--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Options/Core.lua
	* Author.: StormFX

	Core Options Group/Panel

]]

local MASQUE, Core = ...

----------------------------------------
-- WoW API
---

local InterfaceOptionsFrame = InterfaceOptionsFrame
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local InterfaceOptionsFrame_Show = InterfaceOptionsFrame_Show

----------------------------------------
-- Libraries
---

local ACD = LibStub("AceConfigDialog-3.0")

----------------------------------------
-- Setup
---

-- Options Loader
local Setup = {}

Core.Setup = setmetatable(Setup, {
	__call = function(self, Name, ...)
		local func = Name and self[Name]
		if func then
			func(Core, ...)
		end
	end,
})

-- Sets up the root options group/panel.
function Setup.Core(self)
	-- @ Locales\enUS
	local L = self.Locale

	-- @ Masque
	local CRLF = Core.CRLF

	local Options = {
		type = "group",
		name = MASQUE,
		args = {
			Core = {
				type = "group",
				name = L["About"],
				order = 0,
				args = {
					Head = {
						type = "description",
						name = "|cffffcc00Masque - "..L["About"].."|r"..CRLF,
						fontSize = "medium",
						hidden = self.GetStandAlone,
						order = 0,
					},
					Desc = {
						type = "description",
						name = L["This section will allow you to view information about Masque and any skins you have installed."]..CRLF,
						fontSize = "medium",
						hidden = function() return not Core.OptionsLoaded end,
						order = 1,
					},
					-- Necessary when manually navigating to the InterfaceOptionsFrame prior to the options being loaded.
					Load = {
						type = "group",
						name = "",
						inline = true,
						hidden = function() return Core.OptionsLoaded end,
						--order = 100,
						args = {
							Desc = {
								type = "description",
								name = L["Masque's options are load on demand. Click the button below to load them."]..CRLF,
								fontSize = "medium",
								order = 0,
							},
							Button = {
								type = "execute",
								name = L["Load Options"],
								confirm = true,
								confirmText = L["This action will increase memory usage."].."\n",
								desc = L["Click to load Masque's options."],
								func = function()
									if Setup.LoD then Setup("LoD") end
									-- Force a sub-panel refresh.
									InterfaceOptionsFrame_OpenToCategory(Core.OptionsPanel)
									InterfaceOptionsFrame_OpenToCategory(Core.SkinOptionsPanel)
									InterfaceOptionsFrame_OpenToCategory(Core.OptionsPanel)
									Core.Options.args.Core.args.Load = nil -- GC
								end,
								order = 1,
							},
						},
					},
				},
			},
		},
	}

	self.Options = Options

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(MASQUE, self.Options)
	self.OptionsPanel = ACD:AddToBlizOptions(MASQUE, MASQUE, nil, "Core")

	-- GC
	Setup.Core = nil
end

-- Loads the LoD options.
function Setup.LoD(self)
	self.OptionsLoaded = true

	Setup("About")
	Setup("Info")
	Setup("Skins")
	Setup("General")
	Setup("Profiles")

	-- GC
	Setup.LoD = nil
end

----------------------------------------
-- Core
---

-- Toggles the Interface/ACD options frame.
function Core:ToggleOptions()
	if Setup.LoD then Setup("LoD") end

	local IOF_Open = InterfaceOptionsFrame:IsShown()
	local ACD_Open = ACD.OpenFrames[MASQUE]

	-- Toggle the stand-alone GUI if enabled.
	if self.db.profile.StandAlone then
		if IOF_Open then
			InterfaceOptionsFrame_Show()
		elseif ACD_Open then
			ACD:Close(MASQUE)
		else
			ACD:Open(MASQUE)
		end
	-- Toggle the Interface Options frame.
	else
		if ACD_Open then
			ACD:Close(MASQUE)
		elseif IOF_Open then
			InterfaceOptionsFrame_Show()
		else
			-- Call twice to make sure the IOF opens to the proper category.
			InterfaceOptionsFrame_OpenToCategory(self.OptionsPanel)
			InterfaceOptionsFrame_OpenToCategory(self.SkinOptionsPanel)
		end
	end
end

----------------------------------------
-- Utility
---

-- Hides or shows panel titles.
function Core.GetStandAlone()
	return not ACD.OpenFrames[MASQUE]
end

-- Returns the 'arg' of an options group.
function Core.GetArg(Info, ...)
	return Info.arg
end
