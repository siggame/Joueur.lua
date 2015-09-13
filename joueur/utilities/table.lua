-- extensions/table - add more table functions
-- @author Jacob Fischer, jacob.t.fischer@gmail.com

---
-- returns a normal table {}, but with the 'table' metadata set, because unlike strings in lua tables do not get their metatable automatically set :(
Table = function(...)
    return setmetatable({...}, {__index=table})
end

---
-- sets the passed in table's metatable to the 'table' metatable.
Tableize = function(tbl)
    tbl = setmetatable(tbl, {__index=table})
    return tbl
end

---
-- Checks to see if a table contains an item.
-- @param tbl Table to check
-- @param item item to find in table
-- @return the key of the item if found
function table.contains(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then
            return key
        end
    end
end

---
-- @see table.contains
table.indexOf = table.contains

---
-- inverse of table.contains
-- @see table.contains
function table.doesNotContain(tbl, item)
    return not table.contains(tbl, item)
end


--- checks to see if a table contains all the passed in items
-- @param tbl Table to check
-- @param ... items to check for
-- @return true if tbl contains ALL the items, false otherwise
function table.containsAll(tbl, ...)
    local items = {...}
    for key, value in pairs(tbl) do
        for i, item in ipairs(items) do
            if value == item then
                table.remove(items, i)
                if #items == 0 then
                    return true
                end
            end
        end
    end
    return false
end
function table:doesNotContainAll(...) return not self:containsAll(...) end

--- checks to see if a table contains any the passed in items
-- @param tbl Table to check
-- @param ... items to check for
-- @return key of the first item found, nil otherwise
function table.containsAny(tbl, ...)
    local items = Table()
    for key, value in pairs(tbl) do
        for i, item in ipairs(items) do
            if value == item then
                return i
            end
        end
    end
end
function table:doesNotContainAny(...) return not self:containsAny(...) end

---
-- Reverses indexed tables.
-- @param tbl table to reverse
-- @return a new tabled of reversed indexes from table
function table.reverse (tbl)
    local reversed = Table()

    for i = 0, #tbl-1 do
        reversed:insert(tbl[#tbl - i])
    end

    return reversed
end

---
-- Removes the last element from the table and returns it. (pop back, because it is the fastest in Lua)
-- @param tbl the table to pop an item off
-- @return popped item from tbl
function table.pop(tbl)
    local popped = tbl[#tbl]
    table.remove(tbl, #tbl)
    return popped
end

---
-- more verbose was of saying pop, for clarity when coding
-- @see table.pop
table.popBack = table.pop

---
-- pops the front of the table and returns it. slower than popBack because every item after the front must be moved down.
-- @param tbl to pop
-- @return popped item from tbl
function table.popFront(tbl)
    local popped = tbl[1]
    table.remove(tbl, 1)
    return popped
end

---
-- Simple syntaxtical sugar for tbl[1], or the first element from pairs(tbl).
function table.first(tbl)
    if tbl[1] then
        return tbl[1]
    end
    for i, value in pairs(tbl) do
        return value
    end
end

---
-- Simple syntactical sugar for tbl[#tbl].
function table.last(tbl, offset)
    return tbl[#tbl + (offset or 0)]
end

--- Removes a value from a table (instead of a value based on key in table.remove).
-- @param tbl the table to remove the value from
-- @param value the value to find and remove
-- @return the key/index of where the value was
function table.removeValue(tbl, value)
    for k, v in pairs(tbl) do
        if value == v then
            table.remove(tbl, k)
            return k
        end
    end
end

---
-- Simple syntaxtical sugar for table.insert(tbl, 1, value).
function table.pushFront(tbl, value)
    table.insert(tbl, 1, value)
end

---
-- Does a shallow copy to a table from another.
-- @param to the table to copy to, or if not copying from makes a shallow copy of
-- @param from (Optional) the table to copy from onto to
-- @return if no from then returns a shallow copy of to
function table.copy(to, from)
    if from then
        for k, v in pairs(from) do
            to[k] = v
        end
        return to
    else
        local duplicate = Table()
        if to then
            for k, v in pairs(to) do
                duplicate[k] = v
            end
        end
        return duplicate
    end
end

---
-- Does a deep copy to a table from another table using recursion.
-- @param to the table to deep copy to from from
-- @param from the table to deep copy from to to
function table.deepCopy(to, from) -- you better not have any cycles with this
    for key, value in pairs(from or Table()) do
        if type(value) == "table" then
            to[key] = to[key] or Table()
            if type(to[key]) ~= "table" then
                to[key] = Table()
            end
            table.deepCopy(to[key], value)
        else
            to[key] = value
        end
    end
    
    return to
end


---
-- Counts the number of elements (optionally matching an element) in a table, assuming it's not indexed.
-- @param tbl the table to count from
-- @param find (Optional) the element to count
-- @return how many times it found find, or the size of the table
function table.count(tbl, find)
    if not tbl then
        return nil
    end
    
    local i = 0
    for key, value in pairs(tbl) do
        if not find or find == value then
            i = i + 1
        end
    end
    return i
end

---
-- Sets every element in the table to nil.
-- @param tbl the table to clear
function table.empty(tbl)
    for key, value in pairs(tbl) do
        tbl[key] = nil
    end

    return tbl
end

---
-- Checks if the table is empty, simple syntactical sugar for not next(tbl)
-- @return boolean representing if the table is empty
function table.isEmpty(tbl)
    return not next(tbl)
end

---
-- Converts every element in a table using a function.
-- @param t table to use the converter on
-- @param converter a function that takes an element from the table t and returns a converted value to store back in t
-- @return a new converted table
function table.convert(t, converter) -- TODO: should t be overwritten with c?
    local c = Table()
    for k, v in pairs(t) do
        c[k] = converter(v)
    end
    return c
end

---
-- Slices the indexed table from start to to, like a string
-- @param t table to slice
-- @param start number to start slicing from
-- @param to where to stop slicing
-- @return a new table of the sliced elements from t
function table.slice(t, start, to)
    local sliced = Table()
    for i = start, to do
        sliced:insert(t[i])
    end
    return sliced
end

--- sums up a property of an indexed table
-- @param tbl table to sum up
-- @param ... property of every element in the table to sum
-- @return sum of every element[property] in the table
function table.sum(tbl, ...)
    local sum = 0
    for i, v in ipairs(tbl) do
        local value = table.traverse(v, ...)
        if value then
            sum = sum + value
        end
    end
    return sum
end

--- averages a property of an indexed table
-- @param tbl table to sum up
-- @param .... property of every element in the table to average
-- @return average of every element[property] in the table
function table.average(tbl, ...)
    if #tbl == 0 then
        return 0
    end
    return table.sum(tbl, ...)/#tbl
end

--- returns all the tables passed in joined, for easy iterating over
function table.join(...)
    local joined = Table()
    
    for i, tbl in ipairs({...}) do
        for i, v in ipairs(tbl) do
            joined:insert(v)
        end
    end
    
    return joined
end

--- Inserts all the values from one table into another
-- @param tbl the table to insert values into
-- @param fromTable table get the values to insert into tbl
function table.insertFrom(tbl, fromTable)
    for i, v in ipairs(fromTable) do
        table.insert(tbl, v)
    end
end

--- Removes all the values from a table when the whereFunction returns truthy.
-- Does not use table.remove, because that would be O(N^2). Instead because we
-- know we'll could removing multiple values we don't shift the elements down
-- after every removal, instead we only shift after all removals.
-- @param tbl table to remove things from
-- @param whereFunction function that should return if that passed in value should be removed
function table.removeWhere(tbl, whereFunction)
    local n = #tbl

    for i = 1, n do
        if whereFunction(tbl[i]) then
            tbl[i] = nil
        end
    end
    
    local j = 0
    for i = 1, n do
        if tbl[i] ~= nil then
            j = j + 1
            tbl[j] = tbl[i]
        end
    end
    
    for i = j + 1, n do
        tbl[i] = nil
    end
    
    return tbl
end

--- Removes all the found values from the table safely.
-- @param tbl table to remove values from
-- @param ... values to remove from tbl
-- @example Table("alpha", "beta", "charlie", "delta", "gamma"):removeValues("beta", "charlie", "gamma")   ->   {"alpha", "delta"}
function table.removeValues(tbl, ...)
    local remove = Table(...)
    return table.removeWhere(tbl, function(tablesValue) 
        return remove:contains(tablesValue)
    end)
end

--- unpacks a table for table.removeValues
-- @see table.removeValues
function table.removeValuesFrom(tbl, fromTable)
    return table.removeValues(tbl, unpack(fromTable))
end

-- @return random element from the table
function table.randomElement(tbl)
   return tbl[math.random(#tbl)]
end

--- swaps the two keys values in a table
-- @param tbl table to swap key/values in
-- @index1 first key you want to swa the value with index2
-- @index2 second key you want to swap the value with index1
function table.swap(tbl, index1, index2)
    tbl[index1], tbl[index2] = tbl[index2], tbl[index1]
end

--- suffles the passed in table randomly
-- @param tbl table to suffle randomly
function table.shuffle(tbl)
    local counter = #tbl
    while counter > 1 do
        local index = math.random(counter)
        table.swap(tbl, index, counter)
        counter = counter - 1
    end
    return tbl
end

-- @return indexed table of the non indexed keys in tbl
function table.keys(tbl)
    local keys = Table()
    for key, value in pairs(tbl) do
        keys:insert(key)
    end
    return keys
end

-- @return indexed table of the non indexed values in tbl
function table.values(tbl)
    local values = Table()
    for key, value in pairs(tbl) do
        values:insert(value)
    end
    return values
end

--- inserts the element if it is not present
-- @return boolean representing if the element was inserted
function table.insertIfAbsent(tbl, element, ...)
    if table.doesNotContain(tbl, element) then
        table.insert(tbl, element, ...)
        return true
    end
    return false
end

-- @param key (optional) key to sort on for each element in tbl
function table.sortAscending(tbl, key)
    table.sort(tbl, function(a, b)
        if key then
            return a[key] < b[key]
        else
            return a < b
        end
    end)

    return tbl
end

-- @param key (optional) key to sort on for each element in tbl
function table.sortDescending(tbl, key)
    table.sort(tbl, function(a, b)
        if key then
            return a[key] > b[key]
        else
            return a > b
        end
    end)
    
    return tbl
end

---
-- copies values from a given table onto another table, similar to jQuery's extend
-- @param tbl to copy ONTO
-- @param coptFrom table to copy values on top of tbl
function table.extend(tbl, copyFrom)
    tbl = tbl or Table()
    for key, value in pairs(copyFrom) do
        tbl[key] = value
    end
    
    return tbl
end
