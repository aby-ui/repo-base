local mod	= DBM:NewMod(1696, "DBM-Party-Legion", 9, 777)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic"

mod:SetRevision("20220116042005")
mod:SetCreatureID(102246)
mod:SetEncounterID(1852)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 202480",
	"SPELL_CAST_START 202217 202341 201863",
	"SPELL_PERIODIC_DAMAGE 202485",
	"SPELL_PERIODIC_MISSED 202485"
)

--TODO, if fixate poses a probelm on difficulties higher than heroic add a special warning.
--TODO, swarmCD
local warnImpale					= mod:NewTargetAnnounce(202341, 4)
local warnSwarm						= mod:NewSpellAnnounce(201863, 2)
local warnFixate					= mod:NewTargetAnnounce(202480, 3)

local specWarnMandibleStrike		= mod:NewSpecialWarningDefensive(202217, "Tank", nil, nil, 1, 2)
local specWarnImpale				= mod:NewSpecialWarningMoveAway(202341, nil, nil, nil, 1, 2)
local yellImpale					= mod:NewYell(202341)
local specWarnOozeGTFO				= mod:NewSpecialWarningMove(202485, nil, nil, nil, 1, 2)

local timerMandibleStrikeCD			= mod:NewCDTimer(22.8, 202217, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)--22-30
local timerImpaleCD					= mod:NewCDTimer(22.8, 202341, nil, nil, nil, 3)
local timerSwarmCD					= mod:NewCDTimer(22.8, 201863, nil, nil, nil, 1)
local timerFixateCD					= mod:NewCDTimer(15.5, 202480, nil, nil, nil, 3, nil, DBM_COMMON_L.HEROIC_ICON)

local bugsSeen = {}

function mod:ImpaleTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnImpale:Show()
		specWarnImpale:Play("runout")
		yellImpale:Yell()
	else
		warnImpale:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	table.wipe(bugsSeen)
	timerMandibleStrikeCD:Start(8.9-delay)
	timerImpaleCD:Start(18.5-delay)
	timerSwarmCD:Start(30-delay)
	if not self:IsNormal() then
		timerFixateCD:Start(35.5-delay)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 202217 then
		specWarnMandibleStrike:Show()
		specWarnMandibleStrike:Play("defensive")
		timerMandibleStrikeCD:Start()
	elseif spellId == 202341 then
		self:BossUnitTargetScanner("boss1", "ImpaleTarget", 3.4)
		timerImpaleCD:Start()
	elseif spellId == 201863 then
		warnSwarm:Show()
--		timerSwarmCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 202480 then
		warnFixate:Show(args.destName)
		if not bugsSeen[args.sourceGUID] then
			bugsSeen[args.sourceGUID] = true
			timerFixateCD:Start()
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 202485 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnOozeGTFO:Show()
		specWarnMandibleStrike:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE
