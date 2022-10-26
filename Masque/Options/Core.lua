--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Options/Core.lua
	* Author.: StormFX

	Core Options Group/Panel

]]

local MASQUE, Core = ...

----------------------------------------
-- WoW API
---

local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local InterfaceOptionsFrame_Show = InterfaceOptionsFrame_Show

----------------------------------------
-- Libraries
---

local ACD = LibStub("AceConfigDialog-3.0")

----------------------------------------
-- Locals
---

-- Necessary for UI consistency across game versions.
local CRLF = "\n "
Core.CRLF = CRLF

local WOW_RETAIL = Core.WOW_RETAIL

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
						type = "header",
						name = MASQUE.." - "..L["About"],
						order = 0,
						hidden = self.GetStandAlone,
						disabled = true,
						dialogControl = "SFX-Header",
					},
					Desc = {
						type = "description",
						name = L["This section will allow you to view information about Masque and any skins you have installed."]..CRLF,
						order = 1,
						hidden = function() return not Core.OptionsLoaded end,
						fontSize = "medium",
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
								order = 0,
								fontSize = "medium",
							},
							Button = {
								type = "execute",
								name = L["Load Options"],
								desc = L["Click to load Masque's options."],
								func = function()
									if Setup.LoD then Setup("LoD") end

									-- Force a sub-panel refresh.
									if SettingsPanel then
										SettingsPanel:OpenToCategory(self.OptionsPanels.Core)
									else
										local Frames = Core.OptionsPanels.Frames

										InterfaceOptionsFrame_OpenToCategory(Frames.Skins)
										InterfaceOptionsFrame_OpenToCategory(Frames.Core)
									end
									Core.Options.args.Core.args.Load = nil -- GC
								end,
								order = 1,
								confirm = true,
								confirmText = L["This action will increase memory usage."].."\n",
							},
						},
					},
				},
			},
		},
	}

	self.Options = Options

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(MASQUE, self.Options)

	local Path = "Core"
	self:AddOptionsPanel(Path, ACD:AddToBlizOptions(MASQUE, MASQUE, nil, Path))

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

-- Adds options panel info.
function Core:AddOptionsPanel(Path, Frame, Name)
	local Panels = self.OptionsPanels

	if not Panels then
		Panels = {Frames = {}}
		self.OptionsPanels = Panels
	end

	local Frames = Panels.Frames

	Frames[Path] = Frame
	Panels[Path] = Name
end

-- Toggles the Interface/ACD options frame.
function Core:ToggleOptions()
	if Setup.LoD then Setup("LoD") end

	local IOF_Open = InterfaceOptionsFrame and InterfaceOptionsFrame:IsShown()
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
			if WOW_RETAIL then
				SettingsPanel:OpenToCategory(self.OptionsPanels.Core)
			else
				local Frames = self.OptionsPanels.Frames

				-- Call twice to make sure the IOF opens to the proper category.
				InterfaceOptionsFrame_OpenToCategory(Frames.Core)
				InterfaceOptionsFrame_OpenToCategory(Frames.Skins)
			end
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
