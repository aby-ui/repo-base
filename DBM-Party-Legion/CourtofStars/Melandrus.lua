local mod	= DBM:NewMod(1720, "DBM-Party-Legion", 7, 800)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20230101033858")
mod:SetCreatureID(104218)
mod:SetEncounterID(1870)
mod:SetHotfixNoticeRev(20221127000000)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 209602 209676 209628"
)
mod:RegisterEvents(
	"CHAT_MSG_MONSTER_SAY"
)

--[[
(ability.id = 209602 or ability.id = 209676 or ability.id = 209628) and type = "begincast"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
local warnSurge						= mod:NewTargetAnnounce(209602, 4)

local specWarnSurge					= mod:NewSpecialWarningYou(209602, nil, nil, nil, 1, 2)
local yellSurge						= mod:NewYell(209602)
local specWarnSlicingMaelstrom		= mod:NewSpecialWarningSpell(209676, nil, nil, nil, 2, 2)
local specWarnGale					= mod:NewSpecialWarningDodge(209628, nil, nil, nil, 2, 2)

local timerRP						= mod:NewRPTimer(32.9)
local timerSurgeCD					= mod:NewCDTimer(12.1, 209602, nil, nil, nil, 3)
local timerMaelstromCD				= mod:NewCDCountTimer(24.2, 209676, nil, nil, nil, 3)
local timerGaleCD					= mod:NewCDTimer(23.8, 209628, nil, nil, nil, 2)

local trashmod = DBM:GetModByName("CoSTrash")
mod.vb.slicingMaelstromCount = 0

function mod:SurgeTarget(targetname, uId)
	if not targetname then
		warnSurge:Show(DBM_COMMON_L.UNKNOWN)
		return
	end
	if targetname == UnitName("player") then
		specWarnSurge:Show()
		specWarnSurge:Play("targetyou")
		yellSurge:Yell()
	else
		warnSurge:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.slicingMaelstromCount = 0
	timerSurgeCD:Start(5-delay)
	timerGaleCD:Start(10-delay)--10
	timerMaelstromCD:Start(22-delay, 1)
	--Not ideal to do every pull, but cleanest way to ensure it's done
	if not trashmod then
		trashmod = DBM:GetModByName("CoSTrash")
	end
	if trashmod and trashmod.Options.SpyHelper then
		trashmod:ResetGossipState()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 209602 then
		timerSurgeCD:Start()
		self:BossTargetScanner(104218, "SurgeTarget", 0.1, 16, true, nil, nil, nil, true)
	elseif spellId == 209676 then
		self.vb.slicingMaelstromCount = self.vb.slicingMaelstromCount + 1
		specWarnSlicingMaelstrom:Show()
		specWarnSlicingMaelstrom:Play("aesoon")
		timerMaelstromCD:Start(24.2, self.vb.slicingMaelstromCount+1)
	elseif spellId == 209628 and self:AntiSpam(5, 1) then
		specWarnGale:Show()
		specWarnGale:Play("watchstep")
		timerGaleCD:Start()
	end
end

--"<13.69 20:34:35> [CHAT_MSG_MONSTER_SAY] Must you leave so soon, Grand Magistrix?#Advisor Melandrus###Omegal##0#0##0#343#nil#0#false#false#false#false", -- [4]
--"<46.59 20:35:08> [ENCOUNTER_START] 1870#Advisor Melandrus#23#5", -- [18]
function mod:CHAT_MSG_MONSTER_SAY(msg)
	if (msg == L.MelRP or msg:find(L.MelRP)) then
		self:SendSync("MelRP")--Syncing to help unlocalized clients
	end
end

function mod:OnSync(msg)
	if msg == "MelRP" and self:AntiSpam(10, 2) then
		timerRP:Start()
	end
end
