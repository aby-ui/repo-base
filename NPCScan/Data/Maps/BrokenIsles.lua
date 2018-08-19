-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Maps = private.Data.Maps
local MapID = private.Enum.MapID

-- ----------------------------------------------------------------------------
-- Azsuna
-- ----------------------------------------------------------------------------
Maps[MapID.Azsuna].NPCs = {
    [89016] = true, -- Ravyn-Drath
    [89650] = true, -- Valiyaka the Stormbringer
    [89816] = true, -- Golza the Iron Fin
    [89846] = true, -- Captain Volo'ren
    [89850] = true, -- The Oracle
    [89865] = true, -- Mrrgrl the Tide Reaver
    [89884] = true, -- Flog the Captain-Eater
    [90057] = true, -- Daggerbeak
    [90164] = true, -- Warbringer Mox'na
    [90173] = true, -- Arcana Stalker
    [90217] = true, -- Normantis the Deposed
    [90244] = true, -- Arcavellus
    [90505] = true, -- Syphonus
    [90803] = true, -- Infernal Lord
    [90901] = true, -- Pridelord Meowl
    [91100] = true, -- Brogozog
    [91113] = true, -- Tide Behemoth
    [91114] = true, -- Tide Behemoth
    [91115] = true, -- Tide Behemoth
    [91187] = true, -- Beacher
    [91289] = true, -- Cailyn Paledoom
    [91579] = true, -- Doomlord Kazrok
    [93622] = true, -- Mortiferous
    [99846] = true, -- Raging Earth
    [99886] = true, -- Pacified Earth
    [101596] = true, -- Charfeather
    [102064] = true, -- Torrentius
    [102075] = true, -- Withered J'im
    [103975] = true, -- Jade Darkhaven
    [105938] = true, -- Felwing
    [106990] = true, -- Chief Bitterbrine
    [107105] = true, -- Broodmother Lizax
    [107113] = true, -- Vorthax
    [107127] = true, -- Brawlgoth
    [107136] = true, -- Houndmaster Stroxis
    [107169] = true, -- Horux
    [107170] = true, -- Zorux
    [107266] = true, -- Commander Soraax
    [107269] = true, -- Inquisitor Tivos
    [107327] = true, -- Bilebrain
    [107657] = true, -- Arcanist Shal'iman
    [108136] = true, -- The Muscle
    [108174] = true, -- Bilgerat
    [108255] = true, -- Coura, Mistress of Arcana
    [108829] = true, -- Levantus
    [109331] = true, -- Calamir
    [109504] = true, -- Ragemaw
    [109575] = true, -- Valakar the Thirsty
    [109584] = true, -- Fjordun
    [109594] = true, -- Stormfeather
    [109620] = true, -- The Whisperer
    [109630] = true, -- Immolian
    [109641] = true, -- Arcanor Prime
    [109653] = true, -- Marblub the Massive
    [109677] = true, -- Chief Treasurer Jabrill
    [109702] = true, -- Deepclaw
    [111434] = true, -- Sea King Tidross
    [111454] = true, -- Bestrix
    [111674] = true, -- Cinderwing
    [111939] = true, -- Lysanis Shadesoul
    [112636] = true, -- Sinister Leyrunner
    [112637] = true -- Devious Sunrunner
}

-- ----------------------------------------------------------------------------
-- Stormheim
-- ----------------------------------------------------------------------------
Maps[MapID.Stormheim].NPCs = {
    [90139] = true, -- Inquisitor Ernstenbok
    [91529] = true, -- Glimar Ironfist
    [91780] = true, -- Mother Clacker
    [91795] = true, -- Stormwing Matriarch
    [91803] = true, -- Fathnyr
    [91874] = true, -- Bladesquall
    [91892] = true, -- Thane Irglov the Merciless
    [92152] = true, -- Whitewater Typhoon
    [92590] = true, -- Hook
    [92591] = true, -- Sinker
    [92599] = true, -- Bloodstalker Alpha
    [92604] = true, -- Champion Elodie
    [92609] = true, -- Tracker Jack
    [92611] = true, -- Ambusher Daggerfang
    [92613] = true, -- Priestess Liza
    [92626] = true, -- Deathguard Adams
    [92631] = true, -- Dark Ranger Jess
    [92633] = true, -- Assassin Huwe
    [92634] = true, -- Apothecary Perez
    [92682] = true, -- Helmouth Raider
    [92685] = true, -- Captain Brvet
    [92703] = true, -- Helmouth Raider
    [92751] = true, -- Ivory Sentinel
    [92763] = true, -- The Nameless King
    [92951] = true, -- Houndmaster Ely
    [93166] = true, -- Tiptog the Lost
    [93371] = true, -- Mordvigbjorn
    [93401] = true, -- Urgev the Flayer
    [94313] = true, -- Daniel "Boomer" Vorick
    [94347] = true, -- Dread-Rider Cortis
    [94413] = true, -- Isel the Hammer
    [98188] = true, -- Egyl the Enduring
    [98268] = true, -- Tarben
    [98421] = true, -- Kottr Vondyr
    [98503] = true, -- Grrvrgull the Conqueror
    [99886] = true, -- Pacified Earth
    [100223] = true, -- Vrykul Earthshaper Spirit
	[100224] = true, -- Vrykul Earthmaiden Spirit
	[106981] = true, -- Captain Hring
	[106982] = true, -- Reaver Jdorn
	[106984] = true, -- Soultrapper Mevra
    [107023] = true, -- Nithogg
    [107487] = true, -- Starbuck
    [107544] = true, -- Nithogg
    [107926] = true, -- Hannval the Butcher
    [108790] = true, -- Den Mother Ylva
    [108822] = true, -- Huntress Estrid
    [108823] = true, -- Halfdan
    [108827] = true, -- Fjorlag, the Grave's Chill
    [108885] = true, -- Aegir Wavecrusher
    [109015] = true, -- Lagertha
    [109113] = true, -- Boulderfall, the Eroded
    [109195] = true, -- Soulbinder Halldora
    [109317] = true, -- Rulf Bonesnapper
    [109318] = true, -- Runeseer Sigvid
    [109994] = true, -- Stormtalon
    [110363] = true, -- Roteye
    [111463] = true, -- Bulvinkel
    [117850] = true -- Simone the Seductress
}

-- ----------------------------------------------------------------------------
-- Val'Sharah
-- ----------------------------------------------------------------------------
Maps[MapID.ValSharah].NPCs = {
    [92104] = true, -- Thistleleaf Rascal
    [92117] = true, -- Gorebeak,
    [92180] = true, -- Seersei
    [92423] = true, -- Theryssia
    [92965] = true, -- Darkshade
    [93030] = true, -- Ironbranch
    [93205] = true, -- Thondrax
    [93654] = true, -- Skul'vrax
    [93679] = true, -- Gathenak the Subjugator
    [93686] = true, -- Jinikki the Puncturer
    [93758] = true, -- Antydas Nightcaller
    [94414] = true, -- Kiranys Duskwhisper
    [94485] = true, -- Pollous the Fetid
    [95123] = true, -- Grelda the Hag
    [95221] = true, -- Mad Henryk
    [95318] = true, -- Perrexx
    [97504] = true, -- Wraithtalon
    [97517] = true, -- Dreadbog
    [98241] = true, -- Lyrath Moonfeather
    [99846] = true, -- Raging Earth
    [99886] = true, -- Pacified Earth
    [103785] = true, -- Well-Fed Bear
    [104523] = true, -- Shalas'aman
    [106042] = true, -- Kalazzius the Guileful
    [107924] = true, -- Darkfiend Tormentor
    [108678] = true, -- Shar'thos
    [108879] = true, -- Humongris
    [109125] = true, -- Kathaw the Savage
    [109281] = true, -- Malisandra
    [109648] = true, -- Witchdoctor Grgl-Brgl
    [109692] = true, -- Lytheron
    [109708] = true, -- Undergrell Ringleader
    [109990] = true, -- Nylaathria the Forgotten
    [110342] = true, -- Rabxach
    [110346] = true, -- Aodh Witherpetal
    [110361] = true, -- Harbinger of Screams
    [110367] = true, -- Ealdis
    [110562] = true -- Bahagar
}

-- ----------------------------------------------------------------------------
-- Broken Shore
-- ----------------------------------------------------------------------------
Maps[MapID.BrokenShore].NPCs = {
    [116166] = true, -- Eye of Gurgh
    [116953] = true, -- Corrupted Bonebreaker
    [117086] = true, -- Emberfire
    [117089] = true, -- Inquisitor Chillbane
    [117090] = true, -- Xorogun the Flamecarver
    [117091] = true, -- Felmaw Emberfiend
    [117093] = true, -- Felbringer Xar'thok
    [117094] = true, -- Malorus the Soulkeeper
    [117095] = true, -- Dreadblade Annihilator
    [117096] = true, -- Potionmaster Gloop
    [117103] = true, -- Felcaller Zelthae
    [117136] = true, -- Doombringer Zar'thoz
    [117140] = true, -- Salethan the Broodwalker
    [117141] = true, -- Malgrazoth
    [117239] = true, -- Brutallus
    [117303] = true, -- Malificus
    [117470] = true, -- Si'vash
    [118993] = true, -- Dreadeye
    [119629] = true, -- Lord Hel'Nurath
    [119718] = true, -- Imp Mother Bruva
    [120583] = true, -- Than'otalion
    [120641] = true, -- Skulguloth
    [120665] = true, -- Force-Commander Xillious
    [120675] = true, -- An'thyna
    [120681] = true, -- Fel Obliterator
    [120686] = true, -- Illisthyndria
    [120998] = true, -- Flllurlokkr
    [121016] = true, -- Aqueux
    [121029] = true, -- Brood Mother Nix
    [121037] = true, -- Grossir
    [121046] = true, -- Brother Badatin
    [121049] = true, -- Baleful Knight-Captain
    [121051] = true, -- Unstable Abyssal
    [121056] = true, -- Malformed Terrorguard
    [121068] = true, -- Volatile Imp
    [121073] = true, -- Deranged Succubus
    [121077] = true, -- Lambent Felhunter
    [121088] = true, -- Warped Voidlord
    [121090] = true, -- Demented Shivarra
    [121092] = true, -- Anomalous Observer
    [121107] = true, -- Lady Eldrathe
    [121108] = true, -- Ruinous Overfiend
    [121112] = true, -- Somber Dawn
    [121124] = true, -- Apocron
    [121134] = true -- Duke Sithizi
}

-- ----------------------------------------------------------------------------
-- Helheim
-- ----------------------------------------------------------------------------
Maps[MapID.Helheim].NPCs = {
    [92040] = true, -- Fenri
    [97630] = true, -- Soulthirster
    [109163] = true -- Captain Dargun
}

-- ----------------------------------------------------------------------------
-- Highmountain
-- ----------------------------------------------------------------------------
Maps[MapID.Highmountain].NPCs = {
    [94877] = true, -- Brogrul the Mighty
    [95204] = true, -- Oubdob da Smasher
    [95872] = true, -- Skullhat
    [96072] = true, -- Durguth
    [96410] = true, -- Majestic Elderhorn
    [96590] = true, -- Gurbog da Basher
    [96621] = true, -- Mellok, Son of Torok
    [97093] = true, -- Shara Felbreath
    [97102] = true, -- Ram'Pag
    [97203] = true, -- Tenpak Flametotem
    [97220] = true, -- Arru
    [97326] = true, -- Hartli the Snatcher
    [97345] = true, -- Crawshuk the Hungry
    [97449] = true, -- Bristlemaul
    [97593] = true, -- Mynta Talonscreech
    [97653] = true, -- Taurson
    [97793] = true, -- Flamescale
    [97928] = true, -- Tamed Coralback
    [97933] = true, -- Crab Rider Grmlrml
    [98024] = true, -- Luggut the Eggeater
    [98299] = true, -- Bodash the Hoarder
    [98311] = true, -- Mrrklr
    [98890] = true, -- Slumber
    [99846] = true, -- Raging Earth
    [99886] = true, -- Pacified Earth
    [99929] = true, -- Flotsam
    [100230] = true, -- "Sure-Shot" Arnie
    [100231] = true, -- Dargok Thunderuin
    [100232] = true, -- Ryael Dawndrifter
    [100302] = true, -- Puck
    [100303] = true, -- Zenobia
    [100495] = true, -- Devouring Darkness
    [101077] = true, -- Sekhan
    [101649] = true, -- Frostshard
    [102863] = true, -- Bruiser
    [104481] = true, -- Ala'washte
    [104484] = true, -- Olokk the Shipbreaker
    [104513] = true, -- Defilia
    [104517] = true, -- Mawat'aki
    [104524] = true, -- Ormagrogg
    [107924] = true, -- Darkfiend Tormentor
    [109498] = true, -- Xaander
    [109500] = true, -- Jak
    [109501] = true, -- Darkful
    [110378] = true, -- Drugon the Frostblood
    [125951] = true -- Obsidian Deathwarder
}

-- ----------------------------------------------------------------------------
-- Mardum, the Shattered Abyss
-- ----------------------------------------------------------------------------
Maps[MapID.MardumTheShatteredAbyss].NPCs = {
    [97057] = true, -- Overseer Brutarg
    [97058] = true, -- Count Nefarious
    [97059] = true, -- King Voras
    [97370] = true -- General Volroth
}

-- ----------------------------------------------------------------------------
-- Vault of the Wardens
-- ----------------------------------------------------------------------------
Maps[MapID.VaultOfTheWardens].NPCs = {
    [96997] = true, -- Kethrazor
    [97069] = true -- Wrath-Lord Lekos
}

-- ----------------------------------------------------------------------------
-- Suramar
-- ----------------------------------------------------------------------------
Maps[MapID.Suramar].NPCs = {
    [99610] = true, -- Garvrulg
    [99792] = true, -- Elfbane
    [99899] = true, -- Vicious Whale Shark
    [100864] = true, -- Cora'kar
    [102303] = true, -- Lieutenant Strathmar
    [103183] = true, -- Rok'nash
    [103203] = true, -- Jetsam
    [103214] = true, -- Har'kess the Insatiable
    [103223] = true, -- Hertha Grimdottir
    [103575] = true, -- Reef Lord Raj'his
    [103787] = true, -- Baconlisk
    [103827] = true, -- King Morgalash
    [103841] = true, -- Shadowquill
    [104519] = true, -- Colerian
    [104521] = true, -- Alteria
    [104522] = true, -- Selenyi
    [104698] = true, -- Colerian
    [105547] = true, -- Rauren
    [105632] = true, -- Broodmother Shu'malis
    [105728] = true, -- Scythemaster Cil'raman
    [105739] = true, -- Sanaar
    [105899] = true, -- Oglok the Furious
    [106351] = true, -- Artificer Lothaire
    [106526] = true, -- Lady Rivantas
    [106532] = true, -- Inquisitor Volitix
    [107846] = true, -- Pinchshank
    [109054] = true, -- Shal'an
    [109943] = true, -- Ana-Mouz
    [109954] = true, -- Magister Phaedris
    [110024] = true, -- Mal'Dreth the Corruptor
    [110321] = true, -- Na'zak the Fiend
    [110340] = true, -- Myonix
    [110438] = true, -- Siegemaster Aedrin
    [110577] = true, -- Oreth the Vile
    [110656] = true, -- Arcanist Lylandre
    [110726] = true, -- Cadraeus
    [110824] = true, -- Tideclaw
    [110832] = true, -- Gorgroth
    [110870] = true, -- Apothecary Faldren
    [110944] = true, -- Guardian Thor'el
    [111007] = true, -- Randril
    [111197] = true, -- Anax
    [111329] = true, -- Matron Hagatha
    [111649] = true, -- Ambassador D'vwinn
    [111651] = true, -- Degren
    [111653] = true, -- Miasu
    [112497] = true, -- Maia the White
    [112705] = true, -- Achronos
    [112756] = true, -- Sorallus
    [112757] = true, -- Magistrix Vilessa
    [112758] = true, -- Auditor Esiel
    [112759] = true, -- Az'jatar
    [112760] = true, -- Volshax, Breaker of Will
    [112802] = true, -- Mar'tura
    [113368] = true, -- Llorian
    [113694] = true -- Pashya
}

-- ----------------------------------------------------------------------------
-- Halls of Valor
-- ----------------------------------------------------------------------------
Maps[MapID.HallsOfValor].NPCs = {
    [96647] = true, -- Earlnoc the Beastbreaker
    [99802] = true -- Arthfael
}

-- ----------------------------------------------------------------------------
-- Eye of Azshara
-- ----------------------------------------------------------------------------
Maps[MapID.EyeOfAzshara].NPCs = {
    [91788] = true, -- Shellmaw
    [108543] = true, -- Dread Captain Thedon
    [101411] = true, -- Gom Crabbar
    [101467] = true, -- Jaggen-Ra
    [108541] = true, -- Dread Corsair
    [111573] = true -- Kosumoth the Hungering
}

-- ----------------------------------------------------------------------------
-- Darkheart Thicket
-- ----------------------------------------------------------------------------
Maps[MapID.DarkheartThicket].NPCs = {
    [99362] = true, -- Kudzilla
    [101660] = true -- Rage Rot
}

-- ----------------------------------------------------------------------------
-- Thunder Totem
-- ----------------------------------------------------------------------------
Maps[MapID.ThunderTotem].NPCs = {
    [101077] = true -- Sekhan
}
