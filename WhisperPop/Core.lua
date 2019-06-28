------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2015/9/06
------------------------------------------------------------

local pairs = pairs
local ipairs = ipairs
local strfind = strfind
local type = type
local tinsert = tinsert
local strsub = strsub
local date = date
local tonumber = tonumber
local select = select
local PlaySoundFile = PlaySoundFile
local wipe = wipe
local tremove = tremove
local SendWho = SendWho
local min = min
local max = max
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local BNGetNumFriends = BNGetNumFriends
local BNGetFriendInfo = BNGetFriendInfo
local BNGetFriendInfoByID = BNGetFriendInfoByID
local GMChatFrame_IsGM = GMChatFrame_IsGM
local ChatFrame_GetMessageEventFilters = ChatFrame_GetMessageEventFilters
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
local ChatEdit_ActivateChat = ChatEdit_ActivateChat
local ChatEdit_ParseText = ChatEdit_ParseText
local InviteUnit = InviteUnit
local FriendsFrame_ShowDropdown = FriendsFrame_ShowDropdown
local FriendsFrame_ShowBNDropdown = FriendsFrame_ShowBNDropdown
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local UNKNOWN = UNKNOWN

local addon = LibAddonManager:CreateAddon(...)
local L = addon.L

addon:RegisterDB("WhisperPopDB")
addon:RegisterSlashCmd("whisperpop", "wp") -- Type /whisperpop or /wp to toggle the frame

addon.ICON_FILE = "Interface\\Icons\\INV_Letter_05"
addon.SOUND_FILE = "Interface\\AddOns\\WhisperPop\\Sounds\\Notify.ogg"
addon.BACKGROUND = "Interface\\DialogFrame\\UI-DialogBox-Background"
addon.BORDER = "Interface\\Tooltips\\UI-Tooltip-Border"

addon.MAX_MESSAGES = 500 -- Maximum messages stored for each conversation

-- Message are saved in format of: [1/0][hh:mm:ss][contents]
-- The first char is 1 if this message is inform, 0 otherwise
function addon:EncodeMessage(text, inform)
	local timeStamp = strsub(date(), 10, 17)
	return (inform and "1" or "0")..timeStamp..(text or ""), timeStamp
end

function addon:DecodeMessage(line)
	if type(line) ~= "string" then
		return
	end

	local inform
	if strsub(line, 1, 1) == "1" then
		inform = 1
	end

	local timeStamp = strsub(line, 2, 9)
	local text = strsub(line, 10)
	return text, inform, timeStamp
end

-- Splits name-realm
function addon:ParseNameRealm(text)
	if type(text) == "string" then
		local _, _, name, realm = strfind(text, "(.+)%-(.+)")
		return name or text, realm
	end
end

function addon:GetDisplayName(text, forceRealm)
	if self:IsBattleTag(text) then
		local id, name = self:GetBNInfoFromTag(text)
		return name or UNKNOWN
	end

	if forceRealm then
		return text
	end

	local name, realm = self:ParseNameRealm(text)
	if self.db.showRealm then
		if foreignOnly and realm == self.realm then
			return name
		else
			return text
		end
	else
		return name
	end
end

function addon:GetBNInfoFromTag(tag)
	if type(tag) ~= "string" then
		return
	end

	local count = BNGetNumFriends()
	local i
	for i = 1, count do
		local id, name, battleTag, _, _, _, _, online = BNGetFriendInfo(i)
		if battleTag == tag then
			return id, name, online
		end
	end
end

function addon:IsBattleTag(name)
	if type(name) == "string" then
		local _, _, prefix, surfix = strfind(name, "(.+)#(%d+)$")
		return prefix, surfix
	end
end

function addon:GetNewMessage()
	local i
	for i = 1, #self.db.history do
		local data = self.db.history[i]
		if data.new then
			return addon:GetDisplayName(data.name), data.class, addon:DecodeMessage(data.messages[1])
		end
	end
end

function addon:GetNewNames()
	local newNames = {}
	local i
	for i = 1, #self.db.history do
		local data = self.db.history[i]
		if data.new then
			tinsert(newNames, addon:GetDisplayName(data.name))
		end
	end
	return newNames
end

function addon:AddTooltipText(tooltip)
	local newNames = self:GetNewNames()
	if newNames[1] then
		tooltip:AddLine(L["new messages from"], 1, 1, 1, true)
		local i
		for i = 1, #newNames do
			tooltip:AddLine(newNames[i], 0, 1, 0, true)
		end
	else
		tooltip:AddLine(L["no new messages"], 1, 1, 1, true)
	end
end

function addon:HandleAction(name, action)
	if type(name) ~= "string" then
		return
	end

	local bnId, bnName, bnOnline
	if addon:IsBattleTag(name) then
		bnId, bnName, bnOnline = self:GetBNInfoFromTag(name)
		if not bnId then
			return
		end
	end

	if action == "MENU" then
		if bnId then
			FriendsFrame_ShowBNDropdown(bnName, bnOnline, nil, nil, nil, 1, bnId)
		else
			FriendsFrame_ShowDropdown(name, 1)
		end

	elseif action == "WHO" then
		SendWho("n-"..(bnName or name))

	elseif action == "INVITE" then
		if bnId then
			FriendsFrame_BattlenetInvite(nil, bnId)
		else
			InviteUnit(name)
		end

	elseif action == "WHISPER" then
        if bnName then
            ChatFrame_SendBNetTell(bnName)
        else
            local editbox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(editbox)
            editbox:SetText("/w "..(bnName or name).." ")
            ChatEdit_ParseText(editbox, 0)
        end
	end
end

function addon:PlaySound163()
	PlaySoundFile(self.SOUND_FILE, "Master") -- Sound alert
end

addon.DB_DEFAULTS = {
	time = 1,
	sound = 1,
	save = 1,
	notifyButton = 1,
	ignoreTags = 1,
	applyFilters = 1,
	receiveOnly = 0,
	showRealm = 0,
	foreignOnly = 1,
	buttonScale = { min = 50, max = 200, step = 5, default = 100 },
	listScale = { min = 50, max = 200, step = 5, default = 100 },
	listWidth = { min = 100, max = 400, step = 5, default = 200 },
	listHeight = { min = 100, max = 640, step = 20, default = 320 }
}

function addon:OnInitialize(db, firstTime)
	if firstTime or not addon:VerifyDBVersion(4.12, db) then
		db.version = 4.12
		local k, v
		for k, v in pairs(self.DB_DEFAULTS) do
			if v == 1 then
				db[k] = 1
			elseif type(v) == "table" then
				--print(k, db[k])
				if type(db[k]) ~= "number"  or db[k] < v.min or db[k] > v.max then
					db[k] = v.default
				end
			end
		end
	end

	if type(db.history) ~= "table" then
		db.history = {}
	end

	self:BroadcastEvent("OnInitialize", db)

	local k
	for k in pairs(self.DB_DEFAULTS) do
		self:BroadcastOptionEvent(k, db[k])
	end

	self:RegisterEvent("PLAYER_LOGOUT")
	self:RegisterEvent("CHAT_MSG_WHISPER")
	self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER")
	self:RegisterEvent("CHAT_MSG_BN_WHISPER_INFORM")

	self:BroadcastEvent("OnListUpdate")
end

function addon:PLAYER_LOGOUT()
	if not self.db.save then
		wipe(self.db.history)
	end
end

function addon:Clear()
	local history = self.db.history
	local i
	for i = #history, 1, -1 do
		if not history[i].protected then
			tremove(history, i)
		end
	end

	self:BroadcastEvent("OnListUpdate")
	self:BroadcastEvent("OnClearMessages")
end

function addon:FindPlayerData(name)
	local index, data
	for index, data in ipairs(self.db.history) do
		if data.name == name then
			return index, data
		end
	end
end

function addon:Delete(name)
	local index, data = self:FindPlayerData(name)
	if index and not data.protected then
		tremove(self.db.history, index)
		self:BroadcastEvent("OnListUpdate")
	end
end

function addon:ProcessChatMsg(name, class, text, inform, bnid)
	if type(text) ~= "string" or type(name) ~= "string" then
		return
	end

	if self.db.ignoreTags then
		local tag = strsub(text, 1, 1)
		if tag == "<" or tag == "[" then
			return
		end
	end

	if self:IsIgnoredMessage(text) then
		return -- Ignored message
	end

	-- Names must be in the "name-realm" format except for BN friends
	if class == "BN" then
		name = select(3, BNGetFriendInfoByID(bnid or 0)) -- Seemingly better than my original solution, credits to Warbaby
		if not name then
			return
		end
	elseif class ~= "GM" then
		local _, realm = self:ParseNameRealm(name)
		if not realm then
			name = name.."-"..self.realm
		end
	end

	-- Add data into message history
	local index, data = self:FindPlayerData(name)
	if index then
		if index > 1 then
			tremove(self.db.history, index)
			tinsert(self.db.history, 1, data)
		end
	else
		data = { name = name, class = class }
		tinsert(self.db.history, 1, data)
	end

	if type(data.messages) ~= "table" then
		data.messages = {}
	end

	if inform then
		data.new = nil
	else
		data.new = 1
		data.received = 1
	end

	local msg, timeStamp = self:EncodeMessage(text, inform)
	tinsert(data.messages, msg)

	while #data.messages > self.MAX_MESSAGES do
		tremove(data.messages, 1)
	end

	self:BroadcastEvent("OnListUpdate")

	-- It's a new message
	if not inform and self.db.sound then
		self:PlaySound163()
	end

	self:BroadcastEvent("OnNewMessage", name, class, text, inform, timeStamp)
end

function addon:CHAT_MSG_WHISPER(...)
	local text, name, _, _, _, flag, _, _, _, _, _, guid, _, _, _, hide = ...
	if hide then
		return
	end

	if flag == "GM" or flag == "DEV" then
		flag = "GM"
	else
		-- Spam filters only applied on incoming non-GM whispers, other cases make no sense
		if self.db.applyFilters then
			local filtersList = ChatFrame_GetMessageEventFilters("CHAT_MSG_WHISPER")
			if filtersList then
				local _, func
				for _, func in ipairs(filtersList) do
					if type(func) == "function" and func(DEFAULT_CHAT_FRAME, "CHAT_MSG_WHISPER", ...) then
						return
					end
				end
			end
		end

		flag = select(2, GetPlayerInfoByGUID(guid or ""))
	end

	self:ProcessChatMsg(name, flag, text)
end

function addon:CHAT_MSG_WHISPER_INFORM(...)
	local text, name, _, _, _, flag, _, _, _, _, _, guid = ...
	if flag == "GM" or flag == "DEV" or (GMChatFrame_IsGM and GMChatFrame_IsGM(name)) then
		flag = "GM"
    else
		-- 163ui BadBoy_levels and DBM need filter these
		if self.db.applyFilters then
			local filtersList = ChatFrame_GetMessageEventFilters("CHAT_MSG_WHISPER_INFORM")
			if filtersList then
				local _, func
				for _, func in ipairs(filtersList) do
					if type(func) == "function" and func(DEFAULT_CHAT_FRAME, "CHAT_MSG_WHISPER_INFORM", ...) then
						return
					end
				end
			end
		end

		flag = select(2, GetPlayerInfoByGUID(guid or ""))
	end

	self:ProcessChatMsg(name, flag, text, 1)
end

function addon:CHAT_MSG_BN_WHISPER(...)
	local text, name, _, _, _, _, _, _, _, _, _, _, bnid = ...
	self:ProcessChatMsg(name, "BN", text, nil, bnid)
end

function addon:CHAT_MSG_BN_WHISPER_INFORM(...)
	local text, name, _, _, _, _, _, _, _, _, _, _, bnid = ...
	self:ProcessChatMsg(name, "BN", text, 1, bnid)
end

------------------------------------------------------
-- Depreciated functions
------------------------------------------------------
-- It is not recommended to use WhisperPop's IGNORED_MESSAGES array to filter messages anymore,
-- I've added codes in v4 to support third-party filters so it's better let other professional addons do
-- the message-filtering job and we simply take their filter results.
------------------------------------------------------

addon.IGNORED_MESSAGES = {} -- Do not use anymore

-- Add additional ignoring patterns into addon.IGNORED_MESSAGES to filter messages in particular, not recommended since v4.0
function addon:AddIgnore(pattern)
	if type(pattern) ~= "string" then
		return
	end

	local index, str
	for index, str in ipairs(self.IGNORED_MESSAGES) do
		if str == pattern then
			return
		end
	end

	tinsert(self.IGNORED_MESSAGES, pattern)
end

function addon:IsIgnoredMessage(text)
	if type(text) ~= "string" then
		return
	end

	local pattern
	for _, pattern in ipairs(self.IGNORED_MESSAGES) do
		if strfind(text, pattern) then
			return pattern
		end
	end
end
