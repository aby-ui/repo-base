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
enCN
esES
esMX
frFR
itIT
koKR +
ptBR
ptPT
ruRU +
zhCN +
zhTW +
]]

local L = localization

local GetClassInfo,GetSpecializationInfoByID,EJ_GetEncounterInfo,EJ_GetInstanceInfo = GetClassInfo,GetSpecializationInfoByID,EJ_GetEncounterInfo,EJ_GetInstanceInfo

if ExRT.isClassic then
	GetClassInfo = ExRT.Classic.GetClassInfo
	GetSpecializationInfoByID = ExRT.Classic.GetSpecializationInfoByID
	EJ_GetEncounterInfo = ExRT.NULLfunc
	EJ_GetInstanceInfo = ExRT.NULLfunc

	--Global rewrite
	if not EXPANSION_NAME7 then EXPANSION_NAME7 = "BFA" end
	if not EXPANSION_NAME8 then EXPANSION_NAME8 = "Shadowlands" end
	if not TOOLTIP_AZERITE_UNLOCK_LEVELS then TOOLTIP_AZERITE_UNLOCK_LEVELS = "" end
end

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

--- Raid Target Icon [ES]
L.raidtargeticon1_es = "{dorado}"
L.raidtargeticon2_es = "{naranja}"
L.raidtargeticon3_es = "{morado}"
L.raidtargeticon4_es = "{verde}"
L.raidtargeticon5_es = "{plateado}"
L.raidtargeticon6_es = "{azul}"
L.raidtargeticon7_es = "{rojo}"
L.raidtargeticon8_es = "{blanco}"

--- Raid Target Icon [PT]
L.raidtargeticon1_pt = "{dourado}"
L.raidtargeticon2_pt = "{laranja}"
L.raidtargeticon3_pt = "{roxo}"
L.raidtargeticon4_pt = "{verde}"
L.raidtargeticon5_pt = "{prateado}"
L.raidtargeticon6_pt = "{azul}"
L.raidtargeticon7_pt = "{vermelho}"
L.raidtargeticon8_pt = "{branco}"

--- Random strings
L.YesText = YES
L.NoText = NO


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
	S_ZoneT23Siege = 1176,
	S_ZoneT23Storms = 1177,
	S_ZoneT24Eternal = 1179,
	S_ZoneT25Nyalotha = 1180,
	S_ZoneT26CastleNathria = 1190,
	S_ZoneT27SoD = 1193,
}
for prefix,eID in pairs(zoneEJids) do
	L[prefix] = EJ_GetInstanceInfo(eID)
end

local encounterIDtoEJidData = {
	[2423] = 2435,	--The Tarragrue
	[2433] = 2442,	--The Eye of the Jailer
	[2429] = 2439,	--The Nine
	[2432] = 2444,	--Remnant of Ner'zhul
	[2434] = 2445,	--Soulrender Dormazain
	[2430] = 2443,	--Painsmith Raznal
	[2436] = 2446,	--Guardian of the First Ones
	[2431] = 2447,	--Fatescribe Roh-Kalo
	[2422] = 2440,	--Kel'Thuzad
	[2435] = 2441,	--Sylvannas Windrunner

	[2398] = 2393,	--"Shriekwing (1)",
	[2418] = 2429,	--"Huntsman Altimor (2)",
	[2402] = 2422,	--"Kael'thas (3)",
	[2383] = 2428,	--"Hungering Destroyer (4)",
	[2405] = 2418,	--"Broker Curator (5)",
	[2406] = 2420,	--"Lady Inerva Darkvein (6)",
	[2412] = 2426,	--"The Council of Blood (7)",
	[2399] = 2394,	--"Sludgefist (8)",
	[2417] = 2425,	--"Stone Legion Generals (9)",
	[2407] = 2424,	--"Sire Denathrius (10)",

	[2329] = 2368,	--Wrathion
	[2327] = 2365,	--Maut
	[2334] = 2369,	--Prophet Skitra
	[2328] = 2377,	--Dark Inquisitor Xanesh
	[2336] = 2370,	--Vexiona
	[2333] = 2372,	--The Hivemind
	[2331] = 2364,	--Ra-den the Despoiled
	[2335] = 2367,	--Shad'har the Insatiable
	[2343] = 2373,	--Drest'agath
	[2345] = 2374,	--Il'gynoth, Corruption Reborn
	[2337] = 2366,	--Carapace of N'Zoth
	[2344] = 2375,	--N'Zoth the Corruptor

	[2298] = 2352,	--Abyssal Commander Sivara
	[2305] = 2353,	--Radiance of Azshara
	[2289] = 2347,	--Blackwater Behemoth
	[2304] = 2354,	--Lady Ashvane
	[2303] = 2351,	--Orgozoa
	[2311] = 2359,	--The Queen's Court
	[2293] = 2349,	--Za'qul
	[2299] = 2361,	--Queen Azshara

	[2269] = 2328,	--The Restless Cabal
	[2273] = 2332,	--Uu'nat, Harbinger of the Void

	[2265] = 2333,	--Frida Ironbellows, Paladin;  For alliance Ra'wani Kanae, 2344
	[2263] = 2325,	--Grong [horde]
	[2284] = 2340,	--Grong [alliance]
	[2266] = 2341,	--Flamefist and the Illuminated [horde]
	[2285] = 2323,	--Grimfang and Firecaller [alliance]
	[2271] = 2342,	--Treasure Guardian
	[2268] = 2330,	--Loa Council
	[2272] = 2335,	--King Rastakhan
	[2276] = 2334,	--Mekkatorque
	[2280] = 2337,	--Sea Priest
	[2281] = 2343,	--Jaina

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

	[1064]=89,[1065]=90,[1063]=91,[1062]=92,[1060]=93,[1081]=95,[1069]=96,[1070]=97,[1071]=98,[1073]=99,[1072]=100,[1045]=101,
	[1044]=102,[1046]=103,[1047]=104,[1040]=105,[1038]=106,[1039]=107,[1037]=108,[1036]=109,[1056]=110,[1059]=111,[1058]=112,[1057]=113,
	[1043]=114,[1041]=115,[1042]=116,[1052]=117,[1054]=118,[1053]=119,[1055]=122,[1080]=124,[1076]=125,[1075]=126,[1077]=127,[1074]=128,
	[1079]=129,[1078]=130,[1051]=131,[1050]=132,[1048]=133,[1049]=134,[1033]=139,[1250]=140,[1035]=154,[1034]=155,[1030]=156,[1032]=157,
	[1028]=158,[1029]=167,[1082]=168,[1027]=169,[1024]=170,[1022]=171,[1023]=172,[1025]=173,[1026]=174,[1178]=175,[1179]=176,[788]=177,
	[788]=178,[788]=179,[788]=180,[1180]=181,[1181]=184,[1182]=185,[1189]=186,[1190]=187,[1191]=188,[1192]=189,[1193]=190,[1194]=191,[1197]=192,
	[1204]=193,[1206]=194,[1205]=195,[1200]=196,[1185]=197,[1203]=198,[1884]=283,[1883]=285,[1271]=289,[1272]=290,[1273]=291,[1274]=292,[1292]=311,[1296]=317,
	[1291]=318,[1337]=322,[1882]=323,[1294]=324,[1295]=325,[1297]=331,[1298]=332,[1299]=333,[1439]=335,[1332]=339,[1881]=340,[1339]=341,[1340]=342,[1667]=368,
	[227]=369,[228]=370,[229]=371,[230]=372,[231]=373,[232]=374,[233]=375,[234]=376,[235]=377,[236]=378,[237]=379,[238]=380,[239]=381,[241]=383,[242]=384,[243]=385,
	[244]=386,[245]=387,[267]=388,[268]=389,[269]=390,[270]=391,[271]=392,[272]=393,[274]=394,[273]=395,[275]=396,[343]=402,[344]=403,[345]=404,[346]=405,[350]=406,
	[347]=407,[348]=408,[349]=409,[361]=410,[362]=411,[363]=412,[364]=413,[365]=414,[366]=415,[367]=416,[368]=417,[381]=418,[379]=419,[378]=420,[380]=421,[382]=422,
	[422]=423,[423]=424,[427]=425,[1669]=426,[424]=427,[425]=428,[426]=429,[428]=430,[429]=431,[1663]=433,[1668]=436,[1671]=437,[473]=443,[1672]=444,[474]=445,[475]=446,
	[1676]=447,[477]=448,[478]=449,[472]=450,[479]=451,[480]=452,[481]=453,[482]=454,[483]=455,[484]=456,[492]=457,[488]=458,[493]=463,[1144]=464,[1145]=465,[1146]=466,
	[547]=467,[548]=468,[549]=469,[551]=470,[552]=471,[553]=472,[554]=473,[585]=474,[586]=475,[588]=476,[587]=477,[589]=478,[590]=479,[591]=480,[592]=481,[594]=483,[595]=484,
	[596]=485,[597]=486,[598]=487,[600]=489,[1890]=523,[1889]=524,[1893]=527,[1891]=528,[1892]=529,[1897]=530,[1898]=531,[1895]=532,[1894]=533,[1900]=534,[1901]=535,[250]=536,
	[1899]=537,[1905]=538,[1907]=539,[1906]=540,[1903]=541,[1904]=542,[1902]=543,[1908]=544,[1909]=545,[1911]=546,[1910]=547,[1916]=548,[1913]=549,[1915]=550,[1914]=551,
	[1920]=552,[1921]=553,[1919]=554,[1922]=555,[1924]=556,[1923]=557,[1925]=558,[1926]=559,[1928]=560,[1927]=561,[1929]=562,[1932]=563,[1930]=564,[1931]=565,[1936]=566,
	[1937]=568,[1938]=569,[1939]=570,[1941]=571,[1940]=572,[1942]=573,[1943]=574,[1944]=575,[1946]=576,[1945]=577,[1947]=578,[1948]=579,[1969]=580,[1966]=581,[1967]=582,
	[1989]=583,[1968]=584,[1971]=585,[1972]=586,[1973]=587,[1974]=588,[1976]=589,[1977]=590,[1975]=591,[1978]=592,[1983]=593,[1980]=594,[1988]=595,[1981]=596,[1987]=597,
	[1985]=598,[1984]=599,[1986]=600,[1992]=601,[1993]=602,[1990]=603,[1994]=604,[1996]=605,[1995]=606,[1998]=607,[1999]=608,[2001]=609,[2000]=610,[2002]=611,[2004]=612,
	[2003]=613,[2005]=614,[2006]=615,[2007]=616,[519]=617,[521]=618,[522]=619,[524]=620,[527]=621,[528]=622,[530]=623,[533]=624,[534]=625,[2020]=632,[2022]=634,[2022]=635,
	[2022]=636,[2021]=637,[2026]=638,[2024]=639,[2025]=640,[2030]=641,[2027]=642,[2029]=643,[2028]=644,[1419]=649,[1421]=654,[1397]=655,[1420]=656,[1304]=657,[1416]=658,
	[1426]=659,[1422]=660,[1427]=663,[1417]=664,[1428]=665,[1429]=666,[1412]=668,[1413]=669,[1414]=670,[1424]=671,[1418]=672,[1303]=673,[1425]=674,[1405]=675,[1406]=676,
	[1407]=677,[1395]=679,[1434]=682,[1409]=683,[1430]=684,[1305]=685,[1306]=686,[1436]=687,[1423]=688,[1390]=689,[2129]=690,[1447]=692,[1465]=693,[1443]=694,[1444]=695,
	[1445]=696,[1446]=697,[1441]=698,[1442]=708,[1431]=709,[1463]=713,[1500]=726,[1464]=727,[1935]=728,[1506]=729,[1499]=737,[1502]=738,[1498]=741,[1505]=742,[1501]=743,
	[1504]=744,[1507]=745,[1887]=748,[476]=749,[1570]=816,[1559]=817,[1572]=818,[1575]=819,[1574]=820,[1578]=821,[1576]=824,[1565]=825,[1577]=827,[1573]=828,[1560]=829,
	[1580]=831,[1579]=832,[519]=833,[2022]=834,[1595]=846,[1598]=849,[1603]=850,[1599]=851,[1602]=852,[1593]=853,[1606]=856,[1600]=864,[1601]=865,[1624]=866,[1604]=867,
	[1622]=868,[1623]=869,[1594]=870,[1622]=881,[1652]=887,[1653]=888,[1654]=889,[1655]=893,[438]=895,[1656]=896,[1659]=899,[1660]=900,[1661]=901,[1698]=965,[1699]=966,
	[1700]=967,[1701]=968,[1736]=1133,[1715]=1138,[1677]=1139,[1679]=1140,[1666]=1141,[1662]=1142,[1664]=1143,[1670]=1144,[1675]=1145,[1665]=1146,[1682]=1160,[1732]=1163,
	[1688]=1168,[1686]=1185,[1685]=1186,[1757]=1207,[1751]=1208,[1752]=1209,[1756]=1210,[1746]=1214,[1678]=1216,[1714]=1225,[1761]=1226,[1758]=1227,[1759]=1228,[1760]=1229,
	[1762]=1234,[1749]=1235,[1748]=1236,[1750]=1237,[1754]=1238,[1815]=1467,[1816]=1468,[1817]=1469,[1818]=1470,[1813]=1479,[1810]=1480,[1805]=1485,[1806]=1486,[1807]=1487,
	[1808]=1488,[1809]=1489,[1811]=1490,[1812]=1491,[1814]=1492,[1827]=1497,[1825]=1498,[1828]=1499,[1826]=1500,[1829]=1501,[1822]=1502,[1823]=1512,[1832]=1518,[663]=1519,
	[664]=1520,[665]=1521,[666]=1522,[667]=1523,[668]=1524,[669]=1525,[670]=1526,[671]=1527,[672]=1528,[610]=1529,[611]=1530,[612]=1531,[613]=1532,[614]=1533,[615]=1534,
	[616]=1535,[617]=1536,[718]=1537,[719]=1538,[720]=1539,[721]=1540,[722]=1541,[723]=1542,[709]=1543,[711]=1544,[712]=1545,[714]=1546,[710]=1547,[713]=1548,[715]=1549,
	[716]=1550,[717]=1551,[652]=1553,[653]=1554,[654]=1555,[655]=1556,[656]=1557,[658]=1559,[657]=1560,[659]=1561,[660]=1562,[661]=1563,[649]=1564,[650]=1565,[651]=1566,
	[623]=1567,[624]=1568,[625]=1569,[626]=1570,[627]=1571,[628]=1572,[730]=1573,[731]=1574,[732]=1575,[733]=1576,[618]=1577,[619]=1578,[620]=1579,[621]=1580,[622]=1581,
	[601]=1582,[602]=1583,[603]=1584,[604]=1585,[605]=1586,[606]=1587,[607]=1588,[608]=1589,[609]=1590,[724]=1591,[725]=1592,[726]=1593,[727]=1594,[728]=1595,[729]=1596,
	[1126]=1597,[1127]=1598,[1128]=1599,[1129]=1600,[1107]=1601,[1110]=1602,[1116]=1603,[1117]=1604,[1112]=1605,[1115]=1606,[1113]=1607,[1109]=1608,[1121]=1609,[1118]=1610,
	[1111]=1611,[1108]=1612,[1120]=1613,[1119]=1614,[1114]=1615,[1090]=1616,[1094]=1617,[1088]=1618,[1087]=1619,[1086]=1620,[1086]=1621,[1089]=1622,[1085]=1623,[1101]=1624,
	[1100]=1625,[1099]=1626,[1099]=1627,[1096]=1628,[1097]=1629,[1104]=1630,[1102]=1631,[1095]=1632,[1103]=1633,[1098]=1634,[1105]=1635,[1106]=1636,[1132]=1637,[1136]=1638,
	[1139]=1639,[1142]=1640,[1140]=1641,[1137]=1642,[1131]=1643,[1135]=1644,[1141]=1645,[1133]=1646,[1138]=1647,[1134]=1648,[1143]=1649,[1130]=1650,[1084]=1651,[1150]=1652,
	[1833]=1653,[1836]=1654,[1837]=1655,[1838]=1656,[1839]=1657,[1790]=1662,[1824]=1663,[1834]=1664,[1791]=1665,[1835]=1672,[1792]=1673,[1846]=1686,[1793]=1687,[1847]=1688,
	[1848]=1693,[1845]=1694,[1850]=1695,[1852]=1696,[1851]=1697,[1855]=1702,[1856]=1711,[1868]=1718,[1869]=1719,[1870]=1720,[660]=1764,[1965]=1817,[1959]=1818,[1957]=1820,
	[1954]=1825,[1957]=1826,[1957]=1827,[1960]=1835,[1964]=1836,[1961]=1837,[2017]=1838,[2053]=1878,[2039]=1904,[2055]=1905,[2057]=1906,[2065]=1979,[2066]=1980,[2067]=1981,
	[2068]=1982,[2087]=2030,[2085]=2036,[2084]=2082,[2086]=2083,[2094]=2093,[2095]=2094,[2096]=2095,[2104]=2096,[2101]=2097,[2102]=2098,[2103]=2099,[2093]=2102,[2105]=2109,
	[2106]=2114,[2107]=2115,[2108]=2116,[2113]=2125,[2114]=2126,[2115]=2127,[2116]=2128,[2117]=2129,[2112]=2130,[2118]=2131,[2098]=2132,[2097]=2133,[2099]=2134,[2100]=2140,
	[2124]=2142,[2125]=2143,[2126]=2144,[2127]=2145,[2130]=2153,[2131]=2154,[2132]=2155,[2133]=2156,[2111]=2157,[2123]=2158,[2139]=2165,[2140]=2170,[2142]=2171,[2143]=2172,
	[2109]=2173,[2260]=2331,[2257]=2336,[2258]=2339,[2259]=2348,[2291]=2355,[2290]=2357,[2292]=2358,[2312]=2360,[2317]=2362,[2318]=2363,[2351]=2378,[2353]=2381,
	[2380]=2387,[2360]=2388,[2364]=2389,[2366]=2390,[2388]=2391,[2389]=2392,[2387]=2395,[2390]=2396,[2391]=2397,[2400]=2398,[2357]=2399,[2397]=2400,[2365]=2401,[2392]=2402,
	[2384]=2403,[2386]=2404,[2393]=2405,[2401]=2406,[2363]=2407,[2395]=2408,[2394]=2409,[2396]=2410,[2403]=2411,[2359]=2412,[2381]=2413,[2358]=2414,[2361]=2415,[2356]=2416,
	[2404]=2417,[2382]=2419,[2362]=2421,[2385]=2423,[2411]=2430,[2410]=2431,[2409]=2432,[2408]=2433,
}
if ExRT.GDB then
	ExRT.GDB.encounterIDtoEJ = encounterIDtoEJidData
end

local encounterIDtoEJidChache = {
}

L.bossName = setmetatable({}, {__index=function (t, k)
	if not encounterIDtoEJidChache[k] then
		encounterIDtoEJidChache[k] = EJ_GetEncounterInfo(encounterIDtoEJidData[k] or 0) or ""
	end
	return encounterIDtoEJidChache[k]
end})


local instanceIDtoEJidChache = {
}
L.EJInstanceName = setmetatable({}, {__index=function (t, k)
	if not instanceIDtoEJidChache[k] then
		instanceIDtoEJidChache[k] = EJ_GetInstanceInfo(k) or ""
	end
	return instanceIDtoEJidChache[k]
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