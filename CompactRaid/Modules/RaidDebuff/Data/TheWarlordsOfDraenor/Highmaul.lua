------------------------------------------------------------
-- Highmaul.lua
--
-- Abin
-- 2014/10/19
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 6 -- The Warlords of Draenor
local INSTANCE = 477 -- Highmaul
local BOSS

-- Kargath Bladefist
BOSS = 1128
module:RegisterDebuff(TIER, INSTANCE, BOSS, 159113)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 159178, 5)

-- The Butcher
BOSS = 971
module:RegisterDebuff(TIER, INSTANCE, BOSS, 156152, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 156143)

-- Tectus
BOSS = 1195

-- Brackenspore
BOSS = 1196
module:RegisterDebuff(TIER, INSTANCE, BOSS, 163242)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 159463)

-- Twin Ogron
BOSS = 1148
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143834)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 174404)

-- Ko'ragh
BOSS = 1153
module:RegisterDebuff(TIER, INSTANCE, BOSS, 163134)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 161242)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 162186, 5)

-- Imperator Mar'gok
BOSS = 1197
module:RegisterDebuff(TIER, INSTANCE, BOSS, 156238)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 159515)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 158605, 5)

-- Common

