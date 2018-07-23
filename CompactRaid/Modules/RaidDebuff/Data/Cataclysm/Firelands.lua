------------------------------------------------------------
-- Firelands.lua
--
-- Abin
-- 2011/8/21
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 4 -- Cataclysm
local INSTANCE = 78 -- Firelands

-- Beth'tilac (192)

module:RegisterDebuff(TIER, INSTANCE, 192, 97202) -- Fiery Web Spin
module:RegisterDebuff(TIER, INSTANCE, 192, 49026) -- Fixate
module:RegisterDebuff(TIER, INSTANCE, 192, 97079) -- Seeping Venom
module:RegisterDebuff(TIER, INSTANCE, 192, 99506) -- The Widow's Kiss
module:RegisterDebuff(TIER, INSTANCE, 192, 100048) --Fiery Web Silk

-- Lord Rhyolith (193)
--module:RegisterDebuff(TIER, INSTANCE, 193, 98492) --Eruption

-- Alysrazor (194)

module:RegisterDebuff(TIER, INSTANCE, 194, 100744) -- Firestorm
module:RegisterDebuff(TIER, INSTANCE, 194, 101729) -- Blazing Claw
module:RegisterDebuff(TIER, INSTANCE, 194, 98734) -- Molten Feather
module:RegisterDebuff(TIER, INSTANCE, 194, 98619) -- Wings of Flame
--module:RegisterDebuff(TIER, INSTANCE, 194, 99461) -- Blazing Power
--module:RegisterDebuff(TIER, INSTANCE, 194, 100029) -- Alysra's Razor
module:RegisterDebuff(TIER, INSTANCE, 194, 99427) -- Incendiary Cloud
module:RegisterDebuff(TIER, INSTANCE, 194, 101484) -- Blazing Shield
module:RegisterDebuff(TIER, INSTANCE, 194, 100094) -- Fieroblast
module:RegisterDebuff(TIER, INSTANCE, 194, 99389) -- Imprinted
module:RegisterDebuff(TIER, INSTANCE, 194, 99308) -- Gushing Wound
module:RegisterDebuff(TIER, INSTANCE, 194, 100640) -- Harsh Winds

-- Shannox (195)

module:RegisterDebuff(TIER, INSTANCE, 195, 99837) -- Crystal Prison Trap Effect
module:RegisterDebuff(TIER, INSTANCE, 195, 52606) -- Immolation Trap
module:RegisterDebuff(TIER, INSTANCE, 195, 99936) -- Jagged Tear
module:RegisterDebuff(TIER, INSTANCE, 195, 99947) -- Face Rage
module:RegisterDebuff(TIER, INSTANCE, 195, 99840) -- Magma Rupture

-- Baleroc, the Gatekeeper (196)

module:RegisterDebuff(TIER, INSTANCE, 196, 99252) -- Blaze of Glory
module:RegisterDebuff(TIER, INSTANCE, 196, 99256) -- Torment
module:RegisterDebuff(TIER, INSTANCE, 196, 99403) -- Tormented
module:RegisterDebuff(TIER, INSTANCE, 196, 99263) -- Vital Flame
module:RegisterDebuff(TIER, INSTANCE, 196, 99262) -- Vital Spark
module:RegisterDebuff(TIER, INSTANCE, 196, 99516) -- Countdown
module:RegisterDebuff(TIER, INSTANCE, 196, 99353) -- Decimating Strike
module:RegisterDebuff(TIER, INSTANCE, 196, 100908) -- Fiery Torment

-- Majordomo Staghelm (197)

module:RegisterDebuff(TIER, INSTANCE, 197, 98535) -- Leaping Flames
module:RegisterDebuff(TIER, INSTANCE, 197, 98443) -- Fiery Cyclone
module:RegisterDebuff(TIER, INSTANCE, 197, 98450) -- Searing Seeds
module:RegisterDebuff(TIER, INSTANCE, 197, 100210) -- Burning Orb
module:RegisterDebuff(TIER, INSTANCE, 197, 96993) -- Stay Withdrawn

-- Ragnaros (198)

module:RegisterDebuff(TIER, INSTANCE, 198, 100293) -- Lava Wave
module:RegisterDebuff(TIER, INSTANCE, 198, 98313) -- Magma Blast
module:RegisterDebuff(TIER, INSTANCE, 198, 100757) -- Deluge
module:RegisterDebuff(TIER, INSTANCE, 198, 99399) -- Burning Wound
module:RegisterDebuff(TIER, INSTANCE, 198, 100238) -- Magma Trap Vulnerability
module:RegisterDebuff(TIER, INSTANCE, 198, 100460) -- Blazing Heat
module:RegisterDebuff(TIER, INSTANCE, 198, 98981) -- Lava Bolt
module:RegisterDebuff(TIER, INSTANCE, 198, 100249) -- Combustion
module:RegisterDebuff(TIER, INSTANCE, 198, 99613) -- Molten Blast

-- Trash

module:RegisterDebuff(TIER, INSTANCE, 0, 76622) -- Sunder Armor
module:RegisterDebuff(TIER, INSTANCE, 0, 99610) -- Shockwave
module:RegisterDebuff(TIER, INSTANCE, 0, 99695) -- Flaming Spear
module:RegisterDebuff(TIER, INSTANCE, 0, 99800) -- Ensnare
module:RegisterDebuff(TIER, INSTANCE, 0, 99993) -- Fiery Blood
module:RegisterDebuff(TIER, INSTANCE, 0, 100767) -- Melt Armor
module:RegisterDebuff(TIER, INSTANCE, 0, 99693) -- Dinner Time
module:RegisterDebuff(TIER, INSTANCE, 0, 100549) -- Lava Surge
module:RegisterDebuff(TIER, INSTANCE, 0, 100057) -- Rend Flesh
module:RegisterDebuff(TIER, INSTANCE, 0, 101166) -- Ignite
module:RegisterDebuff(TIER, INSTANCE, 0, 100526) -- Blistering Wound
module:RegisterDebuff(TIER, INSTANCE, 0, 100095) -- Fieroclast Barrage
module:RegisterDebuff(TIER, INSTANCE, 0, 99650) -- Reactive flames
module:RegisterDebuff(TIER, INSTANCE, 0, 97151) -- Magma
module:RegisterDebuff(TIER, INSTANCE, 0, 100274) -- Blessed Defender of Nordrassil
