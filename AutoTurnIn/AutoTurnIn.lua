--[[
Feel free to use this source code for any purpose ( except developing nuclear weapon! :)
Please keep original author statement.
@author Alex Shubert (alex.shubert@gmail.com)
]]--
local _G = _G 	--Rumors say that global _G is called by lookup in a super-global table. Have no idea whether it is true.
local _ 		--Sometimes blizzard exposes "_" variable as a global.
local addonName, ptable = ...
local L = ptable.L
local C = ptable.CONST
local Q_DAILY, Q_EXCEPTDAILY = 2, 3
local questNPCName = nil
local dragonflight = ptable.defaults.interface10


AutoTurnIn = LibStub("AceAddon-3.0"):NewAddon("AutoTurnIn", "AceEvent-3.0", "AceConsole-3.0")
AutoTurnIn.TOC = select(4, GetBuildInfo())
AutoTurnIn.defaults = ptable.defaults

AutoTurnIn.ldb, AutoTurnIn.allowed = nil, nil
AutoTurnIn.funcList = {[1] = function() return false end, [2]=IsAltKeyDown, [3]=IsControlKeyDown, [4]=IsShiftKeyDown}
AutoTurnIn.OptionsPanel, AutoTurnIn.RewardPanel = nil, nil
AutoTurnIn.autoEquipList={}
AutoTurnIn.questCache={}	-- daily quest cache. Initially is built from player's quest log
AutoTurnIn.knownGossips={}
AutoTurnIn.ERRORVALUE = nil
AutoTurnIn.IgnoreButton = {["quest"] = nil, ["gossip"] = nil}

-- see https://github.com/tekkub/libdatabroker-1-1/wiki/api
function AutoTurnIn:LibDataStructure()
	if not AutoTurnIn.ldb then
		local LDB = LibStub:GetLibrary("LibDataBroker-1.1", true)
		if LDB then
			AutoTurnIn.ldb = LDB:NewDataObject("AutoTurnIn", {
				type = "data source",
				icon = "Interface\\QUESTFRAME\\UI-QuestLog-BookIcon",
				label = addonName,
				OnClick = function(clickedframe, button)
					-- if InCombatLockdown() then return end
					if (button == "LeftButton") then
						self:ShowOptions()
					else
						self:SetEnabled(not AutoTurnInCharacterDB.enabled)
					end
				end,
		        OnTooltipShow = function(tooltip)  --TODO:abyui10
		            tooltip:AddLine(addonName)
		            tooltip:AddLine(GetAddOnMetadata(addonName, "Notes-" .. GetLocale()) or GetAddOnMetadata(addonName, "Notes").." "..(AutoTurnInCharacterDB.enabled and ENABLE or DISABLE))
		        end,				
				OnTooltipShow = function()
					self:AddLine(addonName)
					self:AddLine("Left mouse button shows options.")
					self:AddLine("Right mouse button toggle addon on/off.")
				end
			})
		end
	end
end

function AutoTurnIn:ShowOptions()
	-- too much things became tainted if called in combat.
	if InCombatLockdown() then return end
	InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.OptionsPanel)

	-- if (InterfaceOptionsFrame:IsVisible() and InterfaceOptionsFrameAddOns.selection) then
	-- 	if (InterfaceOptionsFrameAddOns.selection:GetName() == AutoTurnIn.OptionsPanel:GetName()) then --"AutoTurnInOptionsPanel"
	-- 		InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.RewardPanel)
	-- 	elseif (InterfaceOptionsFrameAddOns.selection:GetName() == AutoTurnIn.RewardPanel:GetName() ) then --"AutoTurnInRewardPanel"
	-- 	-- it used to be a cancel. But BlizzardUI contains weird bug which taints all the interface if InterfaceOptionsFrameCancel:Click() called 
	-- 		InterfaceOptionsFrameOkay:Click()
	-- 	end
	-- else
	-- 	-- http://wowpedia.org/Patch_5.3.0/API_changes double call is a workaround
	-- 	InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.OptionsPanel)
	-- 	InterfaceOptionsFrame_OpenToCategory(AutoTurnIn.OptionsPanel)
	-- end
end

function AutoTurnIn:OnInitialize()
	self:RegisterChatCommand("au", "ConsoleComand")
	if (AutoTurnInCharacterDB and not AutoTurnInCharacterDB.IGNORED_NPC) then AutoTurnInCharacterDB.IGNORED_NPC = {} end

	--self.db = LibStub("AceDB-3.0"):New("HandyNotesDB", defaults)
end	

function AutoTurnIn:SetEnabled(enabled)
	AutoTurnInCharacterDB.enabled = not not enabled
	if self.ldb then
		self.ldb.text = (AutoTurnInCharacterDB.enabled) and '|cff00ff00'..ENABLE..'|r' or '|cffff0000'..DISABLE..'|r'
	end
end

-- quest autocomplete handlers and functions
function AutoTurnIn:OnEnable()
	local TOCVersion = GetAddOnMetadata(addonName, "Version")
	if (not AutoTurnInCharacterDB) or (not AutoTurnInCharacterDB.IGNORED_NPC) or (not AutoTurnInCharacterDB.version or (AutoTurnInCharacterDB.version < TOCVersion)) then
        AutoTurnInCharacterDB = nil
		--self:Print(L["reset"])
	end

	if not AutoTurnInCharacterDB then
		_G.AutoTurnInCharacterDB = CopyTable(self.defaults)
	end

	local DB = AutoTurnInCharacterDB

	if (tonumber(DB.lootreward) == nil) then
		DB.lootreward = 1
	end
	if (tonumber(DB.togglekey) == nil) then
		DB.togglekey = 1
	end
	DB.armor = DB.armor and DB.armor or {}
	DB.weapon = DB.weapon and DB.weapon or {}
	DB.stat = DB.stat and DB.stat or {}
	DB.secondary = DB.secondary and DB.secondary or {}
	DB.trivial = DB.trivial ~= nil and DB.trivial or false

	DB.questlevel = DB.questlevel == nil and true or DB.questlevel
	DB.watchlevel = DB.watchlevel == nil and true or DB.watchlevel
	DB.questshare = DB.questshare == nil and false or DB.questshare
	DB.relictoggle = DB.relictoggle == nil and true or DB.relictoggle
	DB.artifactpowertoggle = DB.artifactpowertoggle == nil and true or DB.artifactpowertoggle
    DB.acceptshare = DB.acceptshare == nil and false or DB.acceptshare

	self:SetEnabled(DB.enabled)
	self:RegisterForEvents()
	self:LibDataStructure()

	-- See no way tp fix taint issues with quest special items.
	hooksecurefunc("ObjectiveTracker_Update", AutoTurnIn.ShowQuestLevelInWatchFrame)
	hooksecurefunc("QuestLogQuests_Update", AutoTurnIn.ShowQuestLevelInLog)
end

function AutoTurnIn:OnDisable()
  self:UnregisterAllEvents()
end

--[[ 
	GOSSIP SHOW 
--]]
function AutoTurnIn:RegisterForEvents()
	self:RegisterEvent("QUEST_GREETING")
	self:RegisterEvent("GOSSIP_SHOW")
	self:RegisterEvent("QUEST_DETAIL")
	self:RegisterEvent("QUEST_PROGRESS")
	self:RegisterEvent("QUEST_COMPLETE")
	self:RegisterEvent("QUEST_LOG_UPDATE")
	self:RegisterEvent("QUEST_ACCEPTED")
	if AutoTurnInCharacterDB.reviveBattlePet --[[ and select(2, UnitClass("player")) == "HUNTER" ]] then 
		self:RegisterEvent("GOSSIP_CONFIRM") 
	end
	
	local gossipFunc1 = function() AutoTurnIn:Print(L["ivechosen"]); C_GossipInfo.SelectOption(1) end
	local gossipFunc2 = function() if (C_GossipInfo.GetNumOptions and C_GossipInfo.GetNumOptions() == 2) then C_GossipInfo.SelectOption(1) end end
	local gossipFunc3 = function()
		if (AutoTurnInCharacterDB.todarkmoon and GetRealZoneText() ~= L["Darkmoon Island"]
			and C_GossipInfo.GetNumAvailableQuests() == 0) then
			--accept available quest first, then teleport
			AutoTurnIn:Print("Teleporting to " .. L["Darkmoon Island"])
			C_GossipInfo.SelectOption(1)
			StaticPopup1Button1:Click()
		end 
	end
	local gossipFunc4 = function() 
		if AutoTurnInCharacterDB.darkmoonteleport then
			AutoTurnIn:Print("Teleporting to cannon")
			C_GossipInfo.SelectOption(1)
			StaticPopup1Button1:Click() 
		end 
	end
	local gossipFunc5 = function() 
		if AutoTurnInCharacterDB.dismisskyriansteward then
			AutoTurnIn:Print(L["ivechosenfive"])
			C_GossipInfo.SelectOption(5)
		end
	end
	local gossipFunc6 = function()
		if AutoTurnInCharacterDB.covenantswapgossipcompletion then
			C_GossipInfo.SelectOption(1)
			C_GossipInfo.SelectOption(1)
			StaticPopup1Button1:Click()
		end
	end
	AutoTurnIn.knownGossips = {
		["171787"]=gossipFunc6, -- Polemarch Adrestes (Kyrian)
		["171795"]=gossipFunc6, -- Lady Moonberry (Night Fae)
		["171589"]=gossipFunc6, -- General Draven (Venthyr)
		["171821"]=gossipFunc6, -- Secutor Mevix (Necrolord)
		["93188"]=gossipFunc1, -- Mongar
		["96782"]=gossipFunc1, -- Lucian Trias
		["97004"]=gossipFunc1, -- "Red" Jack Findle
		["55267"]=gossipFunc1, -- YoungPandaren
		["79815"]=gossipFunc2, -- Grunlek, free seals Alliance
		["77377"]=gossipFunc2, -- Kristen Stoneforge, free seals Horde
		["54334"]=gossipFunc3, -- travel to Darkmoon
		["55382"]=gossipFunc3, -- travel to Darkmoon
		["57850"]=gossipFunc4, -- DarkmoonFaireTeleportologist
		["166663"]=gossipFunc5, -- Kyrian Steward
	}
end

function AutoTurnIn:QUEST_LOG_UPDATE()
	if ( C_QuestLog.GetNumQuestLogEntries() > 0 ) then
		for index=1, C_QuestLog.GetNumQuestLogEntries() do
			local questInfo = C_QuestLog.GetInfo(index)			
			if (questInfo and not questInfo.isHeader and self:_isDaily(questInfo)) then
				self.questCache[questInfo.title] = true
			end
		end
		self:UnregisterEvent("QUEST_LOG_UPDATE")
	end
end

function AutoTurnIn:_isDaily(questInfo) 
	return questInfo and 
	(questInfo.frequency == Enum.QuestFrequency.Daily or 
		questInfo.frequency == Enum.QuestFrequency.Weekly or 
		questInfo.repeatable)
end

-- Available check requires cache
-- Active check query API function Returns true if quest matches options
function AutoTurnIn:isAppropriate(questname, byCache)
    local daily
    if byCache then
        daily = (not not self.questCache[questname])
    else
    	-- for some reason questInfo in gossip table return data different from one from QuestCache
    	local questID = GetQuestID()
    	local qn = questname or (questID and QuestCache:Get(questID).title or "");
        daily = QuestIsDaily() or QuestIsWeekly() or (not not self.questCache[qn])
    end

    return self:_isAppropriate(daily)
end

-- 'private' function
function AutoTurnIn:_isAppropriate(daily)
    if daily then
        return (AutoTurnInCharacterDB.all ~= Q_EXCEPTDAILY)
    else
        return (AutoTurnInCharacterDB.all ~= Q_DAILY)
    end
end

-- caches offered by gossip quest as daily
function AutoTurnIn:CacheAsDaily(questname)
	self.questCache[questname] = true
end

function AutoTurnIn:IsIgnoredQuest(quest)
	local function startsWith(str,template)
		return (string.len(str) >= string.len(template)) and (string.sub(str,1,string.len(template))==template)
	end

	for q in pairs(L.ignoreList) do
		if (startsWith(quest, q) or quest:find(q.."$")) then
			return true
		end
	end

	return false
end

function AutoTurnIn:ConsoleComand(arg)
	arg = strlower(arg)
	if (#arg == 0) then
		self:ShowOptions()
	elseif arg == "on" then
		self:SetEnabled(true)
		self:Print(L["enabled"])
	elseif arg == "off"  then
		self:SetEnabled(false)
		self:Print(L["disabled"])	
	end
end

-- returns specified item count on player character. It may be some sort of currency or present in inventory as real items.
function AutoTurnIn:GetItemAmount(isCurrency, item)
	local amount = isCurrency and C_CurrencyInfo.GetCurrencyInfo(item).quantity or GetItemCount(item, nil, true)
	return amount and amount or 0
end

-- returns set 'self.allowed' to true if addon is allowed to handle current gossip conversation
-- Cases when it may not : (addon is enabled and toggle key was pressed) or (addon is disabled and toggle key is not pressed)
-- 'forcecheck' does what it name says: forces check
function AutoTurnIn:AllowedToHandle(forcecheck)
	if ( self.allowed == nil or forcecheck ) then
		-- Double 'not' converts possible 'nil' to boolean representation
		local IsModifiedClick = not not self.funcList[AutoTurnInCharacterDB.togglekey]()
		-- it's a simple xor implementation (a ~= b)
		self.allowed = (not not AutoTurnInCharacterDB.enabled) ~= (IsModifiedClick)
	end
	return self.allowed and (not AutoTurnIn:IsIgnoredNPC())
end

-- Old 'Quest NPC' interaction system. See http://wowprogramming.com/docs/events/QUEST_GREETING
function AutoTurnIn:QUEST_GREETING()
	if (not self:AllowedToHandle(true)) then
		return
	end

	for index=1, GetNumActiveQuests() do
		local quest, isComplete = GetActiveTitle(index)
		if isComplete and (self:isAppropriate(quest, true)) then
			SelectActiveQuest(index)
		end
	end

    if not AutoTurnInCharacterDB.completeonly then
        for index=1, GetNumAvailableQuests() do
            local isTrivial, isDaily, isRepeatable, isIgnored = GetAvailableQuestInfo(index)
			if (isIgnored) then return end -- Legion functionality
			
            local triviaAndAllowedOrNotTrivia = (not isTrivial) or AutoTurnInCharacterDB.trivial
            local title = GetAvailableTitle(index)
            local quest = L.quests[title]
            local notBlackListed = not (quest and (quest.donotaccept or AutoTurnIn:IsIgnoredQuest(title)))

			-- isDaily was a boolean, but is a number now. but maybe it's still a boolean somewhere
			if (type(isDaily) == "number" and isDaily ~= 0) then isDaily = true else isDaily = false end
			
            if isDaily then
                self:CacheAsDaily(GetAvailableTitle(index))
            end
			
            if (triviaAndAllowedOrNotTrivia and notBlackListed and self:_isAppropriate(isDaily)) then
                if quest and quest.amount then
                    if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
                        SelectAvailableQuest(index)
                    end
                else
                    SelectAvailableQuest(index)
                end
            end
        end
    end
end

function AutoTurnIn:VarArgForActiveQuests(gossipInfos)
	for index, gossipInfo in ipairs(gossipInfos) do
		if (gossipInfo.isComplete) then
			local questname = gossipInfo.title
			if self:isAppropriate(questname, true) then
				local quest = L.quests[questname]
				if quest and quest.amount then
					if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
						C_GossipInfo.SelectActiveQuest(index)
						self.DarkmoonAllowToProceed = false
					end
				else
					C_GossipInfo.SelectActiveQuest(index)
					self.DarkmoonAllowToProceed = false
				end
			end
		end
	end
end

function AutoTurnIn:VarArgForAvailableQuests(gossipInfos)
	for index, questInfo in ipairs(gossipInfos) do
		local triviaAndAllowedOrNotTrivial = (not questInfo.isTrivial) or AutoTurnInCharacterDB.trivial
		local quest = L.quests[questInfo.title] -- this quest exists in addons quest DB. There are mostly daily quests
		local notBlackListed = not (quest and (quest.donotaccept or AutoTurnIn:IsIgnoredQuest(questInfo.title)))
		local isDaily = self:_isDaily(questInfo)
		
		-- for unknown reason the questInfo is different from what is seen in QuestCache:Get(questID);
		if isDaily then
			self:CacheAsDaily(questInfo.title)
		end 
		
		-- Quest is appropriate if: (it is trivial and trivial are accepted) and (any quest accepted or (it is daily quest that is not in ignore list))
		if (triviaAndAllowedOrNotTrivial and notBlackListed and self:_isAppropriate(isDaily)) then
			if quest and quest.amount then
				if self:GetItemAmount(quest.currency, quest.item) >= quest.amount then
					C_GossipInfo.SelectAvailableQuest(index)
				end
			else
				C_GossipInfo.SelectAvailableQuest(index)
			end
		end
	end
end

-- Extracts GUID from the NPC which dialog window is currenty displayed
function AutoTurnIn:GetNPCGUID()
	local a = UnitGUID("npc")
	return a and select(3, a:find("Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-")) or nil
end

function AutoTurnIn:isDarkmoonAndAllowed(questCount)
	return (self.DarkmoonAllowToProceed and questCount) and
			AutoTurnInCharacterDB.darkmoonautostart and
			(GetZoneText() == L["Darkmoon Island"])
end

function AutoTurnIn:GOSSIP_CONFIRM(event, _, message, cost)
	if message == L["ReviveBattlePetA"] and cost == 1000 then
		local dialog = StaticPopup_FindVisible("GOSSIP_CONFIRM")
		if dialog then
			StaticPopup_OnClick(dialog, 1)
		end
	end
end

function AutoTurnIn:GOSSIP_SHOW()
	if (not self:AllowedToHandle(true)) then
		return
	end

	-- darkmoon fairy gossip sometime turns in quest too fast so I can't relay only on quest number count. It often lie.
	-- this flag is set in VarArgForActiveQuests if any quest may be turned in
	self.DarkmoonAllowToProceed = true	
	local questCount = C_GossipInfo.GetNumActiveQuests() > 0
	
	self:VarArgForActiveQuests(C_GossipInfo.GetActiveQuests())
    if not AutoTurnInCharacterDB.completeonly then
	    self:VarArgForAvailableQuests(C_GossipInfo.GetAvailableQuests())
	end
	
	if self:isDarkmoonAndAllowed(questCount) then
		local options = C_GossipInfo.GetOptions()
		for index, gossipInfo in ipairs(options) do
			if ((gossipInfo.type == "gossip") and strfind(gossipInfo.name, "|cFF0008E8%(")) then
				return C_GossipInfo.SelectOption(index)
			end
		end
	end

	self:HandleGossip()
end

local trivialNoText = {}
function AutoTurnIn:QUEST_DETAIL()
	if (QuestIsDaily() or QuestIsWeekly()) then
		self:CacheAsDaily(GetTitleText())
	end
	if QuestGetAutoAccept() then
		if AutoTurnInCharacterDB.enabled then CloseQuest() end
		
    elseif AutoTurnInCharacterDB.acceptshare and (UnitInParty("questnpc") or UnitInRaid("questnpc")) then
        QuestInfoDescriptionText:SetAlphaGradient(0, -1)
        QuestInfoDescriptionText:SetAlpha(1)
        AcceptQuest()

	else
		if self:AllowedToHandle() and self:isAppropriate() and (not AutoTurnInCharacterDB.completeonly) then
			--ignore trivial quests 
			if (not C_QuestLog.IsQuestTrivial(GetQuestID()) or AutoTurnInCharacterDB.trivial) then
				QuestInfoDescriptionText:SetAlphaGradient(0, 5000)
				QuestInfoDescriptionText:SetAlpha(1)
				AcceptQuest()
				return
			end
		end
		--quest level on detail frame
		if AutoTurnInCharacterDB.questlevel then 
			local qid = GetQuestID()
			local level = C_QuestLog.GetQuestDifficultyLevel(qid)
			--sometimes it returns 0, but that's wrong
			if level and level > 0 then 			
				local text = QuestInfoTitleHeader:GetText()
				if text then -- there are reports (unconfirmed) that some trivial quests return nil for text
					local levelFormat = "[%d] %s"
					--trivial display
					if C_QuestLog.IsQuestTrivial(qid) then text = TRIVIAL_QUEST_DISPLAY:format(text) end
					QuestInfoTitleHeader:SetText(levelFormat:format(level, text))
				else
					if (not not trivialNoText[qid]) then
						trivialNoText[qid] = true
						self:Print("[AutoTurnIn] Quest has nil title [" .. qid .. "]. Could you please report it to AutoTurnIn author?")						
					end
				end
			end
		end
	end
end

-- TODO: needs testing with another player
function AutoTurnIn:QUEST_ACCEPTED(event, index)
	if AutoTurnInCharacterDB.questshare and GetNumGroupMembers() >= 1 and not IsInRaid() then --abyui 不Select的话，判断不准确
        C_QuestLog.SetSelectedQuest(index);
        if C_QuestLog.IsPushableQuest(index) then
            if U1Message then U1Message("已自动分享任务，可在<自动交接任务>的配置选项里关闭") end
    		QuestLogPushQuest();
        end
	end
end

function AutoTurnIn:QUEST_PROGRESS()
    if  (self:AllowedToHandle() and IsQuestCompletable() and (self:isAppropriate() or self:IsWantedQuest(GetQuestID()))) then
		CompleteQuest()
    end
end

function AutoTurnIn:HandleGossip()
	local guid = AutoTurnIn:GetNPCGUID()
	local func = AutoTurnIn.knownGossips[guid]
	if func then 
		func() 
	else
		-- https://www.wowinterface.com/forums/showthread.php?t=49210 adaptation
		if AutoTurnInCharacterDB.reviveBattlePet then
			local options = C_GossipInfo.GetOptions()
			for index, gossipInfo in ipairs(options) do
				if gossipInfo.name == L["ReviveBattlePetQ"] then
					return C_GossipInfo.SelectOption(index)
				end
			end
		end 
	end
end 

-- return true if an item is of `ranged` type and is suitable with current options
function AutoTurnIn:IsRangedAndRequired(subclass)
	return (AutoTurnInCharacterDB.weapon['Ranged'] and
		(C.ITEMS['Crossbows'] == subclass or C.ITEMS['Guns'] == subclass or C.ITEMS['Bows'] == subclass))
end

-- return true if an item is of `Jewelry` type and is suitable with current options
function AutoTurnIn:IsJewelryAndRequired(equipSlot)
	return AutoTurnInCharacterDB.armor['Jewelry'] and (C.JEWELRY[equipSlot])
end

-- initiated in AutoTurnIn:TurnInQuest PLAYER_LEAVE_COMBAT ? PLAYER_REGEN_ENABLED ?
AutoTurnIn.delayFrame = CreateFrame('Frame')
AutoTurnIn.delayFrame:Hide()
AutoTurnIn.delayFrame:SetScript('OnUpdate', function()
	if not next(AutoTurnIn.autoEquipList) then
		AutoTurnIn.delayFrame:Hide()
		return
	end

	if (InCombatLockdown()) then
		return
	end

	if (time() < AutoTurnIn.delayFrame.delay) then
		return
	end

	for bag=0, NUM_BAG_SLOTS do
		for slot=1, GetContainerNumSlots(bag), 1 do
			local link = GetContainerItemLink (bag, slot)
			if ( link ) then
				local name = GetItemInfo(link)
				if ( name and AutoTurnIn.autoEquipList[name] ) then
					AutoTurnIn:Print(L["equipping reward"], link)
					EquipItemByName(name, AutoTurnIn.autoEquipList[name])
					AutoTurnIn.autoEquipList[name]=nil
				end
			end
		end
	end
end)

-- return 0 if itemlink is null, item level is math.huge if the item is heirloom
function AutoTurnIn:ItemLevel(itemLink)
	if (not itemLink) then
		return 0
	end
	-- 7 for heirloom http://wowprogramming.com/docs/api_types#itemQuality
	local invQuality, invLevel = select(3, GetItemInfo(itemLink))
	return (invQuality == 7) and math.huge or invLevel
end

function AutoTurnIn:swapEquip(itemLink)
	local name = GetItemInfo(itemLink)
	if (self.autoEquipList[name]) then
		self.delayFrame.delay = time() + 2
		self.delayFrame:Show()
	end
end

-- turns quest in printing reward text if `showrewardtext` option is set.
-- prints appropriate message if item is taken by greed
-- equips received reward if such option selected
function AutoTurnIn:TurnInQuest(rewardIndex)
	if (AutoTurnInCharacterDB.showrewardtext) then
		self:Print((UnitName("target") and UnitName("target") or '')..'\n', GetRewardText())
	end

	if (self.forceGreed) then
		if  (GetNumQuestChoices() > 1) then
			self:Print(L["gogreedy"])
		end
	else
		if AutoTurnInCharacterDB.autoequip then
			local itemLink1 = GetQuestItemLink("choice", (GetNumQuestChoices() == 1) and 1 or rewardIndex)
			-- Unconditional quest reward
			local itemLink2 
			if GetNumQuestRewards() > 0 then
				itemLink2 = GetQuestItemLink("reward", 1)
			end
			-- if we have 2 items for same slot check which one is better
			if (not not itemLink1 and not not itemLink2) then
				local lootLevel1, _, _, _, _, equipSlot1 = select(4, GetItemInfo(itemLink1))
				local lootLevel2, _, _, _, _, equipSlot2 = select(4, GetItemInfo(itemLink2))
				if (equipSlot1 == equipSlot2) then
					if lootLevel1 > lootLevel2 then
						itemLink2 = nil
					else
						itemLink1 = nil
					end
				end
			end
			
			if (not not itemLink1) then 
				-- can be already checked
				local name = GetItemInfo(itemLink1)
				if (not self.autoEquipList[name]) then
					self:isSuitableItem(itemLink1)
				end
				self:swapEquip(itemLink1)
			end
			if (not not itemLink2 and not not self:isSuitableItem(itemLink2)) then
				self:swapEquip(itemLink2)
			end
		end
	end

	if (AutoTurnInCharacterDB.debug) then
		local link = GetQuestItemLink("choice", rewardIndex)
		if (link) then
			self:Print("Debug: item to loot=", link)
		elseif (GetNumQuestChoices() == 0) then
			self:Print("Debug: turning quest in, no choice required")
		end
    else
		GetQuestReward(rewardIndex)
	end
end

function AutoTurnIn:Greed()
	local index, money = 0, 0;

	for i=1, GetNumQuestChoices() do
		local link = GetQuestItemLink("choice", i)
		if ( link == nil ) then
			return
		end
		local m = select(11, GetItemInfo(link))
		if m > money then
			money = m
			index = i
		end
	end

	if money > 0 then  -- some quests, like tournament ones, offer reputation rewards and they have no cost.
		self.forceGreed = true
		self:TurnInQuest(index)
	end
end

--[[
iterates all rewards and compares with chosen stats and types. If only one appropriate item found then it accepted and quest is turned in.
if more than one suitable item found then item list is shown in a chat window and addons return control to player.

@returns 'true' if one or more suitable reward is found, 'false' otherwise ]]--
-- tables are declared here to optimize memory model. Said that in current implementation it's cheaper to wipe than to create.

AutoTurnIn.found, AutoTurnIn.stattable = {}, {}
function AutoTurnIn:Need()
	wipe(self.found)
	for i=1, GetNumQuestChoices() do
		local checkResult = AutoTurnIn:isSuitableItem(GetQuestItemLink("choice", i))
		if checkResult == nil then
			-- not suitable item
		elseif checkResult == false then
			-- Error getting item or trinket was found
			return true
		else
			tinsert(self.found, {index=i, points=checkResult})
		end
	end

	-- HANDLE RESULT
	local foundCount = #self.found
	if foundCount > 1 then
		-- sorting found items by relevance (count of attributes that concidence)
		table.sort(self.found, function(a,b) return a.points > b.points end)

		if (self.found[1].points == self.found[2].points) then
			self:Print(L["multiplefound"])
			for _, reward in pairs(self.found) do
				-- show only top points items
				if reward.points ~= self.found[1].points then break end
				self:Print(GetQuestItemLink("choice", reward.index))
			end
		else
			self:TurnInQuest(self.found[1].index)
		end
	elseif(foundCount == 1) then
		self:TurnInQuest(self.found[1].index)
	elseif  ( foundCount == 0 and GetNumQuestChoices() > 0 ) and ( not AutoTurnInCharacterDB.greedifnothingfound ) then
		self:Print(L["nosuitablefound"])
	end

	return ( foundCount ~= 0 )
end

function AutoTurnIn:isSuitableItem(link)
	if ( link == nil ) then
		self:Print(L["rewardlag"])
		return false
	end

	local name, _, _, _, _, class, subclass, _, invType = GetItemInfo(link)
	--effective loot level
	local lootLevel = GetDetailedItemLevelInfo(link)
	-- non equippable items
	if (invType == "") then
		return nil
	end
	
	--trinkets are out of autoloot--
	if  ( 'INVTYPE_TRINKET' == invType )then
		self:Print(L["stopitemfound"]:format(_G[invType]))
		return false
	end
	
	-- User may not choose any options hence any item became 'ok'. That situation is undoubtedly incorrect.
	local SettingsExists = (class == C.WEAPONLABEL and next(AutoTurnInCharacterDB.weapon) or next(AutoTurnInCharacterDB.armor))
							or next(AutoTurnInCharacterDB.stat)
	if (not SettingsExists) then
		self:Print(L["norewardsettings"])
		return nil
	end
	
	local points = self:itemPoints(link)
	-- points > 0 means that particular options section is empty or item meets requirements
	if (points > 0) then
		-- comparing with currently equipped item
		local slot = C.SLOTS[invType]
		if (slot) then
			local firstSlot = GetInventorySlotInfo(slot[1])
			local invLink = GetInventoryItemLink("player", firstSlot)
			-- nothing equipped
			if invLink == nil then
				if slot[1] == "SecondaryHandSlot" then
					-- will not equip offhand if main hand has 2h-weapon
					local mainHandLink = GetInventoryItemLink("player", GetInventorySlotInfo("MainHandSlot"))
					local mainHandType = select(9, GetItemInfo(mainHandLink))
					if mainHandType == "INVTYPE_2HWEAPON" then
						if (AutoTurnInCharacterDB.debug) then
							self:Print(link, "can not be equipped over", mainHandLink)
						end
						return nil
					end
				end
				-- 
				if (AutoTurnInCharacterDB.debug) then
					self:Print(link, "can be equipped to empty slot")
				end
				if AutoTurnInCharacterDB.autoequip then
					self.autoEquipList[name] = firstSlot
				end
				return points
			end
			
			local eqLevel = self:ItemLevel(invLink)
			local invPoints = self:itemPoints(invLink)
			local equipInvType = select(9, GetItemInfo(invLink))
			-- If reward is a ring, trinket or one-handed weapon all slots must be checked in order to swap one with a lesser item-level
			if (invType == equipInvType and #slot > 1) then
				local secondSlot = GetInventorySlotInfo(slot[2])
				invLink = GetInventoryItemLink("player", secondSlot)
				if invLink == nil then
					if (AutoTurnInCharacterDB.debug) then
						self:Print(link, "can be equipped to empty slot")
					end
					if AutoTurnInCharacterDB.autoequip then
						self.autoEquipList[name] = secondSlot
					end
					return points
				else
					local eq2Level = self:ItemLevel(invLink)
					local inv2Points = self:itemPoints(invLink)
					-- 2nd slot item is worse then 1st slot
					if inv2Points < invPoints then
						firstSlot = secondSlot
						eqLevel = eq2Level
						invPoints = inv2Points
					end
				end
			end

			-- comparing lowest equipped item level with reward's item level and points
			if (points >= invPoints and lootLevel >= eqLevel) then
				if (AutoTurnInCharacterDB.debug) then
					self:Print("New", link, "is more suitable than", invLink, "- can be equipped")
				end
				if AutoTurnInCharacterDB.autoequip then
					self.autoEquipList[name] = firstSlot
				end
				return points
			else 
				if (AutoTurnInCharacterDB.debug) then
					self:Print("Old", invLink, "is more suitable than", link, "- skip")
				end
				return nil
			end
		end

		return points
	end
	return nil
end

function AutoTurnIn:itemPoints(link)
	local points = 0
	if (link == nil) then 
		return points
	end
	
	local name, _, _, lootLevel, _, class, subclass, _, invType = GetItemInfo(link)
	if (invType == "") then
		return points
	end
	
	local info = {}
	tinsert(info, "Debug: " .. link)
	-- TYPE: item is suitable if there are no type specified at all or item type is chosen
	local OkByType = false
	if class == C.WEAPONLABEL then
		OkByType = (not next(AutoTurnInCharacterDB.weapon)) or (AutoTurnInCharacterDB.weapon[subclass] or
					self:IsRangedAndRequired(subclass))
	else
		OkByType = ( not next(AutoTurnInCharacterDB.armor) ) or ( AutoTurnInCharacterDB.armor[subclass] or
					AutoTurnInCharacterDB.armor[invType] or self:IsJewelryAndRequired(invType) )
	end
	tinsert(info, "type: " .. subclass .. ((not not OkByType) and "=>OK" or "=>FAIL"))
	if OkByType then
		points = 1000
		--STAT+SECONDARY: Same here: if no stat specified or item stat is chosen then item is wanted
		local OkByStat = not next(AutoTurnInCharacterDB.stat) 			-- true if table is empty
		local OkBySecondary = not next(AutoTurnInCharacterDB.secondary) -- true if table is empty
		if (not (OkByStat and OkBySecondaryStat)) then
			wipe(self.stattable)
			GetItemStats(link, self.stattable)
			for stat, value in pairs(self.stattable) do
				if (AutoTurnInCharacterDB.stat[stat]) then
					points = points + (5 * value)
					tinsert(info, "stat: " .. _G[stat] .. "=>OK")
				end
				if (AutoTurnInCharacterDB.secondary[stat]) then
					points = points + value
					tinsert(info, _G[stat])
				end
			end
		end
	end
	
	tinsert(info, "total " .. points)
	if (AutoTurnInCharacterDB.debug) then
		self:Print(table.concat(info, ", "))
	end
	
	return points
end

-- I was forced to make decision on offhand, cloak and shields separate from armor but I can't pick up my mind about the reason...
function AutoTurnIn:QUEST_COMPLETE()
	-- blasted Lands citadel wonderful NPC. They do not trigger any events except quest_complete.
	if not self:AllowedToHandle() then
		return
	end

	--/script faction = (GameTooltip:NumLines() > 2 and not UnitIsPlayer(select(2,GameTooltip:GetUnit()))) and
    -- getglobal("GameTooltipTextLeft"..GameTooltip:NumLines()):GetText() DEFAULT_CHAT_FRAME:AddMessage(faction or "NIL")
    if self:isAppropriate() then
		local questname = GetTitleText()
		local quest = L.quests[questname]
		local numOptions = GetNumQuestChoices() 

		if numOptions > 1 then
			local function getItemId(typeStr)
				local link = GetQuestItemLink(typeStr, 1) --first item is enough
				return link and link:match("%b::"):gsub(":", "") or self.ERRORVALUE
			end

			local itemID = getItemId("choice")
			if (not itemID) then
				self:Print("Can't read reward link from server. Close NPC dialogue and open it again.");
				return
			end
			-- Tournament quest found
			if (itemID == "46114" or itemID == "45724") then 
				self:TurnInQuest(AutoTurnInCharacterDB.tournament)
				return
			end

-- Code for ignoring Relics if turned on.
			if (AutoTurnInCharacterDB.relictoggle) then
				local relicFound = false
				local numQuestRewards = GetNumQuestRewards()
				if (AutoTurnInCharacterDB.debug) then
					self:Print("Debug: numQuestRewards:",numQuestRewards,".")
					self:Print("Debug: numOptions:",numOptions,".")
				end
				for i=1, numOptions do
					local itemLinks = GetQuestItemLink("choice", i)
					if (AutoTurnInCharacterDB.debug) then
						self:Print("Debug: Listing choice found:",itemLinks,".")
					end
					local itemReward = GetQuestItemLink("reward", i)
					if (itemReward) then
						if (AutoTurnInCharacterDB.debug) then
							self:Print("Debug: Listing reward found:",itemReward,".")
						end
					end
					local _, _, Color, Ltype, itemID, Enchant, Gem1, Gem2, Gem3, Gem4, Suffix, Unique, LinkLvl, Name = string.find(itemLinks,   "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*):?(%-?%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
					if itemID then
						local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemID)
						if ((itemType == "Gem") and (itemSubType =="Artifact Relic")) then
							relicFound = true
							if (AutoTurnInCharacterDB.debug) then
								self:Print("Debug: Gem: Artificat found:",itemLinks,".")
							end
							return
						end
					end
				end
			end
			if (relicFounnd) then
				if (AutoTurnInCharacterDB.debug) then
					self:Print("Debug: Atleaast 1 relic found.. aborting.")
				end
				return
			end

			if (AutoTurnInCharacterDB.artifactpowertoggle) then
				local ArtifactPowerFound = false
--				code not ready
				if (ArtifactPowerFound) then
					if (AutoTurnInCharacterDB.debug) then
						self:Print("Debug: Pre-emptive debug.. aborting.")
					end
					return
				end
			end
			if (AutoTurnInCharacterDB.lootreward > 1) then -- Auto Loot enabled!
				self.forceGreed = false
				if (AutoTurnInCharacterDB.lootreward == 3) then -- 3 == Need
					self.forceGreed = (not self:Need() ) and AutoTurnInCharacterDB.greedifnothingfound
				end
				if (AutoTurnInCharacterDB.lootreward == 2 or self.forceGreed) then -- 2 == Greed
					self:Greed()
				end
			end
		else
			self:TurnInQuest(1) -- for autoequip to work index must be greater that 0. That's required by Blizzard API
		end
    end
end


function AutoTurnIn:IsIgnoredNPC()
	local guid = AutoTurnIn:GetNPCGUID()
	return (AutoTurnInCharacterDB.IGNORED_NPC and AutoTurnInCharacterDB.IGNORED_NPC[guid]) 
		or ptable.defaults.IGNORED_NPC[guid]
end
function AutoTurnIn:IsDefaultIgnoredNPC()
	return ptable.defaults.IGNORED_NPC[AutoTurnIn:GetNPCGUID()]
end

function AutoTurnIn:ShowIgnoreButton(frame)
	local GlobalFrame = nil
	if (frame == "quest") then GlobalFrame = QuestFrame elseif (frame == "gossip") then GlobalFrame = GossipFrame end
	if GlobalFrame == nil then return end
	
	--reusing existing button
	if (not self.IgnoreButton[frame]) then self.IgnoreButton[frame] = CreateFrame("CheckButton", "NPCIgnoreButton" .. frame, GlobalFrame, dragonflight and "UICheckButtonTemplate" or "OptionsCheckButtonTemplate") end
	
	local IgnoreButton = self.IgnoreButton[frame]
	IgnoreButton:SetPoint("TOPLEFT", 57, 21)
	IgnoreButton:SetChecked(not not AutoTurnIn:IsIgnoredNPC())
	IgnoreButton:SetScript("OnClick", function(self)
		local guid = AutoTurnIn:GetNPCGUID()
		AutoTurnInCharacterDB.IGNORED_NPC[guid] = self:GetChecked() and questNPCName or nil
	end)
	
	if (AutoTurnIn:IsDefaultIgnoredNPC()) then
		IgnoreButton:Disable()
		GameTooltip:SetOwner(IgnoreButton, "ANCHOR_RIGHT");
		GameTooltip:SetText(L["cantstopignore"]);
		GameTooltip:Show()
	else 
		IgnoreButton:Enable()
	end
	--button text on global form
	questNPCName = UnitName("target")
	_G[IgnoreButton:GetName().."Text"]:SetText((GetLocale()=="zhCN" and "自动交接: " or "AutoTurnIn: ") .. L["ignorenpc"])
end

function AutoTurnIn:IsWantedQuest(questId)
       return not not ptable.defaults.WANTED_QUESTS[questId]
end

-- gossip and quest interaction goes through a sequence of windows: gossip [shows a list of available quests] - quest[describes specified quest]
-- sometimes some parts of this chain is skipped. For example, priest in Honor Hold show quest window directly. This is a trick to handle 'toggle key'
hooksecurefunc(QuestFrame, "Hide", function()
	AutoTurnIn.allowed = nil 
	GameTooltip:Hide()
end)
--GossipFrame sets allowed to true, after that 'toggle key' doesn't work
hooksecurefunc(GossipFrame, "Hide", function()
	AutoTurnIn.allowed = nil 
	GameTooltip:Hide()
end)
--GossipFrame should show ignore button too
hooksecurefunc(QuestFrame, "Show", function() AutoTurnIn:ShowIgnoreButton("quest") end)
hooksecurefunc(GossipFrame, "Show", function() AutoTurnIn:ShowIgnoreButton("gossip") end)



-- HELPERS
function AutoTurnIn:dump(o)
	DevTools_Dump(o, "value");
	-- self:Print(self:_dump(o))
end

function AutoTurnIn:_dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. self:_dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
-- /run local a=UnitGUID("npc"); for word in a:gmatch("Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-") do print(word) end
-- https://www.townlong-yak.com/
