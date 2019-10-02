--[[
	Copyright (C) 2006-2007 Nymbia
	Copyright (C) 2010-2017 Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with this program; if not, write to the Free Software Foundation, Inc.,
	51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]
local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
local L = LibStub("AceLocale-3.0"):GetLocale("Quartz3")

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then return end

local MODNAME = "Target"
local Target = Quartz3:NewModule(MODNAME, "AceEvent-3.0")

----------------------------
-- Upvalues
local UnitIsEnemy, UnitIsFriend = UnitIsEnemy, UnitIsFriend

local db, getOptions

local defaults = {
	profile = Quartz3:Merge(Quartz3.CastBarTemplate.defaults,
	{
		--x =  -- applied automatically in :ApplySettings()
		y = 250,
		h = 18,
		w = 200,
		texture = "LiteStep",
		iconposition = "right",
		
		showfriendly = true,
		showhostile = true,
	})
}

do
	local options
	function getOptions()
		if not options then
			options = Target.Bar:CreateOptions()
			options.args.showfriendly = {
				type = "toggle",
				name = L["Show for Friends"],
				desc = L["Show this castbar for friendly units"],
				order = 101,
			}
			options.args.showhostile = {
				type = "toggle",
				name = L["Show for Enemies"],
				desc = L["Show this castbar for hostile units"],
				order = 101,
			}
		end
		return options
	end
end

function Target:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Target"])

	self.Bar = Quartz3.CastBarTemplate:new(self, "target", MODNAME, L["Target"], db)
end

function Target:OnEnable()
	self.Bar:RegisterEvents()
	self.Bar:RegisterEvent("PLAYER_TARGET_CHANGED")
	self.Bar.PLAYER_TARGET_CHANGED = self.Bar.UpdateUnit
	self.lastNotInterruptible = false
	self:ApplySettings()
end

function Target:OnDisable()
	self.Bar:UnregisterEvents()
	self.Bar:Hide()
end

function Target:PreShowCondition(bar, unit)
	if (not db.showfriendly and UnitIsFriend("player", unit)) or
	   (not db.showhostile and UnitIsEnemy("player", unit)) then
		return true
	end
end

function Target:ApplySettings()
	db = self.db.profile

	self.Bar:SetConfig(db)
	if self:IsEnabled() then
		self.Bar:ApplySettings()
	end
end

function Target:Unlock()
	self.Bar:Unlock()
end

function Target:Lock()
	self.Bar:Lock()
end
