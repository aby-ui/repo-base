local E, L, C = select(2, ...):unpack()

if E.isClassic then E.changelog = [=[
v2.6.30
	Initial release for WoW: Classic Era.
]=]
elseif E.isBCC then E.changelog = [=[
v2.6.30
	Feature Updates
		All supported UIs can now display individual unit CD bars in a raid.
		CD bars are now grayed out for offline/dead units.
		Interrupt bar - added option to display interrupted spell icon and target marker. <req#283>
		Highlighting - all self casted spell types can be highlighted.
		Compatibility updates for WoW: Classic Era.
		Compatibility updates for WoW: 9.1.5 PTR.
	Bug Fixes
		Reincarnation will correctly go on CD when used. (Temp fix)
		Stealth, Prowl, Shadowmeld will correctly go on CD when the effect ends instead of on cast.
		Talent changes will now update for synced units.
		Fixed Triple row/col layout and recharge color switching on reset. <iss#284>
		GW2_UI fixed for 5.18.X. <req#286>
	AltzUI support. <req#291>

Pre v2.6.30 changes can be found in the CHANGELOG file
]=]
else E.changelog = [=[
v2.6.34
	Fixed cooldown reduction with synced units.

v2.6.33
	Fixed cooldowns not resetting at the start of Mythic+.

v2.6.32
	Battle Res module removed d/t issues. This will no longer be integrated and be available as an external plugin only.
	Prevent ACCESS_VIOLATION error.

v2.6.31
	Fixed nil error <iss#294>

v2.6.30
	Feature Updates
		Battle Res module.
		All supported UIs can now display individual unit CD bars in a raid.
		CD bars are now grayed out for offline/dead units.
		Interrupt bar - added option to display interrupted spell icon and target marker. <req#283>
		Highlighting - all spell-types can be highlighted.
		Compatibility updates for WoW: Classic Era.
		Compatibility updates for WoW: 9.1.5 PTR.
	Spells & CD Modifiers
		Podtender (Night Fae Soulbind) added.
		Pressure Points (PvP Talent) - Killing a player with Touch of Death reduces the remaining cooldown of Touch of Karma by 60 sec.
		Death and Madness - If a target dies within 7 sec after being struck by your Shadow Word: Death, the cooldown is reset.
		A murder of Crows - If the target dies while under attack, A Murder of Crows' cooldown is reset.
		Shadowburn - Refunds a charge if the target dies within 5 sec.
		Serrated Bone Spike (Rogue Covenant) - Refunds a charge when target dies.
	Bug Fixes
		Intimidation Tactics (Venthyr Soulbind) will correctly increase the CD recovery rate of Door of Shadows by 200% while below 50% health.
		Seeds of Rampant Growth (Runeforge) will reduce the cooldown of Fae Transfusion on each pulse instead of damage.
		Obedience will reduce the cooldown of Flagellation while it's active instead of it's haste buff.
		Sinister Teachings will reduce the cooldown of Fallen Order from critical heals.
		Fixed Flagellation's CD to 1.5 min.
		Fixed Adaptation not applying shared CD on racial abilities when Adaptation isn't being tracked.
		Fire Blast CD for Frost and Arcane Mages are correctly affected by haste.
		Fixed Runeforge-Legendaries on certain slots.
		Fixed Condemn (Warrior Covenant) spell ID.
		Fixed CD recovery rate being lowered when an increased rate wasn't applied in certain situations.
		Covenant detection will no longer be delayed for units that are still pending inspection.
		Fixed Triple row/col layout and recharge color switching on reset. <iss#284>
		GW2_UI fixed for 5.18.X. <req#286>
	AltzUI support. <req#291>

Pre v2.6.30 changes can be found in the CHANGELOG file
]=]
end
