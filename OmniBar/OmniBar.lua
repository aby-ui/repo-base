--print("|cff00dfff[OmniBar-v6.8]|r原作者|c00FF9900Curse:Jordon|r,由|c00FF9900NGA:伊甸外|r于7.23日翻译修改,输入|cff33ff99/bd|r设置.")
--翻译汉化修改：NGA  @伊甸外  barristan@sina.com  http://bbs.ngacn.cc/nuke.php?func=ucp&uid=7350579
-- OmniBar by Jordon

OmniBar = LibStub("AceAddon-3.0"):NewAddon("OmniBar", "AceEvent-3.0", "AceHook-3.0")

OmniBar.cooldowns = {

	-- Death Knight

	[47528] = { default = true, duration = 15, class = "DEATHKNIGHT" }, -- Mind Freeze
	[48265] = { duration = 45, class = "DEATHKNIGHT" }, -- Death's Advance
	[48707] = { duration = 60, class = "DEATHKNIGHT" }, -- Anti-Magic Shell
	[49576] = { duration = 25, class = "DEATHKNIGHT", charges = 2 }, -- Death Grip
	[51052] = { duration = 120, class = "DEATHKNIGHT" }, -- Anti-Magic Zone
	[61999] = { duration = 600, class = "DEATHKNIGHT" }, -- Raise Ally
	[77606] = { duration = 25, class = "DEATHKNIGHT" }, -- Dark Simulacrum
	[212552] = { duration = 60, class = "DEATHKNIGHT" }, -- Wraith Walk

		-- Blood

		[43265] = { duration = 30, class = "DEATHKNIGHT", specID = { 250, 252 } }, -- Death and Decay
		[47476] = { duration = 60, class = "DEATHKNIGHT", specID = { 250 } }, -- Strangulate
		[49028] = { duration = 120, class = "DEATHKNIGHT", specID = { 250 } }, -- Dancing Rune Weapon
		[55233] = { duration = 90, class = "DEATHKNIGHT", specID = { 250 } }, -- Vampiric Blood
		[108199] = { duration = 120, class = "DEATHKNIGHT", specID = { 250 } }, -- Gorefiend's Grasp
		[194679] = { duration = 25, class = "DEATHKNIGHT", specID = { 250 }, charges = 2 }, -- Rune Tap
		[194844] = { duration = 60, class = "DEATHKNIGHT", specID = { 250 } }, -- Bonestorm
		[203173] = { duration = 15, class = "DEATHKNIGHT", specID = { 250 } }, -- Death Chain
		[205223] = { duration = 45, class = "DEATHKNIGHT", specID = { 250 } }, -- Consumption
		[206931] = { duration = 30, class = "DEATHKNIGHT", specID = { 250 } }, -- Blooddrinker
		[206977] = { duration = 120, class = "DEATHKNIGHT", specID = { 250 } }, -- Blood Mirror
		[219809] = { duration = 60, class = "DEATHKNIGHT", specID = { 250 } }, -- Tombstone
		[221562] = { duration = 45, class = "DEATHKNIGHT", specID = { 250, 252 } }, -- Asphyxiate (Blood)
			[108194] = { parent = 221562 }, -- Asphyxiate (Unholy)
		[221699] = { duration = 60, class = "DEATHKNIGHT", specID = { 250 }, charges = 2 }, -- Blood Tap

		-- Frost

		[47568] = { duration = 120, class = "DEATHKNIGHT", specID = { 251 }, charges = 2 }, -- Empower Rune Weapon
			[207127] = { parent = 47568 }, -- Hungering Rune Weapon
		[48792] = { duration = 180, class = "DEATHKNIGHT", specID = { 251, 252 } }, -- Icebound Fortitude
		[51271] = { duration = 45, class = "DEATHKNIGHT", specID = { 251 } }, -- Pillar of Frost
		[152279] = { duration = 120, class = "DEATHKNIGHT", specID = { 251} }, -- Breath of Sindragosa
		[196770] = { duration = 20, class = "DEATHKNIGHT", specID = { 251 } }, -- Remorseless Winter
		[204143] = { duration = 45, class = "DEATHKNIGHT", specID = { 251 } }, -- Killing Machine
		[204160] = { duration = 45, class = "DEATHKNIGHT", specID = { 251 } }, -- Chill Streak
		[207167] = { duration = 60, class = "DEATHKNIGHT", specID = { 251} }, -- Blinding Sleet
		[207256] = { duration = 90, class = "DEATHKNIGHT", specID = { 251} }, -- Obliteration
		[279302] = { duration = 180, class = "DEATHKNIGHT", specID = { 251} }, -- Frostwyrm's Fury

		-- Unholy

		[42650] = { duration = 480, class = "DEATHKNIGHT", specID = { 252 } }, -- Army of the Dead
		[63560] = { duration = 60, class = "DEATHKNIGHT", specID = { 252 } }, -- Dark Transformation
		[43265] = { duration = 30, class = "DEATHKNIGHT", specID = { 252 } }, -- Death and Decay
			[152280] = { parent = 43265 }, -- Defile
		[47481] = { duration = 90, class = "DEATHKNIGHT", specID = { 252 } }, -- Gnaw (Ghoul)
		[47482] = { duration = 30, class = "DEATHKNIGHT", specID = { 252 } }, -- Leap (Ghoul)
		[49206] = { duration = 180, class = "DEATHKNIGHT", specID = { 252 } }, -- Summon Gargoyle
			[207349] = { parent = 49206 }, -- Dark Arbiter
		[91802] = { duration = 30, class = "DEATHKNIGHT", specID = { 252 } }, -- Shambling Rush (Ghoul)
		[130736] = { duration = 45, class = "DEATHKNIGHT", specID = { 252 } }, -- Soul Reaper
		[207289] = { duration = 120, class = "DEATHKNIGHT", specID = { 252 } }, -- Unholy Frenzy
		[207319] = { duration = 60, class = "DEATHKNIGHT", specID = { 252 } }, -- Corpse Shield
		[220143] = { duration = 90, class = "DEATHKNIGHT", specID = { 252 } }, -- Apocalypse

	-- Demon Hunter

	[179057] = { duration = 60, class = "DEMONHUNTER" }, -- Chaos Nova
	[183752] = { default = true, duration = 15, class = "DEMONHUNTER" }, -- Disrupt
	[188499] = { duration = 9, class = "DEMONHUNTER" }, -- Blade Dance
	[188501] = { duration = 30, class = "DEMONHUNTER" }, -- Spectral Sight
	[191427] = { duration = 105, class = "DEMONHUNTER" }, -- Metamorphosis
		[187827] = { parent = 191427, duration = 180 }, -- Metamorphosis (Vengeance)
		[162264] = { parent = 191427 }, -- Metamorphosis
	[196718] = { duration = 180, class = "DEMONHUNTER" }, -- Darkness
	[198013] = { duration = 30, class = "DEMONHUNTER" }, -- Eye Beam
	[198793] = { duration = 25, class = "DEMONHUNTER" }, -- Vengeful Retreat
	[203704] = { duration = 60, class = "DEMONHUNTER" }, -- Mana Break
	[205604] = { duration = 60, class = "DEMONHUNTER" }, -- Reverse Magic
	[206649] = { duration = 45, class = "DEMONHUNTER" }, -- Eye of Leotheras
	[206803] = { duration = 60, class = "DEMONHUNTER" }, -- Rain from Above
	[212800] = { duration = 60, class = "DEMONHUNTER" }, -- Blur
		[196555] = { parent = 212800, duration = 90 }, -- Netherwalk
	[214743] = { duration = 60, class = "DEMONHUNTER" }, -- Soul Carver
		[207407] = { parent = 214743 }, -- Soul Carver (Vengeance)
	[221527] = { duration = 45, class = "DEMONHUNTER" }, -- Imprison

		-- Havoc

		[201467] = { duration = 60, class = "DEMONHUNTER", specID = { 577 } }, -- Fury of the Illidari
		[206491] = { duration = 120, class = "DEMONHUNTER", specID = { 577 } }, -- Nemesis
		--[211048] = { duration = 120, class = "DEMONHUNTER", specID = { 577 } }, -- Chaos Blades
		[211881] = { duration = 30, class = "DEMONHUNTER", specID = { 577, 581 } }, -- Fel Eruption

		-- Vengeance

		[202137] = { duration = 60, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Silence
		[202138] = { duration = 120, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Chains
		[204021] = { duration = 60, class = "DEMONHUNTER", specID = { 581 } }, -- Fiery Brand
		[204596] = { duration = 30, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Flame
		[205629] = { duration = 30,  class = "DEMONHUNTER", specID = { 581 } }, -- Demonic Trample
		[205630] = { duration = 90, class = "DEMONHUNTER", specID = { 581 } }, -- Illidan's Grasp
		[207684] = { duration = 90, class = "DEMONHUNTER", specID = { 581 } }, -- Sigil of Misery
		[207810] = { duration = 120, class = "DEMONHUNTER", specID = { 581 } }, -- Nether Bond
		--[218256] = { duration = 20, class = "DEMONHUNTER", specID = { 581 } }, -- Empower Wards
		[227225] = { duration = 20, class = "DEMONHUNTER", specID = { 581 } }, -- Soul Barrier

	-- Priest

	[586] = { duration = 30, class = "PRIEST" }, -- Fade
		[213602] = { parent = 586 }, -- Greater Fade
	[32375] = { duration = 45, class = "PRIEST" }, -- Mass Dispel

		-- Discipline

		[8122] = { duration = 30, class = "PRIEST", specID = { 256, 257, 258 } }, -- Psychic Scream
		[10060] = { duration = 120, class = "PRIEST", specID = { 256, 258 } }, -- Power Infusion
		[33206] = { duration = 180, class = "PRIEST", specID = { 256 } }, -- Pain Suppression
		[34433] = { duration = 180, class = "PRIEST", specID = { 256, 258 } }, -- Shadowfiend
			[123040] = { parent = 34433, duration = 60 }, -- Mindbender (Discipline)
			[200174] = { parent = 34433, duration = 60 }, -- Mindbender (Shadow)
		[47536] = { duration = 90, class = "PRIEST", specID = { 256 } }, -- Rapture
		[62618] = { duration = 180, class = "PRIEST", specID = { 256 } }, -- Power Word: Barrier
		[73325] = { duration = 90, class = "PRIEST", specID = { 256, 257, 258 } }, -- Leap of Faith
		[197862] = { duration = 60, class = "PRIEST", specID = { 256 } }, -- Archangel
		[197871] = { duration = 60, class = "PRIEST", specID = { 256 } }, -- Dark Archangel
		[204263] = { duration = 45, class = "PRIEST", specID = { 256, 257 } }, -- Shining Force
		[209780] = { duration = 12, class = "PRIEST", specID = { 256} }, -- Premonition

		-- Holy

		[19236] = { duration = 90, class = "PRIEST", specID = { 256, 257 } }, -- Desperate Prayer
		[47788] = { duration = 180, class = "PRIEST", specID = { 257 } }, -- Guardian Spirit
		[64843] = { duration = 180, class = "PRIEST", specID = { 257 } }, -- Divine Hymn
		[64901] = { duration = 300, class = "PRIEST", specID = { 257 } }, -- Symbol of Hope
		[196762] = { duration = 30, class = "PRIEST", specID = { 257 } }, -- Inner Focus
		[197268] = { duration = 60, class = "PRIEST", specID = { 257 } }, -- Ray of Hope
		[200183] = { duration = 120, class = "PRIEST", specID = { 257 } }, -- Apotheosis
		[213610] = { duration = 30, class = "PRIEST", specID = { 257 } }, -- Holy Ward
		[215769] = { duration = 300, class = "PRIEST", specID = { 257 } }, -- Spirit of Redemption

		-- Shadow

		[15286] = { duration = 120, class = "PRIEST", specID = { 258 } }, -- Vampiric Embrace
		[15487] = { duration = 45, class = "PRIEST", specID = { 258 } }, -- Silence
		[32379] = { duration = 9, class = "PRIEST", specID = { 258 }, charges = 2 }, -- Shadow Word: Death
		[47585] = { duration = 120, class = "PRIEST", specID = { 258 } }, -- Dispersion
		[64044] = { duration = 45, class = "PRIEST", specID = { 258 } }, -- Psychic Horror
		[108968] = { duration = 300, class = "PRIEST", specID = { 258 } }, -- Void Shift
		[193223] = { duration = 240, class = "PRIEST", specID = { 258 } }, -- Surrender to Madness
		[205065] = { duration = 45, class = "PRIEST", specID = { 258 } }, -- Void Torrent
		[205369] = { duration = 30, class = "PRIEST", specID = { 258 } }, -- Mind Bomb
		[211522] = { duration = 45, class = "PRIEST", specID = { 258 } }, -- Psyfiend

	-- Paladin

	[633] = { duration = 600, class = "PALADIN" }, -- Lay on Hands
	[642] = { duration = 300, class = "PALADIN" }, -- Divine Shield
	[853] = { duration = 60, class = "PALADIN" }, -- Hammer of Justice
	[1022] = { duration = 300, class = "PALADIN", charges = 2 }, -- Blessing of Protection
		[204018] = { parent = 1022, duration = 180 }, -- Blessing of Spellwarding
	[1044] = { duration = 25, class = "PALADIN", charges = 2 }, -- Blessing of Freedom
	[20066] = { duration = 15, class = "PALADIN" }, -- Repentance
	[31884] = { duration = 120, class = "PALADIN" }, -- Avenging Wrath
		[31842] = { parent = 31884 }, -- Avenging Wrath (Holy)
		[216331] = { parent = 31884 }, -- Avenging Crusader
		[224668] = { parent = 31884 }, -- Crusade
		[231895] = { parent = 31884 }, -- Crusade
	[115750] = { duration = 90, class = "PALADIN" }, -- Blinding Light

		-- Holy

		[498] = { duration = 60, class = "PALADIN", specID = { 65, 66 } }, -- Divine Protection
		[6940] = { duration = 120, class = "PALADIN", specID = { 65, 66 }, charges = 2 }, -- Blessing of Sacrifice
		[31821] = { duration = 180, class = "PALADIN", specID = { 65 } }, -- Aura Mastery
		[105809] = { duration = 90, class = "PALADIN", specID = { 65 } }, -- Holy Avenger
		[114158] = { duration = 60, class = "PALADIN", specID = { 65 } }, -- Light's Hammer
		[183415] = { duration = 180, class = "PALADIN", specID = { 65 } }, -- Aura of Mercy
		[200652] = { duration = 90, class = "PALADIN", specID = { 65 } }, -- Tyr's Deliverance
		[210294] = { duration = 45, class = "PALADIN", specID = { 65 } }, -- Divine Favor
		[214202] = { duration = 30, class = "PALADIN", specID = { 65 }, charges = 2 }, -- Rule of Law

		-- Protection

		[31850] = { duration = 120, class = "PALADIN", specID = { 66 } }, -- Ardent Defender
		[31935] = { default = true, duration = 15, class = "PALADIN", specID = { 66 } }, -- Avenger's Shield
		[86659] = { duration = 300, class = "PALADIN", specID = { 66 } }, -- Guardian of Ancient Kings
			[228049] = { parent = 86659 }, -- Guardian of the Forgotten Queen
		[96231] = { default = true, duration = 15, class = "PALADIN", specID = { 66, 70 } }, -- Rebuke
		[152262] = { duration = 30, class = "PALADIN", specID = { 66 } }, -- Seraphim
		[190784] = { duration = 45, class = "PALADIN", specID = { 66 } }, -- Divine Steed
		[204035] = { duration = 180, class = "PALADIN", specID = { 66 } }, -- Bastion of Light
		[204150] = { duration = 300, class = "PALADIN", specID = { 66 } }, -- Aegis of Light
		[209202] = { duration = 60, class = "PALADIN", specID = { 66 } }, -- Eye of Tyr
		[215652] = { duration = 25, class = "PALADIN", specID = { 66 } }, -- Shield of Virtue

		-- Retribution

		[184662] = { duration = 120, class = "PALADIN", specID = { 70 } }, -- Shield of Vengeance
		[204939] = { duration = 60, class = "PALADIN", specID = { 70 } }, -- Hammer of Reckoning
		[205191] = { duration = 60, class = "PALADIN", specID = { 70 } }, -- Eye for an Eye
		[205273] = { duration = 45, class = "PALADIN", specID = { 70 } }, -- Wake of Ashes
		[210191] = { duration = 60, class = "PALADIN", specID = { 70 }, charges = 2 }, -- Word of Glory
		[210220] = { duration = 180, class = "PALADIN", specID = { 70 } }, -- Holy Wrath
		[210256] = { duration = 45, class = "PALADIN", specID = { 70 } }, -- Blessing of Sanctuary

	-- Druid

	[1850] = { duration = 120, class = "DRUID" }, -- Dash
		[252216] = { parent = 1850, duration = 45 }, -- Tiger Dash
	[5211] = { duration = 50, class = "DRUID" }, -- Mighty Bash
	[20484] = { duration = 600, class = "DRUID" }, -- Rebirth
	[102280] = { duration = 30, class = "DRUID" }, -- Displacer Beast
	[102359] = { duration = 30, class = "DRUID" }, -- Mass Entanglement
	[102401] = { duration = 15, class = "DRUID" }, -- Wild Charge
	[132469] = { duration = 30, class = "DRUID" }, -- Typhoon

		-- Balance

		[22812] = { duration = { default = 60, [104] = 35 }, class = "DRUID", specID = { 102, 104, 105 } }, -- Barkskin
		[29166] = { duration = 180, class = "DRUID", specID = { 102, 105 } }, -- Innervate
		[78675] = { default = true, duration = 60, class = "DRUID", specID = { 102 } }, -- Solar Beam
		[102560] = { duration = 180, class = "DRUID", specID = { 102 } }, -- Incarnation: Chosen of Elune
		[108238] = { duration = 120, class = "DRUID", specID = { 102, 103, 105 } }, -- Renewal
		[194223] = { duration = 180, class = "DRUID", specID = { 102 } }, -- Celestial Alignment
		[202425] = { duration = 45, class = "DRUID", specID = { 102 } }, -- Warrior of Elune
		[202770] = { duration = 60, class = "DRUID", specID = { 102 } }, -- Fury of Elune
		[205636] = { duration = 60, class = "DRUID", specID = { 102 } }, -- Force of Nature
		[209749] = { duration = 30, class = "DRUID", specID = { 102 } }, -- Faerie Swarm

		-- Feral

		[5217] = { duration = 30, class = "DRUID", specID = { 103 } }, -- Tiger's Fury
		[22570] = { duration = 20, class = "DRUID", specID = { 103 } }, -- Maim
		[61336] = { duration = { default = 180, [104] = 120 }, class = "DRUID", specID = { 103, 104 }, charges = 2 }, -- Survival Instincts
		[102543] = { duration = 180, class = "DRUID", specID = { 103 } }, -- Incarnation: King of the Jungle
		[106839] = { default = true, duration = 15, class = "DRUID", specID = { 103, 104 } }, -- Skull Bash
		[106898] = { duration = 120, class = "DRUID", specID = { 103, 104 } }, -- Stampeding Roar
		[106951] = { duration = 180, class = "DRUID", specID = { 103 } }, -- Berserk
		[202060] = { duration = 45, class = "DRUID", specID = { 103 } }, -- Elune's Guidance
		[203242] = { duration = 60, class = "DRUID", specID = { 103 } }, -- Rip and Tear
		[210722] = { duration = 75, class = "DRUID", specID = { 103 } }, -- Ashamane's Frenzy

		-- Guardian

		[99] = { duration = 30, class = "DRUID", specID = { 104 } }, -- Incapacitating Roar
		[22842] = { duration = 36, class = "DRUID", specID = { 104 } }, -- Frenzied Regeneration
		[102558] = { duration = 180, class = "DRUID", specID = { 104 } }, -- Incarnation: Guardian of Ursoc
		[200851] = { duration = 90, class = "DRUID", specID = { 104 } }, -- Rage of the Sleeper
		[202246] = { duration = 15, class = "DRUID", specID = { 104 } }, -- Overrun
		[204066] = { duration = 90, class = "DRUID", specID = { 104 } }, -- Lunar Beam

		-- Restoration

		[740] = { duration = 180, class = "DRUID", specID = { 105} }, -- Tranquility
		[18562] = { duration = 25, class = "DRUID", specID = { 105}, charges = 2 }, -- Swiftmend
		[33891] = { duration = 180, class = "DRUID", specID = { 105} }, -- Incarnation: Tree of Life
		[102342] = { duration = 60, class = "DRUID", specID = { 105} }, -- Ironbark
		[102351] = { duration = 30, class = "DRUID", specID = { 105} }, -- Cenarion Ward
		[102793] = { duration = 60, class = "DRUID", specID = { 105} }, -- Ursol's Vortex
		[197721] = { duration = 90, class = "DRUID", specID = { 105} }, -- Flourish
		[201664] = { duration = 60, class = "DRUID", specID = { 105} }, -- Demoralizing Roar
		[203651] = { duration = 45, class = "DRUID", specID = { 105} }, -- Overgrowth
		[236696] = { duration = 45, class = "DRUID", specID = { 102, 103, 105} }, -- Thorns
		[208253] = { duration = 90, class = "DRUID", specID = { 105} }, -- Essence of G'Hanir

	-- Warrior

	[100] = { duration = 20, class = "WARRIOR" }, -- Charge
		[198758] = { parent = 100, charges = 2 }, -- Intercept
	[1719] = { duration = 90, class = "WARRIOR" }, -- Recklessness
	[6544] = { duration = 30, class = "WARRIOR", charges = 2 }, -- Heroic Leap
	[6552] = { default = true, duration = 15, class = "WARRIOR" }, -- Pummel
	[18499] = { duration = 60, class = "WARRIOR" }, -- Berserker Rage
	[23920] = { duration = 25, class = "WARRIOR" }, -- Spell Reflection
		[213915] = { parent = 23920, duration = 30 }, -- Mass Spell Reflection
		[216890] = { parent = 23920 }, -- Spell Reflection (Arms, Fury)
	[46968] = { duration = 40, class = "WARRIOR" }, -- Shockwave
	[107570] = { duration = 30, class = "WARRIOR" }, -- Storm Bolt
	[107574] = { duration = 90, class = "WARRIOR" }, -- Avatar
	[236077] = { duration = 45, class = "WARRIOR" }, -- Disarm
		[236236] = { parent = 236077 }, -- Disarm (Protection)

		-- Arms

		[5246] = { duration = 90, class = "WARRIOR", specID = { 71, 72 } }, -- Intimidating Shout
		[97462] = { duration = 180, class = "WARRIOR", specID = { 71, 72, 73 } }, -- Rallying Cry
		[118038] = { duration = 180, class = "WARRIOR", specID = { 71 } }, -- Die by the Sword
		[167105] = { duration = 45, class = "WARRIOR", specID = { 71 } }, -- Colossus Smash
			[262161] = { parent = 167105 }, -- Warbreaker
		[197690] = { duration = 10, class = "WARRIOR", specID = { 71 } }, -- Defensive Stance
		[198817] = { duration = 45, class = "WARRIOR", specID = { 71 } }, -- Sharpen Blade
		[227847] = { duration = 60, class = "WARRIOR", specID = { 71, 72 } }, -- Bladestorm (Arms)
			[46924] = { parent = 227847 }, -- Bladestorm (Fury)
			[152277] = { parent = 227847 }, -- Ravager
		[236273] = { duration = 60 , class = "WARRIOR", specID = { 71 } }, -- Duel

		-- Fury

		[184364] = { duration = 120, class = "WARRIOR", specID = { 72 } }, -- Enraged Regeneration
		[205545] = { duration = 45, class = "WARRIOR", specID = { 72 } }, -- Odyn's Fury

		-- Protection

		[871] = { duration = 240, class = "WARRIOR", specID = { 73 } }, -- Shield Wall
		[1160] = { duration = 45, class = "WARRIOR", specID = { 73 } }, -- Demoralizing Shout
		[12975] = { duration = 180, class = "WARRIOR", specID = { 73 } }, -- Last Stand
		[118000] = { duration = 35, class = "WARRIOR", specID = { 73 } }, -- Dragon Roar
		[198304] = { duration = 20, class = "WARRIOR", specID = { 73 }, charges = 2 }, -- Intercept
		[206572] = { duration = 20, class = "WARRIOR", specID = { 73 } }, -- Dragon Charge
		[213871] = { duration = 15, class = "WARRIOR", specID = { 73 } }, -- Bodyguard
		[228920] = { duration = 60, class = "WARRIOR", specID = { 73 } }, -- Ravager

	-- Warlock

	[1122] = { duration = 180, class = "WARLOCK" }, -- Summon Infernal
	[6358] = { duration = 30, class = "WARLOCK" }, -- Seduction
		[115268] = { parent = 6358 }, -- Mesmerize
	[6360] = { duration = 25, class = "WARLOCK" }, -- Whiplash
		[115770] = { parent = 6360 }, -- Fellash
	[6789] = { duration = 45, class = "WARLOCK" }, -- Mortal Coil
	--[18540] = { duration = 180, class = "WARLOCK" }, -- Summon Doomguard
	[20707] = { duration = 600, class = "WARLOCK" }, -- Soulstone
	[30283] = { duration = 60, class = "WARLOCK" }, -- Shadowfury
	[104773] = { duration = 180, class = "WARLOCK" }, -- Unending Resolve
	[108416] = { duration = 60, class = "WARLOCK" }, -- Dark Pact
	[108501] = { duration = 90, class = "WARLOCK" }, -- Grimoire of Service
	[111896] = { duration = 90, class = "WARLOCK" }, -- Grimoire: Succubus
	[119910] = { default = true, duration = 24, class = "WARLOCK" }, -- Spell Lock (Command Demon)
		[19647] = { parent = 119910 }, -- Spell Lock (Felhunter)
		[119911] = { parent = 119910 }, -- Optical Blast (Command Demon)
		[115781] = { parent = 119910 }, -- Optical Blast (Observer)
		[132409] = { parent = 119910 }, -- Spell Lock (Grimoire of Sacrifice)
		[171138] = { parent = 119910 }, -- Shadow Lock (Doomguard)
		[171139] = { parent = 119910 }, -- Shadow Lock (Grimoire of Sacrifice)
		[171140] = { parent = 119910 }, -- Shadow Lock (Command Demon)
	[171152] = { duration = 60, class = "WARLOCK" }, -- Meteor Strike
	[196098] = { duration = 120, class = "WARLOCK" }, -- Soul Harvest
	[199890] = { duration = 15, class = "WARLOCK" }, -- Curse of Tongues
	[199892] = { duration = 20, class = "WARLOCK" }, -- Curse of Weakness
	[199954] = { duration = 45, class = "WARLOCK" }, -- Curse of Fragility
	[212295] = { duration = 45, class = "WARLOCK" }, -- Nether Ward
	[221703] = { duration = 30, class = "WARLOCK" }, -- Casting Circle

		-- Affliction

		[5484] = { duration = 40, class = "WARLOCK", specID = { 265 } }, -- Howl of Terror
		[48181] = { duration = 15, class = "WARLOCK", specID = { 265 } }, -- Haunt
		[86121] = { duration = 20, class = "WARLOCK", specID = { 265 } }, -- Soul Swap
		[113860] = { duration = 120, class = "WARLOCK", specID = { 265 } }, -- Dark Soul: Misery
		[205179] = { duration = 45, class = "WARLOCK", specID = { 265 } }, -- Phantom Singularity

		-- Demonology

		[89751] = { duration = 45, class = "WARLOCK", specID = { 266 } }, -- Felstorm
			[115831] = { parent = 89751 }, -- Wrathstorm
		[89766] = { duration = 30, class = "WARLOCK", specID = { 266 } }, -- Axe Toss
		[201996] = { duration = 90, class = "WARLOCK", specID = { 266 } }, -- Call Observer
		[205180] = { duration = 24, class = "WARLOCK", specID = { 266 } }, -- Summon Darkglare
		[205181] = { duration = 14, class = "WARLOCK", specID = { 266 }, charges = 2 }, -- Shadowflame
		[211714] = { duration = 45, class = "WARLOCK", specID = { 266 } }, -- Thal'kiel's Consumption
		[212459] = { duration = 90, class = "WARLOCK", specID = { 266 } }, -- Call Fel Lord
		[212619] = { duration = 24, class = "WARLOCK", specID = { 266 } }, -- Call Felhunter
		[212623] = { duration = 15, class = "WARLOCK", specID = { 266 } }, -- Singe Magic

		--  Destruction

		[17962] = { duration = 12, class = "WARLOCK", specID = { 267 }, charges = 2 }, -- Conflagrate
		[80240] = { duration = 30, class = "WARLOCK", specID = { 267 } }, -- Havoc
		[113858] = { duration = 120, class = "WARLOCK", specID = { 267 } }, -- Dark Soul: Instability
		[152108] = { duration = 45, class = "WARLOCK", specID = { 267 } }, -- Cataclysm
		[196447] = { duration = 15, class = "WARLOCK", specID = { 267 } }, -- Channel Demonfire
		[196586] = { duration = 45, class = "WARLOCK", specID = { 267 }, charges = 3 }, -- Dimensional Rift
		[212284] = { duration = 45, class = "WARLOCK", specID = { 267 } }, -- Firestone

	-- Shaman

	[2825] = { duration = 60, class = "SHAMAN" }, -- Bloodlust
		[32182] = { parent = 2825 }, -- Heroism
	[20608] = { duration = 1800, class = "SHAMAN" }, -- Reincarnation
	[51485] = { duration = 30, class = "SHAMAN" }, -- Earthgrab Totem
	[51514] = { duration = { default = 30, [264] = 10 }, class = "SHAMAN" }, -- Hex
		[196932] = { parent = 51514 }, -- Voodoo Totem
		[210873] = { parent = 51514 }, -- Hex (Compy)
		[211004] = { parent = 51514 }, -- Hex (Spider)
		[211010] = { parent = 51514 }, -- Hex (Snake)
		[211015] = { parent = 51514 }, -- Hex (Cockroach)
	[57994] = { default = true, duration = 12, class = "SHAMAN" }, -- Wind Shear
	[108271] = { duration = 90, class = "SHAMAN" }, -- Astral Shift
		[210918] = { parent = 108271, duration = 45 }, -- Ethereal Form
	[114049] = { duration = 180, class = "SHAMAN" }, -- Ascendance
		[114050] = { parent = 114050 }, -- Ascendance (Elemental)
		[114051] = { parent = 114050 }, -- Ascendance (Enhancement)
		[114052] = { parent = 114050 }, -- Ascendance (Restoration)
	[192058] = { duration = 60, class = "SHAMAN" }, -- Capacitor
	[192077] = { duration = 120, class = "SHAMAN" }, -- Wind Rush Totem
	[204330] = { duration = 45, class = "SHAMAN" }, -- Skyfury Totem
	[204331] = { duration = 45, class = "SHAMAN" }, -- Counterstrike Totem
	[204332] = { duration = 30, class = "SHAMAN" }, -- Windfury Totem

		-- Elemental

		[16166] = { duration = 120, class = "SHAMAN", specID = { 262 } }, -- Elemental Mastery
		[51490] = { duration = 45, class = "SHAMAN", specID = { 262 } }, -- Thunderstorm
		[108281] = { duration = 120, class = "SHAMAN", specID = { 262, 264 } }, -- Ancestral Guidance
		[192063] = { duration = 15, class = "SHAMAN", specID = { 262, 264 } }, -- Gust of Wind
		[192222] = { duration = 60, class = "SHAMAN", specID = { 262 } }, -- Liquid Magma Totem
		[198067] = { duration = 150, class = "SHAMAN", specID = { 262 } }, -- Fire Elemental
			[192249] = { parent = 198067 }, -- Storm Elemental
		[198103] = { duration = 120, class = "SHAMAN", specID = { 262 } }, -- Earth Elemental
		[204437] = { duration = 30, class = "SHAMAN", specID = { 262 } }, -- Lightning Lasso
		[191634] = { duration = 60, class = "SHAMAN", specID = { 262 } }, -- Stormkeeper

		-- Enhancement

		[58875] = { duration = 60, class = "SHAMAN", specID = { 263 } }, -- Spirit Walk
		[196884] = { duration = 30, class = "SHAMAN", specID = { 263 } }, -- Feral Lunge
		[197214] = { duration = 40, class = "SHAMAN", specID = { 263 } }, -- Sundering
		[201898] = { duration = 45, class = "SHAMAN", specID = { 263 } }, -- Windsong
		[204366] = { duration = 45, class = "SHAMAN", specID = { 263 } }, -- Thundercharge
		[204945] = { duration = 60, class = "SHAMAN", specID = { 263 } }, -- Doom Winds

		-- Restoration

		[5394] = { duration = 30, class = "SHAMAN", specID = { 264 }, charges = 30 }, -- Healing Stream Totem
		[79206] = { duration = 60, class = "SHAMAN", specID = { 264 } }, -- Spiritwalker's Grace
		[98008] = { duration = 180, class = "SHAMAN", specID = { 264 } }, -- Spirit Link Totem
			[204293] = { parent = 98008, duration = 60 }, -- Spirit Link
		[108280] = { duration = 180, class = "SHAMAN", specID = { 264 } }, -- Healing Tide Totem
		[157153] = { duration = 30, class = "SHAMAN", specID = { 264 } }, -- Cloudburst Totem
		[198838] = { duration = 60, class = "SHAMAN", specID = { 264 } }, -- Earthen Wall Totem
		[204336] = { duration = 30, class = "SHAMAN", specID = { 264 } }, -- Grounding Totem
		[207399] = { duration = 300, class = "SHAMAN", specID = { 264 } }, -- Ancestral Protection Totem
		[207778] = { duration = 45, class = "SHAMAN", specID = { 264 } }, -- Gift of the Queen

	-- Hunter

	[136] = { duration = 10, class = "HUNTER" }, -- Mend Pet
	[1543] = { duration = 20, class = "HUNTER" }, -- Flare
	[5384] = { duration = 30, class = "HUNTER" }, -- Feign Death
	[109304] = { duration = 120, class = "HUNTER" }, -- Exhilaration (Beast Mastery, Survival)
	[131894] = { duration = 60, class = "HUNTER" }, -- A Murder of Crows (Beast Mastery, Marksmanship)
		[206505] = { parent = 131894 }, -- A Murder of Crows (Survival)
	[186257] = { duration = { default = 180, [253] = 120, [255] = 144 }, class = "HUNTER" }, -- Aspect of the Cheetah
	[186265] = { duration = { default = 180, [255] = 144 }, class = "HUNTER" }, -- Aspect of the Turtle
	[187650] = { duration = { default = 30, [255] = 20 }, class = "HUNTER" }, -- Freezing Trap
	[202914] = { duration = 60, class = "HUNTER" }, -- Spider Sting
	[209997] = { duration = 30, class = "HUNTER" }, -- Play Dead

		-- Beast Mastery

		[781] = { duration = 20, class = "HUNTER", specID = { 253, 254 } }, -- Disengage
		[19386] = { duration = 45, class = "HUNTER", specID = { 253, 254 } }, -- Wyvern Sting
		[19574] = { duration = 75, class = "HUNTER", specID = { 253 } }, -- Bestial Wrath
		[19577] = { duration = 60, class = "HUNTER", specID = { 253 } }, -- Intimidation
		[109248] = { duration = 45, class = "HUNTER", specID = { 253, 254 } }, -- Binding Shot
		[147362] = { default = true, duration = 24, class = "HUNTER", specID = { 253, 254 } }, -- Counter Shot
		[193530] = { duration = 120, class = "HUNTER", specID = { 253 } }, -- Aspect of the Wild
		[194386] = { duration = 90, class = "HUNTER", specID = { 253, 254 } }, -- Volley
		[201430] = { duration = 180, class = "HUNTER", specID = { 253 } }, -- Stampede
		[207068] = { duration = 60, class = "HUNTER", specID = { 253 } }, -- Titan's Thunder
		[208652] = { duration = 30, class = "HUNTER", specID = { 253 } }, -- Dire Beast: Hawk

		-- Marksmanship

		[34477] = { duration = 30, class = "HUNTER", specID = { 254 } }, -- Misdirection
		[186387] = { duration = 20, class = "HUNTER", specID = { 254 } }, -- Bursting Shot
		[193526] = { duration = 140, class = "HUNTER", specID = { 254 } }, -- Trueshot
		[199483] = { duration = 60, class = "HUNTER", specID = { 254, 255 } }, -- Camouflage
		[204147] = { duration = 20, class = "HUNTER", specID = { 254 } }, -- Windburst
		[206817] = { duration = 30, class = "HUNTER", specID = { 254 } }, -- Sentinel
		[209789] = { duration = 30, class = "HUNTER", specID = { 254 } }, -- Freezing Arrow
		[213691] = { duration = 20, class = "HUNTER", specID = { 254 } }, -- Scatter Shot

		-- Survival

		[53271] = { duration = 45, class = "HUNTER", specID = { 255 } }, -- Master's Call
		[186289] = { duration = 96, class = "HUNTER", specID = { 255 } }, -- Aspect of the Eagle
		[187698] = { duration = 20, class = "HUNTER", specID = { 255 } }, -- Tar Trap
		[187707] = { default = true, duration = 15, class = "HUNTER", specID = { 255 } }, -- Muzzle
		[190925] = { duration = 20, class = "HUNTER", specID = { 255 } }, -- Harpoon
		[191241] = { duration = 30, class = "HUNTER", specID = { 255 } }, -- Sticky Bomb
		[191433] = { duration = 20, class = "HUNTER", specID = { 255 } }, -- Explosive Trap
		[194407] = { duration = 90, class = "HUNTER", specID = { 255 } }, -- Spitting Cobra
		[201078] = { duration = 90, class = "HUNTER", specID = { 255 } }, -- Snake Hunter
		[203415] = { duration = 45, class = "HUNTER", specID = { 255 } }, -- Fury of the Eagle
		[205691] = { duration = 120, class = "HUNTER", specID = { 255 } }, -- Dire Beast: Basilisk
		[212640] = { duration = 25, class = "HUNTER", specID = { 255 } }, -- Mending Bandage

	-- Mage

	[66] = { duration = 300, class = "MAGE" }, -- Invisibility
		[110959] = { parent = 66, duration = 75 }, -- Greater Invisibility
	[1953] = { duration = 15, class = "MAGE"}, -- Blink
		[212653] = { parent = 1953, duration = 20, charges = 2 }, -- Shimmer
	[2139] = { default = true, duration = 24, class = "MAGE" }, -- Counterspell
	[11426] = { duration = 25, class = "MAGE" }, -- Ice Barrier
	[45438] = { duration = 300, class = "MAGE", charges = 2 }, -- Ice Block
	[55342] = { duration = 120, class = "MAGE" }, -- Mirror Image
	[80353] = { duration = 300, class = "MAGE" }, -- Time Warp
	[108839] = { duration = 20, class = "MAGE", charges = 3 }, -- Ice Floes
	[113724] = { duration = 45, class = "MAGE" }, -- Ring of Frost
	[116011] = { duration = 40, class = "MAGE", charges = 2 }, -- Rune of Power
	[198111] = { duration = 45, class = "MAGE" }, -- Temporal Shield

		-- Arcane

		[12042] = { duration = 90, class = "MAGE", specID = { 62 } }, -- Arcane Power
		[12051] = { duration = 90, class = "MAGE", specID = { 62 } }, -- Evocation
		[153626] = { duration = 20, class = "MAGE", specID = { 62 } }, -- Arcane Orb
		[157980] = { duration = 25, class = "MAGE", specID = { 62 } }, -- Supernova
		[195676] = { duration = 24, class = "MAGE", specID = { 62 } }, -- Displacement
		[198158] = { duration = 60, class = "MAGE", specID = { 62 } }, -- Mass Invisibility
		[205025] = { duration = 60, class = "MAGE", specID = { 62 } }, -- Presence of Mind
		[224968] = { duration = 60, class = "MAGE", specID = { 62 } }, -- Mark of Aluneth

		-- Fire

		[31661] = { duration = 20, class = "MAGE", specID = { 63 } }, -- Dragon's Breath
		[108853] = { duration = 12, class = "MAGE", specID = { 63 }, charges = 2 }, -- Fire Blast
		[153561] = { duration = 45, class = "MAGE", specID = { 63 } }, -- Meteor
		[157981] = { duration = 25, class = "MAGE", specID = { 63 } }, -- Blast Wave
		[190319] = { duration = 115, class = "MAGE", specID = { 63 } }, -- Combustion
		[194466] = { duration = 45, class = "MAGE", specID = { 63 }, charges = 3 }, -- Phoenix's Flames
		[205029] = { duration = 45, class = "MAGE", specID = { 63 } }, -- Flame On

		-- Frost

		[122] = { duration = 30, class = "MAGE", specID = { 64 }, charges = 2 }, -- Frost Nova
		[12472] = { duration = 180, class = "MAGE", specID = { 64 } }, -- Icy Veins
			[198144] = { parent = 12472, duration = 45 }, -- Ice Form
		[31687] = { duration = 60, class = "MAGE", specID = { 64 } }, -- Summon Water Elemental
		[84714] = { duration = 60, class = "MAGE", specID = { 64 } }, -- Frozen Orb
		[153595] = { duration = 30, class = "MAGE", specID = { 64 } }, -- Comet Storm
		[157997] = { duration = 25, class = "MAGE", specID = { 64 } }, -- Ice Nova
		[205021] = { duration = 75, class = "MAGE", specID = { 64 } }, -- Ray of Frost
		[214634] = { duration = 45, class = "MAGE", specID = { 64 } }, -- Ebonbolt

	-- Rogue

	[1725] = { duration = 30, class = "ROGUE" }, -- Distract
	[1766] = { default = true, duration = 15, class = "ROGUE" }, -- Kick
	[1856] = { duration = { default = 120, [261] = 30 }, class = "ROGUE" }, -- Vanish
	[2983] = { duration = { default = 60, [259] = 51 }, class = "ROGUE" }, -- Sprint
	[31224] = { duration = { default = 90, [259] = 81 }, class = "ROGUE" }, -- Cloak of Shadows
	[57934] = { duration = 30, class = "ROGUE" }, -- Tricks of the Trade
	[137619] = { duration = 40, class = "ROGUE" }, -- Marked for Death
	[152150] = { duration = 20, class = "ROGUE" }, -- Death from Above

		-- Assassination

		[408] = { duration = 20, class = "ROGUE", specID = { 259, 261 } }, -- Kidney Shot
		[703] = { duration = 6, class = "ROGUE", specID = { 259 } }, -- Garrote
		[5277] = { duration = 120, class = "ROGUE", specID = { 259, 261 } }, -- Evasion
		[36554] = { duration = 30, class = "ROGUE", specID = { 259, 261 } }, -- Shadowstep
		[79140] = { duration = 120, class = "ROGUE", specID = { 259 } }, -- Vendetta
		[192759] = { duration = 45, class = "ROGUE", specID = { 259 } }, -- Kingsbane
		[200806] = { duration = 45, class = "ROGUE", specID = { 259 } }, -- Exsanguinate
		[206328] = { duration = 25, class = "ROGUE", specID = { 259 } }, -- Shiv

		-- Outlaw

		[1776] = { duration = 15, class = "ROGUE", specID = { 260 } }, -- Gouge
		[2094] = { duration = 120, class = "ROGUE", specID = { 260, 261 } }, -- Blind
			[199743] = { parent = 2094, duration = 20 }, -- Parley
		[13750] = { duration = 150, class = "ROGUE", specID = { 260 } }, -- Adrenaline Rush
		[51690] = { duration = 120, class = "ROGUE", specID = { 260 } }, -- Killing Spree
		--[185767] = { duration = 60, class = "ROGUE", specID = { 260 } }, -- Cannonball Barrage
		[195457] = { duration = 30, class = "ROGUE", specID = { 260 } }, -- Grappling Hook
		[198529] = { duration = 120, class = "ROGUE", specID = { 260 } }, -- Plunder Armor
		[199754] = { duration = 120, class = "ROGUE", specID = { 260 } }, -- Riposte
		[199804] = { duration = 30, class = "ROGUE", specID = { 260 } }, -- Between the Eyes
		[202665] = { duration = 90, class = "ROGUE", specID = { 260 } }, -- Curse of the Dreadblades
		[207777] = { duration = 45, class = "ROGUE", specID = { 260 } }, -- Dismantle

		-- Subtlety

		[121471] = { duration = 180, class = "ROGUE", specID = { 261 } }, -- Shadow Blades
		[185313] = { duration = 60, class = "ROGUE", specID = { 261 }, charges = 3 }, -- Shadow Dance
		[207736] = { duration = 120, class = "ROGUE", specID = { 261 } }, -- Shadowy Duel
		[209782] = { duration = 60, class = "ROGUE", specID = { 261 } }, -- Goremaw's Bite
		[212182] = { duration = 180, class = "ROGUE", specID = { 261 } }, -- Smoke Bomb
		[213981] = { duration = 45, class = "ROGUE", specID = { 261 } }, -- Cold Blood

	-- Monk

	[109132] = { duration = 15, class = "MONK", charges = 3 }, -- Roll
		[115008] = { parent = 109132 }, -- Chi Torpedo
	[115078] = { duration = 45, class = "MONK" }, -- Paralysis
	[116841] = { duration = 30, class = "MONK" }, -- Tiger's Lust
	[116844] = { duration = 45, class = "MONK" }, -- Ring of Peace
	[119381] = { duration = 60, class = "MONK" }, -- Leg Sweep
	[119996] = { duration = 45, class = "MONK" }, -- Transcendence: Transfer
	[122278] = { duration = 120, class = "MONK" }, -- Dampen Harm
	[122783] = { duration = 120, class = "MONK" }, -- Diffuse Magic
	[123986] = { duration = 30, class = "MONK" }, -- Chi Burst
	--[137648] = { duration = 120, class = "MONK" }, -- Nimble Brew

		-- Brewmaster

		[115203] = { duration = 105, class = "MONK", specID = { 268 } }, -- Fortifying Brew
		[115399] = { duration = 90, class = "MONK", specID = { 268 } }, -- Black Ox Brew
		[116705] = { default = true, duration = 15, class = "MONK", specID = { 268, 269 } }, -- Spear Hand Strike
		[132578] = { duration = 180, class = "MONK", specID = { 268 } }, -- Invoke Niuzao, the Black Ox
		[202162] = { duration = 45, class = "MONK", specID = { 268 } }, -- Guard
		[202272] = { duration = 45, class = "MONK", specID = { 268 } }, -- Incendiary Brew
		[202370] = { duration = 60, class = "MONK", specID = { 268 } }, -- Mighty Ox Kick

		-- Windwalker

		[101545] = { duration = 25, class = "MONK", specID = { 269 }, charges = 2 }, -- Flying Serpent Kick
		[113656] = { duration = 24, class = "MONK", specID = { 269 } }, -- Fists of Fury
		[115080] = { duration = 120, class = "MONK", specID = { 269 } }, -- Touch of Death
			[152173] = { parent = 137639 }, -- Serenity
		[115176] = { duration = 150, class = "MONK", specID = { 269 } }, -- Zen Meditation
			[201325] = { parent = 115176, 180 }, -- Zen Meditation (Windwalker)
		[115288] = { duration = 60, class = "MONK", specID = { 269 } }, -- Energizing Elixir
		[122470] = { duration = 90, class = "MONK", specID = { 269 } }, -- Touch of Karma
		[123904] = { duration = 120, class = "MONK", specID = { 269 } }, -- Invoke Xuen, the White Tiger
		[137639] = { duration = 90, class = "MONK", specID = { 269 }, charges = 2 }, -- Storm, Earth, and Fire
		[152175] = { duration = 24, class = "MONK", specID = { 269 } }, -- Whirling Dragon Punch
		[201318] = { duration = 90, class = "MONK", specID = { 269 } }, -- Fortifying Elixir

		-- Mistweaver

		[115310] = { duration = 180, class = "MONK", specID = { 270 } }, -- Revival
		[116680] = { duration = 30, class = "MONK", specID = { 270 } }, -- Thunder Focus Tea
		[116849] = { duration = 120, class = "MONK", specID = { 270 } }, -- Life Cocoon
		[197908] = { duration = 90, class = "MONK", specID = { 270 } }, -- Mana Tea
		--[197945] = { duration = 20, class = "MONK", specID = { 270 }, charges = 2 }, -- Mistwalk
		[198664] = { duration = 180, class = "MONK", specID = { 270 } }, -- Invoke Chi-Ji, the Red Crane
		[198898] = { duration = 30, class = "MONK", specID = { 270 } }, -- Song of Chi-Ji
		[216113] = { duration = 45, class = "MONK", specID = { 270 } }, -- Way of the Crane

}

local cooldowns = OmniBar.cooldowns

local order = {
	["DEMONHUNTER"] = 1,
	["DEATHKNIGHT"] = 2,
	["PALADIN"] = 3,
	["WARRIOR"] = 4,
	["DRUID"] = 5,
	["PRIEST"] = 6,
	["WARLOCK"] = 7,
	["SHAMAN"] = 8,
	["HUNTER"] = 9,
	["MAGE"] = 10,
	["ROGUE"] = 11,
	["MONK"] = 12,
}

local resets = {
	--[[ Grimoire: Felhunter
	     - Spell Lock
	  ]]
	[111897] = { 119910 },
}

-- Defaults
local defaults = {
	size                 = 40,
	columns              = 8,
	padding              = 1,
	locked               = false,
	center               = false,
	border               = false,
	highlightTarget      = false,
	highlightFocus       = false,
	growUpward           = true,
	showUnused           = false,
	adaptive             = true,
	unusedAlpha          = 0.40,
	swipeAlpha           = 0.70,
	cooldownCount        = true,
	arena                = true,
	ratedBattleground    = true,
	battleground         = true,
	world                = true,
	scenario             = true,
	multiple             = true,
	glow                 = true,
	tooltips             = true,
	names                = false,
	maxIcons             = 500,
	align                = "CENTER",
    xOfs                 = -145,
    yOfs                 = -120,
}

local SETTINGS_VERSION = 3

local MAX_DUPLICATE_ICONS = 5

local BASE_ICON_SIZE = 36

local _

OmniBar.index = 1

OmniBar.bars = {}

function OmniBar:OnEnable()
	if not OmniBarDB or not OmniBarDB.version or OmniBarDB.version < SETTINGS_VERSION then OmniBarDB = { version = SETTINGS_VERSION } end

	self.db = LibStub("AceDB-3.0"):New("OmniBarDB", { profile = { bars = {} } }, true)

	self.index = 1

	for i = #self.bars, 1, -1 do
		OmniBar:Delete(self.bars[i].key, true)
		table.remove(self.bars, i)
	end

	for key,_ in pairs(self.db.profile.bars) do
		self:Initialize(key)
		self.index = self.index + 1
	end

	-- Create a default bar if none exist
	if self.index == 1 then
		self:Initialize("OmniBar1", "OmniBar")
		self.index = 2
	end

	if not self.registered then
		self.db.RegisterCallback(self, "OnProfileChanged", "OnEnable")
		self.db.RegisterCallback(self, "OnProfileCopied", "OnEnable")
		self.db.RegisterCallback(self, "OnProfileReset", "OnEnable")

		self:SetupOptions()
		self.registered = true
	end

	for key,_ in pairs(self.db.profile.bars) do
		self:AddBarToOptions(key)
	end

	self:Refresh(true)
end

function OmniBar:Delete(key, keepProfile)
	local bar = _G[key]
	if not bar then return end
	bar:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	bar:UnregisterEvent("PLAYER_ENTERING_WORLD")
	bar:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	bar:UnregisterEvent("PLAYER_TARGET_CHANGED")
	bar:UnregisterEvent("PLAYER_FOCUS_CHANGED")
	bar:UnregisterEvent("PLAYER_REGEN_DISABLED")
	bar:UnregisterEvent("ARENA_OPPONENT_UPDATE")
	bar:UnregisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	bar:UnregisterEvent("UPDATE_BATTLEFIELD_SCORE")
	bar:UnregisterEvent("UPDATE_BATTLEFIELD_STATUS")
	bar:Hide()
	if not keepProfile then self.db.profile.bars[key] = nil end
	self.options.args.bars.args[key] = nil
	LibStub("AceConfigRegistry-3.0"):NotifyChange("OmniBar")
end

OmniBar.BackupCooldowns = {}

function OmniBar:CopyCooldown(cooldown)
	local copy = {}

	for _,v in pairs({"class", "charges", "parent", "name", "icon"}) do
		if cooldown[v] then
			copy[v] = cooldown[v]
		end
	end

	if cooldown.duration then
		if type(cooldown.duration) == "table" then
			copy.duration = {}
			for k, v in pairs(cooldown.duration) do
				copy.duration[k] = v
			end
		else
			copy.duration = { default = cooldown.duration }
		end
	end

	if cooldown.specID then
		copy.specID = {}
		for i = 1, #cooldown.specID do
			table.insert(copy.specID, cooldown.specID[i])
		end
	end

	return copy
end

function OmniBar:AddCustomSpells()
	-- Restore any overrides
	for k,v in pairs(self.BackupCooldowns) do
		cooldowns[k] = self:CopyCooldown(v)
	end

	-- Add custom spells
	for k,v in pairs(OmniBarDB.cooldowns) do
		-- Backup if we are going to override
		if cooldowns[k] and not cooldowns[k].custom and not self.BackupCooldowns[k] then
			self.BackupCooldowns[k] = self:CopyCooldown(cooldowns[k])
		end
		cooldowns[k] = v
	end

	-- Populate cooldowns with spell names and icons
	for spellId,_ in pairs(cooldowns) do
		local name, _, icon = GetSpellInfo(spellId)
		cooldowns[spellId].icon = icon
		cooldowns[spellId].name = name
	end

end

function OmniBar:Initialize(key, name)
	if not self.db.profile.bars[key] then
		self.db.profile.bars[key] = { name = name }
		for a,b in pairs(defaults) do
			self.db.profile.bars[key][a] = b
		end
	end

	OmniBarDB.cooldowns = OmniBarDB.cooldowns or {}

	self:AddCustomSpells()

	local f = _G[key] or CreateFrame("Frame", key, UIParent, "OmniBarTemplate")
	f:Show()
	f.settings = self.db.profile.bars[key]
	f.settings.align = f.settings.align or "CENTER"
	f.settings.maxIcons = f.settings.maxIcons or 500
	f.key = key
	f.icons = {}
	f.active = {}
	f.cooldowns = cooldowns
	f.detected = {}
	f.specs = {}
	f.BASE_ICON_SIZE = BASE_ICON_SIZE
	f.numIcons = 0
	f:RegisterForDrag("LeftButton")

	local name = f.settings.name
	f.anchor.text:SetText(name)

	-- Load the settings
	OmniBar_LoadSettings(f)

	-- Create the icons
	for spellID,_ in pairs(cooldowns) do
		if OmniBar_IsSpellEnabled(f, spellID) then
			OmniBar_CreateIcon(f)
		end
	end

	-- Create the duplicate icons
	for i = 1, MAX_DUPLICATE_ICONS do
		OmniBar_CreateIcon(f)
	end

	OmniBar_ShowAnchor(f)
	OmniBar_RefreshIcons(f)
	OmniBar_UpdateIcons(f)
	OmniBar_Center(f)

	f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	f:RegisterEvent("PLAYER_ENTERING_WORLD")
	f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	f:RegisterEvent("PLAYER_FOCUS_CHANGED")
	f:RegisterEvent("PLAYER_REGEN_DISABLED")
	f:RegisterEvent("ARENA_OPPONENT_UPDATE")
	f:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	f:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	f:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")

	table.insert(self.bars, f)
end


function OmniBar:Create()

	local key

	while true do
		key = "OmniBar"..self.index
		self.index = self.index + 1
		if not self.db.profile.bars[key] then
			self:Initialize(key, "OmniBar "..self.index - 1)
			self:AddBarToOptions(key, true)
			return
		end
	end

end

function OmniBar:Refresh(full)
	for key,_ in pairs(self.db.profile.bars) do
		local f = _G[key]
		if f then
			f.container:SetScale(f.settings.size/BASE_ICON_SIZE)
			if full then
				OmniBar_OnEvent(f, "PLAYER_ENTERING_WORLD")
			else
				OmniBar_LoadPosition(f)
				OmniBar_UpdateIcons(f)
				OmniBar_Center(f)
			end
		end
	end
end

local Masque = LibStub and LibStub("Masque", true)

-- create a lookup table to translate spec names into IDs
local specNames = {}
for classID = 1, MAX_CLASSES do
	local _, classToken = GetClassInfo(classID)
	specNames[classToken] = {}
	for i = 1, GetNumSpecializationsForClassID(classID) do
		local id, name = GetSpecializationInfoForClassID(classID, i)
		specNames[classToken][name] = id
	end
end

local function IsHostilePlayer(unit)
	if not unit then return end
	local reaction = UnitReaction("player", unit)
	if not reaction then return end -- out of range
	return UnitIsPlayer(unit) and reaction < 4 and not UnitIsPossessed(unit)
end

function OmniBar_ShowAnchor(self)
	if self.disabled or self.settings.locked or #self.active > 0 then
		self.anchor:Hide()
	else
		local width = self.anchor.text:GetWidth() + 29
		self.anchor:SetSize(width, 30)
		self.anchor:Show()
	end
end

function OmniBar_CreateIcon(self)
	if InCombatLockdown() then return end
	self.numIcons = self.numIcons + 1
	local name = self:GetName()
	local key = name.."Icon"..self.numIcons
	local f = _G[key] or CreateFrame("Button", key, _G[name.."Icons"], "OmniBarButtonTemplate")
	table.insert(self.icons, f)
end

local function SpellBelongsToSpec(spellID, specID)
	if not specID then return true end
	if not cooldowns[spellID].specID then return true end
	for i = 1, #cooldowns[spellID].specID do
		if cooldowns[spellID].specID[i] == specID then return true end
	end
	return false
end

function OmniBar_AddIconsByClass(self, class, sourceGUID, specID)
	for spellID, spell in pairs(cooldowns) do
		if OmniBar_IsSpellEnabled(self, spellID) and spell.class == class and SpellBelongsToSpec(spellID, specID) then
			OmniBar_AddIcon(self, spellID, sourceGUID, nil, true, nil, specID)
		end
	end
end

local function IconIsSource(iconGUID, guid)
	if not guid then return end
	if string.len(iconGUID) == 1 then
		-- arena target
		return UnitGUID("arena"..iconGUID) == guid
	end
	return iconGUID == guid
end

function OmniBar_UpdateBorders(self)
	for i = 1, #self.active do
		local border
		local guid = self.active[i].sourceGUID
		if guid then
			if self.settings.highlightFocus and IconIsSource(guid, UnitGUID("focus")) then
				self.active[i].FocusTexture:SetAlpha(1)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			if self.settings.highlightTarget and IconIsSource(guid, UnitGUID("target")) then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)
				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		else
			local class = select(2, UnitClass("focus"))
			if self.settings.highlightFocus and class and IsHostilePlayer("focus") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(1)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			class = select(2, UnitClass("target"))
			if self.settings.highlightTarget and class and IsHostilePlayer("target") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)
				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		end

		-- Set dim
		self.active[i]:SetAlpha(self.settings.unusedAlpha and self.active[i].cooldown:GetCooldownTimes() == 0 and not border and
			self.settings.unusedAlpha or 1)
	end
end

function OmniBar_UpdateArenaSpecs(self)
	if self.zone ~= "arena" then return end
	for i = 1, 5 do
		local specID = GetArenaOpponentSpec(i)
		if specID and specID > 0 then
			local name = GetUnitName("arena"..i, true)
			if name then self.specs[name] = specID end
		end
	end
end

function OmniBar_SetZone(self, refresh)
	local disabled = self.disabled
	local _, zone = IsInInstance()
	-- if zone == "none" then
	-- 	SetMapToCurrentZone()
	-- 	zone = GetCurrentMapAreaID()
	-- end

	self.zone = zone
	local rated = IsRatedBattleground()
	self.disabled = (zone == "arena" and not self.settings.arena) or
		(rated and not self.settings.ratedBattleground) or
		(zone == "pvp" and not self.settings.battleground and not rated) or
		(zone == "scenario" and not self.settings.scenario) or
		(zone ~= "arena" and zone ~= "pvp" and zone ~= "scenario" and not self.settings.world)

	if refresh or disabled ~= self.disabled then
		OmniBar_LoadPosition(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_ShowAnchor(self)
		if zone == "arena" and not self.disabled then
			wipe(self.detected)
			wipe(self.specs)
			OmniBar_OnEvent(self, "ARENA_OPPONENT_UPDATE")
		end
	end

end

function OmniBar_OnEvent(self, event)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, event, _, sourceGUID, sourceName, sourceFlags, _,_,_,_,_, spellID = CombatLogGetCurrentEventInfo()
		if self.disabled then return end
		if (event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED") and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
			if cooldowns[spellID] then
				OmniBar_UpdateArenaSpecs(self)
				OmniBar_AddIcon(self, spellID, sourceGUID, sourceName)
			end

			-- Check if we need to reset any cooldowns
			if resets[spellID] then
				for i = 1, #self.active do
					if self.active[i] and self.active[i].spellID and self.active[i].sourceGUID and self.active[i].sourceGUID == sourceGUID and self.active[i].cooldown:IsVisible() then
						-- cooldown belongs to this source
						for j = 1, #resets[spellID] do
							if resets[spellID][j] == self.active[i].spellID then
								self.active[i].cooldown:Hide()
								OmniBar_CooldownFinish(self.active[i].cooldown, true)
								return
							end
						end
					end
				end
			end
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
		OmniBar_SetZone(self, true)

	elseif event == "ZONE_CHANGED_NEW_AREA" then
		OmniBar_SetZone(self, true)

	elseif event == "UPDATE_BATTLEFIELD_STATUS" then -- IsRatedBattleground() doesn't return valid response until this event
		OmniBar_SetZone(self)

	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		for i = 1, GetNumBattlefieldScores() do
			local name, _,_,_,_,_,_,_, classToken, _,_,_,_,_,_, talentSpec = GetBattlefieldScore(i)
			if name and specNames[classToken] and specNames[classToken][talentSpec] then
				self.specs[name] = specNames[classToken][talentSpec]
			end
		end

	elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or event == "ARENA_OPPONENT_UPDATE" then
		if self.disabled or not self.settings.adaptive then return end
		for i = 1, 5 do
			local specID = GetArenaOpponentSpec(i)
			if specID and specID > 0 then
				-- only add icons if show unused is checked
				if not self.settings.showUnused then return end
				if not self.detected[i] then
					local class = select(6, GetSpecializationInfoByID(specID))
					OmniBar_AddIconsByClass(self, class, i, specID)
					self.detected[i] = class
				end
			end
		end

	elseif event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" or event == "PLAYER_REGEN_DISABLED" then
		if self.disabled then return end

		-- update icon borders
		OmniBar_UpdateBorders(self)

		-- we don't need to add in arena
		if self.zone == "arena" then return end

		-- only add icons if show adaptive is checked
		if not self.settings.showUnused or not self.settings.adaptive then return end

		-- only add icons when we're in combat
		--if event == "PLAYER_TARGET_CHANGED" and not InCombatLockdown() then return end

		local unit = "playertarget"
		if IsHostilePlayer(unit) then
			local guid = UnitGUID(unit)
			local _, class = UnitClass(unit)
			if class then
				if self.detected[guid] then return end
				self.detected[guid] = class
				OmniBar_AddIconsByClass(self, class)
			end
		end
	end
end

function OmniBar_LoadSettings(self)

	-- Set the scale
	self.container:SetScale(self.settings.size/BASE_ICON_SIZE)

	OmniBar_LoadPosition(self)
	OmniBar_RefreshIcons(self)
	OmniBar_UpdateIcons(self)
	OmniBar_Center(self)
end

function OmniBar_SavePosition(self, set)
	local point, relativeTo, relativePoint, xOfs, yOfs = self:GetPoint()
	local frameStrata = self:GetFrameStrata()
	relativeTo = relativeTo and relativeTo:GetName() or "UIParent"
	if set then
		if set.point then point = set.point end
		if set.relativeTo then relativeTo = set.relativeTo end
		if set.relativePoint then relativePoint = set.relativePoint end
		if set.xOfs then xOfs = set.xOfs end
		if set.yOfs then yOfs = set.yOfs end
		if set.frameStrata then frameStrata = set.frameStrata end
	end

	if not self.settings.position then
		self.settings.position = {}
	end
	self.settings.position.point = point
	self.settings.position.relativeTo = relativeTo
	self.settings.position.relativePoint = relativePoint
	self.settings.position.xOfs = xOfs
	self.settings.position.yOfs = yOfs
	self.settings.position.frameStrata = frameStrata
end

function OmniBar_LoadPosition(self)
	self:ClearAllPoints()
	if self.settings.position then
		local relativeTo = self.settings.position.relativeTo and self.settings.position.relativeTo or "UIParent"
		self:SetPoint(self.settings.position.point, self.settings.position.relativeTo, self.settings.position.relativePoint,
			self.settings.position.xOfs, self.settings.position.yOfs)
		if not self.settings.position.frameStrata then self.settings.position.frameStrata = "MEDIUM" end
		self:SetFrameStrata(self.settings.position.frameStrata)
	else
		self:SetPoint("CENTER", UIParent, "CENTER", 0, -150)
		OmniBar_SavePosition(self)
	end
end

function OmniBar_IsSpellEnabled(self, spellID)
	if not spellID then return end
	-- Check for an explicit rule
	local key = "spell"..spellID
	if type(self.settings[key]) == "boolean" then
		if self.settings[key] then
			return true
		end
	elseif not self.settings.noDefault and cooldowns[spellID].default then
		-- Not user-set, but a default cooldown
		return true
	end
end

function OmniBar_Center(self)
	local parentWidth = UIParent:GetWidth()
	local clamp = self.settings.center and (1 - parentWidth)/2 or 0
	self:SetClampRectInsets(clamp, -clamp, 0, 0)
	clamp = self.settings.center and (self.anchor:GetWidth() - parentWidth)/2 or 0
	self.anchor:SetClampRectInsets(clamp, -clamp, 0, 0)
end

function OmniBar_CooldownFinish(self, force)
	local icon = self:GetParent()
	if icon.cooldown and icon.cooldown:GetCooldownTimes() > 0 and not force then return end -- not complete
	local charges = icon.charges
	if charges then
		charges = charges - 1
		if charges > 0 then
			-- remove a charge
			icon.charges = charges
			icon.Count:SetText(charges)
			if self.omnicc then
				self.omnicc:HookScript('OnHide', function()
					OmniBar_StartCooldown(icon:GetParent():GetParent(), icon, GetTime())
				end)
			end
			OmniBar_StartCooldown(icon:GetParent():GetParent(), icon, GetTime())
			return
		end
	end

	local bar = icon:GetParent():GetParent()

	local flash = icon.flashAnim
	local newItemGlowAnim = icon.newitemglowAnim

	if flash:IsPlaying() or newItemGlowAnim:IsPlaying() then
		flash:Stop()
		newItemGlowAnim:Stop()
	end

	if not bar.settings.showUnused then
		icon:Hide()
	else
		if icon.TargetTexture:GetAlpha() == 0 and
			icon.FocusTexture:GetAlpha() == 0 and
			bar.settings.unusedAlpha then
				icon:SetAlpha(bar.settings.unusedAlpha)
		end
	end
	bar:StopMovingOrSizing()
	OmniBar_Position(bar)
end

function OmniBar_RefreshIcons(self)
	-- Hide all the icons
	for i = 1, self.numIcons do
		if self.icons[i].MasqueGroup then
			--self.icons[i].MasqueGroup:Delete()
			self.icons[i].MasqueGroup = nil
		end
		self.icons[i].TargetTexture:SetAlpha(0)
		self.icons[i].FocusTexture:SetAlpha(0)
		self.icons[i].flash:SetAlpha(0)
		self.icons[i].NewItemTexture:SetAlpha(0)
		self.icons[i].cooldown:SetCooldown(0, 0)
		self.icons[i].cooldown:Hide()
		self.icons[i]:Hide()
	end
	wipe(self.active)

	if self.disabled then return end

	if self.settings.showUnused and not self.settings.adaptive then
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_AddIcon(self, spellID, nil, nil, true)
			end
		end
	end
	OmniBar_Position(self)
end

function OmniBar_StartCooldown(self, icon, start)
	icon.cooldown:SetCooldown(start, icon.duration)
	icon.cooldown.finish = start + icon.duration
	icon.cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)
	icon:SetAlpha(1)
end


function OmniBar_AddIcon(self, spellID, sourceGUID, sourceName, init, test, specID)
	-- Check for parent spellID
	local originalSpellID = spellID
	if cooldowns[spellID].parent then spellID = cooldowns[spellID].parent end

	if not OmniBar_IsSpellEnabled(self, spellID) then return end

	local icon, duplicate

	-- Try to reuse a visible frame
	for i = 1, #self.active do
		if self.active[i].spellID == spellID then
			duplicate = true
			-- check if we can use this icon, but not when initializing arena opponents
			if not init or self.zone ~= "arena" then
				-- use icon if not bound to a sourceGUID
				if not self.active[i].sourceGUID then
					duplicate = nil
					icon = self.active[i]
					break
				end

				-- if it's the same source, reuse the icon
				if sourceGUID and IconIsSource(self.active[i].sourceGUID, sourceGUID) then
					duplicate = nil
					icon = self.active[i]
					break
				end

			end
		end
	end

	-- We couldn't find a visible frame to reuse, try to find an unused
	if not icon then
		if #self.active >= self.settings.maxIcons then return end
		if not self.settings.multiple and duplicate then return end
		for i = 1, #self.icons do
			if not self.icons[i]:IsVisible() then
				icon = self.icons[i]
				icon.specID = nil
				break
			end
		end
	end

	-- We couldn't find a frame to use
	if not icon then return end

	local now = GetTime()

	if specID then
		icon.specID = specID
	else
		if sourceName and sourceName ~= COMBATLOG_FILTER_STRING_UNKNOWN_UNITS and self.specs[sourceName] then
			icon.specID = self.specs[sourceName]
		end
	end

	icon.class = cooldowns[spellID].class
	icon.sourceGUID = sourceGUID
	icon.icon:SetTexture(cooldowns[spellID].icon)
	icon.spellID = spellID
	icon.added = now

	if icon.charges and cooldowns[originalSpellID].charges and icon:IsVisible() then
		local start, duration = icon.cooldown:GetCooldownTimes()
		if icon.cooldown.finish and icon.cooldown.finish - GetTime() > 1 then
			-- add a charge
			local charges = icon.charges + 1
			icon.charges = charges
			icon.Count:SetText(charges)
			if self.settings.glow then
				icon.flashAnim:Play()
				icon.newitemglowAnim:Play()
			end
			return icon
		end
	elseif cooldowns[originalSpellID].charges then
		icon.charges = 1
		icon.Count:SetText("1")
	else
		icon.charges = nil
		icon.Count:SetText(nil)
	end

	local name = self.settings.names and sourceGUID and type(sourceGUID) == "string" and select(6, GetPlayerInfoByGUID(sourceGUID))
	if test and self.settings.names then name = "Name" end
	icon.Name:SetText(name)

	if cooldowns[originalSpellID].duration then
		if type(cooldowns[originalSpellID].duration) == "table" then
			if icon.specID and cooldowns[originalSpellID].duration[icon.specID] then
				icon.duration = cooldowns[originalSpellID].duration[icon.specID]
			else
				icon.duration = cooldowns[originalSpellID].duration.default
			end
		else
			icon.duration = cooldowns[originalSpellID].duration
		end
	else -- child doesn't have a custom duration, use parent
		if type(cooldowns[spellID].duration) == "table" then
			if icon.specID and cooldowns[spellID].duration[icon.specID] then
				icon.duration = cooldowns[spellID].duration[icon.specID]
			else
				icon.duration = cooldowns[spellID].duration.default
			end
		else
			icon.duration = cooldowns[spellID].duration
		end
	end

	-- We don't want duration to be too long if we're just testing
	if test then icon.duration = math.random(5,30) end

	-- Masque
	if Masque then
		icon.MasqueGroup = Masque:Group("OmniBar", cooldowns[spellID].name)
		icon.MasqueGroup:AddButton(icon, {
			FloatingBG = false,
			Icon = icon.icon,
			Cooldown = icon.cooldown,
			Flash = false,
			Pushed = false,
			Normal = icon:GetNormalTexture(),
			Disabled = false,
			Checked = false,
			Border = _G[icon:GetName().."Border"],
			AutoCastable = false,
			Highlight = false,
			Hotkey = false,
			Count = false,
			Name = false,
			Duration = false,
			AutoCast = false,
		})
	end

	icon:Show()

	if not init then
		OmniBar_StartCooldown(self, icon, now)
		if self.settings.glow then
			icon.flashAnim:Play()
			icon.newitemglowAnim:Play()
		end
	end

	return icon
end

function OmniBar_UpdateIcons(self)
	for i = 1, self.numIcons do
		-- Set show text
		self.icons[i].cooldown:SetHideCountdownNumbers(not self.settings.cooldownCount and true or false)
		self.icons[i].cooldown.noCooldownCount = not self.settings.cooldownCount

		-- Set swipe alpha
		self.icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)

		-- Set border
		if self.settings.border then
			self.icons[i].icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		else
			self.icons[i].icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
		end

		-- Set dim
		self.icons[i]:SetAlpha(self.settings.unusedAlpha and self.icons[i].cooldown:GetCooldownTimes() == 0 and
			self.settings.unusedAlpha or 1)

		-- Masque
		if self.icons[i].MasqueGroup then self.icons[i].MasqueGroup:ReSkin() end

	end
end

function OmniBar_Test(self)
	self.disabled = nil
	OmniBar_RefreshIcons(self)
	for k,v in pairs(cooldowns) do
		OmniBar_AddIcon(self, k, nil, nil, nil, true)
	end
end

local function ExtractDigits(str)
	if not str then return 0 end
	if type(str) == "number" then return str end
	local num = str:gsub("%D", "")
	return tonumber(num) or 0
end

function OmniBar_Position(self)
	local numActive = #self.active
	if numActive == 0 then
		-- Show the anchor if needed
		OmniBar_ShowAnchor(self)
		return
	end

	-- Keep cooldowns together by class
	if self.settings.showUnused then
		table.sort(self.active, function(a, b)
			local x, y = ExtractDigits(a.sourceGUID), ExtractDigits(b.sourceGUID)
			if a.class == b.class then
				if x < y then return true end
				if x == y then return a.spellID < b.spellID end
			end
			return order[a.class] < order[b.class]
		end)
	else
		-- if we aren't showing unused, just sort by added time
		table.sort(self.active, function(a, b) return a.added == b.added and a.spellID < b.spellID or a.added < b.added end)
	end

	local count, rows = 0, 1
	local grow = self.settings.growUpward and 1 or -1
	local padding = self.settings.padding and self.settings.padding or 0
	for i = 1, numActive do
		if self.settings.locked then
			self.active[i]:EnableMouse(false)
		else
			self.active[i]:EnableMouse(true)
		end
		self.active[i]:ClearAllPoints()
		local columns = self.settings.columns and self.settings.columns > 0 and self.settings.columns < numActive and
			self.settings.columns or numActive
		if i > 1 then
			count = count + 1
			if count >= columns then
				if self.settings.align == "CENTER" then
					self.active[i]:SetPoint("CENTER", self.anchor, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, (BASE_ICON_SIZE+padding)*rows*grow)
				else
					self.active[i]:SetPoint(self.settings.align, self.anchor, self.settings.align, 0, (BASE_ICON_SIZE+padding)*rows*grow)
				end

				count = 0
				rows = rows + 1
			else
				if self.settings.align == "RIGHT" then
					self.active[i]:SetPoint("TOPRIGHT", self.active[i-1], "TOPLEFT", -1 * padding, 0)
				else
					self.active[i]:SetPoint("TOPLEFT", self.active[i-1], "TOPRIGHT", padding, 0)
				end
			end

		else
			if self.settings.align == "CENTER" then
				self.active[i]:SetPoint("CENTER", self.anchor, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, 0)
			else
				self.active[i]:SetPoint(self.settings.align, self.anchor, self.settings.align, 0, 0)
			end
		end
	end
	OmniBar_ShowAnchor(self)
end

function OmniBar:Test()
	for key,_ in pairs(self.db.profile.bars) do
		OmniBar_Test(_G[key])
	end
end

SLASH_OmniBar1 = "/ob"
SLASH_OmniBar2 = "/omnibar"
SlashCmdList.OmniBar = function()
	InterfaceOptionsFrame_OpenToCategory("OmniBar")
	InterfaceOptionsFrame_OpenToCategory("OmniBar")
end
