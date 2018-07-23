------------------------------------------------------------
-- TheBastionOfTwilight.lua
--
-- Abin
-- 2011/1/07
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 4 -- Cataclysm
local INSTANCE = 72 -- The Bastion of Twilight

-- Halfus Wyrmbreaker (156)

module:RegisterDebuff(TIER, INSTANCE, 156, 83710) --Furious Roar
module:RegisterDebuff(TIER, INSTANCE, 156, 83908) --Malevolent Strikes
module:RegisterDebuff(TIER, INSTANCE, 156, 83603) --Stone Touch

-- Valiona & Theralion (157)

module:RegisterDebuff(TIER, INSTANCE, 157, 86788) --Blackout
module:RegisterDebuff(TIER, INSTANCE, 157, 86622) --Engulfing Magic
module:RegisterDebuff(TIER, INSTANCE, 157, 86202) --Twilight Shift

-- Twilight Ascendant Council (158)

module:RegisterDebuff(TIER, INSTANCE, 158, 82762) --Waterlogged
module:RegisterDebuff(TIER, INSTANCE, 158, 83099) --Lightning Rod
module:RegisterDebuff(TIER, INSTANCE, 158, 82285) --Elemental Stasis
module:RegisterDebuff(TIER, INSTANCE, 158, 82660) --Burning Blood
module:RegisterDebuff(TIER, INSTANCE, 158, 82665) --Heart of Ice

-- Cho'gall (167)

module:RegisterDebuff(TIER, INSTANCE, 167, 81701) --Corrupted Blood
module:RegisterDebuff(TIER, INSTANCE, 167, 82523) --Gall's Blast
module:RegisterDebuff(TIER, INSTANCE, 167, 82518) --Cho's Blast
module:RegisterDebuff(TIER, INSTANCE, 167, 82411) --Debilitating Beam

-- Trash

module:RegisterDebuff(TIER, INSTANCE, 0, 81118) --Magma
module:RegisterDebuff(TIER, INSTANCE, 0, 87931) --Tremors
module:RegisterDebuff(TIER, INSTANCE, 0, 85799) --Phased Burn
module:RegisterDebuff(TIER, INSTANCE, 0, 88232) --Crimson Flames
module:RegisterDebuff(TIER, INSTANCE, 0, 84850) --Soul Blade
module:RegisterDebuff(TIER, INSTANCE, 0, 84853) --Dark Pool
module:RegisterDebuff(TIER, INSTANCE, 0, 88219) --Burning Twilight
module:RegisterDebuff(TIER, INSTANCE, 0, 88079) --Frostfire Bolt
module:RegisterDebuff(TIER, INSTANCE, 0, 76622) --Sunder Armor
module:RegisterDebuff(TIER, INSTANCE, 0, 84832) --Dismantle
module:RegisterDebuff(TIER, INSTANCE, 0, 84856) --Hungering Shadows
