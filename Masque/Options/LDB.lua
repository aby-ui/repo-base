--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Options\LDB.lua
	* Author.: StormFX

	LDB Launcher

]]

-- GLOBALS: LibStub

local MASQUE, Core = ...

----------------------------------------
-- Locals
---

-- @ Options\Core
local Setup = Core.Setup

----------------------------------------
-- Setup
---

function Setup.LDB(self)
	local LDB = LibStub("LibDataBroker-1.1", true)

	if LDB then
		-- @ Locales\enUS
		local L = self.Locale

		self.LDBO = LDB:NewDataObject(MASQUE, {
			type  = "launcher",
			label = MASQUE,
			icon  = "Interface\\Addons\\Masque\\Textures\\Icon",
			OnClick = function(Tip, Button)
				if Button == "LeftButton" or Button == "RightButton" then
					Core:ToggleOptions()
				end
			end,
			OnTooltipShow = function(Tip)
				if not Tip or not Tip.AddLine then
					return
				end
				Tip:AddLine(MASQUE)
				Tip:AddLine(L["Click to open Masque's settings."], 1, 1, 1)
			end,
		})

		local LDBI = LibStub("LibDBIcon-1.0", true)

		if LDBI then
			LDBI:Register(MASQUE, self.LDBO, self.db.profile.LDB)
			self.LDBI = LDBI
		end
	end

	-- GC
	Setup.LDB = nil
end
