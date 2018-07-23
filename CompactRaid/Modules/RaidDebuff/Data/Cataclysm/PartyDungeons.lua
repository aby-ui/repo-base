------------------------------------------------------------
-- PartyDungeons.lua
--
-- Abin
-- 2011/2/09
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then return end

local TIER = 4 -- Cataclysm

-- Blackrock Caverns

module:RegisterDebuff(TIER, 66, 0, 93651) -- Frostbomb
module:RegisterDebuff(TIER, 66, 0, 93674) -- Shadow Prison
module:RegisterDebuff(TIER, 66, 0, 93452) -- Wounding Strike
module:RegisterDebuff(TIER, 66, 0, 93666) -- Lava Drool
module:RegisterDebuff(TIER, 66, 0, 75610, 5) -- Evolution
module:RegisterDebuff(TIER, 66, 0, 76189) -- Crepuscular Veil

-- Throne of the Tides

module:RegisterDebuff(TIER, 65, 0, 91464) -- Poisoned Spear
module:RegisterDebuff(TIER, 65, 0, 83926) -- Veil of Shadow
module:RegisterDebuff(TIER, 65, 0, 83971) -- Aura of Dread
module:RegisterDebuff(TIER, 65, 0, 91484, 5) -- Squeeze
module:RegisterDebuff(TIER, 65, 0, 76094) -- Curse of Fatigue
module:RegisterDebuff(TIER, 65, 0, 91413) -- Enslave
module:RegisterDebuff(TIER, 65, 0, 91470) -- Fungal Spores

-- The Stonecore

module:RegisterDebuff(TIER, 67, 0, 92630) -- Rock Bore
module:RegisterDebuff(TIER, 67, 0, 92650) -- Dampening Wave
module:RegisterDebuff(TIER, 67, 0, 92648) -- Crystal Barrage
module:RegisterDebuff(TIER, 67, 0, 92426) -- Paralyze
module:RegisterDebuff(TIER, 67, 0, 79351, 5) -- Force Grip
module:RegisterDebuff(TIER, 67, 0, 92663) -- Curse of Blood

-- Lost City of the Tol'vir

module:RegisterDebuff(TIER, 69, 0, 90026) -- Dragon's Breath
module:RegisterDebuff(TIER, 69, 0, 82760) -- Hex
module:RegisterDebuff(TIER, 69, 0, 89994) -- Serum of Torment
module:RegisterDebuff(TIER, 69, 0, 89998) -- Scent of Blood
module:RegisterDebuff(TIER, 69, 0, 90010) -- Hallowed Ground
module:RegisterDebuff(TIER, 69, 0, 82255) -- Soul Sever

-- The Vortex Pinnacle

module:RegisterDebuff(TIER, 68, 0, 87618) -- Static Cling
module:RegisterDebuff(TIER, 68, 0, 92773) -- Hurricane
module:RegisterDebuff(TIER, 68, 0, 88282) -- Upwind of Altairus
module:RegisterDebuff(TIER, 68, 0, 88286) -- Downwind of Altairus
module:RegisterDebuff(TIER, 68, 0, 93991) -- Cyclone Shield

-- Halls of Origination

module:RegisterDebuff(TIER, 70, 0, 91206) -- Crumbling Ruin
module:RegisterDebuff(TIER, 70, 0, 91174) -- Nemesis Strike
module:RegisterDebuff(TIER, 70, 0, 91177) -- Alpha Beams
module:RegisterDebuff(TIER, 70, 0, 95181) -- Curse of the Runecaster
module:RegisterDebuff(TIER, 70, 0, 91158) -- Bubble Bound
module:RegisterDebuff(TIER, 70, 0, 91159) -- Raging Inferno

-- Grim Batol

module:RegisterDebuff(TIER, 71, 0, 90880) -- Hooked Net
module:RegisterDebuff(TIER, 71, 0, 90964) -- Seeping Twilight
module:RegisterDebuff(TIER, 71, 0, 90756, 5) -- Impaling Slam
module:RegisterDebuff(TIER, 71, 0, 91079) -- Binding Shadows
module:RegisterDebuff(TIER, 71, 0, 75694) -- Shadow Gale
module:RegisterDebuff(TIER, 71, 0, 91937) -- Bleeding Wound
module:RegisterDebuff(TIER, 71, 0, 90179) -- Modgud's Malady
module:RegisterDebuff(TIER, 71, 0, 82850, 5) -- Flame Gaze

-- Shadowfang Keep

module:RegisterDebuff(TIER, 64, 0, 91678) -- Pustulant Spit
module:RegisterDebuff(TIER, 64, 0, 93956) -- Cursed Veil
module:RegisterDebuff(TIER, 64, 0, 93920) -- Soul Drain
module:RegisterDebuff(TIER, 64, 0, 94370) -- Desecration
module:RegisterDebuff(TIER, 64, 0, 93712) -- Pain and Suffering
module:RegisterDebuff(TIER, 64, 0, 93761, 5) -- Cursed Bullets

-- The Deadmines

module:RegisterDebuff(TIER, 63, 0, 91016) -- Axe to the Head
module:RegisterDebuff(TIER, 63, 0, 88352) -- Chest Bomb
module:RegisterDebuff(TIER, 63, 0, 91830) -- Fixate

-- Zul'Aman

module:RegisterDebuff(TIER, 77, 0, 44008) -- Static Disruption
module:RegisterDebuff(TIER, 77, 0, 97318, 5) -- Plucked
module:RegisterDebuff(TIER, 77, 0, 43648) -- Electrical Storm
module:RegisterDebuff(TIER, 77, 0, 42384) -- Brutal Strike
module:RegisterDebuff(TIER, 77, 0, 42402) -- Surge
module:RegisterDebuff(TIER, 77, 0, 97488) -- Flame Breath
module:RegisterDebuff(TIER, 77, 0, 43150) -- Claw Rage
module:RegisterDebuff(TIER, 77, 0, 43501) -- Siphon Soul
module:RegisterDebuff(TIER, 77, 0, 43093) -- Grievous Throw
module:RegisterDebuff(TIER, 77, 0, 43095) -- Creeping Paralysis

-- Zul'Gurub

module:RegisterDebuff(TIER, 76, 0, 96477) -- Toxic Link
module:RegisterDebuff(TIER, 76, 0, 96466) -- Whispers of Hethiss
module:RegisterDebuff(TIER, 76, 0, 96776) -- Bloodletting
module:RegisterDebuff(TIER, 76, 0, 96423) -- Lash of Anguish
module:RegisterDebuff(TIER, 76, 0, 96342) -- Pursuit

-----------------------------------------
-- 4.3 new instances
-----------------------------------------

-- End Time

module:RegisterDebuff(TIER, 184, 0, 101411)
module:RegisterDebuff(TIER, 184, 0, 101412)
module:RegisterDebuff(TIER, 184, 0, 101337)
module:RegisterDebuff(TIER, 184, 0, 102149)
module:RegisterDebuff(TIER, 184, 0, 109952)
module:RegisterDebuff(TIER, 184, 0, 102066)
module:RegisterDebuff(TIER, 184, 0, 102183)
module:RegisterDebuff(TIER, 184, 0, 102057)

-- Well of Eternity

module:RegisterDebuff(TIER, 185, 0, 105493) -- Easy Prey
module:RegisterDebuff(TIER, 185, 0, 105544) -- Fel Decay
module:RegisterDebuff(TIER, 185, 0, 102455) -- Arcane Bomb
module:RegisterDebuff(TIER, 185, 0, 102466) -- Coldflame
module:RegisterDebuff(TIER, 185, 0, 102245) -- Sweet Lullaby

-- Hour of Twilight

module:RegisterDebuff(TIER, 186, 0, 102848) -- Tentacle Smash
module:RegisterDebuff(TIER, 186, 0, 102984) -- Seeking Shadows
module:RegisterDebuff(TIER, 186, 0, 102861) -- Squeeze Lifeless
module:RegisterDebuff(TIER, 186, 0, 102995) -- Shadow Bore
module:RegisterDebuff(TIER, 186, 0, 103790) -- Choking Smoke Bomb
module:RegisterDebuff(TIER, 186, 0, 43415) -- Freezing Trap
module:RegisterDebuff(TIER, 186, 0, 102582) -- Chains of Frost
module:RegisterDebuff(TIER, 186, 0, 103151) -- Righteous Shear
module:RegisterDebuff(TIER, 186, 0, 103363) -- Twilight Shear
