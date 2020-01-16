local _, addon = ...
local LFRModule = addon.core:NewModule("LFR")

local locLevel = UnitLevel("player")
local locFaction = UnitFactionGroup("player")

local LFRInstances = {
  -- index is the id found in LFGDungeons.dbc or using the command below.
  -- /script local id,name; for i=1,GetNumRFDungeons() do id,name = GetRFDungeonInfo(i);print(i..". "..name.." ("..id..")");end
  -- total is boss count, base is boss offset,
  -- parent is instance name to use, GetLFGDungeonInfo() or using the command below.
  -- /run for i, v in ipairs(GetLFRChoiceOrder()) do print(i, v, GetLFGDungeonInfo(v)) end
  -- altid is for alternate LFRID for higher level toons, use the command below
  -- /run for i = 1, 1951 do local _, _, _, _, maxLvl = GetLFGDungeonInfo(i) if maxLvl == 255 then print(i, GetLFGDungeonInfo(i)) end end
  -- remap is the boss index different from increasing normally for current character
  -- origin is the remap of character that runs the LFR

  -- Cataclysm
  [416] = { total=4, base=1,  parent=448, minLvl=86,  altid=843 }, -- DS1: The Siege of Wyrmrest Temple
  [417] = { total=4, base=5,  parent=448, minLvl=86,  altid=844 }, -- DS2: Fall of Deathwing

  -- Mist of Pandaria
  [527] = { total=3, base=1,  parent=532, minLvl=91,  altid=830, remap={ 1, 2, 3 } }, -- MSV1: Guardians of Mogu'shan
  [528] = { total=3, base=4,  parent=532, minLvl=91,  altid=831, remap={ 1, 2, 3 } }, -- MSV2: The Vault of Mysteries

  [529] = { total=3, base=1,  parent=534, minLvl=91,  altid=832, remap={ 1, 2, 3 } }, -- HoF1: The Dread Approach
  [530] = { total=3, base=4,  parent=534, minLvl=91,  altid=833, remap={ 1, 2, 3 } }, -- HoF2: Nightmare of Shek'zeer

  [526] = { total=4, base=1,  parent=536, minLvl=91,  altid=834 }, -- TeS1: Terrace of Endless Spring

  [610] = { total=3, base=1,  parent=634, minLvl=91,  altid=835, remap={ 1, 2, 3 } }, -- ToT1: Last Stand of the Zandalari
  [611] = { total=3, base=4,  parent=634, minLvl=91,  altid=836, remap={ 1, 2, 3 } }, -- ToT2: Forgotten Depths
  [612] = { total=3, base=7,  parent=634, minLvl=91,  altid=837, remap={ 1, 2, 3 } }, -- ToT3: Halls of Flesh-Shaping
  [613] = { total=3, base=10, parent=634, minLvl=91,  altid=838, remap={ 1, 2, 3 } }, -- ToT4: Pinnacle of Storms

  [716] = { total=4, base=1,  parent=766, minLvl=91,  altid=839, remap={ 1, 2, 3, 4 } }, -- SoO1: Vale of Eternal Sorrows
  [717] = { total=4, base=5,  parent=766, minLvl=91,  altid=840, remap={ 1, 2, 3, 4 } }, -- SoO2: Gates of Retribution
  [724] = { total=3, base=9,  parent=766, minLvl=91,  altid=841, remap={ 1, 2, 3 } }, -- SoO3: The Underhold
  [725] = { total=3, base=12, parent=766, minLvl=91,  altid=842, remap={ 1, 2, 3 } }, -- SoO4: Downfall

  -- Warlords of Draenor
  [849] = { total=3, base=1,  parent=897, minLvl=101, altid=1363, remap={ 1, 2, 3 } }, -- Highmaul1: Walled City
  [850] = { total=3, base=4,  parent=897, minLvl=101, altid=1364, remap={ 1, 2, 3 } }, -- Highmaul2: Arcane Sanctum
  [851] = { total=1, base=7,  parent=897, minLvl=101, altid=1365, remap={ 1 } }, -- Highmaul3: Imperator's Rise

  [847] = { total=3, base=1,  parent=900, minLvl=101, altid=1361, remap={ 1, 2, 3 } }, -- BRF1: Slagworks
  [846] = { total=3, base=4,  parent=900, minLvl=101, altid=1360, remap={ 1, 2, 3 } }, -- BRF2: The Black Forge
  [848] = { total=3, base=7,  parent=900, minLvl=101, altid=1362, remap={ 1, 2, 3 } }, -- BRF3: Iron Assembly
  [823] = { total=1, base=10, parent=900, minLvl=101, altid=1359, remap={ 1 } }, -- BRF4: Blackhand's Crucible

  [982] = { total=3, base=1,  parent=989, minLvl=101, altid=1366, remap={ 1, 2, 3 } }, -- Hellfire1: Hellbreach
  [983] = { total=3, base=4,  parent=989, minLvl=101, altid=1367, remap={ 1, 2, 3 } }, -- Hellfire2: Halls of Blood
  [984] = { total=3, base=7,  parent=989, minLvl=101, altid=1368, remap={ 1, 2, 3 } }, -- Hellfire3: Bastion of Shadows
  [985] = { total=3, base=10, parent=989, minLvl=101, altid=1369, remap={ 1, 2, 3 } }, -- Hellfire4: Destructor's Rise
  [986] = { total=1, base=13, parent=989, minLvl=101, altid=1370, remap={ 1 } }, -- Hellfire5: The Black Gate

  -- Legion
  [1287] = { total=3, base=1,  parent=1350, minLvl=111, altid=1912, remap={ 1, 2, 3 } }, -- EN1: Darkbough
  [1288] = { total=3, base=4,  parent=1350, minLvl=111, altid=1927, remap={ 1, 2, 3 } }, -- EN2: Tormented Guardians
  [1289] = { total=1, base=7,  parent=1350, minLvl=111, altid=1926, remap={ 1 } },       -- EN3: Rift of Aln

  [1290] = { total=3, base=1,  parent=1353, minLvl=111, altid=1925, remap={ 1, 2, 3 } }, -- NH1: Arcing Aqueducts
  [1291] = { total=3, base=4,  parent=1353, minLvl=111, altid=1924, remap={ 1, 2, 3 } }, -- NH2: Royal Athenaeum
  [1292] = { total=3, base=7,  parent=1353, minLvl=111, altid=1923, remap={ 1, 2, 3 } }, -- NH3: Nightspire
  [1293] = { total=1, base=10, parent=1353, minLvl=111, altid=1922, remap={ 1 } }, -- NH4: Betrayer's Rise

  [1411] = { total=3, base=1,  parent=1439, minLvl=111, altid=1921 }, -- ToV

  [1494] = { total=3, base=1,  parent=1527, minLvl=111, altid=1920, remap={ 1, 2, 3 } }, -- ToS1: The Gates of Hell
  [1495] = { total=3, base=4,  parent=1527, minLvl=111, altid=1919, remap={ 1, 2, 3 } }, -- ToS2: Wailing Halls
  [1496] = { total=2, base=7,  parent=1527, minLvl=111, altid=1918, remap={ 1, 2 } }, -- ToS3: Chamber of the Avatar
  [1497] = { total=1, base=9,  parent=1527, minLvl=111, altid=1917, remap={ 1 } }, -- ToS4: Deceiver's Fall

  [1610] = { total=3, base=1,  parent=1642, minLvl=111, altid=1916, remap={ 1, 2, 3 } }, -- Antorus1: Light's Breach
  [1611] = { total=3, base=4,  parent=1642, minLvl=111, altid=1915, remap={ 1, 2, 3 } }, -- Antorus2: Forbidden Descent
  [1612] = { total=3, base=7,  parent=1642, minLvl=111, altid=1914, remap={ 1, 2, 3 } }, -- Antorus3: Hope's End
  [1613] = { total=2, base=10, parent=1642, minLvl=111, altid=1913, remap={ 1, 2 } }, -- Antorus4: Seat of the Pantheon

  -- Battle for Azeroth
  [1731] = { total=3, base=1,  parent=1889, minLvl=120, remap={ 1, 2, 3 } }, -- Uldir1: Halls of Containment
  [1732] = { total=3, base=4,  parent=1889, minLvl=120, remap={ 1, 2, 3 } }, -- Uldir2: Crimson Descent
  [1733] = { total=2, base=7,  parent=1889, minLvl=120, remap={ 1, 2 } },  -- Uldir3: Heart of Corruption

  [1945] = { total=3, base=1,  parent=1944, minLvl=120, remap={ 1, 2, 3 }, faction="Alliance" }, -- BoD1: Siege of Dazar'alor (Alliance)
  [1946] = { total=3, base=4,  parent=1944, minLvl=120, remap={ 1, 2, 3 }, faction="Alliance" }, -- BoD2: Empire's Fall (Alliance)
  [1947] = { total=3, base=7,  parent=1944, minLvl=120, remap={ 1, 2, 3 }, faction="Alliance" }, -- BoD3: Might of the Alliance (Alliance)

  [1948] = { total=3, base=1,  parent=1944, minLvl=120, remap={ 1, 2, 3 }, faction="Horde" }, -- BoD1: Defense of Dazar'alor (Horde)
  [1949] = { total=3, base=4,  parent=1944, minLvl=120, remap={ 1, 2, 3 }, faction="Horde" }, -- BoD2: Death's Bargain (Horde)
  [1950] = { total=3, base=7,  parent=1944, minLvl=120, remap={ 1, 2, 3 }, faction="Horde" }, -- BoD3: Victory or Death (Horde)

  [1951] = { total=2, base=1,  parent=1954, minLvl=120, remap={ 1, 2 } }, -- Crucible of Storms

  [2009] = { total=3, base=1,  parent=2016, minLvl=120, remap={ 1, 2, 3 } }, -- The Eternal Palace: The Grand Reception
  [2010] = { total=3, base=4,  parent=2016, minLvl=120, remap={ 1, 2, 3 } }, -- The Eternal Palace: Depths of the Devoted
  [2011] = { total=2, base=7,  parent=2016, minLvl=120, remap={ 1, 2 } }, -- The Eternal Palace: The Circle of Stars

  -- 15th Anniversary, 1911 is fake LFDID used by Escape from Tol Dagor
  [2004] = { total=1, base=1,  parent=1911, minLvl=120, remap={ 1 } }, -- Memories of Azeroth: Burning Crusade
  [2017] = { total=1, base=2,  parent=1911, minLvl=120, remap={ 1 } }, -- Memories of Azeroth: Wrath of the Lich King
  [2018] = { total=1, base=3,  parent=1911, minLvl=120, remap={ 1 } }, -- Memories of Azeroth: Cataclysm

  [2036] = { total=3, base=1,   parent=2035, minLvl=120, remap={ 1, 2, 3 } }, -- Ny'alotha: Vision of Destiny
  [2037] = { total=4, base=4,   parent=2035, minLvl=120, remap={ 1, 2, 3, 4 } }, -- Ny'alotha: Halls of Devotion
  [2038] = { total=3, base=8,   parent=2035, minLvl=120, remap={ 1, 2, 3 } }, -- Ny'alotha: Gift of Flesh
  [2039] = { total=2, base=11,  parent=2035, minLvl=120, remap={ 1, 2 } }, -- Ny'alotha: The Waking Dream
}

local tbl = {}
for id, info in pairs(LFRInstances) do
  if locLevel < info.minLvl or (info.faction and locFaction ~= info.faction) then
    info.origin = info.remap
    info.remap = nil
    if id == 847 then -- BRF1: Slagworks
      info.remap = { 1, 2, 7 }
    elseif id == 846 then -- BRF2: The Black Forge
      info.remap = { 3, 5, 8 }
    elseif id == 848 then -- BRF3: Iron Assembly
      info.remap = { 4, 6, 9 }
    elseif id == 984 then -- Hellfire3: Bastion of Shadows
      info.remap = { 7, 8,  11 }
    elseif id == 985 then -- Hellfire4: Destructor's Rise
      info.remap = { 9, 10, 12 }
    elseif (id == 1945 or id == 1948) and (info.faction and locFaction ~= info.faction) then -- Battle of Dazar'alor: Wing 1
      info.remap = {1, 3, 2}
    end
  end

  tbl[id] = info
  if info.altid then
    tbl[info.altid] = info
  end
end
addon.LFRInstances = tbl
