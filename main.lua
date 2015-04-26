require("utilities.table") -- extends the base table metatable
require("utilities.string") -- extends the base string metatable
local Client = require("client")
local argparse = require("utilities.argparse")

local parser = argparse():description("Runs the Cadre Lua client to connect to a game server and play games with its AI.")
parser:option("-g", "--game"):description("the game name you want to play on the server")
parser:option("-s", "--server"):description("the host server you want to connect to e.g. localhost:3000"):default("localhost")
parser:option("-p", "--port"):description("port to connect to host server through"):default('3000')
parser:option("-n", "--name"):description("the name you want to use as your AI's player name")
parser:option("-S", "--session"):description("the game session you want to play in on the server"):default("*")
parser:flag("--printIO"):description("(debugging) print IO through the TCP socket to the terminal")

local args = parser:parse()

local splitServer = args.server:split(":")
args.server = splitServer[1]
args.port = tonumber(splitServer[2] or args.port)

if not args.game then
    print("game name required via -g or --game")
    os.exit()
end

local game = require(args.game .. ".game")()
local ai = require(args.game .. ".ai")(game)

local client = Client(game, ai, args.server, args.port, args.session, args)
client:ready(args.name)
