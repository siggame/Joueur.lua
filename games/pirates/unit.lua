-- Unit: A unit group in the game. This may consist of a ship and any number of crew.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local GameObject = require("games.pirates.gameObject")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- A unit group in the game. This may consist of a ship and any number of crew.
-- @classmod Unit
local Unit = class(GameObject)

-- initializes a Unit with basic logic as provided by the Creer code generator
function Unit:init(...)
    GameObject.init(self, ...)

    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- Whether this Unit has performed its action this turn.
    self.acted = false
    --- How many crew are on this Tile. This number will always be <= crewHealth.
    self.crew = 0
    --- How much total health the crew on this Tile have.
    self.crewHealth = 0
    --- How much gold this Unit is carrying.
    self.gold = 0
    --- How many more times this Unit may move this turn.
    self.moves = 0
    --- The Player that owns and can control this Unit, or nil if the Unit is neutral.
    self.owner = nil
    --- (Merchants only) The path this Unit will follow. The first element is the Tile this Unit will move to next.
    self.path = Table()
    --- If a ship is on this Tile, how much health it has remaining. 0 for no ship.
    self.shipHealth = 0
    --- (Merchants only) The Port this Unit is moving to.
    self.targetPort = nil
    --- The Tile this Unit is on.
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

--- Attacks either crew, a ship, or a port on a Tile in range.
-- @tparam Tile tile The Tile to attack.
-- @tparam string target Whether to attack 'crew', 'ship', or 'port'. Crew deal damage to crew, and ships deal damage to ships and ports. Consumes any remaining moves.
-- @treturn bool True if successfully attacked, false otherwise.
function Unit:attack(tile, target)
    return not not (self:_runOnServer("attack", {
        tile = tile,
        target = target,
    }))
end

--- Builds a Port on the given Tile.
-- @tparam Tile tile The Tile to build the Port on.
-- @treturn bool True if successfully constructed a Port, false otherwise.
function Unit:build(tile)
    return not not (self:_runOnServer("build", {
        tile = tile,
    }))
end

--- Buries gold on this Unit's Tile.
-- @tparam number amount How much gold this Unit should bury.
-- @treturn bool True if successfully buried, false otherwise.
function Unit:bury(amount)
    return not not (self:_runOnServer("bury", {
        amount = amount,
    }))
end

--- Puts gold into an adjacent Port. If that Port is the Player's main port, the gold is added to that Player. If that Port is owned by merchants, adds to the investment.
-- @tparam[opt=0] number amount The amount of gold to deposit. Amounts <= 0 will deposit all the gold on this Unit.
-- @treturn bool True if successfully deposited, false otherwise.
function Unit:deposit(amount)
    if amount == nil then
        amount = 0
    end

    return not not (self:_runOnServer("deposit", {
        amount = amount,
    }))
end

--- Digs up gold on this Unit's Tile.
-- @tparam[opt=0] number amount How much gold this Unit should take. Amounts <= 0 will dig up as much as possible.
-- @treturn bool True if successfully dug up, false otherwise.
function Unit:dig(amount)
    if amount == nil then
        amount = 0
    end

    return not not (self:_runOnServer("dig", {
        amount = amount,
    }))
end

--- Moves this Unit from its current Tile to an adjacent Tile.
-- @tparam Tile tile The Tile this Unit should move to.
-- @treturn bool True if it moved, false otherwise.
function Unit:move(tile)
    return not not (self:_runOnServer("move", {
        tile = tile,
    }))
end

--- Regenerates this Unit's health. Must be used in range of a port.
-- @tparam Tile tile The Tile to move the crew to.
-- @tparam[opt=1] number amount The number of crew to move onto that Tile. Amount <= 0 will move all the crew to that Tile.
-- @treturn bool True if successfully split, false otherwise.
function Unit:rest(tile, amount)
    if amount == nil then
        amount = 1
    end

    return not not (self:_runOnServer("rest", {
        tile = tile,
        amount = amount,
    }))
end

--- Moves a number of crew from this Unit to the given Tile. This will consume a move from those crew.
-- @tparam Tile tile The Tile to move the crew to.
-- @tparam[opt=1] number amount The number of crew to move onto that Tile. Amount <= 0 will move all the crew to that Tile.
-- @tparam[opt=0] number gold The amount of gold the crew should take with them. Gold < 0 will move all the gold to that Tile.
-- @treturn bool True if successfully split, false otherwise.
function Unit:split(tile, amount, gold)
    if amount == nil then
        amount = 1
    end

    if gold == nil then
        gold = 0
    end

    return not not (self:_runOnServer("split", {
        tile = tile,
        amount = amount,
        gold = gold,
    }))
end

--- Takes gold from the Player. You can only withdraw from your main port.
-- @tparam[opt=0] number amount The amount of gold to withdraw. Amounts <= 0 will withdraw everything.
-- @treturn bool True if successfully withdrawn, false otherwise.
function Unit:withdraw(amount)
    if amount == nil then
        amount = 0
    end

    return not not (self:_runOnServer("withdraw", {
        amount = amount,
    }))
end

--- (inherited) Adds a message to this GameObject's logs. Intended for your own debugging purposes, as strings stored here are saved in the gamelog.
-- @function Unit:log
-- @see GameObject:log
-- @tparam string message A string to add to this GameObject's log. Intended for debugging.



-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Unit
