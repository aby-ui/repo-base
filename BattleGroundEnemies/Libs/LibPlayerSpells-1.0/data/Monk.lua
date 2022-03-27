--[[
LibPlayerSpells-1.0 - Additional information about player spells.
(c) 2013-2021 Adirelle (adirelle@gmail.com)

This file is part of LibPlayerSpells-1.0.

LibPlayerSpells-1.0 is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LibPlayerSpells-1.0 is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LibPlayerSpells-1.0. If not, see <http://www.gnu.org/licenses/>.
--]]

local lib = LibStub('LibPlayerSpells-1.0')
if not lib then return end
lib:__RegisterSpells('MONK', 90100, 1, {
	COOLDOWN = {
		 107428, -- Rising Sun Kick (Mistweaver/Windwalker)
		 109132, -- Roll
		 113656, -- Fists of Fury (Windwalker)
		 115098, -- Chi Wave (talent)
		 115313, -- Summon Jade Serpent Statue (Mistweaver talent)
		 115315, -- Summon Black Ox Statue (Brewmaster talent)
		 115399, -- Black Ox Brew (Brewmaster talent)
		 116844, -- Ring of Peace (talent)
		 119582, -- Purifying Brew (Brewmaster)
		 119996, -- Transcendence: Transfer
		 122281, -- Healing Elixir (talent)
		 123986, -- Chi Burst (talent)
		 126892, -- Zen Pilgrimage
		 152175, -- Whirling Dragon Punch (Windwalker talent)
		 202370, -- Mighty Ox Kick (Brewmaster pvp talent)
		 205234, -- Healing Sphere (Mistweaver pvp talent)
		 261947, -- Fist of the White Tiger (Windwalker talent)
		 322101, -- Expel Harm
		 322109, -- Touch of Death (Brewmaster/Windwalker)
		 322118, -- Invoke Yu'lon, the Jade Serpent (Mistweaver)
		 325197, -- Invoke Chi-Ji, the Red Crane (Mistweaver talent)
		[116705] = 'INTERRUPT', -- Spear Hand Strike (Brewmaster/Windwalker)
		[123904] = 'BURST', -- Invoke Xuen, the White Tiger (Windwalker)
		AURA = {
			HARMFUL = {
				115804, -- Mortal Wounds (Windwalker)
				117952, -- Crackling Jade Lightning
				122470, -- Touch of Karma (Windwalker)
				123725, -- Breath of Fire (Brewmaster)
				124280, -- Touch of Karma (Windwalker) (DoT)
				206891, -- Focused Assault (Brewmaster pvp talent)
				228287, -- Mark of the Crane (Windwalker)
				233759, -- Grapple Weapon (Windwalker pvp talent)
				CROWD_CTRL = {
					DISORIENT = {
						198909, -- Song of Chi-Ji (Mistweaver talent)
						202274, -- Incendiary Brew (Brewmaster pvp talent)
					},
					INCAPACITATE = {
						115078, -- Paralysis
					},
					ROOT = {
						116706, -- Disable (Windwalker)
						324382, -- Clash (Brewmaster)
					},
					STUN = {
						119381, -- Leg Sweep
						202346, -- Double Barrel (Brewmaster pvp talent)
					},
					TAUNT = {
						116189, -- Provoke
					},
				},
				SNARE = {
					116095, -- Disable (Windwalker)
					121253, -- Keg Smash (Brewmaster)
					123586, -- Flying Serpent Kick (Windwalker)
					201787, -- Heavy-Handed Strikes (Windwalker pvp talent)
				},
			},
			HELPFUL = {
				116841, -- Tiger's Lust (talent)
				119611, -- Renewing Mist (Mistweaver)
				191840, -- Essence Font (Mistweaver)
				201447, -- Ride the Wind (Windwalker pvp talent)
				202162, -- Avert Harm (Brewmaster pvp talent)
				325153, -- Exploding Keg (Brewmaster talent)
				353319, -- Peaceweaver (Mistweaver pvp talent)
				354540, -- Nimble Brew (Brewmaster pvp talent)
				SURVIVAL = {
					116849, -- Life Cocoon (Mistweaver)
				},
			},
			PERSONAL = {
				101643, -- Transcendence
				116680, -- Thunder Focus Tea (Mistweaver)
				116847, -- Rushing Jade Wind (Brewmaster talent)
				119085, -- Chi Torpedo (Brewmaster talent)
				132578, -- Invoke Niuzao, the Black Ox (Brewmaster)
				195630, -- Elusive Brawler (Brewmaster)
				196725, -- Refreshing Jade Wind (Mistweaver talent)
				197908, -- Mana Tea (Mistweaver talent)
				202248, -- Guided Meditation (Brewmaster pvp talent)
				202335, -- Double Barrel (Brewmaster pvp talent)
				209584, -- Zen Focus Tea (Mistweaver pvp talent)
				215479, -- Shuffle (Brewmaster)
				228563, -- Blackout Combo (Brewmaster talent)
				343820, -- Invoke Chi-Ji, the Red Crane (Mistweaver talent)
				BURST = {
					137639, -- Storm, Earth, and Fire (Windwalker)
					152173, -- Serenity (Windwalker talent)
					344361, -- Touch of Death (Mistweaver)
				},
				POWER_REGEN = {
					115288, -- Energizing Elixir (Windwalker talent)
				},
				SURVIVAL = {
					115176, -- Zen Meditation (Brewmaster)
					115203, -- Fortifying Brew (Brewmaster)
					122278, -- Dampen Harm (talent)
					122783, -- Diffuse Magic (Mistweaver talent/Windwalker talent)
					125174, -- Touch of Karma (Windwalker)
					243435, -- Fortifying Brew (Mistweaver/Windwalker)
					322507, -- Celestial Brew (Brewmaster)
					325092, -- Purified Chi (Brewmaster)
				},
			},
		},
		DISPEL = {
			HELPFUL = {
				[115310] = 'DISEASE MAGIC POISON', -- Revival (Mistweaver)
				[115450] = 'DISEASE MAGIC POISON', -- Detox (Mistweaver)
				[218164] = 'DISEASE POISON', -- Detox (Brewmaster/Windwalker)
			},
		}
	},
	AURA = {
		HARMFUL = {
			196608, -- Eye of the Tiger (Brewmaster talent/Windwalker talent)
		},
		HELPFUL = {
			115175, -- Soothing Mist (Mistweaver)
			124682, -- Enveloping Mist (Mistweaver)
			205655, -- Dome of Mist (Mistweaver pvp talent)
			353503, -- Counteract Magic (Mistweaver pvp talent)
			353509, -- Refreshing Breeze (Mistweaver pvp talent)
		},
		PERSONAL = {
			116768, -- Blackout Kick! (Windwalker)
			125883, -- Zen Flight
			196608, -- Eye of the Tiger (Brewmaster talent)
			197916, -- Lifecycles (Vivify) (Mistweaver talent)
			197919, -- Lifecycles (Enveloping Mists)
			202090, -- Teachings of the Monastery (Mistweaver)
			247483, -- Tigereye Brew (Windwalker pvp talent)
			248646, -- Tigereye Brew (Windwalker pvp talent) (stacks)
			261769, -- Inner Strength (Windwalker talent)
			287504, -- Alpha Tiger (Windwalker pvp talent)
			325202, -- Dance of Chi'Ji (Windwalker talent)
			355940, -- Rodeo (Brewmaster pvp talent)
		},
	},
}, {
	-- map aura to provider(s)
	[115804] = 107428, -- Mortal Wounds <- Rising Sun Kick (Windwalker)
	[116189] = 115546, -- Provoke
	[116680] = 116680, -- Thunder Focus Tea (Mistweaver)
	[116706] = 343731, -- Disable <- Disable Rank 2 (Windwalker)
	[116768] = 100780, -- Blackout Kick! <- Tiger Palm (Windwalker)
	[119085] = 115008, -- Chi Torpedo (Brewmaster talent)
	[119611] = 115151, -- Renewing Mist (Windwalker)
	[123586] = 101545, -- Flying Serpent Kick (Windwalker)
	[123725] = 115181, -- Breath of Fire (Brewmaster)
	[124280] = 122470, -- Touch of Karma (Windwalker) (DoT)
	[125174] = 122470, -- Touch of Karma (Windwalker)
	[137639] = 221771, -- Storm, Earth, and Fire <- Storm, Earth, and Fire: Fixate (Windwalker)
	[191840] = 191837, -- Essence Font (Mistweaver)
	[195630] = 117906, -- Elusive Brawler <- Mastery: Elusive Brawler (Brewmaster)
	[196608] = 196607, -- Eye of the Tiger (Brewmaster talent)
	[197916] = 197915, -- Lifecycles (Vivify) <- Lifecycles (Mistweaver talent)
	[197919] = 197915, -- Lifecycles (Enveloping Mists) <- Lifecycles (Mistweaver talent)
	[198909] = 198898, -- Song of Chi-Ji (Mistweaver talent)
	[201447] = 201372, -- Ride the Wind (Windwalker pvp talent)
	[201787] = 287681, -- Heavy-Handed Strikes (Windwalker pvp talent)
	[202090] = 116645, -- Teachings of the Monastery (Mistweaver)
	[202248] = 202220, -- Guided Meditation (Brewmaster pvp talent)
	[202274] = 202272, -- Incendiary Brew (Brewmaster pvp talent)
	[202346] = 202335, -- Double Barrel (Brewmaster pvp talent)
	[205655] = 202577, -- Dome of Mist (Mistweaver pvp talent)
	[206891] = 207025, -- Focused Assault (Brewmaster pvp talent) -> Admonishment
	[215479] = 322120, -- Shuffle (Brewmaster passive)
	[228287] = 343730, -- Mark of the Crane <- Spinning Crane Kick Rank 2 (Windwalker)
	[228563] = 196736, -- Blackout Combo (Brewmaster talent)
	[248646] = 247483, -- Tigereye Brew (Windwalker pvp talent)
	[261769] = 261767, -- Inner Strength (Windwalker talent)
	[287504] = 287503, -- Alpha Tiger (Windwalker pvp talent)
	[324382] = 324312, -- Clash (Brewmaster)
	[325092] = 322510, -- Purified Chi <- Celestial Brew Rank 2 (Brewmaster)
	[325202] = 325201, -- Dance of Chi'Ji (Windwalker talent)
	[343820] = 325197, -- Invoke Chi-Ji, the Red Crane (Mistweaver talent)
	[344361] = 344360, -- Touch of Death Rank 3 (Mistweaver)
	[353319] = 353313, -- Peaceweaver (Mistweaver pvp talent)
	[353503] = 353502, -- Counteract Magic (Mistweaver pvp talent)
	[353509] = 353508, -- Refreshing Breeze (Mistweaver pvp talent)
	[355940] = 355917, -- Rodeo (Brewmaster pvp talent)
}, {
	-- map aura to modified spell(s)
	[116680] = { -- Thunder Focus Tea (Mistweaver)
		107428, -- Rising Sun Kick
		115151, -- Renewing Mist
		116670, -- Vivify
		124682, -- Enveloping Mist
	},
	[116706] = 116095, -- Disable (Windwalker)
	[116768] = 100784, -- Blackout Kick! -> Blackout Kick (Windwalker)
	[195630] = 225523, -- Elusive Brawler -> Blackout Kick (Brewmaster)
	[196608] = 100780, -- Eye of the Tiger (Brewmaster talent) -> Tiger Palm
	[197916] = 116670, -- Lifecycles (Vivify) (Mistweaver talent) -> Vivify
	[197919] = 124682, -- Lifecycles (Enveloping Mists) -> Enveloping Mists
	[201447] = 101545, -- Ride the Wind (Windwalker pvp talent) -> Flying Serpent Kick
	[201787] = 113656, -- Heavy-Handed Strikes (Windwalker pvp talent) -> Fists of Fury
	[202090] = 100784, -- Teachings of the Monastery -> Blackout Kick (Mistweaver)
	[202248] = 115176, -- Guided Meditation (Brewmaster pvp talent) -> Zen Meditation
	[202274] = 115181, -- Incendiary Brew (Brewmaster pvp talent) -> Breath of Fire
	[205655] = 124682, -- Dome of Mist (Mistweaver pvp talent)
	[215479] = { -- Shuffle (Brewmaster)
		121253, -- Keg Smash
		205523, -- Blackout Kick
		322729, -- Spinning Crane Kick
	},
	[228287] = 101546, -- Mark of the Crane -> Spinning Crane Kick (Windwalker)
	[228563] = { -- Blackout Combo (Brewmaster talent)
		100780, -- Tiger Palm
		115181, -- Breath of Fire
		121253, -- Keg Smash
		322507, -- Celestial Brew
	},
	[261769] = { -- Inner Strength (Windwalker talent)
		100784, -- Blackout Kick
		107428, -- Rising Sun Kick
		113656, -- Firsts of Fury
		116847, -- Rushing Jade Wind
	},
	[287504] = 100780, -- Alpha Tiger (Windwalker pvp talent) -> Tiger Palm
	[325202] = 101546, -- Dance of Chi'Ji (Windwalker talent) -> Spinning Crane Kick
	[325092] = 322507, -- Purified Chi -> Celestial Brew (Brewmaster)
	[344361] = 322109, -- Touch of Death (Mistweaver)
	[343820] = 124682, -- Invoke Chi-Ji, the Red Crane (Mistweaver talent) -> Enveloping Mist
	[353319] = 115310, -- Peaceweaver (Mistweaver pvp talent) -> Revival
	[353509] = 322101, -- Refreshing Breeze (Mistweaver pvp talent) -> Expel Harm
	[355940] = { -- Rodeo (Brewmaster pvp talent)
		324312, -- Clash (normal one)
		355919, -- Clash (reactivatable)
	},
})
