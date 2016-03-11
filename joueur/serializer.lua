-- Serializer: functions to serialize and unserialize json communications strings
local class = require("joueur.utilities.class")
local BaseGameObject = require("joueur.baseGameObject")

local serializer = {}

function serializer.isEmptyExceptFor(obj, key)
    if type(obj) ~= "table" then
        return false
    end

    local firstKey = next(obj)
    local secondKey = next(obj, firstKey)
    return firstKey == key and secondKey == nil
end

function serializer.isGameObjectReference(obj)
    return serializer.isEmptyExceptFor(obj, 'id')
end

function serializer.serialize(data)
    if type(data) ~= "table" then
        return data
    end

    if class.isInstance(data, BaseGameObject) then
        return {id = data.id}
    end

    local serialized = Table()

    for key, value in pairs(data) do
        if type(value) == "table" then
            serialized[key] = serializer.serialize(value)
        else
            serialized[key] = value
        end
    end

    return serialized
end

function serializer.deserialize(data, game)
    if type(data) ~= "table" then
        return data
    end

    if serializer.isGameObjectReference(data) then
        return game:getGameObject(data.id)
    end

    local deserialized = Table()

    for key, value in pairs(data) do
        if type(value) == "table" then
            deserialized[key] = serializer.deserialize(value, game)
        elseif value == serializer.null then
            deserialized[key] = nil -- yes, this means nothing because it is already nil, but you get the idea
        else
            deserialized[key] = value
        end
    end

    return deserialized
end

serializer.null = "&NULL" -- used for json because turning null to nil means the key is deleted in parsed json structures

return serializer
