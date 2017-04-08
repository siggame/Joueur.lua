-- Beaver: A beaver in the game.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.stumped.gameObject")



--- A beaver in the game.
-- @classmod Beaver
local Beaver = class(GameObject)

-- initializes a Beaver with basic logic as provided by the Creer code generator
function Beaver:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The number of actions remaining for the Beaver this turn.
    self.actions = 0
    --- The amount of branches this Beaver is holding.
    self.branches = 0
    --- The amount of food this Beaver is holding.
    self.food = 0
    --- How much health this Beaver has left.
    self.health = 0
    --- The Job this Beaver was recruited to do.
    self.job = nil
    --- How many moves this Beaver has left this turn.
    self.moves = 0
    --- The Player that owns and can control this Beaver.
    self.owner = nil
    --- True if the Beaver has finished being recruited and can do things, False otherwise.
    self.recruited = false
    --- The Tile this Beaver is on.
    self.tile = nil
    --- Number of turns this Beaver is distracted for (0 means not distracted).
    self.turnsDistracted = 0

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

--- Attacks another adjacent beaver.
-- @tparam Beaver beaver The Beaver to attack. Must be on an adjacent Tile.
-- @treturn bool True if successfully attacked, false otherwise.
function Beaver:attack(beaver)
    return not not (self:_runOnServer("attack", {
        beaver = beaver,
    }))
end

--- Builds a lodge on the Beavers current Tile.
-- @treturn bool True if successfully built a lodge, false otherwise.
function Beaver:buildLodge()
    return not not (self:_runOnServer("buildLodge", {
    }))
end

--- Drops some of the given resource on the beaver's Tile.
-- @tparam Tile tile The Tile to drop branches/food on. Must be the same Tile that the Beaver is on, or an adjacent one.
-- @tparam string resource The type of resource to drop ('branch' or 'food').
-- @tparam[opt=0] number amount The amount of the resource to drop, numbers <= 0 will drop all the resource type.
-- @treturn bool True if successfully dropped the resource, false otherwise.
function Beaver:drop(tile, resource, amount)
    if amount == nil then
        amount = 0
    end

    return not not (self:_runOnServer("drop", {
        tile = tile,
        resource = resource,
        amount = amount,
    }))
end

--- Harvests the branches or food from a Spawner on an adjacent Tile.
-- @tparam Spawner spawner The Spawner you want to harvest. Must be on an adjacent Tile.
-- @treturn bool True if successfully harvested, false otherwise.
function Beaver:harvest(spawner)
    return not not (self:_runOnServer("harvest", {
        spawner = spawner,
    }))
end

--- Moves this Beaver from its current Tile to an adjacent Tile.
-- @tparam Tile tile The Tile this Beaver should move to.
-- @treturn bool True if the move worked, false otherwise.
function Beaver:move(tile)
    return not not (self:_runOnServer("move", {
        tile = tile,
    }))
end

--- Picks up some branches or food on the beaver's tile.
-- @tparam Tile tile The Tile to pickup branches/food from. Must be the same Tile that the Beaver is on, or an adjacent one.
-- @tparam string resource The type of resource to pickup ('branch' or 'food').
-- @tparam[opt=0] number amount The amount of the resource to drop, numbers <= 0 will pickup all of the resource type.
-- @treturn bool True if successfully picked up a resource, false otherwise.
function Beaver:pickup(tile, resource, amount)
    if amount == nil then
        amount = 0
    end

    return not not (self:_runOnServer("pickup", {
        tile = tile,
        resource = resource,
        amount = amount,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Beaver:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.





return Beaver
