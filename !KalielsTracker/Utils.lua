--- Kaliel's Tracker
--- Copyright (c) 2012-2018, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...

-- Lua API
local floor = math.floor
local fmod = math.fmod
local next = next
local strlen = string.len
local strsub = string.sub

-- Table
function KT.IsTableEmpty(table)
    return (next(table) == nil)
end

-- Map
function KT.GetMapContinents()
    return C_Map.GetMapChildrenInfo(946, Enum.UIMapType.Continent, true)
end

function KT.GetCurrentMapAreaID()
    return C_Map.GetBestMapForUnit("player")
end

function KT.GetCurrentMapContinent()
    local mapID = C_Map.GetBestMapForUnit("player")
    return MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true) or {}
end

function KT.GetMapContinent(mapID)
    return MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent, true) or {}
end

function KT.GetMapNameByID(mapID)
    local mapInfo = C_Map.GetMapInfo(mapID) or {}
    return mapInfo.name
end

function KT.SetMapToCurrentZone()
    local mapID = C_Map.GetBestMapForUnit("player")
    WorldMapFrame:SetMapID(mapID)
end

function KT.SetMapByID(mapID)
    WorldMapFrame:SetMapID(mapID)
end

-- RGB to Hex
local function DecToHex(num)
    local b, k, hex, d = 16, "0123456789abcdef", "", 0
    while num > 0 do
        d = fmod(num, b) + 1
        hex = strsub(k, d, d)..hex
        num = floor(num/b)
    end
    hex = (hex == "") and "0" or hex
    return hex
end

function KT.RgbToHex(color)
    local r, g, b = DecToHex(color.r*255), DecToHex(color.g*255), DecToHex(color.b*255)
    r = (strlen(r) < 2) and "0"..r or r
    g = (strlen(g) < 2) and "0"..g or g
    b = (strlen(b) < 2) and "0"..b or b
    return r..g..b
end