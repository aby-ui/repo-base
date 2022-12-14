local E, L = select(2, ...):unpack()


do
	L["Arena"] = ARENA
	L["Battlegrounds"] = BATTLEGROUNDS
	L["Dungeons"] = DUNGEONS
	L["Raids"] = RAIDS
	L["Scenarios"] = SCENARIOS
	L["Outdoor Zones"] = BUG_CATEGORY2
	L["More..."] = LFG_LIST_MORE
	L["Trinket"] = INVTYPE_TRINKET
	L["Interrupt"] = LOC_TYPE_INTERRUPT
	L["Dispels"] = DISPELS
	L["Other"] = OTHER
	L["PvP Trinket"] = GetSpellInfo(42292) or GetSpellInfo(283167) or L["PvP Trinket"]
	L["Racial Traits"] = type(RACIAL_TRAITS) == "string" and gsub(RACIAL_TRAITS, ":", "") or L["Racial Traits"]
	L["Disarm"] = LOC_TYPE_DISARM
	L["Root"] = LOC_TYPE_ROOT
	L["Silence"] = LOC_TYPE_SILENCE
	L["Disrm, Root, Silence"] = format("%s, %s, %s", L["Disarm"], L["Root"], L["Silence"])
	L["Main Hand"] = INVTYPE_WEAPONMAINHAND
	L["Trinket, Main Hand"] = format("%s, %s", L["Trinket"], L["Main Hand"])
	L["Signature Ability"] = COVENANT_PREVIEW_RACIAL_ABILITY or "Signature Ability"
	L["Essence"] = AZERITE_ESSENCE_ITEM_TYPE or "Essence"
	L["Max"] = MAXIMUM
	L["Spells"] = type(SPELLS) == "string" and SPELLS or L["Spells"]
	L["Highlighting"] = HIGHLIGHTING:gsub(":", "")
	L["Custom"] = CUSTOM
	L["Consumables"] = BAG_FILTER_CONSUMABLES
end

E.L_CFG_ZONE = {
	["arena"] = L["Arena"],
	["pvp"] = L["Battlegrounds"],
	["party"] = L["Dungeons"],
	["raid"] = L["Raids"],
}

E.L_ALL_ZONE = {
	["arena"] = L["Arena"],
	["pvp"] = L["Battlegrounds"],
	["party"] = L["Dungeons"],
	["raid"] = L["Raids"],
	["scenario"] = L["Scenarios"],
	["none"] = L["Outdoor Zones"],
}

E.L_PRIORITY = {
	["consumable"] = L["Consumables"],
	["pvptrinket"] = L["PvP Trinket"],
	["racial"] = L["Racial Traits"],
	["trinket"] = L["Trinket"],
	["essence"] = L["Essence"],
	["covenant"] = L["Covenant"],
	["interrupt"] = L["Interrupt"],
	["dispel"] = L["Dispels"],
	["cc"] = L["Crowd Control"],
	["disarm"] = L["Disrm, Root, Silence"],
	["immunity"] = L["Immunity"],
	["externalDefensive"] = L["External Defensive"],
	["defensive"] = L["Defensive"],
	["raidDefensive"] = L["Raid Defensive"],
	["offensive"] = L["Offensive"],
	["counterCC"] = L["Counter CC"],
	["raidMovement"] = L["Raid Movement"],
	["other"] = L["Other"],
	["custom1"] = L["Custom"] .. 1,
	["custom2"] = L["Custom"] .. 2,
}

E.L_HIGHLIGHTS = {
	["pvptrinket"] = L["PvP Trinket"],
	["racial"] = L["Racial Traits"],
	["trinket"] = L["Trinket"],
	["covenant"] = L["Covenant"],
	["immunity"] = L["Immunity"],
	["externalDefensive"] = L["External Defensive"],
	["defensive"] = L["Defensive"],
	["raidDefensive"] = L["Raid Defensive"],
	["offensive"] = L["Offensive"],
	["counterCC"] = L["Counter CC"],
	["raidMovement"] = L["Raid Movement"],
	["other"] = L["Other"],
}

if E.preCata then
	E.L_PRIORITY.essence = nil
	E.L_PRIORITY.covenant = nil
	E.L_HIGHLIGHTS.covenant = nil
end

E.TEXTURES = E.preCata and {
	["White8x8"] = "Interface\\BUTTONS\\White8x8",
	["CLASS"] = "Interface\\Icons\\classicon_",
	["PVPTRINKET"] = "Interface\\Icons\\inv_jewelry_trinketpvp_01",
	["RACIAL"] = "Interface\\Icons\\achievement_character_troll_male",
	["TRINKET"] = "Interface\\Icons\\inv_misc_armorkit_10",
} or {
	["White8x8"] = "Interface\\BUTTONS\\White8x8",

	["CLASS"] = "Interface\\Icons\\classicon_",
	["PVPTRINKET"] = "Interface\\Icons\\ability_pvp_gladiatormedallion",
	["RACIAL"] = "Interface\\Icons\\Achievement_character_human_female",
	["TRINKET"] = "Interface\\Icons\\inv_60pvp_trinket2d",
	["ESSENCES"] = "Interface\\Icons\\inv_heartofazeroth",
	["COVENANT"] = 3257750,
	["CONSUMABLE"] = 3566860,
}

E.BORDERLESS_TCOORDS = { 0.07, 0.93, 0.07, 0.93 }
E.BASE_ICON_SIZE = 36

E.STR = {
	["RELOAD_UI"] = L["Reload UI?"],
	["ENABLE_BLIZZARD_CRF"] = L["Blizzard Raid Frames has been disabled by your AddOn(s). Enable and reload UI?"],
	["UNSUPPORTED_ADDON"] = L["Raid Frames for testing doesn't exist for %s. If it fails to load, configure OmniCD while in a group or temporarily set it to \'Manual Mode\'."],
	["MAX_RANGE"] = L["Max"] .. ": 999",
	["MAX_RANGE_3600"] = L["Max"] .. ": 3600",
	["ENABLE_HUDEDITMODE_FRAME"] = L["You must manually enable either the \'Party Frames\' or \'Raid Frames\' in Blizzard's \'HUD Edit Mode\'."],
	["WHATS_NEW_ESCSEQ"] = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t ",
}

E.HEX_C = {


	[1]			= "|cff99ffcd",
	[2]			= "|cff0291b0",
	[5]			= "|cff7bbb4e",
	[11]			= "|cff99cdff",

	[321076]		= "|cff2aa2ff",
	[321079]		= "|cffe40d0d",
	[321077]		= "|cff80b5fd",
	[321078]		= "|cff17c864",

	["PERFORMANCE_BLUE"]	= "|cff99cdff",
	["BR31_MINT"]		= "|cff99ffcd",
	["CURSE_ORANGE"]	= "|cfff16436",
	["TWITCH_PURPLE"]	= "|cff9146ff",
	["OMNICD_RED"]		= "|cffc10003",
	["OMNICD_MAROON"]	= "|cff69000b",
	["NORMAL_FONT"]		= "|cffffd200",
	["HIGHLIGHT_FONT"]	= "|cffffffff",
	["RED_FONT"]		= "|cffff2020",
	["GREEN_FONT"]		= "|cff20ff20",
	["GRAY_FONT"]		= "|cff808080",
	["YELLOW_FONT"]		= "|cffffff00",
	["LIGHTYELLOW_FONT"]	= "|cffffff9a",
	["ORANGE_FONT"]		= "|cffff7f3f",
	["ACHIEVEMENT"]		= "|cffffff00",
	["BATTLENET_FONT"]	= "|cff82c5ff",
	["DISABLED_FONT"]	= "|cff7f7f7f",
	["CLOSE"]		= "|r",
}

E.RGB_C = {
	["PERFORMANCE_BLUE"] = { 0.596, 0.808, 1.0 },
	["BR31_MINT"] = { 0.6, 1.0, 0.804 },
	["CURSE_ORANGE"] = { 0.945, 0.392, 0.212 },
	["TWITCH_PURPLE"] = { 0.569, 0.275, 1.0 },
	["OMNICD_RED"] = { 0.757, 0.0, 0.012 },
	["OMNICD_MAROON"] = { 0.412, 0.0, 0.043 },
	["NORMAL_FONT"] = { 1.0, 0.82, 0.0 },
	["HIGHLIGHT_FONT"] = { 1.0, 1.0, 1.0 },
	["RED_FONT"] = { 1.0, 0.1, 0.1 },
	["DIM_RED_FONT"] = { 0.8, 0.1, 0.1 },
	["GREEN_FONT"] = { 0.1, 1.0, 0.1 },
	["GRAY_FONT"] = { 0.5, 0.5, 0.5 },
	["YELLOW_FONT"] = { 1.0, 1.0, 0.0 },
	["LIGHTYELLOW_FONT"] = { 1.0, 1.0, 0.6 },
	["ORANGE_FONT"] = { 1.0, 0.5, 0.25 },
	["PASSIVE_SPELL_FONT"] = { 0.77, 0.64, 0.0 },
	["BATTLENET_FONT"] = { 0.510, 0.773, 1.0 },
	["TRANSMOGRIFY_FONT"] = { 1, 0.5, 1 },
}

E.DARK_THEME = {
	["FRAME_BG"] = { 0.05, 0.05, 0.05, 0.75 },
	["FRAME_BORDER"] = { 0, 0, 0, 1 },
	["TREE_CONTENT_BG"] = { 0.05, 0.05, 0.05, 0.75 },
	["TREE_CONTENT_BORDER"] = { 0, 0, 0 },
	["TREE_NAV_BG"] = { 0.05, 0.05, 0.05, 0.75 },
	["TREE_NAV_BORDER"] = { 0, 0, 0 },
	["TREE_NAV_BUTTON_BG"] = { 0.412, 0.0, 0.043 },
	["TREE_NAV_BUTTON_BORDER"] = { 0, 0, 0 },
	["TREE_NAV_BUTTON_DELIMITER"] = { 0.569, 0.275, 1.0 },
	["TREE_DRAGGER_HIGHLIGHT"] = { 1, 1, 1, 0.8 },
	["TREE_DRAGGER"] = { 1, 1, 1, 0 },
	["TREE_SCROLL_THUMB"] = { 0.3, 0.3, 0.3 },
	["TREE_SCROLL_THUMB_HIGHLIGHT"] = { 0.5, 0.5, 0.5 },
	["TREE_SCROLL_BG"] = { 0, 0, 0, 0.4 },
	["TREE_ICON_BORDER"] = { 0.5, 0.5, 0.5 },
	["TAB_CONTENT_BG"] = { 0.1, 0.1, 0.1, 0.5 },
	["TAB_CONTENT_BORDER"] = { 0, 0, 0 },
	["TAB_BUTTON_BG"] = { 0.412, 0.0, 0.043 },
	["TAB_BUTTON"] = { 0.1, 0.1, 0.1, 0.5 },
	["TAB_BUTTON_BORDER"] = { 0, 0, 0 },
	["SCROLL_THUMB"] = { 0.3, 0.3, 0.3 },
	["SCROLL_THUMB_HIGHLIGHT"] = { 0.5, 0.5, 0.5 },
	["SCROLL_BG"] = { 0, 0, 0, 0.4 },
	["INLINE_GRP_BORDER"] = { 0, 0, 0 },
	["INLINE_GRP_BG"] = { 0, 0, 0, 0.25 },
	["DROPDOWN_BG"] = { 0.15, 0.15, 0.2 },
	["DROPDOWN_BORDER"] = { 0, 0, 0 },
	["DROPDOWN_CONTENT_BG"] = { 0.12, 0.12, 0.17 },
	["DROPDOWN_CONTENT_BORDER"] = { 0, 0, 0 },
	["DROPDOWN_SLIDER_BG"] = { 0, 0, 0, 0.4 },
	["DROPDOWN_SLIDER_BORDER"] = { 0, 0, 0 },
	["DROPDOWN_SLIDER_THUMB"] = { 0.3, 0.3, 0.3 },
	["DROPDOWN_ITEM_LINEBREAK"] = { 0.5, 0.5, 0.5 },
	["SLIDER_THUMB_DISABLED"] = { 0.5, 0.5, 0.5 },
	["SLIDER_THUMB_HIGHLIGHT"] = { 1, 1, 1 },
	["SLIDER_THUMB"] = { 0.8, 0.624, 0.0 },
	["SLIDER_HANDLE_LEFT_DISABLED"] = { 0.5, 0.5, 0.5 },
	["SLIDER_HANDLE_LEFT"] = { 0.8, 0.624, 0.0 },
	["SLIDER_HANDLE_RIGHT"] = { 0.2, 0.2, 0.25 },
	["SLIDER_HANDLE_RIGHT_HIGHLIGHT"] = { 0.5, 0.5, 0.5 },
	["SLIDER_EDITBOX_BORDER_HIGHLIGHT"] = { 0.5, 0.5, 0.5 },
	["SLIDER_EDITBOX_BORDER"] = { 0.2, 0.2, 0.25 },
	["SLIDER_EDITBOX_BG"] = { 0, 0, 0, 0.5 },
	["CHECKBOX_BORDER_HIGHLIGHT"] = { 0.5, 0.5, 0.5 },
	["CHECKBOX_BORDER"] = { 0.2, 0.2, 0.25 },
	["CHECKBOX_BG"] = { 0, 0, 0 },
	["CHECKBOX_BG_DISABLED"] = { 0.5, 0.5, 0.5 },
	["CHECKBOX_ICON_BORDER"] = { 0.2, 0.2, 0.05 },
	["ICON_BORDER_HIGHLIGHT"] = { 0.5, 0.5, 0.5 },
	["ICON_BORDER"] = { 0.2, 0.2, 0.25 },
	["ICON_BG"] = { 0, 0, 0, 0 },
	["BUTTON_DISABLED_BG"] = { 0.2, 0.2, 0.2 },
	["BUTTON_ENABLED_BG"] = { 0.725, 0.008, 0.008 },
	["BUTTON_BORDER"] = { 0, 0, 0 },
	["BUTTON_BG"] = { 0.0, 0.6, 0.4 },
	["COLORSWATCH_BORDER"] = { 0, 0, 0 },
	["COLORSWATCH"] = { 1, 1, 1 },
	["COLORSWATCH_DISABLED"] = { 0.5, 0.5, 0.5 },

	["DISABLED_TEXT"] = { 0.5, 0.5, 0.5 },
	["NORMAL_FONT"] = { 1.0, 0.82, 0.0 },
	["HIGHLIGHT_FONT"] = { 1.0, 1.0, 1.0 },
}

E.LIGHT_THEME = {

}

E.BOOKTYPE_CATEGORY = {
	["WARRIOR"] = true,
	["PALADIN"] = true,
	["HUNTER"] = true,
	["ROGUE"] = true,
	["PRIEST"] = true,
	["DEATHKNIGHT"] = true,
	["SHAMAN"] = true,
	["MAGE"] = true,
	["WARLOCK"] = true,
	["MONK"] = true,
	["DRUID"] = true,
	["DEMONHUNTER"] = true,
	["EVOKER"] = true,
}

E.RAID_TARGET_MARKERS = {
	[0x00000001] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
	[0x00000002] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
	[0x00000004] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
	[0x00000008] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:0|t",
	[0x00000010] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:0|t",
	[0x00000020] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:0|t",
	[0x00000040] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:0|t",
	[0x00000080] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t",
}

E.L_GLOW_ATLAS ={
	["bags-glow-white"] = ICON_TAG_RAID_TARGET_SKULL3,
	["bags-glow-green"] = ICON_TAG_RAID_TARGET_TRIANGLE3,
	["bags-glow-blue"] = ICON_TAG_RAID_TARGET_SQUARE3,
	["bags-glow-purple"] = ICON_TAG_RAID_TARGET_DIAMOND3,
	["bags-glow-orange"] = ICON_TAG_RAID_TARGET_CIRCLE3,
	["bags-glow-artifact"] = ICON_TAG_RAID_TARGET_STAR3,
}

E.L_ALIGN = {
	["CENTER"] = L["CENTER"],
	["TOPLEFT"] = L["LEFT"],
	["TOPRIGHT"] = L["RIGHT"],
}

E.TANK_SPEC = {
	[250] = true,
	[581] = true,
	[104] = true,
	[268] = true,
	[66] = true,
	[73] = true,
}

E.HEALER_SPEC = {
	[105] = true,
	[270] = true,
	[65] = true,
	[256] = true,
	[257] = true,
	[264] = true,
	[1468] = true,
}
