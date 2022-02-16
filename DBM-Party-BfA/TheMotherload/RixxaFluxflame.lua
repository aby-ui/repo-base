local mod	= DBM:NewMod(2115, "DBM-Party-BfA", 7, 1001)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220116042005")
mod:SetCreatureID(129231)
mod:SetEncounterID(2107)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 259853",
	"SPELL_CAST_START 260669 259940",
	"SPELL_CAST_SUCCESS 259022 270042 259856",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2"
)

--TODO, video fight to figure out whats going on with azerite and gushing and what makes them diff.
--TODO, more work on blast timings, two casts isn't enough to establish a timer
local warnAxeriteCatalyst			= mod:NewSpellAnnounce(259022, 2)--Cast often, so general warning not special
local warnPoropellantBlast			= mod:NewTargetNoFilterAnnounce(259940, 2)

local specWarnChemBurn				= mod:NewSpecialWarningDispel(259853, "Healer", nil, nil, 1, 2)
local specWarnPoropellantBlast		= mod:NewSpecialWarningYou(259940, nil, nil, nil, 1, 2)
local yellPoropellantBlast			= mod:NewYell(259940)
local specWarnPoropellantBlastNear	= mod:NewSpecialWarningClose(259940, nil, nil, nil, 1, 2)

local timerAxeriteCatalystCD		= mod:NewCDTimer(13, 259022, nil, nil, nil, 3)
local timerChemBurnCD				= mod:NewCDTimer(13, 259853, nil, nil, 2, 5, nil, DBM_COMMON_L.HEALER_ICON..DBM_COMMON_L.MAGIC_ICON)
--local timerPropellantBlastCD		= mod:NewCDTimer(13, 259940, nil, nil, nil, 3)--Longer pull/more data needed (32.5, 6.0, 36.1)
--local timerGushingCatalystCD		= mod:NewCDTimer(13, 275992, nil, nil, nil, 3, nil, DBM_COMMON_L.HEROIC_ICON)

--mod:AddRangeFrameOption(5, 194966)

mod.vb.chemBurnCast = 0
mod.vb.azeriteCataCast = 0

function mod:BlastTarget(targetname)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnPoropellantBlast:Show()
		specWarnPoropellantBlast:Play("targetyou")
		yellPoropellantBlast:Yell()
	elseif self:CheckNearby(10, targetname) then
		specWarnPoropellantBlastNear:Show(targetname)
		specWarnPoropellantBlastNear:Play("runaway")
	else
		warnPoropellantBlast:Show(targetname)
	end
end

function mod:OnCombatStart(delay)
	self.vb.chemBurnCast = 0
	self.vb.azeriteCataCast = 0
	timerAxeriteCatalystCD:Start(4-delay)
	timerChemBurnCD:Start(12-delay)--SUCCESS
	--timerPropellantBlastCD:Start(31-delay)
--	if not self:IsNormal() then
--		timerGushingCatalystCD:Start(1-delay)
--	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 259853 and self:CheckDispelFilter() then
		specWarnChemBurn:CombinedShow(1, args.destName)
		specWarnChemBurn:ScheduleVoice(1, "dispelnow")
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 260669 or spellId == 259940 then
		self:BossTargetScanner(args.sourceGUID, "BlastTarget", 0.1, 8)
		--timerPropellantBlastCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 259022 or spellId == 270042 then
		warnAxeriteCatalyst:Show()
		timerAxeriteCatalystCD:Start()
	elseif spellId == 259856 and self:AntiSpam(5, 1) then
		self.vb.chemBurnCast = self.vb.chemBurnCast + 1
		if self.vb.chemBurnCast % 2 == 0 then
			timerChemBurnCD:Start(27)
		else
			timerChemBurnCD:Start(15)
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, spellId)
	if spellId == 270028 then
		self.vb.azeriteCataCast = self.vb.azeriteCataCast + 1
		warnAxeriteCatalyst:Show()
		--timerGushingCatalystCD:Start()
		if self.vb.azeriteCataCast % 2 == 0 then
			timerAxeriteCatalystCD:Start(27)
		else
			timerAxeriteCatalystCD:Start(15)
		end
	end
end
