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

    -- if that spider is a Spitter
    if spider.gameObjectName == "Spitter" then
        -- try to spit, but we need to make sure there is not an existing web as Spitters cannot spit new Webs between two Nests if there is an existing Web connecting the two
        local spitter = spider
        local enemysNest = self.player.otherPlayer.broodMother.nest

        -- loop through to check to make sure there is not already a Web to the enemys Nest
        existingWeb = None
        for i, web in ipairs(enemysNest.webs) do
            if web.nestA == spitter.nest or web.nestB == spitter.nest then
                existingWeb = web
                break
            end
        end

        if existingWeb then -- we can't spit to that nest, so instead move over it
            spitter:move(existingWeb)
        else
            spitter:spit(enemysNest)
        end
    elseif spider.gameObjectName == "Cutter" then
        local cutter = spider
        if #cutter.nest.webs > 0 then -- cut one of them
            cutter:cut(cutter.nest.webs:randomElement())
        elseif #cutter.nest.spiders > 1 then -- try to attack one of them
            -- get a random other spider to see if we can attack
            local otherSpider = cutter.nest.spiders:randomElement()
            if otherSpider.owner ~= cutter.owner then -- he isn't owned by our player, [try to] kill him!
                cutter:attack(otherSpider)
            end
        end
    elseif spider.gameObjectName == "Weaver" then
        local weaver = spider
        if #weaver.nest.webs > 0 then -- weave one of them
            -- 50% of the time do a strengthening weave, the other 50% of the time weaken
            if math.random(2) == 2 then
                weaver:strengthen(weaver.nest.webs:randomElement())
            else
                weaver:weaken(weaver.nest.webs:randomElement())
             end
        elseif #weaver.nest.spiders > 1 then -- try to attack one of them
            -- get a random other spider to see if we can attack
            local otherSpider = weaver.nest.spiders:randomElement()
            if otherSpider.owner ~= weaver.owner then -- he isn't owned by our player, [try to] kill him!
                weaver:attack(otherSpider)
            end
        end
    elseif spider.gameObjectName == "BroodMother" then
        local broodMother = spider

        -- try to consume a Spiderling
        if #broodMother.nest.spiders > 1 then -- there is another spider on this Nest, so let's try to consume one
            -- get a random other spider to see if it's not us
            local otherSpider = spider.nest.spiders:randomElement()
            if otherSpider ~= broodMother then -- we can comsume this poor soul
                broodMother:consume(otherSpider)
            end
        end

        -- try to spawn a Spiderling
        if broodMother.eggs > 0 then -- then spawn a Spiderling
            -- get a random spiderling type to spawn a new Spiderling of that type
            local randomSpiderlingType = table.randomElement({"Cutter", "Weaver", "BroodMother"})
            broodMother:spawn(randomSpiderlingType)
        end
    end

    return true
end

return AI
