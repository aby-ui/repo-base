-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

private.RARE_LIST = {
	-- Rares Classic
	14343, --Olm the Wise
	5828, --Humar the Pridelord
	11497, --The Razza
	1552, --Scale Belly
	3253, --Silithid Harvester
	2175, --Shadowclaw
	521, --Lupos
	2850, --Broken Tooth
	3652, --Trigore the Lasher
	5829, --Snort the Heckler
	10741, --Sian-Rotam
	7846, --Teremus the Devourer
	11498, --Skarr the Broken
	462, --Vultros
	10558, --Hearthsinger Forresten
	1130, --Bjarn
	3058, --Arra'chea
	3581, --Sewer Beast
	3535, --Blackmoss the Fetid
	10200, --Rak'shiri
	11447, --Mushgog
	14430, --Duskstalker
	8660, --The Evalcharr
	3398, --Gesharahan
	2453, --Lo'Grosh
	14228, --Giggler
	6584, --King Mosh
	6585, --Uhk'loc
	3068, --Mazzranache
	14344, --Mongress
	5823, --Death Flayer
	8503, --Gibblewilt
	5349, --Arash-ethis
	10356, --Bayne
	2779, --Prince Nazjak
	8300, --Ravage
	8924, --The Behemoth
	10357, --Ressan the Needler
	14276, --Scargil
	14227, --Hissperak
	8211, --Old Cliff Jumper
	5347, --Antilus the Soarer
	8299, --Spiteflayer
	5832, --Thunderstomp
	2753, --Barnabus
	472, --Fedfennel
	5842, --Takk the Leaper
	9718, --Ghok Bashguud
	10198, --Kashoch the Reaver
	2931, --Zaricotl
	10081, --Dustwraith
	14339, --Death Howl
	14475, --Rex Ashil
	5807, --The Rake
	14268, --Lord Condar
	16184, --Nerubian Overseer
	5831, --Swiftmane
	14492, --Verifonix
	9596, --Bannok Grimaxe
	14506, --Lord Hel'nurath
	2476, --Gosh-Haldir
	471, --Mother Fang
	2172, --Strider Clutchmother
	5865, --Dishu
	10828, --Lynnia Abbendis
	14266, --Shanda the Spinner
	5356, --Snarler
	14222, --Araga
	14491, --Kurmokk
	8217, --Mith'rethis the Enchanter
	14471, --Setis
	1132, --Timber
	10263, --Burning Felguard
	9736, --Quartermaster Zigris
	14223, --Cranky Benj
	6583, --Gruff
	10644, --Mist Howler
	4015, --Pridewing Patriarch
	6582, --Clutchmother Zavas
	14477, --Grubthor
	10826, --Lord Darkscythe
	10393, --Skul
	14232, --Dart
	12431, --Gorefang
	5935, --Ironeye the Invincible
	4132, --Krkk'kx
	2452, --Skhowl
	596, --Brainwashed Noble
	5912, --Deviate Faerie Dragon
	5834, --Azzere the Skyblade
	14280, --Big Samras
	8303, --Grunter
	10080, --Sandarr Dunereaver
	8302, --Deatheye
	10817, --Duggan Wildhammer
	5835, --Foreman Grills
	14275, --Tamra Stormpike
	10119, --Volchan
	10077, --Deathmaw
	14270, --Squiddic
	12037, --Ursol'lok
	14427, --Gibblesnik
	14487, --Gluggl
	8205, --Haarka the Ravenous
	14237, --Oozeworm
	6581, --Ravasaur Matriarch
	14488, --Roloch
	9218, --Spirestone Battle Lord
	14478, --Huricanian
	8213, --Ironback
	534, --Nefaru
	14474, --Zora
	10376, --Crystal Fang
	6228, --Dark Iron Ambassador
	616, --Chatter
	7104, --Dessecus
	12433, --Krethis the Shadowspinner
	14473, --Lapress
	5352, --Old Grizzlegut
	13896, --Scalebeard
	5928, --Sorrow Wing
	10359, --Sri'skulk
	5837, --Stonearm
	1398, --Boss Galgosh
	5824, --Captain Flat Tusk
	10824, --Death-Hunter Hawkspear
	10196, --General Colbatann
	14278, --Ro'Bark
	14345, --The Ongar
	12237, --Meshlok the Harvester
	9217, --Spirestone Lord Magus
	5933, --Achellios the Banished
	10202, --Azurous
	6650, --General Fangferror
	9604, --Gorgon'och
	14221, --Gravis Slipknot
	14472, --Gretheer
	8215, --Grimungous
	10199, --Grizzle Snowpaw
	8214, --Jalinde Summerdrake
	99, --Morgaine the Sly
	574, --Naraxis
	14225, --Prince Kellen
	14490, --Rippa
	14272, --Snarlflare
	14428, --Uruson
	2754, --Anathemus
	3270, --Elder Mystic Razorsnout
	14431, --Fury Shelda
	6651, --Gatekeeper Rageroar
	1119, --Hammerspine
	2603, --Kovork
	1112, --Leech Widow
	8297, --Magronos the Unyielding
	2606, --Nimar the Slayer
	5350, --Qirot
	5785, --Sister Hatelash
	599, --Marisa du'Paige
	14340, --Alshirr Banebreath
	6648, --Antilos
	14425, --Gnawbone
	8282, --Highlord Mastrogonde
	14476, --Krellack
	3470, --Rathorian
	8978, --Thauris Balgarr
	14479, --Twilight Lord Everun
	8923, --Panzor the Invincible
	14229, --Accursed Slitherblade
	5838, --Brokespear
	2186, --Carnivous the Breaker
	4380, --Darkmist Widow
	3736, --Darkslayer Mordenthal
	14231, --Drogoth the Roamer
	5863, --Geopriest Gukk'rok
	1260, --Great Father Arctikus
	62, --Gug Fatcandle
	10821, --Hed'mush the Rotting
	14281, --Jimmy the Bleeder
	10559, --Lady Vespia
	2090, --Ma'ruk Wyrmscale
	2258, --Maggarrak
	5937, --Vile Sting
	3872, --Deathsworn Captain
	3672, --Boahn
	5822, --Felweaver Scornn
	573, --Foe Reaper 4000
	1844, --Foreman Marcrid
	14429, --Grimmaw
	5343, --Lady Szallah
	14277, --Lady Zephris
	5848, --Malgin Barleybrew
	79, --Narg the Taskmaster
	14342, --Ragepaw
	8277, --Rekk'tilac
	8281, --Scald
	14269, --Seeker Aqualon
	3792, --Terrowulf Packlord
	1851, --The Husk
	61, --Thuros Lightfingers
	1533, --Tormented Spirit
	2749, --Barricade
	5346, --Bloodroar the Stalker
	8301, --Clack the Reaver
	14279, --Creepthess
	2601, --Foulbelly
	7137, --Immolatus
	14226, --Kaskk
	14448, --Molt Thorn
	1885, --Scarlet Smith
	8298, --Akubar the Seer
	14273, --Boulderheart
	10641, --Branch Snapper
	5851, --Captain Gerogg Hammertoe
	1137, --Edan the Howler
	14426, --Harb Foulmountain
	1425, --Kubb
	8296, --Mojo the Twisted
	1140, --Razormaw Matriarch
	3295, --Sludge Anomaly
	6118, --Varo'then's Ghost
	11467, --Tsu'zee
	10082, --Zerillis
	14224, --7:XT
	2162, --Agal
	2598, --Darbel Montrose
	5345, --Diamond Head
	8304, --Dreadscorn
	1843, --Foreman Jerris
	2108, --Garneg Charskull
	14234, --Hayoc
	2191, --Licillin
	1531, --Lost Soul
	10197, --Mezzir the Howler
	1910, --Muad
	947, --Rohh the Silent
	2752, --Rumbler
	506, --Sergeant Brashclaw
	519, --Slark
	8283, --Slave Master Blackheart
	14432, --Threggil
	9219, --Spirestone Butcher
	10809, --Stonespine
	520, --Brack
	5915, --Brother Ravenoak
	14267, --Emogg the Crusher
	507, --Fenros
	1847, --Foulmane
	2609, --Geomancer Flintdagger
	10825, --Gish the Unmoving
	6649, --Lady Sesspira
	572, --Leprithus
	14236, --Lord Angler
	1848, --Lord Maldazzar
	8981, --Malfunctioning Reaver
	10647, --Prince Raze
	14271, --Ribchaser
	2602, --Ruul Onestone
	1839, --Scarlet High Clerist
	8280, --Shleipnarr
	14433, --Sludginn
	5786, --Snagglespear
	8204, --Soriid the Devourer
	5864, --Swinegart Spearhide
	3773, --Akkrilus
	10819, --Baron Bloodbane
	4339, --Brimgore
	14230, --Burgle Eye
	14445, --Captain Wyrmak
	10818, --Death Knight Soulbearer
	10642, --Eck'alom
	8207, --Emberwing
	5836, --Engineer Whirleygig
	10358, --Fellicent's Shade
	9602, --Hahk'Zor
	11383, --High Priestess Hai'watna
	584, --Kazon
	1399, --Magosh
	1838, --Scarlet Interrogator
	1837, --Scarlet Judge
	5930, --Sister Riven
	5932, --Taskmaster Whipfang
	8219, --Zul'arek Hatefowler
	3735, --Apothecary Falthis
	1936, --Farmer Solliden
	8279, --Faulty War Golem
	2192, --Firecaller Radison
	7015, --Flagglemurk the Cruel
	8979, --Gruklash
	5859, --Hagg Taurenbane
	2541, --Lord Sakrasis
	1424, --Master Digger
	14424, --Mirelow
	14233, --Ripscale
	10639, --Rorgish Jowl
	2744, --Shadowforge Commander
	5830, --Sister Rathtalon
	8278, --Smoldar
	8212, --The Reak
	14235, --The Rot
	11688, --Cursed Centaur
	10827, --Deathspeaker Selendre
	1911, --Deeb
	10820, --Duke Ragereaver
	14447, --Gilmorian
	5354, --Gnarl Leafbrother
	8976, --Hematos
	8200, --Jin'Zallah the Sandbringer
	7016, --Lady Vespira
	2604, --Molok the Crusher
	4066, --Nal'taszar
	8201, --Omgorn the Lost
	5841, --Rocklance
	1841, --Scarlet Executioner
	5809, --Sergeant Curtis
	8199, --Warleader Krazzilak
	10823, --Zul'Brin Warpbranch
	5348, --Dreamwatcher Forktongue
	14446, --Fingat
	5826, --Geolord Mottle
	1063, --Jade
	8203, --Kregg Keelhaul
	2184, --Lady Moongazer
	7017, --Lord Sinslayer
	8216, --Retherokk the Berserker
	2600, --Singer
	10078, --Terrorspark
	5849, --Digger Flameforge
	5787, --Enforcer Emilgund
	763, --Lost One Chieftain
	1106, --Lost One Cook
	10640, --Oakpaw
	1850, --Putridius
	8218, --Witherheart the Stalker
	1849, --Dreadwhisper
	8210, --Razortalon
	2751, --War Golem
	2605, --Zalas Witherbark
	5847, --Heggin Stonewhisker
	
	-- Rares Burning Crusade
	18694, --Collidus the Warp-Watcher
	20932, --Nuramoc
	18697, --Chief Engineer Lorthander
	18695, --Ambassador Jerrikar
	18678, --Fulgorge
	18679, --Vorakem Doomspeaker
	16181, --Rokad the Ravager
	18692, --Hemathion
	18698, --Ever-Core the Punisher
	18690, --Morcrush
	22060, --Fenissa the Assassin
	18677, --Mekthorg the Wild
	18682, --Bog Lurker
	18696, --Kraator
	18689, --Crippler
	17144, --Goretooth
	18685, --Okrek
	18686, --Doomsayer Jurim
	18680, --Marticar
	18693, --Speaker Mar'grom
	18683, --Voidhunter Yar
	18681, --Coilfang Emissary
	16179, --Hyakiss the Lurker
	16180, --Shadikith the Glider
	22062, --Dr. Whitherlimb
	18684, --Bro'Gaz the Clanless
	16854, --Eldinarcus
	21724, --Hawkbane
	18241, --Crusty
	16855, --Tregla
	
	-- Rares Wrath of the Lich King
	32517, --Loque'nahak
	32491, --Time-Lost Proto-Drake
	35189, --Skoll
	38453, --Arcturis
	33776, --Gondria
	32485, --King Krush
	32630, --Vyragosa
	32481, --Aotona
	32361, --Icehorn
	32500, --Dirkee
	32398, --King Ping
	32358, --Fumblub Gearwind
	32377, --Perobas the Bloodthirster
	32357, --Old Crystalbark
	32475, --Terror Spinner
	32409, --Crazed Indu'le Survivor
	32501, --High Thane Jorfus
	32438, --Syreian the Bonecarver
	32487, --Putridus the Ancient
	32471, --Griegen
	32429, --Seething Hate
	32422, --Grocklar
	32400, --Tukemuth
	32417, --Scarlet Highlord Daion
	32386, --Vigdis the War Maiden
	32495, --Hildana Deathstealer
	32447, --Zul'drak Sentinel
	32435, --Vern
	
	-- Rares Cataclysm
	50062, --Aeonaxx
	54320, --Ban'thalos
	54318, --Ankha
	54319, --Magria
	50138, --Karoma
	50005, --Poseidus
	50051, --Ghostcrawler
	50058, --Terrorpene
	50159, --Sambas
	50815, --Skarr
	50061, --Xariona
	54322, --Deth'tilac
	50052, --Burgy Blackheart
	50959, --Karkin
	51661, --Tsul'Kalu
	51663, --Pogeyan
	50056, --Garr
	50063, --Akma'hat
	50089, --Julak-Doom
	45380, --Ashtail
	45399, --Optimo
	54323, --Kirix
	49822, --Jadefang
	50065, --Armagedillo
	50009, --Mobus
	50057, --Blazewing
	54321, --Solix
	54324, --Skitterflame
	54533, --Prince Lakma
	44759, --Andre Firebeard
	56081, --Optimistic Benj
	45402, --Nix
	39185, --Slaverjaw
	47387, --Harakiss the Infestor
	54338, --Anthriss
	47015, --Lost Son of Arugal
	51662, --Mahamba
	44767, --Occulus the Corrupted
	47008, --Fenwick Thatros
	39186, --Hellgazer
	45739, --The Unknown Soldier
	49913, --Lady La-La
	51402, --Madexx
	50060, --Terborus
	50059, --Golgarok
	44750, --Caliph Scorpidsting
	52146, --Chitter
	45785, --Carved One
	47386, --Ainamiss the Hive Queen
	50064, --Cyrus the Black
	45801, --Eliza
	47010, --Indigos
	45811, --Marina DeSirrus
	45740, --Watcher Eva
	45398, --Grizlak
	51404, --Madexx
	44226, --Sarltooth
	47023, --Thule Ravenclaw
	50086, --Tarvus the Vile
	50085, --Overlord Sunderfury
	51401, --Madexx
	45771, --Marus
	45262, --Narixxus the Doombringer
	47003, --Bolgaff
	51079, --Captain Foulwind
	45258, --Cassia the Slitherqueen
	51403, --Madexx
	45257, --Mordak Nightbender
	51071, --Captain Florence
	56080, --Little Samras
	46981, --Nightlash
	39183, --Scorpitar
	43613, --Doomsayer Wiserunner
	50053, --Thartuk the Exile
	45401, --Whitefin
	47009, --Aquarius the Unbound
	45260, --Blackleaf
	45404, --Geoshaper Maren
	45384, --Sagepaw
	46992, --Berard the Moon-Crazed
	50050, --Shok'sharak
	47012, --Effritus
	43488, --Mordei the Earthrender
	44722, --Twisted Reflection of Narain
	44761, --Aquementas the Unchained
	44714, --Fronkle the Disturbed
	45369, --Morick Darkbrew
	44224, --Two-Toes
	44227, --Gazz the Loch-Hunter
	51658, --Mogh the Dead
	44225, --Rufus Darkshot
	43720, --"Pokey" Thornmantle
	50154, --Madexx

	-- Rares Pandaria
	58778, --Aetha
	50750, --Aethis
	50817, --Ahone the Wanderer
	50821, --Ai-Li Skymirror
	50822, --Ai-Ran the Shifting Cloud
	70000, --Al'tabim the All-Seeing
	73174, --Archiereus of Flame
	73666, --Archiereus of Flame
	70243, --Archritualist Kelada
	50787, --Arness the Scale
	70001, --Backbreaker Uru
	58949, --Bai-Jin the Butcher
	63695, --Baolai the Immolator
	51059, --Blackhoof
	58474, --Bloodtip
	50828, --Bonobos
	50341, --Borginn Darkfist
	72775, --Bufo
	73171, --Champion of the Black Flame
	72045, --Chelon
	73175, --Cinderfall
	50768, --Cournith Waterstrider
	58768, --Cracklefang
	72049, --Cranegnasher
	50334, --Dak the Breaker
	68318, --Dalan Nightbreaker
	68319, --Disha Fearwarden
	59369, --Doctor Theolen Krastinov
	73281, --Dread Ship Vazuvius
	73158, --Emerald Gander
	50772, --Eshelon
	73279, --Evermaw
	51078, --Ferdinand
	70429, --Flesh'rok the Diseased
	73172, --Flintlord Gairan
	70249, --Focused Eye
	50340, --Gaarn the Toxic
	62881, --Gaohun the Soul-Severer
	50739, --Gar'lok
	73282, --Garnia
	63101, --General Temuja
	50331, --Go-Kan
	62880, --Gochao the Ironfist
	69999, --God-Hulk Ramuk
	69998, --Goda
	72970, --Golganarr
	73161, --Great Turtle Furyshell
	72909, --Gu'chi the Swarmbringer
	50354, --Havak
	50358, --Haywire Sunreaver Construct
	63691, --Huo-Shuang
	73167, --Huolon
	50836, --Ik-Ik the Nimble
	73163, --Imperial Python
	73160, --Ironfur Steelhorn
	73169, --Jakur of Ordon
	50351, --Jonn-Dar
	50355, --Kah'tir
	50749, --Kal'tik the Blight
	50349, --Kang the Soul Thief
	68321, --Kar Warmaker
	72193, --Karkanos
	50347, --Karr the Darkener
	50338, --Kor'nas Nightsavage
	50332, --Korda Torros
	70323, --Krakkanon
	50363, --Krax'ik
	63978, --Kri'chon
	50356, --Krol the Blade
	69996, --Ku'lai the Skyclaw
	73277, --Leafmender
	50734, --Lith'ik the Stalker
	50333, --Lon the Bull
	70002, --Lu-Ban
	50840, --Major Nanners
	68317, --Mavis Harms
	50823, --Mister Ferocious
	50806, --Moldo One-Eye
	70003, --Molthor
	70440, --Monara
	73166, --Monstrous Spineclaw
	50350, --Morgrinn Crackfang
	68322, --Muerta
	69664, --Mumta
	50364, --Nal'lak the Ripper
	50776, --Nalash Verdantis
	50811, --Nasra Spothide
	50789, --Nessos the Oracle
	70276, --No'ku Stormsayer
	50344, --Norlaxx
	50805, --Omnis Grinlok
	69997, --Progenitus
	50352, --Qu'nas
	58771, --Quid
	70530, --Ra'sha
	72048, --Rattleskew
	73157, --Rock Moss
	70430, --Rocky Horror
	50816, --Ruun Ghostpaw
	50780, --Sahn Tidehunter
	50783, --Salyin Warscout
	50782, --Sarnak
	50831, --Scritch
	50766, --Sele'na
	63240, --Shadowmaster Sydow
	50791, --Siltriss the Sharpener
	50733, --Ski'thik
	71864, --Spelurk
	72769, --Spirit of Jadefire
	58817, --Spirit of Lao-Fe
	50830, --Spriggin
	73704, --Stinkbraid
	50339, --Sulik'shor
	50832, --The Yowler
	50388, --Torik-Ethis
	72808, --Tsavo'ka
	68320, --Ubunti the Shade
	70238, --Unblinking Eye
	73173, --Urdur the Cauterizer
	50359, --Urgolax
	50808, --Urobi the Walker
	58769, --Vicejaw
	63977, --Vyraxxis
	70096, --War-God Dokah
	73170, --Watcher Osu
	73293, --Whizzig
	70126, --Willy Wilder
	63510, --Wulon
	50336, --Yorik Sharpeye
	50820, --Yul Wildpaw
	50769, --Zai the Outcast
	69769, --Zandalari Warbringer cian
	69842, --Zandalari Warbringer gray
	69841, --Zandalari Warbringer silver
	69768, --Zandalari Warscout
	69843, --Zao'cho
	72245, --Zesqua
	71919, --Zhu-Gon the Sour
	50842, --Magmagan
	50839, --Chromehound
	51052, --Gib the Banana-Hoarder
	50343, --Quall
	50737, --Acroniss
	50837, --Kash
	50348, --Norissis
	50346, --Ronak
	50357, --Sunwing
	51077, --Bushtail
	51044, --Plague
	50786, --Sparkwing
	50908, --Nighthowl
	50818, --The Dark Prowler
	50819, --Iceclaw
	50833, --Duskcoat
	50792, --Chiaa
	51045, --Arcanus
	50328, --Fangor
	50856, --Snark
	50916, --Lamepaw the Whimperer
	50864, --Thicket
	51076, --Lopex
	50874, --Tenok
	50353, --Manas
	50784, --Anith
	50797, --Yukiko
	50763, --Shadowstalker
	51014, --Terrapis
	50813, --Fene-mal
	50825, --Feras
	50895, --Volux
	50788, --Quetzl
	50915, --Snort
	50335, --Alitus
	51042, --Bleakheart
	50743, --Manax
	50362, --Blackbog the Fang
	50803, --Bonechewer
	50744, --Qu'rik
	51018, --Zormus
	50330, --Kree
	50930, --Hibernus the Sleeper
	50947, --Varah
	50903, --Orlix the Swamplord
	50370, --Karapax
	50838, --Tabbs
	50926, --Grizzled Ben
	50949, --Finn's Gambit
	51069, --Scintillex
	50725, --Azelisk
	50882, --Chupacabros
	50986, --Goldenback
	50906, --Mutilax
	50846, --Slavermaw
	50940, --Swee
	50361, --Ornat
	51040, --Snuffles
	50993, --Gal'dorak
	51048, --Rexxus
	50886, --Seawing
	50337, --Cackle
	50342, --Heronis
	50855, --Jaxx the Rabid
	50858, --Dustwing
	50790, --Ionis
	50759, --Iriss the Widow
	51037, --Lost Gilnean Wardog
	51046, --Fidonis
	50779, --Sporeggon
	50997, --Bornak the Gorer
	50995, --Bruiser
	50810, --Favored of Isiset
	51027, --Spirocula
	51028, --The Deep Tunneler
	50891, --Boros
	50724, --Spinecrawl
	51004, --Toxx
	50884, --Dustflight the Cowardly
	50925, --Grovepaw
	50742, --Qem
	50948, --Crystalback
	51062, --Khep-Re
	50775, --Likk the Hunter
	51063, --Phalanax
	50730, --Venomspine
	50746, --Bornix the Burrower
	50922, --Warg
	50937, --Hamhide
	50929, --Little Bjorn
	50752, --Tarantis
	50946, --Hogzilla
	51021, --Vorticus
	51017, --Gezan
	50745, --Losaj
	50727, --Strix the Barbed
	50814, --Corpsefeeder
	50876, --Avis
	50952, --Barnacle Jim
	50967, --Craw the Ravager
	50738, --Shimmerscale
	50345, --Alit
	50905, --Cida
	50809, --Heress
	50955, --Carcinak
	50778, --Ironweb
	51007, --Serkett
	50785, --Skyshadow
	51066, --Crystalfang
	50892, --Cyn
	50329, --Rrakk
	50945, --Scruff
	50777, --Needle
	51061, --Roth-Salam
	51029, --Parasitus
	51010, --Snips
	50741, --Kaxx
	51053, --Quirix
	51000, --Blackshell the Impenetrable
	51022, --Chordix
	50728, --Deathstrike
	51026, --Gnath
	50931, --Mange
	50731, --Needlefang
	50812, --Arae
	50735, --Blinkeye the Rattler
	51067, --Glint
	50726, --Kalixx
	50807, --Catal
	50901, --Teromak
	51031, --Tracker
	50875, --Nychus
	50865, --Saurix
	50942, --Snoot the Rooter
	50804, --Ripwing
	50957, --Hugeclaw
	51008, --The Barbed Horror
	50747, --Tix
	50770, --Zorn
	50964, --Chops
	51025, --Dilennaa
	51001, --Venomclaw
	51002, --Scorpoxx
	50764, --Paraliss
	50748, --Nyaj
	51058, --Aphis
	50897, --Ffexk the Dunestalker
	50765, --Miasmiss
	51057, --Weevil
	
	-- Rares Warlords of Draenor
	77140, --Amaukwa
	82899, --Ancient Blademaster
	86213, --Aqualir
	88043, --Avatar of Socrethar
	82326, --Ba'ruun
	81406, --Bahameye
	82085, --Bashiok
	78150, --Beastcarver Saramor
	84887, --Betsi Boombasket
	80614, --Blade-Dancer Aeryx
	84856, --Blightglow
	81639, --Brambleking Fili
	78867, --Breathless
	87234, --Brutag Grimblade
	71721, --Canyon Icemother
	82311, --Char the Burning
	80242, --Chillfang
	72294, --Cindermaw
	78169, --Cloudspeaker Daber
	77513, --Coldstomp the Griever
	76914, --Coldtusk
	77620, --Cro Fleshrender
	78621, --Cyclonic Fury
	77085, --Dark Emanation
	82268, --Darkmaster Go'vid
	82411, --Darktalon
	82058, --Depthroot
	86729, --Direhoof
	77561, --Dr. Gloom
	84807, --Durkath Steelmaw
	82676, --Enavra
	82742, --Enavra
	82207, --Faebright
	82975, --Fangler
	80204, --Felbark
	82992, --Felfire Consort
	84890, --Festerbloom
	74971, --Firefury Giant
	88580, --Firestarter Grash
	83483, --Flinthide
	85250, --Fossilwood the Petrified
	77614, --Frenzied Golem
	78713, --Galzomar
	82764, --Gar'lua
	81038, --Gelgor of the Blue Flame
	82882, --General Aevd
	80471, --Gennadian
	71665, --Giant-Slayer Kul
	78144, --Giantslayer Kimla
	77719, --Glimmerwing
	80868, --Glut
	82778, --Gnarlhoof the Rabid
	76380, --Gorum
	82876, --Grand Marshal Tremblade
	82758, --Greatfeather
	84431, --Greldrok the Cunning
	82912, --Grizzlemaw
	78128, --Gronnstalker Dawarn
	88583, --Grove Warden Yal
	80312, --Grutush the Pillager
	80190, --Gruuk
	80235, --Gurun
	83008, --Haakun the All-Consuming
	77715, --Hammertooth
	77626, --Hen-Mother Hami
	86724, --Hermit Palefur
	82877, --High Warlord Volrath
	88672, --Hunter Bal'ra
	83603, --Hunter Blacktooth
	78151, --Huntmaster Kuang
	78161, --Hyperious
	83553, --Insha'tar
	82616, --Jabberjaw
	87600, --Jaluk the Pacifist
	84955, --Jiasska the Sporegorger
	84810, --Kalos the Bloodbathed
	86959, --Karosh Blackwind
	78710, --Kharazos the Triumphant
	74206, --Killmaw
	78872, --Klikixx
	72362, --Ku'targ the Voidseer
	85121, --Lady Temptessa
	72537, --Leaf-Reader Kurri
	77784, --Lo'marg Jawcrusher
	82920, --Lord Korinak
	77310, --Mad "King" Sporeon
	83643, --Malroc Stonesunder
	84406, --Mandrakor
	82878, --Marshal Gabriel
	82880, --Marshal Karsh Stormforge
	82998, --Matron of Sin
	82362, --Morva Soultwister
	76473, --Mother Araneae
	75071, --Mother Om'ra
	84417, --Mutafen
	82247, --Nas Dunberlin
	79334, --No'losh
	83409, --Ophiis
	84872, --Oskiira the Vengeful
	83680, --Outrider Duretha
	78606, --Pale Fishmonger
	78134, --Pathfinder Jalog
	88208, --Pit Beast
	84838, --Poisonmaster Bortusk
	76918, --Primalist Mur'og
	77741, --Ra'kahn
	84392, --Ragore Driftstalker
	82374, --Rai'vosh
	82755, --Redclaw the Feral
	85504, --Rotcap
	84833, --Sangrikass
	77526, --Scout Goreseeker
	83542, --Sean Whitesea
	79938, --Shadowbark
	82415, --Shinri
	78715, --Sikthiss, Maiden of Slaughter
	79686, --Silverleaf Ancient
	79693, --Silverleaf Ancient
	79692, --Silverleaf Ancient
	83990, --Solar Magnifier
	80057, --Soulfang
	86549, --Steeltusk
	79629, --Stomper Kreego
	84805, --Stonespite
	80725, --Sulfurious
	86137, --Sunclaw
	84912, --Sunderthorn
	85520, --Swarmleaf
	88582, --Swift Onyx Flayer
	84836, --Talonbreaker
	79485, --Talonpriest Zorkra
	84775, --Tesska the Broken
	77527, --The Beater
	82618, --Tor'goroth
	83591, --Tura'aka
	82050, --Varasha
	75482, --Veloss
	85078, --Voidreaver Urnae
	83385, --Voidseer Kalurg
	77776, --Wandering Vindicator
	79024, --Warmaster Blugthol
	75434, --Windfang Matriarch
	82922, --Xothear, the Destroyer
	79145, --Yaga the Scarred
	77529, --Yazheera the Incinerator
	75435, --Yggdrel
	71992, --Moonfang
	84875, --Ancient Inferno
	83819, --Brickhouse
	84911, --Demidos
	85771, --Elder Darkweaver Kath
	84893, --Goregore
	84110, --Korthall Soulgorger
	82988, --Kurlosh Doomfang
	82942, --Lady Demlash
	83683, --Mandragoraster
	84904, --Oraggro
	87668, --Orumo the Observer
	83691, --Panthora
	82930, --Shadowflame Terrorwalker
	83713, --Titarus
	88436, --Vigilant Paarthos
	88072, --Archmagus Tekar
	87597, --Bombardier Gu'gok
	84746, --Captured Gor'vosh Stoneshaper
	85767, --Cursed Harbinger
	85763, --Cursed Ravager
	85766, --Cursed Sharptalon
	87352, --Gibblette the Cowardly
	87362, --Gibby
	83019, --Gug'tol
	87348, --Hoarfrost
	88494, --Legion Vanguard
	85001, --Master Sergeant Milgra
	82614, --Moltnoma
	87351, --Mother of Goren
	84925, --Quartermaster Hershak
	85029, --Shadowspeaker Niir
	82617, --Slogtusk the Corpse-Eater
	82620, --Son of Goramal
	88083, --Soulbinder Naylana
	88071, --Strategist Ankor
	78265, --The Bone Crawler
	86579, --Blademaster Ro'gor
	86566, --Defector Dazgo
	86571, --Durp the Hated
	82536, --Gorivax
	86577, --Horgg
	86574, --Inventor Blammo
	86562, --Maniacal Madgard
	86582, --Morgo Kain
	77081, --The Lanticore
	87357, --Valkor
	87356, --Vrok the Ancient
	82883, --Warlord Noktyn
	84378, --Ak'ox the Slaughterer
	86268, --Alkali
	85568, --Avalanche
	87837, --Bonebreaker
	84926, --Burning Power
	87788, --Durg Spinecrusher
	87019, --Gluttonous Giant
	78269, --Gnarljaw
	72364, --Gorg'ak the Lava Guzzler
	87344, --Gortag Steelgrip
	78260, --King Slime
	87239, --Krahl Deadeye
	84465, --Leaping Gorger
	85451, --Malgosh Shadowkeeper
	87026, --Mecha Plunderer
	88586, --Mogamago
	84435, --Mr. Pinchy Sr.
	85555, --Nagidna
	87027, --Shadow Hulk
	84854, --Slippery Slime
	85837, --Slivermaw
	85026, --Soul-Twister Torek
	79104, --Ug'lok the Frozen
	84196, --Web-wrapped Soldier
	86774, --Aogexon
	86257, --Basten
	86732, --Bergruu
	72156, --Borrok the Devourer
	86743, --Dekorhan
	80372, --Echidna
	86771, --Gagrog the Brutal
	80398, --Keravnos
	88210, --Krud the Eviscerator
	80370, --Lernaea
	87666, --Mu'gra
	86258, --Nultra
	87846, --Pit Slayer
	86750, --Thek'talon
	80371, --Typhon
	86259, --Valstil
	86266, --Venolasix
	88951, --Vileclaw
	86835, --Xelganak
	79725, --Captain Ironbeard
	80122, --Gaz'orda
	83401, --Netherspawn
	83526, --Ru'klaa
	83428, --Windcaller Korast
	82826, --Berserk T-300 Series Mark II
	82486, --Explorer Nozzand
	83509, --Gorepetal
	84263, --Graveltooth
	83634, --Scout Pokhar
	86978, --Gaze
	84951, --Gobblefin
	85572, --Grrbrrgle
	77664, --Aarko
	77828, --Echo of Murmur
	77795, --Echo of Murmur
	79543, --Shirzir
	77634, --Taladorantula
	80524, --Underseer Bloodmane
	85264, --Rolkor
	86410, --Sylldross
	83522, --Hive Queen Skrikka
	74613, --Broodmother Reeg'ak
	77519, --Giantbane
	86689, --Sneevel
	86520, --Stompalupagus
	85907, --Berthora
	85970, --Riptar
	79524, --Hypnocroak
	72606, --Rockhoof
	75492, --Venomshade
	50990, --Nakk the Thunderer
	50992, --Gorok
	50981, --Luk'hok
	50985, --Poundfist
	51015, --Silthide
	50883, --Pathrunner
	81001, --Nok-Karosh
	91871, --Argosh the Destroyer
	92552, --Belgork
	90884, --Bilkor the Thrower
	92657, --Bleeding Hollow Horror
	90936, --Bloodhunter Zulk
	92429, --Broodlord Ixkor
	93264, --Captain Grok'mar
	93076, --Captain Ironbeard
	90434, --Ceraxas
	90519, --Cindral the Wildfire
	90887, --Dorg the Bloody
	93028, --Driss Vile
	90888, --Drivnul
	91727, --Executor Riloth
	93168, --Felbore
	92647, --Felsmith Damorka
	91098, --Felspark
	92508, --Gloomtalon
	92941, --Gorabosh
	91695, --Grand Warlock Nethekurse
	93057, --Grannok
	90094, --Harbormaster Korak
	90777, --High Priest Ikzan
	90429, --Imp-Master Valessa
	90437, --Jax'zor
	92517, --Krell the Serene
	93279, --Kris'kar the Unredeemed
	90438, --Lady Oran
	93002, --Magwia
	90442, --Mistress Thavra
	92411, --Overlord Ma'gruth
	92274, --Painmistress Selora
	91374, --Podlord Wakkawam
	91009, --Putre'thar
	90782, --Rasthe
	92197, --Relgor
	91227, --Remnant of the Blood Moon
	92627, --Rendrak
	90885, --Rogond the Tracker
	94113, --Rukmaz
	90024, --Sergeant Mor'grak
	93236, --Shadowthrash
	92495, --Soulslicer
	92887, --Steelsnout
	92606, --Sylissa
	93001, --Szirek the Twisted
	92465, --The Blackfang
	92694, --The Goreclaw
	92977, --The Iron Houndmaster
	92645, --The Night Haunter
	92636, --The Night Haunter
	91243, --Tho'gar Gorefist
	92574, --Thromma the Gutslicer
	92451, --Varyx the Damned
	92408, --Xanzith the Everlasting
	91087, --Zeter'el
	90122, --Zoug the Heavy
	91093, --Bramblefell
	91232, --Commander Krag'goth
	89675, --Commander Org'mok
	95053, --Deathtalon
	95056, --Doomroller
	93125, --Glub'glok
	95044, --Terrorfist
	95054, --Vengeance
	91921, --Wyrmple
	96235, --Xemirkol
	98200, --Guk
	98199, --Pugg
	98198, --Rukdug
	98283, --Drakum
	98284, --Gondar
	98285, --Smashum Grabb
	98408, --Fel Overseer Mudlump
	96323, --Arachnis
	75590, --Enormous Bullfrog
	87029, --Giga Sentinel
	86621, --Morphed Sentient
	85037, --Kenos the Unraveler
	84376, --Earthshaker Holar
	87622, --Ogom the Mangler
	85036, --Formless Nightmare
	77750, --Kaavu the Crimson Claw
	84374, --Kaga the Ironbender

	-- Rares Legion	
	110378, --Drugon the Frostblood
	99929, --Flotsam
	108879, --Humongris
	107544, --Nithogg
	108678, --Shar'thos
	100230, --"Sure-Shot" Arnie
	112705, --Achronos
	108885, --Aegir Wavecrusher
	104481, --Ala'washte
	107960, --Alluvanon
	104521, --Alteria
	111649, --Ambassador D'vwinn
	92611, --Ambusher Daggerfang
	111197, --Anax
	110346, --Aodh Witherpetal
	110870, --Apothecary Faldren
	92634, --Apothecary Perez
	90173, --Arcana Stalker
	110656, --Arcanist Lylandre
	107657, --Arcanist Shal'iman
	109641, --Arcanor Prime
	90244, --Arcavellus
	97220, --Arru
	99802, --Arthfael
	106351, --Artificer Lothaire
	92633, --Assassin Huwe
	112758, --Auditor Esiel
	112759, --Az'jatar
	103787, --Baconlisk
	110562, --Bahagar
	91187, --Beacher
	111454, --Bestrix
	107327, --Bilebrain
	91874, --Bladesquall
	92599, --Bloodstalker Alpha
	98299, --Bodash the Hoarder
	109113, --Boulderfall, the Eroded
	107127, --Brawlgoth
	97449, --Bristlemaul
	91100, --Brogozog
	94877, --Brogrul the Mighty
	107105, --Broodmother Lizax
	105632, --Broodmother Shu'malis
	111463, --Bulvinkel
	110726, --Cadraeus
	91289, --Cailyn Paledoom
	92685, --Captain Brvet
	109163, --Captain Dargun
	89846, --Captain Volo'ren
	92604, --Champion Elodie
	106990, --Chief Bitterbrine
	109677, --Chief Treasurer Jabrill
	111674, --Cinderwing
	104698, --Colerian
	104519, --Colerian
	107266, --Commander Soraax
	100864, --Cora'kar
	97058, --Count Nefarious
	108255, --Coura, Mistress of Arcana
	97933, --Crab Rider Grmlrml
	97345, --Crawshuk the Hungry
	90057, --Daggerbeak
	94313, --Daniel "Boomer" Vorick
	100231, --Dargok Thunderuin
	92631, --Dark Ranger Jess
	107924, --Darkfiend Tormentor
	109501, --Darkful
	92965, --Darkshade
	92626, --Deathguard Adams
	109702, --Deepclaw
	104513, --Defilia
	111651, --Degren
	108790, --Den Mother Ylva
	112637, --Devious Sunrunner
	100495, --Devouring Darkness
	91579, --Doomlord Kazrok
	108543, --Dread Captain Thedon
	108541, --Dread Corsair
	94347, --Dread-Rider Cortis
	97517, --Dreadbog
	96072, --Durguth
	110367, --Ealdis
	96647, --Earlnoc the Beastbreaker
	98188, --Egyl the Enduring
	99792, --Elfbane
	91803, --Fathnyr
	105938, --Felwing
	92040, --Fenri
	109584, --Fjordun
	108827, --Fjorlag, the Grave's Chill
	97793, --Flamescale
	89884, --Flog the Captain-Eater
	101649, --Frostshard
	99610, --Garvrulg
	93679, --Gathenak the Subjugator
	97370, --General Volroth
	91529, --Glimar Ironfist
	89816, --Golza the Iron Fin
	101411, --Gom Crabbar
	92117, --Gorebeak
	110832, --Gorgroth
	95123, --Grelda the Hag
	107595, --Grimrot
	107596, --Grimrot
	112708, --Grimtotem Champion
	98503, --Grrvrgull the Conqueror
	110944, --Guardian Thor'el
	96590, --Gurbog da Basher
	108823, --Halfdan
	107926, --Hannval the Butcher
	103214, --Har'kess the Insatiable
	110361, --Harbinger of Screams
	97326, --Hartli the Snatcher
	103154, --Hati
	92703, --Helmouth Raider
	92682, --Helmouth Raider
	103223, --Hertha Grimdottir
	92590, --Hook
	107169, --Horux
	92951, --Houndmaster Ely
	107136, --Houndmaster Stroxis
	110486, --Huk'roth the Huntmaster
	108822, --Huntress Estrid
	100067, --Hydrannon
	109630, --Immolian
	90803, --Infernal Lord
	90139, --Inquisitor Ernstenbok
	107269, --Inquisitor Tivos
	106532, --Inquisitor Volitix
	93030, --Ironbranch
	94413, --Isel the Hammer
	92751, --Ivory Sentinel
	103975, --Jade Darkhaven
	101467, --Jaggen-Ra
	109500, --Jak
	93686, --Jinikki the Puncturer
	111731, --Karthax
	109125, --Kathaw the Savage
	96997, --Kethrazor
	103827, --King Morgalash
	97059, --King Voras
	94414, --Kiranys Duskwhisper
	111573, --Kosumoth the Hungering
	98421, --Kottr Vondyr
	103271, --Kraxa
	99362, --Kudzilla
	106526, --Lady Rivantas
	109015, --Lagertha
	102303, --Lieutenant Strathmar
	108366, --Long-Forgotten Hippogryph
	98024, --Luggut the Eggeater
	98241, --Lyrath Moonfeather
	111939, --Lysanis Shadesoul
	109692, --Lytheron
	95221, --Mad Henryk
	109954, --Magister Phaedris
	112757, --Magistrix Vilessa
	112497, --Maia the White
	96410, --Majestic Elderhorn
	110024, --Mal'Dreth the Corruptor
	109281, --Malisandra
	112802, --Mar'tura
	109653, --Marblub the Massive
	111329, --Matron Hagatha
	104517, --Mawat'aki
	96621, --Mellok, Son of Torok
	111653, --Miasu
	93371, --Mordvigbjorn
	93622, --Mortiferous
	91780, --Mother Clacker
	89865, --Mrrgrl the Tide Reaver
	98311, --Mrrklr
	97593, --Mynta Talonscreech
	110340, --Myonix
	101641, --Mythana
	107477, --N.U.T.Z.
	107023, --Nithogg
	90217, --Normantis the Deposed
	109990, --Nylaathria the Forgotten
	105899, --Oglok the Furious
	108715, --Ol' Eary
	107617, --Ol' Muddle
	104484, --Olokk the Shipbreaker
	110577, --Oreth the Vile
	104524, --Ormagrogg
	95204, --Oubdob da Smasher
	97057, --Overseer Brutarg
	99886, --Pacified Earth
	113694, --Pashya
	95318, --Perrexx
	107846, --Pinchshank
	103045, --Plaguemaw
	94485, --Pollous the Fetid
	90901, --Pridelord Meowl
	92613, --Priestess Liza
	100302, --Puck
	110342, --Rabxach
	101660, --Rage Rot
	109504, --Ragemaw
	99846, --Raging Earth
	103199, --Ragoul
	97102, --Ram'Pag
	111007, --Randril
	105547, --Rauren
	89016, --Ravyn-Drath
	103575, --Reef Lord Raj'his
	103183, --Rok'nash
	110363, --Roteye
	109317, --Rulf Bonesnapper
	109318, --Runeseer Sigvid
	100232, --Ryael Dawndrifter
	105739, --Sanaar
	105728, --Scythemaster Cil'raman
	111434, --Sea King Tidross
	92180, --Seersei
	101077, --Sekhan
	104522, --Selenyi
	103841, --Shadowquill
	109054, --Shal'an
	104523, --Shalas'aman
	97093, --Shara Felbreath
	91788, --Shellmaw
	103605, --Shroudseeker
	108794, --Shroudseeker's Shadow
	110438, --Siegemaster Aedrin
	111052, --Silver Serpent
	112636, --Sinister Leyrunner
	92591, --Sinker
	93654, --Skul'vrax
	95872, --Skullhat
	111021, --Sludge Face
	98890, --Slumber
	112756, --Sorallus
	109195, --Soulbinder Halldora
	108494, --Soulfiend Tagerma
	97630, --Soulthirster
	107487, --Starbuck
	109594, --Stormfeather
	109994, --Stormtalon
	91795, --Stormwing Matriarch
	90505, --Syphonus
	97928, --Tamed Coralback
	98268, --Tarben
	97653, --Taurson
	97203, --Tenpak Flametotem
	91892, --Thane Irglov the Merciless
	108136, --The Muscle
	92763, --The Nameless King
	89850, --The Oracle
	111057, --The Rat King
	109620, --The Whisperer
	92423, --Theryssia
	93205, --Thondrax
	91114, --Tide Behemoth
	91115, --Tide Behemoth
	91113, --Tide Behemoth
	110824, --Tideclaw
	93166, --Tiptog the Lost
	102064, --Torrentius
	92609, --Tracker Jack
	103247, --Ultanok
	109708, --Undergrell Ringleader
	93401, --Urgev the Flayer
	109575, --Valakar the Thirsty
	89650, --Valiyaka the Stormbringer
	99899, --Vicious Whale Shark
	112760, --Volshax, Breaker of Will
	107113, --Vorthax
	100224, --Vrykul Earthmaiden Spirit
	100223, --Vrykul Earthshaper Spirit
	90164, --Warbringer Mox'na
	107431, --Weaponized Rabbot
	103785, --Well-Fed Bear
	92152, --Whitewater Typhoon
	109648, --Witchdoctor Grgl-Brgl
	97504, --Wraithtalon
	97069, --Wrath-Lord Lekos
	109498, --Xaander
	100303, --Zenobia
	107170, --Zorux
	97587, --Crazed Mage
	97380, --Splint
	97390, --Thieving Scoundrel
	97388, --Xullorax
	97384, --Segacedi
	97589, --Rotten Egg
	97387, --Mana Seeper
	97381, --Screek
	115847, --Ariadne
	116185, --Attendant Keeper
	115853, --Doomlash
	116230, --Exotic Concubine
	116004, --Flightmaster Volnath
	116008, --Kar'zun
	116395, --Nightwell Diviner
	116059, --Regal Cloudwing
	116034, --The Cow King
	115914, --Torm the Brute
	116158, --Tower Concubine
	116159, --Wily Sycophant
	116041, --Treasure Goblin
	118244, --Lightning Paw
	115537, --Lorthalium
	121124, --Apocron
	117303, --Malificus
	117470, --Si'vash
	120675, --An'thyna
	121092, --Anomalous Observer
	121016, --Aqueux
	121049, --Baleful Knight-Captain
	121029, --Brood Mother Nix
	121046, --Brother Badatin
	117239, --Brutallus
	116953, --Corrupted Bonebreaker
	120022, --Deepmaw
	121090, --Demented Shivarra
	121073, --Deranged Succubus
	117136, --Doombringer Zar'thoz
	117095, --Dreadblade Annihilator
	118993, --Dreadeye
	120716, --Dreadspeaker Serilis
	120012, --Dresanoth
	121134, --Duke Sithizi
	117086, --Emberfire
	120020, --Erdu'val
	116166, --Eye of Gurgh
	120681, --Fel Obliterator
	117093, --Felbringer Xar'thok
	117103, --Felcaller Zelthae
	117091, --Felmaw Emberfiend
	120998, --Flllurlokkr
	120665, --Force-Commander Xillious
	121037, --Grossir
	120686, --Illisthyndria
	119718, --Imp Mother Bruva
	117089, --Inquisitor Chillbane
	115732, --Jorvild the Trusted
	120021, --Kelpfist
	121107, --Lady Eldrathe
	121077, --Lambent Felhunter
	120712, --Larithia
	119629, --Lord Hel'Nurath
	121056, --Malformed Terrorguard
	117141, --Malgrazoth
	117094, --Malorus the Soulkeeper
	120717, --Mistress Dominix
	117096, --Potionmaster Gloop
	120715, --Raga'yut
	121108, --Ruinous Overfiend
	120019, --Ryul the Fading
	117140, --Salethan the Broodwalker
	117850, --Simone the Seductress
	120641, --Skulguloth
	121112, --Somber Dawn
	120583, --Than'otalion
	120013, --The Dread Stalker
	121051, --Unstable Abyssal
	121068, --Volatile Imp
	120713, --Wa'glur
	120003, --Warlord Darjah
	121088, --Warped Voidlord
	117090, --Xorogun the Flamecarver
	112712, --Gilded Guardian
	123087, --Al'Abas
	122524, --Bloodfeast
	122521, --Bonesunder
	122899, --Death Metal Knight
	122519, --Dregmar Runebrand
	122520, --Icefist
	122522, --Iceshatter
	122609, --Xavinox
	127090, --Admiral Rel'var
	127096, --All-Seer Xanarian
	126887, --Ataxon
	126862, --Baruut the Bloodthirsty
	122958, --Blistermaw
	126869, --Captain Faruq
	127376, --Chief Alchemist Munculus
	124775, --Commander Endaxis
	122912, --Commander Sathrenael
	127084, --Commander Texlaz
	122911, --Commander Vecaya
	126910, --Commander Xethgar
	122457, --Darkcaller
	127703, --Doomcaster Suprax
	126864, --Feasel the Muffin Thief
	122999, --Gar'zoth
	126896, --Herald of Chaos
	127288, --Houndmaster Kerrax
	125820, --Imp Mother Laglath
	126946, --Inquisitor Vethroz
	126900, --Instructor Tarahna
	126899, --Jed'hin Champion Vorusk
	126860, --Kaara the Pale
	125824, --Khazaduum
	126254, --Lieutenant Xakaar
	122947, --Mistress Il'thendra
	127705, --Mother Rosula
	126419, --Naroua
	124440, --Overseer Y'Beda
	125498, --Overseer Y'Morna
	125497, --Overseer Y'Sorna
	126040, --Puscilla
	127706, --Rezira the Seer
	126898, --Sabuul
	122838, --Shadowcaster Voruun
	120393, --Siegemaster Voraan
	123464, --Sister Subversia
	126912, --Skreeg the Devourer
	126913, --Slithon the Last
	126889, --Sorolis the Ill-Fated
	126815, --Soultwisted Monstrosity
	127700, --Squadron Commander Vishax
	123689, --Talestra the Vile
	125479, --Tar Spitter
	124804, --Tereck the Selector
	127581, --The Many-Faced Devourer
	126868, --Turek the Lucid
	127906, --Twilight-Harbinger Tharuul
	126885, --Umbraliss
	125388, --Vagath the Betrayed
	126208, --Varga
	126115, --Ven'orn
	126867, --Venomtail Skyfin
	126866, --Vigilant Kuro
	126865, --Vigilant Thanos
	127882, --Vixx the Collector
	127300, --Void Warden Valsuran
	127911, --Void-Blade Zedaat
	122456, --Voidmaw
	126199, --Vrax'thul
	127291, --Watcher Aival
	127118, --Worldsplitter Skuul
	126852, --Wrangler Kravos
	126338, --Wrath-Lord Yarez
	126908, --Zul'tan the Numerous
	125951, --Obsidian Deathwarder
	132591, --Ogmot the Mad
	132578, --Qroshekx
	132580, --Ssinkrix
	132584, --Xaarshej
	111122, --Large Vile Slime
	90816, --Skystormer
	100000, --Johnny Awesomer
	
	-- Rares Battle for Azeroth
	136385, --Azurethos
	140252, --Hailstone Construct
	132253, --Ji'arak
	132701, --T'zane
	140163, --Warbringer Yenajz
	138279, --Adhara White
	140474, --Adherent of the Abyss
	135852, --Ak'tar
	125250, --Ancient Jawbreaker
	137824, --Arclight
	137529, --Arvon the Betrayed
	130439, --Ashmane
	129961, --Atal'zul Gotaka
	132182, --Auditor Dolp
	137825, --Avalanche
	129343, --Avatar of Xolotal
	128553, --Azer'tor
	134298, --Azerite-Infused Elemental
	134293, --Azerite-Infused Slag
	128497, --Bajiani the Slick
	126142, --Bajiatha
	130143, --Balethorn
	143314, --Bane of the Woods
	127333, --Barbthorn Queen
	129181, --Barman Bill
	132068, --Bashmu
	142709, --Beastrider Kama
	134147, --Beehemoth
	129805, --Beshol
	124548, --Betsy
	132319, --Bilefang Mother
	132086, --Black-Eyed Bart
	139145, --Blackthorne
	138667, --Blighted Monstrosity
	129476, --Bloated Krolusk
	126635, --Blood Priest Xak'lar
	128699, --Bloodbulge
	138299, --Bloodmaw
	136393, --Bloodwing Bonepicker
	126621, --Bonesquall
	139321, --Braedan Whitewall
	131718, --Bramblewing
	126427, --Branchlord Aldrus
	142508, --Branchlord Aldrus
	134643, --Brgl-Lrgl the Basher
	137025, --Broodmother
	130508, --Broodmother Razora
	141615, --Burning Goliath
	135796, --Captain Leadfist
	125232, --Captain Mu'kala
	130897, --Captain Razorspine
	136346, --Captain Stef "Marrow" Quin
	132088, --Captain Wintersail
	139152, --Carla Smirk
	131704, --Coati
	124722, --Commodore Calhoun
	126187, --Corpse Bringer Yal'kar
	139968, --Corrupted Tideskipper
	136945, --Corvus
	129904, --Cottontail Matron
	141618, --Cresting Goliath
	142418, --Cresting Goliath
	140938, --Croaker
	136183, --Crushtacean
	133190, --Daggerjaw
	134897, --Dagrus the Scorned
	142688, --Darbel Montrose
	136428, --Dark Chronicler
	138039, --Dark Ranger Clea
	134760, --Darkspeaker Jo'la
	134706, --Deathcap
	139385, --Deepfang
	140925, --Doc Marrtens
	142741, --Doomrider Helgrim
	141668, --Echo of Myzrael
	129995, --Emily Mayville
	136335, --Enraged Krolusk
	134294, --Enraged Water Elemental
	138871, --Ernie
	134213, --Executioner Blackwell
	136323, --Fangcaller Xorreth
	133843, --First Mate Swainbeak
	131404, --Foreman Scripps
	142686, --Foulbelly
	132211, --Fowlmouth
	132127, --Foxhollow Skyterror
	126462, --Fozruk
	142433, --Fozruk
	133155, --G'Naat
	129954, --Gahz'ralka
	132007, --Galestorm
	137553, --General Krathax
	142662, --Geomancer Flintdagger
	138288, --Ghost of the Deep
	121242, --Glompmaw
	127844, --Gluttonous Yeti
	135448, --Gol'than the Malodorous
	129027, --Golanar
	124185, --Golrakahn
	129835, --Gorehorn
	138675, --Gorged Boar
	143559, --Grand Marshal Tremblade
	141059, --Grimscowl the Harebrained
	127129, --Grozgore
	139233, --Gulliver
	128674, --Gut-Gut the Glutton
	128426, --Gutrip
	127001, --Gwugnug the Cursed
	141226, --Haegol the Hammer
	134738, --Hakbi the Risen
	138618, --Haywire Golem
	134637, --Headhunter Lee'za
	127901, --Henry Breakwater
	143536, --High Warlord Volrath
	130443, --Hivemother Kraxi
	137183, --Honey-Coated Slitherer
	142725, --Horrific Apparition
	134754, --Hyo'gi
	141039, --Ice Sickle
	131735, --Idej the Wise
	124399, --Infected Direhorn
	137906, --Infused Bedrock
	141043, --Jakala the Cruel
	133373, --Jax'teb the Reanimated
	133527, --Juba the Scarred
	129283, --Jumbo Sandsnapper
	136341, --Jungleweb Hunter
	142475, --Ka'za the Mezmerizing
	124397, --Kal'draxa
	128686, --Kamid the Trapper
	126637, --Kandak
	132244, --Kiboku
	141029, --Kickers
	137681, --King Clickyclack
	129005, --King Kooba
	142739, --Knight-Captain Aldrin
	142112, --Kor'gresh Coldrage
	142684, --Kovork
	125214, --Krubbs
	120899, --Kul'krazahn
	131520, --Kulett the Ornery
	131233, --Lei-zhi
	133539, --Lo'kuno
	127877, --Longfang
	142434, --Loo'ay
	134296, --Lucille
	134106, --Lumbergrasp Sentinel
	138866, --Mack
	139290, --Maison the Portable
	128935, --Mala'kili
	142716, --Man-Hunter Rog
	143560, --Marshal Gabriel
	134112, --Matron Christiane
	137704, --Matron Morana
	128610, --Maw of Shul-Nagruth
	131252, --Merianae
	138870, --Mick
	141942, --Molok the Crusher
	134694, --Mor'fani the Exile
	127290, --Mugg
	134782, --Murderbeak
	138963, --Nestmother Acada
	130138, --Nevermore
	128951, --Nez'ara
	142692, --Nimar the Slayer
	122639, --Old R'gal
	141239, --Osca the Bloodied
	142423, --Overseer Krix
	124375, --Overstuffed Saurolisk
	139205, --P4-N73R4
	131262, --Pack Leader Asenya
	137649, --Pest Remover Mk. II
	139298, --Pinku'shon
	142435, --Plaguefeather
	142361, --Plaguefeather
	141286, --Poacher Zane
	143313, --Portakillo
	128974, --Queen Tzxi'kik
	125453, --Quillrat Matriarch
	142436, --Ragebeak
	142321, --Ragebeak
	132179, --Raging Swell
	134884, --Ragna
	139278, --Ranja
	137983, --Rear Admiral Hainsworth
	132047, --Reinforced Hullbreaker
	136340, --Relic Hunter Hazaak
	140593, --Restless Horror
	128707, --Rimestone
	128930, --Rohnkor
	139194, --Rotmaw
	126432, --Rumbling Goliath
	141620, --Rumbling Goliath
	142683, --Ruul Onestone
	139335, --Sabertron
	139328, --Sabertron
	139356, --Sabertron
	139359, --Sabertron
	139336, --Sabertron
	139988, --Sandfang
	127289, --Saurolisk Tamer Mugg
	139287, --Sawtooth
	127776, --Scaleclaw Broodmother
	136336, --Scorpox
	127820, --Scout Skrasniss
	127873, --Scrounger Patriarch
	138938, --Seabreaker Skoloth
	140997, --Severus the Outcast
	124475, --Shambling Ambusher
	139285, --Shiverscale the Toxic
	142690, --Singer
	136338, --Sirokar
	141143, --Sister Absinthe
	138863, --Sister Martha
	143316, --Skullcap
	142437, --Skullripper
	142312, --Skullripper
	125816, --Sky Queen
	134571, --Skycaller Teskris
	134745, --Skycarver Krakit
	139319, --Slickspill
	141175, --Song Mistress Dadalea
	136304, --Songstress Nahjeen
	137665, --Soul Goliath
	129836, --Spelltwister Moephus
	132280, --Squacks
	141088, --Squall
	139135, --Squirgle of the Depths
	137708, --Stone Golem
	136413, --Syrawon the Dominus
	139280, --Sythian the Swift
	126460, --Tainted Guardian
	139980, --Taja the Tidehowler
	129950, --Talon
	131687, --Tambano
	133356, --Tempestria
	139289, --Tentulos the Drifter
	131389, --Teres
	139358, --The Caterer
	136189, --The Lichen King
	142419, --Thundering Goliath
	141616, --Thundering Goliath
	133163, --Tia'Kawan
	143311, --Toadcruel
	127939, --Torraske the Eternal
	139235, --Tort Jaw
	126056, --Totem Maker Jash'ga
	132076, --Totes
	131984, --Twin-hearted Construct
	130643, --Twisted Child of Rezan
	122004, --Umbra'jin
	134717, --Umbra'rix
	134002, --Underlord Xerxiz
	128965, --Uroku the Bound
	130401, --Vathikur
	142438, --Venomarus
	142301, --Venomarus
	126926, --Venomjaw
	127651, --Vicemaul
	135939, --Vinespeaker Ratha
	132052, --Vol'Jim
	128584, --Vugthuth
	134048, --Vukuba
	133842, --Warcrawler Karkithiss
	129411, --Zunashi the Exile
	131476, --Zayoos
	130079, --Wagga Snarltusk
	129180, --Warbringer Hozzik
	126907, --Wardrummer Zurula
	134638, --Warlord Zothix
	134625, --Warmother Captive
	128973, --Whargarble the Ill-Tempered
	129803, --Whiplash
	133531, --Xu'ba
	129657, --Za'amar the Queen's Blade
	133812, --Zanxib
	128578, --Zujothgul
	138794, --Dunegorger Kraulok
	139322, --Whitney "Steelclaw" Ramsay
	140123, --Weaponmaster Halu
	140398, --Zeritarj
	142088, --Whirlwing
	142251, --Yogursa
	142440, --Yogursa
	142682, --Zalas Witherbark
	148154, --Agathe Wyrmwood
	149652, --Agathe Wyrmwood
	148787, --Alash'anir
	147951, --Alkalinius
	145292, --Alsian Vistreth
	147966, --Aman
	145392, --Ambassador Gaines
	148393, --Ancient Defender
	144855, --Apothecary Jerrod
	148679, --Arcanist Quintril
	147750, --Artillery Master Goodwin
	148037, --Athil Dewfire
	147708, --Athrikus Narassin
	148075, --Beast Tamer Watkins
	148477, --Beastlord Drakara
	148428, --Bilestomper
	149516, --Blackpaw
	149660, --Blackpaw
	148322, --Blinky Gizmospark
	148744, --Brewmaster Lin
	149141, --Burninator Mark V
	145415, --Cap'n Gorok
	147489, --Captain Greensails
	148676, --Caravan Commander Veronica
	145391, --Caravan Leader
	148550, --Caravan Leader
	148642, --Caravan Leader
	147845, --Commander Drald
	148025, --Commander Ral'esh
	147260, --Conflagros
	148144, --Croz Bloodrage
	149655, --Croz Bloodrage
	147241, --Cyclarus
	148257, --Death Captain Danielle
	148259, --Death Captain Delilah
	148253, --Death Captain Detheca
	148343, --Dinohunter Wildbeard
	148264, --Dinomancer Dajingo
	145278, --Dinomancer Zakuru
	148695, --Doctor Lazane
	145020, --Dolizite
	148510, --Drox'ar Morgar
	148563, --Duchess Fallensong the Frigid
	145465, --Engineer Bolthold
	148308, --Eric Quietfist
	148534, --Evezon the Eternal
	144915, --Firewarden Viton Darkflare
	146773, --First Mate Malone
	145308, --First Sergeant Steelfang
	145269, --Glimmerspine
	149654, --Glimmerspine
	147744, --Glrglrr
	147222, --Gnollfeaster
	146942, --Grand Marshal Fury
	147261, --Granokk
	148031, --Gren Tornfur
	149514, --Grimhorn
	149662, --Grimhorn
	148860, --Grizzwald
	147061, --Grubb
	144997, --Gurin Stonebinder
	146675, --Hartford Sternbach
	147240, --Hydrath
	148717, --Inquisitor Erik
	148597, --Iron Shaman Grimbeard
	148390, --Jessibelle Moonshield
	148456, --Jin'tago
	145395, --Katrianna
	147923, --Knight-Captain Joesiph
	148779, --Lightforged Warframe
	148723, --Maddok the Sniper
	145250, --Madfeather
	149657, --Madfeather
	148739, --Magister Crystalynn
	146651, --Mistweaver Nian
	147562, --Mortar Master Zapfritz
	145286, --Motega Bloodshield
	147701, --Moxo the Beheader
	147970, --Mrggr'marr
	148155, --Muk'luk
	149147, --N'chala the Egg Thief
	148092, --Nalaess Featherseeker
	146607, --Omgar Doombow
	147758, --Onu
	146979, --Ormin Rocketbop
	148147, --Orwell Stevenson
	149659, --Orwell Stevenson
	148651, --Overgrown Ancient
	148044, --Owynn Graddock
	148648, --Packmaster Swiftarrow
	148674, --Plague Master Herbert
	148403, --Portal Keeper Romiir
	148753, --Ptin'go
	148558, --Rockfury
	148494, --Sandbinder Sodir
	148103, --Sapper Odette
	145242, --Scalefiend
	149665, --Scalefiend
	148198, --Scout Captain Grizzleknob
	144987, --Shadow Hunter Mutumba
	148637, --Shadow Hunter Vol'tris
	149512, --Shadowclaw
	149663, --Shadowclaw
	147751, --Shattershard
	145466, --Shredatron-2000
	145161, --Siege Engineer Krackleboom
	148451, --Siege O' Matic 9000
	148231, --Siegebreaker Vol'gar
	148842, --Siegeotron
	148792, --Skycaptain Thermospark
	147897, --Soggoth the Slitherer
	147332, --Stonebinder Ssra'vess
	148759, --Stormcaller Morka
	146611, --Strong Arm John
	147435, --Thelar Moonstrike
	148813, --Thomas Vandergrief
	148276, --Tidebinder Maka
	147941, --Tidesage Clarissa
	144722, --Togoth Cruelarm
	147942, --Twilight Prophet Graeme
	147998, --Voidmaster Evenshade
	148446, --Wolfleader Skraug
	149383, --Xizz Gutshank
	145112, --Zagg Brokeneye
	148862, --Zillie Wunderwrench
	147664, --Zim'kaga
	148146, --Zul'aki the Headhunter
	145287, --Zunjo of Sen'jin
	148295, --Ivus the Decayed
	144946, --Ivus the Forest Lord
	149887, --Stanley
	149886, --Stanley
	152415, --Alga the Eyeless
	152416, --Allseer Oma'kil
	152794, --Amethyst Spireshell
	152566, --Anemonar
	151934, --Arachnoid Harvester
	154342, --Arachnoid Harvester
	150394, --Armored Vaultbot
	154968, --Armored Vaultbot
	150191, --Avarius
	152361, --Banescale the Packfather
	152712, --Blindlight
	153200, --Boilburn
	152001, --Bonepicker
	149653, --Carnivorous Lasher
	154739, --Caustic Mechaslime
	152464, --Caverndark Terror
	152556, --Chasm-Haunter
	149847, --Crazed Trogg
	152569, --Crazed Trogg
	152570, --Crazed Trogg
	152756, --Daggertooth Terror
	152291, --Deepglider
	151569, --Deepwater Maw
	152414, --Elder Unu
	152555, --Elderspawn Nalaada
	154153, --Enforcer KX-T57
	151159, --Fleetfoot
	151202, --Foul Manifestation
	135497, --Fungarian Furor
	152553, --Garnetscale
	153228, --Gear Checker Cogstar
	153205, --Gemicide
	154701, --Gorged Gear-Cruncher
	152736, --Guardian Tyr'mar
	152448, --Iridescent Glimmershell
	151684, --Jawbreaker
	152567, --Kelpwillow
	152007, --Killsaw
	152323, --King Gakula
	151933, --Malfunctioning Beastbot
	151124, --Mechagonian Nullifier
	151672, --Mecharantula
	144644, --Mirecrawler
	153000, --Motobrain Spider
	151627, --Mr. Fixthis
	152465, --Needlespine
	153206, --Ol' Big Tusk
	152397, --Oronu
	152764, --Oxidized Leachbeast
	151702, --Paol Pondwader
	152681, --Prince Typhonus
	152682, --Prince Vortran
	151296, --Rocket
	150583, --Rockweed Shambler
	150575, --Rumblerocks
	152182, --Rustfeather
	151870, --Sandcastle
	152795, --Sandclaw Stoneshell
	152548, --Scale Matriarch Gratinax
	152545, --Scale Matriarch Vynara
	152542, --Scale Matriarch Zodia
	150937, --Seaspit
	152552, --Shassera
	153658, --Shiz'narasz the Consumer
	152359, --Siltstalker the Packmother
	152290, --Soundless
	153226, --Steel Singer Freza
	152113, --The Kleptoboss
	154225, --The Rusty Prince
	151623, --The Scrap King
	151625, --The Scrap King
	153898, --Tidelord Aquatus
	153928, --Tidelord Dispersius
	154148, --Tidemistress Leth'sindra
	152360, --Toxigore the Alpha
	151940, --Uncle T'Rogg
	152568, --Urduu
	151719, --Voice in the Deeps
	150468, --Vor'koth
	152671, --Wekemara
	150342, --Earthbreaker Gulroc
	151308, --Boggac Skullbash
	155811, --Commander Minzera
	155838, --Incantatrix Vazina
	155583, --Scrapclaw
	155841, --Shadowbinder Athissa
	155836, --Theurgist Nitara
	155840, --Warlord Zalzjar
	155173, --Honeyback Usurper
	155055, --Gurg the Hivethief
	155176, --Old Nasha
	155171, --The Hivekiller
	155172, --Trapdoor Bee Hunter
	155059, --Yorag the Jelly Feaster
	152757, --Atekhramun
	157153, --Ha-Li
	160970, --Vuk'laz the Earthbreaker
	160532, --Shoth the Darkened
	151883, --Anaua
	152040, --Scoutmaster Moswen
	157266, --Kilxl the Gaping Maw
	151878, --Sun King Nahkotep
	157120, --Fangtaker Orsa
	151948, --Senbu the Pridefather
	157160, --Houndlord Ren
	157466, --Anh-De the Loyal
	158633, --Gaze of N'Zoth
	156083, --Sanguifang
	157176, --The Forgotten
	154332, --Voidtender Malketh
	157164, --Zealot Tekem
	154559, --Deeplord Zrihj
	158595, --Thoughtstealer Vos
	157170, --Acolyte Taspu
	157167, --Champion Sen-mat
	157146, --Rotfeaster
	157287, --Dokani Obliterator
	157267, --Escaped Mutation
	154106, --Quid
	157162, --Rei Lun
	154490, --Rijz'x the Devourer
	151897, --Sun Priestess Nubitt
	154394, --Veskan the Fallen
	151852, --Watcher Rehu
	154087, --Zror'um the Infinite
	154467, --Chief Mek-mek
	158632, --Corrupted Fleshbeast
	151995, --Hik-ten the Taskmaster
	160968, --Jade Colossus
	152657, --Tat the Bonechewer
	157468, --Tisiphon
	158557, --Actiss the Deceiver
	158531, --Corrupted Neferset Guard
	157171, --Heixi the Stonelord
	160631, --Hungering Miasma
	157134, --Ishak of the Four Winds
	159103, --Manipulator Shrog'lth
	160126, --Manipulator Yggshoth
	152677, --Nebet the Ascended
	161033, --Shadowmaw
	154578, --Aqir Flayer
	154447, --Brother Meller
	158597, --High Executor Yothrim
	157291, --Spymaster Hul'ach
	157279, --Stormhowl
	154600, --Teng the Awakened
	158284, --Craggle Wobbletop
	160623, --Hungering Miasma
	154495, --Will of N'Zoth
	160893, --Captain Vor'lek
	157593, --Amalgamation of Flesh
	160127, --Darkspeaker Shath'gul
	157290, --Jade Watcher
	160867, --Kzit'kovok
	161451, --Manipulator Yar'shath
	159318, --Shadow-Walker Yash'gth
	160906, --Skiver
	154576, --Aqir Titanus
	160878, --Buh'gzaki the Blasphemous
	156451, --Darkspeaker Thul'grsh
	158528, --High Guard Reshef
	160920, --Kal'tik the Blight
	152431, --Kaneb-ti
	156655, --Korzaran the Slaughterer
	156299, --R'khuzj the Unfathomable
	160341, --Sewer Beastling
	156654, --Shol'thoss the Doomspeaker
	158636, --The Grand Executor
	152788, --Uat-ka the Sun's Wrath
	157443, --Xiln the Mountain
	161463, --Depthcaller Velshen
	158594, --Doomsayer Vathiris
	160874, --Drone Keeper Ak'thet
	160876, --Enraged Amber Elemental
	160868, --Harrier Nir'verash
	154604, --Lord Aj'qirai
	160708, --Mail Muncher
	159087, --Corrupted Bonestripper
	160825, --Amber-Shaper Esh'ri
	158491, --Falconer Amenophis
	160810, --Harbinger Il'koxik
	161467, --Portalkeeper Jin'tashal
	160922, --Needler Zhesalla
	157188, --The Tomb Widow
	160841, --Blubbery Blobule
	157183, --Coagulated Anima
	156820, --Dod
	160805, --Gloopy Globule
	160826, --Hive-Guard Naz'ruzek
	160930, --Infused Amber Ooze
	161150, --Lesser Amber Elemental
	155958, --Tashara
	157157, --Muminah the Incandescent
	151609, --Sun Prophet Epaphos
	162141, --Zuythiz
	155703, --Anq'uri the Titanic
	157472, --Aphrom the Guise of Madness
	160872, --Destroyer Krox'tazar
	155531, --Infested Wastewander Captain
	156078, --Magus Rehleth
	157470, --R'aas the Anima Devourer
	157390, --R'oyolok the Reality Eater
	157476, --Shugshul the Flesh Gorger
	157473, --Yiphrim the Will Ravager
	157469, --Zoth'rum the Intellect Pillager
	161683, --Antak'shal
	162142, --Qho
	162170, --Warcaster Xeshro
	162171, --Captain Dunewalker
	162163, --High Priest Ytaessis
	162196, --Obsidian Annihilator
	162172, --Aqir Warcaster
	162147, --Corpse Eater
	162173, --R'krox the Runt
	162140, --Skikx'traz
	162370, --Armagedillo
	162352, --Spirit of Dark Ritualist Zakahn
	162372, --Spirit of Cyrus the Black
	154154, --Honey Smasher
	152961, --Data Anomaly
	152979, --Data Anomaly
	152983, --Data Anomaly
	152958, --Data Anomaly
	152922, --Data Anomaly
	152923, --Data Anomaly
	153486, --Data Anomaly
}
