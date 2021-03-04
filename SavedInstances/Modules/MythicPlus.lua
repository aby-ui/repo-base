local SI, L = unpack(select(2, ...))
local Module = SI:NewModule('MythicPlus', 'AceEvent-3.0', 'AceBucket-3.0')

-- Lua functions
local _G = _G
local ipairs, sort, strsplit, tonumber, select, time, wipe = ipairs, sort, strsplit, tonumber, select, time, wipe

-- WoW API / Variables
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_MythicPlus_GetRunHistory = C_MythicPlus.GetRunHistory
local C_MythicPlus_RequestMapInfo = C_MythicPlus.RequestMapInfo
local C_MythicPlus_GetRewardLevelFromKeystoneLevel = C_MythicPlus.GetRewardLevelFromKeystoneLevel
local C_WeeklyRewards_GetActivities = C_WeeklyRewards.GetActivities
local C_WeeklyRewards_HasAvailableRewards = C_WeeklyRewards.HasAvailableRewards
local C_WeeklyRewards_CanClaimRewards = C_WeeklyRewards.CanClaimRewards
local CreateFrame = CreateFrame
local GetContainerItemID = GetContainerItemID
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetItemQualityColor = GetItemQualityColor
local SendChatMessage = SendChatMessage

local StaticPopup_Show = StaticPopup_Show

local Enum_WeeklyRewardChestThresholdType_MythicPlus = Enum.WeeklyRewardChestThresholdType.MythicPlus

local KeystoneAbbrev = {
  [375] = L["MISTS"], -- Mists of Tirna Scithe
  [376] = L["NW"],    -- The Necrotic Wake
  [377] = L["DOS"],   -- De Other Side
  [378] = L["HOA"],   -- Halls of Atonement
  [379] = L["PF"],    -- Plaguefall
  [380] = L["SD"],    -- Sanguine Depths
  [381] = L["SOA"],   -- Spires of Ascension
  [382] = L["TOP"],   -- Theater of Pain
}
SI.KeystoneAbbrev = KeystoneAbbrev

function Module:OnEnable()
  self:RegisterEvent("BAG_UPDATE_DELAYED", "RefreshMythicKeyInfo")

  self:RegisterEvent("CHALLENGE_MODE_COMPLETED", C_MythicPlus_RequestMapInfo)

  self:RegisterBucketEvent({
    "WEEKLY_REWARDS_UPDATE",
    "CHALLENGE_MODE_MAPS_UPDATE",
  }, 1, "RefreshMythicWeeklyBestInfo")

  C_MythicPlus_RequestMapInfo()

  self:RefreshMythicKeyInfo()
  self:RefreshMythicWeeklyBestInfo()
end

function Module:RefreshMythicKeyInfo()
  local t = SI.db.Toons[SI.thisToon]
  t.MythicKey = wipe(t.MythicKey or {})
  for bagID = 0, 4 do
    for invID = 1, GetContainerNumSlots(bagID) do
      local itemID = GetContainerItemID(bagID, invID)
      if itemID and itemID == 180653 then
        local keyLink = GetContainerItemLink(bagID, invID)
        local KeyInfo = {strsplit(':', keyLink)}
        local mapID = tonumber(KeyInfo[3])
        local mapLevel = tonumber(KeyInfo[4])
        local color
        if KeyInfo[4] == "0" then
          color = select(4, GetItemQualityColor(0))
        elseif mapLevel >= 10 then
          color = select(4, GetItemQualityColor(4))
        elseif mapLevel >= 7 then
          color = select(4, GetItemQualityColor(3))
        elseif mapLevel >= 4 then
          color = select(4, GetItemQualityColor(2))
        else
          color = select(4, GetItemQualityColor(1))
        end
        -- SI:Debug("Mythic Keystone: %s", gsub(keyLink, "\124", "\124\124"))
        t.MythicKey.name = C_ChallengeMode_GetMapUIInfo(mapID)
        t.MythicKey.mapID = mapID
        t.MythicKey.color = color
        t.MythicKey.level = mapLevel
        t.MythicKey.ResetTime = SI:GetNextWeeklyResetTime()
        t.MythicKey.link = keyLink
      end
    end
  end
end

do
  local function activityCompare(left, right)
    return left.index < right.index
  end

  local function runCompare(left, right)
    if left.level == right.level then
      return left.mapChallengeModeID < right.mapChallengeModeID
    else
      return left.level > right.level
    end
  end

  function Module:RefreshMythicWeeklyBestInfo()
    local t = SI.db.Toons[SI.thisToon]

    t.MythicKeyBest = wipe(t.MythicKeyBest or {})
    t.MythicKeyBest.threshold = wipe(t.MythicKeyBest.threshold or {})
    t.MythicKeyBest.rewardWaiting = C_WeeklyRewards_HasAvailableRewards() or C_WeeklyRewards_CanClaimRewards()
    t.MythicKeyBest.ResetTime = SI:GetNextWeeklyResetTime()

    local activities = C_WeeklyRewards_GetActivities(Enum_WeeklyRewardChestThresholdType_MythicPlus)
    sort(activities, activityCompare)

    local lastCompletedIndex = 0
    for i, activityInfo in ipairs(activities) do
      t.MythicKeyBest.threshold[i] = activityInfo.threshold
      if activityInfo.progress >= activityInfo.threshold then
        lastCompletedIndex = i
      end
    end

    -- done nothing
    if lastCompletedIndex == 0 then return end
    t.MythicKeyBest.lastCompletedIndex = lastCompletedIndex

    local runHistory = C_MythicPlus_GetRunHistory(false, true)
    sort(runHistory, runCompare)
    for i = 1, #runHistory do
      runHistory[i].name = C_ChallengeMode_GetMapUIInfo(runHistory[i].mapChallengeModeID)
      runHistory[i].rewardLevel = C_MythicPlus_GetRewardLevelFromKeystoneLevel(runHistory[i].level)
    end
    t.MythicKeyBest.runHistory = runHistory

    for index = 1, lastCompletedIndex do
      if runHistory[activities[index].threshold] then
        t.MythicKeyBest[index] = runHistory[activities[index].threshold].level
      end
    end
  end
end

function Module:Keys()
  local target = SI.db.Tooltip.KeystoneReportTarget
  SI:Debug("Key report target: %s", target)

  if target == 'EXPORT' then
    self:ExportKeys()
  else
    local dialog = StaticPopup_Show("SAVEDINSTANCES_REPORT_KEYS", target, nil, target)
  end
end

function Module:KeyData(action)
  local cpairs = SI.cpairs

  for toon, t in cpairs(SI.db.Toons, true) do
    if t.MythicKey and t.MythicKey.link then
      local toonname
      if SI.db.Tooltip.ShowServer then
        toonname = toon
      else
        local tname, tserver = toon:match('^(.*) [-] (.*)$')
        toonname = tname
      end

      action(toonname, t.MythicKey.link)
    end
  end
end

function Module:ReportKeys(target)
  self:KeyData(function(toon, key) SendChatMessage(toon .. ' - '.. key, target) end)
end

function Module:ExportKeys()
  if not self.KeyExportWindow then
    local f = CreateFrame("Frame", nil, _G.UIParent, "DialogBoxFrame")
    f:SetSize(700, 450)
    f:SetPoint("CENTER")
    f:SetFrameStrata("HIGH")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:SetClampedToScreen(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    self.KeyExportWindow = f

    local sf = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
    sf:SetPoint("TOP", 0, -16)
    sf:SetPoint("BOTTOM", f, "BOTTOM", 0, 50)
    sf:SetPoint("LEFT", 16, 0)
    sf:SetPoint("RIGHT", -36, 0)

    local st = CreateFrame("EditBox", nil, sf)
    st:SetSize(sf:GetSize())
    st:SetMultiLine(true)
    st:SetFontObject("ChatFontNormal")
    st:SetScript("OnEscapePressed", function()
      f:Hide()
    end)
    sf:SetScrollChild(st)
    self.KeyExportText = st
  end

  local keys = ""
  self:KeyData(function(toon, key) keys = keys .. toon .. ' - ' .. key .. '\n' end)

  self.KeyExportText:SetText(keys)
  self.KeyExportText:HighlightText()

  self.KeyExportWindow:Show()
end

StaticPopupDialogs["SAVEDINSTANCES_REPORT_KEYS"] = {
  preferredIndex = STATICPOPUPS_NUMDIALOGS, -- reduce the chance of UI taint
  text = L["Are you sure you want to report all your keys to %s?"],
  button1 = OKAY,
  button2 = CANCEL,
  OnAccept = function(self, target) Module:ReportKeys(target) end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  enterClicksFirstButton = false,
  showAlert = true,
}
