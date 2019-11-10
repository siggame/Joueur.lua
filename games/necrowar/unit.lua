-- Unit: A unit in the game. May be a worker, zombie, ghoul, hound, abomination, wraith or horseman.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.necrowar.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A unit in the game. May be a worker, zombie, ghoul, hound, abomination, wraith or horseman.
-- @classmod Unit
local Unit = class(GameObject)

-- initializes a Unit with basic logic as provided by the Creer code generator
function Unit:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- Whether or not this Unit has performed its action this turn (attack or build).
    self.acted = false
    --- The remaining health of a unit.
    self.health = 0
    --- The type of unit this is.
    self.job = nil
    --- The number of moves this unit has left this turn.
    self.moves = 0
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

--- Attacks an enemy tower on an adjacent tile.
-- @tparam Tile tile The Tile to attack.
-- @treturn bool True if successfully attacked, false otherwise.
function Unit:attack(tile)
    return not not (self:_runOnServer("attack", {
        tile = tile,
    }))
end

--- Unit, if it is a worker, builds a tower on the tile it is on, only workers can do this.
-- @tparam string title The tower type to build, as a string.
-- @treturn bool True if successfully built, false otherwise.
function Unit:build(title)
    return not not (self:_runOnServer("build", {
        title = title,
    }))
end

--- Stops adjacent to a river tile and begins fishing for mana.
-- @tparam Tile tile The tile the unit will stand on as it fishes.
-- @treturn bool True if successfully began fishing for mana, false otherwise.
function Unit:fish(tile)
    return not not (self:_runOnServer("fish", {
        tile = tile,
    }))
end

--- Enters a mine and is put to work gathering resources.
-- @tparam Tile tile The tile the mine is located on.
-- @treturn bool True if successfully entered mine and began mining, false otherwise.
function Unit:mine(tile)
    return not not (self:_runOnServer("mine", {
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

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Unit:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.



-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Unit
