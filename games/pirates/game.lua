-- Game: Steal from merchants and become the most infamous pirate.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- Steal from merchants and become the most infamous pirate.
-- @classmod Game
local Game = class(BaseGame)

-- initializes a Game with basic logic as provided by the Creer code generator
function Game:init(...)
    BaseGame.init(self, ...)

    --- The name of this game, "{game_name}".
    -- @field[string] self.name
    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The rate buried gold increases each turn.
    self.buryInterestRate = 0
    --- How much gold it costs to construct a single crew.
    self.crewCost = 0
    --- How much damage crew deal to each other.
    self.crewDamage = 0
    --- The maximum amount of health a crew member can have.
    self.crewHealth = 0
    --- The number of moves Units with only crew are given each turn.
    self.crewMoves = 0
    --- A crew's attack range. Range is circular.
    self.crewRange = 0
    --- The player whose turn it is currently. That player can send commands. Other players cannot.
    self.currentPlayer = nil
    --- The current turn number, starting at 0 for the first player's turn.
    self.currentTurn = 0
    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- How much health a Unit recovers when they rest.
    self.healFactor = 0
    --- The number of Tiles in the map along the y (vertical) axis.
    self.mapHeight = 0
    --- The number of Tiles in the map along the x (horizontal) axis.
    self.mapWidth = 0
    --- The maximum number of turns before the game will automatically end.
    self.maxTurns = 100
    --- How much gold merchant Ports get each turn.
    self.merchantGoldRate = 0
    --- When a merchant ship spawns, the amount of additional gold it has relative to the Port's investment.
    self.merchantInterestRate = 0
    --- The Euclidean distance buried gold must be from the Player's Port to accumulate interest.
    self.minInterestDistance = 0
    --- List of all the players in the game.
    self.players = Table()
    --- Every Port in the game. Merchant ports have owner set to nil.
    self.ports = Table()
    --- How far a Unit can be from a Port to rest. Range is circular.
    self.restRange = 0
    --- A unique identifier for the game instance that is being played.
    self.session = ""
    --- How much gold it costs to construct a ship.
    self.shipCost = 0
    --- How much damage ships deal to ships and ports.
    self.shipDamage = 0
    --- The maximum amount of health a ship can have.
    self.shipHealth = 0
    --- The number of moves Units with ships are given each turn.
    self.shipMoves = 0
    --- A ship's attack range. Range is circular.
    self.shipRange = 0
    --- All the tiles in the map, stored in Row-major order. Use `x + y * mapWidth` to access the correct index.
    self.tiles = Table()
    --- The amount of time (in nano-seconds) added after each player performs a turn.
    self.timeAddedPerTurn = 0
    --- Every Unit in the game. Merchant units have targetPort set to a port.
    self.units = Table()



    self.name = "Pirates"

    self._gameVersion = "d51fca49d06cb7164f9dbf9c3515ab0f9b5a17113a5946bddcc75aaba125967f"
    self._gameObjectClasses = {
        GameObject = require("games.pirates.gameObject"),
        Player = require("games.pirates.player"),
        Port = require("games.pirates.port"),
        Tile = require("games.pirates.tile"),
        Unit = require("games.pirates.unit"),
    }
end


--- Gets the Tile at a specified (x, y) position
-- @tparam number x integer between 0 and the mapWidth
-- @tparam number y integer between 0 and the mapHeight
-- @treturns Tile the Tile at (x, y) or nil if out of bounds
function Game:getTileAt(x, y)
    if x < 0 or y < 0 or x >= self.mapWidth or y >= self.mapHeight then -- out of bounds
        return nil;
    end

    return self.tiles[1 + x + y * self.mapWidth] -- 1 + ... because Lua lists are indexed at 1, so we add 1 to indexes, but we don't for the x, y positions
end

-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Game
