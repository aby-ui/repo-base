--[[----------------------------------------------------
	LibItemString - Easy Access to ItemString Properties
	----------------------------------------------------
	LibItemString:New(itemLink)
	* Returns an itemStringTable instance
	* Can easily be accessed using property field names
	* No need to remember which index a certain field has
	----------------------------------------------------
	Creating an ItemString Instance - Examples:
	* is = LibItemString:New(itemLink);
	* if (is.enchant ~= 0) then print("item is enchanted"); end
	* itemID = is[1]; itemID = is.itemID;
	* itemStringLabel:SetText(tostring(is));
	----------------------------------------------------
	LibItemString:GetTrueItemLevel(itemLink)
	* Returns the true itemLevel, based on a tooltip scan
	----------------------------------------------------
	GetUpgradedItemLevelFromItemLink(itemLink)
	* Now obsolete - included for compatibility reason
	* Use LibItemString:GetTrueItemLevel(itemLink) instead
	----------------------------------------------------
	Changelog:
	* REV-01 (16.08.30) Patch 7.0.3:	Replaces "GetUpgradedItemLevel.lua", but stays compatible
]]------------------------------------------------------

-- Abort if library has already loaded with the same or newer revision
local REVISION = 1;
if (type(LibItemString) == "table") and (REVISION <= LibItemString.REVISION) then
	return;
end

LibItemString = LibItemString or {};
local LIS = LibItemString;			-- local shortcut
LIS.REVISION = REVISION;
LIS.ScanTip = LIS.ScanTip or CreateFrame("GameTooltip","LibItemStringScanTip",nil,"GameTooltipTemplate");
LIS.ScanTip:SetOwner(UIParent,"ANCHOR_NONE");

GET_UPGRADED_ITEM_LEVEL_REV = 12;	-- this replaces REV-11 of "GetUpgradedItemLevel.lua"

--------------------------------------------------------------------------------------------------------
--                                      Constants / Data Tables                                       --
--------------------------------------------------------------------------------------------------------

-- The number of tooltip lines to scan for the level text
LIS.TOOLTIP_MAXLINE_LEVEL = 5;

-- Pattern to extract the actual itemLevel from the tooltip text line
LIS.ITEM_LEVEL_PATTERN = ITEM_LEVEL:gsub("%%d","(%%d+)");

-- Extraction pattern for the exact itemString, including all its properties
LIS.ITEMSTRING_PATTERN = "(item:[^|]+)";

-- Index of the named itemString property
LIS.ITEMSTRING_PROPERTY_INDEX = {
	-- item --
	itemID					= 1,
	enchant					= 2,
	gemID1					= 3,
	gemID2					= 4,
	gemID3					= 5,
	gemID4					= 6,
	suffixID				= 7,
	uniqueID				= 8,
	linkLevel				= 9,
	specializationID		= 10,
	upgradeTypeID			= 11,
	instanceDifficultyID	= 12,
	numBonusIDs				= 13,
--	bonusID1				= 14,
--	bonusID2				= 15,
--	...
	upgradeValue			= -1,	-- negative value means the absolute index is relative to the last bonusID index
	unknown1				= -2,
	unknown2				= -3,
	unknown3				= -4,
}

-- Table for adjustment of levels due to upgrade -- Source: http://www.wowinterface.com/forums/showthread.php?t=45388
LIS.UPGRADED_LEVEL_ADJUST = {
	[001] = 8, -- 1/1
	-- Patch 5.1 --
	[373] = 4, -- 1/2
	[374] = 8, -- 2/2
	[375] = 4, -- 1/3
	[376] = 4, -- 2/3
	[377] = 4, -- 3/3
	[379] = 4, -- 1/2
	[380] = 4, -- 2/2
--	[445] = 0, -- 0/2
	[446] = 4, -- 1/2
	[447] = 8, -- 2/2
--	[451] = 0, -- 0/1
	[452] = 8, -- 1/1
--	[453] = 0, -- 0/2
	[454] = 4, -- 1/2
	[455] = 8, -- 2/2
--	[456] = 0, -- 0/1
	[457] = 8, -- 1/1
--	[458] = 0, -- 0/4
	[459] = 4, -- 1/4
	[460] = 8, -- 2/4
	[461] = 12, -- 3/4
	[462] = 16, -- 4/4
	-- Patch 5.3 --
--	[465] = 0,
	[466] = 4,
	[467] = 8,
	-- Patch ?? --
--	[468] = 0,
	[469] = 4,
	[470] = 8,
	[471] = 12,
	[472] = 16,
	-- Patch 5.4 --
--	[491] = 0,
	[492] = 4,
	[493] = 8,
--	[494] = 0,
	[495] = 4,
	[496] = 8,
	[497] = 12,
	[498] = 16,
	-- Patch 5.4.8 --
	[504] = 12,	-- US/EU upgrade 3/4
	[505] = 16,	-- US/EU upgrade 4/4
	[506] = 20,	-- Asia upgrade 5/6
	[507] = 24,	-- Asis upgrade 6/6
	-- Patch 6.2.3 --
--	[529] = 0,	-- WoD upgrade 0/2
	[530] = 5,	-- WoD upgrade 1/2
	[531] = 10,	-- WoD upgrade 2/2
	-- Patch ?? --
	[535] = 15,
	[536] = 30,
	[537] = 45,
};

-- Table for adjustment of levels due to Timewarped. These are fixed itemLevels, not upgrade amounts.
LIS.TIMEWARPED_LEVEL_ADJUST = {
	-- Patch 6.2 --
	[615] = 660, -- Dungeon drops
	[692] = 675, -- Timewarped badge vendors
};

-- Table for adjustment of levels due to Timewarped Warforged. These are fixed itemLevels, not upgrade amounts.
LIS.TIMEWARPED_WARFORGED_LEVEL_ADJUST = {
	-- Patch 6.2 --
	-- Cidrei: Yes, this really is a table of all levels between 71 and 99. The scaling matches Heirlooms up to level 97, where they diverge for... reasons.
	[071] = 151,
	[072] = 155,
	[073] = 159,
	[074] = 163,
	[075] = 167,
	[076] = 171,
	[077] = 175,
	[078] = 179,
	[079] = 183,
	[080] = 187,
	[081] = 279,
	[082] = 293,
	[083] = 306,
	[084] = 320,
	[085] = 333,
	[086] = 384,
	[087] = 404,
	[088] = 424,
	[089] = 443,
	[090] = 463,
	[091] = 530,
	[092] = 540,
	[093] = 550,
	[094] = 560,
	[095] = 570,
	[096] = 580,
	[097] = 590,
	[098] = 598,
	[099] = 605,
	[656] = 675, -- Dungeon drops
};

--------------------------------------------------------------------------------------------------------
--                                          Metatable Methods                                         --
--------------------------------------------------------------------------------------------------------

-- basic access; allow for LibItemString access, otherwise fall back to property name array index access
LIS.__index = function(tbl,k)
	if (LIS[k]) then
		return LIS[k];
	elseif (type(k) == "string") then
		-- reference by name
		local propIndex = LIS.ITEMSTRING_PROPERTY_INDEX[k];
		if (propIndex) then
			if (propIndex < 0) then
				propIndex = LIS.ITEMSTRING_PROPERTY_INDEX.numBonusIDs + tbl.numBonusIDs + abs(propIndex);
			end
			return tbl[propIndex] or 0;
		end
		-- bonusIDs
		local bonusIdIndex = tonumber(k:match("bonusID(%d+)"));
		if (bonusIdIndex) then
			local propIndex = LIS.ITEMSTRING_PROPERTY_INDEX.numBonusIDs;
			local numBonusIDs = tbl.numBonusIDs;
			return (numBonusIDs > 0) and (bonusIdIndex <= numBonusIDs) and tbl[propIndex + bonusIdIndex] or nil;
		end
	end
end

-- converts it back to an itemString using tostring()
LIS.__tostring = function(tbl)
	local itemLink = tbl.linkType;
	for index, value in ipairs(tbl) do
		itemLink = itemLink .. ":" .. (value == 0 and "" or tostring(value));
	end
	return itemLink;
end

--------------------------------------------------------------------------------------------------------
--                                             Functions                                              --
--------------------------------------------------------------------------------------------------------

-- Creates new itemString table instance
-- * itemLink			Example: item:128955:::-55:::::99:577::11:2:69:96:3
-- * itemStringTable	If you want to recycle the same table, pass it along here, otherwise a new table is constructed
function LIS:New(itemLink,itemStringTable)
	if (type(itemLink) == "string") then
		itemStringTable = setmetatable(itemStringTable or {},LIS);

		local itemString = itemLink:match(LIS.ITEMSTRING_PATTERN);
		itemStringTable:Parse(itemString);

		return itemStringTable;
	end
end

-- Parses the itemString properties into array entries -- To merge back, use tostring(itemStringTable)
function LIS:Parse(itemString)
	wipe(self);
	self.source = itemString;

	if (type(itemString) ~= "string") then
		return;
	end

	local index = 0;
	for value in self.source:gmatch("([^:]*):?") do
		index = (index + 1);
		if (index == 1) then
			self.linkType = value;		-- will normally just be "item", but we keep it in case we want to expand this lib later
		else
			self[#self + 1] = tonumber(value) or 0;
		end
	end
	self[#self] = nil;	-- removes the last invalid capure we get from matching the optional ":"
end

-- Analyses the itemString and checks for upgrades that affects itemLevel -- Only itemLevel 450 and above will have this
-- As new upgrades are added all the time, this function is rather unreliable, and its therefore not recommended to use
-- WARNING: Use the LibItemString:GetTrueItemLevel() function instead, which scans the tooltip for a 100% correct itemLevel
function LIS:GetUpgradedItemLevel()
	local _, _, _, itemLevel = GetItemInfo(self.source);
	if not (itemLevel) then
		return nil;
	end

	-- obtain the itemString upgrade and bonusValue
	local timewarp = self.bonusID1;
	local warforged = self.bonusID2;
	local upgradeValue = self.upgradeValue;

	-- Return the actual itemLevel based on the itemString properties
	if (itemLevel >= 450) and (LIS.UPGRADED_LEVEL_ADJUST[upgradeValue]) then
		return itemLevel + LIS.UPGRADED_LEVEL_ADJUST[upgradeValue];
	else
		return LIS.TIMEWARPED_WARFORGED_LEVEL_ADJUST[warforged] or LIS.TIMEWARPED_LEVEL_ADJUST[timewarp] or itemLevel;
	end
end

-- Scans the tooltip for the proper itemLevel as we cannot get it consistently any other way
-- No ItemString instance, that is calling LibItemString:New(), of LibItemString is needed to call this function
function LIS:GetTooltipItemLevel(itemLink)
	LIS.ScanTip:ClearLines();
	LIS.ScanTip:SetHyperlink(itemLink);

	-- Line 1 is item name; Line 2 could simply be the itemLevel, or it could be the upgrade type such as "Mythic Warforged"
	for i = 2, min(LIS.ScanTip:NumLines(),LIS.TOOLTIP_MAXLINE_LEVEL) do
		local line = _G["LibItemStringScanTipTextLeft"..i]:GetText();
		local itemLevel = tonumber(line:match(LIS.ITEM_LEVEL_PATTERN));
		if (itemLevel) then
			return itemLevel;
		end
	end
end

-- Returns the true itemLevel for upgraded items, even when GetItemInfo() says otherwise
-- This method replaces the old GetUpgradedItemLevelFromItemLink() function
function LIS:GetTrueItemLevel(itemLink)
	return self:GetTooltipItemLevel(itemLink);
end

-- GLOBAL function staying compatible with the old "GetUpgradedItemLevel.lua" unit
-- OBSOLETE: Use LibItemString:GetTrueItemLevel(itemLink) instead
function GetUpgradedItemLevelFromItemLink(itemLink)
	return LIS:GetTrueItemLevel(itemLink);
end