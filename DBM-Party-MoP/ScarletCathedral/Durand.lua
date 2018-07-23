local mod	= DBM:NewMod(674, "DBM-Party-MoP", 9, 316)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 122 $"):sub(12, -3))
mod:SetCreatureID(60040, 99999)--3977 is High Inquisitor Whitemane and 60040 is Commander Durand, we don't really need to add her ID, because we don't ever engage her, and he true death is at same time as her.
mod:SetEncounterID(1425)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 113134 12039 130857",
	"SPELL_CAST_SUCCESS 9256",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2",
	"UNIT_DIED"
)

local warnFlashofSteel			= mod:NewSpellAnnounce(115627, 3)
local warnDashingStrike			= mod:NewSpellAnnounce(115676, 3)
local warnDeepSleep				= mod:NewSpellAnnounce(9256, 2)

local specWarnMassRes			= mod:NewSpecialWarningInterrupt(113134, true)
local specWarnHeal				= mod:NewSpecialWarningInterrupt(12039, true)
local specWarnMC				= mod:NewSpecialWarningInterrupt(130857, true)

local timerFlashofSteel			= mod:NewCDTimer(26, 115627)--not confirmed.
local timerDashingStrike		= mod:NewCDTimer(26, 115676)--not confirmed.
local timerMassResCD			= mod:NewCDTimer(21, 113134, nil, nil, nil, 4)--21-24sec variation. Earlier if phase transitions
local timerDeepSleep			= mod:NewBuffFadesTimer(10, 9256, nil, nil, nil, 6)
local timerMCCD					= mod:NewCDTimer(19, 130857, nil, nil, nil, 3)

local phase = 1

function mod:OnCombatStart(delay)
	phase = 1
	timerFlashofSteel:Start(9-delay)
	timerDashingStrike:Start(24-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 113134 then
		specWarnMassRes:Show(args.sourceName)
		timerMassResCD:Start()
	elseif args.spellId == 12039 then
		specWarnHeal:Show(args.sourceName)
	elseif args.spellId == 130857 then
		specWarnMC:Show(args.sourceName)
	end
end

--Could also use damage overkill like phase 1 but it's only .8 sec faster so no need.
--3/28 16:22:43.001  SWING_DAMAGE,0x0100000000009810,"Omegal",0x511,0x0,0xF1300F8900000065,"High Inquisitor Whitemane",0x10a48,0x0,10172,-1,1,0,0,410,1,nil,nil
--3/28 16:22:43.810  SPELL_CAST_SUCCESS,0xF1300F8900000065,"High Inquisitor Whitemane",0xa48,0x0,0x0000000000000000,nil,0x80000000,0x80000000,9256,"Deep Sleep",0x20
function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 9256 then--Phase 3
		phase = 3
		warnDeepSleep:Show()
		timerDeepSleep:Start()
		timerMassResCD:Start(18)--Limited Sample size
		if self:IsDifficulty("challenge5") then
			timerMCCD:Start(19)--Pretty much immediately after first mas res, unless mass res isn't interrupted then it'll delay MC
		end
	end
end


function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 115627 and self:AntiSpam(2, 1) then
		warnFlashofSteel:Show()
		timerFlashofSteel:Start()
	elseif spellId == 115676 and self:AntiSpam(2, 2) then
		warnDashingStrike:Show()
		timerDashingStrike:Start()
	end
end

function mod:UNIT_DIED(args)
	if self:GetCIDFromGUID(args.destGUID) == 60040 then
		if phase == 3 then--Fight is over on 2nd death
			DBM:EndCombat(self)
		else--it's first death, he's down and whiteman is taking over
			phase = 2
			timerMassResCD:Start(13)
			if self:IsDifficulty("challenge5") then
				timerMCCD:Start(14)
			end
			timerFlashofSteel:Cancel()
			timerDashingStrike:Cancel()
		end
	end
end
