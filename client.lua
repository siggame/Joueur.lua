local class = require("utilities.class")
local serializer = require("utilities.serializer")
local json = require("utilities.dkjson")
local socket = require("socket")
local inspect = require("utilities.inspect")
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
        print("ERROR CONNECTING:", message)
        os.exit()
    else
        self.socket:settimeout(self._timeoutTime)
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

function Client:disconnect(errorType)
    print("disconnecting from server...")
    self.socket:close()
    os.exit(errorType and 1 or 0)
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
            self:disconnect("closed")
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
                local sent = json.decode(jsonStr, nil, serializer.null)
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
        print("Error: cannot auto handle event", event)
        self:disconnect("unhandled")
    end
end

function Client:_autoHandleDelta(delta)
    self.gameManager:applyDeltaState(delta)

    if self.ai.player then -- the AI is ready for updates
        self.ai:gameUpdated()
    end
end

function Client:_autoHandleInvalid(data)
    self.ai:invalid(data)
    print("sent invalid command data", inspect(data), "erroring out")
    self:disconnect("invalid")
end

function Client:_autoHandleOver()
    local won = self.ai.player.won
    local reason = won and self.ai.player.reasonWon or self.ai.player.reasonLost

    print("Game is over.", won and "I Won!" or "I Lost :(", "because: " .. reason)

    self.ai:ended(won, reason)
    self:disconnect()
end

return Client() -- and instnace, not the class. Client is a singleton object wrapped up in a class
