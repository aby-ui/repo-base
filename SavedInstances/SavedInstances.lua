local addonName, vars = ...
SavedInstances = vars
local addon = vars
local addonAbbrev = "SI"
vars.core = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
local core = vars.core
local L = vars.L
vars.LDB = LibStub("LibDataBroker-1.1", true)
vars.icon = vars.LDB and LibStub("LibDBIcon-1.0", true)

local QTip = LibStub("LibQTip-1.0")
local dataobject, db, config
local maxdiff = 23 -- max number of instance difficulties
local maxcol = 4 -- max columns per player+instance
local maxid = 2000 -- highest possible value for an instanceID, current max (Tomb of Sargeras) is 1676

-- local (optimal) references to provided functions
local table, math, bit, string, pairs, ipairs, unpack, strsplit, time, type, wipe, tonumber, select, strsub =
  table, math, bit, string, pairs, ipairs, unpack, strsplit, time, type, wipe, tonumber, select, strsub
local GetSavedInstanceInfo, GetNumSavedInstances, GetSavedInstanceChatLink, GetLFGDungeonNumEncounters, GetLFGDungeonEncounterInfo, GetNumRandomDungeons, GetLFGRandomDungeonInfo, GetLFGDungeonInfo, LFGGetDungeonInfoByID, GetLFGDungeonRewards, GetTime, UnitIsUnit, GetInstanceInfo, IsInInstance, SecondsToTime, GetQuestResetTime, GetGameTime, GetCurrencyInfo, GetNumGroupMembers =
  GetSavedInstanceInfo, GetNumSavedInstances, GetSavedInstanceChatLink, GetLFGDungeonNumEncounters, GetLFGDungeonEncounterInfo, GetNumRandomDungeons, GetLFGRandomDungeonInfo, GetLFGDungeonInfo, LFGGetDungeonInfoByID, GetLFGDungeonRewards, GetTime, UnitIsUnit, GetInstanceInfo, IsInInstance, SecondsToTime, GetQuestResetTime, GetGameTime, GetCurrencyInfo, GetNumGroupMembers

-- local (optimal) references to Blizzard's strings
local RAID_CLASS_COLORS = RAID_CLASS_COLORS
local RAID_FINDER = PLAYER_DIFFICULTY3
local FONTEND = FONT_COLOR_CODE_CLOSE
local GOLDFONT = NORMAL_FONT_COLOR_CODE
local YELLOWFONT = LIGHTYELLOW_FONT_COLOR_CODE
local REDFONT = RED_FONT_COLOR_CODE
local GREENFONT = GREEN_FONT_COLOR_CODE
local WHITEFONT = HIGHLIGHT_FONT_COLOR_CODE
local GRAYFONT = GRAY_FONT_COLOR_CODE
local GRAY_COLOR = { 0.5, 0.5, 0.5, 1 }
local LFD_RANDOM_REWARD_EXPLANATION2 = LFD_RANDOM_REWARD_EXPLANATION2
local INSTANCE_SAVED, TRANSFER_ABORT_TOO_MANY_INSTANCES, NO_RAID_INSTANCES_SAVED =
  INSTANCE_SAVED, TRANSFER_ABORT_TOO_MANY_INSTANCES, NO_RAID_INSTANCES_SAVED

local ALREADY_LOOTED = ERR_LOOT_GONE:gsub("%(.*%)","")

local UnitAura = UnitAura
-- Unit Aura functions that return info about the first Aura matching the spellName or spellID given on the unit.
local SI_GetUnitAura = function(unit, spell, filter)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, i, filter)
        if not name then return end
        if spell == spellId or spell == name then
            return UnitAura(unit, i, filter)
        end
    end
end

local SI_GetUnitBuff = function(unit, spell, filter)
    return SI_GetUnitAura(unit, spell, filter)
end

local SI_GetUnitDebuff = function(unit, spell, filter)
    filter = filter and filter.."|HARMFUL" or "HARMFUL"
    return SI_GetUnitAura(unit, spell, filter)
end

vars.Indicators = {
  ICON_STAR = ICON_LIST[1] .. "16:16:0:0|t",
  ICON_CIRCLE = ICON_LIST[2] .. "16:16:0:0|t",
  ICON_DIAMOND = ICON_LIST[3] .. "16:16:0:0|t",
  ICON_TRIANGLE = ICON_LIST[4] .. "16:16:0:0|t",
  ICON_MOON = ICON_LIST[5] .. "16:16:0:0|t",
  ICON_SQUARE = ICON_LIST[6] .. "16:16:0:0|t",
  ICON_CROSS = ICON_LIST[7] .. "16:16:0:0|t",
  ICON_SKULL = ICON_LIST[8] .. "16:16:0:0|t",
  BLANK = "None",
}

local KeystoneAbbrev = {
  [197] = L["EoA"],
  [198] = L["DHT"],
  [199] = L["BRH"],
  [200] = L["HoV"],
  [206] = L["Nelt"],
  [207] = L["VotW"],
  [208] = L["MoS"],
  [209] = L["Arc"],
  [210] = L["CoS"],
  [227] = L["L Kara"],
  [233] = L["CoEN"],
  [234] = L["U Kara"],
  [239] = L["SotT"],
}

local KeystonetoAbbrev = {
  ["Eye of Azshara"] = L["EoA"],
  ["Darkheart Thicket"] = L["DHT"],
  ["Black Rook Hold"] = L["BRH"],
  ["Halls of Valor"] = L["HoV"],
  ["Neltharion's Lair"] = L["Nelt"],
  ["Vault of the Wardens"] = L["VotW"],
  ["Maw of Souls"] = L["MoS"],
  ["The Arcway"] = L["Arc"],
  ["Court of Stars"] = L["CoS"],
  ["Return to Karazhan: Lower"] = L["L Kara"],
  ["Cathedral of Eternal Night"] = L["CoEN"],
  ["Return to Karazhan: Upper"] = L["U Kara"],
  ["Seat of the Triumvirate"] = L["SotT"],
}

vars.Categories = { }
local maxExpansion
for i = 0,10 do
  local ename = _G["EXPANSION_NAME"..i]
  if ename then
    maxExpansion = i
    vars.Categories["D"..i] = ename .. ": " .. LFG_TYPE_DUNGEON
    vars.Categories["R"..i] = ename .. ": " .. LFG_TYPE_RAID
  else
    break
  end
end

local tooltip, indicatortip
local thisToon = UnitName("player") .. " - " .. GetRealmName()
local maxlvl = MAX_PLAYER_LEVEL_TABLE[#MAX_PLAYER_LEVEL_TABLE]
local scantt = CreateFrame("GameTooltip", "SavedInstancesScanTooltip", UIParent, "GameTooltipTemplate")

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

addon.LFRInstances = {
  -- index is the id found in LFGDungeons.dbc or using the command below.
  -- /script local id,name; for i=1,GetNumRFDungeons() do id,name = GetRFDungeonInfo(i);print(i..". "..name.." ("..id..")");end
  -- total is boss count, base is boss offset,
  -- parent is instance name to use, GetLFGDungeonInfo() or using the command below.
  -- /run for i, v in ipairs(GetLFRChoiceOrder()) do print(i, v, GetLFGDungeonInfo(v)) end
  -- altid is for alternate LFRID for higher level toons

  [416] = { total=4, base=1,  parent=448, altid=843 }, -- DS1: The Siege of Wyrmrest Temple
  [417] = { total=4, base=5,  parent=448, altid=844 }, -- DS2: Fall of Deathwing

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
}

local tmp = {}
for id, info in pairs(addon.LFRInstances) do
  tmp[id] = info
  if info.altid then
    tmp[info.altid] = info
  end
end
addon.LFRInstances = tmp

addon.WorldBosses = {
  -- encounter index is embedded in the Hjournal hyperlink
  [691] = { quest=32099, expansion=4, level=90 }, -- Sha of Anger
  [725] = { quest=32098, expansion=4, level=90 }, -- Galleon
  [814] = { quest=32518, expansion=4, level=90 }, -- Nalak
  [826] = { quest=32519, expansion=4, level=90 }, -- Oondasta
  [857] = { quest=33117, expansion=4, level=90, name=L["The Four Celestials"]  }, -- Chi-Ji
  --[858] = { quest=nil, expansion=4, level=90 }, -- Yu'lon
  --[859] = { quest=nil, expansion=4, level=90 }, -- Niuzao
  --[860] = { quest=nil, expansion=4, level=90 }, -- Xuen
  [861] = { quest=nil,   expansion=4, level=90 }, -- Ordos

  --[[
  [1291] = { quest=37460,  expansion=5, level=100 }, -- Drov the Ruiner
  [1211] = { quest=37462,  expansion=5, level=100 }, -- Tarlna the Ageless
  --]]
  [1211] = { quest=37462,  expansion=5, level=100, -- Drov/Tarlna share a loot and quest atm
    name=select(2,EJ_GetCreatureInfo(1,1291)):match("^[^ ]+").." / "..
    select(2,EJ_GetCreatureInfo(1,1211)):match("^[^ ]+")},
  [1291] = { remove=true }, -- Drov cleanup

  [1262] = { quest=37464, expansion=5, level=100 }, -- Rukhmar
  [1452] = { quest=39380, expansion=5, level=100 }, -- Kazzak

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

  -- bosses with no EJ entry (eid is a placeholder)
  [9001] = { quest=38276, name=GARRISON_LOCATION_TOOLTIP.." "..BOSS, expansion=5, level=100 },
  [9002] = { quest=47461, name="Lord Kazzak", expansion=6, level=110},          -- Lord Kazzak (13th Anniversary)
  [9003] = { quest=47462, name="Azuregos", expansion=6, level=110},             -- Azuregos (13th Anniversary)
  [9004] = { quest=47463, name="Dragon of Nightmare", expansion=6, level=110},  -- Dragon of Nightmare (13th Anniversary)
}

local _specialQuests = {
  -- Isle of Thunder
  [32610] = { zid=504, lid=94221 }, -- Shan'ze Ritual Stone looted
  [32611] = { zid=504, lid1=95350 },-- Incantation of X looted
  [32626] = { zid=504, lid=94222 }, -- Key to the Palace of Lei Shen looted
  [32609] = { zid=504, aid=8104, aline="Left5"  }, -- Trove of the Thunder King (outdoor chest)
  -- Timeless Isle
  [32962] = { zid=554, aid=8743, daily=true },  -- Zarhym
  [32961] = { zid=554, daily=true },  -- Scary Ghosts and Nice Sprites
  [32956] = { zid=554, aid=8727, acid=2, aline="Right7" }, -- Blackguard's Jetsam
  [32957] = { zid=554, aid=8727, acid=1, aline="Left7" },  -- Sunken Treasure
  [32970] = { zid=554, aid=8727, acid=3, aline="Left8" },  -- Gleaming Treasure Satchel
  [32968] = { zid=554, aid=8726, acid=2, aline="Right7" }, -- Rope-Bound Treasure Chest
  [32969] = { zid=554, aid=8726, acid=1, aline="Left7" },  -- Gleaming Treasure Chest
  [32971] = { zid=554, aid=8726, acid=3, aline="Left8" },  -- Mist-Covered Treasure Chest
  -- Garrison
  [37638] = { zone=GARRISON_LOCATION_TOOLTIP, aid=9162 }, -- Bronze Defender
  [37639] = { zone=GARRISON_LOCATION_TOOLTIP, aid=9164 }, -- Silver Defender
  [37640] = { zone=GARRISON_LOCATION_TOOLTIP, aid=9165 }, -- Golden Defender
  [38482] = { zone=GARRISON_LOCATION_TOOLTIP, aid=9826 }, -- Platinum Defender
  -- Tanaan Jungle
  [39287] = { zid=534, daily=true }, -- Deathtalon
  [39288] = { zid=534, daily=true }, -- Terrorfist
  [39289] = { zid=534, daily=true }, -- Doomroller
  [39290] = { zid=534, daily=true }, -- Vengeance
  -- Order Hall
  [42481] = { zid=717, daily=true }, -- Warlock: Ritual of Doom
  [44707] = { zid=719, daily=true, sid=228651 }, -- Demon Hunter: Twisting Nether
}

function addon:specialQuests()
  for qid, qinfo in pairs(_specialQuests) do
    qinfo.quest = qid

    if not qinfo.name and (qinfo.lid or qinfo.lid1) then
      local itemname, itemlink = GetItemInfo(qinfo.lid or qinfo.lid1)
      if itemlink and qinfo.lid then
        qinfo.name = itemlink.." ("..LOOT..")"
      elseif itemname and qinfo.lid1 then
        local name = itemname:match("^[^%s]+")
        if name and #name > 0 then
          qinfo.name = name.." ("..LOOT..")"
        end
      end
    elseif not qinfo.name and qinfo.aid and qinfo.acid then
      local l = GetAchievementCriteriaInfo(qinfo.aid, qinfo.acid)
      if l then
        qinfo.name = l:gsub("%p$","")
      end
    elseif not qinfo.name and qinfo.aid then
      scantt:SetOwner(UIParent,"ANCHOR_NONE")
      scantt:SetAchievementByID(qinfo.aid)
      local l = _G[scantt:GetName().."Text"..(qinfo.aline or "Left1")]
      l = l and l:GetText()
      if l then
        qinfo.name = l:gsub("%p$","")
      end
    elseif not qinfo.name and qinfo.sid then
      qinfo.name = GetSpellInfo(qinfo.sid)
    end
    if not qinfo.name or #qinfo.name == 0 then
      local title, link = addon:QuestInfo(qid)
      if title then
        title = title:gsub("%p?%s*[Tt]racking%s*[Qq]uest","")
        title = strtrim(title)
        qinfo.name = title
      end
    end

    if not qinfo.zone and qinfo.zid then
      qinfo.zone = C_Map.GetMapInfo(qinfo.zid).name
    end
  end

  return _specialQuests
end

local QuestExceptions = {
  -- some quests are misidentified in scope
  [7905]  = "Regular", -- Darkmoon Faire referral -- old addon versions misidentified this as monthly
  [7926]  = "Regular", -- Darkmoon Faire referral
  [37819] = "Regular", -- Darkmoon Faire races referral

  -- order hall quests that old addon versions misidentified as weekly (fixed in r548/7.0.8)
  [44226] = "Regular", -- Order Hall: DH
  [44235] = "Regular", -- Order Hall: Druid
  [44236] = "Regular", -- Order Hall: Druid?
  [44212] = "Regular", -- Order Hall: Hunter
  [44208] = "Regular", -- Order Hall: Mage
  [44238] = "Regular", -- Order Hall: Monk
  [44219] = "Regular", -- Order Hall: Paladin
  [44230] = "Regular", -- Order Hall: Priest
  [44204] = "Regular", -- Order Hall: Rogue
  [44205] = "Regular", -- Order Hall: Shaman

  [31752] = "AccountDaily", -- Blingtron
  [34774] = "AccountDaily", -- Blingtron 5000
  [40753] = "AccountDaily", -- Blingtron 6000
  -- also pre-populate a few important quests
  [32640] = "Weekly",  -- Champions of the Thunder King
  [32641] = "Weekly",  -- Champions of the Thunder King
  [32718] = "Regular",  -- Mogu Runes of Fate -- ticket 142: outdated quest flag still shows up
  [32719] = "Regular",  -- Mogu Runes of Fate
  [33133] = "Regular",  -- Warforged Seals outdated quests, no longer weekly
  [33134] = "Regular",  -- Warforged Seals
  [33338] = "Weekly",  -- Empowering the Hourglass
  [33334] = "Weekly",  -- Strong Enough to Survive

  -- From Archmage Timear -
  [44164] = "Weekly", -- A Burning Path Through Time - Burning Crusade Timewalking
  [44166] = "Weekly", -- A Frozen Path Through Time - Wrath of the Lich King Timewalking
  [44167] = "Weekly", -- A Shattered Path Through Time - Cataclysm Timewalking
  [44171] = "Weekly", -- Emisary of War - Complete Legion Mythics
  [44172] = "Weekly", -- The Arena Calls - Win Legion Arena Skirmishes
  [44173] = "Weekly", -- A Call to Battle - Win Battlegrounds
  [44174] = "Weekly", -- The Very Best - Win PvP Pet Battles
  [44175] = "Weekly", -- The World Awaits - Complete Broken Isles World Quests
  [45799] = "Weekly", -- A Shrouded Path Through Time - Mists of Pandaria Timewalking

  -- Pet Battle Dungeons
  [46292] = "Weekly", -- Pet Battle Challenge Dungeon Deadmines
  [45539] = "Weekly", -- Pet Battle Challenge Dungeon Wailing Caverns

  -- Argus
  [48910] = "Weekly", -- Supplying Krokuun
  [48911] = "Weekly", -- Void Inoculation
  [48912] = "Weekly", -- Supplying the Antoran Campaign
}

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
  [43510] = "Weekly", -- order hall
  [47851] = "Weekly", -- Mark of Honor x5
  [47864] = "Weekly", -- Mark of Honor x10
  [47865] = "Weekly", -- Mark of Honor x20
}

for k,v in pairs(LegionSealQuests) do
  QuestExceptions[k] = v
end

function addon:QuestInfo(questid)
  if not questid or questid == 0 then return nil end
  scantt:SetOwner(UIParent,"ANCHOR_NONE")
  scantt:SetHyperlink("\124cffffff00\124Hquest:"..questid..":90\124h[]\124h\124r")
  local l = _G[scantt:GetName().."TextLeft1"]
  l = l and l:GetText()
  if not l or #l == 0 then return nil end -- cache miss
  return l, "\124cffffff00\124Hquest:"..questid..":90\124h["..l.."]\124h\124r"
end

local function chatMsg(...)
  DEFAULT_CHAT_FRAME:AddMessage("\124cFFFF0000"..addonName.."\124r: "..string.format(...))
end
addon.chatMsg = chatMsg

local function debug(...)
  --addon.db.dbg = true
  if addon.db.dbg then
    chatMsg(...)
  end
end
addon.debug = debug

local function bugReport(msg)
  addon.bugreport = addon.bugreport or {}
  local now = GetTime()
  if now < (addon.bugreport[msg] or 0)+60 then return end
  addon.bugreport[msg] = now
  chatMsg(msg)
  if now < (addon.bugreport["url"] or 0)+5 then return end
  chatMsg("Please report this bug at: https://github.com/SavedInstances/SavedInstances/issues")
  addon.bugreport["url"] = now
end

local GTToffset = time() - GetTime()
local function GetTimeToTime(val)
  if not val then return nil end
  return val + GTToffset
end

function addon:timedebug()
  chatMsg("Version: %s (%s)", addon.version, addon.revision)
  chatMsg("Realm: %s (%s)", GetRealmName(), addon:GetRegion())
  chatMsg("Zone: %s (%s)", GetRealZoneText(), addon:GetCurrentMapAreaID())
  chatMsg("time()=%s GetTime()=%s", time(), GetTime())
  chatMsg("Local time: %s local", date("%A %c"))
  chatMsg("GetGameTime: %s:%s server",GetGameTime())
  chatMsg("C_Calendar.GetDate: %s %s/%s/%s server",C_Calendar.GetDate())
  chatMsg("GetQuestResetTime: %s",SecondsToTime(GetQuestResetTime()))
  chatMsg(date("Daily reset: %a %c local (based on GetQuestResetTime)",time()+GetQuestResetTime()))
  chatMsg("Local to server offset: %d hours",SavedInstances:GetServerOffset())
  local t = SavedInstances:GetNextDailyResetTime()
  chatMsg("Next daily reset: %s local, %s server",date("%a %c",t), date("%a %c",t+3600*SavedInstances:GetServerOffset()))
  t = SavedInstances:GetNextWeeklyResetTime()
  chatMsg("Next weekly reset: %s local, %s server",date("%a %c",t), date("%a %c",t+3600*SavedInstances:GetServerOffset()))
  t = SavedInstances:GetNextDailySkillResetTime()
  chatMsg("Next skill reset: %s local, %s server",date("%a %c",t), date("%a %c",t+3600*SavedInstances:GetServerOffset()))
  t = SavedInstances:GetNextDarkmoonResetTime()
  chatMsg("Next Darkmoon reset: %s local, %s server",date("%a %c",t), date("%a %c",t+3600*SavedInstances:GetServerOffset()))
end

local function questTableToString(t)
  local ret = ""
  local lvl = UnitLevel("player")
  for k,v in pairs(t) do
    ret = string.format("%s%s\124cffffff00\124Hquest:%s:%s\124h[%s]\124h\124r", ret, (#ret == 0 and "" or ", "),k,lvl,k)
  end
  return ret
end

function addon:questdebug(info)
  local t = vars.db.Toons[thisToon]
  local ql = GetQuestsCompleted()

  local cmd = info.input
  cmd = cmd and strtrim(cmd:gsub("^%s*(%w+)%s*","")):lower()
  if t.completedquests and (cmd == "load" or not addon.completedquests) then
    chatMsg("Loaded quest list")
    addon.completedquests = t.completedquests
  elseif cmd == "load" then
    chatMsg("No saved quest list")
  elseif cmd == "save" then
    chatMsg("Saved quest list")
    t.completedquests = ql
  elseif cmd == "clear" then
    chatMsg("Cleared quest list")
    addon.completedquests = nil
    t.completedquests = nil
    return
  elseif cmd and #cmd > 0 then
    chatMsg("Quest command not understood: '"..cmd.."'")
    chatMsg("/si quest ([save|load|clear])")
    return
  end
  local cnt = 0
  local add = {}
  local remove = {}
  for id,_ in pairs(ql) do
    cnt = cnt + 1
  end
  chatMsg("Completed quests: "..cnt)
  if addon.completedquests then
    for id,_ in pairs(ql) do
      if not addon.completedquests[id] then
        add[id] = true
      end
    end
    for id,_ in pairs(addon.completedquests) do
      if not ql[id] then
        remove[id] = true
      end
    end
    if next(add) then chatMsg("Added IDs:   "..questTableToString(add)) end
    if next(remove) then chatMsg("Removed IDs: "..questTableToString(remove)) end
  end
  addon.completedquests = ql
end

-- abbreviate expansion names (which apparently are not localized in any western character set)
local function abbreviate(iname)
  iname = iname:gsub("Burning Crusade", "BC")
  iname = iname:gsub("Wrath of the Lich King", "WotLK")
  iname = iname:gsub("Cataclysm", "Cata")
  iname = iname:gsub("Mists of Pandaria", "MoP")
  iname = iname:gsub("Warlords of Draenor", "WoD")

  return iname
end

function addon:formatNumber(num, ismoney)
  num = tonumber(num)
  if not num then return "" end
  local post = ""
  if ismoney then
    if num < 1000*10000 then -- less than 1k, show it all
      return GetMoneyString(num)
    end
    num = math.floor(num / 10000)
    post = " \124TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0\124t"
  end
  if vars.db.Tooltip.NumberFormat then
    local str = ""
    local neg = num < 0
    num = math.abs(num)
    local int = math.floor(num)
    local dec = num - int
    local t = tostring(int)
    if #t > 4 then -- leave 4 digit numbers
      while #t > 3 do
        str = LARGE_NUMBER_SEPERATOR .. t:sub(-3) .. str
        t = t:sub(1,-4)
    end
    end
    str = t..str
    if dec > 0 then
      str = str..string.format("%15g",dec):match("(%..*)$")
    end
    if neg then
      str = "-"..str
    end
    return str..post
  else
    return num..post
  end
end

vars.defaultDB = {
  DBVersion = 12,
  History = { }, -- for tracking 5 instance per hour limit
  -- key: instance string; value: time first entered
  Toons = { }, 	-- table key: "Toon - Realm"; value:
  -- Class: string
  -- Level: integer
  -- AlwaysShow: boolean REMOVED
  -- Show: string "always", "never", "saved"
  -- Daily1: expiry (normal) REMOVED
  -- Daily2: expiry (heroic) REMOVED
  -- LFG1: expiry (random dungeon)
  -- LFG2: expiry (deserter)
  -- WeeklyResetTime: expiry
  -- DailyResetTime: expiry
  -- DailyCount: integer REMOVED
  -- PlayedLevel: integer
  -- PlayedTotal: integer
  -- Money: integer
  -- Zone: string

  -- currency: key: currencyID  value:
  -- amount: integer
  -- earnedThisWeek: integer
  -- weeklyMax: integer
  -- totalMax: integer
  -- season: integer

  -- Quests:  key: QuestID  value:
  -- Title: string
  -- Link: hyperlink
  -- Zone: string
  -- isDaily: boolean
  -- Expires: expiration (non-daily)

  -- Skills: key: SpellID or CDID value:
  -- Title: string
  -- Link: hyperlink
  -- Expires: expiration

  -- FarmPlanted: integer
  -- FarmHarvested: integer
  -- FarmCropPlanted: key: spellID value: count
  -- FarmCropReady: key: spellID value: count
  -- FarmExpires: expiration

  -- BonusRoll: key: int value:
  -- name: string
  -- time: int
  -- currencyID: int
  -- money: integer or nil
  -- item: linkstring or nil

  -- MythicKey
  -- name: string
  -- ResetTime: expiry
  -- level: string
  -- color: string
  -- link: string
  -- MythicKeyBest
  -- lastweeklevel: int
  -- ResetTime: expiry
  -- level: string
  -- weeklyReward: boolean
  -- DailyWorldQuest
  -- days[0,1,2]
  -- name
  -- dayleft
  -- questneed
  -- questdone

  Indicators = {
    D1Indicator = "BLANK", -- indicator: ICON_*, BLANK
    D1Text = "KILLED/TOTAL",
    D1Color = { 0, 0.6, 0 }, -- dark green
    D1ClassColor = true,
    D2Indicator = "BLANK",
    D2Text = "KILLED/TOTALH",
    D2Color = { 0, 1, 0 }, -- green
    D2ClassColor = true,
    D3Indicator = "BLANK",
    D3Text = "KILLED/TOTALM",
    D3Color = { 1, 0, 0 }, -- red
    D3ClassColor = true,
    R0Indicator = "BLANK",
    R0Text = "KILLED/TOTAL",
    R0Color = { 0.6, 0.6, 0 }, -- dark yellow
    R0ClassColor = true,
    R1Indicator = "BLANK",
    R1Text = "KILLED/TOTAL",
    R1Color = { 0.6, 0.6, 0 }, -- dark yellow
    R1ClassColor = true,
    R2Indicator = "BLANK",
    R2Text = "KILLED/TOTAL",
    R2Color = { 0.6, 0, 0 }, -- dark red
    R2ClassColor = true,
    R3Indicator = "BLANK",
    R3Text = "KILLED/TOTALH",
    R3Color = { 1, 1, 0 }, -- yellow
    R3ClassColor = true,
    R4Indicator = "BLANK",
    R4Text = "KILLED/TOTALH",
    R4Color = { 1, 0, 0 }, -- red
    R4ClassColor = true,
    R5Indicator = "BLANK",
    R5Text = "KILLED/TOTAL",
    R5Color = { 0, 0, 1 }, -- blue
    R5ClassColor = true,
    R6Indicator = "BLANK",
    R6Text = "KILLED/TOTAL",
    R6Color = { 0, 1, 0 }, -- green
    R6ClassColor = true,
    R7Indicator = "BLANK",
    R7Text = "KILLED/TOTALH",
    R7Color = { 1, 1, 0 }, -- yellow
    R7ClassColor = true,
    R8Indicator = "BLANK",
    R8Text = "KILLED/TOTALM",
    R8Color = { 1, 0, 0 }, -- red
    R8ClassColor = true,
  },
  Tooltip = {
    ReverseInstances = false,
    ShowExpired = false,
    ShowHoliday = true,
    ShowRandom = true,
    CombineWorldBosses = false,
    CombineLFR = true,
    TrackDailyQuests = true,
    TrackWeeklyQuests = true,
    ShowCategories = false,
    CategorySpaces = false,
    RowHighlight = 0.1,
    Scale = 1,
    FitToScreen = true,
    NewFirst = true,
    RaidsFirst = true,
    NumberFormat = true,
    CategorySort = "EXPANSION", -- "EXPANSION", "TYPE"
    ShowSoloCategory = false,
    ShowHints = true,
    ReportResets = true,
    LimitWarn = true,
    HistoryText = false,
    ShowServer = false,
    ServerSort = true,
    ServerOnly = false,
    ConnectedRealms = "group",
    SelfFirst = true,
    SelfAlways = false,
    TrackLFG = true,
    TrackDeserter = true,
    TrackSkills = true,
    TrackFarm = true,
    TrackBonus = false,
    TrackPlayed = true,
    AugmentBonus = true,
    CurrencyValueColor = true,
    Currency776 = false, -- Warforged Seals
    Currency738 = false, -- Lesser Charm of Good Fortune
    Currency823 = false,  -- Apexis Crystal
    Currency824 = false,  -- Garrison Resources
    Currency1101= false,  -- Oil
    Currency994 = false, -- Seal of Tempered Fate
    Currency1129= false, -- Seal of Inevitable Fate
    Currency1155= true,  -- Ancient Mana
    Currency1166= true,  -- Timewarped Badge
    Currency1191= true,  -- Valor Points
    Currency1220= true,  -- Order Resources
    Currency1226= false, -- Nethershards
    Currency1273= true,  -- Seal of Broken Fate
    Currency1149= true,  -- Sightless Eye
    CurrencyMax = false,
    CurrencyEarned = true,
    MythicKey = true,
    MythicKeyBest = true,
    DailyWorldQuest = true,
    AbbreviateKeystone = true,
  },
  Instances = { }, 	-- table key: "Instance name"; value:
  -- Show: boolean
  -- Raid: boolean
  -- Holiday: boolean
  -- Random: boolean
  -- Expansion: integer
  -- RecLevel: integer
  -- LFDID: integer
  -- LFDupdated: integer REMOVED
  -- REMOVED Encounters[integer] = { GUID : integer, Name : string }
  -- table key: "Toon - Realm"; value:
  -- table key: "Difficulty"; value:
  -- ID: integer, positive for a Blizzard Raid ID,
  --  negative value for an LFR encounter count
  -- Expires: integer
  -- Locked: boolean, whether toon is locked to the save
  -- Extended: boolean, whether this is an extended raid lockout
  -- Link: string hyperlink to the save
  -- 1..numEncounters: boolean LFR isLooted
  MinimapIcon = { hide = false },
  Quests = {},  -- Account-wide Quests:  key: QuestID  value: same as toon Quest database
  QuestDB = {   -- permanent repeatable quest DB: key: questid  value: mapid
    Daily = {},
    Weekly = {},
    Darkmoon = {},
    AccountDaily = {},
    AccountWeekly = {},
  },
  RealmMap = {},
}

-- skinning support
-- skinning addons should hook this function, eg:
--   hooksecurefunc(SavedInstances,"SkinFrame",function(self,frame,name) frame:SetWhatever() end)
function addon:SkinFrame(frame,name)
  -- default behavior (ticket 81)
  if IsAddOnLoaded("ElvUI") or IsAddOnLoaded("Tukui") then
    if frame.StripTextures then
      frame:StripTextures()
    end
    if frame.SetTemplate then
      frame:SetTemplate("Transparent")
    end
    local close = _G[name.."CloseButton"] or frame.CloseButton
    if close and close.SetAlpha then
      if ElvUI then
        ElvUI[1]:GetModule('Skins'):HandleCloseButton(close)
      end
      if Tukui and Tukui[1] and Tukui[1].SkinCloseButton then
        Tukui[1].SkinCloseButton(close)
      end
      close:SetAlpha(1)
    end
  end
end

-- general helper functions below

local function ColorCodeOpenRGB(r,g,b,a)
  return format("|c%02x%02x%02x%02x", math.floor(a * 255), math.floor(r * 255), math.floor(g * 255), math.floor(b * 255))
end

local function ColorCodeOpen(color)
  return ColorCodeOpenRGB(color[1] or color.r,
    color[2] or color.g,
    color[3] or color.b,
    color[4] or color.a or 1)
end

local function ClassColorise(class, targetstring)
  local c = (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class]) or RAID_CLASS_COLORS[class]
  if c.colorStr then
    c = "|c"..c.colorStr
  else
    c = ColorCodeOpen( c )
  end
  return c .. targetstring .. FONTEND
end

function addon.ColoredToon(toon, fullname)
  local str = (fullname and toon) or strsplit(' ',toon)
  local t = vars.db.Toons[toon]
  local class = t and t.Class
  if class then
    return ClassColorise(class, str)
  else
    return str
  end
end

local function CurrencyColor(amt, max)
  amt = amt or 0
  local samt = addon:formatNumber(amt)
  if max == nil or max == 0 then
    return samt
  end
  if vars.db.Tooltip.CurrencyValueColor then
    local pct = amt / max
    local color = GREENFONT
    if pct == 1 then
      color = REDFONT
    elseif pct > 0.75 then
      color = GOLDFONT
    end
    samt = color .. samt .. FONTEND
  end
  return samt
end

local function TableLen(table)
  local i = 0
  for _, _ in pairs(table) do
    i = i + 1
  end
  return i
end

-- returns how many hours the server time is ahead of local time
-- convert local time -> server time: add this value
-- convert server time -> local time: subtract this value
function addon:GetServerOffset()
  local serverDate = C_Calendar.GetDate()
  local serverDay, serverWeekday, serverMonth, serverMinute, serverHour, serverYear = serverDate.monthDay, serverDate.weekday, serverDate.month, serverDate.minute, serverDate.hour, serverDate.year
  local localDay = tonumber(date("%w")) -- 0-based starts on Sun
  local localHour, localMinute = tonumber(date("%H")), tonumber(date("%M"))
  if serverDay == (localDay + 1)%7 then -- server is a day ahead
    serverHour = serverHour + 24
  elseif localDay == (serverDay + 1)%7 then -- local is a day ahead
    localHour = localHour + 24
  end
  local server = serverHour + serverMinute / 60
  local localT = localHour + localMinute / 60
  local offset = floor((server - localT) * 2 + 0.5) / 2
  return offset
end

function addon:GetRegion()
  if not addon.region then
    local reg
    reg = GetCVar("portal")
    if reg == "public-test" then -- PTR uses US region resets, despite the misleading realm name suffix
      reg = "US"
    end
    if not reg or #reg ~= 2 then
      local gcr = GetCurrentRegion()
      reg = gcr and ({ "US", "KR", "EU", "TW", "CN" })[gcr]
    end
    if not reg or #reg ~= 2 then
      reg = (GetCVar("realmList") or ""):match("^(%a+)%.")
    end
    if not reg or #reg ~= 2 then -- other test realms?
      reg = (GetRealmName() or ""):match("%((%a%a)%)")
    end
    reg = reg and reg:upper()
    if reg and #reg == 2 then
      addon.region = reg
    end
  end
  return addon.region
end

function addon:GetNextDailyResetTime()
  local resettime = GetQuestResetTime()
  if not resettime or resettime <= 0 or -- ticket 43: can fail during startup
    -- also right after a daylight savings rollover, when it returns negative values >.<
    resettime > 24*3600+30 then -- can also be wrong near reset in an instance
    return nil
  end

  return time() + resettime
end

do
  local midnight = {hour=23, min=59, sec=59}
  function addon:GetNextDailySkillResetTime() -- trade skill reset time
    -- this is just a "best guess" because in reality,
    -- different trade skills reset at up to 3 different times
    local rt = addon:GetNextDailyResetTime()
    if not rt then return nil end
    --local info = date("*t"); print(info.isdst)
    -- Blizzard's ridiculous reset crap:
    -- trade skills ignore daylight savings after the date it changes UNTIL the next restart, then go back to observing it

    return rt
  end
end

function addon:GetNextWeeklyResetTime()
  if not addon.resetDays then
    local region = addon:GetRegion()
    if not region then return nil end
    addon.resetDays = {}
    addon.resetDays.DLHoffset = 0
    if region == "US" then
      addon.resetDays["2"] = true -- tuesday
      -- ensure oceanic servers over the dateline still reset on tues UTC (wed 1/2 AM server)
      addon.resetDays.DLHoffset = -3
    elseif region == "EU" then
      addon.resetDays["3"] = true -- wednesday
    elseif region == "CN" or region == "KR" or region == "TW" then -- XXX: codes unconfirmed
      addon.resetDays["4"] = true -- thursday
    else
      addon.resetDays["2"] = true -- tuesday?
    end
  end
  local offset = (addon:GetServerOffset() + addon.resetDays.DLHoffset) * 3600
  local nightlyReset = addon:GetNextDailyResetTime()
  if not nightlyReset then return nil end
  --while date("%A",nightlyReset+offset) ~= WEEKDAY_TUESDAY do
  while not addon.resetDays[date("%w",nightlyReset+offset)] do
    nightlyReset = nightlyReset + 24 * 3600
  end

  return nightlyReset
end

do
  local dmf_end = {hour=23, min=59}
  function addon:GetNextDarkmoonResetTime()
    -- Darkmoon faire runs from first Sunday of each month to following Saturday
    -- this function returns an approximate time after the end of the current month's faire
    local monthInfo = C_Calendar.GetMonthInfo();
    local firstweekday = monthInfo.firstWeekday
    local firstsunday = ((firstweekday == 1) and 1) or (9 - firstweekday)
    dmf_end.year = monthInfo.year
    dmf_end.month = monthInfo.month
    dmf_end.day = firstsunday + 7 -- 1 days of "slop"
    -- Unfortunately, DMF boundary ignores daylight savings, and the time of day varies across regions
    -- Report a reset well past end to make sure we don't drop quests early
    local ret = time(dmf_end)
    local offset = addon:GetServerOffset() * 3600
    ret = ret - offset
    return ret
  end
end

function addon:QuestCount(toonname)
  local t
  if toonname then
    t = vars and vars.db.Toons and vars.db.Toons[toonname]
  else -- account-wide quests
    t = db
  end
  if not t then return 0,0 end
  local dailycount, weeklycount = 0,0
  -- ticket 96: GetDailyQuestsCompleted() is unreliable, the response is laggy and it fails to count some quests
  for _,info in pairs(t.Quests) do
    if info.isDaily then
      dailycount = dailycount + 1
    else
      weeklycount = weeklycount + 1
    end
  end
  return dailycount, weeklycount
end

-- local addon functions below

local function GetLastLockedInstance()
  local numsaved = GetNumSavedInstances()
  if numsaved > 0 then
    for i = 1, numsaved do
      local name, id, expires, diff, locked, extended, mostsig, raid, players, diffname = GetSavedInstanceInfo(i)
      if locked then
        return name, id, expires, diff, locked, extended, mostsig, raid, players, diffname
      end
    end
  end
end

function addon:normalizeName(str)
  return str:gsub("%p",""):gsub("%s"," "):gsub("%s%s"," "):gsub("^%s+",""):gsub("%s+$",""):upper()
end

addon.transInstance = {
  -- lockout hyperlink id = LFDID
  [543] = 188, 	-- Hellfire Citadel: Ramparts
  [540] = 189, 	-- Hellfire Citadel: Shattered Halls : deDE
  [542] = 187,  -- Hellfire Citadel: Blood Furnace esES
  [534] = 195, 	-- The Battle for Mount Hyjal
  [509] = 160, 	-- Ruins of Ahn'Qiraj
  [557] = 179,  -- Auchindoun: Mana-Tombs : ticket 72 zhTW
  [556] = 180,  -- Auchindoun: Sethekk Halls : ticket 151 frFR
  [568] = 340,  -- Zul'Aman: frFR
  [1004] = 474, -- Scarlet Monastary: deDE
  [600] = 215,  -- Drak'Tharon: ticket 105 deDE
  [560] = 183,  -- Escape from Durnholde Keep: ticket 124 deDE
  [531] = 161,  -- AQ temple: ticket 137 frFR
  [1228] = 897, -- Highmaul: ticket 175 ruRU
  [552] = 1011, -- Arcatraz: ticket 216 frFR
  [1516] = 1190, -- Arcway: ticket 227/233 ptBR
  [1651] = 1347, -- Return to Karazhan: ticket 237 (fake LFDID)
}

-- some instances (like sethekk halls) are named differently by GetSavedInstanceInfo() and LFGGetDungeonInfoByID()
-- we use the latter name to key our database, and this function to convert as needed
function addon:FindInstance(name, raid)
  if not name or #name == 0 then return nil end
  local nname = addon:normalizeName(name)
  -- first pass, direct match
  local info = vars.db.Instances[name]
  if info then
    return name, info.LFDID
  end
  -- hyperlink id lookup: must precede substring match for ticket 99
  -- (so transInstance can override incorrect substring matches)
  for i = 1, GetNumSavedInstances() do
    local link = GetSavedInstanceChatLink(i) or ""
    local lid,lname = link:match(":(%d+):%d+:%d+\124h%[(.+)%]\124h")
    lname = lname and addon:normalizeName(lname)
    lid = lid and tonumber(lid)
    local lfdid = lid and addon.transInstance[lid]
    if lname == nname and lfdid then
      local truename = addon:UpdateInstance(lfdid)
      if truename then
        return truename, lfdid
      end
    end
  end
  -- normalized substring match
  for truename, info in pairs(vars.db.Instances) do
    local tname = addon:normalizeName(truename)
    if (tname:find(nname, 1, true) or nname:find(tname, 1, true)) and
      info.Raid == raid then -- Tempest Keep: The Botanica
      --debug("FindInstance("..name..") => "..truename)
      return truename, info.LFDID
    end
  end
  return nil
end

-- provide either id or name/raid to get the instance truename and db entry
function addon:LookupInstance(id, name, raid)
  --debug("LookupInstance("..(id or "nil")..","..(name or "nil")..","..(raid and "true" or "false")..")")
  local truename, instance
  if name then
    truename, id = addon:FindInstance(name, raid)
  end
  if id then
    truename = addon:UpdateInstance(id)
  end
  if truename then
    instance = vars.db.Instances[truename]
  end
  if not instance then
    debug("LookupInstance() failed to find instance: "..(name or "")..":"..(id or 0).." : "..GetLocale())
    addon.warned = addon.warned or {}
    if not addon.warned[name] then
      addon.warned[name] = true
      local lid
      for i = 1, GetNumSavedInstances() do
        local link = GetSavedInstanceChatLink(i) or ""
        local tlid,tlname = link:match(":(%d+):%d+:%d+\124h%[(.+)%]\124h")
        if tlname == name then lid = tlid end
      end
      bugReport("SavedInstances: ERROR: Refresh() failed to find instance: "..name.." : "..GetLocale().." : "..(lid or "x"))
    end
    instance = {}
    --vars.db.Instances[name] = instance
  end
  return truename, instance
end

function addon:InstanceCategory(instance)
  if not instance then return nil end
  instance = vars.db.Instances[instance]
  if instance.Holiday then return "H" end
  if instance.Random then return "N" end
  return ((instance.Raid and "R") or ((not instance.Raid) and "D")) .. instance.Expansion
end

function addon:InstancesInCategory(targetcategory)
  -- returns a table of the form { "instance1", "instance2", ... }
  if (not targetcategory) then return { } end
  local list = { }
  for instance, _ in pairs(vars.db.Instances) do
    if addon:InstanceCategory(instance) == targetcategory then
      table.insert(list, instance)
    end
  end
  return list
end

function addon:CategorySize(category)
  if not category then return nil end
  local i = 0
  for instance, _ in pairs(vars.db.Instances) do
    if category == addon:InstanceCategory(instance) then
      i = i + 1
    end
  end
  return i
end

local _instance_exceptions = {
  -- workaround a Blizzard bug:
  -- since 5.0, some old raid lockout tooltips are missing boss kill info
  -- currently affects 25+ man BC/Vanilla raids (but not Kara or AQ Ruins, go figure)
  -- starting in 6.1 we have the kill bitmap but no boss names
  [48] = { -- Molten Core
    12118, -- Lucifron
    11982, -- Magmadar
    12259, -- Gehennas
    12057, -- Garr
    12264, -- Shazzrah
    12056, -- Baron Geddon
    12098, -- Sulfuron Harbinger
    11988, -- Golemagg the Incinerator
    12018, -- Majordomo Executus
    11502, -- Ragnaros
  },
  [50] = { -- Blackwing Lair
    12435, -- Razorgore the Untamed
    13020, -- Vaelastrasz the Corrupt
    12017, -- Boodlord Lashlayer
    11983, -- Firemaw
    14601, -- Ebonroc
    11981, -- Flamegor
    14020, -- Chromaggus
    11583, -- Nefarian
  },
  [161] = { -- Ahn'Qiraj Temple
    15263, -- Prophet Skeram
    15543, -- Princess Yauj (also Vem and Lord Kri)
    15516, -- Bodyguard Sartura
    15510, -- Fankriss the Unyielding
    15299, -- Viscidus
    15509, -- Princess Huhuran
    15276, -- Emperor Vek'lor
    15517, -- Ouro
    15727, -- C'Thun
  },
  [176] = { -- Magtheridon's Lair
    17257, -- Magtheridon
  },
  [177] = { -- Gruul's Lair
    18831, -- High King Maulgar
    19044, -- Gruul
  },
  [193] = { -- Tempest Keep
    19514, -- A'lar
    19516, -- Void Reaver
    18805, -- High Astromancer Solarian
    19622, -- Kael'thas Sunstrider
  },
  [194] = { -- Serpentshrine Cavern
    21216, -- Hydross the Unstable
    21217, -- The Lurker Below
    21215, -- Leotheras the Blind
    21214, -- Fathom-Lord Karathress
    21213, -- Morogrim Tidewalker
    21212, -- Lady Vashj
  },
  [195] = { -- Hyjal Past
    17767, -- Rage Winterchill
    17808, -- Anetheron
    17888, -- Kaz'rogal
    17842, -- Azgalor
    17968, -- Archimonde
  },
  [196] = { -- Black Temple
    22887, -- High Warlord Naj'entus
    22898, -- Supremus
    22841, -- Shade of Akama
    22871, -- Teron Gorefiend
    22948, -- Gurtogg Bloodboil
    22856, -- Reliquary of Souls
    22947, -- Mother Shahraz
    23426, -- Illidari Council
    22917, -- Illidan Stormrage
  },
  [199] = { -- Sunwell
    24850, -- Kalecgos
    24882, -- Brutallus
    25038, -- Felmyst
    25166, -- Grand Warlock Alythess
    25741, -- M'uru
    25315, -- Kil'jaeden
  },
  [1347] = { total=8 }, -- Return to Karazhan
}

function addon:instanceException(LFDID)
  if not LFDID then return nil end
  local exc = _instance_exceptions[LFDID]
  if exc then -- localize boss names
    local total = 0
    for idx, id in ipairs(exc) do
      if type(id) == "number" then
        scantt:SetOwner(UIParent,"ANCHOR_NONE")
        scantt:SetHyperlink(("unit:Creature-0-0-0-0-%d:0000000000"):format(id))
        local line = scantt:IsShown() and _G[scantt:GetName().."TextLeft1"]
        line = line and line:GetText()
        if line and #line > 0 then
          exc[idx] = line
        end
      end
      total = total + 1
    end
    exc.total = exc.total or total
  end
  return exc
end

function addon:instanceBosses(instance,toon,diff)
  local killed,total,base = 0,0,1
  local remap = nil
  local inst = vars.db.Instances[instance]
  local save = inst and inst[toon] and inst[toon][diff]
  if inst.WorldBoss then
    return (save[1] and 1 or 0), 1, 1
  end
  if not inst or not inst.LFDID then return 0,0,1 end
  local exc = addon:instanceException(inst.LFDID)
  total = (exc and exc.total) or GetLFGDungeonNumEncounters(inst.LFDID)
  local LFR = addon.LFRInstances[inst.LFDID]
  if LFR then
    total = LFR.total or total
    base = LFR.base or base
    remap = LFR.remap
  end
  if not save then
    return killed, total, base, remap
  elseif save.Link then
    local bits = save.Link:match(":(%d+)\124h")
    bits = bits and tonumber(bits)
    if bits then
      while bits > 0 do
        if bit.band(bits,1) > 0 then
          killed = killed + 1
        end
        bits = bit.rshift(bits,1)
      end
    end
  elseif save.ID < 0 then
    for i=1,-1*save.ID do
      killed = killed + (save[i] and 1 or 0)
    end
  end
  return killed, total, base, remap
end

local lfrkey = "^"..L["LFR"]..": "
local function instanceSort(i1, i2)
  local instance1 = vars.db.Instances[i1]
  local instance2 = vars.db.Instances[i2]
  local level1 = instance1.RecLevel or 0
  local level2 = instance2.RecLevel or 0
  local id1 = instance1.LFDID or instance1.WorldBoss or 0
  local id2 = instance2.LFDID or instance2.WorldBoss or 0
  local key1 = level1*1000000+id1
  local key2 = level2*1000000+id2
  if i1:match(lfrkey) then key1 = key1 - 20000 end
  if i2:match(lfrkey) then key2 = key2 - 20000 end
  if instance1.WorldBoss then key1 = key1 - 30000 end
  if instance2.WorldBoss then key2 = key2 - 30000 end
  if vars.db.Tooltip.ReverseInstances then
    return key1 < key2
  else
    return key2 < key1
  end
end

addon.oi_cache = {}
function addon:OrderedInstances(category)
  -- returns a table of the form { "instance1", "instance2", ... }
  local instances = addon.oi_cache[category]
  if not instances then
    instances = addon:InstancesInCategory(category)
    table.sort(instances, instanceSort)
    if addon.instancesUpdated then
      addon.oi_cache[category] = instances
    end
  end
  return instances
end

function addon:OrderedCategories()
  -- returns a table of the form { "category1", "category2", ... }
  if addon.oc_cache then return addon.oc_cache end
  local orderedlist = { }
  local firstexpansion, lastexpansion, expansionstep, firsttype, lasttype
  if vars.db.Tooltip.NewFirst then
    firstexpansion = maxExpansion
    lastexpansion = 0
    expansionstep = -1
  else
    firstexpansion = 0
    lastexpansion = maxExpansion
    expansionstep = 1
  end
  if vars.db.Tooltip.RaidsFirst then
    firsttype = "R"
    lasttype = "D"
  else
    firsttype = "D"
    lasttype = "R"
  end
  for i = firstexpansion, lastexpansion, expansionstep do
    table.insert(orderedlist, firsttype .. i)
    if vars.db.Tooltip.CategorySort == "EXPANSION" then
      table.insert(orderedlist, lasttype .. i)
    end
  end
  if vars.db.Tooltip.CategorySort == "TYPE" then
    for i = firstexpansion, lastexpansion, expansionstep do
      table.insert(orderedlist, lasttype .. i)
    end
  end
  addon.oc_cache = orderedlist
  return orderedlist
end

local function DifficultyString(instance, diff, toon, expired, killoverride, totoverride)
  local setting,color
  if not instance then
    setting = "D1"
  else
    local inst = vars.db.Instances[instance]
    if not inst or not inst.Raid then -- 5-man
      if diff == 2 then -- heroic
        setting = "D2"
    elseif diff == 23 then -- mythic
      setting = "D3"
    else -- normal?
      setting = "D1"
    end
    elseif inst.Expansion == 0 then -- classic raid
      setting = "R0"
    elseif diff >= 3 and diff <= 7 then -- pre-WoD raids
      setting = "R"..(diff-2)
    elseif diff >= 14 and diff <= 16 then -- WoD raids
      setting = "R"..(diff-8)
    else -- don't know
      setting = "D1"
    end
  end
  local prefs = vars.db.Indicators
  local classcolor = prefs[setting .. "ClassColor"]
  if classcolor == nil then
    classcolor = vars.defaultDB.Indicators[setting .. "ClassColor"]
  end
  if expired then
    color = GRAY_COLOR
  elseif classcolor then
    color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[vars.db.Toons[toon].Class]
  else
    prefs[setting.."Color"]  = prefs[setting.."Color"] or vars.defaultDB.Indicators[setting.."Color"]
    color = prefs[setting.."Color"]
  end
  local text = prefs[setting.."Text"] or vars.defaultDB.Indicators[setting.."Text"]
  local indicator = prefs[setting.."Indicator"] or vars.defaultDB.Indicators[setting.."Indicator"]
  text = ColorCodeOpen(color) .. text .. FONTEND
  if text:find("ICON", 1, true) and indicator ~= "BLANK" then
    text = text:gsub("ICON", FONTEND .. vars.Indicators[indicator] .. ColorCodeOpen(color))
  end
  if text:find("KILLED", 1, true) or text:find("TOTAL", 1, true) then
    local killed, total
    if killoverride then
      killed, total = killoverride, totoverride
    else
      killed, total = addon:instanceBosses(instance,toon,diff)
    end
    if killed == 0 and total == 0 then -- boss kill info missing
      killed = "*"
      total = "*"
    elseif killed == 1 and total == 1 and not expired then
      text = "\124T"..READY_CHECK_READY_TEXTURE..":0|t" -- checkmark
    end
    text = text:gsub("KILLED",killed)
    text = text:gsub("TOTAL",total)
  end
  return text
end

-- run about once per session to update our database of instance info
function addon:UpdateInstanceData()
  --debug("UpdateInstanceData()")
  if addon.instancesUpdated then return end  -- nil before first use in UI
  addon.instancesUpdated = true
  local added = 0
  local lfdid_to_name = {}
  local wbid_to_name = {}
  local id_blacklist = {}
  local starttime = debugprofilestop()
  -- previously we used GetFullRaidList() and LFDDungeonList to help populate the instance list
  -- Unfortunately those are loaded lazily, and forcing them to load from here can lead to taint.
  -- They are also somewhat incomplete, so instead we just brute force it, which is reasonably fast anyhow
  for id=1,maxid do
    local instname, newentry, blacklist = addon:UpdateInstance(id)
    if newentry then
      added = added + 1
    end
    if blacklist then
      id_blacklist[id] = true
    end
    if instname then
      if lfdid_to_name[id] then
        debug("Duplicate entry in lfdid_to_name: "..id..":"..lfdid_to_name[id]..":"..instname)
      end
      lfdid_to_name[id] = instname
    end
  end
  for eid,info in pairs(addon.WorldBosses) do
    info.eid = eid
    if not info.name then
      info.name = select(2,EJ_GetCreatureInfo(1,eid))
    end
    info.name = info.name or "UNKNOWN"..eid
    local instance = vars.db.Instances[info.name]
    if info.remove then -- cleanup hook
      vars.db.Instances[info.name] = nil
      addon.WorldBosses[eid] = nil
    else
      if not instance then
        added = added + 1
        instance = {}
        vars.db.Instances[info.name] = instance
      end
      instance.Show = instance.Show or "saved"
      instance.WorldBoss = eid
      instance.Expansion = info.expansion
      instance.RecLevel = info.level
      instance.Raid = true
      wbid_to_name[eid] = info.name
    end
  end

  -- instance merging: this algorithm removes duplicate entries created by client locale changes using the same database
  -- we really should re-key the database by ID, but this is sufficient for now
  local renames = 0
  local merges = 0
  local conflicts = 0
  local purges = 0
  for instname, inst in pairs(vars.db.Instances) do
    local truename
    if inst.WorldBoss then
      truename = wbid_to_name[inst.WorldBoss]
    elseif inst.LFDID then
      truename = lfdid_to_name[inst.LFDID]
    else
      debug("Ignoring bogus entry in instance database: "..instname)
    end
    if not truename then
      if inst.LFDID and id_blacklist[inst.LFDID] then
        debug("Removing blacklisted entry in instance database: "..instname)
        vars.db.Instances[instname] = nil
      else
        debug("Ignoring unmatched entry in instance database: "..instname)
      end
    elseif instname == truename then
    -- this is the canonical entry, nothing to do
    else -- this is a stale entry, merge data and remove it
      local trueinst = vars.db.Instances[truename]
      if not trueinst or trueinst == inst then
        debug("Merge error in UpdateInstanceData: "..truename)
      else
        for key, info in pairs(inst) do
          if key:find(" - ") then -- is a character key
            if trueinst[key] then
              -- merge conflict: keep the trueinst data
              debug("Merge conflict on "..truename..":"..instname..":"..key)
              conflicts = conflicts + 1
          else
            trueinst[key] = info
            merges = merges + 1
          end
          end
        end
        -- copy config settings, favoring old entry
        trueinst.Show = inst.Show or trueinst.Show
        -- clear stale entry
        vars.db.Instances[instname] = nil
        renames = renames + 1
      end
    end

	-- Eliminate duplicate LFR entries from the database (only affects those that were saved previously), to account for Blizzard's lockout changes in 7.3 (see https://github.com/SavedInstances/SavedInstances/issues/89)
	for key, info in pairs(inst) do -- Check for potential LFR lockout entries

	if key:find(" - ") then -- is a character key
			for difficulty, entry in pairs(info) do -- Check difficulty for LFR
				if difficulty == 7 or difficulty == 17 then -- Difficulties 7 and 17 are for (legacy) LFR modes -> Kill them... with fire!
					debug("Purge LFR lockout entry for " .. truename .. ":" .. instname .. ":" .. key)
					purges = purges + 1
					vars.db.Instances[instname][key][difficulty] = nil
				end
			end
		  end
	end

  end
  -- addon.lfdid_to_name = lfdid_to_name
  -- addon.wbid_to_name = wbid_to_name

  vars.config:BuildOptions() -- refresh config table

  starttime = debugprofilestop()-starttime
  debug("UpdateInstanceData(): completed in %.3f ms : %d added, %d renames, %d merges, %d conflicts, %d purges.", starttime, added, renames, merges, conflicts, purges)
  if addon.RefreshPending then
    addon.RefreshPending = nil
    core:Refresh()
  end
end

--if LFDParentFrame then hooksecurefunc(LFDParentFrame,"Show",function() addon:UpdateInstanceData() end) end
function addon:UpdateInstance(id)
  -- returns: <instance_name>, <is_new_instance>, <blacklisted_id>
  --debug("UpdateInstance: "..id)
  if not id or id <= 0 then return end
  local name, typeID, subtypeID,
    minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel,
    expansionLevel, groupID, textureFilename,
    difficulty, maxPlayers, description, isHoliday = GetLFGDungeonInfo(id)
  -- name is nil for non-existent ids
  -- isHoliday is for single-boss holiday instances that don't generate raid saves
  -- typeID 4 = outdoor area, typeID 6 = random
  maxPlayers = tonumber(maxPlayers)
  if not name or not expansionLevel or not recLevel or (typeID > 2 and typeID ~= TYPEID_RANDOM_DUNGEON) then return end
  if name:find(PVP_RATED_BATTLEGROUND) then return nil, nil, true end -- ignore 10v10 rated bg
  if id == 1347 then -- ticket 237: Return to Karazhan currently has no actual LFDID, so use this one (Kara Scenario)
    name = SPLASH_LEGION_NEW_7_1_RIGHT_TITLE
    expansionLevel = 6
    recLevel = 110
    maxPlayers = 5
    isHoliday = false
    typeID = TYPEID_DUNGEON
    subtypeID = LFG_SUBTYPEID_HEROIC
  end
  if subtypeID == LFG_SUBTYPEID_SCENARIO and typeID ~= TYPEID_RANDOM_DUNGEON then -- ignore non-random scenarios
    return nil, nil, true
  end
  if typeID == 2 and subtypeID == 0 and difficulty == 14 and maxPlayers == 0 then
    --print("ignoring "..id, GetLFGDungeonInfo(id))
    return nil, nil, true -- ignore bogus LFR entries
  end
  if typeID == 1 and subtypeID == 5 and difficulty == 14 and maxPlayers == 25 then
    --print("ignoring "..id, GetLFGDungeonInfo(id))
    return nil, nil, true -- ignore old Flex entries
  end
  if addon.LFRInstances[id] then -- ensure uniqueness (eg TeS LFR)
    local lfrid = vars.db.Instances[name] and vars.db.Instances[name].LFDID
    if lfrid and addon.LFRInstances[lfrid] then
      vars.db.Instances[name] = nil -- clean old LFR entries
    end
    vars.db.Instances[L["Flex"]..": "..name] = nil -- clean old flex entries
    name = L["LFR"]..": "..name
  end
  if id == 852 and expansionLevel == 5 then -- XXX: Molten Core hack
    return nil, nil, true -- ignore Molten Core holiday version, which has no save
  end
  if id == 767 then -- ignore bogus Ordos entry
    return nil, nil, true
  end
  if id == 768 then -- ignore bogus Celestials entry
    return nil, nil, true
  end

  local instance = vars.db.Instances[name]
  local newinst = false
  if not instance then
    debug("UpdateInstance: "..id.." "..(name or "nil").." "..(expansionLevel or "nil").." "..(recLevel or "nil").." "..(maxPlayers or "nil"))
    instance = {}
    newinst = true
  end
  vars.db.Instances[name] = instance
  instance.Show = instance.Show or "saved"
  instance.Encounters = nil -- deprecated
  instance.LFDupdated = nil
  instance.LFDID = id
  instance.Holiday = isHoliday or nil
  instance.Expansion = expansionLevel
  if not instance.RecLevel or instance.RecLevel < 1 then instance.RecLevel = recLevel end
  if recLevel > 0 and recLevel < instance.RecLevel then instance.RecLevel = recLevel end -- favor non-heroic RecLevel
  instance.Raid = (maxPlayers > 5 or (maxPlayers == 0 and typeID == 2))
  if typeID == TYPEID_RANDOM_DUNGEON then
    instance.Random = true
  end
  if subtypeID == LFG_SUBTYPEID_SCENARIO then
    instance.Scenario = true
  end
  return name, newinst
end

function addon:updateSpellTip(spellid)
  local slot
  vars.db.spelltip = vars.db.spelltip or {}
  vars.db.spelltip[spellid] = vars.db.spelltip[spellid] or {}
  for i=1,20 do
    local id = select(10, SI_GetUnitDebuff("player",i))
    if id == spellid then slot = i end
  end
  if slot then
    scantt:SetOwner(UIParent,"ANCHOR_NONE")
    scantt:SetUnitDebuff("player",slot)
    for i=1,scantt:NumLines()-1 do
      local left = _G[scantt:GetName().."TextLeft"..i]
      vars.db.spelltip[spellid][i] = left:GetText()
    end
  end
end

-- run regularly to update lockouts and cached data for this toon
function addon:UpdateToonData()
  addon.activeHolidays = addon.activeHolidays or {}
  wipe(addon.activeHolidays)
  -- blizz internally conflates all the holiday flags, so we have to detect which is really active
  for i=1, GetNumRandomDungeons() do
    local id, name = GetLFGRandomDungeonInfo(i);
    local d = vars.db.Instances[name]
    if d and d.Holiday then
      addon.activeHolidays[name] = true
    end
  end

  local nextreset = addon:GetNextDailyResetTime()
  for instance, i in pairs(vars.db.Instances) do
    for toon, t in pairs(vars.db.Toons) do
      if i[toon] then
        for difficulty, d in pairs(i[toon]) do
          if d.Expires and d.Expires < time() then
            d.Locked = false
            d.Expires = 0
            if d.ID < 0 then
              i[toon][difficulty] = nil
            end
          end
        end
      end
    end
    if (i.Holiday and addon.activeHolidays[instance]) or
      (i.Random and not i.Holiday) then
      local id = i.LFDID
      GetLFGDungeonInfo(id) -- forces update
      local donetoday, money = GetLFGDungeonRewards(id)
      if donetoday and i.Random and (
        (i.LFDID == 258) or  -- random classic dungeon
        (i.LFDID == 995 or i.LFDID == 744) or  -- timewalking dungeons
        (UnitLevel("player") == 85 and
        (i.LFDID == 300 or i.LFDID == 301 or i.LFDID == 434)) -- reg/her cata and HoT at 85
        ) then -- donetoday flag is falsely set for some level/dungeon combos where no daily incentive is available
        donetoday = false
      end
      if nextreset and donetoday and (i.Holiday or (money and money > 0)) then
        i[thisToon] = i[thisToon] or {}
        i[thisToon][1] = i[thisToon][1] or {}
        local d = i[thisToon][1]
        d.ID = -1
        d.Locked = false
        d.Expires = nextreset
      end
    end
  end
  -- update random toon info
  local t = vars.db.Toons[thisToon]
  local now = time()
  if addon.logout or addon.PlayedTime or addon.playedpending then
    if addon.PlayedTime then
      local more = now - addon.PlayedTime
      t.PlayedTotal = t.PlayedTotal + more
      t.PlayedLevel = t.PlayedLevel + more
      addon.PlayedTime = now
    end
  else
    addon.playedpending = true
    addon.playedreg = addon.playedreg or {}
    wipe(addon.playedreg)
    for i=1,10 do
      local c = _G["ChatFrame"..i]
      if c and c:IsEventRegistered("TIME_PLAYED_MSG") then
        c:UnregisterEvent("TIME_PLAYED_MSG") -- prevent spam
        addon.playedreg[c] = true
      end
    end
    RequestTimePlayed()
  end
  t.LFG1 = GetTimeToTime(GetLFGRandomCooldownExpiration()) or t.LFG1
  t.LFG2 = GetTimeToTime(select(6, SI_GetUnitDebuff("player",GetSpellInfo(71041)))) or t.LFG2 -- GetLFGDeserterExpiration()
  if t.LFG2 then addon:updateSpellTip(71041) end
  addon.pvpdesertids = addon.pvpdesertids or { 26013,   -- BG queue
    194958 } -- Ashran
  for _,id in ipairs(addon.pvpdesertids) do
    t.pvpdesert = GetTimeToTime(select(6, SI_GetUnitDebuff("player",GetSpellInfo(id)))) or t.pvpdesert
    if t.pvpdesert then addon:updateSpellTip(id) end
    end
    for toon, ti in pairs(vars.db.Toons) do
      if ti.LFG1 and (ti.LFG1 < now) then ti.LFG1 = nil end
      if ti.LFG2 and (ti.LFG2 < now) then ti.LFG2 = nil end
      if ti.pvpdesert and (ti.pvpdesert < now) then ti.pvpdesert = nil end
      ti.Quests = ti.Quests or {}
    end
    local IL,ILe = GetAverageItemLevel()
    if IL and tonumber(IL) and tonumber(IL) > 0 then -- can fail during logout
      t.IL, t.ILe = tonumber(IL), tonumber(ILe)
    end
    local rating = (GetPersonalRatedInfo and GetPersonalRatedInfo(4))
    t.RBGrating = tonumber(rating) or t.RBGrating
    core:scan_item_cds()
    -- Daily Reset
    if nextreset and nextreset > time() then
      for toon, ti in pairs(vars.db.Toons) do
        if not ti.DailyResetTime or (ti.DailyResetTime < time()) then
          for id,qi in pairs(ti.Quests) do
            if qi.isDaily then
              ti.Quests[id] = nil
            end
          end
          if ti.DailyWorldQuest then
            if ti.DailyWorldQuest.days1 then
              ti.DailyWorldQuest.days0 = ti.DailyWorldQuest.days1
              ti.DailyWorldQuest.days0.dayleft = 0
              ti.DailyWorldQuest.days1 = nil
            end
            if ti.DailyWorldQuest.days2 then
              ti.DailyWorldQuest.days1 = ti.DailyWorldQuest.days2
              ti.DailyWorldQuest.days1.dayleft = 1
              ti.DailyWorldQuest.days2 = nil
            end
          end
          ti.DailyResetTime = (ti.DailyResetTime and ti.DailyResetTime + 24*3600) or nextreset
        end
      end
      t.DailyResetTime = nextreset
      if not db.DailyResetTime or (db.DailyResetTime < time()) then -- AccountDaily reset
        for id,qi in pairs(db.Quests) do
          if qi.isDaily then
            db.Quests[id] = nil
          end
      end
      db.DailyResetTime = nextreset
      end
    end
    -- Skill Reset
    for toon, ti in pairs(vars.db.Toons) do
      if ti.Skills then
        for spellid, sinfo in pairs(ti.Skills) do
          if sinfo.Expires and sinfo.Expires < time() then
            ti.Skills[spellid] = nil
          end
        end
      end
      if ti.FarmExpires and ti.FarmExpires < time() then
        ti.FarmPlanted = 0
        ti.FarmHarvested = 0
        if ti.FarmCropPlanted and next(ti.FarmCropPlanted) then
          ti.FarmCropReady = ti.FarmCropPlanted
          ti.FarmCropPlanted = nil
        end
        ti.FarmExpires = nil
      end
    end
    -- Weekly Reset
    nextreset = addon:GetNextWeeklyResetTime()
    if nextreset and nextreset > time() then
      for toon, ti in pairs(vars.db.Toons) do
        if not ti.WeeklyResetTime or (ti.WeeklyResetTime < time()) then
          ti.currency = ti.currency or {}
          for _,idx in ipairs(currency) do
            local ci = ti.currency[idx]
            if ci and ci.earnedThisWeek then
              ci.earnedThisWeek = 0
            end
          end
          ti.WeeklyResetTime = (ti.WeeklyResetTime and ti.WeeklyResetTime + 7*24*3600) or nextreset
        end
      end
      t.WeeklyResetTime = nextreset
    end
    for toon, ti in pairs(vars.db.Toons) do
      for id,qi in pairs(ti.Quests) do
        if not qi.isDaily and (qi.Expires or 0) < time() then
          ti.Quests[id] = nil
        end
        if QuestExceptions[id] == "Regular" then -- adjust exceptions
          ti.Quests[id] = nil
        end
      end
    end
    for toon, ti in pairs(vars.db.Toons) do
      if ti.MythicKey and (ti.MythicKey.ResetTime or 0) < time() then
        ti.MythicKey = {}
      end
    end
    for toon, ti in pairs(vars.db.Toons) do
      if ti.MythicKeyBest and (ti.MythicKeyBest.ResetTime or 0) < time() then
        if ti.MythicKeyBest.level and ti.MythicKeyBest.level > 0 then
          ti.MythicKeyBest.LastWeekLevel = ti.MythicKeyBest.level
          ti.MythicKeyBest.WeeklyReward = true
        end
        ti.MythicKeyBest.level = 0
        ti.MythicKeyBest.ResetTime = addon:GetNextWeeklyResetTime()
      end
    end
    for id,qi in pairs(db.Quests) do -- AccountWeekly reset
      if not qi.isDaily and (qi.Expires or 0) < time() then
        db.Quests[id] = nil
    end
    end
    addon:UpdateCurrency()
    local zone = GetRealZoneText()
    if zone and #zone > 0 then
      t.Zone = zone
    end
    local lrace, race = UnitRace("player")
    local faction, lfaction = UnitFactionGroup("player")
    t.Faction = faction
    if race == "Pandaren" then
      t.Race = lrace.." ("..lfaction..")"
    else
      t.Race = lrace
    end

    t.LastSeen = time()
end

function addon:UpdateCurrency()
  if addon.logout then return end -- currency is unreliable during logout
  local t = vars.db.Toons[thisToon]
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
      ci.season = addon:GetSeasonCurrency(idx)
      if ci.weeklyMax == 0 then ci.weeklyMax = nil end -- don't store useless info
      if ci.totalMax == 0 then ci.totalMax = nil end -- don't store useless info
      if ci.earnedThisWeek == 0 then ci.earnedThisWeek = nil end -- don't store useless info
      t.currency[idx] = ci
    end
  end
end

function addon:QuestIsDarkmoonMonthly()
  if QuestIsDaily() then return false end
  local id = GetQuestID()
  local scope = id and QuestExceptions[id]
  if scope and scope ~= "Darkmoon" then return false end -- one-time referral quests
  for i=1,GetNumRewardCurrencies() do
    local name,texture,amount = GetQuestCurrencyInfo("reward",i)
    if texture == 134481 then
      return true
    end
  end
  return false
end

function addon:GetCurrentMapAreaID()
  return C_Map.GetBestMapForUnit("player")
end

local function SI_GetQuestReward()
  local t = vars and vars.db.Toons[thisToon]
  if not t then return end
  local id = GetQuestID() or -1
  local title = GetTitleText() or ""
  local link = nil
  local isMonthly = addon:QuestIsDarkmoonMonthly()
  local isWeekly = QuestIsWeekly()
  local isDaily = QuestIsDaily()
  local isAccount

  local index = GetQuestLogIndexByID(id)
  if index and index > 0 then
    link = GetQuestLink(index)
  end
  if id > 1 then -- try harder to fetch names
    local t,l = addon:QuestInfo(id)
    if not (link and #link > 0) then
      link = l
    end
    if not (title and #title > 0) then
      title = t or "<unknown>"
    end
  end
  local questTagID, tagName = GetQuestTagInfo(id)
  if questTagID and tagName then
    isAccount = (questTagID == QUEST_TAG_ACCOUNT)
  else
    isAccount = db.QuestDB.AccountDaily[id] or db.QuestDB.AccountWeekly[id]
    debug("Fetched isAccount")
  end
  if QuestExceptions[id] then
    local qe = QuestExceptions[id]
    isAccount = qe:find("Account") and true
    isDaily = 	qe:find("Daily") and true
    isWeekly = 	qe:find("Weekly") and true
    isMonthly =	qe:find("Darkmoon") and true
  end
  local expires
  local questDB
  if isWeekly then
    expires = addon:GetNextWeeklyResetTime()
    questDB = (isAccount and db.QuestDB.AccountWeekly) or db.QuestDB.Weekly
  elseif isMonthly then
    expires = addon:GetNextDarkmoonResetTime()
    questDB = db.QuestDB.Darkmoon
  elseif isDaily then
    questDB = (isAccount and db.QuestDB.AccountDaily) or db.QuestDB.Daily
  end
  debug("Quest Complete: "..(link or title).." "..id.." : "..title.." "..
    (isAccount and "(Account) " or "")..
    (isMonthly and "(Monthly)" or isWeekly and "(Weekly)" or isDaily and "(Daily)" or "(Regular)").."  "..
    (expires and date("%c",expires) or ""))
  if not isMonthly and not isWeekly and not isDaily then return end
  local mapid = addon:GetCurrentMapAreaID()
  questDB[id] = mapid
  local qinfo =  { ["Title"] = title, ["Link"] = link,
    ["isDaily"] = isDaily,
    ["Expires"] = expires,
    ["Zone"] = C_Map.GetMapInfo(mapid) }
  local scope = t
  if isAccount then
    scope = db
    if t.Quests then t.Quests[id] = nil end -- make sure we promote account quests
  end
  scope.Quests = scope.Quests or {}
  scope.Quests[id] = qinfo
  local dc, wc = addon:QuestCount(thisToon)
  local adc, awc = addon:QuestCount(nil)
  debug("DailyCount: "..dc.."  WeeklyCount: "..wc.." AccountDailyCount: "..adc.."  AccountWeeklyCount: "..awc)
end
hooksecurefunc("GetQuestReward", SI_GetQuestReward)

local function coloredText(fontstring)
  if not fontstring then return nil end
  local text = fontstring:GetText()
  if not text then return nil end
  local textR, textG, textB, textAlpha = fontstring:GetTextColor()
  return string.format("|c%02x%02x%02x%02x"..text.."|r",
    textAlpha*255, textR*255, textG*255, textB*255)
end

local function openIndicator(...)
  indicatortip = QTip:Acquire("SavedInstancesIndicatorTooltip", ...)
  indicatortip:Clear()
  indicatortip:SetHeaderFont(core:HeaderFont())
  indicatortip:SetScale(vars.db.Tooltip.Scale)
end

local function finishIndicator(parent)
  parent = parent or tooltip
  indicatortip:SetAutoHideDelay(0.1, parent)
  indicatortip.OnRelease = function() indicatortip = nil end -- extra-safety: update our variable on auto-release
  indicatortip:SmartAnchorTo(parent)
  indicatortip:SetFrameLevel(150) -- ensure visibility when forced to overlap main tooltip
  addon:SkinFrame(indicatortip,"SavedInstancesIndicatorTooltip")
  indicatortip:Show()
end

local function ShowToonTooltip(cell, arg, ...)
  local toon = arg
  if not toon then return end
  local t = vars.db.Toons[toon]
  if not t then return end
  openIndicator(2, "LEFT","RIGHT")
  local ftex = ""
  if t.Faction == "Alliance" then
    ftex = "\124TInterface\\TargetingFrame\\UI-PVP-Alliance:0:0:0:0:100:100:0:50:0:55\124t "
  elseif t.Faction == "Horde" then
    ftex = "\124TInterface\\TargetingFrame\\UI-PVP-Horde:0:0:0:0:100:100:10:70:0:55\124t"
  end
  indicatortip:SetCell(indicatortip:AddHeader(),1,ftex..ClassColorise(t.Class, toon))
  indicatortip:SetCell(1,2,ClassColorise(t.Class, LEVEL.." "..t.Level.." "..(t.LClass or "")))
  indicatortip:AddLine(STAT_AVERAGE_ITEM_LEVEL,("%d "):format(t.IL or 0)..STAT_AVERAGE_ITEM_LEVEL_EQUIPPED:format(t.ILe or 0))
  if t.RBGrating and t.RBGrating > 0 then
    indicatortip:AddLine(BATTLEGROUND_RATING, t.RBGrating)
  end
  if t.Money then
    indicatortip:AddLine(MONEY,addon:formatNumber(t.Money,true))
  end
  if t.Zone then
    indicatortip:AddLine(ZONE,t.Zone)
  end
  --[[
  if t.Race then
  indicatortip:AddLine(RACE,t.Race)
  end
  ]]
  if t.LastSeen then
    local when = date("%c",t.LastSeen)
    indicatortip:AddLine(L["Last updated"],when)
  end
  if vars.db.Tooltip.TrackPlayed and t.PlayedTotal and t.PlayedLevel and ChatFrame_TimeBreakDown then
    --indicatortip:AddLine((TIME_PLAYED_TOTAL):format((TIME_DAYHOURMINUTESECOND):format(ChatFrame_TimeBreakDown(t.PlayedTotal))))
    --indicatortip:AddLine((TIME_PLAYED_LEVEL):format((TIME_DAYHOURMINUTESECOND):format(ChatFrame_TimeBreakDown(t.PlayedLevel))))
    indicatortip:AddLine((TIME_PLAYED_TOTAL):format(""),SecondsToTime(t.PlayedTotal))
    indicatortip:AddLine((TIME_PLAYED_LEVEL):format(""),SecondsToTime(t.PlayedLevel))
  end
  finishIndicator()
end

local function ShowQuestTooltip(cell, arg, ...)
  local toon,cnt,isDaily = unpack(arg)
  local qstr = cnt.." "..(isDaily and L["Daily Quests"] or L["Weekly Quests"])
  local t = db
  local scopestr = L["Account"]
  local reset
  if toon then
    t = vars.db.Toons[toon]
    if not t then return end
    scopestr = ClassColorise(t.Class, toon)
    reset = (isDaily and t.DailyResetTime) or (not isDaily and t.WeeklyResetTime)
  end
  openIndicator(2, "LEFT","RIGHT")
  indicatortip:AddHeader(scopestr, qstr)
  if not reset then
    reset = (isDaily and addon:GetNextDailyResetTime()) or (not isDaily and addon:GetNextWeeklyResetTime())
  end
  if reset then
    indicatortip:AddLine(YELLOWFONT .. L["Time Left"] .. ":" .. FONTEND,
      SecondsToTime(reset - time()))
  end
  local ql = {}
  local zonename
  for id,qi in pairs(t.Quests) do
    if (not isDaily) == (not qi.isDaily) then
      zonename = qi.Zone and qi.Zone.name or ""
      table.insert(ql,zonename.." # "..id)
    end
  end
  table.sort(ql)
  for _,e in ipairs(ql) do
    local id = tonumber(e:match("# (%d+)"))
    local qi = t.Quests[id]
    local line = indicatortip:AddLine()
    local link = qi.Link
    if not link then -- sometimes missing the actual link due to races, fake it for display to prevent confusion
      if qi.Title:find("("..LOOT..")") then
        link = qi.Title
      else
        link = "\124cffffff00["..(qi.Title or "???").."]\124r"
      end
    end
    -- Exception: Some quests should not show zone name, such as Blingtron
    if (id == 31752 or id == 34774 or id == 40753) then
      zonename = ""
    end
    indicatortip:SetCell(line,1,zonename,"LEFT")
    indicatortip:SetCell(line,2,link,"RIGHT")
  end
  finishIndicator()
end

local function skillsort(s1, s2)
  if s1.Expires ~= s2.Expires then
    return (s1.Expires or 0) < (s2.Expires or 0)
  else
    return (s1.Title or "") < (s2.Title or "")
  end
end

local function ShowSkillTooltip(cell, arg, ...)
  local toon, cnt = unpack(arg)
  local cstr = cnt.." "..L["Trade Skill Cooldowns"]
  local t = vars.db.Toons[toon]
  if not t then return end
  openIndicator(3, "LEFT","RIGHT","RIGHT")
  local tname = ClassColorise(t.Class, toon)
  indicatortip:AddHeader()
  indicatortip:SetCell(1,1,tname,"LEFT")
  indicatortip:SetCell(1,2,cstr,"RIGHT",2)

  local tmp = {}
  for _,sinfo in pairs(t.Skills) do
    table.insert(tmp,sinfo)
  end
  table.sort(tmp, skillsort)

  for _,sinfo in ipairs(tmp) do
    local line = indicatortip:AddLine()
    local title = sinfo.Link or sinfo.Title or "???"
    local tstr = SecondsToTime((sinfo.Expires or 0) - time())
    indicatortip:SetCell(line,1,title,"LEFT",2)
    indicatortip:SetCell(line,3,tstr,"RIGHT")
  end
  finishIndicator()
end

function addon:plantName(spellid)
  local name = GetSpellInfo(spellid)
  if not name then return "unknown" end
  name = name:gsub(L["Plant"],"")
  name = name:gsub(L["Throw"],"")
  name = name:gsub(L["Seeds"],"")
  name = name:gsub(L["Seed"],"")
  name = strtrim(name)
  return name
end

local function ShowFarmTooltip(cell, arg, ...)
  local toon = arg
  local t = vars.db.Toons[toon]
  if not t then return end
  openIndicator(2, "LEFT","RIGHT")
  local tname = ClassColorise(t.Class, toon)
  indicatortip:AddHeader()
  indicatortip:SetCell(1,1,tname,"LEFT")
  indicatortip:SetCell(1,2,L["Farm Crops"],"RIGHT")

  local exp = t.FarmExpires
  if exp and exp > time() then
    indicatortip:AddLine(YELLOWFONT .. L["Time Left"] .. ":" .. FONTEND, SecondsToTime(exp - time()))
  end
  indicatortip:AddLine(YELLOWFONT .. L["Crops harvested today"] .. ":" .. FONTEND,(t.FarmHarvested or 0))
  indicatortip:AddLine(YELLOWFONT .. L["Crops planted today"] .. ":" .. FONTEND,  (t.FarmPlanted or 0))
  local crops
  if t.FarmCropPlanted and next(t.FarmCropPlanted) then
    crops = t.FarmCropPlanted
    indicatortip:AddLine(YELLOWFONT .. L["Crops growing"] .. ":" .. FONTEND)
  elseif t.FarmCropReady and next(t.FarmCropReady) then
    crops = t.FarmCropReady
    indicatortip:AddLine(YELLOWFONT .. L["Crops ready"] .. ":" .. FONTEND)
  end
  if crops then
    for spellid,cnt in pairs(crops) do
      local line = indicatortip:AddLine()
      indicatortip:SetCell(line,1, addon:plantName(spellid),"LEFT")
      indicatortip:SetCell(line,2,"x"..cnt,"RIGHT")
    end
  end
  finishIndicator()
end

local function ShowBonusTooltip(cell, arg, ...)
  local toon = arg
  local parent
  if type(toon) == "table" then
    toon, parent = unpack(toon)
  end
  local t = vars.db.Toons[toon]
  if not t or not t.BonusRoll then return end
  openIndicator(4, "LEFT","LEFT","LEFT","LEFT")
  local tname = ClassColorise(t.Class, toon)
  indicatortip:AddHeader()
  indicatortip:SetCell(1,1,tname,"LEFT",2)
  indicatortip:SetCell(1,3,L["Recent Bonus Rolls"],"RIGHT",2)

  local line = indicatortip:AddLine()
  for i,roll in ipairs(t.BonusRoll) do
    if i > 10 then break end
    local line = indicatortip:AddLine()
    local icon = roll.currencyID and select(3,GetCurrencyInfo(roll.currencyID))
    if icon then
      indicatortip:SetCell(line,1, " \124T"..icon..":0\124t ")
    end
    if roll.name then
      indicatortip:SetCell(line,2,roll.name)
    end
    if roll.item then
      indicatortip:SetCell(line,3,roll.item)
    elseif roll.money then
      indicatortip:SetCell(line,3,GetMoneyString(roll.money))
    end
    if roll.time then
      indicatortip:SetCell(line,4,date("%b %d %H:%M",roll.time))
    end
  end
  finishIndicator(parent)
end

local function ShowAccountSummary(cell, arg, ...)
  openIndicator(2, "LEFT","RIGHT")
  indicatortip:SetCell(indicatortip:AddHeader(),1,GOLDFONT..L["Account Summary"]..FONTEND,"LEFT",2)

  local tmoney = 0
  local ttime = 0
  local ttoons = 0
  local tmaxtoons = 0
  local r = {}
  for toon, t in pairs(vars.db.Toons) do -- deliberately include ALL toons
    local realm = toon:match(" %- (.+)$")
    local money = t.Money or 0
    tmoney = tmoney + money
    local ri = r[realm] or { ["realm"] = realm, ["money"] = 0, ["cnt"] = 0 }
    ri.money = ri.money + money
    ri.cnt = ri.cnt + 1
    r[realm] = ri
    ttime = ttime + (t.PlayedTotal or 0)
    ttoons = ttoons + 1
    if t.Level == maxlvl then
      tmaxtoons = tmaxtoons + 1
    end
  end
  indicatortip:AddLine(L["Characters"], ttoons)
  indicatortip:AddLine(string.format(L["Level %d Characters"],maxlvl), tmaxtoons)
  if vars.db.Tooltip.TrackPlayed then
    indicatortip:AddLine((TIME_PLAYED_TOTAL):format(""),SecondsToTime(ttime))
  end
  indicatortip:AddLine(TOTAL.." "..MONEY,addon:formatNumber(tmoney,true))
  local rmoney = {}
  for _,ri in pairs(r) do table.insert(rmoney,ri) end
  table.sort(rmoney,function(a,b) return a.money > b.money end)
  for _,ri in ipairs(rmoney) do
    if ri.money > 10000*10000 and ri.cnt > 1 then -- show multi-toon servers with over 10k wealth
      indicatortip:AddLine(ri.realm.." "..MONEY,addon:formatNumber(ri.money,true))
    end
  end

  -- history information
  indicatortip:AddLine("")
  addon:HistoryUpdate()
  local tmp = {}
  local cnt = 0
  for _,ii in pairs(db.History) do
    table.insert(tmp,ii)
  end
  cnt = #tmp
  table.sort(tmp, function(i1,i2) return i1.last < i2.last end)
  indicatortip:SetHeaderFont(tooltip:GetHeaderFont())
  indicatortip:SetCell(indicatortip:AddHeader(),1,GOLDFONT..cnt.." "..L["Recent Instances"]..": "..FONTEND,"LEFT",2)
  for _,ii in ipairs(tmp) do
    local tstr = REDFONT..SecondsToTime(ii.last+addon.histReapTime - time(),false,false,1)..FONTEND
    indicatortip:AddLine(tstr, ii.desc)
  end
  indicatortip:AddLine("")
  indicatortip:SetCell(indicatortip:AddLine(),1,
    string.format(L["These are the instances that count towards the %i instances per hour account limit, and the time until they expire."],
      addon.histLimit),"LEFT",2,nil,nil,nil,250)
  finishIndicator()
end

local function ShowWorldBossTooltip(cell, arg, ...)
  local worldbosses = arg[1]
  local toon = arg[2]
  local saved = arg[3]
  if not worldbosses or not toon then return end
  openIndicator(2, "LEFT","RIGHT")
  local line = indicatortip:AddHeader()
  local toonstr = (db.Tooltip.ShowServer and toon) or strsplit(' ', toon)
  local t = vars.db.Toons[toon]
  local reset = t.WeeklyResetTime or addon:GetNextWeeklyResetTime()
  indicatortip:SetCell(line, 1, ClassColorise(vars.db.Toons[toon].Class, toonstr), indicatortip:GetHeaderFont(), "LEFT")
  indicatortip:SetCell(line, 2, GOLDFONT .. L["World Bosses"] .. FONTEND, indicatortip:GetHeaderFont(), "RIGHT")
  indicatortip:AddLine(YELLOWFONT .. L["Time Left"] .. ":" .. FONTEND, SecondsToTime(reset - time()))
  for _, instance in ipairs(worldbosses) do
    local thisinstance = vars.db.Instances[instance]
    if thisinstance then
      local info = thisinstance[toon] and thisinstance[toon][2]
      local n = indicatortip:AddLine()
      indicatortip:SetCell(n, 1, instance, "LEFT")
      if info and info[1] then
        indicatortip:SetCell(n, 2, REDFONT..ALREADY_LOOTED..FONTEND, "RIGHT")
      else
        indicatortip:SetCell(n, 2, GREENFONT..AVAILABLE..FONTEND, "RIGHT")
      end
    end
  end
  finishIndicator()
end

local function ShowLFRTooltip(cell, arg, ...)
  local boxname = arg[1]
  local toon = arg[2]
  local lfrmap = arg[3]
  local t = vars.db.Toons[toon]
  if not boxname or not t or not lfrmap then return end
  openIndicator(3, "LEFT", "LEFT","RIGHT")
  local line = indicatortip:AddHeader()
  local toonstr = (db.Tooltip.ShowServer and toon) or strsplit(' ', toon)
  local reset = t.WeeklyResetTime or addon:GetNextWeeklyResetTime()
  indicatortip:SetCell(line, 1, ClassColorise(vars.db.Toons[toon].Class, toonstr), indicatortip:GetHeaderFont(), "LEFT", 1)
  indicatortip:SetCell(line, 2, GOLDFONT .. boxname .. FONTEND, indicatortip:GetHeaderFont(), "RIGHT", 2)
  indicatortip:AddLine(YELLOWFONT .. L["Time Left"] .. ":" .. FONTEND, nil, SecondsToTime(reset - time()))
  for i=1,20 do
    local instance = lfrmap[boxname..":"..i]
    local diff = 2
    if instance then
      indicatortip:SetCell(indicatortip:AddLine(), 1, YELLOWFONT .. instance .. FONTEND, "CENTER",3)
      local thisinstance = vars.db.Instances[instance]
      local info = thisinstance[toon] and thisinstance[toon][diff]
      local killed, total, base, remap = addon:instanceBosses(instance,toon,diff)
      for i=base,base+total-1 do
        local bossid = i
        if remap then
          bossid = remap[i-base+1]
        end
        local bossname = GetLFGDungeonEncounterInfo(thisinstance.LFDID, bossid);
        local n = indicatortip:AddLine()
        indicatortip:SetCell(n, 1, bossname, "LEFT", 2)
        if info and info[bossid] then
          indicatortip:SetCell(n, 3, REDFONT..ALREADY_LOOTED..FONTEND, "RIGHT", 1)
        else
          indicatortip:SetCell(n, 3, GREENFONT..AVAILABLE..FONTEND, "RIGHT", 1)
        end
      end
    end
  end
  finishIndicator()
end

local function ShowIndicatorTooltip(cell, arg, ...)
  local instance = arg[1]
  local toon = arg[2]
  local diff = arg[3]
  if not instance or not toon or not diff then return end
  openIndicator(3, "LEFT", "LEFT","RIGHT")
  local thisinstance = vars.db.Instances[instance]
  local worldboss = thisinstance and thisinstance.WorldBoss
  local info = thisinstance[toon][diff]
  local id = info.ID
  local nameline = indicatortip:AddHeader()
  indicatortip:SetCell(nameline, 1, DifficultyString(instance, diff, toon), indicatortip:GetHeaderFont(), "LEFT", 1)
  indicatortip:SetCell(nameline, 2, GOLDFONT .. instance .. FONTEND, indicatortip:GetHeaderFont(), "RIGHT", 2)
  local toonline = indicatortip:AddHeader()
  local toonstr = (db.Tooltip.ShowServer and toon) or strsplit(' ', toon)
  indicatortip:SetCell(toonline, 1, ClassColorise(vars.db.Toons[toon].Class, toonstr), indicatortip:GetHeaderFont(), "LEFT", 1)
  indicatortip:SetCell(toonline, 2, addon:idtext(thisinstance,diff,info), "RIGHT", 2)
  local EMPH = " !!! "
  if info.Extended then
    indicatortip:SetCell(indicatortip:AddLine(),1,WHITEFONT .. EMPH .. L["Extended Lockout - Not yet saved"] .. EMPH .. FONTEND,"CENTER",3)
  elseif info.Locked == false and info.ID > 0 then
    indicatortip:SetCell(indicatortip:AddLine(),1,WHITEFONT .. EMPH .. L["Expired Lockout - Can be extended"] .. EMPH .. FONTEND,"CENTER",3)
  end
  if info.Expires > 0 then
    indicatortip:AddLine(YELLOWFONT .. L["Time Left"] .. ":" .. FONTEND, nil, SecondsToTime(thisinstance[toon][diff].Expires - time()))
  end
  if (info.ID or 0) > 0 and (
    (thisinstance.Raid and (diff == 5 or diff == 6 or diff == 16)) -- raid: 10 heroic, 25 heroic or mythic
    or
    (diff == 23) -- mythic 5-man
    ) then
    local n = indicatortip:AddLine()
    indicatortip:SetCell(n, 1, YELLOWFONT .. ID .. ":" .. FONTEND, "LEFT", 1)
    indicatortip:SetCell(n, 2, info.ID, "RIGHT", 2)
  end
  if info.Link then
    scantt:SetOwner(UIParent,"ANCHOR_NONE")
    scantt:SetHyperlink(info.Link)
    local name = scantt:GetName()
    local gotbossinfo
    for i=2,scantt:NumLines() do
      local left,right = _G[name.."TextLeft"..i], _G[name.."TextRight"..i]
      if right and right:GetText() then
        local n = indicatortip:AddLine()
        indicatortip:SetCell(n, 1, coloredText(left), "LEFT", 2)
        indicatortip:SetCell(n, 3, coloredText(right), "RIGHT", 1)
        gotbossinfo = true
      else
        indicatortip:SetCell(indicatortip:AddLine(),1,coloredText(left),"CENTER",3)
      end
    end
    if not gotbossinfo then
      local exc = addon:instanceException(thisinstance.LFDID)
      local bits = tonumber(info.Link:match(":(%d+)\124h"))
      if exc and bits then
        for i=1,exc.total do
          local n = indicatortip:AddLine()
          indicatortip:SetCell(n, 1, exc[i], "LEFT", 2)
          local text = "\124cff00ff00"..BOSS_ALIVE.."\124r"
          if bit.band(bits,1) > 0 then
            text = "\124cffff1f1f"..BOSS_DEAD.."\124r"
          end
          indicatortip:SetCell(n, 3, text, "RIGHT", 1)
          bits = bit.rshift(bits,1)
        end
      else
        indicatortip:SetCell(indicatortip:AddLine(),1,WHITEFONT ..
          L["Boss kill information is missing for this lockout.\nThis is a Blizzard bug affecting certain old raids."] ..
          FONTEND,"CENTER",3)
      end
    end
  end
  if info.ID < 0 then
    local killed, total, base, remap = addon:instanceBosses(instance,toon,diff)
    for i=base,base+total-1 do
      local bossid = i
      if remap then
        bossid = remap[i-base+1]
      end
      local bossname
      if worldboss then
        bossname = addon.WorldBosses[worldboss].name or "UNKNOWN"
      else
        bossname = GetLFGDungeonEncounterInfo(thisinstance.LFDID, bossid);
      end
      local n = indicatortip:AddLine()
      indicatortip:SetCell(n, 1, bossname, "LEFT", 2)
      if info[bossid] then
        indicatortip:SetCell(n, 3, REDFONT..ALREADY_LOOTED..FONTEND, "RIGHT", 1)
      else
        indicatortip:SetCell(n, 3, GREENFONT..AVAILABLE..FONTEND, "RIGHT", 1)
      end
    end
  end
  finishIndicator()
end

local colorpat = "\124c%c%c%c%c%c%c%c%c"
local weeklycap = CURRENCY_WEEKLY_CAP:gsub("%%%d*?([ds])","%%%1")
local weeklycap_scan = weeklycap:gsub("%%d","(%%d+)"):gsub("%%s","(\124c%%x%%x%%x%%x%%x%%x%%x%%x)")
weeklycap = weeklycap:gsub("%%d","%%s")
local totalcap = CURRENCY_TOTAL_CAP:gsub("%%%d*?([ds])","%%%1")
local totalcap_scan = totalcap:gsub("%%d","(%%d+)"):gsub("%%s","(\124c%%x%%x%%x%%x%%x%%x%%x%%x)")
totalcap = totalcap:gsub("%%d","%%s")
local season_scan = CURRENCY_SEASON_TOTAL:gsub("%%%d*?([ds])","(%%%1*)")

function addon:GetSeasonCurrency(idx)
  scantt:SetOwner(UIParent,"ANCHOR_NONE")
  scantt:SetCurrencyByID(idx)
  local name = scantt:GetName()
  for i=1,scantt:NumLines() do
    local left = _G[name.."TextLeft"..i]
    if left:GetText():find(season_scan) then
      return left:GetText()
    end
  end
  return nil
end

local function ShowSpellIDTooltip(cell, arg, ...)
  local toon, spellid, timestr = unpack(arg)
  if not toon or not spellid or not timestr then return end
  openIndicator(2, "LEFT","RIGHT")
  indicatortip:AddHeader(ClassColorise(vars.db.Toons[toon].Class, strsplit(' ', toon)), timestr)
  if spellid > 0 then
    local tip = vars.db.spelltip and vars.db.spelltip[spellid]
    for i=1,#tip do
      indicatortip:AddLine("")
      indicatortip:SetCell(indicatortip:GetLineCount(),1,tip[i], nil, "LEFT",2, nil, nil, nil, 250)
    end
  else
    local queuestr = LFG_RANDOM_COOLDOWN_YOU:match("^(.+)\n")
    indicatortip:AddLine(LFG_TYPE_RANDOM_DUNGEON)
    indicatortip:AddLine("")
    indicatortip:SetCell(indicatortip:GetLineCount(),1,queuestr, nil, "LEFT",2, nil, nil, nil, 250)
  end
  finishIndicator()
end

local function ShowCurrencyTooltip(cell, arg, ...)
  local toon, idx, ci = unpack(arg)
  if not toon or not idx or not ci then return end
  local name,_,tex = GetCurrencyInfo(idx)
  tex = " \124T"..tex..":0\124t"
  openIndicator(2, "LEFT","RIGHT")
  indicatortip:AddHeader(ClassColorise(vars.db.Toons[toon].Class, strsplit(' ', toon)), CurrencyColor(ci.amount or 0,ci.totalMax)..tex)

  scantt:SetOwner(UIParent,"ANCHOR_NONE")
  scantt:SetCurrencyByID(idx)
  name = scantt:GetName()
  local spacer
  for i=1,scantt:NumLines() do
    local left = _G[name.."TextLeft"..i]
    local text = left:GetText()
    if text:find(weeklycap_scan) or
      text:find(totalcap_scan) or
      text:find(season_scan) then
    -- omit player's values
    else
      indicatortip:AddLine("")
      indicatortip:SetCell(indicatortip:GetLineCount(),1,coloredText(left), nil, "LEFT",2, nil, nil, nil, 250)
      spacer = #strtrim(text) == 0
    end
  end
  if ci.weeklyMax and ci.weeklyMax > 0 then
    if not spacer then indicatortip:AddLine(" "); spacer = true end
    indicatortip:AddLine(weeklycap:format("", CurrencyColor(ci.earnedThisWeek or 0,ci.weeklyMax), addon:formatNumber(ci.weeklyMax)))
  end
  if ci.totalMax and ci.totalMax > 0 then
    if not spacer then indicatortip:AddLine(" "); spacer = true end
    indicatortip:AddLine(totalcap:format("", CurrencyColor(ci.amount or 0,ci.totalMax), addon:formatNumber(ci.totalMax)))
  end
  if ci.season and #ci.season > 0 then
    if not spacer then indicatortip:AddLine(" "); spacer = true end
    local str = ci.season
    local num = str:match("(%d+)")
    if num then
      str = str:gsub(num,addon:formatNumber(num))
    end
    indicatortip:AddLine(str)
  end
  finishIndicator()
end

local function ShowCurrencySummary(cell, arg, ...)
  local idx = arg
  if not idx then return end
  local name,_,tex = GetCurrencyInfo(idx)
  tex = " \124T"..tex..":0\124t"
  openIndicator(2, "LEFT","RIGHT")
  indicatortip:AddHeader(name, "")
  local total = 0
  local tmax
  local temp = {}
  for toon, t in pairs(vars.db.Toons) do -- deliberately include ALL toons
    local ci = t.currency and t.currency[idx]
    if ci and ci.amount then
      tmax = tmax or ci.totalMax
      table.insert(temp, { ["toon"] = toon, ["amount"] = ci.amount,
        ["str1"] = ClassColorise(t.Class, toon),
        ["str2"] = CurrencyColor(ci.amount or 0,tmax)..tex,
      })
      total = total + ci.amount
    end
  end
  indicatortip:SetCell(1,2,CurrencyColor(total,0)..tex)
  --indicatortip:AddLine(TOTAL, CurrencyColor(total,tmax)..tex)
  --indicatortip:AddLine(" ")
  addon.currency_sort = addon.currency_sort or function(a,b)
    if a.amount > b.amount then
      return true
    elseif a.amount < b.amount then
      return false
    end
    local an, as = a.toon:match('^(.*) [-] (.*)$')
    local bn, bs = b.toon:match('^(.*) [-] (.*)$')
    if db.Tooltip.ServerSort and as ~= bs then
      return as < bs
    else
      return a.toon < b.toon
    end
  end
  table.sort(temp, addon.currency_sort)
  for _,t in ipairs(temp) do
    indicatortip:AddLine(t.str1, t.str2)
  end

  finishIndicator()
end

-- global addon code below
function core:toonInit()
  local ti = db.Toons[thisToon] or { }
  db.Toons[thisToon] = ti
  ti.LClass, ti.Class = UnitClass("player")
  ti.Level = UnitLevel("player")
  ti.Show = ti.Show or "saved"
  ti.Order = ti.Order or 50
  ti.Quests = ti.Quests or {}
  ti.Skills = ti.Skills or {}
  -- try to get a reset time, but don't overwrite existing, which could break quest list
  -- real update comes later in UpdateToonData
  ti.DailyResetTime = ti.DailyResetTime or addon:GetNextDailyResetTime()
  ti.WeeklyResetTime = ti.WeeklyResetTime or addon:GetNextWeeklyResetTime()
end

function core:OnInitialize()
  local versionString = GetAddOnMetadata(addonName, "version")
  --[===[@debug@
  if versionString == "8.0.5" then
    versionString = "Dev"
  end
  --@end-debug@]===]
  SavedInstances.version = versionString

  SavedInstancesDB = SavedInstancesDB or vars.defaultDB
  -- begin backwards compatibility
  if not SavedInstancesDB.DBVersion or SavedInstancesDB.DBVersion < 10 then
    SavedInstancesDB = vars.defaultDB
  elseif SavedInstancesDB.DBVersion < 12 then
    SavedInstancesDB.Indicators = vars.defaultDB.Indicators
    SavedInstancesDB.DBVersion = 12
  end

  -- end backwards compatibilty
  db = db or SavedInstancesDB
  vars.db = db
  config = vars.config
  core:toonInit()
  db.Lockouts = nil -- deprecated
  db.History = db.History or {}
  db.Quests = db.Quests or vars.defaultDB.Quests
  db.QuestDB = db.QuestDB or vars.defaultDB.QuestDB
  for name,default in pairs(vars.defaultDB.Tooltip) do
    db.Tooltip[name] = (db.Tooltip[name]==nil and default) or db.Tooltip[name]
  end
  for _, id in ipairs(addon.currency) do
    local name = "Currency"..id
    db.Tooltip[name] = (db.Tooltip[name]==nil and  vars.defaultDB.Tooltip[name]) or db.Tooltip[name]
  end
  local currtmp = {}
  for _,idx in ipairs(currency) do currtmp[idx] = true end
  for toon, t in pairs(vars.db.Toons) do
    t.Order = t.Order or 50
    if t.currency then -- clean old undiscovered currency entries
      for idx, ci in pairs(t.currency) do
        -- detect outdated entries because new version doesn't explicitly store max zeros
        if (ci.amount == 0 and (ci.weeklyMax == 0 or ci.totalMax == 0))
          or ci.amount == nil -- another outdated entry type created by old weekly reset logic
          or not currtmp[idx] -- removed currency
        then
          t.currency[idx] = nil
        end
    end
    end
  end
  for qid, _ in pairs(db.QuestDB.Daily) do
    if db.QuestDB.AccountDaily[qid] then
      debug("Removing duplicate questDB entry: "..qid)
      db.QuestDB.Daily[qid] = nil
    end
  end
  for qid, escope in pairs(QuestExceptions) do -- upgrade QuestDB with new exceptions
    local val = -1 -- default to a blank zone
    for scope, qdb in pairs(db.QuestDB) do
      val = qdb[qid] or val
      qdb[qid] = nil
    end
    if db.QuestDB[escope] then
      db.QuestDB[escope][qid] = val
    end
  end
  RequestRaidInfo() -- get lockout data
  RequestLFDPlayerLockInfo()
  vars.dataobject = vars.LDB and vars.LDB:NewDataObject("SavedInstances", {
    text = addonAbbrev,
    type = "launcher",
    icon = "Interface\\Addons\\SavedInstances\\icon.tga",
    OnEnter = function(frame)
      if not addon:IsDetached() and not db.Tooltip.DisableMouseover then
        core:ShowTooltip(frame)
      end
    end,
    OnLeave = function(frame) end,
    OnClick = function(frame, button)
      if button == "MiddleButton" then
        if InCombatLockdown() then return end
        ToggleFriendsFrame(4) -- open Blizzard Raid window
        RaidInfoFrame:Show()
      elseif button == "LeftButton" then
        addon:ToggleDetached()
      else
        config:ShowConfig()
      end
    end
  })
  if vars.icon then
    vars.icon:Register(addonName, vars.dataobject, db.MinimapIcon)
    vars.icon:Refresh(addonName)
  end
  addon.BonusRollShow() -- catch roll-on-load
end

function core:OnEnable()
  self:RegisterBucketEvent("UPDATE_INSTANCE_INFO", 2, function() core:Refresh(nil) end)
  self:RegisterBucketEvent("LOOT_CLOSED", 1, function() core:QuestRefresh(nil) end)
  self:RegisterBucketEvent("LFG_UPDATE_RANDOM_INFO", 1, function() addon:UpdateInstanceData(); addon:UpdateToonData() end)
  self:RegisterBucketEvent("RAID_INSTANCE_WELCOME", 1, RequestRaidInfo)
  self:RegisterEvent("CHAT_MSG_SYSTEM", "CheckSystemMessage")
  self:RegisterEvent("CHAT_MSG_CURRENCY", "CheckSystemMessage")
  self:RegisterEvent("CHAT_MSG_LOOT", "CheckSystemMessage")
  self:RegisterBucketEvent("CURRENCY_DISPLAY_UPDATE", 0.25, function() addon:UpdateCurrency() end)
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  self:RegisterBucketEvent("TRADE_SKILL_LIST_UPDATE", 1)
  self:RegisterBucketEvent("PLAYER_ENTERING_WORLD", 1, RequestRaidInfo)
  self:RegisterBucketEvent("LFG_LOCK_INFO_RECEIVED", 1, RequestRaidInfo)
  self:RegisterEvent("BONUS_ROLL_RESULT", "BonusRollResult")
  self:RegisterEvent("PLAYER_LOGOUT", function() addon.logout = true ; addon:UpdateToonData() end) -- update currency spent
  self:RegisterEvent("LFG_COMPLETION_REWARD", "RefreshLockInfo") -- for random daily dungeon tracking
  self:RegisterEvent("BOSS_KILL")
  self:RegisterEvent("ENCOUNTER_END", "EncounterEnd")
  self:RegisterEvent("BAG_UPDATE", "RefreshMythicKeyInfo")
  self:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE", "RefreshMythicKeyInfo")
  self:RegisterEvent("PLAYER_ENTERING_WORLD", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("ADDON_LOADED", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("QUEST_LOG_UPDATE", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", "RefreshDailyWorldQuestInfo")
  self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
  self:RegisterEvent("TIME_PLAYED_MSG", function(_,total,level)
    local t = thisToon and vars and vars.db and vars.db.Toons[thisToon]
    if total > 0 and t then
      t.PlayedTotal = total
      t.PlayedLevel = level
    end
    addon.PlayedTime = time()
    if addon.playedpending then
      for c,_ in pairs(addon.playedreg) do
        c:RegisterEvent("TIME_PLAYED_MSG") -- Restore default
      end
      addon.playedpending = false
    end
  end)
  self:RegisterEvent("ADDON_LOADED")
  core:ADDON_LOADED()
  if not addon.resetDetect then
    addon.resetDetect = CreateFrame("Button", "SavedInstancesResetDetectHiddenFrame", UIParent)
    for _,e in pairs({
      "RAID_INSTANCE_WELCOME",
      "PLAYER_ENTERING_WORLD", "CHAT_MSG_SYSTEM", "CHAT_MSG_ADDON",
      "ZONE_CHANGED_NEW_AREA",
      "INSTANCE_BOOT_START", "INSTANCE_BOOT_STOP", "GROUP_ROSTER_UPDATE",
    }) do
      addon.resetDetect:RegisterEvent(e)
    end
  end
  addon.resetDetect:SetScript("OnEvent", addon.HistoryEvent)
  C_ChatInfo.RegisterAddonMessagePrefix(addonName)
  addon:HistoryEvent("PLAYER_ENTERING_WORLD") -- update after initial load
  addon:specialQuests()
  core:RefreshMythicKeyInfo()
  core:updateRealmMap()
  core:RefreshDailyWorldQuestInfo()
end

function core:ADDON_LOADED()
  if DBM and DBM.EndCombat and not addon.dbmhook then
    addon.dbmhook = true
    hooksecurefunc(DBM, "EndCombat", function(self, mod, wipe)
      core:BossModEncounterEnd("DBM:EndCombat", mod and mod.combatInfo and mod.combatInfo.name)
    end)
  end
  if BigWigsLoader and not addon.bigwigshook then
    addon.bigwigshook = true
    BigWigsLoader.RegisterMessage(self, "BigWigs_OnBossWin", function(self, event, mod)
      core:BossModEncounterEnd("BigWigs_OnBossWin", mod and mod.displayName)
    end)
  end
end

function core:OnDisable()
  self:UnregisterAllEvents()
  addon.resetDetect:SetScript("OnEvent", nil)
end

function core:RequestLockInfo() -- request lock info from the server immediately
  RequestRaidInfo()
  RequestLFDPlayerLockInfo()
end

function core:RefreshLockInfo() -- throttled lock update with retry
  local now = GetTime()
  if now > (core.lastrefreshlock or 0) + 1 then
    core.lastrefreshlock = now
    core:RequestLockInfo()
  end
  if now > (core.lastrefreshlocksched or 0) + 120 then
    -- make sure we update any lockout info (sometimes there's server-side delay)
    core.lastrefreshlockshed = now
    core:ScheduleTimer("RequestLockInfo",5)
    core:ScheduleTimer("RequestLockInfo",30)
    core:ScheduleTimer("RequestLockInfo",60)
    core:ScheduleTimer("RequestLockInfo",90)
    core:ScheduleTimer("RequestLockInfo",120)
  end
end

local currency_msg = CURRENCY_GAINED:gsub(":.*$","")
function core:CheckSystemMessage(event, msg)
  local inst, t = IsInInstance()
  -- note: currency is already updated in TooltipShow,
  -- here we just hook JP/VP currency messages to capture lockout changes
  if inst and (t == "party" or t == "raid") and -- dont update on bg honor
    (msg:find(INSTANCE_SAVED) or -- first boss kill
    msg:find(currency_msg)) -- subsequent boss kills (unless capped or over level)
  then
    core:RefreshLockInfo()
  end
end

function core:updateRealmMap()
  local realm = GetRealmName():gsub("%s+","")
  local lmap = GetAutoCompleteRealms()
  local rmap = vars.db.RealmMap or {}
  vars.db.RealmMap = rmap
  if lmap and next(lmap) then -- connected realms detected
    table.sort(lmap)
    local mapid = rmap[realm] -- find existing map
    if not mapid then
      for _,r in ipairs(lmap) do
        mapid = mapid or rmap[r]
      end
    end
    if mapid then -- check for possible expansion
      local oldmap = rmap[mapid]
      if oldmap and #lmap > #oldmap then
        rmap[mapid] = lmap
      end
    else -- new map
      mapid = #rmap + 1
      rmap[mapid] = lmap
    end
    for _,r in ipairs(rmap[mapid]) do -- maintain inverse mapping
      rmap[r] = mapid
    end
  end
end

function core:RefreshMythicKeyInfo(event)

  if (event ~= "CHALLENGE_MODE_MAPS_UPDATE") then C_MythicPlus.RequestRewards() end -- This event is fired after the rewards data was requested, causing yet another refresh if not checked for

  local t = vars.db.Toons[thisToon]
  local _
  t.MythicKey = {}
  for bagID = 0, 4 do
    for invID = 1, GetContainerNumSlots(bagID) do
      local itemID = GetContainerItemID(bagID, invID)
      if itemID and itemID == 138019 then
        local keyLink = GetContainerItemLink(bagID, invID)
        local KeyInfo = {strsplit(':', keyLink)}
        local mapID = tonumber(KeyInfo[3])
        local mapLevel = tonumber(KeyInfo[4])
        local color
        if KeyInfo[4] == "0" then
          _,_,_,color = GetItemQualityColor(0)
        elseif mapLevel >= 10 then
          _,_,_,color = GetItemQualityColor(4)
        elseif mapLevel >= 7 then
          _,_,_,color = GetItemQualityColor(3)
        elseif mapLevel >= 4 then
          _,_,_,color = GetItemQualityColor(2)
        else
          _,_,_,color = GetItemQualityColor(1)
        end
        if vars.db.Tooltip.DebugMode then
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[1]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[2]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[3]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[4]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[5]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[6]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[7]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[8]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[9]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[10]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[11]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[12]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[13]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[14]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[15]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[16]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[17]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[18]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[19]))
          DEFAULT_CHAT_FRAME:AddMessage(tostring(KeyInfo[20]))
        end
        t.MythicKey.abbrev = KeystoneAbbrev[mapID]
        t.MythicKey.link = C_ChallengeMode.GetMapUIInfo(mapID)
        t.MythicKey.color = color
        t.MythicKey.level = mapLevel
        t.MythicKey.ResetTime = addon:GetNextWeeklyResetTime()
        t.MythicKey.link = keyLink
      end
    end
  end
  local MythicMaps = { }
  C_MythicPlus.RequestMapInfo()
  MythicMaps = C_ChallengeMode.GetMapTable()
  local bestlevel = 0
  for i = 1, #MythicMaps do
    local _, level = C_MythicPlus.GetWeeklyBestForMap(MythicMaps[i]);
    if level then
      if level > bestlevel then
        bestlevel = level
      end
    end
  end
  if t.MythicKeyBest and (t.MythicKeyBest.ResetTime or 0) < time() then -- dont know weekly reset function will run early or not
    if t.MythicKeyBest.level and t.MythicKeyBest.level > 0 then
      t.MythicKeyBest.LastWeekLevel = t.MythicKeyBest.level
  end
  end
  t.MythicKeyBest = t.MythicKeyBest or { }
  t.MythicKeyBest.ResetTime = addon:GetNextWeeklyResetTime()
  t.MythicKeyBest.level = bestlevel
  t.MythicKeyBest.WeeklyReward = C_MythicPlus.IsWeeklyRewardAvailable()
end

function core:RefreshDailyWorldQuestInfo()
  local t = vars.db.Toons[thisToon]
  t.DailyWorldQuest = {}
  local BountyQuest = GetQuestBountyInfoForMapID(876)
  for BountyIndex, BountyInfo in ipairs(BountyQuest) do
    local title = GetQuestLogTitle(GetQuestLogIndexByID(BountyInfo.questID))
    local timeleft = C_TaskQuest.GetQuestTimeLeftMinutes(BountyInfo.questID)
    local _, _, isFinish, questDone, questNeed = GetQuestObjectiveInfo(BountyInfo.questID, 1, false)
    if timeleft then
      if timeleft > 2880 then
        if t.DailyWorldQuest.days2 then else t.DailyWorldQuest.days2 = {} end
        t.DailyWorldQuest.days2.name = title
        t.DailyWorldQuest.days2.dayleft = 2
        t.DailyWorldQuest.days2.questneed = questNeed
        t.DailyWorldQuest.days2.questdone = questDone
        t.DailyWorldQuest.days2.isfinish = isFinish
        t.DailyWorldQuest.days2.iscompleted = IsQuestFlaggedCompleted(BountyInfo.questID)
      elseif timeleft > 1440 then
        if t.DailyWorldQuest.days1 then else t.DailyWorldQuest.days1 = {} end
        t.DailyWorldQuest.days1.name = title
        t.DailyWorldQuest.days1.dayleft = 1
        t.DailyWorldQuest.days1.questneed = questNeed
        t.DailyWorldQuest.days1.questdone = questDone
        t.DailyWorldQuest.days1.isfinish = isFinish
        t.DailyWorldQuest.days1.iscompleted = IsQuestFlaggedCompleted(BountyInfo.questID)
      else
        if t.DailyWorldQuest.days0 then else t.DailyWorldQuest.days0 = {} end
        t.DailyWorldQuest.days0.name = title
        t.DailyWorldQuest.days0.dayleft = 0
        t.DailyWorldQuest.days0.questneed = questNeed
        t.DailyWorldQuest.days0.questdone = questDone
        t.DailyWorldQuest.days0.isfinish = isFinish
        t.DailyWorldQuest.days0.iscompleted = IsQuestFlaggedCompleted(BountyInfo.questID)
      end
    end
  end
  if IsQuestFlaggedCompleted(43341) then
    if t.DailyWorldQuest.days0 == nil then
      t.DailyWorldQuest.days0 = {}
      t.DailyWorldQuest.days0.dayleft = 0
      t.DailyWorldQuest.days0.iscompleted = true
      t.DailyWorldQuest.days0.name = L["Emissary Missing"]
    end
    if t.DailyWorldQuest.days1 == nil then
      t.DailyWorldQuest.days1 = {}
      t.DailyWorldQuest.days1.dayleft = 1
      t.DailyWorldQuest.days1.iscompleted = true
      t.DailyWorldQuest.days1.name = L["Emissary Missing"]
    end
    if t.DailyWorldQuest.days2 == nil then
      t.DailyWorldQuest.days2 = {}
      t.DailyWorldQuest.days2.dayleft = 2
      t.DailyWorldQuest.days2.iscompleted = true
      t.DailyWorldQuest.days2.name = L["Emissary Missing"]
    end
  end
end

function core:getRealmGroup(realm)
  -- returns realm-group-id, { realm1, realm2, ...} for connected realm, or nil,nil for unconnected
  realm = realm:gsub("%s+","")
  local rmap = vars.db.RealmMap
  local gid = rmap and rmap[realm]
  return gid, gid and rmap[gid]
end

function core:CHAT_MSG_MONSTER_YELL(event, msg, bossname)
  -- cheapest possible outdoor boss detection for players lacking a proper boss mod
  -- should work for sha and nalak, oon and gal report a related mob
  local t = vars.db.Toons[thisToon]
  local now = time()
  if bossname and t then
    bossname = tostring(bossname) -- for safety
    local diff = select(4,GetInstanceInfo())
    if diff and #diff > 0 then bossname = bossname .. ": ".. diff end
    t.lastbossyell = bossname
    t.lastbossyelltime = now
    --debug("CHAT_MSG_MONSTER_YELL: "..tostring(bossname));
  end
end

function core:BossModEncounterEnd(modname, bossname)
  local t = vars.db.Toons[thisToon]
  local now = time()
  if bossname and t and now > (t.lastbosstime or 0) + 2*60 then
    -- boss mods can often detect completion before ENCOUNTER_END
    -- also some world bosses never send ENCOUNTER_END
    -- enough timeout to prevent overwriting, but short enough to prevent cross-boss contamination
    bossname = tostring(bossname) -- for safety
    local diff = select(4,GetInstanceInfo())
    if diff and #diff > 0 then bossname = bossname .. ": ".. diff end
    t.lastboss = bossname
    t.lastbosstime = now
  end
  debug("%s refresh: %s",(modname or "BossMod"),tostring(bossname));
  core:RefreshLockInfo()
end

function core:EncounterEnd(event, encounterID, encounterName, difficultyID, raidSize, endStatus)
  debug("EncounterEnd:%s:%s:%s:%s:%s",tostring(encounterID),tostring(encounterName),tostring(difficultyID),tostring(raidSize),tostring(endStatus))
  if endStatus ~= 1 then return end -- wipe
  core:RefreshLockInfo()
  local t = vars.db.Toons[thisToon]
  if not t then return end
  local name = encounterName
  if difficultyID and difficultyID > 0 then
    local diff = GetDifficultyInfo(difficultyID)
    if diff and #diff > 0 then
      name = name ..": "..diff
    end
  end
  t.lastboss = name
  t.lastbosstime = time()
end

function core:BOSS_KILL(event, encounterID, encounterName, ...)
  debug("BOSS_KILL:%s:%s",tostring(encounterID),tostring(encounterName)) -- ..":"..strjoin(":",...))
  local name = encounterName
  if name and type(name) == "string" then
    name = name:gsub(",.*$","") -- remove extraneous trailing boss titles
    name = strtrim(name)
    core:BossModEncounterEnd("BOSS_KILL", name)
  end
end

function addon:InGroup()
  if IsInRaid() then return "RAID"
  elseif GetNumGroupMembers() > 0 then return "PARTY"
  else return nil end
end

local function doExplicitReset(instancemsg, failed)
  if HasLFGRestrictions() or IsInInstance() or
    (addon:InGroup() and not UnitIsGroupLeader("player")) then return end
  if not failed then
    addon:HistoryUpdate(true)
  end

  local reportchan = addon:InGroup()
  if reportchan then
    if not failed then
      C_ChatInfo.SendAddonMessage(addonName, "GENERATION_ADVANCE", reportchan)
    end
    if vars.db.Tooltip.ReportResets then
      local msg = instancemsg or RESET_INSTANCES
      msg = msg:gsub("\1241.+;.+;","") -- ticket 76, remove |1;; escapes on koKR
      SendChatMessage("<"..addonName.."> "..msg, reportchan)
    end
  end
end
hooksecurefunc("ResetInstances", doExplicitReset)

local resetmsg = INSTANCE_RESET_SUCCESS:gsub("%%s",".+")
local resetfails = { INSTANCE_RESET_FAILED, INSTANCE_RESET_FAILED_OFFLINE, INSTANCE_RESET_FAILED_ZONING }
for k,v in pairs(resetfails) do
  resetfails[k] = v:gsub("%%s",".+")
end
local raiddiffmsg = ERR_RAID_DIFFICULTY_CHANGED_S:gsub("%%s",".+")
local dungdiffmsg = ERR_DUNGEON_DIFFICULTY_CHANGED_S:gsub("%%s",".+")
local delaytime = 3 -- seconds to wait on zone change for settings to stabilize
function addon.HistoryEvent(f, evt, ...)
  --debug("HistoryEvent: "..evt, ...)
  if evt == "CHAT_MSG_ADDON" then
    local prefix, message, channel, sender = ...
    if prefix ~= addonName then return end
    if message:match("^GENERATION_ADVANCE$") and not UnitIsUnit(sender,"player") then
      addon:HistoryUpdate(true)
    end
  elseif evt == "CHAT_MSG_SYSTEM" then
    local msg = ...
    if msg:match("^"..resetmsg.."$") then -- I performed expicit reset
      doExplicitReset(msg)
    elseif msg:match("^"..INSTANCE_SAVED.."$") then -- just got saved
      core:ScheduleTimer("HistoryUpdate", delaytime+1)
    elseif (msg:match("^"..raiddiffmsg.."$") or msg:match("^"..dungdiffmsg.."$")) and
      not addon:histZoneKey() then -- ignore difficulty messages when creating a party while inside an instance
      addon:HistoryUpdate(true)
    elseif msg:match(TRANSFER_ABORT_TOO_MANY_INSTANCES) then
      addon:HistoryUpdate(false,true)
    else
      for _,m in pairs(resetfails) do
        if msg:match("^"..m.."$") then
          doExplicitReset(msg, true) -- send failure chat message
        end
      end
    end
  elseif evt == "INSTANCE_BOOT_START" then -- left group inside instance, resets on boot
    addon:HistoryUpdate(true)
  elseif evt == "INSTANCE_BOOT_STOP" and addon:InGroup() then -- invited back
    addon.delayedReset = false
  elseif evt == "GROUP_ROSTER_UPDATE" and
    addon.histInGroup and not addon:InGroup() and -- ignore failed invites when solo
    not addon:histZoneKey() then -- left group outside instance, resets now
    addon:HistoryUpdate(true)
  elseif evt == "PLAYER_ENTERING_WORLD" or evt == "ZONE_CHANGED_NEW_AREA" or evt == "RAID_INSTANCE_WELCOME" then
    -- delay updates while settings stabilize
    local waittime = delaytime + math.max(0,10 - GetFramerate())
    addon.delayUpdate = time() + waittime
    core:ScheduleTimer("HistoryUpdate", waittime+1)
  end
end


addon.histReapTime = 60*60 -- 1 hour
addon.histLimit = 10 -- instances per hour
function addon:histZoneKey()
  local instname, insttype, diff, diffname, maxPlayers, playerDifficulty, isDynamicInstance = GetInstanceInfo()
  if insttype == nil or insttype == "none" or insttype == "arena" or insttype == "pvp" then -- pvp doesnt count
    return nil
  end
  if IsInLFGDungeon() or IsInScenarioGroup() then -- LFG instances don't count
    return nil
  end
  if C_Garrison.IsOnGarrisonMap() then -- Garrisons don't count
    return nil
  end
  -- check if we're locked (using FindInstance so we don't complain about unsaved unknown instances)
  local truename = addon:FindInstance(instname, insttype == "raid")
  local locked = false
  local inst = truename and vars.db.Instances[truename]
  inst = inst and inst[thisToon]
  for d=1,maxdiff do
    if inst and inst[d] and inst[d].Locked then
      locked = true
    end
  end
  if diff == 1 and maxPlayers == 5 then -- never locked to 5-man regs
    locked = false
  end
  local toonstr = thisToon
  if not db.Tooltip.ShowServer then
    toonstr = strsplit(" - ", toonstr)
  end
  local desc = toonstr .. ": " .. instname
  if diffname and #diffname > 0 then
    desc = desc .. " - " .. diffname
  end
  local key = thisToon..":"..instname..":"..insttype..":"..diff
  if not locked then
    key = key..":"..vars.db.histGeneration
  end
  return key, desc, locked
end

function addon:HistoryUpdate(forcereset, forcemesg)
  vars.db.histGeneration = vars.db.histGeneration or 1
  if forcereset and addon:histZoneKey() then -- delay reset until we zone out
    debug("HistoryUpdate reset delayed")
    addon.delayedReset = true
  end
  if (forcereset or addon.delayedReset) and not addon:histZoneKey() then
    debug("HistoryUpdate generation advance")
    vars.db.histGeneration = (vars.db.histGeneration + 1) % 100000
    addon.delayedReset = false
  end
  local now = time()
  if addon.delayUpdate and now < addon.delayUpdate then
    debug("HistoryUpdate delayed")
    return
  end
  local zoningin = false
  local newzone, newdesc, locked = addon:histZoneKey()
  -- touch zone we left
  if addon.histLastZone then
    local lz = vars.db.History[addon.histLastZone]
    if lz then
      lz.last = now
    end
  elseif newzone then
    zoningin = true
  end
  addon.histLastZone = newzone
  addon.histInGroup = addon:InGroup()
  -- touch/create new zone
  if newzone then
    local nz = vars.db.History[newzone]
    if not nz then
      nz = { create = now, desc = newdesc }
      vars.db.History[newzone] = nz
      if locked then -- creating a locked instance, delete unlocked version
        vars.db.History[newzone..":"..vars.db.histGeneration] = nil
      end
    end
    nz.last = now
  end
  -- reap old zones
  local livecnt = 0
  local oldestkey, oldesttime
  for zk, zi in pairs(vars.db.History) do
    if now > zi.last + addon.histReapTime or
      zi.last > (now + 3600) then -- temporary bug fix
      debug("Reaping %s",zi.desc)
      vars.db.History[zk] = nil
    else
      livecnt = livecnt + 1
      if not oldesttime or zi.last < oldesttime then
        oldestkey = zk
        oldesttime = zi.last
      end
    end
  end
  local oldestrem = oldesttime and (oldesttime+addon.histReapTime-now)
  local oldestremt = (oldestrem and SecondsToTime(oldestrem,false,false,1)) or "n/a"
  local oldestremtm = (oldestrem and SecondsToTime(math.floor((oldestrem+59)/60)*60,false,false,1)) or "n/a"
  if addon.db.dbg then
    local msg = livecnt.." live instances, oldest ("..(oldestkey or "none")..") expires in "..oldestremt..". Current Zone="..(newzone or "nil")
    if msg ~= addon.lasthistdbg then
      addon.lasthistdbg = msg
      debug(msg)
    end
    --debug(vars.db.History)
  end
  -- display update

  if forcemesg or (vars.db.Tooltip.LimitWarn and zoningin and livecnt >= addon.histLimit-1) then
    chatMsg(L["Warning: You've entered about %i instances recently and are approaching the %i instance per hour limit for your account. More instances should be available in %s."],livecnt, addon.histLimit, oldestremt)
  end
  addon.histLiveCount = livecnt
  addon.histOldest = oldestremt
  if db.Tooltip.HistoryText and livecnt > 0 then
    vars.dataobject.text = "("..livecnt.."/"..(oldestremt or "?")..")"
    addon.histTextthrottle = math.min(oldestrem+1, addon.histTextthrottle or 15)
    addon.resetDetect:SetScript("OnUpdate", addon.histTextUpdate)
  else
    vars.dataobject.text = addonAbbrev
    addon.resetDetect:SetScript("OnUpdate", nil)
  end
end
function core:HistoryUpdate(...) return addon:HistoryUpdate(...) end
function addon.histTextUpdate(self, elap)
  addon.histTextthrottle = addon.histTextthrottle - elap
  if addon.histTextthrottle > 0 then return end
  addon.histTextthrottle = 15
  addon:HistoryUpdate()
end

local function localarr(name) -- save on memory churn by reusing arrays in updates
  name = "localarr#"..name
  core[name] = core[name] or {}
  return wipe(core[name])
end

function core:memcheck(context)
  UpdateAddOnMemoryUsage()
  local newval = GetAddOnMemoryUsage("SavedInstances")
  core.memusage = core.memusage or 0
  if newval ~= core.memusage then
    debug("%.3f KB in %s",(newval - core.memusage),context)
    core.memusage = newval
  end
end

-- Lightweight refresh of just quest flag information
-- all may be nil if not instantiataed
function core:QuestRefresh(recoverdaily, questcomplete, nextreset, weeklyreset)
  local tiq = vars.db.Toons[thisToon]
  tiq = tiq and tiq.Quests
  if not tiq then return end
  nextreset = nextreset or addon:GetNextDailyResetTime()
  weeklyreset = weeklyreset or addon:GetNextWeeklyResetTime()
  if not nextreset or not weeklyreset then return end

  for _, qinfo in pairs(addon:specialQuests()) do
    local qid = qinfo.quest
    if IsQuestFlaggedCompleted(qid) or (questcomplete and questcomplete[qid]) then
      local q = tiq[qid] or {}
      tiq[qid] = q
      q.Title = qinfo.name
      q.Zone = qinfo.zone
      if qinfo.daily then
        q.Expires = nextreset
        q.isDaily = true
      else
        q.Expires = weeklyreset
        q.isDaily = nil
      end
    end
  end

  local now = time()
  db.QuestDB.Weekly.expires = weeklyreset
  db.QuestDB.AccountWeekly.expires = weeklyreset
  db.QuestDB.Darkmoon.expires = addon:GetNextDarkmoonResetTime()
  for scope, list in pairs(db.QuestDB) do
    local questlist = tiq
    if scope:find("Account") then
      questlist = db.Quests
    end
    if recoverdaily or (scope ~= "Daily") then
      for qid, mapid in pairs(list) do
        if tonumber(qid) and (IsQuestFlaggedCompleted(qid) or
          (questcomplete and questcomplete[qid])) and not questlist[qid] and -- recovering a lost quest
          (list.expires == nil or list.expires > now) then -- don't repop darkmoon quests from last faire
          local title, link = addon:QuestInfo(qid)
          if title then
            local found
            for _,info in pairs(questlist) do
              if title == info.Title then -- avoid faction duplicates, since both flags are set
                found = true
                break
              end
            end
            if not found then
              debug("Recovering lost quest: "..title.." ("..scope..")")
              questlist[qid] = { ["Title"] = title, ["Link"] = link,
                ["isDaily"] = (scope:find("Daily") and true) or nil,
                ["Expires"] = list.expires,
                ["Zone"] = C_Map.GetMapInfo(mapid) }
            end
          end
        end
      end
    end
  end
  addon:QuestCount(thisToon)
end

function core:Refresh(recoverdaily)
  -- update entire database from the current character's perspective
  addon:UpdateInstanceData()
  if not addon.instancesUpdated then addon.RefreshPending = true; return end -- wait for UpdateInstanceData to succeed
  local nextreset = addon:GetNextDailyResetTime()
  if not nextreset or ((nextreset - time()) > (24*3600 - 5*60)) then  -- allow 5 minutes for quest DB to update after daily rollover
    debug("Skipping core:Refresh() near daily reset")
    addon:UpdateToonData()
    return
  end
  local temp = localarr("RefreshTemp")
  for name, instance in pairs(vars.db.Instances) do -- clear current toons lockouts before refresh
    local id = instance.LFDID
    if instance[thisToon]
    -- disabled for ticket 178/195:
    --and not (id and addon.LFRInstances[id] and select(2,GetLFGDungeonNumEncounters(id)) == 0) -- ticket 103
    then
      temp[name] = instance[thisToon] -- use a temp to reduce memory churn
      for diff,info in pairs(temp[name]) do
        wipe(info)
      end
      instance[thisToon] = nil
    end
  end
  local numsaved = GetNumSavedInstances()
  if numsaved > 0 then
    for i = 1, numsaved do
      local name, id, expires, diff, locked, extended, mostsig, raid, players, diffname = GetSavedInstanceInfo(i)
      local truename, instance = addon:LookupInstance(nil, name, raid)
      if diff ~= 7 and diff ~= 17 then -- Skip (legacy) LFR entries for this character to prevent writing them to the saved variables (from which they'd be purged after the next reload anyway)
        if expires and expires > 0 then
          expires = expires + time()
        else
          expires = 0
        end
        instance.Raid = instance.Raid or raid
        instance[thisToon] = instance[thisToon] or temp[truename] or { }
        local info = instance[thisToon][diff] or {}
        wipe(info)
        info.ID = id
        info.Expires = expires
        info.Link = GetSavedInstanceChatLink(i)
        info.Locked = locked
        info.Extended = extended
        instance[thisToon][diff] = info
      end
	end
  end

  local weeklyreset = addon:GetNextWeeklyResetTime()
  for id,_ in pairs(addon.LFRInstances) do
    local numEncounters, numCompleted = GetLFGDungeonNumEncounters(id);
    if ( numCompleted and numCompleted > 0 and weeklyreset ) then
      local truename, instance = addon:LookupInstance(id, nil, true)
      instance[thisToon] = instance[thisToon] or temp[truename] or { }
      local info = instance[thisToon][2] or {}
      instance[thisToon][2] = info
      if not (info.Expires and info.Expires < (time() + 300)) then -- ticket 109: don't refresh expiration close to reset
        wipe(info)
        info.Expires = weeklyreset
      end
      info.ID = -1*numEncounters
      for i=1, numEncounters do
        local bossName, texture, isKilled = GetLFGDungeonEncounterInfo(id, i);
        info[i] = isKilled
      end
    end
  end

  local questcomplete = GetQuestsCompleted(localarr("QuestCompleteTemp"))
  local wbsave = localarr("wbsave")
  if GetNumSavedWorldBosses and GetSavedWorldBossInfo then -- 5.4
    for i=1,GetNumSavedWorldBosses() do
      local name, id, reset = GetSavedWorldBossInfo(i)
      wbsave[name] = true
  end
  end
  for _,einfo in pairs(addon.WorldBosses) do
    if weeklyreset and (
      (einfo.quest and IsQuestFlaggedCompleted(einfo.quest)) or
      (questcomplete and einfo.quest and questcomplete[einfo.quest]) or
      wbsave[einfo.savename or einfo.name]
      ) then
      local truename = einfo.name
      local instance = vars.db.Instances[truename]
      instance[thisToon] = instance[thisToon] or temp[truename] or { }
      local info = instance[thisToon][2] or {}
      wipe(info)
      instance[thisToon][2] = info
      info.Expires = weeklyreset
      info.ID = -1
      info[1] = true
    end
  end

  core:QuestRefresh(recoverdaily, questcomplete, nextreset, weeklyreset)

  local icnt, dcnt = 0,0
  for name, _ in pairs(temp) do
    if vars.db.Instances[name][thisToon] then
      for diff,info in pairs(vars.db.Instances[name][thisToon]) do
        if not info.ID then
          vars.db.Instances[name][thisToon][diff] = nil
          dcnt = dcnt + 1
        end
      end
    else
      icnt = icnt + 1
    end
  end
  --debug("Refresh temp reaped "..icnt.." instances and "..dcnt.." diffs")
  wipe(temp)
  addon:UpdateToonData()
end

local function UpdateTooltip(self,elap)
  if not tooltip or not tooltip:IsShown() then return end
  if addon.firstupdate then
    -- ticket 155: fix QTip backdrop which somehow gets corrupted sometimes, no idea why
    tooltip:SetBackdrop(GameTooltip:GetBackdrop())
    tooltip:SetBackdropColor(GameTooltip:GetBackdropColor());
    tooltip:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())
    addon:SkinFrame(tooltip, "SavedInstancesTooltip")
    addon.firstupdate = false
  end
  addon.updatetooltip_throttle = (addon.updatetooltip_throttle or 10) + elap
  if addon.updatetooltip_throttle < 0.5 then return end
  addon.updatetooltip_throttle = 0
  if tooltip.anchorframe then
    core:ShowTooltip(tooltip.anchorframe)
  end
end

-- sorted traversal function for character table
local cpairs
do
  local cnext_list = {}
  local cnext_pos
  local cnext_ekey
  local function cnext(t,i)
    local e = cnext_list[cnext_pos]
    if not e then
      return nil
    else
      cnext_pos = cnext_pos + 1
      local n = e[cnext_ekey]
      return n, t[n]
    end
  end

  local function cpairs_sort(a,b)
    -- generic multi-key sort
    for k,av in ipairs(a) do
      local bv = b[k]
      if av ~= bv then
        return av < bv
      end
    end
    return false -- required for sort stability when a==a
  end

  cpairs = function(t, usecache)
    local settings = db.Tooltip
    local realmgroup_key
    local realmgroup_min
    if not usecache then
      local thisrealm = GetRealmName()
      if settings.ConnectedRealms ~= "ignore" then
        local group = core:getRealmGroup(thisrealm)
        thisrealm = group or thisrealm
      end
      wipe(cnext_list)
      cnext_pos = 1
      for n,_ in pairs(t) do
        local t = vars.db.Toons[n]
        local tn, tr = n:match('^(.*) [-] (.*)$')
        if t and
          (t.Show ~= "never" or (n == thisToon and settings.SelfAlways))  and
          (not settings.ServerOnly
          or thisrealm == tr
          or thisrealm == core:getRealmGroup(tr))
        then
          local e = {}
          cnext_ekey = 1

          if settings.SelfFirst then
            if n == thisToon then
              e[cnext_ekey] = 1
            else
              e[cnext_ekey] = 2
            end
            cnext_ekey = cnext_ekey + 1
          end

          if settings.ServerSort then
            if settings.ConnectedRealms == "ignore" then
              e[cnext_ekey] = tr
              cnext_ekey = cnext_ekey + 1
            else
              local rgroup = core:getRealmGroup(tr)
              if rgroup then -- connected realm
                realmgroup_min = realmgroup_min or {}
                if not realmgroup_min[rgroup] or tr < realmgroup_min[rgroup] then
                  realmgroup_min[rgroup] = tr -- lowest active realm in group
                end
              else
                rgroup = tr
              end
              realmgroup_key = cnext_ekey
              e[cnext_ekey] = rgroup
              cnext_ekey = cnext_ekey + 1

              if settings.ConnectedRealms == "group" then
                e[cnext_ekey] = tr
                cnext_ekey = cnext_ekey + 1
              end
            end
          end

          e[cnext_ekey] = t.Order
          cnext_ekey = cnext_ekey + 1

          e[cnext_ekey] = n
          cnext_list[cnext_pos] = e
          cnext_pos = cnext_pos + 1
        end
      end
      if realmgroup_key then -- second pass, convert group id to min name
        for _,e in ipairs(cnext_list) do
          local id = e[realmgroup_key]
          if type(id) == "number" then
            e[realmgroup_key] = realmgroup_min[id]
          end
      end
      end
      table.sort(cnext_list, cpairs_sort)
      --debug(cnext_list)
    end
    cnext_pos = 1
    return cnext, t, nil
  end
end

function addon:IsDetached()
  return addon.detachframe and addon.detachframe:IsShown()
end
function addon:HideDetached()
  addon.detachframe:Hide()
end
function addon:ToggleDetached()
  if addon:IsDetached() then
    addon:HideDetached()
  else
    addon:ShowDetached()
  end
end

function addon:ShowDetached()
  if not addon.detachframe then
    local f = CreateFrame("Frame","SavedInstancesDetachHeader",UIParent,"BasicFrameTemplate")
    f:SetMovable(true)
    f:SetFrameStrata("TOOLTIP")
    f:SetFrameLevel(100) -- prevent weird interlacings with other tooltips
    f:SetClampedToScreen(true)
    f:EnableMouse(true)
    f:SetUserPlaced(true)
    f:SetAlpha(0.5)
    if vars.db.Tooltip.posx and vars.db.Tooltip.posy then
      f:SetPoint("TOPLEFT",vars.db.Tooltip.posx,-vars.db.Tooltip.posy)
    else
      f:SetPoint("CENTER")
    end
    f:SetScript("OnMouseDown", function() f:StartMoving() end)
    f:SetScript("OnMouseUp", function() f:StopMovingOrSizing()
      vars.db.Tooltip.posx = f:GetLeft()
      vars.db.Tooltip.posy = UIParent:GetTop() - (f:GetTop()*f:GetScale())
    end)
    f:SetScript("OnHide", function() if tooltip then QTip:Release(tooltip); tooltip = nil end  end )
    f:SetScript("OnUpdate", function(self)
      if not tooltip then f:Hide(); return end
      local w,h = tooltip:GetSize()
      self:SetSize(w*tooltip:GetScale(),(h+20)*tooltip:GetScale())
    end)
    f:SetScript("OnKeyDown", function(self,key)
      if key == "ESCAPE" then
        f:SetPropagateKeyboardInput(false)
        f:Hide();
      end
    end)
    f:EnableKeyboard(true)
    addon.detachframe = f
  end
  local f = addon.detachframe
  f:Show()
  addon:SkinFrame(f,f:GetName())
  f:SetPropagateKeyboardInput(true)
  if tooltip then tooltip:Hide() end
  core:ShowTooltip(f)
end

-----------------------------------------------------------------------------------------------
-- tooltip event handlers

local function OpenLFD(self, instanceid, button)
  if LFDParentFrame and LFDParentFrame:IsVisible() and LFDQueueFrame.type ~= instanceid then
  -- changing entries
  else
    ToggleLFDParentFrame()
  end
  if LFDParentFrame and LFDParentFrame:IsVisible() and LFDQueueFrame_SetType then
    LFDQueueFrame_SetType(instanceid)
  end
end

local function OpenLFR(self, instanceid, button)
  if RaidFinderFrame and RaidFinderFrame:IsVisible() and RaidFinderQueueFrame.raid ~= instanceid then
  -- changing entries
  else
    PVEFrame_ToggleFrame("GroupFinderFrame", RaidFinderFrame)
  end
  if RaidFinderFrame and RaidFinderFrame:IsVisible() and RaidFinderQueueFrame_SetRaid then
    RaidFinderQueueFrame_SetRaid(instanceid)
  end
end

local function OpenLFS(self, instanceid, button)
  if ScenarioFinderFrame and ScenarioFinderFrame:IsVisible() and ScenarioQueueFrame.type ~= instanceid then
  -- changing entries
  else
    PVEFrame_ToggleFrame("GroupFinderFrame", ScenarioFinderFrame)
  end
  if ScenarioFinderFrame and ScenarioFinderFrame:IsVisible() and ScenarioQueueFrame_SetType then
    ScenarioQueueFrame_SetType(instanceid)
  end
end

local function OpenCurrency(self, _, button)
  ToggleCharacter("TokenFrame")
end

local function ChatLink(self, link, button)
  if not link then return end
  if ChatEdit_GetActiveWindow() then
    ChatEdit_InsertLink(link)
  else
    ChatFrame_OpenChat(link, DEFAULT_CHAT_FRAME)
  end
end

local function CloseTooltips()
  GameTooltip:Hide()
  if indicatortip then
    indicatortip:Hide()
  end
end

local function DoNothing() end

-----------------------------------------------------------------------------------------------

local function ShowAll()
  return (IsAltKeyDown() and true) or false
end

local columnCache = { [true] = {}, [false] = {} }
local function addColumns(columns, toon, tooltip)
  for c = 1, maxcol do
    columns[toon..c] = columns[toon..c] or tooltip:AddColumn("CENTER")
  end
  columnCache[ShowAll()][toon] = true
end
addon.scaleCache = {}

function core:HeaderFont()
  if not addon.headerfont then
    local temp = QTip:Acquire("SavedInstancesHeaderTooltip", 1, "LEFT")
    addon.headerfont = CreateFont("SavedInstancedTooltipHeaderFont")
    local hFont = temp:GetHeaderFont()
    local hFontPath, hFontSize,_ hFontPath, hFontSize, _ = hFont:GetFont()
    addon.headerfont:SetFont(hFontPath, hFontSize, "OUTLINE")
    QTip:Release(temp)
  end
  return addon.headerfont
end

function core:ShowTooltip(anchorframe)
  local showall = ShowAll()
  if tooltip and tooltip:IsShown() and
    core.showall == showall and
    core.scale == (addon.scaleCache[showall] or vars.db.Tooltip.Scale)
  then
    return -- skip update
  end
  local starttime = debugprofilestop()
  core.showall = showall
  local showexpired = showall or vars.db.Tooltip.ShowExpired
  if tooltip then QTip:Release(tooltip) end
  tooltip = QTip:Acquire("SavedInstancesTooltip", 1, "LEFT")
  tooltip:SetCellMarginH(0)
  tooltip.anchorframe = anchorframe
  tooltip:SetScript("OnUpdate", UpdateTooltip)
  addon.firstupdate = true
  tooltip:Clear()
  core.scale = addon.scaleCache[showall] or vars.db.Tooltip.Scale
  tooltip:SetScale(core.scale)
  tooltip:SetHeaderFont(core:HeaderFont())
  addon:HistoryUpdate()
  local headText
  if addon.histLiveCount and addon.histLiveCount > 0 then
    headText = string.format("%s%s (%d/%s)%s",GOLDFONT,addonName,addon.histLiveCount,(addon.histOldest or "?"),FONTEND)
  else
    headText = string.format("%s%s%s",GOLDFONT,addonName,FONTEND)
  end
  local headLine = tooltip:AddHeader(headText)
  tooltip:SetCellScript(headLine, 1, "OnEnter", ShowAccountSummary )
  tooltip:SetCellScript(headLine, 1, "OnLeave", CloseTooltips)
  addon:UpdateToonData()
  local columns = localarr("columns")
  for toon,_ in cpairs(columnCache[showall]) do
    addColumns(columns, toon, tooltip)
    columnCache[showall][toon] = false
  end
  -- allocating columns for characters
  for toon, t in cpairs(vars.db.Toons) do
    if vars.db.Toons[toon].Show == "always" or
      (toon == thisToon and vars.db.Tooltip.SelfAlways) then
      addColumns(columns, toon, tooltip)
    end
  end
  -- determining how many instances will be displayed per category
  local categoryshown = localarr("categoryshown") -- remember if each category will be shown
  local instancesaved = localarr("instancesaved") -- remember if each instance has been saved or not (boolean)
  local wbcons = vars.db.Tooltip.CombineWorldBosses
  local worldbosses = wbcons and localarr("worldbosses")
  local wbalways = false
  local lfrcons = vars.db.Tooltip.CombineLFR
  local lfrbox = lfrcons and localarr("lfrbox")
  local lfrmap = lfrcons and localarr("lfrmap")
  for _, category in ipairs(addon:OrderedCategories()) do
    for _, instance in ipairs(addon:OrderedInstances(category)) do
      local inst = vars.db.Instances[instance]
      if inst.Show == "always" then
        categoryshown[category] = true
      end
      if inst.Show ~= "never" then
        if wbcons and inst.WorldBoss and inst.Expansion <= GetExpansionLevel() then
          if vars.db.Tooltip.ReverseInstances then
            table.insert(worldbosses, instance)
          else
            table.insert(worldbosses, 1, instance)
          end
          wbalways = wbalways or (inst.Show == "always")
        end
        local lfrinfo = lfrcons and inst.LFDID and addon.LFRInstances[inst.LFDID]
        local lfrboxid
        if lfrinfo then
          lfrboxid = lfrinfo.parent
          lfrmap[inst.LFDID] = instance
          if inst.Show == "always" then
            lfrbox[lfrboxid] = true
          end
        end
        for toon, t in cpairs(vars.db.Toons, true) do
          for diff = 1, maxdiff do
            if inst[toon] and inst[toon][diff] then
              if (inst[toon][diff].Expires > 0) then
                if lfrinfo then
                  lfrbox[lfrboxid] = true
                  instancesaved[lfrboxid] = true
                elseif wbcons and inst.WorldBoss then
                  instancesaved[L["World Bosses"]] = true
                else
                  instancesaved[instance] = true
                end
                categoryshown[category] = true
              elseif showall then
                categoryshown[category] = true
              end
            end
          end
        end
      end
    end
  end
  local categories = 0
  -- determining how many categories have instances that will be shown
  if vars.db.Tooltip.ShowCategories then
    for category, _ in pairs(categoryshown) do
      categories = categories + 1
    end
  end
  -- allocating tooltip space for instances, categories, and space between categories
  local categoryrow = localarr("categoryrow") -- remember where each category heading goes
  local instancerow = localarr("instancerow") -- remember where each instance goes
  local blankrow = localarr("blankrow") -- track blank lines
  local firstcategory = true -- use this to skip spacing before the first category
  local function addsep()
    local line = tooltip:AddSeparator(6,0,0,0,0)
    blankrow[line] = true
    return line
  end
  for _, category in ipairs(addon:OrderedCategories()) do
    if categoryshown[category] then
      if not firstcategory and vars.db.Tooltip.CategorySpaces then
        addsep()
      end
      if (categories > 1 or vars.db.Tooltip.ShowSoloCategory) and categoryshown[category] then
        local line = tooltip:AddLine()
        categoryrow[category] = line
        blankrow[line] = true
      end
      for _, instance in ipairs(addon:OrderedInstances(category)) do
        local inst = vars.db.Instances[instance]
        if not (wbcons and inst.WorldBoss) and
          not (lfrcons and addon.LFRInstances[inst.LFDID]) then
          if inst.Show == "always" then
            instancerow[instance] = instancerow[instance] or tooltip:AddLine()
          end
          if inst.Show ~= "never" then
            for toon, t in cpairs(vars.db.Toons, true) do
              for diff = 1, maxdiff do
                if inst[toon] and inst[toon][diff] and (inst[toon][diff].Expires > 0 or showexpired) then
                  instancerow[instance] = instancerow[instance] or tooltip:AddLine()
                  addColumns(columns, toon, tooltip)
                end
              end
            end
          end
        end
        if lfrcons and inst.LFDID then
          -- check if this parent instance has corresponding lfrboxes, and create them
          if lfrbox[inst.LFDID] then
            lfrbox[L["LFR"]..": "..instance] = tooltip:AddLine()
          end
          lfrbox[inst.LFDID] = nil
        end
      end
      firstcategory = false
    end
  end
  -- now printing instance data
  for instance, row in pairs(instancerow) do
    local inst = vars.db.Instances[instance]
    tooltip:SetCell(row, 1, (instancesaved[instance] and GOLDFONT or GRAYFONT) .. instance .. FONTEND)
    if addon.LFRInstances[inst.LFDID] then
      tooltip:SetLineScript(row, "OnMouseDown", OpenLFR, inst.LFDID)
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      if inst[toon] then
        local showcol = localarr("showcol")
        local showcnt = 0
        for diff = 1, maxdiff do
          if inst[toon][diff] and (inst[toon][diff].Expires > 0 or showexpired) then
            showcnt = showcnt + 1
            showcol[diff] = true
          end
        end
        local base = 1
        local span = maxcol
        if showcnt > 1 then
          span = 1
        end
        if showcnt > maxcol then
          bugReport("Column overflow! showcnt="..showcnt)
        end
        for diff = 1, maxdiff do
          if showcol[diff] then
            local col = columns[toon..base]
            tooltip:SetCell(row, col,
              DifficultyString(instance, diff, toon, inst[toon][diff].Expires == 0), span)
            tooltip:SetCellScript(row, col, "OnEnter", ShowIndicatorTooltip, {instance, toon, diff})
            tooltip:SetCellScript(row, col, "OnLeave", CloseTooltips)
            if addon.LFRInstances[inst.LFDID] then
              tooltip:SetCellScript(row, col, "OnMouseDown", OpenLFR, inst.LFDID)
            else
              local link = inst[toon][diff].Link
              if link then
                tooltip:SetCellScript(row, col, "OnMouseDown", ChatLink, link)
              end
            end
            base = base + 1
          elseif columns[toon..diff] and showcnt > 1 then
            tooltip:SetCell(row, columns[toon..diff], "")
          end
        end
      end
    end
  end

  -- combined LFRs
  if lfrcons then
    for boxname, line in pairs(lfrbox) do
      if type(boxname) == "number" then
        bugReport("Unrecognized LFR instance parent id= "..boxname)
        lfrbox[boxname] = nil
      end
    end
    for boxname, line in pairs(lfrbox) do
      local boxtype, pinstance = boxname:match("^([^:]+): (.+)$")
      local pinst = vars.db.Instances[pinstance]
      local boxid = pinst.LFDID
      local firstid
      local total = 0
      for lfdid, lfrinfo in pairs(addon.LFRInstances) do
        if lfrinfo.parent == pinst.LFDID and lfrmap[lfdid] then
          firstid = math.min(lfdid, firstid or lfdid)
          total = total + lfrinfo.total
          lfrmap[boxname..":"..lfrinfo.base] = lfrmap[lfdid]
        end
      end
      tooltip:SetCell(line, 1, (instancesaved[boxid] and GOLDFONT or GRAYFONT) .. boxname .. FONTEND)
      tooltip:SetLineScript(line, "OnMouseDown", OpenLFR, firstid)
      for toon, t in cpairs(vars.db.Toons, true) do
        local saved = 0
        local diff = 2
        for key, instance in pairs(lfrmap) do
          if string.match(key,boxname..":%d+$") then
            saved = saved + addon:instanceBosses(instance, toon, diff)
          end
        end
        if saved > 0 then
          addColumns(columns, toon, tooltip)
          local col = columns[toon..1]
          tooltip:SetCell(line, col, DifficultyString(pinstance, diff, toon, false, saved, total),4)
          tooltip:SetCellScript(line, col, "OnEnter", ShowLFRTooltip, {boxname, toon, lfrmap})
          tooltip:SetCellScript(line, col, "OnLeave", CloseTooltips)
        end
      end
    end
  end

  -- combined world bosses
  if wbcons and next(worldbosses) and (wbalways or instancesaved[L["World Bosses"]]) then
    if not firstcategory and vars.db.Tooltip.CategorySpaces then
      addsep()
    end
    local line = tooltip:AddLine((instancesaved[L["World Bosses"]] and YELLOWFONT or GRAYFONT) .. L["World Bosses"] .. FONTEND)
    for toon, t in cpairs(vars.db.Toons, true) do
      local saved = 0
      local diff = 2
      for _, instance in ipairs(worldbosses) do
        local inst = vars.db.Instances[instance]
        if inst[toon] and inst[toon][diff] and inst[toon][diff].Expires > 0 then
          saved = saved + 1
        end
      end
      if saved > 0 then
        addColumns(columns, toon, tooltip)
        local col = columns[toon..1]
        tooltip:SetCell(line, col, DifficultyString(worldbosses[1], diff, toon, false, saved, #worldbosses),4)
        tooltip:SetCellScript(line, col, "OnEnter", ShowWorldBossTooltip, {worldbosses, toon, saved})
        tooltip:SetCellScript(line, col, "OnLeave", CloseTooltips)
      end
    end
  end

  local holidayinst = localarr("holidayinst")
  local firstlfd = true
  for instance, info in pairs(vars.db.Instances) do
    if showall or
      (info.Holiday and vars.db.Tooltip.ShowHoliday) or
      (info.Random and vars.db.Tooltip.ShowRandom) then
      for toon, t in cpairs(vars.db.Toons, true) do
        local d = info[toon] and info[toon][1]
        if d then
          addColumns(columns, toon, tooltip)
          local row = holidayinst[instance]
          if not row then
            if not firstcategory and vars.db.Tooltip.CategorySpaces and firstlfd then
              addsep()
              firstlfd = false
            end
            row = tooltip:AddLine(YELLOWFONT .. abbreviate(instance) .. FONTEND)
            holidayinst[instance] = row
          end
          local tstr = SecondsToTime(d.Expires - time(), false, false, 1)
          tooltip:SetCell(row, columns[toon..1], ClassColorise(t.Class,tstr), "CENTER",maxcol)
          if info.Scenario then
            tooltip:SetLineScript(row, "OnMouseDown", OpenLFS, info.LFDID)
          else
            tooltip:SetLineScript(row, "OnMouseDown", OpenLFD, info.LFDID)
          end
        end
      end
    end
  end

  -- random dungeon
  if vars.db.Tooltip.TrackLFG or showall then
    local cd1,cd2 = false,false
    for toon, t in cpairs(vars.db.Toons, true) do
      cd2 = cd2 or t.LFG2
      cd1 = cd1 or (t.LFG1 and (not t.LFG2 or showall))
      if t.LFG1 or t.LFG2 then
        addColumns(columns, toon, tooltip)
      end
    end
    local randomLine
    if cd1 or cd2 then
      if not firstcategory and vars.db.Tooltip.CategorySpaces and firstlfd then
        addsep()
        firstlfd = false
      end
      local cooldown = ITEM_COOLDOWN_TOTAL:gsub("%%s",""):gsub("%p","")
      cd1 = cd1 and tooltip:AddLine(YELLOWFONT .. LFG_TYPE_RANDOM_DUNGEON..cooldown .. FONTEND)
      cd2 = cd2 and tooltip:AddLine(YELLOWFONT .. GetSpellInfo(71041) .. FONTEND)
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      local d1 = (t.LFG1 and t.LFG1 - time()) or -1
      local d2 = (t.LFG2 and t.LFG2 - time()) or -1
      if d1 > 0 and (d2 < 0 or showall) then
        local col = columns[toon..1]
        local tstr = SecondsToTime(d1, false, false, 1)
        tooltip:SetCell(cd1, col, ClassColorise(t.Class,tstr), "CENTER",maxcol)
        tooltip:SetCellScript(cd1, col, "OnEnter", ShowSpellIDTooltip, {toon,-1,tstr})
        tooltip:SetCellScript(cd1, col, "OnLeave", CloseTooltips)
      end
      if d2 > 0 then
        local col = columns[toon..1]
        local tstr = SecondsToTime(d2, false, false, 1)
        tooltip:SetCell(cd2, col, ClassColorise(t.Class,tstr), "CENTER",maxcol)
        tooltip:SetCellScript(cd2, col, "OnEnter", ShowSpellIDTooltip, {toon,71041,tstr})
        tooltip:SetCellScript(cd2, col, "OnLeave", CloseTooltips)
      end
    end
  end
  if vars.db.Tooltip.TrackDeserter or showall then
    local show = false
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.pvpdesert then
        show = true
        addColumns(columns, toon, tooltip)
      end
    end
    if show then
      if not firstcategory and vars.db.Tooltip.CategorySpaces and firstlfd then
        addsep()
        firstlfd = false
      end
      show = tooltip:AddLine(YELLOWFONT .. DESERTER .. FONTEND)
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.pvpdesert and time() < t.pvpdesert then
        local col = columns[toon..1]
        local tstr = SecondsToTime(t.pvpdesert - time(), false, false, 1)
        tooltip:SetCell(show, col, ClassColorise(t.Class,tstr), "CENTER",maxcol)
        tooltip:SetCellScript(show, col, "OnEnter", ShowSpellIDTooltip, {toon,26013,tstr})
        tooltip:SetCellScript(show, col, "OnLeave", CloseTooltips)
      end
    end
  end

  do
    local showd, showw
    for toon, t in cpairs(vars.db.Toons, true) do
      local dc, wc = addon:QuestCount(toon)
      if dc > 0 and (vars.db.Tooltip.TrackDailyQuests or showall) then
        showd = true
        addColumns(columns, toon, tooltip)
      end
      if wc > 0 and (vars.db.Tooltip.TrackWeeklyQuests or showall) then
        showw = true
        addColumns(columns, toon, tooltip)
      end
    end
    local adc, awc = addon:QuestCount(nil)
    if adc > 0 and (vars.db.Tooltip.TrackDailyQuests or showall) then showd = true end
    if awc > 0 and (vars.db.Tooltip.TrackWeeklyQuests or showall) then showw = true end
    if not firstcategory and vars.db.Tooltip.CategorySpaces and (showd or showw) then
      addsep()
    end
    if showd then
      showd = tooltip:AddLine(YELLOWFONT .. L["Daily Quests"] .. (adc > 0 and " ("..adc..")" or "") .. FONTEND)
      if adc > 0 then
        tooltip:SetCellScript(showd, 1, "OnEnter", ShowQuestTooltip, {nil,adc,true})
        tooltip:SetCellScript(showd, 1, "OnLeave", CloseTooltips)
      end
    end
    if showw then
      showw = tooltip:AddLine(YELLOWFONT .. L["Weekly Quests"] .. (awc > 0 and " ("..awc..")" or "") .. FONTEND)
      if awc > 0 then
        tooltip:SetCellScript(showw, 1, "OnEnter", ShowQuestTooltip, {nil,awc,false})
        tooltip:SetCellScript(showw, 1, "OnLeave", CloseTooltips)
      end
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      local dc, wc = addon:QuestCount(toon)
      local col = columns[toon..1]
      if showd and col and dc > 0 then
        tooltip:SetCell(showd, col, ClassColorise(t.Class,dc), "CENTER",maxcol)
        tooltip:SetCellScript(showd, col, "OnEnter", ShowQuestTooltip, {toon,dc,true})
        tooltip:SetCellScript(showd, col, "OnLeave", CloseTooltips)
      end
      if showw and col and wc > 0 then
        tooltip:SetCell(showw, col, ClassColorise(t.Class,wc), "CENTER",maxcol)
        tooltip:SetCellScript(showw, col, "OnEnter", ShowQuestTooltip, {toon,wc,false})
        tooltip:SetCellScript(showw, col, "OnLeave", CloseTooltips)
      end
    end
  end

  if vars.db.Tooltip.TrackSkills or showall then
    local show = false
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.Skills and next(t.Skills) then
        show = true
        addColumns(columns, toon, tooltip)
      end
    end
    if show then
      if not firstcategory and vars.db.Tooltip.CategorySpaces then
        addsep()
      end
      show = tooltip:AddLine(YELLOWFONT .. L["Trade Skill Cooldowns"] .. FONTEND)
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      local cnt = 0
      if t.Skills then
        for _ in pairs(t.Skills) do cnt = cnt + 1 end
      end
      if cnt > 0 then
        local col = columns[toon..1]
        tooltip:SetCell(show, col, ClassColorise(t.Class,cnt), "CENTER",maxcol)
        tooltip:SetCellScript(show, col, "OnEnter", ShowSkillTooltip, {toon, cnt})
        tooltip:SetCellScript(show, col, "OnLeave", CloseTooltips)
      end
    end
  end

  if vars.db.Tooltip.MythicKey or showall then
    local show = false
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.MythicKey then
        if t.MythicKey.link then
          show = true
          addColumns(columns, toon, tooltip)
        end
      end
    end
    if show then
      if not firstcategory and vars.db.Tooltip.CategorySpaces then
        addsep()
      end
      show = tooltip:AddLine(YELLOWFONT .. L["Mythic Keystone"] .. FONTEND)
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.MythicKey then
        if t.MythicKey.link then
          local col = columns[toon..1]
          if vars.db.Tooltip.AbbreviateKeystone then
            if t.MythicKey.abbrev then
              tooltip:SetCell(show, col, "|c"..t.MythicKey.color..t.MythicKey.abbrev.." ("..t.MythicKey.level..")"..FONTEND, "CENTER",maxcol)
            else
              local kabbrev = KeystonetoAbbrev[t.MythicKey.link] or t.MythicKey.link
              tooltip:SetCell(show, col, "|c"..t.MythicKey.color..kabbrev.." ("..t.MythicKey.level..")"..FONTEND, "CENTER",maxcol)
            end
          else
          tooltip:SetCell(show, col, "|c"..t.MythicKey.color..t.MythicKey.link.." ("..t.MythicKey.level..")"..FONTEND, "CENTER",maxcol)
          end
          tooltip:SetCellScript(show, col, "OnMouseDown", ChatLink, t.MythicKey.link)
        end
      end
    end
  end

  if vars.db.Tooltip.MythicKeyBest or showall then
    local show = false
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.MythicKeyBest then
        if t.MythicKeyBest.level and t.MythicKeyBest.level > 0 then
          show = true
          addColumns(columns, toon, tooltip)
        end
        if t.MythicKeyBest.WeeklyReward then
          show = true
          addColumns(columns, toon, tooltip)
        end
      end
    end
    if show then
      if not firstcategory and vars.db.Tooltip.CategorySpaces then
        addsep()
      end
      show = tooltip:AddLine(YELLOWFONT .. L["Mythic Key Best"] .. FONTEND)
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.MythicKeyBest then
        local keydesc = ""
        if t.MythicKeyBest.level and t.MythicKeyBest.level > 0 then
          keydesc = t.MythicKeyBest.level
        end
        if t.MythicKeyBest.WeeklyReward then
          if keydesc == "" then
            keydesc = "0"
          end
          local lastlevel = ""
          if t.MythicKeyBest.LastWeekLevel and t.MythicKeyBest.LastWeekLevel > 0 then
            lastlevel = t.MythicKeyBest.LastWeekLevel
          end
          keydesc = keydesc .."(".. lastlevel ..L[" Chest Available"].. ")"
        end
        if keydesc ~= "" then
          local col = columns[toon..1]
          tooltip:SetCell(show, col, keydesc , "CENTER",maxcol)
        end
      end
    end
  end

  if vars.db.Tooltip.DailyWorldQuest or showall then
    local show = {}
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.DailyWorldQuest then
        for day,DailyInfo in pairs(t.DailyWorldQuest) do
          if DailyInfo.name then
            if(not show[DailyInfo.dayleft] or show[DailyInfo.dayleft] == L["Emissary Missing"]) then
              show[DailyInfo.dayleft] = DailyInfo.name
            end
            addColumns(columns, toon, tooltip)
          end
        end
      end
    end

	if not firstcategory and vars.db.Tooltip.CategorySpaces then
          addsep()
	end
	if vars.db.Tooltip.ShowCategories then
		tooltip:AddLine(YELLOWFONT .. L["Emissary Quests"] .. FONTEND)
	end
    for dayleft = 0 , 2 do
      if show[dayleft] then
        local showday = show[dayleft]
			show[dayleft] = tooltip:AddLine(GOLDFONT .. showday .. " (+" .. dayleft .. " " .. L["Day"] .. ")" .. FONTEND)
      end
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.DailyWorldQuest then
        for day,DailyInfo in pairs(t.DailyWorldQuest) do
          if show[DailyInfo.dayleft] then
            local col = columns[toon..1]
            if DailyInfo.iscompleted == true then
              tooltip:SetCell(show[DailyInfo.dayleft], col, "\124T"..READY_CHECK_READY_TEXTURE..":0|t", "CENTER", maxcol)
            elseif DailyInfo.isfinish == true then
              tooltip:SetCell(show[DailyInfo.dayleft], col, "\124T"..READY_CHECK_WAITING_TEXTURE..":0|t", "CENTER", maxcol)
            else
              tooltip:SetCell(show[DailyInfo.dayleft], col, DailyInfo.questdone .. "/" .. DailyInfo.questneed , "CENTER",maxcol)
            end
          end
        end
      end
    end
  end

  if vars.db.Tooltip.TrackFarm or showall then
    local toonfarm = localarr("toonfarm")
    local show
    for toon, t in cpairs(vars.db.Toons, true) do
      if (t.FarmPlanted or 0) > 0 or (t.FarmHarvested or 0) > 0 or
        (t.FarmCropReady and next(t.FarmCropReady)) then
        toonfarm[toon] = (t.FarmHarvested or 0).."/"..(t.FarmPlanted or 0)
        show = true
        addColumns(columns, toon, tooltip)
      end
    end
    if show then
      if not firstcategory and vars.db.Tooltip.CategorySpaces then
        addsep()
      end
      show = tooltip:AddLine(YELLOWFONT .. L["Farm Crops"] .. FONTEND)
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      if toonfarm[toon] then
        local col = columns[toon..1]
        tooltip:SetCell(show, col, ClassColorise(t.Class,toonfarm[toon]), "CENTER",maxcol)
        tooltip:SetCellScript(show, col, "OnEnter", ShowFarmTooltip, toon)
        tooltip:SetCellScript(show, col, "OnLeave", CloseTooltips)
      end
    end
  end

  if vars.db.Tooltip.TrackBonus or showall then
    local show
    local toonbonus = localarr("toonbonus")
    for toon, t in cpairs(vars.db.Toons, true) do
      if t.BonusRoll and t.BonusRoll[1] then
        local gold = 0
        for _,roll in ipairs(t.BonusRoll) do
          if roll.money then
            gold = gold + 1
          else
            break
          end
        end
        toonbonus[toon] = gold
        show = true
        addColumns(columns, toon, tooltip)
      end
    end
    if show then
      if not firstcategory and vars.db.Tooltip.CategorySpaces then
        addsep()
      end
      show = tooltip:AddLine(YELLOWFONT .. L["Roll Bonus"] .. FONTEND)
    end
    for toon, t in cpairs(vars.db.Toons, true) do
      if toonbonus[toon] then
        local col = columns[toon..1]
        local str = toonbonus[toon]
        if str > 0 then str = "+"..str end
        tooltip:SetCell(show, col, ClassColorise(t.Class,str), "CENTER",maxcol)
        tooltip:SetCellScript(show, col, "OnEnter", ShowBonusTooltip, toon)
        tooltip:SetCellScript(show, col, "OnLeave", CloseTooltips)
      end
    end
  end

  local firstcurrency = true
  for _,idx in ipairs(currency) do
    local setting = vars.db.Tooltip["Currency"..idx]
    if setting or showall then
      local show
      for toon, t in cpairs(vars.db.Toons, true) do
        -- ci.name, ci.amount, ci.earnedThisWeek, ci.weeklyMax, ci.totalMax
        local ci = t.currency and t.currency[idx]
        local gotsome
        if ci then
          gotsome = ((ci.earnedThisWeek or 0) > 0 and (ci.weeklyMax or 0) > 0) or
            ((ci.amount or 0) > 0 and showall)
          -- or ((ci.amount or 0) > 0 and ci.weeklyMax == 0 and t.Level == maxlvl)
        end
        if ci and gotsome then
          addColumns(columns, toon, tooltip)
        end
        if ci and (gotsome or (ci.amount or 0) > 0) and columns[toon..1] then
          local name,_,tex = GetCurrencyInfo(idx)
          show = string.format(" \124T%s:0\124t%s",tex,name)
        end
      end
      local currLine
      if show then
        if not firstcategory and vars.db.Tooltip.CategorySpaces and firstcurrency then
          addsep()
          firstcurrency = false
        end
        currLine = tooltip:AddLine(YELLOWFONT .. show .. FONTEND)
        tooltip:SetLineScript(currLine, "OnMouseDown", OpenCurrency)
        tooltip:SetCellScript(currLine, 1, "OnEnter", ShowCurrencySummary, idx)
        tooltip:SetCellScript(currLine, 1, "OnLeave", CloseTooltips)
        tooltip:SetCellScript(currLine, 1, "OnMouseDown", OpenCurrency)

        for toon, t in cpairs(vars.db.Toons, true) do
          local ci = t.currency and t.currency[idx]
          local col = columns[toon..1]
          if ci and col then
            local earned, weeklymax, totalmax = "","",""
            if vars.db.Tooltip.CurrencyMax then
              if (ci.weeklyMax or 0) > 0 then
                weeklymax = "/"..addon:formatNumber(ci.weeklyMax)
              end
              if (ci.totalMax or 0) > 0 then
                totalmax = "/"..addon:formatNumber(ci.totalMax)
              end
            end
            if vars.db.Tooltip.CurrencyEarned or showall then
              earned = CurrencyColor(ci.amount,ci.totalMax)..totalmax
            end
            local str
            if (ci.amount or 0) > 0 or (ci.earnedThisWeek or 0) > 0 then
              if (ci.weeklyMax or 0) > 0 then
                str = earned.." ("..CurrencyColor(ci.earnedThisWeek,ci.weeklyMax)..weeklymax..")"
              elseif (ci.amount or 0) > 0 then
                str = CurrencyColor(ci.amount,ci.totalMax)..totalmax
              end
            end
            if str then
              if not vars.db.Tooltip.CurrencyValueColor then
                str = ClassColorise(t.Class,str)
              end
              tooltip:SetCell(currLine, col, str, "CENTER",maxcol)
              tooltip:SetCellScript(currLine, col, "OnEnter", ShowCurrencyTooltip, {toon, idx, ci})
              tooltip:SetCellScript(currLine, col, "OnLeave", CloseTooltips)
              tooltip:SetCellScript(currLine, col, "OnMouseDown", OpenCurrency)
            end
          end
        end
      end
    end
  end

  -- toon names
  for toondiff, col in pairs(columns) do
    local toon = strsub(toondiff, 1, #toondiff-1)
    local diff = strsub(toondiff, #toondiff, #toondiff)
    if diff == "1" then
      local toonname, toonserver = toon:match('^(.*) [-] (.*)$')
      local toonstr = toonname
      if db.Tooltip.ShowServer then
        toonstr = toonstr .. "\n" .. toonserver
      end
      tooltip:SetCell(headLine, col, ClassColorise(vars.db.Toons[toon].Class, toonstr),
        tooltip:GetHeaderFont(), "CENTER", maxcol)
      tooltip:SetCellScript(headLine, col, "OnEnter", ShowToonTooltip, toon)
      tooltip:SetCellScript(headLine, col, "OnLeave", CloseTooltips)
    end
  end
  -- we now know enough to put in the category names where necessary
  if vars.db.Tooltip.ShowCategories then
    for category, row in pairs(categoryrow) do
      if (categories > 1 or vars.db.Tooltip.ShowSoloCategory) and categoryshown[category] then
        tooltip:SetCell(row, 1, YELLOWFONT .. vars.Categories[category] .. FONTEND, "LEFT", tooltip:GetColumnCount())
      end
    end
  end

  local hi = true
  for i=2,tooltip:GetLineCount() do -- row highlighting
    tooltip:SetLineScript(i, "OnEnter", DoNothing)
    tooltip:SetLineScript(i, "OnLeave", DoNothing)

    if hi and not blankrow[i] then
      tooltip:SetLineColor(i, 1,1,1, db.Tooltip.RowHighlight)
      hi = false
    else
      tooltip:SetLineColor(i, 0,0,0, 0)
      hi = true
    end
  end

  -- finishing up, with hints
  if TableLen(instancerow) == 0 then
    local noneLine = tooltip:AddLine()
    tooltip:SetCell(noneLine, 1, GRAYFONT .. NO_RAID_INSTANCES_SAVED .. FONTEND, "LEFT", tooltip:GetColumnCount())
  end
  if vars.db.Tooltip.ShowHints then
    tooltip:AddSeparator(8,0,0,0,0)
    local hintLine, hintCol
    if not addon:IsDetached() then
      hintLine, hintCol = tooltip:AddLine()
      tooltip:SetCell(hintLine, hintCol, L["|cffffff00Left-click|r to detach tooltip"], "LEFT", tooltip:GetColumnCount())
      hintLine, hintCol = tooltip:AddLine()
      tooltip:SetCell(hintLine, hintCol, L["|cffffff00Middle-click|r to show Blizzard's Raid Information"], "LEFT", tooltip:GetColumnCount())
      hintLine, hintCol = tooltip:AddLine()
      tooltip:SetCell(hintLine, hintCol, L["|cffffff00Right-click|r to configure SavedInstances"], "LEFT", tooltip:GetColumnCount())
    end
    hintLine, hintCol = tooltip:AddLine()
    tooltip:SetCell(hintLine, hintCol, L["Hover mouse on indicator for details"], "LEFT", tooltip:GetColumnCount())
    if not showall then
      hintLine, hintCol = tooltip:AddLine()
      tooltip:SetCell(hintLine, hintCol, L["Hold Alt to show all data"], "LEFT", math.max(1,tooltip:GetColumnCount()-maxcol))
      if tooltip:GetColumnCount() < maxcol+1 then
        tooltip:AddLine(addonName.." version "..addon.version)
      else
        tooltip:SetCell(hintLine, tooltip:GetColumnCount()-maxcol+1, addon.version, "RIGHT", maxcol)
      end
    end
  end

  -- cache check
  local fail = false
  local maxidx = 0
  for toon,val in cpairs(columnCache[showall]) do
    if not val then -- remove stale column
      columnCache[showall][toon] = nil
      fail = true
    else
      local thisidx = columns[toon..1]
      if thisidx < maxidx then -- sort failure caused by new middle-insertion
        fail = true
      end
      maxidx = thisidx
    end
  end
  if fail then -- retry with corrected cache
    debug("Tooltip cache miss")
    addon.scaleCache[showall] = nil
    --core:ShowTooltip(anchorframe)
    -- reschedule continuation to reduce time-slice exceeded errors in combat
    core:ScheduleTimer("ShowTooltip", 0, anchorframe)
  else -- render it
    addon:SkinFrame(tooltip,"SavedInstancesTooltip")
    if addon:IsDetached() then
      tooltip:Show()
      QTip.layoutCleaner:CleanupLayouts()
      tooltip:ClearAllPoints()
      tooltip:SetPoint("BOTTOMLEFT",addon.detachframe)
      tooltip:SetFrameLevel(addon.detachframe:GetFrameLevel()+1)
    else
      tooltip:SmartAnchorTo(anchorframe)
      tooltip:SetAutoHideDelay(0.1, anchorframe)
      tooltip:Show()
    end
    tooltip.OnRelease = function() -- extra-safety: update our variable on auto-release
      tooltip:ClearAllPoints()
      tooltip = nil
    end
    if db.Tooltip.FitToScreen then
      -- scale check
      QTip.layoutCleaner:CleanupLayouts()
      local scale = tooltip:GetScale()
      local w,h = tooltip:GetSize()
      local sw,sh = UIParent:GetSize()
      w = w*scale;
      h = h*scale;
      if w > sw or h > sh then
        scale = scale / math.max(w/sw, h/sh)
        scale = scale*0.95 -- 5% slop to speed convergeance
        debug("Downscaling to %.4f",scale)
        tooltip:SetScale(scale)
        tooltip:Hide()
        addon.scaleCache[showall] = scale
        core:ScheduleTimer("ShowTooltip", 0, anchorframe) -- re-render fonts
      end
    end
  end
  starttime = debugprofilestop()-starttime
  debug("ShowTooltip(): completed in %.3fms", starttime)
end

local function ResetConfirmed()
  debug("Resetting characters")
  if addon:IsDetached() then
    addon:HideDetached()
  end
  -- clear saves
  for instance, i in pairs(vars.db.Instances) do
    for toon, t in pairs(vars.db.Toons) do
      i[toon] = nil
    end
  end
  wipe(vars.db.Toons) -- clear toon db
  addon.PlayedTime = nil -- reset played cache
  core:toonInit() -- rebuild thisToon
  core:Refresh()
  vars.config:BuildOptions() -- refresh config table
  vars.config:ReopenConfigDisplay(vars.config.ftoon)
end


StaticPopupDialogs["SAVEDINSTANCES_RESET"] = {
  preferredIndex = 3, -- reduce the chance of UI taint
  text = L["Are you sure you want to reset the SavedInstances character database? Characters will be re-populated as you log into them."],
  button1 = OKAY,
  button2 = CANCEL,
  OnAccept = ResetConfirmed,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  enterClicksFirstButton = false,
  showAlert = true,
}

local function DeleteCharacter(toon)
  if toon == thisToon or not vars.db.Toons[toon] then
    chatMsg("ERROR: Failed to delete "..toon..". Character is active or does not exist.")
    return
  end
  debug("Deleting character: "..toon)
  if addon:IsDetached() then
    addon:HideDetached()
  end
  -- clear saves
  for instance, i in pairs(vars.db.Instances) do
    i[toon] = nil
  end
  vars.db.Toons[toon] = nil
  vars.config:BuildOptions() -- refresh config table
  vars.config:ReopenConfigDisplay(vars.config.ftoon)
end

StaticPopupDialogs["SAVEDINSTANCES_DELETE_CHARACTER"] = {
  preferredIndex = 3, -- reduce the chance of UI taint
  text = string.format(L["Are you sure you want to remove %s from the SavedInstances character database?"],"\n\n%s%s\n\n").."\n\n"..
  L["This should only be used for characters who have been renamed or deleted, as characters will be re-populated when you log into them."],
  button1 = OKAY,
  button2 = CANCEL,
  OnAccept = function(self,data) DeleteCharacter(data) end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  enterClicksFirstButton = false,
  showAlert = true,
}

local trade_spells = {
  -- Alchemy
  -- Vanilla
  [11479] = "xmute", 	-- Transmute: Iron to Gold
  [11480] = "xmute", 	-- Transmute: Mithril to Truesilver
  [17559] = "xmute", 	-- Transmute: Air to Fire
  [17566] = "xmute", 	-- Transmute: Earth to Life
  [17561] = "xmute", 	-- Transmute: Earth to Water
  [17560] = "xmute", 	-- Transmute: Fire to Earth
  [17565] = "xmute", 	-- Transmute: Life to Earth
  [17563] = "xmute", 	-- Transmute: Undeath to Water
  [17562] = "xmute", 	-- Transmute: Water to Air
  [17564] = "xmute", 	-- Transmute: Water to Undeath
  -- BC
  [28566] = "xmute", 	-- Transmute: Primal Air to Fire
  [28585] = "xmute", 	-- Transmute: Primal Earth to Life
  [28567] = "xmute", 	-- Transmute: Primal Earth to Water
  [28568] = "xmute", 	-- Transmute: Primal Fire to Earth
  [28583] = "xmute", 	-- Transmute: Primal Fire to Mana
  [28584] = "xmute", 	-- Transmute: Primal Life to Earth
  [28582] = "xmute", 	-- Transmute: Primal Mana to Fire
  [28580] = "xmute", 	-- Transmute: Primal Shadow to Water
  [28569] = "xmute", 	-- Transmute: Primal Water to Air
  [28581] = "xmute", 	-- Transmute: Primal Water to Shadow
  -- WotLK
  [60893] = 3, 		-- Northrend Alchemy Research: 3 days
  [53777] = "xmute", 	-- Transmute: Eternal Air to Earth
  [53776] = "xmute", 	-- Transmute: Eternal Air to Water
  [53781] = "xmute", 	-- Transmute: Eternal Earth to Air
  [53782] = "xmute", 	-- Transmute: Eternal Earth to Shadow
  [53775] = "xmute", 	-- Transmute: Eternal Fire to Life
  [53774] = "xmute", 	-- Transmute: Eternal Fire to Water
  [53773] = "xmute", 	-- Transmute: Eternal Life to Fire
  [53771] = "xmute", 	-- Transmute: Eternal Life to Shadow
  [54020] = "xmute", 	-- Transmute: Eternal Might
  [53779] = "xmute", 	-- Transmute: Eternal Shadow to Earth
  [53780] = "xmute", 	-- Transmute: Eternal Shadow to Life
  [53783] = "xmute", 	-- Transmute: Eternal Water to Air
  [53784] = "xmute", 	-- Transmute: Eternal Water to Fire
  [66658] = "xmute", 	-- Transmute: Ametrine
  [66659] = "xmute", 	-- Transmute: Cardinal Ruby
  [66660] = "xmute", 	-- Transmute: King's Amber
  [66662] = "xmute", 	-- Transmute: Dreadstone
  [66663] = "xmute", 	-- Transmute: Majestic Zircon
  [66664] = "xmute", 	-- Transmute: Eye of Zul
  -- Cata
  [78866] = "xmute", 	-- Transmute: Living Elements
  [80244] = "xmute", 	-- Transmute: Pyrium Bar
  -- MoP
  [114780] = "xmute", 	-- Transmute: Living Steel
  -- WoD
  [175880] = true,	-- Secrets of Draenor
  [156587] = true,	-- Alchemical Catalyst (4)
  [168042] = true,	-- Alchemical Catalyst (10), 3 charges w/ 24hr recharge
  [181643] = "xmute",	-- Transmute: Savage Blood
  -- Legion
  [188800] = "wildxmute", -- Transmute: Wild Transmutation (Rank 1)
  [188801] = "wildxmute", -- Transmute: Wild Transmutation (Rank 2)
  [188802] = "wildxmute", -- Transmute: Wild Transmutation (Rank 3)
  [213248] = "legionxmute", -- Transmute: Ore to Cloth
  [213249] = "legionxmute", -- Transmute: Cloth to Skins
  [213250] = "legionxmute", -- Transmute: Skins to Ore
  [213251] = "legionxmute", -- Transmute: Ore to Herbs
  [213252] = "legionxmute", -- Transmute: Cloth to Herbs
  [213253] = "legionxmute", -- Transmute: Skins to Herbs
  [213254] = "legionxmute", -- Transmute: Fish to Gems
  [213255] = "legionxmute", -- Transmute: Meat to Pants
  [213256] = "legionxmute", -- Transmute: Meat to Pet
  [213257] = "legionxmute", -- Transmute: Blood of Sargeras
  [247701] = "legionxmute", -- Transmute: Primal Sargerite
  -- BfA
  [251832] = "legionxmute", -- Transmute: Expulsom
  [251314] = "legionxmute", -- Transmute: Cloth to Skins
  [251822] = "legionxmute", -- Transmute: Fish to Gems
  [251306] = "legionxmute", -- Transmute: Herbs to Cloth
  [251305] = "legionxmute", -- Transmute: Herbs to Ore
  [251808] = "legionxmute", -- Transmute: Meat to Pet
  [251310] = "legionxmute", -- Transmute: Ore to Cloth
  [251311] = "legionxmute", -- Transmute: Ore to Gems
  [251309] = "legionxmute", -- Transmute: Ore to Herbs

  -- Enchanting
  [28027] = "sphere", 	-- Prismatic Sphere (2-day shared, 5.2.0 verified)
  [28028] = "sphere", 	-- Void Sphere (2-day shared, 5.2.0 verified)
  [116499] = true, 	-- Sha Crystal
  [177043] = true,	-- Secrets of Draenor
  [169092] = true,	-- Temporal Crystal

  -- Jewelcrafting
  [47280] = true, 	-- Brilliant Glass, still has a cd (5.2.0 verified)
  [73478] = true, 	-- Fire Prism, still has a cd (5.2.0 verified)
  [131691] = "facet", 	-- Imperial Amethyst/Facets of Research
  [131686] = "facet", 	-- Primordial Ruby/Facets of Research
  [131593] = "facet", 	-- River's Heart/Facets of Research
  [131695] = "facet", 	-- Sun's Radiance/Facets of Research
  [131690] = "facet", 	-- Vermilion Onyx/Facets of Research
  [131688] = "facet", 	-- Wild Jade/Facets of Research
  [140050] = true,	-- Serpent's Heart
  [176087] = true,	-- Secrets of Draenor
  [170700] = true,	-- Taladite Crystal

  -- Tailoring
  [143011] = true,	-- Celestial Cloth
  [125557] = true, 	-- Imperial Silk
  [56005] = 7, 		-- Glacial Bag (5.2.0 verified)
  [176058] = true,	-- Secrets of Draenor
  [168835] = true,	-- Hexweave Cloth
  -- Dreamcloth
  [75141] = 7, 		-- Dream of Skywall
  [75145] = 7, 		-- Dream of Ragnaros
  [75144] = 7, 		-- Dream of Hyjal
  [75142] = 7,	 	-- Dream of Deepholm
  [75146] = 7, 		-- Dream of Azshara

  -- Inscription
  [61288] = true, 	-- Minor Inscription Research
  [61177] = true, 	-- Northrend Inscription Research
  [86654] = true, 	-- Horde Forged Documents
  [89244] = true, 	-- Alliance Forged Documents
  [112996] = true, 	-- Scroll of Wisdom
  [169081] = true,	-- War Paints
  [177045] = true,	-- Secrets of Draenor
  [176513] = true,	-- Draenor Merchant Order

  -- Blacksmithing
  [138646] = true, 	-- Lightning Steel Ingot
  [143255] = true,	-- Balanced Trillium Ingot
  [171690] = true,	-- Truesteel Ingot
  [176090] = true,	-- Secrets of Draenor

  -- Leatherworking
  [140040] = "magni", 	-- Magnificence of Leather
  [140041] = "magni",	-- Magnificence of Scales
  [142976] = true,	-- Hardened Magnificent Hide
  [171391] = true,	-- Burnished Leather
  [176089] = true,	-- Secrets of Draenor

  -- Engineering
  [139176] = true,	-- Stabilized Lightning Source
  [169080] = true, 	-- Gearspring Parts
  [177054] = true,	-- Secrets of Draenor

  [126459] = "item",	-- Blingtron 4000
  [161414] = "item",	-- Blingtron 5000
  [54710]  = "item",	-- MOLL-E
  [67826]  = "item",	-- Jeeves

  [67833] = "item",	-- Wormhole Generator: Northrend
  [126755] = "item",	-- Wormhole Generator: Pandaria
  [163830] = "item",	-- Wormhole Centrifuge
  [23453] = "item", 	-- Ultrasafe Transporter: Gadgetzhan
  [36941] = "item",	-- Ultrasafe Transporter: Toshley's Station
}

local cdname = {
  ["xmute"] =  GetSpellInfo(2259).. ": "..L["Transmute"],
  ["wildxmute"] =  GetSpellInfo(2259).. ": "..L["Wild Transmute"],
  ["legionxmute"] =  GetSpellInfo(2259).. ": "..L["Legion Transmute"],
  ["facet"] =  GetSpellInfo(25229)..": "..L["Facets of Research"],
  ["sphere"] = GetSpellInfo(7411).. ": "..GetSpellInfo(28027),
  ["magni"] =  GetSpellInfo(2108).. ": "..GetSpellInfo(140040)
}

local itemcds = { -- [itemid] = spellid
  [87214] = 126459, 	-- Blingtron 4000
  [111821] = 161414, 	-- Blingtron 5000
  [132530] = 200146,	-- Reaves: Bling (Blingtron 6000)
  [40768] = 54710, 	-- MOLL-E
  [49040] = 67826,	-- Jeeves
  [132525] = 200087,	-- Reaves: Repair
  [112059] = 163830,	-- Wormhole Centrifuge
  [48933] = 67833,	-- Wormhole Generator: Northrend
  [87215] = 126755,	-- Wormhole Generator: Pandaria
  [18986] = 23453, 	-- Ultrasafe Transporter: Gadgetzhan
  [30544] = 36941,	-- Ultrasafe Transporter: Toshley's Station
}

function core:scan_item_cds()
  for itemid, spellid in pairs(itemcds) do
    local start, duration = GetItemCooldown(itemid)
    if start and duration and start > 0 then
      core:record_skill(spellid, GetTimeToTime(start+duration))
    end
  end
end

function core:record_skill(spellID, expires)
  if not spellID then return end
  local cdinfo = trade_spells[spellID]
  if not cdinfo then
    addon.skillwarned = addon.skillwarned or {}
    if expires and expires > 0 and not addon.skillwarned[spellID] then
      addon.skillwarned[spellID] = true
      bugReport("Unrecognized trade skill cd "..(GetSpellInfo(spellID) or "??").." ("..spellID..")")
    end
    return
  end
  local t = vars and vars.db.Toons[thisToon]
  if not t then return end
  local spellName = GetSpellInfo(spellID)
  t.Skills = t.Skills or {}
  local idx = spellID
  local title = spellName
  local link = nil
  if cdinfo == "item" then
    if not expires then
      core:ScheduleTimer("scan_item_cds", 2) -- theres a delay for the item to go on cd
      return
    end
    for itemid, spellid in pairs(itemcds) do
      if spellid == spellID then
        title,link = GetItemInfo(itemid) -- use item name as some item spellnames are ambiguous or wrong
        title = title or spellName
      end
    end
  elseif type(cdinfo) == "string" then
    idx = cdinfo
    title = cdname[cdinfo] or title
  elseif expires ~= 0 then
    local slink = GetSpellLink(spellID)
    if slink and #slink > 0 then  -- tt scan for the full name with profession
      link = "\124cffffd000\124Henchant:"..spellID.."\124h[X]\124h\124r"
      scantt:SetOwner(UIParent,"ANCHOR_NONE")
      scantt:SetHyperlink(link)
      local l = _G[scantt:GetName().."TextLeft1"]
      l = l and l:GetText()
      if l and #l > 0 then
        title = l
        link = link:gsub("X",l)
      else
        link = nil
      end
    end
  end
  if expires == 0 then
    if t.Skills[idx] then -- a cd ended early
      debug("Clearing Trade skill cd: %s (%s)",spellName,spellID)
    end
    t.Skills[idx] = nil
    return
  elseif not expires then
    expires = addon:GetNextDailySkillResetTime()
    if not expires then return end -- ticket 127
    if type(cdinfo) == "number" then -- over a day, make a rough guess
      expires = expires + (cdinfo-1)*24*60*60
    end
  end
  expires = math.floor(expires)
  local sinfo = t.Skills[idx] or {}
  t.Skills[idx] = sinfo
  local change = expires - (sinfo.Expires or 0)
  if math.abs(change) > 180 and addon.db.dbg then -- updating expiration guess (more than 3 min update lag)
    debug("Trade skill cd: "..(link or title).." ("..spellID..") "..
      (sinfo.Expires and string.format("%d",change).." sec" or "(new)")..
      " Local time: "..date("%c",expires))
  end
  sinfo.Title = title
  sinfo.Link = link
  sinfo.Expires = expires

  return true
end

function core:TradeSkillRescan(spellid)
  local scan = core:TRADE_SKILL_LIST_UPDATE()
  if TradeSkillFrame and TradeSkillFrame.filterTbl and
    (scan == 0 or not addon.seencds or not addon.seencds[spellid]) then
    -- scan failed, probably because the skill is hidden - try again
    addon.filtertmp = wipe(addon.filtertmp or {})
    for k,v in pairs(TradeSkillFrame.filterTbl) do addon.filtertmp[k] = v end
    TradeSkillOnlyShowMakeable(false)
    TradeSkillOnlyShowSkillUps(false)
    SetTradeSkillCategoryFilter(-1)
    SetTradeSkillInvSlotFilter(-1, 1, 1)
    ExpandTradeSkillSubClass(0)
    local rescan = core:TRADE_SKILL_LIST_UPDATE()
    debug("Rescan: "..(rescan==scan and "Failed" or "Success"))
    TradeSkillOnlyShowMakeable(addon.filtertmp.hasMaterials);
    TradeSkillOnlyShowSkillUps(addon.filtertmp.hasSkillUp);
    SetTradeSkillCategoryFilter(addon.filtertmp.subClassValue or -1)
    SetTradeSkillInvSlotFilter(addon.filtertmp.slotValue or -1, 1, 1)
  end
end

function core:TRADE_SKILL_LIST_UPDATE()
  local cnt = 0
  if C_TradeSkillUI.IsTradeSkillLinked() or C_TradeSkillUI.IsTradeSkillGuild() then return end
  local recipeids = C_TradeSkillUI.GetFilteredRecipeIDs()
  for _, spellid in ipairs(recipeids) do
    local cd, daily = C_TradeSkillUI.GetRecipeCooldown(spellid)
    if cd and daily -- GetTradeSkillCooldown often returns WRONG answers for daily cds
      and not tonumber(trade_spells[spellid]) then -- daily flag incorrectly set for some multi-day cds (Northrend Alchemy Research)
      cd = addon:GetNextDailySkillResetTime()
    elseif cd then
      cd = time() + cd  -- on cd
    else
      cd = 0 -- off cd or no cd
    end
    core:record_skill(spellid, cd)
    if cd then
      addon.seencds = addon.seencds or {}
      addon.seencds[spellid] = true
      cnt = cnt + 1
    end
  end

  return cnt
end

local farm_spells = {
    [111102]="plant", -- Plant Green Cabbage
    [123361]="plant", -- Plant Juicycrunch Carrot
    [123388]="plant", -- Plant Scallions
    [123485]="plant", -- Plant Mogu Pumpkin
    [123535]="plant", -- Plant Red Blossom Leek
    [123565]="plant", -- Plant Pink Turnip
    [123568]="plant", -- Plant White Turnip
    [123771]="plant", -- Plant Golden Seed
    [123772]="plant", -- Plant Seed of Harmony
    [123773]="plant", -- Plant Snakeroot Seed
    [123774]="plant", -- Plant Enigma Seed
    [123775]="plant", -- Plant Magebulb Seed
    [123776]="plant", -- Plant Soybean Seed
    [123777]="plant", -- Plant Ominous Seed
    [123892]="plant", -- Plant Autumn Blossom Sapling
    [123893]="plant", -- Plant Spring Blossom Seed
    [123894]="plant", -- Plant Winter Blossom Sapling
    [123895]="plant", -- Plant Kyparite Seed
    [129623]="plant", -- Plant Windshear Cactus Seed
    [129628]="plant", -- Plant Raptorleaf Seed
    [129863]="plant", -- Plant Songbell Seed
    [129974]="plant", -- Plant Witchberries
    [129976]="plant", -- Plant Jade Squash
    [129978]="plant", -- Plant Striped Melon
    [130170]="plant", -- Plant Spring Blossom Sapling
    [133036]="plant", -- Plant Unstable Portal Shard

    [116356]="throw", -- Throw Green Cabbage Seeds
    [123362]="throw", -- Throw Juicycrunch Carrot Seeds
    [123389]="throw", -- Throw Scallion Seeds
    [123486]="throw", -- Throw Mogu Pumpkin Seeds
    [123537]="throw", -- Throw Red Blossom Leek Seeds
    [123566]="throw", -- Throw Pink Turnip Seeds
    [123567]="throw", -- Throw White Turnip Seeds
    [131093]="throw", -- Throw Witchberry Seeds
    [131094]="throw", -- Throw Jade Squash Seeds
    [131095]="throw", -- Throw Striped Melon Seeds
    [139975]="throw", -- Throw Songbell Seeds
    [139977]="throw", -- Throw Snakeroot Seeds
    [139978]="throw", -- Throw Enigma Seeds
    [139981]="throw", -- Throw Magebulb Seeds
    [139983]="throw", -- Throw Windshear Cactus Seeds
    [139986]="throw", -- Throw Raptorleaf Seeds

    [111123]="harvest", -- Harvest Green Cabbage
    [115063]="harvest", -- Harvest EZ-Gro Green Cabbage
    [123353]="harvest", -- Harvest Juicycrunch Carrot
    [123355]="harvest", -- Harvest Plump Green Cabbage
    [123356]="harvest", -- Harvest Plump Juicycrunch Carrot
    [123375]="harvest", -- Harvest Scallions
    [123380]="harvest", -- Harvest Plump Scallions
    [123445]="harvest", -- Harvest Mogu Pumpkin
    [123451]="harvest", -- Harvest Plump Mogu Pumpkin
    [123516]="harvest", -- Harvest Winter Blossom Tree
    [123522]="harvest", -- Harvest Plump Red Blossom Leek
    [123524]="harvest", -- Harvest Red Blossom Leek
    [123548]="harvest", -- Harvest Pink Turnip
    [123549]="harvest", -- Harvest Plump Pink Turnip
    [123570]="harvest", -- Harvest White Turnip
    [123571]="harvest", -- Harvest Plump White Turnip
    [129673]="harvest", -- Harvest Golden Lotus
    [129674]="harvest", -- Harvest Fool\'s Cap
    [129675]="harvest", -- Harvest Snow Lily
    [129676]="harvest", -- Harvest Silkweed
    [129687]="harvest", -- Harvest Green Tea Leaf
    [129705]="harvest", -- Harvest Rain Poppy
    [129757]="harvest", -- Harvest Snakeroot
    [129796]="harvest", -- Harvest Magebulb
    [129814]="harvest", -- Harvest Windshear Cactus
    [129843]="harvest", -- Harvest Raptorleaf
    [129887]="harvest", -- Harvest Songbell
    [129983]="harvest", -- Harvest Witchberries
    [129984]="harvest", -- Harvest Plump Witchberries
    [130025]="harvest", -- Harvest Jade Squash
    [130026]="harvest", -- Harvest Plump Jade Squash
    [130042]="harvest", -- Harvest Striped Melon
    [130043]="harvest", -- Harvest Plump Striped Melon
    [130109]="harvest", -- Harvest Terrible Turnip
    [130140]="harvest", -- Harvest Autumn Blossom Tree
    [130168]="harvest", -- Harvest Spring Blossom Tree
    [133106]="harvest", -- Harvest Portal Shard
}

function core:record_farm(spellID)
  local ft = farm_spells[spellID]
  if not ft then return end
  local t = vars and vars.db.Toons[thisToon]
  if not t then return end
  if ft == "plant" or ft == "throw" then
    local amt = (ft == "plant" and 1 or 4)
    t.FarmPlanted = (t.FarmPlanted or 0) + amt
    t.FarmCropPlanted = t.FarmCropPlanted or {}
    t.FarmCropPlanted[spellID] = (t.FarmCropPlanted[spellID] or 0) + amt
  elseif ft == "harvest" then
    if t.FarmExpires and time() + 60 > t.FarmExpires then -- assume this is a fresh day
      t.FarmExpires = t.FarmExpires - 60
      addon:UpdateToonData() -- ticket 132: ensure refresh if we're harvesting right after reset
    end
    t.FarmHarvested = (t.FarmHarvested or 0) + 1
    t.FarmCropReady = nil
  end
  t.FarmExpires = addon:GetNextDailySkillResetTime()
  debug("Farm "..ft..": planted="..(t.FarmPlanted or 0)..
    " harvested="..(t.FarmHarvested or 0).." expires="..date("%c",t.FarmExpires or 0))
end

function core:UNIT_SPELLCAST_SUCCEEDED(evt, unit, spellName, rank, lineID, spellID)
  if unit ~= "player" then return end
  if trade_spells[spellID] then
    debug("UNIT_SPELLCAST_SUCCEEDED: %s (%s)",GetSpellLink(spellID),spellID)
    if not core:record_skill(spellID) then return end
    core:ScheduleTimer("TradeSkillRescan", 0.5, spellID)
  elseif farm_spells[spellID] then
    debug("UNIT_SPELLCAST_SUCCEEDED: %s (%s)",GetSpellLink(spellID),spellID)
    core:record_farm(spellID)
  end
end

function core:BonusRollResult(event, rewardType, rewardLink, rewardQuantity, rewardSpecID)
  local t = vars.db.Toons[thisToon]
  debug("BonusRollResult:%s:%s:%s:%s (boss=%s|%s)",
    tostring(rewardType), tostring(rewardLink), tostring(rewardQuantity), tostring(rewardSpecID),
    tostring(t and t.lastboss), tostring(t and t.lastbossyell))
  if not t then return end
  if not rewardType then return end -- sometimes get a bogus message, ignore it
  t.BonusRoll = t.BonusRoll or {}
  --local rewardstr = _G["BONUS_ROLL_REWARD_"..string.upper(rewardType)]
  local now = time()
  local bossname = t.lastboss
  if now > (t.lastbosstime or 0) + 3*60 then -- user rolled before lastboss was updated, ignore the stale one. Roll timeout is 3 min.
    bossname = nil
  end
  if not bossname and t.lastbossyell and now < (t.lastbossyelltime or 0) + 10*60 then
    bossname = t.lastbossyell -- yell fallback
  end
  if not bossname then
    bossname = GetSubZoneText() or GetRealZoneText() -- zone fallback
  end
  local roll = { name = bossname, time = now, currencyID = BonusRollFrame.currencyID }
  if rewardType == "money" then
    roll.money = rewardQuantity
  elseif rewardType == "artifact_power" then
    roll.money = 25 -- Hacky and cludgy but it'll do for now
    --roll.item = rewardlink -- Possible alternative to at least show Artifact Power rewarded
  elseif rewardType == "item" then
    roll.item = rewardLink
  end
  table.insert(t.BonusRoll, 1, roll)
  local limit = 25
  for i=limit+1, table.maxn(t.BonusRoll) do
    t.BonusRoll[i] = nil
  end
end

function addon.BonusRollShow()
  local t = vars.db.Toons[thisToon]
  if not t or not BonusRollFrame then return end
  local binfo = t.BonusRoll
  local frame = addon.BonusFrame
  if not binfo or #binfo == 0 or not vars.db.Tooltip.AugmentBonus then
    if frame then frame:Hide() end
    return
  end
  if not frame then
    frame = CreateFrame("Button", "SavedInstancesBonusRollFrame", BonusRollFrame, "SpellBookSkillLineTabTemplate")
    addon.BonusFrame = frame
    --frame:SetSize(BonusRollFrame:GetHeight(), BonusRollFrame:GetHeight())
    frame:SetPoint("LEFT", BonusRollFrame, "RIGHT",0,8)
    frame.text = addon.BonusFrame:CreateFontString(nil, "OVERLAY","GameFontNormal")
    frame.text:SetPoint("CENTER")
    frame:SetScript("OnEnter", function() ShowBonusTooltip(nil, { thisToon, frame }) end )
    frame:SetScript("OnLeave", CloseTooltips)
    frame:SetScript("OnClick", nil)
    frame.text:Show()
  end
  local bonus = 0
  for _,rinfo in ipairs(binfo) do
    if rinfo.money then
      bonus = bonus + 1
    else
      break
    end
  end
  frame.text:SetText((bonus > 0 and "+" or "")..bonus)
  frame:Show()
end

hooksecurefunc("BonusRollFrame_StartBonusRoll", addon.BonusRollShow)
