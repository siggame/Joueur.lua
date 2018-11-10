-- Piece: A chess piece.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.chess.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A chess piece.
-- @classmod Piece
local Piece = class(GameObject)

-- initializes a Piece with basic logic as provided by the Creer code generator
function Piece:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- When the Piece has been captured (removed from the board) this is true. Otherwise false.
    self.captured = false
    --- The file (column) coordinate of the Piece represented as a letter [a-h], with 'a' starting at the left of the board.
    self.file = ""
    --- If the Piece has moved from its starting position.
    self.hasMoved = false
    --- The player that controls this chess Piece.
    self.owner = nil
    --- The rank (row) coordinate of the Piece represented as a number [1-8], with 1 starting at the bottom of the board.
    self.rank = 0
    --- The type of chess Piece this is, either 'King, 'Queen', 'Knight', 'Rook', 'Bishop', or 'Pawn'.
    self.type = ""

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

--- Moves the Piece from its current location to the given rank and file.
-- @tparam string file The file coordinate to move to. Must be [a-h].
-- @tparam number rank The rank coordinate to move to. Must be [1-8].
-- @tparam[opt=""] string promotionType If this is a Pawn moving to the end of the board then this parameter is what to promote it to. When used must be 'Queen', 'Knight', 'Rook', or 'Bishop'.
-- @treturn Move The Move you did if successful, otherwise nil if invalid. In addition if your move was invalid you will lose.
function Piece:move(file, rank, promotionType)
    if promotionType == nil then
        promotionType = ""
    end

    return (self:_runOnServer("move", {
        file = file,
        rank = rank,
        promotionType = promotionType,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Piece:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Piece
