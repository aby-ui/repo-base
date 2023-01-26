--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	docuementation and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Masque.lua
	* Author.: StormFX

	Add-On Setup

]]

local MASQUE, Core = ...

assert(LibStub, MASQUE.." requires LibStub.")

----------------------------------------
-- Lua API
---

local print = print

----------------------------------------
-- Internal
---

-- @ Locales\enUS
local L = Core.Locale

----------------------------------------
-- Locals
---

local Masque = LibStub("AceAddon-3.0"):NewAddon(MASQUE)

Masque.Core = Core

-- API Version
local API_VERSION = 100005

-- Client Version
local WOW_VERSION = select(4, GetBuildInfo()) or 0
local WOW_RETAIL = (WOW_VERSION >= 100000 and true) or nil

----------------------------------------
-- Utility
---

-- Function to migrate the DB.
local function MigrateDB()
	local db = Core.db.profile

	-- SkinID Migration @ 100002
	if db.API_VERSION < 100002 then
		local GetSkinID = Core.GetSkinID

		for _, gDB in pairs(db.Groups) do
			local SkinID = gDB.SkinID
			local NewID = GetSkinID(SkinID)

			-- Client-Specific Skin
			if SkinID == "Default" then
				gDB.SkinID = Core.DEFAULT_SKIN_ID

			-- Other
			elseif NewID then
				gDB.SkinID = NewID
			end
		end
	end

	-- Update the API version.
	db.API_VERSION = API_VERSION
end

----------------------------------------
-- Core
---

-- API
Core.API_VERSION = API_VERSION
Core.OLD_VERSION = 70200

Core.API = LibStub:NewLibrary(MASQUE, API_VERSION)

-- Client Version
Core.WOW_VERSION = WOW_VERSION
Core.WOW_RETAIL = WOW_RETAIL

-- Add-On Info
Core.Version = GetAddOnMetadata(MASQUE, "Version")
Core.Discord = "https://discord.gg/DDVqkd6"

Core.Authors = {
	"StormFX",
	"|cff999999JJSheets|r",
}
Core.Websites = {
	"https://github.com/SFX-WoW/Masque",
	"https://www.curseforge.com/wow/addons/masque",
	"https://addons.wago.io/addons/masque",
	"https://www.wowinterface.com/downloads/info12097",
}

-- Toggles debug mode.
function Core.ToggleDebug()
	local db = Core.db.profile
	local Debug = not db.Debug

	db.Debug = Debug
	Core.Debug = Debug

	if Debug then
		print("|cffffff99"..L["Masque debug mode enabled."].."|r")
	else
		print("|cffffff99"..L["Masque debug mode disabled."].."|r")
	end
end

-- Updates on profile activity.
function Core:UpdateProfile()
	self.Debug = self.db.profile.Debug

	-- Profile Migration
	MigrateDB()

	-- Skins and Skin Options
	local Global = self.GetGroup()
	Global:__Update()

	-- Info Panel
	self.Setup("Info")

	local LDBI = LibStub("LibDBIcon-1.0", true)
	if LDBI then
		LDBI:Refresh(MASQUE, Core.db.profile.LDB)
	end
end

----------------------------------------
-- Add-On
---

-- ADDON_LOADED Event
function Masque:OnInitialize()
	local Defaults = {
		profile = {
			API_VERSION = 0,
			AltSort = false,
			Debug = false,
			SkinInfo = true,
			StandAlone = true,
			Groups = {
				["*"] = {
					Backdrop = false,
					Colors = {},
					Disabled = false,
					Gloss = false,
					Inherit = true,
					Pulse = true,
					Scale = 1,
					Shadow = false,
					SkinID = Core.DEFAULT_SKIN_ID,
					UseScale = false,
				},
			},
			LDB = {
				hide = true,
				minimapPos = 220,
				radius = 80,
			},
		},
	}

	local db = LibStub("AceDB-3.0"):New("MasqueDB", Defaults, true)
	db.RegisterCallback(Core, "OnProfileChanged", "UpdateProfile")
	db.RegisterCallback(Core, "OnProfileCopied", "UpdateProfile")
	db.RegisterCallback(Core, "OnProfileReset", "UpdateProfile")
	Core.db = db

	local LDS = (WOW_VERSION > 30000) and LibStub("LibDualSpec-1.0", true)

	if LDS then
		LDS:EnhanceDatabase(Core.db, MASQUE)
		Core.USE_LDS = true
	end

	SLASH_MASQUE1 = "/msq"
	SLASH_MASQUE2 = "/masque"

	SlashCmdList["MASQUE"] = function(Cmd, ...)
		if Cmd == "debug" then
			Core.ToggleDebug()
		else
			Core:ToggleOptions()
		end
	end
end

-- PLAYER_LOGIN Event
function Masque:OnEnable()
	MigrateDB()

	local Setup = Core.Setup

	if Setup then
		Setup("Core")
		Setup("LDB")
	end

	if Core.Queue then
		Core.Queue:ReSkin()
	end
end

-- Wrapper for the DB:CopyProfile method.
function Masque:CopyProfile(Name, Silent)
	Core.db:CopyProfile(Name, Silent)
end

-- Wrapper for the DB:SetProfile method.
function Masque:SetProfile(Name)
	Core.db:SetProfile(Name)
end
