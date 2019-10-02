-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

private.RARE_LIST = {
	-- Rares Pandaria
	50062, --Aeonaxx
	58778, --Aetha
	50750, --Aethis
	50817, --Ahone the Wanderer
	50821, --Ai-Li Skymirror
	50822, --Ai-Ran the Shifting Cloud
	70000, --Al'tabim the All-Seeing
	54318, --Ankha
	54338, --Anthriss
	73174, --Archiereus of Flame
	73666, --Archiereus of Flame
	70243, --Archritualist Kelada
	50787, --Arness the Scale
	70001, --Backbreaker Uru
	58949, --Bai-Jin the Butcher
	54320, --Ban'thalos
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
	54322, --Deth'tilac
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
	50051, --Ghostcrawler
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
	49822, --Jadefang
	73169, --Jakur of Ordon
	50351, --Jonn-Dar
	50355, --Kah'tir
	50749, --Kal'tik the Blight
	50349, --Kang the Soul Thief
	68321, --Kar Warmaker
	72193, --Karkanos
	50959, --Karkin
	50138, --Karoma
	50347, --Karr the Darkener
	54323, --Kirix
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
	54319, --Magria
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
	50085, --Overlord Sunderfury
	54533, --Prince Lakma
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
	50159, --Sambas
	50782, --Sarnak
	50831, --Scritch
	50766, --Sele'na
	63240, --Shadowmaster Sydow
	50791, --Siltriss the Sharpener
	50815, --Skarr
	50733, --Ski'thik
	54324, --Skitterflame
	54321, --Solix
	71864, --Spelurk
	72769, --Spirit of Jadefire
	58817, --Spirit of Lao-Fe
	50830, --Spriggin
	73704, --Stinkbraid
	50339, --Sulik'shor
	50086, --Tarvus the Vile
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
	
	-- Rares Draenor
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
	77763, --Deadshot Kizi
	82058, --Depthroot
	86729, --Direhoof
	77561, --Dr. Gloom
	84807, --Durkath Steelmaw
	77768, --Elementalist Utrah
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
	77648, --Forge Matron Targa
	85250, --Fossilwood the Petrified
	77614, --Frenzied Golem
	78713, --Galzomar
	82764, --Gar'lua
	86058, --Garrison Ford
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
	77095, --Pathstalker Draga
	88208, --Pit Beast
	84838, --Poisonmaster Bortusk
	76918, --Primalist Mur'og
	77642, --Pyrecaster Zindra
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
	77926, --Vulceros
	77776, --Wandering Vindicator
	78733, --Warcaster Bargol
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
	
	-- Rares Draenor 6.2
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
	90081, --Dark Summoner Rendkra
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
	90089, --Grobthok Skullbreaker
	90094, --Harbormaster Korak
	90281, --High Priest Ikzan
	90777, --High Priest Ikzan
	90429, --Imp-Master Valessa
	90087, --Iron Captain Argha
	90437, --Jax'zor
	92517, --Krell the Serene
	93279, --Kris'kar the Unredeemed
	90438, --Lady Oran
	93002, --Magwia
	90442, --Mistress Thavra
	90088, --Ormak Bloodbolt
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
	
	-- Rares Draenor 6.2.1
	98200, --Guk
	98199, --Pugg
	98198, --Rukdug
	98283, --Drakum
	98284, --Gondar
	98285, --Smashum Grabb
	98408, --Fel Overseer Mudlump
	96323, --Arachnis
	97209, --Eraakis

	-- Rares Legion	
	110378, --Drugon the Frostblood
	99929, --Flotsam
	108879, --Humongris
	107544, --Nithogg
	108678, --Shar'thos
	100230, --"Sure-Shot" Arnie
	97348, --Abesha
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
	103801, --Arthfael
	106351, --Artificer Lothaire
	92633, --Assassin Huwe
	112758, --Auditor Esiel
	112759, --Az'jatar
	103787, --Baconlisk
	110562, --Bahagar
	97637, --Barax the Mauler
	91187, --Beacher
	111454, --Bestrix
	107327, --Bilebrain
	91874, --Bladesquall
	92599, --Bloodstalker Alpha
	98361, --Bloody Raven
	98299, --Bodash the Hoarder
	98178, --Boulderfall
	109113, --Boulderfall, the Eroded
	107127, --Brawlgoth
	106863, --Brinebeard the Risen
	97449, --Bristlemaul
	91100, --Brogozog
	94877, --Brogrul the Mighty
	107105, --Broodmother Lizax
	105632, --Broodmother Shu'malis
	102863, --Bruiser
	111463, --Bulvinkel
	110726, --Cadraeus
	91289, --Cailyn Paledoom
	92685, --Captain Brvet
	109163, --Captain Dargun
	89846, --Captain Volo'ren
	92604, --Champion Elodie
	101596, --Charfeather
	106990, --Chief Bitterbrine
	109677, --Chief Treasurer Jabrill
	111674, --Cinderwing
	104698, --Colerian
	104519, --Colerian
	107266, --Commander Soraax
	100864, --Cora'kar
	93778, --Coruscating Bloom
	97058, --Count Nefarious
	108255, --Coura, Mistress of Arcana
	97933, --Crab Rider Grmlrml
	97345, --Crawshuk the Hungry
	90050, --Crystalbeard
	105619, --Cyrilline
	90057, --Daggerbeak
	94313, --Daniel "Boomer" Vorick
	100231, --Dargok Thunderuin
	92631, --Dark Ranger Jess
	92205, --Darkest Fear
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
	93088, --Direclaw
	91579, --Doomlord Kazrok
	109727, --Dorbash the Smasher
	108543, --Dread Captain Thedon
	108541, --Dread Corsair
	108531, --Dread Ship Krazatoa
	94347, --Dread-Rider Cortis
	97517, --Dreadbog
	96072, --Durguth
	110367, --Ealdis
	96647, --Earlnoc the Beastbreaker
	98188, --Egyl the Enduring
	99792, --Elfbane
	93372, --Enraged Earthservant
	109728, --Ettin
	91803, --Fathnyr
	98225, --Fathnyr
	105938, --Felwing
	92040, --Fenri
	98276, --Fenri
	109584, --Fjordun
	108827, --Fjorlag, the Grave's Chill
	97793, --Flamescale
	89884, --Flog the Captain-Eater
	101649, --Frostshard
	109729, --Fury
	99610, --Garvrulg
	93679, --Gathenak the Subjugator
	97370, --General Volroth
	91529, --Glimar Ironfist
	95988, --Globulus
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
	91649, --Hivequeen Zsala
	92590, --Hook
	107169, --Horux
	92951, --Houndmaster Ely
	107136, --Houndmaster Stroxis
	110486, --Huk'roth the Huntmaster
	108822, --Huntress Estrid
	100067, --Hydrannon
	92199, --Image of Ursoc
	92200, --Image of Ursol
	92189, --Imagined Horror
	109630, --Immolian
	90803, --Infernal Lord
	90139, --Inquisitor Ernstenbok
	107269, --Inquisitor Tivos
	106532, --Inquisitor Volitix
	93993, --Insatiable Gorger
	93030, --Ironbranch
	94413, --Isel the Hammer
	109957, --Isel the Hammer
	92751, --Ivory Sentinel
	103975, --Jade Darkhaven
	101467, --Jaggen-Ra
	109500, --Jak
	103203, --Jetsam
	93686, --Jinikki the Puncturer
	96208, --Jubei'thos
	94636, --Kalazzius the Guileful
	111731, --Karthax
	109125, --Kathaw the Savage
	96997, --Kethrazor
	101063, --King Forgalash
	103827, --King Morgalash
	97059, --King Voras
	94414, --Kiranys Duskwhisper
	96212, --Korda Torros
	111573, --Kosumoth the Hungering
	98421, --Kottr Vondyr
	103271, --Kraxa
	96210, --Krol the Blade
	99362, --Kudzilla
	106526, --Lady Rivantas
	109015, --Lagertha
	102303, --Lieutenant Strathmar
	100516, --Lilin the Ravenous
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
	111055, --Monstrous Plague Rat
	93371, --Mordvigbjorn
	93622, --Mortiferous
	91780, --Mother Clacker
	89865, --Mrrgrl the Tide Reaver
	98311, --Mrrklr
	97593, --Mynta Talonscreech
	110340, --Myonix
	101641, --Mythana
	107477, --N.U.T.Z.
	108016, --Necromagus Toldrethar
	110451, --Nightmare Crystal
	106165, --Nightmare WardenNOT SPAWNED
	107023, --Nithogg
	90248, --Normantis the Deposed
	90217, --Normantis the Deposed
	90253, --Normantis the Deposed
	105657, --Notgarn
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
	110364, --Pale Dreadwing
	113694, --Pashya
	95318, --Perrexx
	107846, --Pinchshank
	103045, --Plaguemaw
	94485, --Pollous the Fetid
	108010, --Powdermaster Maclin
	90901, --Pridelord Meowl
	92613, --Priestess Liza
	100302, --Puck
	108256, --Quin'el, Master of Chillwind
	110342, --Rabxach
	101660, --Rage Rot
	109504, --Ragemaw
	99846, --Raging Earth
	103199, --Ragoul
	97102, --Ram'Pag
	92140, --Rampant Mandragora
	111007, --Randril
	105547, --Rauren
	89016, --Ravyn-Drath
	103575, --Reef Lord Raj'his
	103183, --Rok'nash
	110363, --Roteye
	109317, --Rulf Bonesnapper
	109318, --Runeseer Sigvid
	100232, --Ryael Dawndrifter
	111010, --Saepher
	111069, --Saepher
	100184, --Sailor's Nightmare
	105739, --Sanaar
	105728, --Scythemaster Cil'raman
	111434, --Sea King Tidross
	92180, --Seersei
	101077, --Sekhan
	104522, --Selenyi
	108251, --Selia, Master of Balefire
	103841, --Shadowquill
	109054, --Shal'an
	104523, --Shalas'aman
	97093, --Shara Felbreath
	91788, --Shellmaw
	103605, --Shroudseeker
	108794, --Shroudseeker's Shadow
	92090, --Shyama the Dreaded
	110438, --Siegemaster Aedrin
	111052, --Silver Serpent
	112636, --Sinister Leyrunner
	92591, --Sinker
	93654, --Skul'vrax
	95872, --Skullhat
	111021, --Sludge Face
	98890, --Slumber
	92725, --Son of Goredome
	112756, --Sorallus
	109195, --Soulbinder Halldora
	108494, --Soulfiend Tagerma
	97630, --Soulthirster
	107487, --Starbuck
	109594, --Stormfeather
	109994, --Stormtalon
	91795, --Stormwing Matriarch
	98309, --Sunbreeze [DO NOT SPAWN]
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
	95440, --Tremblade
	91663, --Trubble
	108881, --Turtle
	103247, --Ultanok
	109708, --Undergrell Ringleader
	93401, --Urgev the Flayer
	109575, --Valakar the Thirsty
	109606, --Valitos
	89650, --Valiyaka the Stormbringer
	99899, --Vicious Whale Shark
	91640, --Vinyeaty
	91661, --Vinyeti
	89906, --Vinyeti
	112760, --Volshax, Breaker of Will
	107113, --Vorthax
	100224, --Vrykul Earthmaiden Spirit
	100223, --Vrykul Earthshaper Spirit
	90164, --Warbringer Mox'na
	102092, --Warlord Vatilash
	107431, --Weaponized Rabbot
	103785, --Well-Fed Bear
	92152, --Whitewater Typhoon
	109648, --Witchdoctor Grgl-Brgl
	97504, --Wraithtalon
	97069, --Wrath-Lord Lekos
	109498, --Xaander
	104831, --Xavrix
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
	
	-- Rares Legion 7.1.0
	115847, --Ariadne
	116185, --Attendant Keeper
	115853, --Doomlash
	116230, --Exotic Concubine
	116004, --Flightmaster Volnath
	116008, --Kar'zun
	116395, --Nightwell Diviner
	116036, --Regal Cloudwing
	116059, --Regal Cloudwing
	116034, --The Cow King
	115914, --Torm the Brute
	116158, --Tower Concubine
	116652, --Treasure Goblin
	116159, --Wily Sycophant
	89407, --Wrymtongue Hoarder
	116041, --Treasure Goblin
	
	-- Rares Legion 7.1.5
	118244, --Lightning Paw
	115537, --Lorthalium
	
	-- Rares Legion 7.2.0
	121124, --Apocron
	117303, --Malificus
	117470, --Si'vash
	116666, --Abyssal Ember
	120675, --An'thyna
	116657, --Angered Sea Giant
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
	116671, --Emberon
	120020, --Erdu'val
	116166, --Eye of Gurgh
	120681, --Fel Obliterator
	117093, --Felbringer Xar'thok
	117103, --Felcaller Zelthae
	117342, --Felhound
	117091, --Felmaw Emberfiend
	120998, --Flllurlokkr
	120665, --Force-Commander Xillious
	117493, --Grimtotem Warrior
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
	116912, --Mo'arg Brute
	116668, --Mor'tec the Soulslaver
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
	116316, --Zirux
	112712, --Gilded Guardian
	
	-- Rares Legion 7.2.5
	123087, --Al'Abas
	122524, --Bloodfeast
	122521, --Bonesunder
	122899, --Death Metal Knight
	122519, --Dregmar Runebrand
	122520, --Icefist
	122522, --Iceshatter
	122609, --Xavinox
	
	-- Rares Legion 7.3.0
	127090, --Admiral Rel'var
	127096, --All-Seer Xanarian
	126887, --Ataxon
	126862, --Baruut the Bloodthirsty
	122958, --Blistermaw
	124479, --Blisterwing
	126869, --Captain Faruq
	127376, --Chief Alchemist Munculus
	124775, --Commander Endaxis
	122912, --Commander Sathrenael
	127084, --Commander Texlaz
	122911, --Commander Vecaya
	126910, --Commander Xethgar
	122457, --Darkcaller
	127703, --Doomcaster Suprax
	127341, --Everburning Doombringer
	124717, --Executioner Vaal
	124684, --Eye of the Torturer
	126864, --Feasel the Muffin Thief
	122999, --Gar'zoth
	126896, --Herald of Chaos
	124412, --Houndcaller Orox
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
	124572, --Pyromancer Volarr
	127706, --Rezira the Seer
	126898, --Sabuul
	122838, --Shadowcaster Voruun
	120393, --Siegemaster Voraan
	123464, --Sister Subversia
	126912, --Skreeg the Devourer
	126913, --Slithon the Last
	126889, --Sorolis the Ill-Fated
	127704, --Soultender Videx
	126815, --Soultwisted Monstrosity
	127700, --Squadron Commander Vishax
	123689, --Talestra the Vile
	125479, --Tar Spitter
	124804, --Tereck the Selector
	127581, --The Many-Faced Devourer
	126868, --Turek the Lucid
	127906, --Twilight-Harbinger Tharuul
	126691, --Tyrannosaurus Rekt
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
	124680, --Zul'zoloth
	
	-- Rares Legion 7.3.5
	133044, --Grand Marshal Tremblade
	133043, --High Warlord Volrath
	125951, --Obsidian Deathwarder
	132591, --Ogmot the Mad
	132578, --Qroshekx
	133042, --Sky Marshall Gabriel
	132580, --Ssinkrix
	132584, --Xaarshej
	
	-- Rares BFA 8.0.1
	136385, --Azurethos
	140252, --Hailstone Construct
	132253, --Ji'arak
	132701, --T'zane
	140163, --Warbringer Yenajz
	139767, --"Spyglass" Marie
	134798, --Abyss Crawler
	138279, --Adhara White
	140474, --Adherent of the Abyss
	135852, --Ak'tar
	138948, --Akakakoo
	140695, --Albino Dreadfang
	136049, --Algenon
	139229, --Aluna Leaf-Sister
	138486, --Aluriak
	122955, --Ambassador Terrick
	138846, --Amberwinged Mindsinger
	140090, --Ana'tashe
	139350, --Anaha Witherbreath
	129660, --Ancient Armor
	125250, --Ancient Jawbreaker
	134807, --Ancient Spineshell
	139758, --Annie Two-Pistols
	140268, --Ano Forest-Keeper
	139041, --Aquamancer Lushu
	139403, --Arassaz the Invader
	137824, --Arclight
	139679, --Argl
	140109, --Armored Deathflayer
	137529, --Arvon the Betrayed
	138639, --Asennu
	135721, --Asha'ne
	130439, --Ashmane
	135931, --Ashstone
	129961, --Atal'zul Gotaka
	138514, --Athiona
	132182, --Auditor Dolp
	140829, --Autumnbreeze
	137825, --Avalanche
	129343, --Avatar of Xolotal
	140066, --Axeclaw
	128553, --Azer'tor
	134298, --Azerite-Infused Elemental
	134293, --Azerite-Infused Slag
	138511, --Azurescale
	122606, --Azurewing
	143931, --Azurewing
	136877, --Baba Gufa
	139598, --Backbreaker Bahaha
	139442, --Backbreaker Zukan
	139348, --Baga the Frostshield
	134539, --Bajiani the Slick
	128497, --Bajiani the Slick
	126142, --Bajiatha
	130143, --Balethorn
	143314, --Bane of the Woods
	139873, --Banechitter
	136886, --Banner-Bearer Koral
	127333, --Barbthorn Queen
	129181, --Barman Bill
	135929, --Baron Blazehollow
	136854, --Baruun Flinthoof
	132068, --Bashmu
	138447, --Battle-Maiden Salaria
	138847, --Battle-Mender Ka'vaz
	132837, --Beach Strider
	142709, --Beastrider Kama
	136853, --Beefa Warbeard
	134147, --Beehemoth
	138828, --Berhild the Fierce
	139347, --Berserker Gola
	136000, --Beryllus
	129805, --Beshol
	124548, --Betsy
	140660, --Big-Horn
	132319, --Bilefang Mother
	140158, --Bilesoaked Rotclaw
	138393, --Biter
	132086, --Black-Eyed Bart
	139145, --Blackthorne
	138848, --Blade-Dancer Zorlak
	140560, --Blazeseeker
	139681, --Bleakfin
	138667, --Blighted Monstrosity
	129476, --Bloated Krolusk
	126635, --Blood Priest Xak'lar
	137062, --Blood-Hunter Akal
	136991, --Blood-Hunter Dazal'ai
	140692, --Bloodbore
	128699, --Bloodbulge
	134908, --Bloodfang
	140440, --Bloodfur the Gorer
	138299, --Bloodmaw
	139023, --Bloodmaw the Savage
	136859, --Bloodscalp
	140070, --Bloodscent the Tracker
	139871, --Bloodseeker Kilthix
	134806, --Bloodsnapper
	140064, --Bloodsoaked Grizzlefur
	136011, --Bloodstone
	135646, --Bloodstripe the Render
	139021, --Bloodtracker
	136393, --Bloodwing Bonepicker
	129969, --Bloodwitch Ysinna
	138827, --Bodalf the Strong
	139420, --Bog Defender Vaszash
	140160, --Boilhide the Raging
	140330, --Boneclatter
	126621, --Bonesquall
	136874, --Bonk
	138392, --Bono
	138986, --Borgl the Seeker
	137158, --Bound Lightning Elemental
	136043, --Brackish
	139321, --Braedan Whitewall
	140453, --Bramblefur Herdleader
	139213, --Bramblestomp
	131718, --Bramblewing
	139190, --Branch-Leaper the Swift
	126427, --Branchlord Aldrus
	142508, --Branchlord Aldrus
	134643, --Brgl-Lrgl the Basher
	138244, --Briarwood Bulwark
	140836, --Brightfire
	139701, --Brineshell Minor Oracle
	139700, --Brineshell Sea Shaman
	140658, --Bristlefur
	134947, --Bristlethorn Broodqueen
	140266, --Broken-Horn the Ancient
	137025, --Broodmother
	133158, --Broodmother Chimal
	130508, --Broodmother Razora
	140547, --Broodqueen Cindrix
	140545, --Broodqueen Flareanae
	140553, --Broodqueen Shuzasz
	140546, --Broodqueen Vyl'tilac
	139882, --Broodwatcher Anub'akar
	139880, --Broodwatcher Tal'nadix
	139881, --Broodwatcher Taldim-Ra
	138633, --Brother Maat
	135724, --Brushstalker
	139594, --Brusier Gor
	140180, --Brutalgore
	136892, --Brutalsnout
	139471, --Bugan the Flesh-Crusher
	139593, --Burk the Literate
	141615, --Burning Goliath
	139354, --Butun the Boneripper
	139763, --Cannonmaster Arlin
	140075, --Canus
	135796, --Captain Leadfist
	125232, --Captain Mu'kala
	130897, --Captain Razorspine
	136346, --Captain Stef "Marrow" Quin
	132088, --Captain Wintersail
	139152, --Carla Smirk
	124582, --Chasm-Hunter
	140428, --Chasm-Jumper
	123270, --Chef Gru
	139817, --Chief Engineer Zazzy
	140332, --Chitterbore
	134909, --Chittering Spindleweb
	138481, --Chromitus
	140548, --Cinderfang Ambusher
	136856, --Cinderhorn
	129830, --Clackclaw the Behemoth
	140114, --Clatterclaw
	139698, --Clattercraw the Oracle
	134764, --Clattershell
	135649, --Clawflurry
	138630, --Cleric Izzad
	136799, --Cliffbreaker
	140860, --Cliffracer
	140341, --Cloudscraper
	140800, --Cloudwing the Killthief
	140338, --Cltuch Guardian Jinka'lo
	136802, --Coalbiter
	131704, --Coati
	139466, --Cobalt Stoneguard
	138635, --Commander Husan
	138845, --CommanderJo'vak
	124722, --Commodore Calhoun
	126187, --Corpse Bringer Yal'kar
	140992, --Corpseburster
	140370, --Corpsefeaster
	140797, --Corpseharvest
	139968, --Corrupted Tideskipper
	136945, --Corvus
	129904, --Cottontail Matron
	134801, --Cracked-Shell
	140970, --Cragburster
	140798, --Cragcaw
	140851, --Cragg
	140427, --Craghoof Herdfather
	136805, --Cragreaver
	140181, --Cragtusk
	135046, --Crawmog
	139027, --Crescent Oracle
	141618, --Cresting Goliath
	142418, --Cresting Goliath
	138506, --Crimsonscale
	140938, --Croaker
	140162, --Crunchsnap the Vice
	126451, --Crushclaw
	140084, --Crushknuckle
	140684, --Crushstomp
	136183, --Crushtacean
	136045, --Crushtide
	140369, --Cryptseeker
	132879, --Crystalline Giant
	136990, --Cursed Ankali
	139756, --Cutthroat Sheila
	135837, --Cyclonic Lieutenant
	140696, --Da'zu the Feared
	133190, --Daggerjaw
	130644, --Daggertooth
	134897, --Dagrus the Scorned
	140296, --Dampfur the Musky
	133995, --Dangerpearl
	132877, --Dankscale
	142688, --Darbel Montrose
	138890, --Dargulf the Spirit-Seeker
	136428, --Dark Chronicler
	138039, --Dark Ranger Clea
	123001, --Dark Water
	140683, --Darkfur the Smasher
	134911, --Darkhollow Widow
	134794, --Darklurker
	140361, --Darkshadow the Omen
	134760, --Darkspeaker Jo'la
	139391, --Darkwave Assassin
	138016, --Darokk
	135644, --Dawnstalker
	139352, --Death-Caller Majuli
	134706, --Deathcap
	134767, --Deathclaw Egg-Mother
	139345, --Deathwhisperer Kulu
	139761, --Deckmaster O'Rourke
	139040, --Deep Oracle Unani
	140996, --Deepbore
	139385, --Deepfang
	139020, --Deepgrowl the Ferocious
	140674, --Deephowl
	139674, --Deepscale
	140773, --Deepsea Tidecrusher
	140331, --Deeptunnel Ambusher
	139872, --Defender Zakar
	140675, --Den Mother Mugo
	139677, --Depth-Caller
	140392, --Direbore of the Thousand Tunnels
	140062, --Diremaul
	140072, --Direprowl the Ravager
	136888, --Dirt-Speaker Barrul
	138638, --Djar
	140925, --Doc Marrtens
	134109, --Dominated Hydra
	142741, --Doomrider Helgrim
	140978, --Doomtunnel
	140451, --Doting Calfmother
	139344, --Drakani Death-Defiler
	119000, --Dreadbeard
	140159, --Dreadgrowl the Pustulent
	139874, --Dreadswoop
	135648, --Driftcoat
	140429, --Drifthopper the Swift
	140799, --Driftstalker
	133971, --Drukengu
	138445, --Duke Szzull
	140161, --Duneburrower
	137060, --Dunecaster Mu'na
	140795, --Dunecircler the Bleak
	140450, --Dunu the Blind
	139439, --Duskbinder Zuun
	126101, --Duskcoat Huntress
	135719, --Duskrunner
	136861, --Duskstalker Kuli
	140861, --Duster
	130338, --Dustfang
	136808, --Dusthide
	140672, --Dusthide the Mangy
	135829, --Dustwind
	138996, --Earth-Speaker Juwa
	139530, --Earth-Wrought Siegebreaker
	123347, --Earthcaller Malan
	140760, --Earthliving Giant
	140842, --Ebb
	141668, --Echo of Myzrael
	139026, --Eclipse-Caller
	139877, --Egg-Tender Kahasz
	140371, --Egg-Tender Ny'xik
	139878, --Elder Akar'azan
	140168, --Elder Chest-Thump
	140662, --Elder Greatfur
	139217, --Elder Many-Blooms
	140170, --Elder Mokka
	138999, --Elder Ordol
	135645, --Elder Pridemother
	139000, --Elder Yur
	140974, --Eldercraw
	140685, --Elderhorn
	140391, --Emerald Deepseeker
	130016, --Emily Mayville
	129995, --Emily Mayville
	138515, --Endalion
	136335, --Enraged Krolusk
	134294, --Enraged Water Elemental
	138871, --Ernie
	139039, --Eso the Fathom-Hunter
	139211, --Everbloom
	138505, --Evolved Clutch-Warden
	134213, --Executioner Blackwell
	136010, --Faceted Earthbreaker
	136323, --Fangcaller Xorreth
	134950, --Fanged Terror
	139407, --Fangterror
	138446, --Fathom-Caller Zelissa
	139675, --Fathom-Seeker
	134799, --Fathomclaw
	136051, --Fathomus
	140671, --Feralclaw the Rager
	139755, --First Mate McNally
	133843, --First Mate Swainbeak
	140550, --Flamechitter
	132743, --Flamescale Wavebreaker
	140555, --Flare Mongrel
	140987, --Fleshmelter the Insatiable
	140854, --Flow
	131404, --Foreman Scripps
	140272, --Forest-Strider
	139386, --Forked-Tongue
	139766, --Former Navigator Dublin
	142686, --Foulbelly
	132211, --Fowlmouth
	132127, --Foxhollow Skyterror
	126462, --Fozruk
	140757, --Fozruk
	142433, --Fozruk
	139768, --Freebooter Dan
	132448, --Frostbeard the Candlekeeper
	140763, --Frosthill Giant
	132746, --Frostscale Broodmother
	140774, --Frozen Stonelord
	140680, --Frozenhorn Rampager
	133155, --G'Naat
	129954, --Gahz'ralka
	135830, --Galefury
	132007, --Galestorm
	131410, --Gargantuan Venomscale
	139412, --Gashasz
	135225, --Geirn the Windmill
	139421, --Gekkaz Moss-Scaled
	140777, --Gemshard Colossus
	140385, --Gemshell Broodkeeper
	138504, --General Drakkarion
	138574, --General Erxuul
	137553, --General Krathax
	138573, --General Nu'aggth
	138575, --General Shuul'aqar
	138572, --General Uvosh
	138444, --General Vesparak
	136278, --General Zaviul
	142662, --Geomancer Flintdagger
	138288, --Ghost of the Deep
	140299, --Ghostfang
	140082, --Gibb
	139672, --Gibberfin
	132892, --Giddyleaf
	140676, --Gigantic Stoneback
	140864, --Gigglefit
	140682, --Glacierfist
	139599, --Gladiator Ortugg
	140089, --Gloamhoof the Elder
	121242, --Glompmaw
	134793, --Glowspine
	127844, --Gluttonous Yeti
	140981, --Gnashing Horror
	140298, --Gol'kun the Vicious
	135448, --Gol'than the Malodorous
	129027, --Golanar
	140769, --Goldenvein
	136813, --Goldsniffer
	124185, --Golrakahn
	139596, --Gordo the Oracle
	129835, --Gorehorn
	130584, --Gorespike
	136050, --Gorestream
	138675, --Gorged Boar
	140694, --Gorgejaw the Glutton
	139588, --Gorkul the Unstoppable
	143559, --Grand Marshal Tremblade
	139349, --Grave-Caller Muja
	136003, --Gravellus
	136804, --Gravelspine
	138997, --Grawlash the Frenzied
	140097, --Great Dirtbelly
	134946, --Great Huntsman
	136863, --Great Mota
	140147, --Great Ursu
	140979, --Greatfangs
	140267, --Greathorn Uwanu
	140435, --Greyfur
	135838, --Grimebreeze
	141059, --Grimscowl the Harebrained
	134822, --Gritplate Matriarch
	140061, --Grizzlefur Den-Mother
	124580, --Grotto Terrapin
	136893, --Groundshaker Aggan
	127129, --Grozgore
	138991, --Grrl
	138632, --Guardian Asuda
	139431, --Guardian of Tombs
	139233, --Gulliver
	139355, --Guran the Frostblade
	138993, --Gurlack
	137057, --Gurthani the Elder
	140681, --Gurudu The Gorge
	128674, --Gut-Gut the Glutton
	128426, --Gutrip
	140768, --Guuru the Mountain-Breaker
	127001, --Gwugnug the Cursed
	141226, --Haegol the Hammer
	134738, --Hakbi the Risen
	138824, --Halfid Ironeye
	138569, --Harbinger Vor'zzyx
	134800, --Hardened Snapjaw
	139406, --Hassan the Bloody Scale
	138618, --Haywire Golem
	139760, --Head Navigator Franklin
	136878, --Headbang
	140080, --Headbasher
	134637, --Headhunter Lee'za
	137059, --Headshrinker Gaha
	135999, --Heliodor
	127901, --Henry Breakwater
	138637, --Hephet
	138570, --Herald Razzaqi
	137058, --Hexxer Magoda
	139595, --High Guard Makag
	139419, --High Oracle Asayza
	139404, --High Prophet Massas
	139697, --High Shaman Claxikar
	139601, --High Shaman Morg
	143536, --High Warlord Volrath
	140693, --Hisskarath
	140372, --Hive Guardian Ksh'ix
	140374, --Hive Guardian Yx'nil
	138849, --Hivelord Vix'ick
	130443, --Hivemother Kraxi
	138647, --Hjana Fogbringer
	139875, --Hollow Widow
	137183, --Honey-Coated Slitherer
	138370, --Horko
	142725, --Horrific Apparition
	138831, --Horvuld Oceanscythe
	138653, --Hosvir of the Rotting Hull
	135923, --Hound of Gazzran
	137140, --Hulking Charger
	140110, --Hydralurk
	134754, --Hyo'gi
	141039, --Ice Sickle
	140982, --Icecracker
	136047, --Iceheart
	131735, --Idej the Wise
	124399, --Infected Direhorn
	140558, --Inferno Terror
	137906, --Infused Bedrock
	138825, --Ingathora Blood-Drinker
	138829, --Ingel the Cunning
	136890, --Iron Orkas
	139188, --Ironfur
	136850, --Ironhide Dulan
	132913, --Island Ettin
	135647, --Ituakee
	139475, --Jade-Formed Bonesnapper
	140857, --Jadeflare
	134769, --Jagged Claw
	139764, --Jaime the Cutlass
	141043, --Jakala the Cruel
	136858, --Jan'li
	133373, --Jax'teb the Reanimated
	140387, --Jeweled Queen
	133527, --Juba the Scarred
	129283, --Jumbo Sandsnapper
	124927, --Jun-Ti
	126169, --Jungle King Runtu
	140079, --Jungle-Screamer
	136341, --Jungleweb Hunter
	142475, --Ka'za the Mezmerizing
	139038, --Kaihu
	124397, --Kal'draxa
	138482, --Kaluriak the Alchemist
	128686, --Kamid the Trapper
	122062, --Kamul Cloudsong
	126637, --Kandak
	139227, --Keeper Undarius
	130791, --Khut'een
	132244, --Kiboku
	141029, --Kickers
	134936, --Kil'tilac
	136852, --Kilnkeeper Odo
	136835, --Kin'toga Beastbane
	137681, --King Clickyclack
	129005, --King Kooba
	140081, --King Lukka
	134796, --King Spineclaw
	142739, --Knight-Captain Aldrin
	123269, --Kook
	142112, --Kor'gresh Coldrage
	142684, --Kovork
	129832, --Krack
	125214, --Krubbs
	138564, --Kshuun
	120899, --Kul'krazahn
	140083, --Kula the Thunderer
	131520, --Kulett the Ornery
	138388, --Kung
	138440, --Lady Assana
	134707, --Lady Seirine
	136879, --Lava-Eater Mabutu
	135930, --Lavarok
	134903, --Leeching Horror
	131233, --Lei-zhi
	138826, --Leikneir the Brave
	139218, --Life-Tender Olvarius
	139680, --Lightless Hunter
	133539, --Lo'kuno
	127877, --Longfang
	140092, --Longstrider
	142434, --Loo'ay
	136046, --Lord Abyssian
	135936, --Lord Amar'zan
	135994, --Lord Amythite
	136042, --Lord Aquanoth
	138436, --Lord Coilfin
	135842, --Lord Fruzaan
	135933, --Lord Gazzran
	118172, --Lord Hydronicus
	135934, --Lord Incindivar
	135960, --Lord Jaggruk
	135845, --Lord Kamet
	135996, --Lord Korslate
	135935, --Lord Magmarr
	136048, --Lord Mercurius
	135843, --Lord Mudal
	135844, --Lord Sumar
	135997, --Lord Zircon
	139432, --Lu'si
	134296, --Lucille
	139189, --Lumberclaw the Ancient
	134106, --Lumbergrasp Sentinel
	134791, --Luminous Crawler
	138866, --Mack
	140764, --Magma Giant
	139290, --Maison the Portable
	128935, --Mala'kili
	135958, --Malachite
	142716, --Man-Hunter Rog
	138387, --Mangol
	140454, --Many-Braids the Elder
	139411, --Many-Fangs
	139673, --Many-Teeth
	140991, --Marrowbore
	143560, --Marshal Gabriel
	139600, --Maruk the Volcano
	134112, --Matron Christiane
	137704, --Matron Morana
	128610, --Maw of Shul-Nagruth
	135217, --Maximillian of Northshire
	139814, --Merger Specialist Huzzle
	131252, --Merianae
	138870, --Mick
	139414, --Mire Priest Vassz
	139413, --Mirelurk Oasis-Speaker
	139231, --Mirewood the Trampler
	136379, --Misham Endseeker
	140171, --Mistfur
	140169, --Mogka the Rowdy
	141942, --Molok the Crusher
	135924, --Molten Fury
	136855, --Molten Vordo
	140549, --Moltenweb Devourer
	135720, --Moon-Touched Huntress
	140426, --Moonbeard
	140248, --Moonchaser the Swift
	135723, --Moonclaw
	139025, --Moonsong
	134694, --Mor'fani the Exile
	139694, --Mordshell
	139670, --Morgok
	140828, --Morningdew
	134935, --Mother Vishis
	140663, --Mountain Lord Grum
	136012, --Mountanus the Immovable
	138988, --Mrgl-Eye
	136839, --Mrogan
	138987, --Muckfin High Oracle
	127290, --Mugg
	139529, --Muklai
	134782, --Murderbeak
	140439, --Muskflank Herdleader
	140065, --Muskhide
	139759, --Mutineer Jalia
	128498, --Mutineer Kabwalla
	138565, --My'lyth
	126223, --Mystic Sharpfang
	132749, --NAME
	132750, --NAME
	136800, --NAME
	136803, --NAME
	136815, --NAME
	138655, --NAME
	138656, --NAME
	138657, --NAME
	138658, --NAME
	132747, --NAME
	138833, --NAME
	138834, --NAME
	138835, --NAME
	132748, --NAME
	138832, --NAME
	138502, --Naroviak Wyrm-Bender
	139219, --Nasira Morningfrost
	139387, --Nassa the Cold-Blooded
	139444, --Necrolord Zian
	135589, --Necrotic Mass
	136887, --Needlemane
	138963, --Nestmother Acada
	139589, --Netherweaver Ukk
	130138, --Nevermore
	128951, --Nez'ara
	138309, --Nibnub
	139024, --Nightfeather
	139876, --Nightleech
	134904, --Nightlurker
	142692, --Nimar the Slayer
	140297, --Nok-arak
	118192, --Norgor
	138391, --Norko the Thrower
	136851, --Nuru Emberbraid
	138485, --Nuzoriak the Experimenter
	138566, --Nyl'sozz
	138483, --Obsidian Monstrosity
	138479, --Obsidian Overlord
	138484, --Obsidian Prophet
	138487, --Obsidian Wing-Spreader
	134797, --Ocean Recluse
	139597, --Oggog Magmafist
	138985, --Old Grmgl
	140438, --Old Longtooth
	140183, --Old Muckhide
	140071, --Old One-Fang
	122639, --Old R'gal
	140390, --Onyx Bilefeaster
	136872, --Oof Brainbasher
	138308, --Ook-Aak
	139666, --Orgl the Totemic
	136862, --Orgo
	139591, --Oronn Many-Tongues
	141239, --Osca the Bloodied
	126019, --Overfed Mawfiend
	136818, --Overseer Flamelicker
	142423, --Overseer Krix
	138503, --Overseer of Twilight
	136819, --Overseer Rat-Tail
	136816, --Overseer Snorgle
	136817, --Overseer Steelsnout
	124375, --Overstuffed Saurolisk
	139205, --P4-N73R4
	131262, --Pack Leader Asenya
	138631, --Pathfinder Qadim
	137649, --Pest Remover Mk. II
	140452, --Pikehorn the Sleeper
	140093, --Pinegraze Fawnmother
	139298, --Pinku'shon
	142435, --Plaguefeather
	142361, --Plaguefeather
	141286, --Poacher Zane
	143313, --Portakillo
	138636, --Prince Abari
	139884, --Prophet Doom-Ra
	138634, --Prophet Lapisa
	139885, --Prophet Nox'tir
	139883, --Prophet Va'kiz'asha
	140858, --Pyrekin
	135925, --Pyroblaze
	139467, --Qinsu the Granite Fist
	139474, --Qor-Xin the Earth-Caller
	135959, --Quakestomp the Rumbler
	140373, --Queen Duneshell
	140327, --Queen Stonehusk
	128974, --Queen Tzxi'kik
	125453, --Quillrat Matriarch
	140155, --Rabid Rotclaw
	140073, --Rabidmaw
	139019, --Rageback
	142436, --Ragebeak
	142321, --Ragebeak
	140673, --Ragesnarl
	140659, --Ragestomp
	132179, --Raging Swell
	134884, --Ragna
	140148, --Rampaging Grizzlefur
	126181, --Ramut the Black
	139278, --Ranja
	115226, --Ravenian
	134802, --Razorback
	136889, --Razorcaller Tuk
	140102, --Razorhog
	128580, --Razorjaw
	140343, --Razorwing
	137983, --Rear Admiral Hainsworth
	132047, --Reinforced Hullbreaker
	136340, --Relic Hunter Hazaak
	135643, --Ren'kiri
	140593, --Restless Horror
	135650, --REUSE
	140856, --REUSE
	140862, --REUSE
	140859, --REUSE
	128707, --Rimestone
	140557, --Ripface
	140300, --Ripshread
	136806, --Rockmagus Bargg
	128930, --Rohnkor
	140157, --Rotclaw Cub-Eater
	139194, --Rotmaw
	139417, --Rotwood the Cursed
	123293, --Royal Sand Crab
	140388, --Ruby Scavenger
	140863, --Rubywind Prankster
	140995, --Ruinstalker
	126432, --Rumbling Goliath
	140765, --Rumbling Goliath
	141620, --Rumbling Goliath
	140273, --Runehoof Denkeeper
	142683, --Ruul Onestone
	139335, --Sabertron
	139328, --Sabertron
	139356, --Sabertron
	139359, --Sabertron
	139336, --Sabertron
	119103, --Sable Enforcer
	138989, --Saltfin
	141021, --Sand Apparition
	138374, --Sand Fur
	130581, --Sand-Eye
	139988, --Sandfang
	141306, --Sandscour
	134768, --Sandskitter the Relentless
	122090, --Sarashas the Pillager
	127765, --Saurolisk Matriarch
	127289, --Saurolisk Tamer Mugg
	139287, --Sawtooth
	140111, --Scaldix the Poison Spear
	127776, --Scaleclaw Broodmother
	138443, --Scaleguard Buleth
	139390, --Scaleguard Sarrisz
	136834, --Scalper Bazuulu
	140301, --Scarpaw
	138984, --Scarscale
	140794, --Scartalon
	139762, --Scavenger Faith
	136336, --Scorpox
	127820, --Scout Skrasniss
	127873, --Scrounger Patriarch
	140424, --Scythehorn
	138938, --Seabreaker Skoloth
	139769, --Second Mate Barnaby
	139818, --Security Officer Durk
	138995, --Seed-Keeper Ungan
	139667, --Seer Grglok
	139813, --Senior Producer Gixi
	139470, --Serpent Master Xisho
	140271, --Severhorn
	140997, --Severus the Outcast
	128923, --Sha'khee
	134905, --Shadeweb Huntress
	134902, --Shadow-Weaver
	136836, --Shadowbreaker Urzula
	139351, --Shadowspeaker Angolo
	139669, --Shaman Garmr
	124475, --Shambling Ambusher
	139671, --Sharkslayer Mugluk
	140074, --Sharptooth
	138567, --Shathhoth the Punisher
	134910, --Shimmerweb
	140362, --Shimmerwing
	139765, --Shipless Jimmy
	139285, --Shiverscale the Toxic
	139678, --Shoal-Walker
	135044, --Shredmaw the Voracious
	138568, --Shuk'shuguun the Subjugator
	138648, --Sigrid the Shroud-Weaver
	126449, --Siltspitter
	142690, --Singer
	136338, --Sirokar
	141143, --Sister Absinthe
	139226, --Sister Anana
	138863, --Sister Martha
	126508, --Skethik
	143316, --Skullcap
	142437, --Skullripper
	142312, --Skullripper
	139602, --Skur the Unbroken
	125816, --Sky Queen
	140344, --Sky Viper
	134571, --Skycaller Teskris
	134745, --Skycarver Krakit
	139486, --Skycrack
	140249, --Slatehide
	134949, --Slateskitter
	139319, --Slickspill
	138439, --Slitherqueen Valla
	139415, --Slitherscale
	140437, --Slow Olo
	139018, --Slumbering Mountain
	138389, --Smasha
	138307, --Smashface
	140063, --Smashmaw the Man-Eater
	140556, --Smokehound
	135926, --Smolderheart
	138375, --Smoos
	140436, --Snorthoof
	140091, --Snowhoof
	141175, --Song Mistress Dadalea
	136304, --Songstress Nahjeen
	138441, --Songstress of the Deep
	140358, --Sorrowcall
	137665, --Soul Goliath
	138851, --Soul Hunter
	139438, --Soul-Bringer Togan
	139346, --Soul-Speaker Galani
	139045, --Speaker Juchi
	139042, --Spearmaster Kashai
	139592, --Spellbinder Goro
	138509, --Spellbinder Ulura
	129836, --Spelltwister Moephus
	139443, --Spinebender Kuntai
	139468, --Spineripper Ku-Kon
	135045, --Spinesnapper
	136873, --Spitshot
	132280, --Squacks
	141088, --Squall
	139135, --Squirgle of the Depths
	139418, --Stagnant One
	139389, --Steelscale Volshasis
	140333, --Steelshell
	140988, --Steelshred
	132450, --Stinkboot
	137708, --Stone Golem
	139473, --Stone Machinist Nu-Xin
	139472, --Stone-Lord Qinsho
	140088, --Stonehorn the Charger
	136809, --Stonejaw the Rock-Eater
	140112, --Stonelash
	118175, --Storm Elemental
	140345, --Stormscreech
	138473, --Stygia
	137061, --Suluz Wind-Tamer
	140360, --Sunback
	140425, --Surefoot
	139757, --Sureshot Johnson
	136801, --Surveyor Grimesalt
	139564, --Swainbeak
	135839, --Swampgas
	140101, --Swampwallow
	139695, --Swipeclaw
	138651, --Sylveria Reefcaller
	136413, --Syrawon the Dominus
	139280, --Sythian the Swift
	138437, --Szerris the Invader
	138842, --Ta'kil the Resonator
	130788, --Taghira
	126460, --Tainted Guardian
	139980, --Taja the Tidehowler
	134924, --Taloc IGC
	129950, --Talon
	138477, --Talonguard Vrykiss
	131687, --Tambano
	136814, --Tattertail
	139539, --Tavok, Hammer of the Empress
	131723, --Tehd and Marius
	133356, --Tempestria
	139289, --Tentulos the Drifter
	131389, --Teres
	139358, --The Caterer
	136189, --The Lichen King
	138998, --Thick-Hide
	134948, --Thicket Stalker
	140449, --Thickflank
	138512, --Thorisiona
	139016, --Thorncoat
	139022, --Thornfur the Protector
	138830, --Thorvast, Guided by the Stars
	136841, --Thu'zun the Vile
	140359, --Thunderhawk Devourer
	142419, --Thundering Goliath
	141616, --Thundering Goliath
	118176, --Thundershock
	140099, --Thundersnort the Loud
	133163, --Tia'Kawan
	141056, --Tide Lord Makuna
	141058, --Tide Lord Szunis
	141057, --Tide Lord Vorshasz
	138652, --Tide-Cursed Mistress
	138650, --Tide-Lost Champion
	138431, --Tidemistress Najula
	138432, --Tidemistress Nessa
	132921, --Tidemistress Sser'ah
	138433, --Tidemistress Vessana
	138438, --Tidereaver Steelfang
	139043, --Tidestriker Ocho
	138994, --Timberfist
	134804, --Timeless Runeback
	140767, --TO DO
	143311, --Toadcruel
	140386, --Topaz Borer
	127939, --Torraske the Eternal
	139235, --Tort Jaw
	138640, --Torus
	126056, --Totem Maker Jash'ga
	132076, --Totes
	136860, --Tracker Vu'ka
	136875, --Trader Udu
	140182, --Trampleleaf the Jungle Quake
	140855, --Trickle
	139445, --Tumat
	140389, --Tunnel-Keeper Ky'nyx
	136891, --Tuskbreaker the Scarred
	138510, --Twilight Doomcaller
	138516, --Twilight Evolutionist
	135722, --Twilight Prowler
	131984, --Twin-hearted Construct
	130643, --Twisted Child of Rezan
	138475, --Tyrantion
	136876, --Ugh the Feared
	136864, --Uguu the Feared
	140269, --Ulu'tale
	122004, --Umbra'jin
	134717, --Umbra'rix
	138474, --Umbralion
	137579, --Unbound Azerite
	134823, --Unbreakable Crystalspine
	138508, --Unbreakable Vortax
	139191, --Underbrush
	134002, --Underlord Xerxiz
	136857, --Undol the Herdmaster
	139353, --Unliving Champion
	138990, --Urgl the Blind
	128965, --Uroku the Bound
	138889, --Uvuld the Forseer
	136865, --Uzan the Sandreaver
	140339, --Vale Terror
	140661, --Valethunder
	130401, --Vathikur
	134795, --Veiled Hermit
	136837, --Venomancer Ant'su
	142438, --Venomarus
	142301, --Venomarus
	139210, --Venombulb
	126926, --Venomjaw
	140113, --Venomlash
	140357, --Venomreaver
	136044, --Venomswell
	139809, --Venture Acquisitions Specialist
	139810, --Venture Middle Manager
	139812, --Venture Producer
	139811, --Venture Sub-Lead
	138654, --Vestar of the Tattered Sail
	138629, --Vicar Djosa
	139820, --Vice President Fitzi Getzem
	139821, --Vice President Frankie G.
	139819, --Vice President Genni Newcom
	139815, --Vice President Rax Blastem
	127651, --Vicemaul
	140098, --Vicious Scarhide
	135043, --Vicious Vicejaw
	140697, --Vile Asp
	135834, --Vile Cloud
	134821, --Vilegaze Petrifier
	140156, --Vilemaw
	134932, --Vileweb Broodqueen
	139212, --Vinelash
	135939, --Vinespeaker Ratha
	128893, --Vinyeti
	129977, --Vinyeti
	129979, --Vinyeti
	134912, --Violet Creeper
	139410, --Visz the Silent Blade
	139325, --Void Essence Kill Credit
	132052, --Vol'Jim
	135932, --Volcanar
	140559, --Volcanor
	139416, --Volshas
	139889, --Vorus'arak
	138563, --Vudax
	128584, --Vugthuth
	134048, --Vukuba
	138649, --Vulf Stormshore
	140329, --Vy'lix the Corpse-Mauler
	
	-- Build 8.0.1 26032
	133842, --Warcrawler Karkithiss
	127831, --Warmother Zug
	129411, --Zunashi the Exile
	
	-- Build 8.0.1 26131
	126095, --Vyliss
	134805, --Wandering Behemoth
	123282, --Warlord Mo'gosh
	134766, --Wavespitter
	134651, --Witch Doctor Habra'du
	131476, --Zayoos
	
	-- Build 8.0.1 26175
	136838, --Zgordo the Brutalizer
	136840, --Zoga
	
	-- Build 8.0.1 26231
	130079, --Wagga Snarltusk
	129180, --Warbringer Hozzik
	123189, --Warcaller Mog'ra
	126907, --Wardrummer Zurula
	134638, --Warlord Zothix
	134625, --Warmother Captive
	128973, --Whargarble the Ill-Tempered
	129803, --Whiplash
	134088, --Xibalan Apex
	133531, --Xu'ba
	124362, --Xu'e
	129657, --Za'amar the Queen's Blade
	133812, --Zanxib
	131717, --Zayolin the Lifedrainer
	128578, --Zujothgul

	-- Build 8.0.1 26367
	138513, --Vyrantion
	138507, --Warlord Ultriss
	138442, --Wavebreaker
	138843, --Wingleader Srak'ik
	138844, --Ya'vik the Imperial Blade

	-- Build 8.0.1 26433
	139220, --Vya Crystalbloom
	139538, --Wall-Breaker Ha'vik
	139405, --Wavebringer Sezzes'an
	139044, --Wavemender Asha
	139322, --Whitney "Steelclaw" Ramsay
	139017, --Wildmane
	139430, --Zaliz' Eternal Hound
	139388, --Zess'ez
	139469, --Zu-Xan of Thunder

	-- Build 8.0.1 26476
	140100, --Warsnort
	139676, --Wave-Speaker Ormrg
	139668, --Wavebinder Gorgl
	140123, --Weaponmaster Halu
	140270, --Wilderbuck
	140398, --Zeritarj

	-- Build 8.0.1 26530
	140975, --Youngercraw
	140844, --Zephis

	-- Build 8.0.1 26567
	142088, --Whirlwing

	-- Build 8.0.1 26629
	142251, --Yogursa
	142440, --Yogursa
	142682, --Zalas Witherbark
	
	-- Build 8.1.0.28366
	149355, --Aberrant Azergem Crystalback
	148154, --Agathe Wyrmwood
	149517, --Agathe Wyrmwood
	149652, --Agathe Wyrmwood
	146855, --Akina
	148787, --Alash'anir
	147951, --Alkalinius
	149241, --Alliance Captain
	145292, --Alsian Vistreth
	147966, --Aman
	145392, --Ambassador Gaines
	148393, --Ancient Defender
	144855, --Apothecary Jerrod
	148679, --Arcanist Quintril
	147750, --Artillery Master Goodwin
	147862, --Asennu
	148037, --Athil Dewfire
	147708, --Athrikus Narassin
	147957, --Azerchrysalis
	149359, --Azerite Behemoth
	146178, --Azurespine
	146131, --Bartok the Burrower
	149336, --Basaltic Azerite
	148075, --Beast Tamer Watkins
	148477, --Beastlord Drakara
	148428, --Bilestomper
	145272, --Blackpaw
	149516, --Blackpaw
	149651, --Blackpaw
	149660, --Blackpaw
	146238, --Blacksting
	147854, --Blade-Dancer Zorlak
	148322, --Blinky Gizmospark
	144954, --Bloodgorger
	147866, --Bloodgorger
	144827, --Bogbelcher
	148744, --Brewmaster Lin
	147873, --Broodqueen Cindrix
	147872, --Broodqueen Vyl'tilac
	149141, --Burninator Mark V
	149349, --Calcified Azerite
	147857, --Cannonmaster Arlin
	145415, --Cap'n Gorok
	147489, --Captain Greensails
	148676, --Caravan Commander Veronica
	145391, --Caravan Leader
	145825, --Caravan Leader
	148550, --Caravan Leader
	148642, --Caravan Leader
	145932, --Celestra Brightmoon
	149337, --Coalesced Azerite
	149358, --Colossal Azergem Crystalback
	144831, --Colossal Spadefoot
	147845, --Commander Drald
	148025, --Commander Ral'esh
	147260, --Conflagros
	148144, --Croz Bloodrage
	149513, --Croz Bloodrage
	149655, --Croz Bloodrage
	149661, --Croz Bloodrage
	147241, --Cyclarus
	147880, --Dargulf the Spirit-Seeker
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
	146848, --Eerie Conglomeration
	145465, --Engineer Bolthold
	149356, --Enraged Azergem Crystalback
	148308, --Eric Quietfist
	148534, --Evezon the Eternal
	146188, --Firesting Dominator
	144915, --Firewarden Viton Darkflare
	146773, --First Mate Malone
	145308, --First Sergeant Steelfang
	146885, --Foulshriek
	149343, --Frenzy Imbued Azerite
	149344, --Fury Imbued Azerite
	146882, --Gargantuan Blighthound
	147958, --Geoactive Refraction
	147955, --Georb
	147928, --Geoscatter
	147924, --Geoshard
	146887, --Ghern the Rancid
	146880, --Gholvran the Cryptic
	145269, --Glimmerspine
	149654, --Glimmerspine
	147744, --Glrglrr
	147222, --Gnollfeaster
	146139, --Goldspine
	146942, --Grand Marshal Fury
	146850, --Grand Master Ulrich
	147877, --Grand Master Ulrich
	147261, --Granokk
	148031, --Gren Tornfur
	145271, --Grimhorn
	149514, --Grimhorn
	149656, --Grimhorn
	149662, --Grimhorn
	148860, --Grizzwald
	147061, --Grubb
	146813, --Gunther the Gray
	144997, --Gurin Stonebinder
	146869, --Gyrum the Virulent
	146675, --Hartford Sternbach
	147864, --Hisskarath
	144952, --Hookfang
	149245, --Horde Captain
	146883, --Houndmaster Angvold
	146886, --Hrolskald the Fetid
	149360, --Hulking Azerite
	147240, --Hydrath
	145076, --In'le
	149353, --Incandescent Azergem Crystalback
	146112, --Inkfur Behemoth
	148717, --Inquisitor Erik
	148597, --Iron Shaman Grimbeard
	145934, --Ivan the Mad
	147849, --Jadeflare
	146845, --Jared the Jagged
	148390, --Jessibelle Moonshield
	149352, --Jeweled Azergem Crystalback
	148456, --Jin'tago
	146872, --Kachota the Exiled
	145395, --Katrianna
	146853, --Kefolkis the Unburied
	147878, --Kefolkis the Unburied
	147923, --Knight-Captain Joesiph
	146852, --Konrad the Enslaver
	148779, --Lightforged Warframe
	145040, --Llorin the Clever
	146876, --Machitu the Brutal
	148723, --Maddok the Sniper
	145250, --Madfeather
	149657, --Madfeather
	148739, --Magister Crystalynn
	144826, --Man-Eater
	146871, --Matriarch Nas'naya
	146109, --Midnight Charger
	146651, --Mistweaver Nian
	149354, --Monstrous Azergem Crystalback
	147562, --Mortar Master Zapfritz
	145286, --Motega Bloodshield
	147701, --Moxo the Beheader
	147970, --Mrggr'marr
	148155, --Muk'luk
	146873, --Murderous Tempest
	149147, --N'chala the Egg Thief
	148092, --Nalaess Featherseeker
	146844, --Olfkrig the Indentured
	146607, --Omgar Doombow
	147758, --Onu
	146979, --Ormin Rocketbop
	148147, --Orwell Stevenson
	149510, --Orwell Stevenson
	149659, --Orwell Stevenson
	149664, --Orwell Stevenson
	148651, --Overgrown Ancient
	146246, --Ovix the Toxic
	148044, --Owynn Graddock
	148648, --Packmaster Swiftarrow
	144951, --Palefur Devourer
	149339, --Permeated Azerite
	148674, --Plague Master Herbert
	148403, --Portal Keeper Romiir
	148753, --Ptin'go
	146140, --Quilldozer
	144956, --Razorbite
	146143, --Razorspike
	149351, --Rhodochrosite
	148558, --Rockfury
	148494, --Sandbinder Sodir
	148103, --Sapper Odette
	145242, --Scalefiend
	149665, --Scalefiend
	148198, --Scout Captain Grizzleknob
	144987, --Shadow Hunter Mutumba
	148637, --Shadow Hunter Vol'tris
	145268, --Shadowclaw
	149512, --Shadowclaw
	149658, --Shadowclaw
	149663, --Shadowclaw
	144957, --Shali'i
	147751, --Shattershard
	145062, --Shi'sharin
	147858, --Shipless Jimmy
	145466, --Shredatron-2000
	145161, --Siege Engineer Krackleboom
	148451, --Siege O' Matic 9000
	148231, --Siegebreaker Vol'gar
	148842, --Siegeotron
	147869, --Sigrid the Shroud-Weaver
	146816, --Sir Barton Brigham
	145928, --Skavis Nightstalker
	146245, --Skitterwing
	145232, --Skulli
	148792, --Skycaptain Thermospark
	147507, --Skycarver Krakit
	145039, --Snowstalker
	147897, --Soggoth the Slitherer
	146881, --Soothsayer Brinvulf
	146134, --Speedy
	146870, --Spellbinder Ohnazae
	146849, --Spirit Master Rowena
	145927, --Starcaller Ellana
	146854, --Stella Darkpaw
	146244, --Stinging Fiend
	147332, --Stonebinder Ssra'vess
	145063, --Stormbeak
	148759, --Stormcaller Morka
	145226, --Strofnir
	146611, --Strong Arm John
	149346, --Suffused Azerite
	146847, --Summoner Laniella
	146114, --Surging Winds
	145041, --Swifttail Stalker
	149334, --Tectonic Azerite
	145077, --Terrorwing
	147435, --Thelar Moonstrike
	148813, --Thomas Vandergrief
	145229, --Throfnir
	144829, --Thundercroak
	146113, --Thunderhoof
	147870, --Tide-Cursed Mistress
	148276, --Tidebinder Maka
	147941, --Tidesage Clarissa
	144722, --Togoth Cruelarm
	147860, --Torus
	149335, --Tumultuous Azerite
	146111, --Twenty Points
	147942, --Twilight Prophet Graeme
	147881, --Uvuld the Forseer
	146875, --Valimok the Vicious
	145228, --Valja
	147321, --Venomjaw
	144967, --Vinyeti
	149341, --Vitrified Azerite
	147998, --Voidmaster Evenshade
	149338, --Volatile Azerite
	147853, --Wall-Breaker Ha'vik
	146884, --Warlord Hjelskard
	146110, --Waxing Moon
	144833, --Whiptongue
	146247, --White Death
	146874, --Windcaller Mariah
	148446, --Wolfleader Skraug
	149383, --Xizz Gutshank
	144830, --Yaz'za the Devourer
	145112, --Zagg Brokeneye
	144955, --Zal'zi the Bloodgorged
	148862, --Zillie Wunderwrench
	147664, --Zim'kaga
	148146, --Zul'aki the Headhunter
	145287, --Zunjo of Sen'jin
	
	-- Build 8.1.0.27934
	148295, --Ivus the Decayed
	144946, --Ivus the Forest Lord

	-- Build 8.1.5.28938
	149873, --Stanley
	149886, --Stanley
	149887, --Stanley
	152557, --Trialmaster
	
	-- Build 8.2.0
	152697, --Ulmath
	153314, --Aldrantiss
	152415, --Alga the Eyeless
	152416, --Allseer Oma'kil
	153309, --Alzana, Arrow of Thunder
	152794, --Amethyst Spireshell
	152566, --Anemonar
	151934, --Arachnoid Harvester
	154342, --Arachnoid Harvester
	150394, --Armored Vaultbot
	154968, --Armored Vaultbot
	150191, --Avarius
	155331, --Azerite Behemoth
	152361, --Banescale the Packfather
	152712, --Blindlight
	153200, --Boilburn
	153299, --Bonebreaker Szun
	152001, --Bonepicker
	151841, --Burgthok the Herald
	149653, --Carnivorous Lasher
	154739, --Caustic Mechaslime
	152464, --Caverndark Terror
	152556, --Chasm-Haunter
	151689, --Clawfoot the Leaper
	151624, --Clockwork Giant
	151850, --Commander Dilik
	149847, --Crazed Trogg
	152569, --Crazed Trogg
	152570, --Crazed Trogg
	152756, --Daggertooth Terror
	151854, --Deathseeker Loshok
	152291, --Deepglider
	151569, --Deepwater Maw
	153315, --Eldanar
	152414, --Elder Unu
	152555, --Elderspawn Nalaada
	154153, --Enforcer KX-T57
	151159, --Fleetfoot
	151202, --Foul Manifestation
	135497, --Fungarian Furor
	153308, --Fury of Azshara
	152553, --Garnetscale
	153228, --Gear Checker Cogstar
	150576, --Gears
	153205, --Gemicide
	153302, --Glacier Mage Zhiela
	154701, --Gorged Gear-Cruncher
	154640, --Grand Marshal Tremblade
	152736, --Guardian Tyr'mar
	154641, --High Warlord Volrath
	154416, --Hisskari
	155332, --Incandescent Azergem Crystalback
	152448, --Iridescent Glimmershell
	153300, --Iron Zoko
	151684, --Jawbreaker
	152567, --Kelpwillow
	152007, --Killsaw
	152323, --King Gakula
	152624, --King Gakula
	153312, --Kyx'zhul the Deepspeaker
	151845, --Lieutenant N'ot
	151933, --Malfunctioning Beastbot
	151124, --Mechagonian Nullifier
	150786, --Mechanized Crawler
	151672, --Mecharantula
	151688, --Melonsmasher
	144644, --Mirecrawler
	152729, --Moon Priestess Liara
	153000, --Motobrain Spider
	151627, --Mr. Fixthis
	152465, --Needlespine
	151686, --Nimblepaws the Thief
	153206, --Ol' Big Tusk
	151680, --Orangetooth
	152397, --Oronu
	152764, --Oxidized Leachbeast
	151702, --Paol Pondwader
	152681, --Prince Typhonus
	152682, --Prince Vortran
	155333, --Pulsing Azerite Geode
	153310, --Qalina, Spear of Ice
	151918, --Raz'kah of the North
	153297, --REUSE
	153298, --REUSE
	151296, --Rocket
	150583, --Rockweed Shambler
	150575, --Rumblerocks
	152182, --Rustfeather
	152892, --Rusty Mechanocrawler
	149746, --Rusty Mechaspider
	151870, --Sandcastle
	152795, --Sandclaw Stoneshell
	152548, --Scale Matriarch Gratinax
	152545, --Scale Matriarch Vynara
	152542, --Scale Matriarch Zodia
	150937, --Seaspit
	153296, --Shalan'ali Stormtongue
	152552, --Shassera
	153088, --Shiny Mechaspider
	153301, --Shirakess Starseeker
	153658, --Shiz'narasz the Consumer
	151681, --Shorttail the Chucker
	151687, --Shrieker
	152359, --Siltstalker the Packmother
	151690, --Singetooth
	153311, --Slitherblade Azanz
	152290, --Soundless
	151862, --Spiritwalker Fe'sal
	154180, --Sslithara
	153226, --Steel Singer Freza
	151685, --Stinkfur Denmother
	150430, --Streetpig
	151917, --Tar'al Bonespitter
	154277, --Test Creature
	152113, --The Kleptoboss
	154225, --The Rusty Prince
	151623, --The Scrap King
	151625, --The Scrap King
	153898, --Tidelord Aquatus
	153928, --Tidelord Dispersius
	154148, --Tidemistress Leth'sindra
	152360, --Toxigore the Alpha
	151940, --Uncle T'Rogg
	153304, --Undana Frostbarb
	153307, --Unleashed Arcanofiend
	152568, --Urduu
	151719, --Voice in the Deeps
	153303, --Voidblade Kassar
	150468, --Vor'koth
	153313, --Vyz'olgo the Mind-Taker
	152671, --Wekemara
	151916, --Zaegra Sharpaxe
	153305, --Zanj'ir Brutalizer
	154949, --Zanj'ir Brutalizer
	150342, --Earthbreaker Gulroc
	151308, --Boggac Skullbash
	
	-- Build 8.2.0 30430
	155811, --Commander Minzera
	155838, --Incantatrix Vazina
	155583, --Scrapclaw
	155841, --Shadowbinder Athissa
	155836, --Theurgist Nitara
	155840, --Warlord Zalzjar

	-- Build 8.2.5
	155173, --Honeyback Usurper
	155055, --Gurg the Hivethief
	155176, --Old Nasha
	158111, --Trialmaster
	155171, --The Hivekiller
	155172, --Trapdoor Bee Hunter
	155059, --Yorag the Jelly Feaster
}
