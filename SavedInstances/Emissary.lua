local addonName, addon = ...
local EmissaryModule = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("Emissary", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
local L = addon.L
local thisToon = UnitName("player") .. " - " .. GetRealmName()

local Emissaries = {
  [6] = {
    UiMapID = 627,
    questID = 43341,
  },
  [7] = {
    UiMapID = 876,
    questID = 51722,
  },
}
addon.Emissaries = Emissaries

-- [Alliance] = Horde
local _switching = {
  [50605] = 50606, -- Alliance War Effort / Horde War Effort
  [50601] = 50602, -- Storm's Wake / Talanji's Expedition
  [50599] = 50598, -- Proudmoore Admiralty / Zandalari Empire
  [50600] = 50603, -- Order of Embers / Voldunai
}

-- Switching Table
-- [questID] = { ["Alliance"] = questID, ["Horde"] = questID }
local switching, k, v = {}
for k, v in pairs(_switching) do
  local tbl = {
    Alliance = k,
    Horde = v,
  }
  switching[k] = tbl
  switching[v] = tbl
end

function EmissaryModule:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("ADDON_LOADED", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("QUEST_LOG_UPDATE", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "RefreshDailyWorldQuestInfo")
end

function EmissaryModule:RefreshDailyWorldQuestInfo()
  local t = addon.db.Toons[thisToon]
  t.Emissary = {}
  local expansionLevel, tbl
  for expansionLevel, tbl in pairs(Emissaries) do
    if not addon.db.Emissary.Expansion[expansionLevel] then addon.db.Emissary.Expansion[expansionLevel] = {} end
    local currExpansion = addon.db.Emissary.Expansion[expansionLevel]
    t.Emissary[expansionLevel] = {}
    if IsQuestFlaggedCompleted(tbl.questID) then
      t.Emissary[expansionLevel] = {
        unlocked = true,
        days = {},
      }
      local BountyQuest, BountyIndex, BountyInfo = GetQuestBountyInfoForMapID(tbl.UiMapID)
      for BountyIndex, BountyInfo in ipairs(BountyQuest) do
        local title = GetQuestLogTitle(GetQuestLogIndexByID(BountyInfo.questID))
        local timeleft = C_TaskQuest.GetQuestTimeLeftMinutes(BountyInfo.questID)
        local _, _, isFinish, questDone, questNeed = GetQuestObjectiveInfo(BountyInfo.questID, 1, false)
        addon.db.Emissary.Cache[BountyInfo.questID] = title -- cache quest name
        if timeleft then
          local day = tonumber(math.floor(timeleft / 1440) + 1) -- [1, 2, 3]
          addon.debug("title: %s, timeleft: %s, days: +%s", title, timeleft, day)
          if not currExpansion[day] then currExpansion[day] = {} end
          if switching[BountyInfo.questID] then
            currExpansion[day].questID = switching[BountyInfo.questID]
          else
            currExpansion[day].questID = {
              Alliance = BountyInfo.questID,
              Horde = BountyInfo.questID,
            }
          end
          currExpansion[day].questNeed = questNeed
          currExpansion[day].expiredTime = timeleft * 60 + time()
          t.Emissary[expansionLevel].days[day] = {
            isComplete = false,
            isFinish = isFinish,
            questDone = questDone,
          }
        end
      end
      local i
      for i = 1, 3 do
        if not t.Emissary[expansionLevel].days[i] then
          t.Emissary[expansionLevel].days[i] = {
            isComplete = true,
          }
        end
      end
    end
  end
end
