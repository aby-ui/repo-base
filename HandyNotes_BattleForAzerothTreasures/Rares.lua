local myname, ns = ...

local merge = function(t1, t2)
    for k, v in pairs(t2) do
        t1[k] = v
    end
end

merge(ns.points[862], { -- Zuldazar
    [81202100] = {quest=50280, npc=129961, item=161042, achievement=12944, criteria=41850,}, -- Atal'zul Gotaka
    [64403240] = {quest=50439, npc=129954, item=161043, achievement=12944, criteria=41851,}, -- Gahz'ralka
    [44007660] = {quest=51083, npc=136428, item=160979, achievement=12944, criteria=41852,}, -- Dark Chronicler
    [53204480] = {quest=51080, npc=136413, item=161047, achievement=12944, criteria=41853,}, -- Syrawon the Dominus
    [48205400] = {quest=49972, npc=131476, item=161125, achievement=12944, criteria=41869,}, -- Zayoos
    [58807420] = {quest=49911, npc=131233, item=161033, achievement=12944, criteria=41870,}, -- Lei-zhi
    [49705740] = {quest=49410, npc=129343, item=161034, achievement=12944, criteria=41871,}, -- Avatar of Xolotal
    [59601820] = {quest=49267, npc=128699, item=161104, achievement=12944, criteria=41872,}, -- Bloodbulge
    [46606520] = {quest=49004, npc=127939, item=161029, achievement=12944, criteria=41873,}, -- Torraske the Eternal
    [68604820] = {quest=48543, npc=126637, item=160984, achievement=12944, criteria=41874,}, -- Kandak
    [59605640] = {quest=48333, npc=120899, item=160947, achievement=12944, criteria=41875,}, -- Kul'krazahn
    [74002820] = {quest=47792, npc=124185, item=161035, achievement=12944, criteria=41876,}, -- Golrakahn
    [70803240] = {quest=nil, npc=122004, item=161091, achievement=12944, criteria=41877,}, -- Umbra'jin
    [65201020] = {quest=50693, npc=134760, item=160958, achievement=12944, criteria=41855,}, -- Darkspeaker Jo'la
    [42003620] = {quest=50677, npc=134738, item=160978, achievement=12944, criteria=41856,}, -- Hakbi the Risen
    [62004620] = {quest=50508, npc=134048, item=162613, achievement=12944, criteria=41858,}, -- Vukuba
    [44002540] = {quest=50438, npc=133842, item=161040, achievement=12944, criteria=41859,}, -- Warcrawler Karkithiss
    [60606620] = {quest=50281, npc=134782, item=161022, achievement=12944, criteria=41863,}, -- Murderbeak
    [74003940] = {quest=50269, npc=133190, achievement=12944, criteria=41864,}, -- Daggerjaw
    [80003600] = {quest=50260, npc=133155, achievement=12944, criteria=41865,}, -- G'Naat
    [75603600] = {quest=50159, npc=132244, item=161112, achievement=12944, criteria=41866,}, -- Kiboku
    [66203240] = {quest=50034, npc=131718, item=161020, achievement=12944, criteria=41867,}, -- Bramblewing
    [77601120] = {quest=50013, npc=131687, item=161109, achievement=12944, criteria=41868,}, -- Tambano
})
merge(ns.points[863], { -- Nazmir
    [67812972] = {quest=48063, npc=125250, achievement=12942, criteria=41440,}, -- Ancient Jawbreaker
    [32802690] = {quest=50563, npc=134293, achievement=12942, criteria=41447,}, -- Azerite-Infused Slag
    [44224873] = {quest=49305, npc=128965, achievement=12942, criteria=41450,}, -- Uroku the Bound
    [68102023] = {quest=50567, npc=134296, achievement=12942, criteria=41452,}, -- Chag's Challenge
    [81813057] = {quest=48057, npc=125232, achievement=12942, criteria=41454,}, -- Cursed Chest
    [68955747] = {quest=50361, npc=121242, achievement=12942, criteria=41456,}, -- Glompmaw
    [56666932] = {quest=49312, npc=128974, achievement=12942, criteria=41458,}, -- Queen Tzxi'kik
    [45375197] = {quest=50307, npc=133373, achievement=12942, criteria=41460,}, -- Jax'teb the Reanimated
    [52931340] = {quest=47843, npc=124397, achievement=12942, criteria=41462,}, -- Kal'draxa
    [81696105] = {quest=50565, npc=134295, achievement=12942, criteria=41464,}, -- Lost Scroll
    [58963893] = {quest=48972, npc=127820, achievement=12942, criteria=41467,}, -- Scout Skrasniss
    [31443815] = {quest=48508, npc=126460, achievement=12942, criteria=41469,}, -- Tainted Guardian
    [38095768] = {quest=50888, npc=135565, achievement=12942, criteria=41472,}, -- Urn of Agussu
    [48985082] = {quest=48623, npc=126907, achievement=12942, criteria=41474,}, -- Wardrummer Zurula
    [38722674] = {quest=49469, npc=129657, achievement=12942, criteria=41476,}, -- Za'amar the Queen's Blade
    [78084451] = {quest=50355, npc=133539, achievement=12942, criteria=41478,}, -- Lo'kuno
    [54138091] = {quest=50569, npc=134298, achievement=12942, criteria=41444,}, -- Azerite-Infused Elemental
    [43069033] = {quest=48541, npc=126635, achievement=12942, criteria=41448,}, -- Blood Priest Xak'lar
    [53694287] = {quest=49317, npc=129005, achievement=12942, criteria=41451,}, -- King Kooba
    [41665344] = {quest=48462, npc=126187, achievement=12942, criteria=41453,}, -- Corpse Bringer Yal'kar
    [33538708] = {quest=48638, npc=127001, achievement=12942, criteria=41455,}, -- Gwugnug the Cursed
    [32344332] = {quest=49231, npc=128426, achievement=12942, criteria=41457,}, -- Gutrip
    [24967778] = {quest=47877, npc=124399, achievement=12942, criteria=41459,}, -- Infected Direhorn
    [28003408] = {quest=50342, npc=133527, achievement=12942, criteria=41461,}, -- Juba the Scarred
    [76033654] = {quest=48052, npc=125214, achievement=12942, criteria=41463,}, -- Krubbs
    [42805949] = {quest=48439, npc=126142, achievement=12942, criteria=41466,}, -- Bajiatha
    [58431014] = {quest=48980, npc=127873, achievement=12942, criteria=41468,}, -- Scrounger Patriarch
    [49453714] = {quest=48406, npc=126056, achievement=12942, criteria=41470,}, -- Totem Maker Jash'ga
    [29705107] = {quest=48626, npc=126926, achievement=12942, criteria=41473,}, -- Venomjaw
    [36555053] = {quest=50348, npc=133531, achievement=12942, criteria=41475,}, -- Xu'ba
    [38887148] = {quest=50423, npc=133812, achievement=12942, criteria=41477,}, -- Zanxib
    [52605489] = {quest=50040, npc=128930, achievement=12942, criteria=41479,}, -- Mala'kili and Rohnkor
})
merge(ns.points[864], { -- Vol'dun
    [50378160] = {quest=51105, npc=135852, achievement=12943, criteria=41606,}, -- Ak'tar
    [54661534] = {quest=51095, npc=130439, achievement=12943, criteria=41607,}, -- Ashmane
    [49048904] = {quest=51096, npc=128553, achievement=12943, criteria=41608,}, -- Azer'tor
    [31078111] = {quest=51117, npc=128497, achievement=12943, criteria=41609,}, -- Bajiani the Slick
    [49064989] = {quest=nil, npc=129476, achievement=12943, criteria=41610,}, -- Bloated Krolusk
    [56005346] = {quest=51118, npc=136393, achievement=12943, criteria=41611,}, -- Bloodwing Bonepicker
    [41412392] = {quest=51120, npc=136346, achievement=12943, criteria=41612,}, -- Captain Stef "Marrow" Quin
    [42549216] = {quest=51098, npc=124722, achievement=12943, criteria=41613,}, -- Commodore Calhoun
    [61433843] = {quest=51121, npc=136335, achievement=12943, criteria=41614,}, -- Enraged Krolusk
    [63984784] = {quest=51099, npc=128674, achievement=12943, criteria=41615,}, -- Gut-Gut the Glutton
    [53755340] = {quest=nil, npc=130443, achievement=12943, criteria=41616,}, -- Hivemother Kraxi
    [37688447] = {quest=nil, npc=129283, achievement=12943, criteria=41617,}, -- Jumbo Sandsnapper
    [60561756] = {quest=nil, npc=136341, achievement=12943, criteria=41618,}, -- Jungleweb Hunter
    [35205164] = {quest=nil, npc=128686, achievement=12943, criteria=41619,}, -- Kamid the Trapper
    [37964068] = {quest=nil, npc=137681, achievement=12943, criteria=41620,}, -- King Clickyclack
    [43768623] = {quest=nil, npc=128951, achievement=12943, criteria=41621,}, -- Nez'ara
    [49067187] = {quest=nil, npc=136340, achievement=12943, criteria=41622,}, -- Relic Hunter Hazaak
    [44408053] = {quest=51107, npc=127776, achievement=12943, criteria=41623,}, -- Scaleclaw Broodmother
    [32716522] = {quest=nil, npc=136336, achievement=12943, criteria=41624,}, -- Scorpox
    [24566843] = {quest=nil, npc=136338, achievement=12943, criteria=41625,}, -- Sirokar
    [47062556] = {quest=nil, npc=134571, achievement=12943, criteria=41626,}, -- Skycaller Teskris
    [51433620] = {quest=nil, npc=134745, achievement=12943, criteria=41627,}, -- Skycarver Krakit
    [66842511] = {quest=nil, npc=136304, achievement=12943, criteria=41628,}, -- Songstress Nahjeen
    [57217347] = {quest=nil, npc=130401, achievement=12943, criteria=41629,}, -- Vathikur
    [37094611] = {quest=nil, npc=129180, achievement=12943, criteria=41630,}, -- Warbringer Hozzik
    [30065261] = {quest=nil, npc=134638, achievement=12943, criteria=41631,}, -- Warlord Zothix
    [50703077] = {quest=nil, npc=134625, achievement=12943, criteria=41632,}, -- Warmother Captive
    [43905396] = {quest=nil, npc=129411, achievement=12943, criteria=41633,}, -- Zunashi the Exile
})
merge(ns.points[895], { -- Tiragarde Sound
    [75147848] = {quest=50156, npc=132182, achievement=12939, criteria=41793,}, -- Auditor Dolp
    [76218305] = {quest=50233, npc=129181, item=163717, achievement=12939, criteria=41795,}, -- Barman Bill
    [34013029] = {quest=50094, npc=132068, achievement=12939, criteria=41796,}, -- Bashmu
    [56676994] = {quest=50096, npc=132086, item=163718, achievement=12939, criteria=41797,}, -- Black-Eyed Bart
    [84707385] = {quest=51808, npc=139145, item=154411, achievement=12939, criteria=41798, note="Hillside above the cave",}, -- Blackthorne
    [83364413] = {quest=49999, npc=130508, achievement=12939, criteria=41800,}, -- Broodmother Razora
    [38422066] = {quest=50097, npc=132088, achievement=12939, criteria=41806,}, -- Captain Wintersail
    [72838146] = {quest=51809, npc=139152, achievement=12939, criteria=41812,}, -- Carla Smirk
    [89787815] = {quest=50155, npc=132211, achievement=12939, criteria=41813,}, -- Fowlmouth
    [59982275] = {quest=50137, npc=132127, achievement=12939, criteria=41814,}, -- Foxhollow Skyterror
    [57725613] = {quest=53373, npc=139233, achievement=12939, criteria=41819,}, -- Gulliver
    [48072334] = {quest=49984, npc=131520, achievement=12939, criteria=41820,}, -- Kulett the Ornery
    [68352088] = {quest=50525, npc=134106, item=155524, achievement=12939, criteria=41821,}, -- Lumbergrasp Sentinel
    [58094870] = {quest=51880, npc=139290, item=154458, achievement=12939, criteria=41822,}, -- Maison the Portable
    [64291931] = {quest=51321, npc=137183, item=160472, achievement=12939, criteria=41823,}, -- Imperiled Merchants (Honey-Coated Slitherer)
    [43801771] = {quest=49921, npc=131252, achievement=12939, criteria=41824,}, -- Merianae
    [65176460] = {quest=51833, npc=139205, achievement=12939, criteria=41825,}, -- P4-N73R4
    [39461517] = {quest=49923, npc=131262, item=160263, achievement=12939, criteria=41826,}, -- Pack Leader Asenya
    [64805893] = {quest=50148, npc=132179, item=161446, achievement=12939, criteria=41827,}, -- Raging Swell
    [68336362] = {quest=51872, npc=139278, achievement=12939, criteria=41828,}, -- Ranja
    [58541513] = {quest=48806, npc=127290, item=154416, achievement=12939, criteria=41829,}, -- Saurolisk Tamer Mugg (Mugg)
    [76022887] = {quest=51877, npc=139287, achievement=12939, criteria=41830,}, -- Sawtooth
    [55703318] = {quest=51876, npc=139285, achievement=12939, criteria=41831,}, -- Shiverscale the Toxic
    [80838277] = {quest=50160, npc=132280, achievement=12939, criteria=41832,}, -- Squacks
    [49353613] = {quest=51807, npc=139135, achievement=12939, criteria=41833,}, -- Squirgle of the Depths
    [66701427] = {quest=51873, npc=139280, achievement=12939, criteria=41834,}, -- Sythian the Swift
    [60801727] = {quest=50301, npc=133356, achievement=12939, criteria=41835,}, -- Tempestria
    [55095056] = {quest=51879, npc=139289, achievement=12939, criteria=41836,}, -- Tentulos the Drifter
    [63735039] = {quest=49942, npc=131389, item=158556, achievement=12939, criteria=41837,}, -- Teres
    [70035567] = {quest=51835, npc=139235, achievement=12939, criteria=41838,}, -- Tort Jaw
    [46391997] = {quest=50095, npc=132076, item=160452, achievement=12939, criteria=41839,}, -- Totes
    [70271283] = {quest=50073, npc=131984, item=160473, achievement=12939, criteria=41840,}, -- Twin-hearted Construct
    [52253215] = {quest=nil, npc=132052, item=155074,}, -- Vol'Jim
    [61515233] = {quest=49963, npc=130350, item=155571, note="Ride to Roan Berthold in Southwind Station; follow the road",}, -- Guardian of the Spring (49983 is the ride, 49963 is the loot)
})
merge(ns.points[1161], { -- Boralus
    [80403500] = {quest=51877, npc=139287, achievement=12939, criteria=41830,}, -- Sawtooth
})

merge(ns.points[896], { -- Drustvar
    [59933466] = {quest=47884, npc=124548, achievement=12941, criteria=41706,}, -- Betsy
    [58901790] = {quest=48842, npc=127333, achievement=12941, criteria=41708,}, -- Barbthorn Queen
    [66585068] = {quest=48978, npc=126621, achievement=12941, criteria=41711,}, -- Bonesquall
    [59245526] = {quest=48981, npc=127877, achievement=12941, criteria=41713, note="Pick one to fight; Dagger from Longfang, mail gloves from Henry",}, -- Longfang & Henry Breakwater
    [52074697] = {quest=49216, npc=129904, achievement=12941, criteria=41715,}, -- Cottontail Matron
    [65002266] = {quest=49311, npc=128973, achievement=12941, criteria=41718,}, -- Whargarble the Ill-Tempered
    [50842040] = {quest=49388, npc=127129, achievement=12941, criteria=41720,}, -- Grozgore
    [51352957] = {quest=49481, npc=129805, achievement=12941, criteria=41722,}, -- Beshol
    [63414020] = {quest=49530, npc=129995, achievement=12941, criteria=41724,}, -- Emily Mayville
    [56572924] = {quest=49602, npc=130143, achievement=12941, criteria=41726,}, -- Balethorn
    [31011831] = {quest=50546, npc=134213, achievement=12941, criteria=41728,}, -- Executioner Blackwell
    [22934796] = {quest=50688, npc=134754, achievement=12941, criteria=41729,}, -- Hyo'gi
    [34966921] = {quest=51383, npc=137529, achievement=12941, criteria=41732,}, -- Arvon the Betrayed
    [43808828] = {quest=51471, npc=137825, achievement=12941, criteria=41736,}, -- Avalanche
    [29202488] = {quest=51700, npc=138675, achievement=12941, criteria=41742,}, -- Gorged Boar
    [24242193] = {quest=51749, npc=138866, item=154217, achievement=12941, criteria=41748,}, -- Fungi Trio (quest 51887 also?)
    [30476344] = {quest=51923, npc=139322, item=154315, achievement=12941, criteria=41751,}, -- Whitney "Steelclaw" Ramsay
    [66574259] = {quest=48178, npc=125453, item=158583, achievement=12941, criteria=41707,}, -- Quillrat Matriarch
    [72786036] = {quest=48928, npc=127651, achievement=12941, criteria=41709,}, -- Vicemaul
    [62956938] = {quest=48979, npc=127844, achievement=12941, criteria=41712,}, -- Gluttonous Yeti
    [43463611] = {quest=49137, achievement=12941, criteria=41714,}, -- Ancient Sarcophagus
    [59557181] = {quest=49269, npc=128707, achievement=12941, criteria=41717,}, -- Rimestone
    [67936683] = {quest=49341, item=158598, achievement=12941, criteria=41719,}, -- Seething Cache
    [57424380] = {quest=49480, npc=129835, achievement=12941, criteria=41721,}, -- Gorehorn
    [32204036] = {quest=49528, npc=129950, achievement=12941, criteria=41723,}, -- Talon
    [59874478] = {quest=49601, npc=130138, achievement=12941, criteria=41725,}, -- Nevermore
    [35483290] = {quest=50163, npc=132319, achievement=12941, criteria=41727,}, -- Bilefang Mother
    [18746057] = {quest=50669, npc=134706, achievement=12941, criteria=42342,}, -- Deathcap
    [28051425] = {quest=50939, npc=135796, achievement=12941, criteria=41730,}, -- Captain Leadfist
    [29056863] = {quest=51470, npc=137824, achievement=12941, criteria=41733,}, -- Arclight
    [23422975] = {quest=51698, npc=138618, achievement=12941, criteria=41739,}, -- Haywire Golem
    [33245765] = {quest=51748, npc=138863, achievement=12941, criteria=41745,}, -- Sister Martha
    [26935962] = {quest=51922, npc=139321, achievement=12941, criteria=41750,}, -- Braedan Whitewall
    -- [20295731] = {quest=nil, npc=137665,}, -- Soul Goliath
    -- [35711177] = {quest=nil, npc=138667,}, -- Blighted Monstrosity
    -- [25151616] = {quest=nil, npc=139358,}, -- The Caterer
    -- [34722062] = {quest=nil, npc=137704,}, -- Matron Morana
})
merge(ns.points[942], { -- Stormsong Valley
    [71003200] = {quest=52448, npc=141175, item=158218, achievement=12940, criteria=41753,}, -- Song Mistress Dadalea
    [22607300] = {quest=50938, npc=140997, achievement=12940, criteria=41754,}, -- Severus the Outcast
    [33603800] = {quest=51757, npc=138938, item=160477, achievement=12940, criteria=41755,}, -- Seabreaker Skoloth
    [34203240] = {quest=51956, npc=139328, item=154664, achievement=12940, criteria=41756,}, -- Sabertron
    [51807960] = {quest=50974, npc=136189, item=155222, achievement=12940, criteria=41757,}, -- The Lichen King
    [41607360] = {quest=50725, npc=134884, item=160465, achievement=12940, criteria=41758,}, -- Ragna
    [41302920] = {quest=51958, npc=139319, item=158216, achievement=12940, criteria=41759,}, -- Slickspill
    [29206960] = {quest=51298, npc=137025, item=160470, achievement=12940, criteria=41760,}, -- Broodmother
    [71305430] = {quest=50075, npc=132007, item=155568, achievement=12940, criteria=41761,}, -- Galestorm
    [47004220] = {quest=52457, npc=142088, item=158215, achievement=12940, criteria=41762,}, -- Whirlwing
    [31406260] = {quest=52318, npc=141029, item=154475, achievement=12940, criteria=41763,}, -- Kickers
    [64406560] = {quest=49951, npc=131404, item=160471, achievement=12940, criteria=41765,}, -- Foreman Scripps
    [34406760] = {quest=52469, npc=141286, achievement=12940, criteria=41769,}, -- Poacher Zane
    [37905040] = {quest=51959, npc=139298, item=163678, achievement=12940, criteria=41772,}, -- Pinku'shon
    [62007340] = {quest=52329, npc=141059, item=155572, achievement=12940, criteria=41774,}, -- Grimscowl the Harebrained
    [53005200] = {quest=50692, npc=139385, item=160464, achievement=12940, criteria=41775,}, -- Deepfang
    [63003300] = {quest=52303, npc=140938, item=154460, achievement=12940, criteria=41776,}, -- Croaker
    [66905200] = {quest=52121, npc=139968, item=154183, achievement=12940, criteria=41777,}, -- Corrupted Tideskipper
    [51405540] = {quest=50731, npc=136183, item=154857, achievement=12940, criteria=nil,}, -- Crushtacean (shares q:50731 c:41778 with Dagrus)
    [67804000] = {quest=50731, npc=134897, item=160476, achievement=12940, criteria=nil,}, -- Dagrus the Scorned (shares q:50731 c:41778 with Crushtacean)
    [49807000] = {quest=50037, npc=135939, item=158299, achievement=12940, criteria=41782,}, -- Vinespeaker Ratha
    [53106910] = {quest=50024, npc=135947, achievement=12940, criteria=41787,}, -- Strange Mushroom Ring
    [33607500] = {quest=52460, npc=141226, achievement=12940, criteria=41815,}, -- Haegol the Hammer
    [57007580] = {quest=52433, npc=141088, item=158224, achievement=12940, criteria=41816,}, -- Squall
    [63408320] = {quest=52327, npc=141039, achievement=12940, criteria=41817,}, -- Ice Sickle
    [47206580] = {quest=50170, npc=130897, item=155287, achievement=12940, criteria=41818,}, -- Captain Razorspine
    [47306590] = {quest=52296, npc=129803, achievement=12940, criteria=41841,}, -- Whiplash
    [61605700] = {quest=52441, npc=141143, item=155164, achievement=12940, criteria=41842,}, -- Sister Absinthe
    [42807500] = {quest=50819, npc=130079, item=154431, achievement=12940, criteria=41843,}, -- Wagga Snarltusk
    [43404490] = {quest=51762, npc=138963, item=160477, achievement=12940, criteria=41844,}, -- Nestmother Acada
    [42006280] = {quest=52461, npc=141239, item=159169, achievement=12940, criteria=41845,}, -- Osca the Bloodied
    [73806080] = {quest=52125, npc=139988, achievement=12940, criteria=41846,}, -- Sandfang
    [60004600] = {quest=52123, npc=139980, item=154449, achievement=12940, criteria=41847,}, -- Taja the Tidehowler
    [53406450] = {quest=52324, npc=141043, item=159179, achievement=12940, criteria=nil,}, -- Jakala the Cruel
    -- [72545052] = {quest=nil, npc=139515,}, -- Sandscour
    -- [68745147] = {quest=nil, npc=132047,}, -- Reinforced Hullbreaker
    -- [40143732] = {quest=nil, npc=137649,}, -- Pest Remover Mk. II
    -- [67217525] = {quest=nil, npc=134147,}, -- Beehemoth
})
