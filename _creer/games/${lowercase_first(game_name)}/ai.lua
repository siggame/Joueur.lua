-- This is where you build your AI for the ${game_name} game.
<%include file="functions.noCreer" />
local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")

${merge("-- ", "requires", "-- you can add additional require(s) here", optional=True)}

--- the AI functions for the ${game_name} game.
-- @classmod AI
local AI = class(BaseAI)

--- The reference to the Game instance this AI is playing.
-- @field[Game] self.game
-- @see Game

--- The reference to the Player this AI controls in the Game.
-- @field[Player] self.player
-- @see Player

--- this is the name you send to the server to play as.
function AI:getName()
${merge("    -- ", "get-name", '    return "' + game_name + ' Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!')}
end

--- this is called once the game starts and your AI knows its playerID and game. You can initialize your AI here.
function AI:start()
${merge("    -- ", "start", "    -- replace with your start logic")}
end

--- this is called when the game's state updates, so if you are tracking anything you can update it here.
function AI:gameUpdated()
${merge("    -- ", "game-updated", "    -- replace with your game updated logic")}
end

--- this is called when the game ends, you can clean up your data and dump files here if need be
-- @tparam boolean won true means you won, won == false means you lost
-- @tparam string reason why you won or lost
function AI:ended(won, reason)
${merge("    -- ", "ended", "    -- replace with your ended")}
end


-- Game Logic Functions: functions you must fill out to send data to the game server to actually play the game! --
% for function_name in ai['function_names']:

<% function_parms = ai['functions'][function_name]
%>--- ${shared['lua']['format_description'](function_parms['description'])}
% if 'arguments' in function_parms:
% for arg_parms in function_parms['arguments']:
-- @tparam ${shared['lua']['type'](arg_parms['type'])} ${arg_parms['name']} ${shared['lua']['format_description'](arg_parms['description'])}
% endfor
% endif
% if function_parms['returns'] != None:
-- @treturn ${shared['lua']['type'](function_parms['returns']['type'])} ${shared['lua']['format_description'](function_parms['returns']['description'])}
% endif
function AI:${function_name}(${", ".join(function_parms['argument_names'])})
${merge("    -- ", function_name,
"""    -- Put your game logic here for {0}
    return {1}
""".format(function_name, shared['lua']['default'](function_parms['returns']['type'], function_parms['returns']['default']) if function_parms['returns'] else "nil")
)}
end
% endfor

% if 'TiledGame' in game['serverParentClasses']: #// then we need to add some client side utility functions
--- A very basic path finding algorithm (Breadth First Search) that when given a starting Tile, will return a valid path to the goal Tile.
-- @tparam Tile start the starting Tile
-- @tparam Tile goal the goal Tile
-- @treturns Table(Tile) An array of Tiles representing the path, the the first element being a valid adjacent Tile to the start, and the last element being the goal.
function AI:findPath(start, goal)
    if start == goal then
        -- no need to make a path to here...
        return Table()
    end

    -- queue of the tiles that will have their neighbors searched for 'goal'
    local fringe = Table()

    -- How we got to each tile that went into the fringe.
    local cameFrom = Table()

    -- Enqueue start as the first tile to have its neighbors searched.
    fringe:insert(start);

    -- keep exploring neighbors of neighbors... until there are no more.
    while #fringe > 0 do
        -- the tile we are currently exploring.
        local inspect = fringe:popFront();

        -- cycle through the tile's neighbors.
        for i, neighbor in ipairs(inspect:getNeighbors()) do
            -- if we found the goal, we have the path!
            if neighbor == goal then
                -- Follow the path backward to the start from the goal and return it.
                local path = Table(goal)

                -- Starting at the tile we are currently at, insert them retracing our steps till we get to the starting tile
                while inspect ~= start do
                    path:pushFront(inspect)
                    inspect = cameFrom[inspect.id]
                end

                return path;
            end
            -- else we did not find the goal, so enqueue this tile's neighbors to be inspected

            -- if the tile exists, has not been explored or added to the fringe yet, and it is pathable
            if neighbor and not cameFrom[neighbor.id] and neighbor:isPathable() then
                -- add it to the tiles to be explored and add where it came from for path reconstruction.
                fringe:insert(neighbor)
                cameFrom[neighbor.id] = inspect
            end
        end
    end

    -- if we got here, no path was found
    return Table()
end

% endif
${merge("-- ", "functions", "-- if you need additional functions for your AI you can add them here", optional=True)}

return AI
