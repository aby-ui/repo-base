local mod	= DBM:NewMod(814, "DBM-Pandaria", nil, 322)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019041710000")
mod:SetCreatureID(69099)
mod:SetEncounterID(1571)
mod:SetReCombatTime(20, 10)
mod:SetZone()

mod:RegisterCombat("combat_yell", L.Pull)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 136340 136338 136339",
	"SPELL_AURA_APPLIED 136340 136339"
)

local warnStormcloud				= mod:NewTargetAnnounce(136340, 3)
local warnLightningTether			= mod:NewTargetAnnounce(136339, 3)

local specWarnStormcloud			= mod:NewSpecialWarningYou(136340)
local yellStormcloud				= mod:NewYell(136340)
local specWarnLightningTether		= mod:NewSpecialWarningYou(136339)--Is this important enough?
local specWarnArcNova				= mod:NewSpecialWarningRun(136338, "Melee", nil, 2, 4)

local timerStormcloudCD				= mod:NewCDTimer(21.5, 136340, nil, nil, nil, 3)
local timerLightningTetherCD		= mod:NewCDTimer(30.5, 136339, nil, nil, nil, 3)--Needs more data, they may have tweaked it some.
local timerArcNovaCD				= mod:NewCDTimer(35.5, 136338, nil, nil, nil, 2)

mod:AddBoolOption("RangeFrame")--For Stormcloud, might tweek to not show all the time with actual better logs than me facepulling it and dying with 20 seconds
mod:AddReadyCheckOption(32518, false)

local stormcloudTargets = {}
local tetherTargets = {}
local cloudDebuff = DBM:GetSpellInfo(136340)

local debuffFilter
do
	debuffFilter = function(uId)
		return DBM:UnitDebuff(uId, cloudDebuff)
	end
end

local function warnStormcloudTargets()
	warnStormcloud:Show(table.concat(stormcloudTargets, "<, >"))
	table.wipe(stormcloudTargets)
	if mod.Options.RangeFrame then
		if DBM:UnitDebuff("player", cloudDebuff) then--You have debuff, show everyone
			DBM.RangeCheck:Show(10, nil)
		else--You do not have debuff, only show players who do
			DBM.RangeCheck:Show(10, debuffFilter)
		end
	end
end

local function warnTetherTargets()
	warnLightningTether:Show(table.concat(tetherTargets, "<, >"))
	table.wipe(tetherTargets)
end

function mod:OnCombatStart(delay, yellTriggered)
	table.wipe(stormcloudTargets)
	table.wipe(tetherTargets)
	if yellTriggered then
		timerStormcloudCD:Start(13.2-delay)--13-17 variation noted
		timerLightningTetherCD:Start(24.5-delay)
		timerArcNovaCD:Start(36-delay)--Not a large sample size
	end
end

function mod:OnCombatEnd()
	table.wipe(stormcloudTargets)
	table.wipe(tetherTargets)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 136340 then
		timerStormcloudCD:Start()
	elseif spellId == 136338 then
		specWarnArcNova:Show()
		timerArcNovaCD:Start()
	elseif spellId == 136339 then
		timerLightningTetherCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 136340 and self:IsInCombat() then
		stormcloudTargets[#stormcloudTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnStormcloud:Show()
			yellStormcloud:Yell()
		end
		self:Unschedule(warnStormcloudTargets)
		self:Schedule(0.3, warnStormcloudTargets)
	elseif spellId == 136339 then
		tetherTargets[#tetherTargets + 1] = args.destName
		if args:IsPlayer() then
			specWarnLightningTether:Show()
		end
		self:Unschedule(warnTetherTargets)
		self:Schedule(0.3, warnTetherTargets)
	end
end
