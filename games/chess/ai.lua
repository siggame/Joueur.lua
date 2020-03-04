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

--- this is called when the game"s state updates, so if you are tracking anything you can update it here.
function AI:gameUpdated()
    -- replace with your game updated logic
end

--- this is called when the game ends, you can clean up your data and dump files here if need be
-- @tparam boolean won true means you won, won == false means you lost
-- @tparam string reason why you won or lost
function AI:ended(won, reason)
    -- replace with your ended
end

function prettyFEN(fen, us)
    -- split the FEN string up to help parse it
    local split = fen:split(" ")
    local first = split[1] -- the first part is always the board locations

    local sideToMove = split[2] -- always the second part for side to move
    local usOrThem = sideToMove == us[1] and "us" or "them"

    local fullmove = split[6] -- always the sixth part for the full move

    local lines = first:split("/")
    local strings = Table()
    strings:insert("Move: " .. fullmove .. "\nSide to move: " .. sideToMove .. " (" .. usOrThem .. ")\n   +-----------------+")

    for i, line in ipairs(lines) do
        strings:insert("\n " .. (9 - i) .. " |")
        for char in line:gmatch(".") do
            local charAsByte = string.byte(char)
            if charAsByte < string.byte("0") or charAsByte > string.byte("9") then
                strings:insert(" " .. char)
            else -- it is a number, so that many blank lines
                for i = 1, charAsByte - string.byte("0") do
                    strings:insert(" .")
                end
            end
        end
        strings:insert(" |")
    end
    strings:insert("\n   +-----------------+\n     a b c d e f g h\n")

    return strings:concat("")
end

-- Game Logic Functions: functions you must fill out to send data to the game server to actually play the game! --

--- This is called every time it is this AI.player"s turn to make a move.
-- @treturn string A string in Universal Chess Inferface (UCI) or Standard Algebraic Notation (SAN) formatting for the move you want to make. If the move is invalid or not properly formatted you will lose the game.
function AI:makeMove()
    print(prettyFEN(self.game.fen, self.player.color))

    -- This will only work if we are black move the pawn at b2 to b3.
    -- Otherwise we will lose.
    -- Your job is to code SOMETHING to parse the FEN string in some way to
    -- determine a valid move, in UCI format.
    return "b2b3"
end

return AI
