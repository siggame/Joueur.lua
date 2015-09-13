local handleError = require("joueur.handleError")

return function(pcallFunction, onErrorCodeName, onErrorMessage)
    local success, err = pcall(pcallFunction)

    if not success then
        handleError(onErrorCodeName, onErrorMessage, err)
    end
end
