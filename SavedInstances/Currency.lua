local addonName, addon = ...
local CurrencyModule = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("Currency", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
local thisToon = UnitName("player") .. " - " .. GetRealmName()
local QuestExceptions = addon.QuestExceptions

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
}
addon.currency = currency

local WoDSealQuests = {
  [36058] = "Weekly",  -- Seal of Dwarven Bunker
  -- Seal of Ashran quests
  [36054] = "Weekly",
  [37454] = "Weekly",
  [37455] = "Weekly",
  [36056] = "Weekly",
  [37456] = "Weekly",
  [37457] = "Weekly",
  [36057] = "Weekly",
  [37458] = "Weekly",
  [37459] = "Weekly",
  [36055] = "Weekly",
  [37452] = "Weekly",
  [37453] = "Weekly",
}

for k,v in pairs(WoDSealQuests) do
  QuestExceptions[k] = v
end

local LegionSealQuests = {
  [43895] = "Weekly",
  [43896] = "Weekly",
  [43897] = "Weekly",
  [43892] = "Weekly",
  [43893] = "Weekly",
  [43894] = "Weekly",
  [43510] = "Weekly", -- Order Hall
  [47851] = "Weekly", -- Mark of Honor x5
  [47864] = "Weekly", -- Mark of Honor x10
  [47865] = "Weekly", -- Mark of Honor x20
}

for k,v in pairs(LegionSealQuests) do
  QuestExceptions[k] = v
end

local BfASealQuests = {
  [52834] = "Weekly", -- Gold
  [52838] = "Weekly", -- Piles of Gold
  [52835] = "Weekly", -- Marks of Honor
  [52839] = "Weekly", -- Additional Marks of Honor
  [52837] = "Weekly", -- War Resources
  [52840] = "Weekly", -- Stashed War Resources
}

for k,v in pairs(BfASealQuests) do
  QuestExceptions[k] = v
end

function addon:UpdateCurrency()
  if addon.logout then return end -- currency is unreliable during logout
  local t = addon.db.Toons[thisToon]
  t.Money = GetMoney()
  t.currency = wipe(t.currency or {})
  for _,idx in ipairs(currency) do
    local _, amount, _, earnedThisWeek, weeklyMax, totalMax, discovered = GetCurrencyInfo(idx)
    if idx == 390 and amount == 0 then
      discovered = false -- discovery flag broken for conquest points
    end
    if not discovered then
      t.currency[idx] = nil
    else
      local ci = t.currency[idx] or {}
      ci.amount, ci.earnedThisWeek, ci.weeklyMax, ci.totalMax = amount, earnedThisWeek, weeklyMax, totalMax
      if idx == 396 then -- VP has a weekly max scaled by 100
        ci.weeklyMax = ci.weeklyMax and math.floor(ci.weeklyMax/100)
      end
      if idx == 390 or idx == 395 or idx == 396 then -- these have a total max scaled by 100
        ci.totalMax = ci.totalMax and math.floor(ci.totalMax/100)
      end
      if idx == 390 then -- these have a weekly earned scaled by 100
        ci.earnedThisWeek = ci.earnedThisWeek and math.floor(ci.earnedThisWeek/100)
      end
      if idx == 1129 then -- Seal of Tempered Fate returns zero for weekly quantities
        ci.weeklyMax = 3 -- the max via quests
        ci.earnedThisWeek = 0
        for id in pairs(WoDSealQuests) do
          if IsQuestFlaggedCompleted(id) then
            ci.earnedThisWeek = ci.earnedThisWeek + 1
          end
        end
      elseif idx == 1273 then -- Seal of Broken Fate returns zero for weekly quantities
        ci.weeklyMax = 3 -- the max via quests
        ci.earnedThisWeek = 0
        for id in pairs(LegionSealQuests) do
          if IsQuestFlaggedCompleted(id) then
            ci.earnedThisWeek = ci.earnedThisWeek + 1
          end
        end
      end
      if idx == 1580 then -- Seal of Wartorn Fate returns zero for weekly quantities
        ci.weeklyMax = 2 -- the max via quests
        ci.earnedThisWeek = 0
        for id in pairs(BfASealQuests) do
          if IsQuestFlaggedCompleted(id) then
            ci.earnedThisWeek = ci.earnedThisWeek + 1
          end
        end
      end
      ci.season = addon:GetSeasonCurrency(idx)
      if ci.weeklyMax == 0 then ci.weeklyMax = nil end -- don't store useless info
      if ci.totalMax == 0 then ci.totalMax = nil end -- don't store useless info
      if ci.earnedThisWeek == 0 then ci.earnedThisWeek = nil end -- don't store useless info
      t.currency[idx] = ci
    end
  end
end
