--[[
	inventory.lua
		A specialized version of the standard frame for the inventory
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').Container
local Inventory = Addon.Frame:NewClass('InventoryFrame')
Inventory.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBags
Inventory.Bags = {}
Inventory.MainMenuButtons = {
	MainMenuBarBackpackButton,
	CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot, CharacterReagentBag0Slot, --abyui
}

for slot = BACKPACK_CONTAINER, (NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS) do
	tinsert(Inventory.Bags, slot)
end

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
	if C.SortBags and true then --abyui Addon.sets.serverSort then
		C.SortBags()
	else
		self:Super(Inventory):SortItems(self)
	end
end
