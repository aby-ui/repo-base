local SI, L = unpack(select(2, ...))
local Module = SI:NewModule('Progress', 'AceEvent-3.0')

-- Lua functions
local _G = _G
local floor, ipairs, strmatch, type, tostring, wipe = floor, ipairs, strmatch, type, tostring, wipe

-- WoW API / Variables
local C_QuestLog_IsOnQuest = C_QuestLog.IsOnQuest
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local C_TaskQuest_IsActive = C_TaskQuest.IsActive
local C_UIWidgetManager_GetTextWithStateWidgetVisualizationInfo = C_UIWidgetManager.GetTextWithStateWidgetVisualizationInfo
local C_WeeklyRewards_CanClaimRewards = C_WeeklyRewards.CanClaimRewards
local C_WeeklyRewards_GetConquestWeeklyProgress = C_WeeklyRewards.GetConquestWeeklyProgress
local C_WeeklyRewards_HasAvailableRewards = C_WeeklyRewards.HasAvailableRewards
local GetQuestObjectiveInfo = GetQuestObjectiveInfo
local GetQuestProgressBarPercent = GetQuestProgressBarPercent
local UnitLevel = UnitLevel

local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE
local NORMAL_FONT_COLOR_CODE = NORMAL_FONT_COLOR_CODE
local READY_CHECK_READY_TEXTURE = READY_CHECK_READY_TEXTURE
local READY_CHECK_WAITING_TEXTURE = READY_CHECK_WAITING_TEXTURE

local function KeepProgress(toon, index)
  local t = SI.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end
  local prev = t.Progress[index]
  t.Progress[index] = {
    unlocked = prev.unlocked,
    isComplete = false,
    isFinish = prev.isFinish and not prev.isComplete,
    objectiveType = prev.objectiveType,
    numFulfilled = prev.isComplete and 0 or prev.numFulfilled,
    numRequired = prev.numRequired,
  }
end

-- PvP Conquest (index 1)

local function ConquestUpdate(index)
  local data
  if UnitLevel("player") >= SI.maxLevel then
    local weeklyProgress = C_WeeklyRewards_GetConquestWeeklyProgress()
    if not weeklyProgress then return end

    local rewardWaiting = C_WeeklyRewards_HasAvailableRewards() and C_WeeklyRewards_CanClaimRewards()
    data = {
      unlocked = true,
      isComplete = weeklyProgress.progress >= weeklyProgress.maxProgress,
      isFinish = false,
      numFulfilled = weeklyProgress.progress,
      numRequired = weeklyProgress.maxProgress,
      unlocksCompleted = weeklyProgress.unlocksCompleted,
      maxUnlocks = weeklyProgress.maxUnlocks,
      rewardWaiting = rewardWaiting,
    }
  else
    data = {
      unlocked = false,
      isComplete = false,
      isFinish = false,
    }
  end
  SI.db.Toons[SI.thisToon].Progress[index] = data
end

local function ConquestShow(toon, index)
  local t = SI.db.Toons[toon]
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
  if data.unlocksCompleted and data.maxUnlocks then
    text = text .. "(" .. data.unlocksCompleted .. "/" .. data.maxUnlocks .. ")"
  end
  if data.rewardWaiting then
    text = text .. "(\124T" .. READY_CHECK_WAITING_TEXTURE .. ":0|t)"
  end
  return text
end

local function ConquestReset(toon, index)
  local t = SI.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end

  local prev = t.Progress[index]
  t.Progress[index] = {
    unlocked = prev.unlocked,
    isComplete = false,
    isFinish = false,
    numFulfilled = 0,
    numRequired = prev.numRequired,
    unlocksCompleted = 0,
    maxUnlocks = prev.maxUnlocks,
    rewardWaiting = prev.unlocksCompleted and prev.unlocksCompleted > 0,
  }
end

-- Horrific Vision (index 3)

local function HorrificVisionUpdate(index)
  SI.db.Toons[SI.thisToon].Progress[index] = wipe(SI.db.Toons[SI.thisToon].Progress[index] or {})
  for i, questID in ipairs(Module.TrackedQuest[index].rewardQuestID) do
    SI.db.Toons[SI.thisToon].Progress[index][i] = C_QuestLog_IsQuestFlaggedCompleted(questID)
  end
  SI.db.Toons[SI.thisToon].Progress[index].unlocked = C_QuestLog_IsQuestFlaggedCompleted(58634) -- Opening the Gateway
end

local function HorrificVisionShow(toon, index)
  local t = SI.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end

  if t.Progress[index].unlocked then
    local text = "-"
    for i, descText in ipairs(Module.TrackedQuest[index].rewardDesc) do
      if t.Progress[index][i] then
        text = descText[1]
      end
    end
    return text
  end
end

local function HorrificVisionReset(toon, index)
  local t = SI.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end

  local unlocked = t.Progress[index].unlocked
  wipe(t.Progress[index])
  t.Progress[index].unlocked = unlocked
end

-- N'Zoth Assaults (index 4)

local function NZothAssaultUpdate(index)
  SI.db.Toons[SI.thisToon].Progress[index] = wipe(SI.db.Toons[SI.thisToon].Progress[index] or {})
  for _, questID in ipairs(Module.TrackedQuest[index].relatedQuest) do
    SI.db.Toons[SI.thisToon].Progress[index][questID] = C_TaskQuest_IsActive(questID)
  end
  SI.db.Toons[SI.thisToon].Progress[index].unlocked = C_QuestLog_IsQuestFlaggedCompleted(57362) -- Deeper Into the Darkness
end

local function NZothAssaultShow(toon, index)
  local t = SI.db.Toons[toon]
  if not t or not t.Quests then return end
  if not t or not t.Progress or not t.Progress[index] then return end

  if t.Progress[index].unlocked then
    local count = 0
    for _, questID in ipairs(Module.TrackedQuest[index].relatedQuest) do
      if t.Quests[questID] then
        count = count + 1
      end
    end
    return count == 0 and "" or tostring(count)
  end
end

local function NZothAssaultReset(toon, index)
  local t = SI.db.Toons[toon]
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
  local t = SI.db.Toons[toon]
  if not t or not t.Quests then return end

  for _, questID in ipairs(Module.TrackedQuest[index].relatedQuest) do
    if t.Quests[questID] then
      return "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
    end
  end
end

local function LesserVisionReset(toon, index)
  -- do nothing
end

-- Torghast Weekly (index 6)

local function TorghastUpdate(index)
  SI.db.Toons[SI.thisToon].Progress[index] = wipe(SI.db.Toons[SI.thisToon].Progress[index] or {})
  SI.db.Toons[SI.thisToon].Progress[index].unlocked = C_QuestLog_IsQuestFlaggedCompleted(60136) -- Into Torghast

  for i, data in ipairs(Module.TrackedQuest[index].widgetID) do
    local nameInfo = C_UIWidgetManager_GetTextWithStateWidgetVisualizationInfo(data[1])
    local levelInfo = C_UIWidgetManager_GetTextWithStateWidgetVisualizationInfo(data[2])

    if nameInfo and levelInfo then
      local available = nameInfo.shownState == 1
      local levelText = strmatch(levelInfo.text, '|cFF00FF00.-(%d+).+|r')

      SI.db.Toons[SI.thisToon].Progress[index]['Available' .. i] = available
      SI.db.Toons[SI.thisToon].Progress[index]['Level' .. i] = levelText
    end
  end
end

local function TorghastShow(toon, index)
  local t = SI.db.Toons[toon]
  if not t or not t.Quests then return end
  if not t or not t.Progress or not t.Progress[index] then return end

  if t.Progress[index].unlocked then
    local result = ""
    for i in ipairs(Module.TrackedQuest[index].widgetID) do
      if t.Progress[index]['Available' .. i] then
        local first = (#result == 0)
        result = result .. (first and '' or ' / ') .. t.Progress[index]['Level' .. i]
      end
    end
    return result
  end
end

local function TorghastReset(toon, index)
  local t = SI.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end

  local unlocked = t.Progress[index].unlocked
  wipe(t.Progress[index])
  t.Progress[index].unlocked = unlocked
end

-- Covenant Assaults (index 7)

local function CovenantAssaultUpdate(index)
  SI.db.Toons[SI.thisToon].Progress[index] = wipe(SI.db.Toons[SI.thisToon].Progress[index] or {})
  for _, questID in ipairs(Module.TrackedQuest[index].relatedQuest) do
    SI.db.Toons[SI.thisToon].Progress[index][questID] = C_TaskQuest_IsActive(questID)
  end
  SI.db.Toons[SI.thisToon].Progress[index].unlocked = C_QuestLog_IsQuestFlaggedCompleted(64556) -- In Need of Assistance
end

local function CovenantAssaultShow(toon, index)
  local t = SI.db.Toons[toon]
  if not t or not t.Quests then return end
  if not t or not t.Progress or not t.Progress[index] then return end

  if t.Progress[index].unlocked then
    local count = 0
    for _, questID in ipairs(Module.TrackedQuest[index].relatedQuest) do
      if t.Quests[questID] then
        count = count + 1
      end
    end
    return count == 0 and "" or tostring(count)
  end
end

local function CovenantAssaultReset(toon, index)
  local t = SI.db.Toons[toon]
  if not t or not t.Progress or not t.Progress[index] then return end

  local unlocked = t.Progress[index].unlocked
  wipe(t.Progress[index])
  t.Progress[index].unlocked = unlocked
end

Module.TrackedQuest = {
  -- Conquest
  {
    name = PVP_CONQUEST,
    func = ConquestUpdate,
    weekly = true,
    showFunc = ConquestShow,
    resetFunc = ConquestReset,
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
  -- Torghast Weekly
  {
    name = L["Torghast"],
    weekly = true,
    func = TorghastUpdate,
    showFunc = TorghastShow,
    resetFunc = TorghastReset,
    tooltipKey = 'ShowTorghastTooltip',
    widgetID = {
      {2925, 2930}, -- Fracture Chambers
      {2926, 2932}, -- Skoldus Hall
      {2924, 2934}, -- Soulforges
      {2927, 2936}, -- Coldheart Interstitia
      {2928, 2938}, -- Mort'regar
      {2929, 2940}, -- The Upper Reaches
    },
  },
  -- Covenant Assaults
  {
    name = L["Covenant Assaults"],
    weekly = true,
    func = CovenantAssaultUpdate,
    showFunc = CovenantAssaultShow,
    resetFunc = CovenantAssaultReset,
    tooltipKey = 'ShowCovenantAssaultTooltip',
    relatedQuest = {
      63823, -- Night Fae Assault
      63822, -- Venthyr Assault
      63824, -- Kyrian Assault
      63543, -- Necrolord Assault
    },
  },
  {
    name = L["The World Awaits"],
    weekly = true,
    quest = 62631,
    relatedQuest = {62631},
  },
  {
    name = L["Emissary of War"],
    weekly = true,
    quest = 62638,
    relatedQuest = {62638},
  },
  -- Patterns Within Patterns
  {
    name = L["Patterns Within Patterns"],
    weekly = true,
    quest = 66042,
    resetFunc = KeepProgress,
    relatedQuest = {66042},
  },
}

function Module:OnEnable()
  self:UpdateAll()

  self:RegisterEvent('PLAYER_ENTERING_WORLD', 'UpdateAll')
  self:RegisterEvent('QUEST_LOG_UPDATE', 'UpdateAll')
end

function Module:UpdateAll()
  local t = SI.db.Toons[SI.thisToon]
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
        local _, objectiveType, finished, numFulfilled, numRequired = GetQuestObjectiveInfo(questID, 1, false)
        if objectiveType == 'progressbar' then
          numFulfilled = GetQuestProgressBarPercent(questID)
          numRequired = 100
        end
        result.objectiveType = objectiveType
        result.isFinish = finished
        result.numFulfilled = numFulfilled
        result.numRequired = numRequired
        if C_QuestLog_IsQuestFlaggedCompleted(questID) then
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

function Module:OnDailyReset(toon)
  local t = SI.db.Toons[toon]
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

function Module:OnWeeklyReset(toon)
  local t = SI.db.Toons[toon]
  if not t or not t.Progress then return end
  for i, tbl in ipairs(self.TrackedQuest) do
    if tbl.weekly then
      if tbl.resetFunc then
        tbl.resetFunc(toon, i)
      else
        local prev = t.Progress[i]
        if prev then
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
end

function Module:BuildOptions(order)
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

function Module:QuestEnabled(questID)
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
    return SI.db.Tooltip["Progress" .. self.questMap[questID]]
  end
end

-- Use addon global function in future
local function CloseTooltips()
  _G.GameTooltip:Hide()
  if SI.indicatortip then
    SI.indicatortip:Hide()
  end
end

function Module:ShowTooltip(tooltip, columns, showall, preshow)
  local cpairs = SI.cpairs
  local first = true
  for index, tbl in ipairs(self.TrackedQuest) do
    if SI.db.Tooltip["Progress" .. index] or showall then
      local show
      for toon, t in cpairs(SI.db.Toons, true) do
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
        for toon, t in cpairs(SI.db.Toons, true) do
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
              if value.objectiveType == 'progressbar' then
                text = floor((value.numFulfilled or 0) / value.numRequired * 100) .. "%"
              else
                -- Note: no idea why .numRequired is nil rarely (#325)
                -- protect this now to stop lua error
                text = (value.numFulfilled or "?") .. "/" .. (value.numRequired or "?")
              end
            end
          end
          local col = columns[toon .. 1]
          if col and text then
            -- check if current toon is showing
            -- don't add columns
            -- showFunc may return nil, or tbl.unlocked is nil, don't :SetCell and :SetCellScript in this case
            tooltip:SetCell(line, col, text, "CENTER", 4)
            if tbl.tooltipKey then
              tooltip:SetCellScript(line, col, "OnEnter", SI.hoverTooltip[tbl.tooltipKey], {toon, index})
              tooltip:SetCellScript(line, col, "OnLeave", CloseTooltips)
            end
          end
        end
      end
    end
  end
end
