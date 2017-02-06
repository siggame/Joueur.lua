local class = require("joueur.utilities.class")
local serializer = require("joueur.serializer")
local json = require("joueur.utilities.dkjson")
local socket = require("socket")
local safeCall = require("joueur.safeCall")
local handleError = require("joueur.handleError")
local color = require("joueur.ansiColorCoder")
local EOT_CHAR = string.char(4)

---
-- @class Client: singleton that talks to the server receiving game information and sending commands to execute via TCP socket. Clients perform no game logic
local Client = class()

function Client:init()
    self._timeoutTime = 0 -- sec
    self._receivedBufferSize = 1024
    self._receivedBuffer = ""
    self._eventsStack = Table()
end

function Client:connect(hostname, port, options)
    self.hostname = hostname
    self.port = port
    self._printIO = options.printIO

    print(color.text("cyan") .. "Connecting to: " .. self.hostname .. ":" .. self.port .. color.reset())

    self.socket, message = socket.connect(self.hostname, self.port)

    if self.socket == nil then
        handleError("COULD_NOT_CONNECT", "Could not connect to " .. self.hostname .. ":" .. self.port .. ".", message)
    else
        self.socket:settimeout(self._timeoutTime)
        self.socket:setoption("tcp-nodelay", true) -- disable nagle
        handleError.socket = self.socket
    end
end

function Client:setup(game, ai, gameManager, options)
    self.game = game
    self.ai = ai
    self.gameManager = gameManager
end



function Client:_sendRaw(str)
    if self._printIO then
        print(color.text("magenta") .. "TO SERVER --> " .. str .. color.reset())
    end
    self.socket:send(str)
end

function Client:send(event, data)
    self:_sendRaw(
        json.encode({
            sentTime = math.floor(socket.gettime() * 1000),
            event = event,
            data = serializer.serialize(data),
        })
        .. EOT_CHAR
    )
end

function Client:runOnServer(caller, functionName, args)
    self:send("run", {
        caller = caller,
        functionName = functionName,
        args = args,
    })

    local ranData = self:waitForEvent("ran")

    return serializer.deserialize(ranData, self.game)
end

function Client:play()
    self:waitForEvent(false)
end

function Client:waitForEvent(event)
    while true do
        self:waitForEvents() -- blocks till there is at least one event to handle

        -- we should now have some events to handle
        while #self._eventsStack > 0 do
            local sent = self._eventsStack:pop()
            if sent.event == event then
                return sent.data
            else
                self:_autoHandle(sent.event, sent.data)
            end
        end
    end
end

function Client:waitForEvents()
    if #self._eventsStack > 0 then
        return -- as we already have events to handle, no need to wait for more
    end

    self.socket:settimeout(0)
    while true do -- block until we receive something. using normal socket:settimeout won't allow for keyboard interrupts on some systems
        local full, status, partial = self.socket:receive(self._bufferSize) -- should block for timeout

        local sent = full or partial
        if sent == "" then
            sent = nil
        end

        if status == "closed" and not sent then
            handleError("CANNOT_READ_SOCKET", "Socket closed.")
        end

        if sent then -- we got something from the server
            if self._printIO then
                print(color.text("magenta") .. "FROM SERVER <-- " .. sent .. color.reset())
            end
            local total = self._receivedBuffer .. sent
            local split = total:split(EOT_CHAR) --  split on "end of text" character (basically end of transmission)

            self._receivedBuffer = split:pop() -- the last item will either be "" if the last char was an EOT_CHAR, or a partial data we need to buffer anyways

            for i, jsonStr in ipairs(split:reverse()) do -- reveres so the first item we received is last in the events STACK
                local sent = nil

                safeCall(function()
                    sent = json.decode(jsonStr, nil, serializer.null)
                end, "MALFORMED_JSON", "Error parsing json: '" .. jsonStr .. "'")

                self._eventsStack:insert(sent)
            end

            if #self._eventsStack > 0 then
                return
            end
        end
    end
end



function Client:_autoHandle(event, data)
    local callback = self["_autoHandle" .. event:capitalize()]

    if callback then
        return callback(self, data)
    else
        handleError("UNKNOWN_EVENT_FROM_SERVER", "Cannot auto handle event '" + event + "'")
    end
end

function Client:_autoHandleDelta(delta)
    safeCall(function()
        self.gameManager:applyDeltaState(delta)
    end, "DELTA_MERGE_FAILURE", "Error applying delta state.")

    if self.ai.player then -- the AI is ready for updates
        safeCall(function()
            self.ai:gameUpdated()
        end, "AI_ERRORED", "AI errored in gameUpdate() after delta.")
    end
end

function Client:_autoHandleInvalid(data)
    safeCall(function()
        self.ai:invalid(data.message, data.data)
    end, "AI_ERRORED", "AI errored in invalid().")
end

function Client:_autoHandleFatal(data)
    handleError("FATAL_EVENT", nil, "A fatal error occurred '" .. data.message .. "'.")
end

function Client:_autoHandleOver(data)
    local won = self.ai.player.won
    local reason = won and self.ai.player.reasonWon or self.ai.player.reasonLost

    print(color.text("green") .. "Game is over. " .. (won and "I Won!" or "I Lost :(") .. " because: " .. reason .. color.reset())

    safeCall(function()
        self.ai:ended(won, reason)
    end, "AI_ERRORED", "AI errored in ai:ended(won, reason)")
    self.socket:close()

    if data.message then
        local message = data.message:replace("__HOSTNAME__", self.hostname)
        print(color.text("cyan") .. message .. color.reset())
    end

    os.exit(0)
end

function Client:_autoHandleOrder(data)
    local returned = nil
    safeCall(function()
        returned = self.ai:_doOrder(data.name, serializer.deserialize(data.args, self.game))
    end, "AI_ERRORED", "AI errored when running order '" .. data.name .. "'")

    self:send("finished", {
        orderIndex = data.index,
        returned = returned,
    })
end

return Client() -- creates a new instance, not the class constructor. Client is a singleton object wrapped up in a class
