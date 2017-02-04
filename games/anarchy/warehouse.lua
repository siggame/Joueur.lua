-- Warehouse: A typical abandoned warehouse... that anarchists hang out in and can be bribed to burn down Buildings.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local Building = require("games.anarchy.building")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A typical abandoned warehouse... that anarchists hang out in and can be bribed to burn down Buildings.
-- @classmod Warehouse
local Warehouse = class(Building)

-- initializes a Warehouse with basic logic as provided by the Creer code generator
function Warehouse:init(...)
    Building.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- How exposed the anarchists in this warehouse are to PoliceDepartments. Raises when bribed to ignite buildings, and drops each turn if not bribed.
    self.exposure = 0
    --- The amount of fire added to buildings when bribed to ignite a building. Headquarters add more fire than normal Warehouses.
    self.fireAdded = 0

    --- (inherited) When true this building has already been bribed this turn and cannot be bribed again this turn.
    -- @field[bool] self.bribed
    -- @see Building.bribed

    --- (inherited) The Building directly to the east of this building, or nil if not present.
    -- @field[Building] self.buildingEast
    -- @see Building.buildingEast

    --- (inherited) The Building directly to the north of this building, or nil if not present.
    -- @field[Building] self.buildingNorth
    -- @see Building.buildingNorth

    --- (inherited) The Building directly to the south of this building, or nil if not present.
    -- @field[Building] self.buildingSouth
    -- @see Building.buildingSouth

    --- (inherited) The Building directly to the west of this building, or nil if not present.
    -- @field[Building] self.buildingWest
    -- @see Building.buildingWest

    --- (inherited) How much fire is currently burning the building, and thus how much damage it will take at the end of its owner's turn. 0 means no fire.
    -- @field[number] self.fire
    -- @see Building.fire

    --- (inherited) String representing the top level Class that this game object is an instance of. Used for reflection to create new instances on clients, but exposed for convenience should AIs want this data.
    -- @field[string] self.gameObjectName
    -- @see GameObject.gameObjectName

    --- (inherited) How much health this building currently has. When this reaches 0 the Building has been burned down.
    -- @field[number] self.health
    -- @see Building.health

    --- (inherited) A unique id for each instance of a GameObject or a sub class. Used for client and server communication. Should never change value after being set.
    -- @field[string] self.id
    -- @see GameObject.id

    --- (inherited) True if this is the Headquarters of the owning player, false otherwise. Burning this down wins the game for the other Player.
    -- @field[bool] self.isHeadquarters
    -- @see Building.isHeadquarters

    --- (inherited) Any strings logged will be stored here. Intended for debugging.
    -- @field[{string, ...}] self.logs
    -- @see GameObject.logs

    --- (inherited) The player that owns this building. If it burns down (health reaches 0) that player gets an additional bribe(s).
    -- @field[Player] self.owner
    -- @see Building.owner

    --- (inherited) The location of the Building along the x-axis.
    -- @field[number] self.x
    -- @see Building.x

    --- (inherited) The location of the Building along the y-axis.
    -- @field[number] self.y
    -- @see Building.y


end

--- Bribes the Warehouse to light a Building on fire. This adds this building's fireAdded to their fire, and then this building's exposure is increased based on the Manhatten distance between the two buildings.
-- @tparam Building building The Building you want to light on fire.
-- @treturn number The exposure added to this Building's exposure. -1 is returned if there was an error.
function Warehouse:ignite(building)
    return tonumber(self:_runOnServer("ignite", {
        building = building,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Warehouse:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Warehouse
