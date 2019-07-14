do
--doq
	local _detalhes = 		_G._detalhes
	
	_detalhes.PotionList = {
		--> MoP
--		[105702] = true, --jade serpent
--		[105706] = true, --mogu power
--		[105697] = true, --virmen's bite
--		[105698] = true, --montains

		--> WoD
--		[156426] = true, --draenic intellect potion
--		[156430] = true, --draenic armor potion
--		[156423] = true, --draenic agility potion
--		[156428] = true, --draenic strength potion
--		[175821] = true, --draenic pure rage potion

		--> Legion
--		[188028] = true, --Potion of the Old War
--		[188027] = true, --Potion of Deadly Grace
--		[188029] = true, --Unbending Potion
--		[188017] = true, --Ancient Mana Potion
--		[188030] = true, --Leytorrent Potion
--		[229206] = true, --Potion of Prolongued Power
		
		--mana and heal potions
--		[188016] = true, --Ancient Healing Potion
--		[188018] = true, --Ancient Rejuvenation Potion
		
		--flask
--		[188033] = true, --Flask of the Seventh Demon
--		[188031] = true, --Flask of the Whispered Pact
--		[188034] = true, --Flask of the Countless Armies
--		[188035] = true, --Flask of Ten Thousand Scars
	}
	
	--import potion list from the framework
	for spellID, _ in pairs (DetailsFramework.PotionIDs) do
		_detalhes.PotionList [spellID] = true
	end
	
	_detalhes.SpecSpellList = { --~spec

		-- havoc demon hunter --577
		[198793] = 577, -- "Vengeful Retreat"
		[162243] = 577, -- "Demon's Bite"
		--[213241] = 577, -- "Felblade" --both specs has
		--[213243] = 577, -- "Felblade"
		[179057] = 577, -- "Chaos Nova"
		[188499] = 577, -- "Blade Dance"
		[198013] = 577, -- "Eye Beam"
		--[201467] = 577, -- "Fury of the Illidari" --removed from the game
		[178963] = 577, -- "Consume Soul"
		[162794] = 577, -- "Chaos Strike"
		[211881] = 577, -- "Fel Eruption"
		[201427] = 577, -- "Annihilation"
		[210152] = 577, -- "Death Sweep"
	
		-- vengeance demon hunter --581
		[203782] = 581, -- "Shear"
		[203720] = 581, -- "Demon Spikes"
		[218256] = 581, -- "Empower Wards"
		[203798] = 581, -- "Soul Cleave"
		[202137] = 581, -- "Sigil of Silence"
		[204490] = 581, -- "Sigil of Silence"
		[204596] = 581, -- "Sigil of Flame"
		[204598] = 581, -- "Sigil of Flame"
		[204021] = 581, -- "Fiery Brand"
		[202138] = 581, -- "Sigil of Chains"
		[207407] = 581, -- "Soul Carver"

		-- Unholy Death Knight:
		--[165395] = 252, -- Necrosis --removed from the game
		[49206] = 252, -- Summon Gargoyle
		[63560] = 252, -- Dark Transformation
		[85948] = 252, -- Festering Strike
		--[49572] = 252, -- Shadow Infusion --removed from the game
		[55090] = 252, -- Scourge Strike
		[46584] = 252, -- Raise Dead
		--[51160] = 252, -- Ebon Plaguebringer --removed from the game 
		[77575] = 252, --Outbreak --added July 7
		[47541] = 252, --Death Coil --added July 7
		[191587] = 252, --Virulent Plague  --added July 7
		
		-- Frost Death Knight:
		--[130735] = 251, -- Soul Reaper --removed from the game 
		[51271] = 251, -- Pillar of Frost
		[49020] = 251, -- Obliterate --old?
		[66198] = 251, -- Obliterate Off-Hand
		[222024] = 251, -- Obliterate
		[49143] = 251, -- Frost Strike --old?
		[222026] = 251, -- Frost Strike
		[66196] = 251, -- Frost Strike Off-Hand
		[49184] = 251, -- Howling Blast
		
		-- Blood Death Knight:
		--[165394] = 250, -- Runic Strikes --removed from the game 
		[114866] = 250, -- Soul Reaper
		--[49222] = 250, -- Bone Shield --removed from the game 
		[55233] = 250, -- Vampiric Blood
		[49028] = 250, -- Dancing Rune Weapon
		[48982] = 250, -- Rune Tap
		[56222] = 250, -- Dark Command
		[206930] = 250, --Heart Strike --added July 7
		[50842] = 250, --Blood Boil --added July 7
		[195182] = 250, --Marrowrend --added July 7
		
		-- Balance Druid:
		[48505] = 102, -- Starfall
		[112071] = 102, -- Celestial Alignment
		[78675] = 102, -- Solar Beam
		[93399] = 102, -- Shooting Stars
		--[2912] = 102, -- Starfire --both specs has
		--[78674] = 102, -- Starsurge

		-- Feral Druid:
		--[171746] = 103, -- Claws of Shirvallah --removed from the game 
		[22570] = 103, -- Maim
		[16974] = 103, -- Predatory Swiftness
		[52610] = 103, -- Savage Roar
		[5217] = 103, -- Tiger's Fury
		--[1822] = 103, -- Rake
		--[106785] = 103, -- Swipe
		--[1079] = 103, -- Rip
		
		-- Guardian Druid:
		[155835] = 104, -- Bristling Fur
		[155578] = 104, -- Guardian of Elune
		[80313] = 104, -- Pulverize
		--[159232] = 104, -- Ursa Major --removed from the game 
		--[33745] = 104, -- Lacerate --removed from the game 
		--[135288] = 104, -- Tooth and Claw --removed from the game 
		[6807] = 104, -- Maul
		--[62606] = 104, -- Savage Defense --removed from the game 
		
		-- Restoration Druid:
		[145205] = 105, -- Wild Mushroom
		[740] = 105, -- Tranquility
		[102342] = 105, -- Ironbark
		[33763] = 105, -- Lifebloom
		[88423] = 105, -- Nature's Cure
		[145205] = 105, --Efflorescence
		--[145518] = 105, -- Genesis --removed
		--[48438] = 105, -- Wild Growth --talent for other specs
		--[18562] = 105, -- Swiftmend --talent for other specs
		
		-- Beast Mastery Hunter:
		[19574] = 253, -- Bestial Wrath
		[82692] = 253, -- Focus Fire
		[53257] = 253, -- Cobra Strikes
		[217200] = 253, --Barbed Shot
		[193455] = 253, --Cobra Shot
		
		-- Marksmanship Hunter:
		[3045] = 254, -- Rapid Fire
		[257045] = 254, --Rapid Fire
		[19434] = 254, -- Aimed Shot
		[193526] = 254, --Trueshot
		[185358] = 254, --Arcane Shot
		[186387] = 254, --Bursting Shot
		
		-- Survival Hunter:
		[190925] = 255, --Harpoon
		[186289] = 255, --Aspect of the Eagle
		[187708] = 255, --Carve
		[259495] = 255, --Wildfire Bomb
		[195645] = 255, --Wing Clip
		[186270] = 255, --Raptor Strike
		[187707] = 255, --Muzzle
		
		-- Arcane Mage:
		[153626] = 62, -- Arcane Orb
		[153640] = 62, -- Arcane Orb
		[114923] = 62, -- Nether Tempest
		[157980] = 62, -- Supernova
		[12042] = 62, -- Arcane Power
		[12051] = 62, -- Evocation
		[31589] = 62, -- Slow
		[5143] = 62, -- Arcane Missiles
		[7268] = 62, -- Arcane Missiles
		[1449] = 62, -- Arcane Explosion
		[44425] = 62, -- Arcane Barrage
		[30451] = 62, -- Arcane Blast
		
		-- Fire Mage:
		[153561] = 63, -- Meteor
		[11129] = 63, -- Combustion
		[157981] = 63, -- Blast Wave
		[44457] = 63, -- Living Bomb
		[31661] = 63, -- Dragon's Breath
		[2120] = 63, -- Flamestrike
		[108853] = 63, -- Inferno Blast
		[2948] = 63, -- Scorch
		[133] = 63, -- Fireball
		[11366] = 63, -- Pyroblast
		
		-- Frost Mage:
		[153595] = 64, -- Comet Storm
		[112948] = 64, -- Frost Bomb
		[157997] = 64, -- Ice Nova
		[84714] = 64, -- Frozen Orb
		[84721] = 64, -- Frozen Orb
		[10] = 64, -- Blizzard
		[190357] = 64, -- Blizzard
		[30455] = 64, -- Ice Lance
		[148022] = 64, -- Icicle
		[228598] = 64, -- Ice Lance
		[228597] = 64, -- Frostbolt
		[116] = 64, -- Frostbolt
		[228600] = 64, -- glacial spike
		[228354] = 64, -- flurry
		[257338] = 64, -- ebonbolt
		
		-- Brewmaster Monk:
		--[157676] = 268, -- Chi Explosion --removed from the game 
		[119582] = 268, -- Purifying Brew
		[115308] = 268, -- Elusive Brew
		[115295] = 268, -- Guard
		[115181] = 268, -- Breath of Fire
		[121253] = 268, -- Keg Smash
		--[115180] = 268, -- Dizzying Haze --removed from the game 

		-- Windwalker Monk:
		[152175] = 269, -- Hurricane Strike
		[116095] = 269, -- Disable
		[122470] = 269, -- Touch of Karma
		[124280] = 269, -- Touch of Karma
		--[128595] = 269, -- Combat Conditioning --removed from the game 
		[101545] = 269, -- Flying Serpent Kick
		[113656] = 269, -- Fists of Fury
		[117418] = 269, -- Fists of Fury
		
		-- Mistweaver Monk:
		[115310] = 270, -- Revival
		[116680] = 270, -- Thunder Focus Tea
		--[115460] = 270, -- Detonate Chi --removed from the game 
		[116670] = 270, -- Uplift
		[115294] = 270, -- Mana Tea
		[116849] = 270, -- Life Cocoon
		[115151] = 270, -- Renewing Mist
		[124682] = 270, -- Enveloping Mist
		[115175] = 270, -- Soothing Mist
		
		-- Holy Paladin:
		[156910] = 65, -- Beacon of Faith
		--[157007] = 65, -- Beacon of Insight --removed from the game 
		[85222] = 65, -- Light of Dawn
		[31821] = 65, -- Devotion Aura
		[82326] = 65, -- Holy Light
		--[148039] = 65, -- Sacred Shield --removed from the game 
		[53563] = 65, -- Beacon of Light
		--[82327] = 65, -- Holy Radiance --removed from the game 
		--[2812] = 65, -- Denounce --removed from the game 
		[20473] = 65, -- Holy Shock
		
		-- Protection Paladin:
		[53600] = 66, -- Shield of the Righteous
		--[26573] = 66, -- Consecration
		[119072] = 66, -- Holy Wrath
		[31935] = 66, -- Avenger's Shield

		-- Retribution Paladin:
		[157048] = 70, -- Final Verdict
		--[20164] = 70, -- Seal of Justice --removed from the game 
		--[879] = 70, -- Exorcism --removed from the game 
		[53385] = 70, -- Divine Storm
		[224266] = 70, -- Templar's Verdict
		[224239] = 70, -- Divine Storm
		[184575] = 70, --Blade of Justice

		-- Discipline Priest:
		[152118] = 256, -- Clarity of Will
		[62618] = 256, -- Power Word: Barrier
		[194509] = 256, -- Power Word: Radiance
		[129250] = 256, -- Power Word: Solace
		[33206] = 256, -- Pain Suppression
		[81751] = 256, -- Atonement
		[94472] = 256, -- Atonement (crit)
		[47750] = 256, -- Penance
		[214621] = 256, -- Schism
		[200829] = 256, -- Plea
		[47536] = 256, -- Rapture
		[204197] = 256, -- Purge the Wicked
		
		-- Holy Priest:
		[155245] = 257, -- Clarity of Purpose
		[64843] = 257, -- Divine Hymn
		[34861] = 257, -- Circle of Healing
		[32546] = 257, -- Binding Heal
		[596] = 257, -- Prayer of Healing
		[88625] = 257, -- Holy Word: Chastise
		[2050] = 257, -- Holy Word: Serenity
		[34861] = 257, -- Holy Word: Sanctify
		[47788] = 257, -- Guardian Spirit
		[139] = 257, -- Renew
		[2061] = 257, --Flash Heal
		[2060] = 257, --Heal

		-- Shadow Priest:
		[15286] = 258, -- Vampiric Embrace
		[32379] = 258, -- Shadow Word: Death
		--[73510] = 258, -- Mind Spike --removed from the game 
		[78203] = 258, -- Shadowy Apparitions
		[34914] = 258, -- Vampiric Touch
		[8092] = 258, -- Mind Blast
		[15407] = 258, -- Mind Flay
		[228266] = 258, -- Void Bolt
		[228260] = 258, --Void Eruption
		
		-- Assassination Rogue:
		[32645] = 259, -- Envenom
		[1329] = 259, -- Mutilate
		[5374] = 259, -- Mutilate
		[27576] = 259, -- Mutilate Off-Hand
		[79134] = 259, -- Venomous Wounds
		--[192759] = 259, -- Kingsbane --removed from the game 
		--[222062] = 259, -- Kingsbane --removed from the game 
		--[192760] = 259, -- Kingsbane --removed from the game 
		[185565] = 259, -- Poisoned Knife
		[51723] = 259, -- Fan of Knives
		[703] = 259, -- Garrote
		[192434] = 259, -- From the Shadows
		[1943] = 259, -- Rupture
	
		-- Outlaw Rogue:
		[2098] = 260, -- Run Through
		[193315] = 260, -- Saber Slash
		[185763] = 260, -- Pistol Shot
		[199804] = 260, -- Between the Eyes
		[86392] = 260, -- Main Gauche
	
		-- Subtlety Rogue:
		[53] = 261, -- Backstab
		[197835] = 261, -- Shuriken Storm
		[196819] = 261, -- Eviscerate
		[121473] = 261, -- Shadow Blade
		[195452] = 261, -- Nightblade

		-- Elemental Shaman:
		--[165399] = 262, -- Elemental Overload --removed from the game 
		--[165477] = 262, -- Unleashed Fury --removed from the game 
		[165339] = 262, -- Ascendance
		--[165462] = 262, -- Unleash Flame --removed from the game 
		[170374] = 262, -- Mastery: Molten Earth
		[61882] = 262, -- Earthquake
		[77756] = 262, -- Lava Surge
		--[88766] = 262, -- Fulmination --removed from the game 
		[60188] = 262, -- Elemental Fury
		--[29000] = 262, -- Elemental Reach --removed from the game 
		--[62099] = 262, -- Shamanism --removed from the game 
		--[123099] = 262, -- Spiritual Insight --removed from the game 
		[51490] = 262, -- Thunderstorm
		[8042] = 262, -- Earth Shock

		-- Enhancement Shaman:
		--[165368] = 263, -- Lightning Strikes --removed from the game 
		--[117012] = 263, -- Unleashed Fury --removed from the game 
		[165341] = 263, -- Ascendance
		--[73680] = 263, -- Unleash Elements --removed from the game 
		[77223] = 263, -- Mastery: Enhanced Elements
		[51533] = 263, -- Feral Spirit
		[58875] = 263, -- Spirit Walk
		--[51530] = 263, -- Maelstrom Weapon --removed from the game 
		--[1535] = 263, -- Fire Nova --removed from the game 
		--[8190] = 263, -- Magma Totem --removed from the game 
		[166221] = 263, -- Enhanced Weapons
		[33757] = 263, -- Windfury
		[17364] = 263, -- Stormstrike
		[32175] = 263, -- Stormstrike
		[32176] = 263, -- Stormstrike off hand
		[16282] = 263, -- Flurry
		--[10400] = 263, -- Flametongue --removed from the game 
		[10444] = 263, -- Flametongue attack
		[60103] = 263, -- Lava Lash
		--[30814] = 263, -- Mental Quickness --removed from the game 
		--[51522] = 263, -- Primal Wisdom --removed from the game 

		-- Restoration Shaman:
		[157153] = 264, -- Cloudburst Totem
		[157154] = 264, -- High Tide
		[165391] = 264, -- Purification
		--[165479] = 264, -- Unleashed Fury
		[165344] = 264, -- Ascendance
		[77226] = 264, -- Mastery: Deep Healing
		[98008] = 264, -- Spirit Link Totem
		[108280] = 264, -- Healing Tide Totem
		[77472] = 264, -- Healing Wave
		[51564] = 264, -- Tidal Waves
		[1064] = 264, -- Chain Heal
		[16196] = 264, -- Resurgence
		--[974] = 264, -- Earth Shield --can be used by all specs as a talent
		[52127] = 264, -- Water Shield
		[77130] = 264, -- Purify Spirit
		--[55453] = 264, -- Telluric Currents
		--[95862] = 264, -- Meditation
		[16213] = 264, -- Restorative Waves
		[61295] = 264, -- Riptide
		--[112858] = 264, -- Spiritual Insight

		-- Affliction :
		--[152109] = 265, -- Soulburn: Haunt --removed from the game 
		--[165367] = 265, -- Eradication --removed from the game 
		[113860] = 265, -- Dark Soul: Misery
		[77215] = 265, -- Mastery: Potent Afflictions
		--[86121] = 265, -- Soul Swap --removed from the game 
		[48181] = 265, -- Haunt
		[980] = 265, -- Agony
		[103103] = 265, -- Drain Soul
		[27243] = 265, -- Seed of Corruption
		[117198] = 265, -- Soul Shards
		--[74434] = 265, -- Soulburn --removed from the game 
		[108558] = 265, -- Nightfall
		[30108] = 265, -- Unstable Affliction
		[233490] = 265, -- Unstable Affliction
		[233496] = 265, -- Unstable Affliction
		[233497] = 265, -- Unstable Affliction
		[233498] = 265, -- Unstable Affliction
		[233499] = 265, -- Unstable Affliction
		
		
		--  Demonology Warlock:
		[157695] = 266, -- Demonbolt
		[264178] = 266, -- Demonbolt
		[165392] = 266, -- Demonic Tactics
		[113861] = 266, -- Dark Soul: Knowledge
		[77219] = 266, -- Mastery: Master Demonologist
		[171975] = 266, -- Grimoire of Synergy
		[30146] = 266, -- Summon Felguard
		[114592] = 266, -- Wild Imps
		--[1949] = 266, -- Hellfire --removed from the game 
		[105174] = 266, -- Hand of Gul'dan
		[86040] = 266, -- Hand of Gul'dan
		--[6353] = 266, -- Soul Fire --destruction talent
		--[109151] = 266, -- Demonic Leap --removed from the game 
		--[108869] = 266, -- Decimation --removed from the game 
		--[104315] = 266, -- Demonic Fury --removed from the game 
		[124913] = 266, -- Doom
		--[103958] = 266, -- Metamorphosis --removed from the game 
		--[122351] = 266, -- Molten Core --removed from the game 

		--  Destruction Warlock:
		--[157696] = 267, -- Charred Remains --removed from the game 
		--[165363] = 267, -- Devastation --removed from the game 
		[113858] = 267, -- Dark Soul: Instability
		[77220] = 267, -- Mastery: Emberstorm
		--[120451] = 267, -- Flames of Xoroth --removed from the game 
		[117896] = 267, -- Backdraft
		--[109784] = 267, -- Aftermath --removed from the game 
		[108683] = 267, -- Fire and Brimstone
		[17877] = 267, -- Shadowburn
		[80240] = 267, -- Havoc
		[5740] = 267, -- Rain of Fire
		[114635] = 267, -- Ember Tap
		[174848] = 267, -- Searing Flames
		[348] = 267, -- Immolate
		[108647] = 267, -- Burning Embers
		[116858] = 267, -- Chaos Bolt
		[111546] = 267, -- Chaotic Energy
		[17962] = 267, -- Conflagrate
		[29722] = 267, -- Incinerate

		--  Arms Warrior:
		[165365] = 71, -- Weapon Mastery
		[167105] = 71, -- Colossus Smash
		[12328] = 71, -- Sweeping Strikes
		[1464] = 71, -- Slam
		--[56636] = 71, -- Taste for Blood --removed from the game 
		[12294] = 71, -- Mortal Strike
		--[12712] = 71, -- Seasoned Soldier --removed from the game 
		[772] = 71, -- Rend
		--[174737] = 71, -- Enhanced Rend --removed from the game 

		--  Fury Warrior:
		--[165383] = 72, -- Cruelty --removed from the game 
		[12950] = 72, -- Meat Cleaver
		--[46915] = 72, -- Bloodsurge --removed from the game 
		--[169679] = 72, -- Furious Strikes --removed from the game 
		--[169683] = 72, -- Unquenchable Thirst --removed from the game 
		--[81099] = 72, -- Single-Minded Fury --removed from the game 
		[85288] = 72, -- Raging Blow
		[12323] = 72, -- Piercing Howl
		--[100130] = 72, -- Wild Strike --removed from the game 
		[23881] = 72, -- Bloodthirst
		--[23588] = 72, -- Crazed Berserker --removed from the game 
		--[46917] = 72, -- Titan's Grip --removed from the game 

		--  Protection Warrior:
		--[152276] = 73, -- Gladiator's Resolve
		--[159362] = 73, -- Blood Crazy
		[165393] = 73, -- Shield Mastery
		--[114192] = 73, -- Mocking Banner
		[76857] = 73, -- Mastery: Critical Block
		--[161798] = 73, -- Riposte
		--[84608] = 73, -- Bastion of Defense
		[1160] = 73, -- Demoralizing Shout
		[871] = 73, -- Shield Wall
		[169680] = 73, -- Heavy Repercussions
		--[169685] = 73, -- Unyielding Strikes
		[12975] = 73, -- Last Stand
		[6572] = 73, -- Revenge
		[20243] = 73, -- Devastate
		[2565] = 73, -- Shield Block
		--[161608] = 73, -- Bladed Armor --removed from the game 
		[23922] = 73, -- Shield Slam
		[46953] = 73, -- Sword and Board
		[122509] = 73, -- Ultimatum
		--[29144] = 73, -- Unwavering Sentinel --removed from the game 
		--[157497] = 73, -- Improved Block --removed from the game 
		[6343] = 73, -- Thunder Clap
		--[71] = 73, -- Defensive Stance --removed from the game 
		--[157494] = 73, -- Improved Defensive Stance --removed from the game 

	}
	
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
			--[48721]	=	"DEATHKNIGHT", -- Blood Boil
			[42650]	=	"DEATHKNIGHT", -- Army of the Dead
			[130736]	=	"DEATHKNIGHT", -- Soul Reaper
			[45524]	=	"DEATHKNIGHT", -- Chains of Ice
			[57330]	=	"DEATHKNIGHT", -- Horn of Winter
			[45462]	=	"DEATHKNIGHT", -- Plague Strike
			[85948]	=	"DEATHKNIGHT", -- Festering Strike
			--[56815]	=	"DEATHKNIGHT", -- Rune Strike
			[63560]	=	"DEATHKNIGHT", -- Dark Transformation
			[108200]	=	"DEATHKNIGHT", -- Remorseless Winter
			[49222]	=	"DEATHKNIGHT", -- Bone Shield
			[45477]	=	"DEATHKNIGHT", -- Icy Touch
			[43265]	=	"DEATHKNIGHT", -- Death and Decay
			[77575]	=	"DEATHKNIGHT", -- Outbreak
			[51271]	=	"DEATHKNIGHT", -- Pillar of Frost
			[115989]	=	"DEATHKNIGHT", -- Unholy Blight
			[48792]	=	"DEATHKNIGHT", -- Icebound Fortitude
			--[55050]	=	"DEATHKNIGHT", -- Heart Strike
			[55233]	=	"DEATHKNIGHT", -- Vampiric Blood
			[49576]	=	"DEATHKNIGHT", -- Death Grip
			[119975]	=	"DEATHKNIGHT", -- Conversion
			[56222]	=	"DEATHKNIGHT", -- Dark Command
			[114866]	=	"DEATHKNIGHT", -- Soul Reaper
			--[73975]	=	"DEATHKNIGHT", -- Necrotic Strike
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
			--[49016]	=	"DEATHKNIGHT", -- Unholy Frenzy
			[49206]	=	"DEATHKNIGHT", -- Summon Gargoyle
			[48266]	=	"DEATHKNIGHT", -- Frost Presence
			--[45902]	=	"DEATHKNIGHT", -- Blood Strike
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
			--[80965]	=	 "DRUID", --  Skull Bash
			--[16689]	=	 "DRUID", --  Nature's Grasp
			[102417]	=	 "DRUID", --  Wild Charge
			--[5229]	=	 "DRUID", --  Enrage
			[78675]	=	 "DRUID", --  Solar Beam
			[102351]	=	 "DRUID", --  Cenarion Ward
			--[9005]	=	 "DRUID", --  Pounce
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
			--[62078]	=	 "DRUID", --  Swipe
			[102793]	=	 "DRUID", --  Ursol's Vortex
			[106996]	=	 "DRUID", --  Astral Storm
			--[6785]	=	 "DRUID", --  Ravage
			[106898]	=	 "DRUID", --  Stampeding Roar
			[33891]	=	 "DRUID", --  Incarnation: Tree of Life
			[102359]	=	 "DRUID", --  Mass Entanglement
			[108293]	=	 "DRUID", --  Heart of the Wild
			[5211]	=	 "DRUID", --  Mighty Bash
			--[102795]	=	 "DRUID", --  Bear Hug
			[108291]	=	 "DRUID", --  Heart of the Wild		
			[18562]	=	 "DRUID", --Swiftmend
			--[106922]	=	 "DRUID", -- Might of Ursoc
			[132158]	=	 "DRUID", -- Nature's Swiftness
			[33763]	=	 "DRUID", -- Lifebloom
			[1126]	=	 "DRUID", -- Mark of the Wild
			[6807]	=	 "DRUID", -- Maul
			[33745]	=	 "DRUID", -- Lacerate
			[145205]	=	 "DRUID", -- Wild Mushroom
			[77761]	=	 "DRUID", -- Stampeding Roar
			--[102791]	=	 "DRUID", -- Wild Mushroom: Bloom
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
			--[779]	=	 "DRUID", -- Swipe
			[147349]	=	 "DRUID", -- Wild Mushroom
			[77758]	=	 "DRUID", -- Thrash
			[108294]	=	 "DRUID", -- Heart of the Wild
			[106830]	=	 "DRUID", -- Thrash
			[108292]	=	 "DRUID", -- Heart of the Wild
			[768]	=	 "DRUID", -- Cat Form
			--[127538]	=	 "DRUID", -- Savage Roar
			[61336]	=	 "DRUID", -- Survival Instincts
			--[114236]	=	 "DRUID", -- Shred!
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
			--[80964]	=	 "DRUID", -- Skull Bash
			[1822] 	=	"DRUID", --rake
			[1079] 	=	"DRUID", --rip
			[5221] 	=	"DRUID", --shred
			--[33876]	=	"DRUID", --mangle
			--[33878]	=	"DRUID", --mangle (energy)
			--[102545]	=	"DRUID", --ravage!
			--[33878]	=	"DRUID", --mangle (energy gain)
			[17057]	=	"DRUID", --bear form (energy gain)
			[16959]	=	"DRUID", --primal fury (energy gain)
			[5217]	=	"DRUID", --tiger's fury (energy gain)
			[68285]	=	"DRUID", --leader of the pack (mana)
			[5176]	=	"DRUID", --wrath
			[93402]	=	"DRUID", --sunfire
			[2912]	=	"DRUID", --starfire
			[8921]	=	"DRUID", --moonfire
			--[81070]	=	"DRUID", --eclipse
			--[29166]	=	"DRUID", --innervate
			[774]	=	"DRUID", --rejuvenation
			--[44203]	=	"DRUID", --tranquility
			[48438]	=	"DRUID", --wild growth
			[81269]	=	"DRUID", --shiftmend
			--[102792]	=	"DRUID", --wind moshroom: bloom
			[5185]	=	"DRUID", --healing touch
			[8936]	=	"DRUID", --regrowth
			[33778]	=	"DRUID", --lifebloom
			[48503]	=	"DRUID", --living seed
			--[50464]	=	"DRUID", --nourish

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
			[60192]	=	"HUNTER", -- "Freezing Trap"
			[172106]	=	"HUNTER", -- "Aspect of the Fox"
			[162537]	=	"HUNTER", -- "Poisoned Ammo"
			[162536]	=	"HUNTER", -- "Incendiary Ammo"
			[13812]	=	"HUNTER", -- "Explosive Trap"
			[157708]	=	"HUNTER", -- "Kill Shot"
			[120761]	=	"HUNTER", -- "Glaive Toss"
			[171454]	=	"HUNTER", -- "Chimaera Shot"
			[162541]	=	"HUNTER", -- "Incendiary Ammo"
			--[19503]	=	"HUNTER",--  Scatter Shot HUNTER
			[83245]	=	"HUNTER",--  Call Pet 5 HUNTER
			[51753]	=	"HUNTER",--  Camouflage HUNTER
			--[13165]	=	"HUNTER",--  Aspect of the Hawk HUNTER
			[109259]	=	"HUNTER",--  Powershot HUNTER
			[53271]	=	"HUNTER",--  Master's Call HUNTER
			[20736]	=	"HUNTER",--  Distracting Shot HUNTER
			[1543]	=	"HUNTER",--  Flare HUNTER
			[3674]	=	"HUNTER",-- Black Arrow
			[117050]	=	"HUNTER",-- Glaive Toss
			--[1978]	=	"HUNTER",-- Serpent Sting
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
			--[34490]	=	"HUNTER",-- Silencing Shot
			[53209]	=	"HUNTER",-- Chimera Shot
			--[82928]	=	"HUNTER",-- Aimed Shot!
			[83243]	=	"HUNTER",-- Call Pet 3
			[5116]	=	"HUNTER",-- Concussive Shot
			[1130]	=	"HUNTER",--'s Mark
			[34477]	=	"HUNTER",-- Misdirection
			[19263]	=	"HUNTER",-- Deterrence
			[147362]	=	"HUNTER",-- Counter Shot
			[19801]	=	"HUNTER",-- Tranquilizing Shot
			--[82654]	=	"HUNTER",-- Widow Venom
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
			--[131078]	=	"MAGE",-- Icy Veins
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
			--[115213]	=	"MONK", -- Avert Harm
			
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
			--[115073]	=	"MONK", -- Spinning Fire Blossom
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
			--[115464]	=	"MONK", -- Healing Sphere	
			[115151]	=	"MONK", -- Renewing Mist
			[117952]	=	"MONK", -- Crackling Jade Lightning
			[122783]	=	"MONK", -- Diffuse Magic
			[115078]	=	"MONK", -- Paralysis
			[116705]	=	"MONK", -- Spear Hand Strike
			[123904]	=	"MONK", -- Invoke Xuen, the White Tiger
			--[116709]	=	"MONK", -- Spear Hand Strike
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
			--[135914]	=	"MONK", -- Healing Sphere
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
			--[54428] 	= 	"PALADIN", -- Divine Plea
			[7328] 	= 	"PALADIN", -- Redemption
			[116467] 	= 	"PALADIN", -- Consecration
			[31801] 	= 	"PALADIN", -- Seal of Truth
			[20165] 	= 	"PALADIN", -- Seal of Insight
			[20473]	=	"PALADIN",-- Holy Shock
			[114158]	=	"PALADIN",-- Light's Hammer
			[85673]	=	"PALADIN",-- Word of Glory
			[85499]	=	"PALADIN",-- Speed of Light
			--[84963]	=	"PALADIN",-- Inquisition
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
			--[108921] 	= 	"PRIEST", -- Psyfiend
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
			--[64901]	=	"PRIEST", -- Hymn of Hope
			[64843]	=	"PRIEST", -- Divine Hymn
			[64844]	=	"PRIEST", -- Divine Hymn
			[34433]	=	"PRIEST", -- Shadowfiend
			[120644]	=	"PRIEST", -- Halo
			[15487]	=	"PRIEST", -- Silence
			--[89485]	=	"PRIEST", -- Inner Focus
			[109964]	=	"PRIEST", -- Spirit Shell
			[129197]	=	"PRIEST", -- Mind Flay (Insanity)
			[112833]	=	"PRIEST", -- Spectral Guise
			[47750]	=	"PRIEST", -- Penance
			[33206]	=	"PRIEST", -- Pain Suppression
			[15286]	=	"PRIEST", -- Vampiric Embrace
			--[588]	=	"PRIEST", -- Inner Fire
			[21562]	=	"PRIEST", -- Power Word: Fortitude
			--[73413]	=	"PRIEST", -- Inner Will
			[10060]	=	"PRIEST", -- Power Infusion
			--[2050]	=	"PRIEST", -- Heal
			[15473]	=	"PRIEST", -- Shadowform
			[108920]	=	"PRIEST", -- Void Tendrils
			[47585]	=	"PRIEST", -- Dispersion
			[123259]	=	"PRIEST", -- Prayer of Mending
			[34650]	=	"PRIEST", --mana leech (pet)
			[589]	=	"PRIEST", --shadow word: pain
			[34914]	=	"PRIEST", --vampiric touch
			--[34919]	=	"PRIEST", --vampiric touch (mana)
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
			--[64904]	=	"PRIEST", --hymn of hope
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
			--[121471]	=	"ROGUE", -- Shadow Blades
			--[121473]	=	"ROGUE", -- Shadow Blade
			[1752]	=	"ROGUE", -- Sinister Strike
			[51690]	=	"ROGUE", -- Killing Spree
			--[121474]	=	"ROGUE", -- Shadow Blade Off-hand
			[1766]	=	"ROGUE", -- Kick
			[76577]	=	"ROGUE", -- Smoke Bomb
			[5277]	=	"ROGUE", -- Evasion
			[137619]	=	"ROGUE", -- Marked for Death
			--[8647]	=	"ROGUE", -- Expose Armor
			[79140]	=	"ROGUE", -- Vendetta
			[51713]	=	"ROGUE", -- Shadow Dance
			[2823]	=	"ROGUE", -- Deadly Poison
			[115191]	=	"ROGUE", -- Stealth
			--[108215]	=	"ROGUE", -- Paralytic Poison
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
			--[73682] 	= 	"SHAMAN", -- Unleash Frost
			--[8033] 	= 	"SHAMAN", -- Frostbrand Weapon
			[114074] 	= 	"SHAMAN", -- Lava Beam
			--[120668]	=	"SHAMAN", --Stormlash Totem
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
			--[8024]	=	"SHAMAN", -- Flametongue Weapon
			[51485]	=	"SHAMAN", -- Earthgrab Totem
			--[331]	=	"SHAMAN", -- Healing Wave
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
			--[51730]	=	"SHAMAN", -- Earthliving Weapon
			[8056]	=	"SHAMAN", -- Frost Shock
			--[88765]	=	"SHAMAN", --rolling thunder (mana)
			[51490]	=	"SHAMAN", --thunderstorm (mana)
			--[82987]	=	"SHAMAN", --telluric currents glyph (mana)
			[101033]	=	"SHAMAN", --resurgence (mana)
			[51505]	=	"SHAMAN", --lava burst
			[8050]	=	"SHAMAN", --flame shock
			[117014]	=	"SHAMAN", --elemental blast
			[403]	=	"SHAMAN", --lightning bolt
			--[45284]	=	"SHAMAN", --lightning bolt
			[421]	=	"SHAMAN", --chain lightining
			[32175]	=	"SHAMAN", --stormstrike
			[25504]	=	"SHAMAN", --windfury
			[8042]	=	"SHAMAN", --earthshock
			[26364]	=	"SHAMAN", --lightning shield
			[117014]	=	"SHAMAN", --elemental blast
			[73683]	=	"SHAMAN", --unleash flame
			[51522]	=	"SHAMAN", --primal wisdom (mana)
			--[63375]	=	"SHAMAN", --primal wisdom (mana)
			[114942]	=	"SHAMAN", --healing tide
			[73921]	=	"SHAMAN", --healing rain
			[1064]	=	"SHAMAN", --chain heal
			[52042]	=	"SHAMAN", --healing stream totem
			[61295]	=	"SHAMAN", --riptide
			--[51945]	=	"SHAMAN", --earthliving
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
			--[112092] 	= 	"WARLOCK", -- Shadow Bolt
			[113861] 	= 	"WARLOCK", -- Dark Soul: Knowledge
			--[103967] 	= 	"WARLOCK", -- Carrion Swarm
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
			--[6229]	=	"WARLOCK", -- Twilight Ward
			[74434]	=	"WARLOCK", -- Soulburn
			[30283]	=	"WARLOCK", -- Shadowfury
			[113860]	=	"WARLOCK", -- Dark Soul: Misery
			[108503]	=	"WARLOCK", -- Grimoire of Sacrifice
			[104232]	=	"WARLOCK", -- Rain of Fire
			[6353]	=	"WARLOCK", -- Soul Fire
			[689]	=	"WARLOCK", -- Drain Life
			[17877]	=	"WARLOCK", -- Shadowburn
			[113858]	=	"WARLOCK", -- Dark Soul: Instability
			--[1490]	=	"WARLOCK", -- Curse of the Elements
			[114635]	=	"WARLOCK", -- Ember Tap
			[27243]	=	"WARLOCK", -- Seed of Corruption
			--[131623]	=	"WARLOCK", -- Twilight Ward
			[6789]	=	"WARLOCK", -- Mortal Coil
			[111400]	=	"WARLOCK", -- Burning Rush
			[124916]	=	"WARLOCK", -- Chaos Wave
			--[1120]	=	"WARLOCK", -- Drain Soul
			[109773]	=	"WARLOCK", -- Dark Intent
			[112927]	=	"WARLOCK", -- Summon Terrorguard
			[1122]	=	"WARLOCK", -- Summon Infernal
			[108416]	=	"WARLOCK", -- Sacrificial Pact
			[5484]	=	"WARLOCK", -- Howl of Terror
			[29858]	=	"WARLOCK", -- Soulshatter
			[18540]	=	"WARLOCK", -- Summon Doomguard
			--[89420]	=	"WARLOCK", -- Drain Life
			[20707]	=	"WARLOCK", -- Soulstone
			[132413]	=	"WARLOCK", -- Shadow Bulwark
			--[109466]	=	"WARLOCK", -- Curse of Enfeeblement
			[48018]	=	"WARLOCK", -- Demonic Circle: Summon
			--[77799]	=	"WARLOCK", --fel flame
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
			--[114328]	=	"WARLOCK", --shadow bolt glyph
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
			--[122475] 	= 	"WARRIOR", -- Throw
			--[845] 	= 	"WARRIOR", -- Cleave
			[5246] 	= 	"WARRIOR", -- Intimidating Shout
			--[7386] 	= 	"WARRIOR", -- Sunder Armor
			[107566] 	= 	"WARRIOR", -- Staggering Shout
			[86346]	=	"WARRIOR", -- Colossus Smash
			[18499]	=	"WARRIOR", -- Berserker Rage
			[107570]	=	"WARRIOR", -- Storm Bolt
			[1680]	=	"WARRIOR", -- Whirlwind
			[85384]	=	"WARRIOR", -- Raging Blow Off-Hand
			[85288]	=	"WARRIOR", -- Raging Blow
			[100]	=	"WARRIOR", -- Charge
			--[7384]	=	"WARRIOR", -- Overpower
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
			--[114203]	=	"WARRIOR", -- Demoralizing Banner
			[52174]	=	"WARRIOR", -- Heroic Leap
			[1719]	=	"WARRIOR", -- Recklessness
			--[114207]	=	"WARRIOR", -- Skull Banner
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
			--[11800]	=	"WARRIOR", --dragon roar
			[115767]	=	"WARRIOR", --deep wounds
			[109128]	=	"WARRIOR", --charge
			--[11294]	=	"WARRIOR", --mortal strike
			[109128]	=	"WARRIOR", --charge
			[12880]	=	"WARRIOR", --enrage
			--[29842]	=	"WARRIOR", --undribled wrath
	}
	
	_detalhes.HardCrowdControlSpells = {
		--> death knight
		
		--> deamon hunter
		
		--> druid
		[33786] 	= true, -- Cyclone
		
		--> hunter
		
		--> mage
		
		--> monk
		
		--> paladin
		
		--> priest
		
		--> rogue
		
		--> shaman
		
		--> warlock
		
		--> warrior
		
	}
	
	-- updated on 25/04/2015 (@Tonyleila - WoWInterface)
	_detalhes.CrowdControlSpells = {

		--Racials
			[28730]	= true, -- Arcane Torrent (be)
			[47779]	= true, -- Arcane Torrent (be)
			[50613]	= true, -- Arcane Torrent (be)
			[107079]	= true, -- Quaking Palm (pandaren)
			[20549]	= true, -- War Stomp (tauren)
			
		--death knight
			[108194]	= true, -- Asphyxiate
			[96294]	= true, -- Chains of ice
			[47481]	= true, -- Gnaw
			[47528]	= true, -- Mind Freeze
			[91797]	= true, -- Monstrous Blow
			[115001]	= true, -- Remorseless Winter (Stunned)
			[47476]	= true, -- Strangulate
		
		--deamon hunter
			[217832]	= true, -- Imprison
		
		--druid
			[33786] 	= true, -- Cyclone
			[339]		= true, -- Entangling Toots
			[45334] 	= true, -- Immobilized (from Wild Charge)
			[99]		= true, -- Incapacitating Roar
			[22570] 	= true, -- Maim
			[102359] 	= true, -- Mass Entanglement
			[5211] 	= true, -- Mighty Bash (talent)
			[163505] 	= true, -- Rake (stealth)
			[106839]	= true, -- Skull Bash
			[81261] 	= true, -- Solar Beam
			[107566] 	= true, -- Staggering Shout
			[16979]	= true, -- Wild Charge (talent)
			[209753]	= true, -- Cyclone (honor talent)

		--hunter
			[117405]	= true, -- Binding Shot
			[64803]	= true, -- Entrapment
			[3355]	= true, -- Freezing trap
			[24394]	= true, -- Intimidation (pet)
			[128405]	= true, -- Narrow Escape
			[136634]	= true, -- Narrow Wscape
			[24335]	= true, -- Wyvern sting
			[19386]	= true, -- Wyvern sting

		--mage
			[2139]	= true, -- Counterspell
			[44572]	= true, -- Deep Freeze
			[58534]	= true, -- Deep Freeze
			[31661]	= true, -- Dragon's Breath
			[33395]	= true, -- Freeze (pet)
			[122]		= true, -- Frost Nova
			[102051]	= true, -- Frostjaw
			[157997]	= true, -- Ice Nova
			[111340]	= true, -- Ice Ward
			[118]		= true, -- Polymorph sheep
			[28272]	= true, -- Polymorph pig
			[126819]	= true, -- Polymorph pig 2
			[61305]	= true, -- Polymorph black cat
			[61721]	= true, -- Polymorph rabbit
			[61780]	= true, -- Polymorph turkey
			[28271]	= true, -- Polymorph turtle
			[161354]	= true, -- Polymorph Monkey
			[161353]	= true, -- Polymorph Polar Bear Cub
			[161355]	= true, -- Polymorph Penguin
			[82691]	= true, -- Ring of frost
		
		--monk
			[123393]	= true, -- Breath of Fire
			[119392]	= true, -- Charging Ox Wave
			[116706]	= true, -- Disable
			[120086]	= true, -- Fists of Fury
			[117418]	= true, -- Fists of Fury
			[119381]	= true, -- Leg Sweep
			[115078]	= true, -- Paralysis
			[116705]	= true, -- Spear Hand Strike
			[142895]	= true, -- Incapacitated (ring of peace)
	    
		--paladin
			[31935]	= true, -- Avenger's Shield
			[105421]	= true, -- Blinding light
			[105593]	= true, -- Fist of Justice
			[853]		= true, -- Hammer of Justice
			[96231] 	= true, -- Rebuke
			[20066]	= true, -- Repentance
			[145067]	= true, -- Turn Evil
			
		--priest
			[605]		= true, -- Dominate Mind
			[87194]	= true, -- Glyph of Mind Blast
			[88625]	= true, -- Holy Word: Chastise
			[64044]	= true, -- Psychic Horror
			[8122]	= true, -- Psychic scream
			[9484]	= true, -- Shackle undead
			[15487]	= true, -- Silence
			[131556]	= true, -- Sin and Punishment
			[114404]	= true, -- Void Tendril's Grasp
	    
		--rogue
			[2094]	= true, -- Blind
			[1833]	= true, -- Cheap shot
			[1330]	= true, -- Garrote
			[1776]	= true, -- Gouge
			[1766]	= true, -- Kick
			[408]		= true, -- Kidney shot
			[6770]	= true, -- Sap
			[76577]	= true, -- Smoke Bomb
		
		--shaman
			[64695]	= true, -- Earthgrab (earthgrab totem)
			[77505]	= true, -- Earthquake
			[51514]	= true, -- Hex
			[118905]	= true, -- Static Charge
			[51490]	= true, -- Thunderstorm
			[57994]	= true, -- Wind Shear
	    
		--warlock
			[89766]	= true, -- Axe Toss (Felguard)
			[111397]	= true, -- Blood Horror
			[170996]	= true, -- Debilitate (terrorguard)
			[5782] 	= true, -- Fear
			[118699]	= true, -- Fear		
			[5484]	= true, -- Howl of terror
			[115268]	= true, -- Mesmerize (shivarra)
			[6789] 	= true, -- Mortal Coil
			[115781]	= true, -- Optical Blast (improved spell lock from Grimoire of Supremacy)
			[6358]	= true, -- Seduction (succubus)
			[30283]	= true, -- Shadowfury
			[19647]	= true, -- Spell Lock (Felhunters)
			[31117]	= true, -- Unstable Affliction
			[179057]	= true, --Chaos Nova
			
		--warrior
			[100]		= true, -- Charge
			[105771]	= true, -- Charge
			[102060]	= true, -- Disrupting Shout
			[118895]	= true, -- Dragon Roar
			[5246]	= true, -- Intimidating shout
			[6552]	= true, -- Pummel 
			[132168]	= true, -- Shockwave
			[107566]	= true, -- Staggering shout
			[132169]	= true, -- Storm Bolt
			[7922]	= true, -- Warbringer
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

	--cooldowns by spec
	_detalhes.BFA_Cooldowns = {
	
		-- 1 attack cooldown
		-- 2 personal defensive cooldown
		-- 3 targetted defensive cooldown
		-- 4 raid defensive cooldown
		-- 5 personal utility cooldown
	
		--MAGE
			--arcane
			[62]	= {
				[12042] = 1, --Arcane Power
				[55342] = 1, --Mirror Image
				[45438] = 2, --Ice Block
				[12051] = 5, --Evocation
				[110960] = 5, --Greater Invisibility
			},
			--fire
			[63] = {
				[190319] = 1, --Combustion
				[55342] = 1, --Mirror Image
				[45438] = 2, --Ice Block
				[66] = 5, --Invisibility
			},
			--frost
			[64] = {
				[12472] = 1, --Icy Veins
				[205021] = 1, --Ray of Frost
				[55342] = 1, --Mirror Image
				[45438] = 2, --Ice Block
				[66] = 5, --Invisibility
				[235219] = 5, --Cold Snap
			},
		
		--PRIEST
			--discipline
			[256] = {
				[34433] = 1, --Shadowfiend
				[123040] = 1, --Mindbender
				[33206] = 3, --Pain Suppression
				[62618] = 4, --Power Word: Barrier
				[271466] = 4, --Luminous Barrier (talent)
				[47536] = 5, --Rapture
				[19236] = 5, --Desperate Prayer
				[8122] = 5, --Psychic Scream
			},
			--holy
			[257] = {
				[200183] = 2, --Apotheosis
				[47788] = 3, --Guardian Spirit
				[64844] = 4, --Divine Hymn
				[64901] = 4, --Symbol of Hope
				[265202] = 4, --Holy Word: Salvation
				[88625] = 5, --Holy Word: Chastise
				[34861] = 5, --Holy Word: Sanctify
				[2050] = 5, --Holy Word: Serenity
				[19236] = 5, --Desperate Prayer
				[8122] = 5, --Psychic Scream
			},
			--shadow priest
			[258] = {
				[34433] = 1, --Shadowfiend
				[200174] = 1, --Mindbender
				[193223] = 1, --Surrender to Madness
				[47585] = 2, --Dispersion
				[15286] = 4, --Vampiric Embrace
				[64044] = 5, --Psychic Horror
				[8122] = 5, --Psychic Scream
			},
		
		--ROGUE
			--assassination
			[259] = {
				[79140] = 1, --Vendetta
				[1856] = 2, --Vanish
				[5277] = 2, --Evasion
				[31224] = 2, --Cloak of Shadows
				[2094] = 5, --Blind
				[114018] = 5, --Shroud of Concealment
			},
			--outlaw
			[260] = {
				[13750] = 1, --Adrenaline Rush
				[51690] = 1, --Killing Spree (talent)
				[199754] = 2, --Riposte
				[31224] = 2, --Cloak of Shadows
				[1856] = 2, --Vanish
				[2094] = 5, --Blind
				[114018] = 5, --Shroud of Concealment
			},
			--subtlety
			[261] = {
				[121471] = 1, --Shadow Blades
				[31224] = 2, --Cloak of Shadows
				[1856] = 2, --Vanish
				[5277] = 2, --Evasion
				[2094] = 5, --Blind
				[114018] = 5, --Shroud of Concealment
			},
		
		--WARLOCK
			--affliction
			[265] = {
				[205180] = 1, --Summon Darkglare
				[113860] = 1, --Dark Soul: Misery
				[104773] = 2, --Unending Resolve
				
				[108416] = 2, --Dark Pact
				
				[30283] = 5, --Shadowfury
				[6789] = 5, --Mortal Coil
			},
			--demo
			[266] = {
				[265187] = 1, --Summon Demonic Tyrant
				[111898] = 1, --Grimoire: Felguard
				[267217] = 1, --Nether Portal
				
				[104773] = 2, --Unending Resolve
				[108416] = 2, --Dark Pact
				
				[30283] = 5, --Shadowfury
				[6789] = 5, --Mortal Coil
			},
			--destro
			[267] = {
				[1122] = 1, --Summon Infernal
				[113858] = 1, --Dark Soul: Instability
				
				[104773] = 2, --Unending Resolve
				[108416] = 2, --Dark Pact
				
				[6789] = 5, --Mortal Coil
				[30283] = 5, --Shadowfury
			},
		
		--WARRIOR
			--Arms
			[71] = {
				[107574] = 1, --Avatar
				[227847] = 1, --Bladestorm
				[152277] = 1, --Ravager (talent)
				
				[118038] = 2, --Die by the Sword
				
				[97462] = 4, --Rallying Cry
				
				[18499] = 5, --Berserker Rage
				[5246] = 5, --Intimidating Shout
			},
			--Fury
			[72] = {
				[1719] = 1, --Recklessness
				[46924] = 1, --Bladestorm (talent)
				
				[184364] = 2, --Enraged Regeneration
				
				[97462] = 4, --Rallying Cry
				
				[18499] = 5, --Berserker Rage
				[5246] = 5, --Intimidating Shout
			},
			--Protection
			[73] = {
				[228920] = 1, --Ravager (talent)
				[107574] = 1, --Avatar
				
				[12975] = 2, --Last Stand
				[871] = 2, --Shield Wall
				
				[97462] = 4, --Rallying Cry
				
				[18499] = 5, --Berserker Rage
				[5246] = 5, --Intimidating Shout
			},
		
		--PALADIN
			--holy
			[65] = {
				[31884] = 1, --Avenging Wrath
				[216331] = 1, --Avenging Crusader (talent)
				
				[498] = 2, --Divine Protection
				[642] = 2, --Divine Shield
				[105809] = 2, --Holy Avenger (talent)

				[1022] = 3, --Blessing of Protection
				[633] = 3, --Lay on Hands
				
				[31821] = 4, --Aura Mastery
				
				[1044] = 5, --Blessing of Freedom
				[853] = 5, --Hammer of Justice
				[115750] = 5, --Blinding Light (talent)
			},
			
			--protection
			[66] = {
				[31884] = 1, --Avenging Wrath
				
				[31850] = 2, --Ardent Defender
				[86659] = 2, --Guardian of Ancient Kings
				
				[1022] = 3, --Blessing of Protection
				[204018] = 3, --Blessing of Spellwarding (talent)
				[6940] = 3, --Blessing of Sacrifice
				
				[204150] = 4, --Aegis of Light (talent)
				
				[1044] = 5, --Blessing of Freedom
				[853] = 5, --Hammer of Justice
				[115750] = 5, --Blinding Light (talent)
			},
			
			--retribution
			[70] = {
				[31884] = 1, --Avenging Wrath
				[231895] = 1, --Crusade (talent)
				
				[184662] = 2, --Shield of Vengeance
				[642] = 2, --Divine Shield
				
				[1022] = 3, --Blessing of Protection
				[633] = 3, --Lay on Hands
				
				[1044] = 5, --Blessing of Freedom
				[853] = 5, --Hammer of Justice
				[115750] = 5, --Blinding Light (talent)
			},
		
		--DEMON HUNTER
			--havoc
			[577] = {
				[200166] = 1, --Metamorphosis
				[206491] = 1, --Nemesis (talent)

				[196555] = 2, --Netherwalk (talent)
				
				[196718] = 4, --Darkness
			},
			--vengeance
			[581] = {
				[187827] = 2, --Metamorphosis
				
				[207684] = 5, --Sigil of Misery
				[202137] = 5, --Sigil of Silence
				[202138] = 5, --Sigil of Chains (talent)
			},
			
		--DEATH KNIGHT
			--unholy
			[252] = {
				[275699] = 1, --Apocalypse
				[42650] = 1, --Army of the Dead
				[49206] = 1, --Summon Gargoyle (talent)
				
				[48792] = 2, --Icebound Fortitude
				[48743] = 2, --Death Pact (talent)
				
			},
			--frost
			[251] = {
				[152279] = 1, --Breath of Sindragosa (talent)
				[47568] = 1, --Empower Rune Weapon
				[279302] = 1, --Frostwyrm's Fury (talent)
				
				[48792] = 2, --Icebound Fortitude
				[48743] = 2, --Death Pact (talent)
				
				[207167] = 5, --Blinding Sleet (talent)
			},
			--blood
			[250] = {
				[49028] = 1, --Dancing Rune Weapon
				
				[55233] = 2, --Vampiric Blood
				[48792] = 2, --Icebound Fortitude
				
				[108199] = 5, --Gorefiend's Grasp
			},
		
		--DRUID
			--balance
			[102] = {
				[194223] = 1, --Celestial Alignment
				[102560] = 1, --Incarnation: Chosen of Elune (talent)
				
				[22812] = 2, --Barkskin
				[108238] = 2, --Renewal (talent)
				
				[29166] = 3, --Innervate

				[78675] = 5, --Solar Beam
			},
			--feral
			[103] = {
				[106951] = 1, --Berserk
				[102543] = 1, --Incarnation: King of the Jungle (talent)
				
				[61336] = 2, --Survival Instincts
				[108238] = 2, --Renewal (talent)
				
				[77764] = 4, --Stampeding Roar
			},
			--guardian
			[104] = {
				[22812] = 2, --Barkskin	
				[61336] = 2, --Survival Instincts
				[102558] = 2, --Incarnation: Guardian of Ursoc (talent)
				
				[77761] = 4, --Stampeding Roar
				
				[99] = 5, --Incapacitating Roar
			},
			--restoration
			[105] = {
				
				[22812] = 2, --Barkskin
				[108238] = 2, --Renewal (talent)
				[33891] = 2, --Incarnation: Tree of Life (talent)
				
				[102342] = 3, --Ironbark
				[29166] = 3, --Innervate
				
				[740] = 4, --Tranquility
				[197721] = 4, --Flourish (talent)
				
				[102793] = 5, --Ursol's Vortex
			},
		
		--HUNTER
			--beast mastery
			[253] = {
				[193530] = 1, --Aspect of the Wild
				[19574] = 1, --Bestial Wrath
				[201430] = 1, --Stampede (talent)
				[194407] = 1, --Spitting Cobra (talent)
				
				[186265] = 2, --Aspect of the Turtle
				
				[19577] = 5, --Intimidation
			},
			--marksmanship
			[254] = {
				[193526] = 1, --Trueshot
				
				[186265] = 2, --Aspect of the Turtle
				[109304] = 2, --Exhilaration
				[281195] = 2, --Survival of the Fittest
				
				[187650] = 5, --Freezing Trap
			},
			--survival
			[255] = {
				[266779] = 1, --Coordinated Assault
				
				[186265] = 2, --Aspect of the Turtle
				[109304] = 2, --Exhilaration
				
				[19577] = 5, --Intimidation
			},

		--MONK
			--brewmaster
			[268] = {
				[115203] = 2, --Fortifying Brew
				[115176] = 2, --Zen Meditation
				[122278] = 2, --Dampen Harm (talent)
			},
			--windwalker
			[269] = {
				[137639] = 1, --Storm, Earth, and Fire
				[123904] = 1, --Invoke Xuen, the White Tiger (talent)
				[152173] = 1, --Serenity (talent)
				
				[122470] = 2, --Touch of Karma
				[122278] = 2, --Dampen Harm (talent)
				[122783] = 2, --Diffuse Magic (talent)
				
				[119381] = 5, --Leg Sweep
			},
			--mistweaver
			[270] = {
				[122278] = 2, --Dampen Harm (talent)
				[198664] = 2, --Invoke Chi-Ji, the Red Crane (talent)
				[243435] = 2, --Fortifying Brew
				[122783] = 2, --Diffuse Magic (talent)
				
				[116849] = 3, --Life Cocoon
				
				[115310] = 4, --Revival
			},
		
		--SHAMAN
			--elemental
			[262] = {
				[198067] = 1, --Fire Elemental
				[192249] = 1, --Storm Elemental (talent)
				[114050] = 1, --Ascendance (talent)
				
				[108271] = 2, --Astral Shift
				
				[108281] = 4, --Ancestral Guidance (talent)
			},
			--enhancement
			[263] = {
				[51533] = 1, --Feral Spirit
				[114051] = 1, --Ascendance (talent)
				
				[108271] = 2, --Astral Shift
			},
			--restoration
			[263] = {
				[108271] = 2, --Astral Shift
				[114052] = 2, --Ascendance (talent)
				[98008] = 4, --Spirit Link Totem
				[108280] = 4, --Healing Tide Totem
				[207399] = 4, --Ancestral Protection Totem (talent)
			},
	}
	
	
	
		-- ~cooldown 1 self
	_detalhes.DefensiveCooldownSpellsNoBuff = {
		
		[20594] = {120, 8, 1}, --racial stoneform
		
		--[6262] = {120, 1, 1}, --healthstone
		
		--["DEATHKNIGHT"] = {},
		[48707] = {45, 5, 1}, -- Anti-Magic Shell
		[48743] = {120, 0, 1}, --Death Pact
		[51052] = {120, 3, 0}, --Anti-Magic Zone
		[152279] = {120, 6}, -- "Breath of Sindragosa"
		[48982] = {30, 0, 1}, -- "Blood T�p"
		
		--["DRUID"] = {},
		[740] = {480, 8, 0}, --Tranquility
		[22842] = {0, 0, 1}, --Frenzied Regeneration
		--[124988] = {90, 30, 0}, --Nature's Vigil
		[124974] = {90, 30, 0}, --Nature's Vigil
		
		--["HUNTER"] = {},
		[172106] = {180, 6}, -- "Aspect of the Fox"
		
		--["MAGE"] = {},
		[159916]	= {120, 6}, -- "Amplify Magic"
		[157913]	= {45, 3, 1}, -- "Evanesce"
		[110960] = {90, 20, 1}, -- greater invisibility - 110959 too
		
		--["MONK"] = {},
		[115295] = {30, 30, 1}, -- Guard
		[116849] = {120, 12, 0}, -- Life Cocoon (a)
		[115310] = {180, 0, 0}, -- Revival
		[119582] = {60, 0, 1}, -- Purifying Brew
		[116844] = {45, 8, 0}, --Ring of Peace
		[115308] = {0, 6, 1}, --Elusive Brew
		[122783] = {90, 6}, -- Diffuse Magic
		[122278] = {90, 45}, -- Dampen Harm
		[115176] = {180, 8, 1}, -- Zen Meditation
		[115203] = {180, 20, 1}, -- Fortifying Brew
		[157535] = {90, 10}, -- "Breath of the Serpent"
		
		--["PALADIN"] = {},
		[633]	=	{600, 0, 0}, --Lay on Hands
		[31821]	=	{180, 6, 0},-- Devotion Aura
		
		--["PRIEST"] = {},
		[62618] = {180, 10, 0}, --Power Word: Barrier
		[109964] = {60, 10, 0}, --Spirit Shell
		[64843] = {180, 8, 0}, --Divine Hymn
		--[108968] = {300, 0, 0}, --Void Shift holy disc
		--[142723] = {600, 0, 0}, --Void Shift shadow
		
		--["ROGUE"] = {},
		[76577] = {180, 0, 0}, --Smoke Bomb
		
		--["SHAMAN"] = {},
		[108270] = {60, 5, 1}, -- Stone Bulwark Totem
		[108280]	=	{180, 12}, -- Healing Tide Totem
		[98008]	=	{180, 6}, -- Spirit Link Totem
		[108281]	=	{120, 10}, -- Ancestral Guidance
		[165344]	=	{180, 15}, -- "Ascendance"
		[152256]	=	{300, 60}, -- "Storm Elemental Totem"
		
		--["WARLOCK"] = {108416, 6229},
		[108416] = {60, 20, 1}, -- Sacrificial Pact  1 = self
		--[6229] = {30, 30, 1}, -- Twilight Ward  1 = self
		
		--["WARRIOR"] = {},
		--[114203]	= {180, 15}, -- Demoralizing Banner
		[114028]	= {60, 5}, -- Mass Spell Reflection
		[97462]	= {180, 10}, -- Rallying Cry
		[2565] 	= {12, 6, 1}, -- Shield Block
		[871] = {180, 12, 1}, -- Shield Wall
		[12975] = {180, 20, 1}, -- Last Stand
		[23920] = {25, 5, 1}, -- Spell Reflection
		[114030] = {120, 12}, -- Vigilance
		[118038] = {120, 8, 1}, -- Die by the Sword
		[112048]	= {90, 6, 1}, -- Shield Barrier
	}
	
	_detalhes.DefensiveCooldownSpells = {
	
		--> spellid = {cooldown, duration}
		
		-- Death Knigh 
		[55233] = {60, 10}, -- Vampiric Blood
		[49222] = {60, 300}, -- Bone Shield
		[48792] = {180, 12}, -- Icebound Fortitude
		[48743] = {120, 0}, -- Death Pact
		[49039] = {12, 10}, -- Lichborne
		["DEATHKNIGHT"] = {55233, 49222, 48707, 48792, 48743, 49039, 48743, 51052, 152279},

		-- Druid
		[62606] = {1.5, 6}, -- Savage Defense
		--[106922] = {180, 20}, -- Might of Ursoc
		[102342] = {60, 12}, -- Ironbark
		[61336] = {180, 12}, -- Survival Instincts
		[22812] = {60, 12}, -- Barkskin
		[155835] = {60, 3}, -- Bristling Fur
		["DRUID"] = {62606, 102342, 61336, 22812, 740, 22842, 155835}, --106922
		
		-- Hunter
		[19263] = {120, 5}, -- Deterrence
		["HUNTER"] = {19263, 172106},
		
		-- Mage
		[45438] = {300, 12}, -- Ice Block
		["MAGE"] = {45438, 159916, 157913, 110960},
		
		-- Monk
		[122470] = {90, 10}, -- Touch of Karma
		--[115213] = {180, 6}, -- Avert Harm
		["MONK"] = {122470, 115295, 115203, 115176, 116849, 122278, 122783, 115310, 119582, 116844, 115308, 157535}, --115213
		
		-- Paladin
		[86659] = {180, 12}, -- Guardian of Ancient Kings
		[31850] = {180, 10}, -- Ardent Defender
		[498] = {60, 10}, -- Divine Protection
		[642] = {300, 8}, -- Divine Shield
		[6940] = {120, 12}, -- Hand of Sacrifice
		[1022] = {300, 10}, -- Hand of Protection
		[1038] = {120, 10}, -- Hand of Salvation
		["PALADIN"] = {86659, 31850, 498, 642, 6940, 1022, 1038, 633, 31821},

		-- Priest
		[15286] = {180, 15}, -- Vampiric Embrace
		[47788] = {180, 10}, -- Guardian Spirit
		[47585] = {120, 6}, -- Dispersion
		[33206] = {180, 8}, -- Pain Suppression
		["PRIEST"] = {15286, 47788, 47585, 33206, 62618, 109964, 64843}, --108968 142723
		
		-- Rogue
		[1966] = {1.5, 5}, -- Feint
		[31224] = {60, 5}, -- Cloak of Shadows
		[5277] = {180, 15}, -- Evasion
		["ROGUE"] = {1966, 31224, 5277, 76577},
		
		-- Shaman
		[30823] = {60, 15}, -- Shamanistic Rage
		[108271] = {120, 6}, -- Astral Shift
		["SHAMAN"] = {30823, 108271, 108270, 108280, 98008, 108281, 165344, 152256},
		
		-- Warlock
		[104773] = {180, 8}, -- Unending Resolve
		[108359] = {120, 12}, -- Dark Regeneration
		[110913] = {180, 8}, -- Dark Bargain
		["WARLOCK"] = {104773, 108359, 108416, 110913}, --6229

		-- Warrior
		[871] = {180, 12}, -- Shield Wall
		[12975] = {180, 20}, -- Last Stand
		[23920] = {25, 5}, -- Spell Reflection
		[114030] = {120, 12}, -- Vigilance
		[118038] = {120, 8}, -- Die by the Sword
		[112048]	= {90, 6}, -- Shield Barrier
		["WARRIOR"] = {871, 12975, 23920, 114030, 118038, 114028, 97462, 2565} --114203

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
	
	_detalhes.DualSideSpells = {
		[114165]	=	true,-- Holy Prism (paladin)
		[47750]	=	true, -- Penance (priest)
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
	
	function _detalhes:IsCooldown (spellid)
		return _detalhes.DefensiveCooldownSpellsNoBuff [spellid] or _detalhes.DefensiveCooldownSpells [spellid]
	end

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
	}
	
	_detalhes.OverrideSpellSchool = {
		--[196917] = 126, --light of the martyr - from holy to fire
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
