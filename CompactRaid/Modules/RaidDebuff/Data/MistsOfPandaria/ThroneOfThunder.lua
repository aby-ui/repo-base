------------------------------------------------------------
-- ThroneOfThunder.lua
--
-- Abin
-- 2013/3/13
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 5 -- Mists of Panaria
local INSTANCE = 362 -- Throne of Thunder
local BOSS

-- Jin'rokh the Breaker (827)
BOSS = 827
module:RegisterDebuff(TIER, INSTANCE, BOSS, 138002, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 138349)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 137423, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 138732, 5)

-- Horridon (819)
BOSS = 819
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136767, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136708)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136719)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136653)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136587)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136710)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136670)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136513)

-- Council of Elders (816)
BOSS = 816
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136903)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136917)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136922)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136878)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136857)

-- Tortos (825)
BOSS = 825
module:RegisterDebuff(TIER, INSTANCE, BOSS, 137633)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 140701, 4)

-- Megaera (821)
BOSS = 821
module:RegisterDebuff(TIER, INSTANCE, BOSS, 137731)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 139822, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 139841)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 139839)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 140179, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 139993)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 139857, 5)

-- Ji-Kun (828)
BOSS = 828
module:RegisterDebuff(TIER, INSTANCE, BOSS, 134366, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 140571, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 133755)

-- Durumu the Forgotten (818)
BOSS = 818
module:RegisterDebuff(TIER, INSTANCE, BOSS, 133767, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 133768, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 133795)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 133597)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 133598)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 133792, 4)

-- Primordius (820)
BOSS = 820
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136050, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 140546)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136185, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136187, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136183, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136181, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136228, 5)

-- Dark Animus (824)
BOSS = 824
module:RegisterDebuff(TIER, INSTANCE, BOSS, 133843, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 138618)
--module:RegisterDebuff(TIER, INSTANCE, BOSS, 138659, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136962, 5)

-- Iron Qon (817)
BOSS = 817
module:RegisterDebuff(TIER, INSTANCE, BOSS, 134691, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 134647)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136193)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 137669)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136892)

-- Twin Consorts (829)
BOSS = 829
module:RegisterDebuff(TIER, INSTANCE, BOSS, 137341)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 137360, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 137440)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 137408, 4)

-- Lei Shen (832)
BOSS = 832
module:RegisterDebuff(TIER, INSTANCE, BOSS, 134912, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136478)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 135695, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136295, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 136914, 4)

-- Common
module:RegisterDebuff(TIER, INSTANCE, 0, 140049)
module:RegisterDebuff(TIER, INSTANCE, 0, 140629)
module:RegisterDebuff(TIER, INSTANCE, 0, 138742)
module:RegisterDebuff(TIER, INSTANCE, 0, 140682)
