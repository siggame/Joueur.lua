-- ${header}
-- This is where you build your AI for the ${game_name} game.
<%include file="functions.noCreer" />
local class = require("utilities.class")
local BaseAI = require("baseAI")

${merge("-- ", "requires", "-- you can add addtional require(s) here")}

--- @class AI: the AI functions for the ${game_name} game.
local AI = class(BaseAI)

-- this is the name you send to the server to play as.
function AI:getName()
${merge("    -- ", "get-name", '    return "' + game_name + ' Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!')}
end

-- this is called once the game starts and your AI knows its playerID and game. You can initialize your AI here.
function AI:start()
${merge("    -- ", "start", "    -- replace with your start logic")}
end

-- this is called when the game's state updates, so if you are tracking anything you can update it here.
function AI:gameUpdated()
${merge("    -- ", "game-updated", "    -- replace with your game updated logic")}
end

--- this is called when the game ends, you can clean up your data and dump files here if need be
-- @param {boolean} won == true means you won, won == false means you lost
-- @param {string} reason you won or lost
function AI:ended(won, reason)
${merge("    -- ", "ended", "    -- replace with your ended")}
end

--- Game Logic Functions: functions you must fill out to send data to the game server to actually play the game! ---

% for function_name, function_parms in ai['functions'].items():
--- ${function_parms['description']}
% if 'arguments' in function_parms:
% for arg_parms in function_parms['arguments']:
-- @param {${arg_parms['type']}} ${arg_parms['name']}: ${arg_parms['description']}
% endfor
% endif
% if function_parms['returns'] != None:
-- @returns {${shared['lua']['type'](function_parms['returns']['type'])}} ${function_parms['returns']['description']}
% endif
function AI:${function_name}(${", ".join(function_parms['argument_names'])})
${merge("    -- ", function_name,
"""    -- Put your game logic here for {0}
    return {1}
""".format(function_name, shared['lua']['default'](function_parms['returns']['type'], function_parms['returns']['default'])))
}
end
% endfor

${merge("-- ", "functions", "-- if you need additional functions for your AI you can add them here")}

return AI
