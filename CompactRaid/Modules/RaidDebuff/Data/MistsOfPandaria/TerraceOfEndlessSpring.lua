------------------------------------------------------------
-- TerraceOfEndlessSpring.lua
--
-- Abin
-- 2012/10/05
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 5 -- Mists of Panaria
local INSTANCE = 320 -- Terrace of Endless Spring
local BOSS

-- Protectors of the Endless (683)
BOSS = 683
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122874)

-- Tsulong (742)
BOSS = 742
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122752, 5)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 122768)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123036)

-- Lei Shi (729)
BOSS = 729
module:RegisterDebuff(TIER, INSTANCE, BOSS, 123121)

-- Sha of Fear (709)
BOSS = 709
module:RegisterDebuff(TIER, INSTANCE, BOSS, 119086)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 119775, 4)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 119985)
module:RegisterDebuff(TIER, INSTANCE, BOSS, 120629)

-- Minors
module:RegisterDebuff(TIER, INSTANCE, 0, 125758)
