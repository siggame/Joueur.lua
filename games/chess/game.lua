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

    --- Forsyth-Edwards Notation (fen), a notation that describes the game board state.
    self.fen = ""
    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- The array-like table of [known] moves that have occurred in the game, in Standard Algebraic Notation (SAN) format. The first element is the first move, with the last being the most recent.
    self.history = Table()
    --- List of all the players in the game.
    self.players = Table()
    --- A unique identifier for the game instance that is being played.
    self.session = ""



    self.name = "Chess"

    self._gameVersion = "cfa5f5c1685087ce2899229c04c26e39f231e897ecc8fe036b44bc22103ef801"
    self._gameObjectClasses = {
        GameObject = require("games.chess.gameObject"),
        Player = require("games.chess.player"),
    }
end


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Game
