-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local NPCs = private.Data.NPCs

-- ----------------------------------------------------------------------------
-- Arathi Highlands
-- ----------------------------------------------------------------------------
NPCs[50337] = { -- Cackle
	isTameable = true,
}

NPCs[50770] = { -- Zorn
	isTameable = true,
}

NPCs[50804] = { -- Ripwing
	isTameable = true,
}

NPCs[50865] = { -- Saurix
	isTameable = true,
}

NPCs[50891] = { -- Boros
	isTameable = true,
}

NPCs[50940] = { -- Swee
	isTameable = true,
}

NPCs[51040] = { -- Snuffles
	isTameable = true,
}

NPCs[51063] = { -- Phalanax
	isTameable = true,
}

NPCs[51067] = { -- Glint
	isTameable = true,
}

NPCs[137374] = { -- The Lion's Roar
	factionGroup = "Alliance",
	toys = {
		{ itemID = 163829, }, -- Toy War Machine
	},
}

NPCs[138122] = { -- Doom's Howl
	factionGroup = "Horde",
	toys = {
		{ itemID = 163828, }, -- Toy Siege Tower
	},
}

NPCs[141615] = { -- Burning Goliath
	questID = 53506,
	vignetteID = 3194,
}

NPCs[141616] = { -- Thundering Goliath
	questID = 53527,
	vignetteID = 3200,
}

NPCs[141618] = { -- Cresting Goliath
	questID = 53531,
	vignetteID = 3195,
}

NPCs[141620] = { -- Rumbling Goliath
	questID = 53523,
	vignetteID = 3198,
}

NPCs[142423] = { -- Overseer Krix
	mounts = {
		{
			itemID = 163646, -- Lil' Donkey
			spellID = 279608 -- Lil' Donkey
		},
	},
	questID = 53518,
	vignetteID = 3191,
}

NPCs[142433] = { -- Fozruk
	pets = {
		{
			itemID = 163711, -- Shard of Fozruk
			npcID = 143627, -- Fozling
		},
	},
	questID = 53510,
	vignetteID = 3196,
}

NPCs[142435] = { -- Plaguefeather
	isTameable = true,
	pets = {
		{
			itemID = 163690, -- Plagued Egg
			npcID = 143564, -- Foulfeather
		},
	},
	questID = 53519,
	vignetteID = 3197,
}

NPCs[142436] = { -- Ragebeak
	pets = {
		{
			itemID = 163689, -- Angry Egg
			npcID = 143563, -- Ragepeep
		},
	},
	questID = 53522,
	vignetteID = 3193,
}

NPCs[142437] = { -- Skullripper
	mounts = {
		{
			itemID = 163645, -- Skullripper
			spellID = 279611, -- Skullripper
		},
	},
	questID = 53526,
	vignetteID = 3199,
}

NPCs[142438] = { -- Venomarus
	pets = {
		{
			itemID = 163648, -- Fuzzy Creepling
			npcID = 143499, -- Fuzzy Creepling
		},
	},
	questID = 53528,
	vignetteID = 3201,
}

NPCs[142440] = { -- Yogursa
	pets = {
		{
			itemID = 163684, -- Scabby,
			npcID = 143533, -- Scabby
		},
	},
	questID = 53529,
	vignetteID = 3192,
}

NPCs[142508] = { -- Branchlord Aldrus
	pets = {
		{
			itemID = 163650, -- Aldrusian Sproutling
			npcID = 143503, -- Aldrusian Sproutling
		},
	},
	questID = 53505,
	vignetteID = 3190,
}

NPCs[142662] = { -- Geomancer Flintdagger
	questID = 53511,
	toys = {
		{ itemID = 163713, }, -- Brazier Cap
	},
	vignetteID = 3205,
}

NPCs[141668] = { -- Echo of Myzrael
	pets = {
		{
			itemID = 163677, -- Teeny Titan Orb
			npcID = 143515, -- Teeny Titan Orb
		},
	},
	questID = 53508,
	vignetteID = 3204,
}

NPCs[141942] = { -- Molok the Crusher
	questID = 53516,
	toys = {
		{ itemID = 163775, }, -- Molok Morion
	},
	vignetteID = 3202,
}

NPCs[142112] = { -- Kor'gresh Coldrage
	questID = 53513,
	toys = {
		{ itemID = 163744, }, -- Coldrage's Cooler
	},
	vignetteID = 3203,
}

NPCs[142682] = { -- Zalas Witherbark
	questID = 53530,
	toys = {
		{ itemID = 163745, }, -- Witherbark Gong
	},
	vignetteID = 3218,
}

NPCs[142683] = { -- Ruul Onestone
	toys = {
		{ itemID = 163741, }, -- Magic Fun Rock
	},
	questID = 53524,
	vignetteID = 3216,
}

NPCs[142684] = { -- Kovork
	questID = 53514,
	toys = {
		{ itemID = 163750 }, -- Kovork Kostume
	},
	vignetteID = 3213,
}

NPCs[142686] = { -- Foulbelly
	questID = 53509,
	toys = {
		{ itemID = 163735, }, -- Foul Belly
	},
	vignetteID = 3210,
}

NPCs[142688] = { -- Darbel Montrose
	pets = {
		{
			itemID = 163652, -- Tiny Grimoire
			npcID = 143507, -- Voidwiggler
		},
	},
	questID = 53507,
	vignetteID = 3208,
}

NPCs[142690] = { -- Singer
	questID = 53525,
	toys = {
		{ itemID = 163738, } -- Syndicate Mask
	},
	vignetteID = 3217,
}

NPCs[142692] = { -- Nimar the Slayer
	mounts = {
		{
			itemID = 163706, -- Witherbark Direwing
			spellID = 279868, -- Witherbark Direwing
		},
	},
	questID = 53517,
	vignetteID = 3215,
}

NPCs[142709] = { -- Beastrider Kama
	mounts = {
		{
			itemID = 163644, -- Swift Albino Raptor
			spellID = 279569, -- Swift Albino Raptor
		},
	},
	questID = 53504,
	vignetteID = 3207,
}

NPCs[142716] = { -- Man-Hunter Rog
	pets = {
		{
			itemID = 163712, -- Mana-Warped Egg
			npcID = 143628, -- Squawkling
		},
	},
	questID = 53515,
	vignetteID = 3214,
}

NPCs[142725] = { -- Horrific Apparition
	questID = 53512,
	toys = {
		{ itemID = 163736, } -- Spectral Visage
	},
	vignetteID = 3211,
}

NPCs[142739] = { -- Knight-Captain Aldrin
	factionGroup = "Alliance",
	mounts = {
		{
			itemID = 163578, -- Broken Highland Mustang
			spellID = 279457, -- Broken Highland Mustang
		},
	},
	vignetteID = 3212,
}

NPCs[142741] = { -- Doomrider Helgrim
	factionGroup = "Horde",
	mounts = {
		{
			itemID = 163579, -- Highland Mustang
			spellID = 279456, -- Highland Mustang
		},
	},
	vignetteID = 3209,
}

-- ----------------------------------------------------------------------------
-- Badlands
-- ----------------------------------------------------------------------------
NPCs[2753] = { -- Barnabus
	isTameable = true,
}

NPCs[2850] = { -- Broken Tooth
	isTameable = true,
}

NPCs[2931] = { -- Zaricotl
	isTameable = true,
}

NPCs[50726] = { -- Kalixx
	isTameable = true,
}

NPCs[50728] = { -- Deathstrike
	isTameable = true,
}

NPCs[50731] = { -- Needlefang
	isTameable = true,
}

NPCs[50838] = { -- Tabbs
	isTameable = true,
}

NPCs[51000] = { -- Blackshell the Impenetrable
	isTameable = true,
}

NPCs[51007] = { -- Serkett
	isTameable = true,
}

NPCs[51018] = { -- Zormus
	isTameable = true,
}

NPCs[51021] = { -- Vorticus
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Blasted Lands
-- ----------------------------------------------------------------------------
NPCs[8299] = { -- Spiteflayer
	isTameable = true,
}

NPCs[8300] = { -- Ravage
	isTameable = true,
}

NPCs[8301] = { -- Clack the Reaver
	isTameable = true,
}

NPCs[8302] = { -- Deatheye
	isTameable = true,
}

NPCs[8303] = { -- Grunter
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Tirisfal Glades
-- ----------------------------------------------------------------------------
NPCs[10356] = { -- Bayne
	isTameable = true,
}

NPCs[10357] = { -- Ressan the Needler
	isTameable = true,
}

NPCs[10359] = { -- Sri'skulk
	isTameable = true,
}

NPCs[50763] = { -- Shadowstalker
	isTameable = true,
}

NPCs[50803] = { -- Bonechewer
	isTameable = true,
}

NPCs[50908] = { -- Nighthowl
	isTameable = true,
}

NPCs[50930] = { -- Hibernus the Sleeper
	isTameable = true,
}

NPCs[51044] = { -- Plague
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Silverpine Forest
-- ----------------------------------------------------------------------------
NPCs[12431] = { -- Gorefang
	isTameable = true,
}

NPCs[12433] = { -- Krethis the Shadowspinner
	isTameable = true,
}

NPCs[50330] = { -- Kree
	isTameable = true,
}

NPCs[50814] = { -- Corpsefeeder
	isTameable = true,
}

NPCs[50949] = { -- Finn's Gambit
	isTameable = true,
}

NPCs[51026] = { -- Gnath
	isTameable = true,
}

NPCs[51037] = { -- Lost Gilnean Wardog
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Western Plaguelands
-- ----------------------------------------------------------------------------
NPCs[50345] = { -- Alit
	isTameable = true,
}

NPCs[50778] = { -- Ironweb
	isTameable = true,
}

NPCs[50809] = { -- Heress
	isTameable = true,
}

NPCs[50906] = { -- Mutilax
	isTameable = true,
}

NPCs[50922] = { -- Warg
	isTameable = true,
}

NPCs[50931] = { -- Mange
	isTameable = true,
}

NPCs[50937] = { -- Hamhide
	isTameable = true,
}

NPCs[51029] = { -- Parasitus
	isTameable = true,
}

NPCs[51031] = { -- Tracker
	isTameable = true,
}

NPCs[51058] = { -- Aphis
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Eastern Plaguelands
-- ----------------------------------------------------------------------------
NPCs[50775] = { -- Likk the Hunter
	isTameable = true,
}

NPCs[50779] = { -- Sporeggon
	isTameable = true,
}

NPCs[50813] = { -- Fene-mal
	isTameable = true,
}

NPCs[50856] = { -- Snark
	isTameable = true,
}

NPCs[50915] = { -- Snort
	isTameable = true,
}

NPCs[50947] = { -- Varah
	isTameable = true,
}

NPCs[51027] = { -- Spirocula
	isTameable = true,
}

NPCs[51042] = { -- Bleakheart
	isTameable = true,
}

NPCs[51053] = { -- Quirix
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Hillsbrad Foothills
-- ----------------------------------------------------------------------------
NPCs[14222] = { -- Araga
	isTameable = true,
}

NPCs[14223] = { -- Cranky Benj
	isTameable = true,
}

NPCs[14275] = { -- Tamra Stormpike
	factionGroup = "Alliance",
}

NPCs[14279] = { -- Creepthess
	isTameable = true,
}

NPCs[14280] = { -- Big Samras
	isTameable = true,
}

NPCs[50335] = { -- Alitus
	isTameable = true,
}

NPCs[50765] = { -- Miasmiss
	isTameable = true,
}

NPCs[50770] = { -- Zorn
	isTameable = true,
}

NPCs[50818] = { -- The Dark Prowler
	isTameable = true,
}

NPCs[50858] = { -- Dustwing
	isTameable = true,
}

NPCs[50929] = { -- Little Bjorn
	isTameable = true,
}

NPCs[50955] = { -- Carcinak
	isTameable = true,
}

NPCs[50967] = { -- Craw the Ravager
	isTameable = true,
}

NPCs[51022] = { -- Chordix
	isTameable = true,
}

NPCs[51057] = { -- Weevil
	isTameable = true,
}

NPCs[51076] = { -- Lopex
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- The Hinterlands
-- ----------------------------------------------------------------------------
NPCs[8211] = { -- Old Cliff Jumper
	isTameable = true,
}

NPCs[8213] = { -- Ironback
	isTameable = true,
}

NPCs[8214] = { -- Jalinde Summerdrake
	factionGroup = "Alliance",
}

NPCs[107617] = { -- Ol' Muddle
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Dun Morogh
-- ----------------------------------------------------------------------------
NPCs[1130] = { -- Bjarn
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Searing Gorge
-- ----------------------------------------------------------------------------
NPCs[8277] = { -- Rekk'tilac
	isTameable = true,
}

NPCs[50846] = { -- Slavermaw
	isTameable = true,
}

NPCs[50876] = { -- Avis
	isTameable = true,
}

NPCs[50946] = { -- Hogzilla
	isTameable = true,
}

NPCs[50948] = { -- Crystalback
	isTameable = true,
}

NPCs[51002] = { -- Scorpoxx
	isTameable = true,
}

NPCs[51010] = { -- Snips
	isTameable = true,
}

NPCs[51048] = { -- Rexxus
	isTameable = true,
}

NPCs[51066] = { -- Crystalfang
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Burning Steppes
-- ----------------------------------------------------------------------------
NPCs[10077] = { -- Deathmaw
	isTameable = true,
}

NPCs[50357] = { -- Sunwing
	isTameable = true,
}

NPCs[50361] = { -- Ornat
	isTameable = true,
}

NPCs[50725] = { -- Azelisk
	isTameable = true,
}

NPCs[50730] = { -- Venomspine
	isTameable = true,
}

NPCs[50792] = { -- Chiaa
	isTameable = true,
}

NPCs[50807] = { -- Catal
	isTameable = true,
}

NPCs[50810] = { -- Favored of Isiset
	isTameable = true,
}

NPCs[50839] = { -- Chromehound
	isTameable = true,
}

NPCs[50842] = { -- Magmagan
	isTameable = true,
}

NPCs[50855] = { -- Jaxx the Rabid
	isTameable = true,
}

NPCs[51066] = { -- Crystalfang
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Elwynn Forest
-- ----------------------------------------------------------------------------
NPCs[471] = { -- Mother Fang
	isTameable = true,
}

NPCs[50752] = { -- Tarantis
	isTameable = true,
}

NPCs[50916] = { -- Lamepaw the Whimperer
	isTameable = true,
}

NPCs[50926] = { -- Grizzled Ben
	isTameable = true,
}

NPCs[50942] = { -- Snoot the Rooter
	isTameable = true,
}

NPCs[51014] = { -- Terrapis
	isTameable = true,
}

NPCs[51077] = { -- Bushtail
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Duskwood
-- ----------------------------------------------------------------------------
NPCs[521] = { -- Lupos
	isTameable = true,
}

NPCs[574] = { -- Naraxis
	isTameable = true,
}

NPCs[118244] = { -- Lightning Paw
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Loch Modan
-- ----------------------------------------------------------------------------
NPCs[2476] = { -- Gosh-Haldir
	isTameable = true,
}

NPCs[14266] = { -- Shanda the Spinner
	isTameable = true,
}

NPCs[14268] = { -- Lord Condar
	isTameable = true,
}

NPCs[45380] = { -- Ashtail
	isTameable = true,
}

NPCs[45399] = { -- Optimo
	isTameable = true,
}

NPCs[45402] = { -- Nix
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Redridge Mountains
-- ----------------------------------------------------------------------------
NPCs[616] = { -- Chatter
	isTameable = true,
}

NPCs[52146] = { -- Chitter
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Northern Stranglethorn
-- ----------------------------------------------------------------------------
NPCs[51661] = { -- Tsul'Kalu
	isTameable = true,
}

NPCs[51662] = { -- Mahamba
	isTameable = true,
}

NPCs[51663] = { -- Pogeyan
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Scholomance
-- ----------------------------------------------------------------------------
NPCs[59369] = { -- Doctor Theolen Krastinov
	vignetteID = 161,
}

-- ----------------------------------------------------------------------------
-- Swamp of Sorrows
-- ----------------------------------------------------------------------------
NPCs[50738] = { -- Shimmerscale
	isTameable = true,
}

NPCs[50790] = { -- Ionis
	isTameable = true,
}

NPCs[50797] = { -- Yukiko
	isTameable = true,
}

NPCs[50837] = { -- Kash
	isTameable = true,
}

NPCs[50882] = { -- Chupacabros
	isTameable = true,
}

NPCs[50886] = { -- Seawing
	isTameable = true,
}

NPCs[50903] = { -- Orlix the Swamplord
	isTameable = true,
}

NPCs[51052] = { -- Gib the Banana-Hoarder
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Westfall
-- ----------------------------------------------------------------------------
NPCs[462] = { -- Vultros
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Wetlands
-- ----------------------------------------------------------------------------
NPCs[1112] = { -- Leech Widow
	isTameable = true,
}

NPCs[1140] = { -- Razormaw Matriarch
	isTameable = true,
}

NPCs[50964] = { -- Chops
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Stormwind City
-- ----------------------------------------------------------------------------
NPCs[3581] = { -- Sewer Beast
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Vashj'ir
-- ----------------------------------------------------------------------------
NPCs[51079] = { -- Captain Foulwind
	factionGroup = "Horde",
}

-- ----------------------------------------------------------------------------
-- Abyssal Depths
-- ----------------------------------------------------------------------------
NPCs[50051] = { -- Ghostcrawler
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Shimmering Expanse
-- ----------------------------------------------------------------------------
NPCs[51071] = { -- Captain Florence
	factionGroup = "Alliance",
}

-- ----------------------------------------------------------------------------
-- The Cape of Stranglethorn
-- ----------------------------------------------------------------------------
NPCs[1552] = { -- Scale Belly
	isTameable = true,
}

NPCs[14491] = { -- Kurmokk
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Twilight Highlands
-- ----------------------------------------------------------------------------
NPCs[50138] = { -- Karoma
	isTameable = true,
}

NPCs[50159] = { -- Sambas
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Blackrock Spire
-- ----------------------------------------------------------------------------
NPCs[10376] = { -- Crystal Fang
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Karazhan
-- ----------------------------------------------------------------------------
NPCs[16179] = { -- Hyakiss the Lurker
	isTameable = true,
}

NPCs[16180] = { -- Shadikith the Glider
	isTameable = true,
}

NPCs[16181] = { -- Rokad the Ravager
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- Deathknell
-- ----------------------------------------------------------------------------
NPCs[50328] = { -- Fangor
	isTameable = true,
}

-- ----------------------------------------------------------------------------
-- New Tinkertown
-- ----------------------------------------------------------------------------
NPCs[1132] = { -- Timber
	isTameable = true,
}

NPCs[107431] = { -- Weaponized Rabbot
	isTameable = true,
}
