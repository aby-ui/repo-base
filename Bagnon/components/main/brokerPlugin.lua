--[[
	brokerDisplay.lua
		A databroker plugin
--]]

local ADDON, Addon = ...
local LDB = LibStub('LibDataBroker-1.1')
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)

local Plugin = LDB:NewDataObject(ADDON .. 'Launcher', {
	type = 'launcher',
	icon = [[Interface\Icons\INV_Misc_Bag_07]],
	label = ADDON,

	OnClick = function(self, button)
		if IsShiftKeyDown() then
			Addon:ShowOptions()
		elseif button == 'LeftButton' then
			Addon:ToggleFrame('inventory')
		elseif button == 'RightButton' then
			Addon:ToggleFrame('bank')
		end
	end,

	OnTooltipShow = function(tooltip)
		tooltip:AddLine(ADDON)
		tooltip:AddLine(L.TipShowInventory:format(L.LeftClick), 1, 1, 1)
		tooltip:AddLine(L.TipShowBank:format(L.RightClick), 1, 1, 1)
		tooltip:AddLine(L.TipShowOptions:format(L.ShiftClick), 1, 1, 1)
	end,

	OnUpdate = function(self)
		local free, total = 0, 0
		for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			local numFree, family = GetContainerNumFreeSlots(bag)
			if family == 0 then
				total = total + GetContainerNumSlots(bag)
				free = free + numFree
			end
		end

		self.text = format('%d/%d', free, total)
	end
})

Addon.RegisterEvent(Plugin, 'BAG_UPDATE_DELAYED', 'OnUpdate')
