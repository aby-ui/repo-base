--[[
	inventory.lua
		A specialized version of the standard frame for the inventory
--]]

local ADDON, Addon = ...
local Inventory = Addon.Frame:NewClass('InventoryFrame')
Inventory.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBags
Inventory.Bags = {BACKPACK_CONTAINER, 1, 2, 3, 4}
Inventory.MainMenuButtons = {
	MainMenuBarBackpackButton,
	CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot
}

if HasKey then
	tinsert(Inventory.Bags, KEYRING_CONTAINER)
	tinsert(Inventory.MainMenuButtons, KeyRingButton)
end

function Inventory:OnShow()
	self:Super(Inventory):OnShow()
	self:Delay(0, 'HighlightMainMenu', true)
end

function Inventory:OnHide()
	self:Super(Inventory):OnHide()
	self:Delay(0, 'HighlightMainMenu', false)
end

function Inventory:HighlightMainMenu(checked)
	for _, button in pairs(self.MainMenuButtons) do
		if button.SlotHighlightTexture then
			button.SlotHighlightTexture:SetShown(checked)
		elseif button.icon then
			button:SetChecked(checked)
		elseif checked then
			button:SetButtonState('PUSHED', 1)
		else
			button:SetButtonState('NORMAL')
		end
	end
end

function Inventory:SortItems()
	if SortBags and Addon.sets.serverSort then
		SortBags()
	else
		self:Super(Inventory):SortItems(self)
	end
end
