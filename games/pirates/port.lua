-- Port: A port on a Tile.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.pirates.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A port on a Tile.
-- @classmod Port
local Port = class(GameObject)

-- initializes a Port with basic logic as provided by the Creer code generator
function Port:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- Whether this Port has created a Unit this turn.
    self.cooldown = false
    --- Whether this Port can be destroyed.
    self.destroyable = 0
    --- (Merchants only) How much gold this Port has accumulated. Once this port can afford to create a ship, it will spend gold to construct one.
    self.gold = 0
    --- How much health this Port has.
    self.health = 0
    --- (Merchants only) How much gold this Port accumulates each turn.
    self.investment = 0
    --- The owner of this Port, or nil if owned by merchants.
    self.owner = nil
    --- The Tile this Port is on.
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

--- Spawn a Unit on this port.
-- @tparam string type What type of Unit to create ('crew' or 'ship').
-- @treturn bool True if Unit was created successfully, false otherwise.
function Port:spawn(type)
    return not not (self:_runOnServer("spawn", {
        type = type,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Port:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.



-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Port
