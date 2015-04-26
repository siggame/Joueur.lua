-- Serializer: functions to serialize and unserialize json communications strings
local class = require("utilities.class")
local BaseGameObject = require("baseGameObject")

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
    local serialized = {}

    for key, value in pairs(data) do
        if class.isInstance(value, BaseGameObject) then
            serialized[key] = {id = value.id}
        elseif type(value) == "table" then
            serialized[key] = serializer.serialize(value)
        else
            serialized[key] = value
        end
    end

    return serialized
end

serializer.null = "&NULL" -- used for json because turning null to nil means the key is deleted in parsed json structures

return serializer
