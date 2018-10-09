-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local pairs, type, ipairs, bit, select = 
      pairs, type, ipairs, bit, select

local clientVersion = select(4, GetBuildInfo())
local addonVersion = tonumber(GetAddOnMetadata("TellMeWhen", "X-Interface"))

local _, pclass = UnitClass("Player")


---------------------------------------------------------
-- NEGATIVE SPELLIDS WILL BE REPLACED BY THEIR SPELL NAME
---------------------------------------------------------

--[[ TODO: add the following:
	Tremble before me
	heart strike's snare
	
	]]
TMW.BE = {
	debuffs = {
		ReducedHealing = {
			 115804, -- Mortal Wounds
		},
		CrowdControl = {
			   -118, -- Polymorph
			  -6770, -- Sap
			   -605, -- Mind Control
			  20066, -- Repentance
			 -51514, -- Hex (also 211004, 210873, 211015, 211010)
			  -9484, -- Shackle Undead
			  -5782, -- Fear
			  33786, -- Cyclone
			  -3355, -- Freezing Trap
			 209790, -- Freezing Arrow (hunter pvp)
			   -710, -- Banish
			  -6358, -- Seduction
			  -2094, -- Blind
			 -19386, -- Wyvern Sting
			 -82691, -- Ring of Frost
			 115078, -- Paralysis
			 115268, -- Mesmerize
			 107079, -- Quaking Palm
			 207685, -- Sigil of Misery (Havoc Demon hunter)
			 198909, -- Song of Chi-ji (mistweaver monk talent)
		},
		Shatterable = {
			    122, -- Frost Nova
			 -82691, -- Ring of Frost
			  33395, -- Freeze
		},
		Bleeding = {
			  -1822, -- Rake
			  -1079, -- Rip
			-115767, -- Deep Wounds
			   -703, -- Garrote
			  16511, -- Hemorrhage
			 -11977, -- Rend
			 155722, -- Rake
			   1943, -- Rupture
			  77758, -- Thrash
			 106830, -- Thrash
			 162487, -- Steel Trap (hunter talent)
			 185855, -- Lacerate (Survival hunter)
			 194279, -- Caltrops (hunter talent)
		},
		Feared = {
			  -5782, -- Fear
			  -5484, -- Howl of Terror
			   5246, -- Intimidating Shout
			  -6789, -- Mortal Coil
			 -87204, -- Sin and Punishment
			  -8122, -- Psychic Scream
			 207685, -- Sigil of Misery (Havoc Demon hunter)
		},
		Incapacitated = {
			     99, -- Incapacitating Roar
			   3355, -- Freezing Trap
			 209790, -- Freezing Arrow (hunter pvp)
			  -6770, -- Sap
			   -118, -- Polymorph
			 115268, -- Mesmerize
			 -51514, -- Hex (also 211004, 210873, 211015, 211010)
			  20066, -- Repentance
			 200196, -- Holy Word: Chastise
			  82691, -- Ring of Frost
			   1776, -- Gouge
			  -6358, -- Seduction
			 -19386, -- Wyvern Sting
			 115078, -- Paralysis
			  31661, -- Dragon's Breath
			 107079, -- Quaking Palm
			 198909, -- Song of Chi-ji (mistweaver monk talent)
			 203126, -- Maim (with blood trauma feral pvp talent)
			 226943, -- Mind Bomb
		},
		Disoriented = {
			  -2094, -- Blind
			  31661, -- Dragon's Breath
			 105421, -- Bliding light (paladin talent)
			 186387, -- Bursting Shot (hunter marks ability)
			 202274, -- Incendiary brew (brewmaster monk pvp talent)
			 207167, -- Blinding Sleet (dk talent)
			 213691, -- Scatter Shot (hunter pvp talent)
		},
		Silenced = {
			 -15487, -- Silence
			 -25046, -- Arcane Torrent
			  -1330, -- Garrote - Silence
			  31935, -- Avenger's Shield
			 -78675, -- Solar Beam
			 202933, -- Spider Sting
			 199683, -- Last Word
			 -47476, -- Strangulate
			  31117, -- Unstable Affliction
			 204490, -- Sigil of Silence
		},
		Rooted = {
			   -339, -- Entangling Roots
			   -122, -- Frost Nova
			  33395, -- Freeze (frost mage water elemental)
			  45334, -- Immobilized (wild charge, bear form)
			  53148, -- Charge
			  96294, -- Chains of Ice
			 -64695, -- Earthgrab
			  91807, -- Shambling Rush (DK ghoul)
			 102359, -- Mass Entanglement
			 105771, -- Charge
			 116706, -- Disable
			 117526, -- Binding Shot
			 157997, -- Ice Nova (frost mage talent)
			 162480, -- Steel Trap (hunter talent)
			 190927, -- harpoon (survival hunter)
			 199042, -- Thunderstruck (Warrior PVP)
			 200108, -- Ranger's Net (Hunter talent)
			 201158, -- Super Sticky Tar (Expert Trapper, Hunter talent, Tar Trap effect)
			 204085, -- Deathchill (DK PVP)
			 212638, -- tracker's net (hunter PvP )
			 228600, -- glacial spike (frost mage talent)
		},
		Slowed = {
			   -116, -- Frostbolt
			   -120, -- Cone of Cold
			   2120, -- Flamestrike
			   6343, -- Thunder Clap
			  -1715, -- Hamstring
			  -3409, -- Crippling Poison
			  -3600, -- Earthbind
			  -5116, -- Concussive Shot
			 -12544, -- Frost Armor
			  -7992, -- Slowing Poison
			  26679, -- Deadly Throw
			  35346, -- Warp Time
			  44614, -- Flurry
			  45524, -- Chains of Ice
			  50259, -- Dazed (Wild Charge, druid talent, cat form)
			  50433, -- Ankle Crack
			  51490, -- Thunderstorm
			  61391, -- Typhoon
			 -12323, -- Piercing Howl
			 -13810, -- Ice Trap
			 -15407, -- Mind Flay
			 -31589, -- Slow
			 -58180, -- Infected Wounds
			 102793, -- Ursol's Vortex
			 116095, -- Disable
			 121253, -- Keg Smash
			 123586, -- Flying Serpent Kick
			 135299, -- Tar Trap
			 147732, -- Frostbrand Attack
			 157981, -- Blast Wave
			 160065, -- Tendon Rip
			 160067, -- Web Spray
			 169733, -- Brutal Bash
			 183218, -- Hand of Hindrance
			 185763, -- Pistol Shot
			 190780, -- Frost Breath (dk frost artifact ability)
			 191397, -- Bestial Cunning
			 194279, -- Caltrops
			 194858, -- Dragonsfire Grenade
			 195645, -- Wing Clip
			-196840, -- Frost Shock
			 198813, -- Vengeful Retreat
			 201142, -- Frozen Wake (freezing trap break slow from master trapper survival hunter talent)
			 204263, -- Shining Force
			 204843, -- Sigil of Chains
			 205021, -- Ray of Frost (frost mage talent)
			 205320, -- Strike of the Windlord
			 205708, -- Chilled (frost mage effect)
			 206755, -- Ranger's Net
			 206760, -- Night Terrors
			 206930, -- Heart Strike
			 208278, -- Debilitating Infestation (DK unholy talent)
			 209786, -- Goremaw's Bite
			 211793, -- Remorseless Winter
			 211831, -- Abomination's Might
			 212764, -- White Walker
			 212792, -- Cone of Cold (frost mage)
			 222775, -- Strike from the Shadows
			 228354, -- Flurry (frost mage ability)
			 210979, -- Focus in the light (holy priest artifact trait)
		},
		Stunned = {
			  -1833, -- Cheap Shot
			    -25, -- Stun
			   -408, -- Kidney Shot
			   -853, -- Hammer of Justice
			   5211, -- Mighty Bash
			  -7922, -- Warbringer
			  24394, -- Intimidation
			  64044, -- Psychic Horror
			  91797, -- Monstrous Blow
			 -20549, -- War Stomp
			  22703, -- Summon Infernal
			 -30283, -- Shadowfury
			 -89766, -- Axe Toss
			 -91800, -- Gnaw
			 108194, -- Asphyxiate (death knight, talent for unholy)
			 118345, -- Pulverize
			 118905, -- Static Charge
			 119381, -- Leg Sweep
			-131402, -- Stunning Strike
			 132168, -- Shockwave
			 132169, -- Storm Bolt
			 163505, -- Rake
			 179057, -- Chaos Nova
			 196958, -- Strike from the Shadows
			 199804, -- Between the Eyes
			 200166, -- Metamorphosis
			 200200, -- Holy Word: Chastise
			 203123, -- Maim
			 204399, -- Earthfury (enhancement shaman pvp talent)
			 205630, -- Illidan's Grasp (demon hunter vengeance pvp talent - primary effect)
			 208618, -- Illidan's Grasp (demon hunter vengeance pvp talent - throw effect)
			 207165, -- Abomination's Might
			 207171, -- Winter is Coming
			 211881, -- Fel Eruption
			 221562, -- Asphyxiate (death knight, baseline for blood)
		},
	},
	buffs = {
		SpeedBoosts = {
			  -2983, -- Sprint
			   2379, -- Speed
			   2645, -- Ghost Wolf
			   7840, -- Swim Speed
			  36554, -- Shadowstep
			  54861, -- Nitro Boosts
			  58875, -- Spirit Walk
			 -65081, -- Body and Soul
			  68992, -- Darkflight
			  85499, -- Speed of Light
			  87023, -- Cauterize
			 -61684, -- Dash
			 -77761, -- Stampeding Roar
			 108843, -- Blazing Speed
			 111400, -- Burning Rush
			 116841, -- Tiger's Lust
			 118922, -- Posthaste
			 119085, -- Chi Torpedo
			 121557, -- Angelic Feather
			 137452, -- Displacer Beast
			 137573, -- Burst of Speed
			 192082, -- Wind Rush (shaman wind rush totem talent)
			 196674, -- Planewalker (warlock artifact trait)
			 197023, -- Cut to the chase (rogue pvp talent)
			 199407, -- Light on your feet (mistweaver monk artifact trait)
			 201233, -- whirling kicks (windwalaker monk pvp talent)
			 201447, -- Ride the wind (windwalaker monk pvp talent)
			 209754, -- Boarding Party (rogue pvp talent)
			 210980, -- Focus in the light (holy priest artifact trait)
			 213177, -- swift as a coursing river (brewmaster artifact trait)
			 214121, -- Body and Mind (priest talent)
			 215572, -- Frothing Berserker (warrior talent)
			 231390, -- Trailblazer (hunter talent)
			-186257, -- Aspect of the Cheetah
			-204475, -- Windburst (marks hunter artifact ability)
		},
		ImmuneToStun = {
			  33786, -- Cyclone
			 -19263, -- Deterrence
			  48792, -- Icebound Fortitude
			  46924, -- Bladestorm
			 227847, -- Bladestorm again?
			    710, -- Banish
			   6615, -- Free Action
			  45438, -- Ice Block
			    642, -- Divine Shield
			   1022, -- Blessing of Protection
		},
		DefensiveBuffsAOE = {
			 -62618, -- Power Word: Barrier
			 -31821, -- Aura Mastery
			 -76577, -- Smoke Bomb
			 -51052, -- Anti-Magic Zone
			 204150, -- Aegis of light (prot pally talent)
			 204335, -- Aegis of light (prot pally talent)
		},
		DefensiveBuffsSingle = {
			 114030, -- Vigilance
			  47788, -- Guardian Spirit
			  31850, -- Ardent Defender
			  23920, -- Spell Reflection
			    871, -- Shield Wall
			 118038, -- Die by the Sword
			  48707, -- Anti-Magic Shell
			 104773, -- Unending Resolve
			   6940, -- Blessing of Sacrifice
			 108271, -- Astral Shift
			   5277, -- Evasion
			 102342, -- Ironbark
			 155835, -- Bristling Fur
			   1022, -- Blessing of Protection
			  74001, -- Combat Readiness
			  31224, -- Cloak of Shadows
			  33206, -- Pain Suppression
			  47585, -- Dispersion
			 -19263, -- Deterrence
			  48792, -- Icebound Fortitude
			 115176, -- Zen Meditation
			 122783, -- Diffuse Magic
			  86659, -- Guardian of Ancient Kings
			    642, -- Divine Shield
			  45438, -- Ice Block
			    498, -- Divine Protection
			 157913, -- Evanesce
			 115203, -- Fortifying Brew
			  22812, -- Barkskin
			 122278, -- Dampen Harm
			 113862, -- Greater Invisibility
			  61336, -- Survival Instincts
		},
		DamageBuffs = {
			  12292, -- Bloodbath
			   1719, -- Battle Cry
			  12472, -- Icy Veins
			  51271, -- Pillar of Frost
			  31884, -- Avenging Wrath
			-107574, -- Avatar
			 114050, -- Ascendance
			 114051, -- Ascendance
			   5217, -- Tiger's Fury
		},
		MiscHelpfulBuffs = {
			   1044, -- Blessing of Freedom
			  23920, -- Spell Reflection
			  10060, -- Power Infusion
			   2983, -- Sprint
			  45182, -- Cheating Death
			  31821, -- Aura Mastery
			  68992, -- Darkflight
			  53271, -- Master's Call
			   1850, -- Dash
		},
		DamageShield = {
			 114908, -- Spirit Shell
			 108008, -- Indomitable
			   1463, -- Incanter's Flow
			 173260, -- Shieldtronic Shield
			 108366, -- Soul Leech
			 169373, -- Boulder Shield
			 152118, -- Clarity of Will
			 145441, -- Yu'lon's Barrier
			 108416, -- Dark Pact
			 -11426, -- Ice Barrier
			    -17, -- Power Word: Shield
			  77535, -- Blood Shield
			 116849, -- Life Cocoon
			 194022 --- Mental Fortitude (Shadow Priest Artifact)
		},
		ImmuneToMagicCC = {
			  33786, -- Cyclone
			 -19263, -- Deterrence
			  23920, -- Spell Reflection
			  46924, -- Bladestorm
			  48707, -- Anti-Magic Shell
			  45438, -- Ice Block
			    642, -- Divine Shield
			  31224, -- Cloak of Shadows
			   8178, -- Grounding Totem Effect
			    710, -- Banish
		     204018, -- Blessing of Spellwarding
		},
		BurstHaste = {
			  90355, -- Ancient Hysteria
			 146555, -- Drums of Rage
			 178207, -- Drums of Fury
			 230935, -- Drums of the Mountain
			   2825, -- Bloodlust
			  80353, -- Time Warp
			 160452, -- Netherwinds
			  32182, -- Heroism,
			  264667, -- Primal Rage
			  256740, -- Drums of the Maelstrom
		},
	},
	casts = {
		Heals = {
			   2061, -- Flash Heal
			    596, -- Prayer of Healing
			   2060, -- Heal
			  32546, -- Binding Heal
			  33076, -- Prayer of Mending
			  64843, -- Divine Hymn
			 120517, -- Halo
			 152118, -- Clarity of Will
			 186263, -- Shadow Mend
			 194509, -- Power Word: Radiance
			 204065, -- Shadow Covenant

			    740, -- Tranquility
			   8936, -- Regrowth
			  48438, -- Wild Growth

			   1064, -- Chain Heal
			   8004, -- Healing Surge
			  73920, -- Healing Rain
			  77472, -- Healing Wave
			 207778, -- Gift of the Queen

			  19750, -- Flash of Light
			  82326, -- Holy Light
			 200652, -- Tyr's Deliverance

			 116670, -- Vivify
			 124682, -- Enveloping Mist
			 191837, -- Esssence Font
			 205406, -- Sheilun's Gift
			 209525, -- Soothing Mist

		},
		PvPSpells = {
			    339, -- Entangling Roots
			  33786, -- Cyclone
			   5782, -- Fear
			   -605, -- Mind Control
			  51514, -- Hex
			  20066, -- Repentance
			    982, -- Revive Pet
			  12051, -- Evocation
			    118, -- Polymorph
			   5484, -- Howl of Terror
			  20484, -- Rebirth
		},
	},
}

TMW.BE.buffs.DefensiveBuffs	= CopyTable(TMW.BE.buffs.DefensiveBuffsSingle)
for k, v in pairs(TMW.BE.buffs.DefensiveBuffsAOE) do
	tinsert(TMW.BE.buffs.DefensiveBuffs, v)
end


TMW.DS = {
	Magic 	= "Interface\\Icons\\spell_fire_immolation",
	Curse 	= "Interface\\Icons\\spell_shadow_curseofsargeras",
	Disease = "Interface\\Icons\\spell_nature_nullifydisease",
	Poison 	= "Interface\\Icons\\spell_nature_corrosivebreath",
	Enraged = "Interface\\Icons\\ability_druid_challangingroar",
}

local function ProcessEquivalencies()
	TMW.EquivOriginalLookup = {}
	TMW.EquivFullIDLookup = {}
	TMW.EquivFullNameLookup = {}
	TMW.EquivFirstIDLookup = {}
	
	TMW:Fire("TMW_EQUIVS_PROCESSING")
	TMW:UnregisterAllCallbacks("TMW_EQUIVS_PROCESSING")

	for dispeltype, texture in pairs(TMW.DS) do
		TMW.EquivFirstIDLookup[dispeltype] = texture
		TMW.SpellTexturesMetaIndex[strlower(dispeltype)] = texture
	end
	
	for category, b in pairs(TMW.BE) do
		for equiv, tbl in pairs(b) do
			TMW.EquivOriginalLookup[equiv] = CopyTable(tbl)
			TMW.EquivFirstIDLookup[equiv] = abs(tbl[1])
			TMW.EquivFullIDLookup[equiv] = ""
			TMW.EquivFullNameLookup[equiv] = ""

			-- turn all negative IDs into their localized name.
			-- When defining equavalancies, dont put a negative on every single one,
			-- but do use it for spells that do not have any other spells with the same name and different effects.
			
			for i, spellID in pairs(tbl) do

				local realSpellID = abs(spellID)
				local name, _, tex = GetSpellInfo(realSpellID)

				TMW.EquivFullIDLookup[equiv] = TMW.EquivFullIDLookup[equiv] .. ";" .. realSpellID
				TMW.EquivFullNameLookup[equiv] = TMW.EquivFullNameLookup[equiv] .. ";" .. (name or realSpellID)
				
				if spellID < 0 then
					
					-- name will be nil if the ID isn't a valid spell (possibly the spell was removed in a patch).
					if name then
						-- this will insert the spell name into the table of spells for capitalization restoration.
						TMW:LowerNames(name) 
						
						-- map the spell's name and ID to its texture for the spell texture cache
						TMW.SpellTexturesMetaIndex[realSpellID] = tex
						TMW.SpellTexturesMetaIndex[TMW.strlowerCache[name]] = tex

						tbl[i] = name
					else
						
						if clientVersion >= addonVersion then -- only warn for newer clients using older versions
							TMW:Debug("Invalid spellID found: %s (%s - %s)!",
							realSpellID, category, equiv)
						end

						tbl[i] = realSpellID
					end
				else
					tbl[i] = realSpellID
				end
			end

			for _, spell in pairs(tbl) do
				if type(spell) == "number" and not GetSpellInfo(spell) then
					TMW:Debug("Invalid spellID found: %s (%s - %s)!",
						spell, category, equiv)
				end
			end
		end
	end
end

TMW:RegisterCallback("TMW_INITIALIZE", ProcessEquivalencies)
