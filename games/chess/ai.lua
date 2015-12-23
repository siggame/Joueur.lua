-- This is where you build your AI for the Chess game.

local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")

--- @class AI: the AI functions for the Chess game.
local AI = class(BaseAI)

-- this is the name you send to the server to play as.
function AI:getName()
    return "Chess Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!
end

function AI:start()
    -- replace with your start logic
end

-- this is called when the game's state updates, so if you are tracking anything you can update it here.
function AI:gameUpdated()
    -- replace with your game updated logic
end

--- this is called when the game ends, you can clean up your data and dump files here if need be
-- @param {boolean} won == true means you won, won == false means you lost
-- @param {string} reason you won or lost
function AI:ended(won, reason)
    -- replace with your ended
end

--- Game Logic Functions: functions you must fill out to send data to the game server to actually play the game! ---

--- This is called every time the AI is asked to respond with a command during their turn
-- @returns {boolean} represents if you want to end your turn. true means end the turn, false means to keep your turn going and re-call runTurn()
function AI:runTurn()
    -- Here is where you'll want to code your AI.

    -- We've provided sample code that:
    --    1) prints the board to the console
    --    2) prints the opponent's last move to the console
    --    3) prints how much time remaining this AI has to calculate moves
    --    4) makes a random (and probably invalid) move.

    -- 1) print the board to the console
    for file = 9, -1, -1 do
        local str = ""
        if file == 9 or file == 0 then -- the top or bottom of the board
            str = "   +------------------------+"
        elseif file == -1 then -- show the ranks
            str = "     a  b  c  d  e  f  g  h"
        else -- board
            str = " " .. file .. " |"
            -- fill in all the ranks with pieces at the current rank
            for rankOffset = 0, 7 do
                local rank = string.char(string.byte("a") + rankOffset) -- start at a, with with rank offset increasing the char
                local currentPiece = nil
                for i, piece in ipairs(self.game.pieces) do
                    if piece.rank == rank and piece.file == file then -- we found the piece at (rank, file)
                        currentPiece = piece
                        break
                    end
                end

                local code = "." -- default "no piece"
                if currentPiece then
                    code = currentPiece.type:sub(1, 1) -- the code will be the first character of their type, e.g. 'Q' for "Queen"

                    if currentPiece.type == "Knight" then -- 'K' is for "King", we use 'N' for "Knights"
                        code = "N"
                    end

                    if currentPiece.owner.id == "1" then -- the second player (black) is lower case. Otherwise it's upppercase already
                        code = code:lower()
                    end
                end

                str = str .. " " .. code .. " "
            end

            str = str .. "|"
        end

        print(str)
    end

    -- 2) print the opponent's last move to the console
    if #self.game.moves > 0 then
        print("Opponent's Last Move: '" .. self.game.moves[#self.game.moves] .. "'")
    end

    -- 3) print how much time remaining this AI has to calculate moves
    print("Time Remaining: " .. self.player.timeRemaining .. " ns")

    -- 4) make a random (and probably invalid) move.
    local randomPiece = self.player.pieces:randomElement()
    local randomRank = string.char(string.byte("a") + math.random(8) - 1)
    local randomFile = math.random(8)
    randomPiece:move(randomRank, randomFile)

    return true -- to signify we are done with our turn.
end

return AI
