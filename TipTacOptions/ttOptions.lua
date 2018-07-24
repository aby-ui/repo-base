local L = LibStub("AceLocale-3.0"):GetLocale("TipTac") 

local cfg = TipTac_Config;
local modName = "TipTac";
local ignoreConfigUpdate;

-- DropDown Lists
local DROPDOWN_FONTFLAGS = {
	[L["|cffffa0a0None"]] = "",
	[L["Outline"]] = "OUTLINE",
	[L["Thick Outline"]] = "THICKOUTLINE",
};
local DROPDOWN_ANCHORTYPE = {
	[L["Normal Anchor"]] = "normal",
	[L["Mouse Anchor"]] = "mouse",
	[L["Parent Anchor"]] = "parent",
};

local DROPDOWN_ANCHORPOS = {
	[L["Top"]] = "TOP",
	[L["Top Left"]] = "TOPLEFT",
	[L["Top Right"]] = "TOPRIGHT",
	[L["Bottom"]] = "BOTTOM",
	[L["Bottom Left"]] = "BOTTOMLEFT",
	[L["Bottom Right"]] = "BOTTOMRIGHT",
	[L["Left"]] = "LEFT",
	[L["Right"]] = "RIGHT",
	[L["Center"]] = "CENTER",
};

local DROPDOWN_BARTEXTFORMAT = {
	[L["|cffffa0a0None"]] = "none",
	[L["Percentage"]] = "percent",
	[L["Current Only"]] = "current",
	[L["Values"]] = "value",
	[L["Values & Percent"]] = "full",
	[L["Deficit"]] = "deficit",
};

-- Options -- The "y" value of a category subtable, will further increase the vertical offset position of the *next* item
local activePage = 1;
local frames = {};
local options = {
	-- General
	{
		[0] = L["General"],
		{ type = "Check", var = "showUnitTip", label = L["Enable TipTac Unit Tip Appearance"], tip = L["Will change the appearance of how unit tips look. Many options in TipTac only work with this setting enabled.\nNOTE: Using this options with a non English client may cause issues!"], y = 8 },
		{ type = "Check", var = "showStatus", label = L["Show DC, AFK and DND Status"], tip = L["Will show the <DC>, <AFK> and <DND> status after the player name"] },
		{ type = "Check", var = "showGuildRank", label = L["Show Player Guild Rank Title"], tip = L["In addition to the guild name, with this option on, you will also see their guild rank by title"] },
		{ type = "Check", var = "showTargetedBy", label = L["Show Who Targets the Unit"], tip = L["When in a raid or party, the tip will show who from your group is targeting the unit"] },
		{ type = "Check", var = "showPlayerGender", label = L["Show Player Gender"], tip = L["This will show the gender of the player. E.g. \"85 Female Blood Elf Paladin\"."], y = 16 },
		{ type = "DropDown", var = "nameType", label = L["Name Type"], list = { [L["Name only"]] = "normal", [L["Use player titles"]] = "title", [L["Copy from original tip"]] = "original", [L["Mary Sue Protocol"]] = "marysueprot" } },
		{ type = "DropDown", var = "showRealm", label = L["Show Unit Realm"], list = { [L["Do not show realm"]] = "none", [L["Show realm"]] = "show", [L["Show (*) instead"]] = "asterisk" } },
		{ type = "DropDown", var = "showTarget", label = L["Show Unit Target"], list = { [L["Do not show target"]] = "none", [L["First line"]] = "first", [L["Second line"]] = "second", [L["Last line"]] = "last" }, y = 16 },
		{ type = "Text", var = "targetYouText", label = L["Targeting You Text"] },
	},
	-- Special
	{
		[0] = L["Special"],
		{ type = "Check", var = "showBattlePetTip", label = L["Enable Battle Pet Tips"], tip = L["Will show a special tip for both wild and companion battle pets. Might need to be disabled for certain non-English clients"], y = 8 },
		{ type = "Slider", var = "gttScale", label = L["Tooltip Scale"], min = 0.2, max = 4, step = 0.05 },
		{ type = "Slider", var = "updateFreq", label = L["Tip Update Frequency"], min = 0, max = 5, step = 0.05, y = 24 },
		{ type = "Check", var = "enableChatHoverTips", label = L["Enable ChatFrame Hover Hyperlinks"], tip = L["When hovering the mouse over a link in the chatframe, show the tooltip without having to click on it"] },
		{ type = "Check", var = "hideFactionText", label = L["Hide Faction Text"], tip = L["Strips the Alliance or Horde faction text from the tooltip"] },
		{ type = "Check", var = "hideRealmText", label = L["Hide Coalesced Realm Text"], tip = L["Strips the Coalesced Realm text from the tooltip"] },
 	},
	-- Colors
	{
		[0] = L["Colors"],
		{ type = "Check", var = "colorGuildByReaction", label = L["Color Guild by Reaction"], tip = L["Guild color will have the same color as the reacion"], y = 8 },
		{ type = "Color", subType = 2, var = "colGuild", label = L["Guild Color"], tip = L["Color of the guild name, when not using the option to make it the same as reaction color"] },
		{ type = "Color", subType = 2, var = "colSameGuild", label = L["Your Guild Color"], tip = L["To better recognise players from your guild, you can configure the color of your guild name individually"], y = 16 },
		{ type = "Color", subType = 2, var = "colRace", label = L["Race & Creature Type Color"], tip = L["The color of the race and creature type text"] },
		{ type = "Color", subType = 2, var = "colLevel", label = L["Neutral Level Color"], tip = L["Units you cannot attack will have their level text shown in this color"], y = 12 },
		{ type = "Check", var = "colorNameByClass", label = L["Color Player Names by Class Color"], tip = L["With this option on, player names are colored by their class color, otherwise they will be colored by reaction"] },
		{ type = "Check", var = "classColoredBorder", label = L["Color Tip Border by Class Color"], tip = L["For players, the border color will be colored to match the color of their class\nNOTE: This option is overridden by reaction colored border"] },
	},
	-- Reactions
	{
		[0] = L["Reactions"],
		{ type = "Check", var = "reactText", label = L["Show the unit's reaction as text"], tip = L["With this option on, the reaction of the unit will be shown as text on the last line"], y = 42 },
		{ type = "Color", subType = 2, var = "colReactText1", label = L["Tapped Color"] },
		{ type = "Color", subType = 2, var = "colReactText2", label = L["Hostile Color"] },
		{ type = "Color", subType = 2, var = "colReactText3", label = L["Caution Color"] },
		{ type = "Color", subType = 2, var = "colReactText4", label = L["Neutral Color"] },
		{ type = "Color", subType = 2, var = "colReactText5", label = L["Friendly NPC or PvP Player Color"] },
		{ type = "Color", subType = 2, var = "colReactText6", label = L["Friendly Player Color"] },
		{ type = "Color", subType = 2, var = "colReactText7", label = L["Dead Color"] },
	},
	-- BG Color
	{
		[0] = L["BG Color"],
		{ type = "Check", var = "reactColoredBackdrop", label = L["Color backdrop based on the unit's reaction"], tip = L["If you want the tip's background color to be determined by the unit's reaction towards you, enable this. With the option off, the background color will be the one selected on the 'Backdrop' page"] },
		{ type = "Check", var = "reactColoredBorder", label = L["Color border based on the unit's reaction"], tip = L["Same as the above option, just for the border\nNOTE: This option overrides class colored border"], y = 20 },
		{ type = "Color", var = "colReactBack1", label = L["Tapped Color"] },
		{ type = "Color", var = "colReactBack2", label = L["Hostile Color"] },
		{ type = "Color", var = "colReactBack3", label = L["Caution Color"] },
		{ type = "Color", var = "colReactBack4", label = L["Neutral Color"] },
		{ type = "Color", var = "colReactBack5", label = L["Friendly NPC or PvP Player Color"] },
		{ type = "Color", var = "colReactBack6", label = L["Friendly Player Color"] },
		{ type = "Color", var = "colReactBack7", label = L["Dead Color"] },
	},
	-- Backdrop
	{
		[0] = L["Backdrop"],
		{ type = "DropDown", var = "tipBackdropBG", label = L["Background Texture"], media = "background" },
		{ type = "DropDown", var = "tipBackdropEdge", label = L["Border Texture"], media = "border", y = 8 },
		{ type = "Slider", var = "backdropEdgeSize", label = L["Backdrop Edge Size"], min = -20, max = 64, step = 0.5 },
		{ type = "Slider", var = "backdropInsets", label = L["Backdrop Insets"], min = -20, max = 20, step = 0.5, y = 18 },
		{ type = "Color", var = "tipColor", label = L["Tip Background Color"] },
		{ type = "Color", var = "tipBorderColor", label = L["Tip Border Color"], y = 10 },
		{ type = "Check", var = "gradientTip", label = L["Show Gradient Tooltips"], tip = L["Display a small gradient area at the top of the tip to add a minor 3D effect to it. If you have an addon like Skinner, you may wish to disable this to avoid conflicts"], y = 6 },
		{ type = "Color", var = "gradientColor", label = L["Gradient Color"], tip = L["Select the base color for the gradient"] },
	},
	-- Font
	{
		[0] = L["Font"],
		{ type = "Check", var = "modifyFonts", label = L["Modify the GameTooltip Font Templates"], tip = L["For TipTac to change the GameTooltip font templates, and thus all tooltips in the User Interface, you have to enable this option.\nNOTE: If you have an addon such as ClearFont, it might conflict with this option."], y = 12 },
		{ type = "DropDown", var = "fontFace", label = L["Font Face"], media = "font" },
		{ type = "DropDown", var = "fontFlags", label = L["Font Flags"], list = DROPDOWN_FONTFLAGS },
		{ type = "Slider", var = "fontSize", label = L["Font Size"], min = 6, max = 29, step = 1, y = 12 },
		{ type = "Slider", var = "fontSizeDelta", label = L["Font Size Delta"], min = 0, max = 10, step = 1 },
	},
	-- Classify
	{
		[0] = L["Classify"],
		{ type = "Text", var = "classification_minus", label = L["Minus"] },
		{ type = "Text", var = "classification_trivial", label = L["Trivial"] },
		{ type = "Text", var = "classification_normal", label = L["Normal"] },
		{ type = "Text", var = "classification_elite", label = L["Elite"] },
		{ type = "Text", var = "classification_worldboss", label = L["Boss"] },
		{ type = "Text", var = "classification_rare", label = L["Rare"] },
		{ type = "Text", var = "classification_rareelite", label = L["Rare Elite"] },
	},
	-- Fading
	{
		[0] = L["Fading"],
		{ type = "Check", var = "overrideFade", label = L["Override Default GameTooltip Fade"], tip = L["Overrides the default fadeout function of the GameTooltip. If you are seeing problems regarding fadeout, please disable."], y = 16 },
		{ type = "Slider", var = "preFadeTime", label = L["Prefade Time"], min = 0, max = 5, step = 0.05 },
		{ type = "Slider", var = "fadeTime", label = L["Fadeout Time"], min = 0, max = 5, step = 0.05, y = 16 },
		{ type = "Check", var = "hideWorldTips", label = L["Instantly Hide World Frame Tips"], tip = L["This option will make most tips which appear from objects in the world disappear instantly when you take the mouse off the object. Examples such as mailboxes, herbs or chests.\nNOTE: Does not work for all world objects."] },
	},
	-- Bars
	{
		[0] = L["Bars"],
		{ type = "DropDown", var = "barFontFace", label = L["Font Face"], media = "font" },
		{ type = "DropDown", var = "barFontFlags", label = L["Font Flags"], list = DROPDOWN_FONTFLAGS },
		{ type = "Slider", var = "barFontSize", label = L["Font Size"], min = 6, max = 29, step = 1, y = 36 },
		{ type = "DropDown", var = "barTexture", label = L["Bar Texture"], media = "statusbar" },
		{ type = "Slider", var = "barHeight", label = L["Bar Height"], min = 1, max = 50, step = 1 },
	},
	-- Bar Types
	{
		[0] = L["Bar Types"],
		{ type = "Check", var = "hideDefaultBar", label = L["Hide the Default Health Bar"], tip = L["Check this to hide the default health bar"] },
		{ type = "Check", var = "barsCondenseValues", label = L["Show Condensed Bar Values"], tip = L["You can enable this option to condense values shown on the bars. It does this by showing 57254 as 57.3k as an example"] },
		{ type = "DropDown", var = "barsCondenseType", label = L["Condense Type"], list = { [L["k/m/g"]] = "kmg", [L["Wan/Yi"]] = "wanyi" }, y = -2 },
		{ type = "Check", var = "healthBar", label = L["Show Health Bar"], tip = L["Will show a health bar of the unit."] },
		{ type = "DropDown", var = "healthBarText", label = L["Health Bar Text"], list = DROPDOWN_BARTEXTFORMAT, y = -2 },
		{ type = "Check", var = "healthBarClassColor", label = L["Class Colored Health Bar"], tip = L["This options colors the health bar in the same color as the player class"], y = 5 },
		{ type = "Color", var = "healthBarColor", label = L["Health Bar Color"], tip = L["The color of the health bar. Has no effect for players with the option above enabled"], y = 5 },
		{ type = "Check", var = "manaBar", label = L["Show Mana Bar"], tip = L["If the unit has mana, a mana bar will be shown."] },
		{ type = "DropDown", var = "manaBarText", label = L["Mana Bar Text"], list = DROPDOWN_BARTEXTFORMAT },
		{ type = "Color", var = "manaBarColor", label = L["Mana Bar Color"], tip = L["The color of the mana bar"], y = 5 },
		{ type = "Check", var = "powerBar", label = L["Show Energy, Rage, Runic Power or Focus Bar"], tip = L["If the unit uses either energy, rage, runic power or focus, a bar for that will be shown."] },
		{ type = "DropDown", var = "powerBarText", label = L["Power Bar Text"], list = DROPDOWN_BARTEXTFORMAT },
	},
	-- Auras
	{
		[0] = L["Auras"],
		{ type = "Check", var = "aurasAtBottom", label = L["Put Aura Icons at the Bottom Instead of Top"], tip = L["Puts the aura icons at the bottom of the tip instead of the default top"], y = 12 },
		{ type = "Check", var = "showBuffs", label = L["Show Unit Buffs"], tip = L["Show buffs of the unit"] },
		{ type = "Check", var = "showDebuffs", label = L["Show Unit Debuffs"], tip = L["Show debuffs of the unit"], y = 12 },
		{ type = "Check", var = "selfAurasOnly", label = L["Only Show Auras Coming from You"], tip = L["This will filter out and only display auras you cast yourself"], y = 12 },
		{ type = "Slider", var = "auraSize", label = L["Aura Icon Dimension"], min = 8, max = 60, step = 1 },
		{ type = "Slider", var = "auraMaxRows", label = L["Max Aura Rows"], min = 1, max = 8, step = 1, y = 8 },
		{ type = "Check", var = "showAuraCooldown", label = L["Show Cooldown Models"], tip = L["With this option on, you will see a visual progress of the time left on the buff"] },
		{ type = "Check", var = "noCooldownCount", label = L["No Cooldown Count Text"], tip = L["Tells cooldown enhancement addons, such as OmniCC, not to display cooldown text"] },
	},
	-- Icon
	{
		[0] = L["Icon"],
		{ type = "Check", var = "iconRaid", label = L["Show Raid Icon"], tip = L["Shows the raid icon next to the tip"] },
		{ type = "Check", var = "iconFaction", label = L["Show Faction Icon"], tip = L["Shows the faction icon next to the tip"] },
		{ type = "Check", var = "iconCombat", label = L["Show Combat Icon"], tip = L["Shows a combat icon next to the tip, if the unit is in combat"] },
		{ type = "Check", var = "iconClass", label = L["Show Class Icon"], tip = L["For players, this will display the class icon next to the tooltip"], y = 12 },
		{ type = "DropDown", var = "iconAnchor", label = L["Icon Anchor"], list = DROPDOWN_ANCHORPOS },
		{ type = "Slider", var = "iconSize", label = L["Icon Dimension"], min = 8, max = 100, step = 1 },
	},
	-- Anchors
	{
		[0] = L["Anchors"],
		{ type = "DropDown", var = "anchorWorldUnitType", label = L["World Unit Type"], list = DROPDOWN_ANCHORTYPE },
		{ type = "DropDown", var = "anchorWorldUnitPoint", label = L["World Unit Point"], list = DROPDOWN_ANCHORPOS, y = 14 },
		{ type = "DropDown", var = "anchorWorldTipType", label = L["World Tip Type"], list = DROPDOWN_ANCHORTYPE },
		{ type = "DropDown", var = "anchorWorldTipPoint", label = L["World Tip Point"], list = DROPDOWN_ANCHORPOS, y = 14 },
		{ type = "DropDown", var = "anchorFrameUnitType", label = L["Frame Unit Type"], list = DROPDOWN_ANCHORTYPE },
		{ type = "DropDown", var = "anchorFrameUnitPoint", label = L["Frame Unit Point"], list = DROPDOWN_ANCHORPOS, y = 14 },
		{ type = "DropDown", var = "anchorFrameTipType", label = L["Frame Tip Type"], list = DROPDOWN_ANCHORTYPE },
		{ type = "DropDown", var = "anchorFrameTipPoint", label = L["Frame Tip Point"], list = DROPDOWN_ANCHORPOS, y = 14 },
	},
	-- Mouse
	{
		[0] = L["Mouse"],
		{ type = "Slider", var = "mouseOffsetX", label = L["Mouse Anchor X Offset"], min = -200, max = 200, step = 1 },
		{ type = "Slider", var = "mouseOffsetY", label = L["Mouse Anchor Y Offset"], min = -200, max = 200, step = 1 },
	},
	-- Combat
	{
		[0] = L["Combat"],
		{ type = "Check", var = "hideAllTipsInCombat", label = L["Hide All Unit Tips in Combat"], tip = L["In combat, this option will prevent any unit tips from showing"] },
		{ type = "Check", var = "hideUFTipsInCombat", label = L["Hide Unit Tips for Unit Frames in Combat"], tip = L["When you are in combat, this option will prevent tips from showing when you have the mouse over a unit frame"], y = 8 },
		{ type = "Check", var = "showHiddenTipsOnShift", label = L["Still Show Hidden Tips when Holding Shift"], tip = L["When you have this option checked, and one of the above options, you can still force the tip to show, by holding down shift"] },
--		{ type = "DropDown", var = "hideCombatTip", label = L["Hide Tips in Combat For"], list = { [L["Unit Frames"]] = "uf", [L["All Tips"]] = "all", [L["No Tips"]] = "none" } },
	},
	-- Layouts
	{
		[0] = L["Layouts"],
		{ type = "DropDown", label = L["Layout Template"], init = TipTacDropDowns.LoadLayout_Init, y = 20 },
--		{ type = "Text", label = L["Save Layout"], func = nil },
--		{ type = "DropDown", label = L["Delete Layout"], init = TipTacDropDowns.DeleteLayout_Init },
	},
};

-- TipTacTalents Support
if (TipTacTalents) then
	options[#options + 1] = {
		[0] = L["Talents"],
		{ type = "Check", var = "showTalents", label = L["Enable TipTacTalents"], tip = L["This option makes the tip show the talent specialization of other players"] },
		{ type = "Check", var = "talentOnlyInParty", label = L["Only Show Talents for Players in Party or Raid"], tip = L["When you enable this, only talents of players in your party or raid will be requested and shown"], y = 12 },
--		{ type = "DropDown", var = "talentFormat", label = L["Talent Format"], list = { [L["Elemental (57/14/00)"]] = 1, [L["Elemental"]] = 2, [L["57/14/00"]] = 3,}, y = 8 },	-- not supported with MoP changes
		{ type = "Slider", var = "talentCacheSize", label = L["Talent Cache Size"], min = 0, max = 50, step = 1 },
	};
end

-- TipTacItemRef Support -- Az: this category page is full
if (TipTacItemRef) then
	options[#options + 1] = {
		[0] = L["ItemRef"],
		{ type = "Check", var = "if_enable", label = L["Enable ItemRefTooltip Modifications"], tip = L["Turns on or off all features of the TipTacItemRef addon"], y = 8 },
		{ type = "Color", var = "if_infoColor", label = L["Information Color"], tip = L["The color of the various tooltip lines added by these options"] },
		{ type = "Check", var = "if_itemQualityBorder", label = L["Show Item Tips with Quality Colored Border"], tip = L["When enabled and the tip is showing an item, the tip border will have the color of the item's quality"] },
		{ type = "Check", var = "if_showAuraCaster", label = L["Show Aura Tooltip Caster"], tip = L["When showing buff and debuff tooltips, it will add an extra line, showing who cast the specific aura"] },
		{ type = "Check", var = "if_showItemLevelAndId", label = L["Show Item Level & ID"], tip = L["For item tooltips, show their itemLevel and itemID"] },
		{ type = "Check", var = "if_showSpellIdAndRank", label = L["Show Spell ID & Rank"], tip = L["For spell and aura tooltips, show their spellID and spellRank"] },
--		{ type = "Check", var = "if_showCurrencyId", label = L["Show Currency ID"], tip = L["Currency items will now show their ID"] },
--		{ type = "Check", var = "if_showAchievementIdAndCategory", label = L["Show Achievement ID & Category"], tip = L["On achievement tooltips, the achievement ID as well as the category will be shown"] },
		{ type = "Check", var = "if_showQuestLevelAndId", label = L["Show Quest Level & ID"], tip = L["For quest tooltips, show their questLevel and questID"] },
		{ type = "Check", var = "if_modifyAchievementTips", label = L["Modify Achievement Tooltips"], tip = L["Changes the achievement tooltips to show a bit more information\nWarning: Might conflict with other achievement addons"] },
		{ type = "Check", var = "if_showIcon", label = L["Show Icon Texture and Stack Count (when available)"], tip = L["Shows an icon next to the tooltip. For items, the stack count will also be shown"] },
		{ type = "Check", var = "if_smartIcons", label = L["Smart Icon Appearance"], tip = L["When enabled, TipTacItemRef will determine if an icon is needed, based on where the tip is shown. It will not be shown on actionbars or bag slots for example, as they already show an icon"] },
		{ type = "Check", var = "if_borderlessIcons", label = L["Borderless Icons"], tip = L["Turn off the border on icons"] },
		{ type = "Slider", var = "if_iconSize", label = L["Icon Size"], min = 16, max = 128, step = 1 },
	};
end

--------------------------------------------------------------------------------------------------------
--                                          Initialize Frame                                          --
--------------------------------------------------------------------------------------------------------

local f = CreateFrame("Frame",modName.."Options",UIParent);

f.options = options;

f:SetWidth(424);
f:SetHeight(378);	-- "18" per category entry
f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3 } });
f:SetBackdropColor(0.1,0.22,0.35,1);
f:SetBackdropBorderColor(0.1,0.1,0.1,1);
f:EnableMouse(true);
f:SetMovable(true);
f:SetFrameStrata("DIALOG");
f:SetToplevel(true);
f:SetClampedToScreen(true);
f:SetScript("OnShow",function() f:BuildCategoryPage(); end);
f:Hide();

f.outline = CreateFrame("Frame",nil,f);
f.outline:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
f.outline:SetBackdropColor(0.1,0.1,0.2,1);
f.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
f.outline:SetPoint("TOPLEFT",12,-12);
f.outline:SetPoint("BOTTOMLEFT",12,12);
f.outline:SetWidth(84);

f:SetScript("OnMouseDown",function() f:StartMoving() end);
f:SetScript("OnMouseUp",function() f:StopMovingOrSizing(); cfg.optionsLeft = f:GetLeft(); cfg.optionsBottom = f:GetBottom(); end);

if (cfg.optionsLeft) and (cfg.optionsBottom) then
	f:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",cfg.optionsLeft,cfg.optionsBottom);
else
	f:SetPoint("CENTER");
end

f.header = f:CreateFontString(nil,"ARTWORK","GameFontHighlight");
f.header:SetFont(GameFontNormal:GetFont(),22,"THICKOUTLINE");
f.header:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",10,-4);
f.header:SetText(modName..L[" Options"]);

f.vers = f:CreateFontString(nil,"ARTWORK","GameFontNormal");
f.vers:SetPoint("TOPRIGHT",-20,-20);
f.vers:SetText(GetAddOnMetadata(modName,"Version"));
f.vers:SetTextColor(1,1,0.5);

local function Reset_OnClick(self)
	for index, tbl in ipairs(options[activePage]) do
		if (tbl.var) then
			cfg[tbl.var] = nil;
		end
	end
	TipTac:ApplySettings();
	f:BuildCategoryPage();
end

f.btnAnchor = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnAnchor:SetWidth(75);
f.btnAnchor:SetHeight(24);
f.btnAnchor:SetPoint("BOTTOMLEFT",f.outline,"BOTTOMRIGHT",10,3);
f.btnAnchor:SetScript("OnClick",function() if (TipTac:IsVisible()) then TipTac:Hide(); else TipTac:Show(); end end);
f.btnAnchor:SetText(L["Anchor"]);

f.btnReset = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnReset:SetWidth(75);
f.btnReset:SetHeight(24);
f.btnReset:SetPoint("LEFT",f.btnAnchor,"RIGHT",38,0);
f.btnReset:SetScript("OnClick",Reset_OnClick);
f.btnReset:SetText(L["Defaults"]);

f.btnClose = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnClose:SetWidth(75);
f.btnClose:SetHeight(24);
f.btnClose:SetPoint("BOTTOMRIGHT",-15,15);
f.btnClose:SetScript("OnClick",function() f:Hide(); end);
f.btnClose:SetText(L["Close"]);

UISpecialFrames[#UISpecialFrames + 1] = f:GetName();

--------------------------------------------------------------------------------------------------------
--                                        Options Category List                                       --
--------------------------------------------------------------------------------------------------------

local listButtons = {};

local function List_OnClick(self,button)
	listButtons[activePage].text:SetTextColor(1,0.82,0);
	listButtons[activePage]:UnlockHighlight();
	activePage = self.index;
	self.text:SetTextColor(1,1,1);
	self:LockHighlight();
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);	-- "igMainMenuOptionCheckBoxOn"
	f:BuildCategoryPage();
end

local buttonWidth = (f.outline:GetWidth() - 8);
local function MakeListEntry()
	local b = CreateFrame("Button",nil,f.outline);
	b:SetWidth(buttonWidth);
	b:SetHeight(18);
	b:SetScript("OnClick",List_OnClick);
	b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	b:GetHighlightTexture():SetAlpha(0.7);
	b.text = b:CreateFontString(nil,"ARTWORK","GameFontNormal");
	b.text:SetPoint("LEFT",3,0);
	listButtons[#listButtons + 1] = b;
	return b;
end

local button;
for index, table in ipairs(options) do
	button = listButtons[index] or MakeListEntry();
	button.text:SetText(table[0]);
	button.index = index;
	if (index == 1) then
		button:LockHighlight();
		button.text:SetTextColor(1,1,1);
		button:SetPoint("TOPLEFT",f.outline,"TOPLEFT",5,-6);
	else
		button:SetPoint("TOPLEFT",listButtons[index - 1],"BOTTOMLEFT");
	end
end

--------------------------------------------------------------------------------------------------------
--                                        Build Option Category                                       --
--------------------------------------------------------------------------------------------------------

local function ChangeSettingFunc(self,var,value)
	if (not ignoreConfigUpdate) then
		cfg[var] = value;
		TipTac:ApplySettings();
	end
end

local factory = AzOptionsFactory:New(f,nil,ChangeSettingFunc);

-- Build Page
function f:BuildCategoryPage()
	AzDropDown:HideMenu();
	factory:ResetObjectUse();
	local frame;
	local yOffset = -38;
	-- Loop Through Options
	ignoreConfigUpdate = 1;
	for index, option in ipairs(options[activePage]) do
		-- Init & Setup the Frame
		frame = factory:GetObject(option.type);
		frame.option = option;
		frame.text:SetText(option.label);
		-- slider
		if (option.type == "Slider") then
			frame.slider:SetMinMaxValues(option.min,option.max);
			frame.slider:SetValueStep(option.step);
			frame.slider:SetValue(cfg[option.var]);
			frame.edit:SetNumber(cfg[option.var]);
			frame.low:SetText(option.min);
			frame.high:SetText(option.max);
		-- check
		elseif (option.type == "Check") then
			frame:SetHitRectInsets(0,frame.text:GetWidth() * -1,0,0);
			frame:SetChecked(cfg[option.var]);
		-- color
		elseif (option.type == "Color") then
			frame:SetHitRectInsets(0,frame.text:GetWidth() * -1,0,0);
			if (option.subType == 2) then
				frame.color[1], frame.color[2], frame.color[3], frame.color[4] = factory:HexStringToRGBA(cfg[option.var]);
			else
				frame.color[1], frame.color[2], frame.color[3], frame.color[4] = unpack(cfg[option.var]);
			end
			frame.texture:SetVertexColor(frame.color[1],frame.color[2],frame.color[3],frame.color[4] or 1);
		-- dropdown
		elseif (option.type == "DropDown") then
			frame.InitFunc = (option.init or option.media and TipTacDropDowns.SharedMediaLib_Init or TipTacDropDowns.Default_Init);
			frame:InitSelectedItem(cfg[option.var]);
		-- text
		elseif (option.type == "Text") then
			frame:SetText(cfg[option.var]:gsub("|","||"));
		end
		-- Anchor the Frame
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",factory.objectOffsetX[option.type] + (option.x or 0),yOffset);
		yOffset = (yOffset - frame:GetHeight() - factory.objectOffsetY[option.type] - (option.y or 0));
		-- Show
		frame:Show();
	end
	-- End Update
	ignoreConfigUpdate = nil;
end
