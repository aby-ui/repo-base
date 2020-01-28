-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local _, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.Map
local isinstance = ns.isinstance

local Node = ns.node.Node
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

local options = ns.options.args.VisibilityGroup.args
local defaults = ns.optionDefaults.profile

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local map = Map({ id=1462 })
local nodes = map.nodes
local TIME_DISPLACEMENT = 296644

function map:prepare ()
    self.future = AuraUtil.FindAuraByName(GetSpellInfo(TIME_DISPLACEMENT), 'player')
end

function map:enabled (node, coord, minimap)
    if not Map.enabled(self, node, coord, minimap) then return false end

    -- check node's future availability (nil=no, 1=yes, 2=both)
    if self.future and not node.future then return false end
    if not self.future and node.future == 1 then return false end

    local profile = ns.addon.db.profile
    if isinstance(node, Treasure) then
        if node.quest then return profile.chest_mech end
        return profile.locked_mech
    end
    if isinstance(node, Rare) then return profile.rare_mech end
    if isinstance(node, PetBattle) then return profile.pet_mech end
    if node.label == L["rec_rig"] then return profile.recrig_mech end

    -- node for the More Recycling daily
    if isinstance(node, Quest) then return true end

    return false;
end

-- Listen for aura applied/removed events so we can refresh when the player
-- enters and exits the alternate future
ns.addon:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', function ()
    local _,e,_,_,_,_,_,_,t,_,_,s  = CombatLogGetCurrentEventInfo()
    if (e == 'SPELL_AURA_APPLIED' or e == 'SPELL_AURA_REMOVED') and
        t == UnitName('player') and s == TIME_DISPLACEMENT then
        C_Timer.After(1, function()
            ns.addon:Refresh();
        end);
    end
end)

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

defaults['chest_mech'] = false;
defaults['locked_mech'] = true;
defaults['rare_mech'] = true;
defaults['pet_mech'] = true;
defaults['recrig_mech'] = true;

options.groupMechagon = {
    type = "header",
    name = L["Mechagon"],
    order = 0,
};

options.mechChestMechagon = {
    type = "toggle",
    arg = "chest_mech",
    name = L["options_toggle_mech_chest"],
    desc = L["options_toggle_mech_chest_desc"],
    order = 1,
    width = "normal",
};


options.lockedChestMechagon = {
    type = "toggle",
    arg = "locked_mech",
    name = L["options_toggle_locked_chest"],
    desc = L["options_toggle_locked_chest_desc"],
    order = 2,
    width = "normal",
};

options.rareMechagon = {
    type = "toggle",
    arg = "rare_mech",
    name = L["options_toggle_rares"],
    desc = L["options_toggle_rares_desc"],
    order = 3,
    width = "normal",
};

options.petMechagon = {
    type = "toggle",
    arg = "pet_mech",
    name = L["options_toggle_battle_pets"],
    desc = L["options_toggle_battle_pets_desc"],
    order = 4,
    width = "normal",
};

options.recrigMechagon = {
    type = "toggle",
    arg = "recrig_mech",
    name = L["options_toggle_recrig"],
    desc = L["options_toggle_recrig_desc"],
    order = 5,
    width = "normal",
};

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

nodes[52894092] = Rare({id=151934, quest=55512, future=2, note=nil, rewards={
    Achievement({id=13470, criteria=45124}), -- Kill
    Mount({id=1229, item=168823}) -- Rusty Mechanocrawler
}}); -- Arachnoid Harvester

nodes[55622571] = Rare({id=151308, quest=55539, note=nil, rewards={
    Achievement({id=13470, criteria=45131}), -- Kill
    Item({item=169688, quest=56515}) -- Vinyl: Gnomeregan Forever
}}); -- Boggac Skullbash

nodes[51265010] = Rare({id=153200, quest=55857, note=L["drill_rig"]..'(DR-JD41).', rewards={
    Achievement({id=13470, criteria=45152}), -- Kill
    Item({item=167042, quest=55030}), -- Blueprint: Scrap Trap
    Item({item=169691, quest=56518}) -- Vinyl: Depths of Ulduar
}}); -- Boilburn

nodes[65842288] = Rare({id=152001, quest=55537, note=L["cave_spawn"], rewards={
    Achievement({id=13470, criteria=45130}), -- Kill
    Item({item=167846, quest=55061}), -- Blueprint: Mechano-Treat
    Pet({id=2719, item=169392}) -- Bonebiter
}}); -- Bonepicker

nodes[66535891] = Rare({id=154739, quest=56368, note=L["drill_rig"]..'(DR-CC73).', rewards={
    Achievement({id=13470, criteria=45411}), -- Kill
    Item({item=169170, quest=55078}) -- Blueprint: Utility Mechanoclaw
}}); -- Caustic Mechaslime

nodes[82522072] = Rare({id=149847, quest=55812, note=L["crazed_trogg_note"], rewards={
    Achievement({id=13470, criteria=45137}), -- Kill
    Item({item=169169, quest=55077}), -- Blueprint: Blue Spraybot
    Item({item=169168, quest=55076}), -- Blueprint: Green Spraybot
    Item({item=169167, quest=55075}), -- Blueprint: Orange Spraybot
    Item({item=167792, quest=55452}), -- Paint Vial: Fel Mint Green
    Item({item=167793, quest=55457}) -- Paint Vial: Overload Orange
}}); -- Crazed Trogg

nodes[35464229] = Rare({id=151569, quest=55514, note=L["deepwater_note"], rewards={
    Achievement({id=13470, criteria=45128}), -- Kill
    Item({item=167836, quest=55057}), -- Blueprint: Canned Minnows
}}); --Deepwater Maw

nodes[63122559] = Rare({id=150342, quest=55814, note=L["drill_rig"]..'(DR-TR35).', rewards={
    Achievement({id=13470, criteria=45138}), -- Kill
    Item({item=167042, quest=55030}), -- Blueprint: Scrap Trap
    Item({item=169691, quest=56518}) -- Vinyl: Depths of Ulduar
}}); -- Earthbreaker Gulroc

nodes[55075684] = Rare({id=154153, quest=56207, note=nil, rewards={
    Achievement({id=13470, criteria=45373}), -- Kill
    Item({item=169174, quest=55082}), -- Blueprint: Rustbolt Pocket Turret
    Transmog({item=170466, slot=L["staff"]}), -- Junkyard Motivator
    Transmog({item=170467, slot=L["1h_sword"]}), -- Whirring Chainblade
    Transmog({item=170468, slot=L["gun"]}), -- Supervolt Zapper
    Transmog({item=170470, slot=L["shield"]}) -- Reinforced Grease Deflector
}}); -- Enforcer KX-T57

nodes[65515167] = Rare({id=151202, quest=55513, note=L["foul_manifest_note"], rewards={
    Achievement({id=13470, criteria=45127}), -- Kill
    Item({item=167871, quest=55063}) -- Blueprint: G99.99 Landshark
}}); -- Foul Manifestation

nodes[44553964] = Rare({id=151884, quest=55367, note=L["furor_note"], rewards={
    Achievement({id=13470, criteria=45126}), -- Kill
    Item({item=167793, quest=55457}), -- Paint Vial: Overload Orange
    Pet({id=2712, item=169379}) -- Snowsoft Nibbler
}}); -- Fungarian Furor

nodes[61395117] = Rare({id=153228, quest=55852, note=L["cogstar_note"], rewards={
    Achievement({id=13470, criteria=45155}), -- Kill
    Item({item=167847, quest=55062}), -- Blueprint: Ultrasafe Transporter: Mechagon
    Transmog({item=170467, slot=L["1h_sword"]}) -- Whirring Chainblade
}}); -- Gear Checker Cogstar

nodes[59836701] = Rare({id=153205, quest=55855, note=L["drill_rig"]..'(DR-JD99).', rewards={
    Achievement({id=13470, criteria=45146}), -- Kill
    Item({item=169691, quest=56518}) -- Vinyl: Depths of Ulduar
}}); -- Gemicide

nodes[73135414] = Rare({id=154701, quest=56367, note=L["drill_rig"]..'(DR-CC61).', rewards={
    Achievement({id=13470, criteria=45410}), -- Kill
    Item({item=167846, quest=55061}) -- Blueprint: Mechano-Treat
}}); -- Gorged Gear-Cruncher

nodes[77124471] = Rare({id=151684, quest=55399, note=nil, rewards={
    Achievement({id=13470, criteria=45121}) -- Kill
}}); -- Jawbreaker

nodes[44824637] = Rare({id=152007, quest=55369, note=L["killsaw_note"], rewards={
    Achievement({id=13470, criteria=45125}), -- Kill
    Toy({item=167931}) -- Mechagonian Sawblades
}}); -- Killsaw

nodes[60654217] = Rare({id=151933, quest=55544, note=L["beastbot_note"], rewards={
    Achievement({id=13470, criteria=45136}), -- Kill
    Achievement({id=13708, criteria={45772,45775,45776,45777,45778}}), -- Most Minis Wins
    Item({item=169848, weekly=57135}), -- Azeroth Mini Pack: Bondo's Yard
    Item({item=169173, quest=55081}), -- Blueprint: Anti-Gravity Pack
    Pet({id=2715, item=169382}) -- Lost Robogrip
}}); -- Malfunctioning Beastbot (55926 56506)

nodes[57165258] = Rare({id=151124, quest=55207, note=L["nullifier_note"], rewards={
    Achievement({id=13470, criteria=45117}), -- Kill
    Item({item=168490, quest=55069}), -- Blueprint: Protocol Transference Device
    Item({item=169688, quest=56515}) -- Vinyl: Gnomeregan Forever
}}); -- Mechagonian Nullifier

nodes[88142077] = Rare({id=151672, quest=55386, future=2, note=nil, rewards={
    Achievement({id=13470, criteria=45119}), -- Kill
    Pet({id=2720, item=169393}) -- Arachnoid Skitterbot
}}); -- Mecharantula

nodes[61036101] = Rare({id=151627, quest=55859, note=nil, rewards={
    Achievement({id=13470, criteria=45156}), -- Kill
    Item({item=168248, quest=55068}), -- Blueprint: BAWLD-371
    Transmog({item=170467, slot=L["1h_sword"]}) -- Whirring Chainblade
}}); -- Mr. Fixthis

nodes[56243595] = Rare({id=153206, quest=55853, note=L["drill_rig"]..'(DR-TR28).', rewards={
    Achievement({id=13470, criteria=45145}), -- Kill
    Item({item=167846, quest=55061}), -- Blueprint: Mechano-Treat
    Item({item=169691, quest=56518}), -- Vinyl: Depths of Ulduar
    Transmog({item=170466, slot=L["staff"]}) -- Junkyard Motivator
}}); -- Ol' Big Tusk

nodes[57063944] = Rare({id=151296, quest=55515, note=L["avenger_note"], rewards={
    Achievement({id=13470, criteria=45129}), -- Kill
    Item({item=168492, quest=55071}) -- Blueprint: Emergency Rocket Chicken
}}); -- OOX-Avenger/MG

nodes[56636287] = Rare({id=152764, quest=55856, note=L["leachbeast_note"], rewards={
    Achievement({id=13470, criteria=45157}), -- Kill
    Item({item=167794, quest=55454}), -- Paint Vial: Lemonade Steel
}}); -- Oxidized Leachbeast

nodes[22466873] = Rare({id=151702, quest=55405, note=nil, rewards={
    Achievement({id=13470, criteria=45122}), -- Kill
    Transmog({item=170468, slot=L["gun"]}) -- Supervolt Zapper
}}); -- Paol Pondwader

nodes[40235317] = Rare({id=150575, quest=55368, note=L["cave_spawn"], rewards={
    Achievement({id=13470, criteria=45123}), -- Kill
    Item({item=168001, quest=55517}) -- Paint Vial: Big-ol Bronze
}}); -- Rumblerocks

nodes[65637850] = Rare({id=152182, quest=55811, note=nil, rewards={
    Achievement({id=13470, criteria=45135}), -- Kill
    Item({item=169173, quest=55081}), -- Blueprint: Anti-Gravity Pack
    Mount({id=1248, item=168370}) -- Rusted Keys to the Junkheap Drifter
}}); -- Rustfeather

nodes[82287300] = Rare({id=155583, quest=56737, note=L["scrapclaw_note"], rewards={
    Achievement({id=13470, criteria=45691}), -- Kill
    Transmog({item=170470, slot=L["shield"]}) -- Reinforced Grease Deflector
}}); -- Scrapclaw

nodes[19127975] = Rare({id=150937, quest=55545, note=nil, rewards={
    Achievement({id=13470, criteria=45133}), -- Kill
    Item({item=168063, quest=55065}) -- Blueprint: Rustbolt Kegerator
}}); -- Seaspit

nodes[81852708] = Rare({id=153000, quest=55810, note=L["sparkqueen_note"], rewards={
    Achievement({id=13470, criteria=45134}) -- Kill
}}); -- Sparkqueen P'Emp

nodes[26257806] = Rare({id=153226, quest=55854, note=nil, rewards={
    Achievement({id=13470, criteria=45154}), -- Kill
    Item({item=168062, quest=55064}), -- Blueprint: Rustbolt Gramophone
    Item({item=169690, quest=56517}), -- Vinyl: Battle of Gnomeregan
    Item({item=169689, quest=56516}), -- Vinyl: Mimiron's Brainstorm
    Item({item=169692, quest=56519}) -- Vinyl: Triumph of Gnomeregan
}}); -- Steel Singer Freza

nodes[80962019] = Rare({id=155060, quest=56419, note=L["doppel_note"], label=L["doppel_gang"], rewards={
    Achievement({id=13470, criteria=45433}) -- Kill
}}); -- The Doppel Gang

nodes[68434776] = Rare({id=152113, quest=55858, note=L["drill_rig"]..'(DR-CC88).', rewards={
    Achievement({id=13470, criteria=45153}), -- Kill
    Item({item=169691, quest=56518}), -- Vinyl: Depths of Ulduar
    Pet({id=2753, item=169886}) -- Spraybot 0D
}}); -- The Kleptoboss

nodes[57335827] = Rare({id=154225, quest=56182, future=2, note=L["rusty_note"], rewards={
    Achievement({id=13470, criteria=45374}), -- Kill
    Toy({item=169347}), -- Judgment of Mechagon
    Transmog({item=170467, slot=L["1h_sword"]}) -- Whirring Chainblade
}}); -- The Rusty Prince

nodes[72344987] = Rare({id=151625, quest=55364, note=nil, rewards={
    Achievement({id=13470, criteria=45118}), -- Kill
    Item({item=167846, quest=55061}), -- Blueprint: Mechano-Treat
    Transmog({item=170467, slot=L["1h_sword"]}) -- Whirring Chainblade
}}); -- The Scrap King

nodes[57062218] = Rare({id=151940, quest=55538, note=L["cave_spawn"], rewards={
    Achievement({id=13470, criteria=45132}) -- Kill
}}); -- Uncle T'Rogg

nodes[53824933] = Rare({id=150394, quest=55546, future=2, note=L["vaultbot_note"], rewards={
    Achievement({id=13470, criteria=45158}), -- Kill
    Item({item=167843, quest=55058}), -- Blueprint: Vaultbot Key
    Item({item=167796, quest=55455}), -- Paint Vial: Mechagon Gold
    Pet({id=2766, item=170072}) -- Armored Vaultbot
}}); -- Armored Vaultbot

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

nodes[64706460] = PetBattle({id=154922}) -- Gnomefeaster
nodes[60704650] = PetBattle({id=154923}) -- Sputtertude
nodes[60605690] = PetBattle({id=154924}) -- Goldenbot XD
nodes[59205090] = PetBattle({id=154925}) -- Creakclank
nodes[65405770] = PetBattle({id=154926}) -- CK-9 Micro-Oppression Unit
nodes[51104540] = PetBattle({id=154927}) -- Unit 35
nodes[39504010] = PetBattle({id=154928}) -- Unit 6
nodes[72107290] = PetBattle({id=154929}) -- Unit 17

-------------------------------------------------------------------------------
-------------------------------- LOCKED CHESTS --------------------------------
-------------------------------------------------------------------------------

-- All chests have a chance to drop
RED_PAINT = Item({item=170146, quest=56907}) -- Paint Bottle: Nukular Red

-- Recently it looks like these are in fixed spawns compared to when 8.2 hit
nodes[23195699] = Treasure({label=L["iron_chest"], note=L["iron_chest_note"], rewards={RED_PAINT}})
nodes[13228581] = Treasure({label=L["iron_chest"], note=L["iron_chest_note"], rewards={RED_PAINT}})
nodes[19018086] = Treasure({label=L["iron_chest"], note=L["iron_chest_note"], rewards={RED_PAINT}})
nodes[30775964] = Treasure({label=L["iron_chest"], note=L["iron_chest_note"], rewards={RED_PAINT}})
nodes[20537120] = Treasure({label=L["msup_chest"], note=L["msup_chest_note"], rewards={RED_PAINT}})
nodes[18357618] = Treasure({label=L["rust_chest"], note=L["rust_chest_note"], rewards={RED_PAINT}})
nodes[25267825] = Treasure({label=L["rust_chest"], note=L["rust_chest_note"], rewards={RED_PAINT}})
nodes[23988441] = Treasure({label=L["rust_chest"], note=L["rust_chest_note"], rewards={RED_PAINT}})

-------------------------------------------------------------------------------
------------------------------ MECHANIZED CHESTS ------------------------------
-------------------------------------------------------------------------------

local MechChest = Class('MechChest', Treasure)

MechChest.label = L["mech_chest"]
MechChest.rewards = {
    Achievement({id=13708, criteria={45773,45781,45779,45780,45785}}), -- Most Minis Wins
    Item({item=167790, quest=55451}), -- Paint Vial: Fireball Red
    Item({item=169850, weekly=57133}) -- Azeroth Mini Pack: Mechagon
}

local TREASURE1 = MechChest({quest=55547, icon='chest_blue'})
local TREASURE2 = MechChest({quest=55548, icon='chest_brown'})
local TREASURE3 = MechChest({quest=55549, icon='chest_orange'})
local TREASURE4 = MechChest({quest=55550, icon='chest_yellow'})
local TREASURE5 = MechChest({quest=55551, icon='chest_camo', future=1})
local TREASURE6 = MechChest({quest=55552, icon='chest_lime'})
local TREASURE7 = MechChest({quest=55553, icon='chest_red'})
local TREASURE8 = MechChest({quest=55554, icon='chest_purple'})
local TREASURE9 = MechChest({quest=55555, icon='chest_teal'})
local TREASURE10 = MechChest({quest=55556, icon='chest_lblue'})

-- object 325659
nodes[43304977] = TREASURE1
nodes[49223021] = TREASURE1
nodes[52115326] = TREASURE1
nodes[53254190] = TREASURE1
nodes[56973861] = TREASURE1
-- object 325660
nodes[20617141] = TREASURE2
nodes[30785183] = TREASURE2
nodes[35683833] = TREASURE2
nodes[40155409] = TREASURE2
-- object 325661
nodes[59946357] = TREASURE3
nodes[65866460] = TREASURE3
nodes[67075645] = TREASURE3
nodes[73515334] = TREASURE3
nodes[80374838] = TREASURE3
-- object 325662
nodes[65555284] = TREASURE4
nodes[72594733] = TREASURE4
nodes[73014950] = TREASURE4
nodes[76215286] = TREASURE4
nodes[81196149] = TREASURE4
-- object 325663
nodes[56665739] = TREASURE5
nodes[58634160] = TREASURE5
nodes[61583230] = TREASURE5
nodes[64365961] = TREASURE5
nodes[70654796] = TREASURE5
-- object 325664
nodes[66432227] = TREASURE6
nodes[64092627] = TREASURE6
nodes[56782918] = TREASURE6
nodes[57142283] = TREASURE6
nodes[55612404] = TREASURE6
nodes[50662858] = TREASURE6
-- object 325665
nodes[67322289] = TREASURE7
nodes[80691868] = TREASURE7
nodes[85752824] = TREASURE7
nodes[86232042] = TREASURE7
nodes[88732015] = TREASURE7
-- object 325666
nodes[48367595] = TREASURE8
nodes[57258202] = TREASURE8
nodes[62297390] = TREASURE8
nodes[66767759] = TREASURE8
-- object 325667
nodes[63626715] = TREASURE9
nodes[72126545] = TREASURE9
nodes[76516601] = TREASURE9
nodes[81167231] = TREASURE9
nodes[85166335] = TREASURE9
-- object 325668
nodes[24796526] = TREASURE10
nodes[20537696] = TREASURE10
nodes[21788303] = TREASURE10
nodes[12088568] = TREASURE10

-------------------------------------------------------------------------------
-------------------------------- MISCELLANEOUS --------------------------------
-------------------------------------------------------------------------------

nodes[53486145] = Quest({quest=55743, requires=56117, daily=true, minimap=false, scale=1.8, rewards={
    Achievement({id=13708, criteria={45772,45775,45776,45777,45778}}), -- Most Minis Wins
    Item({item=169848, weekly=57134}), -- Azeroth Mini Pack: Bondo's Yard
}})

-------------------------------------------------------------------------------

local RegRig = Class('RegRig', Node)

function RegRig.getters:rlabel ()
    local G, GR, N, H = ns.status.Green, ns.status.Gray, L['normal'], L['hard']
    local normal = IsQuestFlaggedCompleted(55847) and G(N) or GR(N)
    local hard = IsQuestFlaggedCompleted(55848) and G(H) or GR(H)
    return normal..' '..hard
end

nodes[69976201] = RegRig({icon="peg_blue", scale=2, label=L["rec_rig"], rewards={
    Achievement({id=13708, criteria={45773,45781,45779,45780,45785}}), -- Most Minis Wins
    Item({item=169850, note=L["normal"], weekly=57132}), -- Azeroth Mini Pack: Mechagon
    Item({item=168495, note=L["hard"], quest=55074}), -- Blueprint: Rustbolt Requisitions
    Pet({id=2721, item=169396}), -- Echoing Oozeling
    Pet({id=2756, item=169879}) -- Irradiated Elementaling
}, note=L["rec_rig_note"]}) -- Reclamation Rig ???=56079

-------------------------------------------------------------------------------

ns.maps[map.id] = map
