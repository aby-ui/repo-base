-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local Class = ns.Class
local Map = ns.Map
local L = ns.locale

local PetBattle = ns.node.PetBattle
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Quest = ns.reward.Quest
local Transmog = ns.reward.Transmog
local Toy = ns.reward.Toy

local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local NIGHTFAE = ns.covenants.FAE
local map = Map({ id=1565, settings=true })

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[34606800] = Rare({
    id=164477,
    quest=59226,
    rewards={
        Achievement({id=14309, criteria=48714})
    }
}) -- Deathbinder Hroth

map.nodes[47522845] = Rare({
    id=164238,
    quest={59201,62271},
    note=L["deifir_note"],
    rewards={
        Achievement({id=14309, criteria=48784}),
        Pet({item=180631, id=2920}) -- Gorm Needler
    },
    pois={
        Path({
            47522845, 48052741, 48692650, 49172530, 49652403, 49022308, 48842184,
            48162099, 47362116, 46712135, 46332211, 46432338, 46452445, 46602590,
            46932693, 47112793, 47522845
        })
    }
}) -- Deifir the Untamed

map.nodes[48397717] = Rare({
    id=163229,
    quest=58987,
    rewards={
        Achievement({id=14309, criteria=48794})
    }
}) -- Dustbrawl

map.nodes[57862955] = Rare({
    id=167851,
    quest=60266,
    note=L["lehgo_note"],
    rewards={
        Achievement({id=14309, criteria=48790})
    }
}) -- Egg-Tender Leh'go

map.nodes[68612765] = Rare({
    id=171688,
    quest=61184,
    note=L["faeflayer_note"],
    rewards={
        Achievement({id=14309, criteria=48798})
    }
}) -- Faeflayer

map.nodes[54067601] = Rare({
    id=163370,
    quest=59006,
    rewards={
        Achievement({id=14309, criteria=48795}),
        Pet({item=183196, id=3035}) -- Lavender Nibbler
    }
}) -- Gormbore

map.nodes[27885248] = Rare({
    id=164107,
    quest=59145,
    rewards={
        Achievement({id=14309, criteria=48781}),
        Mount({item=180725, id=1362}) -- Spinemaw Gladechewer
    }
}) -- Gormtamer Tizo

map.nodes[32423026] = Rare({
    id=164112,
    quest=59157,
    requires=ns.requirement.Item(175247),
    note=L["humongozz_note"],
    rewards={
        Achievement({id=14309, criteria=48782}),
        Mount({item=182650, id=1415}) -- Arboreal Gulper
    }
}) -- Humon'gozz

map.nodes[67465147] = Rare({
    id=160448,
    quest=59221,
    rewards={
        Achievement({id=14309, criteria=48787}),
        Transmog({item=179596, slot=L["cosmetic"]}), -- Drust Mask of Dominance
        Quest({id=62246}) -- A Fallen Friend
    }
}) -- Hunter Vivian

-- Mysterious Mushroom Ring (36474814)
-- Mysterious Mushroom Ring (47924018)

-- map.nodes[] = Rare({
--     id=164093,
--     quest=nil,
--     rewards={
--         Achievement({id=14309, criteria=48780}),
--         Pet({item=180644, id=2907}) -- Rocky
--     }
-- }) -- Macabre

map.nodes[62102470] = Rare({
    id=165053,
    quest=nil,
    rewards={
        Achievement({id=14309, criteria=48788})
    }
}) -- Mymaen

local RainbowGlow = Class('RainbowGlow', ns.poi.Glow)

function RainbowGlow:Draw(pin, xy)
    local r, g, b, diff = 10, 0, 0, 1
    pin.ticker = C_Timer.NewTicker(0.05, function ()
        if r == 0 and g > b then b = b + diff
        elseif g == 0 and b > r then r = r + diff
        elseif b == 0 and r > g then g = g + diff
        elseif r == 0 and g <= b then g = g - diff
        elseif g == 0 and b <= r then b = b - diff
        elseif b == 0 and r <= g then r = r - diff
        end
        pin.texture:SetVertexColor(r/10, g/10, b/10, 1)
    end)
    self.r, self.g, self.b, self.a = 1, 0, 0, 1
    return ns.poi.Glow.Draw(self, pin, xy)
end

map.nodes[50092091] = Rare({
    id=164547,
    quest=59235,
    note=L["rainbowhorn_note"],
    glow=RainbowGlow({ icon=ns.GetGlowPath('skull_w') }),
    rewards={
        Achievement({id=14309, criteria=48715}),
        Item({item=182179, quest=62434}) -- Runestag Soul
    }
}) -- Mystic Rainbowhorn

map.nodes[57874983] = Rare({
    id=168135,
    quest=60306,
    covenant=NIGHTFAE,
    requires=ns.requirement.Item(178675),
    note=L["night_mare_note"],
    rewards={
        Achievement({id=14309, criteria=48793}),
        Mount({item=180728, id=1306}) -- Swift Gloomhoof
    },
    pois={
        Path({
            59175611, 59905695, 60875610, 62155544, 62445355, 62145199,
            62075045, 61664920, 60634907, 59524941, 58534879, 57874983
        }), -- Night Mare
        Path({18356218, 17576184, 17756284, 18916346, 19776344}), -- Broken Soulweb
        POI({50413303}) -- Elder Gwenna
    }
}) -- Night Mare

map.nodes[51105740] = Rare({
    id=164391,
    quest={59208,62270},
    note=L["old_ardeite_note"],
    rewards={
        Achievement({id=14309, criteria=48785}),
        Pet({item=180643, id=2908}) -- Chirpy Valeshrieker
    }
}) -- Old Ardeite

map.nodes[65104430] = Rare({
    id=167726,
    quest=60273,
    note=L["rootwrithe_note"],
    rewards={
        Achievement({id=14309, criteria=48791})
    }
}) -- Rootwrithe

map.nodes[65702430] = Rare({
    id=167724,
    quest=60258,
    note=L["rotbriar_note"],
    rewards={
        Achievement({id=14309, criteria=48789}),
        Item({item=175729, note=L["trinket"]}) -- Rotbriar Sprout
    }
}) -- Rotbriar Changeling

map.nodes[72425175] = Rare({
    id=171451,
    quest=61177,
    rewards={
        Achievement({id=14309, criteria=48797}),
        Transmog({item=180164, slot=L["staff"]}) -- Soultwister's Scythe
    }
}) -- Soultwister Cero

map.nodes[37675917] = Rare({
    id=164415,
    quest=59220,
    covenant=NIGHTFAE,
    note=L["skuld_vit_note"],
    rewards={
        Achievement({id=14309, criteria=48786}),
        Item({item=182183, quest=62439}) -- Wolfhawk Soul
    }
}) -- Skuld Vit

map.nodes[59304660] = Rare({
    id=167721,
    quest=60290,
    note=L["slumbering_note"],
    rewards={
        Achievement({id=14309, criteria=48792})
    }
}) -- The Slumbering Emperor

map.nodes[30115536] = Rare({
    id=168647,
    quest=61632,
    covenant=NIGHTFAE,
    requires=ns.requirement.GarrisonTalent(1247, L["anima_channeled"]),
    note=L["valfir_note"],
    rewards={
        Achievement({id=14309, criteria=48796}),
        Mount({item=180730, id=1393}), -- Glimmerfur Prowler
        Item({item=182176, quest=62431}) -- Shadowstalker Soul
    },
    pois={
        Path({29265611, 30115536, 30875464})
    }
}) -- Valfir the Unrelenting

map.nodes[58306180] = Rare({
    id=164147,
    quest=59170,
    note=L["wrigglemortis_note"],
    rewards={
        Achievement({id=14309, criteria=48783})
    }
}) -- Wrigglemortis

--------------------------- STAR LAKE AMPHITHEATER ----------------------------

map.nodes[41254443] = Rare({
    id=171743,
    quest=61633,
    covenant=NIGHTFAE,
    requires=ns.requirement.GarrisonTalent(1244, L["anima_channeled"]),
    label=L["star_lake"],
    note=L["star_lake_note"],
    rewards = {
        Achievement({id=14353, criteria={
            48708, -- Argus
            48709, -- Azshara
            48706, -- Gul'dan
            48704, -- Jaina
            48707, -- Kil'jaeden
            48710, -- N'Zoth
            48705  -- Xavius
        }})
    }
})

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[56002101] = Treasure({
    quest=61072,
    rewards={
        Achievement({id=14313, criteria=50031}),
        Pet({item=180630, id=2921}) -- Gorm Harrier
    }
}) -- Aerto's Body

map.nodes[63893778] = Treasure({
    quest=61074,
    note=L["cache_of_the_moon"],
    rewards={
        Achievement({id=14313, criteria=50039}),
        Mount({item=180731, id=1397}) -- Wildseed Cradle
    },
    pois={
        POI({
            38995696, -- Diary of the Night
            39755440, -- Gardener's Hammer
            40315262, -- Gardener's Basket
            38495808, -- Gardener's Flute
            38856010, -- Gardener's Wand
        })
    }
}) -- Cache of the Moon

map.nodes[36236527] = Treasure({
    quest=61110,
    requires=ns.requirement.Item(180652),
    note=L["cache_of_the_night"],
    rewards={
        Achievement({id=14313, criteria=50044}),
        Pet({item=180637, id=2914}) -- Starry Dreamfoal
    }, pois={
        POI({
            42414672, -- Enchanted Bough
            51556160, -- Fae Ornament
            36982983  -- Raw Dream Silk
        })
    }
}) -- Cache of the Night

map.nodes[37646159] = Treasure({
    quest=61068,
    note=L["darkreach_supplies"],
    rewards={
        Achievement({id=14313, criteria=50045}),
        Transmog({item=179594, slot=L["leather"]}) -- Witherscorn Guise
    },
    pois={
        Path({37646159, 37166279, 36686399, 36196520})
    }
}) -- Darkreach Supplies

map.nodes[41953253] = Treasure({
    quest=61147,
    note=L["desiccated_moth"],
    rewards={
        Achievement({id=14313, criteria=50040}),
        Pet({item=180640, id=2911}) -- Amber Glitterwing
    },
    pois={
        POI({41413161}), -- Bounding Shroom
        POI({31763247}) -- Aromatic Flowers
    }
}) -- Desiccated Moth

map.nodes[37683688] = Treasure({
    quest=61070,
    note=L["dreamsong_heart"],
    rewards={
        Achievement({id=14313, criteria=50041}),
        Transmog({item=179510, slot=L["warglaive"]}) -- Dreamsong Warglaive
    },
    pois={
        POI({38013631}) -- Bounding Shroom
    }
}) -- Dreamsong Heart

map.nodes[44827587] = Treasure({
    quest=61175,
    note=L["elusive_faerie_cache"],
    rewards={
        Achievement({id=14313, criteria=50043}),
        Transmog({item=179512, slot=L["1h_sword"]}) -- Dreamsong Saber
    },
    pois={
        Path({
            44827587, 44477530, 44417436, 44647334, 44877246, 45057161,
            45417087, 45837033, 46497011
        }) -- to Faerie Lamp
    }
}) -- Elusive Faerie Cache

map.nodes[36422506] = Treasure({
    quest=62259,
    note=L["enchanted_dreamcatcher"],
    rewards={
        Achievement({id=14313, criteria=50042}),
        Item({item=183129, quest=62259}) -- Anima-Laden Dreamcatcher
    }
}) -- Enchanted Dreamcatcher

map.nodes[49715589] = Treasure({
    quest=61073,
    note=L["faerie_trove"],
    rewards={
        Achievement({id=14313, criteria=50035}),
        Pet({item=182673, id=3022}) -- Shimmerbough Hoarder
    }
}) -- Faerie Trove

map.nodes[67803462] = Treasure({
    quest=61165,
    note=L["harmonic_chest"],
    rewards={
        Achievement({id=14313, criteria=50036})
    }
}) -- Harmonic Chest

map.nodes[48213927] = Treasure({
    quest=61067,
    note=L["hearty_dragon_plume"],
    rewards={
        Achievement({id=14313, criteria=50037}),
        Toy({item=182729}) -- Hearty Dragon Plume
    },
    pois={
        POI({46424032, 48964102, 50084159})
    }
}) -- Hearty Dragon Plume

map.nodes[48282031] = Treasure({
    quest=62187,
    rewards={
        Achievement({id=14313, criteria=50032}),
        Item({item=182731, quest=62187}) -- Satchel of Culexwood
    }
}) -- Lost Satchel

map.nodes[31764100] = Treasure({
    quest={61080, 61081, 61084, 61085, 61086},
    questCount=true,
    note=L["playful_vulpin_note"],
    rewards={
        Achievement({id=14313, criteria=50038}),
        Pet({item=180645, id=2905}) -- Dodger
    },
    pois={
        POI({
            31764100, 31854363, 32604292, 34104500, 40082870, 40722741,
            40945156, 41312874, 41902742, 41374979, 50215353, 51165507,
            65222265, 67162888, 67553191, 69003036, 70143004, 72393146
        }) -- Possible spawns
    }
}) -- Playful Vulpin Befriended (171206)

map.nodes[76672974] = Treasure({
    quest=62186,
    note=L["swollen_anima_seed"],
    rewards={
        Achievement({id=14313, criteria=50034}),
        Item({item=182730, quest=62186}) -- Swollen Anima Seed
    }
}) -- Swollen Anima Seed

map.nodes[26285897] = Treasure({
    quest=61192, -- 61208 = failed, 61198 = passed
    label=L["tame_gladerunner"],
    note=L["tame_gladerunner_note"],
    rewards={
        Mount({item=180727, id=1360}) -- Shimmermist Runner
    },
    pois={
        Path({
            32545304, 32005370, 31345426, 30745484, 30115532, 29455591,
            29735683, 30015767, 29335798, 29385915, 28725860, 28205819,
            27515788, 26985831, 26285897
        })
    }
}) -- Tame Gladerunner

map.nodes[52943729] = Treasure({
    quest=61065,
    rewards={
        Achievement({id=14313, criteria=50033}),
        Pet({item=180642, id=2909}) -- Downfeather Ragewing
    }
}) -- Veilwing Egg (Ancient Cloudfeather Egg)

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[39956449] = PetBattle({
    id=173376,
    rewards={
        Achievement({id=14625, criteria=49404})
    }
}) -- Nightfang

map.nodes[40192880] = PetBattle({
    id=173381,
    rewards={
        Achievement({id=14625, criteria=49402})
    }
}) -- Rascal

map.nodes[51274406] = PetBattle({
    id=173377,
    rewards={
        Achievement({id=14625, criteria=49403})
    }
}) -- Faryl

map.nodes[58205690] = PetBattle({
    id=173372,
    rewards={
        Achievement({id=14625, criteria=49405})
    }
}) -- Glitterdust