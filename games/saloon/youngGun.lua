-- YoungGun: An eager young person that wants to join your gang, and will call in the veteran Cowboys you need to win the brawl in the saloon.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.saloon.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- An eager young person that wants to join your gang, and will call in the veteran Cowboys you need to win the brawl in the saloon.
-- @classmod YoungGun
local YoungGun = class(GameObject)

-- initializes a YoungGun with basic logic as provided by the Creer code generator
function YoungGun:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The Tile that a Cowboy will be called in on if this YoungGun calls in a Cowboy.
    self.callInTile = nil
    --- True if the YoungGun can call in a Cowboy, false otherwise.
    self.canCallIn = false
    --- The Player that owns and can control this YoungGun.
    self.owner = nil
    --- The Tile this YoungGun is currently on.
    self.tile = nil

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

--- Tells the YoungGun to call in a new Cowboy of the given job to the open Tile nearest to them.
-- @tparam string job The job you want the Cowboy being brought to have.
-- @treturn Cowboy The new Cowboy that was called in if valid. They will not be added to any `cowboys` array-like tables until the turn ends. nil otherwise.
function YoungGun:callIn(job)
    return (self:_runOnServer("callIn", {
        job = job,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function YoungGun:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return YoungGun
