-- Game: The traditional 8x8 chess board with pieces.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
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
    --- Forsyth–Edwards Notation, a notation that describes the game board.
    self.fen = ""
    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- The maximum number of turns before the game will automatically end.
    self.maxTurns = 100
    --- The array-like table of Moves that have occurred, in order.
    self.moves = Table()
    --- All the uncaptured Pieces in the game.
    self.pieces = Table()
    --- List of all the players in the game.
    self.players = Table()
    --- A unique identifier for the game instance that is being played.
    self.session = ""
    --- How many turns until the game ends because no pawn has moved and no Piece has been taken.
    self.turnsToDraw = 0



    self.name = "Chess"

    self._gameObjectClasses = {
        GameObject = require("games.chess.gameObject"),
        Move = require("games.chess.move"),
        Piece = require("games.chess.piece"),
        Player = require("games.chess.player"),
    }
end


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Game
