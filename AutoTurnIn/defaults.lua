local addonName, privateTable = ...

privateTable.defaults = {
	enabled = false, 
	all = 1, 
	trivial = false, 
	completeonly = false,
    lootreward = 1, 
	tournament = 2,
	darkmoonteleport = true, 
	todarkmoon = true, 
	darkmoonautostart = true, 
	showrewardtext = true,
	version = GetAddOnMetadata(addonName, "Version"), 
	autoequip = false, 
	togglekey = 4, 
	debug = false,
	questlevel = true, 
	watchlevel = true, 
	questshare = false,
	acceptshare=false,
	armor = {}, 
	weapon = {}, 
	stat = {}, 
	secondary = {},
	relictoggle = true, 
	artifactpowertoggle = true, 
	reviveBattlePet = false,
	IGNORED_NPC = {
		["87391"] = "fate-twister-seress",
		["88570"] = "Fate-Twister Tiklal",
		["111243"] = "Archmage Lan'dalock",
		["15077"] = "Riggle Bassbait",
		["119388"] = "Chieftain Hatuun",
		["127037"] = "Nabiru",
		["142063"] = "Tezran",
		["141584"] = "Zurvan", --seals of fate 
		["111243"] = "Archmage Lan'dalock", --seals of fate
	}
}

