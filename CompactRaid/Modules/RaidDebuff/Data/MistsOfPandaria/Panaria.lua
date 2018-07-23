------------------------------------------------------------
-- Panaria.lua
--
-- Abin
-- 2012/10/05
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 5 -- Mists of Panaria
local INSTANCE = 322 -- Panaria
local BOSS

BOSS = 691
module:RegisterDebuff(TIER, INSTANCE, BOSS, 119622)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 119626)

BOSS = 861
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144690, 5)
