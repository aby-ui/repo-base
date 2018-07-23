------------------------------------------------------------
-- Draenor.lua
--
-- Abin
-- 2014/10/19
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 6 -- The Warlords of Draenor
local INSTANCE = 557 -- Draenor
local BOSS

BOSS = 1291
module:RegisterDebuff(TIER, INSTANCE, BOSS, 175915)

BOSS = 1211
module:RegisterDebuff(TIER, INSTANCE, BOSS, 175973)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 176001)

BOSS = 1262
module:RegisterDebuff(TIER, INSTANCE, BOSS, 167615)

BOSS = 1452
module:RegisterDebuff(TIER, INSTANCE, BOSS, 187664)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 187668)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 187471)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 187667, 5)
