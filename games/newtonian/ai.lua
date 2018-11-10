-- This is where you build your AI for the Newtonian game.

local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")

-- <<-- Creer-Merge: requires -->> - Code you add between this comment and the end comment will be preserved between Creer re-runs.
-- you can add additional require(s) here
-- <<-- /Creer-Merge: requires -->>

--- the AI functions for the Newtonian game.
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
    return "Newtonian Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!
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

    -- Please note: This code is intentionally bad. You should try to optimize everything here. The code here is only to show you how to use the
    --              game's mechanics with the MegaMinerAI server framework.

    -- Goes through all the units that you own.
    for unit in self.player.units do
        -- Only tries to do something if the unit actually exists.
        if unit != nil and unit.tile != nil then
            if unit.job.title == "physicist" then
                -- If the unit is a physicist, tries to work on machines that are ready.
                -- If ther are none, it finds and attacks enemy managers.
                
                -- Tries to find a workable machine for blueium ore.
                -- Note: You need to get redium ore as well.
                local target = nil

                -- Goes through all the machines in the game and picks one that is ready to process ore as its target.
                for machine in self.game.machines do
                    if machine.tile.blueiumOre >= machine.refineInput then
                        target = machine.tile
                    end
                end

                if target == nil then
                    -- Chases down enemy managers if there are no machines that are ready to be worked.
                    for enemy in self.game.units do
                        -- Only does anything if the unit that we found is a manager and belongs to our opponent.
                        if enemy.tile ~= nil and enemy.owner == self.player.opponent and enemy.job.title = "manager" then
                            -- Moves towards the manager.
                            while unit.moves > 0 and #self:findPath(unit.tile, enemy.tile) > 0 do
                                -- Moves until there are no moves left for the physicist.
                                if ~unit:move(self.findPath(unit.tile, enemy.tile)[0]) then
                                    break
                                end
                            end

                            local adjacent = false
                            for tile in enemy.tile:getNeighbors() do
                                if tile == unit.tile then
                                    adjacent = true
                                end
                            end

                            if adjacent then
                                if enemy.stunTime == 0 and enemy.stunImmune == 0 then
                                    -- Stuns the enemy manager if they are not stunned and not immune.
                                    unit:act(enemy.tile)
                                else
                                    -- Attacks the manager otherwise.
                                    unit:attack(enemy.tile)
                                end
                            end
                            break
                        end
                    end
                else
                    -- Gets the tile of the targeted machine if adjacent to it.
                    local adjacent = false
                    for tile in target:getNeighbors() do
                        if tile == unit.tile then
                            adjacent = true
                        end
                    end

                    -- If there is a machine that is waiting to be worked on, go to it.
                    while unit.moves > 0 and #self:findPath(unit.tile, target) > 1 and ~adjacent do
                        if ~unit:move(self:findPath(unit.tile, target)[0]) then
                            break
                        end
                    end

                    -- Acts on the target machine to run it if the physicist is adjacent.
                    if adjacent and ~unit.acted then
                        unit:act(target)
                    end
                end
            elseif unit.job.title == "intern" then
                -- If the unit is an intern, collects blueium ore.
                -- Note: You also need to collect redium ore.
                
                -- Goes to gather resources if currently carrying less than the carry limit.
                if unit.blueiumOre < unit.job.carryLimit then
                    -- Your intern's current target.
                    target = nil

                    -- Goes to collect blueium ore that isn't on a machine.
                    for tile in self.game.tiles do
                        if tile.blueiumOre > 0 and tile.machine == nil then
                            target = tile
                            break
                        end
                    end

                    -- Moves towards our target until at the target or out of moves.
                    if #self:findPath(unit.tile, target) > 0 then
                        while unit.moves > 0 and #self:findPath(unit.tile, target) > 0 do
                            if ~unit:move(self:findPath(unit.tile, target)[0]) then
                                break
                            end
                        end
                    end

                    -- Picks up the appropriate resource once we reach our target's tile.
                    if unit.tile == target and target.blueiumOre > 0 then
                        unit:pickup(target, 0, "blueium ore")
                    end

                else
                    -- Deposits blueium ore in a machine for it if we have any.
                    
                    -- Finds a machine in the game's tiles that takes blueium ore.
                    for tile in self.game.tiles do
                        if tile.machine ~= nil and tile.machine.oreType == "blueium" then
                            -- Moves towards the found machine until we reach it or are out of moves.
                            while unit.moves > 0 and #self:findPath(unit.tile, tile) > 1 do
                                if ~unit:move(self:findPath(unit.tile, tile)[0]) then
                                    break
                                end
                            end

                            -- Deposits blueium ore on the machine if we have reached it.
                            if #self:findPath(unit.tile, tile) <= 1 then
                                unit:drop(tile, 0, "blueium ore")
                            end
                        end
                    end
                end
            elseif unit.job.title == "manager" then
                -- Finds enemy interns, stuns and attacks them if there is no blueium to take to the generator.
                local target = nil

                for tile in self.game.tiles do
                    if tile.blueium > 1 and unit.blueium < unit.job.carryLimit then
                        target = tile
                    end
                end

                if target == nil and unit.blueium == 0 then
                    for enemy in self.game.units do
                        -- Only does anything for an intern that is owned by your opponent.
                        if enemy.tile ~= nil and enemy.owner == self.player.opponent and enemy.job.title == "intern" then
                            -- Moves towards the intern until reached or out of moves.
                            while unit.moves > 0 and #self:findPath(unit.tile, enemy.tile) > 0 do
                                if ~unit:move(self:findPath(unit.tile, enemy.tile)[0]) then
                                    break
                                end
                            end

                            -- Either stuns or attacks the intern if we are within range.
                            local adjacent = false
                            for tile in enemy.tile:getNeighbors() do
                                if tile == unit.tile then
                                    adjacent = true
                                end
                            end

                            if adjacent then
                                if enemy.stunTime == 0 and enemy.stunImmune == 0 then
                                    -- Stuns the enemy intern if they are not stunned and not immune.
                                    unit:act(enemy.tile)
                                else
                                    -- Attacks the intern otherwise.
                                    unit:attack(enemy.tile)
                                end
                            end
                            break
                        end
                    end
                elseif target ~= nil then
                    -- Moves towards our target until at the target or out of moves.
                    while unit.moves > 0 and #self:findPath(unit.tile, target) > 1 do
                        if ~unit:move(self.findPath(unit.tile, target)[0]) then
                            break
                        end
                    end

                    -- Picks up blueium once we reach our target's tile.
                    if #self:findPath(unit.tile, target) <= 1 and target.blueiume > 0 then
                        unit:pickup(target, 0, "blueiume")
                    end
                elseif target == nil and unit.blueiume > 0 then
                    -- Stores a tile that is part of your generator.
                    local genTile = self.player.generatorTiles[0]

                    -- Goes to your generator and drops blueium in.
                    while unit.moves > 0 and #self:findPath(unit.tile, genTile) > 0 do
                        if ~unit:move(self:findPath(unit.tile, genTile)[0]) then
                            break
                        end
                    end

                    -- Deposits blueium in our generator if we have reached it.
                    if #self:findPath(unit.tile, genTile) <= 1 then
                        unit:drop(tile, 0, "blueium")
                    end
                end
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
-- <<-- /Creer-Merge: functions -->>

return AI
