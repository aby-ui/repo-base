-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local Class = ns.Class
local L = ns.locale
local Map = ns.Map

local NPC = ns.node.NPC
local Rare = ns.node.Rare

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

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local map = Map({ id=1543, phased=false, settings=true })

function map:Prepare ()
    Map.Prepare(self)
    self.phased = C_QuestLog.IsQuestFlaggedCompleted(62907)
end

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

-- TODO: Add Fallen Adventurer's Cache rewards?

map.nodes[25923116] = Rare({
    id=157964,
    quest=57482,
    note=L["dekaris_note"],
    rlabel=ns.status.LightBlue('+80 '..L["rep"]),
    rewards={
        Achievement({id=14744, criteria=49841})
    }
}) -- Adjutant Dekaris

map.nodes[19324172] = Rare({
    id=170301,
    quest=60788,
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
    rewards={
        Achievement({id=14744, criteria=49851}),
        Item({item=184108, note=L["neck"]}), -- Vorpal Amulet
        Item({item=183066, quest=63160}), -- Korrath's Grimoire: Aleketh
        Item({item=183067, quest=63161}), -- Korrath's Grimoire: Belidir
        Item({item=183068, quest=63162})  -- Korrath's Grimoire: Gyadrek
    }
}) -- Exos, Herald of Domination

map.nodes[53507950] = Rare({
    id=174827,
    note=L["gorged_shadehound_note"],
    -- quest=61124,
    rewards={
        Mount({item=184167, id=1304}) -- Mawsworn Soulhunter
    }
}) -- Gorged Shadehound

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
    rewards={
        Achievement({id=14660, criteria=49481})
    }
}) -- Huwerath

map.nodes[30846866] = BonusBoss({
    id=170692,
    quest=60903,
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
        Achievement({id=14660, criteria=50408})
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
        Achievement({id=14660, criteria=49489})
    },
    pois={
        POI({55806753}) -- Cave entrance
    }
}) -- Sanngror the Torturer

map.nodes[61737795] = BonusBoss({
    id=172524,
    quest=62211,
    note=L["in_cave"],
    rewards={
        Achievement({id=14660, criteria=49491})
    },
    pois={
        POI({59268001}) -- Cave entrance
    }
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
---------------------------- BONUS OBJECTIVE EVENTS ---------------------------
-------------------------------------------------------------------------------

local BonusEvent = Class('BonusEvent', ns.node.Quest, {
    icon = 'peg_yw',
    scale = 1.8,
    group = ns.groups.BONUS_EVENT,
    note = ''
})

local SOUL_WELL = BonusEvent({ quest=59007, note=L["soul_well_note"] })

map.nodes[21573436] = SOUL_WELL
map.nodes[30394255] = SOUL_WELL
map.nodes[32401771] = SOUL_WELL
-- map.nodes[27446463] = BonusEvent({ quest=59784, note=L["obliterated_soul_shards_note"] })

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
    icon='portal_r',
    fgroup='riftstone1',
    pois={Line({19184778, 25211784})}
})

map.nodes[25211784] = Riftstone({
    icon='portal_r',
    fgroup='riftstone1'
})

-------------------------------------------------------------------------------

map.nodes[23433121] = Riftstone({
    icon='portal_b',
    fgroup='riftstone2',
    pois={Line({23433121, 34804362})}
})

map.nodes[34804362] = Riftstone({
    icon='portal_b',
    fgroup='riftstone2'
})

-------------------------------------------------------------------------------

map.nodes[48284145] = NPC({
    group=ns.groups.RIFTSTONE,
    icon='portal_b',
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
    22534798, 22942220, 22956723, 23034411, 23076836, 23676572, 24542916,
    24833046, 24866552, 25456554, 25633108, 26116811, 26132722, 26306726,
    26342905, 26541861, 26952753, 27202506, 27362593, 27896168, 28161347,
    28634916, 29561776, 29661285, 29863694, 29951784, 30033617, 30132835,
    30582337, 30591312, 30756551, 30942597, 31221584, 31316530, 31351499,
    31655664, 32056840, 32194490, 32426772, 32674369, 32904238, 33102066,
    33286365, 33295928, 33374532, 33584024, 33767056, 34074701, 34237005,
    34463889, 34624440, 35006680, 36244139, 36264642, 37844512, 40334904,
    41184945, 41304785, 42264174
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

map.nodes[15705040] = Cache()
map.nodes[19604460] = Cache()
map.nodes[19805500] = Cache()
map.nodes[24301660] = Cache()
map.nodes[28402560] = Cache()
map.nodes[29621283] = Cache()
map.nodes[35201630] = Cache()
map.nodes[35902360] = Cache()
map.nodes[39802510] = Cache()
map.nodes[44201870] = Cache()
map.nodes[45204740] = Cache()

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
        ns.reward.Spacer(),
        Section(L["torghast"]),
        ns.reward.Spacer(),
        Item({item=184620, quest=63202, note=L["Apprehensive"]}), -- Vessel of Unforunate Spirits
        Item({item=184615, quest=63183, note=L["Apprehensive"]}), -- Extradimensional Pockets
        Item({item=184617, quest=63193, note=L["Tentative"]}), -- Bangle of Seniority
        Item({item=184621, quest=63204, note=L["Ambivalent"]}), -- Ritual Prism of Fortune
        Item({item=184618, quest=63200, note=L["Cordial"]}), -- Rank Insignia: Acquisitionist
        Item({item=184619, quest=63201, note=L["Cordial"]}), -- Loupe of Unusual Charm
        Item({item=180952, quest=nil, note=L["Appreciative"]}), -- Possibility Matrix
    }
})
