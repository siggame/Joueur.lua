-- This is a simple class to represent the Tile object in the game. You can extend it by adding utility functions here in this file.

local class = require("joueur.utilities.class")
local GameObject = require("games.saloon.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add addtional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A Tile in the game that makes up the 2D map grid.
-- @classmod Tile
local Tile = class(GameObject)

-- initializes a Tile with basic logic as provided by the Creer code generator
function Tile:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The beer Bottle currently flying over this Tile.
    self.bottle = nil
    --- The Cowboy that is on this Tile, or null if empty.
    self.cowboy = nil
    --- The furnishing that is on this Tile, or null if empty.
    self.furnishing = nil
    --- If this Tile is pathable, but has a hazard that damages Cowboys that path through it.
    self.hasHazard = false
    --- If this Tile is a wall of the Saloon, and can never be pathed through.
    self.isWall = false
    --- The Tile to the 'East' of this one (x+1, y). Null if out of bounds of the map.
    self.tileEast = nil
    --- The Tile to the 'North' of this one (x, y-1). Null if out of bounds of the map.
    self.tileNorth = nil
    --- The Tile to the 'South' of this one (x, y+1). Null if out of bounds of the map.
    self.tileSouth = nil
    --- The Tile to the 'West' of this one (x-1, y). Null if out of bounds of the map.
    self.tileWest = nil
    --- The x (horizontal) position of this Tile.
    self.x = 0
    --- The y (vertical) position of this Tile.
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
-- @function Tile:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic (such as state checking functions) this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Tile
