-- Game: Use cowboys to have a good time and play some music on a Piano, while brawling with enemy Cowboys.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

--- Use cowboys to have a good time and play some music on a Piano, while brawling with enemy Cowboys.
-- @classmod Game
local Game = class(BaseGame)

-- initializes a Game with basic logic as provided by the Creer code generator
function Game:init(...)
    BaseGame.init(self, ...)

    --- The name of this game, "{game_name}".
    -- @field[string] self.name
    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- How many turns a Bartender will be busy for after throwing a Bottle.
    self.bartenderCooldown = 0
    --- All the beer Bottles currently flying across the saloon in the game.
    self.bottles = Table()
    --- How much damage is applied to neighboring things bit by the Sharpshooter between turns.
    self.brawlerDamage = 0
    --- Every Cowboy in the game.
    self.cowboys = Table()
    --- The player whose turn it is currently. That player can send commands. Other players cannot.
    self.currentPlayer = nil
    --- The current turn number, starting at 0 for the first player's turn.
    self.currentTurn = 0
    --- Every furnishing in the game.
    self.furnishings = Table()
    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- All the jobs that Cowboys can be called in with.
    self.jobs = Table()
    --- The number of Tiles in the map along the y (vertical) axis.
    self.mapHeight = 0
    --- The number of Tiles in the map along the x (horizontal) axis.
    self.mapWidth = 0
    --- The maximum number of Cowboys a Player can bring into the saloon of each specific job.
    self.maxCowboysPerJob = 0
    --- The maximum number of turns before the game will automatically end.
    self.maxTurns = 100
    --- List of all the players in the game.
    self.players = Table()
    --- When a player's rowdiness reaches or exceeds this number their Cowboys take a collective siesta.
    self.rowdinessToSiesta = 0
    --- A unique identifier for the game instance that is being played.
    self.session = ""
    --- How much damage is applied to things hit by Sharpshooters when they act.
    self.sharpshooterDamage = 0
    --- How long siestas are for a player's team.
    self.siestaLength = 0
    --- All the tiles in the map, stored in Row-major order. Use `x + y * mapWidth` to access the correct index.
    self.tiles = Table()
    --- How many turns a Cowboy will be drunk for if a bottle breaks on it.
    self.turnsDrunk = 0



    self.name = "Saloon"

    self._gameObjectClasses = {
        Bottle = require("games.saloon.bottle"),
        Cowboy = require("games.saloon.cowboy"),
        Furnishing = require("games.saloon.furnishing"),
        GameObject = require("games.saloon.gameObject"),
        Player = require("games.saloon.player"),
        Tile = require("games.saloon.tile"),
        YoungGun = require("games.saloon.youngGun"),
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

return Game
