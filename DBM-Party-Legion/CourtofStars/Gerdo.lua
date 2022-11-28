local mod	= DBM:NewMod(1718, "DBM-Party-Legion", 7, 800)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge,timewalker"

mod:SetRevision("20221128034518")
mod:SetCreatureID(104215)
mod:SetEncounterID(1868)
mod:SetHotfixNoticeRev(20221127000000)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 207261 207815 207806",
	"SPELL_CAST_SUCCESS 207278 219488"
)

--[[
(ability.id = 207261 or ability.id = 207815 or ability.id = 207806) and type = "begincast"
 or (ability.id = 219488 or ability.id = 207278) and type = "cast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnStreetsweeper				= mod:NewTargetNoFilterAnnounce(219488, 2, nil, false)
local warnFlask						= mod:NewSpellAnnounce(207815, 2)

local specWarnResonantSlash			= mod:NewSpecialWarningDodge(207261, nil, nil, nil, 2, 2)
local specWarnArcaneLockdown		= mod:NewSpecialWarningJump(207278, nil, nil, nil, 2, 6)
local specWarnBeacon				= mod:NewSpecialWarningSwitch(207806, nil, nil, nil, 1, 2)

local timerStreetsweeperCD			= mod:NewCDTimer(6, 219488, nil, nil, nil, 3)
local timerResonantSlashCD			= mod:NewCDTimer(12.1, 207261, nil, nil, nil, 3)
local timerArcaneLockdownCD			= mod:NewCDTimer(27.9, 207278, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	self:SetStage(1)
	timerResonantSlashCD:Start(6.2-delay)
	timerStreetsweeperCD:Start(11.1)
	timerArcaneLockdownCD:Start(15-delay)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 207261 then
		specWarnResonantSlash:Show()
		specWarnResonantSlash:Play("watchstep")
		if self.vb.phase == 2 then
			timerResonantSlashCD:Start(10)
		else
			timerResonantSlashCD:Start()
		end
	elseif spellId == 207815 then
		self:SetStage(2)
		warnFlask:Show()
	elseif spellId == 207806 then
		specWarnBeacon:Show()
		specWarnBeacon:Play("mobsoon")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 207278 then--Success since jumping on cast start too early
		specWarnArcaneLockdown:Show()
		specWarnArcaneLockdown:Play("keepjump")
		timerArcaneLockdownCD:Start()
	elseif spellId == 219488 then
		warnStreetsweeper:Show(args.destName)
		timerStreetsweeperCD:Start()
	end
end
