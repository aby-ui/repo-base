local addonName, addon = ...
local LFRModule = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("LFR")

addon.LFRInstances = {
  -- index is the id found in LFGDungeons.dbc or using the command below.
  -- /script local id,name; for i=1,GetNumRFDungeons() do id,name = GetRFDungeonInfo(i);print(i..". "..name.." ("..id..")");end
  -- total is boss count, base is boss offset,
  -- parent is instance name to use, GetLFGDungeonInfo() or using the command below.
  -- /run for i, v in ipairs(GetLFRChoiceOrder()) do print(i, v, GetLFGDungeonInfo(v)) end
  -- altid is for alternate LFRID for higher level toons

  -- Cataclysm
  [416] = { total=4, base=1,  parent=448, altid=843 }, -- DS1: The Siege of Wyrmrest Temple
  [417] = { total=4, base=5,  parent=448, altid=844 }, -- DS2: Fall of Deathwing

  -- Mist of Pandaria
  [527] = { total=3, base=1,  parent=532, altid=830 }, -- MSV1: Guardians of Mogu'shan
  [528] = { total=3, base=4,  parent=532, altid=831 }, -- MSV2: The Vault of Mysteries
  [529] = { total=3, base=1,  parent=534, altid=832 }, -- HoF1: The Dread Approach
  [530] = { total=3, base=4,  parent=534, altid=833 }, -- HoF2: Nightmare of Shek'zeer
  [526] = { total=4, base=1,  parent=536, altid=834 }, -- TeS1: Terrace of Endless Spring
  [610] = { total=3, base=1,  parent=634, altid=835 }, -- ToT1: Last Stand of the Zandalari
  [611] = { total=3, base=4,  parent=634, altid=836 }, -- ToT2: Forgotten Depths
  [612] = { total=3, base=7,  parent=634, altid=837 }, -- ToT3: Halls of Flesh-Shaping
  [613] = { total=3, base=10, parent=634, altid=838 }, -- ToT4: Pinnacle of Storms
  [716] = { total=4, base=1,  parent=766, altid=839 }, -- SoO1: Vale of Eternal Sorrows
  [717] = { total=4, base=5,  parent=766, altid=840 }, -- SoO2: Gates of Retribution
  [724] = { total=3, base=9,  parent=766, altid=841 }, -- SoO3: The Underhold
  [725] = { total=3, base=12, parent=766, altid=842 }, -- SoO4: Downfall

  -- Warlords of Draenor
  [849] = { total=3, base=1,  parent=897, altid=1363 }, -- Highmaul1: Walled City
  [850] = { total=3, base=4,  parent=897, altid=1364 }, -- Highmaul2: Arcane Sanctum
  [851] = { total=1, base=7,  parent=897, altid=1365 }, -- Highmaul3: Imperator's Rise
  [847] = { total=3, base=1,  parent=900, altid=1361, remap={ 1, 2, 7 } }, -- BRF1: Slagworks
  [846] = { total=3, base=4,  parent=900, altid=1360, remap={ 3, 5, 8 } }, -- BRF2: The Black Forge
  [848] = { total=3, base=7,  parent=900, altid=1362, remap={ 4, 6, 9 } }, -- BRF3: Iron Assembly
  [823] = { total=1, base=10, parent=900, altid=1359 }, -- BRF4: Blackhand's Crucible

  [982] = { total=3, base=1,  parent=989, altid=1366 }, -- Hellfire1: Hellbreach
  [983] = { total=3, base=4,  parent=989, altid=1367 }, -- Hellfire2: Halls of Blood
  [984] = { total=3, base=7,  parent=989, altid=1368, remap={ 7, 8,  11 } }, -- Hellfire3: Bastion of Shadows
  [985] = { total=3, base=10, parent=989, altid=1369, remap={ 9, 10, 12 } }, -- Hellfire4: Destructor's Rise
  [986] = { total=1, base=13, parent=989, altid=1370 }, -- Hellfire5: The Black Gate

  -- Legion
  [1287] = { total=3, base=1,  parent=1350, altid=nil, remap={ 1, 2, 3 } }, -- EN1: Darkbough
  [1288] = { total=3, base=4,  parent=1350, altid=nil, remap={ 1, 2, 3 } }, -- EN2: Tormented Guardians
  [1289] = { total=1, base=7,  parent=1350, altid=nil, remap={ 1 } },       -- EN3: Rift of Aln

  [1411] = { total=3, base=1,  parent=1439, altid=nil }, -- ToV

  [1290] = { total=3, base=1,  parent=1353, altid=nil }, -- NH1: Arcing Aqueducts
  [1291] = { total=3, base=4,  parent=1353, altid=nil, remap={ 1, 2, 3 } }, -- NH2: Royal Athenaeum
  [1292] = { total=3, base=7,  parent=1353, altid=nil, remap={ 1, 2, 3 } }, -- NH3: Nightspire
  [1293] = { total=1, base=10, parent=1353, altid=nil, remap={ 1 } }, -- NH4: Betrayer's Rise

  [1494] = { total=3, base=1, parent=1527, altid=nil, remap={ 1, 2, 3 } }, -- ToS1: The Gates of Hell (6/27/17)
  [1495] = { total=3, base=4, parent=1527, altid=nil, remap={ 1, 2, 3 } }, -- ToS2: Wailing Halls (7/11/17)
  [1496] = { total=2, base=7, parent=1527, altid=nil, remap={ 1, 2 } }, -- ToS3: Chamber of the Avatar (7/25/17)
  [1497] = { total=1, base=9, parent=1527, altid=nil, remap={ 1 } }, -- ToS4: Deceiver's Fall (8/8/17)

  [1610] = { total=3, base=1, parent=1642, altid=nil, remap={ 1, 2, 3 } }, -- Antorus: Light's Breach
  [1611] = { total=3, base=4, parent=1642, altid=nil, remap={ 1, 2, 3 } }, -- Antorus: Forbidden Descent
  [1612] = { total=3, base=7, parent=1642, altid=nil, remap={ 1, 2, 3 } }, -- Antorus: Hope's End
  [1613] = { total=2, base=10, parent=1642, altid=nil, remap={ 1, 2 } }, -- Antorus: Seat of the Pantheon

  -- Battle for Azeroth
  [1731] = { total=3, base=1, parent=1889, altid=nil, remap={ 1, 2, 3 } }, -- Uldir: Halls of Containment
  [1732] = { total=3, base=4, parent=1889, altid=nil, remap={ 1, 2, 3 } }, -- Uldir: Crimson Descent
  [1733] = { total=2, base=7, parent=1889, altid=nil, remap={ 1, 2 } },  -- Uldir: Heart of Corruption

  [1945] = { total=3, base=1, parent=1942, altid=nil, remap={ 1, 2, 3 } }, -- Battle of Dazar'alor: Alliance Wing 1
  [1946] = { total=3, base=4, parent=1942, altid=nil, remap={ 1, 2, 3 } }, -- Battle of Dazar'alor: Alliance Wing 2
  [1947] = { total=3, base=7, parent=1942, altid=nil, remap={ 1, 2, 3 } }, -- Battle of Dazar'alor: Alliance Wing 3

  [1948] = { total=3, base=1, parent=1942, altid=nil, remap={ 1, 2, 3 } }, -- Battle of Dazar'alor: Horde Wing 1
  [1949] = { total=3, base=4, parent=1942, altid=nil, remap={ 1, 2, 3 } }, -- Battle of Dazar'alor: Horde Wing 2
  [1950] = { total=3, base=7, parent=1942, altid=nil, remap={ 1, 2, 3 } }, -- Battle of Dazar'alor: Horde Wing 3

  [1951] = { total=2, base=1, parent=1952, altid=nil, remap={ 1, 2 } }, -- Crucible of Storms
}

local tmp = {}
for id, info in pairs(addon.LFRInstances) do
  tmp[id] = info
  if info.altid then
    tmp[info.altid] = info
  end
end
addon.LFRInstances = tmp
