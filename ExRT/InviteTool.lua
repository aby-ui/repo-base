local GlobalAddonName, ExRT = ...

local UnitInGuild, IsInRaid = ExRT.F.UnitInGuild, IsInRaid

local VExRT = nil

local module = ExRT.mod:New("InviteTool",ExRT.L.invite,nil,true)
local ELib,L = ExRT.lib,ExRT.L

module.db.converttoraid = false
module.db.massinv = false
module.db.invWordsArray = {}
module.db.promoteWordsArray = {}
module.db.masterlootersArray = {}
module.db.reInvite = {}
module.db.reInviteR = nil
module.db.reInviteFrame = nil

module.db.demotedPlayers = {}

module.db.sessionInRaid = nil

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

local _InviteUnit = InviteUnit
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
	local nowinvnum = 1
	local inRaid = IsInRaid()
	module.db.converttoraid = true
	for i=1,gplayers do
		local name,_,rankIndex,level,_,_,_,_,online,_,_,_,_,isMobile = GetGuildRosterInfo(i)
		local sName = ExRT.F.delUnitNameServer(name)
		if name and rankIndex < VExRT.InviteTool.Rank and online and (ExRT.SDB.charLevel == 120 and level == 120 or level >= 110) and not isMobile and not CheckUnitInRaid(name,sName) and sName ~= module.db.playerFullName then
			if inRaid then
				InviteUnit(name)
			elseif nowinvnum < 5 then
				nowinvnum = nowinvnum + 1
				InviteUnit(name)
			else
				module.db.massinv = true
				return
			end
		end
	end
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
	if VExRT.InviteTool.Words then
		table.wipe(module.db.invWordsArray)
		local tmpCount = 1
		local tmpStr = strsplit(" ",VExRT.InviteTool.Words)
		while tmpStr do
			if tmpStr ~= "" and tmpStr ~= " " then
				module.db.invWordsArray[tmpStr] = 1
			end
			tmpCount = tmpCount + 1
			tmpStr = select(tmpCount,strsplit(" ",VExRT.InviteTool.Words))
		end
	end
end

local function createPromoteArray()
	if VExRT.InviteTool.PromoteNames then
		table.wipe(module.db.promoteWordsArray)
		local tmpCount = 1
		local tmpStr = strsplit(" ",VExRT.InviteTool.PromoteNames)
		while tmpStr do
			if tmpStr ~= "" and tmpStr ~= " " then
				module.db.promoteWordsArray[tmpStr] = 1
			end
			tmpCount = tmpCount + 1
			tmpStr = select(tmpCount,strsplit(" ",VExRT.InviteTool.PromoteNames))
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
	if VExRT.InviteTool.MasterLooters then
		table.wipe(module.db.masterlootersArray)
		local tmpCount = 1
		local tmpStr = strsplit(" ",strtrim(VExRT.InviteTool.MasterLooters))
		while tmpStr do
			if tmpStr ~= "" and tmpStr ~= " " then
				module.db.masterlootersArray[#module.db.masterlootersArray + 1] = tmpStr
			end
			tmpCount = tmpCount + 1
			tmpStr = select(tmpCount,strsplit(" ",strtrim(VExRT.InviteTool.MasterLooters)))
		end
	end
end

function module.options:Load()
	self:CreateTilte()

	self.dropDown = ELib:DropDown(self,205,10):Point(5,-30):Size(220)
	
	function self.dropDown:SetValue(newValue)
		VExRT.InviteTool.Rank = newValue
		module.options.dropDown:SetText( L.inviterank.." " .. GuildControlGetRankName(newValue) or "")
		ELib:DropDownClose()
		for i=1,#module.options.dropDown.List do
			module.options.dropDown.List[i].checkState = VExRT.InviteTool.Rank == module.options.dropDown.List[i].arg1
		end
	end

	if IsInGuild() then
		local granks = GuildControlGetNumRanks()
		for i=granks,1,-1 do
			self.dropDown.List[#self.dropDown.List + 1] = {
				text = GuildControlGetRankName(i) or "",
				checkState = VExRT.InviteTool.Rank == i,
				radio = true,
				func = self.dropDown.SetValue,
				arg1 = i,
			}
		end
		self.dropDown.Lines = #self.dropDown.List
	end
	
	self.butInv = ELib:Button(self,L.inviteinv):Size(200,20):Point(235,-30):OnClick(function() InviteBut() end)
	self.butInv.txt = ELib:Text(self,"/rt inv",11):Size(100,20):Point("LEFT",self.butInv,"RIGHT",5,0)
	
	self.butDisband = ELib:Button(self,L.invitedis):Size(430,20):Point(5,-55):OnClick(function() DisbandBut() end)
	self.butDisband.txt = ELib:Text(self,"/rt dis",11):Size(100,20):Point("LEFT",self.butDisband,"RIGHT",5,0)

	self.butReinvite = ELib:Button(self,L.inviteReInv):Size(430,20):Point(5,-80):OnClick(function() ReinviteBut() end)
	self.butReinvite.txt = ELib:Text(self,"/rt reinv",11):Size(100,20):Point("LEFT",self.butReinvite,"RIGHT",5,0)

	self.chkInvByChat = ELib:Check(self,L.invitewords,VExRT.InviteTool.InvByChat):Point(5,-115):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.InviteTool.InvByChat = true
			module:RegisterEvents('CHAT_MSG_WHISPER','CHAT_MSG_BN_WHISPER')
		else
			VExRT.InviteTool.InvByChat = nil
			module:UnregisterEvents('CHAT_MSG_WHISPER','CHAT_MSG_BN_WHISPER')
		end
	end)

	self.chkOnlyGuild = ELib:Check(self,L.inviteguildonly,VExRT.InviteTool.OnlyGuild):Point(5,-140):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.InviteTool.OnlyGuild = true
		else
			VExRT.InviteTool.OnlyGuild = nil
		end
	end)
	
	self.wordsInput = ELib:Edit(self):Size(650,20):Point(5,-165):Tooltip(L.invitewordstooltip):Text(VExRT.InviteTool.Words):OnChange(function(self)
		VExRT.InviteTool.Words = self:GetText()
		createInvWordsArray()
	end) 	
	
	self.chkAutoInvAccept = ELib:Check(self,L.inviteaccept,VExRT.InviteTool.AutoInvAccept):Point(5,-200):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.InviteTool.AutoInvAccept = true
			module:RegisterEvents('PARTY_INVITE_REQUEST')
		else
			VExRT.InviteTool.AutoInvAccept = nil
			module:UnregisterEvents('PARTY_INVITE_REQUEST')
		end
	end)
	
	self.chkAutoPromote = ELib:Check(self,L.inviteAutoPromote,VExRT.InviteTool.AutoPromote):Point(5,-235):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.InviteTool.AutoPromote = true
		else
			VExRT.InviteTool.AutoPromote = nil
		end
	end)
	
	self.dropDownAutoPromote = ELib:DropDown(self,205,10):Point(5,-260):Size(430)
	function self.dropDownAutoPromote:SetValue(newValue)
		VExRT.InviteTool.PromoteRank = newValue
		module.options.dropDownAutoPromote:SetText( L.inviterank.." " .. (newValue == 0 and L.inviteAutoPromoteDontUseGuild or GuildControlGetRankName(newValue) or ""))
		ELib:DropDownClose()
		for i=1,#module.options.dropDownAutoPromote.List do
			module.options.dropDownAutoPromote.List[i].checkState = VExRT.InviteTool.PromoteRank == module.options.dropDownAutoPromote.List[i].arg1
		end
	end
	if IsInGuild() then
		local granks = GuildControlGetNumRanks()
		for i=granks,1,-1 do
			self.dropDownAutoPromote.List[#self.dropDownAutoPromote.List + 1] = {
				text = GuildControlGetRankName(i) or "",
				checkState = VExRT.InviteTool.PromoteRank == i,
				radio = true,
				func = self.dropDownAutoPromote.SetValue,
				arg1 = i,
			}
		end
	end
	self.dropDownAutoPromote.List[#self.dropDownAutoPromote.List + 1] = {
		text = L.inviteAutoPromoteDontUseGuild,
		checkState = VExRT.InviteTool.PromoteRank == 0,
		radio = true,
		func = self.dropDownAutoPromote.SetValue,
		arg1 = 0,
	}
	self.dropDownAutoPromote.Lines = #self.dropDownAutoPromote.List	

	
	self.autoPromoteInput = ELib:Edit(self):Size(650,20):Point(5,-285):Tooltip(L.inviteAutoPromoteTooltip):Text(VExRT.InviteTool.PromoteNames):OnChange(function(self)
		VExRT.InviteTool.PromoteNames = self:GetText()
		createPromoteArray()
	end) 
	
	self.butRaidDemote = ELib:Button(self,L.inviteRaidDemote):Size(430,20):Point(5,-310):OnClick(function() demoteRaid() end)

	
	self.chkRaidDiff = ELib:Check(self,L.InviteRaidDiffCheck,VExRT.InviteTool.AutoRaidDiff):Point(5,-345):OnClick(function(self) 
		if self:GetChecked() then
			VExRT.InviteTool.AutoRaidDiff = true
		else
			VExRT.InviteTool.AutoRaidDiff = nil
		end
	end)
	
	local RaidDiffsDropDown = {
		{14,PLAYER_DIFFICULTY1},
		{15,PLAYER_DIFFICULTY2},
		{16,PLAYER_DIFFICULTY6},
	}
	self.dropDownRaidDiff = ELib:DropDown(self,235,10):Point(185,-370):Size(250)
	function self.dropDownRaidDiff:SetValue(newValue)
		VExRT.InviteTool.RaidDiff = RaidDiffsDropDown[newValue][1]
		module.options.dropDownRaidDiff:SetText( RaidDiffsDropDown[newValue][2] )
		ELib:DropDownClose()
		for i=1,#module.options.dropDownRaidDiff.List do
			module.options.dropDownRaidDiff.List[i].checkState = VExRT.InviteTool.RaidDiff == RaidDiffsDropDown[ module.options.dropDownRaidDiff.List[i].arg1 ][1]
		end
	end
	for i=1,#RaidDiffsDropDown do
		self.dropDownRaidDiff.List[i] = {
			text = RaidDiffsDropDown[i][2],
			checkState = VExRT.InviteTool.RaidDiff == RaidDiffsDropDown[i][1],
			radio = true,
			arg1 = i,
			func = self.dropDownRaidDiff.SetValue,
		}
	end
	self.dropDownRaidDiff.Lines = #self.dropDownRaidDiff.List
	do
		local diffName = ""
		for i=1,#RaidDiffsDropDown do
			if RaidDiffsDropDown[i][1] == VExRT.InviteTool.RaidDiff then
				diffName = RaidDiffsDropDown[i][2]
				break
			end
		end
		self.dropDownRaidDiff:SetText( diffName or "" )
	end
	
	self.dropDownRaidDiffText = ELib:Text(self,L.InviteRaidDiff,11):Size(150,20):Point("TOPLEFT",self.dropDownRaidDiff,-180,0)
	
	local LootMethodDropDown = {
		{"freeforall",LOOT_FREE_FOR_ALL},
		{"group",LOOT_GROUP_LOOT},
		{"master",LOOT_MASTER_LOOTER},
		{"needbeforegreed",LOOT_NEED_BEFORE_GREED},
		{"personalloot",LOOT_PERSONAL_LOOT},
		{"roundrobin",LOOT_ROUND_ROBIN},
	}
	self.dropDownLootMethod = ELib:DropDown(self,235,10):Point(185,-395):Size(250)
	function self.dropDownLootMethod:SetValue(newValue)
		VExRT.InviteTool.LootMethod = LootMethodDropDown[newValue][1]
		module.options.dropDownLootMethod:SetText( LootMethodDropDown[newValue][2] )
		ELib:DropDownClose()
		for i=1,#module.options.dropDownLootMethod.List do
			module.options.dropDownLootMethod.List[i].checkState = VExRT.InviteTool.LootMethod == LootMethodDropDown[ module.options.dropDownLootMethod.List[i].arg1 ][1]
		end
	end
	for i=1,#LootMethodDropDown do
		self.dropDownLootMethod.List[i] = {
			text = LootMethodDropDown[i][2],
			checkState = VExRT.InviteTool.LootMethod == LootMethodDropDown[i][1],
			radio = true,
			arg1 = i,
			func = self.dropDownLootMethod.SetValue,
		}
	end
	self.dropDownLootMethod.Lines = #self.dropDownLootMethod.List
	do
		local methodName = ""
		for i=1,#LootMethodDropDown do
			if LootMethodDropDown[i][1] == VExRT.InviteTool.LootMethod then
				methodName = LootMethodDropDown[i][2]
				break
			end
		end
		self.dropDownLootMethod:SetText( methodName or "" )
	end
	self.dropDownLootMethodText = ELib:Text(self,LOOT_METHOD..":",11):Size(150,20):Point("TOPLEFT",self.dropDownLootMethod,-180,0)
	
	
	self.masterlotersInput = ELib:Edit(self):Size(250,20):Point(185,-420):Tooltip(L.InviteMasterlootersTooltip):Text(VExRT.InviteTool.MasterLooters):OnChange(function(self)
		VExRT.InviteTool.MasterLooters = self:GetText()
		createMastelootersArray()
	end) 
	self.masterlotersInputText = ELib:Text(self,L.InviteMasterlooters,11):Size(180,20):Point("TOPLEFT",self.masterlotersInput,-180,0)
	
	
	local LootThresholdDropDown = {
		{2,"|c"..select(4,GetItemQualityColor(2))..ITEM_QUALITY2_DESC},
		{3,"|c"..select(4,GetItemQualityColor(3))..ITEM_QUALITY3_DESC},
		{4,"|c"..select(4,GetItemQualityColor(4))..ITEM_QUALITY4_DESC},
	}
	self.dropDownLootThreshold = ELib:DropDown(self,235,10):Point(185,-445):Size(250)
	function self.dropDownLootThreshold:SetValue(newValue)
		VExRT.InviteTool.LootThreshold = LootThresholdDropDown[newValue][1]
		module.options.dropDownLootThreshold:SetText( LootThresholdDropDown[newValue][2] )
		ELib:DropDownClose()
		for i=1,#module.options.dropDownLootThreshold.List do
			module.options.dropDownLootThreshold.List[i].checkState = VExRT.InviteTool.LootThreshold == LootThresholdDropDown[ module.options.dropDownLootThreshold.List[i].arg1 ][1]
		end

	end
	for i=1,#LootThresholdDropDown do
		self.dropDownLootThreshold.List[i] = {
			text = LootThresholdDropDown[i][2],
			checkState = VExRT.InviteTool.LootThreshold == LootThresholdDropDown[i][1],
			radio = true,
			arg1 = i,
			func = self.dropDownLootThreshold.SetValue,
		}
	end
	self.dropDownLootThreshold.Lines = #self.dropDownLootThreshold.List
	do
		local diffName = ""
		for i=1,#LootThresholdDropDown do
			if LootThresholdDropDown[i][1] == VExRT.InviteTool.LootThreshold then
				diffName = LootThresholdDropDown[i][2]
				break
			end
		end
		self.dropDownLootThreshold:SetText( diffName or "" )
	end
	self.dropDownLootThresholdText = ELib:Text(self,LOOT_THRESHOLD..":",11):Size(150,20):Point("TOPLEFT",self.dropDownLootThreshold,-180,0)

	
	self.HelpPlate = {
		FramePos = { x = 0, y = 0 },FrameSize = { width = 660, height = 615 },
		[1] = { ButtonPos = { x = 50,	y = -42 },  	HighLightBox = { x = 0, y = -25, width = 660, height = 80 },		ToolTipDir = "RIGHT",	ToolTipText = L.inviteHelpRaid },
		[2] = { ButtonPos = { x = 50,  y = -128 }, 	HighLightBox = { x = 0, y = -110, width = 660, height = 80 },		ToolTipDir = "RIGHT",	ToolTipText = L.inviteHelpAutoInv },
		[3] = { ButtonPos = { x = 50,  y = -187 }, 	HighLightBox = { x = 0, y = -195, width = 660, height = 30 },		ToolTipDir = "RIGHT",	ToolTipText = L.inviteHelpAutoAccept },
		[4] = { ButtonPos = { x = 50,  y = -255},  	HighLightBox = { x = 0, y = -230, width = 660, height = 105 },		ToolTipDir = "RIGHT",	ToolTipText = L.inviteHelpAutoPromote },
	}
	self.HELPButton = ExRT.lib.CreateHelpButton(self,self.HelpPlate)
	self.HELPButton:SetPoint("CENTER",self,"TOPLEFT",0,15)

	self.dropDown:SetText( L.inviterank.." " .. GuildControlGetRankName(VExRT.InviteTool.Rank) or "")
	self.dropDownAutoPromote:SetText( L.inviterank.." " .. (VExRT.InviteTool.PromoteRank == 0 and L.inviteAutoPromoteDontUseGuild or GuildControlGetRankName(VExRT.InviteTool.PromoteRank) or ""))
end


local promoteRosterUpdate
do
	local promotes,scheduledPromotes={},nil
	local guildmembers = nil
	
	local function GuildReview()
		guildmembers = {}
		for j=1,GetNumGuildMembers() do
			local guild_name,_,rankIndex = GetGuildRosterInfo(j)
			if guild_name then
				guildmembers[ExRT.F.delUnitNameServer(guild_name)] = rankIndex
			end
		end		
	end
	
	function promoteRosterUpdate()
		for i = 1, GetNumGroupMembers() do
			local name, rank = GetRaidRosterInfo(i)
			if name and rank == 0 then
				local sName = ExRT.F.delUnitNameServer(name)
				if module.db.promoteWordsArray[sName] then
					promotes[name] = true
				elseif IsInGuild() and UnitInGuild(sName) then
					if not guildmembers then
						GuildReview()
					end
					if (guildmembers[sName] or 99) < VExRT.InviteTool.PromoteRank then
						promotes[name] = true
					end
				end
			end
		end
		if not scheduledPromotes then
			scheduledPromotes = ExRT.F.ScheduleTimer(function ()
				scheduledPromotes = nil
				for name,v in pairs(promotes) do
					if not module.db.demotedPlayers[ ExRT.F.delUnitNameServer(name) ] then
						PromoteToAssistant(name)
					end
					promotes[name] = nil
				end
			end, 2)
		end
	end
end

function module.main:ADDON_LOADED()
	VExRT = _G.VExRT
	VExRT.InviteTool = VExRT.InviteTool or {OnlyGuild=true,InvByChat=true}
	VExRT.InviteTool.Rank = VExRT.InviteTool.Rank or 1
	
	VExRT.InviteTool.Words = VExRT.InviteTool.Words or "инв inv byd штм 123"
	createInvWordsArray()
	
	VExRT.InviteTool.PromoteNames = VExRT.InviteTool.PromoteNames or ""
	VExRT.InviteTool.PromoteRank = VExRT.InviteTool.PromoteRank or 3
	createPromoteArray()
	
	VExRT.InviteTool.RaidDiff = VExRT.InviteTool.RaidDiff or 16
	VExRT.InviteTool.LootMethod = VExRT.InviteTool.LootMethod or "group"
	VExRT.InviteTool.MasterLooters = VExRT.InviteTool.MasterLooters or ""
	VExRT.InviteTool.LootThreshold = VExRT.InviteTool.LootThreshold or 2
	createMastelootersArray()
	
	module:RegisterEvents('GROUP_ROSTER_UPDATE')
	if VExRT.InviteTool.InvByChat then
		module:RegisterEvents('CHAT_MSG_WHISPER','CHAT_MSG_BN_WHISPER')
	end
	if VExRT.InviteTool.AutoInvAccept then
		module:RegisterEvents('PARTY_INVITE_REQUEST','GROUP_INVITE_CONFIRMATION')
	end
	
	module:RegisterSlash()
	
	module.db.playerFullName = ExRT.F.UnitCombatlogname("player")
end

function module.main:CHAT_MSG_WHISPER(msg, user)
	msg = string.lower(msg)
	if (msg and module.db.invWordsArray[msg]) and (not VExRT.InviteTool.OnlyGuild or UnitInGuild(user)) then
		if not IsInRaid() and GetNumGroupMembers() == 5 then 
			ConvertToRaid()
		end
		InviteUnit(user)
	end
end

function module.main:CHAT_MSG_BN_WHISPER(msg,sender,_,_,_,_,_,_,_,_,_,_,senderBnetIDAccount)
	msg = string.lower(msg)
	if not (msg and module.db.invWordsArray[msg]) then
		return
	end
	if not IsInRaid() and GetNumGroupMembers() == 5 then 
		ConvertToRaid()
	end

	local _,BNcount=BNGetNumFriends() 
	for i=1,BNcount do 
		if senderBnetIDAccount == BNGetFriendInfo(i) then
			local numGameAccounts = BNGetNumFriendGameAccounts(i)
			for j=1,numGameAccounts do
				local hasFocus, characterName, client, realmName, realmID, faction, race, class, _, _, level, _, _, _, _, bnetIDGameAccount = BNGetFriendGameAccountInfo(i, j)
				if client == BNET_CLIENT_WOW and faction == UnitFactionGroup('player') and (not VExRT.InviteTool.OnlyGuild or (characterName and UnitInGuild(characterName))) then
					BNInviteFriend(bnetIDGameAccount)
				end
			end
			break
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
				
				SetRaidDifficultyID(VExRT.InviteTool.RaidDiff)
				SetLootMethod(VExRT.InviteTool.LootMethod,UnitName("player"),nil)
				--SetLootThreshold(VExRT.InviteTool.LootThreshold)	--http://us.battle.net/wow/en/forum/topic/14610481537
				ExRT.F.ScheduleTimer(SetLootThreshold, 2, VExRT.InviteTool.LootThreshold)
			end
		elseif not inRaid and module.db.sessionInRaid then
			module.db.sessionInRaid = nil
		end
	else
		if inRaid and not module.db.sessionInRaidLoot then
			module.db.sessionInRaidLoot = true
			if RaidLeader then
				SetLootMethod(VExRT.InviteTool.LootMethod,UnitName("player"),nil)
				ExRT.F.ScheduleTimer(SetLootThreshold, 2, VExRT.InviteTool.LootThreshold)
			end
		end	
	end
	
	if inRaid and RaidLeader and VExRT.InviteTool.LootMethod == "master" then
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
	if module.db.converttoraid then
		module.db.converttoraid = false
		ConvertToRaid()
	end
	local inRaid = IsInRaid()
	if module.db.reInviteR and inRaid then
		module.db.reInviteR = nil
		ReinviteHelpFunc()
		return
	end
	if module.db.massinv and inRaid then
		module.db.massinv = false
		InviteBut()
	end
	if inRaid and UnitIsGroupLeader("player") then
		promoteRosterUpdate()
	end
	
	if VExRT.InviteTool.AutoRaidDiff then
		if not scheludedRaidUpdate then
			scheludedRaidUpdate = ExRT.F.ScheduleTimer(AutoRaidSetup, .5)
		end
	end
end

do
	local function IsFriend(name)
		for i=1,GetNumFriends() do if(GetFriendInfo(i)==name) then return true end end
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
		if true then
			return
		end
		local firstInvite = GetNextPendingInviteConfirmation()
		if ( not firstInvite ) then
			return
		end
		local confirmationType, name = GetInviteConfirmationInfo(firstInvite)
		local suggesterGuid, suggesterName, relationship = GetInviteReferralInfo(firstInvite)
		if (suggesterName and IsFriend(ExRT.F.delUnitNameServer(suggesterName))) or (name and IsFriend(ExRT.F.delUnitNameServer(name))) then
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
	end
end
