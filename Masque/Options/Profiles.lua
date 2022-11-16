--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Options\Profiles.lua
	* Author.: StormFX

	'Profile Settings' Group/Panel

	TODO: Create a custom profiles panel.

]]

local MASQUE, Core = ...

----------------------------------------
-- Lua API
---

local pairs = pairs

----------------------------------------
-- Internal
---

-- @ Options\Core
local Setup = Core.Setup

----------------------------------------
-- Setup
---

-- Creates the 'Profile Settings' group/panel.
function Setup.Profiles(self)
	-- @ Locales\enUS
	local L = self.Locale

	local Options = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	Options.name = L["Profile Settings"]
	Options.order = -1

	-- Font Size Fix
	local args = Options.args
	for _, arg in pairs(args) do
		local type = arg.type
		if type and type == "description" then
			arg.fontSize = "medium"
		end
	end

	-- LibDualSpec-1.0
	local LDS = self.USE_LDS and LibStub("LibDualSpec-1.0", true)
	if LDS then
		LDS:EnhanceOptions(Options, self.db)
	end

	self.Options.args.Profiles = Options

	local Path = "Profiles"
	self:AddOptionsPanel(Path, LibStub("AceConfigDialog-3.0"):AddToBlizOptions(MASQUE, L["Profile Settings"], MASQUE, Path))

	-- GC
	Setup.Profiles = nil
end
