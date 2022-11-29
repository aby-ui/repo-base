--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2021 Adirelle (adirelle@gmail.com)
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
local GameTooltip = _G.GameTooltip
local UseContainerItem = C_Container and _G.C_Container.UseContainerItem or _G.UseContainerItem
--GLOBALS>

local mod = addon:NewModule('BankSwitcher', 'ABEvent-1.0')
mod.uiName = L['Bank Switcher']
mod.uiDesc = L['Move items from and to the bank by right-clicking on section headers.']

function mod:OnEnable()
	self:RegisterMessage('AdiBags_InteractingWindowChanged')
	self:AdiBags_InteractingWindowChanged('OnEnable', addon:GetInteractingWindow())
end

function mod:OnDisable()
	addon.UnregisterAllSectionHeaderScripts(self)
end

function mod:OnTooltipUpdateSectionHeader(_, _, tooltip)
	tooltip:AddLine(L['Right-click to move these items.'])
end

function mod:OnClickSectionHeader(_, header, button)
	if button == "RightButton" then
		for slotId, bag, slot in header.section:IterateContainerSlots() do
			UseContainerItem(bag, slot)
		end
	end
end

function mod:AdiBags_InteractingWindowChanged(_, new, old)
	if new == "BANKFRAME" then
		addon.RegisterSectionHeaderScript(self, 'OnTooltipUpdate', 'OnTooltipUpdateSectionHeader')
		addon.RegisterSectionHeaderScript(self, 'OnClick', 'OnClickSectionHeader')
	elseif old == "BANKFRAME" then
		addon.UnregisterAllSectionHeaderScripts(self)
	end
end
