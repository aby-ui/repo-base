local _, ELP = ...
local db = ELP.db

local ELP_CURRENT_TIER = 8 --BfA
local ELP_RELIC_SLOT = 30

local curr_items = {}
local curr_encts = {}
local curr_insts = {}
local curr_retrieving = {}
ELP.currs = { curr_items, curr_encts, curr_insts, curr_retrieving }

function ELP_IsRetrieving()
    return next(curr_retrieving) ~= nil
end

function ELP_RetrieveNext()
    local itemID = next(curr_retrieving)
    while(itemID and db.ITEMS[itemID]) do itemID = next(curr_retrieving) end
    if itemID == nil then
        ELP_RetrieveDone()
    else
        local stats = ELP_ScanStats(itemID)
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
        if EJ_GetSlotFilter() == ELP_RELIC_SLOT then
            tinsert(curr_items, k)
        elseif (db.attr1 == 0 or (db.attr1 ~= 0 and type(db.ITEMS[k])=="table" and db.ITEMS[k][db.attr1]))
            and (db.attr2 == 0 or (db.attr2 ~= 0 and type(db.ITEMS[k])=="table" and db.ITEMS[k][db.attr2])) then
            tinsert(curr_items, k)
        end
    end
    -- sort according to attr1
    if db.attr1 ~= 0 and EJ_GetSlotFilter() ~= ELP_RELIC_SLOT then
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
    wipe(curr_encts)
    wipe(curr_insts)
    wipe(curr_items)
    EJ_SelectTier(ELP_CURRENT_TIER)
    -- force slot filter to avoid too many items listed.
    local forceSlot = db.range > 0 and EJ_GetSlotFilter() == 0
    if forceSlot then EJ_SetSlotFilter(11) end

    for i = 1, 2 do
        local index = 1
        while( bit.band(i, db.range) > 0 ) do
            local insID, name, _, _, _, _, _, _, link = EJ_GetInstanceByIndex(index, i == 1)
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
                local itemID, encounterID, name, icon, slot, armorType, link = EJ_GetLootInfoByIndex(loot)
                if not curr_encts[itemID] then
                    if not db.ITEMS[itemID] then curr_retrieving[itemID] = 1 end
                    curr_encts[itemID] = encounterID
                    curr_insts[itemID] = insID
                end
            end
        end
    end

    if forceSlot then EJ_SetSlotFilter(0) end
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

function ELP_ScanStats(itemID, itemLink)
    if not itemID and not itemLink then return end
    itemID = itemID or GetItemIDFromLink(itemLink)
    local name, link, _, iLevel = GetItemInfo(itemID)
    if not link or not iLevel then return end
    local fakeLink = format("item:%d::::::::110::::2:%d:3517::", itemID, 1472+(920-iLevel))
    local stats = U1GetItemStats(fakeLink, nil, nil, false, select(3, UnitClass("player")), GetSpecializationInfo(GetSpecialization() or 0))
    if type(stats) == "table" then stats[3],stats[4] = stats[4], stats[3] end
    return stats
end

