-------------------------------------------------------------------------------
-- Class: A simple class function to create class like table objects. Supports multiple inheritance
-- @author Jacob Fischer, jacob.t.fischer@gmail.com
-- adopted from http://lua-users.org/wiki/SimpleLuaClasses
-- supports multiple inheritance
-------------------------------------------------------------------------------

local classMetatable = {}

---
-- creates a table that contains the class "instance". passed in other classes make up the parent classes
-- @param ... parent classes to inherit from
-- @return new class "instance" as a table
classMetatable.__call = function(...)
    local bases = {...}
    local c = {}    -- a new class instance
    
    for i = #bases, 1, -1 do -- in the reverse order so the first base takes the most priority with inherited attributes
        -- our new class is a shallow copy of the base class!
        for k,v in pairs(bases[i]) do
            c[k] = v
        end
    end
    
    c._bases = bases
    c._class = c
    -- the class will be the metatable for all its objects,
    -- and they will look up their methods in it.
    c.__index = c
    
    -- expose a constructor which can be called by <classname>(<args>)
    local mt = {}
    mt.__call = function(class_tbl, ...)
        local obj = {}
        setmetatable(obj,c)
        if class_tbl.init then
            class_tbl.init(obj, ...)
        end
        return obj
    end
    
    ---
    -- checks if this object is an instance of one of the passed in classes
    -- @param ... classes to check for (it will check inherited classes)
    c.isA = function(self, ...)
        local baseClasses = {getmetatable(self)}
        local isClasses = {...}
        while #baseClasses > 0 do
            local baseClass = baseClasses[#baseClasses]
            baseClasses[#baseClasses] = nil
            
            for i, isClass in ipairs(isClasses) do
                if baseClass == isClass then
                    return true
                end
            end
            
            for i, base in ipairs(baseClass._bases) do
                table.insert(baseClasses, base)
            end
        end
        return false
    end
    
    ---
    -- checks if this object is NOT an instance of one of the passed in classes
    -- @see c.isA
    c.isNotA = function(self, ...)
        return not self:isA(...)
    end
    
    setmetatable(c, mt)
    return c
end


-- class utility functions --

local class = {}

---
-- @param obj to check if it is a class
-- @param ofClass (optional) class to check if the passed in object is an instance of
class.isInstance = function(obj, ofClass)
    if type(obj) == "table" and obj._class then
        if ofClass then
            return obj:isA(ofClass)
        else
            return true
        end
    end

    return false
end

return setmetatable(class, classMetatable)
