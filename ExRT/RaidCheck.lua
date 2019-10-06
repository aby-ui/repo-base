local GlobalAddonName, ExRT = ...

if ExRT.isClassic then
	return
end

local IsEncounterInProgress, GetTime, CombatLogGetCurrentEventInfo = IsEncounterInProgress, GetTime, CombatLogGetCurrentEventInfo

local VExRT = nil

local module = ExRT.mod:New("RaidCheck",ExRT.L.raidcheck,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.isEncounter = nil
module.db.tableFood = {
--Haste		Mastery		Crit		Versa		Int		Str 		Agi		Stam		Stam		Special
						[185736]=50,
[257413]=50,	[257418]=50,	[257408]=50,	[257422]=50,	[259449]=75,	[259452]=75,	[259448]=75,	[259453]=75,	[288074]=50,
[257415]=75,	[257420]=75,	[257410]=75,	[257424]=75,	[259455]=100,	[259456]=100,	[259454]=100,	[259457]=75,	[288075]=75,
								[290468]=75,	[290469]=75,	[290467]=75,	--85 actually
								[285719]=50,	[285720]=50,	[285721]=50,	[288074]=50,	[288075]=75,	[286171]=75,
								[297117]=130,	[297118]=130,	[297116]=130,
[297034]=100,	[297035]=100,	[297039]=100,	[297037]=100,							[297119]=100,	[297040]=100,
}
module.db.StaminaFood = {[201638]=true,[259457]=true,[288075]=true,[288074]=true,[297119]=true,[297040]=true}

module.db.tableFood_headers = {0,50,75,100,130}
module.db.tableFlask =  {
	--Stamina,	Int,		Agi,		Str 
	[251838]=238,	[251837]=238,	[251836]=238,	[251839]=238,
	[298839]=360,	[298837]=360,	[298836]=360,	[298841]=360,	
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
module.db.potionList = {}
module.db.hsList = {}
module.db.tableFoodInProgress = nil
module.db.RaidCheckReadyCheckHide = nil
module.db.RaidCheckReadyCheckTime = nil
module.db.RaidCheckReadyCheckTable = {}
module.db.RaidCheckReadyPPLNum = 0
module.db.RaidCheckReadyCheckHideSchedule = nil

module.db.tableRunes = {[224001]=15,[270058]=60}

module.db.minFoodLevelToActual = {
	[100] = 100,
	[125] = 130,
}


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
		vruneName = "^"..kjrunename:match("^(.-):")
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
				else
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
	
	PublicResults(vruneName:gsub("%^",""),checkType)
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
			module:RegisterEvents('READY_CHECK')
		else
			VExRT.RaidCheck.ReadyCheck = nil
			if not VExRT.RaidCheck.ReadyCheckFrame then
				module:UnregisterEvents('READY_CHECK')
			end
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
			module:RegisterEvents('READY_CHECK','READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			VExRT.RaidCheck.ReadyCheckFrame = true
		else
			module:UnregisterEvents('READY_CHECK_FINISHED','READY_CHECK_CONFIRM')
			if not VExRT.RaidCheck.ReadyCheck then
				module:UnregisterEvents('READY_CHECK')
			end
			VExRT.RaidCheck.ReadyCheckFrame = nil
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
		for i=2,25 do
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
	if VExRT.RaidCheck.ReadyCheckFrame and module.db.RaidCheckReadyCheckHide then
		module.db.RaidCheckReadyCheckHide = module.db.RaidCheckReadyCheckHide - elapsed
		if module.db.RaidCheckReadyCheckHide < 2 and not module.frame.anim:IsPlaying() then
			module.frame.anim:Play()
		end
		if module.db.RaidCheckReadyCheckHide < 0 then
			module.db.RaidCheckReadyCheckHide = nil
		end
	end
	if VExRT.RaidCheck.ReadyCheckFrame and module.frame:IsShown() then
		local h = ""
		local ctime_ = module.db.RaidCheckReadyCheckTime - GetTime()
		if ctime_ > 0 then 
			h = format(" (%d %s)",ctime_+1,L.raidcheckReadyCheckSec) 
		end
		module.frame.headText:SetText(L.raidcheckReadyCheck..h)
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
	end
end

module.frame = ELib:Template("ExRTDialogModernTemplate",UIParent)
module.frame:SetSize(140*2+20,18*13+40)
module.frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
module.frame:SetFrameStrata("TOOLTIP")
module.frame:EnableMouse(true)
module.frame:SetMovable(true)
module.frame:RegisterForDrag("LeftButton")
module.frame:SetScript("OnDragStart", function(self) 
	self:StartMoving()
end)
module.frame:SetScript("OnDragStop", function(self) 
	self:StopMovingOrSizing()
	VExRT.RaidCheck.ReadyCheckLeft = self:GetLeft()
	VExRT.RaidCheck.ReadyCheckTop = self:GetTop()
end)
module.frame:Hide()
--module.frame.headText = ExRT.lib.CreateText(module.frame,290,18,nil,15,-7,nil,nil,ExRT.F.defFont,14,L.raidcheckReadyCheck,nil,1,1,1,1)
module.frame.border = ExRT.lib.CreateShadow(module.frame,20)
module.frame.headText = module.frame.title

module.frame.anim = module.frame:CreateAnimationGroup()
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
	module.frame.anim:Stop()
end)

module.frame.u = {}
for i=1,40 do
	local line = CreateFrame("FRAME",nil,module.frame)
	module.frame.u[i] = line
	line:SetPoint("TOPLEFT", ((i-1)%2)*140+10, -floor((i-1)/2)*18-25)
	line:SetSize(140,18)

	line.t = ELib:Text(line,"raid"..i):Size(120,18):Point(20,0):Font(ExRT.F.defFont,12):Color():Shadow()
	line.icon = ELib:Icon(line,"Interface\\RaidFrame\\ReadyCheck-Waiting",18):Point(0,0)
end

local function RaidCheckReadyCheckReset(starter,isTest)
	table.wipe(module.db.RaidCheckReadyCheckTable)
	local j = 0
	local gMax = ExRT.F.GetRaidDiffMaxGroup()
	module.db.RaidCheckReadyPPLNum = 0
	module.frame:SetHeight(18*ceil(gMax*5/2)+30)
	for i=1,40 do
		local name,_,subgroup = GetRaidRosterInfo(i)
		if isTest then
			name = format("%s%d","raid",i)
			subgroup = i / 5
		end
		if name and subgroup <= gMax then 
			j = j + 1
			if j > 40 then break end
			module.frame.u[j].t:SetText(name)
			module.frame.u[j].t:SetTextColor(1,1,1,1)
			module.frame.u[j].icon.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Waiting")
			module.frame.u[j]:Show()

			module.db.RaidCheckReadyPPLNum = module.db.RaidCheckReadyPPLNum + 1
			module.db.RaidCheckReadyCheckTable[ExRT.F.delUnitNameServer(name)] = j
		end
	end
	for i=(j+1),40 do
		module.frame.u[i]:Hide()
	end
	module.frame.anim:Stop()
	module.frame:SetAlpha(1)
	module.frame:Show()
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.RaidCheck = VExRT.RaidCheck or {}
	
	VExRT.RaidCheck.FlaskExp = VExRT.RaidCheck.FlaskExp or 1
	
	if VExRT.Addon.Version < 3930 then
		VExRT.RaidCheck.BuffsCheck = true
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
	if VExRT.RaidCheck.ReadyCheck or VExRT.RaidCheck.ReadyCheckFrame then
		module:RegisterEvents('READY_CHECK')	
	end
	if VExRT.RaidCheck.PotionCheck then
		--module:RegisterEvents('COMBAT_LOG_EVENT_UNFILTERED')
	end
		
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
		if not (isTest == "TEST") then isTest = nil end
		if VExRT.RaidCheck.ReadyCheck and not isTest then
			--[[
			local plus = VExRT.RaidCheck.SendSelf and 1 or 0
			GetFood(2+plus)
			GetFlask(2+plus)
			if VExRT.RaidCheck.RunesCheck then
				GetRunes(2+plus)
			end
			]]
			PrepareDataToChat(VExRT.RaidCheck.SendSelf)
		end
		if VExRT.RaidCheck.ReadyCheckFrame then
			module.db.RaidCheckReadyCheckHide = nil
			module.db.RaidCheckReadyCheckTime = GetTime() + (timer or 35)
			ExRT.F.CancelTimer(module.db.RaidCheckReadyCheckHideSchedule)
			module.db.RaidCheckReadyCheckHideSchedule = ExRT.F.ScheduleTimer(ScheduledReadyCheckFinish, timer or 35)
			RaidCheckReadyCheckReset(starter,isTest)
			module.main:READY_CHECK_CONFIRM(ExRT.F.delUnitNameServer(starter),true,isTest)
		end
	end
end

function module.main:READY_CHECK_FINISHED()
	if not module.db.RaidCheckReadyCheckHide then
		module.db.RaidCheckReadyCheckHide = VExRT.RaidCheck.ReadyCheckFrameTimerFade
	end
end

function module.main:READY_CHECK_CONFIRM(unit,response,isTest)
	if not (isTest == "TEST") then unit = UnitName(unit) isTest = nil end
	if unit and module.db.RaidCheckReadyCheckTable[unit] then
		local foodBuff = nil
		local flaskBuff = nil
		for i=1,40 do
			local name,_,_,_,_,_,_,_,_,spellId = UnitAura(unit, i,"HELPFUL")
			if not spellId then
				break
			elseif module.db.tableFood[spellId] then
				foodBuff = true
			elseif module.db.tableFlask[spellId] then
				flaskBuff = true
			elseif name and module.db.tableFoodInProgress == name then
				foodBuff = true
			end
		end
		if isTest then
			if math.random(1,2) == 1 then foodBuff = nil flaskBuff = nil else foodBuff = true flaskBuff = true end
		end
		if not foodBuff or not flaskBuff then
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]].t:SetTextColor(1,0.5,0.5,1)
		end
		if response == true then
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]].icon.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
		else
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]].icon.texture:SetTexture("Interface\\RaidFrame\\ReadyCheck-NotReady")
		end
		if foodBuff and flaskBuff and response then
			module.frame.u[module.db.RaidCheckReadyCheckTable[unit]]:Hide()
		end

		module.db.RaidCheckReadyPPLNum = module.db.RaidCheckReadyPPLNum - 1
		if module.db.RaidCheckReadyPPLNum <= 0 then
			module.db.RaidCheckReadyCheckHide = VExRT.RaidCheck.ReadyCheckFrameTimerFade
		end
		module.db.RaidCheckReadyCheckTable[unit] = nil
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

function module:addonMessage(sender, prefix, type, ver)
	if prefix == "raidcheck" then
		if sender then
			ver = max(tonumber(ver or "0") or 0,3910)	--set min ver to 3910
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
		if VExRT.RaidCheck.OnAttack then
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