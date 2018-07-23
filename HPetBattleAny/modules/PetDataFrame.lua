-----####PetData.lua 4.0####
-------1.21增加部分的宠物信息
-------1.22+410.5.15.9.17/421.12.22
-------1.3增加切换按钮
-------1.31+754.2.12
-------1.4:更新了次HPetDate数据(5.1)
-------1.41:再次增加部分数据
-------1.42:通过点击敌对宠物头像，宠物信息可以直接高亮该宠物的种类
-------1.43:修复之前导致的错误品质切换错误
-------1.44修改了宠物信息的Update()用来配合其他开启方式
-------1.5:HPetBattleAny.GetBreedValue进行优化。让它直接接收petID
-------1.6:增加5.2新宠物数据
-------1.61:修复GetBreedValue的误差
-------1.63:修复1229的数据错误.
-------1.7:修改了判断宠物breed的方法.
-------1.71:增加BreedIDStyle,breeid的新描述方法根据HPetAllInfoFrameSwitch.value依旧原来的用途/更新PetDate
-------1.8:删除HPetDate,修改成HPetBattleAny
-------1.9:新的储存方法.减少占用内存.
-------1.91:增加petAState==nil的判断,避免错误
-------1.92:将提瑞斯法的蝙蝠(206)修改成唯一属性.
-------1.93:进一步优化petAState相关的内容
-------2.0:GetBreedIDbySystem因为某次修改出现了一个严重的BUG.已修复.
-------2.1:添加5.4的宠物信息(基础值部分完成100%)
-------2.2:添加5.4的宠物信息(补全"部分""可能值"),增加功能:未收集的数据也将显示在信息界面(红色高亮).
-------2.3:添加5.4的宠物信息(补全"部分""可能值")
-------3.0:简化PetDate,公母信息不再重复用数据~~~~~未完成
-------3.1:修改冬幕节新宠物的属性,增加负酒犬的数据
-------4.0:处理掉6.0下UIMenuButtonStretchTemplate有关的报错
-------4.1:又花了下数据，暂时不区分公母(>=13的breedid)
----2014/10:修改下Getdiff，尝试用整数计算，试试误差||结果修改了一系列，针对野外宠物20%血量减少，不再先做逆运算，再传递值，改为直接传递isWild信息。
----2014-10-29：修复了一个关于下拉菜单的报错,并增加部分数据
----2014-11-28：把petdate分离了出去，方便我更新。
----2014-12-09：好吧，date改成data了。以前怎么没发现。更新需要重新登陆游戏。
----2014-12-17：发现BattlePetBreedID插件的作者更新网站比插件细心+勤快，异常数据都不清理的。所以我增加了一个addon.fixPetDate,在里面留下需要调整的数据内容
----2015-6-26:HPetBattleAny.GetBaseState/GetPetAState增加fixdata的判断,上次更新的fixdate修改成fixdata(手已残)


--- Globals
local _
local _G = getfenv(0)
local hooksecurefunc, tinsert, pairs, wipe, split, match, gmatch, find = _G.hooksecurefunc, _G.table.insert, _G.pairs, _G.wipe, _G.string.split, _G.string.match, _G.string.gmatch, _G.string.find
local ipairs = _G.ipairs

local addonname,addon = ...
local L = addon.L

addon.fixPetData={
	[1515] = "8",	--磨石只有品质8，没有高攻?
	[489] = "4,8,10",	--这是个例子489奥妮克希亚的幼龙，品质是4,8,10
	[1486] = "4",	--大嘴鸟
	[115] = "3",	--陆行鲨
}
addon.fixPetBaseData={
	[115] = "11",
}
addon.NPCPetID={
	[1607]=true,
	[1608]=true,
	[1609]=true,
}
addon.PetIDByItemID={
	---四灵:
	["92799"]=1125,	--风

	["4401"]=39,
	["8485"]=40,
	["8486"]=41,
	["8487"]=43,
	["8488"]=45,
	["8489"]=46,
	["8490"]=44,
	["8491"]=42,
	["8492"]=50,
	["8494"]=49,
	["8495"]=51,
	["8496"]=47,
	["8497"]=72,
	["8498"]=59,
	["8499"]=58,
	["8500"]=68,
	["8501"]=67,
	["10360"]=75,
	["10361"]=77,
	["10392"]=78,
	["10393"]=55,
	["10394"]=70,
	["10398"]=83,
	["10822"]=56,
	["11023"]=52,
	["11026"]=65,
	["11027"]=64,
	["11825"]=85,
	["11826"]=86,
	["15996"]=95,
	["20769"]=114,
	["21277"]=116,
	["21301"]=119,
	["21305"]=120,
	["21308"]=118,
	["21309"]=117,
	["22235"]=122,
	["23083"]=128,
	["29363"]=136,
	["29364"]=137,
	["29901"]=138,
	["29902"]=139,
	["29903"]=140,
	["29904"]=141,
	["29953"]=142,
	["29956"]=143,
	["29957"]=144,
	["29958"]=145,
	["29960"]=146,
	["33154"]=162,
	["34535"]=57,
	["39896"]=194,
	["39898"]=197,
	["39899"]=195,
	["44721"]=196,
	["44794"]=200,
	["44822"]=74,
	["44965"]=204,
	["44970"]=205,
	["44971"]=206,
	["44973"]=207,
	["44974"]=209,
	["44980"]=210,
	["44982"]=213,
	["44984"]=212,
	["45002"]=215,
	["45606"]=218,
	["46398"]=224,
	["46707"]=166,
	["46820"]=229,
	["46821"]=229,
	["48112"]=232,
	["48114"]=233,
	["48116"]=234,
	["48118"]=235,
	["48120"]=236,
	["48122"]=237,
	["48124"]=238,
	["48126"]=239,
	["59597"]=261,
	["60216"]=262,
	["67274"]=267,
	["67275"]=292,
	["67282"]=293,
	["69239"]=306,
	["70908"]=319,
	["72068"]=311,
	["74610"]=341,
	["74611"]=342,
	["80008"]=848,
	["82774"]=845,
	["82775"]=846,
	["85220"]=650,
	["85222"]=1042,
	["85447"]=652,
	["87526"]=844,
	["88147"]=820,
	["88148"]=792,
	["89587"]=381,
	["89367"]=850,
	["89368"]=849,
	["90900"]=1039,
	["90902"]=1040,
	["91003"]=1061,
	["91031"]=1062,
	["94190"]=1185,
	["94191"]=1184,
	["94573"]=1205,
	["94574"]=1200,
	["94595"]=1201,
	["94932"]=1206,
	["94933"]=1207,
	["94934"]=1208,
	["94935"]=1209,
}

local function fixData(id)
	return addon.fixPetData[id]
end
local function fixBaseData(id)
	return addon.fixPetBaseData[id]
end
HPetBattleAny.GetBreedByID=function(breedID)
	local breedID = tonumber(breedID)
	return HPetBattleAny.GetBreeds[breedID>12 and breedID-10 or breedID]
end
HPetBattleAny.GetBreeds = {
	[3]={.5,.5,.5}, --1
	[4]={0,2,0}, --2
	[5]={0,0,2}, --3
	[6]={2,0,0}, --4
	[7]={.9,.9,0},--5
	[8]={0,.9,.9},--6
	[9]={.9,0,.9},--7
	[10]={.4,.9,.4},--8
	[11]={.4,.4,.9},--9
	[12]={.9,.4,.4}--10
}
HPetBattleAny.GetBreedNames = {
	[3]="B/B", --1
	[4]="P/P", --2
	[5]="S/S", --3
	[6]="H/H", --4
	[7]="H/P",--5
	[8]="P/S",--6
	[9]="H/S",--7
	[10]="P/B",--8
	[11]="S/B",--9
	[12]="H/B"--10
}
setmetatable(HPetBattleAny.GetBreedNames,{__index=function(self,key)return key and self[key>12 and key-10 or key] or "" end})

if BPBID_Arrays then	--使用BPB会提高内存占用
	addon.PetData = {}
	addon.PetBaseData = {}
	BPBID_Arrays.InitializeArrays()
	HPetBattleAny.GetBaseState = function(id) return fixBaseData(id) or BPBID_Arrays.BasePetStats[id] end
	HPetBattleAny.GetPetAState = function(id)
		if fixData(id) then
			return fixData(id)
		end
		if BPBID_Arrays.BreedsPerSpecies[id] then
			local lit=""
			for i,v in pairs(BPBID_Arrays.BreedsPerSpecies[id]) do
				if lit == "" then lit = tostring(v) else lit=lit..","..v end
			end
			return lit
		else
			return nil
		end
	end
else
	local GetBaseID = function(id) return fixBaseData(id) or (match(addon.PetData[id],"(%w+):.+") or tonumber(addon.PetData[id])) end
	local GetAState = function(id) return fixData(id) or match(addon.PetData[id],"%w+:(.+)") end
	HPetBattleAny.GetBaseState = function(id) return (addon.PetData[id] or addon.fixPetData[id]) and GetBaseID(id) and addon.PetBaseData[tonumber(GetBaseID(id))] end
	HPetBattleAny.GetPetAState = function(id) return (addon.PetData[id] or addon.fixPetBaseData[id]) and GetAState(id) end
end

HPetBattleAny.GetPetIDByItemID = function(id) return addon.PetIDByItemID[id] end

local HEALTH,POWER,SPEED = 1,2,3
local PetData = addon.PetData
local PetBaseData = addon.PetBaseData
local GetBaseState = HPetBattleAny.GetBaseState		---基础值
local GetPetAState = HPetBattleAny.GetPetAState		---可能值
local GetBaseSum = function(id) return GetBaseState(id)[1]+GetBaseState(id)[2]+GetBaseState(id)[3] end
HPetBattleAny.GetBaseSum = GetBaseSum

--------------------GetLimitPet                /hpe glp a,b,c
local MAXBASESUM = 28
local priMinPet=function(W,minV,t)
	for id,value in pairs(PetData) do
		local petAState = GetPetAState(id)
		local PetBaseData = GetBaseState(id)
		local name,_,pettype = C_PetJournal.GetPetInfoBySpeciesID(id)
		if name~="" and GetBaseSum(id) < MAXBASESUM and (not t or pettype == t) then
			local t={}
			for breedid in gmatch(petAState or "","(%w+)") do
				if tonumber(breedid) ~= 0 then
					local bstate = HPetBattleAny.GetBreedByID(breedid)
					if minV == bstate[W]+PetBaseData[W] and not (t[tonumber(breedid)<13 or tonumber(breedid)-10 and breedid] or t[tonumber(breedid)>12 and tonumber(breedid)-10 or breedid]) then
						HP_L(id,25,breedid,4)
						t[tonumber(breedid)] = true
					end
				end
			end
		end
	end
end
HPetBattleAny.GetLimitPet=function(v,l,t)
	v = tonumber(v) or 1
	l = (tonumber(l)~=0 and true)
	t = (tonumber(t)~=0 and t) and tonumber(t)
	local W = v or SPEED
	local minV,minid,minbr=nil,0,0
	for id,value in pairs(PetData) do
		local petAState = GetPetAState(id)
		local PetBaseData = GetBaseState(id)
		local name,_,pettype = C_PetJournal.GetPetInfoBySpeciesID(id)
		if name~="" and GetBaseSum(id) < MAXBASESUM and (not t or pettype == t) then
			for breedid in gmatch(petAState or "","(%w+)") do
				if tonumber(breedid) ~= 0 then
					local bstate = HPetBattleAny.GetBreedByID(breedid)
					if l then
						if not minV or minV > bstate[W]+PetBaseData[W] then
							minV = bstate[W]+PetBaseData[W]
							minid = id
							minbr = breedid
						end
					else
						if not minV or minV < bstate[W]+PetBaseData[W] then
							minV = bstate[W]+PetBaseData[W]
							minid = id
							minbr = breedid
						end
					end
				end
			end
		end
	end
	print(minV,minid,minbr)
	priMinPet(W,minV,t)
end
HPetBattleAny.GetEEPettest=function()
	for id,value in pairs(PetData) do
		local petAState = GetPetAState(id)
		local PetBaseData = GetBaseState(id)
		if GetBaseSum(id) < MAXBASESUM then
			for breedid in gmatch(petAState or "","(%w+)") do
				if tonumber(breedid) ~= 0 then
					if #petAState>=3 and not petAState:find(tonumber(breedid)>12 and tonumber(breedid)-10 or breedid) then
						print(id)
						break
					end
				end
			end
		end
	end
end
function Ptest(n,x)
	local tab={0.4,0.5,0.9,2}
	local x = x or 1.3
	for _,t in pairs(addon.PetBaseData) do
		for _,key in pairs(t) do
			for _,i in pairs(tab) do
				if abs((key+i)*x*25-n) <= 1 or abs((key+i)*x*25*5+100-n) <= 1 then
					print(key,i)
					return key+i
				end
			end
		end
	end
end
function ptest(n1,n2,n3,x)
	local e=Ptest(n1,x)+Ptest(n2,x)+Ptest(n3,x)
	local m="null"
	if e==24+1.5 then
		m="3"
	elseif e==24+2 then
		m="4,5,6"
	elseif e==24+1.8 then
		m="7,8,9"
	elseif e==24+1.7 then
		m="10,11,12"
	end
	print(e,m)
end
HPetBattleAny.SearchNoPet=function()
	print("----------------------缺少的宠物")
	for i = 1 , 1800 do
		if select(15,C_PetJournal.GetPetInfoByIndex(i)) then
			local _,id=C_PetJournal.GetPetInfoByIndex(i)
			if not PetData[id] then
				local str=select(8,C_PetJournal.GetPetInfoByIndex(i))
				print(str,id,HP_L(id))
			end
		end
	end
	print("----------------------没有基础数据")
	for i = 1, 1800 do
		if PetData[i] and  not GetBaseState(i) then
			print(i)
		end
	end
	print("----------------------没有可能数据")
	for i = 1, 1800 do
		if PetData[i] and  not GetPetAState(i) then
			print(i)
		end
	end
	print("----------------------可能数据未收集")
	for i,v in pairs(HPetBattleAny.HasPet) do
		for _,k in pairs(v) do
			local isok = false
			local breedID = select(4,HPetBattleAny.GetBreedValue(k));if not breedID then print(k.."数据错误");break end
			local petAState = GetPetAState(i)
			if petAState then
				local cont,len = 0,#petAState
				repeat local breedid;_, cont, breedid = find(petAState,"[,]?(%w+)[,]?",cont)
					breedid = tonumber(breedid)
					if breedid == breedID or breedid == breedID +10 then
						isok = true
						break
					end
				until cont >= len
			end
			if not isok  then
				print(i,HP_L(i))
			end
		end
	end
	print("----------------------NPC宠物(无法获取名字的宠物=没有缓存的宠物)1200-1800")
--~ 	for i = 1200, 1800 do
--~ 		if select(2,C_PetJournal.GetPetInfoBySpeciesID(i)) then
--~ 			if not PetData[i] then
--~ 				print(i,HP_L(i))
--~ 			end
--~ 		end
--~ 	end
end
local function tableP(t1,t2)
	if not t2 then return false end
	if table.getn(t1)~=table.getn(t2) then return false end
	if table.getn(t1[4])~=table.getn(t2[4]) then return false end
	for i = 1, 3 do
		if t1[i]~=t2[i] then return false end
	end
	for k,v in pairs(t1[4]) do
		if t2[4][k]~=v then return false end
	end
	return true
end


----获取误差
local Hmin=function(tab)
	local temp
	for i,v in pairs(tab) do
		temp = temp and (tab[temp]>v and i or temp) or i
	end
	return temp
end
----2014/10:修改下Getdiff，尝试用整数计算，试试误差
local Getdiff=function(index,tstate,health,power,speed,breed,level,isflying,isWild)
	local bstate = HPetBattleAny.GetBreedByID(index)

--~ 	print( 	  format("%.2f",(bstate[HEALTH]+tstate[HEALTH])*5*level*breed+100-0.05)/(isWild and 1.2 or 1) , format("%.0f",health or 0)  ,
--~ 			  format("%.2f",(bstate[POWER]+tstate[POWER])*level*breed-0.05) , format("%.0f",power or 0)  ,
--~ 			 format("%.2f",(bstate[SPEED]+tstate[SPEED])*level*breed-0.05)*(isflying and 1.5 or 1), format("%.0f",speed or 0)
--~ 		,index)
--~ 	print 	math.abs(format("%.2f",(bstate[HEALTH]+tstate[HEALTH])*5*level*breed+100)/(isWild and 1.2 or 1) - format("%.0f",health or 0)) +
--~ 			math.abs(format("%.2f",(bstate[POWER]+tstate[POWER])*level*breed) - format("%.0f",power or 0)) +
--~ 			math.abs(format("%.2f",(bstate[SPEED]+tstate[SPEED])*level*breed)*(isflying and 1.5 or 1) - format("%.0f",speed or 0))

	return 	math.abs(format("%.2f",(bstate[HEALTH]+tstate[HEALTH])*5*level*breed+100)/(isWild and 1.2 or 1) - format("%.0f",health or 0)) +
			math.abs(format("%.2f",(bstate[POWER]+tstate[POWER])*level*breed)/(isWild and 1.25 or 1) - format("%.0f",power or 0)) +
			math.abs(format("%.2f",(bstate[SPEED]+tstate[SPEED])*level*breed)*(isflying and 1.5 or 1) - format("%.0f",speed or 0))
-- 	return 	math.abs((format("%.2f",(bstate[HEALTH]+tstate[HEALTH])*5*level*breed+100) - format("%.0f",health or 0)) +
-- 			(format("%.2f",(bstate[POWER]+tstate[POWER])*level*breed) - format("%.0f",power or 0)) +
-- 			(format("%.2f",(bstate[SPEED]+tstate[SPEED])*level*breed) - format("%.0f",speed or 0)))

--~ 	return 	math.abs(format("%.0f",(bstate[HEALTH]+tstate[HEALTH])*5*level*breed+100-0.05) - format("%.0f",health or 0)) +
--~ 			math.abs(format("%.0f",(bstate[POWER]+tstate[POWER])*level*breed-0.05) - format("%.0f",power or 0)) +
--~ 			math.abs(format("%.0f",(bstate[SPEED]+tstate[SPEED])*level*breed-0.05) - format("%.0f",speed or 0))
end
local GetBreedIDbySystem = function(tstate,health,power,speed,breed,level,isflying,isWild,speciesID)
	local petAState = GetPetAState(speciesID)
	local result = 3
	local minnum = Getdiff(result,tstate,health,power,speed,breed,level)
	if speciesID and petAState then
		local cont,len = 0,#petAState
		repeat local breedid;_, cont, breedid = find(petAState,"[,]?(%w+)[,]?",cont)
		breedid = tonumber(breedid)
		if breedid ~= 0 then
			if minnum > Getdiff(breedid,tstate,health,power,speed,breed,level,isflying,isWild) then
				minnum = Getdiff(breedid,tstate,health,power,speed,breed,level,isflying,isWild)
				result = breedid
			end
		end
		until cont >= len
	elseif not speciesID then
		for i = 4 , 12 do
			if minnum > Getdiff(i,tstate,health,power,speed,breed,level,isflying,isWild) then
				minnum = Getdiff(i,tstate,health,power,speed,breed,level,isflying,isWild)
				result = i
			end
		end
	end
	if minnum <= 0.5 * (isWild and 1.5 or 1) + 0.5 + 0.5 * (isflying and 1.5 or 1) then
		return result,minnum
	else
		return nil,minnum
	end
end
HPetBattleAny.GetBreedValue=function(speciesID,...)
	local level,health,power,speed,rarity,isflying,isWild = ...
	if not level or not rarity then
		local petID = speciesID
		isflying = false
		speciesID, _, level = C_PetJournal.GetPetInfoByPetID(petID)
		_, health, power, speed, rarity = C_PetJournal.GetPetStats(petID)
		if not rarity then return 0,0,0,0,0,0,0 end
	end
	local breed=tonumber("1."..(rarity-1 or 0))

	local tstate = GetBaseState(speciesID)
	if tstate then
		local breedID,minFix = GetBreedIDbySystem(tstate,health,power,speed,breed,level,isflying,isWild,speciesID)
		if breedID then
			local bstate = HPetBattleAny.GetBreedByID(breedID)
--~ 			print("我勒个去",speciesID,C_PetJournal.GetPetInfoBySpeciesID(speciesID),format("%.2f",minFix))
			return bstate[HEALTH],bstate[POWER],bstate[SPEED],breedID,tstate[HEALTH],tstate[POWER],tstate[SPEED]
		end
		printt("HPet:插件数据未收集"..speciesID..C_PetJournal.GetPetInfoBySpeciesID(speciesID))

		local breedID,minFix = GetBreedIDbySystem(tstate,health,power,speed,breed,level,isflying,isWild)
		if breedID then
			local bstate = HPetBattleAny.GetBreedByID(breedID)
--~ 			print("我勒个去",speciesID,C_PetJournal.GetPetInfoBySpeciesID(speciesID),format("%.2f",minFix))
			return bstate[HEALTH],bstate[POWER],bstate[SPEED],breedID,tstate[HEALTH],tstate[POWER],tstate[SPEED]
		end
		printt("HPet:插件数据异常"..speciesID..C_PetJournal.GetPetInfoBySpeciesID(speciesID))
	end

	---------------没有基础数据，计算
	local bhealth=format("%.2f",(health-100)/5/level/breed)
	local bpower=format("%.2f",power/level/breed)
	local bspeed=format("%.2f",speed/level/breed)
	return	bhealth,bpower,bspeed,nil,0,0,0
end

HPetBattleAny.GetIDByBreed=function(h,p,s)
	for i = 3 , 12 do
		local gstate = HPetBattleAny.GetBreedByID(i)
		if math.abs(format("%f",gstate[HEALTH] - h)) <= 0.25 then
			if math.abs(format("%f",gstate[POWER] - p)) <= 0.25 then
				if math.abs(format("%f",gstate[SPEED] - s)) <= 0.25 then
					return i
				end
			end
		end
	end
end



---------------------------------------PetAllInfo.lua
local HPetAllInfoFrame=CreateFrame("Frame","HPetAllInfoFrame",UIParent)
local backdrop={
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	edgeSize = 16,
}
local TABLE1={"BreedID","Health","Power","Speed"}
local TABLE2={"Health","Power","Speed"}
local LINECOLOR={0.5, 0.5, 0.5, 1}
local SELFHEIGHT = 0
function HPetAllInfoFrame:Update(speciesID,breedID,rarityvalue,levelvalue)
	if not HPetAllInfoFrame.ready then HPetAllInfoFrame:Init() end
	local selfheight = SELFHEIGHT
	local speciesID = speciesID or PetJournalPetCard.speciesID
	local breedID = breedID or PetJournalPetCard.breedID
	local rarityvalue = rarityvalue or HPetAllInfoFrame.rarityvalue or 4
	local levelvalue = levelvalue or HPetAllInfoFrame.levelvalue or 25
--~ 	print(breedID , self~=HPetAllInfoFrame,speciesID==HPetAllInfoFrame.speciesID)
	if (not breedID and self~=HPetAllInfoFrame and speciesID==HPetAllInfoFrame.speciesID) or
		(not speciesID) or
		(not HPetAllInfoFrame:IsShown() and self ~= HPetAllInfoFrame)
	then return end

	if self ~= HPetAllInfoFrame and not HPetAllInfoFrame.lockrarity then
		if PetJournalPetCard.petID then
			rarityvalue = select(5,C_PetJournal.GetPetStats(PetJournalPetCard.petID))
		end
	end

    if tonumber(speciesID) == nil then return end
	local name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique = C_PetJournal.GetPetInfoBySpeciesID(speciesID);

	HPetAllInfoFrame.petName.text:SetText(name)
	HPetAllInfoFrame.petName.icon:SetTexture("Interface\\Icons\\Pet_TYPE_"..PET_TYPE_SUFFIX[petType])

	----------------------------------------------------------------
	local height=SELFHEIGHT + HPetAllInfoFrame.baseTable.UpdateInfo(speciesID,breedID)


	----------------------------------------------------------------
	if HPetAllInfoFramerarityButton then
		HPetAllInfoFramerarityButton:SetText(format(ITEM_QUALITY_COLORS[rarityvalue-1].hex.."%s|r",(_G["BATTLE_PET_BREED_QUALITY"..rarityvalue])))
	end
	if HPetAllInfoFramelevelButton then
		HPetAllInfoFramelevelButton:SetText(levelvalue)
	end

	HPetAllInfoFrame.levelTable.UpdateInfo(speciesID,breedID,levelvalue,rarityvalue)

	HPetAllInfoFrame:UpdateSize(height);
	updateElapsed = 0
	HPetAllInfoFrame.speciesID = speciesID
	HPetAllInfoFrame.breedID = breedID
end

function HPetAllInfoFrame:AnchorToBlizzard()
    self:SetParent(PetJournal)
   	self:SetWidth(350)
   	self:SetPoint("TOPLEFT",PetJournal,"TOPRIGHT")
   	self:SetFrameStrata("HIGH")
   	self:SetToplevel(true)
   	self:SetMovable(true)
   	self:SetClampedToScreen(true)
end

function HPetAllInfoFrame:Init()
	-- init frame
    self:AnchorToBlizzard()

	-- background
	self.rightbg	=self:CreateVLine(0, 0, 0, 1,LINECOLOR)
	self.leftbg		=self:CreateVLine(0, 0, 0, 1,LINECOLOR)
	self.midbg		=self:CreateVLine(0, 0, 0, 1,{1,1,1,1})
	self.topbg		=self:CreateHLine(0, 0, 0, 1,LINECOLOR)
	self.bottombg	=self:CreateHLine(0, 0, 0, 1,LINECOLOR)
	self.UpdateSize=function(self,height)
		self.rightbg:SetPos	(self:GetWidth(), 	0, -height, 1)
		self.leftbg:SetPos	(0, 				0, -height, 1)
		self.midbg:SetPos	(self:GetWidth()/2+25,	-27, -height, 1)
		self.topbg:SetPos	(self:GetWidth(), 	0, 0, 		1)
		self.bottombg:SetPos(self:GetWidth(), 	0, -height, 1)
		self:SetHeight(height)
	end
	self:SetBackdrop( {
	  bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	  tile = true, tileSize = 16, edgeSize = 16,
	});
	self:SetBackdropColor(0,0,0)
	self:SetAlpha(1)
	-- drag
	self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart",function(self) self:StartMoving() end)
	self:SetScript("OnDragStop",function(self) self:StopMovingOrSizing() end)
	frames={
		-- name
		{name="petName",width="350",height="30",
		point="TOPLEFT",
		font={text=NAME},
		texture={point="RIGHT",repoint="LEFT",size=26},
		},

		--------------左

		-- breed
		{name="breed",width="50",height="60",
		point="TOPLEFT",relative="petName",repoint="BOTTOMLEFT",
		font={text=L["Breed"]},
		},

		-- base point
		{name="base",width="150",height="30",
		point="TOPLEFT",relative="breed",repoint="TOPRIGHT",
		font={text=L["Base Points"]},
		},

		-- icon1
		{name="icon11",width="50",height="30",
		point="TOPLEFT",relative="base",repoint="BOTTOMLEFT",
		texture={icon="Interface\\PetBattles\\PetBattle-StatIcons",coords={0.5,1.0,0.5,1.0},}
		},
		{name="icon12",width="50",height="30",
		point="TOPLEFT",relative="icon11",repoint="TOPRIGHT",
		texture={icon="Interface\\PetBattles\\PetBattle-StatIcons",coords={0.0,0.5,0.0,0.5},}
		},
		{name="icon13",width="50",height="30",
		point="TOPLEFT",relative="icon12",repoint="TOPRIGHT",
		texture={icon="Interface\\PetBattles\\PetBattle-StatIcons",coords={0.0,0.5,0.5,1},}
		},

		--------------右

		-- level
		{name="level",width="150",height="30",
		point="TOPLEFT",relative="base",repoint="TOPRIGHT",
		font={text=LEVEL..":",point="LEFT"},
		},

		-- rarity
		{name="rarity",width="150",height="30",
		point="TOPLEFT",relative="level",repoint="BOTTOMLEFT",
		font={text=PET_BATTLE_STAT_QUALITY..":",point="LEFT"},
		},

		-- icon2
		{name="icon21",width="50",height="30",
		point="TOPLEFT",relative="rarity",repoint="BOTTOMLEFT",
		texture={icon="Interface\\PetBattles\\PetBattle-StatIcons",coords={0.5,1.0,0.5,1.0},}
		},
		{name="icon22",width="50",height="30",
		point="TOPLEFT",relative="icon21",repoint="TOPRIGHT",
		texture={icon="Interface\\PetBattles\\PetBattle-StatIcons",coords={0.0,0.5,0.0,0.5},}
		},
		{name="icon23",width="50",height="30",
		point="TOPLEFT",relative="icon22",repoint="TOPRIGHT",
		texture={icon="Interface\\PetBattles\\PetBattle-StatIcons",coords={0.0,0.5,0.5,1},}
		},
	}
	SELFHEIGHT = 90
	self:initframe(frames)
	local _,rarityslider = self:CreateSlider("rarity")
	self:CreateSlider("level","level")
	self.lockrarity = true
	--------------------------------------CheckButton1
	local lock=CreateFrame("CheckButton",self:GetName().."lockrarity",_G[self:GetName().."rarity"],"OptionsBaseCheckButtonTemplate")
	lock:SetChecked(1)
	lock:SetHitRectInsets(0,-1,0,0)
	lock:SetPoint("RIGHT")
	lock:SetScript("OnClick",function(self)
		rarityslider:Show()
		isChecked = self:GetChecked()
		if isChecked then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		end
		HPetAllInfoFrame.lockrarity = isChecked or false
	end)
	lock:SetScript("OnEnter",function(s)
		GameTooltip:SetOwner(lock,"ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT",lock,"TOPRIGHT")
		GameTooltip:AddLine(L["lock rarity"], 1, 1, 1, true);
		GameTooltip:Show()
	end)
	--------------------------------------button1
	local button=CreateFrame("Button",self:GetName().."Switch",self,"UIMenuButtonStretchTemplate")
	button.value=true
	button:SetText("|cff69ccf0"..L["Switch"].."|r")
	button:SetSize(50,30)
	-- 	_G[button:GetName().."Left"]:SetAlpha(0.5)
	-- 	_G[button:GetName().."Right"]:SetAlpha(0.5)
	-- 	_G[button:GetName().."Middle"]:SetAlpha(0.5)
	button:SetPoint("TOPLEFT",_G[self:GetName().."breed"],"BOTTOMLEFT")
	button:SetScript("OnClick",function(self)
		self.value=not self.value
		if self.value then
			self:SetText("|cff69ccf0"..L["Switch"].."|r")
		else
			self:SetText("|cff00ff96"..L["Switch"].."|r")
		end
		self:GetParent():Update()
		PetJournal_UpdatePetCard(PetJournalPetCard)
	end)
	--------------------------------------

	self.baseTable = self:CreateTable(self:GetName().."base",TABLE1,self["breed"]:GetWidth()*4,30,"TOPLEFT",self:GetName().."breed","BOTTOMLEFT",true,0,-30)

	self.levelTable = self:CreateTable(self:GetName().."level",TABLE2,self["breed"]:GetWidth()*3,30,"TOPLEFT",self:GetName().."icon21","BOTTOMLEFT")

	self:UpdateSize(SELFHEIGHT);
	self.ready=true
	self:Hide()

	hooksecurefunc("PetJournal_UpdatePetCard",self.Update)
	PetJournal:SetScript("OnHide",function() self:Hide() end)
end

function HPetAllInfoFrame:CreateSlider(name,dtype)
	local tempSlider=CreateFrame("Slider",self:GetName()..name.."Slider",HPetAllInfoFrame[name] or nil,"OptionsSliderTemplate")

			tempSlider:SetAlpha(1)
			tempSlider:SetHeight(20)
			tempSlider:SetWidth(100)
			tempSlider:SetPoint("CENTER",120,0)
			if dtype == "level" then
				tempSlider:SetMinMaxValues(1, 25)
			else
				tempSlider:SetMinMaxValues(1, 6)
			end
			tempSlider:SetValueStep(1)
			tempSlider:Hide()
			tempSlider.SetDisplayValue = tempSlider.SetValue;
			_G[tempSlider:GetName().."Low"]:Hide()
			_G[tempSlider:GetName().."High"]:Hide()
			tempSlider:SetScript("OnValueChanged",function(self, value)
				value = math.floor(value);
				self:SetDisplayValue(value)
				HPetAllInfoFrame[name.."value"] = self:GetValue()
				HPetAllInfoFrame:Update()
			end)
		self:HookScript("OnHide",function()tempSlider:Hide()end)

	local button=CreateFrame("Button",self:GetName()..name.."Button",HPetAllInfoFrame[name],"UIMenuButtonStretchTemplate")
	button:SetText(NONE)
	button:SetAlpha(0.8)
	button:SetHeight(20)
	button:SetWidth(80)
	button:SetPoint("CENTER",14,0)
	hooksecurefunc(button,"SetText",function()
		tempSlider:SetDisplayValue(HPetAllInfoFrame[name.."value"] or (dtype=="level" and 25 or 4))
	end)
	button:SetScript("OnClick",function()
		if tempSlider:IsShown() then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
			tempSlider:Hide()
		else
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
			tempSlider:Show()
		end
	end)
	return button,tempSlider
end

function HPetAllInfoFrame:CreateTable(name,useTABLE,width,height,point,relative,repoint,h,x,y)
	local rt={}
	rt.index=#useTABLE
	rt.UpdateInfo=function(speciesID,HbreedID,level,rarity)
		local baseState=GetBaseState(speciesID)
		local petAState=GetPetAState(speciesID)
		local useline = true
		local selfheight = 0
		local i = 1
		local templen
		if h then
			if baseState then
				rt["table0"]:SetInfo("/"..baseState[1].."/"..baseState[2].."/"..baseState[3])
			else
				rt["table0"]:SetInfo("/-/-/-")
			end
			rt["table0"]:Show()
		end
		selfheight = selfheight + height
		if (baseState and HbreedID) or petAState then
			if not petAState then
				petAState = ""..HbreedID
				templen = #petAState
			elseif HbreedID and not (find(petAState,"[,]?"..HbreedID.."[,]?",cont) or find(petAState,"[,]?"..(HbreedID+10).."[,]?",cont)) then
				templen = #petAState
				petAState = petAState..","..HbreedID
			end
			local cont,len = 0,#petAState
			repeat local breedid;_, cont, breedid = find(petAState,"[,]?(%w+)[,]?",cont)
				breedid = tonumber(breedid)
				if breedid == 0 then
					rt["table"..i]:SetInfo("-/-/-/-")
					rt["table"..i]:Show()
					selfheight = selfheight + height
					rt["table"..i].moveline:Show()
				else
					local state = HPetBattleAny.GetBreedByID(breedid)
					local qrarity=tonumber("1."..(rarity or 0)-1) or 0
					local info = breedid.."/"..baseState[1].."+"..state[1].."/"..baseState[2].."+"..state[2].."/"..baseState[3].."+"..state[3]
					local light= HbreedID and (HbreedID==breedid or HbreedID-10==breedid or HbreedID+10==breedid) or nil
					if (templen and cont >= len) then light = 1 end
					rt["table"..i]:SetInfo(info,level,rarity,light)
					rt["table"..i]:Show()
					selfheight = selfheight + height
					if i == 1 then
						rt["table"..i].moveline:Show()
					elseif useline and ((breedid>12) or (templen and cont >= len)) then
						rt["table"..i].moveline:Show()
						useline	= false
					else
						rt["table"..i].moveline:Hide()
					end
				end
				i = i + 1
			until cont >= len
		end
		if i==1 then
			rt["table"..i]:SetInfo("-/-/-/-")
			rt["table"..i]:Show()
			selfheight = selfheight + height
			i = i + 1
		end
		for i = i, 20 do
			rt["table"..i]:Hide()
		end
		return selfheight
	end
	rt.init=function()
		for i = h and 0 or 1, 20 do
			local tab=CreateFrame("Frame",name.."table"..i,self)
			local index=rt.index
			tab:SetSize(width,height)
			tab:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})

			tab:SetPoint(point,relative,repoint,(x or 0),height*(1-i) + (y or 0))

			---外框:
			HPetAllInfoFrame:CreateVLine(width/index*1, 0, -height, 1,LINECOLOR,tab)
			HPetAllInfoFrame:CreateVLine(width/index*2, 0, -height, 1,LINECOLOR,tab)
			HPetAllInfoFrame:CreateVLine(width/index*3, 0, -height, 1,LINECOLOR,tab)
--~ 			HPetAllInfoFrame:CreateVLine(width/index*4, 0, -height, 1,{1,1,0,1},tab)
			tab.moveline=HPetAllInfoFrame:CreateHLine(width, 0, 0, 2,LINECOLOR,tab)
			if i ~= 1 then tab.moveline:SetColorTexture(1,1,1,1) end
			HPetAllInfoFrame:CreateHLine(width, 0, -height, 1,LINECOLOR,tab)
			---内容:
			for k,v in pairs(useTABLE) do
				local font=tab:CreateFontString(HPetAllInfoFrame:GetName()..v,"OVERLAY","GameFontHighlight")
				tab[v] = font
				font:SetSize(width/index-5,height)
				font:SetJustifyH("RIGHT")
				font:SetPoint("LEFT",font:GetParent(),"LEFT",width/index*(k-1), 0)
			end
			local chan = HPetAllInfoFrame.Chan
			tab.SetInfo = function(self,info,level,rarity,light)
				local qrarity=tonumber("1."..(rarity or 0)-1) or 0
				for k,v in pairs(useTABLE) do
					if level then		--一般基础值(basetable)不传递level.
						if k == 1 then
--~ 							tab[v]:SetText(format("%.0f",(info[k+1][1]+info[k+1][2])*level*qrarity*5+100-0.05))
							tab[v]:SetText(format("%.0f",chan(info,k+1,3)*level*qrarity*5+100-0.05))
						else
							tab[v]:SetText(format("%.0f",chan(info,k+1,3)*level*qrarity-0.05))
						end
					else
						if k == 1 or not tonumber(chan(info,1)) then		--基础值(basetable)的第一列用来打印breedid
							local key = chan(info,k)
							if tonumber(chan(info,1)) and not HPetSaves.BreedIDStyle then
								tab[v]:SetText(HPetBattleAny.GetBreedNames[tonumber(key)])
							else
								tab[v]:SetText(key)
							end
						else
							if HPetAllInfoFrameSwitch.value then
								tab[v]:SetText(format("+%s",chan(info,k,2)))
							else
								tab[v]:SetText(chan(info,k,3))
							end
						end
					end
					if light then
							tab[v]:SetShadowColor(0.41, 0.8, 0.94, 0.8)
					else
						tab[v]:SetShadowColor(0, 0, 0, 0)
					end
				end
				if light then
					if light == 1 then
						tab:SetBackdropColor(0.77, 0.12, 0.23, 0.8)
					else
						tab:SetBackdropColor(1,0.96,0.41,0.8)
					end
				else
					tab:SetBackdropColor(0,0,0,0)
				end
			end
			tab:Hide()
			rt["table"..i] = tab
		end
	end
	rt.height = width/4
	rt.init()
	return rt
end
HPetAllInfoFrame.Chan = function(info,k1,k2)
	for i=1 ,k1-1 do
		info = strmatch(info,"/(.*)")
	end
	info = match(info,"(.-)/") or info
	if not k2 then
		return info
	else
		local res1 ,res2 = match(info,"(.*)+(.*)")
		if k2 == 3 then
			return tonumber(res1)+tonumber(res2)
		end
		if k2 == 1 then
			return tonumber(res1)
		end
		if k2 == 2 then
			return tonumber(res2)
		end
	end
end
function HPetAllInfoFrame:CreateVLine (x, y1, y2, w, color, parent)
  parent = parent or self
  local line = parent:CreateTexture (nil, "ARTWORK")
  line:SetDrawLayer ("ARTWORK")
  line:SetColorTexture (color[1], color[2], color[3], color[4])
  if y1 > y2 then
    y1, y2 = y2, y1
  end
  line:ClearAllPoints ()
  line:SetTexCoord (1, 0, 0, 0, 1, 1, 0, 1)
  line.width = w
  line:SetPoint ("BOTTOMLEFT", parent, "TOPLEFT", x - w / 2, y1)
  line:SetPoint ("TOPRIGHT", parent, "TOPLEFT", x + w / 2, y2)
  line:Show ()
  line.SetPos = function (self, x, y1, y2)
    if y1 > y2 then
      y1, y2 = y2, y1
    end
    self:ClearAllPoints ()
    self:SetPoint ("BOTTOMLEFT", parent, "TOPLEFT", x - self.width / 2, y1)
    self:SetPoint ("TOPRIGHT", parent, "TOPLEFT", x + self.width / 2, y2)
  end
  line:Show()
  return line
end

function HPetAllInfoFrame:CreateHLine (x1, x2, y, w, color, parent)
  parent = parent or self
  local line = parent:CreateTexture (nil, "ARTWORK")
  line:SetDrawLayer ("ARTWORK")
  line:SetColorTexture (color[1], color[2], color[3], color[4])
  if x1 > x2 then
    x1, x2 = x2, x1
  end
  line:ClearAllPoints ()
  line:SetTexCoord (0, 0, 0, 1, 1, 0, 1, 1)
  line.width = w
  line:SetPoint ("BOTTOMLEFT", parent, "TOPLEFT", x1, y - w / 2)
  line:SetPoint ("TOPRIGHT", parent, "TOPLEFT", x2, y + w / 2)
  line:Show ()
  line.SetPos = function (self, x1, x2, y)
    if x1 > x2 then
      x1, x2 = x2, x1
    end
    self:ClearAllPoints ()
    self:SetPoint ("BOTTOMLEFT", parent, "TOPLEFT", x1, y - self.width / 2)
    self:SetPoint ("TOPRIGHT", parent, "TOPLEFT", x2, y + self.width / 2)
  end
  line:Show()
  return line
end

function HPetAllInfoFrame:initframe(frames)
	for key,value in pairs(frames) do
		self[value.name]=CreateFrame("Frame",self:GetName()..value.name,self,value.inherits or nil)
		self[value.name]:SetSize(value.width,value.height)
		self[value.name]:SetBackdrop(backdrop);
		if value.point then
			if value.relative then
				value.relative = self:GetName()..value.relative
			end
			self[value.name]:SetPoint(value.point,value.relative or self,value.repoint or self.point,value.x or 0,value.y or 0)
		end
		if value.font then
			self[value.name].text=self[value.name]:CreateFontString(self:GetName().."text","OVERLAY","GameFontHighlight")
			self[value.name].text:SetFont(GameFontHighlight:GetFont(), value.font.size or 15)
			if value.font.point then
				self[value.name].text:SetPoint(value.font.point,10,0)
			else
				self[value.name].text:SetPoint("CENTER")
			end
			if value.font.text then
				self[value.name].text:SetText(value.font.text)
			end
		end
		if value.texture then
			self[value.name].icon=self[value.name]:CreateTexture(self:GetName().."icon","OVERLAY")
			if value.texture.size then
				self[value.name].icon:SetSize(value.texture.size,value.texture.size)
			else
				self[value.name].icon:SetSize(16,16)
			end
			if value.texture.point then
				self[value.name].icon:SetPoint(value.texture.point,self[value.name].text,value.texture.repoint)
			else
				self[value.name].icon:SetPoint("CENTER")
			end
			if value.texture.icon then
				self[value.name].icon:SetTexture(value.texture.icon)
			end
			if value.texture.coords then
				self[value.name].icon:SetTexCoord(value.texture.coords[1],value.texture.coords[2],value.texture.coords[3],value.texture.coords[4])
			end
		end
	end
end
function HPetAllInfoFrame:Toggle(...)
	if not self.ready then self:Init() end
	if self:GetParent() == RematchPetCard then self:Hide() end
	self:AnchorToBlizzard()
    self:SetIgnoreParentAlpha(false)
	self:Update(...)
	if not self:IsVisible() then self:Show() else self:Hide() end
end

CoreDependCall("Rematch", function()
    hooksecurefunc(Rematch, "ShowPetCard", function(self, parent, petID)
        if not RematchPetCard.petID then return end
        local idType = Rematch:GetIDType(RematchPetCard.petID)
        if idType == "species" then
            PetJournalPetCard.speciesID = petID
            PetJournalPetCard.breedID = nil
        elseif idType == "pet" then
            if PetJournalPetCard then
                PetJournalPetCard.speciesID = C_PetJournal.GetPetInfoByPetID(RematchPetCard.petID)
                PetJournalPetCard.breedID = select(4, HPetBattleAny.ShowMaxValue(RematchPetCard.petID))
            end
        else
            return
        end
        local self = HPetAllInfoFrame
        if not self.ready then self:Init() end
        self:SetParent(RematchPetCard)
        self:SetIgnoreParentAlpha(true)
       	self:SetWidth(350)
       	self:SetPoint("TOPLEFT",RematchPetCard,"TOPRIGHT", -2, -73)
       	self:SetFrameStrata("HIGH")
       	self:SetToplevel(true)
       	self:SetMovable(true)
       	self:SetClampedToScreen(false)
        self:Update()
        self:Show()
    end)
end)
