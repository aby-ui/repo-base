local mod	= DBM:NewMod("d288", "DBM-WorldEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190423232607")
mod:SetCreatureID(36272, 36296, 36565)
mod:SetModelID(16176)
mod:SetZone()

mod:SetReCombatTime(10)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_SAY"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 68821",
	"SPELL_PERIODIC_DAMAGE 68927 68934",
	"SPELL_PERIODIC_MISSED 68927 68934"
)

local warnChainReaction			= mod:NewCastAnnounce(68821, 3, nil, nil, "Melee", 2)

local specWarnGTFO				= mod:NewSpecialWarningGTFO(68927, nil, nil, nil, 1, 8)

local timerHummel				= mod:NewTimer(10.5, "HummelActive", "132349", nil, false, "TrioActiveTimer")
local timerBaxter				= mod:NewTimer(16.5, "BaxterActive", "132349", nil, false, "TrioActiveTimer")
local timerFrye					= mod:NewTimer(25.5, "FryeActive", "132349", nil, false, "TrioActiveTimer")
mod:AddBoolOption("TrioActiveTimer", true, "timer", nil, 1)

function mod:SPELL_CAST_START(args)
	if args.spellId == 68821 and self:AntiSpam(3, 1) then
		warnChainReaction:Show()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if (spellId == 68927 or spellId == 68934) and destGUID == UnitGUID("player") and self:AntiSpam(3, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:CHAT_MSG_MONSTER_SAY(msg)
	if msg == L.SayCombatStart or msg:find(L.SayCombatStart) then
		self:SendSync("TrioPulled")
	end
end

function mod:OnSync(msg)
	if msg == "TrioPulled" then
		if self.Options.TrioActiveTimer then
			timerHummel:Start()
			timerBaxter:Start()
			timerFrye:Start()
		end
	end
end
