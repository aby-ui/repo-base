local mod	= DBM:NewMod("Freya_Elders", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20190722195205")

-- passive mod to provide information for multiple fight (trash respawn)
-- mod:SetCreatureID(32914, 32915, 32913)
-- mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START 62344 62325 62932",
	"SPELL_AURA_APPLIED 62310 62928"
)

local specWarnImpale			= mod:NewSpecialWarningTaunt(62928, nil, nil, nil, 1, 2)
local specWarnFistofStone		= mod:NewSpecialWarningRun(62344, "Tank", nil, nil, 4, 2)
local specWarnGroundTremor		= mod:NewSpecialWarningCast(62932, "SpellCaster")

local timerImpale				= mod:NewTargetTimer(5, 62928)

--
-- Trash: 33430 Guardian Lasher (flower)
-- 33355 (nymph)
-- 33354 (tree)
--
-- Elder Stonebark (ground tremor / fist of stone)
-- Elder Brightleaf (unstable sunbeam)
--
--Mob IDs:
-- Elder Ironbranch: 32913
-- Elder Brightleaf: 32915
-- Elder Stonebark: 32914
--

function mod:SPELL_CAST_START(args)
	if args.spellId == 62344 then 					-- Fists of Stone
		specWarnFistofStone:Show()
		specWarnFistofStone:Play("justrun")
	elseif args:IsSpellID(62325, 62932) then		-- Ground Tremor
		specWarnGroundTremor:Show()
		specWarnGroundTremor:Play("stopcast")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(62310, 62928) then 			-- Impale
		if not args:IsPlayer() then
			specWarnImpale:Show(args.destName)
			specWarnImpale:Play("tauntboss")
		end
		timerImpale:Start(args.destName)
	end
end
