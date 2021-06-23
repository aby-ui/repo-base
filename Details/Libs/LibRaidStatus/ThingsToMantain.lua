
--data which main need maintenance over time

if (not LIB_RAID_STATUS_CAN_LOAD) then
	return
end

LIB_RAID_STATUS_AUGMENTATED_RUNE = 347901

LIB_RAID_STATUS_COVENANT_ICONS = {
	[[Interface\ICONS\UI_Sigil_Kyrian]], --kyrian
	[[Interface\ICONS\UI_Sigil_Venthyr]], --venthyr
	[[Interface\ICONS\UI_Sigil_NightFae]], --nightfae
	[[Interface\ICONS\UI_Sigil_Necrolord]], --necrolords
}

--which gear slots can be enchanted on the latest retail version of the game
--when the value is a number, the slot only receives enchants for a specific attribute
LIB_RAID_STATUS_ENCHANT_SLOTS = {
    --[INVSLOT_NECK] = true,

    [INVSLOT_BACK] = true, --for all
    [INVSLOT_CHEST] = true, --for all
	[INVSLOT_FINGER1] = true, --for all
    [INVSLOT_FINGER2] = true, --for all
    [INVSLOT_MAINHAND] = true, --for all

    [INVSLOT_FEET] = 2, --agility only
    [INVSLOT_WRIST] = 1, --intellect only
    [INVSLOT_HAND] = 3, --strenth only
}

-- how to get the enchantId:
-- local itemLink = GetInventoryItemLink("player", slotId)
-- local enchandId = select (3, strsplit(":", itemLink))
-- print("enchantId:", enchandId)
LIB_RAID_STATUS_ENCHANT_IDS = {
    --FEET
        --[6207] = INVSLOT_FEET, --[Enchant Boots - Speed of Soul]
        [6211] = INVSLOT_FEET, --[Enchant Boots - Eternal Agility] + 15 agi
        [6212] = INVSLOT_FEET, --[Enchant Boots - Agile Soulwalker] + 10 agi

    --WRIST
        --[6222] = INVSLOT_WRIST, [Enchant Bracers - Shaded Hearthing]
        [6219] = INVSLOT_WRIST, --[Enchant Bracers - Illuminated Soul] + 10 int
        [6220] = INVSLOT_WRIST, --[Enchant Bracers - Eternal Intellect] + 15 int

    --HAND
        --[6205] = INVSLOT_HAND, --[Enchant Gloves - Shadowlands Gathering]
        [6209] = INVSLOT_HAND, --[Enchant Gloves - Strength of Soul] +10 str
        [6210] = INVSLOT_HAND, --[Enchant Gloves - Eternal Strength] +15 str

    --FINGER
        [6164] = INVSLOT_FINGER1, --[Enchant Ring - Tenet of Critical Strike] +16
        [6166] = INVSLOT_FINGER1, --[Enchant Ring - Tenet of Haste] +16
        [6168] = INVSLOT_FINGER1, --[Enchant Ring - Tenet of Mastery] +16
        [6170] = INVSLOT_FINGER1, --[Enchant Ring - Tenet of Versatility] +16

    --BACK
        [6202] = INVSLOT_BACK, --[Enchant Cloak - Fortified Speed] +20 stam +30 speed
        [6203] = INVSLOT_BACK, --[Enchant Cloak - Fortified Avoidance] +20 stam +30 avoidance
        [6204] = INVSLOT_BACK, --[Enchant Cloak - Fortified Leech]
        [6208] = INVSLOT_BACK, --[Enchant Cloak - Soul Vitality]

    --CHEST
        [6213] = INVSLOT_CHEST, --[Enchant Chest - Eternal Bulwark] +25 armor +20 agi or str
        [6214] = INVSLOT_CHEST, --[Enchant Chest - Eternal Skirmish] +20 agi or str +more white damage
        [6217] = INVSLOT_CHEST, --[Enchant Chest - Eternal Bounds] +20 int + 6% mana
        [6216] = INVSLOT_CHEST, --[Enchant Chest - Sacred Stats] +20 all stats
        [6230] = INVSLOT_CHEST, --[Enchant Chest - Eternal Stats] +30 all stats
    
    --MAINHAND
        [6223] = INVSLOT_MAINHAND, --[Enchant Weapon - Lightless Force] + shadow wave damage
        [6226] = INVSLOT_MAINHAND, --[Enchant Weapon - Eternal Grace] + burst of healing done
        [6227] = INVSLOT_MAINHAND, --[Enchant Weapon - Ascended Vigor] + healing received increased
        [6228] = INVSLOT_MAINHAND, --[Enchant Weapon - Sinful Revelation] + 6% bleed damage
        [6229] = INVSLOT_MAINHAND, --[Enchant Weapon - Celestial Guidance] + 5% agility
}

-- how to get the gemId:
-- local itemLink = GetInventoryItemLink("player", slotId)
-- local gemId = select (4, strsplit(":", itemLink))
-- print("gemId:", gemId)
LIB_RAID_STATUS_GEM_IDS = {
    [173126] = true, --Straddling Jewel Doublet (green, +12 speed)
    [173125] = true, --Revitalizing Jewel Doublet (green, +100 health)
    [173130] = true, --Masterful Jewel Cluster (blue, master)
    [173129] = true, --Versatile Jewel Cluster (blue, versatility)
    [173127] = true, --Deadly Jewel Cluster (blue, crit)
    [173128] = true, --Quick Jewel Cluster (blue, haste)
}

LIB_RAID_STATUS_WEAPON_ENCHANT_IDS = {
	[6188] = true, --shadowcore oil
	[6190] = true, --embalmer's oil
	[6201] = true, --weighted
	[6200] = true, --sharpened
	[5400] = true, --flametongue
	[5401] = true, --windfury
}

LIB_RAID_STATUS_COOLDOWNS_BY_SPEC = {
	-- 1 attack cooldown
	-- 2 personal defensive cooldown
	-- 3 targetted defensive cooldown
	-- 4 raid defensive cooldown
	-- 5 personal utility cooldown

	--Shadowlands 9.0.2 revision by Juliana Maison

	--MAGE
		--arcane
		[62]	= {
			[12042] = 1, --Arcane Power
			[55342] = 1, --Mirror Image
			[45438] = 2, --Ice Block
			[12051] = 5, --Evocation
			[110960] = 5, --Greater Invisibility
			[235450] = 5, --Prismatic Barrier
		},
		--fire
		[63] = {
			[190319] = 1, --Combustion
			[55342] = 1, --Mirror Image
			[45438] = 2, --Ice Block
			[66] = 5, --Invisibility
			[235313] = 5, --Blazing Barrier
		},
		--frost
		[64] = {
			[12472] = 1, --Icy Veins
			[205021] = 1, --Ray of Frost (talent)
			[55342] = 1, --Mirror Image
			[45438] = 2, --Ice Block
			[66] = 5, --Invisibility
			[235219] = 5, --Cold Snap
			[11426] = 5, --Ice Barrier
			[113724] = 5, --Ring of Frost (talent)
		},
	
	--PRIEST
		--discipline
		[256] = {
			[10060] = 1, --Power Infusion
			[34433] = 1, --Shadowfiend
			[123040] = 1, --Mindbender
			[33206] = 3, --Pain Suppression
			[62618] = 4, --Power Word: Barrier
			[271466] = 4, --Luminous Barrier (talent)
			[109964] = 4, --Spirit Shell (talent)
			[47536] = 5, --Rapture
			[19236] = 5, --Desperate Prayer
			[8122] = 5, --Psychic Scream
		},
		--holy
		[257] = {
			[10060] = 1, --Power Infusion
			[200183] = 2, --Apotheosis
			[47788] = 3, --Guardian Spirit
			[64844] = 4, --Divine Hymn
			[64901] = 4, --Symbol of Hope
			[265202] = 4, --Holy Word: Salvation (talent)
			--[88625] = 5, --Holy Word: Chastise
			--[34861] = 5, --Holy Word: Sanctify
			[19236] = 5, --Desperate Prayer
			[8122] = 5, --Psychic Scream
		},
		--shadow priest
		[258] = {
			[10060] = 1, --Power Infusion
			[34433] = 1, --Shadowfiend
			[200174] = 1, --Mindbender
			[193223] = 1, --Surrender to Madness
			[47585] = 2, --Dispersion
			[15286] = 4, --Vampiric Embrace
			[19236] = 5, --Desperate Prayer
			[64044] = 5, --Psychic Horror
			[8122] = 5, --Psychic Scream
			[205369] = 5, --Mind Bomb
		},
	
	--ROGUE
		--assassination
		[259] = {
			[79140] = 1, --Vendetta
			[1856] = 2, --Vanish
			[5277] = 2, --Evasion
			[31224] = 2, --Cloak of Shadows
			[2094] = 5, --Blind
			[185311] = 5, --Crimson Vial
			[114018] = 5, --Shroud of Concealment
		},
		--outlaw
		[260] = {
			[13750] = 1, --Adrenaline Rush
			[51690] = 1, --Killing Spree (talent)
			[199754] = 2, --Riposte
			[31224] = 2, --Cloak of Shadows
			[5277] = 2, --Evasion
			[1856] = 2, --Vanish
			[2094] = 5, --Blind
			[185311] = 5, --Crimson Vial
			[114018] = 5, --Shroud of Concealment
			[343142] = 5, --Dreadblades
		},
		--subtlety
		[261] = {
			[121471] = 1, --Shadow Blades
			[31224] = 2, --Cloak of Shadows
			[1856] = 2, --Vanish
			[5277] = 2, --Evasion
			[2094] = 5, --Blind
			[185311] = 5, --Crimson Vial
			[114018] = 5, --Shroud of Concealment
		},
	
	--WARLOCK
		--affliction
		[265] = {
			[205180] = 1, --Summon Darkglare
			[342601] = 1, --Ritual of Doom
			[113860] = 1, --Dark Soul: Misery (talent)
			[104773] = 2, --Unending Resolve
			[108416] = 2, --Dark Pact (talent)
			[30283] = 5, --Shadowfury
			--[6789] = 5, --Mortal Coil (talent)
			[333889] = 5, --Fel Domination
		},
		--demonology
		[266] = {
			[265187] = 1, --Summon Demonic Tyrant
			[342601] = 1, --Ritual of Doom
			[267171] = 1, --Demonic Strength (talent)
			[111898] = 1, --Grimoire: Felguard (talent)
			[267217] = 1, --Nether Portal (talent)
			
			[104773] = 2, --Unending Resolve
			[108416] = 2, --Dark Pact (talent)
			
			[30283] = 5, --Shadowfury
			--[6789] = 5, --Mortal Coil (talent)
			[5484] = 5, --Howl of Terror (talent)
			[333889] = 5, --Fel Domination
		},
		--destruction
		[267] = {
			[1122] = 1, --Summon Infernal
			[342601] = 1, --Ritual of Doom
			[113858] = 1, --Dark Soul: Instability (talent)
			[104773] = 2, --Unending Resolve
			[108416] = 2, --Dark Pact (talent)
			--[6789] = 5, --Mortal Coil (talent)
			[30283] = 5, --Shadowfury
			[333889] = 5, --Fel Domination
		},
	
	--WARRIOR
		--Arms
		[71] = {
			[107574] = 1, --Avatar (talent)
			[227847] = 1, --Bladestorm
			[152277] = 1, --Ravager (talent)
			[118038] = 2, --Die by the Sword
			[97462] = 4, --Rallying Cry
			[64382] = 5, --Shattering Throw
			--[18499] = 5, --Berserker Rage
			[5246] = 5, --Intimidating Shout
		},
		--Fury
		[72] = {
			[1719] = 1, --Recklessness
			[46924] = 1, --Bladestorm (talent)
			[184364] = 2, --Enraged Regeneration
			[97462] = 4, --Rallying Cry
			[64382] = 5, --Shattering Throw
			--[18499] = 5, --Berserker Rage
			[5246] = 5, --Intimidating Shout
		},
		--Protection
		[73] = {
			[228920] = 1, --Ravager (talent)
			[107574] = 1, --Avatar
			[12975] = 2, --Last Stand
			[871] = 2, --Shield Wall
			[97462] = 4, --Rallying Cry
			[64382] = 5, --Shattering Throw
			--[18499] = 5, --Berserker Rage
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
			[152262] = 2, --Seraphim
			[633] = 3, --Lay on Hands
			[1022] = 3, --Blessing of Protection
			[6940] = 3, --Blessing of Sacrifice
			[31821] = 4, --Aura Mastery
			[1044] = 5, --Blessing of Freedom
			[853] = 5, --Hammer of Justice
			[115750] = 5, --Blinding Light (talent)
		},
		
		--protection
		[66] = {
			[31884] = 1, --Avenging Wrath
			[327193] = 1, --Moment of Glory (talent)
			[31850] = 2, --Ardent Defender
			[86659] = 2, --Guardian of Ancient Kings
			[105809] = 2, --Holy Avenger (talent)
			[152262] = 2, --Seraphim
			[1022] = 3, --Blessing of Protection
			[204018] = 3, --Blessing of Spellwarding (talent)
			[6940] = 3, --Blessing of Sacrifice
			[1044] = 5, --Blessing of Freedom
			[853] = 5, --Hammer of Justice
			[115750] = 5, --Blinding Light (talent)
		},
		
		--retribution
		[70] = {
			[31884] = 1, --Avenging Wrath
			[231895] = 1, --Crusade (talent)
			[205191] = 2, --Eye for an Eye (talent)
			[184662] = 2, --Shield of Vengeance
			[642] = 2, --Divine Shield
			[1022] = 3, --Blessing of Protection
			[6940] = 3, --Blessing of Sacrifice
			[633] = 3, --Lay on Hands
			[1044] = 5, --Blessing of Freedom
			[853] = 5, --Hammer of Justice
			[115750] = 5, --Blinding Light (talent)
		},
	
	--DEMON HUNTER
		--havoc
		[577] = {
			[200166] = 1, --Metamorphosis
			[198589] = 2, --Blur
			[196555] = 2, --Netherwalk (talent)
			[196718] = 4, --Darkness
			[188501] = 5, --Spectral Sight
			[179057] = 5, --Chaos Nova
			[211881] = 5, --Fel Eruption (talent)
		},
		--vengeance
		[581] = {
			[320341] = 1, --Bulk Extraction (talent)
			[187827] = 2, --Metamorphosis
			[204021] = 2, --Fiery Brand
			[263648] = 2, --Soul Barrier (talent)
			[207684] = 5, --Sigil of Misery
			[202137] = 5, --Sigil of Silence
			[202138] = 5, --Sigil of Chains (talent)
			[188501] = 5, --Spectral Sight
		},
		
	--DEATH KNIGHT
		--unholy
		[252] = {
			[275699] = 1, --Apocalypse
			[42650] = 1, --Army of the Dead
			[49206] = 1, --Summon Gargoyle (talent)
			[207289] = 1, --Unholy Assault (talent)
			[48707] = 2, --Anti-magic Shell
			[48792] = 2, --Icebound Fortitude
			[48743] = 2, --Death Pact (talent)
			[51052] = 4, --Anti-magic Zone
			[108194] = 5, --Asphyxiate (talent)
			[287081] = 5, --Lichborne
			[212552] = 5, --Wraith walk (talent)
			
		},
		--frost
		[251] = {
			[152279] = 1, --Breath of Sindragosa (talent)
			[47568] = 1, --Empower Rune Weapon
			[279302] = 1, --Frostwyrm's Fury
			[48707] = 2, --Anti-magic Shell			
			[48792] = 2, --Icebound Fortitude
			[48743] = 2, --Death Pact (talent)
			[51052] = 4, --Anti-magic Zone
			[207167] = 5, --Blinding Sleet (talent)
			[108194] = 5, --Asphyxiate (talent)
			[287081] = 5, --Lichborne
			[212552] = 5, --Wraith walk (talent)
		},
		--blood
		[250] = {
			[49028] = 1, --Dancing Rune Weapon
			[48707] = 2, --Anti-magic Shell
			[48743] = 2, --Death Pact (talent)
			[219809] = 2, --Tombstone (talent)
			[55233] = 2, --Vampiric Blood
			[48792] = 2, --Icebound Fortitude
			[51052] = 4, --Anti-magic Zone
			[108199] = 5, --Gorefiend's Grasp
			[221562] = 5, --Asphyxiate
			[212552] = 5, --Wraith walk (talent)
		},

	--DRUID
		--Balance
		[102] = {
			[194223] = 1, --Celestial Alignment
			[102560] = 1, --Incarnation: Chosen of Elune (talent)
			[22812] = 2, --Barkskin
			[108238] = 2, --Renewal (talent)
			[29166] = 3, --Innervate
			[77761] = 4, --Stampeding Roar
			--[99] = 5, --Incapacitating Roar
			[319454] = 5, --Heart of the Wild (talent)
			[132469] = 5, --Typhoon
			[78675] = 5, --Solar Beam
		},
		--Feral
		[103] = {
			[106951] = 1, --Berserk
			[102543] = 1, --Incarnation: King of the Jungle (talent)
			[22812] = 2, --Barkskin
			[61336] = 2, --Survival Instincts
			[108238] = 2, --Renewal (talent)
			[77764] = 4, --Stampeding Roar
			[132469] = 5, --Typhoon
			[319454] = 5, --Heart of the Wild (talent)
		},
		--Guardian
		[104] = {
			[106951] = 1, --Berserk
			[204066] = 1, --Lunar Beam
			[22812] = 2, --Barkskin	
			[61336] = 2, --Survival Instincts
			[102558] = 2, --Incarnation: Guardian of Ursoc (talent)
			[108238] = 2, --Renewal (talent)
			[77761] = 4, --Stampeding Roar
			[132469] = 5, --Typhoon
			--[99] = 5, --Incapacitating Roar
			[319454] = 5, --Heart of the Wild (talent)
		},
		--Restoration
		[105] = {
			
			[22812] = 2, --Barkskin
			[108238] = 2, --Renewal (talent)
			[33891] = 2, --Incarnation: Tree of Life (talent)
			[102342] = 3, --Ironbark
			[29166] = 3, --Innervate
			[203651] = 3, --Overgrowth (talent)
			[740] = 4, --Tranquility
			[197721] = 4, --Flourish (talent)
			[77761] = 4, --Stampeding Roar
			[319454] = 5, --Heart of the Wild (talent)
			[102793] = 5, --Ursol's Vortex
		},
	
	--HUNTER
		--beast mastery
		[253] = {
			[193530] = 1, --Aspect of the Wild
			[19574] = 1, --Bestial Wrath
			[201430] = 1, --Stampede (talent)
			[186265] = 2, --Aspect of the Turtle
			[109304] = 2, --Exhilaration
			[199483] = 2, --Camouflage (talent)
			[186257] = 5, --Aspect of the cheetah
			[19577] = 5, --Intimidation
			[109248] = 5, --Binding Shot (talent)
			[187650] = 5, --Freezing Trap
		},
		--marksmanship
		[254] = {
			[193526] = 1, --Trueshot
			[186265] = 2, --Aspect of the Turtle
			[199483] = 2, --Camouflage (talent)
			[109304] = 2, --Exhilaration
			[281195] = 2, --Survival of the Fittest
			[186257] = 5, --Aspect of the cheetah
			[187650] = 5, --Freezing Trap
		},
		--survival
		[255] = {
			[266779] = 1, --Coordinated Assault
			[186265] = 2, --Aspect of the Turtle
			[199483] = 2, --Camouflage (talent)
			[109304] = 2, --Exhilaration
			[186289] = 5, --Aspect of the eagle
			[19577] = 5, --Intimidation
			[187650] = 5, --Freezing Trap
		},

	--MONK
		--brewmaster
		[268] = {
			[132578] = 1, --Invoke Niuzao, the Black Ox
			[115080] = 1, --Touch of Death
			[115203] = 2, --Fortifying Brew
			[115399] = 2, --Black Ox brew (talent)
			[115176] = 2, --Zen Meditation
			[122278] = 2, --Dampen Harm (talent)
			[116844] = 5, --Ring of peace (talent)
			[119381] = 5, --Leg Sweep
		},
		--windwalker
		[269] = {
			[137639] = 1, --Storm, Earth, and Fire
			[123904] = 1, --Invoke Xuen, the White Tiger
			[152173] = 1, --Serenity (talent)
			[115080] = 1, --Touch of Death
			[115203] = 2, --Fortifying Brew
			[122470] = 2, --Touch of Karma
			[122278] = 2, --Dampen Harm (talent)
			[122783] = 2, --Diffuse Magic (talent)
			[116844] = 5, --Ring of peace (talent)
			[119381] = 5, --Leg Sweep
		},
		--mistweaver
		[270] = {
			[115080] = 1, --Touch of Death
			[122278] = 2, --Dampen Harm (talent)
			[243435] = 2, --Fortifying Brew
			[122783] = 2, --Diffuse Magic (talent)
			[116849] = 3, --Life Cocoon
			[322118] = 4, --Invoke Yulon, the Jade serpent
--			[198664] = 4, --Invoke Chi-Ji, the Red Crane (talent)
			[115310] = 4, --Revival
			[116844] = 5, --Ring of peace (talent)
			[197908] = 5, --Mana tea (talent)
			[119381] = 5, --Leg Sweep
		},
	
	--SHAMAN
		--elemental
		[262] = {
			[198067] = 1, --Fire Elemental
			[192249] = 1, --Storm Elemental (talent)
			[114050] = 1, --Ascendance (talent)
			[108271] = 2, --Astral Shift
			[108281] = 4, --Ancestral Guidance (talent)
			[198103] = 2, --Earth Elemental
			--[79206] = 5, --Spiritwalkers grace
			[65992] = 5, --Tremor Totem
			[192058] = 5, --Capacitor Totem
			[192077] = 5, --Wind Rush Totem (talent)
		},
		--enhancement
		[263] = {
			[51533] = 1, --Feral Spirit
			[114051] = 1, --Ascendance (talent)
			[108271] = 2, --Astral Shift
			[198103] = 2, --Earth Elemental
			[65992] = 5, --Tremor Totem
			[192058] = 5, --Capacitor Totem

		},
		--restoration
		[264] = {
			[108271] = 2, --Astral Shift
			[114052] = 2, --Ascendance (talent)
			[98008] = 4, --Spirit Link Totem
			[108280] = 4, --Healing Tide Totem
			[16191] = 4, --Mana Tide Totem
			[207399] = 4, --Ancestral Protection Totem (talent)
			[198103] = 2, --Earth Elemental
			[65992] = 5, --Tremor Totem
		},
}

--tells the duration, requirements and cooldown
--information about a cooldown is mainly get from tooltips
--if talent is required, use the command:
--/dump GetTalentInfo (talentTier, talentColumn, 1)
--example: to get the second talent of the last talent line, use: /dump GetTalentInfo (7, 2, 1)
LIB_RAID_STATUS_COOLDOWNS_INFO = {
	--> paladin
	[31884] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "PALADIN", type = 1}, --Avenging Wrath
	[216331] = {cooldown = 120, duration = 20, talent = 22190, charges = 1, class = "PALADIN", type = 1}, --Avenging Crusader (talent)
	[498] = {cooldown = 60, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Divine Protection
	[642] = {cooldown = 300, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Divine Shield
	[105809] = {cooldown = 90, duration = 20, talent = 22164, charges = 1, class = "PALADIN", type = 2}, --Holy Avenger (talent)
	[152262] = { cooldown = 45, duration = 15, talent = 17601, charges = 1, class = "PALADIN", type = 2}, --Seraphim
	[633] = {cooldown = 600, duration = false, talent = false, charges = 1, class = "PALADIN", type = 3}, --Lay on Hands
	[1022] = {cooldown = 300, duration = 10, talent = false, charges = 1, class = "PALADIN", type = 3}, --Blessing of Protection
	[6940] = {cooldown = 120, duration = 12, talent = false, charges = 1, class = "PALADIN", type = 3}, --Blessing of Sacrifice
	[31821] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 4}, --Aura Mastery
	[1044] = {cooldown = 25, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 5}, --Blessing of Freedom
	[853] = {cooldown = 60, duration = 6, talent = false, charges = 1, class = "PALADIN", type = 5}, --Hammer of Justice
	[115750] = {cooldown = 90, duration = 6, talent = 21811, charges = 1, class = "PALADIN", type = 5}, --Blinding Light(talent)
	[327193] = {cooldown = 90, duration = 15, talent = 23468, charges = 1, class = "PALADIN", type = 1}, --Moment of Glory (talent)
	[31850] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Ardent Defender
	[86659] = {cooldown = 300, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Guardian of Ancient Kings
	[204018] = {cooldown = 180, duration = 10, talent = 22435, charges = 1, class = "PALADIN", type = 3}, --Blessing of Spellwarding (talent)
	[231895] = {cooldown = 120, duration = 25, talent = 22215, charges = 1, class = "PALADIN", type = 1}, --Crusade (talent)
	[205191] = {cooldown = 60, duration = 10, talent = 22183, charges = 1, class = "PALADIN", type = 2}, --Eye for an Eye (talent)
	[184662] = {cooldown = 120, duration = 15, talent = false, charges = 1, class = "PALADIN", type = 2}, --Shield of Vengeance
	
	--> warrior
	[107574] = {cooldown = 90, duration = 20, talent = 22397, charges = 1, class = "WARRIOR", type = 1}, --Avatar
	[227847] = {cooldown = 90, duration = 5, talent = false, charges = 1, class = "WARRIOR", type = 1}, --Bladestorm
	[152277] = {cooldown = 60, duration = 6, talent = 21667, charges = 1, class = "WARRIOR", type = 1}, --Ravager (talent)
	[118038] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "WARRIOR", type = 2}, --Die by the Sword
	[97462] = {cooldown = 180, duration = 10, talent = false, charges = 1, class = "WARRIOR", type = 4}, --Rallying Cry
	[1719] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "WARRIOR", type = 1}, --Recklessness
	[46924] = {cooldown = 60, duration = 4, talent = 22400, charges = 1, class = "WARRIOR", type = 1}, --Bladestorm (talent)
	[184364] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "WARRIOR", type = 2}, --Enraged Regeneration
	[228920] = {cooldown = 60, duration = 6, talent = 23099, charges = 1, class = "WARRIOR", type = 1}, --Ravager (talent)
	[12975] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "WARRIOR", type = 2}, --Last Stand
	[871] = {cooldown = 8, duration = 240, talent = false, charges = 1, class = "WARRIOR", type = 2}, --Shield Wall
	[64382]  = {cooldown = 180, duration = false, talent = false, charges = 1, class = "WARRIOR", type = 5}, --Shattering Throw
	[5246]  = {cooldown = 90, duration = 8, talent = false, charges = 1, class = "WARRIOR", type = 5}, --Intimidating Shout

	
	--> warlock
	[205180] = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "WARLOCK", type = 1}, --Summon Darkglare
	[342601] = {cooldown = 3600, duration = false, talent = false, charges = 1, class = "WARLOCK", type = 1}, --Ritual of Doom
	[113860] = {cooldown = 120, duration = 20, talent = 19293, charges = 1, class = "WARLOCK", type = 1}, --Dark Soul: Misery (talent)
	[104773] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "WARLOCK", type = 2}, --Unending Resolve
	[108416] = {cooldown = 60, duration = 20, talent = 19286, charges = 1, class = "WARLOCK", type = 2}, --Dark Pact (talent)
	[265187] = {cooldown = 90, duration = 15, talent = false, charges = 1, class = "WARLOCK", type = 1}, --Summon Demonic Tyrant
	[111898] = {cooldown = 120, duration = 15, talent = 21717, charges = 1, class = "WARLOCK", type = 1}, --Grimoire: Felguard (talent)
	[267171] = {cooldown = 60, duration = false, talent = 23138, charges = 1, class = "WARLOCK", type = 1}, --Demonic Strength (talent)
	[267217] = {cooldown = 180, duration = 20, talent = 23091, charges = 1, class = "WARLOCK", type = 1}, --Nether Portal
	[1122] = {cooldown = 180, duration = 30, talent = false, charges = 1, class = "WARLOCK", type = 1}, --Summon Infernal
	[113858] = {cooldown = 120, duration = 20, talent = 23092, charges = 1, class = "WARLOCK", type = 1}, --Dark Soul: Instability (talent)
	[30283] = {cooldown = 60, duration = 3, talent = false, charges = 1, class = "WARLOCK", type = 5}, --Shadowfury
	[333889] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "WARLOCK", type = 5}, --Fel Domination
	--[6789] = {cooldown = 45, duration = 3, talent = 19291, charges = 1, class = "WARLOCK", type = 5}, --Mortal Coil (talent)
	[5484] = {cooldown = 40, duration = 20, talent = 23465, charges = 1, class = "WARLOCK", type = 5}, --Howl of Terror (talent)

	--> shaman
	[198067] = {cooldown = 150, duration = 30, talent = false, charges = 1, class = "SHAMAN", type = 1}, --Fire Elemental
	[192249] = {cooldown = 150, duration = 30, talent = 19272, charges = 1, class = "SHAMAN", type = 1}, --Storm Elemental (talent)
	[108271] = {cooldown = 90, duration = 8, talent = false, charges = 1, class = "SHAMAN", type = 2}, --Astral Shift
	[108281] = {cooldown = 120, duration = 10, talent = 22172, charges = 1, class = "SHAMAN", type = 4}, --Ancestral Guidance (talent)
	[51533] = {cooldown = 120, duration = 15, talent = false, charges = 1, class = "SHAMAN", type = 1}, --Feral Spirit
	[114050] = {cooldown = 180, duration = 15, talent = 21675, charges = 1, class = "SHAMAN", type = 1}, --Ascendance (talent)
	[114051] = {cooldown = 180, duration = 15, talent = 21972, charges = 1, class = "SHAMAN", type = 1}, --Ascendance (talent)
	[114052] = {cooldown = 180, duration = 15, talent = 22359, charges = 1, class = "SHAMAN", type = 2}, --Ascendance (talent)
	[98008] = {cooldown = 180, duration = 6, talent = false, charges = 1, class = "SHAMAN", type = 4}, --Spirit Link Totem
	[108280] = {cooldown = 180, duration = 10, talent = false, charges = 1, class = "SHAMAN", type = 4}, --Healing Tide Totem
	[207399] = {cooldown = 240, duration = 30, talent = 22323, charges = 1, class = "SHAMAN", type = 4}, --Ancestral Protection Totem (talent)
	[16191] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "SHAMAN", type = 4}, --Mana Tide Totem
	[198103] = {cooldown = 300, duration = 60, talent = false, charges = 1, class = "SHAMAN", type = 2}, --Earth Elemental
	[192058] = {cooldown = 60, duration = false, talent = false, charges = 1, class = "SHAMAN", type = 5}, --Capacitor Totem
	[65992] = {cooldown = 60, duration = 10, talent = false, charges = 1, class = "SHAMAN", type = 5}, --Tremor Totem
	[192077] = {cooldown = 120, duration = 15, talent = 21966, charges = 1, class = "SHAMAN", type = 5}, --Wind Rush Totem (talent)
	
	--> monk
	[132578] = {cooldown = 180, duration = 25, talent = false, charges = 1, class = "MONK", type = 1}, --Invoke Niuzao, the Black Ox
	[115080] = {cooldown = 180, duration = false, talent = false, charges = 1, class = "MONK", type = 1}, --Touch of Death
	[115203] = {cooldown = 420, duration = 15, talent = false, charges = 1, class = "MONK", type = 2}, --Fortifying Brew
	[115176] = {cooldown = 300, duration = 8, talent = false, charges = 1, class = "MONK", type = 2}, --Zen Meditation
	[115399] = {cooldown = 120, duration = false, talent = 19992, charges = 1, class = "MONK", type = 2}, --Black Ox brew (talent)
	[122278] = {cooldown = 120, duration = 10, talent = 20175, charges = 1, class = "MONK", type = 2}, --Dampen Harm (talent)
	[137639] = {cooldown = 90, duration = 15, talent = false, charges = 1, class = "MONK", type = 1}, --Storm, Earth, and Fire
	[123904] = {cooldown = 120, duration = 24, talent = false, charges = 1, class = "MONK", type = 1}, --Invoke Xuen, the White Tiger
	[152173] = {cooldown = 90, duration = 12, talent = 21191, charges = 1, class = "MONK", type = 1}, --Serenity (talent)
	[122470] = {cooldown = 90, duration = 6, talent = false, charges = 1, class = "MONK", type = 2}, --Touch of Karma
	[322118] = {cooldown = 180, duration = 25, talent = false, charges = 1, class = "MONK", type = 4}, --Invoke Yulon, the Jade serpent
--	[198664] = {cooldown = 180, duration = 25, talent = 22214, charges = 1, class = "MONK", type = 4}, --Invoke Chi-Ji, the Red Crane (talent)
	[243435] = {cooldown = 90, duration = 15, talent = false, charges = 1, class = "MONK", type = 2}, --Fortifying Brew
	[122783] = {cooldown = 90, duration = 6, talent = 20173, charges = 1, class = "MONK", type = 2}, --Diffuse Magic (talent)
	[116849] = {cooldown = 120, duration = 12, talent = false, charges = 1, class = "MONK", type = 3}, --Life Cocoon
	[115310] = {cooldown = 180, duration = false, talent = false, charges = 1, class = "MONK", type = 4}, --Revival
	[197908] = {cooldown = 90, duration = 10, talent = 22166, charges = 1, class = "MONK", type = 5}, --Mana tea (talent)
	[116844] = {cooldown = 45, duration = 5, talent = 19995, charges = 1, class = "MONK", type = 5}, --Ring of peace (talent)
	[119381] = {cooldown = 50, duration = 3, talent = false, charges = 1, class = "MONK", type = 5}, --Leg Sweep
	
	--> hunter
	[193530] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "HUNTER", type = 1}, --Aspect of the Wild
	[19574] = {cooldown = 90, duration = 12, talent = false, charges = 1, class = "HUNTER", type = 1}, --Bestial Wrath
	[201430] = {cooldown = 180, duration = 12, talent = 23044, charges = 1, class = "HUNTER", type = 1}, --Stampede (talent)
	[193526] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "HUNTER", type = 1}, --Trueshot
	[199483] = {cooldown = 60, duration = 60, talent = 23100, charges = 1, class = "HUNTER", type = 2}, --Camouflage (talent)
	[281195] = {cooldown = 180, duration = 6,  talent = false, charges = 1, class = "HUNTER", type = 2}, --Survival of the Fittest
	[266779] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "HUNTER", type = 1}, --Coordinated Assault
	[186265] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "HUNTER", type = 2}, --Aspect of the Turtle
	[109304] = {cooldown = 120, duration = false, talent = false, charges = 1, class = "HUNTER", type = 2}, --Exhilaration
	[186257] = {cooldown = 144, duration = 14, talent = false, charges = 1, class = "HUNTER", type = 5}, --Aspect of the cheetah
	[19577] = {cooldown = 60, duration = 5, talent = false, charges = 1, class = "HUNTER", type = 5}, --Intimidation
	[109248] = {cooldown = 45, duration = 10, talent = 22499, charges = 1, class = "HUNTER", type = 5}, --Binding Shot (talent)
	[187650] = {cooldown = 25, duration = 60, talent = false, charges = 1, class = "HUNTER", type = 5}, --Freezing Trap
	[186289] = {cooldown = 72, duration = 15, talent = false, charges = 1, class = "HUNTER", type = 5}, --Aspect of the eagle

	--> druid
	[77761] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "DRUID", type = 4}, --Stampeding Roar
	[194223] = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "DRUID", type = 1}, --Celestial Alignment
	[102560] = {cooldown = 180, duration = 30, talent = 21702, charges = 1, class = "DRUID", type = 1}, --Incarnation: Chosen of Elune (talent)
	[22812] = {cooldown = 60, duration = 12, talent = false, charges = 1, class = "DRUID", type = 2}, --Barkskin
	[108238] = {cooldown = 90, duration = false, talent = 18570, charges = 1, class = "DRUID", type = 2}, --Renewal (talent)
	[29166] = {cooldown = 180, duration = 12, talent = false, charges = 1, class = "DRUID", type = 3}, --Innervate
	[78675] = {cooldown = 60, duration = 8, talent = false, charges = 1, class = "DRUID", type = 5}, --Solar Beam
	[106951] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "DRUID", type = 1}, --Berserk
	[102543] = {cooldown = 30, duration = 180, talent = 21704, charges = 1, class = "DRUID", type = 1}, --Incarnation: King of the Jungle (talent)
	[61336] = {cooldown = 120, duration = 6, talent = false, charges = 2, class = "DRUID", type = 2}, --Survival Instincts (2min feral 4min guardian, same spellid)
	[77764] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "DRUID", type = 4}, --Stampeding Roar (utility)
	[102558] = {cooldown = 180, duration = 30, talent = 22388, charges = 1, class = "DRUID", type = 2}, --Incarnation: Guardian of Ursoc (talent)
	[33891] = {cooldown = 180, duration = 30, talent = 22421, charges = 1, class = "DRUID", type = 2}, --Incarnation: Tree of Life (talent)
	[102342] = {cooldown = 60, duration = 12, talent = false, charges = 1, class = "DRUID", type = 3}, --Ironbark
	[203651] = {cooldown = 60, duration = false, talent = 22422, charges = 1, class = "DRUID", type = 3}, --Overgrowth (talent)
	[740] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "DRUID", type = 4}, --Tranquility
	[197721] = {cooldown = 90, duration = 8, talent = 22404, charges = 1, class = "DRUID", type = 4}, --Flourish (talent)
	[132469] = {cooldown = 30, duration = false, talent = false, charges = 1, class = "DRUID", type = 5}, --Typhoon
	[319454] = {cooldown = 300, duration = 45, talent = 18577, charges = 1, class = "DRUID", type = 5}, --Heart of the Wild (talent)
	[102793] = {cooldown = 60, duration = 10, talent = false, charges = 1, class = "DRUID", type = 5}, --Ursol's Vortex

	--> death knight
	[275699] = {cooldown = 90, duration = 15, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Apocalypse
	[42650] = {cooldown = 480, duration = 30, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Army of the Dead
	[49206] = {cooldown = 180, duration = 30, talent = 22110, charges = 1, class = "DEATHKNIGHT", type = 1}, --Summon Gargoyle (talent)
	[207289] = {cooldown = 78, duration = 12, talent = 22538, charges = 1, class = "DEATHKNIGHT", type = 1}, --Unholy Assault (talent)
	[48743] = {cooldown = 120, duration = 15, talent = 23373, charges = 1, class = "DEATHKNIGHT", type = 2}, --Death Pact (talent)
	[48707] = {cooldown = 60, duration = 10, talent = 23373, charges = 1, class = "DEATHKNIGHT", type = 2}, --Anti-magic Shell
	[152279] = {cooldown = 120, duration = 5, talent = 22537, charges = 1, class = "DEATHKNIGHT", type = 1}, --Breath of Sindragosa (talent)
	[47568] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Empower Rune Weapon
	[279302] = {cooldown = 120, duration = 10, talent = 22535, charges = 1, class = "DEATHKNIGHT", type = 1}, --Frostwyrm's Fury (talent)
	[49028] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Dancing Rune Weapon
	[55233] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "DEATHKNIGHT", type = 2}, --Vampiric Blood
	[48792] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "DEATHKNIGHT", type = 2}, --Icebound Fortitude
	[51052] = {cooldown = 120, duration = 10, talent = false, charges = 1, class = "DEATHKNIGHT", type = 4}, --Anti-magic Zone
	[219809]  = {cooldown = 60, duration = 8, talent = 23454, charges = 1, class = "DEATHKNIGHT", type = 2}, --Tombstone (talent)
	[108199] = {cooldown = 120, duration = false, talent = false, charges = 1, class = "DEATHKNIGHT", type = 5}, --Gorefiend's Grasp
	[207167] = {cooldown = 60, duration = 5, talent = 22519, charges = 1, class = "DEATHKNIGHT", type = 5}, --Blinding Sleet (talent)
	[108194] = {cooldown = 45, duration = 4, talent = 22520, charges = 1, class = "DEATHKNIGHT", type = 5}, --Asphyxiate (talent)
	[221562]  = {cooldown = 45, duration = 5, talent = false, charges = 1, class = "DEATHKNIGHT", type = 5}, --Asphyxiate
	[212552]  = {cooldown = 60, duration = 4, talent = 19228, charges = 1, class = "DEATHKNIGHT", type = 5}, --Wraith walk (talent)

	--> demon hunter
	[200166] = {cooldown = 240, duration = 30, talent = false, charges = 1, class = "DEMONHUNTER", type = 1}, --Metamorphosis
	[198589] = {cooldown = 60, duration = 10, talent = false, charges = 1, class = "DEMONHUNTER", type = 2}, --Blur
	[196555] = {cooldown = 120, duration = 5, talent = 21865, charges = 1, class = "DEMONHUNTER", type = 2}, --Netherwalk (talent)
	[187827] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "DEMONHUNTER", type = 2}, --Metamorphosis
	[196718] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "DEMONHUNTER", type = 4}, --Darkness
	[188501] = {cooldown = 30, duration = 10, talent = false, charges = 1, class = "DEMONHUNTER", type = 5}, --Spectral Sight
	[179057] = {cooldown = 60, duration = 2, talent = false, charges = 1, class = "DEMONHUNTER", type = 5}, --Chaos Nova
	[211881] = {cooldown = 30, duration = 4, talent = 22767, charges = 1, class = "DEMONHUNTER", type = 5}, --Fel Eruption (talent)
	[320341] = {cooldown = 90, duration = false, talent = 21902, charges = 1, class = "DEMONHUNTER", type = 1}, --Bulk Extraction (talent)
	[204021] = {cooldown = 60, duration = 10, talent = false, charges = 1, class = "DEMONHUNTER", type = 2}, --Fiery Brand
	[263648] = {cooldown = 30, duration = 12, talent = 22768, charges = 1, class = "DEMONHUNTER", type = 2}, --Soul Barrier (talent)
	[207684] = {cooldown = 90, duration = 12, talent = false, charges = 1, class = "DEMONHUNTER", type = 5}, --Sigil of Misery
	[202137] = {cooldown = 60, duration = 8, talent = false, charges = 1, class = "DEMONHUNTER", type = 5}, --Sigil of Silence
	[202138] = {cooldown = 90, duration = 6, talent = 22511, charges = 1, class = "DEMONHUNTER", type = 5}, --Sigil of Chains (talent)
	
	--> mage
	[12042] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "MAGE", type = 1},  --Arcane Power
	[12051] = {cooldown = 90, duration = 6, talent = false, charges = 1, class = "MAGE", type = 1},  --Evocation
	[110960] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "MAGE", type = 2},  --Greater Invisibility
	[235450] = {cooldown = 25, duration = 60, talent = false, charges = 1, class = "MAGE", type = 5},  --Prismatic Barrier
	[235313] = {cooldown = 25, duration = 60, talent = false, charges = 1, class = "MAGE", type = 5},  --Blazing Barrier
	[11426] = {cooldown = 25, duration = 60, talent = false, charges = 1, class = "MAGE", type = 5},  --Ice Barrier
	[190319] = {cooldown = 120, duration = 10, talent = false, charges = 1, class = "MAGE", type = 1},  --Combustion
	[55342] = {cooldown = 120, duration = 40, talent = 22445, charges = 1, class = "MAGE", type = 1},  --Mirror Image
	[66] = {cooldown = 300, duration = 20, talent = false, charges = 1, class = "MAGE", type = 2},  --Invisibility
	[12472] = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "MAGE", type = 1},  --Icy Veins
	[205021] = {cooldown = 78, duration = 5, talent = 22309, charges = 1, class = "MAGE", type = 1},  --Ray of Frost (talent)
	[45438] = {cooldown = 240, duration = 10, talent = false, charges = 1, class = "MAGE", type = 2},  --Ice Block
	[235219] = {cooldown = 300, duration = false, talent = false, charges = 1, class = "MAGE", type = 5},  --Cold Snap
	[113724] = {cooldown = 45, duration = 10, talent = 22471, charges = 1, class = "MAGE", type = 5},  --Ring of Frost (talent)

	--> priest
	[10060] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "PRIEST", type = 1},  --Power Infusion
	[34433] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "PRIEST", type = 1},  --Shadowfiend
	[123040] = {cooldown = 60, duration = 12, talent = 22094, charges = 1, class = "PRIEST", type = 1},  --Mindbender (talent)
	[33206] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "PRIEST", type = 3},  --Pain Suppression
	[62618] = {cooldown = 180, duration = 10, talent = false, charges = 1, class = "PRIEST", type = 4},  --Power Word: Barrier
	[271466] = {cooldown = 180, duration = 10, talent = 21184, charges = 1, class = "PRIEST", type = 4},  --Luminous Barrier (talent)
	[47536] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "PRIEST", type = 5},  --Rapture
	[19236] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "PRIEST", type = 5},  --Desperate Prayer
	[200183] = {cooldown = 120, duration = 20, talent = 21644, charges = 1, class = "PRIEST", type = 2},  --Apotheosis (talent)
	[47788] = {cooldown = 180, duration = 10, talent = false, charges = 1, class = "PRIEST", type = 3},  --Guardian Spirit
	[64844] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "PRIEST", type = 4},  --Divine Hymn
	[64901] = {cooldown = 300, duration = 6, talent = false, charges = 1, class = "PRIEST", type = 4},  --Symbol of Hope
	[265202] = {cooldown = 720, duration = false, talent = 23145, charges = 1, class = "PRIEST", type = 4},  --Holy Word: Salvation (talent)
	[109964]  = {cooldown = 60, duration = 12, talent = 21184, charges = 1, class = "PRIEST", type = 4},  --Spirit Shell (talent)
	[8122] = {cooldown = 60, duration = 8, talent = false, charges = 1, class = "PRIEST", type = 5},  --Psychic Scream
	[200174] = {cooldown = 60, duration = 15, talent = 21719, charges = 1, class = "PRIEST", type = 1},  --Mindbender (talent)
	[193223] = {cooldown = 240, duration = 60, talent = 21979, charges = 1, class = "PRIEST", type = 1},  --Surrender to Madness (talent)
	[47585] = {cooldown = 120, duration = 6, talent = false, charges = 1, class = "PRIEST", type = 2},  --Dispersion
	[15286] = {cooldown = 120, duration = 15, talent = false, charges = 1, class = "PRIEST", type = 4},  --Vampiric Embrace
	[64044] = {cooldown = 45, duration = 4, talent = 21752, charges = 1, class = "PRIEST", type = 5}, --Psychic Horror
	[205369] = {cooldown = 30, duration = 6, talent = 23375, charges = 1, class = "PRIEST", type = 5}, --Mind Bomb

	--> rogue
	[79140] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "ROGUE", type = 1},  --Vendetta
	[1856] = {cooldown = 120, duration = 3, talent = false, charges = 1, class = "ROGUE", type = 2},  --Vanish
	[5277] = {cooldown = 120, duration = 10, talent = false, charges = 1, class = "ROGUE", type = 2},  --Evasion
	[31224] = {cooldown = 120, duration = 5, talent = false, charges = 1, class = "ROGUE", type = 2},  --Cloak of Shadows
	[2094] = {cooldown = 120, duration = 60, talent = false, charges = 1, class = "ROGUE", type = 5},  --Blind
	[114018] = {cooldown = 360, duration = 15, talent = false, charges = 1, class = "ROGUE", type = 5},  --Shroud of Concealment
	[185311] = {cooldown = 30, duration = 15, talent = false, charges = 1, class = "ROGUE", type = 5},  --Crimson Vial
	[13750] = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "ROGUE", type = 1},  --Adrenaline Rush
	[51690] = {cooldown = 120, duration = 2, talent = 23175, charges = 1, class = "ROGUE", type = 1},  --Killing Spree (talent)
	[199754] = {cooldown = 120, duration = 10, talent = false, charges = 1, class = "ROGUE", type = 2},  --Riposte
	[343142] = {cooldown = 90, duration = 10, talent = 19250, charges = 1, class = "ROGUE", type = 5},  --Dreadblades
	[121471]  = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "ROGUE", type = 1},  --Shadow Blades
}
