local class = require("utilities.class")
local serializer = require("utilities.serializer")
local json = require("utilities.dkjson")
local socket = require("socket")
local EOT_CHAR = string.char(4)

---
-- @class Client: talks to the server recieving game information and sending commands to execute via TCP socket. Clients perform no game logic
local Client = class()

function Client:init(game, ai, server, port, requestedSession, options)
    self.game = game
    self.ai = ai
    self.server = server
    self.port = port
    self._requestedSession = requestedSession

    self._printIO = options.printIO
    self._gotInitialState = false

    self._timeoutTime = 0
    self._bufferSize = 1024
    self._isRunning = false

    print("connecting to: " .. self.server .. ":" .. self.port)

    self.socket, message = socket.connect(self.server, self.port)

    if self.socket == nil then
        print("ERROR CONNECTING:", message)
        os.exit()
    else
        self.socket:settimeout(self._timeoutTime)
        self:_connected()
    end
end

function Client:_connected()
    print("successfully connected to server...")
end

function Client:disconnect()
    print("disconnected from server...")
    self.socket:close()
    os.exit()
end

function Client:ready(playerName)
    self:send("play", {
        clientType = "Lua",
        playerName = playerName or self.ai:getName() or "Lua Player",
        gameName = self.game.name,
        gameSession = self._requestedSession,
    })

    self:run()
end

function Client:run()
    self._isRunning = true

    local buffer = ""
    while self._isRunning do
        local full, status, partial = self.socket:receive(self._bufferSize)

        if status == "closed" then
            self._isRunning = false
            self:disconnect()
        end

        local sent = full or partial

        if sent ~= "" and sent ~= nil then -- we got something from the server
            if self._printIO then
                print("FROM SERVER <--", sent)
            end

            buffer = buffer .. sent

            local split = buffer:split(EOT_CHAR) --  split on "end of text" character (basically end of transmition)

            buffer = split:pop() -- the last item will either be "" if the last char was an EOT_CHAR, or a partial data we need to buffer anyways

            for i, jsonStr in ipairs(split) do
                self:_sentData(json.decode(jsonStr, nil, serializer.null)) -- special null because default null -> nil, which deletes the key. We need the key to set things to nil
            end
        end
    end
end

function Client:_sentData(data)
    self["_sent" .. data.event:capitalize()](self, data.data)
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



-- Socket sent data functions --

function Client:_sentLobbied(data)
    self.game:setConstants(data.constants)

    print("Connection successful to game '" .. data.gameName .. "' in session '" .. data.gameSession .. "'")
end

function Client:_sentStart(data)
    self._playerID = data.playerID
end

function Client:_sentRequest(data)
    local response = self.ai:respondTo(data.request, data.args)

    if response == nil then
        print("no response returned to '" .. data.request .. "', erroring out.")
        self:disconnect()
    else
        self:send("response", {
            response = data.request,
            data = response,
        })
    end
end

function Client:_sentDelta(delta)
    self.game:applyDeltaState(delta)

    if not self._gotInitialState then
        self._gotInitialState = true

        self.ai:setPlayer(self.game:getGameObject(self._playerID))
        self.ai:start()
    end

    self.ai:gameUpdated()
end

function Client:_sentInvalid(data)
    self.ai:invalid(data)
    print("sent invalid command data", data, "erroring out")
    self:disconnect()
end

function Client:_sentOver()
    local won = self.ai.player.won
    local reason = won and self.ai.player.reasonWon or self.ai.player.reasonLost

    print("Game is over.", won and "I Won!" or "I Lost :(", "because: " .. reason)

    self.ai:ended(won, reason)
    self:disconnect()
end

return Client
