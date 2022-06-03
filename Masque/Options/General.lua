--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Options\General.lua
	* Author.: StormFX

	'General Settings' Group/Panel

]]

local MASQUE, Core = ...

----------------------------------------
-- WoW API
---

local ReloadUI = ReloadUI

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

	-- @ Masque
	local CRLF = Core.CRLF

	local Reload = "\n|cff0099ff"..L["Requires an interface reload."].."|r"
	local Tooltip = "|cffffffff"..L["Select to view."].."|r"

	local Options = {
		type = "group",
		name = L["General Settings"],
		order = 2,
		args = {
			Head = {
				type = "header",
				name = MASQUE.." - "..L["General Settings"],
				hidden = self.GetStandAlone,
				order = 0,
				disabled = true,
				dialogControl = "SFX-Header",
			},
			Desc = {
				type = "description",
				name = L["This section will allow you to adjust Masque's interface and performance settings."]..CRLF,
				order = 1,
				fontSize = "medium",
			},
			Interface = {
				type = "group",
				name = L["Interface"],
				desc = Tooltip,
				order = 2,
				args = {
					Head = {
						type = "header",
						name = L["Interface Settings"],
						order = 0,
						disabled = true,
						dialogControl = "SFX-Header",
					},
					Desc = {
						type = "description",
						name = L["This section will allow you to adjust settings that affect Masque's interface."]..CRLF,
						order = 1,
						fontSize = "medium",
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
						order = 3,
						disabled = function() return not Core.LDBI end,
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
						type = "header",
						name = L["Performance Settings"],
						order = 1,
						disabled = true,
						dialogControl = "SFX-Header",
					},
					Desc = {
						type = "description",
						name = L["This section will allow you to adjust settings that affect Masque's performance."]..CRLF,
						order = 2,
						fontSize = "medium",
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
						type = "header",
						name = L["Developer Settings"],
						order = 0,
						disabled = true,
						dialogControl = "SFX-Header",
					},
					Desc = {
						type = "description",
						name = L["This section will allow you to adjust settings that affect working with Masque's API."]..CRLF,
						order = 1,
						fontSize = "medium",
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
						func = Core.CleanDB,
						order = -1,
						confirm = true,
						confirmText = L["This action cannot be undone. Continue?"],
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
