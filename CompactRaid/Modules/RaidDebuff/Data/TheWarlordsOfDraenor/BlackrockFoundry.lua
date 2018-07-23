------------------------------------------------------------
-- BlackrockFoundry.lua
--
-- Abin
-- 2014/10/19
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 6 -- The Warlords of Draenor
local INSTANCE = 457 -- Black rock Foundry
local BOSS

-- Gruul
BOSS = 1161
module:RegisterDebuff(TIER, INSTANCE, BOSS, 155326)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 162322, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 155506)

-- Oregorger
BOSS = 1202
module:RegisterDebuff(TIER, INSTANCE, BOSS, 156324)

-- Beastlord Darmac
BOSS = 1122
module:RegisterDebuff(TIER, INSTANCE, BOSS, 155365, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 155399, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 154989)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 155499)

-- Flamebender Ka'graz
BOSS = 1123
module:RegisterDebuff(TIER, INSTANCE, BOSS, 155277, 5)

-- Hans'gar and Franzok
BOSS = 1155
module:RegisterDebuff(TIER, INSTANCE, BOSS, 157139)

-- Operator Thogar
BOSS = 1147
module:RegisterDebuff(TIER, INSTANCE, BOSS, 155921)

-- The Blast Furnace
BOSS = 1154
module:RegisterDebuff(TIER, INSTANCE, BOSS, 155240)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 155242)

-- Kromog
BOSS = 1162
module:RegisterDebuff(TIER, INSTANCE, BOSS, 157060)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 156766, 5)

-- The Iron Maidens
BOSS = 1203
module:RegisterDebuff(TIER, INSTANCE, BOSS, 158315)

-- Blackhand
BOSS = 959
module:RegisterDebuff(TIER, INSTANCE, BOSS, 156096)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 156653, 4)

-- Common

