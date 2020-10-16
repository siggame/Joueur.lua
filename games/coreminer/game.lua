-- Game: Mine resources to obtain more value than your opponent.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- Mine resources to obtain more value than your opponent.
-- @classmod Game
local Game = class(BaseGame)

-- initializes a Game with basic logic as provided by the Creer code generator
function Game:init(...)
    BaseGame.init(self, ...)

    --- The name of this game, "{game_name}".
    -- @field[string] self.name
    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The monetary price of a bomb when bought or sold.
    self.bombPrice = 0
    --- The amount of cargo space taken up by a Bomb.
    self.bombSize = 0
    --- Every Bomb in the game.
    self.bombs = Table()
    --- The monetary price of building materials when bought.
    self.buildingMaterialPrice = 0
    --- The player whose turn it is currently. That player can send commands. Other players cannot.
    self.currentPlayer = nil
    --- The current turn number, starting at 0 for the first player's turn.
    self.currentTurn = 0
    --- The monetary price of dirt when bought or sold.
    self.dirtPrice = 0
    --- The amount of damage taken per Tile fallen.
    self.fallDamage = 0
    --- The amount of extra damage taken for falling while carrying a large amount of cargo.
    self.fallWeightDamage = 0
    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- The amount of building material required to build a ladder.
    self.ladderCost = 0
    --- The amount of mining power needed to remove a ladder from a Tile.
    self.ladderHealth = 0
    --- The amount deemed as a large amount of cargo.
    self.largeCargoSize = 0
    --- The amount deemed as a large amount of material.
    self.largeMaterialSize = 0
    --- The number of Tiles in the map along the y (vertical) axis.
    self.mapHeight = 0
    --- The number of Tiles in the map along the x (horizontal) axis.
    self.mapWidth = 0
    --- The maximum amount of shielding possible on a Tile.
    self.maxShielding = 0
    --- The maximum number of turns before the game will automatically end.
    self.maxTurns = 100
    --- The highest upgrade level allowed on a Miner.
    self.maxUpgradeLevel = 0
    --- Every Miner in the game.
    self.miners = Table()
    --- The amount of money awarded when ore is dumped in the base and sold.
    self.orePrice = 0
    --- The amount of value awarded when ore is dumped in the base and sold.
    self.oreValue = 0
    --- List of all the players in the game.
    self.players = Table()
    --- A unique identifier for the game instance that is being played.
    self.session = ""
    --- The amount of building material required to shield a Tile.
    self.shieldCost = 0
    --- The amount of mining power needed to remove one unit of shielding off a Tile.
    self.shieldHealth = 0
    --- The monetary price of spawning a Miner.
    self.spawnPrice = 0
    --- The amount of damage taken when suffocating inside a filled Tile.
    self.suffocationDamage = 0
    --- The amount of extra damage taken for suffocating under a large amount of material.
    self.suffocationWeightDamage = 0
    --- The amount of building material required to build a support.
    self.supportCost = 0
    --- The amount of mining power needed to remove a support from a Tile.
    self.supportHealth = 0
    --- All the tiles in the map, stored in Row-major order. Use `x + y * mapWidth` to access the correct index.
    self.tiles = Table()
    --- The amount of time (in nano-seconds) added after each player performs a turn.
    self.timeAddedPerTurn = 0
    --- The cost to upgrade a Miner.
    self.upgradePrice = 0
    --- Every Upgrade for a Miner in the game.
    self.upgrades = Table()
    --- The amount of victory points (value) required to win.
    self.victoryAmount = 0



    self.name = "Coreminer"

    self._gameVersion = "ce6c632876295900d0b2fc6db0f63dfc8a20533396c67b472fa03817cb82edc4"
    self._gameObjectClasses = {
        Bomb = require("games.coreminer.bomb"),
        GameObject = require("games.coreminer.gameObject"),
        Miner = require("games.coreminer.miner"),
        Player = require("games.coreminer.player"),
        Tile = require("games.coreminer.tile"),
        Upgrade = require("games.coreminer.upgrade"),
    }
end


--- Gets the Tile at a specified (x, y) position
-- @tparam number x integer between 0 and the mapWidth
-- @tparam number y integer between 0 and the mapHeight
-- @treturns Tile the Tile at (x, y) or nil if out of bounds
function Game:getTileAt(x, y)
    if x < 0 or y < 0 or x >= self.mapWidth or y >= self.mapHeight then -- out of bounds
        return nil;
    end

    return self.tiles[1 + x + y * self.mapWidth] -- 1 + ... because Lua lists are indexed at 1, so we add 1 to indexes, but we don't for the x, y positions
end

-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Game
