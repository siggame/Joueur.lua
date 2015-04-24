local class = require("utilities.class")
local serializer = require("utilities.serializer")
local json = require("utilities.dkjson")
local socket = require("socket")
local EOT_CHAR = string.char(4)

---
-- @class Client: talks to the server recieving game information and sending commands to execute via TCP socket. Clients perform no game logic
local Client = class()

function Client:init(game, ai, host, port)
    self.game = game
    self.ai = ai
    self.host = host or "localhost"
    self.port = port or 3000
    self.running = false

    self.game:setClient(self)
    self.game:setAI(self.ai)

    print("connecting to: " .. self.host .. ":" .. self.port)

    self.socket, message = socket.connect(self.host, self.port)

    if self.socket == nil then
        print("ERROR CONNECTING: ", message)
        os.exit()
    else
        self.socket:settimeout(0)
        self:connected()
    end
end

function Client:connected()
    print("successfully connected to server...")
end

function Client:disconnected()
    print("disconnected from server...")
    self.socket:close()
    os.exit()
end


---
-- called by the main script when the client should be ready to play
function Client:ready(playerName)
    self:sendEvent("play", {
        clientType = "Lua",
        playerName = playerName or self.ai:getName() or "Lua Player",
        gameName = self.game.name,
        gameSession = self.game.session or "*",
    })

    self:run()
end

function Client:run()
    self.running = true

    local buffer = ""
    while self.running do
        local full, status, partial = self.socket:receive(1024)

        if status == "closed" then
            self.running = false
            self:disconnected()
        end

        local sent = full or partial

        if sent ~= "" and sent ~= nil then -- we got something from the server
            buffer = buffer .. sent

            local split = buffer:split(EOT_CHAR) --  split on "end of text" character (basically end of transmition)

            buffer = split:pop() -- the last item will either be "" if the last char was an EOT_CHAR, or a partial data we need to buffer anyways

            for i, jsonStr in ipairs(split) do
                self:onJsonData(jsonStr)
            end
        end
    end
end

function Client:onJsonData(jsonStr)
    local parsed = json.decode(jsonStr, nil, serializer.null)
    self["on" .. parsed.event:capitalize()](self, parsed.data)
end

function Client:sendEvent(event, data)
    self.socket:send(
        json.encode({
            sentTime = math.floor(socket.gettime() * 1000),
            event = event,
            data = data,
        })
        .. EOT_CHAR
    )
end

function Client:sendCommand(caller, command, data)
    data.caller = caller
    data.command = command

    self:sendEvent("command", serializer.serialize(data))
end



-- Socket on data functions --

function Client:onPlaying(data)
    self.game:connected(data)
    self.ai:connected(data)
    print("Connection successful to game '" .. self.game.name .. "' in session '" .. self.game.session .. "'")
end

function Client:onStart(data)
    self.ai:start(data)
end

function Client:onAwaiting()
    self.ai:run()
end

function Client:onIgnoring()
    self.ai.ignoring()
end

function Client:onDelta(delta)
    self.game:applyDeltaState(delta)
end

function Client:onInvalid(data)
    -- TODO: expost to AI to interpret invalid data sent back
    print("sent invalid command data", data)
end

function Client:onOver()
    self.ai:over()
    self:disconnected()
end


return Client
