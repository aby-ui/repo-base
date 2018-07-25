-----------------------------------------------------------------------
-- ChatFilter
-----------------------------------------------------------------------
CF_LevelTable = {}
CF_IgnoreTable = {}

local _, cf = ...
local Config = cf.Config
local L = cf.L
local _G = _G

local ChatFilter, FriendsFrame = CreateFrame("Frame"), FriendsFrame
local Loading, prevLineId, prevMsg, queried, queryTime, lastQueryTime, Clock, SendWhoMessage
local craftItemID, craftQuantity, craftCount, craftFinished, craftFinishing, prevCraft, prevCraftMsg, prevCraftTime
local CacheTable, ShieldTable, FriendTable, ServerTable = {}, {}, {}, {}
local achievements, alreadySent, spellList, totalCreated, resetTime, craftList = {}, {}, {}, {}, {}, {}
local spamCategories, specialFilters = {[95] = true, [155] = true, [168] = true, [14807] = true, [15165] = true}, {[456] = true, [1400] = true, [1402] = true, [2186] = true, [2187] = true, [2903] = true, [2904] = true, [3004] = true, [3005] = true, [3117] = true, [3259] = true, [3316] = true, [3808] = true, [3809] = true, [3810] = true, [3817] = true, [3818] = true, [3819] = true, [4078] = true, [4079] = true, [4080] = true, [4156] = true, [4576] = true, [4626] = true, [5313] = true, [6954] = true, [7485] = true, [7486] = true, [7487] = true, [8089] = true, [8238] = true, [8246] = true, [8248] = true, [8249] = true, [8260] = true, [8306] = true, [8307] = true, [8398] = true, [8399] = true, [8400] = true, [8401] = true, [8430] = true, [8431] = true, [8432] = true, [8433] = true, [8434] = true, [8435] = true, [8436] = true, [8437] = true, [8438] = true, [8439] = true}

local function deformat(text)
	text = gsub(text, "%.", "%%.")
	text = gsub(text, "%%%d$s", "(.+)")
	text = gsub(text, "%%s", "(.+)")
	text = gsub(text, "%%d", "(%%d+)")
	text = "^"..text.."$"
	return text
end

local createmsg = deformat(LOOT_ITEM_CREATED_SELF)
local createmultimsg = deformat(LOOT_ITEM_CREATED_SELF_MULTIPLE)
local pushedmultimsg = deformat(LOOT_ITEM_PUSHED_SELF_MULTIPLE)
local learnpassivemsg = deformat(ERR_LEARN_PASSIVE_S)
local learnspellmsg = deformat(ERR_LEARN_SPELL_S)
local learnabilitymsg = deformat(ERR_LEARN_ABILITY_S)
local unlearnspellmsg = deformat(ERR_SPELL_UNLEARNED_S)
local petlearnspellmsg = deformat(ERR_PET_LEARN_SPELL_S)
local petlearnabilitymsg = deformat(ERR_PET_LEARN_ABILITY_S)
local petunlearnspellmsg = deformat(ERR_PET_SPELL_UNLEARNED_S)
local auctionstartedmsg = deformat(ERR_AUCTION_STARTED)
local auctionremovedmsg = deformat(ERR_AUCTION_REMOVED)
local duelwinmsg = deformat(DUEL_WINNER_KNOCKOUT)
local duellosemsg = deformat(DUEL_WINNER_RETREAT)
local friendaddedmsg = deformat(ERR_FRIEND_ADDED_S)
local friendalreadymsg = deformat(ERR_FRIEND_ALREADY_S)
local friendnotfoundmsg = deformat(ERR_FRIEND_NOT_FOUND)
local friendlistfullmsg = deformat(ERR_FRIEND_LIST_FULL)
local ignorelistfullmsg = deformat(ERR_IGNORE_FULL)
local lootmsg = {
	deformat(LOOT_ITEM_SELF),
	deformat(LOOT_ITEM_SELF_MULTIPLE),
	deformat(LOOT_ITEM_PUSHED_SELF),
	deformat(LOOT_ITEM_PUSHED_SELF_MULTIPLE),
	deformat(LOOT_ITEM_BONUS_ROLL_SELF),
	deformat(LOOT_ITEM_BONUS_ROLL_SELF_MULTIPLE),
	deformat(YOU_LOOT_MONEY),
}
local drunkmsg = {
	deformat(DRUNK_MESSAGE_ITEM_OTHER1),
	deformat(DRUNK_MESSAGE_ITEM_OTHER2),
	deformat(DRUNK_MESSAGE_ITEM_OTHER3),
	deformat(DRUNK_MESSAGE_ITEM_OTHER4),
	deformat(DRUNK_MESSAGE_OTHER1),
	deformat(DRUNK_MESSAGE_OTHER2),
	deformat(DRUNK_MESSAGE_OTHER3),
	deformat(DRUNK_MESSAGE_OTHER4),
}

local function SendMessage(event, msg, r, g, b)
	local info = ChatTypeInfo[strsub(event, 10)]
	for i = 1, NUM_CHAT_WINDOWS do
		local ChatFrames = _G["ChatFrame"..i]
		if (ChatFrames and ChatFrames:IsEventRegistered(event)) then
			ChatFrames:AddMessage(msg, info.r, info.g, info.b)
		end
	end
end

local function SendAchievement(event, achievementID, players)
	if (not players) then return end
	for k in pairs(alreadySent) do alreadySent[k] = nil end
	for i = getn(players), 1, -1 do
		if (alreadySent[players[i].name]) then
			tremove(players, i)
		else
			alreadySent[players[i].name] = true
		end
	end
	if (getn(players) > 1) then
		sort(players, function(a, b) return a.name < b.name end)
	end
	for i = 1, getn(players) do
		local class, color, r, g, b
		local playerName = players[i].name
		local playerGuid = players[i].guid
		local org_playerName = playerName
		if (playerGuid and playerGuid:find("Player")) then
			class = select(2, GetPlayerInfoByGUID(players[i].guid))
			color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		end
		if (not color) then
			local info = ChatTypeInfo[strsub(event, 10)]
			r, g, b = info.r, info.g, info.b
		else
			r, g, b = color.r, color.g, color.b
		end
		if (Config.AddLevelBeforeName) then
			local fullName = playerName
			if (not strfind(fullName, "-")) then fullName = fullName.."-"..GetRealmName() end
			if (CF_LevelTable[fullName] and CF_LevelTable[fullName].Level) then
				playerName = CF_LevelTable[fullName].Level..":"..playerName
			end
		end
		players[i] = format("|cff%02x%02x%02x|Hplayer:%s|h%s|h|r", r*255, g*255, b*255, org_playerName, playerName)
	end
	SendMessage(event, format(L["Achievement"], table.concat(players, L["Space"]), GetAchievementLink(achievementID)))
end

local function achievementReady(id, achievement)
	if (achievement.area and achievement.guild) then
		local playerGuild = GetGuildInfo("player")
		for i = getn(achievement.area), 1, -1 do
			local player = achievement.area[i].name
			if (UnitExists(player) and playerGuild and playerGuild == GetGuildInfo(player)) then
				tinsert(achievement.guild, tremove(achievement.area, i))
			end
		end
	end
	if (achievement.area and getn(achievement.area) > 0) then
		SendAchievement("CHAT_MSG_ACHIEVEMENT", id, achievement.area)
	end
	if (achievement.guild and getn(achievement.guild) > 0) then
		SendAchievement("CHAT_MSG_GUILD_ACHIEVEMENT", id, achievement.guild)
	end
end

local function talentspecReady(attribute, spells)
	if (not spells) then return end
	for k in pairs(alreadySent) do alreadySent[k] = nil end
	for i = getn(spells), 1, -1 do
		if (alreadySent[spells[i]]) then
			tremove(spells, i)
		else
			alreadySent[spells[i]] = true
		end
	end
	if (getn(spells) > 1) then
		sort(spells, function(a, b) return a < b end)
	end
	for i = 1, getn(spells) do
		spells[i] = GetSpellLink(spells[i])
	end
	if (attribute == "Learn") then
		SendMessage("CHAT_MSG_SYSTEM", format(L["LearnSpell"], table.concat(spells, L["Space"])))
	end
	if (attribute == "Unlearn") then
		SendMessage("CHAT_MSG_SYSTEM", format(L["UnlearnSpell"], table.concat(spells, L["Space"])))
	end
end

local function CF_OnUpdate(self, elapsed)
	local Now, found = GetTime()
	for id, timeout in pairs(resetTime) do
		if (craftFinished and Now > timeout) then
			if totalCreated[id] == 1 then
				SendMessage("CHAT_MSG_LOOT", format(LOOT_ITEM_CREATED_SELF, (select(2, GetItemInfo(id)))))
			else
				SendMessage("CHAT_MSG_LOOT", format(LOOT_ITEM_CREATED_SELF_MULTIPLE, (select(2, GetItemInfo(id))), totalCreated[id]))
			end
			totalCreated[id] = nil
			resetTime[id] = nil
		end
		found = true
	end
	for id, spell in pairs(spellList) do
		if (Now > spell.timeout) then
			talentspecReady(id, spell)
			spellList[id] = nil
		end
		found = true
	end
	for id, achievement in pairs(achievements) do
		if (Now > achievement.timeout) then
			achievementReady(id, achievement)
			achievements[id] = nil
		end
		found = true
	end
	if (not found) then
		self:SetScript("OnUpdate", nil)
	end
end

local function queueCraftMessage(craft, itemID, itemQuantity)
	if (prevCraft and prevCraft ~= craft) then return end
	prevCraft = craft
	totalCreated[itemID] = (totalCreated[itemID] or 0) + (itemQuantity or 1)
	resetTime[itemID] = GetTime() + craftList[itemID] + 0.5
	ChatFilter:SetScript("OnUpdate", CF_OnUpdate)
end

local function queueTalentSpecSpam(attribute, spellID)
	spellList[attribute] = spellList[attribute] or {timeout = GetTime() + 0.5}
	tinsert(spellList[attribute], spellID)
	ChatFilter:SetScript("OnUpdate", CF_OnUpdate)
end

local function queueAchievementSpam(event, achievementID, playerdata)
	achievements[achievementID] = achievements[achievementID] or {timeout = GetTime() + 0.5}
	achievements[achievementID][event] = achievements[achievementID][event] or {}
	tinsert(achievements[achievementID][event], playerdata)
	ChatFilter:SetScript("OnUpdate", CF_OnUpdate)
end

local function CF_Similarity(s, t)
	s, t = tostring(s), tostring(t)
	local s_len, t_len = #s, #t
	s = {strbyte(s, 1, s_len)}
	t = {strbyte(t, 1, t_len)}
	local num_columns = t_len + 1
	local d = {}
	for i = 0, s_len do
		d[i * num_columns] = i
	end
	for j = 0, t_len do
		d[j] = j
	end
	for i = 1, s_len do
		local i_pos = i * num_columns
		for j = 1, t_len do
			local add_cost = (s[i] ~= t[j] and 1 or 0)
			local val = min(
				d[i_pos - num_columns + j] + 1,
				d[i_pos + j - 1] + 1,
				d[i_pos - num_columns + j - 1] + add_cost
			)
			d[i_pos + j] = val
			if (i > 1 and j > 1 and s[i] == t[j - 1] and s[i - 1] == t[j]) then
				d[i_pos + j] = min(
					val,
					d[i_pos - num_columns - num_columns + j - 2] + add_cost
				)
			end
		end
	end
	if (s_len > t_len) then
		return 100 - 100 * d[#d] / s_len
	else
		return 100 - 100 * d[#d] / t_len
	end
end

local function CF_DelayTime()
	if (Clock and GetTime() - Clock > 5) then
		if (Loading) then Loading = nil end
		if (Config.FilterByLevel) then
			ChatFilter:RegisterEvent("GROUP_ROSTER_UPDATE")
		end
		Clock = nil
	end
end

local function CF_IgnoreMore(player)
	if (not player) then return end
	local ignored
	if (GetNumIgnores() >= 50) then
		for i = 1, GetNumIgnores() do
			local name = GetIgnoreName(i)
			if (player == name) then
				ignored = true
				break
			end
		end
		if (not ignored) then
			CF_IgnoreTable[player] = true
			SendMessage("CHAT_MSG_SYSTEM", format(ERR_IGNORE_ADDED_S, player))
		end
	end
end

local function CF_LevelLogging(fullName, Level)
	local MaxLevel, Now, Time = GetMaxPlayerLevel(), GetTime()
	fullName, Level = tostring(fullName), tonumber(Level)
	if (Level == MaxLevel) then
		Time = 0
	elseif (Level < 90) then
		Time = Now + 1800
	elseif (Level < 100) then
		Time = Now + 3600
	elseif (Level < 110) then
		Time = Now + 7200
	end
	if (not strfind(fullName, "-")) then fullName = fullName.."-"..GetRealmName() end
	if (not CF_LevelTable[fullName] or Level ~= CF_LevelTable[fullName].Level) then
		CF_LevelTable[fullName] = CF_LevelTable[fullName] or {}
		CF_LevelTable[fullName].Level = Level
		CF_LevelTable[fullName].Time = Time
	elseif (Now > CF_LevelTable[fullName].Time) then
		CF_LevelTable[fullName].Time = Time
	end
end

if (Config.IgnoreMore) then
	hooksecurefunc("AddIgnore", CF_IgnoreMore)
	hooksecurefunc("AddOrDelIgnore", CF_IgnoreMore)
end
if (Config.MouseScrollMultiLine) then
	hooksecurefunc("FloatingChatFrame_OnMouseScroll", function(self, delta)
		if (delta > 0) then
			if IsControlKeyDown() then self:ScrollToTop()
			elseif IsShiftKeyDown() then self:ScrollUp() self:ScrollUp() end
		else
			if IsControlKeyDown() then self:ScrollToBottom()
			elseif IsShiftKeyDown() then self:ScrollDown() self:ScrollDown() end
		end
	end)
end
if (Config.MergeCraftMSG) then
	hooksecurefunc(C_TradeSkillUI, "CraftRecipe", function(index, quantity)
			local name = GetSpellInfo(index)
			local _, itemLink = GetItemInfo(name)
			if (not itemLink) then itemLink = select(2, GetItemInfo(name)) or "" end
			local itemID = tonumber(strmatch(itemLink, "item:(%d+)"))
			if (itemID) then
				craftQuantity = quantity
				craftItemID = itemID
				prevCraft = nil
			end
			craftCount = 0
			craftFinished = nil
			craftFinishing = nil
	end)
	ChatFilter:RegisterEvent("TRADE_SKILL_SHOW")
	ChatFilter:RegisterEvent("TRADE_SKILL_CLOSE")
end
if (Config.FilterByLevel) then
	local Org_SendWho = SendWho
	SendWho = function(text)
		queryTime = GetTime()
		if (queryTime - (lastQueryTime or 0) <= 5) then return end
		FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
		if (WhoFrame:IsShown()) then
			FriendsFrame:RegisterEvent("WHO_LIST_UPDATE")
			SendWhoMessage = nil
		elseif (strfind(text, "^a%-")) then
			text = text:gsub("^a%-", "n-", 1)
			SendWhoMessage = nil
		elseif (strfind(text, "^n%-")) then
			text = text:gsub("^n%-", "x-", 1)
			SendWhoMessage = true
		elseif (strfind(text, "^x%-")) then
			SendWhoMessage = true
		elseif (text == WhoFrameEditBox:GetText()) then
			SendWhoMessage = true
		end
		if (Config.Debug) then
			print("发送查询: "..text.."  Time: "..queryTime)
		end
		lastQueryTime = queryTime
		SetWhoToUI(true)
		Org_SendWho(text)
	end
	ChatFilter:RegisterEvent("WHO_LIST_UPDATE")
	ChatFilter:RegisterEvent("FRIENDLIST_UPDATE")
	ChatFilter:RegisterEvent("BN_FRIEND_INFO_CHANGED")
	ChatFilter:RegisterEvent("GUILD_ROSTER_UPDATE")
	ChatFilter:RegisterEvent("GROUP_ROSTER_UPDATE")
	ChatFilter:RegisterEvent("UNIT_LEVEL")
	ChatFilter:RegisterEvent("UNIT_TARGET")
	ChatFilter:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end
ChatFilter:RegisterEvent("ADDON_LOADED")
ChatFilter:RegisterEvent("PLAYER_ENTERING_WORLD")

ChatFilter:SetScript("OnEvent", function(self, event)
	if (not Config.Enabled) then return end
	CF_DelayTime()
	local Now, Num = GetTime()
	if (event == "ADDON_LOADED") then
		if (Config.NoProfanityFilter) then
			SetCVar("profanityFilter", 0)
		end
		if (Config.NoWhisperSticky) then
			ChatTypeInfo.WHISPER.sticky = 0
			ChatTypeInfo.BN_WHISPER.sticky = 0
		end
		if (Config.NoJoinLeaveChannel) then
			for i = 1, NUM_CHAT_WINDOWS do
				ChatFrames = _G["ChatFrame"..i]
				ChatFrame_RemoveMessageGroup(ChatFrames, "CHANNEL")
			end
		end
		if (Config.NoAltArrowkey) then
			for i = 1, NUM_CHAT_WINDOWS do
				ChatFrames = _G["ChatFrame"..i.."EditBox"]
				ChatFrames:SetAltArrowKeyMode(false)
			end
		end
		if (Config.NoProfanityFilter) then
			SetCVar("profanityFilter", 0)
		end
		Loading = true
		self:UnregisterEvent("ADDON_LOADED")
	elseif (event == "PLAYER_ENTERING_WORLD") then
		for k, v in pairs(Config.ShieldPlayers) do
			CF_IgnoreTable[v] = true
		end
		Clock = Now
	elseif (event == "BN_FRIEND_INFO_CHANGED") then
		Num = BNGetNumFriends()
		if (Num and Num > 0) then
			for i = 1, Num do
				local toon = BNGetNumFriendGameAccounts(i)
				for j = 1, toon do
					local _, Name, Game, Realm, _, _, _, _, _, _, Level = BNGetFriendGameAccountInfo(i, j)
					if (Name and Realm and strlen(Realm) > 0 and rRealm ~= GetRealmName()) then
						Name = Name.."-"..Realm
					end
					if (Name and Game == "WoW" and Level) then
						FriendTable[Name] = true
						CF_LevelLogging(Name, Level)
					end
				end
			end
		end
	end
	if (Config.MergeCraftMSG) then
		if (event == "TRADE_SKILL_SHOW") then
			self:RegisterEvent("UNIT_SPELLCAST_START")
		elseif (event == "TRADE_SKILL_CLOSE") then
			craftCount = 0
			craftFinishing = true
			self:UnregisterEvent("UNIT_SPELLCAST_START")
		elseif (event == "UNIT_SPELLCAST_START") then
			local name, _, _, startTime, endTime, isTradeSkill = UnitCastingInfo("player")
			craftFinished = nil
			if (isTradeSkill) then
				local _, itemLink = GetItemInfo(name)
				if (not itemLink) then itemLink = select(2, GetItemInfo(name)) or "" end
				local itemID = tonumber(strmatch(itemLink, "item:(%d+)"))
				if (itemID) then
					craftList[itemID] = (endTime - startTime) / 1000
				end
				self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
			end
		elseif (event == "UNIT_SPELLCAST_INTERRUPTED") then
			craftCount = 0
			craftFinished = true
			self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED")
		end
	end
	if (Config.FilterByLevel) then
		if (event == "WHO_LIST_UPDATE") then
			Num = GetNumWhoResults()
			if (Num and Num > 0) then
				for i = 1, Num do
					local Name, Guild, Level, Race, Class, Zone = GetWhoInfo(i)
					CF_LevelLogging(Name, Level)
					if (Config.Debug) then
						print("查询结果: "..Level..":"..Name.."  Time: "..Now)
					end
					if (SendWhoMessage) then
						local WhoMessage
						if (Guild and strlen(Guild) > 0) then
							WhoMessage = format(WHO_LIST_GUILD_FORMAT, Name, Name, Level, Race, Class, Guild, Zone)
						else
							WhoMessage = format(WHO_LIST_FORMAT, Name, Name, Level, Race, Class, Zone)
						end
						SendMessage("CHAT_MSG_SYSTEM", WhoMessage)
					end
				end
			elseif (Config.Debug) then
				print("查询结果: "..format(WHO_NUM_RESULTS, Num))
			end
			if (SendWhoMessage) then
				SendMessage("CHAT_MSG_SYSTEM", format(WHO_NUM_RESULTS, Num))
			end
		else
			local Name, Level
			if (event == "FRIENDLIST_UPDATE") then
				Num = GetNumFriends()
				if (Num and Num > 0) then
					for i = 1, Num do
						Name, Level = GetFriendInfo(i)
						FriendTable[Name] = true
						CF_LevelLogging(Name, Level)
					end
				end
			elseif (event == "GUILD_ROSTER_UPDATE") then
				Num = GetNumGuildMembers()
				if (Num and Num > 0) then
					for i = 1, Num do
						Name, _, _, Level = GetGuildRosterInfo(i)
						CF_LevelLogging(Name, Level)
					end
				end
			elseif (event == "GROUP_ROSTER_UPDATE") then
				if (IsInRaid()) then
					Num = GetNumGroupMembers()
					if (Num and Num > 0) then
						for i = 1, Num do
							Name, _, _, Level = GetRaidRosterInfo(i)
							CF_LevelLogging(Name, Level)
						end
					end
				else
					Num = GetNumSubgroupMembers()
					if (Num and Num > 0) then
						for i = 1, Num do
							Name = UnitName("party"..i)
							Level = UnitLevel("party"..i)
							CF_LevelLogging(Name, Level)
						end
					end
				end
				Clock = Now
				self:UnregisterEvent("GROUP_ROSTER_UPDATE")
			elseif (event == "UNIT_LEVEL") then
				Name = UnitName("player")
				Level = UnitLevel("player")
				CF_LevelLogging(Name, Level)
			elseif (event == "UNIT_TARGET") then
				if (UnitIsPlayer("target")) then
					Name = UnitName("target")
					Level = UnitLevel("target")
					CF_LevelLogging(Name, Level)
				end
			elseif (event == "UPDATE_MOUSEOVER_UNIT") then
				if (UnitIsPlayer("mouseover")) then
					Name = UnitName("mouseover")
					Level = UnitLevel("mouseover")
					CF_LevelLogging(Name, Level)
				end
			end
		end
	end
end)

local function ChatFilter_Rubbish(self, event, msg, player, _, _, _, flag, _, _, channel, _, lineId, guid)
	if (not Config.Enabled) then return end
	if (lineId ~= prevLineId) then
		CF_DelayTime()
		local Now = GetTime()
		if (not (guid and player)) then return end
		local player, Name, Server, fullName = player
		if (guid and guid:find("Player")) then
			Name = select(6, GetPlayerInfoByGUID(guid))
			Server = select(7, GetPlayerInfoByGUID(guid))
		elseif (strfind(player, "-")) then
			Name, Server = strsplit("-", player)
		else
			Name = player
		end
		if (not Server or strlen(Server) == 0) then Server = GetRealmName() end
		if not Name then return end
		player, fullName = Name, Name.."-"..Server
		if (Server ~= GetRealmName()) then player = fullName end
		if (not Config.ScanOurself and UnitIsUnit(player,"player")) then return end
		if (flag == "GM" or flag == "DEV" or strlen(player) == 0) then return end
		if (CF_IgnoreTable[player]) then return true end
		if (ShieldTable[player] and Now - ShieldTable[player] > Config.IgnoreAdTimes * 60) then
			ShieldTable[player] = nil
		end
		if (ShieldTable[player]) then return true end
		if (event == "CHAT_MSG_WHISPER") then
			if (IsAddOnLoaded("WIM") or IsAddOnLoaded("Cellular")) then
				local f = self:GetName() or ""
				if (f == "WIM_workerFrame" or f == "WIM3_HistoryChatFrame" or f == "Cellular") then return end
			end
			if (Config.FilterRaidAlert and strfind(msg, L["RaidAlert"])) then return true end
		end
		if (Config.FilterRepeat or Config.FilterAdvertising) then
			prevMsg = msg
			msg = msg:lower()
			local Symbols = {"%s","%p","，","。","、","？","！","：","；","’","‘","“","”","【","】","《","》","（","）","—","…"}
			for i = 1, getn(Symbols) do
				msg = gsub(msg, Symbols[i], "")
			end
		end
		for i = 1, getn(Config.WhiteList) do
			if (strfind(msg, Config.WhiteList[i]) or strfind(prevMsg, Config.WhiteList[i])) then return end
		end
		for i = 1, getn(Config.BlackList) do
			if (strfind(msg, Config.BlackList[i]) or strfind(prevMsg, Config.BlackList[i])) then return true end
		end
		local Msg_Data = {Name = player, Msg = msg, Time = Now}
		if (Config.FilterRepeat or Config.FilterMultiLine) then
			local lines, AllowLines, RepeatInterval, RepeatAlike = 1, 5, 10, 95
			if (event == "CHAT_MSG_CHANNEL") then
				RepeatInterval, RepeatAlike, AllowLines = Config.RepeatInterval, Config.RepeatAlike, Config.AllowLines
			end
			for i = getn(CacheTable), 1, -1 do
				local cache = CacheTable[i]
				local interval = Now - cache.Time
				if (interval > Config.RepeatInterval) then
					tremove(CacheTable, i)
				else
					if (Config.FilterMultiLine and player == cache.Name) then
						if (interval < 0.400) then
							lines = lines + 1
						end
						if (lines > AllowLines) then return true end
					end
					if (Config.FilterRepeat and interval < RepeatInterval and player == cache.Name and (msg == cache.Msg or CF_Similarity(msg, cache.Msg) > RepeatAlike)) then return true end
				end
			end
		end
		if (not Config.ScanOurself and (FriendTable[player] or not CanComplainChat(lineId))) then return end
		if (Config.FilterAdvertising) then
			local matchs = 0
			for i = 1, getn(Config.SafeWords) do
				if (strfind(msg, Config.SafeWords[i])) then
					matchs = matchs - 1
				end
			end
			for i = 1, getn(Config.DangerWords) do
				local _, Pos = _, 0
				if (strfind(msg, Config.DangerWords[i], Pos + 1)) then
					matchs = matchs + 1
					_, Pos = strfind(msg, Config.DangerWords[i], Pos +1)
					if (strfind(msg, Config.DangerWords[i], Pos + 1)) then
						matchs = matchs + 1
						_, Pos = strfind(msg, Config.DangerWords[i], Pos +1)
						if (strfind(msg, Config.DangerWords[i], Pos + 1)) then
							matchs = matchs + 1
						end
					end
				end
			end
			if (Config.AllowMatchs < 3 and UnitIsInMyGuild(player)) then
				matchs = matchs - 1
			end
			if (matchs > Config.AllowMatchs) then
				if (Config.Debug) then
					print("|cFF33FF99ChatFilter:|r [[''"..player.."'']]的发言被过滤，过滤原因：消息中含有广告，广告数量："..matchs.."个，本次消息为："..msg)
				end
				ShieldTable[player] = Now
				return true
			end
		end
		if (Config.FilterByLevel and (event == "CHAT_MSG_WHISPER" or (not Config.OnlyOnWhisper and event ~= "CHAT_MSG_WHISPER"))) then
			local AllowLevel, queried = Config.AllowLevel, nil
			if AllowLevel < 1 then return end
			if (Server and strlen(Server) > 0 and Server ~= GetRealmName()) then
				if (event == "CHAT_MSG_GUILD" or channel == L["Channel"]) then
					ServerTable[Server] = true
				elseif (not ServerTable[Server]) then
					queried = true
				end
			end
			if (guid and select(2, GetPlayerInfoByGUID(guid)) == DEATHKNIGHT) then
				if (Config.AllowLevel <= 10) then
					AllowLevel = 55 + floor(Config.AllowLevel / 2)
				elseif (Config.AllowLevel <= 60) then
					AllowLevel = 60
				end
			end
			if (CF_LevelTable[fullName] and (CF_LevelTable[fullName].Time == 0 or (CF_LevelTable[fullName].Time > Now and CF_LevelTable[fullName].Time - Now < 7200))) then
				queried = true
				if (CF_LevelTable[fullName].Level <= AllowLevel) then
					ShieldTable[player] = Now
					return true
				end
			end
			if (not (Loading or queried or UnitIsInMyGuild(player) or WhoFrame:IsShown()) and Now - (queryTime or 0) > 5) then SendWho("a-"..player) end
		end
		tinsert(CacheTable, Msg_Data)
		prevLineId = lineId
	end
end

local function ChatFilter_Achievement(self, event, msg, player, _, _, _, _, _, _, _, _, _, guid)
	if (not Config.Enabled) then return end
	CF_DelayTime()
	if (Config.MergeAchievement) then
		local achievementID = strmatch(msg, "achievement:(%d+)")
		if (not achievementID) then return end
		achievementID = tonumber(achievementID)
		local player, Name, Server = player
		if (guid and guid:find("Player")) then
			Name = select(6, GetPlayerInfoByGUID(guid))
			Server = select(7, GetPlayerInfoByGUID(guid))
			player = Name or player
			if (Name and Server and strlen(Server) > 0 and Server ~= GetRealmName()) then
				player = Name.."-"..Server
			end
		end
		local playerdata = {name = player, guid = guid}
		local categoryID = GetAchievementCategory(achievementID)
		if (spamCategories[categoryID] or spamCategories[select(2, GetCategoryInfo(categoryID))] or specialFilters[achievementID]) then
			queueAchievementSpam((event == "CHAT_MSG_GUILD_ACHIEVEMENT" and "guild" or "area"), achievementID, playerdata)
			return true
		end
	end
end

local function ChatFilter_SystemMSG(self, event, msg)
	if (not Config.Enabled) then return end
	CF_DelayTime()
	if (Config.MergeTalentSpec) then
		local learnID = strmatch(msg, learnspellmsg) or strmatch(msg, learnabilitymsg) or strmatch(msg, learnpassivemsg)
		local unlearnID = strmatch(msg, unlearnspellmsg)
		if (learnID) then
			learnID = tonumber(strmatch(learnID, "spell:(%d+)"))
			queueTalentSpecSpam("Learn", learnID)
			return true
		elseif (unlearnID) then
			unlearnID = tonumber(strmatch(unlearnID, "spell:(%d+)"))
			queueTalentSpecSpam("Unlearn", unlearnID)
			return true
		end
		if (Config.FilterPetTalentSpec and (strfind(msg, petlearnspellmsg) or strfind(msg, petlearnabilitymsg) or strfind(msg, petunlearnspellmsg))) then return true end
	end
	if (Config.FilterDrunkMSG and not strfind(msg, L["You"])) then
		for i = 1, getn(drunkmsg) do
			if (strfind(msg, drunkmsg[i])) then return true end
		end
	end
	if (Config.FilterDuelMSG and (not strfind(msg, GetUnitName("player"))) and (strfind(msg, duelwinmsg) or strfind(msg, duellosemsg))) then return true end
	if (Config.FilterAuctionMSG and (strfind(msg, auctionstartedmsg) or strfind(msg, auctionremovedmsg))) then return true end
	if (Config.IgnoreMore and strfind(msg, ignorelistfullmsg)) then return true end
end

local function ChatFilter_CreateMSG(self, event, msg)
	if (not Config.Enabled) then return end
	CF_DelayTime()
	if (Config.MergeCraftMSG) then
		local craft, Now = self, GetTime()
		local itemID, itemQuantity = strmatch(msg, pushedmultimsg)
		if (not itemID and not itemQuantity) then
			itemID, itemQuantity = strmatch(msg, createmultimsg)
		end
		if (not itemID and not itemQuantity) then
			itemID = strmatch(msg, createmsg)
		end
		if (itemID) then
			itemID = tonumber(strmatch(itemID, "item:(%d+)"))
			itemQuantity = tonumber(itemQuantity)
			if (itemID and craftList[itemID] and craftItemID == itemID and craftQuantity > 1) then
				craftCount = craftCount + 1
				if (craftFinishing or craftCount == craftQuantity) then
					craftCount = 0
					craftFinished = true
				else
					craftFinished = nil
				end
				craftFinishing = nil
				queueCraftMessage(craft, itemID, itemQuantity)
				return true
			end
		end
		if (not Config.OtherCraftMSG) then return end
		if (strfind(msg, L["You"])) then return end
		for i = 1, getn(lootmsg) do
			if (strfind(msg, lootmsg[i])) then return end
		end
		if (not prevCraftTime or Now - prevCraftTime > 10) then
			prevCraftTime = Now
			prevCraftMsg = msg
			return
		end
		if (msg == prevCraftMsg) then return true end
		prevCraftTime = Now
		prevCraftMsg = msg
	end
end

local function ChatFilter_ReportMSG(self, event, msg)
	if (not Config.Enabled) then return end
	CF_DelayTime()
	if (Config.FilterRaidAlert and strfind(msg, L["RaidAlert"])) then return true end
	if (Config.FilterQuestReport and strfind(msg, L["QuestReport"])) then return true end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", ChatFilter_Rubbish)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", ChatFilter_ReportMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatFilter_ReportMSG)
--ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", ChatFilter_CreateMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", ChatFilter_SystemMSG)
ChatFrame_AddMessageEventFilter("CHAT_MSG_ACHIEVEMENT", ChatFilter_Achievement)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD_ACHIEVEMENT", ChatFilter_Achievement)
-----------------------------------------------------------------------
-- Add Level To Name
-----------------------------------------------------------------------
if (Config.AddLevelBeforeName) then
	local Org_GetColoredName = GetColoredName
	function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
		local fullName, Level = arg2
		if (not strfind(fullName, "-")) then fullName = fullName.."-"..GetRealmName() end
		if (CF_LevelTable[fullName] and CF_LevelTable[fullName].Level) then
			Level = CF_LevelTable[fullName].Level
		end
		local Name = Org_GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
		if (Level) then
			if (strfind(Name, "\124c")) then
				return Name:gsub("(\124cff%x%x%x%x%x%x)(.-)(\124r)", "%1"..Level..":%2%3")
			else
				return Level..":"..Name
			end
		else
			return Name
		end
	end
end
-----------------------------------------------------------------------
-- SlashCommand
-----------------------------------------------------------------------
SLASH_CHATFILTER1 = "/chatfilter"
SLASH_CHATFILTER2 = "/cf"

SlashCmdList["CHATFILTER"] = function(msg)
	local cmd = msg:lower()
	if (cmd == "on") then
		Config.Enabled = true
		print("ChatFilter has been enabled.")
	elseif (cmd == "off") then
		Config.Enabled = nil
		print("ChatFilter has been disabled.")
	elseif (cmd == "me") then
		if (Config.ScanOurself) then
			Config.ScanOurself = nil
			print("ScanOurself has been disabled.")
		else
			Config.ScanOurself = true
			print("ScanOurself has been enabled.")
		end
	elseif (cmd == "ad") then
		if (Config.FilterAdvertising) then
			Config.FilterAdvertising = nil
			print("FilterAdvertising has been disabled.")
		else
			Config.FilterAdvertising = true
			print("FilterAdvertising has been enabled.")
		end
	elseif (cmd == "mult") then
		if (Config.FilterMultiLine) then
			Config.FilterMultiLine = nil
			print("FilterMultiLine has been disabled.")
		else
			Config.FilterMultiLine = true
			print("FilterMultiLine has been enabled.")
		end
	elseif (cmd == "repeat") then
		if (Config.FilterRepeat) then
			Config.FilterRepeat = nil
			print("FilterRepeat has been disabled.")
		else
			Config.FilterRepeat = true
			print("FilterRepeat has been enabled.")
		end
	elseif (cmd == "level") then
		if (Config.FilterByLevel) then
			Config.FilterByLevel = nil
			print("FilterByLevel has been disabled.")
		else
			Config.FilterByLevel = true
			print("FilterByLevel has been enabled.")
		end
	elseif (cmd == "achieve") then
		if (Config.MergeAchievement) then
			Config.MergeAchievement = nil
			print("MergeAchievement has been disabled.")
		else
			Config.MergeAchievement = true
			print("MergeAchievement has been enabled.")
		end
	elseif (cmd == "talent") then
		if (Config.MergeTalentSpec) then
			Config.MergeTalentSpec = nil
			print("MergeTalentSpec has been disabled.")
		else
			Config.MergeTalentSpec = true
			print("MergeTalentSpec has been enabled.")
		end
	elseif (cmd == "creat") then
		if (Config.MergeCraftMSG) then
			Config.MergeCraftMSG = nil
			print("MergeCraftMSG has been disabled.")
		else
			Config.MergeCraftMSG = true
			print("MergeCraftMSG has been enabled.")
		end
	elseif (cmd == "auction") then
		if (Config.FilterAuctionMSG) then
			Config.FilterAuctionMSG = nil
			print("FilterAuctionMSG has been disabled.")
		else
			Config.FilterAuctionMSG = true
			print("FilterAuctionMSG has been enabled.")
		end
	elseif (cmd == "duel") then
		if (Config.FilterDuelMSG) then
			Config.FilterDuelMSG = nil
			print("FilterDuelMSG has been disabled.")
		else
			Config.FilterDuelMSG = true
			print("FilterDuelMSG has been enabled.")
		end
	elseif (cmd == "drunk") then
		if (Config.FilterDrunkMSG) then
			Config.FilterDrunkMSG = nil
			print("FilterDrunkMSG has been disabled.")
		else
			Config.FilterDrunkMSG = true
			print("FilterDrunkMSG has been enabled.")
		end
	elseif cmd == "raidalert" then
		if (Config.FilterRaidAlert) then
			Config.FilterRaidAlert = nil
			print("FilterRaidAlert has been disabled.")
		else
			Config.FilterRaidAlert = true
			print("FilterRaidAlert has been enabled.")
		end
	elseif cmd == "questreport" then
		if (Config.FilterQuestReport) then
			Config.FilterQuestReport = nil
			print("FilterRaidAlert has been disabled.")
		else
			Config.FilterQuestReport = true
			print("FilterQuestReport has been enabled.")
		end
	elseif (cmd == "addlevel") then
		if (Config.AddLevelBeforeName) then
			Config.AddLevelBeforeName = nil
			print("AddLevelBeforeName has been disabled.")
		else
			Config.AddLevelBeforeName = true
			print("AddLevelBeforeName has been enabled.")
		end
	elseif cmd == "debug" then
		if (Config.Debug) then
			Config.Debug = nil
			print("Debug has been disabled.")
		else
			Config.Debug = true
			print("Debug has been enabled.")
		end
	elseif (cmd == "wipe level") then
		CF_LevelTable = nil
		CF_LevelTable = {}
		print("The LevelTable has been cleared.")
	elseif (cmd == "wipe ignore") then
		CF_IgnoreTable = nil
		CF_IgnoreTable = {}
		print("The IgnoreTable has been cleared.")
	elseif (strfind(cmd, "unignore") == 1) then
		local player = gsub(cmd, "unignore", "")
		player = gsub(player, "%s", "")
		if (CF_IgnoreTable[player]) then
			CF_IgnoreTable[player] = nil
			SendMessage("CHAT_MSG_SYSTEM", format(ERR_IGNORE_REMOVED_S, player))
		else
			SendMessage("CHAT_MSG_SYSTEM", ERR_IGNORE_NOT_FOUND)
		end
	else
		print("/cf [ on/off | ad | mult | repeat | level | achieve | talent | creat ]")
		print("/cf [ raidalert | questreport | duel | drunk | auction | unignore ]")
	end
end