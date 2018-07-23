------------------------------------------------------------
-- TombofSargeras.lua
--
-- Abin
-- 2017/06/06
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 7 -- Legion
local INSTANCE = 875 -- Tomb of Sargeras
local BOSS

BOSS = 1862
module:RegisterDebuff(TIER, INSTANCE, BOSS, 233279)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 230345)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 231363, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236329)

BOSS = 1867
module:RegisterDebuff(TIER, INSTANCE, BOSS, 233430)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 233983, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 248713)

BOSS = 1856
module:RegisterDebuff(TIER, INSTANCE, BOSS, 231770)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 231998, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 234016, 5)

BOSS = 1903
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236603)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 234995)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 234996)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236519)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236547, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236550)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 239264)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 237351, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236712, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 237561)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236305, 4)

BOSS = 1861
module:RegisterDebuff(TIER, INSTANCE, BOSS, 230959)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 230201)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 234661, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 230139)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 232754)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 232913)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 240169)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 230362)

BOSS = 1896
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236449)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236515)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236513)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 235989, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236340, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236138, 5)

BOSS = 1897
module:RegisterDebuff(TIER, INSTANCE, BOSS, 235117, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 235534)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 235538)

BOSS = 1873
module:RegisterDebuff(TIER, INSTANCE, BOSS, 239739)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236494)

BOSS = 1898
module:RegisterDebuff(TIER, INSTANCE, BOSS, 239155)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 234310)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 236710, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 239932, 5)

BOSS = 0

module:RegisterDebuff(TIER, INSTANCE, BOSS, 240706)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 239810)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 240737)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 241171)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 241009)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 239666)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 241234)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 241237)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 241116)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 241703)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 243298)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 33086)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 240599)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 241276)