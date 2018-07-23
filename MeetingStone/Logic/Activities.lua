
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

Activities = Addon:NewModule('Activities', 'AceEvent-3.0', 'NetEaseSocket-2.0', 'AceTimer-3.0')
Activities._SendServer = Activities.SendServer
Activities._RegisterServer = Activities.RegisterServer

function Activities:OnInitialize()
    self.serverTimers = {}
    self.timeOuts = {}

    self:ListenSocket('NERB', ADDON_SERVER)

    self:RegisterEvent('ENCOUNTER_END')

    self:RegisterServer('SERVER_CONNECTED')

    self:RegisterServer('OASU', 'OA_SCORE_UPDATE')
    self:RegisterServer('OAQR', 'OA_QUERY_RESULT')
    self:RegisterServer('OABR', 'OA_BUY_RESULT')
    self:RegisterServer('OALR', 'OA_LOTTERY_RESULT')
    self:RegisterServer('OASR', 'OA_SIGNIN_RESULT')
    self:RegisterServer('OAUR', 'OA_SIGNUP_RESULT')
    self:RegisterServer('OAAUR', 'OA_SETADDRESS_RESULT')

    self:RegisterTimeOut('OAB', 'OABR', 'OnBuyTimeOut')
    self:RegisterTimeOut('OAQ', 'OAQR', 'OnQueryTimeOut')
    self:RegisterTimeOut('OAL', 'OALR', 'OnLotteryTimeOut')

    self:ConnectServer()
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_DATA_UPDATED')
end

function Activities:SendServer(cmd, ...)
    local timeOut = self.timeOuts[cmd]
    if not timeOut then
        self:_SendServer(cmd, UnitGUID('player'), GetPlayerBattleTag(), ADDON_VERSION_SHORT, ...)
    else
        if timeOut.timer then
            return
        else
            self:_SendServer(cmd, UnitGUID('player'), GetPlayerBattleTag(), ADDON_VERSION_SHORT, ...)
            timeOut.timer = self:ScheduleTimer('OnServerTimeOut', SERVER_TIMEOUT, cmd, timeOut.callback)
        end
    end
end

function Activities:RegisterServer(cmd, method)
    self:_RegisterServer(cmd, function(cmd, ...)
        local timeOut = self.timeOuts[cmd]
        if timeOut then
            self:CancelTimer(timeOut.timer)
            timeOut.timer = nil
        end

        if type(method) == 'string' then
            self[method](self, cmd, ...)
        elseif type(method) == 'function' then
            method(cmd, ...)
        else
            self[cmd](self, cmd, ...)
        end
    end)
end

function Activities:RegisterTimeOut(sCmd, rCmd, callback)
    local timeOut = {
        sCmd = sCmd,
        rCmd = rCmd,
        callback = callback,
    }

    self.timeOuts[sCmd] = timeOut
    self.timeOuts[rCmd] = timeOut
end

function Activities:OnServerTimeOut(cmd, callback)
    self.timeOuts[cmd].timer = nil

    if type(callback) == 'function' then
        callback(self)
    elseif type(callback) == 'string' then
        if self[callback] then
            self[callback](self)
        else
            self:SendMessage(callback)
        end
    end
end

---- Event

function Activities:ENCOUNTER_END(_, id, name, difficulty, size, status)
    if status == 0 then
        return
    end
    if difficulty == 14 or difficulty == 15 or difficulty == 16 then
        self:SendServer('OABK',
            id,
            name,
            difficulty,
            size,
            IsGroupLeader())
    end
end

function Activities:SERVER_CONNECTED()
    self.isConnected = true
    self:SendMessage('MEETINGSTONE_ACTIVITIES_SERVER_CONNECTED')
end

function Activities:MEETINGSTONE_ACTIVITIES_DATA_UPDATED(_, data)
    self.data = data
end

---- Socket

function Activities:OA_SETADDRESS_RESULT(_, success, msg)
    if success then
        self.email = self._email
        self.contact = self._contact
        self.tel = self._tel
        self.address = self._address
        System:Log(L['设置联系方式成功。'])
    else
        System:Error(L['设置联系方式失败，'] .. msg)
    end
end

function Activities:OA_QUERY_RESULT(_, score1, score2, contact, tel, email, address, signIn)
    if not score1 then
        self:OnQueryTimeOut()
    else
        self.scoreQueried = true
        self.score1 = score1
        self.score2 = score2
        self.email = email
        self.contact = contact
        self.tel = tel
        self.address = address
        self.canSignIn = not signIn or nil
        self:SendMessage('MEETINGSTONE_ACTIVITIES_PERSONINFO_UPDATE')
        if self:IsActivityHasScore() then
            System:Log(L['当前可用活动点数：'] .. score1)
        end
    end
end

function Activities:OA_BUY_RESULT(_, success, msg, score1, score2)
    self.buyingItem = nil
    if success then
        self:UpdateScore(score1, score2)

        PlayerInfoDialog:Open(msg, L['购买成功'], L.ActivitiesMallWarning, true)
        System:Log(msg)
    else
        System:Error(msg)
        System:Log(msg)
    end
    self:SendMessage('MEETINGSTONE_ACTIVITIES_BUY_RESULT')
end

function Activities:OA_LOTTERY_RESULT(_, success, ...)
    if success then
        self:UpdateScore(select(2, ...))
    end
    self:SendMessage('MEETINGSTONE_ACTIVITIES_LOTTERY_RESULT', success, ...)
end

function Activities:OA_SIGNIN_RESULT(_, score, msg, scoreType)
    self.canSignIn = nil
    if not score or not scoreType then
        System:Error(msg)
        self:SendMessage('MEETINGSTONE_ACTIVITIES_PERSONINFO_UPDATE')
    else
        self:UpdateScore(score, scoreType)
        System:Message(msg)
    end
    System:Log(msg)
end

function Activities:OA_SCORE_UPDATE(_, score, msg, scoreType)
    if not score or not scoreType then
        return
    end
    self:UpdateScore(score, scoreType)
    System:Log(msg)
end

function Activities:OA_SIGNUP_RESULT(_, success, msg, isLeader)
    if success and isLeader then
        PlayerInfoDialog:Open(msg, L['报名成功'], msg, true, nil, L['完善联系方式'])
    elseif success then
        System:Message(msg);
    else
        System:Error(msg);
    end
end

---- TimeOut

function Activities:OnBuyTimeOut()
    self.buyingItem = nil
    System:Error(L['购买失败，服务器超时。'])
    self:SendMessage('MEETINGSTONE_ACTIVITIES_BUY_TIMEOUT')
end

function Activities:OnQueryTimeOut()
    System:Log(L['获取活动点数信息失败。'])
    self:SendMessage('MEETINGSTONE_ACTIVITIES_QUERY_TIMEOUT')
end

function Activities:OnLotteryTimeOut()
    self:SendMessage('MEETINGSTONE_ACTIVITIES_LOTTERY_RESULT', false, L['抽奖失败，服务器超时。'], nil, nil, 0)
end

---- Interface

function Activities:UpdateScore(score1, score2)
    if not self:IsActivityHasScore() or not self.scoreQueried then
        return
    end

    if type(score2) == 'string' then
        if score2 == 'point_1' then
            self.score1 = self.score1 + score1
        else
            self.score2 = self.score2 + score1
        end
    elseif type(score2) == 'number' then
        self.score1 = score1
        self.score2 = score2
    else
        return
    end
    self:SendMessage('MEETINGSTONE_ACTIVITIES_PERSONINFO_UPDATE')
end

function Activities:Buy(id)
    self.buyingItem = id
    self:SendServer('OAB', id)
    self:SendMessage('MEETINGSTONE_ACTIVITIES_BUY_SENDING')
end

function Activities:Lottery()
    if not self.data or not self.data.lotteryId then
        return
    end
    self:SendServer('OAL', self.data.lotteryId)
    self:SendMessage('MEETINGSTONE_ACTIVITIES_LOTTERY_SENDING')
end

function Activities:SignIn()
    self:SendServer('OAS', GetAddonSource())
end

function Activities:SignUp(isLeader, activityId)
    self:SendServer('OAU', isLeader or false, GetTotalAchievementPoints(), IsGuildLeader(), activityId)
end

function Activities:GetActivitiesInfo(index)
    local activity = self.data and self.data.activities[index]
    if not activity then
        return
    end
    return activity.title, activity.subtitle, activity.summary, activity.bg, activity.url
end

function Activities:GetActivitiesId(index)
    local activity = self.data and self.data.activities[index]
    if not activity then
        return
    end
    return activity.id
end

function Activities:GetActivitiesCount()
    return self.data and #self.data.activities or 0
end

function Activities:GetBuyingItem()
    return self:GetMallItemInfo(self.buyingItem)
end

function Activities:QueryPersonInfo()
    self:SendServer('OAQ')
    self:SendMessage('MEETINGSTONE_ACTIVITIES_QUERY_SENDING')
end

function Activities:SetPersonInfo(contact, tel, email, address)
    if self.email ~= email or self.contact ~= contact or self.tel ~= tel or self.address ~= address then
        self._email = email
        self._contact = contact
        self._tel = tel
        self._address = address
        self:SendServer('OAAU', contact, tel, email, address)
    else
        System:Log(L['设置联系方式成功。'])
    end
end

function Activities:GetPersonInfo()
    return self.contact, self.tel, self.email, self.address
end

function Activities:IsConnected()
    return self.isConnected
end

function Activities:GetMallItemInfo(id)
    return self.data and self.data.mallData and self.data.mallData[tonumber(id)]
end

function Activities:GetScore()
    return self.score1, self.score2
end

function Activities:CanSignIn(index)
    return self.canSignIn and index == 1 and self.data and self.data.gift and ((source == 0 and self.data.gift < 0) or bit.band(abs(self.data.gift), GetAddonSource() or 1) > 0)
end

function Activities:CanLeaderSignUp(index)
    return self.data and self.data.activities[index] and self.data.activities[index].signUpLeader
end

function Activities:CanMemberSignUp(index)
    return self.data and self.data.activities[index] and self.data.activities[index].signUpMember
end

function Activities:IsActivityHasScore()
    return self.data and not self.data.noScore
end

function Activities:IsReady()
    return not not self.data
end