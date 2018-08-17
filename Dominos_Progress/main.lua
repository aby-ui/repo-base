--[[
	the main controller of dominos progress
--]]

local AddonName, Addon = ...
local Dominos = LibStub('AceAddon-3.0'):GetAddon('Dominos')
local ProgressBarModule = Dominos:NewModule('ProgressBars', 'AceEvent-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Progress')
local ConfigVersion = 1

function ProgressBarModule:OnInitialize()
	Addon.Config:Init()
end

function ProgressBarModule:Load()
	if Addon.Config:OneBarMode() then
		self.bars = {
			Addon.ExperienceBar:New('exp', { 'xp', 'reputation', 'honor', 'azerite' }),
		}
	else
		self.bars = {
			Addon.ExperienceBar:New('exp', { 'xp', 'reputation', 'honor' }),
			Addon.ArtifactBar:New('artifact', { 'azerite' })
		}
	end

	-- common events
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	self:RegisterEvent('UPDATE_EXHAUSTION')
	self:RegisterEvent('PLAYER_UPDATE_RESTING')

	-- xp bar events
	self:RegisterEvent('PLAYER_XP_UPDATE')

	-- reputation events
	self:RegisterEvent('UPDATE_FACTION')

	-- honor events
	self:RegisterEvent('HONOR_XP_UPDATE')
	self:RegisterEvent('HONOR_LEVEL_UPDATE')

	-- artifact events
	self:RegisterEvent('ARTIFACT_XP_UPDATE')
	self:RegisterEvent('UNIT_INVENTORY_CHANGED')

	-- azerite events
	self:RegisterEvent('AZERITE_ITEM_EXPERIENCE_CHANGED')

	self:RegisterEvent('ADDON_LOADED')
end

function ProgressBarModule:UpdateAllBars()
	for _, bar in pairs(self.bars) do
		bar:UpdateMode()
		bar:Update()
	end
end

function ProgressBarModule:Unload()
	for i, bar in pairs(self.bars) do
		bar:Free()
	end

	self.bars = {}
end

--[[ events ]]--

function ProgressBarModule:PLAYER_ENTERING_WORLD()
	self:UpdateAllBars()
end

function ProgressBarModule:UPDATE_EXHAUSTION()
	self:UpdateAllBars()
end

function ProgressBarModule:PLAYER_UPDATE_RESTING()
	self:UpdateAllBars()
end

function ProgressBarModule:PLAYER_XP_UPDATE()
	self:UpdateAllBars()
end

function ProgressBarModule:UPDATE_FACTION(event)
	self:UpdateAllBars()
end

function ProgressBarModule:ARTIFACT_XP_UPDATE()
	self:UpdateAllBars()
end

function ProgressBarModule:AZERITE_ITEM_EXPERIENCE_CHANGED()
	self:UpdateAllBars()
end

function ProgressBarModule:UNIT_INVENTORY_CHANGED(event, unit)
	if unit ~= 'player' then return end

	self:UpdateAllBars()
end

function ProgressBarModule:HONOR_XP_UPDATE()
	self:UpdateAllBars()
end

function ProgressBarModule:HONOR_LEVEL_UPDATE()
	self:UpdateAllBars()
end

function ProgressBarModule:ADDON_LOADED(event, addonName)
	if addonName == 'Dominos_Config' then
		self:AddOptionsPanel()
		self:UnregisterEvent('ADDON_LOADED')
	end
end

function ProgressBarModule:AddOptionsPanel()
	local panel = Dominos.Options.AddonOptions:NewPanel(L.Progress)
	local prev = nil

	local oneBarModeToggle = panel:Add('CheckButton', {
		name = L.OneBarMode,

		get = function()
			return Addon.Config:OneBarMode()
		end,

		set = function(_, enable)
			Addon.Config:SetOneBarMode(enable)
			self:Unload()
			self:Load()
		end
	})

	oneBarModeToggle:SetPoint('TOPLEFT', 0, -2)

	for i, key in ipairs{'xp', 'xp_bonus', 'honor', 'artifact', 'azerite'} do

		local picker = panel:Add('ColorPicker', {
			name = L['Color_' .. key],

			hasOpacity = true,

			get = function()
				return Addon.Config:GetColor(key)
			end,

			set = function(...)
				Addon.Config:SetColor(key, ...)

				for i, bar in pairs(self.bars) do
					bar:Init()
				end
			end
		})

		picker:SetPoint('TOP', prev or oneBarModeToggle, 'BOTTOM', 0, -6)
		prev = picker
	end
end