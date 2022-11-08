local L = select(2, ...).L

local AceHook = LibStub("AceHook-3.0");
local format = string.format;
local unpack = unpack;
local gtt = GameTooltip;
local bptt = BattlePetTooltip;
local fbptt = FloatingBattlePetTooltip;
local pjpatt = PetJournalPrimaryAbilityTooltip;
local pjsatt = PetJournalSecondaryAbilityTooltip;
local fpbatt = FloatingPetBattleAbilityTooltip;
local ejtt = EncounterJournalTooltip;

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

local CreateColorFromHexString = CreateColorFromHexString;

if (not CreateColorFromHexString) then
	CreateColorFromHexString = function(hexColor)
		return CreateColor(tonumber(hexColor:sub(3, 4), 16) / 255, tonumber(hexColor:sub(5, 6), 16) / 255, tonumber(hexColor:sub(7, 8), 16) / 255, tonumber(hexColor:sub(1, 2), 16) / 255);
	end
end

local GetSpellLink = GetSpellLink;

if (isWoWClassic) then
	GetSpellLink = function(spellID)
		local name, _, icon, castTime, minRange, maxRange, _spellID = GetSpellInfo(spellID);	-- [18.07.19] 8.0/BfA: 2nd param "rank/nameSubtext" now returns nil
		return format("|c%s|Hspell:%d:0|h[%s]|h|r", "FF71D5FF", spellID, name);
	end
end

local C_CurrencyInfo_GetCurrencyLink = C_CurrencyInfo.GetCurrencyLink;

if (not C_CurrencyInfo_GetCurrencyLink) then
	C_CurrencyInfo_GetCurrencyLink = GetCurrencyLink;
end

local C_QuestLog_GetSelectedQuest = C_QuestLog.GetSelectedQuest;

if (not C_QuestLog_GetSelectedQuest) then
	C_QuestLog_GetSelectedQuest = function()
		local index = GetQuestLogSelection();
		local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory, isHidden, isScaling = GetQuestLogTitle(index);
		return questID;
	end
end

-- Addon
local modName = ...;
local ttif = CreateFrame("Frame", modName);

-- Register with TipTac core addon if available
if (TipTac) then
	TipTac:RegisterElement(ttif,"ItemRef");
end

-- Default Config
local cfg;
local TTIF_DefaultConfig = {
	if_enable = true,
	if_infoColor = { 0.2, 0.6, 1 },

	if_itemQualityBorder = true,
	if_showItemLevel = false,					-- Used to be true, but changed due to the itemLevel issues
	if_showItemId = true,
	if_showKeystoneRewardLevel = true,
	if_showKeystoneTimeLimit = true,
	if_showKeystoneAffixInfo = true,
	if_modifyKeystoneTips = true,
	if_spellColoredBorder = true,
	if_showSpellIdAndRank = true,
	if_auraSpellColoredBorder = true,
	if_showAuraSpellIdAndRank = true,
	if_showMawPowerId = false,
	if_showAuraCaster = true,
	if_questDifficultyBorder = true,
	if_showQuestLevel = true,
	if_showQuestId = true,
	if_currencyQualityBorder = true,
	if_showCurrencyId = true,
	if_achievmentColoredBorder = true,
	if_showAchievementIdAndCategoryId = true,
	if_modifyAchievementTips = true,
	if_battlePetQualityBorder = true,
	if_showBattlePetLevel = false,
	if_showBattlePetId = false,
	if_battlePetAbilityColoredBorder = true,
	if_showBattlePetAbilityId = false,
	if_transmogAppearanceItemQualityBorder = true,
	if_showTransmogAppearanceItemId = false,
	if_transmogIllusionColoredBorder = true,
	if_showTransmogIllusionId = false,
	if_transmogSetQualityBorder = true,
	if_showTransmogSetId = false,
	if_conduitQualityBorder = true,
	if_showConduitItemLevel = false,
	if_showConduitId = false,
	if_azeriteEssenceQualityBorder = true,
	if_showAzeriteEssenceId = false,
	if_runeforgePowerColoredBorder = true,
	if_showRuneforgePowerId = false,
	if_flyoutColoredBorder = true,
	if_showFlyoutId = false,
	if_petActionColoredBorder = true,
	if_showPetActionId = false,

	if_showIcon = true,
	if_smartIcons = true,
	if_borderlessIcons = false,
	if_iconSize = 42,
	if_iconAnchor = "BOTTOMLEFT",
	if_iconTooltipAnchor = "TOPLEFT",
	if_iconOffsetX = 2.5,
	if_iconOffsetY = -2.5,
};

-- Tooltips to Hook into -- MUST be a GameTooltip widget -- If the main TipTac is installed, the TT_TipsToModify is used instead
local tipsToModify = {
	"GameTooltip",
	"ItemRefTooltip",
	"NamePlateTooltip",
	"BattlePetTooltip",
	"FloatingBattlePetTooltip",
	"PetJournalPrimaryAbilityTooltip",
	"PetJournalSecondaryAbilityTooltip",
	"FloatingPetBattleAbilityTooltip",
	--"EncounterJournalTooltip", -- commented out for embedded tooltips, see description in tt:SetPadding()
	-- 3rd party addon tooltips
	"PlaterNamePlateAuraTooltip",
};

local addOnsLoaded = {
	["TipTacItemRef"] = false,
	["Blizzard_AchievementUI"] = false,
	["Blizzard_Collections"] = false,
	["Blizzard_Communities"] = false,
	["Blizzard_EncounterJournal"] = false,
	["Blizzard_GuildUI"] = false,
	["Blizzard_PlayerChoice"] = false,
	["Blizzard_PVPUI"] = false,
	["WorldQuestTracker"] = false
};

-- Tips which will have an icon
local tipsToAddIcon = {
	["GameTooltip"] = true,
	["ShoppingTooltip1"] = true,
	["ShoppingTooltip2"] = true,
	["ItemRefTooltip"] = true,
	["ItemRefShoppingTooltip1"] = true,
	["ItemRefShoppingTooltip2"] = true,
	["BattlePetTooltip"] = true,
	["FloatingBattlePetTooltip"] = true,
	["PetJournalPrimaryAbilityTooltip"] = true,
	["PetJournalSecondaryAbilityTooltip"] = true,
	["FloatingPetBattleAbilityTooltip"] = true,
	--["EncounterJournalTooltip"] = true, -- commented out for embedded tooltips, see description in tt:SetPadding()
};

-- Tables
local LinkTypeFuncs = {};
local CustomTypeFuncs = {};
local criteriaList = {};	-- Used for Achievement criterias
local tipDataAdded = {};	-- Sometimes, OnTooltipSetItem/Spell is called before the tip has been filled using SetHyperlink, we use the array to test if the tooltip has had data added

-- Colors for achivements
local COLOR_COMPLETE = { 0.25, 0.75, 0.25 };
local COLOR_INCOMPLETE = { 0.5, 0.5, 0.5 };

-- Colored text string (red/green)
local BoolCol = { [false] = "|cffff8080", [true] = "|cff80ff80" };

--------------------------------------------------------------------------------------------------------
--                                         Create Tooltip Icon                                        --
--------------------------------------------------------------------------------------------------------

-- Set Texture and Text
local function ttSetIconTextureAndText(self, texture, count)
	if (texture) then
		self.ttIcon:SetTexture(texture ~= "" and texture or "Interface\\Icons\\INV_Misc_QuestionMark");
		if (count) and (count ~= "") and (tonumber(count) > 0) then
			self.ttCount:SetText(count);
		else
			self.ttCount:SetText("");
		end
		self.ttIcon:Show();
	else
		self.ttIcon:Hide();
		self.ttCount:SetText("");
	end
end

-- Create Icon with Counter Text for Tooltip
function ttif:CreateTooltipIcon(tip)
	tip.ttIcon = tip:CreateTexture(nil, "BACKGROUND");
	tip.ttIcon:SetPoint(cfg.if_iconAnchor,tip, cfg.if_iconTooltipAnchor, cfg.if_iconOffsetX, cfg.if_iconOffsetY);
	tip.ttIcon:Hide();

	tip.ttCount = tip:CreateFontString(nil, "ARTWORK");
	tip.ttCount:SetTextColor(1, 1, 1);
	tip.ttCount:SetPoint("BOTTOMRIGHT", tip.ttIcon, "BOTTOMRIGHT", -3, 3);
end

--------------------------------------------------------------------------------------------------------
--                                         TipTacItemRef Frame                                        --
--------------------------------------------------------------------------------------------------------

ttif:SetScript("OnEvent",function(self,event,...) self[event](self,event,...); end);

ttif:RegisterEvent("VARIABLES_LOADED");
ttif:RegisterEvent("ADDON_LOADED");

-- Resolves the given table array of string names into their global objects
local function ResolveGlobalNamedObjects(tipTable)
	local resolved = {};
	for index, tipName in ipairs(tipTable) do
		-- lookup the global object from this name, assign false if nonexistent, to preserve the table entry
		if (type(tipName) == "string") then
			local tip = (_G[tipName] or false);

			-- Check if this object has already been resolved. This can happen for thing like AtlasLoot, which sets AtlasLootTooltip = GameTooltip
			if (resolved[tip]) then
				tip = false;
			elseif (tip) then
				if (type(tip) == "table" and BackdropTemplateMixin and "BackdropTemplate") then
					Mixin(tip, BackdropTemplateMixin);
					if (tip.NineSlice) then
						Mixin(tip.NineSlice, BackdropTemplateMixin);
					end
				end
				resolved[tip] = index;
			end

			-- Assign the resolved object or false back into the table array
			tipTable[index] = tip;
		end
	end
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
function ttif:VARIABLES_LOADED(event)
	-- What tipsToModify to use, TipTac's main addon, or our own?
	if (TipTac and TipTac.tipsToModify) then
		tipsToModify = TipTac.tipsToModify;
	end

	-- Use TipTac settings if installed
	if (TipTac_Config) then
		cfg = ChainConfigTables(TipTac_Config, TTIF_DefaultConfig);
	else
		cfg = TTIF_DefaultConfig;
	end

	-- Hook Tips & Apply Settings
	self:HookTips();
	self:OnApplyConfig();
	
	-- Re-Trigger event ADDON_LOADED for TipTacItemRef if config wasn't ready
	self:ADDON_LOADED("ADDON_LOADED", "TipTacItemRef");
	
	-- Cleanup
	self:UnregisterEvent(event);
	self[event] = nil;
end

--------------------------------------------------------------------------------------------------------
--                                           Element Events                                           --
--------------------------------------------------------------------------------------------------------

-- Apply Settings -- It seems this may be called from TipTac:OnApplyConfig() before we have received our VARIABLES_LOADED, so ensure we have created the tip objects
function ttif:OnApplyConfig()
	local gameFont = GameFontNormal:GetFont();
	for index, tip in ipairs(tipsToModify) do
		if (type(tip) == "table") and (tipsToAddIcon[tip:GetName()]) and (tip.ttIcon) then
			if (cfg.if_showIcon) then
				tip.ttIcon:SetSize(cfg.if_iconSize, cfg.if_iconSize);
				tip.ttCount:SetFont(gameFont, (cfg.if_iconSize / 3), "OUTLINE");
				tip.ttSetIconTextureAndText = ttSetIconTextureAndText;
				if (cfg.if_borderlessIcons) then
					tip.ttIcon:SetTexCoord(0.07, 0.93, 0.07, 0.93);
				else
					tip.ttIcon:SetTexCoord(0, 1, 0, 1);
				end
				tip.ttIcon:ClearAllPoints();
				tip.ttIcon:SetPoint(cfg.if_iconAnchor, tip, cfg.if_iconTooltipAnchor, cfg.if_iconOffsetX, cfg.if_iconOffsetY);
			elseif (tip.ttSetIconTextureAndText) then
				tip.ttIcon:Hide();
				tip.ttSetIconTextureAndText = nil;
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                       HOOK: Tooltip Functions                                      --
--------------------------------------------------------------------------------------------------------

-- apply workaround for the following "bug": on first mouseover over toy or unit aura after starting the game the gtt will be cleared (OnTooltipCleared) and internally set again. There ist no immediately following SetToyByItemID(), SetAction(), SetUnitAura() or SetAzeriteEssence() (only approx. 0.2-1 second later), but on the next OnUpdate the GetItem() is set again.
-- ttWorkaroundForFirstMouseoverStatus:
-- nil = no hooks applied (uninitialized)
-- 0   = hooks applied (initialized)
-- 1   = waiting for GameTooltip:OnTooltipCleared (armed, 1st stage)
-- 2   = waiting for GameTooltip:OnUpdate (armed, 2nd stage)
-- 3   = tooltip modification reapplied (triggered)
function ttif:ApplyWorkaroundForFirstMouseover(self, isAura, source, link, linkType, id, rank)
	local tooltip = self;
	
	-- functions
	local resetVarsFn = function(tooltip)
		tooltip.ttWorkaroundForFirstMouseoverStatus = 0; -- initialized
		tooltip.ttWorkaroundForFirstMouseoverID = nil;
		tooltip.ttWorkaroundForFirstMouseoverRank = nil;
		tooltip.ttWorkaroundForFirstMouseoverOwner = nil;
	end
	
	local initVarsFn = function(tooltip, id, rank, owner)
		tooltip.ttWorkaroundForFirstMouseoverStatus = 1; -- armed, 1st stage
		tooltip.ttWorkaroundForFirstMouseoverID = id;
		tooltip.ttWorkaroundForFirstMouseoverRank = rank;
		tooltip.ttWorkaroundForFirstMouseoverOwner = owner;
	end
	
	local reapplyTooltipModificationFn = function(tooltip)
		tipDataAdded[tooltip] = linkType;
		if (linkType == "spell") then
			LinkTypeFuncs.spell(tooltip, isAura, source, link, linkType, tooltip.ttWorkaroundForFirstMouseoverID);
		elseif (linkType == "azessence") then
			LinkTypeFuncs.azessence(tooltip, link, linkType, tooltip.ttWorkaroundForFirstMouseoverID, tooltip.ttWorkaroundForFirstMouseoverRank);
		else
			LinkTypeFuncs.item(tooltip, link, linkType, tooltip.ttWorkaroundForFirstMouseoverID);
		end
	end
	
	-- apply hooks
	if (not tooltip.ttWorkaroundForFirstMouseoverStatus) then -- nil = uninitialized
		AceHook:SecureHookScript(tooltip, "OnTooltipCleared", function(tooltip)
			if (tooltip.ttWorkaroundForFirstMouseoverStatus == 1) then -- armed, 1st stage
				if (tooltip:GetOwner() ~= tooltip.ttWorkaroundForFirstMouseoverOwner) then
					resetVarsFn(tooltip); -- 0 = initialized
					return;
				end
				tooltip.ttWorkaroundForFirstMouseoverStatus = 2; -- armed, 2nd stage
			end
		end);
		
		AceHook:SecureHookScript(tooltip, "OnUpdate", function(tooltip)
			if (tooltip.ttWorkaroundForFirstMouseoverStatus == 2) then -- armed, 2nd stage
				reapplyTooltipModificationFn(tooltip);
				tooltip.ttWorkaroundForFirstMouseoverStatus = 3; -- triggered
			end
		end);
		
		AceHook:SecureHookScript(tooltip, "OnHide", function(tooltip)
			resetVarsFn(tooltip); -- 0 = initialized
		end);
		
		resetVarsFn(tooltip); -- 0 = initialized
	end
	
	if (tooltip.ttWorkaroundForFirstMouseoverStatus == 0) or (tooltip.ttWorkaroundForFirstMouseoverID ~= id) or (owner ~= tooltip.ttWorkaroundForFirstMouseoverOwner) then
		initVarsFn(tooltip, id, rank, tooltip:GetOwner()); -- 1 = armed, 1st stage
	else
		tooltip.ttWorkaroundForFirstMouseoverStatus = 3; -- triggered
	end
end

-- add text line to PetJournalPrimaryAbilityTooltip, PetJournalSecondaryAbilityTooltip, FloatingPetBattleAbilityTooltip and EncounterJournalTooltip (see BattlePetTooltipTemplate_AddTextLine() in "FloatingPetBattleTooltip.lua")
local function PJATT_EJTT_AddTextLine(self, text, r, g, b, wrap)
	local linePadding = 2;
	local anchorXOfs = 0;
	local anchorYOfs = 0;
	local anchorXOfsWrap = 0;
	
	if not r then
		r, g, b = NORMAL_FONT_COLOR:GetRGB();
	end
	
	local anchor = self.textLineAnchor;
	if not anchor then
		if (self == pjpatt or self == pjsatt or self == fpbatt) then
			anchor = self.bottomFrame;
			linePadding = 5;
			anchorXOfsWrap = -10;
		elseif (self == ejtt) then
			if (self.Item2:IsShown()) then
				anchor = self.Item2;
			else
				anchor = self.Item1.tooltip;
			end
			anchorXOfs = 10; -- see AdventureJournal_Reward_OnEnter() in "Blizzard_EncounterJournal/Blizzard_EncounterJournal.lua"
			anchorYOfs = 6;
		end
	end
	
	local line = self.linePool:Acquire();
	line:SetText(text);
	line:SetTextColor(r, g, b);
	line:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", anchorXOfs, -linePadding + anchorYOfs);
	
	if wrap then
		line:SetPoint("RIGHT", self, "RIGHT", anchorXOfsWrap, -linePadding + anchorYOfs);
	end
	
	line:Show();
	
	self.textLineAnchor = line;
	
	self:SetHeight(self:GetHeight() + line:GetHeight() + linePadding);
	
	if (self == pjpatt or self == pjsatt or self == fpbatt) then
		self.bottomFrame = line;
	end
end

-- HOOK: PetJournalPrimaryAbilityTooltip:OnLoad + PetJournalSecondaryAbilityTooltip:OnLoad + FloatingPetBattleAbilityTooltip:OnLoad + EncounterJournalTooltip:OnLoad (see BattlePetTooltip_OnLoad() in "FloatingPetBattleTooltip.lua")
local function PJATT_EJTT_OnLoad_Hook(self)
	local subLayer = 0;
	self.linePool = CreateFontStringPool(self, "ARTWORK", subLayer, "GameTooltipText");
	self.AddLine = PJATT_EJTT_AddTextLine;
end

-- HOOK: PetJournalPrimaryAbilityTooltip:OnShow + PetJournalSecondaryAbilityTooltip:OnShow + FloatingPetBattleAbilityTooltip:OnShow + EncounterJournalTooltip:OnShow (see BattlePetTooltipTemplate_SetBattlePet() in "FloatingPetBattleTooltip.lua")
local function PJATT_EJTT_OnShow_Hook(self)
	self.linePool:ReleaseAll();
	self.textLineAnchor = nil;
end

--
-- main hooking functions
-- 

-- HOOK: ItemRefTooltip + GameTooltip:SetHyperlink
function ttif:SetHyperlink_Hook(self, hyperlink)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local refString = hyperlink:match("|H([^|]+)|h") or hyperlink;
		local linkType = refString:match("^[^:]+");
		-- Call Tip Type Func
		if (LinkTypeFuncs[linkType]) and (self:NumLines() > 0) then
			tipDataAdded[self] = "hyperlink";
			if (linkType == "spell") then
				LinkTypeFuncs.spell(self, false, nil, refString, (":"):split(refString));
			elseif (linkType == "azessence") then
				local _linkType, essenceID, essenceRank = (":"):split(refString);
				local link = C_AzeriteEssence.GetEssenceHyperlink(essenceID, essenceRank);
				if (link) then
					local linkType, _essenceID, _essenceRank = link:match("H?(%a+):(%d+):(%d+)");
					if (_essenceID) then
						tipDataAdded[self] = linkType;
						LinkTypeFuncs.azessence(self, link, linkType, _essenceID, _essenceRank);

						-- apply workaround for first mouseover
						ttif:ApplyWorkaroundForFirstMouseover(self, false, nil, link, linkType, _essenceID, _essenceRank);
					end
				end
			else
				LinkTypeFuncs[linkType](self, refString, (":"):split(refString));
			end
		end
	end
end

-- HOOK: SetUnitAura
local function SetUnitAura_Hook(self, unit, index, filter)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod =  UnitAura(unit, index, filter); -- [18.07.19] 8.0/BfA: "dropped second parameter"
		if (spellID) then
			local link = GetSpellLink(spellID);
			if (link) then
				local linkType, _spellID = link:match("H?(%a+):(%d+)");
				if (_spellID) then
					tipDataAdded[self] = linkType;
					LinkTypeFuncs.spell(self, true, source, link, linkType, _spellID);

					-- apply workaround for first mouseover
					ttif:ApplyWorkaroundForFirstMouseover(self, true, source, link, linkType, _spellID);
				end
			end
		end
	end
end

-- HOOK: SetUnitBuffByAuraInstanceID/SetUnitDebuffByAuraInstanceID
local function SetUnitXxxxByAuraInstanceID(self, unit, instanceID)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local info = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, instanceID)
		local spellID = info.spellId
		if (spellID) then
			local link = GetSpellLink(spellID);
			if (link) then
				local linkType, _spellID = link:match("H?(%a+):(%d+)");
				if (_spellID) then
					tipDataAdded[self] = linkType;
					LinkTypeFuncs.spell(self, true, info.sourceUnit, link, linkType, _spellID);

					-- apply workaround for first mouseover
					ttif:ApplyWorkaroundForFirstMouseover(self, true, info.sourceUnit, link, linkType, _spellID);
				end
			end
		end
	end
end

-- HOOK: GameTooltip:SetCompanionPet
local function SetCompanionPet_Hook(self, petID)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, tooltipSource, tooltipDescription, isWild, canBattle, isTradeable, isUnique, obtainable = C_PetJournal.GetPetInfoByPetID(petID);
		if (speciesID) then
			local health, maxHealth, power, speed, breedQuality = C_PetJournal.GetPetStats(petID);
			tipDataAdded[self] = "battlepet";
			LinkTypeFuncs.battlepet(self, nil, "battlepet", speciesID, level, breedQuality and breedQuality - 1 or 0, maxHealth, power, speed, nil, displayID);
		end
	end
end

-- HOOK: ItemRefTooltip + GameTooltip:SetAction
local function SetAction_Hook(self, slot)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local actionType, id, subType = GetActionInfo(slot);
		if (actionType == "spell" and subType == "pet") then
			local line = _G[self:GetName().."TextLeft1"]; -- id is always 0. as a workaround find pet action in pet spell book by name.
			local name = line and (line:GetText() or "");
			if (name ~= "" and PetHasSpellbook()) then
				local numPetSpells, petToken = HasPetSpells(); -- returns numPetSpells = nil for feral spirit (shaman wolves) in wotlkc
				
				if (numPetSpells) then
					for i = 1, numPetSpells do
						local spellType, _id = GetSpellBookItemInfo(i, BOOKTYPE_PET); -- see SpellButton_OnEnter() in "SpellBookFrame.lua"
						if (spellType == "PETACTION") then
							local spellName, spellSubName, spellID = GetSpellBookItemName(i, BOOKTYPE_PET);
							if (spellName == name) then
								local icon = GetSpellBookItemTexture(i, BOOKTYPE_PET);
								tipDataAdded[self] = "petAction";
								CustomTypeFuncs.petAction(self, nil, "petAction", _id, icon);
								break;
							end
						end
					end
				end
			end
			
			if (not tipDataAdded[self]) then -- fallback if pet action was not found in pet spell book by name.
				local icon = GetActionTexture(slot);
				tipDataAdded[self] = "petAction";
				CustomTypeFuncs.petAction(self, nil, "petAction", nil, icon);
			end
		elseif (actionType == "item") then
			local _, link = self:GetItem();
			if (link) then
				local linkType, itemID = link:match("H?(%a+):(%d+)");
				if (itemID) then
					tipDataAdded[self] = linkType;
					LinkTypeFuncs.item(self, link, linkType, itemID);
					
					-- apply workaround for first mouseover if item is a toy
					if (C_ToyBox) then
						_itemID, toyName, icon, isFavorite, hasFanfare, itemQuality = C_ToyBox.GetToyInfo(itemID);
						
						if (_itemID) then
							ttif:ApplyWorkaroundForFirstMouseover(self, false, nil, link, linkType, itemID);
						end
					end
				end
			end
		elseif (actionType == "summonpet") then
			local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, tooltipSource, tooltipDescription, isWild, canBattle, isTradeable, isUnique, obtainable = C_PetJournal.GetPetInfoByPetID(id);
			if (speciesID) then
				local health, maxHealth, power, speed, breedQuality = C_PetJournal.GetPetStats(id);
				tipDataAdded[self] = "battlepet";
				LinkTypeFuncs.battlepet(self, nil, "battlepet", speciesID, level, breedQuality and breedQuality - 1 or 0, maxHealth, power, speed, nil, displayID);
			end
		elseif (actionType == "flyout") then
			local icon = GetActionTexture(slot);
			tipDataAdded[self] = "flyout";
			CustomTypeFuncs.flyout(self, nil, "flyout", id, icon);
		elseif (actionType == "macro") then
			local spellID = GetMacroSpell(id);
			if (spellID) then
				local link = GetSpellLink(spellID);
				if (link) then
					local linkType, _spellID = link:match("H?(%a+):(%d+)");
					if (_spellID) then
						tipDataAdded[self] = linkType;
						LinkTypeFuncs.spell(self, false, nil, link, linkType, _spellID);
					end
				end
			end
		end
	end
end

-- HOOK: GameTooltip:SetSpellBookItem
local function SetSpellBookItem_Hook(self, slot, bookType)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local spellType, id = GetSpellBookItemInfo(slot, bookType); -- see SpellButton_OnEnter() in "SpellBookFrame.lua"
		if (spellType == "FLYOUT") then
			local icon = GetSpellBookItemTexture(slot, bookType);
			tipDataAdded[self] = "flyout";
			CustomTypeFuncs.flyout(self, nil, "flyout", id, icon);
		elseif (spellType == "PETACTION") then
			local icon = GetSpellBookItemTexture(slot, bookType);
			tipDataAdded[self] = "petAction";
			CustomTypeFuncs.petAction(self, nil, "petAction", id, icon);
		end
	end
end

-- HOOK: GameTooltip:SetPetAction
local function SetPetAction_Hook(self, slot)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(slot); -- see PetActionBar_Update() in "PetActionBarFrame.lua"
		if (spellID) then
			local link = GetSpellLink(spellID);
			if (link) then
				local linkType, _spellID = link:match("H?(%a+):(%d+)");
				if (spellID) then
					tipDataAdded[self] = linkType;
					LinkTypeFuncs.spell(self, false, nil, link, linkType, _spellID);
				end
			end
		else
			local _name, icon;
			if (isToken) then
				_name = _G[name];
				icon = _G[texture];
			else
				_name = name;
				icon = texture;
			end
			
			if (_name ~= "" and PetHasSpellbook()) then -- id is missing. as a workaround find pet action in pet spell book by name.
				local numPetSpells, petToken = HasPetSpells(); -- returns numPetSpells = nil for feral spirit (shaman wolves) in wotlkc
				
				if (numPetSpells) then
					for i = 1, numPetSpells do
						local spellType, id = GetSpellBookItemInfo(i, BOOKTYPE_PET); -- see SpellButton_OnEnter() in "SpellBookFrame.lua"
						if (spellType == "PETACTION") then
							local spellName, spellSubName, spellID = GetSpellBookItemName(i, BOOKTYPE_PET);
							if (spellName == _name) then
								tipDataAdded[self] = "petAction";
								CustomTypeFuncs.petAction(self, nil, "petAction", id, icon);
								break;
							end
						end
					end
				end
			end
			
			if (not tipDataAdded[self]) then -- fallback if pet action was not found in pet spell book by name.
				tipDataAdded[self] = "petAction";
				CustomTypeFuncs.petAction(self, nil, "petAction", nil, icon);
			end
		end
	end
end

-- HOOK: GameTooltip:SetQuestItem
local function SetQuestItem_Hook(self, _type, index)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local name, texture, numItems, quality, isUsable, itemID = GetQuestItemInfo(_type, index); -- see QuestInfoRewardItemCodeTemplate_OnEnter() in "QuestInfo.lua"
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemID);
		if (itemLink) then
			local linkType, _itemID = itemLink:match("H?(%a+):(%d+)");
			if (_itemID) then
				tipDataAdded[gtt] = linkType;
				LinkTypeFuncs.item(gtt, itemLink, linkType, _itemID);
			end
		end
	end
end

-- HOOK: GameTooltip:SetQuestLogItem
local function SetQuestLogItem_Hook(self, _type, index)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local isChoice = (_type == "choice"); -- see QuestInfoRewardItemCodeTemplate_OnEnter() in "QuestInfo.lua"
		local itemID, numItems;
		if (isChoice) then
			local name, texture, _numItems, quality, isUsable, _itemID = GetQuestLogChoiceInfo(index);
			itemID = _itemID;
			numItems = _numItems;
		else
			local name, texture, _numItems, quality, isUsable, _itemID, itemLevel = GetQuestLogRewardInfo(index);
			itemID = _itemID;
			numItems = _numItems;
		end
		local itemName, itemLink, itemRarity, _itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemID);
		if (itemLink) then
			local linkType, __itemID = itemLink:match("H?(%a+):(%d+)");
			if (__itemID) then
				tipDataAdded[gtt] = linkType;
				LinkTypeFuncs.item(gtt, itemLink, linkType, __itemID);
			end
		end
	end
end

-- HOOK: GameTooltip:SetQuestCurrency
local function SetQuestCurrency_Hook(self, _type, index)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local currencyID = GetQuestCurrencyID(_type, index); -- see QuestInfoRewardItemCodeTemplate_OnEnter() in "QuestInfo.lua"
		local name, texture, quantity, quality = GetQuestCurrencyInfo(_type, index);
		local link = C_CurrencyInfo_GetCurrencyLink(currencyID, quantity);
		if (link) then
			local linkType, _currencyID, _quantity = link:match("H?(%a+):(%d+):(%d+)");
			if (_currencyID) then
				tipDataAdded[gtt] = linkType;
				LinkTypeFuncs.currency(gtt, link, linkType, _currencyID, _quantity);
			end
		end
	end
end

-- HOOK: GameTooltip:SetQuestLogCurrency
local function SetQuestLogCurrency_Hook(self, _type, index)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local questID = C_QuestLog_GetSelectedQuest(); -- see QuestInfoRewardItemCodeTemplate_OnEnter() in "QuestInfo.lua"
		local isChoice = (_type == "choice");
		local name, texture, quantity, currencyID, quality = GetQuestLogRewardCurrencyInfo(index, questID, isChoice);
		local link = C_CurrencyInfo_GetCurrencyLink(currencyID, quantity);
		if (link) then
			local linkType, _currencyID, _quantity = link:match("H?(%a+):(%d+):(%d+)");
			if (_currencyID) then
				tipDataAdded[gtt] = linkType;
				LinkTypeFuncs.currency(gtt, link, linkType, _currencyID, _quantity);
			end
		end
	end
end

-- HOOK: GameTooltip:SetQuestPartyProgress
local function SetQuestPartyProgress_Hook(self, questID, omitTitle, ignoreActivePlayer)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local link = GetQuestLink(questID);
		if (link) then
			local level = link:match("H?%a+:%d+:(%d+)");
			LinkTypeFuncs.quest(self, nil, "quest", questID, level);
		else
			LinkTypeFuncs.quest(self, nil, "quest", questID, nil);
		end
		tipDataAdded[self] = "quest";
	end
end

-- HOOK: GameTooltip:SetRecipeReagentItem
local function SetRecipeReagentItem_Hook(self, recipeID, dataSlotIndex)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local link = C_TradeSkillUI.GetRecipeFixedReagentItemLink(recipeID, dataSlotIndex);
		if (link) then
			local linkType, itemID = link:match("H?(%a+):(%d+)");
			if (itemID) then
				tipDataAdded[self] = linkType;
				LinkTypeFuncs.item(self, link, linkType, itemID);
			end
		end
	end
end

-- HOOK: GameTooltip:SetToyByItemID
local function SetToyByItemID_Hook(self, itemID)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local _, link = self:GetItem();
		if (link) then
			local linkType, itemID = link:match("H?(%a+):(%d+)");
			if (itemID) then
				tipDataAdded[self] = linkType;
				LinkTypeFuncs.item(self, link, linkType, itemID);
				
				-- apply workaround for first mouseover
				ttif:ApplyWorkaroundForFirstMouseover(self, false, nil, link, linkType, itemID);
			end
		end
	end
end

-- HOOK: GameTooltip:SetLFGDungeonReward
local function SetLFGDungeonReward_Hook(self, dungeonID, rewardIndex)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local name, texture, numItems, isBonusReward, rewardType, rewardID, quality = GetLFGDungeonRewardInfo(dungeonID, rewardIndex); -- see LFGDungeonReadyDialogReward_OnEnter in "LFGFrame.lua"
		if (rewardType == "item") then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(rewardID);
			if (itemLink) then
				local linkType, itemID = itemLink:match("H?(%a+):(%d+)");
				if (itemID) then
					tipDataAdded[self] = linkType;
					LinkTypeFuncs.item(self, itemLink, linkType, itemID);
				end
			end
		elseif (rewardType == "currency") then
			local link = C_CurrencyInfo_GetCurrencyLink(rewardID, numItems);
			if (link) then
				local linkType, currencyID, quantity = link:match("H?(%a+):(%d+):(%d+)");
				if (currencyID) then
					tipDataAdded[self] = linkType;
					LinkTypeFuncs.currency(self, link, linkType, currencyID, quantity);
				end
			end
		end
	end
end

-- HOOK: GameTooltip:SetLFGDungeonShortageReward
local function SetLFGDungeonShortageReward_Hook(self, dungeonID, rewardArg, rewardIndex)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local name, texture, numItems, isBonusReward, rewardType, rewardID, quality = GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex); -- see LFGDungeonReadyDialogReward_OnEnter in "LFGFrame.lua"
		if (rewardType == "item") then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(rewardID);
			if (itemLink) then
				local linkType, itemID = itemLink:match("H?(%a+):(%d+)");
				if (itemID) then
					tipDataAdded[self] = linkType;
					LinkTypeFuncs.item(self, itemLink, linkType, itemID);
				end
			end
		elseif (rewardType == "currency") then
			local link = C_CurrencyInfo_GetCurrencyLink(rewardID, numItems);
			if (link) then
				local linkType, currencyID, quantity = link:match("H?(%a+):(%d+):(%d+)");
				if (currencyID) then
					tipDataAdded[self] = linkType;
					LinkTypeFuncs.currency(self, link, linkType, currencyID, quantity);
				end
			end
		end
	end
end

-- HOOK: GameTooltip:SetCurrencyByID
local function SetCurrencyByID_Hook(self, currencyID, quantity)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local link = C_CurrencyInfo_GetCurrencyLink(currencyID, quantity);
		if (link) then
			local linkType, _currencyID, _quantity = link:match("H?(%a+):(%d+):(%d+)");
			if (_currencyID) then
				tipDataAdded[self] = linkType;
				LinkTypeFuncs.currency(self, link, linkType, _currencyID, _quantity);
			end
		end
	end
end

-- HOOK: GameTooltip:SetCurrencyToken
local function SetCurrencyToken_Hook(self, currencyIndex)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local link = C_CurrencyInfo.GetCurrencyListLink(currencyIndex);
		if (link) then
			local linkType, currencyID, quantity = link:match("H?(%a+):(%d+):(%d+)");
			if (currencyID) then
				tipDataAdded[self] = linkType;
				LinkTypeFuncs.currency(self, link, linkType, currencyID, quantity);
			end
		end
	end
end

-- HOOK: GameTooltip:SetCurrencyTokenByID
local function SetCurrencyTokenByID_Hook(self, currencyID)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local link = C_CurrencyInfo_GetCurrencyLink(currencyID);
		if (link) then
			local linkType, _currencyID, quantity = link:match("H?(%a+):(%d+):(%d+)");
			if (_currencyID) then
				tipDataAdded[self] = linkType;
				LinkTypeFuncs.currency(self, link, linkType, _currencyID, quantity);
			end
		end
	end
end

-- HOOK: GameTooltip:SetConduit + GameTooltip:SetEnhancedConduit
local function SetConduit_Hook(self, conduitID, conduitRank)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local link = C_Soulbinds.GetConduitHyperlink(conduitID, conduitRank);
		if (link) then
			local linkType, _conduitID, _conduitRank = link:match("H?(%a+):(%d+):(%d+)");
			if (_conduitID) then
				tipDataAdded[self] = linkType;
				LinkTypeFuncs.conduit(self, link, linkType, _conduitID, _conduitRank);
			end
		end
	end
end

-- HOOK: GameTooltip:SetAzeriteEssence
local function SetAzeriteEssence_Hook(self, essenceID, essenceRank)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local link = C_AzeriteEssence.GetEssenceHyperlink(essenceID, essenceRank);
		if (link) then
			local linkType, _essenceID, _essenceRank = link:match("H?(%a+):(%d+):(%d+)");
			if (_essenceID) then
				tipDataAdded[self] = linkType;
				LinkTypeFuncs.azessence(self, link, linkType, _essenceID, _essenceRank);

				-- apply workaround for first mouseover
				ttif:ApplyWorkaroundForFirstMouseover(self, false, nil, link, linkType, _essenceID, _essenceRank);
			end
		end
	end
end

-- HOOK: GameTooltip:SetAzeriteEssenceSlot
local function SetAzeriteEssenceSlot_Hook(self, slot)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local milestones = C_AzeriteEssence.GetMilestones();
		
		for i, milestoneInfo in ipairs(milestones) do
			if (milestoneInfo.slot == slot) then
				if (not milestoneInfo.unlocked) then
					break;
				end
				
				local milestoneID = milestoneInfo.ID;
				local essenceID = C_AzeriteEssence.GetMilestoneEssence(milestoneID);
				local essenceInfo = C_AzeriteEssence.GetEssenceInfo(essenceID);
				local essenceRank = essenceInfo.rank;
				
				local link = C_AzeriteEssence.GetEssenceHyperlink(essenceID, essenceRank);
				if (link) then
					local linkType, _essenceID, _essenceRank = link:match("H?(%a+):(%d+):(%d+)");
					if (_essenceID) then
						tipDataAdded[self] = linkType;
						LinkTypeFuncs.azessence(self, link, linkType, _essenceID, _essenceRank);

						-- apply workaround for first mouseover
						ttif:ApplyWorkaroundForFirstMouseover(self, false, nil, link, linkType, _essenceID, _essenceRank);
					end
				end
				
				break;
			end
		end
	end
end

-- HOOK: BattlePetToolTip_Show
local function BPTT_Show_Hook(speciesID, level, breedQuality, maxHealth, power, speed, customName)
	if (cfg.if_enable) and (not tipDataAdded[bptt]) and (bptt:IsShown()) then
		tipDataAdded[bptt] = "battlepet";
		local speciesName, speciesIcon, petType, creatureID, tooltipSource, tooltipDescription, isWild, canBattle, isTradeable, isUnique, obtainable, displayID = C_PetJournal.GetPetInfoBySpeciesID(speciesID);
		LinkTypeFuncs.battlepet(bptt, nil, "battlepet", speciesID, level, breedQuality, maxHealth, power, speed, nil, displayID);
	end
end

-- HOOK: FloatingBattlePet_Show
local function FBP_Show_Hook(speciesID, level, breedQuality, maxHealth, power, speed, customName, petID)
	if (cfg.if_enable) and (not tipDataAdded[fbptt]) and (fbptt:IsShown()) then
		local speciesName, speciesIcon, petType, creatureID, tooltipSource, tooltipDescription, isWild, canBattle, isTradeable, isUnique, obtainable, displayID = C_PetJournal.GetPetInfoBySpeciesID(speciesID);
		LinkTypeFuncs.battlepet(fbptt, nil, "battlepet", speciesID, level, breedQuality, maxHealth, power, speed, nil, displayID);
	end
end

-- HOOK: PetJournal_ShowAbilityTooltip
local function PJ_ShowAbilityTooltip_Hook(self, abilityID, speciesID, petID, additionalText)
	if (cfg.if_enable) and (not tipDataAdded[pjpatt]) and (pjpatt:IsShown()) then
		tipDataAdded[pjpatt] = "battlePetAbil";
		LinkTypeFuncs.battlePetAbil(pjpatt, nil, "battlePetAbil", abilityID, speciesID, petID, additionalText);
	end
end

-- HOOK: PetJournal_ShowAbilityCompareTooltip
local function PJ_ShowAbilityCompareTooltip_Hook(abilityID1, abilityID2, speciesID, petID)
	if (cfg.if_enable) then
		if (not tipDataAdded[pjpatt]) and (pjpatt:IsShown()) then
			tipDataAdded[pjpatt] = "battlePetAbil";
			LinkTypeFuncs.battlePetAbil(pjpatt, nil, "battlePetAbil", abilityID1, speciesID, petID, nil);
		end
		if (not tipDataAdded[pjsatt]) and (pjsatt:IsShown()) then
			tipDataAdded[pjsatt] = "battlePetAbil";
			LinkTypeFuncs.battlePetAbil(pjsatt, nil, "battlePetAbil", abilityID2, speciesID, petID, nil);
		end
	end
end

-- HOOK: FloatingPetBattleAbility_Show
local function FPBA_Show_Hook(abilityID, maxHealth, power, speed)
	if (cfg.if_enable) and (fpbatt:IsShown()) then
		if (tipDataAdded[fpbatt]) then -- fire OnShow handler if hyperlink clicked repeatedly. The FloatingPetBattleAbilityTooltip doesn't toggle the tooltip like a FloatingBattlePetTooltip.
			PJATT_EJTT_OnShow_Hook(fpbatt);
		end
		tipDataAdded[fpbatt] = "battlePetAbil";
		LinkTypeFuncs.battlePetAbil(fpbatt, nil, "battlePetAbil", abilityID, nil, nil, nil);
	end
end

-- OnTooltipSetItem
local function OnTooltipSetItem(self,...)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local _, link = self:GetItem();
		if (link) then
			local linkType, id = link:match("H?(%a+):(%d+)");
			if (id) then
				tipDataAdded[self] = linkType;
				if (linkType == "keystone") then
					local refString = link:match("|H([^|]+)|h") or link;
					LinkTypeFuncs.keystone(self, link, (":"):split(refString));
				else
					LinkTypeFuncs.item(self, link, linkType, id);
				end
			end
		end
	end
end

-- OnTooltipSetSpell
local function OnTooltipSetSpell(self,...)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local _, id = self:GetSpell();	-- [18.07.19] 8.0/BfA: "dropped second parameter (nameSubtext)"
		if (id) then
			local link = GetSpellLink(id);
			if (link) then
				local linkType, spellID = link:match("H?(%a+):(%d+)");
				if (spellID) then
					tipDataAdded[self] = linkType;
					LinkTypeFuncs.spell(self, false, nil, link, linkType, spellID);
				end
			end
		end
	end
end

-- HOOK: QuestMapLogTitleButton_OnEnter
local function QMLTB_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local info = C_QuestLog.GetInfo(self.questLogIndex);
		local questID = info.questID;
		local link = GetQuestLink(questID);
		if (link) then
			local level = link:match("H?%a+:%d+:(%d+)");
			LinkTypeFuncs.quest(gtt, nil, "quest", questID, level);
		else
			LinkTypeFuncs.quest(gtt, nil, "quest", questID, nil);
		end
		tipDataAdded[gtt] = "quest";
	end
end

-- HOOK: TaskPOI_OnEnter
local function TPOI_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local questID = self.questID;
		local link = GetQuestLink(questID);
		if (link) then
			local level = link:match("H?%a+:%d+:(%d+)");
			LinkTypeFuncs.quest(gtt, nil, "quest", questID, level);
		else
			LinkTypeFuncs.quest(gtt, nil, "quest", questID, nil);
		end
		tipDataAdded[gtt] = "quest";
	end
end

-- HOOK: QuestPinMixin:OnMouseEnter + StorylineQuestPinMixin:OnMouseEnter
local function QPM_OnMouseEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local questID = self.questID;
		local link = GetQuestLink(questID);
		if (link) then
			local level = link:match("H?%a+:%d+:(%d+)");
			LinkTypeFuncs.quest(gtt, nil, "quest", questID, level);
		else
			LinkTypeFuncs.quest(gtt, nil, "quest", questID, nil);
		end
		tipDataAdded[gtt] = "quest";
	end
end

-- HOOK: QuestBlobPinMixin:OnMouseEnter
local function QBPM_OnMouseEnter_Hook(self)
print("!!! drin");
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local mouseX, mouseY = self:GetMap():GetNormalizedCursorPosition();
		local questID, numPOITooltips = self:UpdateMouseOverTooltip(mouseX, mouseY);
		-- local questID = self.highlightedQuestPOI;
		local link = GetQuestLink(questID);
		if (link) then
			local level = link:match("H?%a+:%d+:(%d+)");
			LinkTypeFuncs.quest(gtt, nil, "quest", questID, level);
		else
			LinkTypeFuncs.quest(gtt, nil, "quest", questID, nil);
		end
		tipDataAdded[gtt] = "quest";
	end
end

-- HOOK: RuneforgePowerBaseMixin:OnEnter
local function RPBM_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local runeforgePowerID = self:GetPowerID();
		if (runeforgePowerID) then
			tipDataAdded[gtt] = "runeforgePower";
			CustomTypeFuncs.runeforgePower(gtt, nil, "runeforgePower", runeforgePowerID);
		end
	end
end

-- HOOK: GameTooltip_AddQuestRewardsToTooltip
local function GTT_AddQuestRewardsToTooltip_Hook(self, questID, style)
	if (cfg.if_enable) and (not tipDataAdded[self]) then
		local link = GetQuestLink(questID);
		if (link) then
			local level = link:match("H?%a+:%d+:(%d+)");
			LinkTypeFuncs.quest(self, nil, "quest", questID, level);
		else
			LinkTypeFuncs.quest(self, nil, "quest", questID, nil);
		end
		tipDataAdded[self] = "quest";
	end
end

-- HOOK: EmbeddedItemTooltip_SetItemByID
local function EITT_SetItemByID_Hook(self, id, count)
	local targetTooltip = self.Tooltip;
	if (cfg.if_enable) and (not tipDataAdded[targetTooltip]) and (targetTooltip:IsShown()) then
		local itemID = id;
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemID);
		if (itemLink) then
			local linkType, _itemID = itemLink:match("H?(%a+):(%d+)");
			if (_itemID) then
				tipDataAdded[targetTooltip] = linkType;
				LinkTypeFuncs.item(targetTooltip, itemLink, linkType, _itemID);
			end
		end
	end
end

-- HOOK: EmbeddedItemTooltip_SetItemByQuestReward
local function EITT_SetItemByQuestReward_Hook(self, questLogIndex, questID, rewardType, showCollectionText)
	local targetTooltip = self.Tooltip;
	if (cfg.if_enable) and (not tipDataAdded[targetTooltip]) and (targetTooltip:IsShown()) then
		if (not questLogIndex) then
			return
		end
		
		rewardType = (rewardType or "reward");
		local getterFunc;
		if (rewardType == "choice") then
			getterFunc = GetQuestLogChoiceInfo;
		else
			getterFunc = GetQuestLogRewardInfo;
		end
		
		local name, texture, numItems, quality, isUsable, itemID = getterFunc(questLogIndex, questID);
		
		if (name) and (texture) then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemID);
			if (itemLink) then
				local linkType, itemID = itemLink:match("H?(%a+):(%d+)");
				if (itemID) then
					tipDataAdded[targetTooltip] = linkType;
					LinkTypeFuncs.item(targetTooltip, itemLink, linkType, itemID);
				end
			end
		end
	end
end

-- HOOK: EmbeddedItemTooltip_SetSpellByQuestReward
local function EITT_SetSpellByQuestReward_Hook(self, rewardIndex, questID)
	local targetTooltip = self.Tooltip;
	if (cfg.if_enable) and (not tipDataAdded[targetTooltip]) and (targetTooltip:IsShown()) then
		local texture, name, isTradeskillSpell, isSpellLearned, hideSpellLearnText, isBoostSpell, garrFollowerID, genericUnlock, spellID = GetQuestLogRewardSpell(rewardIndex, questID);
		
		if (name) and (texture) then
			local link = GetSpellLink(spellID);
			if (link) then
				local linkType, _spellID = link:match("H?(%a+):(%d+)");
				if (spellID) then
					tipDataAdded[targetTooltip] = linkType;
					LinkTypeFuncs.spell(targetTooltip, false, nil, link, linkType, _spellID);
				end
			end
		end
	end
end

-- HOOK: EmbeddedItemTooltip_SetSpellWithTextureByID
local function EITT_SetSpellWithTextureByID_Hook(self, spellID, texture)
	local targetTooltip = self.Tooltip;
	if (cfg.if_enable) and (not tipDataAdded[targetTooltip]) and (targetTooltip:IsShown()) then
		if (texture) then
			local link = GetSpellLink(spellID);
			if (link) then
				local linkType, _spellID = link:match("H?(%a+):(%d+)");
				if (spellID) then
					tipDataAdded[targetTooltip] = linkType;
					LinkTypeFuncs.spell(targetTooltip, false, nil, link, linkType, _spellID);
				end
			end
		end
	end
end

-- HOOK: EmbeddedItemTooltip_SetCurrencyByID
local function EITT_SetCurrencyByID_Hook(self, currencyID, quantity)
	local targetTooltip = self.Tooltip;
	if (cfg.if_enable) and (not tipDataAdded[targetTooltip]) and (targetTooltip:IsShown()) then
		local link = C_CurrencyInfo_GetCurrencyLink(currencyID, quantity);
		if (link) then
			local linkType, _currencyID, _quantity = link:match("H?(%a+):(%d+):(%d+)");
			if (_currencyID) then
				tipDataAdded[targetTooltip] = linkType;
				LinkTypeFuncs.currency(targetTooltip, link, linkType, _currencyID, _quantity);
			end
		end
	end
end

-- HOOK: DressUpOutfitDetailsSlotMixin:OnEnter
local function DUODSM_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		if (not self.transmogID) then
			return;
		end
		if (self.item) then -- item
			local itemID = self.item.itemID;
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemID);
			if (itemLink) then
				local linkType, _itemID = itemLink:match("H?(%a+):(%d+)");
				if (_itemID) then
					tipDataAdded[gtt] = linkType;
					LinkTypeFuncs.item(gtt, itemLink, linkType, _itemID);
				end
			end
		else -- illusion
			local illusionID = self.transmogID;
			local name, hyperlink, sourceText = C_TransmogCollection.GetIllusionStrings(illusionID);
			if (hyperlink) then
				local linkType, illusionID = hyperlink:match("H?(%a+):(%d+)");
				if (illusionID) then
					tipDataAdded[gtt] = linkType;
					LinkTypeFuncs.transmogillusion(gtt, hyperlink, linkType, illusionID);
				end
			end
		end
	end
end

-- HOOK: PlayerChoicePowerChoiceTemplateMixin:OnEnter
local function PCPCTM_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local spellID = (self.optionInfo and self.optionInfo.spellID);
		if (spellID) then
			local link = GetSpellLink(spellID);
			if (link) then
				local linkType, _spellID = link:match("H?(%a+):(%d+)");
				if (_spellID) then
					tipDataAdded[gtt] = linkType;
					LinkTypeFuncs.spell(gtt, false, nil, link, linkType, _spellID);
				end
			end
		end
	end
end

-- HOOK: HonorFrame.BonusFrame.Buttons:OnEnter
local function HFBFB_OnEnter(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) then
		tipDataAdded[gtt] = "pvpEnlistmentBonus";
		CustomTypeFuncs.pvpEnlistmentBonus(gtt, nil, "pvpEnlistmentBonus");
	end
end

-- HOOK: AdventureJournal_Reward_OnEnter
local function AJR_OnEnter_Hook(self)
	if (cfg.if_enable) and (ejtt:IsShown()) then
		local rewardData = self.data;
		if (rewardData) then
			-- item and currency can both exist. In this case currency is the second item.
			if (rewardData.currencyType) or (rewardData.itemLink) then
				if (tipDataAdded[ejtt]) then -- fire OnShow handler to reset line pool. AdventureJournal_Reward_OnEnter will be called multiple times without OnHide.
					PJATT_EJTT_OnShow_Hook(ejtt);
				end
			end
			if (rewardData.currencyType) then -- currency
				local currencyLink = C_CurrencyInfo_GetCurrencyLink(rewardData.currencyType, rewardData.currencyQuantity)
				if (currencyLink) then
					local linkType, currencyID, quantity = currencyLink:match("H?(%a+):(%d+):(%d+)");
					if (currencyID) then
						tipDataAdded[ejtt] = linkType;
						LinkTypeFuncs.currency(ejtt, currencyLink, linkType, currencyID, quantity);
					end
				end
			end
			if (rewardData.itemLink) then -- item
				local linkType, itemID = rewardData.itemLink:match("H?(%a+):(%d+)");
				if (itemID) then
					tipDataAdded[ejtt] = linkType;
					LinkTypeFuncs.item(ejtt, rewardData.itemLink, linkType, itemID);
				end
			end
		end
	end
end

-- HOOK: CommunitiesGuildNewsButton_OnEnter / GuildNewsButton_OnEnter
local function GNB_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local newsType = self.newsType;
		if (newsType == NEWS_PLAYER_ACHIEVEMENT or newsType == NEWS_GUILD_ACHIEVEMENT) then
			local achievementID = self.id;
			local link = GetAchievementLink(achievementID);
			local refString = link:match("|H([^|]+)|h") or link;
			tipDataAdded[gtt] = "achievement";
			LinkTypeFuncs.achievement(gtt, refString, (":"):split(refString));
		end
	end
end

-- HOOK: CommunitiesGuildInfoFrame.Challenges:OnEnter / GuildInfoFrameInfoChallenge:OnEnter
local function GIFC_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		tipDataAdded[gtt] = "guildChallenge";
		CustomTypeFuncs.guildChallenge(gtt, nil, "guildChallenge");
	end
end

-- HOOK: WardrobeCollectionFrame.ItemsCollectionFrame:RefreshAppearanceTooltip() respectively WardrobeCollectionFrame.ItemsCollectionFrame.Models:OnEnter, see WardrobeItemsCollectionMixin:RefreshAppearanceTooltip() and WardrobeItemsModelMixin:OnEnter() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
local function WCFICF_RefreshAppearanceTooltip_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local itemsCollectionFrame = self; -- item, see WardrobeCollectionFrameMixin:GetAppearanceItemHyperlink() + WardrobeItemsModelMixin:OnMouseDown() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
		local wardrobeCollectionFrame = itemsCollectionFrame:GetParent();
		if (wardrobeCollectionFrame.tooltipSourceIndex) then
			local sources = CollectionWardrobeUtil.GetSortedAppearanceSources(self.tooltipVisualID, itemsCollectionFrame:GetActiveCategory(), itemsCollectionFrame.transmogLocation);
			local index = CollectionWardrobeUtil.GetValidIndexForNumSources(wardrobeCollectionFrame.tooltipSourceIndex, #sources);
			local sourceID = sources[index].sourceID;
			
			tipDataAdded[gtt] = "transmogappearance";
			LinkTypeFuncs.transmogappearance(gtt, nil, "transmogappearance", sourceID);
		end
	end
end

-- HOOK: WardrobeCollectionFrame.ItemsCollectionFrame.Models:OnEnter, see WardrobeItemsModelMixin:OnEnter() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
local function WCFICFM_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local itemsCollectionFrame = self:GetParent();
		if (itemsCollectionFrame.transmogLocation:IsIllusion()) then -- illusion
			local illusionID = self.visualInfo.sourceID;
			local name, hyperlink, sourceText = C_TransmogCollection.GetIllusionStrings(illusionID);
			if (hyperlink) then
				local linkType, illusionID = hyperlink:match("H?(%a+):(%d+)");
				if (illusionID) then
					tipDataAdded[gtt] = linkType;
					LinkTypeFuncs.transmogillusion(gtt, hyperlink, linkType, illusionID);
				end
			end
		end
	end
end

-- HOOK: WardrobeCollectionFrame.SetsCollectionFrame:RefreshAppearanceTooltip respectively WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.itemFramesPool:OnEnter, see WardrobeSetsCollectionMixin:RefreshAppearanceTooltip() and WardrobeSetsDetailsItemMixin:OnMouseDown() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
local function WCFSCF_RefreshAppearanceTooltip_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local setID = self:GetSelectedSetID();
		local sourceID = self.tooltipPrimarySourceID;
		
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID);
		local slot = C_Transmog.GetSlotForInventoryType(sourceInfo.invType);
		local sources = C_TransmogSets.GetSourcesForSlot(setID, slot);
		if (#sources == 0) then
			-- can happen if a slot only has HiddenUntilCollected sources
			tinsert(sources, sourceInfo);
		end
		CollectionWardrobeUtil.SortSources(sources, sourceInfo.visualID, sourceID);
		local wardrobeCollectionFrame = self:GetParent();
		local selectedIndex = wardrobeCollectionFrame.tooltipSourceIndex;
		if (selectedIndex) then
			local index = CollectionWardrobeUtil.GetValidIndexForNumSources(selectedIndex, #sources);
			local _sourceID = sources[index].sourceID;
			
			tipDataAdded[gtt] = "transmogappearance";
			LinkTypeFuncs.transmogappearance(gtt, nil, "transmogappearance", _sourceID);
		end
	end
end

-- HOOK: WardrobeCollectionFrame.SetsTransmogFrame.Models:RefreshTooltip, see WardrobeSetsTransmogModelMixin:RefreshTooltip() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
local function WCFSTFM_RefreshTooltip_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local setID = self.setID;
		if (setID) then
			tipDataAdded[gtt] = "transmogset";
			LinkTypeFuncs.transmogset(gtt, nil, "transmogset", setID);
		end
	end
end

-- HOOK: AchievementFrameMiniAchievement:OnEnter, see AchievementShield_OnEnter() in "Blizzard_AchievementUI/Blizzard_AchievementUI.lua"
local function ABMA_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local parent = self:GetParent(); -- see AchievementObjectives_DisplayProgressiveAchievement() in "Blizzard_AchievementUI/Blizzard_AchievementUI.lua"
		if (parent) then
			local achievementID = parent.id;
			repeat
				local _achievementID, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuild, wasEarnedByMe, earnedBy, isStatistic = GetAchievementInfo(achievementID);
				if (name == self.name) and (description == self.desc) then
					local link = GetAchievementLink(achievementID);
					local refString = link:match("|H([^|]+)|h") or link;
					tipDataAdded[gtt] = "achievement";
					LinkTypeFuncs.achievement(gtt, refString, (":"):split(refString));
					break;
				end
				achievementID = GetPreviousAchievement(achievementID);
			until (not achievementID);
		end
	end
end

-- HOOK: WorldQuestTracker_Tracker:OnEnter, see TrackerFrameOnEnter() in "WorldQuestTracker/WorldQuestTracker_Tracker.lua"
local function WQTT_OnEnter_Hook(self)
	if (cfg.if_enable) and (not tipDataAdded[gtt]) and (gtt:IsShown()) then
		local questID = self.questID;
		if (questID) then
			local link = GetQuestLink(questID);
			if (link) then
				local level = link:match("H?%a+:%d+:(%d+)");
				LinkTypeFuncs.quest(gtt, nil, "quest", questID, level);
			else
				LinkTypeFuncs.quest(gtt, nil, "quest", questID, nil);
			end
			tipDataAdded[gtt] = "quest";
		end
	end
end

-- OnTooltipCleared
local function OnTooltipCleared(self)
	tipDataAdded[self] = nil;
	if (self.ttSetIconTextureAndText) then
		self:ttSetIconTextureAndText();
	end
end

-- HOOK: EmbeddedItemTooltip_Clear
local function EITT_Clear_Hook(self)
	local targetTooltip = self.Tooltip;
	tipDataAdded[targetTooltip] = nil;
end

-- HOOK: BattlePetTooltip:OnHide
local function BPTT_OnHide_Hook(self)
	tipDataAdded[self] = nil;
	if (self.ttSetIconTextureAndText) then
		self:ttSetIconTextureAndText();
	end
end

-- HOOK: FloatingBattlePetTooltip:OnHide
local function FBPTT_OnHide_Hook(self)
	tipDataAdded[self] = nil;
	if (self.ttSetIconTextureAndText) then
		self:ttSetIconTextureAndText();
	end
end

-- HOOK: PetJournalPrimaryAbilityTooltip:OnHide + PetJournalSecondaryAbilityTooltip:OnHide
local function PJATT_OnHide_Hook(self)
	tipDataAdded[self] = nil;
	if (self.ttSetIconTextureAndText) then
		self:ttSetIconTextureAndText();
	end
end

-- HOOK: FloatingPetBattleAbilityTooltip:OnHide
local function FPBATT_OnHide_Hook(self)
	tipDataAdded[self] = nil;
	if (self.ttSetIconTextureAndText) then
		self:ttSetIconTextureAndText();
	end
end

-- HOOK: EncounterJournalTooltip:OnHide
local function EJTT_OnHide_Hook(self)
	tipDataAdded[self] = nil;
	if (self.ttSetIconTextureAndText) then
		self:ttSetIconTextureAndText();
	end
end

-- Function to apply necessary hooks to tips
function ttif:ApplyHooksToTips(tips, resolveGlobalNamedObjects, addToTipsToModify)
	-- Resolve the TipsToModify strings into actual objects
	if (resolveGlobalNamedObjects) then
		ResolveGlobalNamedObjects(tips);
	end
	
	-- apply necessary hooks to tips
	for index, tip in ipairs(tips) do
		if (type(tip) == "table") and (type(tip.GetObjectType) == "function") then
			local tipName = tip:GetName();
			local tipHooked = false;
			
			if (addToTipsToModify) then
				tipsToModify[#tipsToModify + 1] = tip;
			end
			
			if (tip:GetObjectType() == "GameTooltip") then
				hooksecurefunc(tip, "SetHyperlink", function(self, ...)
					ttif:SetHyperlink_Hook(self, ...)
				end);
				hooksecurefunc(tip, "SetUnitAura", SetUnitAura_Hook);
				hooksecurefunc(tip, "SetUnitBuff", SetUnitAura_Hook);
				hooksecurefunc(tip, "SetUnitDebuff", SetUnitAura_Hook);
				hooksecurefunc(tip, "SetAction", SetAction_Hook);
				hooksecurefunc(tip, "SetSpellBookItem", SetSpellBookItem_Hook);
				hooksecurefunc(tip, "SetPetAction", SetPetAction_Hook);
				hooksecurefunc(tip, "SetQuestItem", SetQuestItem_Hook);
				hooksecurefunc(tip, "SetQuestLogItem", SetQuestLogItem_Hook);
				if (isWoWWotlkc) or (isWoWSl) or (isWoWRetail) then
					hooksecurefunc(tip, "SetQuestCurrency", SetQuestCurrency_Hook);
					hooksecurefunc(tip, "SetQuestLogCurrency", SetQuestLogCurrency_Hook);
				end
				if (isWoWSl) or (isWoWRetail) then
					hooksecurefunc(tip, "SetConduit", SetConduit_Hook);
					hooksecurefunc(tip, "SetEnhancedConduit", SetConduit_Hook);
					hooksecurefunc(tip, "SetAzeriteEssence", SetAzeriteEssence_Hook);
					hooksecurefunc(tip, "SetAzeriteEssenceSlot", SetAzeriteEssenceSlot_Hook);
					hooksecurefunc(tip, "SetCurrencyByID", SetCurrencyByID_Hook);
					hooksecurefunc(tip, "SetCurrencyToken", SetCurrencyToken_Hook);
					hooksecurefunc(tip, "SetCurrencyTokenByID", SetCurrencyTokenByID_Hook);
					hooksecurefunc(tip, "SetQuestPartyProgress", SetQuestPartyProgress_Hook);
					hooksecurefunc(tip, "SetCompanionPet", SetCompanionPet_Hook);
					hooksecurefunc(tip, "SetRecipeReagentItem", SetRecipeReagentItem_Hook);
					hooksecurefunc(tip, "SetToyByItemID", SetToyByItemID_Hook);
					hooksecurefunc(tip, "SetLFGDungeonReward", SetLFGDungeonReward_Hook);
					hooksecurefunc(tip, "SetLFGDungeonShortageReward", SetLFGDungeonShortageReward_Hook);
					hooksecurefunc(tip, "SetUnitDebuffByAuraInstanceID", SetUnitXxxxByAuraInstanceID);
					hooksecurefunc(tip, "SetUnitBuffByAuraInstanceID", SetUnitXxxxByAuraInstanceID);
				end
				tip:HookScript("OnTooltipSetItem", OnTooltipSetItem);
				tip:HookScript("OnTooltipSetSpell", OnTooltipSetSpell);
				tip:HookScript("OnTooltipCleared", OnTooltipCleared);
				if (tipName == "GameTooltip") then
					hooksecurefunc(QuestPinMixin, "OnMouseEnter", QPM_OnMouseEnter_Hook);
					hooksecurefunc(StorylineQuestPinMixin, "OnMouseEnter", QPM_OnMouseEnter_Hook);
					hooksecurefunc("GameTooltip_AddQuestRewardsToTooltip", GTT_AddQuestRewardsToTooltip_Hook);
					hooksecurefunc("EmbeddedItemTooltip_SetItemByID", EITT_SetItemByID_Hook);
					hooksecurefunc("EmbeddedItemTooltip_SetItemByQuestReward", EITT_SetItemByQuestReward_Hook);
					hooksecurefunc("EmbeddedItemTooltip_SetSpellByQuestReward", EITT_SetSpellByQuestReward_Hook);
					hooksecurefunc("EmbeddedItemTooltip_SetCurrencyByID", EITT_SetCurrencyByID_Hook);
					hooksecurefunc("EmbeddedItemTooltip_Clear", EITT_Clear_Hook);
					-- classic support
					if (isWoWSl) or (isWoWRetail) then
						hooksecurefunc("QuestMapLogTitleButton_OnEnter", QMLTB_OnEnter_Hook);
						hooksecurefunc("TaskPOI_OnEnter", TPOI_OnEnter_Hook);
						hooksecurefunc(QuestBlobPinMixin, "OnMouseEnter", QBPM_OnMouseEnter_Hook);
						hooksecurefunc("EmbeddedItemTooltip_SetSpellWithTextureByID", EITT_SetSpellWithTextureByID_Hook);
						hooksecurefunc(RuneforgePowerBaseMixin, "OnEnter", RPBM_OnEnter_Hook);
						hooksecurefunc(DressUpOutfitDetailsSlotMixin, "OnEnter", DUODSM_OnEnter_Hook);
					end
				end
				tipHooked = true;
			else
				if (tip:GetObjectType() == "Frame") then
					if (tipName == "BattlePetTooltip") then
						hooksecurefunc("BattlePetToolTip_Show", BPTT_Show_Hook);
						tip:HookScript("OnHide", BPTT_OnHide_Hook);
						tipHooked = true;
					elseif (tipName == "FloatingBattlePetTooltip") then
						hooksecurefunc("FloatingBattlePet_Show", FBP_Show_Hook);
						tip:HookScript("OnHide", FBPTT_OnHide_Hook);
						tipHooked = true;
					elseif (IsAddOnLoaded("Blizzard_Collections")) and ((tipName == "PetJournalPrimaryAbilityTooltip") or (tipName == "PetJournalSecondaryAbilityTooltip")) then
						if (tipName == "PetJournalPrimaryAbilityTooltip") then
							hooksecurefunc("PetJournal_ShowAbilityTooltip", PJ_ShowAbilityTooltip_Hook);
							hooksecurefunc("PetJournal_ShowAbilityCompareTooltip", PJ_ShowAbilityCompareTooltip_Hook);
						end
						tip:HookScript("OnHide", PJATT_OnHide_Hook);
						-- add function Addline() (see BattlePetTooltipTemplate_AddTextLine() in "FloatingPetBattleTooltip.lua")
						tip:HookScript("OnLoad", PJATT_EJTT_OnLoad_Hook);
						tip:HookScript("OnShow", PJATT_EJTT_OnShow_Hook);
						if (tip.strongAgainstTextures) then -- fire OnLoad handler if already loaded
							PJATT_EJTT_OnLoad_Hook(tip);
						end
						tipHooked = true;
					elseif (tipName == "FloatingPetBattleAbilityTooltip") then
						hooksecurefunc("FloatingPetBattleAbility_Show", FPBA_Show_Hook);
						tip:HookScript("OnHide", FPBATT_OnHide_Hook);
						-- add function Addline() (see BattlePetTooltipTemplate_AddTextLine() in "FloatingPetBattleTooltip.lua")
						tip:HookScript("OnLoad", PJATT_EJTT_OnLoad_Hook);
						tip:HookScript("OnShow", PJATT_EJTT_OnShow_Hook);
						if (tip.strongAgainstTextures) then -- fire OnLoad handler if already loaded
							PJATT_EJTT_OnLoad_Hook(tip);
						end
						tipHooked = true;
					elseif (IsAddOnLoaded("Blizzard_EncounterJournal")) and (tipName == "EncounterJournalTooltip") then
						hooksecurefunc("AdventureJournal_Reward_OnEnter", AJR_OnEnter_Hook);
						tip:HookScript("OnHide", EJTT_OnHide_Hook);
						-- add function Addline() (see BattlePetTooltipTemplate_AddTextLine() in "FloatingPetBattleTooltip.lua")
						tip:HookScript("OnLoad", PJATT_EJTT_OnLoad_Hook);
						tip:HookScript("OnShow", PJATT_EJTT_OnShow_Hook);
						if (tip.headerText) then -- fire OnLoad handler if already loaded
							PJATT_EJTT_OnLoad_Hook(tip);
						end
						-- tipHooked = true;
					end
				end
			end
			
			if (tipHooked) then
				if (tipsToAddIcon[tipName]) then
					self:CreateTooltipIcon(tip);
				end
			end
		end
	end
end

-- Function to apply necessary hooks to CommunitiesFrameGuildDetailsFrameInfo
local CFGDFIChooked = {};

function ttif:ApplyHooksToCFGDFI()
	local numChallenges = GetNumGuildChallenges(); -- see CommunitiesGuildInfoFrame_UpdateChallenges() in "Blizzard_Communities/GuildInfo.lua"
	for i = 1, numChallenges do
		local frame = CommunitiesFrameGuildDetailsFrameInfo.Challenges[i];
		if (frame) and (not CFGDFIChooked[frame]) then
			frame:HookScript("OnEnter", GIFC_OnEnter_Hook);
			CFGDFIChooked[frame] = true;
		end
	end
end

-- Function to apply necessary hooks to GuildInfoFrameInfoChallenge
local GIFIChooked = {};

function ttif:ApplyHooksToGIFIC()
	local numChallenges = GetNumGuildChallenges(); -- see GuildInfoFrame_UpdateChallenges() in "Blizzard_GuildUI/Blizzard_GuildInfo.lua"
	for i = 1, numChallenges do
		local index, current, max = GetGuildChallengeInfo(i);
		local frame = _G["GuildInfoFrameInfoChallenge"..index];
		if (frame) and (not GIFIChooked[frame]) then
			frame:HookScript("OnEnter", GIFC_OnEnter_Hook);
			GIFIChooked[frame] = true;
		end
	end
end

-- Apply hooks for all the tooltips to modify during VARIABLES_LOADED -- Only hook GameTooltip objects
function ttif:HookTips()
	self:ApplyHooksToTips(tipsToModify, true);
end

-- AddOn Loaded
function ttif:ADDON_LOADED(event, addOnName)
	if (not cfg) then return end;
	
	-- check if addon is already loaded
	if (addOnsLoaded[addOnName] == nil) or (addOnsLoaded[addOnName]) then
		return;
	end
	
	-- now AchievementFrameMiniAchievement exists
	if (addOnName == "Blizzard_AchievementUI") or ((addOnName == "TipTacItemRef") and (IsAddOnLoaded("Blizzard_AchievementUI")) and (not addOnsLoaded['Blizzard_AchievementUI'])) then
		if (isWoWSl) then -- df todo: function AchievementButton_GetMiniAchievement() doesn't exist in df.
			local ABMAhooked = {}; -- see AchievementButton_GetMiniAchievement() in "Blizzard_AchievementUI/Blizzard_AchievementUI.lua"
			
			hooksecurefunc("AchievementButton_GetMiniAchievement", function(index)
				local frame = _G["AchievementFrameMiniAchievement"..index];
				if (frame) and (not ABMAhooked[frame]) then
					frame:HookScript("OnEnter", ABMA_OnEnter_Hook);
					ABMAhooked[frame] = true;
				end
			end);
		end
		
		if (addOnName == "TipTac") then
			addOnsLoaded["Blizzard_AchievementUI"] = true;
		end
	end
	-- now PetJournalPrimaryAbilityTooltip and PetJournalSecondaryAbilityTooltip exist
	if (addOnName == "Blizzard_Collections") or ((addOnName == "TipTacItemRef") and (IsAddOnLoaded("Blizzard_Collections")) and (not addOnsLoaded['Blizzard_Collections'])) then
		pjpatt = PetJournalPrimaryAbilityTooltip;
		pjsatt = PetJournalSecondaryAbilityTooltip;
		
		-- Hook Tips & Apply Settings
		self:ApplyHooksToTips({
			"PetJournalPrimaryAbilityTooltip",
			"PetJournalSecondaryAbilityTooltip"
		}, true, true);

		self:OnApplyConfig();
		
		-- Function to apply necessary hooks to WardrobeCollectionFrame.ItemsCollectionFrame, see WardrobeItemsCollectionMixin:UpdateItems() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
		hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame, "RefreshAppearanceTooltip", WCFICF_RefreshAppearanceTooltip_Hook); -- for items (incl. reapply for tabbing through items with same visualID)

		local itemsCollectionFrame = WardrobeCollectionFrame.ItemsCollectionFrame; -- for illusions
		for i = 1, itemsCollectionFrame.PAGE_SIZE do
			local model = itemsCollectionFrame.Models[i];
			model:HookScript("OnEnter", WCFICFM_OnEnter_Hook);
		end

		hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame, "UpdateItems", function(self) -- reapply if selecting or scrolling
			if (gtt:IsShown()) then
				local itemsCollectionFrame = self;
				for i = 1, itemsCollectionFrame.PAGE_SIZE do
					local model = itemsCollectionFrame.Models[i];
					local gttOwner = gtt:GetOwner();
					
					if (gttOwner == model) then
						WCFICFM_OnEnter_Hook(gttOwner);
						break;
					end
				end
			end
		end);
		
		-- Function to apply necessary hooks to WardrobeCollectionFrame.SetsCollectionFrame
		hooksecurefunc(WardrobeCollectionFrame.SetsCollectionFrame, "RefreshAppearanceTooltip", WCFSCF_RefreshAppearanceTooltip_Hook); -- for sets (incl. reapply for tabbing through items with same visualID)

		-- Function to apply necessary hooks to WardrobeCollectionFrame.SetsTransmogFrame, see WardrobeSetsTransmogMixin:UpdateSets() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
		local setsTransmogFrame = WardrobeCollectionFrame.SetsTransmogFrame; -- for sets at transmogrifier
		for i = 1, setsTransmogFrame.PAGE_SIZE do
			local model = setsTransmogFrame.Models[i];
			hooksecurefunc(model, "RefreshTooltip", WCFSTFM_RefreshTooltip_Hook);
		end
		
		if (addOnName == "TipTac") then
			addOnsLoaded["Blizzard_Collections"] = true;
		end
	end
	-- now CommunitiesGuildNewsFrame exists
	if (addOnName == "Blizzard_Communities") or ((addOnName == "TipTacItemRef") and (IsAddOnLoaded("Blizzard_Communities")) and (not addOnsLoaded['Blizzard_Communities'])) then
		hooksecurefunc("CommunitiesGuildNewsButton_OnEnter", GNB_OnEnter_Hook);

		-- Function to apply necessary hooks to CommunitiesFrameGuildDetailsFrameInfo
		ttif:ApplyHooksToCFGDFI();
		
		hooksecurefunc("CommunitiesGuildInfoFrame_UpdateChallenges", function()
			ttif:ApplyHooksToCFGDFI();
		end);
		
		if (addOnName == "TipTac") then
			addOnsLoaded["Blizzard_Communities"] = true;
		end
	end
	-- now EncounterJournalTooltip exists
	if (addOnName == "Blizzard_EncounterJournal") or ((addOnName == "TipTacItemRef") and (IsAddOnLoaded("Blizzard_EncounterJournal")) and (not addOnsLoaded['Blizzard_EncounterJournal'])) then
		ejtt = EncounterJournalTooltip;
		
		-- Hook Tips & Apply Settings
		-- commented out for embedded tooltips, see description in tt:SetPadding()
		-- self:ApplyHooksToTips({
			-- "EncounterJournalTooltip"
		-- }, true, true);

		-- self:OnApplyConfig();
		
		if (addOnName == "TipTac") then
			addOnsLoaded["Blizzard_EncounterJournal"] = true;
		end
	end
	-- now GuildNewsButton exists
	if (addOnName == "Blizzard_GuildUI") or ((addOnName == "TipTacItemRef") and (IsAddOnLoaded("Blizzard_GuildUI")) and (not addOnsLoaded['Blizzard_GuildUI'])) then
		hooksecurefunc("GuildNewsButton_OnEnter", GNB_OnEnter_Hook);
		
		-- Function to apply necessary hooks to GuildInfoFrameInfoChallenge
		ttif:ApplyHooksToGIFIC();
		
		hooksecurefunc("GuildInfoFrame_UpdateChallenges", function()
			ttif:ApplyHooksToGIFIC();
		end);
		
		if (addOnName == "TipTac") then
			addOnsLoaded["Blizzard_GuildUI"] = true;
		end
	end
	-- now PlayerChoiceTorghastOption exists
	if (addOnName == "Blizzard_PlayerChoice") or ((addOnName == "TipTacItemRef") and (IsAddOnLoaded("Blizzard_PlayerChoice")) and (not addOnsLoaded['Blizzard_PlayerChoice'])) then
		hooksecurefunc(PlayerChoicePowerChoiceTemplateMixin, "OnEnter", PCPCTM_OnEnter_Hook);
		
		if (addOnName == "TipTac") then
			addOnsLoaded["Blizzard_PlayerChoice"] = true;
		end
	end
	-- now PVPRewardTemplate exists
	if (addOnName == "Blizzard_PVPUI") or ((addOnName == "TipTacItemRef") and (IsAddOnLoaded("Blizzard_PVPUI")) and (not addOnsLoaded['Blizzard_PVPUI'])) then
		-- Function to apply necessary hooks to PVPRewardTemplate, see HonorFrameBonusFrame_Update() in "Blizzard_PVPUI/Blizzard_PVPUI.lua"
		local buttons = {
			HonorFrame.BonusFrame.RandomBGButton,
			HonorFrame.BonusFrame.Arena1Button,
			HonorFrame.BonusFrame.RandomEpicBGButton,
			HonorFrame.BonusFrame.BrawlButton,
			HonorFrame.BonusFrame.BrawlButton2
		};
		
		for i, button in pairs(buttons) do
			button.Reward.EnlistmentBonus:HookScript("OnEnter", HFBFB_OnEnter);
		end
		
		if (addOnName == "TipTac") then
			addOnsLoaded["Blizzard_PVPUI"] = true;
		end
	end
	-- now WorldQuestTrackerAddon exists
	if (addOnName == "WorldQuestTracker") or ((addOnName == "TipTacItemRef") and (IsAddOnLoaded("WorldQuestTracker")) and (not addOnsLoaded['WorldQuestTracker'])) then
		local WQTThooked = {}; -- see WorldQuestTracker.GetOrCreateTrackerWidget() in "WorldQuestTracker/WorldQuestTracker_Tracker.lua"
		
		hooksecurefunc(WorldQuestTrackerAddon, "GetOrCreateTrackerWidget", function(index)
			local frame = _G["WorldQuestTracker_Tracker" .. index];
			if (frame) and (not WQTThooked[frame]) then
				frame:HookScript("OnEnter", WQTT_OnEnter_Hook);
				WQTThooked[frame] = true;
			end
		end);
		
		if (addOnName == "TipTac") then
			addOnsLoaded["WorldQuestTracker"] = true;
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
--                                        Smart Icon Evaluation                                       --
--------------------------------------------------------------------------------------------------------

-- returns true if an icon should be displayed
local function SmartIconEvaluation(tip,linkType)
	if (tip == bptt or tip == fbptt) then -- BattlePetTooltip and FloatingBattlePetTooltip
		return true;
	end

	if (linkType == "battlePetAbil") then
		if (tip.anchoredTo and tip.anchoredTo.icon) then
			return false;
		end
		return true;
	end
	
	if (tip == ejtt) then -- EncounterJournalTooltip
		return false;
	end
	
	local owner = tip:GetOwner();

	-- No Owner?
	if (not owner) then
		return false;
	-- Item
	elseif (linkType == "item") then
		if (owner.hasItem or owner.action or owner.icon or owner.Icon or owner.texture or owner.lootFrame or owner.ItemIcon or owner.iconTexture) then
			return false;
		end
	-- Spell
	elseif (linkType == "spell") then
		if (owner.action or owner.texture or owner.icon or owner.Icon or -- mount tooltip in action bar
				(owner.unit and owner.count and owner.filter)) then -- classic: aura
			return false;
		end
		local ownerParent = owner:GetParent();
		if (ownerParent) then
			if (owner.unit and ownerParent.buffs) then -- classic: aura under frame
				return false;
			end
			if (owner.ActiveTexture and ownerParent.icon) then -- mount tooltip in mount journal list
				return false;
			end
			if (ownerParent.Artwork) then -- player choice torghast option
				return false;
			end
		end
	-- Achievement
--	elseif (linkType == "achievement") then
--		if (owner.icon) then
--			return false;
--		end
	-- Battle pet
	elseif (linkType == "battlepet") then
		if (owner.action or owner.icon) then -- pet tooltip in action bar
			return false;
		end
		local ownerParent = owner:GetParent(); -- pet tooltip in pet journal list
		if (ownerParent and ownerParent.petTypeIcon and ownerParent.icon) then
			return false;
		end
	-- Runeforge power
	elseif (linkType == "runeforgePower") then
		if (owner.Icon) then
			return false;
		end
	-- Transmog illusion
	elseif (linkType == "transmogillusion") then
		if (owner.Icon) then
			return false;
		end
	-- Conduit
	elseif (linkType == "conduit") then
		if (owner.Icon) then
			return false;
		end
		local ownerParent = owner:GetParent();
		if (ownerParent and ownerParent.Icon) then
			return false;
		end
	-- Flyout
	elseif (linkType == "flyout") then
		if (owner.icon) then
			return false;
		end
	-- Pet action
	elseif (linkType == "petAction") then
		if (owner.icon) then
			return false;
		end
	-- Azerite essence
	elseif (linkType == "azessence") then
		if (owner.Icon) then
			return false;
		end
	end

	-- IconTexture sub texture
	local ownerName = owner:GetName();
	if (ownerName) then
		if (_G[ownerName.."IconTexture"]) or (ownerName:match("SendMailAttachment(%d+)")) then
			return false;
		end
	end

	-- If we passed all checks, return true to show an icon
	return true;
end

--------------------------------------------------------------------------------------------------------
--                                       Tip LinkType Functions                                       --
--------------------------------------------------------------------------------------------------------

-- Sets backdrop border color
function ttif:SetBackdropBorderColorLocked(tip, lockColor, r, g, b, a)
	if (not lockColor) and (tip.ttBackdropBorderColorApplied) then
		return;
	end
	
	tip.ttSetBackdropBorderColorLocked = false;
	tip:SetBackdropBorderColor(r, g, b, (a or 1) * ((cfg.tipBorderColor and cfg.tipBorderColor[4]) or 1));
	tip.ttSetBackdropBorderColorLocked = true;
	
	if (lockColor) then
		tip.ttBackdropBorderColorApplied = true;
	end
end

-- instancelock
function LinkTypeFuncs:instancelock(link,linkType,guid,mapId,difficulty,encounterBits)
	--AzDump(guid,mapId,difficulty,encounterBits)
  	-- TipType Border Color -- Disable these 3 lines to color border. Az: Work into options?
--	if (cfg.if_itemQualityBorder) then
--      ttif:SetBackdropBorderColorLocked(self, true, 1, .5, 0, 1);
--	end
end

-- item
function LinkTypeFuncs:item(link, linkType, id)
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(link);
	if (classID == 5) and (subClassID == 1) then -- keystone
		local splits = StringSplitIntoTable(":", link);
		local mapID = splits[17];
		local keystoneLevel = splits[19];
		LinkTypeFuncs.keystone(self, link, linkType, id, mapID, keystoneLevel, select(21, unpack(splits))); -- modifierID1, modifierID2, modifierID3, modifierID4
		return;
	end
    if U1GetRealItemLevel then
        itemLevel = U1GetRealItemLevel(link)
    else
	local trueItemLevel = LibItemString:GetTrueItemLevel(link);
	if (trueItemLevel) then
		itemLevel = trueItemLevel;
	end
    end

	-- Icon
	if (not self.IsEmbedded) and (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self,linkType)) then
		local count = (itemStackCount and itemStackCount > 1 and (itemStackCount == 0x7FFFFFFF and "#" or itemStackCount) or "");
		self:ttSetIconTextureAndText(itemTexture, count);
	end

	-- Quality Border
	if (not self.IsEmbedded) and (cfg.if_itemQualityBorder) then
		local itemQualityColor = CreateColorFromHexString(select(4, GetItemQualityColor(itemRarity or 0)));
		ttif:SetBackdropBorderColorLocked(self, true, itemQualityColor:GetRGBA());
	end

	-- level + id -- Only alter the tip if we got either a valid "itemLevel" or "id"
	local showLevel = (itemLevel and cfg.if_showItemLevel);
	local showId = (id and cfg.if_showItemId);
	local linePadding = 2;

	if (showLevel or showId) then
		local targetTooltip = self;
		if (showLevel) then
			if (self == ejtt) then
				targetTooltip = self.Item1.tooltip;
				if (targetTooltip:IsShown()) then
					-- remove level from embedded tip
					for i = 2, min(targetTooltip:NumLines(), LibItemString.TOOLTIP_MAXLINE_LEVEL) do
						local line = _G[targetTooltip:GetName().."TextLeft"..i];
						if (line and (line:GetText() or ""):match(ITEM_LEVEL_PLUS)) then
							line:SetText(nil);
							break;
						end
					end
				else 
					-- remove level from tip's line pool
					for line in self.linePool:EnumerateActive() do
						if (line and (line:GetText() or ""):match(ITEM_LEVEL_PLUS)) then
							local linePredecessorPoint, linePredecessorRelativeTo, linePredecessorRelativePoint, linePredecessorXOfs, linePredecessorYOfs = line:GetPoint(1);
							
							if (line == self.textLineAnchor) then
								-- last line in line pool
								self.textLineAnchor = linePredecessorRelativeTo;
							else
								-- re-anchor successor line
								for successorLine in self.linePool:EnumerateActive() do
									local successorLinePredecessorPoint, successorLinePredecessorRelativeTo, successorLinePredecessorRelativePoint, successorLinePredecessorXOfs, successorLinePredecessorYOfs = successorLine:GetPoint(1);
									
									if (successorLinePredecessorRelativeTo == line) then
										local successorLineNumPoints = successorLine:GetNumPoints();
										local successorLineLeftPoint, successorLineLeftRelativeTo, successorLineLeftRelativePoint, successorLineLeftXOfs, successorLineLeftYOfs = successorLine:GetPoint(2);
										local successorLineRightPoint, successorLineRightRelativeTo, successorLineRightRelativePoint, successorLineRightXOfs, successorLineRightYOfs;
										if (successorLineNumPoints > 2) then
											successorLineRightPoint, successorLineRightRelativeTo, successorLineRightRelativePoint, successorLineRightXOfs, successorLineRightYOfs = successorLine:GetPoint(3);
										end
										successorLinePredecessorRelativeTo = linePredecessorRelativeTo;
										
										successorLine:ClearAllPoints();
										successorLine:SetPoint(successorLinePredecessorPoint, successorLinePredecessorRelativeTo, successorLinePredecessorRelativePoint, successorLinePredecessorXOfs, successorLinePredecessorYOfs);
										successorLine:SetPoint(successorLineLeftPoint, successorLineLeftRelativeTo, successorLineLeftRelativePoint, successorLineLeftXOfs, successorLineLeftYOfs);
										if (successorLineNumPoints > 2) then
											successorLine:SetPoint(successorLineRightPoint, successorLineRightRelativeTo, successorLineRightRelativePoint, successorLineRightXOfs, successorLineRightYOfs);
										end
										break;
									end
								end
							end
							
							-- remove level from tip's line pool
							self:SetHeight(self:GetHeight() - line:GetHeight() - linePadding);
							line:ClearAllPoints();
							self.linePool:Release(line);
							
							break;
						end
					end
				end
			else
				for i = 2, min(self:NumLines(),LibItemString.TOOLTIP_MAXLINE_LEVEL) do
					local line = _G[self:GetName().."TextLeft"..i];
					if (line and (line:GetText() or ""):match(ITEM_LEVEL_PLUS)) then
						line:SetText(nil);
						break;
					end
				end
			end
		end

		if (not showLevel) then
            -- StackSize
            local count = (itemStackCount and itemStackCount > 1 and (itemStackCount == 0x7FFFFFFF and "#" or itemStackCount) or "");
            if count ~= "" then
                local r,g,b = unpack(cfg.if_infoColor)
                targetTooltip:AddDoubleLine(format(L"ItemID: %d",id),format(L"Stack: %d",count),r,g,b,r,g,b);
            else
			targetTooltip:AddLine(format(L"ItemID: %d",id),unpack(cfg.if_infoColor));
            end
		elseif (showId) then
			targetTooltip:AddLine(format(L"ItemLevel: %d, ItemID: %d",itemLevel,id),unpack(cfg.if_infoColor));
		else
			targetTooltip:AddLine(format(L"ItemLevel: %d",itemLevel),unpack(cfg.if_infoColor));
		end
		targetTooltip:Show();	-- call Show() to resize tip after adding lines. only necessary for items in toy box.
	end
end

-- keystone
local getRewardLevelInitialized = false;

function LinkTypeFuncs:keystone(link, linkType, itemID, mapID, keystoneLevel, ...) -- modifierID1, modifierID2, modifierID3, modifierID4
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(itemID);
	local trueItemLevel = LibItemString:GetTrueItemLevel(link);
	if (trueItemLevel) then
		itemLevel = trueItemLevel;
	end

	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self,linkType)) then
		local count = (itemStackCount and itemStackCount > 1 and (itemStackCount == 0x7FFFFFFF and "#" or itemStackCount) or "");
		self:ttSetIconTextureAndText(itemTexture, count);
	end

	-- Quality Border
	if (cfg.if_itemQualityBorder) then
		local itemQualityColor = CreateColorFromHexString(select(4, GetItemQualityColor(itemRarity or 0)));
		ttif:SetBackdropBorderColorLocked(self, true, itemQualityColor:GetRGBA());
	end

	-- RewardLevel + WeeklyRewardLevel + ItemID + TimeLimit + AffixInfos
	if (not getRewardLevelInitialized) then -- makes shure that C_MythicPlus.GetRewardLevelForDifficultyLevel() returns values
		C_MythicPlus.RequestMapInfo();
		getRewardLevelInitialized = true;
	end
	local weeklyRewardLevel, endOfRunRewardLevel = nil, nil;
	if (keystoneLevel) then
		weeklyRewardLevel, endOfRunRewardLevel = C_MythicPlus.GetRewardLevelForDifficultyLevel(keystoneLevel);
	end

	local showId = (itemID and cfg.if_showItemId);
	local showRewardLevel = (endOfRunRewardLevel and cfg.if_showKeystoneRewardLevel);
	local showWeeklyRewardLevel = (weeklyRewardLevel and cfg.if_showKeystoneRewardLevel);
	local showTimeLimit = (mapID and cfg.if_showKeystoneTimeLimit);
	local showAffixInfo = cfg.if_showKeystoneAffixInfo;
	
	if (showId or showRewardLevel or showWeeklyRewardLevel or showTimeLimit or showAffixInfo) then
		local tipName = self:GetName();
		local infoColorMixin = CreateColor(cfg.if_infoColor[1], cfg.if_infoColor[2], cfg.if_infoColor[3], (cfg.if_infoColor[4] or 1));

		if (showId) then
			self:AddLine(format("ItemID: %d", itemID), unpack(cfg.if_infoColor));
		end
		
		if (cfg.if_modifyKeystoneTips) then
			local textRight2 = _G[tipName.."TextRight2"];
			if (not showRewardLevel and showWeeklyRewardLevel) then
				textRight2:SetText(infoColorMixin:WrapTextInColorCode(format("WRL: %d", weeklyRewardLevel)));
			elseif (showRewardLevel and showWeeklyRewardLevel) then
				textRight2:SetText(infoColorMixin:WrapTextInColorCode(format("RL: %d, WRL: %d", endOfRunRewardLevel, weeklyRewardLevel)));
			elseif (showRewardLevel and not showWeeklyRewardLevel) then
				textRight2:SetText(infoColorMixin:WrapTextInColorCode(format("RL: %d", endOfRunRewardLevel)));
			end
			textRight2:Show();
		else
			if (not showRewardLevel and showWeeklyRewardLevel) then
				self:AddLine(format("WeeklyRewardLevel: %d", weeklyRewardLevel), unpack(cfg.if_infoColor));
			elseif (showRewardLevel and showWeeklyRewardLevel) then
				self:AddLine(format("RewardLevel: %d, WeeklyRewardLevel: %d", endOfRunRewardLevel, weeklyRewardLevel), unpack(cfg.if_infoColor));
			elseif (showRewardLevel and not showWeeklyRewardLevel) then
				self:AddLine(format("RewardLevel: %d", endOfRunRewardLevel), unpack(cfg.if_infoColor));
			end
		end
		
		if (showTimeLimit) then
			local name, id, timeLimit, texture, backgroundTexture = C_ChallengeMode.GetMapUIInfo(mapID);
			if (timeLimit) then
				if (cfg.if_modifyKeystoneTips) then
					local textRight1 = _G[tipName.."TextRight1"];
					textRight1:SetText(infoColorMixin:WrapTextInColorCode(format("TL: %s", SecondsToTime(timeLimit, false, false))));
					textRight1:Show();
				else
					self:AddLine(format("TimeLimit: %s", SecondsToTime(timeLimit, false, true)), unpack(cfg.if_infoColor));
				end
			end
		end
		
		if (showAffixInfo) then
			for i = 1, select('#', ...) do
				local modifierID = select(i, ...);
				modifierID = tonumber(modifierID);
				if (modifierID) then
					local modifierName, modifierDescription, fileDataID = C_ChallengeMode.GetAffixInfo(modifierID);
					if (modifierName and modifierDescription) then
						self:AddLine(format("%s %s\n%s", CreateTextureMarkup(fileDataID, 64, 64, 0, 0, 0.07, 0.93, 0.07, 0.93), GREEN_FONT_COLOR:WrapTextInColorCode(modifierName), modifierDescription), cfg.if_infoColor[1], cfg.if_infoColor[2], cfg.if_infoColor[3], true);
					end
				end
			end
		end
		
		self:Show();	-- call Show() to resize tip after adding lines
	end
end

--abyui 施法者的职业颜色，修复Debuff的问题，AddDoubleLine方式
local function GetUnitColorText(unit)
	local ClassColor = RAID_CLASS_COLORS[select(2,UnitClass(unit))] or NORMAL_FONT_COLOR;
	if (not UnitIsPlayer(unit)) then ClassColor = NORMAL_FONT_COLOR end;
	return format("|cFF%s%s|r",format("%02X%02X%02X",ClassColor.r*255,ClassColor.g*255,ClassColor.b*255),UnitName(unit));
end

local function GetCasterColorAndName(unit)
	local PartyUnitID = unit:match("^party(%d+)$");
	local RaidUnitID = unit:match("^raid(%d+)$");
	local PartyPetID = unit:match("^partypet(%d+)$");
	local RaidPetID = unit:match("^raidpet(%d+)$");
	local text = GetUnitColorText(unit);
	if unit == "vehicle" then
		text = text..format("(%s)", GetUnitColorText("player"));
	elseif unit == "target" then
		text = text..format("(%s)", L["|cFFFFFFFFTarget|r"]);
	elseif PartyUnitID then
		text = text..format("(%s)", L["|cFFFFFFFFYour Group|r"]);
	elseif RaidUnitID then
		text = text..format(L["(Group %s)"], "|cFFFFFFFF"..select(3,GetRaidRosterInfo(RaidUnitID)).."|r");
	elseif PartyPetID then
		text = text..format("(%s:%s)", L["|cFFFFFFFFYour Group|r"], GetUnitColorText("party"..PartyPetID));
	elseif RaidPetID then
		text = text..format(L["(Group %s:%s)"], "|cFFFFFFFF"..select(3,GetRaidRosterInfo(RaidPetID)).."|r", GetUnitColorText("raid"..RaidPetID));
	end
	return text;
end

-- spell
function LinkTypeFuncs:spell(isAura, source, link, linkType, spellID)
	local name, _, icon, castTime, minRange, maxRange, _spellID = GetSpellInfo(spellID);	-- [18.07.19] 8.0/BfA: 2nd param "rank/nameSubtext" now returns nil
	local rank = GetSpellSubtext(spellID);	-- will return nil at first unless its locally cached
	rank = (rank and rank ~= "" and ", "..rank or "");

	local mawPowerID = nil;
	if (isWoWSl) or (isWoWRetail) then
		local linkMawPower = GetMawPowerLinkBySpellID(spellID);
		if (linkMawPower) then
			local _linkType, _mawPowerID = linkMawPower:match("H?(%a+):(%d+)");
			mawPowerID = _mawPowerID;
			if (not table_MawPower_by_MawPowerID[mawPowerID]) then -- possible internal blizzard bug: GetMawPowerLinkBySpellID() e.g. returns mawPowerID 1453 for battle shout with spellID 6673, which doesn't exist in table MawPower (from https://wow.tools/dbc/?dbc=mawpower)
				mawPowerID = nil;
			end
		end
	end
	
	local isSpell = (not isAura);

	-- Icon
	if (not self.IsEmbedded) and (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self,linkType)) then
		self:ttSetIconTextureAndText(icon);
	end
	
	-- Caster
	local showAuraCaster = (cfg.if_showAuraCaster and UnitExists(source));
    local auraLine, spellLine --abyui
	if (showAuraCaster) then
        auraLine = format(L"Caster: %s", GetCasterColorAndName(source) or UNKNOWNOBJECT);
	end
	
	-- MawPowerID and SpellID + Rank -- pre-16.08.25 only caster was formatted as this: "<Applied by %s>"
	local showMawPowerID = (cfg.if_showMawPowerId and mawPowerID);
	local showSpellIdAndRank = (((isSpell and cfg.if_showSpellIdAndRank) or (isAura and cfg.if_showAuraSpellIdAndRank)) and spellID and (spellID ~= 0));
	if (showMawPowerID or showSpellIdAndRank) then
		if (not showMawPowerID or showAuraCaster) then
            if auraLine then
                local r,g,b = unpack(cfg.if_infoColor)
                self:AddDoubleLine(auraLine, format(L"SpellID: %d", spellID)..rank,r,g,b,r,g,b)
            else
			self:AddLine(format(L"SpellID: %d", spellID)..rank, unpack(cfg.if_infoColor));
            end
		elseif (showSpellIdAndRank) then
			self:AddLine(format(L"MawPowerID: %d, SpellID: %d", mawPowerID, spellID)..rank, unpack(cfg.if_infoColor));
		else
			self:AddLine(format(L"MawPowerID: %d", mawPowerID), unpack(cfg.if_infoColor));
		end
	end

	if (showAuraCaster or showMawPowerID or showSpellIdAndRank) then
		self:Show();	-- call Show() to resize tip after adding lines
	end

  	-- Colored Border
	if (not self.IsEmbedded) and ((isSpell and cfg.if_spellColoredBorder) or (isAura and cfg.if_auraSpellColoredBorder)) then
		local spellColor = nil;
		
		if (mawPowerID and spellID) then
			local rarityAtlas = C_Spell.GetMawPowerBorderAtlasBySpellID(spellID);
			if (rarityAtlas) then
				local rarityAtlasColors = { -- see table UiTextureAtlasElement name "jailerstower-animapowerlist-powerborder*"
					["jailerstower-animapowerlist-powerborder-white"] = ITEM_QUALITY_COLORS[Enum.ItemQuality.Common],
					["jailerstower-animapowerlist-powerborder-green"] = ITEM_QUALITY_COLORS[Enum.ItemQuality.Uncommon],
					["jailerstower-animapowerlist-powerborder-blue"] = ITEM_QUALITY_COLORS[Enum.ItemQuality.Rare],
					["jailerstower-animapowerlist-powerborder-purple"] = ITEM_QUALITY_COLORS[Enum.ItemQuality.Epic]
				};
				if (rarityAtlasColors[rarityAtlas]) then
					spellColor = rarityAtlasColors[rarityAtlas].color;
				end
			end
		end
		
		if (not spellColor) then
			spellColor = CreateColorFromHexString("FF71D5FF"); -- see GetSpellLink(). extraction of color code from this function not used, because in classic it only returns the spell name instead of a link.
		end
		
		ttif:SetBackdropBorderColorLocked(self, true, spellColor:GetRGBA());
	end
end

-- maw power
function LinkTypeFuncs:mawpower(link, linkType, mawPowerID)
	local spellID = nil;
	if (mawPowerID and table_MawPower_by_MawPowerID[mawPowerID]) then
		spellID = table_MawPower_by_MawPowerID[mawPowerID].spellID;
	end
	
	local name, _, icon, castTime, minRange, maxRange, _spellID = GetSpellInfo(spellID);	-- [18.07.19] 8.0/BfA: 2nd param "rank/nameSubtext" now returns nil
	local rank = GetSpellSubtext(spellID);	-- will return nil at first unless its locally cached
	rank = (rank and rank ~= "" and ", "..rank or "");

	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self,linkType)) then
		self:ttSetIconTextureAndText(icon);
	end
	
	-- MawPowerID and SpellID + Rank -- pre-16.08.25 only caster was formatted as this: "<Applied by %s>"
	local showMawPowerID = (cfg.if_showMawPowerId and mawPowerID and (mawPowerID ~= 0));
	local showSpellIdAndRank = (cfg.if_showSpellIdAndRank and spellID);
	if (showMawPowerID or showSpellIdAndRank) then
		if (not showMawPowerID) then
			self:AddLine(format("SpellID: %d", spellID)..rank, unpack(cfg.if_infoColor));
		elseif (showSpellIdAndRank) then
			self:AddLine(format("MawPowerID: %d, SpellID: %d", mawPowerID, spellID)..rank, unpack(cfg.if_infoColor));
		else
			self:AddLine(format("MawPowerID: %d", mawPowerID), unpack(cfg.if_infoColor));
		end
		-- self:Show();	-- call Show() to resize tip after adding lines
	end

  	-- Colored Border
	if (cfg.if_spellColoredBorder) then
		local spellColor = nil;
		
		if (mawPowerID and spellID) then
			local rarityAtlas = C_Spell.GetMawPowerBorderAtlasBySpellID(spellID);
			if (rarityAtlas) then
				if (rarityAtlas == "jailerstower-animapowerlist-powerborder-white") then -- see table UiTextureAtlasElement name "jailerstower-animapowerlist-powerborder*"
					spellColor = CreateColorFromHexString(select(4, GetItemQualityColor(1)));
				elseif (rarityAtlas == "jailerstower-animapowerlist-powerborder-green") then
					spellColor = CreateColorFromHexString(select(4, GetItemQualityColor(2)));
				elseif (rarityAtlas == "jailerstower-animapowerlist-powerborder-blue") then
					spellColor = CreateColorFromHexString(select(4, GetItemQualityColor(3)));
				elseif (rarityAtlas == "jailerstower-animapowerlist-powerborder-purple") then
					spellColor = CreateColorFromHexString(select(4, GetItemQualityColor(4)));
				end
			end
		end
		
		if (not spellColor) then
			spellColor = CreateColorFromHexString("FF71D5FF"); -- see GetSpellLink(). extraction of color code from this function not used, because in classic it only returns the spell name instead of a link.
		end
		
		ttif:SetBackdropBorderColorLocked(self, true, spellColor:GetRGBA());
	end
end

-- quest
function LinkTypeFuncs:quest(link, linkType, questID, level)
	-- QuestLevel + QuestID
	local showLevel = (level and cfg.if_showQuestLevel);
	local showId = (questID and cfg.if_showQuestId);

	if (showLevel or showId) then
		if (not showLevel) then
			self:AddLine(format(L"QuestID: %d", questID or 0), unpack(cfg.if_infoColor));
		elseif (showId) then
			self:AddLine(format(L"QuestLevel: %d, QuestID: %d", level or 0, questID or 0), unpack(cfg.if_infoColor));
		else
			self:AddLine(format(L"QuestLevel: %d", level or 0), unpack(cfg.if_infoColor));
		end
		self:Show();	-- call Show() to resize tip after adding lines
	end
	
  	-- Difficulty Border
	if (cfg.if_questDifficultyBorder) then
		local difficultyColorMixin;
		
		if (C_QuestLog.IsWorldQuest and C_QuestLog.IsWorldQuest(questID)) then -- see GameTooltip_AddQuest
			local tagInfo = C_QuestLog.GetQuestTagInfo(questID);
			local quality = tagInfo and tagInfo.quality or Enum.WorldQuestQuality.Common;
			difficultyColorMixin = WORLD_QUEST_QUALITY_COLORS[quality].color;
		else
			local difficultyColor = GetDifficultyColor and GetDifficultyColor(C_PlayerInfo.GetContentDifficultyQuestForPlayer(questID)) or GetQuestDifficultyColor(level);
			difficultyColorMixin = CreateColor(difficultyColor.r, difficultyColor.g, difficultyColor.b, 1);
		end
		
		ttif:SetBackdropBorderColorLocked(self, true, difficultyColorMixin:GetRGBA());
	end
end

-- currency -- Thanks to Vladinator for adding this!
function LinkTypeFuncs:currency(link, linkType, currencyID, quantity)
	local _quantity = (quantity or 0); -- mouseover over sightless eye currency link of missing recipes of broken isles (legion) returns nil
	local currencyInfo = nil;
	local icon, quality;
	local isCurrencyContainer = C_CurrencyInfo.IsCurrencyContainer and C_CurrencyInfo.IsCurrencyContainer(currencyID, _quantity);
	
	if (isCurrencyContainer) then
		currencyInfo = C_CurrencyInfo.GetCurrencyContainerInfo(currencyID, _quantity);
		icon = currencyInfo.icon;
		quality = currencyInfo.quality;
	else
		currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID);
		icon = currencyInfo.iconFileID;
		quality = currencyInfo.quality;
	end
	
	-- Icon
	if (not self.IsEmbedded) and (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self,linkType)) then
		if (currencyInfo) then
			local displayQuantity = nil;
			self:ttSetIconTextureAndText(icon, _quantity);	-- As of 5.2 GetCurrencyInfo() now returns full texture path. Previously you had to prefix it with "Interface\\Icons\\"
		end
	end

	-- CurrencyID
	if (cfg.if_showCurrencyId) then
		self:AddLine(format(L"CurrencyID: %d", currencyID), unpack(cfg.if_infoColor));
		self:Show();	-- call Show() to resize tip after adding lines
	end

  	-- Quality Border
	if (not self.IsEmbedded) and (cfg.if_currencyQualityBorder) then
		if (currencyInfo) then
			local currencyQualityColor = CreateColorFromHexString(select(4, GetItemQualityColor(quality)));
			ttif:SetBackdropBorderColorLocked(self, true, currencyQualityColor:GetRGBA());
		end
	end
end

-- achievement
function LinkTypeFuncs:achievement(link, linkType, achievementID, guid, completed, month, day, year, criteria1, criteria2, criteria3, criteria4)
	local _achievementID, name, points, _completed, _month, _day, _year, description, flags, icon, rewardText, isGuild, wasEarnedByMe, earnedBy, isStatistic = GetAchievementInfo(achievementID);
	if (cfg.if_modifyAchievementTips) then
		completed = (tonumber(completed) == 1);
		local tipName = self:GetName();
		local isPlayer = (UnitGUID("player"):sub(3) == guid);
		-- Get category
		local catId = GetAchievementCategory(achievementID);
		local category, catParent = GetCategoryInfo(catId);
		local catName;
		while (catParent > 0) do
			catName, catParent = GetCategoryInfo(catParent);
			category = catName.." - "..category;
		end
		-- Get Criteria
		wipe(criteriaList);
		local criteriaComplete = 0;
		for i = 6, self:NumLines() do
			local left = _G[tipName.."TextLeft"..i];
			local right = _G[tipName.."TextRight"..i];
			local leftText = left:GetText();
			local rightText = right:GetText();
			if (leftText and leftText ~= " ") then
				criteriaList[#criteriaList + 1] = { label = leftText, done = left:GetTextColor() < 0.5 };
				if (criteriaList[#criteriaList].done) then
					criteriaComplete = (criteriaComplete + 1);
				end
			end
			if (rightText and rightText ~= " ") then
				criteriaList[#criteriaList + 1] = { label = rightText, done = right:GetTextColor() < 0.5 };
				if (criteriaList[#criteriaList].done) then
					criteriaComplete = (criteriaComplete + 1);
				end
			end
		end
		-- Cache Info
		local progressText = _G[tipName.."TextLeft3"]:GetText() or "";
		-- Rebuild Tip
		self:ClearLines();
		local stat = isPlayer and GetStatistic(achievementID);
		self:AddDoubleLine(name,(stat ~= "0" and stat ~= "--" and stat),nil,nil,nil,1,1,1);
		self:AddLine("<"..category..">");
		if (rewardText) then
			self:AddLine(rewardText,unpack(cfg.if_infoColor));
		end
		self:AddLine(description,1,1,1,1);
		if (progressText ~= "") then
			self:AddLine(BoolCol[completed]..progressText);
		end
		if (#criteriaList > 0) then
			self:AddLine(" ");
			self:AddLine(format(L["Achievement Criteria |cff00ff00%d|r / |cffffffff%d|r"], criteriaComplete, #criteriaList));
			local r1, g1, b1, r2, g2, b2;
			local myDone1, myDone2;
            if GetAchievementNumCriteria(achievementID)>0 then
			for i = 1, #criteriaList, 2 do
				r1, g1, b1 = unpack(criteriaList[i].done and COLOR_COMPLETE or COLOR_INCOMPLETE);
				if (criteriaList[i + 1]) then
					r2, g2, b2 = unpack(criteriaList[i + 1].done and COLOR_COMPLETE or COLOR_INCOMPLETE);
				end
				if (not isPlayer) then
					local success, _, _, completed = pcall(GetAchievementCriteriaInfo,achievementID,i);
					myDone1 = (success and completed);
					--myDone1 = select(3,GetAchievementCriteriaInfo(achievementID,i));
					if (i + 1 <= #criteriaList) then
						local success, _, _, completed = pcall(GetAchievementCriteriaInfo,achievementID,i + 1);
						myDone2 = (success and completed);
						--myDone2 = select(3,GetAchievementCriteriaInfo(achievementID,i + 1));
					end
				end
				myDone1 = (isPlayer and "" or BoolCol[myDone1].."*|r")..criteriaList[i].label;
				myDone2 = criteriaList[i + 1] and criteriaList[i + 1].label..(isPlayer and "" or BoolCol[myDone2].."*");
				self:AddDoubleLine(myDone1,myDone2,r1,g1,b1,r2,g2,b2);
			end
            end
		end
		-- AchievementID + Category
		if (cfg.if_showAchievementIdAndCategoryId) then
			self:AddLine(format(L"AchievementID: %d, CategoryID: %d",achievementID or 0,catId or 0),unpack(cfg.if_infoColor));
		end
		-- Show
		self:Show();	-- call Show() to resize tip after adding lines
	else
		-- AchievementID + Category
		if (cfg.if_showAchievementIdAndCategoryId) then
			local catId = GetAchievementCategory(achievementID);
			self:AddLine(format(L"AchievementID: %d, CategoryID: %d",achievementID or 0,catId or 0),unpack(cfg.if_infoColor));
			self:Show();	-- call Show() to resize tip after adding lines
		end
	end
	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self,linkType)) then
		self:ttSetIconTextureAndText(icon,points);
	end
  	--  Colored Border
	if (cfg.if_achievmentColoredBorder) then
		local achievementColor = ACHIEVEMENT_COLOR_CODE:match("|c(%x+)");
		local achievementColorMixin = CreateColorFromHexString(achievementColor);
		ttif:SetBackdropBorderColorLocked(self, true, achievementColorMixin:GetRGBA());
	end
end

-- battle pet
function LinkTypeFuncs:battlepet(link, linkType, speciesID, level, breedQuality, maxHealth, power, speed, petID, displayID)
	local speciesName, speciesIcon, petType, creatureID, tooltipSource, tooltipDescription, isWild, canBattle, isTradeable, isUnique, obtainable, _displayID = C_PetJournal.GetPetInfoBySpeciesID(speciesID);

	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self, linkType)) then
		self:ttSetIconTextureAndText(speciesIcon);
	end

	-- Quality Border
	if (cfg.if_battlePetQualityBorder) then
		local battlePetQualityColor = CreateColorFromHexString(select(4, GetItemQualityColor(breedQuality or 0)));
		ttif:SetBackdropBorderColorLocked(self, true, battlePetQualityColor:GetRGBA());
	end

	-- level + creatureID -- Only alter the tip if we got either a valid "level" or "creatureID"
	local showLevel = (level and cfg.if_showBattlePetLevel);
	local showId = (creatureID and cfg.if_showBattlePetId);
	local linePadding = 2;

	if (showLevel or showId) then
		if (showLevel) then
			if (self == bptt or self == fbptt) then
				-- remove level from tip
				self:SetHeight(self:GetHeight() - self.Level:GetHeight() - linePadding);
				self.Level:SetText(nil);
				
				-- re-anchor successor node
				local levelPoint, levelRelativeTo, levelRelativePoint, levelXOfs, levelYOfs = self.Level:GetPoint();
				local healthTexturePoint, healthTextureRelativeTo, healthTextureRelativePoint, healthTextureXOfs, healthTextureYOfs = self.HealthTexture:GetPoint();
				healthTextureRelativeTo = levelRelativeTo;
				
				self.HealthTexture:ClearAllPoints();
				self.HealthTexture:SetPoint(healthTexturePoint, healthTextureRelativeTo, healthTextureRelativePoint, healthTextureXOfs, healthTextureYOfs);
				
				-- remove level from tip's line pool
				for line in self.linePool:EnumerateActive() do
					if (line and (line:GetText() or ""):match(BATTLE_PET_CAGE_TOOLTIP_LEVEL)) then
						local linePredecessorPoint, linePredecessorRelativeTo, linePredecessorRelativePoint, linePredecessorXOfs, linePredecessorYOfs = line:GetPoint(1);
						
						if (line == self.textLineAnchor) then
							-- last line in line pool
							self.textLineAnchor = linePredecessorRelativeTo;
						else
							-- re-anchor successor line
							for successorLine in self.linePool:EnumerateActive() do
								local successorLinePredecessorPoint, successorLinePredecessorRelativeTo, successorLinePredecessorRelativePoint, successorLinePredecessorXOfs, successorLinePredecessorYOfs = successorLine:GetPoint(1);
								
								if (successorLinePredecessorRelativeTo == line) then
									local successorLineNumPoints = successorLine:GetNumPoints();
									local successorLineLeftPoint, successorLineLeftRelativeTo, successorLineLeftRelativePoint, successorLineLeftXOfs, successorLineLeftYOfs = successorLine:GetPoint(2);
									local successorLineRightPoint, successorLineRightRelativeTo, successorLineRightRelativePoint, successorLineRightXOfs, successorLineRightYOfs;
									if (successorLineNumPoints > 2) then
										successorLineRightPoint, successorLineRightRelativeTo, successorLineRightRelativePoint, successorLineRightXOfs, successorLineRightYOfs = successorLine:GetPoint(3);
									end
									successorLinePredecessorRelativeTo = linePredecessorRelativeTo;
									
									successorLine:ClearAllPoints();
									successorLine:SetPoint(successorLinePredecessorPoint, successorLinePredecessorRelativeTo, successorLinePredecessorRelativePoint, successorLinePredecessorXOfs, successorLinePredecessorYOfs);
									successorLine:SetPoint(successorLineLeftPoint, successorLineLeftRelativeTo, successorLineLeftRelativePoint, successorLineLeftXOfs, successorLineLeftYOfs);
									if (successorLineNumPoints > 2) then
										successorLine:SetPoint(successorLineRightPoint, successorLineRightRelativeTo, successorLineRightRelativePoint, successorLineRightXOfs, successorLineRightYOfs);
									end
									break;
								end
							end
						end
						
						-- remove level from tip's line pool
						self:SetHeight(self:GetHeight() - line:GetHeight() - linePadding);
						line:ClearAllPoints();
						self.linePool:Release(line);
						
						break;
					end
				end
			else
				for i = 2, min(self:NumLines(),LibItemString.TOOLTIP_MAXLINE_LEVEL) do
					local line = _G[self:GetName().."TextLeft"..i];
					if (line and (line:GetText() or ""):match(BATTLE_PET_CAGE_TOOLTIP_LEVEL)) then
						line:SetText(nil);
						break;
					end
				end
			end
		end
		
		if (not showLevel) then
			self:AddLine(format("NPC ID: %d", tonumber(creatureID)), unpack(cfg.if_infoColor));
		elseif (showId) then
			self:AddLine(format("PetLevel: %d, NPC ID: %d", level, tonumber(creatureID)), unpack(cfg.if_infoColor));
		else
			self:AddLine(format("PetLevel: %d", level), unpack(cfg.if_infoColor));
		end

		if (self ~= bptt and self ~= fbptt) then
			self:Show();	-- call Show() to resize tip after adding lines. only necessary for pet tooltip in action bar.
		end
	end
	
	if (not showLevel) then
		if (self == bptt or self == fbptt) then
			-- re-anchor successor node if necessary
			local healthTexturePoint, healthTextureRelativeTo, healthTextureRelativePoint, healthTextureXOfs, healthTextureYOfs = self.HealthTexture:GetPoint();
			
			if (healthTextureRelativeTo ~= self.Level) then
				healthTextureRelativeTo = self.Level;
				
				self.HealthTexture:ClearAllPoints();
				self.HealthTexture:SetPoint(healthTexturePoint, healthTextureRelativeTo, healthTextureRelativePoint, healthTextureXOfs, healthTextureYOfs);
			end
		end
	end
end

-- battle pet ability
function LinkTypeFuncs:battlePetAbil(link, linkType, abilityID, speciesID, petID, additionalText)
	local abilityName, abilityIcon, abilityType = C_PetJournal.GetPetAbilityInfo(abilityID)

	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self, linkType)) then
		self:ttSetIconTextureAndText(abilityIcon);
	end

	-- AbilityID
	if (cfg.if_showBattlePetAbilityId) then
		self:AddLine("AbilityID: "..abilityID, unpack(cfg.if_infoColor));
		-- self:Show();	-- call Show() to resize tip after adding lines
	end

	-- Colored Border
	if (cfg.if_battlePetAbilityColoredBorder) then
		local abilityColor = CreateColorFromHexString("FF4E96F7"); -- see GetBattlePetAbilityHyperlink() in "ItemRef.lua"
		ttif:SetBackdropBorderColorLocked(self, true, abilityColor:GetRGBA());
	end
end

-- conduit -- Thanks to hobulian for code example
function LinkTypeFuncs:conduit(link, linkType, conduitID, conduitRank)
	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self, linkType)) then
		local spellID = C_Soulbinds.GetConduitSpellID(conduitID, conduitRank);
		local name, _, icon, castTime, minRange, maxRange, _spellID = GetSpellInfo(spellID);
		self:ttSetIconTextureAndText(icon);
	end

	-- ItemLevel + ConduitID
	local conduitCollectionData = C_Soulbinds.GetConduitCollectionData(conduitID);
	local conduitItemLevel = (conduitCollectionData and conduitCollectionData.conduitItemLevel); -- conduitCollectionData is only available for own conduits
	
	local showLevel = (conduitItemLevel and cfg.if_showConduitItemLevel);
	local showId = (conduitID and cfg.if_showConduitId);

	if (showLevel or showId) then
		if (showLevel) then
			for i = 2, min(self:NumLines(),LibItemString.TOOLTIP_MAXLINE_LEVEL) do
				local line = _G[self:GetName().."TextLeft"..i];
				if (line and (line:GetText() or ""):match(ITEM_LEVEL_PLUS)) then
					line:SetText(nil);
					break;
				end
			end
		end
		
		if (not showLevel) then
			self:AddLine(format("ConduitID: %d", conduitID), unpack(cfg.if_infoColor));
		elseif (showId) then
			self:AddLine(format("ItemLevel: %d, ConduitID: %d", conduitItemLevel, conduitID), unpack(cfg.if_infoColor));
		else
			self:AddLine(format("ItemLevel: %d", conduitItemLevel), unpack(cfg.if_infoColor));
		end
		-- self:Show();	-- call Show() to resize tip after adding lines. only necessary for items in toy box.
	end

  	-- Quality Border
	if (cfg.if_conduitQualityBorder) then
		local conduitQuality = C_Soulbinds.GetConduitQuality(conduitID, conduitRank);
		local conduitQualityColor = CreateColorFromHexString(select(4, GetItemQualityColor(conduitQuality or 0)));
		ttif:SetBackdropBorderColorLocked(self, true, conduitQualityColor:GetRGBA());
	end
end

-- transmog appearance (see WardrobeCollectionFrameMixin:GetAppearanceItemHyperlink() + WardrobeItemsModelMixin:OnMouseDown() in "Blizzard_Collections/Blizzard_Wardrobe.lua")
function LinkTypeFuncs:transmogappearance(link, linkType, sourceID)
	local _linkType, itemID = nil, nil;
	local _link = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID));
	if (_link) then
		_linkType, itemID = _link:match("H?(%a+):(%d+)");
	end
	if (not itemID) then
		return;
	end

	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, classID, subClassID, bindType, expacID, setID, isCraftingReagent = GetItemInfo(_link);
	local trueItemLevel = LibItemString:GetTrueItemLevel(_link);
	if (trueItemLevel) then
		itemLevel = trueItemLevel;
	end

	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self,linkType)) then
		local count = (itemStackCount and itemStackCount > 1 and (itemStackCount == 0x7FFFFFFF and "#" or itemStackCount) or "");
		self:ttSetIconTextureAndText(itemTexture, count);
	end

	-- ItemID
	if (cfg.if_showTransmogAppearanceItemId) then
		self:AddLine(format("ItemID: %d", itemID), unpack(cfg.if_infoColor));
		self:Show();	-- call Show() to resize tip after adding lines
	end

	-- Quality Border
	if (cfg.if_transmogAppearanceItemQualityBorder) then
		local itemQualityColor = CreateColorFromHexString(select(4, GetItemQualityColor(itemRarity or 0)));
		ttif:SetBackdropBorderColorLocked(self, true, itemQualityColor:GetRGBA());
	end
end

-- transmog illusion
function LinkTypeFuncs:transmogillusion(link, linkType, illusionID)
	local illusionInfo = C_TransmogCollection.GetIllusionInfo(illusionID);
	
	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self, linkType)) then
		self:ttSetIconTextureAndText(illusionInfo.icon);
	end

	-- IllusionID
	if (cfg.if_showTransmogIllusionId) then
		self:AddLine(format("IllusionID: %d", illusionID), unpack(cfg.if_infoColor));
		self:Show();	-- call Show() to resize tip after adding lines. only necessary for dress up frame.
	end

  	-- Colored Border
	if (cfg.if_transmogIllusionColoredBorder) then
		local name, hyperlink, sourceText = C_TransmogCollection.GetIllusionStrings(illusionID);
		local illusionColor = hyperlink:match("|c(%x+)");
		local illusionColorMixin = CreateColorFromHexString(illusionColor);
		ttif:SetBackdropBorderColorLocked(self, true, illusionColorMixin:GetRGBA());
	end
end

-- transmog set (see WardrobeSetsTransmogModelMixin:OnEnter() in "Blizzard_Collections/Blizzard_Wardrobe.lua")
function LinkTypeFuncs:transmogset(link, linkType, setID)
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
	
	if (waitingOnQuality) then
		tipDataAdded[self] = nil;
		return;
	end
	
	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self, linkType)) then
		local SetsDataProvider = CreateFromMixins(WardrobeSetsDataProviderMixin);
		local icon = SetsDataProvider:GetIconForSet(setID);
		self:ttSetIconTextureAndText(icon);
	end

	-- SetID
	if (cfg.if_showTransmogSetId) then
		self:AddLine(format("SetID: %d", setID), unpack(cfg.if_infoColor));
		self:Show();	-- call Show() to resize tip after adding lines
	end

  	-- Quality Border
	if (cfg.if_transmogSetQualityBorder) then
		local setQuality = (numTotalSlots > 0 and totalQuality > 0) and Round(totalQuality / numTotalSlots) or Enum.ItemQuality.Common;
		local setColor = CreateColorFromHexString(select(4, GetItemQualityColor(setQuality)));
		ttif:SetBackdropBorderColorLocked(self, true, setColor:GetRGBA());
	end
end

-- azerite essence
function LinkTypeFuncs:azessence(link, linkType, essenceID, essenceRank)
	local essenceInfo = C_AzeriteEssence.GetEssenceInfo(essenceID);
	
	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self, linkType)) then
		self:ttSetIconTextureAndText(essenceInfo.icon);
	end

	-- EssenceID
	if (cfg.if_showAzeriteEssenceId) then
		self:AddLine(format("EssenceID: %d", essenceID), unpack(cfg.if_infoColor));
		self:Show();	-- call Show() to resize tip after adding lines.
	end

  	-- Quality Border
	if (cfg.if_azeriteEssenceQualityBorder) then
		local essenceColor = CreateColorFromHexString(select(4, GetItemQualityColor(essenceRank + 1)));
		ttif:SetBackdropBorderColorLocked(self, true, essenceColor:GetRGBA());
	end
end

--------------------------------------------------------------------------------------------------------
--                                      Tip CustomType Functions                                      --
--------------------------------------------------------------------------------------------------------

-- runeforge power
function CustomTypeFuncs:runeforgePower(link, linkType, runeforgePowerID)
	local powerInfo = C_LegendaryCrafting.GetRuneforgePowerInfo(runeforgePowerID);
	
	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self, linkType)) then
		self:ttSetIconTextureAndText(powerInfo.iconFileID);
	end

	-- RuneforgePowerID
	if (cfg.if_showRuneforgePowerId) then
		self:AddLine(format("RuneforgePowerID: %d", runeforgePowerID), unpack(cfg.if_infoColor));
		self:Show();	-- call Show() to resize tip after adding lines
	end

  	-- Colored Border
	if (cfg.if_runeforgePowerColoredBorder) then
		local runeforgePowerColor = CreateColor(LEGENDARY_ORANGE_COLOR.r, LEGENDARY_ORANGE_COLOR.g, LEGENDARY_ORANGE_COLOR.b, 1); -- see RuneforgePowerBaseMixin:OnEnter() in "RuneforgeUtil.lua"
		ttif:SetBackdropBorderColorLocked(self, true, runeforgePowerColor:GetRGBA());
	end
end

-- guild challenge
function CustomTypeFuncs:guildChallenge(link, linkType)
  	-- Colored Border
	if (cfg.if_questDifficultyBorder) then
		local guildChallengeColor = CreateColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1); -- see CommunitiesGuildChallengeTemplate:OnEnter() / GuildChallengeTemplate:OnEnter() in "Blizzard_Communities/GuildInfo.xml" / "Blizzard_GuildUI/Blizzard_GuildInfo.xml"
		ttif:SetBackdropBorderColorLocked(self, true, guildChallengeColor:GetRGBA());
	end
end

-- pvp enlistment bonus
function CustomTypeFuncs:pvpEnlistmentBonus(link, linkType)
  	-- Colored Border
	if (cfg.if_itemQualityBorder) then
		local pvpEnlistmentBonusColor = CreateColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1); -- see PVPRewardEnlistmentBonus_OnEnter() in "Blizzard_PVPUI/Blizzard_PVPUI.lua"
		ttif:SetBackdropBorderColorLocked(self, true, pvpEnlistmentBonusColor:GetRGBA());
	end
end

-- flyout
function CustomTypeFuncs:flyout(link, linkType, flyoutID, icon)
	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self, linkType)) then
		self:ttSetIconTextureAndText(icon);
	end

	-- FlyoutID
	if (cfg.if_showFlyoutId) then
		self:AddLine(format("FlyoutID: %d", flyoutID), unpack(cfg.if_infoColor));
		self:Show();	-- call Show() to resize tip after adding lines
	end

  	-- Colored Border
	if (cfg.if_flyoutColoredBorder) then
		local spellColor = CreateColorFromHexString("FF71D5FF"); -- see GetSpellLink(). extraction of color code from this function not used, because in classic it only returns the spell name instead of a link.
		ttif:SetBackdropBorderColorLocked(self, true, spellColor:GetRGBA());
	end
end

-- pet action
function CustomTypeFuncs:petAction(link, linkType, petActionID, icon)
	-- Icon
	if (self.ttSetIconTextureAndText) and (not cfg.if_smartIcons or SmartIconEvaluation(self, linkType)) then
		self:ttSetIconTextureAndText(icon);
	end

	-- PetActionID
	if (cfg.if_showPetActionId and petActionID) then
		self:AddLine(format("PetActionID: %d", petActionID), unpack(cfg.if_infoColor));
		self:Show();	-- call Show() to resize tip after adding lines. only necessary for pet tooltip in action bar.
	end

  	-- Colored Border
	if (cfg.if_petActionColoredBorder) then
		local spellColor = CreateColorFromHexString("FF71D5FF"); -- see GetSpellLink(). extraction of color code from this function not used, because in classic it only returns the spell name instead of a link.
		ttif:SetBackdropBorderColorLocked(self, true, spellColor:GetRGBA());
	end
end
