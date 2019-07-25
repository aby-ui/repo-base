local _, addon = ...
local TradeskillsModule = addon.core:NewModule("Tradeskills", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
local L = addon.L
local thisToon = UnitName("player") .. " - " .. GetRealmName()

-- Lua functions
local pairs, type, floor, abs, format = pairs, type, floor, abs, format
local date, wipe, ipairs, tonumber, time = date, wipe, ipairs, tonumber, time
local _G = _G

-- WoW API / Variables
local C_TradeSkillUI_GetFilteredRecipeIDs = C_TradeSkillUI.GetFilteredRecipeIDs
local C_TradeSkillUI_GetRecipeCooldown = C_TradeSkillUI.GetRecipeCooldown
local C_TradeSkillUI_IsTradeSkillGuild = C_TradeSkillUI.IsTradeSkillGuild
local C_TradeSkillUI_IsTradeSkillLinked = C_TradeSkillUI.IsTradeSkillLinked
local ExpandTradeSkillSubClass = ExpandTradeSkillSubClass
local GetItemCooldown = GetItemCooldown
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink
local SetTradeSkillCategoryFilter = SetTradeSkillCategoryFilter
local SetTradeSkillInvSlotFilter = SetTradeSkillInvSlotFilter
local TradeSkillOnlyShowMakeable = TradeSkillOnlyShowMakeable
local TradeSkillOnlyShowSkillUps = TradeSkillOnlyShowSkillUps

local trade_spells = {
  -- Alchemy
  -- Vanilla
  [11479] = "xmute", -- Transmute: Iron to Gold
  [11480] = "xmute", -- Transmute: Mithril to Truesilver
  [17559] = "xmute", -- Transmute: Air to Fire
  [17566] = "xmute", -- Transmute: Earth to Life
  [17561] = "xmute", -- Transmute: Earth to Water
  [17560] = "xmute", -- Transmute: Fire to Earth
  [17565] = "xmute", -- Transmute: Life to Earth
  [17563] = "xmute", -- Transmute: Undeath to Water
  [17562] = "xmute", -- Transmute: Water to Air
  [17564] = "xmute", -- Transmute: Water to Undeath

  -- BC
  [28566] = "xmute", -- Transmute: Primal Air to Fire
  [28585] = "xmute", -- Transmute: Primal Earth to Life
  [28567] = "xmute", -- Transmute: Primal Earth to Water
  [28568] = "xmute", -- Transmute: Primal Fire to Earth
  [28583] = "xmute", -- Transmute: Primal Fire to Mana
  [28584] = "xmute", -- Transmute: Primal Life to Earth
  [28582] = "xmute", -- Transmute: Primal Mana to Fire
  [28580] = "xmute", -- Transmute: Primal Shadow to Water
  [28569] = "xmute", -- Transmute: Primal Water to Air
  [28581] = "xmute", -- Transmute: Primal Water to Shadow

  -- WotLK
  [60893] = 3,       -- Northrend Alchemy Research: 3 days
  [53777] = "xmute", -- Transmute: Eternal Air to Earth
  [53776] = "xmute", -- Transmute: Eternal Air to Water
  [53781] = "xmute", -- Transmute: Eternal Earth to Air
  [53782] = "xmute", -- Transmute: Eternal Earth to Shadow
  [53775] = "xmute", -- Transmute: Eternal Fire to Life
  [53774] = "xmute", -- Transmute: Eternal Fire to Water
  [53773] = "xmute", -- Transmute: Eternal Life to Fire
  [53771] = "xmute", -- Transmute: Eternal Life to Shadow
  [54020] = "xmute", -- Transmute: Eternal Might
  [53779] = "xmute", -- Transmute: Eternal Shadow to Earth
  [53780] = "xmute", -- Transmute: Eternal Shadow to Life
  [53783] = "xmute", -- Transmute: Eternal Water to Air
  [53784] = "xmute", -- Transmute: Eternal Water to Fire
  [66658] = "xmute", -- Transmute: Ametrine
  [66659] = "xmute", -- Transmute: Cardinal Ruby
  [66660] = "xmute", -- Transmute: King's Amber
  [66662] = "xmute", -- Transmute: Dreadstone
  [66663] = "xmute", -- Transmute: Majestic Zircon
  [66664] = "xmute", -- Transmute: Eye of Zul

  -- Cata
  [78866] = "xmute", -- Transmute: Living Elements
  [80244] = "xmute", -- Transmute: Pyrium Bar

  -- MoP
  [114780] = "xmute", -- Transmute: Living Steel

  -- WoD
  [175880] = true,    -- Secrets of Draenor
  [156587] = true,    -- Alchemical Catalyst (4)
  [168042] = true,    -- Alchemical Catalyst (10), 3 charges w/ 24hr recharge
  [181643] = "xmute", -- Transmute: Savage Blood

  -- Legion
  [188800] = "wildxmute",   -- Transmute: Wild Transmutation (Rank 1)
  [188801] = "wildxmute",   -- Transmute: Wild Transmutation (Rank 2)
  [188802] = "wildxmute",   -- Transmute: Wild Transmutation (Rank 3)
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
  [251832] = "xmute", -- Transmute: Expulsom
  [251314] = "xmute", -- Transmute: Cloth to Skins
  [251822] = "xmute", -- Transmute: Fish to Gems
  [251306] = "xmute", -- Transmute: Herbs to Cloth
  [251305] = "xmute", -- Transmute: Herbs to Ore
  [251808] = "xmute", -- Transmute: Meat to Pet
  [251310] = "xmute", -- Transmute: Ore to Cloth
  [251311] = "xmute", -- Transmute: Ore to Gems
  [251309] = "xmute", -- Transmute: Ore to Herbs
  [286547] = "xmute", -- Transmute: Herbs to Anchors

  -- Enchanting
  [28027]  = "sphere", -- Prismatic Sphere (2-day shared, 5.2.0 verified)
  [28028]  = "sphere", -- Void Sphere (2-day shared, 5.2.0 verified)
  [116499] = true,     -- Sha Crystal
  [177043] = true,     -- Secrets of Draenor
  [169092] = true,     -- Temporal Crystal

  -- Jewelcrafting
  [47280]  = true,    -- Brilliant Glass, still has a cd (5.2.0 verified)
  [73478]  = true,    -- Fire Prism, still has a cd (5.2.0 verified)
  [131691] = "facet", -- Imperial Amethyst/Facets of Research
  [131686] = "facet", -- Primordial Ruby/Facets of Research
  [131593] = "facet", -- River's Heart/Facets of Research
  [131695] = "facet", -- Sun's Radiance/Facets of Research
  [131690] = "facet", -- Vermilion Onyx/Facets of Research
  [131688] = "facet", -- Wild Jade/Facets of Research
  [140050] = true,    -- Serpent's Heart
  [176087] = true,    -- Secrets of Draenor
  [170700] = true,    -- Taladite Crystal

  -- Tailoring
  [143011] = true, -- Celestial Cloth
  [125557] = true, -- Imperial Silk
  [56005]  = 7,    -- Glacial Bag (5.2.0 verified)
  [176058] = true, -- Secrets of Draenor
  [168835] = true, -- Hexweave Cloth

  -- Dreamcloth
  [75141] = 7, -- Dream of Skywall
  [75145] = 7, -- Dream of Ragnaros
  [75144] = 7, -- Dream of Hyjal
  [75142] = 7, -- Dream of Deepholm
  [75146] = 7, -- Dream of Azshara

  -- Inscription
  [61288]  = true, -- Minor Inscription Research
  [61177]  = true, -- Northrend Inscription Research
  [86654]  = true, -- Horde Forged Documents
  [89244]  = true, -- Alliance Forged Documents
  [112996] = true, -- Scroll of Wisdom
  [169081] = true, -- War Paints
  [177045] = true, -- Secrets of Draenor
  [176513] = true, -- Draenor Merchant Order

  -- Blacksmithing
  [138646] = true, -- Lightning Steel Ingot
  [143255] = true, -- Balanced Trillium Ingot
  [171690] = true, -- Truesteel Ingot
  [171718] = true, -- Truestell Ingot, 3 charges w/ 24hr recharge
  [176090] = true, -- Secrets of Draenor

  -- Leatherworking
  [140040] = "magni", -- Magnificence of Leather
  [140041] = "magni", -- Magnificence of Scales
  [142976] = true,    -- Hardened Magnificent Hide
  [171391] = true,    -- Burnished Leather
  [176089] = true,    -- Secrets of Draenor

  -- Engineering
  [139176] = true, -- Stabilized Lightning Source
  [169080] = true, -- Gearspring Parts
  [177054] = true, -- Secrets of Draenor

  -- Item
  [54710]  = "item", -- MOLL-E
  [67826]  = "item", -- Jeeves
  [126459] = "item", -- Blingtron 4000
  [161414] = "item", -- Blingtron 5000
  [200061] = "item", -- Rechargeable Reaves Battery
  [261602] = "item", -- Katy's Stampwhistle
  [298926] = "item", -- Blingtron 7000
  -- Wormhole
  [67833]  = "item", -- Wormhole Generator: Northrend
  [126755] = "item", -- Wormhole Generator: Pandaria
  [163830] = "item", -- Wormhole Centrifuge (Draenor)
  [250796] = "item", -- Wormhole Generator: Argus
  [299083] = "item", -- Wormhole Generator: Kul Tiras
  [299084] = "item", -- Wormhole Generator: Zandalar
  -- Transporter
  [23453]  = "item", -- Ultrasafe Transporter: Gadgetzhan
  [36941]  = "item", -- Ultrasafe Transporter: Toshley's Station
}

local itemcds = { -- [itemid] = spellid
  [40768]  = 54710,  -- MOLL-E
  [49040]  = 67826,  -- Jeeves
  [87214]  = 126459, -- Blingtron 4000
  [111821] = 161414, -- Blingtron 5000
  [144341] = 200061, -- Rechargeable Reaves Battery
  [156833] = 261602, -- Katy's Stampwhistle
  [168667] = 298926, -- Blingtron 7000
  -- Wormhole
  [48933]  = 67833,  -- Wormhole Generator: Northrend
  [87215]  = 126755, -- Wormhole Generator: Pandaria
  [112059] = 163830, -- Wormhole Centrifuge (Draenor)
  [151652] = 250796, -- Wormhole Generator: Argus
  [168807] = 299083, -- Wormhole Generator: Kul Tiras
  [168808] = 299084, -- Wormhole Generator: Zandalar
  -- Transporter
  [18986]  = 23453,  -- Ultrasafe Transporter: Gadgetzhan
  [30544]  = 36941,  -- Ultrasafe Transporter: Toshley's Station
}

local cdname = {
  ["xmute"] = GetSpellInfo(2259).. ": "..L["Transmute"],
  ["wildxmute"] = GetSpellInfo(2259).. ": "..L["Wild Transmute"],
  ["legionxmute"] = GetSpellInfo(2259).. ": "..L["Legion Transmute"],
  ["facet"] = GetSpellInfo(25229)..": "..L["Facets of Research"],
  ["sphere"] = GetSpellInfo(7411).. ": "..GetSpellInfo(28027),
  ["magni"] = GetSpellInfo(2108).. ": "..GetSpellInfo(140040)
}

function TradeskillsModule:OnEnable()
  self:RegisterBucketEvent("TRADE_SKILL_LIST_UPDATE", 1)
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end

function TradeskillsModule:ScanItemCDs()
  for itemid, spellid in pairs(itemcds) do
    local start, duration = GetItemCooldown(itemid)
    if start and duration and start > 0 then
      self:RecordSkill(spellid, addon.GetTimeToTime(start + duration))
    end
  end
end

function TradeskillsModule:RecordSkill(spellID, expires)
  if not spellID then return end
  local cdinfo = trade_spells[spellID]
  if not cdinfo then
    addon.skillwarned = addon.skillwarned or {}
    if expires and expires > 0 and not addon.skillwarned[spellID] then
      addon.skillwarned[spellID] = true
      addon.bugReport("Unrecognized trade skill cd "..(GetSpellInfo(spellID) or "??").." ("..spellID..")")
    end
    return
  end
  local t = addon and addon.db.Toons[thisToon]
  if not t then return end
  local spellName = GetSpellInfo(spellID)
  t.Skills = t.Skills or {}
  local idx = spellID
  local title = spellName
  local link = nil
  if cdinfo == "item" then
    if not expires then
      self:ScheduleTimer("ScanItemCDs", 2) -- theres a delay for the item to go on cd
      return
    end
    for itemid, spellid in pairs(itemcds) do
      if spellid == spellID then
        title, link = GetItemInfo(itemid) -- use item name as some item spellnames are ambiguous or wrong
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
      addon.scantt:SetOwner(_G.UIParent,"ANCHOR_NONE")
      addon.scantt:SetHyperlink(link)
      local l = _G[addon.scantt:GetName().."TextLeft1"]
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
      addon.debug("Clearing Trade skill cd: %s (%s)",spellName,spellID)
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
  expires = floor(expires)
  local sinfo = t.Skills[idx] or {}
  t.Skills[idx] = sinfo
  local change = expires - (sinfo.Expires or 0)
  if abs(change) > 180 then -- updating expiration guess (more than 3 min update lag)
    addon.debug("Trade skill cd: "..(link or title).." ("..spellID..") "..
      (sinfo.Expires and format("%d",change).." sec" or "(new)")..
      " Local time: "..date("%c",expires))
  end
  sinfo.Title = title
  sinfo.Link = link
  sinfo.Expires = expires

  return true
end

function TradeskillsModule:TradeSkillRescan(spellid)
  local scan = self:TRADE_SKILL_LIST_UPDATE()
  if _G.TradeSkillFrame and _G.TradeSkillFrame.filterTbl and
    (scan == 0 or not self.seencds or not self.seencds[spellid]) then
    -- scan failed, probably because the skill is hidden - try again
    self.filtertmp = wipe(self.filtertmp or {})
    for k,v in pairs(_G.TradeSkillFrame.filterTbl) do self.filtertmp[k] = v end
    TradeSkillOnlyShowMakeable(false)
    TradeSkillOnlyShowSkillUps(false)
    SetTradeSkillCategoryFilter(-1)
    SetTradeSkillInvSlotFilter(-1, 1, 1)
    ExpandTradeSkillSubClass(0)
    local rescan = self:TRADE_SKILL_LIST_UPDATE()
    addon.debug("Rescan: "..(rescan==scan and "Failed" or "Success"))
    TradeSkillOnlyShowMakeable(self.filtertmp.hasMaterials)
    TradeSkillOnlyShowSkillUps(self.filtertmp.hasSkillUp)
    SetTradeSkillCategoryFilter(self.filtertmp.subClassValue or -1)
    SetTradeSkillInvSlotFilter(self.filtertmp.slotValue or -1, 1, 1)
  end
end

function TradeskillsModule:TRADE_SKILL_LIST_UPDATE()
  local cnt = 0
  if C_TradeSkillUI_IsTradeSkillLinked() or C_TradeSkillUI_IsTradeSkillGuild() then return end
  local recipeids = C_TradeSkillUI_GetFilteredRecipeIDs()
  for _, spellid in ipairs(recipeids) do
    local cd, daily = C_TradeSkillUI_GetRecipeCooldown(spellid)
    if cd and daily -- GetTradeSkillCooldown often returns WRONG answers for daily cds
      and not tonumber(trade_spells[spellid]) then -- daily flag incorrectly set for some multi-day cds (Northrend Alchemy Research)
      cd = addon:GetNextDailySkillResetTime()
    elseif cd then
      cd = time() + cd  -- on cd
    else
      cd = 0 -- off cd or no cd
    end
    self:RecordSkill(spellid, cd)
    if cd then
      self.seencds = self.seencds or {}
      self.seencds[spellid] = true
      cnt = cnt + 1
    end
  end

  return cnt
end

function TradeskillsModule:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellID)
  if unit ~= "player" then return end
  if trade_spells[spellID] then
    addon.debug("UNIT_SPELLCAST_SUCCEEDED: %s (%s)",GetSpellLink(spellID),spellID)
    if not self:RecordSkill(spellID) then return end
    self:ScheduleTimer("TradeSkillRescan", 0.5, spellID)
  end
end
