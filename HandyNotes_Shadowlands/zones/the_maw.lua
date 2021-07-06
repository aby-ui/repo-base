-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local Class = ns.Class
local L = ns.locale
local Map = ns.RiftMap

local NPC = ns.node.NPC
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Quest = ns.reward.Quest
local Section = ns.reward.Section
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Arrow = ns.poi.Arrow
local Line = ns.poi.Line
local Path = ns.poi.Path
local POI = ns.poi.POI

-- local KYRIAN = ns.covenants.KYR
local NECROLORD = ns.covenants.NEC
local NIGHTFAE = ns.covenants.FAE
local VENTHYR = ns.covenants.VEN

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local map = Map({ id=1543, phased=false, settings=true })

function map:Prepare ()
    Map.Prepare(self)
    self.phased = C_QuestLog.IsQuestFlaggedCompleted(62907)
end

function map:CanDisplay(node, coord, minimap)
    local covenant = node.assault or node.noassault
    if covenant then
        local quest = covenant.assault
        local active = C_TaskQuest.GetQuestTimeLeftMinutes(quest) or C_QuestLog.IsQuestFlaggedCompleted(quest)
        if node.assault and not active then return false end
        if node.noassault and active then return false end
    end
    return Map.CanDisplay(self, node, coord, minimap)
end

local ext = Map({id=1822}) -- Extractor's Sanatorium
local pitu = Map({id=1820}) -- Pit of Anguish (upper)
local pitl = Map({id=1821}) -- Pit of Anguish (lower)

-------------------------------------------------------------------------------
------------------------------------ INTRO ------------------------------------
-------------------------------------------------------------------------------

local MawIntro = Class('MawIntro', ns.node.Intro, {
    quest=62907, -- Eye of the Jailor activation
    label=L['return_to_the_maw'],
    note=L["maw_intro_note"]
})

map.intro = MawIntro({
    rewards={
        Quest({id={
            62882, -- Setting the Ground Rules
            60287  -- Rule 1: Have an Escape Plan
        }})
    }
})

map.nodes[80306280] = map.intro

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[25923116] = Rare({
    id=157964,
    quest=57482,
    noassault=NIGHTFAE,
    note=L["dekaris_note"],
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49841})
    }
}) -- Adjutant Dekaris

map.nodes[19324172] = Rare({
    id=170301,
    quest=60788,
    noassault=NIGHTFAE,
    note=L["apholeias_note"],
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49842}),
        Item({item=184106, note=L["ring"]}), -- Gimble
        Item({item=182327}) -- Dominion Etching: Loss
    }
}) -- Apholeias, Herald of Loss

map.nodes[39014119] = Rare({
    id=157833,
    quest=57469,
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49843}),
        Toy({item=184312}) -- Borr-Geth's Fiery Brimstone
    }
}) -- Borr-Geth

map.nodes[27731305] = Rare({
    id=171317,
    quest=61106,
    noassault=VENTHYR,
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49844}),
        Transmog({item=183887, slot=L["1h_sword"]}) -- Suirhtaned, Blade of the Heir
    }
}) -- Conjured Death

map.nodes[60964805] = Rare({
    id=160770,
    quest=62281,
    note=L["in_cave"],
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49845})
    }
}) -- Darithis the Bleak

map.nodes[49128175] = Rare({
    id=158025,
    quest=62282,
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49846})
    }
}) -- Darklord Taraxis

map.nodes[61334129] = Rare({
    id=179779,
    quest=64251,
    note=L["deomen_note"],
    rewards={
        Achievement({id=15107, criteria=52286}),
        Transmog({item=187385, slot=L["mail"]}), -- Vortex Piercing Headgear
        Transmog({item=187367, slot=L["1h_sword"]}) -- Deomen's Vortex Blade
    },
    pois={
        POI({63274368}) -- Entrance
    }
}) -- Deomen the Vortex

map.nodes[28086058] = Rare({
    id=170711,
    quest=60909,
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49847})
    }
}) -- Dolos <Death's Knife>

map.nodes[23765341] = Rare({
    id=170774,
    quest=60915,
    noassault=NIGHTFAE,
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49848})
    }
}) -- Eketra <The Impaler>

map.nodes[42342108] = Rare({
    id=169827,
    quest=60666,
    note=L["ekphoras_note"],
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49849}),
        Item({item=184105, note=L["ring"]}), -- Gyre
        Item({item=182328}) -- Dominion Etching: Grief
    }
}) -- Ekphoras, Herald of Grief

map.nodes[19194608] = Rare({ -- was 27584966
    id=154330,
    quest=57509,
    noassault=NIGHTFAE,
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49850}),
        Pet({item=183407, id=3037}) -- Contained Essence of Dread
    }
}) -- Eternas the Tormentor

map.nodes[20586935] = Rare({
    id=170303,
    quest=62260,
    note=L["exos_note"],
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    fgroup='nilganihmaht_group',
    rewards={
        Achievement({id=14744, criteria=49851}),
        Item({item=184108, note=L["neck"]}), -- Vorpal Amulet
        Item({item=186606}), -- Nilganihmaht's Signet Ring
        Item({item=183066, quest=63160}), -- Korrath's Grimoire: Aleketh
        Item({item=183067, quest=63161}), -- Korrath's Grimoire: Belidir
        Item({item=183068, quest=63162})  -- Korrath's Grimoire: Gyadrek
    }
}) -- Exos, Herald of Domination

map.nodes[17714953] = Rare({
    id=179460,
    quest=64164,
    note=L["fallen_charger_note"],
    rewards={
        Achievement({id=15107, criteria=52292}),
        Mount({item=186659, id=1502}) -- Fallen Charger's Reins
    },
    pois={
        Path({
            17634964, 18664848, 19304835, 21454430, 21494174, 19653921,
            20443739, 21323733, 21753274, 22253118, 23372919, 24132564,
            28121544, 29001472, 29661549, 31481794, 32701772, 33421815,
            34251984, 33622231, 33892464, 36022835, 37193420, 38523504,
            39633701, 40253850, 41854015, 43304062, 43734185, 43244328,
            41604622, 42324843, 44665185, 46585842, 46975919, 47396092,
            49426189, 50646292, 55376234, 57476329, 59606368, 59516552,
            60026614, 60816599, 62036656, 62526765, 62526928, 61917015,
            61867018, 60847219, 60827402, 63387519, 64177649
        }),
        Path({
            17634964, 18664848, 19304835, 21494366, 25543659,
            31283745, 32144455, 36304799, 34295466, 36736413,
            44056349, 45347403, 48928415, 55528687
        })
    }
}) -- Fallen Charger

map.nodes[30775000] = Rare({
    id=175012,
    quest=62788,
    note=L["ikras_note"],
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=50621})
    }
}) -- Ikras the Devourer

map.nodes[16945102] = Rare({
    id=162849,
    quest=60987,
    noassault=NIGHTFAE,
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49852}),
        Toy({item=184292}) -- Ancient Elethium Coin
    }
}) -- Morguliax <Lord of Decapitation>

map.nodes[45507376] = Rare({
    id=158278,
    quest=57573,
    note=L["in_small_cave"],
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49853})
    }
}) -- Nascent Devourer

map.nodes[48801830] = Rare({
    id=164064,
    quest=60667,
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49854})
    }
}) -- Obolos <Prime Adjutant>

map.nodes[23692139] = Rare({
    id=172577,
    quest=61519,
    note=L["orophea_note"],
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49855}),
        Toy({item=181794}) -- Orophea's Lyre
    },
    pois={
        POI({26772932}) -- Eurydea's Amulet
    }
}) -- Orophea

map.nodes[32946646] = Rare({
    id=170634,
    quest=60884,
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49856}),
        Item({item=183066, quest=63160}), -- Korrath's Grimoire: Aleketh
        Item({item=183067, quest=63161}), -- Korrath's Grimoire: Belidir
        Item({item=183068, quest=63162})  -- Korrath's Grimoire: Gyadrek
    }
}) -- Shadeweaver Zeris

map.nodes[35974156] = Rare({
    id=166398,
    quest=60834,
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49857})
    }
}) -- Soulforger Rhovus

map.nodes[28701204] = Rare({
    id=170302,
    quest=60789, -- 62722?
    note=L["talaporas_note"],
    noassault=VENTHYR,
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49858}),
        Transmog({item=184107, slot=L["cloak"]}), -- Borogove Cloak
        Item({item=182326}) -- Dominion Etching: Pain
    }
}) -- Talaporas, Herald of Pain

map.nodes[27397152] = Rare({
    id=170731,
    quest=60914,
    rlabel=ns.status.LightBlue('+100 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49859})
    }
}) -- Thanassos <Death's Voice>

map.nodes[69044897] = Rare({
    id=179805,
    quest=64258, -- 64439?
    rewards={
        Achievement({id=15107, criteria=52289}),
        Transmog({item=187374, slot=L["cloth"]}) -- Balthier's Waistcord (no drop on live)
    }
}) -- Traitor Balthier

map.nodes[37446212] = Rare({
    id=172862,
    quest=61568,
    note=L["yero_note"],
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49860})
    },
    pois={
        Path({
            37976153, 38786073, 39155953, 38795855, 37925852, 37375934,
            37346068, 37446212
        })
    }
}) -- Yero the Skittish

map.nodes[66404400] = Rare({
    id=177444,
    quest=64152,
    fgroup='nilganihmaht_group',
    rewards={
        Achievement({id=15107, criteria=52287}),
        Achievement({id=14943, criteria=51681}),
        Transmog({item=187359, slot=L["shield"]}), -- Ylva's Water Dish
        Transmog({item=186217, slot=L["leather"]}), -- Supple Helhound Leather Pants
        Transmog({item=187393, slot=L["plate"]}), -- Sterling Hound-Handler's Gauntlets
        Item({item=186970, quest=62683, note="{item:186727}"}) -- Feeder's Hand and Key / Seal Breaker Key
    }
}) -- Ylva, Mate of Guarm

-------------------------------------------------------------------------------

map.nodes[34564206] = Rare({
    id=179853,
    quest=64276,
    rlabel=ns.GetIconLink('portal_gy', 20, 4, 1),
    note=L["rift_rare_only_note"],
    rift=2,
    rewards={
        Achievement({id=15107, criteria=52297}),
        Item({item=187406, note=L["ring"]}) -- Band of Blinding Shadows
    }
}) -- Blinding Shadow

map.nodes[49307274] = Rare({
    id=179851,
    quest=64272,
    rlabel=ns.GetIconLink('portal_gy', 20, 4, 1),
    note=L["rift_rare_only_note"],
    rewards={
        Achievement({id=15107, criteria=52293}),
        Transmog({item=187398, slot=L["leather"]}) -- Chestguard of the Shadeguard
    },
    rift=2,
    pois={
        Path({
            49307274, 49497182, 49587131, 49667100, 49777062, 49907029,
            50206988, 50506945, 50686900, 50856866, 51076832, 51336810,
            51536800, 51756789, 51986776, 52366778, 52616791, 52936806,
            53176811, 53396846, 53626889, 53886923, 54266978, 54297040,
            54287097, 54077141, 53757172, 53447210, 53277241, 53047280,
            52747323, 52477358, 52207388, 51817431, 51527461, 51287494,
            51047546, 50777520, 50547510, 50277500, 50027471, 49867442,
            49717414, 49497367, 49307274
        })
    }
}) -- Guard Orguluus

map.nodes[27672526] = Rare({
    id=179735,
    quest=64232,
    rlabel=ns.GetIconLink('portal_gy', 20, 4, 1),
    note=L["rift_rare_only_note"],
    fgroup='nilganihmaht_group',
    rift=2,
    rewards={
        Achievement({id=15107, criteria=52284}),
        Item({item=186605}), -- Nilganihmaht's Runed Band
        Transmog({item=187360, slot=L["offhand"]}), -- Orb of Enveloping Rifts
        Toy({item=187139}) -- Bottled Shade Heart
    }
}) -- Torglluun

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[69214521] = Treasure({
    quest=64256,
    rewards={
        Achievement({id=15099, criteria=52243}),
        Transmog({item=187018, slot=L["cosmetic"]}) -- Ritualist's Shoulder Scythes
    }
}) -- Helsworn Chest

map.nodes[66526129] = Treasure({
    quest=64261,
    note=L["in_cave"],
    rewards={
        Achievement({id=15099, criteria=52244}),
        Item({item=187352, note=L["neck"]}) -- Jeweled Heart of Ezekiel
    }
}) -- Jeweled Heart

map.nodes[32215608] = Treasure({
    quest=64010,
    label='{item:186183}',
    note=L['lilabom_note'],
    rewards={
        Item({item=186183}), -- Lil'Abom Head
        Pet({item=186188, id=3098}) -- Lil'Abom
    }
}) -- Lil'Abom Head

map.nodes[39906260] = Treasure({
    quest=64011,
    label='{item:186184}',
    note=L['lilabom_note'],
    rewards={
        Item({item=186184}), -- Lil'Abom Torso
        Pet({item=186188, id=3098}) -- Lil'Abom
    }
}) -- Lil'Abom Torso

map.nodes[29376732] = Treasure({
    quest=64013,
    label='{item:186185}',
    note=L['lilabom_note'],
    rewards={
        Item({item=186185}), -- Lil'Abom Legs
        Pet({item=186188, id=3098}) -- Lil'Abom
    }
}) -- Lil'Abom Legs

map.nodes[38505850] = Treasure({
    quest=64008,
    label='{item:186186}',
    note=L['lilabom_note'],
    rewards={
        Item({item=186186}), -- Lil'Abom Right Hand
        Pet({item=186188, id=3098}) -- Lil'Abom
    }
}) -- Lil'Abom Right Hand

map.nodes[39286648] = Treasure({
    quest=64009,
    label='{item:186187}',
    note=L['lilabom_note'],
    rewards={
        Item({item=186187}), -- Lil'Abom Spare Arm
        Pet({item=186188, id=3098}) -- Lil'Abom
    }
}) -- Lil'Abom Spare Arm

ext.nodes[62263305] = Treasure({
    quest=64575,
    label=L["hidden_anima_cache"],
    rift=1,
    parent=map.id
}) -- Hidden Anima Cache

-------------------------------------------------------------------------------
---------------------------- BONUS OBJECTIVE BOSSES ---------------------------
-------------------------------------------------------------------------------

local BonusBoss = Class('BonusBoss', NPC, {
    icon = 'peg_rd',
    scale = 1.8,
    group = ns.groups.BONUS_BOSS,
    rlabel = ns.status.LightBlue('+40 '..L["rep"])
})

map.nodes[28204450] = BonusBoss({
    id=169102,
    quest=61136, -- 63380
    rewards={
        Achievement({id=14660, criteria=49485})
    }
}) -- Agonix

map.nodes[34087453] = BonusBoss({
    id=170787,
    quest=60920,
    rewards={
        Achievement({id=14660, criteria=49487})
    }
}) -- Akros <Death's Hammer>

map.nodes[28712513] = BonusBoss({
    id=168693,
    quest=61346,
    rewards={
        Achievement({id=14660, criteria=49484}),
        Item({item=183070, quest=63164}) -- Mawsworn Orders
    }
}) -- Cyrixia <The Willbreaker>

map.nodes[25831479] = BonusBoss({
    id=162452,
    quest=59230,
    rewards={
        Achievement({id=14660, criteria=49476})
    }
}) -- Dartanos <Flayer of Souls>

map.nodes[19205740] = BonusBoss({
    id=162844,
    quest=61140,
    noassault=NIGHTFAE,
    rewards={
        Achievement({id=14660, criteria=50410}),
        Item({item=183066, quest=63160}), -- Korrath's Grimoire: Aleketh
        Item({item=183067, quest=63161}), -- Korrath's Grimoire: Belidir
        Item({item=183068, quest=63162}) -- Korrath's Grimoire: Gyadrek
    }
}) -- Dath Rezara <Lord of Blades>

map.nodes[31982122] = BonusBoss({
    id=158314,
    quest=59183,
    note=L["drifting_sorrow_note"],
    rewards={
        Achievement({id=14660, criteria=49475})
    }
}) -- Drifting Sorrow

map.nodes[60456478] = BonusBoss({
    id=172523,
    quest=62209,
    rewards={
        Achievement({id=14660, criteria=49490})
    }
}) -- Houndmaster Vasanok

map.nodes[20782968] = BonusBoss({
    id=162965,
    quest=58918,
    noassault=NIGHTFAE,
    rewards={
        Achievement({id=14660, criteria=49481})
    }
}) -- Huwerath

map.nodes[30846866] = BonusBoss({
    id=170692,
    quest=63381,
    rewards={
        Achievement({id=14660, criteria=49486})
    }
}) -- Krala <Death's Wings>

map.nodes[27311754] = BonusBoss({
    id=171316,
    quest=61125,
    rewards={
        Achievement({id=14660, criteria=49488})
    }
}) -- Malevolent Stygia

map.nodes[38642880] = BonusBoss({
    id=172207,
    quest=62618,
    rewards={
        Achievement({id=14660, criteria=50408}),
        Achievement({id=14761, criteria=49909}),
        Item({item=183061, quest=63158}) -- Wailing Coin
    }
}) -- Odalrik

map.nodes[25364875] = BonusBoss({
    id=162845,
    quest=60991,
    rewards={
        Achievement({id=14660, criteria=49480})
    }
}) -- Orrholyn <Lord of Bloodletting>

map.nodes[22674223] = BonusBoss({
    id=175821,
    quest=63044, -- 63388 ??
    noassault=NIGHTFAE,
    note=L["in_cave"],
    rewards={
        Achievement({id=14660, criteria=51058})
    },
    pois={
        POI({20813927}) -- Cave entrance
    }
}) -- Ratgusher

map.nodes[26173744] = BonusBoss({
    id=162829,
    quest=60992,
    rewards={
        Achievement({id=14660, criteria=49479})
    }
}) -- Razkazzar <Lord of Axes>

map.nodes[55626318] = BonusBoss({
    id=172521,
    quest=62210,
    note=L["in_cave"]..' '..L["sanngror_note"],
    rewards={
        Achievement({id=14660, criteria=49489}),
        Pet({item=183410, id=3040}) -- Sharpclaw
    },
    pois={
        POI({55806753}) -- Cave entrance
    }
}) -- Sanngror the Torturer

pitu.nodes[41767921] = BonusBoss({
    id=172524,
    quest=62211,
    note=L["nexus_cave_anguish_upper"],
    rewards={
        Achievement({id=14660, criteria=49491})
    },
    parent=map.id
}) -- Skittering Broodmother

map.nodes[36253744] = BonusBoss({
    id=165047,
    quest=59441,
    rewards={
        Achievement({id=14660, criteria=49482})
    }
}) -- Soulsmith Yol-Mattar

map.nodes[36844480] = BonusBoss({
    id=156203,
    quest=62539,
    rewards={
        Achievement({id=14660, criteria=50409})
    }
}) -- Stygian Incinerator

map.nodes[40705959] = BonusBoss({
    id=173086,
    quest=61728,
    note=L["valis_note"],
    rewards={
        Achievement({id=14660, criteria=49492})
    }
}) -- Valis the Cruel

-------------------------------------------------------------------------------
------------------------------ CHAOTIC RIFTSTONES -----------------------------
-------------------------------------------------------------------------------

local Riftstone = Class('Riftstone', ns.node.NPC, {
    id=174962,
    scale=1.3,
    group=ns.groups.RIFTSTONE,
    requires=ns.requirement.Venari(63177),
    note=L["chaotic_riftstone_note"]
})

-------------------------------------------------------------------------------

map.nodes[19184778] = Riftstone({
    icon='portal_rd',
    fgroup='riftstone1',
    pois={Line({19184778, 25211784})}
})

map.nodes[25211784] = Riftstone({
    icon='portal_rd',
    fgroup='riftstone1'
})

-------------------------------------------------------------------------------

map.nodes[23433121] = Riftstone({
    icon='portal_bl',
    fgroup='riftstone2',
    pois={Line({23433121, 34804362})}
})

map.nodes[34804362] = Riftstone({
    icon='portal_bl',
    fgroup='riftstone2'
})

-------------------------------------------------------------------------------

map.nodes[19776617] = Riftstone({
    icon='portal_pp',
    pois={Arrow({19776617, 34794350})}
})

-------------------------------------------------------------------------------

map.nodes[48284145] = NPC({
    group=ns.groups.RIFTSTONE,
    icon='portal_bl',
    id=172925,
    minimap=false,
    note=L["animaflow_teleporter_note"],
    requires=ns.requirement.Venari(61600),
    scale=1.3,
    pois={
        Arrow({48284145, 34181473}), -- The Tremaculum
        Arrow({48284145, 53426364}) -- The Beastwarrens
    }
})

-------------------------------------------------------------------------------
---------------------------------- GRAPPLES -----------------------------------
-------------------------------------------------------------------------------

local GRAPPLES = {
    17574994, 20753838, 20764394, 21553194, 22014819, 22174389, 22475485,
    22534798, 22942220, 23034411, 24542916, 24833046, 25633108, 26132722,
    26342905, 26541861, 26952753, 27202506, 27362593, 28161347, 28634916,
    29561776, 29661285, 29863694, 29951784, 30033617, 30132835, 30582337,
    30591312, 30942597, 31221584, 31351499, 32194490, 32674369, 32904238,
    33102066, 33374532, 33584024, 34074701, 34463889, 34624440, 36244139,
    36264642, 37844512, 40334904, 41184945, 41304785, 42264174,
    -- Perdition Hold
    20506783, 22167106, 22237079, 22956723, 23017146, 23076836, 23676572,
    23717533, 24866552, 25456554, 26116811, 26306726, 27896168, 30756551,
    31316530, 31655664, 32056840, 32426772, 33286365, 33295928, 33767056,
    34237005, 35006680,
    -- Beast Warrens
    44996655, 47608194, 48397060, 49377318, 49997460, 50027306, 51427820,
    52177614, 52247887, 52957021, 53157840, 53266871, 53726760, 53917700,
    54486713, 54987622, 55247788
}

for _, coord in ipairs(GRAPPLES) do
    map.nodes[coord] = NPC({
        group=ns.groups.GRAPPLES,
        icon='peg_bk',
        id=176308,
        requires=ns.requirement.Venari(63217),
        scale=1.25,
    })
end

-------------------------------------------------------------------------------
---------------------------------- MAW LORE -----------------------------------
-------------------------------------------------------------------------------

local Lore = Class('MawLore', Treasure, {
    group=ns.groups.MAW_LORE,
    rlabel=ns.status.LightBlue('+150 '..L["rep"]),
    IsCompleted=function(self)
        if C_QuestLog.IsOnQuest(self.quest[1]) then return true end
        return Treasure.IsCompleted(self)
    end
})

ext.nodes[73121659] = Lore({
    quest=63157,
    note=L["box_of_torments_note"],
    parent={ id=map.id, pois={POI({27702020})} },
    rewards={
        Achievement({id=14761, criteria=49908}),
        Item({item=183060, quest=63157})
    }
}) -- Box of Torments

-- Shadehound Armor Plating ??

map.nodes[35764553] = Lore({
    quest=63163,
    note=L["tormentors_notes_note"],
    rewards={
        Achievement({id=14761, criteria=49914}),
        Item({item=183069, quest=63163})
    }
}) -- Tormentor's Notes

map.nodes[19363340] = Lore({
    quest=63159,
    note=L["words_of_warden_note"],
    rewards={
        Achievement({id=14761, criteria=49910}),
        Item({item=183063, quest=63159})
    }
}) -- Words of the Warden

-------------------------------------------------------------------------------
------------------------------- STYGIAN CACHES --------------------------------
-------------------------------------------------------------------------------

local Cache = Class('Cache', ns.node.Node, {
    group=ns.groups.STYGIAN_CACHES,
    icon='chest_nv',
    label=L["stygian_cache"],
    note=L["stygian_cache_note"],
    scale=1.3,
    rewards={
        ns.reward.Currency({id=1767, note='48'})
    }
})

map.nodes[15705050] = Cache()
map.nodes[19203310] = Cache()
map.nodes[19704460] = Cache()
map.nodes[19705500] = Cache()
map.nodes[24301660] = Cache()
map.nodes[25603660] = Cache()
map.nodes[26602920] = Cache()
map.nodes[27604570] = Cache()
map.nodes[27607180] = Cache()
map.nodes[28402550] = Cache()
map.nodes[29621283] = Cache()
map.nodes[34306190] = Cache()
map.nodes[35201630] = Cache()
map.nodes[35902360] = Cache()
map.nodes[39802510] = Cache()
map.nodes[40306160] = Cache()
map.nodes[44301870] = Cache()
map.nodes[44804830] = Cache()
map.nodes[45204740] = Cache()
map.nodes[47407630] = Cache()
map.nodes[50808390] = Cache()
map.nodes[56196307] = Cache({
    note=L["in_cave"],
    pois={
        POI({55806753}) -- Cave entrance
    }
})
map.nodes[61505080] = Cache()
pitl.nodes[46896760] = Cache({parent=map.id})

-------------------------------------------------------------------------------
--------------------------------- STYGIA NEXUS --------------------------------
-------------------------------------------------------------------------------

-- local STYGIA_NEXUS = {
--     17005000, 19003400, 21003900, 23007000, 24006800, 25006800, 28004500,
--     29006500, 30002800, 36004200, 38001900, 44005800, 45006600, 45006700,
--     52006700, 52006800, 53006600, 57006000
-- }

local Nexus = Class('StygiaNexus', NPC, {
    group=ns.groups.STYGIA_NEXUS,
    icon='peg_gn',
    id=177632,
    requires=ns.requirement.Item(184870),
    scale=1.25,
    rift=2 -- can see in both phases
})

map.nodes[16015170] = Nexus({note=L["nexus_npc_portal"]})
map.nodes[16875503] = Nexus({note=L["nexus_area_gorgoa_mouth"]})
map.nodes[17745311] = Nexus({note=L["nexus_area_gorgoa_mouth"]})
map.nodes[18285458] = Nexus({note=L["nexus_area_gorgoa_mouth"]})
map.nodes[19206731] = Nexus({note=L["nexus_area_domination_edge"]})
map.nodes[19433790] = Nexus({note=L["nexus_area_calcis_crystals"]})
map.nodes[19643533] = Nexus({note=L["nexus_area_calcis_crystals"]})
map.nodes[21366560] = Nexus({note=L["nexus_area_domination_room"]})
map.nodes[21403189] = Nexus({note=L["nexus_area_calcis_branch"]})
map.nodes[21656684] = Nexus({note=L["nexus_area_domination_edge"]})
map.nodes[21717193] = Nexus({note=L["nexus_area_domination_stairs"]})
map.nodes[25252558] = Nexus({note=L["nexus_area_cradle_bridge"]})
map.nodes[22515477] = Nexus({note=L["nexus_misc_grapple_rock"]})
map.nodes[22922234] = Nexus({note=L["nexus_misc_grapple_rock"]})
map.nodes[22926805] = Nexus({note=L["nexus_misc_grapple_ramparts"]})
map.nodes[23044444] = Nexus({note=L["nexus_misc_grapple_ramparts"]})
map.nodes[23252132] = Nexus({note=L["nexus_npc_orophea"]})
map.nodes[23277382] = Nexus({note=L["nexus_area_domination_bridge"]})
map.nodes[23493460] = Nexus({note=L["nexus_area_calcis_crystals"]})
map.nodes[23776535] = Nexus({note=L["nexus_misc_grapple_ramparts"]})
map.nodes[24131667] = Nexus({note=L["nexus_npc_willbreaker"]})
map.nodes[24154277] = Nexus({note=L["nexus_area_gorgoa_bank"]})
map.nodes[24394690] = Nexus({note=L["nexus_area_gorgoa_bank"]})
map.nodes[24703005] = Nexus({note=L["nexus_misc_grapple_rock"]})
map.nodes[25016582] = Nexus({note=L["nexus_misc_below_ramparts"]})
map.nodes[25156553] = Nexus({note=L["nexus_misc_grapple_ramparts"]})
map.nodes[25255011] = Nexus({note=L["nexus_npc_orrholyn"]})
map.nodes[25623699] = Nexus({note=L["nexus_cave_forlorn"]})
map.nodes[26004499] = Nexus({note=L["nexus_misc_crystal_ledge"]})
map.nodes[26153094] = Nexus({note=L["nexus_npc_dekaris"]})
map.nodes[26336859] = Nexus({note=L["nexus_misc_grapple_ramparts"]})
map.nodes[26842748] = Nexus({note=L["nexus_misc_grapple_rock"]})
map.nodes[27392598] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[27427226] = Nexus({note=L["nexus_npc_thanassos"]})
map.nodes[27541273] = Nexus({note=L["nexus_npc_talaporas"]})
map.nodes[27906041] = Nexus({note=L["nexus_npc_dolos"]})
map.nodes[28573090] = Nexus({note=L["nexus_area_torment_rock"]})
map.nodes[28674931] = Nexus({note=L["nexus_misc_grapple_rock"]})
map.nodes[32266739] = Nexus({note=L["nexus_misc_grapple_ramparts"]})
map.nodes[32506541] = Nexus({note=L["nexus_room_ramparts"]})
map.nodes[33064239] = Nexus({note=L["nexus_area_zovaal_wall"]})
map.nodes[33156479] = Nexus({note=L["nexus_area_perdition_wall"]})
map.nodes[33647481] = Nexus({note=L["nexus_npc_akros"]})
map.nodes[33977033] = Nexus({note=L["nexus_misc_grapple_ramparts"]})
map.nodes[34076193] = Nexus({note=L["nexus_room_ramparts"]})
map.nodes[35446747] = Nexus({note=L["nexus_misc_grapple_ramparts"]})
map.nodes[37504334] = Nexus({note=L["nexus_npc_incinerator"]})
map.nodes[37544368] = Nexus({note=L["nexus_npc_incinerator"]})
map.nodes[37814484] = Nexus({note=L["nexus_area_zovaal_edge"]})
map.nodes[39462356] = Nexus({note=L["nexus_area_gorgoa_middle"]})
map.nodes[40444906] = Nexus({note=L["nexus_misc_grapple_rock"]})
map.nodes[41234967] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[41314784] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[42412320] = Nexus({note=L["nexus_npc_ekphoras"]})
map.nodes[43816887] = Nexus({note=L["nexus_area_zone_edge"]})
map.nodes[47166238] = Nexus({note=L["nexus_road_below"]})
map.nodes[48078370] = Nexus({note=L["nexus_cave_howl_outside"]})
map.nodes[48327061] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[49917471] = Nexus({note=L["nexus_misc_grapple_rock"]})
map.nodes[50047306] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[50958572] = Nexus({note=L["nexus_cave_howl"]})
map.nodes[51467820] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[51488386] = Nexus({note=L["nexus_cave_howl"]})
map.nodes[51627864] = Nexus({note=L["nexus_misc_three_chains"]})
map.nodes[51907098] = Nexus({note=L["nexus_cave_ledge"]})
map.nodes[52018189] = Nexus({note=L["nexus_misc_ledge_below"]})
map.nodes[52167619] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[53167848] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[53338024] = Nexus({note=L["nexus_cave_anguish_outside"]})
map.nodes[53877701] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[53975865] = Nexus({note=L["nexus_road_cave"]})
map.nodes[54328482] = Nexus({note=L["nexus_road_mawrats"]})
map.nodes[54556720] = Nexus({note=L["nexus_misc_floating_cage"]})
map.nodes[54967623] = Nexus({note=L["nexus_misc_grapple_rock"]})
map.nodes[55026349] = Nexus({note=L["nexus_cave_torturer"]})
map.nodes[55527722] = Nexus({note=L["nexus_cave_prodigum"]})
map.nodes[56677080] = Nexus({note=L["nexus_cave_soulstained"]})
map.nodes[58435196] = Nexus({note=L["nexus_cave_echoing_outside"]})
map.nodes[59007837] = Nexus({note=L["nexus_road_next"]})
map.nodes[59056108] = Nexus({note=L["nexus_cave_desmotaeron"]})
map.nodes[60866755] = Nexus({note=L["nexus_road_next"]})
map.nodes[60927687] = Nexus({note=L["nexus_area_zone_edge"]})

pitu.nodes[53376624] = Nexus({note=L["nexus_cave_anguish_upper"], parent=map.id})
pitu.nodes[66355542] = Nexus({note=L["nexus_cave_anguish_upper"], parent=map.id})
pitl.nodes[45526802] = Nexus({note=L["nexus_cave_anguish_lower"], parent=map.id})
pitl.nodes[67185536] = Nexus({note=L["nexus_cave_anguish_lower"], parent=map.id})

-------------------------------------------------------------------------------
-------------------------------- ANIMA VESSELS --------------------------------
-------------------------------------------------------------------------------

local Vessel = Class('AnimaVessel', Treasure, {
    label=L["stolen_anima_vessel"],
    group=ns.groups.ANIMA_VESSEL,
    rewards={
        ns.relics.relic_fragment
    }
})

-- In the rift
local VESSEL1 = Vessel({icon='chest_rd', fgroup='vessel1', quest=64265, rift=1}) -- object=369227
local VESSEL2 = Vessel({icon='chest_bl', fgroup='vessel2', quest=64269, rift=1}) -- object=369235
local VESSEL3 = Vessel({icon='chest_yw', fgroup='vessel3', quest=64270, rift=1}) -- object=369236
-- Night Fae assault
local VESSEL4 = Vessel({icon='chest_rd', fgroup='vessel4', quest=nil, assault=NIGHTFAE}) -- object=368952
local VESSEL5 = Vessel({icon='chest_bl', fgroup='vessel5', quest=nil, assault=NIGHTFAE}) -- object=368953
-- Venthyr assault
local VESSEL6 = Vessel({icon='chest_rd', fgroup='vessel6', quest=64055, assault=VENTHYR}) -- object=368948
local VESSEL7 = Vessel({icon='chest_bl', fgroup='vessel7', quest=64056, assault=VENTHYR}) -- object=368949

-- In the rift
map.nodes[47437620] = ns.Clone(VESSEL1, {note=L["in_cave"]})
map.nodes[47798651] = ns.Clone(VESSEL1, {note=L["nexus_cave_roar"]})
map.nodes[51008544] = ns.Clone(VESSEL1, {note=L["nexus_cave_howl"]})
map.nodes[32404309] = VESSEL2
map.nodes[35704620] = VESSEL2
map.nodes[36264215] = VESSEL2
map.nodes[38474846] = ns.Clone(VESSEL2, {note=L["in_cave"]})
map.nodes[44554761] = VESSEL2
map.nodes[27464950] = VESSEL3
-- Night Fae assault
map.nodes[25303330] = VESSEL4
map.nodes[25303820] = VESSEL4
map.nodes[27804180] = VESSEL4
map.nodes[17304780] = VESSEL5
map.nodes[18604260] = VESSEL5
map.nodes[18905030] = VESSEL5
map.nodes[22704850] = VESSEL5
-- Venthyr Assault
map.nodes[23431665] = VESSEL6
map.nodes[25201250] = VESSEL6
map.nodes[27401650] = VESSEL6
map.nodes[27801950] = VESSEL6
map.nodes[26201960] = VESSEL7
map.nodes[29601160] = VESSEL7
map.nodes[32701480] = VESSEL7
ext.nodes[73685062] = ns.Clone(VESSEL7, {parent=map.id})

-- Zovaal's Vault 47257968
-- Zovaal's Vault 62176427

-------------------------------------------------------------------------------
----------------------------- RIFT HIDDEN CACHES ------------------------------
-------------------------------------------------------------------------------

local RiftCache = Class('RiftCache', Treasure, {
    label=L["rift_hidden_cache"],
    group=ns.groups.RIFT_HIDDEN_CACHE,
    rift=1,
    assault=NIGHTFAE,
    rewards={
        Transmog({item=187251, slot=L["cosmetic"]}) -- Shaded Skull Shoulderguards
    }
})

local RIFT_CACHE1 = RiftCache({quest=63995, icon='chest_rd'})
local RIFT_CACHE2 = RiftCache({quest=63997, icon='chest_bl'})
local RIFT_CACHE3 = RiftCache({quest=63998, icon='chest_yw'})
local RIFT_CACHE4 = RiftCache({quest=63996, icon='chest_pp'})
local RIFT_CACHE5 = RiftCache({quest=63999, icon='chest_gn'})
local RIFT_CACHE6 = RiftCache({quest=63993, icon='chest_pk'})

map.nodes[25304918] = RIFT_CACHE1
map.nodes[24583690] = RIFT_CACHE2
map.nodes[26403760] = RIFT_CACHE2
map.nodes[18903970] = RIFT_CACHE3
map.nodes[19143337] = RIFT_CACHE3
map.nodes[19044400] = RIFT_CACHE3
map.nodes[23203580] = RIFT_CACHE3
map.nodes[20712981] = RIFT_CACHE4
map.nodes[25092704] = RIFT_CACHE4
map.nodes[29744282] = RIFT_CACHE5
map.nodes[19104620] = RIFT_CACHE6
map.nodes[20604740] = RIFT_CACHE6
map.nodes[22624623] = RIFT_CACHE6

-------------------------------------------------------------------------------
-------------------------------- NILGANIHMAHT ---------------------------------
-------------------------------------------------------------------------------

local Nilganihmaht = Class('Nilganihmaht', ns.node.Rare, {
    quest=64202,
    id=179572,
    requires={
            ns.requirement.Item(186603), --Stone Ring
            ns.requirement.Item(186605), --Runed Band
            ns.requirement.Item(186608), --Gold Band
            ns.requirement.Item(186606), --Signet Ring Unknown spawn
            ns.requirement.Item(186607) --Silver Ring
    },
    group=ns.groups.NILGANIHMAHT_MOUNT,
    note=L["in_cave"]..' '..L["nilganihmaht_note"],
    icon=1391724,
    fgroup='nilganihmaht_group',
    rewards={
        Mount({item=186713, id=1503}) -- Hand of Nilganihmaht
    },
    pois={
        POI({25603260}) -- Cave entrance
    }
})

map.nodes[25503680] = Nilganihmaht()

map.nodes[66045739] = Treasure({
    quest=64207,
    requires=ns.requirement.Item(186727, 4), -- Seal Breaker Key
    group=ns.groups.NILGANIHMAHT_MOUNT,
    label=L["domination_chest"],
    note=L["domination_chest_note"],
    icon='chest_bl',
    fgroup='nilganihmaht_group',
    rewards={
        Item({item=186607}) -- Nilganimahts Silver Ring
    }
}) -- Domination Chest

map.nodes[19213225] = Treasure({
    quest=64199,
    group=ns.groups.NILGANIHMAHT_MOUNT,
    label="{item:186608}",
    note=L["gold_band_note"],
    icon='chest_bl',
    fgroup='nilganihmaht_group',
    rewards={
        Item({item=186608}) -- Nilganihmaht's Gold Band
    },
    pois={
        POI({18503926}) -- Starting point
    }
}) -- Nilganihmaht's Gold Band

map.nodes[65606000] = Treasure({
    quest=62680,
    group=ns.groups.NILGANIHMAHT_MOUNT,
    label=L["harrower_key_ring"],
    note=L["harrower_key_note"],
    icon='chest_bl',
    fgroup='nilganihmaht_group',
    rewards={
        Item({item=186727}) -- Seal Breaker Key
    }
}) -- The Harrower's Key Ring


local Helgarde = Class('Helgarde', Treasure, {
    quest=62682,
    group=ns.groups.NILGANIHMAHT_MOUNT,
    label=L["helgarde_supply"],
    icon='chest_bl',
    fgroup='nilganihmaht_group',
    rewards={
        Item({item=186727}) -- Seal Breaker Key
    }
})
map.nodes[65706121] = Helgarde()
map.nodes[67535568] = Helgarde()
map.nodes[68204810] = Helgarde()
map.nodes[62475528] = Helgarde()

map.nodes[29105850] = NPC({
    id=179601,
    quest=64197,
    icon='skull_w',
    assault=NECROLORD,
    group=ns.groups.NILGANIHMAHT_MOUNT,
    requires=ns.requirement.Item(186600),
    note=L["maw_mad_note"],
    fgroup='nilganihmaht_group',
    rewards={
        Item({item=186602}) -- Quartered Stone Ring
    }
})

--Add Locations for Quartered Stone Ring(186604), requires Necro Assault and at least 1 ring and is randomly located on the ground in peridition hold.

-------------------------------------------------------------------------------
----------------------------------- ASSAULT -----------------------------------
-------------------------------------------------------------------------------

local MawswornC = Class('MawswornC', Treasure, {
    label=L["mawsworn_cache"],
    fgroup='nilganihmaht_group',
    group=ns.groups.NILGANIHMAHT_MOUNT,
    assault=NECROLORD,
    rewards={
        Achievement({id=15039, criteria={id=1, qty=true}}),
        ns.reward.Currency({id=1767, note='20'}),
        Item({item=186573, quest=63594}), --Defense Plans
    }
})

map.nodes[30295581] = MawswornC({quest=63815})
map.nodes[27806170] = MawswornC({quest=63815})
map.nodes[33547047] = MawswornC({quest=63818})
map.nodes[32756506] = MawswornC({quest=63825})
map.nodes[32055633] = MawswornC({quest=63826})
map.nodes[35126980] = MawswornC({quest=64209, rewards={Item({item=186600})}}) --Quartered Stone Ring

local Etherwyrm = Class('Etherwyrm', Treasure, {
    quest=64000,
    requires=ns.requirement.Item(186190),
    label=L["etherwyrm_label"],
    note=L["etherwyrm_note"],
    assault=NIGHTFAE,
    rift=2,
    rewards={
        Pet({item=186191, id=3099}) -- Infused Etherwyrm
    },
    pois={
        POI({19214376, 19903240, 23604040}) -- Elusive Keybinder
    }
}) -- Infused Etherwyrm

map.nodes[23184238] = Etherwyrm()

-------------------------------------------------------------------------------
----------------------------------- VE'NARI -----------------------------------
-------------------------------------------------------------------------------

map.nodes[46914169] = NPC({
    id=162804,
    icon=3527519,
    note=L["venari_note"],
    rewards={
        Achievement({id=14895, oneline=true}), -- 'Ghast Five
        Section(C_Map.GetMapInfo(1543).name),
        ns.reward.Spacer(),
        Item({item=184613, quest=63177, note=L["Apprehensive"]}), -- Encased Riftwalker Essence
        Item({item=184653, quest=63217, note=L["Tentative"]}), -- Animated Levitating Chain
        Item({item=180949, quest=61600, note=L["Tentative"]}), -- Animaflow Stabilizer
        Item({item=184605, quest=63092, note=L["Tentative"]}), -- Sigil of the Unseen
        Item({item=184588, quest=63091, note=L["Ambivalent"]}), -- Soul-Stabilizing Talisman
        Item({item=184870, note=L["Appreciative"]}), -- Stygia Dowser
        ns.reward.Spacer(),
        Section(L["torghast"]),
        ns.reward.Spacer(),
        Item({item=184620, quest=63202, note=L["Apprehensive"]}), -- Vessel of Unforunate Spirits
        Item({item=184615, quest=63183, note=L["Apprehensive"]}), -- Extradimensional Pockets
        Item({item=184901, quest=63523, note=L["Apprehensive"]}), -- Broker Traversal Enhancer
        Item({item=184617, quest=63193, note=L["Tentative"]}), -- Bangle of Seniority
        Item({item=184621, quest=63204, note=L["Ambivalent"]}), -- Ritual Prism of Fortune
        Item({item=184618, quest=63200, note=L["Cordial"]}), -- Rank Insignia: Acquisitionist
        Item({item=184619, quest=63201, note=L["Cordial"]}), -- Loupe of Unusual Charm
        Item({item=180952, quest=61144, note=L["Appreciative"]}), -- Possibility Matrix
    }
})
