local addonName, privateTable = ...
privateTable.interface10 = select(4, GetBuildInfo()) >= 100000
privateTable.defaults = {
	profile = {
		enabled = false,
		admin = false,
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
		watchlevel = false,
		questshare = false,
		acceptshare = false,
		armor = {},
		armorType = -1,
		weapon = {},
		stat = {},
		secondary = {},
		relictoggle = true,
		artifactpowertoggle = true,
		reviveBattlePet = false,
		covenantswapgossipcompletion = false,
		unsafe_item_wipe = false,
		sell_junk = 1,
		auto_repair = true,
		skip_cinematics = 1,
		skip_movies = 1,
		map_coords = false,
		IGNORED_NPC = {
			["87391"] = "fate-twister-seress",
			["88570"] = "Fate-Twister Tiklal",
			["15077"] = "Riggle Bassbait",
			["119388"] = "Chieftain Hatuun",
			["127037"] = "Nabiru",
			["142063"] = "Tezran",
			["141584"] = "Zurvan", --seals of fate 
			["111243"] = "Archmage Lan'dalock", --seals of fate
			["107486"] = "Chatty Rumormonger in Courtofstars",
			["147297"] = "Zekhan",
			["146012"] = "Zekhan",
			["143555"] = "部落笔记",
			["154002"] = "新生家园", --总是要合剂什么的
			["162804"] = "威娜莉",  --强制交800冥殇
			["193110"] = "卡丁", --专业知识点选择
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
}
