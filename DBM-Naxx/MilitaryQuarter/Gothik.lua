local mod	= DBM:NewMod("Gothik", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190516165414")
mod:SetCreatureID(16060)
mod:SetEncounterID(1109)
mod:SetModelID(16279)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"UNIT_DIED"
)

local warnWaveNow		= mod:NewAnnounce("WarningWaveSpawned", 3, nil, false)
local warnWaveSoon		= mod:NewAnnounce("WarningWaveSoon", 2)
local warnRiderDown		= mod:NewAnnounce("WarningRiderDown", 4)
local warnKnightDown	= mod:NewAnnounce("WarningKnightDown", 2)
local warnPhase2		= mod:NewPhaseAnnounce(2, 3)

local timerPhase2		= mod:NewTimer(270, "TimerPhase2", "136116", nil, nil, 6)
local timerWave			= mod:NewTimer(20, "TimerWave", "135974", nil, nil, 1)

mod.vb.wave = 0
local wavesNormal = {
	{2, L.Trainee, next = 20},
	{2, L.Trainee, next = 20},
	{2, L.Trainee, next = 10},
	{1, L.Knight, next = 10},
	{2, L.Trainee, next = 15},
	{1, L.Knight, next = 5},
	{2, L.Trainee, next = 20},
	{1, L.Knight, 2, L.Trainee, next = 10},
	{1, L.Rider, next = 10},
	{2, L.Trainee, next = 5},
	{1, L.Knight, next = 15},
	{2, L.Trainee, 1, L.Rider, next = 10},
	{2, L.Knight, next = 10},
	{2, L.Trainee, next = 10},
	{1, L.Rider, next = 5},
	{1, L.Knight, next = 5},
	{2, L.Trainee, next = 20},
	{1, L.Rider, 1, L.Knight, 2, L.Trainee, next = 15},
	{2, L.Trainee},
}

local wavesHeroic = {
	{3, L.Trainee, next = 20},
	{3, L.Trainee, next = 20},
	{3, L.Trainee, next = 10},
	{2, L.Knight, next = 10},
	{3, L.Trainee, next = 15},
	{2, L.Knight, next = 5},
	{3, L.Trainee, next = 20},
	{3, L.Trainee, 2, L.Knight, next = 10},
	{3, L.Trainee, next = 10},
	{1, L.Rider, next = 5},
	{3, L.Trainee, next = 15},
	{1, L.Rider, next = 10},
	{2, L.Knight, next = 10},
	{1, L.Rider, next = 10},
	{1, L.Rider, 3, L.Trainee, next = 5},
	{1, L.Knight, 3, L.Trainee, next = 5},
	{1, L.Rider, 3, L.Trainee, next = 20},
	{1, L.Rider, 2, L.Knight, 3, L.Trainee},
}


local waves = wavesNormal

local function getWaveString(wave)
	local waveInfo = waves[wave]
	if #waveInfo == 2 then
		return L.WarningWave1:format(unpack(waveInfo))
	elseif #waveInfo == 4 then
		return L.WarningWave2:format(unpack(waveInfo))
	elseif #waveInfo == 6 then
		return L.WarningWave3:format(unpack(waveInfo))
	end
end

function mod:NextWave()
	self.vb.wave = self.vb.wave + 1
	warnWaveNow:Show(self.vb.wave, getWaveString(self.vb.wave))
	local next = waves[self.vb.wave].next
	if next then
		timerWave:Start(next, self.vb.wave + 1)
		warnWaveSoon:Schedule(next - 3, self.vb.wave + 1, getWaveString(self.vb.wave + 1))
		self:ScheduleMethod(next, "NextWave")
	end
end

function mod:OnCombatStart(delay)
	if self:IsDifficulty("normal25") then
		waves = wavesHeroic
	else
		waves = wavesNormal
	end
	self.vb.wave = 0
	timerPhase2:Start()
	warnPhase2:Schedule(270)
	timerWave:Start(25, self.vb.wave + 1)
	warnWaveSoon:Schedule(22, self.vb.wave + 1, getWaveString(self.vb.wave + 1))
	self:ScheduleMethod(25, "NextWave")
end

function mod:OnTimerRecovery()
	if self:IsDifficulty("normal25") then
		waves = wavesHeroic
	else
		waves = wavesNormal
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 16126 then -- Unrelenting Rider
		warnRiderDown:Show()
	elseif cid == 16125 then -- Unrelenting Deathknight
		warnKnightDown:Show()
	end
end

