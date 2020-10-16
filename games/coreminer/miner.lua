-- Miner: A Miner in the game.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.coreminer.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A Miner in the game.
-- @classmod Miner
local Miner = class(GameObject)

-- initializes a Miner with basic logic as provided by the Creer code generator
function Miner:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The number of bombs being carried by this Miner.
    self.bombs = 0
    --- The number of building materials carried by this Miner.
    self.buildingMaterials = 0
    --- The amount of dirt carried by this Miner.
    self.dirt = 0
    --- The remaining health of this Miner.
    self.health = 0
    --- The remaining mining power this Miner has this turn.
    self.miningPower = 0
    --- The number of moves this Miner has left this turn.
    self.moves = 0
    --- The amount of ore carried by this Miner.
    self.ore = 0
    --- The Player that owns and can control this Miner.
    self.owner = nil
    --- The Tile this Miner is on.
    self.tile = nil
    --- The Upgrade this Miner is on.
    self.upgrade = nil
    --- The upgrade level of this Miner. Starts at 0.
    self.upgradeLevel = 0

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

--- Builds a support, shield, or ladder on Miner's Tile, or an adjacent Tile.
-- @tparam Tile tile The Tile to build on.
-- @tparam string type The structure to build (support, ladder, or shield).
-- @treturn bool True if successfully built, False otherwise.
function Miner:build(tile, type)
    return not not (self:_runOnServer("build", {
        tile = tile,
        type = type,
    }))
end

--- Purchase a resource from the Player's base or hopper.
-- @tparam string resource The type of resource to buy.
-- @tparam number amount The amount of resource to buy. Amounts <= 0 will buy all of that material Player can.
-- @treturn bool True if successfully purchased, false otherwise.
function Miner:buy(resource, amount)
    return not not (self:_runOnServer("buy", {
        resource = resource,
        amount = amount,
    }))
end

--- Dumps materials from cargo to an adjacent Tile. If the Tile is a base or a hopper Tile, materials are sold instead of placed.
-- @tparam Tile tile The Tile the materials will be dumped on.
-- @tparam string material The material the Miner will drop. 'dirt', 'ore', or 'bomb'.
-- @tparam number amount The number of materials to drop. Amounts <= 0 will drop all of the material.
-- @treturn bool True if successfully dumped materials, false otherwise.
function Miner:dump(tile, material, amount)
    return not not (self:_runOnServer("dump", {
        tile = tile,
        material = material,
        amount = amount,
    }))
end

--- Mines the Tile the Miner is on or an adjacent Tile.
-- @tparam Tile tile The Tile the materials will be mined from.
-- @tparam number amount The amount of material to mine up. Amounts <= 0 will mine all the materials that the Miner can.
-- @treturn bool True if successfully mined, false otherwise.
function Miner:mine(tile, amount)
    return not not (self:_runOnServer("mine", {
        tile = tile,
        amount = amount,
    }))
end

--- Moves this Miner from its current Tile to an adjacent Tile.
-- @tparam Tile tile The Tile this Miner should move to.
-- @treturn bool True if it moved, false otherwise.
function Miner:move(tile)
    return not not (self:_runOnServer("move", {
        tile = tile,
    }))
end

--- Transfers a resource from the one Miner to another.
-- @tparam Miner miner The Miner to transfer materials to.
-- @tparam string resource The type of resource to transfer.
-- @tparam number amount The amount of resource to transfer. Amounts <= 0 will transfer all the of the material.
-- @treturn bool True if successfully transferred, false otherwise.
function Miner:transfer(miner, resource, amount)
    return not not (self:_runOnServer("transfer", {
        miner = miner,
        resource = resource,
        amount = amount,
    }))
end

--- Upgrade this Miner by installing an upgrade module.
-- @treturn bool True if successfully upgraded, False otherwise.
function Miner:upgrade()
    return not not (self:_runOnServer("upgrade", {
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Miner:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.



-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Miner
