-- Machine: A machine on a tile.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.newtonian.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A machine on a tile.
-- @classmod Machine
local Machine = class(GameObject)

-- initializes a Machine with basic logic as provided by the Creer code generator
function Machine:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The amount of ore that is in the machine. Cannot be higher than the refineInput value.
    self.input = 0
    --- What type of ore the machine takes it, also determins the type of material it outputs.
    self.oreType = ""
    --- The amount of material that is waiting to be collected in the machine.
    self.output = 0
    --- The amount of ore that needs to be inputted into the machine.
    self.refineInput = 0
    --- The amount of material that out of the machine after running.
    self.refineOutput = 0
    --- The amount of turns this machine takes to refine the ore.
    self.refineTime = 0
    --- The Tile this Machine is on.
    self.tile = nil
    --- Time till the machine finishes running.
    self.timeLeft = 0
    --- Tracks how many times this machine has been worked.
    self.worked = 0

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
-- @function Machine:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.



-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Machine
