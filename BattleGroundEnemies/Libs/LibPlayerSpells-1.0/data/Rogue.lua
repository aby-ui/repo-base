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
lib:__RegisterSpells('ROGUE', 90200, 1, {
	COOLDOWN = {
		   1725, -- Distract
		 195457, -- Grappling Hook (Outlaw)
		 200806, -- Exsanguinate (Assassination talent)
		 280719, -- Secret Technique (Subtlety talent)
		[  1766] = 'INTERRUPT', -- Kick
		AURA = {
			HARMFUL = {
				    703, -- Garrote (Assassination)
				   1330, -- Garrote - Silence (Assassination)
				 154953, -- Internal Bleeding (Assassination talent)
				 196937, -- Ghostly Strike (Outlaw talent)
				 207777, -- Dismantle (pvp talent)
				 245389, -- Toxic Blade (Assassination talent)
				 255909, -- Prey on the Weak (talent)
				 207736, -- Shadowy Duel (Subtlety pvp talent)
				 315341, -- Between the Eyes (Outlaw)
				 319504, -- Shiv (Assassination)
				[354812] = 'SNARE', -- Distracting Mirage: Slow (Subtlety pvp talent)
				BURST = {
					 79140, -- Vendetta (Assassination)
					137619, -- Marked for Death (talent)
				},
				CROWD_CTRL = {
					[ 408] = 'STUN', -- Kidney Shot
					[1776] = 'INCAPACITATE', -- Gouge (Outlaw)
					[2094] = 'DISORIENT', -- Blind
				},
			},
			HELPFUL = {
				  57934, -- Tricks of the Trade
				 354494, -- Crimson Vial (Outlaw pvp talent)
				[212183] = 'INVERT_AURA', -- Smoke Bomb (pvp talent)
				[221630] = 'BURST', -- Tricks of the Trade (pvp talent)
			},
			PERSONAL = {
				   2983, -- Sprint
				  11327, -- Vanish
				  13877, -- Blade Flurry (Outlaw)
				  36554, -- Shadowstep (Assassination/Subtlety)
				  51690, -- Killing Spree (Outlaw talent)
				 114018, -- Shroud of Concealment
				 185422, -- Shadow Dance (Subtlety)
				 197003, -- Maneuverability (pvp talent)
				 256171, -- Loaded Dice (Outlaw talent)
				 269513, -- Death from Above (pvp talent)
				 271896, -- Blade Rush (Outlaw talent)
				 277925, -- Shuriken Tornado (Subtlety talent)
				[196980] = 'POWER_REGEN', -- Master of Shadows (Subtlety talent)
				BURST = {
					  13750, -- Adrenalin Rush (Outlaw)
					 121471, -- Shadow Blades (Subtlety)
					[212283] = 'POWER_REGEN', -- Symbols of Death (Subtlety)
				},
				SURVIVAL = {
					  1966, -- Feint
					  5277, -- Evasion
					 31224, -- Cloak of Shadows
					185311, -- Crimson Vial
				},
			},
		},
		DISPEL = {
			[5938] = 'HARMFUL ENRAGE', -- Shiv
		},
	},
	AURA = {
		HARMFUL = {
			  1943, -- Rupture (Assassination/Subtlety)
			  2818, -- Deadly Poison (Assassination)
			  5760, -- Numbling Poison
			  8680, -- Wound Poison
			121411, -- Crimson Tempest (Assassination talent)
			198688, -- Dagger in the Dark (Subtlety pvp talent)
			256148, -- Iron Wire (Assassination talent)
			316220, -- Find Weakness (Subtlety)
			354896, -- Creeping Venom (Assassination pvp talent)
			CROWD_CTRL = {
				[1833] = 'STUN', -- Cheap Shot
				[6770] = 'INCAPACITATE', -- Sap
			},
			SNARE = {
				  3409, -- Crippling Poison
				185763, -- Pistol Shot (Outlaw)
				198222, -- System Shock (Assassination pvp talent)
				206760, -- Shadow's Grasp (Subtlety talent)
			},
		},
		HELPFUL = {
			198368, -- Take Your Cut (Outlaw pvp talent)
			209754, -- Boarding Party (Outlaw pvp talent)
		},
		PERSONAL = {
			   1784, -- Stealth
			  32645, -- Envenom (Assassination)
			 115191, -- Stealth (with Subterfuge talent)
			 115192, -- Subterfuge (Assassination/Subtlety talent)
			 121153, -- Blindside (Assassination talent)
			 193356, -- Broadside (Outlaw)
			 193357, -- Ruthless Precision (Outlaw)
			 193358, -- Grand Melee (Outlaw)
			 193359, -- True Bearing (Outlaw)
			 193538, -- Alacrity (talent)
			 193641, -- Elaborate Planning (Assassination talent)
			 195627, -- Opportunity (Outlaw)
			 199027, -- Veil of Midnight (Subtlety pvp talent)
			 199600, -- Buried Treasure (Outlaw)
			 199603, -- Skull and Crossbones (Outlaw)
			 227151, -- Symbols of Death (Subtlety)
			 256735, -- Master Assassin (Assassination talent)
			 257506, -- Shot in the Dark (Subtlety talent)
			 270070, -- Hidden Blades (Assassination talent)
			 315496, -- Slice and Dice
			 354827, -- Thief's Bargain (Subtlety pvp talent)
			 354847, -- Enduring Brawler (Outlaw pvp talent)
			[343142] = 'INVERT_AURA', -- Dreadblades (Outlaw talent)
		},
	},
}, {
	-- map aura to provider(s)
	[  1330] =    703, -- Garrote - Silence <- Garrote (Assassination)
	[  2818] =   2823, -- Deadly Poison (Assassination)
	[  3409] =   3408, -- Crippling Poison
	[  5760] =   5761, -- Numbling Poison
	[  8680] =   8679, -- Wound Poison
	[ 11327] =   1856, -- Vanish
	[115191] = 108208, -- Subterfuge (Assassination/Subtlety talent)
	[115192] = 108208, -- Subterfuge (Assassination/Subtlety talent)
	[121153] = 328085, -- Blindside (Assassination talent)
	[154953] = 154904, -- Internal Bleeding (Assassination)
	[185422] = 185313, -- Shadow Dance (Subtlety)
	[193356] = 315508, -- Broadside <- Roll the Bones (Outlaw)
	[193357] = 315508, -- Ruthless Precision <- Roll the Bones (Outlaw)
	[193358] = 315508, -- Grand Melee <- Roll the Bones (Outlaw)
	[193359] = 315508, -- True Bearing <- Roll the Bones (Outlaw)
	[193538] = 193539, -- Alacrity (talent)
	[193641] = 193640, -- Elaborate Planning (Assassination talent)
	[195627] = 193315, -- Opportunity <- Sinister Strike (Outlaw)
	[196980] = 196976, -- Master of Shadows (Subtlety talent)
	[197003] = 197000, -- Maneuverability (pvp talent)
	[198222] = 198145, -- System Shock (Assassination pvp talent)
	[198368] = 198265, -- Take Your Cut (Outlaw pvp talent)
	[198688] = 198675, -- Dagger in the Dark (Subtlety pvp talent)
	[199027] = 198952, -- Veil of Midnight (Subtlety pvp talent)
	[199600] = 315508, -- Buried Treasure <- Roll the Bones (Outlaw)
	[199603] = 315508, -- Skull and Crossbones <- Roll the Bones (Outlaw)
	[206760] = 277953, -- Shadow's Grasp (Subtlety talent)
	[209754] = 209752, -- Boarding Party (Outlaw pvp talent)
	[212183] = 212182, -- Smoke Bomb (pvp talent)
	[213995] = 212035, -- Cheap Tricks (Outlaw pvp talent)
	[221630] = 221622, -- Tricks of the Trade <- Thick as Thieves (pvp talent)
	[227151] = 212283, -- Symbols of Death (Subtlety)
	[245389] = 245388, -- Toxic Blade (Assassination talent)
	[255909] = 131511, -- Prey on the Weak (talent)
	[256148] = 196861, -- Iron Wire (Assassination talent)
	[256171] = 256170, -- Loaded Dice (Outlaw talent)
	[256735] = 255989, -- Master Assassin (Assassination talent)
	[257506] = 257505, -- Shot in the Dark (Subtlety talent)
	[270070] = 270061, -- Hidden Blades (Assassination talent)
	[271896] = 271877, -- Blade Rush (Outlaw talent)
	[316220] = 316219, -- Find Weakness (Subtlety talent)
	[319504] =   5938, -- Shiv (Assassination)
	[354494] = 354425, -- Crimson Vial <- Drink Up Me Hearties (Outlaw pvp talent)
	[354812] = 354661, -- Distracting Mirage: Slow (Subtlety pvp talent)
	[354827] = 354825, -- Thief's Bargain (Subtlety pvp talent)
	[354847] = 354843, -- Enduring Brawler (Outlaw pvp talent)
	[354896] = 354895, -- Creeping Venom (Assasination pvp talent)
}, {
	-- map aura to modified spell(s)
	[115192] = 115191, -- Subterfuge (Assassination/Subtlety talent) -> Stealth
	[121153] =   8676, -- Blindside (Assassination talent) -> Ambush
	[154953] =    408, -- Internal Bleeding (Assassination) -> Kidney Shot
	[193538] = { -- Alacrity
		   408, -- Kidney Shot
		  2098, -- Dispatch (Outlaw)
		196819, -- Eviscerate (Subtlety)
		315341, -- Between the Eyes (Outlaw)
		319175, -- Black Powder (Subtlety)
	},
	[193641] = { -- Elaborate Planning (Assassination talent)
		   408, -- Kidney Shot
		  1943, -- Rupture
		 32645, -- Envenom
		121411, -- Crimson Tempest (Assassination talent)
		315496, -- Slice and Dice
	},
	[195627] = 185763, -- Opportunity -> Pistol Shot (Outlaw)
	[196980] = { -- Master of Shadows (Subtlety talent)
		  1784, -- Stealth
		115191, -- Stealth (with Subterfuge talent)
		185313, -- Shadow Dance
	},
	[197003] =   2983, -- Maneuverability (pvp talent) -> Sprint
	[198222] =  32645, -- System Shock (Assassination pvp talent) -> Envenom
	[198368] = 315508, -- Take Your Cut (Outlaw pvp talent) -> Roll the Bones
	[198688] = 185438, -- Dagger in the Dark (Subtlety pvp talent) -> Shadowstrike
	[199027] = { -- Veil of Midnight (Subtlety pvp talent)
		  1784, -- Stealth
		  1856, -- Vanish
		115191, -- Stealth (with Subterfuge talent)
	},
	[206760] = 197835, -- Shadow's Grasp (Subtlety talent) -> Shuriken Storm
	[209754] = 315341, -- Boarding Party (Outlaw pvp talent) -> Between the Eyes
	[213995] = 315341, -- Cheap Tricks (Outlaw pvp talent) -> Between the Eyes
	[221630] =  57934, -- Tricks of the Trade (pvp talent)
	[227151] = { -- Symbols of Death (Subtlety)
		    53, -- Backstab
		  5938, -- Shiv
		114014, -- Shuriken Toss
		185438, -- Shadowstrike
		197835, -- Shuriken Storm
		200758, -- Gloomblade
	},
	[255909] = { -- Prey on the Weak (talent)
		   408, -- Kidney Shot
		  1833, -- Cheap Shot
	},
	[256148] =    703, -- Iron Wire (Assassination talent) -> Garrote
	[256171] = 315508, -- Loaded Dice (Outlaw talent) -> Roll the Bones
	[256735] =   1784, -- Master Assassin (Assassination talent) -> Stealth
	[257506] =   1833, -- Shot in the Dark (Subtlety talent) -> Cheap Shot
	[270070] =  51723, -- Hidden Blades (Assassination talent) -> Fan of Knives
	[316220] = { -- Find Weakness (Subtlety)
		    53, -- Backstab
		  1833, -- Cheap Shot
		185438, -- Shadowstrike
		197835, -- Shuriken Storm
		200758, -- Gloomblade
	},
	[354494] = 185311, -- Crimson Vial (Outlaw pvp talent) -> Crimson Vial
	[354812] = 354674,-- Distracting Mirage: Slow (Subtlety pvp talent) -> Distracting Mirage: Teleport
	[354827] = { -- Thief's Bargain (Subtlety pvp talent)
		  1856, -- Vanish
		  1966, -- Feint
		121471, -- Shadow Blades
	},
	[354847] = 193315, -- Enduring Brawler (Outlaw pvp talent) -> Sinister Strike
	[354896] =  32645, -- Creeping Venom (Assassination pvp talent) -> Envenom
})
