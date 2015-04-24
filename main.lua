require("utilities.table") -- extends the base table metatable
require("utilities.string") -- extends the base string metatable
local argparse = require("utilities.argparse")

local parser = argparse():description("Runs the Cadre Lua client to connect to a game server and play games with its AI.")
parser:option("-g", "--game"):description("the game name you want to play on the server")
parser:option("-h", "--host"):description("the host server you want to connect to e.g. locahost:3000")
parser:option("-p", "--port"):description("port to connect to host server through")
parser:option("-n", "--name"):description("the name you want to use as your AI's player name")
parser:option("-s", "--session"):description("the game session you want to play in on the server"):default("*")

local args = parser:parse()

if args.host then
    local split = args.host:split(":")
    args.host = split[0] or "localhost"
    args.port = tonumber(args.port or (#split == 2 and split[1]) or 3000)
end

if not args.game then
    print("game name required via -g or --game")
    os.exit()
end

local game = require(args.game .. ".game")(args.session)
local ai = require(args.game .. ".ai")(game)

client = require("client")(game, ai, host, port)
client:ready(args.name)
