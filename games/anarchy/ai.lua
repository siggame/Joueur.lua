-- This is where you build your AI for the Anarchy game.

local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")

--- @class AI: the AI functions for the Anarchy game.
local AI = class(BaseAI)

-- this is the name you send to the server to play as.
function AI:getName()
    return "Anarchy Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!
end

-- this is called once the game starts and your AI knows its playerID and game. You can initialize your AI here.
function AI:start()
    -- replace with your start logic
end

-- this is called when the game's state updates, so if you are tracking anything you can update it here.
function AI:gameUpdated()
    -- replace with your game updated logic
end

--- this is called when the game ends, you can clean up your data and dump files here if need be
-- @param boolean won == true means you won, won == false means you lost
-- @param string reason you won or lost
function AI:ended(won, reason)
    -- replace with your ended
end

--- Game Logic Functions: functions you must fill out to send data to the game server to actually play the game! ---

--- This is called every time the AI is asked to respond with a command during their turn
-- @returns boolean represents if you want to end your turn. true means end the turn, false means to keep your turn going and re-call runTurn()
function AI:runTurn()

    -- Get my first warehouse
    local warehouse = self.player.warehouses[1]
    if self:canBribe(warehouse) then
        -- ignite the first enemy building
        warehouse:ignite(self.player.otherPlayer.buildings[1])
    end

    -- Get my first fire department
    local fireDepartment = self.player.fireDepartments[1]
    if self:canBribe(fireDepartment) then
        -- extinguish my first building if it's not my headquarters
        local myBuilding = self.player.buildings[1]
        if not myBuilding.isHeadquarters then
            fireDepartment:extinguish(myBuilding)
        end
    end

    -- Get my first police department
    local policeDepartment = self.player.policeDepartments[1]
    if self:canBribe(policeDepartment) then
        -- Get the first enemy warehouse
        local toRaid = self.player.otherPlayer.warehouses[1]
        -- Make sure it is alive to be raided and the headquarters
        if toRaid.health > 0 and not toRaid.isHeadquarters then
            -- Raid the first enemy warehouse
            policeDepartment:raid(self.player.otherPlayer.warehouses[1])
        end
    end

    -- Get my first weather station
    local weatherStation1 = self.player.weatherStations[1]
    if self:canBribe(weatherStation1) then
        -- Make sure the intensity isn't at max
        if self.game.nextForecast.intensity < self.game.maxForecastIntensity then
            weatherStation1:intensify()
        else
            -- Otherwise decrease the intensity
            weatherStation1:intensify(true)
        end
    end

    -- Get my second weather station
    local weatherStation2 = self.player.weatherStations[2]
    if self:canBribe(weatherStation2) then
        -- Rotate clockwise
        weatherStation2:rotate()
    end

    return true

end

function AI:canBribe(building)
    return (building and building.health > 0 and not building.bribed and building.owner == self.player)
end

return AI
