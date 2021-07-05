local E, L, C = select(2, ...):unpack()

local L_PVP_TRINKET = GetSpellInfo(42292) or GetSpellInfo(283167)
local RACIAL_TRAITS = RACIAL_TRAITS and gsub(RACIAL_TRAITS, ":", "") or L["Racial Traits"]
local DISARMROOTSILENCE = format("%s, %s, %s",LOC_TYPE_DISARM, LOC_TYPE_ROOT, LOC_TYPE_SILENCE)

E.BASE_ICON_SIZE = 36

E.CRF_KGT = {
	"CompactRaidGroup1Member1","CompactRaidGroup1Member2","CompactRaidGroup1Member3","CompactRaidGroup1Member4","CompactRaidGroup1Member5",
	"CompactRaidGroup2Member1","CompactRaidGroup2Member2","CompactRaidGroup2Member3","CompactRaidGroup2Member4","CompactRaidGroup2Member5",
	"CompactRaidGroup3Member1","CompactRaidGroup3Member2","CompactRaidGroup3Member3","CompactRaidGroup3Member4","CompactRaidGroup3Member5",
	"CompactRaidGroup4Member1","CompactRaidGroup4Member2","CompactRaidGroup4Member3","CompactRaidGroup4Member4","CompactRaidGroup4Member5",
	"CompactRaidGroup5Member1","CompactRaidGroup5Member2","CompactRaidGroup5Member3","CompactRaidGroup5Member4","CompactRaidGroup5Member5",
	"CompactRaidGroup6Member1","CompactRaidGroup6Member2","CompactRaidGroup6Member3","CompactRaidGroup6Member4","CompactRaidGroup6Member5",
	"CompactRaidGroup7Member1","CompactRaidGroup7Member2","CompactRaidGroup7Member3","CompactRaidGroup7Member4","CompactRaidGroup7Member5",
	"CompactRaidGroup8Member1","CompactRaidGroup8Member2","CompactRaidGroup8Member3","CompactRaidGroup8Member4","CompactRaidGroup8Member5",
}

E.CRF_RAID = {
	"CompactRaidFrame1","CompactRaidFrame2","CompactRaidFrame3","CompactRaidFrame4","CompactRaidFrame5",
	"CompactRaidFrame6","CompactRaidFrame7","CompactRaidFrame8","CompactRaidFrame9","CompactRaidFrame10",
	"CompactRaidFrame11","CompactRaidFrame12","CompactRaidFrame13","CompactRaidFrame14","CompactRaidFrame15",
	"CompactRaidFrame16","CompactRaidFrame17","CompactRaidFrame18","CompactRaidFrame19","CompactRaidFrame20",
	"CompactRaidFrame21","CompactRaidFrame22","CompactRaidFrame23","CompactRaidFrame24","CompactRaidFrame25",
	"CompactRaidFrame26","CompactRaidFrame27","CompactRaidFrame28","CompactRaidFrame29","CompactRaidFrame30",
	"CompactRaidFrame31","CompactRaidFrame32","CompactRaidFrame33","CompactRaidFrame34","CompactRaidFrame35",
	"CompactRaidFrame36","CompactRaidFrame37","CompactRaidFrame38","CompactRaidFrame39","CompactRaidFrame40",
	"CompactRaidFrame41","CompactRaidFrame42","CompactRaidFrame43","CompactRaidFrame44","CompactRaidFrame45",
	"CompactRaidFrame46","CompactRaidFrame47","CompactRaidFrame48","CompactRaidFrame49","CompactRaidFrame50",
}

E.CRF_PARTY = {
	"CompactPartyFrameMember1",
	"CompactPartyFrameMember2",
	"CompactPartyFrameMember3",
	"CompactPartyFrameMember4",
	"CompactPartyFrameMember5",
}

E.RAID_UNIT = {
	"raid1","raid2","raid3","raid4","raid5","raid6","raid7","raid8","raid9","raid10",
	"raid11","raid12","raid13","raid14","raid15","raid16","raid17","raid18","raid19","raid20",
	"raid21","raid22","raid23","raid24","raid25","raid26","raid27","raid28","raid29","raid30",
	"raid31","raid32","raid33","raid34","raid35","raid36","raid37","raid38","raid39","raid40",
}

E.unitToPetId = {
	["party1"]="partypet1",["party2"]="partypet2",["party3"]="partypet3",["party4"]="partypet4",["player"]="pet",
	["raid1"]="raidpet1",["raid2"]="raidpet2",["raid3"]="raidpet3",["raid4"]="raidpet4",["raid5"]="raidpet5",
	["raid6"]="raidpet6",["raid7"]="raidpet7",["raid8"]="raidpet8",["raid9"]="raidpet9",["raid10"]="raidpet10",
	["raid11"]="raidpet11",["raid12"]="raidpet12",["raid13"]="raidpet13",["raid14"]="raidpet14",["raid15"]="raidpet15",
	["raid16"]="raidpet16",["raid17"]="raidpet17",["raid18"]="raidpet18",["raid19"]="raidpet19",["raid20"]="raidpet20",
	["raid21"]="raidpet21",["raid22"]="raidpet22",["raid23"]="raidpet23",["raid24"]="raidpet24",["raid25"]="raidpet25",
	["raid26"]="raidpet26",["raid27"]="raidpet27",["raid28"]="raidpet28",["raid29"]="raidpet29",["raid30"]="raidpet30",
	["raid31"]="raidpet31",["raid32"]="raidpet32",["raid33"]="raidpet33",["raid34"]="raidpet34",["raid35"]="raidpet35",
	["raid36"]="raidpet36",["raid37"]="raidpet37",["raid38"]="raidpet38",["raid39"]="raidpet39",["raid40"]="raidpet40",
}

E.PARTY_UNIT = {
	"party1","party2","party3","party4","player",
}

E.TANK_SPEC = {
	[250] = true,   -- Blood DK
	[581] = true,   -- Vengeance DH
	[104] = true,   -- Guardian Druid
	[268] = true,   -- Brewmaster Monk
	[66]  = true,   -- Prot Paladin
	[73]  = true,   -- Prot Warrior
}

E.HEALER_SPEC = {
	[105] = true,   -- Restoration Druid
	[270] = true,   -- Mistweaver
	[65]  = true,   -- Holy Paladin
	[256] = true,   -- Disipline Priest
	[257] = true,   -- Holy Priest
	[264] = true,   -- Restoration Shaman
}

E.CFG_ZONE = {
	["arena"] = ARENA,
	["pvp"] = BATTLEGROUNDS,
	["party"] = DUNGEONS,
	["raid"] = RAIDS,
}

E.L_PRESETS = {
	["TOPLEFT"] = L["LEFT"],
	["TOPRIGHT"] = L["RIGHT"],
	["manual"] = LFG_LIST_MORE or "More...",
}

E.L_POINTS = {
	["LEFT"] = L["LEFT"],
	["RIGHT"] = L["RIGHT"],
	["TOPRIGHT"] = L["TOPRIGHT"],
	["TOPLEFT"] = L["TOPLEFT"],
	["BOTTOMRIGHT"] = L["BOTTOMRIGHT"],
	["BOTTOMLEFT"] = L["BOTTOMLEFT"],
}

E.L_LAYOUT = {
	["horizontal"] = L["Horizontal"],
	["vertical"] = L["Vertical"],
	["doubleRow"] = L["Use Double Row"],
	["doubleColumn"] = L["Use Double Column"],
	["tripleRow"] = L["Use Triple Row"],
	["tripleColumn"] = L["Use Triple Column"],
}

E.L_ALIGN = {
	["CENTER"] = L["CENTER"],
	["TOPLEFT"] = L["LEFT"],
	["TOPRIGHT"] = L["RIGHT"],
}

E.L_ZONE = {
	["arena"] = ARENA,
	["pvp"] = BATTLEGROUNDS,
	["party"] = DUNGEONS,
	["raid"] = RAIDS,
	["scenario"] = SCENARIOS,
	["none"] = BUG_CATEGORY2,
}

E.L_PRIORITY = {
	["pvptrinket"] = L_PVP_TRINKET,
	["racial"] = RACIAL_TRAITS,
	["trinket"] = INVTYPE_TRINKET,
	["covenant"] = L["Covenant"],
	["interrupt"] = LOC_TYPE_INTERRUPT,
	["dispel"] = DISPELS,
	["cc"] = L["Crowd Control"],
	["disarm"] = DISARMROOTSILENCE,
	["immunity"] = L["Immunity"],
	["externalDefensive"] = L["External Defensive"],
	["defensive"] = L["Defensive"],
	["raidDefensive"] = L["Raid Defensive"],
	["offensive"] = L["Offensive"],
	["counterCC"] = L["Counter CC"],
	["raidMovement"] = L["Raid Movement"],
	["other"] = OTHER,
}

E.L_GLOW_ATLAS ={
	["bags-glow-white"] = ICON_TAG_RAID_TARGET_SKULL3,
	["bags-glow-green"] = ICON_TAG_RAID_TARGET_TRIANGLE3,
	["bags-glow-blue"] = ICON_TAG_RAID_TARGET_SQUARE3,
	["bags-glow-purple"] = ICON_TAG_RAID_TARGET_DIAMOND3,
	["bags-glow-orange"] = ICON_TAG_RAID_TARGET_CIRCLE3,
	["bags-glow-artifact"] = ICON_TAG_RAID_TARGET_STAR3,
}

E.L_HIGHLIGHTS = {
	["immunity"] = L["Immunity"],
	["externalDefensive"] = L["External Defensive"],
	["defensive"] = L["Defensive"],
	["raidDefensive"] = L["Raid Defensive"],
	["offensive"] = L["Offensive"],
	["counterCC"] = L["Counter CC"],
	["raidMovement"] = L["Raid Movement"],
	["other"] = OTHER,
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
}

E.OTHER_SORT_ORDER = {
	"PVPTRINKET",
	"RACIAL",
	"TRINKET",
	"COVENANT",
}

E.L_CATAGORY_OTHER = {
	["PVPTRINKET"] = L_PVP_TRINKET,
	["RACIAL"] = RACIAL_TRAITS,
	["TRINKET"] = INVTYPE_TRINKET,
	["COVENANT"] = COVENANT_PREVIEW_RACIAL_ABILITY and format("%s (%s)", COVENANT_PREVIEW_RACIAL_ABILITY, L["Covenant"]) or "Covenant Signature Ability",
}

E.ICO = {
	--["CLASS"] = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes",
	["CLASS"] = "Interface\\Icons\\classicon_", -- individual icons if we're cropping tree icons
	["PVPTRINKET"] = "Interface\\Icons\\ability_pvp_gladiatormedallion",
	["RACIAL"] = "Interface\\Icons\\Achievement_character_human_female",
	["TRINKET"] = "Interface\\Icons\\inv_60pvp_trinket2d",
	["COVENANT"] = 3257750,
}

if E.isBCC then
	E.OTHER_SORT_ORDER[4] = nil

	E.ICO.PVPTRINKET = "Interface\\Icons\\inv_jewelry_trinketpvp_01" -- inv_jewelry_trinketpvp_02 (horde)
	E.ICO.RACIAL = "Interface\\Icons\\achievement_character_troll_male"
	E.ICO.TRINKET = "Interface\\Icons\\inv_misc_armorkit_10"
end

E.STR = {
	["RELOAD_UI"] = L["Reload UI?"],
	["ENABLE_BLIZZARD_CRF"] = L["Blizzard Raid Frames has been disabled by your AddOn(s). Enable and reload UI?"],
	["UNSUPPORTED_ADDON"] = L["Raid Frames for testing doesn't exist for %s. If it fails to load, configure OmniCD while in a group or temporarily set it to \'Manual Mode\'."],
	["MAX_RANGE"] = MAXIMUM .. ": 999",
	["MAX_RANGE_3600"] = MAXIMUM .. ": 3600",
}

E.TEXTURES = {
	White8x8 = [[Interface\BUTTONS\White8x8]],
}

E.CLASSID = {
	"WARRIOR",
	"PALADIN",
	"HUNTER",
	"ROGUE",
	"PRIEST",
	"DEATHKNIGHT",
	"SHAMAN",
	"MAGE",
	"WARLOCK",
	"MONK",
	"DRUID",
	"DEMONHUNTER"
}

E.POWER_TYPE_SPEC = {
	[250] = 1,      -- DK (Blood)
	[253] = 1,      -- HUnter(BM)
	[254] = 1,      -- Hunter (MM)
	[255] = 1,      -- Hunter (SV)
	[269] = true,   -- Monk (WW)
	[65]  = true,   -- Paladin (Holy)
	[66]  = true,   -- Paladin (Prot)
	[70]  = true,   -- Paladin (Ret)
	[260] = true,   -- Rogue (Outlaw)
	[261] = true,   -- Rogue (Sub)
	[71]  = 1,      -- Warrior (Arms)
	[72]  = 1,      -- Warrior (Firu)
	[73]  = 1,      -- Warrior (Prot)
	[265] = true,   -- Warlock (Aff)
	[266] = true,   -- Warlock (Demo)
	[267] = true,   -- Warlock (Dest)
}

E.POWER_TYPE_IDS = {
	["RUNIC_POWER"] = Enum.PowerType.RunicPower,    -- 6
	["FOCUS"] = Enum.PowerType.Focus,   -- 2
	["CHI"] = Enum.PowerType.Chi,   -- 12
	["HOLY_POWER"] = Enum.PowerType.HolyPower,  -- 9
	["RAGE"] = Enum.PowerType.Rage, -- 1
	["COMBO_POINTS"] = Enum.PowerType.ComboPoints,  -- 4
	["SOUL_SHARDS"] = Enum.PowerType.SoulShards,    -- 7
}

--[[
E.COVENANT_HEX_COLOR = {
	[321076] = "|cff2aa2ff",    -- KYRIAN_BLUE_COLOR
	[321079] = "|cffe40d0d",    -- VENTHYR_RED_COLOR
	[321077] = "|cff80b5fd",    -- NIGHT_FAE_BLUE_COLOR
	[321078] = "|cff17c864",    -- NECROLORD_GREEN_COLOR
}
--> Desc
]]

E.HEX_C = {
	CURSE_ORANGE = "|cfff16436", -- 0.945, 0.392, 0.212
	TWITCH_PURPLE = "|cff9146ff", -- 0.569, 0.275, 1.0
	PERFORMANCE_BLUE = "|cff99cdff", -- 0.596, 0.808, 1.0
	OMNICD_RED = "|cffc10003", -- 0.757, 0.0, 0.012
	OMNICD_MAROON = "|cff69000b", -- 0.412, 0.0, 0.043
	[1] = "|cff99cdff", -- WOW_PROJECT_MAINLINE
	[2] = "|cff0291b0", -- WOW_PROJECT_CLASSIC
	[5] = "|cff7bbb4e", -- WOW_PROJECT_BURNING_CRUSADE_CLASSIC
}

-- tree/tab maroon  0.412, 0.0, 0.043
-- checkbox maroon  0.536, 0.0, 0.056
-- checkbox red     0.725, 0.008, 0.008
-- checkbox green   0.008, 0.725, 0.008
-- checkbox yellow  0.8, 0.624, 0
-- flash btn green  0, 0.6, 0.4
-- flash btn red    0.725, 0.008, 0.008
-- slider knob yellow   1, 0.824, 0
