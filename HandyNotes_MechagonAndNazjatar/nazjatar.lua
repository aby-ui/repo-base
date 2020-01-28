-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.Map
local isinstance = ns.isinstance

local Node = ns.node.Node
local Cave = ns.node.Cave
local NPC = ns.node.NPC
local PetBattle = ns.node.PetBattle
local Rare = ns.node.Rare
local Supply = ns.node.Supply
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Quest = ns.reward.Quest
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local options = ns.options.args.VisibilityGroup.args
local defaults = ns.optionDefaults.profile

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local map = Map({ id=1355 })
local nodes = map.nodes

function map:prepare ()
    self.phased = self.intros[ns.faction]:done()
end

function map:enabled (node, coord, minimap)
    if not Map.enabled(self, node, coord, minimap) then return false end

    -- always show the intro helper nodes, and hide all other nodes if we're
    -- not phased yet
    if node.icon == 'quest_yellow' then return true end
    if not self.phased and node.icon ~= 'quest_yellow' then return false end

    local profile = ns.addon.db.profile
    if isinstance(node, Treasure) then return profile.treasure_nazjatar end
    if isinstance(node, Rare) then return profile.rare_nazjatar end
    if isinstance(node, Supply) then return profile.supply_nazjatar end
    if isinstance(node, Cave) then return profile.cave_nazjatar end
    if isinstance(node, PetBattle) then return profile.pet_nazjatar end
    if node.id == 151782 or node.label == L["slimy_cocoon"] then
        return profile.slime_nazjatar
    end
    if node.label == L["cat_figurine"] then
        return profile.cats_nazjatar
    end
    if node.label == L["mardivas_lab"] or node.label == L["murloco"] then
        return profile.misc_nazjatar
    end
    return false
end

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

defaults['treasure_nazjatar'] = true;
defaults['rare_nazjatar'] = true;
defaults['pet_nazjatar'] = true;
defaults['supply_nazjatar'] = true;
defaults['slime_nazjatar'] = true;
defaults['cats_nazjatar'] = true;
defaults['cave_nazjatar'] = true;
defaults['misc_nazjatar'] = true;

options.groupNazjatar = {
    type = "header",
    name = L["Nazjatar"],
    order = 10,
};

options.treasureNazjatar = {
    type = "toggle",
    arg = "treasure_nazjatar",
    name = L["options_toggle_treasures"],
    desc = L["options_toggle_treasures_nazj"],
    order = 11,
    width = "normal",
};

options.supplyNazjatar = {
    type = "toggle",
    arg = "supply_nazjatar",
    name = L["options_toggle_supplies"],
    desc = L["options_toggle_supplies_desc"],
    order = 12,
    width = "normal",
};

options.rareNazjatar = {
    type = "toggle",
    arg = "rare_nazjatar",
    name = L["options_toggle_rares"],
    desc = L["options_toggle_rares_desc"],
    order = 13,
    width = "normal",
};

options.petNazjatar = {
    type = "toggle",
    arg = "pet_nazjatar",
    name = L["options_toggle_battle_pets"],
    desc = L["options_toggle_battle_pets_desc"],
    order = 14,
    width = "normal",
};

options.slimesNazjatar = {
    type = "toggle",
    arg = "slime_nazjatar",
    name = L["options_toggle_slimes_nazj"],
    desc = L["options_toggle_slimes_nazj_desc"],
    order = 15,
    width = "normal",
};

options.catsNazjatar = {
    type = "toggle",
    arg = "cats_nazjatar",
    name = L["options_toggle_cats_nazj"],
    desc = L["options_toggle_cats_nazj_desc"],
    order = 16,
    width = "normal",
};

options.caveNazjatar = {
    type = "toggle",
    arg = "cave_nazjatar",
    name = L["options_toggle_caves"],
    desc = L["options_toggle_caves_desc"],
    order = 17,
    width = "normal",
};

options.miscNazjatar = {
    type = "toggle",
    arg = "misc_nazjatar",
    name = L["options_toggle_misc"],
    desc = L["options_toggle_misc_nazj"],
    order = 18,
    width = "normal",
};

-------------------------------------------------------------------------------
------------------------------------ INTRO ------------------------------------
-------------------------------------------------------------------------------

local Intro = Class('Intro', Node)

Intro.note = L["naz_intro_note"]
Intro.icon = 'quest_yellow'
Intro.scale = 3

function Intro.getters:label ()
    return GetAchievementCriteriaInfo(13710, 1) -- Welcome to Nazjatar
end

nodes[11952801] = Intro({quest=56156, faction='Alliance', rewards={
    -- The Wolf's Offensive => A Way Home
    Quest({id={56031,56043,55095,54969,56640,56641,56642,56643,56644,55175,54972}}),
    -- Essential Empowerment => Scouting the Palace
    Quest({id={55851,55533,55374,55400,55407,55425,55497,55618,57010,56162,56350}}),
    -- The Lost Shaman => A Tempered Blade
    Quest({id={55361,55362,55363,56156}})
}})

nodes[11952802] = Intro({quest=55500, faction='Horde', rewards={
    -- The Warchief's Order => A Way Home
    Quest({id={56030,56044,55054,54018,54021,54012,55092,56063,54015,56429,55094,55053}}),
    -- Essential Empowerment => Scouting the Palace
    Quest({id={55851,55533,55374,55400,55407,55425,55497,55618,57010,56161,55481}}),
    -- Settling In => Save A Friend
    Quest({id={55384,55385,55500}})
}})

map.intros = { Alliance = nodes[11952801], Horde = nodes[11952802] }

ns.addon:RegisterEvent('QUEST_TURNED_IN', function (_, questID)
    if questID == 56156 or questID == 55500 then
        C_Timer.After(1, function()
            ns.addon:Refresh();
        end);
    end
end)

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

nodes[52394183] = Rare({id=152415, quest=56279, note=L["alga_note"], rewards={
    Achievement({id=13691, criteria=45519}), -- Kill
    Achievement({id=13692, criteria=46083}) -- Blind Eye (170189)
}}); -- Alga the Eyeless

nodes[66443875] = Rare({id=152416, quest=56280, note=L["allseer_note"], rewards={
    Achievement({id=13691, criteria=45520}) -- Kill
}}); -- Allseer Oma'kill

nodes[58605329] = Rare({id=152566, quest=56281, note=L["anemonar_note"], rewards={
    Achievement({id=13691, criteria=45522}), -- Kill
    Achievement({id=13692, criteria={46088,46089}}), -- Ancient Reefwalker Bark, Reefwalker Bark
    Item({item=170184, weekly=57140}) -- Ancient Reefwalker Bark
}}); -- Anemonar

nodes[73985395] = Rare({id=152361, quest=56282, note=L["banescale_note"], rewards={
    Achievement({id=13691, criteria=45524}), -- Kill
    Achievement({id=13692, criteria=46093}) -- Snapdragon Scent Gland
}}); -- Banescale the Packfather

nodes[37378256] = Rare({id=152712, quest=56269, note=L["cave_spawn"], rewards={
    Achievement({id=13691, criteria=45525}), -- Kill
    Pet({id=2682, item=169372}) -- Necrofin Tadpole
}}); -- Blindlight

nodes[40790735] = Rare({id=152464, quest=56283, note=L["cave_spawn"], rewards={
    Achievement({id=13691, criteria=45527}), -- Kill
    Pet({id=2690, item=169356}) -- Caverndark Nightmare
}}); -- Caverndark Terror

nodes[49208875] = Rare({id=152556, quest=56270, note=L["ucav_spawn"], rewards={
    Achievement({id=13691, criteria=45528}), -- Kill
    Achievement({id=13692, criteria=46101}), -- Eel Filet
}}); -- Chasm-Haunter

nodes[57074363] = Rare({id=152291, quest=56272, note=L["cora_spawn"], rewards={
    Achievement({id=13691, criteria=45530}), -- Kill
    Achievement({id=13692, criteria=46096}) -- Fathom Ray Wing
}}); -- Deepglider

nodes[64543531] = Rare({id=152414, quest=56284, note=L["elderunu_note"], rewards={
    Achievement({id=13691, criteria=45531}) -- Kill
}}); -- Elder Unu

nodes[51757487] = Rare({id=152555, quest=56285, note=nil, rewards={
    Achievement({id=13691, criteria=45532}), -- Kill
    Pet({id=2693, item=169359}) -- Spawn of Nalaada
}}); -- Elderspawn Nalaada

nodes[36044496] = Rare({id=152553, quest=56273, note=L["area_spawn"], rewards={
    Achievement({id=13691, criteria=45533}), -- Kill
    Achievement({id=13692, criteria=46092}) -- Razorshell
}}); -- Garnetscale

nodes[45715170] = Rare({id=152448, quest=56286, note=L["glimmershell_note"], rewards={
    Achievement({id=13691, criteria=45534}), -- Kill
    Achievement({id=13692, criteria=46099}), -- Giant Crab Leg
    Pet({id=2686, item=169352}) -- Pearlescent Glimmershell
}}); -- Iridescent Glimmershell

nodes[50056991] = Rare({id=152567, quest=56287, note=L["kelpwillow_note"], rewards={
    Achievement({id=13691, criteria=45535}), -- Kill
    Achievement({id=13692, criteria={46088,46089}}), -- Ancient Reefwalker Bark, Reefwalker Bark
    Item({item=170184, weekly=57140}) -- Ancient Reefwalker Bark
}}); -- Kelpwillow

nodes[29412899] = Rare({id=152323, quest=55671, note=L["gakula_note"], rewards={
    Achievement({id=13691, criteria=45536}), -- Kill
    Pet({id=2681, item=169371}) -- Murgle
}}); -- King Gakula

nodes[78132501] = Rare({id=152397, quest=56288, note=L["oronu_note"], rewards={
    Achievement({id=13691, criteria=45539}), -- Kill
    Achievement({id=13692, criteria={46088,46089}}), -- Ancient Reefwalker Bark, Reefwalker Bark
    Item({item=170184, weekly=57140}) -- Ancient Reefwalker Bark
}}); -- Oronu

nodes[42728740] = Rare({id=152681, quest=56289, note=nil, rewards={
    Achievement({id=13691, criteria=45540}), -- Kill
    Pet({id=2701, item=169367}) -- Seafury
}}); -- Prince Typhonus

nodes[42997551] = Rare({id=152682, quest=56290, note=nil, rewards={
    Achievement({id=13691, criteria=45541}), -- Kill
    Pet({id=2702, item=169368}) -- Stormwrath
}}); -- Prince Vortran

nodes[35554141] = Rare({id=152548, quest=56292, note=L["matriarch_note"], rewards={
    Achievement({id=13691, criteria=45545}), -- Kill
    Achievement({id=13692, criteria=46087}), -- Intact Naga Skeleton
    Pet({id=2704, item=169370}) -- Scalebrood Hydra
}}); -- Scale Matriarch Gratinax

nodes[27193708] = Rare({id=152545, quest=56293, note=L["matriarch_note"], rewards={
    Achievement({id=13691, criteria=45546}), -- Kill
    Achievement({id=13692, criteria=46087}), -- Intact Naga Skeleton
    Pet({id=2704, item=169370}) -- Scalebrood Hydra
}}); -- Scale Matriarch Vynara

nodes[28604664] = Rare({id=152542, quest=56294, note=L["matriarch_note"], rewards={
    Achievement({id=13691, criteria=45547}), -- Kill
    Achievement({id=13692, criteria=46087}), -- Intact Naga Skeleton
    Pet({id=2704, item=169370}) -- Scalebrood Hydra
}}); -- Scale Matriarch Zodia

nodes[62740809] = Rare({id=152552, quest=56295, note=L["cave_spawn"], rewards={
    Achievement({id=13691, criteria=45548}), -- Kill
    Toy({item=170187}) -- Shadescale
}}); -- Shassera

nodes[39601700] = Rare({id=153658, quest=56296, note=L["area_spawn"], rewards={
    Achievement({id=13691, criteria=45549}), -- Kill
    Achievement({id=13692, criteria={46090,46091}}) -- Voltscale Shield, Tidal Guard
}}); -- Shiz'narasz the Consumer

nodes[71365456] = Rare({id=152359, quest=56297, note=nil, rewards={
    Achievement({id=13691, criteria=45550}), -- Kill
    Achievement({id=13692, criteria=46093}) -- Snapdragon Scent Gland
}}); -- Siltstalker the Packmother

nodes[59704791] = Rare({id=152290, quest=56298, note=L["cora_spawn"], rewards={
    Achievement({id=13691, criteria=45551}), -- Kill
    Achievement({id=13692, criteria=46096}), -- Fathom Ray Wing
    Mount({id=1257, item=169163}) -- Silent Glider
}}); -- Soundless

nodes[62462964] = Rare({id=153898, quest=56122, note=L["tidelord_note"], rewards={
    Achievement({id=13691, criteria=45553}) -- Kill
}}); -- Tidelord Aquatus

nodes[57962648] = Rare({id=153928, quest=56123, note=L["tidelord_note"], rewards={
    Achievement({id=13691, criteria=45554}) -- Kill
}}); -- Tidelord Dispersius

nodes[65872243] = Rare({id=154148, quest=56106, note=L["tidemistress_note"], rewards={
    Achievement({id=13691, criteria=45555}), -- Kill
    Toy({item=170196}) -- Shirakess Warning Sign
}}); -- Tidemistress Leth'sindra

nodes[66964817] = Rare({id=152360, quest=56278, note=L["area_spawn"], rewards={
    Achievement({id=13691, criteria=45556}), -- Kill
    Achievement({id=13692, criteria=46094}) -- Alpha Fin
}}); -- Toxigore the Alpha

nodes[31282935] = Rare({id=152568, quest=56299, note=L["urduu_note"], rewards={
    Achievement({id=13691, criteria=45557}), -- Kill
    Achievement({id=13692, criteria={46088,46089}}), -- Ancient Reefwalker Bark, Reefwalker Bark
    Item({item=170184, weekly=57140}) -- Ancient Reefwalker Bark
}}); -- Urduu

nodes[67243458] = Rare({id=151719, quest=56300, note=L["voice_deeps_notes"], rewards={
    Achievement({id=13691, criteria=45558}), -- Kill
    Achievement({id=13692, criteria=46086}) -- Abyss Pearl
}}); -- Voice in the Deeps

nodes[36931120] = Rare({id=150191, quest=55584, note=L["avarius_note"], rewards={
    Pet({id=2706, item=169373}) -- Brinestone Algan
}}); -- Avarius

nodes[54664179] = Rare({id=149653, quest=55366, note=L["lasher_note"], rewards={
    Pet({id=2708, item=169375}) -- Coral Lashling
}}); -- Carnivorous Lasher

nodes[48002427] = Rare({id=150468, quest=55603, note=L["vorkoth_note"], rewards={
    Pet({id=2709, item=169376}) -- Skittering Eel
}}); -- Vor'koth

-------------------------------------------------------------------------------
---------------------------------- ZONE RARES ---------------------------------
-------------------------------------------------------------------------------

local start = 09452400;
local function coord(x, y)
    return start + x*2500000 + y*400;
end

nodes[coord(0,0)] = Rare({id=152794, quest=56268, minimap=false, note=L["zone_spawn"], rewards={
    Achievement({id=13691, criteria=45521}), -- Kill
    Pet({id=2697, item=169363}) -- Amethyst Softshell
}}); -- Amethyst Spireshell

nodes[coord(1,0)] = Rare({id=152756, quest=56271, minimap=false, note=L["zone_spawn"], rewards={
    Achievement({id=13691, criteria=45529}), -- Kill
    Pet({id=2695, item=169361}) -- Daggertooth Frenzy
}}); -- Daggertooth Terror

nodes[coord(2,0)] = Rare({id=144644, quest=56274, minimap=false, note=L["zone_spawn"], rewards={
    Achievement({id=13691, criteria=45537}), -- Kill
    Achievement({id=13692, criteria=46098}), -- Brightspine Shell
    Pet({id=2700, item=169366}) -- Wriggler
}}); -- Mirecrawler

nodes[coord(0,1)] = Rare({id=152465, quest=56275, minimap=false, note=L["needle_note"], rewards={
    Achievement({id=13691, criteria=45538}), -- Kill
    Achievement({id=13692, criteria=46099}), -- Giant Crab Leg
    Pet({id=2689, item=169355}) -- Chitterspine Needler
}}); -- Needlespine

nodes[coord(1,2)] = Rare({id=150583, quest=56291, minimap=false, note=L["zone_spawn"]..' '..L["rockweed_note"], rewards={
    Achievement({id=13691, criteria=45542}), -- Kill
    Pet({id=2707, item=169374}) -- Budding Algan
}}); -- Rockweed Shambler

nodes[coord(1,1)] = Rare({id=151870, quest=56276, minimap=false, note=L["sandcastle_note"], rewards={
    Achievement({id=13691, criteria=45543}), -- Kill
    Pet({id=2703, item=169369}) -- Sandkeep
}}); -- Sandcastle

nodes[coord(2,1)] = Rare({id=152795, quest=56277, minimap=false, note=L["east_spawn"], rewards={
    Achievement({id=13691, criteria=45544}), -- Kill
    Achievement({id=13692, criteria=46099}), -- Giant Crab Leg
    Pet({id=2684, item=169350}) -- Glittering Diamondshell
}}); -- Sandclaw Stoneshell

-------------------------------------------------------------------------------
------------------------------------ CAVES ------------------------------------
-------------------------------------------------------------------------------

nodes[39897717] = Cave({parent=nodes[37378256], label=L["blindlight_cave"]});
nodes[42261342] = Cave({parent=nodes[40790735], label=L["caverndark_cave"]});
nodes[47588538] = Cave({parent=nodes[49208875], label=L["chasmhaunt_cave"]});
nodes[63081189] = Cave({parent=nodes[62740809], label=L["shassera_cave"]});

-------------------------------------------------------------------------------
------------------------------------ SLIMES -----------------------------------
-------------------------------------------------------------------------------

local SLIME_PETS = {
    Pet({id=2762, item=167809}), -- Slimy Darkhunter
    Pet({id=2758, item=167808}), -- Slimy Eel
    Pet({id=2761, item=167807}), -- Slimy Fangtooth
    Pet({id=2763, item=167810}), -- Slimy Hermit Crab
    Pet({id=2760, item=167806}), -- Slimy Octopode
    Pet({id=2757, item=167805}), -- Slimy Otter
    Pet({id=2765, item=167804})  -- Slimy Sea Slug
};

-- first quest is daily, second quest means done and gone until weekly reset
nodes[32773951] = NPC({id=151782, icon="slime", quest={55430,55473},
    note=L["ravenous_slime_note"], rewards=SLIME_PETS});
nodes[45692409] = NPC({id=151782, icon="slime", quest={55429,55472},
    note=L["ravenous_slime_note"], rewards=SLIME_PETS});
nodes[54894868] = NPC({id=151782, icon="slime", quest={55427,55470},
    note=L["ravenous_slime_note"], rewards=SLIME_PETS});
nodes[71722569] = NPC({id=151782, icon="slime", quest={55428,55471},
    note=L["ravenous_slime_note"], rewards=SLIME_PETS});

-- once the second quest is true, the eggs should be displayed
nodes[32773952] = Node({icon="green_egg", quest=55478, requires=55473,
    label=L["slimy_cocoon"], note=L["slimy_cocoon_note"], rewards=SLIME_PETS});
nodes[45692410] = Node({icon="green_egg", quest=55477, requires=55472,
    label=L["slimy_cocoon"], note=L["slimy_cocoon_note"], rewards=SLIME_PETS});
nodes[54894869] = Node({icon="green_egg", quest=55475, requires=55470,
    label=L["slimy_cocoon"], note=L["slimy_cocoon_note"], rewards=SLIME_PETS});
nodes[71722570] = Node({icon="green_egg", quest=55476, requires=55471,
    label=L["slimy_cocoon"], note=L["slimy_cocoon_note"], rewards=SLIME_PETS});

ns.addon:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED', function (...)
    -- Watch for a spellcast event that signals the slime was fed.
    -- https://www.wowhead.com/spell=293775/schleimphage-feeding-tracker
    local _, source, _, spellID = ...
    if (source == 'player' and spellID == 293775) then
        C_Timer.After(1, function()
            ns.addon:Refresh();
        end);
    end
end)

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

-- Arcane Chests
nodes[34454040] = Treasure({quest=55954, label=L["arcane_chest"], note=L["arcane_chest_01"]});
nodes[49576450] = Treasure({quest=55949, label=L["arcane_chest"], note=L["arcane_chest_02"]});
nodes[85303860] = Treasure({quest=55938, label=L["arcane_chest"], note=L["arcane_chest_03"]});
nodes[37906050] = Treasure({quest=55957, label=L["arcane_chest"], note=L["arcane_chest_04"]});
nodes[79502720] = Treasure({quest=55942, label=L["arcane_chest"], note=L["arcane_chest_05"]});
nodes[44704890] = Treasure({quest=55947, label=L["arcane_chest"], note=L["arcane_chest_06"]});
nodes[34604360] = Treasure({quest=55952, label=L["arcane_chest"], note=L["arcane_chest_07"]});
nodes[26003240] = Treasure({quest=55953, label=L["arcane_chest"], note=L["arcane_chest_08"]});
nodes[50605000] = Treasure({quest=55955, label=L["arcane_chest"], note=L["arcane_chest_09"]});
nodes[64303330] = Treasure({quest=55943, label=L["arcane_chest"], note=L["arcane_chest_10"]});
nodes[52804980] = Treasure({quest=55945, label=L["arcane_chest"], note=L["arcane_chest_11"]});
nodes[48508740] = Treasure({quest=55951, label=L["arcane_chest"], note=L["arcane_chest_12"]});
nodes[43405820] = Treasure({quest=55948, label=L["arcane_chest"], note=L["arcane_chest_13"]});
nodes[73203580] = Treasure({quest=55941, label=L["arcane_chest"], note=L["arcane_chest_14"]});
nodes[80402980] = Treasure({quest=55939, label=L["arcane_chest"], note=L["arcane_chest_15"]});
nodes[58003500] = Treasure({quest=55946, label=L["arcane_chest"], note=L["arcane_chest_16"]});
nodes[74805320] = Treasure({quest=55940, label=L["arcane_chest"], note=L["arcane_chest_17"]});
nodes[39804920] = Treasure({quest=55956, label=L["arcane_chest"], note=L["arcane_chest_18"]});
nodes[38707440] = Treasure({quest=55950, label=L["arcane_chest"], note=L["arcane_chest_19"]});
nodes[56303380] = Treasure({quest=55944, label=L["arcane_chest"], note=L["arcane_chest_20"]});

-- Glowing Arcane Chests
nodes[37900640] = Treasure({quest=55959, icon="shootbox_blue", scale=2, label=L["glowing_chest"], note=L["glowing_chest_1"]})
nodes[43951693] = Treasure({quest=55963, icon="shootbox_blue", scale=2, label=L["glowing_chest"], note=L["glowing_chest_2"]})
nodes[24803520] = Treasure({quest=56912, icon="shootbox_blue", scale=2, label=L["glowing_chest"], note=L["glowing_chest_3"]})
nodes[55701450] = Treasure({quest=55961, icon="shootbox_blue", scale=2, label=L["glowing_chest"], note=L["glowing_chest_4"]})
nodes[61402290] = Treasure({quest=55958, icon="shootbox_blue", scale=2, label=L["glowing_chest"], note=L["glowing_chest_5"]})
nodes[64102860] = Treasure({quest=55962, icon="shootbox_blue", scale=2, label=L["glowing_chest"], note=L["glowing_chest_6"]})
nodes[37201920] = Treasure({quest=55960, icon="shootbox_blue", scale=2, label=L["glowing_chest"], note=L["glowing_chest_7"]})
nodes[80493194] = Treasure({quest=56547, icon="shootbox_blue", scale=2, label=L["glowing_chest"], note=L["glowing_chest_8"]})

-------------------------------------------------------------------------------
-------------------------------- CAT FIGURINES --------------------------------
-------------------------------------------------------------------------------

nodes[28752910] = Node({quest=56983, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_01"]})
nodes[71342369] = Node({quest=56988, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_02"]})
nodes[73582587] = Node({quest=56992, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_03"]})
nodes[58212198] = Node({quest=56990, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_04"]})
nodes[61092681] = Node({quest=56984, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_05"]})
nodes[40168615] = Node({quest=56987, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_06"]})
nodes[59093053] = Node({quest=56985, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_07"]})
nodes[55362715] = Node({quest=56986, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_08"]})
nodes[61641079] = Node({quest=56991, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_09"]})
nodes[38004925] = Node({quest=56989, icon="emerald_cat", label=L["cat_figurine"], note=L["cat_figurine_10"]})

ns.addon:RegisterEvent('CRITERIA_EARNED', function (...)
    -- Watch for criteria events that signal the figurine was clicked
    local _, achievement = ...
    if achievement == 13836 then
        C_Timer.After(1, function()
            ns.addon:Refresh();
        end);
    end
end)

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

nodes[34702740] = PetBattle({id=154910, note=L["in_cave"]}) -- Prince Wiggletail
nodes[71905110] = PetBattle({id=154911}) -- Chomp
nodes[58304810] = PetBattle({id=154912}) -- Silence
nodes[42201400] = PetBattle({id=154913}) -- Shadowspike Lurker
nodes[50605030] = PetBattle({id=154914, note=L["in_cave"]}) -- Pearlhusk Crawler
nodes[51307500] = PetBattle({id=154915}) -- Elderspawn of Nalaada
nodes[29604970] = PetBattle({id=154916, note=L["in_cave"]}) -- Ravenous Scalespawn
nodes[56400810] = PetBattle({id=154917, note=L["in_cave"]}) -- Mindshackle
nodes[46602800] = PetBattle({id=154918, note=L["in_cave"]}) -- Kelpstone
nodes[37501670] = PetBattle({id=154919, note=L["in_cave"]}) -- Voltgorger
nodes[61472290] = PetBattle({id=154920, note=L["in_cave"]}) -- Frenzied Knifefang
nodes[28102670] = PetBattle({id=154921, note=L["in_cave"]}) -- Giant Opaline Conch

-------------------------------------------------------------------------------
------------------------------ WAR SUPPLY CHESTS ------------------------------
-------------------------------------------------------------------------------

local ASSASSIN_ACHIEVE = Achievement({id=13720, criteria={
    {id=45790, suffix=L["assassin_looted"]}
}});

nodes[47864647] = Supply({label=L["supply_chest"], rewards={ASSASSIN_ACHIEVE}}); -- north basin
nodes[47285170] = Supply({label=L["supply_chest"], rewards={ASSASSIN_ACHIEVE}}); -- south basin
nodes[45237040] = Supply({label=L["supply_chest"], rewards={ASSASSIN_ACHIEVE}}); -- south of newhome
nodes[33493889] = Supply({label=L["supply_chest"], rewards={ASSASSIN_ACHIEVE}}); -- ashen strand (also 33283441?)
nodes[59663755] = Supply({label=L["supply_chest"], rewards={ASSASSIN_ACHIEVE}}); -- coral forest
nodes[76873699] = Supply({label=L["supply_chest"], rewards={ASSASSIN_ACHIEVE}}); -- zin-azshari

-------------------------------------------------------------------------------
-------------------------------- MISCELLANEOUS --------------------------------
-------------------------------------------------------------------------------

nodes[60683221] = Node({quest=55121, icon="portal_blue", scale=1.5, label=L["mardivas_lab"], rewards={
    Achievement({id=13699, criteria={ -- Periodic Destruction
        {id=45678, note=' ('..L["no_reagent"]..')'}, -- Arcane Amalgamation
        {id=45679, note=' ('..L["swater"]..')'}, -- Watery Amalgamation
        {id=45680, note=' ('..L["sfire"]..')'}, -- Burning Amalgamation
        {id=45681, note=' ('..L["searth"]..')'}, -- Dusty Amalgamation
        {id=45682, note=' ('..L["swater"].." + "..L["gearth"]..')'}, -- Zomera
        {id=45683, note=' ('..L["swater"].." + "..L["gfire"]..')'}, -- Omus
        {id=45684, note=' ('..L["swater"].." + "..L["gwater"]..')'}, -- Osgen
        {id=45685, note=' ('..L["sfire"].." + "..L["gearth"]..')'}, -- Moghiea
        {id=45686, note=' ('..L["sfire"].." + "..L["gwater"]..')'}, -- Xue
        {id=45687, note=' ('..L["sfire"].." + "..L["gfire"]..')'}, -- Ungormath
        {id=45688, note=' ('..L["searth"].." + "..L["gwater"]..')'}, -- Spawn of Salgos
        {id=45689, note=' ('..L["searth"].." + "..L["gearth"]..')'}, -- Herald of Salgos
        {id=45690, note=' ('..L["searth"].." + "..L["gfire"]..')'} -- Salgos the Eternal
    }}),
    Transmog({item=170138, slot=L["offhand"], note=L["Watery"]}), -- Scroll of Violent Tides
    Transmog({item=170126, slot=L["bow"], note=L["Burning"]}), -- Igneous Longbow
    Transmog({item=170383, slot=L["shield"], note=L["Dusty"]}), -- Coralspine Bulwark
    Transmog({item=170137, slot=L["dagger"], note=L["Zomera"]}), -- Azerite-Infused Crystal Flayer
    Transmog({item=170132, slot=L["1h_sword"], note=L["Omus"]}), -- Slicer of Omus
    Transmog({item=170130, slot=L["warglaives"], note=L["Osgen"]}), -- Glaive of Swells
    Transmog({item=170128, slot=L["staff"], note=L["Moghiea"]}), -- Majestic Shirakess Greatstaff
    Transmog({item=170127, slot=L["polearm"], note=L["Xue"]}), -- Pyroclastic Halberd
    Transmog({item=170131, slot=L["wand"], note=L["Ungormath"]}), -- Tidal Wand of Malevolence
    Transmog({item=170124, slot=L["2h_sword"], note=L["Spawn"]}), -- Coral-Sharpened Greatsword
    Transmog({item=170125, slot=L["fist"], note=L["Herald"]}), -- Behemoth Claw of the Abyss
    Transmog({item=170129, slot=L["1h_mace"], note=L["Salgos"]}) -- Salgos' Volatile Basher
}})

nodes[45993245] = Node({icon="diablo_murloc", label=L["murloco"], note=L["tentacle_taco"]})

-------------------------------------------------------------------------------

ns.maps[map.id] = map
