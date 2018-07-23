------------------------------------------------------------
-- SiegeOfOrgrimmar.lua
--
-- Abin
-- 2013/9/12
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 5 -- Mists of Panaria
local INSTANCE = 369 -- Siege of Orgrimmar
local BOSS

-- Immerseus (852)
BOSS = 852
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143437, 5)

-- The Fallen Protectors (849)
BOSS = 849
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143962)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144396)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143023)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143009)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143840, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 147383, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143198, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143301)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143879)

-- Norushen (866)
BOSS = 866
module:RegisterDebuff(TIER, INSTANCE, BOSS, 146124)

-- Sha of Pride (867)
BOSS = 867
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144364)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 146595, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 146817, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144843)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144351, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144358)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144684)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144774)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 147207)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 147028)

-- Galakras (881)
BOSS = 881
module:RegisterDebuff(TIER, INSTANCE, BOSS, 146902)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 147705)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 146764, 2)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 147068, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 147042)

-- Iron Juggernaut (864)
BOSS = 864
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144459)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144467)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144498)

-- Kor'kron Dark Shaman (856)
BOSS = 856
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144304)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144215)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144107, 1)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144331, 5)

-- General Nazgrim (850)
BOSS = 850
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143494)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143638)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143480)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143882)

-- Malkorok (846)
BOSS = 846
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142990, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142863)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142864)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142865)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142913, 5)

-- Spoils of Pandaria (870)
BOSS = 870
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142983)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 145218)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122962)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 146289)

-- Thok the Bloodthirsty (851)
BOSS = 851
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143426)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143452)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 146540)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143780)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143791)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143773, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 133636)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143767)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143777, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143766, 5)

-- Siegecrafter Blackfuse (865)
BOSS = 865
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143385)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143856)

-- Paragons of the Klaxxi (853)
BOSS = 853
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142931, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142315)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142929)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142877)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142668)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143702, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143275)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143279)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 143339)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 142948, 4)

-- Garrosh Hellscream (869)
BOSS = 869
module:RegisterDebuff(TIER, INSTANCE, BOSS, 144582, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 145183, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 145175, 5)

-- Common
module:RegisterDebuff(TIER, INSTANCE, 0, 145553, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 25195)
module:RegisterDebuff(TIER, INSTANCE, 0, 145999)
module:RegisterDebuff(TIER, INSTANCE, 0, 145861)
module:RegisterDebuff(TIER, INSTANCE, 0, 136670, 4)
module:RegisterDebuff(TIER, INSTANCE, 0, 147642)
module:RegisterDebuff(TIER, INSTANCE, 0, 146537, 5)
module:RegisterDebuff(TIER, INSTANCE, 0, 147554)
module:RegisterDebuff(TIER, INSTANCE, 0, 148456)
