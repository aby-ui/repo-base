------------------------------------------------------------
-- TheNighthold.lua
--
-- Abin
-- 2016/09/13
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 7 -- Legion
local INSTANCE = 786 -- The Nighthold
local BOSS

BOSS = 1706
module:RegisterDebuff(TIER, INSTANCE, BOSS, 204531)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 204483)

BOSS = 1725
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206607)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206607)

BOSS = 1731
module:RegisterDebuff(TIER, INSTANCE, BOSS, 208506)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206788)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206641)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 208924)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206798)

BOSS = 1751
module:RegisterDebuff(TIER, INSTANCE, BOSS, 212587)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 213328)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 212494)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 224234)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 212647)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 213166)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 213621)

BOSS = 1762
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206480)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206365)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 212795)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 216040)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 208230)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 225003)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 224944)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 216024)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 224982)

BOSS = 1713
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206677)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 205344)

BOSS = 1761
module:RegisterDebuff(TIER, INSTANCE, BOSS, 218424)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 218502)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 218342, 5)

BOSS = 1732
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206936)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 205649)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206464)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 207720)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206585)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206388)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206589)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206965)

BOSS = 1743
module:RegisterDebuff(TIER, INSTANCE, BOSS, 210387)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 209973)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 209244)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 209598)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 211887)

BOSS = 1737
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206222)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206883)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 208536)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 208802)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206384, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 221606, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206896)

BOSS = 0
module:RegisterDebuff(TIER, INSTANCE, BOSS, 224440)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 230994)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 222079)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 222101)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 224995)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 225583)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 234585)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 224944)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 206847, 5)