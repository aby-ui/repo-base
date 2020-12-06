local _,L = ...
local rematch = Rematch

--[[
    rematch.targetData is a table of all targets in this format:

        {expansionID,mapID,npcID,questID,rarity,level,pet1,pet2,pet3}, -- comment

    if expansionID is a number, it's the expansion named as _G["EXPANSION_NAME"..expansionID]; otherwise name is text itself
    if mapID is a number, it's the map named C_Map.GetMapInfo(mapID).name; otherwise name is text itself
    npcID is the npcID of the tamer/quest giver/etc opponent; targetRedirect table can refer to these too
    rarity is 2 for common through 6 for legendary
    level is the level of the pets
    pet1 through pet3 are the speciesIDs of the target's pets

    The menus (and target list) are built in the order listed here, with the first submenus being the expansions
    and the next submenu of the maps. Within the map submenu are the targets for that map.

    As new targets are added, they should be added to the front/top of the list so they appear at the top of menus
    and the target panel list.
]]

rematch.targetData = {

    -- expansionID "Dungeons"

    -- mapID 242: Blackrock Depths
    {DUNGEONS,242,160209,58458,4,25,2801,2800,2799}, -- Horu Cloudwatcher
    {DUNGEONS,242,161650,58458,4,25,2816}, -- Liz
    {DUNGEONS,242,161649,58458,4,25,2815}, -- Rampage
    {DUNGEONS,242,161651,58458,4,25,2817}, -- Ralf
    {DUNGEONS,242,160207,58458,4,25,2802,2803}, -- Therin Skysong
    {DUNGEONS,242,161661,58458,4,25,2821}, -- Wilbur
    {DUNGEONS,242,161658,58458,4,25,2820}, -- Shred
    {DUNGEONS,242,161656,58458,4,25,2818}, -- Splint
    {DUNGEONS,242,161662,58458,4,25,2822}, -- Char
    {DUNGEONS,242,161657,58458,4,25,2819}, -- Ninn Jah
    {DUNGEONS,242,161663,58458,4,25,2823}, -- Tempton
    {DUNGEONS,242,160206,58458,4,25,2804,2805,2806}, -- Alran Heartshade
    {DUNGEONS,242,160208,58458,4,25,2807,2808,2809}, -- Zuna Skullcrush
    {DUNGEONS,242,160210,58458,4,25,2810,2811,2812}, -- Tasha Riley
    {DUNGEONS,242,160205,58458,4,25,2814}, -- Pixy Wizzle
    -- mapID 317: Stratholme
    {DUNGEONS,317,150923,56492,4,25,2609}, -- Belchling
    {DUNGEONS,317,150922,56492,4,25,2608}, -- Sludge Belcher
    {DUNGEONS,317,150911,56492,4,25,2597}, -- Crypt Fiend
    {DUNGEONS,317,150914,56492,4,25,2600,2607,2606}, -- Wandering Phantasm, Zasz the Tiny, Plague Whelp
    {DUNGEONS,317,150925,56492,4,25,2612}, -- Liz the Tormentor
    {DUNGEONS,317,155145,56492,4,25,2595,2594,2593}, -- Diseased Rat, Plague Rat, Plague Roach
    {DUNGEONS,317,155267,56492,4,25,2751}, -- Risen Guard
    {DUNGEONS,317,150929,56492,4,25,2613}, -- Nefarious Terry
    {DUNGEONS,317,150918,56492,4,25,2603}, -- Tommy the Cruel
    {DUNGEONS,317,150917,56492,4,25,2602}, -- Huncher
    {DUNGEONS,317,150858,56492,4,25,2592}, -- Blackmane
    {DUNGEONS,317,155414,56492,4,25,2768,2769,2770}, -- Fras Siabi
    {DUNGEONS,317,155413,56492,4,25,2774,2771,2772}, -- Postmaster Malown
    -- mapID 226: Gnomeregan
    {DUNGEONS,226,146001,54186,4,25,2501}, -- Prototype Annoy-O-Tron
    {DUNGEONS,226,146182,54186,4,25,2503}, -- Living Sludge
    {DUNGEONS,226,146183,54186,4,25,2502}, -- Living Napalm
    {DUNGEONS,226,146181,54186,4,25,2504}, -- Living Permafrost
    {DUNGEONS,226,146932,54186,4,25,2497,2498,2499}, -- Door Control Console
    {DUNGEONS,226,145971,54186,4,25,2486}, -- Cockroach
    {DUNGEONS,226,145968,54186,4,25,2485}, -- Leper Rat
    {DUNGEONS,226,146005,54186,4,25,2495}, -- Bloated Leper Rat
    {DUNGEONS,226,146004,54186,4,25,2494}, -- Gnomeregan Guard Mechanostrider
    {DUNGEONS,226,146003,54186,4,25,2493}, -- Gnomeregan Guard Tiger
    {DUNGEONS,226,146002,54186,4,25,2492}, -- Gnomeregan Guard Wolf
    {DUNGEONS,226,145988,54186,4,25,2488}, -- Pulverizer Bot Mk 60001
    -- mapID 55: Deadmines
    {DUNGEONS,55,119409,46292,4,25,2031}, -- Foe Reaper 50
    {DUNGEONS,55,119346,46292,4,25,2023}, -- Unfortunate Defias
    {DUNGEONS,55,119342,46292,4,25,2027}, -- Angry Geode
    {DUNGEONS,55,119341,46292,4,25,2028}, -- Mining Monkey
    {DUNGEONS,55,119408,46292,4,25,2033}, -- "Captain" Klutz
    {DUNGEONS,55,119343,46292,4,25,2026}, -- Klutz's Battle Rat
    {DUNGEONS,55,119345,46292,4,25,2024}, -- Klutz's Battle Monkey
    {DUNGEONS,55,119344,46292,4,25,2025}, -- Klutz's Battle Bird
    {DUNGEONS,55,119407,46292,4,25,2032}, -- Cookie's Leftovers
    -- mapID 11: Wailing Caverns
    {DUNGEONS,11,116786,45539,4,25,1989}, -- Deviate Smallclaw
    {DUNGEONS,11,116788,45539,4,25,1988}, -- Deviate Chomper
    {DUNGEONS,11,116787,45539,4,25,1987}, -- Deviate Flapper
    {DUNGEONS,11,116789,45539,4,25,1990}, -- Son of Skum
    {DUNGEONS,11,116792,45539,4,25,1993}, -- Phyxia
    {DUNGEONS,11,116791,45539,4,25,1992}, -- Dreadcoil
    {DUNGEONS,11,116790,45539,4,25,1991}, -- Vilefang
    {DUNGEONS,11,116793,45539,4,25,1994}, -- Hiss
    {DUNGEONS,11,116794,45539,4,25,1995}, -- Growing Ectoplasm
    {DUNGEONS,11,116795,45539,4,25,1996}, -- Budding Everliving Spore
    -- mapID 571: Celestial Tournament
    {DUNGEONS,571,71926,33137,6,25,1283,1284,1285}, -- Lorewalker Cho
    {DUNGEONS,571,71934,33137,6,25,1271,1269,1268}, -- Dr. Ion Goldbloom
    {DUNGEONS,571,71929,33137,6,25,1289,1290,1291}, -- Sully "The Pickle" McLeary
    {DUNGEONS,571,71931,33137,6,25,1292,1293,1295}, -- Taran Zhu
    {DUNGEONS,571,71927,33137,6,25,1280,1281,1282}, -- Chen Stormstout
    {DUNGEONS,571,71924,33137,6,25,1299,1301,1300}, -- Wrathion
    {DUNGEONS,571,71932,33137,6,25,1296,1297,1298}, -- Wise Mari
    {DUNGEONS,571,71933,33137,6,25,1278,1277,1279}, -- Blingtron 4000
    {DUNGEONS,571,71930,33137,6,25,1288,1287,1286}, -- Shademaster Kiryn
    {DUNGEONS,571,72285,33137,6,25,1311}, -- Chi-Chi, Hatchling of Chi-Ji
    {DUNGEONS,571,72009,33137,6,25,1267}, -- Xu-Fu, Cub of Xuen
    {DUNGEONS,571,72291,33137,6,25,1317}, -- Yu'la, Broodling of Yu'lon
    {DUNGEONS,571,72290,33137,6,25,1319}, -- Zao, Calfling of Niuzao

    -- expansionID 8: Shadowlands

    -- mapID 1533: Bastion
    {8,1533,173131,61784,4,25,2972,2973,2974}, -- Stratios (Cliffs of Bastion)
    {8,1533,173133,61783,4,25,2968}, -- Jawbone (Mega Bite)
    {8,1533,173130,61787,4,25,2975,2976,2977}, -- Zolla (Micro Defense Force)
    {8,1533,173129,61791,4,25,2969,2970,2971}, -- Thenia (Thenia's Loyal Companions)
    {8,1533,175777,nil,6,25,3068}, -- Crystalsnap
    {8,1533,175783,nil,6,25,3075}, -- Digallo
    {8,1533,175785,nil,6,25,3077}, -- Kostos

    -- mapID 1536: Maldraxxus
    {8,1536,173257,61866,4,25,2980,2981,2982}, -- Caregiver Maximillian (Mighty Minions of Maldraxxus)
    {8,1536,173263,61867,4,25,2983,2984,2985}, -- Rotgut (Extra Pieces)
    {8,1536,173267,61868,4,25,2986,2987,2988}, -- Dundley Stickyfingers (Uncomfortably Undercover)
    {8,1536,173274,61870,4,25,2978}, -- Gorgemouth (Failed Experiment)
    {8,1536,175784,nil,6,25,3076}, -- Gelatinous
    {8,1536,175786,nil,6,25,3078}, -- Glurp

    -- mapID 1525: Revendreth
    {8,1525,173303,61879,4,25,2979}, -- Scorch (Ashes Will Fall)
    {8,1525,173315,61883,4,25,2989,2990,2991}, -- Sylla (Resilient Survivors)
    {8,1525,173324,61885,4,25,2992,2993,2994}, -- Eyegor (Eyegor's Special Friends)
    {8,1525,173331,61886,4,25,2996}, -- Addius the Tormentor (The Mind Games of Addius)
    {8,1525,175781,nil,6,25,3073}, -- Sewer Creeper
    {8,1525,175782,nil,6,25,3074}, -- The Countess

    -- mapID 1565: Ardenweald
    {8,1565,173372,61946,4,25,3000,3001,3002}, -- Glitterdust (Natural Defenders)
    {8,1565,173376,61947,4,25,2998}, -- Nightfang (Lurking In The Shadows)
    {8,1565,173377,61948,4,25,3003,3004,3005}, -- Faryl (Airborne Defense Force)
    {8,1565,173381,61949,4,25,2999}, -- Rascal (Ardenweald's Tricksters)
    {8,1565,175778,nil,6,25,3070}, -- Briarpaw
    {8,1565,175779,nil,6,25,3071}, -- Chittermaw
    {8,1565,175780,nil,6,25,3072}, -- Mistwing

    -- expansionID 7: Battle for Azeroth

    -- mapID 249: Uldum
    {7,249,162458,58742,4,25,2854}, -- Retinus the Seeker
    {7,249,162461,58744,4,25,2855}, -- Whispers
    {7,249,162465,58743,4,25,2856}, -- Aqir Sandcrawler
    {7,249,162466,58745,4,25,2857}, -- Blotto
    -- mapID 390: Vale of Eternal Blossom
    {7,390,162468,58746,4,25,2858}, -- K'tiny the Mad
    {7,390,162469,58747,4,25,2859}, -- Tormentius
    {7,390,162470,58748,4,25,2860}, -- Baruk Stone Defender
    {7,390,162471,58749,4,25,2861}, -- Vil'thik Hatchling
    -- mapID 1462: Mechagon Island
    {7,1462,154922,56393,4,25,2735}, -- Gnomefeaster
    {7,1462,154924,56395,4,25,2737}, -- Goldenbot XD
    {7,1462,154926,56397,4,25,2739}, -- CK-9 Micro-Oppression Unit
    {7,1462,154928,56399,4,25,2741}, -- Unit 6
    {7,1462,154923,56394,4,25,2736}, -- Sputtertube
    {7,1462,154925,56396,4,25,2738}, -- Creakclank
    {7,1462,154927,56398,4,25,2740}, -- Unit 35
    {7,1462,154929,56400,4,25,2742}, -- Unit 17
    -- mapID 1355: Nazjatar
    {7,1355,154910,56381,4,25,2723}, -- Prince Wiggletail
    {7,1355,154912,56383,4,25,2725}, -- Silence
    {7,1355,154914,56385,4,25,2727}, -- Pearlhusk Crawler
    {7,1355,154916,56387,4,25,2729}, -- Ravenous Scalespawn
    {7,1355,154918,56389,4,25,2731}, -- Kelpstone
    {7,1355,154920,56391,4,25,2733}, -- Frenzied Knifefang
    {7,1355,154911,56382,4,25,2724}, -- Chomp
    {7,1355,154913,56384,4,25,2726}, -- Shadowspike Lurker
    {7,1355,154915,56386,4,25,2728}, -- Elderspawn of Nalaada
    {7,1355,154917,56388,4,25,2730}, -- Mindshackle
    {7,1355,154919,56390,4,25,2732}, -- Voltgorger
    {7,1355,154921,56392,4,25,2734}, -- Giant Opaline Conch
    -- mapID 896: Drustvar
    {7,896,139489,52009,4,25,2193,2194,2195}, -- Captain Hermes
    {7,896,140461,52218,4,25,2209,2208,2206}, -- Dilbert McClint
    {7,896,140813,52278,4,25,2210,2211,2212}, -- Fizzie Sparkwhistle
    {7,896,140880,52297,4,25,2213,2214,2215}, -- Michael Skarn
    -- mapID 942: Stormsong Valley
    {7,942,139987,52126,4,25,2200}, -- Bristlespine
    {7,942,140315,52165,4,25,2205,2203,2204}, -- Eddie Fixit
    {7,942,141002,52316,4,25,2220,2221,2222}, -- Ellie Vern
    {7,942,141046,52325,4,25,2223,2225,2226}, -- Leana Darkwind
    -- mapID 895: Tiragarde Sound
    {7,895,141479,52751,4,25,2330,2332,2333}, -- Burly
    {7,895,141215,52455,4,25,2230}, -- Chitara
    {7,895,141292,52471,4,25,2233,2232,2231}, -- Delia Hanako
    {7,895,141077,52430,4,25,2229,2228,2227}, -- Kwint
    -- mapID 863: Nazmir
    {7,863,141588,52779,4,25,2157}, -- Bloodtusk
    {7,863,141799,52799,4,25,2338,2339,2340}, -- Grady Prett
    {7,863,141814,52803,4,25,2341,2343,2344}, -- Korval Darkbeard
    {7,863,141529,52754,4,25,2334,2335,2336}, -- Lozu
    -- mapID 864: Vol'dun
    {7,864,141879,52850,4,25,2345,2346,2347}, -- Keeyo
    {7,864,142054,52878,4,25,2359,2357,2358}, -- Kusa
    {7,864,141945,52856,4,25,2355,2354,2353}, -- Sizzik
    {7,864,141969,52864,4,25,2356}, -- Spineleaf
    -- mapID 862: Zuldazar
    {7,862,142151,52937,4,25,2367}, -- Jammer
    {7,862,142096,52892,4,25,2360,2361,2363}, -- Karaga
    {7,862,142114,52923,4,25,2364,2365,2366}, -- Talia Sparkbrow
    {7,862,142234,52938,4,25,2368,2370,2371}, -- Zujai

    -- expansionID 6: Legion

    -- mapID 13: Eastern Kingdom
    {6,13,124617,47895,4,25,2068,2067,2066}, -- Environeer Bert
    -- mapID 12: Kalimdor
    {6,12,115286,45083,4,25,1983,1981,1982}, -- Crysa
    -- mapID 113: Northrend
    {6,113,115307,44767,4,25,1971,1972,1973}, -- Algalon the Observer
    -- mapID 885: Antoran Wastes
    {6,885,128020,49054,4,25,2108}, -- Bloat
    {6,885,128021,49055,4,25,2109}, -- Earseeker
    {6,885,128023,49057,4,25,2111}, -- Minixis
    {6,885,128024,49058,4,25,2110}, -- One-of-Many
    {6,885,128022,49056,4,25,2112}, -- Pilfer
    {6,885,128019,49053,4,25,2107}, -- Watcher
    -- mapID 830: Krokuun
    {6,830,128009,49043,4,25,2092}, -- Baneglow
    {6,830,128011,49045,4,25,2099}, -- Deathscreech
    {6,830,128008,49042,4,25,2096}, -- Foulclaw
    {6,830,128012,49046,4,25,2100}, -- Gnasher
    {6,830,128010,49044,4,25,2098}, -- Retch
    {6,830,128007,49041,4,25,2095}, -- Ruinhoof
    -- mapID 882: Mac'Aree
    {6,882,128013,49047,4,25,2101}, -- Bucky
    {6,882,128017,49051,4,25,2105}, -- Corrupted Blood of Argus
    {6,882,128015,49049,4,25,2103}, -- Gloamwing
    {6,882,128018,49052,4,25,2106}, -- Mar'cuus
    {6,882,128016,49050,4,25,2104}, -- Shadeflicker
    {6,882,128014,49048,4,25,2102}, -- Snozz
    -- mapID 646: Broken Shore
    {6,646,117934,46111,4,25,2014,2015,2016}, -- Sissix
    {6,646,117950,46112,4,25,2011,2012,2013}, -- Madam Viciosa
    {6,646,117951,46113,4,25,2008,2009,2010}, -- Nameless Mystic
    -- mapID 630: Azsuna
    {6,630,105898,42063,4,25,1883}, -- Size Doesn't Matter (Blottis) quest 42063
    {6,630,97294,42165,3,25,1729}, -- Azsuna Specimens (Olivetail Hare) quest 42165
    {6,630,97283,42165,3,25,1728}, -- Azsuna Specimens (Juvenile Scuttleback) quest 42165
    {6,630,97323,42165,3,25,1731}, -- Azsuna Specimens (Felspider) quest 42165
    {6,630,106476,42146,4,25,1893,1894,1892}, -- Dazed and Confused and Adorable (Beguiling Orb) quest 42146
    {6,630,106552,42159,4,25,1897,1898,1899}, -- Training with the Nightwatchers (Nightwatcher Merayl) quest 42159
    {6,630,106417,42148,4,25,1891}, -- The Wine's Gone Bad (Vinu) quest 42148
    {6,630,106542,42154,4,25,1895,1896}, -- Help a Whelp (Wounded Azurewing Whelpling) quest 42154
    {6,630,98489,40310,4,25,1781,1780,1782}, -- Shipwrecked Captive quest 40310 (from Sternfathom's Pet Journal)
    -- mapID 41: Dalaran
    {6,41,107489,42442,4,25,1904,1905,1906}, -- Fight Night: Amalia quest 42442
    {6,41,99210,40299,4,25,1800,1801,1799}, -- Fight Night: Bodhi Sunwayver quest 40299
    {6,41,99742,41881,4,25,1815}, -- Fight Night: Heliosus quest 41881
    {6,41,99182,40298,4,25,1795,1797,1796}, -- Fight Night: Sir Galveston quest 40298
    {6,41,105241,41886,4,25,1855}, -- Fight Night: Rats! (Splint Jr.) quest 41886
    {6,41,105840,42062,4,25,1880}, -- Fight Night: Stitches Jr. Jr. quest 42062
    {6,41,97804,40277,4,25,1748,1746,1745}, -- Fight Night: Tiffany Nelson quest 40277
    -- mapID 650: Highmountain
    {6,650,99077,40280,4,25,1790,1791,1792}, -- Training with Bredda (Bredda Tenderhide) quest 40280
    {6,650,99150,40282,5,25,1798,1793,1794}, -- Tiny Poacher, Tiny Animals (Grixis Tinypop) quest 40282,
    {6,650,104782,41766,4,25,1843}, -- Wildlife Protection Force (Hungry Icefang) quest 41766
    {6,650,105841,42064,4,25,1881}, -- It's Illid... Wait (Lil'idan) quest 42064
    {6,650,104553,41687,4,25,1842,1841,1840}, -- Snail Fight (Odrogg) quest 41687
    {6,650,98572,41624,4,25,1811}, -- Rocko Needs a Shave (Rocko) quest 41624
    -- mapID 634: Stormheim
    {6,634,105842,42067,4,25,1882}, -- All Howl, No Bite (Chromadon) quest 42067,
    {6,634,105455,41944,4,25,1868,1869,1870}, -- Jarrun's Ladder (Trapper Jarrun) quest 41944
    {6,634,99878,41958,4,25,1816,1817,1818}, -- Oh, Ominitron (need npcID for Mini Magmatron) quest 41958,
    {6,634,98270,40278,4,25,1770,1772,1771}, -- My Beast's Bidding (Robert Craig) quest 40278
    {6,634,105512,41948,4,25,1871,1872}, -- All Pets Go to Heaven (Envoy of the Hunt) quest 41948
    {6,634,105387,41935,4,25,1867}, -- Beasts of Burden (Andurs) quest 41935
    {6,634,105386,41935,4,25,1866}, -- Beasts of Burden (Rydyr) quest 41935
    -- mapID 680: Suramar
    {6,680,105250,41895,4,25,1857,1858,1859}, -- The Master of Pets (Aulier) quest 41895
    {6,680,105323,41914,4,25,1860,1861,1862}, -- Clear the Catacombs (Ancient Catacomb Eggs) quest 41914
    {6,680,105674,41990,4,25,1873,1874,1875}, -- Chopped (Varenne) quest 41990
    {6,680,97709,40337,4,25,1742}, -- Flummoxed (Master Tamer Flummox) quest 40337
    {6,680,105779,42015,4,25,1877,1878,1879}, -- Threads of Fate (Felsoul Seer) quest 42015
    {6,680,105352,41931,4,25,1863,1864,1865}, -- Mana Tap (Surging Mana Crystal) quest 41931
    -- mapID 641: Val'sharah
    {6,641,99035,40279,4,25,1789,1787,1788}, -- Training with Durian (Durian Strongfruit) quest 40279
    {6,641,105093,41862,4,25,1851,1852,1853}, -- Only Pets can Prevent Forest Fires (Fragment of Fire) quest 41862
    {6,641,104992,41861,4,25,1849}, -- Meet The Maw (The Maw) quest 41861
    {6,641,105009,41855,4,25,1850}, -- Stand Up to Bullies (Thistleleaf Bully) quest 41855
    {6,641,97511,42190,4,25,1734}, -- Wildlife Conservationist (Shimmering Aquafly) quest 42190
    {6,641,97547,42190,4,25,1737}, -- Wildlife Conservationist (Vale Flitter) quest 42190
    {6,641,97559,42190,4,25,1739}, -- Wildlife Conservationist (Spring Strider) quest 42190
    {6,641,104970,41860,4,25,1847,1846,1848}, -- Dealing with Satyrs (Xorvasc) quest 41860

    -- expansionID 5: Warlords of Draenor

    -- mapID 534: Tanaan Jungle
    {5,534,94645,39168,6,25,1681}, -- Bleakclaw
    {5,534,94638,39161,6,25,1674}, -- Chaos Pup
    {5,534,94637,39160,6,25,1673}, -- Corrupted Thundertail
    {5,534,94639,39162,6,25,1675}, -- Cursed Spirit
    {5,534,94644,39167,6,25,1680}, -- Dark Gazer
    {5,534,94650,39173,6,25,1686}, -- Defiled Earth
    {5,534,94642,39165,6,25,1678}, -- Direflame
    {5,534,94647,39170,6,25,1683}, -- Dreadwalker
    {5,534,94640,39163,6,25,1676}, -- Felfly
    {5,534,94601,39157,6,25,1671}, -- Felsworn Sentry
    {5,534,94643,39166,6,25,1679}, -- Mirecroak
    {5,534,94648,39171,6,25,1684}, -- Netherfist
    {5,534,94649,39172,6,25,1685}, -- Skrillix
    {5,534,94641,39164,6,25,1677}, -- Tainted Mudclaw
    {5,534,94646,39169,6,25,1682}, -- Vile Blood of Draenor
    -- mapID 572: Draenor
    {5,572,87124,37203,4,25,1548,1547,1549}, -- Ashlei
    {5,572,83837,37201,6,25,1424,1443,1444}, -- Cymre Brightblade
    {5,572,87122,37205,4,25,1552,1553,1550}, -- Gargra
    {5,572,87125,37208,4,25,1562,1561,1560}, -- Taralune
    {5,572,87110,37206,4,25,1554,1555,1556}, -- Tarr the Terrible
    {5,572,87123,37207,4,25,1559,1557,1558}, -- Vesharr
    -- mapID "Garrison"
    {5,GARRISON_LOCATION_TOOLTIP,90675,38299,4,23,1640,1641,1642}, -- Erris the Collector of Pocket Lint (Spores, Dusty, and Salad)
    {5,GARRISON_LOCATION_TOOLTIP,91014,38299,4,23,1637,1643,1644}, -- Erris the Collector of Pocket Lint (Moon, Mouthy, and Carl)
    {5,GARRISON_LOCATION_TOOLTIP,91015,38299,4,23,1646,1645,1647}, -- Erris the Collector of Pocket Lint (Enbi'see, Mal, and Bones)
    {5,GARRISON_LOCATION_TOOLTIP,91016,38299,4,23,1648,1651,1649}, -- Erris the Collector of Pocket Lint (Sprouts, Prince Charming, and Runts)
    {5,GARRISON_LOCATION_TOOLTIP,91017,38299,4,23,1654,1653,1652}, -- Erris the Collector of Pocket Lint (Nicodemus, Brisby, and Jenner)
    {5,GARRISON_LOCATION_TOOLTIP,91026,38300,4,23,1640,1641,1642}, -- Kura Thunderhoof (Spores, Dusty, and Salad)
    {5,GARRISON_LOCATION_TOOLTIP,91361,38300,4,23,1637,1643,1644}, -- Kura Thunderhoof (Moon, Mouthy, and Carl)
    {5,GARRISON_LOCATION_TOOLTIP,91362,38300,4,23,1646,1645,1647}, -- Kura Thunderhoof (Enbi'see, Mal, and Bones)
    {5,GARRISON_LOCATION_TOOLTIP,91363,38300,4,23,1648,1651,1649}, -- Kura Thunderhoof (Sprouts, Prince Charming, and Runts)
    {5,GARRISON_LOCATION_TOOLTIP,91364,38300,4,23,1654,1653,1652}, -- Kura Thunderhoof (Nicodemus, Brisby, and Jenner)
    {5,GARRISON_LOCATION_TOOLTIP,85420,36423,4,25,1473}, -- Carrotus Maximus
    {5,GARRISON_LOCATION_TOOLTIP,85463,36423,4,25,1474}, -- Gorefu
    {5,GARRISON_LOCATION_TOOLTIP,85419,36423,4,25,1472}, -- Gnawface
    -- mapID "Menagerie"
    {5,L["Menagerie"],79751,37644,4,25,1409}, -- Eleanor
    {5,L["Menagerie"],85629,37644,4,25,1500,1499}, -- Challenge Post (Tirs, Fiero)
    {5,L["Menagerie"],85630,37644,4,25,1501,1502,1503}, -- Challenge Post (Rockbiter, Stonechewer, Acidtooth)
    {5,L["Menagerie"],85650,37644,4,25,1480}, -- Quintessence of Light
    {5,L["Menagerie"],85632,37644,4,25,1504,1505,1506}, -- Challenge Post (Blingtron 4999b, Protectron 022481, Protectron 011803)
    {5,L["Menagerie"],85685,37644,4,25,1507}, -- Stitches Jr.
    {5,L["Menagerie"],85634,37644,4,25,1508,1509,1510}, -- Challenge Post (Manos, Hanos, Fatos)
    {5,L["Menagerie"],79179,37644,4,25,1400,1401,1402}, -- Squirt (Deebs, Tyri, Puzzle)
    {5,L["Menagerie"],85622,37644,4,25,1479,1482}, -- Challenge Post (Brutus, Rukus)
    {5,L["Menagerie"],85517,37644,4,25,1483,1484,1485}, -- Challenge Post (Mr. Terrible, Carroteye, Sloppus)
    {5,L["Menagerie"],85659,37644,4,25,1486}, -- The Beakinator
    {5,L["Menagerie"],85624,37644,4,25,1488,1487}, -- Challenge Post (Queen Floret, King Floret)
    {5,L["Menagerie"],85625,37644,4,25,1489,1490}, -- Challenge Post (Kromli, Gromli)
    {5,L["Menagerie"],85626,37644,4,25,1492,1494,1493}, -- Challenge Post (Grubbles, Scrags, Stings)
    {5,L["Menagerie"],85627,37644,4,25,1496,1497,1498}, -- Challenge Post (Jahan, Samm, Archimedes)

    -- expansionID 4: Mists of Pandaria

    -- mapID 554: Timeless Isle
    {4,554,73626,33222,6,25,1339}, -- Little Tommy Newcomer
    -- mapID "Beasts of Fable"
    {4,L["Beasts of Fable"],68555,32604,6,25,1129}, -- Ka'wi the Gorger
    {4,L["Beasts of Fable"],68563,32604,6,25,1192}, -- Kafi
    {4,L["Beasts of Fable"],68564,32604,6,25,1193}, -- Dos-Ryga
    {4,L["Beasts of Fable"],68565,32604,6,25,1194}, -- Nitun
    {4,L["Beasts of Fable"],68560,32868,6,25,1189}, -- Greyhoof
    {4,L["Beasts of Fable"],68561,32868,6,25,1190}, -- Lucky Yi
    {4,L["Beasts of Fable"],68566,32868,6,25,1195}, -- Skitterer Xi'a
    {4,L["Beasts of Fable"],68558,32869,6,25,1187}, -- Gorespine
    {4,L["Beasts of Fable"],68559,32869,6,25,1188}, -- No-No
    {4,L["Beasts of Fable"],68562,32869,6,25,1191}, -- Ti'un the Wanderer
    -- mapID 424: Pandaria
    {4,424,66741,31958,6,25,1012,1011,1010}, -- Aki the Chosen
    {4,424,66738,31956,5,25,1001,1002,1003}, -- Courageous Yon
    {4,424,66734,31955,5,25,995,997,996}, -- Farmer Nishi
    {4,424,66730,31953,5,25,992,993,994}, -- Hyuna of the Shrines
    {4,424,66733,31954,5,25,1000,999,998}, -- Mo'ruk
    {4,424,66918,31991,5,25,1006,1005,1004}, -- Seeker Zusshi
    {4,424,66739,31957,5,25,1009,1007,1008}, -- Wastewalker Shu
    {4,424,68463,32434,6,25,1130,1131,1139}, -- Burning Pandaren Spirit
    {4,424,68462,32439,6,25,1132,1138,1133}, -- Flowing Pandaren Spirit
    {4,424,68465,32441,6,25,1137,1141,1134}, -- Thundering Pandaren Spirit
    {4,424,68464,32440,6,25,1135,1140,1136}, -- Whispering Pandaren Spirit

    -- expansionID 3: Cataclysm

    -- mapID 13: Eastern Kingdom
    {3,13,66822,31974,4,25,987,986,988}, -- Goz Banefury
    -- mapID 12: Kalimdor
    {3,12,66819,31972,4,25,982,980,981}, -- Brok
    {3,12,66824,31971,5,25,989,991,990}, -- Obalis
    -- mapID 276: Maelstrom
    {3,276,66815,31973,4,25,984,983,985}, -- Bordin Steadyfist

    -- expansionID 2: Wrath of the Lich King

    -- mapID 113: Northrend
    {2,113,66675,31935,4,25,978,977,979}, -- Major Payne
    {2,113,66635,31931,4,25,967,966,965}, -- Beegle Blastfuse
    {2,113,66639,31934,4,25,976,974,975}, -- Gutretch
    {2,113,66636,31932,4,25,968,970,969}, -- Nearly Headless Jacob
    {2,113,66638,31933,4,25,973,971,972}, -- Okrut Dragonwaste

    -- expansionID 1: Burning Crusade

    -- mapID 101: Outland
    {1,101,66557,31926,4,24,964,963,962}, -- Bloodknight Antari
    {1,101,66552,31924,3,22,957,958,956}, -- Narrok
    {1,101,66550,31922,3,20,952,951,950}, -- Nicki Tinytech
    {1,101,66553,31925,3,23,961,959,960}, -- Morulu The Elder
    {1,101,66551,31923,3,21,953,955,954}, -- Ras'an

    -- expansionID 0: Classic

    -- mapID 407: Darkmoon Island
    {0,407,67370,32175,5,25,1067,1065,1066}, -- Jeremy Feasel
    {0,407,85519,36471,6,25,1475,1476,1477}, -- Christoph VonFeasel
    -- mapID 13: Eastern Kingdom
    {0,13,66522,31916,3,19,948,949,947}, -- Lydia Accoste
    {0,13,65656,31851,3,11,887,886,888}, -- Bill Buckler
    {0,13,66478,31910,3,13,932,931,933}, -- David Kosse
    {0,13,66512,31911,3,14,935,936,934}, -- Deiza Plaguehorn
    {0,13,66520,31914,3,17,946,945,944}, -- Durin Darkhammer
    {0,13,65655,31850,2,7,881,880,882}, -- Eric Davidson
    {0,13,66518,31913,3,16,941,943,942}, -- Everessa
    {0,13,64330,31693,2,2,873,872}, -- Julia Stevens
    {0,13,66515,31912,3,15,939,937,938}, -- Kortas Darkhammer
    {0,13,65651,31781,2,5,878,877,879}, -- Lindsay
    {0,13,65648,31780,2,3,875,876,874}, -- Old MacDonald
    {0,13,63194,31852,2,9,885,884,883}, -- Steven Lisbane
    -- mapID 12: Kalimdor
    {0,12,66466,31909,3,19,928,927,929}, -- Stone Cold Trixxy
    {0,12,66136,31854,2,5,894,896,895}, -- Analynn
    {0,12,66422,31904,3,11,908,909,907}, -- Cassandra Kaboom
    {0,12,66135,31819,2,3,891,893,892}, -- Dagra the Fierce
    {0,12,66412,31908,3,17,924,925,926}, -- Elena Flutterfly
    {0,12,66436,31905,3,14,913,911,912}, -- Grazzle the Great
    {0,12,66452,31906,3,15,915,917,916}, -- Kela Grimtotem
    {0,12,66372,31872,2,9,901,902,900}, -- Merda Stronghoof
    {0,12,66352,31871,3,13,906,904,905}, -- Traitor Gluk
    {0,12,66442,31907,3,16,922,923,921}, -- Zoltan
    {0,12,66137,31862,2,7,897,899,898}, -- Zonya the Sadist
    {0,12,66126,31818,2,2,889,890}, -- Zunta
}

-- table of npcID's and the npcID they should actually refer to
-- GetUnitNameandID swaps these npcIDs for their redirected npcIDs, unless a team is already saved
rematch.targetRedirects = {
    [89129] = 85420, -- Carrotus Maximus at Frostwall -> Carrotus Maximus at Lunarfall
    [85463] = 89130, -- Gorefu Frostwall -> Gorefu at Lunarfall
    [85419] = 89131, -- Gnawface at Frostwall -> Gnawface at Lunarfall

    [99880] = 99878, -- Mini Magmatron golem -> Mini Magmatron console

    [105353] = 105352, -- Font of Mana -> Surging Mana Crystal
    [105356] = 105352, -- Seed of Mana -> Surging Mana Crystal
    [105355] = 105352, -- Essence of Mana -> Surging Mana Crystal

    [106535] = 106542, -- Hungry Rat -> Wounded Azurewing Whelpling
    [106525] = 106542, -- Hungry Owl -> Wounded Azurewing Whelpling

    [106422] = 106476, -- Subjugated Tadpole -> Beguiling Orb
    [106424] = 106476, -- Confused Tadpole -> Beguiling Orb
    [106423] = 106476, -- Allured Tadpole -> Beguiling Orb

    [105318] = 105323, -- Catacomb Spider -> Ancient Catacomb Eggs
    [105319] = 105323, -- Catacomb Bat -> Ancient Catacomb Eggs
    [105320] = 105323, -- Catacomb Snake -> Ancient Catacomb Eggs

    -- the following all redirect to their respective Challenge Post in the WoD Menagerie
    [85678] = 85629, -- Tirs
    [85677] = 85629, -- Fiero
    [85681] = 85630, -- Rockbiter
    [85680] = 85630, -- Stonechewer
    [85679] = 85630, -- Acidtooth
    [85682] = 85632, -- Blingtron 4999b
    [85683] = 85632, -- Protectron 022481
    [85684] = 85632, -- Protectron 011803
    [85686] = 85634, -- Manos
    [85687] = 85634, -- Hanos
    [85688] = 85634, -- Fatos
    [85561] = 85622, -- Brutus
    [85655] = 85622, -- Rukus
    [85656] = 85517, -- Mr. Terrible
    [85657] = 85517, -- Carroteye
    [85658] = 85517, -- Sloppus
    [85661] = 85624, -- Queen Floret
    [85660] = 85624, -- King Floret
    [85662] = 85625, -- Kromli
    [85663] = 85625, -- Gromli
    [85664] = 85626, -- Grubbles
    [85666] = 85626, -- Scrags
    [85665] = 85626, -- Stings
    [85674] = 85627, -- Jahan
    [85675] = 85627, -- Samm
    [85676] = 85627, -- Archimedes
}