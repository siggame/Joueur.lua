-- Unit: A unit in the game. May be a corvette, missleboat, martyr, transport, miner.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.stardash.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A unit in the game. May be a corvette, missleboat, martyr, transport, miner.
-- @classmod Unit
local Unit = class(GameObject)

-- initializes a Unit with basic logic as provided by the Creer code generator
function Unit:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- Whether or not this Unit has performed its action this turn.
    self.acted = false
    --- The remaining health of a unit.
    self.energy = 0
    --- The amount of Generium ore carried by this unit. (0 to job carry capacity - other carried items).
    self.genarium = 0
    --- Tracks wheither or not the ship is dashing.
    self.isDashing = false
    --- The Job this Unit has.
    self.job = nil
    --- The amount of Legendarium ore carried by this unit. (0 to job carry capacity - other carried items).
    self.legendarium = 0
    --- The distance this unit can still move.
    self.moves = 0
    --- The amount of Mythicite carried by this unit. (0 to job carry capacity - other carried items).
    self.mythicite = 0
    --- The Player that owns and can control this Unit.
    self.owner = nil
    --- The martyr ship that is currently shielding this ship if any.
    self.protector = nil
    --- The radius of the circle this unit occupies.
    self.radius = 0
    --- The amount of Rarium carried by this unit. (0 to job carry capacity - other carried items).
    self.rarium = 0
    --- The x value this unit is on.
    self.x = 0
    --- The y value this unit is on.
    self.y = 0

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

--- Attacks the specified unit.
-- @tparam Unit enemy The Unit being attacked.
-- @treturn bool True if successfully attacked, false otherwise.
function Unit:attack(enemy)
    return not not (self:_runOnServer("attack", {
        enemy = enemy,
    }))
end

--- allows a miner to mine a asteroid
-- @tparam Body body The object to be mined.
-- @treturn bool True if successfully acted, false otherwise.
function Unit:mine(body)
    return not not (self:_runOnServer("mine", {
        body = body,
    }))
end

--- Moves this Unit from its current location to the new location specified.
-- @tparam number x The x value of the destination's coordinates.
-- @tparam number y The y value of the destination's coordinates.
-- @treturn bool True if it moved, false otherwise.
function Unit:move(x, y)
    return not not (self:_runOnServer("move", {
        x = x,
        y = y,
    }))
end

--- tells you if your ship can be at that location.
-- @tparam number x The x position of the location you wish to check.
-- @tparam number y The y position of the location you wish to check.
-- @treturn bool True if pathable by this unit, false otherwise.
function Unit:open(x, y)
    return not not (self:_runOnServer("open", {
        x = x,
        y = y,
    }))
end

--- Attacks the specified projectile.
-- @tparam Projectile missile The projectile being shot down.
-- @treturn bool True if successfully attacked, false otherwise.
function Unit:shootDown(missile)
    return not not (self:_runOnServer("shootDown", {
        missile = missile,
    }))
end

--- Grab materials from a friendly unit. Doesn't use a action.
-- @tparam Unit unit The unit you are grabbing the resources from.
-- @tparam number amount The amount of materials to you with to grab. Amounts <= 0 will pick up all the materials that the unit can.
-- @tparam string material The material the unit will pick up. 'resource1', 'resource2', or 'resource3'.
-- @treturn bool True if successfully taken, false otherwise.
function Unit:transfer(unit, amount, material)
    return not not (self:_runOnServer("transfer", {
        unit = unit,
        amount = amount,
        material = material,
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
