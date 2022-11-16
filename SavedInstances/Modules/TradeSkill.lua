local SI, L = unpack(select(2, ...))
local Module = SI:NewModule('TradeSkill', 'AceEvent-3.0', 'AceTimer-3.0', 'AceBucket-3.0')

-- Lua functions
local pairs, type, floor, abs, format = pairs, type, floor, abs, format
local date, ipairs, tonumber, time = date, ipairs, tonumber, time
local _G = _G

-- WoW API / Variables
local C_TradeSkillUI_GetAllRecipeIDs = C_TradeSkillUI.GetAllRecipeIDs
local C_TradeSkillUI_GetFilteredRecipeIDs = C_TradeSkillUI.GetFilteredRecipeIDs
local C_TradeSkillUI_GetRecipeCooldown = C_TradeSkillUI.GetRecipeCooldown
local C_TradeSkillUI_IsTradeSkillGuild = C_TradeSkillUI.IsTradeSkillGuild
local C_TradeSkillUI_IsTradeSkillLinked = C_TradeSkillUI.IsTradeSkillLinked
local GetItemCooldown = GetItemCooldown
local GetItemInfo = GetItemInfo
local GetSpellInfo = GetSpellInfo
local GetSpellLink = GetSpellLink

local tradeSpells = {
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

  -- SL
  [307142] = true, -- Shadowghast Ingot
  [307143] = true, -- Shadestone
  [307144] = true, -- Stones to Ore

  -- Dragonflight
  [370707] = "dragonflightxmute", -- Transmute: Awakened Fire
  [370708] = "dragonflightxmute", -- Transmute: Awakened Frost
  [370710] = "dragonflightxmute", -- Transmute: Awakened Earth
  [370711] = "dragonflightxmute", -- Transmute: Awakened Air
  [370714] = "dragonflightxmute", -- Transmute: Decay to Elements
  [370715] = "dragonflightxmute", -- Transmute: Order to Elements
  [370743] = "dragonflightexper", -- Basic Potion Experimentation
  [370745] = "dragonflightexper", -- Advanced Potion Experimentation
  [370746] = "dragonflightexper", -- Basic Phial Experimentation
  [370747] = "dragonflightexper", -- Advanced Phial Experimentation

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
  [374546] = true,    -- Queen's Gift
  [374547] = true,    -- Dreamer's Vision
  [374548] = true,    -- Keeper's Glory
  [374549] = true,    -- Earthwarden's Prize
  [374550] = true,    -- Timewatcher's Patience
  [374551] = true,    -- Jeweled Dragon's Heart

  -- Tailoring
  [75141] = 7,     -- Dream of Skywall
  [75145] = 7,     -- Dream of Ragnaros
  [75144] = 7,     -- Dream of Hyjal
  [75142] = 7,     -- Dream of Deepholm
  [75146] = 7,     -- Dream of Azshara
  [143011] = true, -- Celestial Cloth
  [125557] = true, -- Imperial Silk
  [56005]  = 7,    -- Glacial Bag (5.2.0 verified)
  [176058] = true, -- Secrets of Draenor
  [168835] = true, -- Hexweave Cloth
  [376556] = true, -- Azureweave Bolt
  [376557] = true, -- Chronocloth Bolt

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
  [382358] = true, -- Suspiciously Silent Crate
  [382354] = true, -- Suspiciously Ticking Crate

  -- Cooking
  [378302] = true, -- Ooey-Gooey Chocolate

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
  [324031] = "item", -- Wormhole Generator: Shadowlands
  [386379] = "item", -- Wyrmhole Generator
  -- Transporter
  [23453]  = "item", -- Ultrasafe Transporter: Gadgetzhan
  [36941]  = "item", -- Ultrasafe Transporter: Toshley's Station
}

local itemCDs = { -- [spellID] = itemID
  [54710]  = 40768,  -- MOLL-E
  [67826]  = 49040,  -- Jeeves
  [126459] = 87214,  -- Blingtron 4000
  [161414] = 111821, -- Blingtron 5000
  [200061] = 144341, -- Rechargeable Reaves Battery
  [261602] = 156833, -- Katy's Stampwhistle
  [298926] = 168667, -- Blingtron 7000
  -- Wormhole
  [67833]  = 48933,  -- Wormhole Generator: Northrend
  [126755] = 87215,  -- Wormhole Generator: Pandaria
  [163830] = 112059, -- Wormhole Centrifuge (Draenor)
  [250796] = 151652, -- Wormhole Generator: Argus
  [299083] = 168807, -- Wormhole Generator: Kul Tiras
  [299084] = 168808, -- Wormhole Generator: Zandalar
  [324031] = 172924, -- Wormhole Generator: Shadowlands
  [386379] = 198156, -- Wyrmhole Generator
  -- Transporter
  [23453]  = 18986,  -- Ultrasafe Transporter: Gadgetzhan
  [36941]  = 30544,  -- Ultrasafe Transporter: Toshley's Station
}

local categoryNames = {
  ["xmute"] = GetSpellInfo(2259).. ": "..L["Transmute"],
  ["wildxmute"] = GetSpellInfo(2259).. ": "..L["Wild Transmute"],
  ["legionxmute"] = GetSpellInfo(2259).. ": "..L["Legion Transmute"],
  ["dragonflightxmute"] = GetSpellInfo(2259).. ": "..L["Dragonflight Transmute"],
  ["dragonflightexper"] = GetSpellInfo(2259).. ": "..L["Dragonflight Experimentation"],
  ["facet"] = GetSpellInfo(25229)..": "..L["Facets of Research"],
  ["sphere"] = GetSpellInfo(7411).. ": "..GetSpellInfo(28027),
  ["magni"] = GetSpellInfo(2108).. ": "..GetSpellInfo(140040)
}

function Module:OnEnable()
  self:RegisterBucketEvent("TRADE_SKILL_LIST_UPDATE", 1)
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end

function Module:ScanItemCDs()
  for spellID, itemID in pairs(itemCDs) do
    local start, duration = GetItemCooldown(itemID)
    if start and duration and start > 0 then
      self:RecordSkill(spellID, SI:GetTimeToTime(start + duration))
    end
  end
end

function Module:RecordSkill(spellID, expires)
  if not spellID then return end
  local info = tradeSpells[spellID]
  if not info then
    self.missingWarned = self.missingWarned or {}
    if expires and expires > 0 and not self.missingWarned[spellID] then
      self.missingWarned[spellID] = true
      SI:BugReport("Unrecognized trade skill cd "..(GetSpellInfo(spellID) or "??").." ("..spellID..")")
    end
    return
  end

  local t = SI.db.Toons[SI.thisToon]
  t.Skills = t.Skills or {}

  local index = spellID
  local spellName = GetSpellInfo(spellID)
  local title = spellName
  local link = nil
  if info == "item" then
    if not expires then
      self:ScheduleTimer("ScanItemCDs", 2) -- theres a delay for the item to go on cd
      return
    elseif expires - time() < 6 then
      -- might be global cooldowns, #509
      return
    end
    if itemCDs[spellID] then
      -- use item name as some item spellnames are ambiguous or wrong
      title, link = GetItemInfo(itemCDs[spellID])
      title = title or spellName
    end
  elseif type(info) == "string" then
    index = info
    title = categoryNames[info] or title
  elseif expires ~= 0 then
    local slink = GetSpellLink(spellID)
    if slink and #slink > 0 then  -- tt scan for the full name with profession
      link = "\124cffffd000\124Henchant:" .. spellID .. "\124h[X]\124h\124r"
      SI.ScanTooltip:SetOwner(_G.UIParent, 'ANCHOR_NONE')
      SI.ScanTooltip:SetHyperlink(link)
      SI.ScanTooltip:Show()
      local line = _G[SI.ScanTooltip:GetName() .. "TextLeft1"]
      line = line and line:GetText()
      if line and #line > 0 then
        title = line
        link = link:gsub("X", line)
      else
        link = nil
      end
    end
  end

  if expires == 0 then
    if t.Skills[index] then -- a cd ended early
      SI:Debug("Clearing Trade skill cd: %s (%s)",spellName,spellID)
    end
    t.Skills[index] = nil
    return
  elseif not expires then
    expires = SI:GetNextDailySkillResetTime()
    if not expires then return end -- ticket 127
    if type(info) == "number" then -- over a day, make a rough guess
      expires = expires + (info - 1) * 24 * 60 * 60
    end
  end
  expires = floor(expires)

  local sinfo = t.Skills[index] or {}
  t.Skills[index] = sinfo
  local change = expires - (sinfo.Expires or 0)
  if abs(change) > 180 then -- updating expiration guess (more than 3 min update lag)
    SI:Debug("Trade skill cd: "..(link or title).." ("..spellID..") "..
      (sinfo.Expires and format("%d",change).." sec" or "(new)")..
      " Local time: "..date("%c",expires))
  end
  sinfo.Title = title
  sinfo.Link = link
  sinfo.Expires = expires

  return true
end

function Module:RescanTradeSkill(spellID)
  local count = self:ScanTradeSkill()

  if count == 0 or not self.cooldownFound or not self.cooldownFound[spellID] then
    -- scan failed, probably because the skill is hidden - try again
    local rescanCount = self:ScanTradeSkill(true)
    SI:Debug("Rescan: " .. (rescanCount == count and "Failed" or "Success"))
  end
end

function Module:ScanTradeSkill(isAll)
  if C_TradeSkillUI_IsTradeSkillLinked() or C_TradeSkillUI_IsTradeSkillGuild() then return end

  local count = 0
  local data = isAll and C_TradeSkillUI_GetAllRecipeIDs() or C_TradeSkillUI_GetFilteredRecipeIDs()
  for _, spellID in ipairs(data) do
    local cooldown, isDayCooldown = C_TradeSkillUI_GetRecipeCooldown(spellID)
    if (
      cooldown and isDayCooldown -- GetRecipeCooldown often returns WRONG answers for daily cds
      and not tonumber(tradeSpells[spellID]) -- daily flag incorrectly set for some multi-day cds (Northrend Alchemy Research)
    ) then
      cooldown = SI:GetNextDailySkillResetTime()
    elseif cooldown then
      cooldown = time() + cooldown -- on cooldown
    else
      cooldown = 0 -- off cooldown or no cooldown
    end

    self:RecordSkill(spellID, cooldown)
    if cooldown then
      self.cooldownFound = self.cooldownFound or {}
      self.cooldownFound[spellID] = true
      count = count + 1
    end
  end

  return count
end

function Module:TRADE_SKILL_LIST_UPDATE()
  self:ScanTradeSkill()
end

function Module:UNIT_SPELLCAST_SUCCEEDED(_, unit, _, spellID)
  if unit ~= "player" or not tradeSpells[spellID] then return end

  SI:Debug("UNIT_SPELLCAST_SUCCEEDED: %s (%s)", GetSpellLink(spellID), spellID)

  if not self:RecordSkill(spellID) then return end
  self:ScheduleTimer("RescanTradeSkill", 0.5, spellID)
end
