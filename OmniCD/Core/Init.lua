local AddOnName, NS = ...

local AddOn = LibStub("AceAddon-3.0"):NewAddon(AddOnName)
AddOn.L = LibStub("AceLocale-3.0"):GetLocale(AddOnName)
AddOn.defaults = { global = {}, profile = { modules = { ["Party"] = true } } }

NS[1] = AddOn
NS[2] = AddOn.L
NS[3] = AddOn.defaults.profile
NS[4] = AddOn.defaults.global

function NS:unpack()
	return self[1], self[2], self[3], self[4]
end

NS[1].Libs = {}
NS[1].Libs.ACD = LibStub("AceConfigDialog-3.0-OmniCD")
NS[1].Libs.ACR = LibStub("AceConfigRegistry-3.0")
NS[1].Libs.CBH = LibStub("CallbackHandler-1.0"):New(NS[1])
NS[1].Libs.LSM = LibStub("LibSharedMedia-3.0")

NS[1].Party = CreateFrame("Frame")
NS[1].Comm = CreateFrame("Frame")
NS[1].Cooldowns = CreateFrame("Frame")
NS[1].DummyFrame = CreateFrame("Frame")

NS[1].AddOn = AddOnName
NS[1].Version = GetAddOnMetadata(AddOnName, "Version")
NS[1].Author = GetAddOnMetadata(AddOnName, "Author")
NS[1].Notes = GetAddOnMetadata(AddOnName, "Notes")
NS[1].License = GetAddOnMetadata(AddOnName, "X-License")
NS[1].userGUID = UnitGUID("player")
NS[1].userName = UnitName("player")
NS[1].userRealm = GetRealmName()
NS[1].userNameWithRealm = format("%s-%s", NS[1].userName, NS[1].userRealm)
NS[1].userClass = select(2, UnitClass("player"))
NS[1].userRaceID = select(3, UnitRace("player"))
NS[1].userLevel = UnitLevel("player")
NS[1].userFaction = UnitFactionGroup("player")
NS[1].userClassHexColor = "|c" .. select(4, GetClassColor(NS[1].userClass))
NS[1].WoWPatch, NS[1].WoWBuild, NS[1].WoWPatchReleaseDate, NS[1].TocVersion = GetBuildInfo()
NS[1].LoginMessage = format("%sOmniCD v%s|r - /oc", NS[1].userClassHexColor, NS[1].Version)
--[[
	Value	Constant
		WOW_PROJECT_ID
	1	WOW_PROJECT_MAINLINE
	2	WOW_PROJECT_CLASSIC
	5	WOW_PROJECT_BURNING_CRUSADE_CLASSIC
	11	WOW_PROJECT_WRATH_CLASSIC

	Value	Enum
		LE_EXPANSION_LEVEL_CURRENT
	0	LE_EXPANSION_CLASSIC
	1	LE_EXPANSION_BURNING_CRUSADE
	2	LE_EXPANSION_WRATH_OF_THE_LICH_KING
	3	LE_EXPANSION_CATACLYSM
	4	LE_EXPANSION_MISTS_OF_PANDARIA
	5	LE_EXPANSION_WARLORDS_OF_DRAENOR
	6	LE_EXPANSION_LEGION
	7	LE_EXPANSION_BATTLE_FOR_AZEROTH
	8	LE_EXPANSION_SHADOWLANDS
	9	LE_EXPANSION_DRAGONFLIGHT
	10	LE_EXPANSION_11_0
]]
NS[1].isDF = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
NS[1].isClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
NS[1].isBCC = WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC
NS[1].isWOTLKC = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC
NS[1].preCata = LE_EXPANSION_LEVEL_CURRENT < 3
NS[1].postBFA = LE_EXPANSION_LEVEL_CURRENT > 7
NS[1].MAX_PLAYER_LEVEL = MAX_PLAYER_LEVEL_TABLE and MAX_PLAYER_LEVEL_TABLE[LE_EXPANSION_LEVEL_CURRENT]
	or GetMaxLevelForPlayerExpansion()

OmniCD = NS
