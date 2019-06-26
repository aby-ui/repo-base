if not _G.IsWatchingHonorAsXP then return end

local _, Addon = ...
local Dominos = _G.Dominos
local HonorBar = Dominos:CreateClass('Frame', Addon.ProgressBar)

function HonorBar:Init()
	self:SetColor(Addon.Config:GetColor('honor'))
	self:Update()
end

function HonorBar:Update()
	local value = UnitHonor('player') or 0
	local max = UnitHonorMax('player') or 1

	self:SetValues(value, max)
	self:UpdateText(_G.HONOR, value, max)
end

function HonorBar:IsModeActive()
	return IsWatchingHonorAsXP() or InActiveBattlefield() or IsInActiveWorldPVP()
end

-- register this as a possible progress bar mode
Addon.progressBarModes = Addon.progressBarModes or {}
Addon.progressBarModes['honor'] = HonorBar
Addon.HonorBar = HonorBar