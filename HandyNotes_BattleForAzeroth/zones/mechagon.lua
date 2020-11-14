-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local _, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.Map

local Node = ns.node.Node
local NPC = ns.node.NPC
local PetBattle = ns.node.PetBattle
local Quest = ns.node.Quest
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local POI = ns.poi.POI

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local map = Map({ id=1462, settings=true })

function map:Prepare ()
    Map.Prepare(self)
    self.future = AuraUtil.FindAuraByName(GetSpellInfo(296644), 'player')
end

function map:IsNodeEnabled(node, coord, minimap)
    -- check node's future availability (nil=no, 1=yes, 2=both)
    if self.future and not node.future then return false end
    if not self.future and node.future == 1 then return false end
    return Map.IsNodeEnabled(self, node, coord, minimap)
end

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[52894092] = Rare({
    id=151934,
    quest=55512,
    future=2,
    rewards={
        Achievement({id=13470, criteria=45124}),
        Mount({id=1229, item=168823}) -- Rusty Mechanocrawler
    }
}) -- Arachnoid Harvester

map.nodes[55622571] = Rare({
    id=151308,
    quest=55539,
    rewards={
        Achievement({id=13470, criteria=45131}),
        Item({item=169688, quest=56515}) -- Vinyl: Gnomeregan Forever
    }
}) -- Boggac Skullbash

map.nodes[51265010] = Rare({
    id=153200,
    quest=55857,
    requires='{npc:150306} (DR-JD41)',
    rewards={
        Achievement({id=13470, criteria=45152}),
        Item({item=167042, quest=55030}), -- Blueprint: Scrap Trap
        Item({item=169691, quest=56518}) -- Vinyl: Depths of Ulduar
    }
}) -- Boilburn

map.nodes[65842288] = Rare({
    id=152001,
    quest=55537,
    note=L["cave_spawn"],
    rewards={
        Achievement({id=13470, criteria=45130}),
        Item({item=167846, quest=55061}), -- Blueprint: Mechano-Treat
        Pet({id=2719, item=169392}) -- Bonebiter
    }
}) -- Bonepicker

map.nodes[66535891] = Rare({
    id=154739,
    quest=56368,
    requires='{npc:150306} (DR-CC73)',
    rewards={
        Achievement({id=13470, criteria=45411}),
        Item({item=169170, quest=55078}) -- Blueprint: Utility Mechanoclaw
    }
}) -- Caustic Mechaslime

map.nodes[82522072] = Rare({
    id=149847,
    quest=55812,
    note=L["crazed_trogg_note"],
    rewards={
        Achievement({id=13470, criteria=45137}),
        Item({item=169169, quest=55077}), -- Blueprint: Blue Spraybot
        Item({item=169168, quest=55076}), -- Blueprint: Green Spraybot
        Item({item=169167, quest=55075}), -- Blueprint: Orange Spraybot
        Item({item=167792, quest=55452}), -- Paint Vial: Fel Mint Green
        Item({item=167793, quest=55457}) -- Paint Vial: Overload Orange
    }
}) -- Crazed Trogg

map.nodes[35464229] = Rare({
    id=151569,
    quest=55514,
    note=L["deepwater_note"],
    requires=ns.requirement.Item(167649),
    rewards={
        Achievement({id=13470, criteria=45128}),
        Item({item=167836, quest=55057}), -- Blueprint: Canned Minnows
    }
}) --Deepwater Maw

map.nodes[63122559] = Rare({
    id=150342,
    quest=55814,
    requires='{npc:150306} (DR-TR35)',
    rewards={
        Achievement({id=13470, criteria=45138}),
        Item({item=167042, quest=55030}), -- Blueprint: Scrap Trap
        Item({item=169691, quest=56518}) -- Vinyl: Depths of Ulduar
    }
}) -- Earthbreaker Gulroc

map.nodes[55075684] = Rare({
    id=154153,
    quest=56207,
    rewards={
        Achievement({id=13470, criteria=45373}),
        Item({item=169174, quest=55082}), -- Blueprint: Rustbolt Pocket Turret
        Transmog({item=170466, slot=L["staff"]}), -- Junkyard Motivator
        Transmog({item=170467, slot=L["1h_sword"]}), -- Whirring Chainblade
        Transmog({item=170468, slot=L["gun"]}), -- Supervolt Zapper
        Transmog({item=170470, slot=L["shield"]}) -- Reinforced Grease Deflector
    }
}) -- Enforcer KX-T57

map.nodes[65515167] = Rare({
    id=151202,
    quest=55513,
    note=L["foul_manifest_note"],
    rewards={
        Achievement({id=13470, criteria=45127}),
        Item({item=167871, quest=55063}) -- Blueprint: G99.99 Landshark
    }
}) -- Foul Manifestation

map.nodes[44553964] = Rare({
    id=151884,
    quest=55367,
    note=L["furor_note"],
    rewards={
        Achievement({id=13470, criteria=45126}),
        Item({item=167793, quest=55457}), -- Paint Vial: Overload Orange
        Pet({id=2712, item=169379}) -- Snowsoft Nibbler
    }
}) -- Fungarian Furor

map.nodes[61395117] = Rare({
    id=153228,
    quest=55852,
    note=L["cogstar_note"],
    rewards={
        Achievement({id=13470, criteria=45155}),
        Item({item=167847, quest=55062}), -- Blueprint: Ultrasafe Transporter: Mechagon
        Transmog({item=170467, slot=L["1h_sword"]}) -- Whirring Chainblade
    }
}) -- Gear Checker Cogstar

map.nodes[59836701] = Rare({
    id=153205,
    quest=55855,
    requires='{npc:150306} (DR-JD99)',
    rewards={
        Achievement({id=13470, criteria=45146}),
        Item({item=169691, quest=56518}) -- Vinyl: Depths of Ulduar
    }
}) -- Gemicide

map.nodes[73135414] = Rare({
    id=154701,
    quest=56367,
    requires='{npc:150306} (DR-CC61)',
    rewards={
        Achievement({id=13470, criteria=45410}),
        Item({item=167846, quest=55061}) -- Blueprint: Mechano-Treat
    }
}) -- Gorged Gear-Cruncher

map.nodes[77124471] = Rare({
    id=151684,
    quest=55399,
    rewards={
        Achievement({id=13470, criteria=45121})
    }
}) -- Jawbreaker

map.nodes[44824637] = Rare({
    id=152007,
    quest=55369,
    note=L["killsaw_note"],
    rewards={
        Achievement({id=13470, criteria=45125}),
        Toy({item=167931}) -- Mechagonian Sawblades
    }
}) -- Killsaw

map.nodes[60654217] = Rare({
    id=151933,
    quest=55544,
    note=L["beastbot_note"],
    requires=ns.requirement.Item(168045),
    rewards={
        Achievement({id=13470, criteria=45136}),
        Achievement({id=13708, criteria={45772,45775,45776,45777,45778}}), -- Most Minis Wins
        Item({item=169848, weekly=57135}), -- Azeroth Mini Pack: Bondo's Yard
        Item({item=169173, quest=55081}), -- Blueprint: Anti-Gravity Pack
        Pet({id=2715, item=169382}) -- Lost Robogrip
    }
}) -- Malfunctioning Beastbot (55926 56506)

map.nodes[57165258] = Rare({
    id=151124,
    quest=55207,
    note=L["nullifier_note"],
    requires={
        ns.requirement.Item(168023),
        ns.requirement.Item(168435)
    },
    rewards={
        Achievement({id=13470, criteria=45117}),
        Item({item=168490, quest=55069}), -- Blueprint: Protocol Transference Device
        Item({item=169688, quest=56515}) -- Vinyl: Gnomeregan Forever
    }
}) -- Mechagonian Nullifier

map.nodes[88142077] = Rare({
    id=151672,
    quest=55386,
    future=2,
    rewards={
        Achievement({id=13470, criteria=45119}),
        Pet({id=2720, item=169393}) -- Arachnoid Skitterbot
    }
}) -- Mecharantula

map.nodes[61036101] = Rare({
    id=151627,
    quest=55859,
    rewards={
        Achievement({id=13470, criteria=45156}),
        Item({item=168248, quest=55068}), -- Blueprint: BAWLD-371
        Transmog({item=170467, slot=L["1h_sword"]}) -- Whirring Chainblade
    }
}) -- Mr. Fixthis

map.nodes[56243595] = Rare({
    id=153206,
    quest=55853,
    requires='{npc:150306} (DR-TR28)',
    rewards={
        Achievement({id=13470, criteria=45145}),
        Item({item=167846, quest=55061}), -- Blueprint: Mechano-Treat
        Item({item=169691, quest=56518}), -- Vinyl: Depths of Ulduar
        Transmog({item=170466, slot=L["staff"]}) -- Junkyard Motivator
    }
}) -- Ol' Big Tusk

map.nodes[57063944] = Rare({
    id=151296,
    quest=55515,
    note=L["avenger_note"],
    rewards={
        Achievement({id=13470, criteria=45129}),
        Item({item=168492, quest=55071}) -- Blueprint: Emergency Rocket Chicken
    }
}) -- OOX-Avenger/MG

map.nodes[56636287] = Rare({
    id=152764,
    quest=55856,
    note=L["leachbeast_note"],
    rewards={
        Achievement({id=13470, criteria=45157}),
        Item({item=167794, quest=55454}), -- Paint Vial: Lemonade Steel
    }
}) -- Oxidized Leachbeast

map.nodes[22466873] = Rare({
    id=151702,
    quest=55405,
    rewards={
        Achievement({id=13470, criteria=45122}),
        Transmog({item=170468, slot=L["gun"]}) -- Supervolt Zapper
    }
}) -- Paol Pondwader

map.nodes[40235317] = Rare({
    id=150575,
    quest=55368,
    note=L["cave_spawn"],
    rewards={
        Achievement({id=13470, criteria=45123}),
        Item({item=168001, quest=55517}) -- Paint Vial: Big-ol Bronze
    }
}) -- Rumblerocks

map.nodes[65637850] = Rare({
    id=152182,
    quest=55811,
    rewards={
        Achievement({id=13470, criteria=45135}),
        Item({item=169173, quest=55081}), -- Blueprint: Anti-Gravity Pack
        Mount({id=1248, item=168370}) -- Rusted Keys to the Junkheap Drifter
    }
}) -- Rustfeather

map.nodes[82287300] = Rare({
    id=155583,
    quest=56737,
    note=L["scrapclaw_note"],
    rewards={
        Achievement({id=13470, criteria=45691}),
        Transmog({item=170470, slot=L["shield"]}) -- Reinforced Grease Deflector
    }
}) -- Scrapclaw

map.nodes[19127975] = Rare({
    id=150937,
    quest=55545,
    rewards={
        Achievement({id=13470, criteria=45133}),
        Item({item=168063, quest=55065}) -- Blueprint: Rustbolt Kegerator
    }
}) -- Seaspit

map.nodes[81852708] = Rare({
    id=153000,
    quest=55810,
    note=L["sparkqueen_note"],
    rewards={
        Achievement({id=13470, criteria=45134})
    }
}) -- Sparkqueen P'Emp

map.nodes[26257806] = Rare({
    id=153226,
    quest=55854,
    rewards={
        Achievement({id=13470, criteria=45154}),
        Item({item=168062, quest=55064}), -- Blueprint: Rustbolt Gramophone
        Item({item=169690, quest=56517}), -- Vinyl: Battle of Gnomeregan
        Item({item=169689, quest=56516}), -- Vinyl: Mimiron's Brainstorm
        Item({item=169692, quest=56519}) -- Vinyl: Triumph of Gnomeregan
    }
}) -- Steel Singer Freza

map.nodes[80962019] = Rare({
    id=155060,
    quest=56419,
    label=GetAchievementCriteriaInfoByID(13470, 45433),
    note=L["doppel_note"],
    requires=ns.requirement.Item(169470),
    rewards={
        Achievement({id=13470, criteria=45433})
    }
}) -- The Doppel Gang

map.nodes[68434776] = Rare({
    id=152113,
    quest=55858,
    requires='{npc:150306} (DR-CC88)',
    rewards={
        Achievement({id=13470, criteria=45153}),
        Item({item=169691, quest=56518}), -- Vinyl: Depths of Ulduar
        Pet({id=2753, item=169886}) -- Spraybot 0D
    }
}) -- The Kleptoboss

map.nodes[57335827] = Rare({
    id=154225,
    quest=56182,
    future=2,
    note=L["rusty_note"],
    requires=ns.requirement.Item(169114),
    rewards={
        Achievement({id=13470, criteria=45374}),
        Toy({item=169347}), -- Judgment of Mechagon
        Transmog({item=170467, slot=L["1h_sword"]}) -- Whirring Chainblade
    }
}) -- The Rusty Prince

map.nodes[72344987] = Rare({
    id=151625,
    quest=55364,
    rewards={
        Achievement({id=13470, criteria=45118}),
        Item({item=167846, quest=55061}), -- Blueprint: Mechano-Treat
        Transmog({item=170467, slot=L["1h_sword"]}) -- Whirring Chainblade
    }
}) -- The Scrap King

map.nodes[57062218] = Rare({
    id=151940,
    quest=55538,
    note=L["cave_spawn"],
    rewards={
        Achievement({id=13470, criteria=45132})
    }
}) -- Uncle T'Rogg

map.nodes[53824933] = Rare({
    id=150394,
    quest=55546,
    future=2,
    note=L["vaultbot_note"],
    requires=ns.requirement.Item(167062),
    rewards={
        Achievement({id=13470, criteria=45158}),
        Item({item=167843, quest=55058}), -- Blueprint: Vaultbot Key
        Item({item=167796, quest=55455}), -- Paint Vial: Mechagon Gold
        Pet({id=2766, item=170072}) -- Armored Vaultbot
    },
    pois={
        POI({63263885}) -- Tesla Coil
    }
}) -- Armored Vaultbot

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[64706460] = PetBattle({id=154922, rewards={Achievement({id=13625, criteria=45459})}}) -- Gnomefeaster
map.nodes[60704650] = PetBattle({id=154923, rewards={Achievement({id=13625, criteria=45460})}}) -- Sputtertude
map.nodes[60605690] = PetBattle({id=154924, rewards={Achievement({id=13625, criteria=45461})}}) -- Goldenbot XD
map.nodes[59205090] = PetBattle({id=154925, rewards={Achievement({id=13625, criteria=45462})}}) -- Creakclank
map.nodes[65405770] = PetBattle({id=154926, rewards={Achievement({id=13625, criteria=45463})}}) -- CK-9 Micro-Oppression Unit
map.nodes[51104540] = PetBattle({id=154927, rewards={Achievement({id=13625, criteria=45464})}}) -- Unit 35
map.nodes[39504010] = PetBattle({id=154928, rewards={Achievement({id=13625, criteria=45465})}}) -- Unit 6
map.nodes[72107290] = PetBattle({id=154929, rewards={Achievement({id=13625, criteria=45466})}}) -- Unit 17

-------------------------------------------------------------------------------
-------------------------------- LOCKED CHESTS --------------------------------
-------------------------------------------------------------------------------

local Locked = Class('LockedChest', Node, {
    icon='chest_gy',
    scale = 1.3,
    group=ns.groups.LOCKED_CHEST
})

local iron = Locked({
    label=L["iron_chest"],
    note=L["iron_chest_note"],
    requires=ns.requirement.Item(169872),
    rewards={
        Item({item=170146, quest=56907}) -- Paint Bottle: Nukular Red
    }
})

local mech = Locked({
    label=L["msup_chest"],
    note=L["msup_chest_note"],
    requires=ns.requirement.Item(169873),
    rewards={
        Achievement({id=13708, criteria={45773,45781,45779,45780,45785}}), -- Most Minis Wins
        Item({item=169850, weekly=57133}) -- Azeroth Mini Pack: Mechagon
    }
})

local rusty = Locked({
    label=L["rust_chest"],
    note=L["rust_chest_note"],
    requires=ns.requirement.Item(169218)
})

map.nodes[23195699] = iron
map.nodes[13228581] = iron
map.nodes[19018086] = iron
map.nodes[30775964] = iron
map.nodes[20537120] = mech
map.nodes[18357618] = rusty
map.nodes[25267825] = rusty
map.nodes[23988441] = rusty

-------------------------------------------------------------------------------
------------------------------ MECHANIZED CHESTS ------------------------------
-------------------------------------------------------------------------------

local MechChest = Class('MechChest', Treasure)

MechChest.group = ns.groups.MECH_CHEST
MechChest.label = L["mech_chest"]
MechChest.rewards = {
    Achievement({id=13708, criteria={45773,45781,45779,45780,45785}}), -- Most Minis Wins
    Item({item=167790, quest=55451}), -- Paint Vial: Fireball Red
    Item({item=169850, weekly=57133}) -- Azeroth Mini Pack: Mechagon
}

local TREASURE1 = MechChest({quest=55547, icon='chest_yw'})
local TREASURE2 = MechChest({quest=55548, icon='chest_bl'})
local TREASURE3 = MechChest({quest=55549, icon='chest_nv'})
local TREASURE4 = MechChest({quest=55550, icon='chest_tl'})
local TREASURE5 = MechChest({quest=55551, icon='chest_bk', future=1})
local TREASURE6 = MechChest({quest=55552, icon='chest_pp'})
local TREASURE7 = MechChest({quest=55553, icon='chest_gn'})
local TREASURE8 = MechChest({quest=55554, icon='chest_pk'})
local TREASURE9 = MechChest({quest=55555, icon='chest_lm'})
local TREASURE10 = MechChest({quest=55556, icon='chest_rd'})

-- object 325659
map.nodes[43304977] = TREASURE1
map.nodes[49223021] = TREASURE1
map.nodes[52115326] = TREASURE1
map.nodes[53254190] = TREASURE1
map.nodes[56973861] = TREASURE1
-- object 325660
map.nodes[20617141] = TREASURE2
map.nodes[30785183] = TREASURE2
map.nodes[35683833] = TREASURE2
map.nodes[40155409] = TREASURE2
-- object 325661
map.nodes[59946357] = TREASURE3
map.nodes[65866460] = TREASURE3
map.nodes[67075645] = TREASURE3
map.nodes[73515334] = TREASURE3
map.nodes[80374838] = TREASURE3
-- object 325662
map.nodes[65555284] = TREASURE4
map.nodes[72594733] = TREASURE4
map.nodes[73014950] = TREASURE4
map.nodes[76215286] = TREASURE4
map.nodes[81196149] = TREASURE4
-- object 325663
map.nodes[56665739] = TREASURE5
map.nodes[58634160] = TREASURE5
map.nodes[61583230] = TREASURE5
map.nodes[64365961] = TREASURE5
map.nodes[70654796] = TREASURE5
-- object 325664
map.nodes[50662858] = TREASURE6
map.nodes[55612404] = TREASURE6
map.nodes[56782918] = TREASURE6
map.nodes[57142283] = TREASURE6
map.nodes[64092627] = TREASURE6
map.nodes[66432227] = TREASURE6
-- object 325665
map.nodes[67322289] = TREASURE7
map.nodes[80691868] = TREASURE7
map.nodes[85752824] = TREASURE7
map.nodes[86232042] = TREASURE7
map.nodes[88732015] = TREASURE7
-- object 325666
map.nodes[48367595] = TREASURE8
map.nodes[57258202] = TREASURE8
map.nodes[62297390] = TREASURE8
map.nodes[66767759] = TREASURE8
-- object 325667
map.nodes[63626715] = TREASURE9
map.nodes[72126545] = TREASURE9
map.nodes[76516601] = TREASURE9
map.nodes[81167231] = TREASURE9
map.nodes[85166335] = TREASURE9
-- object 325668
map.nodes[12088568] = TREASURE10
map.nodes[20537696] = TREASURE10
map.nodes[21788303] = TREASURE10
map.nodes[24796526] = TREASURE10

-------------------------------------------------------------------------------
-------------------------------- MISCELLANEOUS --------------------------------
-------------------------------------------------------------------------------

map.nodes[53486145] = Quest({
    quest=55743,
    questDeps=56117,
    daily=true,
    minimap=false,
    scale=1.8,
    rewards={
        Achievement({id=13708, criteria={45772,45775,45776,45777,45778}}), -- Most Minis Wins
        Item({item=169848, weekly=57134}), -- Azeroth Mini Pack: Bondo's Yard
    }
})

-------------------------------------------------------------------------------

map.nodes[69976201] = Class('RegRig', NPC, {
    id=150448,
    icon="peg_wb",
    scale=2,
    note=L["rec_rig_note"],
    group=ns.groups.RECRIG,
    rewards={
        Achievement({id=13708, criteria={45773,45781,45779,45780,45785}}), -- Most Minis Wins
        Item({item=169850, note=L["normal"], weekly=57132}), -- Azeroth Mini Pack: Mechagon
        Item({item=168495, note=L["hard"], quest=55074}), -- Blueprint: Rustbolt Requisitions
        Pet({id=2721, item=169396}), -- Echoing Oozeling
        Pet({id=2756, item=169879}) -- Irradiated Elementaling
    },
    getters = {
        rlabel = function (self)
            local G, GR, N, H = ns.status.Green, ns.status.Gray, L['normal'], L['hard']
            local normal = C_QuestLog.IsQuestFlaggedCompleted(55847) and G(N) or GR(N)
            local hard = C_QuestLog.IsQuestFlaggedCompleted(55848) and G(H) or GR(H)
            return normal..' '..hard
        end
    }
})() -- Reclamation Rig ???=56079