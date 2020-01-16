local _, addon = ...
local P = addon.core:NewModule("Paragon", "AceEvent-3.0", "AceTimer-3.0")
local thisToon = UnitName("player") .. " - " .. GetRealmName()

-- Lua functions
local pairs, tinsert = pairs, tinsert

-- WoW API / Variables
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo

local factionID = {
  -- Legion
  -- 1090, -- Kirin Tor - No paragon chest
  1828, -- Highmountain Tribe
  1859, -- The Nightfallen
  1883, -- Dreamweavers
  1894, -- The Wardens
  1900, -- Court of Farondis
  1948, -- Valarjar
  2045, -- Armies of Legionfall
  2165, -- Army of the Light
  2170, -- Argussian Reach

  -- Battle for Azeroth
  2103, -- Zandalari Empire
  2156, -- Talanji's Expedition
  2157, -- The Honorbound
  2158, -- Voldunai
  2159, -- 7th Legion
  2160, -- Proudmoore Admiralty
  2161, -- Order of Embers
  2162, -- Storm's Wake
  2163, -- Tortollan Seekers
  2164, -- Champions of Azeroth
  2373, -- The Unshackled
  2391, -- Rustbolt Resistance
  2400, -- Waveblade Ankoan
  2415, -- Rajani
  2417, -- Uldum Accord
}

function P:OnEnable()
  self:RegisterEvent("UPDATE_FACTION")
  self:UPDATE_FACTION()
end

function P:UPDATE_FACTION()
  local t = addon.db.Toons[thisToon]
  t.Paragon = {}
  for _, faction in pairs(factionID) do
    local currentValue, _, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(faction)
    if currentValue and hasRewardPending then
      tinsert(t.Paragon, faction)
    end
  end
  addon.debug("Paragon faction update: %d", #t.Paragon)
end

hooksecurefunc("GetQuestReward", function()
  P:ScheduleTimer("UPDATE_FACTION", 1)
end)
