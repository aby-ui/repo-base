-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class
local Clone = ns.Clone

local Map = ns.Map

local Collectible = ns.node.Collectible
local Node = ns.node.Node
local NPC = ns.node.NPC
local Rare = ns.node.Rare

local Mount = ns.reward.Mount
local Toy = ns.reward.Toy

local Path = ns.poi.Path

-------------------------------------------------------------------------------

local Buff = Class('Buff', Node, { group=ns.groups.VISIONS_BUFFS })

local Crystal = Class('Crystal', Node, {
    icon='crystal_o',
    scale=1.5,
    group=ns.groups.VISIONS_CRYSTALS,
    label=L["odd_crystal"]
})

local MAIL = Node({
    icon='envelope',
    scale=1.2,
    group=ns.groups.VISIONS_MAIL,
    label=L["mailbox"],
    note=L["mail_muncher"],
    rewards={
        Mount({id=1315, item=174653}) -- Mail Muncher
    }
})

local Chest = Class('VisionsChest', Node, {
    icon='chest_gy',
    scale=1.3,
    group=ns.groups.VISIONS_CHEST,
    label=L["black_empire_cache"]
})

local CHEST1 = Chest({fgroup='c1', sublabel=string.format(L["clear_sight"], 1)})
local CHEST2 = Chest({fgroup='c2', sublabel=string.format(L["clear_sight"], 2)})
local CHEST3 = Chest({fgroup='c3', sublabel=string.format(L["clear_sight"], 3)})

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local orgrimmar = Map({ id=1469, settings=true })
local stormwind = Map({ id=1470, settings=true })

-------------------------------------------------------------------------------
---------------------------------- ORGRIMMAR ----------------------------------
-------------------------------------------------------------------------------

-- Valley of Strength
orgrimmar.nodes[46927409] = CHEST1
orgrimmar.nodes[48036506] = CHEST1
orgrimmar.nodes[48197761] = CHEST1
orgrimmar.nodes[49537689] = CHEST1
orgrimmar.nodes[50067075] = CHEST1
orgrimmar.nodes[52967707] = CHEST1

-- Valley of Spirits
orgrimmar.nodes[32046909] = CHEST2
orgrimmar.nodes[34746325] = CHEST2
orgrimmar.nodes[34937546] = CHEST2
orgrimmar.nodes[35556927] = CHEST2
orgrimmar.nodes[35767889] = CHEST2
orgrimmar.nodes[37528493] = CHEST2
orgrimmar.nodes[39388038] = CHEST2

-- The Drag
orgrimmar.nodes[56915817] = Clone(CHEST2, {note=L["inside_building"]})
orgrimmar.nodes[57116273] = CHEST2
orgrimmar.nodes[57415604] = CHEST2
orgrimmar.nodes[57554961] = CHEST2
orgrimmar.nodes[60175638] = CHEST2
orgrimmar.nodes[60745806] = Clone(CHEST2, {note=L["inside_building"]})
orgrimmar.nodes[60985254] = CHEST2

-- Valley of Wisdom
orgrimmar.nodes[39474727] = CHEST3
orgrimmar.nodes[41224994] = CHEST3
orgrimmar.nodes[42064971] = CHEST3
orgrimmar.nodes[45195352] = CHEST3
orgrimmar.nodes[46895101] = CHEST3
orgrimmar.nodes[48474897] = CHEST3
orgrimmar.nodes[48874617] = CHEST3

-- Valley of Honor
orgrimmar.nodes[66283141] = CHEST3
orgrimmar.nodes[66763903] = CHEST3
orgrimmar.nodes[69164858] = CHEST3
orgrimmar.nodes[69384572] = CHEST3

-------------------------------------------------------------------------------

-- Valley of Strength
orgrimmar.nodes[48708380] = Crystal({note=L["c_behind_bank_counter"]})
orgrimmar.nodes[49406870] = Crystal({note=L["c_hidden_boxes"]})
orgrimmar.nodes[53508200] = Crystal({note=L["c_inside_hut"]})

-- Valley of Spirits
orgrimmar.nodes[33406570] = Crystal({note=L["c_center_building"]})
orgrimmar.nodes[35406940] = Crystal({note=L["c_top_building"]})
orgrimmar.nodes[37908450] = Crystal({note=L["c_behind_pillar"]})
orgrimmar.nodes[38508070] = Crystal({note=L["c_behind_boss"]})

-- The Drag
orgrimmar.nodes[57605860] = Crystal({note=L["c_inside_orphanage"]})
orgrimmar.nodes[57706510] = Crystal({note=L["c_inside_transmog"]})
orgrimmar.nodes[57904860] = Crystal({note=L["c_behind_boss"]})
orgrimmar.nodes[60405510] = Crystal({note=L["c_inside_leatherwork"]})

-- Valley of Wisdom
orgrimmar.nodes[38904990] = Crystal({note=L["c_inside_big_tent"]})
orgrimmar.nodes[41704480] = Crystal({note=L["c_inside_hut"]})
orgrimmar.nodes[48404410] = Crystal({note=L["c_on_small_hill"]})
orgrimmar.nodes[51004520] = Crystal({note=L["c_by_pillar_boxes"]})

-- Valley of Honor
orgrimmar.nodes[63903040] = Crystal({note=L["c_behind_rexxar"]})
orgrimmar.nodes[65805060] = Crystal({note=L["c_inside_cacti"]})
orgrimmar.nodes[67003740] = Crystal({note=L["c_inside_auction"]})
orgrimmar.nodes[68204290] = Crystal({note=L["c_underneath_bridge"]})

-------------------------------------------------------------------------------

orgrimmar.nodes[39304900] = MAIL
orgrimmar.nodes[39708030] = MAIL
orgrimmar.nodes[52707580] = MAIL
orgrimmar.nodes[60105130] = MAIL
orgrimmar.nodes[67673924] = MAIL

-------------------------------------------------------------------------------

orgrimmar.nodes[32106430] = Buff({
    icon=461119,
    label='{spell:313670}',
    note=L["spirit_of_wind_note"]..'\n\n'..L["buffs_change"]
}) -- Spirit of the Wind (Bwemba)

orgrimmar.nodes[44667697] = Buff({
    icon=133044,
    label='{spell:313770}',
    note=L["smiths_strength_note"]..'\n\n'..L["buffs_change"]
}) -- Smith's Strength (Naros)

orgrimmar.nodes[54277833] = Buff({
    icon=134991,
    label='{spell:313749}',
    note=L["heroes_bulwark_note"]..'\n\n'..L["buffs_change"]
}) -- Heroes' Bulwark (Gamon)

orgrimmar.nodes[57676513] = Buff({
    icon=1717106,
    label='{spell:313961}',
    note=L["ethereal_essence_note"]..'\n\n'..L["buffs_change"]
}) -- Ethereal Essence (Warpweaver Dushar)

-------------------------------------------------------------------------------

orgrimmar.nodes[54027044] = NPC({
    id=162358,
    icon=2823166,
    group=ns.groups.VISIONS_MISC,
    note=L["ethereal_note"]
}) -- Zarhaal

orgrimmar.nodes[46828078] = Node({
    icon=967522,
    group=ns.groups.VISIONS_MISC,
    label=L["colored_potion"],
    note=string.format(L["colored_potion_note"], '{npc:162324}')
})

orgrimmar.nodes[39906120] = Collectible({
    id=163441,
    icon=1001616,
    group=ns.groups.VISIONS_MISC,
    note=L["shave_kit_note"],
    rewards={
        Toy({item=174920}) -- Coifcurl's Close Shave Kit
    }
})

-------------------------------------------------------------------------------
---------------------------------- STORMWIND ----------------------------------
-------------------------------------------------------------------------------

-- Cathedral Square
stormwind.nodes[51955788] = CHEST1
stormwind.nodes[55085027] = CHEST1
stormwind.nodes[55845275] = CHEST1
stormwind.nodes[57034974] = CHEST1

-- Trade District
stormwind.nodes[61027547] = CHEST2
stormwind.nodes[61886605] = CHEST2
stormwind.nodes[63687447] = CHEST2
stormwind.nodes[66617039] = CHEST2

-- Dwarven District
stormwind.nodes[60573394] = CHEST2
stormwind.nodes[62522946] = CHEST2
stormwind.nodes[63424206] = CHEST2
stormwind.nodes[66223412] = CHEST2
stormwind.nodes[66694422] = CHEST2

-- Mage Quarter
stormwind.nodes[43018320] = CHEST3
stormwind.nodes[44658694] = CHEST3
stormwind.nodes[47478888] = CHEST3
stormwind.nodes[50169002] = CHEST3
stormwind.nodes[54048542] = CHEST3

-- Old Town
stormwind.nodes[72056202] = CHEST3
stormwind.nodes[73565625] = CHEST3
stormwind.nodes[75286476] = CHEST3
stormwind.nodes[76475374] = Clone(CHEST3, {note=L["inside_building"]})

-------------------------------------------------------------------------------

-- Cathedral Square
stormwind.nodes[53005190] = Crystal({note=L["c_left_cathedral"]})
stormwind.nodes[54605940] = Crystal({note=L["c_behind_boxes"]})
stormwind.nodes[58405510] = Crystal({note=L["c_on_small_hill"]})

-- Trade District
stormwind.nodes[60406880] = Crystal({note=L["c_alley_corner"]})
stormwind.nodes[62007690] = Crystal({note=L["c_behind_mailbox"]})
stormwind.nodes[66107570] = Crystal({note=L["c_behind_cart"]})
stormwind.nodes[69007310] = Crystal({note=L["c_left_inquisitor"]})

-- Dwarven District
stormwind.nodes[62703700] = Crystal({note=L["c_forge_corner"]})
stormwind.nodes[63404170] = Crystal()
stormwind.nodes[64603090] = Crystal({note=L["c_behind_boxes"]})
stormwind.nodes[67304470] = Crystal({note=L["c_forge_corner"]})

-- Mage Quarter
stormwind.nodes[44208790] = Crystal({note=L["c_walkway_corner"]})
stormwind.nodes[47408160] = Crystal({note=L["c_behind_house_counter"]})
stormwind.nodes[47708940] = Crystal({note=L["c_walkway_platform"]})
stormwind.nodes[52408340] = Crystal({note=L["c_behind_house_counter"]})

-- Old Town
stormwind.nodes[74605920] = Crystal({note=L["c_behind_boxes"]})
stormwind.nodes[75605340] = Crystal({note=L["c_bar_upper"]})
stormwind.nodes[75606460] = Crystal({note=L["c_behind_mailbox"]})
stormwind.nodes[76506850] = Crystal({note=L["c_behind_stables"]})

-------------------------------------------------------------------------------

stormwind.nodes[49688700] = MAIL
stormwind.nodes[54635751] = MAIL
stormwind.nodes[61687604] = MAIL
stormwind.nodes[62073082] = MAIL
stormwind.nodes[75716456] = MAIL

-------------------------------------------------------------------------------

stormwind.nodes[58404919] = Buff({
    icon=132183,
    label='{spell:312355}',
    note=L["bear_spirit_note"]..'\n\n'..L["buffs_change"]
}) -- Bear Spirit (Angry Bear Rug Spirit)

stormwind.nodes[53545906] = Buff({
    icon=1621334,
    label='{spell:314203}',
    note=L["requited_bulwark_note"]..'\n\n'..L["buffs_change"]
}) -- Requited Bulwark (Agustus Moulaine)

stormwind.nodes[59553713] = Buff({
    icon=133035,
    label='{spell:314165}',
    note=L["empowered_note"]..'\n\n'..L["buffs_change"]
}) -- Empowered (Experimental Buff Mine)

stormwind.nodes[63107740] = Buff({
    icon=133784,
    label='{spell:314087}',
    note=L["enriched_note"]..'\n\n'..L["buffs_change"]
}) -- Enriched (Neglected Guild Bank)

-------------------------------------------------------------------------------

stormwind.nodes[57204620] = NPC({
    id=162358,
    icon=2823166,
    group=ns.groups.VISIONS_MISC,
    note=L["ethereal_note"]
}) -- Zarhaal

stormwind.nodes[51765852] = Node({
    icon=967522,
    group=ns.groups.VISIONS_MISC,
    label=L["colored_potion"],
    note=string.format(L["colored_potion_note"], '{npc:162231}')
})

stormwind.nodes[58905290] = Collectible({
    icon=237272,
    group=ns.groups.VISIONS_MISC,
    label='{item:174921}',
    note=L["void_skull_note"],
    rewards={
        Toy({item=174921}) -- Void-Touched Skull
    }
})

stormwind.nodes[59106390] = Rare({
    id=158284,
    group=ns.groups.VISIONS_MISC,
    note=L["craggle"],
    pois={
        Path({
            58707630, 57507290, 56406950, 56706670, 59106390, 62306130,
            64706190, 67006490, 68406710
        })
    },
    rewards={
        Toy({item=174926}) -- Overly Sensitive Void Spectacles
    }
}) -- Craggle Wobbletop
