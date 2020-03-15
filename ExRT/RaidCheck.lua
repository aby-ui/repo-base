local GlobalAddonName, ExRT = ...

local IsEncounterInProgress, GetTime, CombatLogGetCurrentEventInfo = IsEncounterInProgress, GetTime, CombatLogGetCurrentEventInfo

local VExRT = nil

local module = ExRT.mod:New("RaidCheck",ExRT.L.raidcheck,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.isEncounter = nil
module.db.tableFood = not ExRT.isClassic and {
--Haste		Mastery		Crit		Versa		Int		Str 		Agi		Stam		Stam		Special
						[185736]=50,
[257413]=50,	[257418]=50,	[257408]=50,	[257422]=50,	[259449]=75,	[259452]=75,	[259448]=75,	[259453]=75,	[288074]=50,
[257415]=75,	[257420]=75,	[257410]=75,	[257424]=75,	[259455]=100,	[259456]=100,	[259454]=100,	[259457]=75,	[288075]=75,
								[290468]=75,	[290469]=75,	[290467]=75,	--85 actually
								[285719]=50,	[285720]=50,	[285721]=50,	[288074]=50,	[288075]=75,	[286171]=75,
								[297117]=130,	[297118]=130,	[297116]=130,
[297034]=100,	[297035]=100,	[297039]=100,	[297037]=100,							[297119]=100,	[297040]=100,
} or {
	[18192]=true,	[24799]=true,	[18194]=true,	[22730]=true,	[25661]=true,	[18141]=true,	[18125]=true,
	[22790]=true,	[22789]=true,	[25804]=true,
	[18222]=true,
}
module.db.StaminaFood = {[201638]=true,[259457]=true,[288075]=true,[288074]=true,[297119]=true,[297040]=true}

module.db.tableFood_headers = {0,50,75,100,130}
module.db.tableFlask =  not ExRT.isClassic and {
	--Stamina,	Int,		Agi,		Str 
	[251838]=238,	[251837]=238,	[251836]=238,	[251839]=238,
	[298839]=360,	[298837]=360,	[298836]=360,	[298841]=360,	
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
}
module.db.tableFlask_headers = {0,238,360}
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
}
module.db.hsSpells = {
	[6262] = true,
	[105708] = true,
	[156438] = true,
	[188016] = true,
	--[188018] = true,
	[250870] = true,
	[301308] = true,
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
}

module.db.classicBuffs = {
	{"druid","Druid",136078,{[21850]=7,[21849]=6,[1126]=1,[5232]=2,[5234]=4,[6756]=3,[8907]=5,[9884]=6,[9885]=7,}},	--Gift of the Wild
	{"int","Int",135932,{[10157]=5,[10156]=4,[1461]=3,[1460]=2,[1459]=1,[23028]=5}},	--Arcane Intellect
	{"ap","AP",132333,{[6673]=1,[5242]=2,[6192]=3,[11549]=4,[11550]=5,[11551]=6,[25289]=7,}},	--Battle Shout
	{"spirit","Spirit",135946,{[27681]=4,[14752]=1,[14818]=2,[14819]=3,[27841]=4,}},	--Prayer of Spirit
	{"armor","Armor",135926,{[588]=1,[7128]=2,[602]=3,[1006]=4,[10951]=5,[10952]=6,}},	--Inner Fire
	{"shadow","Shadow",136121,{[10958]=3,[976]=1,[10957]=2,[27683]=3,}},	--Shadow Protection
	{"stamina","Stamina",135987,{[1243]=1,[21562]=5,[21564]=6,[1244]=2,[1245]=3,[2791]=4,[10937]=5,[10938]=6,}},	--Power Word: Fortitude
}
if ExRT.isClassic and UnitFactionGroup("player") == "Alliance" then
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bom","BoM",135908,{[19740]=1,[19834]=2,[19835]=3,[19836]=4,[19837]=5,[19838]=6,[25291]=7,[25782]=6,[25916]=7,}}	--Blessing of Might
	module.db.classicBuffs[#module.db.classicBuffs+1] = {"bow","BoW",135970,{[19742]=1,[19850]=2,[19852]=3,[19853]=4,[19854]=5,[25290]=6,[25894]=5,[25918]=6,}}	--Blessing of Wisdom	
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

module.db.tableRunes = {[224001]=15,[270058]=60,[317065]=60,}

module.db.minFoodLevelToActual = {
	[100] = 100,
	[125] = 130,
}

module.db.durability = {}

local IsSendFoodByMe,IsSendFlaskByMe,IsSendRunesByMe,IsSendBuffsByMe = nil

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
		for _,stats in ipairs({0,15,60}) do
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
		f[15] = f[15] or {}
		local result = format("|cff00ff00%s (%d):|r ",L.RaidCheckNoRunes,#f[0]+#f[15])
		for i=1,#f[0] do
			result = result .. f[0][i]
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			elseif i ~= #f[0] or #f[15] > 0 then
				result = result .. ", "
			end
		end
		for i=1,#f[15] do
			result = result .. f[15][i] .. "(15)"
			if #result > 230 then
				PublicResults(result,checkType)
				result = ""
			elseif i ~= #f[15] then
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
			if ((VExRT.RaidCheck.FoodMinLevel and statsNum < (module.db.minFoodLevelToActual[VExRT.RaidCheck.FoodMinLevel] or 375)) or (not VExRT.RaidCheck.FoodMinLevel and statsNum == 0)) and #data > 0 then
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
	
	local showExpFlasks_seconds = VExRT.RaidCheck.FlaskExp == 1 and 300 or VExRT.RaidCheck.FlaskExp == 2 and 600 or -1
	
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
						strings_list[#strings_list + 1] = format("%s%s%s",f[ flaskStats ][j][1] or "?", "("..(mins == 0 and "<1" or tostring(mins))..")", i < #module.db.tableFlask_headers and i > 1 and (not VExRT.RaidCheck.FlaskLQ) and " LQ" or "")
					elseif i < #module.db.tableFlask_headers and i > 1 and not VExRT.RaidCheck.FlaskLQ then
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
			elseif f[buffsListLen + k] > 0 and not f[-k] and UnitLevel'player' >= 120 then	--check for minor buffs (7%), but only in BfA actually
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

module.GetRunes = GetRunes
module.GetVRunes = GetVRunes
module.GetFood = GetFood
module.GetFlask = GetFlask
module.GetRaidBuffs = GetRaidBuffs

function module.options:Load()
	self:CreateTilte()

	self.food = ELib:Button(self,L.raidcheckfood):Size(230,20):Point(5,-30):OnClick(function() GetFood() end)
	self.food.txt = ELib:Text(self,"/rt food",10):Size(100,20):Point("LEFT",self.food,"RIGHT",5,0)
	
	self.foodToChat = ELib:Button(self,L.raidcheckfoodchat):Size(230,20):Point("LEFT",self.food,"RIGHT",71,0):OnClick(function() GetFood(1) end)
	self.foodToChat.txt = ELib:Text(self,"/rt foodchat",10):Size(100,20):Point("LEFT",self.foodToChat,"RIGHT",5,0)

	self.flask = ELib:Button(self,L.raidcheckflask):Size(230,20):Point(5,-55):OnClick(function() GetFlask() end)
	self.flask.txt = ELib:Text(self,"/rt flask",10):Size(100,20):Point("LEFT",self.flask,"RIGHT",5,0)
	
	self.flaskToChat = ELib:Button(self,L.raidcheckflaskchat):Size(230,20):Point("LEFT",self.flask,"RIGHT",71,0):OnClick(function() GetFlask(1) end)
	self.flaskToChat.txt = ELib:Text(self,"/rt flaskchat",10):Size(100,20):Point("LEFT",self.flaskToChat,"RIGHT",5,0)
	
	self.runes = ELib:Button(self,L.RaidCheckRunesCheck):Size(230,20):Point(5,-80):OnClick(function() GetRunes() end)
	self.runes.txt = ELib:Text(self,"/rt check r",10):Size(60,22):Point("LEFT",self.runes,"RIGHT",5,0)
	
	self.runesToChat = ELib:Button(self,L.RaidCheckRunesChat):Size(230,20):Point("LEFT",self.runes,"RIGHT",71,0):OnClick(function() GetRunes(1) end)
	self.runesToChat.txt = ELib:Text(self,"/rt check rc",10):Size(100,22):Point("LEFT",self.runesToChat,"RIGHT",5,0)

	self.vantusrunes = ELib:Button(self,L.RaidCheckVRunesCheck):Size(230,20):Point(5,-105):OnClick(function() GetVRunes() end)
	self.vantusrunes.txt = ELib:Text(self,"/rt check v",10):Size(60,22):Point("LEFT",self.vantusrunes,"RIGHT",5,0)
	
	self.vantusrunesToChat = ELib:Button(self,L.RaidCheckVRunesChat):Size(230,20):Point("LEFT",self.vantusrunes,"RIGHT",71,0):OnClick(function() GetVRunes(1) end)
	self.vantusrunesToChat.txt = ELib:Text(self,"/rt check vc",10):Size(100,22):Point("LEFT",self.vantusrunesToChat,"RIGHT",5,0)

	self.raidbuffs = ELib:Button(self,L.RaidCheckBuffs):Size(230,20):Point(5,-130):OnClick(function() GetRaidBuffs() end)
	self.raidbuffs.txt = ELib:Text(self,"/rt check b",10):Size(60,22):Point("LEFT",self.raidbuffs,"RIGHT",5,0)
	
	self.raidbuffsToChat = ELib:Button(self,L.RaidCheckBuffsToChat):Size(230,20):Point("LEFT",self.raidbuffs,"RIGHT",71,0):OnClick(function() GetRaidBuffs(1) end)
	self.raidbuffsToChat.txt = ELib:Text(self,"/rt check bc",10):Size(100,22):Point("LEFT",self.raidbuffsToChat,"RIGHT",5,0)

	self.level2optLine = CreateFrame("Frame",nil,self)
	self.level2optLine:SetPoint("TOPLEFT",0,-155)
	self.level2optLine:SetSize(1,1)	

	self.chkSlak = ELib:Check(self,L.raidcheckslak,VExRT.RaidCheck.ReadyCheck):Point("TOPLEFT",self.level2optLine,7,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.ReadyCheck = true
		else
			VExRT.RaidCheck.ReadyCheck = nil
		end
	end)
	
	self.chkOnAttack = ELib:Check(self,L.RaidCheckOnAttack,VExRT.RaidCheck.OnAttack):Point("TOPLEFT",self.chkSlak,"TOPLEFT",25,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.OnAttack = true
		else
			VExRT.RaidCheck.OnAttack = nil
		end
	end)
	
	self.chkSendSelf = ELib:Check(self,L.RaidCheckSendSelf,VExRT.RaidCheck.SendSelf):Point("TOPLEFT",self.chkOnAttack,"TOPLEFT",0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.SendSelf = true
		else
			VExRT.RaidCheck.SendSelf = nil
		end
	end)
	
	self.disableLFR = ELib:Check(self,L.RaidCheckDisableInLFR,VExRT.RaidCheck.disableLFR):Point("TOPLEFT",self.chkSendSelf,"TOPLEFT",0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.disableLFR = true
		else
			VExRT.RaidCheck.disableLFR = nil
		end
	end)
	
	self.chkRunes = ELib:Check(self,L.RaidCheckRunesEnable,VExRT.RaidCheck.RunesCheck):Point("TOPLEFT",self.level2optLine,7,-100):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.RunesCheck = true
		else
			VExRT.RaidCheck.RunesCheck = nil
		end
	end)
	
	self.chkBuffs = ELib:Check(self,L.RaidCheckBuffsEnable,VExRT.RaidCheck.BuffsCheck):Point("TOPLEFT",self.chkRunes,0,-25):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.BuffsCheck = true
		else
			VExRT.RaidCheck.BuffsCheck = nil
		end
	end)
	
	self.minFoodLevelText = ELib:Text(self,L.RaidCheckMinFoodLevel,11):Point("TOPLEFT",self.chkBuffs,"TOPLEFT",3,-23):Size(0,25)

	self.minFoodLevelAny = ELib:Radio(self,L.RaidCheckMinFoodLevelAny,not VExRT.RaidCheck.FoodMinLevel):Point("LEFT",self.minFoodLevelText,"RIGHT", 15, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFoodLevel100:SetChecked(false)
		module.options.minFoodLevel125:SetChecked(false)
		VExRT.RaidCheck.FoodMinLevel = nil
	end)

	
	self.minFoodLevel100 = ELib:Radio(self,module.db.minFoodLevelToActual[100],VExRT.RaidCheck.FoodMinLevel == 100):Point("LEFT",self.minFoodLevelAny,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFoodLevelAny:SetChecked(false)
		module.options.minFoodLevel125:SetChecked(false)
		VExRT.RaidCheck.FoodMinLevel = 100
	end)
	
	self.minFoodLevel125 = ELib:Radio(self,module.db.minFoodLevelToActual[125],VExRT.RaidCheck.FoodMinLevel == 125):Point("LEFT",self.minFoodLevel100,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFoodLevelAny:SetChecked(false)
		module.options.minFoodLevel100:SetChecked(false)
		VExRT.RaidCheck.FoodMinLevel = 125
	end)

	
	self.minFlaskExpText = ELib:Text(self,L.RaidCheckMinFlaskExp,11):Point("TOPLEFT",self.minFoodLevelText,"TOPLEFT",0,-22):Size(0,25)
	
	self.minFlaskExpNo = ELib:Radio(self,L.RaidCheckMinFlaskExpNo,VExRT.RaidCheck.FlaskExp == 0):Point("LEFT",self.minFlaskExpText,"RIGHT", 15, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFlaskExp5min:SetChecked(false)
		module.options.minFlaskExp10min:SetChecked(false)
		VExRT.RaidCheck.FlaskExp = 0
	end)
	
	self.minFlaskExp5min = ELib:Radio(self,"5 "..L.RaidCheckMinFlaskExpMin,VExRT.RaidCheck.FlaskExp == 1):Point("LEFT",self.minFlaskExpNo,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFlaskExpNo:SetChecked(false)
		module.options.minFlaskExp10min:SetChecked(false)
		VExRT.RaidCheck.FlaskExp = 1
	end)

	self.minFlaskExp10min = ELib:Radio(self,"10 "..L.RaidCheckMinFlaskExpMin,VExRT.RaidCheck.FlaskExp == 2):Point("LEFT",self.minFlaskExp5min,"RIGHT", 75, 0):OnClick(function(self) 
		self:SetChecked(true)
		module.options.minFlaskExpNo:SetChecked(false)
		module.options.minFlaskExp5min:SetChecked(false)
		VExRT.RaidCheck.FlaskExp = 2
	end)

	self.checkLQFlask = ELib:Check(self,L.RaidCheckLQFlask,not VExRT.RaidCheck.FlaskLQ):Point("TOPLEFT",self.level2optLine,7,-195):OnClick(function(self) 
		VExRT.RaidCheck.FlaskLQ = not VExRT.RaidCheck.FlaskLQ
	end)

	
	self.chkPotion = ELib:Check(self,L.raidcheckPotionCheck,VExRT.RaidCheck.PotionCheck):Point("TOPLEFT",self.level2optLine,7,-220):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.PotionCheck = true
			module.options.potionToChat:Enable()
			module.options.potion:Enable()
			module.options.hs:Enable()
			module.options.hsToChat:Enable()
		else
			VExRT.RaidCheck.PotionCheck = nil
			module.options.potionToChat:Disable()
			module.options.potion:Disable()
			module.options.hs:Disable()
			module.options.hsToChat:Disable()
		end
	end)

	self.potion = ELib:Button(self,L.raidcheckPotionLastPull):Size(230,20):Point("TOPLEFT",self.chkPotion,"TOPLEFT",-2,-30):OnClick(function() GetPotion(2) end):Run(function(s,a) if a then s:Disable() end end,not VExRT.RaidCheck.PotionCheck)
	self.potion.txt = ELib:Text(self,"/rt potion",11):Size(100,20):Point("LEFT",self.potion,"RIGHT",5,0)

	self.potionToChat = ELib:Button(self,L.raidcheckPotionLastPullToChat):Size(230,20):Point("LEFT",self.potion,"RIGHT",71,0):OnClick(function() GetPotion(1) end):Run(function(s,a) if a then s:Disable() end end,not VExRT.RaidCheck.PotionCheck)
	self.potionToChat.txt = ELib:Text(self,"/rt potionchat",11):Size(100,20):Point("LEFT",self.potionToChat,"RIGHT",5,0)

	self.hs = ELib:Button(self,L.raidcheckHSLastPull):Size(230,20):Point("TOPLEFT",self.potion,"TOPLEFT",0,-25):OnClick(function() GetHs(2) end):Run(function(s,a) if a then s:Disable() end end,not VExRT.RaidCheck.PotionCheck)
	
	self.hsToChat = ELib:Button(self,L.raidcheckHSLastPullToChat):Size(230,20):Point("LEFT",self.hs,"RIGHT",71,0):OnClick(function() GetHs(1) end):Run(function(s,a) if a then s:Disable() end end,not VExRT.RaidCheck.PotionCheck)
	
	self.optReadyCheckFrame = CreateFrame("Frame",nil,self)
	self.optReadyCheckFrame:SetSize(650,125)
	self.optReadyCheckFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",edgeFile = ExRT.F.defBorder,tile = false,edgeSize = 8})
	self.optReadyCheckFrame:SetBackdropColor(0,0,0,0.3)
	self.optReadyCheckFrame:SetBackdropBorderColor(.24,.25,.30,0)
	ELib:Border(self.optReadyCheckFrame,2,.24,.25,.30,1)
	self.optReadyCheckFrame:SetPoint("TOP",0,-470)

	self.optReadyCheckFrameHeader = ELib:Text(self.optReadyCheckFrame,L.raidcheckReadyCheck):Size(550,20):Point("BOTTOMLEFT",self.optReadyCheckFrame,"TOPLEFT",10,1):Bottom()

	self.chkReadyCheckFrameEnable = ELib:Check(self.optReadyCheckFrame,L.senable,VExRT.RaidCheck.ReadyCheckFrame):Point(15,-10):OnClick(function(self) 
		if self:GetChecked() then
			module:RegisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			VExRT.RaidCheck.ReadyCheckFrame = true
		else
			module:UnregisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			VExRT.RaidCheck.ReadyCheckFrame = nil
		end
	end)

	self.chkReadyCheckFrameEnableRL = ELib:Check(self.optReadyCheckFrame,L.RaidCheckOnlyRL,VExRT.RaidCheck.ReadyCheckFrameOnlyRL):Point("TOPLEFT",self.chkReadyCheckFrameEnable,120,0):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.RaidCheck.ReadyCheckFrameOnlyRL = true
		else
			VExRT.RaidCheck.ReadyCheckFrameOnlyRL = nil
		end
	end)

	self.chkReadyCheckFrameSliderScale = ELib:Slider(self.optReadyCheckFrame,L.raidcheckReadyCheckScale):Size(250):Point(25,-50):Range(5,200):SetTo(VExRT.RaidCheck.ReadyCheckFrameScale or 100):OnChange(function(self,event) 
		event = event - event%1
		VExRT.RaidCheck.ReadyCheckFrameScale = event
		ExRT.F.SetScaleFix(module.frame,event/100)
		self.tooltipText = event
		self:tooltipReload(self)
	end)

	self.chkReadyCheckFrameButTest = ELib:Button(self.optReadyCheckFrame,L.raidcheckReadyCheckTest):Size(280,22):Point(310,-10):OnClick(function(self) 
		module.main:READY_CHECK("raid1",35,"TEST")
		for i=2,30 do
			local y = math.random(1,30000)
			local r = math.random(1,2)
			ExRT.F.ScheduleTimer(function() module.main:READY_CHECK_CONFIRM("raid"..i,r==1,"TEST") end, y/1000)
		end
	end)

	self.chkReadyCheckFrameHtmlTimer = ELib:Text(self.optReadyCheckFrame,L.raidcheckReadyCheckTimerTooltip,11):Size(200,24):Point(310,-50)

	self.chkReadyCheckFrameEditBoxTimer = ELib:Edit(self.optReadyCheckFrame,6,true):Size(50,20):Point(515,-50):Text(VExRT.RaidCheck.ReadyCheckFrameTimerFade or "4"):OnChange(function(self)
		VExRT.RaidCheck.ReadyCheckFrameTimerFade = tonumber(self:GetText()) or 4
		if VExRT.RaidCheck.ReadyCheckFrameTimerFade < 2.5 then VExRT.RaidCheck.ReadyCheckFrameTimerFade = 2.5 end
	end) 
	
	self.htmlReadyCheck1 = ELib:Text(self.optReadyCheckFrame,L.RaidCheckReadyCheckHelp,12):Size(583,100):Point(10,-90):Top()


	if ExRT.isClassic then
		self.food:Hide()
		self.food.txt:Hide()
		self.foodToChat:Hide()
		self.foodToChat.txt:Hide()
		self.flask:Hide()
		self.flask.txt:Hide()
		self.flaskToChat:Hide()
		self.flaskToChat.txt:Hide()
		self.runes:Hide()
		self.runes.txt:Hide()
		self.runesToChat:Hide()
		self.runesToChat.txt:Hide()
		self.vantusrunes:Hide()
		self.vantusrunes.txt:Hide()
		self.vantusrunesToChat:Hide()
		self.vantusrunesToChat.txt:Hide()
		self.raidbuffs:Hide()
		self.raidbuffs.txt:Hide()
		self.raidbuffsToChat:Hide()
		self.raidbuffsToChat.txt:Hide()
		self.chkSlak:Hide()
		self.chkOnAttack:Hide()
		self.chkSendSelf:Hide()
		self.disableLFR:Hide()
		self.chkRunes:Hide()
		self.chkBuffs:Hide()
		self.minFoodLevelText:Hide()
		self.minFoodLevelAny:Hide()
		self.minFoodLevel100:Hide()
		self.minFoodLevel125:Hide()
		self.minFlaskExpText:Hide()
		self.minFlaskExpNo:Hide()
		self.minFlaskExp5min:Hide()
		self.minFlaskExp10min:Hide()
		self.checkLQFlask:Hide()
		self.chkPotion:Hide()
		self.potion:Hide()
		self.potion.txt:Hide()
		self.potionToChat:Hide()
		self.potionToChat.txt:Hide()
		self.hs:Hide()
		self.hsToChat:Hide()

		self.optReadyCheckFrame:SetPoint("TOP",0,-50)
	end

	self:SetScript("OnShow",nil)
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

function module:timer(elapsed)
	if VExRT.RaidCheck.PotionCheck then
		if not module.db.isEncounter and IsEncounterInProgress() then
			module.db.isEncounter = true

			ExRT.F.ScheduleTimer(CheckPotionsOnPull,1.5)
			
			table.wipe(module.db.hsList)
			local gMax = ExRT.F.GetRaidDiffMaxGroup()
			for j=1,40 do
				local name,_,subgroup = GetRaidRosterInfo(j)
				if name and subgroup <= gMax then
					module.db.hsList[name] = 0
				end
			end
			
			module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		elseif module.db.isEncounter and not IsEncounterInProgress() then
			module.db.isEncounter = nil
			
			module:UnregisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
		end
	end
	if VExRT.RaidCheck.ReadyCheckFrame and module.frame:IsShown() and module.db.RaidCheckReadyCheckTime then
		local h = ""
		local ctime_ = module.db.RaidCheckReadyCheckTime - GetTime()
		if ctime_ > 0 then 
			h = format(" (%d %s)",ctime_+1,L.raidcheckReadyCheckSec) 
		end
		module.frame.headText:SetText("ExRT: "..L.raidcheckReadyCheck..h)
	end
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
	elseif arg == "potion" and VExRT.RaidCheck.PotionCheck then
		GetPotion(2)
	elseif arg == "potionchat" and VExRT.RaidCheck.PotionCheck then
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

module.frame = ELib:Template("ExRTDialogModernTemplate",UIParent)
module.frame:SetSize(430+(ExRT.isClassic and 30*RCW_liveToClassicDiff or 0),100)
module.frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
module.frame:SetFrameStrata("TOOLTIP")
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetClampedToScreen(true)
module.frame:SetScript("OnDragStart", function(self) 
	self:StartMoving()
end)
module.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing()
	VExRT.RaidCheck.ReadyCheckLeft = self:GetLeft()
	VExRT.RaidCheck.ReadyCheckTop = self:GetTop()
end)
module.frame:SetScript("OnMouseDown", function(self,button) 
	if button == "RightButton" then
		self:Hide()
	end
end)
module.frame:Hide()

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
		if VExRT.RaidCheck.RCW_Mini and not button.isMinimized then
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

			VExRT.RaidCheck.RCW_Mini = false
		else
			module.frame:SetMinimized()

			VExRT.RaidCheck.RCW_Mini = true
		end
	end)

	
	button.NormalTexture = button:CreateTexture(nil,"ARTWORK")
	button.NormalTexture:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
	button.NormalTexture:SetPoint("TOPLEFT")
	button.NormalTexture:SetPoint("BOTTOMRIGHT")
	button.NormalTexture:SetVertexColor(1,1,1,.7)
	button.NormalTexture:SetTexCoord(unpack(button.TC.up))
	button:SetNormalTexture(button.NormalTexture)
	
	button.HighlightTexture = button:CreateTexture(nil,"ARTWORK")
	button.HighlightTexture:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
	button.HighlightTexture:SetPoint("TOPLEFT")
	button.HighlightTexture:SetPoint("BOTTOMRIGHT")
	button.HighlightTexture:SetVertexColor(1,1,0,1)
	button.HighlightTexture:SetTexCoord(unpack(button.TC.up))	
	button:SetHighlightTexture(button.HighlightTexture)

	button.PushedTexture = button:CreateTexture(nil,"ARTWORK")
	button.PushedTexture:SetTexture("Interface\\AddOns\\ExRT\\media\\DiesalGUIcons16x256x128")
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
	icon.subIcon:SetTexture([[Interface\AddOns\ExRT\media\DiesalGUIcons16x256x128]])
	icon.subIcon:SetTexCoord(0.125,0.1875,0.5,0.625)
	icon.subIcon:SetVertexColor(1,0,0)
	icon.subIcon:Hide()

	return icon
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
		line:SetSize(420+(ExRT.isClassic and 30*RCW_liveToClassicDiff or 0),14)
	
		line.name = ELib:Text(line,"raid"..i):Size(130,12):Point("LEFT",20,0):Font(ExRT.F.defFont,12):Color():Shadow()
	
		line.icon = ELib:Icon(line,"Interface\\RaidFrame\\ReadyCheck-Waiting",14):Point("LEFT",0,0)
	
		for i,key in pairs(RCW_iconsList) do
			line[key.."pointer"] = CreateFrame("Frame",nil,line)
			line[key.."pointer"]:SetSize(RCW_iconsListWide[i] and 60 or 30,14)
	
			if i==1 then
				line[key.."pointer"]:SetPoint("CENTER",line.name,"RIGHT",15 - 5,0)
			else
				line[key.."pointer"]:SetPoint("CENTER",line[ RCW_iconsList[i-1].."pointer" ],"CENTER",30+(RCW_iconsListWide[i-1] and 15 or 0)+(RCW_iconsListWide[i] and 15 or 0),0)
			end
	
			line[key] = RCW_AddIcon(line,RCW_iconsListDebugIcons[i])
			line[key]:Point("CENTER",line[key.."pointer"],"CENTER",0,0)
	
			for j=2,4 do
				line[key..j] = RCW_AddIcon(line,RCW_iconsListDebugIcons[i])
				line[key..j]:Point("LEfT",line[key..((j-1) == 1 and "" or tostring(j-1))],"RIGHT",0,0)
				line[key..j]:Hide()
			end
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

	local delay = tonumber(VExRT.RaidCheck.ReadyCheckFrameTimerFade or "4") or 4
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
			count = count + 1
			local line = self.lines[count]
			if line then
				name = ExRT.F.delUnitNameServer(name)

				line.name:SetText(name)
				line.unit = unit
				line.unit_name = name
				line.name:SetTextColor(1,1,1,1)

				line.mini.name:SetText(name)
				line.mini.name:SetTextColor(1,1,1,1)

				local classColor = classColorsTable[class]
				local r,g,b = classColor and classColor.r or .7,classColor and classColor.g or .7,classColor and classColor.b or .7

				line.classLeft:SetGradientAlpha("HORIZONTAL",r,g,b,.4,r,g,b,0)

				line:Show()
				line.mini:Show()

				line.rc_status = 1
	
				RCW_UnitToLine[name] = line
				RCW_UnitToLine[line.unit] = line
			end
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
				for i=1,40 do
					local name,icon,_,_,duration,expirationTime,_,_,_,spellId,_,_,_,_,_,val1 = UnitAura(line.unit, i,"HELPFUL")
					if not spellId then
						break
					elseif module.db.tableFood[spellId] then
						local val = module.db.tableFood[spellId]
						
						line.food.texture:SetTexture(136000)
						if type(val)~="number" then
							val = ""
						elseif val >= 100 then
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
							if val >= 360 then
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
					elseif module.db.tableRunes[spellId] then
						local val = module.db.tableRunes[spellId]
						
						line.rune.texture:SetTexture((spellId == 270058 or spellId == 317065) and 840006 or icon)
						if val >= 60 then
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
	end
	self.frame:UpdateData()

	self.frame.headText:SetText("ExRT")

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
	VExRT = _G.VExRT
	VExRT.RaidCheck = VExRT.RaidCheck or {}
	
	VExRT.RaidCheck.FlaskExp = VExRT.RaidCheck.FlaskExp or 1
	
	if VExRT.Addon.Version < 3930 then
		VExRT.RaidCheck.BuffsCheck = true
	end
	if VExRT.Addon.Version < 4080 then
		if not VExRT.RaidCheck.ReadyCheckFrame then
			VExRT.RaidCheck.ReadyCheckFrame = true
			VExRT.RaidCheck.ReadyCheckFrameOnlyRL = true
		end
	end

	if VExRT.RaidCheck.ReadyCheckLeft and VExRT.RaidCheck.ReadyCheckTop then
		module.frame:ClearAllPoints()
		module.frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",VExRT.RaidCheck.ReadyCheckLeft,VExRT.RaidCheck.ReadyCheckTop) 
	end
	if VExRT.RaidCheck.ReadyCheckFrameScale then
		module.frame:SetScale(VExRT.RaidCheck.ReadyCheckFrameScale/100)
	end
	VExRT.RaidCheck.ReadyCheckFrameTimerFade = VExRT.RaidCheck.ReadyCheckFrameTimerFade or 4
	
	module.db.tableFoodInProgress = GetSpellInfo(104934)
	
	if VExRT.RaidCheck.ReadyCheckFrame then
		module:RegisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
	end
	if VExRT.RaidCheck.PotionCheck then
		--module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
	end
	module:RegisterEvents('READY_CHECK')
		
	module:RegisterSlash()
	module:RegisterTimer()
	module:RegisterAddonMessage()
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
	IsSendFoodByMe = nil
	IsSendFlaskByMe = nil
	IsSendRunesByMe = nil
	IsSendBuffsByMe = nil
end

local function PrepareDataToChat(toSelf)
	if toSelf then
		GetFood(3)
		GetFlask(3)
		if VExRT.RaidCheck.RunesCheck then
			GetRunes(3)
		end
		if VExRT.RaidCheck.BuffsCheck then
			GetRaidBuffs(3)
		end
	else
		if VExRT.RaidCheck.disableLFR then
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
		if VExRT.RaidCheck.RunesCheck then
			IsSendRunesByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","RUNES\t"..ExRT.V)
		end
		IsSendBuffsByMe = nil
		if VExRT.RaidCheck.BuffsCheck then
			IsSendBuffsByMe = true
			ExRT.F.ScheduleTimer(ExRT.F.SendExMsg, 0.1, "raidcheck","BUFFS\t"..ExRT.V)
		end
		ExRT.F.ScheduleTimer(SendDataToChat, 1)
	end
end

do
	local function ScheduledReadyCheckFinish()
		module.main:READY_CHECK_FINISHED()
	end
	function module.main:READY_CHECK(starter,timer,isTest)
		if not (isTest == "TEST") then 
			isTest = nil 
		end
		if VExRT.RaidCheck.ReadyCheck and not isTest and not ExRT.isClassic then
			PrepareDataToChat(VExRT.RaidCheck.SendSelf)
		end
		if (VExRT.RaidCheck.ReadyCheckFrame and (not VExRT.RaidCheck.ReadyCheckFrameOnlyRL or ExRT.F.IsPlayerRLorOfficer("player"))) or isTest then
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
			ExRT.F.SendExMsg("raidcheck","DUR\t"..ExRT.V.."\t"..format("%.2f",module:DurabilityCheck()))
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
	function module.main:COMBAT_LOG_EVENT_UNFILTERED()
		local _,event,_,_,sourceName,_,_,_,_,_,_,spellId = CombatLogGetCurrentEventInfo()
		if event == "SPELL_CAST_SUCCESS" and sourceName then
			if _db.hsSpells[spellId] then
				_db.hsList[sourceName] = _db.hsList[sourceName] and _db.hsList[sourceName] + 1 or 1
			elseif _db.tablePotion[spellId] then
				_db.potionList[sourceName] = _db.potionList[sourceName] and _db.potionList[sourceName] + 1 or 1
			end
		end
	end
end

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
				end
			end
		end
	end
end

local addonMsgFrame = CreateFrame'Frame'
local addonMsgAttack_AntiSpam = 0
addonMsgFrame:SetScript("OnEvent",function (self, event, ...)
	local prefix, message, channel, sender = ...
	if message and ((prefix == "BigWigs" and message:find("^T:BWPull")) or (prefix == "D4" and message:find("^PT"))) then
		if VExRT.RaidCheck.OnAttack and not ExRT.isClassic then
			local _time = GetTime()
			if (_time - addonMsgAttack_AntiSpam) < 2 then
				return
			end
			addonMsgAttack_AntiSpam = _time
		
			PrepareDataToChat(VExRT.RaidCheck.SendSelf)
		end
	end
end)
addonMsgFrame:RegisterEvent("CHAT_MSG_ADDON")