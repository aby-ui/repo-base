local mod	= DBM:NewMod(1237, "DBM-Party-WoD", 4, 558)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge,timewalker"
mod.upgradedMPlus = true

mod:SetRevision("20221015214135")
mod:SetCreatureID(79852)
mod:SetEncounterID(1750)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 163054",
	"SPELL_CAST_SUCCESS 178124",
	"SPELL_AURA_APPLIED 162415 178156",
	"SPELL_AURA_REMOVED 162415",
	"UNIT_SPELLCAST_SUCCEEDED boss1"
)

--[[
ability.id = 163054 and type = "begincast"
 or (ability.id = 178124) and type = "cast"
 or ability.id = 162415 and (type = "applydebuff" or type = "removedebuff")
 or ability.id = 161309 and type = "applybuff"
 or type = "dungeonencounterstart" or type = "dungeonencounterend"
--]]
--TODO, Roar cd 37 seconds? Verify
--TODO, time to feed seems MUCH longer CD now, unfortunately because of this, fight too short to get good cooldown data
local warnTimeToFeed			= mod:NewTargetNoFilterAnnounce(162415, 3)
local warnBreakout				= mod:NewTargetNoFilterAnnounce(178124, 2)

local specWarnRendingSlashes	= mod:NewSpecialWarningDodge(161239, nil, nil, nil, 3, 2)
local specWarnRoar				= mod:NewSpecialWarningSpell(163054, nil, nil, nil, 2, 2)--Did they delete this?
local specWarnTimeToFeed		= mod:NewSpecialWarningYou(162415, nil, nil, nil, 1, 2)--Can still move and attack during it, a personal warning lets a person immediately hit self heals/damage reduction abilities.
local specWarnTimeToFeedOther	= mod:NewSpecialWarningTarget(162415, "Healer", nil, nil, 1, 2)
local specWarnAcidSplash		= mod:NewSpecialWarningMove(178156, nil, nil, nil, 1, 8)

--Rending Slashes still too varaible, like 26-40
local timerTimeToFeedCD			= mod:NewCDTimer(38.1, 162415, nil, nil, nil, 3)--38-50.2 (mostly 38-42 unless delayed by doubble rending slashhes
local timerBreakoutCD			= mod:NewCDTimer(38.1, 178124, nil, nil, nil, 1)--38-50.2 (mostly 38-42 unless delayed by doubble rending slashhes

function mod:OnCombatStart(delay)
	timerBreakoutCD:Start(17.8-delay)
	timerTimeToFeedCD:Start(39-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 162415 then
		if args:IsPlayer() then
			specWarnTimeToFeed:Show()
			specWarnTimeToFeed:Play("defensive")
		elseif self.Options.SpecWarn162415target then
			specWarnTimeToFeedOther:Show(args.destName)
			specWarnTimeToFeedOther:Play("healfull")
		else
			warnTimeToFeed:Show(args.destName)
		end
	elseif args.spellId == 178156 and args:IsPlayer() and self:AntiSpam(2, 1) then
		specWarnAcidSplash:Show()
		specWarnAcidSplash:Play("watchfeet")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 162415 then
		timerTimeToFeedCD:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 163054 then--he do not target anything. so can't use target scan.
		specWarnRoar:Show()
		specWarnRoar:Play("aesoon")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 178124 then
		warnBreakout:Show(args.destName)
		timerBreakoutCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 161309 and self:AntiSpam(5, 2) then
		specWarnRendingSlashes:Show()
		specWarnRendingSlashes:Play("chargemove")
	end
end
