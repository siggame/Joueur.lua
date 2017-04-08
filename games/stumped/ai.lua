-- This is where you build your AI for the Stumped game.

local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")



--- the AI functions for the Stumped game.
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
    return "Stumped Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!
end

--- this is called once the game starts and your AI knows its playerID and game. You can initialize your AI here.
function AI:start()
    -- replace with your start logic
end

--- this is called when the game's state updates, so if you are tracking anything you can update it here.
function AI:gameUpdated()
    -- replace with your game updated logic
end

--- this is called when the game ends, you can clean up your data and dump files here if need be
-- @tparam boolean won true means you won, won == false means you lost
-- @tparam string reason why you won or lost
function AI:ended(won, reason)
    -- replace with your ended
end


-- Game Logic Functions: functions you must fill out to send data to the game server to actually play the game! --

--- This is called every time it is this AI.player's turn.
-- @treturn bool Represents if you want to end your turn. True means end your turn, False means to keep your turn going and re-call this function.
function AI:runTurn()
    -- self is your Stumped ShellAI
    -- ShellAI is intended to be a simple AI that does everything possible in the game, but plays the game very poorly
    -- self example code does the following:
    -- 1. Grabs a single beaver
    -- 2. tries to move the beaver
    -- 3. tries to do one of the 5 actions on it
    -- 4. Grabs a lodge and tries to recruit a new beaver

    -- First let's do a simple print statement telling us what turn we are on
    print("My Turn " .. self.game.currentTurn)

    -- 1. get the first beaver to try to do things with
    local beaver = self.player.beavers[1]

    -- if we have a beaver, and it's not distracted, and it is alive (health greater than 0)
    if beaver and beaver.turnsDistracted == 0 and beaver.health > 0 then
        -- then let's try to do stuff with it

        -- 2. Try to move the beaver
        if beaver.moves >= 3 then
            -- then it has enough moves to move in any direction, so let's move it

            -- find a spawner to move to
            local target = nil
            for i, tile in ipairs(self.game.tiles) do
                if tile.spawner and tile.spawner.health > 1 then
                    -- then we found a healthy spawner, let's target that tile to move to
                    target = tile
                    break
                end
            end

            -- use the pathfinding algorithm below to make a path to the spawner's target tile
            local path = self:findPath(beaver.tile, target)

            -- if there is a path, move to it
            --      length 0 means no path could be found to the tile
            --      length 1 means the target is adjacent, and we can't move onto the same tile as the spawner
            --      length 2+ means we have to move towards it
            if #path > 1 then
                print("Moving " .. beaver .. " towards " .. target)
                beaver:move(path[1])
            end
        end

        -- 3. Try to do an action on the beaver
        if beaver.actions > 0 then
            -- then let's try to do an action!

            -- Do a random action!
            local action = table.randomElement({"buildLodge", "attack", "pickup", "drop", "harvest"})

            -- how much self beaver is carrying, used for calculations
            local load = beaver.branches + beaver.food

            if action == "buildLodge" then
                -- if the beaver has enough branches to build a lodge
                --   and the tile does not already have a lodge, then do so
                if (beaver.branches + beaver.tile.branches) >= self.player.branchesToBuildLodge and not beaver.tile.lodgeOwner then
                    print(beaver .. " building lodge")
                    beaver:buildLodge()
                end
            elseif action == "attack" then
                -- look at all our neighbor tiles and if they have a beaver attack it!
                for i, neighbor in ipairs(beaver.tile:getNeighbors():shuffle()) do
                    if neighbor.beaver then
                        print(beaver .. " attacking " .. neighbor.beaver)
                        beaver:attack(neighbor.beaver)
                        break
                    end
                end
            elseif action == "pickup" then
                -- make an array of our neighboring tiles + our tile as all can be picked up from
                local pickupTiles = beaver.tile:getNeighbors():extend({beaver.tile}):shuffle()

                -- if the beaver can carry more resources, try to pick something up
                if load < beaver.job.carryLimit then
                    for i, tile in ipairs(pickupTiles) do
                        -- try to pickup branches
                        if tile.branches > 0 then
                            print(beaver .. " picking up branches")
                            beaver:pickup(tile, "branches", 1)
                            break
                        -- try to pickup food
                        elseif tile.food > 0 then
                            print(beaver .. " picking up food")
                            beaver:pickup(tile, "food", 1)
                            break
                        end
                    end
                end
            elseif action == 'drop' then
                -- choose a random tile from our neighbors + out tile to drop stuff on
                local dropTiles = beaver.tile:getNeighbors():extend({beaver.tile}):shuffle()

                -- find a valid tile to drop resources onto
                local tileToDropOn = nil
                for i, tile in ipairs(dropTiles) do
                    if not tile.spawner then
                        tileToDropOn = tile
                        break
                    end
                end

                -- if there is a tile that resources can be dropped on
                if tileToDropOn then
                    -- if we have branches to drop
                    if beaver.branches > 0 then
                        print(beaver .. " dropping 1 branch")
                        beaver:drop(tileToDropOn, 'branches', 1)
                    -- or if we have food to drop
                    elseif beaver.food > 0 then
                        print(beaver .. " dropping 1 food")
                        beaver:drop(tileToDropOn, 'food', 1)
                    end
                end
            elseif action == 'harvest' then
                -- if we can carry more, try to harvest something
                if load < beaver.job.carryLimit then
                    -- try to find a neighboring tile with a spawner on it to harvest from
                    for i, neighbor in ipairs(beaver.tile:getNeighbors():shuffle()) do
                        -- if it has a spawner on that tile, harvest from it
                        if neighbor.spawner then
                            print("" .. beaver .. " harvesting " .. neighbor.spawner)
                            beaver:harvest(neighbor.spawner)
                            break
                        end
                    end
                end
            end
        end
    end

    -- now try to spawn a beaver if we have lodges

    -- 4. Get a lodge to try to spawn something at
    local lodge = self.player.lodges:randomElement()

    -- if we found a lodge and it has no beaver blocking it
    if lodge and not lodge.beaver then
        -- then self lodge can have a new beaver appear here

        -- We need to know how many beavers we have to see if they are free to spawn
        local aliveBeavers = 0
        for i, myBeaver in ipairs(self.player.beavers) do
            if beaver.health > 0 then
                aliveBeavers = aliveBeaver + 1
            end
        end

        -- and we need a Job to spawn
        local job = self.game.jobs:randomElement()

        -- if we have less beavers than the freeBeavers count, it is free to spawn
        --    otherwise if that lodge has enough food on it to cover the job's cost
        if aliveBeavers < self.game.freeBeaversCount or lodge.food >= job.cost then
            -- then spawn a new beaver of that job!
            print("recruiting " .. job .. " to " .. lodge)
            job:recruit(lodge)
            aliveBeavers = aliveBeavers + 1
        end
    end

    print("Done with out turn")
    return true -- to signify that we are truly done with self turn
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



return AI
