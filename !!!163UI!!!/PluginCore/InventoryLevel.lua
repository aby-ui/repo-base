--WLK 绿 187 蓝 200 紫 200 - 284
--CTM 绿 272-333 蓝 308-359 紫 353-
local slotWeight = {
    ["INVTYPE_RELIC"] = 0.3164,
    ["INVTYPE_TRINKET"] = 0.5625,
    ["INVTYPE_2HWEAPON"] = 2.000,
    ["INVTYPE_WEAPONMAINHAND"] = 1.0000,
    ["INVTYPE_WEAPONOFFHAND"] = 1.0000,
    ["INVTYPE_RANGED"] = 2, --0.3164,
    ["INVTYPE_THROWN"] = 0, --0.3164,
    ["INVTYPE_RANGEDRIGHT"] = 2, --0.3164,
    ["INVTYPE_SHIELD"] = 1.0000,
    ["INVTYPE_WEAPON"] = 1.0000,
    ["INVTYPE_HOLDABLE"] = 1.0000,
    ["INVTYPE_HEAD"] = 1.0000,
    ["INVTYPE_NECK"] = 0.5625,
    ["INVTYPE_SHOULDER"] = 0.7500,
    ["INVTYPE_CHEST"] = 1.0000,
    ["INVTYPE_ROBE"] = 1.0000,
    ["INVTYPE_WAIST"] = 0.7500,
    ["INVTYPE_LEGS"] = 1.0000,
    ["INVTYPE_FEET"] = 0.75,
    ["INVTYPE_WRIST"] = 0.5625,
    ["INVTYPE_HAND"] = 0.7500,
    ["INVTYPE_FINGER"] = 0.5625,
    ["INVTYPE_CLOAK"] = 0.5625,
}

local TYPE_WAND = "Wand"
local TYPE_WANDS = "Wands"
if(GetLocale()=="zhCN" or GetLocale()=="zhTW")then TYPE_WAND="魔杖" TYPE_WANDS="魔杖" end
--处理魔杖的问题

--[[
/print gsub("/cff0070dd/Hitem:127158:0:0:0:0:0:0:0:100:70:512:22:2:615:656:100/h[诸界烈焰胸甲]/h/r","/","\124")
/print gsub("/cff0070dd/Hitem:127158:0:0:0:0:0:0:0:100:70:0:0:0/h[诸界烈焰胸甲]/h/r","/","\124")
local item = GetInventoryItemLink("player", 1)
--]]
local ItemUpgradeInfo = LibStub("LibItemUpgradeInfo-1.0")

local tip = CreateFrame("GameTooltip", "GameTooltipForItemLevel", nil, "ShoppingTooltipTemplate")
for i=1, 4 do
    tip:AddFontStrings(
        tip:CreateFontString( "$parentTextLeft"..i, nil, "GameTooltipText" ),
        tip:CreateFontString( "$parentTextRight"..i, nil, "GameTooltipText" )
    )
end

local pattern = ITEM_LEVEL:gsub("%%d", "(%%d+)") --ITEM_LEVEL=物品等级%d
local extractLink = "\124H(item:.-)\124h.-\124h"
local cache = {}
function U1GetItemLevelByScanTooltip(itemLink, slot)
    local name, _, quality, ilevel, extract
    if not slot then
        -- 如果是武器部位，则直接SetInventoryItem，不走这里
        name, _, quality, ilevel = GetItemInfo(itemLink)
        _,_,extract = itemLink:find(extractLink)
        if not extract then return nil end
        if cache[extract] then return cache[extract] end   --神器无法缓存
    else
        itemLink = GetInventoryItemLink(itemLink, slot)
    end
    if not itemLink then return end
    --[[
    local v = GetDetailedItemLevelInfo(itemLink)
    if v then
        if quality ~= 6 and extract then cache[extract] = v end --目前发现神器不能缓存
        --if (slot == 16 or slot == 17) and v ~= 750 and not UnitIsUnit(itemLink, "player") then
        --    v = v + 15 --假设观察的玩家都加出第一层
        --end
        return v
    end
    --]]

    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    for i = 1,4 do
   		if _G[ tip:GetName() .."Texture"..i] then
   			_G[ tip:GetName() .."Texture"..i]:SetTexture("")
   		end
    end
    if slot then
        tip:SetInventoryItem(itemLink, slot)
    else
        tip:SetHyperlink(itemLink)
    end
    tip:Show();
	for i = 2, 4 do
		local text = _G[ tip:GetName() .."TextLeft"..i]:GetText();
        if text then
            local _, _, v = text:find(pattern)
            if v then
                v = tonumber(v)
                if quality ~= 6 and extract then cache[extract] = v end --目前发现神器不能缓存
                return v
            end
        end
    end
    --safe fallback
    return ItemUpgradeInfo:GetUpgradedItemLevel(itemLink) or ilevel
end

---unit is optional, needed for artifact weapons, value is "player" or inspect unit.
function U1GetRealItemLevel(link, unit, slot)
    --artifact, 观察他人的时候另一件神器是750
    if unit and (slot == 16 or slot == 17) then
        local _, _, quality = GetItemInfo(link)
        if quality == 6 then
            local main_hand = U1GetItemLevelByScanTooltip(unit, 16) or 0
            local off_hand = U1GetItemLevelByScanTooltip(unit, 17) or 0
            return max(main_hand, off_hand)
        end
    end
    return U1GetItemLevelByScanTooltip(link)
end

local function GetRealInventoryType(link)
    local _, _, quality, _, _, _, typeName, _, invType = GetItemInfo(link)
    if invType == "INVTYPE_RANGEDRIGHT" and (typeName==TYPE_WAND or typeName==TYPE_WANDS) then
        invType = "INVTYPE_WEAPON"
    end
    return invType
end

local function GetItemScore(link, blizzard, unit, slot)
    if not (link) then return end
    local ilevel = U1GetRealItemLevel(link, unit, slot)
    local invType = GetRealInventoryType(link)
    return ilevel, invType, blizzard and 1 or slotWeight[invType];
end

function U1GetInventoryLevelColor(avgLevel, quality)
    local STEP1, STEP2, STEP3, STEP4, STEP5 = 190, 295, 325, 350, 400
    --local STEP1, STEP2, STEP3, STEP4, STEP5 = 780, 865, 950, 985, 1000 --845=166,865=174,885=182,915=195,930=210,945=225,960=240
    if not avgLevel or avgLevel<=0 then return .5, .5, .5 end
    if avgLevel < STEP1 then
        return 1, 1, 1
    elseif avgLevel <= STEP2 then
        --return 1-(avgLevel-STEP1)/(STEP2 - STEP1), 1, 1-(avgLevel-STEP1)/(STEP2-STEP1) --1,1,1->0,1,0 白到绿
        return GetItemQualityColor(2) --绿装
    elseif avgLevel <= STEP3 then
        --return 0, 1-(avgLevel-STEP2)/(STEP3-STEP2)/2, 0.5+(avgLevel-STEP2)/(STEP3-STEP2)/2 --0,1,0.5 -> 0,0.5,1 绿到蓝
        return (avgLevel-STEP2)/(STEP3-STEP2), 0.5, 1  --0,0.5,1 -> 1,0.5,1 蓝到粉紫
    elseif avgLevel <= STEP4 then
        --return (avgLevel-STEP3)/(STEP4-STEP3), 0.5, 1
        return 1, 0.5-(avgLevel-STEP3)/(STEP4-STEP3)/2, 1 --(avgLevel-STEP3)/(STEP4-STEP3)/2 --1,0.5,1 -> 1,0,0.5 粉紫到紫红（最后用紫）
    elseif avgLevel < STEP5 or (quality and quality ~= 5) then
        --return 1, 0.5, 1-(avgLevel-STEP4)/(STEP5-STEP4) --紫到紫红, 神器
        return 1, 0, 1-(avgLevel-STEP4)/(STEP5-STEP4)/2
    else
        return 1, 0.5, 0
    end
end

local itemLinks = {}
local ItemStats = {}

---获取unit的物品等级信息
--注意如果物品信息不全或者不是玩家则返回nil, 此外如果数据有问题则返回0对应的数据
--@param blizzard 暴雪算法 所有装备权重相同 主手为双手且副手为空时计16件物品，否则17件
--@return avgLevel, color, resilience, totalLevel, count, slotCount, itemLinks
--说明：slotCount是身上应装备的格子数，16或17，count是身上已装备的格子数，如果这两个不相等，则表示装备不全
function U1GetInventoryLevel(unit, blizzard)
    if not UnitIsPlayer(unit) then return end

    if(blizzard==nil) then blizzard = select(4,GetBuildInfo())>40200 end

    table.wipe(itemLinks) --缓存一下
    for i = 1, 17 do
        if i ~= 4 and GetInventoryItemTexture(unit, i) then
            itemLinks[i] = GetInventoryItemLink(unit, i)
            if not itemLinks[i] then return end
        end
    end

    local _, class = UnitClass(unit);

    local invType16, quality16, iLevel16, _
    if itemLinks[16] then _, _, quality16, _, _, _, _, _, invType16 = GetItemInfo(itemLinks[16]) end

    --是否是泰坦之握，只要是双持且主手为双手武器就算。如果主手为空副手拿个双手武器，就算它是拿在主手，不影响结果
    local warriorTitan = not blizzard and (class=="WARRIOR") and itemLinks[16] and itemLinks[17] and (invType16 == "INVTYPE_2HWEAPON")

    local count, totalScore, totalLevel, totalMod, totalPVP = 0, 0, 0, 0, 0
    for i = 1, 17 do
        local link = itemLinks[i]
        if (link) then
            local ilevel, invType, mod = GetItemScore(link, blizzard, unit, i);
            if i == 16 then iLevel16 = ilevel end
            if mod and ilevel then
                if not blizzard then
                    if warriorTitan and (i == 16 or i == 17) then
                        mod = mod * 0.5
                    end
                    totalScore = totalScore + ilevel * mod
                    totalMod = totalMod + mod
                end
                count = count + 1
                totalLevel = totalLevel + ilevel
                --print(link, ilevel)
            end

            --PVP power, no RESILIENCE since 5.0, no PVP power since 6.0
            --wipe(ItemStats)
            --GetItemStats(link, ItemStats)
            --totalPVP = totalPVP + (ItemStats.ITEM_MOD_PVP_POWER_SHORT or 0) --(ItemStats.ITEM_MOD_RESILIENCE_RATING_SHORT or 0) -- no RESILIENCE since 5.0
        end
    end

    local avgLevel, avgLevelEquiped
    local slotCount = 16    --local slotCount = not itemLinks[17] and (not itemLinks[16] or invType16=="INVTYPE_2HWEAPON" or invType16=='INVTYPE_RANGED' or invType16=='INVTYPE_RANGEDRIGHT') and 15 or 16
    if blizzard then
        --2016.10 双手神器算两次，不知道其他双手武器是不是
        if iLevel16 and not itemLinks[17] and (invType16 == "INVTYPE_2HWEAPON" or invType16 == "INVTYPE_RANGEDRIGHT" or invType16 == "INVTYPE_RANGED" or quality16 == 6) then
            totalLevel = totalLevel + iLevel16
            count = count + 1
        end
        avgLevel = totalLevel / slotCount;
    else
        avgLevel = totalMod > 0 and totalScore / totalMod or 0;
    end

    local r, g, b = U1GetInventoryLevelColor(avgLevel)
    local color = string.format("%02x%02x%02x", r * 255, g * 255, b * 255)

    local precise = avgLevel
    avgLevel = avgLevel > 0 and tonumber(string.format("%.1f", avgLevel)) or 0

    return avgLevel, color, totalPVP, totalLevel, count, slotCount, itemLinks, string.format("%0.3f", precise)
end




do
    local enchantables = {
        Finger0Slot = "戒",
        Finger1Slot = "戒",
        MainHandSlot = "武",
        --[[
        BackSlot = "披",
        NeckSlot = "颈",
        ChestSlot = "胸",
        FeetSlot = "脚",
        HandsSlot = "手",
        LegsSlot = "腿",
        WristSlot = "腕",
        HeadSlot = "头",
        ShoulderSlot = "肩",
        WristSlot = "腕",
        WaistSlot = "腰",
        SecondaryHandSlot = "副",
        --]]
    }

    function U1GetUnitEnchantInfo(unit, waist_extra_slot)
        -- local isplayer = unit == 'player'
        local total, hasenchant = 0, 0
        local missing = ""

        for slot, shortname in next, enchantables do
            local link = GetInventoryItemLink(unit, GetInventorySlotInfo(slot))
            if(link) then
                local enchantid = link:match'item:%d+:(%d+):'
                enchantid = enchantid and tonumber(enchantid)

                total = total + 1

                if(enchantid and enchantid > 0) then
                    hasenchant = hasenchant + 1
                else
                    if(slot == 'WaistSlot' and waist_extra_slot) then
                        hasenchant = hasenchant + 1
                    elseif #missing<12 then
                        missing = missing..shortname
                    end
                end
            end
        end

        return total, hasenchant, missing
    end
end


local slots = { "Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand", "SecondaryHand", } -- "Ranged", "Tabard",

do
    local fmt = string.format
    local gem_slots = {
        EMPTY_SOCKET = true,
        EMPTY_SOCKET_BLUE = true,
        EMPTY_SOCKET_COGWHEEL = true,
        EMPTY_SOCKET_HYDRAULIC = true,
        EMPTY_SOCKET_META = true,
        EMPTY_SOCKET_NO_COLOR = true,
        EMPTY_SOCKET_PRISMATIC = true,
        EMPTY_SOCKET_RED = true,
        EMPTY_SOCKET_YELLOW = true,
    }

    local _item_stat_tbl = {}
    local get_item_stats = function(item)
        wipe(_item_stat_tbl)
        return GetItemStats(item, _item_stat_tbl)
    end

    function U1GetUnitGemInfo(unit)
        local gem_s = 0
        local slot_s = 0
        local top_s, sec_s, oth_s = 0, 0, 0
        local waist_extra_slot = false

        for id, slot in next, slots do
            local link = slot~="MainHand" and slot~="SecondaryHand" and GetInventoryItemLink(unit, id) --GetInventorySlotInfo(slot..'Slot')
            if(link) then
                local i_slot, i_gem = 0, 0

                local stats = get_item_stats(link)
                if stats==nil then return UNKNOWN end --item cache
                for k, v in next, stats do
                    if(gem_slots[k]) then
                        i_slot = i_slot + v
                    end
                end
                slot_s = slot_s + i_slot
                --print(link:gsub("\124", "/"), i_slot, GetItemGem(link, 1), GetItemGem(link, 2), GetItemGem(link, 3))

                for i = 1, 3 do
                    local gemname, gemlink = GetItemGem(link, i)
                    if(gemlink) then
                        local name, link, quality, iLevel, reqLevel, itype, subType = GetItemInfo(gemlink)
                        gem_s = gem_s + 1
                        --[[ 6.0之前的逻辑
                        if(iLevel == MAX_PLAYER_LEVEL) then
                            if(quality >= 4) then
                                top_s = top_s + 1
                            else
                                sec_s = sec_s + 1
                            end
                        else
                            oth_s = oth_s + 1
                        end
                        --]]
                        if(quality >= 3) then
                            sec_s = sec_s + 1
                        else
                            oth_s = oth_s + 1
                        end
                        i_gem = i_gem + 1
                    end
                end

                if(slot == 'Waist' and i_gem > i_slot) then
                    waist_extra_slot = true
                end
            end
        end

        slot_s = math.max(slot_s, gem_s)
        local fc = NORMAL_FONT_COLOR_CODE
        local res
        if slot_s == 0 or gem_s == 0 then
            res ="0"
        else
            if sec_s == 0 then
                res = fmt('%d/%d (|cff00dd70%d|r)', gem_s, slot_s, oth_s)
            elseif oth_s == 0 then
                res = fmt('%d/%d (|cff0070dd%d|r)', gem_s, slot_s, sec_s)
            else
                res = fmt('%d/%d (|cff0070dd%d|r+|cff00dd70%d|r)', gem_s, slot_s, sec_s, oth_s) --|cffa335ee%d|r top_s
            end
        end

        return res, waist_extra_slot
    end
end


----物等显示
local slot = {'Head','Neck','Shoulder','Chest','Waist','Legs','Feet','Wrist','Hands','Finger0','Finger1','Trinket0','Trinket1','Back','MainHand','SecondaryHand'}
local function CreateIlvText(slotName)
    local f = _G[slotName]
    f.ilv = f:CreateFontString(nil, 'OVERLAY')
    f.ilv:SetPoint('TOPLEFT', f, 'TOPLEFT', 1, -1)
    f.ilv:SetFont(STANDARD_TEXT_FONT, 13, 'OUTLINE')
end

local function CheckItem(unit, frame)
    if unit then
        for k, v in pairs(slot) do
            local f = _G[frame..v..'Slot']
            if not U1GetCfgValue("!!!163ui!!!/showLevelOnSlot") then
                f.ilv:SetText()
            else
                local slotId = GetInventorySlotInfo(v .. 'Slot')
                local itemLink = GetInventoryItemLink(unit, slotId)
                if not itemLink then
                    f.ilv:SetText()
                else
                    local _, _, itemQuality = GetItemInfo(itemLink)
                    local ilvl = U1GetRealItemLevel(itemLink, unit, slotId)
                    f.ilv:SetText(ilvl)
                    f.ilv:SetTextColor(U1GetInventoryLevelColor(ilvl, itemQuality))
                end
            end
        end
    end
end

for _, v in pairs(slot) do CreateIlvText('Character'..v..'Slot') end

CharacterFrame:HookScript('OnShow', function(self) 
   CheckItem('player', 'Character') 
   self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED') 
end) 

CharacterFrame:HookScript('OnHide', function(self) 
   self:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED') 
end) 

CharacterFrame:HookScript('OnEvent', function(self, event) 
   if event ~= 'PLAYER_EQUIPMENT_CHANGED' then return end 
   CheckItem('player', 'Character') 
end)

--[[------------------------------------------------------------
scan stats
---------------------------------------------------------------]]
local function GetItemIDFromLink(link)
	if not link then
		return
	end
	local found, _, str = link:find("^|c%x+|H(.+)|h%[.+%]")

	if not found then
		return
	end

	local _, ID = (":"):split(str)
	return tonumber(ID)
end

local pattern = "^%+([0-9,]+) ([^ ]+)$"
local patternMore = "%+([0-9,]+) ([^ ]-)\124?r?$" --"附魔：+200 急速" "|cffffffff+150 急速|r"
local ATTRS = {
    [STAT_CRITICAL_STRIKE]  = 1, --CR_CRIT_MELEE,
    [STAT_HASTE]            = 2, --CR_HASTE_MELEE,
    [STAT_VERSATILITY]      = 3, --CR_VERSATILITY_DAMAGE_DONE,
    [STAT_MASTERY]          = 4, --CR_MASTERY,
    [ITEM_MOD_STRENGTH_SHORT] = 5, --LE_UNIT_STAT_STRENGTH
    [ITEM_MOD_AGILITY_SHORT] = 6, --LE_UNIT_STAT_AGILITY
    [ITEM_MOD_INTELLECT_SHORT] = 8, --LE_UNIT_STAT_INTELLECT
}
U1ATTRSNAME = {} for k,v in pairs(ATTRS) do U1ATTRSNAME[v] = k end

local cache, primary_stats = {}, {}
--如果提供tbl，则总是返回tbl，否则返回新的table或者数字1
--如果 includeGemEnchant, 那么当装备只有附魔和宝石时，对应属性是负值
function U1GetItemStats(link, slot, tbl, includeGemEnchant, classID, specID)
    local stats
    if tbl then wipe(tbl) stats = tbl end

    --缓存获取，装备搜索时includeGem是false, 不需要走缓存, 已经被db.ITEMS缓存了
    if slot == nil and includeGemEnchant and cache[link] and (not specID or primary_stats[specID]) then
        copy(cache[link], tbl)
        --移除非主属性
        if specID and primary_stats[specID] then
            for i=5, 8 do if i~=primary_stats[specID]+4 then tbl[i] = nil end end
        end
        return tbl
    end

    local tip, tipname = CoreGetTooltipForScan()
    tip:SetOwner(WorldFrame, "ANCHOR_NONE")
    if slot == nil then
        tip:SetHyperlink(link, classID, specID)
    else
        tip:SetInventoryItem(link, slot)
    end
    for i = 5, tip:NumLines(), 1 do
        local txt = _G[tipname .. "TextLeft"..i]:GetText()
        if txt then
            local _, _, value, attr = txt:find(pattern)
            if attr and ATTRS[attr] then
                local value = tonumber((value:gsub(",", "")))
                stats = stats or {}
                stats[ATTRS[attr]] = math.abs(stats[ATTRS[attr]] or 0) + value
                --通过文字颜色获取天赋主属性
                if specID and specID > 0 and ATTRS[attr] > 4 then
                    local r,g,b = _G[tipname .. "TextLeft"..i]:GetTextColor()
                    if r > 0.99 then
                        primary_stats[specID] = ATTRS[attr] - 4
                    end
                end
            elseif not attr and includeGemEnchant then
                txt = txt:gsub("，%+2%% (.*)$", "") --", +2%速度"
                _, _, value, attr = txt:find(patternMore)
                if attr and ATTRS[attr] then
                    local value = tonumber((value:gsub(",", "")))
                    stats = stats or {}
                    local old = stats[ATTRS[attr]] or 0
                    if old > 0 then stats[ATTRS[attr]] = old + value else stats[ATTRS[attr]] = old - value end
                end
            end
        end
    end
    if slot == nil and includeGemEnchant and stats then
        cache[link] = {}
        copy(stats, cache[link])
        if specID and primary_stats[specID] then
            for i=5, 8 do if i~=primary_stats[specID]+4 then stats[i] = nil end end
        end
    end
    return stats or 1
end