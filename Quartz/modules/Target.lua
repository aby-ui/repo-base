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
local Target = Quartz3:NewModule(MODNAME, "AceEvent-3.0", "AceHook-3.0")

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

		hideblizz = true,
	})
}

do
	local function setOpt(info, value)
		db[info[#info]] = value
		Target:ApplySettings()
	end

	local options
	function getOptions()
		if not options then
			options = Target.Bar:CreateOptions()
			options.args.hideblizz = {
				type = "toggle",
				name = L["Disable Blizzard Cast Bar"],
				desc = L["Disable and hide the default UI's casting bar"],
				set = setOpt,
				order = 101,
			}
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
	self:SecureHook("Target_Spellbar_OnEvent")
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

	-- obey the hideblizz setting no matter if disabled or not
	if db.hideblizz then
		TargetFrameSpellBar.RegisterEvent = function() end
		TargetFrameSpellBar:UnregisterAllEvents()
		TargetFrameSpellBar:Hide()
	else
		TargetFrameSpellBar.RegisterEvent = nil
		TargetFrameSpellBar:UnregisterAllEvents()
		TargetFrameSpellBar:RegisterUnitEvent("UNIT_SPELLCAST_START", "target")
		TargetFrameSpellBar:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "target")
		TargetFrameSpellBar:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "target")
		TargetFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
		TargetFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_DELAYED")
		TargetFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
		TargetFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
		TargetFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
		TargetFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
		TargetFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		TargetFrameSpellBar:RegisterEvent("PLAYER_ENTERING_WORLD")
		TargetFrameSpellBar:RegisterEvent("PLAYER_TARGET_CHANGED")
		TargetFrameSpellBar:RegisterEvent("CVAR_UPDATE")
		TargetFrameSpellBar:RegisterEvent("VARIABLES_LOADED")
	end

	self.Bar:SetConfig(db)
	if self:IsEnabled() then
		self.Bar:ApplySettings()
	end
end

function Target:Target_Spellbar_OnEvent()
	if db.hideblizz then
		TargetFrameSpellBar.showCastbar = false
		TargetFrameSpellBar:Hide()
	end
end

function Target:Unlock()
	self.Bar:Unlock()
end

function Target:Lock()
	self.Bar:Lock()
end
