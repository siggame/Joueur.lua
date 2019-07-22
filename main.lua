-- Please do not modify this file.
-- Instead have a look at `README.md` for how to start writing you AI.

require("joueur.utilities.table") -- extends the base table metatable
require("joueur.utilities.string") -- extends the base string metatable
local argparse = require("joueur.utilities.argparse")
local run = require("joueur.run")

io.stdout:setvbuf 'no' -- Make stdout unbuffered so we get immediate feedback when running inside a non-terminal like docker

local parser = argparse():description("Runs the Cadre Lua client to connect to a game server and play games with its AI.")
parser:argument("game"):description("the name of the game you want to play on the server")
parser:option("-s", "--server"):description("the hostname of the server you want to connect to e.g. localhost:3000"):default("localhost")
parser:option("-p", "--port"):description("port to connect to host server through"):default("3000")
parser:option("-n", "--name"):description("the name you want to use as your AI's player name")
parser:option("-i", "--index"):description("the player number you want to be, with 0 being the first player")
parser:option("-w", "--password"):description("the password required for authentication on official servers")
parser:option("-r", "--session"):description("the requested game session you want to play in on the server"):default("*")
parser:option("--gameSettings"):description("Any settings for the game server to force. Must be url parms formatted (key=value&otherKey=otherValue)")
parser:option("--aiSettings"):description("Any settings for the AI. Delimit pairs by an ampersand (key=value&otherKey=otherValue)")
parser:flag("--printIO"):description("(debugging) print IO through the TCP socket to the terminal")

run(parser:parse())
