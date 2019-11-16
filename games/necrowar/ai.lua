-- This is where you build your AI for the Necrowar game.

local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- the AI functions for the Necrowar game.
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
    return "Necrowar Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!
    -- <<-- /Creer-Merge: get-name -->>
end

--- this is called once the game starts and your AI knows its playerID and game. You can initialize your AI here.
function AI:start()
    -- <<-- Creer-Merge: start -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
    -- replace with your start logic

    -- If you are reading this, congratulations on knowing lua. I do not. Beware.
    -- Print our starting stats
    print(string.format("GOLD: %d", self.player.gold))
    print(string.format("MANA: %d", self.player.mana))
    io.write("UNITS: ")
    for unit in self.player.units do
        io.write(unit.job.title)
        io.write(",")
    end
    print("\nTOWERS: ")
    for tower in self.player.towers do
        io.write(tower.job.title)
        io.write(",")
    end
    print(string.format("\nCASTLE HEALTH: %d", self.player.towers[0].health))

    -- Set up varibales to track all relevant information
    self.spawnUnitTile = nil
    self.spawnWorkerTile = nil
    self.goldMines = {}
    self.miners = {}
    self.builders = {}
    self.units = {}
    self.grassByPath = {}
    self.enemyCastle = self.player.opponent.towers[0]
    self.myCastle = self.player.towers[0]

    -- Fill our variables with tile data
    for tile in self.player.side do
        if tile.is_unit_spawn then
            self.spawnUnitTile = tile
        elseif tile.is_worker_spawn then
            self.spawnWorkerTile = tile
        elseif tile.is_gold_mine then
            self.goldMines.append(tile)
        elseif tile.is_grass then
            for neighbor in tile.get_neighbors() do
                if neighbor.is_path then
                    self.grassByPath.append(tile)
                end
            end
        end
    end

    -- Now we should have our spawn tiles, mines, and tower building locations!

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

    -- Remove any dead units from our personal tracking lists
    local temp = {}
    for elem in self.miners do
        if elem.health <= 0 then
            temp[#temp] = elem
        end
    end
    self.miners = {table.unpack(temp)}


    temp = {}
    for elem in self.builders do
        if elem.health <= 0 then
            temp[#temp] = elem
        end
    end
    self.builders = {table.unpack(temp)}


    temp = {}
    for elem in self.units do
        if elem.health <= 0 then
            temp[#temp] = elem
        end
    end
    self.units = {table.unpack(temp)}

    -- Spawn all three of our chosen unit types if necessary
    if self.miners == {} then
        if self.spawnWorkerTile.spawn_worker() then
            self.miners.append(self.player.units[#self.player.units])
        end
    end

    if self.builders == {} then
        if self.spawnWorkerTile.spawn_worker() then
            self.builders.append(self.player.units[#self.player.units])
        end
    end

    if self.units == {} then
        if self.spawnUnitTile.spawn_unit("ghoul"):
            self.units.append(self.player.units[#self.player.units])
        end
    end

    -- Activate all the different units in our lists
    for miner in self.miners do
        if miner.tile.is_gold_mine then
            miner.mine(miner.tile)
        else
            path = self.find_path_worker(miner.tile, self.goldMines[0])
            for tile in path do
                if miner.moves <= 0 then
                    break
                end
                miner.move(tile)
            end
        end
    end

    for builder in self.builders do
        path = self.find_path_worker(builder.tile, self.grassByPath[0])
        for tile in path do
            if builder.moves <= 0 then
                break
            end
            builder.move(tile)
        end
        if path == {} and builder.moves > 0 then
            builder.build("arrow")
        end
    end

    for unit in self.units do
        path = self.find_path(unit.tile, self.enemyCastle.tile.tile_south)
        for tile in path do
            if unit.moves <= 0 then
                break
            end
            unit.move(tile)
        end
        if path == {} and unit.moves > 0 then
            unit.attack(self.enemyCastle.tile)
        end
    end

    -- Make towers attack anything adjacent to them
    -- Note that they are not using their full range
    for tower in self.player.towers do
        adjacent = tower.tile.get_neighbors()
        for tile in adjacent do
            if tile.unit and tile.unit.owner == self.player.opponent then
                tower.attack(tile)
            end
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
function AI:findPathWorker(start, goal)
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
            if neighbor and not cameFrom[neighbor.id] and neighbor:isPathableWorker() then
                -- add it to the tiles to be explored and add where it came from for path reconstruction.
                fringe:insert(neighbor)
                cameFrom[neighbor.id] = inspect
            end
        end
    end

    -- if we got here, no path was found
    return Table()
end

-- <<-- /Creer-Merge: functions -->>

return AI
