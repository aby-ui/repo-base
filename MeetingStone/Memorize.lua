
local setmetatable = setmetatable
local wipe = wipe
local unpack = unpack
local select = select

BuildModule('NetEaseMemorize-1.0')

function normal(fn)
    local db = setmetatable({}, {
        __mode = 'k',
        __index = function(t, k)
            local v = fn(k)
            t[k] = v
            return v
        end
    })

    local function check(k)
        if k == nil then
            return fn(k)
        end
        return db[k]
    end

    local function clear()
        wipe(db)
    end
    return check, clear
end

local function rets(...)
    return {count = select('#', ...), ...}
end

function multirets(fn)
    local db = setmetatable({}, {__mode = 'kv',})

    local function check(k)
        if k == nil then
            return fn(k)
        end
        local v = db[k]
        if not v then
            v = rets(fn(k))
            db[k] = v
        end
        return unpack(v, 1, v.count)
    end

    local function clear()
        wipe(db)
    end
    return check, clear
end