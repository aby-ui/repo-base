--[[
	Below are constants needed for DB storage and retrieval
	The core of gathermate handles adding new node that collector finds
	data shared between Collector and Display also live in GatherMate for sharing like zone_data for sizes, and node ids with reverses for display and comparison
	Credit to Astrolabe (http://www.gathereraddon.com) for lookup tables used in GatherMate. Astrolabe is licensed LGPL
]]
local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
local NL = LibStub("AceLocale-3.0"):GetLocale("GatherMate2Nodes",true)
local L = LibStub("AceLocale-3.0"):GetLocale("GatherMate2")

--[[
	Node Identifiers
]]
local node_ids = {
	["Fishing"] = {
		[NL["Floating Wreckage"]] 				= 101, -- treasure.tga
		--[NL["Patch of Elemental Water"]] 		= 102, -- purewater.tga
		[NL["Floating Debris"]]			= 103, -- debris.tga
		--[NL["Oil Spill"]] 					= 104, -- oilspill.tga
		[NL["Firefin Snapper School"]] 			= 105, -- firefin.tga
		[NL["Greater Sagefish School"]] 		= 106, -- greatersagefish.tga
		[NL["Oily Blackmouth School"]] 			= 107, -- oilyblackmouth.tga
		[NL["Sagefish School"]] 				= 108, -- sagefish.tga
		[NL["School of Deviate Fish"]] 			= 109, -- firefin.tga
		[NL["Stonescale Eel Swarm"]] 			= 110, -- eel.tga
		--[NL["Muddy Churning Water"]] 			= 111, -- ZG only fishing node
		[NL["Highland Mixed School"]] 			= 112, -- fishhook.tga
		[NL["Pure Water"]] 						= 113, -- purewater.tga
		[NL["Bluefish School"]] 				= 114, -- bluefish,tga
		[NL["Feltail School"]] 					= 115, -- feltail.tga
		[NL["Brackish Mixed School"]]         	= 115, -- feltail.tga
		[NL["Mudfish School"]] 					= 116, -- mudfish.tga
		[NL["School of Darter"]] 				= 117, -- darter.tga
		[NL["Sporefish School"]] 				= 118, -- sporefish.tga
		[NL["Steam Pump Flotsam"]] 				= 119, -- steampump.tga
		[NL["School of Tastyfish"]] 			= 120, -- net.tga
		[NL["Borean Man O' War School"]]        = 121,
		[NL["Deep Sea Monsterbelly School"]]	= 122,
		[NL["Dragonfin Angelfish School"]]		= 123,
		[NL["Fangtooth Herring School"]]		= 124,
		[NL["Floating Wreckage Pool"]]			= 125,
		[NL["Glacial Salmon School"]]			= 126,
		[NL["Glassfin Minnow School"]]			= 127,
		[NL["Imperial Manta Ray School"]]		= 128,
		[NL["Moonglow Cuttlefish School"]]		= 129,
		[NL["Musselback Sculpin School"]]		= 130,
		[NL["Nettlefish School"]]				= 131,
		[NL["Strange Pool"]]					= 132,
		[NL["Schooner Wreckage"]]			    = 133,
		[NL["Waterlogged Wreckage Pool"]]		= 134,
		[NL["Bloodsail Wreckage Pool"]]			= 135,
		[NL["Mixed Ocean School"]]				= 136,
		-- Begin tediuous prefix mapping
		--[NL["Lesser Sagefish School"]]		= 136, -- sagefish.tga
		--[NL["Lesser Oily Blackmouth School"]] = 137, -- oilyblackmouth.tga
		--[NL["Sparse Oily Blackmouth School"]] = 138, -- oilyblackmouth.tga
		--[NL["Abundant Oily Blackmouth School"]]	= 139, -- oilyblackmouth.tga
		--[NL["Teeming Oily Blackmouth School"]]= 140, -- oilyblackmouth.tga
		--[NL["Lesser Firefin Snapper School"]] = 141, -- firefin.tga
		--[NL["Sparse Firefin Snapper School"]] = 142, -- firefin.tga
		--[NL["Abundant Firefin Snapper School"]]= 143, -- firefin.tga
		--[NL["Teeming Firefin Snapper School"]]= 144, -- firefin.tga
		--[NL["Lesser Floating Debris"]] 		= 145, -- debris.tga
		--[NL["Sparse Schooner Wreckage"]]		= 146,
		--[NL["Abundant Bloodsail Wreckage"]]	= 147,
		--[NL["Teeming Floating Wreckage"]]		= 148,
		[NL["Albino Cavefish School"]]			= 149,
		--[NL["Algaefin Rockfish School"]]		= 150,
		[NL["Blackbelly Mudfish School"]]		= 151,
		[NL["Fathom Eel Swarm"]]				= 152,
		[NL["Highland Guppy School"]]			= 153,
		[NL["Mountain Trout School"]]			= 154,
		[NL["Pool of Fire"]]					= 155,
		[NL["Shipwreck Debris"]]				= 156,
		[NL["Deepsea Sagefish School"]]			= 157,
		-- Mists Pools
		[NL["Emperor Salmon School"]]			= 158,
		[NL["Giant Mantis Shrimp Swarm"]]		= 159,
		[NL["Golden Carp School"]]				= 160,
		[NL["Jade Lungfish School"]]			= 161,
		[NL["Krasarang Paddlefish School"]]		= 162,
		[NL["Redbelly Mandarin School"]]		= 163,
		[NL["Reef Octopus Swarm"]]				= 164,
		[NL["Floating Shipwreck Debris"]]		= 165,
		[NL["Jewel Danio School"]]				= 166,
		[NL["Spinefish School"]]				= 167,
		[NL["Tiger Gourami School"]]			= 168,
		-- WoD Pools
		[NL["Abyssal Gulper School"]]			= 169,
		[NL["Oily Abyssal Gulper School"]]		= 170,
		[NL["Blackwater Whiptail School"]]		= 171,
		[NL["Blind Lake Sturgeon School"]]		= 172,
		[NL["Fat Sleeper School"]]				= 173,
		[NL["Fire Ammonite School"]]			= 174,
		[NL["Jawless Skulker School"]]			= 175,
		[NL["Sea Scorpion School"]]				= 176,
		[NL["Oily Sea Scorpion School"]]		= 177,
		[NL["Savage Piranha Pool"]]				= 178,
		--[NL["Lagoon Pool"]]						= 179,
		--[NL["Sparkling Pool"]]					= 180,
		[NL["Felmouth Frenzy School"]]			= 181,
		-- Legion Pools
		[NL["Black Barracuda School"]]			= 182,
		[NL["Cursed Queenfish School"]]			= 183,
		[NL["Runescale Koi School"]]			= 184,
		[NL["Fever of Stormrays"]]				= 185,
		[NL["Highmountain Salmon School"]]		= 186,
		[NL["Mossgill Perch School"]]			= 187,
		-- BfA Pools
		[NL["Frenzied Fangtooth School"]]		= 188,
		[NL["Great Sea Catfish School"]]		= 189,
		[NL["Lane Snapper School"]]				= 190,
		[NL["Rasboralus School"]]				= 191,
		[NL["Redtail Loach School"]]			= 192,
		[NL["Sand Shifter School"]]				= 193,
		[NL["Slimy Mackerel School"]]			= 194,
		[NL["Tiragarde Perch School"]]			= 195,
		[NL["U'taka School"]]					= 196,
		[NL["Mauve Stinger School"]]			= 197,
		[NL["Viper Fish School"]]				= 198,
		[NL["Ionized Minnows"]]					= 199,
		[NL["Sentry Fish School"]]				= 1101,
	},
	["Mining"] = {
		[NL["Copper Vein"]] 					= 201,
		[NL["Tin Vein"]] 						= 202,
		[NL["Iron Deposit"]] 					= 203,
		[NL["Silver Vein"]] 					= 204,
		[NL["Gold Vein"]] 						= 205,
		[NL["Mithril Deposit"]] 				= 206,
		[NL["Ooze Covered Mithril Deposit"]]	= 207,
		[NL["Truesilver Deposit"]] 				= 208,
		[NL["Ooze Covered Silver Vein"]] 		= 209,
		[NL["Ooze Covered Gold Vein"]] 			= 210,
		[NL["Ooze Covered Truesilver Deposit"]] = 211,
		[NL["Ooze Covered Rich Thorium Vein"]] 	= 212,
		[NL["Ooze Covered Thorium Vein"]] 		= 213,
		[NL["Small Thorium Vein"]] 				= 214,
		[NL["Rich Thorium Vein"]] 				= 215,
		--[NL["Hakkari Thorium Vein"]] 			= 216, -- found on in ZG
		[NL["Dark Iron Deposit"]] 				= 217,
		[NL["Lesser Bloodstone Deposit"]] 		= 218,
		[NL["Incendicite Mineral Vein"]] 		= 219,
		[NL["Indurium Mineral Vein"]]			= 220,
		[NL["Fel Iron Deposit"]] 				= 221,
		[NL["Adamantite Deposit"]] 				= 222,
		[NL["Rich Adamantite Deposit"]] 		= 223,
		[NL["Khorium Vein"]] 					= 224,
		[NL["Large Obsidian Chunk"]] 			= 225, -- found only in AQ20/40
		[NL["Small Obsidian Chunk"]] 			= 226, -- found only in AQ20/40
		[NL["Nethercite Deposit"]] 				= 227,
		[NL["Cobalt Deposit"]]					= 228,
		[NL["Rich Cobalt Deposit"]]				= 229,
		[NL["Titanium Vein"]]					= 230,
		[NL["Saronite Deposit"]]				= 231,
		[NL["Rich Saronite Deposit"]]			= 232,
--- Cata nodes
		[NL["Obsidium Deposit"]]				= 233,
		--[NL["Huge Obsidian Slab"]]			= 234,
		[NL["Pure Saronite Deposit"]] 			= 235,
		[NL["Elementium Vein"]]					= 236,
		[NL["Rich Elementium Vein"]]			= 237,
		[NL["Pyrite Deposit"]]					= 238,
		[NL["Rich Obsidium Deposit"]] 			= 239,
		[NL["Rich Pyrite Deposit"]] 			= 240,
-- mists nodes
		[NL["Ghost Iron Deposit"]] 				= 241,
		[NL["Rich Ghost Iron Deposit"]] 		= 242,
		--[NL["Black Trillium Deposit"]]			= 243,
		--[NL["White Trillium Deposit"]]			= 244,
		[NL["Kyparite Deposit"]]				= 245,
		[NL["Rich Kyparite Deposit"]]			= 246,
		[NL["Trillium Vein"]]					= 247,
		[NL["Rich Trillium Vein"]]				= 248,
-- wod nodes
		[NL["True Iron Deposit"]]				= 249,
		[NL["Rich True Iron Deposit"]]			= 250,
		[NL["Blackrock Deposit"]]				= 251,
		[NL["Rich Blackrock Deposit"]]			= 252,
-- legion nodes
		[NL["Leystone Deposit"]]				= 253,
		[NL["Rich Leystone Deposit"]]			= 254,
		[NL["Leystone Seam"]]					= 255,
		[NL["Felslate Deposit"]]				= 256,
		[NL["Rich Felslate Deposit"]]			= 257,
		[NL["Felslate Seam"]]					= 258,
		[NL["Empyrium Deposit"]]				= 259,
		[NL["Rich Empyrium Deposit"]]			= 260,
		[NL["Empyrium Seam"]]					= 261,
-- bfa nodes
		[NL["Monelite Deposit"]]				= 262,
		[NL["Rich Monelite Deposit"]]			= 263,
		[NL["Monelite Seam"]]					= 264,
		[NL["Platinum Deposit"]]				= 265,
		[NL["Rich Platinum Deposit"]]			= 266,
		[NL["Storm Silver Deposit"]]			= 267,
		[NL["Rich Storm Silver Deposit"]]		= 268,
		[NL["Storm Silver Seam"]]				= 269,
		[NL["Osmenite Deposit"]]				= 270,
		[NL["Rich Osmenite Deposit"]]			= 271,
		[NL["Osmenite Seam"]]					= 272,
	},
	["Extract Gas"] = {
		[NL["Windy Cloud"]] 					= 301,
		[NL["Swamp Gas"]] 						= 302,
		[NL["Arcane Vortex"]] 					= 303,
		[NL["Felmist"]] 						= 304,
		[NL["Steam Cloud"]]					    = 305,
		[NL["Cinder Cloud"]]					= 306,
		[NL["Arctic Cloud"]]					= 307,
	},
	["Herb Gathering"] = {
		[NL["Peacebloom"]] 						= 401,
		[NL["Silverleaf"]] 						= 402,
		[NL["Earthroot"]] 						= 403,
		[NL["Mageroyal"]] 						= 404,
		[NL["Briarthorn"]] 						= 405,
		--[NL["Swiftthistle"]] 					= 406, -- found it briathorn nodes
		[NL["Stranglekelp"]] 					= 407,
		[NL["Bruiseweed"]] 						= 408,
		[NL["Wild Steelbloom"]] 				= 409,
		[NL["Grave Moss"]] 						= 410,
		[NL["Kingsblood"]] 						= 411,
		[NL["Liferoot"]] 						= 412,
		[NL["Fadeleaf"]] 						= 413,
		[NL["Goldthorn"]] 						= 414,
		[NL["Khadgar's Whisker"]] 				= 415,
		[NL["Wintersbite"]] 					= 416,
		[NL["Firebloom"]] 						= 417,
		[NL["Purple Lotus"]] 					= 418,
		--[NL["Wildvine"]] 						= 419, -- found in purple lotus nodes
		[NL["Arthas' Tears"]] 					= 420,
		[NL["Sungrass"]] 						= 421,
		[NL["Blindweed"]] 						= 422,
		[NL["Ghost Mushroom"]] 					= 423,
		[NL["Gromsblood"]] 						= 424,
		[NL["Golden Sansam"]] 					= 425,
		[NL["Dreamfoil"]] 						= 426,
		[NL["Mountain Silversage"]] 			= 427,
		[NL["Plaguebloom"]] 					= 428,
		[NL["Icecap"]] 							= 429,
		--[NL["Bloodvine"]] 					= 430, -- zg bush loot
		[NL["Black Lotus"]] 					= 431,
		[NL["Felweed"]] 						= 432,
		[NL["Dreaming Glory"]] 					= 433,
		[NL["Terocone"]] 						= 434,
		[NL["Ancient Lichen"]] 					= 435, -- instance only node
		[NL["Bloodthistle"]] 					= 436,
		[NL["Mana Thistle"]] 					= 437,
		[NL["Netherbloom"]] 					= 438,
		[NL["Nightmare Vine"]] 					= 439,
		[NL["Ragveil"]] 						= 440,
		[NL["Flame Cap"]] 						= 441,
		[NL["Netherdust Bush"]] 				= 442,
		[NL["Adder's Tongue"]]					= 443,
		--[NL["Constrictor Grass"]]				= 444, -- drop form others
		--[NL["Deadnettle"]]					= 445, --looted from other plants
		[NL["Goldclover"]]						= 446,
		[NL["Icethorn"]]						= 447,
		[NL["Lichbloom"]]						= 448,
		[NL["Talandra's Rose"]]					= 449,
		[NL["Tiger Lily"]]						= 450,
		[NL["Firethorn"]]						= 451,
		[NL["Frozen Herb"]]						= 452,
		[NL["Frost Lotus"]]						= 453, -- found in lake wintergrasp only
-- cata nodes
		[NL["Dragon's Teeth"]]					= 454,
		[NL["Sorrowmoss"]]						= 455,
		[NL["Azshara's Veil"]]					= 456,
		[NL["Cinderbloom"]]						= 457,
		[NL["Stormvine"]]						= 458,
		[NL["Heartblossom"]]					= 459,
		[NL["Twilight Jasmine"]]				= 460,
		[NL["Whiptail"]]						= 461,
-- mist nodes
		[NL["Golden Lotus"]]					= 462,
		[NL["Fool's Cap"]]						= 463,
		[NL["Snow Lily"]]						= 464,
		[NL["Silkweed"]]						= 465,
		[NL["Green Tea Leaf"]]					= 466,
		[NL["Rain Poppy"]]						= 467,
		[NL["Sha-Touched Herb"]]				= 468,
-- wod nodes
		[NL["Talador Orchid"]]					= 469,
		[NL["Nagrand Arrowbloom"]]				= 470,
		[NL["Starflower"]]						= 471,
		[NL["Gorgrond Flytrap"]]				= 472,
		[NL["Fireweed"]]						= 473,
		[NL["Frostweed"]]						= 474,
		[NL["Withered Herb"]]					= 475,
-- legion nodes
		[NL["Aethril"]]							= 476,
		[NL["Dreamleaf"]]						= 477,
		[NL["Felwort"]]							= 478,
		[NL["Fjarnskaggl"]]						= 479,
		[NL["Foxflower"]]						= 480,
		[NL["Starlight Rose"]]					= 481,
		[NL["Fel-Encrusted Herb"]]				= 482,
		[NL["Fel-Encrusted Herb Cluster"]]		= 483,
		[NL["Astral Glory"]]					= 484,
-- bfa nodes
		[NL["Akunda's Bite"]]					= 485,
		[NL["Anchor Weed"]]						= 486,
		[NL["Riverbud"]]						= 487,
		[NL["Sea Stalks"]]						= 488,
		[NL["Siren's Sting"]]					= 489,
		[NL["Star Moss"]]						= 490,
		[NL["Winter's Kiss"]]					= 491,
		[NL["Zin'anthid"]]						= 492,
	},
	["Treasure"] = {
		[NL["Giant Clam"]] 						= 501,
		[NL["Battered Chest"]] 					= 502,
		[NL["Tattered Chest"]] 					= 503,
		[NL["Solid Chest"]] 					= 504,
		[NL["Large Iron Bound Chest"]] 			= 505,
		[NL["Large Solid Chest"]] 				= 506,
		[NL["Large Battered Chest"]]			= 507,
		[NL["Buccaneer's Strongbox"]] 			= 508,
		[NL["Large Mithril Bound Chest"]] 		= 509,
		[NL["Large Darkwood Chest"]] 			= 510,
		--[NL["Un'Goro Dirt Pile"]] 			= 511,
		[NL["Bloodpetal Sprout"]] 				= 512,
		--[NL["Blood of Heroes"]] 				= 513,
		[NL["Practice Lockbox"]] 				= 514,
		[NL["Battered Footlocker"]] 			= 515,
		[NL["Waterlogged Footlocker"]] 			= 516,
		[NL["Dented Footlocker"]] 				= 517,
		[NL["Mossy Footlocker"]] 				= 518,
		[NL["Scarlet Footlocker"]] 				= 519,
		[NL["Burial Chest"]] 					= 520,
		[NL["Fel Iron Chest"]] 					= 521,
		[NL["Heavy Fel Iron Chest"]] 			= 522,
		[NL["Adamantite Bound Chest"]] 			= 523,
		[NL["Felsteel Chest"]] 					= 524,
		[NL["Glowcap"]] 						= 525,
		[NL["Wicker Chest"]] 					= 526,
		[NL["Primitive Chest"]] 				= 527,
		[NL["Solid Fel Iron Chest"]] 			= 528,
		[NL["Bound Fel Iron Chest"]] 			= 529,
		[NL["Bound Adamantite Chest"]] 		    = 530, -- instance only node
		[NL["Netherwing Egg"]] 					= 531,
		[NL["Everfrost Chip"]]					= 532,
		[NL["Brightly Colored Egg"]]			= 533,
		[NL["Silken Treasure Chest"]]			= 534,
		[NL["Sturdy Treasure Chest"]]			= 535,
		[NL["Runestone Treasure Chest"]]		= 536,
		[NL["Silverbound Treasure Chest"]]		= 537,
		[NL["Mysterious Camel Figurine"]]       = 538,
		[NL["Dark Iron Treasure Chest"]]        = 539,
		[NL["Maplewood Treasure Chest"]]		= 540,
		[NL["Takk's Nest"]]						= 541,
		[NL["Dart's Nest"]]						= 542,
		[NL["Razormaw Matriarch's Nest"]]		= 543,
		[NL["Ravasaur Matriarch's Nest"]]		= 544,
		[NL["Dark Soil"]]						= 545,
		[NL["Onyx Egg"]]						= 546,
		[NL["Trove of the Thunder King"]]		= 547,
		[NL["Highmaul Reliquary"]]				= 548,
		[NL["Suspiciously Glowing Chest"]]		= 549,
		[NL["Radiating Apexis Shard"]]			= 550,
		[NL["Gleaming Draenic Chest"]]			= 551,
		-- suramar mana
		[NL["Ancient Mana Shard"]]				= 552,
		[NL["Ancient Mana Chunk"]]				= 553,
		[NL["Ancient Mana Crystal"]]			= 554,
		[NL["Leypetal Blossom"]]				= 555,
		[NL["Leypetal Powder"]]					= 556,
		[NL["Glowing Tome"]]					= 557,
		[NL["Mana-Infused Gem"]]				= 558,
		[NL["Twice-Fortified Arcwine"]]			= 559,
		-- bfa 8.2 treasures
		[NL["Mechanized Chest"]]				= 560,
		[NL["Glimmering Chest"]]				= 561,
		[NL["Prismatic Crystal"]]				= 562,
		-- 8.2.5
		[NL["Jelly Deposit"]]					= 563,
		[NL["Large Jelly Deposit"]]				= 564,
	},
	["Archaeology"] = {
		-- cata archeolgy objects
		[NL["Night Elf Archaeology Find"]]      = 601,
		[NL["Troll Archaeology Find"]]          = 602,
		[NL["Dwarf Archaeology Find"]]          = 603,
		[NL["Fossil Archaeology Find"]]         = 604,
		[NL["Draenei Archaeology Find"]]        = 605,
		[NL["Orc Archaeology Find"]]            = 606,
		[NL["Nerubian Archaeology Find"]]       = 607,
		[NL["Vrykul Archaeology Find"]]         = 608,
		[NL["Tol'vir Archaeology Find"]]        = 609,
		[NL["Other Archaeology Find"]]          = 610,
		-- pandaria
		[NL["Pandaren Archaeology Find"]]		= 611,
		[NL["Mogu Archaeology Find"]]			= 612,
		[NL["Mantid Archaeology Find"]]			= 613,
		-- draenor
		[NL["Arakkoa Archaeology Find"]]		= 614,
		[NL["Draenor Clans Archaeology Find"]]	= 615,
		[NL["Ogre Archaeology Find"]]			= 616,
		-- legion
		[NL["Demonic Archaeology Find"]]		= 617,
		[NL["Highborne Archaeology Find"]]		= 618,
		[NL["Highmountain Tauren Archaeology Find"]]	= 619,
		-- bfa
		[NL["Drust Archaeology Find"]]			= 620,
		[NL["Zandalari Archaeology Find"]]		= 621,
	},
	["Logging"] = {
		[NL["Small Timber"]]					= 701,
		[NL["Timber"]]							= 702,
		[NL["Large Timber"]]					= 703,
	},
}
GatherMate.nodeIDs = node_ids
local reverse = {}
for k,v in pairs(node_ids) do
	reverse[k] = GatherMate:CreateReversedTable(v)
end
GatherMate.reverseNodeIDs = reverse
-- Special fix because "Battered Chest" (502) and "Tattered Chest" (503) both translate to "Ramponierte Truhe" in deDE
if GetLocale() == "deDE" then GatherMate.reverseNodeIDs["Treasure"][502] = "Ramponierte Truhe" end

--[[
	Collector data for rare spawn determination
]]
local Collector = GatherMate:GetModule("Collector")
--[[
	Rare spawns are formatted as such the rareid = [nodes it replaces]
]]
local rare_spawns = {
	[204] = {[202]=true,[203]=true}, -- silver
	[205] = {[203]=true,[206]=true}, -- gold
	[208] = {[206]=true,[214]=true,[215]=true}, -- truesilver
	[209] = {[212]=true,[213]=true,[207]=true}, -- oozed covered silver
	[210] = {[212]=true,[213]=true,[207]=true}, -- ooze covered gold
	[211] = {[212]=true,[213]=true,[207]=true}, -- oozed covered true silver
	[217] = {[206]=true,[214]=true,[215]=true}, -- dark iron
	[224] = {[222]=true,[223]=true,[221]=true}, -- khorium
	[223] = {[222]=true}, -- rich adamantite
	[229] = {[228]=true}, -- rich cobalt node
	[232] = {[231]=true}, -- rich saronite node
	[230] = {[231]=true}, -- titanium node
	[441] = {[440]=true}, --flame cap
	[239] = {[233]=true}, -- obsidian
	[237] = {[236]=true}, -- rich elementium
	[238] = {[236]=true}, -- pyrtite
	[240] = {[236]=true}, -- rich pyrite
	[462] = {[462]=true,[463]=true,[464]=true,[465]=true,[466]=true,[467]=true,[468]=true}, -- golden lotus
	[246] = {[245]=true}, -- rich kyparite
	[242] = {[241]=true}, -- rich ghost iron
	[247] = {[242]=true,[241]=true}, -- trillium
	[248] = {[242]=true,[241]=true}, -- rich trillium
	[478] = {[476]=true,[477]=true,[479]=true,[480]=true,[481]=true}, -- felwort
	[254] = {[253]=true}, -- rich leystone deposit
	[257] = {[256]=true}, -- rich feslate deposit
	[260] = {[259]=true}, -- rich empyrium deposit
	[553] = {[552]=true}, -- ancient mana chunk
	[554] = {[552]=true,[553]=true}, -- ancient mana crystal
	[483] = {[482]=true}, -- Fel-encrusted Herb Cluster
	[263] = {[262]=true}, -- rich monelite deposit
	[266] = {[265]=true}, -- rich platinum deposit
	[268] = {[267]=true}, -- rich storm silver deposit
	[486] = {[485]=true,[487]=true,[488]=true,[491]=true,[492]=true}, -- anchor weed
	[271] = {[270]=true}, -- rich osmenite deposit
	[564] = {[563]=true}, -- large jelly deposit
}
Collector.rareNodes = rare_spawns
-- Format zone = { "Database", "new node id"}
local nodeRemap = {
	[78] = { ["Herb Gathering"] = 452},
	[73] = { ["Herb Gathering"] = 452},
}
Collector.specials = nodeRemap
--[[
	Below are Display Module Constants
]]
local Display = GatherMate:GetModule("Display")
local icon_path = "Interface\\AddOns\\GatherMate2\\Artwork\\"
Display.trackingCircle = icon_path.."track_circle.tga"
-- Find xxx spells
Display:SetTrackingSpell("Mining", 2580)
Display:SetTrackingSpell("Herb Gathering", 2383)
Display:SetTrackingSpell("Fishing", 43308)
Display:SetTrackingSpell("Treasure", 2481) -- Left this in, however it appears that the spell no longer exists. Maybe added as a potion TreasureFindingPotion
Display:SetTrackingSpell("Logging", 167924)
-- Profession markers
Display:SetSkillProfession("Herb Gathering", L["Herbalism"])
Display:SetSkillProfession("Mining", L["Mining"])
Display:SetSkillProfession("Fishing", L["Fishing"])
Display:SetSkillProfession("Extract Gas", L["Engineering"])
Display:SetSkillProfession("Archaeology", L["Archaeology"])

--[[
	Textures for display
]]
local node_textures = {
	["Fishing"] = {
		[101] = icon_path.."Fish\\treasure.tga",
		--[102] = icon_path.."Fish\\purewater.tga",
		[103] = icon_path.."Fish\\debris.tga",
		--[104] = icon_path.."Fish\\oilspill.tga",
		[105] = icon_path.."Fish\\firefin.tga",
		[106] = icon_path.."Fish\\greater_sagefish.tga",
		[107] = icon_path.."Fish\\oilyblackmouth.tga",
		[108] = icon_path.."Fish\\sagefish.tga",
		[109] = icon_path.."Fish\\firefin.tga",
		[110] = icon_path.."Fish\\eel.tga",
		--[111] = icon_path.."Fish\\net.tga",
		[112] = icon_path.."Fish\\fish_hook.tga",
		[113] = icon_path.."Fish\\purewater.tga",
		[114] = icon_path.."Fish\\bluefish.tga",
		[115] = icon_path.."Fish\\feltail.tga",
		[116] = icon_path.."Fish\\mudfish.tga",
		[117] = icon_path.."Fish\\darter.tga",
		[118] = icon_path.."Fish\\sporefish.tga",
		[119] = icon_path.."Fish\\steampump.tga",
		[120] = icon_path.."Fish\\net.tga",
		[121] = icon_path.."Fish\\manowar.tga",
		[122] = icon_path.."Fish\\net.tga",
		[123] = icon_path.."Fish\\anglefish.tga",
		[124] = icon_path.."Fish\\herring.tga",
		[125] = icon_path.."Fish\\treasure.tga",
		[126] = icon_path.."Fish\\salmon.tga",
		[127] = icon_path.."Fish\\minnow.tga",
		[128] = icon_path.."Fish\\manta.tga",
		[129] = icon_path.."Fish\\bonescale.tga",
		[130] = icon_path.."Fish\\musselback.tga",
		[131] = icon_path.."Fish\\nettlefish.tga",
		[132] = icon_path.."Fish\\purewater.tga",
		[133] = icon_path.."Fish\\treasure.tga",
		[134] = icon_path.."Fish\\treasure.tga",
		[135] = icon_path.."Fish\\treasure.tga",
		[136] = icon_path.."Fish\\fish_hook.tga",
		--[136] = icon_path.."Fish\\sagefish.tga",
		--[137] = icon_path.."Fish\\oilyblackmouth.tga",
		--[138] = icon_path.."Fish\\oilyblackmouth.tga",
		--[139] = icon_path.."Fish\\oilyblackmouth.tga",
		--[140] = icon_path.."Fish\\oilyblackmouth.tga",
		--[141] = icon_path.."Fish\\firefin.tga",
		--[142] = icon_path.."Fish\\firefin.tga",
		--[143] = icon_path.."Fish\\firefin.tga",
		--[144] = icon_path.."Fish\\firefin.tga",
		--[145] = icon_path.."Fish\\debris.tga",
		--[146] = icon_path.."Fish\\treasure.tga",
		--[147] = icon_path.."Fish\\treasure.tga",
		--[148] = icon_path.."Fish\\treasure.tga",
		[149] = icon_path.."Fish\\salmon.tga",
		--[150] = icon_path.."Fish\\goby.tga",
		[151] = icon_path.."Fish\\mudfish.tga",
		[152] = icon_path.."Fish\\feel.tga",
		[153] = icon_path.."Fish\\hguppy.tga",
		[154] = icon_path.."Fish\\mtrout.tga",
		[155] = icon_path.."Gas\\cinder.tga",
		[156] = icon_path.."Fish\\debris.tga",
		[157] = icon_path.."Fish\\dsagefish.tga",
		[158] = icon_path.."Fish\\emp_salmon.tga",
		[159] = icon_path.."Fish\\matis_shrimp.tga",
		[160] = icon_path.."Fish\\darter.tga",
		[161] = icon_path.."Fish\\lungfish.tga",
		[162] = icon_path.."Fish\\paddle_fish.tga",
		[163] = icon_path.."Fish\\redbelly.tga",
		[164] = icon_path.."Fish\\reef_octopus.tga",
		[165] = icon_path.."Fish\\debris.tga",
		[166] = icon_path.."Fish\\jewel.tga",
		[167] = icon_path.."Fish\\spine.tga",
		[168] = icon_path.."Fish\\tiger.tga",
		[169] = icon_path.."Fish\\abyssalgulper.tga",
		[170] = icon_path.."Fish\\abyssalgulper.tga",
		[171] = icon_path.."Fish\\whiptail.tga",
		[172] = icon_path.."Fish\\sturgeon.tga",
		[173] = icon_path.."Fish\\fatsleeper.tga",
		[174] = icon_path.."Fish\\fireammonite.tga",
		[175] = icon_path.."Fish\\jawlessskulker.tga",
		[176] = icon_path.."Fish\\seascorpion.tga",
		[177] = icon_path.."Fish\\seascorpion.tga",
		[178] = icon_path.."Fish\\piranha.tga",
		[179] = icon_path.."Fish\\fish_hook.tga",
		[180] = icon_path.."Fish\\fish_hook.tga",
		[181] = icon_path.."Fish\\suckerfish.tga",
		[182] = icon_path.."Fish\\fish_hook.tga",
		[183] = icon_path.."Fish\\fish_hook.tga",
		[184] = icon_path.."Fish\\fish_hook.tga",
		[185] = icon_path.."Fish\\fish_hook.tga",
		[186] = icon_path.."Fish\\fish_hook.tga",
		[187] = icon_path.."Fish\\fish_hook.tga",
		[188] = icon_path.."Fish\\frenzied_fangtooth.tga",
		[189] = icon_path.."Fish\\great_sea_catfish.tga",
		[190] = icon_path.."Fish\\lane_snapper.tga",
		[191] = icon_path.."Fish\\rasboralus.tga",
		[192] = icon_path.."Fish\\redtail_loach.tga",
		[193] = icon_path.."Fish\\sand_shifter.tga",
		[194] = icon_path.."Fish\\slimy_mackerel.tga",
		[195] = icon_path.."Fish\\tiragarde_perch.tga",
		[196] = icon_path.."Fish\\utaka.tga",
		[197] = icon_path.."Fish\\mauvestinger.tga",
		[198] = icon_path.."Fish\\viperfish.tga",
		[199] = icon_path.."Fish\\ionizedminnow.tga",
		[1101] = icon_path.."Fish\\sentryfish.tga",
	},
	["Mining"] = {
		[201] = icon_path.."Mine\\copper.tga",
		[202] = icon_path.."Mine\\tin.tga",
		[203] = icon_path.."Mine\\iron.tga",
		[204] = icon_path.."Mine\\silver.tga",
		[205] = icon_path.."Mine\\gold.tga",
		[206] = icon_path.."Mine\\mithril.tga",
		[207] = icon_path.."Mine\\mithril.tga",
		[208] = icon_path.."Mine\\truesilver.tga",
		[209] = icon_path.."Mine\\silver.tga",
		[210] = icon_path.."Mine\\gold.tga",
		[211] = icon_path.."Mine\\truesilver.tga",
		[212] = icon_path.."Mine\\rich_thorium.tga",
		[213] = icon_path.."Mine\\thorium.tga",
		[214] = icon_path.."Mine\\thorium.tga",
		[215] = icon_path.."Mine\\rich_thorium.tga",
		[216] = icon_path.."Mine\\rich_thorium.tga",
		[217] = icon_path.."Mine\\darkiron.tga",
		[218] = icon_path.."Mine\\blood_iron.tga",
		[219] = icon_path.."Mine\\darkiron.tga",
		[220] = icon_path.."Mine\\blood_iron.tga",
		[221] = icon_path.."Mine\\feliron.tga",
		[222] = icon_path.."Mine\\adamantium.tga",
		[223] = icon_path.."Mine\\rich_adamantium.tga",
		[224] = icon_path.."Mine\\khorium.tga",
		[225] = icon_path.."Mine\\ethernium.tga",
		[226] = icon_path.."Mine\\ethernium.tga",
		[227] = icon_path.."Mine\\ethernium.tga",
		[228] = icon_path.."Mine\\cobalt.tga",
		[229] = icon_path.."Mine\\cobalt.tga",
		[230] = icon_path.."Mine\\titanium.tga",
		[231] = icon_path.."Mine\\saronite.tga",
		[232] = icon_path.."Mine\\saronite.tga",
		[233] = icon_path.."Mine\\obsidian.tga",
		--[234] = icon_path.."Mine\\store_tablet.tga",
		[235] = icon_path.."Mine\\saronite.tga",
		[236] = icon_path.."Mine\\elementium.tga",
		[237] = icon_path.."Mine\\elementium.tga",
		[238] = icon_path.."Mine\\pyrite.tga",
		[239] = icon_path.."Mine\\elementium.tga",
		[240] = icon_path.."Mine\\pyrite.tga",
		[241] = icon_path.."Mine\\ghostiron.tga",
		[242] = icon_path.."Mine\\ghostiron.tga",
		--[243] = icon_path.."Mine\\black_trillium.tga",
		--[244] = icon_path.."Mine\\white_trillium.tga",
		[245] = icon_path.."Mine\\kyparite.tga",
		[246] = icon_path.."Mine\\kyparite.tga",
		[247] = icon_path.."Mine\\white_trillium.tga",
		[248] = icon_path.."Mine\\black_trillium.tga",
		[249] = icon_path.."Mine\\trueiron.tga",
		[250] = icon_path.."Mine\\trueiron.tga",
		[251] = icon_path.."Mine\\blackrock.tga",
		[252] = icon_path.."Mine\\blackrock.tga",
		[253] = icon_path.."Mine\\leystone.tga",
		[254] = icon_path.."Mine\\leystone.tga",
		[255] = icon_path.."Mine\\leystone.tga",
		[256] = icon_path.."Mine\\felslate.tga",
		[257] = icon_path.."Mine\\felslate.tga",
		[258] = icon_path.."Mine\\felslate.tga",
		[259] = icon_path.."Mine\\empyrium.tga",
		[260] = icon_path.."Mine\\empyrium.tga",
		[261] = icon_path.."Mine\\empyrium.tga",
		[262] = icon_path.."Mine\\monelite.tga",
		[263] = icon_path.."Mine\\monelite.tga",
		[264] = icon_path.."Mine\\monelite.tga",
		[265] = icon_path.."Mine\\platinum.tga",
		[266] = icon_path.."Mine\\platinum.tga",
		[267] = icon_path.."Mine\\stormsilver.tga",
		[268] = icon_path.."Mine\\stormsilver.tga",
		[269] = icon_path.."Mine\\stormsilver.tga",
		[270] = icon_path.."Mine\\osmenite.tga",
		[271] = icon_path.."Mine\\osmenite.tga",
		[272] = icon_path.."Mine\\osmenite.tga",
	},
	["Extract Gas"] = {
		[301] = icon_path.."Gas\\windy_cloud.tga",
		[302] = icon_path.."Gas\\swamp_gas.tga",
		[303] = icon_path.."Gas\\arcane_vortex.tga",
		[304] = icon_path.."Gas\\felmist.tga",
		[305] = icon_path.."Gas\\steam.tga",
		[306] = icon_path.."Gas\\cinder.tga",
		[307] = icon_path.."Gas\\arctic.tga",
	},
	["Herb Gathering"] = {
		[401] = icon_path.."Herb\\peacebloom.tga",
		[402] = icon_path.."Herb\\silverleaf.tga",
		[403] = icon_path.."Herb\\earthroot.tga",
		[404] = icon_path.."Herb\\mageroyal.tga",
		[405] = icon_path.."Herb\\briarthorn.tga",
		[406] = icon_path.."Herb\\earthroot.tga",
		[407] = icon_path.."Herb\\stranglekelp.tga",
		[408] = icon_path.."Herb\\bruiseweed.tga",
		[409] = icon_path.."Herb\\wild_steelbloom.tga",
		[410] = icon_path.."Herb\\grave_moss.tga",
		[411] = icon_path.."Herb\\kingsblood.tga",
		[412] = icon_path.."Herb\\liferoot.tga",
		[413] = icon_path.."Herb\\fadeleaf.tga",
		[414] = icon_path.."Herb\\goldthorn.tga",
		[415] = icon_path.."Herb\\khadgars_whisker.tga",
		[416] = icon_path.."Herb\\wintersbite.tga",
		[417] = icon_path.."Herb\\firebloom.tga",
		[418] = icon_path.."Herb\\purple_lotus.tga",
		[419] = icon_path.."Herb\\purple_lotus.tga",
		[420] = icon_path.."Herb\\arthas_tears.tga",
		[421] = icon_path.."Herb\\sungrass.tga",
		[422] = icon_path.."Herb\\blindweed.tga",
		[423] = icon_path.."Herb\\ghost_mushroom.tga",
		[424] = icon_path.."Herb\\gromsblood.tga",
		[425] = icon_path.."Herb\\golden_sansam.tga",
		[426] = icon_path.."Herb\\dreamfoil.tga",
		[427] = icon_path.."Herb\\mountain_silversage.tga",
		[428] = icon_path.."Herb\\plaguebloom.tga",
		[429] = icon_path.."Herb\\icecap.tga",
		--[430] = icon_path.."Herb\\purple_lotus.tga",
		[431] = icon_path.."Herb\\black_lotus.tga",
		[432] = icon_path.."Herb\\felweed.tga",
		[433] = icon_path.."Herb\\dreaming_glory.tga",
		[434] = icon_path.."Herb\\terocone.tga",
		[435] = icon_path.."Herb\\ancient_lichen.tga",
		[436] = icon_path.."Herb\\stranglekelp.tga",
		[437] = icon_path.."Herb\\mana_thistle.tga",
		[438] = icon_path.."Herb\\netherbloom.tga",
		[439] = icon_path.."Herb\\nightmare_vine.tga",
		[440] = icon_path.."Herb\\ragveil.tga",
		[441] = icon_path.."Herb\\flame_cap.tga",
		[442] = icon_path.."Herb\\netherdust.tga",
		[443] = icon_path.."Herb\\evergreen.tga",
		[444] = icon_path.."Herb\\constrictor.tga",
		[445] = icon_path.."Herb\\constrictor.tga",
		[446] = icon_path.."Herb\\goldclover.tga",
		[447] = icon_path.."Herb\\icethorn.tga",
		[448] = icon_path.."Herb\\whispervine.tga",
		[449] = icon_path.."Herb\\trose.tga",
		[450] = icon_path.."Herb\\tigerlily.tga",
		[451] = icon_path.."Herb\\briarthorn.tga",
		[452] = icon_path.."Herb\\misc_flower.tga",
		[453] = icon_path.."Herb\\frostlotus.tga",
		[454] = icon_path.."Herb\\dragonsteeth.tga",
		[455] = icon_path.."Herb\\plaguebloom.tga",
		[456] = icon_path.."Herb\\azsharasveil.tga",
		[457] = icon_path.."Herb\\cinderbloom.tga",
		[458] = icon_path.."Herb\\stormvine.tga",
		[459] = icon_path.."Herb\\heartblossom.tga",
		[460] = icon_path.."Herb\\twilightjasmine.tga",
		[461] = icon_path.."Herb\\whiptail.tga",
		[462] = icon_path.."Herb\\golden_lotus.tga",
		[463] = icon_path.."Herb\\fools_cap.tga",
		[464] = icon_path.."Herb\\snow_lily.tga",
		[465] = icon_path.."Herb\\silkweed.tga",
		[466] = icon_path.."Herb\\green_tea_leaf.tga",
		[467] = icon_path.."Herb\\rain_poppy.tga",
		[468] = icon_path.."Herb\\shaherb.tga",
		[469] = icon_path.."Herb\\taladororchid.tga",
		[470] = icon_path.."Herb\\arrowbloom.tga",
		[471] = icon_path.."Herb\\starflower.tga",
		[472] = icon_path.."Herb\\flytrap.tga",
		[473] = icon_path.."Herb\\fireweed.tga",
		[474] = icon_path.."Herb\\frostweed.tga",
		[475] = icon_path.."Herb\\shaherb.tga",
		[476] = icon_path.."Herb\\aethril.tga",
		[477] = icon_path.."Herb\\dreamleaf.tga",
		[478] = icon_path.."Herb\\felwort.tga",
		[479] = icon_path.."Herb\\fjarnskaggl.tga",
		[480] = icon_path.."Herb\\foxflower.tga",
		[481] = icon_path.."Herb\\starlightrose.tga",
		[482] = icon_path.."Herb\\felherb.tga",
		[483] = icon_path.."Herb\\felherb.tga",
		[484] = icon_path.."Herb\\astralglory.tga",
		[485] = icon_path.."Herb\\akundas_bite.tga",
		[486] = icon_path.."Herb\\anchor_weed.tga",
		[487] = icon_path.."Herb\\riverbud.tga",
		[488] = icon_path.."Herb\\seastalk.tga",
		[489] = icon_path.."Herb\\sirens_pollen.tga",
		[490] = icon_path.."Herb\\star_moss.tga",
		[491] = icon_path.."Herb\\winters_kiss.tga",
		[492] = icon_path.."Herb\\zinanthid.tga",
	},
	["Treasure"] = {
		[501] = icon_path.."Treasure\\clam.tga",
		[502] = icon_path.."Treasure\\chest.tga",
		[503] = icon_path.."Treasure\\chest.tga",
		[504] = icon_path.."Treasure\\chest.tga",
		[505] = icon_path.."Treasure\\chest.tga",
		[506] = icon_path.."Treasure\\chest.tga",
		[507] = icon_path.."Treasure\\chest.tga",
		[508] = icon_path.."Treasure\\chest.tga",
		[509] = icon_path.."Treasure\\chest.tga",
		[510] = icon_path.."Treasure\\chest.tga",
		--[511] = icon_path.."Treasure\\soil.tga",
		[512] = icon_path.."Treasure\\sprout.tga",
		--[513] = icon_path.."Treasure\\blood.tga",
		[514] = icon_path.."Treasure\\footlocker.tga",
		[515] = icon_path.."Treasure\\footlocker.tga",
		[516] = icon_path.."Treasure\\footlocker.tga",
		[517] = icon_path.."Treasure\\footlocker.tga",
		[518] = icon_path.."Treasure\\footlocker.tga",
		[519] = icon_path.."Treasure\\footlocker.tga",
		[520] = icon_path.."Treasure\\chest.tga",
		[521] = icon_path.."Treasure\\treasure.tga",
		[522] = icon_path.."Treasure\\treasure.tga",
		[523] = icon_path.."Treasure\\treasure.tga",
		[524] = icon_path.."Treasure\\treasure.tga",
		[525] = icon_path.."Treasure\\mushroom.tga",
		[526] = icon_path.."Treasure\\treasure.tga",
		[527] = icon_path.."Treasure\\treasure.tga",
		[528] = icon_path.."Treasure\\treasure.tga",
		[529] = icon_path.."Treasure\\treasure.tga",
		[530] = icon_path.."Treasure\\treasure.tga",
		[531] = icon_path.."Treasure\\egg.tga",
		[532] = icon_path.."Treasure\\everfrost.tga",
		[533] = icon_path.."Treasure\\egg.tga",
		[534] = icon_path.."Treasure\\treasure.tga",
		[535] = icon_path.."Treasure\\treasure.tga",
		[536] = icon_path.."Treasure\\treasure.tga",
		[537] = icon_path.."Treasure\\treasure.tga",
		[538] = icon_path.."Treasure\\camel.tga",
		[539] = icon_path.."Treasure\\chest.tga",
		[540] = icon_path.."Treasure\\chest.tga",
		[541] = icon_path.."Treasure\\green_raptor.tga",
		[542] = icon_path.."Treasure\\red_raptor.tga",
		[543] = icon_path.."Treasure\\red_raptor.tga",
		[544] = icon_path.."Treasure\\green_raptor.tga",
		[545] = icon_path.."Treasure\\soil.tga",
		[546] = icon_path.."Treasure\\egg.tga",
		[547] = icon_path.."Treasure\\footlocker.tga",
		[548] = icon_path.."Treasure\\treasure.tga",
		[549] = icon_path.."Treasure\\treasure.tga",
		[550] = icon_path.."Treasure\\treasure.tga",
		[551] = icon_path.."Treasure\\treasure.tga",
		[552] = icon_path.."Treasure\\ancient_mana.tga",
		[553] = icon_path.."Treasure\\ancient_mana.tga",
		[554] = icon_path.."Treasure\\ancient_mana.tga",
		[555] = icon_path.."Treasure\\ancient_mana.tga",
		[556] = icon_path.."Treasure\\ancient_mana.tga",
		[557] = icon_path.."Treasure\\ancient_mana.tga",
		[558] = icon_path.."Treasure\\ancient_mana.tga",
		[559] = icon_path.."Treasure\\ancient_mana.tga",
		[560] = icon_path.."Treasure\\treasure.tga",
		[561] = icon_path.."Treasure\\treasure.tga",
		[562] = icon_path.."Treasure\\ancient_mana.tga",
		[563] = icon_path.."Treasure\\honey.tga",
		[564] = icon_path.."Treasure\\honey.tga",
	},
	["Archaeology"] = {
		[601] = icon_path.."Archaeology\\shovel.tga",
		[602] = icon_path.."Archaeology\\shovel.tga",
		[603] = icon_path.."Archaeology\\shovel.tga",
		[604] = icon_path.."Archaeology\\shovel.tga",
		[605] = icon_path.."Archaeology\\shovel.tga",
		[606] = icon_path.."Archaeology\\shovel.tga",
		[607] = icon_path.."Archaeology\\shovel.tga",
		[608] = icon_path.."Archaeology\\shovel.tga",
		[609] = icon_path.."Archaeology\\shovel.tga",
		[610] = icon_path.."Archaeology\\shovel.tga",
		[611] = icon_path.."Archaeology\\shovel.tga",
		[612] = icon_path.."Archaeology\\shovel.tga",
		[613] = icon_path.."Archaeology\\shovel.tga",
		[614] = icon_path.."Archaeology\\shovel.tga",
		[615] = icon_path.."Archaeology\\shovel.tga",
		[616] = icon_path.."Archaeology\\shovel.tga",
		[617] = icon_path.."Archaeology\\shovel.tga",
		[618] = icon_path.."Archaeology\\shovel.tga",
		[619] = icon_path.."Archaeology\\shovel.tga",
		[620] = icon_path.."Archaeology\\shovel.tga",
		[621] = icon_path.."Archaeology\\shovel.tga",
	},
	["Logging"] = {
		[701] = icon_path.."Logging\\timber.tga",
		[702] = icon_path.."Logging\\timber.tga",
		[703] = icon_path.."Logging\\timber.tga",
	},
}
GatherMate.nodeTextures = node_textures

local CLASSIC = 1
local BC      = 2
local WRATH   = 3
local CATA    = 4
local MOP     = 5
local WOD     = 6
local LEGION  = 7
local BFA     = 8
local node_expansion = {
	["Mining"] = {
		[201] = CLASSIC,
		[202] = CLASSIC,
		[203] = CLASSIC,
		[204] = CLASSIC,
		[205] = CLASSIC,
		[206] = CLASSIC,
		[207] = CLASSIC,
		[208] = CLASSIC,
		[209] = CLASSIC,
		[210] = CLASSIC,
		[211] = CLASSIC,
		[212] = CLASSIC,
		[213] = CLASSIC,
		[214] = CLASSIC,
		[215] = CLASSIC,
		[216] = CLASSIC,
		[217] = CLASSIC,
		[218] = CLASSIC,
		[219] = CLASSIC,
		[220] = CLASSIC,
		[221] = BC,
		[222] = BC,
		[223] = BC,
		[224] = BC,
		[225] = BC,
		[226] = BC,
		[227] = BC,
		[228] = WRATH,
		[229] = WRATH,
		[230] = WRATH,
		[231] = WRATH,
		[232] = WRATH,
		[233] = WRATH,
		--[234] = CATA,
		[235] = CATA,
		[236] = CATA,
		[237] = CATA,
		[238] = CATA,
		[239] = CATA,
		[240] = CATA,
		[241] = MOP,
		[242] = MOP,
		--[243] = MOP,
		--[244] = MOP,
		[245] = MOP,
		[246] = MOP,
		[247] = MOP,
		[248] = MOP,
		[249] = WOD,
		[250] = WOD,
		[251] = WOD,
		[252] = WOD,
		[253] = LEGION,
		[254] = LEGION,
		[255] = LEGION,
		[256] = LEGION,
		[257] = LEGION,
		[258] = LEGION,
		[259] = LEGION,
		[260] = LEGION,
		[261] = LEGION,
		[262] = BFA,
		[263] = BFA,
		[264] = BFA,
		[265] = BFA,
		[266] = BFA,
		[267] = BFA,
		[268] = BFA,
		[269] = BFA,
		[270] = BFA,
		[271] = BFA,
		[272] = BFA,
	},
	["Herb Gathering"] = {
		[401] = CLASSIC,
		[402] = CLASSIC,
		[403] = CLASSIC,
		[404] = CLASSIC,
		[405] = CLASSIC,
		[406] = CLASSIC,
		[407] = CLASSIC,
		[408] = CLASSIC,
		[409] = CLASSIC,
		[410] = CLASSIC,
		[411] = CLASSIC,
		[412] = CLASSIC,
		[413] = CLASSIC,
		[414] = CLASSIC,
		[415] = CLASSIC,
		[416] = CLASSIC,
		[417] = CLASSIC,
		[418] = CLASSIC,
		[419] = CLASSIC,
		[420] = CLASSIC,
		[421] = CLASSIC,
		[422] = CLASSIC,
		[423] = CLASSIC,
		[424] = CLASSIC,
		[425] = CLASSIC,
		[426] = CLASSIC,
		[427] = CLASSIC,
		[428] = CLASSIC,
		[429] = CLASSIC,
		--[430] = CLASSIC,
		[431] = CLASSIC,
		[432] = BC,
		[433] = BC,
		[434] = BC,
		[435] = BC,
		[436] = BC,
		[437] = BC,
		[438] = BC,
		[439] = BC,
		[440] = BC,
		[441] = BC,
		[442] = BC,
		[443] = WRATH,
		[444] = WRATH,
		[445] = WRATH,
		[446] = WRATH,
		[447] = WRATH,
		[448] = WRATH,
		[449] = WRATH,
		[450] = WRATH,
		[451] = WRATH,
		[452] = WRATH,
		[453] = WRATH,
		[454] = CATA,
		[455] = CATA,
		[456] = CATA,
		[457] = CATA,
		[458] = CATA,
		[459] = CATA,
		[460] = CATA,
		[461] = CATA,
		[462] = MOP,
		[463] = MOP,
		[464] = MOP,
		[465] = MOP,
		[466] = MOP,
		[467] = MOP,
		[468] = MOP,
		[469] = WOD,
		[470] = WOD,
		[471] = WOD,
		[472] = WOD,
		[473] = WOD,
		[474] = WOD,
		[475] = WOD,
		[476] = LEGION,
		[477] = LEGION,
		[478] = LEGION,
		[479] = LEGION,
		[480] = LEGION,
		[481] = LEGION,
		[482] = LEGION,
		[483] = LEGION,
		[484] = LEGION,
		[485] = BFA,
		[486] = BFA,
		[487] = BFA,
		[488] = BFA,
		[489] = BFA,
		[490] = BFA,
		[491] = BFA,
		[492] = BFA,
	},
}
GatherMate.nodeExpansion = node_expansion

--[[
	Minimap scale settings for zoom
]]
local minimap_size = {
	indoor = {
		[0] = 300, -- scale
		[1] = 240, -- 1.25
		[2] = 180, -- 5/3
		[3] = 120, -- 2.5
		[4] = 80,  -- 3.75
		[5] = 50,  -- 6
	},
	outdoor = {
		[0] = 466 + 2/3, -- scale
		[1] = 400,       -- 7/6
		[2] = 333 + 1/3, -- 1.4
		[3] = 266 + 2/6, -- 1.75
		[4] = 200,       -- 7/3
		[5] = 133 + 1/3, -- 3.5
	},
}
Display.minimapSize = minimap_size
--[[
	Minimap shapes lookup table to determine round of not
	borrowed from strolobe for faster lookups
]]
local minimap_shapes = {
	-- { upper-left, lower-left, upper-right, lower-right }
	["SQUARE"]                = { false, false, false, false },
	["CORNER-TOPLEFT"]        = { true,  false, false, false },
	["CORNER-TOPRIGHT"]       = { false, false, true,  false },
	["CORNER-BOTTOMLEFT"]     = { false, true,  false, false },
	["CORNER-BOTTOMRIGHT"]    = { false, false, false, true },
	["SIDE-LEFT"]             = { true,  true,  false, false },
	["SIDE-RIGHT"]            = { false, false, true,  true },
	["SIDE-TOP"]              = { true,  false, true,  false },
	["SIDE-BOTTOM"]           = { false, true,  false, true },
	["TRICORNER-TOPLEFT"]     = { true,  true,  true,  false },
	["TRICORNER-TOPRIGHT"]    = { true,  false, true,  true },
	["TRICORNER-BOTTOMLEFT"]  = { true,  true,  false, true },
	["TRICORNER-BOTTOMRIGHT"] = { false, true,  true,  true },
}
Display.minimapShapes = minimap_shapes

local map_phasing = {
}

GatherMate.phasing = map_phasing

local map_blacklist = {
	[582] = true, -- Alliance Garrison
	[590] = true, -- Horde Garrison
}

GatherMate.mapBlacklist = map_blacklist
