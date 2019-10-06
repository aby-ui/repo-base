local mod	= DBM:NewMod(109, "DBM-Party-Cataclysm", 1, 66)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190421035925")
mod:SetCreatureID(39705)
mod:SetEncounterID(1036)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 76200 76188 76189",
	"SPELL_AURA_REFRESH 76188 76189",
	"SPELL_AURA_REMOVED 76242 76188"
)

local warnTransformation	= mod:NewSpellAnnounce(76200, 3)
local warnCorrupion			= mod:NewTargetNoFilterAnnounce(76188, 2, nil, "Healer", 2)

local timerCorruption		= mod:NewTargetTimer(12, 76188, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON..DBM_CORE_MAGIC_ICON)
local timerVeil				= mod:NewTargetTimer(4, 76189, nil, "Healer", nil, 5, nil, DBM_CORE_HEALER_ICON)

mod:AddSetIconOption("SetIconOnBoss", 76242, true, false, {8})

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 76200 then
		warnTransformation:Show()
	elseif args.spellId == 76188 then
		warnCorrupion:Show(args.destName)
		timerCorruption:Start(args.destName)
	elseif args.spellId == 76189 then
		timerVeil:Start(args.destName)
	end
end
mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 76242 and self.Options.SetIconOnBoss then
		self:SetIcon(L.name, 8)
	elseif args.spellId == 76188 then
		timerCorruption:Cancel(args.destName)
	end
end
