local SI, L = unpack(select(2, ...))
local Module = SI:NewModule('WorldBoss')

-- encounter index is embedded in the Hjournal hyperlink
SI.WorldBosses = {
  -- Mist of Pandaria
  [691] = { quest=32099, expansion=4, level=35 }, -- Sha of Anger
  [725] = { quest=32098, expansion=4, level=35 }, -- Galleon
  [814] = { quest=32518, expansion=4, level=35 }, -- Nalak
  [826] = { quest=32519, expansion=4, level=35 }, -- Oondasta
  [857] = { quest=33117, expansion=4, level=35, name=L["The Four Celestials"]  }, -- Chi-Ji
  [861] = { quest=nil,   expansion=4, level=35 }, -- Ordos

  -- Warlords of Draenor
  [1211] = { quest=37462,  expansion=5, level=40, -- Drov/Tarlna share a loot and quest atm
    name=select(2,EJ_GetCreatureInfo(1,1291)):match("^[^ ]+").." / "..
    select(2,EJ_GetCreatureInfo(1,1211)):match("^[^ ]+")},
  [1262] = { quest=37464, expansion=5, level=40 }, -- Rukhmar
  [1452] = { quest=39380, expansion=5, level=40 }, -- Kazzak

  -- Legion
  [1749] = { quest=42270, expansion=6, level=45 }, -- Nithogg
  [1756] = { quest=42269, expansion=6, level=45, name=EJ_GetEncounterInfo(1756) }, -- The Soultakers
  [1763] = { quest=42779, expansion=6, level=45 }, -- Shar'thos
  [1769] = { quest=43192, expansion=6, level=45 }, -- Levantus
  [1770] = { quest=42819, expansion=6, level=45 }, -- Humongris
  [1774] = { quest=43193, expansion=6, level=45 }, -- Calamir
  [1783] = { quest=43513, expansion=6, level=45 }, -- Na'zak the Fiend
  [1789] = { quest=43448, expansion=6, level=45 }, -- Drugon the Frostblood
  [1790] = { quest=43512, expansion=6, level=45 }, -- Ana-Mouz
  [1795] = { quest=43985, expansion=6, level=45 }, -- Flotsam
  [1796] = { quest=44287, expansion=6, level=45 }, -- Withered Jim
  [1883] = { quest=46947, expansion=6, level=45 }, -- Brutallus
  [1884] = { quest=46948, expansion=6, level=45 }, -- Malificus
  [1885] = { quest=46945, expansion=6, level=45 }, -- Si'vash
  [1956] = { quest=47061, expansion=6, level=45 }, -- Apocron

  -- Argus Greater Invasions
  [2010] = { quest=49169, name=EJ_GetEncounterInfo(2010), expansion=6, level=45}, -- Matron Folnuna
  [2011] = { quest=49167, name=EJ_GetEncounterInfo(2011), expansion=6, level=45}, -- Mistress Alluradel
  [2012] = { quest=49166, name=EJ_GetEncounterInfo(2012), expansion=6, level=45}, -- Inquisitor Meto
  [2013] = { quest=49170, name=EJ_GetEncounterInfo(2013), expansion=6, level=45}, -- Occularus
  [2014] = { quest=49171, name=EJ_GetEncounterInfo(2014), expansion=6, level=45}, -- Sotanathor
  [2015] = { quest=49168, name=EJ_GetEncounterInfo(2015), expansion=6, level=45}, -- Pit Lord Vilemus

  -- Battle for Azeroth
  [2139] = { quest=52181, expansion=7, level=50 }, -- T'Zane
  [2141] = { quest=52169, expansion=7, level=50 }, -- Ji'arak
  [2197] = { quest=52157, expansion=7, level=50 }, -- Hailstone Construct
  [2199] = { quest=52163, expansion=7, level=50 }, -- Azurethos
  [2198] = { quest=52166, expansion=7, level=50 }, -- Warbringer Yenajz
  [2210] = { quest=52196, expansion=7, level=50 }, -- Dunegorger Kraulok
  -- Arathi Highlands
  [2212] = { quest=52848, expansion=7, level=50, remove=true }, -- The Lion's Roar
  [2213] = { quest=52847, expansion=7, level=50, remove=true }, -- Doom's Howl
  -- Darkshore
  [2329] = { quest=54896, expansion=7, level=50, remove=true }, -- Ivus the Forest Lord
  [2345] = { quest=54895, expansion=7, level=50, remove=true }, -- Ivus the Decayed
  -- Nazjatar
  [2362] = { quest=56057, expansion=7, level=50 }, -- Ulmath, the Soulbinder
  [2363] = { quest=56056, expansion=7, level=50 }, -- Wekemara
  -- Vale of Eternal Blossoms
  [2378] = { quest=58705, expansion=7, level=50 }, -- Grand Empress Shek'zara
  -- Uldum
  [2381] = { quest=55466, expansion=7, level=50 }, -- Vuk'laz the Earthbreaker

  -- Shadowlands
  [2430] = { quest=61813, expansion=8, level=60 }, -- Valinor, the Light of Eons
  [2431] = { quest=61816, expansion=8, level=60 }, -- Mortanis
  [2432] = { quest=61815, expansion=8, level=60 }, -- Oranomonos the Everbranching
  [2433] = { quest=61814, expansion=8, level=60 }, -- Nurgash Muckformed
  [2456] = { quest=64531, expansion=8, level=60 }, -- Mor'geth, Tormentor of the Damned
  [2468] = { quest=65143, expansion=8, level=60 }, -- Antros

  -- Dragonflight
  [2506] = { quest=69930, expansion=9, level=70 }, -- Basrikron, The Shale Wing
  [2515] = { quest=69929, expansion=9, level=70 }, -- Strunraan, The Sky's Misery
  [2517] = { quest=69927, expansion=9, level=70 }, -- Bazual, The Dreaded Flame
  [2518] = { quest=69928, expansion=9, level=70 }, -- Liskanoth, The Futurebane

  -- bosses with no EJ entry (eid is a placeholder)
  [9001] = { quest=38276, name=GARRISON_LOCATION_TOOLTIP.." "..BOSS, expansion=5, level=40 },
  -- Old Vanilla Bosses during Anniversary Event
  [9002] = { quest=47461, name=L["Lord Kazzak"],         expansion=8, level=60, remove=true }, -- Lord Kazzak
  [9003] = { quest=47462, name=L["Azuregos"],            expansion=8, level=60, remove=true }, -- Azuregos
  [9004] = { quest=47463, name=L["Dragon of Nightmare"], expansion=8, level=60, remove=true }, -- Dragon of Nightmare
  -- Eastern Plaguelands (Shadowlands pre-patch event)
  [9005] = { quest=60542, name=L["Nathanos Blightcaller"], expansion=7, level=50 }, -- Nathanos Blightcaller
  -- The Maw
  [9006] = { quest=63414, name=L["Wrath of the Jailer"],    expansion=8, level=60 }, -- Wrath of the Jailer
  [9007] = { quest=63854, name=L["Tormentors of Torghast"], expansion=8, level=60 }, -- Tormentors of Torghast
  -- Fated (Shadowlands Season 4)
  [9008] = { quest=66614, name=EJ_GetEncounterInfo(2430), expansion=8, level=60 }, -- Valinor, the Light of Eons
  [9009] = { quest=66617, name=EJ_GetEncounterInfo(2431), expansion=8, level=60 }, -- Mortanis
  [9010] = { quest=66616, name=EJ_GetEncounterInfo(2432), expansion=8, level=60 }, -- Oranomonos the Everbranching
  [9011] = { quest=66615, name=EJ_GetEncounterInfo(2433), expansion=8, level=60 }, -- Nurgash Muckformed
  [9012] = { quest=66618, name=EJ_GetEncounterInfo(2456), expansion=8, level=60 }, -- Mor'geth, Tormentor of the Damned
  [9013] = { quest=66619, name=EJ_GetEncounterInfo(2468), expansion=8, level=60 }, -- Antros
}
