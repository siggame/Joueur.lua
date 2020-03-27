-- Unit: A unit in the game.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.coreminer.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A unit in the game.
-- @classmod Unit
local Unit = class(GameObject)

-- initializes a Unit with basic logic as provided by the Creer code generator
function Unit:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The number of bombs being carried by this Unit. (0 to job cargo capacity - other carried materials).
    self.bombs = 0
    --- The number of building materials carried by this Unit. (0 to job cargo capacity - other carried materials).
    self.buildingMaterials = 0
    --- The amount of dirt carried by this Unit. (0 to job cargo capacity - other carried materials).
    self.dirt = 0
    --- The remaining health of a Unit.
    self.health = 0
    --- The Job this Unit has.
    self.job = nil
    --- The maximum amount of cargo this Unit can carry.
    self.maxCargoCapacity = 0
    --- The maximum health of this Unit.
    self.maxHealth = 0
    --- The maximum mining power of this Unit.
    self.maxMiningPower = 0
    --- The maximum moves this Unit can have.
    self.maxMoves = 0
    --- The remaining mining power this Unit has this turn.
    self.miningPower = 0
    --- The number of moves this Unit has left this turn.
    self.moves = 0
    --- The amount of ore carried by this Unit. (0 to job capacity - other carried materials).
    self.ore = 0
    --- The Player that owns and can control this Unit.
    self.owner = nil
    --- The Tile this Unit is on.
    self.tile = nil

    --- (inherited) String representing the top level Class that this game object is an instance of. Used for reflection to create new instances on clients, but exposed for convenience should AIs want this data.
    -- @field[string] self.gameObjectName
    -- @see GameObject.gameObjectName

    --- (inherited) A unique id for each instance of a GameObject or a sub class. Used for client and server communication. Should never change value after being set.
    -- @field[string] self.id
    -- @see GameObject.id

    --- (inherited) Any strings logged will be stored here. Intended for debugging.
    -- @field[{string, ...}] self.logs
    -- @see GameObject.logs


end

--- Builds a support, shield, or ladder on Unit's tile, or an adjacent Tile.
-- @tparam Tile tile The Tile to build on.
-- @tparam string type The structure to build (support, ladder, or shield).
-- @treturn bool True if successfully built, False otherwise.
function Unit:build(tile, type)
    return not not (self:_runOnServer("build", {
        tile = tile,
        type = type,
    }))
end

--- Dumps materials from cargo to an adjacent tile.
-- @tparam Tile tile The tile the materials will be dumped on.
-- @tparam string material The material the Unit will drop. 'dirt', 'ore', or 'bomb'.
-- @tparam number amount The number of materials to drop. Amounts <= 0 will drop all the materials.
-- @treturn bool True if successfully dumped materials, false otherwise.
function Unit:dump(tile, material, amount)
    return not not (self:_runOnServer("dump", {
        tile = tile,
        material = material,
        amount = amount,
    }))
end

--- Mines the Tile the Unit is on or an adjacent tile.
-- @tparam Tile tile The Tile the materials will be mined from.
-- @tparam number amount The amount of material to mine up. Amounts <= 0 will mine all the materials that the Unit can.
-- @treturn bool True if successfully mined, false otherwise.
function Unit:mine(tile, amount)
    return not not (self:_runOnServer("mine", {
        tile = tile,
        amount = amount,
    }))
end

--- Moves this Unit from its current Tile to an adjacent Tile.
-- @tparam Tile tile The Tile this Unit should move to.
-- @treturn bool True if it moved, false otherwise.
function Unit:move(tile)
    return not not (self:_runOnServer("move", {
        tile = tile,
    }))
end

--- Upgrade an attribute of this Unit. "health", "miningPower", "moves", or "capacity".
-- @tparam string attribute The attribute of the Unit to be upgraded.
-- @treturn bool True if successfully upgraded, False otherwise.
function Unit:upgrade(attribute)
    return not not (self:_runOnServer("upgrade", {
        attribute = attribute,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Unit:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.



-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Unit
