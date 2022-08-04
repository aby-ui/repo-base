local mod	= DBM:NewMod(893, "DBM-Party-WoD", 2, 385)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"

mod:SetRevision("20200912135206")
mod:SetCreatureID(74366, 74475)--74366 Forgemaster Gog'duh, 74475 Magmolatus
mod:SetEncounterID(1655)
mod:SetMainBossID(74475)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 149997 149975 150032",
	"SPELL_CAST_START 149941 150038 150023",
	"SPELL_PERIODIC_DAMAGE 150011",
	"SPELL_ABSORBED 150011"
)

local warnDancingFlames			= mod:NewTargetNoFilterAnnounce(149975, 3, nil, "Healer")

local specWarnMagmaBarrage		= mod:NewSpecialWarningMove(150011, nil, nil, nil, 1, 8)
local specWarnRoughSmash		= mod:NewSpecialWarningDodge(149941, "Melee", nil, nil, 4, 2)
local specWarnRuination			= mod:NewSpecialWarningSwitch("ej8622", "-Healer", nil, nil, 1, 2)
local specWarnCalamity			= mod:NewSpecialWarningSwitch("ej8626", "-Healer", nil, nil, 1, 2)
local specWarnFirestorm			= mod:NewSpecialWarningInterrupt(149997, "HasInterrupt", nil, 2, 1, 2)
local specWarnDancingFlames		= mod:NewSpecialWarningDispel(149975, "Healer", nil, nil, 1, 2)
local specWarnMagmolatus		= mod:NewSpecialWarningSwitch("ej8621", nil, nil, 2, 1, 2)--Dps can turn this on too I suppose but 5 seconds after boss spawns they are switching to add anyways, so this is mainly for tank to pick it up
local specWarnSlagSmash			= mod:NewSpecialWarningDodge(150023, "Melee", nil, nil, 4, 2)
local specWarnMoltenImpact		= mod:NewSpecialWarningSpell(150038, nil, nil, nil, 2, 2)
local specWarnWitheringFlames	= mod:NewSpecialWarningDispel(150032, "Healer", nil, nil, 1, 2)

local timerMoltenImpactCD		= mod:NewNextTimer(21.5, 150038, nil, nil, nil, 1)

local activeAddGUIDS = {}

function mod:OnCombatStart(delay)
	table.wipe(activeAddGUIDS)
	self:RegisterShortTermEvents(
		"INSTANCE_ENCOUNTER_ENGAGE_UNIT"
	)
end

function mod:OnCombatEnd()
	table.wipe(activeAddGUIDS)
	self:UnregisterShortTermEvents()
end

function mod:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	for i = 1, 5 do
		local unitID = "boss"..i
		local unitGUID = UnitGUID(unitID)
		local cid = self:GetCIDFromGUID(unitGUID)
		if UnitExists(unitID) and not activeAddGUIDS[unitGUID] then
			activeAddGUIDS[unitGUID] = true
			--Ruination#Creature:0:3314:1175:11531:74570
			if cid == 74570 then--Ruination
				specWarnRuination:Show()
				specWarnRuination:Play("mobsoon")
			elseif cid == 74571 then--Calamity
				specWarnCalamity:Show()
				specWarnCalamity:Play("mobsoon")
			elseif cid == 74475 then--Magmolatus
				specWarnMagmolatus:Show()
				specWarnMagmolatus:Play("bigmob")
				timerMoltenImpactCD:Start(5)
			end
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 149997 and self:CheckInterruptFilter(args.sourceGUID, false, true) then
		specWarnFirestorm:Show(args.sourceName)
		if self:IsTank() then
			specWarnFirestorm:Play("kickcast")
		else
			specWarnFirestorm:Play("helpkick")
		end
	elseif spellId == 149975 then
		if self:CheckDispelFilter() then--only show once. (prevent loud sound)
			specWarnDancingFlames:CombinedShow(0.3, args.destName)
			if self:AntiSpam(2, 2) then
				specWarnDancingFlames:Play("dispelnow")
			end
		else
			warnDancingFlames:CombinedShow(0.3, args.destName)--heroic is 2 targets so combined.
		end
	elseif spellId == 150032 and self:CheckDispelFilter() then
		specWarnWitheringFlames:Show(args.destName)
		specWarnWitheringFlames:Play("dispelnow")
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 149941 then
		specWarnRoughSmash:Show()
		specWarnRoughSmash:Play("justrun")
	elseif spellId == 150038 then
		specWarnMoltenImpact:Show()
		specWarnMoltenImpact:Play("watchstep")
		timerMoltenImpactCD:Start()
	elseif spellId == 150023 then
		specWarnSlagSmash:Show()
		specWarnSlagSmash:Play("justrun")
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 15011 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then--need to check spell ids again
		specWarnMagmaBarrage:Show()
		specWarnMagmaBarrage:Play("watchfeet")
	end
end
mod.SPELL_ABSORBED = mod.SPELL_PERIODIC_DAMAGE
