local mod	= DBM:NewMod("Volcanus", "DBM-Firelands")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("2019041705904")
mod:SetCreatureID(53833)
--7/14 23:59:03.242  UNIT_DIED,0x0000000000000000,nil,0x80000000,0x80000000,0xF130D2490000CE02,"Volcanus",0x10a48,0x0
mod:SetModelID(38592)
mod:SetZone()

--[RAID_BOSS_EMOTE] RAID_BOSS_EMOTE#The Branch of Nordrassil reacts violently to Ambrossia's touch!#Branch of Nordrassil#0#false", -- [1]
mod:RegisterCombat("emote_regex", L.StaffEvent)
mod:SetMinCombatTime(15)
mod:SetWipeTime(40)--You leave combat for about 35 seconds. we do 40 for good measure.

mod:RegisterEvents(
	"SPELL_CAST_START 100146",
	"RAID_BOSS_EMOTE"
)
mod.noStatistics = true

local warnRoots					= mod:NewSpellAnnounce(100146, 2)--This is cast 2 seconds before a big aoe that blows entire raid off platform. These roots are what keep raid from wiping. You dispel them AFTER the aoe to reduce raid damage, not before!
local warnPhase2				= mod:NewPhaseAnnounce(2, 3)

local timerRootsCD				= mod:NewCDTimer(17, 100146)
local timerStaffTransition		= mod:NewTimer(35, "timerStaffTransition", 2457, nil, nil, 6)--Might need tuning, hard to say if it's 35-39 as i might not have entered combat right away on my log

function mod:OnCombatStart(delay)
	timerRootsCD:Start(-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 100146 then
		warnRoots:Show()
		timerRootsCD:Start()
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg == L.StaffTransition or msg:find(L.StaffTransition) then
		timerRootsCD:Cancel()
		warnPhase2:Show()
		timerStaffTransition:Start()
	end
end
