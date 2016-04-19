-- This is where you build your AI for the Spiders game.

local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")

--- the AI functions for the Spiders game.
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
    return "Spiders Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!
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
    -- This is ShellAI, it is very simple, and demonstrates how to use all the game objects in Spiders

    -- get a random spider to try to do things with
    local spider = self.player.spiders:randomElement()

    if spider.gameObjectName == "BroodMother" then
        local broodMother = spider

        local choice = math.random(10)

        if choice == 1 then -- try to consume a Spiderling 10% of the time
            if #broodMother.nest.spiders > 1 then -- there is another spider on this Nest, so let's try to consume one
                -- get a random other spider to see if it's not us
                local otherSpider = spider.nest.spiders:randomElement()
                if otherSpider ~= broodMother then -- we can comsume this poor soul
                    print("Broodmother #" .. broodMother.id .. " consuming " .. otherSpider.gameObjectName .. " #" .. otherSpider.id)
                    broodMother:consume(otherSpider)
                end
            end
        else -- try to spawn a Spiderling
            if broodMother.eggs > 0 then -- then we can spawn a Spiderling
                -- get a random spiderling type to spawn a new Spiderling of that type
                local randomSpiderlingType = table.randomElement({"Cutter", "Weaver", "Spitter"})
                print("Broodmother #" .. broodMother.id .. " spawning " .. randomSpiderlingType)
                broodMother:spawn(randomSpiderlingType)
            end
        end
    else -- it is a Spiderling
        local spiderling = spider

        if spiderling.busy == "" then -- it is NOT busy
            local choice = math.random(3) -- do a random choice of 3 options

            if choice == 1 then -- try to move somewhere
                if #spiderling.nest.webs > 0 then
                    local web = spiderling.nest.webs:randomElement()
                    print("Spiderling " .. spiderling.gameObjectName .. " #" .. spiderling.id .. " moving on Web #" .. web.id)
                    spiderling:move(web)
                end
            elseif choice == 2 then -- try to attack something
                if #spiderling.nest.spiders > 1 then -- there is someone besides us on the nest, let's try to attack!
                    local otherSpider = spiderling.nest.spiders:randomElement()
                    if otherSpider.owner ~= spiderling.owner then -- attack the enemy!
                        spiderling:attack(otherSpider)
                    end
                end
            else -- only thing left is to do something unique based on what type of Spiderling we are
                -- if that spider is a Spitter
                if spiderling.gameObjectName == "Spitter" then -- try to spit
                    local spitter = spiderling
                    local enemysNest = self.player.otherPlayer.broodMother.nest

                    -- loop through to check to make sure there is not already a Web to the enemys Nest
                    existingWeb = nil
                    for i, web in ipairs(enemysNest.webs) do
                        if web.nestA == spitter.nest or web.nestB == spitter.nest then
                            existingWeb = web
                            break
                        end
                    end

                    if not existingWeb then -- because no web exists between here and the enemy's nest, spit a web to it
                        print("Spitter #" .. spitter.id .. " spitting to Nest #" .. enemysNest.id)
                        spitter:spit(enemysNest)
                    end
                elseif spiderling.gameObjectName == "Cutter" then -- try to cut
                    local cutter = spiderling
                    if #cutter.nest.webs > 0 then -- cut one of the Webs
                        local web = cutter.nest.webs:randomElement()
                        print("Cutter #" .. cutter.id .. " cutting Web #" .. web.id)
                        cutter:cut(web)
                    end
                elseif spiderling.gameObjectName == "Weaver" then -- try to strengthen or weaken
                    local weaver = spiderling
                    if #weaver.nest.webs > 0 then -- weave one of the Webs
                        -- 50% of the time do a strengthening weave, the other 50% of the time weaken
                        if math.random(2) == 2 then
                            weaver:strengthen(weaver.nest.webs:randomElement())
                        else
                            weaver:weaken(weaver.nest.webs:randomElement())
                        end
                     end
                end
            end
        end
    end

    return true
end

return AI
