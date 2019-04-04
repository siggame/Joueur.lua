-- Body: A celestial body located within the game.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.stardash.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A celestial body located within the game.
-- @classmod Body
local Body = class(GameObject)

-- initializes a Body with basic logic as provided by the Creer code generator
function Body:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The amount of material the object has, or energy if it is a planet.
    self.amount = 0
    --- The type of celestial body it is.
    self.bodyType = ""
    --- The type of material the celestial body has.
    self.materialType = ""
    --- The Player that owns and can control this Body.
    self.owner = nil
    --- The radius of the circle that this body takes up.
    self.radius = 0
    --- The x value this celestial body is on.
    self.x = 0
    --- The y value this celestial body is on.
    self.y = 0

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

--- The x value of this body a number of turns from now. (0-how many you want).
-- @tparam number num The number of turns in the future you wish to check.
-- @treturn number The x position of the body the input number of turns in the future.
function Body:nextX(num)
    return tonumber(self:_runOnServer("nextX", {
        num = num,
    }))
end

--- The x value of this body a number of turns from now. (0-how many you want).
-- @tparam number num The number of turns in the future you wish to check.
-- @treturn number The x position of the body the input number of turns in the future.
function Body:nextY(num)
    return tonumber(self:_runOnServer("nextY", {
        num = num,
    }))
end

--- Spawn a unit on some value of this celestial body.
-- @tparam number x The x value of the spawned unit.
-- @tparam number y The y value of the spawned unit.
-- @tparam string title The job title of the unit being spawned.
-- @treturn bool True if successfully taken, false otherwise.
function Body:spawn(x, y, title)
    return not not (self:_runOnServer("spawn", {
        x = x,
        y = y,
        title = title,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Body:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Body
