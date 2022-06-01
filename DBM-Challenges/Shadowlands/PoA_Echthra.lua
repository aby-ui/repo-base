local mod	= DBM:NewMod("Echthra", "DBM-Challenges", 1)
--local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic,challenge"

mod:SetRevision("20220530062110")
mod:SetCreatureID(172177)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 336096 336715 336709",
	"UNIT_SPELLCAST_SUCCEEDED"
)

--TODO, collect more pulls for "Foul Waste-336715-npc:172177 = pull:169.1, 21.4, 12.2, 16.3, 21.8, 21.5", -- [2]
local warnFoulWaste							= mod:NewSpellAnnounce(336715, 2)
local warnSummonCrawlers					= mod:NewSpellAnnounce(336709, 2)

local specWarnBefuddlingFumes				= mod:NewSpecialWarningDodge(336096, nil, nil, nil, 2, 2)

local timerBefuddlingFumesCD				= mod:NewCDTimer(23.1, 336096, nil, nil, nil, 3)
--local timerFoulWasteCD					= mod:NewCDTimer(12.2, 336715, nil, nil, nil, 3)--12.2-21.8
local timerSummonCrawlersCD					= mod:NewCDTimer(15.7, 336709, nil, nil, nil, 1)

local berserkTimer							= mod:NewBerserkTimer(480)

function mod:OnCombatStart(delay)
	timerSummonCrawlersCD:Start(5-delay)
	--timerFoulWasteCD:Start(9.7-delay)
	timerBefuddlingFumesCD:Start(23.1-delay)
	if self:IsHard() then
		berserkTimer:Start(100-delay)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 336096 then
		specWarnBefuddlingFumes:Show()
		specWarnBefuddlingFumes:Play("shockwave")
		timerBefuddlingFumesCD:Start()
	elseif spellId == 336715 then
		warnFoulWaste:Show()
--		timerFoulWasteCD:Start()
	elseif spellId == 336709 then
		warnSummonCrawlers:Show()
		timerSummonCrawlersCD:Start()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 333198 then--[DNT] Set World State: Win Encounter-
		DBM:EndCombat(self)
	end
end
