------------------------------------------------------------
-- PartyDungeons.lua
--
-- Abin
-- 2012/10/05
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 5 -- Mists of Pandaria

-- Siege of Niuzao Temple
module:RegisterDebuff(TIER, 324, 0, 119941) -- Sap Residue
module:RegisterDebuff(TIER, 324, 0, 119840) -- Serrated Blade
module:RegisterDebuff(TIER, 324, 0, 126336) -- Caustic Pitch
module:RegisterDebuff(TIER, 324, 0, 121447) -- Quick-Dry Resin

-- Shado-Pan Monastery
module:RegisterDebuff(TIER, 312, 0, 107140) -- Magnetic Shroud
module:RegisterDebuff(TIER, 312, 0, 106872) -- Disorienting Smash
module:RegisterDebuff(TIER, 312, 0, 106827) -- Smoke Blades
module:RegisterDebuff(TIER, 312, 0, 107087) -- Haze of Hate
module:RegisterDebuff(TIER, 312, 0, 112929) -- Pool of Shadows

-- Gate of the Setting Sun
module:RegisterDebuff(TIER, 303, 0, 113645) -- Sabotage
module:RegisterDebuff(TIER, 303, 0, 106934, 5) -- Prey Time
module:RegisterDebuff(TIER, 303, 0, 107047, 5) -- Impaling Strike
module:RegisterDebuff(TIER, 303, 0, 107122) -- Viscous Fluid
module:RegisterDebuff(TIER, 303, 0, 111725, 5) -- Fixate

-- Scarlet Monastery
module:RegisterDebuff(TIER, 316, 0, 115144) -- Mind Rot
module:RegisterDebuff(TIER, 316, 0, 115291) -- Spirit Gale
module:RegisterDebuff(TIER, 316, 0, 115297, 5) -- Evict Soul
module:RegisterDebuff(TIER, 316, 0, 114460) -- Scorched Earth

-- Scarlet Halls
module:RegisterDebuff(TIER, 311, 0, 114056) -- Bloody Mess
module:RegisterDebuff(TIER, 311, 0, 113653) -- Greater Dragon's Breath
module:RegisterDebuff(TIER, 311, 0, 113690) -- Pyroblast

-- Scholomance
module:RegisterDebuff(TIER, 246, 0, 114658) -- Wrack Soul
module:RegisterDebuff(TIER, 246, 0, 111610) -- Ice Wrath
module:RegisterDebuff(TIER, 246, 0, 115350, 5) -- Fixate Anger
module:RegisterDebuff(TIER, 246, 0, 46042) -- Immolate

-- Temple of the Jade Serpent
module:RegisterDebuff(TIER, 313, 0, 106823) -- Serpent Strike
module:RegisterDebuff(TIER, 313, 0, 106841, 5) -- Jade Serpent Strike
module:RegisterDebuff(TIER, 313, 0, 106113) -- Touch of Nothingness

-- Stormstout Brewery
module:RegisterDebuff(TIER, 302, 0, 106546) -- Bloat
module:RegisterDebuff(TIER, 302, 0, 106851) -- Blackout Brew
module:RegisterDebuff(TIER, 302, 0, 114451) -- Ferment

-- Mogu'shan Palace
module:RegisterDebuff(TIER, 321, 0, 119946, 5) -- Ravage
module:RegisterDebuff(TIER, 321, 0, 120167) -- Conflagrate
module:RegisterDebuff(TIER, 321, 0, 123655) -- Traumatic Blow
module:RegisterDebuff(TIER, 321, 0, 118963) -- Shank
module:RegisterDebuff(TIER, 321, 0, 118903) -- Hex of Lethargy
