-- Generated by Creer at 06:37PM on February 15, 2016 UTC, git hash: '955970b8006ac45cc438822363db1bc1242d9868'
-- This is a simple class to represent the Move object in the game. You can extend it by adding utility functions here in this file.

local class = require("joueur.utilities.class")
local GameObject = require("games.chess.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add addtional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- Contains all details about a Piece's move in the game.
-- @classmod Move
local Move = class(GameObject)

-- initializes a Move with basic logic as provided by the Creer code generator
function Move:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The Piece captured by this Move, null if no capture.
    self.captured = nil
    --- The file the Piece moved from.
    self.fromFile = 0
    --- The rank the Piece moved from.
    self.fromRank = ""
    --- The Piece that was moved.
    self.piece = nil
    --- The Piece type this Move's piece was promoted to from a Pawn, empty string if no promotion occured.
    self.promotion = ""
    --- The standard algebraic notation (SAN) representation of the move.
    self.san = ""
    --- The file the Piece moved to.
    self.toFile = 0
    --- The rank the Piece moved to.
    self.toRank = ""

    --- (inherited) String representing the top level Class that this game object is an instance of. Used for reflection to create new instances on clients, but exposed for convenience should AIs want this data.
    -- @field[string] self.gameObjectName
    -- @see GameObject.gameObjectName

    --- (inherited) A unique id for each instance of a GameObject or a sub class. Used for client and server communication. Should never change value after being set.
    -- @field[string] self.id
    -- @see GameObject.id

    --- (inherited) Any strings logged will be stored here when this game object logs the strings. Intended for debugging.
    -- @field[{string, ...}] self.logs
    -- @see GameObject.logs


end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Move:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic (such as state checking functions) this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Move
