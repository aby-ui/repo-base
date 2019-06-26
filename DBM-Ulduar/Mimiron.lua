local mod	= DBM:NewMod("Mimiron", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143403")
mod:SetCreatureID(33432)
mod:SetEncounterID(1138)
mod:DisableESCombatDetection()
mod:SetModelID(28578)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7, 8)

mod:RegisterCombat("combat_yell", L.YellPull)
mod:RegisterCombat("yell", L.YellHardPull)

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 63631 64529 62997 64570 64623",
	"SPELL_CAST_SUCCESS 63027 63414",
	"SPELL_AURA_APPLIED 63666 65026 64529 62997",
	"SPELL_AURA_REMOVED 64529 62997",
	"SPELL_SUMMON 63811",
	"UNIT_SPELLCAST_CHANNEL_STOP boss1 boss2 boss3 boss4",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2 boss3",
	"CHAT_MSG_LOOT"
)

local blastWarn					= mod:NewTargetAnnounce(64529, 4)
local shellWarn					= mod:NewTargetAnnounce(63666, 2)
local lootannounce				= mod:NewAnnounce("MagneticCore", 1, 64444)
local warnBombSpawn				= mod:NewAnnounce("WarnBombSpawn", 3, 63811)
local warnFrostBomb				= mod:NewSpellAnnounce(64623, 3)

local warnShockBlast			= mod:NewSpecialWarningRun(63631, "Melee", nil, nil, 4, 2)
local warnRocketStrike			= mod:NewSpecialWarningDodge(64402, nil, nil, nil, 2, 2)
local warnDarkGlare				= mod:NewSpecialWarningDodge(63293, nil, nil, nil, 3, 2)
local warnPlasmaBlast			= mod:NewSpecialWarningDefensive(64529, nil, nil, nil, 1, 2)

local enrage 					= mod:NewBerserkTimer(900)
local timerHardmode				= mod:NewTimer(610, "TimerHardmode", 64582)
local timerP1toP2				= mod:NewTimer(41.5, "TimeToPhase2", "136116", nil, nil, 6)
local timerP2toP3				= mod:NewTimer(29, "TimeToPhase3", "136116", nil, nil, 6)
local timerP3toP4				= mod:NewTimer(29, "TimeToPhase4", "136116", nil, nil, 6)
local timerProximityMines		= mod:NewCDTimer(30.2, 63027, nil, nil, nil, 3)
local timerShockBlast			= mod:NewCastTimer(4, 63631, nil, nil, nil, 2)
local timerShockBlastCD			= mod:NewCDTimer(35, 63631, nil, nil, nil, 2)
local timerRocketStrikeCD		= mod:NewCDTimer(20, 63631, nil, nil, nil, 3)--20-25
local timerSpinUp				= mod:NewCastTimer(4, 63414, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON)
local timerDarkGlareCast		= mod:NewCastTimer(10, 63274, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON)
local timerNextDarkGlare		= mod:NewNextTimer(48, 63414, nil, nil, nil, 3, nil, DBM_CORE_DEADLY_ICON)
local timerNextShockblast		= mod:NewNextTimer(34, 63631, nil, nil, nil, 2)
local timerPlasmaBlastCD		= mod:NewCDTimer(30, 64529, nil, "Tank", 2, 5)
local timerShell				= mod:NewBuffActiveTimer(6, 63666, nil, "Healer", 2, 5, nil, DBM_CORE_HEALER_ICON)
--local timerNextFlameSuppressant	= mod:NewNextTimer(60, 64570, nil, nil, nil, 3)
local timerFlameSuppressant		= mod:NewBuffActiveTimer(10, 65192, nil, nil, nil, 3)
local timerNextFrostBomb		= mod:NewNextTimer(80, 64623, nil, nil, nil, 3, nil, DBM_CORE_HEROIC_ICON)
local timerBombExplosion		= mod:NewCastTimer(15, 65333, nil, nil, nil, 3)

mod:AddBoolOption("SetIconOnNapalm", false)
mod:AddBoolOption("SetIconOnPlasmaBlast", false)
mod:AddBoolOption("RangeFrame")

mod.vb.hardmode = false
mod.vb.phase = 0
mod.vb.napalmShellIcon = 7
local spinningUp = DBM:GetSpellInfo(63414)
local lastSpinUp = 0
mod.vb.is_spinningUp = false
local napalmShellTargets = {}

local function warnNapalmShellTargets(self)
	shellWarn:Show(table.concat(napalmShellTargets, "<, >"))
	table.wipe(napalmShellTargets)
	self.vb.napalmShellIcon = 7
end

local function show_warning_for_spinup(self)
	if self.vb.is_spinningUp then
		warnDarkGlare:Show()
		warnDarkGlare:Play("watchstep")
		warnDarkGlare:ScheduleVoice(1, "keepmove")
	end
end

function mod:OnCombatStart(delay)
	self.vb.hardmode = false
	enrage:Start(-delay)
	self.vb.phase = 1
	self.vb.is_spinningUp = false
	self.vb.napalmShellIcon = 7
	table.wipe(napalmShellTargets)
	timerPlasmaBlastCD:Start(18-delay)
	timerShockBlastCD:Start(30-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(6)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 63631 then
		warnShockBlast:Show()
		warnShockBlast:Play("runout")
		timerShockBlast:Start()
		timerNextShockblast:Start()
	end
	if args:IsSpellID(64529, 62997) then -- plasma blast
		local tanking, status = UnitDetailedThreatSituation("player", "boss1")--Change boss unitID if it's not boss 1
		if tanking or (status == 3) then
			warnPlasmaBlast:Show()
			warnPlasmaBlast:Play("defensive")
		end
		timerPlasmaBlastCD:Start()
	end
	if args.spellId == 64570 then
		timerFlameSuppressant:Start()
	end
	if args.spellId == 64623 then
		warnFrostBomb:Show()
		timerBombExplosion:Start()
		timerNextFrostBomb:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 63027 then				-- mines
		timerProximityMines:Start()
	elseif args.spellId == 63414 then			-- Spinning UP (before Dark Glare)
		self.vb.is_spinningUp = true
		timerSpinUp:Start()
		timerDarkGlareCast:Schedule(4)
		timerNextDarkGlare:Schedule(14)			-- 4 (cast spinup) + 10 sec (channel)
		DBM:Schedule(0.15, show_warning_for_spinup, self)	-- wait 0.15 and then announce it, otherwise it will sometimes fail
		lastSpinUp = GetTime()
--	elseif args.spellId == 65192 then
--		timerNextFlameSuppressant:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(63666, 65026) and args:IsDestTypePlayer() then -- Napalm Shell
		napalmShellTargets[#napalmShellTargets + 1] = args.destName
		timerShell:Start()
		if self.Options.SetIconOnNapalm then
			self:SetIcon(args.destName, self.vb.napalmShellIcon, 6)
		end
		self.vb.napalmShellIcon = self.vb.napalmShellIcon - 1
		self:Unschedule(warnNapalmShellTargets)
		self:Schedule(0.3, warnNapalmShellTargets, self)
	elseif args:IsSpellID(64529, 62997) then -- Plasma Blast
		blastWarn:Show(args.destName)
		if self.Options.SetIconOnPlasmaBlast then
			self:SetIcon(args.destName, 8, 6)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(63666, 65026) then -- Napalm Shell
		if self.Options.SetIconOnNapalm then
			self:SetIcon(args.destName, 0)
		end
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 63811 then -- Bomb Bot
		warnBombSpawn:Show()
	end
end

function mod:UNIT_SPELLCAST_CHANNEL_STOP(unit, _, spellId)
	local spell = DBM:GetSpellInfo(spellId)--DO BETTER with log
	if spell == spinningUp and GetTime() - lastSpinUp < 3.9 then
		self.vb.is_spinningUp = false
		self:SendSync("SpinUpFail")
	end
end

function mod:CHAT_MSG_LOOT(msg)
	local player, itemID = msg:match(L.LootMsg)
	if player and itemID and tonumber(itemID) == 46029 and self:IsInCombat() then
		player = DBM:GetUnitFullName(player)
		self:SendSync("LootMsg", player)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellHardPull or msg:find(L.YellHardPull) then
		timerHardmode:Start()
		--timerNextFlameSuppressant:Start()
		enrage:Stop()
		self.vb.hardmode = true
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 34098 then--ClearAllDebuffs
		self.vb.phase = self.vb.phase + 1
		if self.vb.phase == 2 then
			timerNextShockblast:Stop()
			timerProximityMines:Stop()
			timerFlameSuppressant:Stop()
			--timerNextFlameSuppressant:Stop()
			timerPlasmaBlastCD:Stop()
			timerP1toP2:Start()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
			timerRocketStrikeCD:Start(63)
			timerNextDarkGlare:Start(78)
			if self.vb.hardmode then
				timerNextFrostBomb:Start(94)
			end
		elseif self.vb.phase == 3 then
			timerDarkGlareCast:Stop()
			timerNextDarkGlare:Stop()
			timerNextFrostBomb:Stop()
			timerRocketStrikeCD:Stop()
			timerP2toP3:Start()
		elseif self.vb.phase == 4 then
			timerP3toP4:Start()
			if self.vb.hardmode then
				timerNextFrostBomb:Start(32)
			end
			timerRocketStrikeCD:Start(50)
			timerNextDarkGlare:Start(59.8)
			timerNextShockblast:Start(81)
		end
	elseif spellId == 64402 or spellId == 65034 then--P2, P4 Rocket Strike
		warnRocketStrike:Show()
		warnRocketStrike:Play("watchstep")
		timerRocketStrikeCD:Start()
	end
end

function mod:OnSync(event, args)
	if event == "SpinUpFail" then
		self.vb.is_spinningUp = false
		timerSpinUp:Cancel()
		timerDarkGlareCast:Cancel()
		timerNextDarkGlare:Cancel()
		warnDarkGlare:Cancel()
	elseif event == "LootMsg" and args and self:AntiSpam(2, 1) then
		lootannounce:Show(args)
	end
end
