local addonName, addon = ...
local EmissaryModule = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("Emissary", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
local L = addon.L
local thisToon = UnitName("player") .. " - " .. GetRealmName()

function EmissaryModule:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("ADDON_LOADED", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("QUEST_LOG_UPDATE", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "RefreshDailyWorldQuestInfo")
end

function EmissaryModule:RefreshDailyWorldQuestInfo()
  local t = addon.db.Toons[thisToon]
  t.DailyWorldQuest = {}
  local BountyQuest = GetQuestBountyInfoForMapID(876)
  for BountyIndex, BountyInfo in ipairs(BountyQuest) do
    local title = GetQuestLogTitle(GetQuestLogIndexByID(BountyInfo.questID))
    local timeleft = C_TaskQuest.GetQuestTimeLeftMinutes(BountyInfo.questID)
    local _, _, isFinish, questDone, questNeed = GetQuestObjectiveInfo(BountyInfo.questID, 1, false)
    if timeleft then
      if timeleft > 2880 then
        if t.DailyWorldQuest.days2 then else t.DailyWorldQuest.days2 = {} end
        t.DailyWorldQuest.days2.name = title
        t.DailyWorldQuest.days2.dayleft = 2
        t.DailyWorldQuest.days2.questneed = questNeed
        t.DailyWorldQuest.days2.questdone = questDone
        t.DailyWorldQuest.days2.isfinish = isFinish
        t.DailyWorldQuest.days2.iscompleted = IsQuestFlaggedCompleted(BountyInfo.questID)
      elseif timeleft > 1440 then
        if t.DailyWorldQuest.days1 then else t.DailyWorldQuest.days1 = {} end
        t.DailyWorldQuest.days1.name = title
        t.DailyWorldQuest.days1.dayleft = 1
        t.DailyWorldQuest.days1.questneed = questNeed
        t.DailyWorldQuest.days1.questdone = questDone
        t.DailyWorldQuest.days1.isfinish = isFinish
        t.DailyWorldQuest.days1.iscompleted = IsQuestFlaggedCompleted(BountyInfo.questID)
      else
        if t.DailyWorldQuest.days0 then else t.DailyWorldQuest.days0 = {} end
        t.DailyWorldQuest.days0.name = title
        t.DailyWorldQuest.days0.dayleft = 0
        t.DailyWorldQuest.days0.questneed = questNeed
        t.DailyWorldQuest.days0.questdone = questDone
        t.DailyWorldQuest.days0.isfinish = isFinish
        t.DailyWorldQuest.days0.iscompleted = IsQuestFlaggedCompleted(BountyInfo.questID)
      end
    end
  end
  if IsQuestFlaggedCompleted(51918) or IsQuestFlaggedCompleted(51916) then -- Uniting Kul Tiras & Uniting Zandalar
    if t.DailyWorldQuest.days0 == nil then
      t.DailyWorldQuest.days0 = {}
      t.DailyWorldQuest.days0.dayleft = 0
      t.DailyWorldQuest.days0.iscompleted = true
      t.DailyWorldQuest.days0.name = L["Emissary Missing"]
    end
    if t.DailyWorldQuest.days1 == nil then
      t.DailyWorldQuest.days1 = {}
      t.DailyWorldQuest.days1.dayleft = 1
      t.DailyWorldQuest.days1.iscompleted = true
      t.DailyWorldQuest.days1.name = L["Emissary Missing"]
    end
    if t.DailyWorldQuest.days2 == nil then
      t.DailyWorldQuest.days2 = {}
      t.DailyWorldQuest.days2.dayleft = 2
      t.DailyWorldQuest.days2.iscompleted = true
      t.DailyWorldQuest.days2.name = L["Emissary Missing"]
    end
  end
end
