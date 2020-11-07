-- Spiderling: A Spider spawned by the BroodMother.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local Spider = require("games.spiders.spider")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A Spider spawned by the BroodMother.
-- @classmod Spiderling
local Spiderling = class(Spider)

-- initializes a Spiderling with basic logic as provided by the Creer code generator
function Spiderling:init(...)
    Spider.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- When empty string this Spiderling is not busy, and can act. Otherwise a string representing what it is busy with, e.g. 'Moving', 'Attacking'.
    self.busy = ""
    --- The Web this Spiderling is using to move. nil if it is not moving.
    self.movingOnWeb = nil
    --- The Nest this Spiderling is moving to. nil if it is not moving.
    self.movingToNest = nil
    --- The number of Spiderlings busy with the same work this Spiderling is doing, speeding up the task.
    self.numberOfCoworkers = 0
    --- How much work needs to be done for this Spiderling to finish being busy. See docs for the Work formula.
    self.workRemaining = 0

    --- (inherited) String representing the top level Class that this game object is an instance of. Used for reflection to create new instances on clients, but exposed for convenience should AIs want this data.
    -- @field[string] self.gameObjectName
    -- @see GameObject.gameObjectName

    --- (inherited) A unique id for each instance of a GameObject or a sub class. Used for client and server communication. Should never change value after being set.
    -- @field[string] self.id
    -- @see GameObject.id

    --- (inherited) If this Spider is dead and has been removed from the game.
    -- @field[bool] self.isDead
    -- @see Spider.isDead

    --- (inherited) Any strings logged will be stored here. Intended for debugging.
    -- @field[{string, ...}] self.logs
    -- @see GameObject.logs

    --- (inherited) The Nest that this Spider is currently on. nil when moving on a Web.
    -- @field[Nest] self.nest
    -- @see Spider.nest

    --- (inherited) The Player that owns this Spider, and can command it.
    -- @field[Player] self.owner
    -- @see Spider.owner


end

--- Attacks another Spiderling.
-- @tparam Spiderling spiderling The Spiderling to attack.
-- @treturn bool True if the attack was successful, false otherwise.
function Spiderling:attack(spiderling)
    return not not (self:_runOnServer("attack", {
        spiderling = spiderling,
    }))
end

--- Starts moving the Spiderling across a Web to another Nest.
-- @tparam Web web The Web you want to move across to the other Nest.
-- @treturn bool True if the move was successful, false otherwise.
function Spiderling:move(web)
    return not not (self:_runOnServer("move", {
        web = web,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Spiderling:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Spiderling
