local mod	= DBM:NewMod(1214, "DBM-Party-WoD", 5, 556)
local L		= mod:GetLocalizedStrings()

mod:SetRevision((string.sub("20190414033732", 1, -5)):sub(12, -3))
mod:SetCreatureID(81522)
mod:SetEncounterID(1746)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 164357",
	"SPELL_CAST_SUCCESS 164275",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"CHAT_MSG_MONSTER_EMOTE",
	"RAID_BOSS_WHISPER"
)

local warnBrittleBark			= mod:NewSpellAnnounce(164275, 1)
local warnBrittleBarkOver		= mod:NewEndAnnounce(164275, 2)
local warnUncheckedGrowth		= mod:NewSpellAnnounce("ej10098", 3, 164294)

local specWarnLivingLeaves		= mod:NewSpecialWarningMove(169495, nil, nil, nil, 1, 8)
local specWarnUncheckedGrowthYou= mod:NewSpecialWarningYou(164294, nil, nil, nil, 1, 2)
local specWarnUncheckedGrowth	= mod:NewSpecialWarningMove(164294, nil, nil, nil, 1, 8)
local specWarnUncheckedGrowthAdd= mod:NewSpecialWarningSwitch("ej10098", "Tank", nil, nil, 1, 2)
local specWarnParchedGrasp		= mod:NewSpecialWarningSpell(164357, "Tank", nil, nil, 1, 2)

local timerParchedGrasp			= mod:NewCDTimer(12, 164357, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)

function mod:OnCombatStart(delay)
	timerParchedGrasp:Start(7-delay)
	if not self:IsTrivial(110) then
		self:RegisterShortTermEvents(
			"SPELL_PERIODIC_DAMAGE 169495 164294",
			"SPELL_PERIODIC_MISSED 169495 164294"
		)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 164357 then
		specWarnParchedGrasp:Show()
		specWarnParchedGrasp:Play("breathsoon")
		timerParchedGrasp:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 164275 then
		warnBrittleBark:Show()
		timerParchedGrasp:Cancel()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 169495 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnLivingLeaves:Show()
		specWarnLivingLeaves:Play("watchfeet")
	elseif spellId == 164294 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnUncheckedGrowth:Show()
		specWarnUncheckedGrowth:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 164718 then--Cancel Brittle Bark
		warnBrittleBarkOver:Show()
	end
end

function mod:CHAT_MSG_MONSTER_EMOTE(msg)--Message doesn't matter, it occurs only for one thing during this fight
	if self.Options.SpecWarnej10098switch then
		specWarnUncheckedGrowthAdd:Show()
		specWarnUncheckedGrowthAdd:Play("killmob")
	else
		warnUncheckedGrowth:Show()
	end
end

function mod:RAID_BOSS_WHISPER()
	specWarnUncheckedGrowthYou:Show()
	specWarnUncheckedGrowthYou:Play("targetyou")
end
