-- Game: A 7x9 board game with pieces, to win the game the players must make successful captures of the enemy and reach the opponents den.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A 7x9 board game with pieces, to win the game the players must make successful captures of the enemy and reach the opponents den.
-- @classmod Game
local Game = class(BaseGame)

-- initializes a Game with basic logic as provided by the Creer code generator
function Game:init(...)
    BaseGame.init(self, ...)

    --- The name of this game, "{game_name}".
    -- @field[string] self.name
    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- The array-like table of [known] moves that have occurred in the game, in a format. The first element is the first move, with the last element being the most recent.
    self.history = Table()
    --- The jungleFen is similar to the chess FEN, the order looks like this, board (split into rows by '/'), whose turn it is, half move, and full move.
    self.jungleFen = ""
    --- List of all the players in the game.
    self.players = Table()
    --- A unique identifier for the game instance that is being played.
    self.session = ""



    self.name = "JungleChess"

    self._gameVersion = "0f0b85b33f03a669a391b36c90daa195d028dd1f21f8d4b601adfcf39b23eee2"
    self._gameObjectClasses = {
        GameObject = require("games.jungleChess.gameObject"),
        Player = require("games.jungleChess.player"),
    }
end


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Game
