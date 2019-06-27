local addonName, addon = ...
local libs = { "Events", "BulletinBoard", "Copyright", "Holidays", "Tooltips", "SavedVariables", "Charms", "Data", "Arrows", "Colors", "UUID", "Locales", "Books" }
local libIndexes = {}
local TomCatsLibs = {}

for i = 1, #libs do libIndexes[libs[i]] = i libs[i] = {} end

addon.name = addonName
addon.params = {}

local function index(_, libname) return libs[libIndexes[libname]] end

local function newindex() end

setmetatable(TomCatsLibs, { __index = index, __newindex = newindex })

function getTomCatsLibs(_, key)
    if (key == "TomCatsLibs") then
        local stack = debugstack(2, 1, 2)
        if (not string.find(stack, "TomCatsLibs")) then
            setmetatable(addon, {})
            addon.TomCatsLibs = TomCatsLibs
            for i = 1, #libs do
                local lib = libs[i]
                if (lib.init) then lib.init() lib.init = nil end
            end
        end
        return TomCatsLibs
    else
        return rawget(addon, key)
    end
end

setmetatable(addon, { __index = getTomCatsLibs })
