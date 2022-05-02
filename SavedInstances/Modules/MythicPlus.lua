local SI, L = unpack(select(2, ...))
local Module = SI:NewModule('MythicPlus', 'AceEvent-3.0', 'AceBucket-3.0')

-- Lua functions
local _G = _G
local ipairs, sort, strsplit, tonumber, wipe = ipairs, sort, strsplit, tonumber, wipe

-- WoW API / Variables
local C_ChallengeMode_GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
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
local SendChatMessage = SendChatMessage

local StaticPopup_Show = StaticPopup_Show

local Enum_WeeklyRewardChestThresholdType_MythicPlus = Enum.WeeklyRewardChestThresholdType.MythicPlus

local KeystoneAbbrev = {
  [197] = L["EOA"],   -- Eye of Azshara
  [198] = L["DHT"],   -- Darkheart Thicket
  [199] = L["BRH"],   -- Black Rook Hold
  [206] = L["NL"],    -- Neltharion's Lair
  [207] = L["VOTW"],  -- Vault of the Wardens
  [210] = L["COS"],   -- Court of Stars

  [375] = L["MISTS"], -- Mists of Tirna Scithe
  [376] = L["NW"],    -- The Necrotic Wake
  [377] = L["DOS"],   -- De Other Side
  [378] = L["HOA"],   -- Halls of Atonement
  [379] = L["PF"],    -- Plaguefall
  [380] = L["SD"],    -- Sanguine Depths
  [381] = L["SOA"],   -- Spires of Ascension
  [382] = L["TOP"],   -- Theater of Pain
  [391] = L["STRT"],  -- Tazavesh: Streets of Wonder
  [392] = L["GMBT"],  -- Tazavesh: So'leah's Gambit
}
SI.KeystoneAbbrev = KeystoneAbbrev

function Module:OnEnable()
  self:RegisterEvent("BAG_UPDATE_DELAYED", "RefreshMythicKeyInfo")

  self:RegisterBucketEvent('CHALLENGE_MODE_COMPLETED', 5, C_MythicPlus_RequestMapInfo)

  self:RegisterBucketEvent({
    "WEEKLY_REWARDS_UPDATE",
    "CHALLENGE_MODE_MAPS_UPDATE",
  }, 1, "RefreshMythicWeeklyBestInfo")

  C_MythicPlus_RequestMapInfo()

  self:RefreshMythicKeyInfo()
  self:RefreshMythicWeeklyBestInfo()
end

do
  local colorCache = {}
  local function getLevelColor(level)
    if colorCache[level] then
      return colorCache[level]
    end

    local color = C_ChallengeMode_GetKeystoneLevelRarityColor(level)
    colorCache[level] = color:GenerateHexColor()
    return colorCache[level]
  end

  function Module:ProcessKey(itemLink, targetTable)
    local _, _, mapID, mapLevel = strsplit(':', itemLink)
    mapID = tonumber(mapID)
    mapLevel = tonumber(mapLevel)

    targetTable.link = itemLink
    targetTable.mapID = mapID
    targetTable.level = mapLevel
    targetTable.name = C_ChallengeMode_GetMapUIInfo(mapID)
    targetTable.color = getLevelColor(mapLevel)
    targetTable.ResetTime = SI:GetNextWeeklyResetTime()
  end
end

function Module:RefreshMythicKeyInfo()
  local t = SI.db.Toons[SI.thisToon]
  t.MythicKey = wipe(t.MythicKey or {})
  t.TimewornMythicKey = wipe(t.TimewornMythicKey or {})
  for bagID = 0, 4 do
    for invID = 1, GetContainerNumSlots(bagID) do
      local itemID = GetContainerItemID(bagID, invID)
      if itemID and itemID == 180653 then
        self:ProcessKey(GetContainerItemLink(bagID, invID), t.MythicKey)
      elseif itemID and itemID == 187786 then
        self:ProcessKey(GetContainerItemLink(bagID, invID), t.TimewornMythicKey)
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

function Module:Keys(index)
  local target = SI.db.Tooltip.KeystoneReportTarget
  SI:Debug("Key report target: %s", target)

  if target == 'EXPORT' then
    self:ExportKeys(index)
  else
    local dialog = StaticPopup_Show("SAVEDINSTANCES_REPORT_KEYS", target, nil, target)
    if dialog then
      dialog.data2 = index
    end
  end
end

function Module:KeyData(index, action)
  local cpairs = SI.cpairs

  for toon, t in cpairs(SI.db.Toons, true) do
    if t[index] and t[index].link then
      local toonname
      if SI.db.Tooltip.ShowServer then
        toonname = toon
      else
        local tname, tserver = toon:match('^(.*) [-] (.*)$')
        toonname = tname
      end

      action(toonname, t[index].link)
    end
  end
end

function Module:ReportKeys(target, index)
  self:KeyData(index, function(toon, key) SendChatMessage(toon .. ' - '.. key, target) end)
end

function Module:ExportKeys(index)
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
  self:KeyData(index, function(toon, key) keys = keys .. toon .. ' - ' .. key .. '\n' end)

  self.KeyExportText:SetText(keys)
  self.KeyExportText:HighlightText()

  self.KeyExportWindow:Show()
end

StaticPopupDialogs["SAVEDINSTANCES_REPORT_KEYS"] = {
  preferredIndex = STATICPOPUPS_NUMDIALOGS, -- reduce the chance of UI taint
  text = L["Are you sure you want to report all your keys to %s?"],
  button1 = OKAY,
  button2 = CANCEL,
  OnAccept = function(self, target, index) Module:ReportKeys(target, index) end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  enterClicksFirstButton = false,
  showAlert = true,
}
