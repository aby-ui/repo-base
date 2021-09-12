-- QuestPanel2.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/20/2021, 2:13:13 PM
--
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

local Frame = CreateFrame('Frame', nil, nil, 'MeetingStoneGoldLeaderPanelTemplate')

---@class QuestPanel2: AceAddon,AceEvent,Frame
QuestPanel3 = Addon:NewModule(Frame, 'QuestPanel3', 'AceEvent-3.0')

function QuestPanel3:OnInitialize()
    local signUpButton = Addon:GetClass('Button'):New(self.Body)
    do
        signUpButton:SetText(L['我要报名'])
        signUpButton:SetIcon(132940)
        signUpButton:SetPoint('BOTTOMLEFT', self.Body.RefreshBtn, 'TOPLEFT', 0, 20)
    end

    self.Summary.Text:SetText(
        [[1. 玩家点击上方“我要报名”跳转活动专题报名页，报名成功且完成史诗钥石后可随时点击上方“刷新”按钮来查看自己目前的积分情况
2. 玩家需要通过集合石进行组队通关15层（包括15层）以上难度的史诗钥石地下城；超时完成整个史诗钥石副本活动也将被计算
3. 积分获取：玩家只能通过新队友获取一次积分，不可重复；队伍中有1名新队友可获得1分，有4名新队友可获得4分
4. 玩家报名成功后以角色为单位，报名一旦成功，使用种族变更、阵营转换、角色转移、角色更名等服务，将会影响您的积分结算
5. 活动奖励：本期总排名前100的玩家将获得“金牌导师”专属图标以及对应奖励
    第1名：魔兽世界希尔瓦娜斯雕像*1，888战网点
    第2名：魔兽世界巫妖王统御头盔*1，588战网点
    第3名：魔兽世界巫妖王统御头盔*1，388战网点
    第4-10名：魔兽世界巫妖王统御头盔*1，198战网点
    第11-50名：魔兽世界季卡*1
    第51-100名：魔兽世界月卡*1
6. 活动截止后（10月7日7：00），通关记录将不再被计入本次活动，排行榜将根据玩家在点击报名活动后的积分情况进行排名（如积分相同，则根据获得该积分的时间先后判定）
7. 活动奖励将在结算后45个工作日内安排发出（请仔细认真填写报名时的个人联系方式，届时会有相关工作人员与您取得联系）
8. 本次活动数据量较大，当您完成通关后即可查询您的积分情况，如有问题耐心等待。发现积分在24小时后仍未刷新，请联系人工客服进行反馈]])

    ApplyUrlButton(self.Body.Ranking, 'https://wow.blizzard.cn/rank ')
    ApplyUrlButton(signUpButton, 'https://wow.blizzard.cn/mentor')
    do
        local RefreshBtn = self.Body.RefreshBtn
        CountdownButton:Bind(RefreshBtn)
        RefreshBtn:SetScript('OnClick', function(button)
            QuestServies:QueryScore()
            RefreshBtn:SetCountdown(5)
        end)
    end

    self:SetScript('OnShow', self.OnShow)
    self:RegisterMessage('MEETINGSTONE_UPDATE_SCORE')
end

function QuestPanel3:OnShow()
    local questGroup = QuestServies.questGroup
    self.Body.Time:SetFormattedText('活动时间：%s - %s', date('%Y/%m/%d %H:%M', questGroup.startTime),
                                    date('%Y/%m/%d %H:%M', questGroup.endTime))
end

function QuestPanel3:MEETINGSTONE_UPDATE_SCORE(name, score)
    self.Body.ScoreLabel:SetFormattedText('目前积分：%s分', score)
end
