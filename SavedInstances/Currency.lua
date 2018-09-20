local addonName, addon = ...
local CurrencyModule = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("Currency")

local currency = {
  --390, -- Conquest Points
  --392, -- Honor Points
  --395, -- Justice Points
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
  823, -- Apexis Crystal
  824, -- Garrison Resources
  994, -- Seal of Tempered Fate
  1101, -- Oil
  1129, -- Seal of Inevitable Fate
  1149, -- Sightless Eye
  1155, -- Ancient Mana
  1166, -- Timewarped Badge
  1191, -- Valor Points
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
  1565, -- Rich Azerite Fragment
  1710, -- Seafarer's Dubloon
  1580, -- Seal of Wartorn Fate
  1560, -- War Resources
  1587, -- War Supplies
}
addon.currency = currency
