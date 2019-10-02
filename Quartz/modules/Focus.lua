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

local MODNAME = "Focus"
local Focus = Quartz3:NewModule(MODNAME, "AceEvent-3.0")

----------------------------
-- Upvalues
local UnitIsEnemy, UnitIsFriend, UnitIsUnit = UnitIsEnemy, UnitIsFriend, UnitIsUnit

local db, getOptions

local defaults = {
	profile = Quartz3:Merge(Quartz3.CastBarTemplate.defaults,
	{
		--x =  -- applied automatically in :ApplySettings()
		y = 250,
		h = 18,
		w = 200,
		texture = "LiteStep",
		
		showfriendly = true,
		showhostile = true,
		showtarget = true,

		hideblizz = true,
	})
}

do
	local function setOpt(info, value)
		db[info[#info]] = value
		Focus:ApplySettings()
	end

	local options
	function getOptions()
		if not options then
			options = Focus.Bar:CreateOptions()
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
			options.args.showtarget = {
				type = "toggle",
				name = L["Show if Target"],
				desc = L["Show this castbar if focus is also target"],
				order = 101,
			}
		end
		return options
	end
end

function Focus:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile
	
	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Focus"])
	
	self.Bar = Quartz3.CastBarTemplate:new(self, "focus", MODNAME, L["Focus"], db)
end

function Focus:OnEnable()
	self.Bar:RegisterEvents()
	self.Bar:RegisterEvent("PLAYER_TARGET_CHANGED")
	self.Bar:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self.Bar.PLAYER_TARGET_CHANGED = self.Bar.UpdateUnit
	self.Bar.PLAYER_FOCUS_CHANGED = self.Bar.UpdateUnit
	self.lastNotInterruptible = false
	self:ApplySettings()
end

function Focus:OnDisable()
	self.Bar:UnregisterEvents()
	self.Bar:Hide()
end

function Focus:PreShowCondition(bar, unit)
	if (not db.showfriendly and UnitIsFriend("player", unit)) or 
	   (not db.showhostile and UnitIsEnemy("player", unit)) or
	   (not db.showtarget and UnitIsUnit("target", unit)) then
		return true
	end
end

function Focus:ApplySettings()
	db = self.db.profile
	
	-- obey the hideblizz setting no matter if disabled or not
	if db.hideblizz then
		FocusFrameSpellBar.RegisterEvent = function() end
		FocusFrameSpellBar:UnregisterAllEvents()
		FocusFrameSpellBar:Hide()
	else
		FocusFrameSpellBar.RegisterEvent = nil
		FocusFrameSpellBar:UnregisterAllEvents()
		FocusFrameSpellBar:RegisterUnitEvent("UNIT_SPELLCAST_START", "focus")
		FocusFrameSpellBar:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "focus")
		FocusFrameSpellBar:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "focus")
		FocusFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
		FocusFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_DELAYED")
		FocusFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
		FocusFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
		FocusFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
		FocusFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
		FocusFrameSpellBar:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		FocusFrameSpellBar:RegisterEvent("PLAYER_ENTERING_WORLD")
		FocusFrameSpellBar:RegisterEvent("PLAYER_FOCUS_CHANGED")
		FocusFrameSpellBar:RegisterEvent("CVAR_UPDATE")
	end

	self.Bar:SetConfig(db)
	if self:IsEnabled() then
		self.Bar:ApplySettings()
	end
end

function Focus:Unlock()
	self.Bar:Unlock()
end

function Focus:Lock()
	self.Bar:Lock()
end
