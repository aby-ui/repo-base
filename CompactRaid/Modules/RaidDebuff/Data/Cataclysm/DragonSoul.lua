------------------------------------------------------------
-- DragonSoul.lua
-- Abin
-- 2011/12/05
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 4 -- Cataclysm
local INSTANCE = 187 -- Dragon Soul

-- Morchok (311)

module:RegisterDebuff(TIER, INSTANCE, 311, 103687, 5) --Crush Armor
module:RegisterDebuff(TIER, INSTANCE, 311, 103785) --Black Blood of the Earth
module:RegisterDebuff(TIER, INSTANCE, 311, 103534) --Danger (Red)
module:RegisterDebuff(TIER, INSTANCE, 311, 103536) --Warning (Yellow)

-- Warlord Zon'ozz (324)

module:RegisterDebuff(TIER, INSTANCE, 324, 103434, 5) --Disrupting Shadows (dispellable)

-- Yor'sahj the Unsleeping (325)

module:RegisterDebuff(TIER, INSTANCE, 325, 104849) --Void Bolt
module:RegisterDebuff(TIER, INSTANCE, 325, 105171, 5) --Deep Corruption

-- Hagara the Stormbinder (317)

module:RegisterDebuff(TIER, INSTANCE, 317, 105289) --Shattered Ice (dispellable)
module:RegisterDebuff(TIER, INSTANCE, 317, 105285) --Target (next Ice Lance)
module:RegisterDebuff(TIER, INSTANCE, 317, 104451, 5) --Ice Tomb
module:RegisterDebuff(TIER, INSTANCE, 317, 109423)
module:RegisterDebuff(TIER, INSTANCE, 317, 109333)
module:RegisterDebuff(TIER, INSTANCE, 317, 105297, 4) -- Ice Lance
module:RegisterDebuff(TIER, INSTANCE, 317, 109325, 4)

-- Ultraxion (331)

module:RegisterDebuff(TIER, INSTANCE, 331, 105925, 5) --Fading Light
module:RegisterDebuff(TIER, INSTANCE, 331, 106108) --Heroic Will
module:RegisterDebuff(TIER, INSTANCE, 331, 105984) --Timeloop
module:RegisterDebuff(TIER, INSTANCE, 331, 105927) --Faded Into Twilight

-- Warmaster Blackhorn (332)

module:RegisterDebuff(TIER, INSTANCE, 332, 108043, 5) --Sunder Armor
module:RegisterDebuff(TIER, INSTANCE, 332, 107567) --Brutal Strike
module:RegisterDebuff(TIER, INSTANCE, 332, 108046) --Shockwave
module:RegisterDebuff(TIER, INSTANCE, 332, 110214, 4)

-- Spine of Deathwing (318)

module:RegisterDebuff(TIER, INSTANCE, 318, 105563) --Grasping Tendrils
module:RegisterDebuff(TIER, INSTANCE, 318, 105479, 3) --Searing Plasma
module:RegisterDebuff(TIER, INSTANCE, 318, 105490, 5) --Fiery Grip
module:RegisterDebuff(TIER, INSTANCE, 318, 106199, 4)
module:RegisterDebuff(TIER, INSTANCE, 318, 106200, 4)

-- Madness of Deathwing (333)

module:RegisterDebuff(TIER, INSTANCE, 333, 105445) --Blistering Heat
module:RegisterDebuff(TIER, INSTANCE, 333, 105841) --Degenerative Bite
module:RegisterDebuff(TIER, INSTANCE, 333, 106730) --Tetanus
module:RegisterDebuff(TIER, INSTANCE, 333, 106444, 5) --Impale
module:RegisterDebuff(TIER, INSTANCE, 333, 106794) --Shrapnel (target)
