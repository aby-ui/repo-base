local _, Addon = ...
local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")
local ProgressBarModule = Dominos:NewModule("ProgressBars", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Dominos-Progress")

function ProgressBarModule:OnInitialize()
	Addon.Config:Init()
end

function ProgressBarModule:OnEnable()
	-- common events
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_UPDATE_RESTING")
	self:RegisterEvent("UPDATE_EXHAUSTION")

	-- xp bar events
	self:RegisterEvent("PLAYER_XP_UPDATE")

	-- reputation events
	self:RegisterEvent("UPDATE_FACTION")

	-- honor events
	if Addon.HonorBar then
		self:RegisterEvent("HONOR_LEVEL_UPDATE")
		self:RegisterEvent("HONOR_XP_UPDATE")
	end

	-- artifact events
	if Addon.ArtifactBar then
		self:RegisterEvent("ARTIFACT_XP_UPDATE")
		self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	end

	-- azerite events
	if Addon.AzeriteBar then
		self:RegisterEvent("AZERITE_ITEM_EXPERIENCE_CHANGED")
	end

     -- gold events
     if Addon.GoldBar then
           self:RegisterEvent("PLAYER_MONEY")
     end

	-- addon and library callbacks
	Dominos.RegisterCallback(self, "OPTIONS_MENU_LOADING")
	LibStub("LibSharedMedia-3.0").RegisterCallback(self, 'LibSharedMedia_Registered')
end

function ProgressBarModule:Load()
	if Dominos:IsBuild("classic") then
		self.bars = {
			Addon.ProgressBar:New("exp", {"xp", "reputation", "gold"})
		}
	elseif Addon.Config:OneBarMode() then
		self.bars = {
			Addon.ProgressBar:New("exp", {"xp", "reputation", "honor", "artifact", "azerite", "gold"})
		}
	else
		self.bars = {
			Addon.ProgressBar:New("exp", {"xp", "reputation", "honor", "gold"}),
			Addon.ProgressBar:New("artifact", {"azerite", "artifact"})
		}
	end
end

function ProgressBarModule:Unload()
	for i, bar in pairs(self.bars) do
		bar:Free()
		self.bars[i] = nil
	end
end

-- events
function ProgressBarModule:OPTIONS_MENU_LOADING()
	self:AddOptionsPanel()
end

function ProgressBarModule:PLAYER_ENTERING_WORLD()
	self:UpdateAllBars()
end

function ProgressBarModule:PLAYER_UPDATE_RESTING()
	self:UpdateAllBars()
end

function ProgressBarModule:UPDATE_EXHAUSTION()
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
	if unit ~= "player" then
		return
	end

	self:UpdateAllBars()
end

function ProgressBarModule:HONOR_LEVEL_UPDATE()
	self:UpdateAllBars()
end

function ProgressBarModule:HONOR_XP_UPDATE()
	self:UpdateAllBars()
end

function ProgressBarModule:PLAYER_MONEY()
     self:UpdateAllBars()
end

function ProgressBarModule:LibSharedMedia_Registered()
	self:UpdateAllBars()
end

function ProgressBarModule:UpdateAllBars()
	local bars = self.bars
	if not bars then return end

	for _, bar in pairs(self.bars) do
		bar:UpdateMode()
		bar:Update()
	end
end

function ProgressBarModule:AddOptionsPanel()
	Dominos.Options:AddOptionsPanel(function()
		local options = {
			key = "progress",

			name = L.Progress,

            order = 2,

			check(L.OneBarMode) {
				get = function()
					return Addon.Config:OneBarMode()
				end,

				set = function(_, enable)
					Addon.Config:SetOneBarMode(enable)
					self:Unload()
					self:Load()
				end
			},

			check(L.SkipInactiveModes) {
				get = function()
					return Addon.Config:SkipInactiveModes()
				end,

				set = function(_, enable)
					Addon.Config:SetSkipInactiveModes(enable)
				end
			},

                range(L.GoldGoal) {
                     min = 0,
                     max = 10000000,
                     softMin = 0,
                     softMax = 10000000,
                     step = 1000,
                     bigStep = 10000,
                     width = "double",
                     get = function()
                           return Addon.Config:GoldGoal()
                     end,
                     set = function(_, value)
                           Addon.Config:SetGoldGoal(value)
                           self:UpdateAllBars()
                     end,
                },

			h(COLORS)
		}

		for _, key in ipairs{ "xp", "xp_bonus", "honor", "artifact", "azerite", "gold", "gold_realm" } do
			tinsert(options, color(L["Color_" .. key]) {
				hasAlpha = true,

				get = function()
					return Addon.Config:GetColor(key)
				end,

				set = function(_, ...)
					Addon.Config:SetColor(key, ...)

					for _, bar in pairs(self.bars) do
						bar:Init()
					end
				end
			})
		end

		return options
	end)
end
