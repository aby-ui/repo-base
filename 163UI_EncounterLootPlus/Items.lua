local _, ELP = ...
local db = ELP.db

-- 没有属性的部位，忽略选择的属性
local SLOTS_WITH_NO_STATS = {
    [Enum.ItemSlotFilterType.Other] = true,
}

local curr_items = {}
local curr_encts = {}
local curr_insts = {}
local curr_links = {}
local curr_retrieving = {}
ELP.currs = { curr_items, curr_encts, curr_insts, curr_retrieving, curr_links }

function ELP_IsRetrieving()
    return next(curr_retrieving) ~= nil
end

function ELP_RetrieveNext()
    local itemID = next(curr_retrieving)
    while(itemID and db.ITEMS[itemID]) do itemID = next(curr_retrieving) end
    if itemID == nil then
        ELP_RetrieveDone()
    else
        local stats = ELP_ScanStats(curr_links[itemID])
        if stats ~= nil then
            --if type(stats) == "table" then print(itemID, select(2, GetItemInfo(itemID)), unpack(stats, 2, 5)) end
            db.ITEMS[itemID] = stats
            curr_retrieving[itemID] = nil
        end
    end
end

local function sortByAttr1(a, b)
    local attr = db.attr1
    local aa = db.ITEMS[a][attr]
    local bb = db.ITEMS[b][attr]
    if aa == bb then
        return a < b
    else
        return aa > bb
    end
end

function ELP_RetrieveDone()
    ELP.frame:Hide()
    for k, _ in pairs(curr_encts) do
        if SLOTS_WITH_NO_STATS[C_EncounterJournal.GetSlotFilter()] then
            tinsert(curr_items, k)
        elseif (db.attr1 == 0 or (db.attr1 ~= 0 and type(db.ITEMS[k])=="table" and db.ITEMS[k][db.attr1]))
            and (db.attr1 == 0 or db.attr2 == 0 or (db.attr2 ~= 0 and type(db.ITEMS[k])=="table" and db.ITEMS[k][db.attr2])) then
            tinsert(curr_items, k)
        end
    end
    -- sort according to attr1
    if db.attr1 ~= 0 and not SLOTS_WITH_NO_STATS[C_EncounterJournal.GetSlotFilter()] then
        table.sort(curr_items, sortByAttr1)
    end
    EncounterJournal_LootUpdate()
end

function ELP_RetrieveStart()
    if next(curr_retrieving) then
        ELP.frame:Show()
    else
        ELP_RetrieveDone()
    end
end

function ELP_UpdateItemList()
    if db.range == 0 then return end
    local EncounterJournal = EncounterJournal or CreateFrame("Frame")
    EncounterJournal:UnregisterEvent("EJ_LOOT_DATA_RECIEVED")
    EncounterJournal:UnregisterEvent("EJ_DIFFICULTY_UPDATE")
    for _, v in ipairs(ELP.currs) do wipe(v) end
    EJ_SelectTier(ELP_CURRENT_TIER)
    -- force slot filter to avoid too many items listed.
    local forceSlot = db.range > 0 and db.range ~= 4 and C_EncounterJournal.GetSlotFilter() == ELP_ALL_SLOT --4是最新团本
    if forceSlot then
        C_EncounterJournal.SetSlotFilter(ELP_DEFAULT_SLOT)
        EncounterJournal_RefreshSlotFilterText()
    end

    -- range: 1(01)全部团本; 2(10)最新大秘; 3(11)全部副本; 4(1 but lastRaid)最新团本; 5(3 but lastRaid)最新团本和5人大秘
    local range, lastRaid = db.range, nil --没有lastRaid时表示所有的
    if range == 4 or range == 5 then
        lastRaid = ELP_LAST_RAID_IDX
        range = range == 4 and 1 or 3
    end

    for i = 1, 2 do
        local index = (i == 1 and lastRaid or 1)
        while( bit.band(i, range) > 0 ) do
            local insID, name, _, _, _, _, _, _, link = ELP_EJ_GetInstanceByIndex(index, i == 1)
            if not insID then break end
            index = index + 1
            EJ_SelectInstance(insID)
            local shouldDisplayDifficulty = select(9, EJ_GetInstanceInfo(insID))
            if shouldDisplayDifficulty then
                EJ_SetDifficulty(i==1 and 16 or 23)
            else
                EJ_SetDifficulty(i==1 and 14 or 1)
            end
            for loot = 1, EJ_GetNumLoot() do
                local info = C_EncounterJournal.GetLootInfoByIndex(loot)
                local itemID = info.itemID
                if not curr_encts[itemID] then
                    if not db.ITEMS[itemID] then curr_retrieving[itemID] = 1 end
                    curr_encts[itemID] = info.encounterID
                    curr_insts[itemID] = insID
                    curr_links[itemID] = info.link
                end
            end
        end
    end

    EncounterJournal:RegisterEvent("EJ_LOOT_DATA_RECIEVED")
    EncounterJournal:RegisterEvent("EJ_DIFFICULTY_UPDATE")

    ELP_RetrieveStart()
end

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

local MAX_PLAYER_LEVEL = GetMaxLevelForPlayerExpansion()
function ELP_ScanStats(itemLink)
    if not itemLink then return end
    --local itemID = GetItemIDFromLink(itemLink)
    local name, link, _, iLevel = GetItemInfo(itemLink)
    if not link or not iLevel then return end
    --local fakeLink = format("item:%d::::::::%d::::1:%d:::", itemID, MAX_PLAYER_LEVEL, 1472+(465-iLevel))
    local stats = U1GetItemStats(itemLink, nil, nil, false, select(3, UnitClass("player")), GetSpecializationInfo(GetSpecialization() or 0))
    if type(stats) == "table" then
        stats[3],stats[4] = stats[4], stats[3]
        stats[5] = stats[9] --导灵器
        stats[6], stats[7], stats[8], stats[9] = nil, nil, nil, nil --主属性没用
    end
    return stats
end

