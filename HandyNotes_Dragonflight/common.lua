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

ns.groups.TUSKARR_TACKLEBOX = Group('tuskarr_tacklebox', 'chest_bl', {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.EXPANSION
})

-------------------------------------------------------------------------------

ns.groups.ANCESTOR = Group('ancestor', 135946, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16423
})

ns.groups.BAKAR = Group('bakar', 930453, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16424
})

ns.groups.CHISELED_RECORD = Group('chiseled_record', 134455, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16412
})

ns.groups.DREAMGUARD = Group('dreamguard', 341763, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16574
})

ns.groups.DUCKLINGS = Group('ducklings', 4048818, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16409
})

ns.groups.FLAG = Group('flag', 1723999, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 15890
})

ns.groups.FRAGMENT = Group('fragment', 134908, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16323
})

ns.groups.GRAND_THEFT_MAMMOTH = Group('grand_theft_mammoth', 4034836, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16493
})

ns.groups.HEMET_NESINGWARY_JR = Group('hemet_nesingwary_jr', 236444, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16542
})

ns.groups.KITE = Group('kite', 133837, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16584
})

ns.groups.NOKHUD_DO_IT = Group('nokhud_do_it', 1103068, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16583
})

ns.groups.LEGENDARY_ALBUM = Group('legendary_album', 1109168, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16570
})

ns.groups.LEYLINE = Group('leyline', 1033908, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16638
})

ns.groups.NEW_PERSPECTIVE = Group('new_perspective', 1109100, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16634
})

ns.groups.PRETTY_NEAT = Group('pretty_neat', 133707, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16446
})

ns.groups.SAFARI = Group('safari', 4048818, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16519
})

ns.groups.SNACK_ATTACK = Group('snack_attack', 134062, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16410
})

ns.groups.SPECIALTIES = Group('specialties', 651585, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16621
})

ns.groups.SQUIRRELS = Group('squirrels', 237182, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16729
})

ns.groups.STORIES = Group('stories', 4549126, {
    defaults = ns.GROUP_HIDDEN,
    type = ns.group_types.ACHIEVEMENT,
    achievement = 16406
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
        Armor = Item({item = 197588, quest = 69792}),
        BeakedSnout = Item({item = 197620, quest = 69824}),
        BlackFur = Item({item = 197597, quest = 69801}),
        BlackScales = Item({item = 197611, quest = 69815}),
        BlueScales = Item({item = 197612, quest = 69816}),
        BronzeAndGreenArmor = Item({item = 197577, quest = 69781}),
        BronzeScales = Item({item = 197613, quest = 69817}),
        ClubTail = Item({item = 197624, quest = 69828}),
        ClusterHorns = Item({item = 197602, quest = 69806}),
        CurledHorns = Item({item = 197605, quest = 69809}),
        CurvedHorns = Item({item = 197603, quest = 69807}),
        ExposedFinnedBack = Item({item = 197583, quest = 69787}),
        ExposedFinnedNeck = Item({item = 197626, quest = 69831}),
        ExposedFinnedTail = Item({item = 197621, quest = 69825}),
        FeatheredBack = Item({item = 197587, quest = 69791}),
        FeatheredNeck = Item({item = 197630, quest = 69836}),
        FeatheryHead = Item({item = 197593, quest = 69797}),
        FeatheryTail = Item({item = 197625, quest = 69829}),
        FinnedBack = Item({item = 197584, quest = 69788}),
        FinnedEars = Item({item = 197595, quest = 69799}),
        FinnedNeck = Item({item = 197627, quest = 69832}),
        FinnedTail = Item({item = 197622, quest = 69826}),
        GoldAndRedArmor = Item({item = 197580, quest = 69784}),
        GrayHair = Item({item = 197598, quest = 69802}),
        GrayHorns = Item({item = 197608, quest = 69812}),
        HairyHead = Item({item = 197591, quest = 381190}),
        HeavyScales = Item({item = 197617, quest = 69821}),
        Helm = Item({item = 197600, quest = 69804}),
        HookedSnout = Item({item = 197619, quest = 69823}),
        HornedJaw = Item({item = 197596, quest = 69800}),
        LargeHeadFin = Item({item = 197589, quest = 69793}),
        LongSnout = Item({item = 197618, quest = 69822}),
        ManedBack = Item({item = 197585, quest = 69789}),
        OxHorns = Item({item = 197604, quest = 69808}),
        PlatedNeck = Item({item = 197628, quest = 69834}),
        ReaverPattern = Item({item = 197635, quest = 69846}),
        RedHair = Item({item = 197599, quest = 69803}),
        RedScales = Item({item = 197614, quest = 69818}),
        ShriekerPattern = Item({item = 197636, quest = 69847}),
        SilverAndBlueArmor = Item({item = 197578, quest = 69782}),
        SilverAndPurpleArmor = Item({item = 197581, quest = 69785}),
        SmallEars = Item({item = 197594, quest = 69798}),
        SmallHeadFin = Item({item = 197590, quest = 69794}),
        SpikedBack = Item({item = 197586, quest = 69790}),
        SpikedNeck = Item({item = 197629, quest = 69835}),
        SpikedTail = Item({item = 197623, quest = 69827}),
        SpinedHead = Item({item = 197592, quest = 69796}),
        SplitHorns = Item({item = 197607, quest = 69811}),
        SteelAndOrangeArmor = Item({item = 197579, quest = 69783}),
        SweptHorns = Item({item = 197606, quest = 69810}),
        TealScales = Item({item = 197615, quest = 69819}),
        WavyHorns = Item({item = 197601, quest = 69805}),
        WhiteAndPinkArmor = Item({item = 197582, quest = 69786}),
        WhiteHorns = Item({item = 197609, quest = 69813}),
        WhiteScales = Item({item = 197616, quest = 69820}),
        WindsweptPattern = Item({item = 197634, quest = 69845}),
        YellowHorns = Item({item = 197610, quest = 69814})
    },
    HighlandDrake = {
        Armor = Item({item = 197099, quest = 69300}),
        BlackHair = Item({item = 197117, quest = 69318}),
        BlackScales = Item({item = 197142, quest = 69343}),
        BladedTail = Item({item = 197153, quest = 69354}),
        BronzeAndGreenArmor = Item({item = 197156, quest = 69357}),
        BronzeScales = Item({item = 197145, quest = 69346}),
        BrownHair = Item({item = 197118, quest = 69319}),
        BushyBrow = Item({item = 197101, quest = 69302}),
        ClubTail = Item({item = 197149, quest = 69350}),
        CoiledHorns = Item({item = 197125, quest = 69326}),
        CrestedBrow = Item({item = 197100, quest = 69301}),
        CurledBackHorns = Item({item = 197128, quest = 69329}),
        Ears = Item({item = 197116, quest = 69317}),
        EmbodimentOfTheCrimsonGladiator = Item({item = 201792, quest = 72371}),
        FinnedBack = Item({item = 197098, quest = 69299}),
        FinnedHead = Item({item = 197106, quest = 69307}),
        FinnedNeck = Item({item = 197155, quest = 69356}),
        GoldAndBlackArmor = Item({item = 197090, quest = 69290}),
        GoldAndRedArmor = Item({item = 197094, quest = 69295}),
        GoldAndWhiteArmor = Item({item = 197095, quest = 69296}),
        GrandThornHorns = Item({item = 197127, quest = 69328}),
        GreenScales = Item({item = 197143, quest = 69344}),
        HairyCheek = Item({item = 197131, quest = 69332}),
        HeavyHorns = Item({item = 197122, quest = 69323}),
        HeavyScales = Item({item = 197147, quest = 69348}),
        Helm = Item({item = 197119, quest = 69320}),
        HookedHorns = Item({item = 197126, quest = 69327}),
        HookedTail = Item({item = 197152, quest = 69353}),
        HornedChin = Item({item = 197102, quest = 69303}),
        LargeSpottedPattern = Item({item = 197139, quest = 69340}),
        ManedChin = Item({item = 197103, quest = 69304}),
        ManedHead = Item({item = 197111, quest = 69312}),
        MultiHornedHead = Item({item = 197114, quest = 69315}),
        OrnateHelm = Item({item = 197120, quest = 69321}),
        PlatedHead = Item({item = 197110, quest = 69311}),
        RedScales = Item({item = 197144, quest = 69345}),
        ScaledPattern = Item({item = 197141, quest = 69342}),
        SilverAndBlueArmor = Item({item = 197091, quest = 69291}),
        SilverAndPurpleArmor = Item({item = 197093, quest = 69294}),
        SingleHornedHead = Item({item = 197112, quest = 69313}),
        SleekHorns = Item({item = 197129, quest = 69330}),
        SmallSpottedPattern = Item({item = 197140, quest = 69341}),
        SpikedCheek = Item({item = 197132, quest = 69333}),
        SpikedClubTail = Item({item = 197150, quest = 69351}),
        SpikedHead = Item({item = 197109, quest = 69310}),
        SpikedLegs = Item({item = 197134, quest = 69335}),
        SpikedTail = Item({item = 197151, quest = 69352}),
        SpinedBack = Item({item = 197097, quest = 69298}),
        SpinedCheek = Item({item = 197133, quest = 69334}),
        SpinedChin = Item({item = 197105, quest = 69306}),
        SpinedHead = Item({item = 197108, quest = 69309}),
        SpinedNeck = Item({item = 197154, quest = 69355}),
        SpinedNose = Item({item = 197137, quest = 69338}),
        StagHorns = Item({item = 197130, quest = 69331}),
        SteelAndYellowArmor = Item({item = 197096, quest = 69297}),
        StripedPattern = Item({item = 197138, quest = 69339}),
        SweptHorns = Item({item = 197124, quest = 69325}),
        SweptSpikedHead = Item({item = 197113, quest = 69314}),
        TanHorns = Item({item = 197121, quest = 69322}),
        TaperedChin = Item({item = 197104, quest = 69305}),
        TapereredNose = Item({item = 197136, quest = 69337}),
        ThornedJaw = Item({item = 197115, quest = 69324}),
        ThornHorns = Item({item = 197123, quest = 69316}),
        ToothyMouth = Item({item = 197135, quest = 69336}),
        TripleFinnedHead = Item({item = 197107, quest = 69308}),
        VerticalFinnedTail = Item({item = 197148, quest = 69349}),
        WhiteScales = Item({item = 197146, quest = 69347})
    },
    CliffsideWylderdrake = {
        Armor = Item({item = 196961, quest = 69161}),
        BlackHair = Item({item = 196986, quest = 69186}),
        BlackHorns = Item({item = 196991, quest = 69191}),
        BlackScales = Item({item = 197013, quest = 69213}),
        BlondeHair = Item({item = 196987, quest = 69187}),
        BlueScales = Item({item = 197012, quest = 69212}),
        BluntSpikedTail = Item({item = 197019, quest = 69219}),
        BranchedHorns = Item({item = 196996, quest = 69196}),
        BronzeAndTealArmor = Item({item = 196965, quest = 69165}),
        CoiledHorns = Item({item = 197000, quest = 69200}),
        ConicalHead = Item({item = 196981, quest = 69181}),
        CurledHeadHorns = Item({item = 196979, quest = 69179}),
        DarkSkinVariation = Item({item = 197015, quest = 69215}),
        DualHornedChin = Item({item = 196973, quest = 69173}),
        Ears = Item({item = 196982, quest = 69182}),
        FinnedBack = Item({item = 196969, quest = 69169}),
        FinnedCheek = Item({item = 197001, quest = 69201}),
        FinnedJaw = Item({item = 196984, quest = 69184}),
        FinnedNeck = Item({item = 197022, quest = 69222}),
        FinnedTail = Item({item = 197018, quest = 69218}),
        FlaredCheek = Item({item = 197002, quest = 69202}),
        FourHornedChin = Item({item = 196974, quest = 69174}),
        GoldAndBlackArmor = Item({item = 196964, quest = 69164}),
        GoldAndOrangeArmor = Item({item = 196966, quest = 69166}),
        GoldAndWhiteArmor = Item({item = 196967, quest = 69167}),
        GreenScales = Item({item = 197011, quest = 69211}),
        HeadFin = Item({item = 196975, quest = 69175}),
        HeadMane = Item({item = 196976, quest = 69176}),
        HeavyHorns = Item({item = 196992, quest = 69192}),
        Helm = Item({item = 196990, quest = 69190}),
        HookHorns = Item({item = 196998, quest = 69198}),
        HornedJaw = Item({item = 196985, quest = 69185}),
        HornedNose = Item({item = 197005, quest = 69205}),
        LargeTailSpikes = Item({item = 197017, quest = 69217}),
        ManedJaw = Item({item = 196983, quest = 69183}),
        ManedNeck = Item({item = 197023, quest = 69223}),
        ManedTail = Item({item = 197016, quest = 69216}),
        NarrowStripesPattern = Item({item = 197008, quest = 69208}),
        PlatedBrow = Item({item = 196972, quest = 69172}),
        PlatedNose = Item({item = 197006, quest = 69206}),
        RedHair = Item({item = 196988, quest = 69188}),
        RedScales = Item({item = 197010, quest = 69210}),
        ScaledPattern = Item({item = 197009, quest = 69209}),
        ShortHorns = Item({item = 196994, quest = 69194}),
        SilverAndBlueArmor = Item({item = 196963, quest = 69163}),
        SilverAndPurpleArmor = Item({item = 196962, quest = 69162}),
        SleekHorns = Item({item = 196993, quest = 69193}),
        SmallHeadSpikes = Item({item = 196978, quest = 69178}),
        SpearTail = Item({item = 197020, quest = 69220}),
        SpikedBack = Item({item = 196970, quest = 69170}),
        SpikedBrow = Item({item = 196971, quest = 69171}),
        SpikedCheek = Item({item = 197003, quest = 69203}),
        SpikedClubTail = Item({item = 197021, quest = 69221}),
        SpikedHorns = Item({item = 196995, quest = 69195}),
        SpikedLegs = Item({item = 197004, quest = 69204}),
        SplitHeadHorns = Item({item = 196977, quest = 69177}),
        SplitHorns = Item({item = 196997, quest = 69197}),
        SteelAndYellowArmor = Item({item = 196968, quest = 69168}),
        SweptHorns = Item({item = 196999, quest = 69199}),
        TripleHeadHorns = Item({item = 196980, quest = 69180}),
        WhiteHair = Item({item = 196989, quest = 69189}),
        WhiteScales = Item({item = 197014, quest = 69214}),
        WideStripesPattern = Item({item = 197007, quest = 69207})
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
------------------------------ TUSKARR TACKLEBOX ------------------------------
-------------------------------------------------------------------------------

local TuskarrTacklebox = Class('TuskarrTacklebox', Node, {
    label = L['tuskarr_tacklebox'],
    icon = 'chest_bl',
    group = ns.groups.TUSKARR_TACKLEBOX,
    requires = {
        ns.requirement.Reputation(2511, 27, true), -- Iskaara Tuskarr
        ns.requirement.Quest(70952) -- Abandoned or Hidden Caches
    },
    rewards = {
        Item({item = 194730}), -- Scalebelly Mackerel
        Item({item = 194966}), -- Thousandbite Piranha
        Item({item = 194967}), -- Aileron Seamoth
        Item({item = 194968}), -- Cerulean Spinefish
        Item({item = 194969}), -- Temporal Dragonhead
        Item({item = 194970}), -- Islefin Dorado
        Spacer(), Item({item = 199338}), -- Copper Coin of the Isle
        Item({item = 199339}), -- Silver Coin of the Isle
        Item({item = 199340}), -- Gold Coin of the Isle
        Spacer(), Item({item = 198438}), -- Draconic Recipe in a Bottle
        Currency({id = 2003}) -- Dragon Isles Supplies
    }
})

ns.node.TuskarrTacklebox = TuskarrTacklebox

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
    group = ns.groups.PRETTY_NEAT,
    IsEnabled = function(self)
        if self.isRare and ns.groups.RARE:GetDisplay(self.mapID) then
            return false
        end
        if not ns:GetOpt('show_completed_nodes') and self:IsCompleted() then
            return false
        end
        return true
    end
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
------------------------------ ELEMENTAL CHESTS -------------------------------
-------------------------------------------------------------------------------

local ElementalChest = Class('ElementalChest', ns.node.Treasure, {
    icon = 'chest_rd', -- temporary, maybe change it to different icon?
    getters = {
        rlabel = function(self)
            local completed = C_QuestLog.IsQuestFlaggedCompleted(self.quest[1])
            local color = completed and ns.status.Green or ns.status.Gray
            return color(L['weekly'])
        end
    }
})

ns.node.ElementalChest = ElementalChest

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
        ['thunderstorm'] = 16463, -- Thunderstorms in the Waking Shores
        ['sandstorm'] = 16465, -- Sandstorms in the Waking Shores
        ['firestorm'] = 16466, -- Firestorms in the Waking Shores
        ['snowstorm'] = 16467 -- Snowstorms in the Waking Shores
    }, -- Waking Shores
    [2023] = {
        ['thunderstorm'] = 16475, -- Thunderstorms in the Ohnahran Plains
        ['sandstorm'] = 16477, -- Sandstorms in the Ohnahran Plains
        ['firestorm'] = 16478, -- Firestorms in the Ohnahran Plains
        ['snowstorm'] = 16479 -- Snowstorms in the Ohnahran Plains
    }, -- Ohn'ahran Plains
    [2024] = {
        ['thunderstorm'] = 16480, -- Thunderstorms in the Azure Span
        ['sandstorm'] = 16481, -- Sandstorms in the Azure Span
        ['firestorm'] = 16482, -- Firestorms in the Azure Span
        ['snowstorm'] = 16483 -- Snowstorms in the Azure Span
    }, -- Azure Span
    [2025] = {
        ['thunderstorm'] = 16485, -- Thunderstorms in Thaldraszus
        ['sandstorm'] = 16486, -- Sandstorms in Thaldraszus
        ['firestorm'] = 16487, -- Firestorms in Thaldraszus
        ['snowstorm'] = 16488 -- Snowstorms in Thaldraszus
    }, -- Thaldraszus
    [2085] = {
        ['thunderstorm'] = 16485, -- Thunderstorms in Thaldraszus
        ['sandstorm'] = 16486, -- Sandstorms in Thaldraszus
        ['firestorm'] = 16487, -- Firestorms in Thaldraszus
        ['snowstorm'] = 16488 -- Snowstorms in Thaldraszus
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
    local function getStormAchievement(mapID, stormType)
        return Achievement({
            id = ELEMENTAL_STORM_MOB_ACHIVEMENTS[mapID][stormType],
            criteria = {
                id = 1,
                qty = true,
                suffix = L['empowered_mobs_killed_suffix']
            }
        })
    end

    return {
        ELEMENTAL_STORM_MOB_ACHIVEMENTS['all'], Spacer(),
        getStormAchievement(self.mapID, 'thunderstorm'),
        getStormAchievement(self.mapID, 'sandstorm'),
        getStormAchievement(self.mapID, 'firestorm'),
        getStormAchievement(self.mapID, 'snowstorm'), Spacer(),
        ELEMENTAL_STORM_BOSS_ACHIEVEMENTS['all'],
        ELEMENTAL_STORM_PET_REWARDS['thunderstorm'],
        ELEMENTAL_STORM_PET_REWARDS['sandstorm'],
        ELEMENTAL_STORM_PET_REWARDS['firestorm'],
        ELEMENTAL_STORM_PET_REWARDS['snowstorm'], Spacer(),
        ELEMENTAL_STORM_FORMULA_REWARDS['all'],
        ELEMENTAL_STORM_FORMULA_REWARDS['thunderstorm'],
        ELEMENTAL_STORM_FORMULA_REWARDS['sandstorm'],
        ELEMENTAL_STORM_FORMULA_REWARDS['firestorm'],
        ELEMENTAL_STORM_FORMULA_REWARDS['snowstorm']
    }
end

ns.node.ElementalStorm = ElementalStorm

hooksecurefunc(AreaPOIPinMixin, 'TryShowTooltip', function(self)
    if self and self.areaPoiID then
        local mapID = self:GetMap().mapID
        local group = ns.groups.ELEMENTAL_STORM
        local stormType = ELEMENTAL_STORM_AREA_POIS[self.areaPoiID]

        if FlightMapFrame == nil or not FlightMapFrame:IsShown() then
            if stormType and group:GetDisplay(mapID) then
                local rewards = {
                    ELEMENTAL_STORM_MOB_ACHIVEMENTS['all'], Achievement({
                        id = ELEMENTAL_STORM_MOB_ACHIVEMENTS[mapID][stormType],
                        criteria = {
                            id = 1,
                            qty = true,
                            suffix = L['empowered_mobs_killed_suffix']
                        }
                    }), ELEMENTAL_STORM_BOSS_ACHIEVEMENTS[stormType], Spacer(),
                    ELEMENTAL_STORM_PET_REWARDS[stormType],
                    ELEMENTAL_STORM_FORMULA_REWARDS['all'],
                    ELEMENTAL_STORM_FORMULA_REWARDS[stormType]
                }
                GameTooltip:AddLine(' ')
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
