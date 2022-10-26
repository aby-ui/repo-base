local mod	= DBM:NewMod(1835, "DBM-Party-Legion", 11, 860)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "heroic,mythic,challenge"

mod:SetRevision("20221016002954")
mod:SetCreatureID(114262, 114264)--114264 midnight
mod:SetEncounterID(1960)--Verify
mod:SetUsedIcons(1)
--mod:SetHotfixNoticeRev(14922)
--mod.respawnTime = 30

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 227363 227365 227339 227493 228852",
	"VEHICLE_ANGLE_UPDATE",
	"UNIT_SPELLCAST_SUCCEEDED boss1 boss2"
)

--Most of midnights timers are too short to really be worth including. he either spams charge or spams spectral chargers.
local specWarnMightyStomp			= mod:NewSpecialWarningCast(227363, "SpellCaster", nil, nil, 1, 2)
local specWarnSpectralCharge		= mod:NewSpecialWarningDodge(227365, nil, nil, nil, 2, 2)
--On Foot
local specWarnMezair				= mod:NewSpecialWarningDodge(227339, nil, nil, nil, 1, 2)
local specWarnMortalStrike			= mod:NewSpecialWarningDefensive(227493, nil, nil, 2, 1, 2)
local specWarnSharedSuffering		= mod:NewSpecialWarningMoveTo(228852, nil, nil, nil, 3, 2)
local yellSharedSuffering			= mod:NewYell(228852)

local timerMortalStrikeCD			= mod:NewNextTimer(11, 227493, nil, "Tank", nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerSharedSufferingCD		= mod:NewNextTimer(19, 228852, nil, nil, nil, 3, nil, nil, nil, 1, 4)

mod:AddSetIconOption("SetIconOnSharedSuffering", 228852, true, false, {1})

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 227363 then
		specWarnMightyStomp:Show()
		specWarnMightyStomp:Play("stopcast")
	elseif spellId == 227365 then
		specWarnSpectralCharge:Show()
		specWarnSpectralCharge:Play("watchstep")
	elseif spellId == 227339 then
		specWarnMezair:Show()
		specWarnMezair:Play("chargemove")
	elseif spellId == 227493 then
		if self:IsTanking("player", nil, nil, true, args.sourceGUID) then
			specWarnMortalStrike:Show()
			specWarnMortalStrike:Play("defensive")
		end
	elseif spellId == 228852 then
		local targetName = TANK
		local unitIsPlayer = false
		for uId in DBM:GetGroupMembers() do
			if self:IsTanking(uId) then
				targetName = UnitName(uId)
				if UnitIsUnit("player", uId) then
					unitIsPlayer = true
				end
				if self.Options.SetIconOnSharedSuffering then
					self:SetIcon(args.destName, 1, 4)
				end
				break
			end
		end
		if unitIsPlayer then
			yellSharedSuffering:Yell()
		else
			specWarnSharedSuffering:Show(targetName)
			specWarnSharedSuffering:Play("gathershare")
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 227338 then--Riderless
		timerMortalStrikeCD:Start()
		timerSharedSufferingCD:Start()
	elseif spellId == 227584 or spellId == 227601 then--Mounted or Intermission
		timerMortalStrikeCD:Stop()
		timerSharedSufferingCD:Stop()
	end
end

