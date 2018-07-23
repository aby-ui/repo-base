------------------------------------------------------------
-- Argus.lua
--
-- Abin
-- 2017/8/31
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 7 -- Legion
local INSTANCE = 959 -- Argus
local BOSS

BOSS = 2010 -- Folnuna
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247361, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247389)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247411)

BOSS = 2011 -- Alluradel
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247551, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247544)

BOSS = 2012 -- Meto
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247495)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247492)

BOSS = 2013 -- Occularus
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247332, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247318)

BOSS = 2014 -- Sotanathor
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247698)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247444, 5)


BOSS = 2015 -- Vilemus
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247731)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247739)