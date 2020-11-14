-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local _, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.VisionsMap
local Clone = ns.Clone

local Coffer = ns.node.Coffer
local PetBattle = ns.node.PetBattle
local Rare = ns.node.Rare
local TimedEvent = ns.node.TimedEvent
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Quest = ns.reward.Quest
local Toy = ns.reward.Toy

local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local MAN, MOG, EMP = 0, 1, 2 -- assaults

local function GetAssault()
    local textures = C_MapExplorationInfo.GetExploredMapTextures(1530)
    if textures and textures[1].fileDataIDs[1] == 3155826 then
        if ns:GetOpt('show_debug_map') then ns.Debug('Vale assault: MAN') end
        return MAN -- left
    elseif textures and textures[1].fileDataIDs[1] == 3155832 then
        if ns:GetOpt('show_debug_map') then ns.Debug('Vale assault: MOG') end
        return MOG -- middle
    elseif textures and textures[1].fileDataIDs[1] == 3155841 then
        if ns:GetOpt('show_debug_map') then ns.Debug('Vale assault: EMP') end
        return EMP -- right
    end
end

-------------------------------------------------------------------------------

local map = Map({id=1530, phased=false, settings=true, GetAssault=GetAssault})
local pools = Map({id=1579, GetAssault=GetAssault})

-------------------------------------------------------------------------------
------------------------------------ INTRO ------------------------------------
-------------------------------------------------------------------------------

local Intro = Class('Intro', ns.node.Intro)

Intro.note = L["vale_intro_note"]

function Intro:IsCompleted()
    return map.assault ~= nil
end

function Intro.getters:label()
    return select(2, GetAchievementInfo(14154)) -- Defend the Vale
end

-- Network Diagnostics => Surfacing Threats
local Q1 = Quest({id={58506, 56374, 56209, 56375, 56472, 56376}})
-- Forging Onward => Magni's Findings
local Q2 = Quest({id={56377, 56536, 56537, 56538, 56539, 56771, 56540}})

if UnitFactionGroup('player') == 'Alliance' then
    map.intro = Intro({rewards={
        Quest({id={58496, 58498, 58502}}), Q1, Q2
    }})
else
    map.intro = Intro({rewards={
        Quest({id={58582, 58583}}), Q1, Q2
    }})
end

map.nodes[26005200] = map.intro

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[20007460] = Rare({
    id=160825,
    quest=58300,
    assault=MAN
}) -- Amber-Shaper Esh'ri

map.nodes[34156805] = Rare({
    id=157466,
    quest=57363,
    assault=MOG,
    rewards={
        Mount({id=1328, item=174840}) -- Xinlao
    }
}) -- Anh-De the Loyal

map.nodes[57084098] = Rare({
    id=154447,
    quest=56237,
    assault=EMP
}) -- Brother Meller

map.nodes[06487204] = Rare({
    id=160878,
    quest=58307,
    assault=MAN
}) -- Buh'gzaki the Blasphemous

map.nodes[06406433] = Rare({
    id=160893,
    quest=58308,
    assault=MAN,
    pois={
        Path({06476733, 06416420, 04016423, 04025675, 03985061, 06484877, 06484597})
    }
}) -- Captain Vor'lek

map.nodes[81226450] = Rare({
    id=154467,
    quest=56255,
    assault=EMP
}) -- Chief Mek-mek

map.nodes[18806841] = Rare({
    id=157183,
    quest=58296,
    assault=MOG,
    pois={
        POI({16806672, 18316516, 19026494, 20166403, 20816263, 20866845, 21016961, 19927330, 18607211})
    }
}) -- Coagulated Anima

map.nodes[66556794] = Rare({
    id=154559,
    quest=56323,
    assault=EMP,
    note=L["big_blossom_mine"]
}) -- Deeplord Zrihj

map.nodes[26506657] = Rare({
    id=160872,
    quest=58304,
    assault=MAN
}) -- Destroyer Krox'tazar

map.nodes[41505721] = Rare({
    id=157287,
    quest=57349,
    assault=MOG,
    pois={
        Path({41745982, 40446144, 38995953, 39805740, 41505721, 45405297})
    }
}) -- Dokani Obliterator

map.nodes[13004085] = Rare({
    id=160874,
    quest=58305,
    assault=MAN
}) -- Drone Keeper Ak'thet

map.nodes[10004085] = Rare({
    id=160876,
    quest=58306,
    assault=MAN
}) -- Enraged Amber Elemental

map.nodes[45244524] = Rare({
    id=157267,
    quest=57343,
    assault=EMP,
    pois={
        Path({44174609, 45244524, 45324176, 44783891})
    }
}) -- Escaped Mutation

map.nodes[29513800] = Rare({
    id=157153,
    quest=57344,
    assault=MOG,
    rewards={
        Mount({id=1297, item=173887}) -- Clutch of Ha-Li
    },
    pois={
        Path({37323630, 33973378, 29053930, 31524387, 37313632, 37323630})
    }
}) -- Ha-Li

map.nodes[28895272] = Rare({
    id=160810,
    quest=58299,
    assault=MAN
}) -- Harbinger Il'koxik

map.nodes[12835129] = Rare({
    id=160868,
    quest=58303,
    assault=MAN
}) -- Harrier Nir'verash

map.nodes[28214047] = Rare({
    id=157171,
    quest=57347,
    assault=MOG
}) -- Heixi the Stonelord

map.nodes[19736082] = Rare({
    id=160826,
    quest=58301,
    assault=MAN
}) -- Hive-Guard Naz'ruzek

map.nodes[12183091] = Rare({
    id=157160,
    quest=57345,
    assault=MOG,
    rewards={
        Mount({id=1327, item=174841}) -- Ren's Stalwart Hound
    },
    pois={
        Path({13132578, 11833049, 08953570})
    }
}) -- Houndlord Ren

map.nodes[19976576] = Rare({
    id=160930,
    quest=58312,
    assault=MAN
}) -- Infused Amber Ooze

map.nodes[17201162] = Rare({
    id=160968,
    quest=58295,
    assault=MOG,
    note=L["guolai_left"]
}) -- Jade Colossus

map.nodes[26691061] = Rare({
    id=157290,
    quest=57350,
    assault=MOG,
    note=L["in_small_cave"]
}) -- Jade Watcher

map.nodes[17850918] = Rare({
    id=160920,
    quest=58310,
    assault=MAN
}) -- Kal'tik the Blight

map.nodes[45985858] = Rare({
    id=157266,
    quest=57341,
    assault=EMP,
    pois={
        Path({45985858, 48645963, 50576511, 48936926, 45877046, 43096817, 42486336, 45985858})
    }
}) -- Kilxl the Gaping Maw

map.nodes[25673816] = Rare({
    id=160867,
    quest=58302,
    assault=MAN
}) -- Kzit'kovok

map.nodes[14813374] = Rare({
    id=160922,
    quest=58311,
    assault=MAN
}) -- Needler Zhesalla

map.nodes[90314599] = Rare({
    id=154106,
    quest=56094,
    assault=EMP
}) -- Quid

map.nodes[21901232] = Rare({
    id=157162,
    quest=57346,
    assault=MOG,
    note=L["guolai_center"],
    rewards={
        Item({item=174230}), -- Pristine Cloud Serpent Scale
        Mount({id=1313, item=174649}) -- Rajani Warserpent
    }
}) -- Rei Lun

map.nodes[64175175] = Rare({
    id=154490,
    quest=56302,
    assault=EMP
}) -- Rijz'x the Devourer

map.nodes[46425710] = Rare({
    id=156083,
    quest=56954,
    assault=MOG,
    rewards={
        Item({item=174071}) -- Sanguifang's Pulsating Canine
    }
}) -- Sanguifang

map.nodes[25074411] = Rare({
    id=160906,
    quest=58309,
    assault=MAN
}) -- Skiver

map.nodes[17873752] = Rare({
    id=157291,
    quest=57351,
    assault=MOG
}) -- Spymaster Hul'ach

map.nodes[26057505] = Rare({
    id=157279,
    quest=57348,
    assault=MOG,
    pois={
        Path({23467717, 25247587, 26837367, 27117143})
    }
}) -- Stormhowl

map.nodes[29132207] = Rare({
    id=156424,
    quest=58507,
    assault=MOG,
    rewards={
        Toy({item=174873}) -- Trans-mogu-rifier
    }
}) -- Tashara

map.nodes[47496373] = Rare({
    id=154600,
    quest=56332,
    assault=MOG
}) -- Teng the Awakened

map.nodes[52024173] = Rare({
    id=157176,
    quest=57342,
    assault=EMP,
    note=L["platform"],
    rewards={
        Pet({id=2845, item=174473}) -- K'uddly
    }
}) -- The Forgotten

map.nodes[09586736] = Rare({
    id=157468,
    quest=57364,
    note=L["tisiphon"]
}) -- Tisiphon

map.nodes[86664165] = Rare({
    id=154394,
    quest=56213,
    assault=EMP
}) -- Veskan the Fallen

map.nodes[66732812] = Rare({
    id=154332,
    quest=56183,
    assault=EMP,
    note=L["pools_of_power"]
}) -- Voidtender Malketh

map.nodes[52956225] = Rare({
    id=154495,
    quest=56303,
    assault=EMP,
    note=L["left_eye"],
    rewards={
        Item({item=175141}), -- All-Seeing Left Eye
        Toy({item=175140}), -- All-Seeing Eye
        Pet({id=2846, item=174474}) -- Corrupted Tentacle
    }
}) -- Will of N'Zoth

map.nodes[53794889] = Rare({
    id=157443,
    quest=57358,
    assault=MOG
}) -- Xiln the Mountain

map.nodes[70954053] = Rare({
    id=154087,
    quest=56084,
    assault=EMP
}) -- Zror'um the Infinite

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

local MANChest = Class('MANChest', Treasure, {
    assault=MAN,
    group=ns.groups.DAILY_CHESTS,
    label=L["ambered_cache"]
})

local MANTR1 = MANChest({quest=58224, icon='chest_rd'})
local MANTR2 = MANChest({quest=58225, icon='chest_bl', fgroup='manchest2'})
local MANTR3 = MANChest({quest=58226, icon='chest_yw'})
local MANTR4 = MANChest({quest=58227, icon='chest_pp'})
local MANTR5 = MANChest({quest=58228, icon='chest_gn'})

-- quest=58224
map.nodes[04066172] = MANTR1
map.nodes[05165140] = MANTR1
map.nodes[07223945] = MANTR1
map.nodes[10662334] = MANTR1
map.nodes[11552553] = MANTR1
map.nodes[15797164] = MANTR1
map.nodes[15887672] = MANTR1
-- quest=58225
map.nodes[16021946] = MANTR2
map.nodes[17432634] = MANTR2
map.nodes[19001350] = Clone(MANTR2, {note=L["guolai"]})
map.nodes[21051415] = MANTR2
map.nodes[26301110] = MANTR2
-- quest=58226
map.nodes[07693682] = MANTR3
map.nodes[09302831] = MANTR3
map.nodes[10174243] = MANTR3
map.nodes[12085118] = MANTR3
map.nodes[15083162] = MANTR3
map.nodes[15324320] = MANTR3
map.nodes[16343312] = MANTR3
map.nodes[17714771] = MANTR3
map.nodes[18253632] = MANTR3
-- quest=58227
map.nodes[18063844] = MANTR4
map.nodes[22903439] = MANTR4
map.nodes[24153524] = MANTR4
map.nodes[24994118] = MANTR4
map.nodes[25843841] = MANTR4
map.nodes[26524136] = MANTR4
map.nodes[26704680] = MANTR4
map.nodes[29944580] = MANTR4
map.nodes[30074194] = MANTR4
map.nodes[31724184] = MANTR4
-- quest=58228
map.nodes[07356617] = MANTR5
map.nodes[10746891] = MANTR5
map.nodes[15406394] = MANTR5
map.nodes[16096581] = MANTR5
map.nodes[19897504] = MANTR5
map.nodes[19975976] = MANTR5
map.nodes[21506269] = MANTR5
map.nodes[21636992] = MANTR5

map.nodes[21586246] = Coffer({
    quest=58770,
    assault=MAN,
    label=L["ambered_coffer"],
    requires=ns.requirement.Item(174766)
})

-------------------------------------------------------------------------------

local MOGChest = Class('MOGChest', Treasure, {
    assault=MOG,
    group=ns.groups.DAILY_CHESTS,
    label=L["mogu_plunder"]
})

local MOGTR1 = MOGChest({quest=57206, icon='chest_rd', note=L["guolai"]})
local MOGTR2 = MOGChest({quest=57208, icon='chest_bl'})
local MOGTR3 = MOGChest({quest=57209, icon='chest_yw'})
local MOGTR4 = MOGChest({quest=57211, icon='chest_pp'})
local MOGTR5 = MOGChest({quest=57212, icon='chest_pk'})
local MOGTR6 = MOGChest({quest=57213, icon='chest_gn'})

-- quest=57206
map.nodes[13500720] = MOGTR1
map.nodes[17741256] = MOGTR1
map.nodes[20221140] = MOGTR1
map.nodes[20441477] = MOGTR1
map.nodes[22971552] = MOGTR1
map.nodes[23850753] = MOGTR1
map.nodes[26001261] = MOGTR1
map.nodes[26130403] = MOGTR1
map.nodes[27061822] = MOGTR1
-- quest=57208
map.nodes[18292766] = MOGTR2
map.nodes[20462833] = MOGTR2
map.nodes[21982793] = MOGTR2
map.nodes[24773504] = MOGTR2
map.nodes[25114049] = MOGTR2
map.nodes[26801860] = MOGTR2
map.nodes[30283762] = MOGTR2
map.nodes[30983065] = MOGTR2
map.nodes[33503481] = MOGTR2
-- quest=57209
map.nodes[19281942] = MOGTR3
map.nodes[20311853] = MOGTR3
map.nodes[21271385] = MOGTR3
map.nodes[27981820] = MOGTR3
map.nodes[31241393] = MOGTR3
map.nodes[32721893] = MOGTR3
-- quest=57211
map.nodes[15496436] = MOGTR4
map.nodes[16704468] = MOGTR4
map.nodes[17356860] = MOGTR4
map.nodes[18787398] = MOGTR4
map.nodes[21356297] = MOGTR4
map.nodes[29774890] = MOGTR4
-- quest=57212
map.nodes[42436854] = MOGTR5
map.nodes[44186853] = MOGTR5
map.nodes[47937093] = MOGTR5
map.nodes[48466580] = MOGTR5
map.nodes[51146319] = MOGTR5
map.nodes[52276731] = MOGTR5
-- quest=57213
map.nodes[32097104] = MOGTR6
map.nodes[33346985] = MOGTR6
map.nodes[33876683] = MOGTR6
map.nodes[37666584] = MOGTR6
map.nodes[38417028] = MOGTR6

local MOGCOFF = Coffer({
    quest=57214,
    assault=MOG,
    fgroup='mogcoffer',
    label=L["mogu_strongbox"],
    requires=ns.requirement.Item(174767)
})

map.nodes[10782831] = MOGCOFF
map.nodes[20006321] = MOGCOFF
map.nodes[24430269] = Clone(MOGCOFF, {note=L["guolai_center"]})
map.nodes[43134209] = MOGCOFF
map.nodes[50182143] = MOGCOFF

-------------------------------------------------------------------------------

local EMPChest = Class('EMPChest', Treasure, {
    assault=EMP,
    group=ns.groups.DAILY_CHESTS,
    label=L["black_empire_cache"]
})

local EMPTR1 = EMPChest({quest=57197, icon='chest_rd'})
local EMPTR2 = EMPChest({quest=57199, icon='chest_yw', note=L["pools_of_power"], fgroup='empchest2', parent=map.id})
local EMPTR3 = EMPChest({quest=57200, icon='chest_gn'})
local EMPTR4 = EMPChest({quest=57201, icon='chest_bl'})
local EMPTR5 = EMPChest({quest=57202, icon='chest_pp', note=L["big_blossom_mine"]})
local EMPTR6 = EMPChest({quest=57203, icon='chest_pk'})

-- quest=57197
map.nodes[42024621] = EMPTR1
map.nodes[42314323] = EMPTR1
map.nodes[42814020] = EMPTR1
map.nodes[44274195] = EMPTR1
map.nodes[44483693] = EMPTR1
map.nodes[46314037] = EMPTR1
map.nodes[50673444] = EMPTR1
map.nodes[52673967] = EMPTR1
map.nodes[53884179] = EMPTR1
-- quest=57199
pools.nodes[09235255] = EMPTR2
pools.nodes[09554460] = EMPTR2
pools.nodes[15235182] = EMPTR2
pools.nodes[23234539] = EMPTR2
pools.nodes[32504372] = EMPTR2
pools.nodes[38294622] = EMPTR2
pools.nodes[45715972] = EMPTR2
pools.nodes[46313359] = EMPTR2
pools.nodes[54384017] = EMPTR2
-- quest=57200
map.nodes[57334165] = EMPTR3
map.nodes[59186181] = EMPTR3
map.nodes[59605624] = EMPTR3
map.nodes[61674641] = EMPTR3
map.nodes[62035159] = EMPTR3
map.nodes[62585721] = EMPTR3
map.nodes[65206504] = EMPTR3
map.nodes[65855969] = EMPTR3
map.nodes[67565584] = EMPTR3
-- quest=57201
map.nodes[70215370] = EMPTR4
map.nodes[76594867] = EMPTR4
map.nodes[77076363] = EMPTR4
map.nodes[77413129] = EMPTR4
map.nodes[78305251] = EMPTR4
map.nodes[78435833] = EMPTR4
map.nodes[79034330] = EMPTR4
map.nodes[80733960] = EMPTR4
map.nodes[81363381] = EMPTR4
map.nodes[87813771] = EMPTR4
-- quest=57202
map.nodes[60806337] = EMPTR5
map.nodes[63107059] = EMPTR5
map.nodes[64297053] = EMPTR5
map.nodes[68306247] = EMPTR5
map.nodes[68705880] = EMPTR5
map.nodes[70686357] = EMPTR5
map.nodes[71516854] = EMPTR5
-- quest=57203
map.nodes[42456853] = EMPTR6
map.nodes[44196852] = EMPTR6
map.nodes[47947095] = EMPTR6
map.nodes[48476579] = EMPTR6
map.nodes[51136323] = EMPTR6
map.nodes[52266732] = EMPTR6

local EMPCOFF = Coffer({
    quest=57628,
    assault=EMP,
    fgroup='empcoffer',
    label=L["black_empire_coffer"],
    requires=ns.requirement.Item(174768)
})

map.nodes[53116634] = EMPCOFF
map.nodes[54804100] = Clone(EMPCOFF, {note=L["platform"]})
map.nodes[62975086] = EMPCOFF
pools.nodes[42104690] = Clone(EMPCOFF, {note=L["pools_of_power"], parent=map.id})
map.nodes[69516094] = EMPCOFF
map.nodes[76626437] = EMPCOFF

-------------------------------------------------------------------------------
-------------------------------- ASSAULT EVENTS -------------------------------
-------------------------------------------------------------------------------

map.nodes[29266081] = TimedEvent({quest=57445, assault=MAN, note=L["noodle_cart"]}) -- Chin's Noodle Cart
map.nodes[08852675] = TimedEvent({quest=57521, assault=MAN, note=L["empowered_wagon"]}) -- Empowered War Wagon
map.nodes[11006443] = TimedEvent({quest=57085, assault=MAN, note=L["empowered_wagon"]}) -- Empowered War Wagon
map.nodes[18556572] = TimedEvent({quest=57540, assault=MAN, note=L["kunchong_incubator"]}) -- Kunchong Incubator
map.nodes[06484227] = TimedEvent({quest=57558, assault=MAN, note=L["mantid_hatch"]}) -- Mantid Hatchery
map.nodes[06487067] = TimedEvent({quest=57089, assault=MAN, note=L["mantid_hatch"]}) -- Mantid Hatchery
map.nodes[19287227] = TimedEvent({quest=57384, assault=MAN, note=L["mending_monstro"]}) -- Mending Monstrosity
map.nodes[26644650] = TimedEvent({quest=57404, assault=MAN, note=L["ravager_hive"]}) -- Ravager Hive
map.nodes[16964567] = TimedEvent({quest=57484, assault=MAN, note=L["ritual_wakening"]}) -- Ritual of Wakening
map.nodes[14073421] = TimedEvent({quest=57453, assault=MAN, note=L["swarm_caller"]}) -- Swarm Caller
map.nodes[25663647] = TimedEvent({quest=57517, assault=MAN, note=L["swarm_caller"]}) -- Swarm Caller
map.nodes[27011715] = TimedEvent({quest=57519, assault=MAN, note=L["swarm_caller"]}) -- Swarm Caller
map.nodes[31146095] = TimedEvent({quest=57542, assault=MAN, note=L["swarm_caller"]}) -- Swarm Caller
map.nodes[11384092] = TimedEvent({quest=57476, assault=MAN, note=L["feeding_grounds"]}) -- Vil'thik Feeding Grounds
map.nodes[11034854] = TimedEvent({quest=57508, assault=MAN, note=L["war_banner"]}) -- Zara'thik War Banner

-------------------------------------------------------------------------------

map.nodes[31332897] = TimedEvent({quest=57087, assault=MOG, note=L["colored_flames"]}) -- Baruk Obliterator
map.nodes[19167199] = TimedEvent({quest=57272, assault=MOG, note=L["colored_flames"]}) -- Bloodbound Effigy
map.nodes[25791737] = TimedEvent({quest=57339, assault=MOG, note=L["guolai_right"]..' '..L["construction_ritual"]}) -- Construction Ritual
map.nodes[14582315] = TimedEvent({quest=57158, assault=MOG, note=L["electric_empower"]}) -- Electric Empowerment
map.nodes[22423650] = TimedEvent({quest=58367, assault=MOG, note=L["empowered_demo"]}) -- Empowered Demolisher
map.nodes[26661700] = TimedEvent({quest=58370, assault=MOG, note=L["empowered_demo"]}) -- Empowered Demolisher
map.nodes[20421247] = TimedEvent({quest=57171, assault=MOG, note=L["goldbough_guardian"]}) -- Goldbough Guardian
map.nodes[33477097] = TimedEvent({quest=58334, assault=MOG, note=L["in_flames"]}) -- Mistfall In Flames
map.nodes[50236341] = TimedEvent({quest=57299, assault=MOG, note=L["mystery_sacro"]}) -- Mysterious Sarcophagus
map.nodes[24824769] = TimedEvent({quest=57323, assault=MOG, note=L["serpent_binding"]}) -- Serpent Binding
map.nodes[17054571] = TimedEvent({quest=57256, assault=MOG, note=L["stormchosen_arena"]}) -- Stormchosen Arena
map.nodes[19870750] = TimedEvent({quest=57049, assault=MOG, note=L["guolai_left"]..' '..L["vault_of_souls"]}) -- Vault of Souls
map.nodes[21411413] = TimedEvent({quest=57023, assault=MOG, note=L["guolai_center"]..' '..L["weighted_artifact"]}) -- Weighted Mogu Artifact
map.nodes[47662165] = TimedEvent({quest=57101, assault=MOG, note=L["colored_flames"]}) -- Zan-Tien Serpent Cage

-------------------------------------------------------------------------------

local MAWREWARD = {Achievement({id=14161, criteria=1})}

map.nodes[41354535] = TimedEvent({quest=58439, assault=EMP, note=L["consuming_maw"], rewards=MAWREWARD}) -- Consuming Maw
map.nodes[46365714] = TimedEvent({quest=58438, assault=EMP, note=L["consuming_maw"], rewards=MAWREWARD}) -- Consuming Maw
map.nodes[81314952] = TimedEvent({quest=58442, assault=EMP, note=L["consuming_maw"], rewards=MAWREWARD}) -- Consuming Maw

map.nodes[42316703] = TimedEvent({quest=56090, assault=EMP, note=L["protect_stout"]}) -- Protecting the Stout
map.nodes[43624146] = TimedEvent({quest=57146, assault=EMP, note=L["corruption_tear"]}) -- Corruption Tear
map.nodes[49356668] = TimedEvent({quest=56074, assault=EMP, note=L["void_conduit"]}) -- Void Conduit
map.nodes[56685933] = TimedEvent({quest=56178, assault=EMP, note=L["void_conduit"]}) -- Void Conduit
map.nodes[60614333] = TimedEvent({quest=56163, assault=EMP, note=L["bound_guardian"]}) -- Bound Guardian
map.nodes[60416780] = TimedEvent({quest=56099, assault=EMP, note=L["big_blossom_mine"]..' '..L["font_corruption"]}) -- Font of Corruption
map.nodes[69502214] = TimedEvent({quest=57375, assault=EMP, note=L["pulse_mound"]}) -- Pulsating Mound
map.nodes[74164004] = TimedEvent({quest=56076, assault=EMP, note=L["abyssal_ritual"]}) -- Abyssal Ritual
map.nodes[76365163] = TimedEvent({quest=57379, assault=EMP, note=L["infested_statue"]}) -- Infested Jade Statue
map.nodes[79233315] = TimedEvent({quest=56177, assault=EMP, note=L["void_conduit"]}) -- Void Conduit
map.nodes[79525433] = TimedEvent({quest=56180, assault=EMP, note=L["bound_guardian"]}) -- Bound Guardian

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[28553494] = PetBattle({id=162470}) -- Baruk Stone Defender
map.nodes[56172822] = PetBattle({id=162468}) -- K'tiny the Mad
map.nodes[57465427] = PetBattle({id=162469}) -- Tormentius
map.nodes[07333190] = PetBattle({id=162471}) -- Vil'thik Hatchling
