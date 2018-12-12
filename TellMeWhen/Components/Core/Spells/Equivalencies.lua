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
			  27580, -- Sharpen Blade
			 195452, -- Nightblade
			   8679, -- Wound Poison
			 115625, -- Mortal Cleave
			  30213, -- Legion Strike
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
			   5246, -- Intimidating Shout
			  87204, -- Sin and Punishment
			  -8122, -- Psychic Scream
			  -6789, -- Mortal Coil
			 207685, -- Sigil of Misery (Havoc Demon hunter)
		},
		Incapacitated = {
			     99, -- Incapacitating Roar
			   -118, -- Polymorph
			   2637, -- Hibernate
			   1776, -- Gouge
			  -3355, -- Freezing Trap
			  -6358, -- Seduction
			  -6770, -- Sap
			 -19386, -- Wyvern Sting
			  20066, -- Repentance
			 -51514, -- Hex (also 211015; 211010; 211004; 210873; 196942; 269352; 277778; 277784)
			  82691, -- Ring of Frost
			 107079, -- Quaking Palm
			 115078, -- Paralysis
			 115268, -- Mesmerize
			 197214, -- Sundering
			 200196, -- Holy Word: Chastise
			 203126, -- Maim (with blood trauma feral pvp talent
			 217832, -- Imprison
			 221527, -- Imprison
			 226943, -- Mind Bomb
		},
		Disoriented = {
			  -2094, -- Blind
			  31661, -- Dragon's Breath
			 105421, -- Blinding light (paladin talent)
			 186387, -- Bursting Shot (hunter marks ability)
			 198909, -- Song of Chi-ji (mistweaver monk talent)
			 202274, -- Incendiary brew (brewmaster monk pvp talent)
			 207167, -- Blinding Sleet (dk talent)
			 213691, -- Scatter Shot (hunter pvp talent)
		},
		Silenced = {
			  -1330, -- Garrote - Silence
			 -15487, -- Silence
			  31117, -- Unstable Affliction
			  31935, -- Avenger's Shield
			 -47476, -- Strangulate
			 -78675, -- Solar Beam
			 199683, -- Last Word
			 202933, -- Spider Sting
			 204490, -- Sigil of Silence
			 217824; -- Shield of Virtue
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
			 198121, -- Frostbite
			 199042, -- Thunderstruck (Warrior PVP)
			 200108, -- Ranger's Net (Hunter talent)
			 201158, -- Super Sticky Tar (Expert Trapper, Hunter talent, Tar Trap effect)
			 204085, -- Deathchill (DK PVP)
			 207171, -- Winter is Coming
			 212638, -- tracker's net (hunter PvP )
			 228600, -- glacial spike (frost mage talent)
			 233395, -- Frozen Center
			 233582, -- Entrenched in Flames
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
			    -25, -- Stun
			   -408, -- Kidney Shot
			   -853, -- Hammer of Justice
			  -1833, -- Cheap Shot
			   5211, -- Mighty Bash
			  -7922, -- Warbringer
			  24394, -- Intimidation
			 -20549, -- War Stomp
			  22703, -- Summon Infernal
			 -30283, -- Shadowfury
			 -89766, -- Axe Toss
			  91797, -- Monstrous Blow
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
			 199804, -- Between the Eyes
			 199085, -- Warpath
			 200200, -- Holy Word: Chastise
			 202244, -- Overrun
			 202346, -- Double Barrel
			 203123, -- Maim
			 204399, -- Earthfury (elemental shaman pvp talent)
			 204437, -- ightning Lasso
			 205629, -- Demonic Trample
			 205630, -- Illidan's Grasp (demon hunter vengeance pvp talent - primary effect)
			 208618, -- Illidan's Grasp (demon hunter vengeance pvp talent - throw effect)
			 211881, -- Fel Eruption
			 221562, -- Asphyxiate (death knight, baseline for blood)
			 255723, -- Bull Rush
		},
	},
	buffs = {
		SpeedBoosts = {
			  -2983, -- Sprint
			  -2379, -- Speed
			   2645, -- Ghost Wolf
			   7840, -- Swim Speed
			  36554, -- Shadowstep
			  54861, -- Nitro Boosts
			  58875, -- Spirit Walk
			 -65081, -- Body and Soul
			  68992, -- Darkflight
			  87023, -- Cauterize
			 -61684, -- Dash
			 -77761, -- Stampeding Roar
			 108843, -- Blazing Speed
			 111400, -- Burning Rush
			 116841, -- Tiger's Lust
			 118922, -- Posthaste
			 119085, -- Chi Torpedo
			 121557, -- Angelic Feather
			 188024, -- Skystep Potion
			 192082, -- Wind Rush (shaman wind rush totem talent)
			 196674, -- Planewalker (warlock artifact trait)
			 197023, -- Cut to the chase (rogue pvp talent)
			 199407, -- Light on your feet (mistweaver monk artifact trait)
			 201233, -- whirling kicks (windwalker monk pvp talent)
			 201447, -- Ride the wind (windwalker monk pvp talent)
			 202164, -- Bounding Stride (warrior talent)
			 209754, -- Boarding Party (rogue pvp talent)
			 210980, -- Focus in the light (holy priest artifact trait)
			 213177, -- Swift as a Coursing River (brewmaster artifact trait)
			 214121, -- Body and Mind (priest talent)
			 215572, -- Frothing Berserker (warrior talent)
			 231390, -- Trailblazer (hunter talent)
			-186257, -- Aspect of the Cheetah
			-204475, -- Windburst (marks hunter artifact ability)
			 250878, -- Lightfoot Potion
			-276112, -- Divine Steed
		},
		ImmuneToStun = {
			    642, -- Divine Shield
			    710, -- Banish
			   1022, -- Blessing of Protection
			   6615, -- Free Action
			  33786, -- Cyclone
			  45438, -- Ice Block
			  46924, -- Bladestorm (fury)
			  48792, -- Icebound Fortitude
			 186265, -- Aspect of the Turtle
			 213610, -- Holy Ward
			 227847, -- Bladestorm (arms)
			-228049, -- Guardian of the Forgotten Queen (spellID might be wrong?)
		},
		DefensiveBuffsAOE = {
			 -31821, -- Aura Mastery
			 -51052, -- Anti-Magic Zone
			 -62618, -- Power Word: Barrier
			 201633, -- Earthen Wall
			 204150, -- Aegis of light (prot pally talent)
			 204335, -- Aegis of light (prot pally talent)
			-209426, -- Darkness
		},
		DefensiveBuffsSingle = {
			    498, -- Divine Protection
			    642, -- Divine Shield
			    871, -- Shield Wall
			   1022, -- Blessing of Protection
			   5277, -- Evasion
			   6940, -- Blessing of Sacrifice
			  22812, -- Barkskin
			  23920, -- Spell Reflection
			  31224, -- Cloak of Shadows
			  31850, -- Ardent Defender
			  33206, -- Pain Suppression
			  45438, -- Ice Block
			  47585, -- Dispersion
			  47788, -- Guardian Spirit
			  48707, -- Anti-Magic Shell
			  48792, -- Icebound Fortitude
			  61336, -- Survival Instincts
			  86659, -- Guardian of Ancient Kings
			 102342, -- Ironbark
			 104773, -- Unending Resolve
			 108271, -- Astral Shift
			 113862, -- Greater Invisibility
			 115176, -- Zen Meditation
			 115203, -- Fortifying Brew
			 118038, -- Die by the Sword
			 122278, -- Dampen Harm
			 122783, -- Diffuse Magic
			 155835, -- Bristling Fur
			 184364, -- Enraged Regeneration
			 186265, -- Aspect of the Turtle		 
			 210918, -- Ethereal Form (shaman PVP talent)
			-228049, -- Guardian of the Forgotten Queen (spellID might be wrong?)
		},
		DamageBuffs = {
			   1719, -- Recklessness
			   5217, -- Tiger's Fury
			  12042, -- Arcane Power			   
			  12472, -- Icy Veins
			  13750, -- Adrenaline Rush			  
			  19574, -- Bestial Wrath	
			  31884, -- Avenging Wrath
			  51271, -- Pillar of Frost	
			 102543, -- Incarnation: King of the Jungle
			 102560, -- Incarnation: Chosen of Elune			  
			 106951, -- Berserk
			-107574, -- Avatar	
			 113858, -- Dark Soul: Instability
			 113860, -- Dark Soul: Misery						
			 114050, -- Ascendance
			 114051, -- Ascendance
			 137639, -- Storm, Earth, and Fire			 
			 152173, -- Serenity
			 162264, -- Metamorphosis			 
			 185422, -- Shadow Dance			 
			 190319, -- Combustion			 
			 193526, -- Trueshot			
			 194249, -- Voidform
			 198144, -- Ice Form
			 212283, -- Symbols of Death
			 262228, -- Deadly Calm
			 266779, -- Coordinated Assault
		},
		MiscHelpfulBuffs = {
			   1044, -- Blessing of Freedom
			   1850, -- Dash			   
			   2983, -- Sprint
			  10060, -- Power Infusion
			  23920, -- Spell Reflection
			  31821, -- Aura Mastery
			  45182, -- Cheating Death
			  53271, -- Master's Call
			  68992, -- Darkflight
		},
		DamageShield = {
			    -17, -- Power Word: Shield
			   1463, -- Incanter's Flow
			 -11426, -- Ice Barrier
			  77535, -- Blood Shield
			 114908, -- Spirit Shell
			 108008, -- Indomitable
			 108366, -- Soul Leech
			 108416, -- Dark Pact
			 116849, -- Life Cocoon
			 145441, -- Yu'lon's Barrier
			 152118, -- Clarity of Will 
			 169373, -- Boulder Shield
			 173260, -- Shieldtronic Shield
			 184662, -- Shield of Vengeance
			 194022, -- Mental Fortitude (Shadow Priest Artifact)
			 227225, -- Soul Barrier
			 235313, -- Blazing Barrier
			 235450, -- Prismatic Barrier
			 269279, -- Resounding Protection (general azerite talent)
			 270657, -- Bulwark of the Masses (general azerite talent)
			 274289, -- Burning Soul (DH azerite talent)
			 274346, -- Soulmonger (DH azerite talent)
			 280212, -- Bury the Hatchet (warrior azerite talent, phys absorb only)
		},
		ImmuneToMagicCC = {
			    642, -- Divine Shield
			    710, -- Banish
			   8178, -- Grounding Totem Effect
			  23920, -- Spell Reflection
			  31224, -- Cloak of Shadows
			  33786, -- Cyclone
			  45438, -- Ice Block
			  46924, -- Bladestorm (fury)
			  48707, -- Anti-Magic Shell
			 186265, -- Aspect of the Turtle
		   	 204018, -- Blessing of Spellwarding
			 213915, -- Mass Spell Reflection
			 227847, -- Bladestorm (arms)
			-228049, -- Guardian of the Forgotten Queen (spellID might be wrong?)
		},
		BurstHaste = {
			   2825, -- Bloodlust
			  32182, -- Heroism,
			  80353, -- Time Warp
			  90355, -- Ancient Hysteria
			 146555, -- Drums of Rage
			 178207, -- Drums of Fury
			 160452, -- Netherwinds
			 230935, -- Drums of the Mountain
			 256740, -- Drums of the Maelstrom
			 264667, -- Primal Rage
		},
	},
	casts = {
		Heals = {
			    596, -- Prayer of Healing
			   2060, -- Heal
			   2061, -- Flash Heal
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
			    118, -- Polymorph
			    339, -- Entangling Roots
			   -605, -- Mind Control
			    982, -- Revive Pet
			   5782, -- Fear
			  12051, -- Evocation
			  20484, -- Rebirth
			  20066, -- Repentance
			  33786, -- Cyclone
			 -51514, -- Hex
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
