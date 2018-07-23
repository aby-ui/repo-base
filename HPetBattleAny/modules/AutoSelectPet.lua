DefaultNPCNames={
	["熊猫人微风之灵"]={
		{["petID"]=243,["abilityN"]=423},
		{["petID"]=489,["abilityN"]=423},
		{["petID"]=1165,["abilityN"]=153},
	},
	["熊猫人雷霆之灵"]={
		{["petID"]=243,["abilityN"]=423},
		{["petID"]=489},
		{["petID"]=1165},
	},
	["熊猫人烈焰之灵"]={
		{["petID"]=243},
		{["petID"]=489,["abilityN"]=423},
		{["petID"]=1165},
	},
	["农夫倪石"]={
		{["petID"]=243},
		{["petID"]=489},
		{["petID"]=1165,["abilityN"]=423},
	},
	["废土行者苏游"]={
		{["petID"]=243},
		{["petID"]=489,["abilityN"]=423},
		{["petID"]=1165},
	},
	["圣地的俞娜"]={
		{["petID"]=243},
		{["petID"]=489,["abilityN"]=423},
		{["petID"]=1165},
	},
	["勇敢的尹勇"]={
		{["petID"]=243,["abilityN"]=423},
		{["petID"]=489},
		{["petID"]=1165},
	},
}

HAutoSelectPetSave={}
HAutoSelectPetSave["NPCNames"]=DefaultNPCNames




local HSetprint=function(...)
		print("|cffffff00AutoSetPet|r",...)
end
local HAutoSelectPet=CreateFrame("frame")
HAutoSelectPet.step = 5
HAutoSelectPet.conut = 0
HAutoSelectPet.C=0
HAutoSelectPet.date={}
--[[
	date={
		{
			["petID"]=xxxx,
			["abilityN"]=123,
		},	--[1]petID
		{
			["petID"]=xxxx,
			["abilityN"]=123,
		},	--[2]
		{
			["petID"]=xxxx,
			["abilityN"]=123,
		},	--[3]
	}
--]]
HAutoSelectPet.OnUpdate=function(self)
	if  self.step < 4 and self.date then
		local petID = self.date[self.step].petID
		if not petID then
			HSetprint("|cffffff00"..self.step.."位置的宠物没有进行交换|r")
			self.step=self.step+1
			return
		end
		local health, maxHealth, _ = C_PetJournal.GetPetStats(petID)

		-------------换上宠物
		if petID ~= C_PetJournal.GetPetLoadOutInfo(self.step) then	---
			C_PetJournal.SetPetLoadOutInfo(self.step,petID,true)
		end
			---------判断血量
		if health<maxHealth*0.8 then
			HSetprint("|cffffff00"..self.step.."位置的"..C_PetJournal.GetBattlePetLink(petID).."血量过低|r")
		end

		-------------调整技能
		local as = {}
		local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
		C_PetJournal.GetPetAbilityList(speciesID, as)
		local id,ab=nil,{}
		id,ab[1],ab[2],ab[3] = C_PetJournal.GetPetLoadOutInfo(self.step)
		local str=self.date[self.step].abilityN or HPetSaves.PetAbilitys[petID] or "123"

		for i = 1,3 do
			local skindex = tonumber(string.sub(str,i,i))
			local abilityID = as[skindex]
			if abilityID and abilityID~=ab[i] then
				self.C=self.C+1
				HSetprint("N"..self.C,"操作,设定"..C_PetJournal.GetBattlePetLink(petID).."的",GetBattlePetAbilityHyperlink(abilityID).."技能")
				C_PetJournal.SetAbility(self.step, i, abilityID, true)
			end
		end
			-----------检验技能
		local ac={}
		for i = 1,3 do
			ac[i]=tonumber(string.sub(str,i,i))
			if ac[i] == 0 then ac[i]=i end
		end
--~ 		HSetprint (ab[1], ac[1],ab[2], ac[2] , ab[3], ac[3])
		if (ab[1] == as[ac[1]])
			and (ab[2] == as[ac[2]])
				and (ab[3] == as[ac[3]]) then
			self.step=self.step+1
		end

		--------------重复计数器
		if self.conut > 150 then
			self.conut = 0
			HSetprint(C_PetJournal.GetBattlePetLink(petID),"交换异常")
			self.step=self.step+1
		end

		--------------正常完成
		self.conut = self.conut + 1
	else
		if PetJournal then
			PetJournal_UpdatePetLoadOut()
		end
		self:SetScript("OnUpdate",nil)
		HSetprint("换宠完成")
		self.step = 5
		self.conut = 0
		self.C=0
		self.date = {}
		if self.endfunc then
			HSetprint("调用func")
			self.endfunc()
		end
		self.endfunc=nil
	end
end

HAutoSelectPet.start=function(self)
	HSetprint("换宠开始,准备交换"..(self.date[1].petID and C_PetJournal.GetBattlePetLink(self.date[1].petID) or "")..(self.date[2].petID and C_PetJournal.GetBattlePetLink(self.date[2].petID) or "")..(self.date[3].petID and C_PetJournal.GetBattlePetLink(self.date[3].petID) or "").."上场")
	self.step = 1
	self:SetScript("OnUpdate",HAutoSelectPet.OnUpdate)
end

HAutoSelectPet.isstarting=function(self)
	return self.step < 5
end



-----------------------------



local function SelectpetIDbyspeciesID(id,notid1,notid2)
	local pets=HPetBattleAny:GetPetInfo(id)
	if pets then
		for j = #pets,1,-1 do
			local l=pets[j]
			if l.petID and l.petID~=notid1 and l.petID~=notid2 then
				local health, maxHealth, _, _, ra= C_PetJournal.GetPetStats(l.petID);
				local s,n,level,xp = C_PetJournal.GetPetInfoByPetID(l.petID)
				local _,_,petType,_,_,_,_,canBattle = C_PetJournal.GetPetInfoBySpeciesID(s)
				if health>maxHealth*0.85 and canBattle and level == 25 then
					return l.petID
				end
			end
		end
	end
end

function SelectpetIDbylevel(tlevel,notid1,notid2)
	for i=1,select(2,C_PetJournal.GetNumPets(true)) do
		local petID, speciesID, isOwned, _,level= C_PetJournal.GetPetInfoByIndex(i);
		if petID and petID~=notid1 and petID~=notid2 then
			local health, maxHealth, _, _, ra= C_PetJournal.GetPetStats(petID);
			local s,n,level,xp,_,_,_,_,_,petType,_,_,_,_,canBattle = C_PetJournal.GetPetInfoByPetID(petID)
			if health~=0 and canBattle and level == tlevel then
				if type(tlevel)=="function" and tlevel(level,ra,petType) or level == tlevel then
					return petID
				end
			end
		end
	end
end

function SelectPetByPetID(endfunc,...)
	if HAutoSelectPet:isstarting() then return end
	local petdate=...

	if type(petdate) == "table" then
			HAutoSelectPet.date=petdate
			HAutoSelectPet.endfunc=endfunc
			HAutoSelectPet:start()
	else
		local petid1,petid2,petid3,a1,a2,a3 = ...
		if petid1 or petid2 or petid3 then
			HAutoSelectPet.date={
				{
					["petID"]=petid1,
					["abilityN"]=a1,
				},	--[1]
				{
					["petID"]=petid2,
					["abilityN"]=a2,
				},	--[2]
				{
					["petID"]=petid3,
					["abilityN"]=a3,
				},	--[3]
			}
			HAutoSelectPet.endfunc=endfunc
			HAutoSelectPet:start()
		end
	end
end

function SelectPetByspeciesID(endfunc,...)
	if HAutoSelectPet:isstarting() then return end
	local speciesID1,speciesID2,speciesID3,a1,a2,a3
	local petdate = ...
	if type(petdate) == "table" then
		speciesID1,speciesID2,speciesID3,a1,a2,a3 = petdate[1].petID,petdate[2].petID,petdate[3].petID,petdate[1].abilityN,petdate[2].abilityN,petdate[3].abilityN
		print(speciesID1,speciesID2,speciesID3,a1,a2,a3)
	else
		speciesID1,speciesID2,speciesID3,a1,a2,a3 = ...
	end

	if speciesID1 or speciesID2 or speciesID3 then
		local petid1,petid2,petid3

		local petid1 =(type(speciesID1)=="function" or tonumber(speciesID1)<=25) and SelectpetIDbylevel(speciesID1) or SelectpetIDbyspeciesID(speciesID1)
		local petid2 =(type(speciesID2)=="function" or tonumber(speciesID2)<=25) and SelectpetIDbylevel(speciesID2,petid1) or SelectpetIDbyspeciesID(speciesID2,petid1)
		local petid3 =(type(speciesID3)=="function" or tonumber(speciesID3)<=25) and SelectpetIDbylevel(speciesID3,petid1,petid2) or SelectpetIDbyspeciesID(speciesID3,petid1,petid2)

		SelectPetByPetID(endfunc,{
			{["petID"]=petid1,["abilityN"]=a1},
			{["petID"]=petid2,["abilityN"]=a2},
			{["petID"]=petid3,["abilityN"]=a3}
			})
		return
	end
end

function AutoSelectPetByNPC(endfunc,npcname)
	if HAutoSelectPet:isstarting() then return end
	for name,GoPets in pairs(HAutoSelectPetSave.NPCNames) do
		if string.find(name,npcname) then
			if not GoPets then
				print("没有设置模块,使用通用模块")
				return ;
--~ 				SelectPetByspeciesID(endfunc,1162,746,1162)
			else
				SelectPetByspeciesID(endfunc,GoPets)
			end
			return
		end
	end
end

local function IsDateNpc(name)
	for i,value in pairs(HAutoSelectPetSave.NPCNames) do
		if name and string.find(i,name) then
			return true
		end
	end
	return false
end

StaticPopup1:HookScript("OnUpdate",function(self,elapsed)
	if not IsShiftKeyDown() then
		if StaticPopup1.which == "GOSSIP_CONFIRM" and IsDateNpc(UnitName("npc")) then
			AutoSelectPetByNPC(function()StaticPopup1Button1:Click()end,UnitName("npc"))
		end
	end
end)
