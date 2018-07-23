------------------------------------------------------------
-- HeartOfFear.lua
--
-- Abin
-- 2012/10/05
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 5 -- Mists of Panaria
local INSTANCE = 330 -- Heart of Fear
local BOSS

-- Imperial Vizier Zor'lok (745)
BOSS = 745
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122761)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123812)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122706)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122740, 5)

-- Blade Lord Ta'yak (744)
BOSS = 744
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122994)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123474)

-- Garalon (713)
BOSS = 713
module:RegisterDebuff(TIER, INSTANCE, BOSS, 129815)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123081)

-- Wind Lord Mel'jarak (741)
BOSS = 741
module:RegisterDebuff(TIER, INSTANCE, BOSS, 121881)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122064)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122409)

-- Amber-Shaper Un'sok (737)
BOSS = 737
module:RegisterDebuff(TIER, INSTANCE, BOSS, 121949)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122370, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122389)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122413)

-- Grand Empress Shek'zeer (743)
BOSS = 743
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123707)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123713)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123735)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 124863)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 125638)

