-- ${header}
-- This is where you build your AI for the ${game_name} game.
<%include file="functions.noCreer" />
local class = require("utilities.class")
local BaseAI = require("baseAI")

--- @class AI: the AI functions for the ${game_name} game.
local AI = class(BaseAI)

-- this is the name you send to the server to play as.
function AI:getName()
    return "${game_name} Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!
end

-- this is called once the game starts and your AI knows its playerID and game. You can initialize your AI here.
function AI:start()
    -- pass
end

-- this is called when the game's state updates, so if you are tracking anything you can update it here.
function AI:gameUpdated()
    -- pass
end

--- this is called when the game ends, you can clean up your data and dump files here if need be
-- @param {boolean} won == true means you won, won == false means you lost
-- @param {string} reason you won or lost
function AI:ended(won, reason)
    -- pass
end

--- Game Logic Functions: functions you must fill out to send data to the game server to actually play the game! ---

% for function_name, function_parms in ai['functions'].items():
--- ${function_parms['description']}
% if 'arguments' in function_parms:
% for arg_parms in function_parms['arguments']:
-- @param <${arg_parms['type']}> ${arg_parms['name']}: ${arg_parms['description']}
% endfor
% endif
% if function_parms['returns'] == None:
-- @returns nil
% else:
-- @returns <${shared['lua']['type'](function_parms['returns']['type'])}> ${function_parms['returns']['description']}
% endif
function AI:${function_name}(${", ".join(function_parms['argument_names'])})
    -- Put your game logic here for ${function_name}
    return ${shared['lua']['default'](function_parms['returns']['type'], function_parms['returns']['default'])}
end
% endfor

return AI
