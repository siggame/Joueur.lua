-- This is where you build your AI for the Saloon game.

local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")

--- the AI functions for the Saloon game.
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
    return "Saloon Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!

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
    -- Put your game logic here for runTurn

    -- This is "ShellAI", some basic code we've provided that does
    -- everything in the game for demo purposed, but poorly so you
    -- can get to optimizing or overwriting it ASAP
    --
    -- ShellAI does a few things:
    -- 1. Tries to spawn a new Cowboy
    -- 2. Tries to move to a Piano
    -- 3. Tries to play a Piano
    -- 4. Tries to act
    --
    -- Note: You can find helper functions in joueur/utilities

    print("Start of my turn: " .. self.game.currentTurn)

    -- for steps 2, 3, and 4 we will use this cowboy:
    local cowboy = nil
    for i, myCowboy in ipairs(self.player.cowboys) do
        if not myCowboy.isDead then
            cowboy = myCowboy
            break
        end
    end



    ----- 1. Try to spawn a Cowboy -----

    -- Randomly select a job.
    local callInJob = self.game.jobs:randomElement()
    local jobCount = 0
    for i, myCowboy in ipairs(self.player.cowboys) do
        if not myCowboy.isDead and myCowboy.job == callInJob then
            jobCount = jobCount + 1
        end
    end

    -- Call in the new cowboy with that job if there aren't too many
    --   cowboys with that job already.
    if self.player.youngGun.canCallIn and jobCount < self.game.maxCowboysPerJob then
        print("1. Calling in: " .. callInJob);
        self.player.youngGun:callIn(callInJob);
    end

    --  Now let's use him
    if cowboy then
        ----- 2. Try to move to a Piano -----

        -- find a piano
        local piano = nil -- find a piano
        for i, furnishing in ipairs(self.game.furnishings) do
            if furnishing.isPiano and not furnishing.isDestroyed then
                piano = furnishing
                break
            end
        end

        -- There will always be pianos or the game will end. No need to check for existence.
        -- Attempt to move toward the piano by finding a path.
        if cowboy.canMove and not cowboy.isDead then
            print("Trying to do stuff with Cowboy #" .. cowboy.id)

            -- find a path from the Tile this cowboy is on to the tile the piano is on
            local path = self:findPath(cowboy.tile, piano.tile)

            -- if there is a path, move to it
            --      length 0 means no path could be found to the tile
            --      length 1 means the piano is adjacent, and we can't move onto the same tile as the piano
            if #path > 1 then
                print("2. Moving to Tile #" .. path[1].id)
                cowboy:move(path[1])
            end
        end



        ----- 3. Try to play a piano -----

        -- make sure the cowboy is alive and is not busy
        if not cowboy.isDead and cowboy.turnsBusy == 0 then
            -- look at all the neighboring (adjacent) tiles, and if they have a piano, play it
            for i, neighbor in ipairs(cowboy.tile:getNeighbors()) do
                -- if the neighboring tile has a piano
                if neighbor.furnishing and neighbor.furnishing.isPiano then
                    -- then play it
                    print("3. Playing Furnishing (piano) #" .. neighbor.furnishing.id);
                    cowboy:play(neighbor.furnishing)
                    break
                end
            end
        end



        ----- 4. Try to act -----

        -- make sure the cowboy is alive and is not busy
        if not cowboy.isDead and cowboy.turnsBusy == 0 then
            -- Get a random neighboring tile.
            local randomNeighbor = cowboy.tile:getNeighbors():randomElement()

            -- Based on job, act accordingly.
            if cowboy.job == "Bartender" then
                -- Bartenders throw Bottles in a direction, and the Bottle makes cowboys drunk which causes them to walk in random directions
                -- so throw the bottle on a random neighboring tile, and make drunks move in a random direction
                local direction = cowboy.tile.directions:randomElement()
                print("4. Bartender acting on Tile #" .. randomNeighbor.id .. " in direction " .. direction)
                cowboy:act(randomNeighbor, direction)
            elseif cowboy.job == "Brawler" then
                -- Brawlers cannot act, they instead automatically attack all neighboring tiles on the end of their owner's turn.
                print("4. Brawlers cannot act.")
            elseif "Sharpshooter" then
                -- Sharpshooters build focus by standing still, they can then act(tile) on a neighboring tile to fire in that direction
                if cowboy.focus > 0 then
                    print("4. Sharpshooter acting on Tile #" .. randomNeighbor.id)
                    cowboy:act(randomNeighbor) -- fire in a random direction
                end
            end
        end
    end

    print("Ending my turn.");

    -- we are done, returning true tells the game server we are indeed done with our turn.
    return true;
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
