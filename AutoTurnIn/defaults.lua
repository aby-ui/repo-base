local addonName, privateTable = ...

privateTable.defaults = {
	interface10 = select(4, GetBuildInfo()) >= 100000,
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
	covenantswapgossipcompletion = false,
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
        ["107486"] = "Chatty Rumormonger in Courtofstars",
        ["147297"] = "Zekhan",
        ["146012"] = "Zekhan",
        ["143555"] = "����ʼ�",
        ["154002"] = "������԰", --����Ҫ�ϼ�ʲô��
        ["162804"] = "������",  --ǿ�ƽ�800ڤ��
	},
	WANTED_NPC = {
		["167881"] = "Ta'lan the Antiquary",
		["167880"] = "Finder Ta'sul",
		["158653"] = "Prince Renethal",
	},
	WANTED_QUESTS = {
		["6942"] = "Frostwolf Soldier's Medal",
		["6943"] = "Frostwolf Commander's Medal",
		["6941"] = "Frostwolf Lieutenant's Medal",
	}
}

