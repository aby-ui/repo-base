--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Options\General.lua
	* Author.: StormFX

	'General Settings' Group/Panel

]]

-- GLOBALS: LibStub, ReloadUI

local MASQUE, Core = ...

----------------------------------------
-- Locals
---

-- @ Options\Core
local Setup = Core.Setup

----------------------------------------
-- Setup
---

-- Creates the 'General Settings' group/panel.
function Setup.General(self)
	-- @ Locales\enUS
	local L = self.Locale

	local Reload = "\n|cff0099ff"..L["Requires an interface reload."].."|r"
	local Tooltip = "|cffffffff"..L["Select to view."].."|r"

	local Options = {
		type = "group",
		name = L["General Settings"],
		order = 2,
		args = {
			Head = {
				type = "description",
				name = "|cffffcc00Masque - "..L["General Settings"].."|r\n",
				fontSize = "medium",
				hidden = self.GetStandAlone,
				order = 0,
			},
			Desc = {
				type = "description",
				name = L["This section will allow you to adjust Masque's interface and performance settings."].."\n",
				fontSize = "medium",
				order = 1,
			},
			Interface = {
				type = "group",
				name = L["Interface"],
				desc = Tooltip,
				order = 2,
				args = {
					Head = {
						type = "description",
						name = "|cffffcc00"..L["Interface Settings"].."|r\n",
						fontSize = "medium",
						order = 0,
					},
					Desc = {
						type = "description",
						name = L["This section will allow you to adjust settings that affect Masque's interface."].."\n",
						fontSize = "medium",
						order = 1,
					},
					Icon = {
						type = "toggle",
						name = L["Minimap Icon"],
						desc = L["Enable the Minimap icon."],
						get = function() return not Core.db.profile.LDB.hide end,
						set = function(i, v)
							Core.db.profile.LDB.hide = not v
							if not v then
								Core.LDBI:Hide(MASQUE)
							else
								Core.LDBI:Show(MASQUE)
							end
						end,
						disabled = function() return not Core.LDBI end,
						order = 3,
					},
					Standalone = {
						type = "toggle",
						name = L["Stand-Alone GUI"],
						desc = L["Use a resizable, stand-alone options window."],
						get = function() return Core.db.profile.StandAlone end,
						set = function(i, v) Core.db.profile.StandAlone = v end,
						order = 4,
					},
				},
			},
			Performance = {
				type = "group",
				name = L["Performance"],
				desc = Tooltip,
				order = 3,
				args = {
					Head = {
						type = "description",
						name = "|cffffcc00"..L["Performance Settings"].."|r\n",
						fontSize = "medium",
						order = 1,
					},
					Desc = {
						type = "description",
						name = L["This section will allow you to adjust settings that affect Masque's performance."].."\n",
						fontSize = "medium",
						order = 2,
					},
					SkinInfo = {
						type = "toggle",
						name = L["Skin Information"],
						desc = L["Load the skin information panel."]..Reload,
						get = function() return Core.db.profile.SkinInfo end,
						set = function(i, v)
							Core.db.profile.SkinInfo = v
							Core.Setup("Info")
						end,
						order = 3,
					},
					SPC01 = {
						type = "description",
						name = " ",
						--order = 100,
					},
					Reload = {
						type = "execute",
						name = L["Reload Interface"],
						desc = L["Click to load reload the interface."],
						func = function() ReloadUI() end,
						order = -1,
					},
				},
			},
			Developer = {
				type = "group",
				name = L["Developer"],
				desc = Tooltip,
				order = 4,
				args = {
					Head = {
						type = "description",
						name = "|cffffcc00"..L["Developer Settings"].."|r\n",
						fontSize = "medium",
						order = 0,
					},
					Desc = {
						type = "description",
						name = L["This section will allow you to adjust settings that affect working with Masque's API."].."\n",
						fontSize = "medium",
						order = 1,
					},
					Debug = {
						type = "toggle",
						name = L["Debug Mode"],
						desc = L["Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."],
						get = function() return Core.db.profile.Debug end,
						set = self.ToggleDebug,
						order = 3,
					},
					SPC01 = {
						type = "description",
						name = " ",
						--order = 100,
					},
					Purge = {
						type = "execute",
						name = L["Clean Database"],
						desc = L["Click to purge the settings of all unused add-ons and groups."],
						confirm = true,
						confirmText = L["This action cannot be undone. Continue?"],
						func = Core.CleanDB,
						order = -1,
					},
				},
			},
		},
	}

	self.Options.args.General = Options
	self.ProfilesPanel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(MASQUE, L["General Settings"], MASQUE, "General")

	-- GC
	Setup.General = nil
end
