-- Player: A player in this game. Every AI controls one player.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.stumped.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A player in this game. Every AI controls one player.
-- @classmod Player
local Player = class(GameObject)

-- initializes a Player with basic logic as provided by the Creer code generator
function Player:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The array-like table of Beavers owned by this Player.
    self.beavers = Table()
    --- How many branches are required to build a lodge for this player.
    self.branchesToBuildLodge = 0
    --- What type of client this is, e.g. 'Python', 'JavaScript', or some other language. For potential data mining purposes.
    self.clientType = ""
    --- A array-like table of tiles that contain lodges owned by this player.
    self.lodges = Table()
    --- If the player lost the game or not.
    self.lost = false
    --- The name of the player.
    self.name = "Anonymous"
    --- This player's opponent in the game.
    self.opponent = nil
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


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Player
