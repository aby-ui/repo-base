------------------------------------------------------------
-- BlackwingDescent.lua
--
-- Abin
-- 2011/1/07
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 4 -- Cataclysm
local INSTANCE = 73 -- Blackwing Descent

-- Omnotron Defense System (169)

module:RegisterDebuff(TIER, INSTANCE, 169, 79888) --Lightning Conductor
module:RegisterDebuff(TIER, INSTANCE, 169, 80161) --Chemical Cloud
module:RegisterDebuff(TIER, INSTANCE, 169, 80011) --Soaked in Poison
module:RegisterDebuff(TIER, INSTANCE, 169, 79505) --Flamethrower
module:RegisterDebuff(TIER, INSTANCE, 169, 80094) --Fixate
module:RegisterDebuff(TIER, INSTANCE, 169, 79501) --Acquiring Target

-- Magmaw (170)

module:RegisterDebuff(TIER, INSTANCE, 170, 89773) --Mangle
module:RegisterDebuff(TIER, INSTANCE, 170, 78941) --Parasitic Infection

-- Atramedes (171)

module:RegisterDebuff(TIER, INSTANCE, 171, 78092) --Tracking
module:RegisterDebuff(TIER, INSTANCE, 171, 77982) --Searing Flame
module:RegisterDebuff(TIER, INSTANCE, 171, 78023) --Roaring Flame
module:RegisterDebuff(TIER, INSTANCE, 171, 78897) --Noisy!

-- Chimaeron (172)

module:RegisterDebuff(TIER, INSTANCE, 172, 89084) --Low Health
module:RegisterDebuff(TIER, INSTANCE, 172, 82890) --Mortality
module:RegisterDebuff(TIER, INSTANCE, 172, 82935) --Caustic Slime
module:RegisterDebuff(TIER, INSTANCE, 172, 82881) --Break

-- Maloriak (173)

module:RegisterDebuff(TIER, INSTANCE, 173, 78034) --Rend
module:RegisterDebuff(TIER, INSTANCE, 173, 78225) --Acid Nova
module:RegisterDebuff(TIER, INSTANCE, 173, 77615) --Debilitating Slime
module:RegisterDebuff(TIER, INSTANCE, 173, 77786) --Consuming Flames
module:RegisterDebuff(TIER, INSTANCE, 173, 78617) --Fixate
module:RegisterDebuff(TIER, INSTANCE, 173, 77760) --Biting Chill
module:RegisterDebuff(TIER, INSTANCE, 173, 77699) --Flash Freeze

-- Nefarian (174)

module:RegisterDebuff(TIER, INSTANCE, 174, 81118) --Magma
module:RegisterDebuff(TIER, INSTANCE, 174, 77827) --Tail Lash

-- Trash

module:RegisterDebuff(TIER, INSTANCE, 0, 80390) --Mortal Strike
module:RegisterDebuff(TIER, INSTANCE, 0, 80270) --Shadowflame
module:RegisterDebuff(TIER, INSTANCE, 0, 80145) --Piercing Grip
module:RegisterDebuff(TIER, INSTANCE, 0, 80727) --Execution Sentence
module:RegisterDebuff(TIER, INSTANCE, 0, 80345) --Corrosive Acid
module:RegisterDebuff(TIER, INSTANCE, 0, 80329) --Time Lapse
module:RegisterDebuff(TIER, INSTANCE, 0, 79630) --Drakonid Rush
module:RegisterDebuff(TIER, INSTANCE, 0, 79589) --Constricting Chains
module:RegisterDebuff(TIER, INSTANCE, 0, 79580) --Overhead Smash
module:RegisterDebuff(TIER, INSTANCE, 0, 81060) --Flash Bomb
