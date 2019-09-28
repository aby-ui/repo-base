local mod	= DBM:NewMod(118, "DBM-Party-Cataclysm", 5, 69)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190417010024")
mod:SetCreatureID(43614)
--mod:SetEncounterID(1054)--Disabled because it's likely not correct since him and augh are split.
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 81690 81630 81706",
	"SPELL_AURA_REFRESH 81690 81630",
	"SPELL_AURA_REMOVED 81690",
	"SPELL_CAST_SUCCESS 81642"
)

local warnScentBlood	= mod:NewTargetNoFilterAnnounce(81690, 3)
local warnPoison		= mod:NewTargetNoFilterAnnounce(81630, 3, nil, "RemovePoison", 2)
local warnDustFlail		= mod:NewSpellAnnounce(81642, 3)
local warnEnrage		= mod:NewSpellAnnounce(81706, 4)

local yellScentBlood	= mod:NewYell(81690)

local timerScentBlood	= mod:NewTargetTimer(30, 81690, nil, nil, nil, 3)
local timerDustFlail	= mod:NewBuffActiveTimer(5, 81642, nil, nil, nil, 3)

mod:AddBoolOption("RangeFrame")

function mod:OnCombatStart(delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(5)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 81690 then
		warnScentBlood:Show(args.destName)
		timerScentBlood:Start(args.destName)
		if args:IsPlayer() then
			yellScentBlood:Yell()
		end
	elseif spellId == 81630 then
		warnPoison:CombinedShow(0.3, args.destName)
	elseif spellId == 81706 then
		warnEnrage:Show()
	end
end
mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 81690 then
		timerScentBlood:Cancel(args.destName)
	end
end


function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 81642 then
		warnDustFlail:Show()
		timerDustFlail:Start()
	end
end
