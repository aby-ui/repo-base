local _, addon = ...
local QuestsModule = addon.core:NewModule("Quests")

-- Lua functions
local pairs, strtrim = pairs, strtrim
local _G = _G

-- WoW API / Variables
local C_Map_GetMapInfo = C_Map.GetMapInfo
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local LOOT = LOOT

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
      addon.scantt:SetOwner(_G.UIParent,"ANCHOR_NONE")
      addon.scantt:SetAchievementByID(qinfo.aid)
      local l = _G[addon.scantt:GetName().."Text"..(qinfo.aline or "Left1")]
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
      qinfo.zone = C_Map_GetMapInfo(qinfo.zid)
    end
  end

  return _specialQuests
end

local QuestExceptions = {
  -- Expansion
  -- MoP
  [32640] = "Weekly", -- Champions of the Thunder King
  [32641] = "Weekly", -- Champions of the Thunder King
  [32718] = "Regular", -- Mogu Runes of Fate -- ticket 142: outdated quest flag still shows up
  [32719] = "Regular", -- Mogu Runes of Fate
  [33133] = "Regular", -- Warforged Seals outdated quests, no longer weekly
  [33134] = "Regular", -- Warforged Seals
  [33338] = "Weekly", -- Empowering the Hourglass
  [33334] = "Weekly", -- Strong Enough to Survive

  -- LEG
  -- Order Hall
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
  -- Argus
  [48910] = "Weekly", -- Supplying Krokuun
  [48911] = "Weekly", -- Void Inoculation
  [48912] = "Weekly", -- Supplying the Antoran Campaign
  [48634] = "Regular", -- Further Supplying Krokuun
  [48635] = "Regular", -- More Void Inoculation
  [48636] = "Regular", -- Fueling the Antoran Campaign

  -- BfA
  -- Island Expeditions (Moved to Progress.lua)
  [53435] = "Regular", -- Azerite for the Horde
  [53436] = "Regular", -- Azerite for the Alliance
  -- Warfront (Moved to Warfront.lua)
  [53414] = "Regular", -- Stromgarde Alliance
  [53416] = "Regular", -- Stromgarde Horde
  [53992] = "Regular", -- Darkshore Alliance
  [53955] = "Regular", -- Darkshore Horde
  -- Call to Arms: Weekly World PvP Quest
  [52944] = "Weekly", -- Call to Arms: Drustvar (Alliance)
  [52958] = "Weekly", -- Call to Arms: Drustvar (Horde)
  [52949] = "Weekly", -- Call to Arms: Nazmir (Alliance)
  [52954] = "Weekly", -- Call to Arms: Nazmir (Horde)
  [52782] = "Weekly", -- Call to Arms: Stormsong Valley (Alliance)
  [52957] = "Weekly", -- Call to Arms: Stormsong Valley (Horde)
  [52948] = "Weekly", -- Call to Arms: Tiragarde Sound (Alliance)
  [52956] = "Weekly", -- Call to Arms: Tiragarde Sound (Horde)
  [52950] = "Weekly", -- Call to Arms: Vol'dun (Alliance)
  [52953] = "Weekly", -- Call to Arms: Vol'dun (Horde)
  [52951] = "Weekly", -- Call to Arms: Zuldazar (Alliance)
  [52952] = "Weekly", -- Call to Arms: Zuldazar (Horde)
  -- Nazjatar
  [55121] = "Weekly", -- The Laboratory of Mardivas
  [56969] = "Weekly", -- Ancient Reefwalker Bark
  [56648] = "Weekly", -- Call to Arms: Nazjatar (Alliance)
  [56148] = "Weekly", -- Call to Arms: Nazjatar (Horde)
  [56050] = "Weekly", -- PvP Event: Battle for Nazjatar
  -- Mechagon
  [56116] = "Regular", -- Even More Recycling
  [56649] = "Weekly", -- Call to Arms: Mechagon (Alliance)
  [56650] = "Weekly", -- Call to Arms: Mechagon (Horde)

  -- General
  -- Darkmoon Faire
  [7905]  = "Regular", -- Darkmoon Faire referral -- old addon versions misidentified this as monthly
  [7926]  = "Regular", -- Darkmoon Faire referral
  [37819] = "Regular", -- Darkmoon Faire races referral

  -- Blingtron
  -- update `ShowQuestTooltip` in SavedInstances.lua when updating Blingtron quest list
  [31752] = "AccountDaily", -- Blingtron 4000
  [34774] = "AccountDaily", -- Blingtron 5000
  [40753] = "AccountDaily", -- Blingtron 6000
  [56042] = "AccountDaily", -- Blingtron 7000

  -- Pet Battle Dungeons
  [45539] = "AccountWeekly", -- Pet Battle Challenge: Wailing Caverns
  [46292] = "AccountWeekly", -- Pet Battle Challenge: Deadmines
  [54186] = "AccountWeekly", -- Pet Battle Challenge: Gnomeregan
  [56492] = "AccountWeekly", -- Pet Battle Challenge: Stratholme

  -- Weekend Event
  [53030] = "Weekly", -- The World Awaits - World Quests
  [53032] = "Weekly", -- A Burning Path Through Time - TBC Timewalking
  [53033] = "Weekly", -- A Frozen Path Through Time - WLK Timewalking
  [53034] = "Weekly", -- A Shattered Path Through Time - CTM Timewalking
  [53035] = "Weekly", -- A Shattered Path Through Time - MOP Timewalking
  [54995] = "Weekly", -- A Savage Path Through Time - WOD Timewalking
  [53036] = "Weekly", -- A Call to Battle - Battlegrounds
  [53037] = "Weekly", -- Emissary of War - Mythic Dungeons
  [53038] = "AccountWeekly", -- The Very Best - PvP Pet Battles
  [53039] = "Weekly", -- The Arena Calls - Arena Skirmishes
}
addon.QuestExceptions = QuestExceptions

-- Timewalking Dungeon final boss drops
-- to find iconTexture, select the day in calendar and use the command below
-- please note: event might have THREE different iconTexutre when START, ONGOING, END
-- /run local F,O,I,m,d,e=CalendarFrame,C_Calendar I=O.GetMonthInfo()m=-12*(I.year-F.selectedYear)+F.selectedMonth-I.month d=F.selectedDay for i=1,O.GetNumDayEvents(m,d)do e=O.GetDayEvent(m,d,i)print(e.title,e.iconTexture)end
-- [questID] = {iconTextures}
local TimewalkingItemQuest = {
  [40168] = {1129672, 1129673, 1129674}, -- The Swirling Vial - TBC Timewalking
  [40173] = {1129684, 1129685, 1129686}, -- The Unstable Prism - WLK Timewalking
  [40786] = {1304686, 1304687, 1304688}, -- The Smoldering Ember - CTM Timewalking - Horde
  [40787] = {1304686, 1304687, 1304688}, -- The Smoldering Ember - CTM Timewalking - Alliance
  [45563] = {1530588, 1530589, 1530590}, -- The Shrouded Coin - MOP Timewalking
  [55498] = {1129681, 1129682, 1129683}, -- The Shimmering Crystal - WOD Timewalking - Alliance
  [55499] = {1129681, 1129682, 1129683}, -- The Shimmering Crystal - WOD Timewalking - Horde
}
for questID, tbl in pairs(TimewalkingItemQuest) do
  QuestExceptions[questID] = "Weekly"
end
addon.TimewalkingItemQuest = TimewalkingItemQuest
