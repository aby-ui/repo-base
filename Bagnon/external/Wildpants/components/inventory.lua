--[[
	inventory.lua
		A specialized version of the standard frame for the inventory
--]]

local ADDON, Addon = ...
local Frame = Addon:NewClass('InventoryFrame', 'Frame', Addon.Frame)
Frame.Title = LibStub('AceLocale-3.0'):GetLocale(ADDON).TitleBags
Frame.Bags = {BACKPACK_CONTAINER, 1, 2, 3, 4}

function Frame:OnShow()
	Addon.Frame.OnShow(self)
	self:CheckBagButtons(true)
end

function Frame:OnHide()
	Addon.Frame.OnHide(self)
	self:CheckBagButtons(false)
end

function Frame:CheckBagButtons(checked)
    CoreUIShowOrHide(MainMenuBarBackpackButton.SlotHighlightTexture, checked)
    CoreUIShowOrHide(CharacterBag0Slot.SlotHighlightTexture, checked)
    CoreUIShowOrHide(CharacterBag1Slot.SlotHighlightTexture, checked)
    CoreUIShowOrHide(CharacterBag2Slot.SlotHighlightTexture, checked)
    CoreUIShowOrHide(CharacterBag3Slot.SlotHighlightTexture, checked)
end