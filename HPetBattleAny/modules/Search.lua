-----####Search.lua 1.4####
--修复因CreateLinkByInfo变动而照成的错误
--[[设置详解：
	/hpq s str1,str1为要搜索的资料,用于查找宠物信息中提示出来的所在地/出售商人/获取方式(就是提示信息中的sourceText内容)
	例如:[/hpq s 贫瘠之地][/hpq s]
	/hpq ss str1[ str2][-str3]搜索该宠物的技能信息,str1为包含的技能信息文字,str2为另一个技能包含,str3为不包含
	例如:
	[/hpq ss 月火术]搜索出搜有技能信息带月火术技能的宠物
	[/hpq ss 月火术-重拳]搜索带月火，但是不带重拳
	[/hpq ss 月火术 重拳]搜索带月火并且带重拳
	注意。关键字是包括技能信息内的文字/技能类别"
]]--

--~ Globals
local _G = getfenv(0)
local hooksecurefunc, tinsert, pairs, wipe = _G.hooksecurefunc, _G.table.insert, _G.pairs, _G.wipe
local ipairs = _G.ipairs
local C_PetJournal = _G.C_PetJournal
--~ --------
local addonname,addon = ...
local L = addon.L

local function Qstringfind(strm,strf)
	local strf1=strf[1]
	local strf2=strf[2]
	local strf3=strf[3]
	local str1={}	---查找词组
	local str2={}	---查找词组中排除词组 "/"
	local str3={}	---排除词组 "-"

	if strf1 then
		while strf1 and strf1~="" do
			local strt=""
			strt,strf1=strf1:match("^%s*(%S*)%s*(.-)$")
			str1[strt]=0
		end
	end

	if strf2 then
		while strf2 and strf2~="" do
			local strt=""
			strt,strf2=strf2:match("^%s*(%S*)%s*(.-)$")
			str2[strt]=0
		end
	end

	if strf3 then
		while strf3~="" do
			local strt=""
			strt,strf3=strf3:match("^%s*(%S*)%s*(.-)$")

			str3[strt]=0
		end
	end

	local result=""

	for index=1,6 do

		for i,_ in pairs(str3) do
			if strm[index] and string.find(strm[index],i)~=nil then
				return false
			end
		end

		local btmp=true
		for i,_ in pairs(str2) do
			if strm[index] and string.find(strm[index],i)~=nil then
				btmp=false
			end
		end

		if strm[index] and btmp then result=result..strm[index] end

	end

	for i,_ in pairs(str1) do
		if string.find(result,i)==nil then return false end
	end


	return true
end


function HPetBattleAny:Search(command,rest)
	local stemp=GetZoneText()
	local tmp1=""
	local tmp2=""
	if rest ~= "" then stemp=rest end

	local serachtemp={}
	serachtemp[1],serachtemp[3]=string.split("-",stemp)
	serachtemp[1],serachtemp[2]=string.split("/",serachtemp[1])
	if serachtemp[1]~="" then
		if serachtemp[3] and serachtemp[3]~="" then
			self:PetPrintEX(L["search key"]..serachtemp[1]:match"^%s*(.-)$"..","..L["search remove key"]..serachtemp[3]:match"^%s*(.-)$")
		else
			self:PetPrintEX(L["search key"]..serachtemp[1]:match"^%s*(.-)$")
		end
	end

	for i=1,C_PetJournal.GetNumPets(false) do
		local petID,speciesID,isOwned, _, _, _, _, name, _, _, _, sourceText=C_PetJournal.GetPetInfoByIndex(i)
		if command=="s" then
			if serachtemp and string.find(sourceText,serachtemp[1]) then
				if isOwned then
					tmp1=tmp1..self.CreateLinkByInfo(petID or 0,true)
				else
					tmp2=tmp2.."\124cffffff00\124Hbattlepet:"..speciesID..":0:0:0:0:0\124h["..name.."]\124h\124r"
				end
			end
		else
			local strm={}
			for j=1,6 do
				local abilityID=C_PetJournal.GetPetAbilityList(speciesID)[j]
				if not abilityID then break end
				local _,st1,_,_,st2,_,st3=C_PetBattles.GetAbilityInfoByID(abilityID)
				strm[j]=st1..st2.._G["BATTLE_PET_NAME_"..st3]
			end
			if (serachtemp and Qstringfind(strm,serachtemp)) then
				if isOwned then
					tmp1=tmp1..self.CreateLinkByInfo(petID or 0,true)
				else
					tmp2=tmp2.."\124cffffff00\124Hbattlepet:"..speciesID..":0:0:0:0:0\124h["..name.."]\124h\124r"
				end
			end
		end
	end
	self:PetPrintEX(COLLECTED..":"..tmp1)
	self:PetPrintEX(NOT_COLLECTED..":"..tmp2)
end
HPetBattleAny.fixed={
	["PlayerTalentFrame"]=false,
	["PetJournalParent"]=false,
	["WorldMapFrame"]=false,
	["AchievementFrame"]=false,
}
HPetBattleAny.fix=function(str)end


-----------------map

local npcs = {
	["熊猫人烈焰之灵"]={			--
		["QuestID"]=32434,
	},
	["熊猫人微风之灵"]={			--
		["QuestID"]=32440
	},
	["熊猫人雷霆之灵"]={			--
		["QuestID"]=32441
	},
	["熊猫人流水之灵"]={	--66950
		["QuestID"]=32439
	},
	["杰里米·费舍尔"]={
		["QuestID"]=32175
	},
	["圣地的俞娜"]={
		["QuestID"]=31953
	},
	["莫鲁克"]={
		["QuestID"]=31954
	},
	["废土行者苏游"]={
		["QuestID"]=31957
	},
	["勇敢的尹勇"]={
		["QuestID"]=31956
	},
	["探索者祖什"]={
		["QuestID"]=31991
	},
	["天选者亚济"]={
		["QuestID"]=31958
	},
	["农夫倪石"]={
		["QuestID"]=31955
	},

	["派恩少校"]={
		["QuestID"]=31935
	},

	["“冷血”崔克斯"]={
		["QuestID"]=31909
	},
	["奥巴里斯"]={
		["QuestID"]=31971
	},
	["莉迪亚·埃考斯特"]={
		["QuestID"]=31916
	},
	["血骑士安塔里"]={
		["QuestID"]=31926
	},



	['“冷血”崔克斯'] = {['qID'] = 31909},
	['艾琳娜·振翼'] = {['qID'] = 31908},
	["派恩少校"]={
		["qID"]=31935
	},
	["奥巴里斯"]={
		["qID"]=31971
	},
	["莉迪亚·埃考斯特"]={
		["qID"]=31916
	},
	["血骑士安塔里"]={
		["qID"]=31926
	},

	-------无奖励日常

}
--~ local temp_hook = GetMapLandmarkInfo
--~ GetMapLandmarkInfo=function(...)
--~ 	local name, description, textureIndex, x, y, mapLinkID, inBattleMap, graveyardID, areaID, poiID = temp_hook(...)
--~ 	local message
--~ 	if npcs[name] and npcs[name].QuestID then
--~ 		local q=GetQuestsCompleted();
--~ 		local com = q[tonumber(npcs[name].QuestID)]
--~ 		message = (com and " |cffffff00完成|r" or " |cffff0000未完成|r")
--~ 		if com then
--~ 			textureIndex=189
--~ 		end
--~ 	end
--~ 	return name, (description or "")..(message or ""), textureIndex, x, y, mapLinkID, inBattleMap, graveyardID, areaID, poiID
--~ end
--~ local QuestDate=GetQuestsCompleted()
--~ local NTime=GetTime()
--~ local STime=15
--[==[ --TODO aby8
hooksecurefunc(WorldMapFrame, "OnMapChanged", function(...)
	for i=1, NUM_WORLDMAP_POIS do
		local worldMapPOIName = "WorldMapFramePOI"..i;
		local worldMapPOI = _G[worldMapPOIName];
		local name, description, textureIndex, x, y, mapLinkID, inBattleMap, graveyardID, areaID, poiID, isObjectIcon, atlasIcon = GetMapLandmarkInfo(i);
		if npcs[name] and npcs[name].QuestID then
			local com = IsQuestFlaggedCompleted(tonumber(npcs[name].QuestID))
			message = (com and " |cffffff00完成|r" or " |cffff0000未完成|r")
			worldMapPOI.description = (description or "")..(message or "")
			if com then
				textureIndex=189
			end
			local x1, x2, y1, y2
			if (not atlasIcon) then
				if (isObjectIcon == true) then
					x1, x2, y1, y2 = GetObjectIconTextureCoords(textureIndex);
				else
					x1, x2, y1, y2 = GetPOITextureCoords(textureIndex);
				end
				_G[worldMapPOIName.."Texture"]:SetTexCoord(x1, x2, y1, y2);
			else
				_G[worldMapPOIName.."Texture"]:SetTexCoord(0, 1, 0, 1);
			end
		end
	end
end)
--]==]