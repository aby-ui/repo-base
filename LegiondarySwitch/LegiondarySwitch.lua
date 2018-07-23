local _, LS = ...
_G.LegiondarySwitch = LS

local QUALITY_LEGEND = 5
local CACHE_ACTIONS = "LS_ACTIONS"
local CACHE_RECENT = "LS_RECENT_ONE"
local CACHE_CHANGES = "LS_CHANGES" --连续替换两件装备时，按之前已经替换完来计算

local debug = noop

local function GetItemIDFromLink(link)
    if not link then return end
    local _, _, itemID = link:find("\124Hitem:(%d+):")
    return itemID and tonumber(itemID)
end

local function ReplaceItemLinkNameByIcon(link)
    local icon = select(10, GetItemInfo(link))
    return link:gsub("\124h%[.-%]\124h", "\124h|T"..icon..":20\124t\124h")
end

local function GetInventoryItemLinkWithCache(slot)
    local changes = CoreCacheGet(CACHE_CHANGES)
    if changes then
        local offSlot, replaceLink, onSlot, newLegLink = unpack(changes)
        -- onSlot may be missing when /equip item, in that way we can't provide the slot
        if onSlot and slot == offSlot then return replaceLink end
        if onSlot and slot == onSlot then return newLegLink end
    end
    return GetInventoryItemLink("player", slot)
end

--- ITEM_LOCK_CHANGED fired after UI_ERROR_MESSAGE with bag and slot
-- if item there is legendary and found matched action, main switch logic will be triggered.
function LS.ITEM_LOCK_CHANGED(event, bag, slot)
    if bag and slot then
        local _, _, _, quality, _, _, link, _, _, itemID = GetContainerItemInfo(bag, slot)
        if quality == QUALITY_LEGEND then
            debug("ITEM_LOCK_CHANGED", event, bag, slot)
            local name = GetItemInfo(itemID)
            local list = CoreCacheListGet(CACHE_ACTIONS)
            if not list then return end
            for i, act in ipairs(list) do
                if act.name == name then
                    CoreCacheListRemove(CACHE_ACTIONS, i)
                    LS.Switch(link, itemID, act.bag, act.slot, act.invSlot)
                    break
                end
            end
        end
        return true
    end
end

--the world starts from UI_ERROR_MESSAGE
--你只能装备%d件%s类别中的物品
--你只能装备2件《军团再临》传说物品类别中的物品 LOOT_JOURNAL_LEGENDARIES=传说物品
local msg_pattern = ERR_ITEM_MAX_LIMIT_CATEGORY_EQUIPPED_EXCEEDED_IS:gsub("%%d", "([0-9]+)"):gsub("%%s", "(.+)")
local msg_legendary = LOOT_JOURNAL_LEGENDARIES
function LS.UI_ERROR_MESSAGE(event, msgid, msg)
    local _, _, count, cate = msg:find(msg_pattern)
    if count == "2" and msg_legendary and cate:find(msg_legendary) then
        CoreOnEvent("ITEM_LOCK_CHANGED", LS.ITEM_LOCK_CHANGED)
    end
end
CoreOnEvent("UI_ERROR_MESSAGE", LS.UI_ERROR_MESSAGE)

-- hook and keep last action which may trigger legendary exceed limitation error.
function LS.HookAction(action, ...)
    if LS.ignoreEquipItemByName then return end
    local bag, slot, invSlot, name, _
    if action == "UseContainerItem" then
        bag, slot = ...
        local _, _, _, quality, _, _, _, _, _, itemID = GetContainerItemInfo(bag, slot)
        if quality ~= QUALITY_LEGEND then return end
        name = GetItemInfo(itemID)
    elseif action == "EquipmentManager_EquipContainerItem" then
        local t = ...
        bag, slot, invSlot = t.bag, t.slot, t.invSlot
        local _, _, _, quality, _, _, link, _, _, itemID = GetContainerItemInfo(bag, slot)
        if quality ~= QUALITY_LEGEND then
            -- save for use before decide by max level
            debug("manual swap ", link, GetInventoryItemLinkWithCache(invSlot))
            local db = LS.GetDB(true)
            db.recent = db.recent or {}
            if invSlot >= 11 and invSlot <= 14 then
                local normalslot = (invSlot == 12 and 11) or (invSlot == 14 and 13) or invSlot
                db.recent[normalslot] = db.recent[normalslot] or {}
                for _, v in ipairs(db.recent[normalslot]) do
                    if v == link then return end
                end
                table.insert(db.recent[normalslot], 1, link)
                db.recent[normalslot][3] = nil
            else
                db.recent[invSlot] = link
            end
            return
        end
        name = GetItemInfo(itemID)
    elseif action == "EquipItemByName" then
        local argName, argSlot = ...
        local quality, invType
        name, _, quality, _, _, _, _, _, invType = GetItemInfo(argName)
        if quality ~= QUALITY_LEGEND then return end
        invSlot = argSlot or LS.GEAR_SLOT_REV[invType]
    elseif action == "UseAction" then
        local actionType, itemID = GetActionInfo((...))
        if actionType ~= "item" then return end
        local quality, invType
        name, _, quality, _, _, _, _, _, invType = GetItemInfo(itemID)
        if quality ~= QUALITY_LEGEND then return end
        invSlot = LS.GEAR_SLOT_REV[invType]
    end
    debug("HookAction", action, ...)
    local act = { bag = bag, slot = slot, invSlot = invSlot, name = name }
    local _, link = GetItemInfo(name)
    local itemID = GetItemIDFromLink(link)
    CoreCacheListSet(CACHE_RECENT, itemID, 15) --保存手工更换的装备，不会替换最近15秒更换的最后一件橙装
    CoreCacheListSet(CACHE_ACTIONS, act, 0.5)
    if not LS.LastSaved or GetTime() - LS.LastSaved > 30 then
        LS.SaveLastSet()
    end
end

-- hooks
do
    --Directly click UseContainerItem
    hooksecurefunc("UseContainerItem", function(...) LS.HookAction("UseContainerItem", ...) end)

    --EquipmentFlyout PaperDollFrameItemFlyoutButton_OnClick
    hooksecurefunc("EquipmentManager_EquipContainerItem", function(...) LS.HookAction("EquipmentManager_EquipContainerItem", ...) end)

    --/equip invSlot [bag slot itemName]
    hooksecurefunc("EquipItemByName", function(...) LS.HookAction("EquipItemByName", ...) end)

    --drag item to action bar
    hooksecurefunc("UseAction", function(...) LS.HookAction("UseAction", ...) end)

    --hard to implement and no need to support PickupInventoryItem hook
    --hooksecurefunc("PickupInventoryItem", function(...) LS.HookAction("PickupInventoryItem", ...) end)
end

LS.GEAR_SLOTS = {
    [1] = "INVTYPE_HEAD",
    [2] = "INVTYPE_NECK",
    [3] = "INVTYPE_SHOULDER",
    [5] = "INVTYPE_CHEST",
    [6] = "INVTYPE_WAIST",
    [7] = "INVTYPE_LEGS",
    [8] = "INVTYPE_FEET",
    [9] = "INVTYPE_WRIST",
    [10] = "INVTYPE_HAND",
    [11] = "INVTYPE_FINGER",
    [12] = "INVTYPE_FINGER",
    [13] = "INVTYPE_TRINKET",
    [14] = "INVTYPE_TRINKET",
    [15] = "INVTYPE_CLOAK"
}

LS.GEAR_SLOT_REV = {} for k,v in pairs(LS.GEAR_SLOTS) do LS.GEAR_SLOT_REV[v] = LS.GEAR_SLOT_REV[v] or k end

-- save last set and swap back
do
    function LS.SaveLastSet()
        local links = {}
        local legSlots = {}
        local count = 0
        for slot, _ in pairs(LS.GEAR_SLOTS) do
            local link = GetInventoryItemLinkWithCache(slot)
            if not link then return end
            local name, _, quality = GetItemInfo(link)
            local link = GetInventoryItemLinkWithCache(slot)
            links[slot] = link
            if quality == QUALITY_LEGEND then
                legSlots[slot] = true
                count = count + 1
            end
        end
        if count ~= 2 then
            return
        end
        LS.GetDB().last = {
            legs = legSlots,
            links = links,
        }
        LS.LastSaved = GetTime()
        PaperDollFrame.btnLegSwitch:SetEnabled(true)
    end

    CoreOnEvent("EQUIPMENT_SWAP_FINISHED", function()
        LS.GetDB().last = nil
        LS.LastSaved = nil
        PaperDollFrame.btnLegSwitch:SetEnabled(false)
    end)

    function LS.SwitchBack()
        if InCombatLockdown() then return U1Message("战斗中无法切换装备") end
        local last = LS.GetDB().last
        if not last then
            U1Message("没有上一次传说装备方案，可能是切换了专精或套装")
        else
            LS.SaveLastSet()
            LS.ignoreEquipItemByName = true
            for slot, _ in pairs(LS.GEAR_SLOTS) do
                local link = GetInventoryItemLinkWithCache(slot)
                if link then
                    local name, _, quality = GetItemInfo(link)
                    local link = GetInventoryItemLinkWithCache(slot)
                    if quality == QUALITY_LEGEND then
                        if not last.legs[slot] then
                            EquipItemByName(last.links[slot], slot)
                        end
                    end
                end
            end
            local msg = ""
            for slot, _ in pairs(last.legs) do
                local link = last.links[slot]
                EquipItemByName(link, slot)
                msg = msg .. " " .. ReplaceItemLinkNameByIcon(link)
            end
            LS.ignoreEquipItemByName = nil
            U1Message("当前橙装:" .. msg)
        end
    end

    CoreUIRegisterSlash("LS_SWAP_BACK", "/ls", "/legswitch", LS.SwitchBack)

    TplPanelButton(PaperDollFrame, name):Key("btnLegSwitch"):Size(44,20):BL(242,9)
    :SetText("换回"):SetEnabled(false)
    :SetScript("OnClick", LegiondarySwitch.SwitchBack)
end

local function TakeOffAndPutOn(offSlot, replaceLink, onSlot, newLegLink)
    local oldLegLink = GetInventoryItemLinkWithCache(offSlot)
    local anotherLink
    for slot, _ in pairs(LS.GEAR_SLOTS) do
        local link = GetInventoryItemLinkWithCache(slot)
        if link and select(3, GetItemInfo(link)) == QUALITY_LEGEND and link ~= oldLegLink then
            anotherLink = link
            break
        end
    end
    if not anotherLink or not replaceLink then return end
    U1Message(format("橙装闪换 %s => %s + %s + %s",
        ReplaceItemLinkNameByIcon(oldLegLink),
        ReplaceItemLinkNameByIcon(anotherLink),
        ReplaceItemLinkNameByIcon(newLegLink),
        replaceLink
    ))
    LS.ignoreEquipItemByName = true
    EquipItemByName(replaceLink, offSlot)
    EquipItemByName(newLegLink, onSlot)
    LS.ignoreEquipItemByName = nil
    CoreCacheSet(CACHE_CHANGES, { offSlot, replaceLink, onSlot and tonumber(onSlot) or nil, newLegLink }, 0.5)
end

-- find item to take off
function LS.Switch(itemLink, itemID, bag, slot, invSlot)
    if InCombatLockdown() then return end -- todo queue
    debug("Found item ", itemLink, bag, slot, invSlot)

    -- deal with rings and trinkets
    -- find with suite
    -- find with equipment set

    if not itemLink then return end

    -- 查找当前装备的橙装ID及部位，应当有两件
    local legIDs, legSlots = {}, {}
    for slot, _ in pairs(LS.GEAR_SLOTS) do
        local link = GetInventoryItemLinkWithCache(slot)
        if link then
            local name, _, quality = GetItemInfo(link)
            if quality == QUALITY_LEGEND then
                table.insert(legIDs, GetItemIDFromLink(link))
                table.insert(legSlots, slot)
            end
        end
    end
    if #legIDs ~= 2 then
        return error("Wrong Logic: current weared legendary count should be 2")
    end

    --save gear info before first switch in 0.3 seconds
    debug("switch")

    --- try use db to decide which one to take off
    local db = LS.GetDB(true)
    local tempIds, tempSet, key1, key2 = {}, {}, nil, nil
    local takeOffSlot, putOnLink
    local found

    tempIds[1] = legIDs[1] tempIds[2] = itemID table.sort(tempIds) key1 = table.concat(tempIds, ",") tempSet[1] = db[key1]
    tempIds[1] = legIDs[2] tempIds[2] = itemID table.sort(tempIds) key2 = table.concat(tempIds, ",") tempSet[2] = db[key2]

    -- this is so ugly...
    local protects = CoreCacheListGet(CACHE_RECENT)
    while(#protects > 2) do CoreCacheListRemove(CACHE_RECENT, 1) end
    local protectItemID = #protects == 2 and protects[1]
    if protectItemID ~= nil and legIDs[1] == protectItemID or legIDs[2] == protectItemID then
        if legIDs[1] == protectItemID then
            legIDs[1] = legIDs[2]
            legSlots[1] = legSlots[2]
            tempSet[2] = tempSet[1]
        elseif legIDs[2] == protectItemID then
            legIDs[2] = legIDs[1]
            legSlots[2] = legSlots[1]
            tempSet[1] = tempSet[2]
        end
    end

    if tempSet[1] == nil and tempSet[2] == nil then
        if db[itemID] then
            --用单传说作为key的历史记录，主要是为了在本专精下选择一个比较合理的装备
            local maxLevel = 0
            for _, slot in ipairs(legSlots) do
                if db[itemID][slot] then
                    local ilevel = select(4, GetItemInfo(db[itemID][slot]))
                    if ilevel and ilevel >= maxLevel then
                        takeOffSlot = slot
                        maxLevel = ilevel
                    end
                end
            end
            --有可能未记录到对应位置的非传说装备
            if maxLevel > 0 then
                putOnLink = db[itemID][takeOffSlot]
                debug("decide by single set ", putOnLink, takeOffSlot, itemLink, invSlot)
                TakeOffAndPutOn(takeOffSlot, putOnLink, invSlot, itemLink)
                return
            end
        end

        local maxLevel, maxSlot, maxLink
        for _, slot in ipairs(legSlots) do
            local normalslot = (slot == 12 and 11) or (slot == 14 and 13) or slot
            local avails = GetInventoryItemsForSlot(normalslot, {})
            local linkmap = {} --avails link as key
            for loc, _ in pairs(avails) do
                local player, bank, bags, void, bagSlot, bag = EquipmentManager_UnpackLocation(loc);
                if bags then
                    local _, _, _, quality, _, _, link = GetContainerItemInfo(bag, bagSlot)
                    if quality ~= QUALITY_LEGEND then
                        linkmap[link] = true
                        local ilevel = select(4, GetItemInfo(link))
                        if not maxLevel or ilevel > maxLevel then
                            maxLevel, maxSlot, maxLink  = ilevel, slot, link
                        end
                    end
                end
            end

            if db.recent and db.recent[normalslot] then
                if normalslot == 11 or normalslot == 13 then
                    for _, link in ipairs(db.recent[normalslot]) do
                        if linkmap[link] then
                            maxSlot, maxLink = slot, link
                            break
                        end
                    end
                else
                    if linkmap[db.recent[normalslot]] then
                        maxSlot, maxLink = slot, db.recent[normalslot]
                    end
                end
            end
        end
        if maxSlot then
            debug("decide by max item level", maxLink, maxSlot, itemLink, invSlot)
            TakeOffAndPutOn(maxSlot, maxLink, invSlot, itemLink)
        end
    else
        if tempSet[1] and tempSet[2] then
            takeOffSlot = tempSet[2].time > tempSet[1].time and 1 or 2
        elseif tempSet[1] then
            takeOffSlot = 2
        else
            takeOffSlot = 1
        end
        local set = tempSet[3-takeOffSlot]
        takeOffSlot = legSlots[takeOffSlot]
        putOnLink = set[takeOffSlot] --todo ring and trinket
        debug("decide by db ", putOnLink, takeOffSlot, itemLink, invSlot)
        TakeOffAndPutOn(takeOffSlot, putOnLink, invSlot, itemLink)
    end
end

function LS.GetDB(forSpec)
    U1DB.LS = U1DB.LS or {}
    if forSpec then
        local spec = GetSpecialization()
        local db = U1DB.LS[spec] if not db then db = {} U1DB.LS[spec] = db end
        return db
    else
        return U1DB.LS
    end
end

--[[------------------------------------------------------------
  Automatically save equipped non-legendary items.
---------------------------------------------------------------]]
U1DB.LS = U1DB.LS or {}

-- save legendary set info
function LS.UNIT_INVENTORY_CHANGED()
    local itemTbl = {}
    local legIds = {}
    for slot, _ in pairs(LS.GEAR_SLOTS) do
        local link = GetInventoryItemLinkWithCache(slot)
        if not link then return end
        local name, _, quality = GetItemInfo(link)
        if quality == QUALITY_LEGEND then
            table.insert(legIds, GetItemIDFromLink(link))
        else
            local link = GetInventoryItemLinkWithCache(slot)
            itemTbl[slot] = link
        end
    end

    if #legIds == 2 then
        debug("LS.UNIT_INVENTORY_CHANGED")
        local db = LS.GetDB(true)
        table.sort(legIds)
        db[table.concat(legIds, ",")] = itemTbl
        itemTbl.time = GetTime()
        -- save for single item
        for _, legId in ipairs(legIds) do
            if db[legId] then
                copy(itemTbl, db[legId])
            else
                db[legId] = itemTbl
            end
        end
    end
end

CoreOnEvent("UNIT_INVENTORY_CHANGED", function(event, unit)
    if unit == "player" then
        CoreScheduleBucket("LS_UNIT_INVENTORY_CHANGED", 0.1, LS.UNIT_INVENTORY_CHANGED)
    end
end)

--[[------------------------------------------------------------
 hook UIErrorFrame
---------------------------------------------------------------]]
local onevent = UIErrorsFrame:GetScript("OnEvent")
UIErrorsFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "UI_ERROR_MESSAGE" then
        local messageType, message = ...;
        if messageType == LE_GAME_ERR_ITEM_MAX_LIMIT_CATEGORY_EQUIPPED_EXCEEDED_IS then
            return
        end
    end
    onevent(UIErrorsFrame, event, ...)
end)