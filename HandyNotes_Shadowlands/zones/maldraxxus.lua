-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.Map

local Collectible = ns.node.Collectible
local PetBattle = ns.node.PetBattle
local Rare = ns.node.Rare
local Soulshape = ns.node.Soulshape
local Squirrel = ns.node.Squirrel
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Circle = ns.poi.Circle
local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local NECROLORD = ns.covenants.NEC
local NIGHTFAE = ns.covenants.FAE

local map = Map({id = 1536, settings = true})
local vos = Map({id = 1652}) -- Vault of Souls

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[52663542] = Rare({
    id = 162727,
    quest = 58870,
    rewards = {
        Achievement({id = 14308, criteria = 48876}),
        Transmog({item = 184290, slot = L['dagger']}), -- Blood-Dyed Bonesaw
        Transmog({item = 184154, slot = L['cosmetic']}), -- Grungy Containment Pack
        Toy({item = 184476}) -- Regenerating Slime Vial
    }
}) -- Bubbleblood

map.nodes[49012351] = Rare({
    id = 159105,
    quest = 58005,
    rewards = {
        Achievement({id = 14308, criteria = 48866}),
        Achievement({id = 14833, criteria = 49919, covenant = NECROLORD}), -- Collector Kash's Pack
        Achievement({id = 14763, criteria = 49930}), -- Jagged Bonesaw
        Transmog({item = 184188, slot = L['1h_axe']}), -- Collector's Corpse Gambrel
        Transmog({item = 184181, slot = L['1h_axe']}), -- Kash's Favored Hook
        Transmog({item = 184189, slot = L['1h_axe']}), -- Stained Fleshgorer
        Transmog({item = 184182, slot = L['1h_axe']}) -- Strengthened Abomination Hook
    }
}) -- Collector Kash

map.nodes[26392633] = Rare({
    id = 157058,
    quest = 58335,
    rewards = {
        Achievement({id = 14308, criteria = 48872}),
        Achievement({id = 14833, criteria = 49919, covenant = NECROLORD}), -- Collector Kash's Pack
        Transmog({item = 184177, slot = L['1h_axe']}), -- Grotesque Goring Pick
        Transmog({item = 184176, slot = L['warglaive']}) -- Moroc's Boneslicing Warglaive
    }
}) -- Corpsecutter Moroc

map.nodes[76835707] = Rare({
    id = 162711,
    quest = 58868,
    rewards = {
        Achievement({id = 14308, criteria = 48851}),
        Achievement({id = 14833, criteria = 50558, covenant = NECROLORD}),
        Transmog({item = 184280, slot = L['cloth']}), -- Dapper Threads
        Pet({id = 2953, item = 181263}) -- Shy Melvin
    }
}) -- Deadly Dapperling

map.nodes[46734550] = Rare({
    id = 162797,
    quest = 58878,
    note = L['deepscar_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48852}),
        Transmog({item = 182191, slot = L['1h_mace']}) -- Slobber-Soaked Chew Toy
    },
    pois = {POI({48125190, 53974548})}
}) -- Deepscar

map.nodes[45052842] = Rare({
    id = 162669,
    quest = 58835,
    rewards = {
        Achievement({id = 14308, criteria = 48855}),
        Transmog({item = 184178, slot = L['2h_sword']}) -- Worldrending Claymore
    }
}) -- Devour'us

map.nodes[31603540] = Rare({
    id = 162741,
    quest = 58872,
    covenant = NECROLORD,
    requires = ns.requirement.GarrisonTalent(1250, L['anima_channeled']),
    note = L['gieger_note'],
    rewards = {
        Achievement({id = 14833, criteria = 49876, covenant = NECROLORD}),
        Transmog({item = 184298, slot = L['offhand']}), -- Amalgamated Forsworn's Journal
        Mount({item = 182080, id = 1411, covenant = NECROLORD}) -- Predatory Plagueroc
    }
}) -- Gieger

map.nodes[57795155] = Rare({
    id = 162588,
    quest = 58837,
    note = L['gristlebeak_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48853}),
        Transmog({item = 182196, slot = L['crossbow']}) -- Arbalest of the Colossal Predator
    }
}) -- Gristlebeak

map.nodes[38794333] = Rare({
    id = 161105,
    quest = 58332,
    note = L['schmitd_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48848}),
        Achievement({id = 14751, criteria = 51474, covenant = NECROLORD}), -- Indomitable Hide
        Transmog({item = 182192, slot = L['plate']}) -- Knee-Obstructing Legguards
    }
}) -- Indomitable Schmitd

map.nodes[72872891] = Rare({
    id = 174108,
    quest = 62369,
    rewards = {
        Achievement({id = 14308, criteria = 49724}),
        -- Item({item=184174, note=L["ring"]}), -- Clasp of Death
        Transmog({item = 181810, slot = L['cosmetic'], covenant = NECROLORD}) -- Phylactery of the Dead Conniver
    }
}) -- Necromantic Anomaly

map.nodes[66023532] = Rare({
    id = 162690,
    quest = 58851,
    rewards = {
        Achievement({id = 14308, criteria = 49723}),
        Achievement({id = 14751, criteria = 51473, covenant = NECROLORD}), -- Necromantic Oil
        Transmog({item = 184179, slot = L['2h_sword']}), -- Lichsworn Commander's Boneblade
        Mount({item = 182084, id = 1373}) -- Gorespine
    }
}) -- Nerissa Heartless

map.nodes[50346328] = Rare({
    id = 161857,
    quest = 58629,
    note = L['nirvaska_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48868}),
        Transmog({item = 183700, slot = L['cloth']}), -- Forgotten Summoner's Shoulderpads
        Transmog({item = 181811, slot = L['cosmetic'], covenant = NECROLORD}) -- Beckoner's Shadowy Crystal
    }
}) -- Nirvaska the Summoner

map.nodes[53726132] = Rare({
    id = 162767,
    quest = 58875,
    rewards = {
        Achievement({id = 14308, criteria = 48849}),
        Transmog({item = 182205, slot = L['mail']}) -- Scarab-Shell Faceguard
    }
}) -- Pesticide

map.nodes[53841877] = Rare({
    id = 159753,
    quest = 58004,
    note = L['ravenomous_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48865}),
        Transmog({item = 184184, slot = L['dagger']}), -- Ravenomous's Acid-Tipped Stinger
        Pet({item = 181283, id = 2964}) -- Foulwing Buzzer
    }
}) -- Ravenomous

map.nodes[51744439] = Rare({
    id = 168147,
    quest = 58784,
    covenant = NECROLORD,
    requires = ns.requirement.GarrisonTalent(1253, L['anima_channeled']),
    note = L['sabriel_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48874}),
        Achievement({id = 14802, criteria = 48874}),
        Mount({item = 181815, id = 1370, covenant = NECROLORD}) -- Armored Bonehoof Tauralus
    }
}) -- Sabriel the Bonecleaver

map.nodes[62107580] = Rare({
    id = 158406,
    quest = 58006,
    rewards = {
        Achievement({id = 14308, criteria = 48857}),
        Achievement({id = 14833, criteria = 49919, covenant = NECROLORD}), -- Collector Kash's Pack
        Transmog({item = 184287, slot = L['mail']}), -- Scum-Caked Epaulettes
        Pet({item = 181267, id = 2957}) -- Writhing Spine
    }
}) -- Scunner

map.nodes[55502361] = Rare({
    id = 159886,
    quest = 58003,
    note = L['chelicerae_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48873}),
        Transmog({item = 184289, slot = L['1h_sword']}), -- Spindlefang Spellblade
        Pet({item = 181172, id = 2948}) -- Boneweave Hatchling
    }
}) -- Sister Chelicerae

map.nodes[42465345] = Rare({
    id = 162528,
    quest = 58768,
    rewards = {
        Achievement({id = 14308, criteria = 48869}),
        Achievement({id = 14833, criteria = 50560, covenant = NECROLORD}),
        Transmog({item = 184299, slot = L['leather']}), -- Goresoaked Carapace
        Pet({item = 181266, id = 2956}), -- Bloodlouse Hatchling
        Pet({item = 181265, id = 2955}) -- Corpselouse Hatchling
    }
}) -- Smorgas the Feaster

map.nodes[44215132] = Rare({
    note = L['tahonta_note'],
    id = 162586,
    quest = 58783,
    rewards = {
        Achievement({id = 14308, criteria = 48850}),
        Transmog({item = 182190, slot = L['leather']}), -- Tauralus Hide Collar
        Mount({item = 182075, id = 1366, covenant = NECROLORD}) -- Bonehoof Tauralus
    }
}) -- Tahonta

map.nodes[50562011] = Rare({
    id = 160059,
    quest = 58091,
    note = L['taskmaster_xox_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48867}),
        Transmog({item = 184186, slot = L['1h_axe']}), -- Flesh-Fishing Hook
        Transmog({item = 184192, slot = L['1h_axe']}), -- Pristine Alabaster Gorer
        Transmog({item = 184187, slot = L['1h_axe']}) -- Taskmaster's Tenderizer
    }
}) -- Taskmaster Xox

map.nodes[24184297] = Rare({
    id = 162180,
    quest = 58678,
    note = L['leeda_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48870}),
        Transmog({item = 184180, slot = L['cloth']}) -- Leeda's Unrefined Mask
    }
}) -- Thread Mistress Leeda

map.nodes[33718016] = Rare({
    id = 162819,
    quest = 58889,
    rewards = {
        Achievement({id = 14308, criteria = 48875}),
        Transmog({item = 184288, slot = L['shield']}), -- Ruthless Warlord's Barrier
        Mount({item = 182085, id = 1372}) -- Blisterback Bloodtusk
    }
}) -- Warbringer Mal'Korak

map.nodes[28965138] = Rare({
    id = 157125,
    quest = 59290,
    requires = ns.requirement.Item(175841),
    note = L['zargox_the_reborn_note'],
    rewards = {
        Achievement({id = 14308, criteria = 48864}),
        Achievement({id = 14763, criteria = 49929}), -- Ashen Ink
        Transmog({item = 184285, slot = L['plate']}), -- Boneclutched Shackles
        Transmog({item = 181804, slot = L['cosmetic'], covenant = NECROLORD}) -- Trophy of the Reborn Bonelord
    },
    pois = {POI({26314280})}
}) -- Zargox the Reborn

------------------------- POOL OF MIXED MONSTROSITIES -------------------------

local OOZE = '|T646670:0|t'
local GOO = '|T136007:0|t'
local OIL = '|T136124:0|t'

map.nodes[57007421] = Rare({
    id = 157226,
    quest = {61718, 61719, 61720, 61721, 61722, 61723, 61724},
    questCount = true,
    note = L['mixed_pool_note'],
    rewards = {
        Achievement({
            id = 14721,
            criteria = {
                {
                    id = 48858,
                    quest = 61721,
                    note = OOZE .. ' > ' .. GOO .. ' ' .. OIL
                }, -- Gelloh
                {
                    id = 48863,
                    quest = 61719,
                    note = GOO .. ' > ' .. OOZE .. ' ' .. OIL
                }, -- Corrupted Sediment
                {
                    id = 48854,
                    quest = 61718,
                    note = OIL .. ' > ' .. OOZE .. ' ' .. GOO
                }, -- Pulsing Leech
                {
                    id = 48860,
                    quest = 61722,
                    note = '(' .. OOZE .. ' = ' .. GOO .. ') > ' .. OIL
                }, -- Boneslurp
                {
                    id = 48862,
                    quest = 61723,
                    note = '(' .. OOZE .. ' = ' .. OIL .. ') > ' .. GOO
                }, -- Burnblister
                {
                    id = 48861,
                    quest = 61720,
                    note = '(' .. GOO .. ' = ' .. OIL .. ') > ' .. OOZE
                }, -- Violet Mistake
                {
                    id = 48859,
                    quest = 61724,
                    note = OOZE .. ' = ' .. GOO .. ' = ' .. OIL
                } -- Oily Invertebrate
            }
        }), Transmog({item = 184302, slot = L['mail'], note = '{npc:157308}'}), -- Residue-Coated Muck Waders
        Transmog({item = 184175, slot = L['wand'], note = '{npc:157311}'}), -- Bone-Blistering Wand
        Transmog({item = 184301, slot = L['leather'], note = '{npc:157309}'}), -- Twenty-Loop Violet Girdle
        Transmog({item = 184300, slot = L['cloak'], note = '{npc:157312}'}), -- Fused Spineguard
        Transmog({item = 184156, slot = L['cosmetic'], note = '{npc:157312}'}), -- Recovered Containment Pack
        ns.reward.Spacer(),
        Pet({item = 181270, id = 2960, note = '{npc:157312}'}), -- Decaying Oozewalker
        Toy({item = 183903}), -- Smelly Jelly
        Mount({item = 182079, id = 1410, note = '{npc:157309}'}) -- Slime-Covered Reins of the Hulking Deathroc
    }
})

------------------------------- THEATER OF PAIN -------------------------------

map.nodes[50354728] = Rare({
    id = 162853,
    quest = 62786,
    label = C_Map.GetMapInfo(1683).name,
    note = L['theater_of_pain_note'],
    rewards = {
        Achievement({
            id = 14802,
            criteria = {
                50397, -- Azmogal
                50398, -- Unbreakable Urtz
                50399, -- Xantuth the Blighted
                50400, -- Mistress Dyrax
                50402, -- Devmorta
                50403, -- Ti'or
                48874 -- Sabriel the Bonecleaver
            }
        }), Mount({item = 184062, id = 1437}) -- Gnawed Reins of the Battle-Bound Warhound
    }
})

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[44083989] = Treasure({
    quest = 60368,
    label = L['blackhound_cache'],
    note = L['blackhound_cache_note'],
    covenant = NECROLORD,
    rewards = {
        Achievement({id = 14833, criteria = 49917, covenant = NECROLORD}),
        Achievement({id = 14833, criteria = 49922, covenant = NECROLORD}),
        Transmog({item = 183619, slot = L['2h_axe']}), -- Everlasting Boneforged Greataxe
        Transmog({item = 181800, slot = L['cosmetic'], covenant = NECROLORD}), -- Standard of the Blackhound Warband
        Toy({item = 184318}) -- Battlecry of Krexus
    }
}) -- Blackhound Cache

-- map.nodes[36797862] = Treasure({
--     label=L["bladesworn_supply_cache"]
-- }) -- Bladesworn Supply Cache

map.nodes[54011234] = Treasure({
    label = L['cache_of_eyes'],
    note = L['cache_of_eyes_note'],
    rewards = {
        Pet({item = 181171, id = 2947}) -- Luminous Webspinner
    },
    -- Still no quest id for this chest, so we'll just complete when collected
    IsCompleted = function(self) return self:IsCollected() end
}) -- Cache of Eyes

map.nodes[48301630] = Treasure({
    quest = 59244,
    rewards = {
        Achievement({id = 14312, criteria = 50070}), Item({item = 183696}) -- Sp-eye-glass
    }
}) -- Chest of Eyes

Map({id = 1649}).nodes[34565549] = Treasure({
    quest = 58710,
    note = L['forgotten_mementos'],
    parent = map.id,
    rewards = {Achievement({id = 14312, criteria = 50069})},
    pois = {
        POI({25815353}) -- Vault Portcullis Chain
    }
}) -- Forgotten Mementos

map.nodes[41511953] = Treasure({
    quest = 62602, -- Currently account-wide? Spinebug is lootable on alts but treasure is gone
    label = L['giant_cache_of_epic_treasure'],
    note = L['spinebug_note'],
    rewards = {
        Pet({id = 3047}) -- Spinebug
    }
}) -- Giant Cache of Epic Treasure

map.nodes[72895365] = Treasure({
    quest = 61484,
    note = L['glutharns_note'],
    rewards = {Achievement({id = 14312, criteria = 50072})}
}) -- Glutharn's Stash

map.nodes[30792874] = Treasure({
    quest = 60730,
    rewards = {Achievement({id = 14312, criteria = 50065})}
}) -- Halis's Lunch Pail

map.nodes[32742127] = Treasure({
    quest = 60587,
    note = L['kyrian_keepsake_note'],
    rewards = {
        Achievement({id = 14312, criteria = 50064}), Item({item = 180085}),
        Item({item = 175708, note = L['neck']})
    }
}) -- Kyrian Keepsake

map.nodes[62405997] = Treasure({
    quest = 60311,
    note = L['misplaced_supplies'],
    rewards = {Achievement({id = 14312, criteria = 50071})},
    pois = {
        POI({61925851}) -- Way up
    }
}) -- Misplaced Supplies

map.nodes[42382333] = Treasure({
    quest = 61470,
    note = L['necro_tome_note'],
    rewards = {
        Achievement({id = 14312, criteria = 50068}), Toy({item = 182732}) -- The Necronom-i-nom
    },
    pois = {
        POI({40693305}) -- NPC location
    }
}) -- Necro Tome

map.nodes[47236216] = Treasure({
    quest = 59358,
    rewards = {
        Achievement({id = 14312, criteria = 50063}),
        Transmog({item = 180749, slot = L['shield']}) -- Hauk's Battle-Scarred Bulwark
    }
}) -- Ornate Bone Shield

map.nodes[57667581] = Treasure({
    quest = 61474,
    note = L['plaguefallen_chest_note'],
    rewards = {
        Achievement({id = 14312, criteria = 50074}),
        Pet({item = 183515, id = 3045}) -- Iridescent Ooze
    },
    pois = {POI({62487656})}
}) -- Plaguefallen Chest

map.nodes[64672475] = Treasure({
    quest = 61514,
    requires = ns.requirement.Spell(337041),
    note = L['ritualists_cache_note'],
    rewards = {
        Achievement({id = 14312, criteria = 50075}),
        Item({item = 183517, quest = 62372}) -- Page 76 of the Necronom-i-nom
    }
}) -- Ritualist's Cache

map.nodes[31737004] = Treasure({
    quest = 61491,
    requires = ns.requirement.Item(181777),
    note = L['runespeakers_trove_note'],
    rewards = {
        Achievement({id = 14312, criteria = 50073}),
        Transmog({item = 183516, slot = L['cloth']}) -- Stained Bonefused Mantle
    },
    pois = {POI({37867013})}
}) -- Runespeaker's Trove

local STOLEN_JAR = Treasure({
    quest = 61451,
    note = L['stolen_jar_note'],
    rewards = {
        Achievement({id = 14312, criteria = 50067}),
        Item({item = 182618, quest = 62085}) -- ... Why Me?
    }
}) -- Stolen Jar

map.nodes[66135027] = STOLEN_JAR
map.nodes[66145045] = STOLEN_JAR
map.nodes[73564986] = STOLEN_JAR

map.nodes[55893897] = Treasure({
    quest = {59428, 59429},
    label = '{npc:165037}',
    note = L['strange_growth_note'],
    rewards = {
        -- Item({item=182607}), -- Hairy Egg
        Pet({item = 182606, id = 3013}) -- Bloodlouse Larva
    }
}) -- Strange Growth

map.nodes[59867906] = Treasure({
    quest = 61444,
    note = L['vat_of_slime_note'],
    rewards = {
        Achievement({id = 14312, criteria = 50066}), Toy({item = 181825}) -- Phial of Ravenous Slime
    }
}) -- Vat of Conspicuous Slime

map.nodes[51444848] = Treasure({
    quest = {61127, 61128}, -- {arm, sword}
    questCount = true,
    note = L['oonar_sorrowbane_note'],
    rewards = {
        Achievement({id = 14626, criteria = 0}),
        Pet({item = 181164, id = 2944}), -- Oonar's Arm
        Transmog({item = 180273, slot = L['2h_sword']}) -- Sorrowbane
    },
    pois = {
        POI({
            37114699, -- A Few Bumps Along the Way
            53134131, -- One-Eyed Joby
            53634792, -- Au'larrynar
            76445672 -- Edible Redcaps
        })
    }
}) -- Oonar's Arm and Sorrowbane

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[61907879] = PetBattle({
    id = 175784,
    rewards = {Achievement({id = 14881, criteria = 51054})}
}) -- Gelatinous

map.nodes[26482675] = PetBattle({
    id = 175786,
    rewards = {Achievement({id = 14881, criteria = 51056})}
}) -- Glurp

map.nodes[34005526] = PetBattle({
    id = 173263,
    note = L['rotgut_note'],
    rewards = {
        Achievement({id = 14625, criteria = 49412}), ns.reward.Spacer(),
        Achievement({id = 14868, criteria = 4, oneline = true}), -- Aquatic
        Achievement({id = 14869, criteria = 4, oneline = true}), -- Beast
        Achievement({id = 14870, criteria = 4, oneline = true}), -- Critter
        Achievement({id = 14871, criteria = 4, oneline = true}), -- Dragon
        Achievement({id = 14872, criteria = 4, oneline = true}), -- Elemental
        Achievement({id = 14873, criteria = 4, oneline = true}), -- Flying
        Achievement({id = 14874, criteria = 4, oneline = true}), -- Humanoid
        Achievement({id = 14875, criteria = 4, oneline = true}), -- Magic
        Achievement({id = 14876, criteria = 4, oneline = true}), -- Mechanical
        Achievement({id = 14877, criteria = 4, oneline = true}) -- Undead
    }
}) -- Rotgut

map.nodes[46865000] = PetBattle({
    id = 173257,
    note = L['maximillian_note'],
    rewards = {
        Achievement({id = 14625, criteria = 49413}), ns.reward.Spacer(),
        Achievement({id = 14868, criteria = 6, oneline = true}), -- Aquatic
        Achievement({id = 14869, criteria = 6, oneline = true}), -- Beast
        Achievement({id = 14870, criteria = 6, oneline = true}), -- Critter
        Achievement({id = 14871, criteria = 6, oneline = true}), -- Dragon
        Achievement({id = 14872, criteria = 6, oneline = true}), -- Elemental
        Achievement({id = 14873, criteria = 6, oneline = true}), -- Flying
        Achievement({id = 14874, criteria = 6, oneline = true}), -- Humanoid
        Achievement({id = 14875, criteria = 6, oneline = true}), -- Magic
        Achievement({id = 14876, criteria = 6, oneline = true}), -- Mechanical
        Achievement({id = 14877, criteria = 6, oneline = true}) -- Undead
    }
}) -- Caregiver Maximillian

map.nodes[54062806] = PetBattle({
    id = 173274,
    rewards = {Achievement({id = 14625, criteria = 49410})}
}) -- Gorgemouth

map.nodes[63234687] = PetBattle({
    id = 173267,
    note = L['dundley_note'],
    rewards = {
        Achievement({id = 14625, criteria = 49411}), ns.reward.Spacer(),
        Achievement({id = 14868, criteria = 5, oneline = true}), -- Aquatic
        Achievement({id = 14869, criteria = 5, oneline = true}), -- Beast
        Achievement({id = 14870, criteria = 5, oneline = true}), -- Critter
        Achievement({id = 14871, criteria = 5, oneline = true}), -- Dragon
        Achievement({id = 14872, criteria = 5, oneline = true}), -- Elemental
        Achievement({id = 14873, criteria = 5, oneline = true}), -- Flying
        Achievement({id = 14874, criteria = 5, oneline = true}), -- Humanoid
        Achievement({id = 14875, criteria = 5, oneline = true}), -- Magic
        Achievement({id = 14876, criteria = 5, oneline = true}), -- Mechanical
        Achievement({id = 14877, criteria = 5, oneline = true}) -- Undead
    }
}) -- Dundley Stickyfingers

-------------------------------------------------------------------------------
------------------------------- NINE AFTERLIVES -------------------------------
-------------------------------------------------------------------------------

local Kitten = Class('Kitten', Collectible, {
    sublabel = L['pet_cat'],
    icon = 3732497, -- inv_catslime
    group = ns.groups.SLIME_CAT
})

map.nodes[65225065] = Kitten({
    id = 174224,
    rewards = {Achievement({id = 14634, criteria = 49428})}
}) -- Envy

map.nodes[51002750] = Kitten({
    id = 174230,
    rewards = {Achievement({id = 14634, criteria = 49430})},
    note = L['lime']
}) -- Lime

map.nodes[49461761] = Kitten({
    id = 174234,
    rewards = {Achievement({id = 14634, criteria = 49431})}
}) -- Mayhem

map.nodes[34305310] = Kitten({
    id = 174237,
    rewards = {Achievement({id = 14634, criteria = 49433})}
}) -- Meowmalade

map.nodes[47533375] = Kitten({
    id = 174236,
    rewards = {Achievement({id = 14634, criteria = 49432})},
    note = L['moldstopheles']
}) -- Moldstopheles

map.nodes[64802240] = Kitten({
    id = 174226,
    rewards = {Achievement({id = 14634, criteria = 49429})}
}) -- Mr. Jigglesworth

map.nodes[50246027] = Kitten({
    id = 174223,
    rewards = {Achievement({id = 14634, criteria = 49427})},
    note = L['pus_in_boots']
}) -- Pus-In-Boots

map.nodes[32005700] = Kitten({
    id = 174221,
    rewards = {Achievement({id = 14634, criteria = 49426})}
}) -- Snots

Map({id = 1697}).nodes[45203680] = Kitten({
    id = 174195,
    parent = map.id,
    rewards = {Achievement({id = 14634, criteria = 49425})},
    note = L['hairball']
}) -- Hairball

-------------------------------------------------------------------------------
------------------------------- CRYPT COUTURE ---------------------------------
-------------------------------------------------------------------------------

map.nodes[28805160] = Collectible({
    label = L['ashen_ink_label'],
    icon = 134846,
    quest = 62404,
    note = L['ashen_ink_note'] .. '\n\n' .. L['zargox_the_reborn_note'],
    requires = ns.requirement.Item(175841),
    group = ns.groups.CRYPT_COUTURE,
    rewards = {
        Item({item = 183690, quest = 62404}), -- Ashen Ink
        Achievement({id = 14763, criteria = 49929})
    },
    pois = {POI({26314280})}
}) -- Ashen Ink

map.nodes[49602360] = Collectible({
    label = L['jagged_bonesaw_label'],
    icon = 1064192,
    quest = 62408,
    note = L['jagged_bonesaw_note'],
    group = ns.groups.CRYPT_COUTURE,
    rewards = {
        Item({item = 183692, quest = 62408}), -- Jagged Bonesaw
        Achievement({id = 14763, criteria = 49930})
    }
}) -- Jagged Bonesaw

map.nodes[70402780] = Collectible({
    label = L['discarded_grimoire_label'],
    icon = 133737,
    quest = 62297, -- A Fatal Failure
    note = L['discarded_grimoire_note'],
    group = ns.groups.CRYPT_COUTURE,
    rewards = {
        Item({item = 183394, quest = 62266}), -- Discarded Grimoire
        Achievement({id = 14763, criteria = 49931})
    }
}) -- Discarded Grimoire

local sorcerersBlade = Collectible({
    label = L['sorcerers_blade_label'],
    icon = 463557,
    quest = 62306, -- Casting Doubt
    note = L['sorcerers_blade_note'],
    group = ns.groups.CRYPT_COUTURE,
    rewards = {
        Item({item = 183397, quest = 62306}), -- Sorcerer's Blade
        Achievement({id = 14763, criteria = 49932})
    }
}) -- Sorcerer's Blade

map.nodes[70962857] = sorcerersBlade
vos.nodes[46623172] = sorcerersBlade

map.nodes[64007000] = Collectible({
    label = L['mucosal_pigment_label'],
    icon = 134877,
    quest = 62405,
    note = L['mucosal_pigment_note'],
    group = ns.groups.CRYPT_COUTURE,
    rewards = {
        Item({item = 183691, quest = 62405}), -- Mucosal Pigment
        Achievement({id = 14763, criteria = 49933})
    },
    pois = {
        Path({
            Circle({origin = 64007000, radius = 5}) -- House of Plagues
        }), Path({
            Circle({origin = 52663542, radius = 2}) -- Bubbleblood
        })
    }
}) -- Mucosal Pigment

map.nodes[71603280] = Collectible({
    label = L['amethystine_dye_label'],
    icon = 1385242,
    quest = 62320, -- Regalia de Rigueur
    note = L['amethystine_dye_note'],
    group = ns.groups.CRYPT_COUTURE,
    rewards = {
        Item({item = 183401, quest = 62319}), -- Amethystine Dye
        Achievement({id = 14763, criteria = 49934})
    },
    pois = {
        POI({
            70773279, 68993365, 69063276, 64682644, 65222826, 65042801,
            68032986, 70183124, 71623558
        })
    }
}) -- Amethystine Dye

map.nodes[67803060] = Collectible({
    label = L['ritualists_mantle_label'],
    icon = 3087539,
    quest = 62308, -- Mantle of Mastery
    note = L['ritualists_mantle_note'],
    group = ns.groups.CRYPT_COUTURE,
    rewards = {
        Item({item = 183399, quest = 62311}), -- Ritualists Mantle
        Achievement({id = 14763, criteria = 49935})
    }
}) -- Ritualists Mantle

-------------------------------------------------------------------------------
------------------ TO ALL THE SQUIRRELS I'VE LOVED AND LOST -------------------
-------------------------------------------------------------------------------

map.nodes[49006010] = Squirrel({
    id = 167353,
    rewards = {Achievement({id = 14731, criteria = 50260})},
    pois = {
        POI({
            270405900, 270605900, 310802820, 320002360, 440006140, 440006160,
            440206380, 440406320, 440606060, 440805820, 440806180, 450006360,
            450206340, 450405860, 450605920, 460205960, 460206060, 460406160,
            460605760, 460605900, 460805980, 470206160, 470405740, 470406140,
            470605880, 470806020, 480405820, 480605820, 480805940, 490005980,
            630203120, 630203200, 640403220, 640603220, 650602520, 650803560,
            660003520, 680002860, 680802280, 690203060, 690402540, 690402660
        })
    }
}) -- Chittering Claw

map.nodes[48506050] = Squirrel({
    id = 167354,
    rewards = {Achievement({id = 14731, criteria = 50261})},
    pois = {
        POI({
            260043000, 270051080, 282051000, 298049060, 314031000, 318041040,
            320041080, 322027060, 324066000, 330065060, 338031000, 354023000,
            354047080, 366046080, 368046000, 374049080, 374050060, 378049000,
            380050040, 380050060, 404074060, 452063080, 458057080, 458059080,
            462057040, 470057080, 472062000, 482057080, 482065020, 484060020,
            486060020, 486064040, 490064060, 500060060, 504066080, 510067020,
            514068000, 522067080, 524036040, 524036060, 526065000, 550033060,
            550068000, 552037040, 554032060, 554052000, 556033080, 558032060,
            558054060, 560036080, 648034080
        })
    }
}) -- Writhing Rachis

map.nodes[57806650] = Squirrel({
    id = 174650,
    rewards = {Achievement({id = 14731, criteria = 50262})},
    pois = {
        POI({
            40603120, 41803040, 41803200, 42203100, 43003360, 44203180,
            44403260, 44603260, 45002880, 49202360, 49402240, 49402280,
            49602300, 50001940, 50002080, 50202200, 50602120, 50801900,
            51401820, 51402020, 51601900, 51801800, 51802000, 57206060,
            57406180, 57406380, 57606380, 57606620, 58006500, 58406200,
            59206140, 59206200, 59206280, 61204880, 61604900, 62005080,
            62204980, 62604960, 63005120, 63006220, 63205180, 63404880,
            63605000, 63805160, 63805520, 64205280, 66205200, 66405300,
            69805040, 70804780, 71404980, 72805320
        })
    }
}) -- Bubbling Refuse

-------------------------------------------------------------------------------
--------------------------------- SOULSHAPES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[45006500] = Soulshape({
    id = 182105,
    icon = 2399239,
    note = L['soulshape_saurid_note'],
    rewards = {
        Item({item = 187878, quest = 64995, covenant = NIGHTFAE}) -- Saurid Soul
    }
}) -- Saurid Soul
