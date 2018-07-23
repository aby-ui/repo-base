------------------------------------------------------------
-- PartyDungeons.lua
--
-- Abin
-- 2014/10/19
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 6 -- The Warlords of Draenor

-- Upper Blackrock Spire (559)
module:RegisterDebuff(TIER, 559, 0, 161288)
module:RegisterDebuff(TIER, 559, 0, 155031)

-- Shadowmoon Burial Grounds (537)
module:RegisterDebuff(TIER, 537, 0, 162652)

-- The Everbloom (556)
module:RegisterDebuff(TIER, 556, 0, 164294)
module:RegisterDebuff(TIER, 556, 0, 168187)
module:RegisterDebuff(TIER, 556, 0, 169179)
module:RegisterDebuff(TIER, 556, 0, 164836)
module:RegisterDebuff(TIER, 556, 0, 169376, 5)
module:RegisterDebuff(TIER, 556, 0, 170124, 5)
module:RegisterDebuff(TIER, 556, 0, 164965, 5)

-- Grimrail Depot (536)
module:RegisterDebuff(TIER, 536, 0, 161089)
module:RegisterDebuff(TIER, 536, 0, 160681)
module:RegisterDebuff(TIER, 536, 0, 162058)
module:RegisterDebuff(TIER, 536, 0, 162066)
module:RegisterDebuff(TIER, 536, 0, 176027)

-- Skyreach (476)
module:RegisterDebuff(TIER, 476, 0, 154149)
module:RegisterDebuff(TIER, 476, 0, 153794)
module:RegisterDebuff(TIER, 476, 0, 153795)
module:RegisterDebuff(TIER, 476, 0, 154043)

-- Auchindoun (547)
module:RegisterDebuff(TIER, 547, 0, 153006)
module:RegisterDebuff(TIER, 547, 0, 153477)
module:RegisterDebuff(TIER, 547, 0, 154018)
module:RegisterDebuff(TIER, 547, 0, 153396, 5)
module:RegisterDebuff(TIER, 547, 0, 156921, 5)
module:RegisterDebuff(TIER, 547, 0, 156842)
module:RegisterDebuff(TIER, 547, 0, 156964)

-- Iron Docks (558)
module:RegisterDebuff(TIER, 558, 0, 163390)
module:RegisterDebuff(TIER, 558, 0, 162418, 5)
module:RegisterDebuff(TIER, 558, 0, 162415, 5)

-- Bloodmaul Slag Mines (385)
module:RegisterDebuff(TIER, 385, 0, 149997)
module:RegisterDebuff(TIER, 385, 0, 149975, 5)
module:RegisterDebuff(TIER, 385, 0, 150032, 5)
module:RegisterDebuff(TIER, 385, 0, 149941)
module:RegisterDebuff(TIER, 385, 0, 150023)
module:RegisterDebuff(TIER, 385, 0, 150745)
module:RegisterDebuff(TIER, 385, 0, 151697)


