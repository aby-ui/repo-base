local mod	= DBM:NewMod(1838, "DBM-Party-Legion", 11, 860)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20210905144759")
mod:SetCreatureID(114790)
mod:SetEncounterID(2017)
mod:SetUsedIcons(1, 2, 3)
--mod:SetHotfixNoticeRev(14922)
--mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 229151 229083",
	"SPELL_CAST_SUCCESS 229610",
	"SPELL_AURA_APPLIED 229159 229241",
	"SPELL_AURA_REMOVED 229159",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO: Burning Blast Interrupt helper. Figure out CD, then what to do with it
--TODO: figure out what to do with Felguard Sentry (115730)
--ALL
local warnChaoticShadows			= mod:NewTargetAnnounce(229159, 3)
local warnFelBeam					= mod:NewTargetAnnounce(229242, 4)
local warnDisintegrate				= mod:NewSpellAnnounce(229151, 4)--Switch to special warning if target scanning works
local warnPhase2					= mod:NewPhaseAnnounce(2, 2)
local warnPhase3					= mod:NewPhaseAnnounce(3, 2)

--ALL
local specWarnChaoticShadows		= mod:NewSpecialWarningYou(229159, nil, nil, nil, 1, 2)
local yellChaoticShadows			= mod:NewPosYell(229159, DBM_CORE_L.AUTO_YELL_CUSTOM_POSITION2)
local specWarnBurningBlast			= mod:NewSpecialWarningInterruptCount(229083, "HasInterrupt", nil, nil, 1, 2)
--Phase 1
local specWarnFelBeam				= mod:NewSpecialWarningRun(229242, nil, nil, nil, 1, 2)
local yellFelBeam					= mod:NewYell(229242)

--ALL
local timerChaoticShadowsCD			= mod:NewCDTimer(30, 229159, nil, nil, nil, 3)
local timerDisintegrateCD			= mod:NewCDTimer(10.8, 229151, nil, nil, nil, 3)
--Phase 1
local timerFelBeamCD				= mod:NewCDTimer(40, 229242, 219084, nil, nil, 3)
local timerBombardmentCD			= mod:NewCDTimer(25, 229284, 229287, nil, nil, 3)

--local berserkTimer					= mod:NewBerserkTimer(300)

mod:AddSetIconOption("SetIconOnShadows", 229159, true, false, {1, 2, 3})
mod:AddRangeFrameOption(6, 230066)
--mod:AddInfoFrameOption(198108, false)

mod.vb.kickCount = 0
local chaoticShadowsTargets = {}
--local laserWarned = false--What was this for? need to finish this mod one day

local function breakShadows(self)
	warnChaoticShadows:Show(table.concat(chaoticShadowsTargets, "<, >"))
	table.wipe(chaoticShadowsTargets)
end

function mod:OnCombatStart(delay)
	self:SetStage(1)
	self.vb.kickCount = 0
	--laserWarned = false
	table.wipe(chaoticShadowsTargets)
	--These timers seem to vary about 1-2 sec
	timerFelBeamCD:Start(5.2-delay)
	timerDisintegrateCD:Start(10.8-delay)
	timerChaoticShadowsCD:Start(15.5-delay)
	timerBombardmentCD:Start(25.5-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 229151 then
		warnDisintegrate:Show()
		timerDisintegrateCD:Show()
	elseif spellId == 229083 then--Burning Blast
		if self.vb.kickCount == 2 then self.vb.kickCount = 0 end
		self.vb.kickCount = self.vb.kickCount + 1
		local kickCount = self.vb.kickCount
		specWarnBurningBlast:Show(args.sourceName, kickCount)
		if kickCount == 1 then
			specWarnBurningBlast:Play("kick1r")
		elseif kickCount == 2 then
			specWarnBurningBlast:Play("kick2r")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 229610 then--Demonic Portal (both times or just once?)
		self:SetStage(0)
		self.vb.kickCount = 0
		--Cancel stuff
		timerDisintegrateCD:Stop()
		timerChaoticShadowsCD:Stop()
		timerBombardmentCD:Stop()
		if self.vb.phase == 2 then
			warnPhase2:Show()
			timerFelBeamCD:Stop()
			--Variable based on how long it takesto engage boss
			--timerDisintegrateCD:Start(15)--Cast when boss engaged
			timerBombardmentCD:Start(41)
			timerChaoticShadowsCD:Start(45)
		elseif self.vb.phase == 3 then
			warnPhase3:Show()
			--Variable based on how long it takesto engage boss
			timerChaoticShadowsCD:Start(41)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(6)
			end
		end
	elseif spellId == 230084 then--Stabilize Rift
		DBM:Debug("THE RIFT")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 229159 then
		local name = args.destName
		if not tContains(chaoticShadowsTargets, name) then
			chaoticShadowsTargets[#chaoticShadowsTargets+1] = name
		end
		local count = #chaoticShadowsTargets
		self:Unschedule(breakShadows)
		--TODO, when phase detection is working, Improve this
		if count == 3 then
			breakShadows(self)
		else
			self:Schedule(1, breakShadows, self)
		end
		if args:IsPlayer() then
			specWarnChaoticShadows:Show()
			specWarnChaoticShadows:Play("runout")
			yellChaoticShadows:Yell(count, args.spellName, count)
		end
		if self.Options.SetIconOnShadows then
			self:SetIcon(name, count)
		end
	elseif spellId == 229241 then
		timerFelBeamCD:Start()
		if args:IsPlayer() then
			specWarnFelBeam:Show()
			specWarnFelBeam:Play("justrun")
			specWarnFelBeam:ScheduleVoice(1, "keepmove")
		else
			warnFelBeam:Show(args.destName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 229159 then
		if self.Options.SetIconOnShadows then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 229284 then--Bombardment (more reliable than auras, which can be fickle and apply/remove multiple times
		timerBombardmentCD:Start()
	end
end

