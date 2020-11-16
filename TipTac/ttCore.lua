local L = select(2, ...).L

local function fixInCombat()
    return InCombatLockdown() and U1GetCfgValue and U1GetCfgValue("tiptac/disableMouseFollowWhenCombat")
end

CoreOnEvent("PLAYER_REGEN_DISABLED", function()
    if U1GetCfgValue and U1GetCfgValue("tiptac/disableMouseFollowWhenCombat") then GameTooltip:Hide() end
end)

local _G = getfenv(0);
local unpack = unpack;
local UnitName = UnitName;
local UnitExists = UnitExists;
local GetMouseFocus = GetMouseFocus;
local gtt = GameTooltip;
local wipe = wipe;
local tconcat = table.concat;

-- Addon
local modName = ...;
local tt = CreateFrame("Frame",modName,UIParent,BackdropTemplateMixin and "BackdropTemplate");	-- 9.0.1: Using BackdropTemplate

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
	targetYouText = "<<YOU>>",

	showBattlePetTip = true,
	gttScale = 1,
	updateFreq = 0.5,
	enableChatHoverTips = false,
	hidePvpText = true,
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

	tipBackdropBG = "Interface\\Buttons\\WHITE8X8",
	tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
	backdropEdgeSize = 14,
	backdropInsets = 2.5,

	tipColor = { 0.1, 0.1, 0.2 },			-- UI Default: For most: (0.1,0.1,0.2), World Objects?: (0,0.2,0.35)
	tipBorderColor = { 0.3, 0.3, 0.4 },		-- UI Default: (1,1,1,1)
	gradientTip = true,
	gradientHeight = 36,
	gradientColor = { 0.8, 0.8, 0.8, 0.2 },

	modifyFonts = false,
	fontFace = "",	-- Set during VARIABLES_LOADED
	fontSize = 12,
	fontFlags = "",
	fontSizeDeltaHeader = 2,
	fontSizeDeltaSmall = -2,

	classification_minus = "-%s ",		-- New classification in MoP; Unsure what it's used for, but apparently the units have no mana. Example of use: The "Sha Haunts" early in the Horde's quests in Thunder Hold.
	classification_trivial = "~%s ",
	classification_normal = "%s ",
	classification_elite = "+%s ",
	classification_worldboss = "%s|r (Boss) ",
	classification_rare = "%s|r (Rare) ",
	classification_rareelite = "+%s|r (Rare) ",

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

	-- Talents
	showTalents = true,
	talentOnlyInParty = false,
	talentFormat = 1,
	talentCacheSize = 25,
	inspectDelay = 0.2,			-- The time delay for the scheduled inspection
	inspectFreq = 2,			-- How soon after an inspection are we allowed to inspect again?

	-- ItemRef
	if_enable = true,
	if_infoColor = { 0.2, 0.6, 1 },
	if_itemQualityBorder = true,
	if_showAuraCaster = true,
	if_showItemLevelAndId = false,				-- Used to be true, but changed due to the itemLevel issues
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
   	backdropInsets = 5,

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
	-- 3rd party addon tooltips
	"AtlasLootTooltip",
	"QuestHelperTooltip",
	"QuestGuru_QuestWatchTooltip",
};
tt.tipsToModify = TT_TipsToModify;

-- Colors
local CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;
local TT_ClassColorMarkup = {};
for classID, color in next, CLASS_COLORS do
	TT_ClassColorMarkup[classID] = ("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255);
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
local gtt_lastUpdate = 0;		-- time since last update
local gtt_numLines = 0;			-- number of lines at last check, if this differs from gtt:NumLines() an update should be performed. Only used for unit tips with extra padding.
local gtt_anchorType;			-- valid types: normal/mouse/parent
local gtt_anchorPoint;          -- standard UI anchor point
tt.xPadding = 0;				-- x/y variables used to set the padding (+width, +height) for the GTT, reset to zero in OnTooltipCleared
tt.yPadding = 0;

-- Data Variables
local u = {};
local targetedByList;

tt.u = u;

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

-- Cursor Update -- Event only registered when the "hideWorldTips" option is ENABLED.
function tt:CURSOR_UPDATE(event)
	if (gtt:IsShown()) and (gtt:IsOwned(UIParent)) and (not u.token) then
		-- Restoring the text of the first line, is a workaround so that gatherer addons can get the name of nodes
		local backup = GameTooltipTextLeft1:GetText();
		gtt:Hide();
		GameTooltipTextLeft1:SetText(backup);
	end
end

-- Login [One-Time-Event] -- Initialize Level for difficulty coloring
function tt:PLAYER_LOGIN(event)
	self.playerLevel = UnitLevel("player");
	self:UnregisterEvent(event);
	self[event] = nil;
end

-- Level Up -- Update Level for difficulty coloring to avoid excessively calling UnitLevel()
function tt:PLAYER_LEVEL_UP(event,newLevel)
	self.playerLevel = newLevel;
end

-- Variables Loaded [One-Time-Event]
function tt:VARIABLES_LOADED(event)
	self.isColorBlind = (GetCVar("colorblindMode") == "1");

	-- Default Fonts
	TT_DefaultConfig.fontFace = GameFontNormal:GetFont();
	TT_DefaultConfig.barFontFace = NumberFontNormal:GetFont();

	-- Init Config
	if (not TipTac_Config) then
		TipTac_Config = {};
    end
	cfg = setmetatable(TipTac_Config,{ __index = TT_DefaultConfig });
    if TipTac_Config.top == 0 and TipTac_Config.left == 0 then
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
	g:SetPoint("BOTTOMRIGHT",tip,"TOPRIGHT",cfg.backdropInsets * -1,-cfg.gradientHeight);
	g:Show();
end

-- Apply Settings
function tt:ApplySettings()
	-- Hide World Tips Instantly
	if (cfg.hideWorldTips or cfg.anchorWorldTipType == "mouse") then
		self:RegisterEvent("CURSOR_UPDATE");
	else
		self:UnregisterEvent("CURSOR_UPDATE");
	end

	-- Set Backdrop -- not setting "tileSize" as we dont tile
	tipBackdrop.bgFile = cfg.tipBackdropBG;
	tipBackdrop.edgeFile = cfg.tipBackdropEdge;
	tipBackdrop.tile = false;
	tipBackdrop.tileEdge = false;
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
			tt:ApplyTipBackdrop(tip);
		end
	end

	-- GameTooltip Font Templates
	if (cfg.modifyFonts) then
		GameTooltipText:SetFont(cfg.fontFace,cfg.fontSize,cfg.fontFlags);
		GameTooltipHeaderText:SetFont(cfg.fontFace,cfg.fontSize + cfg.fontSizeDeltaHeader,cfg.fontFlags);
		GameTooltipTextSmall:SetFont(cfg.fontFace,cfg.fontSize + cfg.fontSizeDeltaSmall,cfg.fontFlags);
	end

	-- inform elements that settings has been applied
	self:SendElementEvent("OnApplyConfig",cfg);
end

-- Applies the backdrop, color and border color. The GTT will often reset these internally.
function tt:ApplyTipBackdrop(tip)
	SharedTooltip_SetBackdropStyle(tip,tipBackdrop);
end

--------------------------------------------------------------------------------------------------------
--                                          TipTac Functions                                          --
--------------------------------------------------------------------------------------------------------

-- Anchor any given frame to mouse position
function tt:AnchorFrameToMouse(frame)
	local x, y = GetCursorPosition();
	local effScale = frame:GetEffectiveScale();
	frame:ClearAllPoints();
	frame:SetPoint(gtt_anchorPoint,UIParent,"BOTTOMLEFT",(x / effScale + cfg.mouseOffsetX),(y / effScale + cfg.mouseOffsetY));
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
	local numGroup = GetNumGroupMembers();
	if (not numGroup) or (numGroup <= 1) then
		return;
	end

	local inRaid = IsInRaid();
	for i = 1, numGroup do
		local unit = (inRaid and "raid"..i or "party"..i);
		if (UnitIsUnit(unit.."target",u.token)) and (not UnitIsUnit(unit,"player")) then
			local _, classID = UnitClass(unit);
			targetedByList.next = TT_ClassColorMarkup[classID];
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
function tt:ApplyUnitAppearance(tip,u,first)
	-- obtain unit properties
	if (first) then
		u.isPlayer = UnitIsPlayer(u.token);
		u.class, u.classID = UnitClass(u.token);
	end
	u.reactionIndex = self:GetUnitReactionIndex(u.token);

	--------------------------------------------------
	-- [1] Send style event BEFORE tip has been styled
	self:SendElementEvent("OnPreStyleTip",tip,u,first);
	--------------------------------------------------

	-- Backdrop Color: Reaction
	if (cfg.reactColoredBackdrop) then
		tip:SetBackdropColor(unpack(cfg["colReactBack"..u.reactionIndex]));
	end

	-- Backdrop Border Color: By Class or by Reaction
	if (cfg.classColoredBorder) and (u.isPlayer) then
		if (first) then
			local color = CLASS_COLORS[u.classID] or CLASS_COLORS["PRIEST"];
			tip:SetBackdropBorderColor(color.r,color.g,color.b);
		end
	elseif (cfg.reactColoredBorder) then	-- Az: this will override the classColoredBorder config, perhaps have that option take priority instead?
		tip:SetBackdropBorderColor(unpack(cfg["colReactBack"..u.reactionIndex]));
	end

	-- Remove Unwanted Lines
	if (first) and (cfg.hidePvpText or cfg.hideFactionText or cfg.hideRealmText) then
		self:RemoveUnwantedLines(tip);
	end

	--------------------------------------------------
	-- [2] Send the actual TipTac Appearance Styling event
	if (cfg.showUnitTip) then
		self:SendElementEvent("OnStyleTip",tip,u,first);
	end
	--------------------------------------------------

	if (first) and (cfg.showTargetedBy) then
		self:AddTargetedBy(u);
	end

	-- Calling tip:Show() here ensures that the tooltip has the correct dimensions.
	-- However, forcing it to show here could cause issues, and we should properly wait
	-- until OnShow before we post the final OnPostStyleTip event.
	--printf("[%.2f] %-24s %d x %d",GetTime(),"PreShow",tip:GetWidth(),tip:GetHeight())
	tip:Show();
	--printf("[%.2f] %-24s %d x %d",GetTime(),"PostShow",tip:GetWidth(),tip:GetHeight())

	--------------------------------------------------
	-- [3] Send style event AFTER tip has been styled
	self:SendElementEvent("OnPostStyleTip",tip,u,first);
	--------------------------------------------------

	-- Apply tooltip padding, if any
	if (tt.xPadding ~= 0) or (tt.yPadding ~= 0) then
		tip:SetPadding(tt.xPadding,tt.yPadding);
		gtt_numLines = gtt:NumLines();
	end
end

--------------------------------------------------------------------------------------------------------
--                                      GameTooltip Script Hooks                                      --
--------------------------------------------------------------------------------------------------------

--[[
	GameTooltip Construction Call Order -- Tested for BfA (18.07.24)
	This is apparently the order in which the GTT construsts unit tips
	------------------------------------------------------------------
	- GameTooltip_SetDefaultAnchor()
	- GTT.OnTooltipSetUnit()			-- GetUnit() becomes valid here
	- GTT:Show()						-- Will Resize the tip
	- GTT.OnShow()						-- Event triggered in response to the Show() function
	- GTT.OnTooltipCleared()			-- Tooltip has been cleared and is ready to show new information, doesn't mean it's hidden
--]]

-- table with GameTooltip scripts to hook into (k = scriptName, v = hookFunction)
local gttScriptHooks = {};

-- FadeOut constants
local FADE_ENABLE = 1;
local FADE_BLOCK = 2;

-- Get The Anchor Position Depending on the Tip Content and Parent Frame
-- Do not depend on "u.token" here, as it might not have been cleared yet!
-- Checking "mouseover" here isn't ideal due to actionbars, it will sometimes return true because of selfcast.
local function GetAnchorPosition()
	local mouseFocus = GetMouseFocus();
	local isUnit = UnitExists("mouseover") or (mouseFocus and mouseFocus.GetAttribute and mouseFocus:GetAttribute("unit"));	-- Az: GetAttribute("unit") here is bad, as that will find things like buff frames too
	local var = "anchor"..(mouseFocus == WorldFrame and "World" or "Frame")..(isUnit and "Unit" or "Tip");
    if fixInCombat() and cfg[var.."Type"] == "mouse" then return "normal", "BOTTOMRIGHT" end
	return cfg[var.."Type"], cfg[var.."Point"];
end

-- EventHook: OnShow
function gttScriptHooks:OnShow()
	-- Anchor GTT to Mouse -- Az: Initial mouse anchoring is now being done in GTT_SetDefaultAnchor (remove if there are no issues)
    --abyui 注释掉会导致gtt_anchorType局部变量混乱，可能使用的不是实际的配置，注意最后的Hook也是用这个函数
	gtt_anchorType, gtt_anchorPoint = GetAnchorPosition();
	if (gtt_anchorType == "mouse") and (self.default) then
		local gttAnchor = self:GetAnchorType();
		if (gttAnchor ~= "ANCHOR_CURSOR") and (gttAnchor ~= "ANCHOR_CURSOR_RIGHT") then
			tt:AnchorFrameToMouse(self);
		end
	end

	-- Ensures that default anchored world frame tips have the proper color, their internal function seems to set them to a dark blue color
	-- Tooltips from world objects that change cursor seems to also require this. (Tested in 8.0/BfA)
	if (self:IsOwned(UIParent)) and (not self:GetUnit()) then
		self:SetBackdropColor(unpack(cfg.tipColor));
	end
end

-- EventHook: OnUpdate
function gttScriptHooks:OnUpdate(elapsed)
	-- This ensures that mouse anchored world frame tips have the proper color, their internal function seems to set them to a dark blue color
	local gttAnchor = self:GetAnchorType();
	if (gttAnchor == "ANCHOR_CURSOR") or (gttAnchor == "ANCHOR_CURSOR_RIGHT") then
		self:SetBackdropColor(unpack(cfg.tipColor));
		self:SetBackdropBorderColor(unpack(cfg.tipBorderColor));
		return;
	-- Anchor GTT to Mouse
	elseif (gtt_anchorType == "mouse") and (self.default) then
		tt:AnchorFrameToMouse(self);
	end

	-- WoD: This background color reset, from OnShow(), has been copied down here. It seems resetting the color in OnShow() wasn't enough, as the color changes after the tip is being shown
	if (self:IsOwned(UIParent)) and (not self:GetUnit()) then
		self:SetBackdropColor(unpack(cfg.tipColor));
	end

	-- Fadeout / Update Tip if Showing a Unit
	-- Do not allow (fadeOut == FADE_BLOCK), as that is only for non overridden fadeouts
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
		elseif (cfg.updateFreq > 0) then
			local gttCurrentLines = self:NumLines();
			-- If number of lines differ from last time, force an update. This became an issue in 5.4 as the coalesced realm text is added after the initial Show(). This might also fix some incompatibilities with other addons.
			if (gtt_lastUpdate > cfg.updateFreq) or (gttCurrentLines ~= gtt_numLines) then
				gtt_numLines = gttCurrentLines;
				gtt_lastUpdate = 0;
				tt:ApplyUnitAppearance(gtt,u);
			end
		end
	end
end

-- EventHook: OnTooltipSetUnit
function gttScriptHooks:OnTooltipSetUnit()
	-- Hides the tip in combat if one of those options are set. Also checks if the Shift key is pressed, and cancels hiding of the tip (if that option is set, that is)
	if (cfg.hideAllTipsInCombat or cfg.hideUFTipsInCombat and self:GetOwner() ~= UIParent) and (not cfg.showHiddenTipsOnShift or not IsShiftKeyDown()) and (UnitAffectingCombat("player")) then
		self:Hide();
		return;
	end

	local _, unit = self:GetUnit();

	-- Concated unit tokens such as "targettarget" cannot be returned as the unit by GTT:GetUnit(),
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
	self.fadeOut = nil; -- Az: Sometimes this wasn't getting reset, the fact a cleanup isn't performed at this point, now that it was moved to "OnTooltipCleared" is bad, so this is a fix [8.0/BfA/18.08.12 - Still not cleared 100% of the time]

	-- We're done, apply appearance
	u.token = unit;
	tt:ApplyUnitAppearance(self,u,true);	-- called with "first" arg to true
end

-- EventHook: OnTooltipCleared -- This will clean up auras, bars, raid icon and vars for the gtt when we aren't showing a unit
function gttScriptHooks:OnTooltipCleared()
	-- WoD: resetting the back/border color seems to be a necessary action, otherwise colors may stick when showing the next tooltip thing (world object tips)
	-- BfA: The tooltip now also clears the backdrop in adition to color and bordercolor, so set it again here
	tt:ApplyTipBackdrop(self);

	-- remove the padding that might have been set to fit health/power bars
	tt.xPadding = 0;
	tt.yPadding = 0;
	--self:SetPadding(tt.xPadding,tt.yPadding);		-- [8.1.5] disabled, as it causes issues  -- Look into GTT.recalculatePadding & GameTooltip_CalculatePadding()

	-- wipe the vars
	wipe(u);
	gtt_lastUpdate = 0;
	gtt_numLines = 0;
	self.fadeOut = nil;

	-- post cleared event to elements
	tt:SendElementEvent("OnCleared",self);
end

-- OnHide Script -- Used to default the background and border color -- Az: May cause issues with embedded tooltips, see GameTooltip.lua:396
function gttScriptHooks:OnHide()
	tt:ApplyTipBackdrop(self);
end

--------------------------------------------------------------------------------------------------------
--                                      GameTooltip Other Hooks                                       --
--------------------------------------------------------------------------------------------------------

-- HOOK: GTT:FadeOut -- This allows us to check when the tip is fading out.
-- This function might have been made secure in 8.2?
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

	-- Get the current anchoring type and point based on the frame under the mouse and anchor settings
	gtt_anchorType, gtt_anchorPoint = GetAnchorPosition();

	-- We only hook the GameTooltip, so if any other tips use the default anchor with mouse anchoring,
	-- we have to just set it here statically, as we wont have the OnUpdate hooked for that tooltip
	if (tooltip ~= gtt) and (gtt_anchorType == "mouse") then
		tooltip:SetOwner(parent,"ANCHOR_CURSOR_RIGHT",cfg.mouseOffsetX,cfg.mouseOffsetY);
    else
		-- Since TipTac handles all the anchoring, we want to use "ANCHOR_NONE" here
		tooltip:SetOwner(parent,"ANCHOR_NONE");
		tooltip:ClearAllPoints();

		if (gtt_anchorType == "mouse") then
			-- Although we anchor the frame continuously in OnUpdate, we must anchor it initially here to avoid flicker on the first frame its being shown
			tt:AnchorFrameToMouse(tooltip);
		elseif (gtt_anchorType == "parent") and (parent ~= UIParent) then
			-- anchor to the opposite edge of the parent frame
			tooltip:SetPoint(TT_MirrorAnchorsSmart[gtt_anchorPoint] or TT_MirrorAnchors[gtt_anchorPoint],parent,gtt_anchorPoint);
		else
			-- "normal" anchor or fallback for "parent" in case its UIParent
			tooltip:SetPoint(gtt_anchorPoint,tt);
		end
	end

	-- "default" will flag the tooltip as having been anchored using the default anchor
	tooltip.default = 1;
end

-- Function to loop through tips to modify and hook
function tt:HookTips()
	-- Hooks needs to be applied as late as possible during load, as we want to try and be the
	-- last addon to hook "OnTooltipSetUnit" so we always have a "completed" tip to work on
	for scriptName, hookFunc in next, gttScriptHooks do
		gtt:HookScript(scriptName,hookFunc);
	end

	-- Resolve the TipsToModify strings into actual objects
	ResolveGlobalNamedObjects(TT_TipsToModify);

	-- hook their OnHide script -- Az: OnHide hook disabled for now
--	for index, tipName in ipairs(TT_TipsToModify) do
--		if (type(tip) == "table") and (type(tip.GetObjectType) == "function") then
--			tip:HookScript("OnHide",gttScriptHooks.OnHide);
--		end
--	end

	-- Replace GameTooltip_SetDefaultAnchor (For Re-Anchoring) -- Patch 3.2 made this function secure
	hooksecurefunc("GameTooltip_SetDefaultAnchor",GTT_SetDefaultAnchor);
    C_Timer.After(0.1, function() GameTooltip_SetDefaultAnchor(GameTooltip, UIParent) end) --没有这句，鼠标直接放BUFF上不跟随

	-- Clear this function as it's not needed anymore
	self.HookTips = nil;
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
		TT_TipsToModify[#TT_TipsToModify + 1] = tip;

		-- Az: Disabled the OnHide hook, unsure if it needs to be re-enabled,
--		if (not noHooks) then
--			tip:HookScript("OnHide",gttScriptHooks.OnHide);
--		end

		-- Only apply settings if "cfg" has been initialised, meaning after VARIABLES_LOADED.
		-- If AddModifiedTip() is called earlier, settings will be applied for all tips once VARIABLES_LOADED is fired anyway.
		if (cfg) then
			self:ApplySettings();
		end
	end
end

--abyui 鼠标提示闪烁, 延迟加载是因为要在其他hook之后(例如TipTacItemRef)
hooksecurefunc(GameTooltip, "Show", gttScriptHooks.OnShow)
C_Timer.After(1, function()
    hooksecurefunc(GameTooltip, "SetUnitAura", gttScriptHooks.OnShow)
end)