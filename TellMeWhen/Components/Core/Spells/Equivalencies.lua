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

]]
TMW.BE = {
	debuffs = {
		ReducedHealing = {
			   8679, -- Wound Poison                        (rogue, assassination)
			  27580, -- Sharpen Blade                       (warrior, arms)
			  30213, -- Legion Strike                       (warlock, demonology)
			 115625, -- Mortal Cleave                       (warlock, demonology)
			-115804, -- Mortal Wounds                       (arms/windwalker/hunter pet)
			 195452, -- Nightblade                          (rogue, subtlety)
			 257775, -- Plague Step                         (Freehold dungeon)
			 257908, -- Oiled Blade                         (Freehold dungeon)
			 258323, -- Infected Wound                      (Freehold dungeon)
			 262513, -- Azerite Heartseeker                 (Motherload dungeon)
			 269686, -- Plague                              (Temple of Sethraliss dungeon)
			 272588, -- Rotting Wounds                      (Siege of Boralus dungeon)
			 274555, -- Scabrous Bite                       (Freehold dungeon)
			 287672, -- Fatal Wounds                        (monk, windwalker)
		},
		CrowdControl = {
			   -118, -- Polymorph                           (mage, general)
			   -605, -- Mind Control                        (priest, PVE talent, general)
			   -710, -- Banish                              (warlock, general)
			  -2094, -- Blind                               (rogue, general)
			  -3355, -- Freezing Trap                       (hunter, general)
			  -5782, -- Fear                                (warlock, general)
			  -6358, -- Seduction                           (warlock pet, succubus)
			  -6770, -- Sap                                 (rogue, general)
			  -9484, -- Shackle Undead                      (priest, general)
			  20066, -- Repentance                          (paladin, general)
			  33786, -- Cyclone                             (druid, feral/resto/balance)
			 -51514, -- Hex                                 (shaman, general)
			 -82691, -- Ring of Frost                       (mage, general)
			 107079, -- Quaking Palm                        (pandaren racial)
			 115078, -- Paralysis                           (monk, general)
			 115268, -- Mesmerize                           (warlock pet, Grimiore of Supremacy version of Succubus)
			 198909, -- Song of Chi-ji                      (monk, mistweaver)
			 207685, -- Sigil of Misery                     (demon hunter, Vengeance)
		},
		Shatterable = {
			    122, -- Frost Nova                          (mage, frost)
			  -3355, -- Freezing Trap                       (hunter, general)
			  33395, -- Freeze                              (mage, frost)
			 -82691, -- Ring of Frost                       (mage, general)
			 157997, -- Ice Nova                            (mage, frost)
			 198121, -- Frostbite                           (mage, frost)
			 228358, -- Winter's Chill                      (mage, frost)
			 228600, -- Glacial Spike                       (mage, frost)
		},
		Bleeding = {
			   -703, -- Garrote                             (rogue, general)
			  -1079, -- Rip                                 (druid, feral)
			  -1822, -- Rake                                (druid, feral)
			   1943, -- Rupture                             (rogue, general)
			 -11977, -- Rend                                (warrior, arms)
			  16511, -- Hemorrhage                          (rogue, subtlety)
			  77758, -- Thrash                              (druid, bear)
			 106830, -- Thrash                              (druid, feral)
			-115767, -- Deep Wounds                         (arms/prot warr)
			 162487, -- Steel Trap                          (hunter talent)
			 185855, -- Lacerate                            (hunter, Survival)
			-202028, -- Brutal Slash                        (druid, feral)
			 273794, -- Rezan's Fury                        (general azerite trait)
		},
		Feared = {
			   5246, -- Intimidating Shout                  (warrior, general)
			  -5782, -- Fear                                (warlock, general)
			  -6789, -- Mortal Coil                         (warlock, PVE talent, general)
			  -8122, -- Psychic Scream                      (priest, disc/holy baseline, spriest PVE talent)
			  87204, -- Sin and Punishment                  (priest, shadow)
			 207685, -- Sigil of Misery                     (demon hunter, vengeance)
			 255041, -- Terrifying Screech                  (Atal'dazar dungeon)
			 255371, -- Terrifying Visage                   (Atal'dazar dungeon)
			 257169, -- Terrifying Roar                     (Siege of Boralus dungeon)
			 257791, -- Howling Fear                        (Tol Dagor dungeon)
			 269369, -- Deathly Roar                        (King's Rest dungeon)
			 272609, -- Maddening Gaze                      (Underrot dungeon)
			 276031, -- Pit of Despair                      (King's Rest dungeon)
		},
		Incapacitated = {
			     99, -- Incapacitating Roar                 (druid, bear)
			   -118, -- Polymorph                           (mage, general)
			   2637, -- Hibernate                           (druid, general)
			   1776, -- Gouge                               (rogue, outlaw)
			  -3355, -- Freezing Trap                       (hunter, general)
			  -6358, -- Seduction                           (warlock pet)
			  -6770, -- Sap                                 (rogue, general)
			  20066, -- Repentance                          (paladin, PVE talent, general)
			 -51514, -- Hex                                 (shaman, general)
			  82691, -- Ring of Frost                       (mage, PVE talent, general)
			 107079, -- Quaking Palm                        (pandaren racial)
			 115078, -- Paralysis                           (monk, general)
			 115268, -- Mesmerize                           (warlock pet, Grimiore of Supremacy version of Succubus)
			 197214, -- Sundering                           (shaman, enhancement)
			 200196, -- Holy Word: Chastise                 (priest, holy)
			 217832, -- Imprison                            (demon hunter)
			 221527, -- Imprison                            (demon hunter)
			 226943, -- Mind Bomb                           (priest, shadow)
			 252781, -- Unstable Hex                        (Atal'dazar dungeon)
			 263914, -- Blinding Sand                       (Temple of Sethraliss dungeon)
			 268008, -- Snake Charm                         (Temple of Sethraliss dungeon)
			 268797, -- Transmute: Enemy to Goo             (Motherload dungeon)
			 280032, -- Neurotoxin                          (Temple of Sethraliss dungeon)
		},
		Disoriented = {
			   -605, -- Mind Control                        (priest, PVE talent, general)
			  -2094, -- Blind                               (rogue, general)
			  31661, -- Dragon's Breath                     (mage, fire)
			 105421, -- Blinding light                      (paladin, PVE talent, general)
			 198909, -- Song of Chi-ji                      (monk, mistweaver)
			 202274, -- Incendiary brew                     (monk, brewmaster)
			 207167, -- Blinding Sleet                      (DK, Frost)
			 213691, -- Scatter Shot                        (hunter, marksman)
			 236748, -- Intimidating Roar                   (druid, bear)
			 257371, -- Tear Gas                            (Motherload dungeon)
			 258875, -- Blackout Barrel                     (Freehold dungeon)
			 258917, -- Righteous FLames                    (Tol Dagor dungeon)
			 270920, -- Seduction                           (King's Rest dungeon)
		},
		Silenced = {
			  -1330, -- Garrote - Silence                   (rogue, general)
			 -15487, -- Silence                             (priest, shadow)
			  31117, -- Unstable Affliction                 (warlock, affliction)
			  31935, -- Avenger's Shield                    (paladin, protection)
			 -47476, -- Strangulate                         (death knight, blood)
			 -78675, -- Solar Beam                          (druid, balance)
			 202933, -- Spider Sting                        (hunter, PVP talent, general)
			 204490, -- Sigil of Silence                    (demon hunter, vengeance)
			 217824; -- Shield of Virtue                    (paladin, protection)
			 258313, -- Handcuff                            (Tol Dagor dungeon)
			 268846, -- Echo Blade                          (Motherload dungeon)
		},
		Rooted = {
			   -339, -- Entangling Roots                    (druid, general)
			   -122, -- Frost Nova                          (mage, general)
			  33395, -- Freeze                              (mage, frost)
			  45334, -- Immobilized                         (wild charge, bear form)
			  53148, -- Charge                              (hunter pet)
			  96294, -- Chains of Ice                       (death knight)
			 -64695, -- Earthgrab                           (shaman, resto)
			  91807, -- Shambling Rush                      (DK, Unholy)
			 102359, -- Mass Entanglement                   (druid, PVE talent, general)
			 105771, -- Charge                              (warrior, baseline)
			 116706, -- Disable                             (monk, windwalker)
			 117526, -- Binding Shot                        (hunter, PVE talent, general)
			 157997, -- Ice Nova                            (mage, frost)
			 162480, -- Steel Trap                          (hunter, survival)
			 190927, -- Harpoon                             (hunter, survival)
			 198121, -- Frostbite                           (mage, frost)
			 199042, -- Thunderstruck                       (warrior, protection)
			 200108, -- Ranger's Net                        (hunter, survival)
			 204085, -- Deathchill                          (death knight, frost)
			 212638, -- Tracker's Net                       (hunter, survival)
			 228600, -- Glacial Spike                       (mage, frost)
			 233582, -- Entrenched in Flame                 (warlock, destro)
			 256897, -- Clamping Jaws                       (Siege of Boralus dungeon)
			 258058, -- Squeeze                             (Tol Dagor dungeon)
			 259711, -- Lockdown                            (Tol Dagor dungeon)
			 268050, -- Anchor of Binding                   (Shrine of the Storms dungeon)
			 274389, -- Rat Traps                           (Freehold dungeon)
			 285515, -- Surge of Power                      (shaman, elemental)
		},
		Slowed = {
			   -116, -- Frostbolt                           (mage, frost)
			  -1715, -- Hamstring                           (warrior, arms)
			   2120, -- Flamestrike                         (mage, fire)
			   
			   -- Crippling Poison intentionally not by name -
			   -- 3408 is the buff that goes on the rogue who has applied it to their weapons.
			   3409, -- Crippling Poison                    (rogue, assassination)
			  -3600, -- Earthbind                           (shaman, general)
			  -5116, -- Concussive Shot                     (hunter, beast mastery/marksman)
			  -6343, -- Thunder Clap                        (warrior, protection)
			  -7992, -- Slowing Poison                      (NPC ability)
			 -12323, -- Piercing Howl                       (warrior, fury)
			  12486, -- Blizzard                            (mage, frost)
			 -12544, -- Frost Armor                         (NPC ability only now?)
			 -15407, -- Mind Flay                           (priest, shadow)
			 -31589, -- Slow                                (mage, arcane)
			  35346, -- Warp Time                           (NPC ability)
			  44614, -- Flurry                              (mage, frost)
			  45524, -- Chains of Ice                       (death knight)
			  50259, -- Dazed                               (druid, PVE talent, general)
			  50433, -- Ankle Crack                         (hunter pet)
			  51490, -- Thunderstorm                        (shaman, elemental)
			  58180, -- Infected Wounds                     (druid, feral)
			  61391, -- Typhoon                             (druid, general)
			 116095, -- Disable                             (monk, windwalker)
			 118000, -- Dragon Roar                         (warrior, PVE talent, fury)
			 121253, -- Keg Smash                           (monk, brewmaster)
			 123586, -- Flying Serpent Kick                 (monk, windwalker)
			 127797, -- Ursol's Vortex                      (druid, restoration)
			 135299, -- Tar Trap                            (hunter, survival)
			 147732, -- Frostbrand Attack                   (shaman, enhancement)
			 157981, -- Blast Wave                          (mage, fire)
			 160065, -- Tendon Rip                          (hunter pet)
			 160067, -- Web Spray                           (pet ability)
			 183218, -- Hand of Hindrance                   (paladin, retribution)
			 185763, -- Pistol Shot                         (rogue, outlaw)
			 195645, -- Wing Clip                           (hunter, survival)
			-196840, -- Frost Shock                         (shaman, elemental)
			 198222, -- System Shock                        (rogue, assassination)
			 198813, -- Vengeful Retreat                    (demon hunter, havoc)
			 201787, -- Heavy-Handed Strikes                (monk, windwalker)
			 204263, -- Shining Force                       (priest, disc/holy)
			 204843, -- Sigil of Chains                     (demon hunter, veng)
			 205021, -- Ray of Frost                        (mage, frost)
			 205708, -- Chilled                             (mage, frost)
			 206930, -- Heart Strike                        (death knight, blood)
			 208278, -- Debilitating Infestation            (DK unholy talent)
			 211793, -- Remorseless Winter                  (death knight, frost)
			-212792, -- Cone of Cold                        (mage, frost)
			 213405, -- Master of the Glaive                (demon hunter, PVE talent, havoc)
			 228354, -- Flurry                              (mage, frost)
			 248744, -- Shiv                                (rogue, PVP talent, general)
			 255937, -- Wake of Ashes                       (paladin, PVE talent, retribution)
			 257478, -- Crippling Bite                      (Freehold dungeon)
			 257777, -- Crippling Shiv                      (Tol Dagor dungeon)
			 258313, -- Handcuff                            (Tol Dagor dungeon)
			 267899, -- Hindering Cleave                    (Shrine of the Storms dungeon)
			 268896, -- Mind Rend                           (Shrine of the Storms dungeon)
			 270499, -- Frost Shock                         (King's Rest dungeon)
			 271564, -- Embalming Fluid                     (King's Rest dungeon)
			 272834, -- Viscous Slobber                     (Siege of Boralus dungeon)
			 273977, -- Grip of the Dead                    (death knight, unholy)
			 277953, -- Night Terrors                       (rogue, subtlety)
			 279303, -- Frostwyrm's Fury                    (death knight, PVE talent, frost)
			 280184, -- Sweep the Leg                       (monk, azerite trait)
			 280583, -- Cauterized                          (engineering goggles azerite trait)
			 280604, -- Iced Spritzer                       (Motherload dungeon)
			 288962, -- Blood Bolt                          (hunter pet)
			 289308, -- Frozen Orb                          (mage, frost)
			 289526, -- Everchill                           (Everchill Anchor, from Battle of Dazar'alor raid)
			 290366, -- Commandant's Frigid Winds           (Daelin Proudmoore's Saber+Lord Admiral's Signet 2-set, from Battle of Dazar'alor raid)
		},
		Stunned = {
			    -25, -- Stun                                (generic NPC ability)
			   -408, -- Kidney Shot                         (rogue, subtlety/assassination)
			   -853, -- Hammer of Justice                   (paladin, general)
			  -1833, -- Cheap Shot                          (rogue, general)
			   5211, -- Mighty Bash                         (druid, PVE talent, general)
			  24394, -- Intimidation                        (hunter, beast mastery/surival)
			 -20549, -- War Stomp                           (tauren racial)
			  22703, -- Infernal Awakening                  (warlock, destro)
			 -30283, -- Shadowfury                          (warlock, general)
			 -89766, -- Axe Toss                            (warlock, demonology)
			  91797, -- Monstrous Blow                      (death knight, unholy)
			 -91800, -- Gnaw                                (death knight, unholy)
			 108194, -- Asphyxiate                          (death knight, frost/unholy)
			 118345, -- Pulverize                           (shaman, elemental)
			 118905, -- Static Charge                       (shaman, general)
			 119381, -- Leg Sweep                           (monk, general)
			-131402, -- Stunning Strike                     (generic NPC ability)
			 132168, -- Shockwave                           (warrior, protection)
			 132169, -- Storm Bolt                          (warrior, PVE talent, general)
			 163505, -- Rake                                (druid, general)
			 179057, -- Chaos Nova                          (demon hunter)
			 199804, -- Between the Eyes                    (rogue, outlaw)
			 199085, -- Warpath                             (warrior, protection)
			 200200, -- Holy Word: Chastise                 (priest, holy)
			 202244, -- Overrun                             (druid, bear)
			 202346, -- Double Barrel                       (monk, brewmaster)
			 203123, -- Maim                                (druid, feral)
			 204437, -- Lightning Lasso                     (shaman, elemental)
			 205629, -- Demonic Trample                     (demon hunter, vengeance)
			 205630, -- Illidan's Grasp                     (demon hunter, vengeance)
			 208618, -- Illidan's Grasp                     (demon hunter, vengeance)
			 211881, -- Fel Eruption                        (demon hunter, havoc)
			 221562, -- Asphyxiate                          (death knight, blood)
			 255723, -- Bull Rush                           (highmountain tauren racial)
			 256474, -- Heartstopper Venom                  (Tol Dagor dungeon)
			 257119, -- Sand Trap                           (Tol Dagor dungeon)
			 257292, -- Heavy Slash                         (Siege of Boralus dungeon)
			 257337, -- Shocking Claw                       (Motherload dungeon)
			 260067, -- Vicious Mauling                     (Tol Dagor dungeon)
			 263637, -- Clothesline                         (Motherload dungeon)
			 263891, -- Grasping Thorns                     (Waycrest Manor dungeon)
			 263958, -- A Knot of Snakes                    (Temple of Sethraliss dungeon)
			 268796, -- Impaling Spear                      (King's Rest dungeon)
			 269104, -- Explosive Void                      (Shrine of the Storms dungeon)
			 270003, -- Suppression Slam                    (King's Rest dungeon)
			 272713, -- Crushing Slam                       (Siege of Boralus dungeon)
			 272874, -- Trample                             (Siege of Boralus dungeon)
			 276268, -- Heaving Blow                        (Shrine of the Storms dungeon)
			 278961, -- Decaying Mind                       (Underrot dungeon)
			 280605, -- Brain Freeze                        (Motherload dungeon)
			 287254, -- Dead of Winter                      (death knight, frost)
		},
	},
	buffs = {
		SpeedBoosts = {
			    783, -- Travel Form                         (druid, baseline)
			  -2983, -- Sprint                              (rogue, baseline)
			  -2379, -- Speed                               (generic speed buff)
			   2645, -- Ghost Wolf                          (shaman, general)
			   7840, -- Swim Speed                          (Swim Speed Potion)
			  36554, -- Shadowstep                          (rogue, assassination/subtlety)
			  48265, -- Death's Advance                     (death knight, general)
			  54861, -- Nitro Boosts                        (engineering rocket boots)
			  58875, -- Spirit Walk                         (shaman, enhancement)
			 -65081, -- Body and Soul                       (priest, disc/shadow)
			  68992, -- Darkflight                          (worgen racial)
			 -61684, -- Dash                                (druid, general)
			 -77761, -- Stampeding Roar                     (druid, feral/bear)
			 108843, -- Blazing Speed (cauterize)           (mage, fire)
			 111400, -- Burning Rush                        (warlock, PVE talent, general)
			 116841, -- Tiger's Lust                        (monk, PVE talent, general)
			 118922, -- Posthaste                           (hunter, PVE talent, general)
			 119085, -- Chi Torpedo                         (monk, PVE talent, general)
			 199203, -- Thirst for Battle                   (warrior, fury)
			 121557, -- Angelic Feather                     (priest, holy/disc)
			-186257, -- Aspect of the Cheetah               (hunter, general)
			 188024, -- Skystep Potion                      (Legion potion)
			 192082, -- Wind Rush                           (shaman, PVE talent, genreal)
			 201447, -- Ride the Wind                       (monk, windwalker)
			 202164, -- Bounding Stride                     (arms/fury, PVE talent)
			 209754, -- Boarding Party                      (rogue, outlaw)
			 212552, -- Wraith Walk                         (death knight, frost/unholy)
			 213602, -- Greater Fade                        (priest, PVP talent, general)
			 236060, -- Frenetic Speed                      (mage, fire)
			 250878, -- Lightfoot Potion                    (BFA potion)
			 252216, -- Tiger Dash                          (druid, PVE talent, general)
			 262232, -- War Machine                         (warrior, fury)
			 273415, -- Gathering Storm                     (warrior, azerite trait, general)
			-276112, -- Divine Steed                        (paladin, general)
			 287827, -- Fight or Flight                     (azerite trait, general)
			 290244, -- Gilded Path                         (Boots of the Gilded Path, Battle of Dazar'alor raid)
		},
		ImmuneToStun = {
			    642, -- Divine Shield                       (paladin)
			    710, -- Banish                              (warlock)
			   1022, -- Blessing of Protection              (paladin)
			   6615, -- Free Action                         (vanilla potion)
			  33786, -- Cyclone                             (druid, feral/balance/resto)
			  45438, -- Ice Block                           (mage)
			  46924, -- Bladestorm                          (fury ID)
			  48792, -- Icebound Fortitude                  (death knight, general)
			 186265, -- Aspect of the Turtle                (hunter, general)
			 213610, -- Holy Ward                           (priest, holy)
			 221527, -- Imprison                            (demon hunter)
			 227847, -- Bladestorm                          (arms ID)
			-228049, -- Guardian of the Forgotten Queen     (paladin, protection)
			 287081, -- Lichborne                           (death knight, frost/unholy)
		},
		DefensiveBuffsAOE = {
			 -51052, -- Anti-Magic Zone                     (death knight, unholy)
			 -62618, -- Power Word: Barrier                 (priest, disc)
			  97463, -- Rallying Cry                        (warrior, arms/fury)
			 201633, -- Earthen Wall                        (shaman, resto)
			 204150, -- Aegis of light                      (paladin, protection)
			 204335, -- Aegis of light                      (paladin, protection)
			-209426, -- Darkness                            (demon hunter, havoc)
		},
		DefensiveBuffsSingle = {
			    498, -- Divine Protection                   (paladin, general)
			    642, -- Divine Shield                       (paladin, general)
			    871, -- Shield Wall                         (warrior, protection)
			   1022, -- Blessing of Protection              (paladin, general)
			  -1966, -- Feint                               (rogue, general)
			   5277, -- Evasion                             (rogue, assassination/subtlety)
			   6940, -- Blessing of Sacrifice               (paladin, holy)
			  22812, -- Barkskin                            (druid, general)
			  23920, -- Spell Reflection                    (warrior, PVP talent for arms/fury, baseline for protection)
			  31224, -- Cloak of Shadows                    (rogue, general)
			  31850, -- Ardent Defender                     (paladin, protection)
			  33206, -- Pain Suppression                    (priest, disc)
			  45182, -- Cheating Death                      (rogue, PVE talent, general)
			  45438, -- Ice Block                           (mage, general)
			  47585, -- Dispersion                          (priest, shadow)
			  47788, -- Guardian Spirit                     (priest, holy)
			  48707, -- Anti-Magic Shell                    (death knight, general)
			  48792, -- Icebound Fortitude                  (death knight, general)
			  53480, -- Roar of Sacrifice                   (hunter pet)
			  61336, -- Survival Instincts                  (druid, feral/bear)
			  86659, -- Guardian of Ancient Kings           (paladin, protection)
			 102342, -- Ironbark                            (druid, resto)
			 104773, -- Unending Resolve                    (warlock, general)
			 108271, -- Astral Shift                        (shaman, general)
			 113862, -- Greater Invisibility                (mage, arcane)
			 115176, -- Zen Meditation                      (monk, brewmaster)
			 115203, -- Fortifying Brew                     (monk, general)
			 116849, -- Life Cocoon                         (monk, mistweaver)
			 118038, -- Die by the Sword                    (warrior, arms)
			 122278, -- Dampen Harm                         (monk, PVE talent, general)
			 122783, -- Diffuse Magic                       (monk, PVE talent, general)
			 155835, -- Bristling Fur                       (druid, bear)
			 184364, -- Enraged Regeneration                (warrior, fury)
			 186265, -- Aspect of the Turtle                (hunter, general)
			-197268, -- Ray of Hope                         (priest, holy)
			 199754, -- Riposte                             (rogue, outlaw)
		   	 204018, -- Blessing of Spellwarding            (paladin, protection)
			 205191, -- Eye for an Eye                      (paladin, retribution)
			 210918, -- Ethereal Form                       (shaman, enhancement)
			 213602, -- Greater Fade                        (priest, PVP talent, general)
			 213915, -- Mass Spell Reflection               (warrior, protection)
			-228049, -- Guardian of the Forgotten Queen     (paladin, protection)
			 223658, -- Safeguard                           (warrior, protection)
			 287081, -- Lichborne                           (frost/unholy, PVP talent)
		},
		DamageBuffs = {
			   1719, -- Recklessness                        (warrior, arms)
			   5217, -- Tiger's Fury                        (druid, feral)
			  12042, -- Arcane Power                        (mage, arcane)
			  12472, -- Icy Veins                           (mage, frost)
			  13750, -- Adrenaline Rush                     (rogue, outlaw)
			  19574, -- Bestial Wrath                       (hunter, beast mastery)
			  31884, -- Avenging Wrath                      (paladin, retribution)
			  51271, -- Pillar of Frost                     (death knight, frost)
			 102543, -- Incarnation: King of the Jungle     (druid, feral)
			 102560, -- Incarnation: Chosen of Elune        (druid, balance)
			 106951, -- Berserk                             (druid, feral)
			-107574, -- Avatar                              (warrior, arms)
			 113858, -- Dark Soul: Instability              (warlock, destro)
			 113860, -- Dark Soul: Misery                   (warlock, affliction)
			 114050, -- Ascendance                          (shaman, elemental)
			 114051, -- Ascendance                          (shaman, enhancement)
			 137639, -- Storm, Earth, and Fire              (monk, windwalker)
			 152173, -- Serenity                            (monk, windwalker)
			 162264, -- Metamorphosis                       (demon hunter)
			 185422, -- Shadow Dance                        (rogue, subtlety)
			 190319, -- Combustion                          (mage, fire)
			 194223, -- Celestial Alignment                 (druid, balance)
			 194249, -- Voidform                            (priest, shadow)
			 198144, -- Ice Form                            (mage, frost)
			 199261, -- Death Wish                          (warrior, fury)
			 207289, -- Unholy Frenzy                       (death knight, unholy)
			 212155, -- Tricks of the Trade                 (rogue, Outlaw, PVP talent)
			 212283, -- Symbols of Death                    (rogue, subtlety)
			 216113, -- Way of the Crane                    (monk, mistweaver)
			 216331, -- Avenging Crusader                   (paladin, holy)
			 248622, -- In for the Kill                     (warrior, arms)
			 262228, -- Deadly Calm                         (warrior, arms)
			 266779, -- Coordinated Assault                 (hunter, survival)
			 288613, -- Trueshot                            (hunter, marksman)
		},
		DamageShield = {
			    -17, -- Power Word: Shield                  (priest, disc/shadow)
			 -11426, -- Ice Barrier                         (mage, frost)
			  48707, -- Anti-Magic Shell                    (death knight, general)
			  77535, -- Blood Shield                        (death knight, blood)
			 108008, -- Indomitable                         (old Dragon Soul PVE trinket)
			 108366, -- Soul Leech                          (warlock, general)
			 108416, -- Dark Pact                           (warlock, PVE talent, general)
			 116849, -- Life Cocoon                         (monk, mistweaver)
			 145441, -- Yu'lon's Barrier                    (old MOP legendary cape effect)
			 169373, -- Boulder Shield                      (WOD world item effect)
			 173260, -- Shieldtronic Shield                 (WOD engineering item)
			 184662, -- Shield of Vengeance                 (paladin, retribution)
			 190456, -- Ignore Pain                         (warrior, protection)
			 203538, -- Greater Blessing of Kings           (paladin, retribution)
			 205655, -- Dome of Mists                       (monk, mistweaver, PVP talent)
			 235313, -- Blazing Barrier                     (mage, fire)
			 235450, -- Prismatic Barrier                   (mage, arcane)
			 258153, -- Watery Dome                         (Tol Dagor dungeon)
			 265946, -- Ritual Wraps                        (trinket from King's Rest)
			 265991, -- Luster                              (Atal'dazar dungeon)
			 266201, -- Bone Shield                         (The Underrot dungeon)
			 269120, -- Miniaturized Plasma Shield          (Blacksmithing belt enchant)
			 269279, -- Resounding Protection               (general azerite trait)
			 270657, -- Bulwark of the Masses               (general azerite trait)
			 272979, -- Bulwark of Light                    (paladin, azerite trait)
			 273432, -- Bound by Shadow                     (King's Rest dungeon and Uldir)
			 274289, -- Burning Soul                        (demon hunter, havoc)
			 274346, -- Soulmonger                          (demon hunter, havoc)
			 274369, -- Sanctum                             (priest, azerite trait)
			-274814, -- Reawakening                         (druid, azerite trait)
			 271466, -- Luminous Barrier                    (priest, disc)
			 272987, -- Revel in Pain                       (demon hunter, vengeance)
			 274395, -- Stalwart Protector                  (paladin azerite trait)
			 278159, -- Xalzaix's Veil                      (Uldir tank trinket)
			 279187, -- Surging Tides                       (shaman, restoration, azerite trait)
			 280165, -- Ursoc's Endurance                   (druid, azerite trait)
			 280170, -- Duck and Cover                      (hunter, azerite trait)
			 280212, -- Bury the Hatchet                    (warrior, arms/fury)
			 280661, -- Personal Absorb-o-Tron              (engineering goggles azerite trait)
			 280788, -- Retaliatory Fury                    (general azerite trait)
			 280862, -- Last Gift                           (general azerite trait)
			 286342, -- Gladiator's Safeguard               (BFA PVP trinket)
			 287568, -- Enveloping Protection               (Ward of Envelopment, Battle of Dazar'alor raid)
			 287722, -- Death Denied                        (priest, azerite trait)
			 288024, -- Diamond Barrier                     (Diamond-Laced Refracting Prism, Battle of Dazar'alor raid)
			 295271, -- Umbral Shell                        (Void Stone, Crucible of Storms raid)
			 295431, -- Ephemeral Vigor                     (Abyssal Speaker's Gauntlets, Crucible of Storms raid)
		},
		ImmuneToMagicCC = {
			    642, -- Divine Shield                       (paladin, general)
			    710, -- Banish                              (warlock, general)
			   8178, -- Grounding Totem Effect              (shaman, PVP talent, general)
			  23920, -- Spell Reflection                    (warrior, PVP talent for arms/fury, baseline for protection)
			  31224, -- Cloak of Shadows                    (rogue, general)
			  33786, -- Cyclone                             (druid, feral/balance/resto)
			  45438, -- Ice Block                           (mage, general)
			  46924, -- Bladestorm                          (fury ID)
			  48707, -- Anti-Magic Shell                    (death knight, general)
			 186265, -- Aspect of the Turtle                (hunter, general)
		   	 204018, -- Blessing of Spellwarding            (paladin, protection)
			 212295, -- Nether Ward                         (warlock, PVP talent, general)
			 213610, -- Holy Ward                           (priest, holy)
			 213915, -- Mass Spell Reflection               (warrior, protection)
			 221527, -- Imprison                            (demon hunter)
			 227847, -- Bladestorm                          (arms ID)
			-228049, -- Guardian of the Forgotten Queen     (paladin, protection)
		},
		BurstHaste = {
			   2825, -- Bloodlust                           (shaman, horde)
			  32182, -- Heroism                             (shaman, alliance)
			  80353, -- Time Warp                           (mage, general)
			  90355, -- Ancient Hysteria                    (hunter pet)
			 146555, -- Drums of Rage                       (leatherworking item)
			 178207, -- Drums of Fury                       (leatherworking item)
			 160452, -- Netherwinds                         (hunter pet)
			 204361, -- Bloodlust                           (shaman, PVP talent, horde)
			 204362, -- Heroism                             (shaman, PVP talent, horde)
			 230935, -- Drums of the Mountain               (leatherworking item)
			 256740, -- Drums of the Maelstrom              (leatherworking item)
			 264667, -- Primal Rage                         (hunter pet)
		},
		ImmuneToInterrupts = {
			    642, -- Divine Shield                       (paladin, general)
			 186265, -- Aspect of the Turtle                (hunter)
			 209584, -- Zen Focus Tea                       (monk, mistweaver)
			 210294, -- Divine Favor                        (paladin, holy)
			 221705, -- Casting Circle                      (warlock, PVP talent, generaL)
			-228049, -- Guardian of the Forgotten Queen     (paladin, protection)
			-289657, -- Holy Word: Concentration            (priest, holy)
			 290641, -- Ancestral Gift                      (shaman, resto)
		},
		ImmuneToSlows = {
			    642, -- Divine Shield                       (paladin, general)
			   1044, -- Blessing of Freedom                 (paladin, general)
			  46924, -- Bladestorm                          (fury ID)
			  48265, -- Death's Advance                     (death knight, general)
			  54216, -- Master's Call                       (hunter, pet ability)
			 108843, -- Blazing Speed (cauterize)           (mage, fire)
			 186265, -- Aspect of the Turtle                (hunter)
			 197003, -- Maneuverability                     (rogue, PVP talent, general)
			 201447, -- Ride the Wind                       (monk, windwalker)
			 212552, -- Wraith Walk                         (death knight, frost/unholy)
			 216113, -- Way of the Crane                    (monk, mistweaver)
			 227847, -- Bladestorm                          (arms ID)
			 287081, -- Lichborne                           (death knight, frost/unholy)
		},
	},
	casts = {
		Heals = {
			    596, -- Prayer of Healing
			   2060, -- Heal
			   2061, -- Flash Heal
			  32546, -- Binding Heal                        (priest, holy)
			  33076, -- Prayer of Mending
			  64843, -- Divine Hymn
			 120517, -- Halo                                (priest, holy/disc)
			 186263, -- Shadow Mend
			 194509, -- Power Word: Radiance
			 265202, -- Holy Word: Salvation                (priest, holy)
			 289666, -- Greater Heal                        (priest, holy)

			    740, -- Tranquility
			   8936, -- Regrowth
			  48438, -- Wild Growth
			 289022, -- Nourish                             (druid, restoration)

			   1064, -- Chain Heal
			   8004, -- Healing Surge
			  73920, -- Healing Rain
			  77472, -- Healing Wave
			 197995, -- Wellspring                          (shaman, restoration)
			 207778, -- Downpour                            (shaman, restoration)

			  19750, -- Flash of Light
			  82326, -- Holy Light

			 116670, -- Vivify
			 124682, -- Enveloping Mist
			 191837, -- Essence Font
			-209525, -- Soothing Mist
			 227344, -- Surging Mist                        (monk, mistweaver)

		},
	},
}

TMW:RegisterUpgrade(85702, {
	icon = function(self, ics)
		-- Some equivalencies being retired.
		ics.Name = ics.Name:gsub("PvPSpells", "118;605;982;5782;20066;33786;51514")
		ics.Name = ics.Name:gsub("MiscHelpfulBuffs", "1044;1850;2983;10060;23920;31821;45182;53271;68992;197003;213915")
	end,
})

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
