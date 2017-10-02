-- Game: Convert as many humans to as you can to survive in this post-apocalyptic wasteland.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- Convert as many humans to as you can to survive in this post-apocalyptic wasteland.
-- @classmod Game
local Game = class(BaseGame)

-- initializes a Game with basic logic as provided by the Creer code generator
function Game:init(...)
    BaseGame.init(self, ...)

    --- The name of this game, "{game_name}".
    -- @field[string] self.name
    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The multiplier for the amount of energy regenerated when resting in a base with the cat overlord.
    self.catEnergyMult = 0
    --- The player whose turn it is currently. That player can send commands. Other players cannot.
    self.currentPlayer = nil
    --- The current turn number, starting at 0 for the first player's turn.
    self.currentTurn = 0
    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- All the Jobs that Units can have in the game.
    self.jobs = Table()
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
    --- The multiplier for the amount of energy regenerated when resting while starving.
    self.starvingEnergyMult = 0
    --- Every Structure in the game.
    self.structures = Table()
    --- All the tiles in the map, stored in Row-major order. Use `x + y * mapWidth` to access the correct index.
    self.tiles = Table()
    --- Every Unit in the game.
    self.units = Table()



    self.name = "Catastrophe"

    self._gameObjectClasses = {
        GameObject = require("games.catastrophe.gameObject"),
        Job = require("games.catastrophe.job"),
        Player = require("games.catastrophe.player"),
        Structure = require("games.catastrophe.structure"),
        Tile = require("games.catastrophe.tile"),
        Unit = require("games.catastrophe.unit"),
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
