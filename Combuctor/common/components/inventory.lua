--[[
	inventory.lua
		A specialized version of the standard frame for the inventory
--]]

local ADDON, Addon = ...
local Frame = Addon:NewClass('InventoryFrame', 'Frame', Addon.Frame)
Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBags
Frame.Bags = {BACKPACK_CONTAINER, 1, 2, 3, 4}
Frame.MainMenuButtons = {
	MainMenuBarBackpackButton,
	CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot
}

function Frame:OnShow()
	self.__super.OnShow(self)
	self:After(0, 'HighlightMainMenu', true)
end

function Frame:OnHide()
	self.__super.OnHide(self)
	self:After(0, 'HighlightMainMenu', false)
end

function Frame:HighlightMainMenu(checked)
	for _, button in pairs(self.MainMenuButtons) do
		if button.SlotHighlightTexture then
			button.SlotHighlightTexture:SetShown(checked)
		else
			button:SetChecked(checked)
		end
	end
end

function Frame:SortItems()
	return (SortBags or self.__super.SortItems)(self)
end
