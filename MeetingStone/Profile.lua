
BuildEnv(...)

Profile = Addon:NewModule('Profile', 'AceEvent-3.0')

local DEFAULT_CHATGROUP_LISTENING = {
    APP_WHISPER = {
        [1] = true,
    }
}

local DEFAULT_CHATGROUP_COLOR = {
    APP_WHISPER = {
        r = 0.7, g = 1, b = 0,
    }
}

function Profile:OnInitialize()
    local gdb = {
        global = {
            ActivityProfiles = {
                Voice     = nil,
                VoiceSoft = nil,
            },
            annData        = {},
            serverDatas    = {},
            ignoreHash     = {},
            spamWord       = {},
            searchProfiles = {},
        },
    }

    local cdb = {
        profile = {
            settings = {
                storage   = { point = 'TOP', x = 0, y = -20},
                panel     = true,
                panelLock = false,
                sound     = true,
                ignore    = true,
                spamWord  = true,
                packedPvp = true,
                spamLengthEnabled = true,
                spamLength = 20,
            },
            minimap = {
                minimapPos = 192.68,
            },
            searchHistoryList  = {},
            createHistoryList  = {},
            searchInputHistory = {},
            followMemberList   = {},
            chatGroupListening = DEFAULT_CHATGROUP_LISTENING,
            chatGroupColor     = DEFAULT_CHATGROUP_COLOR,
            recent = {},
            combatData = {
                dd = 0, dt = 0, hd = 0, dead = 0, time = 0,
            }
        }
    }

    self.chatGroupListeningTemp = { APP_WHISPER = {} }
    self.ignoreCache = {}

    self.gdb = LibStub('AceDB-3.0'):New('MEETINGSTONE_UI_DB', gdb, true)
    self.cdb = LibStub('AceDB-3.0'):New('MEETINGSTONE_CHARACTER_DB', cdb)

    local settingVersion = self:GetLastCharacterVersion()
    if settingVersion < 70300.12 then
        self.cdb.profile.settings.onlyms = nil

        for _, v in pairs(self.cdb.profile.followMemberList) do
            if not v.status then
                if v.bitfollow then
                    v.status = FOLLOW_STATUS_FRIEND
                else
                    v.status = FOLLOW_STATUS_STARED
                end
            v.bitfollow = nil
            end
        end

        self.cdb.profile.lastSearchCode = self.cdb.profile.lastSearchValue or self.cdb.profile.lastSearchCode
        self.cdb.profile.lastSearchValue = nil
    end
    if settingVersion < 80000.03 then
        wipe(self.cdb.profile.searchHistoryList)
    end
    self.cdb.profile.version = ADDON_VERSION

    self.cdb.RegisterCallback(self, 'OnDatabaseShutdown')
end

function Profile:OnEnable()
    local settings = {
        'panel',
        'panelLock',
        'sound',
        'ignore',
        'spamWord',
        'packedPvp',
        'spamLengthEnabled',
        'spamLength',
    }

    for _, key in ipairs(settings) do
        self:SetSetting(key, self:GetSetting(key), true)
    end

    self:RefreshIgnoreCache()
    self:ImportDefaultSpamWord()
end

function Profile:GetSetting(key)
    return self.cdb.profile.settings[key]
end

function Profile:SetSetting(key, value, force)
    if force or self.cdb.profile.settings[key] ~= value then
        self.cdb.profile.settings[key] = value
        self:SendMessage('MEETINGSTONE_SETTING_CHANGED', key, value, true)
        self:SendMessage('MEETINGSTONE_SETTING_CHANGED_' .. key, value, true)
    end
end

function Profile:SaveActivityProfile(activity)
    self.gdb.global.ActivityProfiles.Voice = activity:GetVoiceChat()

    self.gdb.global.ActivityProfiles[activity:GetName()] = {
        ItemLevel  = activity:GetItemLevel(),
        Summary    = activity:GetSummary(),
        MinLevel   = activity:GetMinLevel(),
        MaxLevel   = activity:GetMaxLevel(),
        PvPRating  = activity:GetPvPRating(),
        HonorLevel = activity:GetHonorLevel(),
    }
end

function Profile:GetActivityProfile(activityType)
    return self.gdb.global.ActivityProfiles[activityType], self.gdb.global.ActivityProfiles.Voice
end

function Profile:GetGlobalDB()
    return self.gdb
end

function Profile:GetCharacterDB()
    return self.cdb
end

function Profile:GetLastSearchCode()
    return self.cdb.profile.lastSearchCode or '6-0-0-0'
end

function Profile:SetLastSearchCode(searchValue)
    self.cdb.profile.lastSearchCode = searchValue

    self:SaveSearchHistory(searchValue)
end

function Profile:SaveVersion()
    self.gdb.global.version = ADDON_VERSION
end

function Profile:IsNewVersion()
    local pVersion = tonumber(self.gdb.global.version) or 0
    local cVersion = tonumber(ADDON_VERSION) or 0

    return pVersion < cVersion
end

function Profile:SaveSearchHistory(searchValue)
    local list = self.cdb.profile.searchHistoryList

    tDeleteItem(list, searchValue)
    tinsert(list, 1, searchValue)

    RefreshHistoryMenuTable(ACTIVITY_FILTER_BROWSE)
end

function Profile:SaveCreateHistory(searchValue)
    local list = self.cdb.profile.createHistoryList

    tDeleteItem(list, searchValue)
    tinsert(list, 1, searchValue)

    RefreshHistoryMenuTable(ACTIVITY_FILTER_CREATE)
end

function Profile:GetHistoryList(isCreator)
    if isCreator then
        return self.cdb.profile.createHistoryList
    else
        return self.cdb.profile.searchHistoryList
    end
end

function Profile:ClearHistory()
    wipe(self.cdb.profile.createHistoryList)
    wipe(self.cdb.profile.searchHistoryList)
    wipe(self.cdb.profile.searchInputHistory)

    RefreshHistoryMenuTable(ACTIVITY_FILTER_BROWSE)
    RefreshHistoryMenuTable(ACTIVITY_FILTER_CREATE)
end

function Profile:GetSearchInputHistory(searchValue)
    return self.cdb.profile.searchInputHistory[searchValue]
end

function Profile:SaveSearchInputHistory(searchValue, text)
    self.cdb.profile.searchInputHistory[searchValue] = self.cdb.profile.searchInputHistory[searchValue] or {}

    tDeleteItem(self.cdb.profile.searchInputHistory[searchValue], text)
    tinsert(self.cdb.profile.searchInputHistory[searchValue], 1, text)

    if #self.cdb.profile.searchInputHistory[searchValue] > MAX_SEARCHBOX_HISTORY_LINES then
        tremove(self.cdb.profile.searchInputHistory[searchValue])
    end

    return self.cdb.profile.searchInputHistory[searchValue]
end

function Profile:IsIgnored(name)
    return self.gdb.global.ignoreHash[Ambiguate(name, 'none')]
end

function Profile:AddIgnore(name)
    self.gdb.global.ignoreHash[Ambiguate(name, 'none')] = time()
    self:RefreshIgnoreCache()
end

function Profile:DelIgnore(name)
    self.gdb.global.ignoreHash[Ambiguate(name, 'none')] = nil
    self:RefreshIgnoreCache()
end

function Profile:GetNumIgnores()
    return #self.ignoreCache
end

function Profile:RefreshIgnoreCache()
    wipe(self.ignoreCache)

    for k, v in pairs(self.gdb.global.ignoreHash) do
        tinsert(self.ignoreCache, k)
    end

    sort(self.ignoreCache)
end

function Profile:GetIgnoreName(index)
    return self.ignoreCache[index]
end

function Profile:GetSpamWordIndex(word)
    for i, v in ipairs(self.gdb.global.spamWord) do
        if v.text == word.text and v.pain == word.pain then
            return i
        end
    end
end

local function sortSpamWord(a, b)
    return a.text < b.text
end

function Profile:SortSpamWord()
    sort(self.gdb.global.spamWord, sortSpamWord)
end

function Profile:AddSpamWord(word, delay, silence)
    if type(word) ~= 'table'  then
        System:Log(L['添加失败，未输入关键字。'])
        return
    end

    if word.pain then
        word.text = word.text:lower():trim()
    end

    if self:GetSpamWordIndex(word) then
        if not silence then System:Logf(L['添加失败，关键字“%s”已存在。'], word.text) end
    else
        tinsert(self.gdb.global.spamWord, word)
        if not silence then System:Logf(L['添加成功，关键字“%s”已添加。'], word.text) end
        if not delay then
            ClearSpamWordCache()
            self:SortSpamWord()
            self:SendMessage('MEETINGSTONE_SPAMWORD_UPDATE', word)
        end
    end
end

function Profile:DelSpamWord(word)
    if type(word) ~= 'table'  then
        System:Log(L['删除失败，未输入关键字。'])
        return
    end

    local index = self:GetSpamWordIndex(word, pain)
    if index then
        ClearSpamWordCache()
        tremove(self.gdb.global.spamWord, index)
        System:Logf(L['删除成功，关键字“%s”已删除。'], word.text)
        self:SendMessage('MEETINGSTONE_SPAMWORD_UPDATE')
    else
        System:Logf(L['删除失败，关键字“%s”不存在。'], word.text)
    end
end

function Profile:GetSpamWords()
    return self.gdb.global.spamWord
end

function Profile:SaveImportSpamWord(text, silence)
    if type(text) ~= 'string' then
        return
    end

    local list = {('\n'):split(text)}

    if #list == 0 then
        return
    end

    for i, v in ipairs(list) do
        local enable, text = v:match('^([!]*)(.+)$')
        if text then
            enable = enable == '' and true or nil
            local word = { text = text, pain = enable }
            self:AddSpamWord(word, true, silence)
        end
    end

    ClearSpamWordCache()
    self:SortSpamWord()
end

function Profile:ImportDefaultSpamWord()
    if self.gdb.global.spamWord.default then
        return
    end
    self.gdb.global.spamWord.default = true
    self:SaveImportSpamWord(DEFAULT_SPAMWORD, true)
    self:SendMessage('MEETINGSTONE_SPAMWORD_UPDATE')
end

function Profile:ResetSpamWord()
    wipe(self.gdb.global.spamWord)
    self:ImportDefaultSpamWord()
    System:Log(L['关键字列表已恢复默认'])
end

function Profile:ExportSpamWord()
    local text = {}
    for i, v in ipairs(self.gdb.global.spamWord) do
        if not v.pain then
            tinsert(text, '!' .. v.text)
        else
            tinsert(text, v.text)
        end
    end

    return table.concat(text, '\n')
end

function Profile:ImportSpamWord(text)
    self:SaveImportSpamWord(text)
    self:SendMessage('MEETINGSTONE_SPAMWORD_UPDATE')
    System:Log(L['导入关键字完成'])
end

function Profile:AddSearchProfile(name, profile)
    self.gdb.global.searchProfiles[name] = profile
    self:SendMessage('MEETINGSTONE_SEARCH_PROFILE_UPDATE')
end

function Profile:DeleteSearchProfile(name)
    self.gdb.global.searchProfiles[name] = nil
    self:SendMessage('MEETINGSTONE_SEARCH_PROFILE_UPDATE')
end

function Profile:IterateSearchProfiles()
    return pairs(self.gdb.global.searchProfiles)
end

function Profile:GetSearchProfile(name)
    return self.gdb.global.searchProfiles[name]
end

function Profile:IsProfileKeyNew(key, version)
    local value = self.cdb.profile[key]
    return not value or (version and value < tostring(version))
end

function Profile:ClearProfileKeyNew(key)
    self.cdb.profile[key] = ADDON_VERSION
end

---- Follow

function Profile:AddFollow(target, guid, status)
    for i, v in ipairs(self.cdb.profile.followMemberList) do
        if v.name == target then
            v.guid = guid
            v.status = status
            self:SendMessage('MEETINGSTONE_FOLLOWMEMBERLIST_UPDATE')
            return
        end
    end

    tinsert(self.cdb.profile.followMemberList, 1, {
        name = target,
        guid = guid,
        time = time(),
        isNew = true,
        status = status
    })
    self:SendMessage('MEETINGSTONE_FOLLOWMEMBERLIST_UPDATE')
end

function Profile:IsFollowed(target)
    for i, v in ipairs(self.cdb.profile.followMemberList) do
        if v.name == target then
            return (v.status == FOLLOW_STATUS_STARED or v.status == FOLLOW_STATUS_FRIEND), i
        end
    end
end

function Profile:GetFollowGuid(target)
    for i, v in ipairs(self.cdb.profile.followMemberList) do
        if v.name == target then
            return v.guid
        end
    end
end

function Profile:GetFollowList()
    return self.cdb.profile.followMemberList
end

---- Whisper

function Profile:GetChatGroupListeningDB(id, group)
    return id > 10 and self.chatGroupListeningTemp[group] or self.cdb.profile.chatGroupListening[group]
end

function Profile:IsChatGroupListening(id, group)
    return self:GetChatGroupListeningDB(id, group)[id]
end

function Profile:ToggleChatGroupListening(id, group, checked)
    self:GetChatGroupListeningDB(id, group)[id] = not not checked
end

function Profile:SetChatGroupColor(group, r, g, b)
    self.cdb.profile.chatGroupColor[group] = {r = r, g = g, b = b}
end

function Profile:GetChatGroupColor(group)
    local color = self.cdb.profile.chatGroupColor[group]
    return color.r, color.g, color.b
end

function Profile:ResetChatWindows()
    self.chatGroupListeningTemp = {}
    self.cdb.profile.chatGroupListening = CopyTable(DEFAULT_CHATGROUP_LISTENING)
    self.cdb.profile.chatGroupColor = CopyTable(DEFAULT_CHATGROUP_COLOR)
end

function Profile:NeedWorldQuestHelp()
    return not self.cdb.profile.worldQuestHelp
end

function Profile:ClearWorldQuestHelp()
    self.cdb.profile.worldQuestHelp = true
end

function Profile:GetRecentDB(activityCode)
    if not self.cdb.profile.recent[activityCode] then
        self.cdb.profile.recent[activityCode] = {}
    end
    return self.cdb.profile.recent[activityCode]
end

function Profile:SetRecentDB(activityCode, db)
    self.cdb.profile.recent[activityCode] = db
end

function Profile:IterateRecentDB()
    return pairs(self.cdb.profile.recent)
end

function Profile:OnDatabaseShutdown()
    self:SendMessage('MEETINGSTONE_DB_SHUTDOWN')
end

function Profile:GetLastVersion()
    return tonumber(self.gdb.global.version) or 0
end

function Profile:GetLastCharacterVersion()
    return tonumber(self.cdb.profile.version) or 0
end

function Profile:SaveLastVersion()
    self.gdb.global.version = ADDON_VERSION
    self.cdb.profile.version = ADDON_VERSION
end

function Profile:GetCombatData()
    return self.cdb.profile.combatData
end

function Profile:ResetCombatData()
    self.cdb.profile.combatData = {
        dd = 0, dt = 0, hd = 0, dead = 0, time = 0,
    }
    return self.cdb.profile.combatData
end
