-- Beaver: A beaver in the game.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.stumped.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A beaver in the game.
-- @classmod Beaver
local Beaver = class(GameObject)

-- initializes a Beaver with basic logic as provided by the Creer code generator
function Beaver:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The number of actions remaining for the beaver this turn.
    self.actions = 0
    --- The number of branches this beaver is holding.
    self.branches = 0
    --- The number of fish this beaver is holding.
    self.fish = 0
    --- How much health this beaver has left.
    self.health = 0
    --- The Job this beaver was recruited to do.
    self.job = nil
    --- How many moves this beaver has left this turn.
    self.moves = 0
    --- The Player that owns and can control this beaver.
    self.owner = nil
    --- True if the Beaver has finished being recruited and can do things, False otherwise.
    self.recruited = false
    --- The tile this beaver is on.
    self.tile = nil
    --- Number of turns this beaver is distracted for (0 means not distracted).
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
-- @tparam Beaver beaver The beaver to attack. Must be on an adjacent tile.
-- @treturn bool True if successfully attacked, false otherwise.
function Beaver:attack(beaver)
    return not not (self:_runOnServer("attack", {
        beaver = beaver,
    }))
end

--- Builds a lodge on the Beavers current tile.
-- @treturn bool True if successfully built a lodge, false otherwise.
function Beaver:buildLodge()
    return not not (self:_runOnServer("buildLodge", {
    }))
end

--- Drops some of the given resource on the beaver's tile. Fish dropped in water disappear instantly, and fish dropped on land die one per tile per turn.
-- @tparam Tile tile The Tile to drop branches/fish on. Must be the same Tile that the Beaver is on, or an adjacent one.
-- @tparam string resource The type of resource to drop ('branch' or 'fish').
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

--- Harvests the branches or fish from a Spawner on an adjacent tile.
-- @tparam Spawner spawner The Spawner you want to harvest. Must be on an adjacent tile.
-- @treturn bool True if successfully harvested, false otherwise.
function Beaver:harvest(spawner)
    return not not (self:_runOnServer("harvest", {
        spawner = spawner,
    }))
end

--- Moves this beaver from its current tile to an adjacent tile.
-- @tparam Tile tile The tile this beaver should move to.
-- @treturn bool True if the move worked, false otherwise.
function Beaver:move(tile)
    return not not (self:_runOnServer("move", {
        tile = tile,
    }))
end

--- Picks up some branches or fish on the beaver's tile.
-- @tparam Tile tile The Tile to pickup branches/fish from. Must be the same Tile that the Beaver is on, or an adjacent one.
-- @tparam string resource The type of resource to pickup ('branch' or 'fish').
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


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Beaver
