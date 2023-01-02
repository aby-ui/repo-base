-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local L = ns.locale

local Class = ns.Class
local Group = ns.Group

local Collectible = ns.node.Collectible
local Node = ns.node.Node
local Rare = ns.node.Rare

local Achievement = ns.reward.Achievement
local Currency = ns.reward.Currency
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Spacer = ns.reward.Spacer
local Transmog = ns.reward.Transmog

-------------------------------------------------------------------------------

ns.expansion = 10

-------------------------------------------------------------------------------
----------------------------------- GROUPS ------------------------------------
-------------------------------------------------------------------------------

ns.groups.DISTURBED_DIRT = Group('disturbed_dirt', 1060570, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.EXPANSION
})

ns.groups.DRAGON_GLYPH = Group('dragon_glyph', 4728198, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.EXPANSION
})

ns.groups.DRAGONRACE = Group('dragonrace', 1100022, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.EXPANSION
})

ns.groups.ELEMENTAL_STORM = Group('elemental_storm', 538566, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.EXPANSION
})

ns.groups.MAGICBOUND_CHEST = Group('magicbound_chest', 'chest_tl', {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.EXPANSION
})

ns.groups.PROFESSION_TREASURES = Group('profession_treasures', 4620676, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.EXPANSION
})

ns.groups.SCOUT_PACK = Group('scout_pack', 4562583, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.EXPANSION
})

ns.groups.SIGNAL_TRANSMITTER = Group('signal_transmitter', 4548860, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.EXPANSION,

    -- Only display group for engineering players
    IsEnabled = function(self)
        if not ns.PlayerHasProfession(202) then return false end
        return Group.IsEnabled(self)
    end
})

-------------------------------------------------------------------------------

ns.groups.ANCESTOR = Group('ancestor', 135946, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.BAKAR = Group('bakar', 930453, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.CHISELED_RECORD = Group('chiseled_record', 134455, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.DREAMGUARD = Group('dreamguard', 341763, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.DUCKLINGS = Group('ducklings', 4048818, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.FLAG = Group('flag', 1723999, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.FRAGMENT = Group('fragment', 134908, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.GRAND_THEFT_MAMMOTH = Group('grand_theft_mammoth', 4034836, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.HEMET_NESINGWARY_JR = Group('hemet_nesingwary_jr', 236444, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.KITE = Group('kite', 133837, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.LEGENDARY_ALBUM = Group('legendary_album', 1109168, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.LEYLINE = Group('leyline', 1033908, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.NEW_PERSPECTIVE = Group('new_perspective', 1109100, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.PRETTY_NEAT = Group('pretty_neat', 133707, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.SAFARI = Group('safari', 4048818, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.SPECIALTIES = Group('specialties', 651585, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.SQUIRRELS = Group('squirrels', 237182, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

ns.groups.STORIES = Group('stories', 4549126, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT
})

-------------------------------------------------------------------------------
--------------------------------- ELITE RARES ---------------------------------
-------------------------------------------------------------------------------

local RareElite = Class('RareElite', Rare, {
    rlabel = '(' .. ns.color.Gray(L['elite']) .. ')',
    sublabel = L['elite_loot_higher_ilvl']
})

ns.node.RareElite = RareElite

-------------------------------------------------------------------------------
----------------------------- PROFESSION TREASURES ----------------------------
-------------------------------------------------------------------------------

-- LuaFormatter off
local PROFESSIONS = {
    -- name, icon, skillID, variantID
    {'Alchemy', 4620669, 171, 2823},
    {'Blacksmithing', 4620670, 164, 2822},
    {'Enchanting', 4620672, 333, 2825},
    {'Engineering', 4620673, 202, 2827},
    {'Herbalism', 4620675, 182, 2832},
    {'Inscription', 4620676, 773, 2828},
    {'Jewelcrafting', 4620677, 755, 2829},
    {'Leatherworking', 4620678, 165, 2830},
    {'Mining', 4620679, 186, 2833},
    {'Skinning', 4620680, 393, 2834},
    {'Tailoring', 4620681, 197, 2831}
}
-- LuaFormatter on

local ProfessionMaster = Class('ProfessionMaster', ns.node.NPC, {
    scale = 0.9,
    group = ns.groups.PROFESSION_TREASURES
})

function ProfessionMaster:IsEnabled()
    if not ns.PlayerHasProfession(self.skillID) then return false end
    return ns.node.NPC.IsEnabled(self)
end

local ProfessionTreasure = Class('ProfessionTreasure', ns.node.Item, {
    scale = 0.9,
    group = ns.groups.PROFESSION_TREASURES
})

function ProfessionTreasure:IsEnabled()
    if not ns.PlayerHasProfession(self.skillID) then return false end
    return ns.node.Item.IsEnabled(self)
end

ns.node.ProfessionMasters = {}
ns.node.ProfessionTreasures = {}

local PM = ns.node.ProfessionMasters
local PT = ns.node.ProfessionTreasures

for i, ids in ipairs(PROFESSIONS) do
    local name, icon, skillID, variantID = unpack(ids)

    PM[name] = Class(name .. 'Master', ProfessionMaster, {
        icon = icon,
        skillID = skillID,
        requires = ns.requirement.Profession(skillID, variantID, 25)
    })

    PT[name] = Class(name .. 'Treasure', ProfessionTreasure, {
        icon = icon,
        skillID = skillID,
        requires = ns.requirement.Profession(skillID, variantID, 25)
    })
end

-------------------------------------------------------------------------------
-------------------------------- DRAGON GLYPHS --------------------------------
-------------------------------------------------------------------------------

local Dragonglyph = Class('Dragonglyph', Collectible, {
    icon = 4728198,
    label = L['dragon_glyph'],
    group = ns.groups.DRAGON_GLYPH,
    requires = ns.requirement.Quest(68795) -- Dragonriding
})

ns.node.Dragonglyph = Dragonglyph

-------------------------------------------------------------------------------
---------------------------- DRAGON CUSTOMIZATIONS ----------------------------
-------------------------------------------------------------------------------

-- This is a collection of all the open-world dragon customizations that are
-- obtainable. Many of these are available from multiple sources, so this
-- gives us a single easy spot to keep their data and reference it elsewhere.

-- TODO: Add other 3 drakes

ns.DRAGON_CUSTOMIZATIONS = {
    RenewedProtoDrake = {
        Armor = Item({item = 197357, quest = 69558}),
        BeakedSnout = Item({item = 197401, quest = 69602}),
        BlackAndRedArmor = Item({item = 197348, quest = 69549}),
        BlackScales = Item({item = 197392, quest = 69593}),
        BlueHair = Item({item = 197368, quest = 69569}),
        BlueScales = Item({item = 197390, quest = 69591}),
        BovineHorns = Item({item = 197377, quest = 69578}),
        BronzeAndPinkArmor = Item({item = 197353, quest = 69554}),
        BronzeScales = Item({item = 197391, quest = 69592}),
        BrownHair = Item({item = 197369, quest = 69570}),
        ClubTail = Item({item = 197403, quest = 69604}),
        CurledHorns = Item({item = 197375, quest = 69576}),
        CurvedHorns = Item({item = 197380, quest = 69581}),
        CurvedSpikedBrow = Item({item = 197358, quest = 69559}),
        DualHornedCrest = Item({item = 197366, quest = 69567}),
        Ears = Item({item = 197376, quest = 69577}),
        FinnedCrest = Item({item = 197365, quest = 69566}),
        FinnedJaw = Item({item = 197388, quest = 69589}),
        FinnedTail = Item({item = 197404, quest = 69605}),
        FinnedThroat = Item({item = 197408, quest = 69609}),
        GoldAndBlackArmor = Item({item = 197346, quest = 69547}),
        GoldAndRedArmor = Item({item = 197351, quest = 69552}),
        GoldAndWhiteArmor = Item({item = 197349, quest = 69550}),
        GradientHorns = Item({item = 197381, quest = 69582}),
        GrayHair = Item({item = 197367, quest = 69568}),
        GreenHair = Item({item = 197371, quest = 69572}),
        GreenScales = Item({item = 192523, quest = nil}), -- current not in game
        HairyBack = Item({item = 197356, quest = 69557}),
        HairyBrow = Item({item = 197359, quest = 69560}),
        HarrierPattern = Item({item = 197395, quest = 69596}),
        HeavyHorns = Item({item = 197383, quest = 69584}),
        HeavyScales = Item({item = 197397, quest = 69598}),
        Helm = Item({item = 197373, quest = 69574}),
        HornedBack = Item({item = 197354, quest = 69555}),
        HornedJaw = Item({item = 197385, quest = 69586}),
        ImpalerHorns = Item({item = 197379, quest = 69580}),
        ManedCrest = Item({item = 197363, quest = 69564}),
        ManedTail = Item({item = 197405, quest = 69606}),
        PredatorPattern = Item({item = 197394, quest = 69595}),
        PurpleHair = Item({item = 197372, quest = 69573}),
        RazorSnout = Item({item = 197399, quest = 69600}),
        RedHair = Item({item = 197370, quest = 69571}),
        RedScales = Item({item = 192111, quest = nil}), -- current not in game
        SharkSnout = Item({item = 197400, quest = 69601}),
        ShortSpikedCrest = Item({item = 197364, quest = 69565}),
        SilverAndBlueArmor = Item({item = 197347, quest = 69548}),
        SilverAndPurpleArmor = Item({item = 197350, quest = 69551}),
        SkyterrorPattern = Item({item = 197396, quest = 69597}),
        SnubSnout = Item({item = 197398, quest = 69599}),
        SpikedClubTail = Item({item = 197402, quest = 69603}),
        SpikedCrest = Item({item = 197361, quest = 69562}),
        SpikedJaw = Item({item = 197386, quest = 69587}),
        SpikedThroat = Item({item = 197407, quest = 69608}),
        SpinedBrow = Item({item = 197360, quest = 69561}),
        SpinedCrest = Item({item = 197362, quest = 69563}),
        SpinedTail = Item({item = 197406, quest = 69607}),
        SteelAndYellowArmor = Item({item = 197352, quest = 69553}),
        SubtleHorns = Item({item = 197378, quest = 69579}),
        SweptHorns = Item({item = 197374, quest = 69575}),
        ThickSpinedJaw = Item({item = 197355, quest = 69556}),
        ThinSpinedJaw = Item({item = 197387, quest = 69588}),
        WhiteHorns = Item({item = 197382, quest = 69583}),
        WhiteScales = Item({item = 197393, quest = 69594})
    },
    WindborneVelocidrake = {
        ClubTail = Item({item = 197624, quest = 69828}),
        FinnedEars = Item({item = 197595, quest = 69799}),
        GrayHorns = Item({item = 197608, quest = 69812}),
        LargeHeadFin = Item({item = 197589, quest = 69793}),
        SweptHorns = Item({item = 197606, quest = 69810}),
        SpikedBack = Item({item = 197586, quest = 69790}),
        ClusterHorns = Item({item = 197602, quest = 69806})
    },
    HighlandDrake = {
        ClubTail = Item({item = 197149, quest = 69350}),
        CrestedBrow = Item({item = 197100, quest = 69301}),
        FinnedBack = Item({item = 197098, quest = 69299}),
        ManedHead = Item({item = 197111, quest = 69312}),
        SpikedClubTail = Item({item = 197150, quest = 69351}),
        StripedPattern = Item({item = 197138, quest = 69339}),
        TanHorns = Item({item = 197121, quest = 69322}),
        ToothyMouth = Item({item = 197135, quest = 69336})
    },
    CliffsideWylderdrake = {
        BlackHorns = Item({item = 196991, quest = 69191}),
        BluntSpikedTail = Item({item = 197019, quest = 69219}),
        BranchedHorns = Item({item = 196996, quest = 69196}),
        Ears = Item({item = 196982, quest = 69182}),
        DualHornedChin = Item({item = 196973, quest = 69173}),
        FinnedCheek = Item({item = 197001, quest = 69201}),
        FinnedNeck = Item({item = 197022, quest = 69222}),
        HeadMane = Item({item = 196976, quest = 69176}),
        HeavyHorns = Item({item = 196992, quest = 69192}),
        HornedJaw = Item({item = 196985, quest = 69185}),
        HornedNose = Item({item = 197005, quest = 69205}),
        ManedNeck = Item({item = 197023, quest = 69223})
    }
}

-------------------------------------------------------------------------------
------------------ DRAGONSCALE EXPEDITION: THE HIGHEST PEAKS ------------------
-------------------------------------------------------------------------------

local Flag = Class('Flag', Collectible, {
    icon = 1723999,
    label = L['dragonscale_expedition_flag'], -- Dragonscale Expedition Flag
    rlabel = ns.status.LightBlue('+250 ' .. select(1, GetFactionInfoByID(2507))), -- Dragonscale Expedition
    group = ns.groups.FLAG,
    requires = {
        ns.requirement.Reputation(2507, 6, true), -- Dragonscale Expedition
        ns.requirement.GarrisonTalent(2164) -- Cartographer Flag
    },
    rewards = {
        Achievement({
            id = 15890,
            criteria = {id = 1, qty = true, suffix = L['flags_placed']}
        })
    },
    IsCompleted = function(self)
        return C_QuestLog.IsQuestFlaggedCompleted(self.quest[1])
    end
})

ns.node.Flag = Flag

-------------------------------------------------------------------------------
------------------ WYRMHOLE GENERATOR - SIGNAL TRANSMITTER --------------------
-------------------------------------------------------------------------------

local SignalTransmitter = Class('SignalTransmitter', Collectible, {
    label = L['signal_transmitter_label'],
    icon = 4548860,
    note = L['signal_transmitter_note'],
    group = ns.groups.SIGNAL_TRANSMITTER,
    requires = {
        ns.requirement.Profession(202, 2827), -- DF Engineering
        ns.requirement.Toy(198156) -- Wyrmhole Generator
    },
    IsEnabled = function(self)
        if not ns.PlayerHasProfession(202) then return false end
        return ns.node.Item.IsEnabled(self)
    end,
    IsCompleted = function(self)
        return C_QuestLog.IsQuestFlaggedCompleted(self.quest[1])
    end
}) -- Wyrmhole Generator Signal Transmitter

ns.node.SignalTransmitter = SignalTransmitter

-------------------------------------------------------------------------------
---------------------------- FRAGMENTS OF HISTORY -----------------------------
-------------------------------------------------------------------------------

local Fragment = Class('Fragment', Collectible, {
    icon = 134908,
    group = ns.groups.FRAGMENT,
    IsCollected = function(self)
        if ns.PlayerHasItem(self.rewards[2].item) then return true end
        return Collectible.IsCollected(self)
    end
})

function Fragment.getters:note()
    -- Ask Emilia Bellocq first
    return not C_QuestLog.IsQuestFlaggedCompleted(70231) and
               L['fragment_requirement_note']
end

ns.node.Fragment = Fragment

-------------------------------------------------------------------------------
------------------------------- DISTURBED DIRT --------------------------------
-------------------------------------------------------------------------------

local Disturbeddirt = Class('Disturbed_dirt', Node, {
    icon = 1060570,
    label = L['disturbed_dirt'],
    group = ns.groups.DISTURBED_DIRT,
    requires = {
        ns.requirement.Quest(70813), -- Digging Up Treasure
        ns.requirement.Item(191294) -- Small Expedition Shovel
    },
    rewards = {
        Item({item = 190453}), -- Spark of Ingenuity
        Item({item = 190454}), -- Primal Chaos
        Transmog({item = 201386, slot = L['cosmetic']}), -- Drakonid Defender's Pike
        Transmog({item = 201388, slot = L['cosmetic']}), -- Dragonspawn Wingtipped Staff
        Transmog({item = 201390, slot = L['cosmetic']}), -- Devastating Drakonid Waraxe
        Item({item = 194540, quest = 67046}), -- Nokhud Armorer's Notes
        Item({item = 199061, quest = 70527}), -- A Guide to Rare Fish
        Item({item = 199066, quest = 70535}), -- Letter of Caution
        Item({item = 199068, quest = 70537}), -- Time-Lost Memo
        Item({item = 199062, quest = 70528}), -- Ruby Gem Cluster Map
        Item({item = 199067, quest = 70536}), -- Precious Plans
        Item({item = 198852, quest = 70407}), -- Bear Termination Orders
        Item({item = 198843, quest = 70392}), -- Emerald Gardens Explorer's Notes
        Item({item = 199065, quest = 70534}), -- Sorrowful Letter
        Item({item = 192055}), -- Dragon Isles Artifact
        Currency({id = 2003}) -- Dragon Isles Supplies
    }
})

ns.node.Disturbeddirt = Disturbeddirt

-------------------------------------------------------------------------------
-------------------------- EXPEDITION SCOUT'S PACKS ---------------------------
-------------------------------------------------------------------------------

local Scoutpack = Class('Scoutpack', Node, {
    icon = 4562583,
    label = L['scout_pack'],
    group = ns.groups.SCOUT_PACK,
    requires = ns.requirement.Quest(70822), -- Lost Expedition Scouts
    rewards = {
        Item({item = 191784}), -- Dragon Shard of Knowledge
        Item({item = 190454}), -- Primal Chaos
        Mount({item = 192764, id = 1617}), -- Verdant Skitterfly
        Transmog({item = 201387, slot = L['cosmetic']}), -- Dragon Knight's Halberd
        Transmog({item = 201388, slot = L['cosmetic']}), -- Dragonspawn Wingtipped Staff
        Transmog({item = 201390, slot = L['cosmetic']}), -- Devastating Drakonid Waraxe
        Transmog({item = 201392, slot = L['cosmetic']}), -- Dragon Noble's Cutlass
        Transmog({item = 201395, slot = L['cosmetic']}), -- Dragon Wingcrest Scimitar
        Transmog({item = 201396, slot = L['cosmetic']}), -- Dracthyr Claw Extensions
        Item({item = 194540, quest = 67046}), -- Nokhud Armorer's Notes
        Item({item = 199061, quest = 70527}), -- A Guide to Rare Fish
        Item({item = 199066, quest = 70535}), -- Letter of Caution
        Item({item = 199068, quest = 70537}), -- Time-Lost Memo
        Item({item = 199062, quest = 70528}), -- Ruby Gem Cluster Map
        Item({item = 199067, quest = 70536}), -- Precious Plans
        Item({item = 198852, quest = 70407}), -- Bear Termination Orders
        Item({item = 198843, quest = 70392}), -- Emerald Gardens Explorer's Notes
        Item({item = 192055}), -- Dragon Isles Artifact
        Currency({id = 2003}) -- Dragon Isles Supplies
    }
})

ns.node.Scoutpack = Scoutpack

-------------------------------------------------------------------------------
------------------------------ Magic-Bound Chest ------------------------------
-------------------------------------------------------------------------------

local MagicBoundChest = Class('MagicBoundChest', Node, {
    icon = 'chest_tl',
    label = L['magicbound_chest'],
    group = ns.groups.MAGICBOUND_CHEST,
    requires = ns.requirement.Reputation(2507, 16, true), -- Dragonscale Expedition
    rewards = {
        Item({item = 191784}), -- Dragon Shard of Knowledge
        Item({item = 190454}), -- Primal Chaos
        Item({item = 199062, quest = 70528}), -- Ruby Gem Cluster Map
        Item({item = 192055}), -- Dragon Isles Artifact
        Currency({id = 2003}) -- Dragon Isles Supplies
    }
})

ns.node.MagicBoundChest = MagicBoundChest

-------------------------------------------------------------------------------
--------------------------------- DRAGONRACES ---------------------------------
-------------------------------------------------------------------------------

local Dragonrace = Class('DragonRace', Collectible,
    {icon = 1100022, group = ns.groups.DRAGONRACE})

function Dragonrace.getters:sublabel()
    if self.normal then
        local ntime = C_CurrencyInfo.GetCurrencyInfo(self.normal[1]).quantity
        if self.advanced then
            local atime = C_CurrencyInfo.GetCurrencyInfo(self.advanced[1])
                              .quantity
            return L['dr_best']:format(ntime / 1000, atime / 1000)
        end
        return L['dr_best_dash']:format(ntime / 1000)
    end
end

function Dragonrace.getters:note()
    if self.normal then
        local silver = ns.color.Silver
        local gold = ns.color.Gold

        -- LuaFormatter off
        if self.advanced then
            return L['dr_note']:format(
                silver(self.normal[2]),
                gold(self.normal[3]),
                silver(self.advanced[2]),
                gold(self.advanced[3])
            ) .. L['dr_bronze']
        end

        return L['dr_note_dash']:format(
            silver(self.normal[2]),
            gold(self.normal[3])
        ) .. L['dr_bronze']
        -- LuaFormatter on
    end
end

ns.node.Dragonrace = Dragonrace

-------------------------------------------------------------------------------
--------------------- TO ALL THE SQUIRRELS HIDDEN TIL NOW ---------------------
-------------------------------------------------------------------------------

local Squirrel = Class('Squirrel', Collectible, {
    group = ns.groups.SQUIRRELS,
    icon = 237182,
    note = L['squirrels_note']
})

ns.node.Squirrel = Squirrel

-------------------------------------------------------------------------------
----------------------------- THAT'S PRETTY NEAT! -----------------------------
-------------------------------------------------------------------------------

local PrettyNeat = Class('PrettyNeat', Collectible, {
    icon = 133707,
    sublabel = L['pretty_neat_note'],
    group = ns.groups.PRETTY_NEAT
}) -- That's Pretty Neat!

ns.node.PrettyNeat = PrettyNeat

-------------------------------------------------------------------------------
------------------------------ A LEGENDARY ALBUM ------------------------------
-------------------------------------------------------------------------------

local LegendaryCharacter = Class('LegendaryCharacter', Collectible, {
    icon = 1109168,
    group = ns.groups.LEGENDARY_ALBUM,
    requires = {
        ns.requirement.Reputation(2507, 8, true), -- Dragonscale Expedition
        ns.requirement.GarrisonTalent(2169) -- Lucky Rock
    }
}) -- A Legendary Album

ns.node.LegendaryCharacter = LegendaryCharacter

-------------------------------------------------------------------------------
----------------------------- DRAGON ISLES SAFARI -----------------------------
-------------------------------------------------------------------------------

local Safari = Class('Safari', Collectible,
    {icon = 'paw_g', group = ns.groups.SAFARI}) -- Dragon Isles Safari

ns.node.Safari = Safari

-------------------------------------------------------------------------------
------------------------------ ELEMENTAL STORMS -------------------------------
-------------------------------------------------------------------------------

local ELEMENTAL_STORM_AREA_POIS = {
    [7221] = 'thunderstorm',
    [7222] = 'sandstorm',
    [7223] = 'firestorm',
    [7224] = 'snowstorm',
    [7225] = 'thunderstorm',
    [7226] = 'sandstorm',
    [7227] = 'firestorm',
    [7228] = 'snowstorm',
    [7229] = 'thunderstorm',
    [7230] = 'sandstorm',
    [7231] = 'firestorm',
    [7232] = 'snowstorm',
    [7233] = 'thunderstorm',
    [7234] = 'sandstorm',
    [7235] = 'firestorm',
    [7236] = 'snowstorm',
    [7237] = 'thunderstorm',
    [7238] = 'sandstorm',
    [7239] = 'firestorm',
    [7240] = 'snowstorm',
    [7241] = 'thunderstorm',
    [7242] = 'sandstorm',
    [7243] = 'firestorm',
    [7244] = 'snowstorm',
    [7245] = 'thunderstorm',
    [7246] = 'sandstorm',
    [7247] = 'firestorm',
    [7248] = 'snowstorm',
    [7249] = 'thunderstorm',
    [7250] = 'sandstorm',
    [7251] = 'firestorm',
    [7252] = 'snowstorm',
    [7253] = 'thunderstorm',
    [7254] = 'sandstorm',
    [7255] = 'firestorm',
    [7256] = 'snowstorm',
    [7257] = 'thunderstorm',
    [7258] = 'sandstorm',
    [7259] = 'firestorm',
    [7260] = 'snowstorm',
    [7298] = 'thunderstorm',
    [7299] = 'sandstorm',
    [7300] = 'firestorm',
    [7301] = 'snowstorm'
}

-- vv ------------------------------------------------------------------------- TO-DO: SHOULD I SIMPLIFY THIS TABLE TO ONLY USE ACHIEVEMENT ID
-- vv ------------------------------------------------------------------------- AND THEN HANDLE BUILDING ACHIEVEMENT() IN THE ACTUAL CODE?

local ELEMENTAL_STORM_MOB_ACHIVEMENTS = {
    ['all'] = Achievement({
        id = 16500,
        criteria = {
            id = 1,
            qty = true,
            suffix = L['elemental_overflow_obtained_suffix']
        }
    }), -- Elemental Overload
    [2022] = {
        ['thunderstorm'] = Achievement({
            id = 16463,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Thunderstorms in the Waking Shores
        ['sandstorm'] = Achievement({
            id = 16465,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Sandstorms in the Waking Shores
        ['firestorm'] = Achievement({
            id = 16466,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Firestorms in the Waking Shores
        ['snowstorm'] = Achievement({
            id = 16467,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }) -- Snowstorms in the Waking Shores
    }, -- Waking Shores
    [2023] = {
        ['thunderstorm'] = Achievement({
            id = 16475,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Thunderstorms in the Ohnahran Plains
        ['sandstorm'] = Achievement({
            id = 16477,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Sandstorms in the Ohnahran Plains
        ['firestorm'] = Achievement({
            id = 16478,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Firestorms in the Ohnahran Plains
        ['snowstorm'] = Achievement({
            id = 16479,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }) -- Snowstorms in the Ohnahran Plains
    }, -- Ohn'ahran Plains
    [2024] = {
        ['thunderstorm'] = Achievement({
            id = 16480,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Thunderstorms in the Azure Span
        ['sandstorm'] = Achievement({
            id = 16481,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Sandstorms in the Azure Span
        ['firestorm'] = Achievement({
            id = 16482,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Firestorms in the Azure Span
        ['snowstorm'] = Achievement({
            id = 16483,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }) -- Snowstorms in the Azure Span
    }, -- Azure Span
    [2025] = {
        ['thunderstorm'] = Achievement({
            id = 16485,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Thunderstorms in Thaldraszus
        ['sandstorm'] = Achievement({
            id = 16486,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Sandstorms in Thaldraszus
        ['firestorm'] = Achievement({
            id = 16487,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Firestorms in Thaldraszus
        ['snowstorm'] = Achievement({
            id = 16488,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }) -- Snowstorms in Thaldraszus
    }, -- Thaldraszus
    [2085] = {
        ['thunderstorm'] = Achievement({
            id = 16485,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Thunderstorms in Thaldraszus
        ['sandstorm'] = Achievement({
            id = 16486,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Sandstorms in Thaldraszus
        ['firestorm'] = Achievement({
            id = 16487,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }), -- Firestorms in Thaldraszus
        ['snowstorm'] = Achievement({
            id = 16488,
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        }) -- Snowstorms in Thaldraszus
    } -- The Primalist Future
}

local ELEMENTAL_STORM_BOSS_ACHIEVEMENTS = {
    ['all'] = Achievement({
        id = 16461,
        criteria = {
            55461, -- Infernum
            55462, -- Crystalus
            55463, -- Bouldron
            55464, -- Karantun
            55465, -- Neela Firebane
            55466, -- Rouen Icewind
            55467, -- Zurgaz Corebreaker
            55468, -- Pipspark Thundersnap
            55469, -- Grizzlerock
            55470, -- Voraazka
            55471, -- Kain Firebrand
            55472, -- Maeleera
            55473, -- Fieraan
            55474, -- Leerain
            55475, -- Gaelzion
            55476, -- Gravlion
            55477, -- Emblazion
            55478 -- Frozion
        } -- Stormed Off
    }),
    ['thunderstorm'] = Achievement({
        id = 16461,
        criteria = {55464, 55468, 55470, 55475}
    }), -- Stormed Off (Thunderstorm bosses only)
    ['sandstorm'] = Achievement({
        id = 16461,
        criteria = {55463, 55467, 55469, 55476}
    }), -- Stormed Off (Sandstorm bosses only)
    ['firestorm'] = Achievement({
        id = 16461,
        criteria = {55461, 55465, 55471, 55477}
    }), -- Stormed Off (Firestorm bosses only)
    ['snowstorm'] = Achievement({
        id = 16461,
        criteria = {55462, 55466, 55472, 55473, 55474, 55478}
    }) -- Stormed Off (Snowstorm bosses only)
}

local ELEMENTAL_STORM_PET_REWARDS = {
    ['thunderstorm'] = Pet({
        item = 200263,
        id = 3310,
        note = L['elemental_storm_thunderstorm']
    }), -- Echo of the Heights
    ['sandstorm'] = Pet({
        item = 200183,
        id = 3355,
        note = L['elemental_storm_sandstorm']
    }), -- Echo of the Cave
    ['firestorm'] = Pet({
        item = 200255,
        id = 3289,
        note = L['elemental_storm_firestorm']
    }), -- Echo of the Inferno
    ['snowstorm'] = Pet({
        item = 200260,
        id = 3299,
        note = L['elemental_storm_snowstorm']
    }) -- Echo of the Depths
}

-- vv ------------------------------------------------------------------------- TO-DO: UPDATE ITEMS TO NEW RECIPE REWARDS VIA IONEY

local ELEMENTAL_STORM_FORMULA_REWARDS = {
    ['all'] = Item({item = 194641}), -- Design: Elemental Lariat
    ['thunderstorm'] = Item({
        item = 200911,
        note = L['elemental_storm_thunderstorm']
    }), -- Formula: Illusion: Primal Air
    ['sandstorm'] = Item({item = 200912, note = L['elemental_storm_sandstorm']}), -- Formula: Illusion: Primal Earth
    ['firestorm'] = Item({item = 200913, note = L['elemental_storm_firestorm']}), -- Formula: Illusion: Primal Fire
    ['snowstorm'] = Item({item = 200914, note = L['elemental_storm_snowstorm']}) -- Formula: Illusion: Primal Frost
}

-- GENERIC ELEMENTAL STORM NODE -----------------------------------------------
--
-- This node will be added at all Element Storm coordinates where there
-- currently is NOT an Elemental Storm happening.
--
-- It will show zone-specific achievements and rewards shared between all four
-- storm types (pets and recipes) because any storm could spawn there.
--
-- General elemental storm nodes will never display at the same location of a
-- storm that is currently happening (see below).

local ElementalStorm = Class('ElementalStorm', Collectible, {
    icon = 538566,
    group = ns.groups.ELEMENTAL_STORM,
    IsEnabled = function(self)
        local activePOIs = C_AreaPoiInfo.GetAreaPOIForMap(self.mapID)
        local possiblePOIs = self.areaPOIs
        for a = 1, #activePOIs do
            for p = 1, #possiblePOIs do
                if activePOIs[a] == possiblePOIs[p] then
                    return false
                end
            end
        end
        return true
    end
})

function ElementalStorm.getters:rewards()
    return {
        ELEMENTAL_STORM_MOB_ACHIVEMENTS['all'], -- Elemental Overload
        Spacer(), ELEMENTAL_STORM_MOB_ACHIVEMENTS[self.mapID]['thunderstorm'], -- Thunderstorms in...
        ELEMENTAL_STORM_MOB_ACHIVEMENTS[self.mapID]['sandstorm'], -- Sandstorms in...
        ELEMENTAL_STORM_MOB_ACHIVEMENTS[self.mapID]['firestorm'], -- Firestorms in...
        ELEMENTAL_STORM_MOB_ACHIVEMENTS[self.mapID]['snowstorm'], -- Snowstorms in...
        Spacer(), ELEMENTAL_STORM_BOSS_ACHIEVEMENTS['all'], -- Stormed Off
        ELEMENTAL_STORM_PET_REWARDS['thunderstorm'], -- Echo of the Heights
        ELEMENTAL_STORM_PET_REWARDS['sandstorm'], -- Echo of the Cave
        ELEMENTAL_STORM_PET_REWARDS['firestorm'], -- Echo of the Inferno
        ELEMENTAL_STORM_PET_REWARDS['snowstorm'], -- Echo of the Depths
        Spacer(), ELEMENTAL_STORM_FORMULA_REWARDS['all'], -- Design: Elemental Lariat
        ELEMENTAL_STORM_FORMULA_REWARDS['thunderstorm'], -- Formula: Illusion: Primal Air
        ELEMENTAL_STORM_FORMULA_REWARDS['sandstorm'], -- Formula: Illusion: Primal Earth
        ELEMENTAL_STORM_FORMULA_REWARDS['firestorm'], -- Formula: Illusion: Primal Fire
        ELEMENTAL_STORM_FORMULA_REWARDS['snowstorm'] -- Formula: Illusion: Primal Frost
    }
end

ns.node.ElementalStorm = ElementalStorm

-- SPECIFIC ELEMENTAL STORM TOOLTIP EDITOR ------------------------------------
--
-- This code will add specific rewards to the tooltip of an Elemental Storm
-- that is currently happening.
--
-- It will show zone-specific AND storm-specific achievements, pets, and recipe
-- rewards.
--
-- General elemental storm nodes will never display at the same location of a
-- storm that is currently happening (see above).
--
-- Additionally, if the Elemental Storms group checkbox is unchecked in the
-- World Map button then the tooltip will not be affected. This is an
-- improvement from my Shadowlands integration and should be used for Sentinax
-- locations in Legion.

hooksecurefunc(AreaPOIPinMixin, 'TryShowTooltip', function(self)
    if self and self.areaPoiID then
        if ELEMENTAL_STORM_AREA_POIS[self.areaPoiID] ~= nil then
            local mapID = self:GetMap().mapID
            local type = ELEMENTAL_STORM_AREA_POIS[self.areaPoiID]
            if ns.groups.ELEMENTAL_STORM:GetDisplay(ns.maps[mapID]) then
                local rewards = {
                    ELEMENTAL_STORM_MOB_ACHIVEMENTS['all'], -- Elemental Overload
                    ELEMENTAL_STORM_MOB_ACHIVEMENTS[mapID][type], -- (Example: Thunderstorms in Thaldraszus)
                    ELEMENTAL_STORM_BOSS_ACHIEVEMENTS[type], -- Stormed Off (Storm type only)
                    Spacer(), ELEMENTAL_STORM_PET_REWARDS[type], -- Echo of the...
                    ELEMENTAL_STORM_FORMULA_REWARDS['all'], -- Design: Elemental Lariat
                    ELEMENTAL_STORM_FORMULA_REWARDS[type] -- Formula: Illusion Primal...
                }
                GameTooltip:AddLine(' ') -- add blank line before rewards
                for i, reward in ipairs(rewards) do
                    if reward:IsEnabled() then
                        reward:Render(GameTooltip)
                    end
                end
                GameTooltip:Show()
            end
        end
    end
end)
