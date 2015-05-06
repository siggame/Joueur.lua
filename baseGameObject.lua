local class = require("utilities.class")

-- @class BaseGameObject: the base class that every game object within a game inherit from for Python manipulation that would be redundant via Creer
local BaseGameObject = class()

function BaseGameObject:init(data)
    self._client = data.client
end

function BaseGameObject:_runOnServer(functionName, args)
    return self._client:runOnServer(self, functionName, args)
end

return BaseGameObject
