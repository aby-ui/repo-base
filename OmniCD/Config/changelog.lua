local E, L, C = select(2, ...):unpack()

if E.isClassic then E.changelog = [=[

Previous changes can be found in the CHANGELOG file.
]=]
elseif E.isBCC then E.changelog = [=[
v2.7.15
	Feign Death will no longer grey-out the icons.
	Fixed an issue where logging back in would incorrectly grey-out the icons.
	Group inspection is now done periodically until the arena match begins.

Previous changes can be found in the CHANGELOG file.
]=]
else E.changelog = [=[
v2.7.17
	Added new option 'Show Range'.
	Added backup timers to remove Decrypted Urh Cypher, etc.
	Added Seasons of Plenty (Runeforge) CDRR.
	Added PitBull4 raid support,
	Fixed an issue where Purify Soul would not activate with certain soulbind abilities.
	Swiftmend will correctly show with Restoration Affinity.
	Fixed option panel borders for addons w/ ui scaling.
	Known Blizzard Bug:
		Equinox under the effect of Blessing of Autumn incorrectly increases the remaining CD of Guardian Spirit w/ Guardian Angel.

v2.7.16
	Dancing Rune Weapon CDR fixed.
	Observer cooldowns will no longer be tracked in the MDI setting.
	Lib updates.

v2.7.15
	Blizzard Hotfixes
		APRIL 26, 2022
			Holy Priest
				Divine Conversation (2-set bonus) now increases the CDR by 10sec in PvP (was 15sec).
				Miracle Worker (PvP Talent) now reduces the cooldown of Holy Word: Serenity by 10% (was 20%).

v2.7.14
	Updated missing changes from patch 9.0.5 :0
	Crimson Rune Weapon (DK, Runeforge) cooldown reduction increased to 5 seconds (was 3s).
	Qa’pla, Eredun War Order (Hunter, Runeforge) now resets the cooldown of Kill Command (was reduces the cooldown by 5 seconds).
	Divine Vision (Paladin, PvP Talent) now reduces the cooldown of Aura Mastery by 1 minute (was grants Shadow Resistance Aura).
	Duskwalker’s Patch (Rogue, Runeforge) reduces Vendetta’s cooldown for every 30 Energy you expend (was 50 Energy).
	Amplify Curse (Warlock, PvP Talent) cooldown reduced to 30 seconds (was 45 seconds).

v2.7.13
	Fixed an issue where sync could incorrectly reset the CD.
	Bwonsamdi's Pact has been added back in for non-synced units. (doesn't support multiple buffs per target)
	Crafted Unity Legendaries added.

Previous changes can be found in the CHANGELOG file.
]=]
end
