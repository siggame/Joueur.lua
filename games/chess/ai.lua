-- This is where you build your AI for the Chess game.

local class = require("joueur.utilities.class")
local BaseAI = require("joueur.baseAI")

--- the AI functions for the Chess game.
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
    return "Chess Lua Player" -- REPLACE THIS WITH YOUR TEAM NAME!
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
    -- Here is where you'll want to code your AI.

    -- We've provided sample code that:
    --    1) prints the board to the console
    --    2) prints the opponent's last move to the console
    --    3) prints how much time remaining this AI has to calculate moves
    --    4) makes a random (and probably invalid) move.

    -- 1) print the board to the console
    self:printCurrentBoard()

    -- 2) print the opponent's last move to the console
    if #self.game.moves > 0 then
        print("Opponent's Last Move: '" .. self.game.moves[#self.game.moves].san .. "'")
    end

    -- 3) print how much time remaining this AI has to calculate moves
    print("Time Remaining: " .. self.player.timeRemaining .. " ns")

    -- 4) make a random (and probably invalid) move.
    local randomPiece = self.player.pieces:randomElement()
    local randomFile = string.char(string.byte("a") + math.random(8) - 1)
    local randomRank = math.random(8)
    randomPiece:move(randomFile, randomRank)

    return true -- to signify we are done with our turn.
end


--- Prints the current board using pretty ASCII art
-- Note: you can delete this function if you wish
function AI:printCurrentBoard()
    for rank = 9, -1, -1 do
        local str = ""
        if rank == 9 or rank == 0 then -- the top or bottom of the board
            str = "   +------------------------+"
        elseif rank == -1 then -- show the ranks
            str = "     a  b  c  d  e  f  g  h"
        else -- board
            str = " " .. rank .. " |"
            -- fill in all the ranks with pieces at the current file
            for fileOffset = 0, 7 do
                local file = string.char(string.byte("a") + fileOffset) -- start at a, with with file offset increasing the char
                local currentPiece = nil
                for i, piece in ipairs(self.game.pieces) do
                    if piece.file == file and piece.rank == rank then -- we found the piece at (file, rank)
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
end

return AI
