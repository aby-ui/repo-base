------------------------------------------------------------
-- Menu.lua
--
-- Abin
-- 2011-8-22
------------------------------------------------------------

local type = type
local strfind = strfind
local HideDropDownMenu = HideDropDownMenu
local ToggleDropDownMenu = ToggleDropDownMenu
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
local GameTooltip = GameTooltip
local NUM_GEARSET_ICONS_SHOWN = NUM_GEARSET_ICONS_SHOWN
local _G = _G

local _, addon = ...
local L = addon.L
local EMPANEL = PaperDollEquipmentManagerPane
local curSetName, curSetIcon, curSetID

local function OnMenuResaveSet()
	addon:ResaveSet(curSetID)
end

local function OnMenuDeleteSet()
	addon:DeleteSet(curSetID)
end

local function OnMenuRenameSet()
	addon:RenameSet(curSetName)
end

local function OnMenuDepositSet()
	addon:BankSet(curSetName, 1)
end

local function OnMenuWithdrawSet()
	addon:BankSet(curSetName)
end

local function OnMenuBindSetToTalent1()
	addon:BindSetToTalent(curSetID, 1)
end

local function OnMenuBindSetToTalent2()
	addon:BindSetToTalent(curSetID, 2)
end

local function OnMenuBindSetToTalent3()
	addon:BindSetToTalent(curSetID, 3)
end

local function OnMenuBindSetToTalent4()
	addon:BindSetToTalent(curSetID, 4)
end

local t_funcs_OnMenuBindSetToTalent = {
	OnMenuBindSetToTalent1,
	OnMenuBindSetToTalent2,
	OnMenuBindSetToTalent3,
	OnMenuBindSetToTalent4,
}
local function OnMenuShowHelm()
	addon:ToggleShowHelm(curSetName)
end

local function OnMenuShowCloak()
	addon:ToggleShowCloak(curSetName)
end

function addon:SetMenuSet(setID)
	local name, icon
	if type(setID) ~= "number" then
		setID = nil
	else
		name, icon = C_EquipmentSet.GetEquipmentSetInfo(setID)
	end

	if not name then
		setID = nil
	end

	if setID then
		if icon and type(icon) ~= "number" and not strfind(icon, "\\") then
			icon = "Interface\\Icons\\"..icon
		end
	else
		HideDropDownMenu(1)
	end

	curSetName, curSetIcon, curSetID = name, icon, setID
	return name, icon, setID
end

function addon:GetMenuSet()
	return curSetName, curSetIcon, curSetID
end

-- The drop down frame for set buttons
local frame = CreateFrame("Button", "GearManagerExDropDownMenu", EMPANEL, "UIDropDownMenuTemplate")
local lastOwner
function addon:ToggleMenu(parent, point, relativeTo, relativePoint, xOffset, yOffset)
	if not curSetName then
		HideDropDownMenu(1)
		return
	end

	frame:SetParent(parent or UIParent)
	frame.point = point
	frame.relativeTo = relativeTo
	frame.relativePoint = relativePoint
	frame.xOffset = type(xOffset) == "number" and yOffset or 0
	frame.yOffset = type(yOffset) == "number" and yOffset or 0

	if lastOwner ~= relativeTo then
		lastOwner = relativeTo
		HideDropDownMenu(1)
	end

	ToggleDropDownMenu(nil, nil, frame)
	return 1
end

local function BuildMenu()
	UIDropDownMenu_AddButton({ text = curSetName, isTitle = 1, icon = curSetIcon, notCheckable = 1 })
	UIDropDownMenu_AddButton({ text = L["save set"], func = OnMenuResaveSet, notCheckable = 1 })
	UIDropDownMenu_AddButton({ text = L["delete set"], func = OnMenuDeleteSet, notCheckable = 1 })
	UIDropDownMenu_AddButton({ text = L["rename set"], disabled = not addon.activeSet or addon.activeSet ~= curSetName, func = OnMenuRenameSet, notCheckable = 1 })
	UIDropDownMenu_AddButton({ text = L["put into bank"], disabled = not addon.bankOpened, func = OnMenuDepositSet, notCheckable = 1 })
	UIDropDownMenu_AddButton({ text = L["take from bank"], disabled = not addon.bankOpened, func = OnMenuWithdrawSet, notCheckable = 1 })
	--UIDropDownMenu_AddButton({ text = SHOW_CLOAK, checked = addon.db.showCloaks[curSetName] == 1, func = OnMenuShowCloak, isNotRadio = true })
	--UIDropDownMenu_AddButton({ text = SHOW_HELM, checked = addon.db.showHelms[curSetName] == 1, func = OnMenuShowHelm, isNotRadio = true })
	if GetNumSpecializations() > 1 then
		local numSpecs = GetNumSpecializations();
		local sex = UnitSex("player");
		for i = 1, numSpecs do
			local _, name, description, icon = GetSpecializationInfo(i, false, false, nil, sex);
			UIDropDownMenu_AddButton({ text = L["bind to"]..name, checked = C_EquipmentSet.GetEquipmentSetForSpec(i) == curSetID, func = t_funcs_OnMenuBindSetToTalent[i], isNotRadio = true })
		end
	end
	UIDropDownMenu_AddButton({ text = CLOSE, notCheckable = 1 })
end

function addon:BuildMenu()
	BuildMenu()
end

function addon:BuildDewdropMenu(dewdrop)
	if type(dewdrop) ~= "table" or type(dewdrop.AddLine) ~= "function" then
		return
	end
	dewdrop:AddLine("text", curSetName, "isTitle", 1, "icon", curSetIcon)
	dewdrop:AddLine("text", L["save set"], "disabled", addon.activeSet and addon.activeSet ~= curSetName, "func", OnMenuResaveSet)
	dewdrop:AddLine("text", L["delete set"], "func", OnMenuDeleteSet)
	dewdrop:AddLine("text", L["rename set"], "disabled", not addon.activeSet or addon.activeSet ~= curSetName, "func", OnMenuRenameSet)
	dewdrop:AddLine("text", L["put into bank"], "disabled", not addon.bankOpened, "func", OnMenuDepositSet)
	dewdrop:AddLine("text", L["take from bank"], "disabled", not addon.bankOpened, "func", OnMenuWithdrawSet)
	--dewdrop:AddLine("text", SHOW_CLOAK, "checked", addon.db.showCloaks[curSetName] == 1, "func", OnMenuShowCloak)
	--dewdrop:AddLine("text", SHOW_HELM, "checked", addon.db.showHelms[curSetName] == 1, "func", OnMenuShowHelm)
	if GetNumSpecializations() > 1 then
		local numSpecs = GetNumSpecializations();
		local sex = UnitSex("player");
		for i = 1, numSpecs do
			local _, name, description, icon = GetSpecializationInfo(i, false, false, nil, sex);
			dewdrop:AddLine("text", L["bind to"]..name, "checked", C_EquipmentSet.GetEquipmentSetForSpec(i) == curSetID, "func", t_funcs_OnMenuBindSetToTalent[i])
		end
	end
	dewdrop:AddLine("text", CLOSE)
end

UIDropDownMenu_Initialize(frame, BuildMenu, "MENU")

-- Hook "OnMouseDown" for every button to show the drop down menu
local function GearSetButton_OnMouseDown(self, button)
	if button == "RightButton" and type(self.setID) == "number" then
		addon:SetMenuSet(self.setID)
		addon:ToggleMenu(EMPANEL, "TOPLEFT", self, "BOTTOMLEFT", -4, -4)
	end
	GameTooltip:Hide()
end

local managerPaneShown
EMPANEL:HookScript("OnShow", function(self)
	if managerPaneShown then
		return
	end
	managerPaneShown = 1
	local i
	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		local button = _G[EMPANEL:GetName().."Button"..i]
		if button then
			button:HookScript("OnMouseDown", GearSetButton_OnMouseDown)
		end
	end
end)