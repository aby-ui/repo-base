local mod	= DBM:NewMod(967, "DBM-Party-WoD", 7, 476)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(76143)
mod:SetEncounterID(1700)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_REMOVED 159382",
	"SPELL_CAST_START 153810 153794 159382",
	"RAID_BOSS_WHISPER"
)

local warnSolarFlare			= mod:NewSpellAnnounce(153810, 3)

local specWarnPierceArmor		= mod:NewSpecialWarningDefensive(153794, "Tank", nil, nil, 1, 2)
local specWarnFixate			= mod:NewSpecialWarningYou(176544, nil, nil, nil, 1, 2)
local specWarnQuills			= mod:NewSpecialWarningSpell(159382, nil, nil, nil, 2, 2)
local specWarnQuillsEnd			= mod:NewSpecialWarningEnd(159382, nil, nil, nil, 1, 2)

local timerSolarFlareCD			= mod:NewCDTimer(18, 153810, nil, nil, nil, 3)
local timerQuills				= mod:NewBuffActiveTimer(17, 159382, nil, nil, nil, 2, nil, DBM_CORE_HEALER_ICON)

local skyTrashMod = DBM:GetModByName("SkyreachTrash")

function mod:OnCombatStart(delay)
	timerSolarFlareCD:Start(11-delay)
	if self:IsHeroic() then
		--timerQuillsCD:Start(33-delay)--Needs review
	end
	if skyTrashMod.Options.RangeFrame and skyTrashMod.vb.debuffCount ~= 0 then--In case of bug where range frame gets stuck open from trash pulls before this boss.
		skyTrashMod.vb.debuffCount = 0--Fix variable
		DBM.RangeCheck:Hide()--Close range frame.
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 159382 then
		specWarnQuillsEnd:Show()
		specWarnQuillsEnd:Play("safenow")
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 153810 then
		warnSolarFlare:Show()
		timerSolarFlareCD:Start()
		warnSolarFlare:Play("mobsoon")
		if self:IsDps() then
			warnSolarFlare:ScheduleVoice(2, "mobkill")
		end
	elseif spellId == 153794 then
		specWarnPierceArmor:Show()
		specWarnPierceArmor:Play("defensive")
	elseif spellId == 159382 then
		specWarnQuills:Show()
		timerQuills:Start()
		specWarnQuills:Play("findshelter")
	end
end

function mod:RAID_BOSS_WHISPER()
	specWarnFixate:Show()
	specWarnFixate:Play("targetyou")
end
