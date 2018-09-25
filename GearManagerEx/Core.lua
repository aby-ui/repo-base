-----------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2013-10-04
-----------------------------------------------------------

local InCombatLockdown = InCombatLockdown
local GetContainerItemLink = GetContainerItemLink
local GetInventoryItemLink = GetInventoryItemLink
local strfind = strfind
local tonumber = tonumber
local ipairs = ipairs
local GetContainerNumSlots = GetContainerNumSlots
local UseContainerItem = UseContainerItem
local pairs = pairs
local HideDropDownMenu = HideDropDownMenu
local type = type
local ShowHelm = ShowHelm
local ShowCloak = ShowCloak
local format = format
local tostring = tostring
local tinsert = tinsert
local StaticPopup_Show = StaticPopup_Show
-- 7.2
function GMGetEquipmentSetInfoByName(name)
    local equipmentSetID = C_EquipmentSet.GetEquipmentSetID(name);
    if equipmentSetID then
        return C_EquipmentSet.GetEquipmentSetInfo(equipmentSetID);
    end
end
local GetEquipmentSetInfoByName = GMGetEquipmentSetInfoByName
local SaveEquipmentSet = SaveEquipmentSet
local ModifyEquipmentSet = ModifyEquipmentSet
local EquipmentManager_EquipSet = EquipmentManager_EquipSet

local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME

local addonName, addon = ...
_G["GearManagerEx"] = addon
addon.version = GetAddOnMetadata(addonName, "Version") or "1.0"
addon.name = "GearManagerEx"
addon.db = { stripped = {}, showHelms = {}, showCloaks = {}, toolbar = {} } -- Mapped to GearManagerExDB

local L = addon.L
local callbacks = {}

-- Extracts item id
local function GetItemId(bag, slot)
    local lnk
    if slot then
        lnk = GetContainerItemLink(bag, slot)
    else
        lnk = GetInventoryItemLink("player", bag)
    end

    if lnk then
        local _, _, id = strfind(lnk, "item:(%d+).+%[(.+)%]")
        return tonumber(id or "")
    end
end

-- Use a container item by id
local function UseContainerItemById(containers, itemId)
	if (itemId or 0) <= 0 or InCombatLockdown() then
        return
    end

    local bag, slot
    for _, bag in ipairs(containers) do
        for slot = 1, GetContainerNumSlots(bag) do
            local id = GetItemId(bag, slot)
            if id == itemId then
                -- No taint will occur while the bank is open
                UseContainerItem(bag, slot)
                return bag, slot
            end
        end
    end
end

-- Check whether a set is currently equipped
local function CheckSetEquipped(name)
    if not name then
        return false
    end

    local setID = C_EquipmentSet.GetEquipmentSetID(name)
    local _, icon, _, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(setID)
    return isEquipped
end

--[[ Check whether a set is currently worn
local function CheckSetWorn(equipped, name)
    if not name then
        return
    end

    local ids = GetEquipmentSetItemIDs(name)
    local k, v
    for k, v in pairs(ids) do
        if v and v ~= 1 and equipped[k] ~= v then --如果是1则表示忽略此栏位
            return
        end
    end
    return 1
end--]]

-- Find the currently worn set and update the UI
local function UpdateWornSet(silent)
    local equipped = {}
    local i, id, name
    for i = 0, 19 do
        equipped[i] = GetItemId(i) or 0
    end

    -- DONEY MOD begin 7.2
    local ids = C_EquipmentSet.GetEquipmentSetIDs()
    for i,id in ipairs(ids) do
        local setName = C_EquipmentSet.GetEquipmentSetInfo(id)
        if CheckSetEquipped(setName) then
            name = setName
            break
        end
    end
    -- DONEY MOD end

    if name ~= addon.activeSet then
		HideDropDownMenu(1)
        local prevName = addon.activeSet
        addon.activeId, addon.activeSet = id, name
        if name then
            local show = addon.db.showHelms[name]
            if type(show) == "number" then
                --ShowHelm(show == 1)
            end

            show = addon.db.showCloaks[name]
            if type(show) == "number" then
                --ShowCloak(show == 1)
            end

            if not silent then addon:Print(format(L["wore set"], name)) end
        end

        -- Notify other addons, if any interested
        addon:OnActiveSetChanged(name, prevName)
    end
end

function addon:Print(msg, r, g, b)
    DEFAULT_CHAT_FRAME:AddMessage("|cffffff78"..addon.name..":|r "..tostring(msg), r, g, b)
end

function addon:RegisterCallback(func, arg1)
    local data
    if type(func) == "function" then
        data = { func = func, arg1 = arg1 }
    elseif type(func) == "table" and type(arg1) == "string" then
        data = { object = func, func = arg1 }
    end

    if data then
        tinsert(callbacks, data)
    end
end

function addon:OnActiveSetChanged(name, prevName)
    local data
    for _, data in ipairs(callbacks) do
        if data.object then
            local func = data.object[data.func]
            if type(func) == "function" then
                func(data.object, name, prevName)
            end
        else
            if data.arg1 == nil then
                data.func(name, prevName)
            else
                data.func(data.arg1, name, prevName)
            end
        end
    end
end

-- Get the current active set info: index, name, icon
function addon:GetActiveSet()
    if addon.activeId then
        local name, icon = C_EquipmentSet.GetEquipmentSetInfo(addon.activeId)
        return name, icon, addon.activeId
    end
end

-- Moves a set into bank, or take it out of bank
local BANKS = { -1, 5, 6, 7, 8, 9, 10, 11 } -- Bag id's for bank
local BAGS = { 0, 1, 2, 3, 4 } -- Bag id's for container
function addon:BankSet(name, deposit)
    if addon.bankOpened and type(name) == "string" then
        local setids = GetEquipmentSetItemIDs(name)
        if not setids then
            return
        end

        local containers = deposit and BAGS or BANKS
        local id
        for _, id in pairs(setids) do
            if id and id ~= 0 then
                UseContainerItemById(containers, id)
            end
        end
        return 1
    end
end

-- Bind a set to a talent group
function addon:BindSetToTalent(setId, talentId)
	local numSpecs = GetNumSpecializations();
	if talentId < 1 or talentId > numSpecs then
		return
	end

    local currentSpecIndex = C_EquipmentSet.GetEquipmentSetAssignedSpec(setId);
    if type(setId) == "number" then
        if talentId ~= C_EquipmentSet.GetEquipmentSetAssignedSpec(setId) then
            C_EquipmentSet.AssignSpecToEquipmentSet(setId, talentId)
        else
            C_EquipmentSet.UnassignEquipmentSetSpec(setId);
        end
        PaperDollEquipmentManagerPane_Update(true)
    end
end

-- Directly save a set
function addon:ResaveSet(setID)
    if type(setID) == "number" then
        local name, icon = C_EquipmentSet.GetEquipmentSetInfo(setID)
        if not name then
            return
        end

        PaperDollFrame_ClearIgnoredSlots();
        PaperDollFrame_IgnoreSlotsForSet(setID);
        local dialog = StaticPopup_Show("CONFIRM_OVERWRITE_EQUIPMENT_SET", name);
        if ( dialog ) then
            dialog.data = setID;
            dialog.selectedIcon = icon;
        else
            UIErrorsFrame:AddMessage(ERR_CLIENT_LOCKED_OUT, 1.0, 0.1, 0.1, 1.0);
        end
        --[[
        SaveEquipmentSet(name, icon)
		self:Print(format(L["set saved"], name))
		]]
        return 1
    end
end

local setToRename
local function OnPopupRenameSet(name)
    name = strtrim(name or "")
    if name == "" then
        return 1
    end

    if GetEquipmentSetInfoByName(name) then
        addon:Print(format(L["name exists"], name), 1, 0, 0)
        return 1
    end

    addon.db.showHelms[name] = addon.db.showHelms[setToRename]
    addon.db.showCloaks[name] = addon.db.showCloaks[setToRename]

    addon:Print(format(L["set renamed"], setToRename, name))
    ModifyEquipmentSet(setToRename, name)
end

local renameData = {
    preferredIndex = 3,
    button1 = OKAY,
    button2 = CANCEL,
    hasEditBox = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
    hideOnEscape = 1,

    OnAccept = function(self)
        return OnPopupRenameSet(self.editBox:GetText())
    end,

    EditBoxOnEnterPressed = function(self)
        if not OnPopupRenameSet(self:GetText()) then
            self:GetParent():Hide()
        end
    end,

    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,

    OnShow = function(self)
        self.editBox:SetText(setToRename or "")
        self.editBox:SetFocus()
        self.editBox:HighlightText()
    end,
}

StaticPopupDialogs["GEARMANAGEREX_RENAMESET"] = renameData

function addon:RenameSet(name)
    if type(name) == "string" and GetEquipmentSetInfoByName(name) then
        renameData.text = format(L["label text"], name)
        setToRename = name
        StaticPopup_Show("GEARMANAGEREX_RENAMESET")
        return 1
    end
end

function addon:DeleteSet(setID)
    if type(setID) == "number" then
        local name, icon = C_EquipmentSet.GetEquipmentSetInfo(setID)
        if not name then
            return
        end
        local frame = StaticPopup_Show("CONFIRM_DELETE_EQUIPMENT_SET", name)
        frame.data = setID
        return 1
    end
end

-- Equip a set by index
function addon:EquipSetByIndex(id)
	if not InCombatLockdown() and type(id) == "number" then
        EquipmentManager_EquipSet(id)
    end
end

function addon:IsHelmShownForSet(name)
    if type(name) == "string" and GetEquipmentSetInfoByName(name) then
        return addon.db.showHelms[name] == 1
    end
end

function addon:IsCloakShownForSet(name)
    if type(name) == "string" and GetEquipmentSetInfoByName(name) then
        return addon.db.showCloaks[name] == 1
    end
end

-- Toggle show/hide helm of a set
function addon:ToggleShowHelm(name)
    if type(name) ~= "string" or not GetEquipmentSetInfoByName(name) then
        return
    end

    local show = addon.db.showHelms[name] == 1 and 0 or 1
    addon.db.showHelms[name] = show

    if addon.activeSet == name then
        ShowHelm(show == 1)
    end
end

-- Toggle show/hide cloak of a set
function addon:ToggleShowCloak(name)
    if type(name) ~= "string" or not GetEquipmentSetInfoByName(name) then
        return
    end

    local show = addon.db.showCloaks[name] == 1 and 0 or 1
    addon.db.showCloaks[name] = show

    if addon.activeSet == name then
        ShowCloak(show == 1)
    end
end

-- The background message handler frame
local needEquipSet, needCheck, updateElapsed
local frame = CreateFrame("Frame")
addon.frame = frame
frame:Hide()
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("BANKFRAME_OPENED")
frame:RegisterEvent("BANKFRAME_CLOSED")
--frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
--frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterEvent("EQUIPMENT_SETS_CHANGED")

frame:SetScript("OnEvent", function(self, event, id)
    if event == "ADDON_LOADED" and id == addonName then
		if type(GearManagerExDB) ~= "table" then
			GearManagerExDB = {}
        end

        addon.db = GearManagerExDB

        --if type(addon.db.talentBind) ~= "table" then
        --    addon.db.talentBind = {}
        --end

        if type(addon.db.showHelms) ~= "table" then
            addon.db.showHelms = {}
        end

        if type(addon.db.showCloaks) ~= "table" then
            addon.db.showCloaks = {}
        end

        if addon.toolbar then
            if type(addon.db.toolbar) ~= "table" then
                addon.db.toolbar = {numeric = 1}
            end
            addon.toolbar:OnInitialize(addon.db.toolbar)
        end

    elseif event == "BANKFRAME_OPENED" then
        addon.bankOpened = 1
		HideDropDownMenu(1)
    elseif event == "BANKFRAME_CLOSED" then
        addon.bankOpened = nil
		HideDropDownMenu(1)
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- 检测是否转换原来的配置
        if addon.db.talentBind then
            local specs = GetNumSpecializations()
            local found
            for i=1, specs do
                local setId = C_EquipmentSet.GetEquipmentSetForSpec(i)
                if setId then found = true break end
            end
            if not found then
                for spec, name in pairs(addon.db.talentBind) do
                    local setId = C_EquipmentSet.GetEquipmentSetID(name)
                    if setId then
                        C_EquipmentSet.AssignSpecToEquipmentSet(setId, spec)
                        addon:Print("已使用暴雪接口将套装'"..name.."'绑定于'"..select(2, GetSpecializationInfo(spec)).."'专精")
                    end
                end
            end
            addon.db.talentBind = nil
        end
        --self.lastSpecID = GetSpecialization()
--[[ --7.2 blizzard handle
	elseif event == "PLAYER_SPECIALIZATION_CHANGED" then
		if ( id ~= "player" ) then
			return
		end
		if (GetNumSpecializations() > 1) then
			local specID = GetSpecialization()
			if specID ~= nil and specID ~= self.lastSpecID then
				needEquipSet = C_EquipmentSet.GetEquipmentSetID(addon.db.talentBind[specID])
            end
            self.lastSpecID = specID
		end
--]]
    elseif event == "PLAYER_LOGIN" then
        updateElapsed = -3
        needCheck = "login"
        self:Show()
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        needCheck = 1 -- Highly concurrent events, use post-processing to avoid performance drop...
    elseif event == "EQUIPMENT_SETS_CHANGED" then
        local name
        for name in pairs(addon.db.showHelms) do
            if not GetEquipmentSetInfoByName(name) then
                addon.db.showHelms[name] = nil
                addon.db.showCloaks[name] = nil
            end
        end

        for name in pairs(addon.db.showCloaks) do
            if not GetEquipmentSetInfoByName(name) then
                addon.db.showCloaks[name] = nil
            end
        end

        UpdateWornSet()
    end
end)

frame:SetScript("OnUpdate", function(self, elapsed)
    updateElapsed = (updateElapsed or 0) + elapsed
	if updateElapsed > 0.2 then
        updateElapsed = 0

		--[[if needEquipSet and not InCombatLockdown() then
            EquipmentManager_EquipSet(needEquipSet)
            needEquipSet = nil
        else--]]if needCheck then
            UpdateWornSet(needCheck=="login")
            needCheck = nil
        end
    end
end)

-- Prompt the player that he can right-click a set for more operations
hooksecurefunc("GearSetButton_OnEnter", function(self)
    if type(self.name) == "string" and self.name ~= "" and GameTooltipTextLeft1:GetText() == self.name then
        GameTooltip:AddLine(L["tooltip prompt"], 0, 1, 0, 1)
        GameTooltip:Show()
    end
end)

------------------------------------------------------------
-- Binding texts
------------------------------------------------------------

BINDING_HEADER_GEARMANAGEREX_TITLE = addon.name
BINDING_NAME_GEARMANAGEREX_QUICKSTRIP = L["quick strip"]
BINDING_NAME_GEARMANAGEREX_WEARSET1 = L["wear set"].." 1"
BINDING_NAME_GEARMANAGEREX_WEARSET2 = L["wear set"].." 2"
BINDING_NAME_GEARMANAGEREX_WEARSET3 = L["wear set"].." 3"
BINDING_NAME_GEARMANAGEREX_WEARSET4 = L["wear set"].." 4"
BINDING_NAME_GEARMANAGEREX_WEARSET5 = L["wear set"].." 5"
BINDING_NAME_GEARMANAGEREX_WEARSET6 = L["wear set"].." 6"
BINDING_NAME_GEARMANAGEREX_WEARSET7 = L["wear set"].." 7"
BINDING_NAME_GEARMANAGEREX_WEARSET8 = L["wear set"].." 8"
BINDING_NAME_GEARMANAGEREX_WEARSET9 = L["wear set"].." 9"
BINDING_NAME_GEARMANAGEREX_WEARSET10 = L["wear set"].." 10"

function GearManagerEx_Toggle(noCreate)
    -- 关闭
    if PaperDollEquipmentManagerPane:IsVisible() then
        ToggleCharacter("PaperDollFrame")
        return
    end
    -- 打开
    if not PaperDollFrame:IsVisible() then
        ToggleCharacter("PaperDollFrame");
    end

    if not CharacterFrame.Expanded then CharacterFrame_Expand() end

    RunOnNextFrame(function()
        PaperDollFrame_SetSidebar(PaperDollSidebarTab3, PaperDollSidebarTab3:GetID())
        if not noCreate then
            --from GearSetButton_OnClick
            GearManagerDialogPopup:Show();
            PaperDollEquipmentManagerPane.selectedSetName = nil;
            PaperDollFrame_ClearIgnoredSlots();
            PaperDollEquipmentManagerPane_Update(true);
            -- Ignore shirt and tabard by default
            PaperDollFrame_IgnoreSlot(4);
            PaperDollFrame_IgnoreSlot(19);
            --PaperDollFrame_IgnoreSlot(16); --7.0 ignore weapons
            --PaperDollFrame_IgnoreSlot(17);
            StaticPopup_Hide("CONFIRM_SAVE_EQUIPMENT_SET");
            StaticPopup_Hide("CONFIRM_OVERWRITE_EQUIPMENT_SET");
            --GearSetButton_OnClick(_empty_table); --taint?
        end
    end)
end

--绑定专精到套装时，从惩戒或神圣切换防护时，不是把双手武器与盾牌交换，而是放到第一个位置，很烦
do
    local curr, avail, rev = {}, {}, {}
    local slots = {16, 17}

    -- 用 GetInventoryItemsForSlot 查找主手副手可能的装备位置
    local function findLocationsForSlots()
        wipe(avail)
        wipe(rev)
        for _, slot in ipairs(slots) do
            GetInventoryItemsForSlot(slot, avail)
        end
        for loc,v in pairs(avail) do
            local player, bank, bags, void, slot, bag = EquipmentManager_UnpackLocation(loc);
            if bags and slot and bag then
                local link = GetContainerItemLink(bag, slot)
                rev[link] = loc
            end
        end
    end

    -- 在背包里查找被换下来的装备
    local function findInBag()
        for bag = 0, NUM_BAG_SLOTS do
            for slot = 1, GetContainerNumSlots(bag) do
                local link = GetContainerItemLink(bag, slot)
                if link and curr[link] then
                    curr[link] = nil
                    return bag, slot
                end
            end
        end
    end

    -- 查看被换上去的装备的原来位置是否有空位
    local function findAndSwapItem()
        for _, invSlot in ipairs(slots) do
            local link = GetInventoryItemLink("player", invSlot)
            local loc = link and rev[link]
            if loc then
                local player, bank, bags, void, slot, bag = EquipmentManager_UnpackLocation(loc);
                -- 换上来的装备原来在背包里，看看那个位置现在是不是空的
                if bags and bag and slot then
                    if GetContainerItemLink(bag, slot) == nil then
                        --print(link .. "'s spot is empty")
                        local cbag, cslot, foundlink = findInBag(curr) --从背包里找第一个被换下来的装备，无论 GetInsertItemsLeftToRight 如何都是从前往后放的
                        if cbag and cslot then
                            PickupContainerItem(cbag, cslot)
                            PickupContainerItem(bag, slot)
                            --U1Message(format("put %s from %d, %d to %d, %d", link, cbag, cslot, bag, slot))
                            break
                        end
                    end
                end
            end
        end
    end

    CoreOnEvent("EQUIPMENT_SWAP_FINISHED", function(event, success)
        if not success then return end
        wipe(curr)
        for _, slot in ipairs(slots) do
            curr[GetInventoryItemLink("player", slot) or ""] = true
        end
        findLocationsForSlots()
        CoreScheduleTimer(false, 0.1, findAndSwapItem)
    end)
end

