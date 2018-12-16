local addonName, addon = ...
local WorldBosses = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("WorldBosses")
local L = addon.L

  -- encounter index is embedded in the Hjournal hyperlink
addon.WorldBosses = {
  -- Mist of Pandaria
  [691] = { quest=32099, expansion=4, level=90 }, -- Sha of Anger
  [725] = { quest=32098, expansion=4, level=90 }, -- Galleon
  [814] = { quest=32518, expansion=4, level=90 }, -- Nalak
  [826] = { quest=32519, expansion=4, level=90 }, -- Oondasta
  [857] = { quest=33117, expansion=4, level=90, name=L["The Four Celestials"]  }, -- Chi-Ji
  [861] = { quest=nil,   expansion=4, level=90 }, -- Ordos

  -- Warlords of Draenor
  [1211] = { quest=37462,  expansion=5, level=100, -- Drov/Tarlna share a loot and quest atm
    name=select(2,EJ_GetCreatureInfo(1,1291)):match("^[^ ]+").." / "..
    select(2,EJ_GetCreatureInfo(1,1211)):match("^[^ ]+")},
  [1262] = { quest=37464, expansion=5, level=100 }, -- Rukhmar
  [1452] = { quest=39380, expansion=5, level=100 }, -- Kazzak

  -- Legion
  [1749] = { quest=42270, expansion=6, level=110 }, -- Nithogg
  [1756] = { quest=42269, expansion=6, level=110, name=EJ_GetEncounterInfo(1756) }, -- The Soultakers
  [1763] = { quest=42779, expansion=6, level=110 }, -- Shar'thos
  [1769] = { quest=43192, expansion=6, level=110 }, -- Levantus
  [1770] = { quest=42819, expansion=6, level=110 }, -- Humongris
  [1774] = { quest=43193, expansion=6, level=110 }, -- Calamir
  [1783] = { quest=43513, expansion=6, level=110 }, -- Na'zak the Fiend
  [1789] = { quest=43448, expansion=6, level=110 }, -- Drugon the Frostblood
  [1790] = { quest=43512, expansion=6, level=110 }, -- Ana-Mouz
  [1795] = { quest=43985, expansion=6, level=110 }, -- Flotsam
  [1796] = { quest=44287, expansion=6, level=110 }, -- Withered Jim
  [1883] = { quest=46947, expansion=6, level=110 }, -- Brutallus
  [1884] = { quest=46948, expansion=6, level=110 }, -- Malificus
  [1885] = { quest=46945, expansion=6, level=110 }, -- Si'vash
  [1956] = { quest=47061, expansion=6, level=110 }, -- Apocron

  -- Argus Greater Invasions
  [2010] = { quest=49169, name=EJ_GetEncounterInfo(2010), expansion=6, level=110}, -- Matron Folnuna
  [2011] = { quest=49167, name=EJ_GetEncounterInfo(2011), expansion=6, level=110}, -- Mistress Alluradel
  [2012] = { quest=49166, name=EJ_GetEncounterInfo(2012), expansion=6, level=110}, -- Inquisitor Meto
  [2013] = { quest=49170, name=EJ_GetEncounterInfo(2013), expansion=6, level=110}, -- Occularus
  [2014] = { quest=49171, name=EJ_GetEncounterInfo(2014), expansion=6, level=110}, -- Sotanathor
  [2015] = { quest=49168, name=EJ_GetEncounterInfo(2015), expansion=6, level=110}, -- Pit Lord Vilemus

  -- Battle for Azeroth
  [2139] = { quest=52181, expansion=7, level=120 }, -- T'Zane
  [2141] = { quest=52169, expansion=7, level=120 }, -- Ji'arak
  [2197] = { quest=52157, expansion=7, level=120 }, -- Hailstone Construct
  [2199] = { quest=52163, expansion=7, level=120 }, -- Azurethos
  [2198] = { quest=52166, expansion=7, level=120 }, -- Warbringer Yenajz
  [2210] = { quest=52196, expansion=7, level=120 }, -- Dunegorger Kraulok
  -- Arathi Highlands
  [2212] = { quest=52848, expansion=7, level=120 }, -- The Lion's Roar
  [2213] = { quest=52847, expansion=7, level=120 }, -- Doom's Howl
  -- Darkshore
  [2329] = { quest=54896, expansion=7, level=120 }, -- Ivus the Forest Lord
  [2345] = { quest=54895, expansion=7, level=120 }, -- Ivus the Decayed

  -- bosses with no EJ entry (eid is a placeholder)
  [9001] = { quest=38276, name=GARRISON_LOCATION_TOOLTIP.." "..BOSS, expansion=5, level=100 },
  [9002] = { quest=47461, name="Lord Kazzak", expansion=6, level=110},          -- Lord Kazzak (13th Anniversary)
  [9003] = { quest=47462, name="Azuregos", expansion=6, level=110},             -- Azuregos (13th Anniversary)
  [9004] = { quest=47463, name="Dragon of Nightmare", expansion=6, level=110},  -- Dragon of Nightmare (13th Anniversary)
}
