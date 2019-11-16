-- Tower: A tower in the game. Used to combat enemy waves.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.necrowar.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A tower in the game. Used to combat enemy waves.
-- @classmod Tower
local Tower = class(GameObject)

-- initializes a Tower with basic logic as provided by the Creer code generator
function Tower:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- Whether this tower has attacked this turn or not.
    self.attacked = false
    --- How many turns are left before it can fire again.
    self.cooldown = 0
    --- How much remaining health this tower has.
    self.health = 0
    --- What type of tower this is (it's job).
    self.job = nil
    --- The player that built / owns this tower.
    self.owner = nil
    --- The Tile this Tower is on.
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

--- Attacks an enemy unit on an tile within it's range.
-- @tparam Tile tile The Tile to attack.
-- @treturn bool True if successfully attacked, false otherwise.
function Tower:attack(tile)
    return not not (self:_runOnServer("attack", {
        tile = tile,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Tower:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.



-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Tower
