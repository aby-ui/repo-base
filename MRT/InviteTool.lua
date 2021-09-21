local GlobalAddonName, ExRT = ...

local UnitInGuild, IsInRaid = ExRT.F.UnitInGuild, IsInRaid

local VMRT = nil

local module = ExRT:New("InviteTool",ExRT.L.invite)
local ELib,L = ExRT.lib,ExRT.L

module.db.converttoraid = false
module.db.massinv = false
module.db.invWordsArray = {}
module.db.promoteWordsArray = {}
module.db.masterlootersArray = {}
module.db.reInvite = {}
module.db.reInviteR = nil
module.db.reInviteFrame = nil
module.db.lastGRcall = 0

module.db.demotedPlayers = {}

module.db.sessionInRaid = nil

local BNGetFriendInfo = function(friendIndex)
	local accountInfo = C_BattleNet.GetFriendAccountInfo(friendIndex)
	if accountInfo then
		local wowProjectID = accountInfo.wowProjectID or 0
		local clientProgram = accountInfo.clientProgram ~= "" and accountInfo.clientProgram or nil

		return	accountInfo.bnetAccountID, accountInfo.accountName, accountInfo.battleTag, accountInfo.isBattleTagFriend,
				accountInfo.characterName, accountInfo.gameAccountID, clientProgram,
				accountInfo.isOnline, accountInfo.lastOnlineTime, accountInfo.isAFK, accountInfo.isDND, accountInfo.customMessage, accountInfo.note, true,
				accountInfo.customMessageTime, wowProjectID, accountInfo.isRecruitAFriend, accountInfo.canSummon, accountInfo.isFavorite, accountInfo.isWowMobile
	end
end

local C_GuildInfo_GuildRoster = C_GuildInfo and C_GuildInfo.GuildRoster
local C_PartyInfo_ConvertToRaid = C_PartyInfo and C_PartyInfo.ConvertToRaid

if ExRT.isClassic then
	C_GuildInfo_GuildRoster = C_GuildInfo_GuildRoster or GuildRoster
	C_PartyInfo_ConvertToRaid = C_PartyInfo_ConvertToRaid or ConvertToRaid
	BNGetFriendInfo = _G.BNGetFriendInfo
end

hooksecurefunc("DemoteAssistant", function (unit)
	if not unit then
		return
	end
	local name = UnitName(unit)
	if name then
		name = ExRT.F.delUnitNameServer(name)
		module.db.demotedPlayers[ name ] = true
	end
end)

local _InviteUnit = C_PartyInfo and C_PartyInfo.InviteUnit or InviteUnit
local function InviteUnit(name)
	if name and name:len() >= 45 then
		local shortName = ExRT.F.delUnitNameServer(name)
		_InviteUnit(shortName)
	else
		_InviteUnit(name)
	end
end

local function CheckUnitInRaid(name,shortName)
	if not shortName then
		shortName = ExRT.F.delUnitNameServer(name)
	end
	if UnitName(name) or UnitName(shortName) then
		return true
	end
	return false
end


local function InviteBut()
	local gplayers = GetNumGuildMembers() or 0
	local t = GetTime()
	if gplayers == 0 then
		if t > module.db.lastGRcall then
			module.db.lastGRcall = t + 10
			module.db.inviteGRwait = true
			C_GuildInfo_GuildRoster()
		end
		return
	end
	local nowinvnum = 1
	local inRaid = IsInRaid()
	if not inRaid then
		module.db.converttoraid = true
		module.db.massinv = true
	end
	for i=1,gplayers do
		local name,_,rankIndex,level,_,_,_,_,online,_,_,_,_,isMobile = GetGuildRosterInfo(i)
		local sName = ExRT.F.delUnitNameServer(name)
		if name and rankIndex and VMRT.InviteTool.Ranks[rankIndex+1] and online and ((ExRT.SDB.charLevel >= 60 and level >= 60) or (ExRT.isClassic and level >= 60) or level >= 50) and not isMobile and not CheckUnitInRaid(name,sName) and sName ~= module.db.playerFullName then
			if inRaid then
				InviteUnit(name)
			elseif nowinvnum < 5 then
				nowinvnum = nowinvnum + 1
				InviteUnit(name)
			else
				return
			end
		end
	end
end

local function InviteList(list,noNewList)
	local nowinvnum = 1
	local inRaid = IsInRaid()
	if #list > 5 and not inRaid then
		module.db.converttoraid = true
	end
	if not noNewList and not inRaid then
		module.db.listinv = list
	end
	for i=1,#list do
		local name = list[i]
		if not CheckUnitInRaid(name) and not UnitIsUnit(name,"player") then
			if inRaid then
				InviteUnit(name)
			elseif nowinvnum < 5 then
				nowinvnum = nowinvnum + 1
				InviteUnit(name)
			else
				return
			end
		end
	end
end
local function CreateInviteList(text)
	if not text then 
		return {}
	end
	local list = {strsplit("\n",text)}
	for i=#list,1,-1 do
		if string.trim(list[i]) == "" then
			tremove(list,i)
		end
	end
	return list
end

local function DisbandBut()
	local n = GetNumGroupMembers() or 0
	local myname = UnitName("player")
	for j=n,1,-1 do
		local nown = GetNumGroupMembers() or 0
		if nown > 0 then
			local name, rank = GetRaidRosterInfo(j)
			if name and myname ~= name then
				UninviteUnit(name)
			end
		end
	end
end

local function ReinviteHelpFunc()
	local inRaid = IsInRaid()
	local nowinvnum = 0
	for i=1,#module.db.reInvite do
		if not UnitInRaid(module.db.reInvite[i]) then
			if inRaid then
				InviteUnit(module.db.reInvite[i])
			elseif nowinvnum < 5 then
				nowinvnum = nowinvnum + 1
				InviteUnit(module.db.reInvite[i])
			end
		end
	end
end

local function ReinviteBut()
	local inRaid = IsInRaid()
	if not inRaid then
		return
	end
	table.wipe(module.db.reInvite)
	local n = GetNumGroupMembers() or 0
	for j=1,n do
		local name = GetRaidRosterInfo(j)
		table.insert(module.db.reInvite,name)
	end
	DisbandBut()

	if not module.db.reInviteFrame then
		module.db.reInviteFrame = CreateFrame("Frame")
	end

	module.db.reInviteFrame.t = 0
	module.db.reInviteFrame:SetScript("OnUpdate",function(self,e)
		self.t = self.t + e
		if self.t > 5 then
			module.db.converttoraid = true
			module.db.reInviteR = true
			ReinviteHelpFunc()
			self:SetScript("OnUpdate",nil)
		end
	end)
end

local function createInvWordsArray()
	if VMRT.InviteTool.Words then
		table.wipe(module.db.invWordsArray)
		local tmpCount = 1
		local tmpStr = strsplit(" ",VMRT.InviteTool.Words)
		while tmpStr do
			if tmpStr ~= "" and tmpStr ~= " " then
				module.db.invWordsArray[tmpStr] = 1
			end
			tmpCount = tmpCount + 1
			tmpStr = select(tmpCount,strsplit(" ",VMRT.InviteTool.Words))
		end
	end
end

local function createPromoteArray()
	if VMRT.InviteTool.PromoteNames then
		table.wipe(module.db.promoteWordsArray)
		local tmpCount = 1
		local tmpStr = strsplit(" ",VMRT.InviteTool.PromoteNames)
		while tmpStr do
			if tmpStr ~= "" and tmpStr ~= " " then
				tmpStr = tmpStr:lower()
				module.db.promoteWordsArray[tmpStr] = 1
			end
			tmpCount = tmpCount + 1
			tmpStr = select(tmpCount,strsplit(" ",VMRT.InviteTool.PromoteNames))
		end
	end
end

local function demoteRaid()
	for i = 1, GetNumGroupMembers() do
		local name, rank = GetRaidRosterInfo(i)
		if name and rank == 1 then
			DemoteAssistant(name)
		end
	end
end

local function createMastelootersArray()
	if VMRT.InviteTool.MasterLooters then
		table.wipe(module.db.masterlootersArray)
		local tmpCount = 1
		local tmpStr = strsplit(" ",strtrim(VMRT.InviteTool.MasterLooters))
		while tmpStr do
			if tmpStr ~= "" and tmpStr ~= " " then
				module.db.masterlootersArray[#module.db.masterlootersArray + 1] = tmpStr
			end
			tmpCount = tmpCount + 1
			tmpStr = select(tmpCount,strsplit(" ",strtrim(VMRT.InviteTool.MasterLooters)))
		end
	end
end

function module.options:Load()
	self:CreateTilte()

	self.dropDown = ELib:DropDown(self,205,10):Point(15,-30):Size(220)

	function self.dropDown:SetValue(newValue)
		VMRT.InviteTool.Ranks[newValue] = self.checkButton:GetChecked()
		module.options.dropDown:SetText( L.inviterank )
		for i=1,#module.options.dropDown.List do
			module.options.dropDown.List[i].checkState = VMRT.InviteTool.Ranks[ module.options.dropDown.List[i].arg1 ]
		end
		module.options.dropDown:UpdateText()
	end

	if IsInGuild() then
		local granks = GuildControlGetNumRanks()
		for i=granks,1,-1 do
			self.dropDown.List[#self.dropDown.List + 1] = {
				text = GuildControlGetRankName(i) or "",
				checkState = VMRT.InviteTool.Ranks[i],
				checkable = true,
				func = self.dropDown.SetValue,
				arg1 = i,
			}
		end
		self.dropDown.Lines = #self.dropDown.List
	end

	self.butInv = ELib:Button(self,L.inviteinv):Size(200,20):Point(245,-30):OnClick(function() InviteBut() end)
	self.butInv.txt = ELib:Text(self,"/rt inv",11):Size(100,20):Point("LEFT",self.butInv,"RIGHT",5,0)

	self.butDisband = ELib:Button(self,L.invitedis):Size(430,20):Point(15,-55):OnClick(function() DisbandBut() end)
	self.butDisband.txt = ELib:Text(self,"/rt dis",11):Size(100,20):Point("LEFT",self.butDisband,"RIGHT",5,0)

	self.butReinvite = ELib:Button(self,L.inviteReInv):Size(430,20):Point(15,-80):OnClick(function() ReinviteBut() end)
	self.butReinvite.txt = ELib:Text(self,"/rt reinv",11):Size(100,20):Point("LEFT",self.butReinvite,"RIGHT",5,0)

	self.butListInv = ELib:Button(self,L.InviteListButton):Size(430,20):Point(15,-115):OnClick(function() self.listInvFrame:Show() end)
	self.butListInv.txt = ELib:Text(self,"/rt invlist 1",11):Size(100,20):Point("LEFT",self.butListInv,"RIGHT",5,0)


	self.listInvFrame = ELib:Popup(L.InviteListButton):Size(400,400)
	self.listInvFrame.edit = ELib:MultiEdit(self.listInvFrame):Point("TOP",0,-60):Size(386,314):OnChange(function(_,isUser)
		if not isUser then return end
		VMRT.InviteTool["ListInv"..(self.listInvFrame.currList)] = self.listInvFrame.edit:GetText()
	end)
	self.listInvFrame.tip = ELib:Text(self.listInvFrame,L.InviteListTip,12):Point(15,-45)
	for i=1,4 do
		self.listInvFrame["butList"..i] = ELib:Button(self.listInvFrame,i):Size(390/4,20):Point(5+(i-1)*(390/4),-20):OnClick(function(self) 
			for j=1,4 do self:GetParent()["butList"..j]:Enable() end
			self:Disable()

			module.options.listInvFrame.currList = i
			self:GetParent().edit:SetText(VMRT.InviteTool["ListInv"..i] or "")
		end)
	end
	self.listInvFrame["butList"..1]:Disable()
	self.listInvFrame.currList = 1
	self.listInvFrame.edit:SetText(VMRT.InviteTool["ListInv"..1] or "")
	self.listInvFrame.invite = ELib:Button(self.listInvFrame,L.inviteinv):Size(390,20):Point("BOTTOM",0,5):OnClick(function()
		InviteList(CreateInviteList(VMRT.InviteTool["ListInv"..(self.listInvFrame.currList)]))
	end)


	self.chkInvByChat = ELib:Check(self,L.invitewords,VMRT.InviteTool.InvByChat):Point("TOPLEFT",self.butListInv,"BOTTOMLEFT",0,-15):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.InviteTool.InvByChat = true
			module:RegisterEvents('CHAT_MSG_WHISPER','CHAT_MSG_BN_WHISPER')
		else
			VMRT.InviteTool.InvByChat = nil
			module:UnregisterEvents('CHAT_MSG_WHISPER','CHAT_MSG_BN_WHISPER')
		end
	end)

	self.chkOnlyGuild = ELib:Check(self,L.inviteguildonly,VMRT.InviteTool.OnlyGuild):Point("TOPLEFT",self.chkInvByChat,"BOTTOMLEFT",0,-5):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.InviteTool.OnlyGuild = true
		else
			VMRT.InviteTool.OnlyGuild = nil
		end
	end)

	self.chkInvByChatSay = ELib:Check(self,L.invitewordssay,VMRT.InviteTool.InvByChatSay):Point("TOPLEFT",self.chkOnlyGuild,"BOTTOMLEFT",0,-5):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.InviteTool.InvByChatSay = true
			module:RegisterEvents('CHAT_MSG_SAY','CHAT_MSG_YELL')
		else
			VMRT.InviteTool.InvByChatSay = nil
			module:UnregisterEvents('CHAT_MSG_SAY','CHAT_MSG_YELL')
		end
	end)


	self.wordsInput = ELib:Edit(self):Size(650,20):Point("TOPLEFT",self.chkInvByChatSay,"BOTTOMLEFT",0,-5):Tooltip(L.invitewordstooltip.."\n"..L.invitewordstooltipany):Text(VMRT.InviteTool.Words):OnChange(function(self)
		VMRT.InviteTool.Words = self:GetText()
		createInvWordsArray()
	end) 

	self.chkAutoInvAccept = ELib:Check(self,L.inviteaccept,VMRT.InviteTool.AutoInvAccept):Point("TOPLEFT",self.wordsInput,"BOTTOMLEFT",0,-15):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.InviteTool.AutoInvAccept = true
			module:RegisterEvents('PARTY_INVITE_REQUEST')
		else
			VMRT.InviteTool.AutoInvAccept = nil
			module:UnregisterEvents('PARTY_INVITE_REQUEST')
		end
	end)

	self.chkAutoPromote = ELib:Check(self,L.inviteAutoPromote,VMRT.InviteTool.AutoPromote):Point("TOPLEFT",self.chkAutoInvAccept,"BOTTOMLEFT",0,-15):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.InviteTool.AutoPromote = true
		else
			VMRT.InviteTool.AutoPromote = nil
		end
	end)

	self.dropDownAutoPromote = ELib:DropDown(self,205,10):Point("TOPLEFT",self.chkAutoPromote,"BOTTOMLEFT",0,-5):Size(430)
	function self.dropDownAutoPromote:SetValue(newValue)
		VMRT.InviteTool.PromoteRank = newValue
		module.options.dropDownAutoPromote:SetText( L.inviterank.." " .. (newValue == 0 and L.inviteAutoPromoteDontUseGuild or GuildControlGetRankName(newValue) or ""))
		ELib:DropDownClose()
		for i=1,#module.options.dropDownAutoPromote.List do
			module.options.dropDownAutoPromote.List[i].checkState = VMRT.InviteTool.PromoteRank == module.options.dropDownAutoPromote.List[i].arg1
		end
	end
	if IsInGuild() then
		local granks = GuildControlGetNumRanks()
		for i=granks,1,-1 do
			self.dropDownAutoPromote.List[#self.dropDownAutoPromote.List + 1] = {
				text = GuildControlGetRankName(i) or "",
				checkState = VMRT.InviteTool.PromoteRank == i,
				radio = true,
				func = self.dropDownAutoPromote.SetValue,
				arg1 = i,
			}
		end
	end
	self.dropDownAutoPromote.List[#self.dropDownAutoPromote.List + 1] = {
		text = L.inviteAutoPromoteDontUseGuild,
		checkState = VMRT.InviteTool.PromoteRank == 0,
		radio = true,
		func = self.dropDownAutoPromote.SetValue,
		arg1 = 0,
	}
	self.dropDownAutoPromote.Lines = #self.dropDownAutoPromote.List


	self.autoPromoteInput = ELib:Edit(self):Size(650,20):Point("TOPLEFT",self.dropDownAutoPromote,"BOTTOMLEFT",0,-5):Tooltip(L.inviteAutoPromoteTooltip):Text(VMRT.InviteTool.PromoteNames):OnChange(function(self)
		VMRT.InviteTool.PromoteNames = self:GetText()
		createPromoteArray()
	end) 

	self.butRaidDemote = ELib:Button(self,L.inviteRaidDemote):Size(430,20):Point("TOPLEFT",self.autoPromoteInput,"BOTTOMLEFT",0,-5):OnClick(function() demoteRaid() end)


	self.chkRaidDiff = ELib:Check(self,L.InviteRaidDiffCheck,VMRT.InviteTool.AutoRaidDiff):Point("TOPLEFT",self.butRaidDemote,"BOTTOMLEFT",0,-15):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.InviteTool.AutoRaidDiff = true
		else
			VMRT.InviteTool.AutoRaidDiff = nil
		end
	end)

	local RaidDiffsDropDown = {
		{14,PLAYER_DIFFICULTY1},
		{15,PLAYER_DIFFICULTY2},
		{16,PLAYER_DIFFICULTY6},
	}
	self.dropDownRaidDiff = ELib:DropDown(self,235,10):Point("TOPLEFT",self.chkRaidDiff,"BOTTOMLEFT",175,-5):Size(250)
	function self.dropDownRaidDiff:SetValue(newValue)
		VMRT.InviteTool.RaidDiff = RaidDiffsDropDown[newValue][1]
		module.options.dropDownRaidDiff:SetText( RaidDiffsDropDown[newValue][2] )
		ELib:DropDownClose()
		for i=1,#module.options.dropDownRaidDiff.List do
			module.options.dropDownRaidDiff.List[i].checkState = VMRT.InviteTool.RaidDiff == RaidDiffsDropDown[ module.options.dropDownRaidDiff.List[i].arg1 ][1]
		end
	end
	for i=1,#RaidDiffsDropDown do
		self.dropDownRaidDiff.List[i] = {
			text = RaidDiffsDropDown[i][2],
			checkState = VMRT.InviteTool.RaidDiff == RaidDiffsDropDown[i][1],
			radio = true,
			arg1 = i,
			func = self.dropDownRaidDiff.SetValue,
		}
	end
	self.dropDownRaidDiff.Lines = #self.dropDownRaidDiff.List
	do
		local diffName = ""
		for i=1,#RaidDiffsDropDown do
			if RaidDiffsDropDown[i][1] == VMRT.InviteTool.RaidDiff then
				diffName = RaidDiffsDropDown[i][2]
				break
			end
		end
		self.dropDownRaidDiff:SetText( diffName or "" )
	end

	self.dropDownRaidDiffText = ELib:Text(self,L.InviteRaidDiff,11):Size(150,20):Point("TOPLEFT",self.dropDownRaidDiff,-180,0)



	self.chkEnableMasterLooter = ELib:Check(self,L.InviteMasterlootersEnable,VMRT.InviteTool.LootMethodEnabled):Point("TOPLEFT",self.dropDownRaidDiff,"BOTTOMLEFT",-175,-5):OnClick(function(self) 
		if self:GetChecked() then
			VMRT.InviteTool.LootMethodEnabled = true
		else
			VMRT.InviteTool.LootMethodEnabled = nil
		end
	end)

	local LootMethodDropDown = {
		{"freeforall",LOOT_FREE_FOR_ALL},
		{"group",LOOT_GROUP_LOOT},
		{"master",LOOT_MASTER_LOOTER},
		{"needbeforegreed",LOOT_NEED_BEFORE_GREED},
		--{"personalloot",LOOT_PERSONAL_LOOT},
		{"roundrobin",LOOT_ROUND_ROBIN},
	}
	self.dropDownLootMethod = ELib:DropDown(self,235,10):Point("TOPLEFT",self.chkEnableMasterLooter,"BOTTOMLEFT",175,-5):Size(250)
	function self.dropDownLootMethod:SetValue(newValue)
		VMRT.InviteTool.LootMethod = LootMethodDropDown[newValue][1]
		module.options.dropDownLootMethod:SetText( LootMethodDropDown[newValue][2] )
		ELib:DropDownClose()
		for i=1,#module.options.dropDownLootMethod.List do
			module.options.dropDownLootMethod.List[i].checkState = VMRT.InviteTool.LootMethod == LootMethodDropDown[ module.options.dropDownLootMethod.List[i].arg1 ][1]
		end
	end
	for i=1,#LootMethodDropDown do
		self.dropDownLootMethod.List[i] = {
			text = LootMethodDropDown[i][2],
			checkState = VMRT.InviteTool.LootMethod == LootMethodDropDown[i][1],
			radio = true,
			arg1 = i,
			func = self.dropDownLootMethod.SetValue,
		}
	end
	self.dropDownLootMethod.Lines = #self.dropDownLootMethod.List
	do
		local methodName = ""
		for i=1,#LootMethodDropDown do
			if LootMethodDropDown[i][1] == VMRT.InviteTool.LootMethod then
				methodName = LootMethodDropDown[i][2]
				break
			end
		end
		self.dropDownLootMethod:SetText( methodName or "" )
	end
	self.dropDownLootMethodText = ELib:Text(self,LOOT_METHOD..":",11):Size(175,20):Point("TOPLEFT",self.dropDownLootMethod,-175,0)
	
	
	self.masterlotersInput = ELib:Edit(self):Size(250,20):Point("TOPLEFT",self.dropDownLootMethod,"BOTTOMLEFT",0,-5):Tooltip(L.InviteMasterlootersTooltip):Text(VMRT.InviteTool.MasterLooters):OnChange(function(self)
		VMRT.InviteTool.MasterLooters = self:GetText()
		createMastelootersArray()
	end) 
	self.masterlotersInputText = ELib:Text(self,L.InviteMasterlooters,11):Size(175,20):Point("TOPLEFT",self.masterlotersInput,-175,0)
	
	
	local LootThresholdDropDown = {
		{2,"|c"..select(4,GetItemQualityColor(2))..ITEM_QUALITY2_DESC},
		{3,"|c"..select(4,GetItemQualityColor(3))..ITEM_QUALITY3_DESC},
		{4,"|c"..select(4,GetItemQualityColor(4))..ITEM_QUALITY4_DESC},
	}
	self.dropDownLootThreshold = ELib:DropDown(self,235,10):Point("TOPLEFT",self.masterlotersInput,"BOTTOMLEFT",0,-5):Size(250)
	function self.dropDownLootThreshold:SetValue(newValue)
		VMRT.InviteTool.LootThreshold = LootThresholdDropDown[newValue][1]
		module.options.dropDownLootThreshold:SetText( LootThresholdDropDown[newValue][2] )
		ELib:DropDownClose()
		for i=1,#module.options.dropDownLootThreshold.List do
			module.options.dropDownLootThreshold.List[i].checkState = VMRT.InviteTool.LootThreshold == LootThresholdDropDown[ module.options.dropDownLootThreshold.List[i].arg1 ][1]
		end

	end
	for i=1,#LootThresholdDropDown do
		self.dropDownLootThreshold.List[i] = {
			text = LootThresholdDropDown[i][2],
			checkState = VMRT.InviteTool.LootThreshold == LootThresholdDropDown[i][1],
			radio = true,
			arg1 = i,
			func = self.dropDownLootThreshold.SetValue,
		}
	end
	self.dropDownLootThreshold.Lines = #self.dropDownLootThreshold.List
	do
		local diffName = ""
		for i=1,#LootThresholdDropDown do
			if LootThresholdDropDown[i][1] == VMRT.InviteTool.LootThreshold then
				diffName = LootThresholdDropDown[i][2]
				break
			end
		end
		self.dropDownLootThreshold:SetText( diffName or "" )
	end
	self.dropDownLootThresholdText = ELib:Text(self,LOOT_THRESHOLD..":",11):Size(175,20):Point("TOPLEFT",self.dropDownLootThreshold,-175,0)




	if ExRT.isClassic then
		self.chkRaidDiff:Hide()
		self.dropDownRaidDiff:Hide()
		self.dropDownRaidDiffText:Hide()
	else
		self.dropDownLootMethod:Hide()
		self.dropDownLootMethodText:Hide()
		self.masterlotersInput:Hide()
		self.masterlotersInputText:Hide()
		self.dropDownLootThreshold:Hide()
		self.dropDownLootThresholdText:Hide()
	end


	self.HelpPlate = {
		FramePos = { x = 0, y = 0 },FrameSize = { width = 660, height = 615 },
		[1] = { ButtonPos = { x = 50,	y = -42 },  	HighLightBox = { x = 5, y = -25, width = 660, height = 80 },		ToolTipDir = "RIGHT",	ToolTipText = L.inviteHelpRaid },
		[2] = { ButtonPos = { x = 50,  y = -128 }, 	HighLightBox = { x = 5, y = -110, width = 660, height = 105 },		ToolTipDir = "RIGHT",	ToolTipText = L.inviteHelpAutoInv },
		[3] = { ButtonPos = { x = 50,  y = -212 }, 	HighLightBox = { x = 5, y = -220, width = 660, height = 30 },		ToolTipDir = "RIGHT",	ToolTipText = L.inviteHelpAutoAccept },
		[4] = { ButtonPos = { x = 50,  y = -280},  	HighLightBox = { x = 5, y = -255, width = 660, height = 135 },		ToolTipDir = "RIGHT",	ToolTipText = L.inviteHelpAutoPromote },
	}
	if not ExRT.isClassic then
		self.HELPButton = ExRT.lib.CreateHelpButton(self,self.HelpPlate)
		self.HELPButton:SetPoint("CENTER",self,"TOPLEFT",0,15)
	end

	self.dropDown:SetText( L.inviterank )
	self.dropDownAutoPromote:SetText( L.inviterank.." " .. (VMRT.InviteTool.PromoteRank == 0 and L.inviteAutoPromoteDontUseGuild or GuildControlGetRankName(VMRT.InviteTool.PromoteRank) or ""))

	function self.dropDown:UpdateText()
		if IsInGuild() and VMRT.InviteTool.Ranks then
			local r = ""
			for rank,v in pairs(VMRT.InviteTool.Ranks) do
				if v then
					r = r .. (GuildControlGetRankName(rank) or "") .. ","
				end
			end
			self:SetText( L.inviterank .. r:sub(1,-2) )
		end
	end
	self.dropDown:UpdateText()
end


local promoteRosterUpdate
do
	local promotes,scheduledPromotes={},nil
	local guildmembers = nil

	local function GuildReview()
		guildmembers = {}
		if (GetNumGuildMembers() or 0) == 0 then
			C_GuildInfo_GuildRoster()
		end
		for j=1,GetNumGuildMembers() do
			local guild_name,_,rankIndex = GetGuildRosterInfo(j)
			if guild_name then
				guildmembers[ExRT.F.delUnitNameServer(guild_name)] = rankIndex
			end
		end
	end

	function promoteRosterUpdate()
		if not VMRT.InviteTool.AutoPromote then
			return
		end
		for i = 1, GetNumGroupMembers() do
			local name, rank = GetRaidRosterInfo(i)
			if name and rank == 0 then
				local sName = ExRT.F.delUnitNameServer(name)
				if module.db.promoteWordsArray[sName:lower()] then
					promotes[name] = true
				elseif IsInGuild() and UnitInGuild(sName) then
					if not guildmembers then
						GuildReview()
					end
					if (guildmembers[sName] or 99) < VMRT.InviteTool.PromoteRank then
						promotes[name] = true
					end
				end
			end
		end
		if not scheduledPromotes then
			scheduledPromotes = ExRT.F.ScheduleTimer(function ()
				scheduledPromotes = nil
				for name in pairs(promotes) do
					if not module.db.demotedPlayers[ ExRT.F.delUnitNameServer(name) ] then
						PromoteToAssistant(name, true)
					end
					promotes[name] = nil
				end
			end, 2)
		end
	end
end

function module.main:ADDON_LOADED()
	VMRT = _G.VMRT
	VMRT.InviteTool = VMRT.InviteTool or {OnlyGuild=true,InvByChat=true}
	VMRT.InviteTool.Rank = VMRT.InviteTool.Rank or 1

	if not VMRT.InviteTool.Ranks then
		VMRT.InviteTool.Ranks = {}
		if type(VMRT.InviteTool.Rank)=='number' then
			for i=1,VMRT.InviteTool.Rank do
				VMRT.InviteTool.Ranks[i] = true
			end
		end
	end

	VMRT.InviteTool.Words = VMRT.InviteTool.Words or "инв inv byd штм 123"
	createInvWordsArray()

	VMRT.InviteTool.PromoteNames = VMRT.InviteTool.PromoteNames or ""
	VMRT.InviteTool.PromoteRank = VMRT.InviteTool.PromoteRank or 2
	createPromoteArray()

	VMRT.InviteTool.RaidDiff = VMRT.InviteTool.RaidDiff or 16
	VMRT.InviteTool.LootMethod = VMRT.InviteTool.LootMethod or "group"
	VMRT.InviteTool.MasterLooters = VMRT.InviteTool.MasterLooters or ""
	VMRT.InviteTool.LootThreshold = VMRT.InviteTool.LootThreshold or 2
	createMastelootersArray()

	module:RegisterEvents('GROUP_ROSTER_UPDATE','GUILD_ROSTER_UPDATE')
	if VMRT.InviteTool.InvByChat then
		module:RegisterEvents('CHAT_MSG_WHISPER','CHAT_MSG_BN_WHISPER')
	end
	if VMRT.InviteTool.AutoInvAccept then
		module:RegisterEvents('PARTY_INVITE_REQUEST','GROUP_INVITE_CONFIRMATION')
	end
	if VMRT.InviteTool.InvByChatSay then
		module:RegisterEvents('CHAT_MSG_SAY','CHAT_MSG_YELL')
	end

	module:RegisterSlash()

	module.db.playerFullName = ExRT.F.UnitCombatlogname("player")
end

function module.main:CHAT_MSG_WHISPER(msg, user, special)
	if user == ExRT.SDB.charKey then
		return
	end
	msg = string.lower(msg)
	if ((msg and module.db.invWordsArray[msg]) or (module.db.invWordsArray["ANYKEYWORD"] and not UnitName(user))) and (not VMRT.InviteTool.OnlyGuild or UnitInGuild(user)) then
		if not IsInRaid() and GetNumGroupMembers() == 5 then 
			C_PartyInfo_ConvertToRaid()
		end
		InviteUnit(user)
	elseif ((msg and module.db.invWordsArray[msg]) or (module.db.invWordsArray["ANYKEYWORD"] and not UnitName(user))) and VMRT.InviteTool.OnlyGuild and (GetNumGuildMembers() or 0) == 0 and special ~= -578 then
		C_GuildInfo_GuildRoster()
		C_Timer.After(2,function()
			module.main:CHAT_MSG_WHISPER(msg, user, -578)
		end)
	end
end
module.main.CHAT_MSG_SAY = module.main.CHAT_MSG_WHISPER
module.main.CHAT_MSG_YELL = module.main.CHAT_MSG_WHISPER


function module.main:CHAT_MSG_BN_WHISPER(msg,sender,_,_,_,_,_,_,_,_,_,_,senderBnetIDAccount)
	msg = string.lower(msg)
	if not ((msg and module.db.invWordsArray[msg]) or module.db.invWordsArray["ANYKEYWORD"]) then
		return
	end
	if not IsInRaid() and GetNumGroupMembers() == 5 then 
		C_PartyInfo_ConvertToRaid()
	end

	if not ExRT.isClassic then
		local _,BNcount=BNGetNumFriends() 
		for friendIndex=1,BNcount do 
			if senderBnetIDAccount == BNGetFriendInfo(friendIndex) then
				local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(friendIndex)
				for accountIndex=1,numGameAccounts do
					local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(friendIndex, accountIndex)
					if gameAccountInfo and gameAccountInfo.clientProgram == BNET_CLIENT_WOW and gameAccountInfo.factionName == UnitFactionGroup('player') and (not VMRT.InviteTool.OnlyGuild or (gameAccountInfo.characterName and UnitInGuild(gameAccountInfo.characterName))) then
						BNInviteFriend(gameAccountInfo.gameAccountID)
					end
				end
				break
			end
		end
	else
		local _,BNcount=BNGetNumFriends() 
		for i=1,BNcount do 
			if senderBnetIDAccount == BNGetFriendInfo(i) then
				local numGameAccounts = BNGetNumFriendGameAccounts(i)
				for j=1,numGameAccounts do
					local hasFocus, characterName, client, realmName, realmID, faction, race, class, _, _, level, _, _, _, _, bnetIDGameAccount = BNGetFriendGameAccountInfo(i, j)
					if client == BNET_CLIENT_WOW and faction == UnitFactionGroup('player') and (not VMRT.InviteTool.OnlyGuild or (characterName and UnitInGuild(characterName))) then
						BNInviteFriend(bnetIDGameAccount)
					end
				end
				break
			end
		end
	end
end

local function IsRaidLeader()
	for i = 1, GetNumGroupMembers() do
		local name, rank = GetRaidRosterInfo(i)
		if name and rank == 2 and name == UnitName("player") then
			return i
		end
	end
end

local scheludedRaidUpdate = nil
local function AutoRaidSetup()
	scheludedRaidUpdate = nil

	local inRaid = IsInRaid()
	local RaidLeader = inRaid and IsRaidLeader()
	local _,zoneType = IsInInstance()

	if zoneType ~= "raid" then
		if inRaid and not module.db.sessionInRaid then
			if RaidLeader then
				module.db.sessionInRaid = true
				module.db.sessionInRaidLoot = true

				if not ExRT.isClassic then
					SetRaidDifficultyID(VMRT.InviteTool.RaidDiff)
				end
				if ExRT.isClassic and VMRT.InviteTool.LootMethodEnabled then
					SetLootMethod(VMRT.InviteTool.LootMethod,UnitName("player"),nil)
					--SetLootThreshold(VMRT.InviteTool.LootThreshold)	--http://us.battle.net/wow/en/forum/topic/14610481537
					ExRT.F.ScheduleTimer(SetLootThreshold, 2, VMRT.InviteTool.LootThreshold)
				end
			end
		elseif not inRaid and module.db.sessionInRaid then
			module.db.sessionInRaid = nil
		end
	else
		if inRaid and not module.db.sessionInRaidLoot then
			module.db.sessionInRaidLoot = true
			if RaidLeader and ExRT.isClassic and VMRT.InviteTool.LootMethodEnabled then
				SetLootMethod(VMRT.InviteTool.LootMethod,UnitName("player"),nil)
				ExRT.F.ScheduleTimer(SetLootThreshold, 2, VMRT.InviteTool.LootThreshold)
			end
		end
	end

	if inRaid and RaidLeader and VMRT.InviteTool.LootMethod == "master" and VMRT.InviteTool.LootMethodEnabled and ExRT.isClassic then
		local lootMethod,_,masterlooterRaidID = GetLootMethod()
		if lootMethod == "master" then
			local masterlooterName = UnitName("raid"..masterlooterRaidID)
			for i=1,#module.db.masterlootersArray do
				local name = module.db.masterlootersArray[i]
				local nameNow = UnitName(name)
				if nameNow then
					if masterlooterName ~= nameNow then
						SetLootMethod("master",name)
					end
					break
				end
			end
		end
	end
end

function module.main:GROUP_ROSTER_UPDATE()
	local inRaid = IsInRaid()
	if inRaid then
		module.db.converttoraid = false
	elseif module.db.converttoraid then
		C_PartyInfo_ConvertToRaid()
	end
	if module.db.reInviteR and inRaid then
		module.db.reInviteR = nil
		ReinviteHelpFunc()
		return
	end
	if module.db.massinv and inRaid then
		module.db.massinv = false
		InviteBut()
	end
	if module.db.listinv and inRaid then
		InviteList(module.db.listinv,true)
		module.db.listinv = nil
	end
	if inRaid and UnitIsGroupLeader("player") then
		promoteRosterUpdate()
	end

	if VMRT.InviteTool.AutoRaidDiff then
		if not scheludedRaidUpdate then
			scheludedRaidUpdate = ExRT.F.ScheduleTimer(AutoRaidSetup, .5)
		end
	end
end

function module.main:GUILD_ROSTER_UPDATE()
	if module.db.inviteGRwait then
		module.db.inviteGRwait = nil
		if IsInGuild() then
			InviteBut()
		end
	end
end

do
	local function GetFriendInfo(friend)
		local info = C_FriendList.GetFriendInfoByIndex(friend)
		if info then
			return info.name
		end
	end

	local function IsFriend(name)
		for i=1,C_FriendList.GetNumFriends() do if(GetFriendInfo(i)==name) then return true end end
		if(IsInGuild()) then for i=1, GetNumGuildMembers() do if(ExRT.F.delUnitNameServer(GetGuildRosterInfo(i) or "?")==name) then return true end end end
		local b,a=BNGetNumFriends() for i=1,a do local bName=select(5,BNGetFriendInfo(i)) if bName==name then return true end end
	end
	function module.main:PARTY_INVITE_REQUEST(nameinv)
		-- PhoenixStyle
		nameinv = nameinv and ExRT.F.delUnitNameServer(nameinv)
		if nameinv and (IsFriend(nameinv)) then
			AcceptGroup()
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if frame:IsVisible() and frame.which=="PARTY_INVITE" then
					frame.inviteAccepted = true
					StaticPopup_Hide("PARTY_INVITE")
					return
				elseif frame:IsVisible() and frame.which=="PARTY_INVITE_XREALM" then
					frame.inviteAccepted = true
					StaticPopup_Hide("PARTY_INVITE_XREALM")
					return
				end
			end
		end
	end
	function module.main:GROUP_INVITE_CONFIRMATION()
		if true then return end
		local firstInvite = GetNextPendingInviteConfirmation()
		if ( not firstInvite ) then
			return
		end
		local confirmationType, name = GetInviteConfirmationInfo(firstInvite)
		local suggesterGuid, suggesterName, relationship = C_PartyInfo.GetInviteReferralInfo(firstInvite)
		--if (suggesterName and IsFriend(ExRT.F.delUnitNameServer(suggesterName))) or (name and IsFriend(ExRT.F.delUnitNameServer(name))) then
		if name and IsFriend(ExRT.F.delUnitNameServer(name)) then
			RespondToInviteConfirmation(firstInvite, true)
			for i = 1, 4 do
				local frame = _G["StaticPopup"..i]
				if frame:IsVisible() and frame.which=="GROUP_INVITE_CONFIRMATION" then
					StaticPopup_Hide("GROUP_INVITE_CONFIRMATION")
					UpdateInviteConfirmationDialogs()
					return
				end
			end
		end
	end
end

function module:slash(arg)
	if arg == "inv" then
		InviteBut()
	elseif arg == "dis" then
		DisbandBut()
	elseif arg == "reinv" then
		ReinviteBut()
	elseif arg and arg:find("^invlist %d") then
		local listnum = arg:match("%d")
		InviteList(CreateInviteList(VMRT.InviteTool["ListInv"..listnum]))
	elseif arg == "help" then
		print("|cff00ff00/rt inv|r - run autoinvite feature")
		print("|cff00ff00/rt dis|r - disband raid")
		print("|cff00ff00/rt reinv|r - disband & reinvite raid")
		print("|cff00ff00/rt invlist X|r - invite people from X predefined list")
	end
end
