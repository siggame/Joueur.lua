local serializer = require("utilities.serializer")
local class = require("utilities.class")
local BaseGameObject = require("baseGameObject")
local DeltaMergeable = require("deltaMergeable")

-- @class BaseGame: the basics of any game, basically state management. Competitiors do not modify
local BaseGame = class(deltaMergeable)

function BaseGame:init()
    self._gameObjectClasses = {}
end

function BaseGame:getGameObject(id)
    return self.gameObjects[id]
end

return BaseGame
