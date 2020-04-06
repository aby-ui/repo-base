local _, addon = ...
local CU = addon.core:NewModule("Currency", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
local thisToon = UnitName("player") .. " - " .. GetRealmName()

local seasonTotalPatten = gsub(CURRENCY_SEASON_TOTAL, "%%s%%s", "(.+)")

-- Lua functions
local ipairs, pairs, strfind, wipe = ipairs, pairs, strfind, wipe
local _G = _G

-- WoW API / Variables
local GetCurrencyInfo = GetCurrencyInfo
local GetItemCount = GetItemCount
local GetMoney = GetMoney
local IsQuestFlaggedCompleted = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted or IsQuestFlaggedCompleted

local currency = {
  81, -- Epicurean Award
  241, -- Champion's Seal
  391, -- Tol Barad Commendation
  402, -- Ironpaw Token
  416, -- Mark of the World Tree
  515, -- Darkmoon Prize Ticket
  697, -- Elder Charm of Good Fortune
  738, -- Lesser Charm of Good Fortune
  752, -- Mogu Rune of Fate
  776, -- Warforged Seal
  777, -- Timeless Coin
  789, -- Bloody Coin

  -- Warlords of Draenor
  823, -- Apexis Crystal
  824, -- Garrison Resources
  994, -- Seal of Tempered Fate
  1101, -- Oil
  1129, -- Seal of Inevitable Fate
  1149, -- Sightless Eye
  1155, -- Ancient Mana
  1166, -- Timewarped Badge
  1191, -- Valor Points

  -- Legion
  1220, -- Order Resources
  1226, -- Nethershards
  1273, -- Seal of Broken Fate
  1275, -- Curious Coin
  1299, -- Brawler's Gold
  1314, -- Lingering Soul Fragment
  1342, -- Legionfall War Supplies
  1501, -- Writhing Essence
  1508, -- Veiled Argunite
  1533, -- Wakening Essence

  -- Battle for Azeroth
  1710, -- Seafarer's Dubloon
  1580, -- Seal of Wartorn Fate
  1560, -- War Resources
  1587, -- War Supplies
  1716, -- Honorbound Service Medal
  1717, -- 7th Legion Service Medal
  1718, -- Titan Residuum
  1721, -- Prismatic Manapearl
  1719, -- Corrupted Memento
  1755, -- Coalescing Visions
  1803, -- Echoes of Ny'alotha
}
addon.currency = currency

local currencySorted = {}
for _, idx in ipairs(currency) do
  table.insert(currencySorted, idx)
end
table.sort(currencySorted, function (c1, c2)
  local c1_name = GetCurrencyInfo(c1)
  local c2_name = GetCurrencyInfo(c2)
  return c1_name < c2_name
end)
addon.currencySorted = currencySorted

local specialCurrency = {
  [1129] = { -- WoD - Seal of Tempered Fate
    weeklyMax = 3,
    earnByQuest = {
      36058,  -- Seal of Dwarven Bunker
      -- Seal of Ashran quests
      36054,
      37454,
      37455,
      36056,
      37456,
      37457,
      36057,
      37458,
      37459,
      36055,
      37452,
      37453,
    },
  },
  [1273] = { -- LEG - Seal of Broken Fate
    weeklyMax = 3,
    earnByQuest = {
      43895,
      43896,
      43897,
      43892,
      43893,
      43894,
      43510, -- Order Hall
      47851, -- Mark of Honor x5
      47864, -- Mark of Honor x10
      47865, -- Mark of Honor x20
    },
  },
  [1580] = { -- BfA - Seal of Wartorn Fate
    weeklyMax = 2,
    earnByQuest = {
      52834, -- Gold
      52838, -- Piles of Gold
      52835, -- Marks of Honor
      52839, -- Additional Marks of Honor
      52837, -- War Resources
      52840, -- Stashed War Resources
    },
  },
  [1755] = { -- BfA - Coalescing Visions
    relatedItem = {
      id = 173363, -- Vessel of Horrific Visions
    },
  },
}
addon.specialCurrency = specialCurrency

for _, tbl in pairs(specialCurrency) do
  if tbl.earnByQuest then
    for _, questID in ipairs(tbl.earnByQuest) do
      addon.QuestExceptions[questID] = "Regular" -- not show in Weekly Quest
    end
  end
end

local function GetSeasonCurrency(idx)
  addon.scantt:SetOwner(_G.UIParent, "ANCHOR_NONE")
  addon.scantt:SetCurrencyByID(idx)
  local name = addon.scantt:GetName()
  for i = 1, addon.scantt:NumLines() do
    local text = _G[name .. "TextLeft" .. i]:GetText()
    if strfind(text, seasonTotalPatten) then
      return text
    end
  end
end

function CU:OnEnable()
  self:RegisterBucketEvent("CURRENCY_DISPLAY_UPDATE", 0.25, "UpdateCurrency")
  self:RegisterEvent("BAG_UPDATE", "UpdateCurrencyItem")
end

function CU:UpdateCurrency()
  if addon.logout then return end -- currency is unreliable during logout
  local t = addon.db.Toons[thisToon]
  t.Money = GetMoney()
  t.currency = wipe(t.currency or {})
  for _,idx in ipairs(currency) do
    local _, amount, _, earnedThisWeek, weeklyMax, totalMax, discovered = GetCurrencyInfo(idx)
    if not discovered then
      t.currency[idx] = nil
    else
      local ci = t.currency[idx] or {}
      ci.amount, ci.earnedThisWeek, ci.weeklyMax, ci.totalMax = amount, earnedThisWeek, weeklyMax, totalMax
      -- handle special currency
      if specialCurrency[idx] then
        local tbl = specialCurrency[idx]
        if tbl.weeklyMax then ci.weeklyMax = tbl.weeklyMax end
        if tbl.earnByQuest then
          ci.earnedThisWeek = 0
          for _, questID in ipairs(tbl.earnByQuest) do
            if IsQuestFlaggedCompleted(questID) then
              ci.earnedThisWeek = ci.earnedThisWeek + 1
            end
          end
        end
        if tbl.relatedItem then
          ci.relatedItemCount = GetItemCount(tbl.relatedItem.id)
        end
      end
      ci.season = GetSeasonCurrency(idx)
      if ci.weeklyMax == 0 then ci.weeklyMax = nil end -- don't store useless info
      if ci.totalMax == 0 then ci.totalMax = nil end -- don't store useless info
      if ci.earnedThisWeek == 0 then ci.earnedThisWeek = nil end -- don't store useless info
      t.currency[idx] = ci
    end
  end
end

function CU:UpdateCurrencyItem()
  if not addon.db.Toons[thisToon].currency then return end

  for currencyID, tbl in pairs(specialCurrency) do
    if tbl.relatedItem and addon.db.Toons[thisToon].currency[currencyID] then
      addon.db.Toons[thisToon].currency[currencyID].relatedItemCount = GetItemCount(tbl.relatedItem.id)
    end
  end
end
