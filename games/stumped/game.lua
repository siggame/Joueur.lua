-- Game: Gather branches and build up your lodge as beavers fight to survive.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- Gather branches and build up your lodge as beavers fight to survive.
-- @classmod Game
local Game = class(BaseGame)

-- initializes a Game with basic logic as provided by the Creer code generator
function Game:init(...)
    BaseGame.init(self, ...)

    --- The name of this game, "{game_name}".
    -- @field[string] self.name
    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- Every Beaver in the game.
    self.beavers = Table()
    --- How many branches a lodge must have to be considered complete.
    self.branchesToCompleteLodge = 0
    --- The player whose turn it is currently. That player can send commands. Other players cannot.
    self.currentPlayer = nil
    --- The current turn number, starting at 0 for the first player's turn.
    self.currentTurn = 0
    --- When a Player has less Beavers than this number, recruiting other Beavers is free.
    self.freeBeaversCount = 0
    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- All the Jobs that Beavers can have in the game.
    self.jobs = Table()
    --- How many lodges must be complete at once to win the game.
    self.lodgesCompleteToWin = 0
    --- The number of Tiles in the map along the y (vertical) axis.
    self.mapHeight = 0
    --- The number of Tiles in the map along the x (horizontal) axis.
    self.mapWidth = 0
    --- The maximum number of turns before the game will automatically end.
    self.maxTurns = 100
    --- List of all the players in the game.
    self.players = Table()
    --- A unique identifier for the game instance that is being played.
    self.session = ""
    --- Every Spawner in the game.
    self.spawner = Table()
    --- All the types of spawners in the game.
    self.spawnerTypes = Table()
    --- All the tiles in the map, stored in Row-major order. Use `x + y * mapWidth` to access the correct index.
    self.tiles = Table()



    self.name = "Stumped"

    self._gameObjectClasses = {
        Beaver = require("games.stumped.beaver"),
        GameObject = require("games.stumped.gameObject"),
        Job = require("games.stumped.job"),
        Player = require("games.stumped.player"),
        Spawner = require("games.stumped.spawner"),
        Tile = require("games.stumped.tile"),
    }
end


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Game
