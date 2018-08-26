
local CopyTable = TidyPlatesUtility.copyTable

TidyPlatesHubCache = {}
TidyPlatesHubSettings = {}

TidyPlatesHubDefaults = {
	-- Profile
	---------------------------------------
	UseGlobalSet = false,

	-- Style
	---------------------------------------
	StyleHeadlineOutOfCombat = false,


	StyleFriendlyBarsOnActive = false,
	StyleFriendlyBarsOnElite = false,
	StyleFriendlyBarsInstanceMode = false,
	StyleFriendlyBarsOnPlayers = false,
	StyleFriendlyBarsOnNPC = false,

	StyleEnemyBarsOnActive = true,
	StyleEnemyBarsOnElite = true,
	StyleEnemyBarsInstanceMode = false,
	StyleEnemyBarsOnPlayers = true,
	StyleEnemyBarsOnNPC = true,

	StyleForceBarsOnTargets = true,

	StyleHeadlineNeutral = false,
	StyleHeadlineMiniMobs = false,

	ColorEnemyBarMode =  1,
	ColorEnemyNameMode = 1,
	ColorEnemyStatusTextMode = 1,

	ColorFriendlyBarMode =  1,
	ColorFriendlyNameMode = 1,
	ColorFriendlyStatusTextMode = 1,

	TextShowOnlyOnActive = false,




	-- Headline
	---------------------------------------
	StyleEnemyMode = 1,
	StyleFriendlyMode = 2,

	HeadlineEnemyColor = 4,
	HeadlineFriendlyColor = 4,
	HeadlineEnemySubtext = 3,


	-- Opacity
	---------------------------------------
	OpacityTarget = 1,
	OpacityNonTarget = .75,
	--OpacitySpotlightMode = 1,

	EnemyAlphaSpotlightMode = 2,
	FriendlyAlphaSpotlightMode = 1,

	OpacitySpotlight = .90,
	OpacityFullNoTarget = true,				-- Use full opacity when No Target

	--OpacityFullSpell = false,				-- Deprecated 6.13
	--OpacityFullMouseover = false,			-- Deprecated 6.13

	OpacitySpotlightSpell = false,			-- Added 6.14
	OpacitySpotlightMouseover = false,		-- Added 6.14
	OpacitySpotlightRaidMarked = false,		-- Added 6.14

	-- Unit Spotlight
	---------------------------------------
	UnitSpotlightOpacity = 1,
	UnitSpotlightScale = 1.5,
	UnitSpotlightColor = {r = .9, g = 0, b = .9,},
	UnitSpotlightOpacityEnable = true,
	UnitSpotlightScaleEnable = true,
	UnitSpotlightBarEnable = true,
	UnitSpotlightGlowEnable = false,
	UnitSpotlightList = "爆炸物\n邪能炸药\nTest地下城训练假人",
	UnitSpotlightLookup = {},
    UnitSpotlightVersion = "20180804",

	-- Filter
	---------------------------------------
	OpacityFiltered = 0,
	ScaleFiltered = .8,
	FilterScaleLock = false,

	OpacityFilterNeutralUnits = false,		-- OpacityHideNeutral = false,
	OpacityFilterNonElite = false,			-- OpacityHideNonElites = false,
	OpacityFilterEnemyNPC = false,
	OpacityFilterPlayers = false,
	OpacityFilterFriendlyNPC = false,
	OpacityFilterInactive = false,
	OpacityFilterMini = false,
	OpacityFilterUntitledFriendlyNPC = false,

	OpacityFilterList = "Fanged Pit Viper\nLiberated Karabor Prisoner",
	OpacityFilterLookup = {},

	-- Scale
	---------------------------------------
	ScaleStandard = 1,
	ScaleSpotlight = 1.2,
	ScaleSpotlightMode = 2,
	ScaleIgnoreNeutralUnits = true,
	ScaleIgnoreNonEliteUnits = false,
	ScaleIgnoreInactive = false,
	ScaleCastingSpotlight = false,
	ScaleTargetSpotlight = false,
	--ScaleMiniMobs = true,
	ScaleMouseoverSpotlight = false,

	-- Text
	---------------------------------------
	TextShowLevel = false,
	TextUseBlizzardFont = false,
	TextHealthTextMode = 1,
	TextShowOnlyOnTargets = false,

	-- Color
	---------------------------------------
	ColorHealthBarMode = 3,
	ColorDangerGlowMode = 2,
	TextNameColorMode = 1,
	ClassColorPartyMembers = false,
	EnableOffTankHighlight = false,

	-- Threat
	---------------------------------------
	ThreatMode = 1,
	ThreatGlowEnable2 = false,
	ColorThreatWarning = {r = .8, g = 0, b = 0,},		-- Orange
	ColorThreatTransition = {r = 255/255, g = 160/255, b = 0},	-- Yellow
	ColorThreatSafe = {r = 15/255, g = 150/255, b = 230/255},	-- Bright Blue
	ColorAttackingOtherTank = {r = 15/255, g = 170/255, b = 200/255},	-- Bright Blue
	ColorShowPartyAggro = false,
	ColorPartyAggro = {r = 255/255, g = 0, b = .4,},
	ColorPartyAggroBar = false,
	ColorPartyAggroGlow = true,
	ColorPartyAggroText = false,


	-- Reaction
	---------------------------------------
	ColorFriendlyNPC = {r = 0, g = 1, b = 0,},
	ColorFriendlyPlayer = {r = 0, g = 0, b = 1,},
	ColorNeutral = {r = 1, g = 1, b = 0,},
	ColorHostileNPC = {r = 1, g = 0, b = 0,},
	ColorHostilePlayer = {r = 1, g = 0, b = 0,},
	ColorGuildMember = {r = 60/255, g = 168/255, b = 255/255,},

	TextColorFriendlyNPC = {r = 96/255, g = 224/255, b = 37/255,},
	TextColorFriendlyPlayer = {r = 60/255, g = 168/255, b = 255/255,},
	TextColorNeutral = {r = 252/255, g = 180/255, b = 27/255,},
	TextColorHostileNPC = {r = 255/255, g = 51/255, b = 32/255,},
	TextColorHostilePlayer = {r = 255/255, g = 51/255, b = 32/255,},
	TextColorGuildMember = {r = 60/255, g = 168/255, b = 255/255,},

	ColorTapped = {r = 110/255, g = 110/255, b = 110/255,},

	-- Casting
	---------------------------------------
	ColorNormalSpellCast = { r = 252/255, g = 140/255, b = 0, },
	ColorUnIntpellCast = { r = 0.5137243866920471, g = 0.7529395222663879, b = 0.7647042274475098, },
	SpellCastEnableFriendly = false,

	-- Status Text
	---------------------------------------
	StatusTextLeft = 8,
	StatusTextCenter = 5,
	StatusTextRight = 7,

	StatusTextLeftColor = true,
	StatusTextCenterColor = true,
	StatusTextRightColor = true,



	-- Health
	---------------------------------------
	HighHealthThreshold = .7,
	LowHealthThreshold = .3,
	ColorLowHealth = {r = 1, g = 0, b = 0,},		-- Orange
	ColorMediumHealth = {r = 1, g = 1, b = 0},	-- Yellow
	ColorHighHealth = {r = 0, g = 1, b = .2},	-- Bright Blue

	-- Widgets
	---------------------------------------
	WidgetTargetHighlight = true,
	WidgetEliteIndicator = true,
	ClassEnemyIcon = false,
	ClassPartyIcon = false,
	WidgetsTotemIcon = false,
	WidgetsComboPoints = true,
	WidgetsThreatIndicator = true,
	WidgetsRangeIndicator = false,
	WidgetsRangeMode = 1,
	WidgetsEnableExternal = true,

	-- Aura Widget
	---------------------------------------
	WidgetsDebuff = true,
	WidgetsDebuffStyle = 2,
	--WidgetsAuraMode = 1,
	WidgetsMyDebuff = true,
	WidgetsMyBuff = false,
    WidgetsHostileBuff = true,
    WidgetsHostileBuffStealableOnly2 = true,
	WidgetsDebuffTrackList = "", --"My Rake\nMy Rip\nMy Moonfire\nAll 339\nMy Regrowth\nMy Rejuvenation\nNot Facepalm Bolt",
	WidgetsDebuffLookup = {},
	WidgetsDebuffPriority = {},
	WidgetAuraTrackDispelFriendly = false,
	WidgetAuraTrackCurse = true,
	WidgetAuraTrackDisease = true,
	WidgetAuraTrackMagic = true,
	WidgetAuraTrackPoison = true,

	-- Frame
	---------------------------------------
	FrameVerticalPosition = .7,
	AdvancedEnableUnitCache = true,
	FocusAsTarget = false,
	FrameBarWidth = 1,
	--AdvancedHealthTextList = [[return unit.health]],
}

TidyPlatesHubGlobal = CopyTable(TidyPlatesHubDefaults)






