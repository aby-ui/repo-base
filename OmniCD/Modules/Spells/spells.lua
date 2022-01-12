local E, L, C = select(2, ...):unpack()

if E.isPreBCC then return end

E.spell_db = { -- [106]
	["DEATHKNIGHT"] = { -- 250(Blood), 251(Frost), 252(Unholy)
		{ spellID = 315443, duration = 120, type = "covenant",  spec = 321078   },  -- Abomination Limb
		{ spellID = 324128, duration = {[250]=15,default=30},   type = "covenant",  spec = 321077,  parent = 43265, talent = 152280 },  -- Death Due (replace D&D)
		{ spellID = 312202, duration = 60,  type = "covenant",  spec = 321076   },  -- Shackle the Unworthy
		{ spellID = 311648, duration = 60,  type = "covenant",  spec = 321079   },  -- Swarming Mist
		{ spellID = 47482,  duration = 30,  type = "interrupt", spec = {252}    },  -- Leap & Shambling Rush (91807)
		{ spellID = 47528,  duration = 15,  type = "interrupt"  },  -- Mind Freeze
		{ spellID = 108194, duration = 45,  type = "cc",        spec = true     },  -- Asphyxiate
		{ spellID = 221562, duration = 45,  type = "cc",        spec = {250}    },  -- Asphyxiate (B)
		{ spellID = 207167, duration = 60,  type = "cc",        spec = true     },  -- Blinding Sleet
		{ spellID = 287250, duration = 45,  type = "cc",        spec = true,    parent = 196770 }, -- Dead of Winter (talent ID) - [2]
		{ spellID = 47481,  duration = 90,  type = "cc",        spec = {252}    },  -- Gnaw (91800) & Monstrous Blow (91797)
		{ spellID = 49576,  duration = {[250]=15,default=25},   type = "disarm" },  -- Death Grip
		{ spellID = 108199, duration = 120, type = "disarm",    spec = {250}    },  -- Gorefiend's Grasp
		{ spellID = 47476,  duration = 60,  type = "disarm",    spec = true     },  -- Strangulate
		{ spellID = 48707,  duration = 60,  type = "defensive"  },  -- Anti-Magic Shell
		{ spellID = 206931, duration = 30,  type = "defensive", spec = true     },  -- Blooddrinker
		{ spellID = 221699, duration = 60,  type = "defensive", spec = true,    charges = 2 },  -- Blood Tap
		{ spellID = 194844, duration = 60,  type = "defensive", spec = true     },  -- Bonestorm
		{ spellID = 274156, duration = 30,  type = "defensive", spec = true     },  -- Consumption
		{ spellID = 49028,  duration = 120, type = "defensive", spec = {250}    },  -- Dancing Rune Weapon
		{ spellID = 48743,  duration = 120, type = "defensive", spec = true     },  -- Death Pact
		{ spellID = 48792,  duration = 180, type = "defensive"  },  -- Icebound Fortitude
		{ spellID = 114556, duration = 240, type = "defensive", spec = true     },  -- Purgatory (dummy spell)
		{ spellID = 194679, duration = 25,  type = "defensive", spec = {250},   charges = 2 },    -- Rune Tap
		{ spellID = 327574, duration = 120, type = "defensive"  },  -- Sacrificial Pact
		{ spellID = 219809, duration = 60,  type = "defensive", spec = true     },  -- Tombstone
--      { spellID = 288977, duration = 45,  type = "defensive", spec = true     },  -- Transfusion    -- Patch 9.1 removed
		{ spellID = 55233,  duration = 90,  type = "defensive", spec = {250}    },  -- Vampiric Blood
		{ spellID = 51052,  duration = 120, type = "raidDefensive"  },  -- Anti-Magic Zone  -- Patch 9.1 cd 180>120
		{ spellID = 275699, duration = 75,  type = "offensive", spec = {252}    },  -- Apocalypse (Rank2 -15s)
		{ spellID = 42650,  duration = 480, type = "offensive", spec = {252},   talent = 288853 },  -- Army of the Dead
		{ spellID = 288853, duration = 90,  type = "offensive", spec = true,    parent = 42650  },  -- Raise Abomination
		{ spellID = 152279, duration = 120, type = "offensive", spec = true     },  -- Breath of Sindragosa
		{ spellID = 305392, duration = 45,  type = "offensive", spec = true     },  -- Chill Streak
		{ spellID = 63560,  duration = 60,  type = "offensive", spec = {252}    },  -- Dark Transformation
		{ spellID = 43265,  duration = {[250]=15,default=30},   type = "offensive", talent = {152280,321077}    },  -- Death and Decay (Death Due's spec, not spellID)
		{ spellID = 152280, duration = 20,  type = "offensive", spec = true,    parent = 43265 },  -- Defile
		{ spellID = 203173, duration = 30,  type = "offensive", spec = true     },  -- Death Chain
		{ spellID = 47568,  duration = 105, type = "offensive", spec = {251}    },  -- Empower Rune Weapon (Rank2 -15s)
		{ spellID = 279302, duration = 180, type = "offensive", spec = {251}    },  -- Frostwyrm's Fury
		{ spellID = 57330,  duration = 45,  type = "offensive", spec = true     },  -- Horn of Winter
		{ spellID = 321995, duration = 45,  type = "offensive", spec = true     },  -- Hypothermic Presence
		{ spellID = 207018, duration = 20,  type = "offensive", spec = true,    parent = 56222 },  -- Murderous Intent
		{ spellID = 51271,  duration = 60,  type = "offensive", spec = {251}    },  -- Pillar of Frost
		{ spellID = 46584,  duration = 30,  type = "offensive", spec = {252}    },  -- Raise Dead (U)
		{ spellID = 46585,  duration = 120, type = "offensive", spec = {250,251}},  -- Raise Dead
		{ spellID = 49206,  duration = 180, type = "offensive", spec = true     },  -- Summon Gargolye
		{ spellID = 207289, duration = 75,  type = "offensive", spec = true     },  -- Unholy Assault
		{ spellID = 115989, duration = 45,  type = "offensive", spec = true     },  -- Unholy Blight
		{ spellID = 56222,  duration = 8,   type = "other",     talent = 207018 },  -- Dark Command
		{ spellID = 77606,  duration = 20,  type = "other",     spec = true     },  -- Dark Simulacrum
		{ spellID = 48265,  duration = 45,  type = "other"      },  -- Death's Advance
		{ spellID = 49039,  duration = 120, type = "other"      },  -- Lichborne
		{ spellID = 196770, duration = 20,  type = "other",     spec = {251},   talent = 287250 },  -- Remorseless Winter
		{ spellID = 212552, duration = 60,  type = "other",     spec = true     },  -- Wraith Walk
	},
	["DEMONHUNTER"] = { -- 577(Havoc), 581(Vengeance)
		{ spellID = 306830, duration = 60,  type = "covenant",  spec = 321076   },  -- Elysian Decree
		{ spellID = 329554, duration = 120, type = "covenant",  spec = 321078   },  -- Fodder to the Flame
		{ spellID = 317009, duration = 45,  type = "covenant",  spec = 321079   },  -- Sinful Brand -- Patch 9.1.5 cd 60>45
		{ spellID = 323639, duration = 90,  type = "covenant",  spec = 321077   },  -- The Hunt
		{ spellID = 183752, duration = 15,  type = "interrupt"  },  -- Disrupt
		{ spellID = 278326, duration = 10,  type = "dispel"     },  -- Consume Magic
		{ spellID = 179057, duration = 60,  type = "cc",        spec = {577}    },  -- Chaos Nova
		{ spellID = 211881, duration = 30,  type = "cc",        spec = true     },  -- Fel Eruption
		{ spellID = 205630, duration = 60,  type = "cc",        spec = true     },  -- Illidan's Grasp
		{ spellID = 217832, duration = 45,  type = "cc"         },  -- Imprison
		{ spellID = 207684, duration = 90,  type = "cc",        spec = {581}    },  -- Sigil of Misery (Rank2 -90s)
		{ spellID = 202138, duration = 90,  type = "disarm",    spec = true     },  -- Sigil of Chains
		{ spellID = 202137, duration = 60,  type = "disarm",    spec = {581}    },  -- Sigil of Silence (Rank2 -60s)
		{ spellID = 196555, duration = 180, type = "immunity",  spec = true     },  -- Netherwalk
		{ spellID = 198589, duration = 60,  type = "defensive", spec = {577}    },  -- Blur
		{ spellID = 320341, duration = 90,  type = "defensive", spec = true     },  -- Bulk Extraction
		{ spellID = 203720, duration = 20,  type = "defensive", spec = {581},   charges = 2 },  -- Demon Spikes
		{ spellID = 204021, duration = 60,  type = "defensive", spec = {581}    },  -- Fiery Brand
		{ spellID = 209258, duration = 480, type = "defensive", spec = true     },  -- Last Resort (dummy spell)
		{ spellID = 206803, duration = 60,  type = "defensive", spec = true     },  -- Rain from Above
		{ spellID = 263648, duration = 30,  type = "defensive", spec = true     },  -- Soul Barrier
		{ spellID = 196718, duration = 180, type = "raidDefensive", spec = {577}},  -- Darkness (Rank2 - 120s)
		{ spellID = 258860, duration = 20,  type = "offensive", spec = true     },  -- Essence Break
		{ spellID = 198013, duration = 30,  type = "offensive", spec = {577}    },  -- Eye Beam
--      { spellID = 206649, duration = 45,  type = "offensive", spec = true     },  -- Eye of Leotheras -- Patch 9.1 removed
		{ spellID = 258925, duration = 60,  type = "offensive", spec = true     },  -- Fel Barrage
		{ spellID = 212084, duration = 60,  type = "offensive", spec = {581}    },  -- Fel Devastation
		{ spellID = 342817, duration = 20,  type = "offensive", spec = true     },  -- Glaive Tempest
		{ spellID = 258920, duration = {[581]=15, default=30},  type = "offensive"  },  -- Immolation Aura (Vengeance Rank3 -15s)
--      { spellID = 203704, duration = 60,  type = "offensive", spec = true     },  -- Mana Break -- Patch 9.1 removed
		{ spellID = 200166, duration = 240, type = "offensive", spec = {577}    },  -- Metamorphosis (Rank3 -60s) (hidden ID) buffID = 162264 @buffFix
		{ spellID = 187827, duration = 180, type = "defensive", spec = {581}    },  -- Metamorphosis (V) (Rank2,3 -60s,-60s) buffID = spellID
		{ spellID = 206491, duration = 120, type = "offensive", spec = true     },  -- Nemesis
		{ spellID = 204596, duration = 30,  type = "offensive", spec = {581}    },  -- Sigil of Flame
		{ spellID = 207029, duration = 20,  type = "offensive", spec = true,    parent = 185245 },  -- Tormentor
		{ spellID = 205604, duration = 60,  type = "counterCC", spec = true     },  -- Reverse Magic
		{ spellID = 205629, duration = 20,  type = "other",     spec = true,    charges = 2 }, -- Demonic Trample
		{ spellID = 232893, duration = 15,  type = "other",     spec = true     },  -- Felblade
		{ spellID = 195072, duration = 10,  type = "other",     spec = {577},   charges = 2 },  -- Fel Rush
		{ spellID = 189110, duration = 20,  type = "other",     spec = {581},   charges = 2 },  -- Infernal Strike
		{ spellID = 188501, duration = 30,  type = "other"      },  -- Spectral Sight (Rank2 -30s)
		{ spellID = 185123, duration = 9,   type = "other",     spec = {577}    },  -- Throw Glaive
		{ spellID = 204157, duration = 3,   type = "other",     spec = {581}    },  -- Throw Glaive (V)
		{ spellID = 185245, duration = 8,   type = "other",     talent = 207029 },  -- Torment
		{ spellID = 198793, duration = 25,  type = "other",     spec = {577}    },  -- Vengeful Retreat
	},
	["DRUID"] = { -- 102(Bal), 103(Feral), 104(Guardian), 105(Resto)
		{ spellID = 325727, duration = 25,  type = "covenant",  spec = 321078   },  -- Adaptive Swarm
		{ spellID = 323764, duration = 120, type = "covenant",  spec = 321077   },  -- Convoke the Spirits
--      { spellID = 326434, duration = 0,   type = "covenant",  spec = 321076   },  -- Kindred Spirits (arming)
		{ spellID = 338142, duration = 60,  type = "covenant",  spec = 321076   },  -- Lone Empowerment (Bal, Feral)
		-- Merged
		--[[
--      { spellID = 338035, duration = 60,  type = "covenant",  spec = 321076   },  -- Lone Meditation (Resto)
--      { spellID = 338018, duration = 60,  type = "covenant",  spec = 321076   },  -- Lone Protection (guardian)
--      { spellID = 326462, duration = 60,  type = "covenant",  spec = 321076   },  -- Empower Bond (Tank partner)
--      { spellID = 326446, duration = 60,  type = "covenant",  spec = 321076   },  -- Empower Bond (Damager partner)
--      { spellID = 326647, duration = 60,  type = "covenant",  spec = 321076   },  -- Empower Bond (Healer partner)
		-- These are Kindred Spirits' Buffs - can't use since they're CLEU _AURA_APPLIED only
--      { spellID = 327022, duration = 60,  type = "covenant",  spec = 321076   },  -- Kindred Empowerment (Bal, Feral)
--      { spellID = 327037, duration = 60,  type = "covenant",  spec = 321076   },  -- Kindred Protection (Guardian)
--      { spellID = 327071, duration = 60,  type = "covenant",  spec = 321076   },  -- Kindred Focus (Resto)
		--]]
		{ spellID = 323546, duration = 180, type = "covenant",  spec = 321079   },  -- Ravenous Frenzy (1sec self stun debuff id 323557)
		--[[
--          B       F       G       R Affinity
--      B -         202157  197491  197492
--      F - 197488          217615  197492
--      G - 197488  202155          197492
--      R - 197632  197490  197491
		--]]
		{ spellID = 106839, duration = 15,  type = "interrupt", spec = {103,104}},  -- Skull Bash
		{ spellID = 78675,  duration = 60,  type = "interrupt", spec = {102}    },  -- Solar Beam
		{ spellID = 88423,  duration = 8,   type = "dispel",    spec = {105}    },  -- Nature's Cure
		{ spellID = 2782,   duration = 8,   type = "dispel",    spec = {102,103,104}    },  -- Remove Corruption
		{ spellID = 99,     duration = 30,  type = "cc",        spec = {104,197491,217615}  },  -- Incapacitating Roar
		{ spellID = 22570,  duration = 20,  type = "cc",        spec = {103,202157,202155,197490}   },  -- Maim
		{ spellID = 5211,   duration = 60,  type = "cc",        spec = true     },  -- Mighty Bash
		{ spellID = 202246, duration = 25,  type = "cc",        spec = true     },  -- Overrun
		{ spellID = 209749, duration = 30,  type = "disarm",    spec = true     },  -- Faerie Swarm
		{ spellID = 102359, duration = 30,  type = "disarm",    spec = true     },  -- Mass Entanglement
		{ spellID = 132469, duration = 30,  type = "disarm",    spec = {102,197488,197632}  },  -- Typhoon
		{ spellID = 102793, duration = 60,  type = "disarm",    spec = {105,197492} },  -- Ursol's Vortex
		{ spellID = 102342, duration = 90,  type = "externalDefensive", spec = {105}    },  -- Ironbark
		{ spellID = 22812,  duration = 60,  type = "defensive"  },  -- Barkskin
		{ spellID = 155835, duration = 40,  type = "defensive", spec = true     },  -- Bristling Fur
		{ spellID = 201664, duration = 30,  type = "defensive", spec = true     },  -- Demoralizing Roar
		{ spellID = 22842,  duration = 36,  type = "defensive", spec = {104,197491,217615}, charges={[104]=2,default=1} },  -- Frenzied Regeneration
		{ spellID = 354654, duration = 60,  type = "defensive", spec = true     },  -- Grove Protection -- Patch 9.1 new
		{ spellID = 80313,  duration = 45,  type = "defensive", spec = true     },  -- Pulverize
		{ spellID = 108238, duration = 90,  type = "defensive", spec = true     },  -- Renewal
		{ spellID = 61336,  duration = 180, type = "defensive", spec = {103,104},   charges={[104]=2,default=1} },  -- Survival Instincts
		{ spellID = 305497, duration = 45,  type = "defensive", spec = true     },  -- Thorns
		{ spellID = 740,    duration = 180, type = "raidDefensive", spec = {105}},  -- Tranquility
		{ spellID = 207017, duration = 20,  type = "offensive", spec = true,    parent = 6795   },  -- Alpha Challenge
		{ spellID = 106951, duration = 180, type = "offensive", spec = {103},   talent = 102543 },  -- Berserk (F)
		{ spellID = 50334,  duration = 180, type = "offensive", spec = {104},   talent = 102558 },  -- Berserk (G)
		{ spellID = 194223, duration = 180, type = "offensive", spec = {102},   talent = 102560 },  -- Celestial Alignment
		{ spellID = 102351, duration = 30,  type = "offensive", spec = true     },  -- Cenarion Ward
		{ spellID = 274837, duration = 45,  type = "offensive", spec = true     },  -- Feral Frenzy
		{ spellID = 197721, duration = 90,  type = "offensive", spec = true     },  -- Flourish
		{ spellID = 202770, duration = 60,  type = "offensive", spec = true     },  -- Fury of Elune
		{ spellID = 319454, duration = 300, type = "offensive", spec = true     },  -- Heart of the Wild
		--[[ Merged
--      { spellID = 108291, duration = 300, type = "offensive", spec = {197488,197632}  },  -- Heart of the Wild (Balance Affinity)
--      { spellID = 108292, duration = 300, type = "offensive", spec = {202157,202155,197490}   },  -- Heart of the Wild (Feral Affinity)
--      { spellID = 108293, duration = 300, type = "offensive", spec = {197491,217615}  },  -- Heart of the Wild (Guardian Affinity)
--      { spellID = 108294, duration = 300, type = "offensive", spec = 197492   },  -- Heart of the Wild (Restoration Affinity)
		--]]
		{ spellID = 102560, duration = 180, type = "offensive", spec = true,    parent = 194223 },  -- Incarnation: Chosen of Elune
		{ spellID = 102558, duration = 180, type = "offensive", spec = true,    parent = 50334  },  -- Incarnation: Guardian of Ursoc
		{ spellID = 102543, duration = 180, type = "offensive", spec = true,    parent = 106951 },  -- Incarnation: King of the Jungle
		{ spellID = 33891,  duration = 180, type = "offensive", spec = true     },  -- Incarnation: Tree of Life
		{ spellID = 132158, duration = 60,  type = "offensive", spec = {105}    },  -- Nature's Swiftness
		{ spellID = 274281, duration = 20,  type = "offensive", spec = true,    charges = 3 },  -- New Moon -- Patch 9.1 cd 25>20
		{ spellID = 203651, duration = 60,  type = "offensive", spec = true     },  -- Overgrowth
--      { spellID = 203242, duration = 60,  type = "offensive", spec = true     },  -- Rip and Tear -- Patch 9.1 name changed to Wiched Claws(passive)
		{ spellID = 18562,  duration = 15,  type = "offensive", spec = {105}    },  -- Swiftmend
		{ spellID = 5217,   duration = 30,  type = "offensive", spec = {103}    },  -- Tiger's Fury
		{ spellID = 202425, duration = 45,  type = "offensive", spec = true     },  -- Warrior of Elune
		{ spellID = 77761,  duration = {[104]=60,default=120},  type = "raidMovement"  },  -- Stampeding Roar (merged into catform ID)
		{ spellID = 1850,   duration = 120, type = "other",     talent = 252216 },  -- Dash
		{ spellID = 329042, duration = 120, type = "other",     spec = true     },  -- Emerald Slumber  -- Patch 9.1 new
		{ spellID = 252216, duration = 45,  type = "other",     spec = true,    parent = 1850   },  -- Tiger's Dash
		{ spellID = 205636, duration = 60,  type = "other",     spec = true     },  -- Force of Nature
		{ spellID = 6795,   duration = 8,   type = "other",     talent = 207017 },  -- Growl
		{ spellID = 29166,  duration = 180, type = "other",     spec = {102,105}},  -- Innervate
		{ spellID = 5215,   duration = 6,   type = "other"      },  -- Prowl
		{ spellID = 2908,   duration = 10,  type = "other"      },  -- Soothe
		{ spellID = 102401, duration = 15,  type = "other",     spec = true     },  -- Wild Charge
	},
	["HUNTER"] = { -- 253(BM), 254(MM), 255(SV)
		{ spellID = 325028, duration = 45,  type = "covenant",  spec = 321078   },  -- Death Chakram
		{ spellID = 324149, duration = 30,  type = "covenant",  spec = 321079   },  -- Flayed Shot
		{ spellID = 308491, duration = 60,  type = "covenant",  spec = 321076   },  -- Resonating Arrow
		{ spellID = 328231, duration = 120, type = "covenant",  spec = 321077   },  -- Wild Spirits
		{ spellID = 147362, duration = 24,  type = "interrupt", spec = {253,254}},  -- Countershot
		{ spellID = 187707, duration = 15,  type = "interrupt", spec = {255}    },  -- Muzzle
		{ spellID = 19801,  duration = 10,  type = "dispel"     },  -- Tranquilizing Shot
		{ spellID = 187650, duration = 25,  type = "cc"         },  -- Freezing Trap (Rank2 -5s)
		{ spellID = 19577,  duration = 60,  type = "cc",        spec = {253,255}},  -- Intimidation
		{ spellID = 213691, duration = 30,  type = "cc",        spec = true     },  -- Scatter Shot
		{ spellID = 186387, duration = 30,  type = "disarm",    spec = {254}    },  -- Bursting Shot
		{ spellID = 236776, duration = 40,  type = "disarm",    spec = true     },  -- Hi-Explosive Trap
--      { spellID = 202914, duration = 45,  type = "disarm",    spec = true     },  -- Spider Sting -- Patch 9.1 removed
		{ spellID = 212638, duration = 25,  type = "disarm",    spec = true     },  -- Tracker's Net
		{ spellID = 162488, duration = 30,  type = "disarm",    spec = true     },  -- Steel Trap
		-- not an actual talent. Bow's itemID is added to talentData from inspect/sync to use as a psuedo-talentID
		{ spellID = 355589, duration = 60,  type = "disarm",    spec = 186414   },  -- Wailing Arrow    -- Patch 9.1 new ('Rae'shalare, Death's Whisper' legendary bow ability)
		{ spellID = 186265, duration = 180, type = "immunity"   },  -- Aspect of the Turtle
		{ spellID = 53480,  duration = 60,  type = "externalDefensive", spec = true },  -- Roar of Sacrifice
		{ spellID = 109304, duration = 120, type = "defensive"  },  -- Exhilaration
		{ spellID = 248518, duration = 45,  type = "defensive", spec = true,    parent = 34477  },  -- Interlope
		{ spellID = 212640, duration = 25,  type = "defensive", spec = true     },  -- Mending Bandage
--      { spellID = 202900, duration = 24,  type = "defensive", spec = true     },  -- Scorpid Sting    -- Patch 9.1 removed
		{ spellID = 131894, duration = 60,  type = "offensive", spec = true     },  -- A Murder of Crows
		{ spellID = 186289, duration = 90,  type = "offensive", spec = {255}    },  -- Aspect of the Eagle
		{ spellID = 193530, duration = 120, type = "offensive", spec = {253}    },  -- Aspect of the Wild
		{ spellID = 120360, duration = 20,  type = "offensive", spec = true     },  -- Barrage
		{ spellID = 217200, duration = 12,  type = "offensive", spec = {253},   charges = 2 },  -- Barbed Shot
		{ spellID = 19574,  duration = 90,  type = "offensive", spec = {253}    },  -- Bestial Wrath
		{ spellID = 321530, duration = 60,  type = "offensive", spec = true     },  -- Bloodshed
		{ spellID = 259391, duration = 20,  type = "offensive", spec = true     },  -- Chakrams
		{ spellID = 356719, duration = 60,  type = "offensive"  },  -- Chimaeral Sting  -- Patch 9.1 new
		{ spellID = 266779, duration = 120, type = "offensive", spec = {255}    },  -- Coordinated Assault
		{ spellID = 120679, duration = 20,  type = "offensive", spec = true     },  -- Dire Beast
		{ spellID = 205691, duration = 120, type = "offensive", spec = true     },  -- Dire Beast: Basilisk
		{ spellID = 208652, duration = 30,  type = "offensive", spec = true     },  -- Dire Beast: Hawk
		{ spellID = 260402, duration = 60,  type = "offensive", spec = true     },  -- Double Tap
		{ spellID = 212431, duration = 30,  type = "offensive", spec = true     },  -- Explosive Shot
		{ spellID = 269751, duration = 30,  type = "offensive", spec = true     },  -- Flanking Strike
		{ spellID = 34026,  duration = 8,   type = "offensive", spec = {253}    },  -- Kill Command
		{ spellID = 259489, duration = 6,   type = "offensive", spec = {255}    },  -- Kill Command (SV)
		{ spellID = 257044, duration = 20,  type = "offensive", spec = {254}    },  -- Rapid Fire
		{ spellID = 194407, duration = 90,  type = "offensive", spec = true     },  -- Spitting Cobra
		{ spellID = 201430, duration = 120, type = "offensive", spec = true     },  -- Stampede
		{ spellID = 288613, duration = 120, type = "offensive", spec = {254}    },  -- Trueshot
--      { spellID = 202797, duration = 30,  type = "offensive", spec = true     },  -- Viper Sting  -- Patch 9.1 removed
		{ spellID = 260243, duration = 45,  type = "offensive", spec = true     },  -- Volley
		{ spellID = 356707, duration = 60,  type = "offensive", spec = true     },  -- Wild Kingdom -- Patch 9.1 new
		{ spellID = 259495, duration = 18,  type = "offensive", spec = {255}    },  -- Wildfire Bomb
		{ spellID = 186257, duration = 180, type = "other"      },  -- Aspect of the Cheetah
		{ spellID = 109248, duration = 45,  type = "other",     spec = {254,109248} },  -- Binding Shot
		{ spellID = 199483, duration = 60,  type = "other",     spec = true     },  -- Camouflage
		{ spellID = 272651, duration = 45,  type = "other"      },  -- Command Pet
		{ spellID = 781,    duration = 20,  type = "other"      },  -- Disengage
		{ spellID = 5384,   duration = 30,  type = "other"      },  -- Feign Death
		{ spellID = 1543,   duration = 20,  type = "other"      },  -- Flare
		{ spellID = 190925, duration = 20,  type = "other",     spec = {255}    },  -- Harpoon
		{ spellID = 34477,  duration = 30,  type = "other",     talent = 248518 },  -- Misdirection
		{ spellID = 187698, duration = 25,  type = "other"      },  -- Tar Trap (Rank2 -5s)
	},
	["MAGE"] = { -- 62(Arcane), 63(Fire), 64(Frost)
		{ spellID = 324220, duration = 180, type = "covenant",  spec = 321078   },  -- Deathborne
		{ spellID = 314793, duration = 90,  type = "covenant",  spec = 321079   },  -- Mirrors of Torment
		{ spellID = 307443, duration = 30,  type = "covenant",  spec = 321076   },  -- Radiant Spark
		{ spellID = 314791, duration = 60,  type = "covenant",  spec = 321077   },  -- Shifting Power
		{ spellID = 2139,   duration = 24,  type = "interrupt"  },  -- Counterspell
		{ spellID = 198100, duration = 30,  type = "dispel",    spec = true,    parent = 30449  },  -- Kleptomania (talent ID) - [2]
		{ spellID = 475,    duration = 8,   type = "dispel"     },  -- Remove Curse
		{ spellID = 31661,  duration = 18,  type = "cc",        spec = {63}     },  -- Dragon's Breath (Rank2 -2s)
		{ spellID = 113724, duration = 45,  type = "cc",        spec = true     },  -- Ring of Frost
		{ spellID = 353128, duration = 45,  type = "disarm",    spec = true     },  -- Arcanosphere -- Patch 9.1 new
		{ spellID = 157981, duration = 25,  type = "disarm",    spec = true     },  -- Blast Wave
		{ spellID = 33395,  duration = 25,  type = "disarm",    spec = {64},    talent = 205024 },  -- Freeze (pet)
		{ spellID = 122,    duration = 30,  type = "disarm"     },  -- Frost Nova
		{ spellID = 157997, duration = 25,  type = "disarm",    spec = true     },  -- Ice Nova
		{ spellID = 352278, duration = 90,  type = "disarm",    spec = true     },  -- Ice Wall -- Patch 9.1 new
		{ spellID = 157980, duration = 25,  type = "disarm",    spec = true     },  -- Supernova
		{ spellID = 45438,  duration = 240, type = "immunity"   },  -- Ice Block
		{ spellID = 342245, duration = 60,  type = "defensive", spec = {62}     },  -- Alter Time (A) (dummy spell)
		{ spellID = 108978, duration = 60,  type = "defensive", spec = {63, 64} },  -- Alter Time (FF) (dummy spell)
		{ spellID = 86949,  duration = 300, type = "defensive", spec = {63}     },  -- Cauterized (dummy spell)
		{ spellID = 235219, duration = 270, type = "defensive", spec = {64}     },  -- Cold Snap (Rank2 -30s)
		{ spellID = 110960, duration = 120, type = "defensive", spec = {62}     },  -- Greater Invisibility
		{ spellID = 66,     duration = 300, type = "defensive", spec = {63, 64} },  -- Invisibility
		{ spellID = 198158, duration = 60,  type = "defensive", spec = true     },  -- Mass Invisibility
		{ spellID = 235313, duration = 25,  type = "defensive", spec = {63},    },  -- Blazing Barrier
		{ spellID = 11426,  duration = 25,  type = "defensive", spec = {64},    },  -- Ice Barrier
		{ spellID = 235450, duration = 25,  type = "defensive", spec = {62},    },  -- Prismatic Barrier
		{ spellID = 198111, duration = 45,  type = "defensive", spec = true     },  -- Temporal Shield
		{ spellID = 153626, duration = 20,  type = "offensive", spec = true     },  -- Arcane Orb
		{ spellID = 12042,  duration = 120, type = "offensive", spec = {62}     },  -- Arcane Power
		{ spellID = 205032, duration = 40,  type = "offensive", spec = true     },  -- Charged Up
		{ spellID = 190319, duration = 120, type = "offensive", spec = {63}     },  -- Combustion
		{ spellID = 153595, duration = 30,  type = "offensive", spec = true     },  -- Comet Storm
		{ spellID = 257537, duration = 45,  type = "offensive", spec = true     },  -- Ebonbolt
		{ spellID = 108853, duration = 12,  type = "offensive", spec = {63},    charges = 2 },  -- Fire Blast (Fire)
		{ spellID = 319836, duration = 12,  type = "offensive", spec = {62,64}  },  -- Fire Blast
		{ spellID = 84714,  duration = 60,  type = "offensive", spec = {64}     },  -- Frozen Orb
		{ spellID = 203286, duration = 15,  type = "offensive", spec = {63}     },  -- Greater Pyroblast
		{ spellID = 12472,  duration = 180, type = "offensive", spec = {64},    talent = 198144 },  -- Icy Veins
		{ spellID = 198144, duration = 60,  type = "offensive", spec = true,    parent = 12472  },  -- Ice Form
		{ spellID = 153561, duration = 45,  type = "offensive", spec = true     },  -- Meteor
		{ spellID = 55342,  duration = 120, type = "offensive"  },  -- Mirror Image
		{ spellID = 257541, duration = 25,  type = "offensive", spec = {63},    charges = 3 },  -- Pheonix Flames
		{ spellID = 205025, duration = 60,  type = "offensive", spec = {62}     },  -- Presence of Mind
		{ spellID = 205021, duration = 75,  type = "offensive", spec = true     },  -- Ray of Frost
		{ spellID = 353082, duration = 30,  type = "offensive", spec = true     },  -- Ring of Fire -- Patch 9.1 new
		{ spellID = 116011, duration = 45,  type = "offensive", spec = true     },  -- Rune of Power
		{ spellID = 80353,  duration = 300, type = "offensive", pve = true      },  -- Time Warp
		{ spellID = 321507, duration = 45,  type = "offensive", spec = {62}     },  -- Touch of the Magi
		{ spellID = 1953,   duration = 15,  type = "other",     talent = 212653 },  -- Blink
		{ spellID = 190356, duration = 8,   type = "other",     spec = {64}     },  -- Blizzard
		{ spellID = 120,    duration = 12,  type = "other",     spec = {64}     },  -- Cone of Cold
		{ spellID = 12051,  duration = 90,  type = "other",     spec = {62}     },  -- Evocation
		{ spellID = 108839, duration = 20,  type = "other",     spec = true,    charges = 3 },  -- Ice Floes
		{ spellID = 205024, duration = 0,   type = "other",     spec = true,    parent = 33395, hide = true },  -- Lonely Winter (talent ID)
		{ spellID = 212653, duration = 25,  type = "other",     spec = true,    charges = 2,    parent = 1953   },  -- Shimmer
	},
	["MONK"] = { -- 268(BM), 269(WW), 270(MW)
		{ spellID = 325216, duration = 60,  type = "covenant",  spec = 321078   },  -- Bonedust Brew
		{ spellID = 327104, duration = 30,  type = "covenant",  spec = 321077   },  -- Faeline Stomp (RNG 6% to reset self cd while standing on faeline)
		{ spellID = 326860, duration = 180, type = "covenant",  spec = 321079   },  -- Fallen Order
		{ spellID = 310454, duration = 120, type = "covenant",  spec = 321076   },  -- Weapons of Order
		{ spellID = 116705, duration = 15,  type = "interrupt", spec = {268,269}},  -- Spear Hand strike
		{ spellID = 115450, duration = 8,   type = "dispel",    spec = {270}    },  -- Detox
		{ spellID = 218164, duration = 8,   type = "dispel",    spec = {268,269}},  -- Detox
		{ spellID = 202335, duration = 45,  type = "cc",        spec = true     },  -- Double Barrel
		{ spellID = 119381, duration = 60,  type = "cc"         },  -- Leg sweep
		{ spellID = 115078, duration = 30,  type = "cc"         },  -- Paralysis (Rank2 -15s)
		{ spellID = 198898, duration = 30,  type = "cc",        spec = true     },  -- Song of Chi-Ji
		{ spellID = 324312, duration = 30,  type = "disarm",    spec = {268}    },  -- Clash
		{ spellID = 233759, duration = 45,  type = "disarm",    spec = true     },  -- Grapple Weapon
		{ spellID = 202370, duration = 30,  type = "disarm",    spec = true     },  -- Mighty Ox Kick
		{ spellID = 116844, duration = 45,  type = "disarm",    spec = true     },  -- Ring of Peace
		{ spellID = 122470, duration = 90,  type = "immunity",  spec = {269}    },  -- Touch of Karma
		{ spellID = 116849, duration = 120, type = "externalDefensive", spec = {270}    },  -- Life Cocoon
		{ spellID = 202162, duration = 45,  type = "defensive", spec = true     },  -- Avert Harm
		{ spellID = 115399, duration = 120, type = "defensive", spec = true     },  -- Black Ox Brew
		{ spellID = 322507, duration = 60,  type = "defensive", spec = {268}    },  -- Celestial Brew
		{ spellID = 122278, duration = 120, type = "defensive", spec = true     },  -- Dampen Harm
		{ spellID = 122783, duration = 90,  type = "defensive", spec = true     },  -- Diffuse Magic
		{ spellID = 325153, duration = 60,  type = "defensive", spec = true     },  -- Exploding Keg
		{ spellID = 115203, duration = 360, type = "defensive", spec = {268}    },  -- Fortifying Brew (BM)
		{ spellID = 243435, duration = 180, type = "defensive", spec = {269,270}},  -- Fortifying Brew (MW, WW) (Rank2 - 5m)
		{ spellID = 122281, duration = 30,  type = "defensive", spec = true,    charges = 2 },  -- Healing Elixir
		{ spellID = 132578, duration = 180, type = "defensive", spec = {268}    },  -- Invoke Niuzao, the Black Ox
		{ spellID = 119582, duration = 20,  type = "defensive", spec = {268},   charges = 2 },  -- Purifying Brew
		{ spellID = 119996, duration = 45,  type = "defensive"  },  -- Transcendence: Transfer
		{ spellID = 115176, duration = 300, type = "defensive", spec = {268}    },  -- Zen Meditation
		{ spellID = 115310, duration = 180, type = "raidDefensive", spec = {270}},  -- Revival
		{ spellID = 207025, duration = 20,  type = "offensive", spec = true,    parent = 115546 },  -- Admonishment
		{ spellID = 115181, duration = 15,  type = "offensive", spec = {268}    },  -- Breath of Fire
		{ spellID = 115098, duration = 15,  type = "offensive", spec = true     },  -- Chi Wave
		{ spellID = 123986, duration = 30,  type = "offensive", spec = true     },  -- Chi Burst
		{ spellID = 115288, duration = 60,  type = "offensive", spec = true     },  -- Energizing Elixir
		{ spellID = 322101, duration = {[268]=5, default=15},   type = "offensive"  },  -- Expel Harm
		{ spellID = 113656, duration = 24,  type = "offensive", spec = {269}    },  -- Fists of Fury
		{ spellID = 261947, duration = 30,  type = "offensive", spec = true     },  -- Fist of the White Tiger
		{ spellID = 205234, duration = 15,  type = "offensive", spec = true,    charges = 3 },  -- Healing Sphere
		{ spellID = 123904, duration = 120, type = "offensive", spec = {269}    },  -- Invoke Xuen, the White Tiger
		{ spellID = 322118, duration = 180, type = "offensive", spec = {270},   talent = 325197 },  -- Invoke Yu'lon, the Jade Serpent
		{ spellID = 325197, duration = 180, type = "offensive", spec = true,    parent = 322118 },  -- Invoke Chi-Ji, the Red Crane
		{ spellID = 121253, duration = 8,   type = "offensive", spec = {268}    },  -- Keg Smash
		{ spellID = 107428, duration = 10,  type = "offensive", spec = {269}    },  -- Rising Sun Kick
		{ spellID = 137639, duration = 90,  type = "offensive", spec = {269},   charges = 2,    talent = 152173 },  -- Storm, Earth, and Fire (Rank2 +1ch)
		{ spellID = 152173, duration = 90,  type = "offensive", spec = true,    parent = 137639 },  -- Serenity
		{ spellID = 116680, duration = 30,  type = "offensive"  },  -- Thunder Focus Tea
		{ spellID = 322109, duration = 180, type = "offensive"  },  -- Touch of Death
		{ spellID = 152175, duration = 24,  type = "offensive", spec = true     },  -- Whirling Dragon Punch
		{ spellID = 354540, duration = 90,  type = "counterCC", spec = true     },  -- Nimble Brew -- Patch 9.1 new
		{ spellID = 209584, duration = 45,  type = "counterCC", spec = true     },  -- Zen Focus Tea
		{ spellID = 115008, duration = 20,  type = "other",     spec = true,    charges = 2,    parent = 109132 },  -- Chi Torpedo
		{ spellID = 101545, duration = 20,  type = "other",     spec = {269}    },  -- Flying Serpent Kick (Rank2 -5s)
		{ spellID = 109132, duration = 20,  type = "other",     charges = 2,    talent = 115008 },  -- Roll (Rank2 +1ch)
		{ spellID = 197908, duration = 90,  type = "other",     spec = true     },  -- Mana Tea
		{ spellID = 115546, duration = 8,   type = "other",     talent = 207025 },  -- Provoke
		{ spellID = 116841, duration = 30,  type = "other",     spec = true     },  -- Tiger's Lust
	},
	["PALADIN"] = { -- 65(Holy), 66(Prot), 70(Ret)
		{ spellID = 316958, duration = 240, type = "covenant",  spec = 321079   },  -- Ashen Hallow
		{ spellID = 328278, duration = 45,  type = "covenant",  spec = 321077   },  -- Blessing of the Seasons (dummy spell)
		--[[ Merged
--      { spellID = 328622, duration = 45,  type = "covenant",  spec = 321077   },  -- Blessing of Autumn
--      { spellID = 328282, duration = 45,  type = "covenant",  spec = 321077   },  -- Blessing of Spring
--      { spellID = 328620, duration = 45,  type = "covenant",  spec = 321077   },  -- Blessing of Summer
--      { spellID = 328281, duration = 45,  type = "covenant",  spec = 321077   },  -- Blessing of Winter
		--]]
		{ spellID = 304971, duration = 60,  type = "covenant",  spec = 321076   },  -- Divine Toll
		{ spellID = 328204, duration = 30,  type = "covenant",  spec = 321078   },  -- Vanquisher's Hammer (1 holy power)
		{ spellID = 96231,  duration = 15,  type = "interrupt", spec = {66,70}  },  -- Rebuke
		{ spellID = 31935,  duration = 15,  type = "interrupt", spec = {66}     },  -- Avenger's Shield
		{ spellID = 215652, duration = 45,  type = "interrupt", spec = true     },  -- Shield of Virtue
		{ spellID = 4987,   duration = 8,   type = "dispel",    spec = {65}     },  -- Cleanse
		{ spellID = 213644, duration = 8,   type = "dispel",    spec = {66,70}  },  -- Cleanse Toxins
		{ spellID = 115750, duration = 90,  type = "cc",        spec = true     },  -- Blinding Light
		{ spellID = 853,    duration = 60,  type = "cc"         },  -- Hammer of Justice
		{ spellID = 20066,  duration = 15,  type = "cc",        spec = true     },  -- Repentance
		{ spellID = 10326,  duration = 15,  type = "cc"         },  -- Turn Evil
		{ spellID = 642,    duration = 300, type = "immunity"   },  -- Divine Shield
		{ spellID = 1022,   duration = 300, type = "externalDefensive", talent = 204018 },  -- Blessing of Protection
		{ spellID = 204018, duration = 180, type = "externalDefensive", spec = true,    parent = 1022   },  -- Blessing of Spellwarding
		{ spellID = 6940,   duration = 120, type = "externalDefensive", talent = 199452 },  -- Blessing of Sacrifice
		{ spellID = 199452, duration = 120, type = "externalDefensive", spec = true,    parent = 6940   },  -- Ultimate Sacrifice - [2]
		{ spellID = 228049, duration = 180, type = "externalDefensive", spec = true,    parent = 86659  },  -- Guardian of the Forgotten Queen
		{ spellID = 31850,  duration = 120, type = "defensive", spec = {66}     },  -- Ardent Defender
		{ spellID = 498,    duration = 60,  type = "defensive", spec = {65}     },  -- Divine Protection
		{ spellID = 205191, duration = 60,  type = "defensive", spec = true     },  -- Eye for an eye
		{ spellID = 86659,  duration = 300, type = "defensive", spec = {66},    talent = 228049 },  -- Guardian of the Ancient Kings
		{ spellID = 633,    duration = 600, type = "defensive", pve = true      },  -- Lay on Hands
		{ spellID = 184662, duration = 120, type = "defensive", spec = {70}     },  -- Shield of Vengeance
		{ spellID = 31821,  duration = 180, type = "raidDefensive", spec = {65} },  -- Aura Mastery
		{ spellID = 216331, duration = 120, type = "offensive", spec = true,    parent = 31884  },  -- Avenging Crusader
		{ spellID = 31884,  duration = 120, type = "offensive", talent = {216331,231895}    },  -- Avenging Wrath
		{ spellID = 231895, duration = 120, type = "offensive", spec = true,    parent = 31884  },  -- Crusade
		{ spellID = 200025, duration = 15,  type = "offensive", spec = true,    parent = 53563  },  -- Beacon of Virtue
		{ spellID = 223306, duration = 12,  type = "offensive", spec = true     },  -- Bestow Faith
		{ spellID = 343527, duration = 60,  type = "offensive", spec = true     },  -- Execution Sentence
		{ spellID = 343721, duration = 60,  type = "offensive", spec = true     },  -- Final Reckoning
		{ spellID = 105809, duration = 180, type = "offensive", spec = true     },  -- Holy Avenger
		{ spellID = 114165, duration = 20,  type = "offensive", spec = true     },  -- Holy Prism
		{ spellID = 207028, duration = 20,  type = "offensive", spec = true,    parent = 62124  },  -- Inquisition
		{ spellID = 114158, duration = 60,  type = "offensive", spec = true     },  -- Light's Hammer
		{ spellID = 214202, duration = 30,  type = "offensive", spec = true,    charges = 2 },  -- Rule of Law
		{ spellID = 152262, duration = 45,  type = "offensive", spec = true     },  -- Seraphim
		{ spellID = 255937, duration = 45,  type = "offensive", spec = {70}     },  -- Wake of Ashes
		{ spellID = 327193, duration = 90,  type = "offensive", spec = true     },  -- Moment of Glory
		{ spellID = 210256, duration = 45,  type = "counterCC", spec = true     },  -- Blessing of Sanctuary
		{ spellID = 210294, duration = 30,  type = "counterCC", spec = true     },  -- Divine Favor (Jan. 25. 2021 Hotfix 25->30s)
		{ spellID = 1044,   duration = 25,  type = "other"      },  -- Blessing of Freedom
		{ spellID = 190784, duration = 45,  type = "other"      },  -- Divine Steed (Rank2 -15s)
		{ spellID = 183218, duration = 30,  type = "other",     spec = {70}     },  -- Hand of Hinderance
		{ spellID = 62124,  duration = 8,   type = "other",     talent = 207028 },  -- Hand of Reckoning
	},
	["PRIEST"] = { -- 256(Disc), 257(Holy), 258(Shadow)
		{ spellID = 325013, duration = 180, type = "covenant",  spec = 321076   },  -- Boon of the Ascended
		{ spellID = 327661, duration = 90,  type = "covenant",  spec = 321077   },  -- Fae Guardians
		{ spellID = 323673, duration = 45,  type = "covenant",  spec = 321079   },  -- Mindgames
		{ spellID = 324724, duration = 60,  type = "covenant",  spec = 321078   },  -- Unholy Nova
		{ spellID = 15487,  duration = 45,  type = "interrupt", spec = {258}    },  -- Silence
		{ spellID = 32375,  duration = 45,  type = "dispel"     },  -- Mass Dispel
		{ spellID = 527,    duration = 8,   type = "dispel",    spec = {256,257}},  -- Purify
		{ spellID = 213634, duration = 8,   type = "dispel",    spec = {258}    },  -- Purify Disease
		{ spellID = 88625,  duration = 60,  type = "cc",        spec = {257}    },  -- Holy Word: Chastise
		{ spellID = 64044,  duration = 45,  type = "cc",        spec = true     },  -- Psychic Horror
		{ spellID = 8122,   duration = 60,  type = "cc",        talent = 205369 },  -- Psychic Scream
		{ spellID = 205369, duration = 30,  type = "cc",        spec = true,    parent = 8122   },  -- Mind Bomb
		{ spellID = 204263, duration = 45,  type = "disarm",    spec = true     },  -- Shining Force
		{ spellID = 213602, duration = 45,  type = "immunity",  spec = true,    parent = 586    },  -- Greater Fade
		{ spellID = 197268, duration = 60,  type = "immunity",  spec = true     },  -- Ray of Hope
		{ spellID = 47788,  duration = 180, type = "externalDefensive", spec = {257}    },  -- Guardian Spirit
		{ spellID = 33206,  duration = 180, type = "externalDefensive", spec = {256}    },  -- Pain Suppression
		{ spellID = 19236,  duration = 90,  type = "defensive"  },  -- Desperate Prayer
		{ spellID = 47585,  duration = 120, type = "defensive", spec = {258}    },  -- Dispersion
		{ spellID = 328530, duration = 60,  type = "defensive", spec = true     },  -- Divine Ascension
		{ spellID = 20711,  duration = 600, type = "defensive", spec = 337477,  talent = 215982 },  -- Spirit of the Redemption (passive) - (Runeforge)
		{ spellID = 215982, duration = 120, type = "defensive", spec = true,    parent = 20711  },  -- Spirit of the Redeemer (talent ID)   -- Patch 9.1 cd 180>120
		{ spellID = 108968, duration = 300, type = "defensive", spec = true     },  -- Void Shift
		{ spellID = 64843,  duration = 180, type = "raidDefensive", spec = {257}},  -- Divine Hymn
		{ spellID = 265202, duration = 720, type = "raidDefensive", spec = true },  -- Holy Word: Salvation
		{ spellID = 62618,  duration = 180, type = "raidDefensive", spec = {256}},  -- Power Word: Barrier
		{ spellID = 15286,  duration = 120, type = "raidDefensive", spec = {258}},  -- Vampiric Embrace
		{ spellID = 200183, duration = 120, type = "offensive", spec = true     },  -- Apotheosis
		{ spellID = 197862, duration = 60,  type = "offensive", spec = true     },  -- Archangel
		{ spellID = 204883, duration = 15,  type = "offensive", spec = {257}    },  -- Circle of Healing
		{ spellID = 341374, duration = 45,  type = "offensive", spec = true     },  -- Damnation
		{ spellID = 197871, duration = 60,  type = "offensive", spec = true     },  -- Dark Archangel
		{ spellID = 110744, duration = 15,  type = "offensive", spec = true     },  -- Divine Star
		{ spellID = 246287, duration = 90,  type = "offensive", spec = true     },  -- Evangelism
		{ spellID = 289666, duration = 12,  type = "offensive", spec = true     },  -- Greater Heal -- Patch 9.1 changed 15>12s
		{ spellID = 120517, duration = 40,  type = "offensive", spec = true     },  -- Halo
		{ spellID = 34861,  duration = 60,  type = "offensive", spec = {257}    },  -- Holy Word: Sanctify
		{ spellID = 2050,   duration = 60,  type = "offensive", spec = {257}    },  -- Holy Word: Serenity
		{ spellID = 211522, duration = 45,  type = "offensive", spec = true     },  -- Psyfiend
		{ spellID = 47536,  duration = 90,  type = "offensive", spec = {256},   talent = 109964 },  -- Rapture
		{ spellID = 214621, duration = 24,  type = "offensive", spec = true     },  -- Schism
		{ spellID = 32379,  duration = 20,  type = "offensive"  },  -- Shadow Word: Death (Rank2 -10s)
		{ spellID = 314867, duration = 30,  type = "offensive", spec = true     },  -- Shadow Covenant
		{ spellID = 109964, duration = 90,  type = "offensive", spec = true,    parent = 47536  },  -- Spirit Shell -- Patch 9.1 cd 60>90
		{ spellID = 319952, duration = 90,  type = "offensive", spec = {319952,357701}  },  -- Surrender to Madness -- Patch 9.1 (Megalomania - new pvp talent gives Surrender to Madness talent)
		{ spellID = 228260, duration = 90,  type = "offensive", spec = {258}    },  -- Void Eruption
		{ spellID = 263165, duration = 30,  type = "offensive", spec = true     },  -- Void Torrent
		{ spellID = 10060,  duration = 120, type = "offensive"  },  -- Power Infusion
		{ spellID = 194509, duration = 20,  type = "offensive", spec = {256},   charges = 2 },  -- Power Word: Radiance
		{ spellID = 205385, duration = 30,  type = "offensive", spec = true     },  -- Shadow Crash
		{ spellID = 34433,  duration = 180, type = "offensive", spec = {256,258},   talent = {123040, 200174}   },  -- Shadowfiend
		{ spellID = 123040, duration = 60,  type = "offensive", spec = true,    parent = 34433  },  -- Mindbender
		{ spellID = 200174, duration = 60,  type = "offensive", spec = true,    parent = 34433  },  -- Mindbender (Shadow)
		{ spellID = 213610, duration = 30,  type = "counterCC", spec = true     },  -- Holy Ward
--      { spellID = 289657, duration = 45,  type = "counterCC", spec = true     },  -- Holy Word: Concentration -- Patch 9.1 changed to Santified Ground(passive)
--      { spellID = 305498, duration = 12,  type = "counterCC", spec = true     },  -- Premonition  -- 9.0? removed
		{ spellID = 121536, duration = 20,  type = "other",     spec = true,    charges = 3 }, -- Angelic Feather
		{ spellID = 586,    duration = 30,  type = "other",     talent = 213602 },  -- Fade
		{ spellID = 73325,  duration = 90,  type = "other"      },  -- Leap of Faith
		{ spellID = 64901,  duration = 300, type = "other",     spec = {257}    },  -- Symbol of Hope
		{ spellID = 316262, duration = 90,  type = "other",     spec = true     },  -- Thoughtsteal
	},
	["ROGUE"] = { -- 259(Assa), 260(Outlaw), 261(Sub)
		{ spellID = 323547, duration = 45,  type = "covenant",  spec = 321076   },  -- Echoing Reprimand
		{ spellID = 323654, duration = 90,  type = "covenant",  spec = 321079   },  -- Flagellation
		{ spellID = 328305, duration = 90,  type = "covenant",  spec = 321077   },  -- Sepsis
		{ spellID = 328547, duration = 30,  type = "covenant",  spec = 321078,  charges = 3 },  -- Serrated Bone Spike
		{ spellID = 1766,   duration = 15,  type = "interrupt"  },  -- Kick
		{ spellID = 2094,   duration = 120, type = "cc"         },  -- Blind
		{ spellID = 1776,   duration = 15,  type = "cc",        spec = {260}    },  -- Gouge
		{ spellID = 408,    duration = 20,  type = "cc"         },  -- Kidney Shot
		{ spellID = 207736, duration = 120, type = "cc",        spec = true     },  -- Shadowy Duel
		{ spellID = 212182, duration = 180, type = "cc",        spec = true     },  -- Smoke Bomb
		{ spellID = 207777, duration = 45,  type = "disarm",    spec = true     },  -- Dismantle
		{ spellID = 31230,  duration = 360, type = "defensive", spec = true     },  -- Cheat Death (dummy spell)
		{ spellID = 31224,  duration = 120, type = "defensive"  },  -- Cloak of Shadows
		{ spellID = 185311, duration = 30,  type = "defensive"  },  -- Crimson Vial
		{ spellID = 5277,   duration = 120, type = "defensive"  },  -- Evasion
		{ spellID = 1966,   duration = 15,  type = "defensive"  },  -- Feint
		{ spellID = 1856,   duration = 120, type = "defensive"  },  -- Vanish
		{ spellID = 13750,  duration = 180, type = "offensive", spec = {260}    },  -- Adrenaline Rush
		{ spellID = 315341, duration = 45,  type = "offensive", spec = {260}    },  -- Between the Eyes
		{ spellID = 13877,  duration = 30,  type = "offensive", spec = {260}    },  -- Blade Flurry
		{ spellID = 271877, duration = 45,  type = "offensive", spec = true     },  -- Blade Rush
--      { spellID = 213981, duration = 60,  type = "offensive", spec = true     },  -- Cold Blood -- Patch 9.1 removed
		{ spellID = 343142, duration = 90,  type = "offensive", spec = true     },  -- Dreadblades
		{ spellID = 269513, duration = 30,  type = "offensive", spec = true     },  -- Death from Above
		{ spellID = 200806, duration = 45,  type = "offensive", spec = true     },  -- Exsanguinate
		{ spellID = 196937, duration = 30,  type = "offensive", spec = true     },  -- Ghostly Strike
		{ spellID = 51690,  duration = 120, type = "offensive", spec = true     },  -- Killing Spree
		{ spellID = 137619, duration = {default=30, [260]=60},  type = "offensive", spec = true },  -- Marked for Death
--      { spellID = 206328, duration = 45,  type = "offensive", spec = true     },  -- Neurotoxin -- Patch 9.1 removed
--      { spellID = 198529, duration = 120, type = "offensive", spec = true     },  -- Plunder Armor -- Patch 9.1 removed
		{ spellID = 315508, duration = 45,  type = "offensive", spec = {260}    },  -- Roll of the Bones
		{ spellID = 280719, duration = 45,  type = "offensive", spec = true     },  -- Secret Technique
		{ spellID = 121471, duration = 180, type = "offensive", spec = {261}    },  -- Shadow Blades
		{ spellID = 185313, duration = 60,  type = "offensive", spec = {261}    },  -- Shadow Dance
		{ spellID = 277925, duration = 60,  type = "offensive", spec = true     },  -- Shuriken Tornado
		{ spellID = 212283, duration = 30,  type = "offensive", spec = {261}    },  -- Symbol of Death
		{ spellID = 221622, duration = 30,  type = "offensive", spec = true,    parent = 57934  },  -- Thick as Thieves (talent ID) - [2]
		{ spellID = 5938,   duration = 25,  type = "offensive"  },  -- Shiv
		{ spellID = 79140,  duration = 120, type = "offensive", spec = {259}    },  -- Vendetta
		{ spellID = 1725,   duration = 30,  type = "other",     talent = 354661 },  -- Distract
		{ spellID = 354661, duration = 30,  type = "other",     spec = true,    parent = 1725   },  -- Distracting Mirage   -- Patch 9.1 new
		{ spellID = 195457, duration = 45,  type = "other",     spec = {260}    },  -- Grappling Hook (rank2 -15s)
		{ spellID = 36554,  duration = 30,  type = "other",     spec = {259,261},   charges = {[261]=2,default=1}   },  -- Shadowstep
		{ spellID = 114018, duration = 360, type = "other"      },  -- Shroud of Consealment
		{ spellID = 2983,   duration = 60,  type = "other"      },  -- Sprint
		{ spellID = 57934,  duration = 30,  type = "other",     talent = 221622 },  -- Tricks of the Trade
	},
	["SHAMAN"] = { -- 262(Ele), 263(Enh), 264(Resto)
		{ spellID = 320674, duration = 90,  type = "covenant",  spec = 321079   },  -- Chain Harvest
		{ spellID = 328923, duration = 120, type = "covenant",  spec = 321077   },  -- Fae Transfusion (CD start on preActive state)
		{ spellID = 326059, duration = 45,  type = "covenant",  spec = 321078   },  -- Primordial Wave
		{ spellID = 324386, duration = 60,  type = "covenant",  spec = 321076   },  -- Versper Totem
		{ spellID = 57994,  duration = 12,  type = "interrupt"  },  -- Wind Shear
		{ spellID = 51886,  duration = 8,   type = "dispel",    spec = {262,263}},  -- Cleanse Spirit
		{ spellID = 77130,  duration = 8,   type = "dispel",    spec = {264}    },  -- Purify Spirit
		{ spellID = 192058, duration = 60,  type = "cc"         },  -- Capacitor Totem
		{ spellID = 51514,  duration = 20,  type = "cc"         },  -- Hex
		{ spellID = 305483, duration = 30,  type = "cc",        spec = true     },  -- Lightning Lasso
		{ spellID = 197214, duration = 40,  type = "cc",        spec = true     },  -- Sundering
		{ spellID = 51485,  duration = 30,  type = "disarm",    spec = true     },  -- Earthgrab Totem
		{ spellID = 355580, duration = 60,  type = "disarm",    spec = true     },  -- Static Field Totem   -- Patch 9.1 new
		{ spellID = 51490,  duration = 45,  type = "disarm",    spec = {262}    },  -- Thunderstorm
		{ spellID = 356736, duration = 30,  type = "disarm",    spec = true     },  -- Unleash Shield   -- Patch 9.1 new
		{ spellID = 108281, duration = 120, type = "defensive", spec = true     },  -- Ancestral Guidance
		{ spellID = 207399, duration = 300, type = "defensive", spec = true     },  -- Ancestral Protection Totem
		{ spellID = 108271, duration = 90,  type = "defensive", talent = 210918 },  -- Astral Shift
		{ spellID = 198838, duration = 60,  type = "defensive", spec = true     },  -- Earthen Wall Totem
		{ spellID = 210918, duration = 45,  type = "defensive", spec = true,    parent = 108271 },  -- Ethereal Form
		{ spellID = 30884,  duration = 45,  type = "defensive", spec = true     },  -- Nature's Guardian (dummy spell)
--      { spellID = 204293, duration = 0.5, type = "defensive", spec = true,    parent = 98008  },  -- Spirit Link  -- Patch 9.1 removed
--      { spellID = 98008,  duration = 180, type = "raidDefensive", spec = {264},   talent = 204293 },  -- Spirit Link Totem
		{ spellID = 98008,  duration = 180, type = "raidDefensive", spec = {264}},  -- Spirit Link Totem
		{ spellID = 108280, duration = 180, type = "raidDefensive", spec = {264}},  -- Healing Tide Totem
		{ spellID = 114052, duration = 180, type = "offensive", spec = true     },  -- Ascendance (Res)
		{ spellID = 114050, duration = 180, type = "offensive", spec = true     },  -- Ascendance (Ele)
		{ spellID = 114051, duration = 180, type = "offensive", spec = true     },  -- Ascendance (Enh)
		{ spellID = 2825,   duration = 300, type = "offensive", pve = true,     talent = 193876 },  -- Bloodlust
		{ spellID = 193876, duration = 60,  type = "offensive", spec = true,    parent = 2825   },  -- Shamanism (talent ID) - [2]
		{ spellID = 188089, duration = 20,  type = "offensive", spec = true     },  -- Earthen Spike
		{ spellID = 320125, duration = 30,  type = "offensive", spec = true     },  -- Echoing Shock
		{ spellID = 117014, duration = 12,  type = "offensive", spec = true     },  -- Elemental Blast
		{ spellID = 51533,  duration = 120, type = "offensive", spec = {263}    },  -- Feral Spirit
		{ spellID = 198067, duration = 150, type = "offensive", spec = {262},   talent = 192249 },  -- Fire Elemental
		{ spellID = 333974, duration = 15,  type = "offensive", spec = true     },  -- Fire Nova
		{ spellID = 192249, duration = 150, type = "offensive", spec = true,    parent = 198067 },  -- Storm Elemental
		{ spellID = 5394,   duration = 30,  type = "offensive", talent = 157153 },  -- Healing Stream Totem
		{ spellID = 157153, duration = 30,  type = "offensive", spec = true,    parent = 5394   },  -- Cloudburst Totem
		{ spellID = 342240, duration = 15,  type = "offensive", spec = true     },  -- Ice Strike
		{ spellID = 210714, duration = 30,  type = "offensive", spec = true     },  -- Icefury
		{ spellID = 192222, duration = 60,  type = "offensive", spec = true     },  -- Liquid Magma Totem
		{ spellID = 204330, duration = 40,  type = "offensive", spec = true     },  -- Skyfury Totem
		{ spellID = 342243, duration = 30,  type = "offensive", spec = true     },  -- Static Discharge
		{ spellID = 320137, duration = 60,  type = "offensive", spec = true     },  -- Stormkeeper (Enh)
		{ spellID = 191634, duration = 60,  type = "offensive", spec = true     },  -- Stormkeeper
		{ spellID = 320746, duration = 20,  type = "offensive", spec = true     },  -- Surge of Earth
		{ spellID = 204366, duration = 45,  type = "offensive", spec = true     },  -- Thundercharge
		{ spellID = 73685,  duration = 15,  type = "offensive", spec = true     },  -- Unleash Life
		{ spellID = 197995, duration = 20,  type = "offensive", spec = true     },  -- Wellspring
		{ spellID = 204336, duration = 30,  type = "counterCC", spec = true     },  -- Grounding Totem
		{ spellID = 79206,  duration = 120, type = "counterCC", spec = {262,264}},  -- Spiritwalker's Grace
		{ spellID = 8143,   duration = 60,  type = "counterCC"  },  -- Tremor Totem
		{ spellID = 192077, duration = 120, type = "raidMovement",     spec = true     },  -- Wind Rush Totem
		{ spellID = 204331, duration = 45,  type = "other",     spec = true     },  -- Counterstrike Totem
		{ spellID = 198103, duration = 300, type = "other"      },  -- Earth Elemental
		{ spellID = 2484,   duration = 30,  type = "other"      },  -- Earthbind Totem
		{ spellID = 196884, duration = 30,  type = "other",     spec = true     },  -- Feral Lunge
		{ spellID = 16191,  duration = 180, type = "other",     spec = {264}    },  -- Mana Tide Totem
		{ spellID = 20608,  duration = 1800,type = "other",     pve = true      },  -- Reincarnation (dummy spell)
		{ spellID = 58875,  duration = 60,  type = "other",     spec = {263}    },  -- Spirit Walk
	},
	["WARLOCK"] = { -- 265(Aff), 266(Demo), 267(Dest)
		{ spellID = 325289, duration = 45,  type = "covenant",  spec = 321078,  },  -- Decimating Bolt
		{ spellID = 321792, duration = 60,  type = "covenant",  spec = 321079,  },  -- Impending Catastrophe
		{ spellID = 312321, duration = 40,  type = "covenant",  spec = 321076,  },  -- Scouring Tithe
		{ spellID = 325640, duration = 60,  type = "covenant",  spec = 321077,  },  -- Soul Rot
		-- TODO: detect pet?
		{ spellID = 119898, duration = 24,  type = "interrupt"  },  -- Command Demon
		{ spellID = 212619, duration = 24,  type = "interrupt", spec = true     },  -- Call Felhunter - [3]*
--      { spellID = 212623, duration = 15,  type = "dispel",    spec = true     },  -- Singe Magic (Bug? works with other pets)   -- Patch 9.1 removed
		{ spellID = 111898, duration = 120, type = "cc",        spec = true     },  -- Grimoire: Felguard
		{ spellID = 5484,   duration = 40,  type = "cc",        spec = true     },  -- Howl of Terror
		{ spellID = 6789,   duration = 45,  type = "cc",        spec = true     },  -- Mortal Coil
		{ spellID = 30283,  duration = 60,  type = "cc"         },  -- Shadowfury
		{ spellID = 353294, duration = 60,  type = "disarm",    spec = true     },  -- Shadow Rift  -- Patch 9.1 new
		{ spellID = 108416, duration = 60,  type = "defensive", spec = true     },  -- Dark Pact
		{ spellID = 48020,  duration = 30,  type = "defensive"  },  -- Demonic Circle: Teleport
		{ spellID = 113942, duration = 90,  type = "defensive"  },  -- Demonic Gateway (dummy spell)
		{ spellID = 104773, duration = 180, type = "defensive"  },  -- Unending Resolve
		{ spellID = 328774, duration = 45,  type = "offensive", spec = true     },  -- Amplify Curse
		{ spellID = 199954, duration = 45,  type = "offensive", spec = true     },  -- Bane of Fragility
		{ spellID = 234877, duration = 30,  type = "offensive", spec = true     },  -- Bane of Shadows
		{ spellID = 267211, duration = 30,  type = "offensive", spec = true     },  -- Bilescourge Bombers
		{ spellID = 353753, duration = 30,  type = "offensive", spec = true     },  -- Bonds of Fel -- Patch 9.1 new
		{ spellID = 104316, duration = 20,  type = "offensive", spec = {266}    },  -- Call Dreadstalkers
		{ spellID = 201996, duration = 90,  type = "offensive", spec = true     },  -- Call Observer
		{ spellID = 212459, duration = 120, type = "offensive", spec = true     },  -- Call Fel Lord    -- Patch 9.1 cd 90>120
		{ spellID = 152108, duration = 30,  type = "offensive", spec = true     },  -- Cataclysm
		{ spellID = 196447, duration = 25,  type = "offensive", spec = true     },  -- Channel Demonfire
		{ spellID = 17962,  duration = 13,  type = "offensive", spec = {267},   charges = 2 },  -- Conflagrate
		{ spellID = 113858, duration = 120, type = "offensive", spec = true     },  -- Dark Soul: Instability
		{ spellID = 113860, duration = 120, type = "offensive", spec = true     },  -- Dark Soul: Misery
		{ spellID = 264106, duration = 45,  type = "offensive", spec = true     },  -- Deathbolt
		{ spellID = 267171, duration = 60,  type = "offensive", spec = true     },  -- Demonic Strength
		{ spellID = 333889, duration = 180, type = "offensive"  },  -- Fel Domination
		{ spellID = 353601, duration = 45,  type = "offensive", spec = true     },  -- Fel Obelisk  -- Patch 9.1 new
		{ spellID = 108503, duration = 30,  type = "offensive", spec = true     },  -- Grimoire of Sacrifice
		{ spellID = 48181,  duration = 15,  type = "offensive", spec = true     },  -- Haunt
		{ spellID = 267217, duration = 150, type = "offensive", spec = true     },  -- Nether Portal    -- Patch 9.1.5 cd 180>150
		{ spellID = 264130, duration = 30,  type = "offensive", spec = true     },  -- Power Siphon
		{ spellID = 205179, duration = 45,  type = "offensive", spec = true     },  -- Phantom Singularity
		{ spellID = 344566, duration = 30,  type = "offensive", spec = true     },  -- Rapid Contagion
		{ spellID = 17877,  duration = 12,  type = "offensive", spec = true,    charges = 2 },  -- Shadowburn
		{ spellID = 264057, duration = 10,  type = "offensive", spec = true     },  -- Soul Strike
		{ spellID = 6353,   duration = 45,  type = "offensive", spec = true     },  -- Soul Fire
--      { spellID = 212356, duration = 60,  type = "offensive", spec = true     },  -- Soulshatter  -- Patch 9.1 removed
		{ spellID = 205180, duration = 120, type = "offensive", spec = {265}    },  -- Summon Darkglare -- Patch 9.1 CD 180>120 (Dark Caller lvl58 passive -60s)
		{ spellID = 265187, duration = 90,  type = "offensive", spec = {266}    },  -- Summon Demonic Tyrant
		{ spellID = 1122,   duration = 180, type = "offensive", spec = {267}    },  -- Summon Infernal
		{ spellID = 264119, duration = 45,  type = "offensive", spec = true     },  -- Summon Vilefiend
		{ spellID = 278350, duration = 20,  type = "offensive", spec = true     },  -- Vile Taint
		{ spellID = 221703, duration = 60,  type = "counterCC", spec = true     },  -- Casting Circle
		{ spellID = 212295, duration = 45,  type = "counterCC", spec = true     },  -- Nether Ward
		{ spellID = 200546, duration = 45,  type = "other",     spec = true,    parent = 80240 },   -- Bane of Havoc
		{ spellID = 29893,  duration = 120, type = "other"      },  -- Create Soulwell
		{ spellID = 80240,  duration = 30,  type = "other",     spec = {267},   talent = 200546 },  -- Havoc
		-- TODO: get event that fires when a doom guard is sucessfully summoned
--      { spellID = 342601, duration = 3600,type = "other",                     },  -- Ritual of Doom
	},
	["WARRIOR"] = { -- 71(Arms), 72(Fury), 73(Prot)
		{ spellID = 325886, duration = 90,  type = "covenant",  spec = 321077   },  -- Acient Aftershock (stun debuff 1.5s - 325886)
		{ spellID = 317483, duration = 6,   type = "covenant",  spec = 321079,  parent = 5308   },  -- Condemn (replace execute) - ADD to spenders (317320)
		{ spellID = 324143, duration = 120, type = "covenant",  spec = 321078   },  -- Conqueror's Banner   -- Patch 9.0.5 cd 180>120
		{ spellID = 307865, duration = 60,  type = "covenant",  spec = 321076   },  -- Spear of Bastion
		{ spellID = 6552,   duration = 15,  type = "interrupt"  },  -- Pummel
		{ spellID = 5246,   duration = 90,  type = "cc"         },  -- Intimidating Shout
		{ spellID = 46968,  duration = 40,  type = "cc",        spec = {73}     },  -- Shockwave
		{ spellID = 107570, duration = 30,  type = "cc",        spec = true     },  -- Stormbolt
		{ spellID = 199086, duration = 45,  type = "cc",        spec = true,    parent = 6544   },  -- Warpath (talent ID) - [2]
		{ spellID = 236077, duration = 45,  type = "disarm",    spec = true     },  -- Disarm
		{ spellID = 213871, duration = 15,  type = "defensive", spec = true     },  -- Bodyguard
		{ spellID = 1160,   duration = 45,  type = "defensive", spec = {73}     },  -- Demoralizing Shout
		{ spellID = 118038, duration = 120, type = "defensive", spec = {71}     },  -- Die by the Sword
		{ spellID = 236273, duration = 60,  type = "defensive", spec = true     },  -- Duel
		{ spellID = 184364, duration = 120, type = "defensive", spec = {72}     },  -- Enraged Regeneration (Rank2 -1m)
		{ spellID = 190456, duration = {[73]=1,default=12}, type = "defensive"  },  -- Ignore Pain
		{ spellID = 202168, duration = 25,  type = "defensive", spec = true,    parent = 34428  },  -- Impending Victory    -- Patch 9.1.5 cd 30>25
		{ spellID = 12975,  duration = 180, type = "defensive", spec = {73}     },  -- Last Stand
		{ spellID = 2565,   duration = 15,  type = "defensive", charges = 2     },  -- Shield Block
		{ spellID = 871,    duration = 240, type = "defensive", spec = {73}     },  -- Shield Wall
		{ spellID = 97462,  duration = 180, type = "raidDefensive"  },  -- Rallying Cry
		{ spellID = 107574, duration = 90,  type = "offensive", spec = {73,107574}  },  -- Avatar
		{ spellID = 227847, duration = 90,  type = "offensive", spec = {71},    talent = 152277 },  -- Bladestorm
		{ spellID = 46924,  duration = 60,  type = "offensive", spec = true     },  -- Bladestorm (F)
		{ spellID = 152277, duration = 45,  type = "offensive", spec = true,    parent = 227847 },  -- Ravager (A)
		{ spellID = 228920, duration = 45,  type = "offensive", spec = true     },  -- Ravager (P)
		{ spellID = 167105, duration = 45,  type = "offensive", spec = {71},    talent = 262161 },  -- Colossus Smash (Rank2 -45s)
		{ spellID = 262161, duration = 45,  type = "offensive", spec = true,    parent = 167105 },  -- Warbreaker
		{ spellID = 262228, duration = 60,  type = "offensive", spec = true     },  -- Deadly Calm
		{ spellID = 118000, duration = 30,  type = "offensive", spec = true     },  -- Dragon Roar
		{ spellID = 205800, duration = 20,  type = "offensive", spec = true,    parent = 355 }, -- Oppressor
		{ spellID = 7384,   duration = 12,  type = "offensive", spec = {71}     },  -- Overpower
		{ spellID = 1719,   duration = 90,  type = "offensive", spec = {72}     },  -- Recklessness
		{ spellID = 198817, duration = 25,  type = "offensive", spec = true     },  -- Sharpen Blade
		{ spellID = 198912, duration = 10,  type = "offensive", spec = true     },  -- Shield Bash
		{ spellID = 23922,  duration = 9,   type = "offensive"  },  -- Shield Slam
		{ spellID = 280772, duration = 30,  type = "offensive", spec = true     },  -- Siegebreaker
		{ spellID = 260643, duration = 20,  type = "offensive", spec = true     },  -- Skullsplitter
		{ spellID = 260708, duration = 30,  type = "offensive", spec = {71}     },  -- Sweeping Strikes (Rank2 -15s)
		{ spellID = 18499,  duration = 60,  type = "counterCC"  },  -- Berserker Rage
		{ spellID = 3411,   duration = 30,  type = "counterCC"  },  -- Intervene
		{ spellID = 23920,  duration = 25,  type = "counterCC"  },  -- Spell Reflection
		{ spellID = 236320, duration = 90,  type = "counterCC", spec = true     },  -- War Banner
		{ spellID = 329038, duration = 20,  type = "other",     spec = true     },  -- Bloodrage
		{ spellID = 1161,   duration = 240, type = "other"      },  -- Challenging Shout
		{ spellID = 100,    duration = 20,  type = "other"      },  -- Charge
		{ spellID = 206572, duration = 20,  type = "other",     spec = true     },  -- Dragon Charge
		{ spellID = 6544,   duration = 45,  type = "other",     talent = 199086 },  -- Heroic Leap
		{ spellID = 12323,  duration = 30,  type = "other",     spec = {71,72}  },  -- Piercing Howl
		{ spellID = 64382,  duration = 180, type = "other"      },  -- Shattering Throw
		{ spellID = 355,    duration = 8,   type = "other",     talent = 205800 },  -- Taunt
	},
	["PVPTRINKET"] = {
		{ spellID = 336126, duration = 120, type = "pvptrinket",item = 181333,  item2 = 184052  },  -- Sinful Gladiator's Medallion (item2 = Aspirant)
		{ spellID = 336135, duration = 60,  type = "pvptrinket",item = 181816,  item2 = 184054  },  -- Sinful Gladiator's Sigil of Adaptation
		{ spellID = 196029, duration = 0,   type = "pvptrinket",item = 181335,  item2 = 184053  },  -- Sinful Gladiator's Relentless Brooch
		{ spellID = 345231, duration = 120, type = "trinket",   item = 178447,  item2 = 178334  },  -- Sinful Gladiator's Emblem
--      { spellID = 345228, duration = {[175884]=120,default=60},   type = "trinket",   item = 175921,  item2 = 175884  },  -- Sinful Gladiator's Badge of Ferocity
		{ spellID = 345228, duration = 60,  type = "trinket",   item = 175921,  item2 = 175884  },  -- Sinful Gladiator's Badge of Ferocity -- Patch 9.1 aspirant 120>60s
		{ spellID = 356567, duration = 180, type = "trinket",   item = 186980,  },  -- Shackles of Malediction  Unchained Gladiator's Shackles
	},
	["RACIAL"] = {
		{ spellID = 59752,  duration = 180, type = "racial",    race =  1   },  -- Will to Survive
		{ spellID = 20572,  duration = 120, type = "racial",    race =  2   },  -- Blood Fury (Warrior, Hunter, Rogue, Death Knight)
		{ spellID = 20594,  duration = 120, type = "racial",    race =  3   },  -- Stoneform
		{ spellID = 58984,  duration = 120, type = "racial",    race =  4   },  -- Shadowmeld
		{ spellID = 7744,   duration = 120, type = "racial",    race =  5   },  -- Will of the Forsaken
		{ spellID = 20549,  duration = 90,  type = "racial",    race =  6   },  -- War Stomp
		{ spellID = 20589,  duration = 60,  type = "racial",    race =  7   },  -- Escape Artist
		{ spellID = 26297,  duration = 180, type = "racial",    race =  8   },  -- Berserking
		{ spellID = 69070,  duration = 90,  type = "racial",    race =  9   },  -- Rocket Jump
		{ spellID = 129597, duration = 120, type = "racial",    race = 10   },  -- Arcane Torrent (Monk version)
		{ spellID = 59542,  duration = 180, type = "racial",    race = 11   },  -- Gift of the Naaru (Paladin)
		{ spellID = 68992,  duration = 120, type = "racial",    race = 22   },  -- Darkflight
		{ spellID = 107079, duration = 120, type = "racial",    race = {25,26}  },  -- Quaking Palm
		{ spellID = 260364, duration = 180, type = "racial",    race = 27   },  -- Arcane Pulse
		{ spellID = 255654, duration = 120, type = "racial",    race = 28   },  -- Bull Rush
		{ spellID = 256948, duration = 180, type = "racial",    race = 29   },  -- Spatial Rift
		{ spellID = 255647, duration = 150, type = "racial",    race = 30   },  -- Light's Judgment
		{ spellID = 291944, duration = 150, type = "racial",    race = 31   },  -- Regeneratin'
		{ spellID = 287712, duration = 150, type = "racial",    race = 32   },  -- Haymaker
		{ spellID = 265221, duration = 120, type = "racial",    race = 34   },  -- Fireblood
		{ spellID = 312411, duration = 90,  type = "racial",    race = 35   },  -- Bag of Tricks (Vulpera)
		{ spellID = 274738, duration = 120, type = "racial",    race = 36   },  -- Ancestral Call
		{ spellID = 312924, duration = 180, type = "racial",    race = 37   },  -- Hyper Organic Light Originator (Mechagnome)
		{ spellID = 312916, duration = 150, type = "racial",    race = 37   },  -- Emergency Failsafe
	},
	["TRINKET"] = {
		-- BFA
--      { spellID = 313113, duration = 80,  type = "trinket",   item = 173946   },  -- Writhing Segment of Drest'agath
		-- Shadowlands 9.0
--      { spellID = 344384, duration = 120, type = "trinket",   item = 184017   },  -- Bargast's Leash
--      { spellID = 342423, duration = 300, type = "trinket",   item = 178862   },  -- Bladedancer's Armor Kit
		{ spellID = 329840, duration = 120, type = "trinket",   item = 179331   },  -- Blood-Spattered Scale
--      { spellID = 336866, duration = 90,  type = "trinket",   item = 181360,  item2 = 175733  },  -- Brimming Ember Shard
--      { spellID = 311444, duration = 90,  type = "trinket",   item = 173096   },  -- Darkmoon Deck: Indomitable
--      { spellID = 347047, duration = 90,  type = "trinket",   item = 173069   },  -- Darkmoon Deck: Putrescence
--      { spellID = 333734, duration = 90,  type = "trinket",   item = 173078   },  -- Darkmoon Deck: Repose
--      { spellID = 331624, duration = 90,  type = "trinket",   item = 173087   },  -- Darkmoon Deck: Voracity
--      { spellID = 344732, duration = 90,  type = "trinket",   item = 184030   },  -- Dreadfire Vessel
--      { spellID = 345539, duration = 180, type = "trinket",   item = 180117   },  -- Empyreal Ordnance
--      { spellID = 336841, duration = 90,  type = "trinket",   item = 181501   },  -- Flame of Battle
--      { spellID = 339517, duration = 120, type = "trinket",   item = 182451   },  -- Glimmerdust's Grand Design
--      { spellID = 345319, duration = 90,  type = "trinket",   item = 184021   },  -- Glyph of Assimilation
--      { spellID = 345739, duration = 90,  type = "trinket",   item = 178811   },  -- Grim Codex
-- NYI  { spellID = 000000, duration = 180, type = "trinket",   item = 179350   },  -- Inscrutable Quantum Device
--      { spellID = 342432, duration = 120, type = "trinket",   item = 178850   },  -- Lingering Sunmote
--      { spellID = 345432, duration = 90,  type = "trinket",   item = 184024   },  -- Macabre Sheet Music
--      { spellID = 334885, duration = 120, type = "trinket",   item = 180827   },  -- Maldraxxian Warhorn
--      { spellID = 344245, duration = 60,  type = "trinket",   item = 184029   },  -- Manabound Mirror
--      { spellID = 344662, duration = 120, type = "trinket",   item = 184025   },  -- Memory of Past Sins
--      { spellID = 330067, duration = 30,  type = "trinket",   item = 178715   },  -- Mistctrinketer Ocarina
--      { spellID = 180116, duration = 90,  type = "trinket",   item = 180116   },  -- Overcharged Anima Battery
--      { spellID = 343385, duration = 150, type = "trinket",   item = 178849   },  -- Overflowing Anima Prison
--      { spellID = 336465, duration = 150, type = "trinket",   item = 181359,  item2 = 177657  },  -- Overflowing Ember Mirror
--      { spellID = 329831, duration = 90,  type = "trinket",   item = 179342   },  -- Overwhelming Power Crystal
--      { spellID = 343399, duration = 75,  type = "trinket",   item = 178825   },  -- Pulsating Stoneheart
--      { spellID = 344231, duration = 60,  type = "trinket",   item = 184031   },  -- Sanguine Vintage
		-- TODO: Each time a target dies while affected by Shadowgrasp Totem, you are healed for 0 and this cooldown is reduced by 15 sec)
--      { spellID = 331523, duration = 120, type = "trinket",   item = 179356   },  -- Shadowgrasp Totem
--      { spellID = 345549, duration = 30,  type = "trinket",   item = 178783   },  -- Siphoning Phylactery Shard
--      { spellID = 345019, duration = 90,  type = "trinket",   item = 184016   },  -- Skulker's Wing
--      { spellID = 345595, duration = 20,  type = "trinket",   item = 178770   },  -- Slimy Consumptive Organ
--      { spellID = 345251, duration = 60,  type = "trinket",   item = 184019   },  -- Soul Igniter
--      { spellID = 345801, duration = 120, type = "trinket",   item = 178809   },  -- Soulletting Ruby alt: 345502
--      { spellID = 345548, duration = 120, type = "trinket",   item = 178751   },  -- Spare Meat Hook
		{ spellID = 344907, duration = 480, type = "trinket",   item = 184018   },  -- Splintered Heart of Al'ar (passive dummy spell - resets on death)
--      { spellID = 343393, duration = 90,  type = "trinket",   item = 178826   },  -- Sunblood Amethyst
--      { spellID = 336182, duration = 120, type = "trinket",   item = 181357,  item2 = 175732  },  -- Tablet of Despair
--      { spellID = 344916, duration = 120, type = "trinket",   item = 184020   },  -- Tuft of Smoldering Plumage
--      { spellID = 336588, duration = 120, type = "trinket",   item = 181457,  item2 = 183850  },  -- Wakener's Frond
--      { spellID = 345695, duration = 90,  type = "trinket",   item = 178810   },  -- Vial of Spectral Essence
		-- Patch 9.1 new
		{ spellID = 351867, duration = 150, type = "trinket",   item = 185902   },  -- Iron Spikes      Iron Maiden's Toolkit
		{ spellID = 353692, duration = 60,  type = "trinket",   item = 186422   },  -- Studying         Tome of Monstrous Constructions
		{ spellID = 358712, duration = 90,  type = "trinket",   item = 186424   },  -- Annhylde's Aegis Shard of Annhylde's Aegis
		{ spellID = 355318, duration = 60,  type = "trinket",   item = 186425   },  -- Word of Recall   Scrawled Word of Recall
		{ spellID = 355321, duration = 120, type = "trinket",   item = 186428   },  -- Tormented Insight    Shadowed Orb of Torment
		{ spellID = 355327, duration = 90,  type = "trinket",   item = 186431   },  -- Ebonsoul Vise    Ebonsoul Vise
		{ spellID = 355333, duration = 90,  type = "trinket",   item = 186432   },  -- Salvaged Fusion Amplifier    Salvaged Fusion Amplifier
		{ spellID = 355303, duration = 60,  type = "trinket",   item = 186437   },  -- Frostlord's Call Relic of the Frozen Wastes
		{ spellID = 356212, duration = 600, type = "trinket",   item = 186421   },  -- Forbidden Necromancy Forbidden Necromantic Tome
	},
	["COVENANT"] = { -- Signature Ability COVENANT_PREVIEW_RACIAL_ABILITY
		{ spellID = 300728, duration = 60,  type = "covenant",  spec = 321079   },  -- Door of Shadows
		{ spellID = 324631, duration = 120, type = "covenant",  spec = 321078   },  -- Fleshcraft
		{ spellID = 323436, duration = 180, type = "covenant",  spec = 321076   },  -- Purify Soul (3 stacks)
		{ spellID = 310143, duration = 90,  type = "covenant",  spec = 321077   },  -- Soulshape
		{ spellID = 324739, duration = 300, type = "covenant",  spec = 321076   },  -- Summon Steward (-> set 'Phial of Serenity x3 stacks')
		{ spellID = 319217, duration = 600, type = "covenant",  spec = 319217,  buff = 320224   },  -- Podtender (passive dummy spell) - Sync is required
	},
--- ["CONSUMABLE"] = {
---     { spellID = 6262,   duration = 60,  type = "trinket",   },  -- Healthstone
---     { spellID = 307192, duration = 300, type = "trinket",   icon = 3566860  },  -- Spiritual Healing Potion
--- }
}

local iconFix = {
	[200166] = 191427,  -- Metamorphosis
	[193876] = 2825,    -- Shamanism
--  [199086] = 6544,    -- Warpath
}

local buffFix = {
	[51052]  = 145629,  -- AMZ
	[287250] = 196770,  -- Dead of Winter
	[49028]  = 81256,   -- Dancing Rune Weapon
	[198589] = 212800,  -- Blur
	[196718] = 209426,  -- Darkness
	[200166] = 162264,  -- Metamorphosis
	-- Rain from Above (init buff is 206803 for 1s then 206804 until you land -> remove 1s backup timer and replace 206803 for 206804 in _AURA_REMOVED)
	[33891]  = 117679,  -- Incarnation: Tree of Life
	[116011] = 116014,  -- Rune of Power
	[122470] = 125174,  -- Touch of Karma (immunity)
	[342245] = 342246,  -- Alter Time (A)   -- castid 342247 (bluish icon after activating)
	[108978] = 110909,  -- Alter Time (F,F) -- castid 127140
	[228049] = 228050,  -- Guardian of the Forgotten Queen (buff: "Divine Shield", No duration like AOE AMZ) -> 9.1 has duration but delayed
	[62618]  = 81782,   -- Power Word: Barrier (no cleu - check others)
	[197268] = 232707,  -- Ray of Hope
	[1856]   = 11327,   -- Vanish
	[185313] = 185422,  -- Shadow Dance
	[265187] = 265273,  -- Summon Demonic Tyrant (buff - Demonic Power)
	[267217] = 267218,  -- Nether Portal
	[97462]  = 97463,   -- Rallying Cry
	[2565]   = 132404,  -- Shield Block
	[236320] = 236321,  -- War Banner
	[248518] = 248519,  -- Interlope -- NOTE: applied to/from pet 34477/54216 etc is delayed and returns nil duration from GetBuffDuration
	[265221] = 273104,  -- Fireblood
	[274738] = 274740,  -- Ancestral Call   Zeal of the Burning Blade
}

E.buffFixNoCLEU = {
	[125174] = 10,  -- Touch of Karma (immunity)
}

for k, v in pairs(E.spell_db) do
	local n = #v
	for i = n, 1, -1 do
		local t = v[i]
		local id = t.spellID
		local itemID = t.item

		if not C_Spell.DoesSpellExist(id) then
			tremove(v, i)
--          E.Write("Removing Invalid ID: |cffffd200" .. id)
		else
			if k == "TRINKET" then
				t.icon = GetItemIcon(itemID)
			else
				t.icon = t.icon or select(2, GetSpellTexture(iconFix[id] or id))
			end
			t.name = GetSpellInfo(id) or "" -- update spell to item name in mixin (need initial name for sorting)
			t.class = k

			local buff = t.buff or buffFix[id] or id
			if E.L_HIGHLIGHTS[t.type] then
				E.spell_highlighted[buff] = true
			end
			t.buff = buff
		end
	end
end
