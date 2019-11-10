-- UnitJob: Information about a unit's job/type.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.necrowar.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- Information about a unit's job/type.
-- @classmod UnitJob
local UnitJob = class(GameObject)

-- initializes a UnitJob with basic logic as provided by the Creer code generator
function UnitJob:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The amount of damage this type does per attack.
    self.damage = 0
    --- How much does this type cost in gold.
    self.goldCost = 0
    --- The amount of starting health this type has.
    self.health = 0
    --- How much does this type cost in mana.
    self.manaCost = 0
    --- The number of moves this type can make per turn.
    self.moves = 0
    --- How many of this type of unit can take up one tile.
    self.perTile = 0
    --- Amount of tiles away this type has to be in order to be effective.
    self.range = 0
    --- The type title. 'worker', 'zombie', 'ghoul', 'hound', 'abomination', 'wraith' or 'horseman'.
    self.title = ""

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

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function UnitJob:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.



-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return UnitJob
