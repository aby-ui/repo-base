local SI, L = unpack(select(2, ...))
local Module = SI:NewModule('Calling', 'AceEvent-3.0')

-- Lua functions
local floor, ipairs, pairs, time, tonumber, wipe = floor, ipairs, pairs, time, tonumber, wipe

-- WoW API / Variables
local C_CovenantCallings_AreCallingsUnlocked = C_CovenantCallings.AreCallingsUnlocked
local C_CovenantCallings_RequestCallings = C_CovenantCallings.RequestCallings
local C_QuestLog_GetTitleForQuestID = C_QuestLog.GetTitleForQuestID
local C_QuestLog_IsOnQuest = C_QuestLog.IsOnQuest
local C_TaskQuest_GetQuestTimeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes
local GetNumQuestLogRewards = GetNumQuestLogRewards
local GetQuestLogRewardInfo = GetQuestLogRewardInfo
local GetQuestObjectiveInfo = GetQuestObjectiveInfo
local GetQuestProgressBarPercent = GetQuestProgressBarPercent

function Module:PostRefresh()
  if self.initialized then
    if not SI.logout then
      C_CovenantCallings_RequestCallings()
    end
    return
  end

  self:RegisterEvent("COVENANT_CALLINGS_UPDATED")

  self.initialized = true
end

function Module:COVENANT_CALLINGS_UPDATED(_, callings)
  local t = SI.db.Toons[SI.thisToon]
  if not t.Calling then t.Calling = {} end

  if SI.playerLevel < 60 or not C_CovenantCallings_AreCallingsUnlocked() then
    t.Calling.unlocked = nil
    return
  end
  t.Calling.unlocked = true

  -- set all slot completed and set expiredTime
  local nextReset = SI:GetNextDailyResetTime()
  for i = 1, 3 do
    if not t.Calling[i] then t.Calling[i] = {} end
    t.Calling[i].isCompleted = true
    t.Calling[i].expiredTime = nextReset + (i - 1) * 24 * 60 * 60
  end

  for _, data in ipairs(callings) do
      local timeLeft = C_TaskQuest_GetQuestTimeLeftMinutes(data.questID)
      local day = tonumber(floor((timeLeft or 0) / 1440) + 1) -- [1, 2, 3]
      if not timeLeft or not day or not t.Calling[day] then
        C_CovenantCallings_RequestCallings()
        return
      end

      local isOnQuest = C_QuestLog_IsOnQuest(data.questID)
      local title = C_QuestLog_GetTitleForQuestID(data.questID)

      t.Calling[day].isCompleted = false
      t.Calling[day].isOnQuest = isOnQuest
      t.Calling[day].questID = data.questID
      t.Calling[day].title = title

      if isOnQuest then
        local text, objectiveType, isFinished, questDone, questNeed = GetQuestObjectiveInfo(data.questID, 1, false)
        if objectiveType == 'progressbar' then
          questDone = GetQuestProgressBarPercent(data.questID)
          questNeed = 100
        end
        t.Calling[day].text = text
        t.Calling[day].objectiveType = objectiveType
        t.Calling[day].isFinished = isFinished
        t.Calling[day].questDone = questDone
        t.Calling[day].questNeed = questNeed

        local numQuestRewards = GetNumQuestLogRewards(data.questID)
        if numQuestRewards > 0 then
          local itemName, _, _, quality = GetQuestLogRewardInfo(1, data.questID)
          if itemName then
            t.Calling[day].questReward = t.Calling[day].questReward and wipe(t.Calling[day].questReward) or {}
            t.Calling[day].questReward.itemName = itemName
            t.Calling[day].questReward.quality = quality
          end
        end
      end
  end
end

function Module:OnDailyReset()
  local now = time()
  for _, ti in pairs(SI.db.Toons) do
    if ti.Calling and ti.Calling.unlocked then
      while ti.Calling[1] and ti.Calling[1].expiredTime < now do
          ti.Calling[1] = ti.Calling[2]
          ti.Calling[2] = ti.Calling[3]
          ti.Calling[3] = {
            isCompleted = false,
            isOnQuest = false,
            expiredTime = ti.Calling[2].expiredTime + 24 * 60 * 60,
          }
      end
    end
  end
end
