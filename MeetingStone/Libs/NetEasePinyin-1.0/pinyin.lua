
local tonumber = tonumber
local format = string.format
local strsplit = strsplit
local strbyte, strchar, gsub = string.byte, string.char, gsub

local print = print

BuildModule('NetEasePinyin-1.0')

local function getpinyin(value)
    local index = (value - 0x4e00) * 2 + 1
    local shengmu, yunmu = strbyte(PINYIN_DATA, index), strbyte(PINYIN_DATA, index + 1)

    if not shengmu or not yunmu then
        return ''
    end
    if shengmu == 0 and yunmu == 0 then
        return ''
    end
    if shengmu == nil or yunmu == nil then return '' end
    return format(':%s%s:', strchar(shengmu), strchar(yunmu))
end

local function pinyinchar(value)
    if value < 0x4e00 or value > 0x9fa5 then
        return utf8char(value)
    end
    return getpinyin(value) or utf8char(value)
end

function utf8topinyin(data)
    return (gsub(data, 'u(%x+)', function(x)
        return pinyinchar(tonumber(x, 16))
    end))
end

function topinyin(data)
    return utf8topinyin(toutf8(data))
end

function topattern(data)
    return (topinyin(data):gsub('%%h', PINYIN_PATTERN))
end
