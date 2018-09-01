------------------------------------------------------------
-- Uldir.lua
--
-- Abin
-- 2018/08/31
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 8 -- BFA
local INSTANCE = 1031 -- Uldir
local BOSS

BOSS = 2168 -- Taloc
module:RegisterDebuff(TIER, INSTANCE, BOSS, 271222, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 270290)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 270296)

BOSS = 2167 -- Mother
module:RegisterDebuff(TIER, INSTANCE, BOSS, 267787, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 268198)

BOSS = 2146 -- Fetid Devourer
module:RegisterDebuff(TIER, INSTANCE, BOSS, 262313)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 262314, 4)

BOSS = 2169 -- Zekvhozj
module:RegisterDebuff(TIER, INSTANCE, BOSS, 265662)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 265264, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 265646, 5)

BOSS = 2166 -- Vectis
module:RegisterDebuff(TIER, INSTANCE, BOSS, 265129)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 265127, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 265206, 2)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 266948)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 265212, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 265174, 5)

BOSS = 2195 -- Zul
module:RegisterDebuff(TIER, INSTANCE, BOSS, 274195, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 273365, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 274271, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 274358)

BOSS = 2194 -- Mythrax
module:RegisterDebuff(TIER, INSTANCE, BOSS, 272336, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 272536, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 273282, 4)

BOSS = 2147 -- Ghuun
module:RegisterDebuff(TIER, INSTANCE, BOSS, 263372)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 263334)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 267700, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 267409, 5)

BOSS = 0 -- Trash
