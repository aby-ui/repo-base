local GlobalAddonName, ExRT = ...

local GetUnitInfoByUnitFlag = ExRT.F.GetUnitInfoByUnitFlag
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

local VExRT = nil

local module = ExRT:New("Encounter",ExRT.L.sencounter)
local ELib,L = ExRT.lib,ExRT.L

module.db.firstBlood = nil
module.db.isEncounter = nil
module.db.diff = nil
module.db.nowInTable = nil
module.db.afterCombatFix = nil
module.db.diffNames = {
	[1] = L.sencounter5ppl,
	[2] = L.sencounter5pplHC,
	[3] = L.EncounterLegacy..": "..L.sencounter10ppl,
	[4] = L.EncounterLegacy..": "..L.sencounter25ppl,
	[5] = L.EncounterLegacy..": "..L.sencounter10pplHC,
	[6] = L.EncounterLegacy..": "..L.sencounter25pplHC,
	[7] = L.sencounterLfr,		--		PLAYER_DIFFICULTY3
	[8] = L.sencounterChall,
	[9] = L.EncounterLegacy..": "..L.sencounter40ppl,
	[14] = L.sencounterWODNormal,	-- Normal,	PLAYER_DIFFICULTY1
	[15] = L.sencounterWODHeroic,	-- Heroic,	PLAYER_DIFFICULTY2
	[16] = L.sencounterWODMythic,	-- Mythic,	PLAYER_DIFFICULTY6
	[23] = DUNGEON_DIFFICULTY_5PLAYER..": "..PLAYER_DIFFICULTY6,
	[148] = "20ppl raid",
}
module.db.diffPos = ExRT.isClassic and {1,148,9} or {24,1,2,23,8,9,3,4,5,6,172,7,14,15,16}
module.db.dropDownNow = nil
module.db.onlyMy = nil
module.db.scrollPos = 1
module.db.playerName = nil
module.db.pullTime = 0

module.db.chachedDB = nil

function module.options:Load()
	local table_find = ExRT.F.table_find3
	
	module.db.sortedList = {
		{350,652,653,654,655,656,657,658,659,660,661,662},
		{331,651},
		{330,649,650},
		{332,623,624,625,626,627,628},
		{334,730,731,732,733},
		{329,618,619,620,621,622},
		{335,724,725,726,727,728,729},
		{129,519,520,2009,522,521,2010,2011,524,523,525,526,2012,527},
		{130,2002,2003,2004,2005},
		{132,1969,1966,1967,1989,1968},
		{133,2026,2024,2025},
		{136,2030,2027,2029,2028},
		{138,1987,1985,1984,1986},
		{140,1994,1996,1995,1998},
		{141,1094},
		{142,528,2013,530,529,2014,2015,532,531,533,534,2016,535},
		{162,1107,1110,1116,1117,1112,1115,1113,1109,1121,1118,1111,1108,1120,1119,1114},
		{155,1093,1092,1091,1090},
		{147,1132,1136,1139,1142,1140,1137,1131,1135,1141,1164,1165,1166,1133,1138,1134,1143,1130},
		{153,1978,1983,1980,1988,1981},
		{156,1126,1127,1128,1129},
		{157,1971,1972,1973},
		{160,1974,1976,1977,1975},
		{168,2018,2019,2020},
		{171,2022,2023,2021},
		{172,1088,1087,1086,1089,1085},
		{183,2006,2007},
		{184,1999,2001,2000},
		{185,1992,1993,1990},
		{186,1101,1100,1099,1096,1104,1097,1102,1095,1103,1098,1105,1106},
		{200,1147,1149,1148,1150},
		{213,1443,1444,1445,1446},
		{219,593,594,595,596,597,598,599,600},
		{220,492,488,486,487,490,491,493},
		{221,1667,1668,1669,1675,1676,1670,1671,1672},
		{225,1144,1145,1146},
		{226,379,378,380,381,382},
		{230,547,548,549,551,552,553,554,1887},
		{232,663,664,665,666,667,668,669,670,671,672},
		{233,785,784,786,787,788,789,790,791,792,793},
		{234,343,344,345,346,350,347,348,349,361,362,363,364,365,366,367,368},
		{242,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245},
		{246,1935,1936,1937,1938},
		{247,718,719,720,721,722,723},
		{248,1084},
		{250,267,268,269,270,271,272,274,273,275},
		{256,1889,1890},
		{258,1902,1903,1904},
		{260,1908,1909,1910,1911},
		{261,1922,1923,1924},
		{262,1945,1946,1947,1948},
		{263,1942,1943,1944},
		{265,1939,1940,1941},
		{266,1925,1926,1927,1928,1929},
		{267,1930,1931,1932,1933,1934},
		{269,1913,1914,1915,1916},
		{272,1899,1900,250,1901},
		{273,1919,1920,1921},
		{274,1905,1906,1907},
		{277,1052,1053,1054,1055},
		{279,585,586,587,588,589,590,591,592},
		{280,422,423,427,424,425,426,428,429},
		{282,1033,1250,1332},
		{283,1040,1038,1039,1037,1036},
		{285,1027,1024,1022,1023,1025,1026},
		{287,610,611,612,613,614,615,616,617},
		{291,1064,1065,1063,1062,1060,1081},
		{293,1051,1050,1048,1049},
		{294,1030,1032,1028,1029,1082,1083},
		{297,1080,1076,1075,1077,1074,1079,1078},
		{300,1662,1663,1664,1665,1666},
		{301,1656,438,1659,1660,1661},
		{302,444,446,447,448,449,450},
		{306,451,452,453,454,455,456,457,458,459,460,461,462,463},
		{310,1069,1070,1071,1073,1072},
		{317,473,474,476,475,477,478,472,479,480,481,482,483,484,1885},
		{319,709,710,711,712,713,714,715,716,717},
		{322,1045,1044,1046,1047},
		{324,1056,1059,1058,1057},
		{325,1043,1041,1042},
		{328,1035,1034},
		{333,1189,1190,1191,1192,1193,1194},
		{337,1178,1179,1188,1180,1181,1182},
		{339,601,602,603,604,605,606,607,608,609},
		{347,1891,1892,1893},
		{348,1894,1895,1897,1898},
		{367,1197,1204,1205,1206,1200,1185,1203},
		{398,1272,1273,1274},
		{399,1337,1340,1339},
		{401,1881,1882,1883,1884,1271},
		{409,1292,1294,1295,1296,1297,1298,1291,1299},
		{429,1418,1417,1416,1439},
		{431,1422,1421,1420},
		{435,1423,1424,1425},
		{437,1397,1405,1406,1419},
		{439,1412,1413,1414},
		{443,1303,1304,1305,1306},
		{453,1442,1509,1510,1441},
		{456,1409,1505,1506,1431},
		{457,1465,1502,1447,1464},
		{471,1395,1390,1434,1436,1500,1407},
		{474,1507,1504,1463,1498,1499,1501},
		{476,1426,1427,1428,1429,1430},
		{508,1577,1575,1570,1565,1578,1573,1572,1574,1576,1559,1560,1579,1580,1581},
		{554,1563,1564,1571,1587},
		{556,1602,1598,1624,1604,1622,1600,1606,1603,1595,1594,1599,1601,1593,1623,1605},
		{573,1655,1653,1652,1654},
		{574,1677,1688,1679,1682},
		{593,1686,1685,1678,1714},
		{595,1749,1748,1750,1754},
		{596,1696,1691,1693,1694,1689,1692,1690,1713,1695,1704},
		{601,1698,1699,1700,1701},
		{606,1715,1732,1736},

		{616,1761,1758,1759,1760,1762},
		{620,1746,1757,1751,1752,1756},
		{624,1755,1770,1801},

		{703,1805,1806,1807,1808,1809},
		{708,1822,1823,1824},
		{710,1815,1850,1816,1817,1818},
		{713,1810,1811,1812,1813,1814},
		{731,1790,1791,1792,1793},
		{732,1845,1846,1847,1848,1851,1852,1855,1856},
		{733,1836,1837,1838,1839},
		{749,1825,1826,1827,1828,1829},
		{751,1832,1833,1834,1835},
		{761,1868,1869,1870},

		{790,1879,1880,1888,1917,1950,1951,1952,1953,1949},

		{809,1957,1954,1961,1960,1964,1965,1959,2017,2031},

		{845,2055,2057,2039,2053},			
	
		{934,2084,2085,2086,2087},
		{936,2093,2094,2095,2096},
		{974,2101,2102,2103,2104},
		{1010,2105,2106,2107,2108},
		{1015,2113,2114,2115,2116,2117},
		{1041,2111,2118,2112,2123},
		{1162,2098,2097,2109,2099,2100},
		{1038,2124,2125,2126,2127},
		{1039,2130,2131,2132,2133},
		{1004,2139,2142,2140,2143},

		{1666,2387,2388,2389,2390},
		{1674,2382,2384,2385,2386},
		{1669,2397,2392,2393},	
		{1663,2401,2380,2403,2381},
		{1693,2357,2356,2358,2359},
		{1683,2391,2365,2366,2364,2404},
		{1679,2395,2394,2400,2396},
		{1675,2360,2361,2362,2363},

	        {610,1721,1706,1720,1722,1719,1723,1705},--HM
		--{596,1696,1691,1693,1694,1689,1692,1690,1713,1695,1704},--BF
		{661,1778,1785,1787,1798,1786,1783,1788,1794,1777,1800,1784,1795,1799},--HFC
		{777,1853,1841,1873,1854,1876,1877,1864},--EN
		{806,1958,1962,2008},--tov
		{764,1849,1865,1867,1871,1862,1886,1842,1863,1872,1866},--nighthold
		{850,2032,2048,2036,2037,2050,2054,2052,2038,2051},--tos
		{909,2076,2074,2064,2070,2075,2082,2069,2088,2073,2063,2092},--antorus
		{1148,2144,2141,2136,2128,2134,2145,2135,2122},--uldir
		{1358,2265,2263,2284,2266,2285,2271,2268,2272,2276,2280,2281},	--bfd
		{L.S_ZoneT23Storms,2269,2273},	--storms
		{1490,2290,2292,2097,2312,2291,2257,2258,2259,2260},	--mechagon
		{1512,2298,2305,2289,2304,2303,2311,2293,2299},	--ethernal place
		{1582,2329,2327,2334,2328,2336,2333,2331,2335,2343,2345,2337,2344}, --nyalotha
		{1735,2398,2418,2402,2383,2405,2406,2412,2399,2417,2407},	--castle Nathria
	}

	local LegacyDiffs = {
		[3]=true,
		[4]=true,
		[5]=true,
		[6]=true,
	}
	
	local function GetEncounterSortIndex(id,unk)
		for i=1,#module.db.sortedList do
			local dung = module.db.sortedList[i]
			for j=2,#dung do
				if id == dung[j] then
					return i * 100 + j
				end
			end
		end
		return unk
	end
	local function GetEncounterMapID(id)
		for i=1,#module.db.sortedList do
			local dung = module.db.sortedList[i]
			for j=2,#dung do
				if id == dung[j] then
					return dung[1]
				end
			end
		end
		return -999
	end

	self:CreateTilte()
	
	local function ConvertNumberToTime(num)
		local str = ""
		local s = num % 60
		num = floor(num / 60)
		local m = num % 60
		num = floor(num / 60)
		str = format("%d:%02d",m,s)
		if num == 0 then return str end
		local h = num % 24
		num = floor(num / 24)
		str = format("%d:%02d:%02d",h,m,s)
		if num == 0 then return str end
		return num .. "." .. str
	end

	self.dropDown = ELib:DropDown(self,220,#module.db.diffPos):Size(235):Point(445+2,-31)
	function self.dropDown:SetValue(newValue,resetDB)
		if module.db.dropDownNow ~= newValue then
			module.db.scrollPos = 1
			module.options.ScrollBar:SetValue(1)
		end
		if resetDB then
			module.db.chachedDB = nil
		end
		module.db.dropDownNow = newValue
		local newDiff = module.db.diffPos[newValue]
		module.options.dropDown:SetText(module.db.diffNames[newDiff] or GetDifficultyInfo(newDiff))
		ELib:DropDownClose()
		local myName = UnitName("player")
		
		local encounters = module.db.chachedDB or {}
		local currDate = time()
		
		local minPullTime = LegacyDiffs[ newDiff ] and 0 or 30
		
		if not module.db.chachedDB then
			for playerName,playerData in pairs(VExRT.Encounter.list) do
				if not module.db.onlyMy or playerName == module.db.playerName then
					
					for i=1,#playerData do
						local data = playerData[i]
						local isNewFormat = data:find("^%^")
						local diffID
						if isNewFormat then
							diffID = tonumber( select (3, strsplit("^",data) ), nil )
						else
							diffID = tonumber( string.sub(data,4,4),16 ) + 1
						end
						if diffID == newDiff then
							local encounterID, pull, pullTime, isKill, groupSize, firstBloodName, raidIlvl, _
						
							if isNewFormat then
								_, encounterID, _, pull, pullTime, isKill, groupSize, raidIlvl, firstBloodName = strsplit("^", data)
								encounterID = tonumber(encounterID)
								pull = tonumber(pull)
								pullTime = tonumber(pullTime)
								isKill = isKill == "1"
								groupSize = tonumber(groupSize)
							else
								encounterID = tonumber( string.sub(data,1,3),16 )
								pull = tonumber( string.sub(data,5,14),nil )
								pullTime = tonumber( string.sub(data,15,17),16 )
								isKill = string.sub(data,18,18) == "1"
								groupSize = tonumber(string.sub(data,19,20),nil)
								firstBloodName = string.sub(data,21)							
							end
							raidIlvl = tonumber(raidIlvl or "0")
							if firstBloodName == "" then 
								firstBloodName = nil
							end
							
							local encounterLine = table_find(encounters,encounterID,"id")
							if not encounterLine then
								encounterLine = {
									id = encounterID,
									firstBlood = {},
									pullTable = {},
									name = VExRT.Encounter.names[encounterID] or "Unknown",
									pulls = 0,
									kills = 0,
									mapID = GetEncounterMapID(encounterID),
								}
								encounters[#encounters + 1] = encounterLine
							end
							
							encounterLine.first = min( encounterLine.first or currDate, pull )
							if isKill then
								encounterLine.killTime = min( encounterLine.killTime or 4095, pullTime )
								encounterLine.kills = encounterLine.kills + 1
								if not encounterLine.firstKill then
									encounterLine.firstKill = encounterLine.pulls + 1
								end
								encounterLine.pulls = encounterLine.pulls + 1
							else
								encounterLine.wipeTime = max( encounterLine.wipeTime or 0, pullTime )
								if not pullTime or pullTime >= minPullTime then--or pullTime == 0 then
									encounterLine.pulls = encounterLine.pulls + 1
								end
							end
							
							if firstBloodName then
								local firstBloodLine = table_find(encounterLine.firstBlood,firstBloodName,"n")
								if not firstBloodLine then
									encounterLine.firstBlood[#encounterLine.firstBlood + 1] = { 
										n = firstBloodName,
										c = 1,
									}
								else
									firstBloodLine.c = firstBloodLine.c + 1
								end
							end
							
							encounterLine.pullTable[ #encounterLine.pullTable + 1 ] = {
								t = pull,
								d = pullTime,
								k = isKill,
								s = groupSize,
								fb = firstBloodName,
								i = raidIlvl,
							}
						end
					end			
				end
			end
		
			--sort(encounters,function(a,b) return a.first > b.first end)
			sort(encounters,function(a,b) return GetEncounterSortIndex(a.id,a.first) > GetEncounterSortIndex(b.id,b.first) end)
			
			for _,encounterData in pairs(encounters) do
				sort(encounterData.firstBlood,function(a,b) return a.c > b.c end)
				sort(encounterData.pullTable,function(a,b) return a.t < b.t end)
				
				
				local totalTime,isFK = 0
				local legitPulls = 0

				for i=1,#encounterData.pullTable do
					if not encounterData.pullTable[i].d or encounterData.pullTable[i].d >= minPullTime then--or encounterData.pullTable[i].d == 0 then
						legitPulls = legitPulls + 1
					end
					if not isFK and encounterData.pullTable[i].k then
						encounterData.firstKill = legitPulls
						isFK = true
					end
					totalTime = totalTime + (encounterData.pullTable[i].d or 0)
				end
				
				if not encounterData.killTime or encounterData.killTime == 4095 then
					encounterData.killTime = 0
				end
				encounterData.wipeTime = encounterData.wipeTime or 0
				encounterData.wipeTime = totalTime
			end
			
			local prev = nil
			for i=#encounters,1,-1 do
				local eLine = encounters[i]
				if not prev then
					prev = eLine.mapID
				end
				if prev ~= eLine.mapID or i==1 then
					local name = type(prev)=='string' and {name=prev} or C_Map.GetMapInfo(prev or -999)
					if name then
						tinsert(encounters,i==1 and 1 or i+1,{
							isHeader = true,
							name = name.name,
						})
					end
					prev = eLine.mapID
				end
			end
			
		end
		
		module.db.chachedDB = encounters
			
		local j = 0
		for i=module.db.scrollPos,#encounters do
			j = j + 1
			local encounterLine = encounters[i]
			local optionsLine = module.options.line[j]

			if not optionsLine then
				j = j - 1
				break
			end
		
			if encounterLine.isHeader then
				optionsLine.headertext:SetText(encounterLine.name)
				optionsLine.boss:SetText("")
				optionsLine.wipeBK:SetText("")
				optionsLine.wipe:SetText("")
				optionsLine.kill:SetText("")
				optionsLine.firstBlood:SetText("")
				optionsLine.longest:SetText("")
				optionsLine.fastest:SetText("")
				optionsLine.bossImg:SetTexture("")
				
				optionsLine.headerHL:Show()
				optionsLine.pullClick:Hide()
				optionsLine.firstBloodB:Hide()
			else
				optionsLine.headertext:SetText("")
				optionsLine.boss:SetText(encounterLine.name)
				optionsLine.wipeBK:SetText(encounterLine.firstKill or "-")
				optionsLine.wipe:SetText(encounterLine.pulls)
				optionsLine.kill:SetText(encounterLine.kills)
				optionsLine.firstBlood:SetText(encounterLine.firstBlood[1] and encounterLine.firstBlood[1].n or "")
				optionsLine.longest:SetText(ConvertNumberToTime(encounterLine.wipeTime))
				optionsLine.fastest:SetText(date("%M:%S",encounterLine.killTime))
				if encounterLine.wipeTime == 0 then optionsLine.longest:SetText("-") end
				if encounterLine.killTime == 0 then optionsLine.fastest:SetText("-") end

				if ExRT.GDB.encounterIDtoEJ[encounterLine.id] and not ExRT.isClassic then
					local displayInfo = select(4, EJ_GetCreatureInfo(1, ExRT.GDB.encounterIDtoEJ[encounterLine.id]))
					if displayInfo then
						SetPortraitTextureFromCreatureDisplayID(optionsLine.bossImg, displayInfo)
					else
						optionsLine.bossImg:SetTexture("")
					end
				else
					optionsLine.bossImg:SetTexture("")
				end
				
				optionsLine.firstBloodB.n = encounterLine.firstBlood
				optionsLine.pullClick.n = encounterLine.pullTable
				optionsLine.pullClick.bossName = encounterLine.name or ""
				
				optionsLine.headerHL:Hide()
				optionsLine.pullClick:Show()
				optionsLine.firstBloodB:Show()

				optionsLine.data = encounterLine
			end
			optionsLine:Show()
		end
		for i=(j+1),#module.options.line do
			module.options.line[i]:Hide()
		end
		module.options.ScrollBar:SetMinMaxValues(1,max(#encounters-(#module.options.line-1),1))
		module.options.ScrollBar:UpdateButtons()
		module.options.FBframe:Hide()
		module.options.PullsFrame:Hide()
	end

	for i=1,#module.db.diffPos do
		local diffID = module.db.diffPos[i]
		self.dropDown.List[i] = {text = module.db.diffNames[diffID] or GetDifficultyInfo(diffID), justifyH = "CENTER", arg1 = i, arg2 = true, func = self.dropDown.SetValue}
	end
	
	self.borderList = CreateFrame("Frame",nil,self)
	self.borderList:SetSize(698,562)
	self.borderList:SetPoint("TOP", 0, -55)

	self.borderList.decorationLine = ELib:DecorationLine(self.borderList,true):Point("TOP",self.borderList,0,-2):Point("LEFT",self,0,0):Point("RIGHT",self,0,0):Size(0,18)

	local function LineOnEnter(self)
		if self.pullClick.n then 
			self.hl:Show() 
		end 
		
		if self.data and ExRT.GDB.encounterIDtoEJ[self.data.id] and not ExRT.isClassic then
			local displayInfo, bossImage = select(4, EJ_GetCreatureInfo(1, ExRT.GDB.encounterIDtoEJ[self.data.id]))
			if displayInfo then
				SetPortraitTextureFromCreatureDisplayID(module.options.bigImage, displayInfo)
				module.options.bigImage:Show()
			end
		end
	end
	local function LineOnLeave(self)
		self.hl:Hide() 
		module.options.bigImage:Hide()
	end
	local function LineFirstBloodClick(self)
		if not self.n or #self.n == 0 then 
			return 
		end
		local x, y = GetCursorPosition()
		local Es = self:GetEffectiveScale()
		x, y = x/Es, y/Es
		module.options.FBframe:ClearAllPoints()
		module.options.FBframe:SetPoint("BOTTOMLEFT",UIParent,x,y)
		for i=1,#module.options.FBframe.txtL do
			if self.n[i] then
				module.options.FBframe.txtL[i]:SetText(self.n[i].n)
				module.options.FBframe.txtR[i]:SetText(self.n[i].c)
				module.options.FBframe.txtR[i]:Show()
				module.options.FBframe.txtL[i]:Show()				
			else
				module.options.FBframe.txtR[i]:Hide()
				module.options.FBframe.txtL[i]:Hide()
			end
		end
		module.options.FBframe:Show() 
		module.options.PullsFrame:Hide()
	end
	local function LineFirstBloodOnEnter(self)
		local parent = self:GetParent()
		parent.firstBlood:SetTextColor(1,1,0.5,1)
		parent:GetScript("OnEnter")(parent)
	end
	local function LineFirstBloodOnLeave(self)
		local parent = self:GetParent()
		parent.firstBlood:SetTextColor(1,1,1,1)
		parent:GetScript("OnLeave")(parent)
	end
	local function LinePullsClick(self)
		local x, y = GetCursorPosition()
		local Es = self:GetEffectiveScale()
		x, y = x/Es, y/Es
		module.options.PullsFrame:ClearAllPoints()
		module.options.PullsFrame:SetPoint("BOTTOMLEFT",UIParent,x,y)
		module.options.PullsFrame.data = self.n
		module.options.PullsFrame.boss = self.bossName
		module.options.PullsFrame.ScrollBar:SetValue(1)
		module.options.PullsFrame:SetBoss()
		
		module.options.graphsFrame.data = self.n
	end
	local function LinePullsOnEnter(self)
		local parent = self:GetParent()
		parent.wipe:SetTextColor(1,0.5,0.5,1)
		parent:GetScript("OnEnter")(parent)
	end
	local function LinePullsOnLeave(self)
		local parent = self:GetParent()
		parent.wipe:SetTextColor(1,1,1,1)
		parent:GetScript("OnLeave")(parent)
	end
	
	self.line = {}
	for i=0,31 do
		local line = CreateFrame("Frame",nil,self.borderList)     
		self.line[i] = line
		line:SetSize(673,18)        
		line:SetPoint("TOPLEFT",0,-3-18*i) 

		line.boss = ELib:Text(line,"",11):Size(0,18):Point("LEFT",15,0):Color()
		line.wipeBK = ELib:Text(line,"",11):Size(40,18):Point("LEFT",280,0):Color()
		line.wipe = ELib:Text(line,"",11):Size(40,18):Point("LEFT",325,0):Color()
		line.kill = ELib:Text(line,"",11):Size(40,18):Point("LEFT",370,0):Color()
		line.firstBlood = ELib:Text(line,"",11):Size(100,18):Point("LEFT",415,0):Color()
		line.longest = ELib:Text(line,"",11):Size(75,18):Point("LEFT",520,0):Color()
		line.fastest = ELib:Text(line,"",11):Size(75,18):Point("LEFT",595,0):Color()
		line.headertext = ELib:Text(line,"",11):Point("LEFT",0,0):Point("RIGHT",0,0):Center():Color()
		
		if i>0 then
			ExRT.lib.CreateHoverHighlight(line)
			line.hl:SetVertexColor(0.3,0.3,0.7,0.7)
			line:SetScript("OnEnter",LineOnEnter)
			line:SetScript("OnLeave",LineOnLeave)	
			
			ExRT.lib.CreateHoverHighlight(line,"headerHL",1)
			line.headerHL:SetVertexColor(0.6,0.6,0.6,0.7)
		
			line.firstBloodB = CreateFrame("Button",nil,line)  
			line.firstBloodB:SetAllPoints(line.firstBlood)
			line.firstBloodB:SetScript("OnClick",LineFirstBloodClick)
			line.firstBloodB:SetScript("OnEnter",LineFirstBloodOnEnter)
			line.firstBloodB:SetScript("OnLeave",LineFirstBloodOnLeave)

			line.pullClick = CreateFrame("Button",nil,line)  
			line.pullClick:SetAllPoints(line.wipe)
			line.pullClick:SetScript("OnClick",LinePullsClick)
			line.pullClick:SetScript("OnEnter",LinePullsOnEnter)
			line.pullClick:SetScript("OnLeave",LinePullsOnLeave)	

			line.bossImg = line:CreateTexture(nil, "ARTWORK")
			line.bossImg:SetSize(18,18)
			line.bossImg:SetPoint("LEFT",line.boss,"RIGHT",4,0)
		end
	end
	self.line[0].wipe:SetSize(50,18)
	self.line[0].wipe:SetPoint("LEFT", 287+30+5,0)

	self.line[0].boss:SetText(L.sencounterBossName)
	self.line[0].wipeBK:SetText(L.sencounterFirstKill)
	self.line[0].wipe:SetText(L.sencounterWipes)
	self.line[0].kill:SetText(L.sencounterKills)
	self.line[0].firstBlood:SetText(L.sencounterFirstBlood)
	self.line[0].longest:SetText(L.EncounterAllTime)
	self.line[0].fastest:SetText(L.sencounterKillTime)
	
	do
		local wipeBK = CreateFrame("Frame",nil,self.borderList)
		wipeBK:SetAllPoints(self.line[0].wipeBK)
		wipeBK:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterFirstKillTooltip)
		end)
		wipeBK:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)
		
		local pulls = CreateFrame("Frame",nil,self.borderList)
		pulls:SetAllPoints(self.line[0].wipe)
		pulls:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterPullsTooltip)
		end)
		pulls:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)
		
		local longest = CreateFrame("Frame",nil,self.borderList)
		longest:SetAllPoints(self.line[0].longest)
		longest:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterAllTimeTooltip)
		end)
		longest:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)
		
		local fastest = CreateFrame("Frame",nil,self.borderList)
		fastest:SetAllPoints(self.line[0].fastest)
		fastest:SetScript("OnEnter",function(self)
			ELib.Tooltip.Show(self,nil,L.EncounterFastKillTooltip)
		end)
		fastest:SetScript("OnLeave",function()
			GameTooltip_Hide()
		end)		
	end

	self.bigImage = self:CreateTexture(nil, "ARTWORK")
	self.bigImage:SetSize(100,100)
	self.bigImage:SetPoint("BOTTOM",self,"TOP",0,-25)
	
	self.FBframe = ELib:Popup():Size(150,97)
	
	self.FBframe.txtR = {}
	self.FBframe.txtL = {}
	for i=1,5 do
		self.FBframe.txtL[i] = ELib:Text(self.FBframe,"nam1",11):Size(100,14):Point(10,-6-14*i):Color()
		self.FBframe.txtR[i] = ELib:Text(self.FBframe,"123",11):Size(40,14):Point("TOPRIGHT",-10,-6-14*i):Color()
	end	
	
	self.PullsFrame = ELib:Popup():Size(330,247)
	
	self.PullsFrame.txtL = {}
	for i=1,16 do
		self.PullsFrame.txtL[i] = ELib:Text(self.PullsFrame,"",11):Size(305,14):Point(5,-6-14*i):Color()
	end	
	
	self.PullsFrame.ScrollBar = ELib:ScrollBar(self.PullsFrame):Size(16,224):Point("TOPRIGHT",-3,-20):Range(1,1):OnChange(function(self,event)
		event = event - event%1
		module.options.PullsFrame:SetBoss(event)
		self:UpdateButtons()
	end)
	
	function self.PullsFrame:SetBoss(scrollVal)
		local data = module.options.PullsFrame.data
		if data and #data > 0 then
			local j = 0
			for i=(scrollVal or 1),#data do
				j = j + 1
				if j <= 16 then
					module.options.PullsFrame.txtL[j]:SetText((IsShiftKeyDown() and i..". " or "")..date("%d.%m.%Y %H:%M:%S",data[i].t)..(data[i].d > 0 and " ["..date("%M:%S",data[i].d).."]" or "")..(data[i].k and " (kill) " or "")..((data[i].s > 0 and module.db.diffPos[module.db.dropDownNow or 0] ~= 16) and " GS:"..data[i].s or "")..(data[i].i > 0 and " ilvl:"..data[i].i or ""))
				else
					break
				end
			end
			for i=(j+1),16 do
				module.options.PullsFrame.txtL[i]:SetText("")
			end
			if not scrollVal then
				module.options.PullsFrame.ScrollBar:SetMinMaxValues(1,max(#data-15,1))
			end
			
			module.options.PullsFrame.title:SetText(module.options.PullsFrame.boss)
			module.options.PullsFrame:Show()
			module.options.PullsFrame.ScrollBar:UpdateButtons()
			module.options.FBframe:Hide()
		end		
	end
	
	self.PullsFrame:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.ScrollBar:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end)
	
	self.PullsFrame.graphs = ELib:Button(self.PullsFrame,L.BossWatcherTabGraphics):Size(150,20):Point("BOTTOMLEFT",3,-22):OnClick(function()
		if not self.graphsFrame.data then
			print('Error: No Graph data')
			return
		end
		local data = {[1]={}}
		local v_data = {}
		for i=1,#self.graphsFrame.data do
			local line = self.graphsFrame.data[i]
			local t = line.d
			if t > 30 then
				local size = #data[1] + 1
				data[1][size] = {size,t,format("#%d <%s>",i,date("%d.%m.%Y %H:%M:%S",line.t)),format("%s%d:%02d",line.k and "|cff00ff00" or "",t/60,t%60)}
				if line.k then
					v_data[#v_data + 1] = size
				end
			end
		end
		if #data[1] > 0 then
			local prev = data[1][ #data[1] ]
			data[1][#data[1] + 1] = {
				prev[1] + 1,
				prev[2],			
			}
		end
		self.graphsFrame.graph.data = data
		self.graphsFrame.graph.vertical_data = v_data
		self.graphsFrame.graph:Reload()
		
		self.graphsFrame:ShowClick("TOPRIGHT")
		
		self.PullsFrame:Hide()
	end)
	
	self.graphsFrame = ELib:Popup(L.BossWatcherTabGraphics):Size(600,400)
	self.graphsFrame.graph = ExRT.lib.CreateGraph(self.graphsFrame,565,375,"TOPLEFT",30,-20,true)
	self.graphsFrame.graph:SetScript("OnLeave",function ()	GameTooltip_Hide() end)
	self.graphsFrame.graph.AddedOordLines = 1
	self.graphsFrame.graph.IsYIsTime = true
	
	self.onlyThisChar = ELib:Check(self,L.sencounterOnlyThisChar):Point(15,-30):OnClick(function(self,event) 
		module.db.chachedDB = nil
		if self:GetChecked() then
			module.db.onlyMy = true
		else
			module.db.onlyMy = nil
		end
		module.options.ScrollBar:SetValue(1)
		module.options.dropDown:SetValue(module.db.dropDownNow)
	end)	
	
	self.ScrollBar = ELib:ScrollBar(self.borderList):Size(16,self.borderList:GetHeight()-27+18):Point("TOPRIGHT",-4,-22):Range(1,1):OnChange(function(self,event)
		event = ExRT.F.Round(event)
		module.db.scrollPos = event
		module.options.dropDown:SetValue(module.db.dropDownNow)
		self:UpdateButtons()
	end)
	self.ScrollBar:SetScript("OnShow",function() 
		module.options.dropDown:SetValue(module.db.dropDownNow)
		module.options.ScrollBar:UpdateButtons() 
	end)
	
	self.clearButton = ELib:Button(self,L.MarksClear):Size(100,20):Point(340,-30):Tooltip(L.EncounterClear):OnClick(function() 
		StaticPopupDialogs["EXRT_ENCOUNTER_CLEAR"] = {
			text = L.EncounterClearPopUp,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				table.wipe(VExRT.Encounter.list)
				table.wipe(VExRT.Encounter.names)
				module.db.chachedDB = nil
				if module.options.ScrollBar:GetValue() == 1 then
					local func = module.options.ScrollBar.slider:GetScript("OnValueChanged")
					func(module.options.ScrollBar.slider,1)
				else
					module.options.ScrollBar:SetValue(1)
				end
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_ENCOUNTER_CLEAR")
	end) 
	
	self.exportButton = ELib:Button(self,L.Export):Size(100,20):Point("RIGHT",self.clearButton,"LEFT",-5,0):OnClick(function() 
		local allData = {}
		for _,encounterData in pairs(module.db.chachedDB) do
			if encounterData.pullTable then
				for i=1,#encounterData.pullTable do
					local pull = encounterData.pullTable[i]
					
					local resultString = date("%d.%m.%Y %H:%M:%S",pull.t).."\t"..encounterData.name.."\t"..(pull.d > 0 and date("%M:%S",pull.d) or "").."\t"..(pull.k and "Kill" or "").."\t"..(pull.fb or "")
					
					allData[#allData + 1] = {
						t = pull.t,
						s = resultString,
					}
				end
			end
		end
		sort(allData,function(a,b) return a.t<b.t end)
		local text = ""
		for i=1,#allData do
			text = text .. allData[i].s .. "\n"
		end
		ExRT.F:Export(text)
	end)

	self.dropDown:SetValue(#module.db.diffPos)
	
	self:SetScript("OnMouseWheel",function (self,delta)
		local min,max = self.ScrollBar:GetMinMaxValues()
		local val = self.ScrollBar:GetValue()
		if (val - delta) < min then
			self.ScrollBar:SetValue(min)
		elseif (val - delta) > max then
			self.ScrollBar:SetValue(max)
		else
			self.ScrollBar:SetValue(val - delta)
		end
	end)
end

local function DiffInArray(diff)
	for i=1,#module.db.diffPos do
		if module.db.diffPos[i] == diff then
			return true
		end
	end
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.Encounter = VExRT.Encounter or {}
	VExRT.Encounter.list = VExRT.Encounter.list or {}
	VExRT.Encounter.names = VExRT.Encounter.names or {}
	
	if VExRT.Addon.Version < 2022 then
		local newTable = {}
		local newTableNames = {}
		for encID,encData in pairs(VExRT.Encounter.list) do
			local encHex = ExRT.F.tohex(encID,3)
			for diffID,diffData in pairs(encData) do
				if tonumber(diffID) then
					local diffHex = ExRT.F.tohex(diffID - 1)
					for _,pullData in pairs(diffData) do
						local pull = pullData.pull
						local long = "000"
						local kill = "0"
						local gs = format("%02d",pullData.gs or 0)
						if pullData.wipe then
							long = ExRT.F.tohex(pullData.wipe - pull,3)
						end
						if pullData.kill then
							long = ExRT.F.tohex(pullData.kill - pull,3)
							kill = "1"
						end
						local name = pullData.player or 0
						newTable[name] = newTable[name] or {}
						table.insert(newTable[name],encHex..diffHex..format("%010d",pull)..long..kill..gs..(pullData.fb or ""))
					end
				end
			end
			newTableNames[tonumber(encHex,16)] = encData.name or "Unknown"
		end
		VExRT.Encounter.list = newTable
		VExRT.Encounter.names = newTableNames
	end
	
	module.db.playerName = UnitName("player") or 0
	VExRT.Encounter.list[module.db.playerName] = VExRT.Encounter.list[module.db.playerName] or {}
	
	module:RegisterEvents('ENCOUNTER_START','ENCOUNTER_END','BOSS_KILL')
end

function module.main:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
	if difficultyID == 17 or difficultyID == 151 then	--LFR fix
		difficultyID = 7
	end
	if not DiffInArray(difficultyID) or module.db.afterCombatFix then
		return
	end
	if not VExRT.Encounter.list[module.db.playerName] then
		VExRT.Encounter.list[module.db.playerName] = {}
	end
	module.db.isEncounter = encounterID
	module.db.diff = difficultyID
	module.db.pullTime = time()
	module.db.nowInTable = #VExRT.Encounter.list[module.db.playerName] + 1
	
	VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] = 
		"^".. encounterID .. "^" .. difficultyID .. "^" .. module.db.pullTime .. "^0^0^" .. (groupSize or 0) .. "^" .. format("%.2f",ExRT.F.RaidItemLevel and ExRT.F:RaidItemLevel() or 0) .. "^"
	
	VExRT.Encounter.names[encounterID] = encounterName
	module.db.firstBlood = nil
	module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
	
	module.db.chachedDB = nil
end

do
	local function ScheduledAfterCombatFix()
		module.db.afterCombatFix = nil
	end
	function module.main:ENCOUNTER_END(encounterID,_,_,_,success,isBossKillEvent)
		if not module.db.isEncounter then
			return
		end
		if encounterID == module.db.isEncounter then
			local currTime = time()
			if isBossKillEvent then
				currTime = currTime - 3
			end
			local pullTime = currTime - module.db.pullTime
			
			local _,encounterID,difficultyID,pull,_,_,groupSize,raidIlvl,fb = strsplit("^", VExRT.Encounter.list[module.db.playerName][module.db.nowInTable])
			
			VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] = 
				"^".. encounterID .. "^" .. difficultyID .. "^" .. pull .. "^".. pullTime .."^"..(success == 1 and "1" or "0").."^" .. groupSize .. "^" .. raidIlvl .. "^".. fb
			
		end
		module.db.isEncounter = nil
		module.db.diff = nil
		module.db.nowInTable = nil
		module.db.afterCombatFix = true
		ExRT.F.ScheduleTimer(ScheduledAfterCombatFix, 5)
		module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		
		module.db.chachedDB = nil
	end
	function module.main:BOSS_KILL(encounterID)		--08.03.2016: ENCOUNTER_END not fired in 5ppl, but boss_kill only for kills
		if select(2,GetInstanceInfo()) == 'raid' then	--Not needed in raids
			return
		end
		ExRT.F.Timer(module.main.ENCOUNTER_END, 3, module.main, encounterID, 0, 0, 0, 1, true)
	end
end

function module.main:COMBAT_LOG_EVENT_UNFILTERED()
	local _,event,_,_,_,_,_,destGUID,destName,destFlags = CombatLogGetCurrentEventInfo()
	if event == "UNIT_DIED" and destName and GetUnitInfoByUnitFlag(destFlags,1) == 1024 then
		if UnitIsFeignDeath(destName) then
			return
		end
		module.db.firstBlood = true
		VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] = VExRT.Encounter.list[module.db.playerName][module.db.nowInTable] .. destName
		module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		
		module.db.chachedDB = nil
	end
end