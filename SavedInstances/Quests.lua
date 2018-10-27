local addonName, addon = ...
local QuestsModule = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("Quests")
local scantt = addon.scantt

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
addon.QuestExceptions = QuestExceptions
