local mod	= DBM:NewMod("Zandalari", "DBM-Pandaria")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019041710000")
mod:SetCreatureID(69768, 69769, 69841, 69842)
mod:SetZone()
mod:DisableWBEngageSync()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 138040 138044 138036 138042 138043",
	"UNIT_DIED"
)

local warnMeteorShower			= mod:NewSpellAnnounce(138042, 3)
local warnScarabSwarm			= mod:NewSpellAnnounce(138036, 2)

local specwarnHorrificVisage	= mod:NewSpecialWarningSpell(138040, nil, nil, nil, 2)
local specwarnHorrificVisageInt	= mod:NewSpecialWarningInterrupt(138040)
local specwarnThunderCrush		= mod:NewSpecialWarningMove(138044)
local specwarnVengefulSpirit	= mod:NewSpecialWarningRun(138043, "-Tank")--Assume a tank is just going to tank it

local timerThunderCrushCD		= mod:NewCDTimer(7, 138044, nil, nil, nil, 3)
local timerHorrificVisageCD		= mod:NewCDTimer(7, 138040, nil, nil, nil, 4)

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 138040 then
		if args:GetSrcCreatureID() == 69768 then--Scout
			specwarnHorrificVisageInt:Show(args.sourceName)
		else--Non interruptable
			specwarnHorrificVisage:Show()
		end
	elseif spellId == 138044 then
		specwarnThunderCrush:Show()
		timerThunderCrushCD:Start()
	elseif spellId == 138042 then
		warnMeteorShower:Show()
	elseif spellId == 138043 then
		specwarnVengefulSpirit:Show()
	elseif spellId == 138036 then
		warnScarabSwarm:Show()
	end
end

--done this way because you may be fighting two zandalari at once, so we don't want to end combat when first dies.
--Instead, when any zandalari dies, we wait 3 seconds, check for combat, if no combat it's a victory.
local function checkforWin(firstCheck)
	if not InCombatLockdown() then
		DBM:EndCombat(mod)
		if firstCheck then
			mod:Schedule(3, checkforWin)--Check again in case a spirit was lingering around keeping in combat
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 69768 or cid == 69769 or cid == 69841 or cid == 69842 then
		self:Unschedule(checkforWin)
		self:Schedule(3, checkforWin, true)--Allow 3 seconds to leave combat
	end
end
