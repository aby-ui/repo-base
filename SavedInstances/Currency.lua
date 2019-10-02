local _, addon = ...
local CurrencyModule = addon.core:NewModule("Currency", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
local thisToon = UnitName("player") .. " - " .. GetRealmName()

local SEASON_SCAN = CURRENCY_SEASON_TOTAL:gsub("%%%d*?([ds])","(%%%1*)")

-- Lua functions
local wipe, ipairs, pairs = wipe, ipairs, pairs
local _G = _G

-- WoW API / Variables
local GetCurrencyInfo = GetCurrencyInfo
local GetMoney = GetMoney
local IsQuestFlaggedCompleted = C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted or IsQuestFlaggedCompleted

function CurrencyModule:OnEnable()
  self:RegisterBucketEvent("CURRENCY_DISPLAY_UPDATE", 0.25, function() addon:UpdateCurrency() end)
end

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

  --Battle for Azeroth
  1710, -- Seafarer's Dubloon
  1580, -- Seal of Wartorn Fate
  1560, -- War Resources
  1587, -- War Supplies
  1716, -- Honorbound Service Medal
  1717, -- 7th Legion Service Medal
  1718, -- Titan Residuum
  1721, -- Prismatic Manapearl
}
addon.currency = currency

local specialCurrency = {
  [1129] = { -- WoD - Seal of Tempered Fate
    weeklyMax = 3,
    earnByQuest = {
      [36058] = true,  -- Seal of Dwarven Bunker
      -- Seal of Ashran quests
      [36054] = true,
      [37454] = true,
      [37455] = true,
      [36056] = true,
      [37456] = true,
      [37457] = true,
      [36057] = true,
      [37458] = true,
      [37459] = true,
      [36055] = true,
      [37452] = true,
      [37453] = true,
    },
  },
  [1273] = { -- LEG - Seal of Broken Fate
    weeklyMax = 3,
    earnByQuest = {
      [43895] = true,
      [43896] = true,
      [43897] = true,
      [43892] = true,
      [43893] = true,
      [43894] = true,
      [43510] = true, -- Order Hall
      [47851] = true, -- Mark of Honor x5
      [47864] = true, -- Mark of Honor x10
      [47865] = true, -- Mark of Honor x20
    },
  },
  [1580] = { -- BfA - Seal of Wartorn Fate
    weeklyMax = 2,
    earnByQuest = {
      [52834] = true, -- Gold
      [52838] = true, -- Piles of Gold
      [52835] = true, -- Marks of Honor
      [52839] = true, -- Additional Marks of Honor
      [52837] = true, -- War Resources
      [52840] = true, -- Stashed War Resources
    },
  },
}

for _, tbl in pairs(specialCurrency) do
  if tbl.earnByQuest then
    for questID in pairs(tbl.earnByQuest) do
      addon.QuestExceptions[questID] = "Regular" -- not show in Weekly Quest
    end
  end
end

local function GetSeasonCurrency(idx)
  addon.scantt:SetOwner(_G.UIParent, "ANCHOR_NONE")
  addon.scantt:SetCurrencyByID(idx)
  local name = addon.scantt:GetName()
  for i = 1, addon.scantt:NumLines() do
    local left = _G[name.."TextLeft"..i]
    if left:GetText():find(SEASON_SCAN) then
      return left:GetText()
    end
  end
end

function addon:UpdateCurrency()
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
          for questID in pairs(tbl.earnByQuest) do
            if IsQuestFlaggedCompleted(questID) then
              ci.earnedThisWeek = ci.earnedThisWeek + 1
            end
          end
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
