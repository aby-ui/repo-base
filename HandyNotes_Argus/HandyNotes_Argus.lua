-- For the gnomes!!!
local VERSION = "0.26.6";

local _G = getfenv(0)
-- Libraries
local string = _G.string;
local format = string.format
local gsub = string.gsub
local next = next
local wipe = wipe
local GetItemInfo = _G["GetItemInfo"];
local GameTooltip = GameTooltip
local WorldMapTooltip = WorldMapTooltip
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local Argus = LibStub("AceAddon-3.0"):NewAddon("ArgusRaresTreasures", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
local _L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes_Argus");
if not HandyNotes then return end

local objAtlas = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\ObjectIconsAtlas.blp";
local iconDefaults = {
    skull_grey = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RareWhite.blp",
    skull_purple = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RarePurple.blp",
    skull_blue = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RareBlue.blp",
    skull_yellow = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\RareYellow.blp",
    battle_pet = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\BattlePet.blp",
	treasure = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\Treasure.blp",
	portal = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\Portal.blp",
	default = "Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS",
	eye = "Interface\\Icons\\INV_Misc_Eye_02.blp",
	shadowmend = "Interface\\Icons\\Spell_Priest_Shadow Mend.blp",
	portalGreen = {
		icon = objAtlas,
		tCoordLeft = 219/512, tCoordRight = 243/512, tCoordTop = 108/512, tCoordBottom = 129/512,
	},
	starChest = {
		icon = objAtlas,
		tCoordLeft = 351/512, tCoordRight = 383/512, tCoordTop = 408/512, tCoordBottom = 440/512,
	},
	starChestBlue = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\shootboxes.blp",
		tCoordLeft = 6/256, tCoordRight = 58/256, tCoordTop = 6/64, tCoordBottom = 58/64,
	},
	starChestPurple = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\shootboxes.blp",
		tCoordLeft = (64+6)/256, tCoordRight = (64+58)/256, tCoordTop = 6/64, tCoordBottom = 58/64,
	},
	starChestYellow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\shootboxes.blp",
		tCoordLeft = (128+6)/256, tCoordRight = (128+58)/256, tCoordTop = 6/64, tCoordBottom = 58/64,
	},
	starChestBlank = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\shootboxes.blp",
		tCoordLeft = (192+6)/256, tCoordRight = (192+58)/256, tCoordTop = 6/64, tCoordBottom = 58/64,
	},
	skullWhite = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 0/256, tCoordRight = 40/256, tCoordTop = 0/256, tCoordBottom = 40/256,
	},
	skullWhiteRedGlow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 40/256, tCoordRight = 80/256, tCoordTop = 0/256, tCoordBottom = 40/256,
	},
	skullWhiteGreenGlow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 80/256, tCoordRight = 120/256, tCoordTop = 0/256, tCoordBottom = 40/256,
	},
	skullBlue = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 0/256, tCoordRight = 40/256, tCoordTop = 40/256, tCoordBottom = 80/256,
	},
	skullBlueRedGlow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 40/256, tCoordRight = 80/256, tCoordTop = 40/256, tCoordBottom = 80/256,
	},
	skullBlueGreenGlow = {
		icon = "Interface\\Addons\\HandyNotes_Argus\\Artwork\\skulls.blp",
		tCoordLeft = 80/256, tCoordRight = 120/256, tCoordTop = 40/256, tCoordBottom = 80/256,
	},
}
local itemTypeMisc = 0;
local itemTypePet = 1;
local itemTypeMount = 2;
local itemTypeToy = 3;
local itemTypeTransmog = 4;
local itemTypeTitle = 5;

local allLanguages = {
	deDE = true,
	enGB = true,
	enUS = true,
	esES = true,
	esMX = true,
	frFR = true,
	itIT = true,
	koKR = true,
	ptBR = true,
	ruRU = true,
	zhCN = true,
	zhTW = true,
}

Argus.nodes = {};
local nodes = Argus.nodes;
local nodeRef = {
	rares = {}
};

-- [XXXXYYYY] = { questId, icon, group, label, loot, note, search },
-- /run local find="Cross Gazer"; for i,mid in ipairs(C_MountJournal.GetMountIDs()) do local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID(mid); if ( n:match(find)  then print(j .. " " .. n); end end
-- /run local find="Cross"; for i=0,2200 do local n=C_PetJournal.GetPetInfoBySpeciesID(i); if ( n and string.find(n,find) ) then print(i .. " " .. n); end end
-- { itemId = 152903, itemType = itemTypeMount, mountId = 981 } Biletooth Gnasher any rare??
-- Antoran Wastes
nodes["ArgusCore"] = {
	{ coord = 52702950, npcId = 127291, questId = 48822, icon = "skull_grey", group = "rare_aw", label = _L["Watcher Aival"], search = _L["Watcher Aival_search"], loot = {}, note = _L["Watcher Aival_note"] },
	{ coord = 63902090, npcId = 126040, questId = 48809, icon = "skull_grey", group = "rare_aw", label = _L["Puscilla"], search = _L["Puscilla_search"], loot = { { itemId = 152903, itemType = itemTypeMount, mountId = 981 } }, note = _L["Puscilla_note"] },
	{ coord = 53103580, npcId = 126199, questId = 48810, icon = "skull_grey", group = "rare_aw", label = _L["Vrax'thul"], search = _L["Vrax'thul_search"], loot = { { itemId = 152903, itemType = itemTypeMount, mountId = 981 } }, note = _L["Vrax'thul_note"] },
	{ coord = 63225754, npcId = 126115, questId = 48811, icon = "skull_grey", group = "rare_aw", label = _L["Ven'orn"], search = _L["Ven'orn_search"], loot = {}, note = _L["Ven'orn_note"] },
	{ coord = 64304820, npcId = 126208, questId = 48812, icon = "skull_grey", group = "rare_aw", label = _L["Varga"], search = _L["Varga_search"], loot = { { itemId = 153190, itemType = itemTypeMisc }, { itemId = 153054, itemType = itemTypePet, speciesId = 2118 }, { itemId = 153055, itemType = itemTypePet, speciesId = 2119 }, { itemId = 152841, itemType = itemTypeMount, mountId = 975 }, { itemId = 152843, itemType = itemTypeMount, mountId = 906 }, { itemId = 152842, itemType = itemTypeMount, mountId = 974 }, { itemId = 152840, itemType = itemTypeMount, mountId = 976 } }, note = _L["Varga_note"] },
	{ coord = 62405380, npcId = 126254, questId = 48813, icon = "skull_grey", group = "rare_aw", label = _L["Lieutenant Xakaar"], search = _L["Lieutenant Xakaar_search"], loot = {}, note = _L["Lieutenant Xakaar_note"] },
	{ coord = 61336518, npcId = 126338, questId = 48814, icon = "skull_grey", group = "rare_aw", label = _L["Wrath-Lord Yarez"], search = _L["Wrath-Lord Yarez_search"], loot = { { itemId = 153126, itemType = itemTypeToy } }, note = _L["Wrath-Lord Yarez_note"] },
	{ coord = 60674831, npcId = 126946, questId = 48815, icon = "skull_grey", group = "rare_aw", label = _L["Inquisitor Vethroz"], search = _L["Inquisitor Vethroz_search"], loot = { { itemId = 151543, itemType = itemTypeMisc } }, note = _L["Inquisitor Vethroz_note"] },
	{ coord = 80206230, npcId = nil, questId = 48816, icon = "portalGreen", group = "portal_aw", label = _L["Portal to Commander Texlaz"], loot = {}, note = _L["Portal to Commander Texlaz_note"] },
	{ coord = 82006600, npcId = 127084, questId = 48816, icon = "skull_grey", group = "rare_aw", label = _L["Commander Texlaz"], search = _L["Commander Texlaz_search"], loot = {}, note = _L["Commander Texlaz_note"] },
	{ coord = 73207080, npcId = 127090, questId = 48817, icon = "skull_grey", group = "rare_aw", label = _L["Admiral Rel'var"], search = _L["Admiral Rel'var_search"], loot = { { itemId = 153324, itemType = itemTypeTransmog, slot = _L["Shield"] }, { itemId = 152886, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152888, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152884, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152889, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152885, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152881, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152887, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152883, itemType = itemTypeTransmog, slot = _L["Cloth"] } }, note = _L["Admiral Rel'var_note"] },
	{ coord = 76155614, npcId = 127096, questId = 48818, icon = "skull_grey", group = "rare_aw", label = _L["All-Seer Xanarian"], search = _L["All-Seer Xanarian_search"], loot = {}, note = _L["All-Seer Xanarian_note"] },
	{ coord = 50905530, npcId = 127118, questId = 48820, icon = "skull_grey", group = "rare_aw", label = _L["Worldsplitter Skuul"], search = _L["Worldsplitter Skuul_search"], loot = { { itemId = 153312, itemType = itemTypeTransmog, slot = _L["2h Sword"] }, { itemId = 152886, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152888, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152884, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152889, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152885, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152881, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152887, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152883, itemType = itemTypeTransmog, slot = _L["Cloth"] } }, note = _L["Worldsplitter Skuul_note"] },
	{ coord = 63042455, npcId = 127288, questId = 48821, icon = "skull_grey", group = "rare_aw", label = _L["Houndmaster Kerrax"], search = _L["Houndmaster Kerrax_search"], loot = { { itemId = 152790, itemType = itemTypeMount, mountId = 955 } }, note = _L["Houndmaster Kerrax_note"] },
	{ coord = 55702190, npcId = 127300, questId = 48824, icon = "skull_grey", group = "rare_aw", label = _L["Void Warden Valsuran"], search = _L["Void Warden Valsuran_search"], loot = { { itemId = 153319, itemType = itemTypeTransmog, slot = _L["2h Mace"] }, { itemId = 152886, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152888, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152884, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152889, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152885, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152881, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152887, itemType = itemTypeTransmog, slot = _L["Cloth"] }, { itemId = 152883, itemType = itemTypeTransmog, slot = _L["Cloth"] } }, note = _L["Void Warden Valsuran_note"] },
	{ coord = 61392095, npcId = 127376, questId = 48865, icon = "skull_grey", group = "rare_aw", label = _L["Chief Alchemist Munculus"], search = _L["Chief Alchemist Munculus_search"], loot = {}, note = _L["Chief Alchemist Munculus_note"] },
	{ coord = 54823915, npcId = 127581, questId = 48966, icon = "skull_grey", group = "rare_aw", label = _L["The Many-Faced Devourer"], search = _L["The Many-Faced Devourer_search"], loot = { { itemId = 153195, itemType = itemTypePet, speciesId = 2136 } }, note = _L["The Many-Faced Devourer_note"] },
	{ coord = 77567478, npcId = nil, questId = 48967, icon = "portalGreen", group = "portal_aw", label = _L["Portal to Squadron Commander Vishax"], loot = {}, note = _L["Portal to Squadron Commander Vishax_note"] },
	{ coord = 84368118, npcId = 127700, questId = 48967, icon = "skull_grey", group = "rare_aw", label = _L["Squadron Commander Vishax"], search = _L["Squadron Commander Vishax_search"], loot = { { itemId = 153253, itemType = itemTypeToy } }, note = _L["Squadron Commander Vishax_note"] },
	{ coord = 58001200, npcId = 127703, questId = 48968, icon = "skull_grey", group = "rare_aw", label = _L["Doomcaster Suprax"], search = _L["Doomcaster Suprax_search"], loot = { { itemId = 153194, itemType = itemTypeToy } }, note = _L["Doomcaster Suprax_note"] },
	{ coord = 66981777, npcId = 127705, questId = 48970, icon = "skull_grey", group = "rare_aw", label = _L["Mother Rosula"], search = _L["Mother Rosula_search"], loot = { { itemId = 153252, itemType = itemTypePet, speciesId = 2135, forceUnknown = true } }, note = _L["Mother Rosula_note"] },
	{ coord = 64948290, npcId = 127706, questId = 48971, icon = "skull_grey", group = "rare_aw", label = _L["Rezira the Seer"], search = _L["Rezira the Seer_search"], loot = { { itemId = 153293, itemType = itemTypeToy } }, note = _L["Rezira the Seer_note"] },
	{ coord = 61703720, npcId = 122958, questId = 49183, icon = "skull_grey", group = "rare_aw", label = _L["Blistermaw"], search = _L["Blistermaw_search"], loot = { { itemId = 152905, itemType = itemTypeMount, mountId = 979 } }, note = _L["Blistermaw_note"] },
	{ coord = 57403290, npcId = 122947, questId = 49240, icon = "skull_grey", group = "rare_aw", label = _L["Mistress Il'thendra"], search = _L["Mistress Il'thendra_search"], loot = { { itemId = 153327, itemType = itemTypeTransmog, slot = _L["Dagger"] }, { itemId = 152946, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152944, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152949, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152942, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152947, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152943, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152945, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152948, itemType = itemTypeTransmog, slot = _L["Plate"] } }, note = _L["Mistress Il'thendra_note"] },
	{ coord = 56204550, npcId = 122999, questId = 49241, icon = "skull_grey", group = "rare_aw", label = _L["Gar'zoth"], search = _L["Gar'zoth_search"], loot = {}, note = _L["Gar'zoth_note"] },


	{ coord = 59804030, npcId = 128024, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["One-of-Many"], loot = nil, note = _L["One-of-Many_note"] },
	{ coord = 76707390, npcId = 128023, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Minixis"], loot = nil, note = _L["Minixis_note"] },
	{ coord = 51604140, npcId = 128019, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Watcher"], loot = nil, note = _L["Watcher_note"] },
	{ coord = 56605420, npcId = 128020, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Bloat"], loot = nil, note = _L["Bloat_note"] },
	{ coord = 56102870, npcId = 128021, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Earseeker"], loot = nil, note = _L["Earseeker_note"] },
	{ coord = 64106600, npcId = 128022, questId = 0, icon = "battle_pet", group = "pet_aw", label = _L["Pilfer"], loot = nil, note = _L["Pilfer_note"] },
	
	{ coord = 60214557, npcId = 128134, questId = 0, icon = "eye", group = "npc_aw", label = _L["Orix the All-Seer"], loot = { { itemId = 153204, itemType = itemTypeToy }, { itemId = 153026, itemType = itemTypePet, speciesId = 2115 } }, note = _L["Orix the All-Seer_note"] },

	-- Shoot First, Loot Later
	-- Requires 48201 Reinforce Light's Purchase
	-- and 48202 -> followed by 47473 and/or 48929
	{ coord = 58765894, objId = 277204, questId = 49017, icon = "starChestBlue", group = "sfll_aw", label = _L["Forgotten Legion Supplies"], loot = nil, note = _L["Forgotten Legion Supplies_note"] },
	{ coord = 65973977, objId = 277205, questId = 49018, icon = "starChestYellow", group = "sfll_aw", label = _L["Ancient Legion War Cache"], loot = { { itemId = 153308, itemType = itemTypeTransmog, slot = _L["1h Mace"] } }, note = _L["Ancient Legion War Cache_note"] },
	{ coord = 52192708, objId = 277206, questId = 49019, icon = "starChestYellow", group = "sfll_aw", label = _L["Fel-Bound Chest"], loot = nil, note = _L["Fel-Bound Chest_note"] },
	{ coord = 49145940, objId = 277207, questId = 49020, icon = "starChestBlank", group = "sfll_aw", label = _L["Legion Treasure Hoard"], loot = { { itemId = 153291, itemType = itemTypeTransmog, slot = _L["Staff"] } }, note = _L["Legion Treasure Hoard_note"] },
	{ coord = 75595267, objId = 277208, questId = 49021, icon = "starChestBlank", group = "sfll_aw", label = _L["Timeworn Fel Chest"], loot = nil, note = _L["Timeworn Fel Chest_note"] },
	-- no loot on wowhead yet
	{ coord = 57426366, objId = 277346, questId = 49159, icon = "starChestPurple", group = "sfll_aw", label = _L["Missing Augari Chest"], loot = nil, note = _L["Missing Augari Chest_note"] },

	-- 48382
	{ coord = 67546980, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_67546980_note"] },
	{ coord = 67506226, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_67466226_note"] },
	{ coord = 71326946, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_71326946_note"] },
	{ coord = 58066806, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_58066806_note"] },
	{ coord = 68026624, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_68026624_note"] },
	{ coord = 64506868, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_64506868_note"] },
	{ coord = 62666823, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_62666823_note"] },
	{ coord = 60096945, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_60096945_note"] },
	{ coord = 62146938, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_62146938_note"] },
	{ coord = 69496785, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_69496785_note"] },
	{ coord = 58806467, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_58806467_note"] },
	{ coord = 57796495, questId = 48382, icon = "treasure", group = "treasure_aw", label = "48382", loot = nil, note = _L["48382_57796495_note"] },
	-- 48383
	{ coord = 56853581, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_56903570_note"] },
	{ coord = 57633179, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_57633179_note"] },
	{ coord = 52182918, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_52182918_note"] },
	{ coord = 58174021, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_58174021_note"] },
	{ coord = 51863409, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_51863409_note"] },
	{ coord = 55133930, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_55133930_note"] },
	{ coord = 58413097, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_58413097_note"] },
	{ coord = 53753556, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_53753556_note"] },
	{ coord = 51703529, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_51703529_note"] },
	{ coord = 59853583, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_59853583_note"] },
	{ coord = 58273570, questId = 48383, icon = "treasure", group = "treasure_aw", label = "48383", loot = nil, note = _L["48383_58273570_note"] },
	-- 48384
	{ coord = 60872900, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_60872900_note"] },
	{ coord = 61332054, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_61332054_note"] },
	{ coord = 59081942, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_59081942_note"] },
	{ coord = 64152305, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_64152305_note"] },
	{ coord = 66621709, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_66621709_note"] },
	{ coord = 63682571, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_63682571_note"] },
	{ coord = 61862236, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_61862236_note"] },
	{ coord = 64132738, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_64132738_note"] },
	{ coord = 63522090, questId = 48384, icon = "treasure", group = "treasure_aw", label = "48384", loot = nil, note = _L["48384_63522090_note"] },
	-- 48385
	{ coord = 50605720, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_50605720_note"] },
	{ coord = 55544743, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_55544743_note"] },
	{ coord = 57135124, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_57135124_note"] },
	{ coord = 55915425, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_55915425_note"] },
	{ coord = 48195451, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_48195451_note"] },
	{ coord = 57825901, questId = 48385, icon = "treasure", group = "treasure_aw", label = "48385", loot = nil, note = _L["48385_57825901_note"] },
	-- 48387
	{ coord = 69403965, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_69403965_note"] },
	{ coord = 66643654, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_66643654_note"] },
	{ coord = 69003348, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_68983342_note"] },
	{ coord = 65522831, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_65522831_note"] },
	{ coord = 73404669, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_73404669_note"] },
	{ coord = 67954006, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_67954006_note"] },
	{ coord = 63603642, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_63603642_note"] },
	{ coord = 72404207, questId = 48387, icon = "treasure", group = "treasure_aw", label = "48387", loot = nil, note = _L["48387_72404207_note"] },
	-- 48388
	{ coord = 51502610, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_51502610_note"] },
	{ coord = 59261743, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_59261743_note"] },
	{ coord = 55921387, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_55921387_note"] },
	{ coord = 55841722, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_55841722_note"] },
	{ coord = 55622042, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_55622042_note"] },
	{ coord = 59661398, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_59661398_note"] },
	{ coord = 54102803, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_54102803_note"] },
	{ coord = 55922675, questId = 48388, icon = "treasure", group = "treasure_aw", label = "48388", loot = nil, note = _L["48388_55922675_note"] },
	-- 48389
	{ coord = 64305040, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_64305040_note"] },
	{ coord = 60254351, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_60254351_note"] },
	{ coord = 65514081, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_65514081_note"] },
	{ coord = 60304675, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_60304675_note"] },
	{ coord = 65345192, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_65345192_note"] },
	{ coord = 64114242, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_64114242_note"] },
	{ coord = 58734323, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_58734323_note"] },
	{ coord = 62955007, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_62955007_note"] },
	{ coord = 64254720, questId = 48389, icon = "treasure", group = "treasure_aw", label = "48389", loot = nil, note = _L["48389_64254720_note"] },
	-- 48390
	{ coord = 81306860, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_81306860_note"] },
	{ coord = 80406152, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_80406152_note"] },
	{ coord = 82566503, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_82566503_note"] },
	{ coord = 73316858, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_73316858_note"] },
	{ coord = 77127529, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_77127529_note"] },
	{ coord = 72527293, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_72527293_note"] },
	{ coord = 77255876, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_77255876_note"] },
	{ coord = 72215680, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_72215680_note"] },
	{ coord = 73277299, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_73277299_note"] },
	{ coord = 77975620, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_77975620_note"] },
	{ coord = 77246412, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_77246412_note"] },
	{ coord = 76595659, questId = 48390, icon = "treasure", group = "treasure_aw", label = "48390", loot = nil, note = _L["48390_76595659_note"] },
	-- 48391
	{ coord = 64145876, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_64135867_note"] },
	{ coord = 67424761, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_67404790_note"] },
	{ coord = 63615622, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_63615622_note"] },
	{ coord = 65005049, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_65005049_note"] },
	{ coord = 63035762, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_63035762_note"] },
	{ coord = 65185507, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_65185507_note"] },
	{ coord = 68095075, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_68095075_note"] },
	{ coord = 69815522, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_69815522_note"] },
	{ coord = 71205441, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_71205441_note"] },
	{ coord = 66544668, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_66544668_note"] },
	{ coord = 65164951, questId = 48391, icon = "treasure", group = "treasure_aw", label = "48391", loot = nil, note = _L["48391_65164951_note"] },

}

-- Krokuun
nodes["ArgusSurface"] = {
	{ coord = 44390734, npcId = 125824, questId = 48561, icon = "skull_grey", group = "rare_kr", label = _L["Khazaduum"], search = _L["Khazaduum_search"], loot = { { itemId = 153316, itemType = itemTypeTransmog, slot = _L["2h Sword"] }, { itemId = 152946, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152944, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152949, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152942, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152947, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152943, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152945, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152948, itemType = itemTypeTransmog, slot = _L["Plate"] } }, note = _L["Khazaduum_note"] },
	{ coord = 33007600, npcId = 122912, questId = 48562, icon = "skull_grey", group = "rare_kr", label = _L["Commander Sathrenael"], search = _L["Commander Sathrenael_search"], loot = {}, note = _L["Commander Sathrenael_note"] },
	{ coord = 44505870, npcId = 124775, questId = 48564, icon = "skull_grey", group = "rare_kr", label = _L["Commander Endaxis"], search = _L["Commander Endaxis_search"], loot = { { itemId = 153255, itemType = itemTypeTransmog, slot = _L["1h Mace"] }, { itemId = 152946, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152944, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152949, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152942, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152947, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152943, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152945, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152948, itemType = itemTypeTransmog, slot = _L["Plate"] } }, note = _L["Commander Endaxis_note"] },
	{ coord = 53403090, npcId = 123464, questId = 48565, icon = "skull_grey", group = "rare_kr", label = _L["Sister Subversia"], search = _L["Sister Subversia_search"], loot = { { itemId = 153124, itemType = itemTypeToy } }, note = _L["Sister Subversia_note"] },
	{ coord = 58007480, npcId = 120393, questId = 48627, icon = "skull_grey", group = "rare_kr", label = _L["Siegemaster Voraan"], search = _L["Siegemaster Voraan_search"], loot = {}, note = _L["Siegemaster Voraan_note"] },
	{ coord = 54688126, npcId = 123689, questId = 48628, icon = "skull_grey", group = "rare_kr", label = _L["Talestra the Vile"], search = _L["Talestra the Vile_search"], loot = { { itemId = 153329, itemType = itemTypeTransmog, slot = _L["Dagger"] }, { itemId = 152946, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152944, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152949, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152942, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152947, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152943, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152945, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152948, itemType = itemTypeTransmog, slot = _L["Plate"] } }, note = _L["Talestra the Vile_note"] },
	{ coord = 38145920, npcId = 122911, questId = 48563, icon = "skull_grey", group = "rare_kr", label = _L["Commander Vecaya"], search = _L["Commander Vecaya_search"], loot = { { itemId = 153299, itemType = itemTypeTransmog, slot = _L["1h Sword"] }, { itemId = 152946, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152944, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152949, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152942, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152947, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152943, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152945, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152948, itemType = itemTypeTransmog, slot = _L["Plate"] } }, note = _L["Commander Vecaya_note"] },
	{ coord = 60802080, npcId = 125388, questId = 48629, icon = "skull_grey", group = "rare_kr", label = _L["Vagath the Betrayed"], search = _L["Vagath the Betrayed_search"], loot = { { itemId = 153114, itemType = itemTypeMisc, forceUnknown = true } }, note = _L["Vagath the Betrayed_note"] },
	{ coord = 69605750, npcId = 124804, questId = 48664, icon = "skull_grey", group = "rare_kr", label = _L["Tereck the Selector"], search = _L["Tereck the Selector_search"], loot = { { itemId = 153263, itemType = itemTypeTransmog, slot = _L["1h Axe"] }, { itemId = 152946, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152944, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152949, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152942, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152947, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152943, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152945, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152948, itemType = itemTypeTransmog, slot = _L["Plate"] } }, note = _L["Tereck the Selector_note"] },
	{ coord = 69708050, npcId = 125479, questId = 48665, icon = "skull_grey", group = "rare_kr", label = _L["Tar Spitter"], search = _L["Tar Spitter_search"], loot = {}, note = _L["Tar Spitter_note"] },
	{ coord = 41707020, npcId = 125820, questId = 48666, icon = "skull_grey", group = "rare_kr", label = _L["Imp Mother Laglath"], search = _L["Imp Mother Laglath_search"], loot = {}, note = _L["Imp Mother Laglath_note"] },
	{ coord = 71063274, npcId = 126419, questId = 48667, icon = "skull_grey", group = "rare_kr", label = _L["Naroua"], search = _L["Naroua_search"], loot = { { itemId = 153190, itemType = itemTypeMisc }, { itemId = 153054, itemType = itemTypePet, speciesId = 2118 }, { itemId = 153055, itemType = itemTypePet, speciesId = 2119 }, { itemId = 152841, itemType = itemTypeMount, mountId = 975 }, { itemId = 152843, itemType = itemTypeMount, mountId = 906 }, { itemId = 152842, itemType = itemTypeMount, mountId = 974 }, { itemId = 152840, itemType = itemTypeMount, mountId = 976 } }, note = _L["Naroua_note"] },

	{ coord = 43005200, npcId = 128009, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Baneglow"], loot = nil, note = _L["Baneglow_note"] },
	{ coord = 51506380, npcId = 128008, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Foulclaw"], loot = nil, note = _L["Foulclaw_note"] },
	{ coord = 66847263, npcId = 128007, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Ruinhoof"], loot = nil, note = _L["Ruinhoof_note"] },
	{ coord = 29605790, npcId = 128011, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Deathscreech"], loot = nil, note = _L["Deathscreech_note"] },
	{ coord = 39606650, npcId = 128012, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Gnasher"], loot = nil, note = _L["Gnasher_note"] },
	{ coord = 58302970, npcId = 128010, questId = 0, icon = "battle_pet", group = "pet_kr", label = _L["Retch"], loot = nil, note = _L["Retch_note"] },

	-- Shoot First, Loot Later
	{ coord = 51407622, objId = 276490, questId = 48884, icon = "starChestBlue", group = "sfll_kr", label = _L["Krokul Emergency Cache"], loot = { { itemId = 153304, itemType = itemTypeTransmog, slot = _L["1h Axe"] } }, note = _L["Krokul Emergency Cache_note"] },
	{ coord = 62783753, objId = 276489, questId = 48885, icon = "starChestYellow", group = "sfll_kr", label = _L["Legion Tower Chest"], loot = nil, note = _L["Legion Tower Chest_note"] },
	{ coord = 48555894, objId = 276491, questId = 48886, icon = "starChestYellow", group = "sfll_kr", label = _L["Lost Krokul Chest"], loot = nil, note = _L["Lost Krokul Chest_note"] },
	{ coord = 75176975, objId = 277343, questId = 49154, icon = "starChestPurple", group = "sfll_kr", label = _L["Long-Lost Augari Treasure"], loot = nil, note = _L["Long-Lost Augari Treasure_note"] },
	{ coord = 55937428, objId = 277344, questId = 49156, icon = "starChestPurple", group = "sfll_kr", label = _L["Precious Augari Keepsakes"], loot = nil, note = _L["Precious Augari Keepsakes_note"] },

	-- 47752
	{ coord = 55555863, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_55555863_note"] },
	{ coord = 52185431, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_52185431_note"] },
	{ coord = 50405122, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_50405122_note"] },
	{ coord = 53265096, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_53265096_note"] },
	{ coord = 57005472, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_57005472_note"] },
	{ coord = 59695196, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_59695196_note"] },
	{ coord = 51425958, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_51425958_note"] },
	{ coord = 55525237, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_55525237_note"] },
	{ coord = 58375051, questId = 47752, icon = "treasure", group = "treasure_kr", label = "47752", loot = nil, note = _L["47752_58375051_note"] },
	-- 47753
	{ coord = 53167308, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_53167308_note"] },
	{ coord = 55228114, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_55228114_note"] },
	{ coord = 59267341, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_59267341_note"] },
	{ coord = 56118037, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_56118037_note"] },
	{ coord = 58597958, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_58597958_note"] },
	{ coord = 58207164, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_58197157_note"] },
	{ coord = 52737591, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_52737591_note"] },
	{ coord = 58048036, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_58048036_note"] },
	{ coord = 60297610, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_60297610_note"] },
	{ coord = 56827212, questId = 47753, icon = "treasure", group = "treasure_kr", label = "47753", loot = nil, note = _L["47753_56827212_note"] },
	-- 47997
	{ coord = 45876777, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_45876777_note"] },
	{ coord = 45797753, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_45797753_note"] },
	{ coord = 43858139, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_43858139_note"] },
	{ coord = 43816689, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_43816689_note"] },
	{ coord = 40687531, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_40687531_note"] },
	{ coord = 46996831, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_46996831_note"] },
	{ coord = 41438003, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_41438003_note"] },
	{ coord = 41548379, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_41548379_note"] },
	{ coord = 46458665, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_46458665_note"] },
	{ coord = 40357414, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_40357414_note"] },
	{ coord = 44198653, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_44198653_note"] },
	{ coord = 46787984, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_46787984_note"] },
	{ coord = 42737546, questId = 47997, icon = "treasure", group = "treasure_kr", label = "47997", loot = nil, note = _L["47997_42737546_note"] },
	-- 47999
	{ coord = 62592581, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_62592581_note"] },
	{ coord = 59763951, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_59763951_note"] },
	{ coord = 59071884, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_59071884_note"] },
	{ coord = 61643520, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_61643520_note"] },
	{ coord = 61463580, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_61463580_note"] },
	{ coord = 59603052, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_59603052_note"] },
	{ coord = 60891852, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_60891852_note"] },
	{ coord = 49063350, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_49063350_note"] },
	{ coord = 65992286, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_65992286_note"] },
	{ coord = 64632319, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_64632319_note"] },
	{ coord = 51533583, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_51533583_note"] },
	{ coord = 60422354, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_60422354_note"] },
	{ coord = 62763812, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_62763812_note"] },
	{ coord = 60492781, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_60492781_note"] },
	{ coord = 46768337, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_46768337_note"] },
	{ coord = 59433273, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_59433273_note"] },
	{ coord = 58442866, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_58442866_note"] },
	{ coord = 48613092, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_48613092_note"] },
	{ coord = 57642617, questId = 47999, icon = "treasure", group = "treasure_kr", label = "47999", loot = nil, note = _L["47999_57642617_note"] },
	-- 48000
	{ coord = 70907370, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_70907370_note"] },
	{ coord = 74136790, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_74136790_note"] },
	{ coord = 75166435, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_75166435_note"] },
	{ coord = 69605772, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_69605772_note"] },
	{ coord = 69787836, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_69787836_note"] },
	{ coord = 68566054, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_68566054_note"] },
	{ coord = 72896482, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_72896482_note"] },
	{ coord = 71827536, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_71827536_note"] },
	{ coord = 73577146, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_73577146_note"] },
	{ coord = 71846166, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_71846166_note"] },
	{ coord = 67886231, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_67886231_note"] },
	{ coord = 74996922, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_74996922_note"] },
	{ coord = 62946824, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_62946824_note"] },
	{ coord = 69386278, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_69386278_note"] },
	{ coord = 67656999, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_67656999_note"] },
	{ coord = 69218397, questId = 48000, icon = "treasure", group = "treasure_kr", label = "48000", loot = nil, note = _L["48000_69218397_note"] },
	-- 48336
	{ coord = 33575511, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_33575511_note"] },
	{ coord = 32047441, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_32047441_note"] },
	{ coord = 27196668, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_27196668_note"] },
	{ coord = 31936750, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_31936750_note"] },
	{ coord = 35415637, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_35415637_note"] },
	{ coord = 29645761, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_29645761_note"] },
	{ coord = 40526067, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_40526067_note"] },
	{ coord = 36205543, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_36205543_note"] },
	{ coord = 25996814, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_25996814_note"] },
	{ coord = 37176401, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_37176401_note"] },
	{ coord = 28247134, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_28247134_note"] },
	{ coord = 30276403, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_30276403_note"] },
	{ coord = 34566305, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_34566305_note"] },
	{ coord = 36605881, questId = 48336, icon = "treasure", group = "treasure_kr", label = "48336", loot = nil, note = _L["48336_36605881_note"] },
	-- 48339
	{ coord = 68533891, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_68533891_note"] },
	{ coord = 63054240, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_63054240_note"] },
	{ coord = 64964156, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_64964156_note"] },
	{ coord = 73393438, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_73393438_note"] },
	{ coord = 72213234, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_72213234_note"] },
	{ coord = 65983499, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_65983499_note"] },
	{ coord = 64934217, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_64934217_note"] },
	{ coord = 67713454, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_67713454_note"] },
	{ coord = 72493605, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_72493605_note"] },
	{ coord = 44864342, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_44864342_note"] },
	{ coord = 46094082, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_46094082_note"] },
	{ coord = 70503063, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_70503063_note"] },
	{ coord = 61876413, questId = 48339, icon = "treasure", group = "treasure_kr", label = "48339", loot = nil, note = _L["48339_61876413_note"] },

}

nodes["ArgusCitadelSpire"] = {
	{ coord = 38954032, npcId = 125824, questId = 48561, icon = "skull_grey", group = "rare_kr", label = _L["Khazaduum"], search = _L["Khazaduum_search"], loot = { { itemId = 153316, itemType = itemTypeTransmog, slot = _L["2h Sword"] }, { itemId = 152946, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152944, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152949, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152942, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152947, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152943, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152945, itemType = itemTypeTransmog, slot = _L["Plate"] }, { itemId = 152948, itemType = itemTypeTransmog, slot = _L["Plate"] } }, note = _L["Khazaduum_note"] },
}

-- Mac'Aree
nodes["ArgusMacAree"] = {
	{ coord = 44607160, npcId = 122838, questId = 48692, icon = "skull_grey", group = "rare_ma", label = _L["Shadowcaster Voruun"], search = _L["Shadowcaster Voruun_search"], loot = { { itemId = 153296, itemType = itemTypeTransmog, slot = _L["1h Sword"] } }, note = _L["Shadowcaster Voruun_note"] },
	{ coord = 52976684, npcId = 126815, questId = 48693, icon = "skull_grey", group = "rare_ma", label = _L["Soultwisted Monstrosity"], search = _L["Soultwisted Monstrosity_search"], loot = {}, note = _L["Soultwisted Monstrosity_note"] },
	{ coord = 55536016, npcId = 126852, questId = 48695, icon = "skull_grey", group = "rare_ma", label = _L["Wrangler Kravos"], search = _L["Wrangler Kravos_search"], loot = { { itemId = 153269, itemType = itemTypeTransmog, slot = _L["1h Axe"] }, { itemId = 152814, itemType = itemTypeMount, mountId = 970 } }, note = _L["Wrangler Kravos_note"] },
	{ coord = 38705580, npcId = 126860, questId = 48697, icon = "skull_grey", group = "rare_ma", label = _L["Kaara the Pale"], search = _L["Kaara the Pale_search"], loot = { { itemId = 153190, itemType = itemTypeMisc }, { itemId = 153054, itemType = itemTypePet, speciesId = 2118 }, { itemId = 153055, itemType = itemTypePet, speciesId = 2119 }, { itemId = 152841, itemType = itemTypeMount, mountId = 975 }, { itemId = 152843, itemType = itemTypeMount, mountId = 906 }, { itemId = 152842, itemType = itemTypeMount, mountId = 974 }, { itemId = 152840, itemType = itemTypeMount, mountId = 976 } }, note = _L["Kaara the Pale_note"] },
	{ coord = 41121149, npcId = 126864, questId = 48702, icon = "skull_grey", group = "rare_ma", label = _L["Feasel the Muffin Thief"], search = _L["Feasel the Muffin Thief_search"], loot = { { itemId = 152998, itemType = itemTypeMisc } }, note = _L["Feasel the Muffin Thief_note"] },
	{ coord = 36682383, npcId = 126865, questId = 48703, icon = "skull_grey", group = "rare_ma", label = _L["Vigilant Thanos"], search = _L["Vigilant Thanos_search"], loot = { { itemId = 153322, itemType = itemTypeTransmog, slot = _L["Shield"] }, { itemId = 153183, itemType = itemTypeToy } }, note = _L["Vigilant Thanos_note"] },
	{ coord = 63806460, npcId = 126866, questId = 48704, icon = "skull_grey", group = "rare_ma", label = _L["Vigilant Kuro"], search = _L["Vigilant Kuro_search"], loot = { { itemId = 153323, itemType = itemTypeTransmog, slot = _L["Shield"] }, { itemId = 153183, itemType = itemTypeToy } }, note = _L["Vigilant Kuro_note"] },
	{ coord = 33654801, npcId = 126867, questId = 48705, icon = "skull_grey", group = "rare_ma", label = _L["Venomtail Skyfin"], search = _L["Venomtail Skyfin_search"], loot = { { itemId = 152844, itemType = itemTypeMount, mountId = 973 } }, note = _L["Venomtail Skyfin_note"] },
	{ coord = 38226435, npcId = 126868, questId = 48706, icon = "skull_grey", group = "rare_ma", label = _L["Turek the Lucid"], search = _L["Turek the Lucid_search"], loot = { { itemId = 153306, itemType = itemTypeTransmog, slot = _L["1h Axe"] } }, note = _L["Turek the Lucid_note"] },
	{ coord = 27192995, npcId = 126869, questId = 48707, icon = "skull_grey", group = "rare_ma", label = _L["Captain Faruq"], search = _L["Captain Faruq_search"], loot = {}, note = _L["Captain Faruq_note"] },
	{ coord = 34943711, npcId = 126885, questId = 48708, icon = "skull_grey", group = "rare_ma", label = _L["Umbraliss"], search = _L["Umbraliss_search"], loot = {}, note = _L["Umbraliss_note"] },
	{ coord = 70294598, npcId = 126889, questId = 48710, icon = "skull_grey", group = "rare_ma", label = _L["Sorolis the Ill-Fated"], search = _L["Sorolis the Ill-Fated_search"], loot = { { itemId = 153292, itemType = itemTypeTransmog, slot = _L["Staff"] } }, note = _L["Sorolis the Ill-Fated_note"] },
	{ coord = 35965897, npcId = 126896, questId = 48711, icon = "skull_grey", group = "rare_ma", label = _L["Herald of Chaos"], search = _L["Herald of Chaos_search"], loot = {}, note = _L["Herald of Chaos_note"] },
	{ coord = 44204980, npcId = 126898, questId = 48712, icon = "skull_grey", group = "rare_ma", label = _L["Sabuul"], search = _L["Sabuul_search"], loot = { { itemId = 153190, itemType = itemTypeMisc }, { itemId = 153054, itemType = itemTypePet, speciesId = 2118 }, { itemId = 153055, itemType = itemTypePet, speciesId = 2119 }, { itemId = 152841, itemType = itemTypeMount, mountId = 975 }, { itemId = 152843, itemType = itemTypeMount, mountId = 906 }, { itemId = 152842, itemType = itemTypeMount, mountId = 974 }, { itemId = 152840, itemType = itemTypeMount, mountId = 976 } }, note = _L["Sabuul_note"] },
	{ coord = 48504090, npcId = 126899, questId = 48713, icon = "skull_grey", group = "rare_ma", label = _L["Jed'hin Champion Vorusk"], search = _L["Jed'hin Champion Vorusk_search"], loot = { { itemId = 153302, itemType = itemTypeTransmog, slot = _L["1h Sword"] } }, note = _L["Jed'hin Champion Vorusk_note"] },
	{ coord = 58783762, npcId = 124440, questId = 48714, icon = "skull_grey", group = "rare_ma", label = _L["Overseer Y'Beda"], search = _L["Overseer Y'Beda_search"], loot = { { itemId = 153315, itemType = itemTypeTransmog, slot = _L["2h Sword"] } }, note = _L["Overseer Y'Beda_note"] },
	{ coord = 58003090, npcId = 125497, questId = 48716, icon = "skull_grey", group = "rare_ma", label = _L["Overseer Y'Sorna"], search = _L["Overseer Y'Sorna_search"], loot = { { itemId = 153268, itemType = itemTypeTransmog, slot = _L["1h Axe"] } }, note = _L["Overseer Y'Sorna_note"] },
	{ coord = 60982982, npcId = 125498, questId = 48717, icon = "skull_grey", group = "rare_ma", label = _L["Overseer Y'Morna"], search = _L["Overseer Y'Morna_search"], loot = { { itemId = 153257, itemType = itemTypeTransmog, slot = _L["1h Mace"] } }, note = _L["Overseer Y'Morna_note"] },
	{ coord = 61575035, npcId = 126900, questId = 48718, icon = "skull_grey", group = "rare_ma", label = _L["Instructor Tarahna"], search = _L["Instructor Tarahna_search"], loot = { { itemId = 153309, itemType = itemTypeTransmog, slot = _L["1h Mace"] }, { itemId = 153179, itemType = itemTypeToy }, { itemId = 153180, itemType = itemTypeToy }, { itemId = 153181, itemType = itemTypeToy } }, note = _L["Instructor Tarahna_note"] },
	{ coord = 66742845, npcId = 126908, questId = 48719, icon = "skull_grey", group = "rare_ma", label = _L["Zul'tan the Numerous"], search = _L["Zul'tan the Numerous_search"], loot = {}, note = _L["Zul'tan the Numerous_note"] },
	{ coord = 56801450, npcId = 126910, questId = 48720, icon = "skull_grey", group = "rare_ma", label = _L["Commander Xethgar"], search = _L["Commander Xethgar_search"], loot = {}, note = _L["Commander Xethgar_note"] },
	{ coord = 49870953, npcId = 126912, questId = 48721, icon = "skull_grey", group = "rare_ma", label = _L["Skreeg the Devourer"], search = _L["Skreeg the Devourer_search"], loot = { { itemId = 152904, itemType = itemTypeMount, mountId = 980 } }, note = _L["Skreeg the Devourer_note"] },
	{ coord = 43846065, npcId = 126862, questId = 48700, icon = "skull_grey", group = "rare_ma", label = _L["Baruut the Bloodthirsty"], search = _L["Baruut the Bloodthirsty_search"], loot = { { itemId = 153193, itemType = itemTypeToy } }, note = _L["Baruut the Bloodthirsty_note"] },
	{ coord = 30124019, npcId = 126887, questId = 48709, icon = "skull_grey", group = "rare_ma", label = _L["Ataxon"], search = _L["Ataxon_search"], loot = { { itemId = 153056, itemType = itemTypePet, speciesId = 2120, forceUnknown = true } }, note = _L["Ataxon_note"] },
	{ coord = 49505280, npcId = 126913, questId = 48935, icon = "skull_grey", group = "rare_ma", label = _L["Slithon the Last"], search = _L["Slithon the Last_search"], loot = { { itemId = 153203, itemType = itemTypeMisc, forceUnknown = true } }, note = _L["Slithon the Last_note"] },

	{ coord = 60007110, npcId = 128015, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Gloamwing"], loot = nil, note = _L["Gloamwing_note"] },
	{ coord = 67604390, npcId = 128013, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Bucky"], loot = nil, note = _L["Bucky_note"] },
	{ coord = 74703620, npcId = 128018, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Mar'cuus"], loot = nil, note = _L["Mar'cuus_note"] },
	{ coord = 69705190, npcId = 128014, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Snozz"], loot = nil, note = _L["Snozz_note"] },
	{ coord = 31903120, npcId = 128017, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Corrupted Blood of Argus"], loot = nil, note = _L["Corrupted Blood of Argus_note"] },
	{ coord = 36005410, npcId = 128016, questId = 0, icon = "battle_pet", group = "pet_ma", label = _L["Shadeflicker"], loot = nil, note = _L["Shadeflicker_note"] },
	
	{ coord = 42316334, npcId = 127037, questId = 0, icon = "shadowmend", group = "npc_ma", label = _L["Nabiru"], loot = { { itemId = 152096, itemType = itemTypeMisc } }, note = _L["Nabiru_note"] },
	
	-- Shoot First, Loot Later
	{ coord = 42900549, objId = 276223, questId = 48743, icon = "starChestBlue", group = "sfll_ma", label = _L["Eredar Treasure Cache"], loot = nil, note = _L["Eredar Treasure Cache_note"] },
	{ coord = 50583838, objId = 276224, questId = 48744, icon = "starChestYellow", group = "sfll_ma", label = _L["Chest of Ill-Gotten Gains"], loot = nil, note = _L["Chest of Ill-Gotten Gains_note"] },
	{ coord = 61127256, objId = 276225, questId = 48745, icon = "starChestYellow", group = "sfll_ma", label = _L["Student's Surprising Surplus"], loot = nil, note = _L["Student's Surprising Surplus_note"] },
	{ coord = 40275146, objId = 276226, questId = 48747, icon = "starChestBlue", group = "sfll_ma", label = _L["Void-Tinged Chest"], loot = nil, note = _L["Void-Tinged Chest_note"] },
	{ coord = 70305974, objId = 276227, questId = 48748, icon = "starChestBlank", group = "sfll_ma", label = _L["Augari Secret Stash"], loot = nil, note = _L["Augari Secret Stash_note"] },
	{ coord = 57047684, objId = 276228, questId = 48749, icon = "starChestBlank", group = "sfll_ma", label = _L["Desperate Eredar's Cache"], loot = { { itemId = 153267, itemType = itemTypeTransmog, slot = _L["1h Axe"] } }, note = _L["Desperate Eredar's Cache_note"] },
	{ coord = 27274014, objId = 276229, questId = 48750, icon = "starChestBlank", group = "sfll_ma", label = _L["Shattered House Chest"], loot = nil, note = _L["Shattered House Chest_note"] },
	{ coord = 43345447, objId = 276230, questId = 48751, icon = "starChestBlank", group = "sfll_ma", label = _L["Doomseeker's Treasure"], loot = { { itemId = 153313, itemType = itemTypeTransmog, slot = _L["2h Sword"] } }, note = _L["Doomseeker's Treasure_note"] },
	{ coord = 70632744, objId = 277327, questId = 49129, icon = "starChestPurple", group = "sfll_ma", label = _L["Augari-Runed Chest"], loot = nil, note = _L["Augari-Runed Chest_note"] },
	{ coord = 62132247, objId = 277340, questId = 49151, icon = "starChestPurple", group = "sfll_ma", label = _L["Secret Augari Chest"], loot = nil, note = _L["Secret Augari Chest_note"] },
	{ coord = 40856975, objId = 277342, questId = 49153, icon = "starChestPurple", group = "sfll_ma", label = _L["Augari Goods"], loot = nil, note = _L["Augari Goods_note"] },

	-- Ancient Eredar Cache
	-- 48346
	{ coord = 55167766, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_55167766_note"] },
	{ coord = 59386372, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_59386372_note"] },
	{ coord = 57486159, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_57486159_note"] },
	{ coord = 50836729, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_50836729_note"] },
	{ coord = 52868241, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_52868241_note"] },
	{ coord = 47186234, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_47186234_note"] },
	{ coord = 50107580, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_50107580_note"] },
	{ coord = 53328001, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_53328001_note"] },
	{ coord = 55297347, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_55297347_note"] },
	{ coord = 52696161, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_52696161_note"] },
	{ coord = 54806710, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_54806710_note"] },
	{ coord = 51677163, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_51677163_note"] },
	{ coord = 57397517, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_57397517_note"] },
	{ coord = 61047074, questId = 48346, icon = "treasure", group = "treasure_ma", label = "48346", loot = nil, note = _L["48346_61047074_note"] },
	-- 48350
	{ coord = 59622088, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_59622088_note"] },
	{ coord = 60493338, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_60493338_note"] },
	{ coord = 53912335, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_53912335_note"] },
	{ coord = 55063508, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_55063508_note"] },
	{ coord = 62202636, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_62202636_note"] },
	{ coord = 53332740, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_53332740_note"] },
	{ coord = 58584077, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_58574078_note"] },
	{ coord = 63262000, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_63262000_note"] },
	{ coord = 54952484, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_54952484_note"] },
	{ coord = 63332255, questId = 48350, icon = "treasure", group = "treasure_ma", label = "48350", loot = nil, note = _L["48350_63332255_note"] },
	-- 48351
	{ coord = 43637134, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_43637134_note"] },
	{ coord = 34205929, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_34205929_note"] },
	{ coord = 43955630, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_43955630_note"] },
	{ coord = 46917346, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_46917346_note"] },
	{ coord = 36296646, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_36296646_note"] },
	{ coord = 42645361, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_42645361_note"] },
	{ coord = 38126342, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_38126342_note"] },
	{ coord = 42395752, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_42395752_note"] },
	{ coord = 39175934, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_39175934_note"] },
	{ coord = 43555993, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_43555993_note"] },
	{ coord = 35535718, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_35535717_note"] }, -- check
	{ coord = 43666847, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_43666847_note"] },
	{ coord = 38386704, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_38386704_note"] },
	{ coord = 35635604, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_35635604_note"] },
	{ coord = 33795558, questId = 48351, icon = "treasure", group = "treasure_ma", label = "48351", loot = nil, note = _L["48351_33795558_note"] },
	-- 48357
	{ coord = 49412387, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_49412387_note"] },
	{ coord = 47672180, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_47672180_note"] },
	{ coord = 48482115, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_48482115_note"] },
	{ coord = 57881053, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_57881053_note"] },
	{ coord = 52871676, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_52871676_note"] },
	{ coord = 47841956, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_47841956_note"] },
	{ coord = 51802871, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_51802871_note"] },
	{ coord = 49912946, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_49912946_note"] },
	{ coord = 54951750, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_54951750_note"] },
	{ coord = 46381509, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_46381509_note"] },
	{ coord = 50021442, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_50021442_note"] },
	{ coord = 52631644, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_52631644_note"] },
	{ coord = 45981325, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_45981325_note"] },
	{ coord = 44571860, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_44571860_note"] },
	{ coord = 53491281, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_53491281_note"] },
	{ coord = 45241327, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_45241327_note"] },
	{ coord = 48251289, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_48251289_note"] },
	{ coord = 44952483, questId = 48357, icon = "treasure", group = "treasure_ma", label = "48357", loot = nil, note = _L["48357_44952483_note"] },
	-- 48371
	{ coord = 48604971, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_48604971_note"] },
	{ coord = 49865494, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_49865494_note"] },
	{ coord = 47023655, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_47023655_note"] },
	{ coord = 49623585, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_49623585_note"] },
	{ coord = 51094790, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_51094790_note"] },
	{ coord = 35535718, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_35535718_note"] },
	{ coord = 25383016, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_25383016_note"] },
	{ coord = 53594211, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_53594211_note"] },
	{ coord = 59405863, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_59405863_note"] },
	{ coord = 19694227, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_19694227_note"] },
	{ coord = 24763858, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_24763858_note"] },
	{ coord = 50575594, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_50575594_note"] },
	{ coord = 28913361, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_28913361_note"] },
	{ coord = 32644686, questId = 48371, icon = "treasure", group = "treasure_ma", label = "48371", loot = nil, note = _L["48371_32644686_note"] },
	-- 48362
	{ coord = 66682786, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_66682786_note"] },
	{ coord = 62134077, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_62134077_note"] },
	{ coord = 67254608, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_67254608_note"] },
	{ coord = 68355322, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_68355322_note"] },
	{ coord = 65966017, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_65966017_note"] },
	{ coord = 62053268, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_62053268_note"] },
	{ coord = 60964354, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_60964354_note"] },
	{ coord = 64445956, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_64445956_note"] },
	{ coord = 65354194, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_65354194_note"] },
	{ coord = 63924532, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_63924532_note"] },
	{ coord = 67893170, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_67893170_note"] },
	{ coord = 65974679, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_65974679_note"] },
	{ coord = 68404122, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_68404122_note"] },
	{ coord = 61924258, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_61924258_note"] },
	{ coord = 67235673, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_67235673_note"] },
	{ coord = 70243379, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_70243379_note"] },
	{ coord = 69304993, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_69304993_note"] },
	{ coord = 61395555, questId = 48362, icon = "treasure", group = "treasure_ma", label = "48362", loot = nil, note = _L["48362_61395555_note"] },
	-- Void-Seeped Cache / Treasure Chest
	-- 49264
	{ coord = 38143985, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_38143985_note"] },
	{ coord = 37613608, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_37613608_note"] },
	{ coord = 37812344, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_37812344_note"] },
	{ coord = 33972078, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_33972078_note"] },
	{ coord = 33312952, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_33312952_note"] },
	{ coord = 37102005, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_37102005_note"] },
	{ coord = 33592361, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_33592361_note"] },
	{ coord = 31582553, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_31582553_note"] },
	{ coord = 32332131, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_32332131_note"] },
	{ coord = 35293848, questId = 49264, icon = "treasure", group = "treasure_ma", label = "49264", loot = nil, note = _L["49264_35293848_note"] },
	-- 48361
	{ coord = 37664221, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_37664221_note"] },
	{ coord = 25824471, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_25824471_note"] },
	{ coord = 20674033, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_20674033_note"] },
	{ coord = 29503999, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_29503999_note"] },
	{ coord = 29455043, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_29455043_note"] },
	{ coord = 18794171, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_18794171_note"] },
	{ coord = 25293498, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_25293498_note"] },
	{ coord = 35283586, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_35283586_note"] },
	{ coord = 24654126, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_24654126_note"] },
	{ coord = 37754868, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_37754868_note"] },
	{ coord = 39174733, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_39174733_note"] },
	{ coord = 28794425, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_28784425_note"] },
	{ coord = 32583679, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_32583679_note"] },
	{ coord = 19804660, questId = 48361, icon = "treasure", group = "treasure_ma", label = "48361", loot = nil, note = _L["48361_19804660_note"] },

}

--
-- Invasions
--

local invasionLoot = {
	{ itemId = 153265, itemType = itemTypeTransmog, slot = _L["1h Axe"] },
	{ itemId = 153264, itemType = itemTypeTransmog, slot = _L["1h Axe"] },
	{ itemId = 153307, itemType = itemTypeTransmog, slot = _L["1h Axe"] },
	{ itemId = 153262, itemType = itemTypeTransmog, slot = _L["1h Mace"] },
	{ itemId = 153261, itemType = itemTypeTransmog, slot = _L["1h Mace"] },
	{ itemId = 153258, itemType = itemTypeTransmog, slot = _L["1h Mace"] },
	{ itemId = 153254, itemType = itemTypeTransmog, slot = _L["1h Mace"] },
	{ itemId = 153300, itemType = itemTypeTransmog, slot = _L["1h Sword"] },
	{ itemId = 153301, itemType = itemTypeTransmog, slot = _L["1h Sword"] },
	{ itemId = 153297, itemType = itemTypeTransmog, slot = _L["1h Sword"] },
	{ itemId = 153295, itemType = itemTypeTransmog, slot = _L["1h Sword"] },
	{ itemId = 153320, itemType = itemTypeTransmog, slot = _L["2h Mace"] },
};
nodes["InvasionPointVal"] = {
	{ coord = 53893794, questId = 0, icon = "skull_grey", group = "invasion", poiId = 5360, label = _L["Invasion Point: Val"], searchMaxAge = 3600*2, search = _L["invasion_val_search"], loot = invasionLoot, note = nil },
}
nodes["InvasionPointAurinor"] = {
	{ coord = 23485069, questId = 0, icon = "skull_grey", group = "invasion", poiId = 5367, label = _L["Invasion Point: Aurinor"], searchMaxAge = 3600*2, search = _L["invasion_aurinor_search"], loot = invasionLoot, note = nil },
}
nodes["InvasionPointSangua"] = {
	{ coord = 50005000, questId = 0, icon = "skull_grey", group = "invasion", poiId = 5350, label = _L["Invasion Point: Sangua"], searchMaxAge = 3600*2, search = _L["invasion_sangua_search"], loot = invasionLoot, note = nil },
}
nodes["InvasionPointNaigtal"] = {
	{ coord = 66605793, questId = 0, icon = "skull_grey", group = "invasion", poiId = 5368, label = _L["Invasion Point: Naigtal"], searchMaxAge = 3600*2, search = _L["invasion_naigtal_search"], loot = invasionLoot, note = nil },
}
nodes["InvasionPointBonich"] = {
	{ coord = 45165586, questId = 0, icon = "skull_grey", group = "invasion", poiId = 5366, label = _L["Invasion Point: Bonich"], searchMaxAge = 3600*2, search = _L["invasion_bonich_search"], loot = invasionLoot, note = nil },
}
nodes["InvasionPointCengar"] = {
	{ coord = 59256574, questId = 0, icon = "skull_grey", group = "invasion", poiId = 5359, label = _L["Invasion Point: Cen'gar"], searchMaxAge = 3600*2, search = _L["invasion_cengar_search"], loot = invasionLoot, note = nil },
}

local worldmapPOI = {
	[5284] = { npcId = 0, group = "bsrare", label = _L["Malgrazoth"], search = _L["bsrare_malgrazoth_search"] },
	[5285] = { npcId = 0, group = "bsrare", label = _L["Salethan the Broodwalker"], search = _L["bsrare_salethan_search"] },
	[5286] = { npcId = 0, group = "bsrare", label = _L["Malorus the Soulkeeper"], search = _L["bsrare_malorus_search"] },
	[5287] = { npcId = 0, group = "bsrare", label = _L["Emberfire"], search = _L["bsrare_emberfire_search"] },
	[5288] = { npcId = 0, group = "bsrare", label = _L["Potionmaster Gloop"], search = _L["bsrare_gloop_search"] },
	[5289] = { npcId = 0, group = "bsrare", label = _L["Felmaw Emberfiend"], search = _L["bsrare_felmawemberfiend_search"] },
	[5290] = { npcId = 0, group = "bsrare", label = _L["Inquisitor Chillbane"], search = _L["bsrare_chillbane_search"] },
	[5291] = { npcId = 0, group = "bsrare", label = _L["Doombringer Zar'thoz"], search = _L["bsrare_zarthoz_search"] },
	[5292] = { npcId = 0, group = "bsrare", label = _L["Dreadblade Annihilator"], search = _L["bsrare_dreadbladeannihilator_search"] },
	[5293] = { npcId = 0, group = "bsrare", label = _L["Felbringer Xar'thok"], search = _L["bsrare_xarthok_search"] },
	[5294] = { npcId = 0, group = "bsrare", label = _L["Xorogun the Flamecarver"], search = _L["bsrare_xorogun_search"] },
	[5295] = { npcId = 0, group = "bsrare", label = _L["Corrupted Bonebreaker"], search = _L["bsrare_corruptedbonebreaker_search"] },
	[5296] = { npcId = 0, group = "bsrare", label = _L["Felcaller Zelthae"], search = _L["bsrare_zelthae_search"] },
	[5297] = { npcId = 0, group = "bsrare", label = _L["Dreadeye"], search = _L["bsrare_dreadeye_search"] },
	[5298] = { npcId = 0, group = "bsrare", label = _L["Lord Hel'Nurath"], search = _L["bsrare_helnurath_search"] },
	[5299] = { npcId = 0, group = "bsrare", label = _L["Imp Mother Bruva"], search = _L["bsrare_bruva_search"] },
	[5300] = { npcId = 0, group = "bsrare", label = _L["Flllurlokkr"], search = _L["bsrare_flllurlokkr_search"] },
	[5301] = { npcId = 0, group = "bsrare", label = _L["Aqueux"], search = _L["bsrare_aqueux_search"] },
	[5302] = { npcId = 0, group = "bsrare", label = _L["Brood Mother Nix"], search = _L["bsrare_broodmothernix_search"] },
	[5303] = { npcId = 0, group = "bsrare", label = _L["Grossir"], search = _L["bsrare_grossir_search"] },
	[5304] = { npcId = 0, group = "bsrare", label = _L["Lady Eldrathe"], search = _L["bsrare_eldrathe_search"] },
	[5305] = { npcId = 0, group = "bsrare", label = _L["Somber Dawn"], search = _L["bsrare_somberdawn_search"] },
	[5306] = { npcId = 0, group = "bsrare", label = _L["Duke Sithizi"], search = _L["bsrare_dukesithizi_search"] },
	[5307] = { npcId = 0, group = "bsrare", label = _L["Eye of Gurgh"], search = _L["bsrare_eyeofgurgh_search"] },
	[5308] = { npcId = 0, group = "bsrare", label = _L["Brother Badatin"], search = _L["bsrare_badatin_search"] },
	--[xxxx] = { npcId = 0, group = "bsrare", label = _L["xxxx"], search = _L["bsrare__search"] },
	
	[5360] = { group = "invasion", label = _L["Invasion Point: Val"], search = _L["invasion_val_search"] },
	[5372] = { group = "invasion", label = _L["Invasion Point: Val"], search = _L["invasion_val_search"] },
	[5367] = { group = "invasion", label = _L["Invasion Point: Aurinor"], search = _L["invasion_aurinor_search"] },
	[5373] = { group = "invasion", label = _L["Invasion Point: Aurinor"], search = _L["invasion_aurinor_search"] },
	[5369] = { group = "invasion", label = _L["Invasion Point: Sangua"], search = _L["invasion_sangua_search"] },
	[5350] = { group = "invasion", label = _L["Invasion Point: Sangua"], search = _L["invasion_sangua_search"] },
	[5368] = { group = "invasion", label = _L["Invasion Point: Naigtal"], search = _L["invasion_naigtal_search"] },
	[5374] = { group = "invasion", label = _L["Invasion Point: Naigtal"], search = _L["invasion_naigtal_search"] },
	[5366] = { group = "invasion", label = _L["Invasion Point: Bonich"], search = _L["invasion_bonich_search"] },
	[5371] = { group = "invasion", label = _L["Invasion Point: Bonich"], search = _L["invasion_bonich_search"] },
	[5359] = { group = "invasion", label = _L["Invasion Point: Cen'gar"], search = _L["invasion_cengar_search"] },
	[5370] = { group = "invasion", label = _L["Invasion Point: Cen'gar"], search = _L["invasion_cengar_search"] },
	[5375] = { group = "invasion", label = _L["Greater Invasion Point: Mistress Alluradel"], search = _L["invasion_alluradel_search"] },
	[5376] = { group = "invasion", label = _L["Greater Invasion Point: Occularus"], search = _L["invasion_occularus_search"] },
	[5377] = { group = "invasion", label = _L["Greater Invasion Point: Pit Lord Vilemus"], search = _L["invasion_vilemus_search"] },
	[5379] = { group = "invasion", label = _L["Greater Invasion Point: Inquisitor Meto"], search = _L["invasion_meto_search"] },
	[5380] = { group = "invasion", label = _L["Greater Invasion Point: Sotanathor"], search = _L["invasion_sotanathor_search"] },
	[5381] = { group = "invasion", label = _L["Greater Invasion Point: Matron Folnuna"], search = _L["invasion_folnuna_search"] },
}

--
--
--	13th Anniversary
--
--

local kazzakLoot = {
	{ itemId = 150379, itemType = itemTypeTransmog, slot = _L["Mail"] },
	{ itemId = 150380, itemType = itemTypeTransmog, slot = _L["Cloak"] },
	{ itemId = 150381, itemType = itemTypeTransmog, slot = _L["Leather"] },
	{ itemId = 150382, itemType = itemTypeTransmog, slot = _L["Leather"] },
	{ itemId = 150383, itemType = itemTypeTransmog, slot = _L["Staff"] },
	{ itemId = 150384, itemType = itemTypeTransmog, slot = _L["Ring"] },
	{ itemId = 150385, itemType = itemTypeTransmog, slot = _L["Cloth"] },
	{ itemId = 150386, itemType = itemTypeTransmog, slot = _L["Cloth"] },
	{ itemId = 150426, itemType = itemTypeTransmog, slot = _L["Trinket"] },
	{ itemId = 150427, itemType = itemTypeTransmog, slot = _L["1h Mace"] },
};

local azuregosLoot = {
	{ itemId = 150417, itemType = itemTypeTransmog, slot = _L["Cloak"] },
	{ itemId = 150419, itemType = itemTypeTransmog, slot = _L["Cloth"] },
	{ itemId = 150421, itemType = itemTypeTransmog, slot = _L["2h Sword"] },
	{ itemId = 150422, itemType = itemTypeTransmog, slot = _L["Plate"] },
	{ itemId = 150423, itemType = itemTypeTransmog, slot = _L["Dagger"] },
	{ itemId = 150424, itemType = itemTypeTransmog, slot = _L["Wand"] },
	{ itemId = 150425, itemType = itemTypeTransmog, slot = _L["Cloth"] },
	{ itemId = 150428, itemType = itemTypeTransmog, slot = _L["Fist"] },
	{ itemId = 150543, itemType = itemTypeTransmog, slot = _L["Leather"] },
	{ itemId = 150544, itemType = itemTypeTransmog, slot = _L["Mail"] },
	{ itemId = 150545, itemType = itemTypeTransmog, slot = _L["Ring"] },
};

local dragonsofnightmareLoot = {
	{ itemType = itemTypeTitle, title = " " },
	{ itemType = itemTypeTitle, title = _L["Ysondre"] },
	{ itemId = 150387, itemType = itemTypeTransmog, slot = _L["Plate"] },
	{ itemId = 150389, itemType = itemTypeTransmog, slot = _L["Mail"] },
	{ itemId = 150391, itemType = itemTypeTransmog, slot = _L["Cloth"] },
	{ itemId = 150396, itemType = itemTypeTransmog, slot = _L["Leather"] },
	{ itemId = 150397, itemType = itemTypeTransmog, slot = _L["Cloth"] },
	{ itemId = 150409, itemType = itemTypeTransmog, slot = _L["Off Hand"] },
	{ itemType = itemTypeTitle, title = " " },
	{ itemType = itemTypeTitle, title = _L["Lethon"] },
	{ itemId = 150398, itemType = itemTypeTransmog, slot = _L["Leather"] },
	{ itemId = 150399, itemType = itemTypeTransmog, slot = _L["Cloth"] },
	{ itemId = 150400, itemType = itemTypeTransmog, slot = _L["Mail"] },
	{ itemId = 150401, itemType = itemTypeTransmog, slot = _L["Leather"] },
	{ itemId = 150402, itemType = itemTypeTransmog, slot = _L["Plate"] },
	{ itemId = 150407, itemType = itemTypeTransmog, slot = _L["Amulet"] },
	{ itemId = 150429, itemType = itemTypeTransmog, slot = _L["Dagger"] },
	{ itemType = itemTypeTitle, title = " " },
	{ itemType = itemTypeTitle, title = _L["Emeriss"] },
	{ itemId = 150404, itemType = itemTypeTransmog, slot = _L["Ring"] },
	{ itemId = 150405, itemType = itemTypeTransmog, slot = _L["Leather"] },
	{ itemId = 150406, itemType = itemTypeTransmog, slot = _L["Mail"] },
	{ itemId = 150410, itemType = itemTypeTransmog, slot = _L["Plate"] },
	{ itemId = 150415, itemType = itemTypeTransmog, slot = _L["Leather"] },
	{ itemId = 150416, itemType = itemTypeTransmog, slot = _L["Cloth"] },
	{ itemType = itemTypeTitle, title = " " },
	{ itemType = itemTypeTitle, title = _L["Taerar"] },
	{ itemId = 150390, itemType = itemTypeTransmog, slot = _L["Plate"] },
	{ itemId = 150392, itemType = itemTypeTransmog, slot = _L["Ring"] },
	{ itemId = 150394, itemType = itemTypeTransmog, slot = _L["Cloth"] },
	{ itemId = 150395, itemType = itemTypeTransmog, slot = _L["Leather"] },
	{ itemId = 150414, itemType = itemTypeTransmog, slot = _L["Mail"] },
	{ itemId = 150413, itemType = itemTypeTransmog, slot = _L["Plate"] },
	{ itemType = itemTypeTitle, title = " " },
	{ itemType = itemTypeTitle, title = _L["Shared"] },
	{ itemId = 150388, itemType = itemTypeTransmog, slot = _L["Trinket"] }, -- ylet
	{ itemId = 150393, itemType = itemTypeTransmog, slot = _L["1h Sword"] }, -- ylet
	{ itemId = 150403, itemType = itemTypeTransmog, slot = _L["Crossbow"] }, -- ylet
	{ itemId = 150408, itemType = itemTypeTransmog, slot = _L["Staff"] }, -- yle
	{ itemId = 150411, itemType = itemTypeTransmog, slot = _L["Cloak"] }, -- ylet
	{ itemId = 150412, itemType = itemTypeTransmog, slot = _L["1h Mace"] }, -- yle
}

nodes["BlastedLands"] = {
	{ coord = 32274901, questId = 47461, npcId = 12397, icon = "skull_grey", group = "birthday13", label = _L["Lord Kazzak"], searchMaxAge = 3600*2, search = _L["kazzak_search"], loot = kazzakLoot, note = nil },
}

nodes["Aszhara"] = {
	{ coord = 48778429, questId = 47462, npcId = 121820, icon = "skull_grey", group = "birthday13", label = _L["Azuregos"], searchMaxAge = 3600*2, search = _L["azuregos_search"], loot = azuregosLoot, note = nil },
}

-- taerar 14890
-- emeriss 14889
-- ysondre 14887 47463
-- lethon 14888

nodes["Duskwood"] = {
	{ coord = 47533989, questId = 47463, icon = "skull_grey", group = "birthday13", label = _L["Dragons of Nightmare"], searchMaxAge = 3600*2, search = _L["dragonsofnightmare_search"], loot = dragonsofnightmareLoot, note = nil },
}

nodes["Hinterlands"] = {
	{ coord = 62922546, questId = 47463, icon = "skull_grey", group = "birthday13", label = _L["Dragons of Nightmare"], searchMaxAge = 3600*2, search = _L["dragonsofnightmare_search"], loot = dragonsofnightmareLoot, note = nil },
}

nodes["Ashenvale"] = {
	{ coord = 93634059, questId = 47463, icon = "skull_grey", group = "birthday13", label = _L["Dragons of Nightmare"], searchMaxAge = 3600*2, search = _L["dragonsofnightmare_search"], loot = dragonsofnightmareLoot, note = nil },
}

nodes["Feralas"] = {
	{ coord = 50831161, questId = 47463, icon = "skull_grey", group = "birthday13", label = _L["Dragons of Nightmare"], searchMaxAge = 3600*2, search = _L["dragonsofnightmare_search"], loot = dragonsofnightmareLoot, note = nil },
}

--
--
--	Globals
--
--

local isTomTomloaded = false
local isCanIMogItloaded = false
local clickedMapFile = nil
local clickedCoord = nil
local numSearches = 0;
local lastSearchTerm = "";
local LFG_CAT_CUSTOM = 6;
local LFG_CAT_QUESTS = 1;
local lastRareResetSlot = -1;
local MYSELF = nil;
local ADDON_MSG_PREFIX = "HNA";
local ADDON_MSG_CMD = {
	getVer = "GV",
	sendVer = "SV",
	getRares = "GR",
	sendRares = "SR"
};
local PLAYERS = {};

--
--
--	Helpers
--
--

local function debugMsg( msg )
	if ( Argus.db.profile.show_debug ) then
		print( msg );
	end
end

local function versionToNumber( version )
	local v1, v2, v3 = version:match("(%d+)%.(%d+)%.(%d+)");
	if ( v1 and v2 and v3 ) then
		return tonumber(v1) * 10000 + tonumber(v2) * 100 + tonumber(v3);
	else
		return 0;
	end
end

local function hasTransmog( itemId )
end

local function playerHasLoot( loot )
	if ( loot == nil ) then
		-- no loot no need
		return true
	elseif ( loot["forceUnknown"] ) then
		return false;
	elseif ( loot["itemType"] == itemTypeMount ) then
		-- check mount known
		local n,_,_,_,_,_,_,_,_,_,hasMount,j=C_MountJournal.GetMountInfoByID( loot["mountId"] );
		return hasMount;
	elseif ( loot["itemType"] == itemTypePet ) then
		-- check pet quantity
		local n,m = C_PetJournal.GetNumCollectedInfo( loot["speciesId"] );
		return n >= 1;
	elseif ( loot["itemType"] == itemTypeToy ) then
		-- check toy known
		return PlayerHasToy( loot["itemId"] );
	elseif ( isCanIMogItloaded == true and loot["itemType"] == itemTypeTransmog ) then
		-- check transmog known with canimogit
		local _,itemLink = GetItemInfo( loot["itemId"] );
		if ( itemLink ~= nil ) then
			if ( CanIMogIt:PlayerKnowsTransmog( itemLink ) or not CanIMogIt:CharacterCanLearnTransmog( itemLink ) ) then
				return true;
			else
				return false;
			end
		else
			return true
		end
	else
		-- default assume not needed
		return true;
	end
end

local function formatAge( age )
	if age > 3600 then
		return string.format( "%.0f", age / 3600 ) .. _L["hour_short"];
	elseif age > 60 then
		return string.format( "%.0f", age / 60 ) .. _L["minute_short"];
	else
		return age .. _L["second_short"];
	end
end

local function __getCurrentTimeSlot( decimals, offset )
	-- 09:02 - 13:02 = 0
	-- 13:02 - 17:02 = 1
	-- 17:02 - 21:02 = 2
	-- 21:02 - 01:02 = 3
	-- 01:02 - 05:02 = 4
	-- 05:02 - 09:02 = 5
	local h, m = GetGameTime();
	if ( not offset ) then
		offset = 4;
	end
	local slot = ((h*60+m-offset) - 7*60) / (4*60);
	if slot < 0 then
		slot = slot + 6;
	end
	if ( decimals ) then
		return slot;
	else
		return floor( slot );
	end
end

local function getCurrentTimeSlot( decimals, resetSec )
	-- 86400     - 86400-119 = -1
	-- 86400-120 - 72000-119 = 0
	-- 72000-120 - 57600-119 = 1
	-- 57600-120 - 43200-119 = 2
	-- 43200-120 - 28800-119 = 3
	-- 28800-120 - 14400-119 = 4
	-- 14400-120 - 00000-119 = 5
	if ( not resetSec ) then
		resetSec = GetQuestResetTime();
	end
	local slot = (((resetSec + 120) / (4*3600))-6.0);
	if ( slot ~= 0 ) then
		slot = slot * (-1);
	end
	if ( decimals ) then
		return slot;
	else
		return floor( slot );
	end
end

local function updateLoot( node )
	local total = 0;
	local failed = 0;
	node["allLootKnown"] = true;
	if ((node["loot"] ~= nil) and (type(node["loot"]) == "table") ) then
		local ii;
		for ii = 1, #node["loot"] do
			if ( node["loot"][ii]["itemId"] ) then
				total = total + 1;
				local _, itemLink = GetItemInfo( node["loot"][ii]["itemId"] );
				if ( not itemLink ) then failed = failed + 1 end
				if ( not playerHasLoot( node["loot"][ii] ) ) then
					node["allLootKnown"] = false;
				end
			end
		end
	end
	return total, failed;
end

local trackAchievements = CreateFrame("Frame");
trackAchievements:SetScript("OnEvent", function( self, event, ... )
	--print( event );
	--print( ... );
end );
local function updateCommanderOfArgusCriteria()
	-- commander of argus achievement criteria
	local _,_,accountCompleted = GetAchievementInfo( 12078 );
	local numCriteria = GetAchievementNumCriteria( 12078 );
	for i = 1, numCriteria do
		local _, _, completed, _, _, _, _, npcId, _, _ = GetAchievementCriteriaInfo( 12078, i );
		if ( not Argus.db.profile.alwaysTrackCoA and accountCompleted ) then
			completed = true;
		end
		if ( nodeRef.rares[npcId] ) then
			nodeRef.rares[npcId]["missingForCoA"] = not completed;
		end
	end
end

local function prepareNodesData()
	numSearches = 0;
	for mapId,mapFile in pairs( nodes ) do
		local numNodes = #nodes[mapId];
		--debugMsg( mapId );
		nodes[mapId][1]["lookup"] = {};
		local lookup = nodes[mapId][1]["lookup"];
		for i = 1,numNodes do
			local node = nodes[mapId][i];
			node["allLootKnown"] = true;
			if ( node["group"]:find( "rare" ) or node["group"]:find( "invasion" ) ) then
				node["lfgGroups"] = {};
				node["numLfgGroups"] = 0;
				node["ratioLfgGroups"] = 0.0;
				node["confUp"] = 0.0;
				node["up"] = false;
				node["seen"] = false;
				if ( node["group"]:find( "rare" ) ) then
					nodeRef.rares[node["npcId"]] = node;
				end
			end
			if ( i < numNodes ) then
				node["nextNode"] = nodes[mapId][i+1];
			else
				node["nextNode"] = nil;
			end
			lookup[node["coord"]] = node;
		end
	end
	updateCommanderOfArgusCriteria();
end

-- lazy and inefficient as fuck, i know
local function GetNodeByCoord( mapFile, coord )
	if ( nodes[mapFile] ) then
		for i,node in ipairs(nodes[mapFile]) do
			if ( node["coord"] == coord ) then
				return node;
			end
		end
	end
	return nil
end

--
--
--	Tooltip
--
--

local npc_tooltip = CreateFrame("GameTooltip", "HandyNotesArgus_npcToolTip", UIParent, "GameTooltipTemplate")
local tooltip_label

local function getCreatureNamebyID(id)
	npc_tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	npc_tooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
	tooltip_label = _G["HandyNotesArgus_npcToolTipTextLeft1"]:GetText()
end

function Argus:OnEnter( mapFile, coord )
	local node = GetNodeByCoord( mapFile, coord );
	local itemDataMissing = false;
    if ( not node ) then return end
    
    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

    if ( self:GetCenter() > UIParent:GetCenter() ) then
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end
	
	local label = "";
	if ( node["npcId"] ) then
		tooltip_label = nil;
		getCreatureNamebyID( node["npcId"] );
		if ( tooltip_label ) then
			label = tooltip_label
		end
	else
		label = node["label"];
	end
	if ( Argus.db.profile.show_debug ) then
		if ( node["ratioLfgGroups"] ) then
			label = label .. " (" .. string.format("%.2f", node["ratioLfgGroups"] ) .. ")";
		end
		if ( node["seen"] and node["seen"]["timeSlot"] == getCurrentTimeSlot() ) then
			label = label .. " +";
		end
	end
	tooltip:SetText( label );
	if ( Argus.db.profile.show_notes == true and node["note"] and node["note"] ~= nil ) then
		-- note
		tooltip:AddLine( node["note"], nil, nil, nil, true );
	end
    if (	( Argus.db.profile.show_loot == true ) and
			( node["loot"] ~= nil ) and
			( type(node["loot"]) == "table" ) ) then
		local ii;
		local loot = node["loot"];
		for ii = 1, #loot do
			local itemLink;
			if ( loot[ii]["itemId"] ) then
				_, itemLink, _, _, _, _, _, _, _, _ = GetItemInfo( loot[ii]["itemId"] );
				if ( not itemLink ) then
				itemLink = _L["Retrieving data ..."];
					itemDataMissing = true;
				end
			end
			-- loot
			if ( loot[ii]["itemType"] == itemTypeTitle ) then
				tooltip:AddLine( loot[ii]["title"] );
			elseif ( loot[ii]["itemType"] == itemTypeMount ) then
				-- check mount known
				local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID( loot[ii]["mountId"] );
				if ( c == true ) then
					tooltip:AddDoubleLine( itemLink, _L["(Mount known)"] );
				else
					tooltip:AddDoubleLine( itemLink, _L["(Mount missing)"] );
				end
			elseif ( loot[ii]["itemType"] == itemTypePet ) then
				-- check pet quantity
				local n,m = C_PetJournal.GetNumCollectedInfo( loot[ii]["speciesId"] );
				tooltip:AddDoubleLine( itemLink, "(" .. _L["Pet"] .. " " .. n .. "/" .. m .. ")" );
			elseif ( loot[ii]["itemType"] == itemTypeToy ) then
				-- check toy known
				if ( PlayerHasToy( loot[ii]["itemId"] ) == true ) then
					tooltip:AddDoubleLine( itemLink, _L["(Toy known)"] );
				else
					tooltip:AddDoubleLine( itemLink, _L["(Toy missing)"] );
				end
			elseif ( isCanIMogItloaded == true and loot[ii]["itemType"] == itemTypeTransmog ) then
				-- check transmog known with canimogit
				-- local _,itemLink = GetItemInfo( loot[ii]["itemId"] );
				if ( itemLink ~= _L["Retrieving data ..."] ) then
					if ( CanIMogIt:PlayerKnowsTransmog( itemLink ) ) then
						tooltip:AddDoubleLine( itemLink, string.format( _L["(itemLinkGreen)"], loot[ii]["slot"] ) );
					else
						tooltip:AddDoubleLine( itemLink, string.format( _L["(itemLinkRed)"], loot[ii]["slot"] ) );
					end
				else
					tooltip:AddDoubleLine( itemLink, "(" .. loot[ii]["slot"] .. ")" );
				end
			elseif ( loot[ii]["itemType"] == itemTypeTransmog ) then
				-- show transmog without check
				tooltip:AddDoubleLine( itemLink, loot[ii]["slot"] );
			else
				-- default show itemLink
				tooltip:AddDoubleLine( itemLink, "" );
			end
		end
    end
	
	if ( node["missingForCoA"] ) then
		tooltip:AddLine( string.format( _L["Missing for CoALink"], GetAchievementLink( 12078 ) ) );
	end

    tooltip:Show();
	
	if ( itemDataMissing == true ) then
		-- try refreshing if itemlinks are missing
		C_Timer.After( 1, function()
			Argus:Refresh();
		end );
	end
end

local function hideNode(button, mapFile, coord)
	local node = GetNodeByCoord( mapFile, coord );
    if ( node and node["questId"] ~= nil) then
        Argus.db.char[mapFile .. "_" .. coord .. "_" .. node["questId"]] = true;
    end

    Argus:Refresh()
end

local function ResetDB()
    table.wipe(Argus.db.char)
    Argus:Refresh()
end

local function addtoTomTom(button, mapFile, coord)
	local node = GetNodeByCoord( mapFile, coord );
	if ( node and isTomTomloaded == true ) then
		local mapId = HandyNotes:GetMapFiletoMapID( mapFile );
		local x, y = HandyNotes:getXY(  coord );
		local desc = node["label"];

		TomTom:AddMFWaypoint(mapId, nil, x, y, {
			title = desc,
			persistent = nil,
			minimap = true,
			world = true
		});
	end
end


--
--
--	Group finder shit
--
--

local finderFrame = CreateFrame("Frame");
local groupBrowserMenuFrame = CreateFrame( "Frame", "groupBrowserMenuFrame", UIParent, "UIDropDownMenuTemplate");

local function resetNPCGroupCounts()
	numSearches = 0;
	for mapId,mapFile in pairs( nodes ) do
		for i,node in ipairs( nodes[mapId] ) do
			if ( node["group"]:find( "rare" ) or node["group"]:find( "invasion" ) ) then
				node["lfgGroups"] = {};
				node["numLfgGroups"] = 0;
				node["ratioLfgGroups"] = 0.0;
				node["confUp"] = 0.0;
				node["up"] = false;
				node["seen"] = false;
			end
		end
	end
	if ( IsInGuild() ) then
		C_ChatInfo.SendAddonMessage( ADDON_MSG_PREFIX, ADDON_MSG_CMD.getRares .. "=" .. VERSION, "GUILD" );
	end
	if ( IsInGroup() ) then
		C_ChatInfo.SendAddonMessage( ADDON_MSG_PREFIX, ADDON_MSG_CMD.getRares .. "=" .. VERSION, "RAID" );
	end
end

local function checkResetNPCGroupCounts()
	local currentTimeSlot = getCurrentTimeSlot();
	if ( lastRareResetSlot ~= currentTimeSlot ) then
		resetNPCGroupCounts();
		lastRareResetSlot = currentTimeSlot;
		PLAYERS = {};
	end
end

local function updateNPCGroupCount( gName, gLeader )
	gName = gName:lower();
	if ( not gLeader ) then
		gLeader = "none";
	end
	for mapId,mapFile in pairs( nodes ) do
		for i,node in ipairs( nodes[mapId] ) do
			if ( node["group"]:find( "rare" ) or node["group"]:find( "invasion" ) ) then
				for sIdx, search in ipairs( node["search"] ) do
					-- first element is the hardfilter
					if ( sIdx >= 2 and gName:match( search ) ) then
						--print( "add " .. gName .. " to " .. node["label"] );
						node["lfgGroups"][gName.."-"..gLeader] = gName.."-"..gLeader;
					end
				end
			end
		end
	end
end

local function countTable( t )
	if ( not t ) then return 0; end
	local c = 0;
	for k, v in pairs( t ) do
	   c = c + 1;
	end
	return c;
end

local function updateFoundRares()
	local sumGroupsRare = 0;
	local numRares = 0;
	local sumGroupsInvasion = 0;
	local numInvasions = 0;
	-- calc the average first and reset up status
	for mapId,mapFile in pairs( nodes ) do
		for i,node in ipairs( nodes[mapId] ) do
			node["up"] = false;
			if ( node["group"]:find( "rare" ) or node["group"]:find( "invasion" ) ) then
				local c = countTable( node["lfgGroups"] );
				node["numLfgGroups"] = c;
				if ( c > 0 ) then
					if ( node["group"]:find( "rare" ) ) then
						sumGroupsRare = sumGroupsRare + c;
						numRares = numRares + 1;
					else
						sumGroupsInvasion = sumGroupsInvasion + c;
						numInvasions = numInvasions + 1;
					end
					-- print( node["label"] .. " : " .. c );
					for k,v in pairs( node["lfgGroups"] ) do
						--print( k .. " : " .. v );
					end
				end
			end
		end
	end
	if ( numRares > 0 ) then
		local avgRares = sumGroupsRare / numRares;
		--print( "sumGroups:" .. sumGroups .. " numRares:" .. numRares .. " avg:" .. avg );
		for mapId,mapFile in pairs( nodes ) do
			for i,node in ipairs( nodes[mapId] ) do
				if ( node["group"]:find( "rare" ) ) then
					node["ratioLfgGroups"] = node["numLfgGroups"] / avgRares;
					node["confUp"] = node["ratioLfgGroups"];
				end
			end
		end
	end
	if ( numInvasions > 0 ) then
		local avgInvasions = sumGroupsInvasion / numInvasions;
		--print( "sumGroups:" .. sumGroups .. " numInvasions:" .. numInvasions .. " avg:" .. avg );
		for mapId,mapFile in pairs( nodes ) do
			for i,node in ipairs( nodes[mapId] ) do
				if ( node["group"]:find( "invasion" ) ) then
					node["ratioLfgGroups"] = node["numLfgGroups"] / avgInvasions;
					node["confUp"] = node["ratioLfgGroups"];
				end
			end
		end
	end
end

local function genGroupBrowserOption( option )
	local text;
	local color = "";
	if ( option.age < 60 ) then
		color = "|cFF00FF00";
	end
	if ( option.numMembers == 1 ) then
		text = string.format( color .. _L["groupBrowserOptionOne"], option.name, option.numMembers, formatAge( option.age ) );
	else
		text = string.format( color .. _L["groupBrowserOptionMore"], option.name, option.numMembers, formatAge( option.age ) );
	end
	local opt = {
		text = text,
		func = function()
			--local d = LFGListApplicationDialog;
			--local tank = d.TankButton.CheckButton:GetChecked();
			--local heal = d.HealerButton.CheckButton:GetChecked();
			--local dps = d.DamagerButton.CheckButton:GetChecked();
			--if ( not tank and not heal and not dps ) then
			--	dps = true;
			--end
			--local tank, heal, dps = C_LFGList.GetAvailableRoles();
			local _, _, _, _, role = GetSpecializationInfo( GetSpecialization() );
			C_LFGList.ApplyToGroup( option.id, "", role == "TANK", role == "HEALER", role == "DAMAGER" );
		end
	};
	return opt;
end

local function LFGcreate( button, node )
	if ( node ~= nil ) then
		local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
		if c == true and name ~= node["label"] then
			if ( UnitIsGroupLeader("player") ) then
				print( string.format( _L["chatmsg_old_group_delisted_create"], node["label"] ) );
				C_LFGList.RemoveListing();
			elseif ( Argus.db.profile.leave_group_on_search ) then
				LeaveParty();
				print( string.format( _L["chatmsg_left_group_create"], node["label"] ) );
			else
				print( _L["chatmsg_no_group_priv"] );
			end
		elseif ( c == false ) then
			print( string.format( _L["chatmsg_group_created"], node["label"] ) );
			-- 16 = custom
			local desc = "";
			if ( string.find( node["group"], "rare" ) ) then
				desc = string.format( _L["listing_desc_rare"], node["label"] ) .. " Created with HandyNotes_Argus ##rare:" .. node["npcId"] .. "#hna:" .. VERSION;
			elseif ( string.find( node["group"], "invasion" ) ) then
				desc = string.format( _L["listing_desc_invasion"], node["label"] ) .. " Created with HandyNotes_Argus ##invasion:" .. node["poiId"] .. "#hna:" .. VERSION;
			elseif ( string.find( node["group"], "bsrare" ) ) then
				desc = string.format( _L["listing_desc_rare"], node["label"] ) .. " Created with HandyNotes_Argus ##poi:" .. node["poiId"] .. "#hna:" .. VERSION;
			end
			local overallILvl, equippedILvl, pvpILvl = GetAverageItemLevel();
			C_LFGList.CreateListing( 16, node["label"]:sub(1,31), math.min( equippedILvl, 820 ), 0, "", desc:sub(1,200), true );
		end
	end
end

local function LFGsearch( button, node, lfgcat )
	if ( node ~= nil ) then
		if ( not lfgcat ) then
			lfgcat = LFG_CAT_CUSTOM;
		end
		local c,zone,_,_,name = C_LFGList.GetActiveEntryInfo();
		if c == true and name ~= label then
			if ( UnitIsGroupLeader("player") ) then
				print( string.format( _L["chatmsg_old_group_delisted_search"], node["label"] ) );
				C_LFGList.RemoveListing();
			elseif ( Argus.db.profile.leave_group_on_search ) then
				LeaveParty();
				print( string.format( _L["chatmsg_left_group_search"], node["label"] ) );
			else
				print( _L["chatmsg_no_group_priv"] );
			end
		elseif ( c == false ) then
			checkResetNPCGroupCounts();
			finderFrame.searchNode = node;
			finderFrame.searchCat = lfgcat;
			local languages = C_LFGList.GetLanguageSearchFilter();
			if ( numSearches < 5 or ( numSearches % 2 ) == 0 ) then
				-- first 5 and every 2nd should refine globally
				lastSearchTerm = "";
			else
				-- every 2nd search may give more results
				-- needs more testing
				--lastSearchTerm = node["search"][1];
				lastSearchTerm = "";
			end
			if ( IsShiftKeyDown() ) then
				lastSearchTerm = node["search"][1];
			end
			C_LFGList.Search( lfgcat, LFGListSearchPanel_ParseSearchTerms ( lastSearchTerm ), nil, nil, allLanguages );
			--print( "Search in " .. lfgcat .. " '" .. lastSearchTerm .. "'" );
		end
	end
end

local function LFGbrowseMatches( matches, node, lfgcat )
	local menu;
	if ( #matches == 0 ) then
		menu = {
			{ text = _L["Sorry, no groups found!"], isTitle = true, notCheckable = true },
		};
		if ( lfgcat ~= LFG_CAT_QUESTS ) then
			table.insert( menu, { text = "", isTitle = true, notCheckable = true } );
			table.insert( menu, { text = _L["Search in Quests"], func = function() LFGsearch( nil, node, LFG_CAT_QUESTS ); end } );
		end
	else
		menu = {
			{ text = _L["Groups found:"], isTitle = true, notCheckable = true },
		};
		if ( node["group"] == "invasion" or node["group"] == "birthday13" ) then
			table.sort( matches, function( a, b )
				return a.numMembers > b.numMembers;
			end );
		else
			table.sort( matches, function( a, b )
				return a.age < b.age;
			end );
		end
		for k,v in ipairs( matches ) do
			table.insert( menu, genGroupBrowserOption( v ) );
			-- print( v["name"] );
		end
	end
	table.insert( menu, { text = "", isTitle = true, notCheckable = true } );
	table.insert( menu, { text = _L["Create new group"], func = function() LFGcreate( nil, node ); end } );
	table.insert( menu, { text = "", isTitle = true, notCheckable = true } );
	table.insert( menu, { text = _L["Close"], notCheckable = true, func = function() CloseDropDownMenus() end } );
	EasyMenu( menu, groupBrowserMenuFrame, "cursor", 0 , 0, "MENU" );
end

finderFrame:SetScript("OnEvent", function( self, event, ... )
	if ( event == "LFG_LIST_SEARCH_RESULTS_RECEIVED" ) then
		local numResults, resultIds = C_LFGList.GetSearchResults()
		numSearches = numSearches + 1;
		local matches = {};
		local maxAge = 150;
		if ( finderFrame.searchNode and finderFrame.searchNode["searchMaxAge"] ) then
			maxAge = finderFrame.searchNode["searchMaxAge"];
		end

		for _, resultId in ipairs( resultIds ) do

			local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers, isAutoAccept = C_LFGList.GetSearchResultInfo( resultId );
			if ( age < maxAge and lastSearchTerm == "" ) then
				-- dont count groups older than 2.5 minutes
				updateNPCGroupCount( name, leaderName );
			end

			if ( finderFrame.searchNode and isAutoAccept and numMembers ~= 5 ) then
				for sIdx, search in ipairs( finderFrame.searchNode["search"] ) do
					if ( sIdx >= 2 and name:lower():match( search ) ) then
						-- print( "found " .. id .. "; " .. name .. " - " .. numMembers .. " (" .. age .. ")");
						table.insert( matches, { id = id, name = name, age = age, numMembers = numMembers } );
						break;
					end
				end
			end
		end
		updateFoundRares();
		Argus:Refresh();
		if ( finderFrame.searchNode ) then
			LFGbrowseMatches( matches, finderFrame.searchNode, finderFrame.searchCat );
			finderFrame.searchNode = nil;
		end
	elseif ( event == "LFG_LIST_SEARCH_FAILED" ) then
		debugMsg( _L["chatmsg_search_failed"] );
	elseif ( event == "PLAYER_TARGET_CHANGED" ) then
		if ( UnitHealth("target") == UnitHealthMax("target") and not UnitAffectingCombat("target") ) then
			local guid = UnitGUID("target");
			if ( guid ) then
				local npcId = guid:match( 'Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-.*' );
				if ( npcId ) then
					npcId = tonumber( npcId );
					if ( nodeRef.rares[npcId] ) then
						local node = nodeRef.rares[npcId];
						local name = UnitName("player");
						local realm = GetRealmName();
						if ( node.seen == false ) then
							node.seen = {};
						end
						node.seen["player"] = name .. "-" .. realm;
						node.seen["timeSlot"] = getCurrentTimeSlot();
						--print( "rare seen: " .. node["label"] .. " - " .. node.seen["timeSlot"] );
						local msg = npcId .. ':' .. node.seen["timeSlot"] .. ';';
						if ( IsInGuild() ) then
							C_ChatInfo.SendAddonMessage( ADDON_MSG_PREFIX, ADDON_MSG_CMD.sendRares .. "=" .. msg, "GUILD" );
						end
						if ( IsInGroup() ) then
							C_ChatInfo.SendAddonMessage( ADDON_MSG_PREFIX, ADDON_MSG_CMD.sendRares .. "=" .. msg, "RAID" );
						end
					end
				end
			end
		end
	else
		-- print( event );
		-- print( ... );
	end
end );

local function LFGCheckRares( button, node, lfgcat )
	finderFrame.searchNode = nil;
	if ( not lfgcat ) then
		lfgcat = LFG_CAT_CUSTOM;
	end
	local languages = C_LFGList.GetLanguageSearchFilter();
	C_LFGList.Search( lfgcat, LFGListSearchPanel_ParseSearchTerms (""), nil, nil, allLanguages );
end

--
--	Invasions
--

local updateInvasionPOI = CreateFrame("Frame");
updateInvasionPOI:SetScript("OnEvent", function( self, event, ... )
	local numPOI = 0; --GetNumMapLandmarks(); --TODO aby8
	for i = 1, numPOI do
		local landmarkType, name, description, textureIndex, x, y, maplinkID, showInBattleMap,_,_,poiId,_,something = C_WorldMap.GetMapLandmarkInfo( i );
		local invasionPOI = _G["WorldMapFramePOI" .. i];
		if ( invasionPOI and not invasionPOI.handyNotesArgus ) then
			invasionPOI.handyNotesArgus = true;
			invasionPOI:RegisterForClicks("LeftButtonDown", "LeftButtonUp");
			invasionPOI:SetScript("OnMouseDown", function(self, button)
				if ( worldmapPOI[self.poiID] ) then
					worldmapPOI[self.poiID]["poiId"] = self.poiID;
					finderFrame.searchNode = worldmapPOI[self.poiID];
				else
					if ( self.poiID and self.name ) then
						debugMsg( self.poiID .. " - " .. self.name );
					end
					return false;
				end
				local languages = C_LFGList.GetLanguageSearchFilter();
				C_LFGList.Search( LFG_CAT_CUSTOM, LFGListSearchPanel_ParseSearchTerms ( finderFrame.searchNode["search"][1] ), nil, nil, allLanguages );
			end );
		end
	end
end );

--
--
--	Communicator
--
--

local function commGetRares( channel )
	C_ChatInfo.SendAddonMessage( ADDON_MSG_PREFIX, ADDON_MSG_CMD.getRares .. "=" .. VERSION, channel );
end

local function commSendRares( channel )
	local s = "";
	local now = getCurrentTimeSlot();
	for npcId, node in pairs( nodeRef.rares ) do
		if ( node["seen"] ~= false and node["seen"]["timeSlot"] == now ) then
			s = s .. npcId .. ":" .. node["seen"]["timeSlot"] .. ";";
		end
		if ( s:len() > 200 ) then
			C_ChatInfo.SendAddonMessage( ADDON_MSG_PREFIX, ADDON_MSG_CMD.sendRares .. "=" .. s, channel );
			s = "";
		end
	end
	if ( s ~= "" ) then
		C_ChatInfo.SendAddonMessage( ADDON_MSG_PREFIX, ADDON_MSG_CMD.sendRares .. "=" .. s, channel );
	end
end

local function commGetVersion( channel, nextCmd )
	C_ChatInfo.SendAddonMessage( ADDON_MSG_PREFIX, ADDON_MSG_CMD.getVer .. "=" .. nextCmd, channel );
end

local function commSendVersion( channel )
	C_ChatInfo.SendAddonMessage( ADDON_MSG_PREFIX, ADDON_MSG_CMD.sendVer .. "=" .. VERSION, channel );
end

local function commHandleCmd( channel, cmd, msg, target )
	if ( cmd == ADDON_MSG_CMD.getVer ) then
		local nextCmd = msg;
		commSendVersion( channel );
		commHandleCmd( channel, nextCmd, "", target );
	elseif ( cmd == ADDON_MSG_CMD.sendVer ) then
		debugMsg( target .. " -> " .. msg );
		if ( target ) then
			if ( not PLAYERS[target] ) then
				PLAYERS[target] = { version = 0, tries = 0 };
			end
			PLAYERS[target]["version"] = versionToNumber( msg );
		end
	elseif ( cmd == ADDON_MSG_CMD.getRares ) then
		commSendRares( channel );
	elseif ( cmd == ADDON_MSG_CMD.sendRares ) then
		if ( not PLAYERS[target] ) then
			PLAYERS[target] = { version = 0, tries = 0 };
			commGetVersion( channel, ADDON_MSG_CMD.getRares );
			return;
		elseif ( PLAYERS[target]["version"] and PLAYERS[target]["version"] >= 2600 ) then
			--print( ... );
			--debugMsg( "parseRares:" .. msg );
			local now = getCurrentTimeSlot();
			msg:gsub("(%d+):(%d);", function ( npcId, timeSlot )
				npcId = tonumber( npcId );
				timeSlot = tonumber( timeSlot );
				--print( "parse:" .. npcId .. ":" .. timeSlot );
				if ( nodeRef.rares[npcId] ) then
					local node = nodeRef.rares[npcId];
					if ( node.seen == false ) then
						-- new rare
						node.seen = { player = playerRealm, timeSlot = timeSlot };
						--print( "got new rare: " .. node["label"] .. " - " .. node.seen["timeSlot"] );
					elseif ( timeSlot == now ) then
						-- update rare
						node.seen["player"] = playerRealm;
						node.seen["timeSlot"] = timeSlot;
						--print( "got rare: " .. node["label"] .. " - " .. node.seen["timeSlot"] );
					else
						--print("nothing");
					end
				else
					--print("unknown npcid " .. npcId);
				end
			end );
		else
			-- print("ignore rares");
		end
	end
end

local communicator = CreateFrame("Frame");
communicator:SetScript("OnEvent", function( self, event, ... )
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		if ( IsInGuild() ) then
			commGetVersion( "GUILD", ADDON_MSG_CMD.getRares );
			-- commSendVersion( "GUILD" );
			-- commGetRares( "GUILD" );
		end
	elseif ( event == "GROUP_JOINED" or event == "__GROUP_ROSTER_UPDATE" ) then
		commGetVersion( "RAID", ADDON_MSG_CMD.getRares );
		-- commSendVersion( "RAID" );
		-- commGetRares( "RAID" );
	elseif ( event == "CHAT_MSG_ADDON" ) then
		local prefix, rawmsg, channel, playerRealm, player = ...
		if ( playerRealm == MYSELF or prefix ~= ADDON_MSG_PREFIX ) then
			-- ignore myself and other addons
			return;
		end
		local cmd = rawmsg:sub(1,2);
		local msg = "";
		if ( rawmsg:len() >= 4 ) then
			msg = rawmsg:sub(4,-1);
		end
		commHandleCmd( channel, cmd, msg, playerRealm );
	end
end );

--
--
--	Context menu
--
--

local function generateMenu( button, level )

	local info = {}
    if ( not level ) then return end
	local node = GetNodeByCoord( clickedMapFile, clickedCoord );
	if ( not node ) then return end

    for k in pairs(info) do info[k] = nil end

    if (level == 1) then
        info.isTitle = 1
        info.text = _L["context_menu_title"]
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
        info.disabled = nil
        info.isTitle = nil
        info.notCheckable = 1
		
		if ( node["group"]:find( "rare" ) ~= nil or node["group"]:find( "invasion" ) ~= nil ) then

			info.disabled = 1
			info.notClickable = 1
			info.text = ""
			UIDropDownMenu_AddButton(info, level)
			info.disabled = nil
			info.notClickable = nil

			info.text = _L["context_menu_check_group_finder"]
			info.func = LFGCheckRares
			info.arg1 = node
			info.arg2 = LFG_CAT_CUSTOM
			UIDropDownMenu_AddButton(info, level)

			info.text = _L["context_menu_reset_rare_counters"]
			info.tooltipText = "bla;"
			info.func = function()
				resetNPCGroupCounts();
				Argus:Refresh();
			end
			UIDropDownMenu_AddButton(info, level)
			
		end

		info.disabled = 1
		info.notClickable = 1
        info.text = ""
        UIDropDownMenu_AddButton(info, level)
		info.disabled = nil
		info.notClickable = nil

        if isTomTomloaded == true then
            info.text = _L["context_menu_add_tomtom"]
            info.func = addtoTomTom
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            UIDropDownMenu_AddButton(info, level)
        end

        info.text = _L["context_menu_hide_node"]
        info.func = hideNode
        info.arg1 = clickedMapFile
        info.arg2 = clickedCoord
        UIDropDownMenu_AddButton(info, level)

        info.text = _L["context_menu_restore_hidden_nodes"]
        info.func = ResetDB
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
        
		info.disabled = 1
		info.notClickable = 1
        info.text = ""
        UIDropDownMenu_AddButton(info, level)
		info.disabled = nil
		info.notClickable = nil

        info.text = CLOSE
        info.func = function() CloseDropDownMenus() end
        info.arg1 = nil
        info.arg2 = nil
        info.notCheckable = 1
        UIDropDownMenu_AddButton(info, level)
		
    end
end

local HandyNotes_ArgusDropdownMenu = CreateFrame("Frame", "HandyNotes_ArgusDropdownMenu")
HandyNotes_ArgusDropdownMenu.displayMode = "MENU"
HandyNotes_ArgusDropdownMenu.initialize = generateMenu

function Argus:OnClick(button, down, mapFile, coord)
	local node = GetNodeByCoord( mapFile, coord );
	if ( not node ) then return end
    if button == "RightButton" and down then
		-- context menu
        clickedMapFile = mapFile
        clickedCoord = coord
        ToggleDropDownMenu(1, nil, HandyNotes_ArgusDropdownMenu, self, 0, 0)
	elseif button == "MiddleButton" and down then
		-- create group
		if ( node["group"]:find("rare") ~= nil or node["group"]:find("invasion") ~= nil or node["group"]:find("birthday13") ~= nil ) then
			LFGcreate( nil, node );
		end
	elseif button == "LeftButton" and down then
		if ( node["group"]:find("rare") ~= nil or
			node["group"]:find("invasion") ~= nil or
			node["group"]:find("birthday13") ~= nil ) then
			-- find group
			LFGsearch( nil, node );
		end
    end
end

function Argus:OnLeave( mapFile, coord )
    if self:GetParent() == WorldMapButton then
        WorldMapTooltip:Hide()
    else
        GameTooltip:Hide()
    end
end

local options = {
    type = "group",
    name = _L["Argus"],
    get = function(info) return Argus.db.profile[info.arg] end,
    set = function(info, v) Argus.db.profile[info.arg] = v; Argus:Refresh() end,
    args = {
        IconOptions = {
            type = "group",
            name = _L["options_icon_settings"],
            desc = _L["options_icon_settings_desc"],
			inline = true,
			order = 0,
            args = {
				groupIconTreasures = {
					type = "header",
					name = _L["options_icons_treasures"],
					desc = _L["options_icons_treasures_desc"],
					order = 0,
				},
				icon_scale_treasures = {
					type = "range",
					name = _L["options_scale"],
					desc = _L["options_scale_desc"],
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_treasures",
					order = 1,
				},
				icon_alpha_treasures = {
					type = "range",
					name = _L["options_opacity"],
					desc = _L["options_opacity_desc"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_treasures",
					order = 2,
				},
				groupIconRares = {
					type = "header",
					name = _L["options_icons_rares"],
					desc = _L["options_icons_rares_desc"],
					order = 10,
				},
				icon_scale_rares = {
					type = "range",
					name = _L["options_scale"],
					desc = _L["options_scale_desc"],
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_rares",
					order = 11,
				},
				icon_alpha_rares = {
					type = "range",
					name = _L["options_opacity"],
					desc = _L["options_opacity_desc"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_rares",
					order = 12,
				},
				groupIconPets = {
					type = "header",
					name = _L["options_icons_pet_battles"],
					desc = _L["options_icons_pet_battles_desc"],
					order = 20,
				},
				icon_scale_pets = {
					type = "range",
					name = _L["options_scale"],
					desc = _L["options_scale_desc"],
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_pets",
					order = 21,
				},
				icon_alpha_pets = {
					type = "range",
					name = _L["options_opacity"],
					desc = _L["options_opacity_desc"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_pets",
					order = 22,
				},
				groupIconSfll = {
					type = "header",
					name = _L["options_icons_sfll"],
					desc = _L["options_icons_sfll_desc"],
					order = 30,
				},
				icon_scale_sfll = {
					type = "range",
					name = _L["options_scale"],
					desc = _L["options_scale_desc"],
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_sfll",
					order = 31,
				},
				icon_alpha_sfll = {
					type = "range",
					name = _L["options_opacity"],
					desc = _L["options_opacity_desc"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_sfll",
					order = 32,
				},
			},
		},
		VisibilityGroup = {
			type = "group",
			order = 10,
			name = _L["options_visibility_settings"],
			desc = _L["options_visibility_settings_desc"],
			inline = true,
			args = {
				groupAW = {
					type = "header",
					name = _L["Antoran Wastes"],
					order = 0,
				},
				treasureAW = {
					type = "toggle",
					arg = "treasure_aw",
					name = _L["options_toggle_treasures"],
					order = 1,
					width = "normal",
				},
				rareAW = {
					type = "toggle",
					arg = "rare_aw",
					name = _L["options_toggle_rares"],
					order = 2,
					width = "normal",
				},
				petAW = {
					type = "toggle",
					arg = "pet_aw",
					name = _L["options_toggle_battle_pets"],
					order = 3,
					width = "normal",
				},
				sfllAW = {
					type = "toggle",
					arg = "sfll_aw",
					name = _L["options_toggle_sfll"],
					order = 4,
					width = "normal",
				},
				npcAW = {
					type = "toggle",
					arg = "npc_aw",
					name = _L["options_toggle_npcs"],
					order = 5,
					width = "normal",
				},
				portalAW = {
					type = "toggle",
					arg = "portal_aw",
					name = _L["options_toggle_portals"],
					order = 6,
					width = "normal",
				},
				groupKR = {
					type = "header",
					name = _L["Krokuun"],
					order = 10,
				},  
				treasureKR = {
					type = "toggle",
					arg = "treasure_kr",
					name = _L["options_toggle_treasures"],
					width = "normal",
					order = 11,
				},
				rareKR = {
					type = "toggle",
					arg = "rare_kr",
					name = _L["options_toggle_rares"],
					width = "normal",
					order = 12,
				},
				petKR = {
					type = "toggle",
					arg = "pet_kr",
					name = _L["options_toggle_battle_pets"],
					width = "normal",
					order = 13,
				},
				sfllKR = {
					type = "toggle",
					arg = "sfll_kr",
					name = _L["options_toggle_sfll"],
					order = 14,
					width = "normal",
				},
				groupMA = {
					type = "header",
					name = _L["Mac'Aree"],
					order = 20,
				},  
				treasureMA = {
					type = "toggle",
					arg = "treasure_ma",
					name = _L["options_toggle_treasures"],
					width = "normal",
					order = 21,
				},
				rareMA = {
					type = "toggle",
					arg = "rare_ma",
					name = _L["options_toggle_rares"],
					width = "normal",
					order = 22,
				},  
				petMA = {
					type = "toggle",
					arg = "pet_ma",
					name = _L["options_toggle_battle_pets"],
					width = "normal",
					order = 23,
				},  
				sfllMA = {
					type = "toggle",
					arg = "sfll_ma",
					name = _L["options_toggle_sfll"],
					order = 24,
					width = "normal",
				},
				npcMA = {
					type = "toggle",
					arg = "npc_ma",
					name = _L["options_toggle_npcs"],
					order = 25,
					width = "normal",
				},
				groupGeneral = {
					type = "header",
					name = _L["options_general_settings"],
					desc = _L["options_general_settings_desc"],
					order = 30,
				},  
				alwaysshowrares = {
					type = "toggle",
					arg = "alwaysshowrares",
					name = _L["options_toggle_alreadylooted_rares"],
					desc = _L["options_toggle_alreadylooted_rares_desc"],
					order = 31,
					width = "full",
				},
				alwaysshowtreasures = {
					type = "toggle",
					arg = "alwaysshowtreasures",
					name = _L["options_toggle_alreadylooted_treasures"],
					desc = _L["options_toggle_alreadylooted_treasures_desc"],
					order = 32,
					width = "full",
				},
				alwaysshowsfll = {
					type = "toggle",
					arg = "alwaysshowsfll",
					name = _L["options_toggle_alreadylooted_sfll"],
					desc = _L["options_toggle_alreadylooted_sfll_desc"],
					order = 33,
					width = "full",
				},
				nodeRareGlow = {
					type = "toggle",
					arg = "nodeRareGlow",
					name = _L["options_toggle_nodeRareGlow"],
					desc = _L["options_toggle_nodeRareGlow_desc"],
					order = 34,
					width = "full",
				},
				hideKnowLoot = {
					type = "toggle",
					arg = "hideKnowLoot",
					name = _L["options_toggle_hideKnowLoot"],
					desc = _L["options_toggle_hideKnowLoot_desc"],
					order = 35,
					width = "full",
				},
				alwaysTrackCoA = {
					type = "toggle",
					arg = "alwaysTrackCoA",
					name = _L["options_toggle_alwaysTrackCoA"],
					desc = _L["options_toggle_alwaysTrackCoA_desc"],
					order = 36,
					width = "full",
				},
				birthday13 = {
					type = "toggle",
					arg = "birthday13",
					name = _L["options_toggle_birthday13"],
					desc = _L["options_toggle_birthday13_desc"],
					order = 36,
					width = "full",
				},
				alwaysShowBirthday13 = {
					type = "toggle",
					arg = "alwaysShowBirthday13",
					name = _L["options_toggle_alwaysShowBirthday13"],
					desc = _L["options_toggle_alwaysShowBirthday13_desc"],
					order = 37,
					width = "full",
				},
			},
		},
		TooltipGroup = {
			type = "group",
			order = 20,
			name = _L["options_tooltip_settings"],
			desc = _L["options_tooltip_settings_desc"],
			inline = true,
			args = {
				show_loot = {
					type = "toggle",
					arg = "show_loot",
					name = _L["options_toggle_show_loot"],
					desc = _L["options_toggle_show_loot_desc"],
					order = 102,
				},
				show_notes = {
					type = "toggle",
					arg = "show_notes",
					name = _L["options_toggle_show_notes"],
					desc = _L["options_toggle_show_notes_desc"],
					order = 103,
				},
			},
		},
		GeneralGroup = {
			type = "group",
			order = 30,
			name = _L["options_general_settings"],
			desc = _L["options_general_settings_desc"],
			inline = true,
			args = {
				leave_group_on_search = {
					type = "toggle",
					arg = "leave_group_on_search",
					name = _L["options_toggle_leave_group_on_search"],
					desc = _L["options_toggle_leave_group_on_search_desc"],
					order = 102,
				},
				include_player_seen = {
					type = "toggle",
					arg = "include_player_seen",
					name = _L["options_toggle_include_player_seen"],
					desc = _L["options_toggle_include_player_seen_desc"],
					order = 102,
				},
				show_debug = {
					type = "toggle",
					arg = "show_debug",
					name = _L["options_toggle_show_debug"],
					desc = _L["options_toggle_show_debug_desc"],
					order = 102,
				},
			},
		},
    },
}

-- iterate this until we have all items cache. max 10 iterations
local precacheIteration = 0;
local function cacheItems()
	--print ("grab items");
	precacheIteration = precacheIteration + 1;
	local failed = 0;
	local total = 0;
	for mapId, mapFile in pairs( nodes ) do
		for i,node in ipairs( nodes[mapId] ) do
			local t, f = updateLoot( node );
			total = total + t;
			failed = failed + f;
			-- preload localized npc names
			if ( node["npcId"] ~= nil ) then
				getCreatureNamebyID( node["npcId"] );
			end
		end
	end
	if ( failed > 0 and precacheIteration < 10 ) then 
		debugMsg( "Failed: " .. failed .. " / " .. total );
		C_Timer.After(3, function()
			cacheItems();
		end );
	else
		debugMsg( "Got all items" );
	end
end

--
--
--	Main
--
--

function Argus:OnInitialize()
    local defaults = {
        profile = {
            icon_scale_treasures = 2.0,
            icon_scale_rares = 1.875,
            icon_scale_pets = 1.5,
			icon_scale_sfll = 3.25,
            icon_alpha_treasures = 0.5,
			icon_alpha_rares = 0.75,
			icon_alpha_pets = 1.0,
			icon_alpha_sfll = 1.0,
            alwaysshowrares = false,
            alwaysshowtreasures = false,
			alwaysshowsfll = false,
			nodeRareGlow = true,
            save = true,
            treasure_aw = true,
            treasure_kr = true,
            treasure_ma = true,
            rare_aw = true,
            rare_kr = true,
            rare_ma = true,
			pet_aw = true,
			pet_kr = true,
			pet_ma = true,
			sfll_aw = true,
			sfll_kr = true,
			sfll_ma = true,
			invasion = true,
            show_loot = true,
            show_notes = true,
			leave_group_on_search = false,
			show_debug = false,
			include_player_seen = false,
			alwaysTrackCoA = false,
			birthday13 = true,
			alwaysShowBirthday13 = false,
        },
    }

    self.db = LibStub("AceDB-3.0"):New("HandyNotesArgusDB", defaults, "Default");
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter");
	local name = UnitName("player");
	local realm = GetRealmName();
	MYSELF = name .. "-" .. realm;
	lastRareResetSlot = getCurrentTimeSlot();
	--updateInvasionPOI:RegisterEvent("WORLD_MAP_UPDATE");
	communicator:RegisterEvent("PLAYER_ENTERING_WORLD");
	communicator:RegisterEvent("GROUP_ROSTER_UPDATE");
	communicator:RegisterEvent("GROUP_JOINED");
	communicator:RegisterEvent("CHAT_MSG_ADDON");
	finderFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
	finderFrame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED");
	finderFrame:RegisterEvent("LFG_LIST_SEARCH_FAILED");
	finderFrame:RegisterEvent("LFG_LIST_ENTRY_EXPIRED_TIMEOUT");
	finderFrame:RegisterEvent("LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS");
	--trackAchievements:RegisterEvent("CRITERIA_EARNED");
	--trackAchievements:RegisterEvent("CRITERIA_COMPLETE");
	C_ChatInfo.RegisterAddonMessagePrefix( ADDON_MSG_PREFIX );
	--WorldMapTooltip:HookScript("OnShow", function()
		-- print( "wmtt" );
	--end );
	
	--hooksecurefunc( "TaskPOI_OnEnter", function( self )
		--WorldMapTooltip:AddLine ("quest ID: " .. self.questID)
		--print (self.questID)
	--end );

	--hooksecurefunc( "TaskPOI_OnLeave", function ( self )
	--end );
	
	--TaskPOI_OnClick
end

function Argus:WorldEnter()
	prepareNodesData();
    self:UnregisterEvent("PLAYER_ENTERING_WORLD");
    self:ScheduleTimer("RegisterWithHandyNotes", 8);
	self:ScheduleTimer("LoadCheck", 6);
	C_Timer.After(10, function()
		cacheItems();
	end );
end

function Argus:RegisterWithHandyNotes()
    do
		local currentMapFile = "";
        local function iter( t, prestate )

		if not t then return nil end
			
			local node;
			local now = getCurrentTimeSlot();
			if ( prestate ) then
				node = t[1]["lookup"][prestate]["nextNode"];
			else
				checkResetNPCGroupCounts();
				--if ( Argus.db.profile.alwaysTrackCoA ) then
					updateCommanderOfArgusCriteria();
				--end
				node = t[1]
			end

			while node do
                if ( self.db.profile[node["group"]] and Argus:ShowNode( currentMapFile, node ) ) then
					local iconScale = 1;
					local iconAlpha = 1;
					local iconPath = iconDefaults[node["icon"]];
					if ( (string.find(node["group"], "rare") ~= nil) or (string.find(node["group"], "invasion") ~= nil) ) then
						iconScale = self.db.profile.icon_scale_rares;
						iconAlpha = self.db.profile.icon_alpha_rares;
						local icon = "skullWhite";
						if ( not node["allLootKnown"] or node["missingForCoA"] ) then
							icon = "skullBlue";
						end
						if ( ( node["confUp"] > 0.75 or ( self.db.profile.include_player_seen and node["seen"] and node["seen"]["timeSlot"] == now ) ) and self.db.profile.nodeRareGlow ) then
							icon = icon .. "GreenGlow";
						elseif ( node["confUp"] > 0.2 and self.db.profile.nodeRareGlow ) then
							icon = icon .. "RedGlow";
						end
						iconPath = iconDefaults[icon];
					elseif ( (string.find(node["group"], "treasure") ~= nil)) then
						iconScale = self.db.profile.icon_scale_treasures;
						iconAlpha = self.db.profile.icon_alpha_treasures;
					elseif ( (string.find(node["group"], "pet") ~= nil)) then
						iconScale = self.db.profile.icon_scale_pets;
						iconAlpha = self.db.profile.icon_alpha_pets;
					elseif ( (string.find(node["group"], "sfll") ~= nil)) then
						iconScale = self.db.profile.icon_scale_sfll;
						iconAlpha = self.db.profile.icon_alpha_sfll;
					end
                    return node["coord"], nil, iconPath, iconScale, iconAlpha
                end
				node = node["nextNode"];
            end
        end

        function Argus:GetNodes( mapFile, isMinimapUpdate, dungeonLevel )
			currentMapFile = mapFile;
            return iter, nodes[mapFile], nil
        end
    end

    HandyNotes:RegisterPluginDB("HandyNotesArgus", self, options)
    self:RegisterBucketEvent({ "LOOT_CLOSED", "PLAYER_MONEY", "SHOW_LOOT_TOAST", "SHOW_LOOT_TOAST_UPGRADE" }, 2, "Refresh")
    self:Refresh()
end
 
function Argus:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", "HandyNotesArgus")
end

function Argus:ShowNode( mapFile, node )
	if ( not self.db.profile[node["group"]] ) then return false end
	if ( not self.db.profile.birthday13 ) then return false end
	if ( self.db.profile.alwaysShowBirthday13 and (string.find(node["group"], "birthday13") ~= nil) ) then return true end
    if ( self.db.profile.alwaysshowtreasures and (string.find(node["group"], "treasure") ~= nil) ) then return true end
    if ( self.db.profile.alwaysshowrares and (string.find(node["group"], "rare") ~= nil) ) then return true end
	if ( self.db.profile.alwaysshowsfll and (string.find(node["group"], "sfll") ~= nil) ) then return true end
    if ( self.db.char[mapFile .. "_" .. node["coord"] .. "_" .. node["questId"]] and self.db.profile.save ) then return false end
	if ( self.db.profile.hideKnowLoot and node["allLootKnown"] == true and node["loot"] ~= nil and not node["missingForCoA"] and string.find(node["group"], "rare") ~= nil ) then return false end
    if ( IsQuestFlaggedCompleted( node["questId"] ) ) then return false end
    return true
end

function Argus:LoadCheck()

	if (IsAddOnLoaded("TomTom")) then 
		isTomTomloaded = true
	end

	if (IsAddOnLoaded("CanIMogIt")) then 
		isCanIMogItloaded = true
	end

end
