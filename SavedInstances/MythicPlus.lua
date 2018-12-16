local addonName, addon = ...
local MythicPlusModule = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("MythicPlus", "AceEvent-3.0")
local L = addon.L
local thisToon = UnitName("player") .. " - " .. GetRealmName()

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

local KeystonetoAbbrev = {
  ["Atal'Dazar"] = L["AD"],
  ["Freehold"] = L["Free"],
  ["Tol Dagor"] = L["TD"],
  ["The MOTHERLODE!!"] = L["MOTHER"],
  ["Waycrest Manor"] = L["WM"],
  ["Kings' Rest"] = L["KR"],
  ["Temple of Sethraliss"] = L["ToS"],
  ["The Underrot"] = L["Under"],
  ["Shrine of the Storm"] = L["SotS"],
  ["Siege of Boralus"] = L["SoB"],
}
addon.KeystonetoAbbrev = KeystonetoAbbrev

function MythicPlusModule:RefreshMythicKeyInfo(event)

  if (event ~= "CHALLENGE_MODE_MAPS_UPDATE") then C_MythicPlus.RequestRewards() end -- This event is fired after the rewards data was requested, causing yet another refresh if not checked for

  local t = addon.db.Toons[thisToon]
  local _
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
          _,_,_,color = GetItemQualityColor(0)
        elseif mapLevel >= 10 then
          _,_,_,color = GetItemQualityColor(4)
        elseif mapLevel >= 7 then
          _,_,_,color = GetItemQualityColor(3)
        elseif mapLevel >= 4 then
          _,_,_,color = GetItemQualityColor(2)
        else
          _,_,_,color = GetItemQualityColor(1)
        end
        if addon.db.Tooltip.DebugMode then
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[1]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[2]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[3]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[4]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[5]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[6]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[7]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[8]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[9]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[10]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[11]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[12]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[13]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[14]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[15]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[16]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[17]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[18]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[19]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[20]))
        end
        t.MythicKey.abbrev = KeystoneAbbrev[mapID]
        t.MythicKey.link = C_ChallengeMode.GetMapUIInfo(mapID)
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
  t.MythicKeyBest = t.MythicKeyBest or { }
  t.MythicKeyBest.ResetTime = addon:GetNextWeeklyResetTime()
  t.MythicKeyBest.level = C_MythicPlus.GetWeeklyChestRewardLevel()
  t.MythicKeyBest.WeeklyReward = C_MythicPlus.IsWeeklyRewardAvailable()
end

function MythicPlusModule:OnEnable()
  self:RegisterEvent("BAG_UPDATE", "RefreshMythicKeyInfo")
  self:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE", "RefreshMythicKeyInfo")
  MythicPlusModule:RefreshMythicKeyInfo()
end
