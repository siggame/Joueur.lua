-- Tile: A Tile in the game that makes up the 2D map grid.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.necrowar.gameObject")

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

    --- The amount of corpses on this tile.
    self.corpses = 0
    --- Whether or not the tile is a castle tile.
    self.isCastle = false
    --- Whether or not the tile is considered to be a gold mine or not.
    self.isGoldMine = false
    --- Whether or not the tile is considered grass or not (Workers can walk on grass).
    self.isGrass = false
    --- Whether or not the tile is considered to be the island gold mine or not.
    self.isIslandGoldMine = false
    --- Whether or not the tile is considered a path or not (Units can walk on paths).
    self.isPath = false
    --- Whether or not the tile is considered a river or not.
    self.isRiver = false
    --- Whether or not the tile is considered a tower or not.
    self.isTower = false
    --- Whether or not the tile is the unit spawn.
    self.isUnitSpawn = false
    --- Whether or not the tile can be moved on by workers.
    self.isWall = false
    --- Whether or not the tile is the worker spawn.
    self.isWorkerSpawn = false
    --- The amount of Ghouls on this tile.
    self.numGhouls = 0
    --- The amount of Hounds on this tile.
    self.numHounds = 0
    --- The amount of Zombies on this tile.
    self.numZombies = 0
    --- Which player owns this tile, only applies to grass tiles for workers, NULL otherwise.
    self.owner = nil
    --- The Tile to the 'East' of this one (x+1, y). nil if out of bounds of the map.
    self.tileEast = nil
    --- The Tile to the 'North' of this one (x, y-1). nil if out of bounds of the map.
    self.tileNorth = nil
    --- The Tile to the 'South' of this one (x, y+1). nil if out of bounds of the map.
    self.tileSouth = nil
    --- The Tile to the 'West' of this one (x-1, y). nil if out of bounds of the map.
    self.tileWest = nil
    --- The Tower on this Tile if present, otherwise nil.
    self.tower = nil
    --- The Unit on this Tile if present, otherwise nil.
    self.unit = nil
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

--- Resurrect the corpses on this tile into Zombies.
-- @tparam number num Number of zombies to resurrect.
-- @treturn bool True if successful res, false otherwise.
function Tile:res(num)
    return not not (self:_runOnServer("res", {
        num = num,
    }))
end

--- Spawns a fighting unit on the correct tile.
-- @tparam string title The title of the desired unit type.
-- @treturn bool True if successfully spawned, false otherwise.
function Tile:spawnUnit(title)
    return not not (self:_runOnServer("spawnUnit", {
        title = title,
    }))
end

--- Spawns a worker on the correct tile.
-- @treturn bool True if successfully spawned, false otherwise.
function Tile:spawnWorker()
    return not not (self:_runOnServer("spawnWorker", {
    }))
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
    return false -- DEVELOPER ADD LOGIC HERE
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

function Tile:isPathableWorker()
    -- Change this if you wish to
    return not (self.is_river or self.is_unit_spawn or self.is_wall or self.unit != None);


-- <<-- /Creer-Merge: functions -->>

return Tile
