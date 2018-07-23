local mod	= DBM:NewMod("ArtifactImpossibleFoe", "DBM-Challenges", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 105 $"):sub(12, -3))
mod:SetCreatureID(115638)
mod:SetZone()--Healer (1710), Tank (1698), DPS (1703-The God-Queen's Fury), DPS (Fel Totem Fall)
mod.soloChallenge = true
mod.onlyNormal = true

mod:RegisterCombat("combat")
mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 243113",
	"SPELL_AURA_REMOVED 243113",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)
--Notes:
--NEW VOICE: attackshield

local specWarnImpServants		= mod:NewSpecialWarningSwitch(235140, nil, nil, nil, 1, 2)--Agatha's Vengeance spellId used for now
local specWarnDarkFury			= mod:NewSpecialWarningSwitch(243111, nil, nil, nil, 1, 7)

local timerImpServantsCD		= mod:NewCDTimer(45, 235140, nil, nil, nil, 1)
local timerDarkFuryCD			= mod:NewCDTimer(51.1, 243111, nil, nil, nil, 5)

local countdownDarkFury			= mod:NewCountdown(10, 243111)

mod:AddInfoFrameOption(243113, true)

mod.vb.phase = 1

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	timerImpServantsCD:Start(11-delay)--14 in one log, 11 in another
	timerDarkFuryCD:Start(50-delay)
	countdownDarkFury:Start(50-delay)
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 243113 then
		specWarnDarkFury:Show()
		specWarnDarkFury:Play("attackshield")
		if self.vb.phase == 2 then
			timerDarkFuryCD:Start(68)
			countdownDarkFury:Start(68)
		else
			timerDarkFuryCD:Start()
			countdownDarkFury:Start(51.1)
		end
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(2, "enemyabsorb", args.spellName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 243113 then
		specWarnDarkFury:Play("shieldover")
		if self.Options.InfoFrame then
			DBM.InfoFrame:Hide()
		end
	end
end

function mod:UNIT_DIED(args)
	if args.destGUID == UnitGUID("player") then--Solo scenario, a player death is a wipe
		DBM:EndCombat(self, true)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 242987 then--Translocate
		if self.vb.phase == 1 then
			self.vb.phase = 2
		end
	end
end

--"<53.75 21:03:46> [CHAT_MSG_MONSTER_EMOTE] |TInterface\\Icons\\spell_shaman_earthquake:20|t%s readies itself to charge!#Jormog the Behemoth###Kylistà##0#0##0#12#nil#0#false#false#false#false", -- [133]
function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find(L.impServants) or msg == L.impServants then
		specWarnImpServants:Show()
		specWarnImpServants:Play("bigmob")
		timerImpServantsCD:Start()
	end
end
