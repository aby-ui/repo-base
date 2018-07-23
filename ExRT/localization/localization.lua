local GlobalAddonName, ExRT = ...

local localization = ExRT.L
ExRT.Ldef = localization

ExRT.L = setmetatable({}, {__index=function (t, k)
	return localization[k] or k
end})

--[[
deDE +
enGB +
enUS +
esES
esMX
frFR
itIT
koKR +
ptBR
ruRU +
zhCN +
zhTW +
]]

local L = localization

--- Class Names
local classLocalizate = {
	["WARRIOR"] = GetClassInfo(1),
	["PALADIN"] = GetClassInfo(2),
	["HUNTER"] = GetClassInfo(3),
	["ROGUE"] = GetClassInfo(4),
	["PRIEST"] = GetClassInfo(5),
	["DEATHKNIGHT"] = GetClassInfo(6),
	["SHAMAN"] = GetClassInfo(7),
	["MAGE"] = GetClassInfo(8),
	["WARLOCK"] = GetClassInfo(9),
	["MONK"] = GetClassInfo(10),
	["DRUID"] = GetClassInfo(11),
	["DEMONHUNTER"] = GetClassInfo(12),
	["PET"] = PETS,
	["NO"] = SPECIAL,
	["ALL"] = ALL_CLASSES,
}
L.classLocalizate = setmetatable({}, {__index=function (t, k)
	return classLocalizate[k] or k
end})

--- Spec Names
local specCodeToID = {
	["MAGEDPS1"] = 62,
	["MAGEDPS2"] = 63,
	["MAGEDPS3"] = 64,
	["PALADINHEAL"] = 65,
	["PALADINTANK"] = 66,
	["PALADINDPS"] = 70,
	["WARRIORDPS1"] = 71,
	["WARRIORDPS2"] = 72,
	["WARRIORTANK"] = 73,
	["DRUIDDPS1"] = 102,
	["DRUIDDPS2"] = 103,
	["DRUIDTANK"] = 104,
	["DRUIDHEAL"] = 105,
	["DEATHKNIGHTTANK"] = 250,
	["DEATHKNIGHTDPS1"] = 251,
	["DEATHKNIGHTDPS2"] = 252,
	["HUNTERDPS1"] = 253,
	["HUNTERDPS2"] = 254,
	["HUNTERDPS3"] = 255,
	["PRIESTHEAL1"] = 256,
	["PRIESTHEAL2"] = 257,
	["PRIESTDPS"] = 258,
	["ROGUEDPS1"] = 259,
	["ROGUEDPS2"] = 260,
	["ROGUEDPS3"] = 261,
	["SHAMANDPS1"] = 262,
	["SHAMANDPS2"] = 263,
	["SHAMANHEAL"] = 264,
	["WARLOCKDPS1"] = 265,
	["WARLOCKDPS2"] = 266,
	["WARLOCKDPS3"] = 267,
	["MONKTANK"] = 268,
	["MONKDPS"] = 269,
	["MONKHEAL"] = 270,
	["DEMONHUNTERDPS"] = 577,
	["DEMONHUNTERTANK"] = 581,
}

local specLocalizate = {
	["NO"] = ALL_SPECS,
}
for specCode,specID in pairs(specCodeToID) do
	local _,specName = GetSpecializationInfoByID(specID)
	specLocalizate[specCode] = specName
end

L.specLocalizate = setmetatable({}, {__index=function (t, k)
	return specLocalizate[k] or k
end})

--- Raid Target Icon [ENG]
L.raidtargeticon1_eng = "{star}"
L.raidtargeticon2_eng = "{circle}"
L.raidtargeticon3_eng = "{diamond}"
L.raidtargeticon4_eng = "{triangle}"
L.raidtargeticon5_eng = "{moon}"
L.raidtargeticon6_eng = "{square}"
L.raidtargeticon7_eng = "{cross}"
L.raidtargeticon8_eng = "{skull}"

for i=1,8 do
	L['raidtargeticon'..i] = "{"..(_G['RAID_TARGET_'..i]:lower()).."}"
end

--- Raid Target Icon [DE]
L.raidtargeticon1_de = "{stern}"
L.raidtargeticon2_de = "{kreis}"
L.raidtargeticon3_de = "{diamant}"
L.raidtargeticon4_de = "{dreieck}"
L.raidtargeticon5_de = "{mond}"
L.raidtargeticon6_de = "{quadrat}"
L.raidtargeticon7_de = "{kreuz}"
L.raidtargeticon8_de = "{totenschädel}"

--- Raid Target Icon [FR]
L.raidtargeticon1_fr = "{étoile}"
L.raidtargeticon2_fr = "{cercle}"
L.raidtargeticon3_fr = "{losange}"
L.raidtargeticon4_fr = "{triangle}"
L.raidtargeticon5_fr = "{lune}"
L.raidtargeticon6_fr = "{carré}"
L.raidtargeticon7_fr = "{croix}"
L.raidtargeticon8_fr = "{crâne}"

--- Raid Target Icon [IT]
L.raidtargeticon1_it = "{stella}"
L.raidtargeticon2_it = "{cerchio}"
L.raidtargeticon3_it = "{rombo}"
L.raidtargeticon4_it = "{triangolo}"
L.raidtargeticon5_it = "{luna}"
L.raidtargeticon6_it = "{quadrato}"
L.raidtargeticon7_it = "{croce}"
L.raidtargeticon8_it = "{teschio}"

--- Raid Target Icon [RU]
L.raidtargeticon1_ru = "{звезда}"
L.raidtargeticon2_ru = "{круг}"
L.raidtargeticon3_ru = "{ромб}"
L.raidtargeticon4_ru = "{треугольник}"
L.raidtargeticon5_ru = "{полумесяц}"
L.raidtargeticon6_ru = "{квадрат}"
L.raidtargeticon7_ru = "{крест}"
L.raidtargeticon8_ru = "{череп}"


--- Random strings
L.YesText = YES
L.NoText = NO


--- Boss names
local bossEJids = {
	sooitemssooboss1 = 852,
	sooitemssooboss2 = 849,
	sooitemssooboss3 = 866,
	sooitemssooboss4 = 867,
	sooitemssooboss5 = 868,
	sooitemssooboss6 = 864,
	sooitemssooboss7 = 856,
	sooitemssooboss8 = 850,
	sooitemssooboss9 = 846,
	sooitemssooboss10 = 870,
	sooitemssooboss11 = 851,
	sooitemssooboss12 = 865,
	sooitemssooboss13 = 853,
	sooitemssooboss14 = 869,
	sooitemstotboss1 = 827,
	sooitemstotboss2 = 819,
	sooitemstotboss3 = 816,
	sooitemstotboss4 = 825,
	sooitemstotboss5 = 821,
	sooitemstotboss6 = 828,
	sooitemstotboss7 = 818,
	sooitemstotboss8 = 820,
	sooitemstotboss9 = 824,
	sooitemstotboss10 = 817,
	sooitemstotboss11 = 829,
	sooitemstotboss12 = 832,
	sooitemstotboss13 = 831,
	RaidLootHighmaulBoss1 = 1128,
	RaidLootHighmaulBoss2 = 971,
	RaidLootHighmaulBoss3 = 1195,
	RaidLootHighmaulBoss4 = 1196,
	RaidLootHighmaulBoss5 = 1148,
	RaidLootHighmaulBoss6 = 1153,
	RaidLootHighmaulBoss7 = 1197,
	RaidLootBFBoss1 = 1161,
	RaidLootBFBoss2 = 1202,
	RaidLootBFBoss3 = 1122,
	RaidLootBFBoss4 = 1123,
	RaidLootBFBoss5 = 1155,
	RaidLootBFBoss6 = 1147,
	RaidLootBFBoss7 = 1154,
	RaidLootBFBoss8 = 1162,
	RaidLootBFBoss9 = 1203,
	RaidLootBFBoss10 = 959,
	RaidLootT18HCBoss1 = 1426,
	RaidLootT18HCBoss2 = 1425,
	RaidLootT18HCBoss3 = 1392,
	RaidLootT18HCBoss4 = 1432,
	RaidLootT18HCBoss5 = 1396,
	RaidLootT18HCBoss6 = 1372,
	RaidLootT18HCBoss7 = 1433,
	RaidLootT18HCBoss8 = 1427,
	RaidLootT18HCBoss9 = 1391,
	RaidLootT18HCBoss10 = 1447,
	RaidLootT18HCBoss11 = 1394,
	RaidLootT18HCBoss12 = 1395,
	RaidLootT18HCBoss13 = 1438,
	S_BossT19N2 = 1667,
	S_BossT19S1 = 1706,
}

for prefix,eID in pairs(bossEJids) do
	L[prefix] = EJ_GetEncounterInfo(eID)
end

local zoneEJids = {
	sooitemst15 = 362,
	sooitemst16 = 369,
	RaidLootT17Highmaul = 477,
	RaidLootT17BF = 457,
	RaidLootT18HC = 669,
	S_ZoneT19Nightmare = 768,
	S_ZoneT19ToV = 861,
	S_ZoneT19Suramar = 786,
	S_ZoneT20ToS = 875,
	S_ZoneT21A = 946,
	S_ZoneT22Uldir = 1031,
}
for prefix,eID in pairs(zoneEJids) do
	L[prefix] = EJ_GetInstanceInfo(eID)
end

local encounterIDtoEJidData = {
	[2144] = 2168,	--Taloc
	[2141] = 2167,	--MOTHER
	[2136] = 2169,	--Zek'voz
	[2128] = 2146,	--Fetid Devourer
	[2134] = 2166,	--Vectis
	[2145] = 2195,	--Zul
	[2135] = 2194,	--Mythrax
	[2122] = 2147,	--G'huun

	[2076] = 1992,	--Garothi Worldbreaker
	[2074] = 1987,	--Hounds of Sargeras
	[2064] = 1985,	--Portal Keeper Hasabel
	[2070] = 1997,	--War Council
	[2075] = 2025,	--Eonar, the Lifebinder
	[2082] = 2009,	--Imonar the Soulhunter
	[2069] = 1983,	--Varimathras
	[2088] = 2004,	--Kin'garoth
	[2073] = 1986,	--The Coven of Shivarra
	[2063] = 1984,	--Aggramar
	[2092] = 2031,	--Argus the Unmaker

	[2032] = 1862,	--Горот
	[2048] = 1867,	--Демоны-инквизиторы
	[2036] = 1856,	--Харджатан
	[2037] = 1861,	--Госпожа Сашж'ин
	[2050] = 1903,	--Сестры Луны
	[2054] = 1896,	--Переносчик Погибели
	[2052] = 1897,	--Бдительная дева
	[2038] = 1873,	--Аватара Падшего
	[2051] = 1898,	--Кил'джеден

	[1849] = 1706,	--Скорпирон
	[1865] = 1725,	--Хрономатическая аномалия
	[1867] = 1731,	--Триллиакс
	[1871] = 1751,	--Заклинательница клинков Алуриэль
	[1862] = 1762,	--Тихондрий
	[1886] = 1761,	--Верховный ботаник Тел'арн
	[1842] = 1713,	--Крос
	[1863] = 1732,	--Звездный авгур Этрей
	[1872] = 1743,	--Великий магистр Элисанда
	[1866] = 1737,	--Гул'дан
	
	[1958] = 1819,	--Один
	[1962] = 1830,	--Гарм
	[2008] = 1829,	--Хелия

	[1853] = 1703,	--Низендра
	[1841] = 1667,	--Урсок
	[1873] = 1738,	--Ил'гинот, Сердце Порчи
	[1854] = 1704,	--Драконы Кошмара
	[1876] = 1744,	--Элерет Дикая Лань
	[1877] = 1750,	--Кенарий
	[1864] = 1726,	--Ксавий
	
	[1778] = 1426,
	[1785] = 1425,
	[1787] = 1392,
	[1798] = 1432,
	[1786] = 1396,
	[1783] = 1372,
	[1788] = 1433,
	[1794] = 1427,
	[1777] = 1391,
	[1800] = 1447,
	[1784] = 1394,
	[1795] = 1395,
	[1799] = 1438,
	
	[1801] = 1452,

	[1696] = 1202,
	[1691] = 1161,
	[1693] = 1155,
	[1694] = 1122,
	[1689] = 1123,
	[1692] = 1147,
	[1690] = 1154,
	[1713] = 1162,
	[1695] = 1203,
	[1704] = 959,

	[1721] = 1128,
	[1706] = 971,
	[1720] = 1196,
	[1722] = 1195,
	[1719] = 1148,
	[1723] = 1153,
	[1705] = 1197,
}

local encounterIDtoEJidChache = {
}

L.bossName = setmetatable({}, {__index=function (t, k)
	if not encounterIDtoEJidChache[k] then
		encounterIDtoEJidChache[k] = EJ_GetEncounterInfo(encounterIDtoEJidData[k] or 0) or ""
	end
	return encounterIDtoEJidChache[k]
end})


--- Powers names
L.BossWatcherEnergyType0 = MANA
L.BossWatcherEnergyType1 = POWER_TYPE_FURY
L.BossWatcherEnergyType2 = POWER_TYPE_FOCUS
L.BossWatcherEnergyType3 = POWER_TYPE_ENERGY
L.BossWatcherEnergyType4 = COMBO_POINTS
L.BossWatcherEnergyType5 = RUNES
L.BossWatcherEnergyType6 = RUNIC_POWER
L.BossWatcherEnergyType7 = SOUL_SHARDS_POWER
L.BossWatcherEnergyType8 = POWER_TYPE_LUNAR_POWER
L.BossWatcherEnergyType9 = HOLY_POWER
L.BossWatcherEnergyType10 = ALTERNATE_RESOURCE_TEXT
L.BossWatcherEnergyType11 = POWER_TYPE_MAELSTROM
L.BossWatcherEnergyType12 = CHI
L.BossWatcherEnergyType13 = POWER_TYPE_INSANITY
L.BossWatcherEnergyType14 = BURNING_EMBERS
L.BossWatcherEnergyType15 = POWER_TYPE_DEMONIC_FURY
L.BossWatcherEnergyType16 = POWER_TYPE_ARCANE_CHARGES
L.BossWatcherEnergyType17 = POWER_TYPE_FURY_DEMONHUNTER
L.BossWatcherEnergyType18 = POWER_TYPE_PAIN

--- Schools names
L.BossWatcherSchoolPhysical = STRING_SCHOOL_PHYSICAL
L.BossWatcherSchoolHoly = STRING_SCHOOL_HOLY
L.BossWatcherSchoolFire = STRING_SCHOOL_FIRE
L.BossWatcherSchoolNature = STRING_SCHOOL_NATURE
L.BossWatcherSchoolFrost = STRING_SCHOOL_FROST
L.BossWatcherSchoolShadow = STRING_SCHOOL_SHADOW
L.BossWatcherSchoolArcane = STRING_SCHOOL_ARCANE
L.BossWatcherSchoolElemental = STRING_SCHOOL_ELEMENTAL
L.BossWatcherSchoolChromatic = STRING_SCHOOL_CHROMATIC
L.BossWatcherSchoolMagic = STRING_SCHOOL_MAGIC
L.BossWatcherSchoolChaos = STRING_SCHOOL_CHAOS
L.BossWatcherSchoolUnknown = STRING_SCHOOL_UNKNOWN

L.InspectViewerTalents = TALENTS

L.BossWatcherOverhealing = TEXT_MODE_A_STRING_RESULT_OVERHEALING:match("^(.-):")
L.BossWatcherOverdamage = TEXT_MODE_A_STRING_RESULT_OVERKILLING:match("^(.-):")