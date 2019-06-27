-----####Hook.lua 4.8####
-------1.3增加宠物头像着色，hook宠物链接生成函数，
-------1.4修改优化ShowMaxValue,并且应用到宠物浮动窗口
-------1.5在宠物浮动窗口增加是否收集的情况
-------1.51修复点击其他人发出来的无品质宠物链接报错的问题
-------1.6增加认输按钮的快捷键。
-------1.65应用新的ShowMaxValue函数，并添加显示BreedID选项
-------1.7放优化弃快捷键,在设置面板选择是否需要确认。
-------1.72:修复战宠tooltip显示breedid位置的问题
-------1.8:点击放弃战斗按钮，也能应用快速放弃
-------1.9:快速放弃同时判断是否出现精良宠物
-------1.91:快速放弃的额外判断需要关闭声音才会起效
-------1.92:对HPetBattleAny.CreateLinkByInfo的HOOK更严谨一点。
-------1.93:删掉一条多余的代码（会导致5.1报错）
-------2.0:对暴雪已内置的内容进行删除
-------删除:PetJournal_UpdatePetList
-------新增:GameTooltip.OnTooltipSetUnit,C_PetJournal.GetOwnedBattlePetString
-------2.01:BattlePetTooltipTemplate_SetBattlePet加入frame.Name:SetText(data.customName),当某些情况宠物名字无法获取时，用自定义名
-------修复鼠标提示显示问题
-------2.1:修复点击链接无法正确指向宠物
-------2.2:新模块，储存宠物技能组合
-------2.3:显示和隐藏其他UI更加安全，不会再造成BLZUI错误
-------2.4:某些地方用了SetScript，全部改成HookScript
-------2.5:PJSTooltip，新函数，应用于PetJournal滚动窗icon的鼠标提示。
-------2.6:点击敌方头像在打开宠物日志的同时，打开宠物信息，并高亮。
-------2.7:修复IDtoString以及相关的一些报错
-------2.71:滚动列表位置的宠物头像增加鼠标提示。
-------2.8:修复NPC宠物无法快速放弃的问题
-------2.9:增强小地图提示信息.HookMiniMap
-------3.0:配合Ability.lua的改动,用AbilityModules来获取敌方宠物信息(只在C_PetBattles.IsPlayerNPC(x)=false生效)
-------3.1:修复HookMiniMap与其他插件兼容问题
-------3.2:GetOwnedInfo做优化.如果因为特殊情况导致没有读取到数据.就直接调用系统数据.
-------3.3:增加新的breeid描述方法
-------3.4:breeid的新描述方法根据HPetAllInfoFrameSwitch.value来调整,宠物技能的切换可以直接在PetCard上面进行.(哪怕宠物界面已锁定.)
-------3.41:增加BreedIDStyle,breeid的新描述方法根据HPetAllInfoFrameSwitch.value依旧原来的用途
-------4.0:配合HPetBattleAny的3.0修改.
-------4.1:宠物头像增加BUFF显示.
-------4.2:为物品类型的宠物增加收集提示
-------4.3:配合PetDate.lua的更新
-------4.4:配合ICON_LIST的修改.
-------4.5:为HP_L增加判断,当ID数据没有被收集时,创建一个无法打开的链接,直接链接到宠物日志.
-------4.6:GetOwnedInfo内加入sourceText判断,用来区分不可不抓的宠物.
-------4.61:对所有的sourceText进行优化,去掉后面可能存在的"/n"
-------4.62:在统计栏增加更加详细的统计提示信息.(增加繁英)
-------4.7:为PetBattleUnitFrame_OnClick,点击敌方头像,显示当前品质等级属性,增加一个开关选项
-------4.71:修复4.7修改中遗漏的地方.
-------4.72:BattlePetItemTooltip中获取的id进行判定,避免出现某些偶然性错误(其他插件导致.)
-------4.8:修复因为对PetJournalPetCardSpell进行setscript照成无法发送技能链接的错误
-------4.9:鼠标提示(目标/Unit)中加入对HPetSaves.Tooltip的判断。可以通过关闭鼠标提示来关掉所有的鼠标提示信息(HPet增加的提示)
-------5.0:修复下因为6.0 petid更改，而照成的错误.
-------5.1:修复BreedID的设置方式不严谨,在鼠标提示的增加内容中加入|HHPET|h以用来判断
--[[
			for el = GameTooltip:NumLines(),1,-1 do
				if _G["GameTooltipTextLeft"..el]:GetText():find("HPET") then
					return
				end
			end
--]]--未完成
-------5.2:IDtoString去掉，新版ID就是string格式

----- Globals
local _
local _G = getfenv(0)
local hooksecurefunc, tinsert, pairs, wipe = _G.hooksecurefunc, _G.table.insert, _G.pairs, _G.wipe
local ipairs = _G.ipairs
local C_PetJournal = _G.C_PetJournal
----- --------
local addonname,addon = ...
local L = addon.L
local hookfunction = CreateFrame("frame")
local hookPetJournal = {}
HPetBattleAny.hook = hookfunction
HPetBattleAny.hook_PJ = hookPetJournal

--[[	function]]--
------快速自定义宠物链接
if HPetBattleAny.CreateLinkByInfo then
	--hook原始创建链接函数
	HPetBattleAny._GetBattlePetLink = C_PetJournal.GetBattlePetLink
	C_PetJournal.GetBattlePetLink=function(id)
		return HPetBattleAny.CreateLinkByInfo(id)
	end
	--自定义创建链接函数
	HP_L=function(id,mlevel,mhealth,mpower,mspeed,mrarity)
		id,mlevel,mhealth,mpower,mspeed,mrarity = tonumber(id),tonumber(mlevel),tonumber(mhealth),tonumber(mpower),tonumber(mspeed),tonumber(mrarity)
		if mspeed==nil or mrarity==nil then
--~ 			print(C_PetJournal.GetPetInfoBySpeciesID(id))
			if mlevel and mlevel > 0 then
				mlevel = mlevel else mlevel = 25 end
			if mhealth and mhealth > 2 and mhealth <23 then
				mhealth = mhealth else mhealth = 3 end
			if mpower and mpower > 0 and mpower < 9 then
				mpower = mpower else mpower = 4 end
		end
		if mrarity~=nil then
			local data={level=mlevel,health=mhealth,power=mpower,speed=mspeed,rarity=mrarity}
			print(HPetBattleAny.CreateLinkByInfo(id,nil,mlevel,mhealth,mpower,mspeed,mrarity))
		elseif HPetBattleAny.GetBaseState(id) then	----id/level/breedid/rarity
			local baseState = HPetBattleAny.GetBaseState(id)
			local rarity=mpower
			local state=HPetBattleAny.GetBreedByID(mhealth)
			local health,power,speed=state[1],state[2],state[3]
			health = format("%0.f",(health+baseState[1])*mlevel*tonumber("1."..mpower-1)*5+100)
			power = format("%0.f",(power+baseState[2])*mlevel*tonumber("1."..mpower-1))
			speed = format("%0.f",(speed+baseState[3])*mlevel*tonumber("1."..mpower-1))
--~ 			print(health,power,speed)
--~ 			local data={level=mlevel,health=health,power=power,speed=speed,rarity=rarity}
			print(HPetBattleAny.CreateLinkByInfo(id,nil,mlevel,health,power,speed,rarity))
		elseif C_PetJournal.GetPetInfoBySpeciesID(id) == id then
			print("没有这个ID")
			return
		else
			local h = 0
			if HPetBattleAny.HasPet[id] then
				h = 99
			end
			print(HPetBattleAny.ICON_LIST[h].."\124cffffff00\124Hbattlepet:"..id..":0:0:0:0:0\124h["..(C_PetJournal.GetPetInfoBySpeciesID(id) or "").."]\124h\124r")
		end
	end
end

-------收集信息(目标提示)
local function TooltipAddOtherInfo(speciesID)
	if HPetSaves.Tooltip then
		local sourceText = select(5,C_PetJournal.GetPetInfoBySpeciesID(speciesID))
		if sourceText and sourceText~="" then
			--清除sourceText最后可能存在的"\n"
			if sourceText:sub(#sourceText,#sourceText) == "n" then sourceText = sourceText:sub(1,#sourceText-2) end
			local pets = HPetBattleAny:GetPetInfo(speciesID)
			if pets then
				local str1,str2 = HPetBattleAny:GetPetCollectedInfo(pets)
				GameTooltip:AddDoubleLine(string.trim(str2),nil, 1, 1, 1);
			end
			GameTooltip:AddLine("|HHPET|h"..string.trim(sourceText), 1, 1, 1, true);
			GameTooltip:Show();
		end
	end
end
-------收集信息(界面提示)
local function GetOwnedInfo(owned,speciesID,b)
	local sourceText = select(5,C_PetJournal.GetPetInfoBySpeciesID(speciesID))
	if sourceText and sourceText~="" then
		local str, result = "",nil
		for i=1, HPetBattleAny:GetPetNum(speciesID) do
			local rarity, level, breedID = HPetBattleAny:GetPetInfo(speciesID,i)
			local str = ""
			if rarity then str=str..ITEM_QUALITY_COLORS[rarity-1].hex..level.."|r" end
			if breedID then str=str..HPetBattleAny.ICON_LIST[breedID] end
			if b then
				result = str..(result and "/"..result or "")
			else
				if result then
					result=str.."/"..result
				else
					result=str
				end
			end
		end
		if result then
			if not b then
				return (owned or "").." |cffffff00[|r"..result.."|cffffff00]|r"
			else
				return result
			end
		end

		if not owned or owned:find("0/") then
			return "|cffff0000"..NOT_COLLECTED.."!|r"
		end
	end
end;HPetBattleAny.GetOwnedInfo=GetOwnedInfo

local function IDtoString(id)
	if id and type(id)~="string" then
		if (id+1~=id)  then
			id = string.upper(format("%x",id))
			id = "0x"..string.rep("0",16-#id)..id
		else
			id = "0x"..tostring(id)
		end
		printt("宠物ID异常")
	end
	return id
end

--[[	init	]]--	initPetJournal需要跟随加载/initOther启动加载
hookPetJournal.init = function()
	--------------- 宠物删除界面优化
	StaticPopupDialogs["BATTLE_PET_RELEASE"].text = PET_RELEASE_LABEL
	StaticPopupDialogs["BATTLE_PET_RELEASE"].exclusive = nil
	StaticPopupDialogs["BATTLE_PET_RELEASE"].hasItemFrame = 1
	StaticPopupDialogs["BATTLE_PET_RELEASE"].OnShow = function(self)
		self.locktime = 2.5
		self.button1:Disable()
	end
	StaticPopupDialogs["BATTLE_PET_RELEASE"].OnUpdate = function(self, elapsed)
		self.locktime = self.locktime-elapsed
		if ( self.locktime <= 0 ) then
			self.button1:Enable()
			self.button1:SetText(OKAY)
			self.OnUpdate = nil
		else
			self.button1:SetText(format("%.1f",self.locktime))
		end
	end
	for i = 1, STATICPOPUP_NUMDIALOGS do
		_G["StaticPopup"..i].itemFrame:HookScript("OnEnter",function(self)
			if self:GetParent().which == "BATTLE_PET_RELEASE" then
				if self.petID then
					hookPetJournal.PJSTooltip(self)
				end
			end
		end)
		_G["StaticPopup"..i].itemFrame:HookScript("OnLeave",GameTooltip_Hide)
	end
	---需要修改，某些状态下不能继续事件
	hooksecurefunc("StaticPopup_Show",function(which, text_arg1, text_arg2, data)
		if which == "BATTLE_PET_RELEASE" then
			dialog = StaticPopup_FindVisible(which, data);
			_G[dialog:GetName().."ItemFrame"]:Show();
			if ( data  ) then
				local speciesID, customName, level, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(data);
				local rarity = select(5,C_PetJournal.GetPetStats(data))
				_G[dialog:GetName().."ItemFrame"].petID = data
				_G[dialog:GetName().."ItemFrameIconTexture"]:SetTexture(petIcon);
				local nameText = _G[dialog:GetName().."ItemFrameText"];
				if ( customName ) then
					nameText:SetText(text_arg1.."\n"..ITEM_QUALITY_COLORS[rarity-1].hex..petName.."\r")
				else
					nameText:SetText(ITEM_QUALITY_COLORS[rarity-1].hex..text_arg1.."\r")
				end
				dialog:SetWidth(320);
			end
		end
	end)
	--------------- "PJSTooltip"
		--滚动条
		for i = 1, 12 do
			_G["PetJournalListScrollFrameButton"..i].dragButton:HookScript("OnEnter",hookPetJournal.PJSTooltip)
			_G["PetJournalListScrollFrameButton"..i].dragButton:HookScript("OnLeave",GameTooltip_Hide)
		end
		--loadout	
		for i = 1, 3 do
			_G["PetJournalLoadoutPet"..i].dragButton:HookScript("OnEnter",hookPetJournal.PJSTooltip)
			_G["PetJournalLoadoutPet"..i].dragButton:HookScript("OnLeave",GameTooltip_Hide)
			-- 下面2016年10月31日16:00:50已经自带 --待删
			-- _G["PetJournalLoadoutPet"..i].modelScene.cardButton:HookScript("OnClick",function(self)
				-- if (not InCombatLockdown()) then
					-- PetJournal_SelectPet(PetJournal,self:GetParent():GetParent().petID)
				-- end
			-- end)
		end

	--- "PetJournal_SelectPet"	--待删
--~ 	hooksecurefunc("PetJournal_SelectPet",hookPetJournal.PetJournal_SelectPet)

	-- PetJournal.listScroll.update = PetJournal_UpdatePetList;
	---------------手动xxxxxxxxxx
	for i = 1, 6 do
		_G["PetJournalPetCardSpell"..i]:HookScript("OnClick",function(self)
			if not PetJournalPetCard.petID then return end
			if (not IsModifiedClick() and not self.LevelRequirement:IsShown()) or (IsModifiedClick() and self.LevelRequirement:IsShown()) then
				local pos = string.gsub("%1%2%3","(.*)(%%"..((i>3) and (i-3) or i)..")(.*)","%1"..i.."%3")
				if pos then
					HPetSaves.PetAbilitys[PetJournalPetCard.petID] = string.gsub(HPetSaves.PetAbilitys[PetJournalPetCard.petID] or "000","^(.)(.)(.)$",pos)
				end
				for loadoutID = 1, 3 do
					if C_PetJournal.GetPetLoadOutInfo(loadoutID) == PetJournalPetCard.petID then
						C_PetJournal.SetAbility(loadoutID,(i>3) and (i-3) or i,self.abilityID)
						PetJournal_UpdatePetLoadOut()
						break
					end
				end
				PetJournal_UpdatePetCard(PetJournalPetCard)
			end
		end)
	end
	hooksecurefunc(C_PetJournal,"SetAbility",hookPetJournal.SetAbility)
	hooksecurefunc(C_PetJournal,"SetPetLoadOutInfo",hookPetJournal.SetPetLoadOutInfo)
	for a,b in pairs(hookPetJournal) do
		if _G[a] then
			hooksecurefunc(a,b)
		end
	end
	PetJournal.PetCount:HookScript("OnEnter",hookPetJournal.PetJournal_PetCount_OnEnter)

end
hookfunction.init = function()
	for a,b in pairs(hookfunction) do
		if a=="PetBattleUnitFrame_OnClick" then
			--------------------------点击头像
			PetBattleFrame.ActiveAlly:HookScript("OnClick",b)
			PetBattleFrame.ActiveEnemy:HookScript("OnClick",b)
			PetBattleFrame.Ally2:HookScript("OnClick",b)
			PetBattleFrame.Ally3:HookScript("OnClick",b)
			PetBattleFrame.Enemy2:HookScript("OnClick",b)
			PetBattleFrame.Enemy3:HookScript("OnClick",b)
		elseif a=="FloatingBattlePet_Toggle" then
			_G[a]=b
		elseif a=="PetBattleFrame_ButtonUp" or a=="PetBattleFrame_ButtonDown" then
			local temp=_G[a]
			_G[a]=function(id)
				b(id,temp)
			end
		elseif _G[a] and type(_G[a]) == "function" then
			hooksecurefunc(a,b)
		end
	end
	PetBattlePrimaryUnitTooltip:HookScript("OnHide",function() GameTooltip:Hide() end)

	---------------鼠标提示加入简单的收集信息
		-----(目标/Unit)
	GameTooltip:HookScript("OnTooltipSetUnit",function()
		if not HPetSaves.Tooltip then return end
		local unit = select(2,GameTooltip:GetUnit())
		if unit and UnitIsBattlePet and UnitIsBattlePet(unit) then
			local speciesID = UnitBattlePetSpeciesID(select(2,GameTooltip:GetUnit()))
			local str = C_PetJournal.GetOwnedBattlePetString(speciesID)
			if not UnitIsWildBattlePet(unit) then
				GameTooltip:AddLine(str)
			end
			TooltipAddOtherInfo(speciesID)
		end
	end)
		-----(物品/Item)
	local function BattlePetItemTooltip(self)
		local link = select(2,self:GetItem())
		if not link then return end
		local id = select(3,strfind(link, "^|%x+|Hitem:(%-?%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%-?%d+):(%-?%d+)"))
		local petID = HPetBattleAny.GetPetIDByItemID(id)
		if petID and type(petID)=="number" then
			local str = C_PetJournal.GetOwnedBattlePetString(petID)
			local linenum = nil
			for i = self:NumLines(),3,-1  do
				local text = _G[self:GetName().."TextLeft"..i]
				if str:find(text:GetText()) then
					text:SetText(GetOwnedInfo(str,petID))
					self:Show()
					return
				end
			end
			self:AddLine("|cffff0000"..NOT_COLLECTED.."!|r")
			self:Show()
		end
	end
	GameTooltip:HookScript("OnTooltipSetItem", BattlePetItemTooltip)
	ItemRefTooltip:HookScript("OnTooltipSetItem", BattlePetItemTooltip)
	---------------为放弃按钮增加快捷键
	PetBattleFrame.BottomFrame.ForfeitButton:SetID(6)
	---------------hook宠物api
	local GetOwnedBattlePetStringtemp=C_PetJournal.GetOwnedBattlePetString
	C_PetJournal.GetOwnedBattlePetString=function(id)
		local str = GetOwnedBattlePetStringtemp(id)
		if not str then
			return GREEN_FONT_COLOR_CODE..format(ITEM_PET_KNOWN, C_PetJournal.GetNumCollectedInfo(id))..FONT_COLOR_CODE_CLOSE
		else
			return str
		end
	end

------	点击链接无法正确指向宠物(修复处1)
--~ 	local GetPetInfoByPetIDtemp=C_PetJournal.GetPetInfoByPetID
--~ 	C_PetJournal.GetPetInfoByPetID=function(id)
--~ 		return GetPetInfoByPetIDtemp(IDtoString(id))
--~ 	end
--~ 	local GetPetStatstemp=C_PetJournal.GetPetStats
--~ 	C_PetJournal.GetPetStats=function(id)
--~ 		return GetPetStatstemp(IDtoString(id))
--~ 	end---屏蔽掉.这段代码会导致战斗中无法拖拽宠物图标
	-----------------
end


--[[	Hook	]]--petjournal
--抓获宠物得到的链接，petid缺少"0x"，ItemRef:255,FloatingBattlePet_Toggle
--PetJournal_SelectPet(PetJournal,"0x000000000124D362")
------	点击链接无法正确指向宠物(修复处2)
hookPetJournal.PetJournal_SelectPet = function(self, targetPetID,...)
	local numPets = C_PetJournal.GetNumPets(PetJournal.isWild);
	local petIndex = nil;
	local targetPetID = targetPetID
	for i = 1,numPets do
		local petID, speciesID, owned = C_PetJournal.GetPetInfoByIndex(i, PetJournal.isWild);
		if (petID == targetPetID) then
			petIndex = i;
			break;
		end
	end
	if ( petIndex ) then
		PetJournalPetList_UpdateScrollPos(self.listScroll, petIndex);
	end
	PetJournal_ShowPetCardByID(targetPetID);
end
----- 显示宠物/记录breedid (对没有标示品质的宠物进行标示品质)--5.1已有
hookPetJournal.PetJournal_UpdatePetCard=function(self)
	local strbreedID=""
	if PetJournalPetCard.petID then
		local ghealth, gpower, gspeed, breedID = HPetBattleAny.ShowMaxValue(PetJournalPetCard.petID)
		if ghealth then
			self.HealthFrame.health:SetText(format("%s%s",self.HealthFrame.health:GetText(),ghealth))
			self.PowerFrame.power:SetText(format("%s%s",self.PowerFrame.power:GetText(),gpower))
			self.SpeedFrame.speed:SetText(format("%s%s",self.SpeedFrame.speed:GetText(),gspeed))
			if breedID and HPetSaves.ShowBreedID then
				if HPetSaves.BreedIDStyle then
--~ 					strbreedID = "("..(breedID <=12 and breedID or (breedID-10)).."/"..(breedID<=12 and (breedID+10) or breedID)..")"
					strbreedID = "("..breedID..")"
				else
					strbreedID = "("..HPetBattleAny.GetBreedNames[breedID]..")"
				end
			end
			PetJournalPetCard.breedID=breedID
		end
	else
		PetJournalPetCard.breedID=nil
	end
	if PetJournalPetCard.speciesID then
		local petType=select(3,C_PetJournal.GetPetInfoBySpeciesID(PetJournalPetCard.speciesID))
		if HPetSaves.ShowHideID then
			PetJournalPetCard.TypeInfo.type:SetText("("..PetJournalPetCard.speciesID..")".._G["BATTLE_PET_NAME_"..petType]..strbreedID)
		else
			PetJournalPetCard.TypeInfo.type:SetText(_G["BATTLE_PET_NAME_"..petType]..strbreedID)
		end
	end

	-------------------显示选择好的技能组合
	if PetJournalPetCard.speciesID and HPetSaves.AutoSaveAbility and HPetSaves["PetAbilitys"] then
		local str = HPetSaves.PetAbilitys[PetJournalPetCard.petID] or "123"
		for i = 1,3 do
			local d = tonumber(string.sub(str,i,i))
			if d == 0 then d = i end
			_G["PetJournalPetCardSpell"..d].icon:SetVertexColor(1,1,1,1)
			if _G["PetJournalPetCardSpell"..((d>3) and (d-3) or (d+3))].LevelRequirement:IsShown() then
				_G["PetJournalPetCardSpell"..((d>3) and (d-3) or (d+3))].icon:SetVertexColor(1,1,1,1)
			else
				_G["PetJournalPetCardSpell"..((d>3) and (d-3) or (d+3))].icon:SetVertexColor(0.4,0.4,0.4,1)
			end
		end
	end
end

-----------function temp PetJournalScrollButtonTooltip,滚动条图标鼠标提示样本
hookPetJournal.PJSTooltip = function(self)
	local speciesID = self:GetParent().speciesID or self.speciesID
	local petID = self:GetParent().petID or self.petID

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");

	if not IsControlKeyDown() and petID then
		----属性提示
		local _, maxHealth, power, speed, quality = C_PetJournal.GetPetStats(petID)
		local speciesID, customName, level = C_PetJournal.GetPetInfoByPetID(petID)
		BattlePetToolTip_Show(speciesID, level, quality-1, maxHealth, power, speed, customName)
	elseif speciesID then
		local name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
		----默认提示
		BattlePetTooltip:Hide()
		if ( sourceText and sourceText ~= "" ) then
			--清除sourceText最后可能存在的"\n"
			if sourceText:sub(#sourceText,#sourceText) == "n" then sourceText = sourceText:sub(1,#sourceText-2) end
			GameTooltip:SetText(name, 1, 1, 1);
			GameTooltip:AddLine(sourceText, 1, 1, 1, true);
			if ( not tradable ) then
				GameTooltip:AddLine(BATTLE_PET_NOT_TRADABLE, 1, 0.1, 0.1, true);
			end
			if ( unique ) then
				GameTooltip:AddLine(ITEM_UNIQUE, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true);
			end
			if ( description and description ~= "" ) then
				GameTooltip:AddLine(" ");
				GameTooltip:AddLine(description, nil, nil, nil, true);
			end
			GameTooltip:Show();
		end
	end
end


---------------------------自动保存设置宠物技能组合
hookPetJournal.SetAbility = function(loadoutID,index,abilityID,stop)
	if not HPetSaves.AutoSaveAbility or stop then return end
	if not HPetSaves.PetAbilitys then HPetSaves.PetAbilitys={} end

	local abilities = PetJournal.Loadout["Pet"..loadoutID].abilities
	if not abilities then return end

	local petID = C_PetJournal.GetPetLoadOutInfo(loadoutID)
	local pos
	if abilityID == abilities[index] then
		pos = string.gsub("%1%2%3","(.*)(%%"..index..")(.*)","%1"..index.."%3")
	elseif abilityID == abilities[index+3] then
		pos = string.gsub("%1%2%3","(.*)(%%"..index..")(.*)","%1"..(index+3).."%3")
	end
	if pos then
		HPetSaves.PetAbilitys[petID] = string.gsub(HPetSaves.PetAbilitys[petID] or "123","^(.)(.)(.)$",pos)
	end

	if petID == PetJournalPetCard.petID then
		PetJournal_UpdatePetCard(PetJournalPetCard)
	end
end

hookPetJournal.SetPetLoadOutInfo = function(loadoutID,petID,stop)
	if C_PetBattles.IsInBattle() then return end
	if not HPetSaves.AutoSaveAbility or stop then return end
	if not HPetSaves.PetAbilitys then HPetSaves.PetAbilitys={} end

	local str = HPetSaves.PetAbilitys[petID]
	if not str then return end
	local petID,aID1,aID2,aID3 = C_PetJournal.GetPetLoadOutInfo(loadoutID)
	local aID={aID1,aID2,aID3}
	local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
	local abilities = C_PetJournal.GetPetAbilityList(speciesID)
	for i = 1,3 do
		local skindex = tonumber(string.sub(str,i,i))
		local abilityID = abilities[skindex]
		if abilityID and abilityID~=aID[i] then
			C_PetJournal.SetAbility(loadoutID, i, abilityID, true)
		end
	end
end



hookPetJournal.PetJournal_PetCount_OnEnter = function(self)
	GameTooltip:AddLine("")
	local F,B,C,FB,FC,BC,FBC = 0,0,0,0,0,0,0
	if not HPetBattleAny.HasPet[0] then
		for key,value in pairs(HPetBattleAny.HasPet) do
			C = C + 1
			local HF,HB,HFB
			for i,petID in pairs(value) do
				local rarity ,level = HPetBattleAny:GetPetInfo(key,i,true)
				if rarity == 4 then B = B + 1;HB=true end
				if level == 25 then F = F + 1;HF=true end
				if rarity == 4 and level == 25 then FB = FB + 1;HFB=true end
			end
			FC = FC + (HF and 1 or 0)
			BC = BC + (HB  and 1 or 0)
			FBC = FBC + (HFB and 1 or 0)
		end
	end
	GameTooltip:AddLine("满级:"..F.."\n蓝色:"..B.."\n独特:"
	..C.."\n满级蓝色:"..FB.."\n满级独特:"..FC.."\n蓝色独特:"
	..BC.."\n满级蓝色独特:"..FBC
	, 1, 1, 1);
	GameTooltip:Show();
end
--[[	Hook	]]--petbattle
--------------------		鼠标提示/头像
hookfunction.PetBattleUnitTooltip_UpdateForUnit = function(self, petOwner, petIndex)
	local r,g,b,hex=GetItemQualityColor(C_PetBattles.GetBreedQuality(petOwner,petIndex)-1)
	local speciesID=C_PetBattles.GetPetSpeciesID(petOwner,petIndex)
	local name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
	local strbreedID=""
------- 成长值
	GameTooltip:SetOwner(self,"ANCHOR_BOTTOM");
	if petOwner == LE_BATTLE_PET_ENEMY and HPetBattleAny.EnemyPetInfo[petIndex] then
		local EnemyPet=HPetBattleAny.EnemyPetInfo[petIndex]
		local ghealth, gpower, gspeed, breedID = HPetBattleAny.ShowMaxValue("EnemyPet",petIndex)
		if ghealth~="" and ghealth~=nil then
			local str=""
			if HPetSaves.PetBreedInfo then
				str=L["Breed Point"]
			elseif HPetSaves.PetGreedInfo then
				str=L["Greed Point"]
			else
				str=L["Grow Point"]
			end
			local BreedID = ""
			if HPetSaves.ShowBreedID and breedID then
				BreedID = "("..(HPetSaves.BreedIDStyle and breedID or HPetBattleAny.GetBreedNames[breedID])..")"
			end
			GameTooltip:AddDoubleLine(str,"|c"..hex..ghealth.."/"..gpower.."/"..gspeed.."|r"..BreedID)
			GameTooltip:Show();
		end
	end

-----	加入收集信息
	TooltipAddOtherInfo(speciesID)

----- 	技能CD
	if true then
		self.AbilitiesLabel:Show();
		local enemyPetType = C_PetBattles.GetPetType(PetBattleUtil_GetOtherPlayer(petOwner), C_PetBattles.GetActivePet(PetBattleUtil_GetOtherPlayer(petOwner)));
		for i = 1, NUM_BATTLE_PET_ABILITIES do
			local id, name, icon, maxCooldown, description, numTurns, abilityPetType, noStrongWeakHints = C_PetBattles.GetAbilityInfo(petOwner, petIndex, i);
			if not id and not C_PetBattles.IsPlayerNPC(petOwner) and HPetBattleAny.AbilityModules.GetAbilityInfo then
				id, name, icon, maxCooldown, description, numTurns, abilityPetType, noStrongWeakHints = HPetBattleAny.AbilityModules.GetAbilityInfo(petOwner, petIndex, i, true);
			end

			local abilityIcon = self["AbilityIcon"..i];
			local abilityName = self["AbilityName"..i];
			if id or name then
				local CanUse, abilityCD = C_PetBattles.GetAbilityState(petOwner,petIndex,i)
				if CanUse then
					name = "|cffffff00"..name.."|r"
				else
					name = "|cffff0000"..name.."|r"
				end

				if not maxCooldown then
					name = name.." "..abilityCD.."|r"
				elseif abilityCD~=0 then
					name = name.." "..abilityCD.."/"..maxCooldown.."|r"
				elseif maxCooldown ~= 0 then
					name = name.." "..maxCooldown.."|r"
				end

				abilityName:SetText(name)

				if not abilityName:IsShown() then
					local modifier = 1.0;
					if (abilityPetType and enemyPetType) then
						modifier = C_PetBattles.GetAttackModifier(abilityPetType, enemyPetType);
					end

					if ( noStrongWeakHints or modifier == 1 ) then
						abilityIcon:SetTexture("Interface\\PetBattles\\BattleBar-AbilityBadge-Neutral");
					elseif ( modifier < 1 ) then
						abilityIcon:SetTexture("Interface\\PetBattles\\BattleBar-AbilityBadge-Weak");
					elseif ( modifier > 1 ) then
						abilityIcon:SetTexture("Interface\\PetBattles\\BattleBar-AbilityBadge-Strong");
					end

					abilityIcon:Show();
					abilityName:Show();
				end
			end
		end
	end

	if not self.Buffs then
		self.Buffs = CreateFrame("FRAME",nil,self)
		self.Buffs:SetPoint("TOPLEFT",self.Delimiter2,"BOTTOMLEFT",8,-10)
		self.Buffs:SetSize(250,0)
		self.Buffs.frames = {}
		self.Buffs.template = "PetBattleUnitTooltipAuraTemplate"
	end
	local nextFrame = 1;
	local buffs = self.Buffs;
	local buffsHeight = 0;
	for i=1, C_PetBattles.GetNumAuras(petOwner, petIndex) do
		local auraID, instanceID, turnsRemaining, isBuff = C_PetBattles.GetAuraInfo(petOwner, petIndex, i);
		if (isBuff) then
			--We want to display this frame.
			local frame = buffs.frames[nextFrame];
			if ( not frame ) then
				--No frame, create one
				buffs.frames[nextFrame] = CreateFrame("FRAME", nil, buffs, buffs.template);
				frame = buffs.frames[nextFrame];
				frame.DebuffBorder:Hide()

				--Anchor the new frame
				if ( nextFrame == 1 ) then
					frame:SetPoint("TOPLEFT", buffs, "TOPLEFT", 0, 0);
				else
					frame:SetPoint("TOPLEFT", buffs.frames[nextFrame - 1], "BOTTOMLEFT", 0, -6);
				end
			end

			--Update the actual aura
			local id, name, icon, maxCooldown, description = C_PetBattles.GetAbilityInfoByID(auraID);

			frame.Icon:SetTexture(icon);
			frame.Name:SetText(name);
			if ( turnsRemaining < 0 ) then
				frame.Duration:SetText("");
			else
				frame.Duration:SetFormattedText(PET_BATTLE_AURA_TURNS_REMAINING, turnsRemaining);
			end

			frame.auraIndex = i;
			frame:Show();

			nextFrame = nextFrame + 1;
			buffsHeight = buffsHeight + 40;
		end
	end

	for i=nextFrame, #buffs.frames do
		buffs.frames[i]:Hide();
	end

	if (nextFrame > 1) then
		buffs:Show()
		self.Delimiter2:Show()
		buffsHeight = buffsHeight + 5 --extra padding to go below the debuffs
	else
		if not self.Debuffs:IsShown() then self.Delimiter2:Hide() end
		buffs:Hide()
	end
	local debuffsHeight = self.Debuffs:GetHeight()
	local height = self:GetHeight()
	buffs:SetHeight(buffsHeight);
	buffs:SetPoint("TOPLEFT",self.Delimiter2,"BOTTOMLEFT",8,-10-debuffsHeight)
	height = height + buffsHeight;
	self:SetHeight(height);
end
--------------------		UnitFrame上色(self.Name上色留下了，貌似还有用处)
hookfunction.PetBattleUnitFrame_UpdateDisplay=function(self)
	if self.petOwner and self.petIndex and self.petIndex <= C_PetBattles.GetNumPets(self.petOwner)  then
		local rarity = C_PetBattles.GetBreedQuality(self.petOwner,self.petIndex)
		local r,g,b = GetItemQualityColor(rarity-1)
		if self.Name then
			self.Name:SetVertexColor(r, g, b);
		end

		if self.Icon then
			if not self.glow then
				self.glow = self:CreateTexture(nil, 'ARTWORK', nil, 2)
				self.glow:SetTexture('Interface/Buttons/UI-ActionButton-Border')
				self.glow:SetSize(self.Icon:GetWidth() * 1.7, self.Icon:GetHeight() * 1.7)
				self.glow:SetPoint('CENTER', self.Icon, 1, 1)
				self.glow:SetBlendMode('ADD')
				self.glow:SetAlpha(.7)
			end
			self.glow:SetVertexColor(r,g,b)
			if not self.BorderAlive and not HPetSaves.HighGlow then
				self.glow:Hide()
			end
		end
	end
end

----- 宠物对战的时候，鼠标放置技能上面。tooltip固定到了右下角。但是放在被动上面却依附在鼠标附近。这应该算是个bug，所以我hook这一段，进行了一点点修改
hookfunction.PetBattleAbilityButton_OnEnter= function(self)
	local petIndex = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY);
	if ( self:GetEffectiveAlpha() > 0 and C_PetBattles.GetAbilityInfo(LE_BATTLE_PET_ALLY, petIndex, self:GetID()) ) then
		PetBattleAbilityTooltip_SetAbility(LE_BATTLE_PET_ALLY, petIndex, self:GetID());
		PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPRIGHT", 0, 0, self.additionalText);
	elseif ( self.abilityID ) then
		PetBattleAbilityTooltip_SetAbilityByID(LE_BATTLE_PET_ALLY, petIndex, self.abilityID, format(PET_ABILITY_REQUIRES_LEVEL, self.requiredLevel));
		PetBattleAbilityTooltip_Show("BOTTOMLEFT", self, "TOPRIGHT", 0, 0);
	else
		PetBattlePrimaryAbilityTooltip:Hide();
	end
end
----- 点击未收集的宠物链接直接链接到宠物日志
hookfunction.FloatingBattlePet_Show=function(speciesID,level)
	if level==0 then
		FloatingBattlePetTooltip:Hide()
		if (not CollectionsJournal) then
			CollectionsJournal_LoadUI();
		end
		if (not CollectionsJournal:IsShown()) then
			ShowUIPanel(CollectionsJournal);
		end
		if not UnitAffectingCombat("player") then CollectionsJournal_SetTab(CollectionsJournal, 2) end
		if (speciesID and speciesID > 0) then
			PetJournal_SelectSpecies(PetJournal, speciesID)
		end
	end
----- 战宠提示框
	local owned = C_PetJournal.GetOwnedBattlePetString(speciesID);
	if owned ~= nil then
		local str = GetOwnedInfo(owned,speciesID)
		if str then FloatingBattlePetTooltip.Owned:SetText(str) end
	end
end
----- 战宠鼠标提示
hookfunction.BattlePetToolTip_Show=function(speciesID, level, breedQuality, maxHealth, power, speed, customName)
	local owned = C_PetJournal.GetOwnedBattlePetString(speciesID);
	if owned ~= nil then
		local str = GetOwnedInfo(owned,speciesID)
		if str then BattlePetTooltip.Owned:SetText(str) end
----- 修复该鼠标大小问题
		BattlePetTooltip:SetSize(260,140)
	end
end
----- 战斗宠物提示tooltip(收集提示已自带5.1)
hookfunction.BattlePetTooltipTemplate_SetBattlePet=function(frame,data)
	if data.level ~=0 and data.breedQuality~=-1 then
		local ghealth, gpower, gspeed, breedID = HPetBattleAny.ShowMaxValue(data.speciesID,data.level,data.maxHealth,data.power,data.speed,data.breedQuality+1)
		frame.Health:SetText(format("%d%s",data.maxHealth,ghealth))
		frame.Power:SetText(format("%d%s",data.power,gpower))
		frame.Speed:SetText(format("%d%s",data.speed,gspeed))
		if breedID and HPetSaves.ShowBreedID then
			if HPetSaves.BreedIDStyle then
				frame.PetType:SetText(format("%s(%s)",_G["BATTLE_PET_NAME_"..data.petType],breedID))
			else
				frame.PetType:SetText(format("%s(%s)",_G["BATTLE_PET_NAME_"..data.petType],HPetBattleAny.GetBreedNames[breedID]))
			end
		end
		if not frame.Name:GetText() then frame.Name:SetText(data.customName) end
	end
end

----- 点击头像,链接到宠物日志
hookfunction.PetBattleUnitFrame_OnClick=function(self,button)
	if button=="LeftButton" then
		local speciesID = C_PetBattles.GetPetSpeciesID(self.petOwner,self.petIndex)

		if speciesID then hookfunction.FloatingBattlePet_Show(speciesID,0) end

		if self.petOwner == 1 then
			for i = 1, C_PetBattles.GetNumPets(self.petOwner) do
				local petID = C_PetJournal.GetPetLoadOutInfo(i)
				local tspeciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType= C_PetJournal.GetPetInfoByPetID(petID)
				if tspeciesID == speciesID and C_PetBattles.GetLevel(self.petOwner,self.petIndex) == level and C_PetBattles.GetXP(self.petOwner,self.petIndex) == xp and C_PetBattles.GetPetType(self.petOwner,self.petIndex) == petType and C_PetBattles.GetName(self.petOwner,self.petIndex) == (customName or name) and select(2,C_PetBattles.GetName(self.petOwner,self.petIndex)) == name then
					PetJournal_SelectPet(PetJournal,petID)
					return
				end
			end
		elseif self.petOwner == 2  then
			if HPetAllInfoFrame then
				local breedID,rarity,level ;
				if(HPetBattleAny.EnemyPetInfo[self.petIndex]) then
					breedID,rarity,level = HPetBattleAny.EnemyPetInfo[self.petIndex].breedID,HPetBattleAny.EnemyPetInfo[self.petIndex][5],HPetBattleAny.EnemyPetInfo[self.petIndex][1]
				end
				if HPetSaves.lockEnemy then
					if breedID~=HPetAllInfoFrame.breedID or speciesID~=HPetAllInfoFrame.speciesID or not HPetAllInfoFrame:IsShown() then
						HPetAllInfoFrame:Update(speciesID,breedID,rarity,level)
					end
				else
					HPetAllInfoFrame:Update(speciesID,breedID)
				end
				HPetAllInfoFrame:Show()
			end
		end
	end
end


----- 修复宠物对战中一些快捷键失效的问题
hookfunction.PetBattleFrame_ButtonDown=function(id,func)
	if id==6 or id==12 then
		local button
		if id==6 then
			button = PetBattleFrame.BottomFrame.ForfeitButton
			if (not button) then
				return;
			end
		elseif id==12 then
			button = PetBattleFrame.BottomFrame.TurnTimer.SkipButton
			if (not button) then
				return;
			end
			if ( button:IsEnabled() ) then
				button.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
				button.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
				button.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
			end
		end
		if ( button:GetButtonState() == "NORMAL" ) then
			button:SetButtonState("PUSHED");
		end
		if ( GetCVarBool("ActionButtonUseKeydown") ) then
			local forfeitPenalty,staticFrame = C_PetBattles.GetForfeitPenalty(),nil
			if(forfeitPenalty == 0) then
				_,staticFrame = StaticPopup_Visible("PET_BATTLE_FORFEIT_NO_PENALTY")
			else
				_,staticFrame = StaticPopup_Visible("PET_BATTLE_FORFEIT")
			end
			if id == 6 and staticFrame then
				if(forfeitPenalty == 0) then
					StaticPopup_Hide("PET_BATTLE_FORFEIT_NO_PENALTY",nil);
				else
					StaticPopup_Hide("PET_BATTLE_FORFEIT",nil);
				end
				button:SetButtonState("NORMAL");
			else
				button:Click();
			end
		end
	end
	if PetBattleFrame.BottomFrame.PetSelectionFrame:IsShown() then
		if id==1 or id==2 or id==3 then
			return
		end
	end
	func(id)
end

hookfunction.PetBattleFrame_ButtonUp=function(id,func)
	if id==4 or id== 5 or id==6 or id==12 then
		local button
		if id==4 then
			button=PetBattleFrame.BottomFrame["SwitchPetButton"]
		elseif id==5 then
			button=PetBattleFrame.BottomFrame["CatchButton"]
		elseif id==6 then
			button=PetBattleFrame.BottomFrame["ForfeitButton"]
		elseif id==12 then
			button = PetBattleFrame.BottomFrame.TurnTimer.SkipButton
			if ( button:IsEnabled() ) then
				button.Left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
				button.Middle:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
				button.Right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
			end
		else
			return
		end
		if ( button:GetButtonState() == "PUSHED" ) then
			button:SetButtonState("NORMAL");
			if ( not GetCVarBool("ActionButtonUseKeydown") ) and not ( IsModifiedClick() ) then
				local forfeitPenalty,staticFrame = C_PetBattles.GetForfeitPenalty(),nil
				if(forfeitPenalty == 0) then
					_,staticFrame = StaticPopup_Visible("PET_BATTLE_FORFEIT_NO_PENALTY")
				else
					_,staticFrame = StaticPopup_Visible("PET_BATTLE_FORFEIT")
				end
				if id == 6 and staticFrame then
					if(forfeitPenalty == 0) then
						StaticPopup_Hide("PET_BATTLE_FORFEIT_NO_PENALTY",nil);
					else
						StaticPopup_Hide("PET_BATTLE_FORFEIT",nil);
					end
					button:SetButtonState("NORMAL");
				else
					button:Click();
				end
			end
		end
	else
		if PetBattleFrame.BottomFrame.PetSelectionFrame:IsShown() then
			if C_PetBattles.CanPetSwapIn(id) then
				C_PetBattles.ChangePet(id);
				PetBattlePetSelectionFrame_Hide(PetBattleFrame.BottomFrame.PetSelectionFrame);
			end
			return
		end
		func(id)
	end
end
hookfunction.PetBattleFrame_UpdateAbilityButtonHotKeys=function(self)
	PetBattleAbilityButton_UpdateHotKey(self.BottomFrame.ForfeitButton);
	local button=PetBattleFrame.BottomFrame.TurnTimer.SkipButton
	if not button[HotKey] then
		button.HotKey=button:CreateFontString(nil,"OVERLAY","NumberFontNormalSmallGray")
		button.HotKey:SetPoint("TOPRIGHT",-1,-2)
	end
	local key = GetBindingKey("ACTIONBUTTON12");
	if ( key ) then
		button.HotKey:SetText(key);
		button.HotKey:Show();
	else
		button.HotKey:Hide();
	end
end
hookfunction.StaticPopup_Show=function(str)
	if (str=="PET_BATTLE_FORFEIT" or str=="PET_BATTLE_FORFEIT_NO_PENALTY") and HPetSaves.FastForfeit then
		if not HPetSaves.Sound and HPetBattleAny.EnemyPetInfo and HPetBattleAny.EnemyPetInfo.FindBlue then
		else
			local forfeitPenalty = C_PetBattles.GetForfeitPenalty();
			if(forfeitPenalty == 0) then
				StaticPopup_Hide("PET_BATTLE_FORFEIT_NO_PENALTY",nil);
			else
				StaticPopup_Hide("PET_BATTLE_FORFEIT",nil);
			end
			C_PetBattles.ForfeitGame()
		end
	end
end

----技能ID
hookfunction.SharedPetBattleAbilityTooltip_SetAbility=function(self, abilityInfo, additionalTex)
	if not HPetSaves.ShowHideID then return end
	local abilityID = abilityInfo:GetAbilityID();
	if not abilityID then return end
	local name = select(2, C_PetBattles.GetAbilityInfoByID(abilityID))
	self.Name:SetText(name.."("..abilityID..")");
end









-----------小地图提示增强
-----------避免错误目标(奇葩名字)的更加稳妥的补充:1.记录当前target/focus的目标(的GUID),2.target/focus到鼠标指向的名称,3.获取target/focus的信息.
local HookMiniMap={}
HookMiniMap.oldtext=""
HookMiniMap.changetxtfunc = function(value)
	local petName, hasIcon = string.gsub(value,"\124T.-\124t","")
	petName = string.match(petName,"\124[cC]%w%w%w%w%w%w%w%w(.+)\124[rR]") or petName
	local speciesID = C_PetJournal.FindPetIDByName(petName)
	if speciesID then
		local str = C_PetJournal.GetOwnedBattlePetString(speciesID)
		if str then
			local icon = "\124T".."Interface\\Icons\\Pet_TYPE_"..PET_TYPE_SUFFIX[select(3,C_PetJournal.GetPetInfoBySpeciesID(speciesID))]..":12:12:0:0:0:0:0:0:0:0\124t"
			value = (hasIcon ~= 0) and string.gsub(value,"^(\124T.-\124t)(.+)$","%1"..icon.."%2") or icon..value
			if HPetSaves.Tooltip then
				value = value.." "..(GetOwnedInfo(str,speciesID,true) or "")
			end
		end
	end
	return value
end
HookMiniMap.func = function(self)
	if Minimap:IsVisible() and MouseIsOver(Minimap) and self:IsVisible() and self:IsOwned(Minimap) then
		local tooltiptxt = GameTooltipTextLeft1:IsVisible() and GameTooltipTextLeft1:GetText()
		if tooltiptxt and tooltiptxt ~= HookMiniMap.oldtext then
			HookMiniMap.oldtext = string.gsub(tooltiptxt, "[^\n]+",HookMiniMap.changetxtfunc)
			_G[self:GetName().."TextLeft1"]:SetText(HookMiniMap.oldtext)
			self:Show()
		end
	end
end
hooksecurefunc(GameTooltip,"SetScript",function()
	GameTooltip:HookScript('OnUpdate',HookMiniMap.func)
end)
GameTooltip:HookScript('OnUpdate',HookMiniMap.func)

--[[			]]--其他界面隐藏/显示
--~ local AutoFrameSave={}
hookfunction.AddFrameLock=function(lock)
	if lock == "PETBATTLES" then
		for k,s in pairs(HPetBattleAny.AutoHideShowfrmae) do
			local v = _G[k]
			if v then
				if type(v["originalShow"]) == "function" and not UnitAffectingCombat("player") then
--~ 					if k == "MinimapCluster" then
--~ 						AutoFrameSave[k] = {v:GetPoint()}
--~ 						AutoFrameSave[k][2] = AutoFrameSave[k][2] and AutoFrameSave[k][2]:GetName() or nil
--~ 						MinimapCluster:SetPoint("TOPRIGHT",nil,"TOPRIGHT",0,0)
--~ 						print("偏移原位")
--~ 					end
					v:originalShow()
				elseif type(v["Show"]) == "function" then
					HPetBattleAny.AutoHideShowfrmae[k]=v:IsShown() and "Shown" or "Hidden"
					if HPetBattleAny.AutoHideShowfrmae[k]=="Shown" then v:Hide() end
				end
			end
		end
	end
end
hookfunction.RemoveFrameLock=function(lock)
	if lock == "PETBATTLES" then
		for k,s in pairs(HPetBattleAny.AutoHideShowfrmae) do
			local v = _G[k]
			if v then
--~ 						if k == "MinimapCluster" then
--~ 							local a = AutoFrameSave[k]
--~ 							v:SetPoint(a[1],a[2],a[3],a[4],a[5])
--~ 						end
				if type(v["originalShow"]) ~= "function" and type(v["Show"]) == "function" then
					if HPetBattleAny.AutoHideShowfrmae[k]=="Shown" then
						v:Show()
					end
				end
			end
		end
	end
end

local PJHOOK = function(...)
	local name = select(2,...)
	if name == "PetJournalEnhancedListScrollFrameButton12" then
		for i = 1,12 do
			_G["PetJournalEnhancedListScrollFrameButton"..i].dragButton:HookScript("OnEnter",hookPetJournal.PJSTooltip)
			_G["PetJournalEnhancedListScrollFrameButton"..i].dragButton:HookScript("OnLeave",GameTooltip_Hide)
		end
		PJHOOK=nil
	end
end
if GetAddOnInfo("PetJournalEnhanced") then hooksecurefunc("CreateFrame",PJHOOK)end
C_PetJournal.SetPetSortParameter(2)
