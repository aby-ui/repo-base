local E, L, C = select(2, ...):unpack()

if E.isClassic then E.changelog = [=[
v2.7.00
	toc update - 11402

v2.6.35
	CTRL-clicking the spell in the 'Spells/RaidCD' tab will add it to the 'Spell Editor'.
	Warlock Soulstone CD added.
	Tooltip borders fixed.

v2.6.30
	Initial release for WoW: Classic Era.
]=]
elseif E.isBCC then E.changelog = [=[
v2.7.11
	Bumped toc for 2.5.4

v2.6.36
	nil error fix

Pre v2.6.36 changes can be found in the CHANGELOG file
]=]
else E.changelog = [=[
v2.7.11
	Fixed lua error w/ tullaCC
	Shadowlands trinkets have been added back in

v2.7.10
	Feature Updates
		Removed Bwonsamdi's Pact (Priest, Runeforge). Affected major CDs are now directly synced.
		Progress bar's animation/counter rate will follow it's CD recovery rate.
		Show Player in Extra Bars option was removed and is now always enabled.
	Bug Fixes
		Emerald Slumber (Guardian Druid, PvP Talent) will no longer incorrectly affect group members.
		Tricks of the Trade w/ Thick as Thieves (PvP Talent) will correctly go on CD after being activated.
		Fixed an issue where reducing a CD would fail to update the progress bar counter text.
		Fixed Shaman legendaries: Witch Doctor's Wolf Bones, Skybreaker's Fiery Demise, Seeds of Rampant Growth.
	Blizzard Hotfixes
		APRIL 4, 2022
			Priest
				Holy
					Holy Ward’s (PvP Talent) cooldown increased to 45 seconds (was 30 seconds).

v2.7.01
	Encrypted event fix - Decrypted Urh Cypher CDRR

v2.7.00
	TL;DR
		Spells with cooldown reduction that can't be detected are now directly synced with other users.
		Fixed an issue where using an ability would incorrectly put the same ability for another unit on cooldown. <iss#322>
		* AddOn will no longer communicate with earlier versions.


	Revised Sync Mode
		Spells with cooldown reduction that can't be detected are now directly synced with other users.
		Synced Spell : Prerequisite
			DK
				Death Grip: Death's Reach (talent)
				Death and Decay/Defile/Death Due): Crimson Scourge (passive)
			DH
				Eye Beam, Fel Devastation: Darkglare Boon (runeforge)
				Immolation Aura, Fel Devastation: Rapacious Hunger (set bonus)
				All Sigils & Elysian Decree: Razelikh's Defilement (runeforge)
				Felblade: passive
			Druid
				Berserk/Incarnation: Heart of the Lion (Feral set bonus)
			Hunter
				Rapid Fire: Lethal Shots (talent)
				Barbed Shot: Wild Call (passive)
				Wildfire Bomb: Carve passive, Rylakstalker's Confounding Strikes (runeforge), Mad bombardier (set bonus)
				Harpoon: Terms of Engagement (talent)
			Monk
				Invoke Xuen, the White Tiger: Xuen's Bond (conduit)
				Purifying Brew: Mighty Pour (runeforge)
				Rising Sun Kick: Teachings of the Monastery (passive)
				All Brews: Shaohao's Might (runeforge)
				Roll/Chi Torpedo: Tumbling Technique (conduit)
			Paladin
				Avenging Wrath/Avenging Crusader: Dawn Will Come (Holy set bonus)
				Wake of Ashes: Ashes to Ashes (Ret set bonus)
				Avenger's Shield: Grand Crusader (passive), Holy Avenger's Engraved Sigil (runeforge)
			Shaman
				Primordial Wave: Tumbling Waves (conduit)
				Fire/Storm Elemental: Fire Heart (Ele set bonus)
				All Totems: Heal the Soul (Resto set bonus)
			Warlock
				Summon Darkglaire: Corrupting Leer (conduit)
			Warrior
				Recklessness, Enraged Regeneration: Reckless Defense (runeforge)
			Covenant Sig
				Purify Soul: Focusing Mantra (soulbind)
				Fleshcraft: Resourceful Fleshcrafting (soulbind), passive
				Soulshape: Stay on the Move (soulbind)
			Spells affected by power/resource spenders (previous sync mode)

			In raid instances, only the following spells are synced:
				Fortifying Brew, Avenging Wrath, Ashen Hallow, Spirit Link/Healing Tide/Tremor/Wind Rush Totem.
		* AddOn will no longer communicate with earlier versions.
	Main hand on-use abilites can be added as 'Trinket & Main Hand'.
	Spells
		Added Cosmic Gladiator's Echoing Resolve. (display only)
	CD Modifiers
		Added cooldown rate modulation by Decrypted Urh Cypher (Seasonal affix). - not tested
		Added cooldown rate modulation by Architect's Ingenuity core (Trinket).
	Bug Fixes
		Fixed an issue where using an ability would incorrectly put another unit with the same ability on cooldown. <iss#322>
		Phial of Serenity will correctly go on cooldown with Forgelite Filter (soulbind ability).
		Fixed Sinister Teachings' CDR (runeforge) to Fallen Order for Mistweaver Monks.
		Anger Management will no longer incorrectly be applied under the effect of Deadly Calm.
		Black Ox Brew will correctly reset Purifying Brew.
		Keg smash & Tiger palm will correctly reduce Black Ox Brew's CD.
		Haunted Mask (Bwonsamdi's Pact, runeforge) will correctly affect Benevolent Faerie's initial target only.
		Emerald Slumber will no longer incorrectly increase it's own cooldown recovery rate.
		Door of Shadows' cooldown recovery rate will be modulated by Intimidation Tactics only.

	Blizzard Hotfixes
		MARCH 14, 2022
			Mage
				Fire
					Pyrokinesis (PvP Talent) now causes Fireball to reduce the cooldown of Combustion by 2 seconds (was 3 seconds).
		MARCH 7, 2022
			Druid
				Feral
					(2) Set Bonus: Berserk’s cooldown is now reduced by 0.7 seconds per combo point spent (was 0.5 seconds).

v2.6.40
	toc update 90200
	Additional PvP trinkets added

Pre v2.6.40 changes can be found in the CHANGELOG file
]=]
end
