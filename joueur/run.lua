local color = require("joueur.ansiColorCoder")

local function isModuleAvailable(name)
    if package.loaded[name] then
        return true
    else
        for _, searcher in ipairs(package.searchers or package.loaders) do
            local loader = searcher(name)
            if type(loader) == 'function' then
                package.preload[name] = loader
                 return true
            end
        end
        return false
    end
end

return function(args)
    local client = require("joueur.client")
    local GameManager = require("joueur.gameManager")
    local safeCall = require("joueur.safeCall")
    local handleError = require("joueur.handleError")

    local splitServer = args.server:split(":")
    args.server = splitServer[1]
    args.port = tonumber(splitServer[2] or args.port)

    local game, ai = nil, nil

    if not isModuleAvailable("games." .. args.game:uncapitalize() .. ".game") then
        handleError("GAME_NOT_FOUND", "Could not find game files for '" .. args.game .. "'")
    end

    safeCall(function()
        game = require("games." .. args.game:uncapitalize() .. ".game")()
    end, "REFLECTION_FAILED", "Error requiring the Game module for '" .. args.game .. "'.")

    safeCall(function()
        ai = require("games." .. args.game:uncapitalize() .. ".ai")(game)
    end, "AI_ERRORED", "Could not require the AI for game '" .. args.game .. "'. Probably a syntax error in your AI.")

    local gameManager = GameManager(game)

    client:setup(game, ai, gameManager, args.server, args.port, args)

    client:send("play", {
        gameName = args.game,
        requestedSession = args.session,
        clientType = "Lua",
        playerName = args.name or ai:getName() or "Lua Player",
        playerIndex = args.index,
        password = args.password,
        gameSettings = args.gameSettings,
    })

    local lobbyData = client:waitForEvent("lobbied")

    print(color.text("cyan") .. "In lobby for game '" .. lobbyData.gameName .. "' in session '" .. lobbyData.gameSession .. "'." .. color.reset())

    gameManager:setConstants(lobbyData.constants)

    local startData = client:waitForEvent("start")

    print(color.text("green") .. "Game is starting." .. color.reset())

    ai:setPlayer(game:getGameObject(startData.playerID))
    safeCall(function()
        ai:start()
        ai:gameUpdated()
    end, "AI_ERRORED", "AI errored when game starting.")

    client:play()
end
