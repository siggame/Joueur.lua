-- Game: There's an infestation of enemy spiders challenging your queen BroodMother spider! Protect her and attack the other BroodMother in this turn based, node based, game.
-- DO NOT MODIFY THIS FILE
-- Never try to directly create an instance of this class, or modify its member variables.
-- Instead, you should only be reading its variables and calling its functions.


local class = require("joueur.utilities.class")
local BaseGame = require("joueur.baseGame")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- There's an infestation of enemy spiders challenging your queen BroodMother spider! Protect her and attack the other BroodMother in this turn based, node based, game.
-- @classmod Game
local Game = class(BaseGame)

-- initializes a Game with basic logic as provided by the Creer code generator
function Game:init(...)
    BaseGame.init(self, ...)

    --- The name of this game, "{game_name}".
    -- @field[string] self.name
    -- The following values should get overridden when delta states are merged, but we set them here as a reference for you to see what variables this class has.

    --- The player whose turn it is currently. That player can send commands. Other players cannot.
    self.currentPlayer = nil
    --- The current turn number, starting at 0 for the first player's turn.
    self.currentTurn = 0
    --- The speed at which Cutters work to do cut Webs.
    self.cutSpeed = 0
    --- Constant used to calculate how many eggs BroodMothers get on their owner's turns.
    self.eggsScalar = 0
    --- A mapping of every game object's ID to the actual game object. Primarily used by the server and client to easily refer to the game objects via ID.
    self.gameObjects = Table()
    --- The starting strength for Webs.
    self.initialWebStrength = 0
    --- The maximum number of turns before the game will automatically end.
    self.maxTurns = 100
    --- The maximum strength a web can be strengthened to.
    self.maxWebStrength = 0
    --- The speed at which Spiderlings move on Webs.
    self.movementSpeed = 0
    --- Every Nest in the game.
    self.nests = Table()
    --- List of all the players in the game.
    self.players = Table()
    --- A unique identifier for the game instance that is being played.
    self.session = ""
    --- The speed at which Spitters work to spit new Webs.
    self.spitSpeed = 0
    --- The amount of time (in nano-seconds) added after each player performs a turn.
    self.timeAddedPerTurn = 0
    --- How much web strength is added or removed from Webs when they are weaved.
    self.weavePower = 0
    --- The speed at which Weavers work to do strengthens and weakens on Webs.
    self.weaveSpeed = 0
    --- Every Web in the game.
    self.webs = Table()



    self.name = "Spiders"

    self._gameVersion = "a8df6038306b6855bb35959d7698f8dcbf98f48e7e148de59fef940ccb241bdf"
    self._gameObjectClasses = {
        BroodMother = require("games.spiders.broodMother"),
        Cutter = require("games.spiders.cutter"),
        GameObject = require("games.spiders.gameObject"),
        Nest = require("games.spiders.nest"),
        Player = require("games.spiders.player"),
        Spider = require("games.spiders.spider"),
        Spiderling = require("games.spiders.spiderling"),
        Spitter = require("games.spiders.spitter"),
        Weaver = require("games.spiders.weaver"),
        Web = require("games.spiders.web"),
    }
end


-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you want to add any client side logic this is where you can add them
-- <<-- /Creer-Merge: functions -->>

return Game
