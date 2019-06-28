local mod	= DBM:NewMod(311, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190625143316")
mod:SetCreatureID(55265)
mod:SetEncounterID(1292)
mod:SetZone()
--mod:SetModelSound("sound\\CREATURE\\MORCHOK\\VO_DS_MORCHOK_EVENT_04.OGG", "sound\\CREATURE\\MORCHOK\\VO_DS_MORCHOK_ORB_01.OGG")

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 103687 103846",
	"SPELL_AURA_APPLIED_DOSE 103687",
	"SPELL_AURA_REMOVED 103851",
	"SPELL_CAST_START 103414 103851",
	"SPELL_SUMMON 103639 109017",
	"SPELL_CAST_SUCCESS 103821"
)

local warnCrushArmor		= mod:NewStackAnnounce(103687, 3, nil, "Tank|Healer")
local warnCrystal			= mod:NewSpellAnnounce(103639, 3)
local warnStomp				= mod:NewSpellAnnounce(103414, 3)
local warnVortex			= mod:NewSpellAnnounce(103821, 3)
local warnBlood				= mod:NewSpellAnnounce(103851, 4)
local warnFurious			= mod:NewSpellAnnounce(103846, 3)
local warnKohcrom			= mod:NewSpellAnnounce(109017, 4)
local KohcromWarning		= mod:NewAnnounce("KohcromWarning", 2, 55342)--Mirror image icon. use different color for easlier distingush.

local specwarnCrushArmor	= mod:NewSpecialWarningStack(103687, "Tank", 3)
local specwarnVortex		= mod:NewSpecialWarningSpell(103821, nil, nil, nil, 2)
local specwarnBlood			= mod:NewSpecialWarningMove(103785)
local specwarnCrystal		= mod:NewSpecialWarningTarget(103639, false)

local timerCrushArmor		= mod:NewTargetTimer(20, 103687, nil, "Tank", nil, 5, nil, DBM_CORE_TANK_ICON)
local timerCrystal			= mod:NewCDTimer(12, 103640, nil, nil, nil, 5)	-- 12-14sec variation (is also time till 'detonate')
local timerStomp 			= mod:NewCDTimer(11, 103414, nil, nil, nil, 2)	-- 12-14sec variation
local timerVortexNext		= mod:NewCDTimer(74, 103821, nil, nil, nil, 6)--96~97 sec after last vortex. must subtract blood 17 + vortex buff 5 sec. 74 sec left
local timerBlood			= mod:NewBuffActiveTimer(17, 103851, nil, nil, nil, 6)
local timerKohcromCD		= mod:NewTimer(6, "KohcromCD", 55342, nil, nil, nil, DBM_CORE_HEROIC_ICON)--Enable when we have actual timing for any of his abilies
--Basically any time morchok casts, we'll start an echo timer for when it will be mimiced by his twin Kohcrom. 
--We will not start timers using Kohcrom's casts, it'll waste WAY too much space.
--EJ is pretty clear, they are cast shortly after morchok, always. So echo timer is perfect and clean solution.

local berserkTimer			= mod:NewBerserkTimer(420)

mod:AddBoolOption("RangeFrame", false)--For achievement

local stompCount = 1
local crystalCount = 1--3 crystals between each vortex cast by Morchok, we ignore his twins.
local kohcromSkip = 2--1 is crystal, 2 is stomp.

function mod:OnCombatStart(delay)
	stompCount = 1
	crystalCount = 1
	if self:IsDifficulty("heroic10", "heroic25") then
		kohcromSkip = 2
		berserkTimer:Start(-delay)
	end
	timerStomp:Start(-delay)
	timerCrystal:Start(19-delay)
	timerVortexNext:Start(54-delay) -- 56~60 sec variables
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame and not self:IsDifficulty("lfr25") then
		DBM.RangeCheck:Hide()
	end
	self:UnregisterShortTermEvents()
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 103687 then
		local amount = args.amount or 1
		warnCrushArmor:Show(args.destName, amount)
		timerCrushArmor:Start(args.destName)
		if amount > 3 then
			specwarnCrushArmor:Show(amount)
		end
	elseif spellId == 103846 and self:AntiSpam(3, 1) then
		warnFurious:Show()
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 103851 and self:AntiSpam(3, 1) then--Filter twin here, they vortex together but we don't want to trigger everything twice needlessly.
		stompCount = 0
		crystalCount = 0
		timerStomp:Start(19)
		timerCrystal:Start(26)
		timerVortexNext:Start()
		if self.Options.RangeFrame and not self:IsDifficulty("lfr25") then
			DBM.RangeCheck:Hide()
		end
		if self:IsDifficulty("heroic10", "heroic25") then
			kohcromSkip = 1
		end
		self:UnregisterShortTermEvents()
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 103414 then
		if args:GetSrcCreatureID() == 55265 then
			stompCount = stompCount + 1
			warnStomp:Show()
			timerStomp:Cancel()
			if stompCount < 4 then
				timerStomp:Start()
			end
			if UnitExists("boss2") then
				if kohcromSkip == 2 then
					kohcromSkip = nil
				elseif self:IsDifficulty("heroic25") then
					timerKohcromCD:Start(5, args.spellName)
				else
					timerKohcromCD:Start(6, args.spellName)
				end
			end
			if kohcromSkip and self:IsDifficulty("heroic10", "heroic25") then
				kohcromSkip = 1
			end
		else
			KohcromWarning:Show(args.sourceName, args.spellName)
		end
	elseif spellId == 103851 then
		if args:GetSrcCreatureID() == 55265 then
			warnBlood:Show()
			timerBlood:Start()
		end
	end
end

function mod:SPELL_SUMMON(args)
	local spellId = args.spellId
	if spellId == 103639 then
		if self:GetUnitCreatureId("target") == self:GetCIDFromGUID(args.sourceGUID) or self:GetUnitCreatureId("focus") == self:GetCIDFromGUID(args.sourceGUID) then
			specwarnCrystal:Show(args.sourceName)
		end
		if args:GetSrcCreatureID() == 55265 then
			crystalCount = crystalCount + 1
			warnCrystal:Show()
			timerCrystal:Cancel()
			if crystalCount < 3 then
				timerCrystal:Start()
			end
			if UnitExists("boss2") then
				if kohcromSkip == 1 then
					kohcromSkip = nil
				elseif self:IsDifficulty("heroic25") then
					timerKohcromCD:Start(5, args.spellName)
				else
					timerKohcromCD:Start(6, args.spellName)
				end
			end
			if kohcromSkip and self:IsDifficulty("heroic10", "heroic25") then
				kohcromSkip = 2
			end
		else
			KohcromWarning:Show(args.sourceName, args.spellName)
		end
	elseif spellId == 109017 then
		warnKohcrom:Show()
		-- when Kohcrom summoning, Stomp and Crystal timer restarts.
		if kohcromSkip == 1 then -- next is Crystal, Crystal will be skipped.
			timerCrystal:Cancel()
			timerStomp:Cancel()
			timerCrystal:Start(5.5) -- 5.5~6.8 sec
			timerStomp:Start()
		elseif kohcromSkip == 2 then -- next is Stomp, Stomp will be skipped. longer then Crystal.
			timerStomp:Cancel()
			timerCrystal:Cancel()
			timerStomp:Start(6)
			timerCrystal:Start(15)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 103821 and self:AntiSpam(3, 1) then
		crystalCount = 0
		timerStomp:Cancel()
		timerCrystal:Cancel()
		timerKohcromCD:Cancel()
		warnVortex:Show()
		specwarnVortex:Show()
		if self.Options.RangeFrame and not self:IsDifficulty("lfr25") then
			DBM.RangeCheck:Show(5)
		end
		if not self:IsTrivial(90) then--Only register damage events during vortex (when black blood is out) and only if it's not trivial
			self:RegisterShortTermEvents(
				"SPELL_DAMAGE 103785",
				"SPELL_MISSED 103785"
			)
		end
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 103785 and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then
		specwarnBlood:Show()
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE
