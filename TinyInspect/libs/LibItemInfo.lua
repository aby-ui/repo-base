
---------------------------------
-- 物品信息庫 Author: M
---------------------------------

local MAJOR, MINOR = "LibItemInfo.7000", 1
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end

local locale = GetLocale()

--物品等級匹配規則
local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")

--Toolip
local tooltip = CreateFrame("GameTooltip", "LibItemLevelTooltip1", UIParent, "GameTooltipTemplate")
local unittip = CreateFrame("GameTooltip", "LibItemLevelTooltip2", UIParent, "GameTooltipTemplate")

--物品是否已經本地化
function lib:HasLocalCached(item)
    if (not item or item == "" or item == "0") then return true end
    if (tonumber(item)) then
        return select(10, GetItemInfo(tonumber(item)))
    else
        local id, gem1, gem2, gem3 = string.match(item, "item:(%d+):[^:]*:(%d-):(%d-):(%d-):")
        return self:HasLocalCached(id) and self:HasLocalCached(gem1) and self:HasLocalCached(gem2) and self:HasLocalCached(gem3)
    end
end

--獲取TIP中的屬性信息 (zhTW|zhCN|enUS)
function lib:GetStatsViaTooltip(tip, stats)
    if (type(stats) == "table") then
        local line, text, r, g, b, statValue, statName
        for i = 2, tip:NumLines() do
            line = _G[tip:GetName().."TextLeft" .. i]
            text = line:GetText() or ""
            r, g, b = line:GetTextColor()
            for statValue, statName in string.gmatch(text, "%+([0-9,]+)([^%+%|]+)") do
                statName = strtrim(statName)
                statName = statName:gsub("與$", "") --zhTW
                statName = statName:gsub("，", "")  --zhCN
                statName = statName:gsub("%s*&$", "") --enUS
                statValue = statValue:gsub(",","")
                statValue = tonumber(statValue) or 0
                if (not stats[statName]) then
                    stats[statName] = { value = statValue, r = r, g = g, b = b }
                else
                    stats[statName].value = stats[statName].value + statValue
                    if (g > stats[statName].g) then
                        stats[statName].r = r
                        stats[statName].g = g
                        stats[statName].b = b
                    end
                end
            end
        end
    end
    return stats
end

-- koKR
if (locale == "koKR") then
    function lib:GetStatsViaTooltip(tip, stats)
        if (type(stats) == "table") then
            local line, text, r, g, b, statValue, statName
            for i = 2, tip:NumLines() do
                line = _G[tip:GetName().."TextLeft" .. i]
                text = line:GetText() or ""
                r, g, b = line:GetTextColor()
                for statName, statValue in string.gmatch(text, "([^%+]+)%+([0-9,]+)") do
                    statName = statName:gsub("|c%x%x%x%x%x%x%x%x", "")
                    statName = statName:gsub(".-:", "")
                    statName = strtrim(statName)
                    statName = statName:gsub("%s*/%s*", "")
                    statValue = statValue:gsub(",","")
                    statValue = tonumber(statValue) or 0
                    if (not stats[statName]) then
                        stats[statName] = { value = statValue, r = r, g = g, b = b }
                    else
                        stats[statName].value = stats[statName].value + statValue
                        if (g > stats[statName].g) then
                            stats[statName].r = r
                            stats[statName].g = g
                            stats[statName].b = b
                        end
                    end
                end
            end
        end
        return stats
    end
end


--獲取物品實際等級信息
function lib:GetItemInfo(link, stats)
    if (not link or link == "") then
        return 0, 0
    end
    if (not string.match(link, "item:%d+:")) then
        return 1, -1
    end
    if (not self:HasLocalCached(link)) then
        return 1, 0
    end
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:SetHyperlink(link)
    local text, level
    for i = 2, 5 do
        text = _G[tooltip:GetName().."TextLeft" .. i]:GetText() or ""
        level = string.match(text, ItemLevelPattern)
        if (level) then break end
    end
    self:GetStatsViaTooltip(tooltip, stats)
    return 0, tonumber(level) or 0, GetItemInfo(link)
end

--獲取容器裏物品裝備等級(傳家寶/神器)
function lib:GetContainerItemLevel(pid, id)
    local text, level
    if (pid and id) then
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:SetBagItem(pid, id)
        for i = 2, 5 do
            text = _G[tooltip:GetName().."TextLeft" .. i]:GetText() or ""
            level = string.match(text, ItemLevelPattern)
            if (level) then break end
        end
    end
    return 0, tonumber(level) or 0
end

--獲取UNIT物品實際等級信息
function lib:GetUnitItemInfo(unit, index, stats)
    if (not UnitExists(unit)) then return 1, -1 end
    unittip:SetOwner(UIParent, "ANCHOR_NONE")
    unittip:SetInventoryItem(unit, index)
    local link = GetInventoryItemLink(unit, index) or select(2, unittip:GetItem())
    if (not link or link == "") then
        return 0, 0
    end
    if (not self:HasLocalCached(link)) then
        return 1, 0
    end
    local text, level
    for i = 2, 5 do
        text = _G[unittip:GetName().."TextLeft" .. i]:GetText() or ""
        level = string.match(text, ItemLevelPattern)
        if (level) then break end
    end
    self:GetStatsViaTooltip(unittip, stats)
    if (string.match(link, "item:(%d+):")) then
        return 0, tonumber(level) or 0, GetItemInfo(link)
    else
        local line = _G[unittip:GetName().."TextLeft1"]
        local r, g, b = line:GetTextColor()
        local name = ("|cff%.2x%.2x%.2x%s|r"):format((r or 1)*255, (g or 1)*255, (b or 1)*255, line:GetText() or "")
        return 0, tonumber(level) or 0, name
    end
end

--獲取UNIT的裝備等級
function lib:GetUnitItemLevel(unit, stats)
    local total, counts = 0, 0
    local _, count, level
    for i = 1, 15 do
        if (i ~= 4) then
            count, level = self:GetUnitItemInfo(unit, i, stats)
            total = total + level
            counts = counts + count
        end
    end
    local mcount, mlevel, mquality, mslot, ocount, olevel, oquality, oslot
    mcount, mlevel, _, _, mquality, _, _, _, _, _, mslot = self:GetUnitItemInfo(unit, 16, stats)
    ocount, olevel, _, _, oquality, _, _, _, _, _, oslot = self:GetUnitItemInfo(unit, 17, stats)
    counts = counts + mcount + ocount
    if (mquality == 6 or oquality == 6) then
        total = total + max(mlevel, olevel) * 2
    elseif (oslot == "INVTYPE_2HWEAPON" or mslot == "INVTYPE_2HWEAPON" or mslot == "INVTYPE_RANGED" or mslot == "INVTYPE_RANGEDRIGHT") then 
        total = total + max(mlevel, olevel) * 2
    else
        total = total + mlevel + olevel
    end
    return counts, total/max(16-counts,1), total, max(mlevel,olevel), (mquality == 6 or oquality == 6)
end
