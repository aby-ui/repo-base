-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Maps = private.Data.Maps
local MapID = private.Enum.MapID

-- ----------------------------------------------------------------------------
-- Frostfire Ridge
-- ----------------------------------------------------------------------------
Maps[MapID.FrostfireRidge].NPCs = {
    [50992] = true, -- Gorok
    [71665] = true, -- Giant-Slayer Kul
    [71721] = true, -- Canyon Icemother
    [72156] = true, -- Borrok the Devourer
    [72294] = true, -- Cindermaw
    [72364] = true, -- Gorg'ak the Lava Guzzler
    [74613] = true, -- Broodmother Reeg'ak
    [74971] = true, -- Firefury Giant
    [76914] = true, -- Coldtusk
    [76918] = true, -- Primalist Mur'og
    [77513] = true, -- Coldstomp the Griever
    [77519] = true, -- Giantbane
    [77526] = true, -- Scout Goreseeker
    [77527] = true, -- The Beater
    [78128] = true, -- Gronnstalker Dawarn
    [78134] = true, -- Pathfinder Jalog
    [78144] = true, -- Giantslayer Kimla
    [78150] = true, -- Beastcarver Saramor
    [78151] = true, -- Huntmaster Kuang
    [78169] = true, -- Cloudspeaker Daber
    [78265] = true, -- The Bone Crawler
    [78606] = true, -- Pale Fishmonger
    [78621] = true, -- Cyclonic Fury
    [78867] = true, -- Breathless
    [79104] = true, -- Ug'lok the Frozen
    [79145] = true, -- Yaga the Scarred
    [80190] = true, -- Gruuk
    [80235] = true, -- Gurun
    [80242] = true, -- Chillfang
    [80312] = true, -- Grutush the Pillager
    [81001] = true, -- Nok-Karosh
    [82536] = true, -- Gorivax
    [82614] = true, -- Moltnoma
    [82616] = true, -- Jabberjaw
    [82617] = true, -- Slogtusk the Corpse-Eater
    [82618] = true, -- Tor'goroth
    [82620] = true, -- Son of Goramal
    [84374] = true, -- Kaga the Ironbender
    [84376] = true, -- Earthshaker Holar
    [84378] = true, -- Ak'ox the Slaughterer
    [84392] = true, -- Ragore Driftstalker
    [87348] = true, -- Hoarfrost
    [87351] = true, -- Mother of Goren
    [87352] = true, -- Gibblette the Cowardly
    [87356] = true, -- Vrok the Ancient
    [87357] = true, -- Valkor
    [87600] = true, -- Jaluk the Pacifist
    [87622] = true -- Ogom the Mangler
}

-- ----------------------------------------------------------------------------
-- Tanaan Jungle
-- ----------------------------------------------------------------------------
Maps[MapID.TanaanJungle].NPCs = {
    [80398] = true, -- Keravnos
    [89675] = true, -- Commander Org'mok
    [90024] = true, -- Sergeant Mor'grak
    [90094] = true, -- Harbormaster Korak
    [90122] = true, -- Zoug the Heavy
    [90429] = true, -- Imp-Master Valessa
    [90434] = true, -- Ceraxas
    [90437] = true, -- Jax'zor
    [90438] = true, -- Lady Oran
    [90442] = true, -- Mistress Thavra
    [90519] = true, -- Cindral the Wildfire
    [90777] = true, -- High Priest Ikzan
    [90782] = true, -- Rasthe
    [90884] = true, -- Bilkor the Thrower
    [90885] = true, -- Rogond the Tracker
    [90887] = true, -- Dorg the Bloody
    [90888] = true, -- Drivnul
    [90936] = true, -- Bloodhunter Zulk
    [91009] = true, -- Putre'thar
    [91087] = true, -- Zeter'el
    [91093] = true, -- Bramblefell
    [91098] = true, -- Felspark
    [91227] = true, -- Remnant of the Blood Moon
    [91232] = true, -- Commander Krag'goth
    [91243] = true, -- Tho'gar Gorefist
    [91374] = true, -- Podlord Wakkawam
    [91695] = true, -- Grand Warlock Nethekurse
    [91727] = true, -- Executor Riloth
    [91871] = true, -- Argosh the Destroyer
    [92197] = true, -- Relgor
    [92274] = true, -- Painmistress Selora
    [92408] = true, -- Xanzith the Everlasting
    [92411] = true, -- Overlord Ma'gruth
    [92429] = true, -- Broodlord Ixkor
    [92451] = true, -- Varyx the Damned
    [92465] = true, -- The Blackfang
    [92495] = true, -- Soulslicer
    [92508] = true, -- Gloomtalon
    [92517] = true, -- Krell the Serene
    [92552] = true, -- Belgork
    [92574] = true, -- Thromma the Gutslicer
    [92606] = true, -- Sylissa
    [92627] = true, -- Rendrak
    [92636] = true, -- The Night Haunter
    [92645] = true, -- The Night Haunter
    [92647] = true, -- Felsmith Damorka
    [92657] = true, -- Bleeding Hollow Horror
    [92694] = true, -- The Goreclaw
    [92766] = true, -- Akrrilo
    [92817] = true, -- Rendarr
    [92819] = true, -- Eyepiercer
    [92887] = true, -- Steelsnout
    [92941] = true, -- Gorabosh
    [92977] = true, -- The Iron Houndmaster
    [93001] = true, -- Szirek the Twisted
    [93002] = true, -- Magwia
    [93028] = true, -- Driss Vile
    [93057] = true, -- Grannok
    [93076] = true, -- Captain Ironbeard
    [93125] = true, -- Glub'glok
    [93168] = true, -- Felbore
    [93236] = true, -- Shadowthrash
    [93264] = true, -- Captain Grok'mar
    [93279] = true, -- Kris'kar the Unredeemed
    [95044] = true, -- Terrorfist
    [95053] = true, -- Deathtalon
    [95054] = true, -- Vengeance
    [95056] = true, -- Doomroller
    [96235] = true, -- Xemirkol
    [98283] = true, -- Drakum
    [98284] = true, -- Gondar
    [98285] = true, -- Smashum Grabb
    [98408] = true -- Fel Overseer Mudlump
}

-- ----------------------------------------------------------------------------
-- Talador
-- ----------------------------------------------------------------------------
Maps[MapID.Talador].NPCs = {
    [51015] = true, -- Silthide
    [77529] = true, -- Yazheera the Incinerator
    [77561] = true, -- Dr. Gloom
    [77614] = true, -- Frenzied Golem
    [77620] = true, -- Cro Fleshrender
    [77626] = true, -- Hen-Mother Hami
    [77634] = true, -- Taladorantula
    [77664] = true, -- Aarko
    [77715] = true, -- Hammertooth
    [77719] = true, -- Glimmerwing
    [77741] = true, -- Ra'kahn
    [77750] = true, -- Kaavu the Crimson Claw
    [77776] = true, -- Wandering Vindicator
    [77784] = true, -- Lo'marg Jawcrusher
    [77795] = true, -- Echo of Murmur
    [77828] = true, -- Echo of Murmur
    [78710] = true, -- Kharazos the Triumphant
    [78713] = true, -- Galzomar
    [78715] = true, -- Sikthiss, Maiden of Slaughter
    [78872] = true, -- Klikixx
    [79334] = true, -- No'losh
    [79485] = true, -- Talonpriest Zorkra
    [79543] = true, -- Shirzir
    [80204] = true, -- Felbark
    [80471] = true, -- Gennadian
    [80524] = true, -- Underseer Bloodmane
    [82920] = true, -- Lord Korinak
    [82922] = true, -- Xothear, the Destroyer
    [82930] = true, -- Shadowflame Terrorwalker
    [82942] = true, -- Lady Demlash
    [82988] = true, -- Kurlosh Doomfang
    [82992] = true, -- Felfire Consort
    [82998] = true, -- Matron of Sin
    [83008] = true, -- Haakun the All-Consuming
    [83019] = true, -- Gug'tol
    [85572] = true, -- Grrbrrgle
    [86549] = true, -- Steeltusk
    [87597] = true, -- Bombardier Gu'gok
    [87668] = true, -- Orumo the Observer
    [88043] = true, -- Avatar of Socrethar
    [88071] = true, -- Strategist Ankor
    [88072] = true, -- Archmagus Tekar
    [88083] = true, -- Soulbinder Naylana
    [88436] = true, -- Vigilant Paarthos
    [88494] = true -- Legion Vanguard
}

-- ----------------------------------------------------------------------------
-- Shadowmoon Valley (Draenor)
-- ----------------------------------------------------------------------------
Maps[MapID.ShadowmoonValleyDraenor].NPCs = {
    [50883] = true, -- Pathrunner
    [72362] = true, -- Ku'targ the Voidseer
    [72537] = true, -- Leaf-Reader Kurri
    [72606] = true, -- Rockhoof
    [74206] = true, -- Killmaw
    [75071] = true, -- Mother Om'ra
    [75434] = true, -- Windfang Matriarch
    [75435] = true, -- Yggdrel
    [75482] = true, -- Veloss
    [75492] = true, -- Venomshade
    [76380] = true, -- Gorum
    [77085] = true, -- Dark Emanation
    [77140] = true, -- Amaukwa
    [77310] = true, -- Mad "King" Sporeon
    [79524] = true, -- Hypnocroak
    [79686] = true, -- Silverleaf Ancient
    [79692] = true, -- Silverleaf Ancient
    [79693] = true, -- Silverleaf Ancient
    [81406] = true, -- Bahameye
    [81639] = true, -- Brambleking Fili
    [82207] = true, -- Faebright
    [82268] = true, -- Darkmaster Go'vid
    [82326] = true, -- Ba'ruun
    [82362] = true, -- Morva Soultwister
    [82374] = true, -- Rai'vosh
    [82411] = true, -- Darktalon
    [82415] = true, -- Shinri
    [82676] = true, -- Enavra
    [82742] = true, -- Enavra
    [83385] = true, -- Voidseer Kalurg
    [83553] = true, -- Insha'tar
    [84911] = true, -- Demidos
    [84925] = true, -- Quartermaster Hershak
    [85001] = true, -- Master Sergeant Milgra
    [85029] = true, -- Shadowspeaker Niir
    [85121] = true, -- Lady Temptessa
    [85451] = true, -- Malgosh Shadowkeeper
    [85555] = true, -- Nagidna
    [85568] = true, -- Avalanche
    [85837] = true, -- Slivermaw
    [86213] = true, -- Aqualir
    [86689] = true -- Sneevel
}

-- ----------------------------------------------------------------------------
-- Spires of Arak
-- ----------------------------------------------------------------------------
Maps[MapID.SpiresOfArak].NPCs = {
    [79938] = true, -- Shadowbark
    [80372] = true, -- Echidna
    [80614] = true, -- Blade-Dancer Aeryx
    [82050] = true, -- Varasha
    [82247] = true, -- Nas Dunberlin
    [83990] = true, -- Solar Magnifier
    [84417] = true, -- Mutafen
    [84775] = true, -- Tesska the Broken
    [84805] = true, -- Stonespite
    [84807] = true, -- Durkath Steelmaw
    [84810] = true, -- Kalos the Bloodbathed
    [84833] = true, -- Sangrikass
    [84836] = true, -- Talonbreaker
    [84838] = true, -- Poisonmaster Bortusk
    [84856] = true, -- Blightglow
    [84872] = true, -- Oskiira the Vengeful
    [84887] = true, -- Betsi Boombasket
    [84890] = true, -- Festerbloom
    [84912] = true, -- Sunderthorn
    [84951] = true, -- Gobblefin
    [84955] = true, -- Jiasska the Sporegorger
    [85026] = true, -- Soul-Twister Torek
    [85036] = true, -- Formless Nightmare
    [85037] = true, -- Kenos the Unraveler
    [85078] = true, -- Voidreaver Urnae
    [85504] = true, -- Rotcap
    [85520] = true, -- Swarmleaf
    [86621] = true, -- Morphed Sentient
    [86724] = true, -- Hermit Palefur
    [86978] = true, -- Gaze
    [87019] = true, -- Gluttonous Giant
    [87026] = true, -- Mecha Plunderer
    [87027] = true, -- Shadow Hulk
    [87029] = true -- Giga Sentinel
}

-- ----------------------------------------------------------------------------
-- Gorgrond
-- ----------------------------------------------------------------------------
Maps[MapID.Gorgrond].NPCs = {
    [50985] = true, -- Poundfist
    [75207] = true, -- Biolante
    [76473] = true, -- Mother Araneae
    [77093] = true, -- Roardan the Sky Terror
    [78260] = true, -- King Slime
    [78269] = true, -- Gnarljaw
    [79629] = true, -- Stomper Kreego
    [80371] = true, -- Typhon
    [80725] = true, -- Sulfurious
    [80785] = true, -- Fungal Praetorian
    [80868] = true, -- Glut
    [81038] = true, -- Gelgor of the Blue Flame
    [81528] = true, -- Crater Lord Igneous
    [81529] = true, -- Dessicus of the Dead Pools
    [81537] = true, -- Khargax the Devourer
    [81540] = true, -- Erosian the Violent
    [81548] = true, -- Charl Doomwing
    [82058] = true, -- Depthroot
    [82085] = true, -- Bashiok
    [82311] = true, -- Char the Burning
    [83522] = true, -- Hive Queen Skrikka
    [84406] = true, -- Mandrakor
    [84431] = true, -- Greldrok the Cunning
    [85250] = true, -- Fossilwood the Petrified
    [85264] = true, -- Rolkor
    [85907] = true, -- Berthora
    [85970] = true, -- Riptar
    [86137] = true, -- Sunclaw
    [86257] = true, -- Basten
    [86258] = true, -- Nultra
    [86259] = true, -- Valstil
    [86266] = true, -- Venolasix
    [86268] = true, -- Alkali
    [86410] = true, -- Sylldross
    [86520] = true, -- Stompalupagus
    [86562] = true, -- Maniacal Madgard
    [86566] = true, -- Defector Dazgo
    [86571] = true, -- Durp the Hated
    [86574] = true, -- Inventor Blammo
    [86577] = true, -- Horgg
    [86579] = true, -- Blademaster Ro'gor
    [86582] = true, -- Morgo Kain
    [88580] = true, -- Firestarter Grash
    [88582] = true, -- Swift Onyx Flayer
    [88583] = true, -- Grove Warden Yal
    [88586] = true, -- Mogamago
    [88672] = true -- Hunter Bal'ra
}

-- ----------------------------------------------------------------------------
-- Nagrand (Draenor)
-- ----------------------------------------------------------------------------
Maps[MapID.NagrandDraenor].NPCs = {
    [50981] = true, -- Luk'hok
    [50990] = true, -- Nakk the Thunderer
    [78161] = true, -- Hyperious
    [79024] = true, -- Warmaster Blugthol
    [79725] = true, -- Captain Ironbeard
    [80057] = true, -- Soulfang
    [80122] = true, -- Gaz'orda
    [80370] = true, -- Lernaea
    [82486] = true, -- Explorer Nozzand
    [82755] = true, -- Redclaw the Feral
    [82758] = true, -- Greatfeather
    [82764] = true, -- Gar'lua
    [82778] = true, -- Gnarlhoof the Rabid
    [82826] = true, -- Berserk T-300 Series Mark II
    [82899] = true, -- Ancient Blademaster
    [82912] = true, -- Grizzlemaw
    [82975] = true, -- Fangler
    [83401] = true, -- Netherspawn
    [83409] = true, -- Ophiis
    [83428] = true, -- Windcaller Korast
    [83483] = true, -- Flinthide
    [83509] = true, -- Gorepetal
    [83526] = true, -- Ru'klaa
    [83542] = true, -- Sean Whitesea
    [83591] = true, -- Tura'aka
    [83603] = true, -- Hunter Blacktooth
    [83634] = true, -- Scout Pokhar
    [83643] = true, -- Malroc Stonesunder
    [83680] = true, -- Outrider Duretha
    [84263] = true, -- Graveltooth
    [84435] = true, -- Mr. Pinchy Sr.
    [86729] = true, -- Direhoof
    [86732] = true, -- Bergruu
    [86743] = true, -- Dekorhan
    [86750] = true, -- Thek'talon
    [86771] = true, -- Gagrog the Brutal
    [86774] = true, -- Aogexon
    [86835] = true, -- Xelganak
    [86959] = true, -- Karosh Blackwind
    [87234] = true, -- Brutag Grimblade
    [87239] = true, -- Krahl Deadeye
    [87344] = true, -- Gortag Steelgrip
    [87666] = true, -- Mu'gra
    [87788] = true, -- Durg Spinecrusher
    [87837] = true, -- Bonebreaker
    [87846] = true, -- Pit Slayer
    [88208] = true, -- Pit Beast
    [88210] = true, -- Krud the Eviscerator
    [88951] = true, -- Vileclaw
    [98198] = true, -- Rukdug
    [98199] = true, -- Pugg
    [98200] = true -- Guk
}

-- ----------------------------------------------------------------------------
-- Ashran
-- ----------------------------------------------------------------------------
Maps[MapID.Ashran].NPCs = {
    [82876] = true, -- Grand Marshal Tremblade
    [82877] = true, -- High Warlord Volrath
    [82878] = true, -- Marshal Gabriel
    [82880] = true, -- Marshal Karsh Stormforge
    [82882] = true, -- General Aevd
    [82883] = true, -- Warlord Noktyn
    [83683] = true, -- Mandragoraster
    [83691] = true, -- Panthora
    [83713] = true, -- Titarus
    [83819] = true, -- Brickhouse
    [84110] = true, -- Korthall Soulgorger
    [84196] = true, -- Web-wrapped Soldier
    [84465] = true, -- Leaping Gorger
    [84746] = true, -- Captured Gor'vosh Stoneshaper
    [84854] = true, -- Slippery Slime
    [84875] = true, -- Ancient Inferno
    [84893] = true, -- Goregore
    [84904] = true, -- Oraggro
    [84926] = true, -- Burning Power
    [85763] = true, -- Cursed Ravager
    [85765] = true, -- Cursed Kaliri
    [85766] = true, -- Cursed Sharptalon
    [85767] = true, -- Cursed Harbinger
    [85771] = true, -- Elder Darkweaver Kath
    [87362] = true, -- Gibby
    [91921] = true, -- Wyrmple
    [94113] = true -- Rukmaz
}

-- ----------------------------------------------------------------------------
-- Alliance Garrison
-- ----------------------------------------------------------------------------
Maps[MapID.LunarfallExcavation].NPCs = {
    [96323] = true -- Arachnis
}

Maps[MapID.Lunarfall].NPCs = {
    [96323] = true -- Arachnis
}

-- ----------------------------------------------------------------------------
-- Horde Garrison
-- ----------------------------------------------------------------------------
Maps[MapID.FrostwallMine].NPCs = {
    [96323] = true -- Arachnis
}

Maps[MapID.Frostwall].NPCs = {
    [96323] = true -- Arachnis
}
