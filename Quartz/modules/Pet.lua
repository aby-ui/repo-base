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

local MODNAME = "Pet"
local Pet = Quartz3:NewModule(MODNAME, "AceEvent-3.0")

----------------------------
-- Upvalues
-- GLOBALS: PetCastingBarFrame

local db, getOptions

local defaults = {
	profile = Quartz3:Merge(Quartz3.CastBarTemplate.defaults,
	{
		hideblizz = true,
		
		--x =  -- applied automatically in :ApplySettings()
		y = 300,
		h = 18,
		w = 200,
		texture = "LiteStep",
	})
}

do
	local function setOpt(info, value)
		db[info[#info]] = value
		Pet:ApplySettings()
	end

	local options
	function getOptions()
		if not options then
			options = Pet.Bar:CreateOptions()
			options.args.hideblizz = {
				type = "toggle",
				name = L["Disable Blizzard Cast Bar"],
				desc = L["Disable and hide the default UI's casting bar"],
				set = setOpt,
				order = 101,
			}
			options.args.noInterruptGroup = nil
		end
		return options
	end
end


function Pet:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Pet"])

	self.Bar = Quartz3.CastBarTemplate:new(self, "pet", MODNAME, L["Pet"], db)
end

function Pet:OnEnable()
	self.Bar:RegisterEvents()
	self:ApplySettings()
end

function Pet:OnDisable()
	self.Bar:UnregisterEvents()
	self.Bar:Hide()
end

function Pet:ApplySettings()
	db = self.db.profile

	-- obey the hideblizz setting no matter if disabled or not
	if db.hideblizz then
		PetCastingBarFrame.RegisterEvent = function() end
		PetCastingBarFrame:UnregisterAllEvents()
		PetCastingBarFrame:Hide()
	else
		PetCastingBarFrame.RegisterEvent = nil
		PetCastingBarFrame:UnregisterAllEvents()
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_START")
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
		PetCastingBarFrame:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
		PetCastingBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		PetCastingBarFrame:RegisterEvent("UNIT_PET")
	end

	self.Bar:SetConfig(db)
	if self:IsEnabled() then
		self.Bar:ApplySettings()
	end
end

function Pet:Unlock()
	self.Bar:Unlock()
end

function Pet:Lock()
	self.Bar:Lock()
end
