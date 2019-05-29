--[[
Copyright (c) 2009-2016, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local MODNAME = "GroupIcons"
local GroupIcons = Mapster:NewModule(MODNAME, "AceEvent-3.0", "AceHook-3.0")

local fmt = string.format

local _G = _G

local db
local defaults = {
	profile = {
		size = 24,
		sizeBattleMap = 16,
	}
}

local DEFAULT_WORLDMAP_SIZE = 16
local DEFAULT_BATTLEMAP_SIZE = 12

local FixWorldMapUnits, FixBattlefieldUnits

local options
local function getOptions()
	if not options then
		options = {
			order = 20,
			type = "group",
			name = L["Group Icons"],
			arg = MODNAME,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["The Group Icons module allows you to resize the raid and party icons on the world map."],
				},
				enabled = {
					order = 2,
					type = "toggle",
					name = L["Enable Group Icons"],
					get = function() return Mapster:GetModuleEnabled(MODNAME) end,
					set = function(info, value) Mapster:SetModuleEnabled(MODNAME, value) end,
				},
				size = {
					order = 3,
					type = "range",
					name = L["Size on the World Map"],
					min = 8, max = 48, step = 1,
					get = function() return db.size end,
					set = function(info, v)
						db.size = v
						GroupIcons:Refresh()
					end
				},
				sizeBattleMap = {
					order = 3,
					type = "range",
					name = L["Size on the Battle Map"],
					min = 8, max = 48, step = 1,
					get = function() return db.sizeBattleMap end,
					set = function(info, v)
						db.sizeBattleMap = v
						GroupIcons:Refresh()
					end
				}
			}
		}
	end

	return options
end

function GroupIcons:OnInitialize()
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:RegisterModuleOptions(MODNAME, getOptions, L["Group Icons"])
end

function GroupIcons:OnEnable()
	if not IsAddOnLoaded("Blizzard_BattlefieldMinimap") then
		self:RegisterEvent("ADDON_LOADED", function(event, addon)
			if addon == "Blizzard_BattlefieldMinimap" then
				GroupIcons:UnregisterEvent("ADDON_LOADED")
				FixBattlefieldUnits(true)
				self:UnregisterEvent("ADDON_LOADED")
			end
		end)
	else
		FixBattlefieldUnits(true)
	end
	FixWorldMapUnits(true)
end

function GroupIcons:Refresh()
	db = self.db.profile
	FixWorldMapUnits(self:IsEnabled())
	FixBattlefieldUnits(self:IsEnabled())
end

function GroupIcons:OnDisable()
	FixWorldMapUnits(false)
	FixBattlefieldUnits(false)
end

local function FixUnit(unit, state, size, defSize)
	local frame = _G[unit]
	if not frame then return end
	if state then
		frame:SetWidth(size)
		frame:SetHeight(size)
	else
		frame:SetWidth(defSize)
		frame:SetHeight(defSize)
	end
end

function FixWorldMapUnits(state)
	local size = db.size
	for i = 1, 4 do
		FixUnit(fmt("WorldMapParty%d", i), state, size, DEFAULT_WORLDMAP_SIZE)
	end
	for i = 1,40 do
		FixUnit(fmt("WorldMapRaid%d", i), state, size, DEFAULT_WORLDMAP_SIZE)
	end
end

function FixBattlefieldUnits(state)
	if BattlefieldMinimap then
		local size = db.sizeBattleMap
		for i = 1, 4 do
			FixUnit(fmt("BattlefieldMinimapParty%d", i), state, size, DEFAULT_BATTLEMAP_SIZE)
		end
		for i = 1, 40 do
			FixUnit(fmt("BattlefieldMinimapRaid%d", i), state, size, DEFAULT_BATTLEMAP_SIZE)
		end
	end
end
