------------------------------------------------------------
-- Azurethos.lua
--
-- Abin
-- 2018/08/31
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 8 -- BFA
local INSTANCE = 1028 -- Azurethos
local BOSS

BOSS = 2139 -- Tzane
module:RegisterDebuff(TIER, INSTANCE, BOSS, 261552)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 261632, 5)

BOSS = 2141 -- Jiarak
module:RegisterDebuff(TIER, INSTANCE, BOSS, 261509, 5)

BOSS = 2197 -- Hailstone Construct
module:RegisterDebuff(TIER, INSTANCE, BOSS, 274891)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 274895)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 274896)

BOSS = 2199 -- VS
module:RegisterDebuff(TIER, INSTANCE, BOSS, 274839)

BOSS = 2213 -- Doom's Howl
module:RegisterDebuff(TIER, INSTANCE, BOSS, 271246)

BOSS = 2198 -- Yenajz
module:RegisterDebuff(TIER, INSTANCE, BOSS, 274904)

BOSS = 2210 -- Kraulok
