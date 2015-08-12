local serializer = require("utilities.serializer")
local class = require("utilities.class")

-- @class GameManager: manages the games state and does delta merges. Competitiors do not modify
local GameManager = class(deltaMergeable)

function GameManager:init(game)
    self.game = game
end

function GameManager:setConstants(constants)
    self._serverConstants = constants
    self.DELTA_LIST_LENGTH = self._serverConstants.DELTA_ARRAY_LENGTH
    self.DELTA_REMOVED = self._serverConstants.DELTA_REMOVED
end

--- applies a delta state (change in state information) to self game
function GameManager:applyDeltaState(delta)
    if delta.gameObjects then
        self:_initGameObjects(delta.gameObjects)
    end

    self:_mergeDelta(self.game, delta)
end

--- game objects can be refences in the delta states for cycles, they will all point to the game objects here.
function GameManager:_initGameObjects(gameObjects)
    for id, gameObject in pairs(gameObjects) do
        if not self.game.gameObjects[id] then
            self.game.gameObjects[id] = self.game._gameObjectClasses[gameObject.gameObjectName]() -- create new instance of that game object class
        end
    end
end

--- recursively merges delta changes to the game.
function GameManager:_mergeDelta(state, delta)
    local deltaLength = delta[self.DELTA_LIST_LENGTH]

    if deltaLength then -- this part in the state is a list
        delta[self.DELTA_LIST_LENGTH] = nil -- we don't want to copy self key/value over to the state, it was just to signify it is an array
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
        if d == self.DELTA_REMOVED then
            state[key] = nil
        elseif serializer.isGameObjectReference(d) then
            state[key] = self.game:getGameObject(d.id)
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

return GameManager
