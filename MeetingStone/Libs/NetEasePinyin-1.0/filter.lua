
local tonumber = tonumber
local gsub = gsub

BuildModule('NetEasePinyin-1.0')

function unchinesefilter(data)
    return gsub(data, 'u(%x+)', function(x)
        local b = tonumber(x, 16)
        return b >= 0x80 and (b < 0x4e00 or b > 0x9fa5) and ''
    end)
end

function uncharfilter(data)
    return gsub(data, 'u(%x+)', function(x)
        local b = tonumber(x, 16)
        return b < 0x80 and not (
            (b >= 0x30 and b <= 0x39) or
            (b >= 0x41 and b <= 0x5a) or
            (b >= 0x61 and b <= 0x7a)
        ) and ''
    end)
end

function numberfilter(data)
    return gsub(data, 'u(%x+)', function(x)
        local b = tonumber(x, 16)
        return b >= 0x30 and b <= 0x39 and ''
    end)
end

function assicfilter(data)
    return gsub(data, 'u(%x+)', function(x)
        return tonumber(x, 16) < 0x80 and ''
    end)
end