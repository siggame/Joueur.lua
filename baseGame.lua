local serializer = require("utilities.serializer")
local class = require("utilities.class")
local BaseGameObject = require("baseGameObject")

-- @class BaseGame: the basics of any game, basically state management. Competitiors do not modify
local BaseGame = class()

function BaseGame:init()
    self._gameObjectClasses = {}
 end

function BaseGame:setConstants(constants)
    self._serverConstants = constants
end

-- @returns BaseGameObject with the given id
function BaseGame:getGameObject(id)
    return self.gameObjects[id]
end

--- applies a delta state (change in state information) to self game
function BaseGame:applyDeltaState(delta)
    if delta.gameObjects then
        self:_initGameObjects(delta.gameObjects)
    end

    self:_mergeDelta(self, delta)
end

--- game objects can be refences in the delta states for cycles, they will all point to the game objects here.
function BaseGame:_initGameObjects(gameObjects)
    for id, gameObject in pairs(gameObjects) do
        if not self.gameObjects[id] then
            self.gameObjects[id] = self._gameObjectClasses[gameObject.gameObjectName]()
        end
    end
end

--- recursively merges delta changes to the game.
function BaseGame:_mergeDelta(state, delta)
    local deltaLength = delta[self._serverConstants.DELTA_ARRAY_LENGTH]

    if deltaLength then -- this part in the state is an array
        delta[self._serverConstants.DELTA_ARRAY_LENGTH] = nil -- we don't want to copy self key/value over to the state, it was just to signify it is an array
        while #state > deltaLength do -- pop elements off the array until the array is short enough. an increase in array size will be added below as arrays resize when keys larger are set
            table.pop(state)
        end

        -- arrays in lua start at 1 instead of 0 like in Javascript, so act like the delta sent starts at 1 too by increasing all key values by 1
        local list = Table()
        for key, value in pairs(delta) do
            list[tonumber(key) + 1] = value
        end

        delta = list
    end

    for key, d in pairs(delta) do
        if d == self._serverConstants.DELTA_REMOVED then
            state[key] = nil
        elseif serializer.isGameObjectReference(d) then
            state[key] = self:getGameObject(d.id)
        elseif type(d) == "table" and type(state[key]) == "table" then -- both are non GameObject objects, so move recursivly into it for delta merging
            self:_mergeDelta(state[key], d)
        else
            if state[key] == nil and type(d) == "table" then -- we are creating an object that is NOT a game object reference (as checked above), so make the table and then merge into it
                state[key] = self:_mergeDelta(Table(), d)
            else -- it is some other primitive value (number, string, boolean)
                if d == serializer.null then
                    d = nil
                end
                state[key] = d
            end
        end
    end

    return state
end

return BaseGame
