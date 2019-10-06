--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Options\Info.lua
	* Author.: StormFX

	'Installed Skins' Group/Panel

]]

-- GLOBALS: LibStub

local MASQUE, Core = ...

----------------------------------------
-- Lua
---

local pairs, tostring = pairs, tostring

----------------------------------------
-- Libraries
---

local LIB_ACR = LibStub("AceConfigRegistry-3.0")

----------------------------------------
-- Locals
---

-- @ Options\Core
local Setup = Core.Setup

-- @ Locales\enUS
local L = Core.Locale

----------------------------------------
-- Utility
---

local GetInfoGroup

do
	-- Formatted Text
	local UPDATED = "|cff00ff00"..L["Compatible"].."|r"
	local COMPATIBLE = "|cffffff00"..L["Compatible"].."|r"
	local INCOMPATIBLE = "|cffff0000"..L["Incompatible"].."|r"
	local UNKNOWN = "|cff777777"..L["Unknown"].."|r"

	-- Versions
	local API = Core.API_VERSION
	local OLD = Core.OLD_VERSION

	-- Returns the Status text and tooltip for a skin based on its Masque_Version setting.
	local function GetStatus(Version)
		if not Version then
			return UNKNOWN, L["The status of this skin is unknown."]
		elseif Version < OLD then
			return INCOMPATIBLE, L["This skin is outdated and is incompatible with Masque."]
		elseif Version < API then
			return COMPATIBLE, L["This skin is outdated but is still compatible with Masque."]
		else
			return UPDATED, L["This skin is compatible with Masque."]
		end
	end

	----------------------------------------
	-- Options Builder
	---

	-- Reusable Header
	local HDR = {
		type = "description",
		name = "|cffffcc00"..L["Description"].."|r\n",
		order = 1,
		fontSize = "medium",
	}

	-- Creates a skin info options group.
	function GetInfoGroup(Skin, Group)
		local Title = (Group and Skin.Title) or Skin.SkinID
		local Order = (Group and Skin.Order) or nil
		local Description = Skin.Description or L["No description available."]

		local Version = (Skin.Version and tostring(Skin.Version)) or UNKNOWN
		local Authors = Skin.Authors or Skin.Author or UNKNOWN
		local Websites = Skin.Websites or Skin.Website
		local Status, Tooltip = GetStatus(Skin.Masque_Version)

		-- Options Group
		local Info = {
			type = "group",
			name = Title,
			order = Order,
			args = {
				Head = HDR,
				Desc = {
					type = "description",
					name = Description.."\n",
					order = 2,
					fontSize = "medium",
				},
				Info = {
					type = "group",
					name = "",
					order = 3,
					inline = true,
					args = {
						Version = {
							type = "input",
							name = L["Version"],
							arg = Version.."\n",
							order = 1,
							disabled = true,
							dialogControl = "SFX-Info",
						},
					},
				},
			},
		}

		local args = Info.args.Info.args
		Order = 2

		-- Populate the Author field(s).
		if type(Authors) == "table" then
			local Count = #Authors
			if Count > 0 then
				for i = 1, Count do
					local Key = "Author"..i
					local Name = (i == 1 and L["Authors"]) or ""
					args[Key] = {
						type = "input",
						name = Name,
						arg  = Authors[i],
						order = Order,
						disabled = true,
						dialogControl = "SFX-Info",
					}
					Order = Order + 1
				end
				args["SPC"..Order] = {
					type = "description",
					name = " ",
					order = Order,
				}
				Order = Order + 1
			end
		elseif type(Authors) == "string" then
			args.Author = {
				type = "input",
				name = L["Author"],
				arg  = Authors,
				order = Order,
				disabled = true,
				dialogControl = "SFX-Info",
			}
			Order = Order + 1
			args["SPC"..Order] = {
				type = "description",
				name = " ",
				order = Order,
			}
			Order = Order + 1
		end

		-- Populate the Website field(s).
		if type(Websites) == "table" then
			local Count = #Websites
			if Count > 0 then
				for i = 1, Count do
					local Key = "Website"..i
					local Name = (i == 1) and L["Websites"] or ""
					args[Key] = {
						type = "input",
						name = Name,
						arg  = Websites[i],
						order = Order,
						dialogControl = "SFX-Info-URL",
					}
					Order = Order + 1
				end
				args["SPC"..Order] = {
					type = "description",
					name = " ",
					order = Order,
				}
				Order = Order + 1
			end
		elseif type(Websites) == "string" then
			args.Website = {
				type = "input",
				name = L["Website"],
				arg  = Websites,
				order = Order,
				dialogControl = "SFX-Info",
			}
			Order = Order + 1
			args["SPC"..Order] = {
				type = "description",
				name = " ",
				order = Order,
			}
			Order = Order + 1
		end

		-- Status
		args.Status = {
			type = "input",
			name = L["Status"],
			desc = Tooltip,
			arg = Status,
			order = Order,
			dialogControl = "SFX-Info",
		}

		return Info
	end
end

----------------------------------------
-- Setup
---

-- Creates/Removes the 'Installed Skins' options group/panel.
function Setup.Info(self)
	if not self.OptionsLoaded then return end

	local cArgs = self.Options.args.Core.args

	if not self.db.profile.SkinInfo then
		cArgs.SkinInfo = nil
	elseif not cArgs.SkinInfo then
		local Tooltip = "|cffffffff"..L["Select to view."].."|r"

		local Options = {
			type = "group",
			name = L["Installed Skins"],
			desc = Tooltip,
			get = self.GetArg,
			set = self.NoOp,
			order = 4,
			args = {
				Head = {
					type = "description",
					name = "|cffffcc00"..L["Installed Skins"].."|r\n",
					fontSize = "medium",
					order = 0,
				},
				Desc = {
					type = "description",
					name = L["This section provides information on any skins you have installed."].."\n",
					fontSize = "medium",
					order = 1,
				},
			},
		}

		local Skins, SkinList = self.Skins, self.SkinList
		local args = Options.args

		-- Create the info groups.
		for SkinID in pairs(SkinList) do
			local Skin = Skins[SkinID]
			local Group = Skin.Group

			if Group then
				if not args[Group] then
					args[Group] = {
						type = "group",
						name = Group,
						desc = Tooltip,
						args = {},
						childGroups = "select",
					}
				end
				args[Group].args[SkinID] = GetInfoGroup(Skin, Group)
			else
				args[SkinID] = GetInfoGroup(Skin)
				args[SkinID].desc = Tooltip
			end
		end

		cArgs.SkinInfo = Options
	else
		return
	end

	LIB_ACR:NotifyChange(MASQUE)
end
