local mod	= DBM:NewMod(827, "DBM-ThroneofThunder", nil, 362)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143417")
mod:SetCreatureID(69465)
mod:SetEncounterID(1577)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 137399 137313 138732",
	"SPELL_CAST_SUCCESS 137162",
	"SPELL_AURA_APPLIED 137162 137422 138732",
	"SPELL_AURA_REMOVED 138732 137422 137313",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnFocusedLightning			= mod:NewTargetAnnounce(137399, 4)
local warnStaticBurst				= mod:NewTargetAnnounce(137162, 3, nil, "Tank|Healer")
local warnThrow						= mod:NewTargetAnnounce(137175, 2)

local specWarnFocusedLightning		= mod:NewSpecialWarningRun(137422, nil, nil, 2, 4)
local yellFocusedLightning			= mod:NewYell(137422)
local specWarnStaticBurst			= mod:NewSpecialWarningYou(137162)
local specWarnStaticBurstOther		= mod:NewSpecialWarningTaunt(137162)
local specWarnThrow					= mod:NewSpecialWarningYou(137175)
local specWarnThrowOther			= mod:NewSpecialWarningTaunt(137175)
local specWarnWaterMove				= mod:NewSpecialWarning("specWarnWaterMove")
local specWarnStorm					= mod:NewSpecialWarningSpell(137313, nil, nil, nil, 2)
local specWarnElectrifiedWaters		= mod:NewSpecialWarningMove(138006)
local specWarnIonization			= mod:NewSpecialWarningSpell(138732, "-Tank", nil, nil, 2)

local timerFocusedLightningCD		= mod:NewCDTimer(10, 137399, nil, nil, nil, 3)--10-18 second variation, tends to lean toward 11-12 except when delayed by other casts such as throw or storm. Pull one also seems to variate highly
local timerStaticBurstCD			= mod:NewCDTimer(19, 137162, nil, "Tank", nil, 5)
local timerThrowCD					= mod:NewCDTimer(26, 137175, nil, nil, nil, 5)--90-93 variable (26-30 seconds after storm. verified in well over 50 logs)
local timerStorm					= mod:NewBuffActiveTimer(17, 137313)--2 second cast, 15 second duration
local timerStormCD					= mod:NewCDTimer(60.5, 137313, nil, nil, nil, 2)--90-93 variable (60.5~67 seconds after throw)
local timerIonization				= mod:NewBuffFadesTimer(24, 138732)
local timerIonizationCD				= mod:NewNextTimer(61.5, 138732, nil, nil, nil, 3, nil, nil, nil, 1, 4)

local berserkTimer					= mod:NewBerserkTimer(540)

mod:AddBoolOption("RangeFrame")

local scanFailed = false
local ionization, stormDebuff, Fluidity, focusedLight = DBM:GetSpellInfo(138732), DBM:GetSpellInfo(137313), DBM:GetSpellInfo(138002), DBM:GetSpellInfo(137422)

local function checkWaterIonization()
	if DBM:UnitDebuff("player", Fluidity) and DBM:UnitDebuff("player", ionization) and not UnitIsDeadOrGhost("player") then
		specWarnWaterMove:Show(ionization)
	end
end

local function checkWaterStorm()
	if DBM:UnitDebuff("player", Fluidity) and not UnitIsDeadOrGhost("player") then
		specWarnWaterMove:Show(stormDebuff)
	end
end

function mod:FocusedLightningTarget(targetname, uId)
	if not targetname then return end
	if self:IsTanking(uId, "boss1") then--Focused Lightning never target tanks, so if target is tank, that means scanning failed.
		scanFailed = true
	else
		warnFocusedLightning:Show(targetname)
		if targetname == UnitName("player") then
			specWarnFocusedLightning:Show()
			yellFocusedLightning:Yell()
			if self.Options.RangeFrame and not self:IsDifficulty("lfr25") then
				DBM.RangeCheck:Show(8)
			end
		end
	end
end

function mod:OnCombatStart(delay)
	scanFailed = false
	timerFocusedLightningCD:Start(8-delay)
	timerStaticBurstCD:Start(13-delay)
	timerThrowCD:Start(30-delay)
	if self:IsHeroic() then
		timerIonizationCD:Start(60-delay)
		berserkTimer:Start(360-delay)
	else
		berserkTimer:Start(-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	self:UnregisterShortTermEvents()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 137399 then
		self:BossTargetScanner(69465, "FocusedLightningTarget", 0.025, 12)
		timerFocusedLightningCD:Start()
	elseif spellId == 137313 then
		specWarnStorm:Show()
		timerStorm:Start()
		timerStaticBurstCD:Start(20.5)--May need tweaking (20.1-24.2)
		timerThrowCD:Start()
		if self:IsHeroic() then
			timerIonizationCD:Start()
		end
		--Only register electrified waters events during storm. Avoid high cpu events during rest of fight.
		self:RegisterShortTermEvents(
			"SPELL_PERIODIC_DAMAGE 138006",
			"SPELL_PERIODIC_MISSED 138006"
		)
	elseif spellId == 138732 then
		specWarnIonization:Show()
		if timerStaticBurstCD:GetTime() == 0 or timerStaticBurstCD:GetTime() > 5 then -- Static Burst will be delayed by Ionization
			timerStaticBurstCD:Start(12)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 137162 then
		timerStaticBurstCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 137162 then
		warnStaticBurst:Show(args.destName)
		if args:IsPlayer() then
			specWarnStaticBurst:Show()
		else
			specWarnStaticBurstOther:Show(args.destName)
		end
	elseif spellId == 137422 and scanFailed then--Use cleu target if scanning is failed (slower than target scanning)
		scanFailed = false
		self:FocusedLightningTarget(args.destName)
	elseif spellId == 138732 and args:IsPlayer() then
		timerIonization:Start()
		self:Schedule(19, checkWaterIonization)--Extremely dangerous. (if conducted, then auto wipe). So check before 5 sec.
		if self.Options.RangeFrame and not DBM:UnitDebuff("player", focusedLight) then--if you have 137422 then you have range 8 open and we don't want to make it 4
			DBM.RangeCheck:Show(4)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 138732 and args:IsPlayer() then
		timerIonization:Cancel()
		self:Unschedule(checkWaterIonization)
		if self.Options.RangeFrame and not DBM:UnitDebuff("player", focusedLight) then--if you have 137422 we don't want to hide it either.
			DBM.RangeCheck:Hide()
		end
	elseif spellId == 137422 and args:IsPlayer() then
		if self.Options.RangeFrame then
			if DBM:UnitDebuff("player", ionization) then--if you have 138732 then switch to 4 yards
				DBM.RangeCheck:Show(4)
			else
				DBM.RangeCheck:Hide()
			end
		end
	elseif spellId == 137313 then
		self:UnregisterShortTermEvents()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 138006 and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnElectrifiedWaters:Show()
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:find("spell:137175") then
		local target = DBM:GetUnitFullName(target)
		warnThrow:Show(target)
		timerStormCD:Start()
		self:Schedule(55.5, checkWaterStorm)--check before 5 sec.
		if target == UnitName("player") then
			specWarnThrow:Show()
		else
			specWarnThrowOther:Show(target)
		end
	end
end
