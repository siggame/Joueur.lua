-- This is a simple class to represent the Player object in the game. You can extend it by adding utility functions here in this file.

local class = require("joueur.utilities.class")
local GameObject = require("games.saloon.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add addtional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A player in this game. Every AI controls one player.
-- @classmod Player
local Player = class(GameObject)

-- initializes a Player with basic logic as provided by the Creer code generator
function Player:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- What type of client this is, e.g. 'Python', 'JavaScript', or some other language. For potential data mining purposes.
    self.clientType = ""
    --- Every Cowboy owned by this Player.
    self.cowboys = Table()
    --- How many enemy Cowboys this player's team has killed.
    self.kills = 0
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
    --- How rowdy their team is. When it gets too high their team takes a collective siesta.
    self.rowdyness = 0
    --- How many times their team has played a piano.
    self.score = 0
    --- 0 when not having a team siesta. When greater than 0 represents how many turns left for the team siesta to complete.
    self.siesta = 0
    --- The amount of time (in ns) remaining for this AI to send commands.
    self.timeRemaining = 0
    --- If the player won the game or not.
    self.won = false
    --- The only 'Yong Gun' Cowboy this player owns, or null if they called in their young gun during their turn.
    self.youngGun = nil

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

--- Sends in the Young Gun to the nearest Tile into the Saloon, and promotes them to a new job.
-- @tparam string job The job you want the Young Gun being brought in to be called in to do, changing their job to it.
-- @treturn Cowboy The Cowboy that was previously a 'Young Gun', and has now been promoted to a different job if successful, null otherwise.
function Player:sendIn(job)
    return (self:_runOnServer("sendIn", {
        job = job,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Player:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic (such as state checking functions) this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Player
