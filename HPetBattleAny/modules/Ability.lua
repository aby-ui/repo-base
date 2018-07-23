-----####Ability.lua 1.7####
----------1.7: 增加敌方后排技能/己方技能
----------1.71: 增加HPetBattleAny.AllAbilityUpdate,用来总体刷新
----------1.72: 调整了六图标模式,图标的位置(避免挡住名字)/姓名条上加入鼠标提示(beta).
----------1.73: Update中,隐藏图标数量,不再限定事件"PET_BATTLE_OPENING_START"(为了配合Watch模式)

----------1.74:abilityframe在每次进入游戏时都会全部载入(6个),非常不好.(0.1,一点改进:第一次进入对战才进行全部载入)
----------1.75:将pvp对战中获取敌方技能的调试代码屏蔽掉.
--~ Globals
local _G = getfenv(0)
local hooksecurefunc, tinsert, pairs, wipe = _G.hooksecurefunc, _G.table.insert, _G.pairs, _G.wipe
local ipairs = _G.ipairs
local C_PetJournal = _G.C_PetJournal
local addonname,addon = ...
local L = addon.L
local AbilityModules={}
HPetBattleAny.AbilityModules=AbilityModules

AbilityModules.GetAbilityInfo = function(petOwner, petIndex, i, minmod)
	if not C_PetBattles.IsPlayerNPC(petOwner) and petOwner~=1 then
		if not minmod then
			local petlevel = C_PetBattles.GetLevel(petOwner,petIndex)
			local speciesID = C_PetBattles.GetPetSpeciesID(petOwner, petIndex);
			local abilities, abilityLevels = C_PetJournal.GetPetAbilityList(speciesID);
			if petlevel >= abilityLevels[i] then		--标记2
				return C_PetBattles.GetAbilityInfoByID(abilities[i])
			end
		else
			local state = AbilityModules.EnemyPetAs[petIndex][i>3 and i-3 or i]
			if state.id then
				return C_PetBattles.GetAbilityInfoByID(state.id)
			elseif C_PetBattles.GetAbilityState(petOwner,petIndex,i)~=nil then	--标记1
				return nil,UNKNOWN
			end
		end
	else
		return C_PetBattles.GetAbilityInfo(petOwner, petIndex,i)
	end
end
--注释:在暴雪没真正封掉C_PetBattles.GetAbilityState的情况下,这2个判断等价
AbilityModules.GetAbilityState = function(petOwner, petIndex, i)
	if not C_PetBattles.IsPlayerNPC(petOwner) and petOwner~=1 then
		local state = AbilityModules.EnemyPetAs[petIndex][i>3 and i-3 or i]
		if not state.id then
			return true,0,0,nil,true
		else
			if (state.up) == (i>3) then
				return C_PetBattles.GetAbilityState(petOwner, petIndex, i>3 and i-3 or i)
			else
				return nil,nil,nil,true
			end
		end
	else
		return C_PetBattles.GetAbilityState(petOwner, petIndex, i)
	end
end
local SelfGetAbilityInfo=AbilityModules.GetAbilityInfo
local SelfGetAbilityState=AbilityModules.GetAbilityState

--~ --------
local function PetBattleAbilityButton_OnEnterhook(self)
	local petOwner ,petIndex = self:GetParent():GetPetXY()
	if ( self:GetEffectiveAlpha() > 0 and SelfGetAbilityInfo(petOwner, petIndex, self:GetID()) and C_PetBattles.IsPlayerNPC(petOwner)) then
		PetBattleAbilityTooltip_SetAbility(petOwner, petIndex, self:GetID());
		PetBattleAbilityTooltip_Show('BOTTOM', self, 'TOP',self.additionalText);
	elseif ( self.abilityID ) then
		PetBattleAbilityTooltip_SetAbilityByID(petOwner, petIndex, self.abilityID)
		PetBattleAbilityTooltip_Show('BOTTOM', self, 'TOP')
	else
		PetBattlePrimaryAbilityTooltip:Hide();
	end
end

local function PetBattleAbilityButton_UpdateBetterIconhook(self)
	if (not self.BetterIcon) then return end
	self.BetterIcon:Hide();

	local petOwner, petIndex= self:GetParent():GetPetXY()
	local enemypet = petOwner == LE_BATTLE_PET_ALLY and LE_BATTLE_PET_ENEMY or LE_BATTLE_PET_ALLY

	if (not petIndex) or (not petOwner) or (not enemypet) then
		return;
	end

	local petType, noStrongWeakHints, _;
	_, _, _, _, _, _, petType, noStrongWeakHints = SelfGetAbilityInfo(petOwner, petIndex, self:GetID());
	if (not petType) then
		return
	end

	-- 获取 Strong/Weak 图标,并显示到按钮.
	local enemyPetSlot = C_PetBattles.GetActivePet(enemypet);
	local enemyType = C_PetBattles.GetPetType(enemypet, enemyPetSlot);
	local modifier = C_PetBattles.GetAttackModifier(petType, enemyType);

	if ( noStrongWeakHints or modifier == 1 ) then
		self.BetterIcon:Hide();return;
	elseif (modifier > 1) then
		self.BetterIcon:SetTexture("Interface\\PetBattles\\BattleBar-AbilityBadge-Strong");
	elseif (modifier < 1) then
		self.BetterIcon:SetTexture("Interface\\PetBattles\\BattleBar-AbilityBadge-Weak");
	end
	self.BetterIcon:Show();
end

local function PetBattleAbilityButton_UpdateIconshook(self)
	local petOwner ,petIndex = self:GetParent():GetPetXY()
	local id, name, icon, maxCooldown, unparsedDescription, numTurns, petType, noStrongWeakHints = SelfGetAbilityInfo(petOwner, petIndex, self:GetID());
	self.abilityID = id;
	if ( not icon ) then
		icon = "Interface\\Icons\\INV_Misc_QuestionMark";
	end
	if ( not name ) then
		local speciesID = C_PetBattles.GetPetSpeciesID(petOwner, petIndex);
		local abilities,abilityLevels = C_PetJournal.GetPetAbilityList(speciesID or 0)
		self.abilityID = abilities and abilities[self:GetID()];
		if ( not self.abilityID ) then
			self.Icon:SetTexture("INTERFACE\\ICONS\\INV_Misc_Key_05");
			self:Hide();
		else
			name, icon = C_PetJournal.GetPetAbilityInfo(self.abilityID);
			self.Icon:SetTexture(icon);
			self.Lock:Show();
			self.requiredLevel = abilityLevels[self:GetID()];
		end
		self.Icon:SetVertexColor(1, 1, 1);
		self:Disable();
		return;
	end
	self.Icon:SetTexture(icon);
	self:Enable();
	self:Show();

	PetBattleAbilityButton_UpdateBetterIconhook(self);
end

local function PetBattleActionButton_UpdateStatehook(self)

	local petOwner ,petIndex = self:GetParent():GetPetXY()

	local actionType = self.actionType
	local actionIndex = self.actionIndex

	local _, usable, cooldown, hasSelected, isSelected, isLocked, isHidden;
	local selectedActionType, selectedActionIndex = C_PetBattles.GetSelectedAction();


	if ( selectedActionType ) then
		hasSelected = true
	end

	--获取usable/cooldown/locked的状态
	if ( actionType == LE_BATTLE_PET_ACTION_ABILITY ) then
		local _, name, icon = SelfGetAbilityInfo(petOwner, petIndex, actionIndex);
		if ( name ) then
			local isUsable, currentCooldown, _, lock, isAh= SelfGetAbilityState(petOwner, petIndex, actionIndex);
			usable, cooldown, isLocked= isUsable, currentCooldown, lock;
		else
			isLocked = true;
		end
	end
	if self:GetParent():IsDead() then isLocked = true end

	if ( isLocked ) then
		--Set the frame up to look like a cooldown, but with a required level
		if ( self.Icon ) then
			self.Icon:SetVertexColor(0.5, 0.5, 0.5);
			self.Icon:SetDesaturated(true);
		end
		self:SetAlpha(1);
		if ( self.CooldownShadow ) then
			self.CooldownShadow:Show();
		end
		if ( self.Cooldown ) then
			self.Cooldown:Hide();
		end
		if ( self.Lock ) then
			self.Lock:Show();
		end
		if ( self.AdditionalIcon ) then
			self.AdditionalIcon:SetVertexColor(0.5, 0.5, 0.5);
		end
		if ( self.BetterIcon ) then
			self.BetterIcon:Hide();
		end
	elseif ( cooldown and cooldown > 0 ) then
		--Set the frame up to look like a cooldown.
		if ( self.Icon ) then
			self.Icon:SetVertexColor(0.5, 0.5, 0.5);
			self.Icon:SetDesaturated(true);
		end
		self:SetAlpha(1);
		if ( self.CooldownShadow ) then
			self.CooldownShadow:Show();
		end
		if ( self.Cooldown ) then
			self.Cooldown:SetText(cooldown);
			self.Cooldown:Show();
		end
		if ( self.Lock ) then
			self.Lock:Hide();
		end
		if ( self.AdditionalIcon ) then
			self.AdditionalIcon:SetVertexColor(0.5, 0.5, 0.5);
		end
	elseif ( not usable or (hasSelected and not isSelected) ) then
		--Set the frame up to look unusable.
		if ( self.Icon ) then
			self.Icon:SetVertexColor(0.5, 0.5, 0.5);
			self.Icon:SetDesaturated(true);
		end
		self:SetAlpha(1);
		if ( self.CooldownShadow ) then
			self.CooldownShadow:Hide();
		end
		if ( self.Cooldown ) then
			self.Cooldown:Hide();
		end
		if ( self.Lock ) then
			self.Lock:Hide();
		end
		if ( self.AdditionalIcon ) then
			self.AdditionalIcon:SetVertexColor(0.5, 0.5, 0.5);
		end
	else
		--Set the frame up to look clickable/usable.
		if ( self.Icon ) then
			if isAh then
				self.Icon:SetVertexColor(0.4,0.4,0.4,1)
			else
				self.Icon:SetVertexColor(1, 1, 1);
			end
			self.Icon:SetDesaturated(false);
		end
		self:SetAlpha(1);
		if ( self.CooldownShadow ) then
			self.CooldownShadow:Hide();
		end
		if ( self.Cooldown ) then
			self.Cooldown:Hide();
		end
		if ( self.Lock ) then
			self.Lock:Hide();
		end
		if ( self.AdditionalIcon ) then
			self.AdditionalIcon:SetVertexColor(1, 1, 1);
		end
		if (self.CooldownFlash ) then
			self.CooldownFlashAnim:Play();
		end
	end
end


local Backdrop={
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	}

function CreateAbilityList(targetname,rpoints)
	local frame = CreateFrame("frame","HAbiFrame"..targetname,PetBattleFrame)

	function frame:Init(unit)
		self:SetSize("175","30")
		self:SetToplevel(true)
	 	self:SetClampedToScreen(true)
		self:SetMovable(true)
--~ 		self:SetBackdrop(Backdrop);
--~ 		self:SetBackdropColor(0,0,0)
		self.unit=unit
		self.defaultPoint = rpoints

		self.text = self:CreateFontString(self:GetName().."Text","OVERLAY","GameFontNormal")
		self.text:SetPoint("CENTER")
		self.text:Hide()

--~ 		self:SetScript('OnEnter',function()
--~ 			local petOwner, petIndex = self:GetPetXY()
--~ 			PetBattleUnitTooltip_Attach(PetBattlePrimaryUnitTooltip, "TOPLEFT", self, "TOPRIGHT", 0, 0);
--~ 			PetBattleUnitTooltip_UpdateForUnit(PetBattlePrimaryUnitTooltip, petOwner, petIndex);
--~ 			PetBattlePrimaryUnitTooltip:Show();
--~ 		end)
--~ 		self:SetScript('OnLeave',function()
--~ 			if ( PetBattlePrimaryUnitTooltip:GetParent() == self ) then
--~ 				PetBattlePrimaryUnitTooltip:Hide();
--~ 			end
--~ 		end)
		self:SetScript('OnEvent',self.Update)
		self:RegisterEvent('PET_BATTLE_PET_CHANGED')
		self:RegisterEvent('PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE')
		self:RegisterEvent("PET_BATTLE_OPENING_START");
		self.init = true
		if C_PetBattles.IsInBattle() then self:Update() end
	end

	function frame:TextToggle(t)
		if t then
			self:SetBackdrop(Backdrop);
			self:SetBackdropColor(0,0,0)
			self.text:Show()
		else
			self:SetBackdrop(nil);
			self.text:Hide()
		end
	end

	function frame:GetPetXY()
		if PetBattleFrame and PetBattleFrame[self.unit] then
			return PetBattleFrame[self.unit].petOwner,PetBattleFrame[self.unit].petIndex---C_PetBattles.GetActivePet(PetBattleFrame[self.unit].petOwner)
		else
			return 2,1
		end
	end

	function frame:SetUnit(str)
		self.unit=str
		self:Update()
	end

	function frame:IsDead()
		local petOwner,petIndex = self:GetPetXY()
		return C_PetBattles.GetHealth(petOwner,petIndex)<=0
	end

	function frame:isEnble()
		return PetBattleFrame[self.unit]:IsShown()
	end

	function frame:Update(event)
		if self.AbilityButtons==nil then
			self.AbilityButtons={}
			self:InitButton()
			self:Ref()
		end
		local petOwner,petIndex = self:GetPetXY()
		local name = C_PetBattles.GetName(petOwner,petIndex)
		self.text:SetText(name)
		for i=1, (C_PetBattles.IsPlayerNPC(petOwner) or petOwner==1) and NUM_BATTLE_PET_ABILITIES or 6 do
			local button = self.AbilityButtons[i];
			PetBattleAbilityButton_UpdateIconshook(button);
			PetBattleActionButton_UpdateStatehook(button);
		end
		if (C_PetBattles.IsPlayerNPC(petOwner) or petOwner==1) then
			for i = 4, 6 do
				self.AbilityButtons[i]:Hide()
			end
		end
	end

	function frame:Ref()
		if not HPetSaves.AbPoint then HPetSaves.AbPoint={} end
		if not HPetSaves.AbPoint[targetname] then HPetSaves.AbPoint[targetname]= self.defaultPoint or {} end

		HPetSaves.AbScale=HPetSaves.AbScale or 0.8

		self:SetScale(HPetSaves.AbScale)
		self:ClearAllPoints();
		self:SetPoint(HPetSaves.AbPoint[targetname][1] or 'BOTTOM',
			_G[HPetSaves.AbPoint[targetname][2]] or nil,
			HPetSaves.AbPoint[targetname][3] or 'BOTTOM',
			HPetSaves.AbPoint[targetname][4] or '000',
			HPetSaves.AbPoint[targetname][5] or '540')
		self:TextToggle(HPetSaves.ShowAbilitysName)

		if (targetname:find("Enemy") and HPetSaves.EnemyAbility and (targetname:find("Active")  or HPetSaves.OtherAbility)) or
			(targetname:find("Ally") and HPetSaves.AllyAbility and HPetSaves.OtherAbility) then
			self:Show()
		else
			self:Hide()
		end
	end

	function frame:InitButton()
		for i= 1, 6 do
			local Button = self.AbilityButtons[i];
			if ( not Button ) then
				self.AbilityButtons[i] = CreateFrame("CheckButton", nil, self, "PetBattleAbilityButtonTemplate", i);
			end
			Button=self.AbilityButtons[i]

			Button:SetPoint('LEFT', (Button:GetWidth() + 5) * ((i<=3 and i or i-3)-1) + 5, i<=3 and -40 or -100)
			Button:SetScript('OnEnter', PetBattleAbilityButton_OnEnterhook)
			Button:RegisterForClicks("AnyUp")
			Button:SetScript('OnClick',function(self,button)
				if button == "MiddleButton" then
					HPetSaves.AbPoint[targetname]=frame.defaultPoint
					frame:Ref()
				end
			end)
			Button.HotKey:Hide()
			Button:RegisterForDrag("LeftButton")
			Button:SetScript("OnDragStart",function(self) if HPetSaves and not HPetSaves.LockAbilitys then self:GetParent():StartMoving() end end)
			Button:SetScript("OnDragStop",function(self)
				if HPetSaves and not HPetSaves.LockAbilitys then self:GetParent():StopMovingOrSizing() end
				if HPetSaves then
					HPetSaves.AbPoint[targetname] = {self:GetParent():GetPoint()}
					if HPetSaves.AbPoint[targetname][2] then HPetSaves.AbPoint[targetname][2]=HPetSaves.AbPoint[targetname][2]:GetName()end
				end

			end)

			Button:SetHighlightTexture(nil)
			Button:SetPushedTexture(nil)
			Button:UnregisterAllEvents()
			Button:SetClampedToScreen(true)

			Button = self.AbilityButtons[i];
			Button:Show()
			Button:SetFrameLevel(self:GetFrameLevel() + 1, Button);
		end
	end

	frame:Init(targetname)

	return frame
end
HPetBattleAny.EnemyAbilitys={}
HPetBattleAny.EnemyAbilitys.Update=function(self)
	for name,frame in pairs(self) do
		if type(frame)=="table" and frame.Update and frame:isEnble() then
			frame:Update()
		end
	end
end
HPetBattleAny.EnemyAbilitys.Ref=function(self)
	for name,frame in pairs(self) do
		if type(frame)=="table" and frame.Ref and frame:isEnble() then
			frame:Ref()
		end
	end
end

HPetBattleAny.AllyAbilitys={}
HPetBattleAny.AllyAbilitys.Update=function(self)
	for name,frame in pairs(self) do
		if type(frame)=="table" and frame.Update and frame:isEnble() then
			frame:Update()
		end
	end
end
HPetBattleAny.AllyAbilitys.Ref=function(self)
	for name,frame in pairs(self) do
		if type(frame)=="table" and frame.Ref and frame:isEnble() then
			frame:Ref()
--~ 			if HPetSaves.AllyAbility and (HPetSaves.OtherAbility) then
--~ 				frame:Show()
--~ 			else
--~ 				frame:Hide()
--~ 			end
		end
	end
end
HPetBattleAny.AllAbilityRef=function()
	HPetBattleAny.AllyAbilitys:Ref()
	HPetBattleAny.EnemyAbilitys:Ref()
end
HPetBattleAny.AllAbilityUpdate=function()
	HPetBattleAny.AllyAbilitys:Update()
	HPetBattleAny.AllyAbilitys:Ref()
	HPetBattleAny.EnemyAbilitys:Update()
	HPetBattleAny.EnemyAbilitys:Ref()
end

HPetBattleAny.FirstAbilitysLoad=function()
--~ 	if HPetSaves.EnemyAbility then
		HPetBattleAny.EnemyAbilitys["ActiveEnemy"] = HPetBattleAny.EnemyAbilitys["ActiveEnemy"] or CreateAbilityList("ActiveEnemy",{nil,nil,nil,nil,640})
--~ 	end

--~ 	if HPetSaves.OtherAbility then
		if HPetBattleAny.EnemyAbilitys["ActiveEnemy"] then
			HPetBattleAny.EnemyAbilitys["Enemy2"] = HPetBattleAny.EnemyAbilitys["Enemy2"] or CreateAbilityList("Enemy2",{"RIGHT",HPetBattleAny.EnemyAbilitys["ActiveEnemy"]:GetName(),"LEFT",400,0})
			HPetBattleAny.EnemyAbilitys["Enemy3"] = HPetBattleAny.EnemyAbilitys["Enemy3"] or CreateAbilityList("Enemy3",{"LEFT",HPetBattleAny.EnemyAbilitys["ActiveEnemy"]:GetName(),"RIGHT",-400,0})
		end
--~ 	end
--~ 	if HPetSaves.AllyAbility then
		if HPetSaves.OtherAbility then
			HPetBattleAny.AllyAbilitys["ActiveAlly"] = HPetBattleAny.AllyAbilitys["ActiveAlly"] or CreateAbilityList("ActiveAlly",{nil,nil,nil,nil,440})
			HPetBattleAny.AllyAbilitys["Ally2"] = HPetBattleAny.AllyAbilitys["Ally2"] or CreateAbilityList("Ally2",{"RIGHT",HPetBattleAny.AllyAbilitys["ActiveAlly"]:GetName(),"LEFT",400,0})---200,340)
			HPetBattleAny.AllyAbilitys["Ally3"] = HPetBattleAny.AllyAbilitys["Ally3"] or CreateAbilityList("Ally3",{"LEFT",HPetBattleAny.AllyAbilitys["ActiveAlly"]:GetName(),"RIGHT",-400,0})--200,340)
		end
--~ 	end
	HPetBattleAny.FirstAbilitysLoad=nil
end
hooksecurefunc(HPetBattleAny,"PET_BATTLE_OPENING_START",HPetBattleAny.FirstAbilitysLoad)

AbilityModules.EnemyPetAs={
	[1]={[1]={},[2]={},[3]={}},
	[2]={[1]={},[2]={},[3]={}},
	[3]={[1]={},[2]={},[3]={}},
}

local EnemyPetAs=AbilityModules.EnemyPetAs

local SetAbility = function(id)
	local ActIndex = C_PetBattles.GetActivePet(2)
	local speciesID = C_PetBattles.GetPetSpeciesID(2, ActIndex);
	local Astate = EnemyPetAs[ActIndex]
	local abilities, abilityLevels = C_PetJournal.GetPetAbilityList(speciesID);
	for i,v in pairs(abilities) do
		if v == id then
			Astate[i>3 and i-3 or i].id = id
			Astate[i>3 and i-3 or i].up = i > 3
		end
	end
--~ 	if Astate[1].id and Astate[2].id and Astate[3].id then EnemyPetAs.Lock		制作一个lock,在获取了改技能ID后,不再读取信息
end

local RefAbility = function(isclear)
	for _,v in pairs(EnemyPetAs) do
		for _,p in pairs(v) do
			if isclear then
				p.up=nil
				p.id=nil
			end
		end
--~ 		v.Lock = false
	end
end

local CP=C_PetBattles
local useA=nil
local tempPetHealths={}
local tempPetBuffs={}
local SavePetInfo = function()
	local ActIndex = C_PetBattles.GetActivePet(n)
	tempPetHealths[1]=CP.GetPower(1,ActIndex)
	tempPetHealths[2]=CP.GetPower(2,ActIndex)
end

local GetPetStates = function(n)
	local tab={}
	local ActIndex = C_PetBattles.GetActivePet(n)
	tab[2] = CP.GetHealth(n,ActIndex)
	tab[3] = CP.GetPower(n,ActIndex)
	tab[4] = CP.GetSpeed(n,ActIndex)
	tab[5] =  CP.GetHealth(n,ActIndex)..":"..CP.GetPower(n,ActIndex)..":"..CP.GetSpeed(n,ActIndex)
	return tab
end

local CopPtable = function(tab1,tab2)
	for i = 2, 4 do
		if tonumber(tab1[i]) ~= tonumber(tab2[i]) then
			return false
		end
	end
	return true
end
local temprint=print
local print=function(...)
	if HPetSaves.god then
		temprint(...)
	end
end
local GetWhosAbility = function(wtable,ttable,lastable)
	local allytab = GetPetStates(1)
	local enemytab = GetPetStates(2)
	local abilityID = tonumber(wtable[1])
	if CopPtable(enemytab,wtable) then
		if CP.GetAbilityInfo(1,CP.GetActivePet(1),useA) and tonumber(wtable[1]) == CP.GetAbilityInfo(1,CP.GetActivePet(1),useA) then
			if CopPtable(allytab,wtable) then
				if ttable[1] == "H" then
					local tar = ttable[2]
					if tar == PET_BATTLE_COMBAT_LOG_YOUR_LOWER
					or tar == PET_BATTLE_COMBAT_LOG_YOUR then
--~ 					print("AAH1")
						return 0
					end

					if tar == PET_BATTLE_COMBAT_LOG_ENEMY_LOWER
					or tar == PET_BATTLE_COMBAT_LOG_ENEMY then
--~ 					print("AAH2")
						return 1
					end
				end

				if ttable[1] == "D" then
					if abilityID - tempPetHealths[1] == tonumber(ttable[3]) then	---自己变动值符合
--~ 					print("AAS1")
						return 0									---只要自己的符合了,就无视一次
					elseif abilityID - tempPetHealths[2] == tonumber(ttable[3]) then		---敌人血量变动值符合
--~ 					print("AAS2")
						return 1
					end
				end
				if ttable[1] == "B" then
					local tar = ttable[2]
					if tar == PET_BATTLE_COMBAT_LOG_YOUR_LOWER
					or tar == PET_BATTLE_COMBAT_LOG_YOUR then
--~ 					print("BAH1")
						return 1
					end

					if tar == PET_BATTLE_COMBAT_LOG_ENEMY_LOWER
					or tar == PET_BATTLE_COMBAT_LOG_ENEMY then
--~ 					print("BAH2")
						if not tempPetBuffs[abilityID] then tempPetBuffs[abilityID]={} end
						if not tempPetBuffs[abilityID].id then tempPetBuffs[abilityID].id = id end
						if tempPetBuffs[abilityID].id == id then
							tempPetBuffs[abilityID].c = (tempPetBuffs[abilityID].c or 0) + 1				---自己使用的技能miss了,等价于用过一次
--~ 							print("Debug:一次非常特殊")
						end
						return 0
					end
				end
				if ttable[1] == "AA" or ttable[1] == "AP" then
					if not lastable then print("error,AA/AP") return 0 end
					local id = tonumber(string.match(lastable,"(%w)"))
					if not tempPetBuffs[abilityID] then tempPetBuffs[abilityID]={} end
					if not tempPetBuffs[abilityID].id then tempPetBuffs[abilityID].id = id end
					if tempPetBuffs[abilityID].id == id then
						tempPetBuffs[abilityID].c = (tempPetBuffs[abilityID].c or 0) + 1					---该技能出现过一次
--~ 						print("Debug:一次特殊")
						return 0
					else
--~ 						print("Debug:一次更特殊")
						return 0
					end
				end
			else
				return 1
			end
		else
			return 1			--记录下,这次技能属于敌人施放
		end
	end
	return 0
end


local f=CreateFrame("frame")
f:RegisterEvent("PET_BATTLE_OPENING_START");
f:RegisterEvent("PET_BATTLE_CLOSE");
f:RegisterEvent("PET_BATTLE_OVER");
f:RegisterEvent("PET_BATTLE_ACTION_SELECTED")
f:RegisterEvent("CHAT_MSG_PET_BATTLE_COMBAT_LOG")
f:RegisterEvent("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE")
f:SetScript("OnEvent",function(self,event,msg,...)
	if C_PetBattles.IsPlayerNPC(2) then return end
	if event == "PET_BATTLE_OPENING_START" or event == "PET_BATTLE_CLOSE" or event == "PET_BATTLE_OVER" then
		if not f.init then f.GlbalStringInit() end
		RefAbility(true)
		SavePetInfo()
	end
	if event == "PET_BATTLE_ACTION_SELECTED" then
		local selectedActionType, selectedActionIndex = C_PetBattles.GetSelectedAction()
		if selectedActionType == LE_BATTLE_PET_ACTION_ABILITY then
			useA = selectedActionIndex
		end
	end
	if event == "PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE" then
		if f.round ~= msg then
			f.round = msg
			for i,v in pairs(tempPetBuffs) do
--~ 				print(i,v)
				if v.c/2 == ceil(v.c/2) then		----技能出现了2次,说明双方同时用了这个技能
					SetAbility(i)
				end
			end
			SavePetInfo()
			wipe(tempPetBuffs)
			tempPetBuffs={}
		end
		HPetBattleAny.EnemyAbilitys:Update()
	end
	if event == "CHAT_MSG_PET_BATTLE_COMBAT_LOG" then
		local as = string.match(msg,"|HbattlePetAbil:(.-)|h")
		local ps = string.match(msg,"|HAutoSkill:(.-)|h")
		local las = string.match(msg,"|HbattlePetAbil:.-|h.+|HbattlePetAbil:(.-)|h")
		local wtable,ttable
		if ps then
			ttable=ps and {string.split(":",ps)}		---类型,目标,数值
		end
		if as then
			wtable={string.split(":",as)}
			if GetWhosAbility(wtable,ttable,las) == 1 then
				SetAbility(tonumber(wtable[1]))
			end
		end
	end
end)

f.GlbalStringInit = function()
	PET_BATTLE_COMBAT_LOG_AURA_APPLIED = PET_BATTLE_COMBAT_LOG_PAD_AURA_APPLIED.."\124HAutoSkill:AA:%3$s\124h "
	--~ 个体增益

	PET_BATTLE_COMBAT_LOG_PAD_AURA_APPLIED = PET_BATTLE_COMBAT_LOG_PAD_AURA_APPLIED.."\124HAutoSkill:AP:%3$s\124h "
	--~ 队伍释放
	--~ 进行攻击
	PET_BATTLE_COMBAT_LOG_DAMAGE = PET_BATTLE_COMBAT_LOG_DAMAGE.."\124HAutoSkill:D:%3$s:%2$d\124h "
	PET_BATTLE_COMBAT_LOG_HEALING = PET_BATTLE_COMBAT_LOG_HEALING.."\124HAutoSkill:H:%3$s:%2$d\124h "
	PET_BATTLE_COMBAT_LOG_BLOCKED = PET_BATTLE_COMBAT_LOG_BLOCKED.."\124HAutoSkill:B:%2$s\124h "
	--~ PET_BATTLE_COMBAT_LOG_WEATHER_AURA_APPLIED
	--~ 天气变动

	PET_BATTLE_COMBAT_LOG_PARRY = PET_BATTLE_COMBAT_LOG_PARRY.."\124HAutoSkill:B:%2$s\124h "
	PET_BATTLE_COMBAT_LOG_MISS = PET_BATTLE_COMBAT_LOG_MISS.."\124HAutoSkill:B:%2$s\124h "
	PET_BATTLE_COMBAT_LOG_DODGE = PET_BATTLE_COMBAT_LOG_DODGE.."\124HAutoSkill:B:%2$s\124h "
	PET_BATTLE_COMBAT_LOG_DEFLECT = PET_BATTLE_COMBAT_LOG_DEFLECT.."\124HAutoSkill:B:%2$s\124h "
	PET_BATTLE_COMBAT_LOG_IMMUNE = PET_BATTLE_COMBAT_LOG_IMMUNE.."\124HAutoSkill:B:%1$s\124h "
	f.init=true
end
