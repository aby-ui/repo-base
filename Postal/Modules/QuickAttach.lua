local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_QuickAttach = Postal:NewModule("QuickAttach", "AceHook-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_QuickAttach.description = L["Allows you to quickly attach different trade items types to a mail."]
Postal_QuickAttach.description2 = L[ [[|cFFFFCC00*|r A default recipient name can be specified by right clicking on a button.
|cFFFFCC00*|r Which bags are used by this feature can be set in the main menu.]] ]
-- Trade Goods supported itemType for GetItemInfo() by WoW release version
-- Classic: Trade Goods(0), Reagent(5, 0)
-- BCC: Cloth(5), Leather(6), Metal & Stone(7), Meat(8), Herb(9), Enchanting(12), Jewelcrafting(4), Parts(1), Elemental(10), Devices(3), Explosives(2), Materials(13), Other(11)
-- Shadowlands: Cloth(5), Leather(6), Metal & Stone(7), Cooking(8), Herb(9), Enchanting(12), Inscription(16), Jewelcrafting(4), Parts(1), Elemental(10), Optional Reagents(18), Other(11)
local QAButtonPos = 0 -- Needed due to lack of static variables in lua
local QAButtonDialogInfo = "" -- Name|classID|subclassID
local QAButtons

-- Set a button's GameTooltip
local function SetQAButtonGameTooltip(button, toolTip)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetText(toolTip,1,1,1,1,true)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

-- Create QuickAttach button
local function CreateQAButton(name, texture, classID, subclassID, toolTip)
	local ofsxBase, ofsyBase, ofsyIndex = 376, 0, -40
	local buttonWidth, buttonHeight, scale = 36, 36, 0.8
	local TempButton, QAButtonCharName
	TempButton = CreateFrame("Button", name, SendMailFrame, "ActionButtonTemplate")
	TempButton.icon:SetTexture(texture) 
	TempButton:SetSize(math.floor(buttonWidth * scale), math.floor(buttonHeight * scale))
	TempButton:ClearAllPoints()
	TempButton:SetPoint("TOPRIGHT", "SendMailFrame", "TOPLEFT", ofsxBase - (buttonWidth - math.floor(buttonWidth * scale)), ofsyBase + math.floor(ofsyIndex * QAButtonPos * scale))
	TempButton.NormalTexture:SetPoint("TOPLEFT", TempButton ,"TOPLEFT", math.floor(-15 * scale), math.floor(15 * scale))
	TempButton.NormalTexture:SetPoint("BOTTOMRIGHT", TempButton ,"BOTTOMRIGHT", math.floor(15 * scale), math.floor(-15 * scale))
	TempButton:RegisterForClicks("AnyUp")
	TempButton:SetScript("OnClick", function(self, button, down) Postal_QuickAttachButtonClick(button, classID, subclassID) end)
	TempButton:SetFrameLevel(TempButton:GetFrameLevel() + 1)
	QAButtonCharName = Postal_QuickAttachGetQAButtonCharName(classID, subclassID)
	if QAButtonCharName ~= "" then toolTip = toolTip.."\n"..L["Default recipient:"].." "..QAButtonCharName end
	SetQAButtonGameTooltip(TempButton, toolTip)
	QAButtonPos = QAButtonPos + 1
end

-- Hide QuickAttach Buttons
local function Postal_QuickAttachHideButtons()
	local i, name
	for i = 1, #QAButtons, 1 do
		name = "Postal_QuickAttachButton"..tostring(i)
		if _G[name] then _G[name]:Hide() end
	end
end

-- Show QuickAttach Buttons
local function Postal_QuickAttachShowButtons()
	local i, name
	for i = 1, #QAButtons, 1 do
		name = "Postal_QuickAttachButton"..tostring(i)
		if _G[name] then _G[name]:Show() end
	end
end

-- Create QuickAttach buttons and hook OnClick events
function Postal_QuickAttach:OnEnable()
	if not Postal_QuickAttachButton1 then
		QAButtons = {}
		if Postal.WOWClassic == true then
			table.insert(QAButtons, {"Postal_QuickAttachButton1", GetSpellTexture(2018), 7, 0, L["Trade Goods"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton2", "Interface/Icons/inv_misc_food_02", 5, 0, L["Reagent"]})
		end
		if Postal.WOWBCClassic == true then
			table.insert(QAButtons, {"Postal_QuickAttachButton1", GetSpellTexture(3908), 7, 5, L["Cloth"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton2", GetSpellTexture(2108), 7, 6, L["Leather"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton3", GetSpellTexture(2656), 7, 7, L["Metal & Stone"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton4", GetSpellTexture(2550), 7, 8, L["Cooking"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton5", GetSpellTexture(2383), 7, 9, L["Herb"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton6", GetSpellTexture(7411), 7, 12, L["Enchanting"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton7", GetSpellTexture(25229), 7, 4, L["Jewelcrafting"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton8", "Interface/Icons/INV_Gizmo_FelIronCasing", 7, 1, L["Parts"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton9", "Interface/Icons/INV_Elemental_Primal_Air", 7, 10, L["Elemental"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton10", "Interface/Icons/inv_gizmo_goblingtonkcontroller", 7, 3, L["Devices"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton11", "Interface/Icons/INV_Misc_Ammo_Gunpowder_01", 7, 2, L["Explosives"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton12", "Interface/Icons/INV_Misc_Rune_09", 7, 11, L["Other"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton13", "Interface/Icons/Ability_Ensnare", 7, -1, L["Trade Goods"]})
		end
		if Postal.WOWRetail == true then
			table.insert(QAButtons, {"Postal_QuickAttachButton1", GetSpellTexture(3908), 7, 5, L["Cloth"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton2", GetSpellTexture(2108), 7, 6, L["Leather"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton3", GetSpellTexture(2656), 7, 7, L["Metal & Stone"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton4", GetSpellTexture(2550), 7, 8, L["Cooking"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton5", GetSpellTexture(2383), 7, 9, L["Herb"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton6", GetSpellTexture(7411), 7, 12, L["Enchanting"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton7", GetSpellTexture(45357), 7, 16, L["Inscription"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton8", GetSpellTexture(25229), 7, 4, L["Jewelcrafting"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton9", "Interface/Icons/INV_Gizmo_FelIronCasing", 7, 1, L["Parts"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton10", "Interface/Icons/INV_Elemental_Primal_Air", 7, 10, L["Elemental"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton11", "Interface/Icons/INV_Bijou_Green", 7, 18, L["Optional Reagents"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton12", "Interface/Icons/INV_Misc_Rune_09", 7, 11, L["Other"]})
			table.insert(QAButtons, {"Postal_QuickAttachButton13", "Interface/Icons/Ability_Ensnare", 7, -1, L["Trade Goods"]})
		end
		for i = 1, #QAButtons, 1 do
			CreateQAButton(QAButtons[i][1], QAButtons[i][2], QAButtons[i][3], QAButtons[i][4], QAButtons[i][5])
		end
	end
	Postal_QuickAttachShowButtons()
end

-- Disabling modules unregisters all events/hook automatically
function Postal_QuickAttach:OnDisable()
	Postal_QuickAttach:UnregisterAllEvents()
	Postal_QuickAttachHideButtons()
end

-- Return how many free item slots are in the current send mail
local function SendMailNumberOfFreeSlots()
	local itemIndex, NumberOfFreeSlots
	NumberOfFreeSlots = ATTACHMENTS_MAX_SEND
	for itemIndex = 1, ATTACHMENTS_MAX_SEND do
		if HasSendMailItem(itemIndex) then
			NumberOfFreeSlots = NumberOfFreeSlots - 1
		end
	end
	return NumberOfFreeSlots
end

-- Take an action based on a QuickAttach button click
function Postal_QuickAttachButtonClick(button, classID, subclassID)
	if (button ==  "LeftButton") then Postal_QuickAttachLeftButtonClick(classID, subclassID) end
	if (button ==  "RightButton") then Postal_QuickAttachRightButtonClick(classID, subclassID) end
end

-- Attach as many items as possible of the specified type to the current send mail.
function Postal_QuickAttachLeftButtonClick(classID, subclassID)
	local bagID, bindType, itemclassID, itemID, itemsubclassID, locked, slot, slotIndex
	local name = Postal_QuickAttachGetQAButtonCharName(classID, subclassID)
	if name ~= "" then
		SendMailNameEditBox:SetText(name)
		SendMailNameEditBox:HighlightText()
	end
	for bagID = 0, 4, 1 do
		if (bagID == 0) and Postal.db.profile.QuickAttach.EnableBag0 or
			(bagID == 1) and Postal.db.profile.QuickAttach.EnableBag1 or
			(bagID == 2) and Postal.db.profile.QuickAttach.EnableBag2 or
			(bagID == 3) and Postal.db.profile.QuickAttach.EnableBag3 or
			(bagID == 4) and Postal.db.profile.QuickAttach.EnableBag4
		then
			local numberOfSlots = GetContainerNumSlots(bagID)
			for slotIndex = 1, numberOfSlots, 1 do
				locked = select(3, GetContainerItemInfo(bagID, slotIndex))
				if locked == false then
					itemID = select(10, GetContainerItemInfo(bagID, slotIndex))
					if itemID then
						bindType = select(14, GetItemInfo(itemID))
						if bindType ~= 	LE_ITEM_BIND_ON_ACQUIRE then
							itemclassID = select(12, GetItemInfo(itemID))
							if itemclassID == classID then
								itemsubclassID = select(13, GetItemInfo(itemID))
								if itemsubclassID == subclassID or subclassID == -1 then
										if SendMailNumberOfFreeSlots() > 0 then
											PickupContainerItem(bagID, slotIndex)
											ClickSendMailItemButton()
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Set the default recipient name to be filled in for the specified type.
function Postal_QuickAttachRightButtonClick(classID, subclassID)
	local name = Postal_QuickAttachGetQAButtonCharName(classID, subclassID)
	QAButtonDialogInfo = name.."|"..classID.."|"..subclassID
	StaticPopup_Show("POSTAL_QUICKATTACH_CHARACTER_NAME")
end

-- Check if a default character name for the specified type has been set and return it.
function Postal_QuickAttachGetQAButtonCharName(classID, subclassID)
	local db = Postal.db.profile
	if not (db.QuickAttach) then return "" end
	if not (db.QuickAttach.QAbuttons) then return "" end
	db = Postal.db.profile.QuickAttach.QAbuttons
	for i = #db, 1, -1 do
		local n, c, s = strsplit("|", db[i])
		if tonumber(c) == tonumber(classID) and tonumber(s) == tonumber(subclassID) then
			return n
		end
	end
	return ""
end

-- Set and store a default character name for the specified type.
local function Postal_QuickAttachSetQAButtonCharName(name, classID, subclassID)
	local db = Postal.db.profile
	local buttonString = ("%s|%s|%s"):format(name, classID, subclassID)
	if not (db.QuickAttach) then db.QuickAttach = {} end
	if not (db.QuickAttach.QAbuttons) then db.QuickAttach.QAbuttons = {} end
	db = Postal.db.profile.QuickAttach.QAbuttons
	for i = #db, 1, -1 do
		local n, c, s = strsplit("|", db[i])
		if tonumber(c) == tonumber(classID) and tonumber(s) == tonumber(subclassID) then
			tremove(db, i)
		end
	end
	if name ~= "" then tinsert(db, buttonString) end
	table.sort(db)
	if #db == 0 then wipe(Postal.db.profile.QuickAttach) end
	for i = 1, #QAButtons, 1 do
		local c, s, t = QAButtons[i][3], QAButtons[i][4], QAButtons[i][5]
		if tonumber(c) == tonumber(classID) and tonumber(s) == tonumber(subclassID) then
			if name ~= "" then t = t.."\n"..L["Default recipient:"].." "..name end
			SetQAButtonGameTooltip(_G[QAButtons[i][1]], t)
		end
	end	
end

-- Define static popup for default character name dialog.
StaticPopupDialogs["POSTAL_QUICKATTACH_CHARACTER_NAME"] = {
	text = L["Default recipient:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 128,
	editBoxWidth = 350,  -- Needed in Cata
	OnAccept = function(self)
		local name, classID, subclassID = strsplit("|", QAButtonDialogInfo)
		name = strtrim(self.editBox:GetText())
		Postal_QuickAttachSetQAButtonCharName(name, classID, subclassID)	
	end,
	OnShow = function(self)
		local name, classID, subclassID = strsplit("|", QAButtonDialogInfo)
		self.editBox:SetText(name)
		self.editBox:HighlightText()
		self.editBox:SetFocus()
	end,
	OnHide = StaticPopupDialogs["SET_GUILDPLAYERNOTE"].OnHide,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		local name, classID, subclassID = strsplit("|", QAButtonDialogInfo)
		name = strtrim(parent.editBox:GetText())
		Postal_QuickAttachSetQAButtonCharName(name, classID, subclassID)	
		parent:Hide()
	end,
	EditBoxOnEscapePressed = StaticPopupDialogs["SET_GUILDPLAYERNOTE"].EditBoxOnEscapePressed,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

-- Creat QuickAttach Menu
function Postal_QuickAttach.ModuleMenu(self, level)
	if not level then return end
	local info = self.info
	wipe(info)
	info.isNotRadio = 1
	if level == 1 + self.levelAdjust then
		local db = Postal.db.profile.QuickAttach
		info.keepShownOnClick = 1

		info.text = L["Enable for backpack"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag0"
		info.checked = Postal.db.profile.QuickAttach.EnableBag0
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag one"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag1"
		info.checked = Postal.db.profile.QuickAttach.EnableBag1
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag two"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag2"
		info.checked = Postal.db.profile.QuickAttach.EnableBag2
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag three"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag3"
		info.checked = Postal.db.profile.QuickAttach.EnableBag3
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag four"]
		info.func = Postal.SaveOption
		info.arg1 = "QuickAttach"
		info.arg2 = "EnableBag4"
		info.checked = Postal.db.profile.QuickAttach.EnableBag4
		UIDropDownMenu_AddButton(info, level)
	end
end
