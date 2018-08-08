------------------------------------------------------------
-- AntorusBurningThrone.lua
--
-- Abin
-- 2017/8/31
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 7 -- Legion
local INSTANCE = 946 -- Antorus Burning Throne
local BOSS

BOSS = 1992 -- Garothi
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244410)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244536)

BOSS = 1987 -- Hounds of Sargeras
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244767)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244056)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 248819)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244057)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 248815)

BOSS = 1997 -- Antorus War Council
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244910)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244172, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244892, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244420)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 245103)

BOSS = 1985 -- Hasabel
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244613)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 245157)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244952, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244849)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 245050)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 196207)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 245118)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 245075)

BOSS = 2025 -- Eonar
module:RegisterDebuff(TIER, INSTANCE, BOSS, 248326)

BOSS = 2009 -- Imonar
module:RegisterDebuff(TIER, INSTANCE, BOSS, 248424, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247641)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247962)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247552, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247367, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247565)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 248255)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247687, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 247932)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 250255, 4)

BOSS = 2004 -- Kingaroth
module:RegisterDebuff(TIER, INSTANCE, BOSS, 246706)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244312, 5)

BOSS = 1983 -- Varimathras
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244042, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244093)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 243961)

BOSS = 1986 -- Shivarra Coven
module:RegisterDebuff(TIER, INSTANCE, BOSS, 246763)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 245586)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 245518, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244899, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244899)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 253538, 4)

BOSS = 1984 -- Aggramar
module:RegisterDebuff(TIER, INSTANCE, BOSS, 245995)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 244291)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 246014)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 243431, 5)

BOSS = 2031 -- Argus the Unmaker
module:RegisterDebuff(TIER, INSTANCE, BOSS, 251570, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 250669, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 255199, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 248499)

BOSS = 0
--module:RegisterDebuff(TIER, INSTANCE, BOSS, 0)