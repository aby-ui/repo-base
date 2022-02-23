local mod	= DBM:NewMod(2170, "DBM-Party-BfA", 3, 1041)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220217031102")
mod:SetCreatureID(135475, 135470, 135472)
mod:SetEncounterID(2140)
mod:SetUsedIcons(1, 2)
mod:SetBossHPInfoToHighest()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 267256 266231",
	"SPELL_AURA_REMOVED 267256 266231",
	"SPELL_CAST_START 266206 266951 266237 267273 267060",
	"SPELL_CAST_SUCCESS 266231",
	"UNIT_DIED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3",
	"UNIT_TARGETABLE_CHANGED boss1 boss2 boss3"
)

--TODO, finish accurate detection of who starts fight, and bosses swapping in and out.
--TODO, I believe the inactive bosses assisting is health based off the enabled boss, so timers only work for ACTIVE boss.
--[[
(ability.id = 266206 or ability.id = 266951 or ability.id = 266237 or ability.id = 267273 or ability.id = 267060) and type = "begincast"
 or ability.id = 266231 and type = "cast"
--]]
--Kula the Butcher
mod:AddTimerLine(DBM:EJ_GetSectionInfo(18261))
local warnSeveringAxe				= mod:NewTargetNoFilterAnnounce(266231, 3, nil, "Healer")

local specWarnWhirlingAxes			= mod:NewSpecialWarningDodge(266206, nil, nil, nil, 2, 2)
local specWarnSeveringAxe			= mod:NewSpecialWarningDefensive(266231, nil, nil, nil, 1, 2)

local timerWhirlingAxesCD			= mod:NewCDTimer(10.8, 266206, nil, nil, nil, 3)--Used inactive
local timerSeveringAxeCD			= mod:NewCDTimer(21.8, 266231, nil, nil, nil, 3)

mod:AddSetIconOption("SetIconOnAxe", 266231, false, false, {2})
--Aka'ali the Conqueror
mod:AddTimerLine(DBM:EJ_GetSectionInfo(18264))
local specWarnBarrelThrough			= mod:NewSpecialWarningYou(266951, nil, nil, nil, 1, 2)
local yellBarrelThrough				= mod:NewYell(266951)
local yellBarrelThroughFades		= mod:NewShortFadesYell(266951)
local specWarnBarrelThroughSoak		= mod:NewSpecialWarningMoveTo(266951, nil, nil, nil, 1, 2)
local specWarnDebilitatingBackhand	= mod:NewSpecialWarningRun(266237, nil, nil, nil, 4, 2)

local timerBarrelThroughCD			= mod:NewCDTimer(23, 266951, nil, nil, nil, 3)--Used inactive
local timerDebilitatingBackhandCD	= mod:NewCDTimer(22.8, 266237, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON..DBM_COMMON_L.DEADLY_ICON)

mod:AddSetIconOption("SetIconOnBarrel", 266951, true, false, {1})
--Zanazal the Wise
mod:AddTimerLine(DBM:EJ_GetSectionInfo(18267))
local specWarnPoisonNova			= mod:NewSpecialWarningInterrupt(267273, "HasInterrupt", nil, nil, 1, 2)
local specWarnTotems				= mod:NewSpecialWarningSwitch(267060, nil, nil, nil, 1, 2)
local specWarnEarthwall				= mod:NewSpecialWarningDispel(267256, "MagicDispeller", nil, nil, 1, 2)

local timerPoisonNovaCD				= mod:NewCDTimer(26.7, 267273, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)--Used inactive
local timerTotemsCD					= mod:NewCDTimer(53.5, 267060, nil, nil, nil, 1, nil, DBM_COMMON_L.DAMAGE_ICON)--Actual timer needs doing

mod.vb.bossOne = 0
mod.vb.bossTwo = 0
mod.vb.earthTotemActive = false
mod.vb.bossName = "nil"

--Engage Timers
local function whoDat(self, delay)
	for i = 1, 3 do--Might actually only need to check boss 1
		local bossUID = "boss"..i
		if UnitCanAttack("player", bossUID) then
			local cid = self:GetUnitCreatureId(bossUID)
			if cid == 135475 then -- Kula the Butcher
				timerWhirlingAxesCD:Start(6-delay)
				timerSeveringAxeCD:Start(22.2-delay)--SUCCESS
			elseif cid == 135470 then -- Aka'ali the Conqueror
				--timerBarrelThroughCD:Start(1-delay)
				--timerDebilitatingBackhandCD:Start(1-delay)
			elseif cid == 135472 then -- Zanazal the Wise
				timerPoisonNovaCD:Start(8.8-delay)
				timerTotemsCD:Start(23.5-delay)
			end
		end
	end
end

function mod:OnCombatStart(delay)
	self:SetStage(1)
	self.vb.bossOne = 0
	self.vb.bossTwo = 0
	self.vb.bossName = "nil"
	self.vb.earthTotemActive = false
	self:Schedule(2, whoDat, self, delay)
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 267256 and not self.vb.earthTotemActive and not args:IsDestTypePlayer() then
		specWarnEarthwall:Show(args.destName)
		specWarnEarthwall:Play("dispelboss")
		self.vb.bossName = args.destName
	elseif spellId == 266231 then
		if args:IsPlayer() then
			specWarnSeveringAxe:Show()
			specWarnSeveringAxe:Play("defensive")
		else
			warnSeveringAxe:Show(args.destName)
		end
		if self.Options.SetIconOnAxe then
			self:SetIcon(args.destName, 2)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 267256  then
		self.vb.bossName = "nil"
	elseif spellId == 266231 then
		if self.Options.SetIconOnAxe then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 266206 then
		specWarnWhirlingAxes:Show()
		specWarnWhirlingAxes:Play("watchstep")
		local cid = self:GetCIDFromGUID(args.sourceGUID)
		if cid ~= self.vb.bossOne and cid ~= self.vb.bossTwo then
			timerWhirlingAxesCD:Start()
		end
	elseif spellId == 266951 then
		local cid = self:GetCIDFromGUID(args.sourceGUID)
		if cid ~= self.vb.bossOne and cid ~= self.vb.bossTwo then
			timerBarrelThroughCD:Start()
		end
	elseif spellId == 266237 then
		if self:IsTanking("player", "boss1", nil, true) then
			specWarnDebilitatingBackhand:Show()
			specWarnDebilitatingBackhand:Play("justrun")
			--specWarnDebilitatingBackhand:ScheduleVoice(3.5, "justrun")
		end
		timerDebilitatingBackhandCD:Start()
	elseif spellId == 267273 then
		if self:CheckInterruptFilter(args.sourceGUID, false, true, true) then
			specWarnPoisonNova:Show(args.sourceName)
			specWarnPoisonNova:Play("kickcast")
		end
		local cid = self:GetCIDFromGUID(args.sourceGUID)
		if cid ~= self.vb.bossOne and cid ~= self.vb.bossTwo then
			timerPoisonNovaCD:Start(26.7)
		end
	elseif spellId == 267060 then
		self.vb.earthTotemActive = true
		specWarnTotems:Show()
		specWarnTotems:Play("changetarget")
		local cid = self:GetCIDFromGUID(args.sourceGUID)
		if cid ~= self.vb.bossOne and cid ~= self.vb.bossTwo then
			timerTotemsCD:Start(53.5)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 266231 then
		timerSeveringAxeCD:Start(21.8)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 135759 then--Earth Totem
		self.vb.earthTotemActive = false
		if self.vb.bossName ~= "nil" then
			specWarnEarthwall:Show(self.vb.bossName)
			specWarnEarthwall:Play("dispelboss")
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:find("spell:266951") then
		local targetname = DBM:GetUnitFullName(target)
		if targetname then
			if targetname == UnitName("player") then
				specWarnBarrelThrough:Show()
				specWarnBarrelThrough:Play("targetyou")
				yellBarrelThrough:Yell()
				yellBarrelThroughFades:Countdown(8)
			else
				specWarnBarrelThroughSoak:Show(targetname)
				specWarnBarrelThroughSoak:Play("gathershare")
			end
			if self.Options.SetIconOnBarrel then
				self:SetIcon(targetname, 1, 8)
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 34098 and self:AntiSpam(3, uId) then--ClearAllDebuffs (sometimes fires twice, so antispam needed)
		timerWhirlingAxesCD:Stop()
		timerBarrelThroughCD:Stop()
		timerDebilitatingBackhandCD:Stop()
		timerPoisonNovaCD:Stop()
		timerTotemsCD:Stop()
		self:SetStage(0)
		local cid = self:GetUnitCreatureId(uId)
		if self.vb.phase == 2 then
			self.vb.bossOne = cid
			--Start Boss 1 Timer (17sec)
			if cid == 135475 then -- Kula the Butcher
			--	timerWhirlingAxesCD:Start(17)
			elseif cid == 135470 then -- Aka'ali the Conqueror
			--	timerBarrelThroughCD:Start(17)
			elseif cid == 135472 then -- Zanazal the Wise
			--	timerPoisonNovaCD:Start(17)
			end
		else
			self.vb.bossTwo = cid
		end
	end
end

--2nd and 3rd Boss timers
function mod:UNIT_TARGETABLE_CHANGED(uId)
	if UnitCanAttack("player", uId) then
		local cid = self:GetUnitCreatureId(uId)
		if cid == 135475 then -- Kula the Butcher
			timerWhirlingAxesCD:Start(8)
			timerSeveringAxeCD:Start(22.2)
		elseif cid == 135470 then -- Aka'ali the Conqueror
			timerBarrelThroughCD:Start(6)
			timerDebilitatingBackhandCD:Start(15.7)
		elseif cid == 135472 then -- Zanazal the Wise
			timerPoisonNovaCD:Start(18.1)
			timerTotemsCD:Start(19.2)
		end
	end
end
