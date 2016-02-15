-- Generated by Creer at 06:37PM on February 15, 2016 UTC, git hash: '955970b8006ac45cc438822363db1bc1242d9868'
-- This is a simple class to represent the Game object in the game. You can extend it by adding utility functions here in this file.

local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add addtional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- The traditional 8x8 chess board with pieces.
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
    --- The maximum number of turns before the game will automatically end.
    self.maxTurns = 100
    ---  The list of Moves that have occured, in order.
    self.moves = Table()
    --- All the uncaptured pieces in the game.
    self.pieces = Table()
    --- List of all the players in the game.
    self.players = Table()
    --- A unique identifier for the game instance that is being played.
    self.session = ""
    --- How many turns until the game ends because no pawn has moved and no piece has been taken.
    self.turnsToDraw = 0



    self.name = "Chess"

    self._gameObjectClasses = {
        Move = require("games.chess.move"),
        GameObject = require("games.chess.gameObject"),
        Player = require("games.chess.player"),
        Piece = require("games.chess.piece"),
    }
end


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic (such as state checking functions) this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Game
