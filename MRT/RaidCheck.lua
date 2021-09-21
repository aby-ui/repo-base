local GlobalAddonName, ExRT = ...

local IsEncounterInProgress, GetTime = IsEncounterInProgress, GetTime

local VMRT = nil

local module = ExRT:New("RaidCheck",ExRT.L.raidcheck)
local ELib,L = ExRT.lib,ExRT.L

module.db.tableFood = not ExRT.isClassic and {
--Haste		Mastery		Crit		Versa		Int		Str 		Agi		Stam		Stam		Special
						[185736]=5,
[257413]=5,	[257418]=5,	[257408]=5,	[257422]=5,	[259449]=10,	[259452]=10,	[259448]=10,	[259453]=10,	[288074]=5,
[257415]=10,	[257420]=10,	[257410]=10,	[257424]=10,	[259455]=14,	[259456]=14,	[259454]=14,	[259457]=10,	[288075]=10,
								[290468]=10,	[290469]=10,	[290467]=10,	--85 actually
								[285719]=5,	[285720]=5,	[285721]=5,	[288074]=5,	[288075]=10,	[286171]=10,
								[297117]=14,	[297118]=14,	[297116]=14,
[297034]=14,	[297035]=14,	[297039]=14,	[297037]=14,							[297119]=14,	[297040]=14,
} or {
	[18192]=true,	[24799]=true,	[18194]=true,	[22730]=true,	[25661]=true,	[18141]=true,	[18125]=true,
	[22790]=true,	[22789]=true,	[25804]=true,
	[18222]=true,
	[18125]=true,	[18141]=true,

	--tbc
	[33257]=true,	[33257]=true,	[35272]=true,	[45245]=true,	[33254]=true,	[33254]=true,	[35272]=true,	[33254]=true,	[33268]=true,
	[33263]=true,	[33263]=true,	[33263]=true,	[33259]=true,	[33261]=true,	[33261]=true,	[33256]=true,	[43764]=true,	[43722]=true,	[33265]=true,	[45619]=true,

	[46682]=true,	[44104]=true,	[44098]=true,	[44101]=true,	[44099]=true,	[44102]=true,	[44106]=true,	[44105]=true,	[44097]=true,
	[44100]=true,	[43771]=true,	[33272]=true,	[19705]=true,	[19710]=true,	[19706]=true,	[19708]=true,	[46899]=true,	[19709]=true,
	[25941]=true,	[40323]=true,	[42293]=true,	[25694]=true,	[19711]=true,	[24870]=true,
}
module.db.StaminaFood = {[201638]=true,[259457]=true,[288075]=true,[288074]=true,[297119]=true,[297040]=true,}

module.db.tableFood_headers = {0,5,10,14}
module.db.tableFlask =  not ExRT.isClassic and {
	--Stamina,	Int,		Agi,		Str 
	[251838]=25,	[251837]=25,	[251836]=25,	[251839]=25,
	[298839]=38,	[298837]=38,	[298836]=38,	[298841]=38,
} or {
	[17629]=true,	[17627]=true,	[17628]=true,	[17626]=true,
	[17538]=true,	[11474]=true,	[17539]=true,	[26276]=true,
	[21920]=true,	[17535]=true,	[11348]=true,	[11371]=true,

	[24382]=true,	[24417]=true,	[24383]=true,
	[10669]=true,	[10692]=true,	[10693]=true,	[10668]=true,
	[17538]=true,	[24363]=true,	[3593]=true,	[11348]=true,	[24361]=true,	[11371]=true,
	[16323]=true,	[11405]=true,	[16329]=true,	[17038]=true,	[17539]=true,	[11474]=true,	[26276]=true,	[21920]=true,
	[16326]=true,	[16325]=true,	[15233]=true,	[15279]=true,	[5665]=true,
	[17549]=true,	[17543]=true,	[17544]=true,	[17546]=true,	[17548]=true,
	[17545]=true,	[17537]=true,
	[11334]=true,

	--tbc
	[28518]=true,	[28540]=true,	[28520]=true,	[28521]=true,	[28519]=true,	[42735]=true,
	[41609]=true,	[46837]=true,	[41608]=true,	[46839]=true,	[41610]=true,	[41611]=true,
	[40572]=true,	[40576]=true,	[40567]=true,	[40568]=true,	[40573]=true,	[40575]=true,
	[28503]=true,	[38954]=true,	[28497]=true,	[28501]=true,	[28493]=true,	[28491]=true,	[33726]=true,	[28490]=true,	[33721]=true,	[33720]=true,
	[28514]=true,	[28509]=true,	[28502]=true,	[39628]=true,	[39627]=true,	[39626]=true,	[39625]=true,

	[11406]=true,	[28496]=true,	[28489]=true,	[28515]=true,	[38910]=true,	[38927]=true,	[28511]=true,
	[28537]=true,	[28513]=true,	[28512]=true,	[28536]=true,	[28538]=true,
}
module.db.tableFlask_headers = {0,25,38}
module.db.tablePotion = {
	[188024]=true,	--Run haste
	[250871]=true,	--Mana
	[252753]=true,	--Mana channel
	[250872]=true,	--Mana+hp

	[279152]=true,	--Agi
	[279151]=true,	--Int
	[279154]=true,	--Stamina
	[279153]=true,	--Str
	[251231]=true,	--Armor

	[298152]=true,	--Int
	[298146]=true,	--Agi
	[298153]=true,	--Stamina
	[298154]=true,	--Str
	[298155]=true,	--Armor

	[298225]=true,	--Potion of Empowered Proximity
	[298317]=true,	--Potion of Focused Resolve
	[300714]=true,	--Potion of Unbridled Fury
	[300741]=true,	--Potion of Wild Mending


	[251316]=true,	--Potion of Bursting Blood
	[269853]=true,	--Potion of Rising Death

	[250873]=true,	--Invis
	[250878]=true,	--Run haste
	[251143]=true,	--Fall

	[307159]=true,	--Agi
	[307162]=true,	--Int
	[307163]=true,	--Stam
	[307164]=true,	--Str
	[307160]=true,	--Armor

	[307161]=true,	--Mana sleep
	[307194]=true,	--Mana+hp
	[307193]=true,	--Mana

	[307497]=true,	--Potion of Deathly Fixation
	[307494]=true,	--Potion of Empowered Exorcisms
	[307496]=true,	--Potion of Divine Awakening
	[307495]=true,	--Potion of Phantom Fire
	[322302]=true,	--Potion of Sacrificial Anima
	[344314]=true,	--Run
	[307199]=true,	--Potion of Soul Purity
	[342890]=true,	--Potion of Unhindered Passing
	[307196]=true,	--Potion of Shadow Sight
	[307195]=true,	--Invis
}
module.db.hsSpells = {
	[6262] = true,
	[105708] = true,
	[156438] = true,
	[188016] = true,
	--[188018] = true,
	[250870] = true,
	[301308] = true,

	[307192] = true,
}
module.db.raidBuffs = {
	{ATTACK_POWER_TOOLTIP or "AP","WARRIOR",6673,264761},
	{SPELL_STAT3_NAME or "Stamina","PRIEST",21562,264764},
	{SPELL_STAT4_NAME or "Int","MAGE",1459,264760},
}
module.db.tableInt = {[1459]=true,[264760]=7,}
module.db.tableStamina = {[21562]=true,[264764]=7,}
module.db.tableAP = {[6673]=true,[264761]=7,}
module.db.tableVantus = {
	--uldir
	[269276] = 1,
	[269405] = 2,
	[269408] = 3,
	[269407] = 4,
	[269409] = 5,
	[269411] = 6,
	[269412] = 7,
	[269413] = 8,

	--ep
	[298622] = 1,
	[298640] = 2,
	[298642] = 3,
	[298643] = 4,
	[298644] = 5,
	[298645] = 6,
	[298646] = 7,
	[302914] = 8,

	--Nyl
	[306475] = 1,
	[306480] = 2,
	[306476] = 3,
	[306477] = 4,
	[306478] = 5,
	[306484] = 6,
	[306485] = 7,
	[306479] = 8,
	[313550] = 9,
	[313551] = 10,
	[313554] = 11,
	[313556] = 12,

	--CN
	[311445] = 1,
	[334132] = 2,
	[311448] = 3,
	[311446] = 4,
	[311447] = 5,
	[311449] = 6,
	[311450] = 7,
	[311451] = 8,
	[311452] = 9,
	[334131] = 10,

	--SoD
	[354384] = 1,
	[354385] = 2,
	[354386] = 3,
	[354387] = 4,
	[354388] = 5,
	[354389] = 6,
	[354390] = 7,
	[354391] = 8,
	[354392] = 9,
	[354393] = 10,
}

module.db.minFoodLevelToActual = {
	[100] = 10,
	[125] = 14,
}

--TBC SCROLLS
module.db.tableScrolls = not ExRT.isClassic and {} or {
	[33077]=true,
	[33082]=true,
	[33079]=true,
	[33078]=true,
	[33080]=true,
	[33081]=true,
	[12174]=true,
	[12179]=true,
	[12176]=true,
	[12178]=true,
	[12177]=true,
	[12175]=true,
}

if not ExRT.isClassic and UnitLevel'player' > 50 then
	module.db.tableFood = {
	--Haste		Mastery		Crit		Versa		Int		Str 		Agi		Stam		Stam		Special
	[308488]=30,	[308506]=30,	[308434]=30,	[308514]=30,	[327708]=20,	[327706]=20,	[327709]=20,	[308525]=30,	[327707]=30,	[308637]=30,
	[308474]=18,	[308504]=18,	[308430]=18,	[308509]=18,	[327704]=18,	[327701]=18,	[327705]=18,	[327702]=18,	[308525]=18,
									--[341449]=20,
	}
	module.db.tableFoodIsBest = {
	--Haste		Mastery		Crit		Versa		Int		Str 		Agi		Stam		Stam		Special
	[308488]=30,	[308506]=30,	[308434]=30,	[308514]=30,	[327708]=30,	[327706]=30,	[327709]=30,	[308525]=30,	[327707]=30,	[308637]=30,
									--[341449]=30,
	}
	module.db.tableFood_headers = {0,18,30}

	module.db.tableFlask = {
	--Stamina,	Main stat,
	[307187]=70,	[307185]=70,	[307166]=70,
	}
	module.db.tableFlask_headers = {0,70}

	for i=1,#module.db.raidBuffs do
		module.db.raidBuffs[i][4] = nil
	end

	module.db.minFoodLevelToActual = {
		[100] = 18,
		[125] = 30,
	}
	module.db.tableInt = {[1459]=true,}
	module.db.tableStamina = {[21562]=true,}
	module.db.tableAP = {[6673]=true,}
end

module.db.classicBuffs = {
	{"druid","Druid",136078,{[21850]=7,[21849]=6,[1126]=1,[5232]=2,[5234]=4,[6756]=3,[8907]=5,[9884]=6,[9885]=7,}},	--Gift of the Wild
	{"int","Int",135932,{[10157]=5,[10156]=4,[1461]=3,[1460]=2,[1459]=1,[23028]=5}},	--Arcane Intellect
	{"ap","AP",132333,{[6673]=1,[5242]=2,[6192]=3,[11549]=4,[11550]=5,[11551]=6,[25289]=7,}},	--Battle Shout
	{"spirit","Spirit",135946,{[27681]=4,[14752]=1,[14818]=2,[14819]=3,[27841]=4,}},	--Prayer of Spirit
	{"armor","Armor",135926,{[588]=1,[7128]=2,[602]=3,[1006]=4,[10951]=5,[10952]=6,}},	--Inner Fire
	{"shadow","Shadow",136121,{[10958]=3,[976]=1,[10957]=2,[27683]=3,}},	--Shadow Protection
	{"stamina","Stamina",135987,{[1243]=1,[21562]=5,[21564]=6,[1244]=2,[1245]=3,[2791]=4,[10937]=5,[10938]=6,}},	--Power Word: Fortitude
}
if ExRT.isBC then
	module.db.classicBuffs = {
		{"druid","Druid",136078,{[26991]=8,[21850]=7,[21849]=6,[1126]=1,[5232]=2,[5234]=4,[6756]=3,[8907]=5,[9884]=6,[9885]=7,[26990]=8,}},	--Gift of the Wild
		{"int","Int",135932,{[27126]=6,[10157]=5,[10156]=4,[1461]=3,[1460]=2,[1459]=1,[23028]=5,[27127]=6,}},	--Arcane Intellect
		{"ap","AP",132333,{[6673]=1,[5242]=2,[6192]=3,[11549]=4,[11550]=5,[11551]=6,[25289]=7,[2048]=8,}},	--Battle Shout
		{"spirit","Spirit",135946,{[27681]=4,[32999]=5,[14752]=1,[14818]=2,[14819]=3,[27841]=4,[25312]=5,}},	--Prayer of Spirit
		{"armor","Armor",135926,{[588]=1,[7128]=2,[602]=3,[1006]=4,[10951]=5,[10952]=6,[25431]=7,}},	--Inner Fire
		{"shadow","Shadow",136121,{[25433]=4,[10958]=3,[976]=1,[10957]=2,[27683]=3,[39374]=4,}},	--Shadow Protection
		{"stamina","Stamina",135987,{[1243]=1,[21562]=5,[21564]=6,[25392]=7,[1244]=2,[1245]=3,[2791]=4,[10937]=5,[10938]=6,[25389]=7,}},	--Power Word: Fortitude
	}
end
if ExRT.isClassic and UnitFactionGroup("player") == "Alliance" and not ExRT.isBC then
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bom","BoM",135908,{[19740]=1,[19834]=2,[19835]=3,[19836]=4,[19837]=5,[19838]=6,[25291]=7,[25782]=6,[25916]=7,}}	--Blessing of Might
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bow","BoW",135970,{[19742]=1,[19850]=2,[19852]=3,[19853]=4,[19854]=5,[25290]=6,[25894]=5,[25918]=6,}}	--Blessing of Wisdom
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bok","BoK",135993,{[20217]=1,[25898]=1,}}	--Blessing of Kings
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bos","BoS",135967,{[1038]=1,[25895]=1,}}	--Blessing of Kings
end
if ExRT.isBC then
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bom","BoM",135908,{[19740]=1,[19834]=2,[19835]=3,[19836]=4,[19837]=5,[19838]=6,[25291]=7,[27140]=8,[25782]=6,[25916]=7,[27141]=8}}	--Blessing of Might
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bow","BoW",135970,{[19742]=1,[19850]=2,[19852]=3,[19853]=4,[19854]=5,[25290]=6,[27142]=7,[25894]=5,[25918]=6,[27143]=7,}}	--Blessing of Wisdom
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bok","BoK",135993,{[20217]=1,[25898]=1,}}	--Blessing of Kings
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bos","BoS",135967,{[1038]=1,[25895]=1,}}	--Blessing of Kings
end
module.db.tableClassicBuff = {}
if ExRT.isClassic then
	for i=1,#module.db.classicBuffs do
		for k,v in pairs(module.db.classicBuffs[i][4]) do
			module.db.tableClassicBuff[k] = module.db.classicBuffs[i]
		end
	end
end

module.db.potionList = {}
module.db.hsList = {}
module.db.tableFoodInProgress = nil
module.db.RaidCheckReadyCheckHide = nil
module.db.RaidCheckReadyCheckTime = nil
module.db.RaidCheckReadyCheckTable = {}
module.db.RaidCheckReadyPPLNum = 0
module.db.RaidCheckReadyCheckHideSchedule = nil

module.db.tableRunes = {[224001]=5,[270058]=6,[317065]=6,[347901]=18,}

module.db.durability = {}
module.db.oil = {}
module.db.oil2 = {}
module.db.kit = {}

local IsSendFoodByMe,IsSendFlaskByMe,IsSendRunesByMe,IsSendBuffsByMe,IsSendKitsByMe,IsSendOilsByMe = nil

local _GetRaidRosterInfo = GetRaidRosterInfo

local function GetRaidRosterInfo(raidUnitID)
	if IsInRaid() then
		return _GetRaidRosterInfo(raidUnitID)
	elseif raidUnitID <= 5 then
		local unit = raidUnitID <= 4 and "party"..raidUnitID or "player"
		return ExRT.F.UnitCombatlogname(unit),nil,1,nil,nil,select(2,UnitClass(unit))
	else
		return nil
	end
end

local function GetPotion(arg1)
	local h = L.raidcheckPotion
	local t = {}
	for key,val in pairs(module.db.potionList) do
		t[#t+1] = {key,val}
	end

	local function toChat(h)
		local chat_type = ExRT.F.chatType(true)
		if arg1 == 2 then print(h) end
		if arg1 == 1 then SendChatMessage(h,chat_type) end  
	end

	table.sort(t,function(a,b) return a[2]>b[2] end)
	for i=1,#t do
		h = h .. format("%s %d%s",t[i][1],t[i][2],i<#t and ", " or "")
		if #h > 230 then
			toChat(h)
			h = ""
		end
	end
	toChat(h)
end

local function GetHs(arg1)
	local h = L.raidcheckHS
	local t = {}
	for key,val in pairs(module.db.hsList) do
		t[#t+1] = {key,val}
	end

	local function toChat(h)
		local chat_type = ExRT.F.chatType(true)
		if arg1 == 2 then print(h) end
		if arg1 == 1 then SendChatMessage(h,chat_type) end
	end

	table.sort(t,function(a,b) return a[2]>b[2] end)
	for i=1,#t do
		h = h .. format("%s %d%s",t[i][1],t[i][2],i<#t and ", " or "")
		if #h > 230 then
			toChat(h)
			h = ""
		end
	end
	toChat(h)
end

--[[
	Check Types:

	1 - to chat
	2 - ready check
	3 - ready check (self)
	nil - self
]]

local function PublicResults(msg,chat_type)
	if msg == "" or not msg then
		return
	elseif chat_type then
		msg = msg:gsub("|c........","")
		msg = msg:gsub("|r","")

		chat_type = ExRT.F.chatType(true)
		SendChatMessage(msg,chat_type)
	else
		print(msg)
	end
end

local function GetRunes(checkType)
	local f = {[0]={}}
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local _,_,_,_,_,_,_,_,_,spellId = UnitAura(name, i,"HELPFUL")
				if not spellId then
					break
				else
					local isRune = module.db.tableRunes[spellId]
					if isRune then
						f[isRune] = f[isRune] or {}
						f[isRune][ #f[isRune]+1 ] = name
						isAnyBuff = true
						break
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = name
			end
		end
	end

	if not checkType or checkType == 1 then
		for _,stats in ipairs({0,5,6}) do
			f[stats] = f[stats] or {}
			local result = format("|cff00ff00%d (%d):|r ",stats,#f[stats])
			for i=1,#f[stats] do
				result = result .. f[stats][i]
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				elseif i ~= #f[stats] then
					result = result .. ", "
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		f[5] = f[5] or {}
		local result = format("|cff00ff00%s (%d):|r ",L.RaidCheckNoRunes,#f[0]+#f[5])
		for i=1,#f[0] do
			result = result .. f[0][i]
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			elseif i ~= #f[0] or #f[5] > 0 then
				result = result .. ", "
			end
		end
		for i=1,#f[5] do
			result = result .. f[5][i] .. "(5)"
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			elseif i ~= #f[5] then
				result = result .. ", "
			end
		end
		PublicResults(result,checkType)
	end
end

local vruneName
local function GetVRunes(checkType)
	if not vruneName then
		local kjrunename = GetSpellInfo(237825)
		if kjrunename then
			kjrunename = kjrunename:match("^(.-)[:%-：]")
			if kjrunename then
				vruneName = "^"..kjrunename
			end
		end
	end
	local f = {[0]={},[1]={}}
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local auraName = UnitAura(name, i,"HELPFUL")
				if type(auraName)~='string' then
					break
				elseif vruneName then
					local isRune = auraName:find(vruneName)
					if isRune then
						f[1][ #f[1]+1 ] = name
						isAnyBuff = true
						break
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = name
			end
		end
	end

	PublicResults((vruneName or ""):gsub("%^",""),checkType)
	for stats,name in pairs({[0]=L.NoText,[1]=L.YesText}) do
		local result = format("|cff00ff00%s (%d):|r ",name,#f[stats])
		for i=1,#f[stats] do
			result = result .. f[stats][i]
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			elseif i ~= #f[stats] then
				result = result .. ", "
			end
		end
		PublicResults(result,checkType)
	end
end


local function GetFood(checkType)
	local f = {[0]={}}
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local _,_,_,_,_,_,_,_,_,spellId,_,_,_,_,_,stats = UnitAura(name, i,"HELPFUL")
				if not spellId then
					break
				else
					local foodType = module.db.tableFood[spellId]
					if foodType then
						local _,unitRace = UnitRace(name)

						if unitRace == "Pandaren" and stats then
							stats = stats / 2
						end
						if module.db.StaminaFood[spellId] and stats then
							stats = ceil( stats / 1.5 )
						end
						stats = foodType or stats			---ALERT HERE, stats must be first; replace on future updates
						if module.db.tableFoodIsBest[spellId] then
							stats = module.db.tableFoodIsBest[spellId]
						end

						if spellId == 201641 or spellId == 201640 or spellId == 201639 or spellId == 201638 then 
							stats = foodType
						elseif spellId == 201636 or spellId == 201634 or spellId == 201635 or spellId == 201637 then 
							stats = foodType
						elseif (spellId == 259449 or spellId == 259452 or spellId == 259448 or spellId == 259453) or (spellId == 259455 or spellId == 259456 or spellId == 259454 or spellId == 259457) then 
							stats = foodType
						elseif spellId == 185736 then
							stats = foodType
						end

						f[stats] = f[stats] or {}
						f[stats][ #f[stats]+1 ] = name

						isAnyBuff = true
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = name
			end
		end
	end

	if not checkType or checkType == 1 then
		for _,foodType in ipairs(module.db.tableFood_headers) do
			f[foodType] = f[foodType] or {}
			local result = format("|cff00ff00%d (%d):|r ",foodType,#f[foodType])
			for j=1,#f[foodType] do
				result = result .. f[foodType][j] .. (j < #f[foodType] and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		local counter,counterResult = 0,0
		local badStats = {}
		for statsNum,data in pairs(f) do
			if ((VMRT.RaidCheck.FoodMinLevel and statsNum < (module.db.minFoodLevelToActual[VMRT.RaidCheck.FoodMinLevel] or 375)) or (not VMRT.RaidCheck.FoodMinLevel and statsNum == 0)) and #data > 0 then
				badStats[#badStats + 1] = statsNum
				counter = counter + #data
			end
		end
		sort(badStats)
		local result = format("|cff00ff00%s (%d):|r ",L.raidchecknofood,counter)
		for i=1,#badStats do
			local statsNum = badStats[i]
			for j=1,#f[statsNum] do
				counterResult = counterResult + 1
				result = result .. f[statsNum][j].. (statsNum ~= 0 and "("..statsNum..")" or "") .. (counterResult < counter and ", " or "")
				if #result > 220 then
					PublicResults(result,checkType)
					result = ""
				end
			end
		end
		PublicResults(result,checkType)
	end
end

local function GetFlask(checkType)
	local f = {[0]={}}
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	local _time = GetTime()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local isAnyBuff = nil
			for i=1,40 do
				local _,_,_,_,_,expires,_,_,_,spellId = UnitAura(name, i,"HELPFUL")
				if not spellId then
					break
				else
					local flaskType = module.db.tableFlask[spellId]
					if flaskType then
						f[flaskType] = f[flaskType] or {}
						expires = expires or -1
						local lost = expires-_time
						if expires == 0 or lost < 0 then
							lost = 901
						end
						f[flaskType][ #f[flaskType]+1 ] = {name,lost}
						if ExRT.F.table_find(module.db.tableFlask_headers,flaskType) then
							isAnyBuff = true
						end
					end
				end
			end
			if not isAnyBuff then
				f[0][ #f[0]+1 ] = {name,901}
			end
		end
	end
	for flaskType,typeData in pairs(f) do
		table.sort(typeData,function(a,b) return a[2]<b[2] end)
	end

	local showExpFlasks_seconds = VMRT.RaidCheck.FlaskExp == 1 and 300 or VMRT.RaidCheck.FlaskExp == 2 and 600 or -1

	if not checkType or checkType == 1 then
		for i=1,#module.db.tableFlask_headers do
			local flaskStats = module.db.tableFlask_headers[i]
			f[ flaskStats ] = f[ flaskStats ] or {}
			local result = format("|cff00ff00%d (%d):|r ",flaskStats,#f[ flaskStats ])
			for j=1,#f[ flaskStats ] do
				result = result .. format("%s%s",f[ flaskStats ][j][1] or "?", j < #f[ flaskStats ] and ", " or "")
				if #result > 230 then
					PublicResults(result,checkType)
					result = ""
				end
			end
			PublicResults(result,checkType)
		end
	elseif checkType == 2 or checkType == 3 then
		if checkType == 3 then
			checkType = nil
		end
		f[0] = f[0] or {}
		local result = format("|cff00ff00%s (%d):|r ",L.raidchecknoflask,#f[0])
		for j=1,#f[0] do
			result = result .. format("%s%s",f[0][j][1] or "?",j < #f[0] and ", " or "")
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			end
		end
		local strings_list = {}
		for i=1,#module.db.tableFlask_headers do
			local flaskStats = module.db.tableFlask_headers[i]
			if flaskStats ~= 0 then
				f[ flaskStats ] = f[ flaskStats ] or {}
				for j=1,#f[ flaskStats ] do
					if f[ flaskStats ][j][2] <= showExpFlasks_seconds and f[ flaskStats ][j][2] >= 0 then
						local mins = floor( f[ flaskStats ][j][2] / 60 )
						strings_list[#strings_list + 1] = format("%s%s%s",f[ flaskStats ][j][1] or "?", "("..(mins == 0 and "<1" or tostring(mins))..")", i < #module.db.tableFlask_headers and i > 1 and (not VMRT.RaidCheck.FlaskLQ) and " LQ" or "")
					elseif i < #module.db.tableFlask_headers and i > 1 and not VMRT.RaidCheck.FlaskLQ then
						strings_list[#strings_list + 1] = format("%s%s",f[ flaskStats ][j][1] or "?"," LQ")
					end
				end
			end
		end
		local strings_list_len = #strings_list
		if strings_list_len > 0 then
			result = result .. ( #f[0] > 0 and result ~= "" and ", " or "" )
		end
		for i=1,strings_list_len do
			result = result .. strings_list[i] .. (i < strings_list_len and ", " or "")
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			end
		end
		PublicResults(result,checkType)
	end
end

local function GetRaidBuffs(checkType)
	local buffsList,buffsListLen = module.db.raidBuffs,#module.db.raidBuffs
	local f = {}
	for k=1,buffsListLen * 2 do
		f[k] = 0
	end
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	local isAnyBuff = {}
	for j=1,40 do
		local name,_,subgroup, _, _, class = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			for k=1,buffsListLen * 2 do
				isAnyBuff[k] = false
			end
			for k=1,buffsListLen do
				if class == buffsList[k][2] then
					f[-k] = true
				end
			end
			for i=1,40 do
				local _,_,_,_,_,_,_,_,_,auraSpellID = UnitAura(name, i,"HELPFUL")
				if not auraSpellID then
					break
				else
					for k=1,buffsListLen do
						if auraSpellID == buffsList[k][3] then
							isAnyBuff[k] = true
							isAnyBuff[buffsListLen + k] = true
						elseif auraSpellID == buffsList[k][4] then
							isAnyBuff[buffsListLen + k] = true
						end
					end
				end
			end
			for k=1,buffsListLen do
				if not isAnyBuff[k] then
					f[k] = f[k] + 1
				end
				if not isAnyBuff[buffsListLen + k] then
					f[buffsListLen + k] = f[buffsListLen + k] + 1
				end
			end
		end
	end

	if true then
		if checkType == 3 then
			checkType = nil
		end
		local result = format("|cff00ff00%s|r ",GARRISON_MISSION_PARTY_BUFFS)

		local isAnyBuff = true
		for k=1,buffsListLen do
			if f[k] > 0 and f[-k] then
				isAnyBuff = false
				result = result .. buffsList[k][1] .. " ("..f[k].."), "
			elseif f[buffsListLen + k] > 0 and not f[-k] and UnitLevel'player' == 50 then	--check for minor buffs (7%), but only in BfA actually
				isAnyBuff = false
				result = result .. buffsList[k][1] .. " ("..f[buffsListLen + k].."), "
			end
		end
		if isAnyBuff then
			result = result .. ALL
		else
			result = result:gsub(", $","")
		end
		PublicResults(result,checkType)
	end
end

local function GetKits(checkType)
	local list = {
		YES = {},
		NO = {},
		NO_ADDON = {},
	}
	local currTime = time()
	for index, name in ExRT.F.IterateRoster, ExRT.F.GetRaidDiffMaxGroup() do
		if name then
			local shortName = strsplit("-",name)
			local data = module.db.kit[name] or module.db.kit[shortName]

			if data then
				local kNow,kMax = (data.kit or ""):match("(%d+)/(%d+)")
				if data.time + 600 < currTime then
					kNow = nil
				end
				if kNow == "1" then
					list.YES[#list.YES + 1] = shortName
				else
					list.NO[#list.NO + 1] = shortName
				end
			else
				list.NO[#list.NO + 1] = shortName
				list.NO_ADDON[shortName] = true
			end
		end
	end

	if checkType == 3 then
		checkType = nil
	end
	local result = format("|cff00ff00%s ",L.RaidCheckNoKits)

	if checkType == 2 or not checkType then
		sort(list.NO)
		result = result .."("..#list.NO.."):|r "
		for i=1,#list.NO do
			local name = list.NO[i]
			result = result .. name .. ( list.NO_ADDON[name] and " ("..L.RaidCheckNoAddon..")" or "" )
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			elseif i < #list.NO then
				result = result .. ", "
			end
		end
		result = result:gsub(", $","")
		if result ~= "" then
			PublicResults(result,checkType)
		end
	end
end

local function GetOils(checkType)
	local list = {
		YES = {},
		NO = {},
		NO_ADDON = {},
	}
	local currTime = time()
	for index, name in ExRT.F.IterateRoster, ExRT.F.GetRaidDiffMaxGroup() do
		if name then
			local shortName = strsplit("-",name)
			local data = module.db.oil[name] or module.db.oil[shortName]

			if data then
				local anyOil = true
				if data.time + 600 < currTime then
					anyOil = nil
				end
				if anyOil and data.oil == "0" then
					anyOil = nil
				end
				if not anyOil then
					local data2 = module.db.oil2[name] or module.db.oil2[shortName]
					if data2 then 
						anyOil = true
						if data2.time + 600 < currTime then
							anyOil = nil
						end
						if anyOil and data2.oil == "0" then
							anyOil = nil
						end
					end
				end
				if anyOil then
					list.YES[#list.YES + 1] = shortName
				else
					list.NO[#list.NO + 1] = shortName
				end
			else
				list.NO[#list.NO + 1] = shortName
				list.NO_ADDON[shortName] = true
			end
		end
	end

	if checkType == 3 then
		checkType = nil
	end
	local result = format("|cff00ff00%s ",L.RaidCheckNoOils)

	if checkType == 2 or not checkType then
		sort(list.NO)
		result = result .."("..#list.NO.."):|r "
		for i=1,#list.NO do
			local name = list.NO[i]
			result = result .. name .. ( list.NO_ADDON[name] and " ("..L.RaidCheckNoAddon..")" or "" )
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			elseif i < #list.NO then
				result = result .. ", "
			end
		end
		result = result:gsub(", $","")
		if result ~= "" then
			PublicResults(result,checkType)
		end
	end
end

--SCROLLS
local function GetScrolls(checkType)
	local f = {[0]={}}
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			for i=1,40 do
				local _,_,_,_,_,expires,_,_,_,spellId = UnitAura(name, i,"HELPFUL")
				if not spellId then
					break
				else
					local scrollType = module.db.tableScrolls[spellId]
					if scrollType then
						f[scrollType] = f[scrollType] or {}
					end
				end
			end
		end
	end

	if not checkType or checkType == 1 then
		result = ""
		PublicResults(result,checkType)
	end
end


module.GetRunes = GetRunes
module.GetVRunes = GetVRunes
module.GetFood = GetFood
module.GetFlask = GetFlask
module.GetRaidBuffs = GetRaidBuffs
module.GetKits = GetKits
module.GetOils = GetOils

function module.options:Load()
	self:CreateTilte()

	self.decorationLine = ELib:DecorationLine(self,true,"BACKGROUND",-5):Point("TOPLEFT",self,0,-16):Point("BOTTOMRIGHT",self,"TOPRIGHT",0,-36)

	self.tab = ELib:Tabs(self,0,LANDING_PAGE_REPORT,L.raidcheckReadyCheck,L.RaidCheckConsum):Point(0,-36):Size(698,598):SetTo(1)
	self.tab:SetBackdropBorderColor(0,0,0,0)
	self.tab:SetBackdropColor(0,0,0,0)


	self.food = ELib:Button(self.tab.tabs[1],L.raidcheckfood):Size(230,20):Point(15,-10):OnClick(function() GetFood() end)
	self.food.txt = ELib:Text(self.tab.tabs[1],"/rt food",10):Size(100,20):Point("LEFT",self.food,"RIGHT",5,0)

	self.foodToChat = ELib:Button(self.tab.tabs[1],L.raidcheckfoodchat):Size(230,20):Point("LEFT",self.food,"RIGHT",71,0):OnClick(function() GetFood(1) end)
	self.foodToChat.txt = ELib:Text(self.tab.tabs[1],"/rt foodchat",10):Size(100,20):Point("LEFT",self.foodToChat,"RIGHT",5,0)

	self.flask = ELib:Button(self.tab.tabs[1],L.raidcheckflask):Size(230,20):Point(15,-35):OnClick(function() GetFlask() end)
	self.flask.txt = ELib:Text(self.tab.tabs[1],"/rt flask",10):Size(100,20):Point("LEFT",self.flask,"RIGHT",5,0)

	self.flaskToChat = ELib:Button(self.tab.tabs[1],L.raidcheckflaskchat):Size(230,20):Point("LEFT",self.flask,"RIGHT",71,0):OnClick(function() GetFlask(1) end)
	self.flaskToChat.txt = ELib:Text(self.tab.tabs[1],"/rt flaskchat",10):Size(100,20):Point("LEFT",self.flaskToChat,"RIGHT",5,0)

	self.runes = ELib:Button(self.tab.tabs[1],L.RaidCheckRunesCheck):Size(230,20):Point(15,-60):OnClick(function() GetRunes() end)
	self.runes.txt = ELib:Text(self.tab.tabs[1],"/rt check r",10):Size(60,22):Point("LEFT",self.runes,"RIGHT",5,0)

	self.runesToChat = ELib:Button(self.tab.tabs[1],L.RaidCheckRunesChat):Size(230,20):Point("LEFT",self.runes,"RIGHT",71,0):OnClick(function() GetRunes(1) end)
	self.runesToChat.txt = ELib:Text(self.tab.tabs[1],"/rt check rc",10):Size(100,22):Point("LEFT",self.runesToChat,"RIGHT",5,0)

	self.vantusrunes = ELib:Button(self.tab.tabs[1],L.RaidCheckVRunesCheck):Size(230,20):Point(15,-85):OnClick(function() GetVRunes() end)
	self.vantusrunes.txt = ELib:Text(self.tab.tabs[1],"/rt check v",10):Size(60,22):Point("LEFT",self.vantusrunes,"RIGHT",5,0)

	self.vantusrunesToChat = ELib:Button(self.tab.tabs[1],L.RaidCheckVRunesChat):Size(230,20):Point("LEFT",self.vantusrunes,"RIGHT",71,0):OnClick(function() GetVRunes(1) end)
	self.vantusrunesToChat.txt = ELib:Text(self.tab.tabs[1],"/rt check vc",10):Size(100,22):Point("LEFT",self.vantusrunesToChat,"RIGHT",5,0)

	self.raidbuffs = ELib:Button(self.tab.tabs[1],L.RaidCheckBuffs):Size(230,20):Point(15,-110):OnClick(function() GetRaidBuffs() end)
	self.raidbuffs.txt = ELib:Text(self.tab.tabs[1],"/rt check b",10):Size(60,22):Point("LEFT",self.raidbuffs,"RIGHT",5,0)

	self.raidbuffsToChat = ELib:Button(self.tab.tabs[1],L.RaidCheckBuffsToChat):Size(230,20):Point("LEFT",self.raidbuffs,"RIGHT",71,0):OnClick(function() GetRaidBuffs(1) end)
	self.raidbuffsToChat.txt = ELib:Text(self.tab.tabs[1],"/rt check bc",10):Size(100,22):Point("LEFT",self.raidbuffsToChat,"RIGHT",5,0)

	self.level2optLine = CreateFrame("Frame",nil,self.tab.tabs[1])
	self.level2optLine:SetPoint("TOPLEFT",10,-135)
	self.level2optLine:SetSize(1,1)

	self.chkSlak = ELib:Check(self.tab.tabs[1],L.raidcheckslak,VMRT.RaidCheck.ReadyCheck):Point("TOPLEFT",self.level2optLine,7,0):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.ReadyCheck = true
		else
			VMRT.RaidCheck.ReadyCheck = nil
		end
	end)

	self.chkOnAttack = ELib:Check(self.tab.tabs[1],L.RaidCheckOnAttack,VMRT.RaidCheck.OnAttack):Point("TOPLEFT",self.chkSlak,"TOPLEFT",25,-25):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.OnAttack = true
		else
			VMRT.RaidCheck.OnAttack = nil
		end
	end)

	self.chkSendSelf = ELib:Check(self.tab.tabs[1],L.RaidCheckSendSelf,VMRT.RaidCheck.SendSelf):Point("TOPLEFT",self.chkOnAttack,"TOPLEFT",0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.SendSelf = true
		else
			VMRT.RaidCheck.SendSelf = nil
		end
	end)

	self.disableLFR = ELib:Check(self.tab.tabs[1],L.RaidCheckDisableInLFR,VMRT.RaidCheck.disableLFR):Point("TOPLEFT",self.chkSendSelf,"TOPLEFT",0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.disableLFR = true
		else
			VMRT.RaidCheck.disableLFR = nil
		end
	end)

	self.chkRunes = ELib:Check(self.tab.tabs[1],L.RaidCheckRunesEnable,VMRT.RaidCheck.RunesCheck):Point("TOPLEFT",self.level2optLine,7,-100):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.RunesCheck = true
		else
			VMRT.RaidCheck.RunesCheck = nil
		end
	end)

	self.chkBuffs = ELib:Check(self.tab.tabs[1],L.RaidCheckBuffsEnable,VMRT.RaidCheck.BuffsCheck):Point("TOPLEFT",self.chkRunes,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.BuffsCheck = true
		else
			VMRT.RaidCheck.BuffsCheck = nil
		end
	end)

	self.chkKits = ELib:Check(self.tab.tabs[1],L.RaidCheckKitsEnable,VMRT.RaidCheck.KitsCheck):Point("TOPLEFT",self.chkBuffs,0,-25):Tooltip(L.RaidCheckNoAddonOptTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.KitsCheck = true
		else
			VMRT.RaidCheck.KitsCheck = nil
		end
	end)

	self.chkOils = ELib:Check(self.tab.tabs[1],L.RaidCheckOilsEnable,VMRT.RaidCheck.OilsCheck):Point("TOPLEFT",self.chkKits,0,-25):Tooltip(L.RaidCheckNoAddonOptTooltip):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.OilsCheck = true
		else
			VMRT.RaidCheck.OilsCheck = nil
		end
	end)

	self.minFoodLevelText = ELib:Text(self.tab.tabs[1],L.RaidCheckMinFoodLevel,11):Point("TOPLEFT",self.chkOils,"TOPLEFT",3,-23):Size(0,25)

	self.minFoodLevelAny = ELib:Radio(self.tab.tabs[1],L.RaidCheckMinFoodLevelAny,not VMRT.RaidCheck.FoodMinLevel):Point("LEFT",self.minFoodLevelText,"RIGHT", 15, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFoodLevel100:SetChecked(false)
		module.options.minFoodLevel125:SetChecked(false)
		VMRT.RaidCheck.FoodMinLevel = nil
	end)


	self.minFoodLevel100 = ELib:Radio(self.tab.tabs[1],module.db.minFoodLevelToActual[100],VMRT.RaidCheck.FoodMinLevel == 100):Point("LEFT",self.minFoodLevelAny,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFoodLevelAny:SetChecked(false)
		module.options.minFoodLevel125:SetChecked(false)
		VMRT.RaidCheck.FoodMinLevel = 100
	end)

	self.minFoodLevel125 = ELib:Radio(self.tab.tabs[1],module.db.minFoodLevelToActual[125],VMRT.RaidCheck.FoodMinLevel == 125):Point("LEFT",self.minFoodLevel100,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFoodLevelAny:SetChecked(false)
		module.options.minFoodLevel100:SetChecked(false)
		VMRT.RaidCheck.FoodMinLevel = 125
	end)


	self.minFlaskExpText = ELib:Text(self.tab.tabs[1],L.RaidCheckMinFlaskExp,11):Point("TOPLEFT",self.minFoodLevelText,"TOPLEFT",0,-22):Size(0,25)

	self.minFlaskExpNo = ELib:Radio(self.tab.tabs[1],L.RaidCheckMinFlaskExpNo,VMRT.RaidCheck.FlaskExp == 0):Point("LEFT",self.minFlaskExpText,"RIGHT", 15, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFlaskExp5min:SetChecked(false)
		module.options.minFlaskExp10min:SetChecked(false)
		VMRT.RaidCheck.FlaskExp = 0
	end)

	self.minFlaskExp5min = ELib:Radio(self.tab.tabs[1],"5 "..L.RaidCheckMinFlaskExpMin,VMRT.RaidCheck.FlaskExp == 1):Point("LEFT",self.minFlaskExpNo,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFlaskExpNo:SetChecked(false)
		module.options.minFlaskExp10min:SetChecked(false)
		VMRT.RaidCheck.FlaskExp = 1
	end)

	self.minFlaskExp10min = ELib:Radio(self.tab.tabs[1],"10 "..L.RaidCheckMinFlaskExpMin,VMRT.RaidCheck.FlaskExp == 2):Point("LEFT",self.minFlaskExp5min,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFlaskExpNo:SetChecked(false)
		module.options.minFlaskExp5min:SetChecked(false)
		VMRT.RaidCheck.FlaskExp = 2
	end)

	self.checkLQFlask = ELib:Check(self.tab.tabs[1],L.RaidCheckLQFlask,not VMRT.RaidCheck.FlaskLQ):Point("TOPLEFT",self.level2optLine,7,-245):OnClick(function(self) 
		VMRT.RaidCheck.FlaskLQ = not VMRT.RaidCheck.FlaskLQ
	end)


	self.chkPotion = ELib:Check(self.tab.tabs[1],L.raidcheckPotionCheck,VMRT.RaidCheck.PotionCheck):Point("TOPLEFT",self.level2optLine,7,-270):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.PotionCheck = true
			module.options.potionToChat:Enable()
			module.options.potion:Enable()
			module.options.hs:Enable()
			module.options.hsToChat:Enable()
			module:RegisterEvents('ENCOUNTER_START','ENCOUNTER_END')
		else
			VMRT.RaidCheck.PotionCheck = nil
			module.options.potionToChat:Disable()
			module.options.potion:Disable()
			module.options.hs:Disable()
			module.options.hsToChat:Disable()
			module:UnregisterEvents('ENCOUNTER_START','ENCOUNTER_END')
		end
	end)

	self.potion = ELib:Button(self.tab.tabs[1],L.raidcheckPotionLastPull):Size(230,20):Point("TOPLEFT",self.chkPotion,"TOPLEFT",-2,-25):OnClick(function() GetPotion(2) end):Run(function(s,a) if a then s:Disable() end end,not VMRT.RaidCheck.PotionCheck)
	self.potion.txt = ELib:Text(self.tab.tabs[1],"/rt potion",11):Size(100,20):Point("LEFT",self.potion,"RIGHT",5,0)

	self.potionToChat = ELib:Button(self.tab.tabs[1],L.raidcheckPotionLastPullToChat):Size(230,20):Point("LEFT",self.potion,"RIGHT",71,0):OnClick(function() GetPotion(1) end):Run(function(s,a) if a then s:Disable() end end,not VMRT.RaidCheck.PotionCheck)
	self.potionToChat.txt = ELib:Text(self.tab.tabs[1],"/rt potionchat",11):Size(100,20):Point("LEFT",self.potionToChat,"RIGHT",5,0)

	self.hs = ELib:Button(self.tab.tabs[1],L.raidcheckHSLastPull):Size(230,20):Point("TOPLEFT",self.potion,"TOPLEFT",0,-25):OnClick(function() GetHs(2) end):Run(function(s,a) if a then s:Disable() end end,not VMRT.RaidCheck.PotionCheck)

	self.hsToChat = ELib:Button(self.tab.tabs[1],L.raidcheckHSLastPullToChat):Size(230,20):Point("LEFT",self.hs,"RIGHT",71,0):OnClick(function() GetHs(1) end):Run(function(s,a) if a then s:Disable() end end,not VMRT.RaidCheck.PotionCheck)



	ELib:Text(self.tab.tabs[2],L.RaidCheckChatComand..": |cffffffff/rt check|r",10):Point(15,-10)

	self.chkReadyCheckFrameEnable = ELib:Check(self.tab.tabs[2],L.Enable,VMRT.RaidCheck.ReadyCheckFrame):Point(15,-25):AddColorState():OnClick(function(self) 
		if self:GetChecked() then
			module:RegisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			VMRT.RaidCheck.ReadyCheckFrame = true
		else
			module:UnregisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			VMRT.RaidCheck.ReadyCheckFrame = nil
		end
	end)

	self.chkReadyCheckFrameEnableRL = ELib:Check(self.tab.tabs[2],L.RaidCheckOnlyRL,VMRT.RaidCheck.ReadyCheckFrameOnlyRL):Point(15,-50):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.ReadyCheckFrameOnlyRL = true
		else
			VMRT.RaidCheck.ReadyCheckFrameOnlyRL = nil
		end
	end)

	self.chkReadyCheckFrameButTest = ELib:Button(self.tab.tabs[2],L.raidcheckReadyCheckTest):Size(300,20):Point(15,-75):OnClick(function(self) 
		module.main:READY_CHECK("raid1",35,"TEST")
		for i=2,30 do
			local y = math.random(1,30000)
			local r = math.random(1,2)
			ExRT.F.ScheduleTimer(function() module.main:READY_CHECK_CONFIRM("raid"..i,r==1,"TEST") end, y/1000)
		end
	end)

	self.chkReadyCheckFrameSliderScale = ELib:Slider(self.tab.tabs[2],L.raidcheckReadyCheckScale):Size(300):Point(15,-115):Range(5,200):SetTo(VMRT.RaidCheck.ReadyCheckFrameScale or 100):OnChange(function(self,event) 
		event = event - event%1
		VMRT.RaidCheck.ReadyCheckFrameScale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)


	self.sliderFontSize = ELib:Slider(self.tab.tabs[2],""):Size(320):Point(200,-145):Range(10,80):SetTo(VMRT.RaidCheck.ReadyCheckFontSize or 12):OnChange(function(self,event) 
		event = floor(event + .5)
		VMRT.RaidCheck.ReadyCheckFontSize = event
		module.frame:UpdateFont()
		self.tooltipText = event
		self:tooltipReload(self)
	end)
	ELib:Text(self.tab.tabs[2],L.cd2OtherSetFontSize..":",11):Point("RIGHT",self.sliderFontSize,"LEFT",-5,0):Color(1,.82,0,1):Right()

	local function dropDownFontSetValue(_,arg1)
		ELib:DropDownClose()
		VMRT.RaidCheck.ReadyCheckFont = arg1
		self.dropDownFont:SetText(arg1 or DEFAULT)
		module.frame:UpdateFont()
	end

	self.dropDownFont = ELib:DropDown(self.tab.tabs[2],350,10):Size(320):Point(200,-175):SetText(VMRT.RaidCheck.ReadyCheckFont or DEFAULT):AddText("|cffffce00"..L.cd2OtherSetFont..":")
	self.dropDownFont.List[1] = {
		text = DEFAULT,
		arg1 = nil,
		func = dropDownFontSetValue,
		font = ExRT.F.defFont,
		justifyH = "CENTER",
	}
	for i=1,#ExRT.F.fontList do
		local info = {}
		self.dropDownFont.List[i+1] = info
		info.text = ExRT.F.fontList[i]
		info.arg1 = ExRT.F.fontList[i]
		info.func = dropDownFontSetValue
		info.font = ExRT.F.fontList[i]
		info.justifyH = "CENTER" 
	end
	for key,font in ExRT.F.IterateMediaData("font") do
		local info = {}
		self.dropDownFont.List[#self.dropDownFont.List+1] = info

		info.text = key
		info.arg1 = font
		info.func = dropDownFontSetValue
		info.font = font
		info.justifyH = "CENTER" 
	end

	--[[
	self.fontOutline = ELib:Check(self.tab.tabs[2],L.cd2OtherSetOutline,VMRT.RaidCheck.ReadyCheckFontOutline):Point("LEFT",self.dropDownFont,"RIGHT",5,0):OnClick(function(self) 
		VMRT.RaidCheck.ReadyCheckFontOutline = self:GetChecked()
		module:UpdateVisual()
	end)
	]]



	self.chkReadyCheckFrameEditBoxTimer = ELib:Edit(self.tab.tabs[2],6,true):Size(50,20):Point(350,-210):Text(VMRT.RaidCheck.ReadyCheckFrameTimerFade or "4"):OnChange(function(self)
		VMRT.RaidCheck.ReadyCheckFrameTimerFade = tonumber(self:GetText()) or 4
		if VMRT.RaidCheck.ReadyCheckFrameTimerFade < 2.5 then VMRT.RaidCheck.ReadyCheckFrameTimerFade = 2.5 end
	end):LeftText(L.raidcheckReadyCheckTimerTooltip)


	self.chkReadyCheckFrameClassSort = ELib:Check(self.tab.tabs[2],L.RaidCheckSortByClass,VMRT.RaidCheck.ReadyCheckSortClass):Point(15,-235):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.ReadyCheckSortClass = true
		else
			VMRT.RaidCheck.ReadyCheckSortClass = nil
		end
	end)

	self.chkReadyCheckColDecLine = ELib:DecorationLine(self.tab.tabs[2]):Point("TOP",self.chkReadyCheckFrameClassSort,"BOTTOM",0,-5):Size(0,1):Point("LEFT",0,0):Point("RIGHT",0,0)

	self.chkReadyCheckColText = ELib:Text(self.tab.tabs[2],L.cd2Columns..":",12):Point("TOPLEFT",self.chkReadyCheckFrameClassSort,"BOTTOMLEFT",0,-10)
	
	self.chkReadyCheckColSoulstone = ELib:Check(self.tab.tabs[2],GetSpellInfo(20707) or "Soulstone",VMRT.RaidCheck.ReadyCheckSoulstone):Point("TOPLEFT",self.chkReadyCheckFrameClassSort,"BOTTOMLEFT",0,-30):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.ReadyCheckSoulstone = true
		else
			VMRT.RaidCheck.ReadyCheckSoulstone = nil
		end
	end)	

	self.chkReadyCheckConsumables = ELib:Check(self.tab.tabs[3],L.Enable,not VMRT.RaidCheck.DisableConsumables):Point(15,-10):AddColorState():OnClick(function(self) 
		if self:GetChecked() then
			VMRT.RaidCheck.DisableConsumables = nil
			module.consumables:Enable()
		else
			VMRT.RaidCheck.DisableConsumables = true
			module.consumables:Disable()
		end
	end)

	self.chkReadyCheckConsumablesOnlyCuadFlask = ELib:Check(self.tab.tabs[3],L.RaidCheckOnlyCauldron,VMRT.RaidCheck.DisableNotCauldronFlask):Point("TOPLEFT",self.chkReadyCheckConsumables,"BOTTOMLEFT",0,-5):OnClick(function(self) 
		VMRT.RaidCheck.DisableNotCauldronFlask = self:GetChecked()
	end)

	self.chkReadyCheckConsumablesDisableForRL = ELib:Check(self.tab.tabs[3],L.RaidCheckDisableForRL,VMRT.RaidCheck.ConsDisableForStarter):Point("TOPLEFT",self.chkReadyCheckConsumablesOnlyCuadFlask,"BOTTOMLEFT",0,-5):OnClick(function(self) 
		VMRT.RaidCheck.ConsDisableForStarter = self:GetChecked()
	end)

	if ExRT.isClassic then
		self.tab.tabs[3].button:Hide()
		self.tab.tabs[1].button:Hide()
		self.tab.tabs[2].button:ClearAllPoints()
		self.tab.tabs[2].button:SetPoint("TOPLEFT", 10, 24)
		self.tab:SetTo(2)

		self.chkReadyCheckColDecLine:Hide()
		self.chkReadyCheckColText:Hide()
		self.chkReadyCheckColSoulstone:Hide()
	end
end

local function CheckPotionsOnPull()
	table.wipe(module.db.potionList)
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	for j=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(j)
		if name and subgroup <= gMax then
			local b = nil
			for i=1,40 do
				local _,_,_,_,_,_,_,_,_,spellId = UnitAura(name, i,"HELPFUL")
				if not spellId then
					break
				elseif module.db.tablePotion[spellId] then
					module.db.potionList[name] = 1
					b = true
				end
			end
			if not b then
				module.db.potionList[name] = 0
			end
		end
	end
end

do
	local charItemSlotsTable = not ExRT.isClassic and {
		CharacterHeadSlot,CharacterNeckSlot,CharacterShoulderSlot,CharacterBackSlot,CharacterChestSlot,CharacterWristSlot,
		CharacterHandsSlot,CharacterWaistSlot,CharacterLegsSlot,CharacterFeetSlot,CharacterFinger0Slot,CharacterFinger1Slot,CharacterTrinket0Slot,CharacterTrinket1Slot,
		CharacterMainHandSlot,CharacterSecondaryHandSlot
	} or {
		CharacterHeadSlot,CharacterNeckSlot,CharacterShoulderSlot,CharacterBackSlot,CharacterChestSlot,CharacterWristSlot,
		CharacterHandsSlot,CharacterWaistSlot,CharacterLegsSlot,CharacterFeetSlot,
		CharacterFinger0Slot,CharacterFinger1Slot,CharacterTrinket0Slot,CharacterTrinket1Slot,
		CharacterMainHandSlot,CharacterSecondaryHandSlot,CharacterRangedSlot,
	}
	function module:DurabilityCheck()
		local totalCurrent, totalMax = 0,0
		for _,v in pairs(charItemSlotsTable) do
			local slotId = v:GetID()
			local current, maximum = GetInventoryItemDurability(slotId)

			if current and maximum then
				totalCurrent = totalCurrent + current
				totalMax = totalMax + maximum
			end
		end
		if totalMax == 0 then
			return 100
		else
			return totalCurrent / totalMax * 100
		end
	end
end

local inspectScantip = CreateFrame("GameTooltip", "ExRTRaidCheckScanningTooltip", nil, "GameTooltipTemplate")
inspectScantip:SetOwner(UIParent, "ANCHOR_NONE")

do
	local KitSlots = {
		5,	--INVSLOT_CHEST
		--7,	--INVSLOT_LEGS
		--10,	--INVSLOT_HAND
		--8,	--INVSLOT_FEET
	}
	local L_EncName = "^"..L.RaidCheckReinforced
	local TimeLeftPatt = "%(([^%)]+)%)[^%)]*$"
	if ExRT.locale == "koKR" then
		L_EncName = "%([^%)]+%+%d+%) %(%d+"
	elseif ExRT.locale == "zhCN" then
		L_EncName = "^加固（%+[0-9]+ "
		TimeLeftPatt = "（([^）]-)）$"
	elseif ExRT.locale ~= "ruRU" and ExRT.locale ~= "enGB" and ExRT.locale ~= "enUS" then
		L_EncName = "%(%+%d+[^%)]+%) %(%d+"
	end

	function module:KitCheck()
		local kitNow, kitMax = 0, 1
		local kitType = 0
		local timeLeft
		for _,itemSlotID in pairs(KitSlots) do
			inspectScantip:SetInventoryItem("player", itemSlotID)

			for j=2, inspectScantip:NumLines() do
				local tooltipLine = _G["ExRTRaidCheckScanningTooltipTextLeft"..j]
				local text = tooltipLine:GetText()
				if text and text ~= "" then
					if text:find(L_EncName) then
						kitNow = kitNow + 1
						timeLeft = text:match(TimeLeftPatt)
						local stats = text:match("%d+")
						if stats == "32" then
							kitType = 172347
						elseif stats == "16" then
							kitType = 172346
						elseif stats == "24" then
							kitType = 180709
						end
						break
					end
				end
			end

			inspectScantip:ClearLines()
		end
		return kitNow, kitMax, timeLeft, kitType
	end
end

do
	local OilSlots = {
		16,	--INVSLOT_MAINHAND
		17,	--INVSLOT_OFFHAND
	}
	local oilTypes = nil
	function module:OilCheck()
		if not oilTypes then
			oilTypes = {
				{GetSpellInfo(320798),320798},
				{GetSpellInfo(321389),321389},
				{GetSpellInfo(322762),322762},
				{GetSpellInfo(322763),322763},
				{GetSpellInfo(295623),33757},
				{GetSpellInfo(194084),318038},
				{L.RaidCheckOilSharpen,322762},
				{L.RaidCheckOilSharpen2,322763},
			}
			for i=#oilTypes,1,-1 do
				if not oilTypes[i][1] then
					tremove(oilTypes,i)
				end
			end
		end

		local oilMH, oilOH = 0, 0

		for _,itemSlotID in pairs(OilSlots) do
			inspectScantip:SetInventoryItem("player", itemSlotID)

			for j=2, inspectScantip:NumLines() do
				local tooltipLine = _G["ExRTRaidCheckScanningTooltipTextLeft"..j]
				local text = tooltipLine:GetText()
				local isBreak
				if text and text ~= "" then
					for i=1,#oilTypes do
						if text:find("^"..oilTypes[i][1]) then
							if itemSlotID == 16 then
								oilMH = oilTypes[i][2]
							elseif itemSlotID == 17 then
								oilOH = oilTypes[i][2]
							end
							isBreak = true
							break
						end
					end
				end
				if isBreak then
					break
				end
			end

			inspectScantip:ClearLines()
		end

		return oilMH, oilOH
	end
end

function module.main:ENCOUNTER_START()
	ExRT.F.ScheduleTimer(CheckPotionsOnPull,1.5)

	table.wipe(module.db.hsList)
	for index, name in ExRT.F.IterateRoster, ExRT.F.GetRaidDiffMaxGroup() do
		if name then
			module.db.hsList[name] = 0
		end
	end

	module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
end

function module.main:ENCOUNTER_END()
	module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
end

function module:slash(arg)
	if arg == "food" then
		GetFood()
	elseif arg == "flask" then
		GetFlask()
	elseif arg == "foodchat" then
		GetFood(1)
	elseif arg == "flaskchat" then
		GetFlask(1)
	elseif arg == "potion" and VMRT.RaidCheck.PotionCheck then
		GetPotion(2)
	elseif arg == "potionchat" and VMRT.RaidCheck.PotionCheck then
		GetPotion(1)
	elseif arg == "check runes" or arg == "check r" then
		GetRunes()
	elseif arg == "check runeschat" or arg == "check rc" then
		GetRunes(1)
	elseif arg == "check v" then
		GetVRunes()
	elseif arg == "check vc" then
		GetVRunes(1)
	elseif arg == "check b" then
		GetRaidBuffs()
	elseif arg == "check bc" then
		GetRaidBuffs(1)
	elseif arg == "check" then
		module:ReadyCheckWindow(nil,nil,true)
	elseif arg == "help" then
		print("|cff00ff00/rt check|r - show raid buffs window")
	end
end

local RCW_iconsList = {'food','flask','rune','vantus','int','ap','stam','dur'}
local RCW_iconsListHeaders = {L.RaidCheckHeadFood,L.RaidCheckHeadFlask,L.RaidCheckHeadRune,L.RaidCheckHeadVantus,SPELL_STAT4_NAME or "Int",ATTACK_POWER_TOOLTIP or "AP",SPELL_STAT3_NAME or "Stamina",DURABILITY or "Durability"}
local RCW_iconsListDebugIcons = {136000,967549,840006,1058937,135932,132333,135987,132281}
local RCW_iconsListWide = {}
local RCW_liveToClassicDiff = 0

if ExRT.isClassic then
	local wideDiff = 0
	for k,v in pairs(RCW_iconsListWide) do 
		if v then
			wideDiff = wideDiff - 1
		end
	end

	RCW_liveToClassicDiff = (#module.db.classicBuffs + 2) - #RCW_iconsList + 1
	RCW_iconsListDebugIcons[2] = 134877
	RCW_iconsListWide[2] = true
	for i=3,#RCW_iconsList do
		RCW_iconsList[i] = nil
		RCW_iconsListHeaders[i] = nil
		RCW_iconsListDebugIcons[i] = nil
	end
	if ExRT.isBC then
		RCW_liveToClassicDiff = RCW_liveToClassicDiff + 1
		RCW_iconsList[#RCW_iconsList+1] = "scrolls"
		RCW_iconsListHeaders[#RCW_iconsList] = "Scrolls"
		RCW_iconsListDebugIcons[#RCW_iconsList] = 134943
		RCW_iconsListWide[#RCW_iconsList] = true
	end
	for i=1,#module.db.classicBuffs do
		RCW_iconsList[#RCW_iconsList+1] = module.db.classicBuffs[i][1]
		RCW_iconsListHeaders[#RCW_iconsList] = module.db.classicBuffs[i][2]
		RCW_iconsListDebugIcons[#RCW_iconsList] = module.db.classicBuffs[i][3]
	end
	RCW_iconsList[#RCW_iconsList+1] = "dur"
	RCW_iconsListHeaders[#RCW_iconsList] = DURABILITY or "Durability"
	RCW_iconsListDebugIcons[#RCW_iconsList] = 132281

	for k,v in pairs(RCW_iconsListWide) do 
		if v then
			wideDiff = wideDiff + 1
		end
	end
	RCW_liveToClassicDiff = RCW_liveToClassicDiff + wideDiff
end

local RCW_liveToslDiff = 0
if not ExRT.isClassic and UnitLevel'player' > 50 then
	tinsert(RCW_iconsList,8,'oil')
	tinsert(RCW_iconsListHeaders,8,WEAPON)
	tinsert(RCW_iconsListDebugIcons,8,463543)

	tinsert(RCW_iconsList,8,'kit')
	tinsert(RCW_iconsListHeaders,8,BONUS_ARMOR)
	tinsert(RCW_iconsListDebugIcons,8,3528447)

	RCW_liveToslDiff = 60
end

module.frame = ELib:Template("ExRTDialogModernTemplate",UIParent)
module.frame:SetSize(430+(ExRT.isClassic and 30*RCW_liveToClassicDiff or 0)+RCW_liveToslDiff,100)
module.frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
module.frame:SetFrameStrata("DIALOG")
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetClampedToScreen(true)
module.frame:SetScript("OnDragStart", function(self) 
	self:StartMoving()
end)
module.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing()
	VMRT.RaidCheck.ReadyCheckLeft = self:GetLeft()
	VMRT.RaidCheck.ReadyCheckTop = self:GetTop()
end)
module.frame:SetScript("OnMouseDown", function(self,button) 
	if button == "RightButton" then
		self:Hide()
	end
end)
module.frame:Hide()

do
	local tmr = 0
	module.frame:SetScript("OnUpdate",function(self,elapsed)
		tmr = tmr + elapsed
		if tmr > 0.1 then
			tmr = 0
			local h = ""
			if module.db.RaidCheckReadyCheckTime then
				local ctime_ = module.db.RaidCheckReadyCheckTime - GetTime()
				if ctime_ > 0 then 
					h = format(" (%d %s)",ctime_+1,L.raidcheckReadyCheckSec) 
				end
			end
			self.headText:SetText("MRT: "..L.raidcheckReadyCheck..h)
		end
	end)
end

module.frame.border = ExRT.lib.CreateShadow(module.frame,20)
module.frame.headText = module.frame.title

module.frame.anim_frame = CreateFrame("Frame",nil,module.frame)
module.frame.anim_frame:SetPoint("TOPLEFT")
module.frame.anim_frame:SetSize(1,1)

module.frame.anim = module.frame.anim_frame:CreateAnimationGroup()
module.frame.timer = module.frame.anim:CreateAnimation()
module.frame.timer:SetScript("OnFinished", function() 
	module.frame.anim:Stop() 
	module.frame:Hide() 
end)
module.frame.timer:SetDuration(2)
module.frame.timer:SetScript("OnUpdate", function(self,elapsed) 
	module.frame:SetAlpha(1-self:GetProgress())
end)
module.frame:SetScript("OnHide", function(self) 
	self:UnregisterAllEvents()
	if module.frame.anim:IsPlaying() then
		module.frame.anim:Stop()
	end
	if module.frame.hideTimer then
		module.frame.hideTimer:Cancel()
		module.frame.hideTimer = nil
	end
end)

do
	local button = CreateFrame("Button",nil,module.frame)
	module.frame.mimimize = button

	function module.frame:SetMaximized()
		button.isMinimized = nil

		self.minimized:Hide()
		self.maximized:Show()

		button.NormalTexture:SetTexCoord(unpack(button.TC.up))
		button.HighlightTexture:SetTexCoord(unpack(button.TC.up))
		button.PushedTexture:SetTexCoord(unpack(button.TC.up))

		self:SetHeight(self.SizeMaximized)
	end
	function module.frame:SetMinimized()
		button.isMinimized = true

		self.minimized:Show()
		self.maximized:Hide()

		button.NormalTexture:SetTexCoord(unpack(button.TC.down))
		button.HighlightTexture:SetTexCoord(unpack(button.TC.down))
		button.PushedTexture:SetTexCoord(unpack(button.TC.down))

		self:SetHeight(module.frame.SizeMinimized)
	end
	function module.frame:SetMinimizedFromOptions()
		if VMRT.RaidCheck.RCW_Mini and not button.isMinimized then
			self:SetMinimized()
		end
	end

	button.TC = {
		up = {0.3125,0.375,0.5,0.625},
		down = {0.25,0.3125,0.5,0.625},
	}
	button:SetPoint("TOPRIGHT",-20,0)
	button:SetSize(18,18)
	button:SetScript("OnClick",function(self)
		if self.isMinimized then
			module.frame:SetMaximized()

			VMRT.RaidCheck.RCW_Mini = false
		else
			module.frame:SetMinimized()

			VMRT.RaidCheck.RCW_Mini = true
		end
	end)


	button.NormalTexture = button:CreateTexture(nil,"ARTWORK")
	button.NormalTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
	button.NormalTexture:SetPoint("TOPLEFT")
	button.NormalTexture:SetPoint("BOTTOMRIGHT")
	button.NormalTexture:SetVertexColor(1,1,1,.7)
	button.NormalTexture:SetTexCoord(unpack(button.TC.up))
	button:SetNormalTexture(button.NormalTexture)

	button.HighlightTexture = button:CreateTexture(nil,"ARTWORK")
	button.HighlightTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
	button.HighlightTexture:SetPoint("TOPLEFT")
	button.HighlightTexture:SetPoint("BOTTOMRIGHT")
	button.HighlightTexture:SetVertexColor(1,1,0,1)
	button.HighlightTexture:SetTexCoord(unpack(button.TC.up))
	button:SetHighlightTexture(button.HighlightTexture)

	button.PushedTexture = button:CreateTexture(nil,"ARTWORK")
	button.PushedTexture:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
	button.PushedTexture:SetPoint("TOPLEFT")
	button.PushedTexture:SetPoint("BOTTOMRIGHT")
	button.PushedTexture:SetVertexColor(1,1,1,1)
	button.PushedTexture:SetTexCoord(unpack(button.TC.up))
	button:SetPushedTexture(button.PushedTexture)

end

module.frame.minimized = CreateFrame('Frame',nil,module.frame)
module.frame.minimized:SetPoint("TOPLEFT")
module.frame.minimized:SetSize(1,1)
module.frame.minimized:Hide()

module.frame.maximized = CreateFrame('Frame',nil,module.frame)
module.frame.maximized:SetPoint("TOPLEFT")
module.frame.maximized:SetSize(1,1)


module.frame.lines = {}
module.frame.lines_mini = {}

local function RCW_LineOnUpdate(self)
	if self:IsMouseOver(self) and not self.hoverShow then
		self.hover:SetAlpha(.15)
		self.hoverShow = true
	elseif not self:IsMouseOver(self) and self.hoverShow then
		self.hover:SetAlpha(0)
		self.hoverShow = false
	end
end
local function RCW_LineOnEnter(self)
	if self.tooltip then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		if type(self.tooltip) == 'string' then
			GameTooltip:SetHyperlink(self.tooltip)
		else
			GameTooltip:SetUnitAura(self:GetParent().unit, self.tooltip, "HELPFUL")
		end
		GameTooltip:Show()
	end
end
local function RCW_LineOnLeave(self)
	if self.tooltip then
		GameTooltip_Hide()
	end
end

local function RCW_AddIcon(parent,texture)
	local icon = ELib:Icon(parent,texture,14)

	icon:SetScript("OnEnter",RCW_LineOnEnter)
	icon:SetScript("OnLeave",RCW_LineOnLeave)

	icon.texture:SetTexCoord(.1,.9,.1,.9)
	icon.text = ELib:Text(icon,"100",8):Point("BOTTOMRIGHT",4,0):Right():Color(0,1,0)
	icon.bigText = ELib:Text(icon,"",10):Point("CENTER",0,0):Center():Color(1,1,1)

	icon.subIcon = icon:CreateTexture(nil, "BORDER")
	icon.subIcon:SetPoint("CENTER",icon,"TOPRIGHT",-2,-2)
	icon.subIcon:SetSize(10,10)
	icon.subIcon:SetTexture("Interface\\AddOns\\"..GlobalAddonName.."\\media\\DiesalGUIcons16x256x128")
	icon.subIcon:SetTexCoord(0.125,0.1875,0.5,0.625)
	icon.subIcon:SetVertexColor(1,0,0)
	icon.subIcon:Hide()

	return icon
end

local function CreateCol(line,key,i)
	line[key.."pointer"] = CreateFrame("Frame",nil,line)
	line[key.."pointer"]:SetSize(RCW_iconsListWide[i] and 60 or 30,14)

	if i==1 then
		line[key.."pointer"]:SetPoint("CENTER",line.name,"RIGHT",15 - 5,0)
	else
		line[key.."pointer"]:SetPoint("CENTER",line[ RCW_iconsList[i-1].."pointer" ],"CENTER",30+(RCW_iconsListWide[i-1] and 15 or 0)+(RCW_iconsListWide[i] and 15 or 0),0)
	end

	line[key] = RCW_AddIcon(line,RCW_iconsListDebugIcons[i])
	line[key]:Point("CENTER",line[key.."pointer"],"CENTER",0,0)

	line[key].UpdatePos = function(self,pointFrame)
		line[key.."pointer"]:ClearAllPoints()
		line[key.."pointer"]:SetPoint("CENTER",pointFrame,"CENTER",30,0)
		return line[key.."pointer"]
	end

	for j=2,4 do
		line[key..j] = RCW_AddIcon(line,RCW_iconsListDebugIcons[i])
		line[key..j]:Point("LEfT",line[key..((j-1) == 1 and "" or tostring(j-1))],"RIGHT",0,0)
		line[key..j]:Hide()
	end
end

local RCW_iconsList_ORIGIN = #RCW_iconsList
function module.frame:UpdateCols()
	for i=RCW_iconsList_ORIGIN+1,#RCW_iconsList do
		RCW_iconsList[i] = nil
		if module.frame.headers[i] then
			module.frame.headers[i]:SetText("")
		end
	end
	local colsAdd = 0
	if VMRT.RaidCheck.ReadyCheckSoulstone then
		colsAdd = colsAdd + 1
		RCW_iconsList[RCW_iconsList_ORIGIN+colsAdd] = "ss"
		RCW_iconsListHeaders[RCW_iconsList_ORIGIN+colsAdd] = GetSpellInfo(20707) or "Soulstone"
		RCW_iconsListDebugIcons[RCW_iconsList_ORIGIN+colsAdd] = 136210
		local header = module.frame.headers[RCW_iconsList_ORIGIN+colsAdd]
		if not header then
			header = ELib:Text(module.frame.headers,"",10):Color(1,1,1):Point("BOTTOMLEFT",module.frame.headers[RCW_iconsList_ORIGIN+colsAdd-1],"BOTTOMLEFT",30,0)--:Font(VMRT.RaidCheck.ReadyCheckFont or ExRT.F.defFont,(VMRT.RaidCheck.ReadyCheckFontSize or 12)-2)
			module.frame.headers[RCW_iconsList_ORIGIN+colsAdd] = header
		end
		header:SetText(RCW_iconsListHeaders[RCW_iconsList_ORIGIN+colsAdd])
	end
	for i=1,40 do
		local line = module.frame.lines[i]
		line:SetSize(420+(ExRT.isClassic and 30*RCW_liveToClassicDiff or 0)+RCW_liveToslDiff+colsAdd*30,14)

		local prevPointer = line[ RCW_iconsList[RCW_iconsList_ORIGIN].."pointer" ]

		if VMRT.RaidCheck.ReadyCheckSoulstone then
			if not line["ss"] then
				CreateCol(line,"ss",RCW_iconsList_ORIGIN+1)
			end
			prevPointer = line["ss"]:UpdatePos(prevPointer)
			line["ss"]:Show()
		elseif line["ss"] then
			line["ss"]:Hide()
		end
		
	end	
	module.frame:SetWidth(430+(ExRT.isClassic and 30*RCW_liveToClassicDiff or 0)+RCW_liveToslDiff+colsAdd*30)
end

function module.frame:Create()
	if self.isCreated then
		return
	end
	self.isCreated = true

	local miniWidth = (module.frame:GetWidth() - 10) / 4

	for i=1,40 do
		local line = CreateFrame("FRAME",nil,module.frame.maximized)
		module.frame.lines[i] = line
		line.pos = i
		if i==1 then
			line:SetPoint("TOPLEFT", 5, -50)
		else
			line:SetPoint("TOPLEFT", module.frame.lines[i-1], "BOTTOMLEFT", 0, -0)
		end
		line:SetSize(420+(ExRT.isClassic and 30*RCW_liveToClassicDiff or 0)+RCW_liveToslDiff,14)

		line.name = ELib:Text(line,"raid"..i):Size(130,12):Point("LEFT",20,0):Font(ExRT.F.defFont,12):Color():Shadow()

		line.icon = ELib:Icon(line,"Interface\\RaidFrame\\ReadyCheck-Waiting",14):Point("LEFT",0,0)

		for i,key in pairs(RCW_iconsList) do
			CreateCol(line,key,i)
		end

		if i%2 == 0 then
			line.back = line:CreateTexture(nil,"BACKGROUND")
			line.back:SetPoint("TOPLEFT",-5,0)
			line.back:SetPoint("BOTTOMRIGHT",5,0)
			line.back:SetColorTexture(1,1,1,.05)
		end

		line.hover = line:CreateTexture(nil,"BACKGROUND")
		line.hover:SetPoint("TOPLEFT",-5,0)
		line.hover:SetPoint("BOTTOMRIGHT",5,0)
		line.hover:SetColorTexture(1,1,1,1)
		line.hover:SetAlpha(0)

		line.classLeft = line:CreateTexture(nil,"BACKGROUND",nil,5)
		line.classLeft:SetPoint("TOPLEFT",-5,0)
		line.classLeft:SetPoint("BOTTOMLEFT",-5,0)
		--line.classLeft:SetWidth(160)
		line.classLeft:SetPoint("RIGHT",5,0)
		line.classLeft:SetColorTexture(1,1,1,1)
		line.classLeft:SetGradientAlpha("VERTICAL",.24,.25,.30,1,.27,.28,.33,1)

		line:SetScript("OnUpdate",RCW_LineOnUpdate)


		local line_mini = CreateFrame("FRAME",nil,module.frame.minimized)
		module.frame.lines_mini[i] = line_mini
		line_mini.pos = i

		if i==1 then
			line_mini:SetPoint("TOPLEFT", 5, -20)
		elseif i % 4 == 1 then
			line_mini:SetPoint("TOPLEFT", module.frame.lines_mini[i-4], "BOTTOMLEFT", 0, -0)
		else
			line_mini:SetPoint("TOPLEFT", module.frame.lines_mini[i-1], "TOPRIGHT", 0, -0)
		end
		line_mini:SetSize(miniWidth,14)

		line_mini.name = ELib:Text(line_mini,"raid"..i):Size(miniWidth-16,12):Point("LEFT",16,0):Font(ExRT.F.defFont,12):Color():Shadow()

		line_mini.icon = ELib:Icon(line_mini,"Interface\\RaidFrame\\ReadyCheck-Waiting",14):Point("LEFT",0,0)

		line.mini = line_mini
	end

	self:UpdateFont()
end

function module.frame:UpdateFont()
	if not self.isCreated then
		return
	end
	for i=1,40 do
		local line = self.lines[i]
		line.name:SetFont(VMRT.RaidCheck.ReadyCheckFont or ExRT.F.defFont,VMRT.RaidCheck.ReadyCheckFontSize or 12)
		line.mini.name:SetFont(VMRT.RaidCheck.ReadyCheckFont or ExRT.F.defFont,VMRT.RaidCheck.ReadyCheckFontSize or 12)

		for i,key in pairs(RCW_iconsList) do
			line[key].bigText:SetFont(VMRT.RaidCheck.ReadyCheckFont or ExRT.F.defFont,(VMRT.RaidCheck.ReadyCheckFontSize or 12)-2)
		end
	end
	self.title:SetFont(VMRT.RaidCheck.ReadyCheckFont or ExRT.F.defFont,VMRT.RaidCheck.ReadyCheckFontSize or 12)
	self.timeLeftLine.time:SetFont(VMRT.RaidCheck.ReadyCheckFont or ExRT.F.defFont,VMRT.RaidCheck.ReadyCheckFontSize or 12)
	--[[
	if self.headers then
		for i=1,#self.headers do
			self.headers[i]:SetFont(VMRT.RaidCheck.ReadyCheckFont or ExRTFontNormal:GetFont() or ExRT.F.defFont,(VMRT.RaidCheck.ReadyCheckFontSize or 12)-2)
		end
	end
	]]
end

do
	local line = CreateFrame("Frame",nil,module.frame)
	module.frame.timeLeftLine = line

	local cR1,cG1,cB1 = 1,.2,.2	--Started
	local cR3,cG3,cB3 = .6,.6,.2	--Mid
	local cR2,cG2,cB2 = .2,.7,.2	--Finished

	local WIDTH,WIDTH2 = 430,18

	line:SetSize(WIDTH,18)
	--line:SetPoint("BOTTOMLEFT",module.frame,"TOPLEFT",0,-50)
	line:SetPoint("TOPLEFT",module.frame,"TOPLEFT",0,0)

	line.back = line:CreateTexture(nil,"BACKGROUND")
	line.back:SetSize(110,18)
	line.back:SetPoint("LEFT")
	line.back:SetColorTexture(cR1,cG1,cB1)

	line.back2 = line:CreateTexture(nil,"BACKGROUND")
	line.back2:SetSize(WIDTH2,18)
	line.back2:SetPoint("LEFT",line.back,"RIGHT")
	line.back2:SetColorTexture(1,1,1)
	line.back2:SetGradientAlpha("HORIZONTAL",cR1,cG1,cB1,1,cR1,cG1,cB1,0)

	line.time = ELib:Text(module.frame.maximized,"40"):Point("TOPLEFT",line,5,-34):Font(ExRT.F.defFont,12):Color():Shadow()
	line.time:Hide()
 
 	local currR,currG,currB = 1,.2,.2

	local stop = nil
	local end_time,duration = 0,30
	line:SetScript("OnUpdate",function(self)
		if stop then
			return
		end
		local t = end_time - GetTime()
		if t < 0 then
			self:Stop()
			return
		end
		local width = t / duration * (WIDTH - WIDTH2)
		if width <= 1 then
			width = 1
		end
		line.back:SetWidth(width)
		--line.time:SetFormattedText("%d",t)
	end)
	line.Stop = function(self)
		stop = true
		if line:GetAlpha() > 0 then
			line.anim_alpha:Play()
		end

		self:Color(cR2,cG2,cB2)
	end
	line.Start = function(self,timer)
		end_time = GetTime() + timer
		duration = timer

		line.time:SetText("")
		line.back:SetColorTexture(cR1,cG1,cB1)
		line.back2:SetGradientAlpha("HORIZONTAL",cR1,cG1,cB1,1,cR1,cG1,cB1,0)
		line.back:SetWidth(WIDTH - WIDTH2)

		currR,currG,currB = cR1,cG1,cB1

		line.anim_alpha:Stop()
		line:SetAlpha(1)
		line.time:SetAlpha(1)
		stop = nil
		self:Show()
		self.time:Show()
	end
	line:SetScript("OnHide",function(self)
		line.time:Hide()
	end)

	line.anim_alpha = line:CreateAnimationGroup()
	line.anim_alpha.color = line.anim_alpha:CreateAnimation()
	line.anim_alpha.color:SetDuration(1)
	line.anim_alpha.color:SetScript("OnUpdate", function(self,elapsed) 
		line:SetAlpha(1 - self:GetProgress())
		line.time:SetAlpha(1 - self:GetProgress())
	end)
	line.anim_alpha.color:SetScript("OnFinished", function() 
		line.anim_alpha:Stop() 
	end)

	local cfR,cfG,cfB = 1,1,1
	local ctR,ctG,ctB = 1,1,1

	line.anim = line:CreateAnimationGroup()
	line.anim.color = line.anim:CreateAnimation()
	line.anim.color:SetDuration(1)
	line.anim.color:SetScript("OnUpdate", function(self,elapsed) 
		local r,g,b = cfR - (cfR - ctR) * self:GetProgress(),cfG - (cfG - ctG) * self:GetProgress(),cfB - (cfB - ctB) * self:GetProgress()

		line.back:SetColorTexture(r,g,b)
		line.back2:SetGradientAlpha("HORIZONTAL",r,g,b,1,r,g,b,0)

		currR,currG,currB = r,g,b
	end)

	line.Color = function(self,r,g,b)
		if self.anim:IsPlaying() then
			line.anim:Stop()
		end
		cfR,cfG,cfB = currR,currG,currB
		ctR,ctG,ctB = r,g,b
		line.anim:Play()
	end

	line.SetProgress = function(self,total,totalResponced)
		local progress = totalResponced / max(total,1)
		if progress == 0 then
			self.time:SetText(totalResponced.."/"..total)
			return
		end
		local fR,fG,fB
		local tR,tG,tB
		if progress >= .66 then
			fR,fG,fB = cR3,cG3,cB3
			tR,tG,tB = cR2,cG2,cB2
			progress = (progress - 0.66) / (1 - 0.66)
		else
			fR,fG,fB = cR1,cG1,cB1
			tR,tG,tB = cR3,cG3,cB3
			progress = progress * (1 / 0.66)
		end

		--self.time:SetText(progress < 1 and totalResponced.."/"..total or "")
		self.time:SetText(totalResponced.."/"..total)

		local r,g,b = fR - (fR - tR) * progress,fG - (fG - tG) * progress,fB - (fB - tB) * progress
		self:Color(r,g,b)
	end


	--Fix header strata
	local frame = CreateFrame("Frame",nil,module.frame)
	frame:SetPoint("TOP")
	frame:SetSize(1,1)

	module.frame.title:SetParent(frame)
end

do
	local headers = CreateFrame("Frame",nil,module.frame.maximized)
	module.frame.headers = headers

	for i,key in pairs(RCW_iconsListHeaders) do
		headers[i] = ELib:Text(headers,key,10):Color(1,1,1)
		if i == 1 then
			headers[i]:Point("BOTTOMLEFT",module.frame,"TOPLEFT",155,-48)
		else
			headers[i]:Point("BOTTOMLEFT",headers[i-1],"BOTTOMLEFT",30+(RCW_iconsListWide[i-1] and 15 or 0)+(RCW_iconsListWide[i] and 15 or 0),0)
		end
	end

	local group = headers:CreateAnimationGroup()
	group:SetScript('OnFinished', function() group:Play() end)
	local rotation = group:CreateAnimation('Rotation')
	rotation:SetDuration(0.000001)
	rotation:SetEndDelay(2147483647)
	rotation:SetOrigin('BOTTOMRIGHT', 0, 0)
	rotation:SetDegrees(20)
	group:Play()
end

function module.frame:PrepToHide()
	if (not module.frame:IsShown()) or (self.isManual) then
		return
	end

	local delay = tonumber(VMRT.RaidCheck.ReadyCheckFrameTimerFade or "4") or 4
	module.frame.hideTimer = C_Timer.NewTimer(max(0.01,delay),function()
		module.frame.hideTimer = nil
		module.frame.anim:Play()
	end)
	module.frame.timeLeftLine:Stop()
end

local RCW_UnitToLine = {}

local RCW_RCStatusToIcon = {
	[1] = "Interface\\RaidFrame\\ReadyCheck-Waiting",
	[2] = "Interface\\RaidFrame\\ReadyCheck-Ready",
	[3] = "Interface\\RaidFrame\\ReadyCheck-NotReady",
}

function module.frame:UpdateLinesSize(large)
	local size1 = large and 20 or 14
	local size2 = large and 18 or 14
	local size3 = large and 8 or 6
	local size4 = large and 10 or 8
	for i=1,#self.lines do 
		local line = self.lines[i]
		line:SetHeight(size1)
		for i,key in pairs(RCW_iconsList) do
			for j=1,4 do
				local icon = line[key..(j == 1 and "" or tostring(j))]
				icon:SetSize(size2,size2)
				icon.size = size2
				icon.text:SetFont(icon.text:GetFont(),size3,"OUTLINE")
				icon.bigText:SetFont(icon.bigText:GetFont(),size4,"OUTLINE")
				icon.subIcon:SetSize(size4,size4)
			end
		end
	end
end

local testRandomNames = {	--Top parses on WCL :)
	"Dredd",
	"Tygar","Lexk","Zoot","Creams","Critcapped","Dragonaut","Kimence","Raarticuno","Tek","Vodia","Waffles","Bovice","Katbus","Sassuke","Thriser","Variety","Xennov","Drshockalu","Illson","Ushnark","Angelista","Beezy","Blankies","Bujusima","Creamydee","Cutemeatball","Dmb","Garwyn","Sharoon","Shrode","Zhava",
	"Inkline","Fog","Lukn","Vanq","Coziness","Detore","Mcdoogal","Scubastevee",
	"Brath",
	"Elron","Palyu","Ravage","Andyxo","Dean","Dee","Emlis","Manglz","Rhuku","Thance","Verruckt","Zeki","Dane","Blurs","Perry","Smy","Soylent","Earl","Hedral","Jiyun","Xelectra","Bloodrusher","Ej","Execute","Lyger","Musclemommyx","Retrofresh","Rodcockulous",
	"Swimmies","Bixr","Buffcheck","Lightbox","Riggered","Stonka","Yim","Pigg","Poom","Vish",
	"Loue",
	"Cheely","Exora","Hoh","Perilla","Asuna","Devi","Empty","Klikey","Rtm","Sammie","Trashy","Kame","Legs","Ordi","Rising","Seyera","Arafei","Dikken","Lillefod","Abbotts","Dumpy","Feron","Fungi","Kolonelkunt","Pahstee","Tyba","Yvraine","Zela",
	"Krageth","Lunaris","Aestalux","Delmaree","Kutsal","Odoac","Shadyshade","Dokiecry","El","Elyvilon","Samm",
}

function module.frame:UpdateRoster()
	wipe(RCW_UnitToLine)
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	local inRaid = IsInRaid()
	local count = 0
	local classColorsTable = type(CUSTOM_CLASS_COLORS)=="table" and CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
	if self.isTest then
		local function shuffle(tbl)
			for i = #tbl, 2, -1 do
				local j = math.random(i)
				tbl[i], tbl[j] = tbl[j], tbl[i]
			end
			return tbl
		end
		shuffle(testRandomNames)
	end
	local result = {}
	for i=1,(self.isTest and (ExRT.isClassic and 40 or math.random(0,1)*10+20) or 40) do
		local name,subgroup,_,class,unit
		if self.isTest then
			--name = format("%s %d","raid",i)
			name = testRandomNames[i]
			if #name > 2 then
				local del = math.random(2,#name)
				name = name:sub(1,del-1)..name:sub(del+1)
			end
			subgroup = i / 5
			class = ExRT.GDB.ClassList[math.random(1,12)]
			unit = "raid"..i
		elseif not inRaid and i <= 5 then
			unit = i == 1 and 'player' or 'party'..(i-1)
			name = UnitName(unit)
			subgroup = 1
			class = select(2,UnitClass(unit))
		else
			name,_,subgroup,_,_,class = GetRaidRosterInfo(i)
			unit = "raid"..i
		end
		if name and subgroup <= gMax then 
			result[#result+1] = {
				name = ExRT.F.delUnitNameServer(name),
				unit = unit,
				class = class,
			}
		end
	end
	if VMRT and VMRT.RaidCheck and VMRT.RaidCheck.ReadyCheckSortClass then
		sort(result,function(a,b)
			if a.class == b.class then
				return a.name < b.name
			else
				return a.class < b.class
			end
		end)
	end
	for i=1,#result do
		count = count + 1
		local line = self.lines[count]
		if line then
			local data = result[i]

			line.name:SetText(data.name)
			line.unit = data.unit
			line.unit_name = data.name
			line.name:SetTextColor(1,1,1,1)

			line.mini.name:SetText(data.name)
			line.mini.name:SetTextColor(1,1,1,1)

			local classColor = classColorsTable[data.class]
			local r,g,b = classColor and classColor.r or .7,classColor and classColor.g or .7,classColor and classColor.b or .7

			line.classLeft:SetGradientAlpha("HORIZONTAL",r,g,b,.4,r,g,b,0)

			line:Show()
			line.mini:Show()

			line.rc_status = 1

			RCW_UnitToLine[data.name] = line
			RCW_UnitToLine[line.unit] = line
		end
	end
	for i=count+1,#self.lines do 
		self.lines[i].unit = nil
		self.lines[i]:Hide()

		self.lines[i].mini:Hide()
	end
	self:UpdateLinesSize(count <= 20)
	self.SizeMaximized = 55 + (count <= 20 and 20 or 14) * count
	self.SizeMinimized = 25 + math.ceil(count / 4) * 14
	self:SetHeight(self.maximized:IsShown() and self.SizeMaximized or self.SizeMinimized)
end

function module.frame:UpdateData(onlyLine)
	if not vruneName and not ExRT.isClassic then
		local kjrunename = GetSpellInfo(237825)
		if kjrunename then
			kjrunename = kjrunename:match("^(.-)[:%-：]")
			if kjrunename then
				vruneName = "^"..kjrunename
			end
		end
	end
	local total,totalResponced = 0,0
	local currTime,currTime2 = time(),GetTime()
	for i=1,#self.lines do 
		local line = self.lines[i]
		if line.unit then
			total = total + 1
			if line.rc_status == 2 or line.rc_status == 3 then
				totalResponced = totalResponced + 1
			end

			if not onlyLine or line == onlyLine then
				local buffCount = 0
				local flaskCount = 1
				local scrollCount = 1

				line.icon.texture:SetTexture(RCW_RCStatusToIcon[line.rc_status] or "")
				line.mini.icon.texture:SetTexture(RCW_RCStatusToIcon[line.rc_status] or "")

				for i,key in pairs(RCW_iconsList) do
					line[key].texture:SetTexture("")
					line[key].texture:SetAlpha(1)
					line[key].text:SetText("")
					line[key].bigText:SetText("")
					line[key].tooltip = nil
					line[key].subIcon:Hide()
					line[key]:Point("CENTER",line[key.."pointer"],"CENTER",0,0)

					for j=2,4 do
						line[key..j].texture:SetTexture("")
						line[key..j].texture:SetAlpha(1)
						line[key..j].text:SetText("")
						line[key..j].bigText:SetText("")
						line[key..j].tooltip = nil
						line[key..j]:Hide()
						line[key..j].subIcon:Hide()
					end
				end
				for i=1,60 do
					local name,icon,_,_,duration,expirationTime,_,_,_,spellId,_,_,_,_,_,val1 = UnitAura(line.unit, i,"HELPFUL")
					if not spellId then
						break
					elseif module.db.tableFood[spellId] then
						local val = module.db.tableFood[spellId]

						line.food.texture:SetTexture(136000)
						if type(val)~="number" then
							val = ""
						elseif module.db.tableFoodIsBest[spellId] then
							line.food.text:SetTextColor(0,1,0)
						elseif val >= 30 or (UnitLevel'player' < 60 and val >= 10) then
							line.food.text:SetTextColor(0,1,0)
						else
							line.food.text:SetTextColor(1,0,0)
						end
						line.food.text:SetText(val)
						line.food.tooltip = i

						if expirationTime and expirationTime - currTime2 < 600 and expirationTime ~= 0 then
							line.food.subIcon:Show()
							line.food.texture:SetAlpha(.6)
						end

						buffCount = buffCount + 1
					elseif icon == 134062 or icon == 132805 then
						line.food.texture:SetTexture(134062)
						line.food.text:SetText("")
					elseif icon == 136000 then
						line.food.texture:SetTexture(136000)
						line.food.text:SetTextColor(1,1,1)
						if val1 == 0 then val1 = nil end
						line.food.text:SetText(val1 or "")
						line.food.tooltip = i

						buffCount = buffCount + 1
					elseif module.db.tableFlask[spellId] then
						local val = module.db.tableFlask[spellId]

						local frame = line["flask"..(flaskCount == 1 and "" or tostring(flaskCount))]
						line.flask:Point("CENTER",line.flaskpointer,"CENTER",-(line.flask.size or 18)*((flaskCount-1)/2),0)
						flaskCount = flaskCount + 1
						if flaskCount > 4 then
							flaskCount = 4
						end

						frame.texture:SetTexture(icon)
						if type(val)=='number' then
							if (UnitLevel'player' >= 60 and val >= 38) or (val >= 14) then
								frame.text:SetTextColor(0,1,0)
							else
								frame.text:SetTextColor(1,1,0)
							end
							frame.text:SetText(val)
						else
							frame.text:SetText("")
						end
						frame.tooltip = i

						if expirationTime and expirationTime - currTime2 < 600 and expirationTime ~= 0 then
							frame.subIcon:Show()
							frame.texture:SetAlpha(.6)
						end

						frame:Show()

						buffCount = buffCount + 1
					elseif module.db.tableScrolls[spellId] and ExRT.isBC then
						local val = module.db.tableScrolls[spellId]

						local frame = line["scrolls"..(scrollCount == 1 and "" or tostring(scrollCount))]
						line.scrolls:Point("CENTER",line.scrollspointer,"CENTER",-(line.scrolls.size or 18)*((scrollCount-1)/2),0)
						scrollCount = scrollCount + 1
						if scrollCount > 4 then
							scrollCount = 4
						end

						frame.texture:SetTexture(icon)
						if type(val)=='number' then
							if (UnitLevel'player' >= 60 and val >= 38) or (val >= 14) then
								frame.text:SetTextColor(0,1,0)
							else
								frame.text:SetTextColor(1,1,0)
							end
							frame.text:SetText(val)
						else
							frame.text:SetText("")
						end
						frame.tooltip = i

						if expirationTime and expirationTime - currTime2 < 180 and expirationTime ~= 0 then
							frame.subIcon:Show()
							frame.texture:SetAlpha(.6)
						end

						frame:Show()

						buffCount = buffCount + 1
					elseif module.db.tableVantus[spellId] then
						local val = module.db.tableVantus[spellId]

						line.vantus.texture:SetTexture(icon)
						line.vantus.text:SetTextColor(1,1,1)
						line.vantus.text:SetText(val)

						line.vantus.tooltip = i
					elseif name and not ExRT.isClassic and vruneName and name:find(vruneName) then
						line.vantus.texture:SetTexture(icon)
						line.vantus.text:SetText("")

						line.vantus.tooltip = i
					elseif module.db.tableRunes[spellId] and line.rune then
						local val = module.db.tableRunes[spellId]

						line.rune.texture:SetTexture((spellId == 270058 or spellId == 317065) and 840006 or (spellId == 347901 and 134078) or icon)
						if val >= 18 then
							line.rune.text:SetTextColor(0,1,0)
							line.rune.text:SetText("")
						else
							line.rune.text:SetTextColor(1,0,0)
							line.rune.text:SetText(val)
						end
					elseif module.db.tableInt[spellId] and not ExRT.isClassic then
						line.int.texture:SetTexture(icon)
						line.int.text:SetText("")

						buffCount = buffCount + 1
					elseif module.db.tableAP[spellId] and not ExRT.isClassic then
						line.ap.texture:SetTexture(icon)
						line.ap.text:SetText("")

						buffCount = buffCount + 1
					elseif module.db.tableStamina[spellId] and not ExRT.isClassic then
						line.stam.texture:SetTexture(icon)
						line.stam.text:SetText("")

						buffCount = buffCount + 1
					elseif ExRT.isClassic and module.db.tableClassicBuff[spellId] then
						local data = module.db.tableClassicBuff[spellId]

						local key = data[1]
						line[key].texture:SetTexture(icon)

						local val = data[4][spellId]
						line[key].text:SetText(val or "")

						line[key].tooltip = "spell:"..spellId
					elseif spellId == 20707 and line.ss then
						line.ss.texture:SetTexture(136210)
					end
				end
				if line.dur and not self.isTest then
					local durTab, dur = module.db.durability[line.unit_name]
					if durTab and (durTab.time + (line.rc_status ~= 4 and 60 or 600) > currTime) then
						dur = durTab.dur
					end
					line.dur.bigText:SetText(dur and format("%d",dur).."%" or "-")
					if dur and dur <= 20 then
						line.dur.bigText:SetTextColor(1,0,0)
					elseif dur and dur <= 50 then
						line.dur.bigText:SetTextColor(1,1,0)
					else
						line.dur.bigText:SetTextColor(1,1,1)
					end
				end
				if line.kit and not self.isTest then
					local durTab, dur = module.db.kit[line.unit_name]
					if durTab and (durTab.time + (line.rc_status ~= 4 and 60 or 600) > currTime) then
						dur = durTab.kit
					end
					line.kit.bigText:SetText(dur or "-")
					line.kit.text:SetTextColor(1,1,1)

					local kNow,kMax = (dur or ""):match("(%d+)/(%d+)")

					if kNow == "1" then
						line.kit.bigText:SetText("")
						line.kit.texture:SetTexture(3528447)
						line.kit.tooltip = "spell:"..324068

						if durTab.types then
							local itemID = strsplit(":",durTab.types)
							if itemID and itemID ~= "0" and tonumber(itemID) then
								local _, _, _, _, icon = GetItemInfoInstant(tonumber(itemID))
								if icon then
									line.kit.texture:SetTexture(icon)
								end
								line.kit.tooltip = "item:"..itemID

								local stats = ""
								if itemID == "172347" then
									stats = 32
									line.kit.text:SetTextColor(0,1,0)
								elseif itemID == "172346" then
									stats = 16
									line.kit.text:SetTextColor(1,1,0)
								elseif itemID == "180709" then
									stats = 24
									line.kit.text:SetTextColor(1,1,0)
								end
								line.kit.text:SetText(stats)
							end
						end
					elseif kNow == "0" then
						line.kit.bigText:SetText("")
					end 

					if not kNow or not kMax or kNow == kMax then
						line.kit.bigText:SetTextColor(1,1,1)
					elseif kNow == "0" then
						line.kit.bigText:SetTextColor(1,0,0)
					else
						line.dur.bigText:SetTextColor(1,1,0)
					end
				end
				if line.oil and not self.isTest then
					local durTab, oil, oil2 = module.db.oil[line.unit_name]
					if durTab and (durTab.time + (line.rc_status ~= 4 and 60 or 600) > currTime) then
						oil = durTab.oil
						oil2 = module.db.oil2[line.unit_name]
					end
					if not oil then
						line.oil.bigText:SetText("-")
					elseif oil == "0" then

					else
						local texture = select(3,GetSpellInfo(tonumber(oil)))
						if oil == "320798" then texture = 463543
						elseif oil == "321389" then texture = 463544
						elseif oil == "322762" then texture = 3528422
						elseif oil == "322763" then texture = 3528423 
						end
						line.oil.texture:SetTexture(texture)
						line.oil.tooltip = "spell:"..oil

						if oil2 then
							oil2 = oil2.oil
							if oil2 ~= "0" then
								local texture = select(3,GetSpellInfo(tonumber(oil2)))
								if oil2 == "320798" then texture = 463543
								elseif oil2 == "321389" then texture = 463544
								elseif oil2 == "322762" then texture = 3528422
								elseif oil2 == "322763" then texture = 3528423 
								end
								line.oil2.texture:SetTexture(texture)
								line.oil2.tooltip = "spell:"..oil2
								line.oil2:Show()
	
								local size = (line.oil.size or 18) - 4
								line.oil:SetSize(size,size)
								line.oil2:SetSize(size,size)
								
								line.oil:Point("CENTER",line.oilpointer,"CENTER",-size*(1/2),0)
							end
						end
					end
				end

				if self.isTest and line.pos <= (ExRT.isClassic and 30 or 15) then
					self.testData[line.pos] = self.testData[line.pos] or {}

					local hideOne = self.testData[line.pos].hideOne or math.random(1,#RCW_iconsList)
					self.testData[line.pos].hideOne = hideOne

					for i,key in pairs(RCW_iconsList) do
						if line.pos <= 5 or i ~= hideOne then
							line[key].texture:SetTexture(RCW_iconsListDebugIcons[i])
							line[key].text:SetText("")
						end
					end

					if ExRT.isClassic then
						local flaskNum = self.testData[line.pos].flaskNum or math.random(0,4)
						self.testData[line.pos].flaskNum = flaskNum

						line.flask:Point("CENTER",line.flaskpointer,"CENTER",-(line.flask.size or 18)*((flaskNum-1)/2),0)

						if flaskNum >= 1 then line.flask.texture:SetTexture(RCW_iconsListDebugIcons[2]) else line.flask.texture:SetTexture("") end
						if flaskNum >= 2 then line.flask2.texture:SetTexture(RCW_iconsListDebugIcons[2]) line.flask2:Show() end
						if flaskNum >= 3 then line.flask3.texture:SetTexture(RCW_iconsListDebugIcons[2]) line.flask3:Show() end
						if flaskNum >= 4 then line.flask4.texture:SetTexture(RCW_iconsListDebugIcons[2]) line.flask4:Show() end

						if ExRT.isBC then
							local scrollNum = self.testData[line.pos].scrollNum or math.random(0,4)
							self.testData[line.pos].scrollNum = scrollNum
	
							line.scrolls:Point("CENTER",line.scrollspointer,"CENTER",-(line.scrolls.size or 18)*((scrollNum-1)/2),0)
	
							if scrollNum >= 1 then line.scrolls.texture:SetTexture(RCW_iconsListDebugIcons[3]) else line.scrolls.texture:SetTexture("") end
							if scrollNum >= 2 then line.scrolls2.texture:SetTexture(RCW_iconsListDebugIcons[3]) line.scrolls2:Show() end
							if scrollNum >= 3 then line.scrolls3.texture:SetTexture(RCW_iconsListDebugIcons[3]) line.scrolls3:Show() end
							if scrollNum >= 4 then line.scrolls4.texture:SetTexture(RCW_iconsListDebugIcons[3]) line.scrolls4:Show() end
						end
					end

					local lowFlask = self.testData[line.pos].lowFlask or math.random(1,60)
					self.testData[line.pos].lowFlask = lowFlask
					if lowFlask <= 10 and line.flask.texture:GetTexture() then
						line.flask.subIcon:Show()
						line.flask.texture:SetAlpha(.6)
					end

					if line.dur then
						line.dur.texture:SetTexture("")
						local dur = self.testData[line.pos].dur or math.random(1,10000) / 100
						self.testData[line.pos].dur = dur

						line.dur.bigText:SetText(dur and format("%d",dur).."%" or "-")
						if dur and dur <= 20 then
							line.dur.bigText:SetTextColor(1,0,0)
						elseif dur and dur <= 50 then
							line.dur.bigText:SetTextColor(1,1,0)
						else
							line.dur.bigText:SetTextColor(1,1,1)
						end
					end

					buffCount = self.testData[line.pos].buffCount or math.random(4,5)
					self.testData[line.pos].buffCount = buffCount
				end

				if line.rc_status == 3 then
					line.name:SetTextColor(1,.5,.5)
					line.name:SetAlpha(1)
				elseif line.rc_status == 2 and (buffCount >= 5 or ExRT.isClassic) then
					line.name:SetTextColor(1,1,1)
					line.name:SetAlpha(.3)
				elseif line.rc_status == 2 then
					line.name:SetTextColor(1,1,.5)
					line.name:SetAlpha(1)
				else
					line.name:SetTextColor(1,1,1)
					line.name:SetAlpha(1)
				end

				if line.rc_status == 3 then
					line.mini.name:SetTextColor(1,.5,.5)
					line.mini.name:SetAlpha(1)
				elseif line.rc_status == 2 then
					line.mini.name:SetTextColor(1,1,1)
					line.mini.name:SetAlpha(.3)
				else
					line.mini.name:SetTextColor(1,1,1)
					line.mini.name:SetAlpha(1)
				end
			end
		end
	end
	if total == totalResponced then
		self:PrepToHide()
	end
	self.timeLeftLine:SetProgress(total,totalResponced)
end

module.frame:SetScript("OnEvent",function(self,event,unit)
	--This can stop updating after UI hiding (Alt+Z)
	if not self:IsVisible() then
		self:UnregisterAllEvents()
		return
	end
	if unit and RCW_UnitToLine[unit] then
		module.frame:UpdateData(RCW_UnitToLine[unit])
	end
end)


function module:ReadyCheckWindow(starter,isTest,manual)
	self.frame:Create()

	module.db.RaidCheckReadyCheckTime = nil

	local colsAdd = 0
	if VMRT.RaidCheck.ReadyCheckSoulstone then
		colsAdd = bit.bor(colsAdd,0x1)
	end
	if (self.frame.colsAdd or 0) ~= colsAdd then
		self.frame.colsAdd = colsAdd
		self.frame:UpdateCols()
	end

	self.frame.isManual = manual

	self.frame.isTest = isTest
	if not self.frame.testData then
		self.frame.testData = {}
	else
		wipe(self.frame.testData)
	end
	self.frame:UpdateRoster()
	if manual then
		for i=1,#self.frame.lines do 
			self.frame.lines[i].rc_status = 4
		end
		if UnitLevel'player' >= 50 and not ExRT.isClassic then
			ExRT.F.SendExMsg("raidcheckreq","REQ\t1")
		end
	end
	self.frame:UpdateData()

	self.frame.headText:SetText("MRT")

	self.frame.timeLeftLine:Hide()

	self.frame.mimimize:Hide()
	self.frame:SetMaximized()

	if self.frame.hideTimer then
		self.frame.hideTimer:Cancel()
	end

	self.frame.anim:Stop()
	self.frame:SetAlpha(1)
	self.frame:Show()

	self.frame:RegisterEvent("UNIT_AURA")
end

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.RaidCheck = VMRT.RaidCheck or {
		ReadyCheckFrame = true,
		ReadyCheckFrameOnlyRL = true,
	}

	VMRT.RaidCheck.FlaskExp = VMRT.RaidCheck.FlaskExp or 1

	if VMRT.Addon.Version < 3930 then
		VMRT.RaidCheck.BuffsCheck = true
	end
	if VMRT.Addon.Version < 4080 then
		if not VMRT.RaidCheck.ReadyCheckFrame then
			VMRT.RaidCheck.ReadyCheckFrame = true
			VMRT.RaidCheck.ReadyCheckFrameOnlyRL = true
		end
	end

	if VMRT.RaidCheck.ReadyCheckLeft and VMRT.RaidCheck.ReadyCheckTop then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VMRT.RaidCheck.ReadyCheckLeft,VMRT.RaidCheck.ReadyCheckTop) 
	end
	if VMRT.RaidCheck.ReadyCheckFrameScale then
		module.frame:SetScale(VMRT.RaidCheck.ReadyCheckFrameScale/100)
	end
	VMRT.RaidCheck.ReadyCheckFrameTimerFade = VMRT.RaidCheck.ReadyCheckFrameTimerFade or 4

	module.db.tableFoodInProgress = GetSpellInfo(104934)

	if VMRT.RaidCheck.ReadyCheckFrame then
		module:RegisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
	end
	if VMRT.RaidCheck.PotionCheck then
		module:RegisterEvents('ENCOUNTER_START','ENCOUNTER_END')
	end

	if not VMRT.RaidCheck.WeaponEnch then
		VMRT.RaidCheck.WeaponEnch = {}
	end

	module:RegisterEvents('READY_CHECK')

	module:RegisterSlash()
	module:RegisterAddonMessage()

	if module.consumables and not VMRT.RaidCheck.DisableConsumables then
		module.consumables:Enable()
	end
end

local function SendDataToChat()
	if IsSendFoodByMe then
		GetFood(2)
	end
	if IsSendFlaskByMe then
		GetFlask(2)
	end
	if IsSendRunesByMe then
		GetRunes(2)
	end
	if IsSendBuffsByMe then
		GetRaidBuffs(2)
	end
	if IsSendKitsByMe then
		GetKits(2)
	end
	if IsSendOilsByMe then
		GetOils(2)
	end
	IsSendFoodByMe = nil
	IsSendFlaskByMe = nil
	IsSendRunesByMe = nil
	IsSendBuffsByMe = nil
	IsSendKitsByMe = nil
	IsSendOilsByMe = nil
end

local function PrepareDataToChat(toSelf)
	if toSelf then
		GetFood(3)
		GetFlask(3)
		if VMRT.RaidCheck.RunesCheck then
			GetRunes(3)
		end
		if VMRT.RaidCheck.BuffsCheck then
			GetRaidBuffs(3)
		end
		C_Timer.After(1,function()
			if VMRT.RaidCheck.KitsCheck then
				GetKits(3)
			end
			if VMRT.RaidCheck.OilsCheck then
				GetOils(3)
			end
		end)
	else
		if VMRT.RaidCheck.disableLFR then
			local _,_,difficulty = GetInstanceInfo()
			if difficulty == 7 or difficulty == 17 then
				return
			end
		end
		IsSendFoodByMe = true
		ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","FOOD\t"..ExRT.V)
		IsSendFlaskByMe = true
		ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","FLASK\t"..ExRT.V)
		IsSendRunesByMe = nil
		if VMRT.RaidCheck.RunesCheck then
			IsSendRunesByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","RUNES\t"..ExRT.V)
		end
		IsSendBuffsByMe = nil
		if VMRT.RaidCheck.BuffsCheck then
			IsSendBuffsByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","BUFFS\t"..ExRT.V)
		end
		IsSendKitsByMe = nil
		if VMRT.RaidCheck.KitsCheck then
			IsSendKitsByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","REPORT_KITS\t"..ExRT.V)
		end
		IsSendOilsByMe = nil
		if VMRT.RaidCheck.OilsCheck then
			IsSendOilsByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","REPORT_OILS\t"..ExRT.V)
		end

		ExRT.F.ScheduleTimer(SendDataToChat, 1)
	end
end

function module:SendConsumeData()
	local oilMH, oilOH = module:OilCheck()

	local kitNow, kitMax, kitTimeLeft, kitType = module:KitCheck()

	ExRT.F.SendExMsg("raidcheck","DUR\t"..ExRT.V.."\t"..format("%.2f",module:DurabilityCheck())..
		(not ExRT.isClassic and "\tKIT\t"..format("%d/%d",kitNow, kitMax) or "")..
		(not ExRT.isClassic and "\tOIL\t"..format("%d",oilMH) or "")..
		(not ExRT.isClassic and "\tOIL2\t"..format("%d",oilOH) or "")..
		(not ExRT.isClassic and "\tKITT\t"..format("%d",kitType or 0) or "")
	)
end

do
	local function ScheduledReadyCheckFinish()
		module.main:READY_CHECK_FINISHED()
	end
	function module.main:READY_CHECK(starter,timer,isTest)
		if not (isTest == "TEST") then 
			isTest = nil 
		end
		if VMRT.RaidCheck.ReadyCheck and not isTest and not ExRT.isClassic then
			PrepareDataToChat(VMRT.RaidCheck.SendSelf)
		end
		if (VMRT.RaidCheck.ReadyCheckFrame and (not VMRT.RaidCheck.ReadyCheckFrameOnlyRL or ExRT.F.IsPlayerRLorOfficer("player"))) or isTest then
			ExRT.F.CancelTimer(module.db.RaidCheckReadyCheckHideSchedule)
			module.db.RaidCheckReadyCheckHideSchedule = ExRT.F.ScheduleTimer(ScheduledReadyCheckFinish, timer or 35)
			module:ReadyCheckWindow(starter,isTest)
			module.db.RaidCheckReadyCheckTime = GetTime() + (timer or 35)
			module.frame.timeLeftLine:Start(timer or 35)
			module.frame.mimimize:Show()
			module.frame:SetMinimizedFromOptions()
			module.main:READY_CHECK_CONFIRM(ExRT.F.delUnitNameServer(starter),true,isTest)
		end
		if not isTest then
			module:SendConsumeData()
		end
	end
end

function module.main:READY_CHECK_FINISHED()
	module.frame:PrepToHide()
end

function module.main:READY_CHECK_CONFIRM(unit,response,isTest)
	if not (isTest == "TEST") then 
		unit = UnitName(unit) 
		isTest = nil 
	end
	if unit and RCW_UnitToLine[unit] then
		local line = RCW_UnitToLine[unit]
		line.rc_status = response == true and 2 or 3

		module.frame:UpdateData(line)
	end
end

do
	local _db = module.db
	function module.main.COMBAT_LOG_EVENT_UNFILTERED(_,event,_,_,sourceName,_,_,_,_,_,_,spellId)
		if event == "SPELL_CAST_SUCCESS" and sourceName then
			if _db.hsSpells[spellId] then
				_db.hsList[sourceName] = _db.hsList[sourceName] and _db.hsList[sourceName] + 1 or 1
			elseif _db.tablePotion[spellId] then
				_db.potionList[sourceName] = _db.potionList[sourceName] and _db.potionList[sourceName] + 1 or 1
			end
		end
	end
end

module.db.prevReqAntispam = 0

function module:addonMessage(sender, prefix, type, ver, ...)
	if prefix == "raidcheck" then
		if sender then
			ver = max(tonumber(ver or "0") or 0,3910)	--set min ver to 3910
			if type == "DUR" then
				local val = ...
				val = tonumber(val or "100") or 100
				module.db.durability[sender] = {
					time = time(),
					dur = val,
				}
				local shortName = ExRT.F.delUnitNameServer(sender)
				module.db.durability[shortName] = module.db.durability[sender]

				for i=2, select('#', ...), 2 do
					local key,val = select(i, ...)
					if key == "KIT" then
						module.db.kit[sender] = {
							time = time(),
							kit = val,
						}
						module.db.kit[shortName] = module.db.kit[sender]
					elseif key == "KITT" then
						local data = module.db.kit[sender]
						if data then
							data.types = val
						end
					elseif key == "OIL" then
						module.db.oil[sender] = {
							time = time(),
							oil = val,
						}
						module.db.oil[shortName] = module.db.oil[sender]
					elseif key == "OIL2" then
						module.db.oil2[sender] = {
							time = time(),
							oil = val,
						}
						module.db.oil2[shortName] = module.db.oil2[sender]
					end
				end

				local line = RCW_UnitToLine[shortName]
				if line then
					module.frame:UpdateData(line)
				end
			end
			if ver > ExRT.V then
				if type == "FOOD" then
					IsSendFoodByMe = nil
				elseif type == "FLASK" then
					IsSendFlaskByMe = nil
				elseif type == "RUNES" then
					IsSendRunesByMe = nil
				elseif type == "BUFFS" then
					IsSendBuffsByMe = nil
				elseif type == "REPORT_KITS" then
					IsSendKitsByMe = nil
				elseif type == "REPORT_OILS" then
					IsSendOilsByMe = nil
				end
				return
			end
			if ExRT.F.IsPlayerRLorOfficer(ExRT.SDB.charName) == 2 then
				return
			end
			if (sender < ExRT.SDB.charName or ExRT.F.IsPlayerRLorOfficer(sender) == 2) and ver >= ExRT.V then
				if type == "FOOD" then
					IsSendFoodByMe = nil
				elseif type == "FLASK" then
					IsSendFlaskByMe = nil
				elseif type == "RUNES" then
					IsSendRunesByMe = nil
				elseif type == "BUFFS" then
					IsSendBuffsByMe = nil
				elseif type == "REPORT_KITS" then
					IsSendKitsByMe = nil
				elseif type == "REPORT_OILS" then
					IsSendOilsByMe = nil
				end
			end
		end
	elseif prefix == "raidcheckreq" then
		if type == "REQ" then
			if ver == "1" then
				local currTime = GetTime()
				if currTime - module.db.prevReqAntispam < 300 then
					return
				end
				module.db.prevReqAntispam = currTime

				module:SendConsumeData()
			end
		end
	end
end

local addonMsgFrame = CreateFrame'Frame'
local addonMsgAttack_AntiSpam = 0
addonMsgFrame:SetScript("OnEvent",function (self, event, ...)
	local prefix, message, channel, sender = ...
	if message and ((prefix == "BigWigs" and message:find("^T:BWPull")) or (prefix == "D4" and message:find("^PT"))) then
		if VMRT.RaidCheck.OnAttack and not ExRT.isClassic then
			local _time = GetTime()
			if (_time - addonMsgAttack_AntiSpam) < 2 then
				return
			end
			addonMsgAttack_AntiSpam = _time

			PrepareDataToChat(VMRT.RaidCheck.SendSelf)
		end
	end
end)
addonMsgFrame:RegisterEvent("CHAT_MSG_ADDON")


if (not ExRT.isClassic) and UnitLevel'player' >= 60 then
	local consumables_size = 44

	local lastWeaponEnchantItem

	module.consumables = CreateFrame("Frame","MRTConsumables",ReadyCheckListenerFrame)
	module.consumables:SetPoint("BOTTOM",ReadyCheckListenerFrame,"TOP",0,5)
	module.consumables:SetSize(consumables_size*5,consumables_size)
	module.consumables:Hide()
	module.consumables.buttons = {}

	module.consumables.rlpointer = CreateFrame("Frame",nil,UIParent)
	module.consumables.rlpointer:SetSize(1,1)
	module.consumables.rlpointer:SetPoint("CENTER")
	module.consumables.rlpointer:Hide()

	module.consumables.close = ELib:Button(module.consumables,CLOSE or 'x',"ExRTButtonModernTemplate,SecureHandlerClickTemplate"):Shown(false):Size(0,20):Point("TOPLEFT",module.consumables,"BOTTOMLEFT",0,-2):Point("TOPRIGHT",module.consumables,"BOTTOMRIGHT",0,-2)
	module.consumables.close:SetFrameRef("rlpointer",module.consumables.rlpointer)
	module.consumables.close:SetAttribute("_onclick",[[ self:GetFrameRef("rlpointer"):Hide() ]])

	local function ButtonOnEnter(self)
		self:GetParent():SetAlpha(.7)
	end
	local function ButtonOnLeave(self)
		self:GetParent():SetAlpha(1)
	end

	module.consumables.state = CreateFrame('Frame', nil, nil, 'SecureHandlerStateTemplate')
	module.consumables.state:SetAttribute('_onstate-combat', [=[
		for i=2,8 do
			if i ~= 6 then
				if self:GetFrameRef("Button"..i) then
					if newstate == 'hide' then
						self:GetFrameRef("Button"..i):Hide()
					elseif newstate == 'show' then
						if self:GetFrameRef("Button"..i).IsON then
							self:GetFrameRef("Button"..i):Show()
						end
					end
				end
			end
		end
	]=])
	RegisterStateDriver(module.consumables.state, 'combat', '[combat] hide; [nocombat] show')

	for i=1,8 do
		local button = CreateFrame("Frame",nil,module.consumables)
		module.consumables.buttons[i] = button
		button:SetSize(consumables_size,consumables_size)
		if i == 1 then
			button:SetPoint("LEFT",0,0)
		else
			button:SetPoint("LEFT",module.consumables.buttons[i-1],"RIGHT",0,0)
		end
	
		button.texture = button:CreateTexture()
		button.texture:SetAllPoints()
	
		button.statustexture = button:CreateTexture(nil,"OVERLAY")
		button.statustexture:SetPoint("CENTER")
		button.statustexture:SetSize(consumables_size/2,consumables_size/2)
	
		button.timeleft = button:CreateFontString(nil,"ARTWORK","GameFontWhite")
		button.timeleft:SetPoint("BOTTOM",button,"TOP",0,1)
		button.timeleft:SetFont(button.timeleft:GetFont(),8,"OUTLINE")
		--button.timeleft:SetTextColor(0,1,0,1)

		button.count = button:CreateFontString(nil,"ARTWORK","GameFontWhite")
		button.count:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-1,1)
		button.count:SetFont(button.timeleft:GetFont(),10,"OUTLINE")
		--button.count:SetTextColor(0,1,0,1)

		if i == 2 or i == 3 or i == 4 or i == 5 or i == 7 or i == 8 then
			button.click = CreateFrame("Button",nil,button,"SecureActionButtonTemplate")
			button.click:SetAllPoints()
			button.click:Hide()
			button.click:RegisterForClicks("AnyDown")
			if i == 4 or i == 7 then
				button.click:SetAttribute("type", "item")
				button.click:SetAttribute("target-slot", i == 4 and "16" or "17")
			else
				button.click:SetAttribute("type", "macro")
			end
	
			button.click:SetScript("OnEnter",ButtonOnEnter)
			button.click:SetScript("OnLeave",ButtonOnLeave)
	
			module.consumables.state:SetFrameRef("Button"..i, button.click)
		end
	
		if i == 1 then
			button.texture:SetTexture(136000)
			module.consumables.buttons.food = button
		elseif i == 2 then
			button.texture:SetTexture(3566840)
			module.consumables.buttons.flask = button
		elseif i == 3 then
			button.texture:SetTexture(3528447)
			module.consumables.buttons.kit = button
		elseif i == 4 then
			button.texture:SetTexture(463543)
			module.consumables.buttons.oil = button
		elseif i == 5 then
			button.texture:SetTexture(134078)
			module.consumables.buttons.rune = button
		elseif i == 6 then
			button.texture:SetTexture(538745)
			module.consumables.buttons.hs = button
		elseif i == 7 then
			button.texture:SetTexture(463543)
			module.consumables.buttons.oiloh = button
			button:Hide()
		elseif i == 8 then
			button.texture:SetTexture(136051)
			module.consumables.buttons.class = button
			button:Hide()
		end
	end
	
	function module.consumables:Enable()
		self:RegisterEvent("READY_CHECK")
		self:RegisterEvent("READY_CHECK_FINISHED")
		self:Show()
	end
	function module.consumables:Disable()
		self:UnregisterAllEvents()
		self:Hide()
	end

	local isElvUIFix

	function module.consumables:Update()
		if IsAddOnLoaded("ElvUI") and not isElvUIFix then
			self:SetParent(ReadyCheckFrame)
			self:ClearAllPoints()
			self:SetPoint("BOTTOM",ReadyCheckFrame,"TOP",0,5)
			isElvUIFix = true
		end

		local isWarlockInRaid
		for _, name, _, class in ExRT.F.IterateRoster, ExRT.F.GetRaidDiffMaxGroup() do
			if class == "WARLOCK" then
				isWarlockInRaid = true
				break
			end
		end
		local totalButtons = 6
		if not InCombatLockdown() then
			if isWarlockInRaid then
				self.buttons.hs:Show()
			else
				self.buttons.hs:Hide()
				totalButtons = totalButtons - 1
			end
		end

		for i=1,#self.buttons do
			self.buttons[i].statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
			self.buttons[i].timeleft:SetText("")
			self.buttons[i].count:SetText("")
			self.buttons[i].texture:SetDesaturated(true)
		end

		local LCG = LibStub("LibCustomGlow-1.0",true)

		local now = GetTime()

		local isFood, isRune, isFlask
		local isShamanBuff

		for i=1,60 do
			local name,icon,count,dispelType,duration,expires,caster,isStealable,_,spellId = UnitAura("player", i, "HELPFUL")
			if not spellId then
				break
			elseif module.db.tableFood[spellId] then
				self.buttons.food.statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
				self.buttons.food.texture:SetDesaturated(false)
				self.buttons.food.timeleft:SetFormattedText(GARRISON_DURATION_MINUTES,ceil((expires-now)/60))
				isFood = true
			elseif icon == 136000 and not isFood then
				self.buttons.food.statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
				self.buttons.food.texture:SetDesaturated(false)
				self.buttons.food.timeleft:SetFormattedText(GARRISON_DURATION_MINUTES,ceil((expires-now)/60))
			elseif module.db.tableFlask[spellId] then
				self.buttons.flask.statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
				self.buttons.flask.texture:SetDesaturated(false)
				self.buttons.flask.timeleft:SetFormattedText(GARRISON_DURATION_MINUTES,ceil((expires-now)/60))
				isFlask = true
				if expires - now <= 600 then
					isFlask = false
				end
			elseif module.db.tableRunes[spellId] then
				self.buttons.rune.statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
				self.buttons.rune.texture:SetDesaturated(false)
				self.buttons.rune.timeleft:SetFormattedText(GARRISON_DURATION_MINUTES,ceil((expires-now)/60))
				isRune = true
			elseif spellId == 192106 then
				isShamanBuff = format(GARRISON_DURATION_MINUTES,ceil((expires-now)/60))
				if expires - now <= 600 then
					isShamanBuff = false
				end
			end
		end

		local hsCount = GetItemCount(5512,false,true)
		if hsCount and hsCount > 0 then
			self.buttons.hs.count:SetFormattedText("%d",hsCount)
			self.buttons.hs.statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
			self.buttons.hs.texture:SetDesaturated(false)
		else
			self.buttons.hs.count:SetText("0")
		end



		local flaskCount = GetItemCount(171276,false,false)
		local flaskCanCount = GetItemCount(171280,false,false)
		if not isFlask and ((flaskCount and flaskCount > 0 and not VMRT.RaidCheck.DisableNotCauldronFlask) or (flaskCanCount and flaskCanCount > 0)) then
			if not InCombatLockdown() then
				local itemID = (flaskCanCount and flaskCanCount > 0) and 171280 or 171276
				local itemName = GetItemInfo(itemID)
				if itemName then
					self.buttons.flask.click:SetAttribute("macrotext1", format("/stopmacro [combat]\n/use %s", itemName))
					self.buttons.flask.click:Show()
					self.buttons.flask.click.IsON = true
				else
					self.buttons.flask.click:Hide()
					self.buttons.flask.click.IsON = false
				end
			end
		else
			if not InCombatLockdown() then
				self.buttons.flask.click:Hide()
				self.buttons.flask.click.IsON = false
			end
		end
		self.buttons.flask.count:SetFormattedText("%d%s",flaskCount,flaskCanCount > 0 and "+|cff00ff00"..flaskCanCount or "")
		if LCG then
			if not isFlask and ((flaskCount and flaskCount > 0 and not VMRT.RaidCheck.DisableNotCauldronFlask) or (flaskCanCount and flaskCanCount > 0)) then
				LCG.PixelGlow_Start(self.buttons.flask)
			else
				LCG.PixelGlow_Stop(self.buttons.flask)
			end
		end


		local kitCount = GetItemCount(172347,false,true)
		local kitNow, kitMax, kitTimeLeft = module:KitCheck()
		if kitNow > 0 then
			self.buttons.kit.statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
			self.buttons.kit.texture:SetDesaturated(false)
			if kitTimeLeft then
				self.buttons.kit.timeleft:SetText(kitTimeLeft)
			end
		end
		if kitCount and kitCount > 0 then
			if not InCombatLockdown() then
				local itemName = GetItemInfo(172347)
				if itemName then
					self.buttons.kit.click:SetAttribute("macrotext1", format("/stopmacro [combat]\n/use %s\n/use 5", itemName))
					self.buttons.kit.click:Show()
					self.buttons.kit.click.IsON = true
				else
					self.buttons.kit.click:Hide()
					self.buttons.kit.click.IsON = false
				end
			end
		else
			if not InCombatLockdown() then
				self.buttons.kit.click:Hide()
				self.buttons.kit.click.IsON = false
			end
		end
		self.buttons.kit.count:SetFormattedText("%d",kitCount)
		if LCG then
			if kitCount and kitCount > 0 and kitNow == 0 then
				LCG.PixelGlow_Start(self.buttons.kit)
			else
				LCG.PixelGlow_Stop(self.buttons.kit)
			end
		end

		lastWeaponEnchantItem = lastWeaponEnchantItem or VMRT.RaidCheck.WeaponEnch[ExRT.SDB.charKey]

		local offhandCanBeEnchanted
		local offhandItemID = GetInventoryItemID("player", 17)
		if offhandItemID then
			local _, _, _, _, _, itemClassID, itemSubClassID = GetItemInfoInstant(offhandItemID)
			if itemClassID == 2 then
				offhandCanBeEnchanted = true
			end
		end
		if not InCombatLockdown() then
			if offhandCanBeEnchanted then
				self.buttons.oiloh:Show()
				totalButtons = totalButtons + 1
				self.buttons.oiloh:ClearAllPoints()
				self.buttons.oiloh:SetPoint("LEFT",self.buttons.oil,"RIGHT",0,0)
				self.buttons.rune:ClearAllPoints()
				self.buttons.rune:SetPoint("LEFT",self.buttons.oiloh,"RIGHT",0,0)
			else
				self.buttons.oiloh:Hide()
				self.buttons.rune:ClearAllPoints()
				self.buttons.rune:SetPoint("LEFT",self.buttons.oil,"RIGHT",0,0)
			end
		end

		local hasMainHandEnchant, mainHandExpiration, mainHandCharges, mainHandEnchantID, hasOffHandEnchant, offHandExpiration, offHandCharges, offHandEnchantID = GetWeaponEnchantInfo()
		if hasMainHandEnchant then
			self.buttons.oil.statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
			self.buttons.oil.texture:SetDesaturated(false)
			self.buttons.oil.timeleft:SetFormattedText(GARRISON_DURATION_MINUTES,ceil((mainHandExpiration or 0)/1000/60))

			if mainHandEnchantID == 6190 then
				lastWeaponEnchantItem = 171286
			elseif mainHandEnchantID == 6188 then
				lastWeaponEnchantItem = 171285
			elseif mainHandEnchantID == 6200 then
				lastWeaponEnchantItem = 171437
			elseif mainHandEnchantID == 6198 then
				lastWeaponEnchantItem = 171436
			elseif mainHandEnchantID == 6201 then
				lastWeaponEnchantItem = 171439
			elseif mainHandEnchantID == 6199 then
				lastWeaponEnchantItem = 171438
			elseif mainHandEnchantID == 5401 then
				lastWeaponEnchantItem = -33757
			elseif mainHandEnchantID == 5400 then
				lastWeaponEnchantItem = -318038
			end
		end
		if offhandCanBeEnchanted and hasOffHandEnchant then
			self.buttons.oiloh.statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
			self.buttons.oiloh.texture:SetDesaturated(false)
			self.buttons.oiloh.timeleft:SetFormattedText(GARRISON_DURATION_MINUTES,ceil((offHandExpiration or 0)/1000/60))
		end
		if lastWeaponEnchantItem == 171286 then
			self.buttons.oil.texture:SetTexture(463544)
			self.buttons.oiloh.texture:SetTexture(463544)
		elseif lastWeaponEnchantItem == 171285 then
			self.buttons.oil.texture:SetTexture(463543)
			self.buttons.oiloh.texture:SetTexture(463543)
		elseif lastWeaponEnchantItem == 171437 then
			self.buttons.oil.texture:SetTexture(3528422)
			self.buttons.oiloh.texture:SetTexture(3528422)
		elseif lastWeaponEnchantItem == 171436 then
			self.buttons.oil.texture:SetTexture(3528424)
			self.buttons.oiloh.texture:SetTexture(3528424)
		elseif lastWeaponEnchantItem == 171439 then
			self.buttons.oil.texture:SetTexture(3528423)
			self.buttons.oiloh.texture:SetTexture(3528423)
		elseif lastWeaponEnchantItem == 171438 then
			self.buttons.oil.texture:SetTexture(3528425)
			self.buttons.oiloh.texture:SetTexture(3528425)
		elseif lastWeaponEnchantItem == -33757 then
			self.buttons.oil.texture:SetTexture(462329)
			self.buttons.oiloh.texture:SetTexture(135814)
		elseif lastWeaponEnchantItem == -318038 then
			self.buttons.oil.texture:SetTexture(135814)
			self.buttons.oiloh.texture:SetTexture(135814)
		end

		VMRT.RaidCheck.WeaponEnch[ExRT.SDB.charKey] = lastWeaponEnchantItem

		if lastWeaponEnchantItem then
			local oilCount = GetItemCount(lastWeaponEnchantItem,false,true)
			self.buttons.oil.count:SetText(oilCount)
			self.buttons.oiloh.count:SetText(oilCount)
			if type(lastWeaponEnchantItem) == 'number' and lastWeaponEnchantItem < 0 then	--for spell enchants
				if not InCombatLockdown() then
					local spellName = GetSpellInfo(-lastWeaponEnchantItem)
					self.buttons.oil.click:SetAttribute("spell", spellName)
					self.buttons.oil.click:Show()
					self.buttons.oil.click.IsON = true
					self.buttons.oil.click:SetAttribute("type", "spell")
					local spellName = GetSpellInfo(lastWeaponEnchantItem == -33757 and 318038 or -lastWeaponEnchantItem)
					self.buttons.oiloh.click:SetAttribute("spell", spellName)
					self.buttons.oiloh.click:Show()
					self.buttons.oiloh.click.IsON = true
					self.buttons.oiloh.click:SetAttribute("type", "spell")
				end
				self.buttons.oil.count:SetText("")
				self.buttons.oiloh.count:SetText("")
			elseif oilCount and oilCount > 0 then
				if not InCombatLockdown() then
					local itemName = GetItemInfo(lastWeaponEnchantItem)
					if itemName then
						self.buttons.oil.click:SetAttribute("item", itemName)
						self.buttons.oil.click:Show()
						self.buttons.oil.click.IsON = true
						if 
							mainHandExpiration and 
							(lastWeaponEnchantItem == 171285 or lastWeaponEnchantItem == 171286) and
							offhandItemID and not offhandCanBeEnchanted
						then
							self.buttons.oil.click:SetAttribute("type", "cancelaura")
						else
							self.buttons.oil.click:SetAttribute("type", "item")
						end
						self.buttons.oiloh.click:SetAttribute("item", itemName)
						self.buttons.oiloh.click:Show()
						self.buttons.oiloh.click.IsON = true
					else
						self.buttons.oil.click:Hide()
						self.buttons.oil.click.IsON = false
						self.buttons.oiloh.click:Hide()
						self.buttons.oiloh.click.IsON = false
					end
				end
			else
				if not InCombatLockdown() then
					self.buttons.oil.click:Hide()
					self.buttons.oil.click.IsON = false
					self.buttons.oiloh.click:Hide()
					self.buttons.oiloh.click.IsON = false
				end
			end

			if LCG then
				if oilCount and oilCount > 0 and (not hasMainHandEnchant or (mainHandExpiration and mainHandExpiration <= 300000)) then
					LCG.PixelGlow_Start(self.buttons.oil)
				else
					LCG.PixelGlow_Stop(self.buttons.oil)
				end
				if oilCount and oilCount > 0 and (not hasOffHandEnchant or (offHandExpiration and offHandExpiration <= 300000)) then
					LCG.PixelGlow_Start(self.buttons.oiloh)
				else
					LCG.PixelGlow_Stop(self.buttons.oiloh)
				end
			end
		end

		local runeCount = GetItemCount(181468,false,true)
		if runeCount and runeCount > 0 then
			self.buttons.rune.count:SetFormattedText("%d",runeCount)
			if not InCombatLockdown() then
				local itemName = GetItemInfo(181468)
				if itemName then
					self.buttons.rune.click:SetAttribute("macrotext1", format("/stopmacro [combat]\n/use %s", itemName))
					self.buttons.rune.click:Show()
					self.buttons.rune.click.IsON = true
				else
					self.buttons.rune.click:Hide()
					self.buttons.rune.click.IsON = false
				end
			end
		else
			self.buttons.rune.count:SetText("0")
			if not InCombatLockdown() then
				self.buttons.rune.click:Hide()
				self.buttons.rune.click.IsON = false
			end
		end

		if LCG then
			if runeCount and runeCount > 0 and not isRune then
				LCG.PixelGlow_Start(self.buttons.rune)
			else
				LCG.PixelGlow_Stop(self.buttons.rune)
			end
		end


		local isClassShamanEnh
		if select(2,UnitClass("player")) == "SHAMAN" and GetSpecialization() == 2 then
			isClassShamanEnh = true
		end

		if isClassShamanEnh then
			if isShamanBuff then
				self.buttons.class.texture:SetDesaturated(false)
				self.buttons.class.statustexture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
				self.buttons.class.timeleft:SetText(isShamanBuff)
			else
				self.buttons.class.texture:SetDesaturated(true)
			end
			if not InCombatLockdown() then
				local spellName = GetSpellInfo(192106)
				self.buttons.class.click:SetAttribute("type", "spell")
				self.buttons.class.click:SetAttribute("spell", spellName)
				self.buttons.class.click:Show()
				self.buttons.class.click.IsON = true
			end
		end
		if not InCombatLockdown() then
			if isClassShamanEnh then
				self.buttons.class.texture:SetTexture(136051)
				self.buttons.class:Show()
				totalButtons = totalButtons + 1
				self.buttons.class:ClearAllPoints()
				if isWarlockInRaid then
					self.buttons.class:SetPoint("LEFT",self.buttons.hs,"RIGHT",0,0)
				else
					self.buttons.class:SetPoint("LEFT",self.buttons.rune,"RIGHT",0,0)
				end
			else
				self.buttons.class:Hide()
				self.buttons.class.click:Hide()
				self.buttons.class.click.IsON = false
			end
		end


		if not InCombatLockdown() then
			self:SetWidth(consumables_size*totalButtons)
		end
	end

	function module.consumables:Repos(isRL)
		if InCombatLockdown() then
			return
		end
		if isRL then
			self:SetParent(self.rlpointer)
			self:ClearAllPoints()
			self:SetPoint("CENTER",self.rlpointer,"CENTER",0,0)

			self.rlpointer:Show()
			self.close:Show()

			self.isRLpos = true
		elseif self.isRLpos then
			local parent
			if isElvUIFix then
				parent = ReadyCheckFrame
			else
				parent = ReadyCheckListenerFrame
			end
			self:SetParent(parent)
			self:ClearAllPoints()
			self:SetPoint("BOTTOM",parent,"TOP",0,5)

			self.isRLpos = false
		end
	end

	function module.consumables:OnHide()
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
		if self.cancelDelay then
			self.cancelDelay:Cancel()
			self.cancelDelay = nil
		end
	end

	module.consumables:SetScript("OnEvent",function(self,event,arg1,arg2)
		if event == "READY_CHECK" then
			self:Update()
			self:RegisterEvent("UNIT_AURA")
			self:RegisterEvent("UNIT_INVENTORY_CHANGED")
			if self.cancelDelay then
				self.cancelDelay:Cancel()
			end
			self.cancelDelay = C_Timer.NewTimer(arg2 or 40,function()
				self:UnregisterEvent("UNIT_AURA")
				self:UnregisterEvent("UNIT_INVENTORY_CHANGED")

				if self.isRLpos then
					self.rlpointer:Hide()
				end
			end)
			if arg1 and UnitIsUnit(arg1,"player") and not VMRT.RaidCheck.ConsDisableForStarter then
				self:Repos(true)
			else
				self:Repos()
			end
		elseif event == "READY_CHECK_FINISHED" then
			module.consumables:OnHide()

			if self.isRLpos then
				self.rlpointer:Hide()
			end
		elseif event == "UNIT_AURA" then
			if arg1 == "player" then
				self:Update()
			end
		elseif event == "UNIT_INVENTORY_CHANGED" then
			if arg1 == "player" then
				C_Timer.After(.2,function()
					self:Update()
				end)
			end
		end
	end)

	module.consumables:SetScript("OnHide",function(self)
		module.consumables:OnHide()

		if not InCombatLockdown() and self.close:IsShown() then
			self.close:Hide()
		end
	end)

	module.consumables.Test = function(isRL)
		--module.consumables:SetParent(UIParent)
		--module.consumables:ClearAllPoints()
		--module.consumables:SetPoint("CENTER")
		module.consumables:GetScript("OnEvent")(module.consumables,"READY_CHECK",isRL and UnitName'player' or "")
	end
	--/run GMRT.A.RaidCheck.consumables.Test()
end