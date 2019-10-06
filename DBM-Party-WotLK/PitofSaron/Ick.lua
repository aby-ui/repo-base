local mod	= DBM:NewMod(609, "DBM-Party-WotLK", 15, 278)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(36476)
mod:SetEncounterID(835, 836, 2001)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 68987 68989",
	"SPELL_AURA_APPLIED 69029",
	"SPELL_AURA_REMOVED 69029",
	"SPELL_PERIODIC_DAMAGE 69024",
	"SPELL_PERIODIC_MISSED 69024",
	"UNIT_AURA_UNFILTERED"
)

local warnPursuitCast			= mod:NewCastAnnounce(68987, 3)
local warnPursuit				= mod:NewTargetNoFilterAnnounce(68987, 4)

local specWarnToxic				= mod:NewSpecialWarningMove(69024, nil, nil, nil, 1, 2)
local specWarnMines				= mod:NewSpecialWarningSpell(69015, nil, nil, nil, 2, 2)
local specWarnPursuit			= mod:NewSpecialWarningRun(68987, nil, nil, 2, 4, 2)
local specWarnPoisonNova		= mod:NewSpecialWarningRun(68989, "Melee", nil, 2, 4, 2)

local timerSpecialCD			= mod:NewCDSpecialTimer(20)--Every 20-22 seconds. In rare cases he skips a special though and goes 40 seconds. unsure of cause
local timerPursuitCast			= mod:NewCastTimer(5, 68987)
local timerPursuitConfusion		= mod:NewBuffActiveTimer(12, 69029)
local timerPoisonNova			= mod:NewCastTimer(5, 68989, nil, "Melee", 2, 2)

mod:AddSetIconOption("SetIconOnPursuitTarget", 68987, true, false, {8})

local pursuit = DBM:GetSpellInfo(68987)
local pursuitTable = {}

function mod:OnCombatStart(delay)
	table.wipe(pursuitTable)
	timerSpecialCD:Start()
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 68987 then					-- Pursuit
		warnPursuitCast:Show()
		timerPursuitCast:Start()
		timerSpecialCD:Start()
	elseif spellId == 68989 then				-- Poison Nova
		timerPoisonNova:Start()
		specWarnPoisonNova:Show()
		specWarnPoisonNova:Play("runout")
		timerSpecialCD:Start()
	elseif spellId == 69012 then				--Explosive Barrage
		specWarnMines:Show()
		specWarnMines:Play("watchstep")
		timerSpecialCD:Start(22)--Will be 2 seconds longer because of how long barrage lasts
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 69029 then					-- Pursuit Confusion
		timerPursuitConfusion:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 69029 then					-- Pursuit Confusion
		timerPursuitConfusion:Cancel()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 69024 and destGUID == UnitGUID("player") and self:AntiSpam() then
		specWarnToxic:Show()
		specWarnToxic:Play("runaway")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:UNIT_AURA_UNFILTERED(uId)
	local isPursuitDebuff = DBM:UnitDebuff(uId, pursuit)
	local name = DBM:GetUnitFullName(uId)
	if not isPursuitDebuff and pursuitTable[name] then
		pursuitTable[name] = nil
		if self.Options.SetIconOnPursuitTarget then 
			self:SetIcon(name, 0) 
		end
	elseif isPursuitDebuff and not pursuitTable[name] then
		pursuitTable[name] = true
		if UnitIsUnit(uId, "player") then
			specWarnPursuit:Show()
			specWarnPursuit:Play("justrun")
		else
			warnPursuit:Show(name)
		end
		if self.Options.SetIconOnPursuitTarget then 
			self:SetIcon(name, 8) 
		end
	end
end
