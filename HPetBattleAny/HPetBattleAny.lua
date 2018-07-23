-----####HPetBattleAny.lua 3.6####
----3.3:修改了载入数据方式,避免重置过滤器,避免照成顿卡,避免因为游戏文件不全导致重复载入.
----3.4:修复遇到蓝色宠物报警失效的问题
----3.41:优化了下HPetBattleAny.ShowMaxValue,对于没有数据的宠物,不显示breed加值(也没得显示.)
----3.5:增加HPetBattleAny.ICON_LIST,用来表达SS/PP/HH宠物
----3.51:优化VARIABLES_LOADED,用以版本更新,整理数据.
----3.6:优化CreateLinkByInfo,对于数据部明确的宠物,直接使用原数据创建链接.
----3.61:PET_BATTLE_OPENING_START增加打印开战文本.
----3.62:ErrorisShow.count错误提示修正.C_PetJournal.GetPetNum()不需要参数,载入数据以返回值total为上限
----3.7:稍微调整了下PetJournalPetCardModelFrame的位置
----3.8:调整下默认设置
----4.0:处理掉6.0下UIMenuButtonStretchTemplate有关的报错
----4.1:新增HPetSaves.MiniTip,(config没有加入)
----4.2:尝试，去掉Init_BPET下的self:RegisterEvent("PET_JOURNAL_LIST_UPDATE"),让载入数据变成需要使用时再载入
----4.3:新增HPetBattleAny:CanTrapBySpeciesID,修复某些野外BOSS会出现稀有宠物报警提示

--- Globals
local _
local _G = getfenv(0)
local hooksecurefunc, tinsert, pairs, wipe = _G.hooksecurefunc, _G.table.insert, _G.pairs, _G.wipe
local ipairs = _G.ipairs
local C_PetJournal = _G.C_PetJournal
--- --------
local VERSION = GetAddOnMetadata("HPetBattleAny","Version")
local H_PET_BATTLE_CHAT_FRAME={}
local LEVEL_COLLECTED = "(%s)"--"(lv:%s)"
local addonname,addon = ...
local L = addon.L

HPetBattleAny = CreateFrame("frame");
HPetBattleAny:SetScript('OnEvent', function(_, event, ...) return HPetBattleAny[event](HPetBattleAny, event, ...) end)
HPetBattleAny:Hide()
HPetBattleAny.addon = addon

function HPetBattleAny:Init_HPET()
	if not self.initialized_HPET then
		self:RegisterEvent("VARIABLES_LOADED");
		self.initialized_HPET = true
		printt("test:载入HPET部分")

		self:Loadinginfo()
		self:LoadSomeAny()
		if self.hook then self.hook:init() end
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		if PetJournal then
			HPetBattleAny:Init_BPET()
		end
		HPetBattleAny.LoadedTime = GetTime()
	end
end
function HPetBattleAny:Init_BPET()
	printt("test:载入BPET部分")
	if not self.initialized_BPET then
		self.initialized_BPET = true
--~ 		self:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
		self:initforJournalFrame()
		if self.hook_PJ then self.hook_PJ:init() end
	end
end
function HPetBattleAny:LoadSomeAny()
	if GetLocale()=="zhCN" then
		PET_BATTLE_COMBAT_LOG_AURA_APPLIED ="%1$s对%3$s %4$s 造成了%2$s效果."
		PET_BATTLE_COMBAT_LOG_PAD_AURA_APPLIED = "%1$s对%3$s 造成了%2$s效果."
		PET_BATTLE_COMBAT_LOG_MISS = "%s|cffff0000未命中|r%s %s。"
		PET_BATTLE_COMBAT_LOG_DODGE = "%s被%s %s|cffff0000躲闪|r了。";
		PET_BATTLE_COMBAT_LOG_DAMAGE_CRIT = "|cffffff00"..PET_BATTLE_COMBAT_LOG_DAMAGE_CRIT.."|r";

		if HPetSaves.MiniTip then
			CHAT_PET_BATTLE_COMBAT_LOG_GET = "|Hchannel:PET_BATTLE_COMBAT_LOG|h[PTC]|h：\32";
			CHAT_PET_BATTLE_INFO_GET = "|Hchannel:PET_BATTLE_INFO|h[PTI]|h：\32";
			PET_BATTLE_COMBAT_LOG_NEW_ROUND = "Action：%d";
			PET_BATTLE_COMBAT_LOG_PET_SWITCHED = "%2$s放出了%1$s。";
			PET_BATTLE_COMBAT_LOG_ENEMY = "敌方";
			PET_BATTLE_COMBAT_LOG_ENEMY_LOWER = "敌方";
			PET_BATTLE_COMBAT_LOG_YOUR = "我方";
			PET_BATTLE_COMBAT_LOG_YOUR_LOWER = "我方";
			PET_BATTLE_COMBAT_LOG_YOUR_TEAM = "我方队伍";
			PET_BATTLE_COMBAT_LOG_YOUR_TEAM_LOWER = "我方队伍";
		end
	end
end
function HPetBattleAny:Loadinginfo()
	--self:PetPrintEX(format("HPetBattleAny"..VERSION..L["Loading"],"|cffff0000/hpq|r"))
end
--------用于自动隐藏和显示的界面名字
HPetBattleAny.AutoHideShowfrmae={
	["MinimapCluster"]="",
	["Recount_MainWindow"]="",
}
--------这里可以修改声音文件
function HPetBattleAny:PlaySoundFile(t)
	if t=="pvp" then
		PlaySound(SOUNDKIT.IG_PLAYER_INVITE, "Master");	----PVP提示声
	else
		PlaySoundFile([[Sound\Events\scourge_horn.ogg]], "Master" ); 
	end
end
--------------------		data
HPetSaves={}
HPetBattleAny.Default={
	ShowMsg = true,				--在聊天窗口显示信息
	Sound=true,
	OnlyInPetInfo=false,
	MiniTip=false,				--简化聊天窗的信息

	FastForfeit=true,
	Tooltip=true,				--额外鼠标提示
	HighGlow=true,				--战斗中用品质颜色对宠物头像着色

	AutoSaveAbility=true,			--自动保存技能
	ShowBandageButton=false,
	ShowHideID=true,

	ShowGrowInfo=true,			--显示成长值
	BreedIDStyle=true,

	PetGreedInfo=true,			--显示品值
	PetBreedInfo=false,			--breeID
	ShowBreedID=false,			--显示breedID

	EnemyAbility=true,			--显示敌对技能
	LockAbilitys=false,
	ShowAbilitysName=false,

	OtherAbility=false,
	AllyAbility=false,

	AbScale=0.8,				--敌对技能大小
	AbPoint={},					--位置(nil)
	god=false,
}
HPetBattleAny.ICON_LIST={}
setmetatable(HPetBattleAny.ICON_LIST,{__index=function(self,key)
	key = key or 0
	if key == 6 or key == 16 then
		return "|TInterface\\PetBattles\\PetBattle-StatIcons:10:10:0:0:10:10:5:10:5:10|t"
	elseif  key == 5 or key == 15  then
		return "|TInterface\\PetBattles\\PetBattle-StatIcons:10:10:0:0:10:10:0:5:5:10|t"
	elseif  key == 4 or key == 14  then
		return "|TInterface\\PetBattles\\PetBattle-StatIcons:10:10:0:0:10:10:0:5:0:5|t"
	elseif key == 99 then
		return "|TInterface\\PetBattles\\PetBattle-StatIcons:10:10:0:0:10:10:5:10:0:5|t"
	else
		return ""
	end
end})
HPetBattleAny.EnemyPetInfo={}
local TempTable = {["level"]=1,["health"]=2,["power"]=3,["speed"]=4,["rarity"]=5,["isflying"]=6}
local meta={__index=function(self,index)
	if TempTable[index] then
		return self[TempTable[index]]
	else
		return rawget(self,index)
	end
end}
local parentMeta = {
	__newindex=function(self,index,value)
		rawset(self,index,value)
		if type(value) == "table" then
			setmetatable(self[index],meta)
		end
	end
}
setmetatable(HPetBattleAny.EnemyPetInfo,parentMeta)
--------------------		载入宠物手册的数据
HPetBattleAny.HasPet={}
setmetatable(HPetBattleAny.HasPet,{__index=function(self,index)
	setmetatable(HPetBattleAny.HasPet,nil)
	if not HPetBattleAny.HasPetloading then
		printt("初始化HasPet")
		HPetBattleAny:PET_JOURNAL_LIST_UPDATE(true)
		HPetBattleAny.HasPet_Loaded = true
	end
	return HPetBattleAny.HasPet[index]
end})
--[[		function	]]--
-----	测试函数
function printt(...)
	if HPetSaves.god then
		print(...)
	end
end

function HPetBattleAny.sortRarityLevelAsc(a, b)
	if a.rarity == b.rarity then
		return a.level < b.level
	else
		return a.rarity < b.rarity
	end
end
-----	却确定宠物信息窗口
function HPetBattleAny:GetPetBattleChatFrmae()
	wipe(H_PET_BATTLE_CHAT_FRAME)
--~ 	H_PET_BATTLE_CHAT_FRAME={}
	if HPetSaves.OnlyInPetInfo then
		for _, chatFrameName in pairs(CHAT_FRAMES) do
			local frame = _G[chatFrameName];
			for index = #frame.messageTypeList,1,-1 do
				if frame.messageTypeList[index] == "PET_BATTLE_COMBAT_LOG" then
					table.insert(H_PET_BATTLE_CHAT_FRAME,frame)
					break
				end
			end
		end
	end
	if #H_PET_BATTLE_CHAT_FRAME==0 then
		table.insert(H_PET_BATTLE_CHAT_FRAME,DEFAULT_CHAT_FRAME)
	end
end
-----	打印函数
function HPetBattleAny:PetPrintEX(str,...)
	HPetBattleAny:GetPetBattleChatFrmae()

	for _,frame in pairs(H_PET_BATTLE_CHAT_FRAME) do
		if not frame:IsShown() then FCF_StartAlertFlash(frame) end
		frame:AddMessage(str,...)
	end

end
-----	该宠物可否捕捉(通过判断该宠物的文本是否有"宠物对战"字样来判断)
function HPetBattleAny:CanTrapBySpeciesID(speciesID)
	local infotemp = select(5,C_PetJournal.GetPetInfoBySpeciesID(speciesID))
	if infotemp ~= "" and strfind(infotemp,"cFFFFD200"..BATTLE_PET_SOURCE_5) then
		return true
	end
end

-----	创建宠物链接
function HPetBattleAny.CreateLinkByInfo(petID,...)		---...=usecustom,level,health,power,speed,rarity
	if petID == 0 or petID == "BattlePet-0-000000000000" or not petID then return nil end
	local name,speciesID,customname
	local usecustom,level = ...
	local rarity = select(6,...) or select(5,C_PetJournal.GetPetStats(petID)) or nil
	local bhealth,bpower,bspeed,breedID,thealth,tpower,tspeed = HPetBattleAny.GetBreedValue(petID,select(2,...))
	if not level then
		speciesID, customname, level = C_PetJournal.GetPetInfoByPetID(petID)
		if usecustom == "LEVEL" then
			customname = tostring(level)
		else
			customname = usecustom and customname or nil
		end
	else
		speciesID,petID = petID,nil

		customname = usecustom or nil
	end
	if not speciesID then return end
	name = customname or C_PetJournal.GetPetInfoBySpeciesID(speciesID)
	if not name or tonumber(name) == name then return end

	local health,power,speed
	if breedID then
		local rhealth,rpower,rspeed = thealth+bhealth,tpower+bpower,tspeed+bspeed
		health=format("%0.f",rhealth*tonumber("1."..(rarity-1))*level*5+100)
		power=format("%0.f",rpower*tonumber("1."..(rarity-1))*level)
		speed=format("%0.f",rspeed*tonumber("1."..(rarity-1))*level)
		rarity = rarity - 1
	else
		health,power,speed,rarity = select(3,...)
		if rarity then
			rarity = rarity - 1
		else
			health,power,speed,rarity = select(2,C_PetJournal.GetPetStats(petID))
			rarity = rarity - 1
		end
	end
	if HPetSaves.lie then
		HPetSaves.lie = tonumber(HPetSaves.lie) or 1
		rarity=rarity+HPetSaves.lie
	end
	link=ITEM_QUALITY_COLORS[rarity].hex.."\124Hbattlepet:"
	link=link..speciesID..":"..level..":"..rarity..":"..health..":"..power..":"..speed..":"..(petID or "BattlePet-0-000000000000")
	link=link.."\124h["..(customname or name).."]\124h\124r"
--~ 	print(customname or name,"我勒个去")
	return link
end
-----	成长值
function HPetBattleAny.ShowMaxValue(speciesID,...)	---...=level,health,power,speed,rarity
	local bhealth,bpower,bspeed,breedID,thealth,tpower,tspeed,rarity
	local point
	if speciesID == "EnemyPet" then
		local pet = HPetBattleAny.EnemyPetInfo[...]
		point = true
		rarity = pet.rarity
		bhealth,bpower,bspeed,breedID,thealth,tpower,tspeed = HPetBattleAny.GetBreedValue(pet.speciesID,unpack(pet))
	else
		local petID = speciesID
		rarity = select(5,...) or select(5,C_PetJournal.GetPetStats(petID)) or nil
		bhealth,bpower,bspeed,breedID,thealth,tpower,tspeed = HPetBattleAny.GetBreedValue(petID,...)
	end
	if not rarity or rarity<1 then return end
	local breed = tonumber("1."..((rarity and rarity-1) or 0))
	-- ghealth,gpower,gspeed	------成长值
	-- thealth,tpower,tspeed	------基础值
	-- bhealth,bpower,bspeed	------breed加值
	local ghealth=format("%.1f",(bhealth+thealth)*5*breed)
	local gpower=format("%.1f",(bpower+tpower)*breed)
	local gspeed=format("%.1f",(bspeed+tspeed)*breed)
	-- 输出值
	local rhealth,rpower,rspeed
	rhealth=""
	rpower=""
	rspeed=""

	if point then
		if HPetSaves.PetBreedInfo then
			rhealth = bhealth
			rpower = bpower
			rspeed = bspeed
		elseif HPetSaves.PetGreedInfo then
			rhealth = bhealth+thealth
			rpower = bpower+tpower
			rspeed = bspeed+tspeed
		else
			rhealth = ghealth
			rpower = gpower
			rspeed = gspeed
		end
	else
		local stlye1="(|c"..RAID_CLASS_COLORS["ROGUE"].colorStr.."%s|r)"
		local stlye2="(|c"..RAID_CLASS_COLORS["MAGE"].colorStr.."%s|r)"

		if HPetSaves.PetGreedInfo or HPetSaves.PetBreedInfo  then
			if HPetSaves.PetGreedInfo and HPetSaves.PetBreedInfo and thealth+tpower+tspeed~=0 then
				local ty="+"
				rhealth,rpower,rspeed = thealth..ty..bhealth,tpower..ty..bpower,tspeed..ty..bspeed
			elseif HPetSaves.PetBreedInfo then
				rhealth,rpower,rspeed = bhealth,bpower,bspeed
			elseif HPetSaves.PetGreedInfo then
				rhealth,rpower,rspeed = thealth+bhealth,tpower+bpower,tspeed+bspeed
			end
			rhealth = format(stlye2,rhealth)
			rpower 	= format(stlye2,rpower)
			rspeed 	= format(stlye2,rspeed)
		end
		if HPetSaves.ShowGrowInfo then
			rhealth = format(stlye1,ghealth)..rhealth
			rpower = format(stlye1,gpower)..rpower
			rspeed = format(stlye1,gspeed)..rspeed
		end

	end
	return rhealth,rpower,rspeed,breedID
end

-----	调出宠物收集信息(已有宠物信息)
function HPetBattleAny:GetPetCollectedInfo(speciesID,enemypet,islink,mini)
	local str1=""
	local str2=""
	local pets=type(speciesID)=="table" and  speciesID or HPetBattleAny:GetPetInfo(speciesID)
	if enemypet and enemypet.level then
		if enemypet.level>20 then
			enemypet.level = enemypet.level-2
		elseif enemypet.level>15 then
			enemypet.level = enemypet.level-1
		end
	end
	if pets then
		table.sort(pets,self.sortRarityLevelAsc)
		if enemypet and self.sortRarityLevelAsc(pets[1],enemypet) then
			str1 = str1.."|cffff0000"..(mini and "-->|r" or L["Only collected"].."：|r")
		else
			str1 = str1.."|cffffff00"..(mini and "-->|r" or COLLECTED.."：|r")
		end
		for i,petInfo in pairs(pets) do
			local petlink
			local _,custname,_,_,_,_,_,name=C_PetJournal.GetPetInfoByPetID(petInfo.petID)

			if islink then
				petlink=HPetBattleAny.CreateLinkByInfo(petInfo.petID or 0,mini and "LEVEL" or true)
			end
			if not petlink then
				if (custname or name) and not mini then
					petlink=ITEM_QUALITY_COLORS[petInfo.rarity-1].hex..(custname or name).."|r"
				else
					petlink=ITEM_QUALITY_COLORS[petInfo.rarity-1].hex.._G["BATTLE_PET_BREED_QUALITY"..petInfo.rarity].."|r"

				end
			end


			if petlink then
				local breedID = select(4,HPetBattleAny.GetBreedValue(petInfo.petID))
				petlink=petlink..HPetBattleAny.ICON_LIST[breedID]
				if not mini and LEVEL_COLLECTED then petlink = format(LEVEL_COLLECTED.."%s",petInfo.level,petlink) end
				if islink or str2=="" then
					str2 = petlink..str2
				else
					str2=petlink.."|n"..str2
				end
			end
		end
	else
		if C_PetBattles.IsPlayerNPC(2) and (select(2,C_PetBattles.IsTrapAvailable())==6 or select(2,C_PetBattles.IsTrapAvailable())==7) then
			str1=str1.."|cffffff00".._G["PET_BATTLE_TRAP_ERR_"..select(2,C_PetBattles.IsTrapAvailable())]
		else
			if enemypet and not HPetBattleAny:CanTrapBySpeciesID(speciesID) then
				str1=str1.."|cffffff00".._G["PET_BATTLE_TRAP_ERR_6"]
			else
				str1=str1.."|cffff0000"..NOT_COLLECTED.."!|r"
			end
		end
	end
	return str1,str2
end

--[[ 	OnEvent:					PET_BATTLE_OPENING_START	]]--
function HPetBattleAny:PET_BATTLE_OPENING_START(...)
	printt("test:战斗开始"..GetTime())
	if ...~="lock" then self:PetPrintEX("---"..PET_BATTLE_START.."---",1,0.96,0.41) end
	wipe(self.EnemyPetInfo)
----- 输出|记录敌对宠物的数据
	local petOwner=2
		for petIndex=1, C_PetBattles.GetNumPets(petOwner) do
			local isdateLoaded = HPetBattleAny.HasPet_Loaded
			local speciesID=C_PetBattles.GetPetSpeciesID(petOwner,petIndex)
			local pets=HPetBattleAny:GetPetInfo(speciesID)
			if not (
			GetTime() - HPetBattleAny.LoadedTime > 5 or
			isdateLoaded or
--~ 				(C_PetBattles.IsPlayerNPC(2) and (select(2,C_PetBattles.IsTrapAvailable())==6 or select(2,C_PetBattles.IsTrapAvailable())==7)) or
--~ 				(pets) or
				(... == "lock")
			) then HPetBattleAny:RunLagFunc("HPetBattleAny:PET_BATTLE_OPENING_START('lock')",2);printt("test:|cffffff00延迟调用|r"..GetTime());return end
			local name = C_PetBattles.GetName(petOwner, petIndex);
			local level = C_PetBattles.GetLevel(petOwner, petIndex);
			local power = C_PetBattles.GetPower(petOwner, petIndex);
			local rarity=C_PetBattles.GetBreedQuality(petOwner,petIndex);
			if rarity>=4 and rarity~=6 and C_PetBattles.IsPlayerNPC(2) and HPetBattleAny:CanTrapBySpeciesID(speciesID) then
				self.EnemyPetInfo.FindBlue=true
			end;
			local health = C_PetBattles.GetMaxHealth(petOwner, petIndex)
			local speed = C_PetBattles.GetSpeed(petOwner, petIndex);
			local isWild
			local isflying
			if C_PetBattles.IsWildBattle() then
				isWild = true
--~ 				health =format("%.0f",health * 1.2) --生命加20%
			else isWild = false
			end
			if C_PetBattles.GetAuraInfo(petOwner,petIndex,1) == 239 then
--~ 				speed=format("%.0f",speed/1.5) --速度降50%
				isflying = true
			else isflying = false
			end

			self.EnemyPetInfo[petIndex]={["speciesID"]=speciesID,["name"]=name,[1]=level,[2]=health,[3]=power,[4]=speed,[5]=rarity,[6]=isflying,[7]=isWild,["breedID"]=nil}

			local breedID=select(4,HPetBattleAny.GetBreedValue(speciesID,unpack(self.EnemyPetInfo[petIndex])))	--获取breedID

			self.EnemyPetInfo[petIndex].breedID=breedID

			if HPetSaves.MiniTip then
				tmprint=" "..petIndex..":"
				tmprint=tmprint..HPetBattleAny.ICON_LIST[breedID]
				tmprint=tmprint..HPetBattleAny.CreateLinkByInfo(speciesID,tostring(level),unpack(self.EnemyPetInfo[petIndex]))
			else
				tmprint=" "..format(L["this is"],petIndex)
				tmprint=tmprint..HPetBattleAny.ICON_LIST[breedID]
				tmprint=tmprint..HPetBattleAny.CreateLinkByInfo(speciesID,name,unpack(self.EnemyPetInfo[petIndex]))
				if LEVEL_COLLECTED then tmprint=format("%s"..LEVEL_COLLECTED,tmprint,level) end
			end

			if HPetSaves.Contrast or true then
				local str1,str2 = HPetBattleAny:GetPetCollectedInfo(speciesID,{["level"]=level,["rarity"]=rarity},true,HPetSaves.MiniTip)
				tmprint = tmprint..str1..str2
			end

			if HPetSaves.ShowMsg then
				self:PetPrintEX(tmprint)
			end
		end

		if HPetSaves.Sound and self.EnemyPetInfo.FindBlue then --C_PetBattles.IsPlayerNPC(2) and select(2,C_PetBattles.IsTrapAvailable())~=7 then
--- 		PlaySoundFile( [[Sound\Event Sounds\Event_wardrum_ogre.ogg]], "Master" );
			self:PlaySoundFile()
		end
	return true
end


--[[	OnEvent:					PET_JOURNAL_LIST_UPDATE		]]--
local Steptime=0
function HPetBattleAny:PET_JOURNAL_LIST_UPDATE(...)
	if not self:IsEventRegistered("PET_JOURNAL_LIST_UPDATE") then
		self:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
	end
	if (HPetSaves.Contrast or true ) and not self.HasPetloading and (... == true or GetTime() - 1.5 > Steptime) then
		local total, owned = C_PetJournal.GetNumPets();
		if not HPetBattleAny.HasPet_owned or owned ~=  HPetBattleAny.HasPet_owned or (... ~= true and total > HPetBattleAny.HasPet_total) then
			Steptime=GetTime()
			printt("|cffff0000系统数据:"..owned.."/"..(total or 0)..".插件数据"..(self.HasPet_owned or 0).."/"..(HPetBattleAny.HasPet_total or 0)..".|r")
			self:LoadUserPetInfo()
		end
	end
end
local ErrorisShow = {count=0,lasttime=GetTime()}
function HPetBattleAny:LoadUserPetInfo(...)
	printt("test:数据处理.进入判断")
	if HPetBattleAny.HasPetloading then
		return	false
	end
	HPetBattleAny.HasPetloading = true
	if HPetBattleAny.hookfilter then HPetBattleAny.hookfilter.ClearFilters() end
	printt("test:数据处理.开始,一共拥有:"..select(2,C_PetJournal.GetNumPets()).."只")
	wipe(HPetBattleAny.HasPet)
	HPetBattleAny.HasPet_total, HPetBattleAny.HasPet_owned = C_PetJournal.GetNumPets()
	local owned=0
	local GetPetInfoByIndex,insert = _G.C_PetJournal.GetPetInfoByIndex,_G.table.insert
	local lbound = max(HPetBattleAny.HasPet_total, HPetBattleAny.HasPet_owned)
	for i=1, lbound do
		local petID, speciesID, isOwned, _,level= C_PetJournal.GetPetInfoByIndex(i);
		if isOwned then
			if not HPetBattleAny.HasPet[speciesID] then HPetBattleAny.HasPet[speciesID] = {} end
			insert(HPetBattleAny.HasPet[speciesID],petID)
			owned=owned+1
		end
	end
	HPetBattleAny.HasPetloading = false
	if HPetBattleAny.hookfilter then HPetBattleAny.hookfilter.RestoreFilters() end
	printt("test:数据处理.结束,载入数据"..owned.."/"..HPetBattleAny.HasPet_owned)

	if HPetBattleAny.HasPet_owned ~= owned and ErrorisShow.count < 4 then
		local nowtime = GetTime()
		if nowtime - ErrorisShow.lasttime > 8 then	---8秒内,连续"再次载入"超过4次,进行锁定.
			ErrorisShow.lasttime = GetTime()
		else
			ErrorisShow.count = ErrorisShow.count + 1
		end
		HPetBattleAny.HasPet_owned = owned

		local iscomp = HPetBattleAny:RunLagFunc("HPetBattleAny:PET_JOURNAL_LIST_UPDATE(true)",1)
		printt("再次载入"..(iscomp and "成功" or "失败"))
		return false
	elseif ErrorisShow.count == 4 then
		print("因游戏缓存异常,宠物数据可能不齐全")
	end
	collectgarbage("collect")
	return true
end
function HPetBattleAny:GetPetNum(speciesID)
	local ids = HPetBattleAny.HasPet[speciesID]
	if ids then return #ids else return 0 end
end
function HPetBattleAny:GetPetInfo(speciesID,index,h)
	local ids = HPetBattleAny.HasPet[speciesID]
	if ids then
		if index then
			local petID = ids[index]
			local rarity = select(5,C_PetJournal.GetPetStats(petID))
			local level = select(3,C_PetJournal.GetPetInfoByPetID(petID))
			local breedID = h or select(4,HPetBattleAny.GetBreedValue(petID))
			return rarity, level, breedID
		else
			local pets={}
			for _,petID in pairs(ids) do
				local _,_,_,_,rarity = C_PetJournal.GetPetStats(petID)
				local _,_,level = C_PetJournal.GetPetInfoByPetID(petID)
				if not rarity or not level then return end
				tinsert(pets,{petID=petID,rarity=rarity,level=level})
			end
			return pets
		end
	end
end
---延迟运行特定的func
local lag_timer = 0
function HPetBattleAny:RunLagFunc(func,timer)
	if lag_timer == 0 then
		HPetBattleAny["LagFunc"]=func
		lag_timer = -timer
		HPetBattleAny:Show()
		return true
	else
		return false
	end
end
HPetBattleAny:SetScript("OnUpdate", function(frame, elapsed)
    lag_timer = lag_timer + elapsed
	if lag_timer > 0 then
		if lag_running then return end
		HPetBattleAny:Hide()
		lag_timer = 0

		local func = HPetBattleAny["LagFunc"]
		HPetBattleAny["LagFunc"]=nil
		if type(func) == "function" then
			func()
		elseif type(func) == "string" then
			pcall(loadstring(func))
		end
	end
end)
--[[	OnEvent:	 				ADDON_LOADED			]]--
function HPetBattleAny:ADDON_LOADED(_, name)
	if name == "HPetBattleAny" then
		HPetBattleAny:Init_HPET()
	elseif name=="Blizzard_Collections" then
		HPetBattleAny:Init_BPET()
	end
	if self.initialized_BPET and self.initialized_HPET then
		self:UnregisterEvent("ADDON_LOADED")
	end
end
function HPetBattleAny:PLAYER_ENTERING_WORLD()
	self:RegisterEvent("PET_BATTLE_OPENING_START")
end
function HPetBattleAny:VARIABLES_LOADED()
	if HPetSaves.Ver ~= VERSION then
		local newSaves={}
		self:PetPrintEX("HPetBattleAny更新, 设置内容可能出现改变.")
		---检测Saves异常
		for v,t in pairs(self.Default) do
			if HPetSaves[v]==nil or type(HPetSaves[v])~=type(t) then
				printt(v,t)
				newSaves[v] = t
			else
				newSaves[v] = HPetSaves[v]
			end
		end
		---更新的Saves名.
		newSaves.PetAbilitys=HPetSaves.PetAbilitys or HPetSaves.PetAblitys or {}

		HPetSaves = newSaves
		HPetSaves.Ver = VERSION
	end
end
------------------------我是和谐的分割线---------------------------------


function HPetBattleAny:initforJournalFrame()
	local button
	button = CreateFrame("Button","HPetInitOpenButton",PetJournal,"UIPanelButtonTemplate")
	button:SetText(L["HPet Options"])
	button:SetHeight(22)
	button:SetWidth(#L["HPet Options"]*8)
	button:SetPoint("TOPLEFT", PetJournalPetCard, "BOTTOMLEFT", -5, 0)
	button:SetScript("OnClick",function()
		if HPetOption then
			HPetOption:Toggle()
		end
	end)

	button = CreateFrame("Button","HPetAllInfoButton",PetJournal,"UIMenuButtonStretchTemplate")
	button:SetText(L["Pet All Info"])
	button:SetHeight(20)
	button:SetWidth(100)
	button:SetPoint("TOPRIGHT", PetJournalPetCard, "BOTTOMRIGHT", -5, 0)
--~ 	button.rightArrow:Show()
	button:SetScript("OnClick",function()
		if HPetAllInfoFrame then
			HPetAllInfoFrame:Toggle()
		end
	end)

 	PetJournalPetCard.modelScene:SetPoint("TOPLEFT",PetJournalPetCard,70,-21)--65
	if (PetJournalPetCardShadows) then
		PetJournalPetCardShadows:SetPoint("TOPLEFT",PetJournalPetCard,50,-67)--45
	end

	if self.initSwathButton then self.initSwathButton() end
end
function HPetBattleAny:PET_BATTLE_QUEUE_PROPOSE_MATCH()
	HPetBattleAny:PlaySoundFile("pvp")
end
HPetBattleAny:RegisterEvent("ADDON_LOADED")
HPetBattleAny:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
