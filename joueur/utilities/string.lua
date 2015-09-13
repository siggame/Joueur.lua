-- extensions/string - add more string functions
-- @author Jacob Fischer, jacob.t.fischer@gmail.com

---
-- splits the string by pattern a maxsplit number of time.
-- @param s string to split
-- @param pattern string pattern to split between, will not be part of returned strings
-- @param maxsplit (Optional) max times to split
-- @return table of split strings
function string.split(s, pattern, maxsplit)
    pattern = pattern or " "
    maxsplit = maxsplit or -1
    local t = Table()
    local patsz
    if pattern == "." then
        patsz = 1
        pattern = "%."
    else
        patsz = #pattern
    end
    
    while maxsplit ~= 0 do
        local curpos = 1
        local found = string.find(s, pattern)
        if found ~= nil then
            table.insert(t, string.sub(s, curpos, found - 1))
            curpos = found + patsz
            s = string.sub(s, curpos)
        else
            table.insert(t, string.sub(s, curpos))
            break
        end
        maxsplit = maxsplit - 1
        if maxsplit == 0 then
            table.inssert(t, string.sub(s, curpos - patsz - 1))
        end
    end
    
    return t
end

---
-- returns the string as a table of characters.
-- @param str the string to get characters from
-- @param n (Optional, defaults to 1) how many characters should be in each element of the returned table
-- @return a table of the characters in str
function string.characters(str, n)
    if not n or n < 1 then
        n = 1
    end
    
    local dots = ""
    
    for i=1,n do
        dots = "." .. dots
    end
    local strings = {}
    for c in str:gmatch(dots) do
        table.insert(strings, c)
    end
    return strings
end

---
-- Trims whitespace from both sides of a string.
-- @param s string to trim
-- @return string trimmed of whitespace on both sides
function string.trim(s)
    return s:match'^%s*(.*%S)' or ''
end

---
-- Trims whitespace from the left side of a string.
-- @param s string to trim
-- @return string trimmed of whitespace from the left side
function string.leftTrim(s)
    return s:match'^%s*(.*)'
end

---
-- Trims whitespace from the right side of a string.
-- @param s string to trim
-- @return string trimmed of whitespace from the right side
function string.rightTrim(s)
    return s:find'^%s*$' and '' or s:match'^(.*%S)'
end

---
-- escapes the gsub magic characters
-- @param str to escape
function string.literalize(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
end

--- Replaces parts of a string with a different pattern.
-- @param s string to search through
-- @param find pattern to find
-- @param pattern string to replace find with
-- @return string with find replaced with replace
function string.replace(s, find, replace)
    return s:gsub("(" .. find .. ")", replace) -- might break with certain characters
end

---
-- Removes pattern from a string
-- @param s string to search through
-- @param pattern pattern to find
-- @return string with no patterns in it
-- @see replace
function string.remove(s, ...)
    for i, pattern in ipairs({...}) do
        s = s:replace(pattern, "")
    end
    return s
end

---
-- removes whitespace from the string
-- @param str to remove whitespace from
function string.removeWhitespace(str)
    return string.gsub(str, "%s", "")
end

---
-- checks to see if the string is just some whitespace character(s)
-- @param str to check for whitespace
function string.isWhitespace(str)
    return string.removeWhitespace(str) == ""
end

---
-- checks to see if the string is NOT just some whitespace character(s)
-- @param str to check for whitespace
function string.isNotWhitespace(...)
    return not string.isWhitespace(...)
end

---
-- Checks to see if a string is one of passed in strings.
-- @param s string to check against
-- @param ... other strings to see if they are s
-- @return string it matches, or nil if it is not one of them
function string.isOneOf(s, ...)
    for i, arg in ipairs({...}) do
        if s == arg then
            return arg
        end
    end
end

---
-- Convenience Function for not string.isOneOf()
-- @see string.isOneOf
function string.isNotOneOf(...)
    return not string.isOneOf(...)
end

---
-- checks to see if a string starts with another string.
-- @param s string to check against
-- @param start string to see if is at the start
-- @return true if s starts with start
function string.starts(s, start)
    return string.sub(s, 1, string.len(start)) == start
end

---
-- checks to see if a string ends with another string.
-- @param s string to check against
-- @param ends string to see if is at the end
-- @return true if s ends with ends
function string.ends(s, ends)
   return ends == '' or string.sub(s, -string.len(ends)) == ends
end

---
-- Capitalizes the first character of a string
-- @param str to capitalize
-- @param str
function string.capitalize(str)
    return str:sub(1,1):upper() .. str:sub(2)
end

---
-- Uncapitalizes the first character of a string
-- @param str to uncapizalize
-- @return str
function string.uncapitalize(str)
    return str:sub(1,1):lower() .. str:sub(2)
end

---
-- reversed the capitalization in all characters in the string str
-- @param str to reverse the case of
function string.reverseCase(str)
    local chars = str:characters()
    local reversedCase = {}
    
    for i, char in ipairs(chars) do
        if char:upper() == char then
            reversedCase[i] = char:lower()
        else
            reversedCase[i] = char:upper()
        end
    end
    
    return table.concat(reversedCase)
end

---
-- pads a string to the left the given padding string
-- @param padding string you want to pad str with to the left
-- @param desiredLength desired length of the str with left padded string padding
function string.padLeft(str, padding, desiredLength)
    local paddedString = str
    while paddedString:length() < desiredLength do
        paddedString = padding .. paddedString
    end
    
    return paddedString
end

---
-- pads a string to the right the given padding string
-- @param padding string you want to pad str with to the right
-- @param desiredLength desired length of the str with right padded string padding
function string.padRight(str, padding, desiredLength)
    local paddedString = str
    while paddedString:length() < desiredLength do
        paddedString = paddedString .. padding
    end
    
    return paddedString
end

---
-- checks a string for a substring
-- @return boolean representing if the string contains the substring
function string:contains(substring)
    local l = self:find(substring)
    return l and true or false
end

---
-- opposite of contains
-- @see string:contains
-- @return boolean representing if the string does not contain the substring
function string:doesNotContain(substring)
    return not self:contains(substring)
end

---
-- checks a string to see if it contains multiple substrings
-- @see string:contains
function string:containsAll(...)
    for i, substring in ipairs({...}) do
        if self:doesNotContain(substring) then
            return false
        end
    end
    return true
end

---
-- checks to make sure a string does not contains any substrings
-- @see string:containsAll
function string:doesNotContainAll(...) return self:containsAll(...) end

---
-- checks to see if a string contains any of the given substrings
-- @return substring first encountered that is contained within the string
function string:containsAny(...)
    for i, substring in ipairs({...}) do
        if self:contains(substring) then
            return substring
        end
    end
end

---
-- inserts a substring into the given string at an optional location, which otherwise appends it to the end. basically table.insert for strings
-- @param string to insert onto the end of
-- @param subStr substring to insert
-- @param (optional) location to insert into str. defaults to end of str
-- @return the new string created
function string.insert(str, subStr, location)
    location = location or #str
    return str:sub(1, location) .. subStr .. str:sub(location + 1)
end

string.length = string.len
string.startsWith = string.starts
string.doesNotStartWith = function(...) return not string.startsWith(...) end
string.endsWith = string.ends
string.doesNotEndWith = function(...) return not string.endsWith(...) end
