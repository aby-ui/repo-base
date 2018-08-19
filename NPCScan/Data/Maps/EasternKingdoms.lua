-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Maps = private.Data.Maps
local MapID = private.Enum.MapID

-- ----------------------------------------------------------------------------
-- Arathi Highlands
-- ----------------------------------------------------------------------------
Maps[MapID.ArathiHighlands].NPCs = {
    [2598] = true, -- Darbel Montrose
    [2600] = true, -- Singer
    [2601] = true, -- Foulbelly
    [2602] = true, -- Ruul Onestone
    [2603] = true, -- Kovork
    [2604] = true, -- Molok the Crusher
    [2605] = true, -- Zalas Witherbark
    [2606] = true, -- Nimar the Slayer
    [2609] = true, -- Geomancer Flintdagger
    [2779] = true, -- Prince Nazjak
    [50337] = true, -- Cackle
    [50770] = true, -- Zorn
    [50804] = true, -- Ripwing
    [50865] = true, -- Saurix
    [50891] = true, -- Boros
    [50940] = true, -- Swee
    [51040] = true, -- Snuffles
    [51063] = true, -- Phalanax
    [51067] = true -- Glint
}

-- ----------------------------------------------------------------------------
-- Badlands
-- ----------------------------------------------------------------------------
Maps[MapID.Badlands].NPCs = {
    [2744] = true, -- Shadowforge Commander
    [2749] = true, -- Barricade
    [2751] = true, -- War Golem
    [2752] = true, -- Rumbler
    [2753] = true, -- Barnabus
    [2754] = true, -- Anathemus
    [2850] = true, -- Broken Tooth
    [2931] = true, -- Zaricotl
    [14224] = true, -- 7:XT
    [50726] = true, -- Kalixx
    [50728] = true, -- Deathstrike
    [50731] = true, -- Needlefang
    [50838] = true, -- Tabbs
    [51000] = true, -- Blackshell the Impenetrable
    [51007] = true, -- Serkett
    [51018] = true, -- Zormus
    [51021] = true -- Vorticus
}

-- ----------------------------------------------------------------------------
-- Blasted Lands
-- ----------------------------------------------------------------------------
Maps[MapID.BlastedLands].NPCs = {
    [7846] = true, -- Teremus the Devourer
    [8296] = true, -- Mojo the Twisted
    [8297] = true, -- Magronos the Unyielding
    [8298] = true, -- Akubar the Seer
    [8299] = true, -- Spiteflayer
    [8300] = true, -- Ravage
    [8301] = true, -- Clack the Reaver
    [8302] = true, -- Deatheye
    [8303] = true, -- Grunter
    [8304] = true, -- Dreadscorn
    [45257] = true, -- Mordak Nightbender
    [45258] = true, -- Cassia the Slitherqueen
    [45260] = true, -- Blackleaf
    [45262] = true -- Narixxus the Doombringer
}

-- ----------------------------------------------------------------------------
-- Tirisfal Glades
-- ----------------------------------------------------------------------------
Maps[MapID.TirisfalGlades].NPCs = {
    [1531] = true, -- Lost Soul
    [1533] = true, -- Tormented Spirit
    [1910] = true, -- Muad
    [1911] = true, -- Deeb
    [1936] = true, -- Farmer Solliden
    [10356] = true, -- Bayne
    [10357] = true, -- Ressan the Needler
    [10358] = true, -- Fellicent's Shade
    [10359] = true, -- Sri'skulk
    [50763] = true, -- Shadowstalker
    [50803] = true, -- Bonechewer
    [50908] = true, -- Nighthowl
    [50930] = true, -- Hibernus the Sleeper
    [51044] = true -- Plague
}

-- ----------------------------------------------------------------------------
-- Silverpine Forest
-- ----------------------------------------------------------------------------
Maps[MapID.SilverpineForest].NPCs = {
    [12431] = true, -- Gorefang
    [12433] = true, -- Krethis the Shadowspinner
    [46981] = true, -- Nightlash
    [46992] = true, -- Berard the Moon-Crazed
    [47003] = true, -- Bolgaff
    [47008] = true, -- Fenwick Thatros
    [47009] = true, -- Aquarius the Unbound
    [47012] = true, -- Effritus
    [47015] = true, -- Lost Son of Arugal
    [47023] = true, -- Thule Ravenclaw
    [50330] = true, -- Kree
    [50814] = true, -- Corpsefeeder
    [50949] = true, -- Finn's Gambit
    [51026] = true, -- Gnath
    [51037] = true -- Lost Gilnean Wardog
}

-- ----------------------------------------------------------------------------
-- Western Plaguelands
-- ----------------------------------------------------------------------------
Maps[MapID.WesternPlaguelands].NPCs = {
    [1837] = true, -- Scarlet Judge
    [1838] = true, -- Scarlet Interrogator
    [1839] = true, -- Scarlet High Clerist
    [1841] = true, -- Scarlet Executioner
    [1847] = true, -- Foulmane
    [1848] = true, -- Lord Maldazzar
    [1849] = true, -- Dreadwhisper
    [1850] = true, -- Putridius
    [1851] = true, -- The Husk
    [1885] = true, -- Scarlet Smith
    [50345] = true, -- Alit
    [50778] = true, -- Ironweb
    [50809] = true, -- Heress
    [50906] = true, -- Mutilax
    [50922] = true, -- Warg
    [50931] = true, -- Mange
    [50937] = true, -- Hamhide
    [51029] = true, -- Parasitus
    [51031] = true, -- Tracker
    [51058] = true, -- Aphis
    [111122] = true -- Large Vile Slime
}

-- ----------------------------------------------------------------------------
-- Eastern Plaguelands
-- ----------------------------------------------------------------------------
Maps[MapID.EasternPlaguelands].NPCs = {
    [1843] = true, -- Foreman Jerris
    [1844] = true, -- Foreman Marcrid
    [10817] = true, -- Duggan Wildhammer
    [10818] = true, -- Death Knight Soulbearer
    [10819] = true, -- Baron Bloodbane
    [10820] = true, -- Duke Ragereaver
    [10821] = true, -- Hed'mush the Rotting
    [10823] = true, -- Zul'Brin Warpbranch
    [10824] = true, -- Death-Hunter Hawkspear
    [10825] = true, -- Gish the Unmoving
    [10826] = true, -- Lord Darkscythe
    [10827] = true, -- Deathspeaker Selendre
    [10828] = true, -- Lynnia Abbendis
    [16184] = true, -- Nerubian Overseer
    [50775] = true, -- Likk the Hunter
    [50779] = true, -- Sporeggon
    [50813] = true, -- Fene-mal
    [50856] = true, -- Snark
    [50915] = true, -- Snort
    [50947] = true, -- Varah
    [51027] = true, -- Spirocula
    [51042] = true, -- Bleakheart
    [51053] = true -- Quirix
}

-- ----------------------------------------------------------------------------
-- Hillsbrad Foothills
-- ----------------------------------------------------------------------------
Maps[MapID.HillsbradFoothills].NPCs = {
    [2258] = true, -- Maggarrak
    [2452] = true, -- Skhowl
    [2453] = true, -- Lo'Grosh
    [14221] = true, -- Gravis Slipknot
    [14222] = true, -- Araga
    [14223] = true, -- Cranky Benj
    [14275] = true, -- Tamra Stormpike
    [14276] = true, -- Scargil
    [14277] = true, -- Lady Zephris
    [14278] = true, -- Ro'Bark
    [14279] = true, -- Creepthess
    [14280] = true, -- Big Samras
    [14281] = true, -- Jimmy the Bleeder
    [47010] = true, -- Indigos
    [50335] = true, -- Alitus
    [50765] = true, -- Miasmiss
    [50770] = true, -- Zorn
    [50818] = true, -- The Dark Prowler
    [50858] = true, -- Dustwing
    [50929] = true, -- Little Bjorn
    [50955] = true, -- Carcinak
    [50967] = true, -- Craw the Ravager
    [51022] = true, -- Chordix
    [51057] = true, -- Weevil
    [51076] = true -- Lopex
}

-- ----------------------------------------------------------------------------
-- The Hinterlands
-- ----------------------------------------------------------------------------
Maps[MapID.TheHinterlands].NPCs = {
    [8210] = true, -- Razortalon
    [8211] = true, -- Old Cliff Jumper
    [8212] = true, -- The Reak
    [8213] = true, -- Ironback
    [8214] = true, -- Jalinde Summerdrake
    [8215] = true, -- Grimungous
    [8216] = true, -- Retherokk the Berserker
    [8217] = true, -- Mith'rethis the Enchanter
    [8218] = true, -- Witherheart the Stalker
    [8219] = true, -- Zul'arek Hatefowler
    [107617] = true -- Ol' Muddle
}

-- ----------------------------------------------------------------------------
-- Dun Morogh
-- ----------------------------------------------------------------------------
Maps[MapID.DunMorogh].NPCs = {
    [1119] = true, -- Hammerspine
    [1130] = true, -- Bjarn
    [1137] = true, -- Edan the Howler
    [1260] = true -- Great Father Arctikus
}

-- ----------------------------------------------------------------------------
-- Searing Gorge
-- ----------------------------------------------------------------------------
Maps[MapID.SearingGorge].NPCs = {
    [8277] = true, -- Rekk'tilac
    [8278] = true, -- Smoldar
    [8279] = true, -- Faulty War Golem
    [8280] = true, -- Shleipnarr
    [8281] = true, -- Scald
    [8282] = true, -- Highlord Mastrogonde
    [8283] = true, -- Slave Master Blackheart
    [8924] = true, -- The Behemoth
    [50846] = true, -- Slavermaw
    [50876] = true, -- Avis
    [50946] = true, -- Hogzilla
    [50948] = true, -- Crystalback
    [51002] = true, -- Scorpoxx
    [51010] = true, -- Snips
    [51048] = true, -- Rexxus
    [51066] = true -- Crystalfang
}

-- ----------------------------------------------------------------------------
-- Burning Steppes
-- ----------------------------------------------------------------------------
Maps[MapID.BurningSteppes].NPCs = {
    [8924] = true, -- The Behemoth
    [8976] = true, -- Hematos
    [8978] = true, -- Thauris Balgarr
    [8979] = true, -- Gruklash
    [8981] = true, -- Malfunctioning Reaver
    [9602] = true, -- Hahk'Zor
    [9604] = true, -- Gorgon'och
    [10077] = true, -- Deathmaw
    [10078] = true, -- Terrorspark
    [10119] = true, -- Volchan
    [50357] = true, -- Sunwing
    [50361] = true, -- Ornat
    [50725] = true, -- Azelisk
    [50730] = true, -- Venomspine
    [50792] = true, -- Chiaa
    [50807] = true, -- Catal
    [50810] = true, -- Favored of Isiset
    [50839] = true, -- Chromehound
    [50842] = true, -- Magmagan
    [50855] = true, -- Jaxx the Rabid
    [51066] = true -- Crystalfang
}

-- ----------------------------------------------------------------------------
-- Elwynn Forest
-- ----------------------------------------------------------------------------
Maps[MapID.ElwynnForest].NPCs = {
    [61] = true, -- Thuros Lightfingers
    [62] = true, -- Gug Fatcandle
    [79] = true, -- Narg the Taskmaster
    [99] = true, -- Morgaine the Sly
    [100] = true, -- Gruff Swiftbite
    [471] = true, -- Mother Fang
    [472] = true, -- Fedfennel
    [50752] = true, -- Tarantis
    [50916] = true, -- Lamepaw the Whimperer
    [50926] = true, -- Grizzled Ben
    [50942] = true, -- Snoot the Rooter
    [51014] = true, -- Terrapis
    [51077] = true -- Bushtail
}

-- ----------------------------------------------------------------------------
-- Duskwood
-- ----------------------------------------------------------------------------
Maps[MapID.Duskwood].NPCs = {
    [507] = true, -- Fenros
    [521] = true, -- Lupos
    [534] = true, -- Nefaru
    [574] = true, -- Naraxis
    [45739] = true, -- The Unknown Soldier
    [45740] = true, -- Watcher Eva
    [45771] = true, -- Marus
    [45785] = true, -- Carved One
    [45801] = true, -- Eliza
    [45811] = true, -- Marina DeSirrus
    [118244] = true -- Lightning Paw
}

-- ----------------------------------------------------------------------------
-- Loch Modan
-- ----------------------------------------------------------------------------
Maps[MapID.LochModan].NPCs = {
    [1398] = true, -- Boss Galgosh
    [1399] = true, -- Magosh
    [1425] = true, -- Kubb
    [2476] = true, -- Gosh-Haldir
    [14266] = true, -- Shanda the Spinner
    [14267] = true, -- Emogg the Crusher
    [14268] = true, -- Lord Condar
    [45369] = true, -- Morick Darkbrew
    [45380] = true, -- Ashtail
    [45384] = true, -- Sagepaw
    [45398] = true, -- Grizlak
    [45399] = true, -- Optimo
    [45401] = true, -- Whitefin
    [45402] = true, -- Nix
    [45404] = true -- Geoshaper Maren
}

-- ----------------------------------------------------------------------------
-- Redridge Mountains
-- ----------------------------------------------------------------------------
Maps[MapID.RedridgeMountains].NPCs = {
    [584] = true, -- Kazon
    [616] = true, -- Chatter
    [947] = true, -- Rohh the Silent
    [14269] = true, -- Seeker Aqualon
    [14270] = true, -- Squiddic
    [14271] = true, -- Ribchaser
    [14272] = true, -- Snarlflare
    [14273] = true, -- Boulderheart
    [52146] = true -- Chitter
}

-- ----------------------------------------------------------------------------
-- Northern Stranglethorn
-- ----------------------------------------------------------------------------
Maps[MapID.NorthernStranglethorn].NPCs = {
    [11383] = true, -- High Priestess Hai'watna
    [14487] = true, -- Gluggl
    [14488] = true, -- Roloch
    [51658] = true, -- Mogh the Dead
    [51661] = true, -- Tsul'Kalu
    [51662] = true, -- Mahamba
    [51663] = true -- Pogeyan
}

-- ----------------------------------------------------------------------------
-- Swamp of Sorrows
-- ----------------------------------------------------------------------------
Maps[MapID.SwampOfSorrows].NPCs = {
    [763] = true, -- Lost One Chieftain
    [1063] = true, -- Jade
    [1106] = true, -- Lost One Cook
    [5348] = true, -- Dreamwatcher Forktongue
    [14445] = true, -- Captain Wyrmak
    [14446] = true, -- Fingat
    [14447] = true, -- Gilmorian
    [14448] = true, -- Molt Thorn
    [50738] = true, -- Shimmerscale
    [50790] = true, -- Ionis
    [50797] = true, -- Yukiko
    [50837] = true, -- Kash
    [50882] = true, -- Chupacabros
    [50886] = true, -- Seawing
    [50903] = true, -- Orlix the Swamplord
    [51052] = true -- Gib the Banana-Hoarder
}

-- ----------------------------------------------------------------------------
-- Westfall
-- ----------------------------------------------------------------------------
Maps[MapID.Westfall].NPCs = {
    [462] = true, -- Vultros
    [506] = true, -- Sergeant Brashclaw
    [519] = true, -- Slark
    [520] = true, -- Brack
    [572] = true, -- Leprithus
    [573] = true, -- Foe Reaper 4000
    [596] = true, -- Brainwashed Noble
    [599] = true, -- Marisa du'Paige
    [1424] = true -- Master Digger
}

-- ----------------------------------------------------------------------------
-- Wetlands
-- ----------------------------------------------------------------------------
Maps[MapID.Wetlands].NPCs = {
    [1112] = true, -- Leech Widow
    [1140] = true, -- Razormaw Matriarch
    [2090] = true, -- Ma'ruk Wyrmscale
    [2108] = true, -- Garneg Charskull
    [14424] = true, -- Mirelow
    [14425] = true, -- Gnawbone
    [14433] = true, -- Sludginn
    [44224] = true, -- Two-Toes
    [44225] = true, -- Rufus Darkshot
    [44226] = true, -- Sarltooth
    [44227] = true, -- Gazz the Loch-Hunter
    [50964] = true -- Chops
}

-- ----------------------------------------------------------------------------
-- Stormwind City
-- ----------------------------------------------------------------------------
Maps[MapID.StormwindCity].NPCs = {
    [3581] = true -- Sewer Beast
}

-- ----------------------------------------------------------------------------
-- Eversong Woods
-- ----------------------------------------------------------------------------
Maps[MapID.EversongWoods].NPCs = {
    [16854] = true, -- Eldinarcus
    [16855] = true -- Tregla
}

-- ----------------------------------------------------------------------------
-- Ghostlands
-- ----------------------------------------------------------------------------
Maps[MapID.Ghostlands].NPCs = {
    [22062] = true -- Dr. Whitherlimb
}

-- ----------------------------------------------------------------------------
-- Kelp'thar Forest
-- ----------------------------------------------------------------------------
Maps[MapID.KelptharForest].NPCs = {
    [49913] = true -- Lady La-La
}

-- ----------------------------------------------------------------------------
-- Vashj'ir
-- ----------------------------------------------------------------------------
Maps[MapID.Vashjir].NPCs = {
    [51079] = true -- Captain Foulwind
}

-- ----------------------------------------------------------------------------
-- Abyssal Depths
-- ----------------------------------------------------------------------------
Maps[MapID.AbyssalDepths].NPCs = {
    [50005] = true, -- Poseidus
    [50009] = true, -- Mobus
    [50050] = true, -- Shok'sharak
    [50051] = true -- Ghostcrawler
}

-- ----------------------------------------------------------------------------
-- Shimmering Expanse
-- ----------------------------------------------------------------------------
Maps[MapID.ShimmeringExpanse].NPCs = {
    [50005] = true, -- Poseidus
    [50052] = true, -- Burgy Blackheart
    [51071] = true -- Captain Florence
}

-- ----------------------------------------------------------------------------
-- The Cape of Stranglethorn
-- ----------------------------------------------------------------------------
Maps[MapID.TheCapeOfStranglethorn].NPCs = {
    [1552] = true, -- Scale Belly
    [2541] = true, -- Lord Sakrasis
    [14490] = true, -- Rippa
    [14491] = true, -- Kurmokk
    [14492] = true, -- Verifonix
    [108715] = true -- Ol' Eary
}

-- ----------------------------------------------------------------------------
-- The Temple of Atal'Hakkar
-- ----------------------------------------------------------------------------
Maps[MapID.TheTempleOfAtalHakkar].NPCs = {
    [14445] = true -- Captain Wyrmak
}

-- ----------------------------------------------------------------------------
-- Gnomeregan
-- ----------------------------------------------------------------------------
Maps[MapID.Gnomeregan].NPCs = {
    [6228] = true -- Dark Iron Ambassador
}

-- ----------------------------------------------------------------------------
-- Twilight Highlands
-- ----------------------------------------------------------------------------
Maps[MapID.TwilightHighlands].NPCs = {
    [50085] = true, -- Overlord Sunderfury
    [50086] = true, -- Tarvus the Vile
    [50089] = true, -- Julak-Doom
    [50138] = true, -- Karoma
    [50159] = true -- Sambas
}

-- ----------------------------------------------------------------------------
-- Blackrock Depths
-- ----------------------------------------------------------------------------
Maps[MapID.BlackrockDepths].NPCs = {
    [8923] = true -- Panzor the Invincible
}

-- ----------------------------------------------------------------------------
-- Blackrock Spire
-- ----------------------------------------------------------------------------
Maps[MapID.BlackrockSpire].NPCs = {
    [9217] = true, -- Spirestone Lord Magus
    [9218] = true, -- Spirestone Battle Lord
    [9219] = true, -- Spirestone Butcher
    [9596] = true, -- Bannok Grimaxe
    [9718] = true, -- Ghok Bashguud
    [9736] = true, -- Quartermaster Zigris
    [10263] = true, -- Burning Felguard
    [10376] = true, -- Crystal Fang
    [10509] = true -- Jed Runewatcher
}

-- ----------------------------------------------------------------------------
-- The Deadmines
-- ----------------------------------------------------------------------------
Maps[MapID.TheDeadmines].NPCs = {
    [596] = true, -- Brainwashed Noble
    [599] = true -- Marisa du'Paige
}

-- ----------------------------------------------------------------------------
-- Shadowfang Keep
-- ----------------------------------------------------------------------------
Maps[MapID.ShadowfangKeep].NPCs = {
    [3872] = true -- Deathsworn Captain
}

-- ----------------------------------------------------------------------------
-- Stratholme
-- ----------------------------------------------------------------------------
Maps[MapID.Stratholme].NPCs = {
    [10393] = true, -- Skul
    [10558] = true, -- Hearthsinger Forresten
    [10809] = true, -- Stonespine
    [10820] = true -- Duke Ragereaver
}

-- ----------------------------------------------------------------------------
-- Karazhan
-- ----------------------------------------------------------------------------
Maps[MapID.Karazhan].NPCs = {
    [16179] = true, -- Hyakiss the Lurker
    [16180] = true, -- Shadikith the Glider
    [16181] = true -- Rokad the Ravager
}

-- ----------------------------------------------------------------------------
-- Northshire
-- ----------------------------------------------------------------------------
Maps[MapID.Northshire].NPCs = {
    [62] = true -- Gug Fatcandle
}

-- ----------------------------------------------------------------------------
-- Deathknell
-- ----------------------------------------------------------------------------
Maps[MapID.Deathknell].NPCs = {
    [50328] = true -- Fangor
}

-- ----------------------------------------------------------------------------
-- New Tinkertown
-- ----------------------------------------------------------------------------
Maps[MapID.NewTinkertown].NPCs = {
    [1132] = true, -- Timber
    [1260] = true, -- Great Father Arctikus
    [8503] = true, -- Gibblewilt
    [107431] = true -- Weaponized Rabbot
}

-- ----------------------------------------------------------------------------
-- Scholomance
-- ----------------------------------------------------------------------------
Maps[MapID.Scholomance].NPCs = {
    [1850] = true, -- Putridius
    [59369] = true -- Doctor Theolen Krastinov
}

-- ----------------------------------------------------------------------------
-- Upper Blackrock Spire
-- ----------------------------------------------------------------------------
Maps[MapID.UpperBlackrockSpire].NPCs = {
    [77081] = true -- The Lanticore
}
