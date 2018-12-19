-- For the gnomes!!!
local VERSION = "0.1.0";

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

local Arathi = LibStub("AceAddon-3.0"):NewAddon("ArathiRaresTreasures", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
local _L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes_Arathi");
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
	cave = {
		icon = objAtlas,
		tCoordLeft = 439/512, tCoordRight = 470/512, tCoordTop = 62/512, tCoordBottom = 95/512,
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

Arathi.nodes = {};
local nodes = Arathi.nodes;
local nodeRef = {
	rares = {}
};

-- [XXXXYYYY] = { questId, icon, group, label, loot, note, search },
-- /run local find="Albino"; for i,mid in ipairs(C_MountJournal.GetMountIDs()) do local n,_,_,_,_,_,_,_,_,_,c,j=C_MountJournal.GetMountInfoByID(mid); if ( n:match(find) ) then print(j .. " " .. n); end end
-- /run local find="Squa"; for i=0,3200 do local n=C_PetJournal.GetPetInfoBySpeciesID(i); if ( n and string.find(n,find) ) then print(i .. " " .. n); end end
-- { itemId = 152903, itemType = itemTypeMount, mountId = 981 } Biletooth Gnasher any rare??

-- { itemId = 152903, itemType = itemTypeMisc }
-- { itemId = 152903, itemType = itemTypeMount, mountId = 981 }
-- { itemId = 153126, itemType = itemTypeToy }
-- { itemId = 153329, itemType = itemTypeTransmog, slot = _L["Dagger"] }
-- { itemId = 163689, itemType = itemTypePet, speciesId = 2437 }

nodes["Arathi"] = {
	{ coord = 37093921, npcId = 138122, questId = { 53002 }, icon = "skull_grey", group = "rare_arathi", label = _L["Doom's Howl"], loot = { { itemId = 163828, itemType = itemTypeToy } }, note = _L["Alliance only"], faction = "Alliance", controllingFaction = "Alliance" },
	{ coord = 21752217, npcId = 142508, questId = { 53013, 53505 }, icon = "skull_grey", group = "rare_arathi", label = _L["Branchlord Aldrus"], loot = { { itemId = 163650, itemType = itemTypePet, speciesId = 2433 } }, note = nil },
	{ coord = 33693676, npcId = nil,	questId = { 53014, 53518 }, icon = "cave", group = "cave_arathi", label = _L["Overseer Krix_cave"], loot = {}, note = nil, controllingFaction = "Alliance" },
	{ coord = 32923847, npcId = 142423, questId = { 53014, 53518 }, icon = "skull_grey", group = "rare_arathi", label = _L["Overseer Krix"], loot = { { itemId = 163646, itemType = itemTypeMount, mountId = 1182 } }, note = nil, controllingFaction = "Alliance" },
	{ coord = 27485560, npcId = nil,	questId = { 53014, 53518 }, icon = "cave", group = "cave_arathi", label = _L["Overseer Krix_cave"], loot = {}, note = nil, controllingFaction = "Horde" },
	{ coord = 27255710, npcId = 142423, questId = { 53014, 53518 }, icon = "skull_grey", group = "rare_arathi", label = _L["Overseer Krix"], loot = { { itemId = 163646, itemType = itemTypeMount, mountId = 1182 } }, note = nil, controllingFaction = "Horde" },
	{ coord = 13273534, npcId = 142440, questId = { 53015, 53529 }, icon = "skull_grey", group = "rare_arathi", label = _L["Yogursa"], loot = { { itemId = 163684, itemType = itemTypePet, speciesId = 2436 } }, note = nil },
	{ coord = 18412794, npcId = 142436, questId = { 53016, 53522 }, icon = "skull_grey", group = "rare_arathi", label = _L["Ragebeak"], loot = { { itemId = 163689, itemType = itemTypePet, speciesId = 2437 } }, note = nil, controllingFaction = "Alliance" },
	{ coord = 11905220, npcId = 142436, questId = { 53016, 53522 }, icon = "skull_grey", group = "rare_arathi", label = _L["Ragebeak"], loot = { { itemId = 163689, itemType = itemTypePet, speciesId = 2437 } }, note = nil, controllingFaction = "Horde" },
	{ coord = 30604475, npcId = 141615, questId = { 53017, 53506 }, icon = "skull_grey", group = "rare_arathi", label = _L["Burning Goliath"], loot = { { itemId = 163691, itemType = itemTypeMisc } }, note = nil },
	{ coord = 62513084, npcId = 141618, questId = { 53018, 53531 }, icon = "skull_grey", group = "rare_arathi", label = _L["Cresting Goliath"], loot = { { itemId = 163700, itemType = itemTypeMisc } }, note = nil },
	--{ coord = 51045319, npcId = 142433, questId = { 53019 }, icon = "skull_grey", group = "rare_arathi", label = _L["Fozruk"], loot = { { itemId = 163711, itemType = itemTypePet, speciesId = 2440 } }, note = nil },
	{ coord = 59422773, npcId = 142433, questId = { 53019, 53510 }, icon = "skull_grey", group = "rare_arathi", label = _L["Fozruk"], loot = { { itemId = 163711, itemType = itemTypePet, speciesId = 2440 } }, note = nil },
	{ coord = 35606435, npcId = 142435, questId = { 53020, 53519 }, icon = "skull_grey", group = "rare_arathi", label = _L["Plaguefeather"], loot = { { itemId = 163690, itemType = itemTypePet, speciesId = 2438 } }, note = nil },
	{ coord = 29405834, npcId = 141620, questId = { 53021, 53523 }, icon = "skull_grey", group = "rare_arathi", label = _L["Rumbling Goliath"], loot = { { itemId = 163701, itemType = itemTypeMisc } }, note = nil },
	{ coord = 57154575, npcId = 142437, questId = { 53022, 53526 }, icon = "skull_grey", group = "rare_arathi", label = _L["Skullripper"], loot = { { itemId = 163645, itemType = itemTypeMount, mountId = 1183 } }, note = nil },
	{ coord = 46245222, npcId = 141616, questId = { 53023, 53527 }, icon = "skull_grey", group = "rare_arathi", label = _L["Thundering Goliath"], loot = { { itemId = 163698, itemType = itemTypeMisc } }, note = nil },
	{ coord = 56945330, npcId = 142438, questId = { 53024, 53528 }, icon = "skull_grey", group = "rare_arathi", label = _L["Venomarus"], loot = { { itemId = 163648, itemType = itemTypePet, speciesId = 2432 } }, note = nil },
	{ coord = 47657800, npcId = 141942, questId = { 53057, 53516 }, icon = "skull_grey", group = "rare_arathi", label = _L["Molok the Crusher"], loot = { { itemId = 163775, itemType = itemTypeToy } }, note = nil },
	{ coord = 48117953, npcId = nil,	questId = { 53058 }, icon = "cave", group = "cave_arathi", label = _L["Kor'gresh Coldrage_cave"], loot = {}, note = nil },
	{ coord = 49318426, npcId = 142112, questId = { 53058, 53513 }, icon = "skull_grey", group = "rare_arathi", label = _L["Kor'gresh Coldrage"], loot = { { itemId = 163744, itemType = itemTypeToy } }, note = nil },
	{ coord = 57073506, npcId = 141668, questId = { 53059, 53508 }, icon = "skull_grey", group = "rare_arathi", label = _L["Echo of Myzrael"], loot = { { itemId = 163677, itemType = itemTypePet, speciesId = 2435 } }, note = nil },
	{ coord = 78153687, npcId = nil,	questId = { 53060, 53511 }, icon = "cave", group = "cave_arathi", label = _L["Geomancer Flintdagger_cave"], loot = {}, note = nil },
	{ coord = 79532945, npcId = 142662, questId = { 53060, 53511 }, icon = "skull_grey", group = "rare_arathi", label = _L["Geomancer Flintdagger"], loot = { { itemId = 163713, itemType = itemTypeToy } }, note = nil },
	{ coord = 65347116, npcId = 142709, questId = { 53083, 53504 }, icon = "skull_grey", group = "rare_arathi", label = _L["Beastrider Kama"], loot = { { itemId = 163644, itemType = itemTypeMount, mountId = 1180 } }, note = nil },
	{ coord = 50673675, npcId = 142688, questId = { 53084, 53507 }, icon = "skull_grey", group = "rare_arathi", label = _L["Darbel Montrose"], loot = { { itemId = 163652, itemType = itemTypePet, speciesId = 2434 } }, note = nil, controllingFaction = "Alliance" },
	{ coord = 50756121, npcId = 142688, questId = { 53084, 53507 }, icon = "skull_grey", group = "rare_arathi", label = _L["Darbel Montrose"], loot = { { itemId = 163652, itemType = itemTypePet, speciesId = 2434 } }, note = nil, controllingFaction = "Horde" },
	{ coord = 53565764, npcId = 142741, questId = { 53085 }, icon = "skull_grey", group = "rare_arathi", label = _L["Doomrider Helgrim"], loot = { { itemId = 163579, itemType = itemTypeMount, mountId = 1174 } }, note = _L["Alliance only"], faction = "Alliance", controllingFaction = "Alliance" },
	{ coord = 28594559, npcId = nil,	questId = { 53086, 53509 }, icon = "cave", group = "cave_arathi", label = _L["Foulbelly_cave"], loot = {}, note = nil },
	{ coord = 22305106, npcId = 142686, questId = { 53086, 53509 }, icon = "skull_grey", group = "rare_arathi", label = _L["Foulbelly"], loot = { { itemId = 163735, itemType = itemTypeToy } }, note = _L["In cave"] },
	{ coord = 26723278, npcId = 142725, questId = { 53087, 53512 }, icon = "skull_grey", group = "rare_arathi", label = _L["Horrific Apparition"], loot = { { itemId = 163736, itemType = itemTypeToy } }, note = nil, controllingFaction = "Alliance" },
	{ coord = 19406120, npcId = 142725, questId = { 53087, 53512 }, icon = "skull_grey", group = "rare_arathi", label = _L["Horrific Apparition"], loot = { { itemId = 163736, itemType = itemTypeToy } }, note = nil, controllingFaction = "Horde" },
	{ coord = 28594560, npcId = nil,	questId = { 53089, 53514 }, icon = "cave", group = "cave_arathi", label = _L["Kovork_cave"], loot = {}, note = nil },
	{ coord = 25294856, npcId = 142684, questId = { 53089, 53514 }, icon = "skull_grey", group = "rare_arathi", label = _L["Kovork"], loot = { { itemId = 163750, itemType = itemTypeToy } }, note = _L["In cave"] },
	{ coord = 51827562, npcId = 142716, questId = { 53090, 53515 }, icon = "skull_grey", group = "rare_arathi", label = _L["Man-Hunter Rog"], loot = { { itemId = 163689, itemType = itemTypePet, speciesId = 2441 } }, note = nil },
	{ coord = 67486058, npcId = 142692, questId = { 53091, 53517 }, icon = "skull_grey", group = "rare_arathi", label = _L["Nimar the Slayer"], loot = { { itemId = 163706, itemType = itemTypeMount, mountId = 1185 } }, note = nil },
	{ coord = 51213999, npcId = 142690, questId = { 53093, 53525 }, icon = "skull_grey", group = "rare_arathi", label = _L["Singer"], loot = { { itemId = 163738, itemType = itemTypeToy } }, note = nil, controllingFaction = "Alliance" },
	{ coord = 50705748, npcId = 142690, questId = { 53093, 53525 }, icon = "skull_grey", group = "rare_arathi", label = _L["Singer"], loot = { { itemId = 163738, itemType = itemTypeToy } }, note = nil, controllingFaction = "Horde" },
	{ coord = 63257752, npcId = nil,	questId = { 53089, 53530 }, icon = "cave", group = "cave_arathi", label = _L["Zalas Witherbark_cave"], loot = {}, note = nil },
	{ coord = 62858120, npcId = 142682, questId = { 53094, 53530 }, icon = "skull_grey", group = "rare_arathi", label = _L["Zalas Witherbark"], loot = { { itemId = 163745, itemType = itemTypeToy } }, note = nil },
	{ coord = 42905660, npcId = 142683, questId = { 53092, 53524 }, icon = "skull_grey", group = "rare_arathi", label = _L["Ruul Onestone"], loot = { { itemId = 163741, itemType = itemTypeToy } }, note = nil },
	{ coord = 48913996, npcId = 142739, questId = { 53088 }, icon = "skull_grey", group = "rare_arathi", label = _L["Knight-Captain Aldrin"], loot = { { itemId = 163578, itemType = itemTypeMount, mountId = 1173 } }, note = _L["Horde only"], faction = "Horde", controllingFaction = "Horde" },
	{ coord = 39093921, npcId = 137374, questId = { 53001 }, icon = "skull_grey", group = "rare_arathi", label = _L["The Lion's Roar"], loot = { { itemId = 163829, itemType = itemTypeToy } }, note = _L["Horde only"], faction = "Horde", controllingFaction = "Horde" },
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
local MYFACTION = nil;
local arathiControllingFaction = nil;

--
--
--	Helpers
--
--

local function debugMsg( msg )
	if ( Arathi.db.profile.show_debug ) then
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
			if ( i < numNodes ) then
				node["nextNode"] = nodes[mapId][i+1];
			else
				node["nextNode"] = nil;
			end
			lookup[node["coord"]] = node;
		end
	end
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

local npc_tooltip = CreateFrame("GameTooltip", "HandyNotesArathi_npcToolTip", UIParent, "GameTooltipTemplate")
local tooltip_label

local function getCreatureNamebyID(id)
	npc_tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	npc_tooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
	tooltip_label = _G["HandyNotesArathi_npcToolTipTextLeft1"]:GetText()
end

function Arathi:OnEnter( mapFile, coord )
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
	if ( Arathi.db.profile.show_debug ) then
		if ( node["ratioLfgGroups"] ) then
			label = label .. " (" .. string.format("%.2f", node["ratioLfgGroups"] ) .. ")";
		end
		if ( node["seen"] and node["seen"]["timeSlot"] == getCurrentTimeSlot() ) then
			label = label .. " +";
		end
	end
	tooltip:SetText( label );
	if ( Arathi.db.profile.show_notes == true and node["note"] and node["note"] ~= nil ) then
		-- note
		tooltip:AddLine( node["note"], nil, nil, nil, true );
	end
    if (	( Arathi.db.profile.show_loot == true ) and
			( node["loot"] ~= nil ) and
			( type(node["loot"]) == "table" ) ) then
		local ii;
		local loot = node["loot"];
		for ii = 1, #loot do
			local itemLink;
			if ( loot[ii]["itemId"] ) then
				_, itemLink, _, _, _, _, _, _, _, _ = GetItemInfo( loot[ii]["itemId"] );
				if ( not itemLink ) then
					itemLink = "Retrieving data ...";
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
	
    tooltip:Show();
	
	if ( itemDataMissing == true ) then
		-- try refreshing if itemlinks are missing
		C_Timer.After( 1, function()
			Arathi:Refresh();
		end );
	end
end

local function hideNode(button, mapFile, coord)
	local node = GetNodeByCoord( mapFile, coord );
    if ( node and node["questId"][1] ~= nil) then
        Arathi.db.char[mapFile .. "_" .. coord .. "_" .. node["questId"][1]] = true;
    end

    Arathi:Refresh()
end

local function ResetDB()
    table.wipe(Arathi.db.char)
    Arathi:Refresh()
end

local function addtoTomTom(button, mapFile, coord)
	print( mapFile );
	local node = GetNodeByCoord( mapFile, coord );
	if ( node and isTomTomloaded == true ) then
		local mapId = HandyNotes:GetMapFiletoMapID( mapFile );
		local x, y = HandyNotes:getXY(  coord );
		local desc = node["label"];

		TomTom:AddWaypoint(14, x, y, {
			title = desc,
			persistent = nil,
			minimap = true,
			world = true
		});
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

local HandyNotes_ArathiDropdownMenu = CreateFrame("Frame", "HandyNotes_ArathiDropdownMenu")
HandyNotes_ArathiDropdownMenu.displayMode = "MENU"
HandyNotes_ArathiDropdownMenu.initialize = generateMenu

function Arathi:OnClick(button, down, mapFile, coord)
	local node = GetNodeByCoord( mapFile, coord );
	if ( not node ) then return end
    if button == "RightButton" and down then
		-- context menu
        clickedMapFile = mapFile
        clickedCoord = coord
        ToggleDropDownMenu(1, nil, HandyNotes_ArathiDropdownMenu, self, 0, 0)
	elseif button == "MiddleButton" and down then
		-- create group
	elseif button == "LeftButton" and down then
    end
end

function Arathi:OnLeave( mapFile, coord )
    if self:GetParent() == WorldMapButton then
        WorldMapTooltip:Hide()
    else
        GameTooltip:Hide()
    end
end

local options = {
    type = "group",
    name = "战争前线阿拉希", --_L["Arathi"],
    get = function(info) return Arathi.db.profile[info.arg] end,
    set = function(info, v) Arathi.db.profile[info.arg] = v; Arathi:Refresh() end,
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
				groupIconCaves = {
					type = "header",
					name = _L["options_icons_caves"],
					desc = _L["options_icons_caves_desc"],
					order = 30,
				},
				icon_scale_caves = {
					type = "range",
					name = _L["options_scale"],
					desc = _L["options_scale_desc"],
					min = 0.25, max = 10, step = 0.01,
					arg = "icon_scale_caves",
					order = 31,
				},
				icon_alpha_caves = {
					type = "range",
					name = _L["options_opacity"],
					desc = _L["options_opacity_desc"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_caves",
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
					name = _L["Arathi"],
					order = 0,
				},
				treasureArathi = {
					type = "toggle",
					arg = "treasure_arathi",
					name = _L["options_toggle_treasures"],
					order = 1,
					width = "normal",
				},
				rareArathi = {
					type = "toggle",
					arg = "rare_arathi",
					name = _L["options_toggle_rares"],
					order = 2,
					width = "normal",
				},
				petArathi = {
					type = "toggle",
					arg = "pet_arathi",
					name = _L["options_toggle_battle_pets"],
					order = 3,
					width = "normal",
				},
				npcArathi = {
					type = "toggle",
					arg = "npc_arathi",
					name = _L["options_toggle_npcs"],
					order = 5,
					width = "normal",
				},
				caveArathi = {
					type = "toggle",
					arg = "cave_arathi",
					name = _L["options_toggle_caves"],
					order = 6,
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
				hideKnowLoot = {
					type = "toggle",
					arg = "hideKnowLoot",
					name = _L["options_toggle_hideKnowLoot"],
					desc = _L["options_toggle_hideKnowLoot_desc"],
					order = 35,
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

function Arathi:OnInitialize()
    local defaults = {
        profile = {
            icon_scale_treasures = 2.0,
            icon_scale_rares = 1.25,
			icon_scale_caves = 1.5,
            icon_scale_pets = 1.5,
            icon_alpha_treasures = 0.5,
			icon_alpha_rares = 0.75,
			icon_alpha_caves = 0.75,
			icon_alpha_pets = 1.0,
            alwaysshowrares = false,
            alwaysshowtreasures = false,
            save = true,
            treasure_arathi = true,
            rare_arathi = true,
			pet_arathi = true,
			cave_arathi = true,
            show_loot = true,
            show_notes = true,
			show_debug = false,
        },
    }

    self.db = LibStub("AceDB-3.0"):New("HandyNotesArathiDB", defaults, "Default");
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter");
	local name = UnitName("player");
	local realm = GetRealmName();
	MYSELF = name .. "-" .. realm;
	MYFACTION = UnitFactionGroup("player")
	--updateInvasionPOI:RegisterEvent("WORLD_MAP_UPDATE");
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

function Arathi:WorldEnter()
	prepareNodesData();
    self:UnregisterEvent("PLAYER_ENTERING_WORLD");
    self:ScheduleTimer("RegisterWithHandyNotes", 8);
	self:ScheduleTimer("LoadCheck", 6);
	C_Timer.After(10, function()
		cacheItems();
	end );
end

function Arathi:RegisterWithHandyNotes()
    do
		local currentMapFile = "";
        local function iter( t, prestate )

		if not t then return nil end
			
			local node;
			if ( prestate ) then
				node = t[1]["lookup"][prestate]["nextNode"];
			else
				node = t[1]
				local hordeZones = {};
				for i,contributionId in ipairs(hordeZones) do
					local state = C_ContributionCollector.GetState(contributionId);
					if state == 2 then
						-- zone is currently active == faction is not controlling arathi
						arathiControllingFaction = "Alliance";
					end
					if state == 4 then
						-- zone is currently destroyed == faction is controlling arathi
						arathiControllingFaction = "Horde";
					end
				end
				local allianceZones = {};
				for i,contributionId in ipairs(allianceZones) do
					local state = C_ContributionCollector.GetState(contributionId);
					if state == 2 then
						-- zone is currently active == faction is not controlling arathi
						arathiControllingFaction = "Horde";
					end
					if state == 4 then
						-- zone is currently destroyed == faction is controlling arathi
						arathiControllingFaction = "Alliance";
					end
				end
				local state = C_ContributionCollector.GetState(11); -- Battle for Stromgarde
				if state == 1 or state == 2 then
					-- zone is currently active == faction is not controlling arathi
					arathiControllingFaction = "Alliance";
				end
				if state == 3 or state == 4 then
					-- zone is currently destroyed == faction is controlling arathi
					arathiControllingFaction = "Horde";
				end
			end

			while node do
                if ( self.db.profile[node["group"]] and Arathi:ShowNode( currentMapFile, node ) ) then
					local iconScale = 1;
					local iconAlpha = 1;
					local iconPath = iconDefaults[node["icon"]];
					if ( (string.find(node["group"], "rare") ~= nil) ) then
						iconScale = self.db.profile.icon_scale_rares;
						iconAlpha = self.db.profile.icon_alpha_rares;
						local icon = "skullWhite";
						if ( not node["allLootKnown"] ) then
							icon = "skullBlue";
						end
						iconPath = iconDefaults[icon];
					elseif ( (string.find(node["group"], "treasure") ~= nil)) then
						iconScale = self.db.profile.icon_scale_treasures;
						iconAlpha = self.db.profile.icon_alpha_treasures;
					elseif ( (string.find(node["group"], "pet") ~= nil)) then
						iconScale = self.db.profile.icon_scale_pets;
						iconAlpha = self.db.profile.icon_alpha_pets;
					elseif ( (string.find(node["group"], "cave") ~= nil)) then
						iconScale = self.db.profile.icon_scale_caves;
						iconAlpha = self.db.profile.icon_alpha_caves;
					end
                    return node["coord"], nil, iconPath, iconScale, iconAlpha
                end
				node = node["nextNode"];
            end
        end

        function Arathi:GetNodes( mapFile, isMinimapUpdate, dungeonLevel )
			-- print( mapFile );
			currentMapFile = mapFile;
            return iter, nodes[mapFile], nil
        end
    end

    HandyNotes:RegisterPluginDB("HandyNotesArathiAby", self, options)
    self:RegisterBucketEvent({ "LOOT_CLOSED", "PLAYER_MONEY", "SHOW_LOOT_TOAST", "SHOW_LOOT_TOAST_UPGRADE" }, 2, "Refresh")
    self:Refresh()
end
 
function Arathi:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", "HandyNotesArathiAby")
end

function Arathi:ShowNode( mapFile, node )
	if ( not self.db.profile[node["group"]] ) then return false end
    if ( self.db.profile.alwaysshowtreasures and (string.find(node["group"], "treasure") ~= nil) ) then return true end
    if ( self.db.profile.alwaysshowrares and ( (string.find(node["group"], "rare") ~= nil ) or (string.find(node["group"], "cave") ~= nil ) ) ) then return true end
    if ( self.db.char[mapFile .. "_" .. node["coord"] .. "_" .. node["questId"][1]] and self.db.profile.save ) then return false end
	if ( self.db.profile.hideKnowLoot and node["allLootKnown"] == true and node["loot"] ~= nil and string.find(node["group"], "rare") ~= nil ) then return false end
	if ( arathiControllingFaction ~= nil and node["controllingFaction"] ~= nil and node["controllingFaction"] ~= arathiControllingFaction ) then return false end
	if ( MYFACTION ~= nil and node["faction"] ~= nil and node["faction"] ~= MYFACTION ) then return false end
	for i,q in pairs(node["questId"]) do
		-- print( node["questId"][i] );
		if ( IsQuestFlaggedCompleted( node["questId"][i] ) ) then return false end
	end
    return true
end

function Arathi:LoadCheck()

	if (IsAddOnLoaded("TomTom")) then 
		isTomTomloaded = true
	end

	if (IsAddOnLoaded("CanIMogIt")) then 
		isCanIMogItloaded = true
	end

end
