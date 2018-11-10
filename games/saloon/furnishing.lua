-- Furnishing: An furnishing in the Saloon that must be pathed around, or destroyed.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.saloon.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- An furnishing in the Saloon that must be pathed around, or destroyed.
-- @classmod Furnishing
local Furnishing = class(GameObject)

-- initializes a Furnishing with basic logic as provided by the Creer code generator
function Furnishing:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- How much health this Furnishing currently has.
    self.health = 0
    --- If this Furnishing has been destroyed, and has been removed from the game.
    self.isDestroyed = false
    --- True if this Furnishing is a piano and can be played, False otherwise.
    self.isPiano = false
    --- If this is a piano and a Cowboy is playing it this turn.
    self.isPlaying = false
    --- The Tile that this Furnishing is located on.
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

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Furnishing:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.



-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Furnishing
