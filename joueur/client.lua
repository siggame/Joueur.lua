local class = require("joueur.utilities.class")
local serializer = require("joueur.serializer")
local json = require("joueur.utilities.dkjson")
local socket = require("socket")
local safeCall = require("joueur.safeCall")
local handleError = require("joueur.handleError")
local EOT_CHAR = string.char(4)

---
-- @class Client: singleton that talks to the server recieving game information and sending commands to execute via TCP socket. Clients perform no game logic
local Client = class()

function Client:init()
    self._timeoutTime = 0 -- sec
    self._receivedBufferSize = 1024
    self._receivedBuffer = ""
    self._eventsStack = Table()
end

function Client:setup(game, ai, gameManager, server, port, options)
    self.game = game
    self.ai = ai
    self.gameManager = gameManager
    self.server = server
    self.port = port
    self._printIO = options.printIO

    print("connecting to: " .. self.server .. ":" .. self.port)

    self.socket, message = socket.connect(self.server, self.port)

    if self.socket == nil then
        handleError("COULD_NOT_CONNECT", "Could not connect to " .. self.server .. ":" .. self.port .. ".", message)
    else
        self.socket:settimeout(self._timeoutTime)
        handleError.socket = self.socket
        print("successfully connected to server...")
    end
end



function Client:_sendRaw(str)
    if self._printIO then
        print("TO SERVER -->", str)
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
    while true do -- block until we recieve something. using normal socket:settimeout won't allow for keyboard interupts on some systems
        local full, status, partial = self.socket:receive(self._bufferSize) -- should block for timeout

        if status == "closed" then
            handleError("CANNOT_READ_SOCKET", "Socket closed.")
        end

        local sent = full or partial

        if sent ~= "" and sent ~= nil then -- we got something from the server
            if self._printIO then
                print("FROM SERVER <--", sent)
            end

            local total = self._receivedBuffer .. sent
            local split = total:split(EOT_CHAR) --  split on "end of text" character (basically end of transmition)

            self._receivedBuffer = split:pop() -- the last item will either be "" if the last char was an EOT_CHAR, or a partial data we need to buffer anyways

            for i, jsonStr in ipairs(split:reverse()) do -- reveres so the first item we recieved is last in the events STACK
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
    handleError("FATAL_EVENT", nil, "A fatal error occured '" .. data.message .. "'.")
end

function Client:_autoHandleOver(data)
    local won = self.ai.player.won
    local reason = won and self.ai.player.reasonWon or self.ai.player.reasonLost

    print("Game is over.", won and "I Won!" or "I Lost :(", "because: " .. reason)

    safeCall(function()
        self.ai:ended(won, reason)
    end, "AI_ERRORED", "AI errored in ai:ended(won, reason)")
    self.socket:close()

    if data.message then
        print(data.message)
    end

    os.exit(0)
end

function Client:_autoHandleOrder(data)
    local returned = nil
    safeCall(function()
        returned = self.ai:_doOrder(data.name, data.args)
    end, "AI_ERRORED", "AI errored when running order '" .. data.name .. "'")

    self:send("finished", {
        orderIndex = data.index,
        returned = returned,
    })
end

return Client() -- creates a new instance, not the class constructor. Client is a singleton object wrapped up in a class
