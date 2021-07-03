-- QuestPanel2.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/20/2021, 2:13:13 PM
--
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

local Frame = CreateFrame('Frame', nil, nil, 'MeetingStoneQuestPanelTemplate2')

---@class QuestPanel2: AceAddon,AceEvent,Frame
QuestPanel2 = Addon:NewModule(Frame, 'QuestPanel2', 'AceEvent-3.0')

function QuestPanel2:OnInitialize()
    ApplyUrlButton(self.Body.Join, 'https://wow.blizzard.cn/esports')
    ApplyUrlButton(self.Body.Ranking, 'https://wow.blizzard.cn/rank')

    self.Quests = GUI:GetClass('ListView'):Bind(self.Body.Quests)
    self.Quests:SetItemClass(QuestItem)
    self.Quests:SetItemHeight(55)
    self.Quests:SetCallback('OnItemFormatted', function(_, button, item)
        button:SetData(item)
    end)
    self.Quests:SetItemList{
        {
            item = 19054,
            text = '限时通关3次18层及以上史诗钥石地下城，在活动结束时在排行榜中排名前1000名即可获得“红色小神龙（宠物）”一只',
        }, {
            item = 37297,
            text = '限时通关3次20层及以上史诗钥石地下城，并在活动结束时在排行榜中排名前8名即可获得获得“竞争之魂（宠物）”一只',
        },
    }

    self.Summary.Text:SetText([[1. 玩家需要组队并报名才可参与“队伍地下城挑战”；
2. 玩家使用游戏内符合等级要求的钥石即可参与挑战；
3. 玩家可在符合层等级件的任意地下城中完成挑战，地图不限，但仅选取3张表现最佳的不同地图作为评分依据；
4. 完成更高等级的挑战会累计较低等级的任务进度；
5. 除限时通关特定数量的地下城以外，队伍还必须在活动结束时，在“赛事排行榜”中达到特定名次才能够领取奖励。
6. 本次活动“队伍地下城挑战”奖励将在活动结束后统一发放至获得奖励的玩家角色邮箱；
7. 活动到期后，通关记录将不再被计入本次活动，排行榜将根据玩家在活动期间的通关情况进行排名；本次挑战的积分算法由Raider.IO倾情提供。
8. 同一种虚拟物品奖励，每个战网账号仅可领取一次，每支获得有效排名的队伍中的角色各获得1份奖励，排名前8的队伍将同时获得“红色小神龙”及“竞争之魂”奖励；
9. 若在活动结束后的15个工作日内奖励未发送至获得有效排名的游戏角色邮箱，请联系人工客服进行反馈；
10. 本次挑战活动由于数量较大，当您完成通关后，若发现排行榜在72小时后仍未能正确显示您的排名，请联系人工客服进行反馈。]])

    self:SetScript('OnShow', self.OnShow)
end

function QuestPanel2:OnShow()
    local questGroup = QuestServies.questGroup
    self.Body.Time:SetFormattedText('活动时间：%s - %s', date('%Y/%m/%d %H:%M', questGroup.startTime),
                                    date('%Y/%m/%d %H:%M', questGroup.endTime))
end
