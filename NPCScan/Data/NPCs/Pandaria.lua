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
	vignetteID = 98,
}

-- TODO: Figure out which Zandalari Warbringer npcID this vignetteID belongs to - we don't want to alert on ALL of them...
-- vignetteID = 163

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

NPCs[70323] = { -- Krakkanon
	vignetteID = 173,
}

-- ----------------------------------------------------------------------------
-- Valley of the Four Winds
-- ----------------------------------------------------------------------------
NPCs[50339] = { -- Sulik'shor
	vignetteID = 154,
}

NPCs[50351] = { -- Jonn-Dar
	vignetteID = 147,
}

NPCs[50364] = { -- Nal'lak the Ripper
	vignetteID = 140,
}

NPCs[50766] = { -- Sele'na
	vignetteID = 133,
}

NPCs[50783] = { -- Salyin Warscout
	toys = {
		{ itemID = 86583 }, -- Salyin Battle Banner
	},
	vignetteID = 126,
}

NPCs[50811] = { -- Nasra Spothide
	vignetteID = 119,
}

NPCs[50828] = { -- Bonobos
	toys = {
		{ itemID = 86591 }, -- Magic Banana
	},
	vignetteID = 112,
}

NPCs[51059] = { -- Blackhoof
	toys = {
		{ itemID = 86565 }, -- Battle Horn
	},
	vignetteID = 106,
}

NPCs[62346] = { -- Galleon
	mounts = {
		{
			itemID = 89783, -- Son of Galleon's Saddle
			spellID = 130965, -- Son of Galleon
		},
	},
	questID = 32098, -- Short-Supply Reward
	vignetteID = -1,
}

-- ----------------------------------------------------------------------------
-- Kun-Lai Summit
-- ----------------------------------------------------------------------------
NPCs[50332] = { -- Korda Torros
	vignetteID = 159,
}

NPCs[50341] = { -- Borginn Darkfist
	vignetteID = 152,
}

NPCs[50354] = { -- Havak
	toys = {
		{ itemID = 86573 }, -- Shard of Archstone
	},
	vignetteID = 145,
}

NPCs[50733] = { -- Ski'thik
	toys = {
		{ itemID = 86577 }, -- Rod of Ambershaping
	},
	vignetteID = 138,
}

NPCs[50769] = { -- Zai the Outcast
	toys = {
		{ itemID = 86581 }, -- Farwater Conch
	},
	vignetteID = 131,
}

NPCs[50789] = { -- Nessos the Oracle
	toys = {
		{ itemID = 86584 }, -- Hardened Shell
	},
	vignetteID = 124,
}

NPCs[50817] = { -- Ahone the Wanderer
	toys = {
		{ itemID = 86588 }, -- Pandaren Firework Launcher
	},
	vignetteID = 117,
}

NPCs[50831] = { -- Scritch
	vignetteID = 110,
}

NPCs[60491] = { -- Sha of Anger
	mounts = {
		{
			itemID = 87771, -- Reins of the Heavenly Onyx Cloud Serpent
			spellID = 127158, -- Heavenly Onyx Cloud Serpent
		},
	},
	questID = 32099, -- Short-Supply Reward
	vignetteID = -1,
}

-- ----------------------------------------------------------------------------
-- Vale of Eternal Blossoms
-- ----------------------------------------------------------------------------
NPCs[50336] = { -- Yorik Sharpeye
	toys = {
		{ itemID = 86568 }, -- Mr. Smite's Brass Compass
	},
	vignetteID = 156,
}

NPCs[50349] = { -- Kang the Soul Thief
	toys = {
		{ itemID = 86571 }, -- Kang's Bindstone
	},
	vignetteID = 149,
}

NPCs[50359] = { -- Urgolax
	toys = {
		{ itemID = 86575 }, -- Chalice of Secrets
	},
	vignetteID = 142,
}

NPCs[50749] = { -- Kal'tik the Blight
	toys = {
		{ itemID = 134023 }, -- Bottled Tornado
	},
	vignetteID = 135,
}

NPCs[50780] = { -- Sahn Tidehunter
	toys = {
		{ itemID = 86582 }, -- Aqua Jewel
	},
	vignetteID = 128,
}

NPCs[50806] = { -- Moldo One-Eye
	toys = {
		{ itemID = 86586 }, -- Panflute of Pandaria
	},
	vignetteID = 121,
}

NPCs[50822] = { -- Ai-Ran the Shifting Cloud
	toys = {
		{ itemID = 86590 }, -- Essence of the Breeze
	},
	vignetteID = 114,
}

NPCs[50840] = { -- Major Nanners
	toys = {
		{ itemID = 86594 }, -- Helpful Wikky's Whistle
	},
	vignetteID = 107,
}

NPCs[50843] = { -- Portent
	isTameable = true,
	vignetteID = -1,
}

NPCs[58474] = { -- Bloodtip
	isTameable = true,
	vignetteID = 33,
}

NPCs[58768] = { -- Cracklefang
	isTameable = true,
	vignetteID = 34,
}

NPCs[58769] = { -- Vicejaw
	vignetteID = 35,
}

NPCs[58771] = { -- Quid
	achievementSpellID = 129949, -- Quid Kill Credit
	vignetteID = 36,
}

NPCs[58778] = { -- Aetha
	achievementSpellID = 129950, -- Aetha Kill Credit
	vignetteID = 37,
}

NPCs[58817] = { -- Spirit of Lao-Fe
	vignetteID = 38,
}

NPCs[58949] = { -- Bai'Jin the Butcher
	vignetteID = 39,
}

NPCs[62880] = { -- Gochao the Ironfist
	vignetteID = 40,
}

NPCs[62881] = { -- Gaohun the Soul-Severer
	vignetteID = 41,
}

NPCs[63101] = { -- General Temuja
	vignetteID = 42,
}

NPCs[63240] = { -- Shadowmaster Sydow
	vignetteID = 43,
}

NPCs[63509] = { -- Wulon
	isTameable = true,
	vignetteID = 44,
}

NPCs[63510] = { -- Wulon
	isTameable = true,
	vignetteID = -1,
}

NPCs[63691] = { -- Huo-Shuang
	vignetteID = 45,
}

NPCs[63695] = { -- Baolai the Immolator
	vignetteID = 46,
}

NPCs[63977] = { -- Vyraxxis
	vignetteID = 47,
}

NPCs[63978] = { -- Kri'chon
	isTameable = true,
	vignetteID = 48,
}

-- ----------------------------------------------------------------------------
-- Krasarang Wilds
-- ----------------------------------------------------------------------------
NPCs[50331] = { -- Go-Kan
	vignetteID = 160,
}

NPCs[50340] = { -- Gaarn the Toxic
	vignetteID = 153,
}

NPCs[50352] = { -- Qu'nas
	vignetteID = 146,
}

NPCs[50388] = { -- Torik-Ethis
	vignetteID = 139,
}

NPCs[50768] = { -- Cournith Waterstrider
	vignetteID = 132,
}

NPCs[50787] = { -- Arness the Scale
	vignetteID = 125,
}

NPCs[50816] = { -- Ruun Ghostpaw
	vignetteID = 118,
}

NPCs[50830] = { -- Spriggin
	vignetteID = 111,
}

NPCs[68317] = { -- Mavis Harms
	factionGroup = "Alliance",
	vignetteID = 104,
}

NPCs[68318] = { -- Dalan Nightbreaker
	factionGroup = "Alliance",
	vignetteID = 103,
}

NPCs[68319] = { -- Disha Fearwarden
	factionGroup = "Alliance",
	vignetteID = 102,
}

NPCs[68320] = { -- Ubunti the Shade
	factionGroup = "Horde",
	vignetteID = 101,
}

NPCs[68321] = { -- Kar Warmaker
	factionGroup = "Horde",
	vignetteID = 100,
}

NPCs[68322] = { -- Muerta
	factionGroup = "Horde",
	vignetteID = 99,
}

-- ----------------------------------------------------------------------------
-- Dread Wastes
-- ----------------------------------------------------------------------------
NPCs[50334] = { -- Dak the Breaker
	vignetteID = 157,
}

NPCs[50347] = { -- Karr the Darkener
	pets = {
		{
			itemID = 86564, -- Imbued Jade Fragment
			npcID = 64634, -- Grinder
		},
	},
	vignetteID = 150,
}

NPCs[50356] = { -- Krol the Blade
	vignetteID = 143,
}

NPCs[50739] = { -- Gar'lok
	toys = {
		{ itemID = 86578 }, -- Eternal Warrior's Sigil
	},
	vignetteID = 136,
}

NPCs[50776] = { -- Nalash Verdantis
	pets = {
		{
			itemID = 86563, -- Hollow Reed
			npcID = 64633, -- Aqua Strider
		},
	},
	vignetteID = 129, -- Nelash Verdantis
}

NPCs[50821] = { -- Ai-Li Skymirror
	toys = {
		{ itemID = 86589 },  -- Ai-Li's Skymirror
	},
	vignetteID = 115,
}

NPCs[50836] = { -- Ik-Ik the Nimble
	toys = {
		{ itemID = 86593 }, -- Hozen Beach Ball
	},
	vignetteID = 108,
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

NPCs[69664] = { -- Mumta
	vignetteID = 162,
}

NPCs[69996] = { -- Ku'lai the Skyclaw
	vignetteID = 166,
}

NPCs[69997] = { -- Progenitus
	vignetteID = 165,
}

NPCs[69998] = { -- Goda
	isTameable = true,
	vignetteID = 167,
}

NPCs[69999] = { -- God-Hulk Ramuk
	vignetteID = 168,
}

NPCs[70000] = { -- Al'tabim the All-Seeing
	vignetteID = 169,
}

NPCs[70001] = { -- Backbreaker Uru
	vignetteID = 170,
}

NPCs[70002] = { -- Lu-Ban
	vignetteID = 171,
}

NPCs[70003] = { -- Molthor
	vignetteID = 172,
}

NPCs[70530] = { -- Ra'sha
	vignetteID = 96,
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
	vignetteID = -1,
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
	vignetteID = 164,
}

-- ----------------------------------------------------------------------------
-- Isle of Thunder
-- ----------------------------------------------------------------------------
NPCs[69664] = { -- Mumta
	vignetteID = 162,
}

NPCs[69996] = { -- Ku'lai the Skyclaw
	vignetteID = 166,
}

NPCs[69997] = { -- Progenitus
	vignetteID = 165,
}

NPCs[69998] = { -- Goda
	vignetteID = 167,
}

NPCs[69999] = { -- God-Hulk Ramuk
	vignetteID = 168,
}

NPCs[70000] = { -- Al'tabim the All-Seeing
	vignetteID = 169,
}

NPCs[70001] = { -- Backbreaker Uru
	vignetteID = 170,
}

NPCs[70002] = { -- Lu-Ban
	vignetteID = 171,
}

NPCs[70003] = { -- Molthor
	vignetteID = 172,
}

NPCs[70530] = { -- Ra'sha
	vignetteID = 96,
}

-- ----------------------------------------------------------------------------
-- The Jade Forest
-- ----------------------------------------------------------------------------
NPCs[50338] = { -- Kor'nas Nightsavage
	vignetteID = 155,
}

NPCs[50350] = { -- Morgrinn Crackfang
	vignetteID = 148,
}

NPCs[50363] = { -- Krax'ik
	vignetteID = 141,
}

NPCs[50750] = { -- Aethis
	vignetteID = 134,
}

NPCs[50782] = { -- Sarnak
	vignetteID = 127,
}

NPCs[50808] = { -- Urobi the Walker
	vignetteID = 120,
}

NPCs[50823] = { -- Mister Ferocious
	vignetteID = 113,
}

NPCs[51078] = { -- Ferdinand
	vignetteID = 105,
}

-- ----------------------------------------------------------------------------
-- Timeless Isle
-- ----------------------------------------------------------------------------
NPCs[71864] = { -- Spelurk
	vignetteID = 74,
}

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
	vignetteID = 59,
}

NPCs[72048] = { -- Rattleskew
	vignetteID = 61, -- Battle of the Barnacle
}

NPCs[72049] = { -- Cranegnasher
	questID = 32967, -- Tracking Quest - Daily - Cranegnasher
	vignetteID = 53,
}

NPCs[72193] = { -- Karkanos
	questID = 33292, -- Tracking Quest - Daily - Karkanos
	vignetteID = 60,
}

NPCs[72245] = { -- Zesqua
	questID = 33316, -- Tracking Quest - Daily - Zesqua
	vignetteID = 50,
}

NPCs[72769] = { -- Spirit of Jadefire
	pets = {
		{
			itemID = 104307, -- Jadefire Spirit
			npcID = 73738, -- Jadefire Spirit
		},
	},
	questID = 33293, -- Tracking Quest - Daily - Spirit of Jadefire
	vignetteID = 70,
}

NPCs[72775] = { -- Bufo
	pets = {
		{
			itemID = 104169, -- Gulp Froglet
			npcID = 73359, -- Gulp Froglet
		},
	},
	questID = 33301, -- Tracking Quest - Daily - Bufo
	vignetteID = 81,
}

NPCs[72808] = { -- Tsavo'ka
	isTameable = true,
	questID = 33304, -- Tracking Quest - Daily - Tsavo'ka
	vignetteID = 78,
}

NPCs[72909] = { -- Gu'chi the Swarmbringer
	pets = {
		{
			itemID = 104291, -- Swarmling of Gu'chi
			npcID = 73730, -- Gu'chi Swarmling
		},
	},
	questID = 33294, -- Tracking Quest - Daily - Gu'chi the Swarmbringer
	vignetteID = 69,
}

NPCs[72970] = { -- Golganarr
	questID = 33315, -- Tracking Quest - Daily - Golganarr
	toys = {
		{ itemID = 104262 }, -- Odd Polished Stone
	},
	vignetteID = 83,
}

NPCs[73157] = { -- Rock Moss
	questID = 33307, -- Tracking Quest - Daily - Rock Moss
	vignetteID = 76,
}

NPCs[73158] = { -- Emerald Gander
	isTameable = true,
	questID = 33295, -- Tracking Quest - Daily - Emerald Gander
	vignetteID = 68,
}

NPCs[73160] = { -- Ironfur Steelhorn
	isTameable = true,
	questID = 33296, -- Tracking Quest - Daily - Ironfur Steelhorn
	vignetteID = 65,
}

NPCs[73161] = { -- Great Turtle Furyshell
	isTameable = true,
	questID = 33297, -- Tracking Quest - Daily - Great Turtle Furyshell
	toys = {
		{ itemID = 86584 }, -- Hardened Shell
	},
	vignetteID = 67,
}

NPCs[73163] = { -- Imperial Python
	pets = {
		{
			itemID = 104161, -- Death Adder Hatchling
			npcID = 73364, -- Death Adder Hatchling
		},
	},
	questID = 33303, -- Tracking Quest - Daily - Imperial Python
	vignetteID = 84,
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
	vignetteID = 80,
}

NPCs[73167] = { -- Huolon
	mounts = {
		{
			itemID = 104269, -- Reins of the Thundering Onyx Cloud Serpent
			spellID = 148476, -- Thundering Onyx Cloud Serpent
		},
	},
	questID = 33311, -- Tracking Quest - Daily - Huolon
	vignetteID = 79,
}

NPCs[73169] = { -- Jakur of Ordon
	questID = 33306, -- Tracking Quest - Daily - Jakur of Ordon
	toys = {
		{ itemID = 104331 }, -- Warning Sign
	},
	vignetteID = 89,
}

NPCs[73170] = { -- Watcher Osu
	questID = 33322, -- Tracking Quest - Daily - Watcher Osu
	vignetteID = 87,
}

NPCs[73171] = { -- Champion of the Black Flame
	questID = 33299, -- Tracking Quest - Daily - Champion of the Black Flame
	toys = {
		{ itemID = 104302 }, -- Blackflame Daggers
	},
	vignetteID = 91,
}

NPCs[73172] = { -- Flintlord Gairan
	questID = 33309, -- Tracking Quest - Daily - Flintlord Gairan
	toys = {
		{ itemID = 104309 }, -- Eternal Kiln
	},
	vignetteID = 90,
}

NPCs[73173] = { -- Urdur the Cauterizer
	questID = 33308, -- Tracking Quest - Daily - Urdur the Cauterizer
	vignetteID = 88,
}

NPCs[73175] = { -- Cinderfall
	questID = 33310, -- Tracking Quest - Daily - Cinderfall
	vignetteID = 77,
}

NPCs[73277] = { -- Leafmender
	pets = {
		{
			itemID = 104156, -- Ashleaf Spriteling
			npcID = 73533, -- Ashleaf Spriteling
		},
	},
	questID = 33298, -- Tracking Quest - Daily - Leafmender
	vignetteID = 66,
}

NPCs[73279] = { -- Evermaw
	questID = 33313, -- Tracking Quest - Daily - Evermaw
	vignetteID = 85,
}

NPCs[73281] = { -- Dread Ship Vazuvius
	questID = 33314, -- Tracking Quest - Daily - Dread Ship Vazuvius
	toys = {
		{ itemID = 104294 }, -- Rime of the Time-Lost Mariner
	},
	vignetteID = 82,
}

NPCs[73282] = { -- Garnia
	pets = {
		{
			itemID = 104159, -- Ruby Droplet
			npcID = 73356, -- Ruby Droplet
		},
	},
	questID = 33300, -- Tracking Quest - Daily - Garnia
	vignetteID = 75,
}

NPCs[73293] = { -- Whizzig
	vignetteID = 72,
}

NPCs[73666] = { -- Archiereus of Flame (Three-Breeze Terrace)
	questID = 33312, -- Tracking Quest - Daily - Archiereus of Flame
}

NPCs[73704] = { -- Stinkbraid
	questID = 33305, -- Tracking Quest - Daily - Stinkbraid
	vignetteID = 95,
}

NPCs[73854] = { -- Cranegnasher
	vignetteID = -1,
}

-- ----------------------------------------------------------------------------
-- The Veiled Stair
-- ----------------------------------------------------------------------------
NPCs[70126] = { -- Willy Wilder
	vignetteID = 97,
}

-- ----------------------------------------------------------------------------
-- Townlong Steppes
-- ----------------------------------------------------------------------------
NPCs[50333] = { -- Lon the Bull
	vignetteID = 158,
}

NPCs[50344] = { -- Norlaxx
	vignetteID = 151,
}

NPCs[50355] = { -- Kah'tir
	vignetteID = 144,
}

NPCs[50734] = { -- Lith'ik the Stalker
	vignetteID = 137,
}

NPCs[50772] = { -- Eshelon
	vignetteID = 130,
}

NPCs[50791] = { -- Siltriss the Sharpener
	vignetteID = 123,
}

NPCs[50820] = { -- Yul Wildpaw
	vignetteID = 116,
}

NPCs[50832] = { -- The Yowler
	vignetteID = 109,
}
