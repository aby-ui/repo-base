--local zone = "The Nighthold"
local zoneid = 764

-- Skorpyron
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Skorpyron")
-- Crystalline Scorpid
GridStatusRaidDebuff:DebuffId(zoneid, 204766, 11, 5, 5, false, true) -- Energy Surge (non-dispellable, stacks) (DMG + Debuff)
-- Chromatic Exoskeleton
GridStatusRaidDebuff:DebuffId(zoneid, 214657, 12, 5, 5) -- Acidic Fragments (non-dispellable) (DMG + Debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 214662, 13, 5, 5) -- Volatile Fragments (non-dispellable) (DMG + Debuff)
-- Arcanoslash
GridStatusRaidDebuff:DebuffId(zoneid, 211659, 14, 5, 5, true, true) -- Arcane Tether (non-dispellable, stacks) (Stacking Ground AoE)

GridStatusRaidDebuff:DebuffId(zoneid, 204471, 15, 5, 5) -- Focused Blast (non-dispellable) (Frontal Cone AoE)

-- Chronomatic Anomaly
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Chronomatic Anomaly")
GridStatusRaidDebuff:DebuffId(zoneid, 206607, 21, 5, 5, false, true) -- Chronometric Particles (non-dispellable, stacks) (Stacking DoT)
GridStatusRaidDebuff:DebuffId(zoneid, 206609, 22, 5, 5) -- Time Release (non-dispellable) (heal absorb)
GridStatusRaidDebuff:DebuffId(zoneid, 206617, 23, 5, 5, true, false) -- Time Bomb (non-dispellable) (Not a Debuff?)
GridStatusRaidDebuff:DebuffId(zoneid, 212099, 24, 5, 5) -- Temporal Charge (non-dispellable) (DoT)

-- Trilliax
GridStatusRaidDebuff:BossNameId(zoneid, 30, "Trilliax")
GridStatusRaidDebuff:DebuffId(zoneid, 206482, 31, 5, 5) -- Arcane Seepage (non-dispellable) (Ground AoE)
-- The Cleaner
GridStatusRaidDebuff:DebuffId(zoneid, 206788, 32, 6, 6, false, true) -- Toxic Slice (non-dispellable) (DMG + Debuff Stacking DoT)
GridStatusRaidDebuff:DebuffId(zoneid, 214573, 32, 5, 5, false, true) -- Stuffed (non-dispellable)

-- Spellblade Aluriel
GridStatusRaidDebuff:BossNameId(zoneid, 40, "Spellblade Aluriel")
-- Chamion of Blades
GridStatusRaidDebuff:DebuffId(zoneid, 212492, 41, 5, 5) -- Annihilate (non-dispellable) (DMG + Tank Debuff)
-- Master of Frost
GridStatusRaidDebuff:DebuffId(zoneid, 212587, 42, 7, 7, true, false) -- Mark of Frost (non-dispellable) (DMG + Increase DMG taken per stack explodes if two people with it get close)
GridStatusRaidDebuff:DebuffId(zoneid, 212647, 43, 6, 6, false, true) -- Frostbitten (non-dispellable, Stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 212736, 44, 5, 5) -- Pool of Frost (Ground AOE)
GridStatusRaidDebuff:DebuffId(zoneid, 213083, 45, 5, 5, true, false) -- Frozen Tempest (non-dispellable) (DoT)
-- Master of Fire 
GridStatusRaidDebuff:DebuffId(zoneid, 213166, 46, 7, 7, true, true) -- Searing Brand (non-dispellable, Stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 213278, 47, 5, 5) -- Burning Ground (Ground AOE)
-- Master of the Arcane
GridStatusRaidDebuff:DebuffId(zoneid, 213504, 48, 5, 5) -- Arcane Fog (Ground AOE)
-- Fel Soul
GridStatusRaidDebuff:DebuffId(zoneid, 230414, 49, 5, 5) -- Fel Stomp (Ground AOE)

-- Tichondrius
GridStatusRaidDebuff:BossNameId(zoneid, 50, "Tichondrius")
-- Stage One
GridStatusRaidDebuff:DebuffId(zoneid, 206480, 51, 5, 5, true, false) -- Carrion Plague (non-dispellable) (DoT)
GridStatusRaidDebuff:DebuffId(zoneid, 213238, 52, 5, 5, true, false) -- Seeker Swarm (non-dispellable) (DMG + Adds Carrion Plague DoT)
GridStatusRaidDebuff:DebuffId(zoneid, 212795, 53, 5, 5) -- Brand of Argus (non-dispellable) (Explodes if players clump)
GridStatusRaidDebuff:DebuffId(zoneid, 208230, 54, 5, 5) -- Feast of Blood (non-dispellable) (Increases DMG Taken)
-- The Nightborne Felsworn Spellguard
GridStatusRaidDebuff:DebuffId(zoneid, 216024, 55, 5, 5, false, true) -- Volatile Wound (non-dispellable, Stacks) (DMG + Increases Future DMG Taken)
-- The Legion Sightless Watcher
GridStatusRaidDebuff:DebuffId(zoneid, 216040, 56, 5, 5, true, false) -- Burning Soul (dispellable) (DMG + Mana Drain + Explode on Dispell)

-- Krosus
GridStatusRaidDebuff:BossNameId(zoneid, 60, "Krosus")
GridStatusRaidDebuff:DebuffId(zoneid, 208203, 61, 5, 5) -- Isolated Rage (non-dispellable) (Ground AoE Not Avoidable)
GridStatusRaidDebuff:DebuffId(zoneid, 206677, 62, 5, 5, true, true) -- Searing Brand (non-dispellable, Stacks)

-- High Botanist Tel'arn
GridStatusRaidDebuff:BossNameId(zoneid, 70, "High Botanist Tel'arn")
--Arcanist Tel'arn
GridStatusRaidDebuff:DebuffId(zoneid, 218502, 71, 5, 5, false, true) -- Recursive Strikes (non-dispellable, stacks) (Increases DMG Taken)
-- Naturalist Tel'arn
GridStatusRaidDebuff:DebuffId(zoneid, 219049, 72, 5, 5, false, true) -- Toxic Spores (non-dispellable) (Ground AoE)
GridStatusRaidDebuff:DebuffId(zoneid, 218424, 73, 5, 5, false, true) -- Parasitic Fetter (dispellable) (Root + Increaseing DMG)
GridStatusRaidDebuff:DebuffId(zoneid, 218809, 74, 5, 5, true, false) -- Call of Night

-- Star Augur Etraeus
GridStatusRaidDebuff:BossNameId(zoneid, 80, "Star Augur Etraeus")
-- Stage Two
GridStatusRaidDebuff:DebuffId(zoneid, 206585, 81, 5, 5, false, true) -- Absolute Zero (non-dispellable, stacks) (DMG + Dispellable by Player Clump That then causes Chill)
GridStatusRaidDebuff:DebuffId(zoneid, 206936, 82, 5, 5, true) -- Icy Ejection (non-dispellable, stacks) (DoT + Slow-to-Stun)
-- Stage Three
GridStatusRaidDebuff:DebuffId(zoneid, 206388, 83, 5, 5, false, true) -- Felburst (non-dispellable, stacks) (DMG + DoT)
GridStatusRaidDebuff:DebuffId(zoneid, 205649, 84, 5, 5, false, true) -- Fel Ejection (non-dispellable, stacks) (DMG + DoT)
-- Stage Four
GridStatusRaidDebuff:DebuffId(zoneid, 206965, 85, 5, 5, true, false) -- Voidburst (non-dispellable) (DoT)
GridStatusRaidDebuff:DebuffId(zoneid, 207143, 86, 5, 5) -- Void Ejection (non-dispellable) (DMG + DoT)

-- Grand Magistrix Elisande
GridStatusRaidDebuff:BossNameId(zoneid, 90, "Grand Magistrix Elisande")
-- Stage Three
GridStatusRaidDebuff:DebuffId(zoneid, 211258, 91, 5, 5, true, false) -- Permeliative Torment (non-dispellable) (DoT)
GridStatusRaidDebuff:DebuffId(zoneid, 209598, 92, 5, 5, true, false) -- Conflexive Burst
GridStatusRaidDebuff:DebuffId(zoneid, 209971, 93, 5, 5, true, false) -- Ablative Pulse

-- Gul'dan
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Gul'dan")
-- Stage One
-- Inquisitor Vethriz
GridStatusRaidDebuff:DebuffId(zoneid, 212568, 101, 5, 5, true, false) -- Drain (dispellable) (Life Steal)
-- D'zorykx the Trapper
GridStatusRaidDebuff:DebuffId(zoneid, 206883, 102, 5, 5, false, true) -- Soul Vortex (non-dispellable, stacks) (AoE DMG + DoT)
-- Gul'dan
GridStatusRaidDebuff:DebuffId(zoneid, 206222, 103, 5, 5) -- Bonds of Fel (non-dispellable) (chain + Slow + Explosion when seperated)
GridStatusRaidDebuff:DebuffId(zoneid, 206221, 104, 5, 5) -- Empowered Bonds of Fel (non-dispellable) (chain + Slow + Explosion when seperated)
-- Dreadlords of the Twisting Nether
GridStatusRaidDebuff:DebuffId(zoneid, 208672, 105, 5, 5) -- Carrion Wave (non-dispellable) (AoE DMG + Sleep)
-- Gul'dan
GridStatusRaidDebuff:DebuffId(zoneid, 208903, 106, 5, 5) -- Burning Claws (non-dispellable) (ground AoE)
GridStatusRaidDebuff:DebuffId(zoneid, 208802, 107, 5, 5, false, true) -- Soul Corrosion (non-dispellable) (DMG + DoT)

