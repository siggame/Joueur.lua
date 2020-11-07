-- This is where you build your AI for the Coreminer game.

local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- the AI functions for the Coreminer game.
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
    -- <<-- Creer-Merge: get-name -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
    return "Coreminer Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!
    -- <<-- /Creer-Merge: get-name -->>
end

--- this is called once the game starts and your AI knows its playerID and game. You can initialize your AI here.
function AI:start()
    -- <<-- Creer-Merge: start -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
    -- replace with your start logic
    -- <<-- /Creer-Merge: start -->>
end

--- this is called when the game's state updates, so if you are tracking anything you can update it here.
function AI:gameUpdated()
    -- <<-- Creer-Merge: game-updated -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
    -- replace with your game updated logic
    -- <<-- /Creer-Merge: game-updated -->>
end

--- this is called when the game ends, you can clean up your data and dump files here if need be
-- @tparam boolean won true means you won, won == false means you lost
-- @tparam string reason why you won or lost
function AI:ended(won, reason)
    -- <<-- Creer-Merge: ended -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
    -- replace with your ended
    -- <<-- /Creer-Merge: ended -->>
end


-- Game Logic Functions: functions you must fill out to send data to the game server to actually play the game! --

--- This is called every time it is this AI.player's turn.
-- @treturn bool Represents if you want to end your turn. True means end your turn, False means to keep your turn going and re-call this function.
function AI:runTurn()
    -- <<-- Creer-Merge: runTurn -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
    -- Put your game logic here for runTurn

    -- If we have no miners and can afford one, spawn one
    if #self.player.miners < 1 and self.player.money >= self.game.spawnPrice then
        self.player:spawnMiner()
    end

    -- For each miner
    for miner in self.player.miners do
        if miner != nil and miner.tile != nil then
            continue
        end

        -- Move to tile next to base
        if miner.tile.isBase then
            if miner.tile.tileEast then
                miner:move(miner.tile.tileEast)
            else
                miner:move(miner.tile.tileWest)
            end
        end

        -- Sell all materials
        local sellTile = self.game:getTileAt(self.player.baseTile.x, miner.tile.y)
        if sellTile and sellTile.owner == self.player then
            miner:dump(sellTile, "dirt", -1)
            miner:dump(sellTile, "ore", -1)
        end

        local eastTile = miner.tile.tileEast
        local westTile = miner.tile.tileWest

        -- Mine east and west tiles
        if eastTile.x == self.player.baseTile.x then
            if eastTile != nil then
                miner:mine(eastTile, -1)
            end
            if eastTile != nil then
                miner:mine(westTile, -1)
            end
        else
            if eastTile != nil then
                miner:mine(eastTile, -1)
            end
            if eastTile != nil then
                miner:mine(westTile, -1)
            end
        end

        -- Check to make sure east and west tiles are mined
        if (eastTile and eastTile.ore + eastTile.dirt == 0) and (westTile and westTile.ore + westTile.dirt == 0) then
            -- Dig down
            if miner.tile.tileSouth != nil {
                miner:mine(miner.tile.tileSouth, -1)
            }
        end
    end
    
    return true
    -- <<-- /Creer-Merge: runTurn -->>
end

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

-- <<-- Creer-Merge: functions -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- if you need additional functions for your AI you can add them here
-- <<-- /Creer-Merge: functions -->>

return AI
