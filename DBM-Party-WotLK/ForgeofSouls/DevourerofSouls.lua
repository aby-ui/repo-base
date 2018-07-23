local mod	= DBM:NewMod(616, "DBM-Party-WotLK", 14, 280)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 236 $"):sub(12, -3))
mod:SetCreatureID(36502)
mod:SetEncounterID(831, 832, 2007)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local warnPhantomBlast			= mod:NewSpellAnnounce(68982, 2)
local warnUnleashedSouls		= mod:NewSpellAnnounce(68939, 3)
local warnWailingSouls			= mod:NewSpellAnnounce(68899, 4)
local warnWellofSouls			= mod:NewSpellAnnounce(68820, 3)

local specwarnMirroredSoul		= mod:NewSpecialWarningReflect(69051)
local specwarnWailingSouls		= mod:NewSpecialWarningSpell(68899, nil, nil, nil, 2)
local specwarnPhantomBlast		= mod:NewSpecialWarningInterrupt(68982, false)

local warnMirroredSoul			= mod:NewTargetAnnounce(69051, 4)
local timerMirroredSoul			= mod:NewTargetTimer(8, 69051)
local timerUnleashedSouls		= mod:NewBuffActiveTimer(5, 68939)

mod:AddBoolOption("SetIconOnMirroredTarget", false)

function mod:SPELL_CAST_START(args)
	if args.spellId == 68982 then						-- Phantom Blast
		warnPhantomBlast:Show()
		specwarnPhantomBlast:Show(args.sourceName)
	elseif args.spellId == 68820 then					-- Well of Souls
		warnWellofSouls:Show()
	elseif args.spellId == 68939 then					-- Unleashed Souls
		warnUnleashedSouls:Show()
	elseif args.spellId == 68899 then					-- Wailing Souls
		warnWailingSouls:Show()
		specwarnWailingSouls:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 69051 and args:IsDestTypePlayer() then	-- Mirrored Soul
		warnMirroredSoul:Show(args.destName)
		timerMirroredSoul:Start(args.destName)
		specwarnMirroredSoul:Show(args.sourceName)--if sourcename isn't good use L.name
		if self.Options.SetIconOnMirroredTarget then 
			self:SetIcon(args.destName, 8, 8) 
		end 
	elseif args.spellId == 68939 then							-- Unleashed Souls
		timerUnleashedSouls:Start()
	end
end


function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 69051 and args:IsDestTypePlayer() then	-- Mirrored Soul
		timerMirroredSoul:Cancel(args.destName)
		if self.Options.SetIconOnMirroredTarget then 
			self:SetIcon(args.destName, 0) 
		end 
	end
end
