
-----------------------------------------------------------------------
-- LibFroznFunctions-1.0
--
-- Frozn's utility functions for WoW development
--
-- Example:
-- /run DevTools_Dump(LibStub:GetLibrary("LibFroznFunctions-1.0", true).isWoWFlavor)
--

-- create new library
local LIB_NAME = "LibFroznFunctions-1.0";
local LIB_MINOR = 1; -- bump on changes

if (not LibStub) then
	error(LIB_NAME .. " requires LibStub.");
end
-- local ldb = LibStub("LibDataBroker-1.1", true)
-- if not ldb then error(LIB_NAME .. " requires LibDataBroker-1.1.") end

local LibFroznFunctions = LibStub:NewLibrary(LIB_NAME, LIB_MINOR);

if (not LibFroznFunctions) then
	return;
end

----------------------------------------------------------------------------------------------------
--                                        Classic Support                                         --
----------------------------------------------------------------------------------------------------

-- WoW flavor
--
-- @return .ClassicEra = true/false for Classic Era
--         .BCC        = true/false for BCC
--         .WotLKC     = true/false for WotLKC
--         .SL         = true/false for SL
--         .DF         = true/false for DF
LibFroznFunctions.isWoWFlavor = {
	["ClassicEra"] = false,
	["BCC"] = false,
	["WotLKC"] = false,
	["SL"] = false,
	["DF"] = false
};

if (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_CLASSIC"]) then
	LibFroznFunctions.isWoWFlavor.ClassicEra = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_BURNING_CRUSADE_CLASSIC"]) then
	LibFroznFunctions.isWoWFlavor.BCC = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_WRATH_CLASSIC"]) then
	LibFroznFunctions.isWoWFlavor.WotLKC = true;
else -- retail
	if (_G["LE_EXPANSION_LEVEL_CURRENT"] == _G["LE_EXPANSION_SHADOWLANDS"]) then
		LibFroznFunctions.isWoWFlavor.SL = true;
	else
		LibFroznFunctions.isWoWFlavor.DF = true;
	end
end

-- create color from hex string
--
-- @param  hexColor  color represented by hexadecimal digits in format AARRGGBB, e.g. "FFFF7C0A" (orange color for druid)
-- @return ColorMixin
function LibFroznFunctions:CreateColorFromHexString(hexColor)
	if (CreateColorFromHexString) then
		return CreateColorFromHexString(hexColor);
	end
	
	if (#hexColor == 8) then
		local function ExtractColorValueFromHex(str, index)
			return tonumber(str:sub(index, index + 1), 16) / 255;
		end
		
		local a, r, g, b = ExtractColorValueFromHex(hexColor, 1), ExtractColorValueFromHex(hexColor, 3), ExtractColorValueFromHex(hexColor, 5), ExtractColorValueFromHex(hexColor, 7);
		
		return CreateColor(r, g, b, a);
	else
		error("CreateColorFromHexString input must be hexadecimal digits in this format: AARRGGBB.");
	end
end

----------------------------------------------------------------------------------------------------
--                                        Helper Functions                                        --
----------------------------------------------------------------------------------------------------

-- format text
--
-- @param  text            text to format, e.g. "Hello {unitName}! Health: %d"
-- @param  replacements[]  replacements or nil, e.g. { ["unitName"] = UnitName("player") }
-- @param  ...             values, e.g. UnitHealth("player")
-- @return formatted text
function LibFroznFunctions:FormatText(text, replacements, ...)
	if (replacements) then
		for key, replacement in pairs(replacements) do
			text = string.gsub(text, "{" .. key .. "}", replacement);
		end
	end
	
	return string.format(text, ...);
end

-- remove items from table
--
-- @param  tab       table to remove items from
-- @param  removeFn  function to determine which items should be removed. if function returns true for the current item, it will be removed.
-- @return number of removed items
function LibFroznFunctions:removeFromTable(tab, removeFn)
	local tabLength = #tab;
	local secondIndex = 0;
	
	for index = 1, tabLength do
		if (removeFn(tab[index])) then
			tab[index] = nil;
		else
			secondIndex = secondIndex + 1;
			
			if (index ~= secondIndex) then
				tab[secondIndex] = tab[index];
				tab[index] = nil;
			end
		end
	end
	
	return tabLength - secondIndex;
end

-- create push array
--
-- keeps track of the array count internally to avoid the constant
-- use of the length operator (#) recounting the array over and over.
--
-- @param  optionalTable[]  optional table
-- @return pushArray[]                       push array
--         pushArray:Clear()                 wipes push array
--         pushArray:Push(value)             push item in push array
--         pushArray:PushUnique(value)       push item in push array if it doesn't already exist
--         pushArray:PushUniqueOnTop(value)  push item in push array. if it already exists, it will be removed before so that the value is unique and on top.
--         pushArray:GetCount()              returns number of items in push array
--         pushArray:Contains(value)         returns true if push array contains the item, false otherwise.
--         pushArray:Pop()                   pop item out of push array
--         pushArray:Remove(value)           remove item from push array. returns number of removed items
--         pushArray:Concat(sep)             joins push array items, optional with given separator
-- @usage  local pushArray = LibFroznFunctions:CreatePushArray();
--         pushArray:Push("Hello");
--         pushArray:Push("World");
--         pushArray:Push("xxx");
--         if (pushArray:GetCount() > 2) then
--             pushArray:Pop(); -- remove last item
--         end
--         print(pushArray:Concat(" ")); -- output: "Hello World"
--         pushArray:Clear();
local pushArray = {
	__index = {
		Clear = function(tab)
			wipe(tab);
		end,
		Push = function(tab, value)
			tab.next = value;
		end,
		PushUnique = function(tab, value)
			if (tab:Contains(value)) then
				return;
			end
			tab.next = value;
		end,
		PushUniqueOnTop = function(tab, value)
			tab:Remove(value);
			tab.next = value;
		end,
		count = 0,
		GetCount = function(tab)
			return tab.count;
		end,
		Contains = function(tab, value)
			for _, _value in ipairs(tab) do
				if (_value == value) then
					return true;
				end
			end
			return false;
		end,
		Pop = function(tab)
			if (tab.count > 0) then
				local value = rawget(tab, tab.count);
				tab.last = nil;
				return value;
			end
		end,
		Remove = function(tab, value)
			local itemsRemoved = LibFroznFunctions:removeFromTable(tab, function(_value)
				return (_value == value);
			end);
			tab.count = tab.count - itemsRemoved;
			return itemsRemoved;
		end,
		Concat = function(tab, sep)
			return table.concat(tab, sep);
		end
	},
	__newindex = function(tab, key, value)
		if (key == "next") then
			if (value ~= nil) then
				tab.count = tab.count + 1;
				tab.last = value;
			end
		elseif (key == "last") then
			if (tab.count > 0) then
				rawset(tab, tab.count, value);
				
				if (value == nil) then
					tab.count = tab.count - 1;
				end
			end
		else
			rawset(tab, key, value);
		end
	end
};

function LibFroznFunctions:CreatePushArray(optionalTable)
	return setmetatable(optionalTable or {}, pushArray);
end

-- chain tables
--
-- @param  leadingTable[]    leading table
-- @param  alternateTable[]  alternate table
-- @return chained table[]
function LibFroznFunctions:ChainTables(leadingTable, alternateTable)
	local oldLeadingTableMetatable = getmetatable(leadingTable);
	
	return setmetatable(leadingTable, {
		__index = function(tab, index)
			-- check if value exists in alternate table
			local value = alternateTable[index];
			
			if (value) then
				return value;
			end
			
			-- check if value exists in old metatable of leading table
			if (not oldLeadingTableMetatable) or (not oldLeadingTableMetatable.__index) then
				return nil;
			end
			
			if (type(oldLeadingTableMetatable.__index) == "table") then
				return oldLeadingTableMetatable.__index[index];
			end
			
			return oldLeadingTableMetatable.__index(tab, index);
		end
	});
end

-- call function and suppress error message and speech
--
-- @param  func()  function to call
-- @return return values of function to call
function LibFroznFunctions:CallFunctionAndSuppressErrorMessageAndSpeech(func)
	local oldCVarSound_EnableErrorSpeech = GetCVar("Sound_EnableErrorSpeech");
	
	SetCVar("Sound_EnableErrorSpeech", 0);
	
	local values = { func() };
	
	UIErrorsFrame:Clear();
	SetCVar("Sound_EnableErrorSpeech", oldCVarSound_EnableErrorSpeech);
	
	return unpack(values);
end

----------------------------------------------------------------------------------------------------
--                                             Colors                                             --
----------------------------------------------------------------------------------------------------

-- get class color
--
-- @param  classFile                     locale-independent class file of unit, e.g. "MAGE" or "DRUID"
-- @param  alternateClassFileIfNotFound  alternate class file if color for param "classFile" doesn't exist
-- @return ColorMixin. returns nil if class file for param "classFile" and "alternateClassFileIfNotFound" doesn't exist.
local LFF_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;

function LibFroznFunctions:GetClassColor(classFile, alternateClassFileIfNotFound)
	return LFF_CLASS_COLORS[classFile] or LFF_CLASS_COLORS[alternateClassFileIfNotFound];
end

-- get item quality color
--
-- @param  quality                     item quality, e.g. 0 (poor), 3 (rare), 4 (epic), see "Enum.ItemQuality"
-- @param  alternateQualityIfNotFound  alternate quality if color for param "quality" doesn't exist
-- @return ColorMixin. returns nil if quality for param "quality" and "alternateQualityIfNotFound" doesn't exist.
function LibFroznFunctions:GetItemQualityColor(quality, alternateQualityIfNotFound)
	return ITEM_QUALITY_COLORS[quality] and ITEM_QUALITY_COLORS[quality].color or ITEM_QUALITY_COLORS[alternateQualityIfNotFound] and ITEM_QUALITY_COLORS[alternateQualityIfNotFound].color;
end

----------------------------------------------------------------------------------------------------
--                                             Icons                                              --
----------------------------------------------------------------------------------------------------

-- create markup for role icon
--
-- @param  role  "DAMAGER", "TANK" or "HEALER"
-- @return markup for role icon to use in text. returns nil for invalid roles.
function LibFroznFunctions:CreateMarkupForRoleIcon(role)
	if (role == "TANK") then
		return CreateAtlasMarkup("roleicon-tiny-tank");
	elseif (role == "DAMAGER") then
		return CreateAtlasMarkup("roleicon-tiny-dps");
	elseif (role == "HEALER") then
		return CreateAtlasMarkup("roleicon-tiny-healer");
	else
		return nil;
	end
end

-- create markup for class icon
--
-- @param  classIcon  file id/path for class icon
-- @return markup for class icon to use in text
function LibFroznFunctions:CreateMarkupForClassIcon(classIcon)
	return CreateTextureMarkup(classIcon, 64, 64, nil, nil, 0.07, 0.93, 0.07, 0.93);
end

----------------------------------------------------------------------------------------------------
--                                            Tooltip                                             --
----------------------------------------------------------------------------------------------------

-- get unit from tooltip
function LibFroznFunctions:GetUnitFromTooltip(tooltip)
	if (tooltip.GetUnit) then
		return tooltip:GetUnit();
	else
		return TooltipUtil.GetDisplayedUnit(tooltip);
	end
end

-- hook GameTooltip's OnTooltipSetUnit
function LibFroznFunctions:GameTooltipHookScriptOnTooltipSetUnit(callback)
	if (TooltipDataProcessor) then -- since df 10.0.2
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(self, ...)
			if (self == GameTooltip) then
				callback(self, ...);
			end
		end);
	else -- before df 10.0.2
		GameTooltip:HookScript("OnTooltipSetUnit", callback);
	end
end

----------------------------------------------------------------------------------------------------
--                                             Units                                              --
----------------------------------------------------------------------------------------------------

-- get unit id from unit guid
--
-- @param  unit guid  unit guid
-- @return unit id, unit name. nil, unit name otherwise.
function LibFroznFunctions:GetUnitIDFromGUID(unitGUID)
	-- no unit guid
	if (not unitGUID) then
		return nil, nil;
	end
	
    local unitName = select(6, GetPlayerInfoByGUID(unitGUID));
	
	-- no unit name
	if (not unitName) then
		return nil, nil;
	end
	
	-- use blizzard function, since df 10.0.2
	if (UnitTokenFromGUID) then
		local unitID = UnitTokenFromGUID(unitGUID);
		
		if (unitID) then
			return unitID, unitName;
		end
		
		return nil, unitName;
	end
	
	-- check unit name if unit is in the current zone
    if (UnitExists(unitName)) then
        return unitName, unitName;
	end
	
	-- check fixed unit ids
	local checkUnitIDs = {
		"player", "mouseover", "target", "focus", "npc", "softenemy", "softfriend", "softinteract", "pet", "vehicle"
	};
	
	for _, checkUnitID in ipairs(checkUnitIDs) do
		if (UnitGUID(checkUnitID) == unitGUID) then
			return checkUnitID, unitName;
		end
	end
	
	-- check party/raid unit ids
	local numMembers = GetNumGroupMembers();
	local isInRaid = IsInRaid();
	local checkUnitID;
	
	if (numMembers > 0) then
		for i = 1, numMembers do
			checkUnitID = (inRaid and "raid" .. i or "party" .. i);
			
			if (UnitGUID(checkUnitID) == unitGUID) then
				return checkUnitID, unitName;
			end
		end
	end
	
	-- check nameplate unit ids
	local nameplates = C_NamePlate.GetNamePlates();
	local numNameplates = #nameplates;
	
	if (numNameplates > 0) then
		for i = 1, numNameplates do
			checkUnitID = (nameplates[i].namePlateUnitToken or "nameplate" .. i);
			
			if (UnitGUID(checkUnitID) == unitGUID) then
				return checkUnitID, unitName;
			end
		end
	end
	
    -- no unit id found
    return nil, unitName;
end

----------------------------------------------------------------------------------------------------
--                                           Inspecting                                           --
----------------------------------------------------------------------------------------------------

-- config
local LFF_INSPECT_TIMEOUT = 2; -- safety cap on how often the api will allow us to call NotifyInspect without issues
local LFF_INSPECT_FAIL_TIMEOUT = 1; -- time to wait for event INSPECT_READY with inspect data
local LFF_CACHE_TIMEOUT = 5; -- seconds to keep stale information before issuing a new inspect

-- create frame for delayed inspection
local frameForDelayedInspection = CreateFrame("Frame", MOD_NAME);
frameForDelayedInspection:Hide();

frameForDelayedInspection:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...);
end);

frameForDelayedInspection:RegisterEvent("INSPECT_READY");

-- inspect unit
--
-- @param  unitID                                    unit id, e.g. "player", "target" or "mouseover"
-- @param  callbackForInspectData()                  callback function if inspect data is available
-- @param  removeCallbackFromQueuedInspectCallbacks  optional. true if callback function should be removed from all queued inspect callbacks.
-- @param  bypassUnitCacheTimeout                    true to bypass unit cache timeout
-- @return unitCacheRecord
--           .guid                guid of unit
--           .timestamp           timestamp of last update of record, nil otherwise.
--           .isSelf              true if it's the player unit. false for other units.
--           .name                name of unit
--           .nameWithServerName  name with server name of unit
--           .className           localized class name of unit, e.g. "Warrior" or "Guerrier"
--           .classFile           locale-independent class file of unit, e.g. "WARRIOR"
--           .classID             class id of unit
--           .level               level of unit
--           .needsInspect        true if a delayed inspect is needed, false if inspecting the player or the unit cache hasn't been timed out yet.
--           .canInspect          true if inspecting is possible, false otherwise. nil initially.
--           .inspectStatus       inspect status, see LFF_INSPECT_STATUS_*. nil otherwise.
--           .inspectTimestamp    inspect timestamp, nil otherwise.
--           .callbacks[]         push array with callbacks for inspect data if available
--           .talents             see LibFroznFunctions:GetTalents()
--           .averageItemLevel    see LibFroznFunctions:GetAverageItemLevel()
--         returns nil if no unit id is supplied or unit isn't a player.
local unitCache = {};

LFF_INSPECT_STATUS_QUEUED_FOR_NEXT_INSPECT = 1; -- queued for next inspection
LFF_INSPECT_STATUS_WAITING_FOR_INSPECT_DATA = 2; -- waiting for instect data

function LibFroznFunctions:InspectUnit(unitID, callbackForInspectData, removeCallbackFromQueuedInspectCallbacks, bypassUnitCacheTimeout)
	-- remove callback function from all queued inspect callbacks if requested
	if (removeCallbackFromQueuedInspectCallbacks) then
		LibFroznFunctions:RemoveCallbackFromQueuedInspectCallbacks(callbackForInspectData);
	end
	
	-- no unit id or not a player
	local isValidUnitID = (unitID) and (UnitIsPlayer(unitID));
	
	if (not isValidUnitID) then
		return nil;
	end
	
	-- get record in unit cache
	local unitGUID = UnitGUID(unitID);
	local unitCacheRecord = frameForDelayedInspection:GetUnitCacheRecord(unitID, unitGUID);
	
	if (not unitCacheRecord) then
		return nil;
	end
	
	-- no need for a delayed inspect request on the player unit
	if (unitCacheRecord.isSelf) then
		frameForDelayedInspection:InspectDataAvailable(unitID, unitCacheRecord);
	
	-- reinspect only if enough time has been elapsed
	elseif (not bypassUnitCacheTimeout) and (GetTime() - unitCacheRecord.timestamp <= LFF_CACHE_TIMEOUT) then
		frameForDelayedInspection:FinishInspect(unitCacheRecord, true);
	
	-- schedule a delayed inspect request
	else
		frameForDelayedInspection:InitiateInspectRequest(unitID, unitCacheRecord, callbackForInspectData);
	end
	
	return unitCacheRecord;
end

-- remove callback function from all queued inspect callbacks if requested
--
-- @param  callbackForInspectData()  callback function if inspect data is available which should be removed from all queued inspect callbacks
function LibFroznFunctions:RemoveCallbackFromQueuedInspectCallbacks(callbackForInspectData)
	for _, unitCacheRecord in ipairs(unitCache) do
		unitCacheRecord.callbacks:Remove(callbackForInspectData);
	end
end

-- get record in unit cache
function frameForDelayedInspection:GetUnitCacheRecord(unitID, unitGUID)
	-- no unit guid
	if (not unitGUID) then
		return nil;
	end
	
	-- get record in unit cache
	local unitCacheRecord;
	local isValidUnitID = (unitID) and (UnitIsPlayer(unitID));
	
	if (not unitCache[unitGUID]) then
		-- create record in unit cache if a valid unit id is available
		if (isValidUnitID) then
			unitCacheRecord = frameForDelayedInspection:CreateUnitCacheRecord(unitID, unitGUID);
		end
	else
		unitCacheRecord = unitCache[unitGUID];
	end
	
	-- update record in unit cache if a valid unit id is available
	if (unitCacheRecord) and (isValidUnitID) then
		unitCacheRecord.level = UnitLevel(unitID);
	end
	
	return unitCacheRecord;
end

-- create record in unit cache
function frameForDelayedInspection:CreateUnitCacheRecord(unitID, unitGUID)
	unitCache[unitGUID] = {};
	unitCacheRecord = unitCache[unitGUID];
	
	unitCacheRecord.guid = unitGUID;
	unitCacheRecord.timestamp = 0;
	unitCacheRecord.isSelf = UnitIsUnit(unitID, "player");
	unitCacheRecord.name = GetUnitName(unitID);
	unitCacheRecord.nameWithServerName = GetUnitName(unitID, true);
	
	local className, classFile, classID = UnitClass(unitID);
	
	unitCacheRecord.className = className;
	unitCacheRecord.classFile = classFile;
	unitCacheRecord.classID = classID;
	
	unitCacheRecord.needsInspect = false;
	unitCacheRecord.canInspect = nil;
	unitCacheRecord.inspectStatus = nil;
	unitCacheRecord.inspectTimestamp = 0;
	unitCacheRecord.callbacks = LibFroznFunctions:CreatePushArray();
	
	unitCacheRecord.talents = LibFroznFunctions:AreTalentsAvailable(unitID);
	unitCacheRecord.averageItemLevel = LibFroznFunctions:IsAverageItemLevelAvailable(unitID);
	
	return unitCacheRecord;
end

-- determine if an "Inspect Frame" is open. native inspect as well as addon Examiner are supported.
--
-- @return true if inspect frame is open, false otherwise.
function LibFroznFunctions:IsInspectFrameOpen()
	return (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown());
end

-- check if inspection is possible
--
-- @param  unit id  unit id, e.g. "player", "target" or "mouseover"
-- @return true if inspection is possible, false otherwise.
function LibFroznFunctions:CanInspect(unitID)
	local function checkFn()
		return (not LibFroznFunctions:IsInspectFrameOpen()) and (CanInspect(unitID));
	end
	
	-- suppress error message and speech in Classic Era, BCC and WotLKC
	if (LibFroznFunctions.isWoWFlavor.ClassicEra) or (LibFroznFunctions.isWoWFlavor.BCC) or (LibFroznFunctions.isWoWFlavor.WotLKC) then
		return LibFroznFunctions:CallFunctionAndSuppressErrorMessageAndSpeech(checkFn);
	end
	
	return checkFn();
end

-- initiate inspect request
local unitCacheQueuedForNextInspect = LibFroznFunctions:CreatePushArray();

function frameForDelayedInspection:InitiateInspectRequest(unitID, unitCacheRecord, callbackForInspectData)
	-- check if inspect isn't possible
	unitCacheRecord.canInspect = LibFroznFunctions:CanInspect(unitID);
	
	if (not unitCacheRecord.canInspect) then
		frameForDelayedInspection:FinishInspect(unitCacheRecord, true);
		
		return;
	end
	
	-- don't inspect if we're already waiting for inspect data and it hasn't been timed out yet
	if (unitCacheRecord.inspectStatus == LFF_INSPECT_STATUS_WAITING_FOR_INSPECT_DATA) and (GetTime() - unitCacheRecord.inspectTimestamp <= LFF_INSPECT_FAIL_TIMEOUT) then
		return;
	end
	
	-- add callback for inspect data
	unitCacheRecord.needsInspect = true;
	unitCacheRecord.callbacks:PushUnique(callbackForInspectData);
	
	-- schedule a delayed inspect request
	unitCacheRecord.inspectStatus = LFF_INSPECT_STATUS_QUEUED_FOR_NEXT_INSPECT;
	unitCacheRecord.inspectTimestamp = 0;
	
	frameForDelayedInspection:AddQueuedInspectRequest(unitCacheRecord);
end

-- schedule a delayed inspect request
function frameForDelayedInspection:AddQueuedInspectRequest(unitCacheRecord)
	unitCacheQueuedForNextInspect:PushUniqueOnTop(unitCacheRecord);
	
	frameForDelayedInspection:Show();
end

-- remove queued inspect request
function frameForDelayedInspection:RemoveQueuedInspectRequest(unitCacheRecord)
	local itemsRemoved = unitCacheQueuedForNextInspect:Remove(unitCacheRecord);
	
	if (itemsRemoved > 0) then
		-- check if there are no more queued inspect requests available
		if (unitCacheQueuedForNextInspect:GetCount() == 0) then
			frameForDelayedInspection:Hide();
		end
	end
end

-- HOOK: frameForDelayedInspection's OnUpdate -- sends the inspect request after a delay
frameForDelayedInspection.NextNotifyInspectTimestamp = GetTime();

frameForDelayedInspection:SetScript("OnUpdate", function(self, elapsed)
	if (self.NextNotifyInspectTimestamp <= GetTime()) then
		-- send next queued inspect request
		local unitCacheRecord, unitID, unitIDForNotifyInspectFound;
		
		repeat
			unitCacheRecord = unitCacheQueuedForNextInspect:Pop();
			
			-- check if there are no more queued inspect requests available
			if (not unitCacheRecord) then
				self:Hide();
				return;
			end
			
			-- get unit id from unit guid and check if inspect is possible
			unitID = LibFroznFunctions:GetUnitIDFromGUID(unitCacheRecord.guid);
			unitIDForNotifyInspectFound = true;
			
			if (not unitID) then
				frameForDelayedInspection:FinishInspect(unitCacheRecord, true);
				unitIDForNotifyInspectFound = false;
			else
				unitCacheRecord.canInspect = LibFroznFunctions:CanInspect(unitID);
				
				if (not unitCacheRecord.canInspect) then
					frameForDelayedInspection:FinishInspect(unitCacheRecord, true);
					unitIDForNotifyInspectFound = false;
				end
			end
		until (unitIDForNotifyInspectFound);
		
		NotifyInspect(unitID);
		
		-- check if there are no more queued inspect requests available
		if (unitCacheQueuedForNextInspect:GetCount() == 0) then
			self:Hide();
		end
	end
end);

-- HOOK: NotifyInspect to monitor inspect requests
hooksecurefunc("NotifyInspect", function(unitID)
	-- set queued inspect request to inspect requests waiting for inspect data
	local unitGUID = UnitGUID(unitID);
	local unitCacheRecord = frameForDelayedInspection:GetUnitCacheRecord(unitID, unitGUID);
	
	if (unitCacheRecord) then
		unitCacheRecord.inspectStatus = LFF_INSPECT_STATUS_WAITING_FOR_INSPECT_DATA;
		unitCacheRecord.inspectTimestamp = GetTime();
		
		frameForDelayedInspection:RemoveQueuedInspectRequest(unitCacheRecord);
	end
	
	-- set timestamp for next inspect request
	frameForDelayedInspection.NextNotifyInspectTimestamp = GetTime() + LFF_INSPECT_TIMEOUT;
end);

-- EVENT: INSPECT_READY - inspect data available
function frameForDelayedInspection:INSPECT_READY(event, unitGUID)
	-- no unit guid
	if (not unitGUID) then
		return nil;
	end
	
	local unitID = LibFroznFunctions:GetUnitIDFromGUID(unitGUID);
	local unitCacheRecord = frameForDelayedInspection:GetUnitCacheRecord(unitID, unitGUID);
	
	if (unitCacheRecord) then
		self:InspectDataAvailable(unitID, unitCacheRecord);
	end
end

-- inspect data available
function frameForDelayedInspection:InspectDataAvailable(unitID, unitCacheRecord)
	if (not unitID) then
		frameForDelayedInspection:FinishInspect(unitCacheRecord, true);
		return;
	end
	
	unitCacheRecord.talents = LibFroznFunctions:GetTalents(unitID);
	unitCacheRecord.averageItemLevel = LibFroznFunctions:GetAverageItemLevel(unitID, function(averageItemLevel)
		unitCacheRecord.averageItemLevel = averageItemLevel;
		
		frameForDelayedInspection:FinishInspectDataAvailable(unitCacheRecord);
	end);
	
	frameForDelayedInspection:FinishInspectDataAvailable(unitCacheRecord);
end

-- finish inspect data available
function frameForDelayedInspection:FinishInspectDataAvailable(unitCacheRecord)
	-- check which data is set
	local numDataIsSet = 0;
	
	if (unitCacheRecord.talents ~= LFF_TALENTS_AVAILABLE) and (unitCacheRecord.talents ~= LFF_TALENTS_NA) then
		numDataIsSet = numDataIsSet + 1;
	end
	if (unitCacheRecord.averageItemLevel ~= LFF_AVERAGE_ITEM_LEVEL_AVAILABLE) and (unitCacheRecord.averageItemLevel ~= LFF_AVERAGE_ITEM_LEVEL_NA) then
		numDataIsSet = numDataIsSet + 1;
	end
	
	-- finish inspect data available
	if (numDataIsSet == 0) then
		frameForDelayedInspection:FinishInspect(unitCacheRecord, true, true);
	elseif (numDataIsSet < 2) then
		frameForDelayedInspection:FinishInspect(unitCacheRecord, false, true);
	else
		unitCacheRecord.timestamp = GetTime();
		
		frameForDelayedInspection:FinishInspect(unitCacheRecord);
	end
end

-- finish inspect
function frameForDelayedInspection:FinishInspect(unitCacheRecord, noInspectDataAvailable, noClearCallbacksForInspectData)
	-- send unit cache record to callbacks if inspect data is available
	if (not noInspectDataAvailable) then
		for _, callback in ipairs(unitCacheRecord.callbacks) do
			callback(unitCacheRecord);
		end
	end
	
	if (not noClearCallbacksForInspectData) then
		unitCacheRecord.callbacks:Clear();
	end
	
	-- finish inspect request
	unitCacheRecord.needsInspect = false;
	unitCacheRecord.inspectStatus = nil;
	unitCacheRecord.inspectTimestamp = 0;
	
	frameForDelayedInspection:RemoveQueuedInspectRequest(unitCacheRecord);
end

-- check if talents are available
--
-- @param  unitID  unit id for unit, e.g. "player", "target" or "mouseover"
-- @return returns LFF_TALENTS_AVAILABLE if talents are available.
--         returns LFF_TALENTS_NA if no talents are available.
--         returns nil if unit id is missing or not a player
LFF_TALENTS_AVAILABLE = 1; -- talents available
LFF_TALENTS_NA = 2; -- no talents available
LFF_TALENTS_NONE = 3; -- no talents found

function LibFroznFunctions:AreTalentsAvailable(unitID)
	-- no unit id or not a player
	local isValidUnitID = (unitID) and (UnitIsPlayer(unitID));
	
	if (not isValidUnitID) then
		return nil;
	end
	
	 -- no need to display talent/specialization for players who hasn't yet gotten talent tabs or a specialization
	local unitLevel = UnitLevel(unitID);
	
	if (unitLevel < 10 and unitLevel ~= -1) then
		return LFF_TALENTS_NA;
	end
	
	-- getting talents from other players isn't available in classic era
	if (not isSelf) and (LibFroznFunctions.isWoWFlavor.ClassicEra) then
		return LFF_TALENTS_NA;
	end
	
	return LFF_TALENTS_AVAILABLE;
end

-- get talents
--
-- @param  unitID  unit id for unit, e.g. "player", "target" or "mouseover"
-- @return .name           talent/specialization name, e.g. "Elemental"
--         .iconFileID     talent/specialization icon file id, e.g. 135770
--         .role           role ("DAMAGER", "TANK" or "HEALER"
--         .pointsSpent[]  talent points spent, e.g. { 57, 14, 0 }. nil if no talent points spent has been found.
--         returns LFF_TALENTS_NONE if no talents have been found.
--         returns LFF_TALENTS_NA if no talents are available.
--         returns nil if unit id is missing or not a player
function LibFroznFunctions:GetTalents(unitID)
	-- check if talents are available
	local areTalentsAvailable = LibFroznFunctions:AreTalentsAvailable(unitID);
	
	if (areTalentsAvailable ~= LFF_TALENTS_AVAILABLE) then
		return areTalentsAvailable;
	end
	
	-- get talents
	local talents = {};
	local isSelf = UnitIsUnit(unitID, "player");
	
	if (GetSpecialization) then -- retail
		local specializationName, specializationIcon, role;
		
		if (isSelf) then -- player
			local specIndex = GetSpecialization();
			
			if (not specIndex) then
				return LFF_TALENTS_NONE;
			end
			
			_, specializationName, _, specializationIcon, role = GetSpecializationInfo(specIndex);
		else -- inspecting
			local specializationID = GetInspectSpecialization(unitID);
			
			if (specializationID == 0) then
				return LFF_TALENTS_NONE;
			end
			
			_, specializationName, _, specializationIcon, role = GetSpecializationInfoByID(specializationID);
		end
		
		if (specializationName ~= "") then
			talents.name = specializationName;
		end
		
		talents.role = role;
		talents.iconFileID = specializationIcon;
		
		local pointsSpent = {};
		
		if (isSelf) and (C_SpecializationInfo.CanPlayerUseTalentSpecUI()) or (not isSelf) and (C_Traits.HasValidInspectData()) then
			local configID = (isSelf) and (C_ClassTalents.GetActiveConfigID()) or (not isSelf) and (Constants.TraitConsts.INSPECT_TRAIT_CONFIG_ID);
			local configInfo = C_Traits.GetConfigInfo(configID);
			
			if (configInfo) and (configInfo.treeIDs) then
				local treeID = configInfo.treeIDs[1];
				if (treeID) then
					local treeCurrencyInfo = C_Traits.GetTreeCurrencyInfo(configID, treeID, false);
					
					if (treeCurrencyInfo) then
						for _, treeCurrencyInfoItem in ipairs(treeCurrencyInfo) do
							if (treeCurrencyInfoItem.spent) then
								pointsSpent[#pointsSpent + 1] = treeCurrencyInfoItem.spent;
							end
						end
					end
				end
			end
		end
		
		if (#pointsSpent > 0) then
			talents.pointsSpent = pointsSpent;
		end
	else -- classic
		-- inspect functions will always use the active spec when not inspecting
		local activeTalentGroup = GetActiveTalentGroup and GetActiveTalentGroup(not isSelf);
		local numTalentTabs = GetNumTalentTabs(not isSelf);
		
		if (not numTalentTabs) then
			return LFF_TALENTS_NONE;
		end
		
		local talentTabName, talentTabIcon;
		local pointsSpent = {};
		local maxPointsSpent;
		
		for tabIndex = 1, numTalentTabs do
			_talentTabName, _talentTabIcon, _pointsSpent = GetTalentTabInfo(tabIndex, not isSelf, nil, activeTalentGroup);
			pointsSpent[#pointsSpent + 1] = _pointsSpent;
			
			if (not maxPointsSpent) or (_pointsSpent > maxPointsSpent) then
				maxPointsSpent = _pointsSpent;
				talentTabName, talentTabIcon = _talentTabName, _talentTabIcon;
			end
		end
		
		if (talentTabName ~= "") then
			talents.name = talentTabName;
		end
		
		talents.iconFileID = talentTabIcon;
		
		if (#pointsSpent > 0) then
			talents.pointsSpent = pointsSpent;
		end
	end
	
	return talents;
end

-- check if average item level is available
--
-- @param  unitID  unit id for unit, e.g. "player", "target" or "mouseover"
-- @return returns LFF_AVERAGE_ITEM_LEVEL_AVAILABLE if average item level is available.
--         returns LFF_AVERAGE_ITEM_LEVEL_NA if no average item level is available.
--         returns nil if unit id is missing or not a player
LFF_AVERAGE_ITEM_LEVEL_AVAILABLE = 1; -- average item level available
LFF_AVERAGE_ITEM_LEVEL_NA = 2; -- no average item level available
LFF_AVERAGE_ITEM_LEVEL_NONE = 3; -- no average item level found

function LibFroznFunctions:IsAverageItemLevelAvailable(unitID)
	-- no unit id or not a player
	local isValidUnitID = (unitID) and (UnitIsPlayer(unitID));
	
	if (not isValidUnitID) then
		return nil;
	end
	
	 -- consider minimum player level to display average item level, see MIN_PLAYER_LEVEL_FOR_ITEM_LEVEL_DISPLAY in "PaperDollFrame.lua"
	local unitLevel = UnitLevel(unitID);
	
	if (unitLevel < 10 and unitLevel ~= -1) then
		return LFF_AVERAGE_ITEM_LEVEL_NA;
	end
	
	return LFF_AVERAGE_ITEM_LEVEL_AVAILABLE;
end

-- get average item level
--
-- @param  unitID                    unit id for unit, e.g. "player", "target" or "mouseover"
-- @param  callbackForInspectData()  callback function if all item data is available
-- @return .value         average item level
--         .qualityColor  ColorMixin with total quality color
--         .totalItems    total items
--         returns LFF_AVERAGE_ITEM_LEVEL_AVAILABLE if average item level is available
--         returns LFF_AVERAGE_ITEM_LEVEL_NONE if no average item level has been found.
--         returns nil if unit id is missing or not a player
function LibFroznFunctions:GetAverageItemLevel(unitID, callbackForItemData)
	-- check if average item level is available
	local isAverageItemLevelAvailable = LibFroznFunctions:IsAverageItemLevelAvailable(unitID);
	
	if (isAverageItemLevelAvailable ~= LFF_AVERAGE_ITEM_LEVEL_AVAILABLE) then
		return isAverageItemLevelAvailable;
	end
	
	-- check if item data for all items is available and queried from server
	local itemCountWaitingForData = 0;
	local unitGUID = UnitGUID(unitID);
	
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local itemID = GetInventoryItemID(unitID, i);
		
		if (itemID) then
			local item = Item:CreateFromItemID(itemID);
			
			if (not item:IsItemDataCached()) then
				itemCountWaitingForData = itemCountWaitingForData + 1;
				
				item:ContinueOnItemLoad(function()
					itemCountWaitingForData = itemCountWaitingForData - 1;
					
					if (itemCountWaitingForData == 0) then
						LFF_GetAverageItemLevelFromItemData(unitID, callbackForItemData, unitGUID);
					end
				end);
			end
		end
	end
	
	if (itemCountWaitingForData > 0) then
		return LFF_AVERAGE_ITEM_LEVEL_AVAILABLE;
	end
	
	-- item data for all items is already available
	return LFF_GetAverageItemLevelFromItemData(unitID);
end

-- get average item level from item data
function LFF_GetAverageItemLevelFromItemData(unitID, callbackForItemData, unitGUID)
	-- check if unit guid from unit id is still the same if waiting for item data
	if (callbackForItemData) and (unitGUID) then
		local _unitGUID = UnitGUID(unitID);
		
		if (_unitGUID ~= unitGUID) then
			return nil;
		end
	end
	
	-- get items
	local items = {};
	local itemCount = 0;
	
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local itemLink = GetInventoryItemLink(unitID, i);
		
		if (itemLink) then
			local item = Item:CreateFromItemLink(itemLink);
			
			local effectiveILvl = item:GetCurrentItemLevel();
			local quality = item:GetItemQuality();
			local inventoryType = item:GetInventoryType();
			
			items[i] = {
				["effectiveILvl"] = effectiveILvl or 0,
				["quality"] = quality or 0,
				["inventoryType"] = inventoryType
			};
			
			itemCount = itemCount + 1;
		end
	end
	
	if (itemCount == 0) then
		if (callbackForItemData) then
			callbackForItemData(LFF_AVERAGE_ITEM_LEVEL_NONE);
		end
		
		return LFF_AVERAGE_ITEM_LEVEL_NONE;
	end
	
	-- calculate average item level
	local totalScore = 0;
	local totalItems = 0;
	local totalQuality = 0;
	local totalItemsForQuality = 0;
	local averageItemLevel;
	local totalQualityColor;
	
	local ignoreInventorySlots = {
		[INVSLOT_BODY] = true, -- shirt
		[INVSLOT_TABARD] = true -- tabard
		-- [INVSLOT_RANGED] = true -- ranged
	};
	
	local twoHandedInventoryTypes = {
		[Enum.InventoryType.IndexRangedType] = true,
		[Enum.InventoryType.IndexRangedrightType] = true,
		[Enum.InventoryType.Index2HweaponType] = true
	};
	
	-- to check if main hand only
	local itemMainHand = items[INVSLOT_MAINHAND];
	local itemOffHand = items[INVSLOT_OFFHAND];
	
	local isMainHandOnly = (itemMainHand) and (not itemOffHand);
	
	-- to check if main or off hand are artifacts
	local isMainHandArtifact = (itemMainHand) and (itemMainHand.quality == Enum.ItemQuality.Artifact);
	local itemMainHandEffectiveILvl = (itemMainHand) and (itemMainHand.effectiveILvl);
	
	local isOffHandArtifact = (itemOffHand) and (itemOffHand.quality == Enum.ItemQuality.Artifact);
	local itemOffHandEffectiveILvl = (itemOffHand) and (itemOffHand.effectiveILvl);
	
	-- calculate average item level
	for i, item in pairs(items) do
		-- map Heirloom and WoWToken to Rare
		local quality = item.quality;
		
		if (quality == 7) or (quality == 8) then
			quality = 3;
		end
		
		if (not ignoreInventorySlots[i]) then -- ignore shirt, tabard and ranged
			totalItems = totalItems + 1;
			
			if (i == INVSLOT_MAINHAND) or (i == INVSLOT_OFFHAND) then -- handle main and off hand
				if (isMainHandOnly) then -- main hand only
					if (twoHandedInventoryTypes[item.inventoryType]) then -- two handed
						totalItems = totalItems + 1;
						totalScore = totalScore + item.effectiveILvl * 2;
					else -- one handed
						totalScore = totalScore + item.effectiveILvl;
					end
				else -- main and/or off hand
					if (isMainHandArtifact) or (isOffHandArtifact) then -- main or off hand is artifact
						if (itemMainHandEffectiveILvl > itemOffHandEffectiveILvl) then
							totalScore = totalScore + itemMainHandEffectiveILvl;
						else
							totalScore = totalScore + itemOffHandEffectiveILvl;
						end
					else -- main and off hand are non-artifacts
						totalScore = totalScore + item.effectiveILvl;
					end
				end
			else -- other items
				totalScore = totalScore + item.effectiveILvl;
			end
			
			totalItemsForQuality = totalItemsForQuality + 1;
			totalQuality = totalQuality + quality;
		end
	end
	
	if (totalItems == 0) then
		if (callbackForItemData) then
			callbackForItemData(LFF_AVERAGE_ITEM_LEVEL_NONE);
		end

		return LFF_AVERAGE_ITEM_LEVEL_NONE;
	end
	
	-- set average item level and total quality color
	local isSelf = UnitIsUnit(unitID, "player");
	
	if (isSelf) and (GetAverageItemLevel) then
		local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel();
		
		averageItemLevel = floor(avgItemLevelEquipped);
		
		local r, g, b = GetItemLevelColor();
		
		totalQualityColor = CreateColor(r, g, b, 1);
	elseif (C_PaperDollInfo) and (C_PaperDollInfo.GetInspectItemLevel) then
		averageItemLevel = C_PaperDollInfo.GetInspectItemLevel(unitID);
	end
	
	if (not averageItemLevel) or (averageItemLevel == 0) then
		averageItemLevel = floor(totalScore / 16);
	end
	
	if (not totalQualityColor) then
		totalQualityColor = LibFroznFunctions:GetItemQualityColor(floor(totalQuality / totalItemsForQuality + 0.5), Enum.ItemQuality.Common);
	end
	
	local averageItemLevel = {
		["value"] = averageItemLevel,
		["qualityColor"] = totalQualityColor,
		["totalItems"] = totalItemsForQuality
	};
	
	if (callbackForItemData) then
		callbackForItemData(averageItemLevel);
	end
	
	return averageItemLevel;
end
