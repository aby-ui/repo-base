--[[
	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Masque.lua
	* Author.: StormFX

]]

local MASQUE, Core = ...

-- Lua Functions
local print = print

----------------------------------------
-- Libraries, etc.
----------------------------------------

-- GLOBALS: LibStub

assert(LibStub, "Masque requires LibStub.")
local Masque = LibStub("AceAddon-3.0"):NewAddon(MASQUE)
Masque.Core = Core

Core.API = LibStub:NewLibrary(MASQUE, 70200)
Core.Version = GetAddOnMetadata(MASQUE, "Version")

local ACR = LibStub("AceConfigRegistry-3.0")

local LDB = LibStub("LibDataBroker-1.1", true)
local LDBI = LibStub("LibDBIcon-1.0", true)

local L = Core.Locale

----------------------------------------
-- Basic Options Table
----------------------------------------

Core.Options = {
	type = "group",
	name = MASQUE,
	args = {
		General = {
			type = "group",
			name = L["General"],
			order = 0,
			args = {},
		},
	},
}

----------------------------------------
-- ADDON_LOADED Event
----------------------------------------

function Masque:OnInitialize()
	local Defaults = {
		profile = {
			Debug = false,
			Groups = {
				["*"] = {
					Inherit = true,
					Disabled = false,
					SkinID = "Blizzard",
					Gloss = 0.35,
					Backdrop = false,
					Colors = {},
				},
			},
			LDB = {
				hide = true,
				minimapPos = 25,
				radius = 80,
			},
		},
	}
	local db = LibStub("AceDB-3.0"):New("MasqueDB", Defaults, true)
	db.RegisterCallback(Core, "OnProfileChanged", "Update")
	db.RegisterCallback(Core, "OnProfileCopied", "Update")
	db.RegisterCallback(Core, "OnProfileReset", "Update")
	Core.db = db
	SLASH_MASQUE1 = "/msq"
	SLASH_MASQUE2 = "/masque"
	SlashCmdList["MASQUE"] = function(Cmd, ...)
		if Cmd == "debug" then
			Core:Debug()
		else
			Core:ShowOptions()
		end
	end
end

----------------------------------------
-- PLAYER_LOGIN Event
----------------------------------------

function Masque:OnEnable()
	local db = Core.db.profile
	ACR:RegisterOptionsTable(MASQUE, Core.Options)
	Core.ACR = ACR
	Core.OptionsPanel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(MASQUE, MASQUE, nil, "General")
	Core.Options.args.General.args.Load = {
		type = "execute",
		name = L["Load Masque Options"],
		desc = (L["Click this button to load Masque's options. You can also use the %s or %s chat command."]):format("|cffffcc00/msq|r", "|cffffcc00/masque|r"),
		func = function()
			Core:LoadOptions()
			InterfaceOptionsFrame_OpenToCategory(Core.OptionsPanel.Addons)
		end,
		hidden = function()
			return Core.OptionsLoaded
		end,
		order = 0,
	}
	if LDB then
		Core.LDBO = LDB:NewDataObject(MASQUE, {
			type  = "launcher",
			label = MASQUE,
			icon  = "Interface\\Addons\\Masque\\Textures\\Icon",
			OnClick = function(self, Button)
				if Button == "LeftButton" or Button == "RightButton" then
					Core:ShowOptions()
				end
			end,
			OnTooltipShow = function(Tip)
				if not Tip or not Tip.AddLine then
					return
				end
				Tip:AddLine(MASQUE)
				Tip:AddLine(L["Click to open Masque's options window."], 1, 1, 1)
			end,
		})
		Core.LDB = LDB
		if LDBI then
			LDBI:Register(MASQUE, Core.LDBO, db.LDB)
			Core.LDBI = LDBI
		end
	end
end

----------------------------------------
-- Core Methods
----------------------------------------

-- Toggles debug mode.
function Core:Debug()
	local db = self.db.profile
	if db.Debug then
		db.Debug = false
		print("|cffffff99"..L["Masque debug mode disabled."].."|r")
	else
		db.Debug = true
		print("|cffffff99"..L["Masque debug mode enabled."].."|r")
	end
end

-- Updates the current profile.
function Core:Update()
	local Global = Core:Group()
	Global:Update()
	if LDBI then
		LDBI:Refresh(MASQUE, Core.db.profile.LDB)
	end
end

----------------------------------------
-- Miscellaneous
----------------------------------------

-- Bridge for the DB:CopyProfile method.
function Masque:CopyProfile(Name, Silent)
	Core.db:CopyProfile(Name, Silent)
end

-- Bridge for the DB:SetProfile method.
function Masque:SetProfile(Name)
	Core.db:SetProfile(Name)
end
