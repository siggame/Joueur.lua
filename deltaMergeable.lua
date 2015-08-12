local class = require("utilities.class")

-- @class DeltaMergeable: Basically a class that has attributes to be delta merged and made read only as properties
local DeltaMergeable = class()

function DeltaMergeable:init(deltaMergeables)
    self._deltaMergeables = self._deltaMergeables or {}

    if deltaMergeables then
        for key, property in pairs(deltaMergeables) do
            self._deltaMergeables[key] = {value = property.value}
        end
    end
end

-- this make sure you are not trying to set the value directly of a field that is delta mergeable
function DeltaMergeable:__newindex(index, value)
    assert(not self._deltaMergeables or not self._deltaMergeables[index]) -- make sure they are setting either self._deltaMergeables OR an index not in self._deltaMergeables. If both fail then they are trying to set a read only property
    rawset(self, index, value)
end

-- this gets the value of an index, to make delta mergeable fields appear like normal indexes
function DeltaMergeable:__index(index)
    if index ~= "_deltaMergeables" and self._deltaMergeables[index] then
        return self._deltaMergeables[index].value
    else
        return rawget(self, index) or getmetatable(self)[index]
    end
end

-- this should only be used by GameManagers to set the delta mergeable properties
function DeltaMergeable:_setProperty(index, value)
    assert(self._deltaMergeables[index])
    self._deltaMergeables[index].value = value
end

return DeltaMergeable
