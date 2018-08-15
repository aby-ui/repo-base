
local QuestAnnounce = LibStub("AceAddon-3.0"):NewAddon("QuestAnnounce", "AceEvent-3.0", "AceConsole-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("QuestAnnounce")

--[[ The defaults a user without a profile will get. ]]--
local defaults = {
	profile={
		settings = {
			enable = true,
			every = 2,
			sound = false,
			debug = false
		},
		announceTo = {
			chatFrame = true,
			raidWarningFrame = false,
			uiErrorsFrame = false,
		},
		announceIn = {
			say = false,
			party = true,
			guild = false,
			officer = false,
			whisper = false,
			whisperWho = nil
		}
	}
}

--[[ QuestAnnounce Initialize ]]--
function QuestAnnounce:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("QuestAnnounceDB", defaults, true)
	
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileReset")
	self.db.RegisterCallback(self, "OnNewProfile", "OnNewProfile")
	
	self:SetupOptions()
end

function QuestAnnounce:OnEnable()
	--[[ We're looking at the UI_INFO_MESSAGE for quest messages ]]--
	self:RegisterEvent("UI_INFO_MESSAGE")
    self:RegisterEvent("CHAT_MSG_SYSTEM")
    self:RegisterEvent("QUEST_ACCEPTED")
    self:RegisterEvent("GROUP_ROSTER_UPDATE")

    QuestAnnounce:RefreshCompletedQuests(false)
    self:RegisterEvent("QUEST_LOG_UPDATE")

	self:SendDebugMsg("Addon Enabled :: "..tostring(QuestAnnounce.db.profile.settings.enable))
end

local pattern = GetLocale()=="zhCN" and "(.*)：%s*([-%d]+)%s*/%s*([-%d]+)%s*$" or "(.*):%s*([-%d]+)%s*/%s*([-%d]+)%s*$"
--[[ Event handlers ]]--
function QuestAnnounce:UI_INFO_MESSAGE(event, id, msg)
	local settings = self.db.profile.settings
	
	if (msg ~= nil) then
		if (settings.enable) then
			local questText = gsub(msg, pattern, "%1", 1)
			
			if (questText ~= msg) then
                QuestAnnounce:SendDebugMsg("Quest Text: "..questText)
				local ii, jj, strItemName, iNumItems, iNumNeeded = string.find(msg, pattern)
                iNumNeeded, iNumItems = tonumber(iNumNeeded), tonumber(iNumItems)
				local stillNeeded = iNumNeeded - iNumItems
                
				QuestAnnounce:SendDebugMsg("Item Name: "..strItemName.." :: Num Items: "..iNumItems.." :: Num Needed: "..iNumNeeded.." :: Still Need: "..stillNeeded)

				if(stillNeeded == 0 and settings.every == 0) then
					QuestAnnounce:SendMsg(L["Completed: "]..msg)
				elseif(QuestAnnounce.db.profile.settings.every > 0) then
                    --超过10个的则按比例来, 但如果设置成1，则每一个都通知
                    local every = settings.every
                    if iNumNeeded > 10 and every ~= 1 then every = math.ceil(iNumNeeded / 10 * (every - 1)) end
					every = math.fmod(iNumItems, every)
					QuestAnnounce:SendDebugMsg("Every fMod: "..every)
				
					if(every == 0 and stillNeeded > 0) then
						QuestAnnounce:SendMsg(L["Progress: "]..msg)
					elseif(stillNeeded == 0) then
						QuestAnnounce:SendMsg(L["Completed: "]..msg)
					end
                end
			end
		end
	end
end

function QuestAnnounce:OnProfileChanged(event, db)
 	self.db.profile = db.profile
end

function QuestAnnounce:OnProfileReset(event, db)
	for k, v in pairs(defaults) do
		db.profile[k] = v
	end
	self.db.profile = db.profile
end

function QuestAnnounce:OnNewProfile(event, db)
	for k, v in pairs(defaults) do
		db.profile[k] = v
	end
end

--[[ Sends a debugging message if debug is enabled and we have a message to send ]]--
function QuestAnnounce:SendDebugMsg(msg)
	if(msg ~= nil and self.db.profile.settings.debug) then
		QuestAnnounce:Print("DEBUG :: "..msg)
	end
end

local adviseSend = 0
--[[ Sends a chat message to the selected chat channels and frames where applicable,
	if we have a message to send; will also send a debugging message if debug is enabled ]]--
function QuestAnnounce:SendMsg(msg, abyui)
	local announceIn = self.db.profile.announceIn
	local announceTo = self.db.profile.announceTo

	if (msg ~= nil and self.db.profile.settings.enable) then
        if GetLocale():sub(1,2)=="zh" and (adviseSend <= 0 or abyui) then msg = L["【爱不易】"]..msg end
        local send_one = false

		if(announceTo.chatFrame) then
			if(announceIn.say) then
				SendChatMessage(msg, "SAY") send_one = true
				QuestAnnounce:SendDebugMsg("QuestAnnounce:SendMsg(SAY) :: "..msg)
			end
		
			--[[ GetNumGroupMembers is group-wide; GetNumSubgroupMembers is confined to your group of 5 ]]--
			--[[ Ref: http://www.wowpedia.org/API_GetNumSubgroupMembers or http://www.wowpedia.org/API_GetNumGroupMembers ]]--	
			if(announceIn.party) then
				if(IsInGroup() and GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) > 0) then
					SendChatMessage(msg, "PARTY") send_one = true
				end
				
				QuestAnnounce:SendDebugMsg("QuestAnnounce:SendMsg(PARTY) :: "..msg)
			end				
		
			if(announceIn.instance) then
				if (IsInInstance() and GetNumSubgroupMembers(LE_PARTY_CATEGORY_INSTANCE) > 0) then
					SendChatMessage(msg, "INSTANCE_CHAT") send_one = true
				end
				
				QuestAnnounce:SendDebugMsg("QuestAnnounce:SendMsg(INSTANCE) :: "..msg)
			end				
		
			if(announceIn.guild) then
				if(IsInGuild()) then
					SendChatMessage(msg, "GUILD") send_one = true
				end
				
				QuestAnnounce:SendDebugMsg("QuestAnnounce:SendMsg(GUILD) :: "..msg)
			end
			
			if(announceIn.officer) then
				if(IsInGuild()) then
					SendChatMessage(msg, "OFFICER") send_one = true
				end
				
				QuestAnnounce:SendDebugMsg("QuestAnnounce:SendMsg(OFFICER) :: "..msg)
			end			
				
			if(announceIn.whisper) then
				local who = announceIn.whisperWho
				if(who ~= nil and who ~= "") then
					SendChatMessage(msg, "WHISPER", nil, who) send_one = true
					QuestAnnounce:SendDebugMsg("QuestAnnounce:SendMsg(WHISPER) :: "..who.."-"..msg)
				end
			end
		end
		
		if(announceTo.raidWarningFrame) then
			RaidNotice_AddMessage(RaidWarningFrame, msg, ChatTypeInfo["RAID_WARNING"]) send_one = true
		end
		
		if(announceTo.uiErrorsFrame) then
			UIErrorsFrame:AddMessage(msg, 1.0, 1.0, 0.0, 7) send_one = true
		end

        if send_one then adviseSend = adviseSend + 1 end

		if(self.db.profile.settings.sound) then
			PlaySound(PlaySoundKitID and "RAID_WARNING" or 8959)
		end
	end
	
	QuestAnnounce:SendDebugMsg("QuestAnnounce:SendMsg - "..msg)
end

function QuestAnnounce:RefreshCompletedQuests(announce)
    self.completed = self.completed or {}
    for i=1, GetNumQuestLogEntries(), 1 do
        local title, _, _, _, _, isComplete = GetQuestLogTitle(i);
        if title and isComplete then
            if not self.completed[title] and announce then
                QuestAnnounce:SendMsg(L["Quest Done: "] .. title, true)
            end
            self.completed[title] = true
        end
    end
end

function QuestAnnounce:QUEST_LOG_UPDATE()
    QuestAnnounce:RefreshCompletedQuests(true)
end

function QuestAnnounce:QUEST_ACCEPTED(event, questIndex)
    local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle(questIndex)
    if title and not isComplete and not isTask then
        QuestAnnounce:SendMsg(L["Accepted: "] .. title, true)
    end
end

local complete_pattern = escape_pattern(ERR_QUEST_COMPLETE_S):gsub("%%%%s", "(.-)") --ERR_QUEST_COMPLETE_S = "%s完成。"
function QuestAnnounce:CHAT_MSG_SYSTEM(event, msg)
    -- 世界任务用这个方式
    local questText = gsub(msg, complete_pattern, "%1", 1)
    if (questText ~= msg) then
        QuestAnnounce:SendMsg(L["Quest Done: "] .. questText, true)
    end
end

function QuestAnnounce:GROUP_ROSTER_UPDATE()
    adviseSend = 0
end
