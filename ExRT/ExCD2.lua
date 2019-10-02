local GlobalAddonName, ExRT = ...

local GetTime, IsEncounterInProgress, RAID_CLASS_COLORS, GetInstanceInfo, GetSpellCharges, CombatLogGetCurrentEventInfo = GetTime, IsEncounterInProgress, RAID_CLASS_COLORS, GetInstanceInfo, GetSpellCharges, CombatLogGetCurrentEventInfo
local string_gsub, wipe, tonumber, pairs, ipairs, string_trim, format, floor, ceil, abs, type, sort = string.gsub, table.wipe, tonumber, pairs, ipairs, string.trim, format, floor, ceil, abs, type, sort
local UnitIsDeadOrGhost, UnitIsConnected, UnitName, UnitCreatureFamily, UnitIsDead, UnitIsGhost, UnitGUID, UnitInRange, UnitIsWarModeActive = UnitIsDeadOrGhost, UnitIsConnected, UnitName, UnitCreatureFamily, UnitIsDead, UnitIsGhost, UnitGUID, UnitInRange, UnitIsWarModeActive

local RaidInCombat, ClassColorNum, GetDifficultyForCooldownReset, DelUnitNameServer, NumberInRange = ExRT.F.RaidInCombat, ExRT.F.classColorNum, ExRT.F.GetDifficultyForCooldownReset, ExRT.F.delUnitNameServer, ExRT.F.NumberInRange
local GetEncounterTime, UnitCombatlogname, GetUnitInfoByUnitFlag, ScheduleTimer, CancelTimer, GetRaidDiffMaxGroup, round, table_wipe2, dtime = ExRT.F.GetEncounterTime, ExRT.F.UnitCombatlogname, ExRT.F.GetUnitInfoByUnitFlag, ExRT.F.ScheduleTimer, ExRT.F.CancelTimer, ExRT.F.GetRaidDiffMaxGroup, ExRT.F.Round, ExRT.F.table_wipe, ExRT.F.dtime
local CheckInteractDistance, CanInspect = CheckInteractDistance, CanInspect

local GetSpellLevelLearned, GetInspectSpecialization, GetNumSpecializationsForClassID, GetTalentInfo = GetSpellLevelLearned, GetInspectSpecialization, GetNumSpecializationsForClassID, GetTalentInfo
local C_SpecializationInfo_GetInspectSelectedPvpTalent
if ExRT.isClassic then
	GetSpellLevelLearned = function () return 1 end
	GetInspectSpecialization = function () return 0 end
	GetNumSpecializationsForClassID = GetInspectSpecialization
	GetTalentInfo = ExRT.NULLfunc
	C_SpecializationInfo_GetInspectSelectedPvpTalent = ExRT.NULLfunc
else
	C_SpecializationInfo_GetInspectSelectedPvpTalent = C_SpecializationInfo.GetInspectSelectedPvpTalent
end

local VExRT, VExRT_CDE = nil

local module = ExRT:New("ExCD2",ExRT.L.cd2)
local ELib,L = ExRT.lib,ExRT.L

module._C = {}
module.db.spellDB = {
{31821,	"PALADIN",	nil,			{31821,	180,	8},	nil,			nil,			},	--Владение аурами
{204150,"PALADIN",	nil,			nil,			{204150,180,	6},	nil,			},	--Эгида Света
{62618,	"PRIEST",	nil,			{62618,	180,	10},	nil,			nil,			},	--Слово силы: Барьер
{98008,	"SHAMAN",	nil,			nil,			nil,			{98008,	180,	6},	},	--Тотем духовной связи
{97462,	"WARRIOR",	{97462,	180,	10},	nil,			nil,			nil,			},	--Ободряющий клич
{31884,	"PALADIN",	nil,			{31884,	120,	20},	{31884,	120,	20},	{31884,	120,	20},	},	--Гнев карателя
{64843,	"PRIEST",	nil,			nil,			{64843,	180,	8},	nil,			},	--Божественный гимн
{108280,"SHAMAN",	nil,			nil,			nil,			{108280,180,	10},	},	--Тотем целительного прилива
{740,	"DRUID",	nil,			nil,			nil,			nil,{740,180,	8},	},	--Спокойствие
{115310,"MONK",		nil,			nil,			nil,			{115310,180,	0},	},	--Восстановление сил
{15286,	"PRIEST",	nil,			nil,			nil,			{15286,	120,	15},	},	--Объятия вампира
{196718,"DEMONHUNTER",	nil,			{196718,180,	8},	nil,						},	--Мрак
{207399,"SHAMAN",	nil,			nil,			nil,			{207399,300,	30},	},	--Тотем защиты Предков
{265202,"PRIEST",	nil,			nil,			{265202,720,	0},	nil,			},	--Holy Word: Salvation
{216331,"PALADIN",	nil,			{216331,120,	20},	nil,			nil,			},	--Avenging Crusader
{271466,"PRIEST",	nil,			{271466,180,	0},	nil,			nil,			},	--Luminous Barrier

{102342,"DRUID",	nil,			nil,			nil,			nil,{102342,60,	12},	},	--Железная кора
{47788,	"PRIEST",	nil,			nil,			{47788,	180,	10},	nil,			},	--Оберегающий дух
{33206,	"PRIEST",	nil,			{33206,	180,	8},	nil,			nil,			},	--Подавление боли
{6940,	"PALADIN",	nil,			{6940,	120,	12},	{6940,	120,	12},	nil,			},	--Жертвенное благословление
{633,	"PALADIN",	{633,	600,	0},	nil,			nil,			nil,			},	--Возложение рук
{116849,"MONK",		nil,			nil,			nil,			{116849,120,	12},	},	--Исцеляющий кокон
{1022,	"PALADIN",	{1022,	300,	10},	nil,			nil,			nil,			},	--Благословение защиты
{204018,"PALADIN",	nil,			nil,			{204018,180,	10},	nil,			},	--Благословение защиты от заклинаний
{1044,	"PALADIN",	{1044,	25,	8},	nil,			nil,			nil,			},	--Благословенная свобода
{73325,	"PRIEST",	{73325,	90,	0},	nil,			nil,			nil,			},	--Духовное рвение

{106898,"DRUID",	nil,			nil,			{77764,	120,	8},	{77761,	120,	8},nil,	},	--Тревожный рев
{192077,"SHAMAN",	{192077,120,	15},	nil,			nil,			nil,			},	--Тотем ветряного порыва

{161642,"NO",		{161642,0,	0},	nil,			nil,			nil,			},	--Resurrecting [Raid Combat Res]
{20484,	"DRUID",	{20484,	600,	0},	nil,			nil,			nil,nil,		},	--Возрождение
{20707,	"WARLOCK",	{20707,	600,	0},	nil,			nil,			nil,			},	--Камень души
{61999,	"DEATHKNIGHT",	{61999,	600,	0},	nil,			nil,			nil,			},	--Воскрешение союзника
{20608,	"SHAMAN",	{21169,	1800,	0},	nil,			nil,			nil,			},	--Реинкарнация

{46968,	"WARRIOR",	nil,			nil,			nil,			{46968,	30,	0},	},	--Ударная волна
{119381,"MONK",		{119381,60,	3},	nil,			nil,			nil,			},	--Круговой удар ногой
{179057,"DEMONHUNTER",	nil,			{179057,60,	2},	nil,						},	--Кольцо Хаоса
{192058,"SHAMAN",	{192058,60,	2},	nil,			nil,			nil,			},	--Тотем выброса тока
{30283,	"WARLOCK",	{30283,	60,	0},	nil,			nil,			nil,			},	--Shadowfury

{202137,"DEMONHUNTER",	nil,			nil,			{202137,60,	2},				},	--Sigil of Silence

{32375,	"PRIEST",	{32375,	45,	0},	nil,			nil,			nil,			},	--Массовое рассеивание
{64901,	"PRIEST",	nil,			nil,			{64901,	300,	6},	nil,			},	--Символ надежды
{29166,	"DRUID",	nil,			{29166,	180,	12},	nil,			nil,{29166,180,	12},	},	--Озарение

{114018,"ROGUE",	{114018,360,	15},	nil,			nil,			nil,			},	--Shroud of Concealment

{108199,"DEATHKNIGHT",	nil,			{108199,120,	0},	nil,			nil,			},	--Хватка Кровожада
{49576,	"DEATHKNIGHT",	nil,			{49576,	15,	0},	{49576,	25,	0},	{49576,	25,	0},	},	--Хватка смерти
{2825,	"SHAMAN",	{2825,	300,	40},	nil,			nil,			nil,			},	--Жажда крови
{80353,	"MAGE",		{80353,	300,	40},	nil,			nil,			nil,			},	--Искажение времени
--{id,	class,		all specs,		spec1,			spec2={spellid,cd,duration},spec3,spec4		},	--name
}

if ExRT.isClassic then
	module.db.spellDB = {
		{29166,	"DRUID",	{29166,	360,	20}},	--Озарение
		{20748,	"DRUID",	{20748,	1800,	0}},	--BR
		{6795,	"DRUID",	{6795,	10,	0}},	--Taunt
		{9863,	"DRUID",	{9863,	300,	10}},	--Tranq

		{355,	"WARRIOR",	{355,	10,	0}},	--Taunt
		{12975,	"WARRIOR",	{12975,	600,	20}},	--Last stand
		{871,	"WARRIOR",	{871,	1800,	10}},	--SW

		{11958,	"MAGE",		{11958,	480,	40}},	--IB

		{1020,	"PALADIN",	{1020,	300,	12}},	--DS
		{10310,	"PALADIN",	{10310,	3600,	0}},	--LoH
		{19752,	"PALADIN",	{19752,	3600,	0}},	--DI

		{17359,	"SHAMAN",	{17359,	300,	12}},	--MTT
	}
end

module.db.Cmirror = module._C
module.db.dbCountDef = #module.db.spellDB
module.db.findspecspells = {
	[30451] = 62, [7268] = 62,
	[194466] = 63, [133] = 63, [11366] = 63,
	[214634] = 64, [116] = 64, [30455] = 64,
	
	[20473] = 65, [82326] = 65,
	[53600] = 66, [31935] = 66,
	[85256] = 70, [53385] = 70, 

	[209577] = 71, [12294] = 71, [167105] = 71,
	[205546] = 72, [23881] = 72, [184367] = 72,
	[203524] = 73, [20243] = 73, [23922] = 73,
	
	[202767] = 102, [190984] = 102, --[78674] = 102, 
	[210722] = 103, [52610] = 103, --[1822] = 103, 
	[200851] = 104, [33917] = 104, --[22842] = 104,
	[208253] = 105, [188550] = 105, --[8936] = 105, 

	[205223] = 250, [206930] = 250, [50842] = 250,
	[190778] = 251, [49143] = 251, [49184] = 251,
	[220143] = 252, [47541] = 252, [63560] = 252, 

	[207068] = 253, [193455] = 253, [34026] = 253,
	[204147] = 254, [19434] = 254, [185901] = 254,
	[203415] = 255, [190928] = 255, [186270] = 255, 

	[207946] = 256, [200829] = 256, [47666] = 256,
			[139] = 257, [33076] = 257,
	[205065] = 258, [8092] = 258, [34914] = 258, 

	[192759] = 259, [1329] = 259, [1943] = 259, 
	[202665] = 260, [2098] = 260, [193315] = 260,
	[209782] = 261, [196819] = 261, [53] = 261,

	[205495] = 262, [188196] = 262, [188389] = 262,
	[204945] = 263, [17364] = 263, [60103] = 263,
	[207778] = 264, [61295] = 264, [1064] = 264,
	
	[216698] = 265, [30108] = 265, [980] = 265, 
	[211714] = 266, [603] = 266, [105174] = 266,
	[196586] = 267, [29722] = 267, [116858] = 267, 
	
	[214326] = 268, [205523] = 268, [121253] = 268, 
	[205320] = 269, [113656] = 269, --[100780] = 269,
	[205406] = 270, [115151] = 270, --[116670] = 270,
	
	[201467] = 577, [162243] = 577, [198013] = 577,
	[207407] = 581, [203782] = 581, [228477] = 581,
}
module.db.classNames = ExRT.GDB.ClassList

module.db.specByClass = {}
for class,classData in pairs(ExRT.GDB.ClassSpecializationList) do
	local newData = {0}
	for i=1,#classData do
		newData[#newData + 1] = classData[i]
	end
	module.db.specByClass[class] = newData
end

module.db.specIcons = ExRT.GDB.ClassSpecializationIcons
module.db.specInDBase = {
	[253] = 4,	[254] = 5,	[255] = 6,
	[71] = 4,	[72] = 5,	[73] = 6,
	[65] = 4,	[66] = 5,	[70] = 6,
	[62] = 4,	[63] = 5,	[64] = 6,
	[256] = 4,	[257] = 5,	[258] = 6,
	[265] = 4,	[266] = 5,	[267] = 6,
	[250] = 4,	[251] = 5,	[252] = 6,
	[259] = 4,	[260] = 5,	[261] = 6,
	[102] = 4,	[103] = 5,	[104] = 6,	[105] = 7,
	[268] = 4,	[269] = 5,	[270] = 6,
	[262] = 4,	[263] = 5,	[264] = 6,
	[577] = 4,	[581] = 5,
	[0] = 3,
}

do
	local specList = {
		[62] = "MAGEDPS1",		--Arcane
		[63] = "MAGEDPS2",		--Fire
		[64] = "MAGEDPS3",		--Frost
		[65] = "PALADINHEAL",
		[66] = "PALADINTANK",
		[70] = "PALADINDPS",
		[71] = "WARRIORDPS1",		--Arms
		[72] = "WARRIORDPS2",		--Fury
		[73] = "WARRIORTANK",
		[102] = "DRUIDDPS1",		--Owl
		[103] = "DRUIDDPS2",		--Cat
		[104] = "DRUIDTANK",
		[105] = "DRUIDHEAL",
		[250] = "DEATHKNIGHTTANK",
		[251] = "DEATHKNIGHTDPS1",	--Frost
		[252] = "DEATHKNIGHTDPS2",	--Unholy
		[253] = "HUNTERDPS1",		--BM
		[254] = "HUNTERDPS2",		--MM
		[255] = "HUNTERDPS3",		--Survival
		[256] = "PRIESTHEAL1",		--Disc
		[257] = "PRIESTHEAL2",		--Holy
		[258] = "PRIESTDPS",
		[259] = "ROGUEDPS1",		--Assassination
		[260] = "ROGUEDPS2",		--Combat
		[261] = "ROGUEDPS3",		--Subtlety
		[262] = "SHAMANDPS1",		--Elemental
		[263] = "SHAMANDPS2",		--Enhancement
		[264] = "SHAMANHEAL",
		[265] = "WARLOCKDPS1",		--Affliction
		[266] = "WARLOCKDPS2",		--Demonology
		[267] = "WARLOCKDPS3",		--Destruction
		[268] = "MONKTANK",
		[269] = "MONKDPS",
		[270] = "MONKHEAL",
		[577] = "DEMONHUNTERDPS",
		[581] = "DEMONHUNTERTANK",
		[0] = "NO",
	}
	module.db.specInLocalizate = setmetatable({},{__index = function (t,k)
		if tonumber(k) then
			return specList[k] 
		else
			for i,val in pairs(specList) do
				if val == k then
					return i
				end
			end
		end
	end})
end

module.db.historyUsage = {}

module.db.testMode = nil
module.db.isEncounter = nil

local cdsNav_wipe,cdsNav_set = nil
do
	local cdsNavData = {}
	local nilData = {}
	module.db.cdsNav = setmetatable({}, {
		__index = function (t,k) 
			return cdsNavData[k] or nilData
		end
	})
	function cdsNav_wipe()
		wipe(cdsNavData)
	end
	function cdsNav_set(playerName,spellID,pos)
		local e = cdsNavData[playerName]
		if not e then
			e = {}
			cdsNavData[playerName] = e
		end
		e[spellID] = pos
	end
	if ExRT.isClassic then
		function cdsNav_set(playerName,spellID,pos)
			local e = cdsNavData[playerName]
			if not e then
				e = {}
				cdsNavData[playerName] = e
			end
			e[pos.spellName] = pos
		end
	end
end

do
	local sessionData = {}
	local nilData = {}
	module.db.session_gGUIDs = setmetatable({}, {
		__index = function (t,k) 
			return sessionData[k] or nilData
		end,
		__newindex = function (t,k,v)
			local e = sessionData[k]
			if not e then
				e = {}
				sessionData[k] = e
			end
			if v > 0 then
				e[v] = true
			else
				e[-v] = nil
			end
		end
	})	
	module.db.session_gGUIDs_DEBUG = sessionData
end

module.db.session_Pets = {}
module.db.session_PetOwner = {}

module.db.spell_isTalent = {
	[107574]=true,	[845]=true,	[262228]=true,	[197690]=true,	[202168]=true,	[152277]=true,	[260643]=true,	[107570]=true,	[262161]=true,	
	[46924]=true,	[118000]=true,	[202168]=true,	[280772]=true,	[107570]=true,	
	[118000]=true,	[202168]=true,	[228920]=true,	[107570]=true,	

	[183415]=true,	[216331]=true,	[200025]=true,	[223306]=true,	[115750]=true,	[105809]=true,	[114165]=true,	[114158]=true,	[20066]=true,	[214202]=true,	
	[204150]=true,	[204035]=true,	[204018]=true,	[115750]=true,	[20066]=true,	[152262]=true,	
	[115750]=true,	[205228]=true,	[231895]=true,	[267798]=true,	[205191]=true,	[24275]=true,	[20066]=true,	[255937]=true,	[210191]=true,	

	[131894]=true,	[120360]=true,	[109248]=true,	[199483]=true,	[53209]=true,	[120679]=true,	[194407]=true,	[201430]=true,	
	[131894]=true,	[120360]=true,	[109248]=true,	[199483]=true,	[260402]=true,	[212431]=true,	[198670]=true,	
	[131894]=true,	[109248]=true,	[199483]=true,	[259391]=true,	[269751]=true,	[162488]=true,	

	[200806]=true,	[137619]=true,	[245388]=true,	
	[271877]=true,	[196937]=true,	[51690]=true,	[137619]=true,	
	[137619]=true,	[280719]=true,	[277925]=true,	
	
	[110744]=true,	[246287]=true,	[120517]=true,	[271466]=true,	[123040]=true,	[129250]=true,	[214621]=true,	[204065]=true,	[204263]=true,	
	[200183]=true,	[204883]=true,	[110744]=true,	[120517]=true,	[265202]=true,	[204263]=true,	
	[280711]=true,	[263346]=true,	[205369]=true,	[200174]=true,	[64044]=true,	[205385]=true,	[193223]=true,	[263165]=true,

	[206931]=true,	[194844]=true,	[274156]=true,	[206940]=true,	[194679]=true,	[219809]=true,	[212552]=true,	
	[108194]=true,	[207167]=true,	[152279]=true,	[48743]=true,	[279302]=true,	[194913]=true,	[57330]=true,	[212552]=true,	
	[108194]=true,	[48743]=true,	[152280]=true,	[130736]=true,	[49206]=true,	[115989]=true,	[207289]=true,	[212552]=true,	
	
	[108281]=true,	[114050]=true,	[117014]=true,	[210714]=true,	[192222]=true,	[16166]=true,	[265046]=true,	[192249]=true,	[191634]=true,	[192077]=true,	
	[114051]=true,	[188089]=true,	[196884]=true,	[265046]=true,	[197214]=true,	[192077]=true,	
	[207399]=true,	[114052]=true,	[207778]=true,	[198838]=true,	[51485]=true,	[265046]=true,	[197995]=true,	[192077]=true,

	[205022]=true,	[153626]=true,	[205032]=true,	[55342]=true,	[113724]=true,	[116011]=true,	[157980]=true,	
	[235870]=true,	[157981]=true,	[44457]=true,	[153561]=true,	[55342]=true,	[113724]=true,	[116011]=true,	
	[153595]=true,	[257537]=true,	[205030]=true,	[157997]=true,	[55342]=true,	[205021]=true,	[113724]=true,	[116011]=true,	

	[108416]=true,	[113860]=true,	[264106]=true,	[268358]=true,	[108503]=true,	[48181]=true,	[6789]=true,	[205179]=true,	[278350]=true,	
	[267211]=true,	[108416]=true,	[268358]=true,	[267171]=true,	[111898]=true,	[6789]=true,	[267217]=true,	[264130]=true,	[264057]=true,	[264119]=true,	
	[152108]=true,	[196447]=true,	[108416]=true,	[113858]=true,	[268358]=true,	[108503]=true,	[6789]=true,	[6353]=true,	

	[115399]=true,	[123986]=true,	[115098]=true,	[122278]=true,	[115295]=true,	[132578]=true,	[116844]=true,	[116847]=true,	[115315]=true,	[116841]=true,	
	[123986]=true,	[115098]=true,	[122278]=true,	[122783]=true,	[198664]=true,	[197908]=true,	[196725]=true,	[116844]=true,	[198898]=true,	[115313]=true,	[116841]=true,	
	[123986]=true,	[115098]=true,	[122278]=true,	[122783]=true,	[115288]=true,	[261947]=true,	[123904]=true,	[116844]=true,	[261715]=true,	[152173]=true,	[116841]=true,	[152175]=true,	

	[205636]=true,	[202770]=true,	[102560]=true,	[102359]=true,	[5211]=true,	[108238]=true,	[252216]=true,	[132469]=true,	[202425]=true,	[102401]=true,	
	[274837]=true,	[102543]=true,	[102359]=true,	[5211]=true,	[108238]=true,	[252216]=true,	[132469]=true,	[102401]=true,	
	[155835]=true,	[102558]=true,	[236748]=true,	[204066]=true,	[102359]=true,	[5211]=true,	[252216]=true,	[132469]=true,	[102401]=true,	
	[102351]=true,	[197721]=true,	[33891]=true,	[102359]=true,	[5211]=true,	[108238]=true,	[252216]=true,	[132469]=true,	[102401]=true,	

	[258860]=true,	[258925]=true,	[211881]=true,	[232893]=true,	[258920]=true,	[206491]=true,	[196555]=true,	
	[212084]=true,	[232893]=true,	[202138]=true,	[263648]=true,	
	--Other & items
	[67826]=true,
	[298452]=true,	[299376]=true,	[299378]=true,	[303823]=true,	[304088]=true,	[304121]=true,	[295186]=true,	[298628]=true,	[299334]=true,	[298168]=true,	[299273]=true,	[299275]=true,	[293032]=true,	[299943]=true,	[299944]=true,	[296197]=true,	[299932]=true,	[299933]=true,	[296230]=true,	[299958]=true,	[299959]=true,	[293031]=true,	[300009]=true,	[300010]=true,	[293019]=true,	[298080]=true,	[298081]=true,	[295258]=true,	[299336]=true,	[299338]=true,	[296094]=true,	[299882]=true,	[299883]=true,	[294926]=true,	[300002]=true,	[300003]=true,	[295337]=true,	[299345]=true,	[299347]=true,	[295840]=true,	[299355]=true,	[299358]=true,	[302731]=true,	[302982]=true,	[302983]=true,	[298357]=true,	[299372]=true,	[299374]=true,	[296072]=true,	[299875]=true,	[299876]=true,	[295746]=true,	[300015]=true,	[300016]=true,	[295373]=true,	[299349]=true,	[299353]=true,	[296325]=true,	[299368]=true,	[299370]=true,	[297108]=true,	[298273]=true,	[298277]=true,	
}

module.db.spell_autoTalent = {		--Для маркировки базовых заклинаний спека, которые являются талантами у других спеков [spellID] = specID
	[107574] = 73,
	[288826] = 104,
}

module.db.spell_talentsList = {}
module.db.spell_isPvpTalent = {}
module.db.spell_isAzeriteTalent = {}

module.db.spell_charge_fix = {		--Спелы с зарядами
	[100]=103827,
	[7384]=262150,
	[85228]=1,
	[198304]=1,
	[2565]=1,
	[35395]=1,
	[190784]=230332,
	[214202]=1,
	[53600]=1,
	[204019]=1,
	[275779]=204023,
	[210191]=1,
	[217200]=1,
	[19434]=1,
	[259489]=269737,
	[259495]=264332,
	[212436]=1,
	[13877]=1,
	[36554]=1,
	[185313]=1,
	[194509]=1,
	[19758]=1,
	[51505]=108283,
	[5394]=108283,
	[61295]=108283,
	[193786]=1,
	[194679]=1,
	[212653]=1,
	[116011]=1,
	[122]=205036,
	[108853]=205029,
	[257541]=1,
	[108839]=1,
	[195072]=1,
	[195072]=1,
	[115308]=1,
	[119582]=1,
	[109132]=1,
	[115008]=1,
	[122281]=1,
	[115151]=1,
	[137639]=1,
	[61336]=1,
	[22842]=1,
	[18562]=200383,
	[12051]=273330,
}

module.db.spell_durationByTalent_fix = {	--Изменение длительности талантом\глифом   вид: [спелл] = {spellid глифа\таланта, изменение времени (-10;10;*0.5;*1.5)}
	[52174] = {202163,3},
	[1719] = {202751,4},
	[5246] = {275338,4},
	[31884] = {286229,5,53376,"*1.25"},
	[13877] = {272026,3},
	[185313] = {108208,1},
	[48707] = {205727,"*1.3",207321,5},
	[12472] = {155149,10},
	[188499] = {209281,-1},
	[207684] = {209281,-1},
	[202137] = {209281,-1},
	[5217] = {202021,4},
}

module.db.spell_cdByTalent_fix = {		--Изменение кд талантом\глифом   вид: [спелл] = {spellid глифа\таланта, изменение времени (-60;60);spellid2,time2;spellid3,time3;...}
	[100] = {103827,-3},
	[52174] = {202163,-15},
	[85228] = {215573,-1},
	[12975] = {280001,-60},
	[6343] = {275336,{"*0.5",107574}},
	[642] = {114154,"*0.7"},
	[498] = {114154,"*0.7"},
	[633] = {114154,"*0.7"},
	[20473] = {53376,{"*0.5",31884}},
	[186257] = {266921,"*0.8"},
	[186265] = {266921,"*0.8"},
	[186289] = {266921,"*0.8"},
	[195457] = {256188,-30},
	[2094] = {256165,-30},
	[8122] = {196704,-30},
	[15286] = {199855,-45},
	[15487] = {263716,-15},
	[51533] = {262624,-30,296320,"*0.80"},
	[79206] = {192088,-60},
	[48707] = {205727,-15},
	[108199] = {206970,-30},
	[235450] = {235463,"*0"},
	[30283] = {264874,-15},
	[179057] = {206477,"*0.67"},
	[195072] = {207550,-8},
	[188499] = {209281,"*0.8"},
	[207684] = {209281,"*0.8"},
	[202137] = {209281,"*0.8"},
	[109132] = {115173,-5},
	[119381] = {264348,-10},
	[22812] = {203965,"*0.67"},
	[61336] = {203965,"*0.67",296320,"*0.80"},
	[18562] = {200383,-3},
	[740] = {197073,-60,296320,"*0.80"},
	[102342] = {197061,-15},
	[48792] = {288424,-15},
	[106898] = {288826,-60},
	[77764] = {288826,-60},
	[77761] = {288826,-60},
	[109304] = {287938,-15},
	[116849] = {277667,-20},

	[34433] = {296320,"*0.80"},
	[123040] = {296320,"*0.80"},
	[64843] = {296320,"*0.80"},
	[31884] = {296320,"*0.80"},
	[108280] = {296320,"*0.80"},
	[198067] = {296320,"*0.80"},
	[192249] = {296320,"*0.80"},
	[115203] = {296320,"*0.80"},
	[115310] = {296320,"*0.80"},
	[137639] = {296320,"*0.80"},
	[152173] = {296320,"*0.80"},
	[194223] = {296320,"*0.80"},
	[106951] = {296320,"*0.80"},
	[190319] = {296320,"*0.80"},
	[12042] = {296320,"*0.80"},
	[12472] = {296320,"*0.80"},
	[191427] = {296320,"*0.80"},
	[187827] = {296320,"*0.80"},
	[55233] = {296320,"*0.80"},
	[47568] = {296320,"*0.80"},
	[275699] = {296320,"*0.80"},
	[288613] = {296320,"*0.80"},
	[193530] = {296320,"*0.80"},
	[266779] = {296320,"*0.80"},
	[205180] = {296320,"*0.80"},
	[265187] = {296320,"*0.80"},
	[1122] = {296320,"*0.80"},
	[79140] = {296320,"*0.80"},
	[13750] = {296320,"*0.80"},
	[121471] = {296320,"*0.80"},
	[227847] = {296320,"*0.80"},
	[1719] = {296320,"*0.80"},
	[107574] = {296320,"*0.80"},

	--Priest, Paladin, Shaman, Monk, Druid, Mage, DH, DK, Hunter, Warlock, Rogue, Warrior
	[293019] = {298080,-15},
	[294926] = {300002,-30},
	[298168] = {299273,-30},
	[295746] = {300015,-42},
	[293031] = {300009,-15},
	[296230] = {299958,-15},
	[297108] = {298273,-30},
	[298452] = {299376,-15},

}

module.db.spell_cdByTalent_scalable_data = {
	[296320] = {
		[1] = "*0.80",
	},
}

module.db.spell_cdByTalent_isScalable = {
	[296320] = true,
}

module.db.tierSetsSpells = {}	--[specID.tierID.tierMark] = {2P Bonus Spell ID, 4P Bonus Spell ID}
module.db.tierSetsList = {}	-- [itemID] = specID.tierID.tierMark

module.db.spell_talentReplaceOther = {		--Спелы, показ которых нужно убрать при наличии таланта (талант заменяет эти спелы) [spellID] = [talent Spell ID]
	[167105]=262161,
	[34428]=202168,
	[227847]=152277,
	[31884]={216331,231895},
	[35395]=204019,
	[1022]=204018,
	[34433]=123040,
	[62618]=271466,
	[8122]=205369,
	[198067]=192249,
	[5394]=157153,
	[43265]=152280,
	[1953]=212653,
	[31687]=205024,
	[137639]=152173,
	[1850]=252216,
	[194223]=102560,
	[106951]=102543,
}

module.db.spell_aura_list = {		--Спелы, время действия которых отменять при отмене бафа 	[buff_sid] = spellID
	[184662] = 184662,
	[47788] = 47788,
	[48707] = 48707,
	[45438] = 45438,
	[188501] = 188501,
	[115176] = 115176,
	[116849] = 116849,
}
module.db.spell_speed_list = {		--Спелы, которым менять время действия на основании спелхасты
	[740]=true,
	[64843]=true,
	[12051]=true,
	[113656]=true,
}
module.db.spell_afterCombatReset = {	--Принудительный сброс кд после боя с боссом (для спелов с кд менее 5 мин., 3мин после 6.1)
	[161642]=true,
	
	[31884]=true,
	[12042]=true,
}
module.db.spell_afterCombatNotReset = {	--Запрещать сброс кд после боя с боссом (для петов, например; для спелов с кд 5 и более мин., для анха)
	[90355]=true,
	[126393]=true,
	[53478]=true,
	[55709]=true,
	[20608]=true,
	[21169]=true,
	[159931]=true,
	[159956]=true,
	
	--[26297]=true,	--Fixed in 7.0?
	[67826]=true,
	
	[199740]=true,
	[160452]=true,

	--[271466]=true,
}
module.db.spell_reduceCdByHaste = {	--Заклинания, кд которых уменьшается хастой
	[12294]=true,
	[260643]=true,
	[845]=true,
	[23881]=true,
	[85228]=true,
	[6572]=true,
	[2565]=true,
	[23922]=true,
	[6343]=true,
	[26573]=true,
	[35395]=true,
	[20473]=true,
	[275773]=true,
	[85222]=true,
	[31935]=true,
	[204019]=true,
	[213652]=true,
	[275779]=true,
	[184092]=true,
	[53500]=true,
	[184575]=true,
	[20271]=true,
	[24275]=true,
	[53209]=true,
	[19434]=true,
	[129250]=true,
	[33076]=true,
	[204883]=true,
	[187874]=true,
	[193796]=true,
	[193786]=true,
	[17364]=true,
	[108853]=true,
	[44457]=true,
	[188499]=true,
	[232893]=true,
	[203720]=true,
	[115308]=true,
	[121253]=true,
	[119582]=true,
	[116847]=true,
	[107428]=true,
	[113656]=true,
	[152175]=true,
	[33917]=true,
}
module.db.spell_resetOtherSpells = {	--Заклинания, которые откатывают другие заклинания
	--[191427]={{198013,193897},{179057,193897},{198589,193897}},
	--[187827]={{202137,210867},{204596,210867},{207684,210867},{202138,210867}},
	
	[204035]={53600},
	[195676]={195676},
	[235219]={11426,122,120,45438},
}
module.db.spell_sharingCD = {		--Заклинания, которые запускают кд на другие заклинания 	[spellID] = {[otherSpellID] = CD}
	[90633] = {[90632]=120,[90631]=120},
	[90632] = {[90633]=120,[90631]=120},
	[90631] = {[90632]=120,[90633]=120},
}

module.db.spell_runningSameSpell = {}	--Схожие заклинания

do
	local sameSpellsData = {
		{121093,59545,59543,59548,59542,59544,59547,28880},		--DraeneiRacial
		{69041,69070},							--Goblin Racial
		{28730,69179,129597,80483,155145,25046,50613,202719,232633},	--Belf Racial
		{106898,77764,77761},						--Stampeding Roar
		{187611,187614,187615},						--Legendary Ring
		{51514,211015,210873,211010,211004},				--Hex
		{202767,202771,202768},						--New moon [Balance Druid artifact]
		{115308,119582},						--Brewmaster brew
		{90633,90628},{90632,90626},{90631,89479},			--Guild Battle Standard
		{86659,212641},							--Guardian of Ancient Kings [std,glyhed]
		{200166,191427},						--DH Metamorphosis

		{295373,299349,299353},	--The Crucible of Flame
		{295186,298628,299334},	--Worldvein Resonance
		{302731,302982,302983},	--Ripple in Space
		{298357,299372,299374},	--Memory of Lucid Dreams
		{293019,298080,298081},	--Azeroth's Undying Gift
		{294926,300002,300003},	--Anima of Life and Death
		{298168,299273,299275},	--Aegis of the Deep
		{295746,300015,300016},	--Nullification Dynamo
		{293031,300009,300010},	--Sphere of Suppression
		{296197,299932,299933},	--The Well of Existence
		{296094,299882,299883},	--Artifice of Time
		{293032,299943,299944},	--Life-Binder's Invocation
		{296072,299875,299876},	--The Ever-Rising Tide
		{296230,299958,299959},	--Vitality Conduit
		{295258,299336,299338},	--Essence of the Focusing Iris
		{295840,299355,299358},	--Condensed Life-Force
		{297108,298273,298277},	--Blood of the Enemy
		{295337,299345,299347},	--Purification Protocol
		{298452,299376,299378},	--The Unbound Force
	}
	for i=1,#sameSpellsData do
		local list = sameSpellsData[i]
		for j=1,#list do
			module.db.spell_runningSameSpell[ list[j] ] = list
		end
	end
end

module.db.spell_reduceCdCast = {	--Заклинания, применение которых уменьшает время восстановления других заклинаний	[spellID] = {reduceSpellID,time;{reduceSpellID2,talentID},time2;{reduceSpellID3,talentID,specID,effectOnlyDuringBuffActive},time3}
	[163201]={{227847,152278},-2},
	[1715]={{227847,152278},-0.5},
	[12294]={{227847,152278},-1.5},
	[1464]={{227847,152278},-1},
	[1680]={{227847,152278},-1.5},
	[845]={{227847,152278},-1},
	[772]={{227847,152278},-1.5},
	[202168]={{227847,152278},-0.5,{1719,152278},-0.5,{107574,152278},-1,{12975,152278},-1,{871,152278},-1,{1160,152278},-1},
	[12323]={{1719,152278},-0.5},
	[184367]={{1719,152278},-4.25},
	[190456]={{107574,152278},-4,{12975,152278},-4,{871,152278},-4,{1160,152278},-4},
	[6572]={{107574,152278},-3,{12975,152278},-3,{871,152278},-3,{1160,152278},-3},
	[2565]={{107574,152278},-3,{12975,152278},-3,{871,152278},-3,{1160,152278},-3},
	[35395]={{20473,196926},-1.5,{85222,196926},-1.5},
	[275773]={{853,198054},-10},
	[53600]={{184092,204074},-3,{31884,204074},-3},
	[217200]={19574,-12},
	[193455]={{109304,270581},-1.167},
	[34026]={{109304,270581},-1},
	[2643]={{109304,270581},-1.333},
	[120679]={{109304,270581},-0.833},
	[53209]={{109304,270581},-1.333},
	[131894]={{109304,270581,253},-1,{109304,270581,254},-1,{109304,270581,255},-1.5},
	[109248]={{109304,270581,253},-1},
	[201430]={{109304,270581},-1},
	[120360]={{109304,270581,253},-2,{109304,270581,254},-1.5},
	[19434]={{109304,270581},-1.5},
	[185358]={{109304,270581},-0.75,{288613,260404},-3},
	[186387]={{109304,270581,254},-0.5},
	[257620]={{109304,270581},-0.75,{288613,260404},-3},
	[212431]={{109304,270581},-1},
	[198670]={{109304,270581},-1.75},	
	[187708]={{109304,270581},-1.75},
	[186270]={{109304,270581},-1.5},
	[259491]={{109304,270581},-1},
	[195645]={{109304,270581},-1.5},
	[212434]={{109304,270581},-1.5},
	[259387]={{109304,270581},-1.5},
	[259391]={{109304,270581},-1.5},
	[196819]={185313,-7.5,{185313,238104},-5,280719,-5},
	[408]={{185313,1,261},-7.5,{185313,238104},-5,280719,-5},
	[195452]={185313,-7.5,{185313,238104},-5,280719,-5},
	[280719]={185313,-7.5,{185313,238104},-5,280719,-5},	
	[585]={88625,-4,{88625,196985},-1.333,{88625,200183,nil,200183},-12},
	[2060]={2050,-6,{2050,196985},-2,{2050,200183,nil,200183},-18},
	[2061]={2050,-6,{2050,196985},-2,{2050,200183,nil,200183},-18},
	[596]={34861,-6,{34861,196985},-1.333,{34861,200183,nil,200183},-18},
	[139]={34861,-2,{34861,196985},-0.667,{34861,200183,nil,200183},-6},
	[32546]={34861,-3,2050,-3,{2050,196985},-1,{34861,196985},-1,{34861,200183,nil,200183},-9,{2050,200183,nil,200183},-9},
	[2050]={265202,-30},
	[34861]={265202,-30},
	[49998]={{55233,205723},-4.5},
	[61999]={{55233,205723},-3},
	[206940]={{55233,205723},-3},
	[47541]={{275699,276837},-1,{42650,276837},-5},
	[121253]={115203,-4,{115203,196736},-2},
	[100784]={{137639,280197},-0.5},
	[113656]={{137639,280197},-1.5},
	[107428]={{137639,280197},-1},
	[101546]={{137639,280197},-0.5},

}
module.db.spell_increaseDurationCast = {	--Заклинания, продляющие время действия
	[23922]={{2565,203177},1},
}
module.db.spell_dispellsFix = {}
module.db.spell_dispellsList = {	--Заклинания-диспелы (мгновенно откатываются, если ничего не диспелят)
	[4987] = true,
	[527] = true,
	[51886] = true,
	[77130] = true,
	[475] = true,
	[115450] = true,
	[2782] = true,
	[88423] = true,
	[213644] = true,
}

module.db.spell_startCDbyAuraFade = {	--Заклинания, кд которых запускается только при спадении ауры
	[205025]=true,
	[5215]=true,
	[202425]=true,
	[116680]=true,
}
module.db.spell_startCDbyAuraApplied = {	--Заклинания, кд которых запускается только при наложении ауры (вида [aura_spellID] = CD_spellID)
	[117679]=33891,
	[59628]=57934,
	[212800]=198589,	--blur fix
}
module.db.spell_startCDbyAuraApplied_fix = {}
for _,spellID in pairs(module.db.spell_startCDbyAuraApplied) do module.db.spell_startCDbyAuraApplied_fix[spellID] = true end

module.db.spell_reduceCdByAuraFade = {	--Заклинания, кд которых уменьшается при спадении ауры до окончания времени действия. !Важно обязательное время действия для таких заклинаний
	[47788]={{47788,200209},-110},
}
module.db.spell_battleRes = {		--Заклинания-воскрешения [WOD]
	[20484]=true,
	[20707]=true,
	[61999]=true,
	--[126393]=true,
	[161642]=true,
	--[159931]=true,
	--[159956]=true,
}
module.db.isResurectDisabled = nil

module.db.spell_isRacial = {		--Расовые заклинания
	[68992]="Worgen",
	[20589]="Gnome",
	[20594]="Dwarf",
	[121093]="Draenei",
	[59545]="Draenei",
	[59543]="Draenei",
	[59548]="Draenei",
	[59542]="Draenei",
	[59544]="Draenei",
	[59547]="Draenei",
	[28880]="Draenei",
	[58984]="NightElf",
	[107079]="Pandaren",
	[59752]="Human",
	[69041]="Goblin",
	[69070]="Goblin",
	[69046]="Goblin",
	[7744]="Undead",
	[20577]="Undead",
	[20572]="Orc",
	[33697]="Orc",
	[33702]="Orc",
	[20549]="Tauren",
	[26297]="Troll",
	[28730]="BloodElf",
	[69179]="BloodElf",
	[129597]="BloodElf",
	[80483]="BloodElf",
	[155145]="BloodElf",
	[25046]="BloodElf",
	[50613]="BloodElf",
	[202719]="BloodElf",
	[256948]="VoidElf",
	[260364]="Nightborne",
	[255647]="LightforgedDraenei",
	[255654]="HighmountainTauren",
	[274738]="MagharOrc",
	[265221]="DarkIronDwarf",
}

module.db.def_col = {			--Стандартные положения в колонках
	["161642;1"]=2,
	["97462;2"]=1,
	["97462;3"]=1,
	["46968;1"]=1,
	["1022;1"]=2,
	["204018;3"]=2,
	["204013;3"]=2,
	["1044;1"]=2,
	["31821;2"]=1,
	["633;1"]=2,
	["31842;2"]=1,
	["6940;2"]=2,
	["6940;3"]=2,
	["204150;3"]=1,
	["64843;3"]=1,
	["73325;2"]=2,
	["73325;3"]=2,
	["32375;1"]=1,
	["47788;3"]=2,
	["15286;4"]=1,
	["33206;2"]=2,
	["64901;3"]=1,
	["62618;2"]=1,
	["61999;1"]=2,
	["108199;2"]=1,
	["49576;2"]=3,
	["49576;3"]=3,
	["49576;4"]=3,
	["2825;1"]=3,
	["114052;4"]=1,
	["20608;1"]=2,
	["192077;1"]=1,
	["98008;4"]=1,
	["207399;4"]=1,
	["108280;4"]=1,
	["80353;1"]=3,
	["20707;1"]=2,
	["115310;4"]=1,
	["116849;4"]=2,
	["119381;1"]=1,
	["20484;1"]=2,
	["102342;5"]=2,
	["29166;2"]=2,
	["29166;5"]=2,
	["740;5"]=1,
	["106898;3"]=1,
	["106898;4"]=1,
	["179057;1"]=1,
	["196718;1"]=1,
	["265202;1"]=1,
	["31884;2"]=1,
	["31884;3"]=3,
	["31884;4"]=3,
}

module.db.petsAbilities = {	--> PetTypes = HUNTERS[ Tenacity [1], Cunning = [2], Ferocity[3] ]
	[0] = 						{},
	[L.creatureNames["Basilisk"]] = 		{1,	{159733,45},	},
	[L.creatureNames["Bat"]] = 		{2,	},
	[L.creatureNames["Bear"]] = 		{1,	{50256,10},	},
	[L.creatureNames["Beetle"]] = 		{1,	{90339,60,12},	},
	[L.creatureNames["Bird of Prey"]] = 	{2,	},
	[L.creatureNames["Boar"]] = 		{1,	},
	[L.creatureNames["Carrion Bird"]] = 	{3,	{24423,6},	},
	[L.creatureNames["Cat"]] = 		{3,	{24450,10},	{93435,45},	},
	[L.creatureNames["Chimaera"]] = 		{2,	{54644,10},	},
	[L.creatureNames["Core Hound"]] = 		{3,	{90355,360,40},	},
	[L.creatureNames["Crab"]] = 		{1,	{159926,60,12},	},
	[L.creatureNames["Crane"]] = 		{2,	{159931,600},	},
	[L.creatureNames["Crocolisk"]] = 		{1,	{50433,10},	},
	[L.creatureNames["Devilsaur"]] = 		{3,	{159953,60},	{54680,8},	},
	[L.creatureNames["Direhorn"]] = 		{1,	{137798,30},	},
	[L.creatureNames["Dog"]] = 		{3,	},
	[L.creatureNames["Dragonhawk"]] = 		{2,	},
	[L.creatureNames["Fox"]] = 		{3,	{160011,120},	},
	[L.creatureNames["Goat"]] = 		{3,	},
	[L.creatureNames["Gorilla"]] = 		{1,	},
	[L.creatureNames["Hyena"]] = 		{3,	{128432,90},	},
	[L.creatureNames["Monkey"]] = 		{2,	{160044,120},	},
	[L.creatureNames["Moth"]] = 		{3,	{159956,600},	},
	--[L.creatureNames["Nether Ray"]] = 		{2,	{90355,360,40},	},
	[L.creatureNames["Nether Ray"]] = 		{2, 	{160452,360,40}, },
	[L.creatureNames["Porcupine"]] = 		{1,	},
	[L.creatureNames["Quilen"]] = 		{3,	{126393,600},	},
	[L.creatureNames["Raptor"]] = 		{3,	{160052,45},	},
	[L.creatureNames["Ravager"]] = 		{2,	},
	["Clefthoof"] = 				{1,	},					-- Clefthoof[WOD] = Rhino
	[L.creatureNames["Scorpid"]] = 		{1,	{160060,6},	},
	[L.creatureNames["Serpent"]] = 		{2,	{128433,90},	},
	[L.creatureNames["Shale Spider"]] = 	{1,	{160063,60,12},	},
	[L.creatureNames["Silithid"]] = 		{2,	{160065,10},	},
	[L.creatureNames["Spider"]] = 		{2,	{160067,10},	},
	[L.creatureNames["Spirit Beast"]] = 	{3,	{90328,10},	{90361,30},	},
	[L.creatureNames["Sporebat"]] = 		{2,	},
	[L.creatureNames["Tallstrider"]] = 	{3,	{160073,45},	},
	[L.creatureNames["Turtle"]] = 		{1,	{26064,60,12},	},
	[L.creatureNames["Warp Stalker"]] = 	{1,	{35346,15},	},
	[L.creatureNames["Wasp"]] = 		{3,	},
	[L.creatureNames["Water Strider"]] = 	{2,	},
	[L.creatureNames["Wind Serpent"]] = 	{2,	},
	[L.creatureNames["Wolf"]] = 		{3,	{24604,45},	},
	[L.creatureNames["Worm"]] = 		{1,	{93433,14},	},
	[1] = 						{0,	{53478,360,20},	{61685,25},	{63900,10},	},
	[2] = 						{0,	{53490,180,12},	{61684,32,16},	{53480,60,12},	},
	[3] = 						{0,	{61684,32,16},	{55709,480},	},
	[L.creatureNames["Ghoul"]] = 		{0,	{91837,45,10},	{91802,30},	{91797,60},	},
	[L.creatureNames["Felguard"]] = 		{0,	{89751,45,6},	{89766,30},	{30151,15},	},
	[L.creatureNames["Felhunter"]] = 		{0,	{19647,24},	{19505,15},	},
	[L.creatureNames["Fel Imp"]] = 		{0,	{115276,10},	},
	[L.creatureNames["Imp"]] = 		{0,	{89808,10},	{119899,30,12},	{89792,20},	},
	[L.creatureNames["Observer"]] = 		{0,	{115781,24},	{115284,15},	},
	[L.creatureNames["Shivarra"]] = 		{0,	{115770,25},	{115268,30},	},
	[L.creatureNames["Succubus"]] = 		{0,	{6360,25},	{6358,30},	},
	[L.creatureNames["Voidlord"]] = 		{0,	{115236,10}	},
	[L.creatureNames["Voidwalker"]] = 		{0,	{17735,10},	{17767,120,20},	{115232,10},	},
	[L.creatureNames["Wrathguard"]] = 		{0,	{115831,45,6},	},
	[L.creatureNames["Water Elemental"]] = 	{0,	{135029,25,4},	{33395,25},	},
}
module.db.spell_isPetAbility = {}
do
	for petName,petData in pairs(module.db.petsAbilities) do
		for i=2,#petData do
			module.db.spell_isPetAbility[petData[i][1]] = petName
		end
	end
end

module.db.itemsToSpells = {	-- Тринкеты вида [item ID] = spellID
	[113931] = 176878,
	[113969] = 176874,
	[118876] = 177597,	--Coin
	[118878] = 177594,	--Couplend
	[118880] = 177592,	--Candle
	[118882] = 177189,	--Kyanos
	[118884] = 176460,	--Kyb
	[113905] = 176873,	--Tank BRF
	[113834] = 176876,
	[113835] = 176875,	--Shard of nothing
	[113842] = 176879,
	[110002] = 165531,
	[110003] = 165543,
	[110008] = 165535,
	[110012] = 165532,
	[110013] = 165543,
	[110017] = 165534,
	[110018] = 165535,
	[114488] = 176883,
	[114489] = 176882,
	[114490] = 176884,
	[114491] = 176881,
	[114492] = 176885,
	[109997] = 165485,
	[109998] = 165542,
	[110007] = 165532,
	[124224] = 184270,	--Mirror of the Blademaster
	[124232] = 183929,	--Intuition's Gift
	[133598] = 201414,
	[133585] = 201371,
	
	[137105] = 206338,
	[137059] = 206380,
	[137017] = 207628,
	[137089] = 215176,
	[137054] = 215057,
	[137101] = 206332,
	[137033] = 206889,
	[137227] = 212278,
	[137100] = 208892,
	[137030] = 208895,
	[132436] = 214576,
	[132367] = 208706,
	[132376] = 210852,
	[137058] = 210604,
	[137097] = 209256,
	[137027] = 224489,
	[137096] = 206902,
	[137039] = 208199,
	[137061] = 215149,
	[137071] = 210867,
	[138949] = 210970,
	[144279] = 209354,
	
	[64402] = 90633,
	[64401] = 90632,
	[64400] = 90631,
	
	[133642] = 215956,
	[137541] = 215648,
	[137539] = 214962,
	[137538] = 215936,
	[137537] = 215658,
	[137486] = 214980,
	[137462] = 215206,
	[137440] = 214584,
	[137433] = 215467,
	[137369] = 214971,
	[137344] = 214423,
	[137338] = 214366,
	[137329] = 215670,
	[133647] = 214203,
	[133646] = 214198,
	[139322] = 221837,
	[139333] = 221992,
	[139327] = 221695,
	[139326] = 222046,
	[139320] = 221803,
	[144249] = 235169,
	[144258] = 235966,
	[144259] = 235991,
	[144280] = 235556,
	[143728] = 208091,
	[144274] = 235273,
	[144293] = 235605,
	[144355] = 235940,
	[144242] = 235039,
	
	[151978] = 251946,

	[167865] = 295271,
}
module.db.itemsArtifacts = {}	-- Artifacts & First trait

do
	for itemID,spellID in pairs(module.db.itemsArtifacts) do
		module.db.itemsToSpells[itemID] = spellID
	end
	for itemID,spellID in pairs(module.db.itemsToSpells) do
		module.db.spell_isTalent[spellID] = true
	end
end
ExRT.F.table_add2(module.db.itemsToSpells,{
	[124634] = 187614,	--Legendary Ring
	[124636] = 187615,	--Legendary Ring
	[124635] = 187611,	--Legendary Ring
	[124637] = 187613,	--Legendary Ring
	[124638] = 187612,	--Legendary Ring
})

module.db.differentIcons = {	--Другие иконки заклинаниям
	[176875]="Interface\\Icons\\Inv_misc_trinket6oOG_Isoceles1",
	[176873]="Interface\\Icons\\Inv_misc_trinket6oIH_orb4",
	[184270]="Interface\\Icons\\spell_nature_mirrorimage",
	[183929]="Interface\\Icons\\spell_mage_presenceofmind",	
	[187614]="Interface\\Icons\\inv_60legendary_ring1c",
	[187613]="Interface\\Icons\\inv_60legendary_ring1b",
	[187612]="Interface\\Icons\\inv_60legendary_ring1a",
	
	[90633] = "Interface\\Icons\\inv_guild_standard_horde_c",
	[90632] = "Interface\\Icons\\inv_guild_standard_horde_b",
	[90631] = "Interface\\Icons\\inv_guild_standard_horde_a",

	--Prevent replacing icons for players with some talents
	[31884] = "Interface\\Icons\\spell_holy_avenginewrath",	--Avenging Wrath
	[1022] = "Interface\\Icons\\spell_holy_sealofprotection",	--Blessing of Protection
	[62618] = "Interface\\Icons\\spell_holy_powerwordbarrier",	--Power Word: Barrier

	[295271] = 1003587,
}

if ExRT.isClassic then
	module.db.findspecspells = {}
	module.db.spell_isTalent = {}
	module.db.spell_autoTalent = {}
	module.db.spell_charge_fix = {}
	module.db.spell_talentReplaceOther = {}
	module.db.spell_aura_list = {}
	module.db.spell_speed_list = {}
	module.db.spell_afterCombatReset = {}
	module.db.spell_afterCombatNotReset = {}
	module.db.spell_reduceCdByHaste = {}
	module.db.spell_resetOtherSpells = {}
	module.db.spell_reduceCdCast = {}
end

module.db.playerName = nil

module.db.plugin = {}

module.db.notAClass = { r = 0.8, g = 0.8, b = 0.8, colorStr = "ffcccccc" }

local colorSetupFrameColorsNames = {"Default","Active","Cooldown"}
local colorSetupFrameColorsObjectsNames = {"Text","Background","TimeLine"}
local globalGUIDs = nil

module.db.maxLinesInCol = 100
module.db.maxColumns = 10

module.db.colsDefaults = {
	iconSize = 16,
	iconGray = true,
	iconPosition = 1,
	textureFile = ExRT.F.barImg,
	textureBorderSize = 0,
	fontSize = 12,
	fontName = ExRT.F.defFont,
	frameLines = 15,
	frameAlpha = 100,
	frameScale = 100,
	frameWidth = 130,
	frameColumns = 1,
	frameBetweenLines = 0,
	frameBlackBack = 0,
	methodsStyleAnimation = 1,
	methodsTimeLineAnimation = 1,
	methodsSortingRules = 1,
	methodsAlphaNotInRangeNum = 90,
	
	textureBorderColorR = 0,	textureBorderColorG = 0,	textureBorderColorB = 0,	textureBorderColorA = 1,
	
	textureColorTextDefaultR = 1,	textureColorTextDefaultG = 1,	textureColorTextDefaultB = 1,
	textureColorTextActiveR = 1,	textureColorTextActiveG = 1,	textureColorTextActiveB = 1,
	textureColorTextCooldownR = 1,	textureColorTextCooldownG = 1,	textureColorTextCooldownB = 1,

	textureColorBackgroundDefaultR = 0,	textureColorBackgroundDefaultG = 1,	textureColorBackgroundDefaultB = 0,
	textureColorBackgroundActiveR = 0,	textureColorBackgroundActiveG = 1,	textureColorBackgroundActiveB = 0,
	textureColorBackgroundCooldownR = 1,	textureColorBackgroundCooldownG = 0,	textureColorBackgroundCooldownB = 0,

	textureColorTimeLineDefaultR = 0,	textureColorTimeLineDefaultG = 1,	textureColorTimeLineDefaultB = 0,
	textureColorTimeLineActiveR = 0,	textureColorTimeLineActiveG = 1,	textureColorTimeLineActiveB = 0,
	textureColorTimeLineCooldownR = 1,	textureColorTimeLineCooldownG = 0,	textureColorTimeLineCooldownB = 0,
	
	textureAlphaBackground = 0.3,
	textureAlphaTimeLine = 0.8,
	textureAlphaCooldown = 1,
	
	textureSmoothAnimationDuration = 50,
	
	textTemplateLeft = "%name%",
	textTemplateRight = "%time%",
	textTemplateCenter = "",
	
	blacklistText = "",
	whitelistText = "",
}

module.db.colsInit = {
	iconGeneral = true,
	textureGeneral = true,
	methodsGeneral = true,
	frameGeneral = true,
	fontGeneral = true,
	textGeneral = true,
	blacklistGeneral = true,
	visibilityGeneral = true,
	
	iconGray = true,
	textureAnimation = true,
	
	fontOutline = true,
	fontShadow = false,
	
	--textureSmoothAnimation = true,
}

module.db.status_UnitsToCheck = {}
module.db.status_UnitIsDead = {}
module.db.status_UnitIsDisconnected = {}
module.db.status_UnitIsOutOfRange = {}

-- Local functions vaules; other upvaules

local UpdateAllData,SortAllData = nil
local SaveCDtoVar = nil
local CLEUstartCD = nil
local RaidResurrectSpecialCheck,RaidResurrectSpecialText,RaidResurrectSpecialStatus = nil

local L_Offline,L_Dead = L.cd2StatusOffline, L.cd2StatusDead
local _C, _db, _mainFrame = module._C, module.db

local status_UnitsToCheck,status_UnitIsDead,status_UnitIsDisconnected,status_UnitIsOutOfRange = module.db.status_UnitsToCheck,module.db.status_UnitIsDead,module.db.status_UnitIsDisconnected,module.db.status_UnitIsOutOfRange

do
	local frame = CreateFrame("Frame",nil,UIParent)
	module.frame = frame
	frame:SetPoint("CENTER",UIParent, "CENTER", 0, 0)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self) 
		if self:IsMovable() then 
			self:StartMoving() 
		end 
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.ExCD2.Left = self:GetLeft()
		VExRT.ExCD2.Top = self:GetTop()
	end)
	frame.texture = frame:CreateTexture(nil, "BACKGROUND")
	frame.texture:SetColorTexture(0,0,0,0.3)
	frame.texture:SetAllPoints()
	module:RegisterHideOnPetBattle(frame)
	
	frame.colFrame = {}
	
	--upvaule
	_mainFrame = frame
end

local function BarUpdateText(self)
	local barParent = self.parent
		
	local textLeft = barParent.textTemplateLeft
	local textRight = barParent.textTemplateRight
	local textCenter = barParent.textTemplateCenter
	
	local barData = self.data

	local time = (self.curr_end or 0) - GetTime() + 1

	if barData.specialTimer then
		local newTime = barData.specialTimer()
		time = newTime and newTime+1 or time
	end
	
	local name = barData.name
	local spellName = barData.spellName
	
	local longtime,shorttime = nil
	
	if time > 3600 then
		longtime = "1+hour"
		shorttime = "1+hour"
	elseif time < 1 then
		longtime = ""
		shorttime = ""
	else
		longtime = format("%1.1d:%2.2d",time/60,time%60)
		if time < 11 then
			shorttime = format("%.01f",time - 1)
		elseif time < 60 then
			shorttime = format("%d",time)
		else
			shorttime = longtime
		end
	end
	
	if barData.specialAddText then
		name = name .. (barData.specialAddText() or "")
	end
	
	local name_time = time > 0.999 and longtime or name
	local name_stime = time > 0.999 and shorttime or name
	local offStatus = self.disStatus or ""
	local chargesCount = self.curr_charges and "("..self.curr_charges..")" or ""
	
	textLeft = string_gsub(textLeft,"%%time%%",longtime)
	textLeft = string_gsub(textLeft,"%%stime%%",shorttime)
	textLeft = string_gsub(textLeft,"%%name%%",name)
	textLeft = string_gsub(textLeft,"%%name_time%%",name_time)
	textLeft = string_gsub(textLeft,"%%name_stime%%",name_stime)
	textLeft = string_gsub(textLeft,"%%spell%%",spellName)
	textLeft = string_gsub(textLeft,"%%status%%",offStatus)
	textLeft = string_gsub(textLeft,"%%charge%%",chargesCount)
	textRight = string_gsub(textRight,"%%time%%",longtime)
	textRight = string_gsub(textRight,"%%stime%%",shorttime)
	textRight = string_gsub(textRight,"%%name%%",name)
	textRight = string_gsub(textRight,"%%name_time%%",name_time)
	textRight = string_gsub(textRight,"%%name_stime%%",name_stime)
	textRight = string_gsub(textRight,"%%spell%%",spellName)
	textRight = string_gsub(textRight,"%%status%%",offStatus)
	textRight = string_gsub(textRight,"%%charge%%",chargesCount)
	textCenter = string_gsub(textCenter,"%%time%%",longtime)
	textCenter = string_gsub(textCenter,"%%stime%%",shorttime)
	textCenter = string_gsub(textCenter,"%%name%%",name)
	textCenter = string_gsub(textCenter,"%%name_time%%",name_time)
	textCenter = string_gsub(textCenter,"%%name_stime%%",name_stime)
	textCenter = string_gsub(textCenter,"%%spell%%",spellName)
	textCenter = string_gsub(textCenter,"%%status%%",offStatus)
	textCenter = string_gsub(textCenter,"%%charge%%",chargesCount)
	
	self.textLeft:SetText(string_trim(textLeft))
	self.textRight:SetText(string_trim(textRight))
	self.textCenter:SetText(string_trim(textCenter))

	if barParent.optionIconName then
		self.textIcon:SetText(barData.name)
	end
end

local function BarAnimation(self)
	local bar = self.bar
	local t = GetTime()
	
	if t > bar.curr_end then
		bar:Stop()
	else
		local width = (t - bar.curr_start) / bar.curr_dur
		if width > 1 then
			width = 1
		elseif width < 0 then
			width = 0
		end
		bar.timeline:SetShown(width ~= 0)
		bar.timeline:SetWidth(width * bar.timeline.width)
		
		bar.spark:SetPoint("CENTER",bar.statusbar,"LEFT", (t-bar.curr_start) / bar.curr_dur * bar.timeline.width,0)
	end
	self.c = self.c + 1
	if self.c > 3 then
		self.c = 0
		
		bar:UpdateText()
	end
end

local function BarAnimation_Reverse(self)
	local bar = self.bar
	local t = GetTime()
	
	if t > bar.curr_end then
		bar:Stop()
	else
		local width = (bar.curr_end - t) / bar.curr_dur
		if width > 1 then
			width = 1
		elseif width < 0 then
			width = 0
		end
		bar.timeline:SetShown(width ~= 0)
		bar.timeline:SetWidth(width * bar.timeline.width)
		
		bar.spark:SetPoint("CENTER",bar.statusbar,"LEFT", (bar.curr_dur - (t-bar.curr_start)) / bar.curr_dur * bar.timeline.width,0)
	end
	self.c = self.c + 1
	if self.c > 3 then
		self.c = 0
		
		bar:UpdateText()
	end
end

local function BarAnimation_NoAnimation(self)
	local bar = self.bar
	local t = GetTime()
	
	if t > bar.curr_end then
		bar:Stop()
	end
	self.c = self.c + 1
	if self.c > 3 then
		self.c = 0
		
		bar:UpdateText()
	end
end

local function StopBar(self)
  	self.anim:Stop()
  	self.spark:Hide()
 	self:UpdateStatus()
 	if VExRT.ExCD2.SortByAvailability then
 		SortAllData()
 	end
 	UpdateAllData()
end

local function UpdateBar(self)
	local data = self.data
	if not data then
		self:Hide()
		return
	end
	if not self:IsVisible() then
		self:Show()
	end
	local parent = self.parent
	
	self.iconTexture:SetTexture(data.icon)
	self:UpdateText()
	if parent.optionIconName then
		self.textIcon:SetText(data.name)
	end
end

local function BarStateAnimation(self)
	local bar = self.bar
	local progress = self:GetProgress()
	local b = bar.curr_anim_b
	if b then
		bar.background:SetVertexColor(b.r + bar.curr_anim_b_r*progress,b.g + bar.curr_anim_b_g*progress,b.b + bar.curr_anim_b_b*progress,bar.curr_anim_b_a)
	end
	local l = bar.curr_anim_l
	if l then
		bar.timeline:SetVertexColor(l.r + bar.curr_anim_l_r*progress,l.g + bar.curr_anim_l_g*progress,l.b + bar.curr_anim_l_b*progress,bar.curr_anim_l_af+bar.curr_anim_l_a*progress)
	end
	local t = bar.curr_anim_t
	if t then
		bar.textLeft:SetTextColor(t.r + bar.curr_anim_t_r*progress,t.g + bar.curr_anim_t_g*progress,t.b + bar.curr_anim_t_b*progress)
		bar.textRight:SetTextColor(t.r + bar.curr_anim_t_r*progress,t.g + bar.curr_anim_t_g*progress,t.b + bar.curr_anim_t_b*progress)
		bar.textCenter:SetTextColor(t.r + bar.curr_anim_t_r*progress,t.g + bar.curr_anim_t_g*progress,t.b + bar.curr_anim_t_b*progress)
		bar.textIcon:SetTextColor(t.r + bar.curr_anim_t_r*progress,t.g + bar.curr_anim_t_g*progress,t.b + bar.curr_anim_t_b*progress)
	end
end
local function BarStateAnimationFinished(self)
	self.bar.afterAnimFix = true
	self.bar:UpdateStatus()
end

local function UpdateBarStatus(self,isTitle)
	local data = self.data
	if not data then
		return
	end
	if self.isTitle then
		self:UpdateStyle()
		self.isTitle = nil
	end
	if data.specialUpdateData then		--For templates
		data.specialUpdateData(data)
	end
	local parent = self.parent
	local currTime = GetTime()
	local lastUse = data.lastUse

	local active = lastUse + data.duration
	local cooldown = lastUse + data.cd
	
	if parent.methodsDisableActive then
		active = 0
	end
	
	local isActive = (active - currTime) > 0
	local isCooldown = (cooldown - currTime) > 0
	local t = (isActive and active) or (isCooldown and cooldown)
	
	local isDisabled = data.disabled
	if isDisabled then
		isCooldown = true
	end
	if data.specialStatus then
		local var1,var2,var3,var4 = data.specialStatus()
		if var2 then
			if var1 then
				isCooldown = true
				lastUse = var2
				t = var2 + var3
			else
				isCooldown = false
				t = nil	
				if var4 then
					data.charge = var2
					data.cd = var3
				end			
			end
		end
		data.isCharge = var4
	end
	
	self.curr_charges = nil

	local isCharge = nil
	if data.isCharge then
		if data.charge then
			if data.charge <= currTime and (data.charge+data.cd) > currTime then
				isCharge = true
				
				isCooldown = false
				
				self.curr_charges = 1
			elseif data.charge > currTime and not isActive then
				lastUse = data.charge - data.cd
				t = data.charge
				
				isCooldown = true
				
				self.curr_charges = 0
			end
		else
			self.curr_charges = 2
		end
	end
	
	if isCharge and not isActive then
		self.curr_start = data.charge
		self.curr_end = data.charge+data.cd
		self.curr_dur = data.cd
		
		if parent.optionTimeLineAnimation == 1 then
			self.timeline:SetShown(false)
		else
			self.timeline:SetShown(true)
			self.timeline:SetWidth(self.timeline.width)
		end
		self.timeline.SetWidth = self.timeline.IsShown	--Do I really want this shit?
		self.timeline.SetShown = self.timeline.IsShown
		self.spark:Show()
		self.anim:Play()
	elseif t then
		self.curr_start = lastUse
		self.curr_end = t
		self.curr_dur = t - lastUse
		
		self.timeline.SetWidth = self.timeline._SetWidth
		self.timeline.SetShown = self.timeline._SetShown
	
		self.spark:Show()
		self.anim:Play()
	else
		self.curr_start = 0
		self.curr_end = 1
		self.curr_dur = 1
		
		self.timeline.SetWidth = self.timeline._SetWidth
		self.timeline.SetShown = self.timeline._SetShown

	  	self.spark:Hide()
	  	self.anim:Stop()
	  	
	  	if isDisabled then
	  		self.timeline:Hide()
	  	else
	  		if parent.optionTimeLineAnimation == 1 then
	  			self.timeline:Hide()
	  		else
	 			self.timeline:SetWidth(self.timeline.width)
	 			self.timeline:Show()
	 		end
	 	end
	end
	
	local doStandartColors = true
	if parent.optionSmoothAnimation and not self.afterAnimFix then
		doStandartColors = false
		if not parent.optionClassColorBackground then
			local ctFrom, ctTo = nil
			if isActive then
				ctTo = parent.optionColorBackgroundActive
			elseif isCooldown then
				ctTo = parent.optionColorBackgroundCooldown
			else
				ctTo = parent.optionColorBackgroundDefault
			end
			
			if self.curr_anim_state == 1 then
				ctFrom = parent.optionColorBackgroundActive
			elseif self.curr_anim_state == 2 then
				ctFrom = parent.optionColorBackgroundCooldown
			else
				ctFrom = parent.optionColorBackgroundDefault
			end
			
			self.curr_anim_b = ctFrom
			self.curr_anim_b_r = ctTo.r - ctFrom.r
			self.curr_anim_b_g = ctTo.g - ctFrom.g
			self.curr_anim_b_b = ctTo.b - ctFrom.b
			self.curr_anim_b_a = parent.optionAlphaBackground
		else
			self.curr_anim_b = nil
			local colorTable = data.classColor
			self.background:SetVertexColor(colorTable.r,colorTable.g,colorTable.b,parent.optionAlphaBackground)
		end
		if not parent.optionClassColorTimeLine then
			local ctFrom, ctTo = nil
			if isActive then
				ctTo = parent.optionColorTimeLineActive
			elseif isCooldown then
				ctTo = parent.optionColorTimeLineCooldown
			else
				ctTo = parent.optionColorTimeLineDefault
			end
			
			if self.curr_anim_state == 1 then
				ctFrom = parent.optionColorTimeLineActive
				self.curr_anim_l_af = 1
				self.curr_anim_l_a = parent.optionAlphaTimeLine - 1
			elseif self.curr_anim_state == 2 then
				ctFrom = parent.optionColorTimeLineCooldown
				self.curr_anim_l_af = 1
				self.curr_anim_l_a = parent.optionAlphaTimeLine - 1
			else
				ctFrom = parent.optionColorTimeLineDefault
				self.curr_anim_l_af = 0
				self.curr_anim_l_a = parent.optionAlphaTimeLine
			end
			if not parent.optionAnimation then
				self.curr_anim_l_af = 0
				self.curr_anim_l_a = 0
			end
			
			self.curr_anim_l = ctFrom
			self.curr_anim_l_r = ctTo.r - ctFrom.r
			self.curr_anim_l_g = ctTo.g - ctFrom.g
			self.curr_anim_l_b = ctTo.b - ctFrom.b
		else
			self.curr_anim_l = data.classColor
			if self.curr_anim_state == 1 then
				self.curr_anim_l_af = 1
				self.curr_anim_l_a = parent.optionAlphaTimeLine - 1
			elseif self.curr_anim_state == 2 then
				self.curr_anim_l_af = 1
				self.curr_anim_l_a = parent.optionAlphaTimeLine - 1
			else
				self.curr_anim_l_af = 0
				self.curr_anim_l_a = parent.optionAlphaTimeLine
			end
			if not parent.optionAnimation then
				self.curr_anim_l_af = 0
				self.curr_anim_l_a = 0
			end
			self.curr_anim_l_r = 0
			self.curr_anim_l_g = 0
			self.curr_anim_l_b = 0
		end
		if not parent.optionClassColorText then
			local ctFrom, ctTo = nil
			if isActive then
				ctTo = parent.optionColorTextActive
			elseif isCooldown then
				ctTo = parent.optionColorTextCooldown
			else
				ctTo = parent.optionColorTextDefault
			end
			
			if self.curr_anim_state == 1 then
				ctFrom = parent.optionColorTextActive
			elseif self.curr_anim_state == 2 then
				ctFrom = parent.optionColorTextCooldown
			else
				ctFrom = parent.optionColorTextDefault
			end
			
			self.curr_anim_t = ctFrom
			self.curr_anim_t_r = ctTo.r - ctFrom.r
			self.curr_anim_t_g = ctTo.g - ctFrom.g
			self.curr_anim_t_b = ctTo.b - ctFrom.b
		else
			self.curr_anim_t = nil
			local colorTable = data.classColor
			self.textLeft:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
			self.textRight:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
			self.textCenter:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
			self.textIcon:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
		end
		
		if isActive and self.curr_anim_state ~= 1 then
			self.curr_anim_state = 1
			self.anim_state:Stop()
			self.anim_state:Play()
		elseif isCooldown and self.curr_anim_state ~= 2 then
			self.curr_anim_state = 2
			self.anim_state:Stop()
			self.anim_state:Play()
		elseif not isCooldown and not isActive and self.curr_anim_state then
			self.curr_anim_state = nil
			self.anim_state:Stop()
			self.anim_state:Play()
		else
			doStandartColors = true
		end
	end
	if doStandartColors then
		local colorTable = nil
		if parent.optionClassColorBackground then
			colorTable = data.classColor
		else
			if isActive then
				colorTable = parent.optionColorBackgroundActive
			elseif isCooldown then
				colorTable = parent.optionColorBackgroundCooldown
			else
				colorTable = parent.optionColorBackgroundDefault
			end
		end
		self.background:SetVertexColor(colorTable.r,colorTable.g,colorTable.b,parent.optionAlphaBackground)
		
		if parent.optionClassColorTimeLine then
			colorTable = data.classColor
		else
			if isActive then
				colorTable = parent.optionColorTimeLineActive
			elseif isCooldown then
				colorTable = parent.optionColorTimeLineCooldown
			else
				colorTable = parent.optionColorTimeLineDefault
			end
		end
		self.timeline:SetVertexColor(colorTable.r,colorTable.g,colorTable.b,parent.optionAlphaTimeLine)
		
		if parent.optionClassColorText then
			colorTable = data.classColor
		else
			if isActive then
				colorTable = parent.optionColorTextActive
			elseif isCooldown then
				colorTable = parent.optionColorTextCooldown
			else
				colorTable = parent.optionColorTextDefault
			end
		end	
		self.textLeft:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
		self.textRight:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
		self.textCenter:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
		self.textIcon:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
	end
	self.afterAnimFix = nil
	
	if parent.optionGray then
		if isCooldown and not isActive then
			self.iconTexture:SetDesaturated(true)
		else
			self.iconTexture:SetDesaturated(nil)
		end
	end
	
	if parent.optionCooldown then
		-- BIG NOTE:
		-- Cooldown widget is currently bugged
		-- You can set time ( CD_end_time - Now_time ) only for number that is bigger than UI session (ie after reloadUI UI session timer will be 0)
		-- No way for fix :(
	
		if isActive then
			self.cooldown:Show()
			self.cooldown:SetReverse(true)
			self.cooldown:SetCooldown(self.curr_start,self.curr_end-self.curr_start)
		elseif isCooldown then
			self.cooldown:Show()
			self.cooldown:SetReverse(false)
			if isDisabled then
				self.cooldown:SetCooldown(currTime,0)
			else
				self.cooldown:SetCooldown(self.curr_start,self.curr_dur)
			end
		else
			self.cooldown:Hide()
		end
	end
	
	local alpha = 1
	if parent.methodsAlphaNotInRange then
		if data.outofrange then
			alpha = parent.methodsAlphaNotInRangeNum
			self:SetAlpha(alpha)
		else
			self:SetAlpha(1)
		end
	end
	
	if (parent.optionAlphaCooldown or 1) < 1 then
		if isCooldown and not isActive then
			self:SetAlpha(parent.optionAlphaCooldown)
		else
			self:SetAlpha(alpha)
		end
	end
	
	if isDisabled == 2 then
		self.disStatus = L_Offline
	elseif isDisabled == 1 then
		self.disStatus = L_Dead
	else
		self.disStatus = nil
	end
	
	self:UpdateText()
end

local function BarCreateTitle(self)
	local parent = self.parent

	local height = parent.iconSize or 24

	self.statusbar:ClearAllPoints()	self.statusbar:SetHeight(height)
	self.icon:ClearAllPoints()	self.icon:SetSize(height,height)
	
	self.textLeft:SetText("")
	self.textRight:SetText("")
	self.textCenter:SetText("")
	self.textIcon:SetText("")
	
	if parent.optionIconPosition == 2 then
		self.icon:Show()
		self.statusbar:SetPoint("LEFT",self,0,0)
		self.statusbar:SetPoint("RIGHT",self,-height,0)
		self.icon:SetPoint("RIGHT",self,0,0)
		
		self.textRight:SetPoint("LEFT",self,0,0)

		self.textRight:SetTextColor(1,1,1)
		self.textRight:SetText(self.data.spellName)
	elseif parent.optionIconPosition == 1 then
		self.icon:Show()
		self.statusbar:SetPoint("LEFT",self,height,0)
		self.statusbar:SetPoint("RIGHT",self,0,0)
		self.icon:SetPoint("LEFT",self,0,0)
		
		self.textLeft:SetTextColor(1,1,1)
		self.textLeft:SetText(self.data.spellName)		
	end
	
	self.curr_start = 0
	self.curr_end = 1
	self.curr_dur = 1

  	self.spark:Hide()
  	self.anim:Stop()
  	
 	self.timeline:Hide()
  	
  	self.background:SetVertexColor(0,0,0,parent.optionAlphaTimeLine)
  	
  	self.iconTexture:SetTexture(self.data.icon)
  	self.cooldown:Hide()
  	
  	self:SetAlpha(1)
  	self:Show()
  	
  	self.isTitle = true
end

local function LineIconOnHover(self)
	local parent = self:GetParent()
	if not parent.data then	return end
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:SetHyperlink("spell:"..parent.data.db[1])
	GameTooltip:Show()
end
local function LineIconOnClick(self)
	local parent = self:GetParent()
	if not parent.data then	return end
	if parent.data.specialClick then
		parent.data.specialClick(parent.data)
		return
	end	
	local time = parent.data.lastUse + parent.data.cd - GetTime()
	if time < 0 then return end
	local text = parent.data.name.." - "..parent.data.spellName..": "..format("%1.1d:%2.2d",time/60,time%60)
	local chat_type = ExRT.F.chatType(true)
	SendChatMessage(text,chat_type)
end
local function LineIconOnClickWhisper(self)
	local parent = self:GetParent()
	if not parent.data then	return end
	if parent.data.specialClick then
		parent.data.specialClick(parent.data)
		return
	end	
	local time = parent.data.lastUse + parent.data.cd - GetTime()
	if time > 0 then return end
	local spellLink = GetSpellLink(parent.data.db[1])
	if not spellLink or spellLink == "" then
		spellLink = parent.data.spellName
	end
	local text = "Use "..spellLink
	local chat_type = ExRT.F.chatType(true)
	SendChatMessage(text,"WHISPER",nil,parent.data.fullName)
end
local function LineIconOnClickBoth(self)
	local parent = self:GetParent()
	if not parent.data then	return end
	local time = parent.data.lastUse + parent.data.cd - GetTime()
	if time > 0 then 
		return LineIconOnClick(self)
	else
		return LineIconOnClickWhisper(self)
	end
end

local function UpdateBarStyle(self)
	local parent = self.parent

	local width = parent.barWidth or 100
	local height = parent.iconSize or 24
	
	self:SetSize(width,height)
	
	self.textLeft:ClearAllPoints()	self.textLeft:SetSize(0,height)	
	self.textRight:ClearAllPoints()	self.textRight:SetSize(0,height)
	self.textCenter:ClearAllPoints()self.textCenter:SetSize(0,height)
					self.textIcon:SetSize(height,height)
	self.icon:ClearAllPoints()	self.icon:SetSize(height,height)
	self.statusbar:ClearAllPoints()	self.statusbar:SetHeight(height)
					self.spark:SetSize(10,height+10)
					self.cooldown:SetSize(height,height)
		
	local iconSize = height			
	if parent.optionIconPosition == 3 or parent.optionIconTitles then
		self.icon:Hide()
		self.statusbar:SetPoint("LEFT",self,0,0)
		self.statusbar:SetPoint("RIGHT",self,0,0)
		iconSize = 0
	elseif parent.optionIconPosition == 2 then
		self.icon:Show()
		self.statusbar:SetPoint("LEFT",self,0,0)
		self.statusbar:SetPoint("RIGHT",self,-height,0)
		self.icon:SetPoint("RIGHT",self,0,0)
	else
		self.icon:Show()
		self.statusbar:SetPoint("LEFT",self,height,0)
		self.statusbar:SetPoint("RIGHT",self,0,0)
		self.icon:SetPoint("LEFT",self,0,0)
	end

	self.timeline.width = width - iconSize
	self.timeline:SetSize(width - iconSize,height)
	
	if parent.optionIconHideBlizzardEdges then
		self.iconTexture:SetTexCoord(.1,.9,.1,.9)
	else
		self.iconTexture:SetTexCoord(0,1,0,1)
	end
	
	if parent.optionHideSpark then
		self.spark:SetTexture("")
	else
		self.spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	end
	
	local fontOutlineFix = parent.fontOutline and 3 or 0
	if parent.textTemplateLeft:find("time%%") then
		self.textLeft:SetPoint("LEFT",self.statusbar,1,0)
		self.textRight:SetPoint("RIGHT",self.statusbar,-1+fontOutlineFix,0)
		self.textRight:SetPoint("LEFT",self.textLeft,"RIGHT",0,0)
	else
		self.textRight:SetPoint("RIGHT",self.statusbar,-1+fontOutlineFix,0)
		self.textLeft:SetPoint("LEFT",self.statusbar,1,0)
		self.textLeft:SetPoint("RIGHT",self.textRight,"LEFT",0,0)
	end
	
	self.textCenter:SetPoint("LEFT",self.statusbar,0,0)
	self.textCenter:SetPoint("RIGHT",self.statusbar,0,0)
	
	self.barWidth = width
	
	local textureFile = parent.textureFile or module.db.colsDefaults.textureFile
	local isValidTexture = self.background:SetTexture(textureFile)
	if not isValidTexture then
		textureFile = module.db.colsDefaults.textureFile
		self.background:SetTexture(textureFile)
	end
	self.timeline:SetTexture(textureFile)
	
	local isValidFont = nil
	
	isValidFont = self.textLeft:SetFont(parent.fontLeftName,parent.fontLeftSize,parent.fontLeftOutline and "OUTLINE")	if not isValidFont then self.textLeft:SetFont(module.db.colsDefaults.fontName,parent.fontLeftSize,parent.fontLeftOutline and "OUTLINE") end
	isValidFont = self.textRight:SetFont(parent.fontRightName,parent.fontRightSize,parent.fontRightOutline and "OUTLINE")	if not isValidFont then self.textRight:SetFont(module.db.colsDefaults.fontName,parent.fontRightSize,parent.fontRightOutline and "OUTLINE") end
	isValidFont = self.textCenter:SetFont(parent.fontCenterName,parent.fontCenterSize,parent.fontCenterOutline and "OUTLINE")if not isValidFont then self.textCenter:SetFont(module.db.colsDefaults.fontName,parent.fontCenterSize,parent.fontCenterOutline and "OUTLINE") end
	isValidFont = self.textIcon:SetFont(parent.fontIconName,parent.fontIconSize,parent.fontIconOutline and "OUTLINE")	if not isValidFont then self.textIcon:SetFont(module.db.colsDefaults.fontName,parent.fontIconSize,parent.fontIconOutline and "OUTLINE") end
	
	local fontOffset = 0
	fontOffset = parent.fontLeftShadow and 1 or 0	self.textLeft:SetShadowOffset(1*fontOffset,-1*fontOffset)
	fontOffset = parent.fontRightShadow and 1 or 0	self.textRight:SetShadowOffset(1*fontOffset,-1*fontOffset)
	fontOffset = parent.fontCenterShadow and 1 or 0	self.textCenter:SetShadowOffset(1*fontOffset,-1*fontOffset)
	fontOffset = parent.fontIconShadow and 1 or 0	self.textIcon:SetShadowOffset(1*fontOffset,-1*fontOffset)
	
	self.iconTexture:SetDesaturated(nil)
	
	self:SetAlpha(1)
	
	self.cooldown:Hide()
	self.cooldown:SetHideCountdownNumbers(parent.optionCooldownHideNumbers and true or false)
	self.cooldown:SetDrawEdge(parent.optionCooldownShowSwipe and true or false)

	self.textIcon:SetText("")
	
	if parent.optionAnimation then
		if parent.optionStyleAnimation == 1 then
			self.anim:SetScript("OnLoop",BarAnimation_Reverse)
		else
			self.anim:SetScript("OnLoop",BarAnimation)
		end
	else
		self.anim:SetScript("OnLoop",BarAnimation_NoAnimation)
		self.spark:SetTexture("")
		self.timeline:Hide()
	end
	
	if parent.methodsIconTooltip then
		self.icon:SetScript("OnEnter",LineIconOnHover)
		self.icon:SetScript("OnLeave",GameTooltip_Hide)
	else
		self.icon:SetScript("OnEnter",nil)
		self.icon:SetScript("OnLeave",nil)	
	end
	
	
	if parent.methodsLineClick and parent.methodsLineClickWhisper then
		self.clickFrame:SetScript("OnClick",LineIconOnClickBoth)
		self.clickFrame:Show()	
	elseif parent.methodsLineClick then
		self.clickFrame:SetScript("OnClick",LineIconOnClick)
		self.clickFrame:Show()
	elseif parent.methodsLineClickWhisper then
		self.clickFrame:SetScript("OnClick",LineIconOnClickWhisper)
		self.clickFrame:Show()		
	else
		self.clickFrame:SetScript("OnClick",nil)
		self.clickFrame:Hide()	
	end
	
	local borderSize = parent.textureBorderSize
	if borderSize == 0 then
		self.border.top:Hide()
		self.border.bottom:Hide()
		self.border.left:Hide()
		self.border.right:Hide()
	else
		self.border.top:ClearAllPoints()
		self.border.bottom:ClearAllPoints()
		self.border.left:ClearAllPoints()
		self.border.right:ClearAllPoints()
		
		self.border.top:SetPoint("TOPLEFT",self,"TOPLEFT",-borderSize,borderSize)
		self.border.top:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",borderSize,0)
	
		self.border.bottom:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT",-borderSize,-borderSize)
		self.border.bottom:SetPoint("TOPRIGHT",self,"BOTTOMRIGHT",borderSize,0)
	
		self.border.left:SetPoint("TOPLEFT",self,"TOPLEFT",-borderSize,0)
		self.border.left:SetPoint("BOTTOMRIGHT",self,"BOTTOMLEFT",0,0)
	
		self.border.right:SetPoint("TOPLEFT",self,"TOPRIGHT",0,0)
		self.border.right:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",borderSize,0)
	
		self.border.top:SetColorTexture(parent.textureBorderColorR,parent.textureBorderColorG,parent.textureBorderColorB,parent.textureBorderColorA)
		self.border.bottom:SetColorTexture(parent.textureBorderColorR,parent.textureBorderColorG,parent.textureBorderColorB,parent.textureBorderColorA)
		self.border.left:SetColorTexture(parent.textureBorderColorR,parent.textureBorderColorG,parent.textureBorderColorB,parent.textureBorderColorA)
		self.border.right:SetColorTexture(parent.textureBorderColorR,parent.textureBorderColorG,parent.textureBorderColorB,parent.textureBorderColorA)
	
		self.border.top:Show()
		self.border.bottom:Show()
		self.border.left:Show()
		self.border.right:Show()
	end
	
	self.anim_state.timer:SetDuration(parent.optionSmoothAnimationDuration)
	
	if module.db.plugin and type(module.db.plugin.UpdateBarStyle)=="function" then
		module.db.plugin.UpdateBarStyle(self)
	end
end

local function CreateBar(parent)
	local self = CreateFrame("Frame",nil,parent)
	
	self.parent = parent
	
	local statusbar = CreateFrame("StatusBar", nil, self)
	statusbar:SetPoint("TOPRIGHT")
	statusbar:SetPoint("BOTTOMLEFT")
	self.statusbar = statusbar
	
	local timeline = statusbar:CreateTexture(nil, "BACKGROUND")
	timeline:SetPoint("LEFT")
	timeline._SetWidth = timeline.SetWidth
	timeline._SetShown = timeline.SetShown
	self.timeline = timeline
	
	local spark = statusbar:CreateTexture(nil, "BACKGROUND", nil, 3)
	spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	spark:SetBlendMode("ADD")
	spark:SetPoint("CENTER",statusbar,"RIGHT", 0,0)
	spark:SetAlpha(0.5)
	spark:Hide()
	self.spark = spark
	
	local anim = self:CreateAnimationGroup()
	anim:SetLooping("REPEAT")
	anim.c = 0
	anim.timer = anim:CreateAnimation()
	anim.timer:SetDuration(0.04)
	anim:SetScript("OnLoop",BarAnimation)
	anim.bar = self
	self.anim = anim
	
	local anim_state = self:CreateAnimationGroup()
	anim_state.timer = anim_state:CreateAnimation()
	anim_state.timer:SetDuration(0.5)
	anim_state:SetScript("OnUpdate",BarStateAnimation)
	anim_state:SetScript("OnFinished",BarStateAnimationFinished)
	anim_state.bar = self
	self.anim_state = anim_state
	
	local icon = CreateFrame("Frame",nil,self)
	icon:SetPoint("TOPLEFT", 0, 0)
	local iconTexture = icon:CreateTexture(nil, "BACKGROUND")
	iconTexture:SetAllPoints()
	self.icon = icon
	self.iconTexture = iconTexture
	
	local cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
	cooldown:SetDrawEdge(false)
	--cooldown:SetAllPoints()
	cooldown:SetPoint("CENTER")
	cooldown:SetHideCountdownNumbers(false)
	cooldown:SetDrawEdge(false)
	cooldown:SetDrawSwipe(true)
	self.cooldown = cooldown
	
	local background = self:CreateTexture(nil, "BACKGROUND", nil, -7)
	background:SetAllPoints()
	self.background = background
	
	self.textLeft = ELib:Text(self.statusbar,nil,nil,"GameFontNormal"):Size(0,0):Point(1,0):Color()
	self.textRight = ELib:Text(self.statusbar,nil,nil,"GameFontNormal"):Size(40,0):Point("TOPRIGHT",1,0):Right():Color()
	self.textCenter = ELib:Text(self.statusbar,nil,nil,"GameFontNormal"):Size(0,0):Point(0,0):Center():Color()
	self.textIcon = ELib:Text(icon,nil,nil,"GameFontNormal"):Size(0,0):Point(0,0):Center():Bottom():Color()
	
	self.textIcon:SetDrawLayer("ARTWORK",3)
	--[[
	self.textLeft = self.statusbar:CreateFontString(nil,"ARTWORK")
	self.textLeft:SetJustifyH("LEFT")
	self.textLeft:SetJustifyV("MIDDLE")
	self.textLeft:SetSize(0,0)
	self.textLeft:SetPoint("TOPLEFT",1,0)
	self.textLeft:SetFont(ExRT.F.defFont,12)
	self.textLeft:SetTextColor(1,1,1,1)
	
	self.textRight = self.statusbar:CreateFontString(nil,"ARTWORK")
	self.textRight:SetJustifyH("RIGHT")
	self.textRight:SetJustifyV("MIDDLE")
	self.textRight:SetSize(40,0)
	self.textRight:SetPoint("TOPRIGHT",1,0)
	self.textRight:SetFont(ExRT.F.defFont,12)
	self.textRight:SetTextColor(1,1,1,1)
	
	self.textCenter = self.statusbar:CreateFontString(nil,"ARTWORK")
	self.textCenter:SetJustifyH("CENTER")
	self.textCenter:SetJustifyV("MIDDLE")
	self.textCenter:SetSize(0,0)
	self.textCenter:SetPoint("TOPLEFT",1,0)
	self.textCenter:SetFont(ExRT.F.defFont,12)
	self.textCenter:SetTextColor(1,1,1,1)
	
	self.textIcon = icon:CreateFontString(nil,"ARTWORK")
	self.textIcon:SetJustifyH("CENTER")
	self.textIcon:SetJustifyV("BOTTOM")
	self.textIcon:SetSize(0,0)
	self.textIcon:SetPoint("TOPLEFT",1,0)
	self.textIcon:SetFont(ExRT.F.defFont,12)
	self.textIcon:SetTextColor(1,1,1,1)
	]]
	
	--6.1 multilinetext fix
	self.textLeft:SetMaxLines(1)
	self.textRight:SetMaxLines(1)
	self.textCenter:SetMaxLines(1)
	
	self.border = {}
	self.border.top = self:CreateTexture(nil, "BACKGROUND")
	self.border.bottom = self:CreateTexture(nil, "BACKGROUND")
	self.border.left = self:CreateTexture(nil, "BACKGROUND")
	self.border.right = self:CreateTexture(nil, "BACKGROUND")
	
	self.clickFrame = CreateFrame("Button",nil,self)
	self.clickFrame:SetAllPoints()
	self.clickFrame:Hide()
	
	self.Stop = StopBar
	self.Update = UpdateBar
	self.UpdateStyle = UpdateBarStyle
	self.UpdateText = BarUpdateText
	self.UpdateStatus = UpdateBarStatus
	self.CreateTitle = BarCreateTitle
	
	return self
end

for i=1,module.db.maxColumns do
	local columnFrame = CreateFrame("Frame",nil,module.frame)
	module.frame.colFrame[i] = columnFrame
	columnFrame:EnableMouse(false)
	columnFrame:SetMovable(false)
	columnFrame:RegisterForDrag("LeftButton")
	columnFrame:SetScript("OnDragStart", function(self) 
		if self:IsMovable() then 
			self:StartMoving() 
		end 
	end)
	columnFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		VExRT.ExCD2.colSet[i].posX = self:GetLeft()
		VExRT.ExCD2.colSet[i].posY = self:GetTop()
	end)	
	columnFrame.texture = columnFrame:CreateTexture(nil, "BACKGROUND")
	columnFrame.texture:SetColorTexture(0,0,0,0)
	columnFrame.texture:SetAllPoints()
	
	columnFrame.lockTexture = columnFrame:CreateTexture(nil, "BACKGROUND")
	columnFrame.lockTexture:SetColorTexture(0,0,0,0)
	columnFrame.lockTexture:SetAllPoints()

	columnFrame.lines = {}
	
	columnFrame.BlackList = {}
	
	module:RegisterHideOnPetBattle(columnFrame)
end

do
	local isInCombat = false
	local isInEncounter = false
	function module:updateCombatVisibility()
		local _, zoneType = GetInstanceInfo()
		local inRaid = IsInRaid()
		for i=1,module.db.maxColumns do
			local columnFrame = module.frame.colFrame[i]
			
			local state = columnFrame.optionIsEnabled
		
			if not columnFrame.methodsOnlyInCombat then
			
			elseif isInCombat and columnFrame.optionIsEnabled then
				state = state and true
			elseif not isInCombat then
				state = false
			end
			
			if zoneType == "arena" then
				if not columnFrame.visibilityArena then
					state = false
				end
			elseif zoneType == "party" then
				if not columnFrame.visibility5ppl then
					state = false
				end			
			elseif zoneType == "pvp" then
				if not columnFrame.visibilityBG then
					state = false
				end				
			elseif zoneType == "raid" then
				if not columnFrame.visibilityRaid then
					state = false
				end				
			elseif zoneType == "scenario" then
				if not columnFrame.visibility3ppl then
					state = false
				end				
			else
				if not columnFrame.visibilityWorld then
					state = false
				end				
			end
			
			if (columnFrame.visibilityPartyType == 2 and not inRaid) or (columnFrame.visibilityPartyType == 1 and inRaid) then
				state = false
			end
			
			columnFrame:SetShown(state)
		end
		if not VExRT.ExCD2.SplitOpt then
			if VExRT.ExCD2.colSet[module.db.maxColumns+1].methodsOnlyInCombat then
				if isInCombat then
					module.frame:Show()
				else
					module.frame:Hide()
				end
			elseif module.frame.IsEnabled then
				module.frame:Show()
			end
		end
	end
	function module:toggleCombatVisibility(currState,callType)
		local isInstance, instanceType = IsInInstance()
		if instanceType == "arena" or instanceType == "pvp" then
			currState = true
		elseif instanceType == "raid" or instanceType == "party" then
			if callType == 1 then
				isInEncounter = currState
			elseif callType == 2 then
				currState = currState or isInEncounter
			end
		elseif callType == 1 then
			return	--ignore encounters not in raid/party
		end
		isInCombat = currState
		module:updateCombatVisibility()
	end
end

do
	local lastSaving = GetTime() - 15
	function SaveCDtoVar(overwrite)
		local currTime = GetTime()
		if ((currTime - lastSaving) < 30 and not overwrite) or module.db.testMode then 
			return 
		end
		wipe(VExRT.ExCD2.Save)
		for i=1,#_C do
			local unitSpellData = _C[i]
			if unitSpellData.lastUse + unitSpellData.cd - currTime > 0 then
				VExRT.ExCD2.Save[ (unitSpellData.fullName or "?")..(unitSpellData.db[1] or 0) ] = {unitSpellData.lastUse,unitSpellData.cd}
			else
				VExRT.ExCD2.Save[ (unitSpellData.fullName or "?")..(unitSpellData.db[1] or 0) ] = nil
			end	
		end
	end
end

local function AfterCombatResetFunction(isArena)
	if not ExRT.isClassic then
		for i=1,#_C do
			local unitSpellData = _C[i]
			local uSpecID = module.db.specInDBase[globalGUIDs[unitSpellData.fullName] or 0]
			if not unitSpellData.db[uSpecID] and unitSpellData.db[3] then
				uSpecID = 3
			end
	
			if (unitSpellData.cd > 0 and (module.db.spell_afterCombatReset[unitSpellData.db[1]] or (unitSpellData.db[uSpecID] and unitSpellData.db[uSpecID][2] >= (isArena and 0 or 180) or unitSpellData.cd >= (isArena and 0 or 180)))) and (not module.db.spell_afterCombatNotReset[unitSpellData.db[1]] or isArena) then
				unitSpellData.lastUse = 0 
				unitSpellData.charge = nil 
				
				if unitSpellData.bar and unitSpellData.bar.data == unitSpellData then
					unitSpellData.bar:UpdateStatus()
				end
			end
		end
	end
	SaveCDtoVar(true)
end

local function TestMode(h)
	if not h then
		for i=1,#_C do
			local data = _C[i]
			local uSpecID = module.db.specInDBase[VExRT.ExCD2.gnGUIDs[data.fullName] or 0]
			if not data.db[uSpecID] then
				uSpecID = 3
			end
			if data.db[uSpecID] then
				if fastrandom(0,100) < 80 then
					data.cd = data.db[uSpecID][2]
					data.lastUse = GetTime() - fastrandom(0,data.db[uSpecID][2]) - fastrandom()
					data.duration = data.db[uSpecID][3]
				end
			end
		end
	else
		for i=1,#_C do
			local data = _C[i]
			data.lastUse = 0
			data.duration = 0
		end
	end
	UpdateAllData()
	SortAllData()
end

function module.IsPvpTalentsOn(unit)
	local _, zoneType = GetInstanceInfo()
	if zoneType == 'arena' or zoneType == 'pvp' then
		return true
	elseif (zoneType == "none" or not zoneType) and UnitIsWarModeActive(unit) then
		return true
	else
		return false
	end
end

do
	local inColsCount = {}
	
	--Upvaules
	local maxColumns = _db.maxColumns
	local maxLinesInCol = _db.maxLinesInCol
	local specInDBase = _db.specInDBase
	local spell_isTalent = _db.spell_isTalent
	local spell_isPvpTalent = _db.spell_isPvpTalent
	local session_gGUIDs = _db.session_gGUIDs
	local spell_isPetAbility = _db.spell_isPetAbility
	local session_Pets = _db.session_Pets
	local petsAbilities = _db.petsAbilities
	local spell_talentReplaceOther = _db.spell_talentReplaceOther
	local spell_charge_fix = _db.spell_charge_fix
	local def_col = _db.def_col
	local columnsTable = _mainFrame.colFrame
	
	local playerName = ExRT.SDB.charName
	
	local IsPvpTalentsOn = module.IsPvpTalentsOn
		
	local saveDataTimer = 0
	local lastBattleResChargesStatus = nil
	
	local function sort_a(a,b) return (a.sort or 0) < (b.sort or 0) end
	local function sort_b(a,b) if a.sorting == b.sorting then return (a.sort or 0) < (b.sort or 0) else return (a.sorting or 0) < (b.sorting or 0) end end
	--local function sort_b(a,b) return (a.sorting or 0) < (b.sorting or 0) end
	local function sort_ar(a,b) return (a.sort or 0) > (b.sort or 0) end
	local function sort_br(a,b) if a.sorting == b.sorting then return (a.sort or 0) > (b.sort or 0) else return (a.sorting or 0) > (b.sorting or 0) end end
	
	local oneSpellPerCol = {} for i=1,maxColumns do oneSpellPerCol[i]={} end
	local reviewID = 0
	
	function SortAllData()
		if VExRT.ExCD2.SortByAvailability then
			local currTime = GetTime()
			local SortByAvailabilityActiveToTop = VExRT.ExCD2.SortByAvailabilityActiveToTop
		  	for i=1,#_C do
		  		local data = _C[i]
				local cd = data.lastUse + data.cd - currTime
				
				local charge = data.charge
				if data.isCharge and charge then
					if charge <= currTime and (charge+data.cd) > currTime then
						cd = -1
					elseif charge > currTime then
						cd = charge - currTime
					end
				end
				
				if data.disabled then
					cd = cd > 0 and cd or 49999
				end
				if cd > 0 then
					cd = cd + 50000
				end
				
				local dur = 0
				if SortByAvailabilityActiveToTop then
					dur = data.lastUse + data.duration - currTime
					if dur < 0 then
						dur = 0
					end
				end
				data.sorting = dur > 0 and dur or cd > 0 and cd or 0
				
				local columnFrame = columnsTable[data.column]
				if columnFrame.methodsNewSpellNewLine then
					data.sorting = (data.sort2 or data.db[1]) * 100000 + data.sorting
				end
		  	end
		  	if not VExRT.ExCD2.ReverseSorting then
		  		sort(_C,sort_b)
		  	else
		  		sort(_C,sort_br)
		  	end
		elseif not VExRT.ExCD2.ReverseSorting then
		  	sort(_C,sort_a)
		else
		  	sort(_C,sort_ar)
		end
	end
	
	local function TalentReplaceOtherCheck(spellID,name)
		local spellData = spell_talentReplaceOther[spellID]
		if type(spellData) == 'number' then
			return session_gGUIDs[name][spellData]
		else
			for i=1,#spellData do
				if session_gGUIDs[name][ spellData[i] ] then
					return true
				end
			end
		end
		return false
	end
	
	function UpdateAllData()
		reviewID = reviewID + 1
		--print('UpdateAllData',GetTime())
		local isTestMode = _db.testMode
		local CDECol = VExRT.ExCD2.CDECol
		local currTime = GetTime()
		for i=1,#_C do
			local data = _C[i]
			local db = data.db
			local name = data.fullName
			local spellID = db[1]
			
			local specID = globalGUIDs[name] or 0
			local unitSpecID = specInDBase[specID] or 3
			
			if isTestMode or (VExRT_CDE[spellID] and 
			(db[unitSpecID] or (not db[unitSpecID] and db[3])) and 
			(not spell_isTalent[spellID] or session_gGUIDs[name][spellID]) and 
			(not spell_isPvpTalent[spellID] or (session_gGUIDs[name][spellID] and IsPvpTalentsOn(name))) and 
			(not spell_isPetAbility[spellID] or session_Pets[name] == spell_isPetAbility[spellID] or (session_Pets[name] and petsAbilities[ session_Pets[name] ] and petsAbilities[ session_Pets[name] ][1] == spell_isPetAbility[spellID])) and
			(not spell_talentReplaceOther[spellID] or not TalentReplaceOtherCheck(spellID,name)) and
			(not data.specialCheck or data.specialCheck(data,currTime))
			) then 
				data.vis = true
				
				local col = 1
				if db[unitSpecID] then
					col = VExRT.ExCD2.CDECol[db[unitSpecID][1]..";"..(unitSpecID-2)] or def_col[db[unitSpecID][1]..";"..(unitSpecID-2)] or 1
				elseif db[3] then
					col = VExRT.ExCD2.CDECol[db[3][1]..";1"] or def_col[db[3][1]..";1"] or 1
				end
				data.column = col
				
				local isCharge = spell_charge_fix[ spellID ]
				if isCharge then
					if session_gGUIDs[data.fullName][isCharge] then
						data.isCharge = true
						isCharge = true
					else
						data.isCharge = nil
						isCharge = nil
					end
				end
				
				local columnFrame = columnsTable[col]
				
				local isOnCD = not isCharge and (data.lastUse + data.cd) > currTime
				
				if columnFrame.optionShownOnCD and not ((isCharge and data.charge and data.charge > currTime) or isOnCD) then
					data.vis = nil
				end
				if columnFrame.methodsHideOwnSpells and data.fullName == playerName then
					data.vis = nil
				end
								
				local whiteList = columnFrame.WhiteList
				if whiteList then
					if not whiteList[data.loweredName] then
						data.vis = nil
					end
				else
					local blackList = columnFrame.BlackList
					if blackList[data.loweredName] or (blackList[spellID] and blackList[spellID][data.loweredName]) then
						data.vis = nil
					end
				end
				
				local prevDisabledStatus = data.disabled
				local isDead = status_UnitIsDead[ name ]
				local isOffline = status_UnitIsDisconnected[ name ]
				if isDead or isOffline then
					data.disabled = isOffline and 2 or 1
				else
					data.disabled = nil
				end
				
				local prevOutOfRange = data.outofrange
				if status_UnitIsOutOfRange[ name ] then
					data.outofrange = true
				else
					data.outofrange = nil
				end
				
				if columnFrame.methodsOneSpellPerCol and data.vis then
					local oneSpellPerColCurr = oneSpellPerCol[col][spellID]
					if not oneSpellPerColCurr then
						oneSpellPerColCurr = {}
						oneSpellPerCol[col][spellID] = oneSpellPerColCurr
					end
					local isOnCD = isOnCD or data.disabled
					if oneSpellPerColCurr[1] ~= reviewID then
						oneSpellPerColCurr[1] = reviewID
						oneSpellPerColCurr[2] = data
						oneSpellPerColCurr[3] = isOnCD
					elseif oneSpellPerColCurr[3] and not isOnCD then
						oneSpellPerColCurr[2].vis = nil
						oneSpellPerColCurr[1] = reviewID
						oneSpellPerColCurr[2] = data
						oneSpellPerColCurr[3] = isOnCD
					elseif data.disabled then
						data.vis = nil
					elseif oneSpellPerColCurr[3] and isOnCD then
						local prevData = oneSpellPerColCurr[2]
						if (prevData.lastUse + prevData.cd) > (data.lastUse + data.cd) then
							prevData.vis = nil
							oneSpellPerColCurr[1] = reviewID
							oneSpellPerColCurr[2] = data
							oneSpellPerColCurr[3] = isOnCD
						else
							data.vis = nil
						end
					else
						data.vis = nil
					end
				end
				
				local bar = data.bar
				if bar and bar.data == data and (data.disabled ~= prevDisabledStatus or data.outofrange ~= prevOutOfRange) then
					data.bar:UpdateStatus()
				end

			else
				data.vis = nil
			end
		end
	end
	
	local statusTimer1,statusTimer2 = 0,0
	
	function module:timer(elapsed)
		local forceUpdateAllData,forceSortAllData = false,false

		if not _db.isEncounter and IsEncounterInProgress() then
			_db.isEncounter = true
			local _,_,difficulty = GetInstanceInfo()
			if difficulty == 14 or difficulty == 15 or difficulty == 16 or difficulty == 17 or difficulty == 7 then
				_db.isResurectDisabled = true
			end
			module:toggleCombatVisibility(true,1)
		elseif _db.isEncounter and not IsEncounterInProgress() then
			_db.isEncounter = nil
			_db.isResurectDisabled = nil
			if GetDifficultyForCooldownReset() and not module.db.disableCDresetting then
				AfterCombatResetFunction()
				forceUpdateAllData = true
				forceSortAllData = true
			end
			module:toggleCombatVisibility(false,1)
		end
		
		
		---------> Check status
		statusTimer2 = statusTimer2 + elapsed
		if statusTimer2 > 0.25 then
			statusTimer2 = 0
			statusTimer1 = statusTimer1 + 1
			local doOtherChecks = statusTimer1 > 1
			for i=1,#status_UnitsToCheck do
				local unit = status_UnitsToCheck[i]
				local inRange,isRange = UnitInRange(unit)
				local outOfRange = isRange and not inRange
				if status_UnitIsOutOfRange[ unit ] ~= outOfRange then
					forceUpdateAllData = true
				end
				status_UnitIsOutOfRange[ unit ] = outOfRange
				if doOtherChecks then
					local isDead = UnitIsDeadOrGhost(unit)
					if isDead ~= status_UnitIsDead[ unit ] then
						forceUpdateAllData = true
						forceSortAllData = true
					end
					status_UnitIsDead[ unit ] = isDead
					
					local isOffline = not UnitIsConnected(unit)
					if isOffline ~= status_UnitIsDisconnected[ unit ] then
						forceUpdateAllData = true
						forceSortAllData = true
					end
					status_UnitIsDisconnected[ unit ] = not UnitIsConnected(unit)
				end
			end
			if doOtherChecks then
				statusTimer1 = 0
				
				local charges,_,started,duration = GetSpellCharges(20484)
				if charges ~= lastBattleResChargesStatus then
					local charge = nil
					if charges then
						if charges > 0 then
							charge = started
							started = 0
						end
					else
						started = 0
						duration = 0
						charge = nil
					end
					for i=1,#_C do
						local data = _C[i]
						if module.db.spell_battleRes[ data.db[1] ] then
							data.lastUse = started
							data.cd = duration
							data.charge = charge

							local bar = data.bar
							if bar and bar.data == data then
								bar:UpdateStatus()
							end
						end
					end
					forceUpdateAllData = true
					forceSortAllData = true
					
					if charges and lastBattleResChargesStatus and charges < lastBattleResChargesStatus then		--Add resurrect to history
						module.db.historyUsage[#module.db.historyUsage + 1] = {time(),20484,"*",GetEncounterTime()}
					end
				end
				lastBattleResChargesStatus = charges
			end
		end
		if forceUpdateAllData then
			UpdateAllData()
		end
		if forceSortAllData then
			SortAllData()
		end
				
		for i=1,maxColumns do 
			inColsCount[i] = 0 
			columnsTable[i].lastSpell = nil
		end
		for i=1,#_C do
			local data = _C[i]
			if data.vis then
				local col = data.column
				local numberInCol = inColsCount[col] + 1
				local spellID = data.db[1]
				
				local barParent = columnsTable[col]
				
				if numberInCol <= barParent.optionLinesMax then
					if barParent.methodsNewSpellNewLine and barParent.lastSpell ~= spellID then
						local fix = 0
						for j=numberInCol,maxLinesInCol do
							local bar_now = barParent.lines[numberInCol + fix]
							if bar_now then
								if bar_now.IsNewLine then
									break
								else
									if bar_now.data then
										bar_now.data = nil
										bar_now:Update()
									end
									fix = fix + 1
								end
							end
						end
						numberInCol = numberInCol + fix
					end
					if barParent.optionIconTitles and barParent.lastSpell ~= spellID then
						local bar = barParent.lines[numberInCol]
						if bar and (bar.data ~= data or not bar.isTitle) then
							bar.data = data
							bar:CreateTitle()
						end
						numberInCol = numberInCol + 1
					end
					if barParent.methodsNewSpellNewLine and barParent.optionIconTitles and barParent.frameColumns > 1 and barParent.lastSpell == spellID then
						local bar_now = barParent.lines[numberInCol]
						if bar_now and bar_now.IsNewLine then
							if bar_now.data then
								bar_now.data = nil
								bar_now:Update()
							end
							numberInCol = numberInCol + 1
						end
					end
	
					barParent.lastSpell = spellID
					
					inColsCount[col] = numberInCol
					local bar = barParent.lines[numberInCol]
					if bar and bar.data ~= data then
						bar.data = data
						
						data.bar = bar
					
						bar:Update()
						bar:UpdateStatus()
					end
				end
			end
		end
		
		for i=1,maxColumns do
			local col = columnsTable[i]
			if col.IsColumnEnabled then
				local y = col.optionLinesMax
				if inColsCount[i] > y then
					inColsCount[i] = y
				end
				local start = inColsCount[i]
				for j=start+1,col.NumberLastLinesActive do
					local bar = col.lines[j]
					if bar and bar.data then
						bar.data = nil
						bar:Update()
					end
				end
				col.NumberLastLinesActive = start
			end
		end
		
		saveDataTimer = saveDataTimer + elapsed
		if saveDataTimer > 2 then
			saveDataTimer = 0
			SaveCDtoVar()
		end
	end
end

local function GetNumGroupMembersFix() 
	local n = GetNumGroupMembers() or 0
	if module.db.testMode then
		return 20
	elseif n == 0 and VExRT.ExCD2.NoRaid then 
		return 1
	else
		return n
	end
end

local function GetRaidRosterInfoFix(j) 
	local name, rank, subgroup, level, class, classFileName, zone, online, isDead, role, isML = GetRaidRosterInfo(j)
	if j == 1 and not name and VExRT.ExCD2.NoRaid then
		name = UnitName("player")
		class,classFileName = UnitClass("player")
		local _,race = UnitRace("player")
		level = UnitLevel("player")
		isDead = UnitIsDeadOrGhost("player")
		return name,1,classFileName,level,race,true,isDead
	elseif not module.db.testMode then
		local _,race = UnitRace(name or "?")
		return name,subgroup,classFileName,level,race,online,isDead
	elseif module.db.testMode then
		if name then
			local _,race = UnitRace(name)
			return name,subgroup,classFileName,level,race,online,isDead
		end
		local i = math.random(1,11)

		local namesList = {}
		for unitName, specID in pairs(VExRT.ExCD2.gnGUIDs) do
			namesList[#namesList+1] = {unitName}
			for className, classSpecs in pairs(module.db.specByClass) do
				if ExRT.F.table_find(module.db.classNames,className) then	--prevent error at version without DH class
					for spec_i=1,#classSpecs do
						if classSpecs[spec_i] == specID then
							namesList[#namesList][2] = className
						end
					end
				end
			end
		end
		if #namesList == 0 or #namesList < 25 then
			name = L.classLocalizate[module.db.classNames[i]]..tostring(j)
			classFileName = module.db.classNames[i]
		else
			i = math.random(1,#namesList)
			name = namesList[i][1]
			classFileName = namesList[i][2]
		end

		return name,1,classFileName,100,nil,true,false
	end
end

function RaidResurrectSpecialCheck()
	local _,_,difficulty = GetInstanceInfo()
	if difficulty == 14 or difficulty == 15 or difficulty == 16 or difficulty == 7 or difficulty == 17 or difficulty == 8 then
		return true
	end
end
function RaidResurrectSpecialText()
	local charges, maxCharges, started, duration = GetSpellCharges(20484)
	if (charges or 0) > 1 then
		return " ("..charges..")"
	end
end
function RaidResurrectSpecialStatus()
	local charges, maxCharges, started, duration = GetSpellCharges(20484)
	if charges then
		if charges > 0 then
			return false,started,duration,true
		else
			return true,started,duration,false
		end
	end
end

local function UpdateRoster()
	wipe(status_UnitsToCheck)
	wipe(status_UnitIsDead)
	wipe(status_UnitIsDisconnected)
	wipe(status_UnitIsOutOfRange)

	local n = GetNumGroupMembersFix()
	if n > 0 then
		local priorCounter = 0
		local priorNamesToNumber = {}
		if not module.db.testMode then
			for j=1,n do
				local name = GetRaidRosterInfoFix(j)
				if name then
					priorNamesToNumber[#priorNamesToNumber + 1] = name
				end
			end
			sort(priorNamesToNumber)
		end
		
		local classColorsTable = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
		
		for i=1,#_C do _C[i].sort = nil end
		local gMax = GetRaidDiffMaxGroup()
		local isInRaid = IsInRaid()
		for j=1,n do
			local name,subgroup,class,level,race,online,isDead = GetRaidRosterInfoFix(j)
			if name and subgroup <= gMax then
				for i,spellData in ipairs(module.db.spellDB) do
					local SpellID = spellData[1]
					local AddThisSpell = true
					if level < 100 then
						local spellLevel = GetSpellLevelLearned(SpellID)
						if level < (spellLevel or 0) then
							AddThisSpell = false
						end
					end
					if module.db.spell_isRacial[ SpellID ] and race ~= module.db.spell_isRacial[ SpellID ] then
						AddThisSpell = false	
					end
					if not GetSpellInfo(SpellID) then	--non exist, removed spells
						AddThisSpell = false
					end
					if AddThisSpell and (spellData[2] == class or spellData[2] == "ALL") then
						if not ExRT.F.table_find(status_UnitsToCheck,name) then
							status_UnitsToCheck[#status_UnitsToCheck + 1] = name
							
							status_UnitIsDead[ name ] = isDead
							status_UnitIsDisconnected[ name ] = not online
							
							local inRange,isRange = UnitInRange(name)
							status_UnitIsOutOfRange[ name ] = isRange and not inRange
						end 
						--if SpellID == 1719 then
						module:AddCLEUSpellDamage(SpellID)
						--end
					
						local alreadyInCds = nil
						priorCounter = priorCounter + 1
						
						local spellColumn = 1
						local _specID = globalGUIDs[name] or 0
						local uSpecID = _db.specInDBase[_specID] or 3
						if spellData[uSpecID] then
							spellColumn = VExRT.ExCD2.CDECol[spellData[uSpecID][1]..";"..(uSpecID-2)] or _db.def_col[spellData[uSpecID][1]..";"..(uSpecID-2)] or 1
						elseif spellData[3] then
							spellColumn = VExRT.ExCD2.CDECol[spellData[3][1]..";1"] or _db.def_col[spellData[3][1]..";1"] or 1
						end
						local getSpellColumn = _mainFrame.colFrame[spellColumn]
						local prior = nil
						--[[
							1: 00AABBBBBBCCDDDD
							2: 00AACCBBBBBBDDDD
							3: AAEEBBBBBBCCDDDD
							4: AAEECCBBBBBBDDDD
							5: 00CCAABBBBBBDDDD
							6: EEAACCBBBBBBDDDD
							
							A - priority
							B - spell ID
							C - name
							D - priority counter
							E - classID
						]]
						if not getSpellColumn or getSpellColumn.methodsSortingRules == 1 then
							prior = (VExRT.ExCD2.Priority[SpellID] or 15) * 1000000000000 + (SpellID or 0) * 1000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 2 then
							prior = (VExRT.ExCD2.Priority[SpellID] or 15) * 1000000000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000000000 + (SpellID or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 3 then
							prior = (VExRT.ExCD2.Priority[SpellID] or 15) * 100000000000000 + (ExRT.F.table_find(module.db.classNames,class) or 0) * 1000000000000 + (SpellID or 0) * 1000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 4 then
							prior = (VExRT.ExCD2.Priority[SpellID] or 15) * 100000000000000 + (ExRT.F.table_find(module.db.classNames,class) or 0) * 1000000000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000000000 + (SpellID or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 5 then
							prior = (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 1000000000000 + (VExRT.ExCD2.Priority[SpellID] or 15) * 10000000000 + (SpellID or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 6 then
							prior = (ExRT.F.table_find(module.db.classNames,class) or 0) * 100000000000000 + (VExRT.ExCD2.Priority[SpellID] or 15) * 1000000000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000000000 + (SpellID or 0) * 10000 + priorCounter
						end
						local secondPrior = (VExRT.ExCD2.Priority[SpellID] or 15) * 1000000 + (SpellID or 0)	--used in columns with option 'new spell - new line'
						
						local sName = format("%s%d",name or "?",SpellID or 0)
						local lastUse,nowCd = 0,0
						if VExRT.ExCD2.Save[sName] and NumberInRange(VExRT.ExCD2.Save[sName][1] + VExRT.ExCD2.Save[sName][2] - GetTime(),0,2000,false,true) then
							lastUse,nowCd = VExRT.ExCD2.Save[sName][1],VExRT.ExCD2.Save[sName][2]
						end
						
						local spellName,_,spellTexture = GetSpellInfo(SpellID)
						spellTexture = spellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK"
						spellName = spellName or "unk"
						local shownName = DelUnitNameServer(name)
						
						if module.db.differentIcons[SpellID] then
							spellTexture = module.db.differentIcons[SpellID]
						end
						
						for l=3,7 do
							if spellData[l] then
								local h = ExRT.isClassic and module.db.cdsNav[name][GetSpellInfo(spellData[l][1])] or module.db.cdsNav[name][spellData[l][1]]
								if h then
									h.db = spellData
									if lastUse ~= 0 and nowCd ~= 0 and h.lastUse == 0 and h.cd == 0 then
										h.cd = nowCd
										h.lastUse = lastUse
									end
									h.sort = prior
									h.sort2 = secondPrior
									h.spellName = spellName
									h.icon = spellTexture
									h.column = spellColumn
									
									alreadyInCds = true
								end
							end
						end

						if not alreadyInCds then
							_C [#_C + 1] = {
								name = shownName,
								fullName = name,
								loweredName = shownName:lower(),
								icon = spellTexture,
								spellName = spellName,
								db = spellData,
								lastUse = lastUse,
								cd = nowCd,
								duration = 0,
								classColor = classColorsTable[class] or module.db.notAClass,
								sort = prior,
								sort2 = secondPrior,
								column = spellColumn,
							}
						end
					end
				end
				module.db.session_gGUIDs[name] = 1
				if isInRaid then
					module.main:UNIT_PET("raid"..j)
				end
			end
		end
		
		--WOD Raid resurrect
		if not ExRT.isClassic then
			local findResSpell = ExRT.F.table_find(module.db.spellDB,161642,1)
			if findResSpell then
				local spellData = module.db.spellDB[findResSpell]
				local h = module.db.cdsNav["*"][spellData[3][1]]
				local prior = 0
				
				priorCounter = priorCounter + 1
				
				local spellColumn = VExRT.ExCD2.CDECol["161642;1"] or _db.def_col["161642;1"] or 1
				local getSpellColumn = _mainFrame.colFrame[spellColumn]
				if not getSpellColumn or getSpellColumn.methodsSortingRules == 1 then
					prior = (VExRT.ExCD2.Priority[161642] or 15) * 1000000000000 + 161642 * 1000000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 2 then
					prior = (VExRT.ExCD2.Priority[161642] or 15) * 1000000000000 + 161642 * 10000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 3 then
					prior = (VExRT.ExCD2.Priority[161642] or 15) * 100000000000000 + 161642 * 1000000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 4 then
					prior = (VExRT.ExCD2.Priority[161642] or 15) * 100000000000000 + 161642 * 10000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 5 then
					prior = (VExRT.ExCD2.Priority[161642] or 15) * 10000000000 + 161642 * 10000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 6 then
					prior = (VExRT.ExCD2.Priority[161642] or 15) * 1000000000000 + 161642 * 10000 + priorCounter
				end
				local secondPrior = (VExRT.ExCD2.Priority[161642] or 15) * 1000000 + (161642 or 0)
				
				if not h then
					local spellName,_,spellTexture = GetSpellInfo(spellData[1])
					_C [#_C + 1] = {
						name = L.cd2Resurrect,
						fullName = "*",
						loweredName = "*",
						icon = spellTexture,
						spellName = spellName or "unk",
						db = spellData,
						lastUse = 0,
						cd = 0,
						duration = 0,
						classColor = module.db.notAClass,
						sort = prior,
						sort2 = secondPrior,
						column = spellColumn,
						specialCheck = RaidResurrectSpecialCheck,
						specialAddText = RaidResurrectSpecialText,
						specialStatus = RaidResurrectSpecialStatus,
					}
				else
					h.sort = prior
					h.sort2 = secondPrior
					h.column = spellColumn
				end
				module.db.session_gGUIDs["*"] = 1
			end
		end
		
		cdsNav_wipe()

		local pluginFunc = module.db.plugin and type(module.db.plugin.UpdateRoster)=="function" and module.db.plugin.UpdateRoster

		local j = 0
		for i=1,#_C do
			j = j + 1
			local line = _C[j]
			if not line then
				break
			elseif not line.sort then
				tremove(_C,j)
				j = j - 1
			else
				for l=3,7 do 
					if line.db[l] then
						cdsNav_set(line.fullName,line.db[l][1],line)
					end 
				end
				if pluginFunc then
					pluginFunc(line)
				end
			end
		end
	else
		wipe(_C)
		cdsNav_wipe()
	end
	if module.db.testMode then 
		TestMode() 
		
		local offline = status_UnitsToCheck[fastrandom(1,#status_UnitsToCheck)]
		local dead = status_UnitsToCheck[fastrandom(1,#status_UnitsToCheck)]
		
		status_UnitIsDead[dead] = true
		status_UnitIsDisconnected[offline] = true
		
		for j=#status_UnitsToCheck,1,-1 do
			if not UnitName(status_UnitsToCheck[j]) then
				tremove(status_UnitsToCheck, j)
			end
		end
	end
	UpdateAllData()
	SortAllData()
end

do
	local function DispellSchedule(data)
		if not module.db.spell_dispellsFix[ data.fullName ] then
			data.cd = 0
			local bar = data.bar
			if bar and bar.data == data then
				data.bar:UpdateStatus()
			end
			UpdateAllData()
			SortAllData()
		end
		module.db.spell_dispellsFix[ data.fullName ] = nil
	end
	local function IsAuraActive(unit,spellID)
		for i=1,40 do
			local name,_,_,_,_,_,_,_,_,auraSpellID = UnitAura(unit,i)
			if spellID == auraSpellID then
				return true
			elseif not name then
				return
			end
		end
	end
	function CLEUstartCD(i)
		local currTime = GetTime()
		local data = nil
		if type(i) == "table" then
			data = i
		else
			data = _C[i]
		end
		local fullName = data.fullName
		
		local uSpecID = module.db.specInDBase[globalGUIDs[fullName] or 0]
		if not data.db[uSpecID] and not data.db[3] then
			return
		elseif not data.db[uSpecID] then
			uSpecID = 3
		end
		local spellID = data.db[uSpecID][1]
		--WOD Battle Res
		do
			if _db.spell_battleRes[spellID] and _db.isResurectDisabled then
				return
			end
		end
		
		data.cd = data.db[uSpecID][2]
		data.duration = data.db[uSpecID][3]
		
		--Talents / Glyphs
		local durationTable = module.db.spell_durationByTalent_fix[spellID]
		if durationTable then
			for j=1,#durationTable,2 do
				local talentSpellID = durationTable[j]
				if module.db.session_gGUIDs[fullName][talentSpellID] and (not module.db.spell_isPvpTalent[talentSpellID] or module.IsPvpTalentsOn(fullName)) then
					local timeReduce = durationTable[j+1]
					if type(timeReduce) == 'table' then
						--artifact power old
					elseif tonumber(timeReduce) then
						data.duration = data.duration + timeReduce
					else
						local timeFix = tonumber( string.sub( timeReduce, 2 ) )
						data.duration = data.duration * timeFix
					end
				end
			end
		end
		local cdTable = module.db.spell_cdByTalent_fix[spellID]
		if cdTable then
			for j=1,#cdTable,2 do
				local talentSpellID = cdTable[j]
				if module.db.session_gGUIDs[fullName][talentSpellID] and (not module.db.spell_isPvpTalent[talentSpellID] or module.IsPvpTalentsOn(fullName)) then
					local timeReduce
					if module.db.spell_cdByTalent_isScalable[talentSpellID] then
						local scale_data = module.db.spell_cdByTalent_scalable_data[talentSpellID]
						timeReduce = scale_data[fullName] or scale_data[1]
					else
						timeReduce = cdTable[j+1]
						if type(timeReduce) == 'table' then
							if IsAuraActive(fullName,timeReduce[2]) then
								timeReduce = timeReduce[1]
							else
								timeReduce = 0
							end
						end
					end
					if tonumber(timeReduce) then
						data.cd = data.cd + timeReduce
					else
						local timeFix = tonumber( string.sub( timeReduce, 2 ) )
						data.cd = data.cd * timeFix
					end
				end
			end
		end
		--Charges
		local isCharge = module.db.spell_charge_fix[ data.db[1] ]
		if isCharge and (data.lastUse+data.cd) >= currTime then
			data.charge = (data.charge or data.lastUse) + data.cd
			data.lastUse = currTime
			module.db.session_gGUIDs[fullName] = isCharge
		elseif isCharge and module.db.session_gGUIDs[fullName][isCharge] then
			data.charge = currTime
			data.lastUse = currTime
		else
			data.lastUse = currTime
		end
		--Haste/Readiness
		if module.db.spell_speed_list[spellID] then
			data.duration = data.duration / (1 + (UnitSpellHaste(fullName) or 0) /100)
		end
		if module.db.spell_reduceCdByHaste[spellID] then
			data.cd = data.cd / (1 + (UnitSpellHaste(fullName) or 0) /100) 
		end
		--Dispels
		if module.db.spell_dispellsList[spellID] then
			ScheduleTimer(DispellSchedule, 0.5, data)
		end
		-- Fixes
		if data.cd > 45000 then data.cd = 45000 end
		if data.duration > 45000 then data.duration = 45000 end
		
		if data.bar and data.bar.data == data then
			data.bar:UpdateStatus()
		end
		
		UpdateAllData()
		SortAllData()
		
		module.db.historyUsage[#module.db.historyUsage + 1] = {time(),data.db[uSpecID][1],fullName,GetEncounterTime()}
	end
end

function module:Enable()
	VExRT.ExCD2.enabled = true
	if not VExRT.ExCD2.SplitOpt then 
		module.frame:Show()
		module:ReloadAllSplits()
	else
		module:ReloadAllSplits()
	end
	
	module.frame.IsEnabled = true

	module:RegisterSlash()
	module:RegisterTimer()
	module:RegisterEvents('SCENARIO_UPDATE','GROUP_ROSTER_UPDATE','COMBAT_LOG_EVENT_UNFILTERED','UNIT_PET','PLAYER_LOGOUT','ZONE_CHANGED_NEW_AREA','CHALLENGE_MODE_RESET','PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END')

	UpdateRoster()
end

function module:Disable()
	VExRT.ExCD2.enabled = nil
	if not VExRT.ExCD2.SplitOpt then 
		module.frame:Hide()
	else
		for i=1,module.db.maxColumns do 
			module.frame.colFrame[i]:Hide()
		end 
	end
	
	module.frame.IsEnabled = false
	
	module:UnregisterSlash()
	module:UnregisterTimer()
	module:UnregisterEvents('SCENARIO_UPDATE','GROUP_ROSTER_UPDATE','COMBAT_LOG_EVENT_UNFILTERED','UNIT_PET','PLAYER_LOGOUT','ZONE_CHANGED_NEW_AREA','CHALLENGE_MODE_RESET','PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END')
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.ExCD2 = VExRT.ExCD2 or {NoRaid = true}
	
	if VExRT.Addon.Version < 2126 then
		if VExRT.ExCD2.colSet then
			for i=1,module.db.maxColumns+1 do
				if VExRT.ExCD2.colSet[i] and not VExRT.ExCD2.colSet[i].fontOutline then
					VExRT.ExCD2.colSet[i].fontShadow = true
				end
			end
		end
	end
	if VExRT.Addon.Version < 2302 then
		if VExRT.ExCD2.colSet then
			for i=1,module.db.maxColumns+1 do
				if VExRT.ExCD2.colSet[i] then
					VExRT.ExCD2.colSet[i].textGeneral = true
				end
			end
		end
	end
	if VExRT.Addon.Version < 3247 then
		if VExRT.ExCD2.colSet then
			for i=1,module.db.maxColumns+1 do
				if VExRT.ExCD2.colSet[i] then
					VExRT.ExCD2.colSet[i].blacklistGeneral = true
				end
			end
		end
	end
	if VExRT.Addon.Version < 3755 then
		if VExRT.ExCD2.colSet then
			for i=1,module.db.maxColumns+1 do
				if VExRT.ExCD2.colSet[i] then
					VExRT.ExCD2.colSet[i].visibilityGeneral = true
				end
			end
		end
	end	
	
	if VExRT.ExCD2.Left and VExRT.ExCD2.Top then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.ExCD2.Left,VExRT.ExCD2.Top)
	end
	
	VExRT.ExCD2.CDE = VExRT.ExCD2.CDE or {}
	VExRT.ExCD2.CDECol = VExRT.ExCD2.CDECol or {}
	if UnitFactionGroup("player") == "Alliance" then	--> BL Faction Fix
		for i,spellData in ipairs(module.db.spellDB) do
			if spellData[1] == 2825 then
				spellData[1] = 32182
				spellData[3][1] = 32182
				break
			end
		end
	end
	VExRT_CDE = VExRT.ExCD2.CDE
	
	if not VExRT.ExCD2.colSet then
		VExRT.ExCD2.colSet = {}
		for i=1,module.db.maxColumns+1 do
			VExRT.ExCD2.colSet[i] = {}
			for optName,optVal in pairs(module.db.colsInit) do
				VExRT.ExCD2.colSet[i][optName] = optVal
			end
			if i <= 3 then 
				VExRT.ExCD2.colSet[i].enabled = true
			end
		end
	end
	for i=1,module.db.maxColumns+1 do
		VExRT.ExCD2.colSet[i] = VExRT.ExCD2.colSet[i] or {}
	end
	
	VExRT.ExCD2.default_userCD = VExRT.ExCD2.default_userCD or {}
	VExRT.ExCD2.default_userDuration = VExRT.ExCD2.default_userDuration or {}
	do
		for spellID,spellData in pairs(VExRT.ExCD2.default_userCD) do
			for i=1,#module.db.spellDB do
				if module.db.spellDB[i][1] == spellID then
					for j=1,5 do
						if spellData[j] and module.db.spellDB[i][2+j] then
							if spellData[j] == module.db.spellDB[i][2+j][2] then
								spellData[j] = nil
							else
								module.db.spellDB[i][2+j][2] = spellData[j]
							end
						end
					end
				end
			end
		end
	
		for spellID,spellData in pairs(VExRT.ExCD2.default_userDuration) do
			for i=1,#module.db.spellDB do
				if module.db.spellDB[i][1] == spellID then
					for j=1,5 do
						if spellData[j] and module.db.spellDB[i][2+j] then
							if spellData[j] == module.db.spellDB[i][2+j][3] then
								spellData[j] = nil
							else
								module.db.spellDB[i][2+j][3] = spellData[j]
							end
						end
					end
				end
			end
		end
	end
	
	VExRT.ExCD2.userDB = VExRT.ExCD2.userDB or {}
	for i=1,#VExRT.ExCD2.userDB do
		module.db.spellDB[i+module.db.dbCountDef] = VExRT.ExCD2.userDB[i]
	end

	VExRT.ExCD2.Priority = VExRT.ExCD2.Priority or {}

	VExRT.ExCD2.gnGUIDs = VExRT.ExCD2.gnGUIDs or {}
	if VExRT.ExCD2.gnGUIDs and ExRT.F.table_len(VExRT.ExCD2.gnGUIDs) > 500 then
		wipe(VExRT.ExCD2.gnGUIDs)
	end
	globalGUIDs = VExRT.ExCD2.gnGUIDs

	if VExRT.ExCD2.lock then
		module.frame.texture:SetColorTexture(0, 0, 0, 0)
		module.frame:EnableMouse(false)
		ExRT.lib.AddShadowComment(module.frame,1)
	else
		module.frame.texture:SetColorTexture(0, 0, 0, 0.3)
		module.frame:EnableMouse(true)
		ExRT.lib.AddShadowComment(module.frame,nil,L.cd2)
	end
	
	module:SplitExCD2Window() 
	--module:ReloadAllSplits()
	
	VExRT.ExCD2.Save = VExRT.ExCD2.Save or {}

	if not VExRT.ExCD2.enabled then
		if not VExRT.ExCD2.SplitOpt then 
			module.frame:Hide() 
		else
			for i=1,module.db.maxColumns do 
				module.frame.colFrame[i]:Hide() 
			end 
		end
	else
		module:Enable()
		ScheduleTimer(UpdateRoster,10)
		ScheduleTimer(module.ReloadAllSplits,10)
		module:RegisterEvents('PLAYER_ENTERING_WORLD')
	end
	
	module.db.playerName = ExRT.SDB.charName
end

function module.main:PLAYER_ENTERING_WORLD()
	UpdateRoster()
	
	module:UnregisterEvents('PLAYER_ENTERING_WORLD')
end

function module.main:PLAYER_LOGOUT()
	SaveCDtoVar(true)
end

function module.main:SCENARIO_UPDATE()
	AfterCombatResetFunction()
	UpdateAllData()
	SortAllData()
end
module.main.CHALLENGE_MODE_RESET = module.main.SCENARIO_UPDATE

function module.main:PLAYER_REGEN_DISABLED()
	module:toggleCombatVisibility(true,2)
end
function module.main:PLAYER_REGEN_ENABLED()
	module:toggleCombatVisibility(false,2)
end


do
	local scheduledUpdateRoster = nil
	local function funcScheduledUpdate()
		scheduledUpdateRoster = nil
		UpdateRoster()
		module:updateCombatVisibility()
	end
	function module.main:GROUP_ROSTER_UPDATE()
		if not scheduledUpdateRoster then
			scheduledUpdateRoster = ScheduleTimer(funcScheduledUpdate,2)
		end
	end
end

do
	local scheduledUpdateRoster = nil
	local function funcScheduledUpdate()
		scheduledUpdateRoster = nil
		UpdateRoster()
	end
	
	local scheduledVisibility = nil
	local function funcScheduledVisibility()
		scheduledVisibility = nil
		module:updateCombatVisibility()
	end
	
	function module.main:ZONE_CHANGED_NEW_AREA()
		if select(2, IsInInstance()) == "arena" then
			AfterCombatResetFunction(true)
			UpdateAllData()
			SortAllData()
		end
		if not scheduledUpdateRoster then
			scheduledVisibility = ScheduleTimer(funcScheduledVisibility,2)
		end		
		if not scheduledUpdateRoster then
			scheduledUpdateRoster = ScheduleTimer(funcScheduledUpdate,10)
		end
	end
end

function module.main:UNIT_PET(arg)
	local name = UnitCombatlogname(arg)
	if name then
		local forceUpdateAllData = nil
		local petNow = UnitCreatureFamily(arg.."pet")
		if petNow ~= _db.session_Pets[name] then
			_db.session_Pets[name] = UnitCreatureFamily(arg.."pet")
			forceUpdateAllData = true
		end
		if _db.session_Pets[name] then
			_db.session_PetOwner[UnitGUID(arg.."pet")] = name
		end
		if forceUpdateAllData then
			UpdateAllData()
		end
	end
end

function module.main:ENCOUNTER_START(encounterID, encounterName, difficultyID, groupSize)
	if encounterID == 1866 then
		module.db.disableCDresetting = true
	end
end
function module.main:ENCOUNTER_END(encounterID, encounterName, difficultyID, groupSize, success)
	if encounterID == 1866 then
		module.db.disableCDresetting = nil
	end	
end


do
	local eventsView = nil
	--upvaules
	local spell_startCDbyAuraApplied = _db.spell_startCDbyAuraApplied
	local spell_reduceCdByAuraFade = _db.spell_reduceCdByAuraFade
	local spell_aura_list = _db.spell_aura_list
	local spell_startCDbyAuraFade = _db.spell_startCDbyAuraFade
	local spell_startCDbyAuraApplied_fix = _db.spell_startCDbyAuraApplied_fix
	local spell_isPetAbility = _db.spell_isPetAbility
	local spell_isTalent = _db.spell_isTalent
	local spell_resetOtherSpells = _db.spell_resetOtherSpells
	local spell_sharingCD = _db.spell_sharingCD
	local spell_reduceCdCast = _db.spell_reduceCdCast
	local spell_increaseDurationCast = _db.spell_increaseDurationCast
	local spell_runningSameSpell = _db.spell_runningSameSpell
	local spell_dispellsList = _db.spell_dispellsList
	
	local findspecspells = _db.findspecspells

	local session_gGUIDs = _db.session_gGUIDs
	local session_PetOwner = _db.session_PetOwner
	local CDList = _db.cdsNav
	
	local CapacitorMain = {}	--For shamans talent
	local spell265046_var = nil
	
	local function IsAuraActive(unit,spellID)
		for i=1,40 do
			local name,_,_,_,_,_,_,_,_,auraSpellID = UnitAura(unit,i)
			if spellID == auraSpellID then
				return true
			elseif not name then
				return
			end
		end
	end	
	
	function module.main:COMBAT_LOG_EVENT_UNFILTERED()
		--dtime()
		local _,event,_,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,_,_,missType,overhealing,_,_,_,_,critical = CombatLogGetCurrentEventInfo()

		local func = eventsView[event]
		if func then
			func(self,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,critical,missType,overhealing)
		end
		--dtime(ExRT.Debug,'ExCD2',event)
	end
	if ExRT.isClassic then
		function module.main:COMBAT_LOG_EVENT_UNFILTERED()
			--dtime()
			local _,event,_,sourceGUID,sourceName,sourceFlags,_,destGUID,destName,destFlags,_,spellID,spellName,_,missType,overhealing,_,_,_,_,critical = CombatLogGetCurrentEventInfo()
	
			local func = eventsView[event]
			if func then
				func(self,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellName,critical,missType,overhealing)
			end
			--dtime(ExRT.Debug,'ExCD2',event)
		end
	end

	function module.main:SPELL_AURA_APPLIED(sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID)
		if sourceName then
			local CDspellID = spell_startCDbyAuraApplied[spellID]
			if CDspellID then
				local line = CDList[sourceName][CDspellID]
				if line then
					CLEUstartCD(line)
				end
			end
 			
			if spellID == 118905 and sourceGUID and CapacitorMain[sourceGUID] then
				sourceName = CapacitorMain[sourceGUID]
				local line = CDList[sourceName][192058]
				if line and session_gGUIDs[sourceName][265046] then
					spell265046_var = spell265046_var or {0,0}
					local t = GetTime()
					if spell265046_var[1] < t then
						spell265046_var[1] = t + 1
						spell265046_var[2] = 0
					end
					spell265046_var[2] = spell265046_var[2] + 1
					
					line.cd = line.cd - (spell265046_var[2] <= 4 and 5 or 0)
					if line.cd < 0 then 
						line.cd = 0 
					end
					if line.bar and line.bar.data == line then
						line.bar:UpdateStatus()
					end
					UpdateAllData()
					SortAllData()
				end
			end
		end
	end
	function module.main:SPELL_AURA_REMOVED(sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID)
		if not sourceName then
			return
		end
		local forceSortAllData = false
	
		local modifData = spell_reduceCdByAuraFade[spellID]
		if modifData then
			local CDspellID = modifData[1]
			if type(CDspellID) ~= "table" then
				local line = CDList[sourceName][CDspellID]
				if line and (GetTime() - line.lastUse - line.duration) > -0.5 then
					line.cd = line.cd + modifData[2]
					if line.bar and line.bar.data == line then
						line.bar:UpdateStatus()
					end
					forceSortAllData = true
				end
			else
				if session_gGUIDs[sourceName][ CDspellID[2] ] then
					local line = CDList[sourceName][ CDspellID[1] ]
					if line and (GetTime() - line.lastUse - line.duration) > -0.5 then
						line.cd = line.cd + modifData[2]
						if line.bar and line.bar.data == line then
							line.bar:UpdateStatus()
						end
						forceSortAllData = true
					end
				end
			end
		end
	
		local CDspellID = spell_aura_list[spellID]
		if CDspellID then
			local line = CDList[sourceName][ CDspellID ]
			if line then
				line.duration = 0
				if line.bar and line.bar.data == line then
					line.bar:UpdateStatus()
				end
				forceSortAllData = true
			end
		end
		
		if spell_startCDbyAuraFade[spellID] then
			local line = CDList[sourceName][spellID]
			if line then
				CLEUstartCD(line)
			end
		end
		
		if spellID == 206005 then	--Xavius: Dream Simulacrum
			for i=1,#_C do
				local unitSpellData = _C[i]		
				if unitSpellData.fullName == destName then
					unitSpellData.cd = 0
					unitSpellData.duration = 0
					
					if unitSpellData.bar and unitSpellData.bar.data == unitSpellData then
						unitSpellData.bar:UpdateStatus()
						forceSortAllData = true
					end
				end
			end
			UpdateAllData()
		end
		
		if forceSortAllData then
			SortAllData()
		end
	end
	function module.main:SPELL_CAST_SUCCESS(sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID)
		if not sourceName then
			return
		end
		local forceSortAllData,forceUpdateAllData = nil
	
		if spell_isPetAbility[spellID] then
			sourceName = session_PetOwner[sourceGUID] or sourceName
		end
		
		local findSpecSpell = findspecspells[spellID]
		if findSpecSpell and (GetUnitInfoByUnitFlag(sourceFlags,4) % 8) > 0 then
			if globalGUIDs[sourceName] ~= findSpecSpell then
				forceUpdateAllData = true
			end
			globalGUIDs[sourceName] = findSpecSpell
		end
		
		if spell_startCDbyAuraFade[spellID] or spell_startCDbyAuraApplied_fix[spellID] then
			if forceUpdateAllData then UpdateAllData() end
			return
		end

		local line = CDList[sourceName][spellID]
		if line then
			CLEUstartCD(line)
		end

		if spell_isTalent[spellID] then
			if not session_gGUIDs[sourceName][spellID] then
				forceUpdateAllData = true
			end
			session_gGUIDs[sourceName] = spellID
		end
		
		local modifData = spell_resetOtherSpells[spellID]
		if modifData then
			for i=1,#modifData do
				local resetSpellID = modifData[i]
				if type(resetSpellID)~='table' or session_gGUIDs[sourceName][ resetSpellID[2] ] then
					resetSpellID = type(resetSpellID)=='table' and resetSpellID[1] or resetSpellID
					local line = CDList[sourceName][ resetSpellID ]
					if line then
						line.cd = 0
						if line.bar and line.bar.data == line then
							line.bar:UpdateStatus()
						end
						forceUpdateAllData = true
						forceSortAllData = true
					end
				end
			end
		end
		
		local modifData = spell_sharingCD[spellID]
		if modifData then
			local nowTime = GetTime()
			for sharingSpellID,timeCD in pairs(modifData) do
				local line = CDList[sourceName][sharingSpellID]
				if line then
					local cd_timer_now = line.lastUse + line.cd - nowTime
					if (cd_timer_now > 0 and cd_timer_now < timeCD) or (nowTime - line.lastUse) > line.cd then
						line.cd = timeCD
						line.lastUse = nowTime
						line.duration = 0
						if line.bar and line.bar.data == line then
							line.bar:UpdateStatus()
						end
						forceUpdateAllData = true
						forceSortAllData = true
					end
				end
			end
		end
		
		local modifData = spell_reduceCdCast[spellID]
		if modifData then
			for i=1,#modifData,2 do
				local reduceSpellID = modifData[i]
				if type(reduceSpellID) ~= "table" then
					local line = CDList[sourceName][reduceSpellID]
					if line then
						line.cd = line.cd + modifData[i+1]
						if line.cd < 0 then 
							line.cd = 0 
						end
						if line.bar and line.bar.data == line then
							line.bar:UpdateStatus()
						end
						forceUpdateAllData = true
						forceSortAllData = true
					end
				else
					local specReduceCD = reduceSpellID[3]
					local effectOnlyDuringBuffActive = reduceSpellID[4]
					if session_gGUIDs[sourceName][ reduceSpellID[2] ] and (not specReduceCD or (specReduceCD < 0 and globalGUIDs[sourceName] ~= specReduceCD or globalGUIDs[sourceName] == specReduceCD)) and (not effectOnlyDuringBuffActive or IsAuraActive(sourceName,effectOnlyDuringBuffActive)) then
						local line = CDList[sourceName][ reduceSpellID[1] ]
						if line then
							line.cd = line.cd + modifData[i+1]
							if line.cd < 0 then 
								line.cd = 0 
							end
							if line.bar and line.bar.data == line then
								line.bar:UpdateStatus()
							end
							forceUpdateAllData = true
							forceSortAllData = true
						end
					end
				end
			end
		end
		
		local modifData = spell_increaseDurationCast[spellID]
		if modifData then
			for i=1,#modifData,2 do
				local increaseSpellID = modifData[i]
				if type(increaseSpellID) ~= "table" then
					local line = CDList[sourceName][increaseSpellID]
					if line and (GetTime() - line.lastUse) < line.duration  then
						line.duration = line.duration + modifData[i+1]
						if line.duration < 0 then 
							line.duration = 0 
						end
						if line.bar and line.bar.data == line then
							line.bar:UpdateStatus()
						end
						forceUpdateAllData = true
						forceSortAllData = true
					end
				else
					if session_gGUIDs[sourceName][ increaseSpellID[2] ] then
						local line = CDList[sourceName][ increaseSpellID[1] ]
						if line and (GetTime() - line.lastUse) < line.duration  then
							line.duration = line.duration + modifData[i+1]
							if line.duration < 0 then 
								line.duration = 0 
							end
							if line.bar and line.bar.data == line then
								line.bar:UpdateStatus()
							end
							forceUpdateAllData = true
							forceSortAllData = true
						end
					end
				end
			end
		end
		
		local modifData = spell_runningSameSpell[spellID]
		if modifData then
			for i=1,#modifData do
				local sameSpellID = modifData[i]
				if sameSpellID ~= spellID then
					local line = CDList[sourceName][ sameSpellID ]
					if line then
						CLEUstartCD(line)
					end
				end
			end
		end
		
		if forceUpdateAllData then
			UpdateAllData()
		end
		if forceSortAllData then
			SortAllData()
		end
	end
	function module.main:SPELL_DISPEL(sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID)
		if spell_dispellsList[spellID] and sourceName then
			_db.spell_dispellsFix[ sourceName ] = true
		end
	end
		
	function module.main:SPELL_SUMMON(sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID)
		if sourceName and spellID == 192058 then
			CapacitorMain[destGUID] = sourceName
		end 
	end
	
	local spellDamage_trackedSpells = {
		[46968] = true,
		[49143] = true,
		[49020] = true,
		[11366] = true,
		[133] = true,
		[108853] = true,
		[257541] = true,
	}
	local spellDamage_trackedSpells_Register = {
		[46968] = true,
		[51271] = true,
		[190319] = true,
	}	
	local spell46968_var = {}
	function module.main:SPELL_DAMAGE(sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,critical)
		if not spellDamage_trackedSpells[spellID] or not sourceName then
			return
		elseif spellID == 46968 and session_gGUIDs[sourceName][275339] then	--confirm
			local sourceData = spell46968_var[sourceName]
			if not sourceData then
				sourceData = {0,0}
				spell46968_var[sourceName] = sourceData
			end
			local t=GetTime()
			if (t - sourceData[1]) > 2 then
				sourceData[1] = t
				sourceData[2] = 0
			end
			sourceData[2] = sourceData[2] + 1
			if sourceData[2] == 3 then
				local line = CDList[sourceName][46968]
				if line then
					line.cd = line.cd - 10
					if line.cd < 0 then 
						line.cd = 0 
					end
					if line.bar and line.bar.data == line then
						line.bar:UpdateStatus()
					end
					UpdateAllData()
					SortAllData()
				end
			end
		elseif (spellID == 49020 or spellID == 49143) and critical and session_gGUIDs[sourceName][207126] then	--confirm
			local line = CDList[sourceName][51271]
			if line then
				line.cd = line.cd - 1
				if line.cd < 0 then 
					line.cd = 0 
				end
				if line.bar and line.bar.data == line then
					line.bar:UpdateStatus()
				end
				UpdateAllData()
				SortAllData()
			end
		elseif (spellID == 11366 or spellID == 133 or spellID == 108853 or spellID == 257541) and critical and session_gGUIDs[sourceName][155148] then	--confirm
			local line = CDList[sourceName][190319]
			if line then
				line.cd = line.cd - 1
				if line.cd < 0 then 
					line.cd = 0 
				end
				if line.bar and line.bar.data == line then
					line.bar:UpdateStatus()
				end
				UpdateAllData()
				SortAllData()
			end
		end
	end
	
	local spellHeal_trackedSpells = {
		[207778] = true,
		[48438] = true,
		[116670] = true,
	}
	local spellHeal_trackedSpells_Register = {
		[207778] = true,
		[29166] = true,
		[115310] = true,
	}	
	local spell207778_var = {0,0}
	function module.main:SPELL_HEAL(sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellID,critical,amount,overhealing)
		if not spellHeal_trackedSpells[spellID] or not sourceName then
			return
		elseif spellID == 207778 and session_gGUIDs[sourceName][207778] then
			local line = CDList[sourceName][207778]
			if line then
				local t = GetTime()
				if spell207778_var[1] < t then
					spell207778_var[1] = t + 1
					spell207778_var[2] = 0
				end

				if (amount - overhealing) > 0 then
					spell207778_var[2] = spell207778_var[2] + 1
					
					C_Timer.After(0.3,function()	--Await for actual cast, selfhealing event fired first
						line.cd = line.cd + (spell207778_var[2] <= 6 and 5 or 0)
						if line.bar and line.bar.data == line then
							line.bar:UpdateStatus()
						end
						UpdateAllData()
						SortAllData()
					end)
				end							
			end				
		elseif spellID == 48438 and session_gGUIDs[sourceName][287251] then
			local line = CDList[sourceName][29166]
			if line then
				if (amount - overhealing) == 0 then
					line.cd = line.cd - 1
					if line.cd < 0 then 
						line.cd = 0 
					end
					if line.bar and line.bar.data == line then
						line.bar:UpdateStatus()
					end
					UpdateAllData()
					SortAllData()
				end							
			end
		elseif spellID == 116670 and session_gGUIDs[sourceName][278576] then
			local line = CDList[sourceName][115310]
			if line then
				if critical then
					line.cd = line.cd - 1
					if line.cd < 0 then 
						line.cd = 0 
					end
					if line.bar and line.bar.data == line then
						line.bar:UpdateStatus()
					end
					UpdateAllData()
					SortAllData()
				end							
			end			
		end
	end
	
	
	eventsView = {
		SPELL_AURA_REMOVED=module.main.SPELL_AURA_REMOVED,
		SPELL_AURA_APPLIED=module.main.SPELL_AURA_APPLIED,
		SPELL_CAST_SUCCESS=module.main.SPELL_CAST_SUCCESS,
		SPELL_DISPEL=module.main.SPELL_DISPEL,
		--SPELL_DAMAGE=module.main.SPELL_DAMAGE,
		--SPELL_HEAL=module.main.SPELL_HEAL,
		--SWING_MISSED=module.main.SWING_MISSED,
		--SPELL_MISSED=module.main.SPELL_MISSED,
		SPELL_SUMMON=module.main.SPELL_SUMMON,
	}
	
	local isSpellDamageAdded = nil
	function module:AddCLEUSpellDamage(spellID)
		if isSpellDamageAdded or (not spellDamage_trackedSpells_Register[spellID] and not spellHeal_trackedSpells_Register[spellID]) then 
			return 
		end
		eventsView.SPELL_DAMAGE = module.main.SPELL_DAMAGE
		eventsView.SPELL_HEAL = module.main.SPELL_HEAL
		isSpellDamageAdded = true
	end
end

function module.options:Load()
	self:CreateTilte()

	loadstring(module.db.AllClassSpellsInText)()
	module.db.AllClassSpellsInText = nil

	local SPELL_LINE_HEIGHT = 32
	local SPELL_PER_PAGE = 17
	local SPELL_PAGE_HEIGHT = 528

	self.decorationLine = CreateFrame("Frame",nil,self)
	self.decorationLine.texture = self.decorationLine:CreateTexture(nil, "BACKGROUND", nil, -5)
	self.decorationLine:SetPoint("TOPLEFT",self,-8,-25)
	self.decorationLine:SetPoint("BOTTOMRIGHT",self,"TOPRIGHT",8,-45)
	self.decorationLine.texture:SetAllPoints()
	self.decorationLine.texture:SetColorTexture(1,1,1,1)
	self.decorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
	
	self.chkEnable = ELib:Check(self,L.senable,VExRT.ExCD2.enabled):Point(560,-26):Size(18,18):OnClick(function(self) 
		if self:GetChecked() then
			module:Enable()
		else
			module:Disable()
		end
	end)
	
	self.chkLock = ELib:Check(self,L.cd2fix,VExRT.ExCD2.lock):Point(430,-26):Size(18,18):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.lock = true
			ExRT.F.LockMove(module.frame,nil,module.frame.texture)
			ExRT.lib.AddShadowComment(module.frame,1)
			if VExRT.ExCD2.SplitOpt then 
				for i=1,module.db.maxColumns do 
					ExRT.F.LockMove(module.frame.colFrame[i],nil,module.frame.colFrame[i].lockTexture)
					ExRT.lib.AddShadowComment(module.frame.colFrame[i],1)
				end 
			end
		else
			VExRT.ExCD2.lock = nil
			ExRT.F.LockMove(module.frame,true,module.frame.texture)
			ExRT.lib.AddShadowComment(module.frame,nil,L.cd2)
			if VExRT.ExCD2.SplitOpt then 
				for i=1,module.db.maxColumns do 
					ExRT.F.LockMove(module.frame.colFrame[i],true,module.frame.colFrame[i].lockTexture)
					ExRT.lib.AddShadowComment(module.frame.colFrame[i],nil,L.cd2,i,72,"OUTLINE")
				end 
			end
		end
	end)

	self.tab = ELib:Tabs(self,0,L.cd2Spells,L.cd2Appearance,L.cd2History):Point(0,-45):Size(660,570):SetTo(1)
	self.tab:SetBackdropBorderColor(0,0,0,0)
	self.tab:SetBackdropColor(0,0,0,0)
	
	local function fastSetupFrameListClick(self,spellsList)
		for k=1,#spellsList do
			local bool = nil
			for j=1,#module.db.spellDB do
				if module.db.spellDB[j][1] == spellsList[k] then
					bool = true
					break
				end
			end
			if not bool then
				for class,classData in pairs(module.db.allClassSpells) do
					for j=1,#classData do
						if classData[j][1] == spellsList[k] then
							module.options:addNewSpell(class,classData[j],true)
							bool = true
							break
						end
					end
					if bool then
						break
					end
				end
			end
		end
		for j=1,#spellsList do
			VExRT.ExCD2.CDE[ spellsList[j] ] = true
		end
		UpdateRoster()
		module.options:ReloadSpellsPage()
		ELib:DropDownClose()
	end
	local function fastSetupFrameListEnter(self,tooltip)
		ELib.Tooltip.Show(self,"ANCHOR_LEFT",unpack(tooltip))
	end
	local function fastSetupFrameListLeave(self)
		ELib.Tooltip:Hide()
	end
	self.fastSetupFrame = ELib:ListButton(self.tab.tabs[1],L.cd2fastSetupTitle..":",200,7):Size(18,18):Point("TOPRIGHT",-15,-9):Left():OnClick(function(self)
		local list = {
			{L.cd2fastSetupTitle1,{31821,204150,62618,98008,97462,31884,64843,108280,740,115310,15286,196718,207399,265202,216331,271466}},		--Raid Save
			{L.cd2fastSetupTitle2,{102342,47788,33206,6940,633,116849,1022,204018}},								--Direct Save
			{L.cd2fastSetupTitle3,{20484,20707,61999,20608,161642}},										--Battle Res
			{L.cd2fastSetupTitle4,{6552,96231,147362,1766,15487,47528,47476,57994,2139,116705,106839,19647,91802,115781,78675,183752,}},	--Kicks
			{L.cd2fastSetupTitle5,{114192,355,62124,56222,49576,115546,6795,185245,}},								--Taunts
			{L.cd2fastSetupTitle6,{4987,32375,527,51886,115450,2782,475,115276,89808}},							--Dispels	
			{STUN,	{46968,109248,205369,192058,30283,119381,179057,	221562,108194,853,408,5211,}},		--Stuns
		}
		for i=1,#list do
			local tooltip = {list[i][1]..":"}
			for j=1,#list[i][2] do
				local spellName,_,spellTexture = GetSpellInfo(list[i][2][j])
				if spellName then
					tooltip[#tooltip + 1] = "|T"..spellTexture..":0|t |cffffffff"..spellName.."|r"
				end
			end
			self.List[i] = {
				text = list[i][1],
				arg1 = list[i][2],
				func = fastSetupFrameListClick,
				hoverFunc = fastSetupFrameListEnter,
				leaveFunc = fastSetupFrameListLeave,
				hoverArg = tooltip,
				justifyH = "CENTER",
			}
		end
		self.OnClick = nil
	end)
	self.fastSetupFrame.text:FontSize(11):Color(GameFontNormal:GetTextColor())
	
	self.borderList = CreateFrame("Frame",nil,self.tab.tabs[1])
	self.borderList:SetSize(650,SPELL_PAGE_HEIGHT)
	self.borderList:SetPoint("TOP", 0, -38)
	ELib:Border(self.borderList,2,.24,.25,.30,1)
	
	local function SyncUserDB()
		table.wipe(VExRT.ExCD2.userDB)
		local j = 1
		for i=module.db.dbCountDef+1,#module.db.spellDB do
			VExRT.ExCD2.userDB[j] = module.db.spellDB[i]
			j = j + 1
		end
	end
	
	local function CheckToNil(self)
		self.chk:SetChecked(nil) 
		VExRT.ExCD2.CDE[self.sid] = nil
		UpdateRoster()
	end

	function module.options:ReloadSpellsPage()
		local page = module.options
		local scrollBarValue = page.ScrollBar:GetValue()
		page.spellsListScrollFrame:SetVerticalScroll(scrollBarValue % SPELL_LINE_HEIGHT) 

		local pos = floor(scrollBarValue / SPELL_LINE_HEIGHT) + 1
		page.butSpellsAdd:Hide()
		page.butSpellsFrame:Hide()
		local lineNum,lastLine = 0
		for i=pos,pos+SPELL_PER_PAGE+1 do
			lineNum = lineNum + 1
			if not module.db.spellDB[i] then
				for j=lineNum,#page.spellsList do
					page.spellsList[j]:Hide()
				end
				page.butSpellsAdd:ClearAllPoints()
				page.butSpellsAdd:SetPoint("TOPLEFT",lastLine,"BOTTOMLEFT",5,-5)
				page.butSpellsAdd:Show()
				page.butSpellsFrame:ClearAllPoints()
				page.butSpellsFrame:SetPoint("TOPLEFT",lastLine,"BOTTOMLEFT",317,-5)
				page.butSpellsFrame:Show()
				break
			end
			local spellData = module.db.spellDB[i]
			local SpellID = spellData[1]
			local line = module.options.spellsList[lineNum]
			lastLine = line
		
			line.chk:SetChecked(VExRT.ExCD2.CDE[SpellID])
			local SpellName,_,SpellTexture = GetSpellInfo(SpellID)
			if module.db.differentIcons[ SpellID ] then
				SpellTexture = module.db.differentIcons[SpellID]
			end
			
			line.sid = SpellID
			line.tid = i
			line.icon:SetTexture(SpellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			line.spellName:SetFormattedText("|cffffffff|Hspell:%d|h%s|h|r",SpellID, SpellName or "?")
			line.class:SetText(L.classLocalizate[ spellData[2] ] or "?")
			local cR,cG,cB = ExRT.F.classColorNum(spellData[2])
			line.class:SetTextColor(cR,cG,cB,1)
			
			line.backClassColorR = cR
			line.backClassColorG = cG
			line.backClassColorB = cB
	
			if not SpellName and spellData.user then
				line.chk:Disable()
				line.chk:SetAlpha(0.5)
			else
				line.chk:Enable()
				line.chk:SetAlpha(1)
			end

			line:Show()

			ExRT.lib.ShowOrHide(line.tooltipFrame,not spellData.user)
			ExRT.lib.ShowOrHide(line.spellName,not spellData.user)
			ExRT.lib.ShowOrHide(line.class,not spellData.user)
			ExRT.lib.ShowOrHide(line.userSpellName,spellData.user)
			ExRT.lib.ShowOrHide(line.userClass,spellData.user)
			ExRT.lib.ShowOrHide(line.userRemove,spellData.user)

			line.dropDownPriority:SetText(format("%d",VExRT.ExCD2.Priority[SpellID] or 15))

			if spellData.user then
				line.userSpellName:SetText(SpellID or "")

				line.userClass:SetText("|c"..ExRT.F.classColor(spellData[2])..L.classLocalizate[ spellData[2] ])
				
				line.isUserSpell = true
			else
				line.isUserSpell = nil
			end
			
			if SpellID == 161642 then
				line.additionalTooltip = L.cd2ResurrectTooltip
			else
				line.additionalTooltip = nil
			end
		end
		GameTooltip_Hide()
		ELib.Tooltip:HideAdd()
		page.ScrollBar:UpdateButtons()
	end
	
	self.ScrollBar = ELib:ScrollBar(self.borderList):Size(16,0):Point("TOPRIGHT",-3,-3):Point("BOTTOMRIGHT",-3,3):ClickRange(32):Range(0,20):SetTo(0):OnChange(module.options.ReloadSpellsPage)

	function self.ScrollBar:UpdateRange()
		self:SetMinMaxValues(0,max((#module.db.spellDB+1)*SPELL_LINE_HEIGHT-SPELL_PAGE_HEIGHT,0))
	end
	
	self:SetScript("OnMouseWheel", function(self, delta)
		delta = -delta
		local current = module.options.ScrollBar:GetValue()
		local min_,max_ = module.options.ScrollBar:GetMinMaxValues()
		current = current + (delta * SPELL_LINE_HEIGHT)
		if current > max_ then
			current = max_
		elseif current < min_ then
			current = min_
		end
		module.options.ScrollBar:SetValue(current)
	end)
	
	local function SpellsListChkOnClick(self)
		if self:GetChecked() then
			VExRT.ExCD2.CDE[self:GetParent().sid] = true
		else
			VExRT.ExCD2.CDE[self:GetParent().sid] = nil
		end
		UpdateRoster()
	end
	local function SpellsListOnUpdate(self)
		if MouseIsOver(self) and not ExRT.lib.ScrollDropDown.DropDownList[1]:IsShown() and not module.options.spellsModifyFrame:IsShown() then
			self.backClassColor:SetGradientAlpha("HORIZONTAL", self.backClassColorR, self.backClassColorG, self.backClassColorB, 0.8, self.backClassColorR, self.backClassColorG, self.backClassColorB, 0)
		else
			self.backClassColor:SetGradientAlpha("HORIZONTAL", self.backClassColorR, self.backClassColorG, self.backClassColorB, 0.4, self.backClassColorR, self.backClassColorG, self.backClassColorB, 0)
		end
	end
	local function SpellsListTooltipFrameOnEnter(self)
		ELib.Tooltip.Link(self,self:GetParent().spellName:GetText())
		if self:GetParent().additionalTooltip then
			ELib.Tooltip:Add(nil,{self:GetParent().additionalTooltip})
		end
	end
	local function SpellsListTooltipFrameOnLeave()
		GameTooltip_Hide()
		ELib.Tooltip:HideAdd()
	end
	local SpellsListDropDownPriorityDataList = {}
	local function SpellsListDropDownPrioritySelectFunc(self,arg)
		local list = self:GetParent().parent
		list:SetText(arg)
		VExRT.ExCD2.Priority[list:GetParent().sid] = arg
		ELib:DropDownClose()
		UpdateRoster()
	end
	for i=1,30 do
		SpellsListDropDownPriorityDataList[i] = {text=i,justifyH="CENTER",arg1=i,func=SpellsListDropDownPrioritySelectFunc}
	end
	local function SpellsListDropDownPriorityOnEnter(self)
		ELib.Tooltip.Show(self,"ANCHOR_LEFT",L.cd2Priority,{L.cd2PriorityTooltip,1,1,1,true})
	end
	local function SpellsListButtonModifyOnClick(self)
		local spellsModifyFrame = module.options.spellsModifyFrame
		spellsModifyFrame:Hide()
		local parent = self:GetParent()
		spellsModifyFrame.sid = parent.sid
		spellsModifyFrame.tid = parent.tid
		spellsModifyFrame.class = module.db.spellDB[parent.tid][2]
		spellsModifyFrame:ShowClick("TOPRIGHT")
	end
	local function SpellsListUserSpellNameOnTextChanged(self,isUser)
		if not isUser then
			return
		end
		local tmp = nil
		local spellID = tonumber(self:GetText())
		local parentLine = self:GetParent()
		if spellID then
			for j=1,#module.db.spellDB do
				if module.db.spellDB[j][1] == spellID and j ~= parentLine.tid then
					parentLine.chk:Disable()
					parentLine.chk:SetAlpha(0.5)
					return
				end
			end
		end
	
		CheckToNil(parentLine)
		if not spellID then 
			parentLine.chk:Disable()
			parentLine.chk:SetAlpha(0.5)
			return 
		end
		local spellName,_,spellTexture = GetSpellInfo(spellID)
		parentLine.sid = spellID
		parentLine.icon:SetTexture(spellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
		if not spellName then
			parentLine.chk:Disable()
			parentLine.chk:SetAlpha(0.5)
		else
			parentLine.chk:Enable()
			parentLine.chk:SetAlpha(1)
		end
		module.db.spellDB[parentLine.tid][1] = spellID
		SyncUserDB()
	end
	local function SpellsListUserSpellNameOnEnter(self)
		local spellID = tonumber(self:GetText())
		if spellID then
			local spellName = GetSpellInfo(spellID)
			if spellName then
				ELib.Tooltip.Link(self,format("|Hspell:%d|hspell|h",spellID))
			else
				ELib.Tooltip.Std(self)
			end
		else
			ELib.Tooltip.Std(self)
		end
	end

	local SpellsListClassDropDownList = {}
	local function SpellsListUserClassDropDownClick(self,classNum,isAll)
		local parent = self:GetParent().parent
		local parentLine = parent:GetParent()
		local class = isAll and "ALL" or module.db.classNames[classNum]
		CheckToNil(parentLine)
		ELib:DropDownClose()
		parent:SetText("|c"..ExRT.F.classColor(class)..L.classLocalizate[ class ])
		module.db.spellDB[parentLine.tid][2] = class
		local cR,cG,cB = ExRT.F.classColorNum(class)
		parentLine.backClassColorR = cR
		parentLine.backClassColorG = cG
		parentLine.backClassColorB = cB
		SyncUserDB()
	end
	for i=1,#module.db.classNames do
		SpellsListClassDropDownList[#SpellsListClassDropDownList + 1] = {
			text = "|c"..ExRT.F.classColor(module.db.classNames[i])..L.classLocalizate[ module.db.classNames[i] ],
			justifyH = "CENTER",
			arg1 = i,
			func = SpellsListUserClassDropDownClick,
		}
	end
	SpellsListClassDropDownList[#SpellsListClassDropDownList + 1] = {
		text = "|c"..ExRT.F.classColor("ALL")..L.classLocalizate[ "ALL" ],
		justifyH = "CENTER",
		arg1 = 0,
		arg2 = true,
		func = SpellsListUserClassDropDownClick,
	}	
	
	local function SpellsListUserRemoveOnClick(self)
		local parentLine = self:GetParent()
		VExRT.ExCD2.CDE[parentLine.sid] = nil
		
		for j=3,7 do
			if type(module.db.spellDB[parentLine.tid][j])=="table" then
				VExRT.ExCD2.CDECol[module.db.spellDB[parentLine.tid][j][1]..";"..(j-2)] = nil
			end
		end
		
		for j = parentLine.tid + 1,#module.db.spellDB do
			module.db.spellDB[j-1] = module.db.spellDB[j]
		end
		module.db.spellDB[#module.db.spellDB] = nil

		local current = module.options.ScrollBar:GetValue()
		local min_,max_ = module.options.ScrollBar:GetMinMaxValues()
		module.options.ScrollBar:UpdateRange()
		
		local newVal = current == max_ and max(current-SPELL_LINE_HEIGHT,1) or current
		if newVal ~= current then
			module.options.ScrollBar:SetValue(newVal)
			module.options:ReloadSpellsPage()
		else
			module.options.ReloadSpellsPage()
		end

		SyncUserDB()
		UpdateRoster()
		
		module.options:CleanUPVariables()
	end
	
	self.spellsListScrollFrame = CreateFrame("ScrollFrame", nil, self.borderList)
	self.spellsListScrollFrame:SetPoint("TOPLEFT")
	self.spellsListScrollFrame:SetPoint("BOTTOMRIGHT")
	
	self.spellsListScrollFrameContent = CreateFrame("Frame", nil, self.spellsListScrollFrame)
	self.spellsListScrollFrameContent:SetPoint("TOPLEFT",0,0)
	self.spellsListScrollFrameContent:SetSize(self.spellsListScrollFrame:GetSize())
	self.spellsListScrollFrame:SetScrollChild(self.spellsListScrollFrameContent)
	
	self.spellsList = {}
	for i=1,(SPELL_PER_PAGE+2) do
		local line = CreateFrame("Frame",nil,self.spellsListScrollFrameContent)
		self.spellsList[i] = line
		line:SetPoint("TOPLEFT",0,-(i-1)*SPELL_LINE_HEIGHT)
		line:SetPoint("RIGHT",-100,0)
		line:SetHeight(SPELL_LINE_HEIGHT)

		line.chk = ELib:Check(line):Point("LEFT",10,0):OnClick(SpellsListChkOnClick)
		line.chk._i = i
		
		line.backClassColor = line:CreateTexture(nil, "BACKGROUND")
		line.backClassColor:SetPoint("LEFT",0,0)
		line.backClassColor:SetSize(250,SPELL_LINE_HEIGHT)
		line.backClassColor:SetColorTexture(1, 1, 1, 1)
		line.backClassColorR = 0
		line.backClassColorG = 0
		line.backClassColorB = 0
		
		line:SetScript("OnUpdate",SpellsListOnUpdate)
	
		line.icon = line:CreateTexture(nil, "ARTWORK")
		line.icon:SetSize(28,28)
		line.icon:SetPoint("LEFT", 35, 0)
		line.icon:SetTexCoord(.1,.9,.1,.9)
		ELib:Border(line.icon,1,.12,.13,.15,1)
	
		line.tooltipFrame = CreateFrame("Frame",nil,line)
		line.tooltipFrame:SetSize(150,SPELL_LINE_HEIGHT) 
		line.tooltipFrame:SetPoint("LEFT", 70, 0)
		line.tooltipFrame._i = i
		line.tooltipFrame:SetScript("OnEnter", SpellsListTooltipFrameOnEnter)
		line.tooltipFrame:SetScript("OnLeave", SpellsListTooltipFrameOnLeave)

		line.spellName = ELib:Text(line):Size(155,SPELL_LINE_HEIGHT):Point("LEFT",70,0):Font(ExRT.F.defFont,12):Shadow()
	
		line.class = ELib:Text(line):Size(180,SPELL_LINE_HEIGHT):Point("LEFT",235,0):Font(ExRT.F.defFont,14):Shadow()
	
		line.dropDownPriority = ELib:DropDown(line,100,15):Size(80):Point("LEFT",375,0)
		line.dropDownPriority._i = i
		line.dropDownPriority.List = SpellsListDropDownPriorityDataList
		line.dropDownPriority:SetScript("OnEnter",SpellsListDropDownPriorityOnEnter)
		line.dropDownPriority:SetScript("OnLeave",ELib.Tooltip.Hide)
		
		line.buttonModify = ELib:Button(line,L.cd2ButtonModify):Size(130,20):Point("LEFT",465,0):OnClick(SpellsListButtonModifyOnClick)
		line.buttonModify._i = i

		line.userSpellName = ELib:Edit(line,6,true):Size(145,20):Point("LEFT",70,0):Tooltip(L.cd2SpellID):OnChange(SpellsListUserSpellNameOnTextChanged)
		line.userSpellName._i = i
		line.userSpellName:SetScript("OnEnter",SpellsListUserSpellNameOnEnter)
		line.userSpellName:SetScript("OnLeave",ELib.Tooltip.Hide)
		
		line.userClass = ELib:DropDown(line,130,13):Size(140):Point("LEFT",225,0):SetText(L.cd2Class)
		line.userClass._i = i
		line.userClass.List = SpellsListClassDropDownList
	
		line.userRemove = ELib:Button(line,"","UIPanelCloseButton"):Size(18,18):Point("LEFT",600,0):OnClick(SpellsListUserRemoveOnClick)
		line.userRemove.tooltipText = L.cd2RemoveButton
		line.userRemove._i = i
		line.userRemove:SetScript("OnEnter",ELib.Tooltip.Std)
		line.userRemove:SetScript("OnLeave",ELib.Tooltip.Hide)

		line.userClass:Hide()
		line.userRemove:Hide()
	end

	self.butSpellsAdd = ELib:Button(self.spellsListScrollFrameContent,L.cd2AddSpell):Size(305,20):Point(5,-3-SPELL_PER_PAGE*SPELL_LINE_HEIGHT):OnClick(function(self) 
		module.options:addNewSpell(module.db.classNames[math.random(1,#module.db.classNames)])
		module.options:CleanUPVariables()
	end) 
	self.butSpellsAdd:Hide()
	
	self.butSpellsFrame = ELib:Button(self.spellsListScrollFrameContent,L.cd2AddSpellFromList):Size(305,20):Point(317,-3-SPELL_PER_PAGE*SPELL_LINE_HEIGHT):OnClick(function(self) 
		module.options.addSpellFrame:Show()
	end) 
	self.butSpellsFrame:Hide()
	self.butSpellsFrame.Texture:SetGradientAlpha("VERTICAL",0.05,0.26,0.09,1, 0.20,0.41,0.25,1)

	if ExRT.isClassic then
		self.butSpellsFrame:Disable()
		self.butSpellsFrame:Hide()
		self.butSpellsFrame.Show = ExRT.NULLfunc
	end
	
	self.spellsModifyFrame = ELib:Popup():Size(560,180)
	self.spellsModifyFrame.isDefaultSpell = nil
	
	self.spellsModifyFrame.OnShow = function(self)
		if not self.class or not self.sid or not self.tid then
			self:Hide()
			return
		end
		self:SetFrameLevel(120)
		
		local titleName,_,titleTexture = GetSpellInfo(self.sid)
		self.title:SetFormattedText("%s%s",titleTexture and "|T"..titleTexture..":16|t " or "",titleName or L.cd2TextSpell.." #"..self.sid)
		
		local spellData = module.db.spellDB[self.tid]

		local specByClassTable = module.db.specByClass[self.class] or {0}
		local specsCount = #specByClassTable
		if ExRT.isClassic then
			specsCount = math.min(specsCount,1)
		end
		for i=1,specsCount do
			local specID = specByClassTable[i]
			local icon = ""
			if module.db.specIcons[specID] then
				icon = "|T".. module.db.specIcons[specID] ..":20|t"
			else
				icon = ExRT.F.classIconInText(self.class,20) or ""
			end
			local line = module.options.spellsModifyFrame.el[i]
		
			line.spec:SetText(icon.." |c"..ExRT.F.classColor(self.class)..L.specLocalizate[module.db.specInLocalizate[specID]])
			line:Show()
			
			if spellData[i+2] then
				line.cd:SetText(spellData[i+2][2])
				line.dur:SetText(spellData[i+2][3])
				line.spellID:SetText(spellData[i+2][1])
				
				line.col:SetText( VExRT.ExCD2.CDECol[spellData[i+2][1]..";"..i] or module.db.def_col[spellData[i+2][1]..";"..i] or 1)
				
				line.add:Hide()
				line.col:Show()
				line.dur:Show()
				line.spellID:Show()
				line.cd:Show()
				line.remove:Show()
			else
				line.add:Show()
				line.col:Hide()
				line.dur:Hide()
				line.spellID:Hide()
				line.cd:Hide()
				line.remove:Hide()
			end
			
			if not spellData.user then
				line.spellID:Disable()
				line.remove:Disable()
				line.add:Hide()
			else
				line.spellID:Enable()
				line.remove:Enable()
			end
		end
		for i=specsCount+1,5 do
			self.el[i]:Hide()
		end
		if not spellData.user then
			self.isDefaultSpell = true
		else
			self.isDefaultSpell = nil
		end
		self:SetHeight(30+32*specsCount)
	end
	
	self.spellsModifyFrame.el = {}
	for i=1,5 do
		local line = CreateFrame("Frame",nil,self.spellsModifyFrame)
		self.spellsModifyFrame.el[i] = line
		line:SetPoint("TOPLEFT",15,-20-(i-1)*32)
		line:SetSize(self.spellsModifyFrame:GetWidth(),30)
		
		line.spec = ELib:Text(line):Size(160,30):Point(0,0):Font(ExRT.F.defFont,14):Shadow()
	
		line.spellID = ELib:Edit(line,6,true):Size(140,20):Point("LEFT",180,0):Tooltip(L.cd2SpellID):OnChange(function(self,isUser)
			local spellID = tonumber(self:GetText())
			if not spellID or not isUser then
				return
			end
			local spellName = GetSpellInfo(spellID)
			local modFrame = self:GetParent():GetParent()

			local c = VExRT.ExCD2.CDECol[module.db.spellDB[modFrame.tid][i+2][1]..";"..i]
			local tmp = nil
			for N1=1,#module.db.spellDB do
				for N2=3,7 do
					if module.db.spellDB[N1][N2] and module.db.spellDB[N1][N2] and module.db.spellDB[N1][N2][1] == module.db.spellDB[modFrame.tid][i+2][1] and not (modFrame.tid == N1 and (i+2) == N2) then
						tmp = true
					end
				end
			end
			if not tmp then
				VExRT.ExCD2.CDECol[module.db.spellDB[modFrame.tid][i+2][1]..";"..i] = nil
			end
			module.db.spellDB[modFrame.tid][i+2][1] = spellID
			if not VExRT.ExCD2.CDECol[spellID..";"..i] and not module.db.def_col[spellID..";"..i] then
				VExRT.ExCD2.CDECol[spellID..";"..i] = c
			else
				modFrame.el[i].col:SetText( VExRT.ExCD2.CDECol[spellID..";"..i] or module.db.def_col[spellID..";"..i])
			end
		end)
		line.spellID:SetScript("OnEnter",function(self)
			local spellID = tonumber(self:GetText())
			if spellID then
				local spellName = GetSpellInfo(spellID)
				if spellName then
					local link = format("|Hspell:%d|hspell|h",spellID)
					ELib.Tooltip.Link(self,link)
				else
					ELib.Tooltip.Std(self)
				end
			else
				ELib.Tooltip.Std(self)
			end
		end)
		line.spellID:SetScript("OnLeave",function(self)
			ELib.Tooltip:Hide()
		end)
		
		line.col = ELib:DropDown(line,100,10):Size(70):Point("LEFT",330,0):Tooltip(L.cd2ColNum)
		local function SpellsModifyFrameColSet(self,arg)
			module.options.spellsModifyFrame.el[i].col:SetText(arg)
			ELib:DropDownClose()
			VExRT.ExCD2.CDECol[module.db.spellDB[module.options.spellsModifyFrame.tid][i+2][1]..";"..i] = tonumber(arg)
			UpdateRoster()
		end
		for j=1,10 do
			line.col.List[j] = {
				text=j,
				justifyH="CENTER",
				arg1=j,
				func=SpellsModifyFrameColSet,
			}
		end
		
		
		line.cd = ELib:Edit(line,6,true):Size(50,20):Point("LEFT",410,0):Tooltip(L.cd2EditBoxCDTooltip):OnChange(function(self,isUser)
			if not isUser then
				return
			end
			local cd_num = tonumber(self:GetText())
			if not cd_num then
				return
			end
			local modFrame = self:GetParent():GetParent()
			module.db.spellDB[modFrame.tid][i+2][2] = cd_num
			if modFrame.isDefaultSpell then
				local spellID = module.db.spellDB[modFrame.tid][1]
				VExRT.ExCD2.default_userCD[spellID] = VExRT.ExCD2.default_userCD[spellID] or {}
				VExRT.ExCD2.default_userCD[spellID][i] = cd_num
			end
		end)
		
		line.dur = ELib:Edit(line,6,true):Size(50,20):Point("LEFT",470,0):Tooltip(L.cd2EditBoxDurationTooltip):OnChange(function(self,isUser)
			if not isUser then
				return
			end
			local duration = tonumber(self:GetText())
			if not duration then
				return
			end
			local modFrame = self:GetParent():GetParent()
			module.db.spellDB[modFrame.tid][i+2][3] = duration
			if modFrame.isDefaultSpell then
				local spellID = module.db.spellDB[modFrame.tid][1]
				VExRT.ExCD2.default_userDuration[spellID] = VExRT.ExCD2.default_userDuration[spellID] or {}
				VExRT.ExCD2.default_userDuration[spellID][i] = duration
			end
		end)
		line.dur:SetTextColor(0.5,1,0.5,1)
		
		line.remove = ELib:Button(line,"","UIPanelCloseButton"):Size(18,18):Point("LEFT",520,0):OnClick(function(self) 
			local parentLine = self:GetParent()
			parentLine.add:Show()
			parentLine.col:Hide()
			parentLine.dur:Hide()
			parentLine.spellID:Hide()
			parentLine.cd:Hide()
			parentLine.remove:Hide()
			
			module.db.spellDB[parentLine:GetParent().tid][i+2] = nil
		end) 
		line.remove.tooltipText = L.cd2RemoveButton
		line.remove:SetScript("OnEnter",ELib.Tooltip.Std)
		line.remove:SetScript("OnLeave",ELib.Tooltip.Hide)
		
		line.add = ELib:Button(line,0,1):Size(400,24):Point(140,-4):OnClick(function(self) 
			local parentLine = self:GetParent()
			local modFrame = parentLine:GetParent()
			self:Hide()
			parentLine.col:Show()
			parentLine.dur:Show()
			parentLine.spellID:Show()
			parentLine.cd:Show()
			parentLine.remove:Show()
			
			parentLine.spellID:SetText(modFrame.sid)
			
			module.db.spellDB[modFrame.tid][i+2] = {modFrame.sid,0,0}
			
			parentLine.cd:SetText(0)
			parentLine.dur:SetText(0)
			parentLine.col:SetText(VExRT.ExCD2.CDECol[module.db.spellDB[modFrame.tid][i+2][1]..";"..i] or 1)
		end)
		line.add.html = ELib:Text(line.add,L.cd2TextAdd):Point(0,0):Point("BOTTOMRIGHT",0,0):Center():Color()
		ExRT.lib.CreateHoverHighlight(line.add)
		line.add.hl:SetVertexColor(1,1,1,0.5)
		line.add:SetScript("OnEnter", function(self) self.hl:Show() end)
		line.add:SetScript("OnLeave", function(self) self.hl:Hide() end)
	end
	
	self.addSpellFrame = ELib:Popup(L.cd2AddSpellFrameName):Size(750,422+10)

	self.addSpellFrame.backClassColor = self.addSpellFrame:CreateTexture(nil, "BORDER",nil,0)
	self.addSpellFrame.backClassColor:SetPoint("TOPLEFT",0,-72)
	self.addSpellFrame.backClassColor:SetPoint("RIGHT",0,0)
	self.addSpellFrame.backClassColor:SetHeight(40)
	self.addSpellFrame.backClassColor:SetColorTexture( 1, 1, 1, 1)
	self.addSpellFrame.backClassColor:Hide()
	
	self.addSpellFrame.backClassColorBottom = self.addSpellFrame:CreateTexture(nil, "BORDER",nil,0)
	self.addSpellFrame.backClassColorBottom:SetPoint("BOTTOMLEFT",0,0)
	self.addSpellFrame.backClassColorBottom:SetPoint("RIGHT",0,0)
	self.addSpellFrame.backClassColorBottom:SetHeight(15)
	self.addSpellFrame.backClassColorBottom:SetColorTexture( 1, 1, 1, 1)
	self.addSpellFrame.backClassColorBottom:Hide()
	
	self.addSpellFrame.backVertical = self.addSpellFrame:CreateTexture(nil, "BORDER",nil,-2)
	self.addSpellFrame.backVertical:SetPoint("TOPLEFT",200,-72)
	self.addSpellFrame.backVertical:SetPoint("BOTTOM",0,0)
	self.addSpellFrame.backVertical:SetWidth(7)
	self.addSpellFrame.backVertical:SetColorTexture( 1, 1, 1, 1)
	self.addSpellFrame.backVertical:SetGradientAlpha("HORIZONTAL", 0,0,0, .7, 0,0,0, 0)
	
	self.addSpellFrame.classButtons = {}
	for i=1,#module.db.classNames+1 do
		local button = CreateFrame("Button",nil,self.addSpellFrame)
		self.addSpellFrame.classButtons[i] = button
		
		button:SetSize(57,57)
		if i==1 then
			button:SetPoint("TOPLEFT",3,-15)
		else
			button:SetPoint("LEFT",self.addSpellFrame.classButtons[i-1],"RIGHT",0,0)
		end
		
		button.icon = button:CreateTexture(nil, "ARTWORK")
		button.icon:SetPoint("BOTTOM",0,15)
		button.icon:SetSize(32,32)
		
		local isOtherCategory = i > #module.db.classNames
				
		local class = module.db.classNames[i]
		if isOtherCategory then
			button.icon:SetTexture("Interface\\Icons\\spell_priest_divinestar_holy")		
		elseif CLASS_ICON_TCOORDS[class] then
			button.icon:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
			button.icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
		end
		
		button.text = button:CreateFontString(nil,"ARTWORK","GameFontNormal")
		button.text:SetPoint("BOTTOM",0,3)
		if isOtherCategory then
			button.text:SetText("|cffb2b2b2"..L.classLocalizate[ "NO" ])
		elseif class then
			button.text:SetText("|c"..ExRT.F.classColor(class)..L.classLocalizate[ class ])
		end
		button.text:SetWidth(57)
		button.text:SetMaxLines(1)
		button.text:SetFont(button.text:GetFont(),10)
		
		button:SetScript("OnEnter",function(self)
			if self.selected then
				return
			end
			self.icon:SetSize(42,42)
		end)
		button:SetScript("OnLeave",function(self)
			if self.selected then
				return
			end
			self.icon:SetSize(32,32)
		end)
		button:SetScript("OnClick",function(self)
			module.options.addSpellFrame.dropDown:SetValue(self.token)
		end)
		
		button.token = class
		if isOtherCategory then
			button.token = "OTHER"	
		end
	end
	
	self.addSpellFrame.specButtons = {}
	for i=1,4 do
		local button = CreateFrame("Button",nil,self.addSpellFrame)
		self.addSpellFrame.specButtons[i] = button
		
		button:SetSize(200,60)
		
		local cR,cG,cB = .35,.32,.44
		
		button.tGt = button:CreateTexture(nil, "BACKGROUND",nil,0)
		button.tGt:SetPoint("TOPLEFT",0,0)
		button.tGt:SetPoint("RIGHT",0,0)
		button.tGt:SetHeight(10)
		button.tGt:SetColorTexture( 1, 1, 1, 1)
		button.tGt:SetGradientAlpha("VERTICAL", cR,cG,cB, 0, cR,cG,cB, 0.5)
		
		button.tGb = button:CreateTexture(nil, "BACKGROUND",nil,0)
		button.tGb:SetPoint("BOTTOMLEFT",0,0)
		button.tGb:SetPoint("RIGHT",0,0)
		button.tGb:SetHeight(10)
		button.tGb:SetColorTexture( 1, 1, 1, 1)
		button.tGb:SetGradientAlpha("VERTICAL", cR,cG,cB, 0.5, cR,cG,cB, 0)
		
		button.b = button:CreateTexture(nil, "BACKGROUND",nil,-5)
		button.b:SetPoint("TOPLEFT")
		button.b:SetPoint("BOTTOMRIGHT")
		button.b:SetColorTexture( .06, .06, .12, 1)
		
		button.icon = button:CreateTexture(nil, "ARTWORK")
		button.icon:SetPoint("LEFT",4,0)
		button.icon:SetSize(48,48)
		
		button.text = button:CreateFontString(nil,"ARTWORK","GameFontNormal")
		button.text:SetPoint("LEFT",button.icon,"RIGHT",3,0)
		button.text:SetPoint("RIGHT",-5,0)
		
		button.SetState = function(self,selected)
			local cR,cG,cB
			if selected then
				cR,cG,cB = 1,.95,.44
			else
				cR,cG,cB = .35,.32,.44
			end
			self.tGt:SetGradientAlpha("VERTICAL", cR,cG,cB, 0, cR,cG,cB, 0.5)
			self.tGb:SetGradientAlpha("VERTICAL", cR,cG,cB, 0.5, cR,cG,cB, 0)
		end
		button:SetScript("OnEnter",function(self)
			if self.selected then
				return
			end
			self.b:SetColorTexture( .12, .12, .22, 1)
		end)
		button:SetScript("OnLeave",function(self)
			if self.selected then
				return
			end
			self.b:SetColorTexture( .06, .06, .12, 1)
		end)
		button:SetScript("OnClick",function(self)
			module.options.addSpellFrame.CURR_SPEC[module.options.addSpellFrame.CURR_CLASS] = i
			module.options.addSpellFrame.dropDown:SetValue(module.options.addSpellFrame.CURR_CLASS)
		end)
	end
	self.addSpellFrame.CURR_CLASS = nil
	self.addSpellFrame.CURR_SPEC = {}
	
	function self.addSpellFrame:SetSpecButtons(class)
	  	local specByClassTable = module.db.specByClass[class] or {0,-1,-2,-3,-4}
	  	local addSpellFrame = module.options.addSpellFrame
	  	
	  	local height = addSpellFrame:GetHeight() - 72
	  	for i=2,#specByClassTable do
	  		local button = addSpellFrame.specButtons[i-1]
	  		button:SetPoint("LEFT",addSpellFrame,"TOPLEFT",0,-72-height/(#specByClassTable)*(i-1))
	  		
		  	local specID = specByClassTable[i]
	  		if class == "OTHER" then
	  			if specID == -1 then
		  			button.text:SetText(L.cd2Racial)
		  			button.icon:SetTexture("Interface\\Icons\\achievement_character_bloodelf_female")
		  		elseif specID == -2 then	
		  			button.text:SetText(L.cd2Items)
		  			button.icon:SetTexture("Interface\\Icons\\inv_inscription_tarot_volcanocard")
		  		elseif specID == -3 then	
		  			button.text:SetText(L.classLocalizate["PET"])
		  			button.icon:SetTexture("Interface\\Icons\\ability_hunter_aspectofthefox")	 
		  		elseif specID == -4 then	
		  			button.text:SetText(AZERITE_ESSENCE_ITEM_TYPE or "Essences")
		  			button.icon:SetTexture(1869493)	 
		  		end
	  		else
		  		local role = ExRT.GDB.ClassSpecializationRole[specID]
		  		if role then
		  			role = "\n|cffffffff"..(role == 'TANK' and TANK or role == 'HEAL' and HEALER or DAMAGER)
		  		end
		  		
		  		button.text:SetText(L.specLocalizate[ module.db.specInLocalizate[specID] ]..(role or ""))
		  		button.icon:SetTexture(module.db.specIcons[specID])	  		
	  		end
	  		
	  		if addSpellFrame.CURR_SPEC[addSpellFrame.CURR_CLASS] == i-1 then
	  			button:SetState(true)
	  		else
	  			button:SetState(false)
	  		end
	  		
	  		button:Show()
	  	end
	  	for i=#specByClassTable,4 do
	  		addSpellFrame.specButtons[i]:Hide()
	  	end
	end
	
	self.addSpellFrame.sortedClasses = {}
	
	self.addSpellFrame.classNameText = self.addSpellFrame:CreateFontString(nil,"ARTWORK","GameFontWhite")
	self.addSpellFrame.classNameText:SetPoint("TOP",self.addSpellFrame,"TOPLEFT",100,-80)
	self.addSpellFrame.classNameText:SetWidth(190)
	self.addSpellFrame.classNameText:SetMaxLines(1)
	self.addSpellFrame.classNameText:SetFont(self.addSpellFrame.classNameText:GetFont(),18,"OUTLINE")
	
	self.addSpellFrame.dropDown = ELib:DropDown(self.addSpellFrame,200,10):Size(210):Point("TOPRIGHT",-5,-25)
	self.addSpellFrame.dropDown:Hide()
	function self.addSpellFrame.dropDown:SetValue(newValue)
		local addSpellFrame = module.options.addSpellFrame
		--addSpellFrame.dropDown:SetText("|c"..ExRT.F.classColor(newValue)..(L.classLocalizate[newValue] or newValue == "RACIAL" and L.cd2Racial or newValue == "ITEMS" and L.cd2Items or "Unk"))
		ELib:DropDownClose()
		for i=1,#module.db.classNames+1 do
			local button = addSpellFrame.classButtons[i]
			if button.token == newValue then
				button.selected = true
				button.icon:SetSize(42,42)
			else
				button.selected = false
				button.icon:SetSize(32,32)
			end
		end
		addSpellFrame.CURR_CLASS = newValue
		addSpellFrame.CURR_SPEC[newValue] = addSpellFrame.CURR_SPEC[newValue] or 1
		addSpellFrame:SetSpecButtons(newValue)
		
		addSpellFrame.classNameText:SetText(newValue == "OTHER" and "" or L.classLocalizate[newValue] or "")
		
		local specNum = addSpellFrame.CURR_SPEC[newValue]
		
		if newValue == "OTHER" then
			if specNum == 1 then
				newValue = "RACIAL"
			elseif specNum == 2 then
				newValue = "ITEMS"
			elseif specNum == 3 then
				newValue = "PET"
			elseif specNum == 4 then
				newValue = "ESSENCES"
			end
		end
		local classDB = module.db.allClassSpells[newValue]
		
		if not addSpellFrame.sortedClasses[newValue] then
			for i=1,#classDB do
				local spellName = GetSpellInfo(classDB[i][1])
				classDB[i].spellName = spellName or tostring(classDB[i][1])
			end
			sort(classDB,function(a,b) return a.spellName < b.spellName end)
			addSpellFrame.sortedClasses[newValue] = true
		end
		
		local buttonCount = 0
		for i=1,#classDB do
			local spellDB = classDB[i]
			if spellDB[3] or spellDB[3+specNum] then
				buttonCount = buttonCount + 1
				local buttonFrame = module.options.addSpellFrame.buttons[buttonCount]
				if buttonFrame then
					local SpellID = spellDB[1]
					local spellName, _, spellTexture = GetSpellInfo(SpellID)
					if module.db.differentIcons[ SpellID ] then
						spellTexture = module.db.differentIcons[SpellID]
					end
					
					buttonFrame.icon:SetTexture(spellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
					buttonFrame.text:SetText(spellName or "?")
					buttonFrame.spellID = SpellID
					buttonFrame.spellLink = GetSpellLink(SpellID)
					buttonFrame.colNum = spellDB[2]
					
					buttonFrame.line = spellDB
					
					if newValue == "PET" then
						buttonFrame.text:SetText("|c"..ExRT.F.classColor(spellDB[3])..L.classLocalizate[spellDB[3]].."|r "..(spellName or "?"))
					end
					
					buttonFrame.disabled = nil
					for j=1,#module.db.spellDB do
						if module.db.spellDB[j][1] == SpellID then
								buttonFrame.icon:SetDesaturated(true)
								buttonFrame.text:SetTextColor(0.5,0.5,0.5,1)
								buttonFrame.disabled = true
							break
						end
					end
					if not buttonFrame.disabled then
						buttonFrame.icon:SetDesaturated(nil)
						buttonFrame.text:SetTextColor(1,1,1,1)
					end
		
					buttonFrame:Show()
				end
			end
		end
		for i=buttonCount+1,addSpellFrame.buttonsMax do
			addSpellFrame.buttons[i]:Hide()
		end
		addSpellFrame.class = newValue
		
		local cR,cG,cB = ExRT.F.classColorNum(newValue)
		addSpellFrame.backClassColor:SetGradientAlpha("VERTICAL", cR,cG,cB, 0, cR,cG,cB, 0.5)
		addSpellFrame.backClassColor:Show()
		addSpellFrame.backClassColorBottom:SetGradientAlpha("VERTICAL", cR,cG,cB, 0.5, cR,cG,cB, 0)		
		addSpellFrame.backClassColorBottom:Show()
	end
	for i=1,#module.db.classNames do
		local class = module.db.classNames[i]
		self.addSpellFrame.dropDown.List[#self.addSpellFrame.dropDown.List + 1] = {
			text = "|c"..ExRT.F.classColor(class)..L.classLocalizate[class],
			justifyH = "CENTER",
			func = self.addSpellFrame.dropDown.SetValue,
			arg1 = class,
		}
	end
	for i,noClassData in ipairs({{"PET",L.classLocalizate["PET"]},{"RACIAL",L.cd2Racial},{"ITEMS",L.cd2Items}}) do
		self.addSpellFrame.dropDown.List[#self.addSpellFrame.dropDown.List + 1] = {
			text = "|c"..ExRT.F.classColor(noClassData[1])..noClassData[2],
			justifyH = "CENTER",
			func = self.addSpellFrame.dropDown.SetValue,
			arg1 = noClassData[1],
		}
	end
	self.addSpellFrame.dropDown.Lines = #self.addSpellFrame.dropDown.List
	
	local function AddSpellFrameButtonsOnEnter(self)
		self:SetBackdropBorderColor(1,1,1,0.5)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		
		local isItem,isArtifact = nil
		for itemID,spellID in pairs(module.db.itemsToSpells) do
			if spellID == self.line[1] then
				if module.db.itemsArtifacts[itemID] then
					isArtifact = itemID
				else
					isItem = itemID
				end
				break
			end
		end
		
		if not isItem then
			if self.spellLink then
				GameTooltip:SetHyperlink(self.spellLink)
			end
		else
			local _,itemLink = GetItemInfo(isItem)
			GameTooltip:SetHyperlink(itemLink or self.spellLink)
		end
		GameTooltip:AddLine(" ")
		
		local className = module.options.addSpellFrame.class
		if module.db.specByClass[className] then
			for i=1,#module.db.specByClass[className] do
				if self.line[2+i] then
					local icon = ""
					if module.db.specIcons[module.db.specByClass[className][i]] then
						icon = "|T".. module.db.specIcons[module.db.specByClass[className][i]] ..":20|t"
					else
						icon = ExRT.F.classIconInText(className,20) or ""
					end
					GameTooltip:AddLine(icon.." |c"..ExRT.F.classColor(className)..L.specLocalizate[module.db.specInLocalizate[module.db.specByClass[className][i]]].. ":|r|cffffffff "..L.cd2AddSpellFrameCDText.." "..format("%d:%02d",self.line[i+2][2]/60,self.line[i+2][2]%60).. (self.line[i+2][3] > 0 and ", "..L.cd2AddSpellFrameDurationText.." "..self.line[i+2][3] or ""))
				end
			end
		elseif className == "PET" then
			for petName,petData in pairs(module.db.petsAbilities) do
				for j=2,#petData do
					if petData[j][1] == self.line[1] then
						local petNameInTooltip = petName
						if tonumber(petNameInTooltip) then
							petNameInTooltip = L.creatureNames[tonumber(petNameInTooltip)]
						end
						GameTooltip:AddLine((ExRT.F.classIconInText(self.line[3],20) or "").." |c"..ExRT.F.classColor(self.line[3])..petNameInTooltip.. ":|r|cffffffff "..L.cd2AddSpellFrameCDText.." "..format("%d:%02d",petData[j][2]/60,petData[j][2]%60).. (petData[j][3] and ", "..L.cd2AddSpellFrameDurationText.." "..petData[j][3] or ""))
						break
					end
				end
			end
		else
			GameTooltip:AddLine("|cffffffff"..L.cd2AddSpellFrameCDText.." "..self.line[3][2].. (self.line[3][3] > 0 and ", "..L.cd2AddSpellFrameDurationText.." "..self.line[3][3] or ""))
		end
		if isArtifact then
			GameTooltip:AddLine(ARTIFACT_POWER)
		end
		GameTooltip:AddLine("|cffffffff"..L.cd2AddSpellFrameColumnText..": ".. self.colNum .."|r")
		if module.db.spell_isTalent[self.line[1]] and not className == "ITEMS" then
			GameTooltip:AddLine("|cffffffff"..L.cd2AddSpellFrameTalent.."|r")
		end
		if module.db.spell_durationByTalent_fix[self.line[1]] then
			GameTooltip:AddLine("|cffaaffaa"..L.cd2AddSpellFrameDuration..":|r")
			for j=1,#module.db.spell_durationByTalent_fix[self.line[1]],2 do
				local sname = GetSpellInfo(module.db.spell_durationByTalent_fix[self.line[1]][j]) or "???"
				local cd = module.db.spell_durationByTalent_fix[self.line[1]][j+1]
				if type(cd) == 'table' then
					cd = strjoin(",",unpack(cd))
				elseif not tonumber(cd) then
					cd = tonumber(string.sub(cd,2))
					if cd < 1 then
						cd = "-"..( (1-cd)*100 ).."%"
					else
						cd = "+"..( (cd-1)*100 ).."%"
					end
				end
				GameTooltip:AddLine("|cffffffff - "..sname .." (".. (tonumber(cd) and cd > 0 and "+" or "").. cd ..")|r")
				
				ELib.Tooltip:Add("spell:"..module.db.spell_durationByTalent_fix[self.line[1]][j])
			end
			
		end
		do
			local cdByTalent_fix = nil
			local readiness_lines = {}
			if module.db.spell_cdByTalent_fix[self.line[1]] then
				cdByTalent_fix = true
				for j=1,#module.db.spell_cdByTalent_fix[self.line[1]],2 do
					local sname = GetSpellInfo(module.db.spell_cdByTalent_fix[self.line[1]][j]) or "???"
					local cd = module.db.spell_cdByTalent_fix[self.line[1]][j+1]
					if type(cd) == 'table' then
						cd = strjoin(",",unpack(cd))
					elseif not tonumber(cd) then
						cd = tonumber(string.sub(cd,2))
						if cd < 1 then
							cd = "-"..( (1-cd)*100 ).."%"
						else
							cd = "+"..( (cd-1)*100 ).."%"
						end
					end
					table.insert(readiness_lines,"|cffffffff - "..sname .." (".. (tonumber(cd) and cd > 0 and "+" or "").. cd ..")|r")
					
					ELib.Tooltip:Add("spell:"..module.db.spell_cdByTalent_fix[self.line[1]][j])
				end
			end
			if cdByTalent_fix then
				GameTooltip:AddLine("|cffffaaaa"..L.cd2AddSpellFrameCDChange..": |r")
				for j=1,#readiness_lines do
					GameTooltip:AddLine(readiness_lines[j])
				end
			end
		end
		if module.db.spell_charge_fix[self.line[1]] then
			if module.db.spell_charge_fix[self.line[1]] == 1 then
				GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameCharge.."|r")
			else
				GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameChargeChange..":|r")
				local sname = GetSpellInfo(module.db.spell_charge_fix[self.line[1]]) or "???"
				GameTooltip:AddLine("|cffffffff - "..sname .."|r")
			end
		end
		do
			for auraID,sID in pairs(module.db.spell_aura_list) do
				if sID == self.line[1] then
					local sname = GetSpellInfo(auraID) or "???"
					GameTooltip:AddLine("|cffaaffaa"..L.cd2AddSpellFrameDurationLost..":|r")
					GameTooltip:AddLine("|cffffffff - \""..sname.."\"|r")
				end
			end
		end
		if module.db.spell_sharingCD[self.line[1]] then
			GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameSharing..": |r")
			for otherID,otherCD in pairs(module.db.spell_sharingCD[self.line[1]]) do
				local sname = GetSpellInfo(otherID) or "???"
				GameTooltip:AddLine("|cffffffff - "..sname .." (".. otherCD ..")|r")
			end
		end
		if module.db.spell_dispellsList[self.line[1]] then
			GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameDispel.."|r")
		end
		if module.db.spell_talentReplaceOther[self.line[1]] then
			local spellID = module.db.spell_talentReplaceOther[self.line[1]]
			local sname
			if type(spellID)=='table' then
				for i=1,#spellID do
					local sname = GetSpellInfo(spellID[i]) or "???"
					GameTooltip:AddLine("|cffffaaaa"..L.cd2AddSpellFrameReplace .." ".. sname .."|r")
				end
			else
				local sname = GetSpellInfo(spellID) or "???"
				GameTooltip:AddLine("|cffffaaaa"..L.cd2AddSpellFrameReplace .." ".. sname .."|r")
			end
		end
		GameTooltip:Show()
	end
	local function AddSpellFrameButtonsOnLeave(self)
	  	self:SetBackdropBorderColor(1,1,1,0)
	  	GameTooltip_Hide()
	  	ELib.Tooltip:HideAdd()
	end
	local function AddSpellFrameButtonsOnClick(self)
		if not self.disabled then
			local class = module.options.addSpellFrame.class
			module.options:addNewSpell((class == "RACIAL" or class == "ITEMS" or class == "ESSENCES") and "ALL" or class,self.line)
			module.options.addSpellFrame:Hide()
		end
	end
	
	self.addSpellFrame.buttonsMax = 0
	for classNum=1,#module.db.classNames do
		local now = #module.db.allClassSpells[ module.db.classNames[classNum] ]
		self.addSpellFrame.buttonsMax = max(self.addSpellFrame.buttonsMax,now)
	end
	self.addSpellFrame.buttonsMax = max(self.addSpellFrame.buttonsMax,#module.db.allClassSpells["PET"])
	--self.addSpellFrame:SetHeight( 82 + 35 * ceil( self.addSpellFrame.buttonsMax / 4 ) )
	self.addSpellFrame:SetHeight( 420 )
	
	self.addSpellFrame.buttons = {}
	for i=1,self.addSpellFrame.buttonsMax do
		local buttonFrame = CreateFrame("Button",nil,self.addSpellFrame)
		self.addSpellFrame.buttons[i] = buttonFrame
		buttonFrame:SetPoint("TOPLEFT",(i-1)%4 * 130 + 15 + 200,-floor((i-1)/4) * 35 - 60 - 57)
		buttonFrame:SetSize(130,35)
		buttonFrame:SetBackdrop({edgeFile = ExRT.F.defBorder, edgeSize = 8})
		buttonFrame:SetBackdropBorderColor(1,1,1,0)
		
		buttonFrame:SetScript("OnEnter",AddSpellFrameButtonsOnEnter)
		buttonFrame:SetScript("OnLeave",AddSpellFrameButtonsOnLeave)
		
		buttonFrame:SetScript("OnClick",AddSpellFrameButtonsOnClick)
		
		buttonFrame.icon = buttonFrame:CreateTexture(nil, "BACKGROUND")
		buttonFrame.icon:SetSize(24,24)
		buttonFrame.icon:SetPoint("TOPLEFT",5,-5)
		
		buttonFrame.text = ELib:Text(buttonFrame,"",12):Size(99,31):Point(33,-2):Color():Shadow()
	end

	function module.options:addNewSpell(class,line,doNotScroll)
		local sbmin,sbmax = module.options.ScrollBar:GetMinMaxValues()
		--module.options.ScrollBar:SetMinMaxValues(sbmin,sbmax+1)
		if line then
			if class ~= "PET" then
				module.db.spellDB[#module.db.spellDB+1] = {line[1],class,line[3],line[4],line[5],line[6],line[7],user=true}
				for j=3,7 do
					if line[j] and not VExRT.ExCD2.CDECol[ line[j][1] .. ";" .. (j-2) ] then
						VExRT.ExCD2.CDECol[ line[j][1] .. ";" .. (j-2) ] = line[2]
					end
				end
			else
				local cd,dur = 0,0
				for petName,petData in pairs(module.db.petsAbilities) do
					for j=2,#petData do
						if petData[j][1] == line[1] then
							cd = petData[j][2]
							dur = petData[j][3] or 0
							break
						end
					end
				end
				module.db.spellDB[#module.db.spellDB+1] = {line[1],line[3],{line[1],cd,dur},user=true}
				if not VExRT.ExCD2.CDECol[ line[1] .. ";1" ] then
					VExRT.ExCD2.CDECol[ line[1] .. ";1" ] = line[2]
				end
			end
		else
			module.db.spellDB[#module.db.spellDB+1] = {0,class,user=true}
		end
		module.options.ScrollBar:UpdateRange()
		if not doNotScroll then
			module.options.ScrollBar:SetValue(sbmax+31)
			module.options:ReloadSpellsPage()
		end
		SyncUserDB()
		UpdateRoster()
	end
	
	self.addSpellFrame.OnShow = function (self)
		self.dropDown:SetValue(self.CURR_CLASS or module.db.classNames[math.random(1,#module.db.classNames)])
	end
	
	self.tab.tabs[1].decorationLine = CreateFrame("Frame",nil,self.tab.tabs[1])
	self.tab.tabs[1].decorationLine.texture = self.tab.tabs[1].decorationLine:CreateTexture(nil, "BACKGROUND")
	self.tab.tabs[1].decorationLine:SetPoint("TOPLEFT",self.tab.tabs[1],-8,-8)
	self.tab.tabs[1].decorationLine:SetPoint("BOTTOMRIGHT",self.tab.tabs[1],"TOPRIGHT",8,-28)
	self.tab.tabs[1].decorationLine.texture:SetAllPoints()
	self.tab.tabs[1].decorationLine.texture:SetColorTexture(1,1,1,1)
	self.tab.tabs[1].decorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
	
	self.tab1tab = ELib:Tabs(self.tab.tabs[1],0,L.cd2Spells,L.cd2Columns):Size(600,100):Point(0,0)
	self.tab1tab:SetBackdrop({})
	local function SetFirstTabFrame(self)
		if self._i == 1 then
			module.options.borderList:Show()
			module.options.colsSpells:Hide()
		else
			module.options.borderList:Hide()
			module.options.colsSpells:Show()		
		end
	end
	for i=1,2 do
		local frame = self.tab1tab.tabs[i].button
		frame:ClearAllPoints()
		if i == 1 then
			frame:SetPoint("TOPLEFT",self.tab.tabs[1],"TOPLEFT",10,-4)
		else
			frame:SetPoint("LEFT", self.tab1tab.tabs[1].button, "RIGHT", 0, 0)
		end
		frame._i = i
		frame.additionalFunc = SetFirstTabFrame
	end
	
	self.colsSpells = CreateFrame("Frame",nil,self.tab.tabs[1])
	self.colsSpells:SetSize(650,SPELL_PAGE_HEIGHT)
	self.colsSpells:SetPoint("TOP", 0, -38)
	ELib:Border(self.colsSpells,2,.24,.25,.30,1)
	self.colsSpells:Hide()
	
	self.colsSpells.ScrollFrame = CreateFrame("ScrollFrame", nil, self.colsSpells)
	self.colsSpells.ScrollFrame:SetPoint("TOPLEFT")
	self.colsSpells.ScrollFrame:SetPoint("BOTTOMRIGHT")
	
	self.colsSpells.C = CreateFrame("Frame", nil, self.colsSpells) 
	self.colsSpells.C:SetSize(650,SPELL_PAGE_HEIGHT+50)
	self.colsSpells.ScrollFrame:SetScrollChild(self.colsSpells.C)
	
	local function ColsSpellsUpdate()
		local val = self.colsSpells.ScrollBar:GetValue()
		self.colsSpells.ScrollBar:UpdateButtons()
		module.options.colsSpells.ScrollFrame:SetVerticalScroll( val % 24 )
		val = floor( val / 24 ) + 1
		local line = 0
		local count = 0
		for i=1,#module.db.spellDB do
			local spellData = module.db.spellDB[i]
			local spellID = spellData[1]
			if VExRT_CDE[ spellID ] then
				local class = spellData[2]
				local specsCount = module.db.specByClass[class] and #module.db.specByClass[class] or 1
			
				for j=3,3+specsCount do
					if spellData[j] then
						count = count + 1
						if count >= val then
							line = line + 1
							if line > #self.colsSpells.lines then
								return
							end
							local lineFrame = self.colsSpells.lines[line]
							lineFrame:Show()
							
							local spellName,_,spellTexture = GetSpellInfo(spellID)
							lineFrame.icon:SetTexture(spellTexture)
							lineFrame.spellName:SetText(spellName)
							lineFrame.link = "spell:"..(spellData[j][1] or spellID)
							
							if j == 3 then
								lineFrame.iconSpec:Hide()
							else
								lineFrame.iconSpec:Show()
								lineFrame.iconSpec:SetTexture( module.db.specIcons[ module.db.specByClass[class][j - 2] ] or "" )
							end
							
							if CLASS_ICON_TCOORDS[class] then
								lineFrame.iconClass:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
								lineFrame.iconClass:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
							else
								lineFrame.iconClass:SetTexture("")
							end
							
							for k=1,10 do
								lineFrame.chk[k]:SetChecked(false)
							end
							local checked = VExRT.ExCD2.CDECol[spellData[j][1]..";"..(j-2)] or module.db.def_col[spellData[j][1]..";"..(j-2)] or 1
							lineFrame.chk[checked]:SetChecked(true)
							
							lineFrame.spellID = spellData[j][1]
							lineFrame.specNum = j-2
						end
					end
				end
			end
		end
		for i=line+1,#self.colsSpells.lines do
			self.colsSpells.lines[i]:Hide()
		end
	end
	self.colsSpells:SetScript("OnShow",function(self)
		local count = 0
		for i=1,#module.db.spellDB do
			local spellData = module.db.spellDB[i]
			if VExRT_CDE[ spellData[1] ] then
				local class = spellData[2]
				local specsCount = module.db.specByClass[class] and #module.db.specByClass[class] or 1
				for j=3,3+specsCount do
					if spellData[j] then
						count =  count + 1
					end
				end
			end
		end
	
		self.ScrollBar:SetMinMaxValues(0,max(0,(count+0.2)*24-SPELL_PAGE_HEIGHT))
		ColsSpellsUpdate()
	end)
	self.colsSpells:SetScript("OnMouseWheel", function(self, delta)
		delta = -delta
		local current = module.options.colsSpells.ScrollBar:GetValue()
		local min_,max_ = module.options.colsSpells.ScrollBar:GetMinMaxValues()
		current = current + delta * 24
		if current > max_ then
			current = max_
		elseif current < min_ then
			current = min_
		end
		module.options.colsSpells.ScrollBar:SetValue(current)
	end)
	
	self.colsSpells.ScrollBar = ELib:ScrollBar(self.colsSpells):Size(16,0):Point("TOPRIGHT",-3,-3):Point("BOTTOMRIGHT",-3,3):Range(0,SPELL_PAGE_HEIGHT):SetTo(0):OnChange(ColsSpellsUpdate)
	self.colsSpells.ScrollBar.slider:SetObeyStepOnDrag(true)
	
	self.colsSpells.lines = {}
	local function ColsSpellsSpellTooltipOnEnter(self)
		ELib.Tooltip.Link(self,self:GetParent().link)
	end
	local function ColsSpellsSpellCheckboxClick(self)
		for j=1,10 do
			if j ~= self._i then
				self.array[j]:SetChecked(false)
			end
		end
		if not self:GetChecked() then
			self:SetChecked(true)
		end
		VExRT.ExCD2.CDECol[self.main.spellID..";"..self.main.specNum] = self._i
		
		UpdateRoster()
	end
	for i=1,23 do
		local frame = CreateFrame("Frame",nil,self.colsSpells.C)
		self.colsSpells.lines[i] = frame
		frame:SetPoint("TOPLEFT",5,-3-(i-1)*24)
		frame:SetSize(577,24)
		
		frame.icon = frame:CreateTexture(nil, "ARTWORK")
		frame.icon:SetSize(22,22)
		frame.icon:SetPoint("TOPLEFT", 2, 0)
		frame.icon:SetTexCoord(.1,.9,.1,.9)
		ELib:Border(frame.icon,1,.12,.13,.15,1)
		
		frame.tooltipFrame = CreateFrame("Frame",nil,frame)
		frame.tooltipFrame:SetSize(150,24) 
		frame.tooltipFrame:SetPoint("TOPLEFT", 30, 0)
		frame.tooltipFrame:SetScript("OnEnter", ColsSpellsSpellTooltipOnEnter)
		frame.tooltipFrame:SetScript("OnLeave", GameTooltip_Hide)
		
		frame.spellName = ELib:Text(frame):Size(156,24):Point(29,0):Font(ExRT.F.defFont,11):Shadow():Color()
	
		frame.iconClass = frame:CreateTexture(nil, "ARTWORK")
		frame.iconClass:SetSize(18,18)
		frame.iconClass:SetPoint("TOPLEFT", 180, -3)
		
		frame.iconSpec = frame:CreateTexture(nil, "ARTWORK")
		frame.iconSpec:SetSize(18,18)
		frame.iconSpec:SetPoint("TOPLEFT", 200, -3)
		
		frame.chk = {}
		for j=1,10 do
			frame.chk[j] = ELib:Check(frame):Point("LEFT",240 + (j-1) * 25,0):Tooltip(j):OnClick(ColsSpellsSpellCheckboxClick)
			frame.chk[j].array = frame.chk
			frame.chk[j]._i = j
			frame.chk[j].main = frame
		end
	end
	
	module.options.ScrollBar:UpdateRange()
	module.options:ReloadSpellsPage()
	

	--> OPTIONS TAB2: Customize
	self.optColHeader = ELib:Text(self.tab.tabs[2],L.cd2ColSet):Size(560,20):Point(15,-8)
	
	function self:selectColumnTab()
		local i = self and self.colID or module.options.optColTabs.selected
		module.options.optColTabs.selected = i
		module.options.optColTabs:UpdateTabs()
		
		local isGeneralTab = i == (module.db.maxColumns + 1)
		
		if isGeneralTab then
			VExRT.ExCD2.colSet[i].frameGeneral = nil
			VExRT.ExCD2.colSet[i].iconGeneral = nil
			VExRT.ExCD2.colSet[i].textureGeneral = nil
			VExRT.ExCD2.colSet[i].fontGeneral = nil
			VExRT.ExCD2.colSet[i].textGeneral = nil
			VExRT.ExCD2.colSet[i].methodsGeneral = nil
		end

		module.options.optColSet.chkEnable:SetChecked(VExRT.ExCD2.colSet[i].enabled)
		module.options.optColSet.chkGeneral:SetChecked(VExRT.ExCD2.colSet[i].frameGeneral)
		
		module.options.optColSet.sliderLinesNum:SetValue(VExRT.ExCD2.colSet[i].frameLines or module.db.colsDefaults.frameLines)
		module.options.optColSet.sliderAlpha:SetValue(VExRT.ExCD2.colSet[i].frameAlpha or module.db.colsDefaults.frameAlpha)
		module.options.optColSet.sliderScale:SetValue(VExRT.ExCD2.colSet[i].frameScale or module.db.colsDefaults.frameScale)
		module.options.optColSet.sliderWidth:SetValue(VExRT.ExCD2.colSet[i].frameWidth or module.db.colsDefaults.frameWidth)
		module.options.optColSet.sliderColsInCol:SetValue(VExRT.ExCD2.colSet[i].frameColumns or module.db.colsDefaults.frameColumns)
		module.options.optColSet.sliderBetweenLines:SetValue(VExRT.ExCD2.colSet[i].frameBetweenLines or module.db.colsDefaults.frameBetweenLines)
		module.options.optColSet.sliderBlackBack:SetValue(VExRT.ExCD2.colSet[i].frameBlackBack or module.db.colsDefaults.frameBlackBack)
		
		module.options.optColSet.chkGeneral:doAlphas()
		
		module.options.optColSet.sliderHeight:SetValue(VExRT.ExCD2.colSet[i].iconSize or module.db.colsDefaults.iconSize)
		module.options.optColSet.chkGray:SetChecked(VExRT.ExCD2.colSet[i].iconGray)
		module.options.optColSet.chkCooldown:SetChecked(VExRT.ExCD2.colSet[i].methodsCooldown)	
		module.options.optColSet.chkCooldownHideNumbers:SetChecked(VExRT.ExCD2.colSet[i].iconCooldownHideNumbers)	
		module.options.optColSet.chkCooldownShowSwipe:SetChecked(VExRT.ExCD2.colSet[i].iconCooldownShowSwipe)	
		module.options.optColSet.chkShowTitles:SetChecked(VExRT.ExCD2.colSet[i].iconTitles)	
		module.options.optColSet.chkHideBlizzardEdges:SetChecked(VExRT.ExCD2.colSet[i].iconHideBlizzardEdges)	
		module.options.optColSet.chkGeneralIcons:SetChecked(VExRT.ExCD2.colSet[i].iconGeneral)
		do
			local defIconPos = VExRT.ExCD2.colSet[i].iconPosition or module.db.colsDefaults.iconPosition
			module.options.optColSet.dropDownIconPos:SetText( module.options.optColSet.dropDownIconPos.PosNames[defIconPos])	
		end
		
		module.options.optColSet.chkGeneralIcons:doAlphas()
		
		do
			local texturePos = nil
			for j=1,#ExRT.F.textureList do
				if ExRT.F.textureList[j] == (VExRT.ExCD2.colSet[i].textureFile or ExRT.F.barImg) then
					texturePos = j
					break
				end
			end
			if not texturePos and VExRT.ExCD2.colSet[i].textureFile then
				texturePos = select(3,string.find(VExRT.ExCD2.colSet[i].textureFile,"\\([^\\]*)$"))
			end
			texturePos = texturePos or "Standart"
			module.options.optColSet.dropDownTexture:SetText(L.cd2OtherSetTexture.." ["..texturePos.."]")
		end
		module.options.optColSet.colorPickerBorder.color:SetColorTexture(VExRT.ExCD2.colSet[i].textureBorderColorR or module.db.colsDefaults.textureBorderColorR,VExRT.ExCD2.colSet[i].textureBorderColorG or module.db.colsDefaults.textureBorderColorG,VExRT.ExCD2.colSet[i].textureBorderColorB or module.db.colsDefaults.textureBorderColorB, VExRT.ExCD2.colSet[i].textureBorderColorA or module.db.colsDefaults.textureBorderColorA)
		module.options.optColSet.sliderBorderSize:SetValue(VExRT.ExCD2.colSet[i].textureBorderSize or module.db.colsDefaults.textureBorderSize)
		module.options.optColSet.chkAnimation:SetChecked(VExRT.ExCD2.colSet[i].textureAnimation)
		module.options.optColSet.chkHideSpark:SetChecked(VExRT.ExCD2.colSet[i].textureHideSpark)
		module.options.optColSet.chkSmoothAnimation:SetChecked(VExRT.ExCD2.colSet[i].textureSmoothAnimation)
		module.options.optColSet.sliderSmoothAnimationDuration:SetValue(VExRT.ExCD2.colSet[i].textureSmoothAnimationDuration or module.db.colsDefaults.textureSmoothAnimationDuration)
		module.options.optColSet.chkGeneralColorize:SetChecked(VExRT.ExCD2.colSet[i].textureGeneral)
		
		module.options.optColSet.chkGeneralColorize:doAlphas()
			
		do
			local FontNameForDropDown = select(3,string.find(VExRT.ExCD2.colSet[i].fontName or module.db.colsDefaults.fontName,"\\([^\\]*)$"))
			module.options.optColSet.dropDownFont:SetText( (FontNameForDropDown or VExRT.ExCD2.colSet[i].fontName or module.db.colsDefaults.fontName or "?") )
		end
		module.options.optColSet.sliderFont:SetValue(VExRT.ExCD2.colSet[i].fontSize or module.db.colsDefaults.fontSize)
		module.options.optColSet.chkFontOutline:SetChecked(VExRT.ExCD2.colSet[i].fontOutline)
		module.options.optColSet.chkFontShadow:SetChecked(VExRT.ExCD2.colSet[i].fontShadow)
		do
			module.options.optColSet.chkFontOtherAvailable:SetChecked(VExRT.ExCD2.colSet[i].fontOtherAvailable)
			module.options.fontOtherAvailable(VExRT.ExCD2.colSet[i].fontOtherAvailable)
			if VExRT.ExCD2.colSet[i].fontOtherAvailable then
				module.options.optColSet.nowFont = "fontLeft"
			else
				module.options.optColSet.nowFont = "font"
			end
			module.options.optColSet.fontsTab.selectFunc(module.options.optColSet.fontsTab.tabs[1].button)
		end
		module.options.optColSet.chkGeneralFont:SetChecked(VExRT.ExCD2.colSet[i].fontGeneral)
		
		module.options.optColSet.chkGeneralFont:doAlphas()
		
		module.options.optColSet.textLeftTemEdit:SetText(VExRT.ExCD2.colSet[i].textTemplateLeft or module.db.colsDefaults.textTemplateLeft)
		module.options.optColSet.textRightTemEdit:SetText(VExRT.ExCD2.colSet[i].textTemplateRight or module.db.colsDefaults.textTemplateRight)
		module.options.optColSet.textCenterTemEdit:SetText(VExRT.ExCD2.colSet[i].textTemplateCenter or module.db.colsDefaults.textTemplateCenter)
		module.options.optColSet.chkIconName:SetChecked(VExRT.ExCD2.colSet[i].textIconName)
		module.options.optColSet.chkGeneralText:SetChecked(VExRT.ExCD2.colSet[i].textGeneral)
		
		module.options.optColSet.chkGeneralText:doAlphas()

		module.options.optColSet.chkShowOnlyOnCD:SetChecked(VExRT.ExCD2.colSet[i].methodsShownOnCD)
		module.options.optColSet.chkBotToTop:SetChecked(VExRT.ExCD2.colSet[i].frameAnchorBottom)
		module.options.optColSet.chkGeneralMethods:SetChecked(VExRT.ExCD2.colSet[i].methodsGeneral)
		do
			local defStyleAnimation = VExRT.ExCD2.colSet[i].methodsStyleAnimation or module.db.colsDefaults.methodsStyleAnimation
			module.options.optColSet.dropDownStyleAnimation:SetText( module.options.optColSet.dropDownStyleAnimation.Styles[defStyleAnimation])
			local defTimeLineAnimation = VExRT.ExCD2.colSet[i].methodsTimeLineAnimation or module.db.colsDefaults.methodsTimeLineAnimation
			module.options.optColSet.dropDownTimeLineAnimation:SetText(module.options.optColSet.dropDownTimeLineAnimation.Styles[defTimeLineAnimation])
			
			local defSortingRules = VExRT.ExCD2.colSet[i].methodsSortingRules or module.db.colsDefaults.methodsSortingRules
			module.options.optColSet.dropDownSortingRules:SetText(module.options.optColSet.dropDownSortingRules.Rules[defSortingRules])			
		end
		module.options.optColSet.chkIconTooltip:SetChecked(VExRT.ExCD2.colSet[i].methodsIconTooltip)
		module.options.optColSet.chkLineClick:SetChecked(VExRT.ExCD2.colSet[i].methodsLineClick)
		module.options.optColSet.chkLineClickWhisper:SetChecked(VExRT.ExCD2.colSet[i].methodsLineClickWhisper)
		module.options.optColSet.chkNewSpellNewLine:SetChecked(VExRT.ExCD2.colSet[i].methodsNewSpellNewLine)
		module.options.optColSet.chkHideOwnSpells:SetChecked(VExRT.ExCD2.colSet[i].methodsHideOwnSpells)
		module.options.optColSet.chkAlphaNotInRange:SetChecked(VExRT.ExCD2.colSet[i].methodsAlphaNotInRange)
		module.options.optColSet.sliderAlphaNotInRange:SetValue(VExRT.ExCD2.colSet[i].methodsAlphaNotInRangeNum or module.db.colsDefaults.methodsAlphaNotInRangeNum)
		module.options.optColSet.chkDisableActive:SetChecked(VExRT.ExCD2.colSet[i].methodsDisableActive)
		module.options.optColSet.chkOneSpellPerCol:SetChecked(VExRT.ExCD2.colSet[i].methodsOneSpellPerCol)
		module.options.optColSet.chkOnlyInCombat:SetChecked(VExRT.ExCD2.colSet[i].methodsOnlyInCombat)

		module.options.optColSet.chkGeneralMethods:doAlphas()
		
		module.options.optColSet.blacklistEditBox.EditBox:SetText(VExRT.ExCD2.colSet[i].blacklistText or module.db.colsDefaults.blacklistText)
		module.options.optColSet.whitelistEditBox.EditBox:SetText(VExRT.ExCD2.colSet[i].whitelistText or module.db.colsDefaults.whitelistText)
		module.options.optColSet.chkGeneralBlackList:SetChecked(VExRT.ExCD2.colSet[i].blacklistGeneral)		
		
		module.options.optColSet.chkGeneralBlackList:doAlphas()
		
		module.options.optColSet.chkVisibilityPartyTypeAlways:SetChecked(not VExRT.ExCD2.colSet[i].visibilityPartyType)
		module.options.optColSet.chkVisibilityPartyTypeParty:SetChecked(VExRT.ExCD2.colSet[i].visibilityPartyType == 1)
		module.options.optColSet.chkVisibilityPartyTypeRaid:SetChecked(VExRT.ExCD2.colSet[i].visibilityPartyType == 2)
		module.options.optColSet.chkVisibilityZoneArena:SetChecked(not VExRT.ExCD2.colSet[i].visibilityDisableArena)
		module.options.optColSet.chkVisibilityZoneBG:SetChecked(not VExRT.ExCD2.colSet[i].visibilityDisableBG)
		module.options.optColSet.chkVisibilityZoneScenario:SetChecked(not VExRT.ExCD2.colSet[i].visibilityDisable3ppl)
		module.options.optColSet.chkVisibilityZone5ppl:SetChecked(not VExRT.ExCD2.colSet[i].visibilityDisable5ppl)
		module.options.optColSet.chkVisibilityZoneRaid:SetChecked(not VExRT.ExCD2.colSet[i].visibilityDisableRaid)
		module.options.optColSet.chkVisibilityZoneOutdoor:SetChecked(not VExRT.ExCD2.colSet[i].visibilityDisableWorld)
		module.options.optColSet.chkGeneralVisibility:SetChecked(VExRT.ExCD2.colSet[i].visibilityGeneral)

		module.options.optColSet.chkGeneralVisibility:doAlphas()

		ExRT.lib.ShowOrHide(module.options.optColSet.chkEnable,not isGeneralTab)
		ExRT.lib.ShowOrHide(module.options.optColSet.chkGeneral,not isGeneralTab)

		ExRT.lib.ShowOrHide(module.options.optColSet.chkGeneralIcons,not isGeneralTab)
		ExRT.lib.ShowOrHide(module.options.optColSet.chkGeneralColorize,not isGeneralTab)
		ExRT.lib.ShowOrHide(module.options.optColSet.chkGeneralFont,not isGeneralTab)
		ExRT.lib.ShowOrHide(module.options.optColSet.chkGeneralText,not isGeneralTab)
		ExRT.lib.ShowOrHide(module.options.optColSet.chkGeneralMethods,not isGeneralTab)
		ExRT.lib.ShowOrHide(module.options.optColSet.chkGeneralVisibility,not isGeneralTab)
		ExRT.lib.ShowOrHide(module.options.optColSet.chkGeneralBlackList,not isGeneralTab)
		
		ExRT.lib.ShowOrHide(module.options.optColSet.chkSortByAvailability,isGeneralTab)
		ExRT.lib.ShowOrHide(module.options.optColSet.chkSortByAvailability_activeToTop,isGeneralTab)
		ExRT.lib.ShowOrHide(module.options.optColSet.chkReverseSorting,isGeneralTab)
		
		module.options.showColorFrame(module.options.colorSetupFrame)
		
		if self then
			module.options.optColSet.templateRestore:Hide()
		end
	end

	self.optColSet = {}
	do
		local tmpArr = {}
		for i=1,module.db.maxColumns do
			tmpArr[i] = tostring(i)
		end
		tmpArr[module.db.maxColumns+1] = L.cd2GeneralSet
		self.optColTabs = ELib:Tabs(self.tab.tabs[2],0,unpack(tmpArr)):Size(660,417):Point(0,-48):SetTo(module.db.maxColumns+1)
	end
	for i=1,module.db.maxColumns+1 do
		self.optColTabs.tabs[i].button.colID = i
		self.optColTabs.tabs[i].button:SetScript("OnClick", self.selectColumnTab)
	end
	
	self.optColTabs:SetBackdropBorderColor(0,0,0,0)
	self.optColTabs:SetBackdropColor(0,0,0,0)
	
	self.tab.tabs[2].decorationLine = CreateFrame("Frame",nil,self.tab.tabs[2])
	self.tab.tabs[2].decorationLine.texture = self.tab.tabs[2].decorationLine:CreateTexture(nil, "BACKGROUND")
	self.tab.tabs[2].decorationLine:SetPoint("TOPLEFT",self.tab.tabs[2],-8,-28)
	self.tab.tabs[2].decorationLine:SetPoint("BOTTOMRIGHT",self.tab.tabs[2],"TOPRIGHT",8,-48)
	self.tab.tabs[2].decorationLine.texture:SetAllPoints()
	self.tab.tabs[2].decorationLine.texture:SetColorTexture(1,1,1,1)
	self.tab.tabs[2].decorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

	 
	self.optColSet.superTabFrame = ExRT.lib:ScrollTabsFrame(self.optColTabs,L.cd2OtherSetTabNameGeneral,L.cd2OtherSetTabNameIcons,L.cd2OtherSetTabNameColors,L.cd2OtherSetTabNameFont,L.cd2OtherSetTabNameText,L.cd2OtherSetTabNameOther,L.cd2OtherSetTabNameVisibility,L.cd2OtherSetTabNameBlackList,L.cd2OtherSetTabNameTemplate):Size(660,450):Point("TOP",0,-10)	
	
	self.optColSet.chkEnable = ELib:Check(self.optColSet.superTabFrame.tab[1],"|cff00ff00 >>>"..L.senable.."<<<"):Point(10,-10):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].enabled = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].enabled = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkGeneral = ELib:Check(self.optColSet.superTabFrame.tab[1],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameGeneral = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneral:doAlphas()
		ExRT.lib.SetAlphas(VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.sliderLinesNum,module.options.optColSet.sliderAlpha,module.options.optColSet.sliderScale,module.options.optColSet.sliderWidth,module.options.optColSet.sliderColsInCol,module.options.optColSet.sliderBetweenLines,module.options.optColSet.sliderBlackBack,module.options.optColSet.butToCenter)	
	end
	
	self.optColSet.sliderLinesNum = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2lines):Size(400):Point("TOP",0,-50):Range(1,module.db.maxLinesInCol):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameLines = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()		
	end)
	
	self.optColSet.sliderWidth = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2width):Size(400):Point("TOP",0,-85):Range(1,400):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameWidth = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)
	
	self.optColSet.sliderAlpha = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2alpha):Size(400):Point("TOP",0,-120):Range(0,100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameAlpha = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)
	
	self.optColSet.sliderScale = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2scale):Size(400):Point("TOP",0,-155):Range(5,200):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameScale = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits("ScaleFix")
	end)
	
	self.optColSet.sliderColsInCol = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2ColSetColsInCol):Size(400):Point("TOP",0,-190):Range(1,module.db.maxLinesInCol):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameColumns = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)
	
	self.optColSet.sliderBetweenLines = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2ColSetBetweenLines):Size(400):Point("TOP",0,-225):Range(0,20):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameBetweenLines = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)
	
	self.optColSet.sliderBlackBack = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2BlackBack):Size(400):Point("TOP",0,-260):Range(0,100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameBlackBack = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)

	self.optColSet.butToCenter = ELib:Button(self.optColSet.superTabFrame.tab[1],L.cd2ColSetResetPos):Size(200,20):Point("TOP",0,-295):OnClick(function(self) 
		if (module.db.maxColumns + 1) == module.options.optColTabs.selected then
			module.frame:ClearAllPoints()
			module.frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
		else
			module.frame.colFrame[module.options.optColTabs.selected]:ClearAllPoints()
			module.frame.colFrame[module.options.optColTabs.selected]:SetPoint("CENTER",UIParent,"CENTER",0,0)
		end
	end) 

	--> Icon and height options
	
	self.optColSet.sliderHeight = ELib:Slider(self.optColSet.superTabFrame.tab[2],L.cd2OtherSetIconSize):Size(400):Point("TOP",0,-50):Range(6,128):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconSize = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.optColSet.chkGray = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2graytooltip):Point(10,-110):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconGray = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconGray = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.textIconPos = ELib:Text(self.optColSet.superTabFrame.tab[2],L.cd2OtherSetIconPosition..":"):Size(200,20):Point(10,-85)
	self.optColSet.dropDownIconPos = ELib:DropDown(self.optColSet.superTabFrame.tab[2],190,3):Size(200):Point(180,-85)
	self.optColSet.dropDownIconPos.PosNames = {L.cd2OtherSetIconPositionLeft,L.cd2OtherSetIconPositionRight,L.cd2OtherSetIconPositionNo}
	for i=1,#self.optColSet.dropDownIconPos.PosNames do
		self.optColSet.dropDownIconPos.List[i] = {
			text = self.optColSet.dropDownIconPos.PosNames[i],
			arg1 = i,
			func = function (self,arg)
				ELib:DropDownClose()
				VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconPosition = arg
				module:ReloadAllSplits()
				module.options.optColSet.dropDownIconPos:SetText(module.options.optColSet.dropDownIconPos.PosNames[arg])
			end,
		}
	end
	
	self.optColSet.chkCooldown = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ColSetMethodCooldown):Point(10,-135):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsCooldown = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsCooldown = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkCooldownHideNumbers = ELib:Check(self.optColSet.superTabFrame.tab[2],L.BattleResHideTime):Point("TOPLEFT",self.optColSet.chkCooldown,25,-25):Tooltip(L.BattleResHideTimeTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconCooldownHideNumbers = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconCooldownHideNumbers = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkCooldownShowSwipe = ELib:Check(self.optColSet.superTabFrame.tab[2],"Show edge"):Point("TOPLEFT",self.optColSet.chkCooldownHideNumbers,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconCooldownShowSwipe = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconCooldownShowSwipe = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkShowTitles = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ColSetShowTitles):Point("TOPLEFT",self.optColSet.chkCooldown,0,-75):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconTitles = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconTitles = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkHideBlizzardEdges = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ColSetIconHideBlizzardEdges):Point("TOPLEFT",self.optColSet.chkShowTitles,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconHideBlizzardEdges = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconHideBlizzardEdges = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkGeneralIcons = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconGeneral = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralIcons:doAlphas()
		ExRT.lib.SetAlphas(VExRT.ExCD2.colSet[module.options.optColTabs.selected].iconGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.chkGray,module.options.optColSet.sliderHeight,module.options.optColSet.dropDownIconPos,module.options.optColSet.chkCooldown,module.options.optColSet.chkShowTitles,module.options.optColSet.chkHideBlizzardEdges,module.options.optColSet.chkCooldownShowSwipe,module.options.optColSet.chkCooldownHideNumbers)
	end
	
	--> Texture and colors Options
	
	local function dropDownTextureButtonClick(self,arg,name)
		ELib:DropDownClose()
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureFile = arg
		module:ReloadAllSplits()
		module.options.optColSet.dropDownTexture:SetText(L.cd2OtherSetTexture.." ["..name.."]")
	end

	self.optColSet.textDDTexture = ELib:Text(self.optColSet.superTabFrame.tab[3],L.cd2OtherSetTexture..":"):Size(200,20):Point(10,-35)
	self.optColSet.dropDownTexture = ELib:DropDown(self.optColSet.superTabFrame.tab[3],200,15):Size(200):Point(180,-35)
	for i=1,#ExRT.F.textureList do
		self.optColSet.dropDownTexture.List[i] = {}
		local info = self.optColSet.dropDownTexture.List[i]
		info.text = i
		info.arg1 = ExRT.F.textureList[i]
		info.arg2 = i
		info.func = dropDownTextureButtonClick
		info.texture = ExRT.F.textureList[i]
		info.justifyH = "CENTER" 
	end
	if LibStub then
		local loaded,media = pcall(LibStub,"LibSharedMedia-3.0")
		if loaded and media then
			local barsList = media:HashTable("statusbar")
			if barsList then
				local count = #self.optColSet.dropDownTexture.List
				for key,texture in pairs(barsList) do
					count = count + 1
					self.optColSet.dropDownTexture.List[count] = {}
					local info = self.optColSet.dropDownTexture.List[count]
					
					info.text = key
					info.arg1 = texture
					info.arg2 = key
					info.func = dropDownTextureButtonClick
					info.texture = texture
					info.justifyH = "CENTER" 
				end
			end
		end
	end
	
	self.optColSet.textDDBorder = ELib:Text(self.optColSet.superTabFrame.tab[3],L.cd2OtherSetBorder..":"):Size(200,20):Point(10,-65)
	self.optColSet.sliderBorderSize = ELib:Slider(self.optColSet.superTabFrame.tab[3],""):Size(170):Point(180,-68):Range(0,20):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderSize = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)
	self.optColSet.colorPickerBorder = ExRT.lib.CreateColorPickButton(self.optColSet.superTabFrame.tab[3],20,20,nil,361,-65)
	self.optColSet.colorPickerBorder:SetScript("OnClick",function (self)
		ColorPickerFrame.previousValues = {VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorR or module.db.colsDefaults.textureBorderColorR,VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorG or module.db.colsDefaults.textureBorderColorG,VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorB or module.db.colsDefaults.textureBorderColorB, VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorA or module.db.colsDefaults.textureBorderColorA}
		ColorPickerFrame.hasOpacity = true
		local nilFunc = ExRT.NULLfunc
		local function changedCallback(restore)
			local newR, newG, newB, newA
			if restore then
				newR, newG, newB, newA = unpack(restore)
			else
				newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
			end
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorR = newR
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorG = newG
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorB = newB
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorA = newA
			module:ReloadAllSplits()
			
			self.color:SetColorTexture(newR,newG,newB,newA)
		end
		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = nilFunc, nilFunc, nilFunc
		ColorPickerFrame.opacity = VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorA or module.db.colsDefaults.textureBorderColorA
		ColorPickerFrame:SetColorRGB(VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorR or module.db.colsDefaults.textureBorderColorR,VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorG or module.db.colsDefaults.textureBorderColorG,VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureBorderColorB or module.db.colsDefaults.textureBorderColorB)
		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback
		ColorPickerFrame:Show()
	end)
		
	self.optColSet.chkAnimation = ELib:Check(self.optColSet.superTabFrame.tab[3],L.cd2OtherSetAnimation):Point(10,-97):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureAnimation = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureAnimation = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkHideSpark = ELib:Check(self.optColSet.superTabFrame.tab[3],L.cd2OtherSetHideSpark):Point(200,-97):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureHideSpark = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureHideSpark = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkSmoothAnimation = ELib:Check(self.optColSet.superTabFrame.tab[3],L.cd2TextureSmoothAnim):Point(10,-122):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureSmoothAnimation = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureSmoothAnimation = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.sliderSmoothAnimationDuration = ELib:Slider(self.optColSet.superTabFrame.tab[3],""):Size(140):Point("TOP",self.optColSet.chkSmoothAnimation,0,-2):Point("LEFT",self.optColSet.chkSmoothAnimation.text,"RIGHT",20,0):Range(10,200):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureSmoothAnimationDuration = event
		module:ReloadAllSplits()
		self.tooltipText = event / 100
		self:tooltipReload(self)
	end)
	self.optColSet.sliderSmoothAnimationDuration.Low:SetText("0.1")
	self.optColSet.sliderSmoothAnimationDuration.High:SetText("2")

	
	self.colorSetupFrame = CreateFrame("Frame",nil,self.optColSet.superTabFrame.tab[3])
	self.colorSetupFrame:SetSize(420,290)
	self.colorSetupFrame:SetPoint("TOP",0,-135)
		
	self.colorSetupFrame.backAlpha = ELib:Slider(self.colorSetupFrame,L.cd2OtherSetColorFrameAlpha):Size(400):Point("TOP",0,-163):Range(0,100)
	self.colorSetupFrame.backCDAlpha = ELib:Slider(self.colorSetupFrame,L.cd2OtherSetColorFrameAlphaCD):Size(400):Point("TOP",0,-198):Range(0,100)
	self.colorSetupFrame.backCooldownAlpha = ELib:Slider(self.colorSetupFrame,L.cd2OtherSetColorFrameAlphaCooldown):Size(400):Point("TOP",0,-233):Range(0,100)
	self.colorSetupFrame.backAlpha.inOptName = "textureAlphaBackground"
	self.colorSetupFrame.backCDAlpha.inOptName = "textureAlphaTimeLine"
	self.colorSetupFrame.backCooldownAlpha.inOptName = "textureAlphaCooldown"
	
	local function colorPickerButtonClick(self)
		ColorPickerFrame.previousValues = {VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName.."R"] or module.db.colsDefaults[self.inOptName.."R"],VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName.."G"] or module.db.colsDefaults[self.inOptName.."G"],VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName.."B"] or module.db.colsDefaults[self.inOptName.."B"], 1}
		local nilFunc = ExRT.NULLfunc
		local function changedCallback(restore)
			local newR, newG, newB, newA
			if restore then
				newR, newG, newB, newA = unpack(restore)
			else
				newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
			end
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName.."R"] = newR
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName.."G"] = newG
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName.."B"] = newB
			module:ReloadAllSplits()
			
			self.color:SetColorTexture(newR,newG,newB,1)
		end
		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = nilFunc, nilFunc, nilFunc
		ColorPickerFrame:SetColorRGB(VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName.."R"] or module.db.colsDefaults[self.inOptName.."R"],VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName.."G"] or module.db.colsDefaults[self.inOptName.."G"],VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName.."B"] or module.db.colsDefaults[self.inOptName.."B"])
		ColorPickerFrame.func, ColorPickerFrame.cancelFunc = changedCallback, changedCallback
		ColorPickerFrame:Show()
	end

	local function colorPickerSliderValue(self,newval)
		VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName] = newval / 100
		module:ReloadAllSplits()
		self.tooltipText = ExRT.F.Round(newval)
		self:tooltipReload(self)
	end

	local function colorPickerCheckBoxClick(self)
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName] = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.inOptName] = nil
		end
		module:ReloadAllSplits()
	end
	
	local colorSetupFrameColorsNames_TopText = {L.cd2OtherSetColorFrameTopText,L.cd2OtherSetColorFrameTopBack,L.cd2OtherSetColorFrameTopTimeLine}
	for i=1,3 do
		self.colorSetupFrame["topText"..i] = ELib:Text(self.colorSetupFrame,colorSetupFrameColorsNames_TopText[i],12):Size(50,20):Point(225+(i-1)*40,-15):Center():Color():Shadow()
	end
	
	local colorSetupFrameColorsNames_Text = {L.cd2OtherSetColorFrameText..":",L.cd2OtherSetColorFrameActive..":",L.cd2OtherSetColorFrameCooldown..":"}
	for j=1,3 do
		for i=1,3 do
			self.colorSetupFrame["color"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]] = ExRT.lib.CreateColorPickButton(self.colorSetupFrame,20,20,nil,240+(i-1)*40,-35-(j-1)*20)
			self.colorSetupFrame["color"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]].inOptName = "textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]
			self.colorSetupFrame["color"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]]:SetScript("OnClick",colorPickerButtonClick)
		end
		self.colorSetupFrame["text"..colorSetupFrameColorsNames[j]] = ELib:Text(self.colorSetupFrame,colorSetupFrameColorsNames_Text[j],12):Size(210,20):Point(10,-35-(j-1)*20):Right():Color():Shadow()
	end
	
	local checksInOptNames = {"textureClassText","textureClassBackground","textureClassTimeLine"}
	for i=1,3 do
		self.colorSetupFrame["colorClass"..colorSetupFrameColorsObjectsNames[i]] = ELib:Check(self.colorSetupFrame,""):Point(241+(i-1)*40,-117):Size(18,18):OnClick(colorPickerCheckBoxClick)	
		self.colorSetupFrame["colorClass"..colorSetupFrameColorsObjectsNames[i]].inOptName = checksInOptNames[i]
	end
	self.colorSetupFrame["textClass"] = ELib:Text(self.colorSetupFrame,L.cd2OtherSetColorFrameClass..":",12):Size(210,20):Point(10,-115):Right():Color():Shadow()
	
	self.colorSetupFrame.backAlpha:SetScript("OnValueChanged",colorPickerSliderValue)
	self.colorSetupFrame.backCDAlpha:SetScript("OnValueChanged",colorPickerSliderValue)
	self.colorSetupFrame.backCooldownAlpha:SetScript("OnValueChanged",colorPickerSliderValue)
	
	self.colorSetupFrame.resetButton = ELib:Button(self.colorSetupFrame,L.cd2OtherSetColorFrameReset):Size(160,20):Point("TOP",-81,-265)
	self.colorSetupFrame.softenButton = ELib:Button(self.colorSetupFrame,L.cd2OtherSetColorFrameSoften):Size(160,20):Point("TOP",81,-265)
	
	self.colorSetupFrame.softenButton:SetScript("OnClick",function()
		local tmpColors = {"R","G","B"}
		for j=1,3 do
			for i=1,3 do
				local maxColor = 0
				for n=1,3 do
					local color = VExRT.ExCD2.colSet[module.options.optColTabs.selected]["textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n]] or module.db.colsDefaults["textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n]]
					maxColor = max(maxColor,color)
				end
				for n=1,3 do
					local color = VExRT.ExCD2.colSet[module.options.optColTabs.selected]["textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n]] or module.db.colsDefaults["textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n]]
					if color < maxColor then
						VExRT.ExCD2.colSet[module.options.optColTabs.selected]["textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n]] = color + (maxColor - color) / 2
					end
				end
			end
		end
		module.options.showColorFrame(module.options.colorSetupFrame)
		module:ReloadAllSplits()
	end)
	
	self.colorSetupFrame.resetButton:SetScript("OnClick",function()
		local tmpColors = {"R","G","B"}
		for j=1,4 do
			for i=1,3 do
				for n=1,3 do
					VExRT.ExCD2.colSet[module.options.optColTabs.selected]["textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n]] = nil
				end
			end
		end
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureAlphaBackground = nil
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureAlphaTimeLine = nil
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureAlphaCooldown = nil
		for i=1,3 do
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][ checksInOptNames[i] ] = nil
		end
		module.options.showColorFrame(module.options.colorSetupFrame)
		module:ReloadAllSplits()
	end)
	
	function self:showColorFrame()
		for j=1,3 do
			for i=1,3 do
				local this = module.options.colorSetupFrame["color"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]]
				this.color:SetColorTexture(VExRT.ExCD2.colSet[module.options.optColTabs.selected][this.inOptName.."R"] or module.db.colsDefaults[this.inOptName.."R"],VExRT.ExCD2.colSet[module.options.optColTabs.selected][this.inOptName.."G"] or module.db.colsDefaults[this.inOptName.."G"],VExRT.ExCD2.colSet[module.options.optColTabs.selected][this.inOptName.."B"] or module.db.colsDefaults[this.inOptName.."B"],1)
			end
		end
		for i=1,3 do
			module.options.colorSetupFrame["colorClass"..colorSetupFrameColorsObjectsNames[i]]:SetChecked( VExRT.ExCD2.colSet[module.options.optColTabs.selected][ checksInOptNames[i] ] )
		end

		self.backAlpha:SetValue((VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.backAlpha.inOptName] or module.db.colsDefaults[self.backAlpha.inOptName])*100)
		self.backCDAlpha:SetValue((VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.backCDAlpha.inOptName] or module.db.colsDefaults[self.backCDAlpha.inOptName])*100)
		self.backCooldownAlpha:SetValue((VExRT.ExCD2.colSet[module.options.optColTabs.selected][self.backCooldownAlpha.inOptName] or module.db.colsDefaults[self.backCooldownAlpha.inOptName])*100)
	end

	self.colorSetupFrame:SetScript("OnShow",self.showColorFrame)

	
	self.optColSet.chkGeneralColorize = ELib:Check(self.optColSet.superTabFrame.tab[3],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureGeneral = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralColorize:doAlphas()
		ExRT.lib.SetAlphas(VExRT.ExCD2.colSet[module.options.optColTabs.selected].textureGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.dropDownTexture,module.options.optColSet.chkAnimation,module.options.colorSetupFrame,module.options.optColSet.colorPickerBorder,module.options.optColSet.sliderBorderSize,module.options.optColSet.chkHideSpark)
	end	

	--> Font Options
	self.optColSet.nowFont = "font"
	
	self.optColSet.superTabFrame.tab[4].decorationLine = CreateFrame("Frame",nil,self.optColSet.superTabFrame.tab[4])
	self.optColSet.superTabFrame.tab[4].decorationLine.texture = self.optColSet.superTabFrame.tab[4].decorationLine:CreateTexture(nil, "BACKGROUND")
	self.optColSet.superTabFrame.tab[4].decorationLine:SetPoint("TOPLEFT",self.optColSet.superTabFrame.tab[4],0,-35)
	self.optColSet.superTabFrame.tab[4].decorationLine:SetPoint("BOTTOMRIGHT",self.optColSet.superTabFrame.tab[4],"TOPRIGHT",0,-55)
	self.optColSet.superTabFrame.tab[4].decorationLine.texture:SetAllPoints()
	self.optColSet.superTabFrame.tab[4].decorationLine.texture:SetColorTexture(1,1,1,1)
	self.optColSet.superTabFrame.tab[4].decorationLine.texture:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)
	
	self.optColSet.fontsTab = ELib:Tabs(self.optColSet.superTabFrame.tab[4],0,L.cd2ColSetFontPosGeneral,L.cd2ColSetFontPosRight,L.cd2ColSetFontPosCenter,L.cd2ColSetFontPosIcon):Size(455,160):Point(0,-55)
	self.optColSet.fontsTab:SetBackdropBorderColor(0,0,0,0)
	self.optColSet.fontsTab:SetBackdropColor(0,0,0,0)
	local function fontsTabButtonClick(self)
		local tabFrame = self.mainFrame
		tabFrame.selected = self.id
		tabFrame.UpdateTabs(tabFrame)
		
		module.options.optColSet.nowFont = self.fontMark
		
		local i = module.options.optColTabs.selected
		do
			local FontNameForDropDown = select(3,string.find(VExRT.ExCD2.colSet[i][self.fontMark.."Name"] or module.db.colsDefaults.fontName,"\\([^\\]*)$"))
			module.options.optColSet.dropDownFont:SetText(  (FontNameForDropDown or VExRT.ExCD2.colSet[i][self.fontMark.."Name"] or module.db.colsDefaults.fontName or "?") )
		end
		module.options.optColSet.sliderFont:SetValue(VExRT.ExCD2.colSet[i][self.fontMark.."Size"] or module.db.colsDefaults.fontSize)
		module.options.optColSet.chkFontOutline:SetChecked(VExRT.ExCD2.colSet[i][self.fontMark.."Outline"])
		module.options.optColSet.chkFontShadow:SetChecked(VExRT.ExCD2.colSet[i][self.fontMark.."Shadow"])
	end
	for i=1,4 do
		self.optColSet.fontsTab.tabs[i].button:SetScript("OnClick",fontsTabButtonClick)
	end
	local fontOtherAvailableTable = {"Left","Right","Center","Icon"}
	function self.fontOtherAvailable(isAvailable)
		if isAvailable then
			for i=2,4 do
				self.optColSet.fontsTab.tabs[i].button:Show()
			end
			self.optColSet.fontsTab.tabs[1].button:SetText(L.cd2ColSetFontPosLeft)
			for i=1,4 do
				self.optColSet.fontsTab.tabs[i].button.fontMark = "font"..fontOtherAvailableTable[i]
			end
		else
			for i=2,4 do
				self.optColSet.fontsTab.tabs[i].button:Hide()
			end
			self.optColSet.fontsTab.tabs[1].button:SetText(L.cd2ColSetFontPosGeneral)
			self.optColSet.fontsTab.tabs[1].button.fontMark = "font"
		end
		self.optColSet.fontsTab.resizeFunc(self.optColSet.fontsTab.tabs[1].button, 0, nil, nil, self.optColSet.fontsTab.tabs[1].button:GetFontString():GetStringWidth(), self.optColSet.fontsTab.tabs[1].button:GetFontString():GetStringWidth())
		fontsTabButtonClick(module.options.optColSet.fontsTab.tabs[1].button)
	end
	
	self.optColSet.chkFontOtherAvailable = ELib:Check(self.optColSet.superTabFrame.tab[4],L.cd2ColSetFontOtherAvailable):Point(10,-220):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].fontOtherAvailable = true --fontOtherAvailable
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].fontOtherAvailable = nil
		end
		module:ReloadAllSplits()
		module.options.fontOtherAvailable( self:GetChecked() )
	end)

	self.optColSet.sliderFont = ELib:Slider(self.optColSet.fontsTab,L.cd2OtherSetFontSize):Size(400):Point("TOP",0,-60):Range(8,72):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected][module.options.optColSet.nowFont.."Size"] = event --fontSize
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.textDDFont = ELib:Text(self.optColSet.fontsTab,L.cd2OtherSetFont..":"):Size(200,20):Point(10,-15)

	local function dropDownFontButtonClick(self,arg1,arg2)
		ELib:DropDownClose()
		VExRT.ExCD2.colSet[module.options.optColTabs.selected][module.options.optColSet.nowFont.."Name"] = arg1 --fontName
		module:ReloadAllSplits()
		local FontNameForDropDown = select(3,string.find(arg1,"\\([^\\]*)$"))
		if arg2 <= #ExRT.F.fontList then
			module.options.optColSet.dropDownFont:SetText(FontNameForDropDown or ExRT.F.fontList[arg2])
		else
			module.options.optColSet.dropDownFont:SetText(FontNameForDropDown or arg2)
		end
	end
	
	self.optColSet.dropDownFont = ELib:DropDown(self.optColSet.fontsTab,350,10):Size(200):Point(180,-15)
	for i=1,#ExRT.F.fontList do
		self.optColSet.dropDownFont.List[i] = {}
		local info = self.optColSet.dropDownFont.List[i]
		info.text = ExRT.F.fontList[i]
		info.arg1 = ExRT.F.fontList[i]
		info.arg2 = i
		info.func = dropDownFontButtonClick
		info.font = ExRT.F.fontList[i]
		info.justifyH = "CENTER" 
	end
	if LibStub then
		local loaded,media = pcall(LibStub,"LibSharedMedia-3.0")
		if loaded and media then
			local fontList = media:HashTable("font")
			if fontList then
				local count = #self.optColSet.dropDownFont.List
				for key,font in pairs(fontList) do
					count = count + 1
					self.optColSet.dropDownFont.List[count] = {}
					local info = self.optColSet.dropDownFont.List[count]
					
					info.text = font
					info.arg1 = font
					info.arg2 = count
					info.func = dropDownFontButtonClick
					info.font = font
					info.justifyH = "CENTER" 
				end
			end
		end
	end
	
	self.optColSet.chkFontOutline = ELib:Check(self.optColSet.fontsTab,L.cd2OtherSetOutline):Point(10,-95):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][module.options.optColSet.nowFont.."Outline"] = true --fontOutline
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][module.options.optColSet.nowFont.."Outline"] = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkFontShadow = ELib:Check(self.optColSet.fontsTab,L.cd2OtherSetFontShadow):Point(10,-120):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][module.options.optColSet.nowFont.."Shadow"] = true -- fontShadow
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected][module.options.optColSet.nowFont.."Shadow"] = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkGeneralFont = ELib:Check(self.optColSet.superTabFrame.tab[4],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].fontGeneral = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].fontGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)	
	function self.optColSet.chkGeneralFont:doAlphas()
		ExRT.lib.SetAlphas(VExRT.ExCD2.colSet[module.options.optColTabs.selected].fontGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.dropDownFont,module.options.optColSet.sliderFont,module.options.optColSet.chkFontOutline,module.options.optColSet.chkFontShadow)
	end
	
	--> Text options
	
	self.optColSet.textLeftTemText = ELib:Text(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextLeft..":"):Size(200,20):Point(10,-40)
	self.optColSet.textLeftTemEdit = ELib:Edit(self.optColSet.superTabFrame.tab[5]):Size(220,20):Point(180,-40):OnChange(function(self,isUser)
		if isUser then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textTemplateLeft = self:GetText()
			module:ReloadAllSplits()
		end
	end)
	
	self.optColSet.textRightTemText = ELib:Text(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextRight..":"):Size(200,20):Point(10,-65)
	self.optColSet.textRightTemEdit = ELib:Edit(self.optColSet.superTabFrame.tab[5]):Size(220,20):Point(180,-65):OnChange(function(self,isUser)
		if isUser then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textTemplateRight = self:GetText()
			module:ReloadAllSplits()
		end
	end)
	
	self.optColSet.textCenterTemText = ELib:Text(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextCenter..":"):Size(200,20):Point(10,-90)
	self.optColSet.textCenterTemEdit = ELib:Edit(self.optColSet.superTabFrame.tab[5]):Size(220,20):Point(180,-90):OnChange(function(self,isUser)
		if isUser then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textTemplateCenter = self:GetText()
			module:ReloadAllSplits()
		end
	end)
	
	self.optColSet.textAllTemplates = ELib:Text(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextTooltip,11):Size(450,200):Point(10,-115):Top():Color()

	self.optColSet.textResetButton = ELib:Button(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextReset):Size(340,20):Point("TOP",0,-225):OnClick(function(self)
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].textTemplateLeft = nil
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].textTemplateRight = nil
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].textTemplateCenter = nil
		module:ReloadAllSplits()
		module.options.optColSet.textLeftTemEdit:SetText(module.db.colsDefaults.textTemplateLeft)
		module.options.optColSet.textRightTemEdit:SetText(module.db.colsDefaults.textTemplateRight)
		module.options.optColSet.textCenterTemEdit:SetText(module.db.colsDefaults.textTemplateCenter)
	end)
	
	self.optColSet.chkIconName = ELib:Check(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextIconName):Point(10,-250):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textIconName = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textIconName = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkGeneralText = ELib:Check(self.optColSet.superTabFrame.tab[5],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textGeneral = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].textGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralText:doAlphas()
		ExRT.lib.SetAlphas(VExRT.ExCD2.colSet[module.options.optColTabs.selected].textGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.textLeftTemEdit,module.options.optColSet.textRightTemEdit,module.options.optColSet.textCenterTemEdit,module.options.optColSet.chkIconName,module.options.optColSet.textAllTemplates,module.options.optColSet.textLeftTemText,module.options.optColSet.textRightTemText,module.options.optColSet.textCenterTemText,module.options.optColSet.textResetButton)
	end

	--> Method options
	
	self.optColSet.chkShowOnlyOnCD = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2OtherSetOnlyOnCD):Point(10,-30):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsShownOnCD = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsShownOnCD = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkBotToTop = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2ColSetBotToTop):Point(10,-55):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameAnchorBottom = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].frameAnchorBottom = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.textStyleAnimation = ELib:Text(self.optColSet.superTabFrame.tab[6],L.cd2OtherSetStyleAnimation..":",11):Size(200,20):Point(10,-80)
	self.optColSet.dropDownStyleAnimation = ELib:DropDown(self.optColSet.superTabFrame.tab[6],205,2):Size(220):Point(180,-80)
	self.optColSet.dropDownStyleAnimation.Styles = {L.cd2OtherSetStyleAnimation1,L.cd2OtherSetStyleAnimation2}
	for i=1,#self.optColSet.dropDownStyleAnimation.Styles do
		self.optColSet.dropDownStyleAnimation.List[i] = {
			text = self.optColSet.dropDownStyleAnimation.Styles[i],
			arg1 = i,
			func = function (self,arg)
				ELib:DropDownClose()
				VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsStyleAnimation = arg
				module:ReloadAllSplits()
				self:GetParent().parent:SetText(module.options.optColSet.dropDownStyleAnimation.Styles[arg])
			end
		}
	end

	self.optColSet.textTimeLineAnimation = ELib:Text(self.optColSet.superTabFrame.tab[6],L.cd2OtherSetTimeLineAnimation..":",11):Size(200,20):Point(10,-105)
	self.optColSet.dropDownTimeLineAnimation = ELib:DropDown(self.optColSet.superTabFrame.tab[6],205,2):Size(220):Point(180,-105)
	self.optColSet.dropDownTimeLineAnimation.Styles = {L.cd2OtherSetTimeLineAnimation1,L.cd2OtherSetTimeLineAnimation2}
	for i=1,#self.optColSet.dropDownTimeLineAnimation.Styles do
		self.optColSet.dropDownTimeLineAnimation.List[i] = {
			text = self.optColSet.dropDownTimeLineAnimation.Styles[i],
			arg1 = i,
			func = function (self,arg)
				ELib:DropDownClose()
				VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsTimeLineAnimation = arg
				module:ReloadAllSplits()
				self:GetParent().parent:SetText(module.options.optColSet.dropDownTimeLineAnimation.Styles[arg])
			end
		}
	end
	
	self.optColSet.chkIconTooltip = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2OtherSetIconToolip):Point(10,-130):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsIconTooltip = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsIconTooltip = nil
		end
		module:ReloadAllSplits()
	end)
		
	self.optColSet.chkLineClick = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2OtherSetLineClick):Point(10,-155):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsLineClick = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsLineClick = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkLineClickWhisper = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2OtherSetLineClickWhisper):Point(10,-180):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsLineClickWhisper = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsLineClickWhisper = nil
		end
		module:ReloadAllSplits()
	end)	
	
	self.optColSet.chkNewSpellNewLine = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2NewSpellNewLine):Point(10,-205):Tooltip(L.cd2NewSpellNewLineTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsNewSpellNewLine = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsNewSpellNewLine = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.textSortingRules= ELib:Text(self.optColSet.superTabFrame.tab[6],L.cd2MethodsSortingRules..":",11):Size(200,20):Point(10,-230)
	self.optColSet.dropDownSortingRules = ELib:DropDown(self.optColSet.superTabFrame.tab[6],405,6):Size(220):Point(180,-230)
	self.optColSet.dropDownSortingRules.Rules = {L.cd2MethodsSortingRules1,L.cd2MethodsSortingRules2,L.cd2MethodsSortingRules3,L.cd2MethodsSortingRules4,L.cd2MethodsSortingRules5,L.cd2MethodsSortingRules6}
	for i=1,#self.optColSet.dropDownSortingRules.Rules do
		self.optColSet.dropDownSortingRules.List[i] = {
			text = self.optColSet.dropDownSortingRules.Rules[i],
			arg1 = i,
			func = function (self,arg)
				ELib:DropDownClose()
				VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsSortingRules = arg
				module:ReloadAllSplits()
				module.main:GROUP_ROSTER_UPDATE()
				self:GetParent().parent:SetText(module.options.optColSet.dropDownSortingRules.Rules[arg])
			end
		}
	end
	
	self.optColSet.chkHideOwnSpells = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2MethodsDisableOwn):Point(10,-255):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsHideOwnSpells = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsHideOwnSpells = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkAlphaNotInRange = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2MethodsAlphaNotInRange):Point(10,-280):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsAlphaNotInRange = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsAlphaNotInRange = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.sliderAlphaNotInRange = ELib:Slider(self.optColSet.superTabFrame.tab[6],""):Size(140):Point("TOPLEFT",self.optColSet.chkAlphaNotInRange,270,-3):Range(0,100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsAlphaNotInRangeNum = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	
	self.optColSet.chkDisableActive = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2ColSetDisableActive):Point(10,-305):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsDisableActive = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsDisableActive = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkOneSpellPerCol = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2ColSetOneSpellPerCol):Point(10,-330):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsOneSpellPerCol = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsOneSpellPerCol = nil
		end
		module:ReloadAllSplits()
	end):Tooltip(L.cd2ColSetOneSpellPerColTooltip)
	
	self.optColSet.chkGeneralMethods = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsGeneral = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralMethods:doAlphas()
		ExRT.lib.SetAlphas(VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.chkShowOnlyOnCD,module.options.optColSet.chkBotToTop,module.options.optColSet.dropDownStyleAnimation,module.options.optColSet.dropDownTimeLineAnimation,module.options.optColSet.chkIconTooltip,module.options.optColSet.chkLineClick,module.options.optColSet.chkNewSpellNewLine,module.options.optColSet.dropDownSortingRules,module.options.optColSet.textSortingRules,module.options.optColSet.textStyleAnimation,module.options.optColSet.textTimeLineAnimation,module.options.optColSet.chkHideOwnSpells,module.options.optColSet.chkAlphaNotInRange,module.options.optColSet.sliderAlphaNotInRange,module.options.optColSet.chkDisableActive,module.options.optColSet.chkOneSpellPerCol,module.options.optColSet.chkLineClickWhisper)
	end
	
	self.optColSet.chkSortByAvailability = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2SortByAvailability,VExRT.ExCD2.SortByAvailability):Point(10,-355):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.SortByAvailability = true
		else
			VExRT.ExCD2.SortByAvailability = nil
			module.main:GROUP_ROSTER_UPDATE()
		end
	end)
	
	self.optColSet.chkSortByAvailability_activeToTop = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2SortByAvailabilityActiveToTop,VExRT.ExCD2.SortByAvailabilityActiveToTop):Point("TOPLEFT",self.optColSet.chkSortByAvailability,0,-25):Tooltip(L.cd2SortByAvailabilityActiveToTopTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.SortByAvailabilityActiveToTop = true
		else
			VExRT.ExCD2.SortByAvailabilityActiveToTop = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkReverseSorting = ELib:Check(self.optColSet.superTabFrame.tab[6],L.cd2ReverseSorting,VExRT.ExCD2.ReverseSorting):Point("TOPLEFT",self.optColSet.chkSortByAvailability_activeToTop,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.ReverseSorting = true
		else
			VExRT.ExCD2.ReverseSorting = nil
		end
		module:ReloadAllSplits()
	end)

	--> Visibility
	
	
	self.optColSet.chkOnlyInCombat = ELib:Check(self.optColSet.superTabFrame.tab[7],L.TimerOnlyInCombat):Point(10,-30):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsOnlyInCombat = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].methodsOnlyInCombat = nil
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.visibilityTextPartyType = ELib:Text(self.optColSet.superTabFrame.tab[7],L.cd2OtherVisibilityPartyType..":",10):Point(10,-60):Color()
	
	self.optColSet.chkVisibilityPartyTypeAlways = ELib:Radio(self.optColSet.superTabFrame.tab[7],ALWAYS):Point(10,-75):OnClick(function(self) 
		module.options.optColSet.chkVisibilityPartyTypeAlways:SetChecked(true)
		module.options.optColSet.chkVisibilityPartyTypeParty:SetChecked(false)
		module.options.optColSet.chkVisibilityPartyTypeRaid:SetChecked(false)
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityPartyType = nil
		module:ReloadAllSplits()
	end)
	self.optColSet.chkVisibilityPartyTypeParty = ELib:Radio(self.optColSet.superTabFrame.tab[7],AGGRO_WARNING_IN_PARTY):Point(10,-95):OnClick(function(self) 
		module.options.optColSet.chkVisibilityPartyTypeAlways:SetChecked(false)
		module.options.optColSet.chkVisibilityPartyTypeParty:SetChecked(true)
		module.options.optColSet.chkVisibilityPartyTypeRaid:SetChecked(false)
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityPartyType = 1
		module:ReloadAllSplits()
	end)
	self.optColSet.chkVisibilityPartyTypeRaid = ELib:Radio(self.optColSet.superTabFrame.tab[7],L.cd2OtherVisibilityPartyTypeRaid):Point(10,-115):OnClick(function(self) 
		module.options.optColSet.chkVisibilityPartyTypeAlways:SetChecked(false)
		module.options.optColSet.chkVisibilityPartyTypeParty:SetChecked(false)
		module.options.optColSet.chkVisibilityPartyTypeRaid:SetChecked(true)
		VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityPartyType = 2
		module:ReloadAllSplits()
	end)
	
	self.optColSet.visibilityTextZoneType = ELib:Text(self.optColSet.superTabFrame.tab[7],L.cd2OtherVisibilityZoneType..":",10):Point(10,-140):Color()
	
	self.optColSet.chkVisibilityZoneArena = ELib:Check(self.optColSet.superTabFrame.tab[7],ARENA):Point(10,-155):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisableArena = nil
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisableArena = true
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkVisibilityZoneBG = ELib:Check(self.optColSet.superTabFrame.tab[7],BATTLEGROUND):Point(10,-180):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisableBG = nil
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisableBG = true
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkVisibilityZoneScenario = ELib:Check(self.optColSet.superTabFrame.tab[7],TRACKER_HEADER_SCENARIO):Point(10,-205):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisable3ppl = nil
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisable3ppl = true
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkVisibilityZone5ppl = ELib:Check(self.optColSet.superTabFrame.tab[7],CALENDAR_TYPE_DUNGEON):Point(10,-230):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisable5ppl = nil
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisable5ppl = true
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkVisibilityZoneRaid = ELib:Check(self.optColSet.superTabFrame.tab[7],RAID):Point(10,-255):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisableRaid = nil
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisableRaid = true
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkVisibilityZoneOutdoor = ELib:Check(self.optColSet.superTabFrame.tab[7],WORLD):Point(10,-280):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisableWorld = nil
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityDisableWorld = true
		end
		module:ReloadAllSplits()
	end)
	
	self.optColSet.chkGeneralVisibility = ELib:Check(self.optColSet.superTabFrame.tab[7],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityGeneral = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralVisibility:doAlphas()
		ExRT.lib.SetAlphas(VExRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.chkOnlyInCombat,module.options.optColSet.visibilityTextPartyType,module.options.optColSet.chkVisibilityPartyTypeAlways,module.options.optColSet.chkVisibilityPartyTypeParty,module.options.optColSet.chkVisibilityPartyTypeRaid,module.options.optColSet.visibilityTextZoneType,module.options.optColSet.chkVisibilityZoneArena,module.options.optColSet.chkVisibilityZoneBG,module.options.optColSet.chkVisibilityZoneScenario,module.options.optColSet.chkVisibilityZone5ppl,module.options.optColSet.chkVisibilityZoneRaid,module.options.optColSet.chkVisibilityZoneOutdoor)
	end
	
	--> Black List
	
	self.optColSet.blacklistText = ELib:Text(self.optColSet.superTabFrame.tab[8],L.cd2ColSetBlacklistTooltip,11):Size(430,200):Point(10,-30):Top():Color()
	
	self.optColSet.blacklistEditBox = ELib:MultiEdit(self.optColSet.superTabFrame.tab[8]):Size(430,140):Point("TOP",0,-85)
	do
		local scheluded = nil
		local function ScheludeFunc(self)
			scheluded = nil
			module:ReloadAllSplits()
		end
		function self.optColSet.blacklistEditBox:OnTextChanged(isUser)
			if not isUser then
				return
			end
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].blacklistText = strtrim( self:GetText() )
			if not scheluded then
				scheluded = ExRT.F.ScheduleTimer(ScheludeFunc, 1)
			end
		end
	end

	self.optColSet.whitelistText = ELib:Text(self.optColSet.superTabFrame.tab[8],L.cd2ColSetWhitelistTooltip,11):Size(430,200):Point(10,-235):Top():Color()
	
	self.optColSet.whitelistEditBox = ELib:MultiEdit(self.optColSet.superTabFrame.tab[8]):Size(430,140):Point("TOP",0,-290)
	do
		local scheluded = nil
		local function ScheludeFunc(self)
			scheluded = nil
			module:ReloadAllSplits()
		end
		function self.optColSet.whitelistEditBox:OnTextChanged(isUser)
			if not isUser then
				return
			end
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].whitelistText = strtrim( self:GetText() )
			if not scheluded then
				scheluded = ExRT.F.ScheduleTimer(ScheludeFunc, 1)
			end
		end
	end
		
	self.optColSet.chkGeneralBlackList = ELib:Check(self.optColSet.superTabFrame.tab[8],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].blacklistGeneral = true
		else
			VExRT.ExCD2.colSet[module.options.optColTabs.selected].blacklistGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralBlackList:doAlphas()
		ExRT.lib.SetAlphas(VExRT.ExCD2.colSet[module.options.optColTabs.selected].blacklistGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.blacklistEditBox,module.options.optColSet.whitelistEditBox,module.options.optColSet.whitelistText,module.options.optColSet.blacklistText)
	end
	
	--> Templates Tab
	self.optColSet.templates = {}
	self.optColSet.templateData = {
		spells = {31821,62618,97462,20484,98008},
		spellsCD = {90,0,0,20,0},
		spellsDuration = {0,10,0,0,0},
		spellsDead = {nil,nil,true,nil,nil},
		spellsCharge = {nil,nil,nil,true,nil},
		spellsClass = {"PALADIN","PRIEST","WARRIOR","DRUID","SHAMAN"},
		[1] = {
			iconSize = 16,
			optionAnimation = true,
			optionStyleAnimation = 1,
			optionTimeLineAnimation = 1,
			optionIconPosition = 1,
			optionGray = true,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = true,
			fontShadow = false,
			textureFile = ExRT.F.barImg,
			colorsText = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsBack = {0,1,0, 0,1,0, 1,0,0, 1,1,0},
			colorsTL = {0,1,0, 0,1,0, 1,0,0, 1,1,0},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.8,
			textureAlphaCooldown = 1,
			optionClassColorBackground = false,
			optionClassColorTimeLine = false,
			optionClassColorText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%time%",
			textTemplateCenter = "",
		},
		[2] = {
			iconSize = 14,
			optionAnimation = false,
			optionStyleAnimation = 1,
			optionTimeLineAnimation = 1,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = true,
			fontShadow = false,
			textureFile = ExRT.F.barImg,
			colorsText = {1,1,1, 0.5,1,0.5, 1,0.5,0.5, 1,1,0.5,},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.8,
			textureAlphaCooldown = 1,
			optionClassColorBackground = false,
			optionClassColorTimeLine = false,
			optionClassColorText = false,
			textTemplateLeft = "%time% %name%",
			textTemplateRight = "",
			textTemplateCenter = "",
		},
		[3] = {
			iconSize = 14,
			optionAnimation = true,
			optionStyleAnimation = 1,
			optionTimeLineAnimation = 2,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar26.tga",
			colorsText = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 0.8,
			textureAlphaCooldown = 1,
			optionClassColorBackground = false,
			optionClassColorTimeLine = true,
			optionClassColorText = false,
			textTemplateLeft = "",
			textTemplateRight = "%time%",
			textTemplateCenter = "%name%: %spell%",
		},
		[4] = {
			iconSize = 16,
			optionAnimation = true,
			optionStyleAnimation = 2,
			optionTimeLineAnimation = 2,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar19.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,1,1, 1,1,0.5},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = 0.85,
			optionClassColorBackground = true,
			optionClassColorTimeLine = true,
			optionClassColorText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%time%",
			textTemplateCenter = "",
			
			frameBetweenLines = 1,
		},
		[5] = {
			iconSize = 40,
			optionAnimation = false,
			optionStyleAnimation = 1,
			optionTimeLineAnimation = 1,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 10,
			fontName = ExRT.F.defFont,
			fontOutline = true,
			fontShadow = false,
			textureFile = ExRT.F.barImg,
			colorsText = {1,1,1, 0.5,1,0.5, 1,0.5,0.5, 1,1,0.5,},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0,
			textureAlphaTimeLine = 0,
			textureAlphaCooldown = 0.7,
			optionClassColorBackground = false,
			optionClassColorTimeLine = false,
			optionClassColorText = false,
			textTemplateLeft = "",
			textTemplateRight = "",
			textTemplateCenter = "",
			textIconName = true,
			methodsCooldown = true,
			
			frameWidth = 40,
			frameColumns = 4,
		},
		[6] = {
			iconSize = 12,
			optionAnimation = false,
			optionStyleAnimation = 1,
			optionTimeLineAnimation = 1,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = false,
			textureFile = ExRT.F.barImg,
			colorsText = {1,1,1, 0.5,1,0.5, 1,0.5,0.5, 1,1,0.5,},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0,
			textureAlphaTimeLine = 0,
			textureAlphaCooldown = 1,
			optionClassColorBackground = false,
			optionClassColorTimeLine = false,
			optionClassColorText = false,
			textTemplateLeft = "%time% %name%",
			textTemplateRight = "",
			textTemplateCenter = "",
		},
		[7] = {
			iconSize = 14,
			optionAnimation = true,
			optionStyleAnimation = 1,
			optionTimeLineAnimation = 1,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar29.tga",
			colorsText = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsBack = {0,1,0, 0,1,0, 0.8,0,0, 1,1,0},
			colorsTL = {0,1,0, 0,1,0, 0.8,0,0, 1,1,0},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.8,
			textureAlphaCooldown = 0.5,
			optionClassColorBackground = false,
			optionClassColorTimeLine = false,
			optionClassColorText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%stime%",
			textTemplateCenter = "",
		},
		[8] = {
			iconSize = 16,
			optionAnimation = true,
			optionStyleAnimation = 2,
			optionTimeLineAnimation = 2,
			optionIconPosition = 2,
			optionGray = true,
			fontSize = 13,
			fontName = ExRT.F.defFont,
			fontOutline = true,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar6.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,0.5,0.5, 1,1,0.5,},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.8,
			textureAlphaCooldown = 0.5,
			optionClassColorBackground = false,
			optionClassColorTimeLine = false,
			optionClassColorText = true,
			textTemplateLeft = "%name%",
			textTemplateRight = "",
			textTemplateCenter = "",
		},
		[9] = {
			iconSize = 18,
			optionAnimation = true,
			optionStyleAnimation = 1,
			optionTimeLineAnimation = 2,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar16.tga",
			colorsText = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsBack = {0,0,0, 0,0,0, 0,0,0, 0,0,0},
			colorsTL = {0.24,0.44,1, 1,0.37,1, 0.24,0.44,1, 1,0.46,0.10},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.9,
			textureAlphaCooldown = 1,
			optionClassColorBackground = false,
			optionClassColorTimeLine = false,
			optionClassColorText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%stime%",
			textTemplateCenter = "",
			textureBorderSize = 1,
			frameBetweenLines = 3,
			textureBorderColorA = 1,
		},
		[10] = {
			iconSize = 18,
			optionAnimation = true,
			optionStyleAnimation = 1,
			optionTimeLineAnimation = 2,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar16.tga",
			colorsText = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsBack = {0,0,0, 0,0,0, 0,0,0, 0,0,0},
			colorsTL = {0.24,0.44,1, 1,0.37,1, 0.24,0.44,1, 1,0.46,0.10},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.9,
			textureAlphaCooldown = 1,
			optionClassColorBackground = false,
			optionClassColorTimeLine = true,
			optionClassColorText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%stime%",
			textTemplateCenter = "",
			textureBorderSize = 1,
			frameBetweenLines = 3,
			textureBorderColorA = 1,
		},
		[11] = {
			_twoSized = true,
			_Scaled = .8,
			
			iconSize = 40,
			optionAnimation = true,
			optionStyleAnimation = 1,
			optionTimeLineAnimation = 2,
			optionIconPosition = 1,
			optionGray = true,
			fontSize = 14,
			fontName = ExRT.F.defFont,
			fontOutline = true,
			fontShadow = false,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar17.tga",
			colorsText = {1,1,1, 1,1,1, 1,.6,.6, 1,1,.5},
			colorsBack = {0,0,0, 0,0,0, 0,0,0, 0,0,0},
			colorsTL = {0,0,0, 0,0,0, 0,0,0, 0,0,0},
			textureAlphaBackground = 0.8,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = .5,
			optionClassColorBackground = false,
			optionClassColorTimeLine = true,
			optionClassColorText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "",
			textTemplateCenter = "",
			methodsCooldown = true,
			methodsNewSpellNewLine = true,
			frameColumns = 5,
			iconHideBlizzardEdges = true,
			
			frameLines = 60,
			
			DiffSpellData = {
				spells = 	{31821,	31821,	0,	0,	0,	97462,	0,	0,	0,	0,	20484,	20484},
				spellsCD = 	{90,	0,	0,	0,	0,	0,	0,	0,	0,	0,	20,	0},
				spellsDuration = {0,	10,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0},
				spellsDead = 	{nil,	nil,	nil,	nil,	nil,	true,	nil,	nil,	nil,	nil,	nil,	nil},
				spellsCharge = 	{nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	true,	nil},
				spellsClass = 	{"PALADIN","PALADIN",nil,nil,nil,	"WARRIOR",nil,nil,nil,nil,		"DRUID","DRUID"},			
			},
		},
		[12] = {},
		[13] = {
			iconSize = 13,
			optionAnimation = true,
			optionStyleAnimation = 2,
			optionTimeLineAnimation = 2,
			optionIconPosition = 2,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar19.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,1,1, 1,1,0.5},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = 0.85,
			optionClassColorBackground = true,
			optionClassColorTimeLine = true,
			optionClassColorText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%time%",
			textTemplateCenter = "",
			iconTitles = true,
			
			frameBetweenLines = 0,	
			
			DiffSpellData = {
				spells = 	{31821,	31821,	31821,	97462,	97462,	51052,	51052,	51052,	},
				spellsCD = 	{0,	90,	0,	0,	0,	0,	0,	20,	},
				spellsDuration ={0,	0,	10,	0,	0,	0,	0,	0,	},
				spellsDead = 	{nil,	nil,	nil,	nil,	true,	nil,	nil,	nil,	},
				spellsCharge = 	{nil,	nil,	nil,	nil,	nil,	nil,	nil,	true,	},
				spellsClass = 	{"title","PALADIN","PALADIN","title","WARRIOR","title","DEATHKNIGHT","DEATHKNIGHT"},			
			},		
		},
		[14] = {
			iconSize = 14,
			optionAnimation = true,
			optionStyleAnimation = 2,
			optionTimeLineAnimation = 2,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar19.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,1,1, 1,1,0.5},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = 0.85,
			optionClassColorBackground = true,
			optionClassColorTimeLine = true,
			optionClassColorText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%time%",
			textTemplateCenter = "",
			
			frameBetweenLines = 0,
		},
		[15] = {
			_twoSized = true,
			_Scaled = .75,
			
			iconSize = 13,
			optionAnimation = true,
			optionStyleAnimation = 2,
			optionTimeLineAnimation = 2,
			optionIconPosition = 1,
			optionGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\ExRT\\media\\bar19.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,1,1, 1,1,0.5},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = 0.85,
			optionClassColorBackground = true,
			optionClassColorTimeLine = true,
			optionClassColorText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%time%",
			textTemplateCenter = "",
			iconTitles = true,
			methodsNewSpellNewLine = true,
			frameColumns = 5,
			frameLines = 60,
			frameBetweenLines = 0,	
			
			DiffSpellData = {
				spells = 	{31821,	31821,	31821,	0,	0,	97462,	97462,	0,	0,	0,	740,	740,	740,	0,	0,	51052,	51052,	51052,	0,	0,	64843,	64843,	64843,},
				spellsCD = 	{0,	90,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	20,	0,	0,	0,	0,	70,},
				spellsDuration ={0,	0,	10,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,},
				spellsDead = 	{nil,	nil,	nil,	nil,	nil,	nil,	true,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,},
				spellsCharge = 	{nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	nil,	true,	nil,	nil,	nil,	nil,	nil,},
				spellsClass = 	{"title","PALADIN","PALADIN",nil,nil,"title","WARRIOR",nil,nil,nil,"title","DRUID","DRUID",nil,nil,"title","DEATHKNIGHT","DEATHKNIGHT",nil,nil,"title","PRIEST","PRIEST"},			
			},
		},
		[16] = {},
		toOptions = {
			iconSize = "iconSize",
			optionAnimation = "textureAnimation",
			optionStyleAnimation = "methodsStyleAnimation",
			optionTimeLineAnimation = "methodsTimeLineAnimation",
			optionIconPosition = "iconPosition",
			optionGray = "iconGray",
			fontSize = "fontSize",
			fontName = "fontName",
			fontOutline = "fontOutline",
			fontShadow = "fontShadow",
			textureFile = "textureFile",
			colorsText = {"textureColorTextDefaultR","textureColorTextDefaultG","textureColorTextDefaultB","textureColorTextActiveR","textureColorTextActiveG","textureColorTextActiveB","textureColorTextCooldownR","textureColorTextCooldownG","textureColorTextCooldownB","textureColorTextCastR","textureColorTextCastG","textureColorTextCastB",},
			colorsBack = {"textureColorBackgroundDefaultR","textureColorBackgroundDefaultG","textureColorBackgroundDefaultB","textureColorBackgroundActiveR","textureColorBackgroundActiveG","textureColorBackgroundActiveB","textureColorBackgroundCooldownR","textureColorBackgroundCooldownG","textureColorBackgroundCooldownB","textureColorBackgroundCastR","textureColorBackgroundCastG","textureColorBackgroundCastB",},
			colorsTL = {"textureColorTimeLineDefaultR","textureColorTimeLineDefaultG","textureColorTimeLineDefaultB","textureColorTimeLineActiveR","textureColorTimeLineActiveG","textureColorTimeLineActiveB","textureColorTimeLineCooldownR","textureColorTimeLineCooldownG","textureColorTimeLineCooldownB","textureColorTimeLineCastR","textureColorTimeLineCastG","textureColorTimeLineCastB",},
			textureAlphaBackground = "textureAlphaBackground",
			textureAlphaTimeLine = "textureAlphaTimeLine",
			textureAlphaCooldown = "textureAlphaCooldown",
			optionClassColorBackground = "textureClassBackground",
			optionClassColorTimeLine = "textureClassTimeLine",
			optionClassColorText = "textureClassText",	
			textTemplateLeft = "textTemplateLeft",
			textTemplateRight = "textTemplateRight",
			textTemplateCenter = "textTemplateCenter",
			methodsCooldown = "methodsCooldown",
			textIconName = "textIconName",
			fontOtherAvailable = "fontOtherAvailable",
			frameBetweenLines = "frameBetweenLines",
			textureBorderSize = "textureBorderSize",
			textureBorderColorR = "textureBorderColorR",
			textureBorderColorG = "textureBorderColorG",
			textureBorderColorB = "textureBorderColorB",
			textureBorderColorA = "textureBorderColorA",
			methodsNewSpellNewLine = "methodsNewSpellNewLine",
			methodsSortingRules = "methodsSortingRules",
			iconTitles = "iconTitles",
			iconHideBlizzardEdges = "iconHideBlizzardEdges",
			
			iconGeneral = "iconGeneral",
			textureGeneral = "textureGeneral",
			methodsGeneral = "methodsGeneral",
			fontGeneral = "fontGeneral",
			textGeneral = "textGeneral",
			frameGeneral = "frameGeneral",

			frameColumns = "frameColumns",
			
			_frameAlpha = "frameAlpha",
			_frameWidth = "frameWidth",
			_frameBlackBack = "frameBlackBack",
			_frameLines = "frameLines",
		},
	}
	self.optColSet.templateSaveData = nil
	
	self.optColSet.templatesScrollFrame = ELib:ScrollFrame(self.optColSet.superTabFrame.tab[9]):Size(430,380):Point("TOP",0,-50):Height( ceil(#self.optColSet.templateData/2) * 125 + 10 )
	for i=1,#self.optColSet.templateData do if i==1 or not self.optColSet.templateData[i-1]._twoSized then
		local templateFrame = CreateFrame("Button",nil,self.optColSet.templatesScrollFrame.C)
		self.optColSet.templates[i] = templateFrame
		templateFrame:SetPoint(self.optColSet.templateData[i]._twoSized and "TOP" or (i-1)%2 == 0 and "TOPRIGHT" or "TOPLEFT",self.optColSet.templatesScrollFrame.C,"TOP",0,-floor((i-1)/2) * 125 - 5)
		templateFrame:SetSize(185,120)
		if self.optColSet.templateData[i]._twoSized then
			templateFrame:SetSize(370,120)
		end
		templateFrame:SetBackdrop({edgeFile = ExRT.F.defBorder, edgeSize = 8})
		templateFrame:SetBackdropBorderColor(1,1,1,0)
		templateFrame.backgTexture = templateFrame:CreateTexture(nil, "BACKGROUND")
		templateFrame.backgTexture:SetAllPoints()
		
		templateFrame:SetScript("OnEnter",function (self)
			self:SetBackdropBorderColor(1,1,1,0.5)
			self.backgTexture:SetColorTexture(1,1,1,0.3)
		end)
		
		templateFrame:SetScript("OnLeave",function (self)
		  	self:SetBackdropBorderColor(1,1,1,0)
			self.backgTexture:SetColorTexture(0,0,0,0)
		end)
		
		templateFrame:SetScript("OnClick",function (self)
		  	module.options.optColSet.templateRestore:Show()
		  	module.options.optColSet.templateSaveData = {}
		  	ExRT.F.table_copy(VExRT.ExCD2.colSet[module.options.optColTabs.selected],module.options.optColSet.templateSaveData)
		  	for key,val in pairs(module.options.optColSet.templateData.toOptions) do
		  		if type(val) ~= "table" then
		  			if string.find(key,"^_") then
		  				local key2 = string.sub(key,2)
		  				if module.options.optColSet.templateData[i][key2] then
		  					VExRT.ExCD2.colSet[module.options.optColTabs.selected][val] = module.options.optColSet.templateData[i][key2]
		  				elseif key2 == "frameWidth" then
		  					VExRT.ExCD2.colSet[module.options.optColTabs.selected][val] = max(110,VExRT.ExCD2.colSet[module.options.optColTabs.selected][val] or 110)
		  				end
		  			elseif val:find("General") then
		  				VExRT.ExCD2.colSet[module.options.optColTabs.selected][val] = nil
		  			else
		  				VExRT.ExCD2.colSet[module.options.optColTabs.selected][val] = module.options.optColSet.templateData[i][key]
		  			end
		  		else
		  			for k=1,#val do
		  				VExRT.ExCD2.colSet[module.options.optColTabs.selected][val[k]] = module.options.optColSet.templateData[i][key][k]
		  			end
		  		end
		  	end
		  	module:ReloadAllSplits()
		  	module.options.selectColumnTab()
		end)
		
		local width,height = self.optColSet.templateData[i].frameWidth or 160, self.optColSet.templateData[i].iconSize
		local betweenLines = self.optColSet.templateData[i].frameBetweenLines or 0
		
		templateFrame.barWidth = width
		templateFrame.iconSize = height
		
		templateFrame.fontName = self.optColSet.templateData[i].fontName
		templateFrame.fontSize = self.optColSet.templateData[i].fontSize
		templateFrame.fontOutline = self.optColSet.templateData[i].fontOutline
		templateFrame.fontShadow = self.optColSet.templateData[i].fontShadow
		for _,pos in pairs({"Left","Right","Center","Icon"}) do
			templateFrame["font"..pos.."Name"] = self.optColSet.templateData[i]["font"..pos.."Name"] or templateFrame.fontName
			templateFrame["font"..pos.."Size"] = self.optColSet.templateData[i]["font"..pos.."Size"] or templateFrame.fontSize
			templateFrame["font"..pos.."Outline"] = self.optColSet.templateData[i]["font"..pos.."Outline"] or templateFrame.fontOutline
			templateFrame["font"..pos.."Shadow"] = self.optColSet.templateData[i]["font"..pos.."Shadow"] or templateFrame.fontShadow
		end
	
		templateFrame.textTemplateLeft = self.optColSet.templateData[i].textTemplateLeft
		templateFrame.textTemplateRight = self.optColSet.templateData[i].textTemplateRight
		templateFrame.textTemplateCenter = self.optColSet.templateData[i].textTemplateCenter
		templateFrame.optionIconName = self.optColSet.templateData[i].textIconName
		templateFrame.optionCooldown = self.optColSet.templateData[i].methodsCooldown
		templateFrame.optionIconPosition = self.optColSet.templateData[i].optionIconPosition
		templateFrame.optionAnimation = self.optColSet.templateData[i].optionAnimation
		templateFrame.optionGray = self.optColSet.templateData[i].optionGray
		
		templateFrame.textureFile = self.optColSet.templateData[i].textureFile
		templateFrame.optionAlphaBackground = self.optColSet.templateData[i].textureAlphaBackground
		templateFrame.optionAlphaTimeLine = self.optColSet.templateData[i].textureAlphaTimeLine
		templateFrame.optionAlphaCooldown = self.optColSet.templateData[i].textureAlphaCooldown
		
		templateFrame.optionTimeLineAnimation = self.optColSet.templateData[i].optionTimeLineAnimation
		templateFrame.optionStyleAnimation = self.optColSet.templateData[i].optionStyleAnimation
		
		templateFrame.optionClassColorBackground = self.optColSet.templateData[i].optionClassColorBackground
		templateFrame.optionClassColorTimeLine = self.optColSet.templateData[i].optionClassColorTimeLine
		templateFrame.optionClassColorText = self.optColSet.templateData[i].optionClassColorText

		templateFrame.optionIconHideBlizzardEdges = self.optColSet.templateData[i].iconHideBlizzardEdges
		
		templateFrame.textureBorderColorR = self.optColSet.templateData[i].textureBorderColorR or 0
		templateFrame.textureBorderColorG = self.optColSet.templateData[i].textureBorderColorG or 0
		templateFrame.textureBorderColorB = self.optColSet.templateData[i].textureBorderColorB or 0
		templateFrame.textureBorderColorA = self.optColSet.templateData[i].textureBorderColorA or 0
		
		templateFrame.optionIconTitles = self.optColSet.templateData[i].iconTitles
		
		local templateDataColorsTablesNames = {"colorsText","colorsBack","colorsTL"}
		for object_c=1,3 do
			for state_c=1,3 do
				templateFrame["optionColor".. colorSetupFrameColorsObjectsNames[object_c] .. colorSetupFrameColorsNames[state_c] ] = {
					r = self.optColSet.templateData[i][ templateDataColorsTablesNames[object_c] ][ (state_c-1)*3+1 ],
					g = self.optColSet.templateData[i][ templateDataColorsTablesNames[object_c] ][ (state_c-1)*3+2 ],
					b = self.optColSet.templateData[i][ templateDataColorsTablesNames[object_c] ][ (state_c-1)*3+3 ],
				}
			end
		end
		
		templateFrame.textureBorderSize = self.optColSet.templateData[i].textureBorderSize or 0
		
		templateFrame.optionSmoothAnimationDuration = module.db.colsDefaults.textureSmoothAnimationDuration
		
		local DiffSpellData = self.optColSet.templateData[i].DiffSpellData
		
		local classColorsTable = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
		
		templateFrame.lines = {}
		for j=1,DiffSpellData and #DiffSpellData.spells or 5 do if not DiffSpellData or DiffSpellData.spells[j] ~= 0 then
			local bar = CreateBar(templateFrame)
			templateFrame.lines[j] = bar
	
			if not self.optColSet.templateData[i].frameColumns then
				bar:SetPoint("TOP",0,-height*(j-1)-10 -betweenLines*(j-1))
			else
				local inLine = (j-1) % self.optColSet.templateData[i].frameColumns
				local line = ExRT.F.Round( ((j-1) - inLine) / self.optColSet.templateData[i].frameColumns )
				if self.optColSet.templateData[i]._twoSized then
					bar:SetPoint("TOPLEFT", inLine*width + 10, -line*height -10 -betweenLines*line) 
				else
					local pos = inLine * width
					local totalWidth = self.optColSet.templateData[i].frameColumns * width
					pos = pos - totalWidth / 2
					bar:SetPoint("TOPLEFT", templateFrame,"TOP",pos, -line*height -10 -betweenLines*line) 	
				end
			end
			
			if self.optColSet.templateData[i]._Scaled then
				bar:SetScale(self.optColSet.templateData[i]._Scaled)
			end
			
			local spellID = DiffSpellData and DiffSpellData.spells[j] or self.optColSet.templateData.spells[j]
			local spellName,_,spellTexture = GetSpellInfo(spellID or 0)
			spellName = spellName or "unk"
			
			local spellClass = DiffSpellData and DiffSpellData.spellsClass[j] or self.optColSet.templateData.spellsClass[j]
		
			bar.data = {
				name = ExRT.SDB.charName,
				fullName = ExRT.SDB.charName,
				icon = spellTexture,
				spellName = i == 3 and spellName:sub(1,spellName:find(' ')) or spellName,
				db = {spellID,spellClass},
				lastUse = GetTime(),
				charge = GetTime(),
				cd = DiffSpellData and DiffSpellData.spellsCD[j] or self.optColSet.templateData.spellsCD[j],
				duration = DiffSpellData and DiffSpellData.spellsDuration[j] or self.optColSet.templateData.spellsDuration[j],
				classColor = classColorsTable[spellClass] or module.db.notAClass,
				
				disabled = ((DiffSpellData and DiffSpellData.spellsDead[j]) or (not DiffSpellData and self.optColSet.templateData.spellsDead[j])) and 1,
				isCharge = DiffSpellData and DiffSpellData.spellsCharge[j] or not DiffSpellData and self.optColSet.templateData.spellsCharge[j],
				
				specialUpdateData = function(data)
					local currTime = GetTime()
					if data.isCharge then
						if (data.charge + data.cd) < currTime then
							data.charge = currTime
							data.lastUse = currTime
						end
						return
					end
					if data.cd ~= 0 then
						if (data.lastUse + data.cd) < currTime then
							data.lastUse = currTime
						end
					elseif data.duration ~= 0 then
						if (data.lastUse + data.duration) < currTime then
							data.lastUse = currTime
						end
					end
				end,
			}
			
			bar:UpdateStyle()
			bar:Update()
			bar:UpdateStatus()
			if spellClass == "title" then
				bar:CreateTitle()
			end
		end end
	end end
	
	self.optColSet.templateRestore = CreateFrame("Button",nil,self.optColSet.superTabFrame.tab[9])
	self.optColSet.templateRestore:SetPoint("TOP",0,-10)
	self.optColSet.templateRestore:SetSize(430,30)
	self.optColSet.templateRestore:SetBackdrop({edgeFile = ExRT.F.defBorder, edgeSize = 8})
	self.optColSet.templateRestore:SetBackdropBorderColor(1,0.5,0.5,1)
	self.optColSet.templateRestore.text = ELib:Text(self.optColSet.templateRestore,L.cd2OtherSetTemplateRestore,12):Point('x'):Center():Color():Shadow()
	self.optColSet.templateRestore:SetScript("OnEnter",function (self)
	  	self.text:SetTextColor(1,1,0,1)
	end)
	self.optColSet.templateRestore:SetScript("OnLeave",function (self)
	  	self.text:SetTextColor(1,1,1,1)	  
	end)
	self.optColSet.templateRestore:SetScript("OnClick",function (self)
		VExRT.ExCD2.colSet[module.options.optColTabs.selected] = {}
		ExRT.F.table_copy(module.options.optColSet.templateSaveData,VExRT.ExCD2.colSet[module.options.optColTabs.selected])
		module:ReloadAllSplits()
		module.options.selectColumnTab()
		self:Hide()
	end)
	self.optColSet.templateRestore:Hide()
	
	do
		module.options.optColTabs.selected = module.db.maxColumns+1
		module.options.tab.tabs[2]:SetScript("OnShow",function ()
			module.options.selectColumnTab(self.optColTabs.tabs[module.db.maxColumns+1].button)
			module.options.tab.tabs[2]:SetScript("OnShow",nil)
		end)
	end	
	
	--> Other setts
	self.optSetTab = ELib:OneTab(self.tab.tabs[2],L.cd2OtherSet):Size(652,34):Point("TOP",0,-532)
	
	self.chkSplit = ELib:Check(self.optSetTab,L.cd2split,VExRT.ExCD2.SplitOpt):Point("LEFT",10,0):Tooltip(L.cd2splittooltip):OnClick(function(self,event)
		if self:GetChecked() then
			VExRT.ExCD2.SplitOpt = true
		else
			VExRT.ExCD2.SplitOpt = nil
		end
		module:SplitExCD2Window()
		module:ReloadAllSplits()
	end)
	
	self.chkNoRaid = ELib:Check(self.optSetTab,L.cd2noraid,VExRT.ExCD2.NoRaid):Point("LEFT",165,0):OnClick(function(self,event)
		if self:GetChecked() then
			VExRT.ExCD2.NoRaid = true
		else
			VExRT.ExCD2.NoRaid = nil
		end
		UpdateRoster()
	end)
	
	self.testMode = ELib:Check(self.optSetTab,L.cd2GeneralSetTestMode,module.db.testMode):Point("LEFT",325,0):Tooltip(L.cd2HelpTestButton):OnClick(function(self,event)
		if self:GetChecked() then
			module.db.testMode = true
		else
			module.db.testMode = nil
			TestMode(1)
		end
		UpdateRoster()
	end)

	self.butResetToDef = ELib:Button(self.optSetTab,L.cd2OtherSetReset):Size(160,20):Point("LEFT",480,0):Tooltip(L.cd2HelpButtonDefault):OnClick(function()
		StaticPopupDialogs["EXRT_EXCD_DEFAULT"] = {
			text = L.cd2OtherSetReset,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				table_wipe2(VExRT.ExCD2.colSet[module.options.optColTabs.selected])
				for optName,optVal in pairs(module.db.colsInit) do
					VExRT.ExCD2.colSet[module.options.optColTabs.selected][optName] = optVal
				end
				VExRT.ExCD2.SortByAvailability = nil
				
				module.options.selectColumnTab(self.optColTabs.tabs[module.options.optColTabs.selected].button)
				module:ReloadAllSplits()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_EXCD_DEFAULT")
	end) 
	
	
	
	--> OPTIONS TAB3: History
	self.butHistoryClear = ELib:Button(self.tab.tabs[3],L.cd2HistoryClear):Size(180,20):Point("TOPRIGHT",-3,-6):OnClick(function()
		table_wipe2(module.db.historyUsage)
		module.options.historyBox.EditBox:SetText("")
	end)
	
	local historyBoxUpdateTable = {}
	local function historyBoxUpdate(v)
		table_wipe2(historyBoxUpdateTable)
		local count = 0
		for i=1,#module.db.historyUsage do
			if VExRT.ExCD2.CDE[module.db.historyUsage[i][2]] then
				count = count + 1
			end
			if count >= v and VExRT.ExCD2.CDE[module.db.historyUsage[i][2]] then
				local tm = date("%X",module.db.historyUsage[i][1])
				local bosshpstr = module.db.historyUsage[i][4] and format(" (%d:%.2d)",module.db.historyUsage[i][4]/60,module.db.historyUsage[i][4]%60) or ""
				local spellName,_,spellIcon = GetSpellInfo(module.db.historyUsage[i][2])
				historyBoxUpdateTable [#historyBoxUpdateTable + 1] = format("|cffffff00[%s]%s|r %s |Hspell:%d|h|T%s:0|t%s|h",tm,bosshpstr,module.db.historyUsage[i][3] or "?",module.db.historyUsage[i][2] or 0,spellIcon or "Interface\\Icons\\Trade_Engineering",spellName or "?")
			end
			if #historyBoxUpdateTable > 44 then
				break
			end
		end
		module.options.historyBox.EditBox:SetText(strjoin("\n",unpack(historyBoxUpdateTable)))
	end
	
	self.historyBox = ELib:MultiEdit2(self.tab.tabs[3]):Size(652,530):Point("TOP",0,-36):Hyperlinks()
	self.historyBox.EditBox:SetScript("OnShow",function(self)
		historyBoxUpdate(1)
		local count = 0
		for i=1,#module.db.historyUsage do
			if VExRT.ExCD2.CDE[module.db.historyUsage[i][2]] then
				count = count + 1
			end
		end
		module.options.historyBox.ScrollBar:SetMinMaxValues(1,max(count,1))
		module.options.historyBox.ScrollBar:UpdateButtons()
	end)
	self.historyBox.ScrollBar:SetScript("OnValueChanged",function (self,val)
		val = ExRT.F.Round(val)
		historyBoxUpdate(val)
		self:UpdateButtons()
	end)
	
	self.HelpPlate = {
		[1] = {
			FramePos = { x = 0, y = 0 },FrameSize = { width = 660, height = 615 },
			[1] = { ButtonPos = { x = 500,	y = -40 },  	HighLightBox = { x = 485, y = -50, width = 170, height = 25 },		ToolTipDir = "LEFT",	ToolTipText = L.cd2HelpFastSetup },
			[2] = { ButtonPos = { x = 0,  y = -135 }, 	HighLightBox = { x = 7, y = -85, width = 34, height = 495 },		ToolTipDir = "RIGHT",	ToolTipText = L.cd2HelpOnOff },
			[3] = { ButtonPos = { x = 250,  y = -135 }, 	HighLightBox = { x = 225, y = -85, width = 150, height = 495 },		ToolTipDir = "DOWN",	ToolTipText = L.cd2HelpCol },
			[4] = { ButtonPos = { x = 375,  y = -135},  	HighLightBox = { x = 380, y = -85, width = 85, height = 495 },		ToolTipDir = "DOWN",	ToolTipText = L.cd2HelpPriority },
			[5] = { ButtonPos = { x = 470,  y = -135 },  	HighLightBox = { x = 465, y = -85, width = 165, height = 495 },		ToolTipDir = "LEFT",	ToolTipText = L.cd2HelpTime },
			[6] = { ButtonPos = { x = 370,  y = -570 },  	HighLightBox = { x = 7, y = -580, width = 625, height = 30 },		ToolTipDir = "UP",	ToolTipText = L.cd2HelpAddButton },
		},
		[2] = {
			FramePos = { x = 0, y = 0 },FrameSize = { width = 660, height = 615 },
			[1] = { ButtonPos = { x = 50,	y = -130 },  	HighLightBox = { x = 0, y = -70, width = 660, height = 480 },		ToolTipDir = "RIGHT",	ToolTipText = L.cd2HelpColSetup },
			[2] = { ButtonPos = { x = 320,	y = -570 },  	HighLightBox = { x = 315, y = -580, width = 140, height = 30 },		ToolTipDir = "LEFT",	ToolTipText = L.cd2HelpTestButton },
			[3] = { ButtonPos = { x = 500,	y = -570 },  	HighLightBox = { x = 490, y = -580, width = 160, height = 30 },		ToolTipDir = "LEFT",	ToolTipText = L.cd2HelpButtonDefault },
		},
		[3] = {
			FramePos = { x = 0, y = 0 },FrameSize = { width = 660, height = 615 },
			[1] = { ButtonPos = { x = 310,	y = -50 },  	HighLightBox = { x = 0, y = -50, width = 660, height = 565 },		ToolTipDir = "DOWN",	ToolTipText = L.cd2HelpHistory },		
		}
	}
	if not ExRT.isClassic then
		self.HELPButton = ExRT.lib.CreateHelpButton(self,self.HelpPlate,self.tab)
		self.HELPButton:SetPoint("CENTER",self,"TOPLEFT",0,15)
	
		function self.HELPButton:Click2()
			local min,max=module.options.ScrollBar:GetMinMaxValues()
			module.options.ScrollBar:SetValue(max)
		end
	end
end

function module.options:CleanUPVariables()
	local cleanUP = {}
	for sett,col in pairs(VExRT.ExCD2.CDECol) do
		local bool = nil
		for i=1,#module.db.spellDB do
			for j=3,7 do
				if module.db.spellDB[i][j] then
					if tonumber( string.gsub(sett,";%d",""),nil ) == module.db.spellDB[i][j][1] then
						bool = true
					end
				end
			end
		end
		if not bool then
			cleanUP [#cleanUP + 1] = sett
		end
	end
	for i=1,#cleanUP do
		VExRT.ExCD2.CDECol[cleanUP[i]] = nil
	end
	table_wipe2(cleanUP)
	for sid,val in pairs(VExRT.ExCD2.CDE) do
		local bool = nil
		for i=1,#module.db.spellDB do
			if sid == module.db.spellDB[i][1] then
				bool = true
			end
		end
		if not bool then
			cleanUP [#cleanUP + 1] = sid
		end
	end
	for i=1,#cleanUP do
		VExRT.ExCD2.CDE[cleanUP[i]] = nil
	end
	table_wipe2(cleanUP)
	for sid,val in pairs(VExRT.ExCD2.Priority) do
		local bool = nil
		for i=1,#module.db.spellDB do
			if sid == module.db.spellDB[i][1] then
				bool = true
			end
		end
		if not bool then
			cleanUP [#cleanUP + 1] = sid
		end
	end
	for i=1,#cleanUP do
		VExRT.ExCD2.Priority[cleanUP[i]] = nil
	end
end

local function CreateBlackList(text)
	local blacklist = {}
	local tmpList = {strsplit("\n", text)}
	for i=1,#tmpList do
		if tmpList[i]~="" then
			if tmpList[i]:find(":(%d+)") then
				local name,spellID = tmpList[i]:match("([^:]+):(%d+)")
				if name and spellID then
					spellID = tonumber(spellID)
					blacklist[ spellID ] = blacklist[ spellID ] or {}
					name = name:lower()
					blacklist[ spellID ][name] = true
				end
			else
				tmpList[i] = tmpList[i]:lower()
				blacklist[ tmpList[i] ] = true
			end
		end
	end
	return blacklist
end
local function CreateWhiteList(text)
	if text == "" then
		return
	end
	local whitelist = {}
	local tmpList = {strsplit("\n", text)}
	for i=1,#tmpList do
		if tmpList[i]~="" then
			tmpList[i] = tmpList[i]:lower()
			whitelist[ tmpList[i] ] = true
		end
	end
	return whitelist
end

local lastSplitsReload = 0
function module:ReloadAllSplits(argScaleFix)
	local _ctime = GetTime()
	if lastSplitsReload > _ctime then
		return
	end
	lastSplitsReload = _ctime + 0.05
	local VExRT_ColumnOptions = VExRT.ExCD2.colSet
	local Width = 0
	local maxHeight = 0
	local maxLine = VExRT_ColumnOptions[module.db.maxColumns+1].frameLines or module.db.colsDefaults.frameLines
	local maxBetweenLines = 0
	if VExRT_ColumnOptions[module.db.maxColumns+1].frameColumns then
		maxLine = ceil(maxLine / VExRT_ColumnOptions[module.db.maxColumns+1].frameColumns)
	end	

	for i=1,module.db.maxColumns do 
		local columnFrame = module.frame.colFrame[i]
		if not columnFrame.LOADEDs then
			columnFrame.LOADEDs = {}
		end
	
		columnFrame.iconSize = (not VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[i].iconSize) or (VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].iconSize) or module.db.colsDefaults.iconSize
		if VExRT_ColumnOptions[i].enabled and columnFrame.iconSize > maxHeight then
			maxHeight = columnFrame.iconSize
		end
		
		local frameBetweenLines = (not VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[i].frameBetweenLines) or (VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].frameBetweenLines) or module.db.colsDefaults.frameBetweenLines

		local frameColumns = (not VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[i].frameColumns) or (VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].frameColumns) or module.db.colsDefaults.frameColumns
		columnFrame.frameColumns = frameColumns
		local linesShown = (not VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[i].frameLines) or (VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].frameLines) or module.db.colsDefaults.frameLines	
		linesShown = ceil(linesShown / frameColumns)
		local linesTotal = linesShown * frameColumns
		if VExRT.ExCD2.SplitOpt then 
			columnFrame:SetHeight(columnFrame.iconSize*linesShown+frameBetweenLines*(linesShown-1)) 
		else
			columnFrame:SetHeight(columnFrame.iconSize*linesShown)
			if VExRT_ColumnOptions[i].enabled then
				if linesShown > maxLine then
					maxLine = linesShown
				end
				local nowBetweenLines = frameBetweenLines*(linesShown-1)
				if nowBetweenLines > maxBetweenLines then
					maxBetweenLines = nowBetweenLines
				end
			end
		end
		columnFrame.NumberLastLinesActive = module.db.maxLinesInCol
		
		if VExRT_ColumnOptions[i].enabled then
			for j=1,linesTotal do
				if not columnFrame.LOADEDs[j] then
					columnFrame.lines[j] = CreateBar(columnFrame)
					columnFrame.lines[j]:Hide()
					columnFrame.LOADEDs[j] = true
				end
			end
			columnFrame.IsColumnEnabled = true
		else
			columnFrame.IsColumnEnabled = false
		end

		local frameAlpha = (not VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[i].frameAlpha) or (VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].frameAlpha) or module.db.colsDefaults.frameAlpha
		columnFrame:SetAlpha(frameAlpha/100) 

		local frameScale = (not VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[i].frameScale) or (VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].frameScale) or module.db.colsDefaults.frameScale
		if VExRT.ExCD2.SplitOpt then 
			if argScaleFix == "ScaleFix" then
				ExRT.F.SetScaleFix(columnFrame,frameScale/100)
			else
				columnFrame:SetScale(frameScale/100) 
			end
		else
			columnFrame:SetScale(1)
		end
		
		local blackBack = (not VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[i].frameBlackBack) or (VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].frameBlackBack) or module.db.colsDefaults.frameBlackBack
		columnFrame.texture:SetColorTexture(0,0,0,blackBack / 100)
		
		--> View options
		columnFrame.optionClassColorBackground = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureClassBackground) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureClassBackground)
		columnFrame.optionClassColorTimeLine = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureClassTimeLine) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureClassTimeLine)
		columnFrame.optionClassColorText = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureClassText) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureClassText)

		columnFrame.optionAnimation = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureAnimation) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureAnimation)
		columnFrame.optionSmoothAnimation = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureSmoothAnimation) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureSmoothAnimation)
		columnFrame.optionSmoothAnimationDuration = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureSmoothAnimationDuration) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureSmoothAnimationDuration) or module.db.colsDefaults.textureSmoothAnimationDuration
			columnFrame.optionSmoothAnimationDuration = columnFrame.optionSmoothAnimationDuration / 100
		columnFrame.optionLinesMax = min(linesShown*frameColumns,module.db.maxLinesInCol)
		columnFrame.optionShownOnCD = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsShownOnCD) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsShownOnCD)
		columnFrame.optionIconPosition = (not VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[i].iconPosition) or (VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].iconPosition) or module.db.colsDefaults.iconPosition
		columnFrame.optionStyleAnimation = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsStyleAnimation) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsStyleAnimation) or module.db.colsDefaults.methodsStyleAnimation
		columnFrame.optionTimeLineAnimation = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsTimeLineAnimation) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsTimeLineAnimation) or module.db.colsDefaults.methodsTimeLineAnimation
		columnFrame.optionCooldown = (not VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[i].methodsCooldown) or (VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsCooldown)
		columnFrame.optionCooldownHideNumbers = (not VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[i].iconCooldownHideNumbers) or (VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].iconCooldownHideNumbers)
		columnFrame.optionCooldownShowSwipe = (not VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[i].iconCooldownShowSwipe) or (VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].iconCooldownShowSwipe)
		columnFrame.optionIconName = (not VExRT_ColumnOptions[i].textGeneral and VExRT_ColumnOptions[i].textIconName) or (VExRT_ColumnOptions[i].textGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textIconName)
		columnFrame.optionHideSpark = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureHideSpark) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureHideSpark)
		columnFrame.optionIconTitles = (not VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[i].iconTitles) or (VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].iconTitles)
			columnFrame.optionIconTitles = columnFrame.optionIconTitles and not (columnFrame.optionIconPosition == 3)
		columnFrame.optionIconHideBlizzardEdges = (not VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[i].iconHideBlizzardEdges) or (VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].iconHideBlizzardEdges)
		
		columnFrame.methodsIconTooltip = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsIconTooltip) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsIconTooltip) 
		columnFrame.methodsLineClick = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsLineClick) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsLineClick)
		columnFrame.methodsLineClickWhisper = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsLineClickWhisper) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsLineClickWhisper)
		columnFrame.methodsNewSpellNewLine = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsNewSpellNewLine) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsNewSpellNewLine)
		columnFrame.methodsSortingRules = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsSortingRules) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsSortingRules) or module.db.colsDefaults.methodsSortingRules
		columnFrame.methodsHideOwnSpells = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsHideOwnSpells) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsHideOwnSpells)
		columnFrame.methodsAlphaNotInRange = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsAlphaNotInRange) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsAlphaNotInRange)
		columnFrame.methodsAlphaNotInRangeNum = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsAlphaNotInRangeNum) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsAlphaNotInRangeNum) or module.db.colsDefaults.methodsAlphaNotInRangeNum
			columnFrame.methodsAlphaNotInRangeNum = columnFrame.methodsAlphaNotInRangeNum / 100
		columnFrame.methodsDisableActive = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsDisableActive) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsDisableActive)
		columnFrame.methodsOneSpellPerCol = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].methodsOneSpellPerCol) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsOneSpellPerCol)
		
		columnFrame.methodsOnlyInCombat = (not VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[i].methodsOnlyInCombat) or (VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].methodsOnlyInCombat)
		columnFrame.visibilityPartyType = (not VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[i].visibilityPartyType) or (VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].visibilityPartyType)
		columnFrame.visibilityArena = not ( (not VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[i].visibilityDisableArena) or (VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].visibilityDisableArena) )
		columnFrame.visibilityBG = not ( (not VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[i].visibilityDisableBG) or (VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].visibilityDisableBG) )
		columnFrame.visibility3ppl = not ( (not VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[i].visibilityDisable3ppl) or (VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].visibilityDisable3ppl) )
		columnFrame.visibility5ppl = not ( (not VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[i].visibilityDisable5ppl) or (VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].visibilityDisable5ppl) )
		columnFrame.visibilityRaid = not ( (not VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[i].visibilityDisableRaid) or (VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].visibilityDisableRaid) )
		columnFrame.visibilityWorld = not ( (not VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[i].visibilityDisableWorld) or (VExRT_ColumnOptions[i].visibilityGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].visibilityDisableWorld) )

		columnFrame.textTemplateLeft = (not VExRT_ColumnOptions[i].textGeneral and VExRT_ColumnOptions[i].textTemplateLeft) or (VExRT_ColumnOptions[i].textGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textTemplateLeft) or module.db.colsDefaults.textTemplateLeft
		columnFrame.textTemplateRight = (not VExRT_ColumnOptions[i].textGeneral and VExRT_ColumnOptions[i].textTemplateRight) or (VExRT_ColumnOptions[i].textGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textTemplateRight) or module.db.colsDefaults.textTemplateRight
		columnFrame.textTemplateCenter = (not VExRT_ColumnOptions[i].textGeneral and VExRT_ColumnOptions[i].textTemplateCenter) or (VExRT_ColumnOptions[i].textGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textTemplateCenter) or module.db.colsDefaults.textTemplateCenter
		
		local blacklistText = (not VExRT_ColumnOptions[i].blacklistGeneral and VExRT_ColumnOptions[i].blacklistText) or (VExRT_ColumnOptions[i].blacklistGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].blacklistText) or module.db.colsDefaults.blacklistText
		columnFrame.BlackList = CreateBlackList(blacklistText)
		local whitelistText = (not VExRT_ColumnOptions[i].blacklistGeneral and VExRT_ColumnOptions[i].whitelistText) or (VExRT_ColumnOptions[i].blacklistGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].whitelistText) or module.db.colsDefaults.whitelistText
		columnFrame.WhiteList = CreateWhiteList(whitelistText)
		
		local frameWidth = (not VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[i].frameWidth) or (VExRT_ColumnOptions[i].frameGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].frameWidth) or module.db.colsDefaults.frameWidth
		columnFrame:SetWidth(frameWidth*frameColumns)
		columnFrame.barWidth = frameWidth
		
		columnFrame.optionGray = (not VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[i].iconGray) or (VExRT_ColumnOptions[i].iconGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].iconGray)
		columnFrame.fontSize = (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontSize) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontSize) or module.db.colsDefaults.fontSize
		columnFrame.fontName = (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontName) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontName) or module.db.colsDefaults.fontName
		columnFrame.fontOutline = (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontOutline) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontOutline)
		columnFrame.fontShadow = (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontShadow) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontShadow)
		columnFrame.textureFile = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureFile) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureFile) or module.db.colsDefaults.textureFile
		columnFrame.textureBorderSize = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureBorderSize) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureBorderSize) or module.db.colsDefaults.textureBorderSize

		columnFrame.textureBorderColorR = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureBorderColorR) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureBorderColorR) or module.db.colsDefaults.textureBorderColorR
		columnFrame.textureBorderColorG = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureBorderColorG) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureBorderColorG) or module.db.colsDefaults.textureBorderColorG
		columnFrame.textureBorderColorB = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureBorderColorB) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureBorderColorB) or module.db.colsDefaults.textureBorderColorB
		columnFrame.textureBorderColorA = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureBorderColorA) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureBorderColorA) or module.db.colsDefaults.textureBorderColorA

		local fontOtherAvailable = (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontOtherAvailable) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontOtherAvailable)

		columnFrame.fontLeftSize = (not fontOtherAvailable and columnFrame.fontSize) or (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontLeftSize) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontLeftSize) or module.db.colsDefaults.fontSize
		columnFrame.fontLeftName = (not fontOtherAvailable and columnFrame.fontName) or (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontLeftName) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontLeftName) or module.db.colsDefaults.fontName
		columnFrame.fontLeftOutline = (not fontOtherAvailable and columnFrame.fontOutline) or (fontOtherAvailable and ((not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontLeftOutline) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontLeftOutline)))
		columnFrame.fontLeftShadow = (not fontOtherAvailable and columnFrame.fontShadow) or (fontOtherAvailable and ((not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontLeftShadow) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontLeftShadow)))

		columnFrame.fontRightSize = (not fontOtherAvailable and columnFrame.fontSize) or (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontRightSize) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontRightSize) or module.db.colsDefaults.fontSize
		columnFrame.fontRightName = (not fontOtherAvailable and columnFrame.fontName) or (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontRightName) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontRightName) or module.db.colsDefaults.fontName
		columnFrame.fontRightOutline = (not fontOtherAvailable and columnFrame.fontOutline) or (fontOtherAvailable and ((not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontRightOutline) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontRightOutline)))
		columnFrame.fontRightShadow = (not fontOtherAvailable and columnFrame.fontShadow) or (fontOtherAvailable and ((not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontRightShadow) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontRightShadow)))

		columnFrame.fontCenterSize = (not fontOtherAvailable and columnFrame.fontSize) or (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontCenterSize) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontCenterSize) or module.db.colsDefaults.fontSize
		columnFrame.fontCenterName = (not fontOtherAvailable and columnFrame.fontName) or (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontCenterName) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontCenterName) or module.db.colsDefaults.fontName
		columnFrame.fontCenterOutline = (not fontOtherAvailable and columnFrame.fontOutline) or (fontOtherAvailable and ((not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontCenterOutline) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontCenterOutline)))
		columnFrame.fontCenterShadow = (not fontOtherAvailable and columnFrame.fontShadow) or (fontOtherAvailable and ((not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontCenterShadow) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontCenterShadow)))

		columnFrame.fontIconSize = (not fontOtherAvailable and columnFrame.fontSize) or (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontIconSize) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontIconSize) or module.db.colsDefaults.fontSize
		columnFrame.fontIconName = (not fontOtherAvailable and columnFrame.fontName) or (not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontIconName) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontIconName) or module.db.colsDefaults.fontName
		columnFrame.fontIconOutline = (not fontOtherAvailable and columnFrame.fontOutline) or (fontOtherAvailable and ((not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontIconOutline) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontIconOutline)))
		columnFrame.fontIconShadow = (not fontOtherAvailable and columnFrame.fontShadow) or (fontOtherAvailable and ((not VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[i].fontIconShadow) or (VExRT_ColumnOptions[i].fontGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].fontIconShadow)))

		for j=1,3 do
			for n=1,3 do
				local object = colorSetupFrameColorsObjectsNames[j]
				local state = colorSetupFrameColorsNames[n]
				if not columnFrame["optionColor"..object..state] then
					columnFrame["optionColor"..object..state] = {}
				end

				columnFrame["optionColor"..object..state].r = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i]["textureColor"..object..state.."R"]) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1]["textureColor"..object..state.."R"]) or module.db.colsDefaults["textureColor"..object..state.."R"]
				columnFrame["optionColor"..object..state].g = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i]["textureColor"..object..state.."G"]) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1]["textureColor"..object..state.."G"]) or module.db.colsDefaults["textureColor"..object..state.."G"]
				columnFrame["optionColor"..object..state].b = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i]["textureColor"..object..state.."B"]) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1]["textureColor"..object..state.."B"]) or module.db.colsDefaults["textureColor"..object..state.."B"]
			end
		end

		columnFrame.optionAlphaBackground = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureAlphaBackground) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureAlphaBackground) or module.db.colsDefaults.textureAlphaBackground
		columnFrame.optionAlphaTimeLine = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureAlphaTimeLine) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureAlphaTimeLine) or module.db.colsDefaults.textureAlphaTimeLine
		columnFrame.optionAlphaCooldown = (not VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[i].textureAlphaCooldown) or (VExRT_ColumnOptions[i].textureGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].textureAlphaCooldown) or module.db.colsDefaults.textureAlphaCooldown

		if VExRT_ColumnOptions[i].enabled then
			--for n=1,linesTotal do
			for n=1,#columnFrame.lines do
				columnFrame.lines[n]:UpdateStyle()
				if columnFrame.lines[n]:IsVisible() then
					columnFrame.lines[n]:UpdateStatus()
				end
			end
		
			local frameAnchorBottom = (not VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[i].frameAnchorBottom) or (VExRT_ColumnOptions[i].methodsGeneral and VExRT_ColumnOptions[module.db.maxColumns+1].frameAnchorBottom)
			if frameAnchorBottom then
				local lastLine = nil
				for n=1,linesTotal do 
					local inLine = (n-1) % frameColumns
					local line = ((n-1) - inLine) / frameColumns
					columnFrame.lines[n]:ClearAllPoints() 
					columnFrame.lines[n]:SetPoint("BOTTOMLEFT", inLine*frameWidth, line*columnFrame.iconSize+line*frameBetweenLines) 
					
					if line ~= lastLine then
						columnFrame.lines[n].IsNewLine = true
					else
						columnFrame.lines[n].IsNewLine = nil
					end
					lastLine = line
				end
			else
				local lastLine = nil
				for n=1,linesTotal do 
					local inLine = (n-1) % frameColumns
					local line = ExRT.F.Round( ((n-1) - inLine) / frameColumns )
					columnFrame.lines[n]:ClearAllPoints()
					columnFrame.lines[n]:SetPoint("TOPLEFT", inLine*frameWidth, -line*columnFrame.iconSize-line*frameBetweenLines) 
					
					if line ~= lastLine then
						columnFrame.lines[n].IsNewLine = true
					else
						columnFrame.lines[n].IsNewLine = nil
					end
					lastLine = line
				end
			end
		end
		
		if VExRT_ColumnOptions[i].enabled and VExRT.ExCD2.enabled then
			columnFrame.optionIsEnabled = true
			columnFrame:Show()
		else
			columnFrame.optionIsEnabled = nil
			columnFrame:Hide()
		end
		if not VExRT.ExCD2.SplitOpt then
			columnFrame:ClearAllPoints()
			columnFrame:SetPoint("TOPLEFT",module.frame,Width, 0)
		else
			if VExRT_ColumnOptions[i].posX and VExRT_ColumnOptions[i].posY then
				columnFrame:ClearAllPoints()
				columnFrame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT_ColumnOptions[i].posX,VExRT_ColumnOptions[i].posY)
			else
				columnFrame:ClearAllPoints()
				columnFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
			end
		end
		if VExRT_ColumnOptions[i].enabled then
			Width = Width + frameWidth*frameColumns
		end
	end
	module.frame:SetWidth(Width)
	module.frame:SetHeight(maxHeight*maxLine + maxBetweenLines)
	module.frame:SetAlpha((VExRT_ColumnOptions[module.db.maxColumns+1].frameAlpha or module.db.colsDefaults.frameAlpha)/100)
	if argScaleFix == "ScaleFix" then
		ExRT.F.SetScaleFix(module.frame,(VExRT_ColumnOptions[module.db.maxColumns+1].frameScale or module.db.colsDefaults.frameScale)/100)
	else
		module.frame:SetScale((VExRT_ColumnOptions[module.db.maxColumns+1].frameScale or module.db.colsDefaults.frameScale)/100) 
	end
	
	module:updateCombatVisibility()
	
 	SortAllData()
 	UpdateAllData()
end

function module:SplitExCD2Window()
	if VExRT.ExCD2.SplitOpt then
		for i=1,module.db.maxColumns do 
			module.frame.colFrame[i]:SetParent(UIParent)
			module.frame.colFrame[i]:EnableMouse(false)

			if not VExRT.ExCD2.lock then 
				ExRT.F.LockMove(module.frame.colFrame[i],true,module.frame.colFrame[i].lockTexture)
				ExRT.lib.AddShadowComment(module.frame.colFrame[i],nil,L.cd2,i,72,"OUTLINE")
			end
		end
		module.frame:Hide()
	else
		for i=1,module.db.maxColumns do 
			module.frame.colFrame[i]:SetParent(module.frame)
			ExRT.F.LockMove(module.frame.colFrame[i],nil,module.frame.colFrame[i].lockTexture)
			ExRT.lib.AddShadowComment(module.frame.colFrame[i],1)
		end
		module.frame:Show()
	end

end

function module:slash(arg1,arg2)
	if string.find(arg1,"runcd ") then
		local sid,name = arg2:match("%a+ (%d+) (.+)")
		if sid and name then
			print("Run CD "..sid.." by "..name)
			module.main:COMBAT_LOG_EVENT_UNFILTERED(nil,"SPELL_CAST_SUCCESS",nil,nil,name,nil,nil,nil,nil,nil,nil,sid)
		end
	elseif string.find(arg1,"resetcd ") then
		local sid,name = arg2:match("%a+ (%d+) (.+)")
		if sid and name then
			print("Reset CD "..sid.." by "..name)
			local j = module.db.cdsNav[name][sid]
			if j then
				j[3] = 0
			end
		end
	end
end


module.db.AllClassSpellsInText = [[
--06.07.2018, Build 26999 Beta
local module = GExRT.A.ExCD2
module.db.allClassSpells = {
["WARRIOR"] = {
	{107574,3,	nil,			nil,			nil,			{107574,90,	0},	},	--Avatar
	{6673,	1,	{6673,	15,	0},	nil,			nil,			nil,			},	--Battle Shout
	{18499,	4,	{18499,	60,	6},	nil,			nil,			nil,			},	--Berserker Rage
	{227847,3,	nil,			{227847,90,	6},	nil,			nil,			},	--Bladestorm
	{100,	3,	nil,			{100,	20,	0},	{100,	20,	0},	nil,			},	--Charge
	{167105,3,	nil,			{167105,45,	10},	nil,			nil,			},	--Colossus Smash
	{1160,	4,	nil,			nil,			nil,			{1160,	45,	8},	},	--Demoralizing Shout
	{118038,4,	nil,			{118038,180,	8},	nil,			nil,			},	--Die by the Sword
	{184364,4,	nil,			nil,			{184364,120,	8},	nil,			},	--Enraged Regeneration
	{6544,	4,	{52174,	45,	0},	nil,			nil,			nil,			},	--Heroic Leap
	{57755,	3,	{57755,	6,	0},	nil,			nil,			nil,			},	--Heroic Throw
	{198304,2,	nil,			nil,			nil,			{198304,15,	0},	},	--Intercept
	{5246,	1,	{5246,	90,	8},	nil,			nil,			nil,			},	--Intimidating Shout
	{12975,	4,	nil,			nil,			nil,			{12975,	180,	15},	},	--Last Stand
	{7384,	3,	nil,			{7384,	12,	0},	nil,			nil,			},	--Overpower
	{6552,	5,	{6552,	15,	0},	nil,			nil,			nil,			},	--Pummel
	{97462,	1,	{97462,	180,	10},	nil,			nil,			nil,			},	--Rallying Cry
	{1719,	3,	nil,			nil,			{1719,	90,	10},	nil,			},	--Recklessness
	{2565,	4,	nil,			nil,			nil,			{2565,	18,	6},	},	--Shield Block
	{871,	4,	nil,			nil,			nil,			{871,	240,	8},	},	--Shield Wall
	{46968,	1,	nil,			nil,			nil,			{46968,	30,	2},	},	--Shockwave
	{23920,	4,	nil,			nil,			nil,			{23920,	25,	5},	},	--Spell Reflection
	{260708,3,	nil,			{260708,25,	12},	nil,			nil,			},	--Sweeping Strikes
	{355,	5,	{355,	8,	0},	nil,			nil,			nil,			},	--Taunt
	{107570,3,	{107570,30,	0},	nil,			nil,			nil,			},	--Storm Bolt
	
	{107574,3,	nil,			{107574,90,	20},	nil,			nil,			},	--Avatar
	{262228,3,	nil,			{262228,60,	6},	nil,			nil,			},	--Deadly Calm
	{197690,4,	nil,			{197690,6,	0},	nil,			nil,			},	--Defensive Stance
	{202168,3,	{202168,30,	0},	nil,			nil,			nil,			},	--Impending Victory
	{152277,3,	nil,			{152277,60,	0},	nil,			nil,			},	--Ravager
	{260643,3,	nil,			{260643,21,	0},	nil,			nil,			},	--Skullsplitter
	{262161,3,	nil,			{262161,45,	0},	nil,			nil,			},	--Warbreaker
	
	{46924,	3,	nil,			nil,			{46924,	60,	4},	nil,			},	--Bladestorm
	{118000,3,	nil,			nil,			{118000,35,	0},	{118000,35,	0},	},	--Dragon Roar
	{280772,3,	nil,			nil,			{280772,30,	10},	nil,			},	--Siegebreaker

	{228920,3,	nil,			nil,			nil,			{228920,60,	0},	},	--Ravager
},
["PALADIN"] = {
	{31850,	4,	nil,			nil,			{31850,	120,	8},	nil,			},	--Ardent Defender
	{31821,	1,	nil,			{31821,	180,	8},	nil,			nil,			},	--Aura Mastery
	{31935,	3,	nil,			nil,			{31935,	15,	0},	nil,			},	--Avenger's Shield
	{31884,	1,	{31884,	120,	20},	nil,			nil,			nil,			},	--Avenging Wrath
	{1044,	2,	{1044,	25,	8},	nil,			nil,			nil,			},	--Blessing of Freedom
	{1022,	2,	{1022,	300,	10},	nil,			nil,			nil,			},	--Blessing of Protection
	{6940,	2,	nil,			{6940,	120,	12},	{6940,	120,	12},	nil,			},	--Blessing of Sacrifiece	
	{4987,	5,	nil,			{4987,	8,	0},	nil,			nil,			},	--Cleanse
	{213644,5,	nil,			nil,			{213644,8,	0},	{213644,8,	0},	},	--Cleanse Toxins
	{26573,	3,	nil,			{26573,	4.5,	0},	{26573,	4.5,	0},	nil,			},	--Consecration
	{498,	4,	nil,			{498,	60,	8},	nil,			nil,			},	--Divine Protection
	{642,	2,	{642,	300,	8},	nil,			nil,			nil,			},	--Divine Shield
	{190784,4,	{190784,45,	3},	nil,			nil,			nil,			},	--Divine Steed
	{86659,	4,	nil,			nil,			{86659,	300,	8},	nil,			},	--Guardian of Ancient Kings
	{853,	3,	{853,	60,	6},	nil,			nil,			nil,			},	--Hammer of Justice
	{62124,	5,	{62124,	8,	0},	nil,			nil,			nil,			},	--Hand of Reckoning
	{183218,3,	nil,			nil,			nil,			{183218,30,	10},	},	--Hand of Hindrance
	{20473,	3,	nil,			{20473,	9,	0},	nil,			nil,			},	--Holy Shock
	{633,	2,	{633,	600,	0},	nil,			nil,			nil,			},	--Lay on Hands
	{85222,	3,	nil,			{85222,	12,	0},	nil,			nil,			},	--Light of Dawn
	{96231,	5,	nil,			nil,			{96231,	15,	0},	{96231,	15,	0},	},	--Rebuke
	{184662,4,	nil,			nil,			nil,			{184662,120,	15},	},	--Shield of Vengeance
	
	{216331,1,	nil,			{216331,120,	20},	nil,			nil,			},	--Avenging Crusader
	{200025,3,	nil,			{200025,15,	8},	nil,			nil,			},	--Beacon of Virtue
	{223306,3,	nil,			{223306,12,	5},	nil,			nil,			},	--Bestow Faith
	{115750,3,	{115750,90,	0},	nil,			nil,			nil,			},	--Blinding Light
	{105809,3,	nil,			{105809,90,	20},	nil,			nil,			},	--Holy Avenger
	{114165,3,	nil,			{114165,20,	0},	nil,			nil,			},	--Holy Prism
	{114158,3,	nil,			{114158,60,	14},	nil,			nil,			},	--Light's Hammer
	{20066,	3,	{20066,	15,	0},	nil,			nil,			nil,			},	--Repentance
	{214202,3,	nil,			{214202,30,	10},	nil,			nil,			},	--Rule of Law	

	{204150,1,	nil,			nil,			{204150,180,	6},	nil,			},	--Aegis of Light
	{204035,3,	nil,			nil,			{204035,120,	0},	nil,			},	--Bastion of Light
	{204018,2,	nil,			nil,			{204018,180,	10},	nil,			},	--Blessing of Spellwarding
	{152262,3,	nil,			nil,			{152262,45,	0},	nil,			},	--Seraphim
	
	{205228,3,	nil,			nil,			nil,			{205228,20,	0},	},	--Consecration
	{231895,3,	nil,			nil,			nil,			{231895,120,	20},	},	--Crusade
	{267798,3,	nil,			nil,			nil,			{267798,30,	12},	},	--Execution Sentence
	{205191,3,	nil,			nil,			nil,			{205191,60,	0},	},	--Eye for an Eye
	{24275,	3,	nil,			nil,			nil,			{24275,	7.5,	0},	},	--Hammer of Wrath
	{255937,3,	nil,			nil,			nil,			{255937,45,	0},	},	--Wake of Ashes
	{210191,3,	nil,			nil,			nil,			{210191,60,	0},	},	--World of Glory
},
["HUNTER"] = {
	{186257,4,	{186257,180,	12},	nil,			nil,			nil,			},	--Aspect of the Cheetah
	{186289,3,	nil,			nil,			nil,			{186289,90,	0},	},	--Aspect of the Eagle
	{186265,4,	{186265,180,	8},	nil,			nil,			nil,			},	--Aspect of the Turtle
	{193530,3,	nil,			{193530,120,	20},	nil,			nil,			},	--Aspect of the Wild
	{19574,	3,	nil,			{19574,	90,	15},	nil,			nil,			},	--Bestial Wrath
	{186387,3,	nil,			nil,			{186387,30,	0},	nil,			},	--Bursting Shot
	{187708,3,	nil,			nil,			nil,			{187708,6,	0},	},	--Carve
	{5116,	3,	nil,			{5116,	5,	0},	{5116,	5,	0},	nil,			},	--Concussive Shot
	{266779,3,	nil,			nil,			nil,			{266779,120,	0},	},	--Coordinated Assault
	{147362,3,	nil,			{147362,24,	0},	{147362,24,	0},	nil,			},	--Counter Shot
	{781,	4,	{781,	20,	0},	nil,			nil,			nil,			},	--Disengage
	{109304,3,	{109304,120,	0},	nil,			nil,			nil,			},	--Exhilaration
	{5384,	3,	{5384,	30,	0},	nil,			nil,			nil,			},	--Feign Death
	{1543,	3,	{1543,	20,	0},	nil,			nil,			nil,			},	--Flare
	{187650,3,	{187650,30,	0},	nil,			nil,			nil,			},	--Freezing Trap
	{19577,	3,	nil,			{19577,	60,	0},	nil,			{19577,	60,	0},	},	--Intimidation
	{34026,	3,	nil,			{34026,	7.5,	0},	nil,			nil,			},	--Kill Command
	{34477,	3,	{34477,	30,	0},	nil,			nil,			nil,			},	--Misdirection
	{187707,3,	nil,			nil,			nil,			{187707,15,	0},	},	--Muzzle
	{257044,3,	nil,			nil,			{257044,20,	0},	nil,			},	--Rapid Fire
	{187698,3,	{187698,30,	0},	nil,			nil,			nil,			},	--Tar Trap
	{288613,3,	nil,			nil,			{288613,120,	15},	nil,			},	--Trueshot
	
	{131894,3,	{131894,60,	15},	nil,			nil,			nil,			},	--A Murder of Crows
	{120360,3,	nil,			{120360,20,	3},	{120360,20,	3},	nil,			},	--Barrage
	{109248,3,	{109248,45,	0},	nil,			nil,			nil,			},	--Binding Shot
	{199483,3,	{199483,60,	0},	nil,			nil,			nil,			},	--Camouflage
	{53209,	3,	nil,			{53209,	15,	0},	nil,			nil,			},	--Chimaera Shot
	{120679,3,	nil,			{120679,20,	0},	nil,			nil,			},	--Dire Beast
	{194407,3,	nil,			{194407,90,	0},	nil,			nil,			},	--Spitting Cobra
	{201430,3,	nil,			{201430,180,	12},	nil,			nil,			},	--Stampede
	
	{260402,3,	nil,			nil,			{260402,60,	0},	nil,			},	--Double Tap
	{212431,3,	nil,			nil,			{212431,30,	0},	nil,			},	--Explosive Shot
	{198670,3,	nil,			nil,			{198670,30,	0},	nil,			},	--Piercing Shot
	
	{259391,3,	nil,			nil,			nil,			{259391,20,	0},	},	--Chakrams
	{269751,3,	nil,			nil,			nil,			{269751,40,	0},	},	--Flanking Strike
	{162488,3,	nil,			nil,			nil,			{162488,30,	0},	},	--Steel Trap	
},
["ROGUE"] = {
	{13750,	3,	nil,			nil,			{13750,	180,	20},	nil,			},	--Adrenaline Rush
	{199804,3,	nil,			nil,			{199804,30,	0},	nil,			},	--Between the Eyes
	{13877,	3,	nil,			nil,			{13877,	25,	12},	nil,			},	--Blade Flurry
	{2094,	3,	{2094,	120,	0},	nil,			nil,			nil,			},	--Blind
	{31224,	4,	{31224,	120,	5},	nil,			nil,			nil,			},	--Cloak of Shadows
	{185311,4,	{185311,30,	6},	nil,			nil,			nil,			},	--Crimson Vial
	{1725,	3,	{1725,	30,	10},	nil,			nil,			nil,			},	--Distract
	{5277,	4,	nil,			{5277,	120,	10},	nil,			{5277,	120,	10},	},	--Evasion
	{1966,	4,	{1966,	15,	5},	nil,			nil,			nil,			},	--Feint
	{703,	3,	nil,			{703,	6,	0},	nil,			nil,			},	--Garrote
	{1776,	3,	nil,			nil,			{1776,	15,	0},	nil,			},	--Gouge
	{195457,3,	nil,			nil,			{195457,60,	0},	nil,			},	--Grappling Hook
	{1766,	5,	{1766,	15,	0},	nil,			nil,			nil,			},	--Kick
	{408,	3,	nil,			{408,	20,	0},	nil,			{408,	20,	0},	},	--Kidney Shot
	{199754,3,	nil,			nil,			{199754,120,	0},	nil,			},	--Riposte
	{185313,3,	nil,			nil,			nil,			{185313,60,	5},	},	--Shadow dance
	{36554,	4,	nil,			{36554,	30,	2},	nil,			{36554,	30,	2},	},	--Shadowstep
	{121471,3,	nil,			nil,			nil,			{121471,180,	20},	},	--Shadow Blades
	{114018,1,	{114018,360,	15},	nil,			nil,			nil,			},	--Shroud of Concealment
	{2983,	4,	{2983,	120,	8},	nil,			nil,			nil,			},	--Sprint
	{212283,3,	nil,			nil,			nil,			{212283,30,	10},	},	--Symbols of Death
	{57934,	3,	{57934,	30,	6},	nil,			nil,			nil,			},	--Tricks of the Trade
	{1856,	4,	{1856,	120,	3},	nil,			nil,			nil,			},	--Vanish
	{79140,	3,	nil,			{79140,	120,	20},	nil,			nil,			},	--Vendetta
	
	{200806,3,	nil,			{200806,45,	0},	nil,			nil,			},	--Exsanguinate
	{137619,3,	{137619,60,	0},	nil,			nil,			nil,			},	--Marked for Death
	{245388,3,	nil,			{245388,25,	0},	nil,			nil,			},	--Toxic Blade
	
	{271877,3,	nil,			nil,			{271877,45,	0},	nil,			},	--Blade Rush
	{196937,3,	nil,			nil,			{196937,35,	0},	nil,			},	--Ghostly Strike
	{51690,	3,	nil,			nil,			{51690,	120,	0},	nil,			},	--Killing Spree
	
	{280719,3,	nil,			nil,			nil,			{280719,45,	0},	},	--Secret Technique
	{277925,3,	nil,			nil,			nil,			{277925,60,	4},	},	--Shuriken Tornado
},
["PRIEST"] = {
	{19236,	4,	nil,			{19236,	90,	10},	{19236,	90,	10},	nil,			},	--Desperate Prayer
	{47585,	4,	nil,			nil,			nil,			{47585,	120,	6},	},	--Dispersion
	{64843,	1,	nil,			nil,			{64843,	180,	8},	nil,			},	--Divine Hymn
	{586,	4,	{586,	30,	10},	nil,			nil,			nil,			},	--Fade
	{47788,	2,	nil,			nil,			{47788,	180,	10},	nil,			},	--Guardian Spirit
	{14914,	3,	nil,			nil,			{14914,	10,	0},	nil,			},	--Holy Fire
	{88625,	3,	nil,			nil,			{88625,	60,	0},	nil,			},	--Holy Word: Chastise
	{34861,	3,	nil,			nil,			{34861,	60,	0},	nil,			},	--Holy Word: Sanctify
	{2050,	3,	nil,			nil,			{2050,	60,	0},	nil,			},	--Holy Word: Serenity
	{73325,	2,	{73325,	90,	0},	nil,			nil,			nil,			},	--Leap of Faith
	{32375,	1,	{32375,	45,	0},	nil,			nil,			nil,			},	--Mass Dispel
	{33206,	2,	nil,			{33206,	180,	8},	nil,			nil,			},	--Pain Suppression
	{62618,	1,	nil,			{62618,	180,	10},	nil,			nil,			},	--Power Word: Barrier
	{194509,3,	nil,			{194509,20,	0},	nil,			nil,			},	--Power Word: Radiance
	{33076,	3,	nil,			nil,			{33076,	12,	0},	nil,			},	--Prayer of Mending
	{8122,	3,	{8122,	60,	8},	nil,			nil,			nil,			},	--Psychic Scream
	{527,	5,	nil,			{527,	8,	0},	{527,	8,	0},	nil,			},	--Purify
	{213634,5,	nil,			nil,			nil,			{213634,8,	0},	},	--Purify Disease
	{47536,	1,	nil,			{47536,	90,	10},	nil,			nil,			},	--Rapture
	{34433,	3,	nil,			{34433,	180,	15},	nil,			{34433,	180,	15},	},	--Shadowfiend
	{15487,	3,	nil,			nil,			nil,			{15487,	45,	4},	},	--Silence
	{64901,	1,	nil,			nil,			{64901,	300,	6},	nil,			},	--Symbol of Hope
	{15286,	1,	nil,			nil,			nil,			{15286,	120,	15},	},	--Vampiric Embrace
	
	{121536,3,	nil,			{121536,20,	0},	{121536,20,	0},	nil,			},	--Angelic Feather
	{110744,3,	nil,			{110744,15,	0},	{110744,15,	0},	nil,			},	--Divine Star
	{246287,3,	nil,			{246287,90,	0},	nil,			nil,			},	--Evangelism
	{120517,3,	nil,			{120517,40,	0},	{120517,40,	0},	nil,			},	--Halo
	{271466,1,	nil,			{271466,180,	0},	nil,			nil,			},	--Luminous Barrier
	{123040,3,	nil,			{123040,60,	12},	nil,			nil,			},	--Mindbender
	{129250,3,	nil,			{129250,12,	0},	nil,			nil,			},	--Power Word: Solace
	{214621,3,	nil,			{214621,24,	9},	nil,			nil,			},	--Schism
	{204065,3,	nil,			{204065,12,	0},	nil,			nil,			},	--Shadow Covenant
	{204263,3,	nil,			{204263,45,	0},	{204263,45,	0},	nil,			},	--Shining Force
	
	{200183,3,	nil,			nil,			{200183,120,	0},	nil,			},	--Apotheosis
	{204883,3,	nil,			nil,			{204883,15,	0},	nil,			},	--Circle of Healing
	{265202,1,	nil,			nil,			{265202,720,	0},	nil,			},	--Holy Word: Salvation
	
	{280711,3,	nil,			nil,			nil,			{280711,60,	0},	},	--Dark Ascension
	{263346,3,	nil,			nil,			nil,			{263346,30,	0},	},	--Dark Void
	{205369,3,	nil,			nil,			nil,			{205369,30,	0},	},	--Mind Bomb
	{200174,3,	nil,			nil,			nil,			{200174,60,	0},	},	--Mindbender
	{64044,	3,	nil,			nil,			nil,			{64044,	45,	4},	},	--Psychic Horror
	{205385,3,	nil,			nil,			nil,			{205385,20,	0},	},	--Shadow Crash
	{193223,3,	nil,			nil,			nil,			{193223,240,	0},	},	--Surrender to Madness
	{263165,3,	nil,			nil,			nil,			{263165,45,	4},	},	--Void Torrent
},
["DEATHKNIGHT"] = {
	{48707,	4,	{48707,	60,	5},	nil,			nil,			nil,			},	--Anti-Magic Shell
	{275699,3,	nil,			nil,			nil,			{275699,90,	15},	},	--Apocalypse
	{42650,	3,	nil,			nil,			nil,			{42650,	480,	30},	},	--Army of the Dead
	{221562,3,	nil,			{221562,45,	5},	nil,			nil,			},	--Asphyxiate
	{49028,	4,	nil,			{49028,	120,	8},	nil,			nil,			},	--Dancing Rune Weapon
	{56222,	5,	{56222,	8,	0},	nil,			nil,			nil,			},	--Dark Command
	{63560,	3,	nil,			nil,			nil,			{63560,	60,	15},	},	--Dark Transformation
	{50977,	3,	{50977,	60,	0},	nil,			nil,			nil,			},	--Death Gate
	{49576,	5,	nil,			{49576,	15,	0},	{49576,	25,	0},	{49576,	25,	0},	},	--Death Grip
	{43265,	3,	nil,			{43265,	15,	0},	nil,			{43265,	30,	0},	},	--Death and Decay
	{48265,	4,	{48265,	45,	0},	nil,			nil,			nil,			},	--Death's Advance
	{47568,	3,	nil,			nil,			{47568,	120,	20},	nil,			},	--Empower Rune Weapon
	{108199,1,	nil,			{108199,120,	0},	nil,			nil,			},	--Gorefiend's Grasp
	{48792,	4,	{48792,	180,	8},	nil,			nil,			nil,			},	--Icebound Fortitude
	{47528,	5,	{47528,	15,	0},	nil,			nil,			nil,			},	--Mind Freeze
	{51271,	3,	nil,			nil,			{51271,	45,	15},	nil,			},	--Pillar of Frost
	{61999,	3,	{61999,	600,	0},	nil,			nil,			nil,			},	--Raise Ally
	{46584,	3,	nil,			nil,			nil,			{46584,	30,	0},	},	--Raise Dead
	{196770,3,	nil,			nil,			{196770,20,	8},	nil,			},	--Remorseless Winter
	{55233,	3,	nil,			{55233,	90,	10},	nil,			nil,			},	--Vampiric Blood
	
	{206931,3,	nil,			{206931,30,	0},	nil,			nil,			},	--Blooddrinker
	{194844,3,	nil,			{194844,60,	0},	nil,			nil,			},	--Bonestorm
	{274156,3,	nil,			{274156,45,	0},	nil,			nil,			},	--Consumption
	{206940,3,	nil,			{206940,6,	0},	nil,			nil,			},	--Mark of Blood
	{194679,4,	nil,			{194679,25,	4},	nil,			nil,			},	--Rune Tap
	{219809,3,	nil,			{219809,60,	0},	nil,			nil,			},	--Tombstone
	{212552,3,	{212552,60,	4},	nil,			nil,			nil,			},	--Wraith Walk
	
	{108194,3,	nil,			nil,			{108194,45,	0},	{108194,45,	0},	},	--Asphyxiate
	{207167,3,	nil,			nil,			{207167,60,	0},	nil,			},	--Blinding Sleet
	{152279,3,	nil,			nil,			{152279,120,	0},	nil,			},	--Breath of Sindragosa
	{48743,	3,	nil,			nil,			{48743,	120,	15},	{48743,	120,	15},	},	--Death Pact
	{279302,3,	nil,			nil,			{279302,180,	10},	nil,			},	--Frostwyrm's Fury
	{194913,3,	nil,			nil,			{194913,6,	0},	nil,			},	--Glacial Advance
	{57330,	3,	nil,			nil,			{57330,	45,	0},	nil,			},	--Horn of Winter
	
	{152280,3,	nil,			nil,			nil,			{152280,20,	0},	},	--Defile
	{130736,3,	nil,			nil,			nil,			{130736,45,	0},	},	--Soul Reaper
	{49206,	3,	nil,			nil,			nil,			{49206,	180,	30},	},	--Summon Gargoyle
	{115989,3,	nil,			nil,			nil,			{115989,45,	0},	},	--Unholy Blight
	{207289,3,	nil,			nil,			nil,			{207289,75,	12},	},	--Unholy Frenzy
},
["SHAMAN"] = {
	{556,	3,	{556,	600,	0},	nil,			nil,			nil,			},	--Astral Recall
	{108271,4,	{108271,90,	8},	nil,			nil,			nil,			},	--Astral Shift
	{2825,	3,	{2825,	300,	0},	nil,			nil,			nil,			},	--Bloodlust
	{32182,	3,	{32182,	300,	0},	nil,			nil,			nil,			},	--Героизм
	{192058,1,	{192058,60,	2},	nil,			nil,			nil,			},	--Capacitor Totem
	{51886,	5,	nil,			{51886,	8,	0},	{51886,	8,	0},	nil,			},	--Cleanse Spirit
	{187874,3,	nil,			nil,			{187874,6,	0},	nil,			},	--Crash Lightning
	{198103,2,	{198103,300,	60},	nil,			nil,			nil,			},	--Earth Elemental
	{2484,	3,	{2484,	30,	20},	nil,			nil,			nil,			},	--Earthbind Totem
	{51533,	3,	nil,			nil,			{51533,	120,	15},	nil,			},	--Feral Spirit
	{198067,3,	nil,			{198067,150,	30},	nil,			nil,			},	--Fire Elemental
	{188389,3,	nil,			{188389,6,	0},	nil,			{188838,6,	0},	},	--Flame Shock
	{193796,3,	nil,			nil,			{193796,12,	0},	nil,			},	--Flametongue
	{73920,	3,	nil,			nil,			nil,			{73920,	10,	0},	},	--Healing Rain
	{108280,3,	nil,			nil,			nil,			{108280,180,	10},	},	--Healing Tide Totem
	{51514,	3,	{51514,	30,	0},	nil,			nil,			nil,			},	--Hex
	{20608,	2,	{21169,	1800,	0},	nil,			nil,			nil,			},	--Reincarnation
	{58875,	3,	nil,			nil,			{58875,	60,	0},	nil,			},	--Spirit Walk
	{79206,	3,	nil,			nil,			nil,			{79206,	120,	15},	},	--Spiritwalker's Grace
	{17364,	3,	nil,			nil,			{17364,	9,	0},	nil,			},	--Stormstrike
	{51490,	3,	nil,			{51490,	45,	0},	nil,			nil,			},	--Thunderstorm
	{8143,	1,	{8143,	60,	10},	nil,			nil,			nil,			},	--Tremor Totem
	{57994,	5,	{57994,	12,	0},	nil,			nil,			nil,			},	--Wind Shear
	{77130,	5,	nil,			nil,			nil,			{77130,	8,	0},	},	--Purify Spirit
	
	{108281,1,	nil,			{108281,120,	10},	nil,			nil,			},	--Ancestral Guidance
	{114050,3,	nil,			{114050,180,	15},	nil,			nil,			},	--Ascendance
	{117014,3,	nil,			{117014,12,	10},	nil,			nil,			},	--Elemental Blast
	{210714,3,	nil,			{210714,30,	0},	nil,			nil,			},	--Icefury
	{192222,3,	nil,			{192222,60,	0},	nil,			nil,			},	--Liquid Magma Totem
	{16166,	3,	nil,			{16166,	120,	15},	nil,			nil,			},	--Master of the Elements
	{192249,3,	nil,			{192249,150,	30},	nil,			nil,			},	--Storm Elemental
	{191634,3,	nil,			{191634,60,	0},	nil,			nil,			},	--Stormkeeper
	{192077,1,	{192077,120,	15},	nil,			nil,			nil,			},	--Wind Rush Totem
	
	{114051,3,	nil,			nil,			{114051,180,	15},	nil,			},	--Ascendance
	{188089,3,	nil,			nil,			{188089,20,	0},	nil,			},	--Earthen Spike
	{196884,3,	nil,			nil,			{196884,30,	0},	nil,			},	--Feral Lunge
	{197214,3,	nil,			nil,			{197214,40,	0},	nil,			},	--Sundering
	
	{207399,1,	nil,			nil,			nil,			{207399,300,	30},	},	--Ancestral Protection Totem
	{114052,3,	nil,			nil,			nil,			{114052,180,	15},	},	--Ascendance
	{207778,3,	nil,			nil,			nil,			{207778,5,	0},	},	--Downpour
	{198838,3,	nil,			nil,			nil,			{198838,60,	15},	},	--Earthen Wall Totem
	{51485,	3,	nil,			nil,			nil,			{51485,	30,	20},	},	--Earthgrab Totem
	{197995,3,	nil,			nil,			nil,			{197995,20,	0},	},	--Wellspring
	{73685,	3,	nil,			nil,			nil,			{73685,	15,	0},	},	--Unleash Life
	{157153,3,	nil,			nil,			nil,			{157153,30,	15},	},	--CBT
	{5394,	3,	nil,			nil,			nil,			{5394,	30,	15},	},	--HST
	{61295,	3,	nil,			nil,			nil,			{61295,	6,	0},	},	--Riptide
},
["MAGE"] = {
	{12042,	3,	nil,			{12042,	90,	10},	nil,			nil,			},	--Arcane Power
	{1953,	4,	{1953,	15,	0},	nil,			nil,			nil,			},	--Blink
	{235313,3,	nil,			nil,			{235313,25,	0},	nil,			},	--Blazing Barrier
	{190356,3,	nil,			nil,			nil,			{190356,8,	0},	},	--Blizzard
	{235219,3,	nil,			nil,			nil,			{235219,300,	0},	},	--Cold Snap
	{190319,3,	nil,			nil,			{190319,120,	10},	nil,			},	--Combustion
	{120,	3,	nil,			nil,			nil,			{120,	12,	0},	},	--Cone of Cold
	{190336,3,	{190336,15,	0},	nil,			nil,			nil,			},	--Conjure Refreshment
	{2139,	5,	{2139,	24,	0},	nil,			nil,			nil,			},	--Counterspell
	{195676,3,	nil,			{195676,30,	0},	nil,			nil,			},	--Displacement
	{31661,	3,	nil,			nil,			{31661,	20,	0},	nil,			},	--Dragon's Breath
	{12051,	3,	nil,			{12051,	90,	6},	nil,			nil,			},	--Evocation
	{84714,	3,	nil,			nil,			nil,			{84714,	60,	0},	},	--Frozen Orb
	{122,	3,	{122,	30,	0},	nil,			nil,			nil,			},	--Frost nova
	{110960,4,	nil,			{110960,120,	0},	nil,			nil,			},	--Greather invis
	{66,	4,	nil,			nil,			{66,	300,	0},	{66,	300,	0},	},	--Invis
	{11426,	3,	nil,			nil,			nil,			{11426,	25,	0},	},	--Ice Barrier
	{45438,	3,	{45438,	240,	10},	nil,			nil,			nil,			},	--Ice Block
	{12472,	3,	nil,			nil,			nil,			{12472,	180,	20},	},	--Icy Veins
	{66,	3,	{66,	300,	0},	nil,			nil,			nil,			},	--Invisibility
	{205025,3,	nil,			{205025,60,	0},	nil,			nil,			},	--Presence of Mind
	{235450,4,	nil,			{235450,25,	0},	nil,			nil,			},	--Prismatic Barrier
	{475,	5,	{475,	8,	0},	nil,			nil,			nil,			},	--Remove Curse
	{31687,	3,	nil,			nil,			nil,			{31687,	30,	0},	},	--Summon Water Elemental
	{80353,	3,	{80353,	300,	0},	nil,			nil,			nil,			},	--Time Warp
	
	{205022,3,	nil,			{205022,10,	0},	nil,			nil,			},	--Arcane Familiar
	{153626,3,	nil,			{153626,20,	0},	nil,			nil,			},	--Arcane Orb
	{205032,3,	nil,			{205032,40,	0},	nil,			nil,			},	--Charged Up
	{55342,	3,	{55342,	120,	40},	nil,			nil,			nil,			},	--Mirror Image
	{113724,3,	{113724,45,	0},	nil,			nil,			nil,			},	--Ring of Frost
	{116011,3,	{116011,40,	10},	nil,			nil,			nil,			},	--Rune of Power
	{157980,3,	nil,			{157980,25,	0},	nil,			nil,			},	--Supernova
	{212653,4,	{212653,20,	0},	nil,			nil,			nil,			},	--Shimmer
	
	{235870,3,	nil,			nil,			{235870,45,	0},	nil,			},	--Alexstrasza's Fury
	{157981,3,	nil,			nil,			{157981,25,	0},	nil,			},	--Blast Wave
	{44457,	3,	nil,			nil,			{44457,	12,	0},	nil,			},	--Living Bomb
	{153561,3,	nil,			nil,			{153561,45,	0},	nil,			},	--Meteor
	{257541,3,	nil,			nil,			{257541,30,	0},	nil,			},	--Phoenix flames
	
	{153595,3,	nil,			nil,			nil,			{153595,30,	0},	},	--Comet Storm
	{257537,3,	nil,			nil,			nil,			{257537,45,	0},	},	--Ebonbolt
	{205030,3,	nil,			nil,			nil,			{205030,30,	0},	},	--Frozen Touch
	{157997,3,	nil,			nil,			nil,			{157997,25,	0},	},	--Ice Nova
	{205021,3,	nil,			nil,			nil,			{205021,75,	0},	},	--Ray of Frost
},
["WARLOCK"] = {
	{104316,3,	nil,			nil,			{104316,20,	0},	nil,			},	--Call Dreadstalkers
	{29893,	3,	{29893,	120,	0},	nil,			nil,			nil,			},	--Create Soulwell
	{111771,3,	{111771,10,	0},	nil,			nil,			nil,			},	--Demonic Gateway
	{80240,	3,	nil,			nil,			nil,			{80240,	25,	0},	},	--Havoc
	{698,	3,	{698,	120,	0},	nil,			nil,			nil,			},	--Ritual of Summoning
	{30283,	1,	{30283,	60,	0},	nil,			nil,			nil,			},	--Shadowfury
	{20707,	3,	{20707,	600,	0},	nil,			nil,			nil,			},	--Soulstone
	{205180,3,	nil,			{205180,180,	20},	nil,			nil,			},	--Summon Darkglare
	{265187,3,	nil,			nil,			{265187,90,	0},	nil,			},	--Summon Demonic Tyrant
	{1122,	3,	nil,			nil,			nil,			{1122,	180,	0},	},	--Summon Infernal
	{104773,4,	{104773,180,	8},	nil,			nil,			nil,			},	--Unending Resolve
	
	{108416,3,	{108416,60,	0},	nil,			nil,			nil,			},	--Dark Pact
	{113860,3,	nil,			{113860,120,	0},	nil,			nil,			},	--Dark Soul: Misery
	{264106,3,	nil,			{264106,30,	0},	nil,			nil,			},	--Deathbolt
	{268358,3,	{268358,10,	0},	nil,			nil,			nil,			},	--Demonic Circle
	{108503,3,	nil,			{108503,30,	0},	nil,			{108503,30,	0},	},	--Grimoire of Sacrifice
	{48181,	3,	nil,			{48181,	15,	0},	nil,			nil,			},	--Haunt
	{6789,	3,	{6789,	45,	0},	nil,			nil,			nil,			},	--Mortal Coil
	{205179,3,	nil,			{205179,45,	0},	nil,			nil,			},	--Phantom Singularity
	{278350,3,	nil,			{278350,20,	0},	nil,			nil,			},	--Vile Taint
	
	{267211,3,	nil,			nil,			{267211,30,	0},	nil,			},	--Bilescourge Bombers
	{267171,3,	nil,			nil,			{267171,60,	0},	nil,			},	--Demonic Strength
	{111898,3,	nil,			nil,			{111898,90,	0},	nil,			},	--Grimoire: Felguard
	{267217,3,	nil,			nil,			{267217,180,	0},	nil,			},	--Nether Portal
	{264130,3,	nil,			nil,			{264130,30,	0},	nil,			},	--Power Siphon
	{264057,3,	nil,			nil,			{264057,10,	0},	nil,			},	--Soul Strike
	{264119,3,	nil,			nil,			{264119,45,	0},	nil,			},	--Summon Vilefiend
	
	{152108,3,	nil,			nil,			nil,			{152108,30,	0},	},	--Cataclysm
	{196447,3,	nil,			nil,			nil,			{196447,25,	0},	},	--Channel Demonfire
	{113858,3,	nil,			nil,			nil,			{113858,120,	0},	},	--Dark Soul: Instability
	{6353,	3,	nil,			nil,			nil,			{6353,	20,	0},	},	--Soul Fire
},
["MONK"] = {
	{100784,3,	{100784,3,	0},	nil,			nil,			nil,			},	--Blackout Kick
	{115181,3,	nil,			{115181,15,	0},	nil,			nil,			},	--Breath of Fire
	{218164,5,	nil,			{218164,8,	0},	{218164,8,	0},	nil,			},	--Detox
	{115450,5,	nil,			nil,			nil,			{115450,8,	0},	},	--Detox
	{191837,3,	nil,			nil,			nil,			{191837,12,	0},	},	--Essence Font
	{113656,3,	nil,			nil,			{113656,24,	0},nil,				},	--Fists of Fury
	{101545,3,	nil,			nil,			{101545,25,	0},nil,				},	--Flying Serpent Kick
	{115203,4,	nil,			{115203,420,	15},	nil,			nil,			},	--Fortifying Brew
	{243435,4,	nil,			nil,			nil,			{243435,90,	15},	},	--Fortifying Brew
	{119381,1,	{119381,60,	3},	nil,			nil,			nil,			},	--Leg Sweep
	{116849,2,	nil,			nil,			nil,			{116849,120,	12},	},	--Life Cocoon
	{115078,3,	{115078,45,	0},	nil,			nil,			nil,			},	--Paralysis
	{115546,5,	{115546,8,	0},	nil,			nil,			nil,			},	--Provoke
	{115310,1,	nil,			nil,			nil,			{115310,180,	0},	},	--Revival
	{107428,3,	nil,			nil,			{107428,10,	0},	{107428,10,	0},	},	--Rising Sun Kick
	{109132,3,	{107428,20,	0},	nil,			nil,			nil,			},	--Roll	
	{116705,3,	nil,			{116705,15,	0},	{116705,15,	0},	nil,			},	--Spear Hand Strike
	{137639,3,	nil,			nil,			{137639,90,	15},	nil,			},	--Storm, Earth, and Fire
	{116680,3,	nil,			nil,			nil,			{116680,30,	0},	},	--Thunder Focus Tea
	{115080,3,	nil,			nil,			{115080,120,	8},	nil,				},	--Touch of Death
	{122470,3,	nil,			nil,			{122470,90,	10},	nil,			},	--Touch of Karma
	{101643,4,	{101643,10,	0},	nil,			nil,			nil,			},	--Transcendence
	{119996,4,	{119996,45,	0},	nil,			nil,			nil,			},	--Transcendence: Transfer
	{115176,4,	nil,			{115176,300,	8},	nil,			nil,			},	--Zen Meditation
	{126892,3,	{126892,60,	0},	nil,			nil,			nil,			},	--Zen Pilgrimage
	
	{115399,3,	nil,			{115399,120,	0},	nil,			nil,			},	--Black Ox Brew
	{123986,3,	{123986,30,	0},	nil,			nil,			nil,			},	--Chi Burst
	{115008,4,	{115008,20,	0},	nil,			nil,			nil,			},	--Chi Torpedo
	{115098,3,	{115098,15,	0},	nil,			nil,			nil,			},	--Chi Wave
	{122278,3,	{122278,120,	10},	nil,			nil,			nil,			},	--Dampen Harm
	{115295,3,	nil,			{115295,30,	0},	nil,			nil,			},	--Guard
	{132578,3,	nil,			{132578,180,	0},	nil,			nil,			},	--Invoke Niuzao, the Black Ox
	{116844,1,	{116844,45,	5},	nil,			nil,			nil,			},	--Ring of Peace
	{116847,3,	nil,			{116847,6,	0},	nil,			nil,			},	--Rushing Jade Wind
	{115315,3,	nil,			{115315,10,	0},	nil,			nil,			},	--Summon Black Ox Statue
	{116841,2,	{116841,30,	6},	nil,			nil,			nil,			},	--Tiger's Lust
	
	{122783,4,	nil,			nil,			{122783,90,	6},	{122783,90,	6},	},	--Diffuse Magic
	{198664,3,	nil,			nil,			nil,			{198664,180,	25},	},	--Invoke Chi-Ji, the Red Crane
	{197908,3,	nil,			nil,			nil,			{197908,90,	12},	},	--Mana Tea
	{196725,3,	nil,			nil,			nil,			{196725,9,	0},	},	--Refreshing Jade Wind
	{198898,3,	nil,			nil,			nil,			{198898,30,	0},	},	--Song of Chi-Ji
	{115313,3,	nil,			nil,			nil,			{115313,10,	0},	},	--Summon Jade Serpent Statue
	
	{115288,3,	nil,			nil,			{115288,60,	0},	nil,			},	--Energizing Elixir
	{261947,3,	nil,			nil,			{261947,30,	0},	nil,			},	--Fist of the White Tiger
	{123904,3,	nil,			nil,			{123904,120,	20},	nil,			},	--Invoke Xuen, the White Tiger
	{261715,3,	nil,			nil,			{261715,6,	0},	nil,			},	--Rushing Jade Wind
	{152173,3,	nil,			nil,			{152173,90,	12},	nil,			},	--Serenity
	{152175,3,	nil,			nil,			{152175,24,	0},	nil,			},	--Whirling Dragon Punch

},
["DRUID"] = {
	{22812,	4,	nil,			{22812,	60,	12},	nil,			{22812,	60,	12},	{22812,	60,	12},	},	--Barkskin
	{106951,3,	nil,			nil,			{106951,180,	15},	nil,			nil,			},	--Berserk
	{194223,3,	nil,			{194223,180,	20},	nil,			nil,			nil,			},	--Celestial Alignment
	{1850,	4,	{1850,	120,	10},	nil,			nil,			nil,			nil,			},	--Dash
	{22842,	4,	nil,			nil,			nil,			{22842,	36,	3},	nil,			},	--Frenzied Regeneration
	{6795,	5,	{6795,	8,	0},	nil,			nil,			nil,			nil,			},	--Growl
	{99,	3,	nil,			nil,			nil,			{99,	30,	0},	nil,			},	--Incapacitating Roar
	{29166,	2,	nil,			{29166,	180,	12},	nil,			nil,			{29166,	180,	12},	},	--Innervate
	{102342,2,	nil,			nil,			nil,			nil,			{102342,60,	12},	},	--Ironbark
	{22570,	3,	nil,			nil,			{22570,	20,	0},	nil,			nil,			},	--Maim
	{33917,	3,	{33917,	6,	0},	nil,			nil,			nil,			nil,			},	--Mangle
	{5215,	3,	{5215,	6,	0},	nil,			nil,			nil,			nil,			},	--Prowl
	{20484,	1,	{20484,	600,	0},	nil,			nil,			nil,			nil,			},	--Rebirth
	{2782,	5,	nil,			{2782,	8,	0},	{2782,	8,	0},	{2782,	8,	0},	nil,			},	--Remove Corruption
	{106839,5,	nil,			nil,			{106839,15,	0},	{106839,15,	0},	nil,			},	--Skull Bash
	{78675,	5,	nil,			{78675,	60,	8},	nil,			nil,			nil,			},	--Solar Beam
	{2908,	5,	nil,			{2908,	10,	0},	{2908,	10,	0},	nil,			{2908,	10,	0},	},	--Soothe
	{106898,1,	nil,			nil,			{106898,120,	8},	{106898,120,	8},	nil,			},	--Stampeding Roar
	{61336,	3,	nil,			nil,			{61336,	120,	6},	{61336,	240,	6},	nil,			},	--Survival Instincts
	{18562,	3,	nil,			nil,			nil,			nil,			{18562,	25,	0},	},	--Swiftmend
	{5217,	3,	nil,			nil,			{5217,	30,	10},	nil,			nil,			},	--Tiger's Fury
	{740,	1,	nil,			nil,			nil,			nil,			{740,	180,	8},	},	--Tranquility
	{102793,3,	nil,			nil,			nil,			{102793,60,	10},	{102793,60,	10},	},	--Ursol's Vortex
	{48438,	3,	nil,			nil,			nil,			nil,			{48438,	10,	0},	},	--Wild Growth
	
	{205636,3,	nil,			{205636,60,	0},	nil,			nil,			nil,			},	--Force of Nature
	{202770,3,	nil,			{202770,60,	0},	nil,			nil,			nil,			},	--Fury of Elune
	{102560,3,	nil,			{102560,180,	30},	nil,			nil,			nil,			},	--Incarnation: Chosen of Elune
	{102359,3,	{102359,30,	0},	nil,			nil,			nil,			nil,			},	--Mass Entanglement
	{5211,	3,	{5211,	50,	0},	nil,			nil,			nil,			nil,			},	--Mighty Bash
	{108238,3,	nil,			{108238,90,	0},	{108238,90,	0},	nil,			{108238,90,	0},	},	--Renewal
	{252216,3,	{252216,45,	5},	nil,			nil,			nil,			nil,			},	--Tiger Dash
	{132469,3,	{61391,	30,	0},	nil,			nil,			nil,			nil,			},	--Typhoon
	{202425,3,	nil,			{202425,45,	0},	nil,			nil,			nil,			},	--Warrior of Elune
	{102401,3,	{102401,15,	0},	nil,			nil,			nil,			nil,			},	--Wild Charge
	
	{274837,3,	nil,			nil,			{274837,45,	0},	nil,			nil,			},	--Feral Frenzy
	{102543,3,	nil,			nil,			{102543,180,	30},	nil,			nil,			},	--Incarnation: King of the Jungle
	
	{155835,3,	nil,			nil,			nil,			{155835,40,	0},	nil,			},	--Bristling Fur
	{102558,3,	nil,			nil,			nil,			{102558,180,	30},	nil,			},	--Incarnation: Guardian of Ursoc
	{204066,3,	nil,			nil,			nil,			{204066,75,	0},	nil,			},	--Lunar Beam
	
	{102351,3,	nil,			nil,			nil,			nil,			{102351,30,	0},	},	--Cenarion Ward
	{197721,3,	nil,			nil,			nil,			nil,			{197721,90,	8},	},	--Flourish
	{33891,	3,	nil,			nil,			nil,			nil,			{33891,	180,	30},	},	--Incarnation: Tree of Life
},
["DEMONHUNTER"] = {
	{188499,3,	nil,			{188499,9,	0},	nil,			},	--Blade Dance
	{198589,4,	nil,			{198589,60,	10},	nil,			},	--Blur
	{179057,1,	nil,			{179057,60,	2},	nil,			},	--Chaos Nova
	{278326,5,	{278326,10,	0},	nil,			nil,			},	--Consume Magic
	{196718,1,	nil,			{196718,180,	8},	nil,			},	--Darkness
	{203720,4,	nil,			nil,			{203720,20,	6},	},	--Demon Spikes
	{183752,5,	{183752,15,	0},	nil,			nil,			},	--Disrupt
	{198013,3,	nil,			{198013,30,	0},	nil,			},	--Eye Beam
	{195072,4,	nil,			{195072,10,	0},	nil,			},	--Fel rush
	{204021,4,	nil,			nil,			{204021,60,	8},	},	--Fiery Brand
	{178740,3,	nil,			nil,			{178740,15,	0},	},	--Immolation Aura
	{217832,3,	{217832,45,	0},	nil,			nil,			},	--Imprison
	{195072,4,	nil,			nil,			{195072,20,	0},	},	--Infernal Strike
	{191427,3,	nil,			{191427,240,	30},	nil,			},	--Metamorphosis
	{187827,4,	nil,			nil,			{187827,180,	0},	},	--Metamorphosis
	{204596,3,	nil,			nil,			{204596,30,	2},	},	--Sigil of Flame
	{207684,1,	nil,			nil,			{207684,60,	2},	},	--Sigil of Misery
	{202137,1,	nil,			nil,			{202137,60,	2},	},	--Sigil of Silence
	{188501,3,	{188501,30,	10},	nil,			nil,			},	--Spectral Sight
	{281854,5,	nil,			{281854,8,	0},	nil,			},	--Torment
	{185245,5,	nil,			nil,			{185245,8,	0},	},	--Torment
	{198793,3,	nil,			{198793,25,	0},	nil,			},	--Vengeful Retreat
	
	{258860,3,	nil,			{258860,20,	0},	nil,			},	--Dark Slash
	{258925,3,	nil,			{258925,60,	0},	nil,			},	--Fel Barrage
	{211881,3,	nil,			{211881,30,	0},	nil,			},	--Fel Eruption
	{232893,3,	{232893,15,	0},	nil,			nil,			},	--Felblade
	{258920,3,	nil,			{258920,30,	0},	nil,			},	--Immolation Aura
	{206491,3,	nil,			{206491,120,	0},	nil,			},	--Nemesis
	{196555,3,	nil,			{196555,120,	5},	nil,			},	--Netherwalk
	
	{212084,3,	nil,			nil,			{212084,60,	0},	},	--Fel Devastation
	{202138,3,	nil,			nil,			{202138,90,	2},	},	--Sigil of Chains
	{263648,3,	nil,			nil,			{263648,30,	0},	},	--Soul Barrier
},

["PET"] = {
	{90355,	3,	"HUNTER"},
	{159931,3,	"HUNTER"},
	{26064,	3,	"HUNTER"},
	{159956,3,	"HUNTER"},
	{55709,	3,	"HUNTER"},
	{53480,	2,	"HUNTER"},
	{53478,	3,	"HUNTER"},
	{61685,	3,	"HUNTER"},
	{126393,3,	"HUNTER"},
	{137798,3,	"HUNTER"},
	{90361,	3,	"HUNTER"},
	{91802,	5,	"DEATHKNIGHT"},
	{91797,	3,	"DEATHKNIGHT"},
	{89751,	3,	"WARLOCK"},
	{89766,	5,	"WARLOCK"},
	{115276,5,	"WARLOCK"},
	{17767,	3,	"WARLOCK"},
	{89808,	5,	"WARLOCK"},
	{119899,4,	"WARLOCK"},
	{89792,	3,	"WARLOCK"},
	{115781,5,	"WARLOCK"},
	{115831,3,	"WARLOCK"},
	{115268,3,	"WARLOCK"},
	{6358,	3,	"WARLOCK"},
	{19647,	5,	"WARLOCK"},
	{19505,	3,	"WARLOCK"},
	{135029,3,	"MAGE"},
	{33395,	3,	"MAGE"},
},
["RACIAL"] = {
	{68992,	3,	{68992,	120,	10},	},	--Worgen
	{20589,	3,	{20589,	60,	0},	},	--Gnome
	{20594,	3,	{20594,	120,	8},	},	--Dwarf
	{121093,3,	{121093,180,	5},	},	--Draenei
	{58984,	3,	{58984,	120,	0},	},	--NightElf
	{59752,	3,	{59752,	180,	0},	},	--Human
	{69041,	3,	{69041,	90,	0},	},	--Goblin
	{69070,	3,	{69070,	90,	0},	},	--Goblin
	{7744,	3,	{7744,	120,	0},	},	--Undead
	{20577,	3,	{20577,	120,	10},	},	--Undead
	{20572,	3,	{20572,	120,	15},	},	--Orc
	{20549,	3,	{20549,	90,	0},	},	--Tauren
	{26297,	3,	{26297,	180,	10},	},	--Troll
	{28730,	3,	{28730,	120,	0},	},	--BloodElf
	{107079,3,	{107079,120,	4},	},	--Pandaren
	{256948,3,	{256948,180,	0},	},	--VoidElf
	{260364,3,	{260364,180,	12},	},	--Nightborne
	{255647,3,	{255647,150,	0},	},	--LightforgedDraenei
	{255654,3,	{255654,120,	0},	},	--HighmountainTauren
	{274738,3,	{274738,120,	15},	},	--MagharOrc
	{265221,3,	{265221,120,	8},	},	--DarkIronDwarf
},
["ITEMS"] = {
	{67826,	3,	{67826,	3600,	0},	},	--Jeevs
	--{177592,3,	{177592,120,	0},	},	--Candle
	--{176873,3,	{176873,120,	20},	},	--Tank BRF
	--{176875,3,	{176875,120,	20},	},	--Shard of nothing
	--{177597,3,	{177597,120,	20},	},	--Coin
	--{177594,3,	{177594,120,	20},	},	--Couplend
	--{177189,3,	{177189,90,	15},	},	--Kyanos
	--{176460,3,	{176460,120,	20},	},	--Kyb
	--{183929,3,	{183929,90,	15},	},	--Intuition's Gift
	--{184270,3,	{184270,60,	20},	},	--Mirror of the Blademaster
	{201414,3,	{201414,60,	0},	},	--Purified Shard of the Third Moon
	{201371,3,	{201371,60,	0},	},	--Judgment of the Naaru
	{90633,	3,	{90633,	600,	0},	},	--Guild Battle Standard
	{90632,	3,	{90632,	600,	0},	},	--Guild Battle Standard
	{90631,	3,	{90631,	600,	0},	},	--Guild Battle Standard
	{215956,3,	{215956,120,	30},	},	--Horn of Valor
	{215648,3,	{215648,90,	20},	},	--Moonlit Prism
	{214962,3,	{214962,120,	30},	},	--Faulty Countermeasure
	{215936,3,	{215936,120,	20},	},	--Orb of Torment
	{215658,3,	{215658,75,	15},	},	--Tirathon's Betrayal
	{214980,3,	{214980,120,	6},	},	--Windscar Whetstone
	{215206,3,	{215206,20,	0},	},	--Jewel of Insatiable Desire
	{214584,3,	{214584,60,	10},	},	--Shivermaw's Jawbone
	{215467,3,	{215467,60,	15},	},	--Obelisk of the Void
	{214971,3,	{214971,60,	8},	},	--Giant Ornamental Pearl
	{214423,3,	{214423,60,	15},	},	--Talisman of the Cragshaper
	{214366,3,	{214366,120,	30},	},	--Shard of Rokmora
	{215670,3,	{215670,120,	15},	},	--Figurehead of the Naglfar
	{214203,3,	{214203,60,	0},	},	--Gift of Radiance
	{214198,3,	{214198,90,	0},	},	--Mote of Sanctification
	{221837,3,	{221837,120,	10},	},	--Cocoon of Enforced Solitude
	{221992,3,	{221992,60,	0},	},	--Horn of Cenarius
	{221695,3,	{221695,120,	25},	},	--Unbridled Fury
	{222046,3,	{222046,120,	0},	},	--Wriggling Sinew
	{221803,3,	{221803,60,	10},	},	--Ravaged Seed Pod
	{235169,3,	{235169,75,	10},	},	--Archimonde's Hatred Reborn
	{235966,3,	{235966,75,	10},	},	--Velen's Future Sight
	{235991,3,	{235991,75,	0},	},	--Kil'jaeden's Burning Wish
	{251946,3,	{251946,120,	3},	},	--ABT Bulwark of Flame
	{295271,3,	{295271,120,	0},	},	--Void Stone
},
["ESSENCES"] = {
	{295373,3,	{295373,30,	0},	},	--The Crucible of Flame
	{295186,3,	{295186,60,	0},	},	--Worldvein Resonance
	{302731,3,	{302731,60,	2},	},	--Ripple in Space
	{298357,3,	{298357,120,	0},	},	--Memory of Lucid Dreams
	{293019,3,	{293019,60,	4},	},	--Azeroth's Undying Gift
	{294926,3,	{294926,150,	0},	},	--Anima of Life and Death
	{298168,3,	{298168,120,	15},	},	--Aegis of the Deep
	{295746,3,	{295746,180,	0},	},	--Nullification Dynamo
	{293031,3,	{293031,60,	0},	},	--Sphere of Suppression
	{296197,3,	{296197,15,	0},	},	--The Well of Existence
	{296094,3,	{296094,180,	0},	},	--Artifice of Time
	{293032,3,	{293032,120,	0},	},	--Life-Binder's Invocation
	{296072,3,	{296072,30,	8},	},	--The Ever-Rising Tide
	{296230,3,	{296230,60,	0},	},	--Vitality Conduit
	{295258,3,	{295258,90,	0},	},	--Essence of the Focusing Iris
	{295840,3,	{295840,180,	0},	},	--Condensed Life-Force
	{297108,3,	{297108,120,	0},	},	--Blood of the Enemy
	{295337,3,	{295337,60,	0},	},	--Purification Protocol
	{298452,3,	{298452,60,	0},	},	--The Unbound Force
},
}
]]
if ExRT.isClassic then
module.db.AllClassSpellsInText = [[
local module = GExRT.A.ExCD2
module.db.allClassSpells = {
["WARRIOR"] = {},
["PALADIN"] = {},
["HUNTER"] = {},
["ROGUE"] = {},
["PRIEST"] = {},
["DEATHKNIGHT"] = {},
["SHAMAN"] = {},
["MAGE"] = {},
["WARLOCK"] = {},
["MONK"] = {},
["DRUID"] = {},
["DEMONHUNTER"] = {},
["PET"] = {},
}
]]
end


-------------------------------------------
-----------------         -----------------
----------------- Inspect -----------------
-----------------         -----------------
-------------------------------------------


local moduleInspect = ExRT.mod:New("Inspect",nil,true)

moduleInspect.db.inspectDB = {}
moduleInspect.db.inspectDBAch = {}
moduleInspect.db.inspectQuery = {}
moduleInspect.db.inspectItemsOnly = {}
moduleInspect.db.inspectNotItemsOnly = {}
moduleInspect.db.inspectID = nil
moduleInspect.db.inspectCleared = nil

module.db.inspectDB = moduleInspect.db.inspectDB	--Quick fix for other modules

if ExRT.isClassic then
	SetAchievementComparisonUnit = ExRT.NULLfunc
end

local inspectForce = false
function moduleInspect:Force() inspectForce = true end
function moduleInspect:Slowly() inspectForce = false end

moduleInspect.db.statsNames = {
	haste = {L.cd2InspectHaste,L.cd2InspectHasteGem},
	mastery = {L.cd2InspectMastery,L.cd2InspectMasteryGem},
	crit = {L.cd2InspectCrit,L.cd2InspectCritGem,L.cd2InspectCritGemLegendary},
	spirit = {L.cd2InspectSpirit,L.cd2InspectAll},
	
	intellect = {L.cd2InspectInt,L.cd2InspectIntGem,L.cd2InspectAll},
	agility = {L.cd2InspectAgi,L.cd2InspectAll},
	strength = {L.cd2InspectStr,L.cd2InspectStrGem,L.cd2InspectAll},
	spellpower = {L.cd2InspectSpd},
	
	versatility = {L.cd2InspectVersatility,L.cd2InspectVersatilityGem},
	leech = {L.cd2InspectLeech},
	armor = {L.cd2InspectBonusArmor},
	avoidance = {L.cd2InspectAvoidance},
	speed = {L.cd2InspectSpeed},
	
}

moduleInspect.db.itemsSlotTable = {
	1,	--INVSLOT_HEAD
	2,	--INVSLOT_NECK
	3,	--INVSLOT_SHOULDER
	15,	--INVSLOT_BACK
	5,	--INVSLOT_CHEST
	9,	--INVSLOT_WRIST
	10,	--INVSLOT_HAND
	6,	--INVSLOT_WAIST
	7,	--INVSLOT_LEGS
	8,	--INVSLOT_FEET
	11,	--INVSLOT_FINGER1
	12,	--INVSLOT_FINGER2
	13,	--INVSLOT_TRINKET1
	14,	--INVSLOT_TRINKET2
	16,	--INVSLOT_MAINHAND
	17,	--INVSLOT_OFFHAND
}

local inspectScantip = CreateFrame("GameTooltip", "ExRTInspectScanningTooltip", nil, "GameTooltipTemplate")
inspectScantip:SetOwner(UIParent, "ANCHOR_NONE")

do
	local essenceData = nil
	local dbcData = {
		[28] = {298452,298407,298452,298407, 298455,298448,299376,299375, 298456,298449,299378,299377, 298457,298450,299378,299377},
		[32] = {303823,304081,303823,304081, 304086,304055,304088,304089, 303892,304125,304121,304123, 303894,304533,304121,304123},
		[4] =  {295186,295078,295186,295078, 295209,295208,298628,298627, 295160,295165,299334,299333, 295210,295166,299334,299333},
		[25] = {298168,298193,298168,298193, 298169,298351,299273,299274, 298174,298352,299275,299277, 298186,298353,299275,299277},
		[20] = {293032,296207,293032,296207, 296220,296213,299943,299939, 296221,296214,299944,299940, 299520,299521,299944,299940},
		[19] = {296197,296136,296197,296136, 296200,296192,299932,299935, 296201,296193,299933,299936, 299529,299530,299933,299936},
		[21] = {296230,303448,296230,303448, 303472,303463,299958,303474, 296232,303460,299959,303476, 299559,299560,299959,303476},
		[3] =  {293031,294910,293031,294910, 294906,294919,300009,300012, 294907,294920,300010,300013, 294908,294922,300010,300013},
		[2] =  {293019,294668,293019,294668, 294653,294687,298080,298082, 294650,294688,298081,298083, 294655,294689,298081,298083},
		[5] =  {295258,295246,295258,295246, 295262,295251,299336,299335, 295263,295252,299338,299337, 295264,295253,299338,299337},
		[18] = {296094,296081,296094,296081, 296102,296091,299882,299885, 296103,296089,299883,299887, 299518,299519,299883,299887},
		[7] =  {294926,294964,294926,294964, 295307,294970,300002,300004, 294945,294969,300003,300005, 295306,294972,300003,300005},
		[6] =  {295337,295293,295337,295293, 295364,295363,299345,299343, 295352,295351,299347,299346, 295358,295333,299347,299346},
		[14] = {295840,295834,295840,295834, 295841,295836,299355,299354, 295843,295837,299358,299357, 295892,295839,299358,299357},
		[15] = {302731,302916,302731,302916, 302778,302957,302982,302984, 302780,302961,302983,302985, 302910,302962,302983,302985},
		[27] = {298357,298268,298357,298268, 298376,298337,299372,299371, 298377,298339,299374,299373, 298405,298404,299374,299373},
		[17] = {296072,296050,296072,296050, 296074,296067,299875,299878, 296075,296062,299876,299879, 299522,299523,299876,299879},
		[13] = {295746,295750,295746,295750, 295747,295844,300015,300018, 295748,295846,300016,300020, 295749,295845,300016,300020},
		[12] = {295373,295365,295373,295365, 295377,295372,299349,299348, 295379,295369,299353,299350, 295380,295381,299353,299350},
		[22] = {296325,296320,296325,296320, 296326,296321,299368,299367, 303342,296322,299370,299369, 296328,296324,299370,299369},
		[23] = {297108,297147,297108,297147, 297120,297177,298273,298274, 297122,297178,298277,298275, 298182,298183,298277,298275},
	}
	moduleInspect.db.essenceSpellsData = {}
	local CURRENT_MAX,CURRENT_MIN = 32,2

	function moduleInspect:GetEssenceData()
		if not essenceData then
			essenceData = {}
			for i=CURRENT_MIN,CURRENT_MAX do 
				local ess = C_AzeriteEssence.GetEssenceHyperlink(i,1)
				if ess and ess ~= "" and dbcData[i] then
					ess = ess:match("%[(.-)%]"):gsub("%-","%%-")

					local currData = {
						name = ess,
						id = i,
					}
					essenceData[#essenceData+1] = currData

					local essData = C_AzeriteEssence.GetEssenceInfo(i)

					for j=1,4 do
						for k=0,1 do
							local spellID = dbcData[i][(j-1)*4+3+k]
							local spellName,_,spellTexture = GetSpellInfo(spellID)

							moduleInspect.db.essenceSpellsData[spellID] = true

							currData[j*(k == 0 and 1 or -1)] = {
								icon = essData and essData.icon or spellTexture,
								spellID = spellID,
								previewSpellID = dbcData[i][(j-1)*4+1+k],
								name = ess,
								id = i,
								isMajor = k == 0,
								tier = j,
								link = C_AzeriteEssence.GetEssenceHyperlink(i,j),
							}
						end
					end
				end
			end
		end
		return essenceData
	end
end

local function CheckForSuccesInspect(name)
	if not moduleInspect.db.inspectDB[name] then
		moduleInspect.db.inspectQuery[name] = true
	end
end

local inspectLastTime = 0
local function InspectNext()
	if RaidInCombat() or (InspectFrame and InspectFrame:IsShown()) then
		return
	end
	local nowTime = GetTime()
	for name,timeAdded in pairs(moduleInspect.db.inspectQuery) do
		if name and (not ExRT.isClassic or CheckInteractDistance(name,1)) and CanInspect(name) then
			NotifyInspect(name)
			
			if (VExRT and VExRT.InspectViewer and VExRT.InspectViewer.EnableA4ivs) and not moduleInspect.db.inspectDBAch[name] and not ExRT.isClassic then
				if AchievementFrameComparison then
					AchievementFrameComparison:UnregisterEvent("INSPECT_ACHIEVEMENT_READY")
					ExRT.F.Timer(AchievementFrameComparison.RegisterEvent, inspectForce and 1 or 2.5, AchievementFrameComparison, "INSPECT_ACHIEVEMENT_READY")
				end
				ClearAchievementComparisonUnit()
				SetAchievementComparisonUnit(name)
			end
			
			moduleInspect.db.inspectQuery[name] = nil
			ExRT.F.Timer(CheckForSuccesInspect,10,name)	--Try later if failed
			return
		elseif not UnitName(name) then
			moduleInspect.db.inspectQuery[name] = nil
		end
	end
end

local function InspectQueue()
	if ExRT.isClassic then	--Temp fix for 'Unknown unit' or 'Out of Range' errors
		return
	end
	local n = GetNumGroupMembers() or 0
	local timeAdded = GetTime()
	for j=1,n do
		local name,_,subgroup,_,_,_,_,online = GetRaidRosterInfo(j)
		if name and not moduleInspect.db.inspectDB[name] and online then
			moduleInspect.db.inspectQuery[name] = timeAdded
			moduleInspect.db.inspectNotItemsOnly[name] = true
		end
	end
end

function moduleInspect:AddToQueue(name) 
	if not moduleInspect.db.inspectQuery[name] then
		moduleInspect.db.inspectQuery[name] = GetTime()
		moduleInspect.db.inspectNotItemsOnly[name] = true
	end
end


local function ExCD2_ClearTierSetsInfoFromUnit(name)
	for tierUID,tierData in pairs(module.db.tierSetsSpells) do
		if tierData[1] then
			if type(tierData[1]) ~= "table" then
				module.db.session_gGUIDs[name] = -tierData[1]
			else
				for _,sID in pairs(tierData[1]) do
					if type(sID)=='number' then
						module.db.session_gGUIDs[name] = -sID
					end
				end
			end
		end
		if tierData[2] then
			if type(tierData[2]) ~= "table" then
				module.db.session_gGUIDs[name] = -tierData[2]
			else
				for _,sID in pairs(tierData[2]) do
					if type(sID)=='number' then
						module.db.session_gGUIDs[name] = -sID
					end
				end
			end
		end
	end
	for itemID,spellID in pairs(module.db.itemsToSpells) do
		module.db.session_gGUIDs[name] = -spellID
	end
end

local InspectItems = nil
do
	local ITEM_LEVEL = (ITEM_LEVEL or "NO DATA FOR ITEM_LEVEL"):gsub("%%d","(%%d+)")
	local dataNames = {'tiersets','items','items_ilvl','azerite','essence'}
	function InspectItems(name,inspectedName,inspectSavedID)
		if moduleInspect.db.inspectCleared or moduleInspect.db.inspectID ~= inspectSavedID then
			return
		end
		moduleInspect.db.inspectDB[name] = moduleInspect.db.inspectDB[name] or {}
		local inspectData = moduleInspect.db.inspectDB[name]
		inspectData['ilvl'] = 0
		for _,dataName in pairs(dataNames) do	--Prevent overuse memory
			if inspectData[dataName] then
				for q,w in pairs(inspectData[dataName]) do inspectData[dataName][q] = nil end
			else
				inspectData[dataName] = {}
			end		
		end
		for stateName,stateData in pairs(moduleInspect.db.statsNames) do
			inspectData[stateName] = 0
		end
		for spellID,_ in pairs(module.db.spell_isAzeriteTalent) do
			module.db.session_gGUIDs[name] = -spellID
		end
		for spellID,_ in pairs(moduleInspect.db.essenceSpellsData) do
			module.db.session_gGUIDs[name] = -spellID
		end

		
		local ilvl_count = 0
		
		ExCD2_ClearTierSetsInfoFromUnit(name)	--------> ExCD2
		
		local isArtifactEqipped = 0
		local ArtifactIlvlSlot1,ArtifactIlvlSlot2 = 0,0
		local mainHandSlot, offHandSlot = 0,0
		for i=1,#moduleInspect.db.itemsSlotTable do
			local itemSlotID = moduleInspect.db.itemsSlotTable[i]
			--local itemLink = GetInventoryItemLink(inspectedName, itemSlotID)
			inspectScantip:SetInventoryItem(inspectedName, itemSlotID)
			
			local _,itemLink = inspectScantip:GetItem()
			if itemLink and (itemSlotID == 16 or itemSlotID == 17) and itemLink:find("item::") then
				itemLink = GetInventoryItemLink(inspectedName, itemSlotID)
			end
			
			if itemLink then
				inspectData['items'][itemSlotID] = itemLink
				--inspectScantip:SetInventoryItem(inspectedName, itemSlotID)
				local itemID = itemLink:match("item:(%d+):")
				
				if itemSlotID == 16 or itemSlotID == 17 then
					local _,_,quality = GetItemInfo(itemLink)
					if quality == 6 then
						isArtifactEqipped = isArtifactEqipped + 1
					end
				end
				
				local AzeritePowers = nil
				if not ExRT.isClassic then
					local isAzeriteItem = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink)
					if isAzeriteItem then
						local powers = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(itemLink,inspectData.classID)
						if powers then
							AzeritePowers = {}
							for j=1,#powers do
								for k=1,#powers[j].azeritePowerIDs do
									local powerID = powers[j].azeritePowerIDs[k]
									
									local powerData = C_AzeriteEmpoweredItem.GetPowerInfo(powerID)
									if powerData then
										local spellName,_,spellTexture = GetSpellInfo(powerData.spellID)
										
										if spellName then
											AzeritePowers[#AzeritePowers+1] = {
												name = spellName,
												icon = spellTexture,
												id = powerID,
												item = itemSlotID,
												itemLink = itemLink,
												itemID = itemID,
												spellID = powerData.spellID,
												tier = j,
											}
										end
										
										module.db.spell_isAzeriteTalent[powerData.spellID] = true
									end
								end
							end
						end
					end
				end
				local EssencePowers
				if itemSlotID == 2 and C_AzeriteEssence and select(3,GetItemInfo(itemLink)) == 6 then
					EssencePowers = moduleInspect:GetEssenceData()
				end

				if AzeritePowers then
					inspectData.azerite["i"..itemSlotID] = AzeritePowers
				end
				
				for j=2, inspectScantip:NumLines() do
					local tooltipLine = _G["ExRTInspectScanningTooltipTextLeft"..j]
					local text = tooltipLine:GetText()
					if text and text ~= "" then
						for stateName,stateData in pairs(moduleInspect.db.statsNames) do
							inspectData[stateName] = inspectData[stateName] or 0
							local findText = text:gsub("[,]",""):gsub("(%d+)[ ]+(%d+)","%1%2")
							for k=1,#stateData do
								local findData = findText:match(stateData[k])
								if findData then
									local cR,cG,cB = tooltipLine:GetTextColor()
									cR = abs(cR - 0.5)
									cG = abs(cG - 0.5)
									cB = abs(cB - 0.5)
									if cR < 0.01 and cG < 0.01 and cB < 0.01 then
										findData = 0
									end
									inspectData[stateName] = inspectData[stateName] + tonumber(findData)
								end
							end
						end
						
						local ilvl = text:match(ITEM_LEVEL)
						if ilvl then
							ilvl = tonumber(ilvl)
							inspectData['ilvl'] = inspectData['ilvl'] + ilvl
							ilvl_count = ilvl_count + 1
							
							inspectData['items_ilvl'][itemSlotID] = ilvl
							
							if itemSlotID == 16 then
								mainHandSlot = ilvl
								ArtifactIlvlSlot1 = ilvl
							elseif itemSlotID == 17 then
								offHandSlot = ilvl
								ArtifactIlvlSlot2 = ilvl
							elseif itemSlotID == 2 and select(3,GetItemInfo(itemLink)) == 6 then
								module.db.spell_cdByTalent_scalable_data[296320][name] = "*"..(1 - ((ilvl - 465) * 0.15 + 19.8) / 100)
								--[[
									63: 18.9
									66: 19.8
								]]
							end
						end
						
						if AzeritePowers then
							for k=1,#AzeritePowers do
								if text:find(AzeritePowers[k].name.."$") == 3 then
									inspectData.azerite[#inspectData.azerite + 1] = AzeritePowers[k]

									module.db.session_gGUIDs[name] = AzeritePowers[k].spellID
								end
							end
						end
						if EssencePowers then
							for k=1,#EssencePowers do
								if text:find(EssencePowers[k].name.."$") == 1 then
									local isMajor = _G["ExRTInspectScanningTooltipTextLeft"..(j-1)]:GetText() == " "
									local tier = 4
									local r,g,b = tooltipLine:GetTextColor()
									if abs(r-0.639)<0.01 and abs(g-0.217)<0.01 and abs(b-0.933)<0.01 then	--a335ee
										tier = 3
									elseif abs(r-0.117)<0.01 and abs(g-1)<0.01 and abs(b-0)<0.01 then	--1eff00
										tier = 1
									elseif abs(r-0)<0.01 and abs(g-0.439)<0.01 and abs(b-0.866)<0.01 then	--0070dd
										tier = 2
									else	--ff8000
										tier = 4
									end

									if isMajor then
										local ess = EssencePowers[k][tier]
										inspectData.essence[#inspectData.essence + 1] = ess
	
										module.db.session_gGUIDs[name] = ess.spellID
										for l=tier-1,1,-1 do
											local ess = EssencePowers[k][l]
											module.db.session_gGUIDs[name] = ess.spellID
										end
									end

									local ess = EssencePowers[k][tier*(-1)]
									if not isMajor then
										inspectData.essence[#inspectData.essence + 1] = ess
									end

									module.db.session_gGUIDs[name] = ess.spellID
									for l=tier-1,1,-1 do
										local ess = EssencePowers[k][l*(-1)]
										module.db.session_gGUIDs[name] = ess.spellID
									end
								end
							end
						end
					end
				end

				if not inspectData['items_ilvl'][itemSlotID] then
					local ilvl = select(4,GetItemInfo(itemLink))
					if ilvl then
						inspectData['ilvl'] = inspectData['ilvl'] + ilvl
						ilvl_count = ilvl_count + 1
						
						inspectData['items_ilvl'][itemSlotID] = ilvl
					end
				end
				
				itemID = tonumber(itemID or 0)
				
				--------> ExCD2
				local tierSetID = module.db.tierSetsList[itemID]
				if tierSetID then
					inspectData['tiersets'][tierSetID] = inspectData['tiersets'][tierSetID] and inspectData['tiersets'][tierSetID] + 1 or 1
				end
				local isTrinket = module.db.itemsToSpells[itemID]
				if isTrinket then
					module.db.session_gGUIDs[name] = isTrinket
				end
				
				
				--------> Relic
				if (itemSlotID == 16 or itemSlotID == 17) and isArtifactEqipped > 0 then
					--|cffe6cc80|Hitem:128935::140840:139250:140840::::110:262:16777472:9:1:744:113:1:3:3443:1472:3336:2:1806:1502:3:3443:1467:1813|h[Кулак Ра-дена]|h
					--|cffe6cc80|Hitem:128908::140837:140841:140817::::110:65 :256     :9:1:751:660:3:3516:1502:3337:3:3516:1497:3336:3:3515:1477:1813|h[Боевые мечи валарьяров]|h|r
					
					local _,itemID,enchant,gem1,gem2,gem3,gem4,suffixID,uniqueID,level,specializationID,upgradeType,instanceDifficultyID,numBonusIDs,restLink = strsplit(":",itemLink,15)
										
					if ((gem1 and gem1 ~= "") or (gem2 and gem2 ~= "") or (gem1 and gem3 ~= "")) and (numBonusIDs and numBonusIDs ~= "") then
						numBonusIDs = tonumber(numBonusIDs)
						for j=1,numBonusIDs do
							if not restLink then
								break
							end
							local _,newRestLink = strsplit(":",restLink,2)
							restLink = newRestLink
						end
						if restLink then
							restLink = restLink:gsub("|h.-$","")
						
							if upgradeType and (tonumber(upgradeType) or 0) < 1000 then
								local _,newRestLink = strsplit(":",restLink,2)
								restLink = newRestLink
							else
								local _,_,newRestLink = strsplit(":",restLink,3)
								restLink = newRestLink							
							end
							
							for relic=1,3 do
								if not restLink then
									break
								end
								local numBonusRelic,newRestLink = strsplit(":",restLink,2)
								numBonusRelic = tonumber(numBonusRelic or "?") or 0
								restLink = newRestLink
								
								if numBonusRelic > 10 then	--Got Error in parsing here
									break
								end
								
								local relicBonus = numBonusRelic
								for j=1,numBonusRelic do
									if not restLink then
										break
									end
									local bonusID,newRestLink = strsplit(":",restLink,2)
									restLink = newRestLink
									relicBonus = relicBonus .. ":" .. bonusID					
								end
								
								local relicItemID = select(3+relic, strsplit(":",itemLink) )
								if relicItemID and relicItemID ~= "" then
									inspectData['items']['relic'..relic] = "item:"..relicItemID.."::::::::110:0::0:"..relicBonus..":::"
								end
							end
						end
					end
				end
			end
			
			inspectScantip:ClearLines()
		end
		if isArtifactEqipped > 0 then
			inspectData['ilvl'] = inspectData['ilvl'] - ArtifactIlvlSlot1 - ArtifactIlvlSlot2 + max(ArtifactIlvlSlot1,ArtifactIlvlSlot2) * 2
			
		elseif mainHandSlot > 0 and offHandSlot == 0 then
			inspectData['ilvl'] = inspectData['ilvl'] + mainHandSlot
		end
		inspectData['ilvl'] = inspectData['ilvl'] / 16
		

		--------> ExCD2
		for tierUID,count in pairs(inspectData['tiersets']) do
			local p2 = module.db.tierSetsSpells[tierUID][1]
			local p4 = module.db.tierSetsSpells[tierUID][2]
			if p2 and count >= 2 then
				if type(p2) ~= "table" then
					module.db.session_gGUIDs[name] = p2
				else
					local sID = p2[ inspectData.specIndex or 0 ]
					if sID then
						module.db.session_gGUIDs[name] = sID
					end
				end
			end
			if p4 and count >= 4 then
				if type(p4) ~= "table" then
					module.db.session_gGUIDs[name] = p4
				else
					local sID = p4[ inspectData.specIndex or 0 ]
					if sID then
						module.db.session_gGUIDs[name] = sID
					end
				end
			end
		end
		UpdateAllData()
	end
end

hooksecurefunc("NotifyInspect", function() moduleInspect.db.inspectID = GetTime() moduleInspect.db.inspectCleared = nil end)
hooksecurefunc("ClearInspectPlayer", function() moduleInspect.db.inspectCleared = true end)

if not ExRT.isClassic then
	hooksecurefunc("SetAchievementComparisonUnit", function() moduleInspect.db.achievementCleared = nil end)
	hooksecurefunc("ClearAchievementComparisonUnit", function() moduleInspect.db.achievementCleared = true end)
end

do
	local tmr = -5
	local queueTimer = 0
	function moduleInspect:timer(elapsed)
		tmr = tmr + elapsed
		if tmr > (inspectForce and 1 or 2) then
			queueTimer = queueTimer + tmr
			tmr = 0
			if queueTimer > 60 then
				queueTimer = 0
				InspectQueue()
			end
			InspectNext()
		end
	end
	function moduleInspect:ResetTimer() tmr = 0 end
end

function moduleInspect:Enable()
	moduleInspect:RegisterTimer()
	moduleInspect:RegisterEvents('PLAYER_SPECIALIZATION_CHANGED','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED','GROUP_ROSTER_UPDATE','ZONE_CHANGED_NEW_AREA','INSPECT_ACHIEVEMENT_READY','CHALLENGE_MODE_START')
end
function moduleInspect:Disable()
	moduleInspect:UnregisterTimer()
	moduleInspect:UnregisterEvents('PLAYER_SPECIALIZATION_CHANGED','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED','GROUP_ROSTER_UPDATE','ZONE_CHANGED_NEW_AREA','INSPECT_ACHIEVEMENT_READY','CHALLENGE_MODE_START')	
end

function moduleInspect.main:ADDON_LOADED()
	if ExRT.SDB.charName then
		moduleInspect.db.inspectQuery[ExRT.SDB.charName] = GetTime()
		moduleInspect.db.inspectNotItemsOnly[ExRT.SDB.charName] = true
	end
	moduleInspect:Enable()
	
	if VExRT.Addon.Version < 3875 and VExRT.InspectArtifact and VExRT.InspectArtifact.players then
		wipe(VExRT.InspectArtifact.players)
	end
end

function moduleInspect.main:PLAYER_SPECIALIZATION_CHANGED(arg)
	if arg and UnitName(arg) then
		local name = UnitCombatlogname(arg)
		moduleInspect.db.inspectDB[name] = nil
		
		--------> ExCD2
		VExRT.ExCD2.gnGUIDs[name] = nil		
		local _,class = UnitClass(name)
		if module.db.spell_talentsList[class] then
			for specID,specTalents in pairs(module.db.spell_talentsList[class]) do
				for _,spellID in pairs(specTalents) do
					if type(spellID) == "number" then
						module.db.session_gGUIDs[name] = -spellID
					end
				end
			end
		end
		
		UpdateAllData()
		--------> / ExCD2
		
		moduleInspect.db.inspectQuery[name] = GetTime()
		moduleInspect.db.inspectNotItemsOnly[name] = true
	end
end

do
	local scheludedQueue = nil
	local function funcScheduledUpdate()
		scheludedQueue = nil
		InspectQueue()
	end
	function moduleInspect.main:GROUP_ROSTER_UPDATE()
		if not scheludedQueue then
			scheludedQueue = ScheduleTimer(funcScheduledUpdate,2)
		end
	end


	local prevDiff = nil
	local function ZoneCheck()
		local _,_,difficulty = GetInstanceInfo()
		if difficulty == 8 or prevDiff == 8 then
			local n = GetNumGroupMembers() or 0
			if IsInRaid() then
				n = min(n,5)
				for j=1,n do
					local name,_,subgroup = GetRaidRosterInfo(j)
					if name and subgroup == 1 then
						moduleInspect.db.inspectNotItemsOnly[name] = true
						moduleInspect.db.inspectQuery[name] = GetTime()
					end
				end
			else
				for j=1,5 do
					local uid = "party"..j
					if j==5 then
						uid = "player"
					end
					local name = UnitCombatlogname(uid)
					if name then
						moduleInspect.db.inspectNotItemsOnly[name] = true
						moduleInspect.db.inspectQuery[name] = GetTime()
					end
				end
			end
		end
		prevDiff = difficulty
	end
	function moduleInspect.main:ZONE_CHANGED_NEW_AREA()
		ExRT.F.Timer(ZoneCheck,2)
		
		if not scheludedQueue then
			scheludedQueue = ScheduleTimer(funcScheduledUpdate,4)
		end
	end
	function moduleInspect.main:CHALLENGE_MODE_START()
		ExRT.F.Timer(ZoneCheck,2)
		
		if not scheludedQueue then
			scheludedQueue = ScheduleTimer(funcScheduledUpdate,4)
		end
	end
end

do
	local lastInspectTime = {}
	function moduleInspect.main:INSPECT_READY(arg)
		if not moduleInspect.db.inspectCleared then
			ExRT.F.dprint('INSPECT_READY',arg)
			if not arg then 
				return
			end
			local currTime = GetTime()
			if lastInspectTime[arg] and (currTime - lastInspectTime[arg]) < 0.2 then
				return
			end
			lastInspectTime[arg] = currTime
			local _,_,_,race,_,name,realm = GetPlayerInfoByGUID(arg)
			if name then
				if realm and realm ~= "" then name = name.."-"..realm end
				local inspectedName = name
				if UnitName("target") == DelUnitNameServer(name) then 
					inspectedName = "target"
				elseif not UnitName(name) then
					return
				end
				moduleInspect:ResetTimer()
				local _,class,classID = UnitClass(inspectedName)
				
				for i,slotID in pairs(moduleInspect.db.itemsSlotTable) do
					local link = GetInventoryItemLink(inspectedName, slotID)
				end
				ScheduleTimer(InspectItems, inspectForce and 0.65 or 1.3, name, inspectedName, moduleInspect.db.inspectID)
				if not inspectForce then
					--ScheduleTimer(InspectItems, 2.3, name, inspectedName, moduleInspect.db.inspectID)
				end
	
				if moduleInspect.db.inspectDB[name] and moduleInspect.db.inspectItemsOnly[name] and not moduleInspect.db.inspectNotItemsOnly[name] then
					moduleInspect.db.inspectItemsOnly[name] = nil
					return
				end
				moduleInspect.db.inspectItemsOnly[name] = nil
				moduleInspect.db.inspectNotItemsOnly[name] = nil
				
				if moduleInspect.db.inspectDB[name] then
					wipe(moduleInspect.db.inspectDB[name])
				else
					moduleInspect.db.inspectDB[name] = {}
				end
				local data = moduleInspect.db.inspectDB[name]
				
				data.spec = round( GetInspectSpecialization(inspectedName) )
				if data.spec < 1000 then
					VExRT.ExCD2.gnGUIDs[name] = data.spec
				end
				data.class = class
				data.classID = classID
				data.level = UnitLevel(inspectedName)
				data.race = race
				data.time = time()
				data.GUID = UnitGUID(inspectedName)
				data.lastUpdate = currTime
				data.lastUpdateTime = time()
				
				local specIndex = 1
				for i=1,GetNumSpecializationsForClassID(classID) do
					if GetSpecializationInfoForClassID(classID,i) == data.spec then
						specIndex = i
						break
					end
				end
				data.specIndex = specIndex
				
				for i=1,7 do
					data[i] = 0
				end
				data.talentsIDs = {}
				
				local classTalents = module.db.spell_talentsList[class]
				if classTalents then
					for _,list in pairs(classTalents) do
						for _,spellID in pairs(list) do
							module.db.session_gGUIDs[name] = -spellID
						end
					end
				end
				for spellID,specID in pairs(module.db.spell_autoTalent) do
					if specID == data.spec then
						module.db.session_gGUIDs[name] = spellID
					end
				end
				
				for i=0,20 do
					local row,col = (i-i%3)/3+1,i%3+1
				
					local talentID, _, _, selected, available, spellID, _, _, _, _, grantedByAura = GetTalentInfo(row,col,specIndex,true,inspectedName)
					if selected then
						data[row] = col
						data.talentsIDs[row] = talentID
					end
					
					--------> ExCD2
					if spellID then
						local list = module.db.spell_talentsList[class]
						if not list then
							list = {}
							module.db.spell_talentsList[class] = list
						end
						
						list[specIndex] = list[specIndex] or {}
						
						list[specIndex][i+1] = spellID
						if selected or grantedByAura then
							module.db.session_gGUIDs[name] = spellID
						end
						
						module.db.spell_isTalent[spellID] = true
					end
					--------> /ExCD2
				end

				for i=1,4 do
					local talentID = C_SpecializationInfo_GetInspectSelectedPvpTalent(inspectedName, i)
					if talentID then					
						data[i+7] = 1
						data.talentsIDs[i+7] = talentID
						
						local _, _, _, selected, available, spellID, _, _, _, _, grantedByAura = GetPvpTalentInfoByID(talentID)
						if spellID then
							local list = module.db.spell_talentsList[class]
							if not list then
								list = {}
								module.db.spell_talentsList[class] = list
							end
							
							list[-1] = list[-1] or {}
							
							list[-1][spellID] = spellID
							
							module.db.session_gGUIDs[name] = spellID
							
							--module.db.spell_isTalent[spellID] = true
							module.db.spell_isPvpTalent[spellID] = true
						end
					end
				end
				InspectItems(name, inspectedName, moduleInspect.db.inspectID)
				
				UpdateAllData() 	--------> ExCD2
			end
		end
	end
end

do
	local lastInspectTime,lastInspectGUID = 0
	moduleInspect.db.acivementsIDs = {} 
	function moduleInspect.main:INSPECT_ACHIEVEMENT_READY(guid)
		ExRT.F.dprint('INSPECT_ACHIEVEMENT_READY',guid)
		if moduleInspect.db.achievementCleared then
			C_Timer.NewTimer(.3,ClearAchievementComparisonUnit)	--prevent client crash on opening statistic 
			return
		end
		local currTime = GetTime()
		if not guid or (lastInspectGUID == guid and (currTime - lastInspectTime) < 0.2) then
			C_Timer.NewTimer(.3,ClearAchievementComparisonUnit)	--prevent client crash on opening statistic 
			return
		end
		lastInspectGUID = guid
		lastInspectTime = currTime
		local _,_,_,_,_,name,realm = GetPlayerInfoByGUID(guid)
		if name then
			if realm and realm ~= "" then name = name.."-"..realm end
			
			if moduleInspect.db.inspectDBAch[name] then
				wipe(moduleInspect.db.inspectDBAch[name])
			else
				moduleInspect.db.inspectDBAch[name] = {}
			end
			local data = moduleInspect.db.inspectDBAch[name]
			data.guid = guid
			for _,id in pairs(moduleInspect.db.acivementsIDs) do
				if id > 0 then
					local completed, month, day, year, unk1 = GetAchievementComparisonInfo(id)
					if completed then
						data[id] = month..":"..day..":"..year
					end
				else
					id = -id
					local info = GetComparisonStatistic(id)
					info = tonumber(info or "-")
					if info then
						data[id] = info
					end
				end
			end
		end
		if not AchievementFrame or not AchievementFrame:IsShown() then
			C_Timer.NewTimer(.3,ClearAchievementComparisonUnit)	--prevent client crash on opening statistic 
		end
	end
end

function moduleInspect.main:UNIT_INVENTORY_CHANGED(arg)
	if ExRT.isClassic then	--Temp fix for 'Unknown unit' or 'Out of Range' errors
		return
	end
	if arg=='player' then return end
	local name = UnitCombatlogname(arg or "?")
	if name and name ~= ExRT.SDB.charName then
		moduleInspect.db.inspectItemsOnly[name] = true
		moduleInspect.db.inspectQuery[name] = GetTime()
	end
end

function moduleInspect.main:PLAYER_EQUIPMENT_CHANGED(arg)
	local name = UnitCombatlogname("player")
	moduleInspect.db.inspectItemsOnly[name] = true
	moduleInspect.db.inspectQuery[name] = GetTime()
end

