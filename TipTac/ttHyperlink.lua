local AceHook = LibStub("AceHook-3.0");
local gtt = GameTooltip;
local bptt = BattlePetTooltip;

-- Addon
local modName = ...;
local ttHyperlink = CreateFrame("Frame", modName);

-- TipTac refs
local tt = TipTac;
local cfg;

-- element registration
tt:RegisterElement(ttHyperlink, "Hyperlink");

-- Hyperlinks which are supported
local supportedHyperLinks = {
	item = true,
	spell = true,
	unit = true,
	quest = true,
	enchant = true,
	achievement = true,
	instancelock = true,
	talent = true,
	glyph = true,
	battlepet = true,
	battlePetAbil = true,
	transmogappearance = true,
	transmogillusion = true,
	transmogset = true,
	conduit = true,
	currency = true,
	azessence = true,
	mawpower = true,
	dungeonScore = true,
	keystone = true,
};

local addOnsLoaded = {
	["TipTac"] = false,
	["Blizzard_Communities"] = false
};

local itemsCollectionFrame = nil;

--------------------------------------------------------------------------------------------------------
--                                       TipTac Hyperlink Frame                                       --
--------------------------------------------------------------------------------------------------------

ttHyperlink:SetScript("OnEvent",function(self,event,...) self[event](self,event,...); end);

ttHyperlink:RegisterEvent("VARIABLES_LOADED");
ttHyperlink:RegisterEvent("ADDON_LOADED");

-- Variables Loaded [One-Time-Event]
function ttHyperlink:VARIABLES_LOADED(event)
	-- Re-Trigger event ADDON_LOADED for TipTac if config wasn't ready
	self:ADDON_LOADED("ADDON_LOADED", "TipTac");
	
	-- Cleanup
	self:UnregisterEvent(event);
	self[event] = nil;
end

-- AddOn Loaded
function ttHyperlink:ADDON_LOADED(event, addOnName)
	if (not cfg) then return end;
	
	-- check if addon is already loaded
	if (addOnsLoaded[addOnName] == nil) or (addOnsLoaded[addOnName]) then
		return;
	end
	
	-- now CommunitiesGuildNewsFrame exists
	if (addOnName == "Blizzard_Communities") or ((addOnName == "TipTac") and (IsAddOnLoaded("Blizzard_Communities")) and (not addOnsLoaded['Blizzard_Communities'])) then
		self:OnApplyConfig(cfg);
		
		if (addOnName == "TipTac") then
			addOnsLoaded["Blizzard_Communities"] = true;
		end
	end
	
	addOnsLoaded[addOnName] = true;
	
	-- Cleanup if all addons are loaded
	local allAddOnsLoaded = true;
	
	for addOn, isLoaded in pairs(addOnsLoaded) do
		if (not isLoaded) then
			allAddOnsLoaded = false;
			break;
		end
	end
	
	if (allAddOnsLoaded) then
		self:UnregisterEvent(event);
		self[event] = nil;

		-- we no longer need to receive any events
		self:UnregisterAllEvents();
		self:SetScript("OnEvent", nil);
	end
end

--------------------------------------------------------------------------------------------------------
--                                              Scripts                                               --
--------------------------------------------------------------------------------------------------------

-- ChatFrame:OnHyperlinkEnter
local showingTooltip = false;

local function OnHyperlinkEnter(self, refString, text)
	local linkToken = refString:match("^([^:]+)");
	if (supportedHyperLinks[linkToken]) then
		GameTooltip_SetDefaultAnchor(gtt, self); --gtt:ClearAllPoints() gtt:SetOwner(self, "ANCHOR_CURSOR") --TODO:abyui10
		
		if (linkToken == "battlepet") then
			showingTooltip = bptt;
			BattlePetToolTip_ShowLink(text);
		elseif (linkToken == "battlePetAbil") then
			-- makes shure that PetJournalPrimaryAbilityTooltip and PetJournalSecondaryAbilityTooltip exist
			if (not IsAddOnLoaded("Blizzard_Collections")) then
				LoadAddOn("Blizzard_Collections");
			end
			
			-- show tooltip
			local link, abilityID, maxHealth, power, speed = (":"):split(refString);
			showingTooltip = PetJournalPrimaryAbilityTooltip;
			PetJournal_ShowAbilityTooltip(gtt, tonumber(abilityID));
			PetJournalPrimaryAbilityTooltip:ClearAllPoints();
			PetJournalPrimaryAbilityTooltip:SetPoint(gtt:GetPoint());
		elseif (linkToken == "transmogappearance") then -- WardrobeItemsCollectionMixin:RefreshAppearanceTooltip() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
			local linkType, sourceID = (":"):split(refString);
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID);
			local name, nameColor = CollectionWardrobeUtil.GetAppearanceNameTextAndColor(sourceInfo);
			GameTooltip_SetTitle(gtt, name, nameColor);
			showingTooltip = gtt;
			gtt:Show();
			if (TipTacItemRef) then
				TipTacItemRef:SetHyperlink_Hook(gtt, refString);
			end
		elseif (linkToken == "transmogillusion") then -- see WardrobeItemsModelMixin:OnEnter() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
			local linkType, illusionID = (":"):split(refString);
			local name, hyperlink, sourceText = C_TransmogCollection.GetIllusionStrings(illusionID);
			gtt:SetText(name);
			if (sourceText) then
				gtt:AddLine(sourceText, 1, 1, 1, 1);
			end
			showingTooltip = gtt;
			gtt:Show();
			if (TipTacItemRef) then
				TipTacItemRef:SetHyperlink_Hook(gtt, hyperlink);
			end
		elseif (linkToken == "transmogset") then -- WardrobeSetsTransmogModelMixin:RefreshTooltip() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
			-- makes shure that WardrobeCollectionFrame exists
			if (not IsAddOnLoaded("Blizzard_Collections")) then
				LoadAddOn("Blizzard_Collections");
			end
			
			-- show tooltip
			local linkType, setID = (":"):split(refString);
			
			local totalQuality = 0;
			local numTotalSlots = 0;
			local waitingOnQuality = false;
			local sourceQualityTable = {};
			local primaryAppearances = C_TransmogSets.GetSetPrimaryAppearances(setID);
			
			for i, primaryAppearance in pairs(primaryAppearances) do
				numTotalSlots = numTotalSlots + 1;
				local sourceID = primaryAppearance.appearanceID;
				if (sourceQualityTable[sourceID]) then
					totalQuality = totalQuality + sourceQualityTable[sourceID];
				else
					local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID);
					if (sourceInfo and sourceInfo.quality) then
						sourceQualityTable[sourceID] = sourceInfo.quality;
						totalQuality = totalQuality + sourceInfo.quality;
					else
						waitingOnQuality = true;
					end
				end
			end
			
			showingTooltip = gtt;
			if (waitingOnQuality) then
				gtt:SetText(RETRIEVING_ITEM_INFO, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
			else
				local setQuality = (numTotalSlots > 0 and totalQuality > 0) and Round(totalQuality / numTotalSlots) or Enum.ItemQuality.Common;
				local color = ITEM_QUALITY_COLORS[setQuality];
				local setInfo = C_TransmogSets.GetSetInfo(setID);
				gtt:SetText(setInfo.name, color.r, color.g, color.b);
				if (setInfo.label) then
					gtt:AddLine(setInfo.label);
					gtt:Show();
				end
			end
			if (TipTacItemRef) then
				TipTacItemRef:SetHyperlink_Hook(gtt, refString);
			end
		elseif (linkToken == "dungeonScore") then -- GetDungeonScoreLink() + DisplayDungeonScoreLink() in "ItemRef.lua"
			local splits = StringSplitIntoTable(":", refString);
			
			--Bad Link, Return.
			if (not splits) then
				return;
			end
			
			local dungeonScore = tonumber(splits[2]);
			local playerName = splits[4];
			local playerClass = splits[5];
			local playerItemLevel = tonumber(splits[6]);
			local playerLevel = tonumber(splits[7]);
			local className, classFileName = GetClassInfo(playerClass);
			local classColor = C_ClassColor.GetClassColor(classFileName);
			local runsThisSeason = tonumber(splits[8]);
			
			--Bad Link..
			if (not playerName or not playerClass or not playerItemLevel or not playerLevel) then
				return;
			end
			
			--Bad Link..
			if (not className or not classFileName or not classColor) then
				return;
			end
			
			GameTooltip_SetTitle(gtt, classColor:WrapTextInColorCode(playerName));
			GameTooltip_AddColoredLine(gtt, DUNGEON_SCORE_LINK_LEVEL_CLASS_FORMAT_STRING:format(playerLevel, className), HIGHLIGHT_FONT_COLOR);
			GameTooltip_AddNormalLine(gtt, DUNGEON_SCORE_LINK_ITEM_LEVEL:format(playerItemLevel));
			
			local color = C_ChallengeMode.GetDungeonScoreRarityColor(dungeonScore);
			if (not color) then
				color = HIGHLIGHT_FONT_COLOR;
			end
			
			GameTooltip_AddNormalLine(gtt, DUNGEON_SCORE_LINK_RATING:format(color:WrapTextInColorCode(dungeonScore)));
			GameTooltip_AddNormalLine(gtt, DUNGEON_SCORE_LINK_RUNS_SEASON:format(runsThisSeason));
			GameTooltip_AddBlankLineToTooltip(gtt);
			
			local sortTable = { };
			local DUNGEON_SCORE_LINK_INDEX_START = 9;
			local DUNGEON_SCORE_LINK_ITERATE = 3;
			for i = DUNGEON_SCORE_LINK_INDEX_START, (#splits), DUNGEON_SCORE_LINK_ITERATE do
				local mapChallengeModeID = tonumber(splits[i]);
				local completedInTime = tonumber(splits[i + 1]);
				local level = tonumber(splits[i + 2]);
				
				local mapName = C_ChallengeMode.GetMapUIInfo(mapChallengeModeID);
				
				--If any of the maps don't exist.. this is a bad link
				if (not mapName) then
					return;
				end
				
				table.insert(sortTable, { mapName = mapName, completedInTime = completedInTime, level = level });
			end
			
			-- Sort Alphabetically.
			table.sort(sortTable, function(a, b) strcmputf8i(a.mapName, b.mapName); end);
			
			for i = 1, #sortTable do
				local textColor = sortTable[i].completedInTime and HIGHLIGHT_FONT_COLOR or GRAY_FONT_COLOR;
				GameTooltip_AddColoredDoubleLine(gtt, DUNGEON_SCORE_LINK_TEXT1:format(sortTable[i].mapName), (sortTable[i].level > 0 and  DUNGEON_SCORE_LINK_TEXT2:format(sortTable[i].level) or DUNGEON_SCORE_LINK_NO_SCORE), NORMAL_FONT_COLOR, textColor);
			end
			
			-- Backdrop Border Color: By Class
			if (cfg.classColoredBorder) then
				tt:SetBackdropBorderColorLocked(gtt, true, classColor.r, classColor.g, classColor.b);
			end
			
			showingTooltip = gtt;
			gtt:Show();
		else
			showingTooltip = gtt;
			gtt:SetHyperlink(refString);
			gtt:Show();
		end
	end
end

-- ChatFrame:OnHyperlinkLeave
local function OnHyperlinkLeave(self)
	if (showingTooltip) then
		showingTooltip:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Element Events                                           --
--------------------------------------------------------------------------------------------------------

function ttHyperlink:OnLoad()
	cfg = TipTac_Config;
end

function ttHyperlink:OnApplyConfig(cfg)
	-- ChatFrame Hyperlink Hover -- Az: this may need some more testing, code seems wrong. e.g. why only on first window? -- Frozn45: completely rewritten.
	if (cfg.enableChatHoverTips) then
		if (not self.hookedHoverHyperlinks) then
			for i = 1, NUM_CHAT_WINDOWS do
				local chat = _G["ChatFrame"..i];
				AceHook:SecureHookScript(chat, "OnHyperlinkEnter", OnHyperlinkEnter);
				AceHook:SecureHookScript(chat, "OnHyperlinkLeave", OnHyperlinkLeave);
			end
			self.hookedHoverHyperlinks = true;
		end
		if (not self.hookedHoverHyperlinksOnCFCMF) then
			if (IsAddOnLoaded("Blizzard_Communities")) then
				AceHook:SecureHookScript(CommunitiesFrame.Chat.MessageFrame, "OnHyperlinkEnter", OnHyperlinkEnter);
				AceHook:SecureHookScript(CommunitiesFrame.Chat.MessageFrame, "OnHyperlinkLeave", OnHyperlinkLeave);
				self.hookedHoverHyperlinksOnCFCMF = true;
			end
		end
	else
		if (self.hookedHoverHyperlinks) then
			for i = 1, NUM_CHAT_WINDOWS do
				local chat = _G["ChatFrame"..i];
				AceHook:Unhook(chat, "OnHyperlinkEnter");
				AceHook:Unhook(chat, "OnHyperlinkLeave");
			end
			self.hookedHoverHyperlinks = false;
		end
		if (self.hookedHoverHyperlinksOnCFCMF) then
			if (IsAddOnLoaded("Blizzard_Communities")) then
				AceHook:Unhook(CommunitiesFrame.Chat.MessageFrame, "OnHyperlinkEnter");
				AceHook:Unhook(CommunitiesFrame.Chat.MessageFrame, "OnHyperlinkLeave");
				self.hookedHoverHyperlinksOnCFCMF = false;
			end
		end
	end
end
