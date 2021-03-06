-- GameObject: An object in the game. The most basic class that all game classes should inherit from automatically.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGameObject = require("joueur.baseGameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- An object in the game. The most basic class that all game classes should inherit from automatically.
-- @classmod GameObject
local GameObject = class(BaseGameObject)

-- initializes a GameObject with basic logic as provided by the Creer code generator
function GameObject:init(...)
    BaseGameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- String representing the top level Class that this game object is an instance of. Used for reflection to create new instances on clients, but exposed for convenience should AIs want this data.
    self.gameObjectName = ""
    --- A unique id for each instance of a GameObject or a sub class. Used for client and server communication. Should never change value after being set.
    self.id = ""
    --- Any strings logged will be stored here. Intended for debugging.
    self.logs = Table()


end

--- Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.
function GameObject:log(message)
    return (self:_runOnServer("log", {
        message = message,
    }))
end


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return GameObject
