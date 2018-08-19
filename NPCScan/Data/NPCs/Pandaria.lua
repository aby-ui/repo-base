-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local NPCs = private.Data.NPCs

-- ----------------------------------------------------------------------------
-- Multiple zones
-- ----------------------------------------------------------------------------
NPCs[69768] = { -- Zandalari Warscout
	mounts = {
		{
			itemID = 94230, -- Reins of the Amber Primordial Direhorn
			spellID = 138424, -- Amber Primordial Direhorn
		},
	},
}

NPCs[69769] = { -- Zandalari Warbringer
	mounts = {
		{
			itemID = 94229, -- Reins of the Slate Primordial Direhorn
			spellID = 138425, -- Slate Primordial Direhorn
		},
	},
}

NPCs[69841] = { -- Zandalari Warbringer
	mounts = {
		{
			itemID = 94230, -- Reins of the Amber Primordial Direhorn
			spellID = 138424, -- Amber Primordial Direhorn
		},
	},
}

NPCs[69842] = { -- Zandalari Warbringer
	mounts = {
		{
			itemID = 94231, -- Reins of the Jade Primordial Direhorn
			spellID = 138426, -- Jade Primordial Direhorn
		},
	},
}

-- ----------------------------------------------------------------------------
-- Valley of the Four Winds
-- ----------------------------------------------------------------------------
NPCs[50783] = { -- Salyin Warscout
	toys = {
		{ itemID = 86583 }, -- Salyin Battle Banner
	},
}

NPCs[50828] = { -- Bonobos
	toys = {
		{ itemID = 86591 }, -- Magic Banana
	},
}

NPCs[51059] = { -- Blackhoof
	toys = {
		{ itemID = 86565 }, -- Battle Horn
	},
}

NPCs[62346] = { -- Galleon
	mounts = {
		{
			itemID = 89783, -- Son of Galleon's Saddle
			spellID = 130965, -- Son of Galleon
		},
	},
	questID = 32098, -- Short-Supply Reward
}

-- ----------------------------------------------------------------------------
-- Kun-Lai Summit
-- ----------------------------------------------------------------------------
NPCs[50354] = { -- Havak
	toys = {
		{ itemID = 86573 }, -- Shard of Archstone
	},
}

NPCs[50733] = { -- Ski'thik
	toys = {
		{ itemID = 86577 }, -- Rod of Ambershaping
	},
}

NPCs[50769] = { -- Zai the Outcast
	toys = {
		{ itemID = 86581 }, -- Farwater Conch
	},
}

NPCs[50789] = { -- Nessos the Oracle
	toys = {
		{ itemID = 86584 }, -- Hardened Shell
	},
}

NPCs[50817] = { -- Ahone the Wanderer
	toys = {
		{ itemID = 86588 }, -- Pandaren Firework Launcher
	},
}

NPCs[60491] = { -- Sha of Anger
	mounts = {
		{
			itemID = 87771, -- Reins of the Heavenly Onyx Cloud Serpent
			spellID = 127158, -- Heavenly Onyx Cloud Serpent
		},
	},
	questID = 32099, -- Short-Supply Reward
}

-- ----------------------------------------------------------------------------
-- Vale of Eternal Blossoms
-- ----------------------------------------------------------------------------
NPCs[50336] = { -- Yorik Sharpeye
	toys = {
		{ itemID = 86568 }, -- Mr. Smite's Brass Compass
	},
}

NPCs[50349] = { -- Kang the Soul Thief
	toys = {
		{ itemID = 86571 }, -- Kang's Bindstone
	},
}

NPCs[50359] = { -- Urgolax
	toys = {
		{ itemID = 86575 }, -- Chalice of Secrets
	},
}

NPCs[50749] = { -- Kal'tik the Blight
	toys = {
		{ itemID = 134023 }, -- Bottled Tornado
	},
}

NPCs[50780] = { -- Sahn Tidehunter
	toys = {
		{ itemID = 86582 }, -- Aqua Jewel
	},
}

NPCs[50806] = { -- Moldo One-Eye
	toys = {
		{ itemID = 86586 }, -- Panflute of Pandaria
	},
}

NPCs[50822] = { -- Ai-Ran the Shifting Cloud
	toys = {
		{ itemID = 86590 }, -- Essence of the Breeze
	},
}

NPCs[50840] = { -- Major Nanners
	toys = {
		{ itemID = 86594 }, -- Helpful Wikky's Whistle
	},
}

NPCs[50843] = { -- Portent
	isTameable = true,
}

NPCs[58474] = { -- Bloodtip
	isTameable = true,
}

NPCs[58768] = { -- Cracklefang
	isTameable = true,
}

NPCs[58771] = { -- Quid
	achievementSpellID = 129949, -- Quid Kill Credit
}

NPCs[58778] = { -- Aetha
	achievementSpellID = 129950, -- Aetha Kill Credit
}

NPCs[63509] = { -- Wulon
	isTameable = true,
}

NPCs[63510] = { -- Wulon
	isTameable = true,
}

NPCs[63978] = { -- Kri'chon
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Krasarang Wilds
-- ----------------------------------------------------------------------------
NPCs[68317] = { -- Mavis Harms
	factionGroup = "Alliance",
}

NPCs[68318] = { -- Dalan Nightbreaker
	factionGroup = "Alliance",
}

NPCs[68319] = { -- Disha Fearwarden
	factionGroup = "Alliance",
}

NPCs[68320] = { -- Ubunti the Shade
	factionGroup = "Horde",
}

NPCs[68321] = { -- Kar Warmaker
	factionGroup = "Horde",
}

NPCs[68322] = { -- Muerta
	factionGroup = "Horde",
}

-- ----------------------------------------------------------------------------
-- Dread Wastes
-- ----------------------------------------------------------------------------
NPCs[50347] = { -- Karr the Darkener
	pets = {
		{
			itemID = 86564, -- Imbued Jade Fragment
			npcID = 64634, -- Grinder
		},
	},
}

NPCs[50739] = { -- Gar'lok
	toys = {
		{ itemID = 86578 }, -- Eternal Warrior's Sigil
	},
}

NPCs[50776] = { -- Nalash Verdantis
	pets = {
		{
			itemID = 86563, -- Hollow Reed
			npcID = 64633, -- Aqua Strider
		},
	},
}

NPCs[50821] = { -- Ai-Li Skymirror
	toys = {
		{ itemID = 86589 },  -- Ai-Li's Skymirror
	},
}

NPCs[50836] = { -- Ik-Ik the Nimble
	toys = {
		{ itemID = 86593 }, -- Hozen Beach Ball
	},
}

-- ----------------------------------------------------------------------------
-- Isle of Thunder
-- ----------------------------------------------------------------------------
NPCs[50358] = { -- Haywire Sunreaver Construct
	pets = {
		{
			itemID = 94124, -- Sunreaver Micro-Sentry
			npcID = 69778, -- Sunreaver Micro-Sentry
		},
	},
}

NPCs[69099] = { -- Nalak
	mounts = {
		{
			itemID = 95057, -- Reins of the Thundering Cobalt Cloud Serpent
			spellID = 139442, -- Thundering Cobalt Cloud Serpent
		},
	},
	questID = 32518, -- Short-Supply Reward
}

NPCs[69998] = { -- Goda
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Isle of Giants
-- ----------------------------------------------------------------------------
NPCs[69161] = { -- Oondasta
	mounts = {
		{
			itemID = 94228, -- Reins of the Cobalt Primordial Direhorn
			spellID = 138423, -- Cobalt Primordial Direhorn
		},
	},
	questID = 32519, -- Short-Supply Reward
}

NPCs[70096] = { -- War-God Dokah
	pets = {
		{
			itemID = 94126, -- Zandalari Kneebiter
			npcID = 69796, -- Zandalari Kneebiter
		},
		{
			itemID = 95422, -- Zandalari Anklerender
			npcID = 70451, -- Zandalari Anklerender
		},
		{
			itemID = 95423, -- Zandalari Footslasher
			npcID = 70452, -- Zandalari Footslasher
		},
		{
			itemID = 95424, -- Zandalari Toenibbler
			npcID = 70453, -- Zandalari Toenibbler
		},
	},
}

-- ----------------------------------------------------------------------------
-- Timeless Isle
-- ----------------------------------------------------------------------------
NPCs[71919] = { -- Zhu-Gon the Sour
	pets = {
		{
			itemID = 104167, -- Skunky Alemental
			npcID = 73367, -- Skunky Alemental
		},
	},
	questID = 32959, -- Tracking Quest - Daily - Zhu-Gon the Sour/Skunky Beer
	vignetteID = 49, -- Really Skunky Beer
}

NPCs[72045] = { -- Chelon
	questID = 32966, -- Tracking Quest - Daily - Chelon
	toys = {
		{ itemID = 86584 }, -- Hardened Shell
	},
}

NPCs[72048] = { -- Rattleskew
	vignetteID = 61, -- Battle of the Barnacle
}

NPCs[72049] = { -- Cranegnasher
	questID = 32967, -- Tracking Quest - Daily - Cranegnasher
}

NPCs[72193] = { -- Karkanos
	questID = 33292, -- Tracking Quest - Daily - Karkanos
}

NPCs[72245] = { -- Zesqua
	questID = 33316, -- Tracking Quest - Daily - Zesqua
}

NPCs[72769] = { -- Spirit of Jadefire
	pets = {
		{
			itemID = 104307, -- Jadefire Spirit
			npcID = 73738, -- Jadefire Spirit
		},
	},
	questID = 33293, -- Tracking Quest - Daily - Spirit of Jadefire
}

NPCs[72775] = { -- Bufo
	pets = {
		{
			itemID = 104169, -- Gulp Froglet
			npcID = 73359, -- Gulp Froglet
		},
	},
	questID = 33301, -- Tracking Quest - Daily - Bufo
}

NPCs[72808] = { -- Tsavo'ka
	isTameable = true,
	questID = 33304, -- Tracking Quest - Daily - Tsavo'ka
}

NPCs[72909] = { -- Gu'chi the Swarmbringer
	pets = {
		{
			itemID = 104291, -- Swarmling of Gu'chi
			npcID = 73730, -- Gu'chi Swarmling
		},
	},
	questID = 33294, -- Tracking Quest - Daily - Gu'chi the Swarmbringer
}

NPCs[72970] = { -- Golganarr
	questID = 33315, -- Tracking Quest - Daily - Golganarr
	toys = {
		{ itemID = 104262 }, -- Odd Polished Stone
	},
}

NPCs[73157] = { -- Rock Moss
	questID = 33307, -- Tracking Quest - Daily - Rock Moss
}

NPCs[73158] = { -- Emerald Gander
	isTameable = true,
	questID = 33295, -- Tracking Quest - Daily - Emerald Gander
}

NPCs[73160] = { -- Ironfur Steelhorn
	isTameable = true,
	questID = 33296, -- Tracking Quest - Daily - Ironfur Steelhorn
}

NPCs[73161] = { -- Great Turtle Furyshell
	isTameable = true,
	questID = 33297, -- Tracking Quest - Daily - Great Turtle Furyshell
	toys = {
		{ itemID = 86584 }, -- Hardened Shell
	},
}

NPCs[73163] = { -- Imperial Python
	pets = {
		{
			itemID = 104161, -- Death Adder Hatchling
			npcID = 73364, -- Death Adder Hatchling
		},
	},
	questID = 33303, -- Tracking Quest - Daily - Imperial Python
}

NPCs[73166] = { -- Monstrous Spineclaw
	isTameable = true,
	pets = {
		{
			itemID = 104168, -- Spineclaw Crab
			npcID = 73366, -- Spineclaw Crab
		},
	},
	questID = 33302, -- Tracking Quest - Daily - Monstrous Spineclaw
}

NPCs[73167] = { -- Huolon
	mounts = {
		{
			itemID = 104269, -- Reins of the Thundering Onyx Cloud Serpent
			spellID = 148476, -- Thundering Onyx Cloud Serpent
		},
	},
	questID = 33311, -- Tracking Quest - Daily - Huolon
}

NPCs[73169] = { -- Jakur of Ordon
	questID = 33306, -- Tracking Quest - Daily - Jakur of Ordon
	toys = {
		{ itemID = 104331 }, -- Warning Sign
	},
}

NPCs[73170] = { -- Watcher Osu
	questID = 33322, -- Tracking Quest - Daily - Watcher Osu
}

NPCs[73171] = { -- Champion of the Black Flame
	questID = 33299, -- Tracking Quest - Daily - Champion of the Black Flame
	toys = {
		{ itemID = 104302 }, -- Blackflame Daggers
	},
}

NPCs[73172] = { -- Flintlord Gairan
	questID = 33309, -- Tracking Quest - Daily - Flintlord Gairan
	toys = {
		{ itemID = 104309 }, -- Eternal Kiln
	},
}

NPCs[73173] = { -- Urdur the Cauterizer
	questID = 33308, -- Tracking Quest - Daily - Urdur the Cauterizer
}

NPCs[73175] = { -- Cinderfall
	questID = 33310, -- Tracking Quest - Daily - Cinderfall
}

NPCs[73277] = { -- Leafmender
	pets = {
		{
			itemID = 104156, -- Ashleaf Spriteling
			npcID = 73533, -- Ashleaf Spriteling
		},
	},
	questID = 33298, -- Tracking Quest - Daily - Leafmender
}

NPCs[73279] = { -- Evermaw
	questID = 33313, -- Tracking Quest - Daily - Evermaw
}

NPCs[73281] = { -- Dread Ship Vazuvius
	questID = 33314, -- Tracking Quest - Daily - Dread Ship Vazuvius
	toys = {
		{ itemID = 104294 }, -- Rime of the Time-Lost Mariner
	},
}

NPCs[73282] = { -- Garnia
	pets = {
		{
			itemID = 104159, -- Ruby Droplet
			npcID = 73356, -- Ruby Droplet
		},
	},
	questID = 33300, -- Tracking Quest - Daily - Garnia
}

NPCs[73666] = { -- Archiereus of Flame (Three-Breeze Terrace)
	questID = 33312, -- Tracking Quest - Daily - Archiereus of Flame
}

NPCs[73704] = { -- Stinkbraid
	questID = 33305, -- Tracking Quest - Daily - Stinkbraid
}
