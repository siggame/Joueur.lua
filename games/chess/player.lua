-- Player: A player in this game. Every AI controls one player.

-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.chess.gameObject")

--- A player in this game. Every AI controls one player.
-- @classmod Player
local Player = class(GameObject)

-- initializes a Player with basic logic as provided by the Creer code generator
function Player:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- What type of client this is, e.g. 'Python', 'JavaScript', or some other language. For potential data mining purposes.
    self.clientType = ""
    --- The color (side) of this player. Either 'White' or 'Black', with the 'White' player having the first move.
    self.color = ""
    --- True if this player is currently in check, and must move out of check, false otherwise.
    self.inCheck = false
    --- If the player lost the game or not.
    self.lost = false
    --- If the Player has made their move for the turn. true means they can no longer move a Piece this turn.
    self.madeMove = false
    --- The name of the player.
    self.name = "Anonymous"
    --- This player's opponent in the game.
    self.opponent = nil
    --- All the uncaptured chess Pieces owned by this player.
    self.pieces = Table()
    --- The direction your Pieces must go along the rank axis until they reach the other side.
    self.rankDirection = 0
    --- The reason why the player lost the game.
    self.reasonLost = ""
    --- The reason why the player won the game.
    self.reasonWon = ""
    --- The amount of time (in ns) remaining for this AI to send commands.
    self.timeRemaining = 0
    --- If the player won the game or not.
    self.won = false

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

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Player:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.

return Player
