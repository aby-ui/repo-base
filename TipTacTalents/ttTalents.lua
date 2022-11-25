local gtt = GameTooltip;

-- classic support
local isWoWClassic, isWoWBcc, isWoWWotlkc, isWoWSl, isWoWRetail = false, false, false, false, false;
if (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_CLASSIC"]) then
	isWoWClassic = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_BURNING_CRUSADE_CLASSIC"]) then
	isWoWBcc = true;
elseif (_G["WOW_PROJECT_ID"] == _G["WOW_PROJECT_WRATH_CLASSIC"]) then
	isWoWWotlkc = true;
else -- retail
	if (_G["LE_EXPANSION_LEVEL_CURRENT"] == _G["LE_EXPANSION_SHADOWLANDS"]) then
		isWoWSl = true;
	else
		isWoWRetail = true;
	end
end

-- Addon
local modName = ...;
local ttt = CreateFrame("Frame",modName,nil,BackdropTemplateMixin and "BackdropTemplate"); -- 9.0.1: Using BackdropTemplate
ttt:Hide();

-- String Constants
local TALENTS_PREFIX = (((isWoWSl or isWoWRetail) and SPECIALIZATION) or TALENTS)..":|cffffffff "; -- MoP: Could be changed from TALENTS to SPECIALIZATION
local TALENTS_NA = NOT_APPLICABLE:lower();
local TALENTS_NONE = NONE_KEY; -- NO.." "..TALENTS
local TALENTS_LOADING = SEARCH_LOADING_TEXT;
local AIL_PREFIX = "Average Item Level:|cffffffff ";
local AIL_NA = NOT_APPLICABLE:lower();
local AIL_LOADING = SEARCH_LOADING_TEXT;

-- Default Config
local cfg;
local TTT_DefaultConfig = {
	t_enable = true,               -- "Main Switch", addon does nothing if false
	t_showTalents = true,          -- Show talents
	t_showAverageItemLevel = true, -- Show average item level (AIL)
	t_talentOnlyInParty = false,   -- Only show talents/AIL for party/raid members
	t_talentFormat = 1,            -- Talent Format
	t_talentCacheSize = 25,        -- Change cache size here (Default 25)

	t_inspectDelay = 0.2,          -- The time delay for the scheduled inspection (default = 0.2)
	t_inspectFreq = 2,             -- How soon after an inspection are we allowed to inspect again? (default = 2)
}

-- Variables
local cache = {};
local record = {};

-- Allow these to be accessed externally from other addons
ttt.cache = cache;
ttt.record = record;

-- Time of the last inspect reuqest. Init this to zero, just to make sure.
-- This is a global variable, so other addons can use this as well.
lastInspectRequest = 0;

-- Helper function to determine if an "Inspect Frame" is open. Native Inspect as well as Examiner is supported.
local function IsInspectFrameOpen() return (InspectFrame and InspectFrame:IsShown()) or (Examiner and Examiner:IsShown()); end

--------------------------------------------------------------------------------------------------------
--                                          Helper Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Get displayed unit
function ttt:GetDisplayedUnit(tooltip)
	if (tooltip.GetUnit) then
		return tooltip:GetUnit();
	else
		return TooltipUtil.GetDisplayedUnit(tooltip);
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Main Functions                                           --
--------------------------------------------------------------------------------------------------------

-- Perform the tasks needed, after we have valid inspect data available
function ttt:InspectDataAvailable(record)
	self:QuerySpecialization(record);
	self:QueryAverageItemLevel(record);
	self:UpdateTooltip(record);
	self:CacheUnit(record);
end

-- Queries the talent spec of the inspected unit, or player unit (MoP Code)
function ttt:QuerySpecialization(record)
	if (record.level < 10 and record.level ~= -1) then -- No need to display talents for players who has not yet gotten a specialization
		return;
	end
	if (isWoWSl) or (isWoWRetail) then -- retail
		local spec = (not record.isSelf) and GetInspectSpecialization(record.unit) or GetSpecialization();
		if (not spec or spec == 0) then
			record.format = TALENTS_NONE;
		elseif (not record.isSelf) then
			local _, specName = GetSpecializationInfoByID(spec);
			--local _, specName = GetSpecializationInfoForClassID(spec,record.classID);
			record.format = specName ~= "" and specName or TALENTS_NA;
		else
			-- MoP Note: Is it no longer possible to query the different talent spec groups anymore?
--			local group = GetActiveSpecGroup(isInspect) or 1;	-- Az: replaced with GetActiveSpecGroup(), but that does not support inspect?
			local _, specName = GetSpecializationInfo(spec);
			record.format = specName ~= "" and specName or TALENTS_NA;
		end
	else -- classic
		-- Inspect functions will always use the active spec when not inspecting
		local isInspect = (not record.isSelf);
		if (isInspect) and (isWoWClassic) then
			return;
		end
		local activeTalentGroup = ((type(GetActiveTalentGroup) == "function") and GetActiveTalentGroup(isInspect));
		-- Get points per tree, and set "maxTree" to the tree with most points
		local numTalentTabs = GetNumTalentTabs(isInspect);
		if (not numTalentTabs) then
			record.format = TALENTS_NONE;
			return;
		end
		record.tree = {};
		local maxTree = 1;
		for tabIndex = 1, numTalentTabs do
			_, _, record.tree[tabIndex] = GetTalentTabInfo(tabIndex, isInspect, nil, activeTalentGroup);
			if (record.tree[tabIndex] > record.tree[maxTree]) then
				maxTree = tabIndex;
			end
		end
		record.maxTree = GetTalentTabInfo(maxTree, isInspect, nil, activeTalentGroup);
		-- Customise output. Use TipTac setting if it exists, otherwise just use formatting style one.
		local talentFormat = (cfg.t_talentFormat or 1);
		if (record[maxTree] == 0) then
			record.format = TALENTS_NONE;
		elseif (talentFormat == 1) then
			record.format = record.maxTree.." ("..table.concat(record.tree, "/")..")";
		elseif (talentFormat == 2) then
			record.format = record.maxTree;
		elseif (talentFormat == 3) then
			record.format = table.concat(record.tree, "/");
		end
	end
end

-- Queries the items of the inspected unit
function ttt:QueryAverageItemLevel(record)
	-- Get items
	local items = {};
	local count = 0;
	
	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
		local itemLink = GetInventoryItemLink(record.unit, i);
		items[i] = itemLink;
		
		if (itemLink) then
			count = count + 1;
		end
	end
	
	-- Calculate average item level
	local totalScore = 0;
	local totalItems = 0;
	local totalItemRarity = 0;
	local totalItemsForRarity = 0;
	
	if (count > 0) then
		for i, itemLink in pairs(items) do
			if (itemLink) then
				local effectiveILvl = GetDetailedItemLevelInfo(itemLink);
				local itemName, _itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemLink);
				
				 -- map Heirloom and WoWToken to Rare
				if (itemRarity == 7) or (itemRarity == 8) then
					itemRarity = 3;
				end
				
				if (effectiveILvl) and (not ((i == INVSLOT_BODY) or (i == INVSLOT_RANGED) or (i == INVSLOT_TABARD))) then
					totalItems = totalItems + 1;
					
					if (i == INVSLOT_MAINHAND) and (not items[INVSLOT_OFFHAND]) then
						if (itemEquipLoc == "INVTYPE_2HWEAPON") or (itemEquipLoc == "INVTYPE_RANGED") then
							totalScore = totalScore + effectiveILvl;
						end
					else
						totalScore = totalScore + effectiveILvl;
					end
					
					-- ignore tabard for total item rarity
					if (i ~= INVSLOT_TABARD) then
						totalItemsForRarity = totalItemsForRarity + 1;
						totalItemRarity = totalItemRarity + (itemRarity or 0);
					end
				end
			end
		end
	end
	
	-- Rescan if there aren't many items
	local isInspect = (not record.isSelf);
	
	if (isInspect) and (totalItems < 7) and (not record.rescan) then
		-- Make sure the mouseover unit is still our unit
		-- Check IsInspectFrameOpen() again: Since if the user right-clicks a unit frame, and clicks inspect,
		-- it could cause TTT to schedule an inspect, while the inspection window is open
		if (UnitGUID("mouseover") == record.guid) and (not IsInspectFrameOpen()) then
			record.rescan = true;
			
			lastInspectRequest = GetTime();
			self:RegisterEvent("INSPECT_READY");
			NotifyInspect(record.unit);
		end
		
		return;
	end
	
	if (totalItems > 0) then
		local totalItemQualityColor = CreateColorFromHexString(select(4, GetItemQualityColor(floor(totalItemRarity / totalItemsForRarity + 0.5))));
		record.ail = totalItemQualityColor:WrapTextInColorCode(floor(totalScore / totalItems));
	else
		record.ail = AIL_NA;
	end
end

-- Update tooltip with the record format, but only if tooltip is still showing the unit of our record
function ttt:UpdateTooltip(record)
	if (self.tipLineIndexTalents) then
		_G["GameTooltipTextLeft"..self.tipLineIndexTalents]:SetFormattedText("%s%s", TALENTS_PREFIX, record.format);
	elseif (cfg.t_showTalents) and (record.format) then
		gtt:AddLine(format("%s%s", TALENTS_PREFIX, record.format));
		self.tipLineIndexTalents = gtt:NumLines();
	end
	
	if (self.tipLineIndexAverageItemLevel) then
		_G["GameTooltipTextLeft"..self.tipLineIndexAverageItemLevel]:SetFormattedText("%s%s", AIL_PREFIX, record.ail);
	elseif (cfg.t_showAverageItemLevel) and (record.ail) then
		gtt:AddLine(format("%s%s", AIL_PREFIX, record.ail));
		self.tipLineIndexAverageItemLevel = gtt:NumLines();
	end

	-- If GTT is visible and not fading out, call Show() to force the tooltip to resize.
	-- We can only detect a fading out tooltip with TipTac, as that sets the .ttFadeOut field.
	-- This means, when TipTacTalents is used on its own, it may bug out the size of the tooltip here.
	if (gtt:IsVisible()) and (not gtt.ttFadeOut) then
		gtt:Show();
	end
end

-- caches the given unit record
function ttt:CacheUnit(record)
	local cacheSize = cfg.t_talentCacheSize;
	-- remove previous entries of this unit
	for i = #cache, 1, -1 do
		if (record.guid == cache[i].guid) then
			tremove(cache,i);
			break;
		end
	end
	-- remove oldest entry if we are at the cache size limit
	if (#cache > cacheSize) then
		tremove(cache,1);
	end
	-- Cache the new entry
	if (cacheSize > 0) then
		cache[#cache + 1] = CopyTable(record);
	end
end

-- Get value optionally without error speach
function ttt:GetValueOptionallyWithoutErrorSpeech(valueFn, suppressErrorSpeech)
	local cvarSound_EnableErrorSpeech_org;
	if (suppressErrorSpeech) then
		cvarSound_EnableErrorSpeech_org = GetCVar("Sound_EnableErrorSpeech");
		SetCVar("Sound_EnableErrorSpeech", 0);
	end
	local value = valueFn();
	if (suppressErrorSpeech) then
		UIErrorsFrame:Clear();
		SetCVar("Sound_EnableErrorSpeech", cvarSound_EnableErrorSpeech_org);
	end
	return value;
end

-- starts an inspection request
function ttt:InitiateInspectRequest(unit,record)
	-- Wipe Current Record
	wipe(record);
	record.unit = unit;
	record.name = UnitName(unit);
	record.level = UnitLevel(unit);
	record.guid = UnitGUID(unit);

	-- invalidate lineindexes
	self.tipLineIndexTalents = nil;
	self.tipLineIndexAverageItemLevel = nil;

	-- No need for inspection on the player
	if (UnitIsUnit(unit,"player")) then
		record.isSelf = true;
		self:InspectDataAvailable(record);
		return;
	end

	-- Search cached record for this guid, and get the format from cache
	for _, entry in ipairs(cache) do
		if (record.guid == entry.guid) then
			record.format = entry.format;
			record.ail = entry.ail;
			break;
		end
	end

	-- Queue a delayed inspect request
	local canInspect = ttt:GetValueOptionallyWithoutErrorSpeech(function()
		return (CanInspect(unit)) and (not IsInspectFrameOpen());
	end, (not isWoWSl) and (not isWoWRetail));
	
	if (canInspect) then
		local delay = cfg.t_inspectDelay;
		local freq = cfg.t_inspectFreq;

		local lastInspectTime = (GetTime() - lastInspectRequest);
		self.nextUpdate = (lastInspectTime > freq) and delay or (freq - lastInspectTime + delay);
		self:Show();

		if (not record.format) then
			if (not isWoWClassic) and (record.level >= 10 or record.level == -1) then -- Only need to display talents for players who has gotten a specialization
				record.format = TALENTS_LOADING;
			end
		end
		if (not record.ail) then
			record.ail = AIL_LOADING;
		end
	end

	-- if we have something to show already, cached format/ail or loading text, update the tip
	if (record.format) or (record.ail) then
		self:UpdateTooltip(record);
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Event Handling                                           --
--------------------------------------------------------------------------------------------------------

-- Apply hooks during VARIABLES_LOADED
function ttt:HookTip()
	-- Hooks needs to be applied as late as possible during load, as we want to try and be the
	-- last addon to hook "OnTooltipSetUnit" so we always have a "completed" tip to work on
	
	-- OnUpdate -- Sends the inspect request after a delay
	ttt:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = (self.nextUpdate - elapsed);
		if (self.nextUpdate <= 0) then
			self:Hide();
			-- Make sure the mouseover unit is still our unit
			-- Check IsInspectFrameOpen() again: Since if the user right-clicks a unit frame, and clicks inspect,
			-- it could cause TTT to schedule an inspect, while the inspection window is open
			if (UnitGUID("mouseover") == record.guid) and (not IsInspectFrameOpen()) then
				lastInspectRequest = GetTime();
				self:RegisterEvent("INSPECT_READY");
				NotifyInspect(record.unit);
			end
		end
	end);

	-- HOOK: OnTooltipSetUnit -- Will schedule a delayed inspect request
	local function OnTooltipSetUnit(self,...)
		if IsAddOnLoaded("TinyInspect") then return end
		if not (cfg.t_enable) then
			return;
		end

		-- Abort any delayed inspect in progress
		ttt:Hide();

		-- Get the unit -- Check the UnitFrame unit if this tip is from a concated unit, such as "targettarget".
		local _, unit = ttt:GetDisplayedUnit(self);
		if (not unit) then
			local mFocus = GetMouseFocus();
			if (mFocus) and (mFocus.unit) then
				unit = mFocus.unit;
			end
		end

		-- No Unit or not a Player
		if (not unit) or (not UnitIsPlayer(unit)) then
			return;
		end

		-- Show only talents for people in your party/raid
		if (cfg.t_talentOnlyInParty and not UnitInParty(unit) and not UnitInRaid(unit)) then
			return;
		end

		-- Inspect player
		ttt:InitiateInspectRequest(unit,record);
	end
	
	if (TooltipDataProcessor) then -- since df 10.0.2
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(self, ...)
			if (self == gtt) then
				OnTooltipSetUnit(self, ...);
			end
		end);
	else -- before df 10.0.2
		gtt:HookScript("OnTooltipSetUnit", OnTooltipSetUnit);
	end

	-- Clear this function as it's not needed anymore
	self.HookTips = nil;
end

-- Chain config tables
local function ChainConfigTables(config, defaults)
	local config_metatable_org = getmetatable(config);
	
	return setmetatable(config, {
		__index = function(tab, index)
			local value = defaults[index];
			
			if (value) then
				return value;
			end
			
			if (not config_metatable_org) then
				return nil;
			end
			
			local config_metatable_org__index = config_metatable_org.__index;
			
			if (not config_metatable_org__index) then
				return nil;
			end
			
			if (type(config_metatable_org__index) == "table") then
				return config_metatable_org__index[index];
			end
			
			return config_metatable_org__index(tab, index);
		end
	});
end

-- Variables Loaded [One-Time-Event]
function ttt:VARIABLES_LOADED(event)
	-- Use TipTac settings if installed
	if (TipTac_Config) then
		cfg = ChainConfigTables(TipTac_Config, TTT_DefaultConfig);
	else
		cfg = TTT_DefaultConfig;
	end
	
	-- Hook Tip
	self:HookTip();
	
	-- Cleanup
	self:UnregisterEvent(event);
	self[event] = nil;
end

-- Inspect Ready -- Inspect data ready
function ttt:INSPECT_READY(event, guid)
	-- Cleanup
	self:UnregisterEvent(event);
	
	if (guid == record.guid) then
		local _, unit = ttt:GetDisplayedUnit(gtt); -- Perform the tasks needed, but only if tooltip is still showing the unit of our record.
		if (unit) and (UnitGUID(unit) == record.guid) then
			ttt:InspectDataAvailable(record);
		end
	end
end

ttt:SetScript("OnEvent",function(self,event,...) self[event](self,event,...); end);

ttt:RegisterEvent("VARIABLES_LOADED");
