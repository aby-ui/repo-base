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
	Addon.Frame.OnShow(self)
	self:HighlightMainMenu(true)
end

function Frame:OnHide()
	Addon.Frame.OnHide(self)
	self:HighlightMainMenu(false)
end

function Frame:HighlightMainMenu(checked)
	for i, button in pairs(self.MainMenuButtons) do
		if button.SlotHighlightTexture then
			button.SlotHighlightTexture:SetShown(checked)
		else
			C_Timer.After(0, function()
				button:SetChecked(checked)
			end)
		end
	end
end
