local SI, L = unpack(select(2, ...))
local Module = SI:NewModule('Quest')

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

  -- Mechagon
  [57081] = { name=L["Mechanized Chest"] }, -- Mechanized Chest
  [56139] = { daily=true, zid=1462, }, -- Junkyard Treasures
  [55901] = { daily=true, zid=1462, }, -- Rustbolt Rebellion
  [56141] = { daily=true, zid=1462, }, -- Security First

  -- Assault Coffers
  [57628] = { name=L["Cursed Coffer"] },      -- Cursed Coffer
  [57214] = { name=L["Mogu Strongbox"] },     -- Mogu Strongbox
  [58137] = { name=L["Infested Strongbox"] }, -- Infested Strongbox
  [55692] = { name=L["Amathet Reliquary"] },  -- Amathet Reliquary
  [58770] = { name=L["Ambered Coffer"] },     -- Ambered Coffer

  -- Beastwarrens Hunts
  [63180] = { name=L["Hunt: Shadehounds"] },        -- Hunt: Shadehounds
  [63194] = { name=L["Hunt: Winged Soul Eaters"] }, -- Hunt: Winged Soul Eaters
  [63198] = { name=L["Hunt: Death Elementals"] },   -- Hunt: Death Elementals
  [63199] = { name=L["Hunt: Soul Eaters"] },        -- Hunt: Soul Eaters

  -- Covenant Assaults
  [63543] = { zid=1543 }, -- Necrolord Assault
  [63822] = { zid=1543 }, -- Venthyr Assault
  [63823] = { zid=1543 }, -- Night Fae Assault
  [63824] = { zid=1543 }, -- Kyrian Assault

  -- Old Vanilla Bosses during Anniversary Event
  [47461] = { daily=true, name=L["Lord Kazzak"] },          -- Lord Kazzak
  [47462] = { daily=true, name=L["Azuregos"] },             -- Azuregos
  [47463] = { daily=true, name=L["Dragon of Nightmare"] },  -- Dragon of Nightmare
  [60214] = { daily=true, name=L["Doomwalker"] },           -- Doomwalker
}

function SI:specialQuests()
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
      SI.ScanTooltip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
      SI.ScanTooltip:SetAchievementByID(qinfo.aid)
      SI.ScanTooltip:Show()
      local l = _G[SI.ScanTooltip:GetName().."Text"..(qinfo.aline or "Left1")]
      l = l and l:GetText()
      if l then
        qinfo.name = l:gsub("%p$","")
      end
    elseif not qinfo.name and qinfo.sid then
      qinfo.name = GetSpellInfo(qinfo.sid)
    end
    if not qinfo.name or #qinfo.name == 0 then
      local title, link = SI:QuestInfo(qid)
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
  [53435] = "Weekly", -- Azerite for the Horde
  [53436] = "Weekly", -- Azerite for the Alliance
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
  [56648] = "Weekly", -- Call to Arms: Nazjatar (Alliance)
  [56148] = "Weekly", -- Call to Arms: Nazjatar (Horde)
  [56649] = "Weekly", -- Call to Arms: Mechagon (Alliance)
  [56650] = "Weekly", -- Call to Arms: Mechagon (Horde)
  [59018] = "Weekly", -- Call to Arms: Vale of Eternal Blossoms (Alliance)
  [59017] = "Weekly", -- Call to Arms: Vale of Eternal Blossoms (Horde)
  [59019] = "Weekly", -- Call to Arms: Uldum (Alliance)
  [59016] = "Weekly", -- Call to Arms: Uldum (Horde)
  -- BfA Zone Invasions
  [51982] = "Daily", -- Storm's Rage
  [53701] = "Daily", -- A Drust Cause
  [53711] = "Daily", -- A Sound Defense
  [53883] = "Daily", -- Shores of Zuldazar
  [53885] = "Daily", -- Isolated Victory
  [53939] = "Daily", -- Breaching Boralus
  [54132] = "Daily", -- Horde of Heroes
  [54134] = "Daily", -- Many Fine Heroes
  [54135] = "Daily", -- Romp in the Swamp
  [54136] = "Daily", -- March on the Marsh
  [54137] = "Daily", -- In Every Dark Corner
  [54138] = "Daily", -- Ritual Rampage
  -- Nazjatar
  [55121] = "Weekly", -- The Laboratory of Mardivas
  [56969] = "Weekly", -- Ancient Reefwalker Bark
  [56050] = "Weekly", -- PvP Event: Battle for Nazjatar
  -- Mechagon
  [56116] = "Regular", -- Even More Recycling
  -- Assaults
  [57157] = "Weekly", -- Assault: The Black Empire (Uldum)
  [56064] = "Weekly", -- Assault: The Black Empite (Vale of Eternal Blossoms)
  [55350] = "Weekly", -- Assault: Amathet Advance (Uldum)
  [57008] = "Weekly", -- Assault: The Warring Clans (Vale of Eternal Blossoms)
  [57728] = "Weekly", -- Assault: The Endless Swarm (Vale of Eternal Blossoms)
  [56308] = "Weekly", -- Assault: Aqir Unearthed (Uldum)
  -- Lesser Visions of N'Zoth
  [58168] = "Daily", -- A Dark, Glaring Reality
  [58155] = "Daily", -- A Hand in the Dark
  [58151] = "Daily", -- Minions of N'Zoth
  [58167] = "Daily", -- Preventative Measures
  [58156] = "Daily", -- Vanquishing the Darkness

  -- SL
  -- "Trading Favors" Heroic Dungeon Weekly
  [60242] = "Weekly", -- Trading Favors: Necrotic Wake
  [60243] = "Weekly", -- Trading Favors: Sanguine Depths
  [60244] = "Weekly", -- Trading Favors: Halls of Atonement
  [60245] = "Weekly", -- Trading Favors: The Other Side
  [60246] = "Weekly", -- Trading Favors: Tirna Scithe
  [60247] = "Weekly", -- Trading Favors: Theater of Pain
  [60248] = "Weekly", -- Trading Favors: Plaguefall
  [60249] = "Weekly", -- Trading Favors: Spires of Ascension
  -- "A Valuable Find" Mythic Dungeon Weekly
  [60250] = "Weekly", -- A Valuable Find: Theater of Pain
  [60251] = "Weekly", -- A Valuable Find: Plaguefall
  [60252] = "Weekly", -- A Valuable Find: Spires of Ascension
  [60253] = "Weekly", -- A Valuable Find: Necrotic Wake
  [60254] = "Weekly", -- A Valuable Find: Tirna Scithe
  [60255] = "Weekly", -- A Valuable Find: The Other Side
  [60256] = "Weekly", -- A Valuable Find: Halls of Atonement
  [60257] = "Weekly", -- A Valuable Find: Sanguine Depths
  -- "Observing" PvP Weekly
  [62284] = "Weekly", -- Observing Battle
  [62285] = "Weekly", -- Observing War
  [62286] = "Weekly", -- Observing Skirmishes
  [62287] = "Weekly", -- Observing Arenas
  [62288] = "Weekly", -- Observing Teamwork
  [62289] = "Weekly", -- Observing Conflict
  -- Ve'nari Weekly (Daily after Patch 9.1)
  [60622] = "Daily",  -- Eye of the Scryer
  [60646] = "Daily",  -- Misery Business
  [60762] = "Daily",  -- Death Motes
  [60775] = "Daily",  -- A Suitable Demise
  [61075] = "Daily",  -- A Spark of Light
  [61079] = "Daily",  -- The Jailer's Share
  [61088] = "Daily",  -- Dust to Dust
  [61103] = "Daily",  -- Disrupting the Cycle
  [61104] = "Daily",  -- Grathalax, the Extractor
  [61765] = "Daily",  -- Words of Warding
  [62214] = "Daily",  -- Forces of Perdition
  [62234] = "Daily",  -- Power of the Colossus
  [63206] = "Daily",  -- Soulless Husks
  [64541] = "Weekly", -- The Cost of Death
  -- Queen's Conservatory
  [62441] = "Weekly", -- Fair Exchange for a Soul
  [62445] = "Weekly", -- A Spirit's Pride
  [62449] = "Weekly", -- A Spirit's Duty
  [62450] = "Weekly", -- A Spirit's Heart
  [62452] = "Weekly", -- A Spirit's Might
  -- Korthia
  [64522] = "Weekly", -- Stolen Korthian Supplies

  -- General
  -- Darkmoon Faire
  [7905]  = "Regular",  -- Darkmoon Faire referral -- old addon versions misidentified this as monthly
  [7926]  = "Regular",  -- Darkmoon Faire referral
  [37819] = "Regular",  -- Darkmoon Faire races referral
  [47767] = "Darkmoon", -- Death Metal Knight

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
  [58458] = "AccountWeekly", -- Pet Battle Challenge: Blackrock Depths

  -- Weekend Event
  [62631] = "Weekly", -- The World Awaits - World Quests
  [62632] = "Weekly", -- A Burning Path Through Time - TBC Timewalking
  [62633] = "Weekly", -- A Frozen Path Through Time - WLK Timewalking
  [62634] = "Weekly", -- A Shattered Path Through Time - CTM Timewalking
  [62635] = "Weekly", -- A Shattered Path Through Time - MOP Timewalking
  [62636] = "Weekly", -- A Savage Path Through Time - WOD Timewalking
  [62637] = "Weekly", -- A Call to Battle - Battlegrounds
  [62638] = "Weekly", -- Emissary of War - Mythic Dungeons
  [62639] = "AccountWeekly", -- The Very Best - PvP Pet Battles
  [62640] = "Weekly", -- The Arena Calls - Arena Skirmishes
}
SI.QuestExceptions = QuestExceptions

-- Timewalking Dungeon final boss drops
-- [questID] = LFDID,
local TimewalkingItemQuest = {
  [40168] = 744,  -- The Swirling Vial - TBC Timewalking
  [40173] = 995,  -- The Unstable Prism - WLK Timewalking
  [40786] = 1146, -- The Smoldering Ember - CTM Timewalking - Horde
  [40787] = 1146, -- The Smoldering Ember - CTM Timewalking - Alliance
  [45563] = 1453, -- The Shrouded Coin - MOP Timewalking
  [55498] = 1971, -- The Shimmering Crystal - WOD Timewalking - Alliance
  [55499] = 1971, -- The Shimmering Crystal - WOD Timewalking - Horde
  [64710] = 2274, -- Whispering Felflame Crystal - LEG Timewalking
}
for questID, tbl in pairs(TimewalkingItemQuest) do
  QuestExceptions[questID] = "Weekly"
end
SI.TimewalkingItemQuest = TimewalkingItemQuest
