local color = require("joueur.ansiColorCoder")
local handleErrorMetatable = {}

local errorCodes = {
    NONE = 0,
    INVALID_ARGS = 20,
    COULD_NOT_CONNECT = 21,
    DISCONNECTED_UNEXPECTEDLY = 22,
    CANNOT_READ_SOCKET = 23,
    DELTA_MERGE_FAILURE = 24,
    REFLECTION_FAILED = 25,
    UNKNOWN_EVENT_FROM_SERVER = 26,
    SERVER_TIMEOUT = 27,
    FATAL_EVENT = 28,
    GAME_NOT_FOUND = 29,
    MALFORMED_JSON = 30,
    UNAUTHENTICATED = 31,
    AI_ERRORED = 42,
}

function handleErrorMetatable:__call(codeName, message, err)
    print(color.text("red") .. "---\nError:", codeName, "\n")

    if message then
        print(message .. "\n---")
    end

    if err then
        print(tostring(err) .. "\n---")
    end

    print(debug.traceback() .. "\n---" .. color.reset())

    if self.socket then
        self.socket:close()
    end

    os.exit(errorCodes[codeName])
end

return setmetatable({}, handleErrorMetatable)
