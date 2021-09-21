local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_QuickAttach = Postal:NewModule("QuickAttach", "AceHook-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_QuickAttach.description = L["Allows you to quickly attach different trade items types to a mail."]
-- Trade Goods supported itemType for GetItemInfo() by WoW release version
-- Classic: Trade Goods(0), Reagent(5, 0)
-- BCC: Cloth(5), Leather(6), Metal & Stone(7), Meat(8), Herb(9), Enchanting(12), Jewelcrafting(4), Parts(1), Elemental(10), Devices(3), Explosives(2), Materials(13), Other(11)
-- Shadowlands: Cloth(5), Leather(6), Metal & Stone(7), Cooking(8), Herb(9), Enchanting(12), Inscription(16), Jewelcrafting(4), Parts(1), Elemental(10), Optional Reagents(18), Other(11)
local QAButtonPos = 0 -- Needed due to lack of static variables in lua

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
local function CreateQAButton(name, texturePath, itemTypeclassID, itemTypesubclassID, toolTip)
	local ofsxBase, ofsyBase, ofsyIndex = 376, 0, -40
	local buttonWidth, buttonHeight, scale = 36, 36, 0.8
	local TempButton
	TempButton = CreateFrame("Button", name, SendMailFrame, "ActionButtonTemplate")
	TempButton.icon:SetTexture(texturePath) 
	TempButton:SetSize(math.floor(buttonWidth * scale), math.floor(buttonHeight * scale))
	TempButton:ClearAllPoints()
	TempButton:SetPoint("TOPRIGHT", "SendMailFrame", "TOPLEFT", ofsxBase - (buttonWidth - math.floor(buttonWidth * scale)), ofsyBase + math.floor(ofsyIndex * QAButtonPos * scale))
	TempButton.NormalTexture:SetPoint("TOPLEFT", TempButton ,"TOPLEFT", math.floor(-15 * scale), math.floor(15 * scale))
	TempButton.NormalTexture:SetPoint("BOTTOMRIGHT", TempButton ,"BOTTOMRIGHT", math.floor(15 * scale), math.floor(-15 * scale))
	TempButton:SetScript("OnClick", function() Postal_QuickAttachButtonClick(itemTypeclassID, itemTypesubclassID) end)
	TempButton:SetFrameLevel(TempButton:GetFrameLevel() + 1)
	SetQAButtonGameTooltip(TempButton, toolTip)
	QAButtonPos = QAButtonPos + 1
end

-- Hide QuickAttach Buttons
local function Postal_QuickAttachHideButtons()
	local i, name
	for i = 1, 14 do
		name = "Postal_QuickAttachButton"..tostring(i)
		if _G[name] then _G[name]:Hide() end
	end
end

-- Show QuickAttach Buttons
local function Postal_QuickAttachShowButtons()
	local i, name
	for i = 1, 14 do
		name = "Postal_QuickAttachButton"..tostring(i)
		if _G[name] then _G[name]:Show() end
	end
end

-- Create QuickAttach buttons and hook OnClick events
function Postal_QuickAttach:OnEnable()
	if not Postal_QuickAttachButton1 then
		if Postal.WOWClassic == true then
			CreateQAButton("Postal_QuickAttachButton1", GetSpellTexture(2018), 7, 0, L["Trade Goods"])
			CreateQAButton("Postal_QuickAttachButton2", "Interface/Icons/inv_misc_food_02", 5, 0, L["Reagent"])
		end
		if (Postal.WOWBCClassic == true) or (Postal.WOWRetail == true) then
			CreateQAButton("Postal_QuickAttachButton1", GetSpellTexture(3908), 7, 5, L["Cloth"])
			CreateQAButton("Postal_QuickAttachButton2", GetSpellTexture(2108), 7, 6, L["Leather"])
			CreateQAButton("Postal_QuickAttachButton3", GetSpellTexture(2656), 7, 7, L["Metal & Stone"])
			CreateQAButton("Postal_QuickAttachButton4", GetSpellTexture(2550), 7, 8, L["Cooking"])
			CreateQAButton("Postal_QuickAttachButton5", GetSpellTexture(2383), 7, 9, L["Herb"])
			CreateQAButton("Postal_QuickAttachButton6", GetSpellTexture(7411), 7, 12, L["Enchanting"])
			if Postal.WOWRetail == true then
				CreateQAButton("Postal_QuickAttachButton7", GetSpellTexture(45357), 7, 16, L["Inscription"])
			end
			CreateQAButton("Postal_QuickAttachButton8", GetSpellTexture(25229), 7, 4, L["Jewelcrafting"])
			CreateQAButton("Postal_QuickAttachButton9", "Interface/Icons/INV_Gizmo_FelIronCasing", 7, 1, L["Parts"])
			CreateQAButton("Postal_QuickAttachButton10", "Interface/Icons/INV_Elemental_Primal_Air", 7, 10, L["Elemental"])
			if Postal.WOWBCClassic == true then
				CreateQAButton("Postal_QuickAttachButton11", "Interface/Icons/inv_gizmo_goblingtonkcontroller", 7, 3, L["Devices"])
				CreateQAButton("Postal_QuickAttachButton12", "Interface/Icons/INV_Misc_Ammo_Gunpowder_01", 7, 2, L["Explosives"])
			end
			if Postal.WOWRetail == true then
				CreateQAButton("Postal_QuickAttachButton13", "Interface/Icons/INV_Bijou_Green", 7, 18, L["Optional Reagents"])
			end
			CreateQAButton("Postal_QuickAttachButton14", "Interface/Icons/INV_Misc_Rune_09", 7, 11, L["Other"])
			CreateQAButton("Postal_QuickAttachButton15", "Interface/Icons/Ability_Ensnare", 7, nil, L["Trade Goods"])
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

-- Attach as many items as possible of the specified type to the current send mail.
function Postal_QuickAttachButtonClick(classID, subclassID)
	local bagID, bindType, itemclassID, itemID, itemsubclassID, locked, slot, slotIndex
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
								if itemsubclassID == subclassID or subclassID == nil then
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
