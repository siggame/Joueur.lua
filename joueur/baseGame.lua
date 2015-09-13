local class = require("joueur.utilities.class")
local BaseGameObject = require("joueur.baseGameObject")

-- @class BaseGame: the basics of any game, basically state management. Competitiors do not modify
local BaseGame = class()

function BaseGame:init()
    self._gameObjectClasses = {}
end

function BaseGame:getGameObject(id)
    return self.gameObjects[id]
end

return BaseGame
