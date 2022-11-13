local hooks = {}
function ELP_Replace(name, func)
    local parts = { strsplit(".", name) }
    if #parts > 1 then
        local obj = _G
        local funcName = table.remove(parts, #parts)
        for _, part in ipairs(parts) do
            obj = obj[part]
            if not obj then break end
        end
        if obj and type(obj[funcName]) == "function" then
            hooks[name] = obj[funcName]
            obj[funcName] = func
        end
    else
        hooks[name] = _G[name]
        _G[name] = func
    end
end

function ELP_RunOrigin(name, ...)
    return hooks[name](...)
end

function ELP_GetNewestRaidAndEmpoweredRaid(tier)
    local newest, empowered
    EJ_SelectTier(tier)
    for i = 1, 8 do
        local instanceID, name, _, _, _, _, _, _, _, _, mapID = EJ_GetInstanceByIndex(i, true)
        if not instanceID then break end
        newest = instanceID
        local info = C_ModifiedInstance.GetModifiedInstanceInfoFromMapID(mapID)
        if info and info.uiTextureKit == "ui-ej-icon-empoweredraid" then
            empowered = instanceID
        end
    end
    return newest, empowered or newest or 1193
end

local PLAYER_CLASS_ID = select(3, UnitClass("player"))
local PLAYER_SPEC_ID = GetSpecializationInfo(GetSpecialization() or 0) --TODO: check if right
function ELP_ScanStats(itemLink)
    if not itemLink then return end
    local name, link, _, iLevel = GetItemInfo(itemLink)
    if not link or not iLevel then return end
    local stats = U1GetItemStats(itemLink, nil, nil, false, PLAYER_CLASS_ID, PLAYER_SPEC_ID)
    if type(stats) == "table" then
        stats[3], stats[4] = stats[4], stats[3]
        stats[5] = stats[9] --导灵器筛选暂时未实现, 1-效能导灵器, 2-耐久导灵器, 3-灵巧导灵器
        stats[6], stats[7], stats[8], stats[9] = nil, nil, nil, nil --主属性没用
    end
    return stats
end

local ELP_EJ_DIFFICULTIES = {
    DifficultyUtil.ID.DungeonNormal,
   	DifficultyUtil.ID.DungeonHeroic,
   	DifficultyUtil.ID.DungeonMythic,
    DifficultyUtil.ID.Raid10Normal,
   	DifficultyUtil.ID.Raid10Heroic,
   	DifficultyUtil.ID.Raid25Normal,
   	DifficultyUtil.ID.Raid25Heroic,
   	DifficultyUtil.ID.PrimaryRaidNormal,
   	DifficultyUtil.ID.PrimaryRaidHeroic,
   	DifficultyUtil.ID.PrimaryRaidMythic,
}

function ELP_FindBestDifficulty()
    for i = #ELP_EJ_DIFFICULTIES, 1, -1 do
        local diff = ELP_EJ_DIFFICULTIES[i]
        if EJ_IsValidInstanceDifficulty(ELP_EJ_DIFFICULTIES[i]) then
            return diff
        end
    end
end

function ELP_SetBestDifficulty(insID)
    local shouldDisplayDifficulty = select(9, EJ_GetInstanceInfo(insID))
    if shouldDisplayDifficulty then
        local diff = ELP_FindBestDifficulty()
        if diff then EJ_SetDifficulty(diff) end
    end
end

--copied from Blizzard_EncounterJournal.lua
SlotFilterToSlotName_ELP = {
	[Enum.ItemSlotFilterType.Head] = INVTYPE_HEAD,
	[Enum.ItemSlotFilterType.Neck] = INVTYPE_NECK,
	[Enum.ItemSlotFilterType.Shoulder] = INVTYPE_SHOULDER,
	[Enum.ItemSlotFilterType.Cloak] = INVTYPE_CLOAK,
	[Enum.ItemSlotFilterType.Chest] = INVTYPE_CHEST,
	[Enum.ItemSlotFilterType.Wrist] = INVTYPE_WRIST,
	[Enum.ItemSlotFilterType.Hand] = INVTYPE_HAND,
	[Enum.ItemSlotFilterType.Waist] = INVTYPE_WAIST,
	[Enum.ItemSlotFilterType.Legs] = INVTYPE_LEGS,
	[Enum.ItemSlotFilterType.Feet] = INVTYPE_FEET,
	[Enum.ItemSlotFilterType.MainHand] = INVTYPE_WEAPONMAINHAND,
	[Enum.ItemSlotFilterType.OffHand] = INVTYPE_WEAPONOFFHAND,
	[Enum.ItemSlotFilterType.Finger] = INVTYPE_FINGER,
	[Enum.ItemSlotFilterType.Trinket] = INVTYPE_TRINKET,
	[Enum.ItemSlotFilterType.Other] = EJ_LOOT_SLOT_FILTER_OTHER,
}

--- Deprecated
--[[ --9.0早期资料片下拉菜单没有没有暗影国度的选项
CoreDependCall("Blizzard_EncounterJournal", function()
    hooksecurefunc("EJTierDropDown_Initialize", function(self, level)
        if not level then return end
        local listFrame = _G["DropDownList"..level];
        local expId = ELP_CURRENT_TIER
        if listFrame.numButtons >= expId then return end
        local info = UIDropDownMenu_CreateInfo();
        info.text = EJ_GetTierInfo(expId);
        info.func = EncounterJournal_TierDropDown_Select
        info.checked = expId == EJ_GetCurrentTier;
        info.arg1 = expId;
        UIDropDownMenu_AddButton(info, 1)
    end)
end)
--]]