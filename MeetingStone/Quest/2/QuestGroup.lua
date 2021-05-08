-- QuestGroup.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/21/2021, 2:42:28 PM
--
BuildEnv(...)







QuestGroup = Addon:NewClass('QuestGroup', ProtoBase)

QuestGroup.PROTO = {'id', 'startTime', 'endTime', '_quests'}

local QUESTS_INDEX = tIndexOf(QuestGroup.PROTO, '_quests')

function QuestGroup:Constructor()
    self.quests = {}
    self.questMap = {}
end

function QuestGroup:GetQuest(id)
    return self.questMap[id]
end





function QuestGroup:FromProto(data)
    local group = QuestGroup:New()
    group:ApplyProto(self.PROTO, data)

    for _, v in ipairs(data[QUESTS_INDEX]) do
        table.insert(group.quests, Quest:FromProto(v))
    end

    for _, quest in ipairs(group.quests) do
        group.questMap[quest.id] = quest
    end
    return group
end
