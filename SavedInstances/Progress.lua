local _, addon = ...
local P = addon.core:NewModule("Progress", "AceEvent-3.0")
local L = addon.L
local thisToon = UnitName("player") .. " - " .. GetRealmName()

-- Lua functions
local _G = _G
local ipairs, type, tostring, wipe = ipairs, type, tostring, wipe

-- WoW API / Variables
local C_PvP_GetWeeklyChestInfo = C_PvP.GetWeeklyChestInfo
local C_QuestLog_IsOnQuest = C_QuestLog.IsOnQuest
local C_TaskQuest_IsActive = C_TaskQuest.IsActive
local GetQuestObjectiveInfo = GetQuestObjectiveInfo
local IsQuestFlaggedCompleted = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted or IsQuestFlaggedCompleted
local QuestUtils_GetCurrentQuestLineQuest = QuestUtils_GetCurrentQuestLineQuest
local UnitLevel = UnitLevel

local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE
local NORMAL_FONT_COLOR_CODE = NORMAL_FONT_COLOR_CODE
local READY_CHECK_READY_TEXTURE = READY_CHECK_READY_TEXTURE
local READY_CHECK_WAITING_TEXTURE = READY_CHECK_WAITING_TEXTURE

local CONQUEST_QUESTLINE_ID = 782
local maxLvl = MAX_PLAYER_LEVEL_TABLE[#MAX_PLAYER_LEVEL_TABLE]

-- GLOBAL

local function KeepProgress(toon, index)
  local t = addon.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end
  local prev = t.Progress[index]
  t.Progress[index] = {
    unlocked = prev.unlocked,
    isComplete = false,
    isFinish = false,
    numFulfilled = prev.isComplete and 0 or prev.numFulfilled,
    numRequired = prev.numRequired,
    rewardWaiting = prev.rewardAchieved, -- nil for non-Conquest
  }
end

-- PvP Conquest (index 1)

local function ConquestUpdate(index)
  local data
  if UnitLevel("player") >= maxLvl then
    local currentQuestID = QuestUtils_GetCurrentQuestLineQuest(CONQUEST_QUESTLINE_ID)
    local rewardAchieved, lastWeekRewardAchieved, lastWeekRewardClaimed = C_PvP_GetWeeklyChestInfo()
    local rewardWaiting = lastWeekRewardAchieved and not lastWeekRewardClaimed
    if currentQuestID == 0 then
      data = {
        unlocked = true,
        isComplete = true,
        isFinish = true,
        numFulfilled = 500,
        numRequired = 500,
        rewardAchieved = rewardAchieved,
        rewardWaiting = rewardWaiting,
      }
    else
      local text, _, finished, numFulfilled, numRequired = GetQuestObjectiveInfo(currentQuestID, 1, false)
      if text then
        data = {
          unlocked = true,
          isComplete = false,
          isFinish = finished,
          numFulfilled = numFulfilled,
          numRequired = numRequired,
          rewardAchieved = rewardAchieved,
          rewardWaiting = rewardWaiting,
        }
      end
    end
  else
    data = {
      unlocked = false,
      isComplete = false,
      isFinish = false,
      numFulfilled = 500,
      numRequired = 500,
      rewardAchieved = false,
      rewardWaiting = false,
    }
  end
  addon.db.Toons[thisToon].Progress[index] = data
end

local function ConquestShow(toon, index)
  local t = addon.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end
  local data = t.Progress[index]
  local text
  if not data.unlocked then
    text = ""
  elseif data.isComplete then
    text = "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
  elseif data.isFinish then
    text = "\124T" .. READY_CHECK_WAITING_TEXTURE .. ":0|t"
  else
    text = data.numFulfilled .. "/" .. data.numRequired
  end
  if data.rewardWaiting then
    text = text .. "(\124T" .. READY_CHECK_WAITING_TEXTURE .. ":0|t)"
  elseif data.rewardAchieved then
    text = text .. "(\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t)"
  end
  return text
end

-- Horrific Vision (index 3)

local function HorrificVisionUpdate(index)
  addon.db.Toons[thisToon].Progress[index] = wipe(addon.db.Toons[thisToon].Progress[index] or {})
  for i, questID in ipairs(P.TrackedQuest[index].rewardQuestID) do
    addon.db.Toons[thisToon].Progress[index][i] = IsQuestFlaggedCompleted(questID)
  end
  addon.db.Toons[thisToon].Progress[index].unlocked = IsQuestFlaggedCompleted(58634) -- Opening the Gateway
end

local function HorrificVisionShow(toon, index)
  local t = addon.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end

  if t.Progress[index].unlocked then
    local text = "-"
    for i, descText in ipairs(P.TrackedQuest[index].rewardDesc) do
      if t.Progress[index][i] then
        text = descText[1]
      end
    end
    return text
  end
end

local function HorrificVisionReset(toon, index)
  local t = addon.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end

  local unlocked = t.Progress[index].unlocked
  wipe(t.Progress[index])
  t.Progress[index].unlocked = unlocked
end

-- N'Zoth Assaults (index 4)

local function NZothAssaultUpdate(index)
  addon.db.Toons[thisToon].Progress[index] = wipe(addon.db.Toons[thisToon].Progress[index] or {})
  for _, questID in ipairs(P.TrackedQuest[index].relatedQuest) do
    addon.db.Toons[thisToon].Progress[index][questID] = C_TaskQuest_IsActive(questID)
  end
  addon.db.Toons[thisToon].Progress[index].unlocked = IsQuestFlaggedCompleted(57362) -- Deeper Into the Darkness
end

local function NZothAssaultShow(toon, index)
  local t = addon.db.Toons[toon]
  if not t or not t.Quests then return end
  if not t or not t.Progress or not t.Progress[index] then return end

  if t.Progress[index].unlocked then
    local count = 0
    for _, questID in ipairs(P.TrackedQuest[index].relatedQuest) do
      if t.Quests[questID] then
        count = count + 1
      end
    end
    return count == 0 and "" or tostring(count)
  end
end

local function NZothAssaultReset(toon, index)
  local t = addon.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end

  local unlocked = t.Progress[index].unlocked
  wipe(t.Progress[index])
  t.Progress[index].unlocked = unlocked
end

-- Lesser Visions of N'Zoth (index 5)

local function LesserVisionUpdate(index)
  -- do nothing
end

local function LesserVisionShow(toon, index)
  local t = addon.db.Toons[toon]
  if not t or not t.Quests then return end

  for _, questID in ipairs(P.TrackedQuest[index].relatedQuest) do
    if t.Quests[questID] then
      return "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
    end
  end
end

local function LesserVisionReset(toon, index)
  -- do nothing
end

P.TrackedQuest = {
  -- Conquest
  {
    name = PVP_CONQUEST,
    func = ConquestUpdate,
    weekly = true,
    resetFunc = KeepProgress,
    showFunc = ConquestShow,
  },
  -- Island Expedition
  {
    name = ISLANDS_HEADER,
    quest = {
      ["Alliance"] = 53436,
      ["Horde"]    = 53435,
    },
    weekly = true,
    resetFunc = KeepProgress,
    relatedQuest = {53435, 53436},
  },
  -- Horrific Vision
  {
    name = SPLASH_BATTLEFORAZEROTH_8_3_0_FEATURE1_TITLE,
    weekly = true,
    func = HorrificVisionUpdate,
    showFunc = HorrificVisionShow,
    resetFunc = HorrificVisionReset,
    tooltipKey = 'ShowHorrificVisionTooltip',
    -- addition info
    rewardQuestID = {
      57841,
      57845,
      57842,
      57846,
      57843,
      57847,
      57844,
      57848,
    },
    rewardDesc = {
      {"1 + 0", L["Vision Boss Only"]},
      {"3 + 0", L["Vision Boss + 2 Bonus Objectives"]},
      {"5 + 0", L["Full Clear No Masks"]},
      {"5 + 1", L["Full Clear + 1 Mask"]},
      {"5 + 2", L["Full Clear + 2 Masks"]},
      {"5 + 3", L["Full Clear + 3 Masks"]},
      {"5 + 4", L["Full Clear + 4 Masks"]},
      {"5 + 5", L["Full Clear + 5 Masks"]},
    },
  },
  -- N'Zoth Assaults
  {
    name = WORLD_MAP_THREATS,
    weekly = true,
    func = NZothAssaultUpdate,
    showFunc = NZothAssaultShow,
    resetFunc = NZothAssaultReset,
    tooltipKey = 'ShowNZothAssaultTooltip',
    relatedQuest = {
      -- Uldum
      57157, -- Assault: The Black Empire
      55350, -- Assault: Amathet Advance
      56308, -- Assault: Aqir Unearthed
      -- Vale of Eternal Blossoms
      56064, -- Assault: The Black Empire
      57008, -- Assault: The Warring Clans
      57728, -- Assault: The Endless Swarm
    },
    -- addition info
    assaultQuest = {
      [57157] = { -- The Black Empire in Uldum
        57008, -- Assault: The Warring Clans
        57728, -- Assault: The Endless Swarm
      },
      [56064] = { -- The Black Empire in Vale of Eternal Blossoms
        55350, -- Assault: Amathet Advance
        56308, -- Assault: Aqir Unearthed
      },
    },
  },
  -- Lesser Visions of N'Zoth
  {
    name = L["Lesser Visions of N'Zoth"],
    func = LesserVisionUpdate,
    showFunc = LesserVisionShow,
    resetFunc = LesserVisionReset,
    relatedQuest = {
      58151, -- Minions of N'Zoth
      58155, -- A Hand in the Dark
      58156, -- Vanquishing the Darkness
      58167, -- Preventative Measures
      58168, -- A Dark, Glaring Reality
    },
  },
}

function P:OnEnable()
  self:QUEST_LOG_UPDATE()
  self:RegisterEvent("QUEST_LOG_UPDATE")
end

function P:QUEST_LOG_UPDATE()
  local t = addon.db.Toons[thisToon]
  if not t.Progress then t.Progress = {} end
  for i, tbl in ipairs(self.TrackedQuest) do
    if tbl.func then
      tbl.func(i)
    elseif tbl.quest then
      local questID = tbl.quest
      if type(questID) ~= "number" then
        questID = questID[t.Faction]
      end
      if questID then
        -- no questID on Neutral Pandaren or first login
        local result = {}
        local _, _, finished, numFulfilled, numRequired = GetQuestObjectiveInfo(questID, 1, false)
        result.isFinish = finished
        result.numFulfilled = numFulfilled
        result.numRequired = numRequired
        if IsQuestFlaggedCompleted(questID) then
          result.unlocked = true
          result.isComplete = true
        else
          local isOnQuest = C_QuestLog_IsOnQuest(questID)
          result.unlocked = isOnQuest
          result.isComplete = false
        end
        t.Progress[i] = result
      end
    end
  end
end

function P:OnDailyReset(toon)
  local t = addon.db.Toons[toon]
  if not t or not t.Progress then return end
  for i, tbl in ipairs(self.TrackedQuest) do
    if tbl.daily then
      if tbl.resetFunc then
        tbl.resetFunc(toon, i)
      else
        local prev = t.Progress[i]
        t.Progress[i] = {
          unlocked = prev.unlocked,
          isComplete = false,
          isFinish = false,
          numFulfilled = 0,
          numRequired = prev.numRequired,
        }
      end
    end
  end
end

function P:OnWeeklyReset(toon)
  local t = addon.db.Toons[toon]
  if not t or not t.Progress then return end
  for i, tbl in ipairs(self.TrackedQuest) do
    if tbl.weekly then
      if tbl.resetFunc then
        tbl.resetFunc(toon, i)
      else
        local prev = t.Progress[i]
        t.Progress[i] = {
          unlocked = prev.unlocked,
          isComplete = false,
          isFinish = false,
          numFulfilled = 0,
          numRequired = prev.numRequired,
        }
      end
    end
  end
end

function P:BuildOptions(order)
  local option = {}
  for index, tbl in ipairs(self.TrackedQuest) do
    option["Progress" .. index] = {
      type = "toggle",
      order = order + index * 0.01,
      name = tbl.name,
    }
  end
  return option
end

function P:QuestEnabled(questID)
  if not self.questMap then
    self.questMap = {}
    for index, tbl in ipairs(self.TrackedQuest) do
      if tbl.relatedQuest then
        for _, quest in ipairs(tbl.relatedQuest) do
          self.questMap[quest] = index
        end
      end
    end
  end
  if self.questMap[questID] then
    return addon.db.Tooltip["Progress" .. self.questMap[questID]]
  end
end

-- Use addon global function in future
local function CloseTooltips()
  _G.GameTooltip:Hide()
  if addon.indicatortip then
    addon.indicatortip:Hide()
  end
end

function P:ShowTooltip(tooltip, columns, showall, preshow)
  local cpairs = addon.cpairs
  local first = true
  for index, tbl in ipairs(self.TrackedQuest) do
    if addon.db.Tooltip["Progress" .. index] or showall then
      local show
      for toon, t in cpairs(addon.db.Toons, true) do
        if (
          (t.Progress and t.Progress[index] and t.Progress[index].unlocked) or
          (tbl.showFunc and tbl.showFunc(toon, index))
        ) then
          show = true
          break
        end
      end
      if show then
        if first == true then
          preshow()
          first = false
        end
        local line = tooltip:AddLine(NORMAL_FONT_COLOR_CODE .. tbl.name .. FONT_COLOR_CODE_CLOSE)
        for toon, t in cpairs(addon.db.Toons, true) do
          local value = t.Progress and t.Progress[index]
          local text
          if tbl.showFunc then
            text = tbl.showFunc(toon, index)
          elseif value then
            if not value.unlocked then
              -- do nothing
            elseif value.isComplete then
              text = "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
            elseif value.isFinish then
              text = "\124T" .. READY_CHECK_WAITING_TEXTURE .. ":0|t"
            else
              -- Note: no idea why .numRequired is nil rarely (#325)
              -- protect this now to stop lua error
              text = (value.numFulfilled or "?") .. "/" .. (value.numRequired or "?")
            end
          end
          local col = columns[toon .. 1]
          if col and text then
            -- check if current toon is showing
            -- don't add columns
            -- showFunc may return nil, or tbl.unlocked is nil, don't :SetCell and :SetCellScript in this case
            tooltip:SetCell(line, col, text, "CENTER", 4)
            if tbl.tooltipKey then
              tooltip:SetCellScript(line, col, "OnEnter", addon.hoverTooltip[tbl.tooltipKey], {toon, index})
              tooltip:SetCellScript(line, col, "OnLeave", CloseTooltips)
            end
          end
        end
      end
    end
  end
end
