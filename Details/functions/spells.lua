do

	local _detalhes = 		_G._detalhes
	
	--import potion list from the framework
	_detalhes.PotionList = {}
	for spellID, _ in pairs (DetailsFramework.PotionIDs) do
		_detalhes.PotionList [spellID] = true
	end

	if (DetailsFramework.IsTBCWow()) then
		_detalhes.SpecSpellList = { --~spec

			-- Balance Druid:
			[33831] 		= 	102, -- force of nature
			[24858] 		= 	102, -- moonkin form

			-- Feral 		Druid:
			[33983] 		= 	103, -- mangle cat
			[33982] 		= 	103, -- mangle cat
			[33876] 		= 	103, -- mangle cat

			-- Guardian Druid:
			[33986] 		= 	104, -- mangle bear
			[33987] 		= 	104, -- mangle bear
			[33878] 		= 	104, -- mangle bear
			
			-- Restoration Druid:
			[33891] 		= 		105, -- tree of life
			[18562] 		= 		105, -- swiftmend

			-- Beast Mastery Hunter:
			[19574]        =       253,    --      bestial wrath
			
			-- Marksmanship Hunter:
			[34490] =       254,    --    silencing shot
			[19506] =       254,    --    trueshot aura
			[20905] =       254,    --    trueshot aura
			[20906] =       254,    --    trueshot aura
			[27066] =       254,    --    trueshot aura
			
			-- Survival Hunter:
			[23989]        =       255,    --   readiness
			[19386]        =       255,    --   wyvern sting
			[24132]        =       255,    --   wyvern sting
			[24133]        =       255,    --   wyvern sting
			[27068]        =       255,    --   wyvern sting

			-- Arcane Mage:
			[31589]        =       62,     --      slow
			[12042]        =       62,     --      arcane power
			[12043]        =       62,     --      presence of mind

			-- Fire Mage:
			[31661]        =       63,     --      dragon's breath
			[33041]        =       63,     --      dragon's breath
			[33042]        =       63,     --      dragon's breath
			[33043]        =       63,     --      dragon's breath
			[28682]        =       63,     --      combustion
			[27133]        =       63,     --      blast wave
			[11113]        =       63,     --      blast wave
			[13018]        =       63,     --      blast wave
			[13019]        =       63,     --      blast wave
			[13020]        =       63,     --      blast wave
			[13021]        =       63,     --      blast wave
			[33933]        =       63,     --      blast wave

			-- Frost Mage:
			[31687]        =       64,     --      summon water elemental
			[11426]        =       64,     --      ice barrier
			[13032]        =       64,     --      ice barrier
			[13033]        =       64,     --      ice barrier
			[27134]        =       64,     --      ice barrier
			[33405]        =       64,     --      ice barrier
			[11958]        =       64,     --      cold snap

			-- Holy Paladin:
			[31842]        =       65,     --      divine illumination
			[20473]        =       65,     --      holy shock
			[20929]        =       65,     --      holy shock
			[20930]        =       65,     --      holy shock
			[27174]        =       65,     --      holy shock
			[33072]        =       65,     --      holy shock

			-- Protection Paladin:
			[31935] =       66,     --      avengers shield
			[32699] =       66,     --      avengers shield
			[32700] =       66,     --      avengers shield
			[20925] =       66,     --      holy shield
			[20927] =       66,     --      holy shield
			[20928] =       66,     --      holy shield
			[27179] =       66,     --      holy shield

			-- Retribution Paladin:
			[35395]        =       70,     --      crusader strike
			[20066]        =       70,     --      repentance

			-- Discipline Priest:
			[33206] =       256,    --      pain suppression
			[10060] =       256,    --      power infusion

			-- Holy Priest:
			[34861]        =       257,    --    circle of healing
			[34863]        =       257,    --    circle of healing
			[34864]        =       257,    --    circle of healing
			[34865]        =       257,    --    circle of healing
			[34866]        =       257,    --    circle of healing
			[724]        =       257,    --    lightwell
			[27870]        =       257,    --    lightwell
			[27871]        =       257,    --    lightwell
			[27875]        =       257,    --    lightwell
			[20711]        =       257,    --    spirit of redemption

			-- Shadow Priest:
			[34914]        =       258,    --      vampiric touch
			[34916]        =       258,    --      vampiric touch
			[34917]        =       258,    --      vampiric touch
			[15473]        =       258,    --      shadowform
			[15286]        =       258,    --      vampiric embrace

			-- Assassination Rogue:
			[1329]        =       259,    --      mutilate
			[34411]        =       259,    --      mutilate
			[34412]        =       259,    --      mutilate
			[34413]        =       259,    --      mutilate

			-- Outlaw (Combat) Rogue:
			[13750]        =       260,    --      adrenaline rush

			-- Subtlety Rogue:
			[36554]        =       261,    --      shadowstep
			[14183]        =       261,    --      premeditation

			-- Elemental Shaman:
			[30706] = 262, -- totem of wrath
			[16166] = 262, -- elemental mastery

			-- Enhancement Shaman:
			[30823] = 263, -- shamanistic rage
			[17364] = 263, -- storm strike

			-- Restoration Shaman:
			[974] = 264, -- earth shield
			[32593] = 264, -- earth shield
			[32594] = 264, -- earth shield
			[16190] = 264, -- mana tide totem

			-- Affliction :
			[30108]        =       265,    --    unstable affliction
			[30404]        =       265,    --    unstable affliction
			[30405]        =       265,    --    unstable affliction
			[18220]			=		265,   --    dark pact
			[18937]			=		265,   --    dark pact
			[18938]			=		265,   --    dark pact
			[27265]			=		265,   --    dark pact

			--  Demonology Warlock:
			[30146]        =       266,    --      summon felguard
			[19028]        =       266,    --      soul link

			--  Destruction Warlock:
			[30283]        =       267,    --      shadowfury
			[30413]        =       267,    --      shadowfury
			[30414]        =       267,    --      shadowfury

			--  Arms Warrior:
			[29623]   =       71,     --      endless rage
			[12294]   =       71,     --      mortal strike
			[30330]   =       71,     --      mortal strike
			[25248]   =       71,     --      mortal strike
			[27580]   =       71,     --      mortal strike
			[21553]   =       71,     --      mortal strike
			[21552]   =       71,     --      mortal strike
			[21551]   =       71,     --      mortal strike

			--  Fury Warrior:
			[30033] =       72,     --  rampage
			[29801] =       72,     --  rampage
			[30030] =       72,     --  rampage
			[23881] =       72,     --  bloodthirst
			[23892] =       72,     --  bloodthirst
			[23893] =       72,     --  bloodthirst
			[23894] =       72,     --  bloodthirst
			[25251] =       72,     --  bloodthirst
			[30335] =       72,     --  bloodthirst

			--  Protection Warrior:
			[20243]        =       73,     --     devastate
			[30022]        =       73,     --     devastate
			[30016]        =       73,     --     devastate
			[23922]        =       73,     --     shield slam
			[23923]        =       73,     --     shield slam
			[23924]        =       73,     --     shield slam
			[23925]        =       73,     --     shield slam
			[25258]        =       73,     --     shield slam
			[30356]        =       73,     --     shield slam
		}

	else
		_detalhes.SpecSpellList = { --~spec

		-- havoc demon hunter --577
		[188499]        =       577,    --      Blade Dance
		[320402]        =       577,    --      Blade Dance
		[203550]        =       577,    --      Blind Fury
		[198589]        =       577,    --      Blur
		[320407]        =       577,    --      Blur
		[320374]        =       577,    --      Burning Hatred
		[179057]        =       577,    --      Chaos Nova
		[320412]        =       577,    --      Chaos Nova
		[162794]        =       577,    --      Chaos Strike
		[197125]        =       577,    --      Chaos Strike
		[320413]        =       577,    --      Chaos Strike
		[343206]        =       577,    --      Chaos Strike
		[258887]        =       577,    --      Cycle of Hatred
		[196718]        =       577,    --      Darkness
		[320420]        =       577,    --      Darkness
		[203555]        =       577,    --      Demon Blades
		[162243]        =       577,    --      Demon's Bite
		[206478]        =       577,    --      Demonic Appetite
		[205411]        =       577,    --      Desperate Instincts
		[258860]        =       577,    --      Essence Break
		[198013]        =       577,    --      Eye Beam
		[320415]        =       577,    --      Eye Beam
		[258925]        =       577,    --      Fel Barrage
		[211881]        =       577,    --      Fel Eruption
		[195072]        =       577,    --      Fel Rush
		[320416]        =       577,    --      Fel Rush
		[343017]        =       577,    --      Fel Rush
		[206416]        =       577,    --      First Blood
		[342817]        =       577,    --      Glaive Tempest
		[258876]        =       577,    --      Insatiable Hunger
		[203556]        =       577,    --      Master of the Glaive
		[206476]        =       577,    --      Momentum
		[196555]        =       577,    --      Netherwalk
		[258881]        =       577,    --      Trail of Ruin
		[275144]        =       577,    --      Unbound Chaos
		[206477]        =       577,    --      Unleashed Power
		[198793]        =       577,    --      Vengeful Retreat
		[320635]        =       577,    --      Vengeful Retreat

		-- vengeance demon hunter --581
		[207550]        =       581,    --      Abyssal Strike
		[207548]        =       581,    --      Agonizing Flames
		[320341]        =       581,    --      Bulk Extraction
		[207739]        =       581,    --      Burning Alive
		[336639]        =       581,    --      Charred Flesh
		[207666]        =       581,    --      Concentrated Sigils
		[203720]        =       581,    --      Demon Spikes
		[321028]        =       581,    --      Demon Spikes
		[227174]        =       581,    --      Fallout
		[207697]        =       581,    --      Feast of Souls
		[218612]        =       581,    --      Feed the Demon
		[212084]        =       581,    --      Fel Devastation
		[320639]        =       581,    --      Fel Devastation
		[204021]        =       581,    --      Fiery Brand
		[320962]        =       581,    --      Fiery Brand
		[343010]        =       581,    --      Fiery Brand
		[263642]        =       581,    --      Fracture
		[320331]        =       581,    --      Infernal Armor
		[189110]        =       581,    --      Infernal Strike
		[320791]        =       581,    --      Infernal Strike
		[343016]        =       581,    --      Infernal Strike
		[209258]        =       581,    --      Last Resort
		[209281]        =       581,    --      Quickened Sigils
		[343014]        =       581,    --      Revel in Pain
		[326853]        =       581,    --      Ruinous Bulwark
		[203782]        =       581,    --      Shear
		[203783]        =       581,    --      Shear
		[202138]        =       581,    --      Sigil of Chains
		[204596]        =       581,    --      Sigil of Flame
		[320794]        =       581,    --      Sigil of Flame
		[207684]        =       581,    --      Sigil of Misery
		[320418]        =       581,    --      Sigil of Misery
		[202137]        =       581,    --      Sigil of Silence
		[320417]        =       581,    --      Sigil of Silence
		[263648]        =       581,    --      Soul Barrier
		[228477]        =       581,    --      Soul Cleave
		[321021]        =       581,    --      Soul Cleave
		[343207]        =       581,    --      Soul Cleave
		[247454]        =       581,    --      Spirit Bomb
		[320380]        =       581,    --      Thick Skin
		[268175]        =       581,    --      Void Reaver

		-- Unholy Death Knight:
		[194916]        =       252,    --      All Will Serve
		[275699]        =       252,    --      Apocalypse
		[316961]        =       252,    --      Apocalypse
		[343755]        =       252,    --      Apocalypse
		[276837]        =       252,    --      Army of the Damned
		[42650] =       252,    --      Army of the Dead
		[207264]        =       252,    --      Bursting Sores
		[207311]        =       252,    --      Clawing Shadows
		[325554]        =       252,    --      Dark Transformation
		[63560] =       252,    --      Dark Transformation
		[152280]        =       252,    --      Defile
		[207269]        =       252,    --      Ebon Fever
		[207317]        =       252,    --      Epidemic
		[276023]        =       252,    --      Harbinger of Doom
		[207272]        =       252,    --      Infected Claws
		[77575] =       252,    --      Outbreak
		[277234]        =       252,    --      Pestilence
		[194917]        =       252,    --      Pestilent Pustules
		[51462] =       252,    --      Runic Corruption
		[317234]        =       252,    --      Scourge Strike
		[55090] =       252,    --      Scourge Strike
		[343294]        =       252,    --      Soul Reaper
		[207321]        =       252,    --      Spell Eater
		[49530] =       252,    --      Sudden Doom
		[317250]        =       252,    --      Summon Gargoyle
		[49206] =       252,    --      Summon Gargoyle
		[207289]        =       252,    --      Unholy Assault
		[115989]        =       252,    --      Unholy Blight
		[319230]        =       252,    --      Unholy Pact
		
		-- Frost Death Knight:
		[207142]        =       251,    --      Avalanche
		[207167]        =       251,    --      Blinding Sleet
		[152279]        =       251,    --      Breath of Sindragosa
		[281208]        =       251,    --      Cold Heart
		[317230]        =       251,    --      Empower Rune Weapon
		[47568] =       251,    --      Empower Rune Weapon
		[316803]        =       251,    --      Frost Strike
		[49143] =       251,    --      Frost Strike
		[207230]        =       251,    --      Frostscythe
		[279302]        =       251,    --      Frostwyrm's Fury
		[194909]        =       251,    --      Frozen Pulse
		[194912]        =       251,    --      Gathering Storm
		[194913]        =       251,    --      Glacial Advance
		[57330] =       251,    --      Horn of Winter
		[49184] =       251,    --      Howling Blast
		[321995]        =       251,    --      Hypothermic Presence
		[207126]        =       251,    --      Icecap
		[194878]        =       251,    --      Icy Talons
		[253593]        =       251,    --      Inexorable Assault
		[317214]        =       251,    --      Killing Machine
		[51128] =       251,    --      Killing Machine
		[343252]        =       251,    --      Might of the Frozen Wastes
		[81333] =       251,    --      Might of the Frozen Wastes
		[207061]        =       251,    --      Murderous Efficiency
		[317198]        =       251,    --      Obliterate
		[49020] =       251,    --      Obliterate
		[281238]        =       251,    --      Obliteration
		[207200]        =       251,    --      Permafrost
		[316849]        =       251,    --      Pillar of Frost
		[51271] =       251,    --      Pillar of Frost
		[196770]        =       251,    --      Remorseless Winter
		[316794]        =       251,    --      Remorseless Winter
		[316838]        =       251,    --      Rime
		[59057] =       251,    --      Rime
		[207104]        =       251,    --      Runic Attenuation
		[81229] =       251,    --      Runic Empowerment
		
		-- Blood Death Knight:
		[205727]        =       250,    --      Anti-Magic Barrier
		[316634]        =       250,    --      Blood Boil
		[50842] =       250,    --      Blood Boil
		[221699]        =       250,    --      Blood Tap
		[206931]        =       250,    --      Blooddrinker
		[195679]        =       250,    --      Bloodworms
		[194844]        =       250,    --      Bonestorm
		[205224]        =       250,    --      Consumption
		[274156]        =       250,    --      Consumption
		[81136] =       250,    --      Crimson Scourge
		[49028] =       250,    --      Dancing Rune Weapon
		[195292]        =       250,    --      Death's Caress
		[206974]        =       250,    --      Foul Bulwark
		[108199]        =       250,    --      Gorefiend's Grasp
		[206930]        =       250,    --      Heart Strike
		[316575]        =       250,    --      Heart Strike
		[317090]        =       250,    --      Heart Strike
		[221536]        =       250,    --      Heartbreaker
		[273946]        =       250,    --      Hemostasis
		[206940]        =       250,    --      Mark of Blood
		[195182]        =       250,    --      Marrowrend
		[316746]        =       250,    --      Marrowrend
		[219786]        =       250,    --      Ossuary
		[114556]        =       250,    --      Purgatory
		[194662]        =       250,    --      Rapid Decomposition
		[205723]        =       250,    --      Red Thirst
		[317610]        =       250,    --      Relish in Blood
		[194679]        =       250,    --      Rune Tap
		[316616]        =       250,    --      Rune Tap
		[206970]        =       250,    --      Tightening Grasp
		[219809]        =       250,    --      Tombstone
		[317133]        =       250,    --      Vampiric Blood
		[55233] =       250,    --      Vampiric Blood
		[273953]        =       250,    --      Voracious
		[206967]        =       250,    --      Will of the Necropolis

		
		-- Balance Druid:
		[236168] 		= 	102, -- Starfall
		[136060] 		= 	102, -- Celestial Alignment
		[252188] 		= 	102, -- Solar Beam
		[631519] 		= 	102, -- Shooting Stars
		[132123] 		= 	102, -- Fury of Elune

		-- Feral 		Druid:
		[132185] 		= 	103, -- Predatory Swiftness
		[132242] 		= 	103, -- Tiger's Fury
		[132278] 		= 	103, -- Primal Fury
		[132141] 		= 	103, -- Brutal Slash

		-- Guardian Druid:
		[571585] 		= 	104, -- Gore
		[1033479] 		= 	104, -- Guardian of Elune
		[1033490] 		= 	104, -- Pulverize
		[132139] 		= 	104, -- Blood Frenzy
		[571586] 		= 	104, -- Incarnation: Guardian of Ursoc
		
		-- Restoration Druid:
		[740] 		= 		105, -- Tranquility
		[102342] 		= 	105, -- Ironbark
		[33763] 		= 	105, -- Lifebloom
		[88423] 		= 	105, -- Nature's Cure
		[145205] 		= 	105, --Efflorescence

		-- Beast Mastery Hunter:
		[267116]        =       253,    --      Animal Companion
		[191384]        =       253,    --      Aspect of the Beast
		[193530]        =       253,    --      Aspect of the Wild
		[217200]        =       253,    --      Barbed Shot
		[115939]        =       253,    --      Beast Cleave
		[19574] =       253,    --      Bestial Wrath
		[231548]        =       253,    --      Bestial Wrath
		[321530]        =       253,    --      Bloodshed
		[193455]        =       253,    --      Cobra Shot
		[262838]        =       253,    --      Cobra Shot
		[120679]        =       253,    --      Dire Beast
		[53270] =       253,    --      Exotic Beasts
		[199532]        =       253,    --      Killer Cobra
		[273887]        =       253,    --      Killer Instinct
		[56315] =       253,    --      Kindred Spirits
		[199528]        =       253,    --      One with the Pack
		[321014]        =       253,    --      Pack Tactics
		[193532]        =       253,    --      Scent of Blood
		[285564]        =       253,    --      Scent of Blood
		[257891]        =       253,    --      Spitting Cobra
		[201430]        =       253,    --      Stampede
		[199530]        =       253,    --      Stomp
		[257944]        =       253,    --      Thrill of the Hunt
		[185789]        =       253,    --      Wild Call
		
		-- Marksmanship Hunter:
		[19434] =       254,    --      Aimed Shot
		[321468]        =       254,    --      Binding Shackles
		[186387]        =       254,    --      Bursting Shot
		[260404]        =       254,    --      Calling the Shots
		[260228]        =       254,    --      Careful Aim
		[321460]        =       254,    --      Dead Eye
		[260402]        =       254,    --      Double Tap
		[212431]        =       254,    --      Explosive Shot
		[260393]        =       254,    --      Lethal Shots
		[194595]        =       254,    --      Lock and Load
		[155228]        =       254,    --      Lone Wolf
		[260309]        =       254,    --      Master Marksman
		[260240]        =       254,    --      Precise Shots
		[257044]        =       254,    --      Rapid Fire
		[321281]        =       254,    --      Rapid Fire
		[193533]        =       254,    --      Steady Focus
		[260367]        =       254,    --      Streamline
		[257621]        =       254,    --      Trick Shots
		[288613]        =       254,    --      Trueshot
		[260243]        =       254,    --      Volley
		[260247]        =       254,    --      Volley
		
		-- Survival Hunter:
		[269737]        =       255,    --      Alpha Predator
		[186289]        =       255,    --      Aspect of the Eagle
		[260331]        =       255,    --      Birds of Prey
		[260248]        =       255,    --      Bloodseeker
		[212436]        =       255,    --      Butchery
		[187708]        =       255,    --      Carve
		[294029]        =       255,    --      Carve
		[259391]        =       255,    --      Chakrams
		[259398]        =       255,    --      Chakrams
		[272651]        =       255,    --      Command Pet
		[266779]        =       255,    --      Coordinated Assault
		[269751]        =       255,    --      Flanking Strike
		[190925]        =       255,    --      Harpoon
		[231550]        =       255,    --      Harpoon
		[260241]        =       255,    --      Hydra's Bite
		[259387]        =       255,    --      Mongoose Bite
		[187707]        =       255,    --      Muzzle
		[186270]        =       255,    --      Raptor Strike
		[162487]        =       255,    --      Steel Trap
		[162488]        =       255,    --      Steel Trap
		[265895]        =       255,    --      Terms of Engagement
		[260285]        =       255,    --      Tip of the Spear
		[268501]        =       255,    --      Viper's Venom
		[259495]        =       255,    --      Wildfire Bomb
		[271014]        =       255,    --      Wildfire Infusion
		[195645]        =       255,    --      Wing Clip
		[321026]        =       255,    --      Wing Clip
		
		-- Arcane Mage:
		[231564]        =       62,     --      Arcane Barrage
		[321526]        =       62,     --      Arcane Barrage
		[44425] =       62,     --      Arcane Barrage
		[30451] =       62,     --      Arcane Blast
		[342231]        =       62,     --      Arcane Echo
		[205022]        =       62,     --      Arcane Familiar
		[5143]  =       62,     --      Arcane Missiles
		[7268]  =       62,     --      Arcane Missiles
		[153626]        =       62,     --      Arcane Orb
		[12042] =       62,     --      Arcane Power
		[321739]        =       62,     --      Arcane Power
		[343208]        =       62,     --      Arcane Power
		[235711]        =       62,     --      Chrono Shift
		[16870] =       62,     --      Clearcasting
		[321420]        =       62,     --      Clearcasting
		[321758]        =       62,     --      Clearcasting
		[321387]        =       62,     --      Enlightened
		[12051] =       62,     --      Evocation
		[231565]        =       62,     --      Evocation
		[110959]        =       62,     --      Greater Invisibility
		[342249]        =       62,     --      Master of Time
		[114923]        =       62,     --      Nether Tempest
		[114954]        =       62,     --      Nether Tempest
		[155147]        =       62,     --      Overpowered
		[205025]        =       62,     --      Presence of Mind
		[321742]        =       62,     --      Presence of Mind
		[235450]        =       62,     --      Prismatic Barrier
		[321745]        =       62,     --      Prismatic Barrier
		[205028]        =       62,     --      Resonance
		[281482]        =       62,     --      Reverberate
		[264354]        =       62,     --      Rule of Threes
		[236457]        =       62,     --      Slipstream
		[31589] =       62,     --      Slow
		[321747]        =       62,     --      Slow
		[157980]        =       62,     --      Supernova
		[210805]        =       62,     --      Time Anomaly
		[321507]        =       62,     --      Touch of the Magi
		[343215]        =       62,     --      Touch of the Magi
		
		-- Fire Mage:
		[235870]        =       63,     --      Alexstrasza's Fury
		[157981]        =       63,     --      Blast Wave
		[235313]        =       63,     --      Blazing Barrier
		[321708]        =       63,     --      Blazing Barrier
		[235365]        =       63,     --      Blazing Soul
		[86949] =       63,     --      Cauterize
		[190319]        =       63,     --      Combustion
		[321710]        =       63,     --      Combustion
		[205023]        =       63,     --      Conflagration
		[117216]        =       63,     --      Critical Mass
		[231630]        =       63,     --      Critical Mass
		[321707]        =       63,     --      Dragon's Breath
		[133]   =       63,     --      Fireball
		[157642]        =       63,     --      Fireball
		[343194]        =       63,     --      Fireball
		[203283]        =       63,     --      Firestarter
		[205026]        =       63,     --      Firestarter
		[205029]        =       63,     --      Flame On
		[205037]        =       63,     --      Flame Patch
		[2120]  =       63,     --      Flamestrike
		[321709]        =       63,     --      Flamestrike
		[343230]        =       63,     --      Flamestrike
		[236058]        =       63,     --      Frenetic Speed
		[342344]        =       63,     --      From the Ashes
		[195283]        =       63,     --      Hot Streak
		[155148]        =       63,     --      Kindling
		[44457] =       63,     --      Living Bomb
		[44461] =       63,     --      Living Bomb
		[153561]        =       63,     --      Meteor
		[257541]        =       63,     --      Phoenix Flames
		[343222]        =       63,     --      Phoenix Flames
		[321711]        =       63,     --      Pyroblast
		[269650]        =       63,     --      Pyroclasm
		[205020]        =       63,     --      Pyromaniac
		[2948]  =       63,     --      Scorch
		[269644]        =       63,     --      Searing Touch
		
		-- Frost Mage:
		[190356]        =       64,     --      Blizzard
		[321696]        =       64,     --      Blizzard
		[205027]        =       64,     --      Bone Chilling
		[190447]        =       64,     --      Brain Freeze
		[231584]        =       64,     --      Brain Freeze
		[278309]        =       64,     --      Chain Reaction
		[235219]        =       64,     --      Cold Snap
		[321699]        =       64,     --      Cold Snap
		[153595]        =       64,     --      Comet Storm
		[120]   =       64,     --      Cone of Cold
		[343180]        =       64,     --      Cone of Cold
		[257537]        =       64,     --      Ebonbolt
		[112965]        =       64,     --      Fingers of Frost
		[44614] =       64,     --      Flurry
		[270233]        =       64,     --      Freezing Rain
		[235224]        =       64,     --      Frigid Winds
		[84714] =       64,     --      Frozen Orb
		[84721] =       64,     --      Frozen Orb
		[205030]        =       64,     --      Frozen Touch
		[235297]        =       64,     --      Glacial Insulation
		[199786]        =       64,     --      Glacial Spike
		[11426] =       64,     --      Ice Barrier
		[108839]        =       64,     --      Ice Floes
		[30455] =       64,     --      Ice Lance
		[343175]        =       64,     --      Ice Lance
		[157997]        =       64,     --      Ice Nova
		[12472] =       64,     --      Icy Veins
		[321702]        =       64,     --      Icy Veins
		[205024]        =       64,     --      Lonely Winter
		[205021]        =       64,     --      Ray of Frost
		[12982] =       64,     --      Shatter
		[231582]        =       64,     --      Shatter
		[31687] =       64,     --      Summon Water Elemental
		[155149]        =       64,     --      Thermal Void

		-- Brewmaster Monk:
		[115399]        =       268,    --      Black Ox Brew
		[196736]        =       268,    --      Blackout Combo
		[280515]        =       268,    --      Bob and Weave
		[115181]        =       268,    --      Breath of Fire
		[123725]        =       268,    --      Breath of Fire
		[245013]        =       268,    --      Brewmaster's Balance
		[322507]        =       268,    --      Celestial Brew
		[322510]        =       268,    --      Celestial Brew
		[325177]        =       268,    --      Celestial Flames
		[216519]        =       268,    --      Celestial Fortune
		[324312]        =       268,    --      Clash
		[325153]        =       268,    --      Exploding Keg
		[124502]        =       268,    --      Gift of the Ox
		[124507]        =       268,    --      Gift of the Ox
		[196737]        =       268,    --      High Tolerance
		[121253]        =       268,    --      Keg Smash
		[325093]        =       268,    --      Light Brewing
		[119582]        =       268,    --      Purifying Brew
		[343743]        =       268,    --      Purifying Brew
		[322120]        =       268,    --      Shuffle
		[196730]        =       268,    --      Special Delivery
		[242580]        =       268,    --      Spitfire
		[115069]        =       268,    --      Stagger
		[322522]        =       268,    --      Stagger
		[115315]        =       268,    --      Summon Black Ox Statue
		[115176]        =       268,    --      Zen Meditation
		[328682]        =       268,    --      Zen Meditation


		-- Windwalker Monk:
		[116092]        =       269,    --      Afterlife
		[196707]        =       269,    --      Afterlife
		[322719]        =       269,    --      Afterlife
		[115396]        =       269,    --      Ascension
		[161862]        =       269,    --      Ascension
		[325201]        =       269,    --      Dance of Chi-Ji
		[116095]        =       269,    --      Disable
		[343731]        =       269,    --      Disable
		[115288]        =       269,    --      Energizing Elixir
		[261947]        =       269,    --      Fist of the White Tiger
		[113656]        =       269,    --      Fists of Fury
		[117418]        =       269,    --      Fists of Fury
		[101545]        =       269,    --      Flying Serpent Kick
		[123586]        =       269,    --      Flying Serpent Kick
		[280195]        =       269,    --      Good Karma
		[196740]        =       269,    --      Hit Combo
		[261767]        =       269,    --      Inner Strength
		[152173]        =       269,    --      Serenity
		[280197]        =       269,    --      Spiritual Focus
		[122470]        =       269,    --      Touch of Karma
		[124280]        =       269,    --      Touch of Karma
		[152175]        =       269,    --      Whirling Dragon Punch
		[157411]        =       269,    --      Windwalking
		
		-- Mistweaver Monk:
		[343655]        =       270,    --      Enveloping Breath
		[124682]        =       270,    --      Enveloping Mist
		[231605]        =       270,    --      Enveloping Mist
		[191837]        =       270,    --      Essence Font
		[231633]        =       270,    --      Essence Font
		[197895]        =       270,    --      Focused Thunder
		[116849]        =       270,    --      Life Cocoon
		[197915]        =       270,    --      Lifecycles
		[197908]        =       270,    --      Mana Tea
		[197900]        =       270,    --      Mist Wrap
		[212051]        =       270,    --      Reawaken
		[196725]        =       270,    --      Refreshing Jade Wind
		[115151]        =       270,    --      Renewing Mist
		[119611]        =       270,    --      Renewing Mist
		[281231]        =       270,    --      Renewing Mist
		[115310]        =       270,    --      Revival
		[274909]        =       270,    --      Rising Mist
		[198898]        =       270,    --      Song of Chi-Ji
		[115175]        =       270,    --      Soothing Mist
		[209525]        =       270,    --      Soothing Mist
		[210802]        =       270,    --      Spirit of the Crane
		[115313]        =       270,    --      Summon Jade Serpent Statue
		[116645]        =       270,    --      Teachings of the Monastery
		[116680]        =       270,    --      Thunder Focus Tea
		[231876]        =       270,    --      Thunder Focus Tea
		[274963]        =       270,    --      Upwelling
		
		-- Holy Paladin:
		[212056]        =       65,     --      Absolution
		[31821] =       65,     --      Aura Mastery
		[248033]        =       65,     --      Awakening
		[156910]        =       65,     --      Beacon of Faith
		[53563] =       65,     --      Beacon of Light
		[53652] =       65,     --      Beacon of Light
		[200025]        =       65,     --      Beacon of Virtue
		[223306]        =       65,     --      Bestow Faith
		[4987]  =       65,     --      Cleanse
		[196926]        =       65,     --      Crusader's Might
		[498]   =       65,     --      Divine Protection
		[325966]        =       65,     --      Glimmer of Light
		[82326] =       65,     --      Holy Light
		[114165]        =       65,     --      Holy Prism
		[114852]        =       65,     --      Holy Prism
		[114871]        =       65,     --      Holy Prism
		[20473] =       65,     --      Holy Shock
		[25912] =       65,     --      Holy Shock
		[25914] =       65,     --      Holy Shock
		[272906]        =       65,     --      Holy Shock
		[289941]        =       65,     --      Holy Shock
		[53576] =       65,     --      Infusion of Light
		[85222] =       65,     --      Light of Dawn
		[183998]        =       65,     --      Light of the Martyr
		[219562]        =       65,     --      Light of the Martyr
		[114158]        =       65,     --      Light's Hammer
		[114919]        =       65,     --      Light's Hammer
		[214202]        =       65,     --      Rule of Law
		[157047]        =       65,     --      Saved by the Light

		
		-- Protection Paladin:
		[31850] =       66,     --      Ardent Defender
		[66235] =       66,     --      Ardent Defender
		[231665]        =       66,     --      Avenger's Shield
		[31935] =       66,     --      Avenger's Shield
		[337261]        =       66,     --      Avenger's Shield
		[204019]        =       66,     --      Blessed Hammer
		[229976]        =       66,     --      Blessed Hammer
		[204018]        =       66,     --      Blessing of Spellwarding
		[204023]        =       66,     --      Crusader's Judgment
		[204077]        =       66,     --      Final Stand
		[203776]        =       66,     --      First Avenger
		[85043] =       66,     --      Grand Crusader
		[86659] =       66,     --      Guardian of Ancient Kings
		[317854]        =       66,     --      Hammer of the Righteous
		[337287]        =       66,     --      Hammer of the Righteous
		[53595] =       66,     --      Hammer of the Righteous
		[315924]        =       66,     --      Hand of the Protector
		[327193]        =       66,     --      Moment of Glory
		[280373]        =       66,     --      Redoubt
		[204074]        =       66,     --      Righteous Protector
		[161800]        =       66,     --      Riposte
		[321136]        =       66,     --      Shining Light

		
		-- Retribution Paladin:
		[267344]        =       70,     --      Art of War
		[317912]        =       70,     --      Art of War
		[184575]        =       70,     --      Blade of Justice
		[327981]        =       70,     --      Blade of Justice
		[231832]        =       70,     --      Blade of Wrath
		[231895]        =       70,     --      Crusade
		[53385] =       70,     --      Divine Storm
		[326732]        =       70,     --      Empyrean Power
		[343527]        =       70,     --      Execution Sentence
		[343721]        =       70,     --      Final Reckoning
		[203316]        =       70,     --      Fires of Justice
		[183218]        =       70,     --      Hand of Hindrance
		[215661]        =       70,     --      Justicar's Vengeance
		[267610]        =       70,     --      Righteous Verdict
		[85256] =       70,     --      Templar's Verdict
		[255937]        =       70,     --      Wake of Ashes
		[269569]        =       70,     --      Zeal


		-- Discipline Priest:
		[81749] =       256,    --      Atonement
		[193134]        =       256,    --      Castigation
		[197419]        =       256,    --      Contrition
		[205367]        =       256,    --      Dominant Mind
		[246287]        =       256,    --      Evangelism
		[238063]        =       256,    --      Lenience
		[193063]        =       256,    --      Masochism
		[33206] =       256,    --      Pain Suppression
		[47540] =       256,    --      Penance
		[47666] =       256,    --      Penance
		[47750] =       256,    --      Penance
		[198068]        =       256,    --      Power of the Dark Side
		[204197]        =       256,    --      Purge the Wicked
		[47536] =       256,    --      Rapture
		[214621]        =       256,    --      Schism
		[314867]        =       256,    --      Shadow Covenant
		[197045]        =       256,    --      Shield Discipline
		[280391]        =       256,    --      Sins of the Many
		[109964]        =       256,    --      Spirit Shell
		
		-- Holy Priest:
		[116092]        =       257,    --      Afterlife
		[196707]        =       257,    --      Afterlife
		[322719]        =       257,    --      Afterlife
		[238100]        =       257,    --      Angel's Mercy
		[200183]        =       257,    --      Apotheosis
		[193157]        =       257,    --      Benediction
		[32546] =       257,    --      Binding Heal
		[200199]        =       257,    --      Censure
		[204883]        =       257,    --      Circle of Healing
		[238136]        =       257,    --      Cosmic Ripple
		[64843] =       257,    --      Divine Hymn
		[193155]        =       257,    --      Enlightenment
		[2061]  =       257,    --      Flash Heal
		[200209]        =       257,    --      Guardian Angel
		[47788] =       257,    --      Guardian Spirit
		[2060]  =       257,    --      Heal
		[14914] =       257,    --      Holy Fire
		[196985]        =       257,    --      Light of the Naaru
		[321377]        =       257,    --      Prayer Circle
		[596]   =       257,    --      Prayer of Healing
		[319912]        =       257,    --      Prayer of Mending
		[33076] =       257,    --      Prayer of Mending
		[33110] =       257,    --      Prayer of Mending
		[139]   =       257,    --      Renew
		[341997]        =       257,    --      Renewed Faith
		[20711] =       257,    --      Spirit of Redemption
		[215769]        =       257,    --      Spirit of Redemption
		[109186]        =       257,    --      Surge of Light
		[64901] =       257,    --      Symbol of Hope
		[200128]        =       257,    --      Trail of Light

		-- Shadow Priest:
		[341240]        =       258,    --      Ancient Madness
		[341374]        =       258,    --      Damnation
		[341205]        =       258,    --      Dark Thoughts
		[321291]        =       258,    --      Death and Madness
		[335467]        =       258,    --      Devouring Plague
		[322108]        =       258,    --      Dispersion
		[193195]        =       258,    --      Fortress of the Mind
		[280752]        =       258,    --      Hallucinations
		[288733]        =       258,    --      Intangibility
		[263716]        =       258,    --      Last Word
		[193225]        =       258,    --      Legacy of the Void
		[205369]        =       258,    --      Mind Bomb
		[15407] =       258,    --      Mind Flay
		[238558]        =       258,    --      Misery
		[64044] =       258,    --      Psychic Horror
		[213634]        =       258,    --      Purify Disease
		[199855]        =       258,    --      San'layn
		[341385]        =       258,    --      Searing Nightmare
		[342834]        =       258,    --      Shadow Crash
		[232698]        =       258,    --      Shadowform
		[341491]        =       258,    --      Shadowy Apparitions
		[78203] =       258,    --      Shadowy Apparitions
		[15487] =       258,    --      Silence
		[319952]        =       258,    --      Surrender to Madness
		[341273]        =       258,    --      Unfurling Darkness
		[322110]        =       258,    --      Vampiric Embrace
		[322116]        =       258,    --      Vampiric Touch
		[34914] =       258,    --      Vampiric Touch
		[228266]        =       258,    --      Void Bolt
		[231688]        =       258,    --      Void Bolt
		[319914]        =       258,    --      Void Bolt
		[228260]        =       258,    --      Void Eruption
		[319908]        =       258,    --      Void Eruption
		[263165]        =       258,    --      Void Torrent
		[185916]        =       258,    --      Voidform
		[228264]        =       258,    --      Voidform
		
		-- Assassination Rogue:
		[328085]        =       259,    --      Blindside
		[121411]        =       259,    --      Crimson Tempest
		[193640]        =       259,    --      Elaborate Planning
		[32645] =       259,    --      Envenom
		[200806]        =       259,    --      Exsanguinate
		[51723] =       259,    --      Fan of Knives
		[231719]        =       259,    --      Garrote
		[703]   =       259,    --      Garrote
		[270061]        =       259,    --      Hidden Blades
		[14117] =       259,    --      Improved Poisons
		[330542]        =       259,    --      Improved Poisons
		[154904]        =       259,    --      Internal Bleeding
		[196861]        =       259,    --      Iron Wire
		[280716]        =       259,    --      Leeching Poison
		[255989]        =       259,    --      Master Assassin
		[196864]        =       259,    --      Master Poisoner
		[1329]  =       259,    --      Mutilate
		[27576] =       259,    --      Mutilate
		[5374]  =       259,    --      Mutilate
		[255544]        =       259,    --      Poison Bomb
		[185565]        =       259,    --      Poisoned Knife
		[14190] =       259,    --      Seal Fate
		[319568]        =       259,    --      Vendetta
		[79140] =       259,    --      Vendetta
		[152152]        =       259,    --      Venom Rush
		[79134] =       259,    --      Venomous Wounds

		-- Outlaw Rogue:
		[196924]        =       260,    --      Acrobatic Strikes
		[13750] =       260,    --      Adrenaline Rush
		[235484]        =       260,    --      Between the Eyes
		[315341]        =       260,    --      Between the Eyes
		[13877] =       260,    --      Blade Flurry
		[22482] =       260,    --      Blade Flurry
		[331851]        =       260,    --      Blade Flurry
		[271877]        =       260,    --      Blade Rush
		[256165]        =       260,    --      Blinding Powder
		[35551] =       260,    --      Combat Potency
		[61329] =       260,    --      Combat Potency
		[272026]        =       260,    --      Dancing Steel
		[108216]        =       260,    --      Dirty Tricks
		[2098]  =       260,    --      Dispatch
		[343142]        =       260,    --      Dreadblades
		[196937]        =       260,    --      Ghostly Strike
		[1776]  =       260,    --      Gouge
		[195457]        =       260,    --      Grappling Hook
		[319600]        =       260,    --      Grappling Hook
		[196922]        =       260,    --      Hit and Run
		[193546]        =       260,    --      Iron Stomach
		[51690] =       260,    --      Killing Spree
		[256170]        =       260,    --      Loaded Dice
		[185763]        =       260,    --      Pistol Shot
		[196938]        =       260,    --      Quick Draw
		[79096] =       260,    --      Restless Blades
		[256188]        =       260,    --      Retractable Hook
		[315508]        =       260,    --      Roll the Bones
		[14161] =       260,    --      Ruthlessness
		[1752]  =       260,    --      Sinister Strike
		[193315]        =       260,    --      Sinister Strike
		[279876]        =       260,    --      Sinister Strike
		[279877]        =       260,    --      Sinister Strike

		-- Subtlety Rogue:
		[319949]        =       261,    --      Backstab
		[53]    =       261,    --      Backstab
		[245687]        =       261,    --      Dark Shadow
		[185314]        =       261,    --      Deepening Shadows
		[238104]        =       261,    --      Enveloping Shadows
		[196819]        =       261,    --      Eviscerate
		[231716]        =       261,    --      Eviscerate
		[316219]        =       261,    --      Find Weakness
		[200758]        =       261,    --      Gloomblade
		[196976]        =       261,    --      Master of Shadows
		[277953]        =       261,    --      Night Terrors
		[343160]        =       261,    --      Premeditation
		[58423] =       261,    --      Relentless Strikes
		[280719]        =       261,    --      Secret Technique
		[121471]        =       261,    --      Shadow Blades
		[185313]        =       261,    --      Shadow Dance
		[108209]        =       261,    --      Shadow Focus
		[196912]        =       261,    --      Shadow Techniques
		[319706]        =       261,    --      Shadow Techniques
		[319175]        =       261,    --      Shadow Vault
		[319178]        =       261,    --      Shadow Vault
		[185438]        =       261,    --      Shadowstrike
		[231718]        =       261,    --      Shadowstrike
		[257505]        =       261,    --      Shot in the Dark
		[197835]        =       261,    --      Shuriken Storm
		[319951]        =       261,    --      Shuriken Storm
		[277925]        =       261,    --      Shuriken Tornado
		[114014]        =       261,    --      Shuriken Toss
		[200759]        =       261,    --      Soothing Darkness
		[212283]        =       261,    --      Symbols of Death
		[328077]        =       261,    --      Symbols of Death

		-- Elemental Shaman:
		[273221] = 262, -- Aftershock
		[108281] = 262, -- Ancestral Guidance
		[114911] = 262, -- Ancestral Guidance
		[8042] = 262, -- Earth Shock
		[170374] = 262, -- Earthen Rage
		[61882] = 262, -- Earthquake
		[77478] = 262, -- Earthquake
		[320125] = 262, -- Echoing Shock
		[343190] = 262, -- Elemental Fury
		[60188] = 262, -- Elemental Fury
		[198067] = 262, -- Fire Elemental
		[210714] = 262, -- Icefury
		[192222] = 262, -- Liquid Magma Totem
		[16166] = 262, -- Master of the Elements
		[117013] = 262, -- Primal Elementalist
		[342243] = 262, -- Static Discharge
		[192249] = 262, -- Storm Elemental
		[262303] = 262, -- Surge of Power
		[51490] = 262, -- Thunderstorm
		[260895] = 262, -- Unlimited Power

		-- Enhancement Shaman:
		[187874] = 263, -- Crash Lightning
		[192246] = 263, -- Crashing Storm
		[188089] = 263, -- Earthen Spike
		[210853] = 263, -- Elemental Assault
		[262624] = 263, -- Elemental Spirits
		[196884] = 263, -- Feral Lunge
		[231723] = 263, -- Feral Spirit
		[51533] = 263, -- Feral Spirit
		[333974] = 263, -- Fire Nova
		[8349] = 263, -- Fire Nova
		[262647] = 263, -- Forceful Winds
		[334195] = 263, -- Hailstorm
		[201900] = 263, -- Hot Hand
		[342240] = 263, -- Ice Strike
		[334046] = 263, -- Lashing Flames
		[334033] = 263, -- Lava Lash
		[60103] = 263, -- Lava Lash
		[187880] = 263, -- Maelstrom Weapon
		[58875] = 263, -- Spirit Walk
		[201845] = 263, -- Stormbringer
		[319930] = 263, -- Stormbringer
		[334175] = 263, -- Stormfury
		[17364] = 263, -- Stormstrike
		[32175] = 263, -- Stormstrike
		[32176] = 263, -- Stormstrike Off-Hand
		[197214] = 263, -- Sundering
		[343211] = 263, -- Windfury Totem
		[8512] = 263, -- Windfury Totem
		[33757] = 263, -- Windfury Weapon

		-- Restoration Shaman:
		[207399] = 264, -- Ancestral Protection Totem
		[207401] = 264, -- Ancestral Vigor
		[212048] = 264, -- Ancestral Vision
		[157153] = 264, -- Cloudburst Totem
		[200076] = 264, -- Deluge
		[207778] = 264, -- Downpour
		[198838] = 264, -- Earthen Wall Totem
		[280614] = 264, -- Flash Flood
		[192088] = 264, -- Graceful Spirit
		[73920] = 264, -- Healing Rain
		[108280] = 264, -- Healing Tide Totem
		[343205] = 264, -- Healing Tide Totem
		[77472] = 264, -- Healing Wave
		[157154] = 264, -- High Tide
		[16191] = 264, -- Mana Tide Totem
		[343182] = 264, -- Mana Tide Totem
		[77130] = 264, -- Purify Spirit
		[16196] = 264, -- Resurgence
		[61295] = 264, -- Riptide
		[98008] = 264, -- Spirit Link Totem
		[320746] = 264, -- Surge of Earth
		[320747] = 264, -- Surge of Earth
		[231785] = 264, -- Tidal Waves
		[51564] = 264, -- Tidal Waves
		[200072] = 264, -- Torrent
		[200071] = 264, -- Undulation
		[73685] = 264, -- Unleash Life
		[52127] = 264, -- Water Shield
		[197995] = 264, -- Wellspring

		-- Affliction :
		[196103]        =       265,    --      Absolute Corruption
		[231792]        =       265,    --      Agony
		[980]   =       265,    --      Agony
		[264000]        =       265,    --      Creeping Death
		[334183]        =       265,    --      Dark Caller
		[198590]        =       265,    --      Drain Soul
		[48181] =       265,    --      Haunt
		[334319]        =       265,    --      Inevitable Demise
		[324536]        =       265,    --      Malefic Rapture
		[108558]        =       265,    --      Nightfall
		[205179]        =       265,    --      Phantom Singularity
		[27243] =       265,    --      Seed of Corruption
		[27285] =       265,    --      Seed of Corruption
		[32388] =       265,    --      Shadow Embrace
		[63106] =       265,    --      Siphon Life
		[196226]        =       265,    --      Sow the Seeds
		[205180]        =       265,    --      Summon Darkglare
		[231791]        =       265,    --      Unstable Affliction
		[316099]        =       265,    --      Unstable Affliction
		[334315]        =       265,    --      Unstable Affliction
		[278350]        =       265,    --      Vile Taint
		[196102]        =       265,    --      Writhe in Agony
		
		--  Demonology Warlock:
		[267211]        =       266,    --      Bilescourge Bombers
		[104316]        =       266,    --      Call Dreadstalkers
		[334727]        =       266,    --      Call Dreadstalkers
		[264178]        =       266,    --      Demonbolt
		[205145]        =       266,    --      Demonic Calling
		[267215]        =       266,    --      Demonic Consumption
		[267171]        =       266,    --      Demonic Strength
		[603]   =       266,    --      Doom
		[264078]        =       266,    --      Dreadlash
		[267170]        =       266,    --      From the Shadows
		[105174]        =       266,    --      Hand of Gul'dan
		[196277]        =       266,    --      Implosion
		[267216]        =       266,    --      Inner Demons
		[267217]        =       266,    --      Nether Portal
		[264130]        =       266,    --      Power Siphon
		[267214]        =       266,    --      Sacrificed Souls
		[108415]        =       266,    --      Soul Link
		[264057]        =       266,    --      Soul Strike
		[265187]        =       266,    --      Summon Demonic Tyrant
		[334585]        =       266,    --      Summon Demonic Tyrant
		[30146] =       266,    --      Summon Felguard
		[264119]        =       266,    --      Summon Vilefiend

		--  Destruction Warlock:
		[196406]        =       267,    --      Backdraft
		[152108]        =       267,    --      Cataclysm
		[196447]        =       267,    --      Channel Demonfire
		[116858]        =       267,    --      Chaos Bolt
		[215279]        =       267,    --      Chaos Bolt
		[17962] =       267,    --      Conflagrate
		[231793]        =       267,    --      Conflagrate
		[196412]        =       267,    --      Eradication
		[196408]        =       267,    --      Fire and Brimstone
		[267115]        =       267,    --      Flashover
		[335174]        =       267,    --      Havoc
		[80240] =       267,    --      Havoc
		[193541]        =       267,    --      Immolate
		[348]   =       267,    --      Immolate
		[29722] =       267,    --      Incinerate
		[270545]        =       267,    --      Inferno
		[266134]        =       267,    --      Internal Combustion
		[266086]        =       267,    --      Rain of Chaos
		[335189]        =       267,    --      Rain of Fire
		[42223] =       267,    --      Rain of Fire
		[5740]  =       267,    --      Rain of Fire
		[205148]        =       267,    --      Reverse Entropy
		[205184]        =       267,    --      Roaring Blaze
		[17877] =       267,    --      Shadowburn
		[6353]  =       267,    --      Soul Fire
		[1122]  =       267,    --      Summon Infernal
		[335175]        =       267,    --      Summon Infernal


		--  Arms Warrior:
		[845]   =       71,     --      Cleave
		[334779]        =       71,     --      Collateral Damage
		[167105]        =       71,     --      Colossus Smash
		[316411]        =       71,     --      Colossus Smash
		[262228]        =       71,     --      Deadly Calm
		[197690]        =       71,     --      Defensive Stance
		[118038]        =       71,     --      Die by the Sword
		[315948]        =       71,     --      Die by the Sword
		[262150]        =       71,     --      Dreadnaught
		[202316]        =       71,     --      Fervor of Battle
		[248621]        =       71,     --      In For The Kill
		[12294] =       71,     --      Mortal Strike
		[261900]        =       71,     --      Mortal Strike
		[316440]        =       71,     --      Overpower
		[316441]        =       71,     --      Overpower
		[7384]  =       71,     --      Overpower
		[772]   =       71,     --      Rend
		[279423]        =       71,     --      Seasoned Soldier
		[29838] =       71,     --      Second Wind
		[260643]        =       71,     --      Skullsplitter
		[260708]        =       71,     --      Sweeping Strikes
		[316432]        =       71,     --      Sweeping Strikes
		[316433]        =       71,     --      Sweeping Strikes
		[184783]        =       71,     --      Tactician
		[262161]        =       71,     --      Warbreaker

		--  Fury Warrior:
		[23881] =       72,     --      Bloodthirst
		[316537]        =       72,     --      Bloodthirst
		[335070]        =       72,     --      Cruelty
		[184361]        =       72,     --      Enrage
		[316424]        =       72,     --      Enrage
		[316425]        =       72,     --      Enrage
		[184364]        =       72,     --      Enraged Regeneration
		[316474]        =       72,     --      Enraged Regeneration
		[335077]        =       72,     --      Frenzy
		[215568]        =       72,     --      Fresh Meat
		[215571]        =       72,     --      Frothing Berserker
		[202224]        =       72,     --      Furious Charge
		[280392]        =       72,     --      Meat Cleaver
		[315720]        =       72,     --      Onslaught
		[316452]        =       72,     --      Raging Blow
		[316453]        =       72,     --      Raging Blow
		[85288] =       72,     --      Raging Blow
		[85384] =       72,     --      Raging Blow
		[96103] =       72,     --      Raging Blow
		[184367]        =       72,     --      Rampage
		[209694]        =       72,     --      Rampage
		[316412]        =       72,     --      Rampage
		[316519]        =       72,     --      Rampage
		[202751]        =       72,     --      Reckless Abandon
		[1719]  =       72,     --      Recklessness
		[316828]        =       72,     --      Recklessness
		[335091]        =       72,     --      Seethe
		[280772]        =       72,     --      Siegebreaker
		[81099] =       72,     --      Single-Minded Fury
		[46917] =       72,     --      Titan's Grip
		[208154]        =       72,     --      Warpaint


		--  Protection Warrior:
		[202560]        =       73,     --      Best Served Cold
		[280001]        =       73,     --      Bolster
		[202743]        =       73,     --      Booming Voice
		[203201]        =       73,     --      Crackling Thunder
		[115767]        =       73,     --      Deep Wounds
		[115768]        =       73,     --      Deep Wounds
		[1160]  =       73,     --      Demoralizing Shout
		[316464]        =       73,     --      Demoralizing Shout
		[20243] =       73,     --      Devastate
		[236279]        =       73,     --      Devastator
		[203177]        =       73,     --      Heavy Repercussions
		[202095]        =       73,     --      Indomitable
		[202603]        =       73,     --      Into the Fray
		[12975] =       73,     --      Last Stand
		[275338]        =       73,     --      Menace
		[202561]        =       73,     --      Never Surrender
		[275334]        =       73,     --      Punish
		[6572]  =       73,     --      Revenge
		[161798]        =       73,     --      Riposte
		[275339]        =       73,     --      Rumbling Earth
		[316834]        =       73,     --      Shield Wall
		[871]   =       73,     --      Shield Wall
		[46968] =       73,     --      Shockwave
		[316414]        =       73,     --      Thunder Clap
		[6343]  =       73,     --      Thunder Clap
		[275336]        =       73,     --      Unstoppable Force
		[316428]        =       73,     --      Vanguard
		[71]    =       73,     --      Vanguard

	}
	end

	_detalhes.SpecIDToClass = {
		[577] = "DEMONHUNTER", -- Havoc Demon Hunter
		[581] = "DEMONHUNTER", -- Vengeance Demon Hunter

		[252] = "DEATHKNIGHT", -- Unholy Death Knight
		[251] = "DEATHKNIGHT", -- Frost Death Knight
		[250] = "DEATHKNIGHT", -- Blood Death Knight
		
		[102] = "DRUID", -- Balance Druid
		[103] = "DRUID", -- Feral Druid
		[104] = "DRUID", -- Guardian Druid
		[105] = "DRUID", -- Restoration Druid
		
		[253] = "HUNTER", -- Beast Mastery Hunter
		[254] = "HUNTER", -- Marksmanship Hunter
		[255] = "HUNTER", -- Survival Hunter
		
		[62] = "MAGE", -- Arcane Mage
		[63] = "MAGE", -- Fire Mage
		[64] = "MAGE", -- Frost Mage

		[268] = "MONK", -- Brewmaster Monk
		[269] = "MONK", -- Windwalker Monk
		[270] = "MONK", -- Mistweaver Monk
		
		[65] = "PALADIN", -- Holy Paladin
		[66] = "PALADIN", -- Protection Paladin
		[70] = "PALADIN", -- Retribution Paladin
		
		[256] = "PRIEST", -- Discipline Priest
		[257] = "PRIEST", -- Holy Priest
		[258] = "PRIEST", -- Shadow Priest
		
		[259] = "ROGUE", -- Assassination Rogue
		[260] = "ROGUE", -- Outlaw Rogue
		[261] = "ROGUE", -- Subtlety Rogue
		
		[262] = "SHAMAN", -- Elemental Shaman
		[263] = "SHAMAN", -- Enhancement Shaman
		[264] = "SHAMAN", -- Restoration Shaman
		
		[265] = "WARLOCK", -- Affliction Warlock
		[266] = "WARLOCK", -- Demonology Warlock
		[267] = "WARLOCK", -- Destruction Warlock
		
		[71] = "WARRIOR", -- Arms Warrior
		[72] = "WARRIOR", -- Fury Warrior
		[73] = "WARRIOR", -- Protection Warrior
	}

	_detalhes.ClassSpellList = {

		--death knight
		[152280]	=	"DEATHKNIGHT", -- "Defile"
		[152279]	=	"DEATHKNIGHT", -- "Breath of Sindragosa"
		[165569]	=	"DEATHKNIGHT", -- "Frozen Runeblade"
		[156000]	=	"DEATHKNIGHT", -- "Defile"
		[50401]	=	"DEATHKNIGHT", -- "Razorice"
		[155166]	=	"DEATHKNIGHT", -- "Mark of Sindragosa"
		[66198]	=	"DEATHKNIGHT", -- "Obliterate Off-Hand"
		[52212]	=	"DEATHKNIGHT", -- "Death and Decay"
		[168828]	=	"DEATHKNIGHT", -- "Necrosis"
		[66196]	=	"DEATHKNIGHT", -- "Frost Strike Off-Hand"
		[66216]	=	"DEATHKNIGHT", -- "Plague Strike Off-Hand"
		[108194]	=	"DEATHKNIGHT", --  Asphyxiate
		[50977]	=	"DEATHKNIGHT", --  Death Gate
		[108199]	=	"DEATHKNIGHT", --  Gorefiend's Grasp
		[108201]	=	"DEATHKNIGHT", --  Desecrated Ground
		[48265]	=	"DEATHKNIGHT", --  Unholy Presence
		[77606]	=	"DEATHKNIGHT", --  Dark Simulacrum
		[61999]	=	"DEATHKNIGHT", --  Raise Ally
		[108196]	=	"DEATHKNIGHT", --Death Siphon
		[47541]	=	"DEATHKNIGHT", -- Death Coil
		[42650]	=	"DEATHKNIGHT", -- Army of the Dead
		[130736]	=	"DEATHKNIGHT", -- Soul Reaper
		[45524]	=	"DEATHKNIGHT", -- Chains of Ice
		[57330]	=	"DEATHKNIGHT", -- Horn of Winter
		[45462]	=	"DEATHKNIGHT", -- Plague Strike
		[85948]	=	"DEATHKNIGHT", -- Festering Strike
		[63560]	=	"DEATHKNIGHT", -- Dark Transformation
		[108200]	=	"DEATHKNIGHT", -- Remorseless Winter
		[49222]	=	"DEATHKNIGHT", -- Bone Shield
		[45477]	=	"DEATHKNIGHT", -- Icy Touch
		[43265]	=	"DEATHKNIGHT", -- Death and Decay
		[77575]	=	"DEATHKNIGHT", -- Outbreak
		[51271]	=	"DEATHKNIGHT", -- Pillar of Frost
		[115989]	=	"DEATHKNIGHT", -- Unholy Blight
		[48792]	=	"DEATHKNIGHT", -- Icebound Fortitude
		[55233]	=	"DEATHKNIGHT", -- Vampiric Blood
		[49576]	=	"DEATHKNIGHT", -- Death Grip
		[119975]	=	"DEATHKNIGHT", -- Conversion
		[56222]	=	"DEATHKNIGHT", -- Dark Command
		[114866]	=	"DEATHKNIGHT", -- Soul Reaper
		[45529]	=	"DEATHKNIGHT", -- Blood Tap
		[130735]	=	"DEATHKNIGHT", -- Soul Reaper
		[50842]	=	"DEATHKNIGHT", -- Pestilence
		[48743]	=	"DEATHKNIGHT", -- Death Pact
		[47528]	=	"DEATHKNIGHT", -- Mind Freeze
		[123693]	=	"DEATHKNIGHT", -- Plague Leech
		[3714]	=	"DEATHKNIGHT", -- Path of Frost
		[48263]	=	"DEATHKNIGHT", -- Blood Presence
		[49039]	=	"DEATHKNIGHT", -- Lichborne
		[49028]	=	"DEATHKNIGHT", -- Dancing Rune Weapon
		[47568]	=	"DEATHKNIGHT", -- Empower Rune Weapon
		[96268]	=	"DEATHKNIGHT", -- Death's Advance
		[49206]	=	"DEATHKNIGHT", -- Summon Gargoyle
		[48266]	=	"DEATHKNIGHT", -- Frost Presence
		[77535]	=	"DEATHKNIGHT", --Blood Shield (heal)
		[45470]	=	"DEATHKNIGHT", --Death Strike (heal)
		[53365]	=	"DEATHKNIGHT", --Unholy Strength (heal)
		[48707]	=	"DEATHKNIGHT", -- Anti-Magic Shell (heal)
		[48982]	=	"DEATHKNIGHT", --rune tap
		[49020]	=	"DEATHKNIGHT", --obliterate
		[49143]	=	"DEATHKNIGHT", --frost strike
		[55095]	=	"DEATHKNIGHT", --frost fever
		[55078]	=	"DEATHKNIGHT", --blood plague
		[49184]	=	"DEATHKNIGHT", --howling blast
		[49998]	=	"DEATHKNIGHT", --death strike
		[55090]	=	"DEATHKNIGHT",--scourge strike
		[47632]	=	"DEATHKNIGHT",--death coil
	
	--demmon hunter
		[185123] = "DEMONHUNTER", -- "Throw Glaive"
		[196718] = "DEMONHUNTER", -- "Darkness"
		[183752] = "DEMONHUNTER", -- "Consume Magic"
		[131347] = "DEMONHUNTER", -- "Glide"
		[200166] = "DEMONHUNTER", -- "Metamorphosis"
		[198793] = "DEMONHUNTER", -- "Vengeful Retreat"
		[162243] = "DEMONHUNTER", -- "Demon's Bite"
		[213241] = "DEMONHUNTER", -- "Felblade"
		[213243] = "DEMONHUNTER", -- "Felblade"
		[179057] = "DEMONHUNTER", -- "Chaos Nova"
		[188499] = "DEMONHUNTER", -- "Blade Dance"
		[198013] = "DEMONHUNTER", -- "Eye Beam"
		[201467] = "DEMONHUNTER", -- "Fury of the Illidari"
		[178963] = "DEMONHUNTER", -- "Consume Soul"
		[162794] = "DEMONHUNTER", -- "Chaos Strike"
		[211881] = "DEMONHUNTER", -- "Fel Eruption"
		[201427] = "DEMONHUNTER", -- "Annihilation"
		[210152] = "DEMONHUNTER", -- "Death Sweep"
		[203782] = "DEMONHUNTER", -- "Shear"
		[203720] = "DEMONHUNTER", -- "Demon Spikes"
		[218256] = "DEMONHUNTER", -- "Empower Wards"
		[203798] = "DEMONHUNTER", -- "Soul Cleave"
		[202137] = "DEMONHUNTER", -- "Sigil of Silence"
		[204490] = "DEMONHUNTER", -- "Sigil of Silence"
		[204596] = "DEMONHUNTER", -- "Sigil of Flame"
		[204598] = "DEMONHUNTER", -- "Sigil of Flame"
		[204021] = "DEMONHUNTER", -- "Fiery Brand"
		[202138] = "DEMONHUNTER", -- "Sigil of Chains"
		[207407] = "DEMONHUNTER", -- "Soul Carver"
		[178741] = "DEMONHUNTER", -- immolation aura
		[247455] = "DEMONHUNTER", -- spirit bomb
		[225921] = "DEMONHUNTER", -- fracture
		[225919] = "DEMONHUNTER", -- fracture
	
	--druid
		[155722]	=	"DRUID", -- rake
		[192090]	=	"DRUID", -- thrash
		
		[145110]	=	"DRUID", -- "Ysera's Gift"
		[155777]	=	"DRUID", -- "Rejuvenation (Germination)"
		[101024]	=	"DRUID", -- "Glyph of Ferocious Bite"
		[124988]	=	"DRUID", -- "Nature's Vigil"
		[172176]	=	"DRUID", -- "Dream of Cenarius"
		[102352]	=	"DRUID", -- "Cenarion Ward"
		[162359]	=	"DRUID", -- "Genesis"
		[157982]	=	"DRUID", -- "Tranquility"
		[155835]	=	"DRUID", -- "Bristling Fur"
		[20484]	=	"DRUID", -- "Rebirth"
		[106839]	=	"DRUID", -- "Skull Bash"
		[42231]	=	"DRUID", -- "Hurricane"
		[164815]	=	"DRUID", -- "Sunfire"		
		[164812]	=	"DRUID", -- "Moonfire"
		[106785]	=	"DRUID", -- "Swipe"
		[50288]	=	"DRUID", -- "Starfall"
		[152221]	=	"DRUID", -- "Stellar Flare"	
		[80313]	=	"DRUID", -- "Pulverize"	
		[124991]	=	"DRUID", -- "Nature's Vigil"
		[33917]	=	"DRUID", -- "Mangle"
		[102417]	=	 "DRUID", --  Wild Charge
		[78675]	=	 "DRUID", --  Solar Beam
		[102351]	=	 "DRUID", --  Cenarion Ward
		[114282]	=	 "DRUID", --  Treant Form
		[5215]	=	 "DRUID", --  Prowl
		[52610]	=	 "DRUID", --  Savage Roar
		[22570]	=	 "DRUID", --  Maim
		[102401]	=	 "DRUID", --  Wild Charge
		[33831]	=	 "DRUID", --  Force of Nature
		[102355]	=	 "DRUID", --  Faerie Swarm
		[102706]	=	 "DRUID", --  Force of Nature
		[16914]	=	 "DRUID", --  Hurricane
		[2908]	=	 "DRUID", --  Soothe
		[102793]	=	 "DRUID", --  Ursol's Vortex
		[106996]	=	 "DRUID", --  Astral Storm
		[106898]	=	 "DRUID", --  Stampeding Roar
		[33891]	=	 "DRUID", --  Incarnation: Tree of Life
		[102359]	=	 "DRUID", --  Mass Entanglement
		[108293]	=	 "DRUID", --  Heart of the Wild
		[5211]	=	 "DRUID", --  Mighty Bash
		[108291]	=	 "DRUID", --  Heart of the Wild		
		[18562]	=	 "DRUID", --Swiftmend
		[132158]	=	 "DRUID", -- Nature's Swiftness
		[33763]	=	 "DRUID", -- Lifebloom
		[1126]	=	 "DRUID", -- Mark of the Wild
		[6807]	=	 "DRUID", -- Maul
		[33745]	=	 "DRUID", -- Lacerate
		[145205]	=	 "DRUID", -- Wild Mushroom
		[77761]	=	 "DRUID", -- Stampeding Roar
		[16953]	=	 "DRUID", -- Primal Fury
		[102693]	=	 "DRUID", -- Force of Nature
		[145518]	=	 "DRUID", -- Genesis
		[22812]	=	 "DRUID", -- Barkskin
		[770]	=	 "DRUID", -- Faerie Fire
		[106951]	=	 "DRUID", -- Berserk
		[124974]	=	 "DRUID", -- Nature's Vigil
		[105697]	=	 "DRUID", -- Virmen's Bite
		[5225]	=	 "DRUID", -- Track Humanoids
		[102280]	=	 "DRUID", -- Displacer Beast
		[102543]	=	 "DRUID", -- Incarnation: King of the Jungle
		[1850]	=	 "DRUID", -- Dash
		[77764]	=	 "DRUID", -- Stampeding Roar
		[22568]	=	 "DRUID", -- Ferocious Bite	
		[147349]	=	 "DRUID", -- Wild Mushroom
		[77758]	=	 "DRUID", -- Thrash
		[108294]	=	 "DRUID", -- Heart of the Wild
		[106830]	=	 "DRUID", -- Thrash
		[108292]	=	 "DRUID", -- Heart of the Wild
		[768]	=	 "DRUID", -- Cat Form
		[61336]	=	 "DRUID", -- Survival Instincts
		[146323]	=	 "DRUID", -- Inward Contemplation
		[22842]	=	 "DRUID", -- Frenzied Regeneration
		[108238]	=	 "DRUID", -- Renewal
		[16979]	=	 "DRUID", -- Wild Charge
		[50334]	=	 "DRUID", -- Berserk
		[102558]	=	 "DRUID", -- Incarnation: Son of Ursoc
		[6795]	=	 "DRUID", -- Growl
		[48505]	=	 "DRUID", -- Starfall
		[78674]	=	 "DRUID", -- Starsurge
		[102560]	=	 "DRUID", -- Incarnation: Chosen of Elune
		[112071]	=	 "DRUID", -- Celestial Alignment
		[61391]	=	 "DRUID", -- Typhoon
		[24858]	=	 "DRUID", -- Moonkin Form
		[136086]	=	 "DRUID", -- Archer's Grace
		[127663]	=	 "DRUID", -- Astral Communion
		[49376]	=	 "DRUID", -- Wild Charge
		[62606]	=	 "DRUID", -- Savage Defense
		[1822] 	=	"DRUID", --rake
		[1079] 	=	"DRUID", --rip
		[5221] 	=	"DRUID", --shred
		[17057]	=	"DRUID", --bear form (energy gain)
		[16959]	=	"DRUID", --primal fury (energy gain)
		[5217]	=	"DRUID", --tiger's fury (energy gain)
		[68285]	=	"DRUID", --leader of the pack (mana)
		[5176]	=	"DRUID", --wrath
		[93402]	=	"DRUID", --sunfire
		[2912]	=	"DRUID", --starfire
		[8921]	=	"DRUID", --moonfire
		[774]	=	"DRUID", --rejuvenation
		[48438]	=	"DRUID", --wild growth
		[81269]	=	"DRUID", --shiftmend
		[5185]	=	"DRUID", --healing touch
		[8936]	=	"DRUID", --regrowth
		[33778]	=	"DRUID", --lifebloom
		[48503]	=	"DRUID", --living seed

	--hunter
		[257284]	=	"HUNTER", -- hunter's mark
		[259398]	=	"HUNTER", -- Chakrams
		[267666]	=	"HUNTER", -- Chakrams
		[269747]	=	"HUNTER", -- Scorching Wildfire
		[217200]	=	"HUNTER", -- Barbed Shot
		[193455]	=	"HUNTER", -- Cobra Shot
		[185358]	=	"HUNTER", -- Arcane Shot
		[259491]	=	"HUNTER", -- Serpent Sting
		[186270]	=	"HUNTER", -- Raptor Strike
		[212436]	=	"HUNTER", -- Butchery
		[53353]	=	"HUNTER", -- "Chimaera Shot"
		[164851]	=	"HUNTER", -- "Kill Shot"
		[164857]	=	"HUNTER", -- "Survivalist"
		[115927]	=	"HUNTER", -- "Liberation"
		[132764]	=	"HUNTER", -- "Dire Beast"
		[160206]	=	"HUNTER", -- "Lone Wolf: Power of the Primates"
		[13813]	=	"HUNTER", -- "Explosive Trap"
		[187650]	=	"HUNTER", -- "Freezing Trap"
		[172106]	=	"HUNTER", -- "Aspect of the Fox"
		[162537]	=	"HUNTER", -- "Poisoned Ammo"
		[162536]	=	"HUNTER", -- "Incendiary Ammo"
		[13812]	=	"HUNTER", -- "Explosive Trap"
		[157708]	=	"HUNTER", -- "Kill Shot"
		[120761]	=	"HUNTER", -- "Glaive Toss"
		[171454]	=	"HUNTER", -- "Chimaera Shot"
		[162541]	=	"HUNTER", -- "Incendiary Ammo"
		[83245]	=	"HUNTER",--  Call Pet 5 HUNTER
		[51753]	=	"HUNTER",--  Camouflage HUNTER
		[109259]	=	"HUNTER",--  Powershot HUNTER
		[53271]	=	"HUNTER",--  Master's Call HUNTER
		[20736]	=	"HUNTER",--  Distracting Shot HUNTER
		[1543]	=	"HUNTER",--  Flare HUNTER
		[3674]	=	"HUNTER",-- Black Arrow
		[117050]	=	"HUNTER",-- Glaive Toss
		[781]	=	"HUNTER",-- Disengage
		[34026]	=	"HUNTER",-- Kill Command
		[82948]	=	"HUNTER",-- Snake Trap
		[2643]	=	"HUNTER",-- Multi-Shot
		[109248]	=	"HUNTER",-- Binding Shot
		[149365]	=	"HUNTER",-- Dire Beast
		[120679]	=	"HUNTER",-- Dire Beast
		[82726]	=	"HUNTER",-- Fervor
		[3045]	=	"HUNTER",-- Rapid Fire
		[257045]	=	"HUNTER",-- Rapid Fire
		[883]	=	"HUNTER",-- Call Pet 1
		[19574]	=	"HUNTER",-- Bestial Wrath
		[148467]	=	"HUNTER",-- Deterrence
		[109304]	=	"HUNTER",-- Exhilaration
		[82939]	=	"HUNTER",-- Explosive Trap
		[19386]	=	"HUNTER",-- Wyvern Sting
		[131894]	=	"HUNTER",-- A Murder of Crows
		[13159]	=	"HUNTER",-- Aspect of the Pack
		[109260]	=	"HUNTER",-- Aspect of the Iron Hawk
		[121818]	=	"HUNTER",-- Stampede
		[19434]	=	"HUNTER",-- Aimed Shot
		[82941]	=	"HUNTER",-- Ice Trap
		[83242]	=	"HUNTER",-- Call Pet 2
		[120697]	=	"HUNTER",-- Lynx Rush
		[56641]	=	"HUNTER",-- Steady Shot
		[82692]	=	"HUNTER",-- Focus Fire
		[53209]	=	"HUNTER",-- Chimera Shot
		[83243]	=	"HUNTER",-- Call Pet 3
		[5116]	=	"HUNTER",-- Concussive Shot
		[1130]	=	"HUNTER",--'s Mark
		[34477]	=	"HUNTER",-- Misdirection
		[19263]	=	"HUNTER",-- Deterrence
		[147362]	=	"HUNTER",-- Counter Shot
		[19801]	=	"HUNTER",-- Tranquilizing Shot
		[2641]	=	"HUNTER",-- Dismiss Pet
		[83244]	=	"HUNTER",-- Call Pet 4
		[5118]	=	"HUNTER",-- Aspect of the Cheetah
		[120360]	=	"HUNTER",-- Barrage
		[19577]	=	"HUNTER",-- Intimidation			
		[131900]	=	"HUNTER",--a murder of crows
		[118253]	=	"HUNTER",--serpent sting
		[77767]	=	"HUNTER",--cobra shot
		[3044]	=	"HUNTER",--arcane shot
		[53301]	=	"HUNTER",--explosive shot
		[120361]	=	"HUNTER",--barrage
		[53351]	=	"HUNTER",--kill shot
	
	--mage
		[87023]	=	"MAGE", -- "Cauterize"
		[152087]	=	"MAGE", -- "Prismatic Crystal"
		[157750]	=	"MAGE", -- "Summon Water Elemental"
		[159916]	=	"MAGE", -- "Amplify Magic"
		[157913]	=	"MAGE", -- "Evanesce"
		[153561]	=	"MAGE", -- "Meteor"
		[157978]	=	"MAGE", -- "Unstable Magic"
		[157980]	=	"MAGE", -- "Supernova"
		[153564]	=	"MAGE", -- "Meteor"
		[44461]	=	"MAGE", -- "Living Bomb"
		[148022]	=	"MAGE", -- "Icicle"
		[155152]	=	"MAGE", -- "Prismatic Crystal"
		[108839]	=	"MAGE",--  Ice Floes
		[7302]	=	"MAGE",--  Frost Armor
		[31661]	=	"MAGE",--  Dragon's Breath
		[53140]	=	"MAGE",--  Teleport: Dalaran
		[11417]	=	"MAGE",--  Portal: Orgrimmar
		[42955]	=	"MAGE",--  Conjure Refreshment
		[44457]	=	"MAGE",-- Living Bomb
		[1953]	=	"MAGE",-- Blink
		[108843]	=	"MAGE",-- Blazing Speed
		[12043]	=	"MAGE",-- Presence of Mind
		[108978]	=	"MAGE",-- Alter Time
		[55342]	=	"MAGE",-- Mirror Image
		[84714]	=	"MAGE",-- Frozen Orb
		[45438]	=	"MAGE",-- Ice Block
		[115610]	=	"MAGE",-- Temporal Shield
		[110960]	=	"MAGE",-- Greater Invisibility
		[110959]	=	"MAGE",-- Greater Invisibility
		[11129]	=	"MAGE",-- Combustion
		[11958]	=	"MAGE",-- Cold Snap
		[61316]	=	"MAGE",-- Dalaran Brilliance
		[112948]	=	"MAGE",-- Frost Bomb
		[2139]	=	"MAGE",-- Counterspell
		[80353]	=	"MAGE",-- Time Warp
		[2136]	=	"MAGE",-- Fire Blast
		[7268]	=	"MAGE",-- Arcane Missiles
		[111264]	=	"MAGE",-- Ice Ward
		[114923]	=	"MAGE",-- Nether Tempest
		[2120]	=	"MAGE",-- Flamestrike
		[44425]	=	"MAGE",-- Arcane Barrage
		[12042]	=	"MAGE",-- Arcane Power
		[1459]	=	"MAGE",-- Arcane Brilliance
		[127140]	=	"MAGE",-- Alter Time
		[116011]	=	"MAGE",-- Rune of Power
		[116014]	=	"MAGE",-- Rune of Power
		[132627]	=	"MAGE",-- Teleport: Vale of Eternal Blossoms
		[31687]	=	"MAGE",-- Summon Water Elemental
		[3567]	=	"MAGE",-- Teleport: Orgrimmar
		[30449]	=	"MAGE",-- Spellsteal
		[44572]	=	"MAGE",-- Deep Freeze
		[113724]	=	"MAGE",-- Ring of Frost
		[132626]	=	"MAGE",-- Portal: Vale of Eternal Blossoms
		[12472]	=	"MAGE",-- Icy Veins
		[116]	=	"MAGE",--frost bolt
		[30455]	=	"MAGE",--ice lance
		[84721]	=	"MAGE",--frozen orb
		[1449]	=	"MAGE",--arcane explosion
		[113092]	=	"MAGE",--frost bomb
		[115757]	=	"MAGE",--frost nova
		[44614]	=	"MAGE",--forstfire bolt
		[42208]	=	"MAGE",--blizzard
		[11426]	=	"MAGE",--Ice Barrier (heal)
		[11366]	=	"MAGE",--pyroblast
		[133]	=	"MAGE",--fireball
		[108853]	=	"MAGE",--infernoblast
		[2948]	=	"MAGE",--scorch
		[30451]	=	"MAGE",--arcane blase
		[12051]	=	"MAGE",--evocation
	
	--monk
		[116995]	=	"MONK", -- "Surging Mist"
		[162530]	=	"MONK", -- "Rushing Jade Wind"
		[157675]	=	"MONK", -- "Chi Explosion"
		[157590]	=	"MONK", -- "Breath of the Serpent"
		[128591]	=	"MONK", -- "Blackout Kick"
		[122281]	=	"MONK", -- "Healing Elixirs"
		[124101]	=	"MONK", -- "Zen Sphere: Detonate"
		[119031]	=	"MONK", -- "Gift of the Serpent"
		[137562]	=	"MONK", -- "Nimble Brew"
		[157535]	=	"MONK", -- "Breath of the Serpent"
		[152173]	=	"MONK", -- "Serenity"
		[152175]	=	"MONK", -- "Hurricane Strike"
		[148187]	=	"MONK", -- "Rushing Jade Wind"
		[124098]	=	"MONK", -- "Zen Sphere"
		[125033]	=	"MONK", -- "Zen Sphere: Detonate"
		[158221]	=	"MONK", -- "Hurricane Strike"
		[115129]	=	"MONK", -- "Expel Harm"
		[152174]	=	"MONK", -- "Chi Explosion"
		[123586]	=	"MONK", -- "Flying Serpent Kick"
		[115176]	=	"MONK", -- Zen Meditation cooldown
		[115203]	=	"MONK", -- Fortifying Brew
		
		[124081]	=	"MONK", -- Zen Sphere
		[125355]	=	"MONK", -- Healing Sphere
		[122278]	=	"MONK", -- Dampen Harm
		[115450]	=	"MONK", -- Detox
		
		[121827]	=	"MONK", -- Roll
		[115315]	=	"MONK", -- Summon Black Ox Statue
		[115399]	=	"MONK", -- Chi Brew
		[101643]	=	"MONK", -- Transcendence
		[115546]	=	"MONK", -- Provoke
		[115294]	=	"MONK", -- Mana Tea
		[116680]	=	"MONK", -- Thunder Focus Tea
		[115070]	=	"MONK", -- Stance of the Wise Serpent
		[115069]	=	"MONK", -- Stance of the Sturdy Ox
		
		[119381]	=	"MONK", -- Leg Sweep
		[115695]	=	"MONK", -- Jab
		[137639]	=	"MONK", -- Storm, Earth, and Fire
		[115008]	=	"MONK", -- Chi Torpedo
		[121828]	=	"MONK", -- --Chi Torpedo 
		[115180]	=	"MONK", -- Dizzying Haze
		[123986]	=	"MONK", -- Chi Burst
		[130654]	=	"MONK", -- Chi Burst
		[148135]	=	"MONK", -- Chi Burst
		[119392]	=	"MONK", -- Charging Ox Wave
		[116095]	=	"MONK", -- Disable
		[115687]	=	"MONK", -- Jab		
		[117993]	=	"MONK", -- Chi Torpedo
		[100780]	=	"MONK", -- Jab
		[116740]	=	"MONK", -- Tigereye Brew
		[124682]	=	"MONK", -- Enveloping Mist
		[101545]	=	"MONK", -- Flying Serpent Kick
		[109132]	=	"MONK", -- Roll
		[122470]	=	"MONK", -- Touch of Karma
		[117418]	=	"MONK", -- Fists of Fury
		[113656]	=	"MONK", -- Fists of Fury
		[115698]	=	"MONK", -- Jab
		[115460]	=	"MONK", -- Healing Sphere
		[115098]	=	"MONK", -- Chi Wave
		[115151]	=	"MONK", -- Renewing Mist
		[117952]	=	"MONK", -- Crackling Jade Lightning
		[122783]	=	"MONK", -- Diffuse Magic
		[115078]	=	"MONK", -- Paralysis
		[116705]	=	"MONK", -- Spear Hand Strike
		[123904]	=	"MONK", -- Invoke Xuen, the White Tiger
		[147489]	=	"MONK", -- Expel Harm
		[101546]	=	"MONK", -- Spinning Crane Kick
		[115313]	=	"MONK", -- Summon Jade Serpent Statue
		[135920]	=	"MONK", -- Gift of the Serpent
		[116841]	=	"MONK", -- Tiger's Lust
		[116694]	=	"MONK", -- Surging Mist
		[116847]	=	"MONK", -- Rushing Jade Wind
		[108557]	=	"MONK", -- Jab
		[115181]	=	"MONK", -- Breath of Fire
		[121253]	=	"MONK", -- Keg Smash
		[124506]	=	"MONK", -- Gift of the Ox
		[124503]	=	"MONK", -- Gift of the Ox
		[115288]	=	"MONK", -- Energizing Brew
		[115308]	=	"MONK", -- Elusive Brew
		[116781]	=	"MONK", -- Legacy of the White Tiger
		[115921]	=	"MONK", -- Legacy of the Emperor
		[115693]	=	"MONK", -- Jab
		[124507]	=	"MONK", -- Gift of the Ox
		[119582]	=	"MONK", -- Purifying Brew
		[115080]	=	"MONK", -- Touch of Death
		[126892]	=	"MONK", -- Zen Pilgrimage
		[116849]	=	"MONK", -- Life Cocoon
		[116844]	=	"MONK", -- Ring of Peace
		[107428]	=	"MONK", --rising sun kick
		[100784]	=	"MONK", --blackout kick
		[132467]	=	"MONK", --Chi wave	
		[107270]	=	"MONK", --spinning crane kick
		[100787]	=	"MONK", --tiger palm
		[123761]	=	"MONK", --mana tea
		[119611]	=	"MONK", --renewing mist
		[115310]	=	"MONK", --revival
		[116670]	=	"MONK", --uplift
		[115175]	=	"MONK", --soothing mist
		[124041]	=	"MONK", --gift of the serpent
		[124040]	=	"MONK", -- shi torpedo
		[132120]	=	"MONK", -- enveloping mist
		[132463]	=	"MONK", -- shi wave
		[117895]	=	"MONK", --eminence (statue)
		[115295]	=	"MONK", --guard
		[115072]	=	"MONK", --expel harm
		
	--paladin
		[121129]	=	"PALADIN", -- "Daybreak"
		[159375]	=	"PALADIN", -- "Shining Protector"
		[130551]	=	"PALADIN", -- "Word of Glory"
		[115536]	=	"PALADIN", -- "Glyph of Protector of the Innocent"
		[66235]	=	"PALADIN", -- "Ardent Defender"
		[152262]	=	"PALADIN", -- "Seraphim"
		[20164]	=	"PALADIN", -- "Seal of Justice"
		[20170]	=	"PALADIN", -- "Seal of Justice"
		[157122]	=	"PALADIN", -- "Holy Shield"		
		[96172]	=	"PALADIN", -- "Hand of Light"
		[101423]	=	"PALADIN", -- "Seal of Righteousness"
		[42463]	=	"PALADIN", -- "Seal of Truth"
		[25912]	=	"PALADIN", -- "Holy Shock"
		[114852]	=	"PALADIN", -- "Holy Prism"
		[114919]	=	"PALADIN", -- "Arcing Light"
		[31850] 	= 	"PALADIN", -- Ardent Defender
		[31842] 	= 	"PALADIN", -- Divine Favor
		[1044] 	= 	"PALADIN", -- Hand of Freedom
		[114039] 	= 	"PALADIN", -- Hand of Purity
		[4987] 	= 	"PALADIN", -- Cleanse
		[136494] 	= 	"PALADIN", -- Word of Glory
		[7328] 	= 	"PALADIN", -- Redemption
		[116467] 	= 	"PALADIN", -- Consecration
		[31801] 	= 	"PALADIN", -- Seal of Truth
		[20165] 	= 	"PALADIN", -- Seal of Insight
		[20473]	=	"PALADIN",-- Holy Shock
		[114158]	=	"PALADIN",-- Light's Hammer
		[85673]	=	"PALADIN",-- Word of Glory
		[85499]	=	"PALADIN",-- Speed of Light
		[31884]	=	"PALADIN",-- Avenging Wrath
		[24275]	=	"PALADIN",-- Hammer of Wrath
		[114165]	=	"PALADIN",-- Holy Prism
		[20925]	=	"PALADIN",-- Sacred Shield
		[53563]	=	"PALADIN",-- Beacon of Light
		[633]	=	"PALADIN",-- Lay on Hands
		[88263]	=	"PALADIN",-- Hammer of the Righteous
		[53595]	=	"PALADIN",-- Hammer of the Righteous
		[53600]	=	"PALADIN",-- Shield of the Righteous
		[26573]	=	"PALADIN",-- Consecration
		[119072]	=	"PALADIN",-- Holy Wrath
		[105593]	=	"PALADIN",-- Fist of Justice
		[114163]	=	"PALADIN",-- Eternal Flame
		[62124]	=	"PALADIN",-- Reckoning
		[121783]	=	"PALADIN",-- Emancipate
		[98057]	=	"PALADIN",-- Grand Crusader
		[642]	=	"PALADIN",-- Divine Shield
		[122032]	=	"PALADIN",-- Exorcism
		[20217]	=	"PALADIN",-- Blessing of Kings
		[96231]	=	"PALADIN",-- Rebuke
		[105809]	=	"PALADIN",-- Holy Avenger
		[25780]	=	"PALADIN",-- Righteous Fury
		[115750]	=	"PALADIN",-- Blinding Light
		[31821]	=	"PALADIN",-- Devotion Aura
		[53385]	=	"PALADIN",-- Divine Storm
		[20154]	=	"PALADIN",-- Seal of Righteousness
		[19740]	=	"PALADIN",-- Blessing of Might
		[148039]	=	"PALADIN",-- Sacred Shield
		[82326]	=	"PALADIN",-- Divine Light
		[35395]	=	"PALADIN",--cruzade strike
		[879]	=	"PALADIN",--exorcism
		[85256]	=	"PALADIN",--templar's verdict
		[20167]	=	"PALADIN",--seal of insight (mana)
		[31935]	=	"PALADIN",--avenger's shield
		[20271]	=	"PALADIN", --judgment
		[35395]	=	"PALADIN", --cruzader strike
		[81297]	=	"PALADIN", --consacration	
		[31803]	=	"PALADIN", --censure
		[65148]	=	"PALADIN", --Sacred Shield
		[20167]	=	"PALADIN", --Seal of Insight
		[86273]	=	"PALADIN", --illuminated healing
		[85222]	=	"PALADIN", --light of dawn
		[53652]	=	"PALADIN", --beacon of light
		[82327]	=	"PALADIN", --holy radiance
		[119952]	=	"PALADIN", --arcing light
		[25914]	=	"PALADIN", --holy shock
		[19750]	=	"PALADIN", --flash of light

	--priest
		[121148]	=	"PRIEST", -- "Cascade"
		[94472]	=	"PRIEST", -- "Atonement"
		[126154]	=	"PRIEST", -- "Lightwell Renew"
		[23455]	=	"PRIEST", -- "Holy Nova"
		[140815]	=	"PRIEST", -- "Power Word: Solace"
		[56160]	=	"PRIEST", -- "Glyph of Power Word: Shield"
		[152116]	=	"PRIEST", -- "Saving Grace"
		[147193]	=	"PRIEST", -- "Shadowy Apparition"
		[155361]	=	"PRIEST", -- "Void Entropy"
		[73325]	=	"PRIEST", -- "Leap of Faith"
		[155245]	=	"PRIEST", -- "Clarity of Purpose"
		[155521]	=	"PRIEST", -- "Auspicious Spirits"
		[148859]	=	"PRIEST", -- "Shadowy Apparition"
		[120696]	=	"PRIEST", -- "Halo"
		[122128]	=	"PRIEST", -- "Divine Star"		
		[132157]	=	"PRIEST", -- "Holy Nova"
		[19236] 	= 	"PRIEST", -- Desperate Prayer
		[47788] 	= 	"PRIEST", -- Guardian Spirit
		[81206] 	= 	"PRIEST", -- Chakra: Sanctuary
		[62618] 	= 	"PRIEST", -- Power Word: Barrier
		[32375] 	= 	"PRIEST", -- Mass Dispel
		[32546] 	= 	"PRIEST", -- Binding Heal			
		[126135] 	= 	"PRIEST", -- Lightwell
		[81209] 	= 	"PRIEST", -- Chakra: Chastise
		[81208] 	= 	"PRIEST", -- Chakra: Serenity
		[2006] 	= 	"PRIEST", -- Resurrection
		[1706] 	= 	"PRIEST", -- Levitate			
		[73510] 	= 	"PRIEST", -- Mind Spike
		[127632] 	= 	"PRIEST", -- Cascade
		[88625] 	= 	"PRIEST", -- Holy Word: Chastise
		[121135]	=	"PRIEST", -- Cascade
		[122121]	=	"PRIEST", -- Divine Star
		[110744]	=	"PRIEST", -- Divine Star
		[8122]	=	"PRIEST", -- Psychic Scream
		[81700]	=	"PRIEST", -- Archangel
		[123258]	=	"PRIEST", -- Power Word: Shield
		[48045]	=	"PRIEST", -- Mind Sear
		[49821]	=	"PRIEST", -- Mind Sear
		[123040]	=	"PRIEST", -- Mindbender
		[121536]	=	"PRIEST", -- Angelic Feather
		[121557]	=	"PRIEST", -- Angelic Feather
		[88685]	=	"PRIEST", -- Holy Word: Sanctuary
		[88684]	=	"PRIEST", -- Holy Word: Serenity
		[33076]	=	"PRIEST", -- Prayer of Mending
		[32379]	=	"PRIEST", -- Shadow Word: Death
		[129176]	=	"PRIEST", -- Shadow Word: Death
		[586]	=	"PRIEST", -- Fade
		[120517]	=	"PRIEST", -- Halo
		[64843]	=	"PRIEST", -- Divine Hymn
		[64844]	=	"PRIEST", -- Divine Hymn
		[34433]	=	"PRIEST", -- Shadowfiend
		[120644]	=	"PRIEST", -- Halo
		[15487]	=	"PRIEST", -- Silence
		[109964]	=	"PRIEST", -- Spirit Shell
		[129197]	=	"PRIEST", -- Mind Flay (Insanity)
		[112833]	=	"PRIEST", -- Spectral Guise
		[47750]	=	"PRIEST", -- Penance
		[33206]	=	"PRIEST", -- Pain Suppression
		[15286]	=	"PRIEST", -- Vampiric Embrace
		[21562]	=	"PRIEST", -- Power Word: Fortitude
		[10060]	=	"PRIEST", -- Power Infusion
		[15473]	=	"PRIEST", -- Shadowform
		[108920]	=	"PRIEST", -- Void Tendrils
		[47585]	=	"PRIEST", -- Dispersion
		[123259]	=	"PRIEST", -- Prayer of Mending
		[34650]	=	"PRIEST", --mana leech (pet)
		[589]	=	"PRIEST", --shadow word: pain
		[34914]	=	"PRIEST", --vampiric touch
		[15407]	=	"PRIEST", --mind flay
		[8092]	=	"PRIEST", --mind blast
		[15290]	=	"PRIEST",-- Vampiric Embrace
		[127626]	=	"PRIEST",--devouring plague (heal)
		[2944]	=	"PRIEST",--devouring plague (damage)
		[585]	=	"PRIEST", --smite
		[47666]	=	"PRIEST", --penance
		[14914]	=	"PRIEST", --holy fire
		[81751]	=	"PRIEST",  --atonement
		[47753]	=	"PRIEST",  --divine aegis
		[33110]	=	"PRIEST", --prayer of mending
		[77489]	=	"PRIEST", --mastery echo of light
		[596]	=	"PRIEST", --prayer of healing
		[34861]	=	"PRIEST", --circle of healing
		[139]	=	"PRIEST", --renew
		[120692]	=	"PRIEST", --halo
		[2060]	=	"PRIEST", --greater heal
		[110745]	=	"PRIEST", --divine star
		[2061]	=	"PRIEST", --flash heal
		[88686]	=	"PRIEST", --santuary
		[17]		=	"PRIEST", --power word: shield
		[129250]	=	"PRIEST", --power word: solace
	
	--rogue
		[112974]	=	"ROGUE", -- "Leeching Poison"
		[13877]	=	"ROGUE", -- "Blade Flurry"
		[57934]	=	"ROGUE", -- "Tricks of the Trade"
		[152151]	=	"ROGUE", -- "Shadow Reflection"
		[3408]	=	"ROGUE", -- "Crippling Poison"
		[157584]	=	"ROGUE", -- "Instant Poison"
		[114018]	=	"ROGUE", -- "Shroud of Concealment"
		[152150]	=	"ROGUE", -- "Death from Above"
		[168963]	=	"ROGUE", -- "Rupture"
		[22482]	=	"ROGUE", -- "Blade Flurry"
		[57841]	=	"ROGUE", -- "Killing Spree"
		[57842]	=	"ROGUE", -- "Killing Spree Off-Hand"
		[79136]	=	"ROGUE", -- "Venomous Wound"
		[157607]	=	"ROGUE", -- Instant Poison
		[86392]	=	"ROGUE", -- "Main Gauche"
		[74001] 	= 	"ROGUE", -- Combat Readiness
		[14183] 	= 	"ROGUE", -- Premeditation
		[108211] 	= 	"ROGUE", -- Leeching Poison
		--[5761] 	= 	"ROGUE", -- Mind-numbing Poison
		[8679] 	= 	"ROGUE", -- Wound Poison
		
		[137584] 	= 	"ROGUE", -- Shuriken Toss
		[137585] 	= 	"ROGUE", -- Shuriken Toss Off-hand
		[1833] 	= 	"ROGUE", -- Cheap Shot
		[121733] 	= 	"ROGUE", -- Throw
		[1776] 	= 	"ROGUE", -- Gouge
		[108212]	=	"ROGUE", -- Burst of Speed
		[27576]	=	"ROGUE", -- Mutilate Off-Hand
		[1329]	=	"ROGUE", -- Mutilate
		[5171]	=	"ROGUE", -- Slice and Dice
		[2983]	=	"ROGUE", -- Sprint
		[1966]	=	"ROGUE", -- Feint
		[36554]	=	"ROGUE", -- Shadowstep
		[31224]	=	"ROGUE", -- Cloak of Shadows
		[1784]	=	"ROGUE", -- Stealth
		[84617]	=	"ROGUE", -- Revealing Strike
		[13750]	=	"ROGUE", -- Adrenaline Rush
		[1752]	=	"ROGUE", -- Sinister Strike
		[51690]	=	"ROGUE", -- Killing Spree
		[1766]	=	"ROGUE", -- Kick
		[76577]	=	"ROGUE", -- Smoke Bomb
		[5277]	=	"ROGUE", -- Evasion
		[137619]	=	"ROGUE", -- Marked for Death
		[79140]	=	"ROGUE", -- Vendetta
		[51713]	=	"ROGUE", -- Shadow Dance
		[2823]	=	"ROGUE", -- Deadly Poison
		[115191]	=	"ROGUE", -- Stealth
		[14185]	=	"ROGUE", -- Preparation
		[2094]	=	"ROGUE", -- Blind
		[121411]	=	"ROGUE", -- Crimson Tempest
		[53]		= 	"ROGUE", --backstab
		[8680]	= 	"ROGUE", --wound pouson
		[2098]	= 	"ROGUE", --eviscerate
		[2818]	=	"ROGUE", --deadly poison
		[113780]	=	"ROGUE", --deadly poison
		[51723]	=	"ROGUE", --fan of knifes
		[111240]	=	"ROGUE", --dispatch
		[703]	=	"ROGUE", --garrote
		[1943]	=	"ROGUE", --rupture
		[114014]	=	"ROGUE", --shuriken toss
		[16511]	=	"ROGUE", --hemorrhage
		[89775]	=	"ROGUE", --hemorrhage
		[8676]	=	"ROGUE", --amcush
		[5374]	=	"ROGUE", --mutilate
		[32645]	=	"ROGUE", --envenom
		[1943]	=	"ROGUE", --rupture
		[73651]	=	"ROGUE", --Recuperate (heal)
		[35546]	=	"ROGUE", --combat potency (energy)
		[98440]	=	"ROGUE", --relentless strikes (energy)
		[51637]	=	"ROGUE", --venomous vim (energy)
		
	--shaman
		[55533]	=	"SHAMAN", -- "Glyph of Healing Wave"
		[157503]	=	"SHAMAN", -- "Cloudburst"
		[137808]	=	"SHAMAN", -- "Flames of Life"
		[114911]	=	"SHAMAN", -- "Ancestral Guidance"
		[165344]	=	"SHAMAN", -- "Ascendance"
		[157153]	=	"SHAMAN", -- "Cloudburst Totem"
		[152256]	=	"SHAMAN", -- "Storm Elemental Totem"
		[21169]	=	"SHAMAN", -- "Reincarnation"
		[2008]	=	"SHAMAN", -- "Ancestral Spirit"
		[73685]	=	"SHAMAN", -- "Unleash Life"
		[165462]	=	"SHAMAN", -- "Unleash Flame"
		[152255]	=	"SHAMAN", -- "Liquid Magma"
		[8190]	=	"SHAMAN", -- "Magma Totem"
		[108287]	=	"SHAMAN", -- "Totemic Projection"
		[8349]	=	"SHAMAN", -- "Fire Nova"
		[77478]	=	"SHAMAN", -- "Earthquake"
		[114089]	=	"SHAMAN", -- "Windlash"
		[114093]	=	"SHAMAN", -- "Windlash Off-Hand"
		[115357]	=	"SHAMAN", -- "Windstrike"
		[115360]	=	"SHAMAN", -- "Windstrike Off-Hand"
		[88767]	=	"SHAMAN", -- "Fulmination"
		[170379]	=	"SHAMAN", -- "Molten Earth"
		[177601]	=	"SHAMAN", -- "Liquid Magma"
		[10444]	=	"SHAMAN", -- "Flametongue Attack"
		[32176]	=	"SHAMAN", -- "Stormstrike Off-Hand"
		[51886] 	= 	"SHAMAN", -- Cleanse Spirit
		[98008] 	= 	"SHAMAN", -- Spirit Link Totem
		[8177] 	= 	"SHAMAN", -- Grounding Totem
		[8143] 	= 	"SHAMAN", -- Tremor Totem
		[108273] 	= 	"SHAMAN", -- Windwalk Totem
		[51514] 	= 	"SHAMAN", -- Hex
		[114074] 	= 	"SHAMAN", -- Lava Beam
		[2894]	=	"SHAMAN", -- Fire Elemental Totem
		[2825]	=	"SHAMAN", -- Bloodlust
		[114049]	=	"SHAMAN", -- Ascendance
		[73680]	=	"SHAMAN", -- Unleash Elements
		[5394]	=	"SHAMAN", -- Healing Stream Totem
		[108280]	=	"SHAMAN", -- Healing Tide Totem
		[3599]	=	"SHAMAN", -- Searing Totem
		[73920]	=	"SHAMAN", -- Healing Rain
		[2645]	=	"SHAMAN", -- Ghost Wolf
		[16166]	=	"SHAMAN", -- Elemental Mastery
		[108281]	=	"SHAMAN", -- Ancestral Guidance
		[108270]	=	"SHAMAN", -- Stone Bulwark Totem
		[108285]	=	"SHAMAN", -- Call of the Elements
		[115356]	=	"SHAMAN", -- Stormblast
		[60103]	=	"SHAMAN", -- Lava Lash
		[51533]	=	"SHAMAN", -- Feral Spirit
		[17364]	=	"SHAMAN", -- Stormstrike
		[16188]	=	"SHAMAN", -- Ancestral Swiftness
		[2062]	=	"SHAMAN", -- Earth Elemental Totem
		[51485]	=	"SHAMAN", -- Earthgrab Totem
		[61882]	=	"SHAMAN", -- Earthquake
		[52127]	=	"SHAMAN", -- Water Shield
		[77472]	=	"SHAMAN", -- Greater Healing Wave
		[108269]	=	"SHAMAN", -- Capacitor Totem
		[79206]	=	"SHAMAN", -- Spiritwalker's Grace
		[57994]	=	"SHAMAN", -- Wind Shear
		[108271]	=	"SHAMAN", -- Astral Shift
		[30823]	=	"SHAMAN", --istic Rage
		[77130]	=	"SHAMAN", -- Purify Spirit
		[58875]	=	"SHAMAN", -- Spirit Walk
		[36936]	=	"SHAMAN", -- Totemic Recall
		[8056]	=	"SHAMAN", -- Frost Shock
		[51490]	=	"SHAMAN", --thunderstorm (mana)
		[101033]	=	"SHAMAN", --resurgence (mana)
		[51505]	=	"SHAMAN", --lava burst
		[8050]	=	"SHAMAN", --flame shock
		[117014]	=	"SHAMAN", --elemental blast
		[403]	=	"SHAMAN", --lightning bolt
		[421]	=	"SHAMAN", --chain lightining
		[32175]	=	"SHAMAN", --stormstrike
		[25504]	=	"SHAMAN", --windfury
		[8042]	=	"SHAMAN", --earthshock
		[26364]	=	"SHAMAN", --lightning shield
		[117014]	=	"SHAMAN", --elemental blast
		[73683]	=	"SHAMAN", --unleash flame
		[51522]	=	"SHAMAN", --primal wisdom (mana)
		[114942]	=	"SHAMAN", --healing tide
		[73921]	=	"SHAMAN", --healing rain
		[1064]	=	"SHAMAN", --chain heal
		[52042]	=	"SHAMAN", --healing stream totem
		[61295]	=	"SHAMAN", --riptide
		[114083]	=	"SHAMAN", --restorative mists
		[8004]	=	"SHAMAN", --healing surge
		
	--warlock
		[104318]	=	"WARLOCK", -- fel firebolt
		[270481]	=	"WARLOCK", -- demonfire
		[271971]	=	"WARLOCK", -- dreadbite
		[264178]	=	"WARLOCK", -- demonbolt
		
		[233490]	=	"WARLOCK", -- unstable affliction
		[232670]	=	"WARLOCK", -- shadow bolt
		
		[108447]	=	"WARLOCK", -- "Soul Link"
		[108508]	=	"WARLOCK", -- "Mannoroth's Fury"
		[108482]	=	"WARLOCK", -- "Unbound Will"
		[157897]	=	"WARLOCK", -- "Summon Terrorguard"
		[111771]	=	"WARLOCK", -- "Demonic Gateway"
		[157899]	=	"WARLOCK", -- "Summon Abyssal"
		[157757]	=	"WARLOCK", -- "Summon Doomguard"
		[119915]	=	"WARLOCK", -- "Wrathstorm"
		[137587]	=	"WARLOCK", -- "Kil'jaeden's Cunning"
		[1949]	=	"WARLOCK", -- "Hellfire"
		[171140]	=	"WARLOCK", -- "Shadow Lock"
		[104025]	=	"WARLOCK", -- "Immolation Aura"
		[119905]	=	"WARLOCK", -- "Cauterize Master"
		[119913]	=	"WARLOCK", -- "Fellash"
		[111898]	=	"WARLOCK", -- "Grimoire: Felguard"
		[30146]	=	"WARLOCK", -- "Summon Felguard"
		[119914]	=	"WARLOCK", -- "Felstorm"
		[86121]	=	"WARLOCK", -- "Soul Swap"
		[86213]	=	"WARLOCK", -- "Soul Swap Exhale"
		[157695]	=	"WARLOCK", -- "Demonbolt"	
		[86040]	=	"WARLOCK", -- "Hand of Gul'dan"
		[124915]	=	"WARLOCK", -- "Chaos Wave"
		[22703]	=	"WARLOCK", -- "Infernal Awakening"
		[5857]	=	"WARLOCK", -- "Hellfire"
		[129476]	=	"WARLOCK", -- "Immolation Aura"
		[152108]	=	"WARLOCK", -- "Cataclysm"
		[27285]	=	"WARLOCK", -- "Seed of Corruption"
		[131740]	=	"WARLOCK", -- "Corruption"
		[131737]	=	"WARLOCK", -- "Agony"		
		[131736]	=	"WARLOCK", -- "Unstable Affliction"
		[80240] 	= 	"WARLOCK", -- Havoc
		[112921] 	= 	"WARLOCK", -- Summon Abyssal
		[48020] 	= 	"WARLOCK", -- Demonic Circle: Teleport
		[111397] 	= 	"WARLOCK", -- Blood Horror
		[112869] 	= 	"WARLOCK", -- Summon Observer
		[1454] 	= 	"WARLOCK", -- Life Tap
		[112868] 	= 	"WARLOCK", -- Summon Shivarra
		[112869] 	= 	"WARLOCK", -- Summon Observer
		[120451] 	= 	"WARLOCK", -- Flames of Xoroth
		[29893] 	= 	"WARLOCK", -- Create Soulwell
		[114189] 	= 	"WARLOCK", -- Health Funnel
		[112866] 	= 	"WARLOCK", -- Summon Fel Imp
		[108683] 	= 	"WARLOCK", -- Fire and Brimstone
		[688] 	= 	"WARLOCK", -- Summon Imp
		[113861] 	= 	"WARLOCK", -- Dark Soul: Knowledge
		[112870] 	= 	"WARLOCK", -- Summon Wrathguard
		[104316] 	= 	"WARLOCK", -- Imp Swarm
		[17962]	=	"WARLOCK", -- Conflagrate
		[108359]	=	"WARLOCK", -- Dark Regeneration
		[110913]	=	"WARLOCK", -- Dark Bargain
		[105174]	=	"WARLOCK", -- Hand of Gul'dan
		[697]	=	"WARLOCK", -- Summon Voidwalker
		[6201]	=	"WARLOCK", -- Create Healthstone
		[146739]	=	"WARLOCK", -- Corruption
		[109151]	=	"WARLOCK", -- Demonic Leap
		[104773]	=	"WARLOCK", -- Unending Resolve
		[103958]	=	"WARLOCK", -- Metamorphosis
		[119678]	=	"WARLOCK", -- Soul Swap
		[74434]	=	"WARLOCK", -- Soulburn
		[30283]	=	"WARLOCK", -- Shadowfury
		[113860]	=	"WARLOCK", -- Dark Soul: Misery
		[108503]	=	"WARLOCK", -- Grimoire of Sacrifice
		[104232]	=	"WARLOCK", -- Rain of Fire
		[6353]	=	"WARLOCK", -- Soul Fire
		[689]	=	"WARLOCK", -- Drain Life
		[17877]	=	"WARLOCK", -- Shadowburn
		[113858]	=	"WARLOCK", -- Dark Soul: Instability
		[114635]	=	"WARLOCK", -- Ember Tap
		[27243]	=	"WARLOCK", -- Seed of Corruption
		[6789]	=	"WARLOCK", -- Mortal Coil
		[111400]	=	"WARLOCK", -- Burning Rush
		[124916]	=	"WARLOCK", -- Chaos Wave
		[109773]	=	"WARLOCK", -- Dark Intent
		[112927]	=	"WARLOCK", -- Summon Terrorguard
		[1122]	=	"WARLOCK", -- Summon Infernal
		[108416]	=	"WARLOCK", -- Sacrificial Pact
		[5484]	=	"WARLOCK", -- Howl of Terror
		[29858]	=	"WARLOCK", -- Soulshatter
		[18540]	=	"WARLOCK", -- Summon Doomguard
		[20707]	=	"WARLOCK", -- Soulstone
		[132413]	=	"WARLOCK", -- Shadow Bulwark
		[48018]	=	"WARLOCK", -- Demonic Circle: Summon
		[63106]	=	"WARLOCK", --siphon life
		[1454]	=	"WARLOCK", --life tap
		[103103]	=	"WARLOCK", --malefic grasp
		[980]	=	"WARLOCK", --agony
		[30108]	=	"WARLOCK", --unstable affliction
		[172]	=	"WARLOCK", --corruption	
		[48181]	=	"WARLOCK", --haunt	
		[29722]	=	"WARLOCK", --incenerate
		[348]	=	"WARLOCK", --Immolate
		[116858]	=	"WARLOCK", --Chaos Bolt
		[114654]	=	"WARLOCK", --incinerate
		[108686]	=	"WARLOCK", --immolate
		[108685]	=	"WARLOCK", --conflagrate
		[104233]	=	"WARLOCK", --rain of fire
		[103964]	=	"WARLOCK", --touch os chaos
		[686]	=	"WARLOCK", --shadow bolt
		[140719]	=	"WARLOCK", --hellfire
		[104027]	=	"WARLOCK", --soul fire
		[603]	=	"WARLOCK", --doom
		[108371]	=	"WARLOCK", --Harvest life
		
	--warrior
		[117313]	=	"WARRIOR", -- "Bloodthirst Heal"
		[118779]	=	"WARRIOR", -- "Victory Rush"
		[118340]	=	"WARRIOR", -- "Impending Victory"
		[114029]	=	"WARRIOR", -- "Safeguard"
		[156291]	=	"WARRIOR", -- "Gladiator Stance"
		[772]	=	"WARRIOR", -- "Rend"
		[156321]	=	"WARRIOR", -- "Shield Charge"
		[3411]	=	"WARRIOR", -- "Intervene"
		[12723]	=	"WARRIOR", -- "Sweeping Strikes"
		[34428]	=	"WARRIOR", -- "Victory Rush"
		[44949]	=	"WARRIOR", -- "Whirlwind Off-Hand"
		[176289]	=	"WARRIOR", -- "Siegebreaker"
		[174736]	=	"WARRIOR", -- "Enhanced Rend"
		[167105]	=	"WARRIOR", -- "Colossus Smash"
		[163558]	=	"WARRIOR", -- "Execute Off-Hand"
		[95738]	=	"WARRIOR", -- "Bladestorm Off-Hand"
		[145585]	=	"WARRIOR", -- "Storm Bolt Off-Hand"
		[2565] 	= 	"WARRIOR", -- Shield Block
		[2457] 	= 	"WARRIOR", -- Battle Stance
		[12328] 	= 	"WARRIOR", -- Sweeping Strikes
		[114192] 	= 	"WARRIOR", -- Mocking Banner
		[12323] 	= 	"WARRIOR", -- Piercing Howl
		[5246] 	= 	"WARRIOR", -- Intimidating Shout
		[107566] 	= 	"WARRIOR", -- Staggering Shout
		[86346]	=	"WARRIOR", -- Colossus Smash
		[18499]	=	"WARRIOR", -- Berserker Rage
		[107570]	=	"WARRIOR", -- Storm Bolt
		[1680]	=	"WARRIOR", -- Whirlwind
		[85384]	=	"WARRIOR", -- Raging Blow Off-Hand
		[85288]	=	"WARRIOR", -- Raging Blow
		[100]	=	"WARRIOR", -- Charge
		[23881]	=	"WARRIOR", -- Bloodthirst
		[118000]	=	"WARRIOR", -- Dragon Roar
		[50622]	=	"WARRIOR", -- Bladestorm
		[46924]	=	"WARRIOR", -- Bladestorm
		[6673]	=	"WARRIOR", -- Battle Shout
		[103840]	=	"WARRIOR", -- Impending Victory
		[5308]	=	"WARRIOR", -- Execute
		[57755]	=	"WARRIOR", -- Heroic Throw
		[871]	=	"WARRIOR", -- Shield Wall
		[97462]	=	"WARRIOR", -- Rallying Cry
		[118038]	=	"WARRIOR", -- Die by the Sword
		[52174]	=	"WARRIOR", -- Heroic Leap
		[1719]	=	"WARRIOR", -- Recklessness
		[1715]	=	"WARRIOR", -- Hamstring
		[107574]	=	"WARRIOR", -- Avatar
		[46968]	=	"WARRIOR", -- Shockwave
		[6343]	=	"WARRIOR", -- Thunder Clap
		[12292]	=	"WARRIOR", -- Bloodbath
		[64382]	=	"WARRIOR", -- Shattering Throw
		[114028]	=	"WARRIOR", -- Mass Spell Reflection
		[55694]	=	"WARRIOR", -- Enraged Regeneration
		[6552]	=	"WARRIOR", -- Pummel
		[6572]	=	"WARRIOR", -- Revenge
		[112048]	=	"WARRIOR", -- Shield Barrier
		[23920]	=	"WARRIOR", -- Spell Reflection
		[12975]	=	"WARRIOR", -- Last Stand
		[355]	=	"WARRIOR", -- Taunt
		[102060]	=	"WARRIOR", -- Disrupting Shout
		[100130]	=	"WARRIOR", --wild strike
		[96103]	=	"WARRIOR", --raging blow
		[12294]	=	"WARRIOR", --mortal strike
		[1464]	=	"WARRIOR", --Slam
		[23922]	=	"WARRIOR", --shield slam
		[20243]	=	"WARRIOR", --devastate
		[115767]	=	"WARRIOR", --deep wounds
		[109128]	=	"WARRIOR", --charge
		[109128]	=	"WARRIOR", --charge
		[12880]	=	"WARRIOR", --enrage
	}

	_detalhes.AbsorbSpells = {

		--priest
			[47753]	=	true,  --Divine Aegis (discipline)
			[17]		=	true,  --Power Word: Shield (discipline)
			[114908]	=	true,  --Spirit Shell (discipline)
			[114214]	=	true,  --Angelic Bulwark (talent)
			[152118]	=	true,  --Clarity of Will (talent)
			
		--death knight
			[48707]	=	true, --Anti-Magic Shell
			[116888]	=	true, --Shroud of Purgatory (talent)
			[51052]	=	true, --Anti-Magic Zone (talent)
			[77535]	=	true, --Blood Shield
			[115635]	=	true, --death barrier
			
		--shaman
			[114893]	=	true, --Stone Bulwark (stone bulwark totem)
			[145379]	=	true, --Barreira da Natureza
			[145378]	=	true, --2P T16

		--paladin
			[86273]	=	true, --Illuminated Healing (holy)
			[65148]	=	true, --Sacred Shield (talent)
		
		--monk
			[116849]	=	true, --Life Cocoon (mistweaver)
			[115295]	=	true, --Guard (brewmaster)
			--[118604]	=	true, --Guard (brewmaster)
			[145051]	=	true, --Prote��o de Niuzao 
			[145056]	=	true, --
			[145441]	=	true, --2P T16
			[145439]	=	true, --2P T16
		
		--warlock
			--[6229]	=	true, --Twilight Ward
			[108366]	=	true, --Soul Leech (talent)
			[108416]	=	true, --Sacrificial Pact (talent)
			[110913]	=	true, --Dark Bargain (talent)
			[7812]	=	true, --Voidwalker's Sacrifice

		--mage
			[11426]	=	true, --Ice Barrier (talent)
			[1463]	=	true, --Incanter's Ward (talent)
		
		--warrior
			[112048]	=	true, -- Shield Barrier (protection)
			
		--others
			[116631]	=	true, -- enchant "Enchant Weapon - Colossus"
			[140380]	=	true, -- trinket "Inscribed Bag of Hydra-Spawn"
			[138925]	=	true, -- trinket "Stolen Relic of Zuldazar"

	}

	local getCooldownsForClass = function(class)
		local result = {}
		for spellId, spellInfo in pairs (_G.DetailsFramework.CooldownsInfo) do
			if (class == spellInfo.class) then
				result[#result+1] = spellId
			end
		end
		return result
	end

	_detalhes.DefensiveCooldownSpells = {
		["DEATHKNIGHT"] = getCooldownsForClass("DEATHKNIGHT"),
		["DRUID"] = getCooldownsForClass("DRUID"),
		["HUNTER"] = getCooldownsForClass("HUNTER"),
		["MAGE"] = getCooldownsForClass("MAGE"),
		["MONK"] = getCooldownsForClass("MONK"),
		["PALADIN"] = getCooldownsForClass("PALADIN"),
		["PRIEST"] = getCooldownsForClass("PRIEST"),
		["ROGUE"] = getCooldownsForClass("ROGUE"),
		["SHAMAN"] = getCooldownsForClass("SHAMAN"),
		["WARLOCK"] = getCooldownsForClass("WARLOCK"),
		["WARRIOR"] = getCooldownsForClass("WARRIOR"),
	}

	_detalhes.HarmfulSpells = {
		
		--death knight
		[49020] 	= 	true, -- obliterate
		[49143] 	=	true, -- frost strike
		[55095] 	= 	true, -- frost fever
		[55078] 	= 	true, -- blood plague
		[49184] 	= 	true, -- howling blast
		[49998] 	= 	true, -- death strike
		[55090] 	= 	true, -- scourge strike
		[47632] 	= 	true, -- death coil
		[108196]	=	true, --Death Siphon
		[47541]	=	true, -- Death Coil
		--[48721]	=	true, -- Blood Boil
		[42650]	=	true, -- Army of the Dead
		[130736]	=	true, -- Soul Reaper
		[45524]	=	true, -- Chains of Ice
		[45462]	=	true, -- Plague Strike
		[85948]	=	true, -- Festering Strike
		--[56815]	=	true, -- Rune Strike
		[108200]	=	true, -- Remorseless Winter
		[45477]	=	true, -- Icy Touch
		[43265]	=	true, -- Death and Decay
		[77575]	=	true, -- Outbreak
		[115989]	=	true, -- Unholy Blight
		--[55050]	=	true, -- Heart Strike
		[114866]	=	true, -- Soul Reaper
		--[73975]	=	true, -- Necrotic Strike
		[130735]	=	true, -- Soul Reaper
		[50842]	=	true, -- Pestilence
		--[45902]	=	true, -- Blood Strike
		[108194]	=	true, --  Asphyxiate
		[77606]	=	true, --  Dark Simulacrum
		
		--druid
		--[80965]	=	 true, --  Skull Bashs
		[78675]	=	 true, --  Solar Beam
		[22570]	=	 true, --  Maim
		[33831]	=	 true, --  Force of Nature
		[102706]	=	 true, --  Force of Nature
		[102355]	=	 true, --  Faerie Swarm
		[16914]	=	 true, --  Hurricane
		[2908]	=	 true, --  Soothe
		--[62078]	=	 true, --  Swipe
		[106996]	=	 true, --  Astral Storm
		--[6785]	=	 true, --  Ravage
		[33891]	=	 true, --  Incarnation: Tree of Life
		[102359]	=	 true, --  Mass Entanglement
		[5211]	=	 true, --  Mighty Bash
		--[102795]	=	 true, --  Bear Hug
		[1822] 	= 	true, --rake
		[1079] 	= 	true, --rip
		[5221] 	= 	true, --shred
		--[33876] 	=	true, --mangle
		--[102545] 	= 	true, --ravage!
		[5176]	=	true, --wrath
		[93402]	=	true, --sunfire
		[2912]	=	true, --starfire
		[8921]	=	true, --moonfire
		[6807]	=	 true, -- Maul
		[33745]	=	 true, -- Lacerate
		[770]	=	 true, -- Faerie Fire
		[22568]	=	 true, -- Ferocious Bite
		--[779]	=	 true, -- Swipe
		[77758]	=	 true, -- Thrash
		[106830]	=	 true, -- Thrash
		--[114236]	=	 true, -- Shred!
		[48505]	=	 true, -- Starfall
		[78674]	=	 true, -- Starsurge
		--[80964]	=	 true, -- Skull Bash	
		
		--hunter
		--[19503]	=	true,--  Scatter Shot
		[109259]	=	true,--  Powershot
		[20736]	=	true,--  Distracting Shot
		[131900]	=	true, --a murder of crows
		[118253]	=	true, --serpent sting
		[77767]	=	true, --cobra shot
		[3044]	=	true, --arcane shot
		[53301]	=	true, --explosive shot
		[120361]	=	true, --barrage
		[53351]	=	true, --kill shot
		[3674]	=	true,-- Black Arrow
		[117050]	=	true,-- Glaive Toss
		--[1978]	=	true,-- Serpent Sting
		[34026]	=	true,-- Kill Command		
		[2643]	=	true,-- Multi-Shot
		[109248]	=	true,-- Binding Shot
		[149365]	=	true,-- Dire Beast
		[120679]	=	true,-- Dire Beast		
		[3045]	=	true,-- Rapid Fire
		[19574]	=	true,-- Bestial Wrath
		[19386]	=	true,-- Wyvern Sting
		[19434]	=	true,-- Aimed Shot
		[120697]	=	true,-- Lynx Rush
		[56641]	=	true,-- Steady Shot
		--[34490]	=	true,-- Silencing Shot
		[53209]	=	true,-- Chimera Shot
		--[82928]	=	true,-- Aimed Shot!
		[5116]	=	true,-- Concussive Shot
		[147362]	=	true,-- Counter Shot
		[19801]	=	true,-- Tranquilizing Shot
		--[82654]	=	true,-- Widow Venom
		
		--mage
		[116]	=	true, --frost bolt
		[30455]	=	true, --ice lance
		[84721]	=	true, --frozen orb
		[1449]	=	true, --arcane explosion
		[113092]	=	true, --frost bomb
		[115757]	=	true, --frost nova
		[44614]	=	true, --forstfire bolt
		[42208]	=	true, --blizzard
		[11366]	=	true, --pyroblast
		[133]	=	true, --fireball
		[108853]	=	true, --infernoblast
		[2948]	=	true, --scorch
		[30451]	=	true, --arcane blase
		[44457]	=	true,-- Living Bomb
		[84714]	=	true,-- Frozen Orb
		[11129]	=	true,-- Combustion
		[112948]	=	true,-- Frost Bomb
		[2139]	=	true,-- Counterspell
		[2136]	=	true,-- Fire Blast
		[7268]	=	true,-- Arcane Missiles
		[114923]	=	true,-- Nether Tempest
		[2120]	=	true,-- Flamestrike
		[44425]	=	true,-- Arcane Barrage
		[44572]	=	true,-- Deep Freeze
		[113724]	=	true,-- Ring of Frost
		[31661]	=	true,--  Dragon's Breath
		
		--monk
		[107428]	=	true, --rising sun kick
		[100784]	=	true, --blackout kick
		[132467]	=	true, --Chi wave	
		[107270]	=	true, --spinning crane kick
		[100787]	=	true, --tiger palm
		[132463]	=	true, -- shi wave
		[100780]	=	true, -- Jab
		[115698]	=	true, -- Jab
		[108557]	=	true, -- Jab
		[115693]	=	true, -- Jab
		[101545]	=	true, -- Flying Serpent Kick
		[122470]	=	true, -- Touch of Karma
		[117418]	=	true, -- Fists of Fury
		[113656]	=	true, -- Fists of Fury
		[115098]	=	true, -- Chi Wave
		[117952]	=	true, -- Crackling Jade Lightning
		[115078]	=	true, -- Paralysis
		[116705]	=	true, -- Spear Hand Strike
		--[116709]	=	true, -- Spear Hand Strike
		[101546]	=	true, -- Spinning Crane Kick
		[116847]	=	true, -- Rushing Jade Wind
		[115181]	=	true, -- Breath of Fire
		[121253]	=	true, -- Keg Smash
		[124506]	=	true, -- Gift of the Ox
		[124503]	=	true, -- Gift of the Ox
		[124507]	=	true, -- Gift of the Ox
		[115080]	=	true, -- Touch of Death
		[119381]	=	true, -- Leg Sweep
		[115695]	=	true, -- Jab
		[137639]	=	true, -- Storm, Earth, and Fire
		--[115073]	=	true, -- Spinning Fire Blossom
		[115008]	=	true, -- Chi Torpedo
		[121828]	=	true, -- --Chi Torpedo 
		[115180]	=	true, -- Dizzying Haze
		[123986]	=	true, -- Chi Burst
		[130654]	=	true, -- Chi Burst
		[148135]	=	true, -- Chi Burst
		[119392]	=	true, -- Charging Ox Wave
		[116095]	=	true, -- Disable
		[115687]	=	true, -- Jab		
		[117993]	=	true, -- Chi Torpedo
		
		--paladin
		[35395]	=	true,--cruzade strike
		[879]	=	true,--exorcism
		[85256]	=	true,--templar's verdict
		[31935]	=	true,--avenger's shield
		[20271]	=	true, --judgment
		[35395]	=	true, --cruzader strike
		[81297]	=	true, --consacration
		[31803]	=	true, --censure
		[20473]	=	true,-- Holy Shock	
		[114158]	=	true,-- Light's Hammer
		[24275]	=	true,-- Hammer of Wrath
		[88263]	=	true,-- Hammer of the Righteous
		[53595]	=	true,-- Hammer of the Righteous
		[53600]	=	true,-- Shield of the Righteous
		[26573]	=	true,-- Consecration
		[119072]	=	true,-- Holy Wrath
		[105593]	=	true,-- Fist of Justice
		[122032]	=	true,-- Exorcism
		[96231]	=	true,-- Rebuke
		[115750]	=	true,-- Blinding Light
		[53385]	=	true,-- Divine Storm
		[116467] 	= 	true, -- Consecration
		[31801] 	= 	true, -- Seal of Truth
		[20165] 	= 	true, -- Seal of Insight
		
		--priest
		[589]	=	true, --shadow word: pain
		[34914]	=	true, --vampiric touch
		[15407]	=	true, --mind flay
		[8092]	=	true, --mind blast
		[15290]	=	true,-- Vampiric Embrace
		[2944]	=	true,--devouring plague (damage)
		[585]	=	true, --smite
		[47666]	=	true, --penance
		[14914]	=	true, --holy fire
		[48045]	=	true, -- Mind Sear
		[49821]	=	true, -- Mind Sear		
		[32379]	=	true, -- Shadow Word: Death
		[129176]	=	true, -- Shadow Word: Death
		[120517]	=	true, -- Halo
		[120644]	=	true, -- Halo
		[15487]	=	true, -- Silence
		[129197]	=	true, -- Mind Flay (Insanity)
		[108920]	=	true, -- Void Tendrils
		[73510] 	= 	true, -- Mind Spike
		[127632] 	= 	true, -- Cascade
		--[108921] 	= 	true, -- Psyfiend
		[88625] 	= 	true, -- Holy Word: Chastise
		
		--rogue
		[53]		= 	true, --backstab
		[2098]	= 	true, --eviscerate
		[51723]	=	true, --fan of knifes
		[111240]	=	true, --dispatch
		[703]	=	true, --garrote
		[1943]	=	true, --rupture
		[114014]	=	true, --shuriken toss
		[16511]	=	true, --hemorrhage
		[89775]	=	true, --hemorrhage
		[8676]	=	true, --amcush
		[5374]	=	true, --mutilate
		[32645]	=	true, --envenom
		[1943]	=	true, --rupture
		[27576]	=	true, -- Mutilate Off-Hand
		[1329]	=	true, -- Mutilate
		[84617]	=	true, -- Revealing Strike
		[1752]	=	true, -- Sinister Strike
		--[121473]	=	true, -- Shadow Blade
		--[121474]	=	true, -- Shadow Blade Off-hand
		[1766]	=	true, -- Kick
		--[8647]	=	true, -- Expose Armor
		[2094]	=	true, -- Blind
		[121411]	=	true, -- Crimson Tempest
		[137584] 	= 	true, -- Shuriken Toss
		[137585] 	= 	true, -- Shuriken Toss Off-hand
		[1833] 	= 	true, -- Cheap Shot
		[121733] 	= 	true, -- Throw
		[1776] 	= 	true, -- Gouge		

		--shaman
		[51505]	=	true, --lava burst
		[8050]	=	true, --flame shock
		[117014]	=	true, --elemental blast
		[403]	=	true, --lightning bolt
		--[45284]	=	true, --lightning bolt
		[421]	=	true, --chain lightining
		[32175]	=	true, --stormstrike
		[25504]	=	true, --windfury
		[8042]	=	true, --earthshock
		[26364]	=	true, --lightning shield
		[117014]	=	true, --elemental blast
		[73683]	=	true, --unleash flame
		[115356]	=	true, -- Stormblast
		[60103]	=	true, -- Lava Lash
		[17364]	=	true, -- Stormstrike
		[61882]	=	true, -- Earthquake
		[57994]	=	true, -- Wind Shear
		[8056]	=	true, -- Frost Shock
		[114074] 	= 	true, -- Lava Beam

		--warlock
		--[77799]	=	true, --fel flame
		[63106]	=	true, --siphon life
		[103103]	=	true, --malefic grasp
		[980]	=	true, --agony
		[30108]	=	true, --unstable affliction
		[172]	=	true, --corruption	
		[48181]	=	true, --haunt	
		[29722]	=	true, --incenerate
		[348]	=	true, --Immolate
		[116858]	=	true, --Chaos Bolt
		[114654]	=	true, --incinerate
		[108686]	=	true, --immolate
		[108685]	=	true, --conflagrate
		[104233]	=	true, --rain of fire
		[103964]	=	true, --touch os chaos
		[686]	=	true, --shadow bolt
		--[114328]	=	true, --shadow bolt glyph
		[140719]	=	true, --hellfire
		[104027]	=	true, --soul fire
		[603]	=	true, --doom
		[108371]	=	true, --Harvest life
		[17962]	=	true, -- Conflagrate
		[105174]	=	true, -- Hand of Gul'dan
		[146739]	=	true, -- Corruption
		[30283]	=	true, -- Shadowfury
		[104232]	=	true, -- Rain of Fire
		[6353]	=	true, -- Soul Fire
		[689]	=	true, -- Drain Life
		[17877]	=	true, -- Shadowburn
		--[1490]	=	true, -- Curse of the Elements
		[27243]	=	true, -- Seed of Corruption
		[6789]	=	true, -- Mortal Coil
		[124916]	=	true, -- Chaos Wave
		--[1120]	=	true, -- Drain Soul
		[5484]	=	true, -- Howl of Terror
		--[89420]	=	true, -- Drain Life
		--[109466]	=	true, -- Curse of Enfeeblement
		--[112092] 	= 	true, -- Shadow Bolt
		--[103967] 	= 	true, -- Carrion Swarm
		
		--warrior
		[100130]	=	true, --wild strike
		[96103]	=	true, --raging blow
		[12294]	=	true, --mortal strike
		[1464]	=	true, --Slam
		[23922]	=	true, --shield slam
		[20243]	=	true, --devastate
		--[11800]	=	true, --dragon roar
		[115767]	=	true, --deep wounds
		[109128]	=	true, --charge
		--[11294]	=	true, --mortal strike
		--[29842]	=	true, --undribled wrath
		[86346]	=	true, -- Colossus Smash
		[107570]	=	true, -- Storm Bolt
		[1680]	=	true, -- Whirlwind
		[85384]	=	true, -- Raging Blow Off-Hand
		[85288]	=	true, -- Raging Blow
		--[7384]	=	true, -- Overpower
		[23881]	=	true, -- Bloodthirst
		[118000]	=	true, -- Dragon Roar
		[50622]	=	true, -- Bladestorm
		[46924]	=	true, -- Bladestorm
		[103840]	=	true, -- Impending Victory
		[5308]	=	true, -- Execute
		[57755]	=	true, -- Heroic Throw
		[1715]	=	true, -- Hamstring
		[46968]	=	true, -- Shockwave
		[6343]	=	true, -- Thunder Clap
		[64382]	=	true, -- Shattering Throw
		[6552]	=	true, -- Pummel
		[6572]	=	true, -- Revenge
		[102060]	=	true, -- Disrupting Shout
		[12323] 	= 	true, -- Piercing Howl
		--[122475] 	= 	true, -- Throw
		--[845] 	= 	true, -- Cleave
		[5246] 	= 	true, -- Intimidating Shout
		--[7386] 	= 	true, -- Sunder Armor
		[107566] 	= 	true, -- Staggering Shout
	}
	
	_detalhes.MiscClassSpells = {
		--death knight
		[49576]	=	true, -- Death Grip
		[56222]	=	true, -- Dark Command
		[47528]	=	true, -- Mind Freeze (interrupt)
		[123693]	=	true, -- Plague Leech (consume plegue, get 2 deathrunes)
		[3714]	=	true, -- Path of Frost
		[48263]	=	true, -- Blood Presence
		[47568]	=	true, -- Empower Rune Weapon
		[57330]	=	true, -- Horn of Winter (buff)
		[45529]	=	true, -- Blood Tap
		[96268]	=	true, -- Death's Advance (walk faster)
		[48266]	=	true, -- Frost Presence
		[50977]	=	true, --  Death Gate
		[108199]	=	true, --  Gorefiend's Grasp
		[108201]	=	true, --  Desecrated Ground
		[48265]	=	true, --  Unholy Presence
		[61999]	=	true, --  Raise Ally	
		
		--druid
		--[16689]	=	 true, --  Nature's Grasp
		[102417]	=	 true, --  Wild Charge
		--[5229]	=	 true, --  Enrage
		--[9005]	=	 true, --  Pounce
		[114282]	=	 true, --  Treant Form
		[5215]	=	 true, --  Prowl
		[52610]	=	 true, --  Savage Roar
		[102401]	=	 true, --  Wild Charge
		[102793]	=	 true, --  Ursol's Vortex
		[106898]	=	 true, --  Stampeding Roar
		[132158]	=	 true, -- Nature's Swiftness (misc)
		[1126]	=	 true, -- Mark of the Wild (buff)
		[77761]	=	 true, -- Stampeding Roar
		[77764]	=	 true, -- Stampeding Roar
		[16953]	=	 true, -- Primal Fury
		[102693]	=	 true, -- Force of Nature
		[145518]	=	 true, -- Genesis
		[5225]	=	 true, -- Track Humanoids
		[102280]	=	 true, -- Displacer Beast
		[1850]	=	 true, -- Dash
		[108294]	=	 true, -- Heart of the Wild
		[108292]	=	 true, -- Heart of the Wild
		[768]	=	 true, -- Cat Form
		--[127538]	=	 true, -- Savage Roar
		[16979]	=	 true, -- Wild Charge
		[49376]	=	 true, -- Wild Charge
		[6795]	=	 true, -- Growl
		[61391]	=	 true, -- Typhoon
		[24858]	=	 true, -- Moonkin Form
		--[81070]	=	true, --eclipse
		--[29166]	=	true, --innervate
		
		--hunter
		[781]	=	true,-- Disengage
		[82948]	=	true,-- Snake Trap
		[82939]	=	true,-- Explosive Trap
		[82941]	=	true,-- Ice Trap
		[883]	=	true,-- Call Pet 1
		[83242]	=	true,-- Call Pet 2
		[83243]	=	true,-- Call Pet 3
		[83244]	=	true,-- Call Pet 4
		[2641]	=	true,-- Dismiss Pet
		[82726]	=	true,-- Fervor
		[13159]	=	true,-- Aspect of the Pack
		[109260]	=	true,-- Aspect of the Iron Hawk
		[1130]	=	true,--'s Mark
		[5118]	=	true,-- Aspect of the Cheetah
		[34477]	=	true,-- Misdirection
		[19577]	=	true,-- Intimidation
		[83245]	=	true,--  Call Pet 5
		[51753]	=	true,--  Camouflage
		--[13165]	=	true,--  Aspect of the Hawk
		[53271]	=	true,--  Master's Call
		[1543]	=	true,--  Flare
		
		--mage
		[1953]	=	true,-- Blink
		[108843]	=	true,-- Blazing Speed
		[55342]	=	true,-- Mirror Image
		[110960]	=	true,-- Greater Invisibility
		[110959]	=	true,-- Greater Invisibility
		[11958]	=	true,-- Cold Snap
		[61316]	=	true,-- Dalaran Brilliance
		[1459]	=	true,-- Arcane Brilliance
		[116011]	=	true,-- Rune of Power
		[116014]	=	true,-- Rune of Power
		[132627]	=	true,-- Teleport: Vale of Eternal Blossoms
		[31687]	=	true,-- Summon Water Elemental
		[3567]	=	true,-- Teleport: Orgrimmar
		[30449]	=	true,-- Spellsteal
		[132626]	=	true,-- Portal: Vale of Eternal Blossoms
		[12051]	=	true, --evocation
		[108839]	=	true,--  Ice Floes
		[7302]	=	true,--  Frost Armor
		[53140]	=	true,--  Teleport: Dalaran
		[11417]	=	true,--  Portal: Orgrimmar
		[42955]	=	true,--  Conjure Refreshment
		
		--monk
		[109132]	=	true, -- Roll (neutral)
		[115313]	=	true, -- Summon Jade Serpent Statue
		[116781]	=	true, -- Legacy of the White Tiger
		[115921]	=	true, -- Legacy of the Emperor
		[119582]	=	true, -- Purifying Brew
		[126892]	=	true, -- Zen Pilgrimage
		[121827]	=	true, -- Roll
		[115315]	=	true, -- Summon Black Ox Statue
		[115399]	=	true, -- Chi Brew
		[101643]	=	true, -- Transcendence
		[115546]	=	true, -- Provoke
		[115294]	=	true, -- Mana Tea
		[116680]	=	true, -- Thunder Focus Tea
		[115070]	=	true, -- Stance of the Wise Serpent
		[115069]	=	true, -- Stance of the Sturdy Ox
		
		--paladin
		[85499]	=	true,-- Speed of Light
		--[84963]	=	true,-- Inquisition
		[62124]	=	true,-- Reckoning
		[121783]	=	true,-- Emancipate
		[98057]	=	true,-- Grand Crusader
		[20217]	=	true,-- Blessing of Kings
		[25780]	=	true,-- Righteous Fury
		[20154]	=	true,-- Seal of Righteousness
		[19740]	=	true,-- Blessing of Might
		--[54428] 	= 	true, -- Divine Plea --misc
		[7328] 	= 	true, -- Redemption
		
		--priest
		[8122]	=	true, -- Psychic Scream
		[81700]	=	true, -- Archangel
		[586]	=	true, -- Fade
		[121536]	=	true, -- Angelic Feather
		[121557]	=	true, -- Angelic Feather
		--[64901]	=	true, -- Hymn of Hope
		--[89485]	=	true, -- Inner Focus
		[112833]	=	true, -- Spectral Guise
		--[588]	=	true, -- Inner Fire
		[21562]	=	true, -- Power Word: Fortitude
		--[73413]	=	true, -- Inner Will
		[15473]	=	true, -- Shadowform
		[126135] 	= 	true, -- Lightwell
		[81209] 	= 	true, -- Chakra: Chastise
		[81208] 	= 	true, -- Chakra: Serenity
		[2006] 	= 	true, -- Resurrection
		[1706] 	= 	true, -- Levitate
		
		--rogue
		[108212]	=	true, -- Burst of Speed (misc)
		[5171]	=	true, -- Slice and Dice
		[2983]	=	true, -- Sprint
		[36554]	=	true, -- Shadowstep
		[1784]	=	true, -- Stealth
		[115191]	=	true, -- Stealth
		[2823]	=	true, -- Deadly Poison
		--[108215]	=	true, -- Paralytic Poison
		[14185]	=	true, -- Preparation
		[74001] 	= 	true, -- Combat Readiness
		[14183] 	= 	true, -- Premeditation
		[108211] 	= 	true, -- Leeching Poison
		--[5761] 	= 	true, -- Mind-numbing Poison
		[8679] 	= 	true, -- Wound Poison
		
		--shaman
		[73680]	=	true, -- Unleash Elements (misc)
		[3599]	=	true, -- Searing Totem
		[2645]	=	true, -- Ghost Wolf
		[108285]	=	true, -- Call of the Elements
		--[8024]	=	true, -- Flametongue Weapon
		--[51730]	=	true, -- Earthliving Weapon
		[51485]	=	true, -- Earthgrab Totem
		[108269]	=	true, -- Capacitor Totem
		[79206]	=	true, -- Spiritwalker's Grace
		[58875]	=	true, -- Spirit Walk
		[36936]	=	true, -- Totemic Recall
		[8177] 	= 	true, -- Grounding Totem
		[8143] 	= 	true, -- Tremor Totem
		[108273] 	= 	true, -- Windwalk Totem
		[51514] 	= 	true, -- Hex
		--[73682] 	= 	true, -- Unleash Frost
		--[8033] 	= 	true, -- Frostbrand Weapon
		
		--warlock
		[697]	=	true, -- Summon Voidwalker
		[6201]	=	true, -- Create Healthstone
		[109151]	=	true, -- Demonic Leap
		[103958]	=	true, -- Metamorphosis
		[119678]	=	true, -- Soul Swap
		[74434]	=	true, -- Soulburn
		[108503]	=	true, -- Grimoire of Sacrifice
		[111400]	=	true, -- Burning Rush
		[109773]	=	true, -- Dark Intent
		[112927]	=	true, -- Summon Terrorguard
		[1122]	=	true, -- Summon Infernal
		[18540]	=	true, -- Summon Doomguard
		[29858]	=	true, -- Soulshatter
		[20707]	=	true, -- Soulstone
		[48018]	=	true, -- Demonic Circle: Summon
		[80240] 	= 	true, -- Havoc
		[112921] 	= 	true, -- Summon Abyssal
		[48020] 	= 	true, -- Demonic Circle: Teleport
		[111397] 	= 	true, -- Blood Horror
		[112869] 	= 	true, -- Summon Observer
		[1454] 	= 	true, -- Life Tap
		[112868] 	= 	true, -- Summon Shivarra
		[112869] 	= 	true, -- Summon Observer
		[120451] 	= 	true, -- Flames of Xoroth
		[29893] 	= 	true, -- Create Soulwell
		[112866] 	= 	true, -- Summon Fel Imp
		[108683] 	= 	true, -- Fire and Brimstone
		[688] 	= 	true, -- Summon Imp
		[112870] 	= 	true, -- Summon Wrathguard
		[104316] 	= 	true, -- Imp Swarm
		
		--warrior
		[18499]	=	true, -- Berserker Rage (class)
		[100]	=	true, -- Charge
		[6673]	=	true, -- Battle Shout
		[52174]	=	true, -- Heroic Leap
		[355]	=	true, -- Taunt
		[2457] 	= 	true, -- Battle Stance
		[12328] 	= 	true, -- Sweeping Strikes
		[114192] 	= 	true, -- Mocking Banner
		
	}
	
	_detalhes.AttackCooldownSpells = {
		--death knight
		--[49016]	=	true, -- Unholy Frenzy (attack cd)
		[49206]	=	true, -- Summon Gargoyle (attack cd)
		[49028]	=	true, -- Dancing Rune Weapon (attack cd)
		[51271]	=	true, -- Pillar of Frost (attack cd)
		[63560]	=	true, -- Dark Transformation (pet)
		
		--druid
		[106951]	=	 true, -- Berserk (attack cd)
		[124974]	=	 true, -- Nature's Vigil (attack cd)
		[102543]	=	 true, -- Incarnation: King of the Jungle
		[50334]	=	 true, -- Berserk
		[102558]	=	 true, -- Incarnation: Son of Ursoc
		[102560]	=	 true, -- Incarnation: Chosen of Elune
		[112071]	=	 true, -- Celestial Alignment
		[127663]	=	 true, -- Astral Communion
		[108293]	=	 true, --  Heart of the Wild (attack cd)
		[108291]	=	 true, --  Heart of the Wild
		
		--hunter
		[131894]	=	true,-- A Murder of Crows (attack cd)
		[121818]	=	true,-- Stampede (attack cd)
		[82692]	=	true,-- Focus Fire
		[120360]	=	true,-- Barrage
		
		--mage
		[80353]	=	true,-- Time Warp
		--[131078]	=	true,-- Icy Veins
		[12472]	=	true,-- Icy Veins
		[12043]	=	true,-- Presence of Mind
		[108978]	=	true,-- Alter Time
		[127140]	=	true,-- Alter Time
		[12042]	=	true,-- Arcane Power
		
		--monk
		[116740]	=	true, -- Tigereye Brew (attack cd?)
		[123904]	=	true, -- Invoke Xuen, the White Tiger
		[115288]	=	true, -- Energizing Brew
		
		--paladin
		[31884]	=	true,-- Avenging Wrath
		[105809]	=	true,-- Holy Avenger
		[31842] 	= 	true, -- Divine Favor
		
		--priest
		[34433]	=	true, -- Shadowfiend
		[123040]	=	true, -- Mindbender
		[10060]	=	true, -- Power Infusion
		
		--rogue
		[13750]	=	true, -- Adrenaline Rush (attack cd)
		--[121471]	=	true, -- Shadow Blades
		[137619]	=	true, -- Marked for Death
		[79140]	=	true, -- Vendetta
		[51690]	=	true, -- Killing Spree
		[51713]	=	true, -- Shadow Dance
		[152151]	=	true, -- "Shadow Reflection"
		
		--shaman
		--[120668]	=	true, --Stormlash Totem (attack cd)
		[2894]	=	true, -- Fire Elemental Totem
		[2825]	=	true, -- Bloodlust
		[114049]	=	true, -- Ascendance
		[16166]	=	true, -- Elemental Mastery
		[51533]	=	true, -- Feral Spirit
		[16188]	=	true, -- Ancestral Swiftness
		[2062]	=	true, -- Earth Elemental Totem
		
		--warlock
		[113860]	=	true, -- Dark Soul: Misery (attack cd)
		[113858]	=	true, -- Dark Soul: Instability
		[113861] 	= 	true, -- Dark Soul: Knowledge
		
		--warrior
		[1719]	=	true, -- Recklessness (attack cd)
		--[114207]	=	true, -- Skull Banner
		[107574]	=	true, -- Avatar
		[12292]	=	true, -- Bloodbath
	}
	
	_detalhes.HelpfulSpells = {
		--death knight
		[45470] = true, -- Death Strike (heal)
		[77535] = true, -- Blood Shield (heal)
		[53365] = true, -- Unholy Strength (heal)
		[48707] = true, -- Anti-Magic Shell (heal)
		[48982] = true, -- rune tap
		[119975]	=	true, -- Conversion (heal)
		[48743]	=	true, -- Death Pact (heal)
		
		--druid
		--[33878] =	true, --mangle (energy gain)
		[17057] =	true, --bear form (energy gain)
		[16959] =	true, --primal fury (energy gain)
		[5217] = true, --tiger's fury (energy gain)
		[68285] =	true, --leader of the pack (mana)
		[774]	=	true, --rejuvenation
		--[44203]	=	true, --tranquility
		[48438]	=	true, --wild growth
		[81269]	=	true, --shiftmend
		--[102792]	=	true, --wind moshroom: bloom
		[5185]	=	true, --healing touch
		[8936]	=	true, --regrowth
		[33778]	=	true, --lifebloom
		[48503]	=	true, --living seed
		--[50464]	=	true, --nourish	
		[18562]	=	 true, --Swiftmend (heal)
		[145205]	=	 true, -- Wild Mushroom (heal)
		[33763]	=	 true, -- Lifebloom (heal)
		--[102791]	=	 true, -- Wild Mushroom: Bloom
		[147349]	=	 true, -- Wild Mushroom
		[108238]	=	 true, -- Renewal
		[102351]	=	 true, --  Cenarion Ward

		
		--hunter
		[109304]	=	true,-- Exhilaration (heal)
		
		--mage
		[11426]	=	true, --Ice Barrier (heal)
		[115610]	=	true,-- Temporal Shield
		[111264]	=	true,-- Ice Ward
		
		--monk
		[124682]	=	true, -- Enveloping Mist (helpful)
		[115460]	=	true, -- Healing Sphere
		--[115464]	=	true, -- Healing Sphere	
		[115151]	=	true, -- Renewing Mist
		[122783]	=	true, -- Diffuse Magic
		[147489]	=	true, -- Expel Harm
		[135920]	=	true, -- Gift of the Serpent
		[116841]	=	true, -- Tiger's Lust
		[116694]	=	true, -- Surging Mist
		[115308]	=	true, -- Elusive Brew
		--[135914]	=	true, -- Healing Sphere
		[116844]	=	true, -- Ring of Peace
		[123761]	=	true, --mana tea
		[119611]	=	true, --renewing mist
		[115310]	=	true, --revival
		[116670]	=	true, --uplift
		[115175]	=	true, --soothing mist
		[124041]	=	true, --gift of the serpent
		[124040]	=	true, -- shi torpedo
		[132120]	=	true, -- enveloping mist
		[115295]	=	true, --guard
		[115072]	=	true, --expel harm
		[117895]	=	true, --eminence (statue)
		[115176]	=	true, -- Zen Meditation cooldown
		[115203]	=	true, -- Fortifying Brew
		--[115213]	=	true, -- Avert Harm
		[124081]	=	true, -- Zen Sphere
		[125355]	=	true, -- Healing Sphere
		[122278]	=	true, -- Dampen Harm
		[115450]	=	true, -- Detox
		
		--paladin
		[85673]	=	true,-- Word of Glory (heal)
		[20925]	=	true,-- Sacred Shield
		[53563]	=	true,-- Beacon of Light
		[633]	=	true,-- Lay on Hands
		[114163]	=	true,-- Eternal Flame
		[642]	=	true,-- Divine Shield
		[31821]	=	true,-- Devotion Aura
		[148039]	=	true,-- Sacred Shield
		[82326]	=	true,-- Divine Light
		[20167]	=	true,--seal of insight (mana)
		[65148]	=	true, --Sacred Shield
		[20167]	=	true, --Seal of Insight
		[86273]	=	true, --illuminated healing
		[85222]	=	true, --light of dawn
		[53652]	=	true, --beacon of light
		[82327]	=	true, --holy radiance
		[119952]	=	true, --arcing light
		[25914]	=	true, --holy shock
		[19750]	=	true, --flash of light
		[31850] 	= 	true, -- Ardent Defender --defensive cd
		[1044] 	= 	true, -- Hand of Freedom --helpful
		[114039] 	= 	true, -- Hand of Purity
		[4987] 	= 	true, -- Cleanse
		[136494] 	= 	true, -- Word of Glory
		
		--priest
		[19236] 	= 	true, -- Desperate Prayer
		[47788] 	= 	true, -- Guardian Spirit
		[81206] 	= 	true, -- Chakra: Sanctuary
		[62618] 	= 	true, -- Power Word: Barrier
		[32375] 	= 	true, -- Mass Dispel
		[32546] 	= 	true, -- Binding Heal
		[33110]	=	true, --prayer of mending
		[596]	=	true, --prayer of healing
		[34861]	=	true, --circle of healing
		[139]	=	true, --renew
		[120692]	=	true, --halo
		[2060]	=	true, --greater heal
		[110745]	=	true, --divine star
		[2061]	=	true, --flash heal
		[88686]	=	true, --santuary
		[17]		=	true, --power word: shield
		--[64904]	=	true, --hymn of hope
		[129250]	=	true, --power word: solace
		[121135]	=	true, -- Cascade
		[122121]	=	true, -- Divine Star
		[110744]	=	true, -- Divine Star
		[123258]	=	true, -- Power Word: Shield
		[88685]	=	true, -- Holy Word: Sanctuary
		[88684]	=	true, -- Holy Word: Serenity
		[33076]	=	true, -- Prayer of Mending
		[15286]	=	true, -- Vampiric Embrace
		--[2050]	=	true, -- Heal
		[123259]	=	true, -- Prayer of Mending
		
		--rogue
		[73651]	=	true, --Recuperate (heal)
		[35546]	=	true, --combat potency (energy)
		[98440]	=	true, --relentless strikes (energy)
		[51637]	=	true, --venomous vim (energy)
		[31224]	=	true, -- Cloak of Shadows (cooldown)
		[1966]	=	true, -- Feint (helpful)
		[76577]	=	true, -- Smoke Bomb
		[5277]	=	true, -- Evasion
		
		--shaman
		--[88765]	=	true, --rolling thunder (mana)
		[51490]	=	true, --thunderstorm (mana)
		--[82987]	=	true, --telluric currents glyph (mana)
		[101033]	=	true, --resurgence (mana)
		[51522]	=	true, --primal wisdom (mana)
		--[63375]	=	true, --primal wisdom (mana)
		[114942]	=	true, --healing tide
		[73921]	=	true, --healing rain
		[1064]	=	true, --chain heal
		[52042]	=	true, --healing stream totem
		[61295]	=	true, --riptide
		--[51945]	=	true, --earthliving
		[114083]	=	true, --restorative mists
		[8004]	=	true, --healing surge
		[5394]	=	true, -- Healing Stream Totem (heal)
		[73920]	=	true, -- Healing Rain
		[108270]	=	true, -- Stone Bulwark Totem
		--[331]	=	true, -- Healing Wave
		[52127]	=	true, -- Water Shield
		[77472]	=	true, -- Greater Healing Wave
		[108271]	=	true, -- Astral Shift
		[30823]	=	true, --Shamanistic Rage
		[77130]	=	true, -- Purify Spirit
		[51886] 	= 	true, -- Cleanse Spirit
		[98008] 	= 	true, -- Spirit Link Totem
		
		--warlock
		[108359]	=	true, -- Dark Regeneration (helpful)
		[110913]	=	true, -- Dark Bargain
		[104773]	=	true, -- Unending Resolve
		--[6229]	=	true, -- Twilight Ward
		[114635]	=	true, -- Ember Tap
		--[131623]	=	true, -- Twilight Ward
		[108416]	=	true, -- Sacrificial Pact
		[132413]	=	true, -- Shadow Bulwark
		[114189] 	= 	true, -- Health Funnel

		--warrior
		[871]	=	true, -- Shield Wall
		[97462]	=	true, -- Rallying Cry
		[118038]	=	true, -- Die by the Sword
		--[114203]	=	true, -- Demoralizing Banner
		[114028]	=	true, -- Mass Spell Reflection
		[55694]	=	true, -- Enraged Regeneration
		[112048]	=	true, -- Shield Barrier
		[23920]	=	true, -- Spell Reflection
		[12975]	=	true, -- Last Stand
		[2565] 	= 	true, -- Shield Block
	}
	

	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	_detalhes.SpellOverwrite = {
		--[124464] = {name = GetSpellInfo (124464) .. " (" .. Loc ["STRING_MASTERY"] .. ")"}, --> shadow word: pain mastery proc (priest)
	}

	_detalhes.spells_school = {
		[1] = {name = STRING_SCHOOL_PHYSICAL , formated = "|cFFFFFF00" .. STRING_SCHOOL_PHYSICAL .. "|r", hex = "FFFFFF00", rgb = {255, 255, 0}, decimals = {1.00, 1.00, 0.00}},
		[2] = {name = STRING_SCHOOL_HOLY , formated = "|cFFFFE680" .. STRING_SCHOOL_HOLY .. "|r", hex = "FFFFE680", rgb = {255, 230, 128}, decimals = {1.00, 0.90, 0.50}},
		[4] = {name = STRING_SCHOOL_FIRE , formated = "|cFFFF8000" .. STRING_SCHOOL_FIRE .. "|r", hex = "FFFF8000", rgb = {255, 128, 0}, decimals = {1.00, 0.50, 0.00}},
		[8] = {name = STRING_SCHOOL_NATURE , formated = "|cFFbeffbe" .. STRING_SCHOOL_NATURE .. "|r", hex = "FFbeffbe", rgb = {190, 190, 190}, decimals = {0.7451, 1.0000, 0.7451}},
		[16] = {name = STRING_SCHOOL_FROST, formated = "|cFF80FFFF" .. STRING_SCHOOL_FROST .. "|r", hex = "FF80FFFF", rgb = {128, 255, 255}, decimals = {0.50, 1.00, 1.00}},
		[32] = {name = STRING_SCHOOL_SHADOW, formated = "|cFF8080FF" .. STRING_SCHOOL_SHADOW .. "|r", hex = "FF8080FF", rgb = {128, 128, 255}, decimals = {0.50, 0.50, 1.00}},
		[64] = {name = STRING_SCHOOL_ARCANE, formated = "|cFFFF80FF" .. STRING_SCHOOL_ARCANE .. "|r", hex = "FFFF80FF", rgb = {255, 128, 255}, decimals = {1.00, 0.50, 1.00}},
		[3] = {name = STRING_SCHOOL_HOLYSTRIKE , formated = "|cFFFFF240" .. STRING_SCHOOL_HOLYSTRIKE  .. "|r", hex = "FFFFF240", rgb = {255, 64, 64}, decimals = {1.0000, 0.9490, 0.2510}}, --#FFF240
		[5] = {name = STRING_SCHOOL_FLAMESTRIKE, formated = "|cFFFFB900" .. STRING_SCHOOL_FLAMESTRIKE .. "|r", hex = "FFFFB900", rgb = {255, 0, 0}, decimals = {1.0000, 0.7255, 0.0000}}, --#FFB900
		[6] = {name = STRING_SCHOOL_HOLYFIRE , formated = "|cFFFFD266" .. STRING_SCHOOL_HOLYFIRE  .. "|r", hex = "FFFFD266", rgb = {255, 102, 102}, decimals = {1.0000, 0.8235, 0.4000}}, --#FFD266
		[9] = {name = STRING_SCHOOL_STORMSTRIKE, formated = "|cFFAFFF23" .. STRING_SCHOOL_STORMSTRIKE .. "|r", hex = "FFAFFF23", rgb = {175, 35, 35}, decimals = {0.6863, 1.0000, 0.1373}}, --#AFFF23
		[10] = {name = STRING_SCHOOL_HOLYSTORM , formated = "|cFFC1EF6E" .. STRING_SCHOOL_HOLYSTORM  .. "|r", hex = "FFC1EF6E", rgb = {193, 110, 110}, decimals = {0.7569, 0.9373, 0.4314}}, --#C1EF6E
		[12] = {name = STRING_SCHOOL_FIRESTORM, formated = "|cFFAFB923" .. STRING_SCHOOL_FIRESTORM .. "|r", hex = "FFAFB923", rgb = {175, 35, 35}, decimals = {0.6863, 0.7255, 0.1373}}, --#AFB923
		[17] = {name = STRING_SCHOOL_FROSTSTRIKE , formated = "|cFFB3FF99" .. STRING_SCHOOL_FROSTSTRIKE .. "|r", hex = "FFB3FF99", rgb = {179, 153, 153}, decimals = {0.7020, 1.0000, 0.6000}},--#B3FF99
		[18] = {name = STRING_SCHOOL_HOLYFROST , formated = "|cFFCCF0B3" .. STRING_SCHOOL_HOLYFROST  .. "|r", hex = "FFCCF0B3", rgb = {204, 179, 179}, decimals = {0.8000, 0.9412, 0.7020}},--#CCF0B3
		[20] = {name = STRING_SCHOOL_FROSTFIRE, formated = "|cFFC0C080" .. STRING_SCHOOL_FROSTFIRE .. "|r", hex = "FFC0C080", rgb = {192, 128, 128}, decimals = {0.7529, 0.7529, 0.5020}}, --#C0C080
		[24] = {name = STRING_SCHOOL_FROSTSTORM, formated = "|cFF69FFAF" .. STRING_SCHOOL_FROSTSTORM .. "|r", hex = "FF69FFAF", rgb = {105, 175, 175}, decimals = {0.4118, 1.0000, 0.6863}}, --#69FFAF
		[33] = {name = STRING_SCHOOL_SHADOWSTRIKE , formated = "|cFFC6C673" .. STRING_SCHOOL_SHADOWSTRIKE .. "|r", hex = "FFC6C673", rgb = {198, 115, 115}, decimals = {0.7765, 0.7765, 0.4510}},--#C6C673
		[34] = {name = STRING_SCHOOL_SHADOWHOLY, formated = "|cFFD3C2AC" .. STRING_SCHOOL_SHADOWHOLY .. "|r", hex = "FFD3C2AC", rgb = {211, 172, 172}, decimals = {0.8275, 0.7608, 0.6745}},--#D3C2AC
		[36] = {name = STRING_SCHOOL_SHADOWFLAME , formated = "|cFFB38099" .. STRING_SCHOOL_SHADOWFLAME  .. "|r", hex = "FFB38099", rgb = {179, 153, 153}, decimals = {0.7020, 0.5020, 0.6000}}, -- #B38099
		[40] = {name = STRING_SCHOOL_SHADOWSTORM, formated = "|cFF6CB3B8" .. STRING_SCHOOL_SHADOWSTORM .. "|r", hex = "FF6CB3B8", rgb = {108, 184, 184}, decimals = {0.4235, 0.7020, 0.7216}}, --#6CB3B8
		[48] = {name = STRING_SCHOOL_SHADOWFROST , formated = "|cFF80C6FF" .. STRING_SCHOOL_SHADOWFROST  .. "|r", hex = "FF80C6FF", rgb = {128, 255, 255}, decimals = {0.5020, 0.7765, 1.0000}},--#80C6FF
		[65] = {name = STRING_SCHOOL_SPELLSTRIKE, formated = "|cFFFFCC66" .. STRING_SCHOOL_SPELLSTRIKE .. "|r", hex = "FFFFCC66", rgb = {255, 102, 102}, decimals = {1.0000, 0.8000, 0.4000}},--#FFCC66
		[66] = {name = STRING_SCHOOL_DIVINE, formated = "|cFFFFBDB3" .. STRING_SCHOOL_DIVINE .. "|r", hex = "FFFFBDB3", rgb = {255, 179, 179}, decimals = {1.0000, 0.7412, 0.7020}},--#FFBDB3
		[68] = {name = STRING_SCHOOL_SPELLFIRE, formated = "|cFFFF808C" .. STRING_SCHOOL_SPELLFIRE .. "|r", hex = "FFFF808C", rgb = {255, 140, 140}, decimals = {1.0000, 0.5020, 0.5490}}, --#FF808C
		[72] = {name = STRING_SCHOOL_SPELLSTORM, formated = "|cFFAFB9AF" .. STRING_SCHOOL_SPELLSTORM .. "|r", hex = "FFAFB9AF", rgb = {175, 175, 175}, decimals = {0.6863, 0.7255, 0.6863}}, --#AFB9AF
		[80] = {name = STRING_SCHOOL_SPELLFROST , formated = "|cFFC0C0FF" .. STRING_SCHOOL_SPELLFROST  .. "|r", hex = "FFC0C0FF", rgb = {192, 255, 255}, decimals = {0.7529, 0.7529, 1.0000}},--#C0C0FF
		[96] = {name = STRING_SCHOOL_SPELLSHADOW, formated = "|cFFB980FF" .. STRING_SCHOOL_SPELLSHADOW .. "|r", hex = "FFB980FF", rgb = {185, 255, 255}, decimals = {0.7255, 0.5020, 1.0000}},--#B980FF
		
		[28] = {name = STRING_SCHOOL_ELEMENTAL, formated = "|cFF0070DE" .. STRING_SCHOOL_ELEMENTAL .. "|r", hex = "FF0070DE", rgb = {0, 222, 222}, decimals = {0.0000, 0.4392, 0.8706}},
		[124] = {name = STRING_SCHOOL_CHROMATIC, formated = "|cFFC0C0C0" .. STRING_SCHOOL_CHROMATIC .. "|r", hex = "FFC0C0C0", rgb = {192, 192, 192}, decimals = {0.7529, 0.7529, 0.7529}},
		[126] = {name = STRING_SCHOOL_MAGIC , formated = "|cFF1111FF" .. STRING_SCHOOL_MAGIC  .. "|r", hex = "FF1111FF", rgb = {17, 255, 255}, decimals = {0.0667, 0.0667, 1.0000}},
		[127] = {name = STRING_SCHOOL_CHAOS, formated = "|cFFFF1111" .. STRING_SCHOOL_CHAOS .. "|r", hex = "FFFF1111", rgb = {255, 17, 17}, decimals = {1.0000, 0.0667, 0.0667}},
	--[[custom]]	[1024] = {name = "Reflection", formated = "|cFFFFFFFF" .. "Reflection" .. "|r", hex = "FFFFFFFF", rgb = {255, 255, 255}, decimals = {1, 1, 1}},
	}

	function _detalhes:GetSpellSchoolName (school)
		return _detalhes.spells_school [school] and _detalhes.spells_school [school].name or ""
	end
	function _detalhes:GetSpellSchoolFormatedName (school)
		return _detalhes.spells_school [school] and _detalhes.spells_school [school].formated or ""
	end
	local default_school_color = {145/255, 180/255, 228/255}
	function _detalhes:GetSpellSchoolColor (school)
		return unpack (_detalhes.spells_school [school] and _detalhes.spells_school [school].decimals or default_school_color)
	end
	function _detalhes:GetCooldownList (class)
		class = class or select (2, UnitClass ("player"))
		return _detalhes.DefensiveCooldownSpells [class]
	end
end


--save spells of a segment
local SplitLoadFrame = CreateFrame ("frame")
local MiscContainerNames = {
    "dispell_spells",
    "cooldowns_defensive_spells",
    "debuff_uptime_spells",
    "buff_uptime_spells",
    "interrupt_spells",
    "cc_done_spells",
    "cc_break_spells",
    "ress_spells",
}
local SplitLoadFunc = function (self, deltaTime)
    --which container it will iterate on this tick
    local container = Details.tabela_vigente and Details.tabela_vigente [SplitLoadFrame.NextActorContainer] and Details.tabela_vigente [SplitLoadFrame.NextActorContainer]._ActorTable

    if (not container) then
        if (Details.debug) then
            Details:Msg ("(debug) finished index spells.")
        end
        SplitLoadFrame:SetScript ("OnUpdate", nil)
        return
    end
    
    local inInstance = IsInInstance()
    local isEncounter = Details.tabela_vigente and Details.tabela_vigente.is_boss
    local encounterID = isEncounter and isEncounter.id
    
    --get the actor
    local actorToIndex = container [SplitLoadFrame.NextActorIndex]
    
    --no actor? go to the next container
    if (not actorToIndex) then
        SplitLoadFrame.NextActorIndex = 1
        SplitLoadFrame.NextActorContainer = SplitLoadFrame.NextActorContainer + 1
        
        --finished all the 4 container? kill the process
        if (SplitLoadFrame.NextActorContainer == 5) then
            SplitLoadFrame:SetScript ("OnUpdate", nil)
            if (Details.debug) then
                Details:Msg ("(debug) finished index spells.")
            end
            return
        end
    else
        --++
        SplitLoadFrame.NextActorIndex = SplitLoadFrame.NextActorIndex + 1
        
        --get the class name or the actor name in case the actor isn't a player
        local source
        if (inInstance) then
            source = RAID_CLASS_COLORS [actorToIndex.classe] and Details.classstring_to_classid [actorToIndex.classe] or actorToIndex.nome
        else
            source = RAID_CLASS_COLORS [actorToIndex.classe] and Details.classstring_to_classid [actorToIndex.classe]
        end
        
        --if found a valid actor
        if (source) then
            --if is damage, heal or energy
            if (SplitLoadFrame.NextActorContainer == 1 or SplitLoadFrame.NextActorContainer == 2 or SplitLoadFrame.NextActorContainer == 3) then
                --get the spell list in the spells container
                local spellList = actorToIndex.spells and actorToIndex.spells._ActorTable
                if (spellList) then
                
                    local SpellPool = Details.spell_pool
                    local EncounterSpellPool = Details.encounter_spell_pool
                    
                    for spellID, _ in pairs (spellList) do
                        if (not SpellPool [spellID]) then
                            SpellPool [spellID] = source
                        end
                        if (encounterID and not EncounterSpellPool [spellID]) then
                            if (actorToIndex:IsEnemy()) then
                                EncounterSpellPool [spellID] = {encounterID, source}
                            end
                        end
                    end
                end
            
            --if is a misc container
            elseif (SplitLoadFrame.NextActorContainer == 4) then
                for _, containerName in ipairs (MiscContainerNames) do 
                    --check if the actor have this container
                    if (actorToIndex [containerName]) then
                        local spellList = actorToIndex [containerName]._ActorTable
                        if (spellList) then
                        
                            local SpellPool = Details.spell_pool
                            local EncounterSpellPool = Details.encounter_spell_pool
                            
                            for spellID, _ in pairs (spellList) do
                                if (not SpellPool [spellID]) then
                                    SpellPool [spellID] = source
                                end
                                if (encounterID and not EncounterSpellPool [spellID]) then
                                    if (actorToIndex:IsEnemy()) then
                                        EncounterSpellPool [spellID] = {encounterID, source}
                                    end
                                end
                            end
                        end
                    end
                end
                
                --spells the actor casted
                if (actorToIndex.spell_cast) then
                    local SpellPool = Details.spell_pool
                    local EncounterSpellPool = Details.encounter_spell_pool
                    
                    for spellID, _ in pairs (actorToIndex.spell_cast) do
                        if (not SpellPool [spellID]) then
                            SpellPool [spellID] = source
                        end
                        if (encounterID and not EncounterSpellPool [spellID]) then
                            if (actorToIndex:IsEnemy()) then
                                EncounterSpellPool [spellID] = {encounterID, source}
                            end
                        end
                    end
                end
            end
        end
    end
end

function Details.StoreSpells()
    if (Details.debug) then
        Details:Msg ("(debug) started to index spells.")
    end
    SplitLoadFrame:SetScript ("OnUpdate", SplitLoadFunc)
    SplitLoadFrame.NextActorContainer = 1
    SplitLoadFrame.NextActorIndex = 1
end
