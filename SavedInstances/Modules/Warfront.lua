local SI, L = unpack(select(2, ...))
local Module = SI:NewModule('Warfront', 'AceEvent-3.0', 'AceTimer-3.0')

-- Lua functions
local pairs, type = pairs, type

-- WoW API / Variables
local C_ContributionCollector_GetName = C_ContributionCollector.GetName
local C_ContributionCollector_GetState = C_ContributionCollector.GetState
local C_QuestLog_IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local UnitLevel = UnitLevel

local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE
local NORMAL_FONT_COLOR_CODE = NORMAL_FONT_COLOR_CODE
local READY_CHECK_READY_TEXTURE = READY_CHECK_READY_TEXTURE

-- Use following macro to get warfront ids
-- /dump C_ContributionCollector.GetManagedContributionsForCreatureID(143709) -- Alliance
-- /dump C_ContributionCollector.GetManagedContributionsForCreatureID(143707) -- Horde
local warfronts = {
  -- Arathi Highlands
  {
    Alliance = {
      id = 116,
      scenario = {53414, 56136}, -- Warfront: The Battle for Stromgarde (Alliance)
      boss = 52847, -- Doom's Howl
    },
    Horde = {
      id = 11,
      scenario = {53416, 56137}, -- Warfront: The Battle for Stromgarde (Horde)
      boss = 52848, -- The Lion's Roar
    },
  },
  -- Darkshores
  {
    Alliance = {
      id = 117,
      scenario = {53992, 57960}, -- Warfront: The Battle for Darkshore (Alliance)
      boss = 54895, -- Ivus the Decayed
    },
    Horde = {
      id = 118,
      scenario = {53955, 57959}, -- Warfront: The Battle for Darkshore (Horde)
      boss = 54896, -- Ivus the Forest Lord
    },
  },
}

function Module:OnEnable()
  self:CONTRIBUTION_CHANGED()
  self:UpdateQuest()
  self:RegisterEvent("CONTRIBUTION_CHANGED")
end

function Module:CONTRIBUTION_CHANGED()
  local globalInfo = SI.db.Warfront
  for index, tbl in pairs(warfronts) do
    local captureSide = "Horde"
    local state, _, timeOfNextStateChange = C_ContributionCollector_GetState(tbl.Alliance.id)
    if state then
      if state == 4 then
        captureSide = "Alliance"
        state, _, timeOfNextStateChange = C_ContributionCollector_GetState(tbl.Horde.id)
      end
      if not globalInfo[index] or globalInfo[index].captureSide ~= captureSide then
        self:OnReset(index, captureSide)
      end
      globalInfo[index] = {
        captureSide = captureSide,
        contributing = state == 1 and true or false,
        restTime = timeOfNextStateChange,
      }
    end
  end
end

function Module:UpdateQuest()
  local t = SI.db.Toons[SI.thisToon]
  if not t or UnitLevel("player") < 50 then return end
  if not t.Warfront then t.Warfront = {} end
  for index, tbl in pairs(warfronts) do
    if not t.Warfront[index] then t.Warfront[index] = {} end
    local curr = tbl[t.Faction]
    if curr then
      -- faction is not ready on Neutral Pandaren or first login
      t.Warfront[index] = {
        scenario = {},
        boss = C_QuestLog_IsQuestFlaggedCompleted(curr.boss),
      }
      for i, v in pairs(curr.scenario) do
        t.Warfront[index].scenario[i] = C_QuestLog_IsQuestFlaggedCompleted(v)
      end
    end
  end
end

function Module:OnReset(index, captureSide)
  for toon, ti in pairs(SI.db.Toons) do
    local t = SI.db.Toons[toon]
    if not t or not t.Warfront or not t.Warfront[index] then return end
    local tbl = t.Warfront[index]
    if t.Faction == captureSide then
      tbl.boss = false
    else
      tbl.scenario = {}
    end
  end
  self:UpdateQuest()
end

function Module:BuildOptions(order)
  local option = {}
  for index, tbl in pairs(warfronts) do
    option["Warfront" .. index] = {
      type = "toggle",
      order = order + index * 0.01,
      name = C_ContributionCollector_GetName(tbl.Alliance.id),
    }
  end
  return option
end

function Module:ShowTooltip(tooltip, columns, showall, preshow)
  local cpairs = SI.cpairs
  local first = true
  for index, tbl in pairs(warfronts) do
    if SI.db.Tooltip["Warfront" .. index] or showall then
      local show
      for toon, t in cpairs(SI.db.Toons, true) do
        if t.Warfront and t.Warfront[index] then
          show = true
        end
      end
      if show then
        if first == true then
          preshow()
          first = false
        end
        local line = tooltip:AddLine(NORMAL_FONT_COLOR_CODE .. C_ContributionCollector_GetName(tbl.Alliance.id) .. FONT_COLOR_CODE_CLOSE)
        for toon, t in cpairs(SI.db.Toons, true) do
          if t.Warfront and t.Warfront[index] then
            local value = t.Warfront[index]
            local text = ""
            if SI.db.Warfront[index] then
              if SI.db.Warfront[index].captureSide == t.Faction then
                if value.boss then
                  text = "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
                else
                  text = "0/1"
                end
              elseif not SI.db.Warfront[index].contributing then
                if value.scenario then
                  if type(value.scenario) == 'table' then
                    local completed = 0
                    local length = #tbl.Alliance.scenario
                    for _, v in pairs(value.scenario) do
                      if v then
                        completed = completed + 1
                      end
                    end
                    if completed == length then
                      text = "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
                    else
                      text = completed .. "/" .. length
                    end
                  else
                    -- old data fallback
                    text = "\124T" .. READY_CHECK_READY_TEXTURE .. ":0|t"
                  end
                else
                  -- old data fallback
                  text = "0/1"
                end
              end
            end
            local col = columns[toon .. 1]
            if col then
              -- check if current toon is showing
              -- don't add columns
              tooltip:SetCell(line, col, text, "CENTER", 4)
            end
          end
        end
      end
    end
  end
end

hooksecurefunc("GetQuestReward", function()
  Module:ScheduleTimer("UpdateQuest", 1)
end)
