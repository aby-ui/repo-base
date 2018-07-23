--local zone = "Throne of Thunder"
local zoneid = 508

-- Check Compatibility
if GridStatusRD_MoP.rd_version < 502 then
	return
end

--zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Trash
-- Jin'rokh the Breaker
-- Zandalari Storm-Caller
GridStatusRaidDebuff:DebuffId(zoneid, 139322, 1, 2, 2) -- Storm Energy
-- Zandalari Water-Binder
GridStatusRaidDebuff:DebuffId(zoneid, 136952, 1, 1, 1) -- Frostbolt (slow)
-- Zandalari Spear-Shaper
GridStatusRaidDebuff:DebuffId(zoneid, 137072, 1, 3, 3) -- Retrieve Spear (stun)
-- Zandalari Blade Initiate
GridStatusRaidDebuff:DebuffId(zoneid, 140049, 1, 2, 2) -- Wounding Strike

-- Horridon
-- Stormbringer Draz'kil
GridStatusRaidDebuff:DebuffId(zoneid, 139900, 1, 1, 1) --Stormcloud
-- Tormented Spirit
GridStatusRaidDebuff:DebuffId(zoneid, 139550, 1, 1, 1, true, true) --Torment
-- Soul-Fed Construct
GridStatusRaidDebuff:DebuffId(zoneid, 33661, 1, 1, 1, true, true) --Crush Armor

-- Horridon & Council of Elders
-- Ancient Python
GridStatusRaidDebuff:DebuffId(zoneid, 139888, 1, 1, 1, true, true) --Ancient Venom
-- Drakkari Frost Warden
GridStatusRaidDebuff:DebuffId(zoneid, 138687, 1, 6, 6) --Glacial Freeze (Magic, stun)

-- Council of Elders
-- Zandalari Prelate
GridStatusRaidDebuff:DebuffId(zoneid, 139213, 1, 6, 6) -- Mark of the Loa (Magic)
-- Farraki Sand Conjurer
GridStatusRaidDebuff:DebuffId(zoneid, 138742, 1, 7, 7) -- Choking Sands (Magic, silence/pacify)
-- Zandalari Prophet
-- GridStatusRaidDebuff:DebuffId(zoneid, 139205, 1, 6, 6) -- Visions of Grandeur (Magic)
GridStatusRaidDebuff:DebuffId(zoneid, 140400, 1, 6, 6) -- Mark of the Prophet (Magic)
-- Gurubashi Berserker
GridStatusRaidDebuff:DebuffId(zoneid, 138693, 1, 1, 1) --Bloodletting

-- Tortos
-- Greater Cave Bat
GridStatusRaidDebuff:DebuffId(zoneid, 136751, 1, 1, 1) --Sonic Screech
GridStatusRaidDebuff:DebuffId(zoneid, 136753, 1, 1, 1, true, true) --Slashing Talons

-- Magaera
-- Mist Lurker
GridStatusRaidDebuff:DebuffId(zoneid, 140686, 1, 1, 1) --Corrosive Breath
GridStatusRaidDebuff:DebuffId(zoneid, 140682, 1, 1, 1) --Chokin Mists
-- Shale Spider
GridStatusRaidDebuff:DebuffId(zoneid, 140616, 1, 1, 1) --Shale Shards
-- Eternal Guardian
GridStatusRaidDebuff:DebuffId(zoneid, 140629, 1, 6, 6) --Eternal Prison (Magic)
-- Fungal Growth
GridStatusRaidDebuff:DebuffId(zoneid, 140620, 1, 6, 6) --Fungal Spores (Magic)

-- Ji-Kun
-- Gastropod
GridStatusRaidDebuff:DebuffId(zoneid, 134415, 1, 1, 1) --Devoured (stun)

-- Durumu the Forgotten
-- Roaming Fog
GridStatusRaidDebuff:DebuffId(zoneid, 134668, 1, 1, 1) --Gnawed Upon

-- Dark Animus
-- Archritualist Kelada
GridStatusRaidDebuff:DebuffId(zoneid, 139356, 1, 1, 1) --Extermination Beam
-- Ritual Guard
GridStatusRaidDebuff:DebuffId(zoneid, 139215, 1, 1, 1) --Shockwave (stun)

-- Iron Qon
-- Skittering Spiderling
GridStatusRaidDebuff:DebuffId(zoneid, 139310, 1, 6, 6) --Foul Venom (Disease)
-- Untrained Quilen
GridStatusRaidDebuff:DebuffId(zoneid, 122962, 1, 2, 2) --Carnivorous Bite
-- Putrid Waste
GridStatusRaidDebuff:DebuffId(zoneid, 139317, 1, 1, 1) --Putrify
-- Rotting Scavenger
GridStatusRaidDebuff:DebuffId(zoneid, 139314, 1, 6, 6) --Infected Bite (Disease)

-- Lei Shen
-- Lightning Guardian
GridStatusRaidDebuff:DebuffId(zoneid, 138196, 1, 6, 6) --Lightning Burst (Magic)

-- Bosses

-- Jin'rokh the Breaker
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Jin'rokh the Breaker")
GridStatusRaidDebuff:DebuffId(zoneid, 138006, 11, 4, 4) --Electrified Waters
GridStatusRaidDebuff:DebuffId(zoneid, 137399, 12, 6, 6) --Focused Lightning fixate
GridStatusRaidDebuff:DebuffId(zoneid, 138732, 13, 5, 5) --Ionization
GridStatusRaidDebuff:DebuffId(zoneid, 138349, 14, 2, 2) --Static Wound (tank only)
GridStatusRaidDebuff:DebuffId(zoneid, 137371, 15, 2, 2) --Thundering Throw (tank only)

--Horridon
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Horridon")
GridStatusRaidDebuff:DebuffId(zoneid, 136769, 21, 6, 6) --Charge
GridStatusRaidDebuff:DebuffId(zoneid, 136767, 22, 2, 2, true, true) --Triple Puncture (tanks only)
GridStatusRaidDebuff:DebuffId(zoneid, 136708, 23, 6, 6) --Stone Gaze (stun, dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 136723, 24, 5, 5) --Sand Trap
GridStatusRaidDebuff:DebuffId(zoneid, 136587, 25, 5, 5, true, true) --Venom Bolt Volley (dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 136710, 26, 5, 5, true, true) --Deadly Plague (disease)
GridStatusRaidDebuff:DebuffId(zoneid, 136670, 27, 4, 4) --Mortal Strike
GridStatusRaidDebuff:DebuffId(zoneid, 136573, 28, 5, 5) --Frozen Bolt (DebuffId used by frozen orb)
GridStatusRaidDebuff:DebuffId(zoneid, 136512, 29, 6, 6) --Hex of Confusion
GridStatusRaidDebuff:DebuffId(zoneid, 136719, 30, 6, 6) --Blazing Sunlight
GridStatusRaidDebuff:DebuffId(zoneid, 136654, 31, 6, 6) --Rending Charge (major healing bleed)
GridStatusRaidDebuff:DebuffId(zoneid, 140946, 32, 4, 4) --Dire Fixation (Heroic Only)

--Council of Elders
GridStatusRaidDebuff:BossNameId(zoneid, 40, "Council of Elders")
GridStatusRaidDebuff:DebuffId(zoneid, 136922, 41, 6, 6, true, true) --Frostbite
GridStatusRaidDebuff:DebuffId(zoneid, 137084, 42, 3, 3, true, true) --Body Heat
GridStatusRaidDebuff:DebuffId(zoneid, 137641, 43, 6, 6) --Soul Fragment (Heroic only)
GridStatusRaidDebuff:DebuffId(zoneid, 136878, 44, 5, 5, true, true) --Ensnared
GridStatusRaidDebuff:DebuffId(zoneid, 136857, 45, 6, 6) --Entrapped (Dispell)
GridStatusRaidDebuff:DebuffId(zoneid, 137650, 46, 5, 5, true, true) --Shadowed Soul
GridStatusRaidDebuff:DebuffId(zoneid, 137359, 47, 6, 6) --Shadowed Loa Spirit fixate target
GridStatusRaidDebuff:DebuffId(zoneid, 137972, 48, 6, 6) --Twisted Fate (Heroic only)
GridStatusRaidDebuff:DebuffId(zoneid, 136860, 49, 5, 5) --Quicksand
GridStatusRaidDebuff:DebuffId(zoneid, 136860, 50, 2, 2) --Frigid Assault (stun)

--Tortos
GridStatusRaidDebuff:BossNameId(zoneid, 51, "Tortos")
GridStatusRaidDebuff:DebuffId(zoneid, 134030, 52, 6, 6) --Kick Shell
GridStatusRaidDebuff:DebuffId(zoneid, 134920, 53, 6, 6) --Quake Stomp
GridStatusRaidDebuff:DebuffId(zoneid, 136751, 54, 6, 6) --Sonic Screech
GridStatusRaidDebuff:DebuffId(zoneid, 136753, 55, 2, 2) --Slashing Talons (tank only)
GridStatusRaidDebuff:DebuffId(zoneid, 137633, 56, 5, 5) --Crystal Shell (heroic only)

--Megaera
GridStatusRaidDebuff:BossNameId(zoneid, 60, "Megaera")
GridStatusRaidDebuff:DebuffId(zoneid, 139822, 61, 6, 6) --Cinder (Dispell)
GridStatusRaidDebuff:DebuffId(zoneid, 134396, 62, 6, 6) --Consuming Flames (Dispell)
GridStatusRaidDebuff:DebuffId(zoneid, 137731, 63, 5, 5, true, true) --Ignite Flesh
GridStatusRaidDebuff:DebuffId(zoneid, 136892, 64, 6, 6) --Frozen Solid
GridStatusRaidDebuff:DebuffId(zoneid, 139909, 65, 5, 5) --Icy Ground
GridStatusRaidDebuff:DebuffId(zoneid, 137746, 66, 6, 6) --Consuming Magic
GridStatusRaidDebuff:DebuffId(zoneid, 139843, 67, 4, 4) --Artic Freeze
GridStatusRaidDebuff:DebuffId(zoneid, 139840, 68, 4, 4) --Rot Armor
GridStatusRaidDebuff:DebuffId(zoneid, 140179, 69, 6, 6) --Suppression (stun)


--Ji-Kun
GridStatusRaidDebuff:BossNameId(zoneid, 70, "Ji-Kun")
GridStatusRaidDebuff:DebuffId(zoneid, 140092, 71, 2, 2, true, true) --Infected Talons (tank)
GridStatusRaidDebuff:DebuffId(zoneid, 140092, 72, 2, 2, true, true) --Talon Rake (tank)
GridStatusRaidDebuff:DebuffId(zoneid, 138309, 73, 4, 4, true, true) --Slimed
GridStatusRaidDebuff:DebuffId(zoneid, 138319, 74, 5, 5) --Feed Pool
GridStatusRaidDebuff:DebuffId(zoneid, 140571, 75, 3, 3) --Feed Pool
GridStatusRaidDebuff:DebuffId(zoneid, 134372, 76, 3, 3) --Screech
-- This is good, don't need to show it
GridStatusRaidDebuff:DebuffId(zoneid, 140014, 77, 1, 1, false, false, 0, true) --Daedalian Wings

--Durumu the Forgotten
GridStatusRaidDebuff:BossNameId(zoneid, 80, "Durumu")
GridStatusRaidDebuff:DebuffId(zoneid, 133768, 81, 3, 3) --Arterial Cut (tank only)
GridStatusRaidDebuff:DebuffId(zoneid, 133767, 82, 2, 2, true, true) --Serious Wound (Tank only)
GridStatusRaidDebuff:DebuffId(zoneid, 136932, 83, 6, 6) --Force of Will
GridStatusRaidDebuff:DebuffId(zoneid, 134122, 84, 5, 5) --Blue Beam
GridStatusRaidDebuff:DebuffId(zoneid, 134123, 85, 5, 5) --Red Beam
GridStatusRaidDebuff:DebuffId(zoneid, 134124, 86, 5, 5) --Yellow Beam
GridStatusRaidDebuff:DebuffId(zoneid, 133795, 87, 6, 6) --Life Drain
GridStatusRaidDebuff:DebuffId(zoneid, 133597, 88, 6, 6) --Dark Parasite
GridStatusRaidDebuff:DebuffId(zoneid, 133732, 89, 3, 3, true, true) --Infrared Light (the stacking red debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 133677, 90, 3, 3, true, true) --Blue Rays (the stacking blue debuff)  
GridStatusRaidDebuff:DebuffId(zoneid, 133738, 91, 3, 3, true, true) --Bright Light (the stacking yellow debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 133737, 92, 4, 4) --Bright Light (The one that says you are actually in a beam)
GridStatusRaidDebuff:DebuffId(zoneid, 133675, 93, 4, 4) --Blue Rays (The one that says you are actually in a beam)
GridStatusRaidDebuff:DebuffId(zoneid, 134626, 94, 5, 5) --Lingering Gaze

--Primordius
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Primordius")
GridStatusRaidDebuff:DebuffId(zoneid, 140546, 101, 5, 5) --Fully Mutated
GridStatusRaidDebuff:DebuffId(zoneid, 136180, 102, 3, 3, true, true) --Keen Eyesight (Helpful)
GridStatusRaidDebuff:DebuffId(zoneid, 136181, 103, 4, 4, true, true) --Impared Eyesight (Harmful)
GridStatusRaidDebuff:DebuffId(zoneid, 136182, 104, 3, 3, true, true) --Improved Synapses (Helpful)
GridStatusRaidDebuff:DebuffId(zoneid, 136183, 105, 4, 4, true, true) --Dulled Synapses (Harmful)
GridStatusRaidDebuff:DebuffId(zoneid, 136184, 106, 3, 3, true, true) --Thick Bones (Helpful)
GridStatusRaidDebuff:DebuffId(zoneid, 136185, 107, 4, 4, true, true) --Fragile Bones (Harmful)
GridStatusRaidDebuff:DebuffId(zoneid, 136186, 108, 3, 3, true, true) --Clear Mind (Helpful)
GridStatusRaidDebuff:DebuffId(zoneid, 136187, 109, 4, 4, true, true) --Clouded Mind (Harmful)
GridStatusRaidDebuff:DebuffId(zoneid, 136050, 110, 2, 2, true, true) --Malformed Blood(Tank Only)
GridStatusRaidDebuff:DebuffId(zoneid, 136228, 111, 6, 6) --Volatile Pathogen

--Dark Animus
GridStatusRaidDebuff:BossNameId(zoneid, 120, "Dark Animus")
GridStatusRaidDebuff:DebuffId(zoneid, 138569, 121, 2, 2) --Explosive Slam (tank only)
GridStatusRaidDebuff:DebuffId(zoneid, 138659, 122, 6, 6) --Touch of the Animus
GridStatusRaidDebuff:DebuffId(zoneid, 138609, 123, 6, 6) --Matter Swap
GridStatusRaidDebuff:DebuffId(zoneid, 138691, 124, 4, 4) --Anima Font
GridStatusRaidDebuff:DebuffId(zoneid, 136962, 125, 5, 5) --Anima Ring
GridStatusRaidDebuff:DebuffId(zoneid, 138480, 126, 6, 6) --Crimson Wake Fixate

--Iron Qon
GridStatusRaidDebuff:BossNameId(zoneid, 130, "Iron Qon")
GridStatusRaidDebuff:DebuffId(zoneid, 134647, 131, 6, 6, true, true) --Scorched
GridStatusRaidDebuff:DebuffId(zoneid, 136193, 132, 5, 5) --Arcing Lightning
GridStatusRaidDebuff:DebuffId(zoneid, 135147, 133, 2, 2) --Dead Zone
GridStatusRaidDebuff:DebuffId(zoneid, 134691, 134, 2, 2, true, true) --Impale (tank only)
GridStatusRaidDebuff:DebuffId(zoneid, 135145, 135, 6, 6) --Freeze
GridStatusRaidDebuff:DebuffId(zoneid, 136520, 136, 5, 5, true, true) --Frozen Blood
GridStatusRaidDebuff:DebuffId(zoneid, 137669, 137, 3, 3) --Storm Cloud
GridStatusRaidDebuff:DebuffId(zoneid, 137668, 138, 5, 5, true, true) --Burning Cinders
GridStatusRaidDebuff:DebuffId(zoneid, 137654, 139, 5, 5) --Rushing Winds 
GridStatusRaidDebuff:DebuffId(zoneid, 136577, 140, 4, 4) --Wind Storm
GridStatusRaidDebuff:DebuffId(zoneid, 136192, 141, 4, 4) --Lightning Storm
GridStatusRaidDebuff:DebuffId(zoneid, 136615, 142, 6, 6) --Electrified

--Twin Consorts
GridStatusRaidDebuff:BossNameId(zoneid, 150, "Twin Consorts")
GridStatusRaidDebuff:DebuffId(zoneid, 137440, 151, 6, 6) --Icy Shadows
GridStatusRaidDebuff:DebuffId(zoneid, 137417, 152, 6, 6) --Flames of Passion
GridStatusRaidDebuff:DebuffId(zoneid, 138306, 153, 5, 5) --Serpent's Vitality
GridStatusRaidDebuff:DebuffId(zoneid, 137408, 154, 2, 2) --Fan of Flames (tank only)
GridStatusRaidDebuff:DebuffId(zoneid, 137360, 155, 6, 6, true, true) --Corrupted Healing (tanks and healers only?)
GridStatusRaidDebuff:DebuffId(zoneid, 137375, 156, 3, 3) --Beast of Nightmares
GridStatusRaidDebuff:DebuffId(zoneid, 136722, 157, 6, 6) --Slumber Spores

--Lei Shen
GridStatusRaidDebuff:BossNameId(zoneid, 160, "Lei Shen")
GridStatusRaidDebuff:DebuffId(zoneid, 135695, 161, 6, 6) --Static Shock
GridStatusRaidDebuff:DebuffId(zoneid, 136295, 162, 6, 6) --Overcharged
GridStatusRaidDebuff:DebuffId(zoneid, 135000, 163, 2, 2) --Decapitate (Tank only)
GridStatusRaidDebuff:DebuffId(zoneid, 136478, 164, 5, 5) --Fusion Slash
GridStatusRaidDebuff:DebuffId(zoneid, 136543, 165, 5, 5) --Ball Lightning
GridStatusRaidDebuff:DebuffId(zoneid, 134821, 166, 4, 4) --Discharged Energy
GridStatusRaidDebuff:DebuffId(zoneid, 136326, 167, 6, 6) --Overcharge
GridStatusRaidDebuff:DebuffId(zoneid, 137176, 168, 4, 4) --Overloaded Circuits
GridStatusRaidDebuff:DebuffId(zoneid, 136853, 169, 4, 4) --Lightning Bolt
GridStatusRaidDebuff:DebuffId(zoneid, 135153, 170, 6, 6) --Crashing Thunder
GridStatusRaidDebuff:DebuffId(zoneid, 136914, 171, 2, 2) --Electrical Shock
GridStatusRaidDebuff:DebuffId(zoneid, 135001, 172, 2, 2) --Maim

--Ra-den (Heroic only)
GridStatusRaidDebuff:BossNameId(zoneid, 180, "Ra-den")
GridStatusRaidDebuff:DebuffId(zoneid, 138308, 181, 6, 6) --Unstable Vita
GridStatusRaidDebuff:DebuffId(zoneid, 138372, 182, 5, 5) --Vita Sensitivity

