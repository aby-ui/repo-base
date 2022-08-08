-- QuestGroup.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 4/21/2021, 2:42:28 PM
--
BuildEnv(...)

if not ADDON_REGIONSUPPORT then
    return
end

---@class QuestGroup: ProtoBase
---@field id number
---@field quests Quest[]
---@field questMap table<number, Quest>
---@field private startTime number
---@field private endTime number
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

---@generic T
---@param self T
---@param data any[]
---@return T
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

function QuestGroup:Fill(d)
    if not d then
        return
    end
    for _, v in ipairs(d) do
        table.insert(self.quests, Quest:FromProto(v))
    end
end
