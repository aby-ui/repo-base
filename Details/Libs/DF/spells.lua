
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

DF_COOLDOWN_RAID = 4
DF_COOLDOWN_EXTERNAL = 3

DF.CooldownsBySpec = {
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
			[113860] = 1, --Dark Soul: Misery (talent)
			[104773] = 2, --Unending Resolve
			
			[108416] = 2, --Dark Pact (talent)
			
			[30283] = 5, --Shadowfury
			[6789] = 5, --Mortal Coil
		},
		--demo
		[266] = {
			[265187] = 1, --Summon Demonic Tyrant
			[111898] = 1, --Grimoire: Felguard (talent)
			[267217] = 1, --Nether Portal (talent)
			
			[104773] = 2, --Unending Resolve
			[108416] = 2, --Dark Pact (talent)
			
			[30283] = 5, --Shadowfury
			[6789] = 5, --Mortal Coil
		},
		--destro
		[267] = {
			[1122] = 1, --Summon Infernal
			[113858] = 1, --Dark Soul: Instability (talent)
			
			[104773] = 2, --Unending Resolve
			[108416] = 2, --Dark Pact (talent)
			
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
			[243435] = 2, --Fortifying Brew
			[122783] = 2, --Diffuse Magic (talent)
			
			[116849] = 3, --Life Cocoon
			
			[198664] = 4, --Invoke Chi-Ji, the Red Crane (talent)
			
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

-->  tells the duration, requirements and cooldown of a cooldown
DF.CooldownsInfo = {
	--> paladin
	[31884] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "PALADIN", type = 1}, --Avenging Wrath
	[216331] = {cooldown = 120, duration = 20, talent = 22190, charges = 1, class = "PALADIN", type = 1}, --Avenging Crusader (talent)
	[498] = {cooldown = 60, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Divine Protection
	[642] = {cooldown = 300, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Divine Shield
	[105809] = {cooldown = 90, duration = 20, talent = 22164, charges = 1, class = "PALADIN", type = 2}, --Holy Avenger (talent)
	[1022] = {cooldown = 300, duration = 10, talent = false, charges = 1, class = "PALADIN", type = 3}, --Blessing of Protection
	[633] = {cooldown = 600, duration = false, talent = false, charges = 1, class = "PALADIN", type = 3}, --Lay on Hands
	[31821] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 4}, --Aura Mastery
	[1044] = {cooldown = 25, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 5}, --Blessing of Freedom
	[31850] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Ardent Defender
	[86659] = {cooldown = 300, duration = 8, talent = false, charges = 1, class = "PALADIN", type = 2}, --Guardian of Ancient Kings
	[204018] = {cooldown = 180, duration = 10, talent = 22435, charges = 1, class = "PALADIN", type = 3}, --Blessing of Spellwarding (talent)
	[6940] = {cooldown = 120, duration = 12, talent = false, charges = 1, class = "PALADIN", type = 3}, --Blessing of Sacrifice
	[204150] = {cooldown = 180, duration = 6, talent = 23087, charges = 1, class = "PALADIN", type = 4}, --Aegis of Light (talent)
	[231895] = {cooldown = 120, duration = 25, talent = 22215, charges = 1, class = "PALADIN", type = 1}, --Crusade (talent)
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
	
	--> warlock
	[205180] = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "WARLOCK", type = 1}, --Summon Darkglare
	[113860] = {cooldown = 120, duration = 20, talent = 19293, charges = 1, class = "WARLOCK", type = 1}, --Dark Soul: Misery (talent)
	[104773] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "WARLOCK", type = 2}, --Unending Resolve
	[108416] = {cooldown = 60, duration = 20, talent = 19286, charges = 1, class = "WARLOCK", type = 2}, --Dark Pact (talent)
	[265187] = {cooldown = 90, duration = 15, talent = false, charges = 1, class = "WARLOCK", type = 1}, --Summon Demonic Tyrant
	[111898] = {cooldown = 120, duration = 15, talent = 21717, charges = 1, class = "WARLOCK", type = 1}, --Grimoire: Felguard
	[267217] = {cooldown = 180, duration = 20, talent = 23091, charges = 1, class = "WARLOCK", type = 1}, --Nether Portal
	[1122] = {cooldown = 180, duration = 30, talent = false, charges = 1, class = "WARLOCK", type = 1}, --Summon Infernal
	[113858] = {cooldown = 120, duration = 20, talent = 23092, charges = 1, class = "WARLOCK", type = 1}, --Dark Soul: Instability (talent)
	
	--> shaman
	[198067] = {cooldown = 150, duration = 30, talent = false, charges = 1, class = "SHAMAN", type = 1}, --Fire Elemental
	[192249] = {cooldown = 150, duration = 30, talent = 19272, charges = 1, class = "SHAMAN", type = 1}, --Storm Elemental (talent)
	[114050] = {cooldown = 180, duration = 15, talent = 21675, charges = 1, class = "SHAMAN", type = 1}, --Ascendance (talent)
	[108271] = {cooldown = 90, duration = 8, talent = false, charges = 1, class = "SHAMAN", type = 2}, --Astral Shift
	[108281] = {cooldown = 120, duration = 10, talent = 22172, charges = 1, class = "SHAMAN", type = 4}, --Ancestral Guidance (talent)
	[51533] = {cooldown = 120, duration = 15, talent = false, charges = 1, class = "SHAMAN", type = 1}, --Feral Spirit
	[114051] = {cooldown = 180, duration = 15, talent = 21972, charges = 1, class = "SHAMAN", type = 1}, --Ascendance (talent)
	[114052] = {cooldown = 180, duration = 15, talent = 22359, charges = 1, class = "SHAMAN", type = 2}, --Ascendance (talent)
	[98008] = {cooldown = 180, duration = 6, talent = false, charges = 1, class = "SHAMAN", type = 4}, --Spirit Link Totem
	[108280] = {cooldown = 180, duration = 10, talent = false, charges = 1, class = "SHAMAN", type = 4}, --Healing Tide Totem
	[207399] = {cooldown = 240, duration = 30, talent = 22323, charges = 1, class = "SHAMAN", type = 4}, --Ancestral Protection Totem (talent)
	
	--> monk
	[115203] = {cooldown = 420, duration = 15, talent = false, charges = 1, class = "MONK", type = 2}, --Fortifying Brew
	[115176] = {cooldown = 300, duration = 8, talent = false, charges = 1, class = "MONK", type = 2}, --Zen Meditation
	[122278] = {cooldown = 120, duration = 10, talent = 20175, charges = 1, class = "MONK", type = 2}, --Dampen Harm (talent)
	[137639] = {cooldown = 90, duration = 15, talent = false, charges = 1, class = "MONK", type = 1}, --Storm, Earth, and Fire
	[123904] = {cooldown = 120, duration = 20, talent = 22102, charges = 1, class = "MONK", type = 1}, --Invoke Xuen, the White Tiger (talent)
	[152173] = {cooldown = 90, duration = 12, talent = 21191, charges = 1, class = "MONK", type = 1}, --Serenity (talent)
	[122470] = {cooldown = 90, duration = 6, talent = false, charges = 1, class = "MONK", type = 2}, --Touch of Karma
	[198664] = {cooldown = 180, duration = 25, talent = 22214, charges = 1, class = "MONK", type = 4}, --Invoke Chi-Ji, the Red Crane (talent)
	[243435] = {cooldown = 90, duration = 15, talent = false, charges = 1, class = "MONK", type = 2}, --Fortifying Brew
	[122783] = {cooldown = 90, duration = 6, talent = 20173, charges = 1, class = "MONK", type = 2}, --Diffuse Magic (talent)
	[116849] = {cooldown = 120, duration = 12, talent = false, charges = 1, class = "MONK", type = 3}, --Life Cocoon
	[115310] = {cooldown = 180, duration = false, talent = false, charges = 1, class = "MONK", type = 4}, --Revival
	
	--> hunter
	[193530] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "HUNTER", type = 1}, --Aspect of the Wild
	[19574] = {cooldown = 90, duration = 12, talent = false, charges = 1, class = "HUNTER", type = 1}, --Bestial Wrath
	[201430] = {cooldown = 180, duration = 12, talent = 23044, charges = 1, class = "HUNTER", type = 1}, --Stampede (talent)
	[194407] = {cooldown = 90, duration = 20, talent = 22295, charges = 1, class = "HUNTER", type = 1}, --Spitting Cobra (talent)
	[193526] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "HUNTER", type = 1}, --Trueshot
	[281195] = {cooldown = 180, duration = 6, talent = false, charges = 1, class = "HUNTER", type = 2}, --Survival of the Fittest
	[266779] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "HUNTER", type = 1}, --Coordinated Assault
	[186265] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "HUNTER", type = 2}, --Aspect of the Turtle
	[109304] = {cooldown = 120, duration = false, talent = false, charges = 1, class = "HUNTER", type = 2}, --Exhilaration

	--> druid
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
	[740] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "DRUID", type = 4}, --Tranquility
	[197721] = {cooldown = 90, duration = 8, talent = 22404, charges = 1, class = "DRUID", type = 4}, --Flourish (talent)

	--> death knight
	[275699] = {cooldown = 90, duration = 15, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Apocalypse
	[42650] = {cooldown = 480, duration = 30, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Army of the Dead
	[49206] = {cooldown = 180, duration = 30, talent = 22538, charges = 1, class = "DEATHKNIGHT", type = 1}, --Summon Gargoyle (talent)
	[48743] = {cooldown = 120, duration = 15, talent = 23373, charges = 1, class = "DEATHKNIGHT", type = 2}, --Death Pact (talent)
	[152279] = {cooldown = 120, duration = 5, talent = 22537, charges = 1, class = "DEATHKNIGHT", type = 1}, --Breath of Sindragosa (talent)
	[47568] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Empower Rune Weapon
	[279302] = {cooldown = 120, duration = 10, talent = 22535, charges = 1, class = "DEATHKNIGHT", type = 1}, --Frostwyrm's Fury (talent)
	[49028] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "DEATHKNIGHT", type = 1}, --Dancing Rune Weapon
	[55233] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "DEATHKNIGHT", type = 2}, --Vampiric Blood
	[48792] = {cooldown = 120, duration = 8, talent = false, charges = 1, class = "DEATHKNIGHT", type = 2}, --Icebound Fortitude
	[108199] = {cooldown = 120, duration = false, talent = false, charges = 1, class = "DEATHKNIGHT", type = 5}, --Gorefiend's Grasp (utility)
	
	--> demon hunter
	[200166] = {cooldown = 240, duration = 30, talent = false, charges = 1, class = "DEMONHUNTER", type = 1}, --Metamorphosis
	[206491] = {cooldown = 120, duration = 60, talent = 22547, charges = 1, class = "DEMONHUNTER", type = 1}, --Nemesis (talent)
	[196555] = {cooldown = 120, duration = 5, talent = 21865, charges = 1, class = "DEMONHUNTER", type = 2}, --Netherwalk (talent)
	[196718] = {cooldown = 180, duration = 8, talent = false, charges = 1, class = "DEMONHUNTER", type = 4}, --Darkness
	[187827] = {cooldown = 180, duration = 15, talent = false, charges = 1, class = "DEMONHUNTER", type = 2}, --Metamorphosis
	
	--> mage
	[12042] = {cooldown = 90, duration = 10, talent = false, charges = 1, class = "MAGE", type = 1},  --Arcane Power
	[12051] = {cooldown = 90, duration = 6, talent = false, charges = 1, class = "MAGE", type = 1},  --Evocation
	[110960] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "MAGE", type = 2},  --Greater Invisibility
	[190319] = {cooldown = 120, duration = 10, talent = false, charges = 1, class = "MAGE", type = 1},  --Combustion
	[55342] = {cooldown = 120, duration = 40, talent = 22445, charges = 1, class = "MAGE", type = 1},  --Mirror Image (talent)
	[66] = {cooldown = 300, duration = 20, talent = false, charges = 1, class = "MAGE", type = 2},  --Invisibility
	[12472] = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "MAGE", type = 1},  --Icy Veins
	[205021] = {cooldown = 78, duration = 5, talent = 22309, charges = 1, class = "MAGE", type = 1},  --Ray of Frost (talent)
	[45438] = {cooldown = 240, duration = 10, talent = false, charges = 1, class = "MAGE", type = 2},  --Ice Block
	[235219] = {cooldown = 300, duration = false, talent = false, charges = 1, class = "MAGE", type = 5},  --Cold Snap

	--> priest
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
	[8122] = {cooldown = 60, duration = 8, talent = false, charges = 1, class = "PRIEST", type = 5},  --Psychic Scream
	[200174] = {cooldown = 60, duration = 15, talent = 21719, charges = 1, class = "PRIEST", type = 1},  --Mindbender (talent)
	[193223] = {cooldown = 240, duration = 60, talent = 21979, charges = 1, class = "PRIEST", type = 1},  --Surrender to Madness (talent)
	[47585] = {cooldown = 120, duration = 6, talent = false, charges = 1, class = "PRIEST", type = 2},  --Dispersion
	[15286] = {cooldown = 120, duration = 15, talent = false, charges = 1, class = "PRIEST", type = 4},  --Vampiric Embrace

	--> rogue
	[79140] = {cooldown = 120, duration = 20, talent = false, charges = 1, class = "ROGUE", type = 1},  --Vendetta
	[1856] = {cooldown = 120, duration = 3, talent = false, charges = 1, class = "ROGUE", type = 2},  --Vanish
	[5277] = {cooldown = 120, duration = 10, talent = false, charges = 1, class = "ROGUE", type = 2},  --Evasion
	[31224] = {cooldown = 120, duration = 5, talent = false, charges = 1, class = "ROGUE", type = 2},  --Cloak of Shadows
	[2094] = {cooldown = 120, duration = 60, talent = false, charges = 1, class = "ROGUE", type = 5},  --Blind
	[114018] = {cooldown = 360, duration = 15, talent = false, charges = 1, class = "ROGUE", type = 5},  --Shroud of Concealment
	[13750] = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "ROGUE", type = 1},  --Adrenaline Rush
	[51690] = {cooldown = 120, duration = 2, talent = 23175, charges = 1, class = "ROGUE", type = 1},  --Killing Spree (talent)
	[199754] = {cooldown = 120, duration = 10, talent = false, charges = 1, class = "ROGUE", type = 2},  --Riposte
	[121471] = {cooldown = 180, duration = 20, talent = false, charges = 1, class = "ROGUE", type = 1},  --Shadow Blades
}

-- {cooldown = , duration = , talent = false, charges = 1}

DF.CrowdControlSpells = {
	[5246] = "WARRIOR", --Intimidating Shout
	[132168] = "WARRIOR", --Shockwave (debuff spellid)
	[132169] = "WARRIOR", --Storm Bolt (talent debuff spellid)
	
	[118699] = "WARLOCK", --Fear (debuff spellid)
	[6789] = "WARLOCK", --Mortal Coil
	[30283] = "WARLOCK", --Shadowfury
	[710] = "WARLOCK", --Banish

	[118] = "MAGE", --Polymorph
	[61305] = "MAGE", --Polymorph (black cat)
	[28271] = "MAGE", --Polymorph Turtle
	[161354] = "MAGE", --Polymorph Monkey
	[161353] = "MAGE", --Polymorph Polar Bear Cub
	[126819] = "MAGE", --Polymorph Porcupine
	[277787] = "MAGE", --Polymorph Direhorn
	[61721] = "MAGE", --Polymorph Rabbit
	[28272] = "MAGE", --Polymorph Pig
	[277792] = "MAGE", --Polymorph Bumblebee
	
	[82691] = "MAGE", --Ring of Frost (debuff spellid)
	[122] = "MAGE", --Frost Nova
	[157997] = "MAGE", --Ice Nova
	[31661] = "MAGE", --Dragon's Breath
	
	[205364] = "PRIEST", --Mind Control (talent)
	[605] = "PRIEST", --Mind Control
	[8122] = "PRIEST", --Psychic Scream
	[9484] = "PRIEST", --Shackle Undead
	[200196] = "PRIEST", --Holy Word: Chastise (debuff spellid)
	[200200] = "PRIEST", --Holy Word: Chastise (talent debuff spellid)
	[226943] = "PRIEST", --Mind Bomb (talent)
	[64044] = "PRIEST", --Psychic Horror (talent)
	
	[2094] = "ROGUE", --Blind
	[1833] = "ROGUE", --Cheap Shot
	[408] = "ROGUE", --Kidney Shot
	[6770] = "ROGUE", --Sap
	[1776] = "ROGUE", --Gouge
	[199804] = "ROGUE", --Between the Eyes
	
	[853] = "PALADIN", --Hammer of Justice
	[20066] = "PALADIN", --Repentance (talent)
	[105421] = "PALADIN", --Blinding Light (talent)
	
	[221562] = "DEATHKNIGHT", --Asphyxiate
	[108194] = "DEATHKNIGHT", --Asphyxiate (talent)
	[207167] = "DEATHKNIGHT", --Blinding Sleet
	
	[339] = "DRUID", --Entangling Roots
	[2637] = "DRUID", --Hibernate
	[61391] = "DRUID", --Typhoon
	[102359] = "DRUID", --Mass Entanglement
	[99] = "DRUID", --Incapacitating Roar
	[236748] = "DRUID", --Intimidating Roar
	[5211] = "DRUID", --Mighty Bash
	[45334] = "DRUID", --Immobilized
	[203123] = "DRUID", --Maim
	[50259] = "DRUID", --Dazed (from Wild Charge)
	[209753] = "DRUID", --Cyclone (from pvp talent)
	[33786] = "DRUID", --Cyclone (from pvp talent - resto druid)
	
	[3355] = "HUNTER", --Freezing Trap
	[19577] = "HUNTER", --Intimidation
	[190927] = "HUNTER", --Harpoon
	[162480] = "HUNTER", --Steel Trap
	[24394] = "HUNTER", --Intimidation
	
	[119381] = "MONK", --Leg Sweep
	[115078] = "MONK", --Paralysis
	[198909] = "MONK", --Song of Chi-Ji (talent)
	[116706] = "MONK", --Disable
	[107079] = "MONK", --Quaking Palm (racial)
	
	[118905] = "SHAMAN", --Static Charge (Capacitor Totem)
	[51514] = "SHAMAN", --Hex
	[64695] = "SHAMAN", --Earthgrab (talent)
	[197214] = "SHAMAN", --Sundering (talent)
	
	[179057] = "DEMONHUNTER", --Chaos Nova
	[217832] = "DEMONHUNTER", --Imprison
	[200166] = "DEMONHUNTER", --Metamorphosis
	[207685] = "DEMONHUNTER", --Sigil of Misery
	[211881] = "DEMONHUNTER", -- Fel Eruption
}

DF.SpecIds = {
	[577] = "DEMONHUNTER",
	[581] = "DEMONHUNTER",

	[250] = "DEATHKNIGHT",
	[251] = "DEATHKNIGHT",
	[252] = "DEATHKNIGHT",

	[71] = "WARRIOR",
	[72] = "WARRIOR",
	[73] = "WARRIOR",

	[62] = "MAGE",
	[63] = "MAGE",
	[64] = "MAGE",

	[259] = "ROGUE",
	[260] = "ROGUE",
	[261] = "ROGUE",

	[102] = "DRUID",
	[103] = "DRUID",
	[104] = "DRUID",
	[105] = "DRUID",

	[253] = "HUNTER",
	[254] = "HUNTER",
	[255] = "HUNTER",

	[262] = "SHAMAN",
	[263] = "SHAMAN",
	[254] = "SHAMAN",

	[256] = "PRIEST",
	[257] = "PRIEST",
	[258] = "PRIEST",

	[265] = "WARLOCK",
	[266] = "WARLOCK",
	[267] = "WARLOCK",

	[65] = "PALADIN",
	[66] = "PALADIN",
	[70] = "PALADIN",

	[268] = "MONK",
	[269] = "MONK",
	[270] = "MONK",
}

DF.CooldownToClass = {}

DF.CooldownsAttack = {}
DF.CooldownsDeffense = {}
DF.CooldownsExternals = {}
DF.CooldownsRaid = {}

DF.CooldownsAllDeffensive = {}

for specId, cooldownTable in pairs (DF.CooldownsBySpec) do
	
	for spellId, cooldownType in pairs (cooldownTable) do
		
		if (cooldownType == 1) then
			DF.CooldownsAttack [spellId] = true
			
		elseif (cooldownType == 2) then
			DF.CooldownsDeffense [spellId] = true
			DF.CooldownsAllDeffensive [spellId] = true
			
		elseif (cooldownType == 3) then
			DF.CooldownsExternals [spellId] = true
			DF.CooldownsAllDeffensive [spellId] = true
			
		elseif (cooldownType == 4) then
			DF.CooldownsRaid [spellId] = true
			DF.CooldownsAllDeffensive [spellId] = true
			
		elseif (cooldownType == 5) then
			
			
		end
		
		DF.CooldownToClass [spellId] = DF.SpecIds [spellId]

	end
	
end

function DF:FindClassForCooldown (spellId)
	for specId, cooldownTable in pairs (DF.CooldownsBySpec) do
		local hasCooldown = cooldownTable [spellId]
		if (hasCooldown) then
			return DF.SpecIds [specId]
		end
	end
end

function DF:GetCooldownInfo (spellId)
	return DF.CooldownsInfo [spellId]
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--consumables

DF.FlaskIDs = {
	[251836] = true, -- Flask of the Currents agility
	[251837] = true, -- Flask of Endless Fathoms intellect
	[251838] = true, -- Flask of the Vast Horizon stamina
	[251839] = true, -- Flask of the Undertow strength

	------------------------------------------------------------------------
	--revision ny nullKomplex july 07 2019
	[298836] = true, -- Greater Flask of the Currents agility
	[298837] = true, -- Greater Flask of Endless Fathoms intellect
	[298839] = true, -- Greater Flask of the Vast Horizon stamina
	[298841] = true, -- Greater Flask of the Undertow strength
}

DF.FoodIDs = {
	[257422] = 41, --Mon'Dazi versatility
	[257413] = 41, --Ravenberry Tarts haste
	[257418] = 41, --Loa Loaf mastery
	[257408] = 41, --Kul Tiramisu critical
	
	[257424] =  55, --Spiced Snapper versatility
	[257415] =  55, --Swamp Fish 'n Chips haste
	[257420] =  55, --Sailor's Pie mastery
	[257410] =  55, --Honey-Glazed Haunches critical
	
	[259448] = 75, --Galley Banquet agility
	[259449] = 75, --Galley Banquet intellect
	[259453] = 75, --Galley Banquet stamina
	[259452] = 75, --Galley Banquet strength

	[259454] = 100, --Bountiful Captain's Feast agility
	[259455] = 100, --Bountiful Captain's Feast intellect
	[259457] = 100, --Bountiful Captain's Feast stamina
	[257427] = 100, --Bountiful Captain's Feast strength
	
	------------------------------------------------------------------------
	--revision ny nullKomplex july 07 2019
	[288074] = 113, -- Wild Berry Bread stamina (maybe fake it as 41?)

	[285721] = 60, -- Druid Rebirth trait agility
	[285719] = 60, -- Druid Rebirth trait intellect
	[285720] = 60, -- Druid Rebirth trait strength

	-- Put in 70 section:
	[288075] = 150, -- Seasoned Steak and Potatoes (70?)

	[290467] = 85, -- Boralus Blood Sausage agility
	[290468] = 85, -- Boralus Blood Sausage intellect
	[290469] = 85, -- Boralus Blood Sausage strength

	[297037] =  93, -- Bil'Tong versatility
	[297034] =  93, -- Baked Port Tato haste
	[297035] =  93, -- Abyssal-Fried Rissole mastery
	[297039] =  93, -- Mech-Dowel's "Big Mech" critical
	[297040] =  198, -- Fragrant Kakavia stamina (93?)

	[297116] = 131, -- Famine Evaluator And Snack Table agility
	[297117] = 131, -- Famine Evaluator And Snack Table intellect
	[297118] = 131, -- Famine Evaluator And Snack Table strength
}

DF.PotionIDs = {
	[279152] = true, --Battle Potion of Agility
	[279151] = true, --Battle Potion of Intellect
	[279154] = true, --Battle Potion of Stamina
	[279153] = true, --Battle Potion of Strength
	
	[269853] = true, --Potion of Rising Death (range)
	[251316] = true, --Potion of Bursting Blood (melee)
	[251231] = true, --Steelskin Potion (tank)
	
	------------------------------------------------------------------------
	--revision ny nullKomplex july 07 2019
	[298146] = true, -- Superior Battle Potion of Agility
	[298152] = true, -- Superior Battle Potion of Intellect
	[298153] = true, -- Superior Battle Potion of Stamina
	[298154] = true, -- Superior Battle Potion of Strength

	[298317] = true, -- Potion of Focused Resolve (crit)
	[300714] = true, -- Potion of Unbridled Fury (fire damage)
	[298225] = true, -- Potion of Empowered Proximity (main stat per enemy)
	[298155] = true, -- Superior Steelskin Potion (tank)
	[300741] = true, -- Potion of Wild Mending (healer)
}

DF.RuneIDs = {
	[270058] = true, --Battle-Scarred Augment Rune
}

--	/dump UnitAura ("player", 1)
--	/dump UnitAura ("player", 2)

function DF:GetSpellsForEncounterFromJournal (instanceEJID, encounterEJID)

	DetailsFramework.EncounterJournal.EJ_SelectInstance (instanceEJID) 
	local name, description, encounterID, rootSectionID, link = DetailsFramework.EncounterJournal.EJ_GetEncounterInfo (encounterEJID) --taloc (primeiro boss de Uldir)
	
	if (not name) then
		print ("DetailsFramework: Encounter Info Not Found!", instanceEJID, encounterEJID)
		return {}
	end
	
	local spellIDs = {}
	
	--overview
	local sectionInfo = C_EncounterJournal.GetSectionInfo (rootSectionID)
	local nextID = {sectionInfo.siblingSectionID}
	
	while (nextID [1]) do
		--> get the deepest section in the hierarchy
		local ID = tremove (nextID)
		local sectionInfo = C_EncounterJournal.GetSectionInfo (ID)
		
		if (sectionInfo) then
			if (sectionInfo.spellID and type (sectionInfo.spellID) == "number" and sectionInfo.spellID ~= 0) then
				tinsert (spellIDs, sectionInfo.spellID)
			end
			
			local nextChild, nextSibling = sectionInfo.firstChildSectionID, sectionInfo.siblingSectionID
			if (nextSibling) then
				tinsert (nextID, nextSibling)
			end
			if (nextChild) then
				tinsert (nextID, nextChild)
			end
		else
			break
		end
	end
	
	return spellIDs
end











