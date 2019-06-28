local mod	= DBM:NewMod(1196, "DBM-Highmaul", nil, 477)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143352")
mod:SetCreatureID(78491)
mod:SetEncounterID(1720)
mod:SetZone()
--Has no audio files

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 159996 160013 159219",
	"SPELL_CAST_SUCCESS 163594 163241",
	"SPELL_AURA_APPLIED 163241 164125",
	"SPELL_AURA_APPLIED_DOSE 163241",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--TODO, verify only one spore shooter spawns at a time
local warnNecroticBreath			= mod:NewSpellAnnounce(159219, 3)--Warn everyone, so they know where not to be.
local warnRot						= mod:NewStackAnnounce(163241, 2, nil, "Tank")
--Adds/Mushrooms
local warnLivingMushroom			= mod:NewCountAnnounce(160022, 1, nil, nil, nil, nil, nil, 2)--Good shroom! (mana/haste)
local warnRejuvMushroom				= mod:NewCountAnnounce(160021, 1, nil, nil, nil, nil, nil, 2)--Other good shroom (healing)

local specWarnCreepingMoss			= mod:NewSpecialWarningMove(163590, "Tank", nil, nil, 2, 2)
local specWarnInfestingSpores		= mod:NewSpecialWarningCount(159996, nil, nil, nil, 2, 2)
local specWarnDecay					= mod:NewSpecialWarningInterruptCount(160013, "-Healer", nil, nil, nil, 2)
local specWarnNecroticBreath		= mod:NewSpecialWarningSpell(159219, "Tank", nil, nil, 3)
local specWarnRot					= mod:NewSpecialWarningStack(163241, nil, 3, nil, nil, 1, 6)
local specWarnRotOther				= mod:NewSpecialWarningTaunt(163241, nil, nil, nil, 1, 2)
local specWarnExplodingFungus		= mod:NewSpecialWarningDodge(163794, nil, nil, nil, 2, 2)--Change warning type/sound? need to know more about spawn.
local specWarnWaves					= mod:NewSpecialWarningDodge(160425, nil, nil, nil, 2, 2)
--Adds
local specWarnSporeShooter			= mod:NewSpecialWarningSwitch(163594, "RangedDps", nil, 2, nil, 2)
local specWarnFungalFlesheater		= mod:NewSpecialWarningSwitch("ej9995", "-Healer", nil, nil, nil, 2)
local specWarnMindFungus			= mod:NewSpecialWarningSwitch(163141, "Dps", nil, nil, nil, 2)

local timerInfestingSporesCD		= mod:NewCDCountTimer(57, 159996, nil, nil, nil, 2, nil, nil, nil, 1, 4)--57-63 variation
local timerRotCD					= mod:NewCDTimer(10, 163241, nil, false, nil, 5, nil, DBM_CORE_TANK_ICON)--it's a useful timer, but not mandatory and this fight has A LOT of timers so off by default for clutter reduction
local timerNecroticBreathCD			= mod:NewCDTimer(32, 159219, nil, "Tank|Healer", nil, 5, nil, DBM_CORE_TANK_ICON)
--Adds (all adds are actually NEXT timers however they get dleayed by infesting spores and necrotic breath sometimes so i'm leaving as CD for now)
local timerSporeShooterCD			= mod:NewCDTimer(57, 163594, nil, "RangedDps", 2, 1, nil, DBM_CORE_DAMAGE_ICON)
local timerFungalFleshEaterCD		= mod:NewCDCountTimer(120, "ej9995", nil, "-Healer", nil, 1, 163142, nil, nil, 2, 4)
local timerDecayCD					= mod:NewCDTimer(9.5, 160013, nil, "Melee", nil, 4)
local timerMindFungusCD				= mod:NewCDTimer(30, 163141, nil, "MeleeDps", nil, 1, nil, DBM_CORE_DAMAGE_ICON)
local timerLivingMushroomCD			= mod:NewCDCountTimer(55.5, 160022, nil, "Healer", nil, 5)
local timerRejuvMushroomCD			= mod:NewCDCountTimer(130, 160021, nil, "Healer", nil, 5)
local berserkTimer					= mod:NewBerserkTimer(600)
mod:AddTimerLine(ENCOUNTER_JOURNAL_SECTION_FLAG12)
local timerSpecialCD				= mod:NewCDSpecialTimer(20)--Mythic Specials. Shared cd, which special he uses is random. 20-25 second variation, unless delayed by spores. then 20-25+10

mod:AddRangeFrameOption(8, 160254, false)
mod:AddDropdownOption("InterruptCounter", {"Two", "Three", "Four"}, "Two", "misc")

mod.vb.sporesAlive = 0
mod.vb.decayCounter = 0
mod.vb.greenShroom = 0
mod.vb.blueShroom = 0
mod.vb.sporesCount = 0
mod.vb.fleshEaterCount = 0

function mod:OnCombatStart(delay)
	self.vb.sporesAlive = 0
	self.vb.decayCounter = 0
	self.vb.greenShroom = 0
	self.vb.blueShroom = 0
	self.vb.sporesCount = 0
	self.vb.fleshEaterCount = 0
	timerMindFungusCD:Start(10-delay)
	timerLivingMushroomCD:Start(18-delay, 1)--16-18
	timerSporeShooterCD:Start(20-delay)--20-26
	timerNecroticBreathCD:Start(30-delay)
	timerFungalFleshEaterCD:Start(32-delay, 1)
	timerInfestingSporesCD:Start(45-delay, 1)
	specWarnInfestingSpores:ScheduleVoice(38.5-delay, "aesoon")
	timerRejuvMushroomCD:Start(80-delay, 1)--Todo, verify 80 in all modes and not still 75 in mythic
	berserkTimer:Start(-delay)
	if self:IsMythic() then
		timerSpecialCD:Start(-delay)--standard 20-25
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 159996 then
		self.vb.sporesCount = self.vb.sporesCount + 1
		specWarnInfestingSpores:Show(self.vb.sporesCount)
		timerInfestingSporesCD:Start(nil, self.vb.sporesCount+1)
		specWarnInfestingSpores:ScheduleVoice(50.5, "aesoon")
	elseif spellId == 160013 then
		if (self.Options.InterruptCounter == "Two" and self.vb.decayCounter == 2) or (self.Options.InterruptCounter == "Three" and self.vb.decayCounter == 3) or self.vb.decayCounter == 4 then
			self.vb.decayCounter = 0
		end	
		self.vb.decayCounter = self.vb.decayCounter + 1
		local guid = args.souceGUID
		if guid == UnitGUID("target") or guid == UnitGUID("focus") then
			specWarnDecay:Show(args.sourceName, self.vb.decayCounter)
			timerDecayCD:Start(args.sourceGUID)
			if self.vb.decayCounter == 1 then
				specWarnDecay:Play("kick1r")
			elseif self.vb.decayCounter == 2 then
				specWarnDecay:Play("kick2r")
			elseif self.vb.decayCounter == 3 then
				specWarnDecay:Play("kick3r")
			elseif self.vb.decayCounter == 4 then
				specWarnDecay:Play("kick4r")
			end
		end
	elseif spellId == 159219 then
		if self.Options.SpecWarn159219spell then--Special warning is enabled
			specWarnNecroticBreath:Show()
		else--Special warning isn't on, show regular one.
			warnNecroticBreath:Show()
		end
		timerNecroticBreathCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 163594 then
		self.vb.sporesAlive = self.vb.sporesAlive + 1
		specWarnSporeShooter:Show()
		timerSporeShooterCD:Start()
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
		specWarnSporeShooter:Play("163594k")
	elseif spellId == 163241 then
		timerRotCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 163241 then
		local amount = args.amount or 1
		if amount >= 3 then
			if args:IsPlayer() then--At this point the other tank SHOULD be clear.
				specWarnRot:Show(amount)
				specWarnRot:Play("stackhigh")
			else--Taunt as soon as stacks are clear, regardless of stack count.
				if not DBM:UnitDebuff("player", args.spellName) and not UnitIsDeadOrGhost("player") then
					specWarnRotOther:Show(args.destName)
					specWarnRotOther:Play("changemt")
				else
					warnRot:Show(args.destName, amount)
				end
			end
		else
			warnRot:Show(args.destName, amount)
		end
	elseif spellId == 164125 and args:GetDestCreatureID() == 78491 then
		specWarnCreepingMoss:Show()
		specWarnCreepingMoss:Play("bossout")
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 79183 then--Spore Shooter
		self.vb.sporesAlive = self.vb.sporesAlive - 1
		if self.Options.RangeFrame and self.vb.sporesAlive == 0 then
			DBM.RangeCheck:Hide()
		end
	elseif cid == 79092 then--Fungal Flesh Eater
		self.vb.decayCounter = 0
		timerDecayCD:Cancel(args.destGUID)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 163141 then
		specWarnMindFungus:Show()
		timerMindFungusCD:Start()
		specWarnMindFungus:Play("163141k")
	elseif spellId == 163142 then
		self.vb.fleshEaterCount = self.vb.fleshEaterCount + 1
		specWarnFungalFlesheater:Show(self.vb.fleshEaterCount)
		timerFungalFleshEaterCD:Start(nil, self.vb.fleshEaterCount+1)
		specWarnFungalFlesheater:Play("163142k")
	elseif spellId == 160022 then
		self.vb.greenShroom = self.vb.greenShroom + 1
		warnLivingMushroom:Show(self.vb.greenShroom)
		timerLivingMushroomCD:Start(nil, self.vb.greenShroom+1)
		warnLivingMushroom:Play("160022s") --green one
	elseif spellId == 160021 or spellId == 177820 then--Seems diff ID in mythic vs non mythic?
		self.vb.blueShroom = self.vb.blueShroom + 1
		warnRejuvMushroom:Show(self.vb.blueShroom)
		timerRejuvMushroomCD:Start(nil, self.vb.blueShroom+1)
		warnRejuvMushroom:Play("160021s") --blue one
	elseif spellId == 163794 then
		specWarnExplodingFungus:Show()
		timerSpecialCD:Start()
		specWarnExplodingFungus:Play("watchstep")
		specWarnExplodingFungus:ScheduleVoice(15, "specialsoon")
	elseif spellId == 160425 then
		specWarnWaves:Show()
		timerSpecialCD:Start()
		specWarnWaves:Play("watchwave")
		specWarnWaves:ScheduleVoice(15, "specialsoon")
	end
end
