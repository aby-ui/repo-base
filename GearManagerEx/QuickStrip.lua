------------------------------------------------------------
-- Quickstrip.lua
--
-- Abin
-- 2011-8-22
------------------------------------------------------------

local InCombatLockdown = InCombatLockdown
local GetContainerNumSlots = GetContainerNumSlots
local select = select
local GetContainerItemInfo = GetContainerItemInfo
local type = type
local GetInventoryItemLink = GetInventoryItemLink
local PickupInventoryItem = PickupInventoryItem
local CursorHasItem = CursorHasItem
local PutItemInBackpack = PutItemInBackpack
local PutItemInBag = PutItemInBag
local pairs = pairs
local EquipCursorItem = EquipCursorItem
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local HasFullControl = HasFullControl
local GetTime = GetTime
local format = format
local ClearCursor = ClearCursor
local UIErrorsFrame = UIErrorsFrame

local _, addon = ...
local L = addon.L
local DURASLOTS = { 16, 17, 18, 5, 7, 1, 3, 8, 10, 6, 9 } -- Inventory slots that possibly have durabilities
local DURASLOTS_MAP = {} for _,v in ipairs(DURASLOTS) do DURASLOTS_MAP[v] = true end
local lastOpt = 0 -- Last operated time

local function IsEquippableSlot(slot)
    return slot > 15 or not InCombatLockdown()
end

local function GetItemLocked()
    local bag, slot
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            if select(3, GetContainerItemInfo(bag, slot)) then
                return bag, slot
            end
        end
    end
end

-- Find available bag slots to put items into
local function GetAvailableBags()
    local bags = {}
    local i
    for i = 0, 4 do
        local slots, family = GetContainerNumFreeSlots(i)
        bags[i] = (family == 0) and slots or 0
    end
    return bags
end

local function GetFirstAvailableBag(bags)
    local i
    for i = 0, 4 do
        if bags[i] > 0 then
            return i
        end
    end
end

local function FindContainerItem(lnk, allowLocked)
    if type(lnk) == "string" then
        local bag, slot
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local _, _, locked, _, _, _, link = GetContainerItemInfo(bag, slot)
                if (allowLocked or not locked) and link == lnk then
                    return bag, slot
                end
            end
        end
    end
end

local function VerifyStrippedDB()
    local hasContents
    if type(addon.db.stripped) == "table" then
        local inv, lnk
        for inv, lnk in pairs(addon.db.stripped) do
            if type(inv) == "number" and not GetInventoryItemLink("player", inv) and FindContainerItem(lnk, 1) then
                hasContents = 1
            else
                addon.db.stripped[inv] = nil
            end
        end
    end

    if not hasContents then
        addon.db.stripped = nil
    end

    return hasContents
end

-- Strip off all items those have durabilities
local temp = {}
local function StripOff()
    local count = 0
    table.wipe(temp)
    --7.0拿下一个装备可能神器的另一个也没了，所以需要存起来一起拿
    for i = 1, 17 do
        local strip_all = IsControlKeyDown() or IsShiftKeyDown()
        if i ~= 4 and (strip_all or DURASLOTS_MAP[i]) then
            local lnk = GetInventoryItemLink("player", i)
            if lnk and IsEquippableSlot(i) and (strip_all or GetInventoryItemDurability(i) or ((i==16 or i==17) and select(3, GetItemInfo(lnk))==6)) then
                temp[i] = lnk
            end
        end
    end
    local bags = GetAvailableBags()
    for i, lnk in pairs(temp) do
        local bag = GetFirstAvailableBag(bags)
        if bag then
            bags[bag] = bags[bag] - 1
            PickupInventoryItem(i)
            if CursorHasItem() then
                if bag == 0 then
                    PutItemInBackpack()
                else
                    PutItemInBag(19 + bag)
                end
            end
            addon.db.stripped = addon.db.stripped or {}

            addon.db.stripped[i] = lnk
            count = count + 1
        else
            addon:Print(ERR_INV_FULL, 1, 0, 0)
            return count
        end
    end
    return count
end

-- Wear back whatever we stripped off through a previous call to StripOff()
local function WearBack()
    local count = 0
    local inv, lnk
    for inv, lnk in pairs(addon.db.stripped) do
        if IsEquippableSlot(inv) then
            local bag, slot = FindContainerItem(lnk)
            if bag and slot then
                PickupContainerItem(bag, slot)
                if CursorHasItem() then
                    EquipCursorItem(inv)
                    count = count + 1
                end
            end
        end
    end
    addon.db.stripped = nil
    return count
end

-- Strip/wear
function addon:QuickStrip()
    if UnitIsDeadOrGhost("player") or not HasFullControl() or GetItemLocked() then
        UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0)
        return
    end

    if GetTime() - lastOpt < 2 then
        addon:Print(L["too fast"], 1, 0, 0)
        return
    end

    ClearCursor()
    if VerifyStrippedDB() then
        if(InCombatLockdown()) then
            addon:Print("战斗中无法自动穿回, 请点击套装按钮或手工装备", 1,1,0)
        else
            addon:Print(format(L["wore back"], WearBack()))
        end
    else
        addon:Print(format(L["stripped off"], StripOff()))
    end
    lastOpt = GetTime()
end