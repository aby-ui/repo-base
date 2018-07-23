
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

ActivitiesLottery = Addon:NewModule(CreateFrame('Frame'), 'ActivitiesLottery', 'AceEvent-3.0', 'AceTimer-3.0')

local ACCELERATION = 2
local MIN_SPEED = 2
local MAX_SPEED = 20
local MIN_CIRCLE = 1

local BUTTON_SIZE = 100
local SPACING = 5
local MARGIN = 12

local POSITIONS = {
    {0,1},
    {0,0},
    {1,0},
    {2,0},
    {2,1},
    {2,2},
    {1,2},
    {0,2},
}

function ActivitiesLottery:OnInitialize()
    self:Hide()
    GUI:Embed(self, 'Owner')

    self.buttons = {}
    self.lotteryList = nil

    local LotteryWidget = GUI:GetClass('TitleWidget'):New(self) do
        LotteryWidget:SetPoint('TOPLEFT')
        LotteryWidget:SetPoint('BOTTOMLEFT')
        LotteryWidget:SetWidth((BUTTON_SIZE + SPACING) * 3 + MARGIN * 2 - SPACING)
    end

    local Highlight = LotteryWidget:CreateTexture(nil, 'OVERLAY') do
        Highlight:SetSize(BUTTON_SIZE, BUTTON_SIZE)
        Highlight:SetTexture([[Interface\Store\Store-Main]])
        Highlight:SetTexCoord(0.37011719, 0.50683594, 0.54199219, 0.74023438)
        Highlight:SetBlendMode('ADD')
        Highlight:Hide()
    end

    local LotteryPrice = LotteryWidget:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall') do
        LotteryPrice:SetPoint('BOTTOM', LotteryWidget, 'CENTER', 0, 2)
    end

    local LotteryButton = CreateFrame('Button', nil, LotteryWidget, 'UIPanelButtonTemplate') do
        LotteryButton:SetSize(80, 26)
        LotteryButton:SetPoint('TOP', LotteryWidget, 'CENTER', 0, -2)
        LotteryButton:SetText(L['开始抽奖'])
        LotteryButton:SetScript('OnClick', function()
            self:Lottery()
        end)
    end

    local SummaryWidget = GUI:GetClass('TitleWidget'):New(self) do
        SummaryWidget:SetPoint('TOPLEFT', LotteryWidget, 'TOPRIGHT', 3, 0)
        SummaryWidget:SetPoint('BOTTOMRIGHT')
        SummaryWidget:SetText(L['抽奖说明'])
    end

    local Summary = GUI:GetClass('ScrollSummaryHtml'):New(self) do
        SummaryWidget:SetObject(Summary, 10, 5, 10, 10)
        Summary:SetSpacing('p', 5)
    end

    self.Highlight = Highlight
    self.LotteryWidget = LotteryWidget
    self.LotteryButton = LotteryButton
    self.LotteryPrice = LotteryPrice
    self.Summary = Summary

    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_PERSONINFO_UPDATE', 'RefreshButton')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_DATA_UPDATED')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_LOTTERY_SENDING', 'Start')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_LOTTERY_RESULT')
    self:RegisterMessage('MEETINGSTONE_ACTIVITIES_LOTTERY_TIMEOUT')
end

function ActivitiesLottery:MEETINGSTONE_ACTIVITIES_LOTTERY_RESULT(_, success, msg, _, _, item)
    self.msg = msg
    self.success = success
    self.item = item
    self:Stop(success and item or 0)
end

function ActivitiesLottery:MEETINGSTONE_ACTIVITIES_LOTTERY_TIMEOUT()
    self:Stop(0)
end

function ActivitiesLottery:MEETINGSTONE_ACTIVITIES_DATA_UPDATED(_, data)
    if data.noScore then
        return
    end
    self.lotteryList = data.lotteryList
    self.lotteryPrice = data.lotteryPrice

    self.Summary:SetText(FormatActivitiesSummaryUrl(L.ActivitiesLotterySummary, data.url))
    self.LotteryPrice:SetText(L['活动点数：'] .. self.lotteryPrice)
    
    for i, v in ipairs(self.lotteryList) do
        local button = self:GetLotteryButton(i)
        button:SetText(v.name)
        button:SetModel(v.model)
        button:SetIcon(v.icon)
    end

    self:RefreshButton()
end

function ActivitiesLottery:RefreshButton()
    local score = Activities:GetScore()
    if self.started then
        self.LotteryButton:SetText(L['正在抽奖'])
        self.LotteryButton:Disable()
    elseif not self.lotteryPrice or not score or score < self.lotteryPrice then
        self.LotteryButton:SetText(L['点数不足'])
        self.LotteryButton:Disable()
    else
        self.LotteryButton:SetText(L['开始抽奖'])
        self.LotteryButton:Enable()
    end
end

function ActivitiesLottery:GetLotteryButton(index)
    if not self.buttons[index] then
        local x, y = POSITIONS[index][1], POSITIONS[index][2]
        local button = Addon:GetClass('LotteryItem'):New(self.LotteryWidget)
        button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
        button:SetPoint('CENTER', self.LotteryWidget, 'TOPLEFT',
            x*(BUTTON_SIZE+SPACING)+MARGIN+BUTTON_SIZE/2, -y*(BUTTON_SIZE+SPACING)-MARGIN-BUTTON_SIZE/2)

        self.buttons[index] = button
    end
    return self.buttons[index]
end

function ActivitiesLottery:OnTimer()
    self.index = self.index % self.count + 1

    self.Highlight:ClearAllPoints()
    self.Highlight:SetParent(self.buttons[self.index])
    self.Highlight:SetPoint('CENTER')

    if not self.stopIndex or self.maxTimes < MIN_CIRCLE * self.count then
        self.speed = self.speed + ACCELERATION
    elseif self.stopIndex and self.maxTimes >= MIN_CIRCLE * self.count then
        if self.index == self.slowIndex or self.speed ~= MAX_SPEED then
            self.speed = self.speed - ACCELERATION
        end
    end

    if self.speed >= MAX_SPEED then
        self.maxTimes = self.maxTimes + 1
        self.speed = MAX_SPEED
    end

    if self.speed < MIN_SPEED then
        self.speed = MIN_SPEED
    end

    if self.speed > MIN_SPEED or self.index ~= self.stopIndex then
        return self:ScheduleTimer('OnTimer', 1 / self.speed)
    else
        self:OnStop()
    end
end

function ActivitiesLottery:Start()
    self.started = true
    self.count = #self.lotteryList
    self.speed = MIN_SPEED
    self.stopIndex = self.stopIndex or 1
    self.slowIndex = nil
    self.maxTimes = 0
    self.stopIndex = nil
    self.index = self.index or 0
    self.Highlight:Show()
    self:OnTimer()
    self:RefreshButton()
end

function ActivitiesLottery:Stop(id)
    local index
    local start = random(1, self.count)
    local i = start
    repeat
        i = i % self.count + 1
        if self.lotteryList[i].id == id then
            index = i
            break
        end
    until i == start

    self.stopIndex = index or self.stopIndex
    self.slowIndex = (self.stopIndex - (MAX_SPEED - MIN_SPEED) - 2) % self.count + 1
end

function ActivitiesLottery:Lottery()
    if Activities:GetScore() < self.lotteryPrice then
        System:Error(L['活动点数不足，抽奖失败。'])
        System:Log(L['活动点数不足，抽奖失败。'])
    else
        GUI:CallMessageDialog(
            format(L['确认消耗 |cff00ff00%d|r 活动点数抽奖吗？'], self.lotteryPrice),
            function(result)
                if result then
                    Activities:Lottery()
                end
            end)
    end
end

function ActivitiesLottery:OnStop()
    self.started = nil
    if self.success and self.item ~= 0 then
        PlayerInfoDialog:Open(self.msg, L['中奖啦！'], L.ActivitiesLotteryWaring, true)
    else
        System:Message(self.msg)
    end
    System:Log(self.msg)
    self:RefreshButton()
end