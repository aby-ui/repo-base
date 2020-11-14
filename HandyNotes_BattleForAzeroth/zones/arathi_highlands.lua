-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Map = ns.WarfrontMap

local Rare = ns.Class('WFRare', ns.node.Rare, { questAny=true })

local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy

local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({ id=14, collector=11, settings=true, phased=false })

function map:Prepare ()
    Map.Prepare(self)

    -- Zidormi activates this quest to show the old Arathi Highlands
    self.phased = not C_QuestLog.IsQuestFlaggedCompleted(52781)
end

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[65347116] = Rare({
    id=142709,
    quest={53083, 53504},
    rewards={
        Mount({item=163644, id=1180})
    }
}) -- Beastrider Kama

map.nodes[21752217] = Rare({
    id=142508,
    quest={53013, 53505},
    rewards={
        Pet({item=163650, id=2433})
    }
}) -- Branchlord Aldrus

map.nodes[50673675] = Rare({
    id=142688,
    quest={53084, 53507},
    controllingFaction='Alliance',
    rewards={
        Pet({item=163652, id=2434})
    }
}) -- Darbel Montrose

map.nodes[50756121] = Rare({
    id=142688,
    quest={53084, 53507},
    controllingFaction='Horde',
    rewards={
        Pet({item=163652, id=2434})
    },
}) -- Darbel Montrose

map.nodes[22305106] = Rare({
    id=142686,
    quest={53086, 53509},
    note=L["boulderfist_outpost"],
    rewards={
        Toy({item=163735})
    },
    pois={
        POI({28594559}) -- Cave entrance
    }
}) -- Foulbelly

map.nodes[59812809] = Rare({
    id=142433,
    quest={53019, 53510},
    rewards={
        Pet({item=163711, id=2440})
    }
}) -- Fozruk

map.nodes[79532945] = Rare({
    id=142662,
    quest={53060, 53511},
    note=L["in_cave"],
    rewards={
        Toy({item=163713})
    },
    pois={
        POI({78153687}) -- Cave entrance
    }
}) -- Geomancer Flintdagger

map.nodes[26723278] = Rare({
    id=142725,
    quest={53087, 53512},
    controllingFaction='Alliance',
    rewards={
        Toy({item=163736})
    }
}) -- Horrific Apparition

map.nodes[19406120] = Rare({
    id=142725,
    quest={53087, 53512},
    controllingFaction='Horde',
    rewards={
        Toy({item=163736})
    }
}) -- Horrific Apparition

map.nodes[49318426] = Rare({
    id=142112,
    quest={53058, 53513},
    note=L["in_cave"],
    rewards={
        Toy({item=163744})
    },
    pois={
        POI({48117953}) -- Cave entrance
    }
}) -- Kor'gresh Coldrage

map.nodes[25294856] = Rare({
    id=142684,
    quest={53089, 53514},
    note=L["boulderfist_outpost"],
    rewards={
        Toy({item=163750})
    },
    pois={
        POI({28594560}) -- Cave entrance
    }
}) -- Kovork

map.nodes[52197487] = Rare({
    id=142716,
    quest={53090, 53515},
    rewards={
        Pet({item=163689, id=2441})
    },
    pois={
        Path({52297686, 51807585, 52197487, 51957382, 52187259})
    }
}) -- Man-Hunter Rog

map.nodes[47657800] = Rare({
    id=141942,
    quest={53057, 53516},
    rewards={
        Toy({item=163775})
    }
}) -- Molok the Crusher

map.nodes[67486058] = Rare({
    id=142692,
    quest={53091, 53517},
    rewards={
        Mount({item=163706, id=1185})
    }
}) -- Nimar the Slayer

map.nodes[32923847] = Rare({
    id=142423,
    quest={53014, 53518},
    controllingFaction='Alliance',
    rewards={
        Mount({item=163646, id=1182})
    },
    pois={
        POI({33693676}) -- Cave entrance
    }
}) -- Overseer Krix

map.nodes[27255710] = Rare({
    id=142423,
    quest={53014, 53518},
    controllingFaction='Horde',
    rewards={
        Mount({item=163646, id=1182})
    },
    pois={
        POI({27485560}) -- Cave entrance
    }
}) -- Overseer Krix

map.nodes[35606435] = Rare({
    id=142435,
    quest={53020, 53519},
    rewards={
        Pet({item=163690, id=2438})
    }
}) -- Plaguefeather

map.nodes[18412794] = Rare({
    id=142436,
    quest={53016, 53522},
    controllingFaction='Alliance',
    rewards={
        Pet({item=163689, id=2437})
    },
}) -- Ragebeak

map.nodes[11905220] = Rare({
    id=142436,
    quest={53016, 53522},
    controllingFaction='Horde',
    rewards={
        Pet({item=163689, id=2437})
    }
}) -- Ragebeak

map.nodes[42905660] = Rare({
    id=142683,
    quest={53092, 53524},
    rewards={
        Toy({item=163741})
    }
}) -- Ruul Onestone

map.nodes[51213999] = Rare({
    id=142690,
    quest={53093, 53525},
    controllingFaction='Alliance',
    rewards={
        Toy({item=163738})
    },
}) -- Singer

map.nodes[50705748] = Rare({
    id=142690,
    quest={53093, 53525},
    controllingFaction='Horde',
    rewards={
        Toy({item=163738})
    },
}) -- Singer

map.nodes[57154575] = Rare({
    id=142437,
    quest={53022, 53526},
    rewards={
        Mount({item=163645, id=1183})
    }
}) -- Skullripper

map.nodes[56945330] = Rare({
    id=142438,
    quest={53024, 53528},
    rewards={
        Pet({item=163648, id=2432})
    }
}) -- Venomarus

map.nodes[13273534] = Rare({
    id=142440,
    quest={53015, 53529},
    rewards={
        Pet({item=163684, id=2436})
    }
}) -- Yogursa

map.nodes[62858120] = Rare({
    id=142682,
    quest={53094, 53530},
    note=L["in_cave"],
    rewards={
        Toy({item=163745})
    },
    pois={
        POI({63257752}) -- Cave entrance
    }
}) -- Zalas Witherbark

------------------------------ ALLIANCE / HORDE -------------------------------

map.nodes[48913996] = Rare({
    id=142739,
    quest=53088,
    faction='Horde',
    controllingFaction='Horde',
    rewards={
        Mount({item=163578, id=1173})
    }
}) -- Knight-Captain Aldrin

map.nodes[39093921] = Rare({
    id=137374,
    quest=53001,
    faction='Horde',
    controllingFaction='Horde',
    rewards={
        Toy({item=163829})
    }
}) -- The Lion's Roar

map.nodes[37093921] = Rare({
    id=138122,
    quest=53002,
    faction='Alliance',
    controllingFaction='Alliance',
    rewards={
        Toy({item=163828})
    }
}) -- Doom's Howl

map.nodes[53565764] = Rare({
    id=142741,
    quest=53085,
    faction='Alliance',
    controllingFaction='Alliance',
    rewards={
        Mount({item=163579, id=1174})
    }
}) -- Doomrider Helgrim

------------------------------- ECHO OF MYZRAEL -------------------------------

map.nodes[30604475] = Rare({
    id=141615,
    quest={53017, 53506},
    note=L["burning_goliath_note"],
    pois={
        POI({57473438}) -- Burning Guardian
    }
}) -- Burning Goliath

map.nodes[62513084] = Rare({
    id=141618,
    quest={53018, 53531},
    note=L["cresting_goliath_note"],
    pois={
        POI({57323531}) -- Cresting Guardian
    }
}) -- Cresting Goliath

map.nodes[29405834] = Rare({
    id=141620,
    quest={53021, 53523},
    note=L["rumbling_goliath_note"],
    pois={
        POI({56803412}) -- Rumbling Guardian
    }
}) -- Rumbling Goliath

map.nodes[46245222] = Rare({
    id=141616,
    quest={53023, 53527},
    note=L["thundering_goliath_note"],
    pois={
        POI({56703519}) -- Thundering Guardian
    }
}) -- Thundering Goliath

map.nodes[57073472] = Rare({
    id=141668,
    quest={53059, 53508},
    note=L["echo_of_myzrael_note"],
    rewards={
        Pet({item=163677, id=2435})
    }
}) -- Echo of Myzrael