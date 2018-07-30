local function fixInCombat()
    return InCombatLockdown() and U1GetCfgValue("tiptac/disableMouseFollowWhenCombat")
end

CoreOnEvent("PLAYER_REGEN_DISABLED", function()
    if U1GetCfgValue("tiptac/disableMouseFollowWhenCombat") then GameTooltip:Hide() end
end)

local L = LibStub("AceLocale-3.0"):GetLocale("TipTac")

--[[
	18.07.24 BfA fix notes
	- Disabled all references to "gtt_newHeight", as its being replaced with gtt:SetPadding()
	- Remove the gttShow hook as it no longer contains any code.
	- Remove the TipHook_OnHide hook as it no longer contains any code.
--]]

local _G = getfenv(0);
local abs = abs;
local gtt = GameTooltip;
local UnitExists = UnitExists;
local unpack = unpack;

-- Addon
local modName = ...;
local tt = CreateFrame("Frame",modName,UIParent);

-- Global Chat Message Function
function AzMsg(msg) DEFAULT_CHAT_FRAME:AddMessage(tostring(msg):gsub("|1","|cffffff80"):gsub("|2","|cffffffff"),0.5,0.75,1.0); end

-- Config Data Variables
local cfg;
local TT_DefaultConfig = {
	showUnitTip = true,
	showStatus = true,
	showGuildRank = false,
	showTargetedBy = true,
	showPlayerGender = false,
	nameType = "title",
	showRealm = "show",
	showTarget = "last",
	targetYouText = L["<<YOU>>"],

	showBattlePetTip = true,
	gttScale = 1,
	updateFreq = 0.5,
	enableChatHoverTips = false,
	hideFactionText = false,
	hideRealmText = false,

	colorGuildByReaction = true,
	colGuild = "|cff0080cc",
	colSameGuild = "|cffff32ff",
	colRace = "|cffffffff",
	colLevel = "|cffc0c0c0",
	colorNameByClass = false,
	classColoredBorder = false,

	reactText = false,
	colReactText1 = "|cffc0c0c0",
	colReactText2 = "|cffff0000",
	colReactText3 = "|cffff7f00",
	colReactText4 = "|cffffff00",
	colReactText5 = "|cff00ff00",
	colReactText6 = "|cff25c1eb",
	colReactText7 = "|cff808080",

	reactColoredBackdrop = false,
	reactColoredBorder = false,
	colReactBack1 = { 0.2, 0.2, 0.2 },
	colReactBack2 = { 0.3, 0, 0 },
	colReactBack3 = { 0.3, 0.15, 0 },
	colReactBack4 = { 0.3, 0.3, 0 },
	colReactBack5 = { 0, 0.3, 0.1 },
	colReactBack6 = { 0, 0, 0.5 },
	colReactBack7 = { 0.05, 0.05, 0.05 },

	tipBackdropBG = "Interface\\Buttons\\WHITE8X8",
	tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
	backdropEdgeSize = 14,
	backdropInsets = 2.5,

	tipColor = { 0.1, 0.1, 0.2 },			-- UI Default: For most: (0.1,0.1,0.2), World Objects?: (0,0.2,0.35)
	tipBorderColor = { 0.3, 0.3, 0.4 },		-- UI Default: (1,1,1,1)
	gradientTip = true,
	gradientColor = { 0.8, 0.8, 0.8, 0.2 },

	modifyFonts = false,
	fontFace = "",	-- Set during VARIABLES_LOADED
	fontSize = 12,
	fontFlags = "",
	fontSizeDelta = 2,

	classification_minus = L["-%s "],		-- New classification in MoP; Unsure what it's used for, but apparently the units have no mana. Example of use: The "Sha Haunts" early in the Horde's quests in Thunder Hold.
	classification_trivial = L["~%s "],
	classification_normal = L["%s "],
	classification_elite = L["+%s "],
	classification_worldboss = L["%s|r (Boss) "],
	classification_rare = L["%s|r (Rare) "],
	classification_rareelite = L["+%s|r (Rare) "],

	overrideFade = true,
	preFadeTime = 0.1,
	fadeTime = 0.1,
	hideWorldTips = true,

	barFontFace = "",	-- Set during VARIABLES_LOADED
	barFontSize = 12,
	barFontFlags = "OUTLINE",
	barHeight = 6,
	barTexture = "Interface\\TargetingFrame\\UI-StatusBar",

	hideDefaultBar = true,
	barsCondenseValues = false,
	barsCondenseType = "wanyi",

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

	mouseOffsetX = 0,
	mouseOffsetY = 0,

	hideUFTipsInCombat = false,
	hideAllTipsInCombat = false,
	showHiddenTipsOnShift = false,

	showTalents = true,
	talentOnlyInParty = false,
	talentFormat = 1,
	talentCacheSize = 25,

	if_enable = true,
	if_infoColor = { 0.2, 0.6, 1 },
	if_itemQualityBorder = true,
	if_showAuraCaster = true,
	if_showItemLevelAndId = true,				-- Used to be true, but changed due to the itemLevel issues
	if_showQuestLevelAndId = true,
	if_showSpellIdAndRank = false,
	if_showCurrencyId = true,					-- Az: no option for this added to TipTac/options yet!
	if_showAchievementIdAndCategory = false,	-- Az: no option for this added to TipTac/options yet!
	if_modifyAchievementTips = true,
	if_showIcon = true,
	if_smartIcons = true,
	if_borderlessIcons = false,
	if_iconSize = 42,
};

-- ----------------------------------------
-- 爱不易设置showGuildRank
--    暴雪样式
for k,v in pairs({
	["fontSizeDelta"] = 2,
	["classification_elite"] = "|r等级 %s (精英)",
	["tipBackdropEdge"] = "Interface\\Tooltips\\UI-Tooltip-Border",
	["hideWorldTips"] = false,
	["backdropEdgeSize"] = 16,
	["tipBackdropBG"] = "Interface\\Tooltips\\UI-Tooltip-Background",
	["fontFlags"] = "",
	["tipColor"] = {
		0.09, -- [1]
		0.09, -- [2]
		0.19, -- [3]
		1, -- [4]
	},
	["hideDefaultBar"] = false,
	["healthBar"] = false,
	["colRace"] = "|cffffffff",
	["tipBorderColor"] = {
		1, -- [1]
		1, -- [2]
		1, -- [3]
		1, -- [4]
	},
	["classification_normal"] = "|r等级 %s",
	["colLevel"] = "|cffc0c0c0",
	["reactColoredBorder"] = false,
	["classification_minus"] = "|r等级 -%s",
	["fontSize"] = 12,
	["classification_rare"] = "|r等级 %s (稀有)",
	["colorGuildByReaction"] = true,
	["reactColoredBackdrop"] = false,
	["classification_trivial"] = "|r等级 ~%s",
	["classification_worldboss"] = "|r等级 %s (首领)",
	["manaBar"] = false,
	["classification_rareelite"] = "|r等级 %s (稀有精英)",
	["gradientTip"] = false,
	["fontFace"] = "Fonts\\FRIZQT__.TTF",
	["colorNameByClass"] = true,
	["classColoredBorder"] = true,
	["colSameGuild"] = "|cffff32ff",
	["backdropInsets"] = 5,
	["powerBar"] = false,
    ["showBattlePetTip"] = false,
}) do
	TT_DefaultConfig[k] = v
end
TT_DefaultConfig["showBuffs"] = false
TT_DefaultConfig["showDebuffs"] = false
TT_DefaultConfig["showGuildRank"] = true
TT_DefaultConfig["anchorFrameUnitType"] = "parent"
TT_DefaultConfig["anchorFrameTipType"] = "parent"
TT_DefaultConfig["anchorWorldUnitType"] = "mouse"
TT_DefaultConfig["anchorWorldTipType"] = "mouse"
TT_DefaultConfig["anchorWorldTipPoint"] = "TOPLEFT"
TT_DefaultConfig["anchorWorldUnitPoint"] = "TOPLEFT"
TT_DefaultConfig["anchorFrameTipPoint"] = "RIGHT"
TT_DefaultConfig["anchorFrameUnitPoint"] = "RIGHT"
TT_DefaultConfig["enableChatHoverTips"] = true
TT_DefaultConfig["barsCondenseValues"] = true
TT_DefaultConfig["if_showSpellIdAndRank"] = true
TT_DefaultConfig["overrideFade"] = true
TT_DefaultConfig["top"] = 777
TT_DefaultConfig["left"] = 30
TT_DefaultConfig["mouseOffsetX"] = 45
TT_DefaultConfig["mouseOffsetY"] = -110
TT_DefaultConfig["targetYouText"] = "|cffff0000<<你>>|r"
--
-- ----------------------------------------

-- Tips modified by TipTac in appearance and scale, you can add to this list if you want to modify more tips.
-- Other addons can use TipTac:AddModifiedTip(tip,noHooks) to register their own tooltips if desired.
local TT_TipsToModify = {
	"GameTooltip",
	"ShoppingTooltip1",
	"ShoppingTooltip2",
	"ItemRefTooltip",
	"ItemRefShoppingTooltip1",
	"ItemRefShoppingTooltip2",
	--"WorldMapTooltip",
	"WorldMapCompareTooltip1",
	"WorldMapCompareTooltip2",
	-- 3rd party addon tooltips
	"AtlasLootTooltip",
	"QuestHelperTooltip",
	"QuestGuru_QuestWatchTooltip",
};
tt.tipsToModify = TT_TipsToModify;

--local tipBackdrop = { tile = false, insets = {} };
-- Hi-jack the GTT backdrop table for our own evil needs
local tipBackdrop = GAME_TOOLTIP_BACKDROP_STYLE_DEFAULT;
tipBackdrop.backdropColor = CreateColor(1,1,1);
tipBackdrop.backdropBorderColor = CreateColor(1,1,1);

-- To ensure that the alpha channel is applied to the backdrop color, we have to cheat a bit, by pointing the GetRGB() function to GetRGBA().
tipBackdrop.backdropColor.GetRGB = ColorMixin.GetRGBA;
tipBackdrop.backdropBorderColor.GetRGB = ColorMixin.GetRGBA;

-- blizzards "GameTooltip_SetBackdropStyle" function will set the backdrop color using just RGB and no alpha, this fixes that
--hooksecurefunc("GameTooltip_SetBackdropStyle",function(self,style)
--	self:SetBackdropBorderColor((style.backdropBorderColor or TOOLTIP_DEFAULT_COLOR):GetRGBA());
--	self:SetBackdropColor((style.backdropColor or TOOLTIP_DEFAULT_BACKGROUND_COLOR):GetRGBA());
--end);

-- String Constants
local TT_LevelMatch = "^"..TOOLTIP_UNIT_LEVEL:gsub("%%s",".+"); -- Was changed to match other localizations properly, used to match: "^"..LEVEL.." .+" -- Az: doesn't actually match the level line on the russian client! 14.02.24: Doesn't match for Italian client either.
local TT_LevelMatchPet = "^"..TOOLTIP_WILDBATTLEPET_LEVEL_CLASS:gsub("%%s",".+");
local TT_NotSpecified = L["Not specified"];
local TT_Targeting = BINDING_HEADER_TARGETING;
local TT_Reaction = {
	L["Tapped"],					-- No localized string of this
	FACTION_STANDING_LABEL2,	-- Hostile
	FACTION_STANDING_LABEL3,	-- Unfriendly (Caution)
	FACTION_STANDING_LABEL4,	-- Neutral
	FACTION_STANDING_LABEL5,	-- Friendly
	FACTION_STANDING_LABEL5,	-- Friendly (Exalted)
	DEAD,						-- Dead
};

-- Colors
local CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;
local COL_WHITE = "|cffffffff";
local COL_LIGHTGRAY = "|cffc0c0c0";
local TT_ClassColors = {};
for class, color in next, CLASS_COLORS do
	TT_ClassColors[class] = ("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255);
end

-- Mirror Anchors
local TT_MirrorAnchors = {
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

local TT_MirrorAnchorsSmart = {
	TOPLEFT = "BOTTOMRIGHT",
	TOPRIGHT = "BOTTOMLEFT",
	BOTTOMLEFT = "TOPRIGHT",
	BOTTOMRIGHT = "TOPLEFT",
};

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
};

-- Valid units to filter the aurs in DisplayAuras() with the "cfg.selfAurasOnly" setting on
local validSelfCasterUnits = {
	player = true,
	pet = true,
	vehicle = true,
};

-- GTT Control Variables
local gtt_lastUpdate = 0;		-- time since last update
local gtt_numLines = 0;			-- number of lines at last check, if this differs from gtt:NumLines() an update should be performed
--local gtt_newHeight;			-- the new height of the tooltip, this value accommodates the inclusion of health/power bars inside the tooltip
local gtt_anchorType;			-- valid types: normal/mouse/parent
local gtt_anchorPoint;          -- standard UI anchor point

-- Data Variables
local isColorBlind;
local pLevel;
local u = {};
local lineOne = {};
local lineInfo = {};
local targetedList = {};
local auras = {};
local bars = {};
local tipIcon;
local petLevelLineIndex;

--------------------------------------------------------------------------------------------------------
--                                   TipTac Anchor Creation & Events                                  --
--------------------------------------------------------------------------------------------------------


local Corpse_COLORS = {r=0.54, g=0.54, b=0.54}	-- 尸体颜色（灰色）
local FACTION_COLORS = {
    [5]		= "33CC33",				-- 友好（绿色）
    [6]		= "33CCCC",				-- 尊敬（湖蓝）
    [7]		= "FF6633",				-- 崇敬（橙色）
    [8]		= "DD33DD",				-- 崇拜（紫色）
}

-- 转换颜色格式
local function ParseColor(color, hex)
    if hex then
        return format("%2x%2x%2x",color.r*255,color.g*255,color.b*255)
    else
        return color.r, color.g, color.b, 1
    end
end
-- 死亡或已被选取
local function DeadOrTapped(unit)
    --fix7 if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
    --fix7    return 1
    --fix7 else
    if (UnitHealth(unit) <= 0 and not UnitIsPlayer(unit))
            or (UnitIsPlayer(unit) and UnitIsDeadOrGhost(unit)) then
        return 2
    else
        return 0
    end
end

-- 获取阵营、声望
local function UnitFactionString(unit)
    local reaction = UnitReaction(unit, "player")
    if not reaction then return 0 end

    if reaction < 5 then
        tmp = ParseColor(FACTION_BAR_COLORS[reaction], true)
    else
        tmp = FACTION_COLORS[reaction]
    end
    if DeadOrTapped(unit) > 0 then
        tmp = ParseColor(Corpse_COLORS, true)
    end
    tmp2 = GetText("FACTION_STANDING_LABEL"..reaction, UnitSex("player"))
    return format("|cFF%s%s|r", tmp, tmp2)
end





tt:SetWidth(114);
tt:SetHeight(24);
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
tt.text:SetText(L["TipTacAnchor"]);
tt.text:SetPoint("LEFT",6,0);

tt.close = CreateFrame("Button",nil,tt,"UIPanelCloseButton");
tt.close:SetWidth(24);
tt.close:SetHeight(24);
tt.close:SetPoint("RIGHT");

-- Cursor Update -- The backup variable is a workaround so that gatherer addons can get the name of nodes
function tt:CURSOR_UPDATE(event)
	if (gtt:IsShown()) and (gtt:IsOwned(UIParent)) and (not u.token) then
		local backup = GameTooltipTextLeft1:GetText();
		gtt:Hide();
		GameTooltipTextLeft1:SetText(backup);
	end
end

-- Login -- Set Level
function tt:PLAYER_LOGIN(event)
	pLevel = UnitLevel("player");
	self[event] = nil;
end

-- Level Up -- Update Level
function tt:PLAYER_LEVEL_UP(event,newLevel)
	pLevel = newLevel;
end

-- Variables Loaded
function tt:VARIABLES_LOADED(event)
	isColorBlind = (GetCVar("colorblindMode") == "1");
	-- Default Fonts
	TT_DefaultConfig.fontFace = GameFontNormal:GetFont();
	TT_DefaultConfig.barFontFace = NumberFontNormal:GetFont();
	-- Init Config
	if (not TipTac_Config) then
		TipTac_Config = {};
	end
	cfg = setmetatable(TipTac_Config,{ __index = TT_DefaultConfig });
	-- Default the bar texture if it no longer exists
	bars[1]:SetStatusBarTexture(cfg.barTexture);
	if (not bars[1]:GetStatusBarTexture()) then
		cfg.barTexture = nil;
	end
	-- Hook Tips & Apply Settings
	self:HookTips();
	self:ApplySettings();
	-- Position
	if (cfg.left and cfg.top) then
		self:ClearAllPoints();
		self:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",cfg.left,cfg.top);
	else
		self:Show();
		-- Just set left and top here, in case the player just closes the anchor without moving, so it doesn't keep showing up when they log in
		cfg.left, cfg.top = self:GetLeft(), self:GetTop();
	end
	-- Cleanup
	self:UnregisterEvent(event);
	self[event] = nil;
end

-- Console Var Change
function tt:CVAR_UPDATE(event,var,value)
	if (var == "USE_COLORBLIND_MODE") then
		isColorBlind = (value == "1");
	end
end

tt:SetScript("OnMouseDown",tt.StartMoving);
tt:SetScript("OnMouseUp",function(self) self:StopMovingOrSizing(); cfg.left, cfg.top = self:GetLeft(), self:GetTop(); end);
tt:SetScript("OnEvent",function(self,event,...) self[event](self,event,...); end);

tt:RegisterEvent("PLAYER_LOGIN");
tt:RegisterEvent("PLAYER_LEVEL_UP");
tt:RegisterEvent("VARIABLES_LOADED");
tt:RegisterEvent("CVAR_UPDATE");

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
			if (TipTacOptions:IsShown()) then
				TipTacOptions:Hide();
			else
				TipTacOptions:Show();
			end
		else
			AzMsg(L["Could not open TicTac Options: |1"]..tostring(reason)..L["|r. Please make sure the addon is enabled from the character selection screen."]);
		end
	-- Show Anchor
	elseif (param1 == "anchor") then
		tt:Show();
	-- Reset settings
	elseif (param1 == "reset") then
		wipe(cfg);
		tt:ApplySettings();
		AzMsg("All |2"..modName.."|r settings has been reset to their default values.");
	-- Invalid or No Command
	else
		UpdateAddOnMemoryUsage();
		AzMsg(format("----- |2%s|r |1%s|r ----- |1%.2f |2kb|r -----",modName,GetAddOnMetadata(modName,"Version"),GetAddOnMemoryUsage(modName)));
		AzMsg(L["The following |2parameters|r are valid for this addon:"]);
		AzMsg(L[" |2anchor|r = Shows the anchor where the tooltip appears"]);
		AzMsg(L[" |2reset|r = Resets all settings back to their default values"]);
	end
end
--------------------------------------------------------------------------------------------------------
--                                         Modify Unit Tooltip                                        --
--------------------------------------------------------------------------------------------------------

-- Get Reaction Index
local function GetUnitReactionIndex(unit)
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
		return (reaction > 5 and 5) or (reaction < 2 and 2) or reaction;
	end
end

-- Returns the correct difficulty color compared to the player
local function GetDifficultyLevelColor(level)
	level = (level - pLevel);
	if (level > 4) then
		return "|cffff2020"; -- red
	elseif (level > 2) then
		return "|cffff8040"; -- orange
	elseif (level >= -2) then
		return "|cffffff00"; -- yellow
	elseif (level >= -GetQuestGreenRange()) then
		return "|cff40c040"; -- green
	else
		return "|cff808080"; -- gray
	end
end

-- Add target
local function AddTarget(lineList,targetName)
	local targetUnit = u.token.."target";
	if (UnitIsUnit("player",targetUnit)) then
		lineList[#lineList + 1] = COL_WHITE;
		lineList[#lineList + 1] = cfg.targetYouText;
	else
		local targetReaction = cfg["colReactText"..GetUnitReactionIndex(targetUnit)];
		lineList[#lineList + 1] = targetReaction;
		lineList[#lineList + 1] = "[";
		if (UnitIsPlayer(targetUnit)) then
			local _, targetClass = UnitClass(targetUnit);
			lineList[#lineList + 1] = (TT_ClassColors[targetClass] or COL_LIGHTGRAY);
			lineList[#lineList + 1] = targetName;
			lineList[#lineList + 1] = targetReaction;
		else
			lineList[#lineList + 1] = targetName;
		end
		lineList[#lineList + 1] = "]";
	end
end

-- Gather Unit Details
local function ModifyUnitTooltip()
	wipe(lineOne);
	wipe(lineInfo);
	local unit = u.token;
	local reaction = cfg["colReactText"..u.reactionIndex];
	local name, realm = UnitName(unit);
	local lineInfoIndex = 2 + (isColorBlind and UnitIsVisible(unit) and 1 or 0);
	local isPetWild, isPetCompanion = UnitIsWildBattlePet(unit), UnitIsBattlePetCompanion(unit);
	-- Level + Classification
	local level = (isPetWild or isPetCompanion) and UnitBattlePetLevel(unit) or UnitLevel(unit) or -1;
	local classification = UnitClassification(unit) or "";
	lineInfo[#lineInfo + 1] = (UnitCanAttack(unit,"player") or UnitCanAttack("player",unit)) and GetDifficultyLevelColor(level ~= -1 and level or 500) or cfg.colLevel;
	lineInfo[#lineInfo + 1] = (cfg["classification_"..classification] or "%s? "):format(level == -1 and "??" or level);
	-- Players
	if (u.isPlayer) then
		-- gender
		if (cfg.showPlayerGender) then
			local sex = UnitSex(unit);
			if (sex == 2) or (sex == 3) then
				lineInfo[#lineInfo + 1] = " ";
				lineInfo[#lineInfo + 1] = cfg.colRace;
				lineInfo[#lineInfo + 1] = (sex == 3 and L["Female"] or L["Male"]);
			end
		end
		-- race
		lineInfo[#lineInfo + 1] = " ";
		lineInfo[#lineInfo + 1] = cfg.colRace;
		lineInfo[#lineInfo + 1] = UnitRace(unit);
		-- class
		local class, classEng = UnitClass(unit);	-- Az: UnitClass() is called too many times in TipTac's code, cache it!
		lineInfo[#lineInfo + 1] = " ";
		lineInfo[#lineInfo + 1] = (TT_ClassColors[classEng] or COL_WHITE);
		lineInfo[#lineInfo + 1] = class;
		u.classEng = classEng;
		-- name
		lineOne[#lineOne + 1] = "|cffaaaaaa" -- (cfg.colorNameByClass and (TT_ClassColors[classEng] or COL_WHITE) or reaction);
		local line = (cfg.nameType == "marysueprot" and u.rpName) or (cfg.nameType == "original" and u.originalName) or (cfg.nameType == "title" and UnitPVPName(unit)) or name;
		local color = (cfg.colorNameByClass and (TT_ClassColors[classEng] or COL_WHITE) or reaction) 
		line = line:gsub(name, color .. name .. "|r")

		lineOne[#lineOne + 1] = line

		if (realm) and (realm ~= "") and (cfg.showRealm ~= "none") then
			if (cfg.showRealm == "show") then
				lineOne[#lineOne + 1] = " - ";
				lineOne[#lineOne + 1] = realm;
			else
				lineOne[#lineOne + 1] = " (*)";
			end
		end
		-- dc, afk or dnd
		if (cfg.showStatus) then
			local status = (not UnitIsConnected(unit) and L[" <DC>"]) or (UnitIsAFK(unit) and L[" <AFK>"]) or (UnitIsDND(unit) and L[" <DND>"]);
			if (status) then
				lineOne[#lineOne + 1] = COL_WHITE;
				lineOne[#lineOne + 1] = status;
			end
		end
		-- guild
		local guild, guildRank = GetGuildInfo(unit);
		if (guild) then
			local pGuild = GetGuildInfo("player");
			local guildColor = (guild == pGuild and cfg.colSameGuild or cfg.colorGuildByReaction and reaction or cfg.colGuild);
			GameTooltipTextLeft2:SetFormattedText(cfg.showGuildRank and guildRank and "%s<%s> %s%s" or "%s<%s>",guildColor,guild,COL_LIGHTGRAY,guildRank);
			lineInfoIndex = (lineInfoIndex + 1);
		end
	-- BattlePets
	elseif (cfg.showBattlePetTip) and (isPetWild or isPetCompanion) then
		lineOne[#lineOne + 1] = reaction;
		lineOne[#lineOne + 1] = name;
		lineInfo[#lineInfo + 1] = " ";
		lineInfo[#lineInfo + 1] = cfg.colRace;
		local petType = UnitBattlePetType(unit) or 5;
		lineInfo[#lineInfo + 1] = _G["BATTLE_PET_NAME_"..petType];
		if (isPetWild) then
			lineInfo[#lineInfo + 1] = " ";
			lineInfo[#lineInfo + 1] = UnitCreatureFamily(unit) or UnitCreatureType(unit);
		else
			if not (petLevelLineIndex) then
				for i = 2, gtt:NumLines() do
					local gttLineText = _G["GameTooltipTextLeft"..i]:GetText();
					if (type(gttLineText) == "string") and (gttLineText:find(TT_LevelMatchPet)) then
						petLevelLineIndex = i;
						break;
					end
				end
			end
			lineInfoIndex = petLevelLineIndex or 2;
			local expectedLine = 3 + (isColorBlind and 1 or 0);
			if (lineInfoIndex > expectedLine) then
				GameTooltipTextLeft2:SetFormattedText("%s<%s>",reaction,u.title);
			end
		end
	-- NPCs
	else
		-- name
		lineOne[#lineOne + 1] = reaction;
		lineOne[#lineOne + 1] = name;
		-- guild/title -- since WoD, npc title can be a single space character
		if (u.title) and (u.title ~= " ") then
			-- Az: this doesn't work with "Mini Diablo" or "Mini Thor", which has the format: 1) Mini Diablo 2) Lord of Terror 3) Player's Pet 4) Level 1 Non-combat Pet
			local gttLine = isColorBlind and GameTooltipTextLeft3 or GameTooltipTextLeft2;
			gttLine:SetFormattedText("%s<%s>",reaction,u.title);
			lineInfoIndex = (lineInfoIndex + 1);
		end
		-- class
		local class = UnitCreatureFamily(unit) or UnitCreatureType(unit);
		if (not class or class == TT_NotSpecified) then
			class = UNKNOWN;
		end
		lineInfo[#lineInfo + 1] = " ";
		lineInfo[#lineInfo + 1] = cfg.colRace;
		lineInfo[#lineInfo + 1] = class .. " " .. UnitFactionString(u.token) ;
	end
	-- Target
	if (cfg.showTarget ~= "none") then
		local targetUnit = unit.."target";
		local target = UnitName(targetUnit);
		if (target) and (target ~= UNKNOWNOBJECT and target ~= "" or UnitExists(targetUnit)) then
			if (cfg.showTarget == "first") then
				lineOne[#lineOne + 1] = COL_WHITE;
				lineOne[#lineOne + 1] = " : |r";
				AddTarget(lineOne,target);
			elseif (cfg.showTarget == "second") then
				lineOne[#lineOne + 1] = "\n  ";
				AddTarget(lineOne,target);
			elseif (cfg.showTarget == "last") then
				lineInfo[#lineInfo + 1] = L["\n|cffffd100Targeting: "];
				AddTarget(lineInfo,target);
			end
		end
	end
	-- Reaction Text
	if (cfg.reactText) then
		lineInfo[#lineInfo + 1] = "\n";
		lineInfo[#lineInfo + 1] = cfg["colReactText"..u.reactionIndex];
		lineInfo[#lineInfo + 1] = TT_Reaction[u.reactionIndex];
	end
	-- Line One
	GameTooltipTextLeft1:SetFormattedText(("%s"):rep(#lineOne),unpack(lineOne));
	-- Info Line
	local gttLine = _G["GameTooltipTextLeft"..lineInfoIndex];
	gttLine:SetFormattedText(("%s"):rep(#lineInfo),unpack(lineInfo));
	gttLine:SetTextColor(1,1,1);
end

-- Add "Targeted By" line
local function AddTargetedBy()
	local numGroup = GetNumGroupMembers();
	if (not numGroup) or (numGroup <= 1) then
		return;
	end
	local inRaid = IsInRaid();
	for i = 1, numGroup do
		local unit = (inRaid and "raid"..i or "party"..i);
		if (UnitIsUnit(unit.."target",u.token)) and (not UnitIsUnit(unit,"player")) then
			local _, class = UnitClass(unit);
			targetedList[#targetedList + 1] = TT_ClassColors[class];
			targetedList[#targetedList + 1] = UnitName(unit);
			targetedList[#targetedList + 1] = "|r, ";
		end
	end
	if (#targetedList > 0) then
		targetedList[#targetedList] = nil;		-- remove last comma
		gtt:AddLine(" ",nil,nil,nil,1);
		local line = _G["GameTooltipTextLeft"..gtt:NumLines()];
		line:SetFormattedText(L["Targeted By (|cffffffff%d|r): %s"],(#targetedList + 1) / 3,table.concat(targetedList));
		wipe(targetedList);
	end
end

--------------------------------------------------------------------------------------------------------
--                                        Health & Power Bars                                         --
--------------------------------------------------------------------------------------------------------

-- Make Two StatusBars
for i = 1, 2 do
	local bar = CreateFrame("StatusBar",nil,gtt);
	bar:SetWidth(0);	-- Az: As of patch 3.3.3, setting the initial size will somehow mess up the texture. Previously this initilization was needed to fix an anchoring issue.
	bar:SetHeight(0);

	bar.bg = bar:CreateTexture(nil,"BACKGROUND");
	bar.bg:SetColorTexture(0.3,0.3,0.3,0.6);
	bar.bg:SetAllPoints();

	bar.text = bar:CreateFontString(nil,"ARTWORK");
	bar.text:SetPoint("CENTER");
	bar.text:SetTextColor(1,1,1);

	bars[#bars + 1] = bar;
end

-- Configures the Health and Power Bars
local function SetupHealthAndPowerBar()
	u.powerType = UnitPowerType(u.token);
	-- Bar One: Health
	if (cfg.healthBar) then
		bars[1]:Show();
		if (u.isPlayer) and (cfg.healthBarClassColor) then
			local color = CLASS_COLORS[u.classEng] or CLASS_COLORS["PRIEST"];
			bars[1]:SetStatusBarColor(color.r,color.g,color.b);
		else
			bars[1]:SetStatusBarColor(unpack(cfg.healthBarColor));
		end
	else
		bars[1]:Hide();
	end
	-- Bar Two: Power
	if (UnitPowerMax(u.token,u.powerType) ~= 0) and (cfg.manaBar and u.powerType == 0 or cfg.powerBar and u.powerType ~= 0) then
		if (u.powerType == 0) then
			bars[2]:SetStatusBarColor(unpack(cfg.manaBarColor));
		else
			u.powerColor = PowerBarColor[u.powerType or 5];
			bars[2]:SetStatusBarColor(u.powerColor.r,u.powerColor.g,u.powerColor.b);
		end
		bars[2]:Show();
	else
		bars[2]:Hide();
	end
	-- Anchor Frames
	bars[2]:ClearAllPoints();
	bars[1]:ClearAllPoints();
	if (bars[2]:IsShown()) then
		bars[2]:SetPoint("BOTTOMLEFT",8,9);
		bars[2]:SetPoint("BOTTOMRIGHT",-8,9);
		if (bars[1]:IsShown()) then
			bars[1]:SetPoint("BOTTOMLEFT",bars[2],"TOPLEFT",0,4);
			bars[1]:SetPoint("BOTTOMRIGHT",bars[2],"TOPRIGHT",0,4);
		end
	elseif (bars[1]:IsShown()) then
		bars[1]:SetPoint("BOTTOMLEFT",8,9);
		bars[1]:SetPoint("BOTTOMRIGHT",-8,9);
	end
	-- Calculate the space needed for the shown bars
	bars.offset = 0;
	for _, bar in ipairs(bars) do
		if (bar:IsShown()) then
			bars.offset = (bars.offset + cfg.barHeight + 5);
		end
	end
	if (bars.offset == 0) then
		bars.offset = nil;
	end
	-- Hide GTT Status bar, we have our own, which is prettier!
	if (cfg.hideDefaultBar) then
		GameTooltipStatusBar:Hide();
	end
end

-- Format Number Value -- kilo, mega, giga
local function FormatValue(val,type2)
	if (not cfg.barsCondenseValues) or (val < 10000) then
		return val;
	else
		if (type2 == "wanyi") then
			if (val < 100000000) then
				return (L["%.1fWan"]):format(val / 10000);
			else
				return (L["%.2fYi"]):format(val / 100000000);
			end
		else
			if (val < 1000000) then
				return ("%.1fk"):format(val / 1000);
			elseif (val < 1000000000) then
				return ("%.2fm"):format(val / 1000000);
			else
				return ("%.2fg"):format(val / 1000000000);
			end
		end
	end
end

-- Format Bar Text
local function FormatBarValues(fs,val,max,type,type2)
	if (type == "none") then
		fs:SetText("");
	elseif (type == "value") or (max == 0) then -- max should never be zero, but if it is, dont let it pass through to the "percent" type, or there will be an error
		fs:SetFormattedText("%s / %s",FormatValue(val,type2),FormatValue(max,type2));
	elseif (type == "current") then
		fs:SetFormattedText("%s",FormatValue(val,type2));
	elseif (type == "full") then
		fs:SetFormattedText("%s / %s (%.0f%%)",FormatValue(val,type2),FormatValue(max,type2),val / max * 100);
	elseif (type == "deficit") then
		if (val ~= max) then
			fs:SetFormattedText("-%s",FormatValue(max - val,type2));
		else
			fs:SetText("");
		end
	elseif (type == "percent") then
		fs:SetFormattedText("%.0f%%",val / max * 100);
	end
end

-- Update Bar
local function UpdateBar(bar,val,max,fmtType)
	if (bar:IsShown()) then
		bar:SetMinMaxValues(0,max);
		bar:SetValue(val);
		FormatBarValues(bar.text,val,max,fmtType,cfg.barsCondenseType);
	end
end

-- Update Health & Power
local function UpdateHealthAndPowerBar()
	UpdateBar(bars[1],UnitHealth(u.token),UnitHealthMax(u.token),cfg.healthBarText)
	UpdateBar(bars[2],UnitPower(u.token,u.powerType),UnitPowerMax(u.token,u.powerType),(u.powerType == 0 and cfg.manaBarText or cfg.powerBarText))
end

--------------------------------------------------------------------------------------------------------
--                                       Auras: Buffs & Debuffs                                       --
--------------------------------------------------------------------------------------------------------

local function CreateAuraFrame()
	local aura = CreateFrame("Frame",nil,gtt);
	aura:SetWidth(cfg.auraSize);
	aura:SetHeight(cfg.auraSize);
	aura.count = aura:CreateFontString(nil,"OVERLAY");
	aura.count:SetPoint("BOTTOMRIGHT",1,0);
	aura.count:SetFont(GameFontNormal:GetFont(),(cfg.auraSize / 2),"OUTLINE");
	aura.icon = aura:CreateTexture(nil,"BACKGROUND");
	aura.icon:SetAllPoints();
	aura.icon:SetTexCoord(0.07,0.93,0.07,0.93);
	aura.cooldown = CreateFrame("Cooldown",nil,aura,"CooldownFrameTemplate");
	aura.cooldown:SetReverse(1);
	aura.cooldown:SetAllPoints();
	aura.cooldown:SetFrameLevel(aura:GetFrameLevel());
	aura.cooldown.noCooldownCount = cfg.noCooldownCount or nil;
	aura.border = aura:CreateTexture(nil,"OVERLAY");
	aura.border:SetPoint("TOPLEFT",-1,1);
	aura.border:SetPoint("BOTTOMRIGHT",1,-1);
	aura.border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays");
	aura.border:SetTexCoord(0.296875,0.5703125,0,0.515625);
	auras[#auras + 1] = aura;
	return aura;
end

-- querires auras of the specific auraType, and sets up the aura frame and anchors it in the desired place
local function DisplayAuras(auraType,startingAuraFrameIndex)

	local aurasPerRow = floor((gtt:GetWidth() - 4) / (cfg.auraSize + 1));	-- auras we can fit into one row based on the current size of the GTT
	local xOffsetBasis = (auraType == "HELPFUL" and 1 or -1);				-- is +1 or -1 based on horz anchoring

	local queryIndex = 1;							-- aura query index for this auraType
	local auraFrameIndex = startingAuraFrameIndex;	-- array index for the next aura frame, initialized to the starting index

	-- anchor calculation based on "auraType" and "cfg.aurasAtBottom"
	local horzAnchor1 = (auraType == "HELPFUL" and "LEFT" or "RIGHT");
	local horzAnchor2 = TT_MirrorAnchors[horzAnchor1];

	local vertAnchor = (cfg.aurasAtBottom and "TOP" or "BOTTOM");
	local anchor1 = vertAnchor..horzAnchor1;
	local anchor2 = TT_MirrorAnchors[vertAnchor]..horzAnchor1;

	-- query auras
	while (true) do
		local _, iconTexture, count, debuffType, duration, endTime, casterUnit = UnitAura(u.token,queryIndex,auraType);	-- [18.07.19] 8.0/BfA: "dropped second parameter"
		if (not iconTexture) or (auraFrameIndex / aurasPerRow > cfg.auraMaxRows) then
			break;
		end
		if (not cfg.selfAurasOnly or validSelfCasterUnits[casterUnit]) then
			local aura = auras[auraFrameIndex] or CreateAuraFrame();

			-- Anchor It
			aura:ClearAllPoints();
			if ((auraFrameIndex - 1) % aurasPerRow == 0) or (auraFrameIndex == startingAuraFrameIndex) then
				-- new aura line
				local x = (xOffsetBasis * 2);
				local y = (cfg.auraSize + 1) * floor((auraFrameIndex - 1) / aurasPerRow);
				y = (cfg.aurasAtBottom and -y or y);
				aura:SetPoint(anchor1,gtt,anchor2,x,y);
			else
				-- anchor to last
				aura:SetPoint(horzAnchor1,auras[auraFrameIndex - 1],horzAnchor2,xOffsetBasis,0);
			end

			-- Cooldown
			if (cfg.showAuraCooldown) and (duration and duration > 0 and endTime and endTime > 0) then
				aura.cooldown:SetCooldown(endTime - duration,duration);
			else
				aura.cooldown:Hide();
			end

			-- Set Texture + Count
			aura.icon:SetTexture(iconTexture);
			aura.count:SetText(count and count > 1 and count or "");

			-- Border -- Only shown for debuffs
			if (auraType == "HARMFUL") then
				local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
				aura.border:SetVertexColor(color.r,color.g,color.b);
				aura.border:Show();
			else
				aura.border:Hide();
			end

			-- Show + Next, Break if exceed max desired rows of aura
			aura:Show();
			auraFrameIndex = (auraFrameIndex + 1);
		end
		queryIndex = (queryIndex + 1);
	end

	-- return the number of auras displayed
	return (auraFrameIndex - startingAuraFrameIndex);
end

-- display buffs and debuffs and hide unused aura frames
local function SetupAuras()
	local auraCount = 0;
	if (cfg.showBuffs) then
		auraCount = auraCount + DisplayAuras("HELPFUL",auraCount + 1);
	end
	if (cfg.showDebuffs) then
		auraCount = auraCount + DisplayAuras("HARMFUL",auraCount + 1);
	end

	-- Hide the Unused
	for i = (auraCount + 1), #auras do
		auras[i]:Hide();
	end
end

--------------------------------------------------------------------------------------------------------
--                                          GameTooltip Hooks                                         --
--------------------------------------------------------------------------------------------------------

--[[
	GameTooltip Construction Call Order -- Tested for BfA (18.07.24)
	This is apparently the order in which the GTT construsts unit tips
	------------------------------------------------------------------
	- GameTooltip_SetDefaultAnchor()
	- GTT.OnTooltipSetUnit()					-- GTT:GetUnit() becomes valid here
	- GTT.OnShow()
	- GTT:Show()								-- Will Resize the tip
	- GTT.OnTooltipCleared()
	- Something that resizes the tip, Show() already does this, but it's also done after OnTooltipSetUnit() again. Or maybe it's just another addon's hook doing it. Tested without any addons loaded, and it still resizes after.
--]]

-- table with GameTooltip events to hook into (k = eventName, v = hookFunction)
local gttEventHooks = {};

-- FadeOut constants
local FADE_ENABLE = 1;
local FADE_BLOCK = 2;

-- Get The Anchor Position Depending on the Tip Content and Parent Frame -- Do not depend on "u.token" here, as it might not have been cleared yet!
-- Checking "mouseover" here isn't ideal due to actionbars, it will sometimes return true because of selfcast.
local function GetAnchorPosition()
	local mouseFocus = GetMouseFocus();
	local isUnit = UnitExists("mouseover") or (mouseFocus and mouseFocus.GetAttribute and mouseFocus:GetAttribute("unit"));	-- Az: GetAttribute("unit") here is bad, as that will find things like buff frames too
	local var = "anchor"..(mouseFocus == WorldFrame and "World" or "Frame")..(isUnit and "Unit" or "Tip");
	return cfg[var.."Type"], cfg[var.."Point"];
end

-- HOOK: GTT:FadeOut -- This allows us to check when the tip is fading out.
local gttFadeOut = gtt.FadeOut;
gtt.FadeOut = function(self,...)
	if (not u.token) or (not cfg.overrideFade) then
		self.fadeOut = FADE_BLOCK; -- Don't allow the OnUpdate handler to run the fadeout/update code
		gttFadeOut(self,...);
	elseif (cfg.preFadeTime == 0 and cfg.fadeTime == 0) then
		self:Hide();
	else
		self.fadeOut = FADE_ENABLE;
		gtt_lastUpdate = 0;
	end
end

-- HOOK: GTT:Show -- If there are any bar offsets, resize the tip
--local gttShow = gtt.Show;
--gtt.Show = function(self,...)
--hooksecurefunc(GameTooltip, "Show", function(self, ...)
--	gttShow(self,...);
--		tt:ApplyBackdrop(self)
--	if (bars.offset) and (self:GetUnit()) then
--		self:SetPadding(0,bars.offset);
--		gtt_numLines = self:NumLines();
--		gtt_newHeight = (self:GetHeight() + bars.offset);
--		self:SetHeight(gtt_newHeight);	-- Az: Setting height here seems to cause a conflict with the XToLevel addon, which causes an empty line. But I was certain this got added to fix the very same issue, just with another addon
--	end
--end)

-- EventHook: OnShow
function gttEventHooks.OnShow(self,...)
	gtt_anchorType, gtt_anchorPoint = GetAnchorPosition();

	-- Anchor GTT to Mouse
	if (gtt_anchorType == "mouse") and (self.default) then
		local gttAnchor = self:GetAnchorType();
		if (gttAnchor ~= "ANCHOR_CURSOR") and (gttAnchor ~= "ANCHOR_CURSOR_RIGHT") then
        if not fixInCombat() then
			tt:AnchorFrameToMouse(self);
        end
		end
	end

	-- Ensures that default anchored world frame tips have the proper color, their internal function seems to set them to a dark blue color
	if (self:IsOwned(UIParent)) and (not self:GetUnit()) then
		self:SetBackdropColor(unpack(cfg.tipColor));
	end
end

-- EventHook: OnUpdate
function gttEventHooks.OnUpdate(self,elapsed)
	-- This ensures that mouse anchored world frame tips have the proper color, their internal function seems to set them to a dark blue color
	local gttAnchor = self:GetAnchorType();
	if (gttAnchor == "ANCHOR_CURSOR") or (gttAnchor == "ANCHOR_CURSOR_RIGHT") then
		self:SetBackdropColor(tipBackdrop.backdropColor:GetRGBA());
		self:SetBackdropBorderColor(tipBackdrop.backdropBorderColor:GetRGBA());
		return;
	-- Anchor GTT to Mouse
	elseif (gtt_anchorType == "mouse") and (self.default) then
        if not fixInCombat() then
		tt:AnchorFrameToMouse(self);
        end
	end

	-- WoD: This background color reset, from OnShow(), has been copied down here. It seems resetting the color in OnShow() wasn't enough, as the color changes after the tip is being shown
	if (self:IsOwned(UIParent)) and (not self:GetUnit()) then
		self:SetBackdropColor(unpack(cfg.tipColor));
	end

	-- Fadeout / Update Tip if Showing a Unit
	-- Do not allow (fadeOut == FADE_BLOCK), as that is only for non overridden fadeouts, but we still need to keep resizing the tip
	if (u.token) and (self.fadeOut ~= FADE_BLOCK) then
		gtt_lastUpdate = (gtt_lastUpdate + elapsed);
		if (self.fadeOut) then
			self:Show(); -- Overrides self:FadeOut()
			if (gtt_lastUpdate > cfg.fadeTime + cfg.preFadeTime) then
				self.fadeOut = nil;
				self:Hide();
			elseif (gtt_lastUpdate > cfg.preFadeTime) then
				self:SetAlpha(1 - (gtt_lastUpdate - cfg.preFadeTime) / cfg.fadeTime);
			end
		-- This is only really needed for worldframe unit tips, as when u.token == "mouseover", the GTT:FadeOut() function is not called
		elseif (not UnitExists(u.token)) then
			self:FadeOut();
		else
			local gttCurrentLines = self:NumLines();
			-- If number of lines differ from last time, force an update. This became an issue in 5.4 as the coalesced realm text is added after the initial Show(). This might also fix some incompatibilities with other addons.
			if (cfg.updateFreq > 0) and (gtt_lastUpdate > cfg.updateFreq) or (gttCurrentLines ~= gtt_numLines) then
				gtt_numLines = gttCurrentLines;
				gtt_lastUpdate = 0;
				tt:ApplyGeneralAppearance();
			end
		end
	end

	-- Resize the Tooltip if it's size has changed more than 0.1 units
--	local gttHeight = self:GetHeight();
--	if (gtt_newHeight) and (abs(gttHeight - gtt_newHeight) > 0.1) then
		--gtt_newHeight = (gttHeight + bars.offset);	-- Az: Recalculating the height here would possibly fix every issue (I think), but it also adds extra cpu cycles I'd rather be without. For now just stay with the Show() recalc.
--		self:SetHeight(gtt_newHeight);
--	end
end

-- EventHook: OnTooltipSetUnit
function gttEventHooks.OnTooltipSetUnit(self,...)
	-- Hides the tip in combat if one of those options are set. Also checks if the Shift key is pressed, and cancels hiding of the tip (if that option is set, that is)
	if (cfg.hideAllTipsInCombat or cfg.hideUFTipsInCombat and self:GetOwner() ~= UIParent) and (not cfg.showHiddenTipsOnShift or not IsShiftKeyDown()) and (UnitAffectingCombat("player")) then
		self:Hide();
		return;
	end

	local _, unit = self:GetUnit();

	-- Concated unit tokens such as "targettarget" cannot be returned as the unit by GTT:GetUnit() and it will return as "mouseover", but the "mouseover" unit is still invalid at this point for those unitframes!
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

	-- We're done, apply appearance
	u.token = unit;
	self.fadeOut = nil; -- Az: Sometimes this wasn't getting reset, the fact a cleanup isn't performed at this point, now that it was moved to "OnTooltipCleared" is very bad, so this is a fix
	tt:ApplyGeneralAppearance(true);

	-- When there are any bar offsets, set tip padding
	if (bars.offset) and (self:GetUnit()) then
		self:SetPadding(0,bars.offset);
		gtt_numLines = self:NumLines();
	end
end

-- EventHook: OnTooltipCleared -- This will clean up auras, bars, raid icon and vars for the gtt when we aren't showing a unit
function gttEventHooks.OnTooltipCleared(self,...)
	-- WoD: resetting the back/border color seems to be a necessary action, otherwise colors may stick when showing the next tooltip thing (world object tips)
	-- BfA: The tooltip now also clears the backdrop in adition to color and bordercolor, so set it again here
	tt:ApplyBackdrop(self);

	-- remove the padding that might have been set to fit health/power bars
	self:SetPadding(0,0);

	-- wipe the vars
	wipe(u);
	gtt_lastUpdate = 0;
	gtt_numLines = 0;
--	gtt_newHeight = nil;
	petLevelLineIndex = nil;
	self.fadeOut = nil;
	bars.offset = nil;
	for i = 1, #bars do
		bars[i]:Hide();
	end
	for i = 1, #auras do
		auras[i]:Hide();
	end
	if (tipIcon) then
		tipIcon:Hide();
	end
end

-- OnHide Script -- Used to default the background and border color
local function TipHook_OnHide(self,...)
--	tt:ApplyBackdrop(self);
end

-- Resolves the given table array of string names into their global objects
local function ResolveGlobalNamedObjects(tipTable)
	local resolved = {};
	for index, tipName in ipairs(tipTable) do
		-- lookup the global object from this name, assign false if nonexistent, to preserve the table entry
		local tip = (_G[tipName] or false);

		-- Check if this object has already been resolved. This can happen for thing like AtlasLoot, which sets AtlasLootTooltip = GameTooltip
		if (resolved[tip]) then
			tip = false;
		elseif (tip) then
			resolved[tip] = index;
		end

		-- Assign the resolved object or false back into the table array
		tipTable[index] = tip;
	end
end

-- HOOK: GameTooltip_SetDefaultAnchor
local function GTT_SetDefaultAnchor(tooltip,parent)
	-- Return if no tooltip or parent
	if (not tooltip or not parent) then
		return;
	end
        if fixInCombat() then
            return
        end
	-- Position Tip to Normal, Mouse or Parent anchor
	gtt_anchorType, gtt_anchorPoint = GetAnchorPosition();
	tooltip:SetOwner(parent,"ANCHOR_NONE");
	tooltip:ClearAllPoints();
	if (gtt_anchorType == "mouse") then
		tt:AnchorFrameToMouse(tooltip);
	elseif (gtt_anchorType == "parent") and (parent ~= UIParent) then
			
			-------------------------------------------------
			-- 移除 默认位置
			-- by alee
			local points = {}
			for i=1,tooltip:GetNumPoints() do
				local point, relativeTo, relativePoint, xOfs, yOfs = tooltip:GetPoint(i)
				if relativePoint~="BOTTOMRIGHT" and point~="BOTTOMRIGHT" and UIParent~=relativeTo then
					tinsert(points,{point, relativeTo, relativePoint, xOfs, yOfs})
				end
			end
			tooltip:ClearAllPoints()
			for i=1,#points do
				tooltip:SetPoint(unpack(points[i]))
			end
			-- by alee
			
		tooltip:SetPoint(TT_MirrorAnchorsSmart[gtt_anchorPoint] or TT_MirrorAnchors[gtt_anchorPoint],parent,gtt_anchorPoint);
	else
		tooltip:SetPoint(gtt_anchorPoint,tt);
	end
	tooltip.default = 1;
end

-- Function to loop through tips to modify and hook
function tt:HookTips()
	-- Hooks needs to be applied as late as possible during load, as we want to try and be the last addon to hook "OnTooltipSetUnit" so we always have a "completed" tip to work on
	for eventName, funcHook in next, gttEventHooks do
		gtt:HookScript(eventName,funcHook);
	end

	-- Resolve the TipsToModify and hook their OnHide script
	ResolveGlobalNamedObjects(TT_TipsToModify);
	for index, tipName in ipairs(TT_TipsToModify) do
		if (type(tip) == "table") and (type(tip.GetObjectType) == "function") then
			tip:HookScript("OnHide",TipHook_OnHide);
		end
	end

	-- Replace GameTooltip_SetDefaultAnchor (For Re-Anchoring) -- Patch 3.2 made this function secure
	hooksecurefunc("GameTooltip_SetDefaultAnchor",GTT_SetDefaultAnchor);

	-- Clear this function as it's not needed anymore
	self.HookTips = nil;
end

--------------------------------------------------------------------------------------------------------
--                                              Settings                                              --
--------------------------------------------------------------------------------------------------------

-- Setup Gradient Tip
local function SetupGradientTip(tip)
	local g = tip.ttGradient;
	if (not cfg.gradientTip) then
		if (g) then
			g:Hide();
		end
		return;
	elseif (not g) then
		g = tip:CreateTexture();
		g:SetColorTexture(1,1,1,1);
		tip.ttGradient = g;
	end
	g:SetGradientAlpha("VERTICAL",0,0,0,0,unpack(cfg.gradientColor));
	g:SetPoint("TOPLEFT",cfg.backdropInsets,cfg.backdropInsets * -1);
	g:SetPoint("BOTTOMRIGHT",tip,"TOPRIGHT",cfg.backdropInsets * -1,-36);
	g:Show();
end

-- OnHyperlinkEnter
local function OnHyperlinkEnter(self,refString)
	local linkToken = refString:match("^([^:]+)");
	if (supportedHyperLinks[linkToken]) then
		GameTooltip_SetDefaultAnchor(gtt,self);
		gtt:SetHyperlink(refString);
	end
end

-- OnHyperlinkLeave
local function OnHyperlinkLeave(self)
	gtt:Hide();
end

-- Apply Settings
function tt:ApplySettings()
	-- Hide World Tips Instantly
	if (cfg.hideWorldTips) then
		self:RegisterEvent("CURSOR_UPDATE");
	else
		self:UnregisterEvent("CURSOR_UPDATE");
	end

	-- Set Backdrop
	tipBackdrop.bgFile = cfg.tipBackdropBG;
	tipBackdrop.edgeFile = cfg.tipBackdropEdge;
	tipBackdrop.edgeSize = cfg.backdropEdgeSize;
	tipBackdrop.insets.left = cfg.backdropInsets;
	tipBackdrop.insets.right = cfg.backdropInsets;
	tipBackdrop.insets.top = cfg.backdropInsets;
	tipBackdrop.insets.bottom = cfg.backdropInsets;

	tipBackdrop.backdropColor:SetRGBA(unpack(cfg.tipColor));
	tipBackdrop.backdropBorderColor:SetRGBA(unpack(cfg.tipBorderColor));

	-- Set Scale, Backdrop, Gradient
	for _, tip in ipairs(TT_TipsToModify) do
		if (type(tip) == "table") and (type(tip.GetObjectType) == "function") then
			if (tip == WorldMapTooltip) and (WorldMapTooltip.BackdropFrame) then
				tip:SetScale(cfg.gttScale);
				tip = WorldMapTooltip.BackdropFrame;	-- workaround for the worldmap faux tip
			elseif (tip == QuestScrollFrame) and (QuestScrollFrame.StoryTooltip) then
				tip = QuestScrollFrame.StoryTooltip;
			end
			SetupGradientTip(tip);
			tip:SetScale(cfg.gttScale);
			tt:ApplyBackdrop(tip);
		end
	end

	-- Bar Appearances
	GameTooltipStatusBar:SetStatusBarTexture(cfg.barTexture);
	GameTooltipStatusBar:GetStatusBarTexture():SetHorizTile(false);	-- Az: 3.3.3 fix
	GameTooltipStatusBar:GetStatusBarTexture():SetVertTile(false);	-- Az: 3.3.3 fix
	GameTooltipStatusBar:SetHeight(cfg.barHeight);
	for _, bar in ipairs(bars) do
		bar:SetStatusBarTexture(cfg.barTexture);
		bar:GetStatusBarTexture():SetHorizTile(false);	-- Az: 3.3.3 fix
		bar:GetStatusBarTexture():SetVertTile(false);	-- Az: 3.3.3 fix
		bar:SetHeight(cfg.barHeight);
		bar.text:SetFont(cfg.barFontFace,cfg.barFontSize,cfg.barFontFlags);
	end

	-- If disabled, hide auras, else set their size
	local gameFont = GameFontNormal:GetFont();
	for _, aura in ipairs(auras) do
		if (cfg.showBuffs or cfg.showDebuffs) then
			aura:SetWidth(cfg.auraSize);
			aura:SetHeight(cfg.auraSize);
			aura.count:SetFont(gameFont,(cfg.auraSize / 2),"OUTLINE");
			aura.cooldown.noCooldownCount = cfg.noCooldownCount;
		else
			aura:Hide();
		end
	end

	-- GameTooltip Font Templates
	if (cfg.modifyFonts) then
		GameTooltipHeaderText:SetFont(cfg.fontFace,cfg.fontSize + cfg.fontSizeDelta,cfg.fontFlags);
		GameTooltipText:SetFont(cfg.fontFace,cfg.fontSize,cfg.fontFlags);
		GameTooltipTextSmall:SetFont(cfg.fontFace,cfg.fontSize - cfg.fontSizeDelta,cfg.fontFlags);
	end

	-- Special Tooltip Icon
	local isIconNeeded = (cfg.iconRaid or cfg.iconFaction or cfg.iconCombat or cfg.iconClass);
	if (isIconNeeded) and (not tipIcon) then
		tipIcon = gtt:CreateTexture(nil,"BACKGROUND");
	end
	if (tipIcon) then
		if (isIconNeeded) then
			tipIcon:SetWidth(cfg.iconSize);
			tipIcon:SetHeight(cfg.iconSize);
			tipIcon:ClearAllPoints();
			tipIcon:SetPoint(TT_MirrorAnchors[cfg.iconAnchor],gtt,cfg.iconAnchor);
		else
			tipIcon:Hide();
		end
	end

	-- ChatFrame Hyperlink Hover -- Az: this may need some more testing, code seems wrong
	if (cfg.enableChatHoverTips or self.hookedHoverHyperlinks) then
		for i = 1, NUM_CHAT_WINDOWS do
			local chat = _G["ChatFrame"..i];
			if (i == 1) and (cfg.enableChatHoverTips) and (not self.hookedHoverHyperlinks) then		-- Az: why only on first window?
				self["oldOnHyperlinkEnter"..i] = chat:GetScript("OnHyperlinkEnter");
				self["oldOnHyperlinkLeave"..i] = chat:GetScript("OnHyperlinkLeave");
				self.hookedHoverHyperlinks = true;
			end
			chat:SetScript("OnHyperlinkEnter",cfg.enableChatHoverTips and OnHyperlinkEnter or self["oldOnHyperlinkEnter"..i]);
			chat:SetScript("OnHyperlinkLeave",cfg.enableChatHoverTips and OnHyperlinkLeave or self["oldOnHyperlinkLeave"..i]);
		end
--		if (GuildBankMessageFrame) then
--			GuildBankMessageFrame:SetScript("OnHyperlinkEnter",cfg.enableChatHoverTips and OnHyperlinkEnter or nil);
--			GuildBankMessageFrame:SetScript("OnHyperlinkLeave",cfg.enableChatHoverTips and OnHyperlinkLeave or nil);
--		end
	end

	-- TipTacItemRef Support
	if (TipTacItemRef and TipTacItemRef.ApplySettings) then
		TipTacItemRef:ApplySettings();
	end
end

-- Applies the backdrop, color and border color. The GTT will often reset these internally.
function tt:ApplyBackdrop(tip)
	GameTooltip_SetBackdropStyle(tip,tipBackdrop)
end

--------------------------------------------------------------------------------------------------------
--                                          TipTac Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Allows other mods to "register" tooltips or frames to be modified by TipTac
function tt:AddModifiedTip(tip,noHooks)
	if (type(tip) == "string") then
		tip = _G[tip];
	end
	if (type(tip) == "table") and (type(tip.GetObjectType) == "function") then
		for index, tipEntry in ipairs(TT_TipsToModify) do
			if (tip == tipEntry) then
				return;		-- if this tooltip is already modified, abort
			end
		end
		TT_TipsToModify[#TT_TipsToModify + 1] = tip;
		if (not noHooks) then
			tip:HookScript("OnHide",TipHook_OnHide);
		end
		-- Only apply settings if "cfg" has been initialised, meaning after VARIABLES_LOADED. If AddModifiedTip() is called before, settings will be applied for all tips once VARIABLES_LOADED is fired anyway.
		if (cfg) then
			self:ApplySettings();
		end
	end
end

-- Anchor any given frame to mouse position
function tt:AnchorFrameToMouse(frame)
	local x, y = GetCursorPosition();
	local effScale = frame:GetEffectiveScale();
	frame:ClearAllPoints();
	frame:SetPoint(gtt_anchorPoint,UIParent,"BOTTOMLEFT",(x / effScale + cfg.mouseOffsetX),(y / effScale + cfg.mouseOffsetY));
end

-- Apply TipTac Appearance
local function ApplyTipTacAppearance(first)
	-- Store Original Name
	if (first) and (cfg.nameType == "original") then
		u.originalName = GameTooltipTextLeft1:GetText();
	end
	-- Az: RolePlay Explerimental (Mary Sue Protocol)
	if (first) and (u.isPlayer) and (cfg.nameType == "marysueprot") and (msp) then
		local field = "NA";
		local name = UnitName(u.token);
		msp.Request(name,field);	-- Az: does this return our request, or only storing it for later use? I'm guessing the info isn't available right away, but only after the person's roleplay addon replies.
		if (msp.char[name]) and (msp.char[name].field[field] ~= "") then
			u.rpName = msp.char[name].field[field] or name;
		end
	end
	-- Find NPC Title -- 09.08.22: Should now work with colorblind mode
	if (first) and (not u.isPlayer) then
		u.title = (isColorBlind and GameTooltipTextLeft3 or GameTooltipTextLeft2):GetText();
		if (u.title) and (u.title:find(TT_LevelMatch)) then
			u.title = nil;
		end
	end
	-- Modify the Tip
	ModifyUnitTooltip();
	if (first) and (cfg.showTargetedBy) then
		AddTargetedBy();
	end
	-- Bars
	if (first) or (UnitPowerType(u.token) ~= u.powerType) then
		SetupHealthAndPowerBar();
	end
	UpdateHealthAndPowerBar();
	-- Remove PVP Line, which makes the tip look a bit bad -- MoP: Now removes alliance and horde faction text as well -- 5.4: Added removal of the coalesced realm line(s)
	for i = 2, gtt:NumLines() do
		local line = _G["GameTooltipTextLeft"..i];
		local text = line:GetText();
		if (text == PVP_ENABLED) or (cfg.hideFactionText and (text == FACTION_ALLIANCE or text == FACTION_HORDE)) then
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
	-- Show & Adjust Height
	gtt:Show();
end

-- Apply General Appearance
function tt:ApplyGeneralAppearance(first)
	u.isPlayer = UnitIsPlayer(u.token);
	u.reactionIndex = GetUnitReactionIndex(u.token);

	-- Reaction Backdrop/Border Color
	if (cfg.reactColoredBackdrop) then
		gtt:SetBackdropColor(unpack(cfg["colReactBack"..u.reactionIndex]));
	end
	if (cfg.reactColoredBorder) then	-- Az: this will override the classColoredBorder config, perhaps have that option take priority instead?
		gtt:SetBackdropBorderColor(unpack(cfg["colReactBack"..u.reactionIndex]));
	-- Class Colored Border
	elseif (first) and (cfg.classColoredBorder) and (u.isPlayer) then
		local _, classEng = UnitClass(u.token);
		local color = CLASS_COLORS[classEng] or CLASS_COLORS["PRIEST"];
		gtt:SetBackdropBorderColor(color.r,color.g,color.b);
	end

	-- Special Tooltip Icon
	if (cfg.iconRaid or cfg.iconFaction or cfg.iconCombat or cfg.iconClass) then
		local raidIconIndex = GetRaidTargetIndex(u.token);
		if (cfg.iconRaid) and (raidIconIndex) then
			tipIcon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
			SetRaidTargetIconTexture(tipIcon,raidIconIndex);
			tipIcon:Show();
		elseif (cfg.iconFaction) and (UnitIsPVPFreeForAll(u.token)) then
			tipIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
			tipIcon:SetTexCoord(0,0.62,0,0.62);
			tipIcon:Show();
		elseif (cfg.iconFaction) and (UnitIsPVP(u.token)) and (UnitFactionGroup(u.token)) then
			tipIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..UnitFactionGroup(u.token));
			tipIcon:SetTexCoord(0,0.62,0,0.62);
			tipIcon:Show();
		elseif (cfg.iconCombat) and (UnitAffectingCombat(u.token)) then
			tipIcon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon");
			tipIcon:SetTexCoord(0.5,1,0,0.5);
			tipIcon:Show();
		elseif (u.isPlayer) and (cfg.iconClass) then
			local _, classEng = UnitClass(u.token);		-- Az: UnitClass() is called too many times in TipTac's code, cache it!
			local texCoord = CLASS_ICON_TCOORDS[classEng];
			tipIcon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles");
			tipIcon:SetTexCoord(unpack(texCoord));
			tipIcon:Show();
		else
			tipIcon:Hide();
		end
	end

	-- TipTac Appearance
	if (cfg.showUnitTip) then
		ApplyTipTacAppearance(first);
	end

	-- Auras - Has to be updated last because it depends on the tips new dimention
	-- Check token, because if the GTT was hidden in OnShow (called in ApplyTipTacAppearance), it would be nil here due to "u" being cleared in the OnTooltipCleared() function
	if (u.token) and (cfg.showBuffs or cfg.showDebuffs) then
		SetupAuras();
	end
end
