local addonName, addon = ...
local TradeskillsModule = LibStub("AceAddon-3.0"):GetAddon(addonName):NewModule("Tradeskills")
local L = addon.L

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
addon.trade_spells = trade_spells

local cdname = {
  ["xmute"] =  GetSpellInfo(2259).. ": "..L["Transmute"],
  ["wildxmute"] =  GetSpellInfo(2259).. ": "..L["Wild Transmute"],
  ["legionxmute"] =  GetSpellInfo(2259).. ": "..L["Legion Transmute"],
  ["facet"] =  GetSpellInfo(25229)..": "..L["Facets of Research"],
  ["sphere"] = GetSpellInfo(7411).. ": "..GetSpellInfo(28027),
  ["magni"] =  GetSpellInfo(2108).. ": "..GetSpellInfo(140040)
}
addon.cdname = cdname
