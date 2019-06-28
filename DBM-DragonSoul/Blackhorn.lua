local mod	= DBM:NewMod(332, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(56598)--56427 is Boss, but engage trigger needs the ship which is 56598
--mod:SetEncounterID(1298)--Fires when ship get actual engage. need to adjust timer.
mod:SetMainBossID(56427)
mod:SetZone()
--mod:SetModelSound("sound\\CREATURE\\WarmasterBlackhorn\\VO_DS_BLACKHORN_INTRO_01.OGG", "sound\\CREATURE\\WarmasterBlackhorn\\VO_DS_BLACKHORN_SLAY_01.OGG")

mod:RegisterCombat("combat")
mod:SetMinCombatTime(20)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 107588 108046 110212 108039",
	"SPELL_CAST_SUCCESS 108044 108042 107558",
	"SPELL_AURA_APPLIED 108043 108038 108040 110214",
	"SPELL_AURA_APPLIED_DOSE 108043",
	"SPELL_AURA_REMOVED 108043",
	"SPELL_SUMMON 108051",
	"SPELL_DAMAGE 108076 110095",
	"SPELL_MISSED 108076 110095",
	"RAID_BOSS_EMOTE",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--mod:RegisterEvents(
--	"INSTANCE_ENCOUNTER_ENGAGE_UNIT"
--)-- TODO: Move combat start timer to this event.

local warnDrakesLeft				= mod:NewAddsLeftAnnounce("ej4192", 2, 61248)
local warnHarpoon					= mod:NewTargetAnnounce(108038, 2)
local warnReloading					= mod:NewCastAnnounce(108039, 2)
local warnTwilightOnslaught			= mod:NewCountAnnounce(107588, 4)
local warnPhase2					= mod:NewPhaseAnnounce(2, 3)
local warnRoar						= mod:NewSpellAnnounce(108044, 2)
local warnTwilightFlames			= mod:NewSpellAnnounce(108051, 3)
local warnTwilightBreath			= mod:NewSpellAnnounce(110212, 3)
local warnShockwave					= mod:NewTargetAnnounce(108046, 4)
local warnSunder					= mod:NewStackAnnounce(108043, 3, nil, "Tank|Healer")
local warnConsumingShroud			= mod:NewTargetAnnounce(110214)

local specWarnHarpoon				= mod:NewSpecialWarningTarget(108038, false)
local specWarnTwilightOnslaught		= mod:NewSpecialWarningSpell(107588, nil, nil, nil, true)
local specWarnSapper				= mod:NewSpecialWarningSwitch("ej4200", "Dps")
local specWarnDeckFireCast			= mod:NewSpecialWarningSpell(110095, false, nil, nil, true)
local specWarnDeckFire				= mod:NewSpecialWarningMove(110095)
local specWarnElites				= mod:NewSpecialWarning("SpecWarnElites", "Tank")
local specWarnShockwave				= mod:NewSpecialWarningMove(108046)
local specWarnShockwaveOther		= mod:NewSpecialWarningTarget(108046, false)
local yellShockwave					= mod:NewYell(108046)
local specWarnTwilightFlames		= mod:NewSpecialWarningMove(108076)
local specWarnSunder				= mod:NewSpecialWarningStack(108043, "Tank", 3)
local specWarnSunderOther			= mod:NewSpecialWarningTarget(108043, "Tank")

local timerCombatStart				= mod:NewCombatTimer(20.5)
local timerAdd						= mod:NewTimer(61, "TimerAdd", 107752, nil, nil, 1)
local timerHarpoonCD				= mod:NewCDTimer(6.5, 108038, nil, "Dps", nil, 5, nil, DBM_CORE_DAMAGE_ICON)--If you fail to kill drake until next drake spawning, timer do not match. So better to use cd timer for now.
local timerHarpoonActive			= mod:NewBuffActiveTimer(20, 108038, nil, "Dps", nil, 5, nil, DBM_CORE_DAMAGE_ICON)--Seems to always hold at least 20 seconds, beyond that, RNG, but you always get at least 20 seconds before they "snap" free.
local timerReloadingCast			= mod:NewCastTimer(10, 108039, nil, "Dps", nil, 5, nil, DBM_CORE_DAMAGE_ICON)
local timerTwilightOnslaught		= mod:NewCastTimer(7, 107588, nil, nil, nil, 5)
local timerTwilightOnslaughtCD		= mod:NewNextCountTimer(35, 107588, nil, nil, nil, 5, nil, nil, nil, 1, 4)
local timerSapperCD					= mod:NewNextTimer(39.8, "ej4200", nil, nil, nil, 1, 107752, DBM_CORE_HEROIC_ICON, nil, 2, 4)
local timerDegenerationCD			= mod:NewCDTimer(8.5, 107558, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)--8.5-9.5 variation.
local timerBladeRushCD				= mod:NewCDTimer(15.5, 107595, nil, nil, nil, 3)
local timerBroadsideCD				= mod:NewNextTimer(70, 110153, nil, nil, nil, nil, nil, DBM_CORE_HEROIC_ICON)
local timerRoarCD					= mod:NewCDTimer(18.5, 108044, nil, nil, nil, 2)--18.5~24 variables
local timerTwilightFlamesCD			= mod:NewNextTimer(8, 108051, nil, nil, nil, 3)
local timerShockwaveCD				= mod:NewCDTimer(23, 108046, nil, nil, nil, 3)
local timerDevastateCD				= mod:NewCDTimer(8.5, 108042, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerSunder					= mod:NewTargetTimer(30, 108043, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerConsumingShroud			= mod:NewCDTimer(30, 110214, nil, nil, nil, 3)
local timerTwilightBreath			= mod:NewCDTimer(20.5, 110212, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)

local berserkTimer					= mod:NewBerserkTimer(240)

mod:AddBoolOption("SetTextures", false)--Disable projected textures in phase 1, because no harmful spells use them in phase 1, but friendly spells make the blade rush lines harder to see.

local phase2Started = false
local addsCount = 0
local drakesCount = 6
local twilightOnslaughtCount = 0
local CVAR = false

local function Phase2Delay()
	mod:UnscheduleMethod("AddsRepeat")
	timerSapperCD:Cancel()
	timerRoarCD:Start(10)
	timerTwilightFlamesCD:Start(10.5)
	timerShockwaveCD:Start(13)--13-16 second variation
	if mod:IsDifficulty("heroic10", "heroic25") then
		timerConsumingShroud:Start(45)	-- 45seconds once P2 starts?
	end
	if not mod:IsDifficulty("lfr25") then--Assumed, but i find it unlikely a 4 min berserk timer will be active on LFR
		berserkTimer:Start()
	end
	if mod.Options.SetTextures and not GetCVarBool("projectedTextures") and CVAR then--Confirm we turned them off in phase 1 before messing with anything.
		SetCVar("projectedTextures", 1)--Turn them back on for phase 2 if we're the ones that turned em off on pull.
	end
end

function mod:ShockwaveTarget()
	local targetname = self:GetBossTarget(56427)
	if not targetname then return end
	warnShockwave:Show(targetname)
	if targetname == UnitName("player") then
		specWarnShockwave:Show()
		yellShockwave:Yell()
	else
		specWarnShockwaveOther:Show(targetname)
	end
end

function mod:AddsRepeat()
	if addsCount < 2 then
		addsCount = addsCount + 1
		timerAdd:Start()
		self:ScheduleMethod(61, "AddsRepeat")
	end
	specWarnElites:Show()
	if addsCount == 1 then
		timerHarpoonCD:Start(18)--20 seconds after first elites (Confirmed). If harpoon bug not happening, it comes 18 sec after first elites.
	else--6-7 seconds after sets 2 and 3.
		timerHarpoonCD:Start()--6-7 second variation.
	end
end

function mod:OnCombatStart(delay)
	phase2Started = false
	addsCount = 0
	drakesCount = 6
	twilightOnslaughtCount = 0
	CVAR = false
	timerCombatStart:Start(-delay)
	timerAdd:Start(22.8-delay)
	self:ScheduleMethod(22.8-delay, "AddsRepeat")
	timerTwilightOnslaughtCD:Start(46.9-delay, 1)
	if self:IsDifficulty("heroic10", "heroic25") then
		timerBroadsideCD:Start(57-delay)
	end
	if not self:IsDifficulty("lfr25") then--No sappers in LFR
		timerSapperCD:Start(69-delay)
	end
	if self.Options.SetTextures and GetCVarBool("projectedTextures") then--This is only true if projected textures were on when we pulled and option to control setting is also on.
		CVAR = true--so set this variable to true, which means we are allowed to mess with users graphics settings
		SetCVar("projectedTextures", 0)
	end
end

function mod:OnCombatEnd()
	if self.Options.SetTextures and not GetCVarBool("projectedTextures") and CVAR then--Only turn them back on if they are off now, but were on when we pulled, and the setting is enabled.
		SetCVar("projectedTextures", 1)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 107588 then
		twilightOnslaughtCount = twilightOnslaughtCount + 1
		warnTwilightOnslaught:Show(twilightOnslaughtCount)
		specWarnTwilightOnslaught:Show()
		timerTwilightOnslaught:Start()
		timerTwilightOnslaughtCD:Start(nil, twilightOnslaughtCount + 1)
	elseif spellId == 108046 then
		self:ScheduleMethod(0.2, "ShockwaveTarget")
		timerShockwaveCD:Start()
	elseif spellId == 110212 then
		warnTwilightBreath:Show()
		timerTwilightBreath:Start()
	elseif spellId == 108039 then
		warnReloading:Show()
		timerReloadingCast:Start(args.sourceGUID)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 108044 then
		warnRoar:Show()
		timerRoarCD:Start()
	elseif spellId == 108042 then
		timerDevastateCD:Start()
	elseif spellId == 107558 then
		timerDegenerationCD:Start(args.sourceGUID)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 108043 then
		local amount = args.amount or 1
		warnSunder:Show(args.destName, amount)
		timerSunder:Start(args.destName)
		if args:IsPlayer() then
			if amount >= 3 then
				specWarnSunder:Show(amount)
			end
		else
			if amount >= 2 and not DBM:UnitDebuff("player", args.spellName) and not UnitIsDeadOrGhost("player") then
				specWarnSunderOther:Show(args.destName)
			end
		end
	elseif spellId == 108038 then
		if self:AntiSpam(5, 1) then -- Use time check for harpooning warning. It can be avoid bad casts also.
			warnHarpoon:Show(args.destName)
			specWarnHarpoon:Show(args.destName)
		end
		-- Timer not use time check. 2 harpoons cast same time even not bugged.
		if self:IsDifficulty("heroic10", "heroic25") then
			timerHarpoonActive:Start(nil, args.destGUID)
		elseif self:IsDifficulty("normal10", "normal25") then
			timerHarpoonActive:Start(25, args.destGUID)
		end
	elseif spellId == 108040 and not phase2Started then--Goriona is being shot by the ships Artillery Barrage (phase 2 trigger)
		timerTwilightOnslaughtCD:Cancel()
		timerBroadsideCD:Cancel()
		self:Schedule(10, Phase2Delay)--seems to only sapper comes even phase2 started. so delays only sapper stuff.
		phase2Started = true
		warnPhase2:Show()--We still warn phase 2 here though to get into position, especially since he can land on deck up to 5 seconds before his yell.
		--timerCombatStart:Start(5)--5-8 seems variation, we use shortest.
	elseif spellId == 110214 then
		warnConsumingShroud:Show(args.destName)
		timerConsumingShroud:Start()
	end
end		
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 108043 then
		timerSunder:Cancel(args.destName)
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 108051 then
		warnTwilightFlames:Show()
		timerTwilightFlamesCD:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 108076 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then--Goriona's Void zones
		specWarnTwilightFlames:Show()
	elseif spellId == 110095 and destGUID == UnitGUID("player") and self:AntiSpam(3, 3) then
		specWarnDeckFire:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.SapperEmote or msg:find(L.SapperEmote) then
		timerSapperCD:Start()
		specWarnSapper:Show()
	elseif msg == L.Broadside or msg:find(L.Broadside) then
		timerBroadsideCD:Start()
	elseif msg == L.DeckFire or msg:find(L.DeckFire) then
		specWarnDeckFireCast:Show()
	elseif msg == L.GorionaRetreat or msg:find(L.GorionaRetreat) then
		self:Schedule(1.5, function()
			timerTwilightBreath:Cancel()
			timerConsumingShroud:Cancel()
			timerTwilightFlamesCD:Cancel()
		end)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 56427 then--Blackhorn
		DBM:EndCombat(self)
	elseif cid == 56848 or cid == 56854 then--Humanoids
		timerBladeRushCD:Cancel(args.sourceGUID)
		timerDegenerationCD:Cancel(args.sourceGUID)
	elseif cid == 56855 or cid == 56587 then--Drakes
		drakesCount = drakesCount - 1
		warnDrakesLeft:Show(drakesCount)
		timerReloadingCast:Cancel(args.sourceGUID)
		timerHarpoonActive:Cancel(args.sourceGUID)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 107594 then--Blade Rush, cast start is not detectable, only cast finish, can't use target scanning, or pre warn (ie when the lines go out), only able to detect when they actually finish rush
		self:SendSync("BladeRush", UnitGUID(uId))
	end
end

function mod:OnSync(msg, sourceGUID)
	if msg == "BladeRush" then
		if self:IsDifficulty("heroic10", "heroic25") then
			timerBladeRushCD:Start(sourceGUID)
		else
			timerBladeRushCD:Start(20, sourceGUID)--assumed based on LFR, which seemed to have a 20-25 variation, not 15-20
		end
	end
end
