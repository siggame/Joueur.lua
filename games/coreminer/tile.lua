-- Tile: A Tile in the game that makes up the 2D map grid.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.coreminer.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A Tile in the game that makes up the 2D map grid.
-- @classmod Tile
local Tile = class(GameObject)

-- initializes a Tile with basic logic as provided by the Creer code generator
function Tile:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- An array of Bombs on this Tile.
    self.bombs = Table()
    --- The amount of dirt on this Tile.
    self.dirt = 0
    --- Whether or not the Tile is a base Tile.
    self.isBase = false
    --- Whether or not this Tile is about to fall after this turn.
    self.isFalling = false
    --- Whether or not a hopper is on this Tile.
    self.isHopper = false
    --- Whether or not a ladder is built on this Tile.
    self.isLadder = false
    --- Whether or not a support is built on this Tile.
    self.isSupport = false
    --- An array of the Miners on this Tile.
    self.miners = Table()
    --- The amount of ore on this Tile.
    self.ore = 0
    --- The owner of this Tile, or undefined if owned by no-one.
    self.owner = nil
    --- The amount of shielding on this Tile.
    self.shielding = 0
    --- The Tile to the 'East' of this one (x+1, y). nil if out of bounds of the map.
    self.tileEast = nil
    --- The Tile to the 'North' of this one (x, y-1). nil if out of bounds of the map.
    self.tileNorth = nil
    --- The Tile to the 'South' of this one (x, y+1). nil if out of bounds of the map.
    self.tileSouth = nil
    --- The Tile to the 'West' of this one (x-1, y). nil if out of bounds of the map.
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


--- The valid directions that tiles can be in, "North", "East", "South", or "West"
Tile.directions = Table("North", "East", "South", "West")

--- Gets the neighbors of this Tile
-- @treturns Table(Tile) The neighboring (adjacent) Tiles to this tile
function Tile:getNeighbors()
    local neighbors = Table()
    for i, direction in ipairs(self.directions) do
        local neighbor = self["tile" .. direction]
        if neighbor then
            neighbors:insert(neighbor)
        end
    end
    return neighbors
end

--- Checks if a Tile is pathable to units
-- @treturns bool True if pathable, false otherwise
function Tile:isPathable()
    -- <<-- Creer-Merge: is_pathable_builtin -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
    return self.ore + self.dirt <= 0;
    -- <<-- /Creer-Merge: is_pathable_builtin -->>
end

--- Checks if this Tile has a specific neighboring Tile
-- @tparam Tile tile the tile to check against
-- @treturns bool true if the tile is a neighbor of this Tile, false otherwise
function Tile:hasNeighbor(tile)
    if tile then
        return self.tileNorth == tile or self.tileEast == tile or self.tileSouth == tile or self.tileEast == tile
    else
        return false
    end
end

-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Tile
