-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local Class = ns.Class
local L = ns.locale
local Map = ns.RiftMap

local Collectible = ns.node.Collectible
local NPC = ns.node.NPC
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Quest = ns.reward.Quest
local Section = ns.reward.Section
local Spacer = ns.reward.Spacer
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Arrow = ns.poi.Arrow
local Line = ns.poi.Line
local Path = ns.poi.Path
local POI = ns.poi.POI

local KYRIAN = ns.covenants.KYR
local NECROLORD = ns.covenants.NEC
local NIGHTFAE = ns.covenants.FAE
local VENTHYR = ns.covenants.VEN

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local map = Map({id = 1543, phased = false, settings = true})

function map:Prepare()
    Map.Prepare(self)
    self.phased = C_QuestLog.IsQuestFlaggedCompleted(62907)
end

function map:CanDisplay(node, coord, minimap)
    local covenant = node.assault or node.noassault
    if covenant then
        local quest = covenant.assault
        local active = C_TaskQuest.GetQuestTimeLeftMinutes(quest) or
                           C_QuestLog.IsQuestFlaggedCompleted(quest)
        if node.assault and not active then return false end
        if node.noassault and active then return false end
    end
    return Map.CanDisplay(self, node, coord, minimap)
end

local ext = Map({id = 1822}) -- Extractor's Sanatorium
local pitu = Map({id = 1820}) -- Pit of Anguish (upper)
local pitl = Map({id = 1821}) -- Pit of Anguish (lower)

-- Enabler functions for rewards tied to the Hand of Nilganihmaht mount
local HasNilg = function()
    return select(11, C_MountJournal.GetMountInfoByID(1503))
end
local NilgEnabled = function(self)
    if HasNilg() then return false end
    return Item.IsEnabled(self)
end
local NilgCompleted = function(self)
    if HasNilg() then return true end
    return Collectible.IsCompleted(self)
end

-------------------------------------------------------------------------------
------------------------------------ INTRO ------------------------------------
-------------------------------------------------------------------------------

local MawIntro = Class('MawIntro', ns.node.Intro, {
    quest = 62907, -- Eye of the Jailor activation
    label = L['return_to_the_maw'],
    note = L['maw_intro_note']
})

map.intro = MawIntro({
    rewards = {
        Quest({
            id = {
                62882, -- Setting the Ground Rules
                60287 -- Rule 1: Have an Escape Plan
            }
        })
    }
})

map.nodes[80306280] = map.intro

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[25923116] = Rare({
    id = 157964,
    quest = 57482,
    noassault = NIGHTFAE,
    note = L['dekaris_note'],
    rlabel = ns.status.LightBlue('+80 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49841}),
        Transmog({item = 186222, slot = L['mail']}) -- Grips of the Coldheart Adjutant
    }
}) -- Adjutant Dekaris

map.nodes[19324172] = Rare({
    id = 170301,
    quest = 60788,
    noassault = NIGHTFAE,
    note = L['apholeias_note'],
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49842}),
        Item({item = 184106, note = L['ring']}), -- Gimble
        Item({item = 182327}) -- Dominion Etching: Loss
    }
}) -- Apholeias, Herald of Loss

map.nodes[39014119] = Rare({
    id = 157833,
    quest = 57469,
    noassault = KYRIAN,
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49843}),
        Transmog({item = 186223, slot = L['mail']}), -- Coif of the Molten Horror
        Toy({item = 184312}) -- Borr-Geth's Fiery Brimstone
    }
}) -- Borr-Geth

map.nodes[27731305] = Rare({
    id = 171317,
    quest = 61106,
    rlabel = ns.status.LightBlue('+80 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49844}),
        Transmog({item = 183887, slot = L['1h_sword']}) -- Suirhtaned, Blade of the Heir
    },
    pois = {
        POI({28601930}) -- during venthyr assault, change place to here
    }
}) -- Conjured Death

map.nodes[60964805] = Rare({
    id = 160770,
    quest = 62281,
    note = L['in_cave'],
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49845}),
        Transmog({item = 186220, slot = L['mail']}) -- Stygian Chestcage
    }
}) -- Darithis the Bleak

map.nodes[49128175] = Rare({
    id = 158025,
    quest = 62282,
    rlabel = ns.status.LightBlue('+80 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49846}),
        Transmog({item = 186611, slot = L['leather']}), -- Taraxis Treads
        Toy({item = 183901}) -- Bonestorm Top
    }
}) -- Darklord Taraxis

map.nodes[61334129] = Rare({
    id = 179779,
    quest = 64251,
    note = L['deomen_note'],
    rewards = {
        Achievement({id = 15107, criteria = 52286}),
        Transmog({item = 187385, slot = L['mail']}), -- Vortex Piercing Headgear
        Transmog({item = 187367, slot = L['1h_sword']}) -- Deomen's Vortex Blade
    },
    pois = {
        POI({63274368}) -- Entrance
    }
}) -- Deomen the Vortex

map.nodes[28086058] = Rare({
    id = 170711,
    quest = 60909,
    noassault = NECROLORD,
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49847}),
        Transmog({item = 186209, slot = L['cloth']}) -- Blood-Spattered Gloves of Death
    }
}) -- Dolos <Death's Knife>

map.nodes[23765341] = Rare({
    id = 170774,
    quest = 60915,
    noassault = NIGHTFAE,
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49848}),
        Transmog({item = 186563, slot = L['polearm']}) -- Spear of the Impaler
    }
}) -- Eketra <The Impaler>

map.nodes[42342108] = Rare({
    id = 169827,
    quest = 60666,
    note = L['ekphoras_note'],
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49849}),
        Item({item = 184105, note = L['ring']}), -- Gyre
        Item({item = 182328}) -- Dominion Etching: Grief
    }
}) -- Ekphoras, Herald of Grief

map.nodes[19194608] = Rare({ -- was 27584966
    id = 154330,
    quest = 57509,
    noassault = NIGHTFAE,
    rlabel = ns.status.LightBlue('+80 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49850}),
        Transmog({item = 186212, slot = L['cloth']}), -- Eternas' Braided Waistcord
        Pet({item = 183407, id = 3037}) -- Contained Essence of Dread
    }
}) -- Eternas the Tormentor

map.nodes[20586935] = Rare({
    id = 170303,
    quest = 62260,
    note = L['exos_note'],
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    fgroup = 'nilganihmaht_group',
    rewards = {
        Achievement({id = 14744, criteria = 49851}),
        Item({item = 184108, note = L['neck']}), -- Vorpal Amulet
        Item({item = 183066, quest = 63160}), -- Korrath's Grimoire: Aleketh
        Item({item = 183067, quest = 63161}), -- Korrath's Grimoire: Belidir
        Item({item = 183068, quest = 63162}), -- Korrath's Grimoire: Gyadrek
        Item({item = 186606, bag = true, IsEnabled = NilgEnabled}) -- Nilganihmaht's Signet Ring
    }
}) -- Exos, Herald of Domination

map.nodes[17714953] = Rare({
    id = 179460,
    quest = 64164,
    note = L['fallen_charger_note'],
    rewards = {
        Achievement({id = 15107, criteria = 52292}),
        Mount({item = 186659, id = 1502}) -- Fallen Charger's Reins
    },
    pois = {
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
        }), Path({
            17634964, 18664848, 19304835, 21494366, 25543659, 31283745,
            32144455, 36304799, 34295466, 36736413, 44056349, 45347403,
            48928415, 55528687
        })
    }
}) -- Fallen Charger

map.nodes[30775000] = Rare({
    id = 175012,
    quest = 62788,
    note = L['ikras_note'],
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 50621}),
        Transmog({item = 186214, slot = L['leather']}) -- Maw Snakeskin Boots
    }
}) -- Ikras the Devourer

map.nodes[16945102] = Rare({
    id = 162849,
    quest = 60987,
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49852}),
        Transmog({item = 185892, slot = L['2h_sword']}), -- Stygia-Etched Decapitator
        Toy({item = 184292}) -- Ancient Elethium Coin
    },
    pois = {
        POI({18904410}) -- during nightfae assault, change place to here
    }
}) -- Morguliax <Lord of Decapitation>

map.nodes[45507376] = Rare({
    id = 158278,
    quest = 57573,
    note = L['in_small_cave'],
    rlabel = ns.status.LightBlue('+80 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49853}),
        Transmog({item = 186236, slot = L['leather']}) -- Devourer's Shadehide Jerkin
    }
}) -- Nascent Devourer

map.nodes[48801830] = Rare({
    id = 164064,
    quest = 60667,
    rlabel = ns.status.LightBlue('+80 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49854}),
        Transmog({item = 186238, slot = L['cloth']}) -- Mantle of the Prime Collector
    }
}) -- Obolos <Prime Adjutant>

map.nodes[23692139] = Rare({
    id = 172577,
    quest = 61519,
    note = L['orophea_note'],
    rlabel = ns.status.LightBlue('+80 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49855}),
        Transmog({item = 186211, slot = L['cloth']}), -- Pantaloons of the Condemned Bard
        Toy({item = 181794}) -- Orophea's Lyre
    },
    pois = {
        POI({26772932}) -- Eurydea's Amulet
    }
}) -- Orophea

map.nodes[32946646] = Rare({
    id = 170634,
    quest = 60884,
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49856}),
        Item({item = 183066, quest = 63160}), -- Korrath's Grimoire: Aleketh
        Item({item = 183067, quest = 63161}), -- Korrath's Grimoire: Belidir
        Item({item = 183068, quest = 63162}), -- Korrath's Grimoire: Gyadrek
        Transmog({item = 185945, slot = L['staff']}), -- Shadeweaver's Spire
        Toy({item = 181794}) -- Orophea's Lyre
    }
}) -- Shadeweaver Zeris

map.nodes[35974156] = Rare({
    id = 166398,
    quest = 60834,
    noassault = KYRIAN,
    rlabel = ns.status.LightBlue('+80 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49857}),
        Transmog({item = 186613, slot = L['mail']}) -- Rhovus' Linked Greaves
    }
}) -- Soulforger Rhovus

map.nodes[28701204] = Rare({
    id = 170302,
    quest = 60789, -- 62722?
    note = L['talaporas_note'],
    noassault = VENTHYR,
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49858}),
        Transmog({item = 184107, slot = L['cloak']}), -- Borogove Cloak
        Item({item = 182326}) -- Dominion Etching: Pain
    }
}) -- Talaporas, Herald of Pain

map.nodes[27397152] = Rare({
    id = 170731,
    quest = 60914,
    noassault = NECROLORD,
    rlabel = ns.status.LightBlue('+100 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49859}),
        Transmog({item = 186234, slot = L['plate']}) -- Girdle of the Death Speaker
    }
}) -- Thanassos <Death's Voice>

map.nodes[69044897] = Rare({
    id = 179805,
    quest = 64258, -- 64439?
    rewards = {
        Achievement({id = 15107, criteria = 52289}),
        Transmog({item = 187364, slot = L['1h_sword']}), -- Maldraxxi Traitor's Blade
        Transmog({item = 187374, slot = L['cloth']}) -- Balthier's Waistcord
    }
}) -- Traitor Balthier

map.nodes[37446212] = Rare({
    id = 172862,
    quest = 61568,
    noassault = NECROLORD,
    note = L['yero_note'],
    rlabel = ns.status.LightBlue('+80 ' .. L['rep']),
    rewards = {
        Achievement({id = 14744, criteria = 49860}),
        Transmog({item = 186228, slot = L['plate']}) -- Helm of the Skittish Hero
    },
    pois = {
        Path({
            37976153, 38786073, 39155953, 38795855, 37925852, 37375934,
            37346068, 37446212
        })
    }
}) -- Yero the Skittish

map.nodes[66404400] = Rare({
    id = 177444,
    quest = 64152,
    rewards = {
        Achievement({id = 15107, criteria = 52287}),
        Achievement({id = 14943, criteria = 51681}),
        Transmog({item = 187359, slot = L['shield']}), -- Ylva's Water Dish
        Transmog({item = 186217, slot = L['leather']}), -- Supple Helhound Leather Pants
        Transmog({item = 187393, slot = L['plate']}), -- Sterling Hound-Handler's Gauntlets
        Item({
            item = 186970,
            quest = 62683,
            note = '{item:186727}',
            IsEnabled = NilgEnabled
        }) -- Feeder's Hand and Key / Seal Breaker Key
    }
}) -- Ylva, Mate of Guarm

-------------------------------------------------------------------------------

map.nodes[36034433] = Rare({
    id = 179853,
    quest = 64276,
    rlabel = ns.GetIconLink('portal_gy', 20, 4, 1),
    note = L['rift_rare_only_note'],
    rift = 2,
    rewards = {
        Achievement({id = 15107, criteria = 52297}),
        Item({item = 187406, note = L['ring']}), -- Band of Blinding Shadows
        Transmog({item = 187361, slot = L['bow']}) -- Rift-Bound Shadow Piercer
    }
}) -- Blinding Shadow

map.nodes[49307274] = Rare({
    id = 179851,
    quest = 64272,
    rlabel = ns.status.LightBlue(L['plus_research']) ..
        ns.GetIconLink('portal_gy', 20, 4, 1),
    note = L['rift_rare_only_note'],
    rewards = {
        Achievement({id = 15107, criteria = 52293}),
        Transmog({item = 187363, slot = L['polearm']}), -- Orguluus' Spear
        Transmog({item = 187398, slot = L['leather']}) -- Chestguard of the Shadeguard
    },
    rift = 2,
    pois = {
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
    id = 179735,
    quest = 64232,
    rlabel = ns.GetIconLink('portal_gy', 20, 4, 1),
    note = L['rift_rare_only_note'],
    fgroup = 'nilganihmaht_group',
    rift = 2,
    rewards = {
        Achievement({id = 15107, criteria = 52284}),
        Transmog({item = 187360, slot = L['offhand']}), -- Orb of Enveloping Rifts
        Transmog({item = 187389, slot = L['mail']}), -- Lord of Shade's Binders
        Toy({item = 187139}), -- Bottled Shade Heart
        Item({item = 186605, bag = true, IsEnabled = NilgEnabled}) -- Nilganihmaht's Runed Band
    }
}) -- Torglluun

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[69214521] = Treasure({
    quest = 64256,
    rlabel = ns.status.LightBlue(L['plus_research']),
    rewards = {
        Achievement({id = 15099, criteria = 52243}),
        Item({item = 185902, note = L['trinket']}), -- Iron Maiden's Toolkit
        --[[
        Transmog({item=187014, slot=L["cosmetic"]}), -- Shackler's Spiked Shoulders
        Transmog({item=187018, slot=L["cosmetic"]}), -- Ritualist's Shoulder Scythes
        Transmog({item=187019, slot=L["cosmetic"]}), -- Infiltrator's Shoulderguards
        ]] Transmog({item = 187026, slot = L['cosmetic']}), -- Field Warden's Torture Kit
        Transmog({item = 187240, slot = L['cosmetic']}) -- Field Warden's Watchful Eye
    }
}) -- Helsworn Chest

ext.nodes[62263305] = Treasure({
    quest = 64575,
    label = L['hidden_anima_cache'],
    rift = 1,
    parent = map.id
}) -- Hidden Anima Cache

map.nodes[66526129] = Treasure({
    quest = 64261,
    note = L['in_cave'],
    rewards = {
        Achievement({id = 15099, criteria = 52244}),
        Item({item = 187352, note = L['neck']}) -- Jeweled Heart of Ezekiel
    }
}) -- Jeweled Heart

-------------------------------------------------------------------------------

local Lore = Class('MawLore', Treasure, {
    rlabel = ns.status.LightBlue('+150 ' .. L['rep']),
    IsCompleted = function(self)
        if C_QuestLog.IsOnQuest(self.quest[1]) then return true end
        return Treasure.IsCompleted(self)
    end
})

ext.nodes[73121659] = Lore({
    quest = 63157,
    note = L['box_of_torments_note'],
    parent = {id = map.id, pois = {POI({27702020})}},
    rewards = {
        Achievement({id = 14761, criteria = 49908}),
        Item({item = 183060, quest = 63157})
    }
}) -- Box of Torments

map.nodes[35764553] = Lore({
    quest = 63163,
    note = L['tormentors_notes_note'],
    rewards = {
        Achievement({id = 14761, criteria = 49914}),
        Item({item = 183069, quest = 63163})
    }
}) -- Tormentor's Notes

map.nodes[19363340] = Lore({
    quest = 63159,
    note = L['words_of_warden_note'],
    rewards = {
        Achievement({id = 14761, criteria = 49910}),
        Item({item = 183063, quest = 63159})
    }
}) -- Words of the Warden

-------------------------------------------------------------------------------
---------------------------- BONUS OBJECTIVE BOSSES ---------------------------
-------------------------------------------------------------------------------

local BonusBoss = Class('BonusBoss', NPC, {
    icon = 'peg_rd',
    scale = 1.8,
    group = ns.groups.BONUS_BOSS,
    rlabel = ns.status.LightBlue('+40 ' .. L['rep'])
})

map.nodes[28204450] = BonusBoss({
    id = 169102,
    quest = 61136, -- 63380
    rewards = {
        Achievement({id = 14660, criteria = 49485}),
        Transmog({item = 186616, slot = L['mail']}) -- Bindings of Screaming Death
    }
}) -- Agonix

map.nodes[34087453] = BonusBoss({
    id = 170787,
    quest = 60920,
    noassault = NECROLORD,
    rewards = {
        Achievement({id = 14660, criteria = 49487}),
        Transmog({item = 186617, slot = L['plate']}) -- Death's Hammer Stompers
    }
}) -- Akros <Death's Hammer>

map.nodes[28712513] = BonusBoss({
    id = 168693,
    quest = 61346,
    rewards = {
        Achievement({id = 14660, criteria = 49484}),
        Item({item = 183070, quest = 63164}), -- Mawsworn Orders
        Transmog({item = 186618, slot = L['mail']}) -- Willbreaker's Chain
    }
}) -- Cyrixia <The Willbreaker>

map.nodes[25831479] = BonusBoss({
    id = 162452,
    quest = 59230,
    rewards = {
        Achievement({id = 14660, criteria = 49476}),
        Transmog({item = 186619, slot = L['plate']}) -- Bloodspattered Shoulders of the Flayer
    }
}) -- Dartanos <Flayer of Souls>

map.nodes[19205740] = BonusBoss({
    id = 162844,
    quest = 61140,
    noassault = NIGHTFAE,
    rewards = {
        Achievement({id = 14660, criteria = 50410}),
        Item({item = 183066, quest = 63160}), -- Korrath's Grimoire: Aleketh
        Item({item = 183067, quest = 63161}), -- Korrath's Grimoire: Belidir
        Item({item = 183068, quest = 63162}), -- Korrath's Grimoire: Gyadrek
        Transmog({item = 186620, slot = L['leather']}) -- Rezara's Fencing Grips
    }
}) -- Dath Rezara <Lord of Blades>

map.nodes[31982122] = BonusBoss({
    id = 158314,
    quest = 59183,
    note = L['drifting_sorrow_note'],
    rewards = {
        Achievement({id = 14660, criteria = 49475}),
        Transmog({item = 186622, slot = L['cloth']}) -- Robe of Drifting Sorrow
    }
}) -- Drifting Sorrow

map.nodes[60456478] = BonusBoss({
    id = 172523,
    quest = 62209,
    rewards = {
        Achievement({id = 14660, criteria = 49490}),
        Transmog({item = 186224, slot = L['mail']}) -- Beastwarren Houndmaster's Treads
    }
}) -- Houndmaster Vasanok

map.nodes[20782968] = BonusBoss({
    id = 162965,
    quest = 58918,
    noassault = NIGHTFAE,
    rewards = {
        Achievement({id = 14660, criteria = 49481}),
        Transmog({item = 186623, slot = L['cloth']}) -- Lost Soul's Mantle
    }
}) -- Huwerath

map.nodes[30846866] = BonusBoss({
    id = 170692,
    quest = 63381,
    noassault = NECROLORD,
    rewards = {
        Achievement({id = 14660, criteria = 49486}),
        Transmog({item = 186624, slot = L['cloak']}) -- Death Wing Drape
    }
}) -- Krala <Death's Wings>

map.nodes[27311754] = BonusBoss({
    id = 171316,
    quest = 61125,
    rewards = {
        Achievement({id = 14660, criteria = 49488}),
        Transmog({item = 186625, slot = L['leather']}) -- Hood of Malevolence
    }
}) -- Malevolent Stygia

map.nodes[38642880] = BonusBoss({
    id = 172207,
    quest = 62618,
    rewards = {
        Achievement({id = 14660, criteria = 50408}),
        Achievement({id = 14761, criteria = 49909}),
        Item({item = 183061, quest = 63158}) -- Wailing Coin
    }
}) -- Odalrik

map.nodes[25364875] = BonusBoss({
    id = 162845,
    quest = 60991,
    rewards = {
        Achievement({id = 14660, criteria = 49480}),
        Transmog({item = 186626, slot = L['cloth']}) -- Bloodwicking Bands
    }
}) -- Orrholyn <Lord of Bloodletting>

map.nodes[22674223] = BonusBoss({
    id = 175821,
    quest = 63044, -- 63388 ??
    noassault = NIGHTFAE,
    note = L['in_cave'],
    rewards = {
        Achievement({id = 14660, criteria = 51058}),
        Transmog({item = 186627, slot = L['leather']}) -- Belt of Ten Thousand Tails
    },
    pois = {
        POI({20813927}) -- Cave entrance
    }
}) -- Ratgusher

map.nodes[26173744] = BonusBoss({
    id = 162829,
    quest = 60992,
    rewards = {
        Achievement({id = 14660, criteria = 49479}),
        Transmog({item = 186628, slot = L['plate']}) -- Razkazzar's Axe Grippers
    }
}) -- Razkazzar <Lord of Axes>

map.nodes[55626318] = BonusBoss({
    id = 172521,
    quest = 62210,
    note = L['in_cave'] .. ' ' .. L['sanngror_note'],
    rewards = {
        Achievement({id = 14660, criteria = 49489}),
        Item({item = 186629, note = L['ring']}), -- Sanngors Spiked Band
        Pet({item = 183410, id = 3040}) -- Sharpclaw
    },
    pois = {
        POI({55806753}) -- Cave entrance
    }
}) -- Sanngror the Torturer

pitu.nodes[41767921] = BonusBoss({
    id = 172524,
    quest = 62211,
    note = L['nexus_cave_anguish_upper'],
    rewards = {
        Achievement({id = 14660, criteria = 49491}),
        Transmog({item = 186240, slot = L['cloak']}) -- Broodmotherhide Cloak
    },
    parent = map.id
}) -- Skittering Broodmother

map.nodes[36253744] = BonusBoss({
    id = 165047,
    quest = 59441,
    noassault = KYRIAN,
    rewards = {
        Achievement({id = 14660, criteria = 49482}),
        Transmog({item = 186630, slot = L['plate']}) -- Spark Deflecting Girdle
    }
}) -- Soulsmith Yol-Mattar

map.nodes[36844480] = BonusBoss({
    id = 156203,
    quest = 62539,
    noassault = KYRIAN,
    rewards = {
        Achievement({id = 14660, criteria = 50409}),
        Item({item = 186631, note = L['ring']}) -- Emberfused Band
    }
}) -- Stygian Incinerator

map.nodes[40705959] = BonusBoss({
    id = 173086,
    quest = 61728,
    noassault = NECROLORD,
    note = L['valis_note'],
    rewards = {
        Achievement({id = 14660, criteria = 49492}),
        Transmog({item = 186632, slot = L['leather']}) -- Rune Covered Bindings
    }
}) -- Valis the Cruel

-------------------------------------------------------------------------------
------------------------------ CHAOTIC RIFTSTONES -----------------------------
-------------------------------------------------------------------------------

local Riftstone = Class('Riftstone', ns.node.NPC, {
    id = 174962,
    scale = 1.3,
    group = ns.groups.RIFTSTONE,
    requires = ns.requirement.Venari(63177),
    note = L['chaotic_riftstone_note']
})

-------------------------------------------------------------------------------

map.nodes[19184778] = Riftstone({
    icon = 'portal_rd',
    fgroup = 'riftstone1',
    pois = {Line({19184778, 25211784})}
}) -- Tremaculum <=> Crucible

map.nodes[25211784] = Riftstone({icon = 'portal_rd', fgroup = 'riftstone1'})

-------------------------------------------------------------------------------

map.nodes[23433121] = Riftstone({
    icon = 'portal_bl',
    fgroup = 'riftstone2',
    pois = {Line({23433121, 34804362})}
}) -- Calcis <=> Cauldron

map.nodes[34804362] = Riftstone({icon = 'portal_bl', fgroup = 'riftstone2'})

-------------------------------------------------------------------------------

map.nodes[68773673] = Riftstone({
    icon = 'portal_gn',
    fgroup = 'riftstone3',
    pois = {Line({68773673, 33925666})}
}) -- Desmotaeron <=> Perdition Hold

map.nodes[33925666] = Riftstone({icon = 'portal_gn', fgroup = 'riftstone3'})

-------------------------------------------------------------------------------

map.nodes[19776617] = Riftstone({
    icon = 'portal_pp',
    pois = {Arrow({19776617, 34794350})}
}) -- Perdition Hold => Cauldron

-------------------------------------------------------------------------------

map.nodes[48284145] = NPC({
    group = ns.groups.RIFTSTONE,
    icon = 'portal_bl',
    id = 172925,
    minimap = false,
    note = L['animaflow_teleporter_note'],
    requires = ns.requirement.Venari(61600),
    scale = 1.3,
    pois = {
        Arrow({48284145, 33935677}), -- Perdition Hold
        Arrow({48284145, 34181473}), -- The Tremaculum
        Arrow({48284145, 53426364}), -- The Beastwarrens
        Arrow({48284145, 68883680}) -- Desmotaeron
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
    34237005, 35006680, -- Beast Warrens
    44996655, 47608194, 48397060, 49377318, 49997460, 50027306, 51427820,
    52177614, 52247887, 52957021, 53157840, 53266871, 53726760, 53917700,
    54486713, 54987622, 55247788
}

for _, coord in ipairs(GRAPPLES) do
    map.nodes[coord] = NPC({
        group = ns.groups.GRAPPLES,
        icon = 'peg_bk',
        id = 176308,
        requires = ns.requirement.Venari(63217),
        scale = 1.25
    })
end

-------------------------------------------------------------------------------
------------------------------- STYGIAN CACHES --------------------------------
-------------------------------------------------------------------------------

local Cache = Class('Cache', ns.node.Node, {
    group = ns.groups.STYGIAN_CACHES,
    icon = 'chest_nv',
    label = L['stygian_cache'],
    note = L['stygian_cache_note'],
    scale = 1.3,
    rewards = {ns.reward.Currency({id = 1767, note = '48'})}
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
    note = L['in_cave'],
    pois = {
        POI({55806753}) -- Cave entrance
    }
})
map.nodes[61505080] = Cache()
pitl.nodes[46896760] = Cache({parent = map.id})

-------------------------------------------------------------------------------
--------------------------------- STYGIA NEXUS --------------------------------
-------------------------------------------------------------------------------

local Nexus = Class('StygiaNexus', NPC, {
    group = ns.groups.STYGIA_NEXUS,
    icon = 'peg_gn',
    id = 177632,
    requires = ns.requirement.Item(184870),
    scale = 1.25,
    rift = 2 -- can see in both phases
})

map.nodes[16015170] = Nexus({note = L['nexus_npc_portal']})
map.nodes[16875503] = Nexus({note = L['nexus_area_gorgoa_mouth']})
map.nodes[17745311] = Nexus({note = L['nexus_area_gorgoa_mouth']})
map.nodes[18285458] = Nexus({note = L['nexus_area_gorgoa_mouth']})
map.nodes[18924633] = Nexus({note = L['nexus_npc_eternas']})
map.nodes[19206731] = Nexus({note = L['nexus_area_domination_edge']})
map.nodes[19433790] = Nexus({note = L['nexus_area_calcis_crystals']})
map.nodes[19643533] = Nexus({note = L['nexus_area_calcis_crystals']})
map.nodes[21366560] = Nexus({note = L['nexus_area_domination_room']})
map.nodes[21403189] = Nexus({note = L['nexus_area_calcis_branch']})
map.nodes[21656684] = Nexus({note = L['nexus_area_domination_edge']})
map.nodes[21717193] = Nexus({note = L['nexus_area_domination_stairs']})
map.nodes[25252558] = Nexus({note = L['nexus_area_cradle_bridge']})
map.nodes[22515477] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[22922234] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[22926805] = Nexus({note = L['nexus_misc_grapple_ramparts']})
map.nodes[23044444] = Nexus({note = L['nexus_misc_grapple_ramparts']})
map.nodes[23196996] = Nexus({note = L['nexus_misc_grapple_ramparts']})
map.nodes[23252132] = Nexus({note = L['nexus_npc_orophea']})
map.nodes[23277382] = Nexus({note = L['nexus_area_domination_bridge']})
map.nodes[23493460] = Nexus({note = L['nexus_area_calcis_crystals']})
map.nodes[23776535] = Nexus({note = L['nexus_misc_grapple_ramparts']})
map.nodes[24131667] = Nexus({note = L['nexus_npc_willbreaker']})
map.nodes[24154277] = Nexus({note = L['nexus_area_gorgoa_bank']})
map.nodes[24394690] = Nexus({note = L['nexus_area_gorgoa_bank']})
map.nodes[24703005] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[25016582] = Nexus({note = L['nexus_misc_below_ramparts']})
map.nodes[25156553] = Nexus({note = L['nexus_misc_grapple_ramparts']})
map.nodes[25255011] = Nexus({note = L['nexus_npc_orrholyn']})
map.nodes[25623699] = Nexus({note = L['nexus_cave_forlorn']})
map.nodes[26004499] = Nexus({note = L['nexus_misc_crystal_ledge']})
map.nodes[26153094] = Nexus({note = L['nexus_npc_dekaris']})
map.nodes[26336859] = Nexus({note = L['nexus_misc_grapple_ramparts']})
map.nodes[26744496] = Nexus({note = L['nexus_area_gorgoa_bank']})
map.nodes[26842748] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[27392598] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[27427226] = Nexus({note = L['nexus_npc_thanassos']})
map.nodes[27541273] = Nexus({note = L['nexus_npc_talaporas']})
map.nodes[27906041] = Nexus({note = L['nexus_npc_dolos']})
map.nodes[28573090] = Nexus({note = L['nexus_area_torment_rock']})
map.nodes[28674931] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[30056578] = Nexus({note = L['nexus_misc_below_ramparts']})
map.nodes[30092827] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[32266739] = Nexus({note = L['nexus_misc_grapple_ramparts']})
map.nodes[32506541] = Nexus({note = L['nexus_room_ramparts']})
map.nodes[33064239] = Nexus({note = L['nexus_area_zovaal_wall']})
map.nodes[33182058] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[33156479] = Nexus({note = L['nexus_area_perdition_wall']})
map.nodes[33647481] = Nexus({note = L['nexus_npc_akros']})
map.nodes[33977033] = Nexus({note = L['nexus_misc_grapple_ramparts']})
map.nodes[34076193] = Nexus({note = L['nexus_room_ramparts']})
map.nodes[35446747] = Nexus({note = L['nexus_misc_grapple_ramparts']})
map.nodes[37504334] = Nexus({note = L['nexus_npc_incinerator']})
map.nodes[37544368] = Nexus({note = L['nexus_npc_incinerator']})
map.nodes[37814484] = Nexus({note = L['nexus_area_zovaal_edge']})
map.nodes[39462356] = Nexus({note = L['nexus_area_gorgoa_middle']})
map.nodes[40444906] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[41234967] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[41314784] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[42412320] = Nexus({note = L['nexus_npc_ekphoras']})
map.nodes[43816887] = Nexus({note = L['nexus_area_zone_edge']})
map.nodes[45126671] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[46198136] = Nexus({note = L['nexus_cave_roar_outside']})
map.nodes[47166238] = Nexus({note = L['nexus_road_below']})
map.nodes[48078370] = Nexus({note = L['nexus_cave_howl_outside']})
map.nodes[48327061] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[49917471] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[50047306] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[50958572] = Nexus({note = L['nexus_cave_howl']})
map.nodes[51467820] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[51488386] = Nexus({note = L['nexus_cave_howl']})
map.nodes[51627864] = Nexus({note = L['nexus_misc_three_chains']})
map.nodes[51907098] = Nexus({note = L['nexus_cave_ledge']})
map.nodes[52018189] = Nexus({note = L['nexus_misc_ledge_below']})
map.nodes[52167619] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[52907027] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[53167848] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[53338024] = Nexus({note = L['nexus_cave_anguish_outside']})
map.nodes[53877701] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[53975865] = Nexus({note = L['nexus_road_cave']})
map.nodes[54328482] = Nexus({note = L['nexus_road_mawrats']})
map.nodes[54556720] = Nexus({note = L['nexus_misc_floating_cage']})
map.nodes[54967623] = Nexus({note = L['nexus_misc_grapple_rock']})
map.nodes[55026349] = Nexus({note = L['nexus_cave_torturer']})
map.nodes[55527722] = Nexus({note = L['nexus_cave_prodigum']})
map.nodes[56677080] = Nexus({note = L['nexus_cave_soulstained']})
map.nodes[58435196] = Nexus({note = L['nexus_cave_echoing_outside']})
map.nodes[59007837] = Nexus({note = L['nexus_road_next']})
map.nodes[59056108] = Nexus({note = L['nexus_cave_desmotaeron']})
map.nodes[60866755] = Nexus({note = L['nexus_road_next']})
map.nodes[60927687] = Nexus({note = L['nexus_area_zone_edge']})
map.nodes[61096917] = Nexus({note = L['nexus_cave_desmotaeron']})

pitu.nodes[53376624] = Nexus({
    note = L['nexus_cave_anguish_upper'],
    parent = map.id
})
pitu.nodes[66355542] = Nexus({
    note = L['nexus_cave_anguish_upper'],
    parent = map.id
})
pitl.nodes[45526802] = Nexus({
    note = L['nexus_cave_anguish_lower'],
    parent = map.id
})
pitl.nodes[67185536] = Nexus({
    note = L['nexus_cave_anguish_lower'],
    parent = map.id
})

-------------------------------------------------------------------------------
---------------------------- HELGARDE SUPPLY CACHE ----------------------------
-------------------------------------------------------------------------------

local HELGARDE = ns.node.Node({
    quest = 62682,
    label = L['helgarde_supply'],
    note = L['helgarde_supply_note'],
    group = ns.groups.HELGARDE_CACHE,
    icon = 'chest_gy',
    scale = 0.8,
    rewards = {
        Item({item = 186727, quest = 62682}) -- Seal Breaker Key
    }
})

map.nodes[59305360] = HELGARDE
map.nodes[60405370] = HELGARDE
map.nodes[61204650] = HELGARDE
map.nodes[61406350] = HELGARDE
map.nodes[61504230] = HELGARDE
map.nodes[62005600] = HELGARDE
map.nodes[62305160] = HELGARDE
map.nodes[62475528] = HELGARDE
map.nodes[62506180] = HELGARDE
map.nodes[63505190] = HELGARDE
map.nodes[63806480] = HELGARDE
map.nodes[64205670] = HELGARDE
map.nodes[64405380] = HELGARDE
map.nodes[64906280] = HELGARDE
map.nodes[65305780] = HELGARDE
map.nodes[65603890] = HELGARDE
map.nodes[65705940] = HELGARDE
map.nodes[65706121] = HELGARDE
map.nodes[65904590] = HELGARDE
map.nodes[66205450] = HELGARDE
map.nodes[66606210] = HELGARDE
map.nodes[66706450] = HELGARDE
map.nodes[67004070] = HELGARDE
map.nodes[67205170] = HELGARDE
map.nodes[67305730] = HELGARDE
map.nodes[67535568] = HELGARDE
map.nodes[67705310] = HELGARDE
map.nodes[67906130] = HELGARDE
map.nodes[68204810] = HELGARDE
map.nodes[68704260] = HELGARDE
map.nodes[69204530] = HELGARDE
map.nodes[71204820] = HELGARDE

-------------------------------------------------------------------------------
------------------------------- MAWSWORN CACHES -------------------------------
-------------------------------------------------------------------------------

local ramp_cache = L['mawsworn_cache_ramparts_note'] .. '\n\n' ..
                       L['mawsworn_cache_quest_note']
local tower_cache = L['mawsworn_cache_tower_note'] .. '\n\n' ..
                        L['mawsworn_cache_quest_note']

local MawswornC = Class('MawswornC', Treasure, {
    label = L['mawsworn_cache'],
    note = ramp_cache,
    group = ns.groups.MAWSWORN_CACHE,
    assault = NECROLORD,
    rewards = {
        Achievement({id = 15039, criteria = {id = 1, qty = true}}),
        Item({item = 186573, quest = 63594}) -- Defense Plans
    },
    pois = {
        POI({37196363}) -- Overcharged Centurion
    }
})

local MAW_CACHE1 = MawswornC({quest = 64209, icon = 'chest_yw'}) -- object=369141
local MAW_CACHE2 = MawswornC({quest = 63815, icon = 'chest_pp'}) -- object=368205
local MAW_CACHE3 = MawswornC({
    quest = 63816,
    icon = 'chest_nv',
    note = tower_cache
}) -- object=368206
local MAW_CACHE4 = MawswornC({
    quest = 63817,
    icon = 'chest_gn',
    note = tower_cache
}) -- object=368207
local MAW_CACHE5 = MawswornC({quest = 63818, icon = 'chest_pk'}) -- object=368208
local MAW_CACHE6 = MawswornC({quest = 63825, icon = 'chest_lm'}) -- object=368213
local MAW_CACHE7 = MawswornC({quest = 63826, icon = 'chest_tl'}) -- object=368214

map.nodes[27806170] = MAW_CACHE1
map.nodes[35126980] = MAW_CACHE1
map.nodes[30295581] = MAW_CACHE2
map.nodes[32166738] = MAW_CACHE2
map.nodes[30126497] = MAW_CACHE3
map.nodes[34136157] = MAW_CACHE4
map.nodes[33547047] = MAW_CACHE5
map.nodes[32756506] = MAW_CACHE6
map.nodes[32055633] = MAW_CACHE7
map.nodes[33795741] = MAW_CACHE7

-------------------------------------------------------------------------------
----------------------------- RIFT HIDDEN CACHES ------------------------------
-------------------------------------------------------------------------------

local RiftCache = Class('RiftCache', Treasure, {
    label = L['rift_hidden_cache'],
    group = ns.groups.RIFT_HIDDEN_CACHE,
    rift = 1,
    assault = NIGHTFAE,
    rewards = {
        Achievement({id = 15001, criteria = {id = 1, qty = true}}),
        Transmog({item = 187251, slot = L['cosmetic']}) -- Shaded Skull Shoulderguards
    }
})

local RIFT_CACHE1 = RiftCache({quest = 63995, icon = 'chest_rd'})
local RIFT_CACHE2 = RiftCache({quest = 63997, icon = 'chest_bl'})
local RIFT_CACHE3 = RiftCache({quest = 63998, icon = 'chest_yw'})
local RIFT_CACHE4 = RiftCache({quest = 63996, icon = 'chest_pp'})
local RIFT_CACHE5 = RiftCache({quest = 63999, icon = 'chest_gn'})
local RIFT_CACHE6 = RiftCache({quest = 63993, icon = 'chest_pk'})

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
-------------------------------- ANIMA VESSELS --------------------------------
-------------------------------------------------------------------------------

local Vessel = Class('AnimaVessel', Treasure, {
    label = L['stolen_anima_vessel'],
    rlabel = ns.status.LightBlue(L['plus_research']),
    group = ns.groups.ANIMA_VESSEL
})

-- In the rift
local RIFT_VESSEL1 = Vessel({
    icon = 'chest_rd',
    fgroup = 'rv1',
    quest = 64265,
    rift = 1
}) -- object=369227
local RIFT_VESSEL2 = Vessel({
    icon = 'chest_bl',
    fgroup = 'rv2',
    quest = 64269,
    rift = 1
}) -- object=369235
local RIFT_VESSEL3 = Vessel({
    icon = 'chest_yw',
    fgroup = 'rv3',
    quest = 64270,
    rift = 1
}) -- object=369236
-- Necrolord assault
local NEC_VESSEL1 = Vessel({
    icon = 'chest_rd',
    fgroup = 'nv1',
    quest = 64044,
    assault = NECROLORD
}) -- object=368946
local NEC_VESSEL2 = Vessel({
    icon = 'chest_bl',
    fgroup = 'nv2',
    quest = 64045,
    assault = NECROLORD
}) -- object=368947
-- Venthyr assault
local VEN_VESSEL1 = Vessel({
    icon = 'chest_rd',
    fgroup = 'vv1',
    quest = 64055,
    assault = VENTHYR
}) -- object=368948
local VEN_VESSEL2 = Vessel({
    icon = 'chest_bl',
    fgroup = 'vv2',
    quest = 64056,
    assault = VENTHYR
}) -- object=368949
-- Kyrian assault
local KYR_VESSEL1 = Vessel({
    icon = 'chest_rd',
    fgroup = 'kv1',
    quest = 64057,
    assault = KYRIAN
}) -- object=368950
local KYR_VESSEL2 = Vessel({
    icon = 'chest_bl',
    fgroup = 'kv2',
    quest = 64058,
    assault = KYRIAN
}) -- object=368951
-- Night Fae assault
local FAE_VESSEL1 = Vessel({
    icon = 'chest_rd',
    fgroup = 'fv1',
    quest = 64059,
    assault = NIGHTFAE
}) -- object=368952
local FAE_VESSEL2 = Vessel({
    icon = 'chest_bl',
    fgroup = 'fv2',
    quest = 64060,
    assault = NIGHTFAE
}) -- object=368953

-- In the rift
map.nodes[47437620] = ns.Clone(RIFT_VESSEL1, {note = L['in_cave']})
map.nodes[47798651] = ns.Clone(RIFT_VESSEL1, {note = L['nexus_cave_roar']})
map.nodes[51008544] = ns.Clone(RIFT_VESSEL1, {note = L['nexus_cave_howl']})
map.nodes[32404309] = RIFT_VESSEL2
map.nodes[35704620] = RIFT_VESSEL2
map.nodes[36264215] = RIFT_VESSEL2
map.nodes[38474846] = ns.Clone(RIFT_VESSEL2, {note = L['in_cave']})
map.nodes[44554761] = RIFT_VESSEL2
map.nodes[27464950] = RIFT_VESSEL3
-- Necrolord Assault
map.nodes[30555837] = NEC_VESSEL1
map.nodes[32286588] = NEC_VESSEL1
map.nodes[34106170] = NEC_VESSEL1
map.nodes[36716805] = NEC_VESSEL1
map.nodes[25905520] = NEC_VESSEL2
map.nodes[33707480] = NEC_VESSEL2
map.nodes[34205988] = NEC_VESSEL2
-- Venthyr Assault
map.nodes[23431665] = VEN_VESSEL1
map.nodes[25201250] = VEN_VESSEL1
map.nodes[27401650] = VEN_VESSEL1
map.nodes[27801950] = VEN_VESSEL1
map.nodes[26201960] = VEN_VESSEL2
map.nodes[29601160] = VEN_VESSEL2
map.nodes[32701480] = VEN_VESSEL2
ext.nodes[73685062] = ns.Clone(VEN_VESSEL2, {parent = map.id})
-- Kyrian Assault
map.nodes[32594092] = KYR_VESSEL1
map.nodes[32604340] = KYR_VESSEL1
map.nodes[37504500] = KYR_VESSEL1
map.nodes[34103580] = KYR_VESSEL2
map.nodes[36604010] = KYR_VESSEL2
map.nodes[38364869] = KYR_VESSEL2
map.nodes[45424774] = KYR_VESSEL2
-- Night Fae assault
map.nodes[19103320] = FAE_VESSEL1
map.nodes[25303330] = FAE_VESSEL1
map.nodes[25303820] = FAE_VESSEL1
map.nodes[27804180] = FAE_VESSEL1
map.nodes[17304780] = FAE_VESSEL2
map.nodes[18604260] = FAE_VESSEL2
map.nodes[18905030] = FAE_VESSEL2
map.nodes[22704850] = FAE_VESSEL2

-------------------------------------------------------------------------------
-------------------------------- WHO SENT YOU ---------------------------------
-------------------------------------------------------------------------------

local Blackguard = Class('MawswornBlackguard', ns.node.Node, {
    group = ns.groups.MAWSWORN_BLACKGUARD,
    icon = 'peg_yw',
    id = 183173,
    label = L['mawsworn_blackguard'],
    scale = 1.5,
    rewards = {
        Achievement({
            id = 14742,
            criteria = ({id = 1, qty = true, suffix = L['mawsworn_blackguard']})
        })
    }
})

function Blackguard.getters:note()
    local note = L['mawsworn_blackguard_note'] .. '\n'
    note = note .. '\n/cleartarget'
    note = note .. '\n/tar ' .. L['mawsworn_blackguard']
    note = note .. '\n/cleartarget [dead]'
    note = note .. '\n/stopmacro [dead][noexists]'
    note = note .. '\n/script SetRaidTarget("target",8);'
    return note
end

local BLACKGUARD = Blackguard()

map.nodes[21803020] = BLACKGUARD
map.nodes[22202760] = BLACKGUARD
map.nodes[25002140] = BLACKGUARD
map.nodes[25202900] = BLACKGUARD
map.nodes[26802060] = BLACKGUARD
map.nodes[29804260] = BLACKGUARD
map.nodes[30203220] = BLACKGUARD
map.nodes[31203780] = BLACKGUARD
map.nodes[31402600] = BLACKGUARD
map.nodes[31802880] = BLACKGUARD
map.nodes[31803640] = BLACKGUARD
map.nodes[32003900] = BLACKGUARD
map.nodes[33203760] = BLACKGUARD
map.nodes[38002960] = BLACKGUARD
map.nodes[38803540] = BLACKGUARD
map.nodes[40003760] = BLACKGUARD
map.nodes[44086200] = BLACKGUARD
map.nodes[46205640] = BLACKGUARD
map.nodes[46405900] = BLACKGUARD
map.nodes[48606120] = BLACKGUARD
map.nodes[49206160] = BLACKGUARD
map.nodes[56005800] = BLACKGUARD
map.nodes[56606260] = BLACKGUARD
map.nodes[56805680] = BLACKGUARD
map.nodes[58605480] = BLACKGUARD
map.nodes[58606280] = BLACKGUARD

-------------------------------------------------------------------------------
------------------------------- ZOVAAL'S VAULT --------------------------------
-------------------------------------------------------------------------------

local Vault = Class('ZovaalVault', NPC, {
    id = 179883,
    quest = 64283,
    icon = 'star_chest_g',
    scale = 2,
    group = ns.groups.ZOVAAL_VAULT,
    note = L['zovault_note'],
    rift = 1,
    rewards = {
        Transmog({item = 187251, slot = L['cosmetic']}), -- Shaded Skull Shoulderguards
        Toy({item = 187113}), -- Personal Ball and Chain
        Toy({item = 187416}) -- Jailer's Cage
    }
})

map.nodes[33006630] = Vault({pois = {Arrow({33006630, 44545150})}})
map.nodes[47257968] = Vault({pois = {Arrow({47257968, 44545150})}})
map.nodes[62176427] = Vault({pois = {Arrow({62176427, 44545150})}})
map.nodes[66405820] = Vault({pois = {Arrow({66405820, 44545150})}})

-------------------------------------------------------------------------------
------------------------------ COVENANT ASSAULTS ------------------------------
-------------------------------------------------------------------------------

local NECROLORD_ASSAULT_REWARDS = {
    Achievement({id = 15000, criteria = 51720}), -- United Front
    Spacer(), Achievement({
        id = 15032,
        criteria = {
            52000, -- Dead On Their Feet
            52001, -- Here's an Axe, Get to Work!
            52002, -- You and What Army
            52003, -- An Embarrassment of Corpses
            52004, -- Putting a Plan Together
            52005, -- Centurions March!
            52006, -- Pulling His Chain
            52007, -- Splash Damage
            52008, -- Get to the Point
            52009 -- Somebody Feed Kevin
        }
    }), -- Breaking Their Hold
    Spacer(), Achievement({
        id = 15037,
        criteria = {
            52044, -- Cutter Fin
            52045, -- Kearnen the Blade
            52046, -- Winslow Swan
            52047, -- Boil Master Yetch
            52048 -- Flytrap
        }
    }), -- This Army
    Spacer(), Achievement({
        id = 15039,
        criteria = ({
            id = 1,
            qty = true,
            suffix = L['necrolord_assault_quantity_note']
        })
    }), -- Up For Grabs
    Spacer(), Section('{item:185992}'), Mount({item = 186103, id = 1477}), -- Undying Darkhound
    Pet({item = 186557, id = 3114}) -- Fodder
}

local VENTHYR_ASSAULT_REWARDS = {
    Achievement({id = 15000, criteria = 51721}), -- United Front
    Spacer(), Achievement({
        id = 15033,
        criteria = {
            52017, -- Terrorizing the Tremaculum
            52018, -- Weapons of the Tremaculum
            52019, -- That's a Good Trick
            52020, -- Fangcrack's Fan Club
            52021, -- A Tea for Every Occasion
            52022, -- Duelist's Challenge
            52023, -- If Even One is Worthy
            52024, -- They Grow Up So Quickly
            52025, -- The Skyhunt
            52026 -- Wrath of the Party Hearld
        }
    }), -- Taking the Tremaculum
    Spacer(), Achievement({
        id = 15042,
        criteria = {
            52065, -- Simone
            52066, -- Laurent
            52067, -- Archivist Fane
            52068, -- The Countess
            52069, -- Kael'thas Sunstrider
            52070, -- Lost Sybille
            52071, -- Vulca
            52072 -- Iven
        }
    }), -- Tea for the Troubled
    Spacer(), Achievement({
        id = 15043,
        criteria = ({
            id = 1,
            qty = true,
            suffix = L['venthyr_assault_quantity_note']
        })
    }), -- Hoarder of Torghast
    Spacer(), Section('{item:185990}'), Mount({item = 185996, id = 1378}) -- Harvester's Dreadwing
}

local NIGHT_FAE_ASSAULT_REWARDS = {
    Achievement({id = 15000, criteria = 51722}), -- United Front
    Spacer(), Achievement({
        id = 15001,
        criteria = ({
            id = 1,
            qty = true,
            suffix = L['night_fae_assault_quantity_note']
        })
    }), -- Jailer's Personal Stash
    Spacer(), Achievement({
        id = 15036,
        criteria = {
            52031, -- Clean Out the Crucible
            52032, -- Looming Darkness
            52033, -- No Soul Left Behind
            52034, -- Snail Stomping
            52035, -- Just Don't Ask Me to Spell It
            52036, -- Double Dromans
            52037, -- That's Going to Sting
            52038, -- The Soul Blade
            52039, -- A Shady Place
            52040 -- Heavy Handed Tactics
        }
    }), -- Rooting Out the Evil
    Spacer(), Achievement({
        id = 15044,
        criteria = {
            52078, -- Elder Gwenna
            52079, -- Foreman Thorodir
            52080, -- Te'zan
            52081, -- Warden Casad
            52082, -- Kivarr
            52083 -- Guardian Kota
        }
    }), -- Krrprripripkraak's Heroes
    Spacer(), Section('{item:185991}'), Mount({item = 186000, id = 1476}), -- Wild Hunt Legsplitter
    Pet({item = 186547, id = 3116}), -- Invasive Buzzer
    Item({item = 185052, quest = 63608, covenant = NIGHTFAE}) -- Hippo Soul
}

local KYRIAN_ASSAULT_REWARDS = {
    Achievement({id = 15000, criteria = 51723}), -- United Front
    Spacer(), Achievement({
        id = 15004,
        criteria = ({
            id = 1,
            qty = true,
            suffix = L['kyrian_assault_quantity_note1']
        })
    }), -- A Sly Fox
    Spacer(), Achievement({
        id = 15034,
        criteria = {
            52010, -- Mine's Bigger
            52011, -- Heart and Soul,
            52012, -- No One Floats Down Here
            52013, -- Encouraging Words
            52014, -- Courage of the Soul
            52015, -- Saved By The Bells
            52016, -- United In Pride
            52041, -- The Ember Count
            52042, -- Kill The Flame
            52043 -- The Dreadful Blend
        }
    }), -- Wings Against the Flames
    Spacer(), Achievement({
        id = 15041,
        criteria = ({
            id = 1,
            qty = true,
            suffix = L['kyrian_assault_quantity_note2']
        })
    }), -- The Zovaal Shuffle
    Spacer(), Section('{item:185993}'), Pet({item = 186546, id = 3103}), -- Copperback Etherwyrm
    Toy({item = 187185}) -- Vesper of Faith
}

-------------------------------------------------------------------------------

local ASSAULTS = {
    [NECROLORD.assault] = NECROLORD_ASSAULT_REWARDS,
    [VENTHYR.assault] = VENTHYR_ASSAULT_REWARDS,
    [NIGHTFAE.assault] = NIGHT_FAE_ASSAULT_REWARDS,
    [KYRIAN.assault] = KYRIAN_ASSAULT_REWARDS
}

local assaultHandled = false

hooksecurefunc(GameTooltip, 'Show', function(self)
    if assaultHandled then return end
    local owner = self:GetOwner()
    if owner and owner.questID then
        local rewards = ASSAULTS[owner.questID]
        if rewards and #rewards > 0 then
            for i, reward in ipairs(rewards) do
                if reward:IsEnabled() then reward:Render(self) end
            end
            assaultHandled = true
            self:AddLine(' ') -- add blank line after rewards
            self:Show()
        end
    end
end)

hooksecurefunc(GameTooltip, 'ClearLines',
    function(self) assaultHandled = false end)

-------------------------------------------------------------------------------

local Assault = Class('Assault', ns.node.Node, {
    scale = 1.5,
    group = ns.groups.COVENANT_ASSAULTS,
    IsEnabled = function(self)
        return not C_QuestLog.IsOnMap(self.assault_quest)
    end,
    getters = {
        sublabel = function(self)
            local sublabel
            local region = GetCVar('portal')
            if region == 'US' then
                sublabel = L['assault_sublabel_US']
            elseif region == 'EU' then
                sublabel = L['assault_sublabel_EU']
            elseif region == 'CN' then
                sublabel = L['assault_sublabel_CN']
            elseif region == 'KR' then
                sublabel = L['assault_sublabel_AS']
            else
                sublabel = ''
            end
            return sublabel
        end,
        rlabel = function(self)
            local completed = C_QuestLog.IsQuestFlaggedCompleted(
                self.assault_quest)
            local color = completed and ns.status.Green or ns.status.Gray
            return color(L['weekly'])
        end
    }
})

map.nodes[33865473] = Assault({
    label = L['necrolord_assault'],
    icon = 3257749,
    assault_quest = NECROLORD.assault,
    note = L['necrolord_assault_note'],
    rewards = NECROLORD_ASSAULT_REWARDS
}) -- Necrolord Assault

map.nodes[29461808] = Assault({
    label = L['venthyr_assault'],
    icon = 3257751,
    assault_quest = VENTHYR.assault,
    note = L['venthyr_assault_note'],
    rewards = VENTHYR_ASSAULT_REWARDS
}) -- Venthyr Assault

map.nodes[22004412] = Assault({
    label = L['night_fae_assault'],
    icon = 3257750,
    assault_quest = NIGHTFAE.assault,
    note = L['night_fae_assault_note'],
    rewards = NIGHT_FAE_ASSAULT_REWARDS
}) -- Night Fae Assault

map.nodes[41134541] = Assault({
    label = L['kyrian_assault'],
    icon = 3257748,
    assault_quest = KYRIAN.assault,
    note = L['kyrian_assault_note'],
    rewards = KYRIAN_ASSAULT_REWARDS
}) -- Kryian Assault

-------------------------------------------------------------------------------
-------------------------------- NILGANIHMAHT ---------------------------------
-------------------------------------------------------------------------------

local Nilganihmaht = Class('Nilganihmaht', Collectible, {
    -- quest=64202,
    id = 179572,
    icon = 1391724,
    fgroup = 'nilganihmaht_group',
    rift = 2,
    rewards = {
        Mount({item = 186713, id = 1503}) -- Hand of Nilganihmaht
    },
    pois = {
        POI({25603260}), -- Cave entrance
        Arrow({25503680, 30846063}), -- Stone Ring quest=64197
        Arrow({25503680, 19213225}), -- Gold Band quest=64199
        Arrow({25503680, 27672526}), -- Runed Band quest=64198
        Arrow({25503680, 20586935}), -- Signet Ring quest=64201
        Arrow({25503680, 66045739}) -- Silver Ring quest=64200
    }
})

function Nilganihmaht.getters:note()
    local function status(i, item)
        if ns.PlayerHasItem(item) then
            return ns.status.Green(i)
        else
            return ns.status.Red(i)
        end
    end

    local note = L['nexus_cave_forlorn'] .. ' ' .. L['nilganihmaht_note']
    note = note .. '\n\n' .. status(1, 186603) ..
               ' {item:186603} ({quest:63543})'
    note = note .. '\n' .. status(2, 186605) .. ' {item:186605} ({npc:179735})'
    note = note .. '\n' .. status(3, 186606) .. ' {item:186606} ({npc:170303})'
    note = note .. '\n' .. status(4, 186607) .. ' {item:186607} (' ..
               L['desmotaeron'] .. ')'
    note = note .. '\n' .. status(5, 186608) .. ' {item:186608} (' ..
               L['calcis'] .. ')'
    return note
end

map.nodes[25503680] = Nilganihmaht()

-------------------------------------------------------------------------------

local StoneRing = Class('StoneRing', Collectible, {
    item = 186603,
    icon = 1716841,
    assault = NECROLORD,
    fgroup = 'nilganihmaht_group',
    rewards = {Item({item = 186603, bag = true})},
    IsCompleted = NilgCompleted
}) -- Nilganihmaht's Stone Ring

function StoneRing.getters:note()
    local function status(i, item)
        if ns.PlayerHasItem(item) then
            return ns.status.Green(i)
        else
            return ns.status.Red(i)
        end
    end

    local note = L['nilg_stone_ring_note']
    note = note .. '\n\n' .. status(1, 186600) .. ' ' ..
               L['nilg_stone_ring_note1']
    note = note .. '\n\n' .. status(2, 186601) .. ' ' ..
               L['nilg_stone_ring_note2']
    note = note .. '\n\n' .. status(3, 186602) .. ' ' ..
               L['nilg_stone_ring_note3']
    note = note .. '\n\n' .. status(4, 186604) .. ' ' ..
               L['nilg_stone_ring_note4']
    return note
end

map.nodes[30846063] = StoneRing()

-------------------------------------------------------------------------------

map.nodes[19213225] = Collectible({
    icon = 1027823,
    item = 186608,
    note = L['nilg_gold_band_note'],
    fgroup = 'nilganihmaht_group',
    rewards = {
        Item({item = 186608, bag = true}) -- Nilganihmaht's Gold Band
    },
    pois = {
        POI({18873798}), -- Starting point
        Path({
            18873798, 17883838, 16763960, 17273816, 16283815, 15373793,
            16063678, 16813555, 17643428, 18473317, 19213225
        })
    },
    IsCompleted = NilgCompleted
}) -- Nilganihmaht's Gold Band

-------------------------------------------------------------------------------

local SilverRing = Class('SilverRing', Collectible, {
    -- quest=64207,
    icon = 1043909,
    item = 186607,
    requires = ns.requirement.Item(186727, 4), -- Seal Breaker Key
    fgroup = 'nilganihmaht_group',
    rewards = {
        Item({item = 186607, bag = true}) -- Nilganimahts Silver Ring
    },
    pois = {
        POI({65646003, quest = 62680}) -- The Harrower's Key Ring
    },
    IsCompleted = NilgCompleted
}) -- Nilganimahts Silver Ring

function SilverRing.getters:note()
    local function status(i, quest)
        if C_QuestLog.IsQuestFlaggedCompleted(quest) then
            return ns.status.Green(i)
        else
            return ns.status.Red(i)
        end
    end

    local note = L['nilg_silver_ring_note']
    note = note .. '\n\n' .. status(1, 62683) .. ' ' ..
               L['nilg_silver_ring_note1']
    note = note .. '\n\n' .. status(2, 62680) .. ' ' ..
               L['nilg_silver_ring_note2']
    note = note .. '\n\n' .. status(3, 62682) .. ' ' ..
               L['nilg_silver_ring_note3']
    note = note .. '\n\n' .. status(4, 62679) .. ' ' ..
               L['nilg_silver_ring_note4']
    return note
end

map.nodes[66045739] = SilverRing()

-------------------------------------------------------------------------------
---------------------------------- TORMENTORS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[85375524] = Class('Tormentor', ns.node.Node, {
    label = L['tormentors'],
    note = L['tormentors_note'],
    icon = 'tormentor',
    scale = 2.5,
    rewards = {
        Achievement({
            id = 15054,
            criteria = {
                52104, -- Kazj the Sentinel
                51644, -- Promathiz
                52103, -- Sentinel Shakorzeth
                51661, -- Intercessor Razzra
                51653, -- Gruukuuek the Elder
                52102, -- Algel the Haunter
                51648, -- Malleus Grakizz
                51654, -- Gralebboih
                51639, -- The Mass of Souls
                52105, -- Manifestation of Pain
                51655, -- Versya the Damned
                52101, -- Zul'gath the Flayer
                52106, -- Golmak the Monstrosity
                51643, -- Sentinel Pyrophus
                51660 -- Mugrem the Soul Devourer
            }
        }), Transmog({item = 186003, slot = L['bow'], note = '{npc:177981}'}), -- Versya's Stygian Longbow
        Transmog({item = 186009, slot = L['staff'], note = '{npc:177980}'}), -- Corrupted Elder Branch
        Transmog({item = 186006, slot = L['2h_axe'], note = '{npc:178882}'}), -- Kazj's Stygian Splitter
        Transmog({item = 186010, slot = L['1h_mace'], note = '{npc:178002}'}), -- Lost Attendant's Scepter
        Transmog({item = 186007, slot = L['1h_mace'], note = '{npc:177330}'}), -- Cudgel of the Tin Sentinel
        Transmog({item = 186004, slot = L['dagger'], note = '{npc:178004}'}), -- Kris of Dark Temptation
        Transmog({item = 186005, slot = L['dagger'], note = '{npc:178899}'}), -- Stygian Pain Borer
        Transmog({item = 186012, slot = L['shield'], note = '{npc:177972}'}), -- Inferno Blast Shield
        Transmog({item = 186239, slot = L['cloak'], note = '{npc:178897}'}), -- Drape of the Phantasm
        Transmog({item = 186213, slot = L['cloth'], note = '{npc:178899}'}), -- Bindings of Manifest Pain
        Transmog({item = 186210, slot = L['cloth'], note = '{npc:177427}'}), -- Diabolic Soul Veil
        Transmog({item = 186241, slot = L['cloth'], note = '{npc:177331}'}), -- Insulated Thermal Leggings
        Transmog({item = 186208, slot = L['cloth'], note = '{npc:177330}'}), -- Padded Insouls
        Transmog({item = 186218, slot = L['leather'], note = '{npc:177972}'}), -- Fire-Tempered Armor Cinch
        Transmog({item = 186237, slot = L['leather'], note = '{npc:177979}'}), -- Gormhide Pauldrons
        Transmog({item = 186219, slot = L['leather'], note = '{npc:177331}'}), -- Pyrophus' Wrist Ties
        Transmog({item = 186215, slot = L['leather'], note = '{npc:177427}'}), -- Soul Stranglers
        Transmog({item = 186225, slot = L['mail'], note = '{npc:178883}'}), -- Shoulder Joint Spindles
        Transmog({item = 186226, slot = L['mail'], note = '{npc:177980}'}), -- Cinch of Petrified Vines
        Transmog({item = 186227, slot = L['mail'], note = '{npc:178897}'}), -- Jangling Chain Manacles
        Transmog({item = 186242, slot = L['mail'], note = '{npc:178886}'}), -- Zul'gath's Chain Coif
        Transmog({item = 186221, slot = L['mail'], note = '{npc:178898}'}), -- Seared-Link Sabatons
        Transmog({item = 186231, slot = L['plate'], note = '{npc:178004}'}), -- Gloves of Fervent Intercession
        Transmog({item = 186229, slot = L['plate'], note = '{npc:178898}'}), -- Lavafused Breastplate
        Transmog({item = 186235, slot = L['plate'], note = '{npc:178886}'}), -- Shadow-Wreathed Vambraces
        Transmog({item = 186233, slot = L['plate'], note = '{npc:177981}'}), -- Spaulders of the Skyborn Damned
        Pet({item = 186449, id = 3117, note = '{npc:177979}'}), -- Amaranthine Stinger
        Spacer(), ns.reward.Section('{item:185972}'), -- Tormentor's Cache
        Transmog({item = 186977, slot = L['cosmetic'], indent = true}), -- Beastcaller's Skull Crescent
        Transmog({item = 186978, slot = L['cosmetic'], indent = true}), -- Borrowed Eye Crescent
        Transmog({item = 186562, slot = L['cosmetic'], indent = true}), -- Tormentor's Manacled Backplate
        Mount({item = 185973, id = 1475, indent = true}) -- Chain of Bahmethra
    },
    getters = {
        rlabel = function(self)
            local completed = C_QuestLog.IsQuestFlaggedCompleted(63854)
            local color = completed and ns.status.Green or ns.status.Gray
            return color(L['weekly'])
        end
    }
})()

-------------------------------------------------------------------------------
-------------------------------- MISCELLANEOUS --------------------------------
-------------------------------------------------------------------------------

map.nodes[23184238] = Collectible({
    id = 179038,
    quest = 64000,
    icon = 3046536,
    requires = ns.requirement.Item(186190),
    note = L['etherwyrm_note'],
    assault = NIGHTFAE,
    rift = 2,
    rewards = {
        Pet({item = 186191, id = 3099}) -- Infused Etherwyrm
    },
    pois = {
        POI({19214376, 19903240, 23604040}) -- Elusive Keybinder
    }
}) -- Infused Etherwyrm

map.nodes[36506740] = Collectible({
    id = 179008,
    icon = 3622121,
    quest = {64008, 64009, 64010, 64011, 64013},
    note = L['lilabom_note'],
    rewards = {
        Pet({item = 186188, id = 3098}) -- Lil'Abom
    },
    pois = {
        POI({27505670, 30306330, 32215608, quest = 64010}), -- Head
        POI({39906260, quest = 64011}), -- Torso
        POI({29376732, quest = 64013}), -- Legs
        POI({38505850, quest = 64008}), -- Right Hand
        Path({
            38505850,
            37855857,
            37465904,
            37295959,
            37336038,
            37456122,
            quest = 64008
        }), -- Right Hand
        Arrow({37456122, 37806250, quest = 64008}), -- Right Hand
        POI({33306580, 39286648, quest = 64009}) -- Spare Arm
    }
}) -- Lil'Abom

map.nodes[42164448] = Collectible({
    id = 179083,
    quest = 64019,
    icon = 3072461,
    note = L['sly_note'],
    assault = KYRIAN,
    rewards = {
        Achievement({id = 15004, oneline = true}),
        Pet({item = 186539, id = 3101}) -- Sly
    },
    pois = {
        POI({40715157, quest = 64024}), -- assault 1
        POI({38023973, quest = 64022, questDeps = 64024}), -- assault 2
        POI({32904417, quest = 64023, questDeps = 64022}) -- assault 3
    }
}) -- Sly

map.nodes[46914169] = NPC({
    id = 162804,
    icon = 3527519,
    note = L['venari_note'],
    rewards = {
        Achievement({id = 14895, oneline = true}), -- 'Ghast Five
        Section(C_Map.GetMapInfo(1543).name), Spacer(),
        Item({item = 184613, quest = 63177, note = L['Apprehensive']}), -- Encased Riftwalker Essence
        Item({item = 184653, quest = 63217, note = L['Tentative']}), -- Animated Levitating Chain
        Item({item = 180949, quest = 61600, note = L['Tentative']}), -- Animaflow Stabilizer
        Item({item = 184605, quest = 63092, note = L['Tentative']}), -- Sigil of the Unseen
        Item({item = 184588, quest = 63091, note = L['Ambivalent']}), -- Soul-Stabilizing Talisman
        Item({item = 184870, note = L['Appreciative']}), -- Stygia Dowser
        Spacer(), Section(L['torghast']), Spacer(),
        Item({item = 184620, quest = 63202, note = L['Apprehensive']}), -- Vessel of Unforunate Spirits
        Item({item = 184615, quest = 63183, note = L['Apprehensive']}), -- Extradimensional Pockets
        Item({item = 184901, quest = 63523, note = L['Apprehensive']}), -- Broker Traversal Enhancer
        Item({item = 184617, quest = 63193, note = L['Tentative']}), -- Bangle of Seniority
        Item({item = 184621, quest = 63204, note = L['Ambivalent']}), -- Ritual Prism of Fortune
        Item({item = 184618, quest = 63200, note = L['Cordial']}), -- Rank Insignia: Acquisitionist
        Item({item = 184619, quest = 63201, note = L['Cordial']}), -- Loupe of Unusual Charm
        Item({item = 180952, quest = 61144, note = L['Appreciative']}) -- Possibility Matrix
    }
}) -- Ve'nari
