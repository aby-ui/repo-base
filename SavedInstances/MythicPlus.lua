local addonName, addon = ...
local MythicPlusModule = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("MythicPlus")
local L = addon.L

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
