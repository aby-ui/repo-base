--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Options/Core.lua
	* Author.: StormFX

	Core Options Group/Panel

]]

local MASQUE, Core = ...

----------------------------------------
-- Libraries
---

local ACD = LibStub("AceConfigDialog-3.0")

----------------------------------------
-- WoW API
---

local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local InterfaceOptionsFrame_Show = InterfaceOptionsFrame_Show

----------------------------------------
-- Internal
---

-- @ Masque
local WOW_RETAIL = Core.WOW_RETAIL

----------------------------------------
-- Locals
---

-- Necessary for consistency across clients.
local CRLF = "\n "

-- Loader Frame
local OPT_FRAME

----------------------------------------
-- Setup
---

-- Options Setup Table
local Setup = {}

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
				},
			},
		},
	}

	self.Options = Options

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(MASQUE, self.Options)

	local Path = "Core"
	self:AddOptionsPanel(Path, ACD:AddToBlizOptions(MASQUE, MASQUE, nil, Path))

	OPT_FRAME = CreateFrame("Frame", "MSQ_OPT_FRAME", SettingsPanel or InterfaceOptionsFrame)
	OPT_FRAME:SetScript("OnShow", function() Setup("LoD") end)

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
	if OPT_FRAME then
		OPT_FRAME:SetScript("OnShow", nil)
	end

	Setup.LoD = nil
end

----------------------------------------
-- Core
---

Core.CRLF = CRLF
Core.Setup = setmetatable(Setup, {
	__call = function(self, Name, ...)
		local func = Name and self[Name]
		if func then
			func(Core, ...)
		end
	end,
})

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
			ACD:SelectGroup(MASQUE, "Skins", "Global")
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
