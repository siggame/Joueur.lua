local class = require("joueur.utilities.class")

---
-- @class BaseAI: the base functions all AIs should do
local BaseAI = class()

---
-- BaseAI constructor, sets the game
-- @param {Game} the game this AI should be playing
function BaseAI:init(game)
    self.game = game
end

---
-- called once we get the first game state and can find our actual player in the game
function BaseAI:setPlayer(player)
    self.player = player
end

---
-- called once the game is initialized, intended to be overridden by the competitor's AI Class
function BaseAI:start()
    -- intended to be overridden by the AI class, purposed left empty here to not penalize competitors for forgetting to call the parent method
end

---
-- called every time the game is updated, intended to be overridden by the competitor's AI Class
function BaseAI:gameUpdated()
    -- intended to be overridden by the AI class, purposed left empty here to not penalize competitors for forgetting to call the parent method
end

---
-- called when the server sends a order that it expects you to execute and finish. callback is executed via reflection, and said callback should be in the top-level AI class filled in by competitor
-- @param order {string} what we are responding to, used for reflection
-- @param {table} array of args to send to callback
-- @returns {table} response. what the table is depends on the order.
function BaseAI:_doOrder(order, args)
    local callback = self[order] -- this function should be generated via Creer in the inherited AI function

    if callback then
        return callback(self, args and unpack(args) or nil)
    else
        print("ERROR: AI has not function '" .. order .. "'' to respond with")
        os.exit()
    end
end

---
-- called when we (the client) send some invalid response to the server. It should be echoed back here
-- @param data {table} the invalid data we sent, echoed back here
function BaseAI:invalid(data)
    print("AI was told this is invalid", data)
end


---
-- called when the game is over. Intended to be overridden
function BaseAI:ended(won, reason)
    -- intended to be overridden by the AI class, purposed left empty here to not penalize competitors for forgetting to call the parent method
end

return BaseAI
