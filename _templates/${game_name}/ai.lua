-- ${header}
-- This is where you build your AI for the ${game_name} game.
local class = require("utilities.class")
local BaseAI = require("baseAI")

--- @class AI: the AI functions for the ${game_name} game.
local AI = class(BaseAI)

-- this is the name you send to the server to play as.
function AI:getName()
    return "${game_name} Lua Player"
end

-- this is called once the game starts and your AI knows its playerID and game. You can initialize your AI here.
function AI:gameInitialized()
    -- pass
end

-- this is called when the game's state updates, so if you are tracking anything you can update it here.
function AI:gameUpdated()
    -- pass
end

-- this is called every time the server tells you that you can send a command. Once you send a command you must return because the game state will change. This is where most of your game logic will probably go
function AI:run()
    -- pass
end

-- this is called when the server is no longer taking game commands from you, normally when you turn ends and another players begins.
function AI:ignoring()
    -- pass
end

-- this is called when the game closes (ends), you can clean up your data and dump files here if need be
function AI:close()
    -- pass
end

return AI
