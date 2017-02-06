-- Move: Contains all details about a Piece's move in the game.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.chess.gameObject")

--- Contains all details about a Piece's move in the game.
-- @classmod Move
local Move = class(GameObject)

-- initializes a Move with basic logic as provided by the Creer code generator
function Move:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The Piece captured by this Move, nil if no capture.
    self.captured = nil
    --- The file the Piece moved from.
    self.fromFile = ""
    --- The rank the Piece moved from.
    self.fromRank = 0
    --- The Piece that was moved.
    self.piece = nil
    --- The Piece type this Move's Piece was promoted to from a Pawn, empty string if no promotion occurred.
    self.promotion = ""
    --- The standard algebraic notation (SAN) representation of the move.
    self.san = ""
    --- The file the Piece moved to.
    self.toFile = ""
    --- The rank the Piece moved to.
    self.toRank = 0

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
-- @function Move:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.

return Move
