--local zone = "Blackrock Foundry"
local zoneid = 597

--zoneid, debuffID, order, icon_priority, colorpriority, timer, stackable, color, defaultdisable, noicon
--true, true is for stackable

-- Check Compatibility
if GridStatusRD_WoD.rd_version < 600 then
	return
end

-- Trash

-- Slagworks/Black Forge trash
-- Orgron Hauler
GridStatusRaidDebuff:DebuffId(zoneid, 175752, 1, 3, 3, true) -- Slag Breath (frontal cone debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 175765, 1, 4, 4, true) -- Overhead Smash (tank debuff)
-- Workshop Guardian
GridStatusRaidDebuff:DebuffId(zoneid, 175624, 1, 5, 5, false, true) -- Grievous Mortal Wounds (stacking healing debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 175643, 1, 4, 4) -- Spinning Blade (dot, standing in)
-- Iron Flame Binder
-- Iron Slag-Shaper
GridStatusRaidDebuff:DebuffId(zoneid, 175603, 1, 4, 4, true) -- Gripping Slag (AoE dot, root)
-- Ironworker
GridStatusRaidDebuff:DebuffId(zoneid, 175668, 1, 3, 3, true) -- Hammer Throw (dam increase)
-- Slagshop Brute
-- Slagshop Worker
GridStatusRaidDebuff:DebuffId(zoneid, 175987, 1, 3, 3, true, true) -- Puncture Wound (stacking dot)

-- Oregorger trash (Depository)
-- Darkshard Acidback
GridStatusRaidDebuff:DebuffId(zoneid, 159686, 1, 4, 4) -- Acidback Puddle (dot, standing in)
-- Darkshard Gnasher
GridStatusRaidDebuff:DebuffId(zoneid, 159632, 1, 5, 5, true) -- Insatiable Hunger (fixate)
GridStatusRaidDebuff:DebuffId(zoneid, 159520, 1, 2, 2, true) -- Shattering Charge (stun)
-- Darkshard Crystalback
GridStatusRaidDebuff:DebuffId(zoneid, 159939, 1, 3, 3, true, true) -- Acidmaw (stacking debuff)

-- Hans'gar and Franzok trash (Slagmill Press)
-- Blackrock Enforcer
GridStatusRaidDebuff:DebuffId(zoneid, 160260, 1, 4, 4) -- Fire Bomb (dot, standing in)
GridStatusRaidDebuff:DebuffId(zoneid, 160109, 1, 1, 1, true) -- Intimidation (damage reduction)
-- Blackrock Forge Specialist

-- Beastlord Darmac trash (Breaking Grounds)
-- Iron Assembly Warden
GridStatusRaidDebuff:DebuffId(zoneid, 162516, 1, 4, 4, true) -- Whirling Steel (dot)
GridStatusRaidDebuff:DebuffId(zoneid, 162508, 1, 2, 2, true) -- Shield Slam (stun)
-- Iron Marksman
GridStatusRaidDebuff:DebuffId(zoneid, 162748, 1, 2, 2, true) -- Scatter Shot (disorient)
GridStatusRaidDebuff:DebuffId(zoneid, 162757, 1, 1, 1, true) -- Ice Trap (attack speed/movement debuff)
-- Thunderlord Beast-Tender
GridStatusRaidDebuff:DebuffId(zoneid, 162663, 1, 4, 4) -- Electrical Storm (dot, standing in)
-- Ornery Ironhoof
GridStatusRaidDebuff:DebuffId(zoneid, 162672, 1, 4, 4, true) -- Goring Swipe (dot)
-- Stubborn Ironhoof
-- Markog Aba'dir

-- Gruul trash
-- Gronnling Labroer
-- Iron Journeyman
-- Karnor the Cruel (mini-boss)
GridStatusRaidDebuff:DebuffId(zoneid, 188189, 1, 6, 6, true) -- Fel Poison (dot, dispellable)

-- Burning Font trash
-- Enchanted Armament
-- Iron Flametwister
-- Iron Journeyman (duplicate)
-- Iron Taskmaster
GridStatusRaidDebuff:DebuffId(zoneid, 163126, 1, 6, 6, true) -- Bonk (tank disorient)
-- Iron Smith

-- Flamebender Ka'graz trash
-- Mol'dana Two-Blade (mini-boss)
GridStatusRaidDebuff:DebuffId(zoneid, 177855, 1, 4, 4, true) -- Ember in the Wind (AoE dot)
GridStatusRaidDebuff:DebuffId(zoneid, 177891, 1, 2, 2, true, true) -- Rising Flame Kick (tank dot)

-- Operator Thogar trash
-- same trash as during the boss fight, trash is listed under the boss
-- Exhaust vent
GridStatusRaidDebuff:DebuffId(zoneid, 174773, 1, 6, 6) -- Exhaust Fumes (dot, standing on)

-- The Blast Furnace trash
-- Slag Behemoth
GridStatusRaidDebuff:DebuffId(zoneid, 156345, 1, 6, 6, true) -- Ignite (player explodes)

-- Kromog trash
-- just one pack of Burning Font trash between Flamebender and Kromog

-- The Iron Maidens trash
-- Aquatic Technician
-- Iron Dockworker
-- Iron Earthbinder
-- Iron Mauler
-- Iron Cleaver
GridStatusRaidDebuff:DebuffId(zoneid, 171537, 1, 4, 4, true) -- Reaping Whirl (dot)

-- Blackhand trash
-- Flame Jets
GridStatusRaidDebuff:DebuffId(zoneid, 175577, 1, 4, 4) -- Flame Jets (dot, standing in)
-- Forgemistress Flamehand
-- Burning is duplicate to Operator Thogar ability
GridStatusRaidDebuff:DebuffId(zoneid, 175583, 1, 5, 5, true) -- Living Blaze (AoE dot, dam nearby players)

-- Unknown trash
-- Fungal Spores (debuff that is a buff?)
GridStatusRaidDebuff:DebuffId(zoneid, 174704, 1, 1, 1, true, false, 0, true) -- Fungal Spores (disabled)

-- this Exhaustion debuff causes problems with GridStatusRaidDebuff prior to r28 (6.11)
-- It would cause the Exhaustion from Heroism to always be displayed
if GridStatusRD_WoD.rd_version < 611 then
   -- Disable the trash Exhaustion debuff
   GridStatusRaidDebuff:DebuffId(zoneid, 163714, 1, 1, 1, true, false, 0, true) -- Exhaustion (disabled)
else 
   -- GridStatusRaidDebuff versions over 6.11 can handle displaying this debuff
   GridStatusRaidDebuff:DebuffId(zoneid, 163714, 1, 1, 1, true) -- Exhaustion (root)
end

-- Bosses

-- Oregorger
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Oregorger")
GridStatusRaidDebuff:DebuffId(zoneid, 173471, 11, 5, 5, true) -- Acid Maw (dot, nondispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 156297, 12, 6, 6, true) -- Acid Torrent (tank debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 156374, 13, 2, 2, true) -- Explosive Shard (stun)
GridStatusRaidDebuff:DebuffId(zoneid, 155900, 14, 2, 2, true) -- Rolling Fury (knocked down)
-- Retched Blackrock
GridStatusRaidDebuff:DebuffId(zoneid, 156203, 15, 5, 5) -- Retched Blackrock (standing in pool?)

-- Hans'gar and Franzok 
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Hans'gar and Franzok")
-- both have these abilities
GridStatusRaidDebuff:DebuffId(zoneid, 157853, 21, 2, 2, true) -- Aftershock (dot)
GridStatusRaidDebuff:DebuffId(zoneid, 156938, 22, 6, 6) -- Crippling Suplex (picked up)
GridStatusRaidDebuff:DebuffId(zoneid, 157139, 23, 6, 6, true) -- Shattered Vertebrae (increase dam)
-- Searing Plates
GridStatusRaidDebuff:DebuffId(zoneid, 161570, 24, 5, 5) -- Searing Plates (standing on)
-- Grill
GridStatusRaidDebuff:DebuffId(zoneid, 155818, 24, 5, 5) -- Scorching Burns (standing on)

-- Beastlord Darmac
GridStatusRaidDebuff:BossNameId(zoneid, 30, "Beastlord Darmac")
-- Phase 1
GridStatusRaidDebuff:DebuffId(zoneid, 154960, 31, 6, 6) -- Pinned Down (stun, dot)
-- Cruelfang
GridStatusRaidDebuff:DebuffId(zoneid, 155061, 32, 4, 4, true, true) -- Rend and Tear (dot, increase dam, stacks)
-- Dreadwing
GridStatusRaidDebuff:DebuffId(zoneid, 154989, 33, 5, 5, true) -- Inferno Breath (dot, dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 154981, 34, 6, 6, true) -- Conflagration (AoE dot, dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 155030, 35, 4, 4, true, true) -- Seared Flesh (tank dot, stacks)
-- Ironcrusher
GridStatusRaidDebuff:DebuffId(zoneid, 155236, 36, 4, 4, true, true) -- Crush Armor (tank stacking debuff)
-- Phase 3
GridStatusRaidDebuff:DebuffId(zoneid, 155499, 37, 5, 5, true) -- Superheated Shrapnel (dot, dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 155657, 38, 6, 6) -- Flame Infusion (standing in fire)
-- Mythic
-- Faultline
GridStatusRaidDebuff:DebuffId(zoneid, 159044, 39, 2, 2, true) -- Epicenter (standing in, movement debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 162276, 40, 1, 1, true) -- Unsteady
-- GridStatusRaidDebuff:DebuffId(zoneid, 155222, 41, 6, 6) --TANTRUM (not a debuff)

-- Gruul
GridStatusRaidDebuff:BossNameId(zoneid, 50, "Gruul")
GridStatusRaidDebuff:DebuffId(zoneid, 155080, 51, 3, 3, true) -- Inferno Slice (dot, nondispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 162322, 52, 2, 2, true, true) -- Inferno Strike (tank debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 155078, 53, 4, 4, true, true) -- Overwhelming Blows (tank debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 173192, 54, 6, 6) -- Cave In
GridStatusRaidDebuff:DebuffId(zoneid, 155323, 55, 5, 5) -- Petrifying Slam (knockback flying)
GridStatusRaidDebuff:DebuffId(zoneid, 155330, 56, 5, 5, true, true) -- Petrify (movement, petrify)
GridStatusRaidDebuff:DebuffId(zoneid, 155506, 57, 5, 5, true) -- Petrified
-- Mythic
GridStatusRaidDebuff:DebuffId(zoneid, 165298, 58, 4, 4, true) -- Flare (debuff, nondispellable)

-- Flamebender Ka'graz
GridStatusRaidDebuff:BossNameId(zoneid, 60, "Flamebender Ka'graz")
GridStatusRaidDebuff:DebuffId(zoneid, 155277, 61, 5, 5, true) -- Blazing Radiance (AoE dot)
GridStatusRaidDebuff:DebuffId(zoneid, 163284, 62, 4, 4, true, true) -- Rising Flames (tank dot, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 154932, 63, 6, 6, true) -- Molten Torrent (split damage)
-- Lava Slash
GridStatusRaidDebuff:DebuffId(zoneid, 155314, 64, 3, 3) -- Lava Slash (standing in, not high damage)
-- Cinder Wolf
GridStatusRaidDebuff:DebuffId(zoneid, 154952, 65, 5, 5, true) -- Fixate
GridStatusRaidDebuff:DebuffId(zoneid, 155074, 66, 3, 3, true, true) -- Charring Breath (stacking debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 155049, 67, 4, 4, true, true) -- Singe (dot, dispellable)
-- GridStatusRaidDebuff:DebuffId(zoneid, 162293, 68, 5, 5) --EMPOWEREDARMAMENT -- not a debuff
-- GridStatusRaidDebuff:DebuffId(zoneid, 155493, 68, 5, 5) --FIRESTORM -- not a debuff
-- GridStatusRaidDebuff:DebuffId(zoneid, 163633, 68, 5, 5) --MAGMAMONSOON -- not a debuff

-- Operator Thogar 
GridStatusRaidDebuff:BossNameId(zoneid, 70, "Operator Thogar")
GridStatusRaidDebuff:DebuffId(zoneid, 155921, 71, 3, 3, true, true) -- Enkindle (stacking tank dot)
GridStatusRaidDebuff:DebuffId(zoneid, 165195, 72, 6, 6) -- Prototype Pulse Grenade (standing in)
GridStatusRaidDebuff:DebuffId(zoneid, 164380, 73, 5, 5, true, true) -- Burning (stacking dot, dispellable)
-- Iron Raider
GridStatusRaidDebuff:DebuffId(zoneid, 155701, 74, 2, 2, true) -- Serrated Slash (dot)
-- Grom'kar Firemender
GridStatusRaidDebuff:DebuffId(zoneid, 156310, 75, 4, 4) -- Lava Shock (dot, dispellable)
-- Cauterizing Bolt is an offensive dispel
-- Iron Gunnery Sergeants
GridStatusRaidDebuff:DebuffId(zoneid, 159481, 76, 6, 6, true) -- Delayed Siege Bomb (targetted)
-- Iron Crack-Shots
-- Grom'kar Men-at-Arms

-- The Blast Furnace
GridStatusRaidDebuff:BossNameId(zoneid, 80, "The Blast Furnace")
-- Heart of the Mountain
GridStatusRaidDebuff:DebuffId(zoneid, 155240, 81, 3, 3, false, true) -- Tempered (tank debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 155242, 82, 4, 4, true, true) -- Heat (stacking tank dot)
GridStatusRaidDebuff:DebuffId(zoneid, 155225, 83, 5, 5, true) -- Melt (create void zone)
-- Furnace Engineer
GridStatusRaidDebuff:DebuffId(zoneid, 155192, 84, 5, 5, true) -- Bomb (carrying the bomb)
-- Foreman Feldspar
GridStatusRaidDebuff:DebuffId(zoneid, 156934, 85, 6, 6, true) -- Rupture (create void zone)
GridStatusRaidDebuff:DebuffId(zoneid, 158246, 86, 1, 1) -- Hot Blooded (dot from being near)
-- Firecaller
GridStatusRaidDebuff:DebuffId(zoneid, 176121, 87, 4, 4, true) -- Volatile Fire (player explodes)
-- Slag Elemental
GridStatusRaidDebuff:DebuffId(zoneid, 155196, 88, 4, 4) -- Fixate
-- Slag Pool
GridStatusRaidDebuff:DebuffId(zoneid, 155743, 89, 6, 6) -- Slag Pool (standing in)
-- Unknown
GridStatusRaidDebuff:DebuffId(zoneid, 175104, 90, 6, 6) -- Melt Armor (is this for this boss?)
-- Bellows Operator
-- Security Guard
-- Primal Elementalist

-- Kromog
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Kromog")
GridStatusRaidDebuff:DebuffId(zoneid, 157059, 101, 2, 2) -- Rune of Grasping Earth (dot until killed)
GridStatusRaidDebuff:DebuffId(zoneid, 156766, 102, 4, 4, true, true) -- Warped Armor (stacking tank debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 161839, 103, 3, 3, true) -- Rune of Crushing Earth (stun, non-dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 156844, 104, 6, 6, true) -- Stone Breath (dot, no one in melee)

-- The Iron Maidens
GridStatusRaidDebuff:BossNameId(zoneid, 110, "The Iron Maidens")
-- Admiral Gar'an
GridStatusRaidDebuff:DebuffId(zoneid, 164271, 111, 6, 6, true) -- Penetraing Shot (target, damage split)
GridStatusRaidDebuff:DebuffId(zoneid, 156631, 112, 4, 4, true) -- Rapid Fire (target, damage)
-- GridStatusRaidDebuff:DebuffId(zoneid, 159585, 120, 5, 5) --DEPLOYTURRET - not a debuff
-- Enforcer Sorka
GridStatusRaidDebuff:DebuffId(zoneid, 158315, 113, 5, 5) -- Dark Hunt (target, teleport to)
GridStatusRaidDebuff:DebuffId(zoneid, 170395, 114, 2, 2) -- Sorka's Prey (dam increase)
-- Marak the Blooded
GridStatusRaidDebuff:DebuffId(zoneid, 159724, 115, 6, 6, true) -- Blood Ritual (target, cone dam)
GridStatusRaidDebuff:DebuffId(zoneid, 170405, 116, 2, 2) -- Marak's  Bloodcalling (dam increase)
GridStatusRaidDebuff:DebuffId(zoneid, 158010, 117, 5, 5, true) -- Bloodsoaked Heartseeker (target, bounce damage)
-- GridStatusRaidDebuff:DebuffId(zoneid, 156601, 113, 6, 6) --SANGUINESTRIKES -- not a debuff
-- Gorak
GridStatusRaidDebuff:DebuffId(zoneid, 158692, 118, 1, 1, true) -- Deadly Throw (movement)
-- Iron Eviscerator
GridStatusRaidDebuff:DebuffId(zoneid, 158702, 119, 5, 5, true) -- Fixate
GridStatusRaidDebuff:DebuffId(zoneid, 158686, 120, 3, 3, true) -- Expose Armor (dam increase)
-- Uk'urogg
GridStatusRaidDebuff:DebuffId(zoneid, 158683, 121, 6, 6) -- Corrupted Blood (standing in)
GridStatusRaidDebuff:DebuffId(zoneid, 156214, 122, 5, 5, false, true) -- Convulsive Shadows (dot dispellable, dam per stack dispelled)
-- Dominator Turret
GridStatusRaidDebuff:DebuffId(zoneid, 158601, 123, 3, 3, true, true) -- Dominator Blast (stacking dot, non-dispellable)
-- Mythic
-- Swirling Vortex
GridStatusRaidDebuff:DebuffId(zoneid, 160436, 124, 1, 1, true) -- Swirling Vortex (stun)

-- Blackhand
GridStatusRaidDebuff:BossNameId(zoneid, 130, "Blackhand")
GridStatusRaidDebuff:DebuffId(zoneid, 156096, 131, 6, 6, true) -- Marked for Death (targetted by Impaling Throw)
GridStatusRaidDebuff:DebuffId(zoneid, 156743, 132, 4, 4, true, true) -- Impaled (dot)
GridStatusRaidDebuff:DebuffId(zoneid, 156047, 133, 2, 2, true) -- Slagged (dam increase)
GridStatusRaidDebuff:DebuffId(zoneid, 156401, 134, 4, 4, true, true) -- Molten Slag (dot, nondispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 156404, 135, 3, 3, true, true) -- Burned (stacking debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 158054, 136, 5, 5) -- Massive Shattering Smash (tank dot, dam split)
GridStatusRaidDebuff:DebuffId(zoneid, 157354, 137, 2, 2, true) -- Broken Bones (tank stun)
GridStatusRaidDebuff:DebuffId(zoneid, 156888, 138, 1, 1) -- Overheated (phase 3)
GridStatusRaidDebuff:DebuffId(zoneid, 157000, 139, 5, 5, true) -- Attach Slag Bombs (player explodes)
GridStatusRaidDebuff:DebuffId(zoneid, 156999, 140, 5, 5, true) -- Throw Slag Bombs (player explodes)
-- Siegemaker
GridStatusRaidDebuff:DebuffId(zoneid, 156653, 141, 6, 6, true) -- Fixate
-- Blaze (from Siegemaker)
GridStatusRaidDebuff:DebuffId(zoneid, 162490, 142, 5, 5) -- Blaze (standing in)
GridStatusRaidDebuff:DebuffId(zoneid, 156604, 143, 3, 3, true) -- Burning (dot from Blaze)
-- Iron Sentry
GridStatusRaidDebuff:DebuffId(zoneid, 156772, 144, 3, 3, true, true) -- Incendiary Shot (stacking debuff)
-- Mythic
GridStatusRaidDebuff:DebuffId(zoneid, 162498, 145, 6, 6, true, true) -- Burning Cinders (stacking dot, dispellable)

