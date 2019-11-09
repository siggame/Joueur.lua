-- Game: Send hordes of the undead at your opponent while defending yourself against theirs to win.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- Send hordes of the undead at your opponent while defending yourself against theirs to win.
-- @classmod Game
local Game = class(BaseGame)

-- initializes a Game with basic logic as provided by the Creer code generator
function Game:init(...)
    BaseGame.init(self, ...)

    --- The name of this game, "{game_name}".
    -- @field[string] self.name
    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The player whose turn it is currently. That player can send commands. Other players cannot.
    self.currentPlayer = nil
    --- The current turn number, starting at 0 for the first player's turn.
    self.currentTurn = 0
    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- The amount of gold income per turn per unit in a mine.
    self.goldIncomePerUnit = 0
    --- The amount of gold income per turn per unit in the island mine.
    self.islandIncomePerUnit = 0
    --- The maximum number of workers that can occupy the mine on the island at a given time.
    self.islandUnitCap = 0
    --- The Amount of gold income per turn per unit fishing on the river side.
    self.manaIncomePerUnit = 0
    --- The number of Tiles in the map along the y (vertical) axis.
    self.mapHeight = 0
    --- The number of Tiles in the map along the x (horizontal) axis.
    self.mapWidth = 0
    --- The maximum number of turns before the game will automatically end.
    self.maxTurns = 100
    --- The maximum number of workers that can occupy a mine at a given time.
    self.mineUnitCap = 0
    --- List of all the players in the game.
    self.players = Table()
    --- The amount of turns it takes between the river changing phases.
    self.riverPhase = 0
    --- A unique identifier for the game instance that is being played.
    self.session = ""
    --- A array-like table of every tower type / job.
    self.tJobs = Table()
    --- All the tiles in the map, stored in Row-major order. Use `x + y * mapWidth` to access the correct index.
    self.tiles = Table()
    --- The amount of time (in nano-seconds) added after each player performs a turn.
    self.timeAddedPerTurn = 0
    --- Every Tower in the game.
    self.towers = Table()
    --- A array-like table of every unit type / job.
    self.uJobs = Table()
    --- Every Unit in the game.
    self.units = Table()



    self.name = "Necrowar"

    self._gameObjectClasses = {
        GameObject = require("games.necrowar.gameObject"),
        Player = require("games.necrowar.player"),
        Tile = require("games.necrowar.tile"),
        Tower = require("games.necrowar.tower"),
        Unit = require("games.necrowar.unit"),
        tJob = require("games.necrowar.tJob"),
        uJob = require("games.necrowar.uJob"),
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
