
--[[

by ldz5

--]]

local MAJOR, MINOR = "NetEaseBase64-1.0", 1
local Base64, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not Base64 then return end

local BASE64_KEY = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local strchar, tonumber, random, type = string.char, tonumber, fastrandom, type
local tinsert, tremove, tconcat = table.insert, table.remove, table.concat

local tobin = setmetatable({}, {__index = function(o, x)
    local b = x:byte()
    local r = ''
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    o[x] = r
    return r
end})

local debin = setmetatable({
    ['='] = '',
}, {__index = function(o, x)
    local r,f='',(BASE64_KEY:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    o[x]=r
    return r
end})

local tonum = setmetatable({}, {__index = function(o, x)
    o[x] = #x ~= 8 and '' or strchar(tonumber(x, 2))
    return o[x]
end})

function Base64:EnCode(data, key)
    local b = key or BASE64_KEY
    return ((data:gsub('.', tobin)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=tonumber(x,2)+1
        return b:sub(c,c)
    end))
end

function Base64:DeCode(data, key)
    local b = key or BASE64_KEY
    data = data:gsub('[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', tonum))
end

function Base64:CreateKey()
    local src, dest = {}, {}
    for i = 1, #BASE64_KEY do
        tinsert(src, BASE64_KEY:sub(i, i))
    end
    while #src > 0 do
        local index = random(1, #src)
        tinsert(dest, src[index])
        tremove(src, index)
    end
    return tconcat(dest)
end

local VALID_REGEX = '^[' .. BASE64_KEY .. ']+$'
function Base64:IsValid(str)
    if type(str) ~= 'string' then
        return
    end
    return not not str:find(VALID_REGEX)
end