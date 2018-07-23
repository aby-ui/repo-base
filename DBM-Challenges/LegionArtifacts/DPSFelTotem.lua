local mod	= DBM:NewMod("ArtifactFelTotem", "DBM-Challenges", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 105 $"):sub(12, -3))
mod:SetCreatureID(117230, 117484)--Tugar, Jormog
mod:SetZone()--Healer (1710), Tank (1698), DPS (1703-The God-Queen's Fury), DPS (Fel Totem Fall)
mod:SetBossHPInfoToHighest()
mod.soloChallenge = true
mod.onlyNormal = true

mod:RegisterCombat("combat")
mod:RegisterEventsInCombat(
	"SPELL_CAST_START 241687 242496 242733",
	"SPELL_AURA_REMOVED 238471",
	"SPELL_AURA_REMOVED_DOSE 238471",
	"SPELL_CAST_SUCCESS 242730 237950",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3 boss4 boss5",--need all 5?
	"CHAT_MSG_MONSTER_EMOTE"
)
--Notes:
--TODO, all. mapids, mob iDs, win event to stop timers (currently only death event stops them)
--Damage (Fel Totem Fall)
--  ["241687-Sonic Scream"] = "pull:33.8, 48.6, 17.0, 41.3, 15.7, 45.1, 17.0, 43.7, 19.2",
--  ["242733-Fel Burst"] = "pull:30.2, 23.1, 21.9, 20.7, 19.4, 18.2, 18.2, 23.1, 15.8, 15.8, 14.6, 13.4, 13.4, 12.2, 12.1, 10.9, 12.1, 13.4, 10.9"

local warnFelShock			= mod:NewSpellAnnounce(242730, 2, nil, false)
local warnRupture			= mod:NewSpellAnnounce(241664, 2)
local warnScale				= mod:NewStackAnnounce(238471, 2)

local specWarnSonicScream	= mod:NewSpecialWarningCast(241687, nil, nil, nil, 1, 2)
local specWarnEarthquake	= mod:NewSpecialWarningSpell(237950, nil, nil, nil, 2, 2)
local specWarnCharge		= mod:NewSpecialWarningYou(100, nil, nil, nil, 1, 2)--Not real spell ID, but closest match
local specWarnFelSurge		= mod:NewSpecialWarningSpell(242496, nil, nil, nil, 1, 2)
local specWarnFelBurst		= mod:NewSpecialWarningSpell(242733, nil, nil, nil, 1, 2)

local timerEarthquakeCD		= mod:NewNextTimer(60, 237950, nil, nil, nil, 2)
local timerFelSurgeCD		= mod:NewCDTimer(25, 242496, nil, nil, nil, 3)--25-33
local timerFelRuptureCD		= mod:NewCDTimer(10.9, 241664, nil, nil, nil, 3)--10.9-13.4
local timerFelBurstCD		= mod:NewCDCountTimer(10.9, 242733, nil, nil, nil, 3)--HIGHLY variable

--local countdownTimer		= mod:NewCountdownFades(10, 141582)

--[[
["242733-Fel Burst"] = "pull:40.2, 23.1, 21.8, 20.7, 21.9, 18.2, 17.7, 19.2, 15.4, 15.8, 14.6, 23.1, 13.3, 12.1, 12.1, 24.3, 10.9, 12.1, 12.1, 19.4",
["242733-Fel Burst"] = "pull:19.0, 23.1, 21.9, 20.6, 20.7, 19.5, 18.2, 24.3, 15.8, 15.8, 14.6, 17.0, 13.4, 12.1",
["242733-Fel Burst"] = "pull:31.6, 23.0, 21.9, 21.8, 21.8, 18.2, 18.2, 24.3, 15.8, 17.0, 14.6, 15.8, 13.3, 12.1",
["242733-Fel Burst"] = "pull:19.5, 23.1, 21.9, 20.7, 19.4, 18.2, 18.2, 29.2, 15.8, 17.0, 26.7, 14.6, 13.3",
["242733-Fel Burst"] = "pull:22.4, 23.1, 21.9, 20.6, 21.9, 18.2, 19.4, 25.5, 15.8, 17.0, 29.2, 13.4, 14.6, 12.2, 22.3, 11.7, 10.9, 12.1, 24.3",
["242733-Fel Burst"] = "pull:25.5, 23.1, 21.9, 21.9, 20.7, 18.2, 18.2, 25.5, 15.8, 15.8, 14.6, 15.8, 13.4",
["242733-Fel Burst"] = "pull:21.4, 23.1, 21.8, 21.8, 20.6, 18.2, 18.2, 24.3, 15.8, 15.8, 14.0, 17.5, 13.3, 12.2, 12.2, 23.1, 13.4, 10.0, 13.1, 26.7, 10.9, 13.3",
["242733-Fel Burst"] = "pull:30.2, 23.1, 21.9, 20.7, 19.4, 18.2, 18.2, 23.1, 15.8, 15.8, 14.6, 13.4, 13.4, 12.2, 12.1, 10.9, 12.1, 13.4, 10.9",
--]]
local felBurstTimers = 	{21.4, 23.1, 21.8, 20.6, 19.4, 18.2, 17.7, 19.2, 15.4, 15.8, 14.0, 13.4, 13.3, 12.2, 12.2, 11.7, 10.9, 10.0, 10.9, 19.4, 10.9, 13.3}
local felburstCount = 0

function mod:OnCombatStart(delay)
	felburstCount = 0
	timerFelRuptureCD:Start(7.5)
	timerEarthquakeCD:Start(20.5)
	timerFelSurgeCD:Start(62)--Correct place to do it?
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 241687 then
		specWarnSonicScream:Show()
		specWarnSonicScream:Play("stopcast")
	elseif spellId == 242496 then--Fel Surge
		specWarnFelSurge:Show()
		specWarnFelSurge:Play("stunsoon")
		timerFelSurgeCD:Start()
	elseif spellId == 242733 then--Fel Burst (DPS)
		felburstCount = felburstCount + 1
		specWarnFelBurst:Show()
		local timer = felBurstTimers[felburstCount+1]
		if timer then
			timerFelBurstCD:Start(timer, felburstCount+1)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 237950 then
		specWarnEarthquake:Show(args.sourceName)
		specWarnEarthquake:Play("aesoon")
		timerEarthquakeCD:Start()
	elseif spellId == 242730 then
		warnFelShock:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 238471 then
		local amount = args.amount or 1
		warnScale:Show(args.destName, amount)
	end
end
mod.SPELL_AURA_REMOVED_DOSE = mod.SPELL_AURA_REMOVED

function mod:UNIT_DIED(args)
	if args.destGUID == UnitGUID("player") then--Solo scenario, a player death is a wipe
		DBM:EndCombat(self, true)
	end
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 117230 then--Tugar Bloodtotem (DPS Fel Totem Fall)
		timerEarthquakeCD:Stop()
		timerFelSurgeCD:Stop()
		timerFelRuptureCD:Stop()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 241664 then--Rupture
		warnRupture:Show()
		timerFelRuptureCD:Start()
	end
end

--"<53.75 21:03:46> [CHAT_MSG_MONSTER_EMOTE] |TInterface\\Icons\\spell_shaman_earthquake:20|t%s readies itself to charge!#Jormog the Behemoth###Kylistà##0#0##0#12#nil#0#false#false#false#false", -- [133]
function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg:find("Interface\\Icons\\spell_shaman_earthquake") then
		specWarnCharge:Show()
		specWarnCharge:Play("charge")
	end
end
