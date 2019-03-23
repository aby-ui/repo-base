local _, addon = ...
local MythicPlusModule = addon.core:NewModule("MythicPlus", "AceEvent-3.0")
local L = addon.L
local thisToon = UnitName("player") .. " - " .. GetRealmName()

-- Lua functions
local strsplit, tonumber, select, time = strsplit, tonumber, select, time

-- WoW API / Variables
local C_ChallengeMode_GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local C_MythicPlus_GetWeeklyChestRewardLevel = C_MythicPlus.GetWeeklyChestRewardLevel
local C_MythicPlus_IsWeeklyRewardAvailable = C_MythicPlus.IsWeeklyRewardAvailable
local C_MythicPlus_RequestRewards = C_MythicPlus.RequestRewards
local GetContainerItemID = GetContainerItemID
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetItemQualityColor = GetItemQualityColor

local KeystoneAbbrev = {
  [244] = L["AD"],
  [245] = L["Free"],
  [246] = L["TD"],
  [247] = L["MOTHER"],
  [248] = L["WM"],
  [249] = L["KR"],
  [250] = L["ToS"],
  [251] = L["Under"],
  [252] = L["SotS"],
  [353] = L["SoB"],
}
addon.KeystoneAbbrev = KeystoneAbbrev

function MythicPlusModule:OnEnable()
  self:RegisterEvent("BAG_UPDATE", "RefreshMythicKeyInfo")
  self:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE", "RefreshMythicKeyInfo")
  self:RefreshMythicKeyInfo()
end

function MythicPlusModule:RefreshMythicKeyInfo(event)
  -- This event is fired after the rewards data was requested, causing yet another refresh if not checked for
  if (event ~= "CHALLENGE_MODE_MAPS_UPDATE") then C_MythicPlus_RequestRewards() end

  local t = addon.db.Toons[thisToon]
  t.MythicKey = {}
  for bagID = 0, 4 do
    for invID = 1, GetContainerNumSlots(bagID) do
      local itemID = GetContainerItemID(bagID, invID)
      if itemID and itemID == 158923 then
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
        -- addon.debug("Mythic Keystone: %s", gsub(keyLink, "\124", "\124\124"))
        t.MythicKey.name = C_ChallengeMode_GetMapUIInfo(mapID)
        t.MythicKey.mapID = mapID
        t.MythicKey.color = color
        t.MythicKey.level = mapLevel
        t.MythicKey.ResetTime = addon:GetNextWeeklyResetTime()
        t.MythicKey.link = keyLink
      end
    end
  end
  if t.MythicKeyBest and (t.MythicKeyBest.ResetTime or 0) < time() then -- dont know weekly reset function will run early or not
    if t.MythicKeyBest.level and t.MythicKeyBest.level > 0 then
      t.MythicKeyBest.LastWeekLevel = t.MythicKeyBest.level
  end
  end
  t.MythicKeyBest = t.MythicKeyBest or {}
  t.MythicKeyBest.ResetTime = addon:GetNextWeeklyResetTime()
  t.MythicKeyBest.level = C_MythicPlus_GetWeeklyChestRewardLevel()
  t.MythicKeyBest.WeeklyReward = C_MythicPlus_IsWeeklyRewardAvailable()
end
