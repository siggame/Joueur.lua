-- Building: A basic building. It does nothing besides burn down. Other Buildings inherit from this class.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.anarchy.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A basic building. It does nothing besides burn down. Other Buildings inherit from this class.
-- @classmod Building
local Building = class(GameObject)

-- initializes a Building with basic logic as provided by the Creer code generator
function Building:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- When true this building has already been bribed this turn and cannot be bribed again this turn.
    self.bribed = false
    --- The Building directly to the east of this building, or nil if not present.
    self.buildingEast = nil
    --- The Building directly to the north of this building, or nil if not present.
    self.buildingNorth = nil
    --- The Building directly to the south of this building, or nil if not present.
    self.buildingSouth = nil
    --- The Building directly to the west of this building, or nil if not present.
    self.buildingWest = nil
    --- How much fire is currently burning the building, and thus how much damage it will take at the end of its owner's turn. 0 means no fire.
    self.fire = 0
    --- How much health this building currently has. When this reaches 0 the Building has been burned down.
    self.health = 0
    --- True if this is the Headquarters of the owning player, false otherwise. Burning this down wins the game for the other Player.
    self.isHeadquarters = false
    --- The player that owns this building. If it burns down (health reaches 0) that player gets an additional bribe(s).
    self.owner = nil
    --- The location of the Building along the x-axis.
    self.x = 0
    --- The location of the Building along the y-axis.
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

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Building:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Building
