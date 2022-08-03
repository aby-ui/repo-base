local mod	= DBM:NewMod(1711, "DBM-Party-Legion", 9, 777)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic"

mod:SetRevision("20220610054416")
mod:SetCreatureID(102446)
mod:SetEncounterID(1856)
mod:SetUsedIcons(1, 2, 3)--3 icons?

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 210879 205233",
	"SPELL_AURA_REMOVED 210879 205233",
	"SPELL_CAST_SUCCESS 210879",
	"SPELL_CAST_START 203641 202328"
)

local warnFelSlash				= mod:NewTargetAnnounce(203641, 4)
local warnSeedofDestruction		= mod:NewTargetAnnounce(210879, 3)
local warnExecute				= mod:NewTargetAnnounce(205233, 4)

local specWarnFelSlash			= mod:NewSpecialWarningDodge(203641, nil, nil, nil, 1, 2)--warn Everyone since cone is so wide
local yellFelSlash				= mod:NewYell(203641)
local specWarnMightySmash		= mod:NewSpecialWarningSpell(202328, nil, nil, nil, 2, 2)
local specWarnSeedofDestruction	= mod:NewSpecialWarningYou(210879, nil, nil, nil, 1, 2)
local yellSeedsofDestruction	= mod:NewYell(210879)

--local timerFelSlashCD			= mod:NewCDTimer(18, 203641, nil, nil, nil, 3)--Too unreliable do to smash/executions
local timerMightySmashCD		= mod:NewCDTimer(50, 202328, nil, nil, nil, 2)--50-57
local timerSeedsCD				= mod:NewCDTimer(21.8, 210879, nil, nil, nil, 3, nil, DBM_COMMON_L.HEROIC_ICON)--22-40
local timerExecute				= mod:NewTargetTimer(20, 205233, nil, nil, nil, 3, nil, DBM_COMMON_L.DEADLY_ICON)--22-40

mod:AddSetIconOption("SetIconOnSeeds", 210879, true, 6, {1, 2, 3})

function mod:SlashTarget(targetname, uId)
	if not targetname then return end
	warnFelSlash:Show(targetname)
	if targetname == UnitName("player") then
		yellFelSlash:Yell()
	end
end

function mod:OnCombatStart(delay)
	--timerFelSlashCD:Start(11-delay)
	if not self:IsNormal() then
		timerSeedsCD:Start(17-delay)
	end
	timerMightySmashCD:Start(30-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 210879 then
		warnSeedofDestruction:CombinedShow(0.5, args.destName)
		if args:IsPlayer() then
			specWarnSeedofDestruction:Show()
			yellSeedsofDestruction:Yell()
			specWarnSeedofDestruction:Play("runout")
		end
		if self.Options.SetIconOnSeeds then
			self:SetAlphaIcon(0.5, args.destName)
		end
	elseif spellId == 205233 then
		warnExecute:Show(args.destName)
		timerExecute:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 210879 and self.Options.SetIconOnSeeds then
		self:SetIcon(args.destName, 0)
	elseif spellId == 205233 then
		timerExecute:Stop(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 210879 then
		timerSeedsCD:Start()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 203641 then
		specWarnFelSlash:Show()
		specWarnFelSlash:Play("shockwave")
		self:BossUnitTargetScanner("boss1", "SlashTarget", 3)
		--timerFelSlashCD:Start()
	elseif spellId == 202328 then
		specWarnMightySmash:Show()
		specWarnMightySmash:Play("carefly")
		timerMightySmashCD:Start()
	end
end
