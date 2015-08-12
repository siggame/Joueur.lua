local class = require("utilities.class")
local DeltaMergeable = require("deltaMergeable")

-- @class BaseGameObject: the base class that every game object within a game inherit from for Python manipulation that would be redundant via Creer
local BaseGameObject = class(deltaMergeable)

function BaseGameObject:init()
    -- pass
end

function BaseGameObject:_runOnServer(functionName, args)
    return require("client"):runOnServer(self, functionName, args)
end

return BaseGameObject
