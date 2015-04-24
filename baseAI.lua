local class = require("utilities.class")

-- @class BaseAI: the base functions all AIs should do
local BaseAI = class()

function BaseAI:init(game)
    self.game = game
end

function BaseAI:start(data)
    self.playerID = data.playerID
    self.playerName = data.playerName
end

function BaseAI:connected(data)
    self._serverConstants = data.constants
end

function BaseAI:connectPlayer()
    self.player = self.game:getGameObject(self.playerID)
end

function BaseAI:gameInitialized()
    -- intended to be overridden by the AI class
end

function BaseAI:gameUpdated()
    -- intended to be overridden by the AI class
end

function BaseAI:run()
    -- intended to be overridden by the AI class
end

function BaseAI:ignoring()
    -- intended to be overridden by the AI class
end

function BaseAI:over()
    -- intended to be overridden by the AI class
end

return BaseAI
