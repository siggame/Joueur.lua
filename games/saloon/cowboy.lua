-- This is a simple class to represent the Cowboy object in the game. You can extend it by adding utility functions here in this file.

local class = require("joueur.utilities.class")
local GameObject = require("games.saloon.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add addtional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A person on the map that can move around and interact within the saloon.
-- @classmod Cowboy
local Cowboy = class(GameObject)

-- initializes a Cowboy with basic logic as provided by the Creer code generator
function Cowboy:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- If the Cowboy can be moved this turn via its owner.
    self.canMove = 0
    --- The direction this Cowboy is moving while drunk. Will be 'North', 'East', 'South', or 'West' when drunk; or '' (empty string) when not drunk.
    self.drunkDirection = ""
    --- How much focus this Cowboy has. Different Jobs do different things with their Cowboy's focus.
    self.focus = 0
    --- How much health this Cowboy currently has.
    self.health = 0
    --- If this Cowboy is dead and has been removed from the game.
    self.isDead = false
    --- If this Cowboy is drunk, and will automatically walk.
    self.isDrunk = false
    --- The job that this Cowboy does, and dictates how they fight and interact within the Saloon.
    self.job = ""
    --- The Player that owns and can control this Cowboy.
    self.owner = nil
    --- The Tile that this Cowboy is located on.
    self.tile = nil
    --- How many times this unit has been drunk before taking their siesta and reseting this to 0.
    self.tolerance = 0
    --- How many turns this unit has remaining before it is no longer busy and can `act()` or `play()` again.
    self.turnsBusy = 0

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

--- Does their job's action on a Tile.
-- @tparam Tile tile The Tile you want this Cowboy to act on.
-- @tparam[opt=""] string drunkDirection The direction the bottle will cause drunk cowboys to be in, can be 'North', 'East', 'South', or 'West'.
-- @treturn bool True if the act worked, false otherwise.
function Cowboy:act(tile, drunkDirection)
    if drunkDirection == nil then
        drunkDirection = ""
    end

    return not not (self:_runOnServer("act", {
        tile = tile,
        drunkDirection = drunkDirection,
    }))
end

--- Moves this Cowboy from its current Tile to an adjacent Tile.
-- @tparam Tile tile The Tile you want to move this Cowboy to.
-- @treturn bool True if the move worked, false otherwise.
function Cowboy:move(tile)
    return not not (self:_runOnServer("move", {
        tile = tile,
    }))
end

--- Sits down and plays a piano.
-- @tparam Furnishing piano The Furnishing that is a piano you want to play.
-- @treturn bool True if the play worked, false otherwise.
function Cowboy:play(piano)
    return not not (self:_runOnServer("play", {
        piano = piano,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Cowboy:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic (such as state checking functions) this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Cowboy
