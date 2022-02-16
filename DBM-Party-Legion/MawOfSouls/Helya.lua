local mod	= DBM:NewMod(1663, "DBM-Party-Legion", 8, 727)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
mod:SetCreatureID(96759)
mod:SetEncounterID(1824)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 227233 202088 198495",
	"SPELL_AURA_APPLIED 196947 197262",
	"SPELL_AURA_REMOVED 196947",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

local warnTaintofSea					= mod:NewTargetAnnounce(197262, 2, nil, false)
local warnSubmerged						= mod:NewTargetAnnounce(196947, 2)

local specWarnDestructorTentacle		= mod:NewSpecialWarningSwitch("ej12364", "Tank")
local specWarnBrackwaterBarrage			= mod:NewSpecialWarningDodge(202088, "-Tank", nil, nil, 2, 2)--Tank stays with destructor tentacle no matter what
local specWarnSubmergedOver				= mod:NewSpecialWarningEnd(196947)
local specWarnBreath					= mod:NewSpecialWarningDodge(227233, nil, nil, nil, 2, 2)
local specWarnTorrent					= mod:NewSpecialWarningInterrupt(198495, "HasInterrupt", nil, nil, 1, 2)

local timerTaintofSeaCD					= mod:NewCDTimer(12, 197262, nil, false, nil, 3)
local timerPiercingTentacleCD			= mod:NewNextTimer(9, 197596, nil, nil, nil, 3)
--local timerDestructorTentacleCD		= mod:NewCDTimer(26, "ej12364", nil, nil, nil, 1)--More data
local timerSubmerged					= mod:NewBuffFadesTimer(15, 196947, nil, nil, nil, 6)
local timerBreathCD						= mod:NewNextTimer(22, 227233, nil, nil, nil, 3, nil, nil, nil, 1, 4)
local timerTorrentCD					= mod:NewCDTimer(9.7, 198495, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)--often delayed and after breath so often will see 12-14

function mod:OnCombatStart(delay)
	self:SetStage(1)
	timerPiercingTentacleCD:Start(8.5)
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 227233 then
		specWarnBreath:Show()
		specWarnBreath:Play("breathsoon")
		timerBreathCD:Start()
	elseif spellId == 202088 then
		specWarnBrackwaterBarrage:Show()
		specWarnBrackwaterBarrage:Play("breathsoon")
		--timerBreathCD:Start()
	elseif spellId == 198495 then
		timerTorrentCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnTorrent:Show(args.sourceName)
			specWarnTorrent:Play("kickcast")
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 196947 then
		timerPiercingTentacleCD:Stop()
		timerTaintofSeaCD:Stop()
		timerBreathCD:Stop()
		timerTorrentCD:Stop()
		warnSubmerged:Show(args.destName)
		timerSubmerged:Start()
		if self.vb.phase == 1 then
			self:SetStage(2)
		end
	elseif spellId == 197262 then
		warnTaintofSea:Show(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 196947 then
		timerTorrentCD:Start(5)
		specWarnSubmergedOver:Show()
		timerBreathCD:Start(15)
	end
end

--"<50.03 00:13:36> [CHAT_MSG_RAID_BOSS_EMOTE] |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges!#Destructor Tentacle###Destructor Tentacle##0#0##0#257#nil#0#false#false#false#false"
function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find("inv_misc_monsterhorn_03") then
		specWarnDestructorTentacle:Show()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 197596 then--Piercing Tentacle
		if self.vb.phase == 1 then
			timerPiercingTentacleCD:Start()
		else
			timerPiercingTentacleCD:Start(6)
		end
	end
end
