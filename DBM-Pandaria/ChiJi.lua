local mod	= DBM:NewMod(857, "DBM-Pandaria", nil, 322, 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019050334758")
mod:SetCreatureID(71952)
mod:SetReCombatTime(20)
mod:SetZone()

mod:RegisterCombat("combat_yell", L.Pull)
mod:RegisterKill("yell", L.Victory)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 144468 144471 144470 144473 144461",
	"UNIT_SPELLCAST_SUCCEEDED target focus"
)

local warnBeaconOfHope			= mod:NewTargetAnnounce(144473, 1)
local warnFirestorm				= mod:NewSpellAnnounce(144461, 2, nil, false)

local specWarnInspiringSong		= mod:NewSpecialWarningInterrupt(144468)
local specWarnBeaconOfHope		= mod:NewSpecialWarningMoveTo(144473)
local yellBeacon				= mod:NewYell(144473)
local specWarnBlazingSong		= mod:NewSpecialWarningSpell(144471, nil, nil, nil, 3)
local specWarnCraneRush			= mod:NewSpecialWarningSpell(144470, nil, nil, nil, 2)

local timerInspiringSongCD		= mod:NewCDTimer(30, 144468, nil, nil, nil, 4)--30-50sec variation?
local timerBlazingSong			= mod:NewBuffActiveTimer(15, 144471)

mod:AddReadyCheckOption(33117, false, 90)

function mod:BeaconTarget(targetname, uId)
	if not targetname then return end
	warnBeaconOfHope:Show(targetname)
	if targetname == UnitName("player") and not self:IsTanking(uId) then--Never targets tanks
		yellBeacon:Yell()
	else
		specWarnBeaconOfHope:Show(targetname)
	end
end

function mod:OnCombatStart(delay, yellTriggered)
	if yellTriggered then--We know for sure this is an actual pull and not diving into in progress
		timerInspiringSongCD:Start(20-delay)
	end
end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 144468 then
		specWarnInspiringSong:Show(args.sourceName)
		timerInspiringSongCD:Start()
	elseif spellId == 144471 then
		specWarnBlazingSong:Show()
		timerBlazingSong:Start()
	elseif spellId == 144470 then
		specWarnCraneRush:Show()
	elseif spellId == 144473 then
		warnBeaconOfHope:Show()
		specWarnBeaconOfHope:Show()
		self:BossTargetScanner(71952, "BeaconTarget", 0.1, 20)
	elseif spellId == 144461 then
		warnFirestorm:Show()
	end
end

--This method works without local and doesn't fail with curse of tongues. However, it requires at least ONE person in raid targeting boss to be running dbm (which SHOULD be most of the time)
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 148318 or spellId == 148317 or spellId == 149304 and self:AntiSpam(3, 2) then--use all 3 because i'm not sure which ones fire on repeat kills
		self:SendSync("Victory")
	end
end

function mod:OnSync(msg)
	if msg == "Victory" and self:IsInCombat() then
		DBM:EndCombat(self)
	end
end
