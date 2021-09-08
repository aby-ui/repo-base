local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_QuickAttach = Postal:NewModule("QuickAttach", "AceHook-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_QuickAttach.description = L["Allows you to quickly attach different trade items types to a mail."]
-- Trade Goods supported itemType for GetItemInfo() by WoW release version
-- Classic: Trade Goods(0), Reagent(5, 0)
-- BCC: Cloth(5), Leather(6), Metal & Stone(7), Meat(8), Herb(9), Enchanting(12), Jewelcrafting(4), Parts(1), Elemental(10), Devices(3), Explosives(2), Materials(13), Other(11)
-- Shadowlands: Cloth(5), Leather(6), Metal & Stone(7), Cooking(8), Herb(9), Enchanting(12), Inscription(16), Jewelcrafting(4), Parts(1), Elemental(10), Optional Reagents(18), Other(11)

-- Set a button's GameTooltip
local function SetButtonGameTooltip(button, tip)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:SetText(tip,1,1,1,1,true)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)
end

-- Create QuickAttach buttons and hook OnClick events
function Postal_QuickAttach:OnEnable()
	local Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight = 36, 36
	local ofsy, ofsyindex = 0, -40
	if not Postal_QuickAttachButton1 then
		if Postal.WOWClassic == true then
			-- Create Trade Goods Button
			Postal_QuickAttachButton1 = CreateFrame("Button", "Postal_QuickAttachButton1", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton1.icon:SetTexture(GetSpellTexture(2018)) -- Trade Goods
			Postal_QuickAttachButton1:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton1:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton1:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 0) end)
			Postal_QuickAttachButton1:SetFrameLevel(Postal_QuickAttachButton1:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton1, L["Trade Goods"])
			ofsy = ofsy + ofsyindex
			-- Create Reagent Button
			Postal_QuickAttachButton2 = CreateFrame("Button", "Postal_QuickAttachButton2", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton2.icon:SetTexture("Interface/Icons/inv_misc_food_02") -- Reagent
			Postal_QuickAttachButton2:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton2:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton2:SetScript("OnClick", function() Postal_QuickAttachButtonClick(5, 0) end)
			Postal_QuickAttachButton2:SetFrameLevel(Postal_QuickAttachButton2:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton2, L["Reagent"])
			ofsy = ofsy + ofsyindex
		end
		if (Postal.WOWBCClassic == true) or (Postal.WOWRetail == true) then
			-- Create Cloth Button
			Postal_QuickAttachButton1 = CreateFrame("Button", "Postal_QuickAttachButton1", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton1.icon:SetTexture(GetSpellTexture(3908)) -- Cloth
			Postal_QuickAttachButton1:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton1:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton1:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 5) end)
			Postal_QuickAttachButton1:SetFrameLevel(Postal_QuickAttachButton1:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton1, L["Cloth"])
			ofsy = ofsy + ofsyindex
			-- Create Leather Button
			Postal_QuickAttachButton2 = CreateFrame("Button", "Postal_QuickAttachButton2", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton2.icon:SetTexture(GetSpellTexture(2108)) -- Leather
			Postal_QuickAttachButton2:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton2:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton2:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 6) end)
			Postal_QuickAttachButton2:SetFrameLevel(Postal_QuickAttachButton2:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton2, L["Leather"])
			ofsy = ofsy + ofsyindex
			-- Create Metal & Stone Button
			Postal_QuickAttachButton3 = CreateFrame("Button", "Postal_QuickAttachButton3", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton3.icon:SetTexture(GetSpellTexture(2656)) -- Metal & Stone
			Postal_QuickAttachButton3:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton3:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton3:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 7) end)
			Postal_QuickAttachButton3:SetFrameLevel(Postal_QuickAttachButton3:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton3, L["Metal & Stone"])
			ofsy = ofsy + ofsyindex
			-- Create Cooking Button
			Postal_QuickAttachButton4 = CreateFrame("Button", "Postal_QuickAttachButton4", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton4.icon:SetTexture(GetSpellTexture(2550)) -- Cooking
			Postal_QuickAttachButton4:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton4:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton4:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 8) end)
			Postal_QuickAttachButton4:SetFrameLevel(Postal_QuickAttachButton4:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton4, L["Cooking"])
			ofsy = ofsy + ofsyindex
			-- Create Herb Button
			Postal_QuickAttachButton5 = CreateFrame("Button", "Postal_QuickAttachButton5", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton5.icon:SetTexture(GetSpellTexture(2383)) -- Herb
			Postal_QuickAttachButton5:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton5:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton5:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 9) end)
			Postal_QuickAttachButton5:SetFrameLevel(Postal_QuickAttachButton5:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton5, L["Herb"])
			ofsy = ofsy + ofsyindex
			-- Create Enchanting Button
			Postal_QuickAttachButton6 = CreateFrame("Button", "Postal_QuickAttachButton6", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton6.icon:SetTexture(GetSpellTexture(7411)) -- Enchanting
			Postal_QuickAttachButton6:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton6:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton6:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 12) end)
			Postal_QuickAttachButton6:SetFrameLevel(Postal_QuickAttachButton6:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton6, L["Enchanting"])
			ofsy = ofsy + ofsyindex
			if Postal.WOWRetail == true then
				-- Create Inscription Button
				Postal_QuickAttachButton7 = CreateFrame("Button", "Postal_QuickAttachButton7", SendMailFrame, "ActionButtonTemplate")
				Postal_QuickAttachButton7.icon:SetTexture(GetSpellTexture(45357)) -- Inscription
				Postal_QuickAttachButton7:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
				Postal_QuickAttachButton7:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
				Postal_QuickAttachButton7:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 16) end)
				Postal_QuickAttachButton7:SetFrameLevel(Postal_QuickAttachButton7:GetFrameLevel() + 1)
				SetButtonGameTooltip(Postal_QuickAttachButton7, L["Inscription"])
				ofsy = ofsy + ofsyindex
			end
			-- Create Jewelcrafting Button
			Postal_QuickAttachButton8 = CreateFrame("Button", "Postal_QuickAttachButton8", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton8.icon:SetTexture(GetSpellTexture(25229)) -- Jewelcrafting
			Postal_QuickAttachButton8:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton8:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton8:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 4) end)
			Postal_QuickAttachButton8:SetFrameLevel(Postal_QuickAttachButton8:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton8, L["Jewelcrafting"])
			ofsy = ofsy + ofsyindex
			-- Create Parts Button
			Postal_QuickAttachButton9 = CreateFrame("Button", "Postal_QuickAttachButton9", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton9.icon:SetTexture("Interface/Icons/INV_Gizmo_FelIronCasing") -- Parts
			Postal_QuickAttachButton9:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton9:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton9:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 1) end)
			Postal_QuickAttachButton9:SetFrameLevel(Postal_QuickAttachButton9:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton9, L["Parts"])
			ofsy = ofsy + ofsyindex
			-- Create Elemental Button
			Postal_QuickAttachButton10 = CreateFrame("Button", "Postal_QuickAttachButton10", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton10.icon:SetTexture("Interface/Icons/INV_Elemental_Primal_Air") -- Elemental
			Postal_QuickAttachButton10:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton10:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton10:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 10) end)
			Postal_QuickAttachButton10:SetFrameLevel(Postal_QuickAttachButton10:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton10, L["Elemental"])
			ofsy = ofsy + ofsyindex
			if Postal.WOWBCClassic == true then
				-- Create Devices Button
				Postal_QuickAttachButton11 = CreateFrame("Button", "Postal_QuickAttachButton11", SendMailFrame, "ActionButtonTemplate")
				Postal_QuickAttachButton11.icon:SetTexture("Interface/Icons/inv_gizmo_goblingtonkcontroller") -- Devices
				Postal_QuickAttachButton11:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
				Postal_QuickAttachButton11:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
				Postal_QuickAttachButton11:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 3) end)
				Postal_QuickAttachButton11:SetFrameLevel(Postal_QuickAttachButton11:GetFrameLevel() + 1)
				SetButtonGameTooltip(Postal_QuickAttachButton11, L["Devices"])
				ofsy = ofsy + ofsyindex
				-- Create Explosives Button
				Postal_QuickAttachButton12 = CreateFrame("Button", "Postal_QuickAttachButton12", SendMailFrame, "ActionButtonTemplate")
				Postal_QuickAttachButton12.icon:SetTexture("Interface/Icons/INV_Misc_Ammo_Gunpowder_01") -- Explosives
				Postal_QuickAttachButton12:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
				Postal_QuickAttachButton12:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
				Postal_QuickAttachButton12:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 2) end)
				Postal_QuickAttachButton12:SetFrameLevel(Postal_QuickAttachButton12:GetFrameLevel() + 1)
				SetButtonGameTooltip(Postal_QuickAttachButton12, L["Explosives"])
				ofsy = ofsy + ofsyindex
			end
			if Postal.WOWRetail == true then
				-- Create Optional Reagents Button
				Postal_QuickAttachButton13 = CreateFrame("Button", "Postal_QuickAttachButton13", SendMailFrame, "ActionButtonTemplate")
				Postal_QuickAttachButton13.icon:SetTexture("Interface/Icons/INV_Bijou_Green") -- Optional Reagents
				Postal_QuickAttachButton13:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
				Postal_QuickAttachButton13:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
				Postal_QuickAttachButton13:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 18) end)
				Postal_QuickAttachButton13:SetFrameLevel(Postal_QuickAttachButton13:GetFrameLevel() + 1)
				SetButtonGameTooltip(Postal_QuickAttachButton13, L["Optional Reagents"])
				ofsy = ofsy + ofsyindex
			end
			-- Create Other Button
			Postal_QuickAttachButton14 = CreateFrame("Button", "Postal_QuickAttachButton14", SendMailFrame, "ActionButtonTemplate")
			Postal_QuickAttachButton14.icon:SetTexture("Interface/Icons/INV_Misc_Rune_09") -- Other
			Postal_QuickAttachButton14:SetSize(Postal_QuickAttachButtonWidth, Postal_QuickAttachButtonHeight)
			Postal_QuickAttachButton14:SetPoint("TOPRIGHT", "SendMailFrame", "TOPRIGHT", -7, ofsy)
			Postal_QuickAttachButton14:SetScript("OnClick", function() Postal_QuickAttachButtonClick(7, 11) end)
			Postal_QuickAttachButton14:SetFrameLevel(Postal_QuickAttachButton14:GetFrameLevel() + 1)
			SetButtonGameTooltip(Postal_QuickAttachButton14, L["Other"])
			ofsy = ofsy + ofsyindex
		end
	end
	if Postal_QuickAttachButton1 then Postal_QuickAttachButton1:Show() end
	if Postal_QuickAttachButton2 then Postal_QuickAttachButton2:Show() end
	if Postal_QuickAttachButton3 then Postal_QuickAttachButton3:Show() end
	if Postal_QuickAttachButton4 then Postal_QuickAttachButton4:Show() end
	if Postal_QuickAttachButton5 then Postal_QuickAttachButton5:Show() end
	if Postal_QuickAttachButton6 then Postal_QuickAttachButton6:Show() end
	if Postal_QuickAttachButton7 then Postal_QuickAttachButton7:Show() end
	if Postal_QuickAttachButton8 then Postal_QuickAttachButton8:Show() end
	if Postal_QuickAttachButton9 then Postal_QuickAttachButton9:Show() end
	if Postal_QuickAttachButton10 then Postal_QuickAttachButton10:Show() end
	if Postal_QuickAttachButton11 then Postal_QuickAttachButton11:Show() end
	if Postal_QuickAttachButton12 then Postal_QuickAttachButton12:Show() end
	if Postal_QuickAttachButton13 then Postal_QuickAttachButton13:Show() end
	if Postal_QuickAttachButton14 then Postal_QuickAttachButton14:Show() end
end

-- Disabling modules unregisters all events/hook automatically
function Postal_QuickAttach:OnDisable()
	Postal_QuickAttach:UnregisterAllEvents()
	if Postal_QuickAttachButton1 then Postal_QuickAttachButton1:Hide() end
	if Postal_QuickAttachButton2 then Postal_QuickAttachButton2:Hide() end
	if Postal_QuickAttachButton3 then Postal_QuickAttachButton3:Hide() end
	if Postal_QuickAttachButton4 then Postal_QuickAttachButton4:Hide() end
	if Postal_QuickAttachButton5 then Postal_QuickAttachButton5:Hide() end
	if Postal_QuickAttachButton6 then Postal_QuickAttachButton6:Hide() end
	if Postal_QuickAttachButton7 then Postal_QuickAttachButton7:Hide() end
	if Postal_QuickAttachButton8 then Postal_QuickAttachButton8:Hide() end
	if Postal_QuickAttachButton9 then Postal_QuickAttachButton9:Hide() end
	if Postal_QuickAttachButton10 then Postal_QuickAttachButton10:Hide() end
	if Postal_QuickAttachButton11 then Postal_QuickAttachButton11:Hide() end
	if Postal_QuickAttachButton12 then Postal_QuickAttachButton12:Hide() end
	if Postal_QuickAttachButton13 then Postal_QuickAttachButton13:Hide() end
	if Postal_QuickAttachButton14 then Postal_QuickAttachButton14:Hide() end
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
								if itemsubclassID == subclassID then
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

function Postal_QuickAttach.SetEnableBag0(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.QuickAttach.EnableBag0 = checked
end

function Postal_QuickAttach.SetEnableBag1(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.QuickAttach.EnableBag1 = checked
end

function Postal_QuickAttach.SetEnableBag2(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.QuickAttach.EnableBag2 = checked
end

function Postal_QuickAttach.SetEnableBag3(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.QuickAttach.EnableBag3 = checked
end

function Postal_QuickAttach.SetEnableBag4(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.QuickAttach.EnableBag4 = checked
end

function Postal_QuickAttach.ModuleMenu(self, level)
	if not level then return end
	local info = self.info
	wipe(info)
	info.isNotRadio = 1
	if level == 1 + self.levelAdjust then
		local db = Postal.db.profile.QuickAttach
		info.keepShownOnClick = 1

		info.text = L["Enable for backpack"]
		info.func = Postal_QuickAttach.SetEnableBag0
		info.checked = db.EnableBag0
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag one"]
		info.func = Postal_QuickAttach.SetEnableBag1
		info.checked = db.EnableBag1
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag two"]
		info.func = Postal_QuickAttach.SetEnableBag2
		info.checked = db.EnableBag2
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag three"]
		info.func = Postal_QuickAttach.SetEnableBag3
		info.checked = db.EnableBag3
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Enable for bag four"]
		info.func = Postal_QuickAttach.SetEnableBag4
		info.checked = db.EnableBag4
		UIDropDownMenu_AddButton(info, level)
	end
end
