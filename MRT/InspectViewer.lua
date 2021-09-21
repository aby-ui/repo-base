local GlobalAddonName, ExRT = ...

local VMRT = nil

local parentModule = ExRT.A.Inspect
if not parentModule then
	return
end
local module = ExRT:New("InspectViewer",ExRT.L.InspectViewer)
local ELib,L = ExRT.lib,ExRT.L

module.db.inspectDB = parentModule.db.inspectDB
module.db.inspectDBAch = parentModule.db.inspectDBAch
module.db.inspectQuery = parentModule.db.inspectQuery
module.db.specIcons = ExRT.A.ExCD2 and ExRT.A.ExCD2.db.specIcons
module.db.itemsSlotTable = parentModule.db.itemsSlotTable
module.db.classIDs = ExRT.GDB.ClassID
module.db.glyphsIDs = {8,9,10,11,12,13}

module.db.statsList = {'intellect','agility','strength','haste','mastery','crit','spellpower','multistrike','versatility','armor','leech','avoidance','speed','corruption'}
module.db.statsListName = {L.InspectViewerInt,L.InspectViewerAgi,L.InspectViewerStr,L.InspectViewerHaste,L.InspectViewerMastery,L.InspectViewerCrit,L.InspectViewerSpd, L.InspectViewerMS, L.InspectViewerVer, L.InspectViewerBonusArmor, L.InspectViewerLeech, L.InspectViewerAvoidance, L.InspectViewerSpeed,ITEM_MOD_CORRUPTION}

module.db.baseStats = {	--By class IDs
	strength =  {	450,	450,	0,	0,	0,	450,	0,	0,	0,	0,	0,	0,	},
	agility =   {	0,	0,	450,	450,	0,	0,	450,	0,	0,	450,	450,	450,	},
	intellect = {	0,	450,	0,	0,	450,	0,	450,	450,	450,	450,	450,	0,	},
		--	WARRIOR,PALADIN,HUNTER,	ROGUE,	PRIEST,	DK,	SHAMAN,	MAGE,	WARLOCK,MONK,	DRUID,	DH,
}
module.db.raceList = {'Human','Dwarf','Night Elf','Orc','Tauren','Undead','Gnome','Troll','Blood Elf','Draenei','Goblin','Worgen','Pandaren'}
module.db.raceStatsDiffs = {	--Outdated
	strength =  {	0,	5,	-4,	3,	5,	-1,	-5,	1,	-3,	1,	-3,	3,	0,	},
	agility =   {	0,	-4,	4,	-3,	-4,	-2,	2,	2,	2,	-3,	2,	2,	-2,	},
	intellect = {	0,	-1,	0,	-3,	-4,	-2,	3,	-4,	3,	0,	3,	-4,	-1,	},
		--	Human,	Dwarf,	NElf,	Orc,	Tauren,	Undead,	Gnome,	Troll,	BElf,	Draenei,Goblin,	Worgen,	Pandaren
}

module.db.armorType = ExRT.GDB.ClassArmorType
module.db.roleBySpec = ExRT.GDB.ClassSpecializationRole

module.db.specHasOffhand = {
	[71]=true,
	[72]=true,
	[251]=true,
	[252]=true,
	[259]=true,
	[260]=true,
	[261]=true,
	[263]=true,
	[268]=true,
	[269]=true,
	[577]=true,
	[581]=true,
}

module.db.socketsBonusIDs = {
	[563]=true,
	[564]=true,
	[565]=true,
	[572]=true,
	[1808]=true,
	[4802]=true,
	[6935]=true,
	[6672]=true,
	[6514]=true,
	[4231]=true,
	[3522]=true,
	[3475]=true,
}

local IS_LOW = UnitLevel'player' < 50
local IS_BFA = UnitLevel'player' < 60
local IS_SL = UnitLevel'player' >= 60

module.db.topEnchGems = IS_SL and {
	[6202]="cloak:stamina:speed",
	[6208]="cloak:stamina",
	[6204]="cloak:stamina:leech",
	[6203]="cloak:stamina:avoid",

	[6211]="boots:agi",
	--[6207]="boots:falldmg",

	[6220]="bracer:int",
	--[6222]="bracer:hs",

	[6230]="chest:stats",
	[6217]="chest:int:mana",
	[6214]="chest:str:agi",
	[6213]="chest:armor:str:agi",
	[6265]="chest:dmg",

	[6210]="gloves:str",
	--[6205]="gloves:gather",

	[6170]="ring:vers",
	[6168]="ring:mastery",
	[6166]="ring:haste",
	[6164]="ring:crit",

	[6229]="weapon:stat",
	[6228]="weapon:damage",
	[6227]="weapon:heal",
	[6226]="weapon:heal",
	[6223]="weapon:damage",

	[6195]="HunterWeapon:haste",
	[6196]="HunterWeapon:crit",

	[173129]="Gem:vers:16",
	[173127]="Gem:crit:16",
	[173130]="Gem:mastery:16",
	[173128]="Gem:haste:16",
	[168638]="Gem:int:7",

	[3368]="DKWeapon:knight",
	[3370]="DKWeapon:frost",
	[3847]="DKWeapon:2h",

	[187079]="Gem:SoD:Unholy",
	[187076]="Gem:SoD:Unholy",
	[187073]="Gem:SoD:Unholy",
	[187071]="Gem:SoD:Frost",
	[187065]="Gem:SoD:Frost",
	[187063]="Gem:SoD:Frost",
	[187061]="Gem:SoD:Blood",
	[187059]="Gem:SoD:Blood",
	[187057]="Gem:SoD:Blood",
} or {
	--[5938]="Ring:Crit:27",
	--[5939]="Ring:Haste:27",
	--[5940]="Ring:Mastery:27",
	--[5941]="Ring:Vers:27",

	--[5942]="Ring:Crit:37",
	--[5943]="Ring:Haste:37",
	--[5944]="Ring:Mastery:37",
	--[5945]="Ring:Vers:37",

	[6108]="Ring:Crit:60",
	[6109]="Ring:Haste:60",
	[6110]="Ring:Mastery:60",
	[6111]="Ring:Vers:60",

	[5946]="Weapon:hot",
	[5965]="Weapon:crit",
	[5950]="Weapon:attakspeed",
	[5964]="Weapon:mastery",
	[5963]="Weapon:haste",
	[5948]="Weapon:leech",
	[5966]="Weapon:armor",
	[5949]="Weapon:elemental",
	[5962]="Weapon:vers",

	[6112]="Weapon:unk",
	[6150]="Weapon:unk",
	[6149]="Weapon:unk",
	[6148]="Weapon:unk",

	[5955]="HunterWeapon:crit",
	[5956]="HunterWeapon:haste",
	[5958]="HunterWeapon:frost",
	[5957]="HunterWeapon:fire",

	[3368]="DKWeapon:knight",
	[3370]="DKWeapon:frost",
	[3847]="DKWeapon:2h",

	--[153710]="Gem:crit:30",
	--[153711]="Gem:haste:30",
	--[153712]="Gem:vers:30",
	--[153713]="Gem:mastery:30",

	[153709]="Gem:int:80",
	[153708]="Gem:agi:80",
	[153707]="Gem:str:80",

	[168638]="Gem:int:120",
	[168637]="Gem:agi:120",
	[168636]="Gem:str:120",

	--[154128]="Gem:vers:40",
	--[154129]="Gem:mastery:40",
	--[154126]="Gem:crit:40",
	--[154127]="Gem:haste:40",

	[168642]="Gem:vers:50",
	[168640]="Gem:mastery:50",
	[168639]="Gem:crit:50",
	[168641]="Gem:haste:50",
	[169220]="Gem:movespeed:5",
}


module.db.achievementsList = {
	{	--SoD
		L.S_ZoneT27SoD,
		15122,15123,15124,15125,15126,15112,15113,15114,15116,15115,15117,15118,15119,15120,15121,15128,15134,15135,
	},{	--castle Nathria
		L.S_ZoneT26CastleNathria,
		14715,14717,14718,14356,14357,14360,14359,14358,14361,14362,14363,14364,14365,14460,14461,
	},{	--SL 5ppl
		(EXPANSION_NAME8 or "SL")..": "..DUNGEONS,
		14418,14409,14411,14413,14415,14199,14325,14368,14417,14531,14532,
	},{	--Nyalotha
		L.S_ZoneT25Nyalotha,
		14193,14194,14195,14196,14041,14043,14044,14045,14050,14046,14051,14048,14049,14052,14054,14055,14068,
	},{	--EP
		L.S_ZoneT24Eternal,
		13718,13719,13725,13726,13727,13728,13729,13730,13731,13732,13733,13784,13785,
	},{	--CoS
		L.S_ZoneT23Storms,
		13414,13416,13417,13418,13419,
	},{	--BfD
		L.S_ZoneT23Siege,
		13289,13290,13291,13292,13293,13295,13299,13300,13311,13312,13313,13314,13322,
	},{	--Uldir
		L.S_ZoneT22Uldir,
		12521,12522,12523,12524,12526,12527,12529,12530,12531,12532,12533,12536,
	},{	--BFA 5ppl
		EXPANSION_NAME7..": "..DUNGEONS,
		12807,12846,12826,12848,12502,12506,12847,12842,12833,12838,12488,13075,
	},{	--A
		L.S_ZoneT21A,
		11988,11989,11990,11991,11992,11993,11994,11995,11996,11997,11998,11999,12000,12001,12002,12110,
	},{	--ToS
		L.S_ZoneT20ToS,
		11787,11788,11789,11790,11767,11774,11775,11777,11778,11776,11779,11780,11781,11874,
	},{	--Nighthold
		L.S_ZoneT19Suramar,
		10829,10837,10838,10839,10840,10842,10843,10844,10848,10847,10846,10845,10849,10850,11195,
	},{	--Trial of Valor
		L.S_ZoneT19ToV,
		11426,11396,11397,11398,11581,
	},{	--Nightmare
		L.S_ZoneT19Nightmare,
		10818,10819,10820,10821,10822,10823,10824,10825,10826,10827,

	},{	--Legion 5ppl
		EXPANSION_NAME6..": "..DUNGEONS,
		11164,10800,10806,10816,10785,10782,10789,10809,10797,10813,10803,11183,11184,11185,11162,

	},{	--Legion Questing & Artifact
		EXPANSION_NAME6..": "..QUESTS_LABEL,
		10617,11124,10877,10852,10746,

	},{	--HFC
		L.RaidLootT18HC..":"..L.sencounterWODMythic,
		10027,10032,10033,10034,10035,10253,10037,10040,10041,10038,10039,10042,10043,
	},{
		L.RaidLootT18HC,
		10023,10024,10025,10020,10019,10044,
	},{	--BRF
		L.RaidLootT17BF..":"..L.sencounterWODMythic,
		8966,8967,8970,8968,8932,8971,8956,8969,8972,8973,
	},{
		L.RaidLootT17BF,
		8989,8990,8991,8992,9444,
	},{	--H
		L.RaidLootT17Highmaul..":"..L.sencounterWODMythic,
		8949,8960,8962,8961,8963,8964,8965,
	},{
		L.RaidLootT17Highmaul,
		8986,8987,8988,9441,
	},{	--Old curves
		EXPANSION_NAME4,
		6954,7485,8246,7486,8248,7487,8249,8238,8260,8398,8400,8399,8401
	},
}
module.db.achievementsList_statistic = {
	{	--SoD
		
	},{	--CN
		0,0,0,{14422,14419,14420,14421},{14426,14423,14424,14425},{14438,14435,14436,14437},{14434,14431,14432,14433},{14430,14427,14428,14429},{14442,14439,14440,14441},{14446,14443,14444,14445},{14450,14447,14448,14449},{14454,14451,14452,14453},{14458,14455,14456,14457},
	},{
		0,{14387,14388,14389},{14390,14391,14392},{14393,14394,14395},{14396,14397,14398},{14201,14202,14205},{14399,14400,14401},{14402,14403,14404},{14405,14406,14407}
	},{
		0,0,0,0,{14078,14079,14080,14082},{14089,14091,14093,14094},{14095,14096,14097,14098},{14101,14102,14104,14105},{14123,14124,14125,14126},{14107,14108,14109,14110},{14127,14128,14129,14130},{14111,14112,14114,14115},{14117,14118,14119,14120},{14207,14208,14210,14211},{14131,14132,14133,14134},{14135,14136,14137,14138}
	},{	--EP
		0,0,0,{13587,13588,13589,13590},{13595,13596,13597,13598},{13591,13592,13593,13594},{13600,13601,13602,13603},{13604,13605,13606,13607},{13608,13609,13610,13611},{13612,13613,13614,13615},{13616,13617,13618,13619},
	},{	--CoS
		0,{13404,13405,13406,13407},{13408,13411,13412,13413},
	},{	--BfD
		0,0,0,{13328,13329,13330,13331},{13332,13333,13334,13336},{13354,13355,13356,13357},{13358,13359,13361,13362},{13363,13364,13365,13366},{13367,13368,13369,13370},{13371,13372,13373,13374},{13375,13376,13377,13378},{13379,13380,13381,13382},
	},{	--Uldir
		0,0,0,{12786,12787,12788,12789},{12790,12791,12792,12793},{12798,12799,12800,12801},{12802,12803,12804,12805},{12794,12795,12796,12797},{12808,12809,12810,12811},{12813,12814,12815,12816},{12817,12818,12819,12820},
	},{	--BFA 5ppl
		0,{12777,12778,12779},{12720,12748,12749},{12763},{12728,12729,12745},{12774,12775,12776},{12773},{12780,12781,12782},{12750,12751,12752},{12766,12767,12768},{12783,12784,12785},
	},{	--A

	},{	--ToS

	},{	--Nighthold
		0,0,0,0,{10940,10941,10942,10943},{10944,10945,10946,10947},{10948,10949,10950,10951},{10952,10953,10954,10955},{10969,10970,10971,10972},{10965,10966,10967,10968},{10961,10962,10963,10964},{10956,10957,10959,10960},{10973,10974,10975,10976},{10977,10978,10979,10980},
	},{	--Trial of Valor
		0,{11407,11408,11409,11410},{11411,11412,11413,11414},{11415,11416,11417,11418},
	},{	--Nightmare
		0,0,0,{10911,10912,10913,10914},{10920,10921,10922,10923},{10924,10925,10926,10927},{10915,10916,10917,10918},{10928,10929,10930,10931},{10932,10933,10934,10935},{10936,10937,10938,10939},
	},{	--Legion 5ppl
		{10981,10982},{10890,10891,10892,10893,10894,10895},{10899,10900,10901},{10910},{10881,10882,10883},{10878,10879,10880},{10887,10888,10889},{10902,10903,10904},
		{10884,10885,10886},{10907},{10896,10897,10898},nil,nil,nil,nil,

	},{	--Legion Questing & Artifact
		nil,nil,nil,nil,nil,

	},{	--HFC
		{10201,10202,10203,10204},{10205,10206,10207,10208},{10209,10210,10211,10212},{10213,10214,10215,10216},{10217,10218,10219,10220},{10221,10222,10223,10224},{10225,10226,10227,10228},
		{10229,10230,10231,10232},{10241,10242,10243,10244},{10233,10234,10235,10236},{10237,10238,10239,10240},{10245,10246,10247,10248},{10249,10250,10251,10252},
	},{
		{-10201,-10202,-10203,-10205,-10206,-10207,-10209,-10210,-10211},{-10213,-10214,-10215,-10217,-10218,-10219,-10221,-10222,-10223},
		{-10225,-10226,-10227,-10229,-10230,-10231,-10241,-10242,-10243},{-10233,-10234,-10235,-10237,-10238,-10239,-10245,-10246,-10247},{-10249,-10250,-10251},{-10251,-10252},
	},{	--BRF
		{9316,9317,9318,9319},{9320,9321,9322,9323},{9343,9349,9351,9353},{9324,9327,9328,9329},{9330,9331,9332,9333},
		{9354,9355,9356,9357},{9334,9336,9337,9338},{9339,9340,9341,9342},{9358,9359,9360,9361},{9362,9363,9364,9365},
	},{
		{-9316,-9317,-9318,-9320,-9321,-9322,-9343,-9349,-9351},{-9324,-9327,-9328,-9330,-9331,-9332,-9354,-9355,-9356},{-9334,-9336,-9337,-9339,-9340,-9341,-9358,-9359,-9360},{-9362,-9363,-9364},{-9364,-9365},
	},{	--H
		{9280,9282,9284,9285},{9286,9287,9288,9289},{9295,9297,9298,9300},{9290,9292,9293,9294},{9301,9302,9303,9304},{9306,9308,9310,9311},{9312,9313,9314,9315},
	},{
		{-9280,-9282,-9284,-9286,-9287,-9288,-9295,-9297,-9298},{-9290,-9292,-9293,-9301,-9302,-9303,-9306,-9308,-9310},{-9312,-9313,-9314},{-9314,-9315},
	},{	--Old curves
		{6799,7926},{6800,7927},{6811,7963},{6812,7964},{6819,7971},{6820,7972},{8199,8200},{8202,8201},{8203,8256},{8635},{8637},{8636},{8638},
	},
}

do
	local array = parentModule.db.acivementsIDs
	for i=1,#module.db.achievementsList do
		local from = module.db.achievementsList[i]
		local size = #from
		for j=2,size do
			array[#array + 1] = from[j]
		end

		local from = module.db.achievementsList_statistic[i]
		for j=1,size-1 do
			if from[j] and from[j]~=0 then
				for k=1,#from[j] do
					local id = from[j][k]
					if id > 0 then
						array[#array + 1] = -id
					elseif id < 0 then
						from[j][k] = -id
					end
				end
			end
		end
	end
	--ELib:Frame(UIParent):SetScript('OnUpdate',function()local q=GetMouseFocus()if not q or not q.id then DInfo'nil' return end DInfo(q.id)end)
end

module.db.relicLocalizated = {
	[0] = "|cff00ff00"..RELIC_SLOT_TYPE_FEL,
	[1] = "|cffff5000"..RELIC_SLOT_TYPE_FIRE,
	[2] = "|cffff262c"..RELIC_SLOT_TYPE_BLOOD,
	[3] = "|cff438d1d"..RELIC_SLOT_TYPE_LIFE,
	[4] = "|cffffee00"..RELIC_SLOT_TYPE_HOLY,
	[5] = "|cff77ffcc"..RELIC_SLOT_TYPE_FROST,
	[6] = "|cff400e51"..RELIC_SLOT_TYPE_SHADOW,
	[7] = "|cff555555"..RELIC_SLOT_TYPE_IRON,
	[8] = "|cffff65f5"..RELIC_SLOT_TYPE_ARCANE,
	[9] = "|cff403cff"..RELIC_SLOT_TYPE_WIND,
}

module.db.perPage = 19
module.db.page = 1

module.db.filter = nil
module.db.filterType = nil

module.db.colorizeNoEnch = true
module.db.colorizeLowIlvl = true
module.db.colorizeNoGems = true
module.db.colorizeNoTopEnchGems = false
module.db.colorizeLowIlvl685 = false
module.db.colorizeNoValorUpgrade = false

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.InspectViewer = VMRT.InspectViewer or {}

	if VMRT.Addon.Version < 3580 then
		VMRT.InspectViewer.ColorizeNoEnch = true
		VMRT.InspectViewer.ColorizeLowIlvl = true
		VMRT.InspectViewer.ColorizeNoGems = true
		VMRT.InspectViewer.ColorizeNoTopEnchGems = false
		VMRT.InspectViewer.ColorizeLowIlvl685 = false
		VMRT.InspectViewer.ColorizeNoValorUpgrade = false
	end

	module:RegisterSlash()
end

function module.main:INSPECT_READY()
	module.options.UpdatePage_InspectEvent()
end

function module:Enable()
	parentModule:RegisterTimer()
	parentModule:RegisterEvents('GROUP_ROSTER_UPDATE','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED')
	parentModule.main:GROUP_ROSTER_UPDATE()
end

function module:Disable()
	if not VMRT or not VMRT.ExCD2 or not VMRT.ExCD2.enabled then
		parentModule:UnregisterTimer()
		parentModule:UnregisterEvents('GROUP_ROSTER_UPDATE','INSPECT_READY','UNIT_INVENTORY_CHANGED','PLAYER_EQUIPMENT_CHANGED')
	end
end

do
	local specToStat = {
		[62] = "int",
		[63] = "int",
		[64] = "int",
		[65] = "int",
		[66] = "str",
		[70] = "str",
		[71] = "str",
		[72] = "str",
		[73] = "str",
		[102] = "int",
		[103] = "agi",
		[104] = "agi",
		[105] = "int",
		[250] = "str",
		[251] = "str",
		[252] = "str",
		[253] = "agi",
		[254] = "agi",
		[255] = "agi",
		[256] = "int",
		[257] = "int",
		[258] = "int",
		[259] = "agi",
		[260] = "agi",
		[261] = "agi",
		[262] = "int",
		[263] = "agi",
		[264] = "int",
		[265] = "int",
		[266] = "int",
		[267] = "int",
		[268] = "agi",
		[269] = "agi",
		[270] = "int",
		[577] = "agi",
		[581] = "agi",
	}
	function module:GetSpecMainStat(specID)
		return specToStat[specID or 0]
	end
end

function module.options:Load()
	self:CreateTilte()

	local GetSpecializationInfoByID = GetSpecializationInfoByID
	if ExRT.isClassic then
		GetSpecializationInfoByID = ExRT.Classic.GetSpecializationInfoByID
	end

	local function reloadChks(self)
		local clickID = self.selected

		if clickID == 4 then
			module.options.achievementsDropDown:Show()
			module.options.filterDropDown:Hide()
		else
			module.options.achievementsDropDown:Hide()
			module.options.filterDropDown:Show()
		end
		if clickID == 6 or clickID == 7 then
			self.selectFunc(self.tabs[5].button)
		end

		module.db.page = clickID
		module.options.showPage()
	end

	self.decorationLine = ELib:DecorationLine(self,true):Point("TOPLEFT",self,0,-16):Point("BOTTOMRIGHT",self,"TOPRIGHT",0,-36)

	self.chkItemsTrack = ELib:Template("ExRTTrackingButtonModernTemplate",self)  

	do
		local text_az = TOOLTIP_AZERITE_UNLOCK_LEVELS:gsub(" %(.*","")
		if ExRT.locale == "zhTW" or ExRT.locale == "zhCN" then
			text_az = TOOLTIP_AZERITE_UNLOCK_LEVELS:gsub(" ?%(.*","")
		end

		local text_relic = RELIC_TOOLTIP_TYPE:gsub("[%( ]*%%s[%) ]*","")

		local extra_list = {}
		local contentID
		if ExRT.isClassic or (UnitLevel'player' < 40) then
			contentID = 0
		elseif UnitLevel'player' < 50 then
			contentID = 1
			extra_list[#extra_list+1] = text_relic
		elseif UnitLevel'player' < 51 then
			contentID = 2
			extra_list[#extra_list+1] = text_az
		else
			contentID = 3
			extra_list[#extra_list+1] = LANDING_PAGE_SOULBIND_SECTION_HEADER
		end

		self.tab = ELib:Tabs(self,0,L.InspectViewerItems.."           ",L.InspectViewerTalents,L.InspectViewerInfo,ACHIEVEMENTS,unpack(extra_list)):Point(0,-36):Size(698,1):SetTo(1)
		self.tab:SetBackdropBorderColor(0,0,0,0)
		self.tab:SetBackdropColor(0,0,0,0)

		self.tab.buttonAdditionalFunc = reloadChks

		if self.tab.tabs[5] then
			self.tab.tabs[5].button.id = contentID == 1 and 6 or contentID == 2 and 5 or contentID == 3 and 7 or 5
		end
	end

	local inspectScantip = CreateFrame("GameTooltip", "ExRTInspectViewerScanningTooltip", nil, "GameTooltipTemplate")
	inspectScantip:SetOwner(UIParent, "ANCHOR_NONE")

	local ScanRelicType_STR = RELIC_TOOLTIP_TYPE:gsub("([%(%)])","%%%1"):gsub("%%s","(.-)")
	local ScanRelicType_Cache = {}
	local function ScanRelicType(relicLink)
		local _,itemID = strsplit(":",relicLink)
		if ScanRelicType_Cache[itemID] then
			return ScanRelicType_Cache[itemID]
		end
		inspectScantip:SetHyperlink(relicLink)

		for j=2, inspectScantip:NumLines() do
			local text = _G["ExRTInspectViewerScanningTooltipTextLeft"..j]:GetText()
			if text and text:find(ScanRelicType_STR) then
				local type_name = text:match(ScanRelicType_STR)

				local type_name_lower = type_name:lower()
				for id,str in pairs(module.db.relicLocalizated) do
					if str:lower():find(type_name_lower) then
						inspectScantip:ClearLines()
						ScanRelicType_Cache[itemID] = id
						return id
					end
				end

				inspectScantip:ClearLines()
				ScanRelicType_Cache[itemID] = type_name
				return type_name
			end
		end

		inspectScantip:ClearLines()
	end

	local function ItemsTrackDropDownClick(self)
		local f = self.checkButton:GetScript("OnClick")
		self.checkButton:SetChecked(not self.checkButton:GetChecked())
		f(self.checkButton)
	end

	module.db.colorizeNoEnch = VMRT.InspectViewer.ColorizeNoEnch
	module.db.colorizeLowIlvl = VMRT.InspectViewer.ColorizeLowIlvl
	module.db.colorizeNoGems = VMRT.InspectViewer.ColorizeNoGems
	module.db.colorizeNoTopEnchGems = VMRT.InspectViewer.ColorizeNoTopEnchGems
	module.db.colorizeLowIlvl685 = VMRT.InspectViewer.ColorizeLowIlvl685
	module.db.colorizeNoValorUpgrade = VMRT.InspectViewer.ColorizeNoValorUpgrade

	local colorizeLowIlvl630 = 183
	local colorizeLowIlvl685 = 213
	if IS_LOW then
		colorizeLowIlvl630 = 50
		colorizeLowIlvl685 = 80
	end
	if IS_BFA then
		colorizeLowIlvl630 = 100
		colorizeLowIlvl685 = 120
	end

	self.chkItemsTrackDropDown = ELib:DropDown(self,300,6):Point(50,0):Size(50)
	self.chkItemsTrackDropDown:Hide()
	self.chkItemsTrackDropDown.List = {
		{text = L.InspectViewerColorizeNoEnch,checkable = true,checkState = module.db.colorizeNoEnch, checkFunc = function(self,checked) 
			module.db.colorizeNoEnch = checked
			VMRT.InspectViewer.ColorizeNoEnch = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = L.InspectViewerColorizeNoGems,checkable = true,checkState = module.db.colorizeNoGems, checkFunc = function(self,checked) 
			module.db.colorizeNoGems = checked
			VMRT.InspectViewer.ColorizeNoGems = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = L.InspectViewerColorizeNoTopEnch,checkable = true,checkState = module.db.colorizeNoTopEnchGems, checkFunc = function(self,checked) 
			module.db.colorizeNoTopEnchGems = checked
			VMRT.InspectViewer.ColorizeNoTopEnchGems = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = format(L.InspectViewerColorizeLowIlvl,colorizeLowIlvl630),checkable = true,checkState = module.db.colorizeLowIlvl, checkFunc = function(self,checked) 
			module.db.colorizeLowIlvl = checked
			VMRT.InspectViewer.ColorizeLowIlvl = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		{text = format(L.InspectViewerColorizeLowIlvl,colorizeLowIlvl685),checkable = true,checkState = module.db.colorizeLowIlvl685, checkFunc = function(self,checked) 
			module.db.colorizeLowIlvl685 = checked
			VMRT.InspectViewer.ColorizeLowIlvl685 = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		--[[
		{text = L.InspectViewerColorizeNoValorUpgrade,checkable = true,checkState = module.db.colorizeNoValorUpgrade, checkFunc = function(self,checked)
			module.db.colorizeNoValorUpgrade = checked
			VMRT.InspectViewer.ColorizeNoValorUpgrade = checked
			module.options.ReloadPage()
		end,func = ItemsTrackDropDownClick},
		]]
		{text = L.minimapmenuclose,checkable = false, padding = 16, func = function()
			ELib:DropDownClose()
		end},
	}



	self.chkItemsTrack:SetPoint("RIGHT", self.tab.tabs[1].button.Text, 0,0)
	self.chkItemsTrack:SetScale(.8)
	self.chkItemsTrack.Button:SetScript("OnClick",function (this)
		if ExRT.lib.ScrollDropDown.DropDownList[1]:IsShown() then
			ELib:DropDownClose()
		else
			ExRT.lib.ScrollDropDown.ToggleDropDownMenu(module.options.chkItemsTrackDropDown)
		end
	end)
	self.chkItemsTrackDropDown:ClearAllPoints()
	self.chkItemsTrackDropDown:SetPoint("CENTER",self.chkItemsTrack,0,0)
	self.chkItemsTrackDropDown.toggleX = -32

	self:SetScript("OnHide",function() ELib:DropDownClose() end)

	local dropDownTable = {
		[1] = {
			ExRT.isClassic and {
				"WARRIOR",
				"PALADIN",
				"HUNTER",
				"ROGUE",
				"PRIEST",
				"SHAMAN",
				"MAGE",
				"WARLOCK",
				"DRUID",
			} or ExRT.GDB.ClassList,
		},
		[2] = {
			{"CLOTH","LEATHER","MAIL","PLATE"},
			{L.InspectViewerTypeCloth,L.InspectViewerTypeLeather,L.InspectViewerTypeMail,L.InspectViewerTypePlate},
		},
		[3] = {
			{"TANK","HEAL","MELEE-RANGE","MELEE","RANGE"},
			{TANK,HEALER,DAMAGER,MELEE,RANGED},
		},
		[4] = {
			{
				ExRT.isClassic and "_PALADIN_PRIEST_WARLOCK" or "_PALADIN_PRIEST_WARLOCK_DEMONHUNTER",
				ExRT.isClassic and "_ROGUE_MAGE_DRUID" or "_ROGUE_DEATHKNIGHT_MAGE_DRUID",
				ExRT.isClassic and "_WARRIOR_HUNTER_SHAMAN" or "_WARRIOR_HUNTER_SHAMAN_MONK"
			},
		},
	}

	self.filterDropDown = ELib:DropDown(self,250,6):Point("TOPRIGHT",-10,-16-1):Size(150):SetText(L.InspectViewerFilter)
	self.filterDropDown:_Size(140,18)

	local EQUIPMENT_SETS_Fixed = EQUIPMENT_SETS or "EQUIPMENT SETS"
	if EQUIPMENT_SETS_Fixed:find(":") then
		EQUIPMENT_SETS_Fixed = EQUIPMENT_SETS_Fixed:gsub(":.+$","")
	else
		EQUIPMENT_SETS_Fixed = EQUIPMENT_SETS_Fixed:gsub("%%s","")
	end

	self.filterDropDown.List = {
		{text = L.InspectViewerClass, subMenu = {}},
		{text = L.InspectViewerType, subMenu = {}},
		{text = ROLE, subMenu = {}},
		{text = EQUIPMENT_SETS_Fixed, subMenu = {}},
		{text = L.InspectViewerHideInRaid,checkable = true, checkState = VMRT.InspectViewer.HideNotInRaid, checkFunc = function(self,checked) 
			VMRT.InspectViewer.HideNotInRaid = checked
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
		end, func = ItemsTrackDropDownClick},
		{text = L.InspectViewerClear,func = function (self)
			module.db.filter = nil
			module.db.filterType = nil
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilter)
		end},
	}
	for i=1,#dropDownTable[1][1] do
		self.filterDropDown.List[1].subMenu[i] = {text = L.classLocalizate[ dropDownTable[1][1][i] ],func = function (self,arg1)
			module.db.filter = arg1
			module.db.filterType = 1
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilterShort.. L.classLocalizate[ arg1 ] )
		end, arg1 = dropDownTable[1][1][i]}
	end
	for i=1,#dropDownTable[2][1] do
		self.filterDropDown.List[2].subMenu[i] = {text = dropDownTable[2][2][i],func = function (self,arg1,arg2)
			module.db.filter = arg1
			module.db.filterType = 2
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilterShort.. arg2 )
		end, arg1 = dropDownTable[2][1][i], arg2 = dropDownTable[2][2][i]}
	end
	for i=1,#dropDownTable[3][1] do
		self.filterDropDown.List[3].subMenu[i] = {text = dropDownTable[3][2][i],func = function (self,arg1,arg2)
			module.db.filter = arg1
			module.db.filterType = 3
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilterShort.. arg2 )
		end, arg1 = dropDownTable[3][1][i], arg2 = dropDownTable[3][2][i]}
	end
	for i=1,#dropDownTable[4][1] do
		local text = ""
		for className,_ in pairs(module.db.classIDs) do
			if dropDownTable[4][1][i]:find("_"..className) then
				text = text..(text ~= "" and ", " or "")..L.classLocalizate[ className ]
			end
		end
		self.filterDropDown.List[4].subMenu[i] = {text = text,func = function (self,arg1)
			module.db.filter = arg1
			module.db.filterType = 4
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
			module.options.filterDropDown:SetText(L.InspectViewerFilterShort.. text )
		end, arg1 = dropDownTable[4][1][i]}
	end

	module.db.achievementList = 1
	self.achievementsDropDown = ELib:DropDown(self,330,#module.db.achievementsList + 2):Point("TOPRIGHT",-10,-16-1):Size(249):SetText(ACHIEVEMENT_FILTER_TITLE)
	self.achievementsDropDown:_Size(140,18)
	self.achievementsDropDown:Hide()
	self.achievementsDropDown.List = {}
	for i=1,#module.db.achievementsList do
		self.achievementsDropDown.List[i] = {text = module.db.achievementsList[i][1],func = function (self)
			module.db.achievementList = i
			module.options.ScrollBar:SetValue(1)
			module.options.ReloadPage()
			ELib:DropDownClose()
		end}
	end
	self.achievementsDropDown.List[ #self.achievementsDropDown.List + 1 ] = {text = ENABLE,checkable = true, checkState = VMRT.InspectViewer.EnableA4ivs, checkFunc = function(self,checked) 
		VMRT.InspectViewer.EnableA4ivs = checked
	end, func = ItemsTrackDropDownClick}
	self.achievementsDropDown.List[ #self.achievementsDropDown.List + 1 ] = {text = L.minimapmenuclose,checkable = false,func = function()
		ELib:DropDownClose()
	end}

	if ExRT.isClassic then
		--self.tab.tabs[2].button:Hide()
		self.tab.tabs[3].button:Hide()
		self.tab.tabs[4].button:Hide()
		if self.tab.tabs[5] then self.tab.tabs[5].button:Hide() end
		self.chkItemsTrack:Hide()

		tremove(self.filterDropDown.List,3)
	end


	self.borderList = CreateFrame("Frame",nil,self)
	self.borderList:SetSize(698,module.db.perPage*30)
	self.borderList:SetPoint("TOP", 0, -40)
	ELib:Border(self.borderList,0)

	self.borderList:SetScript("OnMouseWheel",function (self,delta)
		if delta > 0 then
			module.options.ScrollBar.buttonUP:Click("LeftButton")
		else
			module.options.ScrollBar.buttonDown:Click("LeftButton")
		end
	end)

	self.ScrollBar = ELib:ScrollBar(self.borderList):Size(16,0):Point("TOPRIGHT",-3,-3):Point("BOTTOMRIGHT",-3,3):Range(1,20)

	local function IsItemHasNotGem(link)
		if link then
			local gem = link:match("item:%d+:[0-9%-]*:([0-9%-]*):")
			if gem == "0" or gem == "" then
				return true
			end
		end
	end

	local function IsArtifactItemHasNot3rdGem(link)
		if link then
			local gem1,gem2,gem3 = link:match("item:%d+:[0-9%-]*:([0-9%-]*):([0-9%-]*):([0-9%-]*):")
			if (gem1 == "" or gem2 == "" or gem3 == "") and not (gem1 == "" and gem2 == "" and gem3 == "") then
				return true
			end
		end
	end

	local function IsTopEnchAndGems(link)
		if link then
			local ench,gem = link:match("item:%d+:([0-9%-]*):([0-9%-]*):")
			if ench and gem then
				local isTop = true
				if ench ~= "0" and ench ~= "" then
					ench = tonumber(ench)
					if not module.db.topEnchGems[ench] then
						isTop = false
					end
				end
				if gem ~= "0" and gem ~= "" then
					gem = tonumber(gem)
					if not module.db.topEnchGems[gem] then
						isTop = false
					end
				end
				return isTop
			end
		end
	end

	local function IsValorUpgraded(link)
		if link then
			local isUpgraded = true

			local _,itemID,enchant,gem1,gem2,gem3,gem4,suffixID,uniqueID,level,specializationID,upgradeType,instanceDifficultyID,numBonusIDs,restLink = strsplit(":",link,15)

			if upgradeType == "4" and restLink then
				local upgradeID = select((tonumber(numBonusIDs or "0") or 0) + 1,strsplit(":",restLink))
				if upgradeID ~= "531" then -- 529 is 0/2, 530 is 1/2, 531 is 2/2
					isUpgraded = false
				end
			end
			return isUpgraded
		end
	end

	local RefreshArtifactCache = {}

	local function ReloadPage_CreateNowDB(db)
		for _, name in ExRT.F.IterateRoster do
			if name ~= "" and not ExRT.F.table_find(db,name,1) then
				db[#db + 1] = {name,nil,true,class = 100}
			end
		end
	end

	function module.options.ReloadPage()
		local nowDB = {}
		for name,data in pairs(module.db.inspectDB) do
			table.insert(nowDB,{name,data,class = data.classID or 100})
		end
		for name,_ in pairs(module.db.inspectQuery) do
			if not module.db.inspectDB[name] then
				table.insert(nowDB,{name,class = 100})
			end
		end
		ReloadPage_CreateNowDB(nowDB)

		table.sort(nowDB,function(a,b) if a.class == b.class then return a[1] < b[1] else return a.class < b.class end end)

		local scrollNow = ExRT.F.Round(module.options.ScrollBar:GetValue())
		local counter = 0
		for i=scrollNow,#nowDB do
			local data = nowDB[i][2]
			local isInRaid = (not VMRT.InspectViewer.HideNotInRaid) or (VMRT.InspectViewer.HideNotInRaid and data and UnitName( nowDB[i][1] ))
			if (not module.db.filter or (data and (
			  (module.db.filterType == 1 and module.db.filter == data.class) or 
			  (module.db.filterType == 2 and module.db.filter == module.db.armorType[ data.class or "?" ]) or 
			  (module.db.filterType == 3 and module.db.roleBySpec[ data.spec or 0 ] and module.db.filter:find( module.db.roleBySpec[ data.spec or 0 ] )) or
			  (module.db.filterType == 4 and module.db.filter:find( "_"..(data.class or "unknown") ))
			))) and isInRaid then
				counter = counter + 1

				local name = nowDB[i][1]
				local line = module.options.lines[counter]
				line.name:SetText(name)
				line.unit = name
				if data then
					local class = data.class
					local classIconCoords = CLASS_ICON_TCOORDS[class]
					if classIconCoords then
						line.class.texture:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
						line.class.texture:SetTexCoord(unpack(classIconCoords))
					else
						line.class.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
					end

					local spec = data.spec
					local specIcon = module.db.specIcons[spec]
					if not specIcon and VMRT and VMRT.ExCD2 and VMRT.ExCD2.gnGUIDs and VMRT.ExCD2.gnGUIDs[ name ] then
						spec = VMRT.ExCD2.gnGUIDs[ name ]
						specIcon = module.db.specIcons[spec]
					end

					if specIcon then
						line.spec.texture:SetTexture(specIcon)
						line.spec.id = spec
					elseif ExRT.isClassic then
						line.spec.texture:SetTexture("")
						line.spec.id = nil
					else
						line.spec.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
						line.spec.id = nil
					end
					line.spec:Show()

					local ilvl_def = format("%.2f",data.ilvl or 0)
					if type(data.corruption)=='number' and data.corruption >= 1 then
						local essenceResist = 0
						if data.essence then
							local ess_d
							for ess_c=1,#data.essence do
								ess_d = data.essence[ess_c]
								if ess_d.id == 33 or ess_d.id == 34 or ess_d.id == 35 or ess_d.id == 36 or ess_d.id == 37 or ess_d.id == 16 or ess_d.id == 24 then
									essenceResist = 10
									break
								end
							end
						end
						local corrLevel = math.max(data.corruption - (data.corruption_res or 0) - essenceResist,0)
						ilvl_def = format("%.2f",data.ilvl or 0).."|n".."|T3176469:16:16:0:0:256:128:11:51:24:64|t "..corrLevel
					end

					line.linkSpecID = spec
					line.linkClassID = module.db.classIDs[class or "?"]

					line.refreshArtifact:Hide()
					line.updateAP:Hide()
					line.refreshSoulbind:Hide()

					line.apinfo:SetText("")
					for _,item in pairs(line.items) do
						item:Hide()
						item.text:SetText("")
						item.text:Color()
						item.border:Hide()
						item.azerite = nil
						item.azeriteExtra = nil
						item.star:Hide()
						item.type_icon:Hide()
					end
					line.perksData = nil

					line.relic1:SetText("")
					line.relic2:SetText("")
					line.relic3:SetText("")

					line.time:Hide()
					line.time2:SetText("")

					line.otherInfo:Hide()
					line.otherInfoTooltipFrame:Hide()

					line.ilvl:SetText("")

					if module.db.page == 1 then
						line.ilvl:SetText(ilvl_def)

						local items = data.items
						local items_ilvl = data.items_ilvl
						if items then
							for j=1,#module.db.itemsSlotTable do
								local icon = line.items[j]
								local slotID = module.db.itemsSlotTable[j]
								local item = items[slotID]
								if item then
									local itemID,enchantID = string.match(item,"item:(%d+):(%d+):")
									itemID = itemID and tonumber(itemID) or 0
									enchantID = enchantID and tonumber(enchantID) or 0

									local _,_,itemQuality,itemLevel,_,_,_,_,_,itemTexture = GetItemInfo(item)
									if not itemTexture then
										local _,_,_,_,t = GetItemInfoInstant(item)
										itemTexture = t
									end
									icon.texture:SetTexture(itemTexture)
									icon.link = item
									local itemColor = select(4,GetItemQualityColor(itemQuality or 1))
									if itemQuality == 6 then
										itemLevel = items_ilvl[slotID]
										if slotID == 16 or slotID == 17 then
											itemLevel = max(items_ilvl[16] or 0,items_ilvl[17] or 0)
										end
									end
									itemLevel = items_ilvl[slotID] or itemLevel
									icon.text:SetText("|c"..(itemColor or "ffffffff")..(itemLevel or ""))

									if not ExRT.isClassic and (
										(enchantID == 0 and ((slotID == 2 and IS_LOW) or (slotID == 15 and IS_LOW) or slotID == 11 or slotID == 12 or (slotID == 16) or (slotID == 17 and module.db.specHasOffhand[spec or 0]) or (slotID == 15 and IS_SL) or (slotID == 8 and module:GetSpecMainStat(spec)=="agi" and IS_SL) or (slotID == 9 and module:GetSpecMainStat(spec)=="int" and IS_SL) or (slotID == 10 and module:GetSpecMainStat(spec)=="str" and IS_SL) or (slotID == 5 and IS_SL)) and module.db.colorizeNoEnch) or
										(items_ilvl[slotID] and items_ilvl[slotID] > 0 and items_ilvl[slotID] < colorizeLowIlvl630 and module.db.colorizeLowIlvl) or
										(module.db.colorizeNoGems and ExRT.F.IsBonusOnItem(item,module.db.socketsBonusIDs) and IsItemHasNotGem(item)) or 
										(module.db.colorizeNoGems and (slotID == 16 or slotID == 17) and itemQuality == 6 and IsArtifactItemHasNot3rdGem(item)) or 
										(module.db.colorizeNoTopEnchGems and not IsTopEnchAndGems(item) and ((slotID == 2 and IS_LOW) or (slotID == 15 and IS_LOW) or slotID == 11 or slotID == 12 or (slotID == 16) or (slotID == 17 and module.db.specHasOffhand[spec or 0]) or (slotID == 15 and IS_SL) or (slotID == 8 and module:GetSpecMainStat(spec)=="agi" and IS_SL) or (slotID == 9 and module:GetSpecMainStat(spec)=="int" and IS_SL) or (slotID == 10 and module:GetSpecMainStat(spec)=="str" and IS_SL) or (slotID == 5 and IS_SL))) or
										(items_ilvl[slotID] and items_ilvl[slotID] > 0 and items_ilvl[slotID] < colorizeLowIlvl685 and module.db.colorizeLowIlvl685)
									) then
										icon.border:Show()
									end

									icon:Show()
								end
							end
						end
					elseif module.db.page == 2 and ExRT.isClassic then
						local data = VMRT.Inspect and VMRT.Inspect.TalentsClassic and VMRT.Inspect.TalentsClassic[name]

						line.spec:Hide()
						line.refreshSoulbind:Show()

						if data then
							local it = -1

							local timeUpdate,tree = strsplit(":",data,2)

							--line.time2:SetText(date("%d/%m/%Y\n%H:%M:%S",tonumber(timeUpdate),nil))

							while tree do
								local spellID,spellRanks,on = strsplit(":",tree,3)
								tree = on

								spellID = tonumber(spellID)
								if spellID and spellID ~= 0 then
									local rankSelected = spellRanks:sub(1,1)
									local rankMax = spellRanks:sub(2,2)

									local icon = line.items[it]
									if not icon then
										break
									end

									local texture = select(3,GetSpellInfo(spellID))

									icon.texture:SetTexture(texture)
									icon.link = "spell:"..spellID
									icon.sid = nil
									icon.text:SetText((rankSelected == rankMax and "|cff00ff00" or "")..rankSelected.."/"..rankMax)
									icon:Show()

									it = it + 1
								end
							end
						elseif parentModule.db.TalentNoAddon then
							local now = GetTime()
							local prev = parentModule.db.TalentNoAddon[name]
							if prev and now - prev > 1.5 then
								line.otherInfo:SetText(L.InspectViewerNoExRTAddon)
								line.otherInfo:Show()
							end
						end
					elseif module.db.page == 2 then
						line.ilvl:SetText(ilvl_def)

						for j=1,7 do
							local t = data[j]
							local icon = line.items[j]
							if t and t ~= 0 then
								if t < 10 then
									t = (j-1)*3+t
									local _,_,spellTexture = GetTalentInfoByID( data.talentsIDs[j] )
									icon.texture:SetTexture(spellTexture)
									icon.link = GetTalentLink( data.talentsIDs[j] )
								else
									local _,_,spellTexture = GetSpellInfo(t)
									icon.texture:SetTexture(spellTexture)
									icon.link = GetSpellLink(t)
								end
								icon.sid = nil
								icon:Show()
							end
						end

						for j=9,14 do
							local t = data[module.db.glyphsIDs[j-8]]
							local icon = line.items[j]
							if t then
								local _,_,spellTexture = GetPvpTalentInfoByID( data.talentsIDs[ j - 1 ] )
								icon.texture:SetTexture(spellTexture)
								icon.link = GetPvpTalentLink( data.talentsIDs[ j - 1 ] )
								icon.sid = nil
								icon:Show()
							end
						end
					elseif module.db.page == 3 then
						line.ilvl:SetText(ilvl_def)

						line.time:Show()
						line.time:SetText(date("%H:%M:%S",data.time))

						local result = ""
						for k,statName in ipairs(module.db.statsList) do
							local statValue = data[statName]
							if statValue and statValue >= 10 then
								if module.db.baseStats[statName] then
									local classCount = module.db.classIDs[class]
									if classCount then
										statValue = statValue + module.db.baseStats[statName][classCount]
										local raceCount = ExRT.F.table_find(module.db.raceList,data.race)
										if raceCount then
											statValue = statValue + ceil(module.db.raceStatsDiffs[statName][raceCount]/2)
										end
									end
								end
								if k <= 3 then
									statValue = statValue * 1.05
								end
								result = result .. module.db.statsListName[k] .. ": " ..floor(statValue)..", "
							end

						end
						result = result:gsub(", $","")

						line.otherInfo:SetText(result)
						line.otherInfo:Show()
						line.otherInfoTooltipFrame:Show()
					elseif module.db.page == 4 then
						local a4ivsData = module.db.inspectDBAch[name]
						if a4ivsData then
							line.ilvl:SetText(a4ivsData.points or 0)
							for j=1,18 do
								local icon = line.items[j]
								local id = module.db.achievementsList[ module.db.achievementList ][j + 1]
								if id then
									local _,acivName,_,_,_,_,_,_,_,texture = GetAchievementInfo(id)
									local link,completed
									if a4ivsData[id] then
										local c_count = GetAchievementNumCriteria(id)
										local criteria = (2 ^ c_count) - 1
										link = format("|cffffff00|Hachievement:%d:%s:1:%s:%d:%d:%d:%d\124h[%s]|h|r",id,a4ivsData.guid,a4ivsData[id],criteria,criteria,criteria,criteria,acivName or "")
										completed = true
									else
										link = format("|cffffff00|Hachievement:%d:%s:0:0:0:-1:0:0:0:0\124h[%s]|h|r",id,a4ivsData.guid,acivName or "")
									end

									local statisticList = module.db.achievementsList_statistic[ module.db.achievementList ][j]
									if statisticList and statisticList ~= 0 then
										local additional = {}
										for k=1,#statisticList do
											local statisticID = statisticList[k]
											if statisticID ~= 0 then
												local _,statisticName = GetAchievementInfo(statisticID)
												additional[#additional + 1] = (statisticName or "?")..": |cffffffff"..( a4ivsData[ statisticID ] or 0 ).."|r"
											else
												additional[#additional + 1] = " "
											end
										end
										icon.additional = additional
									else
										icon.additional = nil
									end

									icon.texture:SetTexture(texture)
									icon.link = link
									if not completed then
										icon.border:Show()
									end

									icon:Show()
								end
							end
						else
							line.otherInfo:SetText(L.BossWatcherDamageSwitchTabInfoNoInfo)
							line.otherInfo:Show()
						end
					elseif module.db.page == 5 then
						local it = -2

						local db = data.essence
						if db then
							if #db > 0 then
								it = it + 1
							end
							for j=1,#db do
								local power = db[j]

								local icon = line.items[it]
								if not icon then
									break
								end

								icon.texture:SetTexture(power.icon)
								icon.link = "spell:"..power.spellID
								icon.sid = nil
								local tier = power.link:gsub("%[.-%]","T"..power.tier..(power.isMajor and "+" or ""))
								icon.text:SetText(tier or "")
								if power.isMajor then
									icon.star:Show()
								end
								icon:Show()

								it = it + 1
							end
						end

						local db = data.azerite
						if db then
							local lastItem = 0
							for j=1,#db do
								local power = db[j]
								if lastItem ~= power.item then
									it = it + 1
									lastItem = power.item
								end

								local icon = line.items[it]
								if not icon then
									break
								end

								icon.texture:SetTexture(power.icon)
								icon.link = "spell:"..power.spellID
								icon.sid = nil
								local ilvl = select(4,GetItemInfo(power.itemLink))
								icon.text:SetText(ilvl or "")
								icon:Show()

								icon.azerite = power
								icon.azeriteExtra = {}

								for k=1,20 do
									local p = data.azerite["i"..k]
									if p then
										for l=1,#p do
											if p[l].itemLink == power.itemLink and p[l].tier == power.tier then
												icon.azeriteExtra[#icon.azeriteExtra + 1] = p[l]
											end
										end
									end
								end

								it = it + 1
							end
						end
					elseif module.db.page == 6 then
						for j=1,3 do
							local relicLink = data.items['relic'..j]
							if relicLink then
								local icon = line.items[j*5]
								local _,_,_,ilvl,_,_,_,_,_,itemTexture = GetItemInfo(relicLink)
								if not itemTexture then
									local _,_,_,_,t = GetItemInfoInstant(relicLink)
									itemTexture = t
								end
								icon.text:SetText(ilvl or "")
								icon.texture:SetTexture(itemTexture or "")
								icon.link = relicLink
								icon:Show()

								local relicType = ScanRelicType(relicLink)
								if relicType then
									if type(relicType) == 'number' then
										relicType = module.db.relicLocalizated[relicType] or ""
									end
									line["relic"..j]:SetText(relicType)
								else
									line["relic"..j]:SetText("")
								end
							end
						end

						local weaponIlvl = 0
						local items_ilvl = data.items_ilvl
						if items_ilvl then
							for slotID=16,17 do
								weaponIlvl = max(weaponIlvl,items_ilvl[slotID] or 0)
							end
						end
						if weaponIlvl > 0 then
							line.ilvl:SetFormattedText("|cffe5cc7f%d",weaponIlvl)
						end
					elseif module.db.page == 7 then
						local data = VMRT.Inspect and VMRT.Inspect.Soulbinds and VMRT.Inspect.Soulbinds[name]
						local data2 = VMRT.Inspect and VMRT.Inspect.Soulbinds and VMRT.Inspect.Soulbinds[name.."-"..ExRT.SDB.realmKey]
						if not data then
							data = data2
						elseif data2 and tonumber(strsplit(":",data2),10) > tonumber(strsplit(":",data),10) then
							data = data2
						end

						line.refreshSoulbind:Show()

						line.time2:SetText("")

						if data then
							local it = 2

							local timeUpdate,covenantID,soulbindID,tree = strsplit(":",data,4)

							line.time2:SetText(date("%d/%m/%Y\n%H:%M:%S",tonumber(timeUpdate),nil))

							do
								local icon = line.items[it]
								if not icon then
									break
								end

								local texture = covenantID == "1" and "shadowlands-landingbutton-kyrian-up" or
										covenantID == "2" and "shadowlands-landingbutton-venthyr-up" or
										covenantID == "3" and "shadowlands-landingbutton-NightFae-up" or
										covenantID == "4" and "shadowlands-landingbutton-necrolord-up"

								icon.texture:SetAtlas(texture)
								icon.link = nil
								icon.sid = nil
								icon:Show()

								it = it + 2
							end

							while tree do
								local powerStr,on = strsplit(":",tree,2)
								tree = on

								local spellID = tonumber(powerStr)
								if spellID then
									if spellID ~= 0 then
										local icon = line.items[it]
										if not icon then
											break
										end

										local texture = select(3,GetSpellInfo(spellID))

										icon.texture:SetTexture(texture)
										icon.link = "spell:"..spellID
										icon.sid = nil
										icon:Show()

										it = it + 1
									end
								else
									local conduitID,conduitRank,conduitType = strsplit("-",powerStr,3)

									if conduitID and conduitRank then
										conduitID = tonumber(conduitID) or 0
										conduitRank = tonumber(conduitRank) or 0
										spellID = C_Soulbinds.GetConduitSpellID(conduitID,conduitRank)

										local icon = line.items[it]
										if not icon then
											break
										end

										local texture = select(3,GetSpellInfo(spellID))

										icon.texture:SetTexture(texture)
										--icon.link = "spell:"..spellID
										icon.link = C_Soulbinds.GetConduitHyperlink(conduitID, conduitRank)
										if icon.link == "" or not icon.link then
											icon.link = "spell:"..spellID
										end
										icon.sid = nil
										icon.text:SetText(conduitRank)
										icon:Show()

										if conduitType then
											local atlas
											conduitType = tonumber(conduitType)
											if conduitType == Enum.SoulbindConduitType.Potency then
												atlas = "Soulbinds_Tree_Conduit_Icon_Attack"
											elseif conduitType == Enum.SoulbindConduitType.Endurance then
												atlas = "Soulbinds_Tree_Conduit_Icon_Protect"
											elseif conduitType == Enum.SoulbindConduitType.Finesse then
												atlas = "Soulbinds_Tree_Conduit_Icon_Utility"
											end

											if atlas then
												icon.type_icon:SetAtlas(atlas)
												icon.type_icon:Show()
											end
										end

										it = it + 1
									end
								end
							end
						end
					end

					local cR,cG,cB = ExRT.F.classColorNum(class)
					if name and UnitName(name) then
						line.back:SetGradientAlpha("HORIZONTAL", cR,cG,cB, 0.5, cR,cG,cB, 0)
					else
						line.back:SetGradientAlpha("HORIZONTAL", cR,cG,cB, 0, cR,cG,cB, 0.5)
					end
				else
					for j=-1,18 do
						line.items[j]:Hide()
					end
					line.time:Show()
					line.time:SetText(L.InspectViewerNoData)
					line.time2:SetText("")

					line.otherInfo:Hide()
					line.otherInfoTooltipFrame:Hide()

					line.class.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
					line.class.texture:SetTexCoord(0,1,0,1)
					line.spec.texture:SetTexture("Interface\\Icons\\INV_MISC_QUESTIONMARK")
					line.spec.id = nil
					line.spec:Show()
					line.ilvl:SetText("")

					line.relic1:SetText("")
					line.relic2:SetText("")
					line.relic3:SetText("")

					line.updateAP:Hide()

					line.refreshArtifact:Hide()

					line.apinfo:SetText("")

					line.back:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 0.5, 0, 0, 0, 0)

					line.perksData = nil
				end

				if (nowDB[i][3] or not parentModule.db.inspectQuery[ name ]) and module.db.page < (ExRT.isClassic and 2 or 3) then
					line.updateButton:Show()
				else
					line.updateButton:Hide()
				end

				line:Show()
				if counter >= module.db.perPage then
					break
				end
			end
		end
		for i=(counter+1),module.db.perPage do
			module.options.lines[i]:Hide()
		end

		if not module.options.ScrollBar.ignore then
			module.options.ScrollBar:SetMinMaxValues(1,max(#nowDB-module.db.perPage+1,1),nil,true):UpdateButtons()
		end
		module.options.RaidIlvl()
	end
	local ScrollBar_PrevScroll = nil
	self.ScrollBar:SetScript("OnValueChanged", function(self)
		local scrollNow = ExRT.F.Round(self:GetValue())
		if scrollNow ~= ScrollBar_PrevScroll then
			ScrollBar_PrevScroll = scrollNow
			module.options.ReloadPage()
		end
	end)

	local function NoIlvl()
		self.raidItemLevel:SetText("")
	end

	function module.options.RaidIlvl()
		local gMax = ExRT.F.GetRaidDiffMaxGroup()
		local ilvl = 0
		local countPeople = 0

		for _, name, subgroup in ExRT.F.IterateRoster do
			if subgroup <= gMax and module.db.inspectDB[name] and module.db.inspectDB[name].ilvl and module.db.inspectDB[name].ilvl >= 1 then
				countPeople = countPeople + 1
				ilvl = ilvl + module.db.inspectDB[name].ilvl
			end
		end

		if countPeople == 0 then
			NoIlvl()
			return
		end
		ilvl = ilvl / countPeople
		self.raidItemLevel:SetText(L.InspectViewerRaidIlvl..": "..format("%.02f",ilvl).." ("..format(L.InspectViewerRaidIlvlData,countPeople)..")")
	end

	local function otherInfoHover(self)
		local parent = self:GetParent()
		if not parent.otherInfo:IsShown() then
			return
		end
		if parent.otherInfo:IsTruncated() then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetText(parent.otherInfo:GetText(),nil, nil, nil, nil,true)
			GameTooltip:Show()
		end
	end

	local extraIconsDropdown = {}
	local function SetExtraIcon(i,db)
		if not extraIconsDropdown[i] then
			local item = ELib:Icon(self,nil,21,true)
			extraIconsDropdown[i] = item
			if i > 1 then
				item:Point("TOP",extraIconsDropdown[i-1],"BOTTOM")
			end
			item.texture:SetTexCoord(.1,.9,.1,.9)
			item:SetFrameStrata("TOOLTIP")
			item:SetScript("OnEnter",function(self) 
				GameTooltip:SetOwner(self, "ANCHOR_LEFT")
				GameTooltip:SetAzeritePower(tonumber(self.azerite.itemID), select(4,GetItemInfo(self.azerite.itemLink)), self.azerite.id, self.azerite.itemLink)
				GameTooltip:Show()
			end)
			item:SetScript("OnLeave",function() ELib.Tooltip:Hide() ELib.Tooltip:HideAdd() end)
			item:SetScript("OnUpdate",function(self)
				for j=1,#extraIconsDropdown do
					if extraIconsDropdown[j]:IsVisible() and MouseIsOver(extraIconsDropdown[j]) then
						return
					end
				end
				if extraIconsDropdown[1] and extraIconsDropdown[1].main and MouseIsOver(extraIconsDropdown[1].main) then
					return
				end
				self:Hide()
				extraIconsDropdown.bl:Hide()
				extraIconsDropdown.br:Hide()
				extraIconsDropdown.bb:Hide()
			end)
		end
		if not extraIconsDropdown.bl then
			local bl = CreateFrame("Frame",nil,self)
			extraIconsDropdown.bl = bl
			bl.t = bl:CreateTexture(nil,"BORDER")
			bl.t:SetAllPoints()
			bl.t:SetColorTexture(0,0,0,1)
			bl:SetPoint("TOPLEFT",extraIconsDropdown[1],-2,0)

			local br = CreateFrame("Frame",nil,self)
			extraIconsDropdown.br = br
			br.t = br:CreateTexture(nil,"BORDER")
			br.t:SetAllPoints()
			br.t:SetColorTexture(0,0,0,1)
			br:SetPoint("TOPLEFT",extraIconsDropdown[1],"TOPRIGHT",0,0)

			local bb = CreateFrame("Frame",nil,self)
			extraIconsDropdown.bb = bb
			bb.t = bb:CreateTexture(nil,"BORDER")
			bb.t:SetAllPoints()
			bb.t:SetColorTexture(0,0,0,1)
			bb:SetPoint("TOPLEFT",bl,"BOTTOMRIGHT",0,2)
			bb:SetPoint("BOTTOMRIGHT",br,"BOTTOMLEFT",0,0)

			bl:SetFrameStrata("DIALOG")
			br:SetFrameStrata("DIALOG")
			bb:SetFrameStrata("DIALOG")
		end
		extraIconsDropdown[i].texture:SetTexture(db.icon)
		extraIconsDropdown[i].azerite = db
		extraIconsDropdown[i]:Show()

		extraIconsDropdown.bl:SetPoint("BOTTOMRIGHT",extraIconsDropdown[i],"BOTTOMLEFT",0,-2)
		extraIconsDropdown.br:SetPoint("BOTTOMRIGHT",extraIconsDropdown[i],"BOTTOMRIGHT",2,-2)

		extraIconsDropdown.bl:Show()
		extraIconsDropdown.br:Show()
		extraIconsDropdown.bb:Show()
	end

	local function Lines_SpecIcon_OnEnter(self)
		if self.id then
			local _,name,descr = GetSpecializationInfoByID(self.id)
			ELib.Tooltip.Show(self,"ANCHOR_LEFT",name,{descr,1,1,1,true})
		end
	end
	local function Lines_ItemIcon_OnEnter(self)
		if self.azerite then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:SetAzeritePower(tonumber(self.azerite.itemID), select(4,GetItemInfo(self.azerite.itemLink)), self.azerite.id, self.azerite.itemLink)
			GameTooltip:Show()
			if self.azeriteExtra then
				for i=1,#self.azeriteExtra do
					SetExtraIcon(i,self.azeriteExtra[i])
				end
				if #self.azeriteExtra > 0 then
					extraIconsDropdown[1]:ClearAllPoints()
					extraIconsDropdown[1]:SetPoint("TOP",self,"BOTTOM")
					extraIconsDropdown[1].main = self
					extraIconsDropdown[1]:Show()
				end
			end
		elseif self.link then
			local classID = self:GetParent().linkClassID
			local specID = self:GetParent().linkSpecID
			ELib.Tooltip.Link(self,self.link,classID,specID)
			if module.db.page == 4 and self.additional then
				ELib.Tooltip:Add(nil,self.additional,false,true)
			end
		end
	end
	local function Lines_ItemIcon_OnLeave(self)
		ELib.Tooltip:Hide()
		ELib.Tooltip:HideAdd()
	end
	local function Lines_ItemIcon_OnClick(self)
		if self.link then
			if module.db.page == 1 then
				ExRT.F.LinkItem(nil, self.link)
			elseif module.db.page == 2 then
				if self.sid then
					ExRT.F.LinkSpell(self.sid)
				else
					ExRT.F.LinkSpell(nil,self.link)
				end
			elseif module.db.page == 4 then
				if ChatEdit_GetActiveWindow() then
					ChatEdit_InsertLink(self.link)
				else
					ChatFrame_OpenChat(self.link)
				end
			end
		end
	end
	local function Lines_UpdateButton_OnEnter(self)
		self.texture:SetVertexColor(0.9,0.75,0,1)
	end
	local function Lines_UpdateButton_OnLeave(self)
		self.texture:SetVertexColor(1,1,1,0.7)
	end
	local function Lines_UpdateButton_OnClick(self)
		local unit = self:GetParent().unit
		if unit then
			parentModule:AddToQueue(unit)
			module.options:showPage()
		end
	end

	local function Lines_RefreshArtifactButton_OnClick(self)
		local unit = self:GetParent().unit
		if unit then
			--parentModule:ArtifactAddToQueue(unit)
			self:Hide()
			C_Timer.NewTimer(1.5,function()
				module.options:showPage()
			end)
			RefreshArtifactCache[ unit ] = true
		end
	end

	local function Lines_UpdateSoulbindButton_OnClick(self)
		local t = GetTime()
		if self.prev and (t - self.prev < 5) then
			return
		end
		self.prev = t
		local unit = self:GetParent().unit
		if unit then
			if ExRT.isClassic then
				parentModule:TalentClassicReq(unit)
			else
				parentModule:SoulbindReq(unit)
			end
			self:SetAlpha(0)
			C_Timer.NewTimer(2,function()
				self:SetAlpha(1)
				module.options:showPage()
			end)
		end	  
	end

	local function Line_OnEnter(self)

	end
	local function Line_OnLeave()

	end

	self.lines = {}
	for i=1,module.db.perPage do
		local line = CreateFrame("Frame",nil,self.borderList)
		self.lines[i] = line
		line:SetSize(678,30)
		line:SetPoint("TOPLEFT",0,-(i-1)*30)

		line.name = ELib:Text(line,"Name",11):Color():Point(15,0):Size(109,30):Shadow()

		line.class = ELib:Icon(line,nil,24):Point(125,-3)

		line.spec = ELib:Icon(line,nil,24):Point("LEFT",line.class,30,0)
		line.spec:SetScript("OnEnter",Lines_SpecIcon_OnEnter)
		line.spec:SetScript("OnLeave",GameTooltip_Hide)

		line.apinfo = ELib:Text(line,"",9):Color():Point("LEFT",125,0):Shadow()

		line.ilvl = ELib:Text(line,"630.52",11):Color():Point(180,0):Size(50,30):Shadow():Center()

		line.items = {}
		for j=-1,18 do
			local item = ELib:Icon(line,nil,21,true):Point("LEFT",235+(24*(j-1)),0)
			line.items[j] = item
			item:SetScript("OnEnter",Lines_ItemIcon_OnEnter)
			item:SetScript("OnLeave",Lines_ItemIcon_OnLeave)
			item:SetScript("OnClick",Lines_ItemIcon_OnClick)

			item.text = ELib:Text(item,"",8):Color():Point("BOTTOMRIGHT",2,0):Outline()

			item.texture:SetTexCoord(.1,.9,.1,.9)

			item.border = CreateFrame("Frame",nil,item)
			item.border:SetPoint("TOPLEFT")
			item.border:SetPoint("BOTTOMRIGHT")

			ELib:Border(item.border,1,.12,.13,.15,1)

			item.border.background = item.border:CreateTexture(nil,"OVERLAY")
			item.border.background:SetPoint("TOPLEFT")
			item.border.background:SetPoint("BOTTOMRIGHT")

			item.star = item:CreateTexture(nil,"ARTWORK")
			item.star:SetPoint("CENTER",item,"TOPLEFT",2,-2)
			item.star:SetSize(18,18)
			item.star:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\star")
			item.star:Hide()

			item.type_icon = item:CreateTexture(nil,"ARTWORK")
			item.type_icon:SetPoint("CENTER",item,"TOPLEFT",2,-2)
			item.type_icon:SetSize(18,18)
			item.type_icon:Hide()

			item.border:Hide()
			item:Hide()
		end

		line.relic1 = ELib:Text(line,"",11):Color():Point("RIGHT",line.items[5],"LEFT",-2,0):Size(0,30):Outline()
		line.relic2 = ELib:Text(line,"",11):Color():Point("RIGHT",line.items[10],"LEFT",-2,0):Size(0,30):Outline()
		line.relic3 = ELib:Text(line,"",11):Color():Point("RIGHT",line.items[15],"LEFT",-2,0):Size(0,30):Outline()

		line.updateButton = ELib:Icon(line,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128",18,true):Point("RIGHT",-10,0)
		line.updateButton.texture:SetTexCoord(0.125,0.1875,0.5,0.625)
		line.updateButton.texture:SetVertexColor(1,1,1,0.7)
		line.updateButton:SetScript("OnEnter",Lines_UpdateButton_OnEnter)
		line.updateButton:SetScript("OnLeave",Lines_UpdateButton_OnLeave)
		line.updateButton:SetScript("OnClick",Lines_UpdateButton_OnClick)
		line.updateButton:Hide()

		line.updateAP = ELib:Icon(line,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128",18,true):Point("RIGHT",line.items[0],"LEFT",-2,0)
		line.updateAP.texture:SetTexCoord(0.125,0.1875,0.5,0.625)
		line.updateAP.texture:SetVertexColor(1,1,1,0.7)
		line.updateAP:SetScript("OnEnter",Lines_UpdateButton_OnEnter)
		line.updateAP:SetScript("OnLeave",Lines_UpdateButton_OnLeave)
		line.updateAP:SetScript("OnClick",Lines_RefreshArtifactButton_OnClick)
		line.updateAP:Hide()

		line.time = ELib:Text(line,date("%H:%M:%S",time()),11):Color():Point(230,0):Size(80,30):Shadow():Center()
		line.otherInfo = ELib:Text(line,"",10):Color():Point(310,0):Size(335,30):Shadow()

		line.time2 = ELib:Text(line,"",10):Color():Point(180,0):Size(80,30):Shadow():Center()

		line.otherInfoTooltipFrame = CreateFrame("Frame",nil,line)
		line.otherInfoTooltipFrame:SetAllPoints(line.otherInfo)
		line.otherInfoTooltipFrame:SetScript("OnEnter",otherInfoHover)
		line.otherInfoTooltipFrame:SetScript("OnLeave",GameTooltip_Hide)

		line.back = line:CreateTexture(nil, "BACKGROUND", nil, -3)
		line.back:SetPoint("TOPLEFT",0,0)
		line.back:SetPoint("BOTTOMRIGHT",0,0)
		line.back:SetColorTexture(1, 1, 1, 1)
		line.back:SetGradientAlpha("HORIZONTAL", 0, 0, 0, 1, 0, 0, 0, 0)

		line.refreshArtifact = ELib:Button(line,REFRESH):Point("LEFT",245,0):Size(100,20):OnClick(Lines_RefreshArtifactButton_OnClick)
		line.refreshArtifact:Hide()

		line.refreshSoulbind = ELib:Icon(line,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128",18,true):Point(235+(24*16)+4,-8)
		line.refreshSoulbind.texture:SetTexCoord(0.125,0.1875,0.5,0.625)
		line.refreshSoulbind.texture:SetVertexColor(1,1,1,0.7)
		line.refreshSoulbind:SetScript("OnEnter",Lines_UpdateButton_OnEnter)
		line.refreshSoulbind:SetScript("OnLeave",Lines_UpdateButton_OnLeave)
		line.refreshSoulbind:SetScript("OnClick",Lines_UpdateSoulbindButton_OnClick)
		line.refreshSoulbind:Hide()
		if ExRT.isClassic then
			line.refreshSoulbind:NewPoint("LEFT",160,0)
		end

		line:SetScript("OnEnter",Line_OnEnter)
		line:SetScript("OnLeave",Line_OnLeave)
	end
	self.raidItemLevel = ELib:Text(self,"",12):Size(500,20):Point("TOPLEFT",self.borderList,"BOTTOMLEFT",3,-2):Shadow():Color()

	local animationTimer = 0
	self:SetScript("OnUpdate",function (self, elapsed)
		animationTimer = animationTimer + elapsed
		local color = animationTimer
		if color > 1 then
			color = 2 - color
		end
		if color < 0 then
			color = 0
		end
		local colorR = color / 1.5
		for i=1,module.db.perPage do
			for j,item in pairs(self.lines[i].items) do
				local frame = item.border
				if frame:IsVisible() then
					frame.background:SetColorTexture(1,color,color,.4)

					frame.border_top:SetColorTexture(.7,colorR,colorR,1)
					frame.border_bottom:SetColorTexture(.7,colorR,colorR,1)
					frame.border_left:SetColorTexture(.7,colorR,colorR,1)
					frame.border_right:SetColorTexture(.7,colorR,colorR,1)
				end
			end
		end
		if animationTimer > 2 then
			animationTimer = animationTimer % 2
		end
	end)


	self.moreInfoButton = ELib:Button(self,L.InspectViewerMoreInfo):Size(150,20):Point("TOPRIGHT",self.borderList,"BOTTOMRIGHT",-1,1):OnClick(function() module.options.moreInfoWindow:Show() end)

	self.moreInfoWindow = ELib:Popup(L.InspectViewerMoreInfo):Size(250,170)
	self.moreInfoWindow:SetScript("OnShow",function (self)
		local armorCloth,armorLeather,armorMail,armorPlate = 0,0,0,0
		local roleTank,roleMDD,roleRDD,roleHealer = 0,0,0,0

		local gMax = ExRT.F.GetRaidDiffMaxGroup()
		local ilvl = 0
		local countPeople = 0

		for _, name, subgroup in ExRT.F.IterateRoster do
			if subgroup <= gMax then
				local data = module.db.inspectDB[name]
				if data then
					countPeople = countPeople + 1
					if data.class then
						if module.db.armorType[data.class] == "CLOTH" then
							armorCloth = armorCloth + 1
						elseif module.db.armorType[data.class] == "LEATHER" then
							armorLeather = armorLeather + 1
						elseif module.db.armorType[data.class] == "MAIL" then
							armorMail = armorMail + 1
						elseif module.db.armorType[data.class] == "PLATE" then
							armorPlate = armorPlate + 1
						end
					end
					if data.spec then
						if module.db.roleBySpec[data.spec] == "TANK" then
							roleTank = roleTank + 1
						elseif module.db.roleBySpec[data.spec] == "MELEE" then
							roleMDD = roleMDD + 1
						elseif module.db.roleBySpec[data.spec] == "RANGE" then
							roleRDD = roleRDD + 1
						elseif module.db.roleBySpec[data.spec] == "HEAL" then
							roleHealer = roleHealer + 1
						end
					end
				end
			end
		end

		self.textData:SetText(
			L.InspectViewerMoreInfoRaidSetup..format(" ("..L.InspectViewerRaidIlvlData.."):",countPeople).."\n"..
			L.InspectViewerType..":\n"..
			"   "..L.InspectViewerTypeCloth..": "..armorCloth.."\n"..
			"   "..L.InspectViewerTypeLeather..": "..armorLeather.."\n"..
			"   "..L.InspectViewerTypeMail..": "..armorMail.."\n"..
			"   "..L.InspectViewerTypePlate..": "..armorPlate.."\n"..
			L.InspectViewerMoreInfoRole..":\n"..
			"   "..L.InspectViewerMoreInfoRoleTank..": "..roleTank.."\n"..
			"   "..L.InspectViewerMoreInfoRoleMDD..": "..roleMDD.."\n"..
			"   "..L.InspectViewerMoreInfoRoleRDD..": "..roleRDD.."\n"..
			"   "..L.InspectViewerMoreInfoRoleHealer..": "..roleHealer
		)
	end)
	self.moreInfoWindow.textData  = ELib:Text(self.moreInfoWindow,"",11):Size(225,180):Point("TOP",0,-32):Top():Color()

	self.buttonForce = ELib:Button(self,L.InspectViewerForce):Size(90,20):Point("RIGHT",self.moreInfoButton,"LEFT",-5,0):OnClick(function(self) 
		parentModule:Force() 
		self:SetEnabled(false)
	end)

	function module.options.showPage()
		local count = 0
		local nowDB = {}
		for name,data in pairs(module.db.inspectDB) do
			table.insert(nowDB,{name,data})
		end
		for name,_ in pairs(module.db.inspectQuery) do
			if not module.db.inspectDB[name] then
				table.insert(nowDB,{name})
			end
		end
		ReloadPage_CreateNowDB(nowDB)
		count = #nowDB

		local val = self.ScrollBar:GetValue()
		local newMax = max(count-module.db.perPage+1,1)
		self.ScrollBar:SetMinMaxValues(1,newMax)
		if val > newMax then
			val = newMax
		end
		self.ScrollBar.ignore = true
		self.ScrollBar:SetValue(val)
		self.ScrollBar.ignore = nil

		module.options.ReloadPage()

		module.options.RaidIlvl()
	end
	function self.UpdatePage_InspectEvent()
		if not module.options:IsShown() then
			return
		end
		module.options:showPage()
		ExRT.F.ScheduleTimer(module.options.showPage, 4)
	end

	function self:OnShow()
		self:showPage()
	end
	module:RegisterEvents("INSPECT_READY")
end

function ExRT.F:RaidItemLevel()
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	local ilvl = 0
	local countPeople = 0

	for _, name, subgroup in ExRT.F.IterateRoster do
		if subgroup <= gMax and module.db.inspectDB[name] and module.db.inspectDB[name].ilvl and module.db.inspectDB[name].ilvl >= 1 then
			countPeople = countPeople + 1
			ilvl = ilvl + module.db.inspectDB[name].ilvl
		end
	end

	if countPeople == 0 then
		return 0
	end
	return ilvl / countPeople
end

function module:slash(arg)
	if arg == "raid" then
		ExRT.Options:Open(module.options)
	end
end

