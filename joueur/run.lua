return function(args)
    local client = require("joueur.client")
    local GameManager = require("joueur.gameManager")
    local safeCall = require("joueur.safeCall")

    local splitServer = args.server:split(":")
    args.server = splitServer[1]
    args.port = tonumber(splitServer[2] or args.port)

    local game, ai, gameManager = nil, nil, nil

    safeCall(function()
        game = require("games." .. args.game .. ".game")()
        ai = require("games." .. args.game .. ".ai")(game)
        gameManager = GameManager(game)
    end, "GAME_NOT_FOUND", "Could not find game files for '" .. args.game .. "'")

    client:setup(game, ai, gameManager, args.server, args.port, args)

    client:send("play", {
        gameName = args.game,
        requestedSession = args.session,
        clientType = "Lua",
        playerName = args.playerName or ai:getName() or "Lua Player",
        password = args.password,
        gameSettings = args.gameSettings,
    })

    local lobbyData = client:waitForEvent("lobbied")

    print("In Lobby for game '" .. lobbyData.gameName .. "' in session '" .. lobbyData.gameSession .. "'")

    gameManager:setConstants(lobbyData.constants)

    local startData = client:waitForEvent("start")

    print("Game starting")

    ai:setPlayer(game:getGameObject(startData.playerID))
    safeCall(function()
        ai:start()
        ai:gameUpdated()
    end, "AI_ERRORED", "AI errored when game starting.")

    client:play()
end
