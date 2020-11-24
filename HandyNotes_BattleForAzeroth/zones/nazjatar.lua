-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.Map

local Collectible = ns.node.Collectible
local Node = ns.node.Node
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

local Arrow = ns.poi.Arrow
local POI = ns.poi.POI

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local map = Map({ id=1355, phased=false, settings=true })

function map:Prepare ()
    Map.Prepare(self)
    self.phased = self.intro:IsCompleted()
end

-------------------------------------------------------------------------------
------------------------------------ INTRO ------------------------------------
-------------------------------------------------------------------------------

local Intro = Class('Intro', ns.node.Intro)

Intro.note = L["naz_intro_note"]

function Intro.getters:label ()
    return GetAchievementCriteriaInfoByID(13709, 45756) -- Welcome to Nazjatar
end

if UnitFactionGroup('player') == 'Alliance' then
    map.intro = Intro({quest=56156, faction='Alliance', rewards={
        -- The Wolf's Offensive => A Way Home
        Quest({id={56031,56043,55095,54969,56640,56641,56642,56643,56644,55175,54972}}),
        -- Essential Empowerment => Scouting the Palace
        Quest({id={55851,55533,55374,55400,55407,55425,55497,55618,57010,56162,56350}}),
        -- The Lost Shaman => A Tempered Blade
        Quest({id={55361,55362,55363,56156}})
    }})
else
    map.intro = Intro({quest=55500, faction='Horde', rewards={
        -- The Warchief's Order => A Way Home
        Quest({id={56030,56044,55054,54018,54021,54012,55092,56063,54015,56429,55094,55053}}),
        -- Essential Empowerment => Scouting the Palace
        Quest({id={55851,55533,55374,55400,55407,55425,55497,55618,57010,56161,55481}}),
        -- Settling In => Save A Friend
        Quest({id={55384,55385,55500}})
    }})
end

map.nodes[11952801] = map.intro

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[52394183] = Rare({
    id=152415,
    quest=56279,
    note=L["alga_note"],
    rewards={
        Achievement({id=13691, criteria=45519}), -- Kill
        Achievement({id=13692, criteria=46083}) -- Blind Eye (170189)
    }
}) -- Alga the Eyeless

map.nodes[65603880] = Rare({
    id=152416,
    quest=56280,
    note=L["allseer_note"],
    rewards={
        Achievement({id=13691, criteria=45520}) -- Kill
    },
    pois={
        POI({65603880, 66204060, 67803700, 69604060, 71003460})
    }
}) -- Allseer Oma'kill

map.nodes[58605329] = Rare({
    id=152566,
    quest=56281,
    note=L["anemonar_note"],
    rewards={
        Achievement({id=13691, criteria=45522}), -- Kill
        Achievement({id=13692, criteria={46088,46089}}), -- Ancient Reefwalker Bark, Reefwalker Bark
        Item({item=170184, weekly=57140}) -- Ancient Reefwalker Bark
    }
}) -- Anemonar

map.nodes[36931120] = Rare({
    id=150191, quest=55584,
    note=L["avarius_note"],
    requires=ns.requirement.Item(167012),
    rewards={
        Pet({id=2706, item=169373}) -- Brinestone Algan
    }
}) -- Avarius

map.nodes[73985395] = Rare({
    id=152361,
    quest=56282,
    note=L["banescale_note"],
    rewards={
        Achievement({id=13691, criteria=45524}), -- Kill
        Achievement({id=13692, criteria=46093}) -- Snapdragon Scent Gland
    }
}) -- Banescale the Packfather

map.nodes[37378256] = Rare({
    id=152712,
    quest=56269,
    note=L["cave_spawn"],
    rewards={
        Achievement({id=13691, criteria=45525}), -- Kill
        Pet({id=2682, item=169372}) -- Necrofin Tadpole
    }, pois={
        POI({39897717}) -- Cave entrance
    }
}) -- Blindlight

map.nodes[54664179] = Rare({
    id=149653,
    quest=55366,
    note=L["lasher_note"],
    requires=ns.requirement.Item(166888),
    rewards={
        Pet({id=2708, item=169375}) -- Coral Lashling
    }
}) -- Carnivorous Lasher

map.nodes[40790735] = Rare({
    id=152464,
    quest=56283,
    note=L["cave_spawn"],
    rewards={
        Achievement({id=13691, criteria=45527}), -- Kill
        Pet({id=2690, item=169356}) -- Caverndark Nightmare
    }, pois={
        POI({42261342}) -- Cave entrance
    }
}) -- Caverndark Terror

map.nodes[49208875] = Rare({
    id=152556,
    quest=56270,
    note=L["ucav_spawn"],
    rewards={
        Achievement({id=13691, criteria=45528}), -- Kill
        Achievement({id=13692, criteria=46101}), -- Eel Filet
    }, pois={
        POI({47588538}) -- Cave entrance
    }
}) -- Chasm-Haunter

map.nodes[57074363] = Rare({
    id=152291,
    quest=56272,
    note=L["cora_spawn"],
    rewards={
        Achievement({id=13691, criteria=45530}), -- Kill
        Achievement({id=13692, criteria=46096}) -- Fathom Ray Wing
    }
}) -- Deepglider

map.nodes[64543531] = Rare({
    id=152414,
    quest=56284,
    note=L["elderunu_note"],
    rewards={
        Achievement({id=13691, criteria=45531}) -- Kill
    }
}) -- Elder Unu

map.nodes[51757487] = Rare({
    id=152555,
    quest=56285,
    rewards={
        Achievement({id=13691, criteria=45532}), -- Kill
        Pet({id=2693, item=169359}) -- Spawn of Nalaada
    }
}) -- Elderspawn Nalaada

map.nodes[36044496] = Rare({
    id=152553,
    quest=56273,
    note=L["area_spawn"],
    rewards={
        Achievement({id=13691, criteria=45533}), -- Kill
        Achievement({id=13692, criteria=46092}) -- Razorshell
    }
}) -- Garnetscale

map.nodes[43355507] = Rare({
    id=152448,
    quest=56286,
    note=L["glimmershell_note"],
    rewards={
        Achievement({id=13691, criteria=45534}), -- Kill
        Achievement({id=13692, criteria=46099}), -- Giant Crab Leg
        Pet({id=2686, item=169352}) -- Pearlescent Glimmershell
    },
    pois={
        POI({
            39984945, 40354831, 42164806, 42634727, 43355507, 44385569,
            45335615, 45774702, 46035411, 46645255, 47235611, 49595150,
            55845610, 56165729, 57425751, 58614000, 59163967, 61724212,
        })
    }
}) -- Iridescent Glimmershell

map.nodes[50056991] = Rare({
    id=152567,
    quest=56287,
    note=L["kelpwillow_note"],
    requires=ns.requirement.Item(167893),
    rewards={
        Achievement({id=13691, criteria=45535}), -- Kill
        Achievement({id=13692, criteria={46088,46089}}), -- Ancient Reefwalker Bark, Reefwalker Bark
        Item({item=170184, weekly=57140}) -- Ancient Reefwalker Bark
    }
}) -- Kelpwillow

map.nodes[29412899] = Rare({
    id=152323,
    quest=55671,
    note=L["gakula_note"],
    rewards={
        Achievement({id=13691, criteria=45536}), -- Kill
        Pet({id=2681, item=169371}) -- Murgle
    }
}) -- King Gakula

map.nodes[48601760] = Rare({
    id=152465,
    quest=56275,
    minimap=false,
    note=L["needle_note"],
    rewards={
        Achievement({id=13691, criteria=45538}), -- Kill
        Achievement({id=13692, criteria=46099}), -- Giant Crab Leg
        Pet({id=2689, item=169355}) -- Chitterspine Needler
    },
    pois={
        POI({39602800, 46002560, 47003080, 48601760, 50401960, 56600860, 70602460})
    }
}) -- Needlespine

map.nodes[78132501] = Rare({
    id=152397,
    quest=56288,
    note=L["oronu_note"],
    rewards={
        Achievement({id=13691, criteria=45539}), -- Kill
        Achievement({id=13692, criteria={46088,46089}}), -- Ancient Reefwalker Bark, Reefwalker Bark
        Item({item=170184, weekly=57140}) -- Ancient Reefwalker Bark
    }
}) -- Oronu

map.nodes[42728740] = Rare({
    id=152681,
    quest=56289,
    rewards={
        Achievement({id=13691, criteria=45540}), -- Kill
        Pet({id=2701, item=169367}) -- Seafury
    }
}) -- Prince Typhonus

map.nodes[42997551] = Rare({
    id=152682,
    quest=56290,
    rewards={
        Achievement({id=13691, criteria=45541}), -- Kill
        Pet({id=2702, item=169368}) -- Stormwrath
    }
}) -- Prince Vortran

map.nodes[35554141] = Rare({
    id=152548,
    quest=56292,
    note=L["matriarch_note"],
    rewards={
        Achievement({id=13691, criteria=45545}), -- Kill
        Achievement({id=13692, criteria=46087}), -- Intact Naga Skeleton
        Pet({id=2704, item=169370}) -- Scalebrood Hydra
    }
}) -- Scale Matriarch Gratinax

map.nodes[27193708] = Rare({
    id=152545,
    quest=56293,
    note=L["matriarch_note"],
    rewards={
        Achievement({id=13691, criteria=45546}), -- Kill
        Achievement({id=13692, criteria=46087}), -- Intact Naga Skeleton
        Pet({id=2704, item=169370}) -- Scalebrood Hydra
    }
}) -- Scale Matriarch Vynara

map.nodes[28604664] = Rare({
    id=152542,
    quest=56294,
    note=L["matriarch_note"],
    rewards={
        Achievement({id=13691, criteria=45547}), -- Kill
        Achievement({id=13692, criteria=46087}), -- Intact Naga Skeleton
        Pet({id=2704, item=169370}) -- Scalebrood Hydra
    }
}) -- Scale Matriarch Zodia

map.nodes[62740809] = Rare({
    id=152552,
    quest=56295,
    note=L["cave_spawn"],
    rewards={
        Achievement({id=13691, criteria=45548}), -- Kill
        Toy({item=170187}) -- Shadescale
    }, pois={
        POI({63081189}) -- Cave entrance
    }
}) -- Shassera

map.nodes[39601700] = Rare({
    id=153658,
    quest=56296,
    note=L["area_spawn"],
    rewards={
        Achievement({id=13691, criteria=45549}), -- Kill
        Achievement({id=13692, criteria={46090,46091}}) -- Voltscale Shield, Tidal Guard
    }
}) -- Shiz'narasz the Consumer

map.nodes[71365456] = Rare({
    id=152359,
    quest=56297,
    rewards={
        Achievement({id=13691, criteria=45550}), -- Kill
        Achievement({id=13692, criteria=46093}) -- Snapdragon Scent Gland
    }
}) -- Siltstalker the Packmother

map.nodes[60204740] = Rare({
    id=152290,
    quest=56298,
    note=L["cora_spawn"],
    rewards={
        Achievement({id=13691, criteria=45551}), -- Kill
        Achievement({id=13692, criteria=46096}), -- Fathom Ray Wing
        Mount({id=1257, item=169163}) -- Silent Glider
    },
    pois={
        POI({53804220, 54605020, 57605180, 58204140, 60204740, 62605960, 64805180})
    }
}) -- Soundless

map.nodes[62462964] = Rare({
    id=153898,
    quest=56122,
    note=L["tidelord_note"],
    rewards={
        Achievement({id=13691, criteria=45553}) -- Kill
    }
}) -- Tidelord Aquatus

map.nodes[57962648] = Rare({
    id=153928,
    quest=56123,
    note=L["tidelord_note"],
    rewards={
        Achievement({id=13691, criteria=45554}) -- Kill
    }
}) -- Tidelord Dispersius

map.nodes[65872243] = Rare({
    id=154148,
    quest=56106,
    note=L["tidemistress_note"],
    rewards={
        Achievement({id=13691, criteria=45555}), -- Kill
        Toy({item=170196}) -- Shirakess Warning Sign
    }
}) -- Tidemistress Leth'sindra

map.nodes[66964817] = Rare({
    id=152360,
    quest=56278,
    note=L["area_spawn"],
    rewards={
        Achievement({id=13691, criteria=45556}), -- Kill
        Achievement({id=13692, criteria=46094}) -- Alpha Fin
    }
}) -- Toxigore the Alpha

map.nodes[31282935] = Rare({
    id=152568,
    quest=56299,
    note=L["urduu_note"],
    rewards={
        Achievement({id=13691, criteria=45557}), -- Kill
        Achievement({id=13692, criteria={46088,46089}}), -- Ancient Reefwalker Bark, Reefwalker Bark
        Item({item=170184, weekly=57140}) -- Ancient Reefwalker Bark
    }
}) -- Urduu

map.nodes[67243458] = Rare({
    id=151719,
    quest=56300,
    note=L["voice_deeps_notes"],
    requires=ns.requirement.Item(168161),
    rewards={
        Achievement({id=13691, criteria=45558}), -- Kill
        Achievement({id=13692, criteria=46086}) -- Abyss Pearl
    }
}) -- Voice in the Deeps

map.nodes[48002427] = Rare({
    id=150468,
    quest=55603,
    note=L["vorkoth_note"],
    requires=ns.requirement.Item(167059),
    rewards={
        Pet({id=2709, item=169376}) -- Skittering Eel
    }
}) -- Vor'koth

-------------------------------------------------------------------------------
---------------------------------- ZONE RARES ---------------------------------
-------------------------------------------------------------------------------

local start = 09452400
local function coord(x, y)
    return start + x*2500000 + y*400
end

map.nodes[coord(0,0)] = Rare({
    id=152794,
    quest=56268,
    minimap=false,
    note=L["zone_spawn"],
    rewards={
        Achievement({id=13691, criteria=45521}), -- Kill
        Pet({id=2697, item=169363}) -- Amethyst Softshell
    }
}) -- Amethyst Spireshell

map.nodes[coord(1,0)] = Rare({
    id=152756,
    quest=56271,
    minimap=false,
    note=L["zone_spawn"],
    rewards={
        Achievement({id=13691, criteria=45529}), -- Kill
        Pet({id=2695, item=169361}) -- Daggertooth Frenzy
    }
}) -- Daggertooth Terror

map.nodes[coord(2,0)] = Rare({
    id=144644,
    quest=56274,
    minimap=false,
    note=L["zone_spawn"],
    rewards={
        Achievement({id=13691, criteria=45537}), -- Kill
        Achievement({id=13692, criteria=46098}), -- Brightspine Shell
        Pet({id=2700, item=169366}) -- Wriggler
    }
}) -- Mirecrawler

map.nodes[coord(0,1)] = Rare({
    id=150583,
    quest=56291,
    minimap=false,
    note=L["zone_spawn"]..' '..L["rockweed_note"],
    rewards={
        Achievement({id=13691, criteria=45542}), -- Kill
        Pet({id=2707, item=169374}) -- Budding Algan
    }
}) -- Rockweed Shambler

map.nodes[coord(1,1)] = Rare({
    id=151870,
    quest=56276,
    minimap=false,
    note=L["sandcastle_note"],
    requires=ns.requirement.Item(167077),
    rewards={
        Achievement({id=13691, criteria=45543}), -- Kill
        Pet({id=2703, item=169369}) -- Sandkeep
    }
}) -- Sandcastle

map.nodes[coord(2,1)] = Rare({
    id=152795,
    quest=56277,
    minimap=false,
    note=L["east_spawn"],
    rewards={
        Achievement({id=13691, criteria=45544}), -- Kill
        Achievement({id=13692, criteria=46099}), -- Giant Crab Leg
        Pet({id=2684, item=169350}) -- Glittering Diamondshell
    }
}) -- Sandclaw Stoneshell

-------------------------------------------------------------------------------
-------------------------------- TROVE TRACKER --------------------------------
-------------------------------------------------------------------------------

local Arcane = Class('ArcaneChest', Treasure, {
    label=L["arcane_chest"],
    rewards={
        Achievement({id=13549, criteria=1})
    }
})

local Glowing = Class('GlowingChest', Treasure, {
    icon='chest_bl',
    label=L["glowing_chest"],
    rewards={
        Achievement({id=13549, criteria=2})
    }
})

-- Arcane Chests
map.nodes[34454040] = Arcane({quest=55954, note=L["arcane_chest_01"]})
map.nodes[49576450] = Arcane({quest=55949, note=L["arcane_chest_02"]})
map.nodes[85303860] = Arcane({quest=55938, note=L["arcane_chest_03"]})
map.nodes[37906050] = Arcane({quest=55957, note=L["arcane_chest_04"]})
map.nodes[79502720] = Arcane({quest=55942, note=L["arcane_chest_05"]})
map.nodes[44704890] = Arcane({quest=55947, note=L["arcane_chest_06"]})
map.nodes[34604360] = Arcane({quest=55952, note=L["arcane_chest_07"]})
map.nodes[26003240] = Arcane({quest=55953, note=L["arcane_chest_08"]})
map.nodes[50605000] = Arcane({quest=55955, note=L["arcane_chest_09"]})
map.nodes[64303330] = Arcane({quest=55943, note=L["arcane_chest_10"]})
map.nodes[52804980] = Arcane({quest=55945, note=L["arcane_chest_11"]})
map.nodes[48508740] = Arcane({quest=55951, note=L["arcane_chest_12"]})
map.nodes[43405820] = Arcane({quest=55948, note=L["arcane_chest_13"]})
map.nodes[73203580] = Arcane({quest=55941, note=L["arcane_chest_14"]})
map.nodes[80402980] = Arcane({quest=55939, note=L["arcane_chest_15"]})
map.nodes[58003500] = Arcane({quest=55946, note=L["arcane_chest_16"]})
map.nodes[74805320] = Arcane({quest=55940, note=L["arcane_chest_17"]})
map.nodes[39804920] = Arcane({quest=55956, note=L["arcane_chest_18"]})
map.nodes[38707440] = Arcane({quest=55950, note=L["arcane_chest_19"]})
map.nodes[56303380] = Arcane({quest=55944, note=L["arcane_chest_20"]})

-- Glowing Arcane Chests
map.nodes[37900640] = Glowing({quest=55959, note=L["glowing_chest_1"]})
map.nodes[43951693] = Glowing({quest=55963, note=L["glowing_chest_2"]})
map.nodes[24803520] = Glowing({quest=56912, note=L["glowing_chest_3"]})
map.nodes[55701450] = Glowing({quest=55961, note=L["glowing_chest_4"]})
map.nodes[61402290] = Glowing({quest=55958, note=L["glowing_chest_5"]})
map.nodes[64102860] = Glowing({quest=55962, note=L["glowing_chest_6"]})
map.nodes[37201920] = Glowing({quest=55960, note=L["glowing_chest_7"]})
map.nodes[80493194] = Glowing({quest=56547, note=L["glowing_chest_8"]})

-------------------------------------------------------------------------------
------------------------------ WAR SUPPLY CHESTS ------------------------------
-------------------------------------------------------------------------------

local NazSupply = Class('NazSupply', Supply, {
    quest=56792,
    rewards={
        Achievement({id=13720, criteria={
            {id=45790, suffix=L["assassin_looted"]}
        }}),
        ns.reward.Spacer(),
        Achievement({id=12572})
    }
})

map.nodes[45237040] = NazSupply({ fgroup='supply_path_1', pois={Arrow({50502245, 44008159})} }) -- south of newhome
map.nodes[47285170] = NazSupply({ fgroup='supply_path_1' }) -- south basin
map.nodes[47864647] = NazSupply({ fgroup='supply_path_1' }) -- north basin
map.nodes[33493889] = NazSupply({ fgroup='supply_path_2', pois={Arrow({83003672, 25003926})} }) -- ashen strand (also 33283441?)
map.nodes[59663755] = NazSupply({ fgroup='supply_path_2' }) -- coral forest
map.nodes[76873699] = NazSupply({ fgroup='supply_path_2' }) -- zin-azshari

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[34702740] = PetBattle({
    id=154910,
    note=L["in_cave"],
    rewards={
        Achievement({id=13626, criteria=45467})
    }
}) -- Prince Wiggletail

map.nodes[71905110] = PetBattle({
    id=154911,
    rewards={
        Achievement({id=13626, criteria=45468})
    }
}) -- Chomp

map.nodes[58304810] = PetBattle({
    id=154912,
    rewards={
        Achievement({id=13626, criteria=45469})
    }
}) -- Silence

map.nodes[42201400] = PetBattle({
    id=154913,
    rewards={
        Achievement({id=13626, criteria=45470})
    }
}) -- Shadowspike Lurker

map.nodes[50605030] = PetBattle({
    id=154914,
    note=L["in_cave"],
    rewards={
        Achievement({id=13626, criteria=45471})
    }
}) -- Pearlhusk Crawler

map.nodes[51307500] = PetBattle({
    id=154915,
    rewards={
        Achievement({id=13626, criteria=45472})
    }
}) -- Elderspawn of Nalaada

map.nodes[29604970] = PetBattle({
    id=154916,
    note=L["in_cave"],
    rewards={
        Achievement({id=13626, criteria=45473})
    }
}) -- Ravenous Scalespawn

map.nodes[56400810] = PetBattle({
    id=154917,
    note=L["in_cave"],
    rewards={
        Achievement({id=13626, criteria=45474})
    }
}) -- Mindshackle

map.nodes[46602800] = PetBattle({
    id=154918,
    note=L["in_cave"],
    rewards={
        Achievement({id=13626, criteria=45475})
    },
}) -- Kelpstone

map.nodes[37501670] = PetBattle({
    id=154919,
    note=L["in_cave"],
    rewards={
        Achievement({id=13626, criteria=45476})
    }
}) -- Voltgorger

map.nodes[61472290] = PetBattle({
    id=154920,
    note=L["in_cave"],
    rewards={
        Achievement({id=13626, criteria=45477})
    }
}) -- Frenzied Knifefang

map.nodes[28102670] = PetBattle({
    id=154921,
    note=L["in_cave"],
    rewards={
        Achievement({id=13626, criteria=45478})
    }
}) -- Giant Opaline Conch

-------------------------------------------------------------------------------
------------------------------ PRISMATIC CRYSTALS -----------------------------
-------------------------------------------------------------------------------

map.nodes[55154877] = Node({
    quest=56560,
    icon='crystal_p',
    scale=2,
    label=L["strange_crystal"],
    note=L["strange_crystal_note"],
    group=ns.groups.PRISMATICS,
    -- Hide node even when "Show completed" is enabled
    IsEnabled = function () return not C_QuestLog.IsQuestFlaggedCompleted(56560) end
}) -- A Curious Discovery

local Crystal = Class('Crystal', Node, {
    questDeps=56560,
    icon='crystal_p',
    scale=1.5,
    label='{item:167893}',
    note=L["prismatic_crystal_note"],
    group=ns.groups.PRISMATICS
})

map.nodes[29503608] = Crystal()
map.nodes[29993606] = Crystal() -- behind the Staghorn Reefwalker
map.nodes[30033610] = Crystal()
map.nodes[30712420] = Crystal() -- behind Urduu
map.nodes[31313554] = Crystal()
map.nodes[32143302] = Crystal()
map.nodes[32163311] = Crystal()
map.nodes[38721815] = Crystal()
map.nodes[39105950] = Crystal()
map.nodes[39675954] = Crystal()
map.nodes[40647131] = Crystal()
map.nodes[40806604] = Crystal()
map.nodes[42211795] = Crystal()
map.nodes[43435545] = Crystal()
map.nodes[44722111] = Crystal() -- check top and bottom of waterfall
map.nodes[45475368] = Crystal()
map.nodes[45584064] = Crystal()
map.nodes[45803810] = Crystal()
map.nodes[45804241] = Crystal()
map.nodes[46503610] = Crystal()
map.nodes[46805213] = Crystal()
map.nodes[47236905] = Crystal()
map.nodes[47668550] = Crystal()
map.nodes[48272815] = Crystal()
map.nodes[48358625] = Crystal()
map.nodes[50117263] = Crystal()
map.nodes[50656934] = Crystal()
map.nodes[52235182] = Crystal() -- tucked among the glowing blue bubbles
map.nodes[52905270] = Crystal()
map.nodes[70312481] = Crystal()
map.nodes[71363134] = Crystal()
map.nodes[71562605] = Crystal()
map.nodes[71962251] = Crystal()
map.nodes[72294746] = Crystal()
map.nodes[73405050] = Crystal()

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
}

local Slime = Class('RavenousSlime', NPC, {
    id=151782,
    icon=132107,
    group=ns.groups.SLIMES_NAZJ,
    questAny=true,
    note=L["ravenous_slime_note"],
    requires=ns.requirement.Item(167893),
    rewards=SLIME_PETS
})

local Cocoon = Class('SlimyCocoon', Node, {
    icon=132833,
    group=ns.groups.SLIMES_NAZJ,
    label=L["slimy_cocoon"],
    note=L["slimy_cocoon_note"],
    rewards=SLIME_PETS
})

-- first quest is daily, second quest means done and gone until weekly reset
map.nodes[32773951] = Slime({quest={55430,55473}})
map.nodes[45692409] = Slime({quest={55429,55472}})
map.nodes[54894868] = Slime({quest={55427,55470}})
map.nodes[71722569] = Slime({quest={55428,55471}})

-- once the second quest is true, the eggs should be displayed
map.nodes[32773952] = Cocoon({quest=55478, questDeps=55473})
map.nodes[45692410] = Cocoon({quest=55477, questDeps=55472})
map.nodes[54894869] = Cocoon({quest=55475, questDeps=55470})
map.nodes[71722570] = Cocoon({quest=55476, questDeps=55471})

-------------------------------------------------------------------------------
-------------------------------- CAT FIGURINES --------------------------------
-------------------------------------------------------------------------------

local Figurine = Class('CatFigurine', Collectible, {
    icon=454045,
    group=ns.groups.CATS_NAZJ,
    label=L["cat_figurine"],
    rewards={
        Achievement({id=13836, criteria={
            {id=1, qty=true, suffix=L["figurines_found"]}
        }})
    }
})

map.nodes[28752910] = Figurine({quest=56983, note=L["cat_figurine_01"]})
map.nodes[71342369] = Figurine({quest=56988, note=L["cat_figurine_02"]})
map.nodes[73582587] = Figurine({quest=56992, note=L["cat_figurine_03"]})
map.nodes[58212198] = Figurine({quest=56990, note=L["cat_figurine_04"]})
map.nodes[61092681] = Figurine({quest=56984, note=L["cat_figurine_05"]})
map.nodes[40168615] = Figurine({quest=56987, note=L["cat_figurine_06"]})
map.nodes[59093053] = Figurine({quest=56985, note=L["cat_figurine_07"]})
map.nodes[55362715] = Figurine({quest=56986, note=L["cat_figurine_08"]})
map.nodes[61641079] = Figurine({quest=56991, note=L["cat_figurine_09"]})
map.nodes[38004925] = Figurine({quest=56989, note=L["cat_figurine_10"]})

-------------------------------------------------------------------------------
-------------------------------- MISCELLANEOUS --------------------------------
-------------------------------------------------------------------------------

map.nodes[60683221] = Node({
    quest=55121,
    group=ns.groups.MISC_NAZJ,
    icon="portal_b",
    scale=1.5,
    label=L["mardivas_lab"],
    rewards={
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
        Item({item=170477, note=L["Arcane"]}), -- Mardivas's Universally Lauded Tote
        Transmog({item=170138, slot=L["offhand"], note=L["Watery"]}), -- Scroll of Violent Tides
        Transmog({item=170126, slot=L["bow"], note=L["Burning"]}), -- Igneous Longbow
        Transmog({item=170383, slot=L["shield"], note=L["Dusty"]}), -- Coralspine Bulwark
        Transmog({item=170137, slot=L["dagger"], note=L["Zomera"]}), -- Azerite-Infused Crystal Flayer
        Transmog({item=170132, slot=L["1h_sword"], note=L["Omus"]}), -- Slicer of Omus
        Transmog({item=170130, slot=L["warglaive"], note=L["Osgen"]}), -- Glaive of Swells
        Transmog({item=170128, slot=L["staff"], note=L["Moghiea"]}), -- Majestic Shirakess Greatstaff
        Transmog({item=170127, slot=L["polearm"], note=L["Xue"]}), -- Pyroclastic Halberd
        Transmog({item=170131, slot=L["wand"], note=L["Ungormath"]}), -- Tidal Wand of Malevolence
        Transmog({item=170124, slot=L["2h_sword"], note=L["Spawn"]}), -- Coral-Sharpened Greatsword
        Transmog({item=170125, slot=L["fist"], note=L["Herald"]}), -- Behemoth Claw of the Abyss
        Transmog({item=170129, slot=L["1h_mace"], note=L["Salgos"]}) -- Salgos' Volatile Basher
    }
})

map.nodes[45993245] = NPC({
    id=152593,
    icon=528288,
    group=ns.groups.MISC_NAZJ,
    note=L["tentacle_taco"]
})
