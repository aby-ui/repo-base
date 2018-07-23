
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

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

DF.CrowdControlSpells = {
	[5246] = "WARRIOR", --Intimidating Shout
	[132168] = "WARRIOR", --Shockwave (debuff spellid)
	[132169] = "WARRIOR", --Storm Bolt (talent debuff spellid)
	
	[118699] = "WARLOCK", --Fear (debuff spellid)
	[6789] = "WARLOCK", --Mortal Coil
	[30283] = "WARLOCK", --Shadowfury
	[710] = "WARLOCK", --Banish

	[118] = "MAGE", --Polymorph
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

	[3355] = "HUNTER", --Freezing Trap
	[19577] = "HUNTER", --Intimidation
	[190927] = "HUNTER", --Harpoon
	[162480] = "HUNTER", --Steel Trap
	
	[119381] = "MONK", --Leg Sweep
	[115078] = "MONK", --Paralysis
	[198909] = "MONK", --Song of Chi-Ji (talent)
	[116706] = "MONK", --Disable
	
	[118905] = "SHAMAN", --Static Charge (Capacitor Totem)
	[51514] = "SHAMAN", --Hex
	[64695] = "SHAMAN", --Earthgrab (talent)
	
	[179057] = "DEMONHUNTER", --Chaos Nova
	[217832] = "DEMONHUNTER", --Imprison
	[200166] = "DEMONHUNTER", --Metamorphosis
	[207685] = "DEMONHUNTER", --Sigil of Misery
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

