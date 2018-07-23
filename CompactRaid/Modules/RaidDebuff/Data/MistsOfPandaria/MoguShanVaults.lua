------------------------------------------------------------
-- MoguShanVaults.lua
--
-- Abin
-- 2012/10/05
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 5 -- Mists of Panaria
local INSTANCE = 317 -- Mogu'shan Vaults
local BOSS

-- The Stone Guard (679)
BOSS = 679
module:RegisterDebuff(TIER, INSTANCE, BOSS, 130395)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 125206)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116322)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116199)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116301)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116304)

-- Feng the Accursed (689)
BOSS = 689
module:RegisterDebuff(TIER, INSTANCE, BOSS, 131788)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116040)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116942, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116784, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 131790, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116577, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 131792, 4)

-- Gara'jal the Spiritbinder (682)
BOSS = 682
module:RegisterDebuff(TIER, INSTANCE, BOSS, 96689)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 117723)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116000)

-- The Spirit Kings (687)
BOSS = 687
module:RegisterDebuff(TIER, INSTANCE, BOSS, 117708)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 118047)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 118141)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 118163)

-- Elegon (726)
BOSS = 726
module:RegisterDebuff(TIER, INSTANCE, BOSS, 117949)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 132226)

-- Will of the Emperor (677)
BOSS = 677
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116525)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 117485)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116835)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 132425)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 116829)
