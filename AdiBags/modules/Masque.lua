--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2023 Adirelle (adirelle@gmail.com)
All rights reserved.
This file is part of AdiBags.
AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

local addonName, addon = ...
local L = addon.L

--<GLOBALS
local _G = _G
local SlashCmdList = _G.SlashCmdList
--GLOBALS>

local mod = addon:NewModule('Masque', 'ABEvent-1.0')
mod.uiName = L['Masque']
mod.uiDesc = L['Support for skinning item buttons with Masque.']

local function isBankButton(button)
	return not not addon.BAG_IDS.BANK[button.bag]
end

local function isMasqueGroupEnabled(group)
	return not group.db.Disabled
end

function mod:OnEnable()
	local Masque = LibStub("Masque", true)

	if not Masque then return end

	self.Masque = Masque

	self.BackpackGroup = Masque:Group(addonName, L["Backpack"])
	self.BackpackGroup:SetCallback(self.OnMasqueGroupChange, self)
	self.BankGroup = Masque:Group(addonName, L["Bank"])
	self.BankGroup:SetCallback(self.OnMasqueGroupChange, self)

	self.BackpackButtonPool = addon:GetPool("ItemButton")
	self.BankButtonPool = addon:GetPool("BankItemButton")

	self:RegisterMessage("AdiBags_AcquireButton", "OnAcquireButton")
	self:RegisterMessage("AdiBags_ReleaseButton", "OnReleaseButton")
	self:RegisterMessage("AdiBags_UpdateButton", "OnUpdateButton")
	self:RegisterMessage("AdiBags_UpdateBorder", "OnUpdateButton")

	self:AddAllActiveButtonsToGroups()
end

function mod:OnDisable()
	self:UnregisterMessage("AdiBags_AcquireButton")
	self:UnregisterMessage("AdiBags_ReleaseButton")
	self:UnregisterMessage("AdiBags_UpdateButton")
	self:UnregisterMessage("AdiBags_UpdateBorder")

	if self.BackpackGroup and self.BackpackButtonPool then
		self:RemoveAllActiveButtonsFromGroups()
	end
	if self.BackpackGroup then
		self.BackpackGroup:Delete()
	end
	if self.BankGroup then
		self.BankGroup:Delete()
	end
end

function mod:ComputeButtonMasqueGroup(button)
	return isBankButton(button) and self.BankGroup or self.BackpackGroup
end

function mod:OnMasqueGroupChange(masqueGroupName, skinId, backdrop, shadow, gloss, colors, disabled)
	self:RemoveAllActiveButtonsFromGroups()
	self:AddAllActiveButtonsToGroups()
end

function mod:AddAllActiveButtonsToGroups()
	for _, pool in ipairs({ [1] = self.BackpackButtonPool, [2] = self.BankButtonPool }) do
		if pool.IterateActiveObjects then
			for button in pool:IterateActiveObjects() do
				self:AddButtonToMasqueGroup(self:ComputeButtonMasqueGroup(button), button)
			end
		end
	end
end

function mod:RemoveAllActiveButtonsFromGroups()
	for _, pool in ipairs({ [1] = self.BackpackButtonPool, [2] = self.BankButtonPool }) do
		if pool.IterateActiveObjects then
			for button in pool:IterateActiveObjects() do
				local group = self:ComputeButtonMasqueGroup(button)
				self:RemoveButtonFromMasqueGroup(group, button, not self:IsEnabled() or not isMasqueGroupEnabled(group))
			end
		end
	end
end

function mod:OnAcquireButton(event, button)
	self:AddButtonToMasqueGroup(self:ComputeButtonMasqueGroup(button), button)
end

function mod:OnReleaseButton(event, button)
	self:RemoveButtonFromMasqueGroup(self:ComputeButtonMasqueGroup(button), button)
end

function mod:AddButtonToMasqueGroup(group, button)
	if not isMasqueGroupEnabled(group) then return end
	button.EmptySlotTextureFile = nil
	group:AddButton(button, {
		Icon = button.IconTexture,
		IconBorder = button.IconBorder,
		QuestBorder = button.IconQuestTexture
	})
	button.masqueGroup = group
	button:UpdateIcon()
end

function mod:RemoveButtonFromMasqueGroup(group, button, update)
	button.EmptySlotTextureFile = addon.EMPTY_SLOT_FILE
	button.masqueGroup = nil
	group:RemoveButton(button)
	if update then
		button:UpdateIcon() -- mainly for empty slot update

		-- hack: seems like masque does not reset these values when button is removed from group (it's possible there could be other taint)
		button.IconBorder:SetWidth(addon.ITEM_SIZE)
		button.IconBorder:SetHeight(addon.ITEM_SIZE)
		button:UpdateBorder()
	end
end

function mod:OnUpdateButton(event, button)
	if button.masqueGroup then
		button.masqueGroup:ReSkin(button)
	end
end

function mod:GetOptions()
	local options = {}
	if SlashCmdList["MASQUE"] then
		options["reset"] = {
			name = L['/masque'],
			type = 'execute',
			order = 10,
			func = function()
				addon:CloseOptions()
				SlashCmdList["MASQUE"]("")
			end,
		}
	end
	return options, addon:GetOptionHandler(self, false)
end
