local L = LibStub("AceLocale-3.0"):GetLocale("TipTac") 

TipTacDropDowns = {};
local cfg = TipTac_Config;

-- Shared Media
local LSM = LibStub and LibStub("LibSharedMedia-3.0",1);

--------------------------------------------------------------------------------------------------------
--                                        Default DropDown Init                                       --
--------------------------------------------------------------------------------------------------------

local function Default_SelectValue(dropDown,entry,index)
	cfg[dropDown.option.var] = entry.value;
	TipTac:ApplySettings();
end

function TipTacDropDowns.Default_Init(dropDown,list)
	dropDown.SelectValueFunc = Default_SelectValue;
	local tbl;
	for text, option in next, dropDown.option.list do
		tbl = list[#list + 1]
		tbl.text = text; tbl.value = option;
	end
end

--------------------------------------------------------------------------------------------------------
--                                          Lib Shared Media                                          --
--------------------------------------------------------------------------------------------------------

local LibSharedMediaSubstitute = not LSM and {
	["font"] = {
		["Friz Quadrata TT"] = "Fonts\\FRIZQT__.TTF",
		["Arial Narrow"] = "Fonts\\ARIALN.TTF",
		["Skurri"] = "Fonts\\SKURRI.TTF",
		["Morpheus"] = "Fonts\\MORPHEUS.TTF",
	},
	["background"] = {
		["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Background",
		["Solid"] = "Interface\\Buttons\\WHITE8X8",
	},
	["border"] = {
		["None"] = "Interface\\None",
		["Blizzard Dialog"]  = "Interface\\DialogFrame\\UI-DialogBox-Border",
		["Blizzard Tooltip"] = "Interface\\Tooltips\\UI-Tooltip-Border",
		["Solid"] = "Interface\\Buttons\\WHITE8X8",
	},
	["statusbar"] = {
		["Blizzard StatusBar"] = "Interface\\TargetingFrame\\UI-StatusBar",
	},
} or nil;

if (LSM) then
	LSM:Register("border","Solid","Interface\\Buttons\\WHITE8X8");
end

function TipTacDropDowns.SharedMediaLib_Init(dropDown,list)
	local query = dropDown.option.media;
	dropDown.SelectValueFunc = Default_SelectValue;
	local tbl;
	if (LSM) then
		for _, name in next, LSM:List(query) do
			tbl = list[#list + 1];
			tbl.text = name; tbl.value = LSM:Fetch(query,name);
		end
	else
		for name, value in next, LibSharedMediaSubstitute[query] do
			tbl = list[#list + 1];
			tbl.text = name; tbl.value = value;
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Layout Presets                                           --
--------------------------------------------------------------------------------------------------------

local layout_presets = {
	-- TipTac Layout (New)
	["TipTac New Style"] = {
		showTarget = "last",
		targetYouText = L["<<YOU>>"],

		tipBackdropBG = "Interface\\Buttons\\WHITE8X8",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		backdropEdgeSize = 14,
		backdropInsets = 2.5,
		tipColor = { 0.1, 0.1, 0.2, 1.0 },
		tipBorderColor = { 0.3, 0.3, 0.4, 1.0 },
		gradientTip = true,
		gradientColor = { 0.8, 0.8, 0.8, 0.2 },

		reactColoredBackdrop = false,

		colSameGuild = "|cffff32ff",
		colRace = "|cffffffff",
		colLevel = "|cffc0c0c0",

		colorNameByClass = false,
		classColoredBorder = false,

		barFontFace = "Fonts\\ARIALN.TTF",
		barFontSize = 10,
		barFontFlags = "OUTLINE",
		barHeight = 6,

		classification_minus = L["-%s "],
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

		hideDefaultBar = true,
		healthBar = true,
		healthBarClassColor = true,
		healthBarText = "value",
		healthBarColor = { 0.3, 0.9, 0.3, 1 },
		manaBar = false,
		powerBar = false,
	},
	-- TipTac Layout (Old)
	["TipTac Old Style"] = {
		showTarget = "second",
		targetYouText = L["<<YOU>>"],

		reactColoredBackdrop = false,

		tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		backdropEdgeSize = 16,
		backdropInsets = 4,
		tipColor = { 0.1, 0.1, 0.2, 1.0 },
		tipBorderColor = { 0.3, 0.3, 0.4, 1.0 },
		gradientTip = false,

		colSameGuild = "|cffff32ff",
		colRace = "|cffffffff",
		colLevel = "|cffc0c0c0",

		colorNameByClass = false,
		classColoredBorder = false,

		barFontFace = "Fonts\\FRIZQT__.TTF",
		barFontSize = 12,
		barFontFlags = "OUTLINE",
		barHeight = 6,

		classification_minus = L["-%s "],
		classification_trivial = L["~%s "],
		classification_normal = L["%s "],
		classification_elite = L["+%s "],
		classification_worldboss = L["%s|r (Boss) "],
		classification_rare = L["%s|r (Rare) "],
		classification_rareelite = L["+%s|r (Rare) "],

		hideDefaultBar = true,
		healthBar = true,
		healthBarClassColor = true,
		healthBarText = "value",
		healthBarColor = { 0.3, 0.9, 0.3, 1 },
		manaBar = false,
		powerBar = false,
	},
	-- TipBuddy Layout
	["TipBuddy"] = {
		showTarget = "first",
		targetYouText = L["[YOU]"],

		tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		backdropEdgeSize = 16,
		backdropInsets = 4,
		tipColor = { 0.1, 0.1, 0.1, 0.8 },
		tipBorderColor = { 0.8, 0.8, 0.9, 1.0 },

		reactColoredBackdrop = false,

		colSameGuild = "|cffff32ff",
		colRace = "|cffffffff",
		colLevel = "|cffc0c0c0",

		colorNameByClass = false,
		classColoredBorder = false,

		barFontFace = "Fonts\\ARIALN.TTF",
		barFontSize = 12,
		barFontFlags = "OUTLINE",
		barHeight = 6,

		classification_minus = L["-%s "],
		classification_trivial = L["~%s "],
		classification_normal = L["%s "],
		classification_elite = L["+%s "],
		classification_worldboss = L["%s|r (Boss) "],
		classification_rare = L["%s|r (Rare) "],
		classification_rareelite = L["+%s|r (Rare) "],

		hideDefaultBar = false,
		healthBar = false,
		manaBar = false,
		powerBar = false,
	},
	-- TinyTip Layout
	["TinyTip"] = {
		showTarget = "last",
		targetYouText = L["<<YOU>>"],

		tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		backdropEdgeSize = 16,
		backdropInsets = 4,
		tipColor = { 0, 0, 0, 1 },
		tipBorderColor = { 0, 0, 0, 1 },

		reactColoredBackdrop = true,

		colRace = "|cffddeeaa",
		colLevel = "|cffffcc00",

		classification_minus = L["Level -%s"],
		classification_trivial = L["Level ~%s"],
		classification_normal = L["Level %s"],
		classification_elite = L["Level %s|cffffcc00 Elite"],
		classification_worldboss = L["Level %s|cffff0000 Boss"],
		classification_rare = L["Level %s|cffff66ff Rare"],
		classification_rareelite = L["Level %s|cffffaaff Rare Elite"],

		hideDefaultBar = false,
		healthBar = false,
		manaBar = false,
		powerBar = false,
	},
	-- Solid Border Layout
	["Solid Border"] = {
		showTarget = "last",
		targetYouText = L["|cffff0000<<YOU>>"],

		tipBackdropBG = "Interface\\Buttons\\WHITE8X8",
		tipBackdropEdge = "Interface\\Buttons\\WHITE8X8",
		backdropEdgeSize = 2.5,
		backdropInsets = 0,
		tipColor = { 0.09, 0.09, 0.19, 1.0 },
		tipBorderColor = { 0.6, 0.6, 0.6, 1.0 },

		reactColoredBackdrop = false,

		colorNameByClass = false,
		classColoredBorder = true,
	},
	-- Solid Border Layout
	["Blizzard"] = {
		colorGuildByReaction = true,
		colSameGuild = "|cffff32ff",
		colRace = "|cffffffff",
		colLevel = "|cffc0c0c0",
		colorNameByClass = false,
		classColoredBorder = false,

		reactColoredBackdrop = false,
		reactColoredBorder = false,

		tipBackdropBG = "Interface\\Tooltips\\UI-Tooltip-Background",
		tipBackdropEdge = "Interface\\Tooltips\\UI-Tooltip-Border",
		backdropEdgeSize = 16,
		backdropInsets = 5,
		tipColor = { TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, 1 },
		tipBorderColor = { 1, 1, 1, 1 },
		gradientTip = false,

		fontFace = "Fonts\\FRIZQT__.TTF",
		fontSize = 12,
		fontFlags = "",
		fontSizeDelta = 2,

		classification_minus = L["|rLevel -%s"],
		classification_trivial = L["|rLevel ~%s"],
		classification_normal = L["|rLevel %s"],
		classification_elite = L["|rLevel %s (Elite)"],
		classification_worldboss = L["|rLevel %s (Boss)"],
		classification_rare = L["|rLevel %s (Rare)"],
		classification_rareelite = L["|rLevel %s (Rare Elite)"],

		overrideFade = false,
		hideWorldTips = false,

		hideDefaultBar = false,
		healthBar = false,
		manaBar = false,
		powerBar = false,
	},
};

local function LoadLayout_SelectValue(dropDown,entry,index)
	for name, value in next, layout_presets[entry.value] do
		cfg[name] = value;
	end
	TipTac:ApplySettings();
	dropDown.label:SetText(L["|cff80ff80Layout Loaded"]);
end

local function DeleteLayout_SelectValue(dropDown,entry,index)
	layout_presets[entry.value] = nil;
	dropDown.label:SetText(L["|cffff8080Layout Deleted!"]);
end

function TipTacDropDowns.LoadLayout_Init(dropDown,list)
	dropDown.SelectValueFunc = LoadLayout_SelectValue;
	local tbl;
	for name in next, layout_presets do
		tbl = list[#list + 1];
		tbl.text = name; tbl.value = name;
	end
	dropDown.label:SetText(L["|cff00ff00Pick Layout..."]);
end

function TipTacDropDowns.DeleteLayout_Init(dropDown,list)
	dropDown.SelectValueFunc = DeleteLayout_SelectValue;
	local tbl;
	for name in next, layout_presets do
		tbl = list[#list + 1];
		tbl.text = name; tbl.value = name;
	end
	dropDown.label:SetText(L["|cff00ff00Delete Layout..."]);
end
