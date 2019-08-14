local _, Addon = ...
local Dominos = _G.Dominos
local ExperienceBar = Dominos:CreateClass("Frame", Addon.ProgressBar)

local IsXPUserDisabled = IsXPUserDisabled or function() return false end

function ExperienceBar:Init()
	self:Update()
	self:SetColor(Addon.Config:GetColor("xp"))
	self:SetBonusColor(Addon.Config:GetColor("xp_bonus"))
end

function ExperienceBar:Update()
	local value = UnitXP("player")
	local max = UnitXPMax("player")
	local rest = GetXPExhaustion() or 0

	self:SetValues(value, max, rest)
	self:UpdateText(_G.XP, value, max, rest)
end

function ExperienceBar:IsModeActive()
	return not (IsPlayerAtEffectiveMaxLevel() or IsXPUserDisabled())
end

-- register this as a possible progress bar mode
Addon.progressBarModes = Addon.progressBarModes or {}
Addon.progressBarModes["xp"] = ExperienceBar
Addon.ExperienceBar = ExperienceBar
