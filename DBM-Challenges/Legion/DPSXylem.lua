local mod	= DBM:NewMod("ArtifactXylem", "DBM-Challenges", 3)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,timewalker"

mod:SetRevision("20211226024315")
mod:SetCreatureID(115244, 116839)
mod:SetBossHPInfoToHighest()
mod.soloChallenge = true

mod:RegisterCombat("combat")
mod:SetWipeTime(30)--Prevent intermission to stage 2 causing mod to think it wipes since wipe check would detect no combat and no boss1

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 234728",
	"SPELL_AURA_APPLIED 231443 233248",
--	"SPELL_AURA_APPLIED_DOSE",
--	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS 232661 231522",
	"SPELL_PERIODIC_DAMAGE 232672",
	"SPELL_PERIODIC_MISSED 232672",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_SPELLCAST_STOP boss1",
	"INSTANCE_ENCOUNTER_ENGAGE_UNIT"
)
--Notes:
--TODO, more timer work/data.
--Frost Phase
local warnFrostPhase				= mod:NewSpellAnnounce(242394, 2)
--Arcane Phase
local warnArcanePhase				= mod:NewSpellAnnounce(242386, 2)

--Frost Phase
local specWarnRazorIce				= mod:NewSpecialWarningDodge(232661, nil, nil, nil, 1, 2)
--Transition
local specWarnArcaneAnnihilation	= mod:NewSpecialWarningInterrupt(234728, nil, nil, nil, 1, 2)
--Arcane Phase
local specWarnShadowBarrage			= mod:NewSpecialWarningDodge(231443, nil, nil, nil, 2, 2)
local specWarnDrawPower				= mod:NewSpecialWarningInterrupt(231522, nil, nil, nil, 1, 2)
--Phase 2
local specWarnSeeds					= mod:NewSpecialWarningRun(233248, nil, nil, nil, 4, 2)
local specWarnGTFO					= mod:NewSpecialWarningGTFO(232672, nil, nil, nil, 1, 8)

--Frost Phase
local timerRazorIceCD				= mod:NewCDTimer(25.5, 232661, nil, nil, nil, 3)--25.5-38.9 (other casts can delay it a lot)
--Transition
local timerArcaneAnnihilationCD		= mod:NewNextTimer(5, 234728, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerArcaneAnnihilation		= mod:NewCastTimer(40, 234728, nil, nil, nil, 6)
local timerShadowBarrageCD			= mod:NewCDTimer(40.0, 231443, nil, nil, nil, 3)--Actually used both phases
--Arcane Phase
local timerDrawPowerCD				= mod:NewCDTimer(18.2, 231522, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
--Phase 2
local timerSeedsCD					= mod:NewCDTimer(65.6, 233248, nil, nil, nil, 3)
local timerDarknessWithin	 		= mod:NewAddsTimer(8, 158830)

local activeBossGUIDS = {}

function mod:OnCombatStart(delay)
	self:SetStage(1)
	timerRazorIceCD:Start(12-delay)
	self.vb.bossLeft = 2
	self.numBoss = 2
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 234728 then
		specWarnArcaneAnnihilation:Show(args.sourceName)
		specWarnArcaneAnnihilation:Play("kickcast")
		timerArcaneAnnihilation:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 232661 then
		specWarnRazorIce:Show()
		specWarnRazorIce:Play("watchstep")
		timerRazorIceCD:Start()
	elseif spellId == 231522 then
		specWarnDrawPower:Show(args.sourceName)
		specWarnDrawPower:Play("kickcast")
		timerDrawPowerCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 231443 then
		specWarnShadowBarrage:Show()
		specWarnShadowBarrage:Play("watchorb")
		timerShadowBarrageCD:Start()
	elseif spellId == 233248 and args:IsPlayer() then
		specWarnSeeds:Show()
		specWarnSeeds:Play("runout")
		timerDarknessWithin:Start()
		timerSeedsCD:Start()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 232672 and destGUID == UnitGUID("player") and not self:AntiSpam(2, 1) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_DIED(args)
	if args.destGUID == UnitGUID("player") then--Solo scenario, a player death is a wipe
		DBM:EndCombat(self, true)
	end
	local cid = self:GetCIDFromGUID(args.destGUID)
	--Needs manual death caller since internal handler in core expects both bosses to die (they don't)
	if cid == 116839 then--Corrupting Shadows
		DBM:EndCombat(self)--Win
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 242394 then--Frost Phase
		timerDrawPowerCD:Stop()
		warnFrostPhase:Show()
		timerArcaneAnnihilationCD:Start()
		timerRazorIceCD:Start(20)--20-33
	elseif spellId == 242386 then--Arcane Phase
		warnArcanePhase:Show()
		timerRazorIceCD:Stop()
		timerArcaneAnnihilationCD:Start()
		--timerShadowBarrageCD:Start(11)--Not consistent
		timerDrawPowerCD:Start(27)--27-42 (also not very consistent)
--	elseif spellId == 164393 then--Cancel Channeling (Successfully interrupted Arcane Annihilation)

	end
end

function mod:UNIT_SPELLCAST_STOP(uId, _, spellId)
	if spellId == 234728 then
		timerArcaneAnnihilation:Stop()
	end
end

--"<315.20 14:53:40> [DBM_Debug] CHAT_MSG_MONSTER_YELL from Archmage Xylem while looking at #2", -- [1170]
--"<315.20 14:53:40> [CHAT_MSG_MONSTER_YELL] No... this is not right!#Archmage Xylem#####0#0##0#50#nil#0#false#false#false#false", -- [1171]
--"<316.41 14:53:41> [INSTANCE_ENCOUNTER_ENGAGE_UNIT] Fake Args:#boss1#false#false#false#??#nil#normal#0#boss2#false#false#false#??#nil#normal#0#boss3#false#false#false#??#nil#normal#0#boss4#false#false#false#??#nil#normal#0#boss5#false#false#false#??#nil#normal#0#Real Args:", -- [1172]
--"<316.41 14:53:41> [IsEncounterInProgress()] false", -- [1173]
--"<316.41 14:53:41> [IsEncounterSuppressingRelease()] false", -- [1174]
--"<322.07 14:53:47> [PLAYER_REGEN_ENABLED] -Leaving combat!", -- [1175]
--"<336.62 14:54:01> [CHAT_MSG_MONSTER_YELL] You cannot defy the will of the Legion, Archmage. All will perish!#Corrupting Shadows###Archmage Xylem##0#0##0#57#nil#0#false#false#false#false", -- [1191]
--"<338.89 14:54:04> [PLAYER_TARGET_CHANGED] 47 Hostile (elite Elemental) - Corrupting Shadows # Creature-0-3134-1673-4814-116839-000036532A", -- [1192]
--"<344.29 14:54:09> [CHAT_MSG_MONSTER_YELL] Hold them off! For the sake of Azeroth!#Archmage Xylem#####0#0##0#58#nil#0#false#false#false#false", -- [1193]
--"<345.10 14:54:10> [INSTANCE_ENCOUNTER_ENGAGE_UNIT] Fake Args:#boss1#true#true#true#Corrupting Shadows#Creature-0-3134-1673-4814-116839-000036532A#elite#172432#boss2#false#false#false#??#nil#normal#0#boss3#false#false#false#??#nil#normal#0#boss4#false#false#false#??#nil#normal#0#boss5#false#false#false#??#nil#normal#0#Real Args:", -- [1194]
--"<345.10 14:54:10> [PLAYER_REGEN_DISABLED] +Entering combat!", -- [1196]
function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	--First Boss defeated and removed from boss frames
	if self.vb.phase == 1 and not UnitExists("boss1") then
		self:SetStage(1.5)
		self.vb.bossLeft = 1
		timerDrawPowerCD:Stop()
		timerArcaneAnnihilationCD:Stop()
		timerArcaneAnnihilation:Stop()
		timerShadowBarrageCD:Stop()
		timerRazorIceCD:Stop()
	--Second Boss engaging and added to boss frames
	elseif self.vb.phase == 1.5 and UnitExists("boss1") then
		local GUID = UnitGUID("boss1")
		local cid = self:GetCIDFromGUID(GUID)
		if cid == 116839 then--Still verify it to make sure
			self:SetStage(2)
			timerSeedsCD:Start(20.5)
		end
	end
end
