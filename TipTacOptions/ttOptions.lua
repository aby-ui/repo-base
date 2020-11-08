local cfg = TipTac_Config;
local modName = "TipTac";
local L = select(2, ...).L

-- DropDown Lists
local DROPDOWN_FONTFLAGS = {
	[L"|cffffa0a0None"] = "",
	[L"Outline"] = "OUTLINE",
	[L"Thick Outline"] = "THICKOUTLINE",
};
local DROPDOWN_ANCHORTYPE = {
	[L"Normal Anchor"] = "normal",
	[L"Mouse Anchor"] = "mouse",
	[L"Parent Anchor"] = "parent",
};

local DROPDOWN_ANCHORPOS = {
	[L"Top"] = "TOP",
	[L"Top Left"] = "TOPLEFT",
	[L"Top Right"] = "TOPRIGHT",
	[L"Bottom"] = "BOTTOM",
	[L"Bottom Left"] = "BOTTOMLEFT",
	[L"Bottom Right"] = "BOTTOMRIGHT",
	[L"Left"] = "LEFT",
	[L"Right"] = "RIGHT",
	[L"Center"] = "CENTER",
};

local DROPDOWN_BARTEXTFORMAT = {
	[L"|cffffa0a0None"] = "none",
	[L"Percentage"] = "percent",
	[L"Current Only"] = "current",
	[L"Values"] = "value",
	[L"Values & Percent"] = "full",
	[L"Deficit"] = "deficit",
};

-- Options -- The "y" value of a category subtable, will further increase the vertical offset position of the item
local activePage = 1;
local options = {
	-- General
	{
		[0] = "General",
		{ type = "Check", var = "showUnitTip", label = "Enable TipTac Unit Tip Appearance", tip = "Will change the appearance of how unit tips look. Many options in TipTac only work with this setting enabled.\nNOTE: Using this options with a non English client may cause issues!" },
		{ type = "Check", var = "showStatus", label = "Show DC, AFK and DND Status", tip = "Will show the <DC>, <AFK> and <DND> status after the player name", y = 8 },
		{ type = "Check", var = "showGuildRank", label = "Show Player Guild Rank Title", tip = "In addition to the guild name, with this option on, you will also see their guild rank by title" },
		{ type = "Check", var = "showTargetedBy", label = "Show Who Targets the Unit", tip = "When in a raid or party, the tip will show who from your group is targeting the unit" },
		{ type = "Check", var = "showPlayerGender", label = "Show Player Gender", tip = "This will show the gender of the player. E.g. \"85 Female Blood Elf Paladin\"." },
		{ type = "DropDown", var = "nameType", label = "Name & Title", list = { [L"Name only"] = "normal", [L"Name + title"] = "title", [L"Copy from original tip"] = "original", [L"Mary Sue Protocol"] = "marysueprot" }, y = 16 },
		{ type = "DropDown", var = "showRealm", label = "Show Unit Realm", list = { [L"Do not show realm"] = "none", [L"Show realm"] = "show", [L"Show (*) instead"] = "asterisk" } },
		{ type = "DropDown", var = "showTarget", label = "Show Unit Target", list = { [L"Do not show target"] = "none", [L"First line"] = "first", [L"Second line"] = "second", [L"Last line"] = "last" } },
		{ type = "Text", var = "targetYouText", label = "Targeting You Text", y = 16 },
	},
	-- Special
	{
		[0] = "Special",
		{ type = "Check", var = "showBattlePetTip", label = "Enable Battle Pet Tips", tip = "Will show a special tip for both wild and companion battle pets. Might need to be disabled for certain non-English clients" },
		{ type = "Slider", var = "gttScale", label = "Tooltip Scale", min = 0.2, max = 4, step = 0.05, y = 8 },
		{ type = "Slider", var = "updateFreq", label = "Tip Update Frequency", min = 0, max = 5, step = 0.05 },
		{ type = "Check", var = "enableChatHoverTips", label = "Enable ChatFrame Hover Hyperlinks", tip = "When hovering the mouse over a link in the chatframe, show the tooltip without having to click on it", y = 24 },
		{ type = "Check", var = "hidePvpText", label = "Hide PvP Text", tip = "Strips the PvP line from the tooltip", y = 10 },
		{ type = "Check", var = "hideFactionText", label = "Hide Faction Text", tip = "Strips the Alliance or Horde faction text from the tooltip", x = 170 },
		{ type = "Check", var = "hideRealmText", label = "Hide Coalesced Realm Text", tip = "Strips the Coalesced Realm text from the tooltip" },
 	},
	-- Colors
	{
		[0] = "Colors",
		{ type = "Check", var = "colorGuildByReaction", label = "Color Guild by Reaction", tip = "Guild color will have the same color as the reacion" },
		{ type = "Color", subType = 2, var = "colGuild", label = "Guild Color", tip = "Color of the guild name, when not using the option to make it the same as reaction color", y = 8 },
		{ type = "Color", subType = 2, var = "colSameGuild", label = "Your Guild Color", tip = "To better recognise players from your guild, you can configure the color of your guild name individually", x = 120 },
		{ type = "Color", subType = 2, var = "colRace", label = "Race & Creature Type Color", tip = "The color of the race and creature type text", y = 8 },
		{ type = "Color", subType = 2, var = "colLevel", label = "Neutral Level Color", tip = "Units you cannot attack will have their level text shown in this color" },
		{ type = "Check", var = "colorNameByClass", label = "Color Player Names by Class Color", tip = "With this option on, player names are colored by their class color, otherwise they will be colored by reaction", y = 12 },
		{ type = "Check", var = "classColoredBorder", label = "Color Tip Border by Class Color", tip = "For players, the border color will be colored to match the color of their class\nNOTE: This option is overridden by reaction colored border" },
	},
	-- Reactions
	{
		[0] = "Reactions",
		{ type = "Check", var = "reactText", label = "Show the unit's reaction as text", tip = "With this option on, the reaction of the unit will be shown as text on the last line" },
		{ type = "Color", subType = 2, var = "colReactText1", label = "Tapped Color", y = 42 },
		{ type = "Color", subType = 2, var = "colReactText2", label = "Hostile Color" },
		{ type = "Color", subType = 2, var = "colReactText3", label = "Caution Color" },
		{ type = "Color", subType = 2, var = "colReactText4", label = "Neutral Color" },
		{ type = "Color", subType = 2, var = "colReactText5", label = "Friendly NPC or PvP Player Color" },
		{ type = "Color", subType = 2, var = "colReactText6", label = "Friendly Player Color" },
		{ type = "Color", subType = 2, var = "colReactText7", label = "Dead Color" },
	},
	-- BG Color
	{
		[0] = "BG Color",
		{ type = "Check", var = "reactColoredBackdrop", label = "Color backdrop based on the unit's reaction", tip = "If you want the tip's background color to be determined by the unit's reaction towards you, enable this. With the option off, the background color will be the one selected on the 'Backdrop' page" },
		{ type = "Check", var = "reactColoredBorder", label = "Color border based on the unit's reaction", tip = "Same as the above option, just for the border\nNOTE: This option overrides class colored border" },
		{ type = "Color", var = "colReactBack1", label = "Tapped Color", y = 20 },
		{ type = "Color", var = "colReactBack2", label = "Hostile Color" },
		{ type = "Color", var = "colReactBack3", label = "Caution Color" },
		{ type = "Color", var = "colReactBack4", label = "Neutral Color" },
		{ type = "Color", var = "colReactBack5", label = "Friendly NPC or PvP Player Color" },
		{ type = "Color", var = "colReactBack6", label = "Friendly Player Color" },
		{ type = "Color", var = "colReactBack7", label = "Dead Color" },
	},
	-- Backdrop
	{
		[0] = "Backdrop",
		{ type = "DropDown", var = "tipBackdropBG", label = "Background Texture", media = "background" },
		{ type = "DropDown", var = "tipBackdropEdge", label = "Border Texture", media = "border" },
		{ type = "Slider", var = "backdropEdgeSize", label = "Backdrop Edge Size", min = -20, max = 64, step = 0.5, y = 8 },
		{ type = "Slider", var = "backdropInsets", label = "Backdrop Insets", min = -20, max = 20, step = 0.5 },
		{ type = "Color", var = "tipColor", label = "Tip Background Color", y = 18 },
		{ type = "Color", var = "tipBorderColor", label = "Tip Border Color", x = 160 },
		{ type = "Check", var = "gradientTip", label = "Show Gradient Tooltips", tip = "Display a small gradient area at the top of the tip to add a minor 3D effect to it. If you have an addon like Skinner, you may wish to disable this to avoid conflicts", y = 6 },
		{ type = "Color", var = "gradientColor", label = "Gradient Color", tip = "Select the base color for the gradient", x = 160 },
	},
	-- Font
	{
		[0] = "Font",
		{ type = "Check", var = "modifyFonts", label = "Modify the GameTooltip Font Templates", tip = "For TipTac to change the GameTooltip font templates, and thus all tooltips in the User Interface, you have to enable this option.\nNOTE: If you have an addon such as ClearFont, it might conflict with this option." },
		{ type = "DropDown", var = "fontFace", label = "Font Face", media = "font", y = 32 },
		{ type = "DropDown", var = "fontFlags", label = "Font Flags", list = DROPDOWN_FONTFLAGS },
		{ type = "Slider", var = "fontSize", label = "Font Size", min = 6, max = 29, step = 1, y = 4 },
		{ type = "Slider", var = "fontSizeDeltaHeader", label = "Font Size Header Delta", min = -10, max = 10, step = 1, y = 20 },
		{ type = "Slider", var = "fontSizeDeltaSmall", label = "Font Size Small Delta", min = -10, max = 10, step = 1 },
	},
	-- Classify
	{
		[0] = "Classify",
		{ type = "Text", var = "classification_minus", label = "Minus" },
		{ type = "Text", var = "classification_trivial", label = "Trivial" },
		{ type = "Text", var = "classification_normal", label = "Normal" },
		{ type = "Text", var = "classification_elite", label = "Elite" },
		{ type = "Text", var = "classification_worldboss", label = "Boss" },
		{ type = "Text", var = "classification_rare", label = "Rare" },
		{ type = "Text", var = "classification_rareelite", label = "Rare Elite" },
	},
	-- Fading
	{
		[0] = "Fading",
		{ type = "Check", var = "overrideFade", label = "Override Default GameTooltip Fade", tip = "Overrides the default fadeout function of the GameTooltip. If you are seeing problems regarding fadeout, please disable." },
		{ type = "Slider", var = "preFadeTime", label = "Prefade Time", min = 0, max = 5, step = 0.05, y = 16 },
		{ type = "Slider", var = "fadeTime", label = "Fadeout Time", min = 0, max = 5, step = 0.05 },
		{ type = "Check", var = "hideWorldTips", label = "Instantly Hide World Frame Tips", tip = "This option will make most tips which appear from objects in the world disappear instantly when you take the mouse off the object. Examples such as mailboxes, herbs or chests.\nNOTE: Does not work for all world objects.", y = 16 },
	},
	-- Bars
	{
		[0] = "Bars",
		{ type = "DropDown", var = "barFontFace", label = "Font Face", media = "font" },
		{ type = "DropDown", var = "barFontFlags", label = "Font Flags", list = DROPDOWN_FONTFLAGS },
		{ type = "Slider", var = "barFontSize", label = "Font Size", min = 6, max = 29, step = 1 },
		{ type = "DropDown", var = "barTexture", label = "Bar Texture", media = "statusbar", y = 36 },
		{ type = "Slider", var = "barHeight", label = "Bar Height", min = 1, max = 50, step = 1 },
	},
	-- Bar Types
	{
		[0] = "Bar Types",
		{ type = "Check", var = "hideDefaultBar", label = "Hide the Default Health Bar", tip = "Check this to hide the default health bar" },
		{ type = "Check", var = "barsCondenseValues", label = "Show Condensed Bar Values", tip = "You can enable this option to condense values shown on the bars. It does this by showing 57254 as 57.3k as an example" },
        { type = "DropDown", var = "barsCondenseType", label = "Condense Type", list = { [L"k/m/g"] = "kmg", [L"Wan/Yi"] = "wanyi" }, y = -2 },
		{ type = "Check", var = "healthBar", label = "Show Health Bar", tip = "Will show a health bar of the unit.", y = 12 },
		{ type = "DropDown", var = "healthBarText", label = "Health Bar Text", list = DROPDOWN_BARTEXTFORMAT },
		{ type = "Color", var = "healthBarColor", label = "Health Bar Color", tip = "The color of the health bar. Has no effect for players with the option above enabled" },
		{ type = "Check", var = "healthBarClassColor", label = "Class Colored Health Bar", tip = "This options colors the health bar in the same color as the player class", x = 130 },
		{ type = "Check", var = "manaBar", label = "Show Mana Bar", tip = "If the unit has mana, a mana bar will be shown.", y = 12 },
		{ type = "DropDown", var = "manaBarText", label = "Mana Bar Text", list = DROPDOWN_BARTEXTFORMAT },
		{ type = "Color", var = "manaBarColor", label = "Mana Bar Color", tip = "The color of the mana bar" },
		{ type = "Check", var = "powerBar", label = "Show Energy, Rage, Runic Power or Focus Bar", tip = "If the unit uses either energy, rage, runic power or focus, a bar for that will be shown.", y = 12 },
		{ type = "DropDown", var = "powerBarText", label = "Power Bar Text", list = DROPDOWN_BARTEXTFORMAT },
	},
	-- Auras
	{
		[0] = "Auras",
		{ type = "Check", var = "aurasAtBottom", label = "Put Aura Icons at the Bottom Instead of Top", tip = "Puts the aura icons at the bottom of the tip instead of the default top" },
		{ type = "Check", var = "showBuffs", label = "Show Unit Buffs", tip = "Show buffs of the unit", y = 12 },
		{ type = "Check", var = "showDebuffs", label = "Show Unit Debuffs", tip = "Show debuffs of the unit" },
		{ type = "Check", var = "selfAurasOnly", label = "Only Show Auras Coming from You", tip = "This will filter out and only display auras you cast yourself", y = 12 },
		{ type = "Slider", var = "auraSize", label = "Aura Icon Dimension", min = 8, max = 60, step = 1, y = 12 },
		{ type = "Slider", var = "auraMaxRows", label = "Max Aura Rows", min = 1, max = 8, step = 1 },
		{ type = "Check", var = "showAuraCooldown", label = "Show Cooldown Models", tip = "With this option on, you will see a visual progress of the time left on the buff", y = 8 },
		{ type = "Check", var = "noCooldownCount", label = "No Cooldown Count Text", tip = "Tells cooldown enhancement addons, such as OmniCC, not to display cooldown text" },
	},
	-- Icon
	{
		[0] = "Icon",
		{ type = "Check", var = "iconRaid", label = "Show Raid Icon", tip = "Shows the raid icon next to the tip" },
		{ type = "Check", var = "iconFaction", label = "Show Faction Icon", tip = "Shows the faction icon next to the tip" },
		{ type = "Check", var = "iconCombat", label = "Show Combat Icon", tip = "Shows a combat icon next to the tip, if the unit is in combat" },
		{ type = "Check", var = "iconClass", label = "Show Class Icon", tip = "For players, this will display the class icon next to the tooltip" },
		{ type = "DropDown", var = "iconAnchor", label = "Icon Anchor", list = DROPDOWN_ANCHORPOS, y = 12 },
		{ type = "Slider", var = "iconSize", label = "Icon Dimension", min = 8, max = 100, step = 1 },
	},
	-- Anchors
	{
		[0] = "Anchors",
		{ type = "DropDown", var = "anchorWorldUnitType", label = "World Unit Type", list = DROPDOWN_ANCHORTYPE },
		{ type = "DropDown", var = "anchorWorldUnitPoint", label = "World Unit Point", list = DROPDOWN_ANCHORPOS },
		{ type = "DropDown", var = "anchorWorldTipType", label = "World Tip Type", list = DROPDOWN_ANCHORTYPE, y = 14 },
		{ type = "DropDown", var = "anchorWorldTipPoint", label = "World Tip Point", list = DROPDOWN_ANCHORPOS },
		{ type = "DropDown", var = "anchorFrameUnitType", label = "Frame Unit Type", list = DROPDOWN_ANCHORTYPE, y = 14 },
		{ type = "DropDown", var = "anchorFrameUnitPoint", label = "Frame Unit Point", list = DROPDOWN_ANCHORPOS },
		{ type = "DropDown", var = "anchorFrameTipType", label = "Frame Tip Type", list = DROPDOWN_ANCHORTYPE, y = 14 },
		{ type = "DropDown", var = "anchorFrameTipPoint", label = "Frame Tip Point", list = DROPDOWN_ANCHORPOS },
	},
	-- Mouse
	{
		[0] = "Mouse",
		{ type = "Slider", var = "mouseOffsetX", label = "Mouse Anchor X Offset", min = -200, max = 200, step = 1 },
		{ type = "Slider", var = "mouseOffsetY", label = "Mouse Anchor Y Offset", min = -200, max = 200, step = 1 },
	},
	-- Combat
	{
		[0] = "Combat",
		{ type = "Check", var = "hideAllTipsInCombat", label = "Hide All Unit Tips in Combat", tip = "In combat, this option will prevent any unit tips from showing" },
		{ type = "Check", var = "hideUFTipsInCombat", label = "Hide Unit Tips for Unit Frames in Combat", tip = "When you are in combat, this option will prevent tips from showing when you have the mouse over a unit frame" },
		{ type = "Check", var = "showHiddenTipsOnShift", label = "Still Show Hidden Tips when Holding Shift", tip = "When you have this option checked, and one of the above options, you can still force the tip to show, by holding down shift", y = 8 },
--		{ type = "DropDown", var = "hideCombatTip", label = "Hide Tips in Combat For", list = { ["Unit Frames"] = "uf", ["All Tips"] = "all", ["No Tips"] = "none" } },
	},
	-- Layouts
	{
		[0] = "Layouts",
		{ type = "DropDown", label = "Layout Template", init = TipTacLayouts.LoadLayout_Init },
--		{ type = "Text", label = "Save Layout", func = nil },
--		{ type = "DropDown", label = "Delete Layout", init = TipTacLayouts.DeleteLayout_Init },
	},
};

-- TipTacTalents Support
if (TipTacTalents) then
	options[#options + 1] = {
		[0] = "Talents",
		{ type = "Check", var = "showTalents", label = "Enable TipTacTalents", tip = "This option makes the tip show the talent specialization of other players" },
		{ type = "Check", var = "talentOnlyInParty", label = "Only Show Talents for Party and Raid Members", tip = "When you enable this, only talents of players in your party or raid will be requested and shown" },
--		{ type = "DropDown", var = "talentFormat", label = "Talent Format", list = { ["Elemental (57/14/00)"] = 1, ["Elemental"] = 2, ["57/14/00"] = 3,}, y = 8 },	-- not supported with MoP changes
		{ type = "Slider", var = "talentCacheSize", label = "Talent Cache Size", min = 0, max = 50, step = 1, y = 12 },
	};
end

-- TipTacItemRef Support -- Az: this category page is full
if (TipTacItemRef) then
	options[#options + 1] = {
		[0] = "ItemRef",
		{ type = "Check", var = "if_enable", label = "Enable ItemRefTooltip Modifications", tip = "Turns on or off all features of the TipTacItemRef addon" },
		{ type = "Color", var = "if_infoColor", label = "Information Color", tip = "The color of the various tooltip lines added by these options", y = 8 },
		{ type = "Check", var = "if_itemQualityBorder", label = "Show Item Tips with Quality Colored Border", tip = "When enabled and the tip is showing an item, the tip border will have the color of the item's quality" },
		{ type = "Check", var = "if_showAuraCaster", label = "Show Aura Tooltip Caster", tip = "When showing buff and debuff tooltips, it will add an extra line, showing who cast the specific aura" },
		{ type = "Check", var = "if_showItemLevel", label = "Show Item Level", tip = "For item tooltips, show their itemLevel (Combines with itemID).\nNOTE: This will remove the default itemLevel text shown in tooltips" },
		{ type = "Check", var = "if_showItemId", label = "Show Item ID", tip = "For item tooltips, show their itemID (Combines with itemLevel)", x = 160 },
		{ type = "Check", var = "if_showSpellIdAndRank", label = "Show Spell ID & Rank", tip = "For spell and aura tooltips, show their spellID and spellRank" },
--		{ type = "Check", var = "if_showCurrencyId", label = "Show Currency ID", tip = "Currency items will now show their ID" },
--		{ type = "Check", var = "if_showAchievementIdAndCategory", label = "Show Achievement ID & Category", tip = "On achievement tooltips, the achievement ID as well as the category will be shown" },
		{ type = "Check", var = "if_showQuestLevelAndId", label = "Show Quest Level & ID", tip = "For quest tooltips, show their questLevel and questID" },
		{ type = "Check", var = "if_modifyAchievementTips", label = "Modify Achievement Tooltips", tip = "Changes the achievement tooltips to show a bit more information\nWarning: Might conflict with other achievement addons" },
		{ type = "Check", var = "if_showIcon", label = "Show Icon Texture and Stack Count (when available)", tip = "Shows an icon next to the tooltip. For items, the stack count will also be shown" },
		{ type = "Check", var = "if_smartIcons", label = "Smart Icon Appearance", tip = "When enabled, TipTacItemRef will determine if an icon is needed, based on where the tip is shown. It will not be shown on actionbars or bag slots for example, as they already show an icon" },
		{ type = "Check", var = "if_borderlessIcons", label = "Borderless Icons", tip = "Turn off the border on icons" },
		{ type = "Slider", var = "if_iconSize", label = "Icon Size", min = 16, max = 128, step = 1 },
	};
end

for _, option in ipairs(options) do
    for k, v in pairs(option) do
        if k == 0 then option[k] = L[v] else v.label = v.label and L[v.label] or nil; v.tip = v.tip and L[v.tip] or nil; end
    end
end

--------------------------------------------------------------------------------------------------------
--                                          Initialize Frame                                          --
--------------------------------------------------------------------------------------------------------

local f = CreateFrame("Frame",modName.."Options",UIParent,BackdropTemplateMixin and "BackdropTemplate");	-- 9.0.1: Using BackdropTemplate

UISpecialFrames[#UISpecialFrames + 1] = f:GetName();

f.options = options;

f:SetSize(424,378);
f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3 } });
f:SetBackdropColor(0.1,0.22,0.35,1);
f:SetBackdropBorderColor(0.1,0.1,0.1,1);
f:EnableMouse(true);
f:SetMovable(true);
f:SetFrameStrata("DIALOG");
f:SetToplevel(true);
f:SetClampedToScreen(true);
f:SetScript("OnShow",function(self) self:BuildCategoryPage(); end);
f:Hide();

f.outline = CreateFrame("Frame",nil,f,BackdropTemplateMixin and "BackdropTemplate");	-- 9.0.1: Using BackdropTemplate
f.outline:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
f.outline:SetBackdropColor(0.1,0.1,0.2,1);
f.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
f.outline:SetPoint("TOPLEFT",12,-12);
f.outline:SetPoint("BOTTOMLEFT",12,12);
f.outline:SetWidth(84);

f:SetScript("OnMouseDown",f.StartMoving);
f:SetScript("OnMouseUp",function(self) self:StopMovingOrSizing(); cfg.optionsLeft = self:GetLeft(); cfg.optionsBottom = self:GetBottom(); end);

if (cfg.optionsLeft) and (cfg.optionsBottom) then
	f:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",cfg.optionsLeft,cfg.optionsBottom);
else
	f:SetPoint("CENTER");
end

f.header = f:CreateFontString(nil,"ARTWORK","GameFontHighlight");
f.header:SetFont(GameFontNormal:GetFont(),22,"THICKOUTLINE");
f.header:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",10,-4);
f.header:SetText(modName..L" Options");

f.vers = f:CreateFontString(nil,"ARTWORK","GameFontNormal");
f.vers:SetPoint("TOPRIGHT",-20,-20);
f.vers:SetText(GetAddOnMetadata(modName,"Version"));
f.vers:SetTextColor(1,1,0.5);

local function Reset_OnClick(self)
	for index, option in ipairs(options[activePage]) do
		if (option.var) then
			cfg[option.var] = nil;	-- when cleared, they will read the default value from the metatable
		end
	end
	TipTac:ApplySettings();
	f:BuildCategoryPage();
end

f.btnAnchor = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnAnchor:SetSize(75,24);
f.btnAnchor:SetPoint("BOTTOMLEFT",f.outline,"BOTTOMRIGHT",10,3);
f.btnAnchor:SetScript("OnClick",function() TipTac:SetShown(not TipTac:IsShown()) end);
f.btnAnchor:SetText(L"Anchor");

f.btnReset = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnReset:SetSize(75,24);
f.btnReset:SetPoint("LEFT",f.btnAnchor,"RIGHT",38,0);
f.btnReset:SetScript("OnClick",Reset_OnClick);
f.btnReset:SetText(L"Defaults");

f.btnClose = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnClose:SetSize(75,24);
f.btnClose:SetPoint("BOTTOMRIGHT",-15,15);
f.btnClose:SetScript("OnClick",function() f:Hide(); end);
f.btnClose:SetText(L"Close");

--------------------------------------------------------------------------------------------------------
--                                        Options Category List                                       --
--------------------------------------------------------------------------------------------------------

local listButtons = {};

local function CategoryButton_OnClick(self,button)
	listButtons[activePage].text:SetTextColor(1,0.82,0);
	listButtons[activePage]:UnlockHighlight();
	activePage = self.index;
	self.text:SetTextColor(1,1,1);
	self:LockHighlight();
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);	-- "igMainMenuOptionCheckBoxOn"
	f:BuildCategoryPage();
end

local buttonWidth = (f.outline:GetWidth() - 8);
local function CreateCategoryButtonEntry(parent)
	local b = CreateFrame("Button",nil,parent);
	b:SetSize(buttonWidth,18);
	b:SetScript("OnClick",CategoryButton_OnClick);
	b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	b:GetHighlightTexture():SetAlpha(0.7);
	b.text = b:CreateFontString(nil,"ARTWORK","GameFontNormal");
	b.text:SetPoint("LEFT",3,0);
	listButtons[#listButtons + 1] = b;
	return b;
end

for index, table in ipairs(options) do
	local button = listButtons[index] or CreateCategoryButtonEntry(f.outline);
	button.text:SetText(table[0]);
	button.index = index;
	if (index == 1) then
		button:SetPoint("TOPLEFT",f.outline,"TOPLEFT",5,-6);
	else
		button:SetPoint("TOPLEFT",listButtons[index - 1],"BOTTOMLEFT");
	end
	if (index == activePage) then
		button.text:SetTextColor(1,1,1);
		button:LockHighlight();
	end
end

--------------------------------------------------------------------------------------------------------
--                                        Build Option Category                                       --
--------------------------------------------------------------------------------------------------------

-- Get Setting
local function GetConfigValue(self,var)
	return cfg[var];
end

-- called when a setting is changed, do not allow
local function SetConfigValue(self,var,value)
	if (not self.isBuildingOptions) then
		cfg[var] = value;
		TipTac:ApplySettings();
	end
end

-- create new factory instance
local factory = AzOptionsFactory:New(f,GetConfigValue,SetConfigValue);
f.factory = factory; 

-- Build Page
function f:BuildCategoryPage()
	factory:BuildOptionsPage(options[activePage],f.outline,f.outline:GetWidth(),38);
end