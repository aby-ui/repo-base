local L = select(2, ...).L

local function fixInCombat()
    return InCombatLockdown() and U1GetCfgValue and U1GetCfgValue("tiptac/disableMouseFollowWhenCombat")
end

CoreOnEvent("PLAYER_REGEN_DISABLED", function()
    if U1GetCfgValue and U1GetCfgValue("tiptac/disableMouseFollowWhenCombat") then GameTooltip:Hide() end
end)

local LibQTip = LibStub("LibQTip-1.0", true);
local _G = getfenv(0);
local unpack = unpack;
local UnitName = UnitName;
local UnitExists = UnitExists;
local GetMouseFocus = GetMouseFocus;
local gtt = GameTooltip;
local stt1 = ShoppingTooltip1;
local stt2 = ShoppingTooltip2;
local irtt = ItemRefTooltip;
local irstt1 = ItemRefShoppingTooltip1;
local irstt2 = ItemRefShoppingTooltip2;
local bptt = BattlePetTooltip;
local fbptt = FloatingBattlePetTooltip;
local pjpatt = PetJournalPrimaryAbilityTooltip;
local pjsatt = PetJournalSecondaryAbilityTooltip;
local fpbatt = FloatingPetBattleAbilityTooltip;
local ejtt = EncounterJournalTooltip;
local wipe = wipe;
local tconcat = table.concat;

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
local tt = CreateFrame("Frame",modName,UIParent,BackdropTemplateMixin and "BackdropTemplate");	-- 9.0.1: Using BackdropTemplate

-- Global Chat Message Function
function AzMsg(msg) DEFAULT_CHAT_FRAME:AddMessage(tostring(msg):gsub("|1","|cffffff80"):gsub("|2","|cffffffff"):gsub("|3","|cffc41e3a"),0.5,0.75,1.0); end

-- Default Config
local cfg;
local TT_DefaultConfig = {
	showUnitTip = true,
	showStatus = true,
	showGuildRank = true,
	guildRankFormat = "both",
	showTargetedBy = true,
	showPlayerGender = false,
	nameType = "title",
	showRealm = "show",
	showTarget = "last",
	targetYouText = "<<YOU>>",
	showCurrentUnitSpeed = false,
	showMythicPlusDungeonScore = true,

	showBattlePetTip = true,
	gttScale = 1,
	updateFreq = 0.5,
	enableChatHoverTips = true,
	hidePvpText = true,
	hideFactionText = false,
	hideRealmText = false,

	colorGuildByReaction = true,
	colGuild = "|cff0080cc",
	colSameGuild = "|cffff32ff",
	colRace = "|cffffffff",
	colLevel = "|cffc0c0c0",
	colorNameByClass = false,
	classColoredBorder = true,

	reactText = false,
	colReactText1 = "|cffc0c0c0", --tapped
	colReactText2 = "|cffff0000", --hostile
	colReactText3 = "|cffff7f00", --Caution
	colReactText4 = "|cffffff00", --Neutral
	colReactText5 = "|cff00ff00", --Friendly NPC or PvP Player
	colReactText6 = "|cff25c1eb", --Friendly Player
	colReactText7 = "|cff808080", --Dead

	reactColoredBackdrop = false,
	reactColoredBorder = false,
	colReactBack1 = { 0.2, 0.2, 0.2 },
	colReactBack2 = { 0.3, 0, 0 },
	colReactBack3 = { 0.3, 0.15, 0 },
	colReactBack4 = { 0.3, 0.3, 0 },
	colReactBack5 = { 0, 0.3, 0.1 },
	colReactBack6 = { 0, 0, 0.5 },
	colReactBack7 = { 0.05, 0.05, 0.05 },

	enableBackdrop = false,
	tipBackdropBG = "Interface\\Buttons\\WHITE8X8",
	tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
	pixelPerfectBackdrop = false,
	backdropEdgeSize = 14,
	backdropInsets = 2.5,

	tipColor = { 0.1, 0.1, 0.2 },			-- UI Default: For most: (0.1,0.1,0.2), World Objects?: (0,0.2,0.35)
	tipBorderColor = { 0.3, 0.3, 0.4 },		-- UI Default: (1,1,1,1)
	gradientTip = true,
	gradientHeight = 32,
	gradientColor = { 0.8, 0.8, 0.8, 0.15 },

	modifyFonts = false,
	fontFace = "",	-- Set during VARIABLES_LOADED
	fontSize = 13,	-- Set during VARIABLES_LOADED
	fontFlags = "",	-- Set during VARIABLES_LOADED
	fontSizeDeltaHeader = 2,
	fontSizeDeltaSmall = -2,

	classification_minus = "-%s",		-- New classification in MoP; Used for minion mobs that typically have less health than normal mobs of their level, but engage the player in larger numbers. Example of use: The "Sha Haunts" early in the Horde's quests in Thunder Hold.
	classification_trivial = "~%s",
	classification_normal = "%s",
	classification_elite = "+%s",
	classification_worldboss = "%s|r (Boss)",
	classification_rare = "%s|r (Rare)",
	classification_rareelite = "+%s|r (Rare)",

	overrideFade = true,
	preFadeTime = 0.1,
	fadeTime = 0.1,
	hideWorldTips = true,

	barFontFace = "",	      -- Set during VARIABLES_LOADED
	barFontSize = 13,	      -- Set during VARIABLES_LOADED
	barFontFlags = "OUTLINE", -- Set during VARIABLES_LOADED
	barHeight = 6,
	barTexture = "Interface\\TargetingFrame\\UI-StatusBar",

	hideDefaultBar = true,
	barsCondenseValues = true,
	healthBar = true,
	healthBarClassColor = true,
	healthBarText = "value",
	healthBarColor = { 0.3, 0.9, 0.3 },
	manaBar = false,
	manaBarText = "value",
	manaBarColor = { 0.3, 0.55, 0.9 },
	powerBar = false,
	powerBarText = "value",

	aurasAtBottom = false,
	showBuffs = true,
	showDebuffs = true,
	selfAurasOnly = false,
	auraSize = 20,
	auraMaxRows = 2,
	showAuraCooldown = true,
	noCooldownCount = false,

	iconRaid = true,
	iconFaction = false,
	iconCombat = false,
	iconClass = false,
	iconAnchor = "TOPLEFT",
	iconSize = 24,

	anchorWorldUnitType = "normal",
	anchorWorldUnitPoint = "BOTTOMRIGHT",
	anchorWorldTipType = "normal",
	anchorWorldTipPoint = "BOTTOMRIGHT",
	anchorFrameUnitType = "normal",
	anchorFrameUnitPoint = "BOTTOMRIGHT",
	anchorFrameTipType = "normal",
	anchorFrameTipPoint = "BOTTOMRIGHT",

	enableAnchorOverrideWorldUnitInCombat = false,
	anchorWorldUnitTypeInCombat = "normal",
	anchorWorldUnitPointInCombat = "BOTTOMRIGHT",
	enableAnchorOverrideWorldTipInCombat = false,
	anchorWorldTipTypeInCombat = "normal",
	anchorWorldTipPointInCombat = "BOTTOMRIGHT",
	enableAnchorOverrideFrameUnitInCombat = false,
	anchorFrameUnitTypeInCombat = "normal",
	anchorFrameUnitPointInCombat = "BOTTOMRIGHT",
	enableAnchorOverrideFrameTipInCombat = false,
	anchorFrameTipTypeInCombat = "normal",
	anchorFrameTipPointInCombat = "BOTTOMRIGHT",

	enableAnchorOverrideCF = false,
	anchorOverrideCFType = "normal",
	anchorOverrideCFPoint = "BOTTOMRIGHT",

	mouseOffsetX = 0,
	mouseOffsetY = 0,

	hideTips = "none",
	hideTipsInCombat = "none",
	showHiddenTipsOnShift = false,
};

-- ----------------------------------------
-- 爱不易修改默认设置
for k,v in pairs({
   	showGuildRank = true,
   	targetYouText = "|cffff0000<<你>>|r",
   	enableChatHoverTips = true,
   	hidePvpText = true,
   	colorNameByClass = true,
   	classColoredBorder = true,

   	tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
   	tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
   	backdropEdgeSize = 16,
   	backdropInsets = 2.5, --原来的5会弹跳一下

   	tipColor = { 0.1, 0.1, 0.2, 1 },			-- UI Default: For most: (0.1,0.1,0.2), World Objects?: (0,0.2,0.35)
   	tipBorderColor = { 1, 1, 1, 1 },		-- UI Default: (1,1,1,1)
   	gradientTip = false,

   	classification_minus = "|r等级 -%s",		-- New classification in MoP; Unsure what it's used for, but apparently the units have no mana. Example of use: The "Sha Haunts" early in the Horde's quests in Thunder Hold.
   	classification_trivial = "|r等级 ~%s",
   	classification_normal = "|r等级 %s",
   	classification_elite = "|r等级 %s (精英)",
   	classification_worldboss = "|r等级 %s (首领)",
   	classification_rare = "|r等级 %s (稀有)",
   	classification_rareelite = "|r等级 %s (稀有精英)",

   	overrideFade = true,
   	hideWorldTips = false,

   	hideDefaultBar = false,
   	barsCondenseValues = true,
    barsCondenseType = "wanyi",
   	healthBar = false,

   	showBuffs = false,
   	showDebuffs = false,

   	anchorWorldUnitType = "mouse",
   	anchorWorldUnitPoint = "TOPLEFT",
   	anchorWorldTipType = "mouse",
   	anchorWorldTipPoint = "TOPLEFT",
   	anchorFrameUnitType = "parent",
   	anchorFrameUnitPoint = "BOTTOMRIGHT",
   	anchorFrameTipType = "parent",
   	anchorFrameTipPoint = "BOTTOMRIGHT",

   	mouseOffsetX = 45,
   	mouseOffsetY = -110,
    top = 200, --没有top和left就会显示锚点框体
    left = (GetScreenWidth() or 2000) - 250,

   	-- Talents
   	showTalents = true,

   	-- ItemRef
    if_showItemLevel = false,					-- Used to be true, but changed due to the itemLevel issues
   	if_showItemId = true,
   	if_showSpellIdAndRank = true,
   	if_showAchievementIdAndCategory = true,	-- Az: no option for this added to TipTac/options yet!
}) do
	TT_DefaultConfig[k] = v
end

-- Tips modified by TipTac in appearance and scale, you can add to this list if you want to modify more tips.
-- Other addons can use TipTac:AddModifiedTip(tip,noHooks) to register their own tooltips if desired.
local TT_TipsToModify = {
	"GameTooltip",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ItemRefTooltip",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
	"EmbeddedItemTooltip",
	"NamePlateTooltip",
	"BattlePetTooltip",
	"FloatingBattlePetTooltip",
	"PetJournalPrimaryAbilityTooltip",
	"PetJournalSecondaryAbilityTooltip",
	"FloatingPetBattleAbilityTooltip",
	"FriendsTooltip",
	"ContributionBuffTooltip",
	"QueueStatusFrame",
	-- "EncounterJournalTooltip", -- commented out for embedded tooltips: SetPadding() makes problems with embedded tooltips.
	-- 3rd party addon tooltips
	"LibDBIconTooltip",
	"AtlasLootTooltip",
	"QuestHelperTooltip",
	"QuestGuru_QuestWatchTooltip",
	"PlaterNamePlateAuraTooltip"
};

for i = 1, UIDROPDOWNMENU_MAXLEVELS do
	TT_TipsToModify[#TT_TipsToModify + 1] = "DropDownList"..i;
end

tt.tipsToModify = TT_TipsToModify;

local TT_NoReApplyAnchorFor = {
	["ShoppingTooltip1"] = true,
	["ShoppingTooltip2"] = true,
	["ItemRefTooltip"] = true,
	["ItemRefShoppingTooltip1"] = true,
	["ItemRefShoppingTooltip2"] = true,
	["RaiderIO_ProfileTooltip"] = true,
	["RaiderIO_SearchTooltip"] = true
};

local TT_AddOnsLoaded = {
	["TipTac"] = false,
	["Blizzard_Collections"] = false,
	["Blizzard_Communities"] = false,
	["Blizzard_Contribution"] = false,
	["Blizzard_EncounterJournal"] = false,
	["RaiderIO"] = false
};

-- Colors
local CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;
local TT_ClassColorMarkup = {};
for classFile, color in next, CLASS_COLORS do
	TT_ClassColorMarkup[classFile] = ("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255);
end
tt.ClassColorMarkup = TT_ClassColorMarkup;

-- Mirror Anchors
local TT_MirrorAnchors = {			-- MirrorAnchorsVertical
	TOP = "BOTTOM",
	TOPLEFT = "TOPRIGHT",
	TOPRIGHT = "TOPLEFT",
	BOTTOM = "TOP",
	BOTTOMLEFT = "BOTTOMRIGHT",
	BOTTOMRIGHT = "BOTTOMLEFT",
	LEFT = "RIGHT",
	RIGHT = "LEFT",
	CENTER = "CENTER",
};
tt.MirrorAnchors = TT_MirrorAnchors;

local TT_MirrorAnchorsSmart = {		-- MirrorAnchorsCentered
	TOPLEFT = "BOTTOMRIGHT",
	TOPRIGHT = "BOTTOMLEFT",
	BOTTOMLEFT = "TOPRIGHT",
	BOTTOMRIGHT = "TOPLEFT",
};
tt.MirrorAnchorsSmart = TT_MirrorAnchorsSmart;

-- GTT Control Variables
tt.padding = {			-- padding variables used to set the padding for the GTT
	["right"] = 0,
	["bottom"] = 0,
	["left"] = 0,
	["top"] = 0,
	["offset"] = -2.5
};

-- Data Variables
local targetedByList;

orgGTTFontFace = "";          -- Set during VARIABLES_LOADED
orgGTTFontSize = 13;          -- Set during VARIABLES_LOADED
orgGTTFontFlags = "";         -- Set during VARIABLES_LOADED
orgGTHTFontFace = "";         -- Set during VARIABLES_LOADED
orgGTHTFontSize = 15;         -- Set during VARIABLES_LOADED
orgGTHTFontFlags = "OUTLINE"; -- Set during VARIABLES_LOADED
orgGTTSFontFace = "";         -- Set during VARIABLES_LOADED
orgGTTSFontSize = 12;         -- Set during VARIABLES_LOADED
orgGTTSFontFlags = "";        -- Set during VARIABLES_LOADED

-- Pixel Perfect Scale
local physicalScreenWidth, physicalScreenHeight, uiUnitFactor, uiScale;
local mouseOffsetX, mouseOffsetY = 0, 0;

local function updatePixelPerfectScale()
	physicalScreenWidth, physicalScreenHeight = GetPhysicalScreenSize();
	uiUnitFactor = 768.0 / physicalScreenHeight;
	uiScale = UIParent:GetEffectiveScale();
	if (cfg) then
		mouseOffsetX, mouseOffsetY = tt:GetNearestPixelSize(cfg.mouseOffsetX or 0), tt:GetNearestPixelSize(cfg.mouseOffsetY or 0);
	end
end

updatePixelPerfectScale();

-- Tooltip Backdrop -- Az: use this instead: TOOLTIP_BACKDROP_STYLE_DEFAULT;
--local tipBackdrop = TOOLTIP_BACKDROP_STYLE_DEFAULT;
local tipBackdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } };
tipBackdrop.backdropColor = CreateColor(1,1,1);
tipBackdrop.backdropBorderColor = CreateColor(1,1,1);

-- To ensure that the alpha channel is applied to the backdrop color, we have to cheat a bit, by pointing the GetRGB() function to GetRGBA().
tipBackdrop.backdropColor.GetRGB = ColorMixin.GetRGBA;
tipBackdrop.backdropBorderColor.GetRGB = ColorMixin.GetRGBA;

--------------------------------------------------------------------------------------------------------
--                              MetaClass for Pushing Values Into Table                               --
--------------------------------------------------------------------------------------------------------

-- this class keeps track of the array count internally to avoid the constant
-- use of the length operator (#) recounting the array over and over.
local PushArray = {
	__index = {
		count = 0,
		Clear = function(t) wipe(t); end,
		Concat = function(t) return tconcat(t) end,
	},
	__newindex = function(t,k,v)
		if (k == "next") then
			t.count = (t.count + 1);
			t.last = v;
		elseif (k == "last") then
			rawset(t,t.count,v);
			if (v == nil) then
				t.count = (t.count - 1);
			end
		else
			rawset(t,k,v);
		end
	end,
}

-- returns the given table, or a new table with te PushArray metamethods
function tt:CreatePushArray(optTable)
	return setmetatable(optTable or {},PushArray);
end

--------------------------------------------------------------------------------------------------------
--                                          Helper Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Get displayed unit
function tt:GetDisplayedUnit(tooltip)
	if (tooltip.GetUnit) then
		return tooltip:GetUnit();
	else
		return TooltipUtil.GetDisplayedUnit(tooltip);
	end
end

--------------------------------------------------------------------------------------------------------
--                                         Elements Framework                                         --
--------------------------------------------------------------------------------------------------------

--[[
	Element Events:
	- OnLoad			Variables has been loaded
	- OnCleared			Tooltip has been cleared
	- OnApplyConfig		Config settings needs to be applied
	- OnPreStyleTip		Before tooltip is being styled
	- OnPostStyleTip	After tooltip has been styled and have the final size
--]]

local elements = {};
tt.elements = elements;

function tt:RegisterElement(element,name)
	element.name = name;
	elements[#elements + 1] = element;
	return element;
end

function tt:SendElementEvent(event,...)
	for _, element in ipairs(elements) do
		if (not element.disabled) and (element[event]) then
			element[event](element,...);
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                      Anchor Creation & Events                                      --
--------------------------------------------------------------------------------------------------------

tt:SetSize(114,24);
tt:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 8, edgeSize = 12, insets = { left = 2, right = 2, top = 2, bottom = 2 } });
tt:SetBackdropColor(0.1,0.1,0.2,1);
tt:SetBackdropBorderColor(0.1,0.1,0.1,1);
tt:SetMovable(true);
tt:EnableMouse(true);
tt:SetToplevel(true);
tt:SetClampedToScreen(true);
tt:SetPoint("CENTER");
tt:Hide();

tt.text = tt:CreateFontString(nil,"ARTWORK","GameFontHighlight");
tt.text:SetText(L"TipTacAnchor");
tt.text:SetPoint("LEFT",6,0);

tt.close = CreateFrame("Button",nil,tt,"UIPanelCloseButton");
tt.close:SetSize(24,24);
tt.close:SetPoint("RIGHT");

-- Cursor Update/Changed -- Event only registered when the "hideWorldTips" option is ENABLED.
local function hideWorldTips()
	if (gtt:IsShown()) and (gtt:IsOwned(UIParent)) and ((not gtt.ttUnit) or (not gtt.ttUnit.token)) then
		-- Restoring the text of the first line, is a workaround so that gatherer addons can get the name of nodes
		local backup = GameTooltipTextLeft1:GetText();
		gtt:Hide();
		GameTooltipTextLeft1:SetText(backup);
	end
end

function tt:CURSOR_UPDATE(event)
	hideWorldTips();
end

function tt:CURSOR_CHANGED(event)
	hideWorldTips();
end

-- Login [One-Time-Event] -- Initialize Level for difficulty coloring
function tt:PLAYER_LOGIN(event)
	self.playerLevel = UnitLevel("player");
	
	-- Cleanup
	self:UnregisterEvent(event);
	self[event] = nil;
end

-- Level Up -- Update Level for difficulty coloring to avoid excessively calling UnitLevel()
function tt:PLAYER_LEVEL_UP(event,newLevel)
	self.playerLevel = newLevel;
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
function tt:VARIABLES_LOADED(event)
	self.isColorBlind = (GetCVar("colorblindMode") == "1");

	-- Default Fonts
	orgGTTFontFace, orgGTTFontSize, orgGTTFontFlags = GameTooltipText:GetFont();
	orgGTTFontSize = math.floor(orgGTTFontSize + 0.5);
	orgGTHTFontFace, orgGTHTFontSize, orgGTHTFontFlags = GameTooltipHeaderText:GetFont();
	orgGTHTFontSize = math.floor(orgGTHTFontSize + 0.5);
	orgGTTSFontFace, orgGTTSFontSize, orgGTTSFontFlags = GameTooltipTextSmall:GetFont();
	orgGTTSFontSize = math.floor(orgGTTSFontSize + 0.5);

	TT_DefaultConfig.fontFace, TT_DefaultConfig.fontSize, TT_DefaultConfig.fontFlags = GameFontNormal:GetFont();
	TT_DefaultConfig.fontSize = math.floor(TT_DefaultConfig.fontSize + 0.5);
	TT_DefaultConfig.barFontFace, TT_DefaultConfig.barFontSize, TT_DefaultConfig.barFontFlags = NumberFontNormal:GetFont();
	TT_DefaultConfig.barFontSize = math.floor(TT_DefaultConfig.barFontSize + 0.5);

	-- Init Config
	if (not TipTac_Config) then
		TipTac_Config = {};
	end
	cfg = ChainConfigTables(TipTac_Config, TT_DefaultConfig);
    if TipTac_Config.top == 0 and TipTac_Config.left == 0 then --abyui
        TipTac_Config.top = nil
        TipTac_Config.left = nil
        self:Show()
    end
    
	-- Default the bar texture if it no longer exists
	GameTooltipStatusBar:SetStatusBarTexture(cfg.barTexture);
	if (not GameTooltipStatusBar:GetStatusBarTexture()) then
		cfg.barTexture = nil;
	end

	-- Position
	if (cfg.left and cfg.top) then
		self:ClearAllPoints();
		self:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",cfg.left,cfg.top);
	else
		self:Show();
		-- Just set left and top here, in case the player just closes the anchor without moving, so it doesn't keep showing up when they log in
		cfg.left, cfg.top = self:GetLeft(), self:GetTop();
	end

	-- Notify elements that we've loaded
	self:SendElementEvent("OnLoad",cfg);

	-- Hook Tips & Apply Settings
	self:HookTips();
	self:ApplySettings();

	if (not targetedByList) then
		targetedByList = self:CreatePushArray();
	end
	
	-- Re-Trigger event ADDON_LOADED for TipTac if config wasn't ready
	self:ADDON_LOADED("ADDON_LOADED", "TipTac");
	
	-- Cleanup
	self:UnregisterEvent(event);
	self[event] = nil;
end

-- Console Var Change
function tt:CVAR_UPDATE(event,var,value)
	if (var == "USE_COLORBLIND_MODE") then
		self.isColorBlind = (value == "1");
	end
end

-- UI Scale Changed
function tt:UI_SCALE_CHANGED(event)
	tt:ApplySettings();
end

hooksecurefunc(UIParent, "SetScale", function()
	tt:ApplySettings();
end);

-- Display Size Changed
function tt:DISPLAY_SIZE_CHANGED(event)
	tt:ApplySettings();
end

tt:SetScript("OnMouseDown",tt.StartMoving);
tt:SetScript("OnMouseUp",function(self) self:StopMovingOrSizing(); cfg.left, cfg.top = self:GetLeft(), self:GetTop(); end);
tt:SetScript("OnEvent",function(self,event,...) self[event](self,event,...); end);

tt:RegisterEvent("PLAYER_LOGIN");
tt:RegisterEvent("PLAYER_LEVEL_UP");
tt:RegisterEvent("VARIABLES_LOADED");
tt:RegisterEvent("ADDON_LOADED");
tt:RegisterEvent("CVAR_UPDATE");
tt:RegisterEvent("UI_SCALE_CHANGED");
tt:RegisterEvent("DISPLAY_SIZE_CHANGED");

--------------------------------------------------------------------------------------------------------
--                                           Slash Handling                                           --
--------------------------------------------------------------------------------------------------------

_G["SLASH_"..modName.."1"] = "/tip";
_G["SLASH_"..modName.."2"] = "/tiptac";
SlashCmdList[modName] = function(cmd)
	-- Extract Parameters
	local param1, param2 = cmd:match("^([^%s]+)%s*(.*)$");
	param1 = (param1 and param1:lower() or cmd:lower());
	-- Options
	if (param1 == "") then
		local loaded, reason = LoadAddOn("TipTacOptions");
		if (loaded) then
			TipTacOptions:SetShown(not TipTacOptions:IsShown());
		else
			AzMsg(L"Could not open TicTac Options: |1"..tostring(reason)..L"|r. Please make sure the addon is enabled from the character selection screen.");
		end
	-- Show Anchor
	elseif (param1 == "anchor") then
		tt:SetShown(not tt:IsShown());
	-- Reset settings
	elseif (param1 == "reset") then
		wipe(cfg);
		tt:ApplySettings();
		AzMsg(L"All |2"..modName..L"|r settings has been reset to their default values.");
	-- Invalid or No Command
	else
		UpdateAddOnMemoryUsage();
		AzMsg(format("----- |2%s|r |1%s|r ----- |1%.2f |2kb|r -----",modName,GetAddOnMetadata(modName,"Version"),GetAddOnMemoryUsage(modName)));
		AzMsg(L"The following |2parameters|r are valid for this addon:");
		AzMsg(L" |2anchor|r = Shows the anchor where the tooltip appears");
		AzMsg(L" |2reset|r = Resets all settings back to their default values");
	end
end

--------------------------------------------------------------------------------------------------------
--                                              Settings                                              --
--------------------------------------------------------------------------------------------------------

-- Get nearest pixel size (e.g. to avoid 1-pixel borders, which are sometimes 0/2-pixels wide)
function tt:GetNearestPixelSize(size, pixelPerfect)
	local _size = ((pixelPerfect and (size * uiUnitFactor)) or size);
	return PixelUtil.GetNearestPixelSize(_size, 1) / uiScale / (cfg.gttScale or 1);
end

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

-- Setup Gradient Tip
local function SetupGradientTip(tip)
	local g = tip.ttGradient;
	if (not cfg.enableBackdrop) or (not cfg.gradientTip) then
		if (g) then
			g:Hide();
		end
		return;
	elseif (not g) then
		g = tip:CreateTexture();
		if (g.SetGradientAlpha) then -- before df
			g:SetColorTexture(1, 1, 1, 1);
		else -- since df
			g:SetTexture([[Interface\AddOns\TipTac\media\gradient]]);
		end
		tip.ttGradient = g;
	end
	if (g.SetGradientAlpha) then -- before df
		g:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, unpack(cfg.gradientColor));
	else -- since df
		g:SetVertexColor(unpack(cfg.gradientColor));
	end
	local insets = ((cfg.pixelPerfectBackdrop and tt:GetNearestPixelSize(cfg.backdropInsets, true)) or cfg.backdropInsets);
	g:SetPoint("TOPLEFT", insets, insets * -1);
	g:SetPoint("BOTTOMRIGHT", tip, "TOPRIGHT", insets * -1, -cfg.gradientHeight);
	g:Show();
end

-- Set padding variables
function tt:SetPaddingVariables()
	tt.padding.right, tt.padding.bottom, tt.padding.left, tt.padding.top = tipBackdrop.insets.right + tt.padding.offset, tipBackdrop.insets.bottom + tt.padding.offset, tipBackdrop.insets.left + tt.padding.offset, tipBackdrop.insets.top + tt.padding.offset;
end

-- Set scale to frame
local function SetScale(frame)
	local frameName = frame:GetName();
	
	-- don't scale some frames
	if (frameName) and ((frameName == "QueueStatusFrame") or (frameName:match("DropDownList(%d+)")) or (frameName == "RaiderIO_ProfileTooltip") or (frameName == "RaiderIO_SearchTooltip")) then
		return;
	end
	
	frame:SetScale(cfg.gttScale);
end

-- Apply Settings
function tt:ApplySettings()
	updatePixelPerfectScale();
	
	if (not cfg) then return end;
	
	-- Hide World Tips Instantly
	if (cfg.hideWorldTips or cfg.anchorWorldTipType == "mouse") then
		self:RegisterEvent(isWoWClassic and "CURSOR_UPDATE" or "CURSOR_CHANGED");
	else
		self:UnregisterEvent(isWoWClassic and "CURSOR_UPDATE" or "CURSOR_CHANGED");
	end

	-- Set Backdrop -- not setting "tileSize" as we dont tile
	if (cfg.tipBackdropBG == "nil") then
		tipBackdrop.bgFile = nil;
	else
		tipBackdrop.bgFile = cfg.tipBackdropBG;
	end
	if (cfg.tipBackdropEdge == "nil") then
		tipBackdrop.edgeFile = nil;
	else
		tipBackdrop.edgeFile = cfg.tipBackdropEdge;
	end
	
	tipBackdrop.tile = false;
	tipBackdrop.tileEdge = false;
	
	local edgeSize = ((cfg.pixelPerfectBackdrop and tt:GetNearestPixelSize(cfg.backdropEdgeSize, true)) or cfg.backdropEdgeSize);
	tipBackdrop.edgeSize = edgeSize;
	
	local insets = ((cfg.pixelPerfectBackdrop and tt:GetNearestPixelSize(cfg.backdropInsets, true)) or cfg.backdropInsets);
	tipBackdrop.insets.left = insets;
	tipBackdrop.insets.right = insets;
	tipBackdrop.insets.top = insets;
	tipBackdrop.insets.bottom = insets;
	
	tipBackdrop.backdropColor:SetRGBA(unpack(cfg.tipColor));
	tipBackdrop.backdropBorderColor:SetRGBA(unpack(cfg.tipBorderColor));

	tt:SetPaddingVariables();

	-- Set Scale, Backdrop, Gradient
	for _, tip in ipairs(TT_TipsToModify) do
		if (type(tip) == "table") and (type(tip.GetObjectType) == "function") then
			if (tip == WorldMapTooltip) and (WorldMapTooltip.BackdropFrame) then
				SetScale(tip);
				tip = WorldMapTooltip.BackdropFrame;	-- workaround for the worldmap faux tip
			elseif (tip == QuestScrollFrame) and (QuestScrollFrame.StoryTooltip) then
				tip = QuestScrollFrame.StoryTooltip;
			end
			SetupGradientTip(tip);
			SetScale(tip);
			tt:ApplyTipBackdrop(tip, "ApplySettings");
		end
	end

	-- GameTooltip Font Templates
	if (cfg.modifyFonts) then
		GameTooltipText:SetFont(cfg.fontFace, cfg.fontSize, cfg.fontFlags);
		GameTooltipHeaderText:SetFont(cfg.fontFace, cfg.fontSize + cfg.fontSizeDeltaHeader, cfg.fontFlags);
		GameTooltipTextSmall:SetFont(cfg.fontFace, cfg.fontSize + cfg.fontSizeDeltaSmall, cfg.fontFlags);
	else
		GameTooltipText:SetFont(orgGTTFontFace, orgGTTFontSize, orgGTTFontFlags);
		GameTooltipHeaderText:SetFont(orgGTHTFontFace, orgGTHTFontSize, orgGTHTFontFlags);
		GameTooltipTextSmall:SetFont(orgGTTSFontFace, orgGTTSFontSize, orgGTTSFontFlags);
	end

	-- Calling tip:Show() here ensures that the tooltip has the correct dimensions f.e. if enabling/disabling "Font->Modify the GameTooltip Font Templates".
	if (gtt:IsShown()) then
		gtt:Show();
	end

	-- inform elements that settings has been applied
	self:SendElementEvent("OnApplyConfig",cfg);
end

--------------------------------------------------------------------------------------------------------
--                                          TipTac Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Reapplies backdrop
local function STT_SetBackdropStyle(self, style, embedded)
	for _, tip in ipairs(TT_TipsToModify) do
		if (type(tip) == "table") and (type(tip.GetObjectType) == "function") and (tip == self) then
			tt:ApplyTipBackdrop(self, "SharedTooltip_SetBackdropStyle");
			break;
		end
	end
end

-- Sets backdrop
function tt:SetBackdropLocked(tip, backdropInfo)
	tip.ttSetBackdropLocked = false;
	tip:SetBackdrop(backdropInfo);
	tip.ttSetBackdropLocked = true;
end

-- Sets backdrop color
function tt:SetBackdropColorLocked(tip, lockColor, r, g, b, a)
	if (not lockColor) and (tip.ttBackdropColorApplied) then
		return;
	end
	
	tip.ttSetBackdropColorLocked = false;
	tip:SetBackdropColor(r, g, b, (a or 1) * (tipBackdrop.backdropColor.a or 1));
	tip.ttSetBackdropColorLocked = true;
	
	if (lockColor) then
		tip.ttBackdropColorApplied = true;
	end
end

-- Sets backdrop border color
function tt:SetBackdropBorderColorLocked(tip, lockColor, r, g, b, a)
	if (not lockColor) and (tip.ttBackdropBorderColorApplied) then
		return;
	end
	
	tip.ttSetBackdropBorderColorLocked = false;
	tip:SetBackdropBorderColor(r, g, b, (a or 1) * (tipBackdrop.backdropBorderColor.a or 1));
	tip.ttSetBackdropBorderColorLocked = true;
	
	if (lockColor) then
		tip.ttBackdropBorderColorApplied = true;
	end
end

-- Resets backdrop (border) color
function tt:ResetBackdropBorderColorLocked(tip)
	tip.ttBackdropColorApplied = false;
	tip.ttBackdropBorderColorApplied = false;

	tt:SetBackdropColorLocked(tip, false, tipBackdrop.backdropColor:GetRGBA());
	tt:SetBackdropBorderColorLocked(tip, false, tipBackdrop.backdropBorderColor:GetRGBA());
end

-- Sets padding, so that the tooltip text is still in the center piece.
function tt:SetPadding(tip, calledFromEvent)
	if (tip:GetObjectType() ~= "GameTooltip") then -- SetPadding() not available for BattlePetTooltip, FloatingBattlePetTooltip, PetJournalPrimaryAbilityTooltip, PetJournalSecondaryAbilityTooltip, FloatingPetBattleAbilityTooltip, EncounterJournalTooltip and DropDownList
		return;
	end
	local oldPaddingWidth, oldPaddingHeight = tip:GetPadding();
	
	local itemTooltip = tip.ItemTooltip;
	local isItemTooltipShown = (itemTooltip and itemTooltip:IsShown());
	local isBottomFontStringShown = (tip.BottomFontString and tip.BottomFontString:IsShown());
	
	if (not isItemTooltipShown) and (not isBottomFontStringShown) and
			(calledFromEvent ~= "GameTooltip_AddQuestRewardsToTooltip") and
			(calledFromEvent ~= "GameTooltip_CalculatePadding") then

		if (math.abs(tt.padding.right - oldPaddingWidth) > 0.5) or (math.abs(tt.padding.bottom - oldPaddingHeight) > 0.5) then
			tip:SetPadding(tt.padding.right, tt.padding.bottom, tt.padding.left, tt.padding.top);
		end
		return;
	end
	
	-- consider GameTooltip_AddQuestRewardsToTooltip() + GameTooltip_CalculatePadding()
	-- commented out for embedded tooltips: SetPadding() makes problems with embedded tooltips.
	
	-- if (calledFromEvent == "OnTooltipCleared") then -- no SetPadding() here for embedded tooltips during event OnTooltipCleared
		-- return;
	-- end
	
	-- if (itemTooltip) then
		-- if (isBottomFontStringShown) then
			-- itemTooltip:SetPoint("BOTTOMLEFT", tip.BottomFontString, "TOPLEFT", 0, 10);
		-- else
			-- itemTooltip:SetPoint("BOTTOMLEFT", 10 + tt.padding.left, 13 + tt.padding.bottom);
		-- end
	-- end
	
	-- if (not tip:IsShown()) and (calledFromEvent ~= "GameTooltip_AddQuestRewardsToTooltip") then
		-- return;
	-- end

	-- local newPaddingRight, newPaddingBottom, newPaddingLeft, newPaddingTop = tt.padding.right, tt.padding.bottom, tt.padding.left, tt.padding.top;
	
	-- newPaddingRight = oldPaddingWidth + tt.padding.right;print(newPaddingRight, tip:IsShown(), calledFromEvent);
	
	-- if (calledFromEvent == "GameTooltip_AddQuestRewardsToTooltip") then
		-- newPaddingBottom = oldPaddingHeight + tt.padding.bottom;
	-- else
		-- newPaddingBottom = oldPaddingHeight;
	-- end
	
	-- if (math.abs(newPaddingRight - oldPaddingWidth) > 0.5) or (math.abs(newPaddingBottom - oldPaddingHeight) > 0.5) then
		-- tip:SetPadding(newPaddingRight, newPaddingBottom, tt.padding.left, tt.padding.top);
	-- end
end

-- Strip textures form object
local function StripTextures(obj)
	local nineSlicePieces = { -- keys have to match pieceNames in nineSliceSetup table in "NineSlice.lua"
		"TopLeftCorner",
		"TopRightCorner",
		"BottomLeftCorner",
		"BottomRightCorner",
		"TopEdge",
		"BottomEdge",
		"LeftEdge",
		"RightEdge",
		"Center"
	};

	for index, pieceName in ipairs(nineSlicePieces) do
		local region = obj[pieceName];
		if (region) then
			region:SetTexture(nil);
		end
	end
end

-- Applies the backdrop, color and border color. The GTT will often reset these internally.
function tt:ApplyTipBackdrop(tip, calledFromEvent, resetBackdropColor)
	if (not cfg.enableBackdrop) then
		return;
	end
	
	-- remove default tip backdrop
	if (tip.NineSlice) then
		StripTextures(tip.NineSlice);

		tip.NineSlice.layoutType = nil;
		tip.NineSlice.layoutTextureKit = nil;
		tip.NineSlice.backdropInfo = nil;
	end
	
	tip.layoutType = nil;
	tip.layoutTextureKit = nil;
	tip.backdropInfo = nil;
	
	if (IsAddOnLoaded("ElvUI_MerathilisUI")) then -- workaround for addon MerathilisUI in ElvUI to prevent styling of frame
		tip.__shadow = true;
		tip.__MERSkin = true;
	end
	
	local tipName = tip:GetName();
	
	if (tipName) and (tipName:match("DropDownList(%d+)")) then
		local dropDownListBackdrop = _G[tipName.."Backdrop"];
		local dropDownListMenuBackdrop = _G[tipName.."MenuBackdrop"];
		
		StripTextures(dropDownListBackdrop);
		if (dropDownListBackdrop.Bg) then
			dropDownListBackdrop.Bg:SetTexture(nil);
		end
		StripTextures(dropDownListMenuBackdrop.NineSlice);
		
		if (IsAddOnLoaded("ElvUI")) then -- workaround for addon ElvUI to prevent applying of frame:StripTextures()
			tip.template = "Default";
			dropDownListBackdrop.template = "Default";
			dropDownListMenuBackdrop.template = "Default";
		end
		
		if (IsAddOnLoaded("ElvUI_MerathilisUI")) then -- workaround for addon MerathilisUI in ElvUI to prevent styling of frame
			dropDownListBackdrop.__MERSkin = true;
			dropDownListMenuBackdrop.__MERSkin = true;
		end
	end
	
	-- apply tip backdrop
	tt:SetBackdropLocked(tip, tipBackdrop);
	
	if (resetBackdropColor) then
		tt:ResetBackdropBorderColorLocked(tip);
	else
		tt:SetBackdropColorLocked(tip, false, tipBackdrop.backdropColor:GetRGBA());
		tt:SetBackdropBorderColorLocked(tip, false, tipBackdrop.backdropBorderColor:GetRGBA());
	end
	
	-- apply padding
	tt:SetPadding(tip, calledFromEvent);
end

-- Checks chain of frames, if a frame named like "patterns" or like specified frame exists.
local function IsInFrameChain(frame, patternsOrFrame, maxLevel)
	local currentFrame = frame;
	local currentLevel = 1;
	
	while (currentFrame) do
		if (type(currentFrame.GetName) ~= "function") then
			return false;
		end
		
		local currentFrameName = currentFrame:GetName();
		
		for _, patternOrFrame in ipairs(patternsOrFrame) do
			if (patternOrFrame) then
				local typePatternOrFrame = type(patternOrFrame);
				
				if ((typePatternOrFrame == "string") and (currentFrameName) and (currentFrameName:match(patternOrFrame))) or
						((typePatternOrFrame == "table") and (currentFrame == patternOrFrame)) then
					return true;
				end
			end
		end
		
		if (maxLevel) and (currentLevel == maxLevel) then
			return false;
		end
		
		currentFrame = currentFrame:GetParent();
		currentLevel = currentLevel + 1;
	end
	
	return false;
end

-- Get The Anchor Position Depending on the Tip Content and Parent Frame
-- Do not depend on "ttUnit.token" here, as it might not have been cleared yet!
-- Checking "mouseover" here isn't ideal due to actionbars, it will sometimes return true because of selfcast.
-- valid anchor types: normal/mouse/parent
-- anchor points: standard UI anchor point
local function GetAnchorPosition(tooltip)
	if not cfg then return "normal", "BOTTOMRIGHT" end --abyui
	local mouseFocus = GetMouseFocus();
	local isUnit = (tooltip.ttDisplayingUnit) or (not tooltip.ttDisplayingAura) and (UnitExists("mouseover") or (mouseFocus and mouseFocus.GetAttribute and mouseFocus:GetAttribute("unit")));	-- Az: GetAttribute("unit") here is bad, as that will find things like buff frames too
	local frameName = (mouseFocus == WorldFrame and "World" or "Frame")..(isUnit and "Unit" or "Tip");
	local var = "anchor"..frameName;
	if fixInCombat() and cfg[var.."Type"] == "mouse" then return "normal", "BOTTOMRIGHT" end --abyui --TODO:abyui10
	local anchorOverrideInCombat = (cfg["enableAnchorOverride" .. frameName .. "InCombat"] and UnitAffectingCombat("player") and "InCombat" or "");
	local ttAnchorType, ttAnchorPoint = cfg[var.."Type"..anchorOverrideInCombat], cfg[var.."Point"..anchorOverrideInCombat];
	
	-- check for GTT anchor overrides
	if (tooltip == gtt) then
		-- override GTT anchor for (Guild & Community) ChatFrame
		if (cfg.enableAnchorOverrideCF) and (IsInFrameChain(tooltip:GetOwner(), {
					"ChatFrame(%d+)",
					(IsAddOnLoaded("Blizzard_Communities") and CommunitiesFrame.Chat.MessageFrame)
				}, 1)) then
			return cfg.anchorOverrideCFType, cfg.anchorOverrideCFPoint;
		end
		
		-- don't anchor GTT (frame tip type) in "Premade Groups->LFGList" to mouse if addon RaiderIO is loaded
		if (frameName == "FrameTip") and (ttAnchorType == "mouse") and (IsAddOnLoaded("RaiderIO")) and (IsInFrameChain(tooltip:GetOwner(), {
					LFGListFrame.SearchPanel.ScrollBox,
					LFGListFrame.ApplicationViewer.ScrollBox
				}, 6)) then
			return "normal", "BOTTOMRIGHT";
		end
		
		-- workaround for bug in RaiderIO: https://github.com/RaiderIO/raiderio-addon/issues/203
		if (frameName == "FrameTip") and (ttAnchorType == "mouse") and (IsAddOnLoaded("RaiderIO")) and IsAddOnLoaded("Blizzard_Communities") and (IsInFrameChain(tooltip:GetOwner(), {
					CommunitiesFrame.MemberList.ScrollBox
				}, 3)) then
			return "normal", "BOTTOMRIGHT";
		end
	end
	
	return ttAnchorType, ttAnchorPoint;
end

-- Get offsets for anchor point
local function GetOffsetsForAnchorPoint(ttAnchorPoint)
	if (ttAnchorPoint == "TOPLEFT") then
		return (tt:GetLeft() - UIParent:GetLeft()) / cfg.gttScale, (tt:GetTop() - UIParent:GetTop()) / cfg.gttScale;
	elseif (ttAnchorPoint == "TOPRIGHT") then
		return (tt:GetRight() - UIParent:GetRight()) / cfg.gttScale, (tt:GetTop() - UIParent:GetTop()) / cfg.gttScale;
	elseif (ttAnchorPoint == "BOTTOMLEFT") then
		return (tt:GetLeft() - UIParent:GetLeft()) / cfg.gttScale, (tt:GetBottom() - UIParent:GetBottom()) / cfg.gttScale;
	elseif (ttAnchorPoint == "BOTTOMRIGHT") then
		return (tt:GetRight() - UIParent:GetRight()) / cfg.gttScale, (tt:GetBottom() - UIParent:GetBottom()) / cfg.gttScale;
	elseif (ttAnchorPoint == "TOP") then
		return (tt:GetLeft() + tt:GetRight() - UIParent:GetLeft() - UIParent:GetRight()) / 2 / cfg.gttScale, (tt:GetTop() - UIParent:GetTop()) / cfg.gttScale;
	elseif (ttAnchorPoint == "BOTTOM") then
		return (tt:GetLeft() + tt:GetRight() - UIParent:GetLeft() - UIParent:GetRight()) / 2 / cfg.gttScale, (tt:GetBottom() - UIParent:GetBottom()) / cfg.gttScale;
	elseif (ttAnchorPoint == "LEFT") then
		return (tt:GetLeft() - UIParent:GetLeft()) / cfg.gttScale, (tt:GetTop() + tt:GetBottom() - UIParent:GetTop() - UIParent:GetBottom()) / 2 / cfg.gttScale;
	elseif (ttAnchorPoint == "RIGHT") then
		return (tt:GetRight() - UIParent:GetRight()) / cfg.gttScale, (tt:GetTop() + tt:GetBottom() - UIParent:GetTop() - UIParent:GetBottom()) / 2 / cfg.gttScale;
	elseif (ttAnchorPoint == "CENTER") then
		return (tt:GetLeft() + tt:GetRight() - UIParent:GetLeft() - UIParent:GetRight()) / 2 / cfg.gttScale, (tt:GetTop() + tt:GetBottom() - UIParent:GetTop() - UIParent:GetBottom()) / 2 / cfg.gttScale;
	end
end

-- Set default anchor
local function SetDefaultAnchor(tooltip, parent, noSetOwner)
	-- Return if no tooltip or parent
	if (not tooltip or not parent) then
		return;
	end

	-- Get the current anchoring type and point based on the frame under the mouse and anchor settings
	tooltip.ttAnchorType, tooltip.ttAnchorPoint = GetAnchorPosition(tooltip);

	-- We only hook the GameTooltip, so if any other tips use the default anchor with mouse anchoring,
	-- we have to just set it here statically, as we wont have the OnUpdate hooked for that tooltip
	if (tooltip ~= gtt) and (tooltip.ttAnchorType == "mouse") then
		if (not noSetOwner) then
			tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT", mouseOffsetX, mouseOffsetY);
		end
	else
		-- Since TipTac handles all the anchoring, we want to use "ANCHOR_NONE" here
		if (not noSetOwner) then
			tooltip:SetOwner(parent, "ANCHOR_NONE");
		else
			local gttAnchor = tooltip:GetAnchorType();
			if (gttAnchor ~= "ANCHOR_NONE") then
				tooltip:SetAnchorType("ANCHOR_NONE");
			end
		end
		tooltip:ClearAllPoints();

		if (tooltip.ttAnchorType == "mouse") then
			-- Although we anchor the frame continuously in OnUpdate, we must anchor it initially here to avoid flicker on the first frame its being shown
			tt:AnchorFrameToMouse(tooltip);
		elseif (tooltip.ttAnchorType == "parent") and (parent ~= UIParent) then
			-- anchor to the opposite edge of the parent frame
			tooltip:SetPoint(TT_MirrorAnchorsSmart[tooltip.ttAnchorPoint] or TT_MirrorAnchors[tooltip.ttAnchorPoint],parent,tooltip.ttAnchorPoint);
		else
			-- "normal" anchor or fallback for "parent" in case its UIParent
			-- tooltip:SetPoint(tooltip.ttAnchorPoint,tt); -- caused some "Action[SetPoint] failed because[SetPoint would result in anchor family connection]" errors
			local offsetX, offsetY = GetOffsetsForAnchorPoint(tooltip.ttAnchorPoint);
			tooltip:SetPoint(tooltip.ttAnchorPoint, UIParent, offsetX, offsetY);
		end
	end
end

-- Anchor any given frame to mouse position
function tt:AnchorFrameToMouse(frame)
	local x, y = GetCursorPosition();
	local effScale = frame:GetEffectiveScale();
	frame:ClearAllPoints();
	frame:SetPoint(frame.ttAnchorPoint, UIParent, "BOTTOMLEFT", (x / effScale + mouseOffsetX), (y / effScale + mouseOffsetY));
end

-- Re-anchor for anchor type mouse
function tt:ReApplyAnchorTypeForMouse(frame, noUpdateAnchorPosition, ignoreWorldTips)
	-- Anchor GTT to Mouse (no anchoring e.g. for tooltips from AddModifiedTip() or compare items)
	-- This prevents wrong initial positioning of item tooltip if "Anchors->Frame Tip Type" = "Mouse Anchor" e.g. on opening character frame and mouse is already over the position of an appearing item.
	if (not noUpdateAnchorPosition) then
		frame.ttAnchorType, frame.ttAnchorPoint = GetAnchorPosition(frame);
	end
	
	if (frame.ttAnchorType == "mouse") and (frame:GetObjectType() == "GameTooltip") and (not TT_NoReApplyAnchorFor[frame:GetName()]) then
		local gttAnchor = frame:GetAnchorType();
		if (ignoreWorldTips) and ((gttAnchor == "ANCHOR_CURSOR") or (gttAnchor == "ANCHOR_CURSOR_RIGHT")) then
			return;
		end
		if (gttAnchor ~= "ANCHOR_NONE") then
			-- Since TipTac handles all the anchoring, we want to use "ANCHOR_NONE" here
			frame:SetAnchorType("ANCHOR_NONE");
		end
		tt:AnchorFrameToMouse(frame);
	end
end

-- Removes lines from the tooltip which are unwanted, such as "PvP", "Alliance", "Horde"
-- Also removes the coalesced realm line(s), which I am unsure is still in BfA?
function tt:RemoveUnwantedLines(tip)
	for i = 2, tip:NumLines() do
		local line = _G["GameTooltipTextLeft"..i];
		local text = line:GetText();
		if (cfg.hidePvpText) and (text == PVP_ENABLED) or (cfg.hideFactionText and (text == FACTION_ALLIANCE or text == FACTION_HORDE)) then
			line:SetText(nil);
		end
		if (cfg.hideRealmText) and (text == " ") then
			local nextLine = _G["GameTooltipTextLeft"..(i + 1)];
			if (nextLine) then
				local nextText = nextLine:GetText();
				if (nextText == COALESCED_REALM_TOOLTIP) or (nextText == INTERACTIVE_REALM_TOOLTIP) then
					line:SetText(nil);
					nextLine:SetText(nil);
				end
			end
		end
	end
end

-- Get Reaction Index
--[[
	1 = Tapped
	2 = Hostile
	3 = Caution
	4 = Neutral
	5 = Friendly NPC or PvP Player
	6 = Friendly Player
	7 = Dead
--]]
function tt:GetUnitReactionIndex(unit)
	-- Deadies
	if (UnitIsDead(unit)) then
		return 7;
	-- Players (Can't rely on UnitPlayerControlled() alone, since it always returns nil on units out of range)
	elseif (UnitIsPlayer(unit) or UnitPlayerControlled(unit)) then
		if (UnitCanAttack(unit,"player")) then
			return (UnitCanAttack("player",unit) and 2 or 3);
		elseif (UnitCanAttack("player",unit)) then
			return 4;
		elseif (UnitIsPVP(unit) and not UnitIsPVPSanctuary(unit) and not UnitIsPVPSanctuary("player")) then
			return 5;
		else
			return 6;
		end
	-- Tapped -- The UNIT_FACTION event is fired when this changes (not for mouseover however) -- [7.0.3] API change: Tap functions has been condensed into a single function
	elseif (UnitIsTapDenied(unit)) and not (UnitPlayerControlled(unit)) then
		return 1;
	-- Others
	else
		local reaction = (UnitReaction(unit,"player") or 3);
		return (reaction > 5 and 5) or (reaction < 2 and 2) or (reaction);
	end
end

-- Add "Targeted By" line
function tt:AddTargetedBy(u)
	local numUnits, inGroup, inRaid, nameplates;
	
	local numGroup = GetNumGroupMembers();
	if (numGroup) and (numGroup >= 1) then
		numUnits = numGroup;
		inGroup = true;
		inRaid = IsInRaid();
	else
		nameplates = C_NamePlate.GetNamePlates();
		numUnits = #nameplates;
		inGroup = false;
	end
	
	for i = 1, numUnits do
		local unit = inGroup and (inRaid and "raid"..i or "party"..i) or (nameplates[i].namePlateUnitToken or "nameplate"..i);
		if (UnitIsUnit(unit.."target", u.token)) and (not UnitIsUnit(unit, "player")) then
			local _, classFile = UnitClass(unit);
			targetedByList.next = TT_ClassColorMarkup[classFile];
			targetedByList.next = UnitName(unit);
			targetedByList.next = "|r, ";
		end
	end

	if (targetedByList.count > 0) then
		targetedByList.last = nil;		-- remove last comma
		gtt:AddLine(" ",nil,nil,nil,1);
		local line = _G["GameTooltipTextLeft"..gtt:NumLines()];
		line:SetFormattedText(L"Targeted By (|cffffffff%d|r): %s",(targetedByList.count + 1) / 3,targetedByList:Concat());
		targetedByList:Clear();
	end
end

-- Apply Unit Appearance
-- Styling the unit tooltip happens in three stages, 1) pre-style 2) style 3) post-style
function tt:ApplyUnitAppearance(tip,first)
	-- obtain unit properties
	if (first) then
		tip.ttUnit.isPlayer = UnitIsPlayer(tip.ttUnit.token);
		tip.ttUnit.class, tip.ttUnit.classFile = UnitClass(tip.ttUnit.token);
	end
	tip.ttUnit.reactionIndex = self:GetUnitReactionIndex(tip.ttUnit.token);

	--------------------------------------------------
	-- [1] Send style event BEFORE tip has been styled
	self:SendElementEvent("OnPreStyleTip",tip,first);
	--------------------------------------------------

	-- Backdrop Color: Reaction
	if (cfg.reactColoredBackdrop) then
		tt:SetBackdropColorLocked(tip, true, unpack(cfg["colReactBack"..tip.ttUnit.reactionIndex]));
	end

	-- Backdrop Border Color: By Class or by Reaction
	if (cfg.classColoredBorder) and (tip.ttUnit.isPlayer) then
		if (first) then
			local classColor = CLASS_COLORS[tip.ttUnit.classFile] or CLASS_COLORS["PRIEST"];
			tt:SetBackdropBorderColorLocked(tip, true, classColor.r, classColor.g, classColor.b);
		end
	elseif (cfg.reactColoredBorder) then	-- Az: this will override the classColoredBorder config, perhaps have that option take priority instead?
		tt:SetBackdropBorderColorLocked(tip, true, unpack(cfg["colReactBack"..tip.ttUnit.reactionIndex]));
	end

	-- Remove Unwanted Lines
	if (first) and (cfg.hidePvpText or cfg.hideFactionText or cfg.hideRealmText) then
		self:RemoveUnwantedLines(tip);
	end

	--------------------------------------------------
	-- [2] Send the actual TipTac Appearance Styling event
	if (cfg.showUnitTip) then
		self:SendElementEvent("OnStyleTip",tip,first);
	end
	--------------------------------------------------

	if (first) and (cfg.showTargetedBy) then
		self:AddTargetedBy(tip.ttUnit);
	end

	-- Calling tip:Show() here ensures that the tooltip has the correct dimensions.
	-- However, forcing it to show here could cause issues, and we should properly wait
	-- until OnShow before we post the final OnPostStyleTip event.
	--printf("[%.2f] %-24s %d x %d",GetTime(),"PreShow",tip:GetWidth(),tip:GetHeight())
	tip:Show();
	--printf("[%.2f] %-24s %d x %d",GetTime(),"PostShow",tip:GetWidth(),tip:GetHeight())

	--------------------------------------------------
	-- [3] Send style event AFTER tip has been styled
	self:SendElementEvent("OnPostStyleTip",tip,first);
	--------------------------------------------------
	
	-- reapply tooltip padding. padding might have been modified to fit health/power bars.
	tt:SetPadding(tip);
end

-- HOOK: CommunitiesFrame.MemberList:OnEnter
local function CFML_OnEnter_Hook(self)
	if (cfg.classColoredBorder) and (gtt:IsShown()) then
		local classColor = CLASS_COLORS["PRIEST"];
		local memberInfo = self.memberInfo;
		if (memberInfo) then
			local classID = memberInfo.classID;
			if (classID) then
				local classInfo = C_CreatureInfo.GetClassInfo(classID);
				if (classInfo) then
					classColor = CLASS_COLORS[classInfo.classFile] or CLASS_COLORS["PRIEST"];
				end
			end
		end
		tt:SetBackdropBorderColorLocked(gtt, true, classColor.r, classColor.g, classColor.b);
	end
end

-- HOOK: DisplayDungeonScoreLink, see "ItemRef.lua"
local function IRTT_DisplayDungeonScoreLink(link)
	if (cfg.classColoredBorder) and (irtt:IsShown()) then
		local splits = StringSplitIntoTable(":", link);
		
		--Bad Link, Return.
		if (not splits) then
			return;
		end
		
		local playerClass = splits[5];
		local className, classFileName = GetClassInfo(playerClass);
		local classColor = C_ClassColor.GetClassColor(classFileName);

		tt:SetBackdropBorderColorLocked(irtt, true, classColor.r, classColor.g, classColor.b);
	end
end

-- HOOK: LFGListFrame.ApplicationViewer.ScrollBox:OnEnter respectively LFGListApplicantMember_OnEnter, see "LFGList.lua"
local function LFGLFAVSB_OnEnter_Hook(self)
	if (cfg.classColoredBorder) and (gtt:IsShown()) then
		local applicantID = self:GetParent().applicantID;
		local memberIdx = self.memberIdx;
		
		local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel = C_LFGList.GetApplicantMemberInfo(applicantID, memberIdx);
		
		if (name) then
			local classColor = RAID_CLASS_COLORS[class];
			tt:SetBackdropBorderColorLocked(gtt, true, classColor.r, classColor.g, classColor.b);
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                      GameTooltip Script Hooks                                      --
--------------------------------------------------------------------------------------------------------

--[[
	GameTooltip Construction Call Order -- Tested for BfA (18.07.24)
	This is apparently the order in which the GTT construsts unit tips
	------------------------------------------------------------------
	- GameTooltip_SetDefaultAnchor()    -- called e.g. for units and mailboxes. won't initially be called for buffs or vendor signs.
	- GTT.OnTooltipSetUnit()			-- GetUnit() aka TooltipUtil.GetDisplayedUnit() becomes valid here
	- GTT:Show()						-- Will Resize the tip
	- GTT.OnShow()						-- Event triggered in response to the Show() function. won't be called if tooltip of world unit isn't faded yet and moving mouse over it again or someone else.
	- GTT.OnTooltipCleared()			-- Tooltip has been cleared and is ready to show new information, doesn't mean it's hidden
--]]

-- table with GameTooltip scripts to hook into (k = scriptName, v = hookFunction)
local gttScriptHooks = {};

-- FadeOut constants
local FADE_ENABLE = 1;
local FADE_BLOCK = 2;

-- Function to hide tooltip
local function isHideTip(tooltip, calledFromEvent)
	-- Hides the tip (in combat) if one of those options are set. Also checks if the Shift key is pressed, and cancels hiding of the tip (if that option is set, that is)
	if (not cfg.showHiddenTipsOnShift) or (not IsShiftKeyDown()) then
		local isInCombat = UnitAffectingCombat("player");
		
		if (cfg.hideTips == "all") or (cfg.hideTipsInCombat == "all") and (isInCombat) then
			return true;
		end
		if (isInCombat) then
			if (cfg.hideTipsInCombat == "all") then
				return true;
			end
		end
		
		if (calledFromEvent == "OnTooltipSetUnit") then
			local isUIParentOwner = (tooltip:GetOwner() == UIParent);
			
			if (cfg.hideTips == "fwu") or (cfg.hideTips == "fu") and (not isUIParentOwner) or (cfg.hideTips == "wu") and (isUIParentOwner) then
				return true
			end
			
			if (isInCombat) then
				if (cfg.hideTipsInCombat == "fwu") or (cfg.hideTipsInCombat == "fu") and (not isUIParentOwner) or (cfg.hideTipsInCombat == "wu") and (isUIParentOwner) then
					return true;
				end
			end
		end
	end
	
	return false;
end

-- EventHook: OnShow
function gttScriptHooks:OnShow()
	-- Check if tooltip has to be set hidden
	if (isHideTip(self, "OnShow")) then
		self:Hide();
	end
	
	-- reapply padding needed here since df
	tt:SetPadding(self, "OnShow");

	-- Anchor GTT to Mouse -- Az: Initial mouse anchoring is now being done in GTT_SetDefaultAnchor (remove if there are no issues)

    --abyui 注释掉会导致gtt_anchorType局部变量混乱，可能使用的不是实际的配置，注意最后的Hook也是用这个函数 (原版注释掉一段代码, abyui取消注释, Frozn45版本另写，暂时采用)

	-- Frozn45: Needed a.o. for the following issue:
	-- 1. Set "Anchors->Frame Tip Type" to "Mouse Anchor"
	-- 2. Mount a flying mount
	-- 3. Fly straight ahead with forward key pressed
	-- 4. Open the world map and navigate to maw
	-- 5. Hover with mouse over Torghast and see that the tooltip sometimes flicker between "Normal Anchor" and "Mouse Anchor" only during forward movement.
	tt:ReApplyAnchorTypeForMouse(self, false, true);

	-- Ensures that default anchored world frame tips have the proper color, their internal function seems to set them to a dark blue color
	-- Tooltips from world objects that change cursor seems to also require this. (Tested in 8.0/BfA)
	-- if (self:IsOwned(UIParent)) and (not tt:GetDisplayedUnit(self)) then
		-- tt:SetBackdropColorLocked(self, false, unpack(cfg.tipColor));
	-- end
end

-- EventHook: OnUpdate
function gttScriptHooks:OnUpdate(elapsed)
	-- This ensures that mouse anchored world frame tips have the proper color, their internal function seems to set them to a dark blue color
	-- local gttAnchor = self:GetAnchorType();
	-- if (gttAnchor == "ANCHOR_CURSOR") or (gttAnchor == "ANCHOR_CURSOR_RIGHT") then
		-- tt:SetBackdropColorLocked(self, false, unpack(cfg.tipColor));
		-- tt:SetBackdropBorderColorLocked(self, false, unpack(cfg.tipBorderColor));
		-- return;
	-- else
	-- Anchor GTT to Mouse (no anchoring e.g. for tooltips from AddModifiedTip() or compare items)
	tt:ReApplyAnchorTypeForMouse(self, true, true);
	
	-- WoD: This background color reset, from OnShow(), has been copied down here. It seems resetting the color in OnShow() wasn't enough, as the color changes after the tip is being shown
	-- if (self:IsOwned(UIParent)) and (not tt:GetDisplayedUnit(self)) then
		-- tt:SetBackdropColorLocked(self, false, unpack(cfg.tipColor));
	-- end

	-- Fadeout / Update Tip if Showing a Unit
	-- Do not allow (ttFadeOut == FADE_BLOCK), as that is only for non overridden fadeouts
	if (self.ttUnit) and (self.ttUnit.token) and (self.ttFadeOut ~= FADE_BLOCK) then
		self.ttLastUpdate = ((self.ttLastUpdate or 0) + elapsed);
		if (self.ttFadeOut) then
			self:Show(); -- Overrides self:FadeOut()
			if (self.ttLastUpdate > cfg.fadeTime + cfg.preFadeTime) then
				self.ttFadeOut = nil;
				self:Hide();
			elseif (self.ttLastUpdate > cfg.preFadeTime) then
				self:SetAlpha(1 - (self.ttLastUpdate - cfg.preFadeTime) / cfg.fadeTime);
			end
		-- Do nothing if mouse button is down, because the following check for UnitExists("mouseover") incorrectly returns false if hovering over a world unit.
		elseif (IsMouseButtonDown()) then
		-- This is only really needed for worldframe unit tips, as when self.ttUnit.token == "mouseover", the GTT:FadeOut() function is not called
		elseif (not UnitExists(self.ttUnit.token)) then
			self:FadeOut();
		elseif (cfg.updateFreq > 0) then
			local gttCurrentLines = self:NumLines();
			-- If number of lines differ from last time, force an update. This became an issue in 5.4 as the coalesced realm text is added after the initial Show(). This might also fix some incompatibilities with other addons.
			if (self.ttLastUpdate > cfg.updateFreq) or (gttCurrentLines ~= self.ttNumLines) then
				self.ttNumLines = gttCurrentLines;
				self.ttLastUpdate = 0;
				tt:ApplyUnitAppearance(self);
			end
		end
	end
end

-- EventHook: OnTooltipSetUnit
function gttScriptHooks:OnTooltipSetUnit()
	-- Check if tooltip has to be set hidden
	if (isHideTip(self, "OnTooltipSetUnit")) then
		self:Hide();
	end
	
	self.ttUnit = {};
	
	local _, unit = tt:GetDisplayedUnit(self);

	-- Concated unit tokens such as "targettarget" cannot be returned as the unit by GTT:GetUnit() aka TooltipUtil.GetDisplayedUnit(GTT),
	-- and it will return as "mouseover", but the "mouseover" unit is still invalid at this point for those unitframes!
	-- To overcome this problem, we look if the mouse is over a unitframe, and if that unitframe has a unit attribute set?
	if (not unit) then
		local mouseFocus = GetMouseFocus();
		unit = mouseFocus and mouseFocus.GetAttribute and mouseFocus:GetAttribute("unit");
	end

	-- A mage's mirror images sometimes doesn't return a unit, this would fix it
	if (not unit) and (UnitExists("mouseover")) then
		unit = "mouseover";
	end

	-- Sometimes when you move your mouse quicky over units in the worldframe, we can get here without a unit
	if (not unit) then
		self:Hide();
		return;
	end

	-- A "mouseover" unit is better to have as we can then safely say the tip should no longer show when it becomes invalid. Harder to say with a "party2" unit.
	-- This also helps fix the problem that "mouseover" units aren't valid for group members out of range, a bug that has been in WoW since 3.0.2 I think.
	if (UnitIsUnit(unit,"mouseover")) then
		unit = "mouseover";
	end

	-- Workaround for OnTooltipCleared not having fired
	self.ttFadeOut = nil; -- Az: Sometimes this wasn't getting reset, the fact a cleanup isn't performed at this point, now that it was moved to "OnTooltipCleared" is bad, so this is a fix [8.0/BfA/18.08.12 - Still not cleared 100% of the time]

	-- We're done, apply appearance
	self.ttUnit.token = unit;
	tt:ApplyUnitAppearance(self,true);	-- called with "first" arg to true
end

-- EventHook: OnTooltipCleared -- This will clean up auras, bars, raid icon and vars for the gtt when we aren't showing a unit
function gttScriptHooks:OnTooltipCleared()
	-- reset the padding that might have been modified to fit health/power bars
	tt:SetPaddingVariables();
	tt:SetPadding(self, "OnTooltipCleared");

	-- WoD: resetting the back/border color seems to be a necessary action, otherwise colors may stick when showing the next tooltip thing (world object tips)
	-- BfA: The tooltip now also clears the backdrop in adition to color and bordercolor, so set it again here
	tt:ResetBackdropBorderColorLocked(self);

	-- wipe the vars
	if (self.ttUnit) then
		wipe(self.ttUnit);
	end
	self.ttLastUpdate = 0; -- time since last update
	self.ttNumLines = 0; -- number of lines at last check, if this differs from gtt:NumLines() an update should be performed. Only used for unit tips with extra padding.
	self.ttFadeOut = nil;
	self.ttDefaultAnchored = false;
	self.ttDisplayingUnit = false;
	self.ttDisplayingAura = false;

	-- post cleared event to elements
	tt:SendElementEvent("OnCleared",self);
end

-- EventHook: OnTooltipSetItem
function gttScriptHooks:OnTooltipSetItem()
	tt:ReApplyAnchorTypeForMouse(self);
end

-- OnHide Script -- Used to default the background and border color -- Az: May cause issues with embedded tooltips, see GameTooltip.lua:396
function gttScriptHooks:OnHide()
	tt:ApplyTipBackdrop(self, "OnHide", true);
end

--------------------------------------------------------------------------------------------------------
--                                      GameTooltip Other Hooks                                       --
--------------------------------------------------------------------------------------------------------

-- HOOK: GTT:FadeOut -- This allows us to check when the tip is fading out.
-- This function might have been made secure in 8.2?
local gttFadeOut = gtt.FadeOut;
gtt.FadeOut = function(self,...)
	if (not self.ttUnit) or (not self.ttUnit.token) or (not cfg.overrideFade) then
		self.ttFadeOut = FADE_BLOCK; -- Don't allow the OnUpdate handler to run the fadeout/update code
		gttFadeOut(self,...);
	elseif (cfg.preFadeTime == 0 and cfg.fadeTime == 0) then
		self:Hide();
	else
		self.ttFadeOut = FADE_ENABLE;
		self.ttLastUpdate = 0;
	end
end

-- HOOK: GameTooltip_SetDefaultAnchor
local function GTT_SetDefaultAnchor(tooltip,parent)
	-- Return if no tooltip or parent
	if (not tooltip or not parent) then
		return;
	end
	
	SetDefaultAnchor(tooltip, parent);

	-- "ttDefaultAnchored" will flag the tooltip as having been anchored using the default anchor
	tooltip.ttDefaultAnchored = true;
end

-- HOOK: GameTooltip_AddQuestRewardsToTooltip
-- commented out for embedded tooltips, see description in tt:SetPadding()
-- local function GTT_AddQuestRewardsToTooltip(tooltip)
	-- -- reapply padding if modified
	-- if (tooltip:GetObjectType() == "GameTooltip") then
		-- --tt:SetPadding(tooltip);
	-- end
-- end

-- HOOK: GameTooltip_CalculatePadding
-- commented out for embedded tooltips, see description in tt:SetPadding()
-- local function GTT_CalculatePadding(tooltip)
	-- -- reapply padding if modified
	-- if (tooltip:GetObjectType() == "GameTooltip") then
		-- tt:SetPadding(tooltip, "GameTooltip_CalculatePadding");
	-- end
-- end

-- HOOK: QuestUtils_AddQuestRewardsToTooltip
-- added helper function for embedded tooltips, see description in tt:SetPadding()
local function QU_AddQuestRewardsToTooltip(tooltip, questID, style)
	-- reset padding to fix displaying of embedded tooltips
	if (tooltip.ItemTooltip and tooltip.ItemTooltip:IsShown()) then
		GameTooltip_CalculatePadding(tooltip);
	end
end

-- HOOK: GameTooltip:SetUnit()
local function GTT_SetUnit(self)
	-- "ttDisplayingUnit" will flag the tooltip that it is currently showing a unit
	self.ttDisplayingUnit = true;
	self.ttDisplayingAura = false;
	
	SetDefaultAnchor(self, self:GetOwner(), true);
end

-- HOOK: GameTooltip:SetUnitAura()
local function GTT_SetUnitAura(self)
	-- "ttDisplayingAura" will flag the tooltip that it is currently showing an aura
	self.ttDisplayingAura = true;
	self.ttDisplayingUnit = false;

	tt:ReApplyAnchorTypeForMouse(self);
end

-- HOOK: GameTooltip:SetToyByItemID()
local function GTT_SetToyByItemID(self)
	tt:ReApplyAnchorTypeForMouse(self);
end

-- HOOK: QuestPinMixin:OnMouseEnter()
local function QPM_OnMouseEnter_Hook(self)
	tt:ReApplyAnchorTypeForMouse(gtt);
end

-- HOOK: QuestBlobPinMixin:UpdateTooltip()
local function QBPM_UpdateTooltip_Hook(self)
	tt:ReApplyAnchorTypeForMouse(gtt);
end

-- HOOK: WardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems(), see WardrobeItemsCollectionMixin:UpdateItems() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
local function WCFICF_UpdateItems_Hook(self)
	if (C_Transmog.IsAtTransmogNPC()) and (gtt:IsShown()) then
		tt:ReApplyAnchorTypeForMouse(gtt);
	end
end

-- HOOK: RuneforgePowerBaseMixin:OnEnter(), see in "Blizzard_Collections/Blizzard_Wardrobe.lua"
local function RPBM_OnEnter_Hook(self)
	if (gtt:IsShown()) then
		tt:ReApplyAnchorTypeForMouse(gtt);
	end
end

--------------------------------------------------------------------------------------------------------
--                      BattlePetTooltip / EncounterJournalTooltip Script Hooks                       --
--------------------------------------------------------------------------------------------------------

--[[
	BattlePetTooltip / EncounterJournalTooltip Construction Call Order
	------------------------------------------------------------------
	- GameTooltip_SetDefaultAnchor()        -- 
	- BPTT/EJTT:Show()					    -- Will Resize the tip
	- BPTT/EJTT.OnShow()					-- Event triggered in response to the Show() function
	- BPTT/EJTT.OnHide()		           	-- Tooltip has been hidden
--]]

-- table with BattlePetTooltip / EncounterJournalTooltip scripts to hook into (k = scriptName, v = hookFunction)
local bpttEjttScriptHooks = {};

-- EventHook: OnShow
function bpttEjttScriptHooks:OnShow()
	self.ttAnchorType, self.ttAnchorPoint = GetAnchorPosition(self);
end

-- EventHook: OnUpdate
function bpttEjttScriptHooks:OnUpdate(elapsed)
	-- Anchor BPTT / EJTT to Mouse
	if (self.ttAnchorType == "mouse") then
		tt:AnchorFrameToMouse(self);
	end
end

-- EventHook: OnHide
function bpttEjttScriptHooks:OnHide()
	tt:ResetBackdropBorderColorLocked(self);
end

--------------------------------------------------------------------------------------------------------
--          PetJournalPrimaryAbilityTooltip / PetJournalSecondaryAbilityTooltip Script Hooks          --
--------------------------------------------------------------------------------------------------------

--[[
	PetJournalPrimaryAbilityTooltip / PetJournalSecondaryAbilityTooltip Construction Call Order
	------------------------------------------------------------------
	- PJATT:Show()					    -- Will Resize the tip
	- PJATT.OnShow()					-- Event triggered in response to the Show() function
	- PJATT.OnHide()		           	-- Tooltip has been hidden
--]]

-- table with PetJournalPrimaryAbilityTooltip / PetJournalSecondaryAbilityTooltip scripts to hook into (k = scriptName, v = hookFunction)
local pjattScriptHooks = {};

-- EventHook: OnShow
function pjattScriptHooks:OnShow()
	self.ttAnchorType, self.ttAnchorPoint = GetAnchorPosition(self);

	-- Anchor PJATT to Mouse
	if (self.ttAnchorType == "mouse") then
		tt:AnchorFrameToMouse(self);
	end
end

-- EventHook: OnUpdate
function pjattScriptHooks:OnUpdate(elapsed)
	-- Anchor PJATT to Mouse
	if (self.ttAnchorType == "mouse") then
		tt:AnchorFrameToMouse(self);
	end
end

-- HOOK: SharedPetBattleAbilityTooltip_UpdateSize()
local function SPBATT_UpdateSize(self)
	-- re-hook OnUpdate for PetJournalPrimaryAbilityTooltip and PetJournalSecondaryAbilityTooltip
	if (self == pjpatt) or (self == pjsatt) then
		self:HookScript("OnUpdate", pjattScriptHooks.OnUpdate);
	end
end

-- EventHook: OnHide
function pjattScriptHooks:OnHide()
	tt:ResetBackdropBorderColorLocked(self);
end

--------------------------------------------------------------------------------------------------------
--                                             Hook Tips                                              --
--------------------------------------------------------------------------------------------------------

-- Function to add a locking feature for SetBackdrop, SetBackdropColor and SetBackdropBorderColor
function tt:AddLockingFeature(tip)
	--do return end --cause serious taint abyui
	if (not cfg.enableBackdrop) then
		return;
	end
	
	local tip_ApplyBackdrop_org = tip.ApplyBackdrop;
	local tip_SetBackdrop_org = tip.SetBackdrop;
	local tip_SetBackdropColor_org = tip.SetBackdropColor;
	local tip_SetBackdropBorderColor_org = tip.SetBackdropBorderColor;
	
	tip.ApplyBackdrop = function(self, ...)
		if (self.ttSetBackdropLocked) then
			return;
		end
		if (tip_ApplyBackdrop_org) then
			tip_ApplyBackdrop_org(self, ...);
		end
	end
	tip.SetBackdrop = function(self, ...)
		if (self.ttSetBackdropLocked) then
			return;
		end
		if (tip_SetBackdrop_org) then
			tip_SetBackdrop_org(self, ...);
		end
	end
	tip.SetBackdropColor = function(self, ...)
		if (self.ttSetBackdropColorLocked) then
			return;
		end
		if (tip_SetBackdropColor_org) then
			tip_SetBackdropColor_org(self, ...);
		end
	end
	tip.SetBackdropBorderColor = function(self, ...)
		if (self.ttSetBackdropBorderColorLocked) then
			return;
		end
		if (tip_SetBackdropBorderColor_org) then
			tip_SetBackdropBorderColor_org(self, ...);
		end
	end
	
	if (tip.NineSlice) then
		local tip_NineSlice_ApplyBackdrop_org = tip.NineSlice.ApplyBackdrop;
		local tip_NineSlice_SetBackdrop_org = tip.NineSlice.SetBackdrop;
		local tip_NineSlice_SetBackdropColor_org = tip.NineSlice.SetBackdropColor;
		local tip_NineSlice_SetBackdropBorderColor_org = tip.NineSlice.SetBackdropBorderColor;
		local tip_NineSlice_SetCenterColor_org = tip.NineSlice.SetCenterColor;
		local tip_NineSlice_SetBorderColor_org = tip.NineSlice.SetBorderColor;
		
		tip.NineSlice.ApplyBackdrop = function(self, ...)
			if (self:GetParent().ttSetBackdropLocked) then
				return;
			end
			if (tip_NineSlice_ApplyBackdrop_org) then
				tip_NineSlice_ApplyBackdrop_org(self, ...);
			end
		end
		tip.NineSlice.SetBackdrop = function(self, ...)
			if (self:GetParent().ttSetBackdropLocked) then
				return;
			end
			if (tip_NineSlice_SetBackdrop_org) then
				tip_NineSlice_SetBackdrop_org(self, ...);
			end
		end
		tip.NineSlice.SetBackdropColor = function(self, ...)
			if (self:GetParent().ttSetBackdropColorLocked) then
				return;
			end
			if (tip_NineSlice_SetBackdropColor_org) then
				tip_NineSlice_SetBackdropColor_org(self, ...);
			end
		end
		tip.NineSlice.SetBackdropBorderColor = function(self, ...)
			if (self:GetParent().ttSetBackdropBordeColorLocked) then
				return;
			end
			if (tip_NineSlice_SetBackdropBordeColor_org) then
				tip_NineSlice_SetBackdropBordeColor_org(self, ...);
			end
		end
		tip.NineSlice.SetCenterColor = function(self, ...)
			if (self:GetParent().ttSetBackdropColorLocked) then
				return;
			end
			if (tip_NineSlice_SetCenterColor_org) then
				tip_NineSlice_SetCenterColor_org(self, ...);
			end
		end
		tip.NineSlice.SetBorderColor = function(self, ...)
			if (self:GetParent().ttSetBackdropBorderColorLocked) then
				return;
			end
			if (tip_NineSlice_SetBorderColor_org) then
				tip_NineSlice_SetBorderColor_org(self, ...);
			end
		end
	end
end

-- Function to apply necessary hooks to tips
function tt:ApplyHooksToTips(tips, resolveGlobalNamedObjects, addToTipsToModify)
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
				TT_TipsToModify[#TT_TipsToModify + 1] = tip;
			end
			
			if (tip:GetObjectType() == "GameTooltip") then
				for scriptName, hookFunc in next, gttScriptHooks do
					if (TooltipDataProcessor) then -- since df 10.0.2
						if (scriptName == "OnTooltipSetUnit") then
							TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(self, ...)
								if (self == tip) then
									gttScriptHooks.OnTooltipSetUnit(self, ...);
								end
							end);
						elseif (scriptName == "OnTooltipSetItem") then
							TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(self, ...)
								if (self == tip) then
									gttScriptHooks.OnTooltipSetItem(self, ...);
								end
							end);
						else
							tip:HookScript(scriptName, hookFunc);
						end
					else -- before df 10.0.2
						tip:HookScript(scriptName, hookFunc);
					end
				end

				-- Post-Hook GameTooltip:SetUnit() to flag the tooltip that it is currently showing a unit
				hooksecurefunc(tip, "SetUnit", GTT_SetUnit);

				-- Post-Hook GameTooltip:SetUnitAura/Buff/Debuff() to prevent flickering of tooltips over buffs if "Anchors->Frame Tip Type" = "Mouse Anchor"
				hooksecurefunc(tip, "SetUnitAura", GTT_SetUnitAura);
				hooksecurefunc(tip, "SetUnitBuff", GTT_SetUnitAura);
				hooksecurefunc(tip, "SetUnitDebuff", GTT_SetUnitAura);
				
				if (isWoWSl) or (isWoWRetail) then
					-- Post-Hook GameTooltip:SetToyByItemID() to prevent flickering of tooltips if scrolling over toys from last page to previous page and "Anchors->Frame Tip Type" = "Mouse Anchor"
					hooksecurefunc(tip, "SetToyByItemID", GTT_SetToyByItemID);
				end
				
				if (tipName == "GameTooltip") then
					-- Replace GameTooltip_SetDefaultAnchor() (For Re-Anchoring) -- Patch 3.2 made this function secure
					hooksecurefunc("GameTooltip_SetDefaultAnchor", GTT_SetDefaultAnchor);
					--C_Timer.After(0.1, function() GameTooltip_SetDefaultAnchor(GameTooltip, UIParent) end) --没有这句，鼠标直接放BUFF上不跟随 --TODO:abyui10
					
					-- Post-Hook SharedTooltip_SetBackdropStyle() to reapply backdrop (e.g. needed for OnTooltipSetItem() or AreaPOIPinMixin:OnMouseEnter() on world map (e.g. Torghast) or VignettePin on world map (e.g. weekly event in Maw))
					hooksecurefunc("SharedTooltip_SetBackdropStyle", STT_SetBackdropStyle);
					
					-- Post-Hook QuestPinMixin:OnMouseEnter() to re-anchor tooltip (e.g. quests on world map with numeric banner) if "Anchors->Frame Tip Type" = "Mouse Anchor"
					hooksecurefunc(QuestPinMixin, "OnMouseEnter", QPM_OnMouseEnter_Hook);
					
					-- Post-Hook TaskPOI_OnEnter() to reapply padding if modified
					-- commented out for embedded tooltips, see description in tt:SetPadding()
					-- hooksecurefunc("TaskPOI_OnEnter", function(self)
					  -- tt:SetPadding(gtt, "GameTooltip_AddQuestRewardsToTooltip");
					-- end);
					
					-- Post-Hook QuestBlobPinMixin:UpdateTooltip() (OnMouseEnter() doesn't work) to re-anchor tooltip (blue area of quests) if "Anchors->Frame Tip Type" = "Mouse Anchor"
					for pin in WorldMapFrame:EnumeratePinsByTemplate("QuestBlobPinTemplate") do
						hooksecurefunc(pin, "UpdateTooltip", QBPM_UpdateTooltip_Hook);
					end
					
					-- Post-Hook GameTooltip_AddQuestRewardsToTooltip() to reapply padding if modified
					-- commented out for embedded tooltips, see description in tt:SetPadding()
					-- hooksecurefunc("GameTooltip_AddQuestRewardsToTooltip", GTT_AddQuestRewardsToTooltip);
					
					-- Post-Hook GameTooltip_CalculatePadding() to reapply padding if modified
					-- commented out for embedded tooltips, see description in tt:SetPadding()
					-- hooksecurefunc("GameTooltip_CalculatePadding", GTT_CalculatePadding);
					
					if (isWoWSl) or (isWoWRetail) then
						-- Post-Hook QuestUtils_AddQuestRewardsToTooltip() to reset padding to fix displaying of embedded tooltips
						-- added helper function for embedded tooltips, see description in tt:SetPadding()
						hooksecurefunc("QuestUtils_AddQuestRewardsToTooltip", QU_AddQuestRewardsToTooltip);
						
						-- Post-Hook RuneforgePowerBaseMixin:OnEnter() to re-anchor tooltip in adventure journal if "Anchors->Frame Tip Type" = "Mouse Anchor" and scrolling up and down, see WardrobeItemsCollectionMixin:UpdateItems() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
						hooksecurefunc(RuneforgePowerBaseMixin, "OnEnter", RPBM_OnEnter_Hook);

						-- Function to apply necessary hooks to LFGListFrame.ApplicationViewer to apply class colors
						tt:ApplyHooksToLFGLFAVSB();
						
						hooksecurefunc("LFGListApplicationViewer_UpdateApplicant", function(button, applicantID)
							tt:ApplyHooksToLFGLFAVSB(button, applicantID);
						end);
						
						hooksecurefunc("LFGListApplicantMember_OnEnter", LFGLFAVSB_OnEnter_Hook);
					end
				elseif (tipName == "ItemRefTooltip") then
					if (isWoWSl) or (isWoWRetail) then
						-- Post-Hook DisplayDungeonScoreLink() to apply class colors
						hooksecurefunc("DisplayDungeonScoreLink", IRTT_DisplayDungeonScoreLink);
					end
				end
				tipHooked = true;
			elseif (tip:GetObjectType() == "Frame") then
				if (tipName == "BattlePetTooltip") then
					for scriptName, hookFunc in next, bpttEjttScriptHooks do
						tip:HookScript(scriptName, hookFunc);
					end
					tipHooked = true;
				elseif (IsAddOnLoaded("Blizzard_Collections")) and ((tipName == "PetJournalPrimaryAbilityTooltip") or (tipName == "PetJournalSecondaryAbilityTooltip")) then
					for scriptName, hookFunc in next, pjattScriptHooks do
						tip:HookScript(scriptName, hookFunc);
					end
					if (tipName == "PetJournalPrimaryAbilityTooltip") then
						-- Post-Hook SharedPetBattleAbilityTooltip_UpdateSize() to re-hook OnUpdate for PetJournalPrimaryAbilityTooltip and PetJournalSecondaryAbilityTooltip
						hooksecurefunc("SharedPetBattleAbilityTooltip_UpdateSize", SPBATT_UpdateSize);
					end
					tipHooked = true;
				elseif (IsAddOnLoaded("Blizzard_EncounterJournal")) and (tipName == "EncounterJournalTooltip") then
					for scriptName, hookFunc in next, bpttEjttScriptHooks do
						tip:HookScript(scriptName, hookFunc);
					end
					tipHooked = true;
				elseif (tipName == "FriendsTooltip") then
					tipHooked = true;
				end
			elseif (tip:GetObjectType() == "Button") then
				if (tipName:match("DropDownList(%d+)")) then
					tipHooked = true;
				end
			end
			
			if (tipHooked) then
				tt:AddLockingFeature(tip);
			end
		end
	end
end

-- Function to apply necessary hooks to LFGListFrame.ApplicationViewer.ScrollBox respectively LFGListApplicantMember_OnEnter()
local LFGLFAVSBhooked = {};

local function ApplyHooksToLFGLFAVSB(button, applicantID)
	local applicantInfo = C_LFGList.GetApplicantInfo(applicantID);
	for i = 1, applicantInfo.numMembers do
		local member = button.Members[i];
		if (not LFGLFAVSBhooked[member]) then
			member:HookScript("OnEnter", LFGLFAVSB_OnEnter_Hook);
			LFGLFAVSBhooked[member] = true;
		end
	end
end

function tt:ApplyHooksToLFGLFAVSB(button, applicantID)
	if (button) then
		ApplyHooksToLFGLFAVSB(button, applicantID); -- see LFGListApplicationViewer_UpdateApplicant() in "LFGList.lua"
	else
		local self = LFGListFrame.ApplicationViewer; -- see LFGListApplicationViewer_UpdateResults() + LFGListApplicationViewer_OnEvent() in "LFGList.lua"
		if (self.applicants) then
			for index = 1, #self.applicants do
				local applicantID = self.applicants[index];
				local frame = self.ScrollBox:FindFrameByPredicate(function(frame, elementData)
					return elementData.id == applicantID;
				end);
				if frame then
					ApplyHooksToLFGLFAVSB(button, applicantID);
				end
			end
		end
	end
end

-- Function to loop through tips to modify and hook during VARIABLES_LOADED
function tt:HookTips()
	-- Hooks needs to be applied as late as possible during load, as we want to try and be the
	-- last addon to hook "OnTooltipSetUnit" so we always have a "completed" tip to work on
	self:ApplyHooksToTips(TT_TipsToModify, true);
	
	-- hook their OnHide script -- Az: OnHide hook disabled for now
--	for index, tipName in ipairs(TT_TipsToModify) do
--		if (type(tip) == "table") and (type(tip.GetObjectType) == "function") then
--			tip:HookScript("OnHide",gttScriptHooks.OnHide);
--		end
--	end

	-- Clear this function as it's not needed anymore
	self.HookTips = nil;
end

-- AddOn Loaded
function tt:ADDON_LOADED(event, addOnName)
	if (not cfg) then return end;
	
	-- check if addon is already loaded
	if (TT_AddOnsLoaded[addOnName] == nil) or (TT_AddOnsLoaded[addOnName]) then
		return;
	end
	
	-- now LibQTip might be available
	if (addOnName == "TipTac") then
		if (LibQTip) then
			local LibQTip_Acquire_org = LibQTip.Acquire;
			LibQTip.Acquire = function(self, key, ...)
				local tooltip = LibQTip_Acquire_org(self, key, ...);
				tt:AddModifiedTip(tooltip, true);
				return tooltip;
			end
		end
	end
	-- now PetJournalPrimaryAbilityTooltip and PetJournalSecondaryAbilityTooltip exist
	if (addOnName == "Blizzard_Collections") or ((addOnName == "TipTac") and (IsAddOnLoaded("Blizzard_Collections")) and (not TT_AddOnsLoaded['Blizzard_Collections'])) then
		pjpatt = PetJournalPrimaryAbilityTooltip;
		pjsatt = PetJournalSecondaryAbilityTooltip;
		
		-- Hook Tips & Apply Settings
		self:ApplyHooksToTips({
			"PetJournalPrimaryAbilityTooltip",
			"PetJournalSecondaryAbilityTooltip"
		}, true, true);

		self:ApplySettings();

		-- Post-Hook WardrobeCollectionFrame.ItemsCollectionFrame:UpdateItems() to re-anchor tooltip at transmogrifier if "Anchors->Frame Tip Type" = "Mouse Anchor" and selecting items, see WardrobeItemsCollectionMixin:UpdateItems() in "Blizzard_Collections/Blizzard_Wardrobe.lua"
		hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame, "UpdateItems", WCFICF_UpdateItems_Hook);
		
		if (addOnName == "TipTac") then
			TT_AddOnsLoaded["Blizzard_Collections"] = true;
		end
	end
	-- now CommunitiesGuildNewsFrame exists
	if (addOnName == "Blizzard_Communities") or ((addOnName == "TipTac") and (IsAddOnLoaded("Blizzard_Communities")) and (not TT_AddOnsLoaded['Blizzard_Communities'])) then
		-- Function to apply necessary hooks to CommunitiesFrame.MemberList to apply class colors
		hooksecurefunc(CommunitiesMemberListEntryMixin, "OnEnter", CFML_OnEnter_Hook);
		
		if (addOnName == "TipTac") then
			TT_AddOnsLoaded["Blizzard_Communities"] = true;
		end
	end
	-- now ContributionBuffTooltip exists
	if (addOnName == "Blizzard_Contribution") or ((addOnName == "TipTac") and (IsAddOnLoaded("Blizzard_Contribution")) and (not TT_AddOnsLoaded['Blizzard_Contribution'])) then
		-- Hook Tips & Apply Settings
		self:ApplyHooksToTips({
			"ContributionBuffTooltip"
		}, true, true);

		self:ApplySettings();
		
		if (addOnName == "TipTac") then
			TT_AddOnsLoaded["Blizzard_Contribution"] = true;
		end
	end
	-- now EncounterJournalTooltip exists
	if (addOnName == "Blizzard_EncounterJournal") or ((addOnName == "TipTac") and (IsAddOnLoaded("Blizzard_EncounterJournal")) and (not TT_AddOnsLoaded['Blizzard_EncounterJournal'])) then
		ejtt = EncounterJournalTooltip;
		
		-- Hook Tips & Apply Settings
		-- commented out for embedded tooltips, see description in tt:SetPadding()
		-- self:ApplyHooksToTips({
			-- "EncounterJournalTooltip"
		-- }, true, true);

		-- self:ApplySettings();
		
		if (addOnName == "TipTac") then
			TT_AddOnsLoaded["Blizzard_EncounterJournal"] = true;
		end
	end
	-- now RaiderIO_ProfileTooltip and RaiderIO_SearchTooltip exist
	if (addOnName == "RaiderIO") or ((addOnName == "TipTac") and (IsAddOnLoaded("RaiderIO")) and (not TT_AddOnsLoaded['RaiderIO'])) then
		-- Hook Tips & Apply Settings
		C_Timer.After(1, function()
			self:ApplyHooksToTips({
				"RaiderIO_ProfileTooltip",
				"RaiderIO_SearchTooltip"
			}, true, true);
			
			self:ApplySettings();
		end);
		
		if (addOnName == "TipTac") then
			TT_AddOnsLoaded["RaiderIO"] = true;
		end
	end
	
	TT_AddOnsLoaded[addOnName] = true;
	
	-- Cleanup if all addons are loaded
	local allAddOnsLoaded = true;
	
	for addOn, isLoaded in pairs(TT_AddOnsLoaded) do
		if (not isLoaded) then
			allAddOnsLoaded = false;
			break;
		end
	end
	
	if (allAddOnsLoaded) then
		self:UnregisterEvent(event);
		self[event] = nil;
	end
end

-- Allows other mods to "register" tooltips or frames to be modified by TipTac
function tt:AddModifiedTip(tip,noHooks)
	if (type(tip) == "string") then
		tip = _G[tip];
	end
	if (type(tip) == "table") and (type(tip.GetObjectType) == "function") then
		-- if this tooltip is already modified, abort
		if (tIndexOf(TT_TipsToModify,tip)) then
			return;
		end
		if (type(tip) == "table" and BackdropTemplateMixin and "BackdropTemplate") then
			Mixin(tip, BackdropTemplateMixin);
			if (tip.NineSlice) then
				Mixin(tip.NineSlice, BackdropTemplateMixin);
			end
		end
		TT_TipsToModify[#TT_TipsToModify + 1] = tip;

		-- Az: Disabled the OnHide hook, unsure if it needs to be re-enabled,
--		if (not noHooks) then
--			tip:HookScript("OnHide",gttScriptHooks.OnHide);
--		end
		
		if (not noHooks) then
			tip:HookScript("OnShow", function()
				tt:ApplyTipBackdrop(tip, "AddModifiedTip");
			end);
		end

		tt:AddLockingFeature(tip);

		-- Apply Settings
		self:ApplySettings();
	end
end

--------------------------------------------------------------------------------------------------------
--                                    Bugfixes for SetPoint errors                                    --
--------------------------------------------------------------------------------------------------------

-- HOOK: GameTooltip_SetDefaultAnchor -- fix for: FrameXML\GameTooltip.lua:161: Action[SetPoint] failed because[SetPoint would result in anchor family connection]: attempted from: GameTooltip:SetPoint
-- deactivated because of tainting GameTooltip_SetDefaultAnchor() by TipTac, see https://github.com/frozn/TipTac/issues/62
-- local GameTooltip_SetDefaultAnchor_org = GameTooltip_SetDefaultAnchor;
-- GameTooltip_SetDefaultAnchor = function(self, ...)
	-- self:ClearAllPoints();
	-- GameTooltip_SetDefaultAnchor_org(self, ...);
-- end

-- HOOK: GarrisonLandingPageReportMission_OnEnter -- fix for: Blizzard_GarrisonUI\Blizzard_GarrisonLandingPage.lua:870: Action[SetPoint] failed because[SetPoint would result in anchor family connection]: attempted from: GameTooltip:SetPoint
local GarrisonLandingPageReportMission_OnEnter_org = GarrisonLandingPageReportMission_OnEnter;
GarrisonLandingPageReportMission_OnEnter = function(self, ...)
	self:ClearAllPoints();
	GarrisonLandingPageReportMission_OnEnter_org(self, ...);
end

--abyui 鼠标提示闪烁, 延迟加载是因为要在其他hook之后(例如TipTacItemRef) --TODO:abyui10
--[[
hooksecurefunc(GameTooltip, "Show", gttScriptHooks.OnShow)
C_Timer.After(1, function()
    hooksecurefunc(GameTooltip, "SetUnitAura", gttScriptHooks.OnShow)
end)
--]]
