local GlobalAddonName, ExRT = ...

local GetTime, IsEncounterInProgress, RAID_CLASS_COLORS, GetInstanceInfo, GetSpellCharges, SecondsToTime, IsInJailersTower = GetTime, IsEncounterInProgress, RAID_CLASS_COLORS, GetInstanceInfo, GetSpellCharges, SecondsToTime, IsInJailersTower
local string_gsub, wipe, tonumber, pairs, ipairs, string_trim, format, floor, ceil, abs, type, sort, select, Enum = string.gsub, table.wipe, tonumber, pairs, ipairs, string.trim, format, floor, ceil, abs, type, sort, select, Enum
local UnitIsDeadOrGhost, UnitIsConnected, UnitName, UnitCreatureFamily, UnitIsDead, UnitIsGhost, UnitGUID, UnitInRange, UnitPhaseReason, UnitAura = UnitIsDeadOrGhost, UnitIsConnected, UnitName, UnitCreatureFamily, UnitIsDead, UnitIsGhost, UnitGUID, UnitInRange, UnitPhaseReason, UnitAura

local RaidInCombat, ClassColorNum, GetDifficultyForCooldownReset, DelUnitNameServer, NumberInRange = ExRT.F.RaidInCombat, ExRT.F.classColorNum, ExRT.F.GetDifficultyForCooldownReset, ExRT.F.delUnitNameServer, ExRT.F.NumberInRange
local GetEncounterTime, UnitCombatlogname, GetUnitInfoByUnitFlag, ScheduleTimer, CancelTimer, GetRaidDiffMaxGroup, table_wipe2, dtime, utf8sub = ExRT.F.GetEncounterTime, ExRT.F.UnitCombatlogname, ExRT.F.GetUnitInfoByUnitFlag, ExRT.F.ScheduleTimer, ExRT.F.CancelTimer, ExRT.F.GetRaidDiffMaxGroup, ExRT.F.table_wipe, ExRT.F.dtime, ExRT.F.utf8sub
local C_PvP_IsWarModeDesired = C_PvP.IsWarModeDesired

local GetSpellLevelLearned = GetSpellLevelLearned
if ExRT.isClassic then
	GetSpellLevelLearned = function () return 1 end
	IsInJailersTower = function() end
end

local VMRT = nil

local module = ExRT:New("ExCD2",ExRT.L.cd2)
local ELib,L = ExRT.lib,ExRT.L

local LibDeflate = LibStub:GetLibrary("LibDeflate")

module._C = {}
module.db.spellDB = {}

module.db.Cmirror = module._C
module.db.dbCountDef = #module.db.spellDB
module.db.findspecspells = {
	[30451] = 62, [5143] = 62,
	[11366] = 63, [133] = 63,
	[30455] = 64, [44614] = 64,

	[20473] = 65, [85222] = 65,
	[31935] = 66, [204019] = 66, [53595] = 66, 
	[85256] = 70, [184575] = 70,

	[12294] = 71, [7384] = 71,
	[23881] = 72, [184367] = 72,
	[6572] = 73, [6343] = 73,

	[202770] = 102, [102560] = 102, [194223] = 102,
	[202028] = 103, [5217] = 103, 
	[50334] = 104,
	[145205] = 105, [157982] = 105,

	[50842] = 250, [206930] = 250, 
	[49020] = 251, [49143] = 251,
	[55090] = 252, [85948] = 252,

	[272790] = 253, [193455] = 253, 
	[19434] = 254, [56641] = 254, 
	[186270] = 255, [259491] = 255, 

	[194509] = 256, [47540] = 256,
	[596] = 257, [204883] = 257,
	[335467] = 258, [34914] = 258,

	[1329] = 259, [32645] = 259, 
	[193315] = 260, [2098] = 260, 
	[185438] = 261, [53] = 261, 

	[8042] = 262, [198067] = 262, 
	[17364] = 263, [60103] = 263, 
	[61295] = 264, [73920] = 264,

	[198590] = 265, [324536] = 265, 
	[105174] = 266, [264178] = 266, 
	[29722] = 267, [116858] = 267, 

	[121253] = 268, [124506] = 268,
	[113656] = 269, [122470] = 269, 
	[115151] = 270, [191837] = 270, 

	[162243] = 577, [162794] = 577, [195072] = 577, 
	[209795] = 581, [228478] = 581, 
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
	[253] = 5,	[254] = 6,	[255] = 7,
	[71] = 5,	[72] = 6,	[73] = 7,
	[65] = 5,	[66] = 6,	[70] = 7,
	[62] = 5,	[63] = 6,	[64] = 7,
	[256] = 5,	[257] = 6,	[258] = 7,
	[265] = 5,	[266] = 6,	[267] = 7,
	[250] = 5,	[251] = 6,	[252] = 7,
	[259] = 5,	[260] = 6,	[261] = 7,
	[102] = 5,	[103] = 6,	[104] = 7,	[105] = 8,
	[268] = 5,	[269] = 6,	[270] = 7,
	[262] = 5,	[263] = 6,	[264] = 7,
	[577] = 5,	[581] = 6,
	[1467] = 5,	[1468] = 6,
	[0] = 4,
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
		[1467] = "EVOKERDPS",
		[1468] = "EVOKERHEAL",
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
	module.db.cdsNavData = cdsNavData
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
			local reason = true
			if type(v) == 'table' then
				if v[3] then
					reason = {v[3],v[2]}
				else
					reason = v[2]
				end
				v = v[1]
			end
			if v > 0 then
				e[v] = reason
			else
				e[-v] = nil
			end
		end
	})
	module.db.session_gGUIDs_DEBUG = sessionData

	if ExRT.isClassic then
		module.db.session_gGUIDs = setmetatable({}, {
			__index = function (t,k) 
				return sessionData[k] or nilData
			end,
			__newindex = function (t,k,v)
				local e = sessionData[k]
				if not e then
					local n = {}
					e = setmetatable({},{
						__index = function (t1,k1) 
							return n[k1] or type(k1) == "number" and k1 > 0 and n[GetSpellInfo(k1) or ""]
						end,
						__newindex = function (t1,k1,v1)
							n[k1] = v1
						end
					})
					sessionData[k] = e
				end
				local reason = true
				if type(v) == 'table' then
					if v[3] then
						reason = {v[3],v[2]}
					else
						reason = v[2]
					end
					v = v[1]
				end
				if type(v)=='string' or v > 0 then
					e[v] = reason
				else
					e[-v] = nil
				end
			end
		})
	end

	function module:ClearSessionDataReason(name,...)
		local e = sessionData[name]
		if not e then
			return
		end
		local reasons = {}
		for i=1,select("#",...) do
			reasons[ select(i,...) ] = true
		end
		for k,v in pairs(e) do
			if (type(v) == "table" and reasons[ v[2] ]) or (type(v) ~= "table" and reasons[v]) then
				e[k] = nil
			end
		end
	end

	function module:ClearFullSessionDataReason(...)
		local reasons = {}
		for i=1,select("#",...) do
			reasons[ select(i,...) ] = true
		end
		for _,e in pairs(sessionData) do
			for k,v in pairs(e) do
				if (type(v) == "table" and reasons[ v[2] ]) or (type(v) ~= "table" and reasons[v]) then
					e[k] = nil
				end
			end
		end
	end
end

module.db.session_Pets = {}
module.db.session_PetOwner = {}

module.db.spell_isTalent = {
	[845]=true,	[315720]=true,	[206940]=true,	[194913]=true,	[343294]=true,	[117014]=true,	[265046]=true,	[117014]=true,	[265046]=true,
	[265046]=true,	[205022]=true,	[235870]=true,	[205030]=true,	[116847]=true,	[196725]=true,	[116847]=true,

	--Other & items

	[311203]=true,	[311302]=true,	[311303]=true,	[312725]=true,	[313921]=true,	[313922]=true,	[310592]=true,	[310601]=true,	[310602]=true,	[310690]=true,	[311194]=true,	[311195]=true,	[295046]=true,	[299984]=true,	[299988]=true,	[303823]=true,	[304088]=true,	[304121]=true,		[299376]=true,	[299378]=true,		[299372]=true,	[299374]=true,		[299273]=true,	[299275]=true,	[297375]=true,	[298309]=true,	[298312]=true,		[298628]=true,	[299334]=true,		[299336]=true,	[299338]=true,		[299958]=true,	[299959]=true,		[299943]=true,	[299944]=true,		[300009]=true,	[300010]=true,		[298080]=true,	[298081]=true,		[299932]=true,	[299933]=true,		[299882]=true,	[299883]=true,		[300002]=true,	[300003]=true,		[299345]=true,	[299347]=true,		[299355]=true,	[299358]=true,		[302982]=true,	[302983]=true,	[296036]=true,	[310425]=true,	[310442]=true,		[299875]=true,	[299876]=true,		[300015]=true,	[300016]=true,		[299349]=true,	[299353]=true,	[296325]=true,	[299368]=true,	[299370]=true,		[298273]=true,	[298277]=true,
}

module.db.spell_autoTalent = {		--Для маркировки базовых заклинаний спека, которые являются талантами у других спеков [spellID] = specID
	[273048]=104,
	[88]=104,
	[288826]=104
}

module.db.spell_talentProvideAnotherTalents = {
	[197492] = {102793},
	[197488] = {132469},
	[197632] = {132469},
	[197491] = {99,22842},
	[217615] = {99,22842},
}

module.db.spell_talentsList = {}
module.db.spell_isPvpTalent = {}
module.db.spell_isAzeriteTalent = {}
module.db.spell_covenant = {}

do
	local cache = {}
	for k,v in pairs(module.db.spell_covenant) do
		module.db.spell_isTalent[k] = true
	end
	function module:AddCovenant(player,covenant)
		if not player or cache[player] == covenant then
			return
		end
		cache[player] = covenant
		module:ClearSessionDataReason(player,"covenant")
		for spellID,cov in pairs(module.db.spell_covenant) do
			if cov == covenant then
				module.db.session_gGUIDs[player] = {spellID,"covenant"}
			end
		end
	end
end

local SOULBIND_DEF_RANK_NOW = 15
do
	local nilData = {}
	local soulbindData = {}
	module.db.soulbind_rank_debug = soulbindData
	module.db.soulbind_rank = setmetatable({}, {
		__index = function (t,k) 
			return soulbindData[k] or nilData
		end
	})
	function module:SetSoulbindRank(player,spellID,rank)
		if not player then
			return
		end
		soulbindData[player] = soulbindData[player] or {}
		if rank and type(rank) == 'number' and rank > 15 then
			rank = 15
		end
		soulbindData[player][spellID] = rank
	end
end

do

	local nilData = {}
	local talentRankData = {}
	module.db.talent_classic_rank_debug = talentRankData
	module.db.talent_classic_rank = setmetatable({}, {
		__index = function (t,k) 
			return talentRankData[k] or nilData
		end
	})
	function module:SetTalentClassicRank(player,spellID,rank)
		if not player then
			return
		end
		talentRankData[player] = talentRankData[player] or {}
		talentRankData[player][spellID] = rank
	end
end

module.db.spell_charge_fix = {		--Спелы с зарядами
	[51505]=108283,
	[204019]=1,
	[53600]=1,
	[35395]=1,
	[205629]=1,
	[205234]=1,
	[61295]=108283,
	[19758]=1,
	[198304]=1,
	[193786]=1,
	[7384]=262150,
	[108839]=1,
	[115151]=1,
	[259495]=264332,
	[115308]=1,
	[108853]=205029,
	[275779]=204023,
	[210191]=1,
	[217200]=1,
	[259489]=269737,
	[212436]=1,
	[19434]=1,

	--[17]=1,
}

module.db.spell_durationByTalent_fix = {	--Изменение длительности талантом\глифом   вид: [спелл] = {spellid глифа\таланта, изменение времени (-10;10;*0.5;*1.5)}
	[52174]={202163,3},
}

module.db.spell_cdByTalent_fix = {		--Изменение кд талантом\глифом   вид: [спелл] = {spellid глифа\таланта, изменение времени (-60;60);spellid2,time2;spellid3,time3;...}
	[30449]={198100,30},
	[77761]={288826,-60},
	[52174]={202163,-15},
	[77764]={288826,-60},
	[6343]={275336,{"*0.5",107574}},
	[187827]={296320,"*0.80"},
	[339]={202226,6},
}

module.db.spell_cdByTalent_scalable_data = {
	[296320] = {
		[1] = "*0.75",
	},
}

module.db.spell_cdByTalent_isScalable = {
	[296320] = true,
}

module.db.tierSetsSpells = {}	--[specID.tierID.tierMark] = {2P Bonus Spell ID, 4P Bonus Spell ID}
module.db.tierSetsList = {}	-- [itemID] = specID.tierID.tierMark

module.db.spell_talentReplaceOther = {		--Спелы, показ которых нужно убрать при наличии таланта (талант заменяет эти спелы) [spellID] = [talent Spell ID]
	[34428]=202168,
	[35395]=204019,
}

module.db.spell_aura_list = {		--Спелы, время действия которых отменять при отмене бафа 	[buff_sid] = spellID
}
module.db.spell_speed_list = {		--Спелы, которым менять время действия на основании спелхасты
}
module.db.spell_afterCombatReset = {	--Принудительный сброс кд после боя с боссом (для спелов с кд менее 5 мин., 3мин после 6.1, 2мин после 9.0)
}
module.db.spell_afterCombatNotReset = {	--Запрещать сброс кд после боя с боссом (для петов, например; для спелов с кд 5 и более мин., для анха)
	[21169]=true,
	[199740]=true,
	[126393]=true,
	[160452]=true,
	[159956]=true,
	[159931]=true,
}
module.db.spell_reduceCdByHaste = {	--Заклинания, кд которых уменьшается хастой
	[12294]=true,
	[184575]=true,
	[24275]=true,
	[108853]=true,
	[204019]=true,
	[35395]=true,
	[121253]=true,
	[116847]=true,
	[6343]=true,
	[17364]=true,
	[275773]=true,
	[53500]=true,
	[115308]=true,
	[33917]=true,
	[20271]=true,
	[85222]=true,
	[845]=true,
	[193786]=true,
	[184092]=true,
	[213652]=true,
	[275779]=true,
	[23881]=true,
	[193796]=true,
	[6572]=true,
	[19434]=true,
	[187874]=true,
	[23922]=true,
}
module.db.spell_resetOtherSpells = {	--Заклинания, которые откатывают другие заклинания
	[204035]={53600},
	[217200]={{34026,336830}},
}
module.db.spell_sharingCD = {		--Заклинания, которые запускают кд на другие заклинания 	[spellID] = {[otherSpellID] = CD}
}

module.db.spell_runningSameSpell = {}	--Схожие заклинания

do
	module.db.spell_runningSameSpell2 = {
		{187611,187614,187615},						--Legendary Ring
		{202767,202771,202768},						--New moon [Balance Druid artifact]
		{330325,5308},	--warrior: Execute
	}
	if ExRT.isBC then
		module.db.spell_runningSameSpell2[#module.db.spell_runningSameSpell2+1] = {2894,2062}
	end
	for i=1,#module.db.spell_runningSameSpell2 do
		local list = module.db.spell_runningSameSpell2[i]
		for j=1,#list do
			module.db.spell_runningSameSpell[ list[j] ] = list
		end
	end
end

module.db.spell_reduceCdCast = {	--Заклинания, применение которых уменьшает время восстановления других заклинаний	[spellID] = {reduceSpellID,time;{reduceSpellID2,talentID},time2;{reduceSpellID3,talentID,specID,effectOnlyDuringBuffActive},time3}
}
module.db.spell_increaseDurationCast = {	--Заклинания, продляющие время действия
}
module.db.spell_dispellsFix = {}
module.db.spell_dispellsList = {	--Заклинания-диспелы (мгновенно откатываются, если ничего не диспелят)
	[115450]=true,
	[360823]=true,
}

module.db.spell_startCDbyAuraFade = {	--Заклинания, кд которых запускается только при спадении ауры (вида [aura_spellID] = CD_spellID)
	[5215]=5215,
}
module.db.spell_startCDbyAuraFadeExt = {	--Заклинания, кд которых запускается также при спадении ауры (вида [aura_spellID] = CD_spellID)
}
module.db.spell_startCDbyAuraApplied = {	--Заклинания, кд которых запускается только при наложении ауры (вида [aura_spellID] = CD_spellID)
}
module.db.spell_startCDbyAuraApplied_fix = {}
for _,spellID in pairs(module.db.spell_startCDbyAuraApplied) do module.db.spell_startCDbyAuraApplied_fix[spellID] = true end

module.db.spell_reduceCdByAuraFade = {	--Заклинания, кд которых уменьшается при спадении ауры по окончании времени действия. !Важно обязательное время действия для таких заклинаний
}
module.db.spell_reduceCdByAuraFadeBefore = {	--Заклинания, кд которых уменьшается при спадении ауры до окончания времени действия. !Важно обязательное время действия для таких заклинаний
}
module.db.spell_reduceCdByAura = {	--Изменение кд если активна аура
}
module.db.spell_ignoreUseWithAura = {
}

module.db.spell_battleRes = {		--Заклинания-воскрешения [WOD]
}
module.db.isResurectDisabled = nil

module.db.spell_isRacial = {		--Расовые заклинания
	[80483]="BloodElf",
	[69179]="BloodElf",
	[28880]="Draenei",
	[59542]="Draenei",
	[59544]="Draenei",
	[129597]="BloodElf",
	[59548]="Draenei",
	[202719]="BloodElf",
	[33697]="Orc",
	[50613]="BloodElf",
	[25046]="BloodElf",
	[155145]="BloodElf",
	[33702]="Orc",
	[59543]="Draenei",
	[59545]="Draenei",
	[59547]="Draenei",
	[69046]="Goblin",
}

module.db.aura_grant_talent = {		--Бафф, который дает талант	[buff_spell_id] = talent_spell_id
	[108293] = 273048,
}

module.db.def_col = {			--Стандартные положения в колонках
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
	[2] = 						{0,	{53490,180,12},	{61684,32,16},	},
	[3] = 						{0,	{61684,32,16},	{55709,480},	},
	[L.creatureNames["Ghoul"]] = 		{0,	{91837,45,10},	{91802,30},	{91797,60},	},
	[L.creatureNames["Felguard"]] = 		{0,	{89751,45,6},	{89766,30},	{30151,15},	},
	[L.creatureNames["Felhunter"]] = 		{0,	{19647,24},	{19505,15},	},
	[L.creatureNames["Fel Imp"]] = 		{0,	{115276,10},	},
	[L.creatureNames["Imp"]] = 		{0,	{89808,10},	{119899,30,12},	{89792,20},	},
	[L.creatureNames["Observer"]] = 		{0,	{19647,24},	{115284,15},	},
	[L.creatureNames["Shivarra"]] = 		{0,	{115770,25},	{115268,30},	},
	[L.creatureNames["Succubus"]] = 		{0,	{6360,25},	{6358,30},	},
	[L.creatureNames["Voidlord"]] = 		{0,	{115236,10}	},
	[L.creatureNames["Voidwalker"]] = 		{0,	{17735,10},	{17767,120,20},	{115232,10},	},
	[L.creatureNames["Wrathguard"]] = 		{0,	{115831,45,6},	},
	[L.creatureNames["Water Elemental"]] = 	{0,	{135029,25,4},	{33395,25},	},
}
module.db.spell_isPetAbility = {}
for petName,petData in pairs(module.db.petsAbilities) do
	for i=2,#petData do
		if module.db.spell_isPetAbility[petData[i][1]] then
			if type(module.db.spell_isPetAbility[petData[i][1]]) ~= "table" then
				module.db.spell_isPetAbility[petData[i][1]] = {module.db.spell_isPetAbility[petData[i][1]]}
			end
			module.db.spell_isPetAbility[petData[i][1]][ #module.db.spell_isPetAbility[petData[i][1]] + 1 ] = petName
		else
			module.db.spell_isPetAbility[petData[i][1]] = petName
		end
	end
end

module.db.differentIcons = {	--Другие иконки заклинаниям
	[176875]="Interface\\Icons\\Inv_misc_trinket6oOG_Isoceles1",
	[176873]="Interface\\Icons\\Inv_misc_trinket6oIH_orb4",
	[184270]="Interface\\Icons\\spell_nature_mirrorimage",
	[183929]="Interface\\Icons\\spell_mage_presenceofmind",
	[187614]="Interface\\Icons\\inv_60legendary_ring1c",
	[187613]="Interface\\Icons\\inv_60legendary_ring1b",
	[187612]="Interface\\Icons\\inv_60legendary_ring1a",
}

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

	[64399] = 90628,
	[64398] = 90626,
	[63359] = 89479,

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

	[144280] = 235556,
	[143728] = 208091,
	[144274] = 235273,
	[144293] = 235605,
	[144355] = 235940,
	[144242] = 235039,
}

--/run for _,q in pairs({188255,188272,188271,188268,188266,188263,188261}) do _,e=GetItemSpell(q) JJBox("["..q.."]="..e..",") end
--/run for _,q in pairs({188255,188272,188271,188268,188266,188263,188261}) do _,e=GetItemSpell(q)t=GetSpellBaseCooldown(e) JJBox("{"..e..',"ITEMS",	3,	{'..e..','..((t or 0)/1000)..',	0},	},') end

for itemID,spellID in pairs(module.db.itemsToSpells) do
	module.db.spell_isTalent[spellID] = true
	if spellID > 330000 and not module.db.differentIcons[spellID] then
		local icon = select(5,GetItemInfoInstant(itemID))
		if icon ~= GetSpellTexture(spellID) then
			module.db.differentIcons[spellID] = icon
		end
	end
end

ExRT.F.table_add2(module.db.itemsToSpells,{
	[124634] = 187614,	--Legendary Ring
	[124636] = 187615,	--Legendary Ring
	[124635] = 187611,	--Legendary Ring
	[124637] = 187613,	--Legendary Ring
	[124638] = 187612,	--Legendary Ring
})

module.db.itemsBonusToSpell = {
	[6972] = 336470,
	[6979] = 336133,
	[6977] = 336314,
	[6948] = 334724,
	[6943] = 334580,
	[6941] = 334525,
	[6946] = 334692,
	[6952] = 334949,
	[6951] = 334898,
	[7051] = 337685,
	[7109] = 340053,
	[7095] = 339062,
	[7003] = 336742,
	[7006] = 336747,
	[7009] = 336830,
	[7081] = 337296,
	[7070] = 337481,
	[7054] = 337594,
	[7053] = 337600,
	[7060] = 337831,
	[7114] = 340080,
	[6989] = 336734,
	[6995] = 335897,
	[7025] = 337020,
	[7118] = 340084,
	[6955] = 335214,
	[6965] = 335582,
	[6957] = 335239,
	[6956] = 335229,
	[7061] = 337838,
	[7011] = 336849,
	[7470] = 354131,
	[7730] = 357996,
	[7474] = 354109,
	[7571] = 354118,
	[7703] = 356391,
	[7728] = 356395,
	[7701] = 355447,
	[7573] = 354731,
	[7708] = 356218,
}
if UnitLevel'player' > 60 then	--not work outside sl
	for _,bonusID in pairs({6972,6979,6977,6948,6943,6941,6946,6952,6951,7051,7109,7095,7003,7006,7009,7081,7070,7054,7053,7060,7114,6989,6995,7025,7118,6955,6965,6957,6956,7061,7011,7470,7730,7474,7571,7703,7728,7701,7573,7708}) do
		module.db.itemsBonusToSpell[bonusID] = nil
	end
end

module.db.spellCDSync = {}
module.db.spellCDSyncToSpell = {}
do
	local c,scd,scsts = select(2,UnitClass'player'),module.db.spellCDSync,module.db.spellCDSyncToSpell
	if not ExRT.isClassic and c == "SHAMAN" then ExRT.F.table_add(scd,{157153,324386,5394,108280,16191,98008,192058,2484,8143,207399,198838}) end
	--if c == "DEMONHUNTER" then ExRT.F.table_add(scd,{204596,207684,202137,202138,390163}) end
end


module.db.spellIgnoreAfterFirstUse = {}

local CLEU = {}
module.db.CLEU = CLEU


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
	module.db.itemsBonusToSpell = {}
	module.db.itemsToSpells = {}

	module.db.spell_cdByTalent_fix = {}
	module.db.spell_durationByTalent_fix = {}
end
if ExRT.isLK then
	local spellToLvl = {
		[31884] = 70,
		[642] = 34,
		[10310] = 10,
		[1022] = 10,
		[19752] = 30,
		[34477] = 70,
		[64901] = 80,
		[64843] = 80,
		[6346] = 20,
		[42650] = 80,
		[61999] = 72,
		[2825] = 70,
		[32182] = 70,
		[55694] = 75,
		[20765] = 18,
		[55342] = 80,
		[45438] = 30,
	}

	GetSpellLevelLearned = function (spell)
		if spellToLvl[spell] then
			return spellToLvl[spell]
		end
		return 1 
	end
end


module.db.vars = {
	isWarlock = {},
	isRogue = {},
	isPaladin = {},
	isMage = {},
}

module.db.plugin = {}

module.db.rframes = {
	{text = L.cd2Autoselect},
	{name = "VuhDo", opts = {"^Vd1", "^Vd2", "^Vd3", "^Vd4", "^Vd5", "^Vd"}},
	{name = "HealBot", opts = {"^HealBot"}},
	{name = "Grid", opts = {"^GridLayout","^Grid2Layout"}},
	{name = "ElvUI", opts = {"^ElvUF_RaidGroup","^ElvUF_PartyGroup"}},
	{name = "SUF", opts = {"^SUFHeaderraid","^SUFHeaderparty"}},
	{name = "Blizzard", opts = {"^CompactRaid","^CompactParty"}},
}
module.db.rframes_def = {	--copy from LibGetFrame
	-- raid frames
	"^Vd1", -- vuhdo
	"^Vd2", -- vuhdo
	"^Vd3", -- vuhdo
	"^Vd4", -- vuhdo
	"^Vd5", -- vuhdo
	"^Vd", -- vuhdo
	"^HealBot", -- healbot
	"^GridLayout", -- grid
	"^Grid2Layout", -- grid2
	"^PlexusLayout", -- plexus
	"^ElvUF_RaidGroup", -- elv
	"^oUF_bdGrid", -- bdgrid
	"^oUF_.-Raid", -- generic oUF
	"^LimeGroup", -- lime
	"^SUFHeaderraid", -- suf
	-- party frames
	"^AleaUI_GroupHeader", -- Alea
	"^SUFHeaderparty", --suf
	"^ElvUF_PartyGroup", -- elv
	"^oUF_.-Party", -- generic oUF
	"^PitBull4_Groups_Party", -- pitbull4
	"^CompactRaid", -- blizz
	"^CompactParty", -- blizz
	-- player frame
	"^SUFUnitplayer",
	"^PitBull4_Frames_Player",
	"^ElvUF_Player",
	"^oUF_.-Player",
	"^PlayerFrame",
}

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
	fontCDSize = 16,
	frameLines = 15,
	frameAlpha = 100,
	frameScale = 100,
	frameWidth = 130,
	frameColumns = 1,
	frameBetweenLines = 0,
	frameBlackBack = 0,
	frameStrata = "MEDIUM",
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

	textIconNameChars = 50,
	textIconCDStyle = 7,

	blacklistText = "",
	whitelistText = "",

	ATFCol = 6,
	ATFLines = 2,
	ATFOffsetX = 0,
	ATFOffsetY = 0,
	ATFGrowth = 1,
	iconGlowType = 4,
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

local UpdateAllData = nil
local SaveCDtoVar = nil
local CLEUstartCD = nil

local L_Offline,L_Dead = L.cd2StatusOffline, L.cd2StatusDead
local _C, _db = module._C, module.db

local status_UnitsToCheck,status_UnitIsDead,status_UnitIsDisconnected,status_UnitIsOutOfRange = module.db.status_UnitsToCheck,module.db.status_UnitIsDead,module.db.status_UnitIsDisconnected,module.db.status_UnitIsOutOfRange

do
	local key_to_table = {
		["isTalent"]={module.db.spell_isTalent,0},
		["isCovenant"]={module.db.spell_covenant,0},
		["baseForSpec"]={module.db.spell_autoTalent,0},
		["hasCharges"]={module.db.spell_charge_fix,0},
		["durationDiff"]={module.db.spell_durationByTalent_fix,0},
		["cdDiff"]={module.db.spell_cdByTalent_fix,0},
		["isScalable"]={module.db.spell_cdByTalent_isScalable,0},
		["hideWithTalent"]={module.db.spell_talentReplaceOther,0},
		["changeDurWithHaste"]={module.db.spell_speed_list,0},
		["afterCombatReset"]={module.db.spell_afterCombatReset,0},
		["afterCombatNotReset"]={module.db.spell_afterCombatNotReset,0},
		["changeCdWithHaste"]={module.db.spell_reduceCdByHaste,0},
		["sameSpell"]={module.db.spell_runningSameSpell2,0},
		["isDispel"]={module.db.spell_dispellsList,0},
		["isBattleRes"]={module.db.spell_battleRes,0},
		["isRacial"]={module.db.spell_isRacial,0},
		["icon"]={module.db.differentIcons,0},
		["ignoreUseWithAura"]={module.db.spell_ignoreUseWithAura,0},

		["stopDurWithAuraFade"]={module.db.spell_aura_list,"S"},
		["resetBy"]={module.db.spell_resetOtherSpells,1},
		["startCdAfterUse"]={module.db.spell_sharingCD,"K"},
		["reduceCdAfterCast"]={module.db.spell_reduceCdCast,2},
		["increaseDurAfterCast"]={module.db.spell_increaseDurationCast,2},
		["startCdAfterAuraFade"]={module.db.spell_startCDbyAuraFade,"S"},
		["startCdAfterAuraFadeExt"]={module.db.spell_startCDbyAuraFadeExt,"S"},
		["startCdAfterAuraApply"]={module.db.spell_startCDbyAuraApplied,"S"},
		["changeCdAfterAuraFullDur"]={module.db.spell_reduceCdByAuraFade,2},
		["changeCdBeforeAuraFullDur"]={module.db.spell_reduceCdByAuraFadeBefore,2},
		["item"]={module.db.itemsToSpells,"S"},
		["changeCdWithAura"]={module.db.spell_reduceCdByAura,2},
	}
	local function cmp(a,b)
		if type(a) == "table" and type(b) == "table" then
			return ExRT.F.table_compare(a,b) == 1
		else
			return a == b
		end
	end
	function module:CreateSpellData(forceAll)
		CLEU:Reset()

		for i=1,#module.db.AllSpells do
			local spell = module.db.AllSpells[i]
			local on = VMRT.ExCD2.CDE[ spell[1] ]
			if on or forceAll then
				for k,v in pairs(spell) do
					local t = key_to_table[k]
					if t then
						local it = t[2]
						if t[2] == 0 then
							t[1][ spell[1] ] = v
						elseif t[2] == "K" then
							for i=1,#v do
								local st = t[1][ v[i][1] ]
								if not st then
									st = {}
									t[1][ v[i][1] ] = st
								end
								st[ spell[1] ] = v[i][2]
							end
						elseif t[2] == "S" then
							for i=1,(type(v)~="table" and 1 or #v) do
								t[1][ (type(v)~="table" and v or v[i]) ]=spell[1]
							end							
						else
							for i=1,(type(v)~="table" and 1 or #v),it do
								local sk = type(v)~="table" and v or v[i]
								local st
								local vAdd
								if type(sk) == "table" then
									local n = ExRT.F.table_copy2(sk)
									st = t[1][ n[1] ]
									if not st then
										st = {}
										t[1][ n[1] ] = st
									end
									n[1] = spell[1]
									vAdd = n
								else
									st = t[1][sk]
									if not st then
										st = {}
										t[1][sk] = st
									end
									vAdd = spell[1]
								end
								for o=1,#st,it do
									if cmp(st[o],vAdd) then
										vAdd = nil
										break
									end
								end
								if vAdd then
									st[#st+1] = vAdd
									for l=2,it do
										st[#st+1] = v[i+l-1]
									end
								end
							end
						end
					elseif type(k)=="string" and k:find("^CLEU_") and on then
						CLEU:Add(k,v)
					elseif type(k)=="string" then
						--print("ExCD2: CreateSpellData: Found wrong key",k)
					end
				end
			end
		end


		for _,list in pairs(module.db.spell_runningSameSpell2) do
			for j=1,#list do
				module.db.spell_runningSameSpell[ list[j] ] = list
			end
		end

		for _,spellID in pairs(module.db.spell_startCDbyAuraApplied) do module.db.spell_startCDbyAuraApplied_fix[spellID] = true end

		for itemID,spellID in pairs(module.db.itemsToSpells) do
			module.db.spell_isTalent[spellID] = true
			if spellID > 330000 and not module.db.differentIcons[spellID] then
				local icon = select(5,GetItemInfoInstant(itemID))
				if icon ~= GetSpellTexture(spellID) then
					module.db.differentIcons[spellID] = icon
				end
			end
		end

		for k in pairs(module.db.spell_cdByTalent_isScalable) do 
			if not module.db.spell_cdByTalent_scalable_data[k] then
				module.db.spell_cdByTalent_scalable_data[k]={[1]="*0.75"} 
			end
		end

		if ExRT.isClassic then
			local n = {}
			for k in pairs(module.db.spell_isTalent) do
				if type(k) == "number" then
					n[#n+1] = GetSpellInfo(k) or "spell:"..k
				end
			end
			for _,v in pairs(n) do
				module.db.spell_isTalent[v] = true
			end
		end
		CLEU:Recreate()
	end
	function module:CreateSpellDB()
		local spellDB, AllSpells = module.db.spellDB, module.db.AllSpells
		local isTestMode = module.db.testMode
		local spellInMainDB = {}
		wipe(spellDB)
		for i=1,#AllSpells do
			local data = AllSpells[i]
			if VMRT.ExCD2.CDE[ data[1] ] or isTestMode then
				spellDB[#spellDB+1] = data
				spellInMainDB[ data[1] ] = true
			end
		end
		for i=1,#VMRT.ExCD2.userDB do
			local data = VMRT.ExCD2.userDB[i]
			if 	--Prevent any errors for userbased cds
				VMRT.ExCD2.CDE[ data[1] ] and 
				not spellInMainDB[ data[1] ] and
				type(data[2]) == "string" and
				type(data[3]) == "number" and
				(data[4] or data[5] or data[6] or data[7] or data[8]) and
				((data[4] and data[4][1] and data[4][2] and data[4][3]) or not data[4]) and
				((data[5] and data[5][1] and data[5][2] and data[5][3]) or not data[5]) and
				((data[6] and data[6][1] and data[6][2] and data[6][3]) or not data[6]) and
				((data[7] and data[7][1] and data[7][2] and data[7][3]) or not data[7]) and
				((data[8] and data[8][1] and data[8][2] and data[8][3]) or not data[8])
			then
				spellDB[#spellDB+1] = data
				if data.itemID and data[2] and strsplit(",",data[2]) == "ITEMS" then
					_db.itemsToSpells[data.itemID] = data[1]
					if data.isEquip then
						_db.spell_isTalent[ data[1] ] = true
					end
				end
			end
		end

		module:CreateSpellData()
	end
end

function module:UpdateSpellDB(fullUpdate)
	if fullUpdate then
		module:CreateSpellDB()
		module:UpdateRoster()
	end
	UpdateAllData()
end

do
	local frame = CreateFrame("Frame",nil,UIParent)
	module.frame = frame
	frame:Hide()
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
		VMRT.ExCD2.Left = self:GetLeft()
		VMRT.ExCD2.Top = self:GetTop()
	end)
	frame.texture = frame:CreateTexture(nil, "BACKGROUND")
	frame.texture:SetColorTexture(0,0,0,0.3)
	frame.texture:SetAllPoints()
	module:RegisterHideOnPetBattle(frame)

	frame.colFrame = {}
end


local gsub_data = {}
local gsub_func = function(a)
	return gsub_data[a]
end
local function BarUpdateText(self)
	local barParent = self.parent

	local barData = self.data
	if not barData then
		--self.textLeft:SetText(" ")
		--self.textRight:SetText(" ")
		--self.textCenter:SetText(" ")
		--self.textIcon:SetText("")
		--self.textIconCD:SetText("")
		return
	end
	--if not barParent:IsVisible() then return end

	local time = (self.curr_end or 0) - GetTime() + 1
	if barParent.methodsTextIgnoreActive then
		time = (self.curr_end_cd or 0) - GetTime() + 1
	end

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

	local name_time = time >= 1 and longtime or name
	local name_stime = time >= 1 and shorttime or name
	local offStatus = self.disStatus or ""
	local chargesCount = self.curr_charges and "("..self.curr_charges..")" or ""

	gsub_data.time = longtime
	gsub_data.stime = shorttime
	gsub_data.name = name
	gsub_data.name_time = name_time
	gsub_data.name_stime = name_stime
	gsub_data.spell = spellName
	gsub_data.status = offStatus
	gsub_data.charge = chargesCount

	local left = string_trim(barParent.textTemplateLeft:gsub("%%([^%%]+)%%",gsub_func),nil)
	if self.textLeft.text ~= left then
		self.textLeft.text = left
		if left == "" then left = " " end
		self.textLeft:SetText(left)
	end

	local right = string_trim(barParent.textTemplateRight:gsub("%%([^%%]+)%%",gsub_func),nil)
	if self.textRight.text ~= right then
		self.textRight.text = right
		if right == "" then right = " " end
		self.textRight:SetText(right)
	end

	local center = string_trim(barParent.textTemplateCenter:gsub("%%([^%%]+)%%",gsub_func),nil)
	if self.textCenter.text ~= center then
		self.textCenter:SetText(center)
		self.textCenter.text = center
	end

	if barParent.optionIconName and (self.textIcon.name ~= barData.name or self.textIcon.numChars ~= barParent.textIconNameChars) then
		self.textIcon:SetText(utf8sub(barData.name,1,barParent.textIconNameChars))
		self.textIcon.name = barData.name
		self.textIcon.numChars = barParent.textIconNameChars
	end

	local cdText
	if barParent.optionCooldownUseExRT then
		local style = barParent.textIconCDStyle
		time = time - 1
		if  time <= 0 then
			cdText = ""
		elseif time < 60 then
			if style == 1 or style == 2 or style == 5 or style == 7 or style == 8 or style == 11 then
				cdText = ceil(time)
			elseif style == 3 or style == 4 or style == 6 or style == 9 or style == 10 then
				cdText = format("%.1f",time)
			end
		elseif style == 1 or style == 3 then
			cdText = SecondsToTime(time, true)
		elseif style == 2 or style == 4 then
			cdText = SecondsToTime(time+60, true)
		elseif style == 5 or style == 6 then
			cdText = format("%d:%02d",time/60,time%60)
		elseif style == 7 or style == 9 then
			cdText = format("%dm",time/60)
		elseif style == 8 or style == 10 then
			cdText = format("%dm",time/60+1)
		elseif style == 11 then
			if time <= 99 then
				cdText = ceil(time)
			else
				cdText = format("%dm",time/60)
			end
		end
	end
	if self.textIconCD.text ~= cdText then
		self.textIconCD:SetText(cdText or "")
		self.textIconCD.text = cdText
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
	if self.c > 2 then
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
	if self.c > 2 then
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
	if self.c > 2 then
		self.c = 0

		bar:UpdateText()
	end
end

local function StopBar(self)
	if self.curr_end == 0 then
		return
	end
  	self.anim:Stop()
  	self.spark:Hide()
 	self:UpdateStatus()
	if self:IsVisible() then 
 		UpdateAllData()
	end
end

local function UpdateBar(self)
	local data = self.data
	if not data then
		self:Hide()
		return
	end
	if not self:IsShown() then
		self:Show()
	end

	self.iconTexture:SetTexture(data.icon)
	self:UpdateText()
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
		bar.textIconCD:SetTextColor(t.r + bar.curr_anim_t_r*progress,t.g + bar.curr_anim_t_g*progress,t.b + bar.curr_anim_t_b*progress)
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
	local tOnlyCD = (isCooldown and cooldown)

	local isDisabled = data.disabled
	if isDisabled then
		isCooldown = true
	end
	if data.specialStatus then
		local var1,var2,var3,var4,var5 = data.specialStatus(data)
		if var5 then
			isCooldown = true
			isDisabled = true
		end
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

				isCooldown = isCooldown and false

				self.curr_charges = 1
			elseif data.charge > currTime and not isActive then
				lastUse = data.charge - data.cd
				t = data.charge
				tOnlyCD = t

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
		if not self:IsVisible() then self.anim:Pause() end
	elseif t then
		self.curr_start = lastUse
		self.curr_end = t
		self.curr_dur = t - lastUse
		self.curr_end_cd = tOnlyCD

		self.timeline.SetWidth = self.timeline._SetWidth
		self.timeline.SetShown = self.timeline._SetShown

		self.spark:Show()
		self.anim:Play()
		if not self:IsVisible() then self.anim:Pause() end
	else
		self.curr_start = 0
		self.curr_end = 1
		self.curr_dur = 1
		self.curr_end_cd = 1

		self.timeline.SetWidth = self.timeline._SetWidth
		self.timeline.SetShown = self.timeline._SetShown

	  	self.spark:Hide()
		if self.anim:IsPlaying() then self.anim:Stop() end
	  
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
			self.textIconCD:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
		end

		if isActive and self.curr_anim_state ~= 1 then
			self.curr_anim_state = 1
			if self.anim_state:IsPlaying() then self.anim_state:Stop() end
			self.anim_state:Play()
			if not self:IsVisible() then self.anim_state:Pause() end
		elseif isCooldown and self.curr_anim_state ~= 2 then
			self.curr_anim_state = 2
			if self.anim_state:IsPlaying() then self.anim_state:Stop() end
			self.anim_state:Play()
			if not self:IsVisible() then self.anim_state:Pause() end
		elseif not isCooldown and not isActive and self.curr_anim_state then
			self.curr_anim_state = nil
			if self.anim_state:IsPlaying() then self.anim_state:Stop() end
			self.anim_state:Play()
			if not self:IsVisible() then self.anim_state:Pause() end
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
		self.textIconCD:SetTextColor(colorTable.r,colorTable.g,colorTable.b)
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
			self.cooldown:SetDrawSwipe(true)
			self.cooldown:SetCooldown(self.curr_start,self.curr_end-self.curr_start)
			self.glowStart(self.icon)
		elseif isCharge then
			self.cooldown:Show()
			self.cooldown:SetReverse(false)
			self.cooldown:SetDrawSwipe(false)
			self.cooldown:SetCooldown(self.curr_start,self.curr_end-self.curr_start)
			self.glowStop(self.icon)
		elseif isCooldown then
			self.cooldown:Show()
			self.cooldown:SetReverse(false)
			self.cooldown:SetDrawSwipe(true)
			if isDisabled then
				self.cooldown:SetCooldown(currTime,0)
			else
				self.cooldown:SetCooldown(self.curr_start,self.curr_dur)
			end
			self.glowStop(self.icon)
		else
			self.cooldown:Hide()
			self.glowStop(self.icon)
		end
	else
		self.glowStop(self.icon)
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
	self.textLeft.text = nil
	self.textRight:SetText("")
	self.textRight.text = nil
	self.textCenter:SetText("")
	self.textCenter.text = nil
	self.textIcon:SetText("")
	self.textIcon.name = nil
	self.textIconCD:SetText("")

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

local function LineClickFrameOnHover_OnUpdate(self)
	if not self:IsMouseOver() then
		self:SetScript("OnUpdate",nil)
		if self.IconIsHovered then
			GameTooltip_Hide()
			self.IconIsHovered = nil
		end
		return
	end
	local isHover = self:GetParent().icon:IsMouseOver()
	if isHover and not self.IconIsHovered then
		LineIconOnHover(self)
		self.IconIsHovered = true
	elseif not isHover and self.IconIsHovered then
		GameTooltip_Hide()
		self.IconIsHovered = nil
	end
end

local function LineClickFrameOnHover(self)
	self.IconIsHovered = nil
	self:SetScript("OnUpdate",LineClickFrameOnHover_OnUpdate)
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

		self.textCenter:SetPoint("LEFT",self.textLeft,"RIGHT",0,0)
		self.textCenter:SetPoint("RIGHT",self.statusbar,0,0)
	elseif parent.textTemplateCenter:find("time%%") then
		self.textLeft:SetPoint("LEFT",self.statusbar,1,0)
		self.textRight:SetPoint("RIGHT",self.statusbar,-1+fontOutlineFix,0)

		self.textCenter:SetPoint("LEFT",self.statusbar,0,0)
		self.textCenter:SetPoint("RIGHT",self.statusbar,0,0)
	else
		self.textRight:SetPoint("RIGHT",self.statusbar,-1+fontOutlineFix,0)
		self.textLeft:SetPoint("LEFT",self.statusbar,1,0)
		self.textLeft:SetPoint("RIGHT",self.textRight,"LEFT",0,0)

		self.textCenter:SetPoint("LEFT",self.statusbar,0,0)
		self.textCenter:SetPoint("RIGHT",self.textRight,"LEFT",0,0)
	end

	self.barWidth = width

	local textureFile = parent.textureFile or module.db.colsDefaults.textureFile
	local isValidTexture = self.background:SetTexture(textureFile)
	if not isValidTexture then
		textureFile = module.db.colsDefaults.textureFile
		self.background:SetTexture(textureFile)
	end
	self.timeline:SetTexture(textureFile)

	local isValidFont = nil

	self.textLeft:SetFont(parent.fontLeftName,parent.fontLeftSize,parent.fontLeftOutline and "OUTLINE" or "")
	self.textRight:SetFont(parent.fontRightName,parent.fontRightSize,parent.fontRightOutline and "OUTLINE" or "")
	self.textCenter:SetFont(parent.fontCenterName,parent.fontCenterSize,parent.fontCenterOutline and "OUTLINE" or "")
	self.textIcon:SetFont(parent.fontIconName,parent.fontIconSize,parent.fontIconOutline and "OUTLINE" or "")
	self.textIconCD:SetFont(parent.fontIconCDName,parent.fontIconCDSize,parent.fontIconCDOutline and "OUTLINE" or "")

	local fontOffset = 0
	fontOffset = parent.fontLeftShadow and 1 or 0	self.textLeft:SetShadowOffset(1*fontOffset,-1*fontOffset)
	fontOffset = parent.fontRightShadow and 1 or 0	self.textRight:SetShadowOffset(1*fontOffset,-1*fontOffset)
	fontOffset = parent.fontCenterShadow and 1 or 0	self.textCenter:SetShadowOffset(1*fontOffset,-1*fontOffset)
	fontOffset = parent.fontIconShadow and 1 or 0	self.textIcon:SetShadowOffset(1*fontOffset,-1*fontOffset)
	fontOffset = parent.fontIconCDShadow and 1 or 0	self.textIconCD:SetShadowOffset(1*fontOffset,-1*fontOffset)

	local cdFont = self.cooldown:GetRegions()
	cdFont:SetFont(cdFont:GetFont(),parent.fontCDSize or 16,"OUTLINE")

	self.iconTexture:SetDesaturated(nil)

	self:SetAlpha(1)

	self.cooldown:Hide()
	self.cooldown:SetHideCountdownNumbers(parent.optionCooldownHideNumbers and true or false)
	self.cooldown:SetDrawEdge(parent.optionCooldownShowSwipe and true or false)

	if parent.optionCooldownUseExRT or (not parent.optionCooldownHideNumbers and GetCVar("countdownForCooldowns") == "1") then
		self.cooldown.noCooldownCount = true	--hide OmniCC time on cooldown
	else
		self.cooldown.noCooldownCount = nil
	end

	self.textIcon:SetText("")
	self.textIcon.name = nil

	if parent.optionCooldownUseExRT then
		self.textIconCD:Show()
	else
		self.textIconCD:Hide()
	end

	if parent.glowStop ~= self.glowStop then
		self.glowStop(self.icon)
	end
	self.glowStart = parent.glowStart or ExRT.NULLfunc
	self.glowStop = parent.glowStop or ExRT.NULLfunc

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

	if parent.methodsLineClick and parent.methodsLineClickWhisper then
		self.clickFrame:SetScript("OnClick",LineIconOnClickBoth)
		self.clickFrame:Show()
		self.clickFrame:SetFrameLevel(9000)
	elseif parent.methodsLineClick then
		self.clickFrame:SetScript("OnClick",LineIconOnClick)
		self.clickFrame:Show()
		self.clickFrame:SetFrameLevel(9000)
	elseif parent.methodsLineClickWhisper then
		self.clickFrame:SetScript("OnClick",LineIconOnClickWhisper)
		self.clickFrame:Show()
		self.clickFrame:SetFrameLevel(9000)
	else
		self.clickFrame:SetScript("OnClick",nil)
		self.clickFrame:Hide()
	end
	if parent.methodsIconTooltip then
		if not self.clickFrame:IsShown() then
			self.clickFrame:Show()
			self.clickFrame:SetFrameLevel(9000)
		end
		self.clickFrame:SetScript("OnEnter",LineClickFrameOnHover)
	else
		self.clickFrame:SetScript("OnEnter",nil)
		self.clickFrame:SetScript("OnUpdate",nil)
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

	self.atf = nil
	self.atf2 = nil

	self.textLeft.text = nil
	self.textRight.text = nil
	self.textCenter.text = nil
	self.textIcon.name = nil

	if parent.Masque_Group and self.Masque_Group ~= parent.Masque_Group then
		parent.Masque_Group:AddButton(self, {Icon = self.iconTexture, Cooldown = self.cooldown}, "MRT_CD_ICON", true)
		self.Masque_Group = parent.Masque_Group
	elseif not parent.Masque_Group and self.Masque_Group then
		self.Masque_Group = nil
	end

	if module.db.plugin and type(module.db.plugin.UpdateBarStyle)=="function" then
		module.db.plugin.UpdateBarStyle(self)
	end
end

local function AnimationControl_Hide(self)
	if self.anim:IsPlaying() then
		self.anim:Pause()
	end
	if self.anim_state:IsPlaying() then
		self.anim_state:Pause()
	end
end
local function AnimationControl_Show(self)
	if self.anim:IsPaused() then
		self.anim:Play()
	end
	if self.anim_state:IsPaused() then
		self.anim_state:Play()
	end
end
local function AnimationControl_Play(self)
	self:SetScript("OnUpdate",BarStateAnimation)
end
local function AnimationControl_Pause(self)
	self:SetScript("OnUpdate",nil)
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
	anim.timer:SetDuration(0.05)
	anim:Stop()
	anim:SetScript("OnLoop",BarAnimation)
	anim.bar = self
	self.anim = anim

	local anim_state = self:CreateAnimationGroup()
	anim_state.timer = anim_state:CreateAnimation()
	anim_state.timer:SetDuration(0.5)
	anim_state:Stop()
	--anim_state:SetScript("OnUpdate",BarStateAnimation)
	anim_state:SetScript("OnPlay",AnimationControl_Play)
	anim_state:SetScript("OnPause",AnimationControl_Pause)
	anim_state:SetScript("OnFinished",BarStateAnimationFinished)
	anim_state.bar = self
	self.anim_state = anim_state

	self:SetScript("OnHide",AnimationControl_Hide)
	self:SetScript("OnShow",AnimationControl_Show)

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

	self.textLeft = ELib:Text(self.statusbar,nil,nil,"GameFontNormal"):Point(1,0):Color()
	self.textRight = ELib:Text(self.statusbar,nil,nil,"GameFontNormal"):Size(40,0):Point("TOPRIGHT",1,0):Right():Color()
	self.textCenter = ELib:Text(self.statusbar,nil,nil,"GameFontNormal"):Point(0,0):Center():Color()
	self.textIcon = ELib:Text(icon,nil,nil,"GameFontNormal"):Point(0,0):Center():Bottom():Color()
	self.textIconCD = ELib:Text(cooldown,nil,nil,"GameFontNormal"):Point("CENTER"):Center():Middle():Color()

	self.textIcon:SetDrawLayer("ARTWORK",3)
	self.textIconCD:SetDrawLayer("ARTWORK",3)

	self.glowStart = ExRT.NULLfunc
	self.glowStop = ExRT.NULLfunc

	--multilinetext fix
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
module.db.debugBarFuncs = {
	Stop = StopBar,
	Update = UpdateBar,
	UpdateStyle = UpdateBarStyle,
	UpdateText = BarUpdateText,
	UpdateStatus = UpdateBarStatus,
	CreateTitle = BarCreateTitle,
	BarAnimation = BarAnimation,
	BarAnimation_Reverse = BarAnimation_Reverse,
	BarAnimation_NoAnimation = BarAnimation_NoAnimation,
	BarStateAnimation = BarStateAnimation,
	BarStateAnimationFinished = BarStateAnimationFinished,
}

local function FixFontsOnLoad(self)
	local defGameFont = GameFontWhite:GetFont()
	for i=1,#self.lines do
		local bar = self.lines[i]

		bar.textLeft:SetFont(defGameFont,self.fontLeftSize - 1,"")
		bar.textRight:SetFont(defGameFont,self.fontRightSize - 1,"")
		bar.textCenter:SetFont(defGameFont,self.fontCenterSize - 1,"")
		bar.textIcon:SetFont(defGameFont,self.fontIconSize - 1,"")
		bar.textIconCD:SetFont(defGameFont,self.fontIconSize - 1,"")

		bar:UpdateStyle()
	end
	return true
end

function module:CreateColumn(parent,frameName)
	local columnFrame = CreateFrame("Frame",frameName,parent)
	columnFrame:EnableMouse(false)
	columnFrame:SetMovable(false)

	columnFrame.texture = columnFrame:CreateTexture(nil, "BACKGROUND")
	columnFrame.texture:SetColorTexture(0,0,0,0)
	columnFrame.texture:SetAllPoints()

	columnFrame.lockTexture = columnFrame:CreateTexture(nil, "BACKGROUND")
	columnFrame.lockTexture:SetColorTexture(0,0,0,0)
	columnFrame.lockTexture:SetAllPoints()

	columnFrame.lines = {}

	columnFrame.BlackList = {}

	return columnFrame
end

for i=1,module.db.maxColumns do
	local columnFrame = module:CreateColumn(module.frame,"MRTRaidCooldownCol"..i)
	module.frame.colFrame[i] = columnFrame
	columnFrame:RegisterForDrag("LeftButton")
	columnFrame:SetScript("OnDragStart", function(self) 
		if self:IsMovable() then 
			self:StartMoving() 
		end 
	end)
	columnFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		if self.ATFenabled then
			return
		end
		VMRT.ExCD2.colSet[i].posX = self:GetLeft()
		VMRT.ExCD2.colSet[i].posY = self:GetTop()
	end)
	columnFrame.colNum = i

	module:RegisterHideOnPetBattle(columnFrame)

	ELib:FixPreloadFont(columnFrame,FixFontsOnLoad)
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
		if not VMRT.ExCD2.SplitOpt then
			if VMRT.ExCD2.colSet[module.db.maxColumns+1].methodsOnlyInCombat then
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
		if ((currTime - lastSaving) < 20 and not overwrite) or module.db.testMode then 
			return 
		end
		if not VMRT or not VMRT.ExCD2 then
			return
		end
		local VMRT_ExCD2_Save = VMRT.ExCD2.Save
		wipe(VMRT_ExCD2_Save)
		for i=1,#_C do
			local unitSpellData = _C[i]
			if unitSpellData.lastUse + unitSpellData.cd - currTime > 0 then
				VMRT_ExCD2_Save[ (unitSpellData.fullName or "?")..(unitSpellData.db[1] or 0) ] = {unitSpellData.lastUse,unitSpellData.cd}
			else
				VMRT_ExCD2_Save[ (unitSpellData.fullName or "?")..(unitSpellData.db[1] or 0) ] = nil
			end
		end
		lastSaving = currTime
	end
end

local function AfterCombatResetFunction(isArena)
	if not ExRT.isClassic or ExRT.isLK then
		for i=1,#_C do
			local unitSpellData = _C[i]
			local uSpecID = _db.specInDBase[globalGUIDs[unitSpellData.fullName] or 0]
			if not unitSpellData.db[uSpecID] and unitSpellData.db[4] then
				uSpecID = 4
			end

			if (unitSpellData.cd > 0 and (_db.spell_afterCombatReset[unitSpellData.db[1]] or (unitSpellData.db[uSpecID] and unitSpellData.db[uSpecID][2] >= (isArena and 0 or 120) or unitSpellData.cd >= (isArena and 0 or 180)))) and (not _db.spell_afterCombatNotReset[unitSpellData.db[1]] or isArena) then
				unitSpellData.lastUse = 0 
				unitSpellData.charge = nil 

				if unitSpellData.specialAfterCombatReset then
					unitSpellData.specialAfterCombatReset(unitSpellData)
				end

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
			local uSpecID = module.db.specInDBase[VMRT.ExCD2.gnGUIDs[data.fullName] or 0]
			if not data.db[uSpecID] then
				uSpecID = 4
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
end

function module.IsPvpTalentsOn(unit)
	local _, zoneType = GetInstanceInfo()
	if zoneType == 'arena' or zoneType == 'pvp' then
		return true
	elseif (zoneType == "none" or not zoneType) and (C_PvP_IsWarModeDesired() and UnitPhaseReason(unit) ~= Enum.PhaseReason.WarMode) then
		return true
	else
		return false
	end
end
if ExRT.isClassic then
	function module.IsPvpTalentsOn(unit)
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
	local columnsTable = module.frame.colFrame

	local _CV = {}
	local _CV_Len = 0
	module.db._CV = _CV

	local playerName = ExRT.SDB.charName

	local IsPvpTalentsOn = module.IsPvpTalentsOn

	local saveDataTimer = 0
	local lastBattleResChargesStatus = nil

	local function sort_f(a,b)
		if a.column ~= b.column then
			return a.column < b.column
		elseif a.sorting ~= b.sorting then
			if a.rsort then
				return (a.sorting or 0) > (b.sorting or 0)
			else
				return (a.sorting or 0) < (b.sorting or 0)
			end
		elseif a.rsort then
			return (a.sort or 0) > (b.sort or 0)
		else
			return (a.sort or 0) < (b.sort or 0)
		end
	end

	local oneSpellPerCol = {} for i=1,maxColumns do oneSpellPerCol[i]={} end
	local prevLineForGUID,prevLineForGUID_wiped = {}
	local reviewID = 0

	local strataToStrata = {
		["BACKGROUND"]="LOW",
		["LOW"]="MEDIUM",
		["MEDIUM"]="HIGH",
		["HIGH"]="DIALOG",
		["DIALOG"]="FULLSCREEN",
		["FULLSCREEN"]="FULLSCREEN_DIALOG",
		["FULLSCREEN_DIALOG"]="TOOLTIP",
		["TOOLTIP"]="TOOLTIP",
	}

	local LGF = LibStub("LibGetFrame-1.0",true)
	local LGFNullOpt = {}

	local needReposAttached

	local HiddenOnCD = {}	--for "Show only without cd" option, hidden cds can't fire updateall event

	local function SortAllData()
		local currTime = GetTime()
	  	for i=1,_CV_Len do
	  		local data = _CV[i]
			local columnFrame = columnsTable[data.column]
			if columnFrame.methodsSortByAvailability then
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
				elseif data.disable_oncd then
					cd = 49999
				end
				if cd > 0 then
					cd = cd + 50000
				end

				local dur = 0
				if columnFrame.methodsSortActiveToTop then
					dur = data.lastUse + data.duration - currTime
					if dur < 0 then
						dur = 0
					end
				end
				data.sorting = dur > 0 and dur or cd > 0 and cd or 0

				if columnFrame.methodsNewSpellNewLine then
					data.sorting = (data.sort2 or data.db[1]) * 100000 + data.sorting
				end
			else
				data.sorting = 0
			end
			data.rsort = columnFrame.methodsReverseSorting
	  	end
		sort(_CV,sort_f)
	end
	module.SortAllData = SortAllData

	local function TalentReplaceOtherCheck(spellID,name)
		local spellData = spell_talentReplaceOther[spellID]
		if type(spellData) == 'number' then
			if not spell_isPvpTalent[spellData] or module.IsPvpTalentsOn(name) then
				return session_gGUIDs[name][spellData]
			end
		else
			for i=1,#spellData do
				if session_gGUIDs[name][ spellData[i] ] then
					return true
				end
			end
		end
		return false
	end
	local function IsOnCD(data)
		local currTime = GetTime()

		local isOnCD = not data.isCharge and (data.lastUse + data.cd) > currTime
		if data.disable_oncd then
			isOnCD = true
		end

		return isOnCD or (data.isCharge and data.charge and data.charge > currTime)
	end

	function UpdateAllData()
		reviewID = reviewID + 1
		--print('UpdateAllData',GetTime())
		local isTestMode = _db.testMode
		local CDECol = VMRT.ExCD2.CDECol
		local VMRT_CDE = VMRT.ExCD2.CDE
		local currTime = GetTime()
		wipe(_CV)
		_CV_Len = 0
		for i=1,#_C do
			local data = _C[i]
			local db = data.db
			local name = data.fullName
			local spellID = db[1]

			local specID = globalGUIDs[name] or 0
			local unitSpecID = specInDBase[specID] or 4

			if isTestMode or (VMRT_CDE[spellID] and 
			(db[unitSpecID] or (not db[unitSpecID] and db[4])) and 
			(not spell_isTalent[spellID] or session_gGUIDs[name][spellID]) and 
			(not spell_isPvpTalent[spellID] or (session_gGUIDs[name][spellID] and IsPvpTalentsOn(name))) and 
			(not spell_isPetAbility[spellID] or session_Pets[name] == spell_isPetAbility[spellID] or (session_Pets[name] and petsAbilities[ session_Pets[name] ] and petsAbilities[ session_Pets[name] ][1] == spell_isPetAbility[spellID]) or (type(spell_isPetAbility[spellID]) == "table" and session_Pets[name] and ExRT.F.table_find(spell_isPetAbility[spellID],session_Pets[name]))) and
			(not spell_talentReplaceOther[spellID] or not TalentReplaceOtherCheck(spellID,name)) and
			(not data.specialCheck or data.specialCheck(data,currTime))
			) then 
				data.vis = true

				local col = CDECol[spellID..";"..(unitSpecID-3)] or CDECol[spellID..";1"] or def_col[spellID..";"..(unitSpecID-3)] or def_col[spellID..";1"] or db[3] or 1
				data.column = col

				local forceUpdate

				local isCharge = spell_charge_fix[ spellID ]
				if isCharge and spell_isPvpTalent[isCharge] and not module.IsPvpTalentsOn(name) then
					isCharge = false
				end
				if isCharge then
					if session_gGUIDs[name][isCharge] then
						if not data.isCharge then
							forceUpdate = true
							data.charge = data.lastUse
						end
						data.isCharge = true
						isCharge = true
					else
						if data.isCharge then
							forceUpdate = true
						end
						data.isCharge = nil
						isCharge = nil
					end
				elseif data.isCharge then
					data.isCharge = nil
					forceUpdate = true
				end

				local columnFrame = columnsTable[col]

				local isOnCD = not isCharge and (data.lastUse + data.cd) > currTime
				if data.disable_oncd then
					isOnCD = true
				end

				local isOnCDWithCharge = isOnCD or (isCharge and data.charge and data.charge > currTime)

				if columnFrame.optionShownOnCD and not isOnCDWithCharge then
					data.vis = nil
				end
				if columnFrame.methodsOnlyNotOnCD and isOnCDWithCharge then
					data.vis = nil
					HiddenOnCD[data] = true
				end
				if columnFrame.methodsHideOwnSpells and name == playerName then
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
				if (isDead or isOffline) and not columnFrame.methodsCDOnlyTime then
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
				if bar and bar.data == data and (data.disabled ~= prevDisabledStatus or data.outofrange ~= prevOutOfRange or forceUpdate) then
					data.bar:UpdateStatus()
				end

				if columnFrame.ATFenabled then
					needReposAttached = true
				end

				_CV_Len = _CV_Len + 1
				_CV[_CV_Len] = data
			else
				data.vis = nil
			end
		end
		SortAllData()
	end
	module.UpdateAllData = UpdateAllData

	local statusTimer2 = 0
	local timerATFRepos = 0
	local timerATFReset = 15
	local ATFFrames = {}

	function module:ATFFrameDataReset()
		timerATFReset = 100
	end

	function module:timer(elapsed)
		local forceUpdateAllData

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
			end
			module:toggleCombatVisibility(false,1)
		end


		---------> Check status
		statusTimer2 = statusTimer2 + elapsed
		if statusTimer2 > 0.25 then
			statusTimer2 = 0
			for i,unit in pairs(status_UnitsToCheck) do
				local inRange,isRange = UnitInRange(unit)
				local outOfRange = isRange and not inRange
				if status_UnitIsOutOfRange[ unit ] ~= outOfRange then
					forceUpdateAllData = true
					status_UnitIsOutOfRange[ unit ] = outOfRange
				end

				local isDead = UnitIsDeadOrGhost(unit)
				if isDead ~= status_UnitIsDead[ unit ] then
					forceUpdateAllData = true
					status_UnitIsDead[ unit ] = isDead
				end

				local isOffline = not UnitIsConnected(unit)
				if isOffline ~= status_UnitIsDisconnected[ unit ] then
					forceUpdateAllData = true
					status_UnitIsDisconnected[ unit ] = isOffline
				end
			end

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
				for i=1,_CV_Len do
					local data = _CV[i]
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

				if charges and lastBattleResChargesStatus and charges < lastBattleResChargesStatus then		--Add resurrect to history
					module.db.historyUsage[#module.db.historyUsage + 1] = {time(),20484,"*",GetEncounterTime()}
				end
				lastBattleResChargesStatus = charges
			end

			for data in pairs(HiddenOnCD) do
				if not IsOnCD(data) then
					forceUpdateAllData = true
					HiddenOnCD[data] = nil
				end
			end
		end

		if forceUpdateAllData then
			UpdateAllData()
		end

		for i=1,maxColumns do 
			inColsCount[i] = 0 
			columnsTable[i].lastSpell = nil
		end
		for i=1,_CV_Len do
			local data = _CV[i]
			if data.vis then
				local col = data.column
				local numberInCol = inColsCount[col] + 1

				local barParent = columnsTable[col]

				if numberInCol <= barParent.optionLinesMax then
					local spellID = data.db[1]

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

		timerATFRepos = timerATFRepos + elapsed
		local ATFProcess
		if timerATFRepos > 1 or needReposAttached then
			timerATFRepos = 0
			needReposAttached = false
			if LGF then
				ATFProcess = true
			end
		end

		--Reset data for predefined
		timerATFReset = timerATFReset + elapsed
		if timerATFReset > 20 then
			timerATFReset = 0

			for _,v in pairs(ATFFrames) do
				wipe(v)
			end
		end

		for i=1,maxColumns do
			local col = columnsTable[i]
			if col.IsColumnEnabled then
				local start = inColsCount[i]
				if start > col.optionLinesMax then
					start = col.optionLinesMax
				end
				for j=start+1,col.NumberLastLinesActive do
					local bar = col.lines[j]
					if bar and bar.data then
						bar.data = nil
						bar:Update()
					end
				end
				col.NumberLastLinesActive = start

				if ATFProcess and col.ATFenabled then
					prevLineForGUID_wiped = nil
					for j=1,start do
						local bar = col.lines[j]
						if bar.data then
							local guid = bar.data.guid or "unk"
							local optList = col.ATFFramePrior or LGFNullOpt
							if not ATFFrames[optList] then
								ATFFrames[optList] = {}
							end
							local frame = ATFFrames[optList][guid]
							if not frame then
								--Try to find frame or set 0 to skip calls for players not on frames (i.e. 6-8 groups)
								--Reset db every 20 sec or 1 sec after GROUP_ROSTER_UPDATE
								frame = LGF.GetFrame(guid, optList) or 0
								ATFFrames[optList][guid] = frame
							end
							if frame ~= 0 then
								if not prevLineForGUID_wiped then
									prevLineForGUID_wiped = true
									wipe(prevLineForGUID)
								end

								local prevBar = prevLineForGUID[guid]
								if prevBar then
									bar.ATFcounter = prevBar.ATFcounter + 1
									if bar.ATFcounter > col.ATFMax then
										if bar.atf ~= 0 then
											bar:ClearAllPoints()
											bar:SetPoint("RIGHT",UIParent,"LEFT",-2000,0)
											bar.atf = 0
										end
									elseif (bar.ATFcounter - 1) % col.ATFCol == 0 then
										if bar.atf ~= 1 or bar.atf2 ~= prevBar.ATFPrevLine then
											bar:ClearAllPoints()
											bar:SetPoint(col.ATFPointLine1,prevBar.ATFPrevLine,col.ATFPointLine2,0,col.ATFBetweenLinesLine)
											bar.atf = 1
											bar.atf2 = prevBar.ATFPrevLine
										end
										bar.ATFPrevLine = bar
									else
										if bar.atf ~= 2 or bar.atf2 ~= prevBar then
											bar:ClearAllPoints()
											bar:SetPoint(col.ATFPointCol1,prevBar,col.ATFPointCol2,col.ATFBetweenLinesCol,0)
											bar.atf = 2
											bar.atf2 = prevBar
										end
										bar.ATFPrevLine = prevBar.ATFPrevLine
									end
								else
									bar.ATFcounter = 1
									if bar.atf ~= 3 or bar.atf2 ~= frame then
										bar:ClearAllPoints()
										bar:SetPoint(col.ATFPoint1,frame,col.ATFPoint2,col.ATFOffsetX,col.ATFOffsetY)
										bar.atf = 3
										bar.atf2 = frame
									end
									bar.ATFPrevLine = bar
								end
								prevLineForGUID[guid] = bar

								if col.autoStrata then
									local strata = frame:GetFrameStrata()
									if strata ~= col.FrameStrata then
										col:SetFrameStrata(strataToStrata[strata] or strata)
										col.FrameStrata = strata
									end
								end
							else
								if bar.atf ~= 0 then
									bar:ClearAllPoints()
									bar:SetPoint("RIGHT",UIParent,"LEFT",-2000,0)
									bar.atf = 0
								end
							end
						end
					end
				end
			end
		end

		saveDataTimer = saveDataTimer + elapsed
		if saveDataTimer > 2 then
			saveDataTimer = saveDataTimer % 2
			SaveCDtoVar()
		end
	end
end

local function GetNumGroupMembersFix() 
	local n = GetNumGroupMembers() or 0
	if module.db.testMode then
		return 20
	elseif n == 0 and VMRT.ExCD2.NoRaid then 
		return 1
	else
		return n
	end
end

local function GetRaidRosterInfoFix(j) 
	local name, rank, subgroup, level, class, classFileName, zone, online, isDead, role, isML = GetRaidRosterInfo(j)
	if j == 1 and not name and VMRT.ExCD2.NoRaid then
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
		for unitName, specID in pairs(VMRT.ExCD2.gnGUIDs) do
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

local function RaidResurrectSpecialCheck()
	local _,_,difficulty = GetInstanceInfo()
	if difficulty == 14 or difficulty == 15 or difficulty == 16 or difficulty == 7 or difficulty == 17 or difficulty == 8 then
		return true
	end
end
local function RaidResurrectSpecialText()
	local charges, maxCharges, started, duration = GetSpellCharges(20484)
	if (charges or 0) > 1 then
		return " ("..charges..")"
	end
end
local function RaidResurrectSpecialStatus()
	local charges, maxCharges, started, duration = GetSpellCharges(20484)
	if charges then
		if charges > 0 then
			return false,started,duration,true
		else
			return true,started,duration,false
		end
	end
end

local function StartAfterCombat_SpecialStatus(data)
	if data.disable_oncd then
		return true,0,0,nil,true
	end
end
local function StartAfterCombat_SpecialStart(data)
	if data.disable_ticker then
		data.disable_ticker:Cancel()
		data.disable_ticker = nil
		data.disable_oncd = nil
	end

	if UnitAffectingCombat(data.fullName) then
		data.disable_oncd = true
		data.disable_ticker = C_Timer.NewTicker(1,function(self)
			if not UnitAffectingCombat(data.fullName) then
				self.count = (self.count or 0) + 1
			end
			if self.count and self.count >= 3 then
				self:Cancel()
				data.disable_ticker = nil
				data.disable_oncd = nil
				data.lastUse = GetTime()
				if data.bar and data.bar.data == data then
					data.bar:UpdateStatus()
				end
			end
		end)
	end
end
local function StartAfterCombat_SpecialAfterCombatReset(data)
	if data.disable_ticker then
		data.disable_ticker:Cancel()
		data.disable_ticker = nil
		data.disable_oncd = nil
	end
end

local lineFuncs = {
	ChangeCD = function(line,time,delayUpdate)
		line.cd = line.cd + time
		if line.cd < 0 then 
			line.cd = 0 
		end
		if line.bar and line.bar.data == line then
			line.bar:UpdateStatus()
		end
		if not delayUpdate then
			UpdateAllData()
		end
	end,
	ReduceCD = function(line,time,delayUpdate)
		line.lastUse = line.lastUse - time
		if line.charge then
			line.charge = line.charge - time
		end
		if time > 0 then
			line.duration = line.duration + time
		end
		if line.bar and line.bar.data == line then
			line.bar:UpdateStatus()
		end
		if not delayUpdate then
			UpdateAllData()
		end
	end,
	SetCD = function(line,time,delayUpdate)
		line.cd = time
		if line.cd < 0 then 
			line.cd = 0 
		end
		if line.bar and line.bar.data == line then
			line.bar:UpdateStatus()
		end
		if not delayUpdate then
			UpdateAllData()
		end
	end,
	SetCDSynq = function(line,time,delayUpdate)
		if time == 0 then
			return line:ResetCD(delayUpdate)
		end
		local new = GetTime() - line.cd + time
		if not line.lastUse or abs(line.lastUse - new) > 1 then
			line.lastUse = new
		end
		if line.bar and line.bar.data == line then
			line.bar:UpdateStatus()
		end
		if not delayUpdate then
			UpdateAllData()
		end
	end,
	ModCD = function(line,modVal,delayUpdate)
		if type(modVal) == "number" then
			line.cd = line.cd + modVal
		elseif type(modVal) == "string" then
			line.cd = line.cd * tonumber( modVal:sub(2) )
		end
		if line.cd < 0 then 
			line.cd = 0 
		end
		if line.bar and line.bar.data == line then
			line.bar:UpdateStatus()
		end
		if not delayUpdate then
			UpdateAllData()
		end
	end,
	ResetCD = function(line,delayUpdate)
		line.lastUse = 0
		if line.charge then
			line.charge = 0
		end
		if line.bar and line.bar.data == line then
			line.bar:UpdateStatus()
		end
		if not delayUpdate then
			UpdateAllData()
		end
	end,
	ChangeDur = function(line,time,delayUpdate)
		line.duration = line.duration + time
		if line.duration < 0 then 
			line.duration = 0 
		end
		if line.bar and line.bar.data == line then
			line.bar:UpdateStatus()
		end
		if not delayUpdate then
			UpdateAllData()
		end
	end,
	SetDur = function(line,time,delayUpdate)
		line.duration = time
		if line.duration < 0 then 
			line.duration = 0 
		end
		if line.bar and line.bar.data == line then
			line.bar:UpdateStatus()
		end
		if not delayUpdate then
			UpdateAllData()
		end
	end,
}

local function UpdateRoster()
	wipe(status_UnitsToCheck)
	wipe(status_UnitIsDead)
	wipe(status_UnitIsDisconnected)
	wipe(status_UnitIsOutOfRange)

	wipe(_db.vars.isWarlock)
	wipe(_db.vars.isRogue)
	wipe(_db.vars.isPaladin)
	wipe(_db.vars.isMage)

	local n = GetNumGroupMembersFix()
	if n > 0 then
		local priorCounter = 0
		local priorNamesToNumber = {}
		if not _db.testMode then
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
				for i,spellData in ipairs(_db.spellDB) do
					local SpellID = spellData[1]
					local AddThisSpell = true
					if level < 60 or ExRT.isLK then
						local spellLevel = GetSpellLevelLearned(SpellID)
						if level < (spellLevel or 0) then
							AddThisSpell = false
						end
					end
					if _db.spell_isRacial[ SpellID ] and race ~= _db.spell_isRacial[ SpellID ] then
						AddThisSpell = false
					end
					if not GetSpellInfo(SpellID) then	--non exist, removed spells
						AddThisSpell = false
					end
					local spellClass,spellClass2 = strsplit(",",spellData[2])
					if spellClass == "COVENANTS" then
						spellClass = spellClass2
					end
					if not ExRT.GDB.ClassID[spellClass] and spellClass ~= "NO" then
						spellClass = "ALL"
					end

					if AddThisSpell and (spellClass == class or spellClass == "ALL") and (not spellData.specialCheck or spellData.specialCheck(SpellID,name,class,race)) then
						if not ExRT.F.table_find(status_UnitsToCheck,name) then
							status_UnitsToCheck[#status_UnitsToCheck + 1] = name

							status_UnitIsDead[ name ] = isDead
							status_UnitIsDisconnected[ name ] = not online

							local inRange,isRange = UnitInRange(name)
							status_UnitIsOutOfRange[ name ] = isRange and not inRange
						end 

						module:AddCLEUSpellDamage(SpellID)

						local alreadyInCds = nil
						priorCounter = priorCounter + 1

						local _specID = globalGUIDs[name] or 0
						local uSpecID = _db.specInDBase[_specID] or 4
						local spellColumn = VMRT.ExCD2.CDECol[SpellID..";"..(uSpecID-3)] or VMRT.ExCD2.CDECol[SpellID..";1"] or _db.def_col[SpellID..";"..(uSpecID-3)] or _db.def_col[SpellID..";1"] or spellData[3] or 1

						local getSpellColumn = module.frame.colFrame[spellColumn]
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
							prior = (VMRT.ExCD2.Priority[SpellID] or 50) * 1000000000000 + (SpellID or 0) * 1000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 2 then
							prior = (VMRT.ExCD2.Priority[SpellID] or 50) * 1000000000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000000000 + (SpellID or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 3 then
							prior = (VMRT.ExCD2.Priority[SpellID] or 50) * 100000000000000 + (ExRT.F.table_find(_db.classNames,class) or 0) * 1000000000000 + (SpellID or 0) * 1000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 4 then
							prior = (VMRT.ExCD2.Priority[SpellID] or 50) * 100000000000000 + (ExRT.F.table_find(_db.classNames,class) or 0) * 1000000000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000000000 + (SpellID or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 5 then
							prior = (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 1000000000000 + (VMRT.ExCD2.Priority[SpellID] or 50) * 10000000000 + (SpellID or 0) * 10000 + priorCounter
						elseif getSpellColumn.methodsSortingRules == 6 then
							prior = (ExRT.F.table_find(_db.classNames,class) or 0) * 100000000000000 + (VMRT.ExCD2.Priority[SpellID] or 50) * 1000000000000 + (ExRT.F.table_find(priorNamesToNumber,name) or 0) * 10000000000 + (SpellID or 0) * 10000 + priorCounter
						end
						local secondPrior = (VMRT.ExCD2.Priority[SpellID] or 50) * 1000000 + (SpellID or 0)	--used in columns with option 'new spell - new line'

						local sName = format("%s%d",name or "?",SpellID or 0)
						local lastUse,nowCd = 0,0
						if VMRT.ExCD2.Save[sName] and NumberInRange(VMRT.ExCD2.Save[sName][1] + VMRT.ExCD2.Save[sName][2] - GetTime(),0,2000,false,true) then
							lastUse,nowCd = VMRT.ExCD2.Save[sName][1],VMRT.ExCD2.Save[sName][2]
						end

						local spellName,_,spellTexture = GetSpellInfo(SpellID)
						spellTexture = spellTexture or "Interface\\Icons\\INV_MISC_QUESTIONMARK"
						spellName = spellName or "unk"
						local shownName = DelUnitNameServer(name)

						if _db.differentIcons[SpellID] then
							spellTexture = _db.differentIcons[SpellID]
						end

						for l=4,8 do
							if spellData[l] then
								local h = ExRT.isClassic and _db.cdsNav[name][GetSpellInfo(spellData[l][1])] or _db.cdsNav[name][spellData[l][1]]
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
									h.guid = h.guid or UnitGUID(name)

									alreadyInCds = true

									if spellClass == "WARLOCK" and h.guid then
										_db.vars.isWarlock[h.guid] = true
									elseif spellClass == "ROGUE" and h.guid then
										_db.vars.isRogue[h.guid] = true
									elseif spellClass == "PALADIN" and h.guid then
										_db.vars.isPaladin[h.guid] = true
									elseif spellClass == "MAGE" and h.guid then
										_db.vars.isMage[h.guid] = true
									end
								end
							end
						end

						if not alreadyInCds then
							local guid = UnitGUID(name)

							local new = {
								name = shownName,
								fullName = name,
								loweredName = shownName:lower(),
								icon = spellTexture,
								spellName = spellName,
								db = spellData,
								lastUse = lastUse,
								cd = nowCd,
								duration = 0,
								classColor = classColorsTable[class] or _db.notAClass,
								sort = prior,
								sort2 = secondPrior,
								column = spellColumn,
								guid = guid,
							}
							_C [#_C + 1] = new

							if 
								SpellID == 323436 or --Kyrian pot
								SpellID == 6262 --Healthstone
							then
								new.specialStatus = StartAfterCombat_SpecialStatus
								new.specialStart = StartAfterCombat_SpecialStart
								new.specialAfterCombatReset = StartAfterCombat_SpecialAfterCombatReset
							end

							if spellClass == "WARLOCK" and guid then
								_db.vars.isWarlock[guid] = true
							elseif spellClass == "ROGUE" and guid then
								_db.vars.isRogue[guid] = true
							elseif spellClass == "PALADIN" and guid then
								_db.vars.isPaladin[guid] = true
							elseif spellClass == "MAGE" and guid then
								_db.vars.isMage[guid] = true
							end
						end
					end
				end
				_db.session_gGUIDs[name] = 1
				if isInRaid then
					module.main:UNIT_PET("raid"..j)
				end
			end
		end

		--WOD Raid resurrect
		if not ExRT.isClassic then
			local findResSpell = ExRT.F.table_find(_db.spellDB,161642,1)
			if findResSpell then
				local spellData = _db.spellDB[findResSpell]
				local h = _db.cdsNav["*"][spellData[4][1]]
				local prior = 0

				priorCounter = priorCounter + 1

				local spellColumn = VMRT.ExCD2.CDECol["161642;1"] or _db.def_col["161642;1"] or spellData[3] or 1
				local getSpellColumn = module.frame.colFrame[spellColumn]
				if not getSpellColumn or getSpellColumn.methodsSortingRules == 1 then
					prior = (VMRT.ExCD2.Priority[161642] or 50) * 1000000000000 + 161642 * 1000000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 2 then
					prior = (VMRT.ExCD2.Priority[161642] or 50) * 1000000000000 + 161642 * 10000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 3 then
					prior = (VMRT.ExCD2.Priority[161642] or 50) * 100000000000000 + 161642 * 1000000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 4 then
					prior = (VMRT.ExCD2.Priority[161642] or 50) * 100000000000000 + 161642 * 10000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 5 then
					prior = (VMRT.ExCD2.Priority[161642] or 50) * 10000000000 + 161642 * 10000 + priorCounter
				elseif getSpellColumn.methodsSortingRules == 6 then
					prior = (VMRT.ExCD2.Priority[161642] or 50) * 1000000000000 + 161642 * 10000 + priorCounter
				end
				local secondPrior = (VMRT.ExCD2.Priority[161642] or 50) * 1000000 + (161642 or 0)

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
						classColor = _db.notAClass,
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
				_db.session_gGUIDs["*"] = 1
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
				for k,v in pairs(lineFuncs) do
					line[k] = v
				end
				cdsNav_set(line.fullName,line.db[1],line)
				for l=4,8 do 
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

		for i=1,2 do
			local offline = status_UnitsToCheck[fastrandom(1,#status_UnitsToCheck)]
			status_UnitIsDisconnected[offline] = true
	
			local dead = status_UnitsToCheck[fastrandom(1,#status_UnitsToCheck)]
			status_UnitIsDead[dead] = true
		end

		for j=#status_UnitsToCheck,1,-1 do
			if not UnitName(status_UnitsToCheck[j]) then
				tremove(status_UnitsToCheck, j)
			end
		end

		for i=#_C,1,-1 do
			local col = _C[i].column
			if not (module.frame.colFrame[col] and module.frame.colFrame[col]:IsShown()) then
				tremove(_C, i)
			end
		end
		while #_C > 300 do
			tremove(_C, math.random(1,#_C))
		end
	end
	UpdateAllData()
end
module.UpdateRoster = UpdateRoster

do
	local function DispellSchedule(data)
		if not _db.spell_dispellsFix[ data.fullName ] then
			data:SetCD(0)
		end
		_db.spell_dispellsFix[ data.fullName ] = nil
	end
	local function IsAuraActive(unit,spellID)
		for i=1,60 do
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

		local uSpecID = _db.specInDBase[globalGUIDs[fullName] or 0]
		if not data.db[uSpecID] and not data.db[4] then
			return
		elseif not data.db[uSpecID] then
			uSpecID = 4
		end
		local spellID = data.db[uSpecID][1]
		--Raid Battle Res
		if _db.spell_battleRes[spellID] and _db.isResurectDisabled then
			return
		end

		--Ignore same use
		if _db.spellIgnoreAfterFirstUse[spellID] and data.lastUse then
			local t = _db.spellIgnoreAfterFirstUse[spellID]
			if currTime - data.lastUse <= t then
				return
			end
		end

		data.cd = data.db[uSpecID][2]
		data.duration = data.db[uSpecID][3]

		--Talents / Glyphs
		local durationTable = _db.spell_durationByTalent_fix[spellID]
		if durationTable then
			for j=1,#durationTable,2 do
				local talentSpellID = durationTable[j]
				local session_gGUID = _db.session_gGUIDs[fullName][talentSpellID]
				if session_gGUID and (not _db.spell_isPvpTalent[talentSpellID] or module.IsPvpTalentsOn(fullName)) then
					local timeReduce = durationTable[j+1]
					if type(timeReduce) == 'table' and ExRT.isClassic then
						local talent_rank = _db.talent_classic_rank[fullName][talentSpellID] or #timeReduce
						timeReduce = timeReduce[talent_rank] or timeReduce[1]
					elseif type(timeReduce) == 'table' and #timeReduce <= 5 then
						local talent_rank = _db.talent_classic_rank[fullName][talentSpellID] or #timeReduce
						timeReduce = timeReduce[talent_rank] or timeReduce[#timeReduce]
					elseif type(timeReduce) == 'table' then
						local soulbind_rank = _db.soulbind_rank[fullName][talentSpellID] or SOULBIND_DEF_RANK_NOW
						timeReduce = timeReduce[soulbind_rank]
					end
					local mod = type(session_gGUID) == "table" and session_gGUID[1] or 1
					if tonumber(timeReduce) then
						data.duration = data.duration + timeReduce * mod
					else
						local timeFix = tonumber( string.sub( timeReduce, 2 ) )
						data.duration = data.duration * timeFix * mod
					end
				end
			end
		end
		local cdTable = _db.spell_cdByTalent_fix[spellID]
		if cdTable then
			for j=1,#cdTable,2 do
				local talentSpellID = cdTable[j]
				local passSpecCheck = true
				if type(talentSpellID) == "table" then
					local specReduceCD = talentSpellID[2]
					if (not specReduceCD or (specReduceCD < 0 and globalGUIDs[fullName] ~= specReduceCD or globalGUIDs[fullName] == specReduceCD)) then
						passSpecCheck = true
					else
						passSpecCheck = false
					end
					talentSpellID = talentSpellID[1]
				end
				local session_gGUID = _db.session_gGUIDs[fullName][talentSpellID]
				if session_gGUID and passSpecCheck and (not _db.spell_isPvpTalent[talentSpellID] or module.IsPvpTalentsOn(fullName)) then
					local timeReduce
					if _db.spell_cdByTalent_isScalable[talentSpellID] then
						local scale_data = _db.spell_cdByTalent_scalable_data[talentSpellID]
						timeReduce = scale_data[fullName] or scale_data[1]
					else
						timeReduce = cdTable[j+1]
						if type(timeReduce) == 'table' and ExRT.isClassic then
							local talent_rank = _db.talent_classic_rank[fullName][talentSpellID] or #timeReduce
							timeReduce = timeReduce[talent_rank] or timeReduce[1]
						elseif type(timeReduce) == 'table' and #timeReduce <= 5 then
							if timeReduce[2] > 1000 then
								if IsAuraActive(fullName,timeReduce[2]) then
									timeReduce = timeReduce[1]
								else
									timeReduce = 0
								end
							else
								local talent_rank = _db.talent_classic_rank[fullName][talentSpellID] or #timeReduce
								timeReduce = timeReduce[talent_rank] or timeReduce[#timeReduce]
							end
						elseif type(timeReduce) == 'table' then
							local soulbind_rank = _db.soulbind_rank[fullName][talentSpellID] or SOULBIND_DEF_RANK_NOW
							timeReduce = timeReduce[soulbind_rank]
						end
					end
					local mod = type(session_gGUID) == "table" and session_gGUID[1] or 1
					if tonumber(timeReduce) then
						data.cd = data.cd + timeReduce * mod
					else
						local timeFix = tonumber( string.sub( timeReduce, 2 ) )
						data.cd = data.cd * timeFix * mod
					end
				end
			end
		end
		local cdAura = _db.spell_reduceCdByAura[spellID]
		if cdAura then
			for j=1,#cdAura,2 do
				local auraID = cdAura[j]
				if type(auraID) == "table" then
					if _db.session_gGUIDs[fullName][ auraID[2] ] and (not _db.spell_isPvpTalent[ auraID[2] ] or module.IsPvpTalentsOn(fullName)) then
						auraID = auraID[1]
					else
						auraID = nil
					end
				end
				if auraID and IsAuraActive(fullName,auraID) then
					local timeReduce = cdAura[j+1]
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
		local isCharge = _db.spell_charge_fix[ data.db[1] ]
		if isCharge and _db.spell_isPvpTalent[isCharge] and not module.IsPvpTalentsOn(fullName) then
			isCharge = false
		end
		if isCharge and (data.lastUse+data.cd) >= currTime then
			data.charge = (data.charge or data.lastUse) + data.cd
			data.lastUse = currTime
			_db.session_gGUIDs[fullName] = isCharge
		elseif isCharge and _db.session_gGUIDs[fullName][isCharge] then
			data.charge = currTime
			data.lastUse = currTime
		else
			data.lastUse = currTime
		end
		--Haste/Readiness
		if _db.spell_speed_list[spellID] then
			data.duration = data.duration / (1 + (UnitSpellHaste(fullName) or 0) /100)
		end
		if _db.spell_reduceCdByHaste[spellID] then
			data.cd = data.cd / (1 + (UnitSpellHaste(fullName) or 0) /100) 
		end
		--Dispels
		if _db.spell_dispellsList[spellID] then
			ScheduleTimer(DispellSchedule, 0.5, data)
		end
		-- Fixes
		if data.cd > 45000 then data.cd = 45000 end
		if data.duration > 45000 then data.duration = 45000 end

		if data.specialStart then
			data.specialStart(data)
		end

		if data.bar and data.bar.data == data then
			data.bar:UpdateStatus()
		end

		UpdateAllData()

		_db.historyUsage[#_db.historyUsage + 1] = {time(),data.db[uSpecID][1],fullName,GetEncounterTime()}
	end
	module.CLEUstartCD = CLEUstartCD
end

do
	local IGNORE_PROFILE_KEYS = {
		["Profiles"] = true,
	}
	function module:SaveCurrentProfiletoDB()
		local profileName = VMRT.ExCD2.Profiles.Now

		local saveDB = {}
		VMRT.ExCD2.Profiles.List[ profileName ] = saveDB

		for key,val in pairs(VMRT.ExCD2) do
			if not IGNORE_PROFILE_KEYS[key] then
				if type(val) == "table" then
					saveDB[key] = ExRT.F.table_copy2(val)
				else
					saveDB[key] = val
				end
			end
		end
	end
	function module:SelectProfile(name)
		if name == VMRT.ExCD2.Profiles.Now or not name then
			return
		end
		if not VMRT.ExCD2.Profiles.List[name] then
			return
		end
		module:SaveCurrentProfiletoDB()

		local savedKeys = {}
		for key in pairs(IGNORE_PROFILE_KEYS) do
			if VMRT.ExCD2[key] then
				savedKeys[key] = VMRT.ExCD2[key]
			end
		end
		ExRT.F.table_rewrite(VMRT.ExCD2,VMRT.ExCD2.Profiles.List[name])
		for key,val in pairs(savedKeys) do
			VMRT.ExCD2[key] = val
		end

		VMRT.ExCD2.Profiles.Now = name

		module:ReloadProfile()

		VMRT.ExCD2.Profiles.List[name] = nil	--remove data only if reload is successful

		return true
	end
	function module:ReloadProfile()
		module.main:ADDON_LOADED()
		if module.options.isLoaded then
			module.options.chkLock:SetChecked(VMRT.ExCD2.lock)
			module.options.chkEnable:SetChecked(VMRT.ExCD2.enabled)
			module.options.chkEnable:ColorState()
			module.options.chkSplit:SetChecked(VMRT.ExCD2.SplitOpt)
			module.options.chkNoRaid:SetChecked(VMRT.ExCD2.NoRaid)
			module.options.categories:Update()
			module.options.categories.buttons[1]:Click()
			module.options.optColTabs.tabs[module.db.maxColumns+3].currentName:UpdateText()
			module.options.optColTabs.tabs[module.db.maxColumns+3]:UpdateAutoTexts()
			if module.options.optColTabs.selected <= module.db.maxColumns + 1 then
				module.options:selectColumnTab()
			end
		end
	end

	function module:CheckZoneProfiles()
		local _, zoneType = GetInstanceInfo()

		if zoneType == "arena" then
			if VMRT.ExCD2.Profiles.Arena then
				module:SelectProfile(VMRT.ExCD2.Profiles.Arena)
			end
		elseif zoneType == "party" then
			if VMRT.ExCD2.Profiles.Dung then
				module:SelectProfile(VMRT.ExCD2.Profiles.Dung)
			end
		elseif zoneType == "raid" then
			if VMRT.ExCD2.Profiles.Raid then
				module:SelectProfile(VMRT.ExCD2.Profiles.Raid)
			end
		elseif zoneType == "pvp" then
			if VMRT.ExCD2.Profiles.BG then
				module:SelectProfile(VMRT.ExCD2.Profiles.BG)
			end
		else
			if VMRT.ExCD2.Profiles.Other then
				module:SelectProfile(VMRT.ExCD2.Profiles.Other)
			end
		end
	end
end

function module:Enable()
	VMRT.ExCD2.enabled = true
	module.frame.IsEnabled = true

	module:UpdateLockState()
	module:SplitExCD2Window() 
	module:ReloadAllSplits()

	module:RegisterTimer()
	module:RegisterEvents('SCENARIO_UPDATE','GROUP_ROSTER_UPDATE','COMBAT_LOG_EVENT_UNFILTERED','UNIT_PET','PLAYER_LOGOUT','CHALLENGE_MODE_RESET','PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END')

	module:CreateSpellDB()

	module:ApplyHotfixes()

	UpdateRoster()

	module.main:ZONE_CHANGED_NEW_AREA()

	module:RegisterAddonMessage()
end

function module:Disable()
	VMRT.ExCD2.enabled = nil
	module.frame.IsEnabled = false
	if not VMRT.ExCD2.SplitOpt then 
		module.frame:Hide()
	else
		for i=1,module.db.maxColumns do 
			module.frame.colFrame[i]:Hide()
		end 
	end

	module:UnregisterTimer()
	module:UnregisterEvents('SCENARIO_UPDATE','GROUP_ROSTER_UPDATE','COMBAT_LOG_EVENT_UNFILTERED','UNIT_PET','PLAYER_LOGOUT','CHALLENGE_MODE_RESET','PLAYER_REGEN_DISABLED','PLAYER_REGEN_ENABLED','ENCOUNTER_START','ENCOUNTER_END','ARENA_COOLDOWNS_UPDATE','UNIT_AURA')

	module:UnregisterAddonMessage()
end

function module:IsEnabled()
	if module.frame.IsEnabled then
		return true
	else
		return false
	end
end

local NewVMRTTableData = {
	NoRaid = true,
	upd4380 = true,
	upd4525 = true,
}

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.ExCD2 = VMRT.ExCD2 or ExRT.F.table_copy2(NewVMRTTableData)

	VMRT.ExCD2.Profiles = VMRT.ExCD2.Profiles or {}
	VMRT.ExCD2.Profiles.List = VMRT.ExCD2.Profiles.List or {}
	VMRT.ExCD2.Profiles.Now = VMRT.ExCD2.Profiles.Now or "default"

	if VMRT.Addon.Version < 4235 then
		if VMRT.ExCD2.Priority then
			for k,v in pairs(VMRT.ExCD2.Priority) do
				if type(v) == 'number' then
					VMRT.ExCD2.Priority[k] = floor((v - 1) / 29 * 100)
				end
			end
		end
	end
	if VMRT.Addon.Version < 4240 then
		if VMRT.ExCD2.userDB then
			for i=#VMRT.ExCD2.userDB,1,-1 do
				for j=1,#module.db.AllSpells do
					if module.db.AllSpells[j][1] == VMRT.ExCD2.userDB[i][1] then
						tremove(VMRT.ExCD2.userDB,i)
						break
					end
				end
			end
			for i=1,#VMRT.ExCD2.userDB do
				if type(VMRT.ExCD2.userDB[i][3]) ~= "number" then
					for j=8,4,-1 do
						VMRT.ExCD2.userDB[i][j] = VMRT.ExCD2.userDB[i][j-1]
					end
					VMRT.ExCD2.userDB[i][3] = 1
				end
			end
		end
		VMRT.ExCD2.default_userCD = nil
		VMRT.ExCD2.default_userDuration = nil
	end

	if VMRT.ExCD2.Left and VMRT.ExCD2.Top then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VMRT.ExCD2.Left,VMRT.ExCD2.Top)
	end

	VMRT.ExCD2.CDE = VMRT.ExCD2.CDE or {}
	VMRT.ExCD2.CDECol = VMRT.ExCD2.CDECol or {}

	if not VMRT.ExCD2.colSet then
		VMRT.ExCD2.colSet = {}
		for i=1,module.db.maxColumns+1 do
			VMRT.ExCD2.colSet[i] = {}
			for optName,optVal in pairs(module.db.colsInit) do
				VMRT.ExCD2.colSet[i][optName] = optVal
			end
			if i <= 3 then 
				VMRT.ExCD2.colSet[i].enabled = true
			end
		end
	end
	for i=1,module.db.maxColumns+1 do
		VMRT.ExCD2.colSet[i] = VMRT.ExCD2.colSet[i] or {}
	end

	if not VMRT.ExCD2.upd4380 then
		for i=1,module.db.maxColumns+1 do
			local colSet = VMRT.ExCD2.colSet[i]
			colSet.methodsSortByAvailability = VMRT.ExCD2.SortByAvailability
			colSet.methodsSortActiveToTop = VMRT.ExCD2.SortByAvailabilityActiveToTop
			colSet.methodsReverseSorting = VMRT.ExCD2.ReverseSorting
		end
		VMRT.ExCD2.upd4380 = true
	end
	if not VMRT.ExCD2.upd4525 then
		for i=1,module.db.maxColumns do
			local colSet = VMRT.ExCD2.colSet[i]
			if colSet.ATF then
				colSet.frameStrata = nil
			end
		end
		VMRT.ExCD2.upd4525 = true
	end

	VMRT.ExCD2.userDB = VMRT.ExCD2.userDB or {}

	VMRT.ExCD2.Priority = VMRT.ExCD2.Priority or {}

	VMRT.ExCD2.gnGUIDs = VMRT.ExCD2.gnGUIDs or {}
	if VMRT.ExCD2.gnGUIDs and ExRT.F.table_len(VMRT.ExCD2.gnGUIDs) > 500 then
		wipe(VMRT.ExCD2.gnGUIDs)
	end
	globalGUIDs = VMRT.ExCD2.gnGUIDs

	VMRT.ExCD2.OptFav = VMRT.ExCD2.OptFav or {}

	VMRT.ExCD2.Save = VMRT.ExCD2.Save or {}

	module:RegisterEvents('ZONE_CHANGED_NEW_AREA')
	if ExRT.isClassic then
		module:RegisterEvents('LOADING_SCREEN_DISABLED')
	end
	if not VMRT.ExCD2.enabled then
		module:Disable()
		C_Timer.After(2,module.CheckZoneProfiles)
	else
		module:Enable()
		ScheduleTimer(UpdateRoster,10)
		ScheduleTimer(module.ReloadAllSplits,10)
		module:RegisterEvents('PLAYER_ENTERING_WORLD')
	end

	for _ in pairs(module.db.spellCDSync) do
		module:RegisterEvents('SPELL_UPDATE_COOLDOWN')
		break
	end

	module:RegisterSlash()
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
		module:ATFFrameDataReset()
	end

	function module.main:GROUP_ROSTER_UPDATE()
		if not scheduledUpdateRoster then
			scheduledUpdateRoster = ScheduleTimer(funcScheduledUpdate,1)
		end
	end
end

do
	local scheduledUpdateRoster = nil
	local function funcScheduledUpdate()
		scheduledUpdateRoster = nil
		if not module:IsEnabled() then	--module can be disabled after function already scheduled
			return
		end
		UpdateRoster()
	end

	local prevDiffID

	local scheduledVisibility = nil
	local function funcScheduledVisibility()
		scheduledVisibility = nil
		if not module:IsEnabled() then	--module can be disabled after function already scheduled
			return
		end
		module:updateCombatVisibility()

		local _,_,diff = GetInstanceInfo()
		if diff ~= prevDiffID then
			if diff == 167 then --Torghast
				module:ClearFullSessionDataReason("torghast")
				module:RegisterEvents('UNIT_AURA')
			elseif prevDiffID == 167 then
				module:UnregisterEvents('UNIT_AURA')
				module:ClearFullSessionDataReason("torghast")
			end
			prevDiffID = diff
		end
	end

	function module.main:ZONE_CHANGED_NEW_AREA()
		C_Timer.After(1,module.CheckZoneProfiles)

		if module:IsEnabled() then
			if select(2, IsInInstance()) == "arena" then
				AfterCombatResetFunction(true)
				UpdateAllData()
			end
			if not scheduledVisibility then
				scheduledVisibility = ScheduleTimer(funcScheduledVisibility,2)
			end
			if not scheduledUpdateRoster then
				scheduledUpdateRoster = ScheduleTimer(funcScheduledUpdate,10)
			end
		end
	end
	module.main.LOADING_SCREEN_DISABLED = module.main.ZONE_CHANGED_NEW_AREA
end

do
	local prevStart,prevDur = {},{}
	local str
	function module.main:SPELL_UPDATE_COOLDOWN()
		for _,spellID in pairs(module.db.spellCDSync) do
			local start, duration = GetSpellCooldown(spellID)
			if (start ~= prevStart[spellID] or duration ~= prevDur[spellID]) and (duration == 0 or duration > 2) then
				prevStart[spellID] = start
				prevDur[spellID] = duration
				if duration > 2 then
					str = (str or "") .. spellID .. ":" .. floor(start + duration - GetTime()) .. ";"
				elseif duration == 0 then
					str = (str or "") .. spellID .. ":0;"
				end
			end
		end
		if str then
			str = str:sub(1,-2)
			ExRT.F.SendExMsg("rcd","SQ\t"..str)
			str = nil
		end
	end

	local CDList = _db.cdsNav
	function module:addonMessage(sender, prefix, subPrefix, ...)
		if prefix == "rcd" then
			if subPrefix == "SQ" then
				--print(sender, prefix, subPrefix, ...)
				local str = ...
				local senderFull = sender
				sender = strsplit("-",sender)

				local updateReq

				while str do
					local main,next = strsplit(";",str,2)
					str = next

					if main then
						local spellID,spellCD = strsplit(":",main)
						spellID = tonumber(spellID or "")
						spellCD = tonumber(spellCD or "")

						if spellID and spellCD then
							local line = CDList[sender][spellID]
							if line then
								line:SetCDSynq(spellCD,true)
								--print('update',sender,spellID,spellCD)
								updateReq = true
							end
						end
					end
				end

				if updateReq then
					UpdateAllData()
				end
			end
		end
	end
end

local FD_GUIDs = {}
local ScheduledUnitAura
function module.main:UNIT_AURA(unitID)
	local isInTorghast = IsInJailersTower()
	if isInTorghast then
		local name,realm = UnitName(unitID)
		if realm then
			name = name .. "-" .. realm
		end
		--cooldownsModule:ClearSessionDataReason(name,"torghast")
		for i=1,60 do
			local _, _, count, _, _, _, _, _, _, spellId = UnitAura(unitID, i, "MAW")
			if not spellId then
				break
			else
				if count and count < 2 then
					count = nil
				end
				_db.session_gGUIDs[name] = {spellId,"torghast",count}
			end
		end
	end
	local guid = UnitGUID(unitID)
	if guid and FD_GUIDs[guid] then
		local FD_Found
		for i=1,60 do
			local _, _, _, _, _, _, _, _, _, spellId = UnitAura(unitID, i)
			if not spellId then
				break
			elseif spellId == 5384 then
				FD_Found = true
			end
		end
		if not FD_Found then
			local line = _db.cdsNav[UnitName(unitID)][5384]
			if ExRT.isClassic and not line then
				line = _db.cdsNav[UnitName(unitID)][GetSpellInfo(5384)]
			end
			if line then
				CLEUstartCD(line)
			end

			FD_GUIDs[guid] = nil
			if not isInTorghast then
				local anyFound
				for _ in pairs(FD_GUIDs) do
					anyFound = true
					break
				end
				if not anyFound then
					if ScheduledUnitAura then
						ScheduledUnitAura:Cancel()
						ScheduledUnitAura = nil
					end
					module:UnregisterEvents("UNIT_AURA")
				end
			end
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
	if encounterID == 1866 or encounterID == 2334 then
		module.db.disableCDresetting = true
	end
end
function module.main:ENCOUNTER_END(encounterID, encounterName, difficultyID, groupSize, success)
	if encounterID == 1866 or encounterID == 2334 then
		module.db.disableCDresetting = nil
	end
end

local hotfixTableNameToType = {
	AllSpells = 1,
	spell_charge_fix = 2,
	spell_talentReplaceOther = 2,
	spell_aura_list = 2,
	spell_durationByTalent_fix = 3,
	spell_cdByTalent_fix = 3,
	spell_speed_list = 2,
	spell_afterCombatReset = 2,
	spell_afterCombatNotReset = 2,
	spell_reduceCdByHaste = 2,
	spell_resetOtherSpells = 3,
	spell_sharingCD = 4,
	spell_runningSameSpell = 3,
	spell_reduceCdCast = 3,
	spell_increaseDurationCast = 3,
	spell_dispellsList = 2,
	spell_startCDbyAuraFade = 2,
	spell_startCDbyAuraFadeExt = 2,
	spell_startCDbyAuraApplied = 2,
	spell_reduceCdByAuraFade = 3,
	spell_reduceCdByAuraFadeBefore = 3,
	spell_battleRes = 2,
	spell_isRacial = 2,
	differentIcons = 2,
	itemsToSpells = 2,
	spell_autoTalent = 2,
	spell_talentProvideAnotherTalents = 3,
	spell_isTalent = 2,
	spell_isPvpTalent = 2,
	findspecspells = 2,
	aura_grant_talent = 2,
}

function module:ApplyHotfixes()
	local text, line = VMRT.ExCD2.Hotfixes or ""
	line, text = strsplit("\n",text,2)
	while line do
		line = line:trim()
		local tableName = strsplit(":",line,2)
		if not tableName then

		elseif hotfixTableNameToType[tableName] == 1 or tonumber(tableName) then
			if tonumber(tableName) then line = ":"..line end
			local _,spellID,hotfixType,newData1,newData2 = strsplit(":",line)
			if newData1 then
				spellID = tonumber(spellID)
				if spellID then
					local data
					for i=1,#module.db.AllSpells do
						data = module.db.AllSpells[i]
						if data[1] == spellID then
							if hotfixType == "dur" then
								newData1 = tonumber(newData1)
								if newData1 then
									for j=4,8 do
										if data[j] then
											data[j][3] = newData1
										end
									end
								end
							elseif hotfixType == "cd" then
								newData1 = tonumber(newData1)
								if newData1 then
									for j=4,8 do
										if data[j] then
											data[j][2] = newData1
										end
									end
								end
							elseif hotfixType == "cleu" then
								newData1 = tonumber(newData1)
								if newData1 then
									for j=4,8 do
										if data[j] then
											data[j][1] = newData1
										end
									end
								end
							elseif tonumber(hotfixType) then
								if hotfixType < 4 then
									data[hotfixType] = tonumber(newData1) or newData1
								elseif data[hotfixType] then
									newData1 = tonumber(newData1)
									if newData1 and newData2 then
										data[hotfixType][newData1] = tonumber(newData2) or newData2
									end
								end
							end
							break
						end
					end
				end
			end 
		elseif tableName == "AllSpells2" then
			local _,spellID,specNum,cleu,cd,dur = strsplit(":",line,4)
			if dur then
				specNum = tonumber(specNum)
				spellID = tonumber(spellID)
				cleu = tonumber(cleu)
				cd = tonumber(cd)
				dur = tonumber(dur)
				if spellID and specNum and cleu and cd and dur then
					local data
					for i=1,#module.db.AllSpells do
						data = module.db.AllSpells[i]
						if data[1] == spellID then
							data[specNum+4] = {cleu,cd,dur}
							break
						end
					end
				end
			end
		elseif hotfixTableNameToType[tableName] == 2 then
			local _,key,var = strsplit(":",line)
			key = tonumber(key or "")
			if var == "true" then
				var = true
			elseif var == "false" then
				var = false
			else
				var = tonumber(var or "") or var
			end
			if key and var then
				module.db[tableName][key] = var
			end
		elseif hotfixTableNameToType[tableName] == 3 then
			local _,key,var = strsplit(":",line,3)
			key = tonumber(key or "")
			if key and var then
				local new = {}
				local v1,v2 = strsplit(",",var,2)
				while v1 do
					if v1:find(";") then
						local new2 = {}
						local b1,b2 = strsplit(";",v1,2)
						while b1 do
							if b1 == "false" then b1 = false end
							if b1 == "true" then b1 = true end
							new2[#new2+1] = tonumber(b1) or b1
							if not b2 then break end
							b1,b2 = strsplit(";",b2,2)
						end
						v1 = new2
					end
					if v1 == "false" then v1 = false end
					if v1 == "true" then v1 = true end
					new[#new+1] = tonumber(v1) or v1
					if not v2 then break end
					v1,v2 = strsplit(",",v2,2)
				end
				module.db[tableName][key] = new
			end
		elseif hotfixTableNameToType[tableName] == 4 then
			local _,key,var = strsplit(":",line,3)
			key = tonumber(key or "")
			if key and var then
				local new = {}
				local v1,v2 = strsplit(",",var,2)
				while v1 do
					local b1,b2 = strsplit(":",v1,2)
					b1 = tonumber(b1) or b1
					b2 = tonumber(b2) or b2
					if b1 and b2 then
						new[b1] = b2
					end
					if not v2 then break end
					v1,v2 = strsplit(",",v2,2)
				end
				module.db[tableName][key] = new
			end
		end
		if not text then
			break
		end
		line, text = strsplit("\n",text,2)
	end
end



do
	local eventsView = {}

	local function IsAuraActive(unit,spellID)
		for i=1,60 do
			local name,_,_,_,_,_,_,_,_,auraSpellID = UnitAura(unit,i)
			if spellID == auraSpellID then
				return true
			elseif not name then
				return
			end
		end
	end

	function module.main.COMBAT_LOG_EVENT_UNFILTERED(timestamp,event,...)
		local func = eventsView[event]
		if func then
			return func(timestamp,event,...)
		else
			return
		end
	end

	local env = {
		module = module,
		_db = _db,
		eventsView = eventsView,
		_C = _C,

		spell_startCDbyAuraApplied_fix = _db.spell_startCDbyAuraApplied_fix,
		spell_startCDbyAuraApplied = _db.spell_startCDbyAuraApplied,
		spell_aura_grant_talent = _db.aura_grant_talent,
		spell_isPetAbility = _db.spell_isPetAbility,
		spell_covenant = _db.spell_covenant,
		spell_startCDbyAuraFade = _db.spell_startCDbyAuraFade,
		spell_startCDbyAuraFadeExt = _db.spell_startCDbyAuraFadeExt,
		spell_isTalent = _db.spell_isTalent,
		spell_resetOtherSpells = _db.spell_resetOtherSpells,
		spell_isPvpTalent = _db.spell_isPvpTalent,
		spell_sharingCD = _db.spell_sharingCD,
		spell_reduceCdCast = _db.spell_reduceCdCast,
		spell_increaseDurationCast = _db.spell_increaseDurationCast,
		spell_runningSameSpell = _db.spell_runningSameSpell,
		spell_reduceCdByAuraFade = _db.spell_reduceCdByAuraFade,
		spell_reduceCdByAuraFadeBefore = _db.spell_reduceCdByAuraFadeBefore,
		spell_aura_list = _db.spell_aura_list,
		spell_dispellsList = _db.spell_dispellsList,
		spell_ReincarnationFix = _db.spell_ReincarnationFix,
		spell_ignoreUseWithAura = _db.spell_ignoreUseWithAura,

		isWarlock = _db.vars.isWarlock,
		isRogue = _db.vars.isRogue,
		isPaladin = _db.vars.isPaladin,
		isMage = _db.vars.isMage,

		session_gGUIDs = _db.session_gGUIDs,
		session_PetOwner = _db.session_PetOwner,
		findspecspells = _db.findspecspells,
		globalGUIDs = {},
		CDList = _db.cdsNav,
		bit = bit,
		print = print,
		abs = abs,
		C_Timer = C_Timer,
		UnitAura = UnitAura,
		UnitSpellHaste = UnitSpellHaste,
		UnitHealthMax = UnitHealthMax,
		UnitHealth = UnitHealth,
		GetSpellInfo = GetSpellInfo,
		type = type,
		pairs = pairs,
		ipairs = ipairs,

		CLEUstartCD = CLEUstartCD,
		UpdateAllData = UpdateAllData,
		GetUnitInfoByUnitFlag = GetUnitInfoByUnitFlag,
		GetTime = GetTime,
		IsAuraActive = IsAuraActive,
		ExRT = ExRT,

		SOULBIND_DEF_RANK_NOW = SOULBIND_DEF_RANK_NOW,

		avengershield_var = {},
	}
	CLEU.Events = {
		SPELL_CAST_SUCCESS = {main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,spellSchool)
				if not sourceName then
					return
				end
				$$$2
				local forceUpdateAllData

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
				if spell_covenant[spellID] then
					module:AddCovenant(sourceName,spell_covenant[spellID])
				end

				if spell_startCDbyAuraFade[spellID] or spell_startCDbyAuraApplied_fix[spellID] then
					if forceUpdateAllData then UpdateAllData() end
					return
				end
				if spell_ignoreUseWithAura[spellID] and IsAuraActive(sourceName,spell_ignoreUseWithAura[spellID]) then
					return
				end

				local line = CDList[sourceName][spellID]
				if line then
					CLEUstartCD(line)
				end

				if spell_isTalent[spellID] and not isSpellDuplicateDisabled and not session_gGUIDs[sourceName][spellID] then
					forceUpdateAllData = true
					session_gGUIDs[sourceName] = {spellID,"talent"}
				end

				local modifData = spell_resetOtherSpells[spellID]
				if modifData then
					for i=1,#modifData do
						local resetSpellID = modifData[i]
						if type(resetSpellID)~='table' or (session_gGUIDs[sourceName][ resetSpellID[2] ] and (not spell_isPvpTalent[ resetSpellID[2] ] or module.IsPvpTalentsOn(sourceName))) then
							resetSpellID = type(resetSpellID)=='table' and resetSpellID[1] or resetSpellID
							local line = CDList[sourceName][ resetSpellID ]
							if line then
								line:SetCD(0,true)

								forceUpdateAllData = true
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
							end
						end
					end
				end

				local modifData = spell_reduceCdCast[spellID]
				if modifData then
					local cdr_mod = 1
					for i=1,#modifData,2 do
						local reduceSpellID = modifData[i]
						if type(reduceSpellID) ~= "table" then
							local line = CDList[sourceName][reduceSpellID]
							local reduceTime = modifData[i+1]
							if line then
								line:ReduceCD(-reduceTime * cdr_mod,true)
								forceUpdateAllData = true
							end
						else
							local specReduceCD = reduceSpellID[3]
							local effectOnlyDuringBuffActive = reduceSpellID[4]
							if session_gGUIDs[sourceName][ reduceSpellID[2] ] and (not spell_isPvpTalent[ reduceSpellID[2] ] or module.IsPvpTalentsOn(sourceName)) and (not specReduceCD or (specReduceCD < 0 and globalGUIDs[sourceName] ~= specReduceCD or globalGUIDs[sourceName] == specReduceCD)) and (not effectOnlyDuringBuffActive or IsAuraActive(sourceName,effectOnlyDuringBuffActive)) then
								local line = CDList[sourceName][ reduceSpellID[1] ]

								local reduceTime = modifData[i+1]
								if type(reduceTime) == "table" and #reduceTime <= 5 then
									local talent_rank = _db.talent_classic_rank[sourceName][ reduceSpellID[2] ] or #reduceTime
									reduceTime = reduceTime[talent_rank] or reduceTime[#reduceTime]
								elseif type(reduceTime) == "table" then
									local soulbind_rank = _db.soulbind_rank[sourceName][ reduceSpellID[2] ] or SOULBIND_DEF_RANK_NOW
									reduceTime = reduceTime[soulbind_rank]
								end

								if line then
									line:ReduceCD(-reduceTime * cdr_mod,true)
									forceUpdateAllData = true
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
								line:ChangeDur(modifData[i+1],true)
								forceUpdateAllData = true
							end
						else
							if session_gGUIDs[sourceName][ increaseSpellID[2] ] then
								local line = CDList[sourceName][ increaseSpellID[1] ]

								local incTime = modifData[i+1]
								if type(incTime) == "table" then
									local soulbind_rank = _db.soulbind_rank[sourceName][ increaseSpellID[2] ] or SOULBIND_DEF_RANK_NOW
									incTime = incTime[soulbind_rank]
								end

								if line and (GetTime() - line.lastUse) < line.duration then
									line:ChangeDur(incTime,true)
									forceUpdateAllData = true
								end
							end
						end
					end
				end

				local modifData = spell_runningSameSpell[spellID]
				if modifData and not isSpellDuplicateDisabled then
					for i=1,#modifData do
						local sameSpellID = modifData[i]
						if sameSpellID ~= spellID then
							isSpellDuplicateDisabled = true
							eventsView.SPELL_CAST_SUCCESS(timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,sameSpellID,spellName,spellSchool)
							isSpellDuplicateDisabled = false
						end
					end
				end

				if spellID == 1856 and (session_gGUIDs[sourceName][340080] or session_gGUIDs[sourceName][382523]) then
					local talent_rank = _db.talent_classic_rank[sourceName][382523] or 2
					local timeReduce = 10 * talent_rank
					for j=1,#_C do
						local line = _C[j]
						if line.fullName == sourceName and line.db[1] ~= 1856 then
							line:ReduceCD(timeReduce,true)
							forceUpdateAllData = true
						end
					end
				end
				$$$1

				if forceUpdateAllData then
					UpdateAllData()
				end
			end
		]],classic=[[
			if spellID == 25937 or spellID == 33667 then
				return
			end
		]]},
		SPELL_AURA_APPLIED = {main=[[
			blessingcdr = {}
			symbolofhope = {}
			symbolofhopeSpells = {
				[22812]=true,[198589]=true,[48792]=true,[204021]=true,[109304]=true,[55342]=true,
				[115203]=true,[19236]=true,[108271]=true,[104773]=true,[871]=true,[118038]=true,
				[184364]=true,[498]=true,[31850]=true,[184662]=true,
			}
			thundercharge = {}
			faerie = {}
			faerieCond = {}
			faerieSpells = {
				[740]=true,[1122]=true,[1719]=true,[12042]=true,[12472]=true,[13750]=true,
				[31884]=true,[47536]=true,[47568]=true,[50334]=true,[51533]=true,[55233]=true,
				[61336]=true,[64843]=true,[79140]=true,[102543]=true,[102560]=true,[106951]=true,
				[107574]=true,[108280]=true,[109964]=true,[115203]=true,[115310]=true,[121471]=true,
				[137639]=true,[152173]=true,[152277]=true,[187827]=true,[190319]=true,[191427]=true,
				[192249]=true,[193530]=true,[194223]=true,[194249]=true,[198067]=true,[198144]=true,
				[205180]=true,[216331]=true,[227847]=true,[228260]=true,[231895]=true,[265187]=true,
				[266779]=true,[275699]=true,[288613]=true,[297850]=true,[333957]=true,[335235]=true,
				[102558]=true,
			}
			shiftingpower = {}

			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,school,auraType)
				if not sourceName then
					return
				end
				$$$2
				local CDspellID = spell_startCDbyAuraApplied[spellID]
				if CDspellID then
					local line = CDList[sourceName][CDspellID]
					if line then
						CLEUstartCD(line)
					end
				end

				local talentFromAura = spell_aura_grant_talent[spellID]
				if talentFromAura then
					if type(talentFromAura) == "table" then
						if not talentFromAura[1] or talentFromAura[1]==0 or session_gGUIDs[sourceName][ talentFromAura[1] ] then
							for i=2,#talentFromAura do
								session_gGUIDs[sourceName] = {talentFromAura[i],"aura"}
							end
						end
					else
						session_gGUIDs[sourceName] = {talentFromAura,"aura"}
					end
					UpdateAllData()
				end

				if (spellID == 328622 or spellID == 388010) and destName then	--Blessing of Autumn
					if blessingcdr[sourceName] then
						blessingcdr[sourceName]:Cancel()
					end
					local power
					for i=1,60 do
						local _,_,_,_,_,_,_,_,_,auraSpellID,_,_,_,_,_,val = UnitAura(destName,i)
						if not auraSpellID then
							break
						elseif auraSpellID == 328622 or auraSpellID == 388010 then
							power = (val or 30)/100
							break
						end
					end
					blessingcdr[sourceName] = C_Timer.NewTicker(1,function()
						local line, updateReq
						for j=1,#_C do
							line = _C[j]
							if line.fullName == destName then
								line:ReduceCD(power or 0.3,true)
								updateReq = true
							end
						end
						if updateReq then
							UpdateAllData()
						end
					end, 30)
				elseif spellID == 64901 and destName and sourceName then	--Symbol of Hope
					local hymnDur = 5 / (1 + (UnitSpellHaste(sourceName) or 0) /100)
					local perSec = 60 / hymnDur

					symbolofhope[sourceName..":"..destName] = C_Timer.NewTicker(1,function(self)
						local line, updateReq
						for j=1,#_C do
							line = _C[j]
							if line.fullName == destName and line.db and symbolofhopeSpells[ line.db[1] ] then
								line:ReduceCD(perSec,true)
								updateReq = true
							end
						end
						self.last = GetTime()
						if updateReq then
							UpdateAllData()
						end
					end, hymnDur)
					symbolofhope[sourceName..":"..destName].OnCancel = function(self)
						local now = GetTime()
						if not self.last or ((now - self.last) < 0.2) then
							return
						end
						local updateReq
						for j=1,#_C do
							local line = _C[j]
							if line.fullName == destName and line.db and symbolofhopeSpells[ line.db[1] ] then
								line:ReduceCD((now - self.last)*perSec,true)
								updateReq = true
							end
						end
						if updateReq then
							UpdateAllData()
						end
					end
				elseif spellID == 204366 and destName then	--Thundercharge
					if thundercharge[destName] then
						thundercharge[destName]:Cancel()
					end
					local power
					for i=1,60 do
						local _,_,_,_,_,_,_,_,_,auraSpellID,_,_,_,_,_,val = UnitAura(destName,i)
						if not auraSpellID then
							break
						elseif auraSpellID == 204366 then
							power = (val or 30)/100
							break
						end
					end
					thundercharge[destName] = C_Timer.NewTicker(1,function()
						local line, updateReq
						for j=1,#_C do
							line = _C[j]
							if line.fullName == destName then
								line:ReduceCD(power or 0.3,true)
								updateReq = true
							end
						end
						if updateReq then
							UpdateAllData()
						end
					end, 10)
				elseif (spellID == 327710 or spellID == 345453) and destName and sourceName then	--Benevolent Faerie
					local db = spellID == 327710 and faerie or faerieCond
					local mod = spellID == 327710 and 1 or 0.8
					if session_gGUIDs[sourceName][356391] then
						mod = mod * 2
					end
					if db[sourceName..":"..destName] then
						db[sourceName..":"..destName]:Cancel()
					end
					db[sourceName..":"..destName] = C_Timer.NewTicker(1,function(self)
						local updateReq
						for j=1,#_C do
							local line = _C[j]
							if line.fullName == destName and line.db and faerieSpells[ line.db[1] ] then
								line:ReduceCD(1*mod,true)
								updateReq = true
							end
						end
						self.last = GetTime()
						if updateReq then
							UpdateAllData()
						end
					end, 30)
					db[sourceName..":"..destName].OnCancel = function(self)
						local now = GetTime()
						if not self.last or ((now - self.last) < 0.2) then
							return
						end
						local updateReq
						for j=1,#_C do
							local line = _C[j]
							if line.fullName == destName and line.db and faerieSpells[ line.db[1] ] then
								line:ReduceCD((now - self.last)*mod,true)
								updateReq = true
							end
						end
						if updateReq then
							UpdateAllData()
						end
					end
				elseif (spellID == 314791 or spellID == 382440) and sourceName then	--Shifting Power
					if shiftingpower[sourceName] then
						shiftingpower[sourceName]:Cancel()
					end
					local len = 4 / (1 + (UnitSpellHaste(sourceName) or 0) /100)
					local changePerTick = 3
					if session_gGUIDs[sourceName][336992] then
						local soulbind_rank = _db.soulbind_rank[sourceName][336992] or SOULBIND_DEF_RANK_NOW
						local change = 0.9 + soulbind_rank * 0.1

						changePerTick = changePerTick + change
					end
					shiftingpower[sourceName] = C_Timer.NewTicker(len / 4,function()
						local line, updateReq
						for j=1,#_C do
							line = _C[j]
							if line.fullName == sourceName and line.db[1] ~= spellID then
								line:ReduceCD(changePerTick,true)
								updateReq = true
							end
						end
						if updateReq then
							UpdateAllData()
						end
					end, 4)
					shiftingpower[sourceName].t_end = GetTime() + len
				end

				$$$1
			end
		]]},
		SPELL_AURA_REMOVED = {main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,school,auraType)
				if not sourceName then
					return
				end
				$$$2
				local forceUpdateAllData

				local modifData = spell_reduceCdByAuraFade[spellID]
				if modifData then
					local CDspellID = modifData[1]
					if type(CDspellID) ~= "table" then
						local line = CDList[sourceName][CDspellID]
						if line and abs(GetTime() - line.lastUse - line.duration) < 0.5 then
							line:ModCD(modifData[2],true)
							forceUpdateAllData = true
						end
					else
						if session_gGUIDs[sourceName][ CDspellID[2] ] then
							local line = CDList[sourceName][ CDspellID[1] ]
							if line and abs(GetTime() - line.lastUse - line.duration) < 0.5 then
								line:ModCD(modifData[2],true)
								forceUpdateAllData = true
							end
						end
					end
				end

				local modifData = spell_reduceCdByAuraFadeBefore[spellID]
				if modifData then
					local CDspellID = modifData[1]
					if type(CDspellID) ~= "table" then
						local line = CDList[sourceName][CDspellID]
						if line and abs(GetTime() - line.lastUse - line.duration) > 0.5 then
							line:ModCD(modifData[2],true)
							forceUpdateAllData = true
						end
					else
						if session_gGUIDs[sourceName][ CDspellID[2] ] then
							local line = CDList[sourceName][ CDspellID[1] ]
							if line and abs(GetTime() - line.lastUse - line.duration) > 0.5 then
								line:ModCD(modifData[2],true)
								forceUpdateAllData = true
							end
						end
					end
				end

				local CDspellID = spell_aura_list[spellID]
				if CDspellID then
					if CDspellID == 198839 then	--Earthen Wall
						sourceName = ExRT.F.Pets:getOwnerNameByGUID(destGUID)
					end
					local line = CDList[sourceName][ CDspellID ]
					if line then
						line:SetDur(0,true)
						forceUpdateAllData = true
					end
				end

				local CDspellID = spell_startCDbyAuraFade[spellID]
				if CDspellID then
					local line = CDList[sourceName][CDspellID]
					if line then
						CLEUstartCD(line)
					end
				end

				local CDspellID = spell_startCDbyAuraFadeExt[spellID]
				if CDspellID then
					local line = CDList[sourceName][CDspellID]
					if line then
						CLEUstartCD(line)
					end
				end

				local talentFromAura = spell_aura_grant_talent[spellID]
				if talentFromAura then
					if type(talentFromAura) == "table" then
						if not talentFromAura[1] or talentFromAura[1]==0 or session_gGUIDs[sourceName][ talentFromAura[1] ] then
							for i=2,#talentFromAura do
								session_gGUIDs[sourceName] = -talentFromAura[i]
							end
						end
					else
						session_gGUIDs[sourceName] = -talentFromAura
					end
					forceUpdateAllData = true
				end

				if (spellID == 328622 or spellID == 388010) and destName then	--Blessing of Autumn
					C_Timer.After(.5,function()
						if blessingcdr[sourceName] then
							blessingcdr[sourceName]:Cancel()
						end
					end)
				elseif spellID == 64901 and destName then	--Symbol of Hope
					C_Timer.After(0.1,function()
						if symbolofhope[sourceName..":"..destName] then
							symbolofhope[sourceName..":"..destName]:OnCancel()
							symbolofhope[sourceName..":"..destName]:Cancel()
						end
					end)
				elseif spellID == 204366 and destName then	--Thundercharge
					C_Timer.After(.5,function()
						if thundercharge[destName] then
							thundercharge[destName]:Cancel()
						end
					end)
				elseif (spellID == 327710  or spellID == 345453) and destName then	--Benevolent Faerie
					local db = spellID == 327710 and faerie or faerieCond
					C_Timer.After(0.1,function()
						if db[sourceName..":"..destName] then
							db[sourceName..":"..destName]:OnCancel()
							db[sourceName..":"..destName]:Cancel()
						end
					end)
				elseif (spellID == 314791 or spellID == 382440) then	--Shifting Power
					if shiftingpower[sourceName] then
						local now = GetTime()
						if abs(now - shiftingpower[sourceName].t_end) > 0.2 then
							shiftingpower[sourceName]:Cancel()
						end
					end
				elseif spellID == 206005 then	--Xavius: Dream Simulacrum
					for i=1,#_C do
						local unitSpellData = _C[i]
						if unitSpellData.fullName == destName then
							unitSpellData:SetCD(0,true)
							unitSpellData:SetDur(0,true)

							forceUpdateAllData = true
						end
					end
				end
				$$$1

				if forceUpdateAllData then
					UpdateAllData()
				end
			end
		]]},
		PREP = {main=[[
			return function ()
				$$$1
			end
		]]},
		SPELL_SUMMON = {isEmpty=true,main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName)
				$$$2
				$$$1
			end
		]]},
		SPELL_AURA_APPLIED_DOSE = {isEmpty=true,main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,_,type,stack)
				$$$2
				$$$1
			end
		]]},
		SPELL_AURA_REMOVED_DOSE = {isEmpty=true,main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,_,type,stack)
				$$$2
				$$$1
			end
		]]},
		SPELL_DISPEL = {main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,_,destSpell)
				$$$2
				if spell_dispellsList[spellID] and sourceName then
					_db.spell_dispellsFix[ sourceName ] = true
				end
				$$$1
			end
		]]},
		SPELL_DAMAGE = {isEmpty=true,main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,_,amount,overkill,school,resisted,blocked,absorbed,critical,glancing,crushing,isOffHand)
				$$$2
				$$$1
			end
		]],subevents={RANGE_DAMAGE=true,SPELL_PERIODIC_DAMAGE=true,SWING_DAMAGE=[[
			local meleeStr = GetSpellInfo(6603)
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,amount,overkill,school,resisted,blocked,absorbed,critical,glancing,crushing,isOffHand)
				return eventsView.SPELL_DAMAGE(timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,6603,meleeStr,1,amount,overkill,school,resisted,blocked,absorbed,critical,glancing,crushing,isOffHand)
			end
		]]}},
		SPELL_HEAL = {isEmpty=true,main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,_,amount,overhealing,absorbed,critical)
				$$$2
				$$$1
			end
		]],subevents={SPELL_PERIODIC_HEAL=true}},
		SPELL_ENERGIZE = {isEmpty=true,main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,_,amount,overEnergize,powerType,alternatePowerType)
				$$$2
				$$$1
			end
		]],subevents={SPELL_PERIODIC_ENERGIZE=true}},
		SPELL_MISSED = {isEmpty=true,main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,_,missType,isOffHand,amountMissed,critical)
				$$$2
				$$$1
			end
		]],subevents={RANGE_MISSED=true,SPELL_PERIODIC_MISSED=true,SWING_MISSED=[[
			local meleeStr = GetSpellInfo(6603)
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,missType,isOffHand,amountMissed,critical)
				return eventsView.SPELL_MISSED(timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,6603,meleeStr,1,missType,isOffHand,amountMissed,critical)
			end
		]]}},
		SPELL_INTERRUPT = {isEmpty=true,main=[[
			return function (timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName,_,destSpell)
				$$$2
				$$$1
			end
		]]},
	}

	function CLEU:Recreate()
		env.globalGUIDs = globalGUIDs

		for event,db in pairs(CLEU.Events) do
			if db.isEmpty and #db == 0 then
				eventsView[event] = nil
			else
				local full = db.main
				for i=1,#db do 
					full = full:gsub("%$%$%$1",db[i].."$$$1")
				end
				if ExRT.isClassic then
					if db.classic then
						full = full:gsub("%$%$%$2",db.classic.."$$$2")
					end
					full = full:gsub("%$%$%$2","local spellIDClassic = spellID;spellID=spellName")
				end

				full = full:gsub("%$%$%$%d","")
				local f = assert(loadstring(full,"ExCD2:"..event))
				setfenv(f,env)
				eventsView[event] = f()
				if db.subevents then
					for subevent,substr in pairs(db.subevents) do
						if type(substr) == "string" then
							local sf = assert(loadstring(substr,"ExCD2:"..subevent))
							setfenv(sf,env)
							eventsView[subevent] = sf()
						else
							eventsView[subevent] = eventsView[event]
						end
					end
				end

				db.devstr = full
			end
		end
		eventsView.PREP()
		eventsView.PREP = nil
	end
	function CLEU:Reset()
		for event,db in pairs(CLEU.Events) do
			if db.main then
				for i=1,#db do
					db[i] = nil
				end
			else
				CLEU.Events[event] = nil
			end
		end
	end
	function CLEU:Add(event,str)
		if event:find("^CLEU_") then
			event = event:gsub("^CLEU_","")
		end
		if not CLEU.Events[event] then
			return
		end
		tinsert(CLEU.Events[event],str)
	end

	local isPaladin = _db.vars.isPaladin
	function module.main:ARENA_COOLDOWNS_UPDATE(unitID)
		local guid = UnitGUID(unitID)
		if not guid then return end
		if isPaladin[guid] then
			local t = GetTime()
			if (t - 0.5) < (env.avengershield_var[guid] or 0) then
				local name,realm = UnitName(unitID)
				if name then
					if realm then
						name = name .. "-" .. realm
					end
					local line = _db.cdsNav[name][31935]
					if line then
						line:ResetCD()
					end
				end
			end
		end
	end

	local SCSSpells = {}
	local SCSBlack = {}
	function module.main:UNIT_SPELLCAST_SUCCEEDED(unitID,castGUID,spellID)
		if SCSSpells[spellID] then
			if SCSBlack[castGUID] then
				return
			end
			SCSBlack[castGUID] = true

			local guid = UnitGUID(unitID)
			local name = UnitName(unitID)

			eventsView.SPELL_CAST_SUCCESS(0,"SPELL_CAST_SUCCESS",false,guid,name,0,0,"","",0,0,spellID,GetSpellInfo(spellID),1)

			if spellID == 5384 then
				local line = _db.cdsNav[name][5384]
				if ExRT.isClassic and not line then
					line = _db.cdsNav[name][GetSpellInfo(5384)]
				end
				if line then
					line:SetCD(360)
				end

				FD_GUIDs[guid] = true

				if not IsInJailersTower() then
					module:RegisterEvents('UNIT_AURA')
					if ScheduledUnitAura then
						ScheduledUnitAura:Cancel()
					end
					ScheduledUnitAura = ScheduleTimer(function()
						ScheduledUnitAura = nil
						module:UnregisterEvents('UNIT_AURA')
					end,361)
				end
			end
		end
	end

	function module.main.UNIT_DIED(_,_,_,destGUID,destName,destFlags)
		if destName then
			local _,class = UnitClass(destName)
			if class == "SHAMAN" then
				_db.spell_ReincarnationFix[destName] = true
			end
		end
	end
	function module.main:SPELL_RESURRECT(_,_,_,destGUID,destName,destFlags)
		if destName and _db.spell_ReincarnationFix[destName] then
			_db.spell_ReincarnationFix[destName] = nil
		end
	end

	function module.main:UNIT_FLAGS(unitID)
		local name = UnitCombatlogname(unitID)
		if _db.spell_ReincarnationFix[name] and not UnitIsDead(unitID) then
			if not UnitIsGhost(unitID) then
				local hp = UnitHealth(unitID) / max(UnitHealthMax(unitID),1)
				if hp < 0.45 then
					eventsView.SPELL_CAST_SUCCESS(0,"SPELL_CAST_SUCCESS",false,UnitGUID(unitID),name,0,0,"","",0,0,20608,GetSpellInfo(20608),1)
				end
			end
			_db.spell_ReincarnationFix[name] = nil
		end
	end

	local isACUAdded = nil
	local isSCSAdded = nil
	local isAnkhAdded
	function module:AddCLEUSpellDamage(spellID)
		if spellID == 31935 and not isACUAdded then
			module:RegisterEvents('ARENA_COOLDOWNS_UPDATE')
			isACUAdded = true
		elseif spellID == 5384 and not isSCSAdded then
			module:RegisterEvents('UNIT_SPELLCAST_SUCCEEDED')
			isSCSAdded = true
			SCSSpells[5384] = true
		elseif ExRT.isClassic and spellID == 20608 and not isAnkhAdded then
			_db.spell_ReincarnationFix = {}
			module:RegisterEvents('UNIT_FLAGS')
			eventsView.UNIT_DIED = module.main.UNIT_DIED
			eventsView.SPELL_RESURRECT = module.main.SPELL_RESURRECT
			isAnkhAdded = true
		end
	end
end

function module.options:Load()
	self:CreateTilte()

	self.decorationLine = ELib:DecorationLine(self,true,"BACKGROUND",-5):Point("TOPLEFT",self,0,-25):Point("BOTTOMRIGHT",self,"TOPRIGHT",0,-45)

	self.chkEnable = ELib:Check(self,L.Enable,VMRT.ExCD2.enabled):Point(720,-26):Size(18,18):Tooltip("/rt cd"):AddColorState():OnClick(function(self) 
		if self:GetChecked() then
			module:Enable()
		else
			module:Disable()
		end
	end)

	self.chkLock = ELib:Check(self,L.cd2fix,VMRT.ExCD2.lock):Point(590,-26):Size(18,18):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.ExCD2.lock = true
		else
			VMRT.ExCD2.lock = nil
		end
		module:UpdateLockState()
	end)

	self.tab = ELib:Tabs(self,0,L.cd2Spells,L.cd2Appearance,L.cd2History):Point(0,-45):Size(850,589):SetTo(1)
	self.tab:SetBackdropBorderColor(0,0,0,0)
	self.tab:SetBackdropColor(0,0,0,0)


	self.CATEGORIES_DEF = {
		"ALL",
		"ENABLED",
		"FAV",
	}
	self.CATEGORIES_VIS = {
		["ALL"] = {name = L.cd2CatAll,icon = ExRT.isClassic and 133733 or 1495827, sort = 0},

		["RAID"] = {name = L.cd2CatMajor,icon = 136107, sort = 10, ignoreSubcats = true},
		["DEFTAR"] = {name = L.cd2CatSingleTar,icon = 135928, sort = 15, ignoreSubcats = true},
		["RES"] = {name = L.cd2CatRes,icon = 136080, sort = 20, ignoreSubcats = true},
		["RAIDSPEED"] = {name = L.cd2CatRaidMove,icon = 464343, sort = 25, ignoreSubcats = true},
		["KICK"] = {name = L.cd2CatKicks,icon = 132219, sort = 30, ignoreSubcats = true},
		["UTIL"] = {name = L.cd2CatUtil,icon = 458224, sort = 35, ignoreSubcats = true},
		["AOECC"] = {name = L.cd2CatMassStun,icon = 136013, sort = 40, ignoreSubcats = true},
		["HEALUTIL"] = {name = L.cd2CatHealUtil,icon = 136048, sort = 45, ignoreSubcats = true},
		["DISPEL"] = {name = L.cd2CatDispells,icon = 135894, sort = 50, ignoreSubcats = true},
		["TAUNT"] = {name = L.cd2CatTaunts,icon = 132270, sort = 55, ignoreSubcats = true},

		["DPS"] = {name = L.cd2CatDPS,icon = 135753, sort = 60, ignoreSubcats = true},
		["HEAL"] = {name = L.cd2CatHeal,icon = 1060983, sort = 65, ignoreSubcats = true},
		["DEFTANK"] = {name = L.cd2CatDefTank,icon = 132361, sort = 70, ignoreSubcats = true},
		["DEF"] = {name = L.cd2CatDef,icon = 135896, sort = 75, ignoreSubcats = true},
		["CC"] = {name = L.cd2CatCC,icon = 136175, sort = 80, ignoreSubcats = true},
		["MOVE"] = {name = L.cd2CatMove,icon = 574574, sort = 85, ignoreSubcats = true},

		["WARRIOR"] = {name = L.classLocalizate["WARRIOR"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["WARRIOR"], sort = 101, isClassCategory = true},
		["PALADIN"] = {name = L.classLocalizate["PALADIN"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["PALADIN"], sort = 102, isClassCategory = true},
		["HUNTER"] = {name = L.classLocalizate["HUNTER"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["HUNTER"], sort = 103, isClassCategory = true},
		["ROGUE"] = {name = L.classLocalizate["ROGUE"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["ROGUE"], sort = 104, isClassCategory = true},
		["PRIEST"] = {name = L.classLocalizate["PRIEST"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["PRIEST"], sort = 105, isClassCategory = true},
		["DEATHKNIGHT"] = {name = L.classLocalizate["DEATHKNIGHT"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["DEATHKNIGHT"], sort = 106, isClassCategory = true},
		["SHAMAN"] = {name = L.classLocalizate["SHAMAN"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["SHAMAN"], sort = 107, isClassCategory = true},
		["MAGE"] = {name = L.classLocalizate["MAGE"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["MAGE"], sort = 108, isClassCategory = true},
		["WARLOCK"] = {name = L.classLocalizate["WARLOCK"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["WARLOCK"], sort = 109, isClassCategory = true},
		["MONK"] = {name = L.classLocalizate["MONK"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["MONK"], sort = 110, isClassCategory = true},
		["DRUID"] = {name = L.classLocalizate["DRUID"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["DRUID"], sort = 111, isClassCategory = true},
		["DEMONHUNTER"] = {name = L.classLocalizate["DEMONHUNTER"],icon = "Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES", iconTcoord = CLASS_ICON_TCOORDS["DEMONHUNTER"], sort = 112, isClassCategory = true},
		["EVOKER"] = {name = L.classLocalizate["EVOKER"],icon = "interface/icons/classicon_evoker", sort = 113, isClassCategory = true},

		["ITEMS"] = {name = L.cd2CatItems,icon = 135918, sort = 140, ignoreSubcats = true},
		["ESSENCES"] = {name = L.cd2CatEssences,icon = 2967111, sort = 150, ignoreSubcats = true},
		["COVENANTS"] = {name = L.cd2CatCovenants,icon = 3528296, sort = 151, ignoreSubcats = true},
		["RACIAL"] = {name = L.cd2CatRacial,icon = 135727, sort = 160, ignoreSubcats = true},

		["PET"] = {name = PET,icon = 613074, sort = 185, ignoreSubcats = true},

		["PVP"] = {name = CALENDAR_TYPE_PVP,icon = 236396, sort = 190, ignoreSubcats = true},

		["NO"] = {name = L.cd2CatOther,icon = 136011, sort = 195, ignoreSubcats = true, isHidden = true},
		["OTHER"] = {name = L.cd2CatOther,icon = 136011, sort = 197, ignoreSubcats = true},
		["USER"] = {name = L.cd2CatUser,icon = 133667, sort = 199, ignoreOwncat = true},

		["ENABLED"] = {name = L.cd2CatEnabled,icon = ExRT.isClassic and 136170 or 236372, sort = 5, ignoreSubcats = true},
		["FAV"] = {name = L.cd2Favorite,icon = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\star2", iconTcoord = {0,.5,0,.5}, sort = 310, ignoreSubcats = true},

	}

	self.categories = ELib:ScrollFrame(self.tab.tabs[1]):Point("TOPLEFT",0,0):Size(100,589)
	ELib:Border(self.categories,0)
	self.categories.C:SetWidth(100)
	self.categories.mouseWheelRange = 200

	self.categories.ScrollBar:Size(8,0):Point("TOPRIGHT",0,0):Point("BOTTOMRIGHT",0,0)
	self.categories.ScrollBar.thumb:SetHeight(100)
	self.categories.ScrollBar.buttonUP:Hide()
	self.categories.ScrollBar.buttonDown:Hide()
	self.categories.ScrollBar.borderLeft:Hide()
	self.categories.ScrollBar.borderRight:Hide()
	self.categories.ScrollBar.bg:Hide()

	self.categories.buttons = {}

	self.categories.border_right = ELib:Texture(self.categories,.24,.25,.30,1,"BORDER"):Point("TOPLEFT",self.categories,"TOPRIGHT",0,0):Point("BOTTOMRIGHT",self.categories,"BOTTOMRIGHT",1,0)

	local function CategoriesButtonOnEnter(self)
		if not self.isActive then
			self.background:Show()
		end
	end
	local function CategoriesButtonOnLeave(self)
		self.background:Hide()
	end
	local function CategoriesButtonOnClick(self)
		for i=1,#module.options.categories.buttons do
			module.options.categories.buttons[i].isActive = false
		end
		self.background:Hide()
		self.isActive = true
		module.options.categories:Update()
		module.options.list:UpdateDB(self.category)
		module.options.list:Update()
		module.options.list.ScrollBar.slider:SetValue(0)
	end
	local CATEGORIES_INDEX_COUNTER = 200

	function self:GetAllSpells(addPvP)
		local new = {}
		for i=1,#module.db.AllSpells do 
			if addPvP then
				new[i] = module.db.AllSpells[i]
			else
				local findPvP = false
				for cat in string.gmatch(module.db.AllSpells[i][2], "[^,]+") do
					if cat == "PVP" then
						findPvP = true
						break
					end
				end
				if (findPvP and addPvP) or (not findPvP and not addPvP) then
					new[#new+1] = module.db.AllSpells[i]
				end
			end
		end
		for i=1,#VMRT.ExCD2.userDB do
			local line = VMRT.ExCD2.userDB[i]
			if type(line[2]) == "string" and type(line[3]) == "number" then
				new[#new+1] = line

				local findUserCat = false
				for cat in string.gmatch(line[2], "[^,]+") do
					if cat == "USER" then
						findUserCat = true
						break
					end
				end
				if not findUserCat then
					line[2] = line[2] .. ",USER"
				end
			end
		end

		return new
	end

	local function SortCategoriesButtons(a,b)
		return (self.CATEGORIES_VIS[a] and self.CATEGORIES_VIS[a].sort or 200) < (self.CATEGORIES_VIS[b] and self.CATEGORIES_VIS[b].sort or 200)
	end

	function self.categories:Update()
		local cats = ExRT.F.table_copy2(module.options.CATEGORIES_DEF)
		local AllSpells = module.options:GetAllSpells(true)
		for _,data in pairs(AllSpells) do
			for cat in string.gmatch(data[2], "[^,]+") do
				if not ExRT.F.table_find(cats,cat) then
					cats[#cats+1] = cat
				end
			end
		end
		for i=#cats,1,-1 do
			if module.options.CATEGORIES_VIS[ cats[i] ] and module.options.CATEGORIES_VIS[ cats[i] ].isHidden then
				tremove(cats,i)
			end
		end
		sort(cats,SortCategoriesButtons)
		for i=1,#cats do
			local button = self.buttons[i]
			if not button then
				button = CreateFrame("Button",nil,self.C)
				self.buttons[i] = button
				if i == 1 then
					button:SetPoint("TOP",0,0)
				else
					button:SetPoint("TOP",self.buttons[i-1],"BOTTOM",0,-2)
				end
				button:SetSize(88,62)

				button.icon = button:CreateTexture(nil, "ARTWORK")
				button.icon:SetPoint("TOP",0,-3)
				button.icon:SetSize(30,30)

				button.text = button:CreateFontString(nil,"ARTWORK","ExRTFontNormal")
				button.text:SetFont(button.text:GetFont(),11,"")
				button.text:SetPoint("TOP",button.icon,"BOTTOM",0,-3)
				button.text:SetPoint("BOTTOM",0,1)
				button.text:SetPoint("LEFT",2,0)
				button.text:SetPoint("RIGHT",-2,0)
				button.text:SetJustifyH("CENTER")
				button.text:SetJustifyV("TOP")

				button.class = button:CreateTexture(nil, "BACKGROUND")
				button.class:SetPoint("TOP")
				button.class:SetPoint("BOTTOM")
				button.class:SetPoint("LEFT",self,0,0)
				button.class:SetPoint("RIGHT",self,0,0)
				button.class:Hide()

				button.background = button:CreateTexture(nil, "BACKGROUND")
				button.background:SetPoint("TOP")
				button.background:SetPoint("BOTTOM")
				button.background:SetPoint("LEFT",self,0,0)
				button.background:SetPoint("RIGHT",self,0,0)
				button.background:SetColorTexture(1,1,1,.3)
				button.background:Hide()

				button.active = button:CreateTexture(nil, "BACKGROUND")
				button.active:SetPoint("TOP")
				button.active:SetPoint("BOTTOM")
				button.active:SetPoint("LEFT",self,0,0)
				button.active:SetPoint("RIGHT",self,0,0)
				button.active:SetColorTexture(.8,.6,0,1)
				button.active:Hide()

				button:SetScript("OnEnter",CategoriesButtonOnEnter)
				button:SetScript("OnLeave",CategoriesButtonOnLeave)
				button:SetScript("OnClick",CategoriesButtonOnClick)
			end
			local cat = cats[i]
			local catData = module.options.CATEGORIES_VIS[cat]
			button.icon:SetTexture(catData and catData.icon or "Interface\\Icons\\INV_MISC_QUESTIONMARK")
			if catData and catData.iconTcoord then
				button.icon:SetTexCoord(unpack(catData.iconTcoord))
			else
				button.icon:SetTexCoord(0,1,0,1)
			end
			button.text:SetText(catData and catData.name or cat)
			button.active:SetShown(button.isActive)
			button.category = cat
			if cat == "ALL" then 
				button.category = nil 
			end
			if ExRT.GDB.ClassID[cat] then
				local r,g,b = ExRT.F.classColorNum(cat)
				button.class:SetColorTexture(r,g,b,.3)
				button.class:Show()
			else
				button.class:Hide()
			end
			if not catData then
				module.options.CATEGORIES_VIS[cat] = {sort = CATEGORIES_INDEX_COUNTER,ignoreSubcats = true}
				CATEGORIES_INDEX_COUNTER = CATEGORIES_INDEX_COUNTER + 1
			end
			button:Show()
		end
		for i=#cats+1,#self.buttons do
			self.buttons[i]:Hide()
		end
		self:Height(64 * #cats - 2)
	end


	self.list = ELib:ScrollFrame(self.tab.tabs[1]):Point("TOPLEFT",101,0):Size(749,589)
	ELib:Border(self.list,0)
	self.list.mouseWheelRange = 50

	local SPELL_LINE_HEIGHT = 32

	local function SpellsListLineOnUpdate(self)
		if module.options.list.colBySpecFrame:IsShown() then
			return
		end
		local alpha = 0.4
		if self:IsMouseOver() and not ExRT.lib.ScrollDropDown.DropDownList[1]:IsShown() then
			alpha = 0.8
		end
		if ExRT.is10 then
			self.backClassColor:SetGradient("HORIZONTAL",CreateColor(self.backClassColorR, self.backClassColorG, self.backClassColorB, alpha), CreateColor(self.backClassColorR, self.backClassColorG, self.backClassColorB, 0))
		else
			self.backClassColor:SetGradientAlpha("HORIZONTAL", self.backClassColorR, self.backClassColorG, self.backClassColorB, alpha, self.backClassColorR, self.backClassColorG, self.backClassColorB, 0)
		end

		if self:IsMouseOver() and not self.colExpand:IsShown() and self.colBack:IsShown() then
			self.colExpand:Show()
		elseif not self:IsMouseOver() and self.colExpand:IsShown() then
			self.colExpand:Hide()
		end
	end
	local function SpellsListTooltipFrameOnEnter(self)
		local parent = self:GetParent()
		if not parent.data then
			return
		end
		ELib.Tooltip.Link(self,self.link or "spell:"..parent.data[1])

		local additional = {}
		if parent.data[1] == 161642 then
			additional[#additional+1] = L.cd2ResurrectTooltip
		end
		if module.db.spell_isTalent[ parent.data[1] ] and not parent.isItem and not module.db.spell_covenant[ parent.data[1] ] then
			additional[#additional+1] = "|cffffffff"..L.cd2AddSpellFrameTalent.."|r"..(ExRT.isClassic and " |cffff8888(*will be shown only after first usage)|r" or "")
		end
		if module.db.spell_dispellsList[ parent.data[1] ] then
			additional[#additional+1] = "|cffffffaa"..L.cd2AddSpellFrameDispel.."|r"
		end
		if module.db.spell_talentReplaceOther[ parent.data[1] ] then
			local spellID = module.db.spell_talentReplaceOther[ parent.data[1] ]
			if type(spellID)=='table' then
				for i=1,#spellID do
					local sname,_,sicon = GetSpellInfo(spellID[i])
					additional[#additional+1] = "|cffffaaaa"..L.cd2AddSpellFrameReplace .." "..(sicon and "|T"..sicon..":20|t" or "").. (sname or "???") .."|r"
				end
			else
				local sname,_,sicon = GetSpellInfo(spellID)
				additional[#additional+1] = "|cffffaaaa"..L.cd2AddSpellFrameReplace .." "..(sicon and "|T"..sicon..":20|t" or "").. (sname or "???") .."|r"
			end
		end
		if module.db.spell_isPetAbility[ parent.data[1] ] then
			additional[#additional+1] = "|cffffffff"..L.BossWatcherBuffsAndDebuffsFilterPets.."|r"
		end

		if #additional > 0 then
			ELib.Tooltip:Add(nil,additional)
		end
	end
	local function SpellsListTooltipFrameOnLeave(self)
		GameTooltip_Hide()
		ELib.Tooltip:HideAdd()
	end
	local function SpellsListLineColExpand(self)
		module.options.list.colBySpecFrame:Open(self:GetParent(),self)
	end
	local function SpellsListChkOnClick(self)
		if self.disabled then
			VMRT.ExCD2.CDE[ self:GetParent().data[1] ] = nil
			if self:GetChecked() then
				self:SetChecked(false)
			end
		elseif self:GetChecked() then
			VMRT.ExCD2.CDE[ self:GetParent().data[1] ] = true
		else
			VMRT.ExCD2.CDE[ self:GetParent().data[1] ] = nil
		end	  
 		self:UpdateColors()

		module:UpdateSpellDB(true)

		module.options.list:Update()
	end
	local function SpellsListChkUpdateColors(self)
		local cR,cG,cB
		if self.disabled then
			cR,cG,cB = .5,.5,.5
		elseif self:GetChecked() then
			cR,cG,cB = .2,.8,.2
		else
			cR,cG,cB = .8,.2,.2
		end
		self.BorderTop:SetColorTexture(cR,cG,cB,1)
		self.BorderLeft:SetColorTexture(cR,cG,cB,1)
		self.BorderBottom:SetColorTexture(cR,cG,cB,1)
		self.BorderRight:SetColorTexture(cR,cG,cB,1)
	end
	local function SpellsListCDTooltipFrameOnEnter(self)
		local data = self:GetParent().data
		if not data then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")

		local className = self:GetParent().data_class
		if module.db.specByClass[className] then
			for i=1,#module.db.specByClass[className] do
				if data[3+i] then
					local icon = ""
					if module.db.specIcons[module.db.specByClass[className][i]] then
						icon = "|T".. module.db.specIcons[module.db.specByClass[className][i]] ..":20|t"
					else
						icon = ExRT.F.classIconInText(className,20) or ""
					end
					GameTooltip:AddLine(icon.." |c"..ExRT.F.classColor(className)..L.specLocalizate[module.db.specInLocalizate[module.db.specByClass[className][i]]].. ":|r|cffffffff "..L.cd2AddSpellFrameCDText.." "..format("%d:%02d",data[i+3][2]/60,data[i+3][2]%60).. (data[i+3][3] > 0 and ", "..L.cd2AddSpellFrameDurationText.." "..data[i+3][3] or ""))
				end
			end
		else
			GameTooltip:AddLine("|cffffffff"..L.cd2AddSpellFrameCDText.." "..data[4][2].. (data[4][3] > 0 and ", "..L.cd2AddSpellFrameDurationText.." "..data[4][3] or ""))
		end

		do
			local cdByTalent_fix = nil
			local readiness_lines = {}
			if module.db.spell_cdByTalent_fix[ data[1] ] then
				cdByTalent_fix = true
				for j=1,#module.db.spell_cdByTalent_fix[ data[1] ],2 do
					local spellID = module.db.spell_cdByTalent_fix[ data[1] ][j]
					local specInfo 
					if type(spellID) == "table" then
						specInfo = L.specLocalizate[ module.db.specInLocalizate[ spellID[2] ] ]
						spellID = spellID[1]
					end

					local sname,_,sicon = GetSpellInfo(spellID)
					local cd = module.db.spell_cdByTalent_fix[ data[1] ][j+1]
					local isSoulbind
					local isRank
					if type(cd) == 'table' and ExRT.isLK then
						cd = cd[#cd]
					elseif type(cd) == 'table' and #cd > 5 then
						cd = cd[5]
						isSoulbind = true
					elseif type(cd) == 'table' then
						isRank = #cd
						cd = cd[#cd]
					end
					if type(cd) == 'table' then
						local tal_sid = cd[2]
						if not tonumber(cd[1]) then
							cd = tonumber(string.sub(cd[1],2))
							if cd < 1 then
								cd = "-"..( (1-cd)*100 ).."%"
							else
								cd = "+"..( (cd-1)*100 ).."%"
							end
						else
							cd = "+"..cd
						end
						local spellname,_,spellicon = GetSpellInfo(tal_sid)
						cd = cd .. " during "..(spellicon and "|T"..spellicon..":20|t" or "")..(spellname or tal_sid)
					elseif not tonumber(cd) then
						cd = tonumber(string.sub(cd,2))
						if cd < 1 then
							cd = "-"..( (1-cd)*100 ).."%"
						else
							cd = "+"..( (cd-1)*100 ).."%"
						end
					end
					table.insert(readiness_lines,"|cffffffff - "..(sicon and "|T"..sicon..":20|t" or "")..(sname or "???") .." (".. (tonumber(cd) and cd > 0 and "+" or "").. cd .. (isSoulbind and " [soulbind rank 5]" or "") .. (isRank and " [rank "..isRank.."]" or "") ..")"..(specInfo and " <"..specInfo..">" or "").."|r")

					ELib.Tooltip:Add("spell:"..spellID)
				end
			end
			if cdByTalent_fix then
				GameTooltip:AddLine("|cffffaaaa"..L.cd2AddSpellFrameCDChange..": |r")
				for j=1,#readiness_lines do
					GameTooltip:AddLine(readiness_lines[j])
				end
			end
		end
		if module.db.spell_charge_fix[ data[1] ] then
			if module.db.spell_charge_fix[ data[1] ] == 1 then
				GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameCharge.."|r")
			else
				GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameChargeChange..":|r")
				local sname = GetSpellInfo(module.db.spell_charge_fix[ data[1] ])
				GameTooltip:AddLine("|cffffffff - "..(sname or "???") .."|r")
			end
		end

		if module.db.spell_sharingCD[ data[1] ] then
			GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameSharing..": |r")
			for otherID,otherCD in pairs(module.db.spell_sharingCD[ data[1] ]) do
				local sname = GetSpellInfo(otherID)
				GameTooltip:AddLine("|cffffffff - "..(sname or "???") .." (".. otherCD ..")|r")
			end
		end

		if module.db.spell_reduceCdByHaste[ data[1] ] then
			GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameCDHaste..": |r")
		end

		for castSpellID,castData in pairs(module.db.spell_reduceCdCast) do
			for i=1,#castData,2 do
				local sID = castData[i]
				if type(sID) == 'table' then
					if sID[1] == data[1] then
						local spellname,_,spellicon = GetSpellInfo(castSpellID)
						if not sID[3] and not sID[4] then
							local spellnameT,_,spelliconT = GetSpellInfo(sID[2])
							GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameCasting1.." "..(spellicon and "|T"..spellicon..":20|t" or "")..(spellname or castSpellID).." "..L.cd2AddSpellFrameCasting3.." "..(spelliconT and "|T"..spelliconT..":20|t" or "")..(spellnameT or sID[2]).." "..L.cd2AddSpellFrameCasting2.." "..(type(castData[i+1])=="table" and castData[i+1][#castData[i+1]].." (rank "..#castData[i+1]..")" or castData[i+1]).." |r")
						elseif sID[4] then
							local spellnameT,_,spelliconT = GetSpellInfo(sID[4])
							GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameCasting1.." "..(spellicon and "|T"..spellicon..":20|t" or "")..(spellname or castSpellID).." "..L.cd2AddSpellFrameCasting4.." "..(spelliconT and "|T"..spelliconT..":20|t" or "")..(spellnameT or sID[2]).." "..L.cd2AddSpellFrameCasting2.." "..(type(castData[i+1])=="table" and castData[i+1][#castData[i+1]].." (rank "..#castData[i+1]..")" or castData[i+1]).." |r")
						elseif sID[3] then
							local spellnameT,_,spelliconT = GetSpellInfo(sID[2])
							GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameCasting1.." "..(spellicon and "|T"..spellicon..":20|t" or "")..(spellname or castSpellID).." "..L.cd2AddSpellFrameCasting3.." "..(spelliconT and "|T"..spelliconT..":20|t" or "")..(spellnameT or sID[2]).." "..L.cd2AddSpellFrameCasting5.." "..L.specLocalizate[ module.db.specInLocalizate[ sID[3] ] ].." "..L.cd2AddSpellFrameCasting2.." "..(type(castData[i+1])=="table" and castData[i+1][#castData[i+1]].." (rank "..#castData[i+1]..")" or castData[i+1]).." |r")
						end
					end
				elseif sID == data[1] then
					local spellname,_,spellicon = GetSpellInfo(castSpellID)
					GameTooltip:AddLine("|cffffffaa"..L.cd2AddSpellFrameCasting1.." "..(spellicon and "|T"..spellicon..":20|t" or "")..(spellname or castSpellID).." "..L.cd2AddSpellFrameCasting2.." "..(type(castData[i+1])=="table" and castData[i+1][5].." (soulbind rank 5)" or castData[i+1]).." |r")
				end
			end
		end

		GameTooltip:Show()
	end
	local function SpellsListCDTooltipFrameOnLeave(self)
	  	GameTooltip_Hide()
	  	ELib.Tooltip:HideAdd()	  
	end
	local function SpellsListDurTooltipFrameOnEnter(self)
		local data = self:GetParent().data
		if not data then
			return
		end
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		local something

		if module.db.spell_durationByTalent_fix[ data[1] ] then
			GameTooltip:AddLine("|cffaaffaa"..L.cd2AddSpellFrameDuration..":|r")
			for j=1,#module.db.spell_durationByTalent_fix[data[1]],2 do
				local sname = GetSpellInfo(module.db.spell_durationByTalent_fix[ data[1] ][j]) or "???"
				local cd = module.db.spell_durationByTalent_fix[ data[1] ][j+1]
				local isRank 
				if type(cd) == 'table' then
					isRank = #cd
					cd = cd[#cd]
				end
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
				GameTooltip:AddLine("|cffffffff - "..sname .." (".. (tonumber(cd) and cd > 0 and "+" or "").. cd .. (isRank and " [rank "..isRank.."]" or "") ..")|r")

				ELib.Tooltip:Add("spell:"..module.db.spell_durationByTalent_fix[ data[1] ][j])
			end
			something = true
		end
		do
			for auraID,sID in pairs(module.db.spell_aura_list) do
				if sID == data[1] then
					local sname = GetSpellInfo(auraID) or "???"
					GameTooltip:AddLine("|cffaaffaa"..L.cd2AddSpellFrameDurationLost..":|r")
					GameTooltip:AddLine("|cffffffff - \""..sname.."\"|r")

					something = true
				end
			end
		end

		if something then
			GameTooltip:Show()
		end
	end
	local function SpellsListDurTooltipFrameOnLeave(self)
	  	GameTooltip_Hide()
	  	ELib.Tooltip:HideAdd()	 
	end
	local function SpellsListColSetValue(self,value)
		local isEnabled = VMRT.ExCD2.colSet[value] and VMRT.ExCD2.colSet[value].enabled
	  	self.text:SetText(L.cd2AddSpellFrameColumnText.." "..(not isEnabled and "|cffff0000" or "|cffffffff")..value)
		if self.lock then return end
		if type(self.keystr) == "table" then
			for i=1,#self.keystr do
				VMRT.ExCD2.CDECol[ self.keystr[i] ] = value
			end
		else
			VMRT.ExCD2.CDECol[self.keystr] = value
		end
		module.options.list:Update()
		module:UpdateSpellDB()
	end

	local priorChangeDelay
	local function SpellsListPrioritySetValue(self,value)
	  	self.text:SetText(L.cd2Priority.." |cffffffff"..(100-value).."%")
		if self.lock then return end
		VMRT.ExCD2.Priority[ self:GetParent().data[1] ] = value
		if not priorChangeDelay then
			priorChangeDelay = C_Timer.NewTimer(.5,function()
				priorChangeDelay = nil
				UpdateRoster()
				module:UpdateSpellDB()
			end)
		end
	end

	local function SpellsListButtonModifyOnClick(self)
		if module.options.addModSpellFrame:IsShown() then
			module.options.addModSpellFrame:Hide()
		end
		module.options.addModSpellFrame.data = self:GetParent().data
		module.options.addModSpellFrame:Show()
	end
	local function SpellsListButtonAddOnClick(self)
		if module.options.addModSpellFrame:IsShown() then
			module.options.addModSpellFrame:Hide()
		end
		module.options.addModSpellFrame.data = nil
		module.options.addModSpellFrame:Show()
	end

	local function SpellsListButtonStarButOnClick(self)
		local spellID = self:GetParent().data[1]
		VMRT.ExCD2.OptFav[spellID] = not VMRT.ExCD2.OptFav[spellID]
		self:Update(VMRT.ExCD2.OptFav[spellID] and 2 or 1)
	end
	local function SpellsListButtonStarButUpdate(self,type)
		if type == 1 or not type then
			self.NormalTexture:TexCoord(.5,1,.5,1):Color(.25,.25,.3,1)
			self.HighlightTexture:TexCoord(0,.5,.5,1):Color(.25,.25,.3,1)
			self.PushedTexture:TexCoord(0,.5,.5,1):Color(.5,.5,.3,1)
	  	elseif type == 2 then
			self.NormalTexture:TexCoord(0,.5,0,.5):Color(1,1,1,1)
			self.HighlightTexture:TexCoord(0,.5,0,.5):Color(.5,.5,1,1)
			self.PushedTexture:TexCoord(0,.5,0,.5):Color(.5,.5,1,1)
		end
	end
	local function SpellsListButtonSortByCol()
		module.options.list.sortByCol = true
		module.options.list:UpdateDB(module.options.list.current)
		module.options.list:Update()
	end
	local function SpellsListButtonSortByColOnEnter(self)
		self.text:Color()
	end
	local function SpellsListButtonSortByColOnLeave(self)
		self.text:Color(1,.82,0,1)
	end

	self.list.lines = {}
	for i=1,ceil(589/SPELL_LINE_HEIGHT)+2 do
		local line = CreateFrame("Frame",nil,self.list.C)
		self.list.lines[i] = line
		line:SetPoint("TOPLEFT",0,-(i-1)*SPELL_LINE_HEIGHT)
		line:SetPoint("RIGHT",0,0)
		line:SetHeight(SPELL_LINE_HEIGHT)

		line.chk = ELib:Check(line):Point("LEFT",10,0):OnClick(SpellsListChkOnClick)
		line.chk.UpdateColors = SpellsListChkUpdateColors

		line.chk.CheckedTexture:SetVertexColor(0.2,1,0.2,1)

		line.backClassColor = line:CreateTexture(nil, "BACKGROUND")
		line.backClassColor:SetPoint("LEFT",0,0)
		line.backClassColor:SetSize(350,SPELL_LINE_HEIGHT)
		line.backClassColor:SetColorTexture(1, 1, 1, 1)
		line.backClassColorR = 0
		line.backClassColorG = 0
		line.backClassColorB = 0

		line:SetScript("OnUpdate",SpellsListLineOnUpdate)

		line.icon = line:CreateTexture(nil, "ARTWORK")
		line.icon:SetSize(28,28)
		line.icon:SetPoint("LEFT", line.chk,"RIGHT", 10, 0)
		line.icon:SetTexCoord(.1,.9,.1,.9)
		ELib:Border(line.icon,1,.12,.13,.15,1)

		line.spellName = ELib:Text(line):Size(200,SPELL_LINE_HEIGHT):Point("LEFT",line.icon,"RIGHT",5,0):Font(ExRT.F.defFont,12):Shadow()

		line.tooltipFrame = CreateFrame("Frame",nil,line)
		line.tooltipFrame:SetAllPoints(line.spellName)
		line.tooltipFrame:SetScript("OnEnter", SpellsListTooltipFrameOnEnter)
		line.tooltipFrame:SetScript("OnLeave", SpellsListTooltipFrameOnLeave)

		line.class = line:CreateTexture(nil, "ARTWORK")
		line.class:SetSize(22,22)
		line.class:SetPoint("LEFT", line.spellName, "RIGHT", 5, 0)
		line.class:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")

		line.spec = line:CreateTexture(nil, "ARTWORK")
		line.spec:SetSize(22,22)
		line.spec:SetPoint("RIGHT", line.class, "LEFT", -2, 0)

		line.spec1 = line:CreateTexture(nil, "ARTWORK")
		line.spec1:SetSize(16,16)
		line.spec1:SetPoint("TOPRIGHT", line.class, "TOPLEFT", -2, 0)

		line.spec2 = line:CreateTexture(nil, "ARTWORK")
		line.spec2:SetSize(16,16)
		line.spec2:SetPoint("RIGHT", line.spec1, "LEFT", -1, 0)

		line.spec3 = line:CreateTexture(nil, "ARTWORK")
		line.spec3:SetSize(16,16)
		line.spec3:SetPoint("RIGHT", line.spec2, "LEFT", -1, 0)

		line.spec4 = line:CreateTexture(nil, "ARTWORK")
		line.spec4:SetSize(16,16)
		line.spec4:SetPoint("RIGHT", line.spec3, "LEFT", -1, 0)

		line.col = ELib:Slider(line,""):Size(120):Point("LEFT",line.class,"RIGHT",15,-1):Range(1,10):SetTo(11):OnChange(SpellsListColSetValue)
		line.col:SetObeyStepOnDrag(true)
		line.col.Low:Hide()
		line.col.High:Hide()
		line.col:SetScript("OnEnter",nil)
		line.col:SetScript("OnLeave",nil)
		line.col:HideBorders()
		line.col.Thumb:SetSize(12,12)
		line.col.Thumb:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256")
		line.col.Thumb:SetVertexColor(0.44,0.45,0.50,1)
		line.col.backline = line.col:CreateTexture(nil,"BACKGROUND")
		line.col.backline:SetColorTexture(0.44,0.45,0.50,0.7)
		line.col.backline:SetPoint("LEFT")
		line.col.backline:SetPoint("RIGHT")
		line.col.backline:SetHeight(4)
		line.col.Text:SetFont(GameFontHighlight:GetFont(),10,"")
		line.col.Text:SetTextColor(0.84,0.85,0.90,1)
		line.col:SetScript("OnMouseWheel",nil)
		line.col.ThumbBySpec = {}
		for j=1,4 do
			local Thumb = line.col:CreateTexture(nil,"ARTWORK",nil,1-j)
			line.col.ThumbBySpec[j] = Thumb
			Thumb:SetSize(14,14)
			Thumb:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask")
			Thumb:Hide()
		end

		line.colBack = CreateFrame("Frame",nil,line)
		line.colBack:SetHeight(SPELL_LINE_HEIGHT)
		line.colBack:SetPoint("LEFT",line.col)
		line.colBack:SetPoint("RIGHT",line.col)

		line.colExpand = ELib:Button(line,L.cd2BySpec):Size(120,8):Point("LEFT",line.col,0,0):Point("BOTTOM",line,0,0):OnClick(SpellsListLineColExpand)
		if ExRT.is10 then
			line.colExpand.Texture:SetGradient("VERTICAL",CreateColor(0.05,0.26,0.09,1), CreateColor(0.20,0.41,0.25,1))
		else
			line.colExpand.Texture:SetGradientAlpha("VERTICAL",0.05,0.26,0.09,1, 0.20,0.41,0.25,1)
		end
		local textObj = line.colExpand:GetTextObj()
		textObj:SetFont(textObj:GetFont(),8,"")


		line.prior = ELib:Slider(line,""):Size(120):Point("LEFT",line.col,"RIGHT",15,0):Range(0,100):SetTo(101):OnChange(SpellsListPrioritySetValue)
		line.prior:SetObeyStepOnDrag(true)
		line.prior.Low:Hide()
		line.prior.High:Hide()
		line.prior:SetScript("OnEnter",nil)
		line.prior:SetScript("OnLeave",nil)
		line.prior:HideBorders()
		line.prior.Thumb:SetSize(4,12)
		line.prior.Thumb:SetColorTexture(0.44,0.45,0.50,1)
		line.prior.backline = line.prior:CreateTexture(nil,"BACKGROUND")
		line.prior.backline:SetColorTexture(0.44,0.45,0.50,0.7)
		line.prior.backline:SetPoint("LEFT")
		line.prior.backline:SetPoint("RIGHT")
		line.prior.backline:SetHeight(4)
		line.prior.Text:SetFont(GameFontHighlight:GetFont(),10,"")
		line.prior.Text:SetTextColor(0.84,0.85,0.90,1)
		line.prior:SetScript("OnMouseWheel",nil)

		line.cd = ELib:Text(line,""):Size(40,SPELL_LINE_HEIGHT):Point("LEFT",line.prior,"RIGHT",15,1):Font(ExRT.F.defFont,14):Shadow():Center():Color(1,.3,.3)
		line.cdTooltipFrame = CreateFrame("Frame",nil,line)
		line.cdTooltipFrame:SetAllPoints(line.cd)
		line.cdTooltipFrame:SetScript("OnEnter", SpellsListCDTooltipFrameOnEnter)
		line.cdTooltipFrame:SetScript("OnLeave", SpellsListCDTooltipFrameOnLeave)

		line.dur = ELib:Text(line,""):Size(40,SPELL_LINE_HEIGHT):Point("LEFT",line.cd,"RIGHT",5,0):Font(ExRT.F.defFont,14):Shadow():Center():Color(.3,1,.3)
		line.durTooltipFrame = CreateFrame("Frame",nil,line)
		line.durTooltipFrame:SetAllPoints(line.dur)
		line.durTooltipFrame:SetScript("OnEnter", SpellsListDurTooltipFrameOnEnter)
		line.durTooltipFrame:SetScript("OnLeave", SpellsListDurTooltipFrameOnLeave)

		line.buttonModify = ELib:Button(line,">>"):Size(40,20):Point("LEFT",line.dur,"RIGHT",5,0):OnClick(SpellsListButtonModifyOnClick)

		line.buttonAddBig = ELib:Button(line,ADD):Size(0,20):Point("LEFT",10,0):Point("RIGHT",-10,0):OnClick(SpellsListButtonAddOnClick)

		line.starBut = ELib:Button(line,"",1):Size(20,20):Point("LEFT",line.dur,"RIGHT",10,0):OnClick(SpellsListButtonStarButOnClick):Tooltip(L.cd2Favorite)
		line.starBut.Update = SpellsListButtonStarButUpdate
		line.starBut.NormalTexture = ELib:Texture(line.starBut,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\star2"):Point('x')
		line.starBut.HighlightTexture = ELib:Texture(line.starBut,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\star2"):Point('x')
		line.starBut.PushedTexture = ELib:Texture(line.starBut,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\star2"):Point('x')

		line.starBut:SetNormalTexture(line.starBut.NormalTexture)
		line.starBut:SetHighlightTexture(line.starBut.HighlightTexture)
		line.starBut:SetPushedTexture(line.starBut.PushedTexture)

		line.buttonSortByCol = ELib:Button(line,"",1):Size(0,18):Point("LEFT",line.col,0,0):Point("RIGHT",line.col,0,0):OnClick(SpellsListButtonSortByCol):OnEnter(SpellsListButtonSortByColOnEnter):OnLeave(SpellsListButtonSortByColOnLeave)
		line.buttonSortByCol.text = ELib:Text(line.buttonSortByCol,L.cd2SortOpt,10):Point("CENTER",line.buttonSortByCol)
		line.buttonSortByCol.arrow = ELib:Texture(line.buttonSortByCol,"Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128"):Point("LEFT",line.buttonSortByCol.text,"RIGHT",2,0):Size(14,14):TexCoord(0.25,0.3125,0.5,0.625)

		line:Hide()
	end

	self.list.colBySpecFrame = CreateFrame("Frame",nil,self)
	self.list.colBySpecFrame:SetWidth(155)
	self.list.colBySpecFrame:SetFrameStrata("DIALOG")
	self.list.colBySpecFrame.background = self.list.colBySpecFrame:CreateTexture(nil,"BACKGROUND")
	self.list.colBySpecFrame.background:SetAllPoints()
	self.list.colBySpecFrame.background:SetColorTexture(0,0,0,.8)
	ELib:Border(self.list.colBySpecFrame,2,0.44,0.45,0.50,1)

	self.list.colBySpecFrame.close = ELib:Button(self.list.colBySpecFrame,"x"):Size(155-2,10):Point("BOTTOM",0,0):OnClick(function(self) self:GetParent():Hide() end)

	self.list.colBySpecFrame:Hide()
	self.list.colBySpecFrame.spec = {}
	function self.list.colBySpecFrame:Open(line,clickObj)
		if self:IsShown() and self.data == line.data[1] then
			self:Hide()
			return
		end

		self:ClearAllPoints()
		self:SetPoint("TOPRIGHT",clickObj,"BOTTOMRIGHT",5,-2)

		local class = line.data_class
		local spellID = line.data[1]

		local r,g,b = ExRT.F.classColorNum(class)
		self.background:SetColorTexture(r*0.5,g*0.5,b*0.5,1)

		local specs = line.colExpand.specs
		for i=1,#specs do
			local slider = self.spec[i]
			if not slider then
				slider = ELib:Slider(self,L.cd2AddSpellFrameColumnText.." 1"):Size(120):Point("RIGHT",self,"TOPRIGHT",-5,-3-SPELL_LINE_HEIGHT*(i-1)-SPELL_LINE_HEIGHT/2):Range(1,10):SetTo(1):OnChange(SpellsListColSetValue)
				self.spec[i] = slider
				slider:SetObeyStepOnDrag(true)
				slider.Low:Hide()
				slider.High:Hide()
				slider:SetScript("OnEnter",nil)
				slider:SetScript("OnLeave",nil)
				slider:HideBorders()
				slider.Thumb:SetSize(12,12)
				slider.Thumb:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\circle256")
				slider.Thumb:SetVertexColor(0.44,0.45,0.50,1)
				slider.backline = slider:CreateTexture(nil,"BACKGROUND")
				slider.backline:SetColorTexture(0.44,0.45,0.50,0.7)
				slider.backline:SetPoint("LEFT")
				slider.backline:SetPoint("RIGHT")
				slider.backline:SetHeight(4)
				slider.Text:SetFont(GameFontHighlight:GetFont(),10,"")
				slider.Text:SetTextColor(0.44,0.45,0.50,1)
				slider:SetScript("OnMouseWheel",nil)

				slider.icon = slider:CreateTexture(nil,"ARTWORK")
				slider.icon:SetPoint("RIGHT",slider,"LEFT",-5,0)
				slider.icon:SetSize(20,20)
			end
			slider.icon:SetTexture(ExRT.GDB.ClassSpecializationIcons[ specs[i] ])

			local specPos = line.colExpand.specsPos[i]
			local colStr = line.data[1]..";"..(specPos or 1)
			local col = VMRT.ExCD2.CDECol[colStr] or module.db.def_col[colStr] or line.data[3]
			slider.keystr = colStr
			slider.lock = true
			slider:SetTo(col)
			slider.lock = false

			slider:Show()
		end
		for i=#specs+1,#self.spec do
			self.spec[i]:Hide()
		end
		self:SetHeight(SPELL_LINE_HEIGHT * #specs + 10)

		self.data = line.data[1]

		self:Show()
	end

	local function SortCategories(cats)
		local new = {}
		for k,v in pairs(cats) do 
			new[#new+1] = k
		end
		sort(new,function(a,b) if a and b and self.CATEGORIES_VIS[a] and self.CATEGORIES_VIS[b] then return self.CATEGORIES_VIS[a].sort < self.CATEGORIES_VIS[b].sort end end)
		return new
	end

	function self.list:UpdateDB(categoryNow)
		self.current = categoryNow
		local list,cats = {},{}
		local extraData = {}
		local AllSpells = module.options:GetAllSpells(categoryNow == "PVP")
		for _,data in pairs(AllSpells) do
			if not categoryNow then
				list[#list+1] = data
				for cat in string.gmatch(data[2], "[^,]+") do
					cats[cat] = true
				end
			else
				for cat in string.gmatch(data[2], "[^,]+") do
					if cat == categoryNow then
						list[#list+1] = data
					end
					cats[cat] = true
				end
				if (categoryNow == "ENABLED" and data[1] and GetSpellInfo(data[1]) and VMRT.ExCD2.CDE[ data[1] ]) then
					list[#list+1] = data
				end
				if (categoryNow == "FAV" and data[1] and VMRT.ExCD2.OptFav[ data[1] ]) then
					list[#list+1] = data
				end
			end
		end
		if self.search then
			for i=#list,1,-1 do
				local name = GetSpellInfo(list[i][1])
				if name and not name:lower():find(self.search) then
					tremove(list,i)
				end
			end
		end
		if categoryNow ~= "PVP" then
			cats["PVP"] = nil
		end
		cats = SortCategories(cats)
		if categoryNow and module.options.CATEGORIES_VIS[categoryNow].isClassCategory then
			local class = categoryNow
			local specList = not ExRT.isClassic and module.db.specByClass[class] or {0}

			local newList = {}
			local specsLen = #specList - 1
			for i=1,#specList do
				local specID = specList[i] or 0
				local icon
				if module.db.specIcons[specID] then
					icon = "|T".. module.db.specIcons[specID] ..":20|t"
				else
					icon = ExRT.F.classIconInText(class,20) or ""
				end
				newList[#newList+1] = {cat = (icon or "").." |c"..ExRT.F.classColor(class)..L.specLocalizate[module.db.specInLocalizate[specID]], specID = specID, specPos = i, sortBut = i==1}
				local count = 0
				for j=1,#list do
					local line = list[j]
					for cat in string.gmatch(line[2], "[^,]+") do
						if 
							cat == categoryNow and
							(
								(i == 1 and line[4]) or
								(i == 1 and not line[4] and ((specsLen == 1 and line[5]) or (specsLen == 2 and line[5] and line[6]) or (specsLen == 3 and line[5] and line[6] and line[7]) or (specsLen == 4 and line[5] and line[6] and line[7] and line[8]))) or
								(i > 1 and line[4+i-1])
							)
						then
							newList[#newList+1] = line
							if i > 1 then
								extraData[#newList] = {specID = i, specPos = i}
							end
							count = count + 1
							break
						end
					end
				end
				if count == 0 then
					tremove(newList,#newList)
				end
			end
			list = newList
		elseif categoryNow and not module.options.CATEGORIES_VIS[categoryNow].ignoreSubcats then
			local newList = {}
			for i=1,#cats do
				if not module.options.CATEGORIES_VIS[categoryNow].ignoreOwncat or cats[i] ~= categoryNow then
					newList[#newList+1] = {cat = module.options.CATEGORIES_VIS[ cats[i] ] and module.options.CATEGORIES_VIS[ cats[i] ].name or cats[i]}
					local count = 0
					for j=1,#list do
						for cat in string.gmatch(list[j][2], "[^,]+") do
							if cat == cats[i] then
								newList[#newList+1] = list[j]
								count = count + 1
								break
							end
						end
					end
					if count == 0 then
						tremove(newList,#newList)
					end
				end
			end
			list = newList
		elseif categoryNow and module.options.CATEGORIES_VIS[categoryNow].ignoreSubcats then
			tinsert(list,1,{cat = module.options.CATEGORIES_VIS[categoryNow] and module.options.CATEGORIES_VIS[categoryNow].name or categoryNow,sortBut = true})
		elseif not categoryNow then
			local newList = {}
			for i=1,#cats do
				newList[#newList+1] = {cat = module.options.CATEGORIES_VIS[ cats[i] ] and module.options.CATEGORIES_VIS[ cats[i] ].name or cats[i]}
				local count = 0
				for j=1,#list do
					for cat in string.gmatch(list[j][2], "[^,]+") do
						if cat == cats[i] then
							newList[#newList+1] = list[j]
							count = count + 1
							break
						end
					end
					--[[
					local cat1,cat2 = strsplit(",",list[j][2])
					local cat = (not ExRT.GDB.ClassID[cat1] and cat1 ~= "NO") and cat1 or cat2 or cat1
					if cat == cats[i] then
						newList[#newList+1] = list[j]
						count = count + 1
					end
					]]
				end
				if count == 0 then
					tremove(newList,#newList)
				end
			end
			if not self.search then
				newList[#newList+1] = {isAddButton = true}
			end
			list = newList
		end
		self.list = list
		self.extraData = extraData
		if self.sortByCol then
			self.sortByCol = nil
			local p = 0
			local colData = {}
			for i=1,#list do
				local data = list[i]
				if data[1] then
					local col = VMRT.ExCD2.CDECol[data[1]..";1"] or module.db.def_col[data[1]..";1"] or data[3]
					if extraData[i] and extraData[i].specPos then
						col = VMRT.ExCD2.CDECol[data[1]..";"..(extraData[i].specPos)] or col
					elseif not data[4] then
						for j=5,8 do
							if data[j] then
								local newcol = VMRT.ExCD2.CDECol[data[1]..";"..(j-3)]
								if newcol then
									col = newcol
									break
								end
							end
						end
					end
					colData[i] = {p + col,i}
				else
					p = p + 20
					colData[i] = {p,i}
				end
			end
			sort(colData,function(a,b) return a[1]<b[1] end)
			local newList = {}
			local newExtra = {}
			for i=1,#colData do
				newList[i] = list[ colData[i][2] ]
				newExtra[i] = extraData[ colData[i][2] ]
			end
			self.list = newList
			self.extraData = extraData
		elseif categoryNow == "ITEMS" and #list > 0 then
			local header = list[1]
			tremove(list, 1)
			local listLen = #list
			for i=1,#list/2 do
				list[i], list[listLen-i+1] = list[listLen-i+1], list[i]
				extraData[i], extraData[listLen-i+1] = extraData[listLen-i+1], extraData[i]
			end
			tinsert(list, 1, header)
		end
	end
	function self.list:Update()
		local scroll = self.ScrollBar:GetValue()
		self:SetVerticalScroll(scroll % SPELL_LINE_HEIGHT) 
		local start = floor(scroll / SPELL_LINE_HEIGHT) + 1

		local list = self.list
		local lineCount = 1
		for i=start,#list do
			local data = list[i]
			local extraData = self.extraData[i]
			local line = self.lines[lineCount]
			lineCount = lineCount + 1
			if not line then
				break
			end
			local isHideMost = false

			line.spec:Hide()
			line.spec1:Hide()
			line.spec2:Hide()
			line.spec3:Hide()
			line.starBut:Hide()
			line.buttonSortByCol:Hide()

			if data.cat then
				line.spellName:SetText(data.cat)

				line.class:Hide()
				line.colBack:Hide()
				line.buttonModify:Hide()

				line.data = nil

				line.buttonAddBig:Hide()

				if data.sortBut then
					line.buttonSortByCol:Show()
				end

				isHideMost = true
			elseif data.isAddButton then
				line.spellName:SetText("")

				line.class:Hide()
				line.colBack:Hide()
				line.buttonModify:Hide()

				line.data = nil

				line.buttonAddBig:Show()

				isHideMost = true
			else
				local spellName,_,spellTexture = GetSpellInfo(data[1])
				line.icon:SetTexture(spellTexture)
				line.spellName:SetText(spellName or "Removed spell #"..data[1])

				line.tooltipFrame.link = nil
				line.isItem = nil
				if strsplit(",",data[2]) == "ITEMS" then
					for itemID,itemSpellID in pairs(module.db.itemsToSpells) do
						if itemSpellID == data[1] then
							local itemName,_,itemQuality = GetItemInfo(itemID)
							if itemName then
								line.spellName:SetText((itemQuality and ITEM_QUALITY_COLORS[itemQuality] and ITEM_QUALITY_COLORS[itemQuality].hex or "")..itemName)
							end
							local itemTexture = select(5,GetItemInfoInstant(itemID))
							line.icon:SetTexture(itemTexture)
							line.tooltipFrame.link = "item:"..itemID
							break
						end
					end
					line.isItem = true
				end

				local class,specPos = nil
				local dataSpecs = 0
				for cat in string.gmatch(data[2], "[^,]+") do
					if ExRT.GDB.ClassID[cat] then
						class = cat
						break
					end
				end
				local cR,cG,cB = ExRT.F.classColorNum(class)

				line.backClassColorR = cR
				line.backClassColorG = cG
				line.backClassColorB = cB

				if class then
					if class == "EVOKER" then
						line.class:SetTexture("interface/icons/classicon_evoker")
						line.class:SetTexCoord(0,1,0,1)
					else
						line.class:SetTexture("Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES")
						line.class:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
					end
					line.class:Show()


					local specs = ExRT.GDB.ClassSpecializationList[class]
					local specID = nil
					for j=4,4+#specs do
						if data[j] then
							dataSpecs = dataSpecs + 1
							specID = specs[j-4]
						end
					end
					if data[4] and not ExRT.isClassic then
						dataSpecs = #specs
					end
					line.colExpand.specs = {}
					line.colExpand.specsPos = {}
					local specIcon = 1
					for j=5,4+#specs do
						if data[j] or data[4] then
							line.colExpand.specs[#line.colExpand.specs+1] = specs[j-4]
							line.colExpand.specsPos[#line.colExpand.specsPos+1] = j - 3

							if data[j] then
								local icon = line["spec"..specIcon]
								if icon then
									icon:SetTexture(ExRT.GDB.ClassSpecializationIcons[ specs[j-4] ])
									icon:Show()
									specIcon = specIcon + 1
								end
							end
						end
					end
					if dataSpecs > 1 then
						line.colBack:Show()
					else
						line.colBack:Hide()
						if specID then
							line.spec:SetTexture(ExRT.GDB.ClassSpecializationIcons[specID])
							line.spec:Show()
							line.spec1:Hide()
						else
							line.spec:Hide()
						end
					end
					for j=4,4+#specs do
						if data[j] then
							specPos = j - 3
							break
						end
					end
				else
					line.class:Hide()
					line.colBack:Hide()
				end
				line.data_class = class

				if module.db.spell_isPetAbility[ data[1] ] then
					line.spec:SetTexture(613074)
					line.spec:Show()
				end

				local covenantID = module.db.spell_covenant[ data[1] ]
				if covenantID then
					local texture = covenantID == 1 and "shadowlands-landingbutton-kyrian-up" or
							covenantID == 2 and "shadowlands-landingbutton-venthyr-up" or
							covenantID == 3 and "shadowlands-landingbutton-NightFae-up" or
							covenantID == 4 and "shadowlands-landingbutton-necrolord-up"
					if texture then
						line.spec:SetAtlas(texture)
						line.spec:Show()
					end
				end

				for j=1,4 do 
					line.col.ThumbBySpec[j]:Hide()
				end
				local colDefStr = data[1]..";"..(specPos or 1)
				local col = VMRT.ExCD2.CDECol[colDefStr] or module.db.def_col[colDefStr] or data[3]
				if extraData and extraData.specPos then
					local specPos = extraData.specPos
					col = VMRT.ExCD2.CDECol[data[1]..";"..specPos] or col or data[3]
				end
				local defCol = col
				line.col.keystr = colDefStr
				if dataSpecs > 1 then
					line.col.keystr = {}
					local updateCol = data[4]
					if updateCol then
						line.col.keystr[#line.col.keystr+1] = colDefStr
					end
					local miniIcon = {}
					for j=5,8 do
						if data[j] or (data[4] and ExRT.GDB.ClassSpecializationList[class][j-4]) then
							local str = data[1]..";"..(j-3)
							line.col.keystr[#line.col.keystr+1] = str
							if not updateCol and VMRT.ExCD2.CDECol[str] then
								updateCol = true
								col = VMRT.ExCD2.CDECol[str]
							end
							local specs = ExRT.GDB.ClassSpecializationList[class]
							if specs then
								local p = VMRT.ExCD2.CDECol[str] or VMRT.ExCD2.CDECol[data[1]..";1"] or module.db.def_col[str] or module.db.def_col[data[1]..";1"] or data[3]
								if p ~= defCol then
									local t = line.col.ThumbBySpec[j-4]
									t:SetPoint("CENTER",line.col,"LEFT",7 + (line.col:GetWidth() - 14) / 9 * (p-1),miniIcon[p] == 1 and -5 or miniIcon[p] == 2 and 5 or 0)
									t:SetTexture(ExRT.GDB.ClassSpecializationIcons[ specs[j-4] ])
									t:Show()
									miniIcon[p] = (miniIcon[p] or 0) + 1
								end
							end
						end
					end
				end
				if extraData and extraData.specPos then
					local specPos = extraData.specPos
					col = VMRT.ExCD2.CDECol[data[1]..";"..specPos] or col or data[3]
					line.col.keystr = data[1]..";"..specPos
				end
				line.col.lock = true
				line.col:SetTo(col)
				line.col.lock = false


				line.prior.lock = true
				line.prior:SetTo(VMRT.ExCD2.Priority[ data[1] ] or 50)
				line.prior.lock = false

				local first = nil
				for j=4,4+4 do
					if data[j] then
						first = data[j]
						break
					end
				end
				if first then
					line.cd:SetFormattedText("%d:%02d",first[2]/60,first[2]%60)
					if first[3] > 0 then
						line.dur:SetFormattedText("%d:%02d",first[3]/60,first[3]%60)
					else
						line.dur:SetText("")
					end
				else
					line.cd:SetFormattedText("")
					line.dur:SetText("")
				end

				local findUserCat = false
				for cat in string.gmatch(data[2], "[^,]+") do
					if cat == "USER" then
						findUserCat = true
						break
					end
				end
				line.buttonModify:SetShown(findUserCat)

				line.buttonAddBig:Hide()

				if spellName then
					line.chk.disabled = false
				else
					line.chk.disabled = true
				end
				line.chk:SetChecked(VMRT.ExCD2.CDE[ data[1] ])
				line.chk:UpdateColors()

				if spellName and VMRT.ExCD2.OptFav[ data[1] ] then
					line.starBut:Update(2)
				else
					line.starBut:Update(1)
				end
				line.starBut:SetShown(not findUserCat)

				line.data = data
			end
			line.icon:SetShown(not isHideMost)
			line.icon.border_top:SetShown(not isHideMost)
			line.icon.border_bottom:SetShown(not isHideMost)
			line.icon.border_left:SetShown(not isHideMost)
			line.icon.border_right:SetShown(not isHideMost)
			line.backClassColor:SetShown(not isHideMost)
			line.chk:SetShown(not isHideMost)
			line.col:SetShown(not isHideMost)
			line.prior:SetShown(not isHideMost)
			line.cd:SetShown(not isHideMost)
			line.dur:SetShown(not isHideMost)
			line.tooltipFrame:SetShown(not isHideMost)

			line:Show()
		end
		for i=lineCount,#self.lines do
			self.lines[i]:Hide()
		end
		self:Height(SPELL_LINE_HEIGHT * #list)
	end
	self.list.ScrollBar.slider:SetScript("OnValueChanged", function(self)
		self:GetParent():GetParent():Update()
		self:UpdateButtons()
	end)


	self.searchEditBox = ELib:Edit(self.tab.tabs[1]):Point("TOPLEFT",400,18):Size(140,16):AddSearchIcon():OnChange(function (self,isUser)
		if not isUser then
			return
		end
		local text = self:GetText():lower()
		if text == "" then
			text = nil
		end
		module.options.list.search = text

		if self.scheduledUpdate then
			return
		end
		self.scheduledUpdate = C_Timer.NewTimer(.3,function()
			self.scheduledUpdate = nil
			module.options.list:UpdateDB(module.options.list.current)
			module.options.list:Update()
		end)
	end):Tooltip(SEARCH)
	self.searchEditBox:SetTextColor(0,1,0,1)


	self.addModSpellFrame = ELib:Popup():Size(570,250)

	self.addModSpellFrame.Save = ELib:Button(self.addModSpellFrame,L.BossmodsKromogSetupsSave):Size(558,20):Point("BOTTOM",0,1):OnClick(function(self)
		local parent = self:GetParent()
		local data = parent.data
		if not data then
			return
		end
		for i=4,8 do
			if data[i] and data[i][1] == 0 then
				data[i] = nil
			end
		end
		if data[1] == 0 then
			return
		end
		if data[2] and strsplit(",",data[2]) == "ITEMS" and not data.itemID then
			return
		end
		if data[4] or data[5] or data[6] or data[7] or data[8] then
			local isNew = true
			local AllSpells = module.options:GetAllSpells(true)
			for _,line in pairs(AllSpells) do
				if line == data then
					isNew = false
					break
				end
			end
			if isNew then
				VMRT.ExCD2.userDB[#VMRT.ExCD2.userDB+1] = data
			end
			module.options.list:UpdateDB(module.options.list.current)
			module.options.list:Update()

			module:UpdateSpellDB(true)
		end

		parent:Hide()
	end)
	function self.addModSpellFrame.Save:Check()
		local parent = self:GetParent()
		local data = parent.data
		local spellID = data[1]
		if not GetSpellInfo(spellID) then
			self:Disable()
			parent.spellIDIcon:ColorBorder(true)
			return
		end
		if data[2] and strsplit(",",data[2]) == "ITEMS" and not data.itemID then
			self:Disable()
			parent.itemToSpell:ColorBorder(true)
			return
		end
		local AllSpells = module.options:GetAllSpells(true)
		for _,line in pairs(AllSpells) do
			if line[1] == spellID and line ~= parent.data then
				self:Disable()
				parent.spellIDIcon:ColorBorder(true)
				return
			end
		end
		parent.spellIDIcon:ColorBorder()
		parent.itemToSpell:ColorBorder()
		self:Enable()
	end
	self.addModSpellFrame:SetScript("OnHide",function(self)
		--self.Save:Click()
	end)

	self.addModSpellFrame.spellIDIcon = ELib:Edit(self.addModSpellFrame):Size(100,20):Point("TOPLEFT",150,-50):LeftText("Spell ID (for icon):"):OnChange(function(self,isUser)
		local text = self:GetText() or ""
		if not tonumber(text) then
			text = "0"
		end
		local spellID = tonumber(text)
		local parent = self:GetParent()
		parent.data[1] = spellID
		parent.Save:Check()

		local spellName,_,spellIcon = GetSpellInfo(spellID)
		self.RightText:SetText((spellIcon and "|T"..spellIcon..":20|t " or "")..(spellName or ""))
	end)
	self.addModSpellFrame.spellIDIcon.leftText:Color():Shadow()
	self.addModSpellFrame.spellIDIcon.RightText = ELib:Text(self.addModSpellFrame.spellIDIcon,"",12):Point("LEFT",self.addModSpellFrame.spellIDIcon,"RIGHT",5,0):Color():Shadow()

	local function addModSpellFrameEditCLEU(self)
		local text = self:GetText() or ""
		self.data[1] = tonumber(text) or 0
	end
	local function addModSpellFrameEditCD(self)
		local text = self:GetText() or ""
		self.data[2] = tonumber(text) or 0
	end
	local function addModSpellFrameEditDur(self)
		local text = self:GetText() or ""
		self.data[3] = tonumber(text) or 0
	end

	for i=1,5 do
		self.addModSpellFrame["spellIDCLEU"..i] = ELib:Edit(self.addModSpellFrame):Size(180,20):Point("TOPLEFT",150,-100-(i-1)*25):OnChange(addModSpellFrameEditCLEU):Tooltip("Leave empty for ignoring"):LeftText("")
		self.addModSpellFrame["spellIDCLEU"..i].leftText:Color():Shadow()

		self.addModSpellFrame["cd"..i] = ELib:Edit(self.addModSpellFrame):Size(100,20):Point("LEFT",self.addModSpellFrame["spellIDCLEU"..i],"RIGHT",10,0):OnChange(addModSpellFrameEditCD)

		self.addModSpellFrame["dur"..i] = ELib:Edit(self.addModSpellFrame):Size(100,20):Point("LEFT",self.addModSpellFrame["cd"..i],"RIGHT",10,0):OnChange(addModSpellFrameEditDur)
	end
	self.addModSpellFrame.spellIDCLEUtext = ELib:Text(self.addModSpellFrame,"Spell ID (for combat log event)",12):Point("BOTTOM",self.addModSpellFrame.spellIDCLEU1,"TOP",0,2):Color():Shadow()
	self.addModSpellFrame.cdtext = ELib:Text(self.addModSpellFrame,L.cd2EditBoxCDTooltip,12):Point("BOTTOM",self.addModSpellFrame.cd1,"TOP",0,2):Color():Shadow()
	self.addModSpellFrame.durtext = ELib:Text(self.addModSpellFrame,L.cd2EditBoxDurationTooltip,12):Point("BOTTOM",self.addModSpellFrame.dur1,"TOP",0,2):Color():Shadow()

	self.addModSpellFrame.dropDown = ELib:DropDown(self.addModSpellFrame,200,10):Size(210):Point("TOPLEFT",150,-25)
	self.addModSpellFrame.dropDown.LeftText = ELib:Text(self.addModSpellFrame.dropDown,L.cd2Class..":",12):Point("RIGHT",self.addModSpellFrame.dropDown,"LEFT",-5,0):Color():Shadow()

	function self.addModSpellFrame.dropDown:SetValue(newValue)
		ELib:DropDownClose()

		module.options.addModSpellFrame.data[2] = newValue .. ",USER"

		module.options.addModSpellFrame:Update()
	end

	for i=1,#module.db.classNames do
		local class = module.db.classNames[i]
		self.addModSpellFrame.dropDown.List[#self.addModSpellFrame.dropDown.List + 1] = {
			text = "|c"..ExRT.F.classColor(class)..L.classLocalizate[class],
			justifyH = "CENTER",
			func = self.addModSpellFrame.dropDown.SetValue,
			arg1 = class,
		}
	end
	if ExRT.isClassic then
		tremove(self.addModSpellFrame.dropDown.List, 12)
		tremove(self.addModSpellFrame.dropDown.List, 10)
		if not ExRT.isLK then tremove(self.addModSpellFrame.dropDown.List, 6) end
	end

	self.addModSpellFrame.dropDown.List[#self.addModSpellFrame.dropDown.List + 1] = {
		text = L.cd2CatItems,
		justifyH = "CENTER",
		func = self.addModSpellFrame.dropDown.SetValue,
		arg1 = "ITEMS",
	}
	self.addModSpellFrame.dropDown.List[#self.addModSpellFrame.dropDown.List + 1] = {
		text = ALL,
		justifyH = "CENTER",
		func = self.addModSpellFrame.dropDown.SetValue,
		arg1 = "OTHER",
	}
	self.addModSpellFrame.dropDown.Lines = #self.addModSpellFrame.dropDown.List


	self.addModSpellFrame.Delete = ELib:Button(self.addModSpellFrame,DELETE):Size(100,20):Point("LEFT",self.addModSpellFrame.dropDown,"RIGHT",50,0):OnClick(function(self)
		local parent = self:GetParent()
		local data = parent.data
		for i=1,#VMRT.ExCD2.userDB do
			if data == VMRT.ExCD2.userDB[i] then
				tremove(VMRT.ExCD2.userDB, i)
				break
			end
		end
		parent.data = nil

		module.options.list:UpdateDB(module.options.list.current)
		module.options.list:Update()

		module:UpdateSpellDB(true)

		parent:Hide()
	end)

	self.addModSpellFrame.isEquip = ELib:Check(self.addModSpellFrame,"|cffffffffIs Equipment:"):Left():Point("LEFT",self.addModSpellFrame["spellIDCLEU3"],"LEFT",0,0):OnClick(function(self)
		local parent = self:GetParent()
		local data = parent.data

		if self:GetChecked() then
			data.isEquip = true
		else
			data.isEquip = nil
		end
	end)

	self.addModSpellFrame.itemToSpell = ELib:Edit(self.addModSpellFrame,nil,true):Size(180,20):Point("LEFT",self.addModSpellFrame["spellIDCLEU4"],"LEFT",0,0):OnChange(function(self,isUser)
		local parent = self:GetParent()
		local data = parent.data

		self.RightText:SetText("")
		local itemID = tonumber(self:GetText() or "")

		data.itemID = itemID
		parent.Save:Check()

		if itemID then
			local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
			local _, spellID = GetItemSpell(itemID)
			if itemName then
				if spellID then
					self.RightText:SetText("SpellID: "..spellID.." (for item "..(itemIcon and "|T"..itemIcon..":20|t" or "")..itemName..")")
					return
				end
				self.RightText:SetText("No spell found for item "..(itemIcon and "|T"..itemIcon..":20|t" or "")..itemName)
				return
			end
			self.RightText:SetText("No item found")
		end
	end):LeftText("Item ID:"):Run(function(self) 
		self.leftText:Color() 
		self.RightText = ELib:Text(self,"",12):Point("TOPLEFT",self,"BOTTOMLEFT",3,-3):Color():Shadow()
	end)



	self.addModSpellFrame.Update = function(self)
		local data = self.data
		self.spellIDIcon:SetText(data[1])

		local class = "OTHER"
		for i=1,#self.dropDown.List do
			if strsplit(",",data[2]) == self.dropDown.List[i].arg1 then
				self.dropDown:SetText(self.dropDown.List[i].text)
				class = self.dropDown.List[i].arg1
				break
			end
		end

		local specList = not ExRT.isClassic and module.db.specByClass[class] or {0}
		for i=1,#specList do
			local specID = specList[i]
			local icon 
			if module.db.specIcons[specID] then
				icon = "|T".. module.db.specIcons[specID] ..":20|t"
			else
				icon = ExRT.F.classIconInText(class,20) or ""
			end

			self["spellIDCLEU"..i]:LeftText((icon or "").." |c"..ExRT.F.classColor(class)..L.specLocalizate[module.db.specInLocalizate[specID]])

			local dataSpec = data[3+i] or {0,0,0}
			data[3+i] = dataSpec
			self["spellIDCLEU"..i]:SetText(dataSpec[1])
			self["cd"..i]:SetText(dataSpec[2])
			self["dur"..i]:SetText(dataSpec[3])

			self["spellIDCLEU"..i].data = dataSpec
			self["cd"..i].data = dataSpec
			self["dur"..i].data = dataSpec

			self["spellIDCLEU"..i]:Show()
			self["cd"..i]:Show()
			self["dur"..i]:Show()
		end
		for i=#specList+1,5 do
			self["spellIDCLEU"..i]:Hide()
			self["cd"..i]:Hide()
			self["dur"..i]:Hide()
		end

		self.itemToSpell:SetText(data.itemID or "")
		self.isEquip:SetChecked(data.isEquip)
		self.itemToSpell:SetShown(class == "ITEMS")
		self.isEquip:SetShown(class == "ITEMS")

		local isNew = true
		local AllSpells = module.options:GetAllSpells(true)
		for _,line in pairs(AllSpells) do
			if line == data then
				isNew = false
				break
			end
		end
		self.Delete:SetShown(not isNew)
	end

	self.addModSpellFrame.OnShow = function(self)
		local data = self.data
		if not data then
			data = {0,"OTHER,USER",1,{0,0,0}}
			self.data = data
		end
		self:Update()
	end


	self.categories:Update()
	self.categories.buttons[1]:Click()


	--> OPTIONS TAB2: Customize
	self.optColHeader = ELib:Text(self.tab.tabs[2],L.cd2ColSet):Size(560,20):Point(15+80,-8)

	local currColOpt = {}

	function self:selectColumnTab()
		local i = self and self.colID or module.options.optColTabs.selected
		module.options.optColTabs.selected = i
		module.options.optColTabs:UpdateTabs()

		local isGeneralTab = i == (module.db.maxColumns + 1)

		local optColSet = module.options.optColSet
		local defOpt = module.db.colsDefaults
		local VColOpt = VMRT.ExCD2.colSet[i]

		optColSet.superTabFrame:Show()

		optColSet.LOCK = true
		currColOpt = {}

		if isGeneralTab then
			VColOpt.frameGeneral = nil
			VColOpt.iconGeneral = nil
			VColOpt.textureGeneral = nil
			VColOpt.fontGeneral = nil
			VColOpt.textGeneral = nil
			VColOpt.methodsGeneral = nil
		end
		optColSet.superTabFrame.list.LDisabled[10] = isGeneralTab
		optColSet.superTabFrame.list:Update()

		optColSet.chkEnable:SetChecked(VColOpt.enabled)
		optColSet.chkGeneral:SetChecked(VColOpt.frameGeneral)

		optColSet.sliderLinesNum:SetValue(VColOpt.frameLines or defOpt.frameLines)
		optColSet.sliderAlpha:SetValue(VColOpt.frameAlpha or defOpt.frameAlpha)
		optColSet.sliderScale:SetValue(VColOpt.frameScale or defOpt.frameScale)
		optColSet.sliderWidth:SetValue(VColOpt.frameWidth or defOpt.frameWidth)
		optColSet.sliderColsInCol:SetValue(VColOpt.frameColumns or defOpt.frameColumns)
		optColSet.sliderBetweenLines:SetValue(VColOpt.frameBetweenLines or defOpt.frameBetweenLines)
		optColSet.sliderBlackBack:SetValue(VColOpt.frameBlackBack or defOpt.frameBlackBack)
		optColSet.dropDownStrata:SetText(VColOpt.frameStrata or defOpt.frameStrata)
		if VColOpt.ATF and not VColOpt.frameStrata then
			optColSet.dropDownStrata:SetText("Auto")
		end

		optColSet.chkGeneral:doAlphas()

		optColSet.sliderHeight:SetValue(VColOpt.iconSize or defOpt.iconSize)
		optColSet.chkGray:SetChecked(VColOpt.iconGray)
		optColSet.chkCooldown:SetChecked(VColOpt.methodsCooldown)
		optColSet:chkCooldownTextUpdate()
		optColSet.chkCooldownShowSwipe:SetChecked(VColOpt.iconCooldownShowSwipe)
		optColSet.chkShowTitles:SetChecked(VColOpt.iconTitles)
		optColSet.chkHideBlizzardEdges:SetChecked(VColOpt.iconHideBlizzardEdges)
		optColSet.chkMasque:SetChecked(VColOpt.iconMasque)
		optColSet.chkGeneralIcons:SetChecked(VColOpt.iconGeneral)
		do
			local defIconPos = VColOpt.iconPosition or defOpt.iconPosition
			optColSet.dropDownIconPos:SetText( optColSet.dropDownIconPos.PosNames[defIconPos])
		end
		if optColSet.dropDownCooldownGlowType.List[ VColOpt.iconGlowType or 1 ] then
			optColSet.dropDownCooldownGlowType:SetText(optColSet.dropDownCooldownGlowType.List[ VColOpt.iconGlowType or 1 ].text)
		end

		optColSet.chkGeneralIcons:doAlphas()

		do
			local texturePos = nil
			for j=1,#ExRT.F.textureList do
				if ExRT.F.textureList[j] == (VColOpt.textureFile or ExRT.F.barImg) then
					texturePos = j
					break
				end
			end
			if not texturePos and VColOpt.textureFile then
				texturePos = select(3,string.find(VColOpt.textureFile,"\\([^\\]*)$"))
			end
			texturePos = texturePos or "Standart"
			optColSet.dropDownTexture:SetText(L.cd2OtherSetTexture.." ["..texturePos.."]")
		end
		optColSet.colorPickerBorder.color:SetColorTexture(VColOpt.textureBorderColorR or defOpt.textureBorderColorR,VColOpt.textureBorderColorG or defOpt.textureBorderColorG,VColOpt.textureBorderColorB or defOpt.textureBorderColorB, VColOpt.textureBorderColorA or defOpt.textureBorderColorA)
		optColSet.sliderBorderSize:SetValue(VColOpt.textureBorderSize or defOpt.textureBorderSize)
		optColSet.chkAnimation:SetChecked(VColOpt.textureAnimation)
		optColSet.chkHideSpark:SetChecked(VColOpt.textureHideSpark)
		optColSet.chkSmoothAnimation:SetChecked(VColOpt.textureSmoothAnimation)
		optColSet.sliderSmoothAnimationDuration:SetValue(VColOpt.textureSmoothAnimationDuration or defOpt.textureSmoothAnimationDuration)
		optColSet.chkGeneralColorize:SetChecked(VColOpt.textureGeneral)

		optColSet.chkGeneralColorize:doAlphas()

		do
			local FontNameForDropDown = select(3,string.find(VColOpt.fontName or defOpt.fontName,"\\([^\\]*)$"))
			optColSet.dropDownFont:SetText( (FontNameForDropDown or VColOpt.fontName or defOpt.fontName or "?") )
		end
		optColSet.sliderFont:SetValue(VColOpt.fontSize or defOpt.fontSize)
		optColSet.chkFontOutline:SetChecked(VColOpt.fontOutline)
		optColSet.chkFontShadow:SetChecked(VColOpt.fontShadow)
		do
			optColSet.chkFontOtherAvailable:SetChecked(VColOpt.fontOtherAvailable)
			module.options.fontOtherAvailable(VColOpt.fontOtherAvailable)
			if VColOpt.fontOtherAvailable then
				optColSet.nowFont = "fontLeft"
			else
				optColSet.nowFont = "font"
			end
			optColSet.fontsTab.selectFunc(optColSet.fontsTab.tabs[1].button)
		end
		optColSet.chkGeneralFont:SetChecked(VColOpt.fontGeneral)

		optColSet.chkGeneralFont:doAlphas()

		optColSet.textLeftTemEdit:SetText(VColOpt.textTemplateLeft or defOpt.textTemplateLeft)
		optColSet.textRightTemEdit:SetText(VColOpt.textTemplateRight or defOpt.textTemplateRight)
		optColSet.textCenterTemEdit:SetText(VColOpt.textTemplateCenter or defOpt.textTemplateCenter)
		optColSet.chkIconName:SetChecked(VColOpt.textIconName)
		optColSet.sliderIconNameChars:SetValue(VColOpt.textIconNameChars or defOpt.textIconNameChars)
		do
			local deftextIconCDStyle = VColOpt.textIconCDStyle or defOpt.textIconCDStyle
			optColSet.dropDownIconCDStyle:SetText(optColSet.dropDownIconCDStyle.Styles[deftextIconCDStyle])
		end

		optColSet.chkGeneralText:SetChecked(VColOpt.textGeneral)

		optColSet.chkGeneralText:doAlphas()

		optColSet.chkShowOnlyOnCD:SetChecked(VColOpt.methodsShownOnCD)
		optColSet.chkBotToTop:SetChecked(VColOpt.frameAnchorBottom)
		optColSet.chkRightToLeft:SetChecked(VColOpt.frameAnchorRightToLeft)
		optColSet.chkGeneralMethods:SetChecked(VColOpt.methodsGeneral)
		do
			local defStyleAnimation = VColOpt.methodsStyleAnimation or defOpt.methodsStyleAnimation
			optColSet.dropDownStyleAnimation:SetText( optColSet.dropDownStyleAnimation.Styles[defStyleAnimation])
			local defTimeLineAnimation = VColOpt.methodsTimeLineAnimation or defOpt.methodsTimeLineAnimation
			optColSet.dropDownTimeLineAnimation:SetText(optColSet.dropDownTimeLineAnimation.Styles[defTimeLineAnimation])

			local defSortingRules = VColOpt.methodsSortingRules or defOpt.methodsSortingRules
			optColSet.dropDownSortingRules:SetText(optColSet.dropDownSortingRules.Rules[defSortingRules])
		end
		optColSet.chkIconTooltip:SetChecked(VColOpt.methodsIconTooltip)
		optColSet.chkLineClick:SetChecked(VColOpt.methodsLineClick)
		optColSet.chkLineClickWhisper:SetChecked(VColOpt.methodsLineClickWhisper)
		optColSet.chkNewSpellNewLine:SetChecked(VColOpt.methodsNewSpellNewLine)
		optColSet.chkHideOwnSpells:SetChecked(VColOpt.methodsHideOwnSpells)
		optColSet.chkAlphaNotInRange:SetChecked(VColOpt.methodsAlphaNotInRange)
		optColSet.sliderAlphaNotInRange:SetValue(VColOpt.methodsAlphaNotInRangeNum or defOpt.methodsAlphaNotInRangeNum)
		optColSet.chkDisableActive:SetChecked(VColOpt.methodsDisableActive)
		optColSet.chkOneSpellPerCol:SetChecked(VColOpt.methodsOneSpellPerCol)
		optColSet.chkOnlyInCombat:SetChecked(VColOpt.methodsOnlyInCombat)
		optColSet.chkSortByAvailability:SetChecked(VColOpt.methodsSortByAvailability)
		optColSet.chkSortByAvailability_activeToTop:SetChecked(VColOpt.methodsSortActiveToTop)
		optColSet.chkReverseSorting:SetChecked(VColOpt.methodsReverseSorting)
		optColSet.chkCDOnlyTimer:SetChecked(VColOpt.methodsCDOnlyTime)
		optColSet.chkTextIgnoreActive:SetChecked(VColOpt.methodsTextIgnoreActive)
		optColSet.chkShowOnlyNotOnCD:SetChecked(VColOpt.methodsOnlyNotOnCD)

		optColSet.chkGeneralMethods:doAlphas()

		optColSet.blacklistEditBox.EditBox:SetText(VColOpt.blacklistText or defOpt.blacklistText)
		optColSet.whitelistEditBox.EditBox:SetText(VColOpt.whitelistText or defOpt.whitelistText)
		optColSet.chkGeneralBlackList:SetChecked(VColOpt.blacklistGeneral)

		optColSet.chkGeneralBlackList:doAlphas()

		optColSet.chkVisibilityPartyTypeAlways:SetChecked(not VColOpt.visibilityPartyType)
		optColSet.chkVisibilityPartyTypeParty:SetChecked(VColOpt.visibilityPartyType == 1)
		optColSet.chkVisibilityPartyTypeRaid:SetChecked(VColOpt.visibilityPartyType == 2)
		optColSet.chkVisibilityZoneArena:SetChecked(not VColOpt.visibilityDisableArena)
		optColSet.chkVisibilityZoneBG:SetChecked(not VColOpt.visibilityDisableBG)
		optColSet.chkVisibilityZoneScenario:SetChecked(not VColOpt.visibilityDisable3ppl)
		optColSet.chkVisibilityZone5ppl:SetChecked(not VColOpt.visibilityDisable5ppl)
		optColSet.chkVisibilityZoneRaid:SetChecked(not VColOpt.visibilityDisableRaid)
		optColSet.chkVisibilityZoneOutdoor:SetChecked(not VColOpt.visibilityDisableWorld)
		optColSet.chkGeneralVisibility:SetChecked(VColOpt.visibilityGeneral)

		optColSet.chkGeneralVisibility:doAlphas()

		if not isGeneralTab then
			optColSet.chkATF:SetChecked(VColOpt.ATF)
			optColSet.sliderATFHeight:SetValue(VColOpt.iconSize or defOpt.iconSize)
			optColSet.sliderATFFont:SetValue(VColOpt.fontCDSize or defOpt.fontCDSize)
			optColSet.sliderATFMaxCol:SetValue(VColOpt.ATFCol or defOpt.ATFCol)
			optColSet.sliderATFMaxLine:SetValue(VColOpt.ATFLines or defOpt.ATFLines)
			optColSet.sliderATFOffsetX:SetValue(VColOpt.ATFOffsetX or defOpt.ATFOffsetX)
			optColSet.sliderATFOffsetY:SetValue(VColOpt.ATFOffsetY or defOpt.ATFOffsetY)
			optColSet.ATFRadiosCheck()
			optColSet.ATFTypeGrowth1:SetChecked(VColOpt.ATFGrowth == 1 or not VColOpt.ATFGrowth)
			optColSet.ATFTypeGrowth2:SetChecked(VColOpt.ATFGrowth == 2)
			optColSet.dropDownATFFramePrior:Update(VColOpt.ATFFramePrior)
		end


		optColSet.chkEnable:SetShown(not isGeneralTab)
		optColSet.chkGeneral:SetShown(not isGeneralTab)

		optColSet.chkGeneralIcons:SetShown(not isGeneralTab)
		optColSet.chkGeneralColorize:SetShown(not isGeneralTab)
		optColSet.chkGeneralFont:SetShown(not isGeneralTab)
		optColSet.chkGeneralText:SetShown(not isGeneralTab)
		optColSet.chkGeneralMethods:SetShown(not isGeneralTab)
		optColSet.chkGeneralVisibility:SetShown(not isGeneralTab)
		optColSet.chkGeneralBlackList:SetShown(not isGeneralTab)

		module.options.showColorFrame(module.options.colorSetupFrame)

		if self then
			optColSet.templateRestore:Hide()
		end

		if isGeneralTab and optColSet.superTabFrame.list.selected == 10 then
			optColSet.superTabFrame.list:SetTo(1)
		end

		optColSet.LOCK = nil
		currColOpt = VMRT.ExCD2.colSet[module.options.optColTabs.selected]

		if VColOpt.enabled and not isGeneralTab and VMRT.ExCD2.enabled and not VColOpt.ATF then
			optColSet.NavLineF.f = module.frame.colFrame[i]
			optColSet.FindFrameBut:Show()
		else
			optColSet.NavLineF.f = nil
			optColSet.FindFrameBut:Hide()
		end
	end

	self.optColSet = {}
	do
		local tmpArr = {}
		for i=1,module.db.maxColumns do
			tmpArr[i] = tostring(i)
		end
		tmpArr[module.db.maxColumns+1] = L.cd2GeneralSet
		tmpArr[#tmpArr+1] = ADVANCED_LABEL
		tmpArr[#tmpArr+1] = L.Profiles
		self.optColTabs = ELib:Tabs(self.tab.tabs[2],0,unpack(tmpArr)):Size(660,417):Point("TOP",0,-48):SetTo(module.db.maxColumns+1)

		local profilesBut = self.optColTabs.tabs[module.db.maxColumns+3].button
		profilesBut.colID = module.db.maxColumns+3
		profilesBut:SetScript("OnClick", function(self)
			module.options.optColTabs.selected = self.colID
			module.options.optColTabs:UpdateTabs()
			module.options.optColSet.superTabFrame:Hide()
		end)
		profilesBut:ClearAllPoints()
		profilesBut:SetPoint("TOPRIGHT", -10, 24)

		local advColBut = self.optColTabs.tabs[module.db.maxColumns+2].button
		advColBut.colID = module.db.maxColumns+2
		advColBut:SetScript("OnClick", function(self)
			module.options.optColTabs.selected = self.colID
			module.options.optColTabs:UpdateTabs()
			module.options.optColSet.superTabFrame:Hide()
		end)
		advColBut:ClearAllPoints()
		advColBut:SetPoint("RIGHT", profilesBut, "LEFT", 0, 0)
	end
	for i=1,module.db.maxColumns+1 do
		self.optColTabs.tabs[i].button.colID = i
		self.optColTabs.tabs[i].button:SetScript("OnClick", self.selectColumnTab)
	end

	self.optColTabs:SetBackdropBorderColor(0,0,0,0)
	self.optColTabs:SetBackdropColor(0,0,0,0)

	self.tab.tabs[2].decorationLine = ELib:DecorationLine(self.tab.tabs[2],true,"BACKGROUND",-5):Point("TOPLEFT",self.tab.tabs[2],0,-28):Point("RIGHT",self,0,0):Size(0,20)

	self.optColSet.superTabFrame = ExRT.lib:ScrollTabsFrame(self.optColTabs,L.cd2OtherSetTabNameGeneral,L.cd2OtherSetTabNameIcons,L.cd2OtherSetTabNameColors,L.cd2OtherSetTabNameFont,L.cd2OtherSetTabNameText,L.cd2OtherSetTabNameOther,L.cd2OtherSetTabNameVisibility,L.cd2OtherSetTabNameBlackList,L.cd2OtherSetTabNameTemplate,L.cd2ATF):Size(660,450):Point("TOP",0,-10)
	self.optColSet.superTabFrame.list.LDisabled = {}
	self.optColSet.superTabFrame.list:SetScript("OnUpdate",function(self)
		for i=1,#self.List do
			local line = self.List[i]
			if line:IsMouseOver() and line.index and self.LDisabled[line.index] then
				if not self.DisabledTooltipShowed then
					self.DisabledTooltipShowed = true
					GameTooltip:SetOwner(line, "ANCHOR_TOP")
					GameTooltip:AddLine(L.cd2ATFTooltipDisabled, 1, .3, .3)
					GameTooltip:Show()
				end
				return
			end
		end
		if self.DisabledTooltipShowed then
			GameTooltip_Hide()
			self.DisabledTooltipShowed = nil
		end
	end)

	self.optColSet.NavLineF = ELib:Frame(self.optColTabs):Point("TOPLEFT",self.optColTabs,0,0):Size(1,1)
	self.optColSet.NavLineF:Hide()

	self.optColSet.NavLineF.line = self.optColSet.NavLineF:CreateLine(nil, "ARTWORK")
	self.optColSet.NavLineF.line:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/lineGapped")
	self.optColSet.NavLineF.line:SetVertexColor(.44,1,.50,1)
	self.optColSet.NavLineF.line:SetThickness(10)

	self.optColSet.NavLineF:SetScript("OnUpdate",function(self)
		if not self.f then
			return
		end
		local l1,t1 = self.f2:GetLeft(), self.f2:GetTop()
		local s1 = self.f2:GetEffectiveScale()
		local l2,t2 = self.f:GetLeft(), self.f:GetTop()
		local s2 = self.f:GetEffectiveScale()
		l1, t1 = l1*s1, t1*s1
		l2, t2 = l2*s2, t2*s2

		local s3 = UIParent:GetEffectiveScale()
		l1, t1, l2, t2 = l1/s3, t1/s3, l2/s3, t2/s3

		self.line:SetStartPoint("BOTTOMLEFT", UIParent, l1, t1)
		self.line:SetEndPoint("BOTTOMLEFT", UIParent, l2, t2)

		local t = GetTime() % 1
		local d = 40/1024
		self.line:SetTexCoord(d * t,(1 - d)+ t*d,0,1)
	end)

	self.optColSet.FindFrameBut = ELib:Button(self.optColTabs,L.cd2FindFrame):Point("TOPRIGHT",self.optColSet.superTabFrame,"TOPLEFT",-5,-1):Size(83,50):OnEnter(function()
		local f = self.optColSet.NavLineF
		if f.f and f.f.ATFenabled then return end
		f:Show()
	end):OnLeave(function ()
		self.optColSet.NavLineF:Hide()
	end)

	self.optColSet.NavLineF.f2 = self.optColSet.FindFrameBut

	self.optColSet.chkEnable = ELib:Check(self.optColSet.superTabFrame.tab[1],">>>"..L.Enable.."<<<"):Point(10,-10):AddColorState():OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.enabled = true
		else
			currColOpt.enabled = nil
		end
		module:ReloadAllSplits()
	end):OnShow(function(self)
		C_Timer.After(.1,function()
			self:ColorState()
		end)
	end,true)

	self.optColSet.chkGeneral = ELib:Check(self.optColSet.superTabFrame.tab[1],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.frameGeneral = true
		else
			currColOpt.frameGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneral:doAlphas()
		ExRT.lib.SetAlphas(VMRT.ExCD2.colSet[module.options.optColTabs.selected].frameGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.sliderLinesNum,module.options.optColSet.sliderAlpha,module.options.optColSet.sliderScale,module.options.optColSet.sliderWidth,module.options.optColSet.sliderColsInCol,module.options.optColSet.sliderBetweenLines,module.options.optColSet.sliderBlackBack,module.options.optColSet.butToCenter,module.options.optColSet.dropDownStrata,module.options.optColSet.textdropDownStrata)
	end

	self.optColSet.sliderLinesNum = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2lines):Size(400):Point("TOP",0,-50):Range(1,module.db.maxLinesInCol):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.frameLines = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)

	self.optColSet.sliderWidth = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2width):Size(400):Point("TOP",0,-85):Range(1,400):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.frameWidth = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)

	self.optColSet.sliderAlpha = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2alpha):Size(400):Point("TOP",0,-120):Range(0,100):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.frameAlpha = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)

	self.optColSet.sliderScale = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2scale):Size(400):Point("TOP",0,-155):Range(5,200):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.frameScale = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits("ScaleFix")
	end)

	self.optColSet.sliderColsInCol = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2ColSetColsInCol):Size(400):Point("TOP",0,-190):Range(1,module.db.maxLinesInCol):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.frameColumns = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)

	self.optColSet.sliderBetweenLines = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2ColSetBetweenLines):Size(400):Point("TOP",0,-225):Range(0,20):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.frameBetweenLines = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)

	self.optColSet.sliderBlackBack = ELib:Slider(self.optColSet.superTabFrame.tab[1],L.cd2BlackBack):Size(400):Point("TOP",0,-260):Range(0,100):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.frameBlackBack = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)

	self.optColSet.dropDownStrata = ELib:DropDown(self.optColSet.superTabFrame.tab[1],230,-1):Point("TOPLEFT",198,-295):Size(230)
	self.optColSet.textdropDownStrata = ELib:Text(self.optColSet.superTabFrame.tab[1],L.cd2ColStrata..":",11):Size(200,20):Point("TOPLEFT",27,-295)
	for i,strataString in ipairs({"BACKGROUND","LOW","MEDIUM","HIGH","DIALOG","FULLSCREEN","FULLSCREEN_DIALOG","TOOLTIP","Auto"}) do
		self.optColSet.dropDownStrata.List[i] = {
			text = strataString,
			arg1 = strataString,
			func = function (self,arg)
				ELib:DropDownClose()
				currColOpt.frameStrata = arg
				if arg == "Auto" then
					currColOpt.frameStrata = nil
				end
				module:ReloadAllSplits()
				self:GetParent().parent:SetText(arg)
			end,
			tooltip = strataString == "Auto" and L.cd2ColStrataAutoTooltip,
		}
	end
	function self.optColSet.dropDownStrata:PreUpdate()
		for i=1,#self.List do
			local v = self.List[i]
			if v.arg1 == "Auto" then
				if currColOpt.ATF then
					v.isHidden = nil
				else
					v.isHidden = true
				end
				break
			end
		end
	end

	self.optColSet.butToCenter = ELib:Button(self.optColSet.superTabFrame.tab[1],L.cd2ColSetResetPos):Size(200,20):Point("TOP",0,-330):OnClick(function(self) 
		if (module.db.maxColumns + 1) == module.options.optColTabs.selected then
			module.frame:ClearAllPoints()
			module.frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
		else
			module.frame.colFrame[module.options.optColTabs.selected]:ClearAllPoints()
			module.frame.colFrame[module.options.optColTabs.selected]:SetPoint("CENTER",UIParent,"CENTER",0,0)
		end
	end) 

	--> Icon and height options

	self.optColSet.sliderHeight = ELib:Slider(self.optColSet.superTabFrame.tab[2],L.cd2OtherSetIconSize):Size(400):Point("TOP",0,-50):Range(6,128):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.iconSize = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.chkGray = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2graytooltip):Point(10,-110):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.iconGray = true
		else
			currColOpt.iconGray = nil
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
				currColOpt.iconPosition = arg
				module:ReloadAllSplits()
				module.options.optColSet.dropDownIconPos:SetText(module.options.optColSet.dropDownIconPos.PosNames[arg])
			end,
		}
	end

	self.optColSet.chkCooldown = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ColSetMethodCooldown):Point(10,-135):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsCooldown = true
		else
			currColOpt.methodsCooldown = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkCooldownTextDef = ELib:Radio(self.optColSet.superTabFrame.tab[2],L.cd2ColSetCDTimeDef):Point("TOPLEFT",self.optColSet.chkCooldown,25,-25):Tooltip(L.cd2ColSetCDTimeDefTooltip):OnClick(function(self) 
		currColOpt.iconCooldownHideNumbers = nil
		currColOpt.iconCooldownExRTNumbers = nil
		module.options.optColSet:chkCooldownTextUpdate()
		module:ReloadAllSplits()
	end)

	self.optColSet.chkCooldownExRTNumbers = ELib:Radio(self.optColSet.superTabFrame.tab[2],L.cd2ColSetCDTimeExRT):Point("TOPLEFT",self.optColSet.chkCooldownTextDef,0,-25):Tooltip(L.cd2ColSetCDTimeExRTTooltip):OnClick(function(self) 
		currColOpt.iconCooldownHideNumbers = nil
		currColOpt.iconCooldownExRTNumbers = true
		module.options.optColSet:chkCooldownTextUpdate()
		module:ReloadAllSplits()
	end)

	self.optColSet.chkCooldownHideNumbers = ELib:Radio(self.optColSet.superTabFrame.tab[2],L.BattleResHideTime):Point("TOPLEFT",self.optColSet.chkCooldownExRTNumbers,0,-25):Tooltip(L.BattleResHideTimeTooltip):OnClick(function(self) 
		currColOpt.iconCooldownHideNumbers = true
		currColOpt.iconCooldownExRTNumbers = nil
		module.options.optColSet:chkCooldownTextUpdate()
		module:ReloadAllSplits()
	end)

	self.optColSet.chkCooldownTextUpdate = function(self)
		local v1,v2,v3
		local currColOpt = VMRT.ExCD2.colSet[module.options.optColTabs.selected]
		if currColOpt.iconCooldownExRTNumbers then
			v3 = true
		elseif currColOpt.iconCooldownHideNumbers then
			v2 = true
		else
			v1 = true
		end
		module.options.optColSet.chkCooldownTextDef:SetChecked(v1)
		module.options.optColSet.chkCooldownHideNumbers:SetChecked(v2)
		module.options.optColSet.chkCooldownExRTNumbers:SetChecked(v3)
	end

	self.optColSet.chkCooldownShowSwipe = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ShowEgde):Point("TOPLEFT",self.optColSet.chkCooldownHideNumbers,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.iconCooldownShowSwipe = true
		else
			currColOpt.iconCooldownShowSwipe = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.textGlowType = ELib:Text(self.optColSet.superTabFrame.tab[2],L.cd2GlowType):Point("TOPLEFT",self.optColSet.chkCooldownShowSwipe,0,-25):Size(0,25):Middle():Left()
	self.optColSet.dropDownCooldownGlowType = ELib:DropDown(self.optColSet.superTabFrame.tab[2],160,4):Size(170):Point("LEFT",self.optColSet.textGlowType,"RIGHT",5,0):Tooltip(L.cd2GlowTypeTooltip)
	for i=1,4 do
		self.optColSet.dropDownCooldownGlowType.List[i] = {
			text = i == 4 and L.NoText or i,
			arg1 = i,
			func = function (self,arg1)
				ELib:DropDownClose()
				currColOpt.iconGlowType = arg1
				module:ReloadAllSplits()
				module.options.optColSet.dropDownCooldownGlowType:SetText(module.options.optColSet.dropDownCooldownGlowType.List[arg1].text)
			end,
		}
	end

	self.optColSet.chkShowTitles = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ColSetShowTitles):Point("TOPLEFT",self.optColSet.chkCooldown,0,-150):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.iconTitles = true
		else
			currColOpt.iconTitles = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkHideBlizzardEdges = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ColSetIconHideBlizzardEdges):Point("TOPLEFT",self.optColSet.chkShowTitles,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.iconHideBlizzardEdges = true
		else
			currColOpt.iconHideBlizzardEdges = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkMasque = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ColSetIconMasque):Point("TOPLEFT",self.optColSet.chkHideBlizzardEdges,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.iconMasque = true
		else
			currColOpt.iconMasque = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkGeneralIcons = ELib:Check(self.optColSet.superTabFrame.tab[2],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.iconGeneral = true
		else
			currColOpt.iconGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralIcons:doAlphas()
		ExRT.lib.SetAlphas(VMRT.ExCD2.colSet[module.options.optColTabs.selected].iconGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.chkGray,module.options.optColSet.sliderHeight,module.options.optColSet.dropDownIconPos,module.options.optColSet.chkCooldown,module.options.optColSet.chkShowTitles,module.options.optColSet.chkHideBlizzardEdges,module.options.optColSet.chkCooldownShowSwipe,module.options.optColSet.chkCooldownHideNumbers,module.options.optColSet.textIconPos, module.options.optColSet.textGlowType, module.options.optColSet.dropDownCooldownGlowType,module.options.optColSet.chkCooldownTextDef,module.options.optColSet.chkCooldownExRTNumbers,module.options.optColSet.chkMasque)
	end

	--> Texture and colors Options

	local function dropDownTextureButtonClick(self,arg,name)
		ELib:DropDownClose()
		currColOpt.textureFile = arg
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
	for key,texture in ExRT.F.IterateMediaData("statusbar") do
		local info = {}
		self.optColSet.dropDownTexture.List[#self.optColSet.dropDownTexture.List+1] = info

		info.text = key
		info.arg1 = texture
		info.arg2 = key
		info.func = dropDownTextureButtonClick
		info.texture = texture
		info.justifyH = "CENTER" 
	end

	self.optColSet.textDDBorder = ELib:Text(self.optColSet.superTabFrame.tab[3],L.cd2OtherSetBorder..":"):Size(200,20):Point(10,-65)
	self.optColSet.sliderBorderSize = ELib:Slider(self.optColSet.superTabFrame.tab[3],""):Size(170):Point(180,-68):Range(0,20):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.textureBorderSize = event
		self.tooltipText = event
		self:tooltipReload(self)
		module:ReloadAllSplits()
	end)
	self.optColSet.colorPickerBorder = ExRT.lib.CreateColorPickButton(self.optColSet.superTabFrame.tab[3],20,20,nil,361,-65)
	self.optColSet.colorPickerBorder:SetScript("OnClick",function (self)
		ColorPickerFrame.previousValues = {currColOpt.textureBorderColorR or module.db.colsDefaults.textureBorderColorR,currColOpt.textureBorderColorG or module.db.colsDefaults.textureBorderColorG,currColOpt.textureBorderColorB or module.db.colsDefaults.textureBorderColorB, currColOpt.textureBorderColorA or module.db.colsDefaults.textureBorderColorA}
		ColorPickerFrame.hasOpacity = true
		local nilFunc = ExRT.NULLfunc
		local function changedCallback(restore)
			local newR, newG, newB, newA
			if restore then
				newR, newG, newB, newA = unpack(restore)
			else
				newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
			end
			currColOpt.textureBorderColorR = newR
			currColOpt.textureBorderColorG = newG
			currColOpt.textureBorderColorB = newB
			currColOpt.textureBorderColorA = newA
			module:ReloadAllSplits()

			self.color:SetColorTexture(newR,newG,newB,newA)
		end
		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = nilFunc, nilFunc, nilFunc
		ColorPickerFrame.opacity = currColOpt.textureBorderColorA or module.db.colsDefaults.textureBorderColorA
		ColorPickerFrame:SetColorRGB(currColOpt.textureBorderColorR or module.db.colsDefaults.textureBorderColorR,currColOpt.textureBorderColorG or module.db.colsDefaults.textureBorderColorG,currColOpt.textureBorderColorB or module.db.colsDefaults.textureBorderColorB)
		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback
		ColorPickerFrame:Show()
	end)

	self.optColSet.chkAnimation = ELib:Check(self.optColSet.superTabFrame.tab[3],L.cd2OtherSetAnimation):Point(10,-97):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.textureAnimation = true
		else
			currColOpt.textureAnimation = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkHideSpark = ELib:Check(self.optColSet.superTabFrame.tab[3],L.cd2OtherSetHideSpark):Point(200,-97):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.textureHideSpark = true
		else
			currColOpt.textureHideSpark = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkSmoothAnimation = ELib:Check(self.optColSet.superTabFrame.tab[3],L.cd2TextureSmoothAnim):Point(10,-122):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.textureSmoothAnimation = true
		else
			currColOpt.textureSmoothAnimation = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.sliderSmoothAnimationDuration = ELib:Slider(self.optColSet.superTabFrame.tab[3],""):Size(140):Point("TOP",self.optColSet.chkSmoothAnimation,0,-2):Point("LEFT",self.optColSet.chkSmoothAnimation.text,"RIGHT",20,0):Range(10,200):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.textureSmoothAnimationDuration = event
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
		ColorPickerFrame.previousValues = {currColOpt[self.inOptName.."R"] or module.db.colsDefaults[self.inOptName.."R"],currColOpt[self.inOptName.."G"] or module.db.colsDefaults[self.inOptName.."G"],currColOpt[self.inOptName.."B"] or module.db.colsDefaults[self.inOptName.."B"], 1}
		local nilFunc = ExRT.NULLfunc
		local function changedCallback(restore)
			local newR, newG, newB, newA
			if restore then
				newR, newG, newB, newA = unpack(restore)
			else
				newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
			end
			currColOpt[self.inOptName.."R"] = newR
			currColOpt[self.inOptName.."G"] = newG
			currColOpt[self.inOptName.."B"] = newB
			module:ReloadAllSplits()

			self.color:SetColorTexture(newR,newG,newB,1)
		end
		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = nilFunc, nilFunc, nilFunc
		ColorPickerFrame:SetColorRGB(currColOpt[self.inOptName.."R"] or module.db.colsDefaults[self.inOptName.."R"],currColOpt[self.inOptName.."G"] or module.db.colsDefaults[self.inOptName.."G"],currColOpt[self.inOptName.."B"] or module.db.colsDefaults[self.inOptName.."B"])
		ColorPickerFrame.func, ColorPickerFrame.cancelFunc = changedCallback, changedCallback
		ColorPickerFrame:Show()
	end

	local function colorPickerSliderValue(self,newval)
		currColOpt[self.inOptName] = newval / 100
		module:ReloadAllSplits()
		self.tooltipText = ExRT.F.Round(newval)
		self:tooltipReload(self)
	end

	local function colorPickerCheckBoxClick(self)
		if self:GetChecked() then
			currColOpt[self.inOptName] = true
		else
			currColOpt[self.inOptName] = nil
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
			local colorf = ExRT.lib.CreateColorPickButton(self.colorSetupFrame,20,20,nil,240+(i-1)*40,-35-(j-1)*20)
			self.colorSetupFrame[ "color"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j] ] = colorf
			colorf.inOptName = "textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]
			colorf:SetScript("OnClick",colorPickerButtonClick)
		end
		self.colorSetupFrame[ "text"..colorSetupFrameColorsNames[j] ] = ELib:Text(self.colorSetupFrame,colorSetupFrameColorsNames_Text[j],12):Size(210,20):Point(10,-35-(j-1)*20):Right():Color():Shadow()
	end

	local checksInOptNames = {"textureClassText","textureClassBackground","textureClassTimeLine"}
	for i=1,3 do
		self.colorSetupFrame[ "colorClass"..colorSetupFrameColorsObjectsNames[i] ] = ELib:Check(self.colorSetupFrame,""):Point(241+(i-1)*40,-117):Size(18,18):OnClick(colorPickerCheckBoxClick)
		self.colorSetupFrame[ "colorClass"..colorSetupFrameColorsObjectsNames[i] ].inOptName = checksInOptNames[i]
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
					local color = currColOpt[ "textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n] ] or module.db.colsDefaults[ "textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n] ]
					maxColor = max(maxColor,color)
				end
				for n=1,3 do
					local color = currColOpt[ "textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n] ] or module.db.colsDefaults[ "textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n] ]
					if color < maxColor then
						currColOpt[ "textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n] ] = color + (maxColor - color) / 2
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
					currColOpt[ "textureColor"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j]..tmpColors[n] ] = nil
				end
			end
		end
		currColOpt.textureAlphaBackground = nil
		currColOpt.textureAlphaTimeLine = nil
		currColOpt.textureAlphaCooldown = nil
		for i=1,3 do
			currColOpt[ checksInOptNames[i] ] = nil
		end
		module.options.showColorFrame(module.options.colorSetupFrame)
		module:ReloadAllSplits()
	end)

	function self:showColorFrame()
		local currColOpt = VMRT.ExCD2.colSet[module.options.optColTabs.selected]
		for j=1,3 do
			for i=1,3 do
				local this = module.options.colorSetupFrame[ "color"..colorSetupFrameColorsObjectsNames[i]..colorSetupFrameColorsNames[j] ]
				this.color:SetColorTexture(currColOpt[this.inOptName.."R"] or module.db.colsDefaults[this.inOptName.."R"],currColOpt[this.inOptName.."G"] or module.db.colsDefaults[this.inOptName.."G"],currColOpt[this.inOptName.."B"] or module.db.colsDefaults[this.inOptName.."B"],1)
			end
		end
		for i=1,3 do
			module.options.colorSetupFrame["colorClass"..colorSetupFrameColorsObjectsNames[i]]:SetChecked( currColOpt[ checksInOptNames[i] ] )
		end

		self.backAlpha:SetValue((currColOpt[self.backAlpha.inOptName] or module.db.colsDefaults[self.backAlpha.inOptName])*100)
		self.backCDAlpha:SetValue((currColOpt[self.backCDAlpha.inOptName] or module.db.colsDefaults[self.backCDAlpha.inOptName])*100)
		self.backCooldownAlpha:SetValue((currColOpt[self.backCooldownAlpha.inOptName] or module.db.colsDefaults[self.backCooldownAlpha.inOptName])*100)
	end

	self.colorSetupFrame:SetScript("OnShow",self.showColorFrame)


	self.optColSet.chkGeneralColorize = ELib:Check(self.optColSet.superTabFrame.tab[3],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.textureGeneral = true
		else
			currColOpt.textureGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralColorize:doAlphas()
		ExRT.lib.SetAlphas(VMRT.ExCD2.colSet[module.options.optColTabs.selected].textureGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.dropDownTexture,module.options.optColSet.chkAnimation,module.options.colorSetupFrame,module.options.optColSet.colorPickerBorder,module.options.optColSet.sliderBorderSize,module.options.optColSet.chkHideSpark,module.options.optColSet.textDDTexture, module.options.optColSet.textDDBorder, module.options.optColSet.chkSmoothAnimation, module.options.optColSet.sliderSmoothAnimationDuration)
	end

	--> Font Options
	self.optColSet.nowFont = "font"

	self.optColSet.superTabFrame.tab[4].decorationLine = ELib:DecorationLine(self.optColSet.superTabFrame.tab[4],true,"BACKGROUND"):Point("TOPLEFT",self.optColSet.superTabFrame.tab[4],0,-35):Point("BOTTOMRIGHT",self.optColSet.superTabFrame.tab[4],"TOPRIGHT",0,-55)

	self.optColSet.fontsTab = ELib:Tabs(self.optColSet.superTabFrame.tab[4],0,L.cd2ColSetFontPosGeneral,L.cd2ColSetFontPosRight,L.cd2ColSetFontPosCenter,L.cd2ColSetFontPosIcon,L.cd2ColSetFontPosIconCD):Size(455,160):Point(0,-55)
	self.optColSet.fontsTab:SetBackdropBorderColor(0,0,0,0)
	self.optColSet.fontsTab:SetBackdropColor(0,0,0,0)
	local function fontsTabButtonClick(self)
		local tabFrame = self.mainFrame
		tabFrame.selected = self.id
		tabFrame.UpdateTabs(tabFrame)

		module.options.optColSet.nowFont = self.fontMark

		local i = module.options.optColTabs.selected
		do
			local FontNameForDropDown = select(3,string.find(VMRT.ExCD2.colSet[i][self.fontMark.."Name"] or module.db.colsDefaults.fontName,"\\([^\\]*)$"))
			module.options.optColSet.dropDownFont:SetText(  (FontNameForDropDown or VMRT.ExCD2.colSet[i][self.fontMark.."Name"] or module.db.colsDefaults.fontName or "?") )
		end
		module.options.optColSet.sliderFont:SetValue(VMRT.ExCD2.colSet[i][self.fontMark.."Size"] or module.db.colsDefaults.fontSize)
		module.options.optColSet.chkFontOutline:SetChecked(VMRT.ExCD2.colSet[i][self.fontMark.."Outline"])
		module.options.optColSet.chkFontShadow:SetChecked(VMRT.ExCD2.colSet[i][self.fontMark.."Shadow"])
	end
	for i=1,5 do
		self.optColSet.fontsTab.tabs[i].button:SetScript("OnClick",fontsTabButtonClick)
	end
	local fontOtherAvailableTable = {"Left","Right","Center","Icon","IconCD"}
	function self.fontOtherAvailable(isAvailable)
		if isAvailable then
			for i=2,5 do
				self.optColSet.fontsTab.tabs[i].button:Show()
			end
			self.optColSet.fontsTab.tabs[1].button:SetText(L.cd2ColSetFontPosLeft)
			for i=1,5 do
				self.optColSet.fontsTab.tabs[i].button.fontMark = "font"..fontOtherAvailableTable[i]
			end
		else
			for i=2,5 do
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
			currColOpt.fontOtherAvailable = true --fontOtherAvailable
		else
			currColOpt.fontOtherAvailable = nil
		end
		module:ReloadAllSplits()
		module.options.fontOtherAvailable( self:GetChecked() )
	end)

	self.optColSet.sliderFont = ELib:Slider(self.optColSet.fontsTab,L.cd2OtherSetFontSize):Size(400):Point("TOP",0,-60):Range(8,72):OnChange(function(self,event) 
		event = event - event%1
		currColOpt[module.options.optColSet.nowFont.."Size"] = event --fontSize
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.textDDFont = ELib:Text(self.optColSet.fontsTab,L.cd2OtherSetFont..":"):Size(200,20):Point(10,-15)

	local function dropDownFontButtonClick(self,arg1,arg2)
		ELib:DropDownClose()
		currColOpt[module.options.optColSet.nowFont.."Name"] = arg1 --fontName
		module:ReloadAllSplits()
		local FontNameForDropDown = select(3,string.find(arg1,"\\([^\\]*)$"))
		if arg2 then
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
	for name,font in ExRT.F.IterateMediaData("font") do
		local info = {}
		self.optColSet.dropDownFont.List[#self.optColSet.dropDownFont.List+1] = info

		info.text = name
		info.arg1 = font
		info.func = dropDownFontButtonClick
		info.font = font
		info.justifyH = "CENTER" 
	end

	self.optColSet.chkFontOutline = ELib:Check(self.optColSet.fontsTab,L.cd2OtherSetOutline):Point(10,-95):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt[module.options.optColSet.nowFont.."Outline"] = true --fontOutline
		else
			currColOpt[module.options.optColSet.nowFont.."Outline"] = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkFontShadow = ELib:Check(self.optColSet.fontsTab,L.cd2OtherSetFontShadow):Point(10,-120):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt[module.options.optColSet.nowFont.."Shadow"] = true -- fontShadow
		else
			currColOpt[module.options.optColSet.nowFont.."Shadow"] = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkGeneralFont = ELib:Check(self.optColSet.superTabFrame.tab[4],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.fontGeneral = true
		else
			currColOpt.fontGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralFont:doAlphas()
		ExRT.lib.SetAlphas(VMRT.ExCD2.colSet[module.options.optColTabs.selected].fontGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.dropDownFont,module.options.optColSet.sliderFont,module.options.optColSet.chkFontOutline,module.options.optColSet.chkFontShadow,module.options.optColSet.chkFontOtherAvailable)
	end

	--> Text options

	self.optColSet.textLeftTemText = ELib:Text(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextLeft..":"):Size(200,20):Point(10,-40)
	self.optColSet.textLeftTemEdit = ELib:Edit(self.optColSet.superTabFrame.tab[5]):Size(220,20):Point(180,-40):OnChange(function(self,isUser)
		if isUser then
			currColOpt.textTemplateLeft = self:GetText()
			module:ReloadAllSplits()
		end
	end)

	self.optColSet.textRightTemText = ELib:Text(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextRight..":"):Size(200,20):Point(10,-65)
	self.optColSet.textRightTemEdit = ELib:Edit(self.optColSet.superTabFrame.tab[5]):Size(220,20):Point(180,-65):OnChange(function(self,isUser)
		if isUser then
			currColOpt.textTemplateRight = self:GetText()
			module:ReloadAllSplits()
		end
	end)

	self.optColSet.textCenterTemText = ELib:Text(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextCenter..":"):Size(200,20):Point(10,-90)
	self.optColSet.textCenterTemEdit = ELib:Edit(self.optColSet.superTabFrame.tab[5]):Size(220,20):Point(180,-90):OnChange(function(self,isUser)
		if isUser then
			currColOpt.textTemplateCenter = self:GetText()
			module:ReloadAllSplits()
		end
	end)

	self.optColSet.textAllTemplates = ELib:Text(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextTooltip,11):Size(450,200):Point(10,-115):Top():Color()

	self.optColSet.textResetButton = ELib:Button(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextReset):Size(340,20):Point("TOP",0,-225):OnClick(function(self)
		currColOpt.textTemplateLeft = nil
		currColOpt.textTemplateRight = nil
		currColOpt.textTemplateCenter = nil
		module:ReloadAllSplits()
		module.options.optColSet.textLeftTemEdit:SetText(module.db.colsDefaults.textTemplateLeft)
		module.options.optColSet.textRightTemEdit:SetText(module.db.colsDefaults.textTemplateRight)
		module.options.optColSet.textCenterTemEdit:SetText(module.db.colsDefaults.textTemplateCenter)
	end)

	self.optColSet.chkIconName = ELib:Check(self.optColSet.superTabFrame.tab[5],L.cd2ColSetTextIconName):Point(10,-250):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.textIconName = true
		else
			currColOpt.textIconName = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.sliderIconNameChars = ELib:Slider(self.optColSet.superTabFrame.tab[5],L.cd2ColSetMaxLength):Size(140):Point("TOP",self.optColSet.chkIconName,0,-8):Point("LEFT",self.optColSet.chkIconName.text,"RIGHT",20,0):Range(1,50):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.textIconNameChars = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	self.optColSet.sliderIconNameChars.Low:SetText("")
	self.optColSet.sliderIconNameChars.High:SetText("")


	self.optColSet.dropDownIconCDStyle = ELib:DropDown(self.optColSet.superTabFrame.tab[5],350):Size(230):Point("TOPLEFT",self.optColSet.chkIconName,170,-30)
	self.optColSet.textdropDownIconCDStyle = ELib:Text(self.optColSet.superTabFrame.tab[5],L.cd2ColSetCDTimeStyle..":",11):Size(200,20):Point("TOPLEFT",self.optColSet.chkIconName,0,-30)
	self.optColSet.dropDownIconCDStyle.Styles = {
		"<10: |cff00ff009|r - <60: |cff00ff0046|r - 60+: |cff00ff00"..SecondsToTime(95,true).."|r - 120+:|cff00ff00"..SecondsToTime(125,true).."|r",
		"<10: |cff00ff009|r - <60: |cff00ff0046|r - 60+: |cff00ff00"..SecondsToTime(95+60,true).."|r - 120+:|cff00ff00"..SecondsToTime(125+60,true).."|r",
		"<10: |cff00ff008.5|r - <60: |cff00ff0046|r - 60+: |cff00ff00"..SecondsToTime(95,true).."|r - 120+:|cff00ff00"..SecondsToTime(125,true).."|r",
		"<10: |cff00ff008.5|r - <60: |cff00ff0046|r - 60+: |cff00ff00"..SecondsToTime(95+60,true).."|r - 120+:|cff00ff00"..SecondsToTime(125+60,true).."|r",
		"<10: |cff00ff009|r - <60: |cff00ff0046|r - 60+: |cff00ff001:35|r - 120+:|cff00ff002:05|r",
		"<10: |cff00ff008.5|r - <60: |cff00ff0046|r - 60+: |cff00ff001:35|r - 120+:|cff00ff002:05|r",
		"<10: |cff00ff009|r - <60: |cff00ff0046|r - 60+: |cff00ff001m|r - 120+:|cff00ff002m|r",
		"<10: |cff00ff009|r - <60: |cff00ff0046|r - 60+: |cff00ff002m|r - 120+:|cff00ff003m|r",
		"<10: |cff00ff008.5|r - <60: |cff00ff0046|r - 60+: |cff00ff001m|r - 120+:|cff00ff002m|r",
		"<10: |cff00ff008.5|r - <60: |cff00ff0046|r - 60+: |cff00ff002m|r - 120+:|cff00ff003m|r",
		"<10: |cff00ff008|r - <100: |cff00ff0046|r - 100+: |cff00ff001m|r - 120+:|cff00ff002m|r",
	}
	for i=1,#self.optColSet.dropDownIconCDStyle.Styles do
		self.optColSet.dropDownIconCDStyle.List[i] = {
			text = self.optColSet.dropDownIconCDStyle.Styles[i],
			arg1 = i,
			arg2 = self.optColSet.dropDownIconCDStyle.Styles[i],
			func = function (self,arg,arg2)
				ELib:DropDownClose()
				currColOpt.textIconCDStyle = arg
				module:ReloadAllSplits()
				self:GetParent().parent:SetText(arg2)
			end
		}
	end

	self.optColSet.chkGeneralText = ELib:Check(self.optColSet.superTabFrame.tab[5],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.textGeneral = true
		else
			currColOpt.textGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralText:doAlphas()
		ExRT.lib.SetAlphas(VMRT.ExCD2.colSet[module.options.optColTabs.selected].textGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.textLeftTemEdit,module.options.optColSet.textRightTemEdit,module.options.optColSet.textCenterTemEdit,module.options.optColSet.chkIconName,module.options.optColSet.textAllTemplates,module.options.optColSet.textLeftTemText,module.options.optColSet.textRightTemText,module.options.optColSet.textCenterTemText,module.options.optColSet.textResetButton,module.options.optColSet.sliderIconNameChars,module.options.optColSet.dropDownIconCDStyle,module.options.optColSet.textdropDownIconCDStyle)
	end

	--> Method options

	self.optColSet.superTabFrame.tab[6].scroll = ELib:ScrollFrame(self.optColSet.superTabFrame.tab[6]):Point("TOP"):Size(456,444):Height(535)
	ELib:Border(self.optColSet.superTabFrame.tab[6].scroll,0)
	self.optColSet.col6scroll = self.optColSet.superTabFrame.tab[6].scroll.C
	self.optColSet.col6scroll:SetWidth(456 - 16)

	self.optColSet.chkShowOnlyOnCD = ELib:Check(self.optColSet.col6scroll,L.cd2OtherSetOnlyOnCD):Point(10,-30):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsShownOnCD = true
		else
			currColOpt.methodsShownOnCD = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkBotToTop = ELib:Check(self.optColSet.col6scroll,L.cd2ColSetBotToTop):Point(10,-55):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.frameAnchorBottom = true
		else
			currColOpt.frameAnchorBottom = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkRightToLeft = ELib:Check(self.optColSet.col6scroll,L.cd2ColSetRightToLeft):Point(10,-80):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.frameAnchorRightToLeft = true
		else
			currColOpt.frameAnchorRightToLeft = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.textStyleAnimation = ELib:Text(self.optColSet.col6scroll,L.cd2OtherSetStyleAnimation..":",11):Size(200,20):Point(10,-105)
	self.optColSet.dropDownStyleAnimation = ELib:DropDown(self.optColSet.col6scroll,205,2):Size(220):Point(180,-105)
	self.optColSet.dropDownStyleAnimation.Styles = {L.cd2OtherSetStyleAnimation1,L.cd2OtherSetStyleAnimation2}
	for i=1,#self.optColSet.dropDownStyleAnimation.Styles do
		self.optColSet.dropDownStyleAnimation.List[i] = {
			text = self.optColSet.dropDownStyleAnimation.Styles[i],
			arg1 = i,
			func = function (self,arg)
				ELib:DropDownClose()
				currColOpt.methodsStyleAnimation = arg
				module:ReloadAllSplits()
				self:GetParent().parent:SetText(module.options.optColSet.dropDownStyleAnimation.Styles[arg])
			end
		}
	end

	self.optColSet.textTimeLineAnimation = ELib:Text(self.optColSet.col6scroll,L.cd2OtherSetTimeLineAnimation..":",11):Size(200,20):Point(10,-130)
	self.optColSet.dropDownTimeLineAnimation = ELib:DropDown(self.optColSet.col6scroll,205,2):Size(220):Point(180,-130)
	self.optColSet.dropDownTimeLineAnimation.Styles = {L.cd2OtherSetTimeLineAnimation1,L.cd2OtherSetTimeLineAnimation2}
	for i=1,#self.optColSet.dropDownTimeLineAnimation.Styles do
		self.optColSet.dropDownTimeLineAnimation.List[i] = {
			text = self.optColSet.dropDownTimeLineAnimation.Styles[i],
			arg1 = i,
			func = function (self,arg)
				ELib:DropDownClose()
				currColOpt.methodsTimeLineAnimation = arg
				module:ReloadAllSplits()
				self:GetParent().parent:SetText(module.options.optColSet.dropDownTimeLineAnimation.Styles[arg])
			end
		}
	end

	self.optColSet.chkIconTooltip = ELib:Check(self.optColSet.col6scroll,L.cd2OtherSetIconToolip):Point(10,-155):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsIconTooltip = true
		else
			currColOpt.methodsIconTooltip = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkLineClick = ELib:Check(self.optColSet.col6scroll,L.cd2OtherSetLineClick):Point(10,-180):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsLineClick = true
		else
			currColOpt.methodsLineClick = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkLineClickWhisper = ELib:Check(self.optColSet.col6scroll,L.cd2OtherSetLineClickWhisper):Point(10,-205):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsLineClickWhisper = true
		else
			currColOpt.methodsLineClickWhisper = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkNewSpellNewLine = ELib:Check(self.optColSet.col6scroll,L.cd2NewSpellNewLine):Point(10,-230):Tooltip(L.cd2NewSpellNewLineTooltip):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsNewSpellNewLine = true
		else
			currColOpt.methodsNewSpellNewLine = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.textSortingRules= ELib:Text(self.optColSet.col6scroll,L.cd2MethodsSortingRules..":",11):Size(200,20):Point(10,-255)
	self.optColSet.dropDownSortingRules = ELib:DropDown(self.optColSet.col6scroll,405,6):Size(220):Point(180,-255)
	self.optColSet.dropDownSortingRules.Rules = {L.cd2MethodsSortingRules1,L.cd2MethodsSortingRules2,L.cd2MethodsSortingRules3,L.cd2MethodsSortingRules4,L.cd2MethodsSortingRules5,L.cd2MethodsSortingRules6}
	for i=1,#self.optColSet.dropDownSortingRules.Rules do
		self.optColSet.dropDownSortingRules.List[i] = {
			text = self.optColSet.dropDownSortingRules.Rules[i],
			arg1 = i,
			func = function (self,arg)
				ELib:DropDownClose()
				currColOpt.methodsSortingRules = arg
				module:ReloadAllSplits()
				module.main:GROUP_ROSTER_UPDATE()
				self:GetParent().parent:SetText(module.options.optColSet.dropDownSortingRules.Rules[arg])
			end
		}
	end

	self.optColSet.chkHideOwnSpells = ELib:Check(self.optColSet.col6scroll,L.cd2MethodsDisableOwn):Point(10,-280):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsHideOwnSpells = true
		else
			currColOpt.methodsHideOwnSpells = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkAlphaNotInRange = ELib:Check(self.optColSet.col6scroll,L.cd2MethodsAlphaNotInRange):Point(10,-305):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsAlphaNotInRange = true
		else
			currColOpt.methodsAlphaNotInRange = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.sliderAlphaNotInRange = ELib:Slider(self.optColSet.col6scroll,""):Size(140):Point("TOPLEFT",self.optColSet.chkAlphaNotInRange,270,-3):Range(0,100):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.methodsAlphaNotInRangeNum = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.chkDisableActive = ELib:Check(self.optColSet.col6scroll,L.cd2ColSetDisableActive):Point(10,-330):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsDisableActive = true
		else
			currColOpt.methodsDisableActive = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkOneSpellPerCol = ELib:Check(self.optColSet.col6scroll,L.cd2ColSetOneSpellPerCol):Point(10,-355):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsOneSpellPerCol = true
		else
			currColOpt.methodsOneSpellPerCol = nil
		end
		module:ReloadAllSplits()
	end):Tooltip(L.cd2ColSetOneSpellPerColTooltip)

	self.optColSet.chkSortByAvailability = ELib:Check(self.optColSet.col6scroll,L.cd2SortByAvailability):Point(10,-380):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsSortByAvailability = true
		else
			currColOpt.methodsSortByAvailability = nil
		end
		module:ReloadAllSplits()
		module.main:GROUP_ROSTER_UPDATE()
	end)

	self.optColSet.chkSortByAvailability_activeToTop = ELib:Check(self.optColSet.col6scroll,L.cd2SortByAvailabilityActiveToTop):Point("TOPLEFT",self.optColSet.chkSortByAvailability,0,-25):Tooltip(L.cd2SortByAvailabilityActiveToTopTooltip):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsSortActiveToTop = true
		else
			currColOpt.methodsSortActiveToTop = nil
		end
		module:ReloadAllSplits()
		module.main:GROUP_ROSTER_UPDATE()
	end)

	self.optColSet.chkReverseSorting = ELib:Check(self.optColSet.col6scroll,L.cd2ReverseSorting):Point("TOPLEFT",self.optColSet.chkSortByAvailability_activeToTop,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsReverseSorting = true
		else
			currColOpt.methodsReverseSorting = nil
		end
		module:ReloadAllSplits()
		module.main:GROUP_ROSTER_UPDATE()
	end)

	self.optColSet.chkCDOnlyTimer = ELib:Check(self.optColSet.col6scroll,L.cd2CDOnlyTimer):Point("TOPLEFT",self.optColSet.chkReverseSorting,0,-25):Tooltip(L.cd2CDOnlyTimerTooltip):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsCDOnlyTime = true
		else
			currColOpt.methodsCDOnlyTime = nil
		end
		module:ReloadAllSplits()
		module.main:GROUP_ROSTER_UPDATE()
	end)

	self.optColSet.chkTextIgnoreActive = ELib:Check(self.optColSet.col6scroll,L.cd2TextIgnoreActive):Point("TOPLEFT",self.optColSet.chkCDOnlyTimer,0,-25):Tooltip(L.cd2TextIgnoreActiveTooltip):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsTextIgnoreActive = true
		else
			currColOpt.methodsTextIgnoreActive = nil
		end
		module:ReloadAllSplits()
		module.main:GROUP_ROSTER_UPDATE()
	end)

	self.optColSet.chkShowOnlyNotOnCD = ELib:Check(self.optColSet.col6scroll,L.cd2OtherSetOnlyNotOnCD):Point("TOPLEFT",self.optColSet.chkTextIgnoreActive,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsOnlyNotOnCD = true
		else
			currColOpt.methodsOnlyNotOnCD = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkGeneralMethods = ELib:Check(self.optColSet.col6scroll,L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsGeneral = true
		else
			currColOpt.methodsGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)


	function self.optColSet.chkGeneralMethods:doAlphas()
		ExRT.lib.SetAlphas(VMRT.ExCD2.colSet[module.options.optColTabs.selected].methodsGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.chkShowOnlyOnCD,module.options.optColSet.chkBotToTop,module.options.optColSet.chkRightToLeft,module.options.optColSet.dropDownStyleAnimation,module.options.optColSet.dropDownTimeLineAnimation,module.options.optColSet.chkIconTooltip,module.options.optColSet.chkLineClick,module.options.optColSet.chkNewSpellNewLine,module.options.optColSet.dropDownSortingRules,module.options.optColSet.textSortingRules,module.options.optColSet.textStyleAnimation,module.options.optColSet.textTimeLineAnimation,module.options.optColSet.chkHideOwnSpells,module.options.optColSet.chkAlphaNotInRange,module.options.optColSet.sliderAlphaNotInRange,module.options.optColSet.chkDisableActive,module.options.optColSet.chkOneSpellPerCol,module.options.optColSet.chkLineClickWhisper,module.options.optColSet.chkSortByAvailability, module.options.optColSet.chkSortByAvailability_activeToTop, module.options.optColSet.chkReverseSorting, module.options.optColSet.chkCDOnlyTimer, module.options.optColSet.chkTextIgnoreActive, module.options.optColSet.chkShowOnlyNotOnCD)
	end



	--> Visibility


	self.optColSet.chkOnlyInCombat = ELib:Check(self.optColSet.superTabFrame.tab[7],L.TimerOnlyInCombat):Point(10,-30):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.methodsOnlyInCombat = true
		else
			currColOpt.methodsOnlyInCombat = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.visibilityTextPartyType = ELib:Text(self.optColSet.superTabFrame.tab[7],L.cd2OtherVisibilityPartyType..":",10):Point(10,-60):Color()

	self.optColSet.chkVisibilityPartyTypeAlways = ELib:Radio(self.optColSet.superTabFrame.tab[7],ALWAYS):Point(10,-75):OnClick(function(self) 
		module.options.optColSet.chkVisibilityPartyTypeAlways:SetChecked(true)
		module.options.optColSet.chkVisibilityPartyTypeParty:SetChecked(false)
		module.options.optColSet.chkVisibilityPartyTypeRaid:SetChecked(false)
		currColOpt.visibilityPartyType = nil
		module:ReloadAllSplits()
	end)
	self.optColSet.chkVisibilityPartyTypeParty = ELib:Radio(self.optColSet.superTabFrame.tab[7],AGGRO_WARNING_IN_PARTY.." / "..SOLO):Point(10,-95):OnClick(function(self) 
		module.options.optColSet.chkVisibilityPartyTypeAlways:SetChecked(false)
		module.options.optColSet.chkVisibilityPartyTypeParty:SetChecked(true)
		module.options.optColSet.chkVisibilityPartyTypeRaid:SetChecked(false)
		currColOpt.visibilityPartyType = 1
		module:ReloadAllSplits()
	end)
	self.optColSet.chkVisibilityPartyTypeRaid = ELib:Radio(self.optColSet.superTabFrame.tab[7],L.cd2OtherVisibilityPartyTypeRaid):Point(10,-115):OnClick(function(self) 
		module.options.optColSet.chkVisibilityPartyTypeAlways:SetChecked(false)
		module.options.optColSet.chkVisibilityPartyTypeParty:SetChecked(false)
		module.options.optColSet.chkVisibilityPartyTypeRaid:SetChecked(true)
		currColOpt.visibilityPartyType = 2
		module:ReloadAllSplits()
	end)

	self.optColSet.visibilityTextZoneType = ELib:Text(self.optColSet.superTabFrame.tab[7],L.cd2OtherVisibilityZoneType..":",10):Point(10,-140):Color()

	self.optColSet.chkVisibilityZoneArena = ELib:Check(self.optColSet.superTabFrame.tab[7],ARENA):Point(10,-155):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.visibilityDisableArena = nil
		else
			currColOpt.visibilityDisableArena = true
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkVisibilityZoneBG = ELib:Check(self.optColSet.superTabFrame.tab[7],BATTLEGROUND):Point(10,-180):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.visibilityDisableBG = nil
		else
			currColOpt.visibilityDisableBG = true
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkVisibilityZoneScenario = ELib:Check(self.optColSet.superTabFrame.tab[7],TRACKER_HEADER_SCENARIO):Point(10,-205):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.visibilityDisable3ppl = nil
		else
			currColOpt.visibilityDisable3ppl = true
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkVisibilityZone5ppl = ELib:Check(self.optColSet.superTabFrame.tab[7],CALENDAR_TYPE_DUNGEON):Point(10,-230):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.visibilityDisable5ppl = nil
		else
			currColOpt.visibilityDisable5ppl = true
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkVisibilityZoneRaid = ELib:Check(self.optColSet.superTabFrame.tab[7],RAID):Point(10,-255):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.visibilityDisableRaid = nil
		else
			currColOpt.visibilityDisableRaid = true
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkVisibilityZoneOutdoor = ELib:Check(self.optColSet.superTabFrame.tab[7],WORLD):Point(10,-280):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.visibilityDisableWorld = nil
		else
			currColOpt.visibilityDisableWorld = true
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.chkGeneralVisibility = ELib:Check(self.optColSet.superTabFrame.tab[7],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.visibilityGeneral = true
		else
			currColOpt.visibilityGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralVisibility:doAlphas()
		ExRT.lib.SetAlphas(VMRT.ExCD2.colSet[module.options.optColTabs.selected].visibilityGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.chkOnlyInCombat,module.options.optColSet.visibilityTextPartyType,module.options.optColSet.chkVisibilityPartyTypeAlways,module.options.optColSet.chkVisibilityPartyTypeParty,module.options.optColSet.chkVisibilityPartyTypeRaid,module.options.optColSet.visibilityTextZoneType,module.options.optColSet.chkVisibilityZoneArena,module.options.optColSet.chkVisibilityZoneBG,module.options.optColSet.chkVisibilityZoneScenario,module.options.optColSet.chkVisibilityZone5ppl,module.options.optColSet.chkVisibilityZoneRaid,module.options.optColSet.chkVisibilityZoneOutdoor)
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
			currColOpt.blacklistText = strtrim( self:GetText() )
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
			currColOpt.whitelistText = strtrim( self:GetText() )
			if not scheluded then
				scheluded = ExRT.F.ScheduleTimer(ScheludeFunc, 1)
			end
		end
	end

	self.optColSet.chkGeneralBlackList = ELib:Check(self.optColSet.superTabFrame.tab[8],L.cd2ColSetGeneral):Point("TOPRIGHT",-10,-10):Left():OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.blacklistGeneral = true
		else
			currColOpt.blacklistGeneral = nil
		end
		module:ReloadAllSplits()
		self:doAlphas()
	end)
	function self.optColSet.chkGeneralBlackList:doAlphas()
		ExRT.lib.SetAlphas(VMRT.ExCD2.colSet[module.options.optColTabs.selected].blacklistGeneral and module.options.optColTabs.selected ~= (module.db.maxColumns + 1) and 0.5 or 1,module.options.optColSet.blacklistEditBox,module.options.optColSet.whitelistEditBox,module.options.optColSet.whitelistText,module.options.optColSet.blacklistText)
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
			textureAnimation = true,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 1,
			iconPosition = 1,
			iconGray = true,
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
			textureClassBackground = false,
			textureClassTimeLine = false,
			textureClassText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%time%",
			textTemplateCenter = "",
			textureAnimation = true,
			_heightType = 1,
		},
		[2] = {
			iconSize = 14,
			textureAnimation = false,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 1,
			iconPosition = 1,
			iconGray = false,
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
			textureClassBackground = false,
			textureClassTimeLine = false,
			textureClassText = false,
			textTemplateLeft = "%time% %name%",
			textTemplateRight = "",
			textTemplateCenter = "",
			_heightType = 1,
		},
		[3] = {
			iconSize = 24,
			frameWidth = 24,
			textureAnimation = false,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 1,
			iconPosition = 1,
			iconGray = true,
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
			textureClassBackground = false,
			textureClassTimeLine = false,
			textureClassText = false,
			textTemplateLeft = "",
			textTemplateRight = "",
			textTemplateCenter = "",
			textIconName = false,
			methodsCooldown = true,
			iconCooldownShowSwipe = true,

			ATFLines = 2,
			ATFCol = 6,
			ATFGrowth = 2,
			ATF = true,
			fontCDSize = 10,
			iconGlowType = 3,

			func = function(parent,templateFrame)
				local f1 = ELib:Frame(parent):Point("BOTTOMRIGHT",parent,"RIGHT",-20,0):Size(80,48)
				ELib:Texture(f1,.8,.8,.8,.8,"BACKGROUND"):Point('x')
				ELib:Text(f1,UnitName"player",12):Point("CENTER",0,0):Color(0,0.44,0.866):Outline()
				local i1=templateFrame.lines[1] i1:ClearAllPoints() i1:SetPoint("BOTTOMRIGHT",f1,"BOTTOMLEFT",0,0)
				local i2=templateFrame.lines[2] i2:ClearAllPoints() i2:SetPoint("RIGHT",i1,"LEFT",0,0)
				local i3=templateFrame.lines[3] i3:ClearAllPoints() i3:SetPoint("BOTTOM",i1,"TOP",0,0)

				local f2 = ELib:Frame(parent):Point("TOPRIGHT",parent,"RIGHT",-20,-1):Size(80,48)
				ELib:Texture(f2,.8,.8,.8,.8,"BACKGROUND"):Point("TOPLEFT",f2,0,0):Point("BOTTOMRIGHT",f2,-54,0)
				ELib:Texture(f2,.2,.2,.2,.8,"BACKGROUND"):Point("TOPLEFT",f2,"TOPRIGHT",-54,0):Point("BOTTOMRIGHT",f2,0,0)
				ELib:Text(f2,UnitName"player",12):Point("CENTER",0,0):Color(0.77,0.12,0.23):Outline()
				local i1=templateFrame.lines[4] i1:ClearAllPoints() i1:SetPoint("BOTTOMRIGHT",f2,"BOTTOMLEFT",0,0)
				local i2=templateFrame.lines[5] i2:ClearAllPoints() i2:SetPoint("RIGHT",i1,"LEFT",0,0)
				local i3=templateFrame.lines[6] i3:ClearAllPoints() i3:SetPoint("RIGHT",i2,"LEFT",0,0)
				local i4=templateFrame.lines[7] i4:ClearAllPoints() i4:SetPoint("BOTTOM",i1,"TOP",0,0)
				local i5=templateFrame.lines[8] i5:ClearAllPoints() i5:SetPoint("RIGHT",i4,"LEFT",0,0)
			end,
			disableOnGeneral = true,
			DiffSpellData = {
				spells = 	{98008,	108280,	8143,	49576,	61999,	51052,	48707,	48792	},
				spellsCD = 	{0,	90,	0,	10,	0,	0,	20,	25	},
				spellsDuration ={0,	0,	10,	0,	0,	0,	5,	8	},
				spellsDead = 	{nil,	nil,	nil,	nil,	true,	nil,	nil,	nil	},
				spellsCharge = 	{nil,	nil,	nil,	true,	nil,	nil,	nil,	true	},
				spellsClass = 	{"SHAMAN","SHAMAN","SHAMAN","DEATHKNIGHT","DEATHKNIGHT","DEATHKNIGHT","DEATHKNIGHT","DEATHKNIGHT"},
			},
		},
		[4] = {
			iconSize = 16,
			textureAnimation = true,
			methodsStyleAnimation = 2,
			methodsTimeLineAnimation = 2,
			iconPosition = 1,
			iconGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar19.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,1,1, 1,1,0.5},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = 0.85,
			textureClassBackground = true,
			textureClassTimeLine = true,
			textureClassText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%time%",
			textTemplateCenter = "",

			frameBetweenLines = 1,
			_heightType = 1,
		},
		[5] = {
			iconSize = 40,
			textureAnimation = false,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 1,
			iconPosition = 1,
			iconGray = true,
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
			textureClassBackground = false,
			textureClassTimeLine = false,
			textureClassText = false,
			textTemplateLeft = "",
			textTemplateRight = "",
			textTemplateCenter = "",
			textIconName = true,
			methodsCooldown = true,
			textIconNameChars = 6,

			frameWidth = 40,
			frameColumns = 4,
			_heightType = 1,
		},
		[6] = {
			iconSize = 12,
			textureAnimation = false,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 1,
			iconPosition = 1,
			iconGray = false,
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
			textureClassBackground = false,
			textureClassTimeLine = false,
			textureClassText = false,
			textTemplateLeft = "%time% %name%",
			textTemplateRight = "",
			textTemplateCenter = "",
			_heightType = 1,
		},
		[7] = {
			iconSize = 14,
			textureAnimation = true,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 1,
			iconPosition = 1,
			iconGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar29.tga",
			colorsText = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsBack = {0,1,0, 0,1,0, 0.8,0,0, 1,1,0},
			colorsTL = {0,1,0, 0,1,0, 0.8,0,0, 1,1,0},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.8,
			textureAlphaCooldown = 0.5,
			textureClassBackground = false,
			textureClassTimeLine = false,
			textureClassText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%stime%",
			textTemplateCenter = "",
			_heightType = 1,
		},
		[8] = {
			iconSize = 16,
			textureAnimation = true,
			methodsStyleAnimation = 2,
			methodsTimeLineAnimation = 2,
			iconPosition = 2,
			iconGray = true,
			fontSize = 13,
			fontName = ExRT.F.defFont,
			fontOutline = true,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar6.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,0.5,0.5, 1,1,0.5,},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.8,
			textureAlphaCooldown = 0.5,
			textureClassBackground = false,
			textureClassTimeLine = false,
			textureClassText = true,
			textTemplateLeft = "%name%",
			textTemplateRight = "",
			textTemplateCenter = "",
			_heightType = 1,
		},
		[9] = {
			iconSize = 18,
			textureAnimation = true,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 2,
			iconPosition = 1,
			iconGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar16.tga",
			colorsText = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsBack = {0,0,0, 0,0,0, 0,0,0, 0,0,0},
			colorsTL = {0.24,0.44,1, 1,0.37,1, 0.24,0.44,1, 1,0.46,0.10},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.9,
			textureAlphaCooldown = 1,
			textureClassBackground = false,
			textureClassTimeLine = false,
			textureClassText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%stime%",
			textTemplateCenter = "",
			textureBorderSize = 1,
			frameBetweenLines = 3,
			textureBorderColorA = 1,
			_heightType = 1,
		},
		[10] = {
			iconSize = 18,
			textureAnimation = true,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 2,
			iconPosition = 1,
			iconGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar16.tga",
			colorsText = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsBack = {0,0,0, 0,0,0, 0,0,0, 0,0,0},
			colorsTL = {0.24,0.44,1, 1,0.37,1, 0.24,0.44,1, 1,0.46,0.10},
			textureAlphaBackground = 0.3,
			textureAlphaTimeLine = 0.9,
			textureAlphaCooldown = 1,
			textureClassBackground = false,
			textureClassTimeLine = true,
			textureClassText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%stime%",
			textTemplateCenter = "",
			textureBorderSize = 1,
			frameBetweenLines = 3,
			textureBorderColorA = 1,
			_heightType = 1,
		},
		[11] = {
			_twoSized = true,
			_Scaled = .8,

			iconSize = 40,
			textureAnimation = true,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 2,
			iconPosition = 1,
			iconGray = true,
			fontSize = 14,
			fontName = ExRT.F.defFont,
			fontOutline = true,
			fontShadow = false,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar17.tga",
			colorsText = {1,1,1, 1,1,1, 1,.6,.6, 1,1,.5},
			colorsBack = {0,0,0, 0,0,0, 0,0,0, 0,0,0},
			colorsTL = {0,0,0, 0,0,0, 0,0,0, 0,0,0},
			textureAlphaBackground = 0.8,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = .5,
			textureClassBackground = false,
			textureClassTimeLine = true,
			textureClassText = false,
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
			textureAnimation = true,
			methodsStyleAnimation = 2,
			methodsTimeLineAnimation = 2,
			iconPosition = 2,
			iconGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar19.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,1,1, 1,1,0.5},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = 0.85,
			textureClassBackground = true,
			textureClassTimeLine = true,
			textureClassText = false,
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
			_heightType = 1,
		},
		[14] = {
			iconSize = 14,
			textureAnimation = true,
			methodsStyleAnimation = 2,
			methodsTimeLineAnimation = 2,
			iconPosition = 1,
			iconGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar19.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,1,1, 1,1,0.5},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = 0.85,
			textureClassBackground = true,
			textureClassTimeLine = true,
			textureClassText = false,
			textTemplateLeft = "%name%",
			textTemplateRight = "%time%",
			textTemplateCenter = "",

			frameBetweenLines = 0,
			_heightType = 1,
		},
		[15] = {
			_twoSized = true,
			_Scaled = .85,

			iconSize = 13,
			textureAnimation = true,
			methodsStyleAnimation = 2,
			methodsTimeLineAnimation = 2,
			iconPosition = 1,
			iconGray = false,
			fontSize = 12,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar19.tga",
			colorsText = {1,1,1, 0.5,1,0.5, 1,1,1, 1,1,0.5},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 1,
			textureAlphaCooldown = 0.85,
			textureClassBackground = true,
			textureClassTimeLine = true,
			textureClassText = false,
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
			_heightType = 1,
		},
		[16] = {},
		[17] = {
			iconSize = 14,
			textureAnimation = true,
			methodsStyleAnimation = 1,
			methodsTimeLineAnimation = 2,
			iconPosition = 1,
			iconGray = false,
			fontSize = 10,
			fontName = ExRT.F.defFont,
			fontOutline = false,
			fontShadow = true,
			textureFile = "Interface\\AddOns\\"..GlobalAddonName.."\\media\\bar26.tga",
			colorsText = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsBack = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			colorsTL = {1,1,1, 1,1,1, 1,1,1, 1,1,1},
			textureAlphaBackground = 0.15,
			textureAlphaTimeLine = 0.8,
			textureAlphaCooldown = 1,
			textureClassBackground = false,
			textureClassTimeLine = true,
			textureClassText = false,
			textTemplateLeft = "",
			textTemplateRight = "%time%",
			textTemplateCenter = "%name%: %spell%",
			_heightType = 1,
		},
		def = {
			enabled = true,
			iconGlowType = 4,
			textureSmoothAnimation = true,
		},
		toOptions = {
			iconSize = true,
			textureAnimation = true,
			methodsStyleAnimation = true,
			methodsTimeLineAnimation = true,
			iconPosition = true,
			iconGray = true,
			fontSize = true,
			fontName = true,
			fontOutline = true,
			fontShadow = true,
			textureFile = true,
			textureAlphaBackground = true,
			textureAlphaTimeLine = true,
			textureAlphaCooldown = true,
			textureClassBackground = true,
			textureClassTimeLine = true,
			textureClassText = true,
			textTemplateLeft = true,
			textTemplateRight = true,
			textTemplateCenter = true,
			methodsCooldown = true,
			textIconName = true,
			fontOtherAvailable = true,
			frameBetweenLines = true,
			textureBorderSize = true,
			textureBorderColorR = true,
			textureBorderColorG = true,
			textureBorderColorB = true,
			textureBorderColorA = true,
			methodsNewSpellNewLine = true,
			methodsSortingRules = true,
			iconTitles = true,
			iconHideBlizzardEdges = true,
			iconCooldownShowSwipe = true,
			textIconNameChars = true,

			iconGeneral = true,
			textureGeneral = true,
			methodsGeneral = true,
			fontGeneral = true,
			textGeneral = true,
			frameGeneral = true,

			frameColumns = true,

			textureSmoothAnimation = true,
			textureSmoothAnimationDuration = true,
			iconCooldownHideNumbers = true,
			textureHideSpark = true,
			iconGlowType = true,
			methodsDisableActive = true,
			methodsOneSpellPerCol = true,

			fontCDSize = true,
			ATF = true,
			ATFLines = true,
			ATFCol = true,
			ATFGrowth = true,

			_frameAlpha = "frameAlpha",
			_frameWidth = "frameWidth",
			_frameBlackBack = "frameBlackBack",
			_frameLines = "frameLines",
		},
	}
	self.optColSet.templateSaveData = nil

	for i=1,#self.optColSet.templateData do
		local t = self.optColSet.templateData[i]
		if t.colorsText then for j=1,3 do for k=1,3 do
			local key = "textureColorText"..(j == 1 and "Default" or j==2 and "Active" or "Cooldown")..(k==1 and "R" or k==2 and "G" or "B")
			t[key] = t.colorsText[(j-1)*3+k]
			self.optColSet.templateData.toOptions[key] = true
		end end end
		if t.colorsBack then for j=1,3 do for k=1,3 do
			local key = "textureColorBackground"..(j == 1 and "Default" or j==2 and "Active" or "Cooldown")..(k==1 and "R" or k==2 and "G" or "B")
			t[key] = t.colorsBack[(j-1)*3+k]
			self.optColSet.templateData.toOptions[key] = true
		end end end
		if t.colorsTL then for j=1,3 do for k=1,3 do
			local key = "textureColorTimeLine"..(j == 1 and "Default" or j==2 and "Active" or "Cooldown")..(k==1 and "R" or k==2 and "G" or "B")
			t[key] = t.colorsTL[(j-1)*3+k]
			self.optColSet.templateData.toOptions[key] = true
		end end end
		t.colorsText, t.colorsBack, t.colorsTL = nil
	end

	local function TemplateButtonOnEnter(self)
		if self.templateData.disableOnGeneral and module.options.optColTabs.selected == (module.db.maxColumns + 1) then
			self.backgTexture:SetColorTexture(1,0,0,0.3)
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
			GameTooltip:AddLine(L.cd2ATFTooltipDisabled)
			GameTooltip:Show()
		else
			self.backgTexture:SetColorTexture(1,1,1,0.3)
		end
	end
	local function TemplateButtonOnLeave(self)
		self.backgTexture:SetColorTexture(0,0,0,0)
		GameTooltip_Hide()
	end
	local function TemplateButtonOnClick(self)
		local templateData = self.templateData
		if templateData.disableOnGeneral and module.options.optColTabs.selected == (module.db.maxColumns + 1) then
			return
		end
	  	module.options.optColSet.templateRestore:Show()
	  	module.options.optColSet.templateSaveData = {}
	  	ExRT.F.table_copy(currColOpt,module.options.optColSet.templateSaveData)
	  	for key,val in pairs(module.options.optColSet.templateData.toOptions) do
			if type(val) == "boolean" then
				val = key
			end
  			if key:sub(1,1)=="_" then
  				key = key:sub(2)
  				if templateData[key] then
  					currColOpt[val] = templateData[key]
  				elseif key == "frameWidth" then
  					currColOpt[val] = max(130,currColOpt[val] or 130)
  				end
  			elseif val:find("General") then
  				currColOpt[val] = nil
  			else
  				currColOpt[val] = templateData[key]
  			end
	  	end
	  	module:ReloadAllSplits()
	  	module.options.selectColumnTab()
	end
	local TemplateMT = {__index = self.optColSet.templateData.def}

	self.optColSet.templatesScrollFrame = ELib:ScrollFrame(self.optColSet.superTabFrame.tab[9]):Size(430,380):Point("TOP",0,-50):Height( ceil(#self.optColSet.templateData/2) * 125 + 10 )
	for i=1,#self.optColSet.templateData do 
		local templateData = self.optColSet.templateData[i]
		if ExRT.F.table_len(templateData) > 0 then
			local buttonFrame = CreateFrame("Button",nil,self.optColSet.templatesScrollFrame.C)
			if templateData._twoSized then
				buttonFrame:SetSize(370,120)
			else
				buttonFrame:SetSize(185,120)
			end
			buttonFrame:SetPoint(templateData._twoSized and "TOP" or (i-1)%2 == 0 and "TOPRIGHT" or "TOPLEFT",self.optColSet.templatesScrollFrame.C,"TOP",0,-floor((i-1)/2) * 125 - 5)
			buttonFrame.backgTexture = buttonFrame:CreateTexture(nil, "BACKGROUND")
			buttonFrame.backgTexture:SetAllPoints()
			buttonFrame.templateData = templateData

			buttonFrame:SetScript("OnEnter",TemplateButtonOnEnter)
			buttonFrame:SetScript("OnLeave",TemplateButtonOnLeave)
			buttonFrame:SetScript("OnClick",TemplateButtonOnClick)

			local templateFrame = module:CreateColumn(buttonFrame)
			self.optColSet.templates[i] = templateFrame
			setmetatable(templateData,TemplateMT)
			module:ColApplyStyle(templateFrame,templateData,{},module.db.colsDefaults)
			templateFrame:ClearAllPoints()
			templateFrame:Show()
			templateFrame:SetPoint("CENTER")
			if templateData._heightType == 1 then
				local l = #(templateData.DiffSpellData and templateData.DiffSpellData.spells or self.optColSet.templateData.spells)
				l = ceil(l / (templateData.frameColumns or 1))
				local height = templateData.iconSize * l + ((templateData.frameBetweenLines or 0) - 1) * l
				templateFrame:SetSize(min(templateFrame:GetWidth(),templateData._twoSized and 370 or 185),min(height,120))
			else
				templateFrame:SetSize(min(templateFrame:GetWidth(),templateData._twoSized and 370 or 185),min(templateFrame:GetHeight(),120))
			end

			if templateData._Scaled then
				templateFrame:SetScale(templateData._Scaled)
			end
			if templateData.func then
				templateData.func(buttonFrame,templateFrame)
			end

			local spellData = templateData.DiffSpellData or self.optColSet.templateData

			local classColorsTable = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

			local lineC = 0
			for j=1,#spellData.spells do 
				lineC = lineC + 1
				local bar = templateFrame.lines[lineC]

				local spellClass = spellData.spellsClass[j]
				if spellData.spells[j] ~= 0 then
					local spellID = spellData.spells[j]
					local spellName,_,spellTexture = GetSpellInfo(spellID or 0)
					spellName = spellName or "unk"


					bar.data = {
						name = ExRT.SDB.charName,
						fullName = ExRT.SDB.charName,
						icon = spellTexture,
						spellName = i == 3 and spellName:sub(1,spellName:find(' ')) or spellName,
						db = {spellID,spellClass},
						lastUse = GetTime(),
						charge = GetTime(),
						cd = spellData.spellsCD[j],
						duration = spellData.spellsDuration[j],
						classColor = classColorsTable[spellClass] or module.db.notAClass,

						disabled = spellData.spellsDead[j],
						isCharge = spellData.spellsCharge[j],

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
				end

				bar:UpdateStyle()
				bar:Update()
				bar:UpdateStatus()
				if spellClass == "title" then
					bar:CreateTitle()
				end
			end
		end
	end

	self.optColSet.templateRestore = CreateFrame("Button",nil,self.optColSet.superTabFrame.tab[9], BackdropTemplateMixin and "BackdropTemplate")
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
		wipe(currColOpt)
		ExRT.F.table_copy(module.options.optColSet.templateSaveData,currColOpt)
		module:ReloadAllSplits()
		module.options.selectColumnTab()
		self:Hide()
	end)
	self.optColSet.templateRestore:Hide()

	--> Attach to frame

	self.optColSet.chkATF = ELib:Check(self.optColSet.superTabFrame.tab[10],L.Enable):Point(10,-10):OnClick(function(self) 
		if self:GetChecked() then
			currColOpt.ATF = true
			currColOpt.frameGeneral = false
			currColOpt.textureGeneral = false
			currColOpt.iconGeneral = false
			currColOpt.methodsGeneral = false
			currColOpt.textGeneral = false
			currColOpt.fontGeneral = false
			currColOpt.methodsCooldown = true
			currColOpt.frameStrata = nil
		else
			currColOpt.ATF = nil
		end
		module:ReloadAllSplits()
	end)

	self.optColSet.sliderATFHeight = ELib:Slider(self.optColSet.superTabFrame.tab[10],L.cd2OtherSetIconSize):Size(400):Point("TOP",0,-50):Range(6,128):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.iconSize = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.sliderATFFont = ELib:Slider(self.optColSet.superTabFrame.tab[10],L.cd2OtherSetFontSize):Size(400):Point("TOP",0,-85):Range(8,72):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.fontCDSize = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.ATFframePreview = ELib:Frame(self.optColSet.superTabFrame.tab[10]):Point("TOPLEFT",140,-140):Size(80,45)
	ELib:Texture(self.optColSet.ATFframePreview,.8,.8,.8,.8,"BACKGROUND"):Point('x')

	ELib:Text(self.optColSet.superTabFrame.tab[10],L.cd2ATFPosition..":"):Point("RIGHT",self.optColSet.ATFframePreview,"LEFT",-30,0):Color()

	function self.optColSet.ATFRadiosCheck()
		for k,v in pairs(self.optColSet.ATFRadios) do
			v:SetChecked(false)
		end
		local pos = VMRT.ExCD2.colSet[module.options.optColTabs.selected].ATFPos or 1
		local k = pos == 1 and "LB" or
			pos == 2 and "LT" or
			pos == 3 and "TL" or
			pos == 4 and "TR" or
			pos == 5 and "RT" or
			pos == 6 and "RB" or
			pos == 7 and "BR" or
			pos == 8 and "BL" or
			"C"
		self.optColSet.ATFRadios[k]:SetChecked(true)
	end
	self.optColSet.ATFRadios = {}
	self.optColSet.ATFRadios.LB = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("BOTTOMRIGHT",self.optColSet.ATFframePreview,"BOTTOMLEFT",-2,2):OnClick(function(self) 
		currColOpt.ATFPos = 1
		module.options.optColSet.ATFRadiosCheck()
		module:ReloadAllSplits()
	end)
	self.optColSet.ATFRadios.LT = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("TOPRIGHT",self.optColSet.ATFframePreview,"TOPLEFT",-2,-2):OnClick(function(self) 
		currColOpt.ATFPos = 2
		module.options.optColSet.ATFRadiosCheck()
		module:ReloadAllSplits()
	end)
	self.optColSet.ATFRadios.TL = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("BOTTOMLEFT",self.optColSet.ATFframePreview,"TOPLEFT",2,2):OnClick(function(self) 
		currColOpt.ATFPos = 3
		module.options.optColSet.ATFRadiosCheck()
		module:ReloadAllSplits()
	end)
	self.optColSet.ATFRadios.TR = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("BOTTOMRIGHT",self.optColSet.ATFframePreview,"TOPRIGHT",-2,2):OnClick(function(self) 
		currColOpt.ATFPos = 4
		module.options.optColSet.ATFRadiosCheck()
		module:ReloadAllSplits()
	end)
	self.optColSet.ATFRadios.RT = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("TOPLEFT",self.optColSet.ATFframePreview,"TOPRIGHT",2,-2):OnClick(function(self) 
		currColOpt.ATFPos = 5
		module.options.optColSet.ATFRadiosCheck()
		module:ReloadAllSplits()
	end)
	self.optColSet.ATFRadios.RB = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("BOTTOMLEFT",self.optColSet.ATFframePreview,"BOTTOMRIGHT",2,2):OnClick(function(self) 
		currColOpt.ATFPos = 6
		module.options.optColSet.ATFRadiosCheck()
		module:ReloadAllSplits()
	end)
	self.optColSet.ATFRadios.BR = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("TOPRIGHT",self.optColSet.ATFframePreview,"BOTTOMRIGHT",-2,-2):OnClick(function(self) 
		currColOpt.ATFPos = 7
		module.options.optColSet.ATFRadiosCheck()
		module:ReloadAllSplits()
	end)
	self.optColSet.ATFRadios.BL = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("TOPLEFT",self.optColSet.ATFframePreview,"BOTTOMLEFT",2,-2):OnClick(function(self) 
		currColOpt.ATFPos = 8
		module.options.optColSet.ATFRadiosCheck()
		module:ReloadAllSplits()
	end)
	self.optColSet.ATFRadios.C = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("CENTER",self.optColSet.ATFframePreview,"CENTER",0,0):OnClick(function(self) 
		currColOpt.ATFPos = 9
		module.options.optColSet.ATFRadiosCheck()
		module:ReloadAllSplits()
	end)

	ELib:Text(self.optColSet.superTabFrame.tab[10],L.cd2ATFGrowth..":"):Point("TOPLEFT",320,-115):Color()

	self.optColSet.ATFTypeGrowth1 = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("TOPLEFT",280,-140):OnClick(function(self) 
		currColOpt.ATFGrowth = 1
		module.options.optColSet.ATFTypeGrowth2:SetChecked(false)
		module:ReloadAllSplits()
	end)

	do
		local p = self.optColSet.ATFTypeGrowth1
		local x,y = 20, 5
		for i=1,3 do
			p["l"..i] = p:CreateLine(nil, "BACKGROUND", nil, -5)
			p["l"..i]:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/line")
			p["l"..i]:SetVertexColor(1,0,0,1)
			p["l"..i]:SetThickness(8)

			x, y = (i % 2) == 1 and 20 or 120, i < 3 and 10 or -10
			p["l"..i]:SetStartPoint("CENTER",p, x, y)
			x, y = (i % 2) == 1 and 120 or 20, i < 2 and 10 or -10
			p["l"..i]:SetEndPoint("CENTER",p, x, y)
		end
	end

	self.optColSet.ATFTypeGrowth2 = ELib:Radio(self.optColSet.superTabFrame.tab[10]):Point("TOPLEFT",280,-180):OnClick(function(self) 
		currColOpt.ATFGrowth = 2
		module.options.optColSet.ATFTypeGrowth1:SetChecked(false)
		module:ReloadAllSplits()
	end)

	do
		local p = self.optColSet.ATFTypeGrowth2
		local x,y = 20, 10
		for i=1,11 do
			p["l"..i] = p:CreateLine(nil, "BACKGROUND", nil, -5)
			p["l"..i]:SetTexture("Interface/AddOns/"..GlobalAddonName.."/media/line")
			p["l"..i]:SetVertexColor(1,0,0,1)
			p["l"..i]:SetThickness(8)

			p["l"..i]:SetStartPoint("CENTER",p, x, y)
			if (i % 2) == 0 then
				x = x + 20
				y = y + 20
			else
				y = y - 20
			end
			p["l"..i]:SetEndPoint("CENTER",p, x, y)
		end
	end

	self.optColSet.sliderATFMaxCol = ELib:Slider(self.optColSet.superTabFrame.tab[10],L.cd2ATFMaxCol):Size(400):Point("TOP",0,-230):Range(1,20):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.ATFCol = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.sliderATFMaxLine = ELib:Slider(self.optColSet.superTabFrame.tab[10],L.cd2ATFMaxLine):Size(400):Point("TOP",0,-265):Range(1,20):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.ATFLines = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.sliderATFOffsetX = ELib:Slider(self.optColSet.superTabFrame.tab[10],L.cd2ATFOffsetX):Size(400):Point("TOP",0,-300):Range(-300,300):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.ATFOffsetX = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.sliderATFOffsetY = ELib:Slider(self.optColSet.superTabFrame.tab[10],L.cd2ATFOffsetY):Size(400):Point("TOP",0,-335):Range(-300,300):SetObey(true):OnChange(function(self,event) 
		event = event - event%1
		currColOpt.ATFOffsetY = event
		module:ReloadAllSplits()
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.optColSet.dropDownATFFramePrior = ELib:DropDown(self.optColSet.superTabFrame.tab[10],350,-1):Size(230):Point("TOPLEFT",180,-370):Tooltip(L.cd2FramePriorTooltip)
	self.optColSet.textdropDownATFFramePrior = ELib:Text(self.optColSet.superTabFrame.tab[10],L.cd2FramePrior..":",11):Size(200,20):Point("LEFT",10,0):Point("TOP",self.optColSet.dropDownATFFramePrior,0,0)
	for i=1,#module.db.rframes do
		self.optColSet.dropDownATFFramePrior.List[i] = {
			text = module.db.rframes[i].text or module.db.rframes[i].name,
			arg1 = module.db.rframes[i].name,
			func = function (self,arg,arg2)
				ELib:DropDownClose()
				currColOpt.ATFFramePrior = arg
				module:ReloadAllSplits()
				self:GetParent().parent:Update()
			end
		}
	end
	function self.optColSet.dropDownATFFramePrior:Update(opt)
		opt = opt or currColOpt.ATFFramePrior
		local optData = ExRT.F.table_find3(module.db.rframes, opt, "name")
		if optData then
			self:SetText(optData.text or optData.name or "")
		else
			self:SetText("")
		end
	end


	do
		module.options.optColTabs.selected = module.db.maxColumns+1
		module.options.tab.tabs[2]:SetScript("OnShow",function ()
			module.options.selectColumnTab(self.optColTabs.tabs[module.db.maxColumns+1].button)
			module.options.tab.tabs[2]:SetScript("OnShow",nil)
		end)
	end

	--> Advanced

	local advTab = self.optColTabs.tabs[module.db.maxColumns+2]

	advTab.hotfixEdit = ELib:MultiEdit(advTab):Size(650,200):Point("TOPLEFT",0,-30):SetText(VMRT.ExCD2.Hotfixes or ""):OnChange(function(self,isUser)
		if not isUser then
			return
		end
		VMRT.ExCD2.Hotfixes = self:GetText()
		advTab.hotfixApplyBut:Show()
	end)
	--advTab.hotfixEdit.EditBox:Disable()
	advTab.hotfixEditText = ELib:Text(advTab,"Hotfixes: [?]"):Point("BOTTOMLEFT",advTab.hotfixEdit,"TOPLEFT",10,3):Color():Run(function(self) self.TooltipOverwrite = "Functionality to change predefined addons data for spells.\nExample to change spells cooldown: \"62618:cd:120\". (Change cooldown of spell 62618 to 2 mins)\nExample to change spells duration: \"1044:dur:15\". (Change duration of spell 1044 to 15 sec)" end):Tooltip()
	advTab.hotfixApplyBut = ELib:Button(advTab,APPLY):Point("TOPLEFT",advTab.hotfixEdit,"TOPRIGHT",5,-2):Size(90,25):Shown(false):OnClick(function (self)
		self:Hide()
		module:ApplyHotfixes()
	end)


	--> Profiles

	local profilesTab = self.optColTabs.tabs[module.db.maxColumns+3]

	local function GetCurrentProfileName()
		return VMRT.ExCD2.Profiles.Now=="default" and L.ProfilesDefault or VMRT.ExCD2.Profiles.Now
	end

	profilesTab.currentText = ELib:Text(profilesTab,L.ProfilesCurrent,11):Size(650,200):Point(15,-20):Top():Color()
	profilesTab.currentName = ELib:Text(profilesTab,"",14):Size(650,200):Point(210,-20):Top():Color(1,1,0)

	profilesTab.currentName.UpdateText = function(self)
		self:SetText(GetCurrentProfileName())
	end
	profilesTab.currentName:UpdateText()

	profilesTab.choseText = ELib:Text(profilesTab,L.ProfilesChooseDesc,11):Size(650,200):Point(15,-60):Top():Color()

	profilesTab.choseNewText = ELib:Text(profilesTab,L.ProfilesNew,11):Size(650,200):Point(15,-88):Top()
	profilesTab.choseNew = ELib:Edit(profilesTab):Size(170,20):Point(10,-100)

	profilesTab.choseNewButton = ELib:Button(profilesTab,L.ProfilesAdd):Size(70,20):Point("LEFT",profilesTab.choseNew,"RIGHT",0,0):OnClick(function (self)
		local text = profilesTab.choseNew:GetText()
		profilesTab.choseNew:SetText("")
		if text == "" or text == "default" or VMRT.ExCD2.Profiles.List[text] or text == VMRT.ExCD2.Profiles.Now then
			return
		end
		VMRT.ExCD2.Profiles.List[text] = ExRT.F.table_copy2(NewVMRTTableData)

		StaticPopupDialogs["EXRT_EXCD_ACTIVATENEW"] = {
			text = L.ProfilesActivateAlert,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				module:SelectProfile(text)
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_EXCD_ACTIVATENEW")
	end)

	profilesTab.choseSelectText = ELib:Text(profilesTab,L.ProfilesSelect,11):Size(605,200):Point(335,-88):Top()
	profilesTab.choseSelectDropDown = ELib:DropDown(profilesTab,220,10):Point(330,-100):Size(235):SetText(LFG_LIST_SELECT)

	local function GetCurrentProfilesList(func)
		local list = {
			{ text = GetCurrentProfileName(), func = func, arg1 = VMRT.ExCD2.Profiles.Now, _sort = "0" },
		}
		for name,_ in pairs(VMRT.ExCD2.Profiles.List) do
			if name ~= VMRT.ExCD2.Profiles.Now then
				list[#list + 1] = { text = name == "default" and L.ProfilesDefault or name, func = func, arg1 = name, _sort = "1"..name }
			end
		end
		sort(list,function(a,b) return a._sort < b._sort end)
		return list
	end

	function profilesTab.choseSelectDropDown:ToggleUpadte()
		self.List = GetCurrentProfilesList(function(_,arg1)
			ELib:DropDownClose()
			module:SelectProfile(arg1)
		end)
	end

	local function CopyProfile(name)
		local newdb = VMRT.ExCD2.Profiles.List[name]
		local currname = VMRT.ExCD2.Profiles.Now
		if module:SelectProfile(name) then
			VMRT.ExCD2.Profiles.List[name] = newdb
			VMRT.ExCD2.Profiles.Now = currname

			profilesTab.currentName:UpdateText()

			print(L.cd2ProfileCopySuccess:format(name))
		end
	end
	profilesTab.copyText = ELib:Text(profilesTab,L.ProfilesCopy,11):Size(605,200):Point(15,-138):Top()
	profilesTab.copyDropDown = ELib:DropDown(profilesTab,220,10):Point(10,-150):Size(235)
	function profilesTab.copyDropDown:ToggleUpadte()
		self.List = GetCurrentProfilesList(function(_,arg1)
			ELib:DropDownClose()
			CopyProfile(arg1)
		end)
		for i=1,#self.List do
			if self.List[i].arg1 == VMRT.ExCD2.Profiles.Now then
				tremove(self.List, i)
				break
			end
		end
	end

	local function DeleteProfile(name)
		StaticPopupDialogs["EXRT_EXCD_PROFILES_REMOVE"] = {
			text = L.ProfilesDeleteAlert,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				VMRT.ExCD2.Profiles.List[name] = nil
				profilesTab:UpdateAutoTexts()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("EXRT_EXCD_PROFILES_REMOVE")
	end
	profilesTab.deleteText = ELib:Text(profilesTab,L.ProfilesDelete,11):Size(605,200):Point(15,-188):Top()
	profilesTab.deleteDropDown = ELib:DropDown(profilesTab,220,10):Point(10,-200):Size(235)
	function profilesTab.deleteDropDown:ToggleUpadte()
		self.List = GetCurrentProfilesList(function(_,arg1)
			ELib:DropDownClose()
			DeleteProfile(arg1)
		end)
		for i=#self.List,1,-1 do
			if self.List[i].arg1 == VMRT.ExCD2.Profiles.Now then
				tremove(self.List, i)
			elseif self.List[i].arg1 == "default" then
				tremove(self.List, i)
			end
		end
	end


	profilesTab.importWindow, profilesTab.exportWindow = ExRT.F.CreateImportExportWindows()

	function profilesTab.importWindow:ImportFunc(str)
		local headerLen = str:sub(1,4) == "EXRT" and 8 or 7

		local header = str:sub(1,headerLen)
		if (header:sub(1,headerLen-1) ~= "EXRTCDP" and header:sub(1,headerLen-1) ~= "MRTCDP") or (header:sub(headerLen,headerLen) ~= "0" and header:sub(headerLen,headerLen) ~= "1") then
			StaticPopupDialogs["EXRT_EXCD_IMPORT"] = {
				text = "|cffff0000"..ERROR_CAPS.."|r "..L.ProfilesFail3,
				button1 = OKAY,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,
			}
			StaticPopup_Show("EXRT_EXCD_IMPORT")
			return
		end

		profilesTab:TextToProfile(str:sub(headerLen+1),header:sub(headerLen,headerLen)=="0")
	end

	profilesTab.exportButton = ELib:Button(profilesTab,L.ProfilesExport):Size(235,25):Point(10,-250):OnClick(function (self)
		profilesTab.exportWindow:NewPoint("CENTER",UIParent,0,0)
		profilesTab:ProfileToText()
	end)

	profilesTab.importButton = ELib:Button(profilesTab,L.ProfilesImport):Size(235,25):Point("LEFT",profilesTab.exportButton,"RIGHT",85,0):OnClick(function (self)
		profilesTab.importWindow:NewPoint("CENTER",UIParent,0,0)
		profilesTab.importWindow:Show()
	end)

	local IGNORE_PROFILE_KEYS = {
		["Profiles"] = true,
	}
	function profilesTab:ProfileToText()
		local new = {}
		for key,val in pairs(VMRT.ExCD2) do
			if not IGNORE_PROFILE_KEYS[key] then
				new[key] = val
			end
		end
		local strlist = ExRT.F.TableToText(new)
		strlist[1] = "0,"..strlist[1]
		local str = table.concat(strlist)

		local compressed
		if #str < 1000000 then
			compressed = LibDeflate:CompressDeflate(str,{level = 5})
		end
		local encoded = "MRTCDP"..(compressed and "1" or "0")..LibDeflate:EncodeForPrint(compressed or str)

		ExRT.F.dprint("Str len:",#str,"Encoded len:",#encoded)

		if ExRT.isDev then
			module.db.exportTable = new
		end
		profilesTab.exportWindow.Edit:SetText(encoded)
		profilesTab.exportWindow:Show()
	end

	function profilesTab:SaveDataFilter(res)
		local KeysToSave = {
			["Profiles"] = true,
		}
		local R = {
			data = {},
			Restore = function(self,t) 
				for k,v in pairs(self.data) do
					t[k] = v
				end
			end
		}
		for k,v in pairs(KeysToSave) do
			R.data[k] = res[k]
		end
		return R
	end
	function profilesTab:LockedFilter(res)
		local KeysToErase = {
			["Profiles"] = true,
		}
		for k,v in pairs(KeysToErase) do
			res[k] = nil
		end
	end
	function profilesTab:OnlyVisualFilter(res)
		local KeysToErase = {
			["Hotfixes"] = true,
			["Priority"] = true,
			["CDE"] = true,
			["enabled"] = true,
			["gnGUIDs"] = true,
			["CDECol"] = true,
			["userDB"] = true,
			["OptFav"] = true,
		}
		for k,v in pairs(KeysToErase) do
			res[k] = VMRT.ExCD2[k]
		end
	end

	function profilesTab:TextToProfile(str,uncompressed)
		local decoded = LibDeflate:DecodeForPrint(str)
		local decompressed
		if uncompressed then
			decompressed = decoded
		else
			decompressed = LibDeflate:DecompressDeflate(decoded)
		end
		decoded = nil

		local _,tableData = strsplit(",",decompressed,2)
		decompressed = nil

		local successful, res = pcall(ExRT.F.TextToTable,tableData)
		if ExRT.isDev then
			module.db.lastImportDB = res
			if module.db.exportTable and type(res)=="table" then
				module.db.diffTable = {}
				print("Compare table",ExRT.F.table_compare(res,module.db.exportTable,module.db.diffTable))
			end
		end
		if successful and res then
			profilesTab:LockedFilter(res)
			StaticPopupDialogs["EXRT_EXCD_IMPORT"] = {
				text = L.cd2ProfileRewriteAlert,
				button1 = APPLY,
				button2 = L.cd2ImportOnlyVisual,
				button3 = L.ProfilesSaveAsNew,
				button4 = CANCEL,
				selectCallbackByIndex = true,
				OnButton1 = function()
					local saved = profilesTab:SaveDataFilter(VMRT.ExCD2)
					ExRT.F.table_rewrite(VMRT.ExCD2,res)
					saved:Restore(VMRT.ExCD2)
					module:ReloadProfile()
					res = nil
				end,
				OnButton2 = function()
					profilesTab:OnlyVisualFilter(res)
					local saved = profilesTab:SaveDataFilter(VMRT.ExCD2)
					ExRT.F.table_rewrite(VMRT.ExCD2,res)
					saved:Restore(VMRT.ExCD2)
					module:ReloadProfile()
					res = nil
				end,
				OnButton3 = function()
					ExRT.F.ShowInput(L.ProfilesNewProfile,function(_,name)
						if name == "" or VMRT.ExCD2.Profiles.List[name] or name == "default" or name == VMRT.ExCD2.Profiles.Now then
							res = nil
							return
						end
						VMRT.ExCD2.Profiles.List[name] = res
						module:SelectProfile(name)
						res = nil
					end,nil,nil,nil,function(self)
						local name = self:GetText()
						if name == "" or VMRT.ExCD2.Profiles.List[name] or name == "default" or name == VMRT.ExCD2.Profiles.Now then
							self:GetParent().OK:Disable()
						else
							self:GetParent().OK:Enable()
						end
					end)
				end,
				OnButton4 = function()
					res = nil
				end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,
			}
		else
			StaticPopupDialogs["EXRT_EXCD_IMPORT"] = {
				text = L.ProfilesFail1..(res and "\nError code: "..res or ""),
				button1 = OKAY,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,
			}
		end

		StaticPopup_Show("EXRT_EXCD_IMPORT")
	end


	profilesTab.autoText = ELib:Text(profilesTab,L.cd2AutoChangeTooltip,12):Size(605,200):Point(10,-300):Top():Color()

	local function GetTextProfileName(profileName)
		if not profileName then
			return
		end
		local prefix
		if profileName == VMRT.ExCD2.Profiles.Now then
			prefix = "|cff00ff00"
		elseif not VMRT.ExCD2.Profiles.List[profileName] then
			prefix = "|cffff0000"
		end
		if profileName == "default" then
			profileName = L.ProfilesDefault
		end
		return (prefix or "")..profileName
	end
	function profilesTab:UpdateAutoTexts()
		self.autoRaidDown:SetText(GetTextProfileName(VMRT.ExCD2.Profiles.Raid) or "|cff999999"..L.cd2DontChange)
		self.autoDungDown:SetText(GetTextProfileName(VMRT.ExCD2.Profiles.Dung) or "|cff999999"..L.cd2DontChange)
		self.autoArenaDown:SetText(GetTextProfileName(VMRT.ExCD2.Profiles.Arena) or "|cff999999"..L.cd2DontChange)
		self.autoBGDown:SetText(GetTextProfileName(VMRT.ExCD2.Profiles.BG) or "|cff999999"..L.cd2DontChange)
		self.autoOtherDown:SetText(GetTextProfileName(VMRT.ExCD2.Profiles.Other) or "|cff999999"..L.cd2DontChange)
	end

	local function AutoDropDown_ToggleUpadte(self)
		local func = function(_,arg1)
			ELib:DropDownClose()
			VMRT.ExCD2.Profiles[self.OptKey] = arg1
			profilesTab:UpdateAutoTexts()
		end
		self.List = GetCurrentProfilesList(func)
		tinsert(self.List,1,{text = L.cd2DontChange, func = func})
	end

	profilesTab.autoRaidDown = ELib:DropDown(profilesTab,220,10):Point(10,-335):Size(235):AddText(RAID,11,function(self)self:NewPoint("TOPLEFT",'x',5,12):Color(1,.82,0,1) end)
	profilesTab.autoRaidDown.OptKey = "Raid"
	profilesTab.autoRaidDown.ToggleUpadte = AutoDropDown_ToggleUpadte

	profilesTab.autoDungDown = ELib:DropDown(profilesTab,220,10):Point("TOPLEFT",profilesTab.autoRaidDown,0,-40):Size(235):AddText(CALENDAR_TYPE_DUNGEON,11,function(self)self:NewPoint("TOPLEFT",'x',5,12):Color(1,.82,0,1) end)
	profilesTab.autoDungDown.OptKey = "Dung"
	profilesTab.autoDungDown.ToggleUpadte = AutoDropDown_ToggleUpadte

	profilesTab.autoArenaDown = ELib:DropDown(profilesTab,220,10):Point("TOPLEFT",profilesTab.autoRaidDown,320,0):Size(235):AddText(ARENA,11,function(self)self:NewPoint("TOPLEFT",'x',5,12):Color(1,.82,0,1) end)
	profilesTab.autoArenaDown.OptKey = "Arena"
	profilesTab.autoArenaDown.ToggleUpadte = AutoDropDown_ToggleUpadte

	profilesTab.autoBGDown = ELib:DropDown(profilesTab,220,10):Point("TOPLEFT",profilesTab.autoArenaDown,0,-40):Size(235):AddText(BATTLEGROUND,11,function(self)self:NewPoint("TOPLEFT",'x',5,12):Color(1,.82,0,1) end)
	profilesTab.autoBGDown.OptKey = "BG"
	profilesTab.autoBGDown.ToggleUpadte = AutoDropDown_ToggleUpadte

	profilesTab.autoOtherDown = ELib:DropDown(profilesTab,220,10):Point("TOPLEFT",profilesTab.autoDungDown,0,-40):Size(235):AddText(OTHER,11,function(self)self:NewPoint("TOPLEFT",'x',5,12):Color(1,.82,0,1) end)
	profilesTab.autoOtherDown.OptKey = "Other"
	profilesTab.autoOtherDown.ToggleUpadte = AutoDropDown_ToggleUpadte

	profilesTab:UpdateAutoTexts()


	--> Other setts
	self.optSetTab = ELib:OneTab(self.tab.tabs[2],L.cd2OtherSet):Size(652,34):Point("TOP",0,-532)

	self.chkSplit = ELib:Check(self.optSetTab,L.cd2split,VMRT.ExCD2.SplitOpt):Point("LEFT",10,0):Tooltip(L.cd2splittooltip):OnClick(function(self,event)
		if self:GetChecked() then
			VMRT.ExCD2.SplitOpt = true
		else
			VMRT.ExCD2.SplitOpt = nil
		end
		module:UpdateLockState()
		module:SplitExCD2Window()
		module:ReloadAllSplits()
	end)

	self.chkNoRaid = ELib:Check(self.optSetTab,L.cd2noraid,VMRT.ExCD2.NoRaid):Point("LEFT",165,0):OnClick(function(self,event)
		if self:GetChecked() then
			VMRT.ExCD2.NoRaid = true
		else
			VMRT.ExCD2.NoRaid = nil
		end
		module:UpdateRoster()
	end)

	self.testMode = ELib:Check(self.optSetTab,L.cd2GeneralSetTestMode,module.db.testMode):Point("LEFT",325,0):Tooltip(L.cd2HelpTestButton):OnClick(function(self,event)
		if self:GetChecked() then
			module.db.testMode = true
		else
			module.db.testMode = nil
			TestMode(1)
		end
		module:UpdateSpellDB(true)
	end)

	self.butResetToDef = ELib:Button(self.optSetTab,L.cd2OtherSetReset):Size(160,20):Point("LEFT",480,0):Tooltip(L.cd2HelpButtonDefault):OnClick(function()
		local tabSelected = module.options.optColTabs.selected
		StaticPopupDialogs["EXRT_EXCD_DEFAULT"] = {
			text = L.cd2OtherSetReset,
			button1 = L.YesText,
			button2 = L.NoText,
			OnAccept = function()
				if not VMRT.ExCD2.colSet[tabSelected] then
					VMRT.ExCD2.colSet[tabSelected] = {}
				end
				table_wipe2(VMRT.ExCD2.colSet[tabSelected])
				for optName,optVal in pairs(module.db.colsInit) do
					VMRT.ExCD2.colSet[tabSelected][optName] = optVal
				end

				module.options.selectColumnTab(self.optColTabs.tabs[tabSelected].button)
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
			if VMRT.ExCD2.CDE[module.db.historyUsage[i][2]] then
				count = count + 1
			end
			if count >= v and VMRT.ExCD2.CDE[module.db.historyUsage[i][2]] then
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

	self.historyBox = ELib:MultiEdit2(self.tab.tabs[3]):Size(840,550):Point("TOP",0,-36):Hyperlinks()
	self.historyBox.EditBox:SetScript("OnShow",function(self)
		historyBoxUpdate(1)
		local count = 0
		for i=1,#module.db.historyUsage do
			if VMRT.ExCD2.CDE[module.db.historyUsage[i][2]] then
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
		[1] = {},
		[2] = {
			FramePos = { x = 90, y = 25 },FrameSize = { width = 660, height = 615 },
			[1] = { ButtonPos = { x = 50,	y = -110 },  	HighLightBox = { x = 0, y = -50, width = 660, height = 480 },		ToolTipDir = "RIGHT",	ToolTipText = L.cd2HelpColSetup },
			[2] = { ButtonPos = { x = 320,	y = -550 },  	HighLightBox = { x = 315, y = -560, width = 140, height = 30 },		ToolTipDir = "LEFT",	ToolTipText = L.cd2HelpTestButton },
			[3] = { ButtonPos = { x = 500,	y = -550 },  	HighLightBox = { x = 490, y = -560, width = 160, height = 30 },		ToolTipDir = "LEFT",	ToolTipText = L.cd2HelpButtonDefault },
		},
	}
	if not ExRT.isClassic then
		self.HELPButton = ExRT.lib.CreateHelpButton(self.tab.tabs[2],self.HelpPlate,self.tab)
		self.HELPButton:SetPoint("LEFT",self.title,"RIGHT",20,-2)
	end

	self.isWide = true

	module:CreateSpellData(true)
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

local function IconGlowNoLibStart(self)
	local LCG = LibStub("LibCustomGlow-1.0",true)
	if not LCG then
		return
	end
	local iconGlowType = self:GetParent().parent.optionGlowType
	if (not iconGlowType or iconGlowType == 1) then
		return LCG.ButtonGlow_Start(self)
	elseif iconGlowType == 2 then
		return LCG.AutoCastGlow_Start(self)
	elseif iconGlowType == 3 then
		return LCG.PixelGlow_Start(self)
	elseif iconGlowType == 4 then
		return ExRT.NULLfunc(self)
	end
end

local function IconGlowNoLibStop(self)
	local LCG = LibStub("LibCustomGlow-1.0",true)
	if not LCG then
		return
	end
	local iconGlowType = self:GetParent().parent.optionGlowType
	if (not iconGlowType or iconGlowType == 1) then
		return LCG.ButtonGlow_Stop(self)
	elseif iconGlowType == 2 then
		return LCG.AutoCastGlow_Stop(self)
	elseif iconGlowType == 3 then
		return LCG.PixelGlow_Stop(self)
	elseif iconGlowType == 4 then
		return ExRT.NULLfunc(self)
	end
end

function module:ColApplyStyle(columnFrame,currColOpt,generalOpt,defOpt,mainWidth,argScaleFix)
	local LCG = LibStub("LibCustomGlow-1.0",true)

	if not columnFrame.LOADEDs then
		columnFrame.LOADEDs = {}
	end

	columnFrame.iconSize = (not currColOpt.iconGeneral and currColOpt.iconSize) or (currColOpt.iconGeneral and generalOpt.iconSize) or defOpt.iconSize

	local frameBetweenLines = (not currColOpt.frameGeneral and currColOpt.frameBetweenLines) or (currColOpt.frameGeneral and generalOpt.frameBetweenLines) or defOpt.frameBetweenLines
	columnFrame.frameBetweenLines = frameBetweenLines

	local frameColumns = (not currColOpt.frameGeneral and currColOpt.frameColumns) or (currColOpt.frameGeneral and generalOpt.frameColumns) or defOpt.frameColumns
	columnFrame.frameColumns = frameColumns
	local linesShown = (not currColOpt.frameGeneral and currColOpt.frameLines) or (currColOpt.frameGeneral and generalOpt.frameLines) or defOpt.frameLines
	linesShown = ceil(linesShown / frameColumns)
	columnFrame.GlinesShown = linesShown
	local linesTotal = min(linesShown * frameColumns,module.db.maxLinesInCol)
	if currColOpt.ATF then
		linesTotal = 150
	end
	if VMRT.ExCD2.SplitOpt then 
		columnFrame.Gheight = columnFrame.iconSize*linesShown+frameBetweenLines*(linesShown-1)
		columnFrame:SetHeight(columnFrame.iconSize*linesShown+frameBetweenLines*(linesShown-1)) 
	elseif not currColOpt.ATF then
		columnFrame.Gheight = columnFrame.iconSize*linesShown
		columnFrame:SetHeight(columnFrame.iconSize*linesShown)
	end
	columnFrame.NumberLastLinesActive = max(linesTotal,module.db.maxLinesInCol,#columnFrame.lines)

	if currColOpt.enabled then
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

	local frameStrata = (not currColOpt.frameGeneral and currColOpt.frameStrata) or (currColOpt.frameGeneral and generalOpt.frameStrata) or defOpt.frameStrata
	if currColOpt.ATF then
		if not ( (not currColOpt.frameGeneral and currColOpt.frameStrata) or (currColOpt.frameGeneral and generalOpt.frameStrata) ) then
			columnFrame.autoStrata = true
		else
			columnFrame.autoStrata = false
		end
	else
		columnFrame.autoStrata = false
	end
	columnFrame:SetFrameStrata(frameStrata)
	columnFrame.FrameStrata = nil

	local frameAlpha = (not currColOpt.frameGeneral and currColOpt.frameAlpha) or (currColOpt.frameGeneral and generalOpt.frameAlpha) or defOpt.frameAlpha
	columnFrame:SetAlpha(frameAlpha/100) 

	local frameScale = (not currColOpt.frameGeneral and currColOpt.frameScale) or (currColOpt.frameGeneral and generalOpt.frameScale) or defOpt.frameScale
	if VMRT.ExCD2.SplitOpt then 
		if argScaleFix == "ScaleFix" then
			ExRT.F.SetScaleFix(columnFrame,frameScale/100)
		else
			columnFrame:SetScale(frameScale/100) 
		end
	else
		columnFrame:SetScale(1)
	end

	local blackBack = (not currColOpt.frameGeneral and currColOpt.frameBlackBack) or (currColOpt.frameGeneral and generalOpt.frameBlackBack) or defOpt.frameBlackBack
	columnFrame.texture:SetColorTexture(0,0,0,blackBack / 100)

	--> View options
	columnFrame.optionClassColorBackground = (not currColOpt.textureGeneral and currColOpt.textureClassBackground) or (currColOpt.textureGeneral and generalOpt.textureClassBackground)
	columnFrame.optionClassColorTimeLine = (not currColOpt.textureGeneral and currColOpt.textureClassTimeLine) or (currColOpt.textureGeneral and generalOpt.textureClassTimeLine)
	columnFrame.optionClassColorText = (not currColOpt.textureGeneral and currColOpt.textureClassText) or (currColOpt.textureGeneral and generalOpt.textureClassText)

	columnFrame.optionAnimation = (not currColOpt.textureGeneral and currColOpt.textureAnimation) or (currColOpt.textureGeneral and generalOpt.textureAnimation)
	columnFrame.optionSmoothAnimation = (not currColOpt.textureGeneral and currColOpt.textureSmoothAnimation) or (currColOpt.textureGeneral and generalOpt.textureSmoothAnimation)
	columnFrame.optionSmoothAnimationDuration = (not currColOpt.textureGeneral and currColOpt.textureSmoothAnimationDuration) or (currColOpt.textureGeneral and generalOpt.textureSmoothAnimationDuration) or defOpt.textureSmoothAnimationDuration
		columnFrame.optionSmoothAnimationDuration = columnFrame.optionSmoothAnimationDuration / 200
	columnFrame.optionLinesMax = linesTotal
	columnFrame.optionShownOnCD = (not currColOpt.methodsGeneral and currColOpt.methodsShownOnCD) or (currColOpt.methodsGeneral and generalOpt.methodsShownOnCD)
	columnFrame.optionIconPosition = (not currColOpt.iconGeneral and currColOpt.iconPosition) or (currColOpt.iconGeneral and generalOpt.iconPosition) or defOpt.iconPosition
	columnFrame.optionStyleAnimation = (not currColOpt.methodsGeneral and currColOpt.methodsStyleAnimation) or (currColOpt.methodsGeneral and generalOpt.methodsStyleAnimation) or defOpt.methodsStyleAnimation
	columnFrame.optionTimeLineAnimation = (not currColOpt.methodsGeneral and currColOpt.methodsTimeLineAnimation) or (currColOpt.methodsGeneral and generalOpt.methodsTimeLineAnimation) or defOpt.methodsTimeLineAnimation
	columnFrame.optionCooldown = (not currColOpt.iconGeneral and currColOpt.methodsCooldown) or (currColOpt.iconGeneral and generalOpt.methodsCooldown)
	columnFrame.optionCooldownHideNumbers = (not currColOpt.iconGeneral and currColOpt.iconCooldownHideNumbers) or (currColOpt.iconGeneral and generalOpt.iconCooldownHideNumbers)
	columnFrame.optionCooldownUseExRT = (not currColOpt.iconGeneral and currColOpt.iconCooldownExRTNumbers) or (currColOpt.iconGeneral and generalOpt.iconCooldownExRTNumbers)
		if columnFrame.optionCooldownUseExRT then columnFrame.optionCooldownHideNumbers = true end
	columnFrame.optionCooldownShowSwipe = (not currColOpt.iconGeneral and currColOpt.iconCooldownShowSwipe) or (currColOpt.iconGeneral and generalOpt.iconCooldownShowSwipe)
	columnFrame.optionIconName = (not currColOpt.textGeneral and currColOpt.textIconName) or (currColOpt.textGeneral and generalOpt.textIconName)
	columnFrame.optionHideSpark = (not currColOpt.textureGeneral and currColOpt.textureHideSpark) or (currColOpt.textureGeneral and generalOpt.textureHideSpark)
	columnFrame.optionIconTitles = (not currColOpt.iconGeneral and currColOpt.iconTitles) or (currColOpt.iconGeneral and generalOpt.iconTitles)
		columnFrame.optionIconTitles = columnFrame.optionIconTitles and not (columnFrame.optionIconPosition == 3)
	columnFrame.optionIconHideBlizzardEdges = (not currColOpt.iconGeneral and currColOpt.iconHideBlizzardEdges) or (currColOpt.iconGeneral and generalOpt.iconHideBlizzardEdges)

	local iconGlowType = (not currColOpt.iconGeneral and currColOpt.iconGlowType) or (currColOpt.iconGeneral and generalOpt.iconGlowType) or defOpt.iconGlowType
	columnFrame.optionGlowType = iconGlowType
	local glowStart, glowStop
	if LCG and (not iconGlowType or iconGlowType == 1) then
		glowStart, glowStop = LCG.ButtonGlow_Start, LCG.ButtonGlow_Stop
	elseif LCG and iconGlowType == 2 then
		glowStart, glowStop = LCG.AutoCastGlow_Start, LCG.AutoCastGlow_Stop
	elseif LCG and iconGlowType == 3 then
		glowStart, glowStop = LCG.PixelGlow_Start, LCG.PixelGlow_Stop
	elseif LCG and iconGlowType == 4 then
		glowStart, glowStop = ExRT.NULLfunc, ExRT.NULLfunc
	elseif not LCG then
		glowStart, glowStop = IconGlowNoLibStart, IconGlowNoLibStop
	end
	if ExRT.is10 then glowStart,glowStop=nil end	--!!!!!!!!! ALERT THIS IS TEMP
	columnFrame.glowStart = glowStart or ExRT.NULLfunc
	columnFrame.glowStop = glowStop or ExRT.NULLfunc

	columnFrame.methodsIconTooltip = (not currColOpt.methodsGeneral and currColOpt.methodsIconTooltip) or (currColOpt.methodsGeneral and generalOpt.methodsIconTooltip) 
	columnFrame.methodsLineClick = (not currColOpt.methodsGeneral and currColOpt.methodsLineClick) or (currColOpt.methodsGeneral and generalOpt.methodsLineClick)
	columnFrame.methodsLineClickWhisper = (not currColOpt.methodsGeneral and currColOpt.methodsLineClickWhisper) or (currColOpt.methodsGeneral and generalOpt.methodsLineClickWhisper)
	columnFrame.methodsNewSpellNewLine = (not currColOpt.methodsGeneral and currColOpt.methodsNewSpellNewLine) or (currColOpt.methodsGeneral and generalOpt.methodsNewSpellNewLine)
	columnFrame.methodsSortingRules = (not currColOpt.methodsGeneral and currColOpt.methodsSortingRules) or (currColOpt.methodsGeneral and generalOpt.methodsSortingRules) or defOpt.methodsSortingRules
	columnFrame.methodsHideOwnSpells = (not currColOpt.methodsGeneral and currColOpt.methodsHideOwnSpells) or (currColOpt.methodsGeneral and generalOpt.methodsHideOwnSpells)
	columnFrame.methodsAlphaNotInRange = (not currColOpt.methodsGeneral and currColOpt.methodsAlphaNotInRange) or (currColOpt.methodsGeneral and generalOpt.methodsAlphaNotInRange)
	columnFrame.methodsAlphaNotInRangeNum = (not currColOpt.methodsGeneral and currColOpt.methodsAlphaNotInRangeNum) or (currColOpt.methodsGeneral and generalOpt.methodsAlphaNotInRangeNum) or defOpt.methodsAlphaNotInRangeNum
		columnFrame.methodsAlphaNotInRangeNum = columnFrame.methodsAlphaNotInRangeNum / 100
	columnFrame.methodsDisableActive = (not currColOpt.methodsGeneral and currColOpt.methodsDisableActive) or (currColOpt.methodsGeneral and generalOpt.methodsDisableActive)
	columnFrame.methodsOneSpellPerCol = (not currColOpt.methodsGeneral and currColOpt.methodsOneSpellPerCol) or (currColOpt.methodsGeneral and generalOpt.methodsOneSpellPerCol)

	columnFrame.methodsSortByAvailability = (not currColOpt.methodsGeneral and currColOpt.methodsSortByAvailability) or (currColOpt.methodsGeneral and generalOpt.methodsSortByAvailability)
	columnFrame.methodsSortActiveToTop = (not currColOpt.methodsGeneral and currColOpt.methodsSortActiveToTop) or (currColOpt.methodsGeneral and generalOpt.methodsSortActiveToTop)
	columnFrame.methodsReverseSorting = (not currColOpt.methodsGeneral and currColOpt.methodsReverseSorting) or (currColOpt.methodsGeneral and generalOpt.methodsReverseSorting)
	columnFrame.methodsReverseSorting = (not currColOpt.methodsGeneral and currColOpt.methodsReverseSorting) or (currColOpt.methodsGeneral and generalOpt.methodsReverseSorting)
	columnFrame.methodsCDOnlyTime = (not currColOpt.methodsGeneral and currColOpt.methodsCDOnlyTime) or (currColOpt.methodsGeneral and generalOpt.methodsCDOnlyTime)
	columnFrame.methodsTextIgnoreActive = (not currColOpt.methodsGeneral and currColOpt.methodsTextIgnoreActive) or (currColOpt.methodsGeneral and generalOpt.methodsTextIgnoreActive)
	columnFrame.methodsOnlyNotOnCD = (not currColOpt.methodsGeneral and currColOpt.methodsOnlyNotOnCD) or (currColOpt.methodsGeneral and generalOpt.methodsOnlyNotOnCD)

	columnFrame.methodsOnlyInCombat = (not currColOpt.visibilityGeneral and currColOpt.methodsOnlyInCombat) or (currColOpt.visibilityGeneral and generalOpt.methodsOnlyInCombat)
	columnFrame.visibilityPartyType = (not currColOpt.visibilityGeneral and currColOpt.visibilityPartyType) or (currColOpt.visibilityGeneral and generalOpt.visibilityPartyType)
	columnFrame.visibilityArena = not ( (not currColOpt.visibilityGeneral and currColOpt.visibilityDisableArena) or (currColOpt.visibilityGeneral and generalOpt.visibilityDisableArena) )
	columnFrame.visibilityBG = not ( (not currColOpt.visibilityGeneral and currColOpt.visibilityDisableBG) or (currColOpt.visibilityGeneral and generalOpt.visibilityDisableBG) )
	columnFrame.visibility3ppl = not ( (not currColOpt.visibilityGeneral and currColOpt.visibilityDisable3ppl) or (currColOpt.visibilityGeneral and generalOpt.visibilityDisable3ppl) )
	columnFrame.visibility5ppl = not ( (not currColOpt.visibilityGeneral and currColOpt.visibilityDisable5ppl) or (currColOpt.visibilityGeneral and generalOpt.visibilityDisable5ppl) )
	columnFrame.visibilityRaid = not ( (not currColOpt.visibilityGeneral and currColOpt.visibilityDisableRaid) or (currColOpt.visibilityGeneral and generalOpt.visibilityDisableRaid) )
	columnFrame.visibilityWorld = not ( (not currColOpt.visibilityGeneral and currColOpt.visibilityDisableWorld) or (currColOpt.visibilityGeneral and generalOpt.visibilityDisableWorld) )

	columnFrame.textTemplateLeft = (not currColOpt.textGeneral and currColOpt.textTemplateLeft) or (currColOpt.textGeneral and generalOpt.textTemplateLeft) or defOpt.textTemplateLeft
	columnFrame.textTemplateRight = (not currColOpt.textGeneral and currColOpt.textTemplateRight) or (currColOpt.textGeneral and generalOpt.textTemplateRight) or defOpt.textTemplateRight
	columnFrame.textTemplateCenter = (not currColOpt.textGeneral and currColOpt.textTemplateCenter) or (currColOpt.textGeneral and generalOpt.textTemplateCenter) or defOpt.textTemplateCenter

	columnFrame.textIconNameChars = (not currColOpt.textGeneral and currColOpt.textIconNameChars) or (currColOpt.textGeneral and generalOpt.textIconNameChars) or defOpt.textIconNameChars
	columnFrame.textIconCDStyle = (not currColOpt.textGeneral and currColOpt.textIconCDStyle) or (currColOpt.textGeneral and generalOpt.textIconCDStyle) or defOpt.textIconCDStyle

	local blacklistText = (not currColOpt.blacklistGeneral and currColOpt.blacklistText) or (currColOpt.blacklistGeneral and generalOpt.blacklistText) or defOpt.blacklistText
	columnFrame.BlackList = CreateBlackList(blacklistText)
	local whitelistText = (not currColOpt.blacklistGeneral and currColOpt.whitelistText) or (currColOpt.blacklistGeneral and generalOpt.whitelistText) or defOpt.whitelistText
	columnFrame.WhiteList = CreateWhiteList(whitelistText)

	local frameWidth = (not currColOpt.frameGeneral and currColOpt.frameWidth) or (currColOpt.frameGeneral and generalOpt.frameWidth) or defOpt.frameWidth
	columnFrame:SetWidth(frameWidth*frameColumns)
	columnFrame.barWidth = frameWidth

	columnFrame.optionGray = (not currColOpt.iconGeneral and currColOpt.iconGray) or (currColOpt.iconGeneral and generalOpt.iconGray)
	columnFrame.fontSize = (not currColOpt.fontGeneral and currColOpt.fontSize) or (currColOpt.fontGeneral and generalOpt.fontSize) or defOpt.fontSize
	columnFrame.fontName = (not currColOpt.fontGeneral and currColOpt.fontName) or (currColOpt.fontGeneral and generalOpt.fontName) or defOpt.fontName
	columnFrame.fontOutline = (not currColOpt.fontGeneral and currColOpt.fontOutline) or (currColOpt.fontGeneral and generalOpt.fontOutline)
	columnFrame.fontShadow = (not currColOpt.fontGeneral and currColOpt.fontShadow) or (currColOpt.fontGeneral and generalOpt.fontShadow)
	columnFrame.textureFile = (not currColOpt.textureGeneral and currColOpt.textureFile) or (currColOpt.textureGeneral and generalOpt.textureFile) or defOpt.textureFile
	columnFrame.textureBorderSize = (not currColOpt.textureGeneral and currColOpt.textureBorderSize) or (currColOpt.textureGeneral and generalOpt.textureBorderSize) or defOpt.textureBorderSize

	columnFrame.textureBorderColorR = (not currColOpt.textureGeneral and currColOpt.textureBorderColorR) or (currColOpt.textureGeneral and generalOpt.textureBorderColorR) or defOpt.textureBorderColorR
	columnFrame.textureBorderColorG = (not currColOpt.textureGeneral and currColOpt.textureBorderColorG) or (currColOpt.textureGeneral and generalOpt.textureBorderColorG) or defOpt.textureBorderColorG
	columnFrame.textureBorderColorB = (not currColOpt.textureGeneral and currColOpt.textureBorderColorB) or (currColOpt.textureGeneral and generalOpt.textureBorderColorB) or defOpt.textureBorderColorB
	columnFrame.textureBorderColorA = (not currColOpt.textureGeneral and currColOpt.textureBorderColorA) or (currColOpt.textureGeneral and generalOpt.textureBorderColorA) or defOpt.textureBorderColorA

	local fontOtherAvailable = (not currColOpt.fontGeneral and currColOpt.fontOtherAvailable) or (currColOpt.fontGeneral and generalOpt.fontOtherAvailable)

	local fontOpts = (not currColOpt.fontGeneral and currColOpt) or (currColOpt.fontGeneral and generalOpt)

	columnFrame.fontLeftSize = (not fontOtherAvailable and fontOpts.fontSize) or (fontOtherAvailable and fontOpts.fontLeftSize) or defOpt.fontSize
	columnFrame.fontLeftName = (not fontOtherAvailable and fontOpts.fontName) or (fontOtherAvailable and fontOpts.fontLeftName) or defOpt.fontName
	columnFrame.fontLeftOutline = (not fontOtherAvailable and fontOpts.fontOutline) or (fontOtherAvailable and fontOpts.fontLeftOutline)
	columnFrame.fontLeftShadow = (not fontOtherAvailable and fontOpts.fontShadow) or (fontOtherAvailable and fontOpts.fontLeftShadow)

	columnFrame.fontRightSize = (not fontOtherAvailable and fontOpts.fontSize) or (fontOtherAvailable and fontOpts.fontRightSize) or defOpt.fontSize
	columnFrame.fontRightName = (not fontOtherAvailable and fontOpts.fontName) or (fontOtherAvailable and fontOpts.fontRightName) or defOpt.fontName
	columnFrame.fontRightOutline = (not fontOtherAvailable and fontOpts.fontOutline) or (fontOtherAvailable and fontOpts.fontRightOutline)
	columnFrame.fontRightShadow = (not fontOtherAvailable and fontOpts.fontShadow) or (fontOtherAvailable and fontOpts.fontRightShadow)

	columnFrame.fontCenterSize = (not fontOtherAvailable and fontOpts.fontSize) or (fontOtherAvailable and fontOpts.fontCenterSize) or defOpt.fontSize
	columnFrame.fontCenterName = (not fontOtherAvailable and fontOpts.fontName) or (fontOtherAvailable and fontOpts.fontCenterName) or defOpt.fontName
	columnFrame.fontCenterOutline = (not fontOtherAvailable and fontOpts.fontOutline) or (fontOtherAvailable and fontOpts.fontCenterOutline)
	columnFrame.fontCenterShadow = (not fontOtherAvailable and fontOpts.fontShadow) or (fontOtherAvailable and fontOpts.fontCenterShadow)

	columnFrame.fontIconSize = (not fontOtherAvailable and fontOpts.fontSize) or (fontOtherAvailable and fontOpts.fontIconSize) or defOpt.fontSize
	columnFrame.fontIconName = (not fontOtherAvailable and fontOpts.fontName) or (fontOtherAvailable and fontOpts.fontIconName) or defOpt.fontName
	columnFrame.fontIconOutline = (not fontOtherAvailable and fontOpts.fontOutline) or (fontOtherAvailable and fontOpts.fontIconOutline)
	columnFrame.fontIconShadow = (not fontOtherAvailable and fontOpts.fontShadow) or (fontOtherAvailable and fontOpts.fontIconShadow)

	columnFrame.fontIconCDSize = (not fontOtherAvailable and fontOpts.fontSize) or (fontOtherAvailable and fontOpts.fontIconCDSize) or defOpt.fontSize
	columnFrame.fontIconCDName = (not fontOtherAvailable and fontOpts.fontName) or (fontOtherAvailable and fontOpts.fontIconCDName) or defOpt.fontName
	columnFrame.fontIconCDOutline = (not fontOtherAvailable and fontOpts.fontOutline) or (fontOtherAvailable and fontOpts.fontIconCDOutline)
	columnFrame.fontIconCDShadow = (not fontOtherAvailable and fontOpts.fontShadow) or (fontOtherAvailable and fontOpts.fontIconCDShadow)

	columnFrame.fontCDSize = (not currColOpt.fontGeneral and currColOpt.fontCDSize) or (currColOpt.fontGeneral and generalOpt.fontCDSize) or defOpt.fontCDSize

	for j=1,3 do
		for n=1,3 do
			local object = colorSetupFrameColorsObjectsNames[j]
			local state = colorSetupFrameColorsNames[n]
			if not columnFrame["optionColor"..object..state] then
				columnFrame["optionColor"..object..state] = {}
			end

			columnFrame["optionColor"..object..state].r = (not currColOpt.textureGeneral and currColOpt["textureColor"..object..state.."R"]) or (currColOpt.textureGeneral and generalOpt["textureColor"..object..state.."R"]) or defOpt["textureColor"..object..state.."R"]
			columnFrame["optionColor"..object..state].g = (not currColOpt.textureGeneral and currColOpt["textureColor"..object..state.."G"]) or (currColOpt.textureGeneral and generalOpt["textureColor"..object..state.."G"]) or defOpt["textureColor"..object..state.."G"]
			columnFrame["optionColor"..object..state].b = (not currColOpt.textureGeneral and currColOpt["textureColor"..object..state.."B"]) or (currColOpt.textureGeneral and generalOpt["textureColor"..object..state.."B"]) or defOpt["textureColor"..object..state.."B"]
		end
	end

	columnFrame.optionAlphaBackground = (not currColOpt.textureGeneral and currColOpt.textureAlphaBackground) or (currColOpt.textureGeneral and generalOpt.textureAlphaBackground) or defOpt.textureAlphaBackground
	columnFrame.optionAlphaTimeLine = (not currColOpt.textureGeneral and currColOpt.textureAlphaTimeLine) or (currColOpt.textureGeneral and generalOpt.textureAlphaTimeLine) or defOpt.textureAlphaTimeLine
	columnFrame.optionAlphaCooldown = (not currColOpt.textureGeneral and currColOpt.textureAlphaCooldown) or (currColOpt.textureGeneral and generalOpt.textureAlphaCooldown) or defOpt.textureAlphaCooldown

	columnFrame.ATFenabled = currColOpt.ATF

	if currColOpt.ATF then
		local ATFPos = currColOpt.ATFPos
		local ATFGrowth = currColOpt.ATFGrowth or defOpt.ATFGrowth
		local ATFPoint1,ATFPoint2 = "BOTTOMRIGHT", "BOTTOMLEFT"
		local ATFPointCol1,ATFPointCol2 = "LEFT", "RIGHT"
		local ATFPointLine1,ATFPointLine2 = "BOTTOM", "TOP"
		local ATFBetweenLinesCol, ATFBetweenLinesLine = -frameBetweenLines, frameBetweenLines
		if ATFPos == 1 then
			ATFPoint1,ATFPoint2 = "BOTTOMRIGHT", "BOTTOMLEFT"
			ATFPointCol1,ATFPointCol2 = "RIGHT", "LEFT"
			ATFPointLine1,ATFPointLine2 = "BOTTOM", "TOP"
			ATFBetweenLinesCol, ATFBetweenLinesLine = -frameBetweenLines, frameBetweenLines
		elseif ATFPos == 2 then
			ATFPoint1,ATFPoint2 = "TOPRIGHT", "TOPLEFT"
			ATFPointCol1,ATFPointCol2 = "RIGHT", "LEFT"
			ATFPointLine1,ATFPointLine2 = "TOP", "BOTTOM"
			ATFBetweenLinesCol, ATFBetweenLinesLine = -frameBetweenLines, -frameBetweenLines
		elseif ATFPos == 3 then
			ATFPoint1,ATFPoint2 = "BOTTOMLEFT", "TOPLEFT"
			ATFPointCol1,ATFPointCol2 = "LEFT", "RIGHT"
			ATFPointLine1,ATFPointLine2 = "BOTTOM", "TOP"
			ATFBetweenLinesCol, ATFBetweenLinesLine = frameBetweenLines, frameBetweenLines
		elseif ATFPos == 4 then
			ATFPoint1,ATFPoint2 = "BOTTOMRIGHT", "TOPRIGHT"
			ATFPointCol1,ATFPointCol2 = "RIGHT", "LEFT"
			ATFPointLine1,ATFPointLine2 = "BOTTOM", "TOP"
			ATFBetweenLinesCol, ATFBetweenLinesLine = -frameBetweenLines, frameBetweenLines
		elseif ATFPos == 5 then
			ATFPoint1,ATFPoint2 = "TOPLEFT", "TOPRIGHT"
			ATFPointCol1,ATFPointCol2 = "LEFT", "RIGHT"
			ATFPointLine1,ATFPointLine2 = "TOP", "BOTTOM"
			ATFBetweenLinesCol, ATFBetweenLinesLine = frameBetweenLines, -frameBetweenLines
		elseif ATFPos == 6 then
			ATFPoint1,ATFPoint2 = "BOTTOMLEFT", "BOTTOMRIGHT"
			ATFPointCol1,ATFPointCol2 = "LEFT", "RIGHT"
			ATFPointLine1,ATFPointLine2 = "TOP", "BOTTOM"
			ATFBetweenLinesCol, ATFBetweenLinesLine = frameBetweenLines, frameBetweenLines
		elseif ATFPos == 7 then
			ATFPoint1,ATFPoint2 = "TOPRIGHT", "BOTTOMRIGHT"
			ATFPointCol1,ATFPointCol2 = "RIGHT", "LEFT"
			ATFPointLine1,ATFPointLine2 = "TOP", "BOTTOM"
			ATFBetweenLinesCol, ATFBetweenLinesLine = -frameBetweenLines, -frameBetweenLines
		elseif ATFPos == 8 then
			ATFPoint1,ATFPoint2 = "TOPLEFT", "BOTTOMLEFT"
			ATFPointCol1,ATFPointCol2 = "LEFT", "RIGHT"
			ATFPointLine1,ATFPointLine2 = "TOP", "BOTTOM"
			ATFBetweenLinesCol, ATFBetweenLinesLine = frameBetweenLines, frameBetweenLines
		elseif ATFPos == 9 then
			ATFPoint1,ATFPoint2 = "CENTER", "CENTER"
			ATFPointCol1,ATFPointCol2 = "LEFT", "RIGHT"
			ATFPointLine1,ATFPointLine2 = "TOP", "BOTTOM"
			ATFBetweenLinesCol, ATFBetweenLinesLine = frameBetweenLines, -frameBetweenLines
		end
		if ATFGrowth == 2 then
			ATFPointCol1,ATFPointCol2,ATFPointLine1,ATFPointLine2 = ATFPointLine1,ATFPointLine2,ATFPointCol1,ATFPointCol2
		end
		columnFrame.ATFPoint1 = ATFPoint1
		columnFrame.ATFPoint2 = ATFPoint2
		columnFrame.ATFPointCol1 = ATFPointCol1
		columnFrame.ATFPointCol2 = ATFPointCol2
		columnFrame.ATFPointLine1 = ATFPointLine1
		columnFrame.ATFPointLine2 = ATFPointLine2
		columnFrame.ATFBetweenLinesCol = ATFBetweenLinesCol
		columnFrame.ATFBetweenLinesLine = ATFBetweenLinesLine

		columnFrame.ATFCol = ATFGrowth == 2 and (currColOpt.ATFLines or defOpt.ATFLines) or (currColOpt.ATFCol or defOpt.ATFCol)
		columnFrame.ATFMax = (currColOpt.ATFLines or defOpt.ATFLines) * (currColOpt.ATFCol or defOpt.ATFCol)

		columnFrame.ATFOffsetX = currColOpt.ATFOffsetX or defOpt.ATFOffsetX
		columnFrame.ATFOffsetY = currColOpt.ATFOffsetY or defOpt.ATFOffsetY

		columnFrame.ATFGrowth = ATFGrowth

		local framePriorOpt
		if currColOpt.ATFFramePrior then
			local new = ExRT.F.table_find3(module.db.rframes, currColOpt.ATFFramePrior, "name")
			if new then
				new = new.opts

				framePriorOpt = ExRT.F.table_copy2(module.db.rframes_def)

				for j=#new,1,-1 do
					tinsert(framePriorOpt,1,new[j])
				end

				framePriorOpt = {
					framePriorities = framePriorOpt,
				}
			end
		end
		columnFrame.ATFFramePrior = framePriorOpt

		--rewrite something for fix
		columnFrame.optionCooldown = true
		columnFrame.optionHideSpark = true
		columnFrame.iconSize = currColOpt.iconSize or defOpt.iconSize
		columnFrame.barWidth = columnFrame.iconSize + 0.001

		columnFrame.textTemplateLeft = ""
		columnFrame.textTemplateRight = ""
		columnFrame.textTemplateCenter = ""

		columnFrame.optionIconTitles = false
		columnFrame.optionTimeLineAnimation = 1
		columnFrame.methodsNewSpellNewLine = false

		columnFrame.texture:SetColorTexture(0,0,0,0)
	end

	local isMasqueEnabled = (not currColOpt.iconGeneral and currColOpt.iconMasque) or (currColOpt.iconGeneral and generalOpt.iconMasque)
	if isMasqueEnabled and module.db.Masque then
		if not columnFrame.Masque_Group then
			columnFrame.Masque_Group = module.db.Masque:Group("MRT", "Raid cooldowns Col "..columnFrame.colNum)
		end
	elseif columnFrame.Masque_Group then
		columnFrame.Masque_Group:Delete()
		columnFrame.Masque_Group = nil
	end

	if currColOpt.enabled then
		for n=1,#columnFrame.lines do
			local line = columnFrame.lines[n]
			line:UpdateStyle()
			if line:IsShown() then
				line:UpdateStatus()
			end
		end

		local frameAnchorBottom = (not currColOpt.methodsGeneral and currColOpt.frameAnchorBottom) or (currColOpt.methodsGeneral and generalOpt.frameAnchorBottom)
		local frameAnchorRightToLeft = (not currColOpt.methodsGeneral and currColOpt.frameAnchorRightToLeft) or (currColOpt.methodsGeneral and generalOpt.frameAnchorRightToLeft)

		local lastLine = nil
		for n=1,linesTotal do 
			local line
			local colLine = columnFrame.lines[n]
			if columnFrame.ATFenabled then
				line = 1
			elseif frameAnchorBottom then
				local inLine = (n-1) % frameColumns
				line = ((n-1) - inLine) / frameColumns
				colLine:ClearAllPoints()
				if frameAnchorRightToLeft then
					colLine:SetPoint("BOTTOMRIGHT", -inLine*frameWidth, line*columnFrame.iconSize+line*frameBetweenLines) 
				else
					colLine:SetPoint("BOTTOMLEFT", inLine*frameWidth, line*columnFrame.iconSize+line*frameBetweenLines) 
				end
				colLine.ATFanchored = nil
			else
				local inLine = (n-1) % frameColumns
				line = ExRT.F.Round( ((n-1) - inLine) / frameColumns )
				colLine:ClearAllPoints()
				if frameAnchorRightToLeft then
					colLine:SetPoint("TOPRIGHT", -inLine*frameWidth, -line*columnFrame.iconSize-line*frameBetweenLines) 
				else
					colLine:SetPoint("TOPLEFT", inLine*frameWidth, -line*columnFrame.iconSize-line*frameBetweenLines) 
				end
				colLine.ATFanchored = nil
			end

			if line ~= lastLine then
				colLine.IsNewLine = true
			else
				colLine.IsNewLine = nil
			end
			lastLine = line
		end

		if columnFrame.Masque_Group then
			columnFrame.Masque_Group:ReSkin(true)
		end
	end

	if currColOpt.enabled and VMRT.ExCD2.enabled then
		columnFrame.optionIsEnabled = true
		columnFrame:Show()
	else
		columnFrame.optionIsEnabled = nil
		columnFrame:Hide()
	end
	if currColOpt.ATF then
		columnFrame:ClearAllPoints()
		columnFrame:SetPoint("LEFT",UIParent,"RIGHT",-2000, 0)
	elseif not VMRT.ExCD2.SplitOpt and mainWidth then
		columnFrame:ClearAllPoints()
		columnFrame:SetPoint("TOPLEFT",module.frame,mainWidth, 0)
	else
		if currColOpt.posX and currColOpt.posY then
			columnFrame:ClearAllPoints()
			columnFrame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",currColOpt.posX,currColOpt.posY)
		else
			columnFrame:ClearAllPoints()
			columnFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
		end
	end

	columnFrame.Gwidth = frameWidth*frameColumns
end

do	--unsafe check
	local Masque, MSQ_Version = LibStub("Masque", true)
	if Masque then
		module.db.Masque = Masque
	end
end

local lastSplitsReload = 0
function module:ReloadAllSplits(argScaleFix)
	local _ctime = GetTime()
	if lastSplitsReload > _ctime then
		return
	end
	lastSplitsReload = _ctime + 0.05
	local Width = 0
	local maxHeight = 0

	local generalOpt = VMRT.ExCD2.colSet[module.db.maxColumns+1]
	local defOpt = module.db.colsDefaults
	for i=1,module.db.maxColumns do 
		local columnFrame = module.frame.colFrame[i]
		local currColOpt = VMRT.ExCD2.colSet[i]

		module:ColApplyStyle(columnFrame,currColOpt,generalOpt,defOpt,Width,argScaleFix)

		if currColOpt.enabled and not currColOpt.ATF then
			if columnFrame.Gheight > maxHeight then
				maxHeight = columnFrame.Gheight
			end
			Width = Width + columnFrame.Gwidth
		end
	end
	module.frame:SetWidth(Width)
	module.frame:SetHeight(maxHeight)
	module.frame:SetAlpha((generalOpt.frameAlpha or defOpt.frameAlpha)/100)
	if argScaleFix == "ScaleFix" then
		ExRT.F.SetScaleFix(module.frame,(generalOpt.frameScale or defOpt.frameScale)/100)
	else
		module.frame:SetScale((generalOpt.frameScale or defOpt.frameScale)/100) 
	end
	module.frame:SetFrameStrata(generalOpt.frameStrata or defOpt.frameStrata)

	module:updateCombatVisibility()

	module:ATFFrameDataReset()

 	UpdateAllData()
end

function module:SplitExCD2Window()
	if VMRT.ExCD2.SplitOpt then
		for i=1,module.db.maxColumns do 
			module.frame.colFrame[i]:SetParent(UIParent)
			module.frame.colFrame[i]:EnableMouse(false)
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

function module:UpdateLockState()
	if VMRT.ExCD2.lock then
		ExRT.F.LockMove(module.frame,nil,module.frame.texture)
		ExRT.lib.AddShadowComment(module.frame,1)
		if VMRT.ExCD2.SplitOpt then 
			for i=1,module.db.maxColumns do 
				ExRT.F.LockMove(module.frame.colFrame[i],nil,module.frame.colFrame[i].lockTexture)
				ExRT.lib.AddShadowComment(module.frame.colFrame[i],1)
			end 
		end
	else
		ExRT.F.LockMove(module.frame,true,module.frame.texture)
		ExRT.lib.AddShadowComment(module.frame,nil,L.cd2)
		if VMRT.ExCD2.SplitOpt then 
			for i=1,module.db.maxColumns do 
				ExRT.F.LockMove(module.frame.colFrame[i],true,module.frame.colFrame[i].lockTexture)
				ExRT.lib.AddShadowComment(module.frame.colFrame[i],nil,L.cd2,i,72,"OUTLINE")
			end 
		end
	end
end

function module:slash(arg1,arg2)
	if string.find(arg1,"runcd ") then
		local sid,name = arg2:match("%a+ (%d+) (.+)")
		if sid and name then
			print("Run CD "..sid.." by "..name)
			sid = tonumber(sid)
			local line = module.db.cdsNav[name][sid]
			if line then
				CLEUstartCD(line)
			end
		end
	elseif string.find(arg1,"resetcd ") then
		local sid,name = arg2:match("%a+ (%d+) (.+)")
		if sid and name then
			print("Reset CD "..sid.." by "..name)
			sid = tonumber(sid)
			local j = module.db.cdsNav[name][sid]
			if j then
				j:SetCD(0)
			end
		end
	elseif arg1 == "cd" then
		if not VMRT.ExCD2.enabled then
			module:Enable()
		else
			module:Disable()
		end
		if module.options.chkEnable then
			module.options.chkEnable:SetChecked(VMRT.ExCD2.enabled)
		end
	end
end

--{id,	"class,cat1,cat2",	col	all specs,		spec1,			spec2={spellid,cd,duration},spec3,spec4		},	--name
module.db.AllSpells = {
	{107574,"WARRIOR,DPS",3,--Аватара
		{107574,90,20},
		isTalent=true,cdDiff={296320,"*0.80"},reduceCdAfterCast={{1715,152278,73},-1,{330334,152278,73},-3,{2565,152278,73},-3,{190456,152278,73},-4,{1680,152278,73},-3,{163201,152278,73},-3}},
	{6673,	"WARRIOR",1,--Боевой крик
		{6673,15,0},nil,nil,nil},
	{18499,	"WARRIOR,DEF",4,--Ярость берсерка
		{18499,60,6},nil,nil,nil,
		isTalent=true},
	{227847,"WARRIOR,DPS",3,--Вихрь клинков
		nil,{227847,90,6},nil,nil,
		isTalent=true,cdDiff={296320,"*0.80",236308,"*0.67"},hideWithTalent=152277,reduceCdAfterCast={{1715,152278,71},-0.5,{1464,152278,71},-1,{330334,152278,71},-1.5,{2565,152278,71},-1.5,{12294,152278,71},-1.5,{190456,152278,71},-2,{1680,152278,71},-1.5,{163201,152278,71},-1.5}},
	{1161,	"WARRIOR,TAUNT",5,--Вызывающий крик
		nil,nil,nil,{1161,120,0},
		isTalent=true},
	{100,	"WARRIOR",3,--Рывок
		{100,20,0},nil,nil,nil,
		hasCharges=103827,cdDiff={103827,-3}},
	{167105,"WARRIOR",3,--Удар колосса
		nil,{167105,45,10},nil,nil,
		isTalent=true,hideWithTalent=262161,reduceCdAfterCast={{1715,152278,71},-0.5,{1464,152278,71},-1,{330334,152278,71},-1.5,{2565,152278,71},-1.5,{12294,152278,71},-1.5,{190456,152278,71},-2,{1680,152278,71},-1.5,{163201,152278,71},-1.5},increaseDurAfterCast={{317349,354131},1.5}},
	{1160,	"WARRIOR,DEFTANK",4,--Деморализующий крик
		nil,nil,nil,{1160,45,8},
		isTalent=true,cdDiff={199023,-15},
		CLEU_PREP = [[
			spell335229_var = {}
		]],CLEU_SPELL_DAMAGE=[[
			if spellID == 6343 and session_gGUIDs[sourceName][335229] then
				local sourceData = spell335229_var[sourceName]
				if not sourceData then
					sourceData = {0,0}
					spell335229_var[sourceName] = sourceData
				end
				local t=GetTime()
				if (t - sourceData[1]) > 2 then
					sourceData[1] = t
					sourceData[2] = 0
				end
				sourceData[2] = sourceData[2] + 1
				if sourceData[2] <= 3 then
					local line = CDList[sourceName][1160]
					if line then
						line:ReduceCD(1.5)
					end
				end
			end
		]]},
	{376079,"WARRIOR",3,--Копье Бастиона
		{376079,90,4},
		isTalent=true,durationDiff={386285,2}},
	{384318,"WARRIOR",3,--Громогласный рык
		{384318,90,0},
		isTalent=true,cdDiff={391572,-30}},
	{118038,"WARRIOR,DEF",4,--Бой насмерть
		nil,{118038,120,8},nil,nil,
		isTalent=true,cdDiff={383338,{-15,-30},334993,{-20,-22,-24,-26,-28,-30,-32,-34,-36,-38,-40,-42,-44,-46,-48}}},
	{184364,"WARRIOR,DEF",4,--Безудержное восстановление
		nil,nil,{184364,120,8},nil,
		isTalent=true,cdDiff={334993,{-20,-22,-24,-26,-28,-30,-32,-34,-36,-38,-40,-42,-44,-46,-48}},durationDiff={383468,3}},
	{6544,	"WARRIOR,MOVE",4,--Героический прыжок
		{52174,45,0},nil,nil,nil,
		isTalent=true,hasCharges=335214,startCdAfterAuraFadeExt=280746,ignoreUseWithAura=375258,changeCdWithAura={381758,"*0.85"}},
	{57755,	"WARRIOR",3,--Героический бросок
		{57755,6,0},nil,nil,nil,
		isTalent=true},
	{3411,	"WARRIOR,DEFTAR",2,--Вмешательство
		{3411,30,6},nil,nil,nil,
		isTalent=true},
	{5246,	"WARRIOR,AOECC",1,--Устрашающий крик
		{5246,90,8},nil,nil,nil,
		isTalent=true,durationDiff={275338,7}},
	{12975,	"WARRIOR,DEFTANK",4,--Ни шагу назад
		nil,nil,nil,{12975,180,15},
		isTalent=true,cdDiff={280001,-60},increaseDurAfterCast={{317349,354131},3}},
	{12323,	"WARRIOR",3,--Пронзительный вой
		{12323,30,8},
		isTalent=true,cdDiff={339948,{-5,-6,-6,-7,-7,-8,-8,-9,-9,-10,-10,-11,-11,-12,-12}}},
	{384100,"WARRIOR,UTIL",3,--Крик берсерка
		{384100,60,8},
		isTalent=true},
	{6552,	"WARRIOR,KICK",5,--Зуботычина
		{6552,15,0},nil,nil,nil,
		cdDiff={383115,-1}},
	{97462,	"WARRIOR,RAID",1,--Ободряющий клич
		{97462,180,10},nil,nil,nil,
		isTalent=true,durationDiff={382310,3,335034,{"*1.20","*1.22","*1.24","*1.26","*1.28","*1.30","*1.32","*1.34","*1.36","*1.38","*1.40","*1.42","*1.44","*1.46","*1.48"}},cdDiff={235941,-120}},
	{1719,	"WARRIOR,DPS",3,--Безрассудство
		nil,nil,{1719,90,12},nil,
		isTalent=true,durationDiff={337162,{"*1.20","*1.215","*1.23","*1.245","*1.26","*1.275","*1.29","*1.305","*1.32","*1.335","*1.35","*1.365","*1.38","*1.395","*1.41"}},cdDiff={296320,"*0.80"},reduceCdAfterCast={{1715,152278,72},-0.5,{184367,152278,72},-4,{1464,152278,72},-1,{330334,152278,72},-1.5,{2565,152278,72},-1.5,{190456,152278,72},-3,{163201,152278,72},-1.5},increaseDurAfterCast={{317349,354131},1.5}},
	{385059,"WARRIOR,DPS",3,--Ярость Одина
		nil,nil,{385059,45,0},nil,
		isTalent=true},
	{64382,	"WARRIOR,UTIL",3,--Сокрушительный бросок
		{64382,180,0},nil,nil,nil,
		isTalent=true,cdDiff={329033,-120}},
	{384110,"WARRIOR",3,--Сокрушительный бросок
		{384110,45,0},nil,nil,nil,
		isTalent=true},
	{2565,	"WARRIOR",4,--Блок щитом
		{2565,16,0},nil,nil,nil,
		hasCharges=1,changeCdWithHaste=true,increaseDurAfterCast={{23922,203177},1}},
	{871,	"WARRIOR,DEFTANK",4,--Глухая оборона
		nil,nil,nil,{871,210,8},
		isTalent=true,cdDiff={334993,{-20,-22,-24,-26,-28,-30,-32,-34,-36,-38,-40,-42,-44,-46,-48}},reduceCdAfterCast={{1715,152278,73},-1,{23922,335239},-5,{330334,152278,73},-3,{2565,152278,73},-3,{190456,152278,73},-4,{1680,152278,73},-3,{163201,152278,73},-3}},
	{46968,	"WARRIOR,AOECC",1,--Ударная волна
		{46968,40,2},
		isTalent=true,cdDiff={339948,{-5,-6,-6,-7,-7,-8,-8,-9,-9,-10,-10,-11,-11,-12,-12}},
		CLEU_PREP=[[
			spell46968_var = {}
		]],CLEU_SPELL_DAMAGE=[[
			if spellID == 46968 and sourceName and session_gGUIDs[sourceName][275339] then
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
						line:ChangeCD(-15)
					end
				end
			end
		]]},
	{23920,	"WARRIOR,DEFTANK",4,--Отражение заклинаний
		{23920,25,0},nil,nil,nil,
		isTalent=true},
	{260708,"WARRIOR,DPS",3,--Размашистые удары
		nil,{260708,30,15},nil,nil},
	{355,	"WARRIOR,TAUNT",5,--Провокация
		{355,8,0},nil,nil,nil,
		hideWithTalent=205800},
	{46924,	"WARRIOR,DPS",3,--Вихрь клинков
		nil,nil,{46924,60,4},nil,
		isTalent=true},
	{262228,"WARRIOR,DPS",3,--Смертельное спокойствие
		nil,{262228,60,6},nil,nil,
		isTalent=true},
	{118000,"WARRIOR",3,--Рев дракона
		nil,nil,{118000,30,0},{118000,30,0},
		isTalent=true},
	{202168,"WARRIOR,DEF",3,--Верная победа
		{202168,30,0},nil,nil,nil,
		isTalent=true},
	{228920,"WARRIOR,DPS",3,--Опустошитель
		nil,nil,nil,{228920,45,10},
		isTalent=true},
	{152277,"WARRIOR,DPS",3,--Опустошитель
		nil,{152277,45,10},nil,nil,
		isTalent=true},
	{280772,"WARRIOR",3,--Прорыв блокады
		nil,nil,{280772,30,10},nil,
		isTalent=true},
	{260643,"WARRIOR",3,--Рассекатель черепов
		nil,{260643,30,0},nil,nil,
		isTalent=true,changeCdWithHaste=true},
	{107570,"WARRIOR,CC",3,--Удар громовержца
		{107570,30,0},nil,nil,nil,
		isTalent=true},
	{262161,"WARRIOR,DPS",3,--Миротворец
		nil,{262161,45,10},nil,nil,
		isTalent=true},
	{329038,"WARRIOR,PVP",3,--Кровавая ярость
		nil,nil,{329038,20,4},nil,
		isTalent=true},
	{213871,"WARRIOR,PVP",3,--Телохранитель
		nil,nil,nil,{213871,15,0},
		isTalent=true},
	{199261,"WARRIOR,PVP",3,--Инстинкт смерти
		nil,nil,{199261,5,0},nil,
		isTalent=true},
	{236077,"WARRIOR,PVP",3,--Обезоруживание
		{236077,45,6},nil,nil,nil,
		isTalent=true},
	{206572,"WARRIOR,PVP",3,--Рывок дракона
		nil,nil,nil,{206572,20,0},
		isTalent=true},
	{236273,"WARRIOR,PVP",3,--Дуэль
		nil,{236273,60,8},nil,nil,
		isTalent=true},
	{205800,"WARRIOR,PVP",3,--Угнетатель
		nil,nil,nil,{205800,20,0},
		isTalent=true},
	{198817,"WARRIOR,PVP",3,--Заточка клинка
		nil,{198817,25,0},nil,nil,
		isTalent=true},
	{198912,"WARRIOR,PVP",3,--Удар щитом
		nil,nil,nil,{198912,10,0},
		isTalent=true},
	{236320,"WARRIOR,PVP",3,--Боевое знамя
		nil,{236320,90,15},nil,nil,
		isTalent=true},


	{391054,"PALADIN,RES",1,--Заступничество
		{391054,600,0},nil,nil,nil,
		isBattleRes=true},
	{31850,	"PALADIN,DEFTANK",4,--Ревностный защитник
		nil,nil,{31850,120,8},nil,
		isTalent=true,cdDiff={114154,"*0.7"},reduceCdAfterCast={{53600,340023},{-1,-1.1,-1.2,-1.3,-1.4,-1.5,-1.6,-1.7,-1.8,-1.9,-2,-2.1,-2.2,-2.3,-2.4},{85673,385422},-3,{53600,385422},-3,{85256,385422},-3,{53385,385422},-3,{215661,385422},-3},increaseDurAfterCast={{53600,340023},2},changeCdAfterAuraFullDur={{31850,337838},"*0.6"}},
	{31821,	"PALADIN,RAID",1,--Владение аурами
		nil,{31821,180,8},nil,nil,
		isTalent=true,cdDiff={199324,-60,392911,-30}},
	{31935,	"PALADIN,KICK",3,--Щит мстителя
		nil,nil,{31935,15,0},nil,
		isTalent=true,changeCdWithHaste=true,
		CLEU_PREP=[[
			--avengershield_var = {} --hardcoded
		]],CLEU_SPELL_CAST_SUCCESS=[[
			if spellID == 53595 then	--Hammer of the Righteous
				avengershield_var[sourceGUID] = GetTime()
			elseif spellID == 204019 then	--Hammer of the Righteous
				avengershield_var[sourceGUID] = GetTime()
			elseif spellID == 31935 and session_gGUIDs[sourceName][337831] then	--Avenger's Shield
				avengershield_var[sourceGUID] = GetTime()
			end
		]],CLEU_SPELL_MISSED=[[
			if destGUID and isPaladin[destGUID] and destName and missType == "DODGE" then
				avengershield_var[destGUID] = GetTime()
			end
		]]
		},
	{31884,	"PALADIN,RAID,DPS",1,--Гнев карателя
		nil,{31884,120,20},{31884,120,20},{31884,120,20},
		durationDiff={231895,5,286229,5,53376,"*1.25"},cdDiff={296320,"*0.80"},sameSpell={31884,231895,389539},hideWithTalent={216331},icon="Interface\\Icons\\spell_holy_avenginewrath",reduceCdAfterCast={{53600,204074},{-1.5,-3},{85673,204074},{-1.5,-3},{53600,204074},{-1.5,-3},{85256,204074},{-1.5,-3},{53385,204074},{-1.5,-3},{215661,204074},{-1.5,-3}},increaseDurAfterCast={{24275,391142},1,{24275,337594},1,{24275,332806},3}},
	{1044,	"PALADIN,DEFTAR",2,--Благословенная свобода
		{1044,25,8},nil,nil,nil,
		isTalent=true,hasCharges=199454,reduceCdAfterCast={{85256,337600},-3,{85222,337600},-3,{85673,337600},-3,{53385,337600},-3,{152262,337600},-3,{53600,337600},-3}},
	{1022,	"PALADIN,DEFTAR",2,--Благословение защиты
		{1022,300,10},nil,nil,nil,
		isTalent=true,hasCharges=199454,cdDiff={384909,-60,216853,"*0.67",378425,"*0.8"},sameSpell={1022,204018},icon="Interface\\Icons\\spell_holy_sealofprotection",reduceCdAfterCast={{85256,337600},-3,{85222,337600},-3,{85673,337600},-3,{53385,337600},-3,{152262,337600},-3,{53600,337600},-3}},
	{6940,	"PALADIN,DEFTAR",2,--Жертвенное благословение
		{6940,120,12},nil,nil,nil,
		isTalent=true,cdDiff={216853,"*0.67",384820,-60},stopDurWithAuraFade=6940,reduceCdAfterCast={{85256,337600},-3,{85222,337600},-3,{85673,337600},-3,{53385,337600},-3,{152262,337600},-3,{53600,337600},-3}},
	{4987,	"PALADIN,DISPEL",5,--Очищение
		nil,{4987,8,0},nil,nil,
		isDispel=true},
	{213644,"PALADIN,DISPEL",5,--Очищение от токсинов
		nil,nil,{213644,8,0},{213644,8,0},
		isTalent=true,isDispel=true},
	{498,	"PALADIN,DEF",4,--Божественная защита
		nil,{498,60,8},nil,{498,60,8},
		cdDiff={114154,"*0.7"},icon=524353},
	{642,	"PALADIN,DEF",2,--Божественный щит
		{642,300,8},nil,nil,nil,
		cdDiff={114154,"*0.7",332542,"*0.4",378425,"*0.8"},stopDurWithAuraFade=642,reduceCdAfterCast={{85673,385422},-3,{53600,385422},-3,{85256,385422},-3,{53385,385422},-3,{215661,385422},-3},
		CLEU_PREP = [[
			spell338741_var = {}
		]],CLEU_SPELL_DAMAGE=[[
			if destGUID and isPaladin[destGUID] and destName and session_gGUIDs[destName][338741] then
				local now = GetTime()
				if not spell338741_var[destGUID] or (now > spell338741_var[destGUID]) then
					local soulbind_rank = _db.soulbind_rank[destName][338741] or SOULBIND_DEF_RANK_NOW
					spell338741_var[destGUID] = now + (50 - soulbind_rank * 2)
					local line = CDList[destName][642]
					if line then
						line:ReduceCD(5)
					end
				end
			end
		]]},
	{190784,"PALADIN,MOVE",4,--Божественный скакун
		{190784,45,3},nil,nil,nil,
		isTalent=true,hasCharges=230332,durationDiff={376996,1,335424,3,199542,2,339268,{"*1.50","*1.55","*1.60","*1.65","*1.70","*1.75","*1.80","*1.85","*1.90","*1.95","*2.00","*2.05","*2.10","*2.15","*2.20"}},ignoreUseWithAura=375253,changeCdWithAura={381752,"*0.85"}},
	{86659,	"PALADIN,DEFTANK",4,--Защитник древних королей
		nil,nil,{86659,300,8},nil,
		isTalent=true,cdDiff={340030,{-15,-16.5,-18,-19.5,-21,-22.5,-24,-25.5,-27,-28.5,-30,-31.5,-33,-34.5,-36}},hideWithTalent=228049,sameSpell={86659,212641},reduceCdAfterCast={{53600,204074},{-1.5,-3},{85673,204074},{-1.5,-3},{53600,204074},{-1.5,-3},{85256,204074},{-1.5,-3},{53385,204074},{-1.5,-3},{215661,204074},{-1.5,-3}},
		CLEU_SPELL_DAMAGE=[[
			if spellID == 31935 and session_gGUIDs[sourceName][378279] then
				local line = CDList[sourceName][86659]
				if line then
					local timeReduce = (_db.talent_classic_rank[sourceName][378279] or 2)*0.5
					line:ReduceCD(timeReduce)
				end
			end
		]]},
	{853,	"PALADIN",3,--Молот правосудия
		{853,60,6},nil,nil,nil,
		reduceCdAfterCast={{85673,234299},{-3,-6},{53600,234299},{-3,-6},{85256,234299},{-3,-6},{53385,234299},{-3,-6},{215661,234299},{-3,-6}}},
	{183218,"PALADIN",3,--Преграждающая длань
		nil,nil,nil,{183218,30,10},
		CLEU_PREP=[[
			handOfHind_var = {}
		]],CLEU_SPELL_AURA_REMOVED=[[
			if spellID == 183218 and destGUID then	--Hand of Hindrance pvp
				handOfHind_var[destGUID] = sourceName
			end
		]],CLEU_SPELL_DISPEL=[[
			if destSpell == 183218 and destGUID then
				local name = handOfHind_var[destGUID]
				if name and session_gGUIDs[name][204934] and module.IsPvpTalentsOn(name) then
					local line = CDList[name][183218]
					if line then
						line:ReduceCD(15)
					end
				end
			end
		]]},
	{62124,	"PALADIN,TAUNT",5,--Длань расплаты
		{62124,8,0},nil,nil,nil,
		hideWithTalent=207028},
	{20473,	"PALADIN",3,--Шок небес
		nil,{20473,7.5,0},nil,nil,
		cdDiff={332401,-1.5,53376,{"*0.5",31884}},changeCdWithHaste=true,reduceCdAfterCast={{35395,196926},-1}},
	{633,	"PALADIN,DEFTAR",2,--Возложение рук
		{633,600,0},nil,nil,nil,
		isTalent=true,cdDiff={114154,"*0.7",378425,"*0.8"},reduceCdAfterCast={{85673,392928},-3,{53600,392928},-3,{85256,392928},-3,{53385,392928},-3},
		CLEU_SPELL_HEAL=[[
			if spellID == 633 and session_gGUIDs[sourceName][326734] then
				local line = CDList[sourceName][633]
				if line then
					local maxHP = UnitHealthMax(destName) or 0
					if maxHP ~= 0 then
						local hpB4 = maxHP - (amount-overhealing)
						if hpB4 < 0 then
							hpB4 = 0
						end
						local val = 1 - hpB4 / maxHP
	
						line:SetCD((line.cd or 0) * (1 - val * 0.6))
					end
				end
			end
		]]},
	{96231,	"PALADIN,KICK",5,--Укор
		{96231,15,0},nil,nil,nil,
		isTalent=true},
	{184662,"PALADIN,DEF",4,--Щит возмездия
		nil,nil,nil,{184662,120,15},
		isTalent=true,cdDiff={114154,"*0.7"},stopDurWithAuraFade=184662},
	{10326,	"PALADIN,CC",3,--Изгнание зла
		{10326,15,40},nil,nil,nil,
		isTalent=true},
	{255937,"PALADIN,DPS",3,--Испепеляющий след
		nil,nil,nil,{255937,45,0},
		isTalent=true,hideWithTalent=384052},
	{383469,"PALADIN,DPS",3,--Светозарный указ
		nil,nil,nil,{383469,15,0},
		isTalent=true},
	{375576,"PALADIN,DPS",3,--Божественный благовест
		{375576,60,0},nil,nil,nil,
		isTalent=true,cdDiff={379391,-15}},
	{343527,"PALADIN,DPS",3,--Смертный приговор
		nil,nil,nil,{343527,60,8},
		isTalent=true,increaseDurAfterCast={{85256,384162},1}},
	{216331,"PALADIN,RAID",1,--Рыцарь-мститель
		nil,{216331,120,20},nil,nil,
		isTalent=true},
	{200025,"PALADIN",3,--Частица добродетели
		nil,{200025,15,8},nil,nil,
		isTalent=true},
	{223306,"PALADIN",3,--Дарование веры
		nil,{223306,12,5},nil,nil,
		isTalent=true},
	{148039,"PALADIN",3,--Барьер веры
		nil,{148039,25,0},nil,nil,
		isTalent=true},
	{200652,"PALADIN,HEAL",3,--Избавление Тира
		nil,{200652,90,10},nil,nil,
		isTalent=true,
		CLEU_SPELL_CAST_SUCCESS=[[
			if spellID == 19750 and session_gGUIDs[sourceName][392951] and IsAuraActive(destName,200654) then
				local line = CDList[destName][200652]
				if line then
					line:ChangeDur(2.5)
				end
			elseif spellID == 82326 and session_gGUIDs[sourceName][392951] and IsAuraActive(destName,200654) then
				local line = CDList[destName][200652]
				if line then
					line:ChangeDur(5)
				end
			end
		]]},
	{388007,"PALADIN",3,--Благословение лета
		nil,{388007,45,0},nil,nil,
		isTalent=true,sameSpell={388007,388010,388011,388013}},
	{204018,"PALADIN,DEFTAR",2,--Благословение защиты от заклинаний
		nil,nil,{204018,300,10},nil,
		isTalent=true,cdDiff={384909,-60,216853,"*0.67",378425,"*0.8"},sameSpell={1022,204018},reduceCdAfterCast={{85256,337600},-3,{85222,337600},-3,{85673,337600},-3,{53385,337600},-3,{152262,337600},-3,{53600,337600},-3}},
	{115750,"PALADIN",3,--Слепящий свет
		{115750,90,0},nil,nil,nil,
		isTalent=true},
	--{231895,"PALADIN,DPS",3,--Священная война
	--	nil,nil,nil,{231895,120,25},
	--	isTalent=true,increaseDurAfterCast={{24275,337594},1,{24275,332806},3}},
	{205191,"PALADIN",3,--Око за око
		nil,nil,nil,{205191,60,10},
		isTalent=true},
	{343721,"PALADIN",3,--Последний расчет
		nil,nil,nil,{343721,60,8},
		isTalent=true},
	{105809,"PALADIN,HEAL,DPS",3,--Святой каратель
		{105809,180,20},nil,nil,nil,
		isTalent=true},
	{114165,"PALADIN,HEAL",3,--Божественная призма
		nil,{114165,20,0},nil,nil,
		isTalent=true},
	{114158,"PALADIN,HEAL",3,--Молот Света
		nil,{114158,60,14},nil,nil,
		isTalent=true},
	{327193,"PALADIN,TANK",3,--Минута славы
		nil,nil,{327193,90,15},nil,
		isTalent=true},
	{387174,"PALADIN,TANK",3,--Око Тира
		nil,nil,{387174,60,9},nil,
		isTalent=true},
	{378974,"PALADIN",3,--Бастион Света
		nil,nil,{378974,120,0},nil,
		isTalent=true},
	{20066,	"PALADIN,CC",3,--Покаяние
		{20066,15,0},nil,nil,nil,
		isTalent=true},
	{152262,"PALADIN,DPS,HEAL",3,--Серафим
		{152262,45,15},nil,nil,nil,
		isTalent=true,cdDiff={379391,-5}},
	{210256,"PALADIN,PVP",3,--Благословение святилища
		nil,nil,nil,{210256,45,5},
		isTalent=true},
	{236186,"PALADIN,PVP",3,--Очищающий свет
		nil,nil,{236186,4,0},{236186,4,0},
		isTalent=true,isDispel=true},
	{210294,"PALADIN",3,--Божественное одобрение
		nil,{210294,45,0},nil,nil,
		isTalent=true},
	{228049,"PALADIN,PVP",3,--Страж забытой королевы
		nil,nil,{228049,180,10},nil,
		isTalent=true},
	{207028,"PALADIN,PVP",3,--Инквизиция
		nil,nil,{207028,20,0},nil,
		isTalent=true},
	{215652,"PALADIN,PVP",3,--Щит добродетели
		nil,nil,{215652,45,0},nil,
		isTalent=true},


	{186257,"HUNTER,MOVE",4,--Дух гепарда
		{186257,180,12},nil,nil,nil,
		durationDiff={339558,3},cdDiff={266921,{"*0.9","*0.8"},339558,{-16,-17,-18,-19,-20,-21,-22,-23,-24,-25,-26,-27,-28,-29,-30},336742,"*0.65",203235,"*0.5"},ignoreUseWithAura=375238,changeCdWithAura={381749,"*0.85"}},
	{186289,"HUNTER",3,--Дух орла
		nil,nil,nil,{186289,90,15},
		isTalent=true,cdDiff={266921,{"*0.9","*0.8"},336742,"*0.65"}},
	{186265,"HUNTER,DEF",4,--Дух черепахи
		{186265,180,8},nil,nil,nil,
		cdDiff={266921,{"*0.9","*0.8"},339377,{-10,-11.5,-13,-14.5,-16,-17.5,-19,-20.5,-23,-24.5,-26,-27.5,-29,-30.5,-32},336742,"*0.65"},stopDurWithAuraFade=186265,reduceCdAfterCast={{19434,248443},-5}},
	{193530,"HUNTER,DPS",3,--Дух дикой природы
		nil,{193530,120,20},nil,nil,
		isTalent=true,cdDiff={296320,"*0.80",336742,"*0.65"},
		CLEU_SPELL_DAMAGE=[[
			if spellID == 83381 and critical then
				local petOwner = ExRT.F.Pets:getOwnerNameByGUID(sourceGUID)
				if petOwner and session_gGUIDs[petOwner][339704] then
					local line = CDList[petOwner][193530]
					if line then
						local soulbind_rank = _db.soulbind_rank[petOwner][339704] or SOULBIND_DEF_RANK_NOW
						local timeReduce = 0.8 + soulbind_rank * 0.2

						line:ReduceCD(timeReduce)
					end
				end
			end
		]]},
	{359844,"HUNTER,DPS",3,--Зов дикой природы
		nil,{359844,180,20},nil,nil,
		isTalent=true},
	{392060,"HUNTER",3,--Стенающая стрела
		nil,{392060,60,0},nil,nil,
		isTalent=true},
	{19574,	"HUNTER,DPS",3,--Звериный гнев
		nil,{19574,90,15},nil,nil,
		isTalent=true,reduceCdAfterCast={{217200,231548},-12}},
	{186387,"HUNTER",3,--Взрывной выстрел
		nil,nil,{186387,30,0},nil,
		isTalent=true},
	{266779,"HUNTER,DPS",3,--Согласованная атака
		nil,nil,nil,{266779,120,20},
		isTalent=true,durationDiff={341350,{4,4.5,5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11}},cdDiff={296320,"*0.80",336742,"*0.65"}},
	{147362,"HUNTER,KICK",3,--Встречный выстрел
		nil,{147362,24,0},{147362,24,0},nil,
		isTalent=true},
	{781,	"HUNTER,DEF",4,--Отрыв
		{781,20,0},nil,nil,nil,
		CLEU_PREP=[[
			hunter_trap_var = {tar={},steel={},expl={}}
		]],CLEU_SPELL_AURA_APPLIED=[[
			if (spellID == 3355 or spellID == 135299 or spellID == 162487) and sourceName and session_gGUIDs[sourceName][346747] then	--Hunter traps
				local line = CDList[sourceName][781]
				if spellID == 135299 then
					if hunter_trap_var.tar[sourceName] then
						line = nil
					end
					hunter_trap_var.tar[sourceName] = true
				elseif spellID == 162487 then
					if hunter_trap_var.steel[sourceName] then
						line = nil
					end
					hunter_trap_var.steel[sourceName] = true
				end
				if line then
					local soulbind_rank = _db.soulbind_rank[sourceName][346747] or SOULBIND_DEF_RANK_NOW
					local timeReduce = 0.9 + 0.1 * soulbind_rank

					line:ReduceCD(timeReduce)
				end
			end
		]],CLEU_SPELL_CAST_SUCCESS=[[
			if spellID == 187698 then	--Tar Trap
				hunter_trap_var.tar[sourceName] = nil
			elseif spellID == 162488 then	--Steel Trap
				hunter_trap_var.steel[sourceName] = nil
			elseif spellID == 236776 then	--Expl Trap
				hunter_trap_var.expl[sourceName] = nil
			end
		]],CLEU_SPELL_DAMAGE=[[
			if spellID == 236777 and session_gGUIDs[sourceName][346747] then
				local line = CDList[sourceName][781]
				if hunter_trap_var.expl[sourceName] then
					line = nil
				end
				hunter_trap_var.expl[sourceName] = true
				if line then
					local soulbind_rank = _db.soulbind_rank[sourceName][346747] or SOULBIND_DEF_RANK_NOW
					local timeReduce = 0.9 + 0.1 * soulbind_rank

					line:ReduceCD(timeReduce)
				end
			end
		]]},
	{109304,"HUNTER,DEF",3,--Живость
		{109304,120,0},nil,nil,nil,
		cdDiff={287938,-15},reduceCdAfterCast={{34026,270581},-1,{212431,270581,254},-1,{186270,270581},-1.5,{259391,270581},-0.75,{342049,270581,254},-1,{259489,270581},-2.5,{271788,270581,254},-0.5,{1513,270581,253},-0.833,{1513,270581,254},-1.25,{1513,270581,255},-1.25,{212436,270581},-1.5,{259491,270581},-1,{186387,270581,254},-0.5,{120360,270581,253},-2,{120360,270581,254},-1.5,{320976,270581},-0.5,{19434,270581,254},-1.75,{19434,248443},-5,{257620,270581,254},-1,{185358,270581,253},-1.333,{185358,270581,254},-1,{185358,270581,255},-2,{187708,270581},-1.75,{193455,270581},-1.167,{195645,270581,255},-1,{2643,270581},-1.333,{131894,270581,253},-1,{131894,270581,254},-1,{131894,270581,255},-1.5,{259387,270581},-1.5,{53351,270581,253},-0.333,{53351,270581,254},-0.5}},
	{5384,	"HUNTER,DEF",3,--Притвориться мертвым
		{5384,30,0},nil,nil,nil,
		cdDiff={336747,-15}},
	{1543,	"HUNTER",3,--Осветительная ракета
		{1543,20,0},nil,nil,nil},
	{187650,"HUNTER,CC",3,--Замораживающая ловушка
		{187650,30,0},nil,nil,nil,
		cdDiff={343247,{-2.5,-5}}},
	{190925,"HUNTER,MOVE",3,--Гарпун
		nil,nil,nil,{190925,30,0},
		isTalent=true,cdDiff={265895,-10}},
	{19577,	"HUNTER,CC",3,--Устрашение
		{19577,60,5},
		isTalent=true},
	{34477,	"HUNTER",3,--Перенаправление
		{34477,30,0},
		isTalent=true,hideWithTalent=248518},
	{187707,"HUNTER,KICK",3,--Намордник
		nil,nil,nil,{187707,15,0}},
	{257044,"HUNTER",3,--Быстрая стрельба
		nil,nil,{257044,20,0},nil,
		isTalent=true},
	{187698,"HUNTER",3,--Смоляная ловушка
		{187698,30,0},
		isTalent=true,cdDiff={343247,{-2.5,-5}}},
	{19801,	"HUNTER,UTIL",3,--Усмиряющий выстрел
		{19801,10,0},
		isTalent=true},
	{288613,"HUNTER,DPS",3,--Меткий выстрел
		nil,nil,{288613,120,15},nil,
		isTalent=true,durationDiff={336849,3,339920,{"*1.20","*1.22","*1.24","*1.27","*1.29","*1.31","*1.33","*1.36","*1.38","*1.40","*1.42","*1.44","*1.46","*1.48","*1.50"}},cdDiff={203129,-20,296320,"*0.80",336742,"*0.65"},reduceCdAfterCast={{257620,260404},-2.5,{185358,260404},-2.5}},
	{131894,"HUNTER",3,--Стая воронов
		nil,{131894,60,15},nil,nil,
		isTalent=true},
	{120360,"HUNTER",3,--Шквал
		{120360,20,3},
		isTalent=true},
	{109248,"HUNTER,CC",3,--Связующий выстрел
		{109248,45,0},nil,nil,nil,
		isTalent=true},
	{321530,"HUNTER",3,--Кровопролитие
		nil,{321530,60,18},nil,nil,
		isTalent=true},
	{199483,"HUNTER,DEF",3,--Камуфляж
		{199483,60,0},nil,nil,nil,
		isTalent=true},
	{259391,"HUNTER",3,--Шакрамы
		nil,nil,nil,{259391,20,0},
		isTalent=true},
	{53209,	"HUNTER",3,--Выстрел химеры
		nil,{53209,15,0},nil,nil,
		isTalent=true,changeCdWithHaste=true},
	{120679,"HUNTER",3,--Ужасный зверь
		nil,{120679,20,0},nil,nil,
		isTalent=true},
	{260402,"HUNTER",3,--Двойной выстрел
		nil,nil,{260402,60,0},nil,
		isTalent=true},
	{212431,"HUNTER",3,--Разрывной выстрел
		{212431,30,0},
		isTalent=true},
	{269751,"HUNTER",3,--Обходной удар
		nil,nil,nil,{269751,30,0},
		isTalent=true},
	{360966,"HUNTER",3,--Острие копья
		nil,nil,nil,{360966,90,0},
		isTalent=true},
	{201430,"HUNTER,DPS",3,--Звериный натиск
		{201430,120,12},
		isTalent=true},
	{162488,"HUNTER",3,--Капкан
		{162488,30,0},
		isTalent=true,cdDiff={343247,{-2.5,-5}}},
	{260243,"HUNTER",3,--Беглый огонь
		nil,nil,{260243,45,6},nil,
		isTalent=true},
	{205691,"HUNTER,PVP",3,--Ужасный зверь: василиск
		nil,{205691,120,30},nil,nil,
		isTalent=true},
	{208652,"HUNTER,PVP",3,--Ужасный зверь: ястреб
		nil,{208652,30,10},nil,nil,
		isTalent=true},
	{236776,"HUNTER",3,--Фугасная ловушка
		{236776,40,0},
		isTalent=true,cdDiff={343247,{-2.5,-5}}},
	{248518,"HUNTER,PVP",3,--Вмешательство
		nil,{248518,45,0},nil,nil,
		isTalent=true,startCdAfterAuraFade=248519},
	{212640,"HUNTER,PVP",3,--Целебная повязка
		nil,nil,nil,{212640,25,0},
		isTalent=true},
	{213691,"HUNTER",3,--Ошеломляющий выстрел
		{213691,30,0},
		isTalent=true},
	{202900,"HUNTER,PVP",3,--Укус скорпида
		{202900,24,8},nil,nil,nil,
		isTalent=true},
	{203155,"HUNTER,PVP",3,--Снайперский выстрел
		nil,nil,{203155,10,0},nil,
		isTalent=true},
	{202914,"HUNTER,PVP",3,--Укус паука
		{202914,45,4},nil,nil,nil,
		isTalent=true},
	{212638,"HUNTER,PVP",3,--Сеть следопыта
		nil,nil,nil,{212638,25,0},
		isTalent=true},
	{202797,"HUNTER,PVP",3,--Укус гадюки
		{202797,30,6},nil,nil,nil,
		isTalent=true},
	{53480,	"HUNTER,PVP",3,--Рев жертвенности
		{53480,60,12},nil,nil,nil,
		isTalent=true},
	{375891,"HUNTER",3,--Шакрам смерти
		{375891,45,0},
		isTalent=true},


	{13750,	"ROGUE,DPS",3,--Выброс адреналина
		nil,nil,{13750,180,20},nil,
		isTalent=true,cdDiff={296320,"*0.80"}},
	{315341,"ROGUE",3,--Промеж глаз
		nil,nil,{315341,45,0},nil},
	{13877,	"ROGUE",3,--Шквал клинков
		nil,nil,{13877,30,12},nil,
		isTalent=true,durationDiff={272026,3}},
	{2094,	"ROGUE,CC",3,--Ослепление
		{2094,120,0},
		isTalent=true,cdDiff={256165,-30}},
	{31224,	"ROGUE,DEF",4,--Плащ теней
		{31224,120,5},
		isTalent=true,
		CLEU_SPELL_INTERRUPT=[[
			if sourceGUID and isRogue[sourceGUID] and sourceName and session_gGUIDs[sourceName][341535] and spellID == 1766 then
				local line = CDList[sourceName][31224]
				if line then
					local soulbind_rank = _db.soulbind_rank[sourceName][341535] or SOULBIND_DEF_RANK_NOW
					local timeReduce = (1.8 + soulbind_rank * 0.2) * 2

					line:ReduceCD(timeReduce)
				end
			end
		]]},
	{185311,"ROGUE,DEF",4,--Алый фиал
		{185311,30,6},nil,nil,nil},
	{1725,	"ROGUE",3,--Отвлечение
		{1725,30,10},nil,nil,nil},
	{5277,	"ROGUE,DEF",4,--Ускользание
		{5277,120,10},
		isTalent=true,
		CLEU_SPELL_MISSED=[[
			if destGUID and isRogue[destGUID] and destName and session_gGUIDs[destName][341535] and missType == "DODGE" then
				local line = CDList[destName][5277]
				if line then
					local soulbind_rank = _db.soulbind_rank[destName][341535] or SOULBIND_DEF_RANK_NOW
					local timeReduce = 1.8 + soulbind_rank * 0.2

					line:ReduceCD(timeReduce)
				end
			end
		]]},
	{1966,	"ROGUE,DEF",4,--Уловка
		{1966,15,6},
		isTalent=true},
	{1776,	"ROGUE,CC",3,--Парализующий удар
		{1776,20,0},
		isTalent=true},
	{195457,"ROGUE,MOVE",3,--Абордажный крюк
		nil,nil,{195457,45,0},nil,
		isTalent=true,cdDiff={256188,-15,341531,"*0.9"}},
	{1766,	"ROGUE,KICK",5,--Пинок
		{1766,15,0},nil,nil,nil},
	{408,	"ROGUE,CC",3,--Удар по почкам
		{408,20,0},nil,nil,nil},
	{315508,"ROGUE",3,--Игра в кости
		nil,nil,{315508,45,0},nil,
		isTalent=true},
	{381989,"ROGUE",3,--Призовая игра
		nil,nil,{381989,420,0},nil,
		isTalent=true},
	{121471,"ROGUE,DPS",3,--Теневые клинки
		nil,nil,nil,{121471,180,20},
		isTalent=true,cdDiff={296320,"*0.80"},
		CLEU_SPELL_ENERGIZE=[[
			if destGUID and isRogue[destGUID] and destName and session_gGUIDs[sourceName][341559] and spellID == 196911 then
				local line = CDList[destName][121471]
				if line then
					local soulbind_rank = _db.soulbind_rank[sourceName][341559] or SOULBIND_DEF_RANK_NOW
					local timeReduce = 0.9 + soulbind_rank * 0.1

					line:ReduceCD(timeReduce)
				end
			end
		]]},
	{36554,	"ROGUE,MOVE",4,--Шаг сквозь тень
		{36554,30,2},
		isTalent=true,hasCharges=1,cdDiff={341531,"*0.9",382503,"*0.8"},
		CLEU_PREP=[[
			roguepvptal_var = {}
		]],CLEU_SPELL_AURA_APPLIED=[[
			if spellID == 79140 then
				roguepvptal_var[sourceName] = destGUID
			end
		]],CLEU_SPELL_AURA_REMOVED=[[
			if spellID == 79140 then
				roguepvptal_var[sourceName] = nil
			end
		]],CLEU_SPELL_CAST_SUCCESS=[[
			if spellID == 36554 and module.IsPvpTalentsOn(sourceName) then
				if destGUID == roguepvptal_var[sourceName] and session_gGUIDs[sourceName][197007] then
					local line = CDList[sourceName][36554]
					if line then
						line:ChangeCD(-20,true)
						forceUpdateAllData = true
					end
				end
				if bit.band(destFlags or 0,240) == 16 then
					local line = CDList[sourceName][36554]
					if line then
						line:ChangeCD(-15,true)
						forceUpdateAllData = true
					end
				end
			end
		]]},
	{5938,	"ROGUE",3,--Отравляющий укол
		{5938,25,0},
		isTalent=true},
	{382245,"ROGUE",3,--Хладнокровие
		{382245,45,0},
		isTalent=true,startCdAfterAuraFade=382245},
	{385616,"ROGUE",3,--Продолжительная отповедь
		{385616,45,0},
		isTalent=true},
	{381623,"ROGUE,DPS",3,--Скорополоховый чай
		{381623,60,6},
		isTalent=true,hasCharges=1},
	{114018,"ROGUE,UTIL",1,--Скрывающий покров
		{114018,360,15},nil,nil,nil},
	{2983,	"ROGUE,MOVE",4,--Спринт
		{2983,120,8},nil,nil,nil,
		cdDiff={231691,-60},ignoreUseWithAura=375255,changeCdWithAura={381754,"*0.85"}},
	{212283,"ROGUE,DPS",3,--Символы смерти
		nil,nil,nil,{212283,30,10},
		cdDiff={394309,-5}},
	{57934,	"ROGUE",3,--Маленькие хитрости
		{57934,30,6},
		isTalent=true,startCdAfterAuraApply=59628},
	{1856,	"ROGUE,DEF",4,--Исчезновение
		{1856,120,3},nil,nil,nil,
		cdDiff={212081,-45},hasCharges=382513},
	{271877,"ROGUE",3,--Натиск клинка
		nil,nil,{271877,45,0},nil,
		isTalent=true},
	{343142,"ROGUE",3,--Клинки Ужаса
		nil,nil,{343142,120,10},nil,
		isTalent=true},
	{200806,"ROGUE,DPS",3,--Пускание крови
		nil,{200806,45,0},nil,nil,
		isTalent=true},
	{196937,"ROGUE",3,--Призрачный удар
		nil,nil,{196937,35,0},nil,
		isTalent=true},
	{51690,	"ROGUE,DPS",3,--Череда убийств
		nil,nil,{51690,120,0},nil,
		isTalent=true},
	{137619,"ROGUE,DPS",3,--Метка смерти
		{137619,60,0},nil,nil,nil,
		isTalent=true},
	{280719,"ROGUE",3,--Тайный прием
		nil,nil,nil,{280719,60,0},
		isTalent=true,reduceCdAfterCast={195452,-5,408,-5,196819,-5,280719,-5}},
	{277925,"ROGUE",3,--Торнадо из сюрикэнов
		nil,nil,nil,{277925,60,4},
		isTalent=true},
	{213981,"ROGUE,PVP",3,--Хладнокровие
		nil,nil,nil,{213981,60,0},
		isTalent=true},
	{269513,"ROGUE,PVP",3,--Смерть с небес
		{269513,30,0},nil,nil,nil,
		isTalent=true},
	{207777,"ROGUE,PVP",3,--Долой оружие
		nil,nil,{207777,45,0},nil,
		isTalent=true},
	{206328,"ROGUE,PVP",3,--Нейротоксин
		nil,{206328,45,0},nil,nil,
		isTalent=true},
	{198529,"ROGUE,PVP",3,--Кража доспехов
		nil,nil,{198529,120,0},nil,
		isTalent=true},
	{207736,"ROGUE,PVP",3,--Дуэль в тенях
		nil,nil,nil,{207736,120,6},
		isTalent=true},
	{212182,"ROGUE,PVP",3,--Дымовая шашка
		{212182,180,5},nil,nil,nil,
		isTalent=true},
	{360194,"ROGUE",3,--Метка смерти
		nil,{360194,120,0},nil,nil,
		isTalent=true},
	{385408,"ROGUE",3,--Сепсис
		{385408,90,10},
		isTalent=true,changeCdBeforeAuraFullDur={385408,-30}},
	{385424,"ROGUE",3,--Зазубренный костяной шип
		nil,{385424,30,0},
		isTalent=true,hasCharges=1},
	{385627,"ROGUE",3,--Погибель королей
		nil,{385627,60,0},
		isTalent=true},
	{381802,"ROGUE",3,--Тотальная бойня
		nil,{381802,60,0},
		isTalent=true,startCdAfterAuraFade=381802},
	{384631,"ROGUE",3,--Флагелляция
		nil,nil,nil,{323654,90,12},
		isTalent=true},


	{204883,"PRIEST",3,--Круг исцеления
		nil,nil,{204883,15,0},nil,
		changeCdWithHaste=true},
	{19236,	"PRIEST,DEF",4,--Молитва отчаяния
		{19236,90,0},nil,nil,nil},
	{47585,	"PRIEST,DEF",4,--Слияние с Тьмой
		nil,nil,nil,{47585,120,6},
		isTalent=true,cdDiff={288733,-30}},
	{64843,	"PRIEST,RAID",1,--Божественный гимн
		nil,nil,{64843,180,8},nil,
		isTalent=true,cdDiff={296320,"*0.80"},changeDurWithHaste=true,stopDurWithAuraFade=64843},
	{586,	"PRIEST,DEF",4,--Уход в тень
		{586,30,10},nil,nil,nil,
		cdDiff={329588,-10},hideWithTalent=213602},
	{47788,	"PRIEST,DEFTAR",2,--Оберегающий дух
		nil,nil,{47788,180,10},nil,
		isTalent=true,durationDiff={337811,2,329693,5},stopDurWithAuraFade=47788,changeCdAfterAuraFullDur={{47788,200209},-110}},
	{88625,	"PRIEST",3,--Слово Света: Наказание
		nil,nil,{88625,60,0},nil,
		isTalent=true,resetBy=200183,reduceCdAfterCast={{14914,336314},-4,{14914,390994},{-2,-4},585,-4,{585,196985},-1.333,{585,200183,nil,200183},-12,{585,338345},{-0.24,-0.352,-0.384,-0.416,-0.448,-0.48,-0.512,-0.544,-0.576,-0.608,-0.64,-0.672,-0.704,-0.736,-0.768},{585,338345,nil,200183},{-0.72,-1.056,-1.152,-1.248,-1.344,-1.44,-1.536,-1.632,-1.728,-1.824,-1.92,-2.016,-2.112,-2.208,-2.304}}},
	{34861,	"PRIEST",3,--Слово Света: Освящение
		nil,nil,{34861,60,0},nil,
		isTalent=true,resetBy=200183,hasCharges=235587,reduceCdAfterCast={32546,-3,{32546,196985},-1,{32546,200183,nil,200183},-9,{32546,338345},{-0.18,-0.264,-0.288,-0.312,-0.336,-0.36,-0.384,-0.408,-0.432,-0.456,-0.48,-0.504,-0.528,-0.552,-0.576},{32546,338345,nil,200183},{-0.54,-0.792,-0.864,-0.936,-1.008,-1.08,-1.152,-1.224,-1.296,-1.368,-1.44,-1.512,-1.584,-1.656,-1.728},139,-2,{139,196985},-0.667,{139,200183,nil,200183},-6,{139,338345},{-0.12,-0.176,-0.192,-0.208,-0.224,-0.24,-0.256,-0.272,-0.288,-0.304,-0.32,-0.336,-0.352,-0.368,-0.384},{139,338345,nil,200183},{-0.36,-0.528,-0.576,-0.624,-0.672,-0.72,-0.768,-0.816,-0.864,-0.912,-0.96,-1.008,-1.056,-1.104,-1.152},{204883,336314},-4,{204883,390994},{-2,-4},596,-6,{596,196985},-1.333,{596,200183,nil,200183},-18,{596,338345},{-0.36,-0.528,-0.576,-0.624,-0.672,-0.72,-0.768,-0.816,-0.864,-0.912,-0.96,-1.008,-1.056,-1.104,-1.152},{596,338345,nil,200183},{-1.08,-1.584,-1.728,-1.872,-2.016,-2.16,-2.304,-2.448,-2.592,-2.736,-2.88,-3.024,-3.168,-3.312,-3.456}}},
	{2050,	"PRIEST,DEFTAR",3,--Слово Света: Безмятежность
		nil,nil,{2050,60,0},nil,
		isTalent=true,hasCharges=235587,resetBy=200183,reduceCdAfterCast={32546,-3,{32546,196985},-1,{32546,200183,nil,200183},-9,{32546,338345},{-0.18,-0.264,-0.288,-0.312,-0.336,-0.36,-0.384,-0.408,-0.432,-0.456,-0.48,-0.504,-0.528,-0.552,-0.576},{32546,338345,nil,200183},{-0.54,-0.792,-0.864,-0.936,-1.008,-1.08,-1.152,-1.224,-1.296,-1.368,-1.44,-1.512,-1.584,-1.656,-1.728},2060,-6,{2060,196985},-2,{2060,200183,nil,200183},-18,{2060,338345},{-0.36,-0.528,-0.576,-0.624,-0.672,-0.72,-0.768,-0.816,-0.864,-0.912,-0.96,-1.008,-1.056,-1.104,-1.152},{2060,338345,nil,200183},{-1.08,-1.584,-1.728,-1.872,-2.016,-2.16,-2.304,-2.448,-2.592,-2.736,-2.88,-3.024,-3.168,-3.312,-3.456},{33076,336314},-4,{33076,390994},{-2,-4},2061,-6,{2061,196985},-2,{2061,200183,nil,200183},-18,{2061,338345},{-0.36,-0.528,-0.576,-0.624,-0.672,-0.72,-0.768,-0.816,-0.864,-0.912,-0.96,-1.008,-1.056,-1.104,-1.152},{2061,338345,nil,200183},{-1.08,-1.584,-1.728,-1.872,-2.016,-2.16,-2.304,-2.448,-2.592,-2.736,-2.88,-3.024,-3.168,-3.312,-3.456}}},
	{73325,	"PRIEST,UTIL",2,--Духовное рвение
		{73325,90,0},nil,nil,nil,
		isTalent=true,hasCharges=336470,cdDiff={390620,-30,337678,{-20,-22,-24,-26,-28,-30,-32,-34,-36,-38,-40,-42,-44,-46,-48}},sameSpell={336471,73325},ignoreUseWithAura=375254,changeCdWithAura={381753,"*0.85"}},
	{32375,	"PRIEST,DISPEL",1,--Массовое рассеивание
		{32375,45,0},nil,nil,nil,
		isTalent=true,cdDiff={341167,-25}},
	{33206,	"PRIEST,DEFTAR",2,--Подавление боли
		nil,{33206,180,8},nil,nil,
		isTalent=true,durationDiff={329693,4},reduceCdAfterCast={{17,373035},-3}},
	{10060,	"PRIEST,UTIL",3,--Придание сил
		{10060,120,20},nil,nil,nil,
		isTalent=true,
		CLEU_SPELL_CAST_SUCCESS=[[
			if spellID == 10060 and session_gGUIDs[sourceName][337762] and sourceName ~= destName then	--Power infusion soulbind
				local line = CDList[sourceName][10060]
				if line then
					local soulbind_rank = _db.soulbind_rank[sourceName][337762] or SOULBIND_DEF_RANK_NOW
					local timeReduce = 5.4 + soulbind_rank * 0.6

					line:ChangeCD(-timeReduce,true)

					forceUpdateAllData = true
				end
			end
		]]},
	{373481,"PRIEST",3,--Слово Силы: Жизнь
		{373481,30,0},nil,nil,nil,
		isTalent=true,
		CLEU_SPELL_HEAL=[[
			if spellID == 373481 and destName then
				local maxHP = UnitHealthMax(destName) or 0
				if maxHP ~= 0 then
					local hpB4 = UnitHealth(destName) - (amount-overhealing)
					local hp = hpB4 / maxHP
	
					if hp < 0.35 then
						local line = CDList[sourceName][373481]
						if line then
							C_Timer.After(0.3,function()	--Await for actual cast, selfhealing event fired first
								line:ChangeCD(-20)
							end)
						end
					end
				end

			end
		]]},
	{62618,	"PRIEST,RAID",1,--Слово силы: Барьер
		nil,{62618,180,10},nil,nil,
		isTalent=true,cdDiff={197590,-90},hideWithTalent=271466,icon="Interface\\Icons\\spell_holy_powerwordbarrier"},
	{194509,"PRIEST",3,--Слово силы: Сияние
		nil,{194509,20,0},nil,nil,
		isTalent=true,hasCharges=322115,cdDiff={390684,-5}},
	{33076,	"PRIEST",3,--Молитва восстановления
		nil,nil,{33076,12,0},nil,
		isTalent=true,changeCdWithHaste=true},
	{8122,	"PRIEST,AOECC",3,--Ментальный крик
		{8122,60,8},nil,nil,nil,
		cdDiff={196704,-15},hideWithTalent=205369},
	{527,	"PRIEST,DISPEL",5,--Очищение
		nil,{527,8,0},{527,8,0},nil,
		hasCharges=196162,isDispel=true},
	{213634,"PRIEST,DISPEL",5,--Очищение от болезни
		nil,nil,nil,{213634,8,0},
		isTalent=true,isDispel=true},
	{391109,"PRIEST,DPS",5,--Темное вознесение
		nil,nil,nil,{391109,60,20},
		isTalent=true},
	{47536,	"PRIEST,HEAL",1,--Вознесение
		nil,{47536,90,8},nil,nil,
		isTalent=true,durationDiff={337790,1,373042,5},hideWithTalent=109964},
	{32379,	"PRIEST",3,--Слово Тьмы: Смерть
		{32379,20,0},nil,nil,nil,
		cdDiff={336133,-12},changeCdWithHaste=true},
	{34433,	"PRIEST,DPS,HEAL",3,--Исчадие Тьмы
		{34433,180,15},nil,nil,nil,
		isTalent=true,cdDiff={296320,"*0.80"},hideWithTalent=123040},
	{15487,	"PRIEST,CC,KICK",3,--Безмолвие
		nil,nil,nil,{15487,45,4},
		isTalent=true,cdDiff={263716,-15}},
	{64901,	"PRIEST,HEALUTIL",1,--Символ надежды
		nil,nil,{64901,180,4},nil,
		isTalent=true,changeDurWithHaste=true,stopDurWithAuraFade=64901},
	{15286,	"PRIEST,RAID",1,--Объятия вампира
		{15286,120,15},nil,nil,nil,
		isTalent=true,durationDiff={329693,7.5},cdDiff={199855,-45}},
	{228260,"PRIEST,DPS",3,--Извержение Бездны
		nil,nil,nil,{228260,90,0}},
	{200183,"PRIEST,HEAL",3,--Прославление
		nil,nil,{200183,120,20},nil,
		isTalent=true},
	{372835,"PRIEST,HEAL",3,--Колодец Света
		nil,nil,{372835,180,0},nil,
		isTalent=true},
	{372760,"PRIEST,HEAL",3,--Божественное слово
		nil,nil,{372760,60,0},nil,
		isTalent=true},
	{341374,"PRIEST",3,--Проклятие
		nil,nil,nil,{341374,45,0},
		isTalent=true,cdDiff={373221,-15}},
	{121536,"PRIEST,MOVE",3,--Божественное перышко
		{121536,20,0},nil,nil,nil,
		isTalent=true,hasCharges=1},
	{205364,"PRIEST,CC",3,--Господство над разумом
		{205364,30,0},nil,nil,nil,
		isTalent=true},
	{108920,"PRIEST,AOECC",3,--Щупальца Бездны
		{108920,60,20},nil,nil,nil,
		isTalent=true},
	{110744,"PRIEST",3,--Божественная звезда
		nil,{110744,15,0},{110744,15,0},{122121,15,0},
		isTalent=true},
	{246287,"PRIEST,HEAL",3,--Проповедь
		nil,{246287,180,0},nil,nil,
		isTalent=true},
	{373178,"PRIEST,HEAL",3,--Ярость Света
		nil,{373178,90,0},nil,nil,
		isTalent=true},
	{120517,"PRIEST",3,--Сияние
		nil,{120517,40,0},{120517,40,0},{120644,40,0},
		isTalent=true},
	{265202,"PRIEST,RAID",1,--Слово Света: Спасение
		nil,nil,{265202,720,0},nil,
		isTalent=true,reduceCdAfterCast={34861,-30,2050,-30}},
	--{205369,"PRIEST,AOECC",3,--Мыслебомба
	--	nil,nil,nil,{205369,30,2},
	--	isTalent=true},
	{200174,"PRIEST",3,--Подчинитель разума
		nil,nil,nil,{200174,60,15},
		isTalent=true},
	{123040,"PRIEST",3,--Подчинитель разума
		nil,{123040,60,12},nil,nil,
		isTalent=true,cdDiff={296320,"*0.80"},reduceCdAfterCast={{585,390770},-2,{47540,390770},-2,{8092,390770},-2}},
	{129250,"PRIEST",3,--Слово силы: Утешение
		nil,{129250,15,0},nil,nil,
		isTalent=true,changeCdWithHaste=true},
	{64044,	"PRIEST,CC",3,--Глубинный ужас
		nil,nil,nil,{64044,45,4},
		isTalent=true},
	{214621,"PRIEST,HEAL",3,--Схизма
		nil,{214621,24,9},nil,nil,
		isTalent=true,durationDiff={372969,3}},
	{314867,"PRIEST",3,--Темный завет
		nil,{314867,30,7},nil,nil,
		isTalent=true,durationDiff={372985,4}},
	{263165,"PRIEST",3,--Поток Бездны
		nil,nil,nil,{263165,45,3},
		isTalent=true,cdDiff={373221,-15}},
	{375901,"PRIEST",3,--Игры разума
		{375901,45,5},
		isTalent=true,durationDiff={391112,2},stopDurWithAuraFade=375901,reduceCdAfterCast={{585,390996},{-0.5,-1},{47540,390996},{-0.5,-1},{8092,390996},{-0.5,-1},{73510,390996},{-0.5,-1},{14914,390996},{-0.5,-1}}},
	{197862,"PRIEST,PVP",3,--Архангел
		nil,{197862,60,15},nil,nil,
		isTalent=true},
	{197871,"PRIEST,PVP",3,--Темный архангел
		nil,{197871,60,8},nil,nil,
		isTalent=true},
	{328530,"PRIEST,PVP",3,--Божественное вознесение
		nil,nil,{328530,60,0},nil,
		isTalent=true},
	{213602,"PRIEST,PVP",3,--Улучшенный уход в тень
		nil,nil,{213602,45,0},{213602,45,0},
		isTalent=true},
	{289666,"PRIEST,PVP",3,--Великое исцеление
		nil,nil,{289666,15,0},nil,
		isTalent=true},
	{213610,"PRIEST,PVP",3,--Священный оберег
		nil,nil,{213610,30,0},nil,
		isTalent=true},
	{289657,"PRIEST,PVP",3,--Освященная земля
		nil,nil,{289657,45,8},nil,
		isTalent=true},
	{211522,"PRIEST,PVP",3,--Ментальный демон
		nil,nil,nil,{211522,45,12},
		isTalent=true},
	{197268,"PRIEST,PVP",3,--Луч надежды
		nil,nil,{197268,60,6},nil,
		isTalent=true},
	{316262,"PRIEST,PVP",3,--Украденные мысли
		{316262,90,0},nil,nil,nil,
		isTalent=true},
	{108968,"PRIEST,DEFTAR",2,--Вхождение в Бездну
		{108968,300,0},nil,nil,nil,
		isTalent=true},
	{215982,"PRIEST,PVP",3,--Дух воздаятеля
		nil,nil,{215769,180,7},nil,
		isTalent=true},


	{48707,	"DEATHKNIGHT,DEF",4,--Антимагический панцирь
		{48707,60,5},
		isTalent=true,durationDiff={205727,"*1.4",207321,5},cdDiff={205727,-20},stopDurWithAuraFade=48707},
	{51052,	"DEATHKNIGHT,RAID",3,--Зона антимагии
		{51052,120,8},
		isTalent=true,durationDiff={337764,{2,2.2,2.4,2.6,2.8,3,3.2,3.4,3.6,3.8,4,4.2,4.4,4.6,4.8}}},
	{275699,"DEATHKNIGHT,DPS",3,--Апокалипсис
		nil,nil,nil,{275699,90,15},
		isTalent=true,cdDiff={288848,-45,296320,"*0.80",338553,-1},reduceCdAfterCast={{47541,276837},-1}},
	{42650,	"DEATHKNIGHT,DPS",3,--Войско мертвых
		nil,nil,nil,{42650,480,30},
		isTalent=true,hideWithTalent=288853,reduceCdAfterCast={{47541,276837},-5}},
	{390279,"DEATHKNIGHT,DPS",3,--Отвратительное заражение
		nil,nil,nil,{390279,90,0},
		isTalent=true},
	{221562,"DEATHKNIGHT,CC",3,--Асфиксия
		{221562,45,5},
		isTalent=true},
	{49028,	"DEATHKNIGHT,DEFTANK",4,--Танцующее руническое оружие
		nil,{49028,120,8},nil,nil,
		isTalent=true,durationDiff={377668,8,233412,"*0.5"},cdDiff={233412,"*0.5"},
		CLEU_SPELL_AURA_REMOVED=[[
			if spellID == 195181 and (session_gGUIDs[sourceName][334525] or session_gGUIDs[sourceName][377637]) then	--Bone Shield
				local line = CDList[sourceName][49028]
				if line then
					line:ReduceCD(5,true)
					forceUpdateAllData = true
				end
			end
		]],CLEU_SPELL_AURA_REMOVED_DOSE=[[
			if spellID == 195181 and (session_gGUIDs[sourceName][334525] or session_gGUIDs[sourceName][377637]) then	--Bone Shield
				local line = CDList[sourceName][49028]
				if line then
					line:ReduceCD(3)
				end
			end
		]]},
	{56222,	"DEATHKNIGHT,TAUNT",5,--Темная власть
		{56222,8,0},nil,nil,nil,
		hideWithTalent=207018},
	{63560,	"DEATHKNIGHT,DPS",3,--Темное превращение
		nil,nil,nil,{63560,60,15},
		isTalent=true,cdDiff={316941,{-8,-16}},durationDiff={337381,{3,3.3,3.9,3.9,4.2,4.5,4.8,5.1,5.4,5.7,6,6.3,6.6,6.9,7.2}},increaseDurAfterCast={{47541,334949},1}},
	{50977,	"DEATHKNIGHT",3,--Врата смерти
		{50977,60,0},nil,nil,nil},
	{49576,	"DEATHKNIGHT,UTIL",5,--Хватка смерти
		{49576,25,0},nil,nil,nil,
		hasCharges=356367,cdDiff={334724,-3},startCdAfterAuraFadeExt=334722},
	{43265,	"DEATHKNIGHT",3,--Смерть и разложение
		{43265,30,0},nil,nil,nil,
		hasCharges=356367,hideWithTalent=152280,reduceCdAfterCast={{47541,334898},-2,{49998,334898},-2}},
	{48265,	"DEATHKNIGHT,MOVE",4,--Поступь смерти
		{48265,45,0},
		hasCharges=356367,ignoreUseWithAura=375226,changeCdWithAura={381732,"*0.85"}},
	{47568,	"DEATHKNIGHT,DPS",3,--Усиление рунического оружия
		{47568,120,20},
		isTalent=true,cdDiff={296320,"*0.80"}},
	{383269,"DEATHKNIGHT,DPS",3,--Рука поганища
		{383269,120,12},
		isTalent=true},
	{279302,"DEATHKNIGHT",3,--Ярость ледяного змея
		nil,nil,{279302,180,10},nil,
		isTalent=true,cdDiff={334692,"*0.5",377047,"*0.5"}},
	{108199,"DEATHKNIGHT,UTIL",1,--Хватка Кровожада
		nil,{108199,120,0},nil,nil,
		isTalent=true,cdDiff={206970,-30}},
	{48792,	"DEATHKNIGHT,DEFTANK,DEF",4,--Незыблемость льда
		{48792,180,8},
		isTalent=true,cdDiff={373926,-60,288424,-15,337704,{-20,-22,-24,-26,-28,-30,-32,-34,-36,-38,-40,-42,-44,-46,-38}}},
	{49039,	"DEATHKNIGHT",3,--Перерождение
		{49039,120,10},
		durationDiff={389682,10}},
	{47528,	"DEATHKNIGHT,KICK",5,--Заморозка разума
		{47528,15,0},
		isTalent=true,
		CLEU_SPELL_INTERRUPT=[[
			if sourceName and session_gGUIDs[sourceName][378848] and spellID == 47528 then
				local line = CDList[sourceName][47528]
				if line then
					line:ReduceCD(3)
				end
			end
		]]},
	{51271,	"DEATHKNIGHT,DPS,DEF",3,--Ледяной столп
		nil,nil,{51271,60,12},nil,
		isTalent=true,
		CLEU_SPELL_DAMAGE=[[
			if (spellID == 49020 or spellID == 49143) and critical and session_gGUIDs[sourceName][207126] then
				local line = CDList[sourceName][51271]
				if line then
					line:ReduceCD(4)
				end
			end
		]]},
	{61999,	"DEATHKNIGHT,RES",3,--Воскрешение союзника
		{61999,600,0},nil,nil,nil,
		isBattleRes=true},
	{46585,	"DEATHKNIGHT",3,--Воскрешение мертвых
		{46585,120,0},
		isTalent=true},
	{196770,"DEATHKNIGHT",3,--Беспощадность зимы
		nil,nil,{196770,20,8},nil,
		isTalent=true},
	{194679,"DEATHKNIGHT,DEFTANK",4,--Захват рун
		nil,{194679,25,4},nil,nil,
		isTalent=true,hasCharges=1},
	{55233,	"DEATHKNIGHT,DEFTANK",3,--Кровь вампира
		nil,{55233,90,10},nil,nil,
		isTalent=true,cdDiff={296320,"*0.80"},reduceCdAfterCast={{206930,334580},-2,{61999,205723},-3,{47541,205723},-4,{327574,205723},-2,{49998,205723},-4.5},durationDiff={317133,2}},
	{108194,"DEATHKNIGHT,CC",3,--Асфиксия
		nil,nil,{108194,45,0},{108194,45,0},
		isTalent=true},
	{207167,"DEATHKNIGHT,AOECC",3,--Ослепляющая наледь
		{207167,60,0},
		isTalent=true},
	{206931,"DEATHKNIGHT,DEFTANK",3,--Кровопийца
		nil,{206931,30,0},nil,nil,
		isTalent=true},
	{194844,"DEATHKNIGHT",3,--Буря костей
		nil,{194844,60,0},nil,nil,
		isTalent=true},
	{152279,"DEATHKNIGHT,DPS",3,--Дыхание Синдрагосы
		nil,nil,{152279,120,0},nil,
		isTalent=true},
	{274156,"DEATHKNIGHT",3,--Пожирание
		nil,{274156,30,0},nil,nil,
		isTalent=true},
	{48743,	"DEATHKNIGHT,DEF",3,--Смертельный союз
		{48743,120,0},
		isTalent=true},
	{152280,"DEATHKNIGHT",3,--Осквернение
		nil,nil,nil,{152280,20,0},
		isTalent=true,reduceCdAfterCast={{47541,334898},-2,{49998,334898},-2}},
	{57330,	"DEATHKNIGHT",3,--Зимний горн
		nil,nil,{57330,45,0},nil,
		isTalent=true},
	{321995,"DEATHKNIGHT",3,--Гипотермия
		nil,nil,{321995,45,8},nil,
		isTalent=true},
	{49206,	"DEATHKNIGHT,DPS",3,--Призыв горгульи
		nil,nil,nil,{49206,180,30},
		isTalent=true},
	{219809,"DEATHKNIGHT",3,--Надгробный камень
		nil,{219809,60,0},nil,nil,
		isTalent=true},
	{207289,"DEATHKNIGHT,DPS",3,--Нечестивый натиск
		nil,nil,nil,{207289,90,12},
		isTalent=true},
	{115989,"DEATHKNIGHT",3,--Нечестивая порча
		nil,nil,nil,{115989,45,0},
		isTalent=true},
	{212552,"DEATHKNIGHT,MOVE",3,--Блуждающий дух
		{212552,60,4},
		isTalent=true},
	{305392,"DEATHKNIGHT,PVP",3,--Поток холода
		nil,nil,{305392,45,0},nil,
		isTalent=true},
	{77606,	"DEATHKNIGHT,PVP",3,--Темный симулякр
		{77606,20,0},nil,nil,nil,
		isTalent=true},
	{203173,"DEATHKNIGHT,PVP",3,--Цепь смерти
		nil,{203173,30,0},nil,nil,
		isTalent=true},
	{207018,"DEATHKNIGHT,PVP",3,--Убийственное намерение
		nil,{207018,20,0},nil,nil,
		isTalent=true},
	{288853,"DEATHKNIGHT,PVP",3,--Воскрешение поганища
		nil,nil,nil,{288853,90,0},
		isTalent=true},
	{47476,	"DEATHKNIGHT,PVP",3,--Удушение
		nil,{47476,60,5},nil,nil,
		isTalent=true},
	{288977,"DEATHKNIGHT,PVP",3,--Передача
		nil,nil,{288977,45,7},{288977,45,7},
		isTalent=true},


	{556,	"SHAMAN",3,--Астральное возвращение
		{556,600,0},nil,nil,nil},
	{108271,"SHAMAN,DEF",4,--Астральный сдвиг
		{108271,120,8},nil,nil,nil,
		isTalent=true,durationDiff={329538,10,381647,4},cdDiff={381647,-30},hideWithTalent=210918},
	{2825,	"SHAMAN,UTIL",3,--Жажда крови
		{2825,300,40},nil,nil,nil,
		cdDiff={193876,-240},specialCheck=function(_,name) return UnitFactionGroup(name or "")~="Alliance" end},
	{32182,	"SHAMAN,UTIL",3,--Героизм
		{32182,300,40},nil,nil,nil,
		cdDiff={193876,-240},specialCheck=function(_,name) return UnitFactionGroup(name or "")=="Alliance" end},
	{192058,"SHAMAN,AOECC",1,--Тотем конденсации
		{192058,60,2},nil,nil,nil,
		isTalent=true,cdDiff={381867,{-2,-4},338042,{-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15}},
		CLEU_PREP = [[
			CapacitorMain = {}
			CapacitorPrev,CapacitorCount = 0,0
		]],CLEU_SPELL_AURA_APPLIED = [[
			if spellID == 118905 and sourceGUID and CapacitorMain[sourceGUID] then
				sourceName = CapacitorMain[sourceGUID]
				local line = CDList[sourceName][192058]
				if line and session_gGUIDs[sourceName][265046] then
					local t = GetTime()
					if CapacitorPrev < t then
						CapacitorPrev = t + 1
						CapacitorCount = 0
					end
					CapacitorCount = CapacitorCount + 1

					line:ChangeCD( -(CapacitorCount <= 4 and 5 or 0) )
				end
			end
		]],CLEU_SPELL_SUMMON = [[
			if sourceName and spellID == 192058 then
				CapacitorMain[destGUID] = sourceName
			end
		]]},
	{51886,	"SHAMAN,DISPEL",5,--Очищение духа
		nil,{51886,8,0},{51886,8,0},nil,
		isTalent=true,isDispel=true},
	{198103,"SHAMAN,UTIL",2,--Элементаль земли
		{198103,300,60},nil,nil,nil,
		isTalent=true,cdDiff={329534,-60}},
	{2484,	"SHAMAN,AOECC",3,--Тотем оков земли
		{2484,30,20},nil,nil,nil,
		cdDiff={381867,{-2,-4},338042,{-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15}}},
	{51533,	"SHAMAN,DPS",3,--Дух дикого зверя
		nil,nil,{51533,90,15},nil,
		isTalent=true,cdDiff={262624,-30,296320,"*0.80"},resetBy={{328923,333352}},
		CLEU_PREP=[[
			spell356218_var51533 = {}
		]],CLEU_SPELL_AURA_APPLIED=[[
			if spellID == 187881 and sourceName and session_gGUIDs[sourceName][335897] then
				local line = CDList[sourceName][51533]
				if line then
					line:ReduceCD(2)
				end
			end
		]],CLEU_SPELL_AURA_APPLIED_DOSE=[[
			if spellID == 187881 and sourceName and session_gGUIDs[sourceName][335897] then
				local line = CDList[sourceName][51533]
				if line then
					line:ReduceCD(2)
				end
			end
		]],CLEU_SPELL_DAMAGE=[[
			if spellID == 328928 and session_gGUIDs[sourceName][356218] then
				local last = spell356218_var51533[sourceName] or 0
				local t = GetTime()
				if t > last then
					spell356218_var51533[sourceName] = t + 0.2

					local line = CDList[sourceName][51533]
					if line then
						line:ReduceCD(9)
					end
				end
			end
		]]},
	{198067,"SHAMAN,DPS",3,--Элементаль огня
		nil,{198067,150,30},nil,nil,
		isTalent=true,durationDiff={338303,{"*1.35","*1.36","*1.37","*1.38","*1.39","*1.40","*1.41","*1.43","*1.44","*1.45","*1.46","*1.47","*1.48","*1.49","*1.50"}},cdDiff={296320,"*0.80"},hideWithTalent=192249,
		CLEU_PREP=[[
			spell356218_var198067 = {}
		]],CLEU_SPELL_DAMAGE=[[
			if spellID == 188389 and critical and session_gGUIDs[sourceName][336734] then
				local line = CDList[sourceName][198067]
				if line then
					line:ReduceCD(1)
				end
			elseif spellID == 328928 and session_gGUIDs[sourceName][356218] then
				local last = spell356218_var198067[sourceName] or 0
				local t = GetTime()
				if t > last then
					spell356218_var198067[sourceName] = t + 0.2

					local line = CDList[sourceName][198067]
					if line then
						line:ReduceCD(7)
					end
				end
			end
		]]},
	{73920,	"SHAMAN",3,--Целительный ливень
		nil,nil,nil,{73920,10,0},
		isTalent=true},
	{5394,	"SHAMAN",3,--Тотем исцеляющего потока
		{5394,30,0},nil,nil,nil,
		isTalent=true,hasCharges=108283,hideWithTalent=157153,cdDiff={381867,{-2,-4}}},
	{108280,"SHAMAN,RAID",3,--Тотем целительного прилива
		nil,nil,nil,{108280,180,12},
		isTalent=true,cdDiff={381867,{-2,-4},296320,"*0.80"},
		CLEU_PREP=[[
			spell356218_var108280 = {}
		]],CLEU_SPELL_DAMAGE=[[
			if spellID == 328928 and session_gGUIDs[sourceName][356218] then
				local last = spell356218_var108280[sourceName] or 0
				local t = GetTime()
				if t > last then
					spell356218_var108280[sourceName] = t + 0.2

					local line = CDList[sourceName][108280]
					if line then
						line:ReduceCD(7)
					end
				end
			end
		]],CLEU_SPELL_AURA_REMOVED_DOSE=[[
			if spellID == 53390 and session_gGUIDs[sourceName][382030] then
				local line = CDList[sourceName][108280]
				if line then
					line:ReduceCD(0.5)
				end
			end
		]],CLEU_SPELL_AURA_REMOVED=[[
			if spellID == 53390 and session_gGUIDs[sourceName][382030] then
				local line = CDList[sourceName][108280]
				if line then
					line:ReduceCD(0.5)
				end
			end
		]]},
	{51514,	"SHAMAN,CC",3,--Сглаз
		{51514,30,0},nil,nil,nil,
		isTalent=true,cdDiff={204268,-15},sameSpell={51514,211015,210873,211010,211004,269352,277778,277784,309328}},
	{16191,	"SHAMAN,HEALUTIL",3,--Тотем прилива маны
		nil,nil,nil,{16191,180,8},
		isTalent=true,cdDiff={381867,{-2,-4}},
		CLEU_SPELL_AURA_REMOVED_DOSE=[[
			if spellID == 53390 and session_gGUIDs[sourceName][382030] then
				local line = CDList[sourceName][16191]
				if line then
					line:ReduceCD(0.5)
				end
			end
		]],CLEU_SPELL_AURA_REMOVED=[[
			if spellID == 53390 and session_gGUIDs[sourceName][382030] then
				local line = CDList[sourceName][16191]
				if line then
					line:ReduceCD(0.5)
				end
			end
		]]},
	{77130,	"SHAMAN,DISPEL",5,--Возрождение духа
		nil,nil,nil,{77130,8,0},
		isDispel=true},
	{20608,	"SHAMAN,RES",2,--Реинкарнация
		{21169,1800,0},nil,nil,nil,
		cdDiff={337964,{-180,-210,-240,-270,-300,-330,-360,-390,-420,-450,-480,-510,-540,-570,-600}},afterCombatNotReset=true,
		CLEU_SPELL_CAST_SUCCESS=[[
			if spellID == 21169 and sourceName and session_gGUIDs[sourceName][381689] then	--No recheck after reload
				local line = CDList[sourceName][21169]
				if line then
					if not AnkhTimers then
						AnkhTimers = {}
					end
					if AnkhTimers[sourceName] then
						AnkhTimers[sourceName]:Cancel()
					end
					AnkhTimers[sourceName] = C_Timer.NewTicker(1,function(self)
						local line = CDList[sourceName][21169]
						if not line or ((line.lastUse + line.cd) < GetTime()) then
							self:Cancel()
							AnkhTimers[sourceName] = nil
							return
						end
						if UnitHealth(sourceName) == UnitHealthMax(sourceName) then
							line:ReduceCD(0.75)
						end
					end)
				end
			end
		]]},
	{98008,	"SHAMAN,RAID",1,--Тотем духовной связи
		nil,nil,nil,{98008,180,6},
		isTalent=true,hideWithTalent=204293,cdDiff={381867,{-2,-4}}},
	{58875,	"SHAMAN,MOVE",3,--Поступь духа
		{58875,60,8},
		isTalent=true,cdDiff={381678,-7.5},ignoreUseWithAura=375256,changeCdWithAura={381756,"*0.85"}},
	{192063,"SHAMAN,MOVE",3,--Порыв ветра
		{192063,30,0},
		isTalent=true,cdDiff={381678,-5}},
	{79206,	"SHAMAN,MOVE",3,--Благосклонность предков
		{79206,120,15},
		isTalent=true,cdDiff={192088,-30},ignoreUseWithAura=375256,changeCdWithAura={381756,"*0.85"}},
	{51490,	"SHAMAN,UTIL",3,--Гром и молния
		{51490,30,0},
		isTalent=true,cdDiff={378779,-5,204403,-15}},
	{8143,	"SHAMAN,UTIL",1,--Тотем трепета
		{8143,60,10},nil,nil,nil,
		isTalent=true,cdDiff={381867,{-2,-4},338042,{-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15}}},
	{57994,	"SHAMAN,KICK",5,--Пронизывающий ветер
		{57994,12,0},nil,nil,nil,
		isTalent=true,cdDiff={329526,-3}},
	{108281,"SHAMAN",1,--Наставления предков
		{108281,120,10},
		isTalent=true},
	{378081,"SHAMAN",3,--Природная стремительность
		{378081,60,0},
		isTalent=true,startCdAfterAuraFade=378081},
	{207399,"SHAMAN,RAID",1,--Тотем защиты Предков
		nil,nil,nil,{207399,300,30},
		isTalent=true,cdDiff={381867,{-2,-4}}},
	{114051,"SHAMAN,DPS",3,--Перерождение
		nil,nil,{114051,180,15},nil,
		isTalent=true},
	{114052,"SHAMAN,HEAL",3,--Перерождение
		nil,nil,nil,{114052,180,15},
		isTalent=true},
	{114050,"SHAMAN,DPS",3,--Перерождение
		nil,{114050,180,15},nil,nil,
		isTalent=true},
	{207778,"SHAMAN",3,--Ливневый дождь
		nil,nil,nil,{207778,5,0},
		isTalent=true,
		CLEU_PREP=[[
			spell207778_var = {}
			spell207778_var_c = {}
		]],CLEU_SPELL_HEAL=[[
			if spellID == 207778 and session_gGUIDs[sourceName][207778] then
				local line = CDList[sourceName][207778]
				if line then
					local t = GetTime()
					if (spell207778_var[sourceName] or 0) < t then
						spell207778_var[sourceName] = t + 1
						spell207778_var_c[sourceName] = 0
					end

					if (amount - overhealing) > 0 then
						spell207778_var_c[sourceName] = spell207778_var_c[sourceName] + 1

						C_Timer.After(0.3,function()	--Await for actual cast, selfhealing event fired first
							line:ChangeCD(spell207778_var_c[sourceName] <= 6 and 5 or 0)
						end)
					end
				end
			end
		]]},
	{198838,"SHAMAN,HEAL",3,--Тотем земляной стены
		nil,nil,nil,{198838,60,15},
		isTalent=true,stopDurWithAuraFade=198839,cdDiff={381867,{-2,-4}}},
	{51485,	"SHAMAN,AOECC",3,--Тотем хватки земли
		{51485,60,20},
		isTalent=true,cdDiff={381867,{-2,-4}}},
	{320125,"SHAMAN",3,--Вторящий шок
		nil,{320125,30,0},nil,nil,
		isTalent=true},
	{196884,"SHAMAN",3,--Свирепый выпад
		nil,nil,{196884,30,0},nil,
		isTalent=true},
	{333974,"SHAMAN",3,--Кольцо огня
		nil,nil,{333974,15,0},nil,
		isTalent=true},
	{342240,"SHAMAN",3,--Ледяной клинок
		nil,nil,{342240,15,0},nil,
		isTalent=true},
	{210714,"SHAMAN",3,--Ледяная ярость
		nil,{210714,30,0},nil,nil,
		isTalent=true},
	{192222,"SHAMAN",3,--Тотем жидкой магмы
		nil,{192222,60,15},nil,nil,
		isTalent=true,cdDiff={381867,{-2,-4}}},
	{342243,"SHAMAN",3,--Статический разряд
		nil,{342243,30,0},nil,nil,
		isTalent=true},
	{191634,"SHAMAN,DPS",3,--Хранитель бурь
		nil,{191634,60,0},nil,nil,
		isTalent=true},
	{383009,"SHAMAN",3,--Хранитель бурь
		nil,nil,nil,{383009,60,0},
		isTalent=true},
	{197214,"SHAMAN,AOECC",3,--Раскол
		nil,nil,{197214,40,0},nil,
		isTalent=true},
	{320746,"SHAMAN",3,--Вздымающаяся земля
		nil,nil,nil,{320746,20,0},
		isTalent=true},
	{197995,"SHAMAN",3,--Родник
		nil,nil,nil,{197995,20,0},
		isTalent=true},
	{192077,"SHAMAN,RAIDSPEED",1,--Тотем ветряного порыва
		{192077,120,15},nil,nil,nil,
		isTalent=true,cdDiff={381867,{-2,-4}}},
	{383017,"SHAMAN,UTIL",3,--Тотем каменной кожи
		{383017,30,15},
		isTalent=true,cdDiff={381867,{-2,-4}}},
	{383019,"SHAMAN,UTIL",3,--Тотем безветрия
		{383019,60,20},
		isTalent=true,cdDiff={381867,{-2,-4}}},
	{383013,"SHAMAN,DISPEL",3,--Тотем противоядия
		{383013,45,6},
		isTalent=true,cdDiff={381867,{-2,-4}},
		CLEU_SPELL_AURA_REMOVED_DOSE=[[
			if spellID == 53390 and session_gGUIDs[sourceName][382030] then
				local line = CDList[sourceName][383013]
				if line then
					line:ReduceCD(0.5)
				end
			end
		]],CLEU_SPELL_AURA_REMOVED=[[
			if spellID == 53390 and session_gGUIDs[sourceName][382030] then
				local line = CDList[sourceName][383013]
				if line then
					line:ReduceCD(0.5)
				end
			end
		]]},
	{204331,"SHAMAN,PVP",3,--Тотем контрудара
		{204331,45,15},nil,nil,nil,
		isTalent=true,cdDiff={381867,{-2,-4}}},
	{210918,"SHAMAN,PVP",3,--Астральный облик
		nil,nil,{210918,45,0},nil,
		isTalent=true},
	{204336,"SHAMAN,PVP",3,--Тотем заземления
		{204336,30,3},nil,nil,nil,
		isTalent=true,cdDiff={381867,{-2,-4}}},
	{305483,"SHAMAN,CC",3,--Молния-лассо
		{305483,45,0},
		isTalent=true},
	{108285,"SHAMAN",3,--Возвращение тотемов
		{108285,180,0},
		isTalent=true,cdDiff={383011,-60},
		CLEU_PREP=[[
			TotemicRecallList = {
				[204336]=true,
				[204331]=true,
				[383013]=true,
				[383019]=true,
				[383017]=true,
				[192077]=true,
				[204330]=true,
				[157153]=true,
				[8143]=true,
				[192222]=true,
				[51485]=true,
				[198838]=true,
				[192058]=true,
				[2484]=true,
				[5394]=true,
			}
			TotemicRecall1,TotemicRecall2 = {},{}
		]],CLEU_SPELL_CAST_SUCCESS=[[
			if sourceName and spellID and TotemicRecallList[spellID] then
				TotemicRecall2[sourceName] = TotemicRecall1[sourceName]
				TotemicRecall1[sourceName] = spellID
			elseif spellID == 108285 and sourceName then
				local s = TotemicRecall1[sourceName] or 0
				local line = CDList[sourceName][s]
				if line then
					line:ResetCD()
				end
				if session_gGUIDs[sourceName][383012] then
					local s = TotemicRecall2[sourceName] or 0
					local line = CDList[sourceName][s]
					if line then
						line:ResetCD()
					end
				end
			end
		]]},
	{204330,"SHAMAN,PVP",3,--Тотем небесной ярости
		{204330,40,15},nil,nil,nil,
		isTalent=true,cdDiff={381867,{-2,-4}}},
	{204366,"SHAMAN,PVP",3,--Грозовой заряд
		nil,nil,{204366,45,0},nil,
		isTalent=true},
	{157153,"SHAMAN",3,--Тотем разразившегося ливня
		nil,nil,nil,{157153,45,15},
		cdDiff={381867,{-2,-4}}},
	{192249,"SHAMAN,DPS",3,--Элементаль бури
		nil,{192249,150,30},nil,nil,
		isTalent=true,durationDiff={338303,{"*1.35","*1.36","*1.37","*1.38","*1.39","*1.40","*1.41","*1.43","*1.44","*1.45","*1.46","*1.47","*1.48","*1.49","*1.50"}},cdDiff={296320,"*0.80"},
		CLEU_SPELL_DAMAGE=[[
			if spellID == 188389 and critical and session_gGUIDs[sourceName][336734] then
				local line = CDList[sourceName][192249]
				if line then
					line:ReduceCD(1)
				end
			end
		]]},
	{73685,	"SHAMAN",3,--Высвободить чары жизни
		nil,nil,nil,{73685,15,0},
		isTalent=true},
	{375982,"SHAMAN",3,--Первозданная волна
		{375982,45,0},
		isTalent=true,cdDiff={382046,-15}},


	{342245,"MAGE,DEF",3,--Манипуляции со временем
		{342245,60,10},
		isTalent=true,stopDurWithAuraFade={342246,110909},startCdAfterAuraApply={110909,342246},cdDiff={342249,-10}},
	{235313,"MAGE,DEF",3,--Пылающая преграда
		nil,nil,{235313,25,0},nil,
		isTalent=true},
	{1953,	"MAGE,MOVE",4,--Скачок
		{1953,15,0},nil,nil,nil,
		cdDiff={382268,{-1,-2},336636,{-2,-2.2,-2.4,-2.6,-2.8,-3,-3.2,-3.4,-3.6,-3.8,-4,-4.2,-4.4,-4.6,-4.8}},hideWithTalent=212653,ignoreUseWithAura=375240,changeCdWithAura={381750,"*0.85"}},
	{190356,"MAGE",3,--Снежная буря
		nil,nil,nil,{190356,8,0},
		isTalent=true,changeCdWithHaste=true},
	{235219,"MAGE",3,--Холодная хватка
		nil,nil,nil,{235219,300,0},
		isTalent=true},
	{190319,"MAGE,DPS",3,--Возгорание
		nil,nil,{190319,120,12},nil,
		isTalent=true,cdDiff={296320,"*0.80"},durationDiff={383659,"*0.5"},reduceCdAfterCast={{133,203283},-3},
		CLEU_SPELL_DAMAGE=[[
			if (spellID == 11366 or spellID == 133 or spellID == 108853) and critical and session_gGUIDs[sourceName][155148] then
				local line = CDList[sourceName][190319]
				if line then
					line:ReduceCD(1)
				end
			elseif spellID == 257542 and session_gGUIDs[sourceName][155148] then
				if not spell155148_var1 then
					spell155148_var1 = C_Timer.NewTimer(0.3,function()
						spell155148_var1 = nil
						if spell155148_var2 then
							local line = CDList[sourceName][190319]
							if line then
								line:ReduceCD(1)
							end
						end
						spell155148_var2 = nil
					end)
				end
				spell155148_var2 = critical
			end
		]]},
	{120,	"MAGE",3,--Конус холода
		nil,nil,nil,{120,12,0},
		resetBy={{122,206431},235219}},
	{190336,"MAGE",3,--Сотворение яств
		{190336,15,0},nil,nil,nil},
	{383121,"MAGE,AOECC",3,--Массовое превращение
		{383121,60,0},nil,nil,nil,
		isTalent=true},
	{2139,	"MAGE,KICK",5,--Антимагия
		{2139,24,0},nil,nil,nil,
		CLEU_SPELL_INTERRUPT=[[
			if sourceName and session_gGUIDs[sourceName][382297] and spellID == 2139 then
				local line = CDList[sourceName][2139]
				if line then
					line:ReduceCD(4)
				end
			end
			if sourceName and session_gGUIDs[sourceName][336777] and spellID == 2139 then
				local line = CDList[sourceName][2139]
				if line then
					local soulbind_rank = _db.soulbind_rank[sourceName][336777] or SOULBIND_DEF_RANK_NOW
					local tr = {2.5,2.8,3.0,3.3,3.5,3.8,4.0,4.3,4.5,4.8,5.0,5.3,5.5,5.8,6.0}
					local timeReduce = tr[soulbind_rank] or 3.5

					line:ReduceCD(timeReduce)
				end
			end
		]]},
	{31661,	"MAGE",3,--Дыхание дракона
		{31661,45,0},
		isTalent=true},
	{12051,	"MAGE",3,--Прилив сил
		nil,{12051,90,6},nil,nil,
		isTalent=true,hasCharges=273330,changeDurWithHaste=true},
	{376103,"MAGE",3,--Сияющая искра
		nil,{376103,30,0},nil,nil,
		isTalent=true},
	{122,	"MAGE",3,--Кольцо льда
		{122,30,0},nil,nil,nil,
		hasCharges=205036,resetBy=235219},
	{84714,	"MAGE",3,--Ледяной шар
		nil,nil,nil,{84714,60,0},
		isTalent=true},
	{11426,	"MAGE,DEF",3,--Ледяная преграда
		nil,nil,nil,{11426,25,0},
		isTalent=true,stopDurWithAuraFade=11426,resetBy=235219},
	{45438,	"MAGE,DEF",3,--Ледяная глыба
		{45438,240,10},nil,nil,nil,
		isTalent=true,cdDiff={336613,{-25,-28,-30,-33,-35,-38,-40,-43,-45,-48,-50,-53,-55,-58,-60}},stopDurWithAuraFade=45438,resetBy=235219},
	{12472,	"MAGE,DPS",3,--Стылая кровь
		nil,nil,nil,{12472,180,25},
		isTalent=true,durationDiff={155149,10},cdDiff={296320,"*0.80"},hideWithTalent=198144,
		CLEU_SPELL_CAST_SUCCESS=[[
			if sourceName and (spellID == 30455 or spellID == 116 or spellID == 44614) and session_gGUIDs[sourceName][378433] then
				local line = CDList[sourceName][12472]
				if line then
					line:ReduceCD(1)
				end
			end	
		]],CLEU_SPELL_DAMAGE=[[
			if critical and sourceGUID and isMage[sourceGUID] and sourceName and session_gGUIDs[sourceName][336522] and IsAuraActive(sourceName,12472) then
				if spellID ~= 190357 and spellID ~= 327498 and spellID ~= 205021 and spellID ~= 257538 then
					local line = CDList[sourceName][12472]
					if line then
						local soulbind_rank = _db.soulbind_rank[sourceName][336522] or SOULBIND_DEF_RANK_NOW
						local timeReduce = 0.75 + (soulbind_rank - 1) * 0.075

						line:ReduceCD(timeReduce)
					end
				end
			end
		]]},
	{66,	"MAGE,DEF",4,--Невидимость
		{66,300,20},nil,nil,nil,
		isTalent=true,cdDiff={210476,-45}},
	{110959,"MAGE,DEF",4,--Великая невидимость
		{110959,120,0},nil,nil,nil,
		isTalent=true},
	{55342,	"MAGE,DEF",3,--Зеркальное изображение
		{55342,120,40},nil,nil,nil,
		isTalent=true},
	{257541,"MAGE",3,--Пламя феникса
		nil,nil,{257541,25,0},nil,
		isTalent=true,hasCharges=1,
		CLEU_SPELL_DAMAGE=[[
			if (spellID == 11366 or spellID == 108853 or spellID == 2948 or spellID == 133) and critical and session_gGUIDs[sourceName][342344] then
				local line = CDList[sourceName][257541]
				if line then
					line:ReduceCD(1)
				end
			end
		]]},
	{382440,"MAGE",3,--Переходящая сила
		{382440,60,0},
		isTalent=true},
	{205025,"MAGE",3,--Величие разума
		nil,{205025,45,0},nil,nil,
		isTalent=true,startCdAfterAuraFade=205025},
	{235450,"MAGE,DEF",4,--Призматический барьер
		nil,{235450,25,0},nil,nil,
		isTalent=true,cdDiff={235463,"*0"}},
	{475,	"MAGE,DISPEL",5,--Снятие проклятия
		{475,8,0},nil,nil,nil,
		isTalent=true,isDispel=true},
	{31687,	"MAGE",3,--Призыв элементаля воды
		nil,nil,nil,{31687,30,0},
		hideWithTalent=205024},
	{80353,	"MAGE,UTIL",3,--Искажение времени
		{80353,300,40},nil,nil,nil},
	{321507,"MAGE",3,--Касание мага
		nil,{321507,45,0},nil,nil},
	{153626,"MAGE",3,--Чародейский шар
		nil,{153626,20,0},nil,nil,
		isTalent=true,hasCharges=384651},
	{365350,"MAGE",3,--Чародейский выброс
		nil,{365350,90,12},nil,nil,
		isTalent=true,durationDiff={321739,3}},
	{157981,"MAGE",3,--Взрывная волна
		{157981,30,0},
		isTalent=true,cdDiff={389627,-5}},
	{153595,"MAGE",3,--Кометная буря
		nil,nil,nil,{153595,30,0},
		isTalent=true},
	{257537,"MAGE",3,--Полярная стрела
		nil,nil,nil,{257537,45,0},
		isTalent=true},
	{157997,"MAGE",3,--Кольцо обледенения
		{157997,25,0},
		isTalent=true},
	{44457,	"MAGE",3,--Живая бомба
		nil,nil,{44457,12,0},nil,
		isTalent=true,changeCdWithHaste=true},
	{153561,"MAGE",3,--Метеор
		{153561,45,0},
		isTalent=true},
	{389713,"MAGE",3,--Перемещение
		{389713,45,0},
		isTalent=true},
	{205021,"MAGE",3,--Морозный луч
		nil,nil,nil,{205021,75,0},
		isTalent=true},
	{113724,"MAGE,AOECC",3,--Кольцо мороза
		{113724,45,10},nil,nil,nil,
		isTalent=true},
	{116011,"MAGE,DPS",3,--Руна мощи
		{116011,45,15},nil,nil,nil,
		isTalent=true,hasCharges=1},
	{157980,"MAGE",3,--Сверхновая
		nil,{157980,25,0},nil,nil,
		isTalent=true},
	{203286,"MAGE,PVP",3,--Большая огненная глыба
		nil,nil,{203286,15,0},nil,
		isTalent=true},
	{198144,"MAGE,PVP",3,--Ледяной облик
		nil,nil,nil,{198144,60,15},
		isTalent=true},
	{198158,"MAGE,PVP",3,--Массовая невидимость
		nil,{198158,60,5},nil,nil,
		isTalent=true},
	{198111,"MAGE,PVP",3,--Барьер времени
		nil,{198111,45,4},nil,nil,
		isTalent=true},
	{212653,"MAGE,MOVE",4,--Мерцание
		{212653,25,0},nil,nil,nil,
		isTalent=true,hasCharges=1,cdDiff={382268,{-1,-2},336636,{-2,-2.2,-2.4,-2.6,-2.8,-3,-3.2,-3.4,-3.6,-3.8,-4,-4.2,-4.4,-4.6,-4.8}},ignoreUseWithAura=375240,changeCdWithAura={381750,"*0.85"}},


	{104316,"WARLOCK",3,--Призыв зловещих охотников
		nil,nil,{104316,20,0},nil,
		isTalent=true},
	{29893,	"WARLOCK",3,--Создание источника душ
		{29893,120,0},nil,nil,nil},
	{48018,	"WARLOCK",3,--Демонический круг
		{48018,10,0},nil,nil,nil},
	{48020,	"WARLOCK",3,--Демонический круг: телепортация
		{48020,30,0},nil,nil,nil,
		ignoreUseWithAura=375234,changeCdWithAura={381757,"*0.85"}},
	{111771,"WARLOCK",3,--Демонические врата
		{111771,10,0},
		isTalent=true},
	{333889,"WARLOCK",3,--Власть Скверны
		{333889,180,0},
		isTalent=true,cdDiff={339130,{-48,-51,-54,-57,-60,-63,-66,-69,-72,-75,-78,-81,-84,-87,-90},386113,{-30,-60}}},
	{80240,	"WARLOCK,DPS",3,--Хаос
		nil,nil,nil,{80240,30,12},
		isTalent=true,hideWithTalent=200546},
	{342601,"WARLOCK",3,--Ритуал рока
		{342601,3600,0},nil,nil,nil},
	{698,	"WARLOCK",3,--Ритуал призыва
		{698,120,0},nil,nil,nil},
	{30283,	"WARLOCK,AOECC",1,--Неистовство Тьмы
		{30283,60,3},
		isTalent=true,cdDiff={264874,-15}},
	{20707,	"WARLOCK,RES",3,--Камень души
		{20707,600,0},nil,nil,nil,
		isBattleRes=true},
	{205180,"WARLOCK,DPS",3,--Призыв созерцателя тьмы
		nil,{205180,120,20},nil,nil,
		isTalent=true,cdDiff={296320,"*0.80",334183,-60},reduceCdAfterCast={{278350,337020},-2,{267211,337020},-2,{688,337020},-2,{116858,337020},-4,{267217,337020},-2,{5740,337020},-6,{111898,337020},-2,{27243,337020},-2,{105174,337020},-4,{104316,337020},-4,{691,337020},-2,{712,337020},-2,{697,337020},-2,{342601,337020},-2,{324536,337020},-2,{264119,337020},-2,{17877,337020},-2,{278350,387084},-1.5,{267211,387084},-1.5,{688,387084},-1.5,{116858,387084},-3,{267217,387084},-1.5,{5740,387084},-6,{111898,387084},-1.5,{27243,387084},-1.5,{105174,387084},-3,{104316,387084},-3,{691,387084},-1.5,{712,387084},-1.5,{697,387084},-1.5,{342601,387084},-1.5,{324536,387084},-1.5,{264119,387084},-1.5,{17877,387084},-1.5}},
	{265187,"WARLOCK,DPS",3,--Призыв демонического тирана
		nil,nil,{265187,90,15},nil,
		isTalent=true,cdDiff={296320,"*0.80"},reduceCdAfterCast={{278350,387084},-1.5,{267211,387084},-1.5,{688,387084},-1.5,{116858,387084},-3,{267217,387084},-1.5,{5740,387084},-6,{111898,387084},-1.5,{27243,387084},-1.5,{105174,387084},-3,{104316,387084},-3,{691,387084},-1.5,{712,387084},-1.5,{697,387084},-1.5,{342601,387084},-1.5,{324536,387084},-1.5,{264119,387084},-1.5,{17877,387084},-1.5}},
	{1122,	"WARLOCK,DPS",3,--Призыв инфернала
		nil,nil,nil,{1122,180,30},
		isTalent=true,cdDiff={296320,"*0.80"},reduceCdAfterCast={{278350,337020},-0.6,{278350,337020},-1.5,{267211,337020},-0.6,{267211,337020},-1.5,{688,337020},-0.6,{688,337020},-1.5,{116858,337020},-1.2,{116858,337020},-3,{267217,337020},-0.6,{267217,337020},-1.5,{5740,337020},-1.8,{5740,337020},-4.5,{111898,337020},-0.6,{111898,337020},-1.5,{27243,337020},-0.6,{27243,337020},-1.5,{105174,337020},-1.2,{105174,337020},-3,{104316,337020},-1.2,{104316,337020},-3,{691,337020},-0.6,{691,337020},-1.5,{712,337020},-0.6,{712,337020},-1.5,{697,337020},-0.6,{697,337020},-1.5,{342601,337020},-0.6,{342601,337020},-1.5,{324536,337020},-0.6,{324536,337020},-1.5,{264119,337020},-0.6,{264119,337020},-1.5,{17877,337020},-0.6,{17877,337020},-1.5,
			{278350,387084},-1.5,{267211,387084},-1.5,{688,387084},-1.5,{116858,387084},-3,{267217,387084},-1.5,{5740,387084},-4.5,{111898,387084},-1.5,{27243,387084},-1.5,{105174,387084},-3,{104316,387084},-3,{691,387084},-1.5,{712,387084},-1.5,{697,387084},-1.5,{342601,387084},-1.5,{324536,387084},-1.5,{264119,387084},-1.5,{17877,387084},-1.5}},
	{104773,"WARLOCK,DEF",4,--Твердая решимость
		{104773,180,8},
		cdDiff={386659,-45},
		CLEU_PREP = [[
			spell339272_var = {}
		]],CLEU_SPELL_DAMAGE=[[
			if destGUID and isWarlock[destGUID] and destName and session_gGUIDs[destName][339272] then
				local maxHP = UnitHealthMax(destName)
				if maxHP ~= 0 and ((amount / maxHP) > 0.05) then
					local now = GetTime()
					if not spell339272_var[destGUID] or (now > spell339272_var[destGUID]) then
						local soulbind_rank = _db.soulbind_rank[destName][339272] or SOULBIND_DEF_RANK_NOW
						spell339272_var[destGUID] = now + (31 - soulbind_rank)
						local line = CDList[destName][104773]
						if line then
							line:ReduceCD(10)
						end
					end
				end
			end
		]]},
	{386997,"WARLOCK",3,--Гниение души
		nil,{386997,60,0},nil,nil,
		isTalent=true,
		CLEU_SPELL_DAMAGE=[[
			if spellID == 316099 and sourceName and session_gGUIDs[sourceName][389630] then
				local line = CDList[sourceName][386997]
				if line then
					local talent_rank = _db.talent_classic_rank[sourceName][389630] or 2

					line:ReduceCD(talent_rank * 0.5)
				end
			end
		]]},
	{386833,"WARLOCK",3,--Гильотина
		nil,nil,{386833,45,8},nil,
		isTalent=true},
	{267211,"WARLOCK",3,--Взрывные желчегнусы
		nil,nil,{267211,30,0},nil,
		isTalent=true},
	{152108,"WARLOCK",3,--Катаклизм
		nil,nil,nil,{152108,30,0},
		isTalent=true},
	{196447,"WARLOCK",3,--Направленный демонический огонь
		nil,nil,nil,{196447,25,0},
		isTalent=true},
	{108416,"WARLOCK,DEF",3,--Темный пакт
		{108416,60,0},
		isTalent=true,cdDiff={386686,-15}},
	{113858,"WARLOCK,DPS",3,--Черная душа: нестабильность
		nil,nil,nil,{113858,120,20},
		isTalent=true},
	{113860,"WARLOCK,DPS",3,--Черная душа: страдание
		nil,{113860,120,20},nil,nil,
		isTalent=true},
	{267171,"WARLOCK",3,--Демоническая сила
		nil,nil,{267171,60,0},nil,
		isTalent=true},
	{108503,"WARLOCK",3,--Гримуар жертвоприношения
		nil,{108503,30,0},nil,{108503,30,0},
		isTalent=true},
	{111898,"WARLOCK",3,--Гримуар: страж Скверны
		nil,nil,{111898,120,0},nil,
		isTalent=true},
	{48181,	"WARLOCK",3,--Блуждающий дух
		nil,{48181,15,0},nil,nil,
		isTalent=true},
	{5484,	"WARLOCK,CC",3,--Вой ужаса
		{5484,40,0},
		isTalent=true},
	{6789,	"WARLOCK,CC",3,--Лик тлена
		{6789,45,0},
		isTalent=true},
	{267217,"WARLOCK",3,--Врата Пустоты
		nil,nil,{267217,180,15},nil,
		isTalent=true},
	{205179,"WARLOCK",3,--Призрачная сингулярность
		nil,{205179,45,0},nil,nil,
		isTalent=true},
	{264130,"WARLOCK",3,--Вытягивание сил
		nil,nil,{264130,30,0},nil,
		isTalent=true},
	{6353,	"WARLOCK",3,--Ожог души
		nil,nil,nil,{6353,45,0},
		isTalent=true},
	{264057,"WARLOCK",3,--Удар души
		nil,nil,{264057,10,0},nil,
		isTalent=true},
	{264119,"WARLOCK",3,--Призыв мерзотня
		nil,nil,{264119,45,0},nil,
		isTalent=true},
	{278350,"WARLOCK",3,--Пагуба
		nil,{278350,30,0},nil,nil,
		isTalent=true},
	{132409,"WARLOCK,KICK",3,--Запрет чар
		nil,{132409,24,0},nil,{132409,24,0},
		isTalent=true},
	{328774,"WARLOCK",3,--Усиление проклятия
		{328774,30,0},
		isTalent=true,cdDiff={387972,-10}},
	{199954,"WARLOCK,PVP",3,--Проклятие хрупкости
		{199954,45,10},nil,nil,nil,
		isTalent=true},
	{200546,"WARLOCK,PVP",3,--Проклятие хаоса
		nil,nil,nil,{200546,45,12},
		isTalent=true},
	{234877,"WARLOCK,PVP",3,--Проклятие теней
		nil,{234877,30,0},nil,nil,
		isTalent=true},
	{212459,"WARLOCK,PVP",3,--Призыв повелителя Скверны
		nil,nil,{212459,90,15},nil,
		isTalent=true},
	{212619,"WARLOCK,PVP",3,--Вызов охотника Скверны
		nil,nil,{212619,24,0},nil,
		isTalent=true},
	{201996,"WARLOCK,PVP",3,--Вызов наблюдателя
		nil,nil,{201996,90,20},nil,
		isTalent=true},
	{221703,"WARLOCK,PVP",3,--Круг заклинателей
		{221703,60,8},nil,nil,nil,
		isTalent=true},
	{264106,"WARLOCK,PVP",3,--Стрела смерти
		nil,{264106,45,0},nil,nil,
		isTalent=true},
	{212295,"WARLOCK,PVP",3,--Оберег Пустоты
		{212295,45,3},nil,nil,nil,
		isTalent=true},
	{344566,"WARLOCK,PVP",3,--Быстрое заражение
		nil,{344566,30,0},nil,nil,
		isTalent=true},
	{212623,"WARLOCK,PVP",3,--Опаляющая магия
		nil,nil,{212623,15,0},nil,
		isTalent=true},
	{212356,"WARLOCK,PVP",3,--???
		nil,{212356,60,0},nil,nil,
		isTalent=true},


	{115181,"MONK",3,--Пламенное дыхание
		nil,{115181,15,0},nil,nil,
		isTalent=true},
	{322507,"MONK",3,--Божественный отвар
		nil,{322507,60,0},nil,nil,
		isTalent=true,cdDiff={325093,"*0.8"}},
	{324312,"MONK",3,--Столкновение
		nil,{324312,30,0},nil,nil,
		isTalent=true},
	{218164,"MONK,DISPEL",5,--Детоксикация
		{218164,8,0},nil,nil,nil,
		isTalent=true,baseForSpec=270,sameSpell={218164,115450},isDispel=true},
	{191837,"MONK",3,--Купель сущности
		nil,nil,nil,{191837,12,0},
		isTalent=true},
	{322101,"MONK",3,--Устранение вреда
		{322101,15,0},nil,nil,nil},
	{113656,"MONK",3,--Неистовые кулаки
		nil,nil,{113656,24,0},nil,
		isTalent=true,changeDurWithHaste=true,changeCdWithHaste=true,
		CLEU_SPELL_DAMAGE=[[
			if spellID == 107428 and critical and (session_gGUIDs[sourceName][337481] or session_gGUIDs[sourceName][392993]) then
				local line = CDList[sourceName][113656]
				if line then
					line:ReduceCD(4)
				end
			end
		]]},
	{101545,"MONK,MOVE",3,--Удар летящего змея
		nil,nil,{101545,25,0},nil,
		isTalent=true},
	{115203,"MONK,DEFTANK,DEF",4,--Укрепляющий отвар
		{115203,360,15},
		isTalent=true,cdDiff={388813,-120,296320,"*0.80",202107,"*0.5"},sameSpell={115203,243435},reduceCdAfterCast={121253,-3,{121253,196736},-2}},
	{122281,"MONK",3,--Целебный эликсир
		nil,{122281,30,0},nil,{122281,30,0},
		isTalent=true,hasCharges=1},
	{132578,"MONK",3,--Призыв Нюцзао, Черного Быка
		nil,{132578,180,0},nil,nil,
		isTalent=true,reduceCdAfterCast={{121253,337264},-0.5,{322729,337264},-0.5,{205523,337264},-0.5}},
	{123904,"MONK,DPS",3,--Призыв Сюэня, Белого Тигра
		nil,nil,{123904,120,20},nil,
		isTalent=true},
	{322118,"MONK,HEAL",3,--Призыв Юй-лун, Нефритовой Змеи
		nil,nil,nil,{322118,180,25},
		isTalent=true,hideWithTalent=325197,cdDiff={388212,-120},durationDiff={388212,-12},reduceCdAfterCast={{115151,336773},-0.3,{116670,336773},-0.3,{322101,336773},-0.3,{124682,336773},-0.3,{115151,388031},-0.3,{116670,388031},-0.3,{322101,388031},-0.3,{124682,388031},-0.3}},
	{119381,"MONK,AOECC",1,--Круговой удар ногой
		{119381,60,3},nil,nil,nil,
		cdDiff={264348,{-10,-20}}},
	{116849,"MONK,DEFTAR",2,--Исцеляющий кокон
		nil,nil,nil,{116849,120,12},
		isTalent=true,cdDiff={277667,-20,202424,-40},stopDurWithAuraFade=116849},
	{115078,"MONK,CC",3,--Паралич
		{115078,45,0},
		isTalent=true,cdDiff={344359,-15}},
	{115546,"MONK,TAUNT",5,--Вызов
		{115546,8,0},nil,nil,nil,
		hideWithTalent=207025},
	{119582,"MONK",3,--Очищающий отвар
		nil,{119582,20,0},nil,nil,
		isTalent=true,hasCharges=343743,changeCdWithHaste=true,sameSpell={115308,119582},cdDiff={325093,"*0.8"}},
	{115310,"MONK,RAID",1,--Восстановление сил
		nil,nil,nil,{115310,180,0},
		isTalent=true,cdDiff={296320,"*0.80"},reduceCdAfterCast={{107428,337099},-1,{107428,388551},-1},
		CLEU_SPELL_HEAL=[[
			if spellID == 116670 and critical and (session_gGUIDs[sourceName][278576] or session_gGUIDs[sourceName][388551]) then
				local line = CDList[sourceName][115310]
				if line then
					line:ReduceCD(1)
				end
			end
		]]},
	{388615,"MONK,RAID",1,--Восстановление здоровья
		nil,nil,nil,{388615,180,0},
		isTalent=true,reduceCdAfterCast={{107428,388551},-1},
		CLEU_SPELL_HEAL=[[
			if spellID == 116670 and critical and (session_gGUIDs[sourceName][278576] or session_gGUIDs[sourceName][388551]) then
				local line = CDList[sourceName][388615]
				if line then
					line:ReduceCD(1)
				end
			end
		]]},
	{107428,"MONK",3,--Удар восходящего солнца
		{107428,10,0},
		isTalent=true,changeCdWithHaste=true},
	{109132,"MONK,MOVE",3,--Кувырок
		{107428,20,0},nil,nil,nil,
		hasCharges=328669,cdDiff={115173,-5},ignoreUseWithAura=375252,changeCdWithAura={381751,"*0.85"},hideWithTalent=115008},
	{116705,"MONK,KICK",3,--Рука-копье
		{116705,15,0},
		isTalent=true},
	{137639,"MONK,DPS",3,--Буря, земля и огонь
		nil,nil,{137639,90,15},nil,
		isTalent=true,hasCharges=1,cdDiff={296320,"*0.80"},hideWithTalent=152173,reduceCdAfterCast={{107428,280197},-1,{101546,280197},-0.5,{100784,280197},-0.5,{113656,280197},-1.5}},
	{116680,"MONK",3,--Громовой чай
		nil,nil,nil,{116680,30,0},
		isTalent=true,startCdAfterAuraFade=116680},
	{322109,"MONK",3,--Смертельное касание
		{322109,180,0},nil,nil,nil,
		cdDiff={337296,-120,394123,{-45,-90}}},
	{122470,"MONK,DEF",3,--Закон кармы
		nil,nil,{122470,90,10},nil,
		isTalent=true,
		CLEU_SPELL_DAMAGE=[[
			if spellID == 322109 and session_gGUIDs[sourceName][345829] and module.IsPvpTalentsOn(sourceName) then
				if overkill and overkill > 0 and bit.band(destFlags or 0,0x400) > 0 then
					local line = CDList[sourceName][122470]
					if line then
						line:ReduceCD(60)
					end
				end
			end
		]]},
	{392983,"MONK",3,--Удар Владыки Ветра
		nil,nil,{392983,40,0},nil,
		isTalent=true},
	{101643,"MONK",4,--Трансцендентность
		{101643,10,0},
		isTalent=true},
	{119996,"MONK,MOVE",4,--Трансцендентность: перенос
		{119996,45,0},nil,nil,nil,
		cdDiff={216255,-20}},
	{115176,"MONK,DEFTANK",4,--Дзен-медитация
		nil,{115176,300,8},nil,nil,
		isTalent=true,cdDiff={387035,"*0.75",202200,"*0.25"},stopDurWithAuraFade=115176},
	{126892,"MONK",3,--Духовное путешествие
		{126892,60,0},nil,nil,nil},
	{115399,"MONK",3,--Отвар Черного Быка
		nil,{115399,120,0},nil,nil,
		isTalent=true},
	{123986,"MONK",3,--Выброс ци
		{123986,30,0},
		isTalent=true},
	{115098,"MONK",3,--Волна ци
		{115098,15,0},
		isTalent=true},
	{122278,"MONK,DEF",3,--Смягчение удара
		{122278,120,10},
		isTalent=true},
	{122783,"MONK,DEF",4,--Распыление магии
		{122783,90,6},
		isTalent=true},
	{115288,"MONK",3,--Будоражащий отвар
		nil,nil,{115288,60,5},nil,
		isTalent=true},
	{325153,"MONK",3,--Взрывной бочонок
		nil,{325153,60,0},nil,nil,
		isTalent=true},
	{261947,"MONK",3,--Кулак Белого Тигра
		nil,nil,{261947,30,0},nil,
		isTalent=true},
	{325197,"MONK,HEAL",3,--Призыв Чи-Цзи, Красного Журавля
		nil,nil,nil,{325197,180,25},
		isTalent=true,cdDiff={388212,-120},durationDiff={388212,-12},reduceCdAfterCast={{115151,336773},-0.3,{116670,336773},-0.3,{322101,336773},-0.3,{124682,336773},-0.3,{115151,388031},-0.3,{116670,388031},-0.3,{322101,388031},-0.3,{124682,388031},-0.3}},
	{197908,"MONK,HEAL",3,--Маначай
		nil,nil,nil,{197908,90,10},
		isTalent=true},
	{116844,"MONK,UTIL",1,--Круг мира
		{116844,45,5},
		isTalent=true},
	{152173,"MONK,DPS",3,--Безмятежность
		nil,nil,{152173,90,12},nil,
		isTalent=true,cdDiff={296320,"*0.80"}},
	{198898,"MONK",3,--Песнь Чи-Цзи
		nil,nil,nil,{198898,30,0},
		isTalent=true},
	{115315,"MONK",3,--Призыв статуи Черного Быка
		{115315,10,0},
		isTalent=true},
	{388686,"MONK",3,--Призыв статуи белого тигра
		{388686,120,30},
		isTalent=true},
	{115313,"MONK",3,--Призыв статуи Нефритовой Змеи
		{115313,10,0},
		isTalent=true},
	{116841,"MONK,UTIL,RAIDSPEED",2,--Тигриное рвение
		{116841,30,6},nil,nil,nil,
		isTalent=true},
	{152175,"MONK",3,--Удар крутящегося дракона
		nil,nil,{152175,24,0},nil,
		isTalent=true,changeCdWithHaste=true},
	{207025,"MONK,PVP",3,--Осуждение
		nil,{207025,20,0},nil,nil,
		isTalent=true},
	{202162,"MONK,PVP",3,--Отведение ударов
		nil,{202162,45,15},nil,nil,
		isTalent=true},
	{202335,"MONK,PVP",3,--Пара бочек
		nil,{202335,45,0},nil,nil,
		isTalent=true},
	{233759,"MONK,PVP",3,--Захват оружия
		nil,nil,{233759,45,6},{233759,45,6},
		isTalent=true},
	{202370,"MONK,PVP",3,--Удар могучего быка
		nil,{202370,30,0},nil,nil,
		isTalent=true},
	{209584,"MONK,PVP",3,--Чай дзен-концентрации
		nil,nil,{209584,45,5},nil,
		isTalent=true},
	{115008,"MONK,MOVE",4,--Ци-полет
		{115008,20,0},nil,nil,nil,
		isTalent=true,hasCharges=328669,ignoreUseWithAura=375252,changeCdWithAura={381751,"*0.85"}},
	{386276,"MONK",3,--Отвар из костяной пыли
		{386276,60,10},
		isTalent=true,
		CLEU_PREP=[[
			spell386941_var = {}
			spell386941_var_c = {}
		]],CLEU_SPELL_HEAL=[[
			if spellID == 325218 and session_gGUIDs[sourceName][386941] then
				local line = CDList[sourceName][386276]
				if line then
					if timestamp - (spell386941_var[sourceName] or 0) > 20 then
						spell386941_var[sourceName] = timestamp
						spell386941_var_c[sourceName] = 0
					end
					spell386941_var_c[sourceName] = spell386941_var_c[sourceName] + 1
					if spell386941_var_c[sourceName] <= 5 then
						line:ReduceCD(0.5)
					end
				end
			end
		]],CLEU_SPELL_DAMAGE=[[
			if spellID == 325218 and session_gGUIDs[sourceName][386941] then
				local line = CDList[sourceName][386276]
				if line then
					if timestamp - (spell386941_var[sourceName] or 0) > 20 then
						spell386941_var[sourceName] = timestamp
						spell386941_var_c[sourceName] = 0
					end
					spell386941_var_c[sourceName] = spell386941_var_c[sourceName] + 1
					if spell386941_var_c[sourceName] <= 5 then
						line:ReduceCD(0.5)
					end
				end
			end
		]]},
	{388193,"COVENANTS,MONK",3,--Волшебная линия
		nil,nil,{388193,30,0},{388193,30,0},
		isTalent=true},


	{22812,	"DRUID,DEFTANK,DEF",4,--Дубовая кожа
		{22812,60,8},nil,nil,nil,nil,
		durationDiff={329800,8,327993,4,393611,1},cdDiff={203965,{"*0.85","*0.7"},340529,{"*0.9","*0.89","*0.88","*0.87","*0.86","*0.85","*0.84","*0.83","*0.82","*0.81","*0.80","*0.79","*0.78","*0.76"}}},
	{50334,	"DRUID,DPS",3,--Берсерк
		nil,nil,nil,{50334,180,15},nil,
		cdDiff={339062,-30,329802,-54},hideWithTalent=102558},
	{106951,"DRUID,DPS",3,--Берсерк
		nil,nil,{106951,180,15},nil,nil,
		isTalent=true,cdDiff={296320,"*0.80",329802,-54},hideWithTalent=102543,reduceCdAfterCast={{274837,340053,103},-0.2,{106785,340053,103},-0.2,{202028,340053,103},-0.2,{5221,340053,103},-0.2,{1822,340053,103},-0.2,{106830,340053,103},-0.2}},
	{194223,"DRUID,DPS",3,--Парад планет
		nil,{194223,180,20},nil,nil,nil,
		isTalent=true,durationDiff={340706,{5,5.5,6,6.5,7,7.5,8,8.5,9,9.5,10,10.5,11,11.5,12}},cdDiff={296320,"*0.80",329802,-54},hideWithTalent=102560},
	{88747,"DRUID,DPS",3,--Дикий гриб
		nil,{88747,30,0},nil,nil,nil,
		isTalent=true},
	{391528,"DRUID,DPS",3,--Созыв духов
		{391528,120,0},
		isTalent=true,cdDiff={391548,"*0.5",393991,"*0.5",393371,"*0.5",393414,"*0.5"}},
	{1850,	"DRUID,MOVE",4,--Порыв
		{1850,120,10},nil,nil,nil,nil,
		hideWithTalent=252216,ignoreUseWithAura=375230,changeCdWithAura={381746,"*0.85"}},
	{22842,	"DRUID,DEFTANK",4,--Неистовое восстановление
		{22842,36,3},nil,nil,nil,nil,
		isTalent=true,baseForSpec=104,hasCharges=273048,changeCdWithHaste=true,
		CLEU_PREP=[[
			berserk = {}
		]],CLEU_SPELL_AURA_APPLIED=[[
			if spellID == 50334 and destName then	--Berserk
				if berserk[destName] then
					berserk[destName]:Cancel()
				end
				berserk[destName] = C_Timer.NewTicker(1,function()
					local updateReq
					local line = CDList[destName][22842]
					if line then
						line:ReduceCD( (1 + (UnitSpellHaste(destName) or 0)/100)*3 )
					end
				end, 15)
			end
		]],CLEU_SPELL_AURA_REMOVED=[[
			if spellID == 50334 and destName then	--Berserk
				C_Timer.After(.5,function()
					if berserk[destName] then
						berserk[destName]:Cancel()
					end
				end)
			end
		]]},
	{6795,	"DRUID,TAUNT",5,--Рык
		{6795,8,0},nil,nil,nil,nil,
		hideWithTalent=207017},
	{99,	"DRUID,CC",3,--Парализующий рык
		{99,30,0},nil,nil,nil,nil,
		isTalent=true},
	{29166,	"DRUID,HEALUTIL",2,--Озарение
		{29166,180,10},
		isTalent=true,
		CLEU_SPELL_HEAL=[[
			if spellID == 48438 and session_gGUIDs[sourceName][287251] then
				local line = CDList[sourceName][29166]
				if line then
					if (amount - overhealing) == 0 then
						line:ReduceCD(1)
					end
				end
			end
		]]},
	{102342,"DRUID,DEFTAR",2,--Железная кора
		nil,nil,nil,nil,{102342,90,12},
		isTalent=true,cdDiff={382552,-20}},
	{22570,	"DRUID",3,--Калечение
		{22570,20,0},
		isTalent=true},
	{88423,	"DRUID,DISPEL",5,--Природный целитель
		nil,nil,nil,nil,{88423,8,0},
		isDispel=true},
	{132158,"DRUID",3,--Природная стремительность
		nil,nil,nil,nil,{132158,60,0},
		isTalent=true,cdDiff={382550,-12,340550,{"*0.9","*0.89","*0.88","*0.87","*0.86","*0.85","*0.84","*0.83","*0.82","*0.81","*0.80","*0.79","*0.78","*0.76"}},startCdAfterAuraFade=132158},
	{20484,	"DRUID,RES",1,--Возрождение
		{20484,600,0},nil,nil,nil,nil,
		isBattleRes=true},
	{2782,	"DRUID,DISPEL",5,--Снятие порчи
		nil,{2782,8,0},{2782,8,0},{2782,8,0},nil,
		isTalent=true,isDispel=true},
	{106839,"DRUID,KICK",5,--Лобовая атака
		{106839,15,0},
		isTalent=true},
	{78675,	"DRUID,KICK",5,--Столп солнечного света
		nil,{78675,60,8},nil,nil,nil,
		isTalent=true,
		CLEU_SPELL_CAST_SUCCESS=[[
			if sourceName and spellID == 78675 and session_gGUIDs[sourceName][202918] then
				solarKickTarget = destGUID
				solarKickTime = timestamp
			end
		]],CLEU_SPELL_INTERRUPT=[[
			if sourceName and spellID == 78675 and session_gGUIDs[sourceName][202918] and solarKickTarget and solarKickTarget == destGUID and timestamp - solarKickTime < 10 then
				local line = CDList[sourceName][78675]
				if line then
					line:ReduceCD(15)
				end
			end
		]]},
	{124974,"DRUID",3,--Природная чуткость
		{124974,90,30},
		isTalent=true},
	{2908,	"DRUID",5,--Умиротворение
		{2908,10,0},nil,nil,nil,nil,
		isTalent=true},
	{106898,"DRUID,RAIDSPEED",1,--Тревожный рев
		{106898,120,8},nil,nil,nil,nil,
		isTalent=true,durationDiff={341450,{"*1.15","*1.165","*1.18","*1.195","*1.21","*1.225","*1.24","*1.255","*1.27","*1.285","*1.30","*1.315","*1.33","*1.345","*1.36"}},cdDiff={288826,-60},sameSpell={106898,77764,77761},
		CLEU_SPELL_INTERRUPT=[[
			if sourceName and spellID == 106839 and session_gGUIDs[sourceName][205673] and module.IsPvpTalentsOn(sourceName) then
				local line = CDList[sourceName][106898]
				if line then
					line:ReduceCD(10)
				end
			end
		]]},
	{61336,	"DRUID,DEFTANK,DEF",3,--Инстинкты выживания
		nil,nil,{61336,180,6},{61336,180,6},nil,
		isTalent=true,hasCharges=1,cdDiff={203965,"*0.67",296320,"*0.80"},
		CLEU_SPELL_INTERRUPT=[[
			if sourceName and spellID == 106839 and session_gGUIDs[sourceName][205673] and module.IsPvpTalentsOn(sourceName) then
				local line = CDList[sourceName][61336]
				if line then
					line:ReduceCD(10)
				end
			end
		]]},
	{18562,	"DRUID",3,--Быстрое восстановление
		nil,nil,nil,nil,{18562,15,0},
		isTalent=true,hasCharges=200383,cdDiff={200383,-3}},
	{5217,	"DRUID,DPS",3,--Тигриное неистовство
		nil,nil,{5217,30,10},nil,nil,
		isTalent=true,durationDiff={202021,5},
		CLEU_SPELL_INTERRUPT=[[
			if sourceName and spellID == 106839 and session_gGUIDs[sourceName][205673] and module.IsPvpTalentsOn(sourceName) then
				local line = CDList[sourceName][5217]
				if line then
					line:ReduceCD(10)
				end
			end
		]]},
	{740,	"DRUID,RAID",1,--Спокойствие
		nil,nil,nil,nil,{740,180,8},
		isTalent=true,cdDiff={197073,-60,329802,-54,296320,"*0.80"},changeDurWithHaste=true,
		CLEU_SPELL_HEAL=[[
			if spellID == 157982 and event == "SPELL_HEAL" and sourceGUID == destGUID and session_gGUIDs[sourceName][392162] then
				local line, updateReq
				for j=1,#_C do
					line = _C[j]
					if line.fullName == sourceName and line.db[1] ~= 740 then
						line:ReduceCD(3,true)
						updateReq = true
					end
				end
				if updateReq then
					UpdateAllData()
				end
			end
		]]},
	{132469,"DRUID,UTIL",3,--Тайфун
		{61391,30,0},nil,nil,nil,nil,
		isTalent=true},
	{102793,"DRUID,UTIL",3,--Вихрь Урсола
		{102793,60,10},nil,nil,nil,nil,
		isTalent=true},
	{200851,"DRUID",3,--Ярость Спящего
		nil,nil,nil,{200851,90,10},nil,
		isTalent=true},
	{48438,	"DRUID",3,--Буйный рост
		{48438,10,0},
		isTalent=true},
	{155835,"DRUID,DEFTANK",3,--Колючий мех
		nil,nil,nil,{155835,40,0},nil,
		isTalent=true},
	{102351,"DRUID",3,--Щит Кенария
		nil,nil,nil,nil,{102351,30,0},
		isTalent=true},
	{274837,"DRUID",3,--Дикое бешенство
		nil,nil,{274837,45,0},nil,nil,
		isTalent=true},
	{197721,"DRUID,HEAL",3,--Расцвет
		nil,nil,nil,nil,{197721,90,8},
		isTalent=true},
	{205636,"DRUID,UTIL",3,--Сила природы
		nil,{205636,60,10},nil,nil,nil,
		isTalent=true},
	{202770,"DRUID",3,--Ярость Элуны
		nil,{202770,60,8},nil,nil,nil,
		isTalent=true},
	{319454,"DRUID",3,--Сердце дикой природы
		{108293,300,45},nil,nil,nil,nil,
		isTalent=true,cdDiff={341451,{"*0.9","*0.89","*0.88","*0.87","*0.86","*0.85","*0.84","*0.83","*0.82","*0.81","*0.80","*0.79","*0.78","*0.76"}},sameSpell={108293,108291,319454}},
	{102560,"DRUID,DPS",3,--Воплощение: избранный Элуны
		nil,{102560,180,30},nil,nil,nil,
		isTalent=true,cdDiff={329802,-54}},
	{102558,"DRUID,DEFTANK",3,--Воплощение: Страж Урсока
		nil,nil,nil,{102558,180,30},nil,
		isTalent=true,cdDiff={339062,-30,329802,-54}},
	{102543,"DRUID,DPS",3,--Воплощение: король джунглей
		nil,nil,{102543,180,30},nil,nil,
		isTalent=true,cdDiff={329802,-54},reduceCdAfterCast={{274837,340053,103},-0.2,{106785,340053,103},-0.2,{202028,340053,103},-0.2,{5221,340053,103},-0.2,{1822,340053,103},-0.2,{106830,340053,103},-0.2}},
	{33891,	"DRUID,HEAL",3,--Воплощение: древо жизни
		nil,nil,nil,nil,{33891,180,30},
		isTalent=true,cdDiff={329802,-54},startCdAfterAuraApply=117679},
	{102359,"DRUID,UTIL",3,--Массовое оплетение
		{102359,30,0},nil,nil,nil,nil,
		isTalent=true,cdDiff={341451,{"*0.9","*0.89","*0.88","*0.87","*0.86","*0.85","*0.84","*0.83","*0.82","*0.81","*0.80","*0.79","*0.78","*0.76"}}},
	{5211,	"DRUID,CC",3,--Мощное оглушение
		{5211,60,0},nil,nil,nil,nil,
		isTalent=true,cdDiff={341451,{"*0.9","*0.89","*0.88","*0.87","*0.86","*0.85","*0.84","*0.83","*0.82","*0.81","*0.80","*0.79","*0.78","*0.76"}}},
	{203651,"DRUID",3,--Буйство природы
		nil,nil,nil,nil,{203651,60,0},
		isTalent=true},
	{391888,"DRUID",3,--Адаптивный рой
		{391888,25,0},
		isTalent=true},
	{80313,	"DRUID",3,--Раздавить
		nil,nil,nil,{80313,30,0},nil,
		isTalent=true},
	{108238,"DRUID,DEF",3,--Обновление
		{108238,90,0},nil,nil,nil,nil,
		isTalent=true},
	{252216,"DRUID,MOVE",3,--Рывок тигра
		{252216,45,5},nil,nil,nil,nil,
		isTalent=true,ignoreUseWithAura=375230,changeCdWithAura={381746,"*0.85"}},
	{202425,"DRUID",3,--Воин Элуны
		nil,{202425,45,0},nil,nil,nil,
		isTalent=true,startCdAfterAuraFade=202425},
	{102401,"DRUID,MOVE",3,--Стремительный рывок
		{102401,15,0},nil,nil,nil,nil,
		isTalent=true},
	{207017,"DRUID,PVP",3,--Вызов вожака
		nil,nil,nil,{207017,20,0},nil,
		isTalent=true},
	{201664,"DRUID,PVP",3,--Деморализующий рев
		nil,nil,nil,{201664,30,8},nil,
		isTalent=true},
	{209749,"DRUID,PVP",3,--Волшебный рой
		nil,{209749,30,5},nil,nil,nil,
		isTalent=true},
	{202246,"DRUID,PVP",3,--Накат
		nil,nil,nil,{202246,25,0},nil,
		isTalent=true},
	{203242,"DRUID,PVP",3,--Гибельные когти
		nil,nil,{203242,60,0},nil,nil,
		isTalent=true},
	{329042,"DRUID,PVP",3,--Изумрудная дрема
		nil,nil,nil,{329042,12,0},nil,
		isTalent=true},
	{305497,"DRUID,PVP",3,--Шипы
		nil,{305497,45,12},{305497,45,12},nil,{305497,45,12},
		isTalent=true},


	{188499,"DEMONHUNTER",3,--Танец клинков
		nil,{188499,15,0},nil,
		changeCdWithHaste=true,resetBy=191427},
	{198589,"DEMONHUNTER,DEF",4,--Затуманивание
		nil,{198589,60,10},nil,
		cdDiff={338671,{-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-18,-20}},startCdAfterAuraApply=212800},
	{179057,"DEMONHUNTER,AOECC",3,--Кольцо Хаоса
		{179057,60,2},
		isTalent=true,cdDiff={206477,"*0.8"}},
	{278326,"DEMONHUNTER",5,--Поглощение магии
		{278326,10,0},nil,nil,
		isTalent=true},
	{196718,"DEMONHUNTER,RAID",1,--Мрак
		{196718,300,8},
		isTalent=true,durationDiff={389781,3},cdDiff={389783,-120}},
	{203720,"DEMONHUNTER,DEFTANK",3,--Демонические шипы
		nil,nil,{203720,20,0},
		hasCharges=1,changeCdWithHaste=true},
	{183752,"DEMONHUNTER,KICK",5,--Прерывание
		{183752,15,0},nil,nil},
	{198013,"DEMONHUNTER",3,--Пронзающий взгляд
		nil,{198013,40,0},nil,
		isTalent=true,resetBy=191427},
	{212084,"DEMONHUNTER",3,--Опустошение Скверной
		nil,nil,{212084,60,0},
		isTalent=true},
	{195072,"DEMONHUNTER,MOVE",3,--Рывок Скверны
		nil,{195072,10,0},nil,
		hasCharges=320416,cdDiff={391397,{"*0.9","*0.8"},337685,"*0.7"},ignoreUseWithAura=375229,changeCdWithAura={381741,"*0.85"}},
	{189110,"DEMONHUNTER,MOVE",3,--Инфернальный удар
		nil,nil,{189110,20,0},
		hasCharges=320416,cdDiff={391397,{"*0.9","*0.8"}},ignoreUseWithAura=375229,changeCdWithAura={381741,"*0.85"}},
	{204021,"DEMONHUNTER",3,--Огненное клеймо
		nil,nil,{204021,60,10},
		isTalent=true,hasCharges=389732,cdDiff={389732,-15,338671,{-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-18,-20}}},
	{258920,"DEMONHUNTER",3,--Обжигающий жар
		{258920,30,0},nil,nil},
	{217832,"DEMONHUNTER,CC",3,--Пленение
		{217832,45,0},nil,nil,
		isTalent=true,cdDiff={205506,15}},
	{191427,"DEMONHUNTER,DPS,DEFTANK",3,--Метаморфоза
		nil,{191427,240,30},{187827,180,15},
		durationDiff={235893,-15},cdDiff={320421,-60,235893,-60,296320,"*0.80"},sameSpell={200166,191427}},
	{204596,"DEMONHUNTER",3,--Печать огня
		{204596,30,2},
		isTalent=true,durationDiff={209281,-1},cdDiff={209281,"*0.8",211489,"*0.75"},
		CLEU_PREP = [[
			spell389718_var204596 = {}
		]],CLEU_SPELL_AURA_APPLIED=[[
			if sourceName and (spellID == 204598 or spellID == 207685 or spellID == 204490 or spellID == 204843) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var204596[sourceName] or 0)) > 0.1 then
					spell389718_var204596[sourceName] = timestamp
					
					local line = CDList[sourceName][204596]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]],CLEU_SPELL_DAMAGE=[[
			if sourceName and (spellID == 389860) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var204596[sourceName] or 0)) > 0.1 then
					spell389718_var204596[sourceName] = timestamp
					
					local line = CDList[sourceName][204596]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]]},
	{207684,"DEMONHUNTER,AOECC",1,--Печать страдания
		{207684,120,2},
		isTalent=true,durationDiff={209281,-1},cdDiff={320418,-30,209281,"*0.8",211489,"*0.75"},
		CLEU_PREP = [[
			spell389718_var207684 = {}
		]],CLEU_SPELL_AURA_APPLIED=[[
			if sourceName and (spellID == 204598 or spellID == 207685 or spellID == 204490 or spellID == 204843) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var207684[sourceName] or 0)) > 0.1 then
					spell389718_var207684[sourceName] = timestamp
					
					local line = CDList[sourceName][207684]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]],CLEU_SPELL_DAMAGE=[[
			if sourceName and (spellID == 389860) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var207684[sourceName] or 0)) > 0.1 then
					spell389718_var207684[sourceName] = timestamp
					
					local line = CDList[sourceName][207684]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]]},
	{202137,"DEMONHUNTER,UTIL",1,--Печать немоты
		nil,nil,{202137,60,2},
		isTalent=true,durationDiff={209281,-1},cdDiff={209281,"*0.8",211489,"*0.75"},
		CLEU_PREP = [[
			spell389718_var202137 = {}
		]],CLEU_SPELL_AURA_APPLIED=[[
			if sourceName and (spellID == 204598 or spellID == 207685 or spellID == 204490 or spellID == 204843) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var202137[sourceName] or 0)) > 0.1 then
					spell389718_var202137[sourceName] = timestamp
					
					local line = CDList[sourceName][202137]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]],CLEU_SPELL_DAMAGE=[[
			if sourceName and (spellID == 389860) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var202137[sourceName] or 0)) > 0.1 then
					spell389718_var202137[sourceName] = timestamp
					
					local line = CDList[sourceName][202137]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]]},
	{188501,"DEMONHUNTER",3,--Призрачное зрение
		{188501,60,10},nil,nil,
		stopDurWithAuraFade=188501},
	{185123,"DEMONHUNTER",3,--Бросок боевого клинка
		{185123,9,0},nil,nil},
	{185245,"DEMONHUNTER,TAUNT",5,--Мучение
		{185245,8,0},nil,nil,
		hideWithTalent=207029},
	{370965,"DEMONHUNTER",3,--Охота
		{370965,90,0},
		isTalent=true},
	{198793,"DEMONHUNTER",3,--Коварное отступление
		{198793,25,0},
		isTalent=true,cdDiff={389688,-5}},
	{320341,"DEMONHUNTER",3,--Массовое извлечение
		nil,nil,{320341,90,0},
		isTalent=true},
	{258860,"DEMONHUNTER",3,--Разрыв сущности
		nil,{258860,40,0},nil,
		isTalent=true},
	{258925,"DEMONHUNTER",3,--Обстрел Скверны
		nil,{258925,60,0},nil,
		isTalent=true},
	{211881,"DEMONHUNTER,CC",3,--Извержение Скверны
		nil,{211881,30,0},nil,
		isTalent=true},
	{232893,"DEMONHUNTER",3,--Клинок Скверны
		{232893,15,0},nil,nil,
		isTalent=true,changeCdWithHaste=true},
	{342817,"DEMONHUNTER",3,--Буря клинков
		nil,{342817,20,0},nil,
		isTalent=true,changeCdWithHaste=true},
	{196555,"DEMONHUNTER,DEF",3,--Путь Пустоты
		nil,{196555,180,6},nil,
		isTalent=true},
	{202138,"DEMONHUNTER,UTIL",3,--Печать цепей
		nil,nil,{202138,60,2},
		isTalent=true,cdDiff={209281,"*0.8",211489,"*0.75"},
		CLEU_PREP = [[
			spell389718_var202138 = {}
		]],CLEU_SPELL_AURA_APPLIED=[[
			if sourceName and (spellID == 204598 or spellID == 207685 or spellID == 204490 or spellID == 204843) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var202138[sourceName] or 0)) > 0.1 then
					spell389718_var202138[sourceName] = timestamp
					
					local line = CDList[sourceName][202138]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]],CLEU_SPELL_DAMAGE=[[
			if sourceName and (spellID == 389860) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var202138[sourceName] or 0)) > 0.1 then
					spell389718_var202138[sourceName] = timestamp
					
					local line = CDList[sourceName][202138]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]]},
	{263648,"DEMONHUNTER",3,--Призрачный барьер
		nil,nil,{263648,30,0},
		isTalent=true},
	{390163,"DEMONHUNTER",3,--Элизийский декрет
		nil,nil,{390163,60,2},
		isTalent=true,cdDiff={209281,"*0.8"},
		CLEU_PREP = [[
			spell389718_var390163 = {}
		]],CLEU_SPELL_AURA_APPLIED=[[
			if sourceName and (spellID == 204598 or spellID == 207685 or spellID == 204490 or spellID == 204843) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var390163[sourceName] or 0)) > 0.1 then
					spell389718_var390163[sourceName] = timestamp
					
					local line = CDList[sourceName][390163]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]],CLEU_SPELL_DAMAGE=[[
			if sourceName and (spellID == 389860) and session_gGUIDs[sourceName][389718] then
				if (timestamp - (spell389718_var390163[sourceName] or 0)) > 0.1 then
					spell389718_var390163[sourceName] = timestamp
					
					local line = CDList[sourceName][390163]
					if line then
						line:ReduceCD(3)
					end
				end
			end
		]]},
	{206649,"DEMONHUNTER,PVP",3,--Глаз Леотераса
		nil,{206649,45,6},nil,
		isTalent=true},
	{205630,"DEMONHUNTER,PVP",3,--Хватка Иллидана
		nil,nil,{205630,60,0},
		isTalent=true},
	{203704,"DEMONHUNTER,PVP",3,--Прорыв маны
		nil,{203704,60,10},nil,
		isTalent=true},
	{235903,"DEMONHUNTER,PVP",3,--Провал маны
		nil,{235903,10,0},nil,
		isTalent=true},
	{206803,"DEMONHUNTER,PVP",3,--Удар с небес
		nil,{206803,60,0},nil,
		isTalent=true},
	{205604,"DEMONHUNTER,PVP",3,--Обращение магии
		{205604,60,0},nil,nil,
		isTalent=true},
	{207029,"DEMONHUNTER,PVP",3,--Мучитель
		nil,nil,{207029,20,0},
		isTalent=true},


	{358267,"EVOKER,MOVE",3,--Бреющий полет
		{358267,35,0},
		hasCharges=365933,ignoreUseWithAura=375234,changeCdWithAura={381748,"*0.85"}},
	{357210,"EVOKER",3,--Глубокий вдох
		{357210,120,0},
		cdDiff={386348,-60}},
	{364342,"EVOKER",3,--Дар бронзовых драконов
		{364342,15,0},nil,nil},
	{360995,"EVOKER",3,--Живительные объятия
		{360995,24,0},
		isTalent=true},
	{355913,"EVOKER",3,--Изумрудный цветок
		{355913,30,0},nil,nil},
	{360806,"EVOKER,CC",3,--Лунатизм
		{360806,15,0},
		isTalent=true},
	{365585,"EVOKER,DISPEL",5,--Нейтрализация
		{365585,8,0},
		isTalent=true,isDispel=true,sameSpell={360823,365585}},
	{374348,"EVOKER,DEF",3,--Обновляющее пламя
		{374348,90,8},
		isTalent=true,cdDiff={375577,-30}},
	{363916,"EVOKER,DEF",3,--Обсидиановая чешуя
		{363916,150,12},
		isTalent=true,cdDiff={375406,-60}},
	{357208,"EVOKER",3,--Огненное дыхание
		{357208,30,0},nil,nil},
	{351338,"EVOKER,KICK",5,--Подавление
		{351338,40,0},
		isTalent=true,cdDiff={371016,-20}},
	{374251,"EVOKER",3,--Прижигающее пламя
		{374251,60,0},
		isTalent=true},
	{368432,"EVOKER",3,--Разрушение магии
		{368432,9,0},
		isTalent=true},
	{358385,"EVOKER,CC",3,--Сель
		{358385,90,0},
		isTalent=true,cdDiff={375528,-30}},
	{370553,"EVOKER",3,--Смещение равновесия
		{370553,120,0},
		isTalent=true,startCdAfterAuraFade=370553},
	{370665,"EVOKER,UTIL,MOVE",2,--Спасение
		{370665,60,0},
		isTalent=true},
	{374968,"EVOKER,RAIDSPEED",1,--Спираль времени
		{374968,120,10},
		isTalent=true},
	{372048,"EVOKER",3,--Угнетающий рык
		{372048,120,0},
		isTalent=true},
	{374227,"EVOKER,RAIDSPEED",3,--Южный ветер
		{374227,120,8},
		isTalent=true},
	{390386,"EVOKER",3,--Ярость Аспектов
		{390386,300,0}},
	{370452,"EVOKER",3,--Сокрушающая звезда
		nil,{370452,15,0},nil,
		isTalent=true},
	{368847,"EVOKER",3,--Огненная буря
		nil,{368847,20,0},nil,
		isTalent=true},
	{359073,"EVOKER",3,--Всплеск вечности
		nil,{359073,30,0},nil,
		isTalent=true,reduceCdAfterCast={{364343,375777},-1,{357211,375777},-1,{356995,375777},-1,{355913,375777},-1}},
	{375087,"EVOKER,DPS",3,--Ярость дракона
		nil,{375087,120,10},nil,
		isTalent=true},
	{355936,"EVOKER",3,--Изумрудное дыхание
		nil,nil,{355936,30,0},
		isTalent=true},
	{363534,"EVOKER,DEFTAR",2,--Перемотка
		nil,nil,{363534,240,0},
		isTalent=true,reduceCdAfterCast={{364343,376204},-2,{357211,376204},-2,{356995,376204},-2,{355913,376204},-2},hasCharges=376210,cdDiff={381922,-60}},
	{370960,"EVOKER,HEAL",3,--Изумрудные грезы
		nil,nil,{370960,180,5},
		isTalent=true},
	{359816,"EVOKER,HEAL",3,--Изумрудный полет
		nil,nil,{359816,120,0},
		isTalent=true},
	{367226,"EVOKER",3,--Призрачный цветок
		nil,nil,{367226,30,0},
		isTalent=true,cdDiff={376150,-10}},
	{357170,"EVOKER,DEFTAR",2,--Растяжение времени
		nil,nil,{357170,60,8},
		isTalent=true,durationDiff={376240,{"*1.15","*1.3"}}},
	{370537,"EVOKER",3,--Стазис
		nil,nil,{370537,90,0},
		isTalent=true},


	{161642,"NO,RES",3,--Воскрешение
		{161642,0,0},
		afterCombatReset=true,isBattleRes=true},


	{90355,	"PET,HUNTER,UTIL",3,--Древняя истерия
		{90355,360,40},
		afterCombatNotReset=true},
	{26064,	"PET,HUNTER",3,--Панцирный щит
		{26064,60,12}},
	{55709,	"PET,HUNTER",3,--Сердце феникса
		{55709,480,0},
		afterCombatNotReset=true},
	{53478,	"PET,HUNTER",3,--Ни шагу назад
		{53478,360,20},
		afterCombatNotReset=true},
	{61685,	"PET,HUNTER",3,--Рывок
		{61685,25,0}},
	{90361,	"PET,HUNTER",3,--Духовное лечение
		{90361,30,0}},
	{91802,	"PET,DEATHKNIGHT",5,--Неуклюжий рывок
		{91802,30,0}},
	{91797,	"PET,DEATHKNIGHT",3,--Чудовищный удар
		{91797,90,0}},
	{89751,	"PET,WARLOCK",3,--Буря Скверны
		{89751,45,6}},
	{89766,	"PET,WARLOCK,CC,KICK",5,--Метание топора
		{89766,30,0},
		sameSpell={89766,119914}},
	{115276,"PET,WARLOCK,DISPEL",5,--Обжигающая магия
		{115276,10,0}},
	{17767,	"PET,WARLOCK",3,--Оплот теней
		{17767,120,20},
		sameSpell={119907,17767}},
	{89808,	"PET,WARLOCK,DISPEL",5,--Опаляющая магия
		{89808,10,0},
		sameSpell={119905,89808}},
	{119899,"PET,WARLOCK",4,--Прижигание ран хозяина
		{119899,30,12}},
	{89792,	"PET,WARLOCK",3,--Бегство
		{89792,20,0}},
	{115831,"PET,WARLOCK",3,--Буря гнева
		{115831,45,6}},
	{115268,"PET,WARLOCK,CC",3,--Очарование
		{115268,30,0}},
	{6358,	"PET,WARLOCK,CC",3,--Соблазн
		{6358,30,0},
		sameSpell={119909,6358}},
	{19647,	"PET,WARLOCK,KICK",5,--Запрет чар
		{19647,24,0},
		sameSpell={119910,19647}},
	{19505,	"PET,WARLOCK",3,--Пожирание магии
		{19505,15,0}},
	{33395,	"PET,MAGE",3,--Холод
		{33395,25,0}},


	{68992,	"RACIAL",3,--Легкость тьмы
		{68992,120,10},
		isRacial="Worgen"},
	{20589,	"RACIAL",3,--Мастер побега
		{20589,60,0},
		isRacial="Gnome"},
	{20594,	"RACIAL",3,--Каменная форма
		{20594,120,8},
		isRacial="Dwarf"},
	{121093,"RACIAL",3,--Дар наару
		{121093,180,5},
		sameSpell={121093,59545,59543,59548,59542,59544,59547,28880},isRacial="Draenei"},
	{58984,	"RACIAL",3,--Слиться с тенью
		{58984,120,0},
		isRacial="NightElf"},
	{59752,	"RACIAL",3,--Воля к жизни
		{59752,180,0},
		isRacial="Human"},
	{69041,	"RACIAL",3,--Ракетный обстрел
		{69041,90,0},
		sameSpell={69041,69070},isRacial="Goblin"},
	{69070,	"RACIAL",3,--Реактивный прыжок
		{69070,90,0},
		sameSpell={69041,69070},isRacial="Goblin"},
	{7744,	"RACIAL",3,--Воля Отрекшихся
		{7744,120,0},
		isRacial="Undead"},
	{20577,	"RACIAL",3,--Каннибализм
		{20577,120,10},
		isRacial="Undead"},
	{20572,	"RACIAL",3,--Кровавое неистовство
		{20572,120,15},
		isRacial="Orc"},
	{20549,	"RACIAL",3,--Громовая поступь
		{20549,90,0},
		isRacial="Tauren"},
	{26297,	"RACIAL",3,--Берсерк
		{26297,180,12},
		isRacial="Troll"},
	{28730,	"RACIAL",3,--Волшебный поток
		{28730,120,0},
		sameSpell={28730,69179,129597,80483,155145,25046,50613,202719,232633},isRacial="BloodElf"},
	{107079,"RACIAL",3,--Сотрясающая ладонь
		{107079,120,4},
		isRacial="Pandaren"},
	{256948,"RACIAL",3,--Пространственный разлом
		{256948,180,0},
		isRacial="VoidElf"},
	{260364,"RACIAL",3,--Чародейский импульс
		{260364,180,12},
		isRacial="Nightborne"},
	{255647,"RACIAL",3,--Правосудие Света
		{255647,150,3},
		isRacial="LightforgedDraenei"},
	{255654,"RACIAL",3,--Бычий натиск
		{255654,120,0},
		isRacial="HighmountainTauren"},
	{274738,"RACIAL",3,--Призыв предков
		{274738,120,15},
		isRacial="MagharOrc"},
	{265221,"RACIAL",3,--Огненная кровь
		{265221,120,8},
		isRacial="DarkIronDwarf"},
	{312924,"RACIAL",3,--Излучатель органического света
		{312924,180,0},
		isRacial="Mechagnome"},
	{287712,"RACIAL",3,--Удар с размаху
		{287712,150,3},
		isRacial="KulTiran"},
	{312411,"RACIAL",3,--Набор хитростей
		{312411,90,0},
		isRacial="Vulpera"},
	{291944,"RACIAL",3,--Регенерация
		{291944,150,6},
		isRacial="ZandalariTroll"},
	{357214,"RACIAL",3,--Взмах крыльями
		{357214,90,0},
		isRacial="Dracthyr",cdDiff={368838,-45}},
	{368970,"RACIAL",3,--Взмах крыльями
		{368970,90,0},
		isRacial="Dracthyr",cdDiff={375443,-45}},


	{67826,	"ITEMS",3,--Дживс
		{67826,3600,0},
		isTalent=true,afterCombatNotReset=true},
	{201414,"ITEMS",3,--Оплот чистоты
		{201414,60,0},
		item=133598},
	{201371,"ITEMS",3,--Божественное правосудие
		{201371,60,0},
		item=133585},
	{90633,	"ITEMS",3,--Боевой штандарт гильдии
		{90633,600,0},
		sameSpell={90633,90628},icon="Interface\\Icons\\inv_guild_standard_horde_c",startCdAfterUse={{90631,120},{90632,120}},item=64402},
	{90632,	"ITEMS",3,--Боевой штандарт гильдии
		{90632,600,0},
		sameSpell={90632,90626},icon="Interface\\Icons\\inv_guild_standard_horde_b",startCdAfterUse={{90633,120},{90631,120}},item=64401},
	{90631,	"ITEMS",3,--Боевой штандарт гильдии
		{90631,600,0},
		sameSpell={90631,89479},icon="Interface\\Icons\\inv_guild_standard_horde_a",startCdAfterUse={{90633,120},{90632,120}},item=64400},
	{187614,"ITEMS",3,--Legendary DD
		{187614,120,15},
		item={124634,124636,124635}},	
	{187612,"ITEMS",3,--Legendary Heal
		{187612,120,15},
		item=124638},
	{187613,"ITEMS",3,--Legendary Tank
		{187613,120,15},
		item=124637},
	{235169,"ITEMS",3,--Перерожденная ненависть Архимонда
		{235169,75,10},
		item=144249},
	{235966,"ITEMS",3,--Предвидение Велена
		{235966,75,10},
		item=144258},
	{235991,"ITEMS",3,--Пылкое желание Кил'джедена
		{235991,75,0},
		item=144259},
	{251946,"ITEMS",3,--Пылающий бастион
		{251946,120,3},
		item=151978},
	{295271,"ITEMS",3,--Темный панцирь
		{295271,120,0},
		icon=1003587,item=167865},
	{344732,"ITEMS",3,--Сосуд жуткого огня
		{344732,90,0},
		item=184030},
	{344231,"ITEMS",3,--Кровавый винтаж
		{344231,60,0},
		item=184031},
	{344245,"ITEMS",3,--Зеркало маны
		{344245,60,0},
		item=184029},
	{345251,"ITEMS",3,--Поджигание души
		{345251,60,0},
		item=184019},
	{345019,"ITEMS",3,--Таящийся хищник
		{345019,90,0},
		item=184016},
	{344916,"ITEMS",3,--Пучок огненных перьев
		{344916,120,6},
		item=184020},
	{345432,"ITEMS",3,--Вальс крови
		{345432,90,20},
		item=184024},
	{344662,"ITEMS",3,--Разбитая душа
		{344662,120,0},
		item=184025},
	{334058,"ITEMS",3,--Гнилостный взрыв
		{334058,90,10},
		item=173069},
	{333734,"ITEMS",3,--Паутина покоя
		{333734,90,0},
		icon=3717273,item=173078},
	{311444,"ITEMS",3,--Колода Неукротимости
		{311444,90,10},
		item=173096},
	{331624,"ITEMS",3,--Неутолимый голод
		{331624,90,20},
		icon=3717302,item=173087},
	{345319,"ITEMS",3,--Символ ассимиляции
		{345319,90,0},
		item=184021},
	{344384,"ITEMS",3,--Связь охотника
		{344384,120,30},
		item=184017},
	{345228,"ITEMS",3,--Жетон гладиатора
		{345228,60,15},
		item={175921,185197}},
	{345231,"ITEMS",3,--Эмблема гладиатора
		{345231,120,20},
		item={178447,185282}},
	{336126,"ITEMS",3,--Медальон гладиатора
		{336126,120,0},
		item={181333,185304}},
	{307192,"ITEMS",3,--Духовное зелье исцеления
		{307192,300,0},
		sameSpell={307192,213664,216431,216802,216468,338447,301308}},
	{6262,	"ITEMS",3,--Камень здоровья
		{6262,60,0}},
	{355327,"ITEMS",3,--Зажим черной души
		{355327,90,0},
		item=186431},
	{356212,"ITEMS",3,--Запретная некромантия
		{356212,600,0},
		icon=355498,item=186421},
	{355321,"ITEMS",3,--Истязающее озарение
		{355321,120,0},
		item=186428},
	{358712,"ITEMS",3,--Эгида Аннгильды
		{358712,90,0},
		item=186424},
	{355303,"ITEMS",3,--Зов Повелителя Холода
		{355303,60,0},
		item=186437},
	{355333,"ITEMS",3,--Трофейный катализатор синтеза
		{355333,90,0},
		item=186432},
	{353692,"ITEMS",3,--Изучение
		{353692,60,0},
		item=186422},
	{363481,"ITEMS",3,--Резонатор гладиатора
		{363481,120,4},
		item=188766},
	{363117,"ITEMS",3,--Взыскательная решимость гладиатора
		{363117,180,15},
		item=188524},
	{363557,"ITEMS",3,--Львиный рык
		{363557,600,0},
		item=188262},
	{364152,"ITEMS",3,--Сердце роя
		{364152,180,0},
		icon=538518,item=188255},
	{367236,"ITEMS",3,--Ореол дезинтеграции
		{367236,90,0},
		icon=610679,item=188272},
	{367241,"ITEMS",3,--Первая печать
		{367241,300,0},
		icon=656542,item=188271},
	{368203,"ITEMS",3,--Изобретательность архитектора
		{368203,90,0},
		item=188268},
	{367802,"ITEMS",3,--Пульсирующий осколок
		{367802,60,0},
		item=188266},
	{368894,"ITEMS",3,--Заряженный сердечник Возвращающего
		{368894,150,0},
		icon=463521,item=188263},
	{367885,"ITEMS",3,--Клетка навязчивых идей
		{367885,180,0},
		icon=1559579,item=188261},


	{295373,"ESSENCES",3,--Сосредоточенный огонь
		{295373,30,0},
		isTalent=true,sameSpell={295373,299349,299353}},
	{295186,"ESSENCES",3,--Резонанс крови мира
		{295186,60,0},
		isTalent=true,sameSpell={295186,298628,299334}},
	{302731,"ESSENCES",3,--Пространственная рябь
		{302731,60,2},
		isTalent=true,sameSpell={302731,302982,302983}},
	{298357,"ESSENCES",3,--Воспоминания о снах наяву
		{298357,120,0},
		isTalent=true,sameSpell={298357,299372,299374}},
	{293019,"ESSENCES",3,--Дар жизни Азерот
		{293019,60,4},
		isTalent=true,cdDiff={298080,-15},sameSpell={293019,298080,298081}},
	{294926,"ESSENCES",3,--Сущность смерти
		{294926,150,0},
		isTalent=true,cdDiff={300002,-30},sameSpell={294926,300002,300003}},
	{298168,"ESSENCES",3,--Эгида глубин
		{298168,120,15},
		isTalent=true,cdDiff={299273,-30},sameSpell={298168,299273,299275}},
	{295746,"ESSENCES",3,--Усиленный нуль-щит
		{295746,180,0},
		isTalent=true,cdDiff={300015,-42},sameSpell={295746,300015,300016}},
	{293031,"ESSENCES",3,--Луч подавления
		{293031,60,0},
		isTalent=true,cdDiff={300009,-15},sameSpell={293031,300009,300010}},
	{296197,"ESSENCES",3,--Восполнение сил
		{296197,15,0},
		isTalent=true,sameSpell={296197,299932,299933}},
	{296094,"ESSENCES",3,--Застой
		{296094,180,0},
		isTalent=true,sameSpell={296094,299882,299883}},
	{293032,"ESSENCES",3,--Чары Хранительницы жизни
		{293032,120,0},
		isTalent=true,sameSpell={293032,299943,299944}},
	{296072,"ESSENCES",3,--Перегрузка маны
		{296072,30,8},
		isTalent=true,sameSpell={296072,299875,299876}},
	{296230,"ESSENCES",3,--Проводник жизненной силы
		{296230,60,0},
		isTalent=true,cdDiff={299958,-15},sameSpell={296230,299958,299959}},
	{295258,"ESSENCES",3,--Сосредоточенный азеритовый луч
		{295258,90,0},
		isTalent=true,sameSpell={295258,299336,299338}},
	{295840,"ESSENCES",3,--Защитник Азерот
		{295840,180,0},
		isTalent=true,sameSpell={295840,299355,299358}},
	{297108,"ESSENCES",3,--Кровь врага
		{297108,120,0},
		isTalent=true,cdDiff={298273,-30},sameSpell={297108,298273,298277}},
	{295337,"ESSENCES",3,--Очищающая вспышка
		{295337,60,0},
		isTalent=true,sameSpell={295337,299345,299347}},
	{298452,"ESSENCES",3,--Высвобожденная сила
		{298452,60,0},
		isTalent=true,cdDiff={299376,-15},sameSpell={298452,299376,299378}},


	{324739,"COVENANTS",3,--Призыв распорядителя
		{324739,300,240},
		isTalent=true,isCovenant=1},
	{323436,"COVENANTS",3,--Очищение души
		{323436,180,0},
		isTalent=true,isCovenant=1,
		CLEU_SPELL_HEAL=[[
			if spellID == 323436 then
				C_Timer.After(.3,function()
					local line = CDList[sourceName][323436]

					if line and GetTime() - (line.lastUse or 0) > 1 then
						CLEUstartCD(line)
					end
				end)
			end
		]]},
	{324631,"COVENANTS",3,--Скульптор плоти
		{324631,120,4},
		isTalent=true,isCovenant=4,stopDurWithAuraFade=324631},
	{310143,"COVENANTS",3,--Облик души
		{310143,90,0},
		isTalent=true,isCovenant=3,cdDiff={320658,-15,342789,-30}},
	{300728,"COVENANTS",3,--Врата теней
		{300728,60,0},
		isTalent=true,isCovenant=2,hasCharges=336147,durationDiff={331577,6},cdDiff={336147,30,342801,-6},
		CLEU_SPELL_AURA_APPLIED_DOSE=[[
			if spellID == 342801 and destName then
				session_gGUIDs[destName] = {342801,"torghast",stack}
			end
		]]},
	{307865,"COVENANTS,WARRIOR",3,--Копье Бастиона
		{307865,60,4},
		isTalent=true,isCovenant=1,durationDiff={357996,4}},
	{312321,"COVENANTS,WARLOCK",3,--Очищающее пожертвование
		{312321,40,0},
		isTalent=true,isCovenant=1},
	{324386,"COVENANTS,SHAMAN",3,--Тотем вечернего колокола
		{324386,60,0},
		isTalent=true,isCovenant=1,cdDiff={333261,-6,314278,-5}},
	{323547,"COVENANTS,ROGUE",3,--Продолжительная отповедь
		{323547,45,0},
		isTalent=true,isCovenant=1},
	{325013,"COVENANTS,PRIEST",3,--Благословение перерожденных
		{325013,180,10},
		isTalent=true,isCovenant=1,cdDiff={327468,-20},
		CLEU_PREP=[[
			priestBoon_var = {}
		]],CLEU_SPELL_AURA_APPLIED_DOSE=[[
			if spellID == 325013 then
				priestBoon_var[sourceName] = stack
			end
		]],CLEU_SPELL_AURA_REMOVED=[[
			if spellID == 325013 and session_gGUIDs[sourceName][356395] then
				local max_stack = priestBoon_var[sourceName]
				if max_stack then
					local line = CDList[sourceName][325013]
					if line then
						local time_reduce = min(max_stack * 3,60)

						line:ReduceCD(time_reduce,true)
						forceUpdateAllData = true
					end
				end
				priestBoon_var[sourceName] = nil
			end
		]]},
	{304971,"COVENANTS,PALADIN",3,--Божественный благовест
		{304971,60,0},
		isTalent=true,isCovenant=1},
	{310454,"COVENANTS,MONK",3,--Оружие ордена
		{310454,120,30},
		isTalent=true,isCovenant=1},
	{307443,"COVENANTS,MAGE",3,--Сияющая искра
		{307443,30,0},
		isTalent=true,isCovenant=1},
	{308491,"COVENANTS,HUNTER",3,--Резонирующая стрела
		{308491,60,0},
		isTalent=true,isCovenant=1},
	{326434,"COVENANTS,DRUID",3,--Родственные души
		{326434,60,10},
		isTalent=true,isCovenant=1,sameSpell={338142,338018,338035,326462,326446,326647,326434}},
	{306830,"COVENANTS,DEMONHUNTER",3,--Элизийский декрет
		{306830,60,2},
		isTalent=true,isCovenant=1},
	{312202,"COVENANTS,DEATHKNIGHT",3,--Узы недостойных
		{312202,60,0},
		isTalent=true,isCovenant=1},
	{324143,"COVENANTS,WARRIOR",3,--Знамя завоевателя
		{324143,120,15},
		isTalent=true,isCovenant=4},
	{325289,"COVENANTS,WARLOCK",3,--Стрела опустошения
		{325289,45,0},
		isTalent=true,isCovenant=4},
	{326059,"COVENANTS,SHAMAN",3,--Первозданная волна
		{326059,45,0},
		isTalent=true,isCovenant=4,hasCharges=333344},
	{328547,"COVENANTS,ROGUE",3,--Зазубренный костяной шип
		{328547,30,0},
		isTalent=true,isCovenant=4,hasCharges=354731},
	{324724,"COVENANTS,PRIEST",3,--Нечестивое кольцо
		{324724,60,15},
		isTalent=true,isCovenant=4,durationDiff={337979,2}},
	{328204,"COVENANTS,PALADIN",3,--Молот покорителя
		{328204,30,0},
		isTalent=true,isCovenant=4,cdDiff={336612,-3}},
	{325216,"COVENANTS,MONK",3,--Отвар из костяной пыли
		{325216,60,10},
		isTalent=true,isCovenant=4,
		CLEU_PREP=[[
			spell337295_var = {}
			spell337295_var_c = {}
		]],CLEU_SPELL_HEAL=[[
			if spellID == 325218 and session_gGUIDs[sourceName][337295] then
				local line = CDList[sourceName][325216]
				if line then
					local t = GetTime()
					if t - (spell337295_var[sourceName] or 0) > 20 then
						spell337295_var[sourceName] = t
						spell337295_var_c[sourceName] = 0
					end
					spell337295_var_c[sourceName] = spell337295_var_c[sourceName] + 1
					if spell337295_var_c[sourceName] <= 5 then
						line:ReduceCD(0.5)
					end
				end
			end
		]]},
	{324220,"COVENANTS,MAGE",3,--Дитя смерти
		{324220,180,25},
		isTalent=true,isCovenant=4,durationDiff={336999,{6,6.6,7.2,7.8,8.4,9,9.6,10.2,10.8,11.4,12,12.6,13.2,13.8,14.4}}},
	{325028,"COVENANTS,HUNTER",3,--Шакрам смерти
		{325028,45,0},
		isTalent=true,isCovenant=4},
	{325727,"COVENANTS,DRUID",3,--Адаптивный рой
		{325727,25,0},
		isTalent=true,isCovenant=4},
	{329554,"COVENANTS,DEMONHUNTER",3,--Подпитка для пламени
		{329554,120,30},
		isTalent=true,isCovenant=4,durationDiff={340063,{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}}},
	{315443,"COVENANTS,DEATHKNIGHT",3,--Рука поганища
		{315443,120,12},
		isTalent=true,isCovenant=4},
	{325886,"COVENANTS,WARRIOR",3,--Повторный толчок Древних
		{325886,90,0},
		isTalent=true,isCovenant=3,cdDiff={339939,-15}},
	{325640,"COVENANTS,WARLOCK",3,--Гниение души
		{325640,60,0},
		isTalent=true,isCovenant=3},
	{328923,"COVENANTS,SHAMAN",3,--Волшебное переливание
		{328923,120,3},
		isTalent=true,isCovenant=3,cdDiff={339183,{-25,-26,-27,-28,-29,-30,-31,-33,-34,-35,-36,-37,-38,-39,-40},333348,-15}},
	{328305,"COVENANTS,ROGUE",3,--Сепсис
		{328305,90,10},
		isTalent=true,isCovenant=3,changeCdBeforeAuraFullDur={328305,-30}},
	{327661,"COVENANTS,PRIEST",3,--Волшебные стражи
		{327661,90,20},
		isTalent=true,isCovenant=3},
	{328620,"COVENANTS,PALADIN",3,--Благословение лета
		{328620,45,0},
		isTalent=true,isCovenant=3,sameSpell={328282,328622,328620,328281}},
	{327104,"COVENANTS,MONK",3,--Волшебная линия
		{327104,30,0},
		isTalent=true,isCovenant=3},
	{314791,"COVENANTS,MAGE",3,--Переходящая сила
		{314791,45,0},
		isTalent=true,isCovenant=3},
	{328231,"COVENANTS,HUNTER",3,--Дикие духи
		{328231,120,15},
		isTalent=true,isCovenant=3,durationDiff={339109,3}},
	{323764,"COVENANTS,DRUID",3,--Созыв духов
		{323764,120,4},
		isTalent=true,isCovenant=3,cdDiff={354118,"*0.5",335766,-20}},
	{323639,"COVENANTS,DEMONHUNTER",3,--Охота
		{323639,90,0},
		isTalent=true,isCovenant=3},
	{324128,"COVENANTS,DEATHKNIGHT",3,--Дань смерти
		{324128,30,10},
		isTalent=true,isCovenant=3},
	{317320,"COVENANTS,WARRIOR",3,--Порицание
		{317320,0,0},
		isTalent=true,isCovenant=2},
	{321792,"COVENANTS,WARLOCK",3,--Неотвратимая катастрофа
		{321792,60,0},
		isTalent=true,isCovenant=2},
	{320674,"COVENANTS,SHAMAN",3,--Цепная жатва
		{320674,90,0},
		isTalent=true,isCovenant=2,
		CLEU_SPELL_DAMAGE=[[
			if spellID == 320752 and critical then
				local line = CDList[sourceName][320674]
				if line then
					line:ReduceCD(5)
				end
			end
		]],CLEU_SPELL_HEAL=[[
			if spellID == 320751 and critical then
				local line = CDList[sourceName][320674]
				if line and critical then
					line:ReduceCD(5)
				end
			end
		]]},
	{323654,"COVENANTS,ROGUE",3,--Флагелляция
		{323654,90,12},
		isTalent=true,isCovenant=2},
	{323673,"COVENANTS,PRIEST",3,--Игры разума
		{323673,45,5},
		isTalent=true,isCovenant=2,durationDiff={338315,2},stopDurWithAuraFade=323673},
	{316958,"COVENANTS,PALADIN",1,--Пепельное освящение
		{316958,240,30},
		isTalent=true,isCovenant=2,durationDiff={355447,"*1.5"}},
	{326860,"COVENANTS,MONK",3,--Павший орден
		{326860,180,24},
		isTalent=true,isCovenant=2},
	{314793,"COVENANTS,MAGE",3,--Истязающие зеркала
		{314793,90,25},
		isTalent=true,isCovenant=2},
	{324149,"COVENANTS,HUNTER",3,--Выстрел свежевателя
		{324149,30,0},
		isTalent=true,isCovenant=2},
	{323546,"COVENANTS,DRUID",3,--Прожорливое бешенство
		{323546,180,20},
		isTalent=true,isCovenant=2,durationDiff={354109,2.5},stopDurWithAuraFade=323546},
	{317009,"COVENANTS,DEMONHUNTER",3,--Клеймо греха
		{317009,60,8},
		isTalent=true,isCovenant=2,cdDiff={340028,{-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15}}},
	{311648,"COVENANTS,DEATHKNIGHT",3,--Клубящийся туман
		{311648,60,8},
		isTalent=true,isCovenant=2},
}

if ExRT.isLK then
	module.db.AllSpells = {
		{29166,	"DRUID",	1,	{29166,	180,	20}},	--Озарение
		{20748,	"DRUID",	1,	{20748,	600,	0}},	--BR
		{6795,	"DRUID",	1,	{6795,	8,	0}},	--Taunt
		{9863,	"DRUID",	1,	{9863,	480,	8}},	--Tranq
		{5209,	"DRUID",	1,	{5209,	180,	6}},	--Challenging Roar

		{355,	"WARRIOR",	1,	{355,	8,	0}},	--Taunt
		{12975,	"WARRIOR",	1,	{12975,	180,	20}},	--Last stand
		{871,	"WARRIOR",	1,	{871,	300,	10}},	--SW
		{1161,	"WARRIOR",	1,	{1161,	180,	6}},	--Challenging Shout
		{12809,	"WARRIOR",	1,	{12809,	30,	5}},	--Concussion Blow
		{676,	"WARRIOR",	1,	{676,	60,	10}},	--Disarm
		{55694,	"WARRIOR",	1,	{55694,	180,	10}},	--Enraged Regeneration

		{11958,	"MAGE",		1,	{11958,	480,	0}},	--Cold Snap
		{12472,	"MAGE",		1,	{12472,	180,	20}},	--IV
		{45438,	"MAGE",		1,	{45438,	300,	10}},	--IB
		{55342,	"MAGE",		1,	{55342,	180,	30}},	--Mirrors

		{642,	"PALADIN",	1,	{642,	300,	12}},	--DS
		{10310,	"PALADIN",	1,	{10310,	1200,	0}},	--LoH
		{19752,	"PALADIN",	1,	{19752,	600,	180}},	--DI
		{31884,	"PALADIN",	1,	{31884,	180,	20}},	--AW
		{10278,	"PALADIN",	1,	{10278,	300,	10}},	--BoP
		{1044,	"PALADIN",	1,	{1044,	25,	6}},	--Freedom
		{1038,	"PALADIN",	1,	{1038,	120,	10}},	--Salv
		{6940,	"PALADIN",	1,	{6940,	120,	12}},	--Sac
		{62124,	"PALADIN",	1,	{62124,	8,	0}},	--Taunt
		{64205,	"PALADIN",	1,	{64205,	120,	10}},	--Divine Sacrifice
		{31821,	"PALADIN",	1,	{31821,	120,	6}},	--Aura Mastery

		{16190,	"SHAMAN",	1,	{16190,	300,	12}},	--MTT
		{32182,	"SHAMAN",	1,	{32182,	300,	40},	specialCheck=function() if UnitFactionGroup('player')=="Alliance" then return true end end},	--BL [A]
		{2825,	"SHAMAN",	1,	{2825,	300,	40},	specialCheck=function() if UnitFactionGroup('player')=="Horde" then return true end end},	--BL [H]
		{20608,	"SHAMAN",	1,	{21169,	1800,	0}},	--Reincarnation
		{2894, 	"SHAMAN",	1,	{2894,	600,	120}},	--FET
		{2062, 	"SHAMAN",	1,	{2062, 	600,	120}},	--EET

		{20765,	"WARLOCK",	1,	{20765,	900,	0}},	--Soulstone

		{19801, "HUNTER",	1,	{19801,	8,	0}},	--Tranq
		{34477, "HUNTER",	1,	{34477,	30,	0}},	--MD
		{19577, "HUNTER",	1,	{19577,	60,	3}},	--MD
		{5384, 	"HUNTER",	1,	{5384,	30,	0}},	--Feign Death

		{64843, "PRIEST",	1,	{64843,	480,	8}}, 	--Divine Hymn
		{724, 	"PRIEST",	1,	{724,	180,	0}}, 	--Lightwell
		{6346, 	"PRIEST",	1,	{6346,	180,	0}}, 	--Fear Ward
		{10060, "PRIEST",	1,	{10060,	120,	15}},	--Power Infusion
		{64901, "PRIEST",	1,	{64901,	360,	0}}, 	--Hymn of Hope
		{47788, "PRIEST",	1,	{47788,	180,	10}}, 	--Guardian Spirit
		{33206, "PRIEST",	1,	{33206,	180,	8}}, 	--Pain Suppression

		{5277, 	"ROGUE",	1,	{5277,	180,	15}},	--Evasion
		{57934, "ROGUE",	1,	{57934,	30,	6}},	--Tricks of the Trade

		{49576,	"DEATHKNIGHT",	1,	{49576,	35,	0}},	--Grip
		{48707,	"DEATHKNIGHT",	1,	{48707,	45,	5}},	--AMS
		{42650,	"DEATHKNIGHT",	1,	{42650,	600,	0}},	--Army
		{61999,	"DEATHKNIGHT",	1,	{61999,	600,	0}},	--Res
		{56222,	"DEATHKNIGHT",	1,	{56222,	8,	0}},	--Taunt
		{51052,	"DEATHKNIGHT",	1,	{51052,	120,	10}},	--AMZ
		{49028,	"DEATHKNIGHT",	1,	{49028,	90,	12}},	--DRW
		{49016,	"DEATHKNIGHT",	1,	{49016,	180,	30}},	--Unholy Frenzy
	}
	module.db.spell_isTalent[GetSpellInfo(16190) or "spell:16190"] = true	module.db.spell_isTalent[16190] = true
	module.db.spell_isTalent[GetSpellInfo(10060) or "spell:10060"] = true	module.db.spell_isTalent[10060] = true
	module.db.spell_isTalent[GetSpellInfo(11958) or "spell:11958"] = true	module.db.spell_isTalent[11958] = true
	module.db.spell_isTalent[GetSpellInfo(51052) or "spell:51052"] = true	module.db.spell_isTalent[51052] = true
	module.db.spell_isTalent[GetSpellInfo(47788) or "spell:47788"] = true	module.db.spell_isTalent[47788] = true
	module.db.spell_isTalent[GetSpellInfo(33206) or "spell:33206"] = true	module.db.spell_isTalent[33206] = true
	module.db.spell_isTalent[GetSpellInfo(724) or "spell:724"] = true	module.db.spell_isTalent[724] = true
	module.db.spell_isTalent[GetSpellInfo(64205) or "spell:64205"] = true	module.db.spell_isTalent[64205] = true
	module.db.spell_isTalent[GetSpellInfo(49028) or "spell:49028"] = true	module.db.spell_isTalent[49028] = true
	module.db.spell_isTalent[GetSpellInfo(49016) or "spell:49016"] = true	module.db.spell_isTalent[49016] = true
	module.db.spell_isTalent[GetSpellInfo(31821) or "spell:31821"] = true	module.db.spell_isTalent[31821] = true

	module.db.spell_resetOtherSpells[GetSpellInfo(11958) or "spell:11958"] = {GetSpellInfo(45438)}

	module.db.spell_aura_list[GetSpellInfo(45438) or "spell:45438"] = GetSpellInfo(45438)
	module.db.spell_aura_list[GetSpellInfo(47788) or "spell:47788"] = GetSpellInfo(47788)
	module.db.spell_aura_list[GetSpellInfo(9863) or "spell:9863"] = GetSpellInfo(9863)

	module.db.spell_afterCombatNotReset[GetSpellInfo(20608) or "spell:20608"] = true	module.db.spell_afterCombatNotReset[20608] = true

	module.db.spell_cdByTalent_fix[31884] = {53375,{-30,-60}}
	module.db.spell_cdByTalent_fix[871] = {12312,{-30,-60}}
	module.db.spell_cdByTalent_fix[10278] = {20174,{-60,-120}}
	module.db.spell_cdByTalent_fix[10310] = {20234,{-120,-240}}
	module.db.spell_cdByTalent_fix[11958] = {55091,{"*0.9","*0.8"}}
	module.db.spell_cdByTalent_fix[33206] = {47507,{"*0.9","*0.8"}}
	module.db.spell_cdByTalent_fix[10060] = {47507,{"*0.9","*0.8"}}
	module.db.spell_cdByTalent_fix[20608] = {16209,{"*0.75","*0.5"}}
	module.db.spell_cdByTalent_fix[9863] = {17123,{"*0.7","*0.4"}}
	module.db.spell_cdByTalent_fix[42650] = {55620,{-60,-120}}
	module.db.spell_cdByTalent_fix[49576] = {49588,{-5,-10}}

	module.db.spell_durationByTalent_fix[1044] = {20174,{2,4}}

	module.db.spellIgnoreAfterFirstUse[9863] = 10
	module.db.spellIgnoreAfterFirstUse[64843] = 10
	module.db.spellIgnoreAfterFirstUse[64901] = 10
	module.db.spellIgnoreAfterFirstUse[42650] = 10

	module.db.spell_startCDbyAuraFade[GetSpellInfo(57934) or "spell:57934"] = 57934		module.db.spell_startCDbyAuraFade[57934] = 57934
	module.db.spell_startCDbyAuraFade[GetSpellInfo(57934) or "spell:57934"] = GetSpellInfo(57934)		module.db.spell_startCDbyAuraFade[57934] = GetSpellInfo(57934)

	module.db.spell_sharingCD[GetSpellInfo(31884) or "spell:31884"] = {[GetSpellInfo(642) or "spell:642"]=30}

elseif ExRT.isBC then
	module.db.AllSpells = {
		{29166,	"DRUID",	1,	{29166,	360,	20}},	--Озарение
		{20748,	"DRUID",	1,	{20748,	1200,	0}},	--BR
		{6795,	"DRUID",	1,	{6795,	10,	0}},	--Taunt
		{9863,	"DRUID",	1,	{9863,	600,	8}},	--Tranq
		{5209,	"DRUID",	1,	{5209,	600,	6}},	--Challenging Roar

		{355,	"WARRIOR",	1,	{355,	10,	0}},	--Taunt
		{12975,	"WARRIOR",	1,	{12975,	480,	20}},	--Last stand
		{871,	"WARRIOR",	1,	{871,	1800,	10}},	--SW
		{1161,	"WARRIOR",	1,	{1161,	600,	6}},	--Challenging Shout
		{12809,	"WARRIOR",	1,	{12809,	45,	5}},	--Concussion Blow
		{676,	"WARRIOR",	1,	{676,	60,	10}},	--Disarm

		{11958,	"MAGE",		1,	{11958,	480,	0}},	--Cold Snap
		{12472,	"MAGE",		1,	{12472,	180,	20}},	--IV
		{45438,	"MAGE",		1,	{45438,	300,	10}},	--IB

		{1020,	"PALADIN",	1,	{1020,	300,	12}},	--DS
		{10310,	"PALADIN",	1,	{10310,	3600,	0}},	--LoH
		{19752,	"PALADIN",	1,	{19752,	3600,	180}},	--DI
		{31884,	"PALADIN",	1,	{31884,	180,	20}},	--AW

		{16190,	"SHAMAN",	1,	{16190,	300,	12}},	--MTT
		{32182,	"SHAMAN",	1,	{32182,	600,	40},	specialCheck=function() if UnitFactionGroup('player')=="Alliance" then return true end end},	--BL [A]
		{2825,	"SHAMAN",	1,	{2825,	600,	40},	specialCheck=function() if UnitFactionGroup('player')=="Horde" then return true end end},	--BL [H]
		{20608,	"SHAMAN",	1,	{21169,	3600,	0}},	--Reincarnation
		{2894, 	"SHAMAN",	1,	{2894,	1200,	120}},	--FET
		{2062, 	"SHAMAN",	1,	{2062, 	1200,	120}},	--EET

		{20765,	"WARLOCK",	1,	{20765,	1800,	0}},	--Soulstone

		{19801, "HUNTER",	1,	{19801,	20,	0}},	--Tranq
		{34477, "HUNTER",	1,	{34477,	120,	30}},	--MD
		{19577, "HUNTER",	1,	{19577,	60,	3}},	--MD
		{5384, 	"HUNTER",	1,	{5384,	30,	0}},	--Feign Death

		{28275, "PRIEST",	1,	{28275,	360,	180}}, 	--Lightwell
		{6346, 	"PRIEST",	1,	{6346,	180,	0}}, 	--Fear Ward
		{32548, "PRIEST",	1,	{32548,	300,	15},	specialCheck=function(_,_,_,r) if r=="Draenei" then return true end end}, 	--Symbol of Hope
		{10060, "PRIEST",	1,	{10060,	180,	15}},	--Power Infusion

		{5277, 	"ROGUE",	1,	{5277,	300,	15}},	--Evasion
	}
	module.db.spell_isTalent[GetSpellInfo(16190) or "spell:16190"] = true	module.db.spell_isTalent[16190] = true
	module.db.spell_isTalent[GetSpellInfo(10060) or "spell:10060"] = true	module.db.spell_isTalent[10060] = true
	module.db.spell_isTalent[GetSpellInfo(11958) or "spell:11958"] = true	module.db.spell_isTalent[11958] = true

	module.db.spell_resetOtherSpells[GetSpellInfo(11958) or "spell:11958"] = {GetSpellInfo(45438)}
	module.db.spell_aura_list[GetSpellInfo(45438) or "spell:45438"] = GetSpellInfo(45438)

elseif ExRT.isClassic then
	module.db.AllSpells = {
		{29166,	"DRUID",	1,	{29166,	360,	20}},	--Озарение
		{20748,	"DRUID",	1,	{20748,	1800,	0}},	--BR
		{6795,	"DRUID",	1,	{6795,	10,	0}},	--Taunt
		{9863,	"DRUID",	1,	{9863,	300,	10}},	--Tranq
		{5209,	"DRUID",	1,	{5209,	600,	6}},	--Challenging Roar

		{355,	"WARRIOR",	1,	{355,	10,	0}},	--Taunt
		{12975,	"WARRIOR",	1,	{12975,	600,	20}},	--Last stand
		{871,	"WARRIOR",	1,	{871,	1800,	10}},	--SW
		{1161,	"WARRIOR",	1,	{1161,	600,	6}},	--Challenging Shout

		{11958,	"MAGE",		1,	{11958,	480,	40}},	--IB

		{1020,	"PALADIN",	1,	{1020,	300,	12}},	--DS
		{10310,	"PALADIN",	1,	{10310,	3600,	0}},	--LoH
		{19752,	"PALADIN",	1,	{19752,	3600,	0}},	--DI

		{17359,	"SHAMAN",	1,	{17359,	300,	12}},	--MTT

		{20765,	"WARLOCK",	1,	{20765,	1800,	0}},	--Soulstone
	}
end