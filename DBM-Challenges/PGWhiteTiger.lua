local mod	= DBM:NewMod("d640", "DBM-Challenges", 1, nil, function(t)
	if( GetLocale() == "deDE") then
		return select(2, string.match(t, "(%S+): (%S+.%S+.%S+.%S+)")) -- "Feuerprobe: Tempel des Weißen Tigers QUEST nil"
	else
		return select(2, string.match(t, "(%S+.%S+): (%S+.%S+)")) or select(2, string.match(t, "(%S+.%S+):(%S+.%S+)"))
	end
end)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 105 $"):sub(12, -3))
mod:SetZone()
mod.noStatistics = true

--mod:RegisterCombat("scenario", 1148)

mod:RegisterEvents(
	"SPELL_CAST_START 147601 144374 144106 144401 142189 142238 145200",
	"SPELL_AURA_APPLIED 144383 144404 145206",
	"SPELL_AURA_APPLIED_DOSE 144383",
	"SPELL_CAST_SUCCESS 144084 144091 144088 144086 144087 145260 142838 145198",
	"UNIT_DIED",
	"SCENARIO_UPDATE"
)

--Tank
----Adds spawning
local warnRipperTank		= mod:NewSpellAnnounce(144084, 2, nil, false)--145408 is healer version of mob
local warnFlamecallerTank	= mod:NewSpellAnnounce(144091, 2)--145401 is healer version of mob
local warnWindGuard			= mod:NewSpellAnnounce(144087, 3)
local warnAmbusher			= mod:NewSpellAnnounce(144086, 4)
local warnConquerorTank		= mod:NewSpellAnnounce(144088, 3)--145409 is healer version of mob
----Other Stuff
local warnPyroBlast			= mod:NewCastAnnounce(147601, 3, 3)--Tooltip says 2 but it actually has 3 sec cast
local warnInvokeLava		= mod:NewSpellAnnounce(144374, 3)
local warnWindBlast			= mod:NewSpellAnnounce(144106, 4)--Threat wipe & knockback, must taunt, very important
local warnEnrage			= mod:NewTargetAnnounce(144404, 3)
local warnPowerfulSlam		= mod:NewSpellAnnounce(144401, 4)
--Damager
local warnBanshee			= mod:NewSpellAnnounce(142838, 4)
local warnAmberGlobule		= mod:NewSpellAnnounce(142189, 4)
local warnHealIllusion		= mod:NewCastAnnounce(142238, 4)
--Healer
local warnStinger			= mod:NewSpellAnnounce(145198, 3)
local warnSonicBlast		= mod:NewSpellAnnounce(145200, 3)
local warnAquaBomb			= mod:NewTargetAnnounce(145206, 3)
local warnBurrow			= mod:NewTargetAnnounce(145260, 2)

--Tank
local specWarnPyroBlast		= mod:NewSpecialWarningInterrupt(147601, false)
local specWarnInvokeLava	= mod:NewSpecialWarningSpell(144374, nil, nil, nil, 2)
local specWarnInvokeLavaSIS	= mod:NewSpecialWarningMove(144383)
local specWarnWindBlast		= mod:NewSpecialWarningSpell(144106)
local specWarnAmbusher		= mod:NewSpecialWarningSwitch(144086)
local specWarnPowerfulSlam	= mod:NewSpecialWarningMove(144401)
--Damager
local specWarnAmberGlob		= mod:NewSpecialWarningSpell(142189)
local specWarnHealIllusion	= mod:NewSpecialWarningInterrupt(142238)
local specWarnBanshee		= mod:NewSpecialWarningSwitch(142838)
--Healer
local specWarnStinger		= mod:NewSpecialWarningSpell(145198, false)
local specWarnSonicBlast	= mod:NewSpecialWarningInterrupt(145200, false)--have to be pretty damn fast to interrupt this, off by default and for the very skilled mainly
local specWarnAquaBomb		= mod:NewSpecialWarningTarget(145206)--It's cast too often to dispel them off, so it's better as a target warning.

--Tank
local timerWindBlastCD		= mod:NewNextTimer(21, 144106, nil, nil, nil, 5)
local timerPowerfulSlamCD	= mod:NewCDTimer(15, 144401, nil, nil, nil, 3)--15-17sec variation
--Damager
local timerAmberGlobCD		= mod:NewNextTimer(10.5, 142189, nil, nil, nil, 5)
local timerHealIllusionCD	= mod:NewNextTimer(20, 142238, nil, nil, nil, 4)
--Healer
local timerAquaBombCD		= mod:NewCDTimer(12, 145206, nil, false, nil, 5)--12-22 second variation? off by default do to this
local timerSonicBlastCD		= mod:NewCDTimer(6, 145200, nil, nil, nil, 2)--8-11sec variation

local countdownTimer		= mod:NewCountdownFades(10, 141582)

local started = false

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 147601 then
		warnPyroBlast:Show()
		specWarnPyroBlast:Show(args.sourceName)
	elseif spellId == 144374 then
		warnInvokeLava:Show()
		specWarnInvokeLava:Show()
	elseif spellId == 144106 and self:AntiSpam(2.5, 2) then
		warnWindBlast:Show()
		specWarnWindBlast:Show()
		timerWindBlastCD:Start(args.sourceGUID)
	elseif spellId == 144401 and self:AntiSpam(2.5, 3) then
		warnPowerfulSlam:Show()
		specWarnPowerfulSlam:Show()
		timerPowerfulSlamCD:Start(args.sourceGUID)
		specWarnPowerfulSlam:Play("shockwave")
	elseif spellId == 142189 then
		warnAmberGlobule:Show()
		specWarnAmberGlob:Show()
		timerAmberGlobCD:Start(args.sourceGUID)
	elseif spellId == 142238 then
		warnHealIllusion:Show()
		specWarnHealIllusion:Show(args.sourceName)
		timerHealIllusionCD:Start(args.sourceGUID)
		specWarnHealIllusion:Play("kickcast")
	elseif spellId == 145200 then
		warnSonicBlast:Show()
		specWarnSonicBlast:Show(args.sourceName)
		timerSonicBlastCD:Start(args.sourceGUID)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 144383 and args:IsPlayer() and self:AntiSpam(1.5, 1) then
		specWarnInvokeLavaSIS:Show()
	elseif spellId == 144404 then
		warnEnrage:Show(args.destName)
	elseif spellId == 145206 then
		warnAquaBomb:Show(args.destName)
		specWarnAquaBomb:Show(args.destName)
		timerAquaBombCD:Start(args.sourceGUID)
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

--[[
--new Damager adds (at this time not worth adding that i can see. They don't spawn mid round like tank ones, they all spawn at wave start)
"<41.9 18:54:22> [CLEU] SPELL_CAST_SUCCESS#false#0xF131159C00001436#Large Illusionary Amber-Weaver#2632#0##nil#-2147483648#-2147483648#142835#Illusionary Amber-Weaver#1", -- [273]
"<41.9 18:54:22> [CLEU] SPELL_CAST_SUCCESS#false#0xF13116F600001437#Large Illusionary Banana-Tosser#2632#0##nil#-2147483648#-2147483648#142839#Illusionary Banana-Tosser#1", -- [274]
"<76.9 18:54:57> [CLEU] SPELL_CAST_SUCCESS#false#0xF13115A400001499#Small Illusionary Mystic#2632#0##nil#-2147483648#-2147483648#142833#Illusionary Mystic#1", -- [569]
--New Healer Adds
"<48.7 18:00:50> [CLEU] SPELL_CAST_SUCCESS#false#0xF1311A90000005B9#Small Illusionary Ripper#2632#0##nil#-2147483648#-2147483648#145408#Illusionary Ripper#1", -- [1183]
"<3.6 18:00:05> [CLEU] SPELL_CAST_SUCCESS#false#0xF1311A960000057D#Small Illusionary Hive-Singer#2632#0##nil#-2147483648#-2147483648#145198#Illusionary Hive-Singer#1", -- [96]
"<3.6 18:00:05> [CLEU] SPELL_CAST_SUCCESS#false#0xF1311A980000057E#Small Illusionary Aqualyte#2632#0##nil#-2147483648#-2147483648#145204#Illusionary Aqualyte#1", -- [97]
"<48.7 18:00:50> [CLEU] SPELL_CAST_SUCCESS#false#0xF1311AC2000005B8#Unknown#2632#0##nil#-2147483648#-2147483648#145258#Illusionary Tunneler#1", -- [1182]
"<208.5 18:03:30> [CLEU] SPELL_CAST_SUCCESS#false#0xF1311A9400000647#Unknown#2632#0##nil#-2147483648#-2147483648#145409#Illusionary Conqueror#1", -- [5867]
"<328.4 18:05:29> [CLEU] SPELL_CAST_SUCCESS#false#0xF1311A93000006C8#Large Illusionary Flamecaller#2632#0##nil#-2147483648#-2147483648#145401#Illusionary Flamecaller#1", -- [9132]
--]]
function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 144084 and self:AntiSpam(2, 4) then
		warnRipperTank:Show()
	elseif spellId == 144091 and self:AntiSpam(2, 10) then
		warnFlamecallerTank:Show()
	elseif spellId == 144088 and self:AntiSpam(2, 5) then
		warnConquerorTank:Show()
	elseif spellId == 144086 and self:AntiSpam(2, 6) then
		warnAmbusher:Show()
		specWarnAmbusher:Show()
	elseif spellId == 144087 and self:AntiSpam(2, 7) then
		warnWindGuard:Show()
	elseif spellId == 145260 and self:AntiSpam(2, 8) then
		warnBurrow:Show(args.destName)
	elseif spellId == 142838 and self:AntiSpam(2, 9) then
		warnBanshee:Show()
		specWarnBanshee:Show()
	elseif spellId == 145198 and self:AntiSpam(2, 11) then
		warnStinger:Show()
		specWarnStinger:Show()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 71076 or cid == 71069 then--Illusionary Mystic
		timerHealIllusionCD:Cancel(args.destGUID)
	elseif cid == 71077 or cid == 71068 then--Illusionary Amber-Weave
		timerAmberGlobCD:Cancel(args.destGUID)
	elseif cid == 71834 or cid == 71833 then--Illusionary Wind-Guard
		timerWindBlastCD:Cancel(args.destGUID)
	elseif cid == 71842 or cid == 71841 then--Illusionary Conqueror (Tank version of mob)
		timerPowerfulSlamCD:Cancel(args.destGUID)
	elseif cid == 72344 or cid == 72346 then--Illusionary Aqualyte
		timerAquaBombCD:Cancel(args.destGUID)
	elseif cid == 72342 or cid == 72343 then--Illusionary Hive-Singer
		timerSonicBlastCD:Cancel(args.destGUID)
	end
end

function mod:SCENARIO_UPDATE(newStep)
	local diffID, currWave, maxWave, duration = C_Scenario.GetProvingGroundsInfo()
	if diffID > 0 then
		started = true
		countdownTimer:Cancel()
		countdownTimer:Start(duration)
		if DBM.Options.AutoRespond then--Use global whisper option
			self:RegisterShortTermEvents(
				"CHAT_MSG_WHISPER"
			)
		end
	elseif started then
		started = false
		countdownTimer:Cancel()
		self:UnregisterShortTermEvents()
	end
end

do
	local mode = {
		[1] = CHALLENGE_MODE_MEDAL1,
		[2] = CHALLENGE_MODE_MEDAL2,
		[3] = CHALLENGE_MODE_MEDAL3,
		[4] = L.Endless,
	}
	function mod:CHAT_MSG_WHISPER(msg, name, _, _, _, status)
		if status ~= "GM" then--Filter GMs
			name = Ambiguate(name, "none")
			local diffID, currWave, maxWave, duration = C_Scenario.GetProvingGroundsInfo()
			local message = L.ReplyWhisper:format(UnitName("player"), mode[diffID], currWave)
			if msg == "status" then
				SendChatMessage(message, "WHISPER", nil, name)
			elseif self:AntiSpam(20, name) then--If not "status" then auto respond only once per 20 seconds per person.
				SendChatMessage(message, "WHISPER", nil, name)
			end
		end
	end
end
