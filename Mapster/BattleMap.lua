--[[
Copyright (c) 2009-2016, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local MODNAME = "BattleMap"
local BattleMap = Mapster:NewModule(MODNAME, "AceEvent-3.0")
local FogClear

-- Make sure to get the global before FogClear loads and overwrites it
local GetNumMapOverlays = GetNumMapOverlays

local db
local defaults = { 
	profile = {
		hideTextures = false,
	}
}

local optGetter, optSetter
do
	local mod = BattleMap
	function optGetter(info)
		local key = info[#info]
		return db[key]
	end

	function optSetter(info, value)
		local key = info[#info]
		db[key] = value
		mod:Refresh()
	end
end

local options
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = L["BattleMap"],
			arg = MODNAME,
			get = optGetter,
			set = optSetter,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["The BattleMap module allows you to change the style of the BattlefieldMinimap, removing unnecessary textures or PvP Objectives."],
				},
				enabled = {
					order = 2,
					type = "toggle",
					name = L["Enable BattleMap"],
					get = function() return Mapster:GetModuleEnabled(MODNAME) end,
					set = function(info, value) Mapster:SetModuleEnabled(MODNAME, value) end,
				},
				texturesdesc = {
					order = 3,
					type = "description",
					name = "\n" .. L["Hide the surrounding textures around the BattleMap, only leaving you with the pure map overlays."],
				},
				hideTextures = {
					order = 4,
					type = "toggle",
					name = L["Hide Textures"],
				},
			},
		}
	end

	return options
end

function BattleMap:OnInitialize()
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:RegisterModuleOptions(MODNAME, getOptions, L["BattleMap"])

	FogClear = Mapster:GetModule("FogClear", true)
end

function BattleMap:OnEnable()
	if not IsAddOnLoaded("Blizzard_BattlefieldMinimap") then
		self:RegisterEvent("ADDON_LOADED", function(event, addon)
			if addon == "Blizzard_BattlefieldMinimap" then
				BattleMap:UnregisterEvent("ADDON_LOADED")
				BattleMap:SetupMap()
			end
		end)
	else
		self:SetupMap()
	end
end

function BattleMap:OnDisable()
	if BattlefieldMinimap then
		BattlefieldMinimapCorner:Show()
		BattlefieldMinimapBackground:Show()
		BattlefieldMinimapCloseButton:Show()
		BattlefieldMinimapTab:Show()
	end

	self:UpdateTextureVisibility()
end

function BattleMap:SetupMap()
	BattlefieldMinimapCorner:Hide()
	BattlefieldMinimapBackground:Hide()
	BattlefieldMinimapCloseButton:Hide()
	BattlefieldMinimapTab:Hide()

	self:RegisterEvent("WORLD_MAP_UPDATE", "UpdateTextureVisibility")
	self:UpdateTextureVisibility()
end

function BattleMap:Refresh()
	db = self.db.profile
	if not self:IsEnabled() then return end

	self:UpdateTextureVisibility()
end

function BattleMap:UpdateTextureVisibility()
	if not BattlefieldMinimap then return end
	local hasOverlays
	if FogClear and FogClear:IsEnabled() then hasOverlays = FogClear:RealHasOverlays() else hasOverlays = GetNumMapOverlays() > 0 end
	if hasOverlays and db.hideTextures and self:IsEnabled() then
		for i=1,12 do
			_G["BattlefieldMinimap"..i]:Hide()
		end
	else
		for i=1,12 do
			_G["BattlefieldMinimap"..i]:Show()
		end
	end
end
