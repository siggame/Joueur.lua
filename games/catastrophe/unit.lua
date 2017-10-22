-- Unit: A unit in the game.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.catastrophe.gameObject")

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

    --- Whether this Unit has performed its action this turn.
    self.acted = false
    --- The amount of energy this Unit has (from 0.0 to 100.0).
    self.energy = 0
    --- The amount of food this Unit is holding.
    self.food = 0
    --- The Job this Unit was recruited to do.
    self.job = nil
    --- The amount of materials this Unit is holding.
    self.materials = 0
    --- The tile this Unit is moving to. This only applies to neutral fresh humans spawned on the road. Otherwise, the tile this Unit is on.
    self.movementTarget = nil
    --- How many moves this Unit has left this turn.
    self.moves = 0
    --- The Player that owns and can control this Unit, or nil if the Unit is neutral.
    self.owner = nil
    --- The Units in the same squad as this Unit. Units in the same squad attack and defend together.
    self.squad = Table()
    --- Whether this Unit is starving. Starving Units regenerate energy at half the rate they normally would while resting.
    self.starving = false
    --- The Tile this Unit is on.
    self.tile = nil
    --- The number of turns before this Unit dies. This only applies to neutral fresh humans created from combat. Otherwise, 0.
    self.turnsToDie = 0

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

--- Attacks an adjacent Tile. Costs an action for each Unit in this Unit's squad. Units in the squad without an action don't participate in combat. Units in combat cannot move afterwards.
-- @tparam Tile tile The Tile to attack.
-- @treturn bool True if successfully attacked, false otherwise.
function Unit:attack(tile)
    return not not (self:_runOnServer("attack", {
        tile = tile,
    }))
end

--- Changes this Unit's Job. Must be at max energy (100.0) to change Jobs.
-- @tparam string job The name of the Job to change to.
-- @treturn bool True if successfully changed Jobs, false otherwise.
function Unit:changeJob(job)
    return not not (self:_runOnServer("changeJob", {
        job = job,
    }))
end

--- Constructs a Structure on an adjacent Tile.
-- @tparam Tile tile The Tile to construct the Structure on. It must have enough materials on it for a Structure to be constructed.
-- @tparam string type The type of Structure to construct on that Tile.
-- @treturn bool True if successfully constructed a structure, false otherwise.
function Unit:construct(tile, type)
    return not not (self:_runOnServer("construct", {
        tile = tile,
        type = type,
    }))
end

--- Converts an adjacent Unit to your side.
-- @tparam Tile tile The Tile with the Unit to convert.
-- @treturn bool True if successfully converted, false otherwise.
function Unit:convert(tile)
    return not not (self:_runOnServer("convert", {
        tile = tile,
    }))
end

--- Removes materials from an adjacent Tile's Structure. Soldiers do not gain materials from doing this, but can deconstruct friendly Structures as well.
-- @tparam Tile tile The Tile to deconstruct. It must have a Structure on it.
-- @treturn bool True if successfully deconstructed, false otherwise.
function Unit:deconstruct(tile)
    return not not (self:_runOnServer("deconstruct", {
        tile = tile,
    }))
end

--- Drops some of the given resource on or adjacent to the Unit's Tile. Does not count as an action.
-- @tparam Tile tile The Tile to drop materials/food on.
-- @tparam string resource The type of resource to drop ('material' or 'food').
-- @tparam[opt=0] number amount The amount of the resource to drop. Amounts <= 0 will drop as much as possible.
-- @treturn bool True if successfully dropped the resource, false otherwise.
function Unit:drop(tile, resource, amount)
    if amount == nil then
        amount = 0
    end

    return not not (self:_runOnServer("drop", {
        tile = tile,
        resource = resource,
        amount = amount,
    }))
end

--- Harvests the food on an adjacent Tile.
-- @tparam Tile tile The Tile you want to harvest.
-- @treturn bool True if successfully harvested, false otherwise.
function Unit:harvest(tile)
    return not not (self:_runOnServer("harvest", {
        tile = tile,
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

--- Picks up some materials or food on or adjacent to the Unit's Tile. Does not count as an action.
-- @tparam Tile tile The Tile to pickup materials/food from.
-- @tparam string resource The type of resource to pickup ('material' or 'food').
-- @tparam[opt=0] number amount The amount of the resource to pickup. Amounts <= 0 will pickup as much as possible.
-- @treturn bool True if successfully picked up a resource, false otherwise.
function Unit:pickup(tile, resource, amount)
    if amount == nil then
        amount = 0
    end

    return not not (self:_runOnServer("pickup", {
        tile = tile,
        resource = resource,
        amount = amount,
    }))
end

--- Regenerates energy. Must be in range of a friendly shelter to rest. Costs an action. Units cannot move after resting.
-- @treturn bool True if successfully rested, false otherwise.
function Unit:rest()
    return not not (self:_runOnServer("rest", {
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
