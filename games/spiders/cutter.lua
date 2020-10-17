-- Cutter: A Spiderling that can cut existing Webs.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local Spiderling = require("games.spiders.spiderling")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A Spiderling that can cut existing Webs.
-- @classmod Cutter
local Cutter = class(Spiderling)

-- initializes a Cutter with basic logic as provided by the Creer code generator
function Cutter:init(...)
    Spiderling.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The Web that this Cutter is trying to cut. nil if not cutting.
    self.cuttingWeb = nil

    --- (inherited) When empty string this Spiderling is not busy, and can act. Otherwise a string representing what it is busy with, e.g. 'Moving', 'Attacking'.
    -- @field[string] self.busy
    -- @see Spiderling.busy

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

    --- (inherited) The Web this Spiderling is using to move. nil if it is not moving.
    -- @field[Web] self.movingOnWeb
    -- @see Spiderling.movingOnWeb

    --- (inherited) The Nest this Spiderling is moving to. nil if it is not moving.
    -- @field[Nest] self.movingToNest
    -- @see Spiderling.movingToNest

    --- (inherited) The Nest that this Spider is currently on. nil when moving on a Web.
    -- @field[Nest] self.nest
    -- @see Spider.nest

    --- (inherited) The number of Spiderlings busy with the same work this Spiderling is doing, speeding up the task.
    -- @field[number] self.numberOfCoworkers
    -- @see Spiderling.numberOfCoworkers

    --- (inherited) The Player that owns this Spider, and can command it.
    -- @field[Player] self.owner
    -- @see Spider.owner

    --- (inherited) How much work needs to be done for this Spiderling to finish being busy. See docs for the Work formula.
    -- @field[number] self.workRemaining
    -- @see Spiderling.workRemaining


end

--- Cuts a web, destroying it, and any Spiderlings on it.
-- @tparam Web web The web you want to Cut. Must be connected to the Nest this Cutter is currently on.
-- @treturn bool True if the cut was successfully started, false otherwise.
function Cutter:cut(web)
    return not not (self:_runOnServer("cut", {
        web = web,
    }))
end

--- (inherited) Attacks another Spiderling.
-- @function Cutter:attack
-- @see Spiderling:attack
-- @tparam Spiderling spiderling The Spiderling to attack.
-- @treturn bool True if the attack was successful, false otherwise.

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Cutter:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.

--- (inherited) Starts moving the Spiderling across a Web to another Nest.
-- @function Cutter:move
-- @see Spiderling:move
-- @tparam Web web The Web you want to move across to the other Nest.
-- @treturn bool True if the move was successful, false otherwise.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Cutter
