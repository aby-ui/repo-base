------------------------------------------------------------
-- Kiljaeden.lua
--
-- Displays "Bursting Dreadflame" as raid debuff on CompactRaid unit frames.
--
-- Abin
-- 2017/8/27
------------------------------------------------------------

local GetTime = GetTime

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local BOSS_NAME = EJ_GetEncounterInfo(1898) -- Kiljaeden
local SPELL_ID = 238430 -- Bursting Dreadflame
local _, _, SPELL_ICON = GetSpellInfo(SPELL_ID) -- Spell icon
local SPELL_DURATION = 5 -- Spell duration

local object = CompactRaid:EmbedEventObject()

function object:COMBAT_LOG_EVENT_UNFILTERED()
    local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId, spellName = CombatLogGetCurrentEventInfo()
	if event == "SPELL_CAST_SUCCESS" and spellId == SPELL_ID and destGUID and sourceName == BOSS_NAME then
		module:SetOverrideDebuff(destGUID, SPELL_ICON, 1, nil, GetTime() + SPELL_DURATION)
	end
end

CompactRaid:RegisterEventCallback("RaidDebuff_OnEncounterBegin", function(bossName)
	if bossName == BOSS_NAME then
		object:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end)

CompactRaid:RegisterEventCallback("RaidDebuff_OnEncounterEnd", function(bossName)
	if bossName == BOSS_NAME then
		object:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end)