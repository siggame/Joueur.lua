local _style = {
    none = 0,
    bold = 1,
    underline = 4,
    blink = 5,
    inverse = 7,
    hidden = 8,
}

local _text = {
    black = 30,
    red = 31,
    green = 32,
    yellow = 33,
    blue = 34,
    magenta = 35,
    cyan = 36,
    white = 37,
    default = 39,
}

local _background = {
    black = 40,
    red = 41,
    green = 42,
    yellow = 43,
    blue = 44,
    magenta = 45,
    cyan = 46,
    white = 47,
    default = 49,
}

local function ansi(num)
    num = num or 0
    return string.char(27) .. '[' .. tostring(num) .. 'm'
end

return {
    style = function(key)
        return ansi(_style[key or "none"])
    end,

    text = function(key)
        return ansi(_text[key or "default"])
    end,

    background = function(key)
        return ansi(_background[key or "default"])
    end,

    reset = function()
        return ansi(0)
    end,
}
