
local band, bor, rshift = bit.band, bit.bor, bit.rshift
local format, strchar, gsub = string.format, string.char, gsub
local tonumber = tonumber
local tinsert, tconcat = table.insert, table.concat

BuildModule('NetEasePinyin-1.0')

local head = {
    0x00, 0xC0, 0xE0, 0xF0
}

local function tobin(b, h, l)
    local r = ''
    for i = h, l, -1 do
        r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0')
    end
    return r
end

function utf8char(value)
    if value < 0x80 then
        return strchar(value), 1
    end
    local cache = {}
    repeat
        tinsert(cache, 1, band(value, 0x3F))
        value = rshift(value, 6)
    until value == 0
    
    cache[1] = strchar(bor(cache[1], head[#cache]))
    
    for i = 2, #cache do
        cache[i] = strchar(bor(cache[i], 0x80))
    end
    return tconcat(cache)
end

function toutf8(data)
    return gsub(data, '.', function(x)
        local b = x:byte()
        if band(b, 0xC0) == 0xC0 then           -- 110xxxxx 10xxxxxx
            return 'u' .. tobin(b, 5, 1)
        elseif band(b, 0xE0) == 0xE0 then       -- 1110xxxx 10xxxxxx 10xxxxxx
            return 'u' .. tobin(b, 4, 1)
        elseif band(b, 0xF0) == 0xF0 then       -- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
            return 'u' .. tobin(b, 3, 1)
        elseif band(b, 0x80) == 0x80 then
            return tobin(b, 6, 1)
        elseif b < 0x80 then
            return 'u' .. tobin(b, 8, 1)
        else
            error('haha')
        end
    end):gsub('([01]+)', function(x)
        return format('%04x', tonumber(x, 2))
    end)
end

function utf8tostring(data)
    return (gsub(data, 'u(%x+)', function(x)
        return utf8char(tonumber(x, 16))
    end))
end