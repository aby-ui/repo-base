-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

private.NPC_INFO = {
	[147199] = { zoneID = 0, displayID = 22773 }; --Atrivar the Cursed
	[147200] = { zoneID = 0, displayID = 36891 }; --The Shambler
	[149040] = { zoneID = 0, displayID = 40301 }; --The Spiritweaver
	[153667] = { zoneID = 0, displayID = 91878 }; --Slagbelt
	[156237] = { zoneID = 0, displayID = 94919 }; --Imperator Dara
	[157145] = { zoneID = 0, displayID = 91889 }; --Gravitas
	[157149] = { zoneID = 0, displayID = 92703 }; --Heartseeker
	[158060] = { zoneID = 0, displayID = 55139 }; --Vinyeti <Vignette Placeholder>
	[158760] = { zoneID = 0, displayID = 93623 }; --Lord Chamberlain
	[158761] = { zoneID = 0, displayID = 93622 }; --Mordai Darkwhisper
	[158782] = { zoneID = 0, displayID = 93778 }; --Daniela Darkwhisper
	[158783] = { zoneID = 0, displayID = 93777 }; --Lady Sybelle
	[159031] = { zoneID = 0, displayID = 93622 }; --Rare Template
	[159032] = { zoneID = 0, displayID = 93623 }; --Rare Elite Template
	[159038] = { zoneID = 0, displayID = 93622 }; --Rare Template
	[159039] = { zoneID = 0, displayID = 93623 }; --Rare Elite Template
	[159056] = { zoneID = 0, displayID = 93622 }; --Rare Template
	[159057] = { zoneID = 0, displayID = 93622 }; --Rare Template
	[159184] = { zoneID = 0, displayID = 93811 }; --Prince Vrand <House of Dust>
	[159189] = { zoneID = 0, displayID = 93808 }; --Fallen One
	[159193] = { zoneID = 0, displayID = 93815 }; --Mucktooth
	[159194] = { zoneID = 0, displayID = 93108 }; --Crystal-Tooth
	[159195] = { zoneID = 0, displayID = 93166 }; --Ancient Bristleback
	[159196] = { zoneID = 0, displayID = 92704 }; --Kir'rik the Drinker
	[159197] = { zoneID = 0, displayID = 92703 }; --Lifeleech
	[159207] = { zoneID = 0, displayID = 94769 }; --Gizzak the Snatcher
	[159221] = { zoneID = 0, displayID = 76876 }; --Bleakmane
	[159231] = { zoneID = 0, displayID = 93831 }; --General Draven
	[159234] = { zoneID = 0, displayID = 93830 }; --Keridin
	[159323] = { zoneID = 0, displayID = 93165 }; --Stoneward Trampler
	[159363] = { zoneID = 0, displayID = 93909 }; --Nemea
	[159364] = { zoneID = 0, displayID = 93910 }; --High Courier Taelica
	[159374] = { zoneID = 0, displayID = 93915 }; --Aegeus Cloudshearer
	[159375] = { zoneID = 0, displayID = 93914 }; --Karan <The Sword of Hope>
	[159379] = { zoneID = 0, displayID = 93881 }; --Nadia
	[159383] = { zoneID = 0, displayID = 93880 }; --Nikolaos
	[159433] = { zoneID = 0, displayID = 93889 }; --Mateos
	[159436] = { zoneID = 0, displayID = 93890 }; --Elagea
	[159450] = { zoneID = 0, displayID = 93912 }; --Callie the Nightmaiden
	[159451] = { zoneID = 0, displayID = 93911 }; --Valiana Skyshadow
	[159456] = { zoneID = 0, displayID = 93916 }; --Vasilios the Truth-Breaker
	[159457] = { zoneID = 0, displayID = 93913 }; --Xandar <The Sword of Vengeance>
	[159480] = { zoneID = 0, displayID = 93930 }; --Hopo
	[159483] = { zoneID = 0, displayID = 93929 }; --Wiltix the Loyal
	[159492] = { zoneID = 0, displayID = 93938 }; --Foul-Tongue Cyrlix
	[159493] = { zoneID = 0, displayID = 96073 }; --Thel'naz the Bonespeaker
	[159500] = { zoneID = 0, displayID = 93948 }; --Sludgehook the Tenderizer
	[159501] = { zoneID = 0, displayID = 93945 }; --Slimegut
	[159507] = { zoneID = 0, displayID = 93953 }; --Al'ximir
	[159515] = { zoneID = 0, displayID = 93964 }; --Moonberry
	[159522] = { zoneID = 0, displayID = 93965 }; --Dreamthief
	[159525] = { zoneID = 0, displayID = 93971 }; --Thalanil
	[159534] = { zoneID = 0, displayID = 93973 }; --Li'sshiss
	[159539] = { zoneID = 0, displayID = 93976 }; --Oranomonos the Everbranching
	[159949] = { zoneID = 0, displayID = 92192 }; --Gleaming Challenger
	[159950] = { zoneID = 0, displayID = 92193 }; --Skystormer
	[159984] = { zoneID = 0, displayID = 92664 }; --Tectis
	[159985] = { zoneID = 0, displayID = 92663 }; --Herculon
	[159992] = { zoneID = 0, displayID = 92664 }; --Gildbreaker <Paragon's End>
	[159995] = { zoneID = 0, displayID = 92663 }; --Fist of the Paragons
	[160014] = { zoneID = 0, displayID = 92676 }; --Pureheart
	[160018] = { zoneID = 0, displayID = 92677 }; --Oathbreaker
	[160050] = { zoneID = 0, displayID = 93496 }; --Eldenwing
	[160051] = { zoneID = 0, displayID = 93462 }; --Nemaeus
	[160052] = { zoneID = 0, displayID = 93464 }; --Great Kingmane
	[160079] = { zoneID = 0, displayID = 94151 }; --Gemshell
	[160080] = { zoneID = 0, displayID = 94150 }; --Elydorea <The Great Terrapin>
	[160310] = { zoneID = 0, displayID = 94203 }; --Gnashmaw the Broodqueen
	[160311] = { zoneID = 0, displayID = 94202 }; --Spitscar the Flesh-Melter
	[160321] = { zoneID = 0, displayID = 93791 }; --Brighthide
	[160328] = { zoneID = 0, displayID = 94227 }; --Zyxua
	[160331] = { zoneID = 0, displayID = 93853 }; --Thirstlurker
	[160332] = { zoneID = 0, displayID = 93853 }; --Gruux
	[160337] = { zoneID = 0, displayID = 94228 }; --Jedu <The Final Doom>
	[160549] = { zoneID = 0, displayID = 94287 }; --Ironhoof
	[160551] = { zoneID = 0, displayID = 93756 }; --Velix <The Great Huntress>
	[160552] = { zoneID = 0, displayID = 93760 }; --Fleetpaw
	[160556] = { zoneID = 0, displayID = 94292 }; --Windmane
	[160557] = { zoneID = 0, displayID = 94297 }; --Mystra <The Ancient Steed>
	[160562] = { zoneID = 0, displayID = 93622 }; --REUSE
	[160587] = { zoneID = 0, displayID = 94406 }; --Bonespinner
	[160588] = { zoneID = 0, displayID = 94407 }; --Corpsebreeder
	[160592] = { zoneID = 0, displayID = 93471 }; --Coatylis
	[160731] = { zoneID = 0, displayID = 94380 }; --General Kaal
	[160736] = { zoneID = 0, displayID = 94379 }; --First Talon Syndaal
	[160760] = { zoneID = 0, displayID = 92412 }; --Warden Skoldus
	[160765] = { zoneID = 0, displayID = 92412 }; --Vol'kalar <Champion of Agony>
	[160771] = { zoneID = 0, displayID = 92781 }; --Morticar the Soul-Binder
	[160776] = { zoneID = 0, displayID = 94400 }; --Rynhild <Grasp of the Maw>
	[160777] = { zoneID = 0, displayID = 94397 }; --Karija <The Wings of Death>
	[160782] = { zoneID = 0, displayID = 93213 }; --Malakas <The Endless Shadow>
	[160783] = { zoneID = 0, displayID = 93213 }; --Valioc
	[160787] = { zoneID = 0, displayID = 92629 }; --Horgul, Hound of Darkness
	[160788] = { zoneID = 0, displayID = 92629 }; --Zurdun <The Dark Watcher>
	[160792] = { zoneID = 0, displayID = 93157 }; --Oblivion-Seeker
	[160833] = { zoneID = 0, displayID = 92415 }; --Barithur <Assassin of Souls>
	[160834] = { zoneID = 0, displayID = 92415 }; --Shade-Hunter Kavrok
	[160835] = { zoneID = 0, displayID = 92418 }; --Warden Kas'volar
	[160836] = { zoneID = 0, displayID = 92418 }; --Anduris <The Chains of Woe>
	[160855] = { zoneID = 0, displayID = 94415 }; --Usula <The Consumer>
	[160861] = { zoneID = 0, displayID = 94280 }; --Essence of Loss
	[160865] = { zoneID = 0, displayID = 94527 }; --Excrutiating Thoughts
	[160866] = { zoneID = 0, displayID = 94276 }; --Gluttonous
	[160943] = { zoneID = 0, displayID = 53875 }; --Lava Wyrm
	[161825] = { zoneID = 0, displayID = 55139 }; --Vinyeti <Vignette Placeholder>
	[162314] = { zoneID = 0, displayID = 94756 }; --Lord Mortegore
	[162323] = { zoneID = 0, displayID = 94835 }; --Discarded
	[162394] = { zoneID = 0, displayID = 92779 }; --Extricator Vlavios
	[162627] = { zoneID = 0, displayID = 94913 }; --Leatherhide
	[162628] = { zoneID = 0, displayID = 94928 }; --Rotclaw the Pestilent
	[162630] = { zoneID = 0, displayID = 94936 }; --Stitched One
	[162631] = { zoneID = 0, displayID = 94937 }; --Vulgor <The Iron Amalgamation>
	[162658] = { zoneID = 0, displayID = 94941 }; --Dark Cathedral
	[162759] = { zoneID = 0, displayID = 54317 }; --Moregorger
	[163004] = { zoneID = 0, displayID = 97777 }; --Shrieking Chorus
	[163005] = { zoneID = 0, displayID = 97777 }; --Many-Voiced Horror
	[163054] = { zoneID = 0, displayID = 95073 }; --Hunt-Captain Korayn
	[163056] = { zoneID = 0, displayID = 95072 }; --Sharian
	[163188] = { zoneID = 0, displayID = 94190 }; --Gormboar
	[163238] = { zoneID = 0, displayID = 95115 }; --Eldercaw the Patriarch
	[163240] = { zoneID = 0, displayID = 95115 }; --Downfeather
	[163496] = { zoneID = 0, displayID = 95195 }; --Niya
	[163525] = { zoneID = 0, displayID = 95200 }; --Lightseeker
	[163531] = { zoneID = 0, displayID = 95201 }; --Great Duskflutter
	[163538] = { zoneID = 0, displayID = 99060 }; --The Tarragrue
	[164212] = { zoneID = 0, displayID = 95381 }; --Commander Bonescythe
	[164213] = { zoneID = 0, displayID = 95378 }; --Urdo the Invulerable
	[164239] = { zoneID = 0, displayID = 94229 }; --Anomalous Worldeater
	[164526] = { zoneID = 0, displayID = 95588 }; --Blargus the Stone-Carver
	[164789] = { zoneID = 0, displayID = 95553 }; --Silkskimmer
	[165000] = { zoneID = 0, displayID = 93213 }; --Valioc
	[165223] = { zoneID = 0, displayID = 95689 }; --Vy'nix the Feaster
	[165227] = { zoneID = 0, displayID = 95696 }; --Tricky Tommith
	[165287] = { zoneID = 0, displayID = 95718 }; --Keepwatcher
	[165365] = { zoneID = 0, displayID = 94200 }; --Gorm Monstrosity
	[165441] = { zoneID = 0, displayID = 95796 }; --Vashiri Darkthief
	[165444] = { zoneID = 0, displayID = 95791 }; --Toxigrow
	[165451] = { zoneID = 0, displayID = 97321 }; --Bonecrunch
	[165686] = { zoneID = 0, displayID = 95209 }; --Ashen Amalgamation
	[165893] = { zoneID = 0, displayID = 16170 }; --Spirit of the Damned
	[166001] = { zoneID = 0, displayID = 96062 }; --Shadeweaver
	[166016] = { zoneID = 0, displayID = 96087 }; --Gnarlwood
	[166308] = { zoneID = 0, displayID = 96240 }; --Plaguemuck
	[166582] = { zoneID = 0, displayID = 90424 }; --Skira the Revenant
	[166588] = { zoneID = 0, displayID = 96338 }; --Dying Breath
	[166684] = { zoneID = 0, displayID = 92411 }; --Warden Arkoban
	[168149] = { zoneID = 0, displayID = 94297 }; --Night Mare
	[169379] = { zoneID = 0, displayID = 97024 }; --Lord Inquisitor Winze
	[169503] = { zoneID = 0, displayID = 94195 }; --Deifir the Untamed
	[171216] = { zoneID = 0, displayID = 94305 }; --Fallen Aspirant Eolis
	[171405] = { zoneID = 0, displayID = 95695 }; --Tricky Trik
	[171540] = { zoneID = 0, displayID = 90580 }; --Swollen Experiment
	[171708] = { zoneID = 0, displayID = 97759 }; --Drezgruda <The Fifth Talon>
	[171741] = { zoneID = 0, displayID = 97766 }; --Kedu <The Final Fate>
	[172384] = { zoneID = 0, displayID = 80465 }; --Withered Emberbloom
	[172890] = { zoneID = 0, displayID = 97777 }; --Yero the Skittish
	[173293] = { zoneID = 0, displayID = 94614 }; --Lady Audat
	[174473] = { zoneID = 0, displayID = 97524 }; --Echo of Aella <Hand of Courage>
	[175011] = { zoneID = 0, displayID = 548 }; --Foe Reaper 4000
	[175101] = { zoneID = 0, displayID = 95752 }; --Thespian's Reward
	[175427] = { zoneID = 0, displayID = 99661 }; --Amalgamation of Filth
	[175482] = { zoneID = 0, displayID = 97777 }; --Yero the Skittish
	[175968] = { zoneID = 0, displayID = 92627 }; --The Untamed
	[5809] = { zoneID = 1, artID = { 2 }, x = 0.592, y = 0.582, overlay = { "0.59-0.59" }, friendly = { "A" }, displayID = 33165 }; --Sergeant Curtis
	[5823] = { zoneID = 1, artID = { 2 }, x = 0.344, y = 0.44599998, overlay = { "0.34-0.43","0.35-0.44","0.35-0.45","0.35-0.46","0.36-0.44","0.37-0.44","0.37-0.45","0.37-0.47","0.37-0.46","0.38-0.44","0.38-0.43","0.38-0.46","0.38-0.48","0.39-0.46","0.39-0.45","0.39-0.44" }, displayID = 2491 }; --Death Flayer
	[5824] = { zoneID = 1, artID = { 2 }, x = 0.38599998, y = 0.538, overlay = { "0.42-0.38","0.42-0.39","0.43-0.38","0.44-0.49","0.44-0.50" }, displayID = 1346 }; --Captain Flat Tusk
	[5826] = { zoneID = 1, artID = { 2 }, x = 0.432, y = 0.39400002, overlay = { "0.43-0.49","0.43-0.50","0.47-0.49" }, displayID = 6113 }; --Geolord Mottle
	[5822] = { zoneID = 5, artID = { 7 }, x = 0.21200001, y = 0.608, overlay = { "0.21-0.57","0.22-0.58","0.23-0.62","0.38-0.40","0.55-0.23","0.58-0.27" }, displayID = 4594 }; --Felweaver Scornn
	[3058] = { zoneID = 7, artID = { 8 }, x = 0.48, y = 0.686, overlay = { "0.48-0.67","0.48-0.69","0.49-0.69","0.50-0.66","0.50-0.68","0.51-0.69","0.51-0.66","0.51-0.65","0.51-0.68","0.52-0.63","0.53-0.62","0.53-0.61","0.53-0.69","0.54-0.68","0.54-0.62","0.54-0.7","0.55-0.68","0.56-0.63","0.56-0.7","0.57-0.65","0.57-0.66","0.57-0.67","0.57-0.69" }, displayID = 10916 }; --Arra'chea
	[3068] = { zoneID = 7, artID = { 8 }, x = 0.42400002, y = 0.45400003, overlay = { "0.42-0.46","0.43-0.41","0.44-0.47","0.45-0.46","0.45-0.47","0.46-0.46","0.47-0.40","0.47-0.46","0.48-0.43","0.49-0.43","0.5-0.42" }, displayID = 1961 }; --Mazzranache
	[43613] = { zoneID = 7, artID = { 8 }, x = 0.338, y = 0.37, overlay = { "0.33-0.37" }, displayID = 33430 }; --Doomsayer Wiserunner
	[5785] = { zoneID = 7, artID = { 8 }, x = 0.32, y = 0.244, overlay = { "0.52-0.11","0.53-0.11","0.53-0.12" }, displayID = 2163 }; --Sister Hatelash
	[5786] = { zoneID = 7, artID = { 8 }, x = 0.48400003, y = 0.704, overlay = { "0.48-0.7","0.53-0.71" }, displayID = 275 }; --Snagglespear
	[5787] = { zoneID = 7, artID = { 8 }, x = 0.60400003, y = 0.474, displayID = 6692 }; --Enforcer Emilgund
	[5807] = { zoneID = 7, artID = { 8 }, x = 0.496, y = 0.22, overlay = { "0.49-0.25","0.5-0.23","0.50-0.26","0.50-0.21","0.51-0.28","0.51-0.21","0.52-0.20","0.53-0.19","0.53-0.29","0.54-0.20","0.55-0.24","0.55-0.25" }, displayID = 1973 }; --The Rake
	[3270] = { zoneID = 10, artID = { 11 }, x = 0.564, y = 0.516, overlay = { "0.58-0.49","0.60-0.52","0.61-0.53" }, displayID = 6095 }; --Elder Mystic Razorsnout
	[3295] = { zoneID = 10, artID = { 11 }, x = 0.574, y = 0.192, overlay = { "0.57-0.20" }, displayID = 360 }; --Sludge Anomaly
	[3398] = { zoneID = 10, artID = { 11 }, x = 0.3997237, y = 0.738891, overlay = { "0.4-0.74","0.40-0.74" }, displayID = 1397 }; --Gesharahan
	[3470] = { zoneID = 10, artID = { 11 }, x = 0.412, y = 0.39200002, overlay = { "0.41-0.38","0.42-0.38" }, displayID = 5047 }; --Rathorian
	[5828] = { zoneID = 10, artID = { 11 }, x = 0.672, y = 0.64, displayID = 4424 }; --Humar the Pridelord
	[5830] = { zoneID = 10, artID = { 11 }, x = 0.254, y = 0.33200002, displayID = 10876 }; --Sister Rathtalon
	[5831] = { zoneID = 10, artID = { 11 }, x = 0.632, y = 0.634, overlay = { "0.64-0.60" }, displayID = 6084 }; --Swiftmane
	[5835] = { zoneID = 10, artID = { 11 }, x = 0.572, y = 0.19399999, overlay = { "0.57-0.20" }, displayID = 4593 }; --Foreman Grills
	[5836] = { zoneID = 10, artID = { 11 }, x = 0.58, y = 0.204, displayID = 7049 }; --Engineer Whirleygig
	[5837] = { zoneID = 10, artID = { 11 }, x = 0.318, y = 0.48400003, overlay = { "0.32-0.48","0.32-0.52","0.32-0.53","0.4-0.45" }, displayID = 4874 }; --Stonearm
	[5838] = { zoneID = 10, artID = { 11 }, x = 0.5130981, y = 0.8384, overlay = { "0.51-0.75","0.52-0.75","0.53-0.87","0.57-0.82","0.58-0.77" }, displayID = 9448 }; --Brokespear
	[5841] = { zoneID = 10, artID = { 11 }, x = 0.59, y = 0.806, overlay = { "0.59-0.79" }, displayID = 9533 }; --Rocklance
	[5842] = { zoneID = 10, artID = { 11 }, x = 0.634, y = 0.36, overlay = { "0.63-0.35" }, displayID = 1337 }; --Takk the Leaper
	[5865] = { zoneID = 10, artID = { 11 }, x = 0.45200002, y = 0.528, overlay = { "0.45-0.33","0.48-0.51" }, displayID = 1043 }; --Dishu
	[3652] = { zoneID = 11, artID = { 12 }, x = 0.60400003, y = 0.38599998, overlay = { "0.60-0.40","0.61-0.41","0.62-0.38","0.62-0.42","0.62-0.37" }, displayID = 1092 }; --Trigore the Lasher
	[3672] = { zoneID = 11, artID = { 12 }, x = 0.60034436, y = 0.4967057, overlay = { "0.67-0.57","0.68-0.58","0.68-0.59","0.70-0.57","0.74-0.25","0.78-0.4","0.78-0.40","0.79-0.39" }, displayID = 4212 }; --Boahn
	[141615] = { zoneID = 14, artID = { 1137 }, x = 0.308, y = 0.432, overlay = { "0.29-0.44","0.29-0.45","0.30-0.43","0.30-0.44","0.30-0.45" }, displayID = 37986, questID = { 53017,53506 } }; --Burning Goliath
	[141616] = { zoneID = 14, artID = { 1137 }, x = 0.466, y = 0.52, overlay = { "0.45-0.52","0.46-0.52","0.46-0.51" }, displayID = 54195, questID = { 53023,53527 } }; --Thundering Goliath
	[141618] = { zoneID = 14, artID = { 1137 }, x = 0.622, y = 0.32599998, overlay = { "0.61-0.31","0.62-0.31","0.62-0.32" }, displayID = 62045, questID = { 53018,53531 } }; --Cresting Goliath
	[141620] = { zoneID = 14, artID = { 1137 }, x = 0.30200002, y = 0.582, overlay = { "0.29-0.59","0.29-0.61","0.29-0.60","0.30-0.58" }, displayID = 37987, questID = { 53021,53523 } }; --Rumbling Goliath
	[141668] = { zoneID = 14, artID = { 1137 }, x = 0.58, y = 0.35, overlay = { "0.56-0.34","0.56-0.36","0.56-0.35","0.56-0.33","0.57-0.34","0.57-0.35","0.57-0.36","0.57-0.38","0.57-0.37","0.58-0.33","0.58-0.35" }, displayID = 77145, questID = { 53059,53508 } }; --Echo of Myzrael
	[141942] = { zoneID = 14, artID = { 1137 }, x = 0.48599997, y = 0.77599996, overlay = { "0.46-0.77","0.47-0.78","0.48-0.78","0.48-0.77" }, displayID = 87784, questID = { 53057,53516 } }; --Molok the Crusher
	[142112] = { zoneID = 14, artID = { 1137 }, x = 0.49, y = 0.83800006, overlay = { "0.49-0.83" }, displayID = 88105, questID = { 53058,53513 } }; --Kor'gresh Coldrage
	[142423] = { zoneID = 14, artID = { 1137 }, x = 0.33, y = 0.376, overlay = { "0.27-0.56","0.33-0.36","0.33-0.37" }, displayID = 64568, questID = { 53014,53518 } }; --Overseer Krix
	[142433] = { zoneID = 14, artID = { 1137 }, x = 0.62, y = 0.316, overlay = { "0.30-0.48","0.47-0.49","0.59-0.30","0.59-0.27","0.59-0.28","0.59-0.31","0.59-0.32","0.6-0.32","0.60-0.34","0.61-0.31","0.62-0.31" }, displayID = 12814, questID = { 53019,53510 } }; --Fozruk
	[142435] = { zoneID = 14, artID = { 1137 }, x = 0.378, y = 0.65599996, overlay = { "0.35-0.64","0.35-0.61","0.35-0.62","0.35-0.63","0.36-0.64","0.36-0.61","0.36-0.62","0.36-0.65","0.37-0.65","0.37-0.63","0.37-0.66","0.37-0.64" }, displayID = 54845, questID = { 53020,53519 } }; --Plaguefeather
	[142436] = { zoneID = 14, artID = { 1137 }, x = 0.186, y = 0.278, overlay = { "0.12-0.52","0.18-0.28","0.18-0.27" }, displayID = 37771, questID = { 53016,53522 } }; --Ragebeak
	[142437] = { zoneID = 14, artID = { 1137 }, x = 0.576, y = 0.45599997, overlay = { "0.56-0.46","0.56-0.44","0.56-0.45","0.57-0.43","0.57-0.44","0.57-0.45" }, displayID = 61297, questID = { 53022,53526 } }; --Skullripper
	[142438] = { zoneID = 14, artID = { 1137 }, x = 0.576, y = 0.546, overlay = { "0.56-0.54","0.56-0.53","0.57-0.53","0.57-0.54" }, displayID = 46232, questID = { 53024,53528 } }; --Venomarus
	[142440] = { zoneID = 14, artID = { 1137 }, x = 0.148, y = 0.354, overlay = { "0.13-0.35","0.13-0.36","0.13-0.37","0.13-0.34","0.13-0.38","0.14-0.35","0.14-0.37","0.14-0.36","0.14-0.38" }, displayID = 66633, questID = { 53015,53529 } }; --Yogursa
	[142508] = { zoneID = 14, artID = { 1137 }, x = 0.236, y = 0.216, overlay = { "0.21-0.19","0.21-0.21","0.21-0.23","0.22-0.21","0.22-0.20","0.22-0.18","0.22-0.22","0.22-0.19","0.23-0.21","0.23-0.22" }, displayID = 56952, questID = { 53013,53505 } }; --Branchlord Aldrus
	[142662] = { zoneID = 14, artID = { 1137 }, x = 0.796, y = 0.296, overlay = { "0.79-0.29" }, displayID = 27190, questID = { 53060,53511 } }; --Geomancer Flintdagger
	[142682] = { zoneID = 14, artID = { 1137 }, x = 0.628, y = 0.81, overlay = { "0.62-0.80","0.62-0.81" }, displayID = 88246, questID = { 53094,53530 } }; --Zalas Witherbark
	[142683] = { zoneID = 14, artID = { 1137 }, x = 0.43, y = 0.566, overlay = { "0.42-0.56","0.43-0.56" }, displayID = 88093, questID = { 53092,53524 } }; --Ruul Onestone
	[142684] = { zoneID = 14, artID = { 1137 }, x = 0.266, y = 0.474, overlay = { "0.24-0.47","0.25-0.48","0.26-0.47" }, displayID = 87968, questID = { 53089,53514 } }; --Kovork
	[142686] = { zoneID = 14, artID = { 1137 }, x = 0.22600001, y = 0.50200003, overlay = { "0.22-0.49","0.22-0.50" }, displayID = 88106, questID = { 53086,53509 } }; --Foulbelly
	[142688] = { zoneID = 14, artID = { 1137 }, x = 0.506, y = 0.612, overlay = { "0.50-0.37","0.50-0.61","0.50-0.36" }, displayID = 4027, questID = { 53084,53507 } }; --Darbel Montrose
	[142690] = { zoneID = 14, artID = { 1137 }, x = 0.51, y = 0.402, overlay = { "0.50-0.57","0.50-0.40","0.51-0.40" }, displayID = 4026, questID = { 53093,53525 } }; --Singer
	[142692] = { zoneID = 14, artID = { 1137 }, x = 0.676, y = 0.608, overlay = { "0.67-0.60" }, displayID = 88253, questID = { 53091,53517 } }; --Nimar the Slayer
	[142709] = { zoneID = 14, artID = { 1137 }, x = 0.682, y = 0.66800004, overlay = { "0.64-0.71","0.65-0.68","0.65-0.70","0.65-0.69","0.65-0.7","0.65-0.71","0.66-0.67","0.66-0.66","0.66-0.65","0.67-0.66","0.68-0.66" }, displayID = 88188, questID = { 53083,53504 } }; --Beastrider Kama
	[142716] = { zoneID = 14, artID = { 1137 }, x = 0.52, y = 0.766, overlay = { "0.51-0.76","0.52-0.72","0.52-0.73","0.52-0.74","0.52-0.75","0.52-0.76" }, displayID = 88095, questID = { 53090,53515 } }; --Man-Hunter Rog
	[142725] = { zoneID = 14, artID = { 1137 }, x = 0.268, y = 0.32599998, overlay = { "0.19-0.61","0.26-0.31","0.26-0.32","0.26-0.33" }, displayID = 60824, questID = { 53087,53512 } }; --Horrific Apparition
	[142739] = { zoneID = 14, artID = { 1137 }, x = 0.496, y = 0.39200002, overlay = { "0.47-0.41","0.48-0.40","0.49-0.37","0.49-0.39" }, friendly = { "A" }, displayID = 87988, questID = { 53088 } }; --Knight-Captain Aldrin
	[142741] = { zoneID = 14, artID = { 1137 }, x = 0.538, y = 0.572, overlay = { "0.53-0.56","0.53-0.57","0.53-0.58" }, friendly = { "H" }, displayID = 87703, questID = { 53085 } }; --Doomrider Helgrim
	[2598] = { zoneID = 14, artID = { 15 }, x = 0.192, y = 0.64599997, displayID = 4027 }; --Darbel Montrose
	[2600] = { zoneID = 14, artID = { 15 }, x = 0.274, y = 0.278, displayID = 4026 }; --Singer
	[2601] = { zoneID = 14, artID = { 15 }, x = 0.14, y = 0.674, overlay = { "0.14-0.69","0.15-0.68" }, displayID = 11551 }; --Foulbelly
	[2602] = { zoneID = 14, artID = { 15 }, x = 0.18, y = 0.312, overlay = { "0.18-0.30","0.19-0.30" }, displayID = 11572 }; --Ruul Onestone
	[2603] = { zoneID = 14, artID = { 15 }, x = 0.24200001, y = 0.444, displayID = 610 }; --Kovork
	[2604] = { zoneID = 14, artID = { 15 }, x = 0.466, y = 0.77199996, overlay = { "0.47-0.75","0.47-0.77","0.47-0.76","0.47-0.78","0.48-0.76","0.48-0.79","0.48-0.77" }, displayID = 536 }; --Molok the Crusher
	[2605] = { zoneID = 14, artID = { 15 }, x = 0.624, y = 0.8, overlay = { "0.62-0.81" }, displayID = 4003 }; --Zalas Witherbark
	[2606] = { zoneID = 14, artID = { 15 }, x = 0.67800003, y = 0.66400003, overlay = { "0.68-0.66" }, displayID = 4033 }; --Nimar the Slayer
	[2609] = { zoneID = 14, artID = { 15 }, x = 0.794, y = 0.294, displayID = 10911 }; --Geomancer Flintdagger
	[2779] = { zoneID = 14, artID = { 15 }, x = 0.14, y = 0.866, overlay = { "0.14-0.92","0.15-0.88","0.16-0.87","0.16-0.93","0.16-0.91","0.17-0.91" }, displayID = 6763 }; --Prince Nazjak
	[50337] = { zoneID = 14, artID = { 15 }, x = 0.22600001, y = 0.876, overlay = { "0.21-0.87","0.21-0.86","0.21-0.88","0.22-0.87","0.22-0.86" }, displayID = 46227 }; --Cackle
	[50770] = { zoneID = {
				[14] = { x = 0.22, y = 0.14, overlay = { "0.21-0.15","0.22-0.14" } };
				[25] = { x = 0.77, y = 0.6, overlay = { "0.77-0.6" } };
			  }, displayID = 46232 }; --null
	[50804] = { zoneID = 14, artID = { 15 }, x = 0.372, y = 0.636, overlay = { "0.35-0.61","0.35-0.62","0.36-0.63","0.36-0.61","0.36-0.62","0.37-0.63" }, displayID = 10827 }; --Ripwing
	[50865] = { zoneID = 14, artID = { 15 }, x = 0.432, y = 0.348, overlay = { "0.41-0.34","0.41-0.35","0.42-0.34","0.42-0.36","0.43-0.34" }, displayID = 21825 }; --Saurix
	[50891] = { zoneID = 14, artID = { 15 }, x = 0.48599997, y = 0.35799998, overlay = { "0.47-0.33","0.48-0.34","0.48-0.36","0.48-0.35" }, displayID = 46235 }; --Boros
	[50940] = { zoneID = 14, artID = { 15 }, x = 0.566, y = 0.566, overlay = { "0.55-0.57","0.56-0.56" }, displayID = 20814 }; --Swee
	[51040] = { zoneID = 14, artID = { 15 }, x = 0.268, y = 0.272, overlay = { "0.25-0.27","0.26-0.27" }, displayID = 30222 }; --Snuffles
	[51063] = { zoneID = 14, artID = { 15 }, x = 0.48599997, y = 0.814, overlay = { "0.47-0.82","0.48-0.81" }, displayID = 46226 }; --Phalanax
	[51067] = { zoneID = 14, artID = { 15 }, x = 0.306, y = 0.614, overlay = { "0.29-0.59","0.3-0.61","0.30-0.60","0.30-0.63","0.30-0.61" }, displayID = 36634 }; --Glint
	[14224] = { zoneID = 15, artID = { 16 }, x = 0.78, y = 0.32599998, overlay = { "0.78-0.31" }, displayID = 6889 }; --7:XT
	[2744] = { zoneID = 15, artID = { 16 }, x = 0.39400002, y = 0.244, displayID = 4937 }; --Shadowforge Commander
	[2749] = { zoneID = 15, artID = { 16 }, x = 0.094, y = 0.488, overlay = { "0.09-0.49","0.27-0.37" }, displayID = 10802 }; --Barricade
	[2751] = { zoneID = 15, artID = { 16 }, x = 0.48400003, y = 0.262, overlay = { "0.48-0.25","0.49-0.25" }, displayID = 5747 }; --War Golem
	[2752] = { zoneID = 15, artID = { 16 }, x = 0.158, y = 0.29799998, overlay = { "0.16-0.29" }, displayID = 8550 }; --Rumbler
	[2753] = { zoneID = 15, artID = { 16 }, x = 0.39400002, y = 0.582, overlay = { "0.39-0.59","0.39-0.60","0.40-0.6","0.40-0.60","0.40-0.58","0.41-0.58" }, displayID = 9372 }; --Barnabus
	[2754] = { zoneID = 15, artID = { 16 }, x = 0.08, y = 0.66400003, overlay = { "0.08-0.65","0.08-0.67" }, displayID = 10040 }; --Anathemus
	[2850] = { zoneID = 15, artID = { 16 }, x = 0.22399999, y = 0.608, overlay = { "0.22-0.6","0.23-0.61" }, displayID = 6082 }; --Broken Tooth
	[2931] = { zoneID = 15, artID = { 16 }, x = 0.55, y = 0.432, overlay = { "0.55-0.44","0.55-0.45","0.55-0.42","0.56-0.43","0.56-0.44" }, displayID = 1210 }; --Zaricotl
	[50726] = { zoneID = 15, artID = { 16 }, x = 0.324, y = 0.342, overlay = { "0.32-0.35","0.32-0.34" }, displayID = 46250 }; --Kalixx
	[50728] = { zoneID = 15, artID = { 16 }, x = 0.70199996, y = 0.53400004, overlay = { "0.69-0.53","0.7-0.53","0.70-0.53" }, displayID = 20308 }; --Deathstrike
	[50731] = { zoneID = 15, artID = { 16 }, x = 0.508, y = 0.726, overlay = { "0.50-0.72" }, displayID = 17062 }; --Needlefang
	[50838] = { zoneID = 15, artID = { 16 }, x = 0.58599997, y = 0.606, overlay = { "0.58-0.60" }, displayID = 46251 }; --Tabbs
	[51000] = { zoneID = 15, artID = { 16 }, x = 0.72199994, y = 0.274, overlay = { "0.70-0.29","0.71-0.28","0.72-0.27" }, displayID = 46248 }; --Blackshell the Impenetrable
	[51007] = { zoneID = 15, artID = { 16 }, x = 0.276, y = 0.38, overlay = { "0.26-0.38","0.27-0.38" }, displayID = 46252 }; --Serkett
	[51018] = { zoneID = 15, artID = { 16 }, x = 0.518, y = 0.342, overlay = { "0.51-0.34" }, displayID = 19996 }; --Zormus
	[51021] = { zoneID = 15, artID = { 16 }, x = 0.23200001, y = 0.376, overlay = { "0.21-0.37","0.23-0.37" }, displayID = 20910 }; --Vorticus
	[45257] = { zoneID = 17, artID = { 18 }, x = 0.606, y = 0.29799998, overlay = { "0.60-0.29" }, displayID = 6786 }; --Mordak Nightbender
	[45258] = { zoneID = 17, artID = { 18 }, x = 0.606, y = 0.754, overlay = { "0.60-0.75" }, displayID = 5029 }; --Cassia the Slitherqueen
	[45260] = { zoneID = 17, artID = { 18 }, x = 0.31, y = 0.706, overlay = { "0.31-0.69","0.31-0.70" }, displayID = 12929 }; --Blackleaf
	[45262] = { zoneID = 17, artID = { 18 }, x = 0.324, y = 0.444, overlay = { "0.32-0.44" }, displayID = 19949 }; --Narixxus the Doombringer
	[7846] = { zoneID = 17, artID = { 18 }, x = 0.512, y = 0.482, overlay = { "0.51-0.50","0.51-0.46","0.51-0.44","0.51-0.47","0.51-0.51","0.51-0.52","0.51-0.53","0.52-0.46","0.52-0.53","0.52-0.49","0.52-0.45","0.53-0.44","0.53-0.54","0.54-0.43","0.54-0.44","0.54-0.45","0.55-0.54","0.55-0.44","0.55-0.43","0.56-0.54","0.56-0.45","0.56-0.53","0.56-0.46","0.57-0.45","0.57-0.48","0.57-0.52","0.57-0.51","0.57-0.49","0.57-0.5" }, displayID = 6378 }; --Teremus the Devourer
	[8296] = { zoneID = 17, artID = { 18 }, x = 0.46400002, y = 0.262, displayID = 11562 }; --Mojo the Twisted
	[8297] = { zoneID = 17, artID = { 18 }, x = 0.46400002, y = 0.39200002, displayID = 11564 }; --Magronos the Unyielding
	[8298] = { zoneID = 17, artID = { 18 }, x = 0.734, y = 0.55, displayID = 10920 }; --Akubar the Seer
	[8299] = { zoneID = 17, artID = { 18 }, x = 0.59400004, y = 0.354, overlay = { "0.59-0.36","0.59-0.38","0.6-0.34","0.6-0.38","0.60-0.33","0.60-0.4","0.61-0.40","0.61-0.32","0.62-0.36","0.62-0.40","0.62-0.41","0.63-0.40","0.63-0.33","0.64-0.33","0.64-0.39","0.64-0.38","0.64-0.36","0.64-0.37","0.64-0.35" }, displayID = 388 }; --Spiteflayer
	[8300] = { zoneID = 17, artID = { 18 }, x = 0.49, y = 0.344, overlay = { "0.49-0.35","0.49-0.36" }, displayID = 10904 }; --Ravage
	[8301] = { zoneID = 17, artID = { 18 }, x = 0.472, y = 0.138, overlay = { "0.47-0.14" }, displayID = 10983 }; --Clack the Reaver
	[8302] = { zoneID = 17, artID = { 18 }, x = 0.512, y = 0.272, overlay = { "0.51-0.25","0.52-0.27","0.52-0.29","0.53-0.26" }, displayID = 2174 }; --Deatheye
	[8303] = { zoneID = 17, artID = { 18 }, x = 0.544, y = 0.39400002, overlay = { "0.55-0.38","0.55-0.40","0.55-0.39","0.55-0.4" }, displayID = 8870 }; --Grunter
	[8304] = { zoneID = 17, artID = { 18 }, x = 0.366, y = 0.282, overlay = { "0.37-0.29" }, displayID = 7844 }; --Dreadscorn
	[10356] = { zoneID = 18, artID = { 19 }, x = 0.45996732, y = 0.48474097, overlay = { "0.46-0.49","0.46-0.50" }, displayID = 7892 }; --Bayne
	[10357] = { zoneID = 18, artID = { 19 }, x = 0.5370048, y = 0.57760906, overlay = { "0.52-0.56","0.53-0.56","0.53-0.58","0.54-0.56" }, displayID = 9750 }; --Ressan the Needler
	[10358] = { zoneID = 18, artID = { 19 }, x = 0.77, y = 0.598, displayID = 5430 }; --Fellicent's Shade
	[10359] = { zoneID = 18, artID = { 19 }, x = 0.84400004, y = 0.492, displayID = 418 }; --Sri'skulk
	[1531] = { zoneID = 18, artID = { 19 }, x = 0.45, y = 0.376, overlay = { "0.48-0.34","0.49-0.35","0.49-0.32","0.53-0.45","0.53-0.46","0.53-0.48" }, displayID = 985 }; --Lost Soul
	[1533] = { zoneID = 18, artID = { 19 }, x = 0.438, y = 0.314, overlay = { "0.43-0.32","0.43-0.33","0.45-0.31","0.45-0.35","0.45-0.36","0.46-0.30","0.46-0.31","0.47-0.35","0.48-0.33" }, displayID = 9534 }; --Tormented Spirit
	[1910] = { zoneID = 18, artID = { 19 }, x = 0.35908163, y = 0.4281255, overlay = { "0.35-0.43" }, displayID = 2597 }; --Muad
	[1911] = { zoneID = 18, artID = { 19 }, x = 0.72400004, y = 0.258, displayID = 1994 }; --Deeb
	[1936] = { zoneID = 18, artID = { 19 }, x = 0.3410316, y = 0.5207522, overlay = { "0.37-0.49","0.38-0.49","0.38-0.51" }, displayID = 3535 }; --Farmer Solliden
	[50763] = { zoneID = 18, artID = { 19 }, x = 0.38, y = 0.52, overlay = { "0.38-0.52" }, displayID = 67596 }; --Shadowstalker
	[50803] = { zoneID = 18, artID = { 19 }, x = 0.32599998, y = 0.46400002, overlay = { "0.31-0.46","0.32-0.47","0.32-0.46" }, displayID = 37992 }; --Bonechewer
	[50908] = { zoneID = 18, artID = { 19 }, x = 0.428, y = 0.284, overlay = { "0.42-0.28" }, displayID = 46667 }; --Nighthowl
	[50930] = { zoneID = 18, artID = { 19 }, x = 0.47599998, y = 0.70199996, overlay = { "0.46-0.69","0.47-0.70" }, displayID = 70192 }; --Hibernus the Sleeper
	[51044] = { zoneID = 18, artID = { 19 }, x = 0.578, y = 0.33, overlay = { "0.57-0.33" }, displayID = 46668 }; --Plague
	[12431] = { zoneID = 21, artID = { 22 }, x = 0.5633452, y = 0.2375347, overlay = { "0.56-0.25","0.56-0.24","0.57-0.16","0.57-0.15","0.57-0.17","0.58-0.15","0.58-0.16","0.6-0.09","0.60-0.09" }, displayID = 11413 }; --Gorefang
	[12433] = { zoneID = 21, artID = { 22 }, x = 0.346, y = 0.156, overlay = { "0.34-0.17","0.35-0.15","0.35-0.14","0.35-0.16","0.35-0.17","0.35-0.18","0.36-0.15","0.36-0.14","0.36-0.16","0.36-0.17","0.37-0.14","0.37-0.17","0.37-0.16","0.38-0.14","0.38-0.16" }, displayID = 22185 }; --Krethis the Shadowspinner
	[46981] = { zoneID = 21, artID = { 22 }, x = 0.532, y = 0.248, overlay = { "0.51-0.26","0.51-0.27","0.52-0.25","0.52-0.26","0.52-0.27","0.53-0.28","0.53-0.24" }, displayID = 915 }; --Nightlash
	[46992] = { zoneID = 21, artID = { 22 }, x = 0.436, y = 0.508, overlay = { "0.43-0.50" }, displayID = 35373 }; --Berard the Moon-Crazed
	[47003] = { zoneID = 21, artID = { 22 }, x = 0.488, y = 0.254, overlay = { "0.48-0.24","0.48-0.25" }, displayID = 35381 }; --Bolgaff
	[47008] = { zoneID = 21, artID = { 22 }, x = 0.59400004, y = 0.338, overlay = { "0.59-0.33" }, displayID = 10834 }; --Fenwick Thatros
	[47009] = { zoneID = 21, artID = { 22 }, x = 0.626, y = 0.66199994, overlay = { "0.57-0.64","0.57-0.62","0.58-0.63","0.58-0.62","0.58-0.66","0.59-0.62","0.59-0.65","0.59-0.66","0.59-0.61","0.59-0.63","0.60-0.63","0.61-0.64","0.61-0.65","0.61-0.66","0.61-0.63","0.61-0.67","0.62-0.66" }, displayID = 35383 }; --Aquarius the Unbound
	[47012] = { zoneID = 21, artID = { 22 }, x = 0.47, y = 0.694, overlay = { "0.46-0.69","0.47-0.69" }, displayID = 26799 }; --Effritus
	[47015] = { zoneID = 21, artID = { 22 }, x = 0.566, y = 0.32, overlay = { "0.45-0.3","0.46-0.24","0.46-0.27","0.46-0.23","0.47-0.24","0.48-0.21","0.48-0.23","0.48-0.34","0.49-0.21","0.49-0.35","0.50-0.2","0.50-0.19","0.52-0.19","0.53-0.20","0.53-0.19","0.54-0.42","0.54-0.47","0.54-0.54","0.54-0.20","0.54-0.64","0.54-0.48","0.54-0.51","0.54-0.43","0.55-0.23","0.55-0.38","0.55-0.45","0.55-0.64","0.55-0.73","0.55-0.37","0.55-0.44","0.55-0.71","0.55-0.75","0.55-0.31","0.55-0.32","0.55-0.61","0.55-0.33","0.55-0.41","0.56-0.76","0.56-0.26","0.56-0.28","0.56-0.34","0.56-0.78","0.56-0.32" }, displayID = 563 }; --Lost Son of Arugal
	[47023] = { zoneID = 21, artID = { 22 }, x = 0.50200003, y = 0.6, overlay = { "0.50-0.6" }, displayID = 4430 }; --Thule Ravenclaw
	[50330] = { zoneID = 21, artID = { 22 }, x = 0.616, y = 0.064, overlay = { "0.60-0.06","0.60-0.07","0.61-0.06" }, displayID = 34130 }; --Kree
	[50814] = { zoneID = 21, artID = { 22 }, x = 0.492, y = 0.682, overlay = { "0.49-0.68" }, displayID = 23481 }; --Corpsefeeder
	[50949] = { zoneID = 21, artID = { 22 }, x = 0.64, y = 0.466, overlay = { "0.64-0.46" }, displayID = 4714 }; --Finn's Gambit
	[51026] = { zoneID = 21, artID = { 22 }, x = 0.5, y = 0.294, overlay = { "0.49-0.29","0.5-0.29" }, displayID = 46569 }; --Gnath
	[51037] = { zoneID = 21, artID = { 22 }, x = 0.602, y = 0.404, overlay = { "0.57-0.42","0.57-0.41","0.58-0.41","0.59-0.41","0.59-0.42","0.6-0.40","0.6-0.41","0.60-0.40" }, displayID = 33998 }; --Lost Gilnean Wardog
	[111122] = { zoneID = 22, artID = { 23 }, x = 0.69, y = 0.458, overlay = { "0.69-0.45" }, displayID = 40728 }; --Large Vile Slime
	[1837] = { zoneID = 22, artID = { 23 }, x = 0.6922462, y = 0.49556875, displayID = 10355 }; --Scarlet Judge
	[1838] = { zoneID = 22, artID = { 23 }, x = 0.45, y = 0.52, displayID = 10343 }; --Scarlet Interrogator
	[1839] = { zoneID = 22, artID = { 23 }, x = 0.41, y = 0.52, overlay = { "0.41-0.53","0.42-0.52" }, displayID = 10342 }; --Scarlet High Clerist
	[1841] = { zoneID = 22, artID = { 23 }, x = 0.508, y = 0.404, displayID = 10344 }; --Scarlet Executioner
	[1847] = { zoneID = 22, artID = { 23 }, x = 0.54, y = 0.804, displayID = 519 }; --Foulmane
	[1848] = { zoneID = 22, artID = { 23 }, x = 0.65372765, y = 0.47575063, displayID = 10356 }; --Lord Maldazzar
	[1849] = { zoneID = 22, artID = { 23 }, x = 0.638, y = 0.564, overlay = { "0.64-0.56" }, displayID = 4629 }; --Dreadwhisper
	[1850] = { zoneID = 22, artID = { 23 }, x = 0.694, y = 0.73, displayID = 10612 }; --Putridius
	[1851] = { zoneID = 22, artID = { 23 }, x = 0.63, y = 0.828, overlay = { "0.63-0.83","0.64-0.83" }, displayID = 9013 }; --The Husk
	[1885] = { zoneID = 22, artID = { 23 }, x = 0.538885, y = 0.44086677, displayID = 10346 }; --Scarlet Smith
	[50345] = { zoneID = 22, artID = { 23 }, x = 0.32599998, y = 0.72199994, overlay = { "0.31-0.71","0.31-0.72","0.32-0.73","0.32-0.72" }, displayID = 21133 }; --Alit
	[50778] = { zoneID = 22, artID = { 23 }, x = 0.522, y = 0.684, overlay = { "0.51-0.70","0.51-0.69","0.52-0.68" }, displayID = 42742 }; --Ironweb
	[50809] = { zoneID = 22, artID = { 23 }, x = 0.35799998, y = 0.52599996, overlay = { "0.34-0.52","0.34-0.53","0.35-0.53","0.35-0.52" }, displayID = 46740 }; --Heress
	[50906] = { zoneID = 22, artID = { 23 }, x = 0.52599996, y = 0.276, overlay = { "0.52-0.27","0.52-0.26","0.52-0.28" }, displayID = 37857 }; --Mutilax
	[50922] = { zoneID = 22, artID = { 23 }, x = 0.582, y = 0.614, overlay = { "0.56-0.62","0.56-0.61","0.56-0.63","0.57-0.61","0.57-0.63","0.57-0.60","0.58-0.61" }, displayID = 35394 }; --Warg
	[50931] = { zoneID = 22, artID = { 23 }, x = 0.666, y = 0.546, overlay = { "0.65-0.56","0.66-0.55","0.66-0.54" }, displayID = 70191 }; --Mange
	[50937] = { zoneID = 22, artID = { 23 }, x = 0.436, y = 0.36, overlay = { "0.43-0.34","0.43-0.35","0.43-0.36" }, displayID = 6122 }; --Hamhide
	[51029] = { zoneID = 22, artID = { 23 }, x = 0.62, y = 0.736, overlay = { "0.61-0.72","0.62-0.73" }, displayID = 23998 }; --Parasitus
	[51031] = { zoneID = 22, artID = { 23 }, x = 0.626, y = 0.472, overlay = { "0.62-0.47" }, displayID = 46741 }; --Tracker
	[51058] = { zoneID = 22, artID = { 23 }, x = 0.626, y = 0.354, overlay = { "0.62-0.35" }, displayID = 34900 }; --Aphis
	[100000] = { zoneID = 23, artID = { 24 }, x = 0.756, y = 0.49, overlay = { "0.75-0.49" }, friendly = { "A","H" }, displayID = 31910 }; --Johnny Awesomer
	[10817] = { zoneID = 23, artID = { 24 }, x = 0.35965878, y = 0.6206186, displayID = 10374 }; --Duggan Wildhammer
	[10818] = { zoneID = 23, artID = { 24 }, x = 0.65400004, y = 0.244, displayID = 6380 }; --Death Knight Soulbearer
	[10819] = { zoneID = 23, artID = { 24 }, x = 0.3567382, y = 0.21415633, displayID = 6380 }; --Baron Bloodbane
	[10820] = { zoneID = 23, artID = { 24 }, x = 0.278216, y = 0.12735772, overlay = { "0.26-0.11","0.27-0.13","0.27-0.11" }, displayID = 6380 }; --Duke Ragereaver
	[10821] = { zoneID = 23, artID = { 24 }, x = 0.79, y = 0.39, displayID = 10709 }; --Hed'mush the Rotting
	[10823] = { zoneID = 23, artID = { 24 }, x = 0.64, y = 0.124, displayID = 10443 }; --Zul'Brin Warpbranch
	[10824] = { zoneID = 23, artID = { 24 }, x = 0.4733991, y = 0.21338946, displayID = 19824 }; --Death-Hunter Hawkspear
	[10825] = { zoneID = 23, artID = { 24 }, x = 0.258, y = 0.68, displayID = 7856 }; --Gish the Unmoving
	[10826] = { zoneID = 23, artID = { 24 }, x = 0.36930305, y = 0.44113845, overlay = { "0.33-0.47","0.33-0.48","0.33-0.49","0.33-0.46","0.34-0.46","0.34-0.49","0.34-0.44","0.34-0.45","0.35-0.44","0.35-0.47","0.35-0.48","0.36-0.43","0.36-0.48","0.36-0.47","0.37-0.47","0.37-0.43","0.37-0.45","0.37-0.46" }, displayID = 7847 }; --Lord Darkscythe
	[10827] = { zoneID = 23, artID = { 24 }, x = 0.17135757, y = 0.7841854, overlay = { "0.18-0.77","0.18-0.78","0.19-0.77" }, displayID = 10432 }; --Deathspeaker Selendre
	[10828] = { zoneID = 23, artID = { 24 }, x = 0.774, y = 0.72199994, overlay = { "0.77-0.71" }, displayID = 37769 }; --Lynnia Abbendis
	[16184] = { zoneID = 23, artID = { 24 }, x = 0.042, y = 0.36, displayID = 14698 }; --Nerubian Overseer
	[1843] = { zoneID = 23, artID = { 24 }, x = 0.552, y = 0.686, displayID = 10340 }; --Foreman Jerris
	[1844] = { zoneID = 23, artID = { 24 }, x = 0.538, y = 0.684, overlay = { "0.54-0.68" }, displayID = 10354 }; --Foreman Marcrid
	[50775] = { zoneID = 23, artID = { 24 }, x = 0.13, y = 0.714, overlay = { "0.11-0.70","0.12-0.71","0.12-0.72","0.13-0.71" }, displayID = 46518 }; --Likk the Hunter
	[50779] = { zoneID = 23, artID = { 24 }, x = 0.39400002, y = 0.556, overlay = { "0.39-0.55" }, displayID = 18029 }; --Sporeggon
	[50813] = { zoneID = 23, artID = { 24 }, x = 0.496, y = 0.432, overlay = { "0.49-0.43" }, displayID = 46516 }; --Fene-mal
	[50856] = { zoneID = 23, artID = { 24 }, x = 0.396, y = 0.84599996, overlay = { "0.37-0.84","0.39-0.84" }, displayID = 31352 }; --Snark
	[50915] = { zoneID = 23, artID = { 24 }, x = 0.576, y = 0.79800004, overlay = { "0.57-0.8","0.57-0.79" }, displayID = 46520 }; --Snort
	[50947] = { zoneID = 23, artID = { 24 }, x = 0.116000004, y = 0.28, overlay = { "0.11-0.28" }, displayID = 46532 }; --Varah
	[51027] = { zoneID = 23, artID = { 24 }, x = 0.746, y = 0.588, overlay = { "0.74-0.58" }, displayID = 46534 }; --Spirocula
	[51042] = { zoneID = 23, artID = { 24 }, x = 0.71800005, y = 0.458, overlay = { "0.71-0.45" }, displayID = 46517 }; --Bleakheart
	[51053] = { zoneID = 23, artID = { 24 }, x = 0.23799999, y = 0.786, overlay = { "0.23-0.78" }, displayID = 37580 }; --Quirix
	[14221] = { zoneID = 25, artID = { 26 }, x = 0.554, y = 0.23799999, overlay = { "0.56-0.25","0.56-0.23","0.57-0.25","0.57-0.24","0.58-0.24" }, displayID = 2582 }; --Gravis Slipknot
	[14222] = { zoneID = 25, artID = { 26 }, x = 0.442, y = 0.54, displayID = 1933 }; --Araga
	[14223] = { zoneID = 25, artID = { 26 }, x = 0.566, y = 0.616, overlay = { "0.57-0.61","0.57-0.6","0.58-0.59","0.58-0.60","0.59-0.58","0.60-0.57","0.60-0.55","0.60-0.56","0.60-0.47","0.60-0.50","0.60-0.52","0.60-0.54","0.61-0.47","0.61-0.45","0.61-0.41","0.61-0.43","0.61-0.44","0.61-0.42","0.61-0.48","0.62-0.40","0.62-0.39","0.63-0.39","0.63-0.40","0.64-0.38","0.64-0.37","0.65-0.36","0.67-0.34","0.68-0.30","0.68-0.32" }, displayID = 5026 }; --Cranky Benj
	[14275] = { zoneID = 25, artID = { 26 }, x = 0.632, y = 0.85800004, friendly = { "A" }, displayID = 3763 }; --Tamra Stormpike
	[14276] = { zoneID = 25, artID = { 26 }, x = 0.322, y = 0.794, displayID = 540 }; --Scargil
	[14277] = { zoneID = 25, artID = { 26 }, x = 0.544, y = 0.764, displayID = 4978 }; --Lady Zephris
	[14278] = { zoneID = 25, artID = { 26 }, x = 0.57, y = 0.746, overlay = { "0.57-0.73","0.57-0.76","0.58-0.72","0.58-0.75","0.59-0.75","0.59-0.73","0.59-0.74" }, displayID = 491 }; --Ro'Bark
	[14279] = { zoneID = 25, artID = { 26 }, x = 0.43400002, y = 0.752, overlay = { "0.43-0.74" }, displayID = 1091 }; --Creepthess
	[14280] = { zoneID = 25, artID = { 26 }, x = 0.634, y = 0.52599996, displayID = 706 }; --Big Samras
	[14281] = { zoneID = 25, artID = { 26 }, x = 0.498, y = 0.50200003, displayID = 3616 }; --Jimmy the Bleeder
	[2258] = { zoneID = 25, artID = { 26 }, x = 0.602, y = 0.288, displayID = 36325 }; --Maggarrak
	[2452] = { zoneID = 25, artID = { 26 }, x = 0.43400002, y = 0.378, overlay = { "0.43-0.38" }, displayID = 1078 }; --Skhowl
	[2453] = { zoneID = 25, artID = { 26 }, x = 0.49400002, y = 0.184, displayID = 11566 }; --Lo'Grosh
	[47010] = { zoneID = 25, artID = { 26 }, x = 0.316, y = 0.4, overlay = { "0.31-0.39","0.31-0.4" }, displayID = 9995 }; --Indigos
	[50335] = { zoneID = 25, artID = { 26 }, x = 0.474, y = 0.682, overlay = { "0.46-0.66","0.47-0.66","0.47-0.68" }, displayID = 26255 }; --Alitus
	[50765] = { zoneID = 25, artID = { 26 }, x = 0.37, y = 0.682, overlay = { "0.37-0.68" }, displayID = 27683 }; --Miasmiss
	[50818] = { zoneID = 25, artID = { 26 }, x = 0.33, y = 0.55, overlay = { "0.33-0.55" }, displayID = 26618 }; --The Dark Prowler
	[50858] = { zoneID = 25, artID = { 26 }, x = 0.286, y = 0.83800006, overlay = { "0.27-0.83","0.28-0.83" }, displayID = 46551 }; --Dustwing
	[50929] = { zoneID = 25, artID = { 26 }, x = 0.35, y = 0.78400004, overlay = { "0.34-0.78","0.35-0.78" }, displayID = 46552 }; --Little Bjorn
	[50955] = { zoneID = 25, artID = { 26 }, x = 0.468, y = 0.76, overlay = { "0.46-0.76" }, displayID = 46558 }; --Carcinak
	[50967] = { zoneID = 25, artID = { 26 }, x = 0.518, y = 0.872, overlay = { "0.51-0.87" }, displayID = 32807 }; --Craw the Ravager
	[51022] = { zoneID = 25, artID = { 26 }, x = 0.568, y = 0.548, overlay = { "0.56-0.54" }, displayID = 37540 }; --Chordix
	[51057] = { zoneID = 25, artID = { 26 }, x = 0.45599997, y = 0.538, overlay = { "0.45-0.52","0.45-0.53" }, displayID = 34898 }; --Weevil
	[51076] = { zoneID = 25, artID = { 26 }, x = 0.688, y = 0.56, overlay = { "0.68-0.56" }, displayID = 40191 }; --Lopex
	[107617] = { zoneID = 26, artID = { 27 }, x = 0.768, y = 0.498, overlay = { "0.42-0.61","0.42-0.59","0.42-0.62","0.43-0.61","0.43-0.63","0.43-0.6","0.44-0.55","0.44-0.59","0.44-0.64","0.44-0.53","0.47-0.56","0.48-0.59","0.49-0.57","0.51-0.55","0.51-0.53","0.51-0.59","0.52-0.51","0.54-0.45","0.54-0.46","0.56-0.46","0.58-0.46","0.58-0.53","0.59-0.48","0.61-0.50","0.62-0.54","0.62-0.47","0.62-0.45","0.63-0.54","0.63-0.42","0.64-0.54","0.64-0.41","0.64-0.42","0.64-0.57","0.65-0.58","0.67-0.47","0.67-0.57","0.68-0.48","0.69-0.50","0.70-0.51","0.71-0.50","0.71-0.51","0.72-0.50","0.72-0.49","0.72-0.5","0.74-0.54","0.75-0.51","0.76-0.49" }, displayID = 70190 }; --Ol' Muddle
	[8210] = { zoneID = 26, artID = { 27 }, x = 0.66, y = 0.53, displayID = 5927 }; --Razortalon
	[8211] = { zoneID = 26, artID = { 27 }, x = 0.132, y = 0.538, displayID = 11414 }; --Old Cliff Jumper
	[8212] = { zoneID = 26, artID = { 27 }, x = 0.574, y = 0.43, overlay = { "0.57-0.42" }, displayID = 1306 }; --The Reak
	[8213] = { zoneID = 26, artID = { 27 }, x = 0.794, y = 0.566, overlay = { "0.80-0.56","0.80-0.58","0.80-0.57","0.81-0.55","0.81-0.57" }, displayID = 7840 }; --Ironback
	[8214] = { zoneID = 26, artID = { 27 }, x = 0.344, y = 0.55, friendly = { "A" }, displayID = 4731 }; --Jalinde Summerdrake
	[8215] = { zoneID = 26, artID = { 27 }, x = 0.714, y = 0.61, overlay = { "0.71-0.60","0.71-0.62","0.72-0.59","0.72-0.58","0.72-0.57","0.73-0.57","0.73-0.56","0.73-0.55","0.74-0.52","0.74-0.54","0.75-0.55","0.76-0.54","0.76-0.52","0.76-0.51","0.76-0.55","0.77-0.50","0.77-0.51","0.78-0.50" }, displayID = 12816 }; --Grimungous
	[8216] = { zoneID = 26, artID = { 27 }, x = 0.474, y = 0.66400003, overlay = { "0.47-0.67","0.48-0.67","0.48-0.68" }, displayID = 6512 }; --Retherokk the Berserker
	[8217] = { zoneID = 26, artID = { 27 }, x = 0.648, y = 0.814, displayID = 6512 }; --Mith'rethis the Enchanter
	[8218] = { zoneID = 26, artID = { 27 }, x = 0.39400002, y = 0.66199994, displayID = 6479 }; --Witherheart the Stalker
	[8219] = { zoneID = 26, artID = { 27 }, x = 0.246, y = 0.65400004, displayID = 6479 }; --Zul'arek Hatefowler
	[1130] = { zoneID = 27, artID = { 28 }, x = 0.66199994, y = 0.598, overlay = { "0.66-0.58","0.67-0.58","0.69-0.55","0.69-0.56","0.69-0.58" }, displayID = 913 }; --Bjarn
	[1137] = { zoneID = 29, artID = { 31 }, x = 0.318, y = 0.44, overlay = { "0.32-0.49","0.33-0.5","0.33-0.52","0.34-0.48","0.34-0.52","0.34-0.45","0.35-0.49","0.35-0.53","0.38-0.51","0.39-0.46" }, displayID = 931 }; --Edan the Howler
	[1119] = { zoneID = 31, artID = { 30 }, x = 0.524, y = 0.322, overlay = { "0.55-0.36","0.56-0.38","0.56-0.39","0.56-0.37","0.57-0.38","0.57-0.39" }, displayID = 830 }; --Hammerspine
	[50846] = { zoneID = 32, artID = { 33 }, x = 0.59, y = 0.254, overlay = { "0.57-0.25","0.57-0.23","0.57-0.24","0.58-0.22","0.58-0.23","0.59-0.25" }, displayID = 5240 }; --Slavermaw
	[50876] = { zoneID = 32, artID = { 33 }, x = 0.71599996, y = 0.192, overlay = { "0.70-0.18","0.71-0.17","0.71-0.16","0.71-0.19" }, displayID = 1746 }; --Avis
	[50946] = { zoneID = 32, artID = { 33 }, x = 0.222, y = 0.77800006, overlay = { "0.21-0.78","0.22-0.77" }, displayID = 2450 }; --Hogzilla
	[50948] = { zoneID = 32, artID = { 33 }, x = 0.67, y = 0.45200002, overlay = { "0.64-0.46","0.65-0.45","0.65-0.46","0.65-0.47","0.66-0.45","0.66-0.46","0.66-0.47","0.66-0.44","0.66-0.43","0.67-0.45" }, displayID = 46566 }; --Crystalback
	[51002] = { zoneID = 32, artID = { 33 }, x = 0.184, y = 0.38799998, overlay = { "0.17-0.38","0.18-0.38" }, displayID = 15336 }; --Scorpoxx
	[51010] = { zoneID = 32, artID = { 33 }, x = 0.36200002, y = 0.53, overlay = { "0.35-0.52","0.36-0.53" }, displayID = 46248 }; --Snips
	[51048] = { zoneID = 32, artID = { 33 }, x = 0.428, y = 0.472, overlay = { "0.39-0.50","0.39-0.53","0.40-0.50","0.40-0.49","0.41-0.49","0.41-0.50","0.42-0.49","0.42-0.47" }, displayID = 35356 }; --Rexxus
	[8277] = { zoneID = 32, artID = { 33 }, x = 0.292, y = 0.67800003, overlay = { "0.30-0.68","0.30-0.70","0.30-0.71","0.30-0.69","0.30-0.72","0.31-0.69","0.31-0.72","0.31-0.73" }, displayID = 4458 }; --Rekk'tilac
	[8278] = { zoneID = 32, artID = { 33 }, x = 0.48, y = 0.384, overlay = { "0.48-0.37","0.49-0.37","0.49-0.39","0.49-0.38" }, displayID = 5781 }; --Smoldar
	[8279] = { zoneID = 32, artID = { 33 }, x = 0.58, y = 0.564, overlay = { "0.62-0.61","0.62-0.59","0.63-0.60","0.63-0.63" }, displayID = 10800 }; --Faulty War Golem
	[8280] = { zoneID = 32, artID = { 33 }, x = 0.55799997, y = 0.45200002, overlay = { "0.55-0.46","0.56-0.46","0.57-0.45","0.57-0.47","0.57-0.44","0.57-0.43","0.58-0.44" }, displayID = 2346 }; --Shleipnarr
	[8281] = { zoneID = 32, artID = { 33 }, x = 0.402, y = 0.58599997, overlay = { "0.40-0.57" }, displayID = 1204 }; --Scald
	[8282] = { zoneID = 32, artID = { 33 }, x = 0.294, y = 0.254, overlay = { "0.29-0.26","0.31-0.26" }, displayID = 7835 }; --Highlord Mastrogonde
	[8283] = { zoneID = 32, artID = { 33 }, x = 0.374, y = 0.442, overlay = { "0.38-0.44" }, displayID = 7819 }; --Slave Master Blackheart
	[50839] = { zoneID = {
				[33] = { x = 0.62, y = 0.44799998, overlay = { "0.35-0.60","0.36-0.49","0.37-0.66","0.38-0.44","0.38-0.42","0.40-0.40","0.40-0.73","0.41-0.73","0.42-0.74","0.43-0.76","0.43-0.36","0.44-0.36","0.44-0.76","0.44-0.37","0.44-0.75","0.45-0.36","0.45-0.76","0.46-0.35","0.46-0.78","0.46-0.77","0.47-0.36","0.48-0.78","0.48-0.35","0.5-0.35","0.50-0.78","0.51-0.35","0.54-0.35","0.54-0.76","0.55-0.35","0.56-0.76","0.57-0.36","0.57-0.38","0.58-0.38","0.59-0.41","0.61-0.43","0.62-0.44" } };
				[36] = { x = 0.24, y = 0.304, overlay = { "0.17-0.31","0.18-0.25","0.18-0.33","0.19-0.24","0.19-0.33","0.20-0.33","0.20-0.24","0.21-0.24","0.22-0.33","0.22-0.25","0.23-0.25","0.24-0.30" } };
			  }, displayID = 29539 }; --null
	[51066] = { zoneID = 35, artID = { 36 }, x = 0.34, y = 0.2, overlay = { "0.34-0.20" }, displayID = 33863 }; --Crystalfang
	[8924] = { zoneID = 35, artID = { 36 }, x = 0.40132546, y = 0.6061824, displayID = 8390 }; --The Behemoth
	[10077] = { zoneID = 36, artID = { 37 }, x = 0.628, y = 0.314, overlay = { "0.63-0.32","0.67-0.54","0.68-0.55","0.7-0.56","0.70-0.56","0.70-0.31","0.70-0.29","0.72-0.59","0.73-0.51" }, displayID = 9562 }; --Deathmaw
	[10078] = { zoneID = 36, artID = { 37 }, x = 0.56200004, y = 0.33, overlay = { "0.56-0.32","0.57-0.31","0.57-0.32","0.57-0.34","0.57-0.33","0.58-0.33","0.6-0.30" }, displayID = 1018 }; --Terrorspark
	[10119] = { zoneID = 36, artID = { 37 }, x = 0.188, y = 0.43400002, overlay = { "0.19-0.41","0.19-0.42","0.20-0.41","0.21-0.41","0.21-0.42","0.22-0.41" }, displayID = 12232 }; --Volchan
	[50357] = { zoneID = 36, artID = { 37 }, x = 0.098000005, y = 0.544, overlay = { "0.08-0.54","0.09-0.54","0.09-0.52","0.09-0.53","0.09-0.55" }, displayID = 45201 }; --Sunwing
	[50361] = { zoneID = 36, artID = { 37 }, x = 0.506, y = 0.606, overlay = { "0.50-0.60","0.50-0.59" }, displayID = 20596 }; --Ornat
	[50725] = { zoneID = 36, artID = { 37 }, x = 0.72800004, y = 0.22600001, overlay = { "0.71-0.23","0.72-0.22" }, displayID = 20309 }; --Azelisk
	[50730] = { zoneID = 36, artID = { 37 }, x = 0.058000002, y = 0.382, overlay = { "0.05-0.38" }, displayID = 20297 }; --Venomspine
	[50792] = { zoneID = 36, artID = { 37 }, x = 0.354, y = 0.268, overlay = { "0.35-0.26" }, displayID = 46278 }; --Chiaa
	[50807] = { zoneID = 36, artID = { 37 }, x = 0.65, y = 0.538, overlay = { "0.63-0.54","0.64-0.52","0.64-0.54","0.64-0.53","0.65-0.53" }, displayID = 46277 }; --Catal
	[50810] = { zoneID = 36, artID = { 37 }, x = 0.756, y = 0.53400004, overlay = { "0.73-0.53","0.74-0.52","0.74-0.51","0.75-0.53","0.75-0.51","0.75-0.52" }, displayID = 20347 }; --Favored of Isiset
	[50842] = { zoneID = 36, artID = { 37 }, x = 0.292, y = 0.314, overlay = { "0.28-0.33","0.28-0.32","0.29-0.33","0.29-0.34","0.29-0.31" }, displayID = 12168 }; --Magmagan
	[50855] = { zoneID = 36, artID = { 37 }, x = 0.47, y = 0.24200001, overlay = { "0.47-0.24" }, displayID = 79025 }; --Jaxx the Rabid
	[8976] = { zoneID = 36, artID = { 37 }, x = 0.27709383, y = 0.592155, overlay = { "0.26-0.58","0.28-0.6" }, displayID = 6369 }; --Hematos
	[8978] = { zoneID = 36, artID = { 37 }, x = 0.438, y = 0.398, displayID = 11511 }; --Thauris Balgarr
	[8979] = { zoneID = 36, artID = { 37 }, x = 0.33400002, y = 0.368, overlay = { "0.33-0.37","0.34-0.36" }, friendly = { "H" }, displayID = 11510 }; --Gruklash
	[8981] = { zoneID = 36, artID = { 37 }, x = 0.51, y = 0.36400002, overlay = { "0.52-0.38","0.53-0.36","0.55-0.43" }, displayID = 10802 }; --Malfunctioning Reaver
	[9602] = { zoneID = 36, artID = { 37 }, x = 0.684, y = 0.404, displayID = 11564 }; --Hahk'Zor
	[9604] = { zoneID = 36, artID = { 37 }, x = 0.634, y = 0.474, overlay = { "0.64-0.46" }, displayID = 11562 }; --Gorgon'och
	[472] = { zoneID = 37, artID = { 41 }, x = 0.67941034, y = 0.3952331, overlay = { "0.66-0.40","0.66-0.4","0.66-0.41","0.67-0.47","0.68-0.44","0.69-0.38","0.70-0.4" }, displayID = 175 }; --Fedfennel
	[50752] = { zoneID = 37, artID = { 41 }, x = 0.676, y = 0.632, overlay = { "0.65-0.64","0.65-0.65","0.66-0.63","0.67-0.63" }, displayID = 2537 }; --Tarantis
	[50916] = { zoneID = 37, artID = { 41 }, x = 0.52599996, y = 0.632, overlay = { "0.51-0.62","0.51-0.63","0.52-0.62","0.52-0.63" }, displayID = 46543 }; --Lamepaw the Whimperer
	[50926] = { zoneID = 37, artID = { 41 }, x = 0.286, y = 0.666, overlay = { "0.27-0.67","0.27-0.69","0.28-0.66" }, displayID = 70199 }; --Grizzled Ben
	[50942] = { zoneID = 37, artID = { 41 }, x = 0.706, y = 0.79800004, overlay = { "0.67-0.82","0.69-0.77","0.69-0.78","0.69-0.79","0.70-0.79" }, displayID = 1208 }; --Snoot the Rooter
	[51014] = { zoneID = {
				[37] = { x = 0.74, y = 0.84800005, overlay = { "0.50-0.87","0.51-0.88","0.51-0.87","0.53-0.87","0.53-0.86","0.55-0.86","0.55-0.85","0.56-0.85","0.57-0.85","0.58-0.83","0.59-0.83","0.60-0.82","0.62-0.82","0.63-0.83","0.66-0.84","0.66-0.85","0.67-0.84","0.68-0.85","0.68-0.84","0.70-0.85","0.71-0.85","0.72-0.84","0.72-0.85","0.73-0.85","0.74-0.84" } };
				[47] = { x = 0.61, y = 0.126, overlay = { "0.47-0.12","0.49-0.10","0.49-0.11","0.61-0.12" } };
			  }, displayID = 7837 }; --null
	[51077] = { zoneID = 37, artID = { 41 }, x = 0.83800006, y = 0.85, overlay = { "0.81-0.85","0.82-0.84","0.83-0.82","0.83-0.84","0.83-0.85" }, displayID = 30254 }; --Bushtail
	[61] = { zoneID = 37, artID = { 41 }, x = 0.50634074, y = 0.830827, overlay = { "0.49-0.82","0.5-0.81","0.50-0.84","0.50-0.81" }, displayID = 3341 }; --Thuros Lightfingers
	[79] = { zoneID = 37, artID = { 41 }, x = 0.372, y = 0.834, overlay = { "0.38-0.81","0.38-0.82","0.38-0.83" }, displayID = 774 }; --Narg the Taskmaster
	[99] = { zoneID = 37, artID = { 41 }, x = 0.308, y = 0.65, overlay = { "0.31-0.65" }, displayID = 3320 }; --Morgaine the Sly
	[471] = { zoneID = 40, artID = { 42 }, x = 0.39400002, y = 0.21200001, overlay = { "0.40-0.2","0.47-0.24","0.51-0.30","0.51-0.29","0.52-0.28","0.52-0.29","0.54-0.33" }, displayID = 2541 }; --Mother Fang
	[116034] = { zoneID = 47, artID = { 52 }, x = 0.496, y = 0.756, overlay = { "0.49-0.75","0.49-0.76" }, displayID = 74030 }; --The Cow King
	[118244] = { zoneID = 47, artID = { 52 }, x = 0.1669, y = 0.5444, overlay = { "0.16-0.54","0.23-0.29","0.16-0.60","0.24-0.39","0.23-0.76","0.30-0.41" }, displayID = 74736 }; --Lightning Paw
	[45739] = { zoneID = 47, artID = { 52 }, x = 0.90599996, y = 0.306, overlay = { "0.89-0.30","0.90-0.30" }, displayID = 34648 }; --The Unknown Soldier
	[45740] = { zoneID = 47, artID = { 52 }, x = 0.818, y = 0.592, overlay = { "0.79-0.69","0.79-0.70","0.79-0.67","0.80-0.67","0.80-0.69","0.80-0.62","0.80-0.65","0.80-0.68","0.81-0.59" }, displayID = 34649 }; --Watcher Eva
	[45771] = { zoneID = 47, artID = { 52 }, x = 0.65199995, y = 0.704, overlay = { "0.58-0.77","0.58-0.8","0.60-0.75","0.61-0.73","0.61-0.74","0.61-0.70","0.61-0.71","0.62-0.74","0.62-0.72","0.63-0.73","0.63-0.68","0.63-0.83","0.63-0.7","0.64-0.69","0.65-0.68","0.65-0.70" }, displayID = 34669 }; --Marus
	[45785] = { zoneID = 47, artID = { 52 }, x = 0.512, y = 0.748, overlay = { "0.46-0.74","0.47-0.70","0.47-0.72","0.47-0.76","0.48-0.72","0.48-0.71","0.48-0.74","0.48-0.70","0.48-0.73","0.49-0.70","0.49-0.71","0.49-0.74","0.49-0.75","0.49-0.72","0.5-0.72","0.5-0.74","0.5-0.76","0.50-0.74","0.50-0.75","0.50-0.7","0.50-0.73","0.50-0.71","0.51-0.74" }, displayID = 34671 }; --Carved One
	[45801] = { zoneID = 47, artID = { 52 }, x = 0.276, y = 0.336, overlay = { "0.27-0.31","0.27-0.32","0.27-0.33" }, displayID = 34682 }; --Eliza
	[45811] = { zoneID = 47, artID = { 52 }, x = 0.08, y = 0.366, overlay = { "0.07-0.32","0.07-0.33","0.07-0.35","0.07-0.34","0.07-0.36","0.08-0.31","0.08-0.36" }, displayID = 4277 }; --Marina DeSirrus
	[507] = { zoneID = 47, artID = { 52 }, x = 0.59, y = 0.3, overlay = { "0.61-0.4","0.61-0.40","0.61-0.41","0.62-0.41","0.62-0.43","0.63-0.41","0.63-0.45","0.63-0.48","0.64-0.51" }, displayID = 11179 }; --Fenros
	[521] = { zoneID = 47, artID = { 52 }, x = 0.588, y = 0.186, overlay = { "0.59-0.2","0.59-0.21","0.6-0.22","0.60-0.18","0.60-0.22","0.60-0.2","0.60-0.21","0.60-0.19","0.63-0.19","0.64-0.21","0.64-0.20","0.65-0.2","0.65-0.18","0.65-0.22","0.65-0.19","0.65-0.17","0.66-0.21","0.66-0.20","0.66-0.19","0.69-0.24","0.69-0.25","0.69-0.22","0.7-0.24","0.70-0.25","0.70-0.22","0.70-0.23","0.71-0.22","0.71-0.23" }, displayID = 11412 }; --Lupos
	[534] = { zoneID = 47, artID = { 52 }, x = 0.74, y = 0.786, displayID = 11181 }; --Nefaru
	[574] = { zoneID = 47, artID = { 52 }, x = 0.864, y = 0.48, overlay = { "0.86-0.49" }, displayID = 963 }; --Naraxis
	[1398] = { zoneID = 48, artID = { 53 }, x = 0.66800004, y = 0.69, overlay = { "0.68-0.66","0.68-0.68","0.69-0.59","0.69-0.66","0.69-0.6","0.69-0.67","0.7-0.62","0.70-0.61","0.70-0.62","0.70-0.63","0.70-0.64","0.70-0.67","0.70-0.65","0.70-0.66","0.70-0.68","0.71-0.60" }, displayID = 1194 }; --Boss Galgosh
	[1399] = { zoneID = 48, artID = { 53 }, x = 0.308, y = 0.75, overlay = { "0.31-0.75" }, displayID = 160 }; --Magosh
	[1425] = { zoneID = 48, artID = { 53 }, x = 0.244, y = 0.3, overlay = { "0.24-0.28","0.25-0.30","0.25-0.29","0.26-0.27","0.26-0.28","0.26-0.31" }, displayID = 774 }; --Kubb
	[14266] = { zoneID = 48, artID = { 53 }, x = 0.614, y = 0.734, overlay = { "0.61-0.74" }, displayID = 1103 }; --Shanda the Spinner
	[14267] = { zoneID = 48, artID = { 53 }, x = 0.66, y = 0.214, overlay = { "0.67-0.21","0.67-0.22","0.67-0.23","0.68-0.27","0.68-0.21","0.68-0.22","0.68-0.23","0.68-0.29","0.68-0.25","0.69-0.23","0.69-0.24","0.69-0.27","0.69-0.22","0.69-0.25","0.69-0.26","0.7-0.22","0.7-0.23","0.7-0.25","0.70-0.22","0.71-0.2","0.71-0.20","0.71-0.22","0.71-0.24","0.71-0.23","0.72-0.23","0.72-0.21","0.72-0.25","0.73-0.25" }, displayID = 3189 }; --Emogg the Crusher
	[14268] = { zoneID = 48, artID = { 53 }, x = 0.66199994, y = 0.71199995, overlay = { "0.66-0.73","0.67-0.76","0.68-0.75","0.69-0.73","0.70-0.73","0.70-0.74","0.70-0.75","0.71-0.72","0.72-0.71","0.72-0.72","0.73-0.71","0.73-0.72","0.74-0.65","0.74-0.68","0.74-0.7","0.74-0.66","0.74-0.67","0.74-0.73","0.75-0.71","0.75-0.73","0.75-0.63","0.76-0.73","0.76-0.62","0.77-0.74","0.77-0.73","0.77-0.64","0.78-0.67","0.78-0.70","0.78-0.73","0.78-0.76","0.78-0.64","0.78-0.68","0.78-0.71","0.78-0.74","0.78-0.72","0.79-0.63","0.79-0.67","0.79-0.66" }, displayID = 14313 }; --Lord Condar
	[2476] = { zoneID = 48, artID = { 53 }, x = 0.528, y = 0.578, overlay = { "0.53-0.55","0.53-0.56","0.53-0.54","0.54-0.53","0.54-0.56","0.54-0.58","0.54-0.59","0.54-0.57","0.55-0.54","0.55-0.53","0.55-0.55","0.56-0.53","0.56-0.51" }, displayID = 32813 }; --Gosh-Haldir
	[45369] = { zoneID = 48, artID = { 53 }, x = 0.408, y = 0.626, overlay = { "0.37-0.62","0.37-0.63","0.38-0.62","0.39-0.61","0.4-0.61","0.40-0.60","0.40-0.65","0.40-0.64","0.40-0.62" }, displayID = 3452 }; --Morick Darkbrew
	[45380] = { zoneID = 48, artID = { 53 }, x = 0.77599996, y = 0.41599998, overlay = { "0.66-0.4","0.67-0.42","0.68-0.37","0.68-0.36","0.68-0.38","0.69-0.42","0.7-0.37","0.70-0.35","0.70-0.36","0.71-0.42","0.72-0.37","0.72-0.36","0.72-0.42","0.73-0.35","0.73-0.36","0.73-0.43","0.73-0.44","0.73-0.42","0.74-0.34","0.74-0.44","0.74-0.43","0.75-0.42","0.76-0.42","0.76-0.43","0.76-0.38","0.76-0.35","0.77-0.36","0.77-0.39","0.77-0.41" }, displayID = 30239 }; --Ashtail
	[45384] = { zoneID = 48, artID = { 53 }, x = 0.256, y = 0.44799998, overlay = { "0.25-0.43","0.25-0.44" }, displayID = 10796 }; --Sagepaw
	[45398] = { zoneID = 48, artID = { 53 }, x = 0.35599998, y = 0.156, overlay = { "0.35-0.15" }, displayID = 27195 }; --Grizlak
	[45399] = { zoneID = 48, artID = { 53 }, x = 0.78, y = 0.77800006, overlay = { "0.71-0.76","0.71-0.77","0.72-0.78","0.73-0.78","0.73-0.77","0.74-0.76","0.75-0.77","0.75-0.78","0.76-0.79","0.76-0.80","0.76-0.81","0.76-0.82","0.77-0.83","0.77-0.8","0.77-0.81","0.77-0.78","0.77-0.82","0.78-0.77" }, displayID = 10664 }; --Optimo
	[45401] = { zoneID = 48, artID = { 53 }, x = 0.496, y = 0.57, overlay = { "0.41-0.44","0.42-0.46","0.42-0.41","0.42-0.48","0.42-0.43","0.42-0.45","0.43-0.43","0.43-0.47","0.43-0.41","0.43-0.40","0.43-0.48","0.44-0.39","0.44-0.40","0.44-0.49","0.44-0.51","0.44-0.52","0.44-0.38","0.44-0.48","0.45-0.53","0.45-0.47","0.45-0.54","0.45-0.37","0.45-0.38","0.45-0.51","0.45-0.50","0.46-0.53","0.46-0.54","0.47-0.51","0.47-0.55","0.47-0.54","0.47-0.56","0.48-0.56","0.49-0.56","0.49-0.57" }, displayID = 5286 }; --Whitefin
	[45402] = { zoneID = 48, artID = { 53 }, x = 0.59400004, y = 0.406, overlay = { "0.50-0.37","0.50-0.36","0.51-0.37","0.51-0.40","0.51-0.41","0.52-0.36","0.52-0.40","0.52-0.41","0.52-0.34","0.53-0.33","0.53-0.35","0.53-0.42","0.53-0.41","0.53-0.43","0.54-0.41","0.55-0.34","0.55-0.35","0.55-0.40","0.55-0.42","0.55-0.39","0.55-0.41","0.56-0.37","0.56-0.38","0.56-0.41","0.57-0.36","0.57-0.34","0.57-0.35","0.57-0.38","0.57-0.4","0.57-0.42","0.57-0.40","0.58-0.36","0.58-0.38","0.58-0.39","0.58-0.41","0.59-0.39","0.59-0.40" }, displayID = 18723 }; --Nix
	[45404] = { zoneID = 48, artID = { 53 }, x = 0.5, y = 0.24, overlay = { "0.5-0.24" }, displayID = 34187 }; --Geoshaper Maren
	[14269] = { zoneID = 49, artID = { 54 }, x = 0.698, y = 0.552, overlay = { "0.70-0.53","0.70-0.54","0.71-0.55","0.71-0.56","0.72-0.54" }, displayID = 525 }; --Seeker Aqualon
	[14270] = { zoneID = 49, artID = { 54 }, x = 0.36200002, y = 0.426, overlay = { "0.36-0.41","0.36-0.43","0.37-0.42","0.37-0.41" }, displayID = 5243 }; --Squiddic
	[14271] = { zoneID = 49, artID = { 54 }, x = 0.278, y = 0.616, overlay = { "0.28-0.59","0.29-0.59","0.29-0.61","0.29-0.63","0.29-0.64","0.29-0.60","0.3-0.57","0.3-0.60","0.3-0.63","0.30-0.61","0.30-0.62" }, displayID = 500 }; --Ribchaser
	[14272] = { zoneID = 49, artID = { 54 }, x = 0.34, y = 0.57, overlay = { "0.34-0.6","0.34-0.59","0.35-0.60","0.35-0.62","0.35-0.61" }, displayID = 497 }; --Snarlflare
	[14273] = { zoneID = 49, artID = { 54 }, x = 0.564, y = 0.514, displayID = 5229 }; --Boulderheart
	[147222] = { zoneID = 49, artID = { 54 }, x = 0.25, y = 0.694, overlay = { "0.24-0.70","0.25-0.69" }, displayID = 8014 }; --Gnollfeaster
	[52146] = { zoneID = 49, artID = { 54 }, x = 0.64199996, y = 0.644, overlay = { "0.63-0.66","0.63-0.65","0.64-0.64" }, displayID = 909 }; --Chitter
	[584] = { zoneID = 49, artID = { 54 }, x = 0.33400002, y = 0.102, overlay = { "0.33-0.09","0.34-0.10","0.34-0.12" }, displayID = 6041 }; --Kazon
	[616] = { zoneID = 49, artID = { 54 }, x = 0.36400002, y = 0.338, overlay = { "0.36-0.36","0.37-0.34","0.37-0.35","0.37-0.36","0.38-0.33","0.38-0.35","0.38-0.36","0.38-0.34","0.39-0.36" }, displayID = 821 }; --Chatter
	[947] = { zoneID = 49, artID = { 54 }, x = 0.666, y = 0.36, overlay = { "0.68-0.35","0.69-0.36" }, displayID = 10792 }; --Rohh the Silent
	[11383] = { zoneID = 50, artID = { 55 }, x = 0.67, y = 0.316, overlay = { "0.67-0.34" }, displayID = 11295 }; --High Priestess Hai'watna
	[14487] = { zoneID = 50, artID = { 55 }, x = 0.4, y = 0.38799998, overlay = { "0.40-0.39","0.40-0.38","0.41-0.39","0.41-0.40","0.41-0.38","0.42-0.41","0.42-0.42","0.42-0.40","0.43-0.41","0.43-0.43","0.43-0.44" }, displayID = 22530 }; --Gluggl
	[14488] = { zoneID = 50, artID = { 55 }, x = 0.44799998, y = 0.532, overlay = { "0.45-0.54","0.45-0.55","0.45-0.51","0.45-0.52","0.45-0.46","0.45-0.48","0.45-0.50","0.46-0.45","0.46-0.52","0.46-0.49","0.46-0.46","0.46-0.54","0.46-0.48","0.46-0.55","0.47-0.54","0.47-0.45" }, displayID = 5782 }; --Roloch
	[51658] = { zoneID = 50, artID = { 55 }, x = 0.628, y = 0.746, overlay = { "0.62-0.73","0.62-0.74" }, displayID = 37596 }; --Mogh the Dead
	[51661] = { zoneID = 50, artID = { 55 }, x = 0.47599998, y = 0.33200002, overlay = { "0.47-0.32","0.47-0.31","0.47-0.33" }, displayID = 10133 }; --Tsul'Kalu
	[51662] = { zoneID = 50, artID = { 55 }, x = 0.55, y = 0.306, overlay = { "0.53-0.30","0.54-0.31","0.54-0.30","0.54-0.29","0.54-0.3","0.55-0.30" }, displayID = 37613 }; --Mahamba
	[51663] = { zoneID = 50, artID = { 55 }, x = 0.37, y = 0.29799998, overlay = { "0.36-0.29","0.36-0.28","0.37-0.28","0.37-0.29" }, displayID = 37615 }; --Pogeyan
	[1063] = { zoneID = 51, artID = { 56 }, x = 0.3, y = 0.45400003, overlay = { "0.3-0.48","0.30-0.46","0.30-0.47","0.32-0.46" }, displayID = 7975 }; --Jade
	[1106] = { zoneID = 51, artID = { 56 }, x = 0.616, y = 0.276, overlay = { "0.62-0.27","0.62-0.25","0.62-0.26","0.63-0.24","0.63-0.25","0.63-0.26","0.63-0.27" }, displayID = 152 }; --Lost One Cook
	[14445] = { zoneID = 51, artID = { 56 }, x = 0.73800004, y = 0.444, overlay = { "0.74-0.45","0.75-0.45" }, displayID = 7976 }; --Captain Wyrmak
	[14446] = { zoneID = 51, artID = { 56 }, x = 0.77, y = 0.84800005, overlay = { "0.77-0.82","0.77-0.83","0.78-0.85" }, displayID = 441 }; --Fingat
	[14447] = { zoneID = 51, artID = { 56 }, x = 0.89, y = 0.682, overlay = { "0.89-0.66","0.89-0.65","0.9-0.66","0.90-0.67" }, displayID = 4920 }; --Gilmorian
	[14448] = { zoneID = 51, artID = { 56 }, x = 0.482, y = 0.408, overlay = { "0.49-0.42","0.49-0.41","0.5-0.42","0.50-0.41" }, displayID = 14497 }; --Molt Thorn
	[50738] = { zoneID = 51, artID = { 56 }, x = 0.578, y = 0.524, overlay = { "0.55-0.54","0.55-0.52","0.56-0.54","0.57-0.52","0.57-0.54" }, displayID = 25009 }; --Shimmerscale
	[50790] = { zoneID = 51, artID = { 56 }, x = 0.408, y = 0.35799998, overlay = { "0.39-0.34","0.39-0.33","0.39-0.35","0.4-0.34","0.40-0.35" }, displayID = 47120 }; --Ionis
	[50797] = { zoneID = 51, artID = { 56 }, x = 0.708, y = 0.65, overlay = { "0.69-0.66","0.69-0.67","0.7-0.65","0.70-0.64","0.70-0.66","0.70-0.65" }, displayID = 47126 }; --Yukiko
	[50837] = { zoneID = 51, artID = { 56 }, x = 0.802, y = 0.296, overlay = { "0.78-0.27","0.78-0.29","0.79-0.27","0.79-0.28","0.79-0.26","0.79-0.29","0.79-0.30","0.80-0.29" }, displayID = 46575 }; --Kash
	[50882] = { zoneID = 51, artID = { 56 }, x = 0.278, y = 0.636, overlay = { "0.27-0.61","0.27-0.63","0.27-0.62" }, displayID = 19743 }; --Chupacabros
	[50886] = { zoneID = 51, artID = { 56 }, x = 0.90599996, y = 0.39200002, overlay = { "0.80-0.16","0.81-0.17","0.82-0.17","0.85-0.24","0.85-0.22","0.85-0.21","0.85-0.23","0.85-0.25","0.86-0.23","0.87-0.24","0.87-0.30","0.88-0.26","0.88-0.31","0.88-0.27","0.88-0.29","0.88-0.33","0.89-0.28","0.89-0.33","0.89-0.31","0.89-0.27","0.89-0.35","0.9-0.35","0.90-0.36","0.90-0.38","0.90-0.39" }, displayID = 21268 }; --Seawing
	[50903] = { zoneID = 51, artID = { 56 }, x = 0.186, y = 0.382, overlay = { "0.16-0.36","0.16-0.35","0.17-0.38","0.17-0.37","0.17-0.39","0.17-0.36","0.18-0.35","0.18-0.38" }, displayID = 37856 }; --Orlix the Swamplord
	[51052] = { zoneID = 51, artID = { 56 }, x = 0.17799999, y = 0.48, overlay = { "0.16-0.47","0.17-0.47","0.17-0.48" }, displayID = 46574 }; --Gib the Banana-Hoarder
	[5348] = { zoneID = 51, artID = { 56 }, x = 0.18, y = 0.698, displayID = 625 }; --Dreamwatcher Forktongue
	[763] = { zoneID = 51, artID = { 56 }, x = 0.59599996, y = 0.264, overlay = { "0.61-0.25","0.61-0.23","0.61-0.27","0.61-0.26","0.62-0.25","0.62-0.24","0.63-0.24","0.63-0.25","0.63-0.19","0.63-0.23","0.64-0.23","0.64-0.22","0.65-0.21","0.65-0.22","0.65-0.23" }, displayID = 10921 }; --Lost One Chieftain
	[1424] = { zoneID = 52, artID = { 57 }, x = 0.46, y = 0.184, displayID = 774 }; --Master Digger
	[462] = { zoneID = 52, artID = { 57 }, x = 0.48400003, y = 0.33, overlay = { "0.49-0.28","0.49-0.32","0.49-0.33","0.49-0.35","0.49-0.26","0.50-0.28","0.50-0.33","0.54-0.24","0.54-0.25","0.55-0.35","0.55-0.23","0.56-0.34","0.56-0.33","0.56-0.20","0.56-0.35","0.57-0.19","0.57-0.20","0.58-0.18","0.58-0.20" }, displayID = 507 }; --Vultros
	[506] = { zoneID = 52, artID = { 57 }, x = 0.59599996, y = 0.744, overlay = { "0.6-0.73","0.6-0.74","0.60-0.73","0.60-0.74","0.61-0.73","0.61-0.75","0.63-0.72","0.63-0.73","0.63-0.75","0.64-0.71","0.64-0.73","0.64-0.75" }, displayID = 383 }; --Sergeant Brashclaw
	[519] = { zoneID = 52, artID = { 57 }, x = 0.498, y = 0.103999995, overlay = { "0.50-0.10","0.52-0.10","0.53-0.09","0.54-0.11","0.54-0.10","0.54-0.12","0.55-0.10","0.55-0.09","0.56-0.09","0.56-0.11" }, displayID = 540 }; --Slark
	[520] = { zoneID = 52, artID = { 57 }, x = 0.288, y = 0.72800004, displayID = 652 }; --Brack
	[572] = { zoneID = 52, artID = { 57 }, x = 0.412, y = 0.284, overlay = { "0.41-0.29","0.42-0.29","0.42-0.28" }, displayID = 1065 }; --Leprithus
	[573] = { zoneID = 52, artID = { 57 }, x = 0.3851248, y = 0.51590526, overlay = { "0.38-0.50","0.38-0.52","0.44-0.36","0.54-0.33","0.54-0.32","0.55-0.31","0.62-0.61","0.62-0.62","0.63-0.60","0.63-0.61" }, displayID = 548 }; --Foe Reaper 4000
	[596] = { zoneID = 52, artID = { 57 }, x = 0.41, y = 0.766, overlay = { "0.42-0.76","0.42-0.79" }, displayID = 3267 }; --Brainwashed Noble
	[599] = { zoneID = 55, artID = { 60 }, x = 0.296, y = 0.614, overlay = { "0.29-0.59","0.32-0.56","0.33-0.56","0.34-0.55","0.34-0.54","0.34-0.56","0.35-0.56","0.36-0.56","0.37-0.56","0.39-0.55","0.41-0.56","0.50-0.53","0.51-0.54","0.51-0.65","0.52-0.54","0.52-0.56","0.52-0.57","0.52-0.58","0.53-0.58","0.53-0.63","0.54-0.54","0.54-0.57","0.54-0.68","0.54-0.55","0.54-0.69","0.56-0.64","0.56-0.66","0.56-0.67","0.56-0.70","0.56-0.71","0.57-0.65","0.57-0.66","0.57-0.69","0.62-0.59" }, displayID = 2355 }; --Marisa du'Paige
	[1112] = { zoneID = 56, artID = { 61 }, x = 0.468, y = 0.634, displayID = 955 }; --Leech Widow
	[1140] = { zoneID = 56, artID = { 61 }, x = 0.698, y = 0.292, displayID = 11316 }; --Razormaw Matriarch
	[14424] = { zoneID = 56, artID = { 61 }, x = 0.504, y = 0.30200002, overlay = { "0.50-0.32","0.50-0.27","0.50-0.31","0.51-0.29","0.51-0.28","0.51-0.33","0.52-0.35","0.52-0.36","0.52-0.27","0.52-0.33","0.52-0.34","0.53-0.27","0.53-0.34","0.53-0.28","0.54-0.33","0.54-0.32","0.54-0.29","0.55-0.30","0.55-0.27","0.55-0.31","0.55-0.26","0.55-0.29","0.56-0.29","0.56-0.30" }, displayID = 631 }; --Mirelow
	[14425] = { zoneID = 56, artID = { 61 }, x = 0.304, y = 0.33, overlay = { "0.30-0.32","0.31-0.32","0.31-0.33","0.31-0.29","0.34-0.27","0.35-0.27","0.35-0.28" }, displayID = 543 }; --Gnawbone
	[14433] = { zoneID = 56, artID = { 61 }, x = 0.444, y = 0.248, displayID = 8834 }; --Sludginn
	[2090] = { zoneID = 56, artID = { 61 }, x = 0.48, y = 0.742, displayID = 4914 }; --Ma'ruk Wyrmscale
	[2108] = { zoneID = 56, artID = { 61 }, x = 0.382, y = 0.458, overlay = { "0.38-0.46" }, displayID = 4913 }; --Garneg Charskull
	[44224] = { zoneID = 56, artID = { 61 }, x = 0.156, y = 0.4, overlay = { "0.13-0.37","0.13-0.39","0.13-0.41","0.13-0.42","0.13-0.38","0.15-0.38","0.15-0.39","0.15-0.37","0.15-0.4" }, displayID = 1763 }; --Two-Toes
	[44225] = { zoneID = 56, artID = { 61 }, x = 0.428, y = 0.32599998, overlay = { "0.42-0.32" }, displayID = 32448 }; --Rufus Darkshot
	[44226] = { zoneID = 56, artID = { 61 }, x = 0.336, y = 0.51, overlay = { "0.32-0.50","0.33-0.51" }, displayID = 33737 }; --Sarltooth
	[44227] = { zoneID = 56, artID = { 61 }, x = 0.616, y = 0.578, overlay = { "0.61-0.57" }, displayID = 3199 }; --Gazz the Loch-Hunter
	[50964] = { zoneID = 56, artID = { 61 }, x = 0.58, y = 0.086, overlay = { "0.57-0.09","0.57-0.08","0.57-0.07","0.58-0.08" }, displayID = 46230 }; --Chops
	[14428] = { zoneID = 57, artID = { 62 }, x = 0.65199995, y = 0.512, displayID = 6818 }; --Uruson
	[14429] = { zoneID = 57, artID = { 62 }, x = 0.516, y = 0.384, displayID = 1011 }; --Grimmaw
	[14430] = { zoneID = 57, artID = { 62 }, x = 0.522, y = 0.674, overlay = { "0.54-0.66","0.57-0.66","0.59-0.64","0.59-0.65" }, displayID = 11453 }; --Duskstalker
	[14431] = { zoneID = 57, artID = { 62 }, x = 0.37, y = 0.304, overlay = { "0.37-0.31","0.37-0.32","0.38-0.33","0.38-0.34","0.39-0.35","0.39-0.36","0.39-0.37" }, displayID = 2296 }; --Fury Shelda
	[14432] = { zoneID = 57, artID = { 62 }, x = 0.53, y = 0.442, displayID = 904 }; --Threggil
	[2162] = { zoneID = 57, artID = { 62 }, x = 0.472, y = 0.44799998, overlay = { "0.47-0.45" }, displayID = 936 }; --Agal
	[3535] = { zoneID = 57, artID = { 62 }, x = 0.52, y = 0.638, displayID = 1549 }; --Blackmoss the Fetid
	[144946] = { zoneID = 62, artID = { 1176 }, x = 0.41599998, y = 0.35799998, overlay = { "0.41-0.36","0.41-0.35" }, displayID = 90400, questID = { 54865,54896 } }; --Ivus the Forest Lord
	[147240] = { zoneID = 62, artID = { 1176 }, x = 0.528, y = 0.318, overlay = { "0.52-0.32","0.52-0.31" }, displayID = 88619, questID = { 54227,54228 } }; --Hydrath
	[147241] = { zoneID = 62, artID = { 1176 }, x = 0.438, y = 0.536, overlay = { "0.43-0.53" }, displayID = 8714, questID = { 54229,54230 } }; --Cyclarus
	[147260] = { zoneID = 62, artID = { 1176 }, x = 0.39200002, y = 0.618, overlay = { "0.39-0.61" }, displayID = 1070, questID = { 54232,54233 } }; --Conflagros
	[147261] = { zoneID = 62, artID = { 1176 }, x = 0.482, y = 0.556, overlay = { "0.47-0.55","0.48-0.55" }, displayID = 1162, questID = { 54234,54235 } }; --Granokk
	[147332] = { zoneID = 62, artID = { 1176 }, x = 0.45599997, y = 0.588, overlay = { "0.45-0.58" }, displayID = 89635, questID = { 54247,54248 } }; --Stonebinder Ssra'vess
	[147435] = { zoneID = 62, artID = { 1176 }, x = 0.62, y = 0.16600001, overlay = { "0.62-0.16" }, friendly = { "A" }, displayID = 89707, questID = { 54252 } }; --Thelar Moonstrike
	[147664] = { zoneID = 62, artID = { 1176 }, x = 0.624, y = 0.098000005, overlay = { "0.62-0.09" }, friendly = { "H" }, displayID = 89764, questID = { 54274 } }; --Zim'kaga
	[147701] = { zoneID = 62, artID = { 1176 }, x = 0.67, y = 0.188, overlay = { "0.63-0.2","0.63-0.20","0.64-0.19","0.64-0.2","0.65-0.19","0.66-0.19","0.67-0.18" }, friendly = { "H" }, displayID = 89768, questID = { 54277 } }; --Moxo the Beheader
	[147708] = { zoneID = 62, artID = { 1176 }, x = 0.58599997, y = 0.246, overlay = { "0.58-0.24" }, displayID = 66623, questID = { 54278,54279 } }; --Athrikus Narassin
	[147744] = { zoneID = 62, artID = { 1176 }, x = 0.576, y = 0.156, overlay = { "0.57-0.15" }, displayID = 75372, questID = { 54285,54286 } }; --Glrglrr
	[147751] = { zoneID = 62, artID = { 1176 }, x = 0.436, y = 0.296, overlay = { "0.43-0.29" }, displayID = 82155, questID = { 54289,54290 } }; --Shattershard
	[147758] = { zoneID = 62, artID = { 1176 }, x = 0.45200002, y = 0.75, overlay = { "0.45-0.75" }, friendly = { "A" }, displayID = 1455, questID = { 54291 } }; --Onu
	[147845] = { zoneID = 62, artID = { 1176 }, x = 0.466, y = 0.866, overlay = { "0.46-0.86","0.46-0.85" }, friendly = { "H" }, displayID = 89798, questID = { 54309 } }; --Commander Drald
	[147897] = { zoneID = 62, artID = { 1176 }, x = 0.406, y = 0.856, overlay = { "0.40-0.84","0.40-0.85" }, displayID = 85923, questID = { 54320,54321 } }; --Soggoth the Slitherer
	[147942] = { zoneID = 62, artID = { 1176 }, x = 0.406, y = 0.826, overlay = { "0.40-0.82" }, displayID = 89822, questID = { 54397,54398 } }; --Twilight Prophet Graeme
	[147966] = { zoneID = 62, artID = { 1176 }, x = 0.378, y = 0.84800005, overlay = { "0.37-0.84" }, displayID = 1698, questID = { 54405,54406 } }; --Aman
	[147970] = { zoneID = 62, artID = { 1176 }, x = 0.35799998, y = 0.818, overlay = { "0.35-0.81" }, displayID = 72659, questID = { 54408,54409 } }; --Mrggr'marr
	[148025] = { zoneID = 62, artID = { 1176 }, x = 0.378, y = 0.76199996, overlay = { "0.37-0.76" }, displayID = 84029, questID = { 54426,54427 } }; --Commander Ral'esh
	[148031] = { zoneID = 62, artID = { 1176 }, x = 0.408, y = 0.566, overlay = { "0.40-0.56" }, displayID = 1010, questID = { 54428,54429 } }; --Gren Tornfur
	[148037] = { zoneID = 62, artID = { 1176 }, x = 0.41599998, y = 0.766, overlay = { "0.40-0.73","0.40-0.74","0.41-0.74","0.41-0.76","0.41-0.75" }, friendly = { "A" }, displayID = 89379, questID = { 54431 } }; --Athil Dewfire
	[148103] = { zoneID = 62, artID = { 1176 }, x = 0.33, y = 0.83800006, overlay = { "0.33-0.83" }, friendly = { "A" }, displayID = 89860, questID = { 54452 } }; --Sapper Odette
	[148295] = { zoneID = 62, artID = { 1176 }, x = 0.41599998, y = 0.36, overlay = { "0.41-0.35","0.41-0.36" }, displayID = 89962, questID = { 54862,54895 } }; --Ivus the Decayed
	[148787] = { zoneID = 62, artID = { 1176 }, x = 0.566, y = 0.308, overlay = { "0.56-0.30" }, displayID = 89749, questID = { 54695,54696 } }; --Alash'anir
	[149141] = { zoneID = 62, artID = { 1176 }, x = 0.41599998, y = 0.768, overlay = { "0.41-0.76" }, friendly = { "H" }, displayID = 56590, questID = { 54768 } }; --Burninator Mark V
	[149652] = { zoneID = 62, artID = { 1176 }, x = 0.496, y = 0.25, overlay = { "0.49-0.24","0.49-0.25" }, friendly = { "H" }, displayID = 89897, questID = { 54883 } }; --Agathe Wyrmwood
	[149654] = { zoneID = 62, artID = { 1176 }, x = 0.436, y = 0.19600001, overlay = { "0.43-0.19" }, displayID = 89029, questID = { 54884,54885 } }; --Glimmerspine
	[149655] = { zoneID = 62, artID = { 1176 }, x = 0.506, y = 0.32599998, overlay = { "0.50-0.32" }, friendly = { "H" }, displayID = 77979, questID = { 54886 } }; --Croz Bloodrage
	[149657] = { zoneID = 62, artID = { 1176 }, x = 0.44, y = 0.48599997, overlay = { "0.44-0.48" }, displayID = 67206, questID = { 54887,54888 } }; --Madfeather
	[149659] = { zoneID = 62, artID = { 1176 }, x = 0.396, y = 0.336, overlay = { "0.39-0.33" }, friendly = { "H" }, displayID = 89896, questID = { 54889 } }; --Orwell Stevenson
	[149660] = { zoneID = 62, artID = { 1176 }, x = 0.496, y = 0.25, overlay = { "0.49-0.24","0.49-0.25" }, friendly = { "A" }, displayID = 707, questID = { 54890 } }; --Blackpaw
	[149662] = { zoneID = 62, artID = { 1176 }, x = 0.506, y = 0.32599998, overlay = { "0.50-0.32" }, friendly = { "A" }, displayID = 89315, questID = { 54891 } }; --Grimhorn
	[149663] = { zoneID = 62, artID = { 1176 }, x = 0.398, y = 0.32799998, overlay = { "0.39-0.32" }, friendly = { "A" }, displayID = 62590, questID = { 54892 } }; --Shadowclaw
	[149665] = { zoneID = 62, artID = { 1176 }, x = 0.47599998, y = 0.44599998, overlay = { "0.47-0.44" }, displayID = 67608, questID = { 54893,54894 } }; --Scalefiend
	[2172] = { zoneID = 62, artID = { 67 }, x = 0.408, y = 0.48400003, displayID = 38 }; --Strider Clutchmother
	[2175] = { zoneID = 62, artID = { 67 }, x = 0.412, y = 0.36400002, displayID = 3030 }; --Shadowclaw
	[2184] = { zoneID = 62, artID = { 67 }, x = 0.44799998, y = 0.566, displayID = 5774 }; --Lady Moongazer
	[2186] = { zoneID = 62, artID = { 67 }, x = 0.442, y = 0.824, overlay = { "0.44-0.83" }, displayID = 5773 }; --Carnivous the Breaker
	[2191] = { zoneID = 62, artID = { 67 }, x = 0.572, y = 0.32799998, displayID = 10819 }; --Licillin
	[2192] = { zoneID = 62, artID = { 67 }, x = 0.4, y = 0.83, displayID = 5772 }; --Firecaller Radison
	[7015] = { zoneID = 62, artID = { 67 }, x = 0.574, y = 0.152, overlay = { "0.58-0.11","0.58-0.09" }, displayID = 1305 }; --Flagglemurk the Cruel
	[7016] = { zoneID = 62, artID = { 67 }, x = 0.46400002, y = 0.414, overlay = { "0.48-0.41","0.48-0.39" }, displayID = 4982 }; --Lady Vespira
	[7017] = { zoneID = 62, artID = { 67 }, x = 0.34, y = 0.834, displayID = 4762 }; --Lord Sinslayer
	[10559] = { zoneID = 63, artID = { 68 }, x = 0.12, y = 0.15, overlay = { "0.12-0.29","0.15-0.24" }, displayID = 4979 }; --Lady Vespia
	[10639] = { zoneID = 63, artID = { 68 }, x = 0.37, y = 0.336, displayID = 6800 }; --Rorgish Jowl
	[10640] = { zoneID = 63, artID = { 68 }, x = 0.54, y = 0.622, overlay = { "0.54-0.63","0.55-0.62","0.56-0.64","0.57-0.64" }, displayID = 5773 }; --Oakpaw
	[10641] = { zoneID = 63, artID = { 68 }, x = 0.42400002, y = 0.462, overlay = { "0.43-0.46","0.43-0.47","0.43-0.48","0.43-0.50","0.43-0.51","0.43-0.52","0.44-0.53","0.45-0.47","0.46-0.47","0.46-0.48","0.46-0.51" }, displayID = 8389 }; --Branch Snapper
	[10642] = { zoneID = 63, artID = { 68 }, x = 0.46400002, y = 0.694, overlay = { "0.46-0.70","0.47-0.71","0.47-0.68","0.47-0.69","0.48-0.68","0.49-0.68","0.49-0.71","0.49-0.69","0.49-0.70","0.5-0.71","0.50-0.70","0.51-0.70" }, displayID = 5561 }; --Eck'alom
	[10644] = { zoneID = 63, artID = { 68 }, x = 0.252, y = 0.268, overlay = { "0.26-0.15" }, displayID = 165 }; --Mist Howler
	[10647] = { zoneID = 63, artID = { 68 }, x = 0.666, y = 0.568, overlay = { "0.78-0.45","0.81-0.49" }, displayID = 11331 }; --Prince Raze
	[12037] = { zoneID = 63, artID = { 68 }, x = 0.894, y = 0.46400002, overlay = { "0.89-0.47","0.92-0.45" }, displayID = 706 }; --Ursol'lok
	[3735] = { zoneID = 63, artID = { 68 }, x = 0.314, y = 0.22399999, overlay = { "0.32-0.23" }, friendly = { "H" }, displayID = 4156 }; --Apothecary Falthis
	[3736] = { zoneID = 63, artID = { 68 }, x = 0.72400004, y = 0.71, overlay = { "0.73-0.73","0.75-0.71" }, friendly = { "H" }, displayID = 4155 }; --Darkslayer Mordenthal
	[3773] = { zoneID = 63, artID = { 68 }, x = 0.25, y = 0.60400003, displayID = 1912 }; --Akkrilus
	[3792] = { zoneID = 63, artID = { 68 }, x = 0.53, y = 0.374, displayID = 522 }; --Terrowulf Packlord
	[14426] = { zoneID = 64, artID = { 69 }, x = 0.384, y = 0.272, overlay = { "0.38-0.28" }, displayID = 3898 }; --Harb Foulmountain
	[14427] = { zoneID = 64, artID = { 69 }, x = 0.398, y = 0.32599998, overlay = { "0.4-0.32" }, displayID = 511 }; --Gibblesnik
	[4132] = { zoneID = 64, artID = { 69 }, x = 0.698, y = 0.856, overlay = { "0.7-0.85" }, displayID = 37583 }; --Krkk'kx
	[50329] = { zoneID = 64, artID = { 69 }, x = 0.90800005, y = 0.406, overlay = { "0.89-0.40","0.9-0.39","0.90-0.38","0.90-0.39","0.90-0.40" }, displayID = 46999 }; --Rrakk
	[50727] = { zoneID = 64, artID = { 69 }, x = 0.946, y = 0.816, overlay = { "0.93-0.80","0.94-0.81" }, displayID = 20834 }; --Strix the Barbed
	[50741] = { zoneID = 64, artID = { 69 }, x = 0.376, y = 0.56, overlay = { "0.37-0.56" }, displayID = 1561 }; --Kaxx
	[50748] = { zoneID = 64, artID = { 69 }, x = 0.44599998, y = 0.404, overlay = { "0.44-0.40" }, displayID = 481 }; --Nyaj
	[50785] = { zoneID = 64, artID = { 69 }, x = 0.942, y = 0.58599997, overlay = { "0.93-0.57","0.94-0.58" }, displayID = 46995 }; --Skyshadow
	[50892] = { zoneID = 64, artID = { 69 }, x = 0.552, y = 0.406, overlay = { "0.55-0.40" }, displayID = 25857 }; --Cyn
	[50952] = { zoneID = 64, artID = { 69 }, x = 0.41599998, y = 0.368, overlay = { "0.41-0.36" }, displayID = 46994 }; --Barnacle Jim
	[51001] = { zoneID = 64, artID = { 69 }, x = 0.818, y = 0.96, overlay = { "0.81-0.95","0.81-0.96" }, displayID = 15423 }; --Venomclaw
	[51008] = { zoneID = 64, artID = { 69 }, x = 0.71199995, y = 0.948, overlay = { "0.71-0.94" }, displayID = 20912 }; --The Barbed Horror
	[5933] = { zoneID = 64, artID = { 69 }, x = 0.696, y = 0.49400002, overlay = { "0.70-0.50","0.71-0.49","0.71-0.5","0.72-0.5","0.72-0.49" }, displayID = 9418 }; --Achellios the Banished
	[5935] = { zoneID = 64, artID = { 69 }, x = 0.612, y = 0.67, displayID = 2076 }; --Ironeye the Invincible
	[5937] = { zoneID = 64, artID = { 69 }, x = 0.054, y = 0.42, overlay = { "0.06-0.42" }, displayID = 10988 }; --Vile Sting
	[4015] = { zoneID = 65, artID = { 70 }, x = 0.55, y = 0.45, overlay = { "0.55-0.44","0.55-0.46" }, displayID = 4585 }; --Pridewing Patriarch
	[4066] = { zoneID = 65, artID = { 70 }, x = 0.48400003, y = 0.734, displayID = 8471 }; --Nal'taszar
	[50343] = { zoneID = 65, artID = { 70 }, x = 0.6, y = 0.634, overlay = { "0.59-0.64","0.6-0.63" }, displayID = 46988 }; --Quall
	[50759] = { zoneID = 65, artID = { 70 }, x = 0.544, y = 0.748, overlay = { "0.54-0.74" }, displayID = 42742 }; --Iriss the Widow
	[50786] = { zoneID = 65, artID = { 70 }, x = 0.59, y = 0.866, overlay = { "0.58-0.86","0.59-0.86" }, displayID = 46990 }; --Sparkwing
	[50812] = { zoneID = 65, artID = { 70 }, x = 0.49400002, y = 0.65599996, overlay = { "0.49-0.65" }, displayID = 46229 }; --Arae
	[50825] = { zoneID = 65, artID = { 70 }, x = 0.76, y = 0.91199994, overlay = { "0.76-0.91" }, displayID = 46987 }; --Feras
	[50874] = { zoneID = 65, artID = { 70 }, x = 0.444, y = 0.492, overlay = { "0.44-0.49" }, displayID = 19733 }; --Tenok
	[50884] = { zoneID = 65, artID = { 70 }, x = 0.44799998, y = 0.55799997, overlay = { "0.44-0.55" }, displayID = 21268 }; --Dustflight the Cowardly
	[50895] = { zoneID = 65, artID = { 70 }, x = 0.398, y = 0.46, overlay = { "0.39-0.46" }, displayID = 46998 }; --Volux
	[50986] = { zoneID = 65, artID = { 70 }, x = 0.82199997, y = 0.792, overlay = { "0.82-0.79" }, displayID = 5245 }; --Goldenback
	[51062] = { zoneID = 65, artID = { 70 }, x = 0.746, y = 0.732, overlay = { "0.74-0.73" }, displayID = 46225 }; --Khep-Re
	[5915] = { zoneID = 65, artID = { 70 }, x = 0.41799998, y = 0.19, displayID = 4599 }; --Brother Ravenoak
	[5928] = { zoneID = 65, artID = { 70 }, x = 0.50200003, y = 0.412, displayID = 11012 }; --Sorrow Wing
	[5930] = { zoneID = 65, artID = { 70 }, x = 0.404, y = 0.708, overlay = { "0.40-0.71" }, displayID = 10875 }; --Sister Riven
	[5932] = { zoneID = 65, artID = { 70 }, x = 0.644, y = 0.45400003, displayID = 487 }; --Taskmaster Whipfang
	[14225] = { zoneID = 66, artID = { 71 }, x = 0.744, y = 0.124, overlay = { "0.75-0.18","0.77-0.23" }, displayID = 6743 }; --Prince Kellen
	[14226] = { zoneID = 66, artID = { 71 }, x = 0.5, y = 0.72, overlay = { "0.50-0.81","0.50-0.80","0.51-0.75","0.51-0.76","0.51-0.84","0.55-0.76","0.56-0.74" }, displayID = 14255 }; --Kaskk
	[14227] = { zoneID = 66, artID = { 71 }, x = 0.41799998, y = 0.466, overlay = { "0.42-0.45","0.42-0.46","0.43-0.42","0.43-0.61","0.43-0.41","0.46-0.53","0.46-0.54","0.51-0.47","0.51-0.48" }, displayID = 2076 }; --Hissperak
	[14228] = { zoneID = 66, artID = { 71 }, x = 0.574, y = 0.084, overlay = { "0.57-0.1","0.58-0.09","0.58-0.18","0.59-0.17","0.6-0.25","0.60-0.24","0.61-0.24","0.61-0.25","0.63-0.34","0.63-0.19","0.64-0.19","0.64-0.33","0.66-0.24","0.66-0.25","0.66-0.26" }, displayID = 2714 }; --Giggler
	[14229] = { zoneID = 66, artID = { 71 }, x = 0.29, y = 0.134, overlay = { "0.29-0.14","0.30-0.18","0.31-0.13","0.32-0.13","0.32-0.05","0.32-0.06","0.32-0.15","0.32-0.14","0.33-0.05","0.34-0.09" }, displayID = 9135 }; --Accursed Slitherblade
	[18241] = { zoneID = 66, artID = { 71 }, x = 0.344, y = 0.216, overlay = { "0.34-0.23","0.34-0.24","0.34-0.20","0.34-0.22","0.35-0.2","0.35-0.25","0.35-0.24","0.36-0.20","0.36-0.25","0.36-0.22","0.36-0.23","0.37-0.19","0.37-0.20","0.38-0.20","0.38-0.19","0.39-0.18","0.41-0.18" }, displayID = 27692 }; --Crusty
	[11688] = { zoneID = 67, artID = { 72 }, x = 0.1994499, y = 0.3927951, overlay = { "0.12-0.5","0.13-0.47","0.13-0.49","0.13-0.48","0.14-0.47","0.14-0.48","0.14-0.49","0.15-0.45","0.15-0.50","0.15-0.38","0.15-0.39","0.15-0.42","0.15-0.5","0.16-0.45","0.16-0.52","0.16-0.37","0.16-0.54","0.17-0.4","0.17-0.41","0.17-0.44","0.17-0.56","0.17-0.38","0.17-0.40","0.17-0.43","0.18-0.43","0.18-0.57","0.18-0.44","0.18-0.60","0.18-0.46","0.19-0.43","0.19-0.44","0.19-0.59","0.19-0.38","0.2-0.39","0.2-0.60","0.20-0.50","0.20-0.45","0.20-0.61","0.20-0.46","0.21-0.44","0.21-0.49","0.21-0.50","0.21-0.5","0.21-0.52","0.21-0.54","0.21-0.53","0.21-0.56","0.22-0.46","0.22-0.56","0.22-0.59","0.22-0.58","0.22-0.61","0.23-0.44","0.23-0.43","0.26-0.42","0.29-0.42" }, displayID = 11640 }; --Cursed Centaur
	[11447] = { zoneID = 69, artID = { 74 }, x = 0.692, y = 0.614, overlay = { "0.69-0.59","0.69-0.58","0.69-0.62","0.70-0.63","0.71-0.63","0.71-0.57","0.71-0.61","0.71-0.59","0.72-0.60","0.72-0.62","0.72-0.58" }, displayID = 14382 }; --Mushgog
	[11497] = { zoneID = 69, artID = { 74 }, x = 0.845, y = 0.497, displayID = 12683 }; --The Razza
	[11498] = { zoneID = 69, artID = { 74 }, x = 0.84199995, y = 0.37, displayID = 10169 }; --Skarr the Broken
	[115537] = { zoneID = 69, artID = { 74 }, x = 0.566, y = 0.736, overlay = { "0.54-0.71","0.54-0.73","0.54-0.75","0.55-0.75","0.55-0.71","0.55-0.73","0.56-0.73" }, displayID = 73851 }; --Lorthalium
	[43488] = { zoneID = 69, artID = { 74 }, x = 0.496, y = 0.306, overlay = { "0.49-0.30" }, displayID = 21120 }; --Mordei the Earthrender
	[5343] = { zoneID = 69, artID = { 74 }, x = 0.304, y = 0.458, overlay = { "0.31-0.42","0.31-0.45","0.32-0.43" }, displayID = 11262 }; --Lady Szallah
	[5345] = { zoneID = 69, artID = { 74 }, x = 0.49, y = 0.20799999, displayID = 1817 }; --Diamond Head
	[5346] = { zoneID = 69, artID = { 74 }, x = 0.518, y = 0.606, overlay = { "0.52-0.60","0.52-0.59" }, displayID = 7336 }; --Bloodroar the Stalker
	[5347] = { zoneID = 69, artID = { 74 }, x = 0.53400004, y = 0.688, overlay = { "0.53-0.70","0.53-0.67","0.54-0.66","0.54-0.71","0.54-0.65","0.54-0.67","0.54-0.68","0.54-0.73","0.54-0.69","0.55-0.65","0.55-0.66","0.55-0.70","0.55-0.71","0.55-0.69","0.55-0.72" }, displayID = 10889 }; --Antilus the Soarer
	[5349] = { zoneID = 69, artID = { 74 }, x = 0.374, y = 0.22, overlay = { "0.37-0.23","0.38-0.24","0.38-0.21","0.39-0.20","0.39-0.21","0.40-0.24","0.40-0.22","0.41-0.22","0.41-0.24" }, displayID = 7569 }; --Arash-ethis
	[5350] = { zoneID = 69, artID = { 74 }, x = 0.734, y = 0.64, overlay = { "0.76-0.61" }, displayID = 11142 }; --Qirot
	[5352] = { zoneID = 69, artID = { 74 }, x = 0.554, y = 0.612, overlay = { "0.55-0.62","0.55-0.59","0.56-0.57","0.56-0.58","0.56-0.60","0.56-0.62","0.57-0.58","0.57-0.62","0.58-0.58","0.58-0.62","0.58-0.59","0.59-0.62","0.59-0.61","0.59-0.60","0.6-0.59","0.6-0.60","0.60-0.60","0.60-0.62","0.61-0.62" }, displayID = 706 }; --Old Grizzlegut
	[5354] = { zoneID = 69, artID = { 74 }, x = 0.694, y = 0.42200002, overlay = { "0.69-0.43","0.69-0.44","0.69-0.41","0.69-0.45","0.7-0.41","0.70-0.40","0.71-0.40","0.71-0.39","0.71-0.46","0.71-0.42","0.71-0.45","0.72-0.39","0.72-0.43","0.72-0.45","0.72-0.40" }, displayID = 2168 }; --Gnarl Leafbrother
	[5356] = { zoneID = 69, artID = { 74 }, x = 0.752, y = 0.36400002, overlay = { "0.76-0.38","0.77-0.37","0.78-0.38","0.79-0.39","0.81-0.38","0.81-0.39","0.82-0.39","0.83-0.38","0.84-0.38" }, displayID = 780 }; --Snarler
	[54533] = { zoneID = {
				[69] = { x = 0.48599997, y = 0.79, overlay = { "0.47-0.74","0.48-0.78","0.48-0.79" } };
				[81] = { x = 0.214, y = 0.064, overlay = { "0.20-0.08","0.21-0.06" } };
			  }, displayID = 39009 }; --null
	[90816] = { zoneID = 69, artID = { 74 }, x = 0.536, y = 0.64599997, overlay = { "0.53-0.64" }, displayID = 12589 }; --Skystormer
	[14230] = { zoneID = 70, artID = { 498,75 }, x = 0.574, y = 0.16600001, overlay = { "0.59-0.09","0.62-0.08","0.62-0.07" }, displayID = 391 }; --Burgle Eye
	[14231] = { zoneID = 70, artID = { 498,75 }, x = 0.376, y = 0.184, overlay = { "0.39-0.18","0.39-0.17","0.39-0.19" }, displayID = 631 }; --Drogoth the Roamer
	[14232] = { zoneID = 70, artID = { 498,75 }, x = 0.468, y = 0.174, overlay = { "0.47-0.18","0.47-0.15","0.47-0.16","0.47-0.2","0.47-0.19","0.48-0.14","0.48-0.15","0.48-0.16","0.49-0.17","0.49-0.18" }, displayID = 788 }; --Dart
	[14233] = { zoneID = 70, artID = { 498,75 }, x = 0.376, y = 0.492, overlay = { "0.37-0.50","0.41-0.55","0.42-0.55","0.42-0.54","0.43-0.50","0.43-0.5","0.47-0.54","0.47-0.55","0.49-0.57" }, displayID = 2549 }; --Ripscale
	[14234] = { zoneID = 70, artID = { 498,75 }, x = 0.474, y = 0.614, overlay = { "0.47-0.63","0.48-0.59","0.48-0.60","0.48-0.61" }, displayID = 2703 }; --Hayoc
	[14235] = { zoneID = 70, artID = { 498,75 }, x = 0.514, y = 0.606, overlay = { "0.53-0.58" }, displayID = 11140 }; --The Rot
	[14236] = { zoneID = 70, artID = { 498,75 }, x = 0.552, y = 0.632, overlay = { "0.55-0.65","0.56-0.63","0.56-0.62" }, displayID = 14257 }; --Lord Angler
	[14237] = { zoneID = 70, artID = { 498,75 }, x = 0.36400002, y = 0.624, overlay = { "0.37-0.62" }, displayID = 12336 }; --Oozeworm
	[4339] = { zoneID = 70, artID = { 498,75 }, x = 0.50200003, y = 0.754, displayID = 6374 }; --Brimgore
	[4380] = { zoneID = 70, artID = { 498,75 }, x = 0.33400002, y = 0.22799999, displayID = 2537 }; --Darkmist Widow
	[50342] = { zoneID = 70, artID = { 498,75 }, x = 0.402, y = 0.286, overlay = { "0.39-0.28","0.4-0.28","0.40-0.28" }, displayID = 33004 }; --Heronis
	[50735] = { zoneID = 70, artID = { 498,75 }, x = 0.514, y = 0.168, overlay = { "0.51-0.16" }, displayID = 4435 }; --Blinkeye the Rattler
	[50764] = { zoneID = 70, artID = { 498,75 }, x = 0.39, y = 0.744, overlay = { "0.38-0.74","0.39-0.74" }, displayID = 46518 }; --Paraliss
	[50784] = { zoneID = 70, artID = { 498,75 }, x = 0.32599998, y = 0.308, overlay = { "0.32-0.31","0.32-0.30" }, displayID = 47124 }; --Anith
	[50875] = { zoneID = 70, artID = { 498,75 }, x = 0.346, y = 0.704, overlay = { "0.34-0.70","0.34-0.71" }, displayID = 46287 }; --Nychus
	[50901] = { zoneID = 70, artID = { 498,75 }, x = 0.42, y = 0.42, overlay = { "0.41-0.43","0.42-0.42" }, displayID = 46235 }; --Teromak
	[50945] = { zoneID = 70, artID = { 498,75 }, x = 0.296, y = 0.44799998, overlay = { "0.29-0.44" }, displayID = 4714 }; --Scruff
	[50957] = { zoneID = 70, artID = { 498,75 }, x = 0.54, y = 0.436, overlay = { "0.53-0.43","0.54-0.43" }, displayID = 46285 }; --Hugeclaw
	[51061] = { zoneID = 70, artID = { 498,75 }, x = 0.50200003, y = 0.84599996, overlay = { "0.50-0.84" }, displayID = 15339 }; --Roth-Salam
	[51069] = { zoneID = 70, artID = { 498,75 }, x = 0.55799997, y = 0.856, overlay = { "0.55-0.85" }, displayID = 46290 }; --Scintillex
	[39183] = { zoneID = 71, artID = { 76 }, x = 0.496, y = 0.58599997, overlay = { "0.49-0.58" }, displayID = 31351 }; --Scorpitar
	[39185] = { zoneID = 71, artID = { 76 }, x = 0.402, y = 0.674, overlay = { "0.4-0.67","0.40-0.67" }, displayID = 31352 }; --Slaverjaw
	[39186] = { zoneID = 71, artID = { 76 }, x = 0.408, y = 0.412, overlay = { "0.40-0.41" }, displayID = 45946 }; --Hellgazer
	[44714] = { zoneID = 71, artID = { 76 }, x = 0.57, y = 0.898, overlay = { "0.57-0.89" }, displayID = 34030 }; --Fronkle the Disturbed
	[44722] = { zoneID = 71, artID = { 76 }, x = 0.64599997, y = 0.198, overlay = { "0.64-0.2","0.64-0.19" }, displayID = 11757 }; --Twisted Reflection of Narain
	[44750] = { zoneID = 71, artID = { 76 }, x = 0.47, y = 0.65199995, overlay = { "0.47-0.65" }, displayID = 9169 }; --Caliph Scorpidsting
	[44759] = { zoneID = 71, artID = { 76 }, x = 0.696, y = 0.568, overlay = { "0.69-0.57","0.69-0.56" }, displayID = 9073 }; --Andre Firebeard
	[44761] = { zoneID = 71, artID = { 76 }, x = 0.696, y = 0.5, overlay = { "0.69-0.5" }, displayID = 5564 }; --Aquementas the Unchained
	[44767] = { zoneID = 71, artID = { 76 }, x = 0.61, y = 0.506, overlay = { "0.61-0.50" }, displayID = 19060 }; --Occulus the Corrupted
	[47386] = { zoneID = 71, artID = { 76 }, x = 0.368, y = 0.47599998, overlay = { "0.32-0.48","0.33-0.48","0.33-0.46","0.34-0.45","0.35-0.44","0.36-0.42","0.36-0.43","0.36-0.46","0.36-0.47" }, displayID = 37549 }; --Ainamiss the Hive Queen
	[47387] = { zoneID = 71, artID = { 76 }, x = 0.566, y = 0.688, overlay = { "0.50-0.72","0.52-0.65","0.52-0.70","0.53-0.70","0.55-0.64","0.56-0.68" }, displayID = 15657 }; --Harakiss the Infestor
	[8199] = { zoneID = 71, artID = { 76 }, x = 0.408, y = 0.292, displayID = 9023 }; --Warleader Krazzilak
	[8200] = { zoneID = 71, artID = { 76 }, x = 0.374, y = 0.26, overlay = { "0.37-0.25","0.40-0.30" }, displayID = 9024 }; --Jin'Zallah the Sandbringer
	[8201] = { zoneID = 71, artID = { 76 }, x = 0.4309957, y = 0.5396465, overlay = { "0.37-0.56","0.38-0.56","0.38-0.53","0.38-0.54","0.38-0.57","0.38-0.52","0.38-0.58","0.39-0.50","0.39-0.58","0.40-0.50","0.40-0.58","0.41-0.49","0.41-0.51","0.42-0.54","0.42-0.52","0.43-0.55" }, displayID = 11570 }; --Omgorn the Lost
	[8203] = { zoneID = 71, artID = { 76 }, x = 0.71199995, y = 0.468, overlay = { "0.73-0.47","0.75-0.45" }, displayID = 7509 }; --Kregg Keelhaul
	[8207] = { zoneID = 71, artID = { 76 }, x = 0.444, y = 0.404, overlay = { "0.48-0.45" }, displayID = 34048 }; --Emberwing
	[8204] = { zoneID = 72, artID = { 78 }, x = 0.53400004, y = 0.67800003, overlay = { "0.53-0.70" }, displayID = 11106 }; --Soriid the Devourer
	[8205] = { zoneID = 73, artID = { 77 }, x = 0.6015961, y = 0.25384665, overlay = { "0.58-0.23","0.60-0.27","0.60-0.21" }, displayID = 11092 }; --Haarka the Ravenous
	[107477] = { zoneID = 76, artID = { 81 }, x = 0.44, y = 0.764, overlay = { "0.43-0.76","0.43-0.75","0.44-0.76" }, displayID = 70105 }; --N.U.T.Z.
	[13896] = { zoneID = 76, artID = { 81 }, x = 0.42200002, y = 0.50200003, overlay = { "0.42-0.46","0.42-0.48","0.42-0.49","0.43-0.51","0.43-0.52" }, displayID = 7046 }; --Scalebeard
	[6118] = { zoneID = 76, artID = { 81 }, x = 0.324, y = 0.77199996, overlay = { "0.33-0.75","0.33-0.76","0.33-0.74","0.34-0.73","0.34-0.71","0.34-0.76","0.35-0.77","0.36-0.71","0.37-0.74","0.37-0.73" }, displayID = 10771 }; --Varo'then's Ghost
	[6648] = { zoneID = 76, artID = { 81 }, x = 0.444, y = 0.264, overlay = { "0.44-0.27","0.44-0.28" }, displayID = 3212 }; --Antilos
	[6649] = { zoneID = 76, artID = { 81 }, x = 0.44, y = 0.598, displayID = 11261 }; --Lady Sesspira
	[6650] = { zoneID = 76, artID = { 81 }, x = 0.588, y = 0.77, overlay = { "0.59-0.77","0.60-0.77","0.61-0.77","0.61-0.78","0.62-0.78","0.62-0.76","0.63-0.79","0.63-0.81" }, displayID = 11257 }; --General Fangferror
	[6651] = { zoneID = 76, artID = { 81 }, x = 0.33, y = 0.324, friendly = { "A","H" }, displayID = 1012 }; --Gatekeeper Rageroar
	[8660] = { zoneID = 76, artID = { 81 }, x = 0.138, y = 0.506, overlay = { "0.14-0.50","0.14-0.57" }, displayID = 10807 }; --The Evalcharr
	[107595] = { zoneID = 77, artID = { 82 }, x = 0.382, y = 0.45599997, overlay = { "0.38-0.45" }, displayID = 70193 }; --Grimrot
	[107596] = { zoneID = 77, artID = { 82 }, x = 0.382, y = 0.45599997, overlay = { "0.38-0.45" }, displayID = 70194 }; --Grimrot
	[14339] = { zoneID = 77, artID = { 82 }, x = 0.482, y = 0.744, overlay = { "0.48-0.73","0.48-0.75","0.53-0.85","0.53-0.84" }, displayID = 11412 }; --Death Howl
	[14340] = { zoneID = 77, artID = { 82 }, x = 0.39200002, y = 0.8, overlay = { "0.4-0.82","0.40-0.82","0.40-0.83","0.41-0.84","0.42-0.84","0.43-0.85" }, displayID = 2879 }; --Alshirr Banebreath
	[14342] = { zoneID = 77, artID = { 82 }, x = 0.48599997, y = 0.89, overlay = { "0.49-0.88" }, displayID = 1012 }; --Ragepaw
	[14343] = { zoneID = 77, artID = { 82 }, x = 0.544, y = 0.264, overlay = { "0.54-0.27","0.54-0.23","0.55-0.24","0.56-0.23","0.57-0.18","0.57-0.19" }, displayID = 6212 }; --Olm the Wise
	[14344] = { zoneID = 77, artID = { 82 }, x = 0.43400002, y = 0.758, overlay = { "0.46-0.82" }, displayID = 14315 }; --Mongress
	[14345] = { zoneID = 77, artID = { 82 }, x = 0.42, y = 0.458, displayID = 682 }; --The Ongar
	[50362] = { zoneID = 77, artID = { 82 }, x = 0.348, y = 0.59599996, overlay = { "0.34-0.59" }, displayID = 20596 }; --Blackbog the Fang
	[50724] = { zoneID = 77, artID = { 82 }, x = 0.606, y = 0.222, overlay = { "0.60-0.22" }, displayID = 20297 }; --Spinecrawl
	[50777] = { zoneID = 77, artID = { 82 }, x = 0.51, y = 0.342, overlay = { "0.51-0.34" }, displayID = 18041 }; --Needle
	[50833] = { zoneID = 77, artID = { 82 }, x = 0.406, y = 0.31, overlay = { "0.39-0.31","0.40-0.31" }, displayID = 38913 }; --Duskcoat
	[50864] = { zoneID = 77, artID = { 82 }, x = 0.59599996, y = 0.068, overlay = { "0.59-0.06" }, displayID = 46831 }; --Thicket
	[50905] = { zoneID = 77, artID = { 82 }, x = 0.45, y = 0.318, overlay = { "0.45-0.31" }, displayID = 46830 }; --Cida
	[50925] = { zoneID = 77, artID = { 82 }, x = 0.382, y = 0.726, overlay = { "0.38-0.72" }, displayID = 9569 }; --Grovepaw
	[51017] = { zoneID = 77, artID = { 82 }, x = 0.52599996, y = 0.316, overlay = { "0.52-0.31" }, displayID = 20142 }; --Gezan
	[51025] = { zoneID = 77, artID = { 82 }, x = 0.42200002, y = 0.482, overlay = { "0.42-0.47","0.42-0.48" }, displayID = 12335 }; --Dilennaa
	[51046] = { zoneID = 77, artID = { 82 }, x = 0.38599998, y = 0.528, overlay = { "0.38-0.52" }, displayID = 46517 }; --Fidonis
	[7104] = { zoneID = 77, artID = { 82 }, x = 0.578, y = 0.19399999, displayID = 9013 }; --Dessecus
	[7137] = { zoneID = 77, artID = { 82 }, x = 0.406, y = 0.43400002, overlay = { "0.41-0.42","0.41-0.38" }, displayID = 0 }; --Immolatus
	[6581] = { zoneID = 78, artID = { 83 }, x = 0.608, y = 0.72800004, overlay = { "0.66-0.67" }, displayID = 11319 }; --Ravasaur Matriarch
	[6583] = { zoneID = 78, artID = { 83 }, x = 0.318, y = 0.78199995, overlay = { "0.32-0.78","0.33-0.79" }, displayID = 10932 }; --Gruff
	[6584] = { zoneID = 78, artID = { 83 }, x = 0.29, y = 0.36400002, overlay = { "0.29-0.47","0.29-0.42","0.29-0.46","0.29-0.45","0.29-0.37","0.3-0.35","0.3-0.44","0.30-0.45","0.30-0.46","0.30-0.31","0.31-0.29","0.31-0.3","0.31-0.36","0.32-0.30","0.32-0.31","0.32-0.36","0.33-0.28","0.33-0.29","0.33-0.35","0.33-0.37","0.34-0.38","0.35-0.35","0.35-0.36","0.35-0.37","0.35-0.39","0.36-0.37","0.36-0.30","0.36-0.35","0.36-0.34","0.37-0.31","0.37-0.33","0.37-0.30","0.37-0.32" }, displayID = 5305 }; --King Mosh
	[6585] = { zoneID = 78, artID = { 83 }, x = 0.628, y = 0.184, overlay = { "0.63-0.18" }, displayID = 8129 }; --Uhk'loc
	[6582] = { zoneID = 79, artID = { 84 }, x = 0.768, y = 0.524, overlay = { "0.78-0.47","0.80-0.45" }, displayID = 11084 }; --Clutchmother Zavas
	[122609] = { zoneID = 80, artID = { 85 }, x = 0.688, y = 0.6, overlay = { "0.65-0.59","0.65-0.6","0.65-0.60","0.65-0.61","0.66-0.6","0.66-0.60","0.67-0.59","0.67-0.58","0.67-0.62","0.67-0.60","0.68-0.60","0.68-0.6" }, displayID = 64706 }; --Xavinox
	[132578] = { zoneID = 81, artID = { 962 }, x = 0.616, y = 0.134, overlay = { "0.57-0.12","0.57-0.13","0.58-0.15","0.58-0.12","0.58-0.13","0.58-0.14","0.59-0.12","0.59-0.11","0.59-0.13","0.60-0.14","0.61-0.13" }, displayID = 82490 }; --Qroshekx
	[132580] = { zoneID = 81, artID = { 962 }, x = 0.55799997, y = 0.8, overlay = { "0.53-0.79","0.54-0.78","0.54-0.79","0.54-0.81","0.55-0.77","0.55-0.8" }, displayID = 82491 }; --Ssinkrix
	[132584] = { zoneID = 81, artID = { 962 }, x = 0.296, y = 0.35799998, overlay = { "0.29-0.35","0.29-0.34" }, displayID = 82492 }; --Xaarshej
	[132591] = { zoneID = 81, artID = { 962 }, x = 0.31, y = 0.77, overlay = { "0.26-0.73","0.27-0.76","0.27-0.73","0.27-0.74","0.27-0.72","0.28-0.74","0.28-0.75","0.28-0.71","0.28-0.73","0.28-0.77","0.28-0.76","0.29-0.70","0.29-0.75","0.29-0.76","0.29-0.71","0.29-0.73","0.29-0.72","0.29-0.77","0.3-0.70","0.3-0.77","0.30-0.74","0.30-0.76","0.30-0.68","0.30-0.72","0.31-0.73","0.31-0.75","0.31-0.77" }, displayID = 53683 }; --Ogmot the Mad
	[137906] = { zoneID = 81, artID = { 962 }, x = 0.506, y = 0.538, overlay = { "0.44-0.35","0.45-0.35","0.47-0.32","0.48-0.31","0.48-0.51","0.49-0.52","0.5-0.53","0.50-0.53" }, displayID = 82155 }; --Infused Bedrock CHECK
	[14471] = { zoneID = 81, artID = { 86 }, x = 0.36, y = 0.82199997, displayID = 5965 }; --Setis
	[14472] = { zoneID = 81, artID = { 86 }, x = 0.35599998, y = 0.38, overlay = { "0.35-0.39","0.36-0.38","0.36-0.42","0.36-0.39","0.44-0.51","0.44-0.49","0.45-0.50","0.45-0.51","0.51-0.56","0.52-0.55","0.53-0.54","0.53-0.55","0.64-0.57","0.64-0.58" }, displayID = 1104 }; --Gretheer
	[14473] = { zoneID = 81, artID = { 86 }, x = 0.554, y = 0.71, overlay = { "0.56-0.74","0.57-0.75","0.57-0.76","0.58-0.66","0.60-0.68","0.61-0.66","0.63-0.73","0.63-0.74","0.63-0.82","0.65-0.75" }, displayID = 14521 }; --Lapress
	[14474] = { zoneID = 81, artID = { 86 }, x = 0.27, y = 0.62, overlay = { "0.32-0.55","0.33-0.53" }, displayID = 14522 }; --Zora
	[14475] = { zoneID = 81, artID = { 86 }, x = 0.51, y = 0.23, overlay = { "0.51-0.26","0.51-0.25","0.52-0.24" }, displayID = 12153 }; --Rex Ashil
	[14476] = { zoneID = 81, artID = { 86 }, x = 0.624, y = 0.184, overlay = { "0.64-0.39","0.67-0.29","0.69-0.36","0.69-0.37" }, displayID = 6068 }; --Krellack
	[14477] = { zoneID = 81, artID = { 86 }, x = 0.34, y = 0.732, overlay = { "0.34-0.71","0.34-0.72","0.35-0.71","0.41-0.65","0.41-0.64","0.48-0.71","0.48-0.72","0.49-0.72","0.49-0.63","0.49-0.71","0.5-0.62","0.50-0.61","0.50-0.63","0.50-0.62" }, displayID = 14523 }; --Grubthor
	[14478] = { zoneID = 81, artID = { 86 }, x = 0.292, y = 0.192, overlay = { "0.29-0.20","0.30-0.24","0.30-0.26","0.32-0.15","0.32-0.26","0.33-0.14","0.33-0.26","0.35-0.16","0.36-0.16","0.36-0.17","0.36-0.22","0.36-0.21","0.36-0.23" }, displayID = 14525 }; --Huricanian
	[14479] = { zoneID = 81, artID = { 86 }, x = 0.254, y = 0.77199996, overlay = { "0.26-0.75","0.26-0.76","0.26-0.77","0.33-0.3","0.34-0.31","0.35-0.30","0.35-0.32","0.44-0.40","0.44-0.41","0.45-0.42","0.46-0.41" }, displayID = 14526 }; --Twilight Lord Everun
	[50370] = { zoneID = 81, artID = { 86 }, x = 0.576, y = 0.148, overlay = { "0.57-0.14" }, displayID = 20067 }; --Karapax
	[50737] = { zoneID = 81, artID = { 86 }, x = 0.736, y = 0.16, overlay = { "0.73-0.16" }, displayID = 46985 }; --Acroniss
	[50742] = { zoneID = 81, artID = { 86 }, x = 0.44, y = 0.172, overlay = { "0.43-0.17","0.44-0.17" }, displayID = 46982 }; --Qem
	[50743] = { zoneID = 81, artID = { 86 }, x = 0.67800003, y = 0.66800004, overlay = { "0.67-0.66" }, displayID = 46983 }; --Manax
	[50744] = { zoneID = 81, artID = { 86 }, x = 0.546, y = 0.266, overlay = { "0.54-0.26" }, displayID = 46981 }; --Qu'rik
	[50745] = { zoneID = 81, artID = { 86 }, x = 0.426, y = 0.566, overlay = { "0.42-0.55","0.42-0.57","0.42-0.56" }, displayID = 15658 }; --Losaj
	[50746] = { zoneID = 81, artID = { 86 }, x = 0.636, y = 0.888, overlay = { "0.62-0.89","0.63-0.88" }, displayID = 15656 }; --Bornix the Burrower
	[50747] = { zoneID = {
				[81] = { x = 0.38, y = 0.85800004, overlay = { "0.38-0.85" } };
				[327] = { x = 0.608, y = 0.066, overlay = { "0.60-0.06" } };
			  }, displayID = 15334 }; --null
	[50897] = { zoneID = 81, artID = { 86 }, x = 0.33, y = 0.53400004, overlay = { "0.32-0.53","0.33-0.53" }, displayID = 46980 }; --Ffexk the Dunestalker
	[51004] = { zoneID = 81, artID = { 86 }, x = 0.428, y = 0.18200001, overlay = { "0.42-0.17","0.42-0.18","0.42-0.16" }, displayID = 46984 }; --Toxx
	[10196] = { zoneID = 83, artID = { 88 }, x = 0.556, y = 0.64199996, overlay = { "0.56-0.65","0.57-0.65","0.58-0.65","0.59-0.65","0.59-0.64","0.60-0.64","0.62-0.64" }, displayID = 9489 }; --General Colbatann
	[10197] = { zoneID = 83, artID = { 88 }, x = 0.24, y = 0.504, overlay = { "0.24-0.51" }, displayID = 3208 }; --Mezzir the Howler
	[10198] = { zoneID = 83, artID = { 88 }, x = 0.612, y = 0.83800006, displayID = 10317 }; --Kashoch the Reaver
	[10199] = { zoneID = 83, artID = { 88 }, x = 0.684, y = 0.50200003, displayID = 9491 }; --Grizzle Snowpaw
	[10200] = { zoneID = 83, artID = { 88 }, x = 0.468, y = 0.19399999, overlay = { "0.47-0.19","0.47-0.18","0.48-0.17" }, displayID = 10054 }; --Rak'shiri
	[10202] = { zoneID = 83, artID = { 88 }, x = 0.524, y = 0.59, overlay = { "0.52-0.61","0.56-0.57","0.58-0.56","0.58-0.55","0.60-0.53","0.61-0.54","0.63-0.54","0.63-0.55","0.64-0.56","0.65-0.66","0.65-0.67","0.65-0.58","0.65-0.61","0.65-0.64","0.66-0.63" }, displayID = 6373 }; --Azurous
	[10741] = { zoneID = 83, artID = { 88 }, x = 0.458, y = 0.174, displayID = 10114 }; --Sian-Rotam
	[50346] = { zoneID = 83, artID = { 88 }, x = 0.598, y = 0.428, overlay = { "0.59-0.42" }, displayID = 17093 }; --Ronak
	[50348] = { zoneID = 83, artID = { 88 }, x = 0.59599996, y = 0.24, overlay = { "0.59-0.23","0.59-0.24" }, displayID = 17092 }; --Norissis
	[50353] = { zoneID = 83, artID = { 88 }, x = 0.64, y = 0.8, overlay = { "0.64-0.8" }, displayID = 45200 }; --Manas
	[50788] = { zoneID = 83, artID = { 88 }, x = 0.66800004, y = 0.83599997, overlay = { "0.66-0.83" }, displayID = 46996 }; --Quetzl
	[50819] = { zoneID = 83, artID = { 88 }, x = 0.52, y = 0.188, overlay = { "0.52-0.18" }, displayID = 9951 }; --Iceclaw
	[50993] = { zoneID = 83, artID = { 88 }, x = 0.35599998, y = 0.488, overlay = { "0.35-0.48","0.35-0.49" }, displayID = 26267 }; --Gal'dorak
	[50995] = { zoneID = 83, artID = { 88 }, x = 0.66, y = 0.42, overlay = { "0.65-0.41","0.65-0.42","0.66-0.42" }, displayID = 28648 }; --Bruiser
	[50997] = { zoneID = 83, artID = { 88 }, x = 0.624, y = 0.248, overlay = { "0.59-0.16","0.59-0.17","0.62-0.24" }, displayID = 26295 }; --Bornak the Gorer
	[51028] = { zoneID = 83, artID = { 88 }, x = 0.506, y = 0.72199994, overlay = { "0.50-0.72" }, displayID = 37551 }; --The Deep Tunneler
	[51045] = { zoneID = 83, artID = { 88 }, x = 0.48, y = 0.59599996, overlay = { "0.48-0.59" }, displayID = 24906 }; --Arcanus
	[149886] = { zoneID = 84, artID = { 89 }, x = 0.8522, y = 0.2483, friendly = { "H","A" }, displayID = 90574, questID = { 54950 } }; --Stanley
	[3581] = { zoneID = 84, artID = { 89 }, x = 0.48400003, y = 0.618, overlay = { "0.52-0.64","0.54-0.68","0.54-0.64","0.54-0.70","0.54-0.65","0.54-0.67","0.54-0.69","0.55-0.70","0.55-0.65","0.56-0.72","0.56-0.74","0.56-0.76","0.56-0.64","0.57-0.75","0.57-0.76","0.57-0.73","0.57-0.77","0.58-0.41","0.58-0.79","0.59-0.43","0.59-0.45","0.59-0.44","0.60-0.45","0.60-0.72","0.61-0.47","0.61-0.48","0.62-0.51","0.62-0.49","0.62-0.50","0.63-0.49","0.64-0.60","0.65-0.65","0.65-0.50","0.65-0.64","0.66-0.61","0.66-0.64","0.66-0.58","0.67-0.55","0.67-0.52","0.67-0.54","0.67-0.62","0.67-0.64","0.67-0.66","0.68-0.53","0.68-0.50","0.68-0.64","0.69-0.65","0.69-0.51","0.69-0.63","0.69-0.49","0.69-0.5","0.7-0.50","0.70-0.65","0.70-0.68","0.71-0.48" }, displayID = 2850 }; --Sewer Beast
	[149887] = { zoneID = 85, artID = { 90 }, x = 0.5349, y = 0.7076, friendly = { "H","A" }, displayID = 90571, questID = { 54948 } }; --Stanley
	[16854] = { zoneID = 94, artID = { 99 }, x = 0.682, y = 0.45, overlay = { "0.68-0.46","0.69-0.48","0.69-0.49","0.69-0.47","0.7-0.46","0.70-0.47" }, displayID = 14272 }; --Eldinarcus
	[16855] = { zoneID = 94, artID = { 99 }, x = 0.628, y = 0.796, overlay = { "0.63-0.79","0.63-0.78","0.64-0.78","0.64-0.67","0.65-0.67","0.65-0.68","0.66-0.69","0.66-0.79","0.68-0.79","0.68-0.71","0.69-0.81","0.69-0.73","0.69-0.74","0.69-0.78","0.69-0.72","0.70-0.72","0.70-0.75" }, displayID = 16406 }; --Tregla
	[22062] = { zoneID = 95, artID = { 100 }, x = 0.294, y = 0.884, overlay = { "0.34-0.48","0.34-0.47","0.35-0.88","0.35-0.89","0.4-0.5","0.40-0.49" }, displayID = 16176 }; --Dr. Whitherlimb
	[18677] = { zoneID = 100, artID = { 105 }, x = 0.41, y = 0.71, overlay = { "0.41-0.70","0.41-0.69","0.41-0.67","0.42-0.66","0.42-0.65","0.42-0.64","0.43-0.62","0.44-0.59","0.44-0.39","0.45-0.42","0.45-0.44","0.45-0.41","0.46-0.43","0.46-0.59","0.46-0.44","0.46-0.46","0.47-0.58","0.47-0.46","0.48-0.50","0.48-0.54","0.48-0.53","0.49-0.50","0.49-0.52","0.50-0.50","0.50-0.51","0.51-0.51","0.53-0.50","0.55-0.50","0.64-0.72","0.65-0.71","0.67-0.68","0.67-0.73","0.67-0.76","0.68-0.70","0.69-0.69","0.69-0.68" }, displayID = 20761 }; --Mekthorg the Wild
	[18678] = { zoneID = 100, artID = { 105 }, x = 0.236, y = 0.568, overlay = { "0.23-0.58","0.23-0.59","0.23-0.61","0.23-0.55","0.23-0.63","0.24-0.48","0.24-0.49","0.25-0.45","0.26-0.43","0.26-0.44","0.27-0.42","0.28-0.42","0.28-0.65","0.29-0.40","0.29-0.64","0.3-0.64","0.30-0.64","0.30-0.37","0.31-0.61","0.32-0.60","0.33-0.61","0.35-0.57","0.37-0.52","0.38-0.52","0.40-0.51","0.41-0.71","0.42-0.51","0.42-0.72","0.43-0.50","0.43-0.71","0.45-0.48","0.46-0.69","0.49-0.70","0.50-0.70","0.51-0.70","0.53-0.71","0.54-0.72","0.54-0.71","0.56-0.71" }, displayID = 17445 }; --Fulgorge
	[18679] = { zoneID = 100, artID = { 105 }, x = 0.714, y = 0.56, overlay = { "0.74-0.37" }, displayID = 20044 }; --Vorakem Doomspeaker
	[18680] = { zoneID = 102, artID = { 107 }, x = 0.098000005, y = 0.522, overlay = { "0.10-0.47","0.10-0.55","0.11-0.50","0.11-0.46","0.13-0.45","0.14-0.44","0.15-0.40","0.15-0.43","0.16-0.38","0.16-0.36","0.17-0.34","0.37-0.38","0.38-0.33","0.40-0.33","0.41-0.33","0.42-0.33","0.42-0.34","0.43-0.34","0.44-0.34","0.47-0.32","0.47-0.30","0.47-0.3","0.5-0.30","0.52-0.32","0.52-0.33","0.54-0.33","0.70-0.39","0.70-0.37","0.73-0.36","0.73-0.46","0.75-0.48","0.77-0.51","0.78-0.53" }, displayID = 45045 }; --Marticar
	[18681] = { zoneID = 102, artID = { 107 }, x = 0.254, y = 0.374, overlay = { "0.25-0.42","0.26-0.46","0.59-0.36","0.6-0.36","0.62-0.69","0.63-0.38","0.63-0.43","0.63-0.65","0.64-0.69","0.64-0.41","0.70-0.72","0.72-0.76","0.73-0.82","0.74-0.77" }, displayID = 20768 }; --Coilfang Emissary
	[18682] = { zoneID = 102, artID = { 107 }, x = 0.23, y = 0.214, overlay = { "0.24-0.20","0.28-0.23","0.40-0.61","0.44-0.59","0.49-0.58","0.84-0.79","0.86-0.84","0.86-0.89","0.86-0.91" }, displayID = 20769 }; --Bog Lurker
	[110486] = { zoneID = 103, artID = { 108 }, x = 0.648, y = 0.852, overlay = { "0.55-0.78","0.57-0.74","0.57-0.90","0.57-0.76","0.57-0.81","0.57-0.82","0.57-0.92","0.57-0.73","0.57-0.91","0.57-0.78","0.57-0.84","0.58-0.72","0.58-0.82","0.58-0.84","0.59-0.82","0.59-0.78","0.60-0.80","0.60-0.81","0.60-0.82","0.61-0.83","0.61-0.80","0.61-0.82","0.64-0.85" }, displayID = 71965 }; --Huk'roth the Huntmaster
	[18694] = { zoneID = 104, artID = { 109 }, x = 0.366, y = 0.45, overlay = { "0.37-0.44","0.37-0.43","0.39-0.42","0.4-0.43","0.40-0.43","0.55-0.71","0.58-0.70","0.59-0.70","0.66-0.26","0.67-0.23","0.70-0.28","0.73-0.30","0.73-0.29" }, displayID = 20590 }; --Collidus the Warp-Watcher
	[18695] = { zoneID = 104, artID = { 109 }, x = 0.28, y = 0.48400003, overlay = { "0.28-0.49","0.29-0.55","0.29-0.50","0.29-0.51","0.29-0.52","0.30-0.58","0.45-0.28","0.45-0.30","0.45-0.31","0.46-0.28","0.46-0.66","0.46-0.69","0.46-0.70","0.46-0.26","0.46-0.27","0.46-0.71","0.47-0.65","0.47-0.68","0.47-0.67","0.55-0.38","0.56-0.35","0.57-0.38","0.57-0.35","0.57-0.37","0.57-0.36","0.58-0.36","0.68-0.61","0.68-0.62","0.68-0.59","0.71-0.62" }, displayID = 11347 }; --Ambassador Jerrikar
	[18696] = { zoneID = 104, artID = { 109 }, x = 0.31, y = 0.45200002, overlay = { "0.41-0.40","0.42-0.39","0.42-0.40","0.42-0.68","0.45-0.12","0.59-0.46" }, displayID = 20810 }; --Kraator
	[18690] = { zoneID = 105, artID = { 110 }, x = 0.60400003, y = 0.248, overlay = { "0.63-0.51","0.67-0.47","0.68-0.67","0.68-0.69","0.68-0.46","0.71-0.29","0.72-0.29" }, displayID = 20862 }; --Morcrush
	[18692] = { zoneID = 105, artID = { 110 }, x = 0.28, y = 0.66199994, overlay = { "0.28-0.67","0.29-0.63","0.29-0.49","0.29-0.7","0.29-0.48","0.29-0.47","0.29-0.64","0.29-0.71","0.3-0.45","0.3-0.65","0.30-0.46","0.30-0.66","0.30-0.67","0.30-0.51","0.30-0.68","0.31-0.69","0.31-0.52","0.31-0.57","0.31-0.53","0.31-0.55","0.32-0.54","0.32-0.53" }, displayID = 8574 }; --Hemathion
	[18693] = { zoneID = 105, artID = { 110 }, x = 0.39200002, y = 0.564, overlay = { "0.40-0.55","0.41-0.48","0.41-0.54","0.41-0.51","0.41-0.55","0.41-0.56","0.42-0.50","0.42-0.5","0.42-0.82","0.42-0.49","0.42-0.81","0.43-0.8","0.43-0.78","0.44-0.77","0.45-0.76","0.46-0.78","0.46-0.77","0.46-0.76","0.47-0.75","0.55-0.35","0.56-0.25","0.56-0.24","0.56-0.34","0.56-0.27","0.57-0.27","0.57-0.33","0.57-0.29","0.57-0.30","0.57-0.32","0.64-0.19","0.65-0.2","0.65-0.21","0.65-0.22","0.66-0.23","0.66-0.24","0.66-0.25","0.66-0.26" }, displayID = 20762 }; --Speaker Mar'grom
	[22060] = { zoneID = 106, artID = { 111 }, x = 0.148, y = 0.546, displayID = 20771 }; --Fenissa the Assassin
	[17144] = { zoneID = 107, artID = { 112 }, x = 0.414, y = 0.414, overlay = { "0.44-0.47","0.44-0.40","0.58-0.27","0.74-0.76","0.75-0.75","0.76-0.79","0.76-0.80","0.76-0.78" }, displayID = 20763 }; --Goretooth
	[18683] = { zoneID = 107, artID = { 112 }, x = 0.322, y = 0.704, overlay = { "0.32-0.71","0.32-0.73","0.32-0.69","0.32-0.68","0.33-0.74","0.33-0.67","0.33-0.75","0.34-0.66","0.35-0.76","0.35-0.65","0.36-0.65","0.36-0.77","0.36-0.76","0.37-0.65","0.37-0.66","0.38-0.76","0.39-0.68","0.39-0.74","0.39-0.75","0.39-0.73","0.39-0.70","0.39-0.72" }, displayID = 19681 }; --Voidhunter Yar
	[18684] = { zoneID = 107, artID = { 112 }, x = 0.256, y = 0.518, overlay = { "0.27-0.43","0.5-0.52","0.6-0.75","0.60-0.71","0.60-0.76","0.60-0.72","0.64-0.77","0.65-0.76","0.67-0.73","0.69-0.71","0.69-0.70" }, displayID = 18070 }; --Bro'Gaz the Clanless
	[18685] = { zoneID = 108, artID = { 113 }, x = 0.304, y = 0.43400002, overlay = { "0.30-0.44","0.31-0.43","0.31-0.42","0.49-0.17","0.49-0.18","0.56-0.70","0.56-0.69","0.56-0.71","0.56-0.67","0.56-0.68","0.56-0.66","0.57-0.65","0.57-0.23","0.58-0.23","0.59-0.24","0.59-0.25" }, displayID = 20766 }; --Okrek
	[18686] = { zoneID = 108, artID = { 113 }, x = 0.35599998, y = 0.378, overlay = { "0.35-0.34","0.35-0.35","0.35-0.36","0.35-0.39","0.36-0.40","0.36-0.42","0.41-0.25","0.41-0.26","0.42-0.26","0.43-0.26","0.45-0.26","0.46-0.26","0.47-0.27","0.47-0.26","0.48-0.25","0.49-0.25","0.50-0.25","0.52-0.23","0.53-0.22","0.54-0.20","0.55-0.19","0.55-0.32","0.56-0.32","0.57-0.32","0.59-0.34","0.60-0.35","0.61-0.35","0.62-0.36","0.62-0.37","0.63-0.38","0.64-0.39","0.65-0.41","0.65-0.42","0.67-0.45","0.67-0.46","0.68-0.47","0.69-0.48","0.70-0.48" }, displayID = 20767 }; --Doomsayer Jurim
	[18689] = { zoneID = 108, artID = { 113 }, x = 0.304, y = 0.638, overlay = { "0.32-0.55","0.32-0.52","0.38-0.65","0.38-0.66","0.38-0.67","0.39-0.68","0.39-0.48","0.4-0.50","0.4-0.62","0.41-0.65","0.41-0.63","0.44-0.56","0.45-0.74","0.45-0.79","0.45-0.59","0.46-0.78","0.47-0.62","0.48-0.74","0.48-0.55","0.48-0.57","0.49-0.71" }, displayID = 12073 }; --Crippler
	[21724] = { zoneID = 108, artID = { 113 }, x = 0.76199996, y = 0.812, displayID = 20425 }; --Hawkbane
	[18697] = { zoneID = 109, artID = { 114 }, x = 0.262, y = 0.404, overlay = { "0.26-0.42","0.26-0.41","0.26-0.36","0.27-0.37","0.27-0.38","0.27-0.39","0.28-0.4","0.46-0.8","0.46-0.80","0.46-0.82","0.46-0.83","0.47-0.80","0.47-0.84","0.48-0.81","0.49-0.81","0.58-0.64","0.58-0.62","0.59-0.62","0.59-0.67","0.59-0.66","0.60-0.65","0.61-0.65" }, displayID = 20765 }; --Chief Engineer Lorthander
	[18698] = { zoneID = 109, artID = { 114 }, x = 0.206, y = 0.682, overlay = { "0.21-0.76","0.22-0.64","0.24-0.75","0.24-0.41","0.25-0.41","0.26-0.42","0.26-0.65","0.26-0.72","0.27-0.69","0.27-0.42","0.28-0.41","0.28-0.40","0.29-0.4","0.29-0.41","0.30-0.41","0.57-0.39","0.57-0.42","0.59-0.33","0.59-0.35","0.61-0.46","0.61-0.32","0.65-0.32" }, displayID = 20764 }; --Ever-Core the Punisher
	[20932] = { zoneID = 109, artID = { 114 }, x = 0.23200001, y = 0.78800005, overlay = { "0.24-0.80","0.26-0.81","0.33-0.32","0.34-0.20","0.34-0.25","0.34-0.27","0.35-0.26","0.35-0.19","0.35-0.24","0.35-0.78","0.38-0.78","0.39-0.77","0.40-0.77","0.44-0.71","0.54-0.59","0.57-0.60","0.63-0.58","0.65-0.58","0.67-0.60" }, displayID = 19913 }; --Nuramoc
	[32357] = { zoneID = 114, artID = { 119 }, x = 0.338, y = 0.308, displayID = 24960 }; --Old Crystalbark
	[32358] = { zoneID = 114, artID = { 119 }, x = 0.576, y = 0.188, overlay = { "0.59-0.23","0.59-0.24","0.60-0.15","0.61-0.22","0.61-0.30","0.61-0.20","0.62-0.18","0.62-0.34","0.63-0.16","0.63-0.27","0.63-0.28","0.65-0.17","0.65-0.18","0.65-0.35","0.66-0.19","0.66-0.36","0.66-0.22","0.67-0.23","0.67-0.28","0.68-0.36","0.68-0.19","0.69-0.31","0.69-0.37","0.69-0.38","0.70-0.37","0.70-0.29","0.70-0.36","0.71-0.34","0.72-0.36","0.72-0.27" }, displayID = 24103 }; --Fumblub Gearwind
	[32361] = { zoneID = 114, artID = { 119 }, x = 0.804, y = 0.46, overlay = { "0.81-0.31","0.81-0.32","0.84-0.46","0.85-0.34","0.88-0.39","0.91-0.32" }, displayID = 26286 }; --Icehorn
	[32400] = { zoneID = 115, artID = { 120 }, x = 0.546, y = 0.544, overlay = { "0.57-0.50","0.57-0.48","0.57-0.49","0.58-0.59","0.59-0.60","0.59-0.28","0.59-0.43","0.60-0.32","0.61-0.58","0.61-0.48","0.62-0.49","0.62-0.50","0.62-0.51","0.62-0.54","0.62-0.52","0.63-0.54","0.63-0.36","0.64-0.36","0.67-0.31","0.67-0.29","0.68-0.58","0.69-0.48","0.69-0.56","0.69-0.54" }, displayID = 27951 }; --Tukemuth
	[32409] = { zoneID = 115, artID = { 120 }, x = 0.154, y = 0.45200002, overlay = { "0.15-0.58","0.20-0.55","0.24-0.53","0.24-0.54","0.26-0.58","0.28-0.61","0.28-0.60","0.30-0.58","0.33-0.56","0.33-0.57" }, displayID = 28284 }; --Crazed Indu'le Survivor
	[32417] = { zoneID = 115, artID = { 120 }, x = 0.69, y = 0.758, overlay = { "0.69-0.74","0.71-0.22","0.71-0.73","0.72-0.25","0.72-0.70","0.72-0.74","0.75-0.27","0.85-0.36","0.86-0.36","0.86-0.40","0.86-0.41","0.88-0.36" }, displayID = 10294 }; --Scarlet Highlord Daion
	[32422] = { zoneID = 116, artID = { 121 }, x = 0.102, y = 0.372, overlay = { "0.10-0.39","0.11-0.41","0.11-0.42","0.11-0.71","0.11-0.43","0.12-0.55","0.12-0.70","0.12-0.43","0.12-0.44","0.12-0.54","0.12-0.45","0.12-0.53","0.12-0.5","0.13-0.46","0.13-0.48","0.13-0.51","0.13-0.55","0.13-0.70","0.13-0.54","0.14-0.53","0.14-0.70","0.14-0.52","0.14-0.51","0.15-0.7","0.15-0.50","0.16-0.69","0.17-0.70","0.17-0.71","0.18-0.72","0.19-0.72","0.2-0.72","0.20-0.56","0.21-0.71","0.21-0.57","0.22-0.57","0.22-0.72","0.22-0.73","0.23-0.57","0.23-0.56","0.24-0.54","0.24-0.55","0.24-0.56","0.24-0.6","0.25-0.58","0.25-0.56","0.25-0.57","0.26-0.56","0.28-0.41" }, displayID = 26663 }; --Grocklar
	[32429] = { zoneID = 116, artID = { 121 }, x = 0.282, y = 0.45400003, overlay = { "0.34-0.49","0.34-0.48","0.38-0.49","0.39-0.50","0.4-0.48","0.4-0.49","0.40-0.48" }, displayID = 18083 }; --Seething Hate
	[32438] = { zoneID = 116, artID = { 121 }, x = 0.62, y = 0.368, overlay = { "0.64-0.35","0.65-0.3","0.65-0.35","0.65-0.33","0.65-0.28","0.65-0.36","0.65-0.37","0.66-0.39","0.66-0.35","0.66-0.40","0.66-0.28","0.66-0.41","0.66-0.36","0.67-0.38","0.67-0.28","0.68-0.26","0.68-0.30","0.69-0.31","0.70-0.33","0.70-0.34","0.71-0.35","0.73-0.37","0.75-0.38","0.76-0.41" }, displayID = 27970 }; --Syreian the Bonecarver
	[38453] = { zoneID = 116, artID = { 121 }, x = 0.31, y = 0.55799997, displayID = 31094 }; --Arcturis
	[32377] = { zoneID = 117, artID = { 122 }, x = 0.50200003, y = 0.048, overlay = { "0.53-0.12","0.53-0.11","0.60-0.2","0.68-0.16","0.68-0.17","0.71-0.13" }, displayID = 28051 }; --Perobas the Bloodthirster
	[32386] = { zoneID = 117, artID = { 122 }, x = 0.686, y = 0.48400003, overlay = { "0.69-0.58","0.69-0.49","0.69-0.57","0.7-0.49","0.7-0.57","0.70-0.51","0.70-0.56","0.71-0.55","0.71-0.53","0.71-0.44","0.71-0.45","0.71-0.54","0.71-0.46","0.71-0.48","0.71-0.43","0.72-0.43","0.72-0.44","0.72-0.49","0.72-0.50","0.72-0.51","0.72-0.52","0.72-0.61","0.72-0.40","0.72-0.46","0.73-0.45","0.73-0.53","0.73-0.39","0.74-0.45","0.74-0.52","0.74-0.46","0.74-0.47","0.74-0.48","0.74-0.49","0.74-0.54","0.74-0.55","0.74-0.56","0.74-0.60","0.74-0.53","0.74-0.57","0.74-0.59","0.74-0.51","0.74-0.58","0.75-0.48","0.75-0.58","0.75-0.49","0.75-0.42","0.75-0.44","0.75-0.47","0.75-0.45","0.75-0.46" }, displayID = 27063 }; --Vigdis the War Maiden
	[32398] = { zoneID = 117, artID = { 122 }, x = 0.26, y = 0.64, overlay = { "0.30-0.71","0.31-0.56","0.32-0.74","0.32-0.75","0.33-0.80" }, displayID = 27950 }; --King Ping
	[174048] = { zoneID = 118, artID = { 123 }, x = 0.44170904, y = 0.49160963, overlay = { "0.44-0.49" }, displayID = 27407, resetTimer = 1200, questID = { 62326 } }; --Elder Nadox
	[174049] = { zoneID = 118, artID = { 123 }, x = 0.29510763, y = 0.62136525, overlay = { "0.29-0.62" }, displayID = 30856, resetTimer = 1200, questID = { 62327 } }; --Prince Taldaram
	[174050] = { zoneID = 118, artID = { 123 }, x = 0.67502165, y = 0.5816729, overlay = { "0.67-0.58" }, displayID = 27394, resetTimer = 1200, questID = { 62328 } }; --Krik'thir the Gatewatcher
	[174051] = { zoneID = 118, artID = { 123 }, x = 0.5831629, y = 0.39307454, overlay = { "0.58-0.39" }, displayID = 26352, resetTimer = 1200, questID = { 62329 } }; --Trollgore
	[174052] = { zoneID = 118, artID = { 123 }, x = 0.7788021, y = 0.6610173, overlay = { "0.77-0.66" }, displayID = 26292, resetTimer = 1200, questID = { 62330 } }; --Novos the Summoner
	[174053] = { zoneID = 118, artID = { 123 }, x = 0.8031386, y = 0.61346227, overlay = { "0.79-0.60","0.80-0.61" }, displayID = 27072, resetTimer = 1200, questID = { 62331 } }; --The Prophet Tharon'ja
	[174054] = { zoneID = 118, artID = { 123 }, x = 0.5017176, y = 0.88094807, overlay = { "0.50-0.87","0.50-0.88" }, displayID = 30972, resetTimer = 1200, questID = { 62332 } }; --Falric
	[174055] = { zoneID = 118, artID = { 123 }, x = 0.58168465, y = 0.8347093, overlay = { "0.58-0.83" }, displayID = 30973, resetTimer = 1200, questID = { 62333 } }; --Marwyn
	[174056] = { zoneID = 118, artID = { 123 }, x = 0.59104705, y = 0.723767, overlay = { "0.58-0.72","0.59-0.72" }, displayID = 30843, resetTimer = 1200, questID = { 62334 } }; --Forgemaster Garfrost
	[174057] = { zoneID = 118, artID = { 123 }, x = 0.4712406, y = 0.6592141, overlay = { "0.47-0.66","0.47-0.65" }, displayID = 30277, resetTimer = 1200, questID = { 62335 } }; --Scourgelord Tyrannus
	[174058] = { zoneID = 118, artID = { 123 }, x = 0.7061919, y = 0.3854165, overlay = { "0.70-0.38" }, displayID = 30226, resetTimer = 1200, questID = { 62336 } }; --Bronjahm <Godfather of Souls>
	[174059] = { zoneID = 118, artID = { 123 }, x = 0.6480345, y = 0.2210472, overlay = { "0.64-0.22","0.65-0.22","0.65-0.23" }, displayID = 29837, resetTimer = 1200, questID = { 62337 } }; --The Black Knight
	[174060] = { zoneID = 118, artID = { 123 }, x = 0.5394308, y = 0.4467787, overlay = { "0.54-0.44","0.53-0.44" }, displayID = 30857, resetTimer = 1200, questID = { 62338 } }; --Prince Keleseth
	[174061] = { zoneID = 118, artID = { 123 }, x = 0.52309144, y = 0.52551395, overlay = { "0.52-0.52" }, displayID = 26351, resetTimer = 1200, questID = { 62339 } }; --Ingvar the Plunderer
	[174062] = { zoneID = 118, artID = { 123 }, x = 0.57629585, y = 0.5593978, overlay = { "0.57-0.56","0.57-0.55" }, displayID = 27418, resetTimer = 1200, questID = { 62340 } }; --Skadi the Ruthless
	[174063] = { zoneID = 118, artID = { 123 }, x = 0.51173115, y = 0.7854619, overlay = { "0.51-0.78" }, displayID = 30893, resetTimer = 1200, questID = { 62341 } }; --Lady Deathwhisper
	[174064] = { zoneID = 118, artID = { 123 }, x = 0.57089347, y = 0.3052526, overlay = { "0.57-0.30" }, displayID = 30881, resetTimer = 1200, questID = { 62342 } }; --Professor Putricide
	[174065] = { zoneID = 118, artID = { 123 }, x = 0.49584413, y = 0.32262886, overlay = { "0.49-0.32" }, displayID = 31165, resetTimer = 1200, questID = { 62343 } }; --Blood Queen Lana'thel
	[174066] = { zoneID = 118, artID = { 123 }, x = 0.3655242, y = 0.676658, overlay = { "0.34-0.68","0.36-0.67" }, displayID = 16174, resetTimer = 1200, questID = { 62344 } }; --Patchwerk
	[174067] = { zoneID = 118, artID = { 123 }, x = 0.31540912, y = 0.70346075, overlay = { "0.31-0.70" }, displayID = 16590, resetTimer = 1200, questID = { 62345 } }; --Noth the Plaguebringer
	[32487] = { zoneID = 118, artID = { 123 }, x = 0.438, y = 0.578, overlay = { "0.44-0.55","0.44-0.54","0.44-0.50","0.44-0.53","0.44-0.60","0.45-0.61","0.45-0.49","0.45-0.51","0.45-0.62","0.45-0.63","0.45-0.64","0.46-0.49","0.46-0.65","0.46-0.48","0.47-0.47","0.47-0.46","0.48-0.45","0.48-0.42","0.49-0.43","0.49-0.42","0.50-0.41","0.50-0.40","0.51-0.39","0.52-0.41","0.54-0.38","0.54-0.41","0.55-0.41","0.56-0.40","0.57-0.40","0.57-0.41","0.59-0.41","0.59-0.40","0.60-0.41","0.61-0.41","0.62-0.42","0.64-0.45","0.65-0.47","0.65-0.48","0.65-0.51","0.65-0.50","0.65-0.49","0.66-0.52","0.66-0.54","0.66-0.53","0.66-0.55","0.67-0.56","0.67-0.57","0.67-0.58","0.68-0.60","0.68-0.61","0.68-0.62","0.68-0.69","0.68-0.64","0.68-0.65","0.68-0.68","0.68-0.67","0.69-0.67","0.69-0.63" }, displayID = 27979 }; --Putridus the Ancient
	[32495] = { zoneID = 118, artID = { 123 }, x = 0.284, y = 0.458, overlay = { "0.30-0.38","0.31-0.39","0.31-0.28","0.31-0.29","0.32-0.29","0.32-0.40","0.37-0.24","0.54-0.52","0.56-0.53","0.59-0.58","0.59-0.62","0.59-0.59" }, displayID = 67148 }; --Hildana Deathstealer
	[32501] = { zoneID = 118, artID = { 123 }, x = 0.312, y = 0.622, overlay = { "0.31-0.63","0.31-0.64","0.31-0.65","0.31-0.66","0.31-0.67","0.31-0.68","0.32-0.69","0.32-0.70","0.33-0.70","0.34-0.70","0.34-0.69","0.35-0.69","0.35-0.70","0.35-0.7","0.46-0.84","0.46-0.85","0.47-0.80","0.47-0.78","0.47-0.86","0.47-0.84","0.48-0.80","0.48-0.81","0.48-0.82","0.48-0.85","0.48-0.86","0.48-0.78","0.49-0.84","0.49-0.79","0.49-0.86","0.49-0.85","0.67-0.37","0.67-0.38","0.68-0.41","0.69-0.41","0.69-0.40","0.70-0.40","0.70-0.39","0.70-0.4","0.71-0.36","0.71-0.37","0.72-0.36","0.72-0.39","0.72-0.35","0.73-0.34","0.73-0.31","0.74-0.32","0.74-0.33" }, displayID = 27988 }; --High Thane Jorfus
	[32481] = { zoneID = 119, artID = { 124 }, x = 0.404, y = 0.59599996, overlay = { "0.40-0.58","0.41-0.68","0.41-0.69","0.42-0.73","0.43-0.52","0.43-0.50","0.44-0.69","0.44-0.68","0.46-0.55","0.52-0.72","0.54-0.51","0.54-0.50","0.55-0.52","0.56-0.65","0.57-0.65" }, displayID = 27975 }; --Aotona
	[32485] = { zoneID = 119, artID = { 124 }, x = 0.26, y = 0.48, overlay = { "0.26-0.47","0.27-0.48","0.27-0.47","0.3-0.44","0.30-0.39","0.32-0.33","0.33-0.34","0.33-0.32","0.36-0.3","0.37-0.28","0.46-0.41","0.46-0.42","0.47-0.43","0.47-0.41","0.47-0.44","0.48-0.43","0.48-0.44","0.48-0.41","0.49-0.44","0.50-0.42","0.50-0.43","0.50-0.81","0.51-0.42","0.51-0.43","0.52-0.42","0.52-0.84","0.54-0.83","0.56-0.80","0.57-0.81","0.58-0.82","0.60-0.83","0.62-0.82","0.63-0.79","0.64-0.79","0.65-0.78" }, displayID = 28052 }; --King Krush
	[32517] = { zoneID = 119, artID = { 124 }, x = 0.206, y = 0.7, overlay = { "0.21-0.70","0.21-0.68","0.30-0.66","0.31-0.66","0.35-0.30","0.35-0.31","0.36-0.3","0.51-0.81","0.58-0.21","0.58-0.22","0.66-0.79","0.67-0.78","0.70-0.71","0.71-0.71" }, displayID = 28010 }; --Loque'nahak
	[103154] = { zoneID = 120, artID = { 125 }, x = 0.33400002, y = 0.582, overlay = { "0.33-0.58" }, friendly = { "A","H" }, displayID = 70574 }; --Hati
	[32491] = { zoneID = 120, artID = { 125 }, x = 0.28, y = 0.65400004, overlay = { "0.33-0.65","0.30-0.64","0.27-0.66","0.27-0.60","0.26-0.56","0.27-0.52","0.29-0.48","0.31-0.46","0.31-0.45","0.35-0.4","0.37-0.39","0.39-0.40","0.4-0.44","0.4-0.49","0.38-0.51","0.37-0.56","0.36-0.60","0.34-0.65","0.28-0.44","0.28-0.4","0.27-0.36","0.28-0.33","0.29-0.33","0.35-0.31","0.33-0.31","0.31-0.32","0.36-0.29","0.38-0.28","0.41-0.27","0.44-0.26","0.45-0.25","0.48-0.25","0.49-0.25","0.50-0.25","0.51-0.27","0.52-0.27","0.53-0.31","0.50-0.35","0.51-0.33","0.45-0.36","0.47-0.35","0.44-0.38","0.44-0.4","0.45-0.42","0.47-0.46","0.49-0.49","0.49-0.50","0.49-0.52","0.47-0.53","0.44-0.56","0.41-0.6","0.39-0.61","0.36-0.63","0.42-0.57","0.27-0.47","0.38-0.65","0.40-0.63","0.42-0.61","0.44-0.61","0.47-0.64","0.47-0.65","0.47-0.68","0.46-0.71","0.44-0.74","0.43-0.76","0.43-0.78","0.43-0.79","0.41-0.82","0.37-0.85","0.33-0.80","0.35-0.77","0.37-0.76","0.37-0.73","0.37-0.69","0.37-0.67","0.38-0.84","0.34-0.84","0.33-0.82","0.35-0.85","0.27-0.62","0.27-0.69","0.25-0.71","0.25-0.74","0.26-0.77","0.28-0.78","0.29-0.79","0.31-0.79","0.35-0.67","0.35-0.69","0.36-0.71","0.35-0.74","0.34-0.41","0.33-0.44","0.28-0.42","0.27-0.37","0.46-0.44","0.37-0.53","0.36-0.57" }, displayID = 26711 }; --Time-Lost Proto-Drake
	[32500] = { zoneID = 120, artID = { 125 }, x = 0.378, y = 0.584, overlay = { "0.41-0.51","0.41-0.39","0.41-0.40","0.68-0.47" }, displayID = 27986 }; --Dirkee
	[32630] = { zoneID = 120, artID = { 125 }, x = 0.26, y = 0.73800004, overlay = { "0.26-0.41","0.27-0.71","0.27-0.45","0.27-0.59","0.27-0.60","0.27-0.61","0.27-0.70","0.27-0.7","0.28-0.65","0.28-0.69","0.28-0.80","0.29-0.66","0.29-0.67","0.30-0.68","0.30-0.65","0.31-0.69","0.31-0.66","0.32-0.66","0.34-0.66","0.35-0.34","0.35-0.66","0.36-0.64","0.36-0.67","0.36-0.68","0.36-0.69","0.36-0.71","0.36-0.72","0.36-0.73","0.36-0.80","0.37-0.79","0.37-0.62","0.38-0.60","0.38-0.32","0.38-0.83","0.39-0.57","0.40-0.48","0.40-0.65","0.40-0.52","0.40-0.54","0.40-0.84","0.41-0.70","0.42-0.59","0.43-0.58","0.44-0.31","0.45-0.61","0.48-0.40","0.48-0.66","0.5-0.68","0.50-0.70" }, displayID = 28110 }; --Vyragosa
	[35189] = { zoneID = 120, artID = { 125 }, x = 0.278, y = 0.504, overlay = { "0.30-0.64","0.46-0.64" }, displayID = 29673 }; --Skoll
	[32447] = { zoneID = 121, artID = { 126 }, x = 0.22799999, y = 0.828, overlay = { "0.28-0.82","0.29-0.76","0.29-0.81","0.29-0.82","0.29-0.75","0.40-0.53","0.40-0.55","0.40-0.58","0.40-0.59","0.40-0.62","0.40-0.64","0.40-0.61","0.42-0.70","0.45-0.58","0.45-0.60","0.46-0.76","0.47-0.78" }, displayID = 26589 }; --Zul'drak Sentinel
	[32471] = { zoneID = 121, artID = { 126 }, x = 0.144, y = 0.56200004, overlay = { "0.17-0.71","0.17-0.70","0.18-0.70","0.20-0.80","0.20-0.79","0.21-0.79","0.21-0.70","0.22-0.70","0.22-0.61","0.23-0.61","0.24-0.76","0.26-0.55","0.26-0.71","0.26-0.70","0.27-0.54" }, displayID = 25926 }; --Griegen
	[32475] = { zoneID = 121, artID = { 126 }, x = 0.52599996, y = 0.32, overlay = { "0.53-0.31","0.61-0.36","0.71-0.23","0.71-0.28","0.71-0.29","0.71-0.24","0.72-0.28","0.74-0.66","0.75-0.66","0.77-0.42","0.81-0.34","0.82-0.35" }, displayID = 27683 }; --Terror Spinner
	[33776] = { zoneID = 121, artID = { 126 }, x = 0.61, y = 0.634, overlay = { "0.61-0.61","0.61-0.62","0.63-0.42","0.63-0.43","0.67-0.77","0.69-0.48","0.77-0.7" }, displayID = 28871 }; --Gondria
	[32435] = { zoneID = 126, artID = { 131 }, x = 0.512, y = 0.314, overlay = { "0.52-0.31","0.52-0.32","0.53-0.33","0.54-0.28","0.55-0.33","0.55-0.30","0.56-0.3","0.57-0.30","0.57-0.31" }, displayID = 20763 }; --Vern
	[50053] = { zoneID = 198, artID = { 203,227 }, x = 0.592, y = 0.376, overlay = { "0.34-0.26","0.35-0.26","0.36-0.26","0.39-0.26","0.41-0.30","0.42-0.31","0.44-0.32","0.45-0.32","0.46-0.33","0.47-0.34","0.48-0.34","0.50-0.33","0.51-0.32","0.52-0.30","0.53-0.3","0.53-0.29","0.54-0.29","0.55-0.28","0.56-0.34","0.56-0.32","0.57-0.31","0.57-0.34","0.57-0.28","0.57-0.35","0.57-0.30","0.57-0.29","0.58-0.36","0.59-0.37" }, displayID = 36700 }; --Thartuk the Exile
	[50056] = { zoneID = 198, artID = { 203,227 }, x = 0.406, y = 0.814, overlay = { "0.37-0.72","0.37-0.73","0.37-0.74","0.37-0.75","0.37-0.76","0.37-0.78","0.38-0.77","0.38-0.79","0.38-0.83","0.39-0.78","0.39-0.79","0.39-0.82","0.4-0.82","0.4-0.83","0.40-0.80","0.40-0.81","0.40-0.79" }, displayID = 37307 }; --Garr
	[50057] = { zoneID = 198, artID = { 203,227 }, x = 0.67800003, y = 0.55, overlay = { "0.45-0.60","0.65-0.54","0.67-0.55" }, displayID = 36701 }; --Blazewing
	[50058] = { zoneID = 198, artID = { 203,227 }, x = 0.568, y = 0.754, overlay = { "0.52-0.83","0.53-0.82","0.54-0.8","0.55-0.76","0.56-0.75" }, displayID = 37282 }; --Terrorpene
	[54318] = { zoneID = 198, artID = { 203,227 }, x = 0.412, y = 0.54, overlay = { "0.27-0.51","0.28-0.52","0.29-0.52","0.3-0.51","0.30-0.51","0.32-0.51","0.33-0.52","0.34-0.53","0.35-0.54","0.36-0.53","0.37-0.54","0.38-0.54","0.39-0.54","0.40-0.53","0.41-0.54" }, displayID = 38748 }; --Ankha
	[54319] = { zoneID = 198, artID = { 203,227 }, x = 0.412, y = 0.548, overlay = { "0.27-0.51","0.28-0.52","0.29-0.52","0.3-0.51","0.30-0.51","0.31-0.51","0.32-0.51","0.33-0.52","0.34-0.53","0.34-0.54","0.35-0.54","0.36-0.54","0.37-0.54","0.38-0.54","0.38-0.55","0.39-0.54","0.39-0.53","0.40-0.53","0.40-0.54","0.41-0.54" }, displayID = 38749 }; --Magria
	[54320] = { zoneID = 198, artID = { 203,227 }, x = 0.28, y = 0.622, overlay = { "0.25-0.61","0.26-0.65","0.26-0.62","0.26-0.6","0.27-0.59","0.27-0.63","0.27-0.64","0.27-0.60","0.27-0.62","0.28-0.61","0.28-0.62" }, displayID = 38634 }; --Ban'thalos
	[3253] = { zoneID = 199, artID = { 204 }, x = 0.412, y = 0.67, displayID = 11096 }; --Silithid Harvester
	[5829] = { zoneID = 199, artID = { 204 }, x = 0.45400003, y = 0.43400002, displayID = 2713 }; --Snort the Heckler
	[5832] = { zoneID = 199, artID = { 204 }, x = 0.444, y = 0.774, overlay = { "0.44-0.8","0.44-0.80","0.46-0.79","0.46-0.78","0.48-0.74","0.49-0.79","0.49-0.80" }, displayID = 6085 }; --Thunderstomp
	[5834] = { zoneID = 199, artID = { 204 }, x = 0.42200002, y = 0.53400004, overlay = { "0.42-0.54","0.43-0.54","0.43-0.56","0.43-0.57","0.43-0.58","0.44-0.56","0.44-0.59","0.45-0.58","0.46-0.57","0.46-0.55" }, displayID = 2702 }; --Azzere the Skyblade
	[5847] = { zoneID = 199, artID = { 204 }, x = 0.47, y = 0.886, friendly = { "A" }, displayID = 4595 }; --Heggin Stonewhisker
	[5848] = { zoneID = 199, artID = { 204 }, x = 0.474, y = 0.85800004, friendly = { "A" }, displayID = 4597 }; --Malgin Barleybrew
	[5849] = { zoneID = 199, artID = { 204 }, x = 0.478, y = 0.88199997, friendly = { "A" }, displayID = 4596 }; --Digger Flameforge
	[5851] = { zoneID = 199, artID = { 204 }, x = 0.496, y = 0.894, friendly = { "A" }, displayID = 4598 }; --Captain Gerogg Hammertoe
	[5859] = { zoneID = 199, artID = { 204 }, x = 0.404, y = 0.83, overlay = { "0.41-0.84","0.41-0.85","0.43-0.84" }, displayID = 6114 }; --Hagg Taurenbane
	[5863] = { zoneID = 199, artID = { 204 }, x = 0.42, y = 0.426, overlay = { "0.44-0.42" }, displayID = 6116 }; --Geopriest Gukk'rok
	[5864] = { zoneID = 199, artID = { 204 }, x = 0.38599998, y = 0.33400002, displayID = 6117 }; --Swinegart Spearhide
	[49913] = { zoneID = 201, artID = { 206 }, x = 0.616, y = 0.754, overlay = { "0.56-0.77","0.57-0.80","0.59-0.75","0.59-0.76","0.6-0.76","0.60-0.70","0.60-0.69","0.61-0.75" }, displayID = 36660 }; --Lady La-La
	[51071] = { zoneID = {
				[203] = { x = 0.684, y = 0.73800004, overlay = { "0.68-0.73" } };
				[205] = { x = 0.552, y = 0.73800004, overlay = { "0.55-0.73" } };
			  }, friendly = { "A" }, displayID = 4693 }; --null
	[51079] = { zoneID = 203, artID = { 208 }, x = 0.66800004, y = 0.696, overlay = { "0.66-0.69" }, friendly = { "H" }, displayID = 30103 }; --Captain Foulwind
	[50005] = { zoneID = {
				[204] = { x = 0.42200002, y = 0.76, overlay = { "0.39-0.71","0.40-0.73","0.41-0.76","0.41-0.73","0.42-0.76" } };
				[205] = { x = 0.67, y = 0.432, overlay = { "0.37-0.66","0.39-0.68","0.39-0.66","0.44-0.49","0.44-0.50","0.46-0.48","0.46-0.49","0.56-0.82","0.57-0.80","0.57-0.83","0.58-0.81","0.65-0.43","0.66-0.44","0.67-0.43" } };
			  }, displayID = 37308 }; --null
	[50009] = { zoneID = 204, artID = { 209 }, x = 0.774, y = 0.268, overlay = { "0.63-0.30","0.63-0.25","0.63-0.32","0.64-0.23","0.64-0.22","0.65-0.20","0.67-0.19","0.68-0.39","0.68-0.18","0.69-0.17","0.69-0.40","0.70-0.18","0.71-0.18","0.73-0.2","0.74-0.20","0.75-0.36","0.77-0.25","0.77-0.26","0.77-0.29","0.77-0.31" }, displayID = 37338 }; --Mobus
	[50050] = { zoneID = 204, artID = { 209 }, x = 0.51, y = 0.322, overlay = { "0.41-0.32","0.46-0.29","0.48-0.27","0.48-0.34","0.48-0.26","0.51-0.32" }, displayID = 37335 }; --Shok'sharak
	[50051] = { zoneID = 204, artID = { 209 }, x = 0.314, y = 0.806, overlay = { "0.12-0.82","0.15-0.77","0.15-0.87","0.19-0.77","0.2-0.58","0.20-0.68","0.22-0.65","0.24-0.71","0.24-0.80","0.26-0.81","0.28-0.82","0.31-0.78","0.31-0.80" }, displayID = 37396 }; --Ghostcrawler
	[50052] = { zoneID = 205, artID = { 210 }, x = 0.576, y = 0.698, overlay = { "0.56-0.7","0.56-0.71","0.56-0.70","0.57-0.69" }, displayID = 36699 }; --Burgy Blackheart
	[49822] = { zoneID = 207, artID = { 212 }, x = 0.612, y = 0.22600001, overlay = { "0.61-0.22" }, displayID = 36636 }; --Jadefang
	[50059] = { zoneID = 207, artID = { 212 }, x = 0.458, y = 0.84199995, overlay = { "0.32-0.76","0.37-0.79","0.37-0.81","0.38-0.83","0.39-0.83","0.42-0.87","0.43-0.86","0.43-0.87","0.45-0.84" }, displayID = 37364 }; --Golgarok
	[50060] = { zoneID = 207, artID = { 212 }, x = 0.552, y = 0.244, overlay = { "0.54-0.25","0.54-0.26","0.55-0.24","0.55-0.25" }, displayID = 36703 }; --Terborus
	[50061] = { zoneID = 207, artID = { 212 }, x = 0.58599997, y = 0.512, overlay = { "0.40-0.52","0.40-0.55","0.40-0.47","0.40-0.57","0.41-0.45","0.41-0.58","0.42-0.43","0.42-0.6","0.42-0.42","0.42-0.41","0.43-0.61","0.43-0.40","0.44-0.62","0.44-0.63","0.45-0.63","0.45-0.39","0.46-0.64","0.46-0.38","0.46-0.39","0.47-0.38","0.47-0.65","0.49-0.38","0.50-0.65","0.52-0.64","0.53-0.38","0.53-0.64","0.53-0.39","0.54-0.4","0.55-0.61","0.55-0.43","0.56-0.42","0.56-0.59","0.56-0.60","0.56-0.6","0.57-0.58","0.57-0.44","0.57-0.45","0.57-0.56","0.57-0.57","0.58-0.56","0.58-0.51" }, displayID = 32229 }; --Xariona
	[50062] = { zoneID = 207, artID = { 212 }, x = 0.66, y = 0.644, overlay = { "0.31-0.42","0.35-0.42","0.39-0.48","0.41-0.82","0.42-0.46","0.42-0.58","0.43-0.48","0.43-0.60","0.46-0.44","0.47-0.57","0.47-0.59","0.51-0.42","0.60-0.26","0.61-0.26","0.61-0.27","0.64-0.19","0.66-0.64" }, displayID = 37149 }; --Aeonaxx
	[108715] = { zoneID = 210, artID = { 215 }, x = 0.39400002, y = 0.638, overlay = { "0.33-0.62","0.34-0.67","0.34-0.66","0.35-0.61","0.35-0.67","0.35-0.69","0.35-0.68","0.36-0.68","0.36-0.62","0.36-0.61","0.36-0.67","0.36-0.60","0.36-0.64","0.37-0.60","0.37-0.63","0.37-0.62","0.37-0.66","0.37-0.67","0.37-0.64","0.37-0.69","0.37-0.7","0.38-0.63","0.38-0.65","0.38-0.66","0.38-0.70","0.38-0.67","0.38-0.68","0.39-0.67","0.39-0.63" }, displayID = 70668 }; --Ol' Eary
	[14490] = { zoneID = 210, artID = { 215 }, x = 0.412, y = 0.71800005, displayID = 14528 }; --Rippa
	[14491] = { zoneID = 210, artID = { 215 }, x = 0.48, y = 0.58, overlay = { "0.48-0.57","0.49-0.56","0.50-0.55","0.51-0.54","0.51-0.53","0.52-0.53","0.53-0.53","0.54-0.52","0.54-0.51","0.55-0.51","0.56-0.52","0.57-0.49","0.58-0.47" }, displayID = 3186 }; --Kurmokk
	[14492] = { zoneID = 210, artID = { 215 }, x = 0.53, y = 0.276, displayID = 7232 }; --Verifonix
	[1552] = { zoneID = 210, artID = { 215 }, x = 0.67800003, y = 0.252, overlay = { "0.68-0.25" }, displayID = 12342 }; --Scale Belly
	[2541] = { zoneID = 210, artID = { 215 }, x = 0.432, y = 0.496, displayID = 4910 }; --Lord Sakrasis
	[10080] = { zoneID = 219, artID = { 230 }, x = 0.52, y = 0.41, displayID = 9291 }; --Sandarr Dunereaver
	[10081] = { zoneID = 219, artID = { 230 }, x = 0.362, y = 0.178, displayID = 9292 }; --Dustwraith
	[10082] = { zoneID = 219, artID = { 230 }, x = 0.53, y = 0.4, displayID = 9293 }; --Zerillis
	[6228] = { zoneID = 229, artID = { 240 }, x = 0.28, y = 0.52, displayID = 6669 }; --Dark Iron Ambassador (GNOME)
	[11467] = { zoneID = 237, artID = { 248 }, x = 0.32, y = 0.28, displayID = 11250 }; --Tsu'zee
	[14506] = { zoneID = 238, artID = { 249 }, x = 0.38, y = 0.59, friendly = { "A" }, displayID = 14556 }; --Lord Hel'nurath
	[50085] = { zoneID = 241, artID = { 338,252 }, x = 0.58, y = 0.338, overlay = { "0.57-0.33","0.58-0.33" }, displayID = 36711 }; --Overlord Sunderfury
	[50086] = { zoneID = 241, artID = { 338,252 }, x = 0.51, y = 0.824, overlay = { "0.50-0.82","0.51-0.82" }, displayID = 36714 }; --Tarvus the Vile
	[50089] = { zoneID = 241, artID = { 338,252 }, x = 0.598, y = 0.068, overlay = { "0.50-0.08","0.50-0.07","0.51-0.07","0.52-0.07","0.52-0.10","0.52-0.08","0.52-0.09","0.53-0.07","0.53-0.08","0.53-0.11","0.53-0.12","0.53-0.10","0.54-0.12","0.54-0.11","0.55-0.11","0.56-0.11","0.56-0.12","0.56-0.08","0.56-0.09","0.57-0.07","0.57-0.10","0.58-0.06","0.58-0.09","0.59-0.06" }, displayID = 24301 }; --Julak-Doom
	[50138] = { zoneID = 241, artID = { 338,252 }, x = 0.65599996, y = 0.606, overlay = { "0.49-0.74","0.49-0.75","0.53-0.53","0.54-0.54","0.54-0.76","0.54-0.75","0.58-0.63","0.58-0.64","0.59-0.43","0.59-0.44","0.65-0.60" }, displayID = 36726 }; --Karoma
	[50159] = { zoneID = 241, artID = { 338,252 }, x = 0.688, y = 0.258, overlay = { "0.38-0.53","0.42-0.38","0.68-0.25" }, displayID = 37352 }; --Sambas
	[8923] = { zoneID = 243, artID = { 254 }, x = 0.5, y = 0.37, displayID = 8270 }; --Panzor the Invincible
	[50063] = { zoneID = 249, artID = { 260,289 }, x = 0.38, y = 0.606, overlay = { "0.38-0.60" }, displayID = 34573 }; --Akma'hat
	[50064] = { zoneID = 249, artID = { 260,289 }, x = 0.708, y = 0.742, overlay = { "0.58-0.82","0.58-0.61","0.66-0.68","0.70-0.74" }, displayID = 36707 }; --Cyrus the Black
	[50065] = { zoneID = 249, artID = { 260,289 }, x = 0.45200002, y = 0.42200002, overlay = { "0.44-0.42","0.44-0.41","0.45-0.42" }, displayID = 37353 }; --Armagedillo
	[50154] = { zoneID = 249, artID = { 260,289 }, x = 0.538, y = 0.19399999, overlay = { "0.44-0.10","0.44-0.11","0.44-0.21","0.44-0.22","0.44-0.1","0.47-0.18","0.48-0.18","0.5-0.23","0.50-0.19","0.50-0.21","0.50-0.20","0.50-0.23","0.53-0.19" }, displayID = 36728 }; --Madexx
	[51401] = { zoneID = 249, artID = { 260,289 }, x = 0.532, y = 0.198, overlay = { "0.44-0.10","0.44-0.21","0.47-0.19","0.50-0.23","0.50-0.20","0.50-0.19","0.50-0.24","0.53-0.19" }, displayID = 37360 }; --Madexx
	[51402] = { zoneID = 249, artID = { 260,289 }, x = 0.532, y = 0.19399999, overlay = { "0.44-0.10","0.44-0.22","0.44-0.21","0.50-0.20","0.53-0.19" }, displayID = 37362 }; --Madexx
	[51403] = { zoneID = 249, artID = { 260,289 }, x = 0.53400004, y = 0.19, overlay = { "0.47-0.18","0.51-0.20","0.53-0.19" }, displayID = 37359 }; --Madexx
	[51404] = { zoneID = 249, artID = { 260,289 }, x = 0.532, y = 0.198, overlay = { "0.44-0.10","0.44-0.22","0.44-0.1","0.44-0.21","0.47-0.18","0.47-0.17","0.5-0.20","0.5-0.24","0.50-0.19","0.50-0.23","0.51-0.19","0.53-0.19" }, displayID = 37361 }; --Madexx
	[10263] = { zoneID = 251, artID = { 262 }, x = 0.66, y = 0.41, displayID = 5047 }; --Burning Felguard
	[10376] = { zoneID = 251, artID = { 262 }, x = 0.57, y = 0.78, displayID = 9755 }; --Crystal Fang
	[9217] = { zoneID = 252, artID = { 263 }, x = 0.41, y = 0.58, displayID = 11578 }; --Spirestone Lord Magus
	[9218] = { zoneID = 252, artID = { 263 }, x = 0.35, y = 0.56, displayID = 11576 }; --Spirestone Battle Lord
	[9219] = { zoneID = 252, artID = { 263 }, x = 0.512, y = 0.56700003, displayID = 11574 }; --Spirestone Butcher
	[9596] = { zoneID = 252, artID = { 263 }, x = 0.479, y = 0.64199996, displayID = 9668 }; --Bannok Grimaxe
	[9718] = { zoneID = 254, artID = { 265 }, x = 0.35, y = 0.74, displayID = 11809 }; --Ghok Bashguud (REVISAR MONTAÑA ROCANEGRA INFER)
	[9736] = { zoneID = 255, artID = { 266 }, x = 0.53900003, y = 0.84400004, overlay = { "0.55-0.84" }, displayID = 9738 }; --Quartermaster Zigris
	[56080] = { zoneID = 274, artID = { 285 }, x = 0.612, y = 0.411, friendly = { "A","H" }, displayID = 39299 }; --Little Samras
	[56081] = { zoneID = 274, artID = { 285 }, x = 0.48, y = 0.643, friendly = { "A","H" }, displayID = 5027 }; --Optimistic Benj
	[5912] = { zoneID = 279, artID = { 290 }, x = 0.72, y = 0.66, displayID = 1267 }; --Deviate Faerie Dragon
	[12237] = { zoneID = 280, artID = { 291 }, x = 0.25, y = 0.79, displayID = 9014 }; --Meshlok the Harvester
	[75590] = { zoneID = 301, artID = { 313 }, x = 0.1225, y = 0.3341, displayID = 52785 }; --Enormous Bullfrog
	[3872] = { zoneID = 316, artID = { 328 }, x = 0.68, y = 0.6, displayID = 3224 }; --Deathsworn Captain
	[10393] = { zoneID = 317, artID = { 329 }, x = 0.56, y = 0.66, displayID = 2606 }; --Skul
	[10558] = { zoneID = {
				[317] = { x = 0.83, y = 0.23 };
				[318] = { x = 0.605, y = 0.313 };
			  }, displayID = 10482 }; --null
	[10809] = { zoneID = 318, artID = { 330 }, x = 0.67, y = 0.3, displayID = 7856 }; --Stonespine
	[50815] = { zoneID = 338, artID = { 350 }, x = 0.374, y = 0.35599998, overlay = { "0.33-0.52","0.36-0.34","0.37-0.35" }, displayID = 19607 }; --Skarr
	[50959] = { zoneID = 338, artID = { 350 }, x = 0.376, y = 0.354, overlay = { "0.33-0.52","0.33-0.53","0.36-0.34","0.37-0.35" }, displayID = 88834 }; --Karkin
	[54321] = { zoneID = 338, artID = { 350 }, x = 0.606, y = 0.59599996, overlay = { "0.60-0.58","0.60-0.60","0.60-0.59" }, displayID = 38780 }; --Solix
	[54322] = { zoneID = 338, artID = { 350 }, x = 0.732, y = 0.59400004, overlay = { "0.68-0.71","0.68-0.72","0.69-0.69","0.73-0.58","0.73-0.59" }, displayID = 38424 }; --Deth'tilac
	[54323] = { zoneID = 338, artID = { 350 }, x = 0.316, y = 0.568, overlay = { "0.26-0.66","0.27-0.62","0.28-0.61","0.29-0.73","0.29-0.55","0.30-0.58","0.30-0.56","0.31-0.57","0.31-0.56" }, displayID = 38453 }; --Kirix
	[54324] = { zoneID = 338, artID = { 350 }, x = 0.2, y = 0.508, overlay = { "0.18-0.52","0.19-0.47","0.19-0.48","0.19-0.49","0.2-0.50" }, displayID = 38779 }; --Skitterflame
	[54338] = { zoneID = 338, artID = { 350 }, x = 0.566, y = 0.414, overlay = { "0.52-0.41","0.53-0.39","0.54-0.39","0.54-0.38","0.54-0.41","0.55-0.38","0.56-0.41" }, displayID = 38426 }; --Anthriss
	[16179] = { zoneID = 351, artID = { 363 }, x = 0.59599996, y = 0.287, displayID = 15938 }; --Hyakiss the Lurker
	[16180] = { zoneID = 351, artID = { 363 }, x = 0.59599996, y = 0.287, displayID = 16053 }; --Shadikith the Glider
	[16181] = { zoneID = 351, artID = { 363 }, x = 0.59599996, y = 0.287, displayID = 16054 }; --Rokad the Ravager
	[50338] = { zoneID = 371, artID = { 383 }, x = 0.44, y = 0.758, overlay = { "0.43-0.76","0.43-0.72","0.43-0.73","0.44-0.74","0.44-0.75" }, displayID = 44274 }; --Kor'nas Nightsavage
	[50350] = { zoneID = 371, artID = { 383 }, x = 0.482, y = 0.206, overlay = { "0.40-0.15","0.42-0.17","0.42-0.16","0.46-0.16","0.48-0.18","0.48-0.20" }, displayID = 44346 }; --Morgrinn Crackfang
	[50363] = { zoneID = 371, artID = { 383 }, x = 0.396, y = 0.626, overlay = { "0.39-0.62" }, displayID = 44394 }; --Krax'ik
	[50750] = { zoneID = 371, artID = { 383 }, x = 0.336, y = 0.508, overlay = { "0.33-0.50" }, displayID = 44203 }; --Aethis
	[50782] = { zoneID = 371, artID = { 383 }, x = 0.64599997, y = 0.742, overlay = { "0.64-0.74" }, displayID = 44255 }; --Sarnak
	[50808] = { zoneID = 371, artID = { 383 }, x = 0.574, y = 0.714, overlay = { "0.57-0.71" }, displayID = 44362 }; --Urobi the Walker
	[50823] = { zoneID = 371, artID = { 383 }, x = 0.426, y = 0.38799998, overlay = { "0.42-0.38" }, displayID = 44236 }; --Mister Ferocious
	[51078] = { zoneID = 371, artID = { 383 }, x = 0.564, y = 0.48, overlay = { "0.52-0.44","0.53-0.49","0.53-0.45","0.54-0.42","0.56-0.48" }, displayID = 43977 }; --Ferdinand
	[69768] = { zoneID = {
				[371] = { x = 0.542, y = 0.276, overlay = { "0.43-0.17","0.44-0.17","0.45-0.17","0.46-0.18","0.47-0.21","0.48-0.21","0.49-0.20","0.49-0.2","0.50-0.36","0.51-0.2","0.52-0.19","0.52-0.21","0.52-0.23","0.52-0.32","0.52-0.20","0.53-0.19","0.53-0.34","0.53-0.30","0.53-0.29","0.54-0.27" } };
				[379] = { x = 0.746, y = 0.68, overlay = { "0.64-0.64","0.66-0.65","0.67-0.81","0.67-0.79","0.68-0.64","0.69-0.65","0.69-0.76","0.70-0.75","0.70-0.66","0.71-0.74","0.72-0.66","0.72-0.70","0.73-0.69","0.73-0.68","0.74-0.67","0.74-0.68" } };
				[388] = { x = 0.49400002, y = 0.73, overlay = { "0.36-0.85","0.37-0.86","0.37-0.84","0.38-0.87","0.38-0.83","0.38-0.82","0.39-0.82","0.39-0.81","0.39-0.88","0.4-0.80","0.40-0.77","0.40-0.89","0.42-0.90","0.43-0.90","0.44-0.74","0.46-0.89","0.47-0.74","0.48-0.74","0.48-0.86","0.48-0.84","0.49-0.73" } };
				[418] = { x = 0.578, y = 0.292, overlay = { "0.36-0.60","0.37-0.62","0.38-0.65","0.38-0.66","0.39-0.63","0.57-0.29" } };
				[422] = { x = 0.576, y = 0.66, overlay = { "0.37-0.48","0.37-0.49","0.38-0.48","0.39-0.46","0.39-0.49","0.41-0.50","0.43-0.51","0.45-0.56","0.45-0.57","0.46-0.58","0.46-0.59","0.47-0.60","0.48-0.61","0.49-0.62","0.49-0.63","0.5-0.64","0.53-0.66","0.56-0.66","0.57-0.66" } };
			  }, displayID = 47673 }; --null
	[69769] = { zoneID = {
				[371] = { x = 0.52599996, y = 0.19, overlay = { "0.52-0.18","0.52-0.19" } };
				[379] = { x = 0.75, y = 0.676, overlay = { "0.75-0.67" } };
				[388] = { x = 0.366, y = 0.856, overlay = { "0.36-0.85" } };
				[418] = { x = 0.398, y = 0.65599996, overlay = { "0.38-0.67","0.39-0.65" } };
				[422] = { x = 0.47599998, y = 0.616, overlay = { "0.47-0.61" } };
			  }, displayID = 47681 }; --null
	[69841] = { zoneID = {
				[371] = { x = 0.52599996, y = 0.19, overlay = { "0.52-0.18","0.52-0.19" } };
				[379] = { x = 0.75, y = 0.676, overlay = { "0.75-0.67" } };
				[388] = { x = 0.366, y = 0.856, overlay = { "0.36-0.85" } };
				[422] = { x = 0.474, y = 0.616, overlay = { "0.47-0.61" } };
			  }, displayID = 47681 }; --null
	[69842] = { zoneID = {
				[371] = { x = 0.52599996, y = 0.19, overlay = { "0.52-0.18","0.52-0.19" } };
				[379] = { x = 0.75, y = 0.676, overlay = { "0.75-0.67" } };
				[388] = { x = 0.366, y = 0.856, overlay = { "0.36-0.85" } };
				[422] = { x = 0.47599998, y = 0.616, overlay = { "0.47-0.61" } };
			  }, displayID = 47681 }; --null
	[70323] = { zoneID = {
				[371] = { x = 0.566, y = 0.218, overlay = { "0.50-0.20","0.55-0.21","0.56-0.21" } };
				[376] = { x = 0.372, y = 0.706, overlay = { "0.37-0.70" } };
				[379] = { x = 0.734, y = 0.864, overlay = { "0.33-0.44","0.72-0.85","0.73-0.86" } };
				[388] = { x = 0.35599998, y = 0.53, overlay = { "0.35-0.51","0.35-0.53" } };
				[418] = { x = 0.346, y = 0.342, overlay = { "0.32-0.34","0.33-0.33","0.34-0.34" } };
				[422] = { x = 0.264, y = 0.16, overlay = { "0.26-0.16" } };
				[554] = { x = 0.47599998, y = 0.548, overlay = { "0.47-0.55","0.47-0.54" } };
			  }, displayID = 48006 }; --null
	[50339] = { zoneID = 376, artID = { 388 }, x = 0.37, y = 0.256, overlay = { "0.36-0.25","0.37-0.25" }, displayID = 44282 }; --Sulik'shor
	[50351] = { zoneID = 376, artID = { 388 }, x = 0.186, y = 0.77599996, overlay = { "0.18-0.77" }, displayID = 44347 }; --Jonn-Dar
	[50364] = { zoneID = 376, artID = { 388 }, x = 0.128, y = 0.498, overlay = { "0.08-0.59","0.08-0.56","0.08-0.57","0.08-0.60","0.08-0.50","0.09-0.59","0.09-0.47","0.09-0.51","0.09-0.54","0.09-0.58","0.09-0.45","0.09-0.48","0.09-0.50","0.09-0.53","0.09-0.57","0.09-0.52","0.09-0.56","0.1-0.49","0.10-0.47","0.10-0.49","0.11-0.56","0.11-0.55","0.11-0.58","0.11-0.52","0.11-0.54","0.12-0.50","0.12-0.53","0.12-0.48","0.12-0.49" }, displayID = 44395 }; --Nal'lak the Ripper
	[50766] = { zoneID = 376, artID = { 388 }, x = 0.602, y = 0.39200002, overlay = { "0.52-0.28","0.54-0.31","0.54-0.32","0.54-0.36","0.57-0.33","0.58-0.38","0.59-0.38","0.59-0.37","0.60-0.39" }, displayID = 44222 }; --Sele'na
	[50783] = { zoneID = 376, artID = { 388 }, x = 0.758, y = 0.468, overlay = { "0.67-0.59","0.67-0.6","0.68-0.58","0.68-0.57","0.69-0.52","0.69-0.56","0.69-0.54","0.69-0.53","0.70-0.53","0.70-0.52","0.71-0.52","0.71-0.51","0.72-0.52","0.73-0.53","0.73-0.52","0.74-0.50","0.74-0.49","0.74-0.48","0.75-0.48","0.75-0.46" }, displayID = 44267 }; --Salyin Warscout
	[50811] = { zoneID = 376, artID = { 388 }, x = 0.886, y = 0.18, overlay = { "0.88-0.18" }, displayID = 44370 }; --Nasra Spothide
	[50828] = { zoneID = 376, artID = { 388 }, x = 0.19, y = 0.35799998, overlay = { "0.13-0.38","0.14-0.38","0.15-0.32","0.15-0.31","0.16-0.35","0.16-0.40","0.16-0.41","0.19-0.35" }, displayID = 44242 }; --Bonobos
	[51059] = { zoneID = 376, artID = { 388 }, x = 0.396, y = 0.576, overlay = { "0.32-0.62","0.34-0.59","0.37-0.60","0.38-0.60","0.39-0.57" }, displayID = 44161 }; --Blackhoof
	[62346] = { zoneID = 376, artID = { 388 }, x = 0.71599996, y = 0.644, overlay = { "0.71-0.64" }, displayID = 42439, questReset = true, nameplate = true, questID = { 32098 } }; --Galleon
	[50332] = { zoneID = 379, artID = { 391 }, x = 0.518, y = 0.794, overlay = { "0.47-0.81","0.47-0.80","0.48-0.80","0.48-0.8","0.49-0.80","0.5-0.80","0.50-0.80","0.51-0.79","0.51-0.80" }, displayID = 44163 }; --Korda Torros
	[50341] = { zoneID = 379, artID = { 391 }, x = 0.55799997, y = 0.43400002, overlay = { "0.55-0.43","0.55-0.44" }, displayID = 44283 }; --Borginn Darkfist
	[50354] = { zoneID = 379, artID = { 391 }, x = 0.592, y = 0.73800004, overlay = { "0.57-0.75","0.59-0.73" }, displayID = 44349 }; --Havak
	[50733] = { zoneID = 379, artID = { 391 }, x = 0.366, y = 0.796, overlay = { "0.36-0.79" }, displayID = 44397 }; --Ski'thik
	[50769] = { zoneID = 379, artID = { 391 }, x = 0.744, y = 0.792, overlay = { "0.73-0.76","0.73-0.77","0.74-0.79" }, displayID = 44226 }; --Zai the Outcast
	[50789] = { zoneID = 379, artID = { 391 }, x = 0.638, y = 0.138, overlay = { "0.63-0.13" }, displayID = 44269 }; --Nessos the Oracle
	[50817] = { zoneID = 379, artID = { 391 }, x = 0.408, y = 0.42400002, overlay = { "0.40-0.42" }, displayID = 44372 }; --Ahone the Wanderer
	[50831] = { zoneID = 379, artID = { 391 }, x = 0.472, y = 0.63, overlay = { "0.44-0.63","0.44-0.65","0.46-0.61","0.47-0.63" }, displayID = 44246 }; --Scritch
	[60491] = { zoneID = 379, artID = { 391 }, x = 0.544, y = 0.632, overlay = { "0.54-0.63" }, displayID = 41448, questReset = true, nameplate = true, questID = { 32099 } }; --Sha of Anger
	[50333] = { zoneID = 388, artID = { 400 }, x = 0.67800003, y = 0.508, overlay = { "0.64-0.49","0.64-0.50","0.65-0.50","0.66-0.50","0.66-0.44","0.66-0.51","0.66-0.52","0.67-0.50","0.67-0.47","0.67-0.45","0.67-0.48","0.67-0.5","0.67-0.49" }, displayID = 44164 }; --Lon the Bull
	[50344] = { zoneID = 388, artID = { 400 }, x = 0.54, y = 0.634, overlay = { "0.53-0.63","0.54-0.63" }, displayID = 44284 }; --Norlaxx
	[50355] = { zoneID = 388, artID = { 400 }, x = 0.63, y = 0.35599998, overlay = { "0.62-0.35","0.63-0.35" }, displayID = 44350 }; --Kah'tir
	[50734] = { zoneID = 388, artID = { 400 }, x = 0.478, y = 0.886, overlay = { "0.41-0.78","0.42-0.78","0.46-0.74","0.47-0.84","0.47-0.88" }, displayID = 44398 }; --Lith'ik the Stalker
	[50772] = { zoneID = 388, artID = { 400 }, x = 0.688, y = 0.89, overlay = { "0.65-0.87","0.66-0.86","0.67-0.87","0.68-0.89" }, displayID = 44228 }; --Eshelon
	[50791] = { zoneID = 388, artID = { 400 }, x = 0.592, y = 0.856, overlay = { "0.59-0.85" }, displayID = 44270 }; --Siltriss the Sharpener
	[50820] = { zoneID = 388, artID = { 400 }, x = 0.32, y = 0.618, overlay = { "0.32-0.61" }, displayID = 44373 }; --Yul Wildpaw
	[50832] = { zoneID = 388, artID = { 400 }, x = 0.676, y = 0.746, overlay = { "0.67-0.74" }, displayID = 44249 }; --The Yowler
	[50336] = { zoneID = 390, artID = { 402 }, x = 0.878, y = 0.44599998, overlay = { "0.87-0.44" }, displayID = 44159 }; --Yorik Sharpeye
	[50349] = { zoneID = 390, artID = { 402 }, x = 0.15, y = 0.35599998, overlay = { "0.15-0.35" }, displayID = 44286 }; --Kang the Soul Thief
	[50359] = { zoneID = 390, artID = { 402 }, x = 0.398, y = 0.25, overlay = { "0.39-0.25","0.39-0.24" }, displayID = 44352 }; --Urgolax
	[50749] = { zoneID = 390, artID = { 402 }, x = 0.14, y = 0.58599997, overlay = { "0.14-0.58" }, displayID = 44400 }; --Kal'tik the Blight
	[50780] = { zoneID = 390, artID = { 402 }, x = 0.696, y = 0.308, overlay = { "0.69-0.30","0.69-0.31" }, displayID = 44230 }; --Sahn Tidehunter
	[50806] = { zoneID = 390, artID = { 402 }, x = 0.44, y = 0.518, overlay = { "0.35-0.61","0.35-0.60","0.35-0.59","0.36-0.59","0.36-0.58","0.37-0.57","0.37-0.55","0.38-0.55","0.39-0.53","0.40-0.53","0.41-0.53","0.42-0.53","0.43-0.51","0.44-0.51" }, displayID = 44272 }; --Moldo One-Eye
	[50822] = { zoneID = 390, artID = { 402 }, x = 0.426, y = 0.69, overlay = { "0.42-0.69" }, displayID = 44375 }; --Ai-Ran the Shifting Cloud
	[50840] = { zoneID = 390, artID = { 402 }, x = 0.31, y = 0.916, overlay = { "0.30-0.91","0.31-0.91" }, displayID = 44251 }; --Major Nanners
	[58474] = { zoneID = 390, artID = { 402 }, x = 0.27, y = 0.146, overlay = { "0.27-0.14" }, displayID = 43640 }; --Bloodtip
	[58768] = { zoneID = 390, artID = { 402 }, x = 0.466, y = 0.59, overlay = { "0.46-0.59" }, displayID = 44455 }; --Cracklefang
	[58769] = { zoneID = 390, artID = { 402 }, x = 0.376, y = 0.51, overlay = { "0.34-0.50","0.37-0.51","0.37-0.50" }, displayID = 42333 }; --Vicejaw
	[58771] = { zoneID = 390, artID = { 402 }, x = 0.666, y = 0.398, overlay = { "0.66-0.38","0.66-0.39" }, displayID = 40357 }; --Quid
	[58778] = { zoneID = 390, artID = { 402 }, x = 0.35, y = 0.89599997, overlay = { "0.35-0.89" }, displayID = 42736 }; --Aetha
	[58817] = { zoneID = 390, artID = { 402 }, x = 0.474, y = 0.66199994, overlay = { "0.47-0.66" }, displayID = 40299 }; --Spirit of Lao-Fe
	[58949] = { zoneID = 390, artID = { 402 }, x = 0.168, y = 0.49, overlay = { "0.16-0.48","0.16-0.49" }, displayID = 45743 }; --Bai-Jin the Butcher
	[62880] = { zoneID = 390, artID = { 402 }, x = 0.27, y = 0.136, overlay = { "0.27-0.13" }, displayID = 45741 }; --Gochao the Ironfist
	[63101] = { zoneID = 390, artID = { 402 }, x = 0.308, y = 0.598, overlay = { "0.26-0.51","0.26-0.52","0.27-0.53","0.27-0.54","0.28-0.55","0.28-0.56","0.29-0.57","0.3-0.57","0.30-0.57","0.30-0.58","0.30-0.59" }, displayID = 45786 }; --General Temuja
	[63240] = { zoneID = 390, artID = { 402 }, x = 0.306, y = 0.786, overlay = { "0.30-0.78" }, displayID = 45785 }; --Shadowmaster Sydow
	[63510] = { zoneID = 390, artID = { 402 }, x = 0.45200002, y = 0.76199996, overlay = { "0.45-0.76" }, displayID = 43097 }; --Wulon
	[63691] = { zoneID = 390, artID = { 402 }, x = 0.268, y = 0.158, overlay = { "0.26-0.15" }, displayID = 45739 }; --Huo-Shuang
	[63695] = { zoneID = 390, artID = { 402 }, x = 0.288, y = 0.428, overlay = { "0.28-0.43","0.28-0.42" }, displayID = 45745 }; --Baolai the Immolator
	[63977] = { zoneID = 390, artID = { 402 }, x = 0.081999995, y = 0.34, overlay = { "0.08-0.33","0.08-0.34" }, displayID = 43377 }; --Vyraxxis
	[63978] = { zoneID = 390, artID = { 402 }, x = 0.062, y = 0.58599997, overlay = { "0.06-0.57","0.06-0.58" }, displayID = 43409 }; --Kri'chon
	[62881] = { zoneID = 395, artID = { 403 }, x = 0.548, y = 0.584, overlay = { "0.52-0.60","0.53-0.6","0.53-0.59","0.54-0.59","0.54-0.58" }, displayID = 45744 }; --Gaohun the Soul-Severer
	[71992] = { zoneID = 407, artID = { 419 }, x = 0.432, y = 0.458, overlay = { "0.36-0.49","0.36-0.50","0.37-0.46","0.37-0.40","0.37-0.50","0.37-0.45","0.38-0.39","0.38-0.42","0.38-0.49","0.38-0.47","0.38-0.48","0.39-0.41","0.39-0.43","0.39-0.45","0.39-0.48","0.39-0.44","0.39-0.47","0.39-0.49","0.39-0.50","0.39-0.42","0.39-0.46","0.4-0.47","0.40-0.41","0.40-0.47","0.40-0.50","0.40-0.45","0.40-0.48","0.40-0.46","0.40-0.51","0.41-0.5","0.41-0.44","0.41-0.51","0.41-0.42","0.41-0.45","0.41-0.50","0.41-0.43","0.41-0.46","0.42-0.46","0.42-0.45","0.43-0.43","0.43-0.44","0.43-0.47","0.43-0.45" }, displayID = 49249 }; --Moonfang
	[122899] = { zoneID = 408, artID = { 420 }, x = 0.466, y = 0.42400002, overlay = { "0.26-0.31","0.30-0.35","0.30-0.38","0.30-0.36","0.31-0.37","0.31-0.34","0.31-0.36","0.32-0.38","0.32-0.35","0.32-0.37","0.32-0.31","0.32-0.34","0.32-0.41","0.33-0.35","0.33-0.36","0.33-0.40","0.33-0.45","0.33-0.41","0.34-0.34","0.34-0.36","0.34-0.39","0.34-0.35","0.34-0.38","0.34-0.41","0.34-0.33","0.34-0.40","0.35-0.42","0.35-0.32","0.35-0.35","0.35-0.36","0.35-0.37","0.35-0.38","0.35-0.39","0.35-0.44","0.35-0.40","0.35-0.43","0.36-0.36","0.36-0.40","0.36-0.42","0.36-0.44","0.36-0.41","0.36-0.35","0.36-0.49","0.36-0.38","0.36-0.45","0.36-0.47","0.36-0.33","0.36-0.37","0.37-0.36","0.37-0.39","0.37-0.40","0.37-0.43","0.37-0.31","0.37-0.46","0.37-0.48","0.38-0.37","0.38-0.38","0.38-0.44","0.38-0.49","0.38-0.35","0.38-0.46","0.38-0.39","0.38-0.40","0.38-0.42","0.38-0.48","0.38-0.34","0.38-0.36","0.38-0.4","0.38-0.47","0.38-0.32","0.38-0.41","0.38-0.43","0.38-0.50","0.39-0.49","0.39-0.31","0.39-0.37","0.39-0.38","0.39-0.43","0.39-0.44","0.39-0.32","0.39-0.34","0.39-0.42","0.39-0.47","0.39-0.30","0.39-0.36","0.4-0.33","0.4-0.37","0.4-0.38","0.4-0.39","0.4-0.4","0.40-0.42","0.40-0.44","0.40-0.46","0.40-0.48","0.40-0.49","0.40-0.50","0.40-0.41","0.40-0.45","0.40-0.34","0.40-0.38","0.40-0.40","0.40-0.51","0.40-0.4","0.40-0.47","0.41-0.37","0.41-0.38","0.41-0.36","0.41-0.44","0.41-0.45","0.41-0.47","0.41-0.35","0.41-0.43","0.41-0.48","0.41-0.49","0.41-0.33","0.41-0.46","0.41-0.32","0.41-0.40","0.41-0.51","0.42-0.34","0.42-0.39","0.42-0.35","0.42-0.40","0.42-0.42","0.42-0.48","0.42-0.37","0.42-0.47","0.42-0.5","0.42-0.41","0.42-0.43","0.43-0.42","0.43-0.45","0.43-0.46","0.43-0.37","0.43-0.39","0.43-0.36","0.43-0.43","0.43-0.48","0.43-0.33","0.43-0.34","0.43-0.35","0.43-0.41","0.44-0.35","0.44-0.42","0.44-0.44","0.44-0.47","0.44-0.50","0.44-0.37","0.44-0.39","0.44-0.34","0.44-0.36","0.44-0.40","0.45-0.41","0.45-0.35","0.45-0.37","0.45-0.49","0.45-0.52","0.45-0.42","0.45-0.44","0.45-0.45","0.46-0.42" }, displayID = 77425 }; --Death Metal Knight
	[50331] = { zoneID = 418, artID = { 499 }, x = 0.39400002, y = 0.288, overlay = { "0.39-0.28" }, displayID = 44162 }; --Go-Kan
	[50340] = { zoneID = 418, artID = { 499 }, x = 0.58599997, y = 0.344, overlay = { "0.53-0.38","0.54-0.32","0.56-0.28","0.56-0.35","0.56-0.38","0.58-0.31","0.58-0.34" }, displayID = 44281 }; --Gaarn the Toxic
	[50352] = { zoneID = 418, artID = { 499 }, x = 0.704, y = 0.18200001, overlay = { "0.67-0.23","0.70-0.18" }, displayID = 44348 }; --Qu'nas
	[50388] = { zoneID = 418, artID = { 499 }, x = 0.156, y = 0.35599998, overlay = { "0.14-0.31","0.14-0.35","0.14-0.30","0.15-0.34","0.15-0.35" }, displayID = 44396 }; --Torik-Ethis
	[50768] = { zoneID = 418, artID = { 499 }, x = 0.31, y = 0.344, overlay = { "0.30-0.38","0.31-0.34" }, displayID = 44224 }; --Cournith Waterstrider
	[50787] = { zoneID = 418, artID = { 499 }, x = 0.58599997, y = 0.438, overlay = { "0.56-0.46","0.58-0.43" }, displayID = 44268 }; --Arness the Scale
	[50816] = { zoneID = 418, artID = { 499 }, x = 0.428, y = 0.528, overlay = { "0.39-0.55","0.40-0.52","0.41-0.55","0.42-0.52" }, displayID = 44371 }; --Ruun Ghostpaw
	[50830] = { zoneID = 418, artID = { 499 }, x = 0.542, y = 0.89, overlay = { "0.52-0.88","0.54-0.89" }, displayID = 44243 }; --Spriggin
	[68317] = { zoneID = 418, artID = { 499 }, x = 0.89, y = 0.268, overlay = { "0.84-0.31","0.89-0.26" }, friendly = { "A" }, displayID = 46743 }; --Mavis Harms
	[68318] = { zoneID = 418, artID = { 499 }, x = 0.89599997, y = 0.22399999, overlay = { "0.84-0.27","0.85-0.27","0.89-0.22" }, friendly = { "A" }, displayID = 46747 }; --Dalan Nightbreaker
	[68319] = { zoneID = 418, artID = { 499 }, x = 0.922, y = 0.248, overlay = { "0.87-0.29","0.92-0.24" }, friendly = { "A" }, displayID = 46745 }; --Disha Fearwarden
	[68320] = { zoneID = 418, artID = { 499 }, x = 0.132, y = 0.66, overlay = { "0.12-0.64","0.13-0.66" }, friendly = { "H" }, displayID = 46744 }; --Ubunti the Shade
	[68321] = { zoneID = 418, artID = { 499 }, x = 0.14, y = 0.57, overlay = { "0.13-0.54","0.14-0.57" }, friendly = { "H" }, displayID = 46748 }; --Kar Warmaker
	[68322] = { zoneID = 418, artID = { 499 }, x = 0.106000006, y = 0.57, overlay = { "0.09-0.54","0.10-0.56","0.10-0.57" }, friendly = { "H" }, displayID = 46746 }; --Muerta
	[50334] = { zoneID = 422, artID = { 434 }, x = 0.252, y = 0.286, overlay = { "0.25-0.28" }, displayID = 44166 }; --Dak the Breaker
	[50347] = { zoneID = 422, artID = { 434 }, x = 0.71800005, y = 0.376, overlay = { "0.71-0.37" }, displayID = 44285 }; --Karr the Darkener
	[50356] = { zoneID = 422, artID = { 434 }, x = 0.742, y = 0.204, overlay = { "0.72-0.22","0.73-0.20","0.73-0.23","0.74-0.20" }, displayID = 44351 }; --Krol the Blade
	[50739] = { zoneID = 422, artID = { 434 }, x = 0.39200002, y = 0.41799998, overlay = { "0.35-0.30","0.37-0.29","0.39-0.41" }, displayID = 44399 }; --Gar'lok
	[50776] = { zoneID = 422, artID = { 434 }, x = 0.64199996, y = 0.58599997, overlay = { "0.64-0.58" }, displayID = 44229 }; --Nalash Verdantis
	[50805] = { zoneID = 422, artID = { 434 }, x = 0.396, y = 0.606, overlay = { "0.36-0.62","0.36-0.63","0.36-0.61","0.36-0.64","0.38-0.63","0.38-0.58","0.38-0.62","0.39-0.62","0.39-0.58","0.39-0.60" }, displayID = 44271 }; --Omnis Grinlok
	[50821] = { zoneID = 422, artID = { 434 }, x = 0.348, y = 0.23200001, overlay = { "0.34-0.23" }, displayID = 44374 }; --Ai-Li Skymirror
	[50836] = { zoneID = 422, artID = { 434 }, x = 0.554, y = 0.634, overlay = { "0.55-0.63" }, displayID = 44250 }; --Ik-Ik the Nimble
	[62] = { zoneID = 425, artID = { 437 }, x = 0.314, y = 0.17, overlay = { "0.31-0.18" }, displayID = 26 }; --Gug Fatcandle
	[70126] = { zoneID = 433, artID = { 445 }, x = 0.638, y = 0.756, overlay = { "0.53-0.82","0.55-0.73","0.62-0.74","0.63-0.74","0.63-0.73","0.63-0.75" }, displayID = 47874 }; --Willy Wilder
	[43720] = { zoneID = 462, artID = { 474 }, x = 0.21200001, y = 0.71, overlay = { "0.20-0.70","0.21-0.71" }, displayID = 52724 }; --"Pokey" Thornmantle
	[50328] = { zoneID = 465, artID = { 477 }, x = 0.65199995, y = 0.79800004, overlay = { "0.60-0.77","0.61-0.76","0.61-0.79","0.62-0.80","0.64-0.8","0.65-0.81","0.65-0.79" }, displayID = 46665 }; --Fangor
	[107431] = { zoneID = 469, artID = { 481 }, x = 0.708, y = 0.16, overlay = { "0.62-0.27","0.64-0.28","0.64-0.25","0.65-0.29","0.66-0.25","0.66-0.29","0.66-0.27","0.66-0.28","0.67-0.28","0.67-0.29","0.67-0.30","0.70-0.16" }, displayID = 68291 }; --Weaponized Rabbot
	[1132] = { zoneID = 469, artID = { 481 }, x = 0.66, y = 0.336, overlay = { "0.66-0.37","0.67-0.35","0.67-0.34","0.67-0.33","0.67-0.37","0.69-0.34","0.69-0.38","0.7-0.34" }, displayID = 11422 }; --Timber
	[1260] = { zoneID = 469, artID = { 481 }, x = 0.292, y = 0.68, overlay = { "0.29-0.66","0.29-0.65","0.29-0.67","0.30-0.64" }, displayID = 5625 }; --Great Father Arctikus
	[8503] = { zoneID = 469, artID = { 481 }, x = 0.402, y = 0.442, overlay = { "0.40-0.46","0.40-0.45" }, displayID = 7807 }; --Gibblewilt
	[59369] = { zoneID = 477, artID = { 489 }, x = 0.352, y = 0.36200002, displayID = 40741 }; --Doctor Theolen Krastinov
	[50358] = { zoneID = 504, artID = { 521 }, x = 0.50200003, y = 0.90800005, overlay = { "0.48-0.88","0.48-0.87","0.48-0.86","0.49-0.88","0.49-0.89","0.49-0.86","0.49-0.90","0.50-0.90" }, displayID = 47695 }; --Haywire Sunreaver Construct
	[69099] = { zoneID = 504, artID = { 521 }, x = 0.605, y = 0.373, overlay = { "0.60-0.37" }, displayID = 47227, questReset = true, nameplate = true, questID = { 32518 } }; --Nalak <The Storm Lord>
	[69664] = { zoneID = 504, artID = { 521 }, x = 0.35, y = 0.626, overlay = { "0.35-0.62" }, displayID = 47873 }; --Mumta
	[69996] = { zoneID = 504, artID = { 521 }, x = 0.376, y = 0.826, overlay = { "0.33-0.81","0.34-0.81","0.35-0.81","0.35-0.82","0.36-0.81","0.36-0.82","0.37-0.82" }, displayID = 47886 }; --Ku'lai the Skyclaw
	[69997] = { zoneID = 504, artID = { 521 }, x = 0.51, y = 0.71199995, overlay = { "0.51-0.71" }, displayID = 47889 }; --Progenitus
	[69998] = { zoneID = 504, artID = { 521 }, x = 0.536, y = 0.53, overlay = { "0.53-0.53" }, displayID = 47809 }; --Goda
	[69999] = { zoneID = 504, artID = { 521 }, x = 0.616, y = 0.498, overlay = { "0.61-0.49" }, displayID = 47595 }; --God-Hulk Ramuk
	[70000] = { zoneID = 504, artID = { 521 }, x = 0.44799998, y = 0.292, overlay = { "0.44-0.3","0.44-0.29" }, displayID = 47902 }; --Al'tabim the All-Seeing
	[70002] = { zoneID = 504, artID = { 521 }, x = 0.546, y = 0.35799998, overlay = { "0.54-0.35" }, displayID = 47917 }; --Lu-Ban
	[70003] = { zoneID = 504, artID = { 521 }, x = 0.634, y = 0.49, overlay = { "0.59-0.36","0.63-0.49" }, displayID = 47900 }; --Molthor
	[70530] = { zoneID = 504, artID = { 521 }, x = 0.396, y = 0.812, overlay = { "0.39-0.81" }, displayID = 48097 }; --Ra'sha
	[70001] = { zoneID = 505, artID = { 522 }, x = 0.44599998, y = 0.41, overlay = { "0.34-0.27","0.35-0.25","0.36-0.25","0.38-0.26","0.42-0.32","0.42-0.33","0.42-0.29","0.44-0.36","0.44-0.41" }, displayID = 47810 }; --Backbreaker Uru
	[69161] = { zoneID = 507, artID = { 524 }, x = 0.499, y = 0.54, overlay = { "0.49-0.54","0.50-0.54" }, displayID = 47257, questReset = true, nameplate = true, questID = { 32519 } }; --Oondasta
	[70096] = { zoneID = 507, artID = { 524 }, x = 0.786, y = 0.806, overlay = { "0.76-0.83","0.77-0.83","0.77-0.82","0.77-0.80","0.78-0.83","0.78-0.84","0.78-0.81","0.78-0.80" }, displayID = 47868 }; --War-God Dokah
	[70440] = { zoneID = 508, artID = { 525 }, x = 0.584, y = 0.77599996, displayID = 48053 }; --Monara
	[70276] = { zoneID = 509, artID = { 526 }, x = 0.268, y = 0.22600001, displayID = 47975 }; --No'ku Stormsayer
	[70430] = { zoneID = 510, artID = { 527 }, x = 0.396, y = 0.39200002, displayID = 34264 }; --Rocky Horror
	[70238] = { zoneID = 512, artID = { 529 }, x = 0.66400003, y = 0.286, displayID = 47963 }; --Unblinking Eye
	[70243] = { zoneID = 512, artID = { 529 }, x = 0.42400002, y = 0.688, displayID = 47952 }; --Archritualist Kelada
	[70249] = { zoneID = 512, artID = { 529 }, x = 0.76, y = 0.29, overlay = { "0.76-0.29" }, displayID = 47963 }; --Focused Eye
	[70429] = { zoneID = 513, artID = { 530 }, x = 0.4473, y = 0.591, displayID = 48039 }; --Flesh'rok the Diseased
	[69843] = { zoneID = 514, artID = { 531 }, x = 0, y = 0, displayID = 48164 }; --Zao'cho
	[50992] = { zoneID = 525, artID = { 542 }, x = 0.64599997, y = 0.52, overlay = { "0.22-0.66","0.23-0.65","0.51-0.50","0.57-0.20","0.58-0.19","0.58-0.18","0.63-0.79","0.63-0.80","0.63-0.81","0.64-0.52" }, displayID = 61218 }; --Gorok
	[71665] = { zoneID = 525, artID = { 542 }, x = 0.548, y = 0.22600001, overlay = { "0.54-0.22" }, displayID = 52167, questID = { 32918 } }; --Giant-Slayer Kul
	[71721] = { zoneID = 525, artID = { 542 }, x = 0.338, y = 0.23, overlay = { "0.33-0.23" }, displayID = 49096, questID = { 32941 } }; --Canyon Icemother
	[72156] = { zoneID = 525, artID = { 542 }, x = 0.626, y = 0.42400002, overlay = { "0.62-0.42" }, displayID = 52424, questID = { 33511 } }; --Borrok the Devourer
	[72294] = { zoneID = 525, artID = { 542 }, x = 0.41599998, y = 0.48599997, overlay = { "0.40-0.47","0.41-0.48","0.41-0.46" }, displayID = 38175, questID = { 33014 } }; --Cindermaw
	[72364] = { zoneID = 525, artID = { 542 }, x = 0.71, y = 0.274, overlay = { "0.70-0.27","0.71-0.27" }, displayID = 49769, questID = { 37562 } }; --Gorg'ak the Lava Guzzler
	[74613] = { zoneID = 525, artID = { 542 }, x = 0.666, y = 0.316, overlay = { "0.65-0.31","0.66-0.30","0.66-0.31" }, displayID = 54953, questID = { 33843 } }; --Broodmother Reeg'ak
	[74971] = { zoneID = 525, artID = { 542 }, x = 0.714, y = 0.468, overlay = { "0.71-0.46" }, displayID = 57874, questID = { 33504 } }; --Firefury Giant
	[76914] = { zoneID = 525, artID = { 542 }, x = 0.55, y = 0.71199995, overlay = { "0.54-0.68","0.54-0.67","0.54-0.69","0.54-0.7","0.55-0.71" }, displayID = 52652, questID = { 34131 } }; --Coldtusk
	[76918] = { zoneID = 525, artID = { 542 }, x = 0.37, y = 0.338, overlay = { "0.37-0.33" }, displayID = 52900, questID = { 33938 } }; --Primalist Mur'og
	[77513] = { zoneID = 525, artID = { 542 }, x = 0.268, y = 0.554, overlay = { "0.25-0.55","0.26-0.56","0.26-0.55" }, displayID = 52404, questID = { 34129 } }; --Coldstomp the Griever
	[77519] = { zoneID = 525, artID = { 542 }, x = 0.59400004, y = 0.314, overlay = { "0.57-0.38","0.57-0.37","0.58-0.31","0.58-0.35","0.58-0.33","0.58-0.34","0.59-0.31" }, displayID = 53946, questID = { 34130 } }; --Giantbane
	[77526] = { zoneID = 525, artID = { 542 }, x = 0.764, y = 0.634, overlay = { "0.76-0.63" }, displayID = 53943, questID = { 34132 } }; --Scout Goreseeker
	[77527] = { zoneID = 525, artID = { 542 }, x = 0.268, y = 0.316, overlay = { "0.26-0.31" }, displayID = 55865, questID = { 34133 } }; --The Beater
	[78128] = { zoneID = 525, artID = { 542 }, x = 0.588, y = 0.336, overlay = { "0.57-0.37","0.57-0.36","0.58-0.33","0.58-0.34","0.58-0.35","0.58-0.36","0.58-0.32","0.58-0.37" }, displayID = 54319, questID = { 34130 } }; --Gronnstalker Dawarn
	[78134] = { zoneID = 525, artID = { 542 }, x = 0.588, y = 0.33400002, overlay = { "0.57-0.37","0.58-0.35","0.58-0.33","0.58-0.36" }, displayID = 54321, questID = { 34130 } }; --Pathfinder Jalog
	[78144] = { zoneID = 525, artID = { 542 }, x = 0.588, y = 0.336, overlay = { "0.57-0.36","0.57-0.37","0.58-0.34","0.58-0.33","0.58-0.36","0.58-0.32" }, displayID = 54332, questID = { 34130 } }; --Giantslayer Kimla
	[78150] = { zoneID = 525, artID = { 542 }, x = 0.59400004, y = 0.312, overlay = { "0.56-0.37","0.56-0.38","0.57-0.37","0.57-0.36","0.58-0.35","0.58-0.32","0.58-0.33","0.58-0.34","0.58-0.36","0.59-0.31" }, displayID = 54337, questID = { 34130 } }; --Beastcarver Saramor
	[78151] = { zoneID = 525, artID = { 542 }, x = 0.59400004, y = 0.314, overlay = { "0.56-0.37","0.57-0.37","0.58-0.36","0.58-0.31","0.58-0.35","0.58-0.33","0.58-0.32","0.59-0.31" }, displayID = 54343, questID = { 34130 } }; --Huntmaster Kuang
	[78169] = { zoneID = 525, artID = { 542 }, x = 0.588, y = 0.342, overlay = { "0.56-0.37","0.56-0.38","0.57-0.36","0.57-0.37","0.58-0.32","0.58-0.34","0.58-0.33","0.58-0.35","0.58-0.36" }, displayID = 54345, questID = { 34130 } }; --Cloudspeaker Daber
	[78265] = { zoneID = 525, artID = { 542 }, x = 0.72199994, y = 0.33, overlay = { "0.72-0.33" }, displayID = 55699, questID = { 37361 } }; --The Bone Crawler
	[78606] = { zoneID = 525, artID = { 542 }, x = 0.282, y = 0.666, overlay = { "0.28-0.66" }, displayID = 54749, questID = { 34470 } }; --Pale Fishmonger
	[78621] = { zoneID = 525, artID = { 542 }, x = 0.676, y = 0.78800005, overlay = { "0.66-0.77","0.66-0.78","0.66-0.76","0.67-0.76","0.67-0.78","0.67-0.77" }, displayID = 47661, questID = { 34477 } }; --Cyclonic Fury
	[78867] = { zoneID = 525, artID = { 542 }, x = 0.276, y = 0.5, overlay = { "0.27-0.5" }, displayID = 47661, questID = { 34497 } }; --Breathless
	[79104] = { zoneID = 525, artID = { 542 }, x = 0.404, y = 0.122, overlay = { "0.40-0.12" }, displayID = 57149, questID = { 34522 } }; --Ug'lok the Frozen
	[79145] = { zoneID = 525, artID = { 542 }, x = 0.406, y = 0.278, overlay = { "0.40-0.27" }, displayID = 52170, questID = { 34559 } }; --Yaga the Scarred
	[80190] = { zoneID = 525, artID = { 542 }, x = 0.518, y = 0.648, overlay = { "0.50-0.52","0.51-0.64" }, displayID = 56636, questID = { 34825 } }; --Gruuk
	[80235] = { zoneID = 525, artID = { 542 }, x = 0.47, y = 0.552, overlay = { "0.47-0.55" }, displayID = 56636, questID = { 34839 } }; --Gurun
	[80242] = { zoneID = 525, artID = { 542 }, x = 0.412, y = 0.682, overlay = { "0.41-0.68" }, displayID = 55721, questID = { 34843 } }; --Chillfang
	[80312] = { zoneID = 525, artID = { 542 }, x = 0.38599998, y = 0.628, overlay = { "0.38-0.63","0.38-0.62" }, displayID = 55657, questID = { 34865 } }; --Grutush the Pillager
	[81001] = { zoneID = 525, artID = { 542 }, x = 0.136, y = 0.51, overlay = { "0.13-0.50","0.13-0.51" }, displayID = 61674 }; --Nok-Karosh
	[82536] = { zoneID = 525, artID = { 542 }, x = 0.38, y = 0.14, overlay = { "0.38-0.14" }, displayID = 57051, questID = { 37388 } }; --Gorivax
	[82614] = { zoneID = 525, artID = { 542 }, x = 0.426, y = 0.216, overlay = { "0.42-0.21" }, displayID = 58329, questID = { 37387 } }; --Moltnoma
	[82616] = { zoneID = 525, artID = { 542 }, x = 0.488, y = 0.234, overlay = { "0.48-0.24","0.48-0.23" }, displayID = 55133, questID = { 37386 } }; --Jabberjaw
	[82617] = { zoneID = 525, artID = { 542 }, x = 0.44599998, y = 0.152, overlay = { "0.44-0.15" }, displayID = 57263, questID = { 37385 } }; --Slogtusk the Corpse-Eater
	[82618] = { zoneID = 525, artID = { 542 }, x = 0.436, y = 0.088, overlay = { "0.43-0.09","0.43-0.08" }, displayID = 52899, questID = { 37384 } }; --Tor'goroth
	[82620] = { zoneID = 525, artID = { 542 }, x = 0.382, y = 0.16, overlay = { "0.38-0.16" }, displayID = 57313, questID = { 37383 } }; --Son of Goramal
	[84374] = { zoneID = 525, artID = { 542 }, x = 0.86800003, y = 0.466, overlay = { "0.86-0.46" }, displayID = 58318, questID = { 37404 } }; --Kaga the Ironbender
	[84376] = { zoneID = 525, artID = { 542 }, x = 0.84199995, y = 0.466, overlay = { "0.84-0.46" }, displayID = 58318, questID = { 37403 } }; --Earthshaker Holar
	[84378] = { zoneID = 525, artID = { 542 }, x = 0.886, y = 0.572, overlay = { "0.88-0.57" }, displayID = 58319, questID = { 37525 } }; --Ak'ox the Slaughterer
	[84392] = { zoneID = 525, artID = { 542 }, x = 0.86800003, y = 0.49, overlay = { "0.86-0.49" }, displayID = 58330, questID = { 37401 } }; --Ragore Driftstalker
	[87348] = { zoneID = 525, artID = { 542 }, x = 0.68, y = 0.198, overlay = { "0.68-0.19" }, displayID = 58879, questID = { 37382 } }; --Hoarfrost
	[87351] = { zoneID = 525, artID = { 542 }, x = 0.726, y = 0.22600001, overlay = { "0.72-0.22" }, displayID = 60566, questID = { 37381 } }; --Mother of Goren
	[87352] = { zoneID = 525, artID = { 542 }, x = 0.666, y = 0.254, overlay = { "0.66-0.25" }, displayID = 54953, questID = { 37380 } }; --Gibblette the Cowardly
	[87356] = { zoneID = 525, artID = { 542 }, x = 0.706, y = 0.39, overlay = { "0.70-0.39" }, displayID = 60457, questID = { 37379 } }; --Vrok the Ancient
	[87357] = { zoneID = 525, artID = { 542 }, x = 0.72800004, y = 0.25, overlay = { "0.68-0.28","0.69-0.27","0.69-0.28","0.69-0.29","0.69-0.25","0.70-0.24","0.70-0.29","0.71-0.24","0.71-0.29","0.71-0.28","0.72-0.24","0.72-0.27","0.72-0.28","0.72-0.26","0.72-0.25" }, displayID = 55835, questID = { 37378 } }; --Valkor
	[87600] = { zoneID = 525, artID = { 542 }, x = 0.85, y = 0.522, overlay = { "0.85-0.52" }, displayID = 60386 }; --Jaluk the Pacifist
	[87622] = { zoneID = 525, artID = { 542 }, x = 0.866, y = 0.48599997, overlay = { "0.84-0.47","0.84-0.48","0.84-0.49","0.85-0.47","0.86-0.48" }, displayID = 58663, questID = { 37402 } }; --Ogom the Mangler
	[80398] = { zoneID = 534, artID = { 551 }, x = 0.398, y = 0.82199997, overlay = { "0.39-0.82" }, displayID = 55718, questID = { 37407 } }; --Keravnos
	[89675] = { zoneID = 534, artID = { 551 }, x = 0.512, y = 0.466, overlay = { "0.47-0.45","0.47-0.44","0.47-0.46","0.48-0.46","0.48-0.44","0.49-0.46","0.49-0.44","0.49-0.47","0.50-0.43","0.50-0.45","0.50-0.47","0.50-0.48","0.51-0.46" }, displayID = 63416, questID = { 38749 } }; --Commander Org'mok
	[90024] = { zoneID = 534, artID = { 551 }, x = 0.428, y = 0.366, overlay = { "0.41-0.37","0.42-0.37","0.42-0.36" }, displayID = 61851, questID = { 37953 } }; --Sergeant Mor'grak
	[90094] = { zoneID = 534, artID = { 551 }, x = 0.396, y = 0.32599998, overlay = { "0.39-0.32" }, displayID = 61867, questID = { 39046 } }; --Harbormaster Korak
	[90122] = { zoneID = 534, artID = { 551 }, x = 0.37, y = 0.33, overlay = { "0.37-0.33" }, displayID = 56178, questID = { 39045 } }; --Zoug the Heavy
	[90429] = { zoneID = 534, artID = { 551 }, x = 0.316, y = 0.726, overlay = { "0.30-0.71","0.30-0.72","0.31-0.71","0.31-0.72" }, displayID = 62118, questID = { 38026 } }; --Imp-Master Valessa
	[90434] = { zoneID = 534, artID = { 551 }, x = 0.316, y = 0.68, overlay = { "0.31-0.68" }, displayID = 62027, questID = { 38031 } }; --Ceraxas
	[90437] = { zoneID = 534, artID = { 551 }, x = 0.266, y = 0.752, overlay = { "0.26-0.75" }, displayID = 62187, questID = { 38030 } }; --Jax'zor
	[90438] = { zoneID = 534, artID = { 551 }, x = 0.258, y = 0.764, overlay = { "0.25-0.76" }, displayID = 54366, questID = { 38029 } }; --Lady Oran
	[90442] = { zoneID = 534, artID = { 551 }, x = 0.258, y = 0.796, overlay = { "0.25-0.79" }, displayID = 29442, questID = { 38032 } }; --Mistress Thavra
	[90519] = { zoneID = 534, artID = { 551 }, x = 0.44599998, y = 0.378, overlay = { "0.44-0.37" }, displayID = 58329, questID = { 37990 } }; --Cindral the Wildfire
	[90777] = { zoneID = 534, artID = { 551 }, x = 0.22600001, y = 0.4, overlay = { "0.20-0.37","0.20-0.40","0.20-0.41","0.20-0.38","0.20-0.39","0.21-0.40","0.22-0.37","0.22-0.39","0.22-0.4" }, displayID = 62123, questID = { 38028 } }; --High Priest Ikzan
	[90782] = { zoneID = 534, artID = { 551 }, x = 0.17799999, y = 0.42400002, overlay = { "0.17-0.42" }, displayID = 7757, questID = { 38034 } }; --Rasthe
	[90884] = { zoneID = 534, artID = { 551 }, x = 0.236, y = 0.52, overlay = { "0.23-0.52" }, displayID = 62140, questID = { 38262 } }; --Bilkor the Thrower
	[90885] = { zoneID = 534, artID = { 551 }, x = 0.206, y = 0.5, overlay = { "0.20-0.49","0.20-0.5" }, displayID = 62141, questID = { 38263 } }; --Rogond the Tracker
	[90887] = { zoneID = 534, artID = { 551 }, x = 0.248, y = 0.46400002, overlay = { "0.20-0.51","0.21-0.49","0.22-0.51","0.22-0.49","0.22-0.48","0.23-0.48","0.23-0.47","0.24-0.46" }, displayID = 60108, questID = { 38265 } }; --Dorg the Bloody
	[90888] = { zoneID = 534, artID = { 551 }, x = 0.256, y = 0.462, overlay = { "0.25-0.46" }, displayID = 62142, questID = { 38264 } }; --Drivnul
	[90936] = { zoneID = 534, artID = { 551 }, x = 0.246, y = 0.5, overlay = { "0.20-0.52","0.21-0.52","0.21-0.53","0.21-0.51","0.22-0.51","0.22-0.54","0.22-0.53","0.23-0.50","0.23-0.52","0.23-0.49","0.24-0.5" }, displayID = 62169, questID = { 38266 } }; --Bloodhunter Zulk
	[91009] = { zoneID = 534, artID = { 551 }, x = 0.576, y = 0.23200001, overlay = { "0.57-0.22","0.57-0.23" }, displayID = 14173, questID = { 38457 } }; --Putre'thar
	[91087] = { zoneID = 534, artID = { 551 }, x = 0.48400003, y = 0.286, overlay = { "0.48-0.28" }, displayID = 61981, questID = { 38207 } }; --Zeter'el
	[91093] = { zoneID = 534, artID = { 551 }, x = 0.41, y = 0.688, overlay = { "0.39-0.68","0.39-0.69","0.40-0.69","0.41-0.67","0.41-0.68" }, displayID = 62258, questID = { 38209 } }; --Bramblefell
	[91098] = { zoneID = 534, artID = { 551 }, x = 0.53, y = 0.27, overlay = { "0.52-0.27","0.52-0.26","0.52-0.25","0.53-0.25","0.53-0.27" }, displayID = 20431, questID = { 38211 } }; --Felspark
	[91227] = { zoneID = 534, artID = { 551 }, x = 0.222, y = 0.506, overlay = { "0.22-0.50" }, displayID = 64424, questID = { 39159 } }; --Remnant of the Blood Moon
	[91232] = { zoneID = 534, artID = { 551 }, x = 0.15, y = 0.542, overlay = { "0.15-0.54" }, displayID = 62357, questID = { 38746 } }; --Commander Krag'goth
	[91243] = { zoneID = 534, artID = { 551 }, x = 0.136, y = 0.576, overlay = { "0.13-0.56","0.13-0.57" }, displayID = 63341, questID = { 38747 } }; --Tho'gar Gorefist
	[91374] = { zoneID = 534, artID = { 551 }, x = 0.168, y = 0.496, overlay = { "0.16-0.48","0.16-0.49" }, displayID = 62418, questID = { 38282 } }; --Podlord Wakkawam
	[91695] = { zoneID = 534, artID = { 551 }, x = 0.47599998, y = 0.412, overlay = { "0.45-0.42","0.46-0.40","0.46-0.4","0.46-0.42","0.47-0.42","0.47-0.39","0.47-0.41","0.47-0.40" }, displayID = 62706, questID = { 38400 } }; --Grand Warlock Nethekurse
	[91727] = { zoneID = 534, artID = { 551 }, x = 0.498, y = 0.36200002, overlay = { "0.49-0.36" }, displayID = 64023, questID = { 38411 } }; --Executor Riloth
	[91871] = { zoneID = 534, artID = { 551 }, x = 0.52599996, y = 0.406, overlay = { "0.52-0.40" }, displayID = 54516, questID = { 38430 } }; --Argosh the Destroyer
	[92197] = { zoneID = 534, artID = { 551 }, x = 0.262, y = 0.544, overlay = { "0.26-0.54" }, displayID = 63547, questID = { 38496 } }; --Relgor
	[92274] = { zoneID = 534, artID = { 551 }, x = 0.536, y = 0.216, overlay = { "0.53-0.21" }, displayID = 20385, questID = { 38557 } }; --Painmistress Selora
	[92408] = { zoneID = 534, artID = { 551 }, x = 0.6, y = 0.21, overlay = { "0.6-0.21" }, displayID = 20590, questID = { 38579 } }; --Xanzith the Everlasting
	[92411] = { zoneID = 534, artID = { 551 }, x = 0.53, y = 0.19600001, overlay = { "0.52-0.19","0.53-0.19" }, displayID = 63026, questID = { 38580 } }; --Overlord Ma'gruth
	[92429] = { zoneID = 534, artID = { 551 }, x = 0.576, y = 0.672, overlay = { "0.57-0.67" }, displayID = 58756, questID = { 38589 } }; --Broodlord Ixkor
	[92451] = { zoneID = 534, artID = { 551 }, x = 0.276, y = 0.32599998, overlay = { "0.27-0.32" }, displayID = 62632, questID = { 37937 } }; --Varyx the Damned
	[92465] = { zoneID = 534, artID = { 551 }, x = 0.492, y = 0.736, overlay = { "0.48-0.73","0.49-0.73" }, displayID = 63052, questID = { 38597 } }; --The Blackfang
	[92495] = { zoneID = 534, artID = { 551 }, x = 0.626, y = 0.72199994, overlay = { "0.62-0.72" }, displayID = 63078, questID = { 38600 } }; --Soulslicer
	[92508] = { zoneID = 534, artID = { 551 }, x = 0.636, y = 0.812, overlay = { "0.63-0.81" }, displayID = 63082, questID = { 38604 } }; --Gloomtalon
	[92517] = { zoneID = 534, artID = { 551 }, x = 0.52, y = 0.83599997, overlay = { "0.51-0.83","0.52-0.83" }, displayID = 63093, questID = { 38605 } }; --Krell the Serene
	[92552] = { zoneID = 534, artID = { 551 }, x = 0.35599998, y = 0.466, overlay = { "0.35-0.46" }, displayID = 63139, questID = { 38609 } }; --Belgork
	[92574] = { zoneID = 534, artID = { 551 }, x = 0.34, y = 0.44599998, overlay = { "0.34-0.44" }, displayID = 55860, questID = { 38620 } }; --Thromma the Gutslicer
	[92606] = { zoneID = 534, artID = { 551 }, x = 0.41, y = 0.78800005, overlay = { "0.41-0.78" }, displayID = 51135, questID = { 38628 } }; --Sylissa
	[92627] = { zoneID = 534, artID = { 551 }, x = 0.438, y = 0.726, overlay = { "0.37-0.68","0.37-0.67","0.38-0.77","0.39-0.74","0.39-0.69","0.39-0.70","0.39-0.71","0.39-0.72","0.39-0.75","0.39-0.76","0.40-0.74","0.40-0.71","0.40-0.73","0.41-0.74","0.41-0.77","0.41-0.75","0.41-0.76","0.42-0.70","0.42-0.71","0.42-0.73","0.42-0.77","0.42-0.76","0.42-0.74","0.43-0.70","0.43-0.71","0.43-0.73","0.43-0.75","0.43-0.76","0.43-0.79","0.43-0.72","0.43-0.74","0.43-0.77" }, displayID = 63197, questID = { 38631 } }; --Rendrak
	[92636] = { zoneID = 534, artID = { 551 }, x = 0.44799998, y = 0.72400004, overlay = { "0.36-0.67","0.36-0.70","0.37-0.67","0.37-0.68","0.38-0.68","0.38-0.71","0.38-0.72","0.38-0.79","0.38-0.76","0.38-0.78","0.38-0.73","0.39-0.69","0.39-0.74","0.39-0.73","0.39-0.79","0.40-0.70","0.40-0.73","0.40-0.77","0.40-0.78","0.41-0.69","0.42-0.77","0.42-0.74","0.43-0.74","0.43-0.68","0.43-0.71","0.44-0.67","0.44-0.78","0.44-0.76","0.44-0.72" }, displayID = 63206, questID = { 38632 } }; --The Night Haunter
	[92645] = { zoneID = 534, artID = { 551 }, x = 0.442, y = 0.72400004, overlay = { "0.37-0.67","0.38-0.79","0.38-0.72","0.38-0.74","0.40-0.73","0.40-0.77","0.41-0.69","0.42-0.77","0.42-0.74","0.43-0.74","0.43-0.67","0.44-0.72" }, displayID = 63206, questID = { 38632 } }; --The Night Haunter
	[92647] = { zoneID = 534, artID = { 551 }, x = 0.458, y = 0.47, overlay = { "0.45-0.47" }, displayID = 63208, questID = { 38634 } }; --Felsmith Damorka
	[92657] = { zoneID = 534, artID = { 551 }, x = 0.51, y = 0.748, overlay = { "0.50-0.74","0.51-0.74" }, displayID = 63342, questID = { 38696 } }; --Bleeding Hollow Horror
	[92694] = { zoneID = 534, artID = { 551 }, x = 0.346, y = 0.726, overlay = { "0.34-0.72" }, displayID = 63223, questID = { 38654 } }; --The Goreclaw
	[92887] = { zoneID = 534, artID = { 551 }, x = 0.65599996, y = 0.368, overlay = { "0.65-0.36" }, displayID = 64723, questID = { 38700 } }; --Steelsnout
	[92941] = { zoneID = 534, artID = { 551 }, x = 0.33200002, y = 0.35799998, overlay = { "0.32-0.35","0.33-0.35" }, displayID = 62142, questID = { 38709 } }; --Gorabosh
	[92977] = { zoneID = 534, artID = { 551 }, x = 0.126, y = 0.568, overlay = { "0.12-0.56" }, displayID = 58123, questID = { 38751 } }; --The Iron Houndmaster
	[93001] = { zoneID = 534, artID = { 551 }, x = 0.16600001, y = 0.56200004, overlay = { "0.15-0.57","0.16-0.57","0.16-0.56" }, displayID = 62816, questID = { 38752 } }; --Szirek the Twisted
	[93002] = { zoneID = 534, artID = { 551 }, x = 0.522, y = 0.65199995, overlay = { "0.52-0.65" }, displayID = 61301, questID = { 38726 } }; --Magwia
	[93028] = { zoneID = 534, artID = { 551 }, x = 0.202, y = 0.53400004, overlay = { "0.2-0.53","0.20-0.53" }, displayID = 63549, questID = { 38736 } }; --Driss Vile
	[93057] = { zoneID = 534, artID = { 551 }, x = 0.16, y = 0.592, overlay = { "0.16-0.59" }, displayID = 62816, questID = { 38750 } }; --Grannok
	[93076] = { zoneID = 534, artID = { 551 }, x = 0.366, y = 0.796, overlay = { "0.35-0.80","0.35-0.79","0.36-0.80","0.36-0.79","0.36-0.78" }, displayID = 63424, questID = { 34727,38756 } }; --Captain Ironbeard
	[93125] = { zoneID = 534, artID = { 551 }, x = 0.346, y = 0.78, overlay = { "0.34-0.77","0.34-0.78" }, displayID = 19658, questID = { 38764 } }; --Glub'glok
	[93168] = { zoneID = 534, artID = { 551 }, x = 0.288, y = 0.51, overlay = { "0.28-0.51" }, displayID = 62261, questID = { 38775 } }; --Felbore
	[93236] = { zoneID = 534, artID = { 551 }, x = 0.498, y = 0.616, overlay = { "0.49-0.61" }, displayID = 21371, questID = { 38812 } }; --Shadowthrash
	[93264] = { zoneID = 534, artID = { 551 }, x = 0.48599997, y = 0.572, overlay = { "0.48-0.57" }, displayID = 63416, questID = { 38820 } }; --Captain Grok'mar
	[93279] = { zoneID = 534, artID = { 551 }, x = 0.396, y = 0.682, overlay = { "0.39-0.68" }, displayID = 63514, questID = { 38825 } }; --Kris'kar the Unredeemed
	[95044] = { zoneID = 534, artID = { 551 }, x = 0.158, y = 0.638, overlay = { "0.13-0.59","0.13-0.60","0.14-0.60","0.14-0.61","0.14-0.62","0.15-0.63" }, displayID = 64258, questID = { 39288 } }; --Terrorfist
	[95053] = { zoneID = 534, artID = { 551 }, x = 0.23, y = 0.402, overlay = { "0.23-0.40" }, displayID = 64266, questID = { 39287 } }; --Deathtalon
	[95054] = { zoneID = 534, artID = { 551 }, x = 0.32599998, y = 0.74, overlay = { "0.32-0.73","0.32-0.74" }, displayID = 64263, questID = { 39290 } }; --Vengeance
	[95056] = { zoneID = 534, artID = { 551 }, x = 0.47, y = 0.52599996, overlay = { "0.47-0.52" }, displayID = 63059, questID = { 39289 } }; --Doomroller
	[96235] = { zoneID = 534, artID = { 551 }, x = 0.696, y = 0.382, overlay = { "0.69-0.38" }, displayID = 62785 }; --Xemirkol
	[98283] = { zoneID = 534, artID = { 551 }, x = 0.83599997, y = 0.436, overlay = { "0.83-0.43" }, displayID = 65788, questID = { 40105 } }; --Drakum
	[98284] = { zoneID = 534, artID = { 551 }, x = 0.806, y = 0.564, overlay = { "0.80-0.56" }, displayID = 65789, questID = { 40106 } }; --Gondar
	[98285] = { zoneID = 534, artID = { 551 }, x = 0.88, y = 0.55799997, overlay = { "0.88-0.55" }, displayID = 58598, questID = { 40104 } }; --Smashum Grabb
	[98408] = { zoneID = 534, artID = { 551 }, x = 0.875, y = 0.561, overlay = { "0.87-0.56" }, displayID = 65796, questID = { 40107 } }; --Fel Overseer Mudlump
	[51015] = { zoneID = 535, artID = { 552 }, x = 0.804, y = 0.56, overlay = { "0.55-0.81","0.62-0.45","0.62-0.33","0.62-0.46","0.62-0.47","0.63-0.46","0.67-0.59","0.67-0.60","0.67-0.58","0.79-0.55","0.8-0.55","0.80-0.56" }, displayID = 61216 }; --Silthide
	[77529] = { zoneID = 535, artID = { 552 }, x = 0.538, y = 0.258, overlay = { "0.53-0.25" }, displayID = 53936, questID = { 34135 } }; --Yazheera the Incinerator
	[77561] = { zoneID = 535, artID = { 552 }, x = 0.686, y = 0.156, overlay = { "0.68-0.15" }, displayID = 53949, questID = { 34142 } }; --Dr. Gloom
	[77614] = { zoneID = 535, artID = { 552 }, x = 0.462, y = 0.55, overlay = { "0.46-0.55" }, displayID = 47651, questID = { 34145 } }; --Frenzied Golem
	[77620] = { zoneID = 535, artID = { 552 }, x = 0.376, y = 0.704, overlay = { "0.37-0.70" }, displayID = 53979, questID = { 34165 } }; --Cro Fleshrender
	[77626] = { zoneID = 535, artID = { 552 }, x = 0.78400004, y = 0.508, overlay = { "0.75-0.50","0.75-0.51","0.76-0.50","0.77-0.51","0.78-0.50" }, displayID = 58713, questID = { 34167 } }; --Hen-Mother Hami
	[77634] = { zoneID = 535, artID = { 552 }, x = 0.59, y = 0.874, overlay = { "0.58-0.87","0.59-0.87" }, displayID = 54564, questID = { 34171 } }; --Taladorantula
	[77664] = { zoneID = 535, artID = { 552 }, x = 0.366, y = 0.96, overlay = { "0.36-0.96" }, friendly = { "A","H" }, displayID = 61239, questID = { 34182 } }; --Aarko
	[77715] = { zoneID = 535, artID = { 552 }, x = 0.65199995, y = 0.43, overlay = { "0.60-0.47","0.60-0.48","0.61-0.46","0.61-0.45","0.61-0.44","0.61-0.49","0.61-0.48","0.62-0.46","0.62-0.47","0.62-0.44","0.62-0.45","0.62-0.48","0.63-0.43","0.63-0.45","0.64-0.43","0.64-0.45","0.65-0.43" }, displayID = 52415, questID = { 34185 } }; --Hammertooth
	[77719] = { zoneID = 535, artID = { 552 }, x = 0.33200002, y = 0.636, overlay = { "0.30-0.64","0.30-0.65","0.31-0.63","0.32-0.63","0.32-0.65","0.32-0.62","0.33-0.63" }, displayID = 59748, questID = { 34189 } }; --Glimmerwing
	[77741] = { zoneID = 535, artID = { 552 }, x = 0.59400004, y = 0.59599996, overlay = { "0.59-0.59" }, displayID = 59725, questID = { 34196 } }; --Ra'kahn
	[77750] = { zoneID = 535, artID = { 552 }, x = 0.786, y = 0.556, overlay = { "0.77-0.56","0.78-0.55" }, displayID = 56084 }; --Kaavu the Crimson Claw
	[77776] = { zoneID = 535, artID = { 552 }, x = 0.696, y = 0.336, overlay = { "0.69-0.33" }, displayID = 54079, questID = { 34205 } }; --Wandering Vindicator
	[77784] = { zoneID = 535, artID = { 552 }, x = 0.49, y = 0.92, overlay = { "0.49-0.92" }, displayID = 54092, questID = { 34208 } }; --Lo'marg Jawcrusher
	[77795] = { zoneID = 535, artID = { 552 }, x = 0.342, y = 0.57, overlay = { "0.34-0.57" }, displayID = 39019, questID = { 34221 } }; --Echo of Murmur
	[77828] = { zoneID = 535, artID = { 552 }, x = 0.34, y = 0.572, overlay = { "0.34-0.57" }, friendly = { "A","H" }, displayID = 39019, questID = { 34221 } }; --Echo of Murmur
	[78710] = { zoneID = 535, artID = { 552 }, x = 0.566, y = 0.66199994, overlay = { "0.56-0.65","0.56-0.63","0.56-0.64","0.56-0.66" }, displayID = 18531, questID = { 35219 } }; --Kharazos the Triumphant
	[78713] = { zoneID = 535, artID = { 552 }, x = 0.566, y = 0.626, overlay = { "0.56-0.65","0.56-0.62","0.56-0.64" }, displayID = 20919, questID = { 35219 } }; --Galzomar
	[78715] = { zoneID = 535, artID = { 552 }, x = 0.566, y = 0.66400003, overlay = { "0.56-0.64","0.56-0.65","0.56-0.63","0.56-0.66" }, displayID = 21252, questID = { 35219 } }; --Sikthiss
	[78872] = { zoneID = 535, artID = { 552 }, x = 0.66800004, y = 0.856, overlay = { "0.66-0.85" }, displayID = 46518, questID = { 34498 } }; --Klikixx
	[79334] = { zoneID = 535, artID = { 552 }, x = 0.864, y = 0.308, overlay = { "0.85-0.29","0.86-0.29","0.86-0.30" }, displayID = 18194, questID = { 34859 } }; --No'losh
	[79485] = { zoneID = 535, artID = { 552 }, x = 0.538, y = 0.91, overlay = { "0.53-0.91" }, displayID = 56284, questID = { 34668 } }; --Talonpriest Zorkra
	[80204] = { zoneID = 535, artID = { 552 }, x = 0.508, y = 0.83800006, overlay = { "0.49-0.83","0.49-0.85","0.49-0.86","0.50-0.83","0.50-0.86","0.50-0.84" }, displayID = 55632, questID = { 35018 } }; --Felbark
	[80471] = { zoneID = 535, artID = { 552 }, x = 0.674, y = 0.806, overlay = { "0.67-0.80" }, displayID = 55763, questID = { 34929 } }; --Gennadian
	[80524] = { zoneID = 535, artID = { 552 }, x = 0.636, y = 0.20799999, overlay = { "0.63-0.20" }, displayID = 55807, questID = { 34945 } }; --Underseer Bloodmane
	[82920] = { zoneID = 535, artID = { 552 }, x = 0.31, y = 0.268, overlay = { "0.31-0.26" }, displayID = 61253, questID = { 37345 } }; --Lord Korinak
	[82922] = { zoneID = 535, artID = { 552 }, x = 0.376, y = 0.146, overlay = { "0.37-0.14" }, displayID = 58310, questID = { 37343 } }; --Xothear
	[82930] = { zoneID = 535, artID = { 552 }, x = 0.41, y = 0.42, overlay = { "0.41-0.42" }, displayID = 57394, questID = { 37347 } }; --Shadowflame Terrorwalker
	[82942] = { zoneID = 535, artID = { 552 }, x = 0.336, y = 0.378, overlay = { "0.33-0.37" }, displayID = 60856, questID = { 37346 } }; --Lady Demlash
	[82988] = { zoneID = 535, artID = { 552 }, x = 0.374, y = 0.376, overlay = { "0.37-0.37" }, displayID = 57440, questID = { 37348 } }; --Kurlosh Doomfang
	[82992] = { zoneID = 535, artID = { 552 }, x = 0.47599998, y = 0.32799998, overlay = { "0.47-0.32" }, displayID = 57441, questID = { 37341 } }; --Felfire Consort
	[82998] = { zoneID = 535, artID = { 552 }, x = 0.38799998, y = 0.496, overlay = { "0.38-0.49" }, displayID = 21252, questID = { 37349 } }; --Matron of Sin
	[83008] = { zoneID = 535, artID = { 552 }, x = 0.48, y = 0.252, overlay = { "0.48-0.25" }, displayID = 57459, questID = { 37312 } }; --Haakun the All-Consuming
	[83019] = { zoneID = 535, artID = { 552 }, x = 0.47599998, y = 0.39, overlay = { "0.47-0.39" }, displayID = 57470, questID = { 37340 } }; --Gug'tol
	[85572] = { zoneID = 535, artID = { 552 }, x = 0.222, y = 0.742, overlay = { "0.22-0.74" }, displayID = 58979, questID = { 36919 } }; --Grrbrrgle
	[86549] = { zoneID = 535, artID = { 552 }, x = 0.68, y = 0.35, overlay = { "0.67-0.35","0.68-0.35" }, displayID = 59683, questID = { 36858 } }; --Steeltusk
	[87597] = { zoneID = 535, artID = { 552 }, x = 0.44799998, y = 0.41, overlay = { "0.43-0.37","0.43-0.38","0.44-0.39","0.44-0.40","0.44-0.37","0.44-0.38","0.44-0.41" }, displayID = 60385, questID = { 37339 } }; --Bombardier Gu'gok
	[87668] = { zoneID = 535, artID = { 552 }, x = 0.314, y = 0.47599998, overlay = { "0.31-0.47" }, displayID = 60429, questID = { 37344 } }; --Orumo the Observer
	[88043] = { zoneID = 535, artID = { 552 }, x = 0.482, y = 0.352, overlay = { "0.44-0.34","0.45-0.32","0.45-0.36","0.45-0.34","0.45-0.33","0.46-0.32","0.46-0.35","0.46-0.31","0.47-0.35","0.48-0.34","0.48-0.35" }, displayID = 56554, questID = { 37338 } }; --Avatar of Socrethar
	[88071] = { zoneID = 535, artID = { 552 }, x = 0.47599998, y = 0.286, overlay = { "0.43-0.27","0.44-0.28","0.44-0.29","0.44-0.26","0.45-0.26","0.45-0.30","0.45-0.27","0.46-0.31","0.46-0.28","0.47-0.30","0.47-0.28" }, displayID = 60730, questID = { 37337 } }; --Strategist Ankor
	[88072] = { zoneID = 535, artID = { 552 }, x = 0.47599998, y = 0.286, overlay = { "0.43-0.26","0.44-0.28","0.44-0.29","0.44-0.26","0.44-0.30","0.45-0.26","0.45-0.30","0.45-0.27","0.46-0.31","0.46-0.28","0.47-0.3","0.47-0.28" }, displayID = 60728, questID = { 37337 } }; --Archmagus Tekar
	[88083] = { zoneID = 535, artID = { 552 }, x = 0.47599998, y = 0.286, overlay = { "0.43-0.26","0.43-0.27","0.44-0.29","0.44-0.26","0.44-0.30","0.45-0.30","0.45-0.27","0.46-0.31","0.46-0.28","0.47-0.29","0.47-0.28" }, displayID = 60729, questID = { 37337 } }; --Soulbinder Naylana
	[88436] = { zoneID = 535, artID = { 552 }, x = 0.382, y = 0.438, overlay = { "0.36-0.40","0.37-0.42","0.37-0.40","0.37-0.41","0.37-0.43","0.38-0.43" }, displayID = 60902, questID = { 37350 } }; --Vigilant Paarthos
	[88494] = { zoneID = 535, artID = { 552 }, x = 0.38, y = 0.206, overlay = { "0.38-0.20" }, displayID = 60931, questID = { 37342 } }; --Legion Vanguard
	[79543] = { zoneID = 537, artID = { 554 }, x = 0.692, y = 0.236, overlay = { "0.66-0.24","0.67-0.23","0.69-0.23" }, displayID = 58984, questID = { 34671 } }; --Shirzir
	[50883] = { zoneID = 539, artID = { 556 }, x = 0.568, y = 0.522, overlay = { "0.39-0.37","0.39-0.36","0.39-0.35","0.42-0.30","0.43-0.31","0.43-0.32","0.44-0.43","0.44-0.42","0.45-0.67","0.46-0.67","0.53-0.30","0.53-0.31","0.56-0.52" }, displayID = 61221 }; --Pathrunner
	[72362] = { zoneID = 539, artID = { 556 }, x = 0.322, y = 0.35, overlay = { "0.32-0.35" }, displayID = 53720, questID = { 33039 } }; --Ku'targ the Voidseer
	[72537] = { zoneID = 539, artID = { 556 }, x = 0.376, y = 0.146, overlay = { "0.37-0.14" }, displayID = 55451, questID = { 33055 } }; --Leaf-Reader Kurri
	[72606] = { zoneID = 539, artID = { 556 }, x = 0.528, y = 0.508, overlay = { "0.52-0.50" }, displayID = 53607, questID = { 34068 } }; --Rockhoof
	[74206] = { zoneID = 539, artID = { 556 }, x = 0.408, y = 0.444, overlay = { "0.40-0.44" }, displayID = 55523, questID = { 33043 } }; --Killmaw
	[75071] = { zoneID = 539, artID = { 556 }, x = 0.44, y = 0.574, overlay = { "0.43-0.57","0.44-0.57" }, displayID = 53061, questID = { 33642 } }; --Mother Om'ra
	[75434] = { zoneID = 539, artID = { 556 }, x = 0.428, y = 0.404, overlay = { "0.42-0.40" }, displayID = 56900, questID = { 33038 } }; --Windfang Matriarch
	[75435] = { zoneID = 539, artID = { 556 }, x = 0.48599997, y = 0.666, overlay = { "0.48-0.65","0.48-0.66","0.48-0.64" }, displayID = 54696, questID = { 33389 } }; --Yggdrel
	[75482] = { zoneID = 539, artID = { 556 }, x = 0.218, y = 0.21, overlay = { "0.21-0.20","0.21-0.21" }, displayID = 53360, questID = { 33640 } }; --Veloss
	[75492] = { zoneID = 539, artID = { 556 }, x = 0.546, y = 0.70199996, overlay = { "0.54-0.70" }, displayID = 53225, questID = { 33643 } }; --Venomshade
	[76380] = { zoneID = 539, artID = { 556 }, x = 0.33200002, y = 0.352, overlay = { "0.33-0.35" }, displayID = 54744, questID = { 33664 } }; --Gorum
	[77085] = { zoneID = 539, artID = { 556 }, x = 0.48599997, y = 0.436, overlay = { "0.48-0.43" }, displayID = 35903, questID = { 33064 } }; --Dark Emanation
	[77140] = { zoneID = 539, artID = { 556 }, x = 0.41599998, y = 0.32799998, overlay = { "0.29-0.30","0.29-0.29","0.29-0.32","0.3-0.29","0.30-0.29","0.31-0.32","0.31-0.28","0.32-0.33","0.32-0.28","0.33-0.33","0.34-0.28","0.35-0.29","0.35-0.35","0.36-0.29","0.36-0.35","0.37-0.29","0.38-0.36","0.40-0.35","0.41-0.34","0.41-0.30","0.41-0.31","0.41-0.32" }, displayID = 60896, questID = { 33061 } }; --Amaukwa
	[77310] = { zoneID = 539, artID = { 556 }, x = 0.44799998, y = 0.20799999, overlay = { "0.44-0.21","0.44-0.20" }, displayID = 57479, questID = { 35906 } }; --Mad "King" Sporeon
	[79524] = { zoneID = 539, artID = { 556 }, x = 0.376, y = 0.49, overlay = { "0.37-0.48","0.37-0.49" }, displayID = 55232, questID = { 35558 } }; --Hypnocroak
	[79686] = { zoneID = 539, artID = { 556 }, x = 0.616, y = 0.67800003, overlay = { "0.61-0.68","0.61-0.67" }, displayID = 54690, questID = { 34743 } }; --Silverleaf Ancient
	[79692] = { zoneID = 539, artID = { 556 }, x = 0.616, y = 0.67800003, overlay = { "0.61-0.67" }, displayID = 54691, questID = { 34743 } }; --Silverleaf Ancient
	[79693] = { zoneID = 539, artID = { 556 }, x = 0.62, y = 0.674, overlay = { "0.61-0.67","0.62-0.67" }, displayID = 55275, questID = { 34743 } }; --Silverleaf Ancient
	[81406] = { zoneID = 539, artID = { 556 }, x = 0.306, y = 0.066, overlay = { "0.28-0.05","0.29-0.06","0.29-0.05","0.29-0.07","0.30-0.05","0.30-0.06" }, displayID = 56398, questID = { 35281 } }; --Bahameye
	[81639] = { zoneID = 539, artID = { 556 }, x = 0.45, y = 0.77599996, overlay = { "0.44-0.77","0.45-0.77" }, displayID = 56713, questID = { 33383 } }; --Brambleking Fili
	[82207] = { zoneID = 539, artID = { 556 }, x = 0.616, y = 0.618, overlay = { "0.61-0.61" }, displayID = 56898, questID = { 35725 } }; --Faebright
	[82268] = { zoneID = 539, artID = { 556 }, x = 0.426, y = 0.83800006, overlay = { "0.38-0.83","0.38-0.82","0.39-0.81","0.39-0.83","0.39-0.80","0.4-0.83","0.40-0.81","0.41-0.82","0.41-0.83","0.42-0.83" }, displayID = 56933, questID = { 35448 } }; --Darkmaster Go'vid
	[82326] = { zoneID = 539, artID = { 556 }, x = 0.528, y = 0.16600001, overlay = { "0.52-0.16" }, displayID = 61022, questID = { 35731 } }; --Ba'ruun
	[82362] = { zoneID = 539, artID = { 556 }, x = 0.38599998, y = 0.706, overlay = { "0.38-0.70" }, displayID = 56962, questID = { 35523 } }; --Morva Soultwister
	[82374] = { zoneID = 539, artID = { 556 }, x = 0.488, y = 0.22399999, overlay = { "0.48-0.22" }, displayID = 36061, questID = { 35553 } }; --Rai'vosh
	[82411] = { zoneID = 539, artID = { 556 }, x = 0.496, y = 0.42, overlay = { "0.49-0.41","0.49-0.42" }, displayID = 59726, questID = { 35555 } }; --Darktalon
	[82415] = { zoneID = 539, artID = { 556 }, x = 0.636, y = 0.576, overlay = { "0.59-0.55","0.59-0.56","0.59-0.57","0.59-0.52","0.59-0.58","0.6-0.52","0.6-0.54","0.60-0.51","0.60-0.54","0.61-0.50","0.61-0.51","0.61-0.53","0.61-0.57","0.61-0.49","0.61-0.5","0.61-0.52","0.61-0.55","0.62-0.58","0.62-0.50","0.63-0.51","0.63-0.52","0.63-0.57","0.63-0.54","0.63-0.55","0.63-0.56" }, displayID = 61254, questID = { 35732 } }; --Shinri
	[82676] = { zoneID = 539, artID = { 556 }, x = 0.67800003, y = 0.638, overlay = { "0.67-0.63" }, displayID = 52573, questID = { 35688 } }; --Enavra
	[82742] = { zoneID = 539, artID = { 556 }, x = 0.67800003, y = 0.638, overlay = { "0.67-0.63" }, friendly = { "A","H" }, displayID = 52573, questID = { 35688 } }; --Enavra
	[83385] = { zoneID = 539, artID = { 556 }, x = 0.32599998, y = 0.41599998, overlay = { "0.32-0.41" }, displayID = 57526, questID = { 35847 } }; --Voidseer Kalurg
	[83553] = { zoneID = 539, artID = { 556 }, x = 0.574, y = 0.48599997, overlay = { "0.57-0.48" }, displayID = 57801, questID = { 35909 } }; --Insha'tar
	[84911] = { zoneID = 539, artID = { 556 }, x = 0.46, y = 0.71800005, overlay = { "0.46-0.71" }, displayID = 60685, questID = { 37351 } }; --Demidos
	[84925] = { zoneID = 539, artID = { 556 }, x = 0.50200003, y = 0.726, overlay = { "0.5-0.72","0.50-0.72" }, displayID = 58574, questID = { 37352 } }; --Quartermaster Hershak
	[85001] = { zoneID = 539, artID = { 556 }, x = 0.52, y = 0.796, overlay = { "0.51-0.76","0.51-0.77","0.51-0.78","0.52-0.79" }, displayID = 58607, questID = { 37353 } }; --Master Sergeant Milgra
	[85029] = { zoneID = 539, artID = { 556 }, x = 0.482, y = 0.808, overlay = { "0.48-0.80" }, displayID = 58619, questID = { 37354 } }; --Shadowspeaker Niir
	[85121] = { zoneID = 539, artID = { 556 }, x = 0.48, y = 0.77599996, overlay = { "0.48-0.77" }, displayID = 21455, questID = { 37355 } }; --Lady Temptessa
	[85451] = { zoneID = 539, artID = { 556 }, x = 0.296, y = 0.508, overlay = { "0.29-0.51","0.29-0.50" }, displayID = 58894, questID = { 37357 } }; --Malgosh Shadowkeeper
	[85555] = { zoneID = 539, artID = { 556 }, x = 0.606, y = 0.898, overlay = { "0.60-0.9","0.60-0.89" }, displayID = 55833, questID = { 37409 } }; --Nagidna
	[85568] = { zoneID = 539, artID = { 556 }, x = 0.672, y = 0.84599996, overlay = { "0.67-0.84" }, displayID = 57985, questID = { 37410 } }; --Avalanche
	[85837] = { zoneID = 539, artID = { 556 }, x = 0.616, y = 0.888, overlay = { "0.61-0.88" }, displayID = 29878, questID = { 37411 } }; --Slivermaw
	[86213] = { zoneID = 539, artID = { 556 }, x = 0.508, y = 0.79, overlay = { "0.50-0.79" }, displayID = 58879, questID = { 37356 } }; --Aqualir
	[86689] = { zoneID = 539, artID = { 556 }, x = 0.276, y = 0.436, overlay = { "0.27-0.43" }, displayID = 59853, questID = { 36880 } }; --Sneevel
	[79938] = { zoneID = 542, artID = { 559 }, x = 0.518, y = 0.35599998, overlay = { "0.51-0.35" }, displayID = 58947, questID = { 36478 } }; --Shadowbark
	[80372] = { zoneID = 542, artID = { 559 }, x = 0.696, y = 0.538, overlay = { "0.69-0.53" }, displayID = 55712, questID = { 37406 } }; --Echidna
	[80614] = { zoneID = 542, artID = { 559 }, x = 0.468, y = 0.23, overlay = { "0.46-0.23" }, displayID = 58821, questID = { 35599 } }; --Blade-Dancer Aeryx
	[82050] = { zoneID = 542, artID = { 559 }, x = 0.296, y = 0.42, overlay = { "0.29-0.41","0.29-0.42" }, displayID = 58892, questID = { 35334 } }; --Varasha
	[82247] = { zoneID = 542, artID = { 559 }, x = 0.36200002, y = 0.52599996, overlay = { "0.36-0.52" }, displayID = 56921, questID = { 36129 } }; --Nas Dunberlin
	[83990] = { zoneID = 542, artID = { 559 }, x = 0.52, y = 0.076, overlay = { "0.52-0.07" }, displayID = 56656, questID = { 37394 } }; --Solar Magnifier
	[84417] = { zoneID = 542, artID = { 559 }, x = 0.548, y = 0.886, overlay = { "0.53-0.88","0.54-0.88","0.54-0.89" }, displayID = 58314, questID = { 36396 } }; --Mutafen
	[84775] = { zoneID = 542, artID = { 559 }, x = 0.572, y = 0.73800004, overlay = { "0.57-0.73" }, displayID = 59469, questID = { 36254 } }; --Tesska the Broken
	[84805] = { zoneID = 542, artID = { 559 }, x = 0.336, y = 0.22, overlay = { "0.33-0.22" }, displayID = 58506, questID = { 36265 } }; --Stonespite
	[84807] = { zoneID = 542, artID = { 559 }, x = 0.46400002, y = 0.286, overlay = { "0.46-0.28" }, displayID = 58508, questID = { 36267 } }; --Durkath Steelmaw
	[84810] = { zoneID = 542, artID = { 559 }, x = 0.628, y = 0.376, overlay = { "0.62-0.37" }, displayID = 59470, questID = { 36268 } }; --Kalos the Bloodbathed
	[84833] = { zoneID = 542, artID = { 559 }, x = 0.688, y = 0.49, overlay = { "0.68-0.49" }, displayID = 60286, questID = { 36276 } }; --Sangrikass
	[84836] = { zoneID = 542, artID = { 559 }, x = 0.546, y = 0.632, overlay = { "0.54-0.63" }, displayID = 58523, questID = { 36278 } }; --Talonbreaker
	[84838] = { zoneID = 542, artID = { 559 }, x = 0.59599996, y = 0.376, overlay = { "0.59-0.37" }, displayID = 58524, questID = { 36279 } }; --Poisonmaster Bortusk
	[84856] = { zoneID = 542, artID = { 559 }, x = 0.65199995, y = 0.67800003, overlay = { "0.64-0.65","0.64-0.66","0.65-0.67" }, displayID = 52740, questID = { 36283 } }; --Blightglow
	[84872] = { zoneID = 542, artID = { 559 }, x = 0.65, y = 0.54, overlay = { "0.65-0.54" }, displayID = 54715, questID = { 36288 } }; --Oskiira the Vengeful
	[84887] = { zoneID = 542, artID = { 559 }, x = 0.584, y = 0.84199995, overlay = { "0.58-0.84" }, displayID = 58549, questID = { 36291 } }; --Betsi Boombasket
	[84890] = { zoneID = 542, artID = { 559 }, x = 0.548, y = 0.398, overlay = { "0.54-0.39" }, displayID = 58554, questID = { 36297 } }; --Festerbloom
	[84912] = { zoneID = 542, artID = { 559 }, x = 0.58599997, y = 0.45, overlay = { "0.58-0.45" }, displayID = 58569, questID = { 36298 } }; --Sunderthorn
	[84951] = { zoneID = 542, artID = { 559 }, x = 0.336, y = 0.588, overlay = { "0.33-0.58" }, displayID = 45374, questID = { 36305 } }; --Gobblefin
	[84955] = { zoneID = 542, artID = { 559 }, x = 0.566, y = 0.946, overlay = { "0.56-0.94" }, displayID = 55723, questID = { 36306 } }; --Jiasska the Sporegorger
	[85026] = { zoneID = 542, artID = { 559 }, x = 0.726, y = 0.19600001, overlay = { "0.72-0.19" }, displayID = 58618, questID = { 37358 } }; --Soul-Twister Torek
	[85036] = { zoneID = 542, artID = { 559 }, x = 0.726, y = 0.19399999, overlay = { "0.72-0.19" }, displayID = 60982, questID = { 37360 } }; --Formless Nightmare
	[85037] = { zoneID = 542, artID = { 559 }, x = 0.706, y = 0.24200001, overlay = { "0.70-0.23","0.70-0.24" }, displayID = 61035, questID = { 37361 } }; --Kenos the Unraveler
	[85078] = { zoneID = 542, artID = { 559 }, x = 0.748, y = 0.324, overlay = { "0.73-0.30","0.73-0.31","0.74-0.32" }, displayID = 58638, questID = { 37359 } }; --Voidreaver Urnae
	[85504] = { zoneID = 542, artID = { 559 }, x = 0.384, y = 0.274, overlay = { "0.38-0.27" }, displayID = 59514, questID = { 36470 } }; --Rotcap
	[85520] = { zoneID = 542, artID = { 559 }, x = 0.528, y = 0.548, overlay = { "0.52-0.54" }, displayID = 55425, questID = { 36472 } }; --Swarmleaf
	[86621] = { zoneID = 542, artID = { 559 }, x = 0.736, y = 0.45, overlay = { "0.73-0.45" }, displayID = 18615 }; --Morphed Sentient
	[86724] = { zoneID = 542, artID = { 559 }, x = 0.592, y = 0.15, overlay = { "0.59-0.15" }, displayID = 59886, questID = { 36887 } }; --Hermit Palefur
	[86978] = { zoneID = 542, artID = { 559 }, x = 0.252, y = 0.24200001, overlay = { "0.25-0.24" }, displayID = 20526, questID = { 36943 } }; --Gaze
	[87019] = { zoneID = 542, artID = { 559 }, x = 0.746, y = 0.436, overlay = { "0.74-0.43" }, displayID = 61736, questID = { 37390 } }; --Gluttonous Giant
	[87026] = { zoneID = 542, artID = { 559 }, x = 0.744, y = 0.38799998, overlay = { "0.74-0.38" }, displayID = 60199, questID = { 37391 } }; --Mecha Plunderer
	[87027] = { zoneID = 542, artID = { 559 }, x = 0.71599996, y = 0.33, overlay = { "0.71-0.33" }, displayID = 58740, questID = { 37392 } }; --Shadow Hulk
	[87029] = { zoneID = 542, artID = { 559 }, x = 0.71599996, y = 0.44799998, overlay = { "0.71-0.44" }, displayID = 60145, questID = { 37393 } }; --Giga Sentinel
	[50985] = { zoneID = 543, artID = { 560 }, x = 0.514, y = 0.431, overlay = { "0.42-0.25","0.43-0.55","0.45-0.47","0.47-0.54","0.51-0.43" }, displayID = 61217 }; --Poundfist
	[76473] = { zoneID = 543, artID = { 560 }, x = 0.53400004, y = 0.78199995, overlay = { "0.53-0.78" }, displayID = 17180, questID = { 34726 } }; --Mother Araneae
	[79629] = { zoneID = 543, artID = { 560 }, x = 0.382, y = 0.66199994, overlay = { "0.38-0.66" }, displayID = 55225, questID = { 35910 } }; --Stomper Kreego
	[80371] = { zoneID = 543, artID = { 560 }, x = 0.756, y = 0.426, overlay = { "0.75-0.42" }, displayID = 55711, questID = { 37405 } }; --Typhon
	[80725] = { zoneID = 543, artID = { 560 }, x = 0.412, y = 0.61, overlay = { "0.40-0.60","0.41-0.61" }, displayID = 58882, questID = { 36394 } }; --Sulfurious
	[80868] = { zoneID = 543, artID = { 560 }, x = 0.46, y = 0.508, overlay = { "0.46-0.50" }, displayID = 56082, questID = { 36204 } }; --Glut
	[81038] = { zoneID = 543, artID = { 560 }, x = 0.41799998, y = 0.45599997, overlay = { "0.41-0.45" }, displayID = 55863, questID = { 36391 } }; --Gelgor of the Blue Flame
	[82058] = { zoneID = 543, artID = { 560 }, x = 0.726, y = 0.406, overlay = { "0.72-0.40" }, displayID = 56891, questID = { 37370 } }; --Depthroot
	[82085] = { zoneID = 543, artID = { 560 }, x = 0.4, y = 0.79, overlay = { "0.4-0.79" }, displayID = 57020, questID = { 35335 } }; --Bashiok
	[82311] = { zoneID = 543, artID = { 560 }, x = 0.536, y = 0.44599998, overlay = { "0.53-0.44" }, displayID = 61421, questID = { 35503 } }; --Char the Burning
	[83522] = { zoneID = 543, artID = { 560 }, x = 0.522, y = 0.70199996, overlay = { "0.52-0.70" }, displayID = 57771, questID = { 35908 } }; --Hive Queen Skrikka
	[84406] = { zoneID = 543, artID = { 560 }, x = 0.506, y = 0.532, overlay = { "0.50-0.53" }, displayID = 58334, questID = { 36178 } }; --Mandrakor
	[84431] = { zoneID = 543, artID = { 560 }, x = 0.468, y = 0.43, overlay = { "0.46-0.43" }, displayID = 54327, questID = { 36186 } }; --Greldrok the Cunning
	[85250] = { zoneID = 543, artID = { 560 }, x = 0.574, y = 0.686, overlay = { "0.57-0.68" }, displayID = 55055, questID = { 36387 } }; --Fossilwood the Petrified
	[85264] = { zoneID = 543, artID = { 560 }, x = 0.478, y = 0.41599998, overlay = { "0.47-0.41" }, displayID = 55755, questID = { 36393 } }; --Rolkor
	[85907] = { zoneID = 543, artID = { 560 }, x = 0.39400002, y = 0.746, overlay = { "0.39-0.74" }, displayID = 59205, questID = { 36597 } }; --Berthora
	[85970] = { zoneID = 543, artID = { 560 }, x = 0.376, y = 0.814, overlay = { "0.37-0.81" }, displayID = 59579, questID = { 36600 } }; --Riptar
	[86137] = { zoneID = 543, artID = { 560 }, x = 0.44599998, y = 0.922, overlay = { "0.44-0.92" }, displayID = 59384, questID = { 36656 } }; --Sunclaw
	[86257] = { zoneID = 543, artID = { 560 }, x = 0.692, y = 0.44599998, overlay = { "0.69-0.44" }, displayID = 57964, questID = { 37369 } }; --Basten
	[86258] = { zoneID = 543, artID = { 560 }, x = 0.694, y = 0.44599998, overlay = { "0.69-0.44" }, displayID = 57019, questID = { 37369 } }; --Nultra
	[86259] = { zoneID = 543, artID = { 560 }, x = 0.694, y = 0.44599998, overlay = { "0.69-0.44" }, displayID = 57020, questID = { 37369 } }; --Valstil
	[86266] = { zoneID = 543, artID = { 560 }, x = 0.634, y = 0.308, overlay = { "0.63-0.30" }, displayID = 61588, questID = { 37372 } }; --Venolasix
	[86268] = { zoneID = 543, artID = { 560 }, x = 0.714, y = 0.404, overlay = { "0.56-0.40","0.58-0.41","0.71-0.40" }, displayID = 59427, questID = { 37371 } }; --Alkali
	[86410] = { zoneID = 543, artID = { 560 }, x = 0.65400004, y = 0.608, overlay = { "0.63-0.61","0.64-0.61","0.64-0.60","0.65-0.60" }, displayID = 59571, questID = { 36794 } }; --Sylldross
	[86520] = { zoneID = 543, artID = { 560 }, x = 0.55, y = 0.71, overlay = { "0.53-0.73","0.54-0.72","0.54-0.71","0.55-0.71" }, displayID = 57735, questID = { 36837 } }; --Stompalupagus
	[86562] = { zoneID = 543, artID = { 560 }, x = 0.49, y = 0.33, overlay = { "0.49-0.33" }, displayID = 58895, questID = { 37363 } }; --Maniacal Madgard
	[86566] = { zoneID = 543, artID = { 560 }, x = 0.482, y = 0.21, overlay = { "0.48-0.21" }, displayID = 59693, questID = { 37362 } }; --Defector Dazgo
	[86571] = { zoneID = 543, artID = { 560 }, x = 0.498, y = 0.23799999, overlay = { "0.49-0.23" }, displayID = 55755, questID = { 37366 } }; --Durp the Hated
	[86574] = { zoneID = 543, artID = { 560 }, x = 0.47599998, y = 0.308, overlay = { "0.47-0.30" }, displayID = 59700, questID = { 37367 } }; --Inventor Blammo
	[86577] = { zoneID = 543, artID = { 560 }, x = 0.46, y = 0.278, overlay = { "0.45-0.25","0.45-0.26","0.46-0.27" }, displayID = 59702, questID = { 37365 } }; --Horgg
	[86579] = { zoneID = 543, artID = { 560 }, x = 0.46, y = 0.314, overlay = { "0.45-0.32","0.45-0.33","0.46-0.31" }, displayID = 59703, questID = { 37368 } }; --Blademaster Ro'gor
	[86582] = { zoneID = 543, artID = { 560 }, x = 0.466, y = 0.23, overlay = { "0.45-0.24","0.46-0.23" }, displayID = 59892, questID = { 37364 } }; --Morgo Kain
	[88580] = { zoneID = 543, artID = { 560 }, x = 0.578, y = 0.366, overlay = { "0.57-0.36" }, displayID = 58491, questID = { 37373 } }; --Firestarter Grash
	[88582] = { zoneID = 543, artID = { 560 }, x = 0.59599996, y = 0.32, overlay = { "0.59-0.32" }, displayID = 58756, questID = { 37374 } }; --Swift Onyx Flayer
	[88583] = { zoneID = 543, artID = { 560 }, x = 0.59599996, y = 0.43, overlay = { "0.59-0.43" }, displayID = 57964, questID = { 37375 } }; --Grove Warden Yal
	[88586] = { zoneID = 543, artID = { 560 }, x = 0.616, y = 0.39200002, overlay = { "0.61-0.39" }, displayID = 55211, questID = { 37376 } }; --Mogamago
	[88672] = { zoneID = 543, artID = { 560 }, x = 0.548, y = 0.462, overlay = { "0.54-0.46" }, displayID = 60623, questID = { 37377 } }; --Hunter Bal'ra
	[78260] = { zoneID = 549, artID = { 562 }, x = 0.438, y = 0.758, overlay = { "0.41-0.71","0.41-0.75","0.42-0.73","0.42-0.72","0.43-0.75" }, displayID = 54399, questID = { 37412 } }; --King Slime
	[78269] = { zoneID = 549, artID = { 562 }, x = 0.588, y = 0.374, overlay = { "0.48-0.37","0.49-0.37","0.50-0.38","0.52-0.36","0.52-0.35","0.52-0.33","0.52-0.37","0.52-0.34","0.53-0.35","0.53-0.32","0.53-0.38","0.53-0.36","0.53-0.33","0.54-0.30","0.54-0.31","0.54-0.37","0.54-0.32","0.54-0.38","0.55-0.32","0.55-0.38","0.55-0.33","0.55-0.34","0.55-0.37","0.56-0.37","0.56-0.35","0.57-0.36","0.58-0.37" }, displayID = 54318, questID = { 37413 } }; --Gnarljaw
	[50981] = { zoneID = 550, artID = { 567 }, x = 0.84199995, y = 0.636, overlay = { "0.66-0.44","0.66-0.43","0.67-0.43","0.72-0.53","0.74-0.32","0.75-0.32","0.76-0.30","0.79-0.55","0.79-0.56","0.8-0.55","0.84-0.63" }, displayID = 61220 }; --Luk'hok
	[50990] = { zoneID = 550, artID = { 567 }, x = 0.644, y = 0.2, overlay = { "0.5-0.34","0.54-0.35","0.55-0.35","0.60-0.32","0.60-0.31","0.62-0.14","0.62-0.15","0.62-0.18","0.64-0.2" }, displayID = 61219 }; --Nakk the Thunderer
	[78161] = { zoneID = 550, artID = { 567 }, x = 0.87, y = 0.548, overlay = { "0.87-0.54" }, displayID = 60442, questID = { 34862 } }; --Hyperious
	[79024] = { zoneID = 550, artID = { 567 }, x = 0.826, y = 0.76199996, overlay = { "0.82-0.76" }, displayID = 54837, questID = { 34645 } }; --Warmaster Blugthol
	[79725] = { zoneID = 550, artID = { 567 }, x = 0.346, y = 0.77, overlay = { "0.34-0.76","0.34-0.77" }, displayID = 55286, questID = { 34727,38756 } }; --Captain Ironbeard
	[80057] = { zoneID = 550, artID = { 567 }, x = 0.756, y = 0.65199995, overlay = { "0.75-0.65" }, displayID = 55683, questID = { 36128 } }; --Soulfang
	[80122] = { zoneID = 550, artID = { 567 }, x = 0.436, y = 0.77599996, overlay = { "0.43-0.77" }, displayID = 55460, questID = { 34725 } }; --Gaz'orda
	[80370] = { zoneID = 550, artID = { 567 }, x = 0.52599996, y = 0.9, overlay = { "0.51-0.89","0.52-0.89","0.52-0.9" }, displayID = 55710, questID = { 37408 } }; --Lernaea
	[82486] = { zoneID = 550, artID = { 567 }, x = 0.888, y = 0.412, overlay = { "0.88-0.41" }, displayID = 57034, questID = { 35623 } }; --Explorer Nozzand
	[82755] = { zoneID = 550, artID = { 567 }, x = 0.736, y = 0.578, overlay = { "0.73-0.57" }, displayID = 57245, questID = { 35712 } }; --Redclaw the Feral
	[82758] = { zoneID = 550, artID = { 567 }, x = 0.66800004, y = 0.512, overlay = { "0.66-0.51" }, displayID = 60416, questID = { 35714 } }; --Greatfeather
	[82764] = { zoneID = 550, artID = { 567 }, x = 0.522, y = 0.55799997, overlay = { "0.52-0.55" }, displayID = 57251, questID = { 35715 } }; --Gar'lua
	[82778] = { zoneID = 550, artID = { 567 }, x = 0.666, y = 0.566, overlay = { "0.66-0.56" }, displayID = 53744, questID = { 35717 } }; --Gnarlhoof the Rabid
	[82826] = { zoneID = 550, artID = { 567 }, x = 0.77, y = 0.64199996, overlay = { "0.76-0.64","0.77-0.64" }, displayID = 59990, questID = { 35735 } }; --Berserk T-300 Series Mark II
	[82899] = { zoneID = 550, artID = { 567 }, x = 0.84599996, y = 0.536, overlay = { "0.84-0.53" }, displayID = 57365, questID = { 35778 } }; --Ancient Blademaster
	[82912] = { zoneID = 550, artID = { 567 }, x = 0.894, y = 0.726, overlay = { "0.89-0.72" }, displayID = 57383, questID = { 36051,35784 } }; --Grizzlemaw
	[82975] = { zoneID = 550, artID = { 567 }, x = 0.748, y = 0.118, overlay = { "0.74-0.11" }, displayID = 31786, questID = { 35836 } }; --Fangler
	[83401] = { zoneID = 550, artID = { 567 }, x = 0.47599998, y = 0.706, overlay = { "0.47-0.70" }, displayID = 9595, questID = { 35865 } }; --Netherspawn
	[83409] = { zoneID = 550, artID = { 567 }, x = 0.45400003, y = 0.474, overlay = { "0.39-0.49","0.39-0.5","0.40-0.49","0.41-0.51","0.41-0.50","0.42-0.50","0.42-0.49","0.43-0.49","0.44-0.48","0.45-0.47" }, displayID = 60197, questID = { 35875 } }; --Ophiis
	[83428] = { zoneID = 550, artID = { 567 }, x = 0.706, y = 0.292, overlay = { "0.70-0.29" }, displayID = 57702, questID = { 35877 } }; --Windcaller Korast
	[83483] = { zoneID = 550, artID = { 567 }, x = 0.698, y = 0.42, overlay = { "0.69-0.41","0.69-0.42" }, displayID = 57735, questID = { 35893 } }; --Flinthide
	[83509] = { zoneID = 550, artID = { 567 }, x = 0.932, y = 0.282, overlay = { "0.93-0.28" }, displayID = 57758, questID = { 35898 } }; --Gorepetal
	[83526] = { zoneID = 550, artID = { 567 }, x = 0.578, y = 0.83800006, overlay = { "0.57-0.83" }, displayID = 18279, questID = { 35900 } }; --Ru'klaa
	[83542] = { zoneID = 550, artID = { 567 }, x = 0.608, y = 0.47599998, overlay = { "0.60-0.47" }, displayID = 57788, questID = { 35912 } }; --Sean Whitesea
	[83591] = { zoneID = 550, artID = { 567 }, x = 0.65, y = 0.39200002, overlay = { "0.65-0.39" }, displayID = 56062, questID = { 35920 } }; --Tura'aka
	[83603] = { zoneID = 550, artID = { 567 }, x = 0.806, y = 0.306, overlay = { "0.80-0.30" }, displayID = 57398, questID = { 35923 } }; --Hunter Blacktooth
	[83634] = { zoneID = 550, artID = { 567 }, x = 0.548, y = 0.612, overlay = { "0.54-0.61" }, displayID = 57846, questID = { 35931 } }; --Scout Pokhar
	[83643] = { zoneID = 550, artID = { 567 }, x = 0.812, y = 0.6, overlay = { "0.81-0.6" }, displayID = 57848, questID = { 35932 } }; --Malroc Stonesunder
	[83680] = { zoneID = 550, artID = { 567 }, x = 0.618, y = 0.69, overlay = { "0.61-0.69" }, displayID = 57878, questID = { 35943 } }; --Outrider Duretha
	[84263] = { zoneID = 550, artID = { 567 }, x = 0.83800006, y = 0.368, overlay = { "0.83-0.37","0.83-0.36" }, displayID = 58234, questID = { 36159 } }; --Graveltooth
	[84435] = { zoneID = 550, artID = { 567 }, x = 0.45599997, y = 0.152, overlay = { "0.45-0.15" }, displayID = 19658, questID = { 36229 } }; --Mr. Pinchy Sr.
	[86729] = { zoneID = 550, artID = { 567 }, x = 0.602, y = 0.38599998, overlay = { "0.60-0.38" }, displayID = 56848, reset = true }; --Direhoof
	[86732] = { zoneID = 550, artID = { 567 }, x = 0.66, y = 0.244, overlay = { "0.61-0.12","0.62-0.17","0.62-0.14","0.62-0.15","0.63-0.19","0.64-0.2","0.65-0.21","0.65-0.22","0.65-0.24","0.66-0.24" }, displayID = 58621, reset = true }; --Bergruu
	[86743] = { zoneID = 550, artID = { 567 }, x = 0.64199996, y = 0.304, overlay = { "0.64-0.30" }, displayID = 54470, reset = true }; --Dekorhan
	[86750] = { zoneID = 550, artID = { 567 }, x = 0.64599997, y = 0.272, overlay = { "0.49-0.38","0.5-0.38","0.50-0.37","0.50-0.4","0.50-0.40","0.50-0.38","0.51-0.36","0.51-0.40","0.51-0.39","0.52-0.40","0.52-0.35","0.53-0.35","0.53-0.39","0.54-0.34","0.55-0.33","0.55-0.38","0.55-0.37","0.56-0.33","0.56-0.36","0.57-0.31","0.57-0.35","0.58-0.35","0.58-0.30","0.58-0.34","0.59-0.34","0.59-0.29","0.6-0.32","0.60-0.32","0.60-0.28","0.60-0.27","0.61-0.25","0.61-0.31","0.61-0.22","0.62-0.30","0.62-0.22","0.63-0.29","0.63-0.24","0.63-0.28","0.64-0.28","0.64-0.29","0.64-0.26","0.64-0.27" }, displayID = 61652, reset = true }; --Thek'talon
	[86771] = { zoneID = 550, artID = { 567 }, x = 0.482, y = 0.22600001, overlay = { "0.48-0.22" }, displayID = 60220, reset = true }; --Gagrog the Brutal
	[86774] = { zoneID = 550, artID = { 567 }, x = 0.516, y = 0.16, overlay = { "0.51-0.16" }, displayID = 59928, reset = true }; --Aogexon
	[86835] = { zoneID = 550, artID = { 567 }, x = 0.41599998, y = 0.45, overlay = { "0.41-0.44","0.41-0.45" }, displayID = 61274, reset = true }; --Xelganak
	[86959] = { zoneID = 550, artID = { 567 }, x = 0.458, y = 0.348, overlay = { "0.45-0.34" }, displayID = 60200, questID = { 37399 } }; --Karosh Blackwind
	[87234] = { zoneID = 550, artID = { 567 }, x = 0.43, y = 0.36200002, overlay = { "0.43-0.36" }, displayID = 60198, questID = { 37400 } }; --Brutag Grimblade
	[87239] = { zoneID = 550, artID = { 567 }, x = 0.426, y = 0.36200002, overlay = { "0.42-0.36" }, displayID = 60253, questID = { 37473 } }; --Krahl Deadeye
	[87344] = { zoneID = 550, artID = { 567 }, x = 0.426, y = 0.36200002, overlay = { "0.42-0.36" }, displayID = 60268, questID = { 37472 } }; --Gortag Steelgrip
	[87666] = { zoneID = 550, artID = { 567 }, x = 0.342, y = 0.514, overlay = { "0.34-0.51" }, displayID = 61301, reset = true }; --Mu'gra
	[87788] = { zoneID = 550, artID = { 567 }, x = 0.38799998, y = 0.23, overlay = { "0.35-0.21","0.35-0.20","0.35-0.22","0.35-0.23","0.36-0.20","0.36-0.23","0.37-0.19","0.37-0.24","0.37-0.20","0.38-0.21","0.38-0.24","0.38-0.22","0.38-0.23" }, displayID = 61423, questID = { 37395 } }; --Durg Spinecrusher
	[87837] = { zoneID = 550, artID = { 567 }, x = 0.398, y = 0.132, overlay = { "0.38-0.15","0.38-0.14","0.39-0.15","0.39-0.13" }, displayID = 57863, questID = { 37396 } }; --Bonebreaker
	[87846] = { zoneID = 550, artID = { 567 }, x = 0.414, y = 0.14, overlay = { "0.39-0.14","0.41-0.14" }, displayID = 57863, questID = { 37397 } }; --Pit Slayer
	[88208] = { zoneID = 550, artID = { 567 }, x = 0.582, y = 0.184, overlay = { "0.58-0.18" }, displayID = 48084, questID = { 37637 } }; --Pit Beast
	[88210] = { zoneID = 550, artID = { 567 }, x = 0.582, y = 0.12, overlay = { "0.58-0.12" }, displayID = 61512, questID = { 37398 } }; --Krud the Eviscerator
	[88951] = { zoneID = 550, artID = { 567 }, x = 0.372, y = 0.39, overlay = { "0.37-0.39" }, displayID = 61300, reset = true }; --Vileclaw
	[98198] = { zoneID = 550, artID = { 567 }, x = 0.262, y = 0.342, overlay = { "0.26-0.34" }, displayID = 60608, questID = { 98198 } }; --Rukdug
	[98199] = { zoneID = 550, artID = { 567 }, x = 0.285, y = 0.303, overlay = { "0.28-0.30" }, displayID = 57973, questID = { 98199 } }; --Pugg
	[98200] = { zoneID = 550, artID = { 567 }, x = 0.23799999, y = 0.379, overlay = { "0.23-0.37" }, displayID = 65699, questID = { 98200 } }; --Guk
	[71864] = { zoneID = 554, artID = { 571 }, x = 0.592, y = 0.48400003, overlay = { "0.58-0.48","0.59-0.48" }, displayID = 40976 }; --Spelurk
	[71919] = { zoneID = 554, artID = { 571 }, x = 0.378, y = 0.77199996, overlay = { "0.37-0.77" }, displayID = 44361 }; --Zhu-Gon the Sour
	[72045] = { zoneID = 554, artID = { 571 }, x = 0.252, y = 0.36, overlay = { "0.25-0.35","0.25-0.36" }, displayID = 44784 }; --Chelon
	[72048] = { zoneID = 554, artID = { 571 }, x = 0.606, y = 0.878, overlay = { "0.60-0.87" }, displayID = 49277 }; --Rattleskew
	[72049] = { zoneID = 554, artID = { 571 }, x = 0.438, y = 0.696, overlay = { "0.43-0.7","0.43-0.69" }, displayID = 39588 }; --Cranegnasher
	[72193] = { zoneID = 554, artID = { 571 }, x = 0.338, y = 0.85800004, overlay = { "0.33-0.85" }, displayID = 29487 }; --Karkanos
	[72245] = { zoneID = 554, artID = { 571 }, x = 0.472, y = 0.88, overlay = { "0.47-0.87","0.47-0.88" }, displayID = 51015 }; --Zesqua
	[72775] = { zoneID = 554, artID = { 571 }, x = 0.67, y = 0.65599996, overlay = { "0.62-0.76","0.63-0.73","0.63-0.72","0.64-0.74","0.65-0.69","0.65-0.70","0.66-0.67","0.66-0.65","0.66-0.66","0.67-0.65" }, displayID = 48112 }; --Bufo
	[72808] = { zoneID = 554, artID = { 571 }, x = 0.542, y = 0.428, overlay = { "0.54-0.42" }, displayID = 51132 }; --Tsavo'ka
	[72909] = { zoneID = 554, artID = { 571 }, x = 0.426, y = 0.75, overlay = { "0.30-0.71","0.30-0.72","0.31-0.70","0.31-0.74","0.31-0.76","0.32-0.77","0.32-0.78","0.32-0.70","0.33-0.70","0.33-0.79","0.34-0.71","0.34-0.70","0.34-0.79","0.35-0.7","0.35-0.8","0.35-0.69","0.36-0.69","0.36-0.80","0.36-0.81","0.37-0.7","0.37-0.82","0.37-0.69","0.38-0.82","0.39-0.69","0.40-0.82","0.40-0.79","0.40-0.81","0.40-0.69","0.41-0.80","0.41-0.7","0.41-0.77","0.41-0.71","0.41-0.72","0.41-0.73","0.41-0.78","0.41-0.76","0.42-0.73","0.42-0.74","0.42-0.76","0.42-0.75" }, displayID = 46461 }; --Gu'chi the Swarmbringer
	[72970] = { zoneID = 554, artID = { 571 }, x = 0.632, y = 0.612, overlay = { "0.61-0.63","0.62-0.62","0.62-0.63","0.63-0.61" }, displayID = 51013 }; --Golganarr
	[73158] = { zoneID = 554, artID = { 571 }, x = 0.44799998, y = 0.536, overlay = { "0.29-0.50","0.29-0.45","0.29-0.61","0.29-0.66","0.3-0.62","0.30-0.58","0.30-0.43","0.30-0.50","0.30-0.61","0.30-0.64","0.30-0.66","0.30-0.44","0.30-0.52","0.30-0.62","0.30-0.45","0.30-0.5","0.31-0.66","0.31-0.62","0.31-0.79","0.31-0.65","0.31-0.4","0.32-0.52","0.32-0.79","0.32-0.48","0.32-0.80","0.32-0.49","0.33-0.48","0.33-0.39","0.36-0.39","0.36-0.40","0.36-0.83","0.37-0.41","0.38-0.41","0.39-0.43","0.39-0.68","0.39-0.67","0.4-0.39","0.40-0.40","0.40-0.43","0.40-0.39","0.40-0.42","0.41-0.40","0.41-0.42","0.42-0.70","0.42-0.66","0.42-0.68","0.42-0.67","0.42-0.7","0.43-0.55","0.44-0.61","0.44-0.54","0.44-0.55","0.44-0.53" }, displayID = 51264 }; --Emerald Gander
	[73160] = { zoneID = 554, artID = { 571 }, x = 0.44599998, y = 0.438, overlay = { "0.27-0.51","0.27-0.6","0.28-0.40","0.28-0.59","0.28-0.47","0.29-0.43","0.29-0.44","0.29-0.71","0.29-0.72","0.29-0.45","0.29-0.7","0.30-0.47","0.30-0.70","0.31-0.57","0.31-0.43","0.31-0.58","0.32-0.44","0.33-0.38","0.33-0.61","0.33-0.37","0.33-0.62","0.34-0.71","0.34-0.72","0.35-0.41","0.35-0.67","0.36-0.67","0.36-0.70","0.39-0.38","0.41-0.39","0.43-0.43","0.44-0.43" }, displayID = 51284 }; --Ironfur Steelhorn
	[73161] = { zoneID = 554, artID = { 571 }, x = 0.266, y = 0.72400004, overlay = { "0.20-0.43","0.21-0.44","0.21-0.64","0.21-0.66","0.22-0.42","0.22-0.44","0.22-0.61","0.22-0.53","0.22-0.67","0.22-0.45","0.22-0.65","0.22-0.66","0.23-0.47","0.23-0.63","0.23-0.68","0.23-0.69","0.23-0.49","0.23-0.60","0.23-0.53","0.23-0.59","0.23-0.62","0.23-0.54","0.24-0.49","0.24-0.7","0.24-0.57","0.24-0.59","0.25-0.58","0.25-0.50","0.25-0.52","0.25-0.53","0.25-0.55","0.25-0.56","0.25-0.57","0.25-0.54","0.25-0.71","0.26-0.50","0.26-0.72" }, displayID = 51127 }; --Great Turtle Furyshell
	[73163] = { zoneID = 554, artID = { 571 }, x = 0.53, y = 0.588, overlay = { "0.25-0.46","0.26-0.69","0.27-0.61","0.27-0.69","0.28-0.61","0.28-0.62","0.29-0.43","0.29-0.63","0.29-0.64","0.29-0.73","0.30-0.36","0.31-0.75","0.33-0.46","0.33-0.45","0.34-0.74","0.34-0.73","0.36-0.73","0.44-0.66","0.44-0.65","0.50-0.46","0.53-0.58" }, displayID = 51135 }; --Imperial Python
	[73166] = { zoneID = 554, artID = { 571 }, x = 0.688, y = 0.748, overlay = { "0.17-0.52","0.17-0.72","0.18-0.54","0.18-0.75","0.18-0.64","0.18-0.57","0.18-0.58","0.19-0.75","0.20-0.77","0.20-0.48","0.20-0.47","0.20-0.70","0.21-0.36","0.21-0.77","0.21-0.46","0.21-0.64","0.21-0.32","0.21-0.63","0.21-0.35","0.22-0.31","0.22-0.30","0.23-0.34","0.23-0.35","0.23-0.28","0.23-0.36","0.24-0.75","0.25-0.74","0.26-0.73","0.27-0.75","0.27-0.74","0.27-0.79","0.28-0.79","0.28-0.81","0.30-0.31","0.35-0.87","0.36-0.86","0.38-0.86","0.38-0.87","0.40-0.90","0.44-0.89","0.45-0.90","0.52-0.86","0.61-0.83","0.63-0.79","0.65-0.77","0.65-0.78","0.67-0.77","0.67-0.78","0.68-0.74","0.68-0.77" }, displayID = 51146 }; --Monstrous Spineclaw
	[73167] = { zoneID = 554, artID = { 571 }, x = 0.744, y = 0.436, overlay = { "0.57-0.57","0.57-0.58","0.58-0.57","0.64-0.40","0.65-0.57","0.65-0.36","0.66-0.58","0.66-0.59","0.66-0.57","0.67-0.58","0.67-0.57","0.68-0.58","0.69-0.57","0.7-0.58","0.72-0.54","0.73-0.50","0.73-0.53","0.74-0.41","0.74-0.43" }, displayID = 51161 }; --Huolon
	[73169] = { zoneID = 554, artID = { 571 }, x = 0.536, y = 0.83, overlay = { "0.53-0.82","0.53-0.83" }, displayID = 51210 }; --Jakur of Ordon
	[73170] = { zoneID = 554, artID = { 571 }, x = 0.576, y = 0.766, overlay = { "0.57-0.76" }, displayID = 51211 }; --Watcher Osu
	[73171] = { zoneID = 554, artID = { 571 }, x = 0.71, y = 0.472, overlay = { "0.60-0.48","0.61-0.46","0.61-0.45","0.62-0.44","0.63-0.43","0.64-0.41","0.64-0.42","0.65-0.42","0.65-0.60","0.65-0.59","0.66-0.59","0.66-0.42","0.66-0.58","0.67-0.57","0.67-0.42","0.67-0.58","0.67-0.41","0.68-0.44","0.68-0.54","0.68-0.56","0.68-0.43","0.69-0.44","0.69-0.58","0.69-0.45","0.69-0.54","0.69-0.55","0.69-0.43","0.70-0.45","0.70-0.52","0.70-0.53","0.70-0.49","0.70-0.50","0.70-0.51","0.70-0.47","0.70-0.48","0.71-0.44","0.71-0.46","0.71-0.47" }, displayID = 51202 }; --Champion of the Black Flame
	[73172] = { zoneID = 554, artID = { 571 }, x = 0.556, y = 0.38, overlay = { "0.40-0.26","0.40-0.25","0.40-0.27","0.43-0.33","0.44-0.33","0.44-0.35","0.46-0.39","0.47-0.40","0.48-0.36","0.48-0.37","0.55-0.38" }, displayID = 51193 }; --Flintlord Gairan
	[73173] = { zoneID = 554, artID = { 571 }, x = 0.44599998, y = 0.254, overlay = { "0.43-0.26","0.44-0.25","0.44-0.26" }, displayID = 51194 }; --Urdur the Cauterizer
	[73174] = { zoneID = 554, artID = { 571 }, x = 0.58, y = 0.256, overlay = { "0.48-0.32","0.48-0.33","0.49-0.33","0.49-0.23","0.5-0.23","0.50-0.24","0.50-0.22","0.50-0.23","0.51-0.22","0.55-0.35","0.55-0.34","0.56-0.35","0.56-0.24","0.56-0.36","0.57-0.24","0.57-0.27","0.57-0.26","0.58-0.25" }, displayID = 51203 }; --Archiereus of Flame
	[73175] = { zoneID = 554, artID = { 571 }, x = 0.546, y = 0.538, overlay = { "0.54-0.52","0.54-0.53" }, displayID = 51192 }; --Cinderfall
	[73277] = { zoneID = 554, artID = { 571 }, x = 0.676, y = 0.442, overlay = { "0.67-0.44" }, displayID = 51206 }; --Leafmender
	[73279] = { zoneID = 554, artID = { 571 }, x = 0.806, y = 0.342, overlay = { "0.13-0.36","0.14-0.37","0.14-0.58","0.14-0.29","0.14-0.52","0.14-0.43","0.14-0.44","0.14-0.59","0.14-0.56","0.15-0.62","0.15-0.26","0.16-0.63","0.16-0.23","0.16-0.22","0.17-0.20","0.17-0.67","0.18-0.68","0.19-0.70","0.19-0.72","0.19-0.14","0.20-0.74","0.20-0.75","0.21-0.76","0.22-0.77","0.22-0.78","0.23-0.08","0.24-0.82","0.26-0.85","0.27-0.05","0.28-0.87","0.28-0.03","0.29-0.87","0.31-0.89","0.32-0.9","0.36-0.93","0.39-0.95","0.4-0.96","0.40-0.96","0.41-0.03","0.44-0.97","0.45-0.03","0.49-0.97","0.50-0.97","0.57-0.06","0.59-0.96","0.59-0.97","0.61-0.96","0.63-0.95","0.65-0.93","0.71-0.87","0.74-0.17","0.76-0.21","0.78-0.25","0.80-0.34" }, displayID = 37338 }; --Evermaw
	[73281] = { zoneID = 554, artID = { 571 }, x = 0.26, y = 0.234, overlay = { "0.26-0.23" }, displayID = 51213 }; --Dread Ship Vazuvius
	[73282] = { zoneID = 554, artID = { 571 }, x = 0.65, y = 0.274, overlay = { "0.63-0.3","0.64-0.27","0.64-0.29","0.64-0.28","0.65-0.27" }, displayID = 51214 }; --Garnia
	[73293] = { zoneID = 554, artID = { 571 }, x = 0.428, y = 0.59400004, overlay = { "0.35-0.52","0.4-0.63","0.41-0.47","0.42-0.59" }, friendly = { "A","H" }, displayID = 37498 }; --Whizzig
	[73666] = { zoneID = 554, artID = { 571 }, x = 0.346, y = 0.316, overlay = { "0.34-0.31","0.34-0.30","0.34-0.29","0.34-0.3" }, displayID = 51203 }; --Archiereus of Flame
	[73704] = { zoneID = 554, artID = { 571 }, x = 0.71199995, y = 0.826, overlay = { "0.71-0.82" }, displayID = 51813 }; --Stinkbraid
	[72769] = { zoneID = 555, artID = { 572 }, x = 0.748, y = 0.346, overlay = { "0.48-0.61","0.48-0.62","0.48-0.63","0.52-0.72","0.53-0.71","0.54-0.68","0.56-0.28","0.56-0.30","0.62-0.33","0.62-0.38","0.62-0.35","0.62-0.37","0.64-0.47","0.64-0.63","0.65-0.64","0.69-0.61","0.70-0.62","0.72-0.28","0.73-0.30","0.74-0.32","0.74-0.33","0.74-0.34" }, displayID = 51316 }; --Spirit of Jadefire
	[73157] = { zoneID = 555, artID = { 572 }, x = 0.5, y = 0.294, overlay = { "0.42-0.33","0.42-0.32","0.43-0.31","0.43-0.34","0.44-0.3","0.44-0.32","0.44-0.31","0.45-0.31","0.45-0.32","0.45-0.21","0.46-0.31","0.46-0.33","0.46-0.32","0.47-0.34","0.47-0.32","0.47-0.36","0.48-0.30","0.49-0.35","0.49-0.27","0.5-0.29" }, displayID = 51118 }; --Rock Moss
	[96323] = { zoneID = {
				[579] = { x = 0.728, y = 0.366, overlay = { "0.68-0.39","0.68-0.4","0.69-0.39","0.70-0.38","0.71-0.37","0.72-0.35","0.72-0.36","0.73-0.35","0.73-0.36","0.74-0.35" } };
				[580] = { x = 0.728, y = 0.366, overlay = { "0.68-0.39","0.68-0.4","0.69-0.39","0.70-0.38","0.71-0.37","0.72-0.35","0.72-0.36","0.73-0.35","0.73-0.36","0.74-0.35" } };
				[581] = { x = 0.728, y = 0.366, overlay = { "0.68-0.39","0.68-0.4","0.69-0.39","0.70-0.38","0.71-0.37","0.72-0.35","0.72-0.36","0.73-0.35","0.73-0.36","0.74-0.35" } };
				[582] = { x = 0.74, y = 0.354, overlay = { "0.68-0.39","0.68-0.4","0.69-0.39","0.70-0.38","0.71-0.37","0.72-0.35","0.72-0.36","0.73-0.35","0.73-0.36","0.74-0.35" } };
				[585] = { x = 0.572, y = 0.854, overlay = { "0.55-0.87","0.55-0.88","0.56-0.86","0.56-0.87","0.56-0.85","0.57-0.85","0.57-0.87","0.57-0.88" } };
				[586] = { x = 0.572, y = 0.854, overlay = { "0.55-0.87","0.55-0.88","0.56-0.86","0.56-0.87","0.56-0.85","0.57-0.85","0.57-0.87","0.57-0.88" } };
				[587] = { x = 0.572, y = 0.854, overlay = { "0.55-0.87","0.55-0.88","0.56-0.86","0.56-0.87","0.56-0.85","0.57-0.85","0.57-0.87","0.57-0.88" } };
				[590] = { x = 0.576, y = 0.888, overlay = { "0.55-0.87","0.55-0.88","0.56-0.86","0.56-0.87","0.56-0.85","0.57-0.85","0.57-0.87","0.57-0.88" } };
			  }, displayID = 65160, questID = { 39617 } }; --Arachnis
	[82876] = { zoneID = 588, artID = { 611 }, x = 0.45599997, y = 0.76, overlay = { "0.45-0.79","0.45-0.76" }, friendly = { "A" }, displayID = 59096 }; --Grand Marshal Tremblade
	[82877] = { zoneID = 588, artID = { 611 }, x = 0.482, y = 0.256, overlay = { "0.46-0.21","0.48-0.28","0.48-0.30","0.48-0.25" }, friendly = { "H" }, displayID = 58184 }; --High Warlord Volrath
	[82878] = { zoneID = 588, artID = { 611 }, x = 0.45599997, y = 0.76, overlay = { "0.45-0.79","0.45-0.76" }, friendly = { "A" }, displayID = 61636 }; --Marshal Gabriel
	[82880] = { zoneID = 588, artID = { 611 }, x = 0.45400003, y = 0.758, overlay = { "0.45-0.79","0.45-0.75" }, friendly = { "A" }, displayID = 59960 }; --Marshal Karsh Stormforge
	[82882] = { zoneID = 588, artID = { 611 }, x = 0.48400003, y = 0.262, overlay = { "0.46-0.21","0.48-0.26" }, friendly = { "H" }, displayID = 59969 }; --General Aevd
	[82883] = { zoneID = 588, artID = { 611 }, x = 0.48, y = 0.26, overlay = { "0.46-0.21","0.48-0.26" }, friendly = { "H" }, displayID = 59146 }; --Warlord Noktyn
	[83683] = { zoneID = 588, artID = { 611 }, x = 0.308, y = 0.306, overlay = { "0.30-0.31","0.30-0.30" }, displayID = 56932 }; --Mandragoraster
	[83691] = { zoneID = 588, artID = { 611 }, x = 0.598, y = 0.59, overlay = { "0.58-0.58","0.59-0.58","0.59-0.59" }, displayID = 59046 }; --Panthora
	[83713] = { zoneID = 588, artID = { 611 }, x = 0.65599996, y = 0.692, overlay = { "0.46-0.71","0.49-0.53","0.65-0.69" }, displayID = 60821 }; --Titarus
	[83819] = { zoneID = 588, artID = { 611 }, x = 0.628, y = 0.29, overlay = { "0.61-0.30","0.62-0.29" }, displayID = 57974 }; --Brickhouse
	[84110] = { zoneID = 588, artID = { 611 }, x = 0.37, y = 0.67, overlay = { "0.37-0.66","0.37-0.67" }, displayID = 58134 }; --Korthall Soulgorger
	[84196] = { zoneID = 588, artID = { 611 }, x = 0.44599998, y = 0.53, overlay = { "0.35-0.60","0.35-0.66","0.37-0.55","0.38-0.56","0.38-0.61","0.38-0.62","0.39-0.64","0.39-0.65","0.42-0.59","0.43-0.57","0.44-0.53" }, displayID = 24925 }; --Web-wrapped Soldier
	[84465] = { zoneID = 588, artID = { 611 }, x = 0.648, y = 0.71599996, overlay = { "0.55-0.75","0.56-0.72","0.58-0.65","0.58-0.72","0.58-0.66","0.60-0.69","0.62-0.72","0.63-0.69","0.64-0.71" }, friendly = { "A","H" }, displayID = 54287 }; --Leaping Gorger
	[84746] = { zoneID = 588, artID = { 611 }, x = 0.616, y = 0.33400002, overlay = { "0.54-0.32","0.58-0.29","0.58-0.32","0.60-0.3","0.61-0.23","0.61-0.33" }, displayID = 53490 }; --Captured Gor'vosh Stoneshaper
	[84854] = { zoneID = 588, artID = { 611 }, x = 0.38799998, y = 0.396, overlay = { "0.30-0.3","0.31-0.31","0.31-0.34","0.35-0.35","0.36-0.35","0.37-0.38","0.37-0.36","0.38-0.39","0.38-0.38" }, friendly = { "A","H" }, displayID = 58535 }; --Slippery Slime
	[84875] = { zoneID = 588, artID = { 611 }, x = 0.34, y = 0.50200003, overlay = { "0.34-0.50" }, displayID = 61521 }; --Ancient Inferno
	[84893] = { zoneID = 588, artID = { 611 }, x = 0.35799998, y = 0.532, overlay = { "0.34-0.53","0.35-0.53" }, displayID = 52698 }; --Goregore
	[84904] = { zoneID = 588, artID = { 611 }, x = 0.342, y = 0.47, overlay = { "0.31-0.49","0.32-0.47","0.32-0.46","0.33-0.46","0.34-0.46","0.34-0.47" }, displayID = 58566 }; --Oraggro
	[84926] = { zoneID = 588, artID = { 611 }, x = 0.38, y = 0.506, overlay = { "0.31-0.50","0.32-0.46","0.32-0.47","0.33-0.52","0.33-0.47","0.34-0.47","0.34-0.52","0.35-0.53","0.36-0.50","0.36-0.49","0.36-0.48","0.37-0.47","0.37-0.52","0.38-0.49","0.38-0.50" }, friendly = { "A","H" }, displayID = 0 }; --Burning Power
	[85763] = { zoneID = 588, artID = { 611 }, x = 0.59400004, y = 0.374, overlay = { "0.55-0.38","0.55-0.39","0.56-0.38","0.56-0.43","0.56-0.39","0.56-0.44","0.57-0.40","0.57-0.41","0.58-0.40","0.58-0.45","0.58-0.44","0.58-0.41","0.59-0.37" }, displayID = 59148 }; --Cursed Ravager
	[85766] = { zoneID = 588, artID = { 611 }, x = 0.58599997, y = 0.42200002, overlay = { "0.58-0.42" }, displayID = 59468 }; --Cursed Sharptalon
	[85767] = { zoneID = 588, artID = { 611 }, x = 0.588, y = 0.38799998, overlay = { "0.55-0.42","0.58-0.38" }, displayID = 59473 }; --Cursed Harbinger
	[85771] = { zoneID = 588, artID = { 611 }, x = 0.598, y = 0.432, overlay = { "0.59-0.42","0.59-0.43" }, displayID = 59472 }; --Elder Darkweaver Kath
	[87362] = { zoneID = 588, artID = { 611 }, x = 0.498, y = 0.366, overlay = { "0.47-0.69","0.47-0.28","0.47-0.30","0.48-0.58","0.49-0.36" }, displayID = 46574 }; --Gibby
	[91921] = { zoneID = 588, artID = { 611 }, x = 0.54, y = 0.58, overlay = { "0.54-0.58" }, displayID = 59296 }; --Wyrmple
	[94113] = { zoneID = 588, artID = { 611 }, x = 0.41799998, y = 0.46400002, overlay = { "0.41-0.46" }, displayID = 63877 }; --Rukmaz
	[77081] = { zoneID = 617, artID = { 640 }, x = 0.354, y = 0.374, displayID = 53656 }; --The Lanticore
	[123087] = { zoneID = 626, artID = { 649 }, x = 0.478, y = 0.288, overlay = { "0.44-0.25","0.45-0.26","0.45-0.27","0.46-0.27","0.47-0.28" }, friendly = { "A","H" }, displayID = 78148 }; --Al'Abas
	[116041] = { zoneID = {
				[628] = { x = 0.79800004, y = 0.84800005, overlay = { "0.28-0.46","0.29-0.45","0.29-0.44","0.3-0.42","0.3-0.43","0.30-0.46","0.30-0.42","0.31-0.42","0.31-0.43","0.32-0.43","0.33-0.43","0.33-0.44","0.34-0.43","0.35-0.43","0.36-0.43","0.37-0.43","0.37-0.51","0.37-0.44","0.37-0.42","0.38-0.42","0.38-0.45","0.39-0.50","0.39-0.51","0.39-0.43","0.41-0.51","0.41-0.46","0.41-0.52","0.41-0.50","0.42-0.42","0.42-0.50","0.42-0.43","0.43-0.44","0.43-0.49","0.44-0.39","0.44-0.47","0.44-0.49","0.44-0.42","0.44-0.44","0.44-0.45","0.44-0.43","0.44-0.51","0.44-0.58","0.45-0.47","0.45-0.53","0.45-0.45","0.45-0.46","0.46-0.47","0.46-0.49","0.46-0.48","0.47-0.45","0.47-0.47","0.47-0.58","0.47-0.59","0.47-0.6","0.47-0.48","0.47-0.51","0.48-0.47","0.48-0.49","0.48-0.59","0.48-0.57","0.48-0.55","0.48-0.48","0.49-0.59","0.49-0.47","0.49-0.54","0.49-0.58","0.49-0.49","0.49-0.63","0.49-0.46","0.5-0.56","0.5-0.60","0.50-0.56","0.50-0.58","0.50-0.60","0.50-0.54","0.50-0.57","0.50-0.66","0.50-0.61","0.51-0.45","0.51-0.51","0.51-0.59","0.51-0.6","0.51-0.62","0.51-0.55","0.51-0.57","0.51-0.63","0.51-0.65","0.52-0.55","0.52-0.68","0.52-0.41","0.52-0.54","0.52-0.6","0.52-0.61","0.52-0.63","0.52-0.58","0.52-0.60","0.52-0.44","0.52-0.62","0.52-0.53","0.52-0.57","0.53-0.42","0.53-0.58","0.53-0.68","0.53-0.56","0.53-0.61","0.53-0.51","0.53-0.59","0.53-0.6","0.53-0.63","0.53-0.66","0.54-0.44","0.54-0.57","0.54-0.61","0.54-0.64","0.54-0.60","0.55-0.44","0.55-0.37","0.55-0.6","0.55-0.62","0.55-0.63","0.55-0.66","0.55-0.36","0.55-0.58","0.55-0.59","0.55-0.69","0.55-0.38","0.55-0.46","0.55-0.64","0.56-0.38","0.56-0.46","0.56-0.44","0.56-0.45","0.56-0.60","0.56-0.63","0.56-0.68","0.56-0.43","0.56-0.62","0.56-0.66","0.56-0.37","0.56-0.39","0.56-0.40","0.57-0.38","0.57-0.4","0.57-0.46","0.57-0.65","0.57-0.62","0.57-0.64","0.57-0.67","0.57-0.68","0.57-0.41","0.57-0.47","0.57-0.59","0.57-0.42","0.57-0.45","0.57-0.50","0.57-0.7","0.58-0.63","0.58-0.64","0.58-0.44","0.58-0.50","0.58-0.61","0.58-0.40","0.58-0.46","0.58-0.48","0.58-0.66","0.58-0.69","0.58-0.42","0.58-0.45","0.58-0.49","0.58-0.71","0.58-0.65","0.58-0.67","0.58-0.70","0.58-0.75","0.59-0.43","0.59-0.47","0.59-0.49","0.59-0.66","0.59-0.73","0.59-0.75","0.59-0.76","0.59-0.41","0.59-0.44","0.59-0.68","0.59-0.71","0.59-0.4","0.59-0.63","0.59-0.40","0.59-0.50","0.59-0.38","0.59-0.39","0.59-0.46","0.59-0.48","0.6-0.42","0.6-0.47","0.6-0.66","0.6-0.71","0.6-0.75","0.60-0.37","0.60-0.44","0.60-0.61","0.60-0.64","0.60-0.68","0.60-0.69","0.60-0.76","0.60-0.79","0.60-0.49","0.60-0.45","0.60-0.65","0.60-0.66","0.60-0.67","0.60-0.46","0.60-0.48","0.60-0.78","0.61-0.46","0.61-0.5","0.61-0.61","0.61-0.67","0.61-0.51","0.61-0.62","0.61-0.64","0.61-0.69","0.61-0.79","0.61-0.50","0.61-0.63","0.62-0.45","0.62-0.50","0.62-0.63","0.62-0.43","0.62-0.53","0.62-0.64","0.62-0.66","0.62-0.68","0.62-0.79","0.63-0.46","0.63-0.51","0.63-0.66","0.63-0.62","0.63-0.44","0.63-0.52","0.63-0.64","0.63-0.48","0.63-0.78","0.64-0.30","0.64-0.8","0.64-0.79","0.65-0.54","0.65-0.78","0.65-0.28","0.65-0.79","0.66-0.75","0.66-0.76","0.66-0.77","0.66-0.79","0.66-0.74","0.67-0.77","0.67-0.79","0.68-0.23","0.68-0.22","0.68-0.17","0.68-0.8","0.69-0.83","0.69-0.20","0.69-0.21","0.69-0.76","0.69-0.80","0.69-0.81","0.69-0.18","0.69-0.14","0.69-0.19","0.69-0.17","0.69-0.2","0.7-0.16","0.70-0.13","0.70-0.22","0.70-0.21","0.70-0.81","0.70-0.19","0.71-0.14","0.71-0.22","0.71-0.83","0.71-0.81","0.71-0.82","0.72-0.83","0.72-0.16","0.72-0.82","0.73-0.82","0.73-0.84","0.74-0.83","0.75-0.82","0.75-0.84","0.75-0.81","0.75-0.83","0.75-0.86","0.75-0.85","0.76-0.81","0.76-0.84","0.76-0.86","0.76-0.80","0.78-0.81","0.78-0.82","0.78-0.84","0.78-0.86","0.78-0.83","0.79-0.85","0.79-0.82","0.79-0.81","0.79-0.83","0.79-0.84" } };
				[630] = { x = 0.65599996, y = 0.372, overlay = { "0.46-0.47","0.52-0.11","0.53-0.58","0.57-0.28","0.60-0.36","0.64-0.31","0.65-0.36","0.65-0.37" } };
				[634] = { x = 0.732, y = 0.574, overlay = { "0.36-0.26","0.38-0.40","0.38-0.39","0.41-0.63","0.45-0.54","0.46-0.41","0.59-0.3","0.59-0.29","0.62-0.54","0.62-0.53","0.65-0.47","0.73-0.57" } };
				[641] = { x = 0.71, y = 0.468, overlay = { "0.47-0.55","0.49-0.77","0.49-0.76","0.49-0.84","0.54-0.67","0.57-0.61","0.57-0.62","0.57-0.60","0.62-0.72","0.63-0.42","0.65-0.75","0.65-0.77","0.65-0.67","0.71-0.46" } };
				[650] = { x = 0.568, y = 0.58599997, overlay = { "0.27-0.41","0.28-0.41","0.37-0.66","0.37-0.40","0.38-0.40","0.43-0.50","0.45-0.55","0.45-0.56","0.47-0.32","0.47-0.33","0.47-0.10","0.48-0.10","0.49-0.71","0.49-0.43","0.50-0.43","0.56-0.58" } };
				[680] = { x = 0.72, y = 0.59, overlay = { "0.21-0.26","0.23-0.60","0.23-0.6","0.24-0.59","0.28-0.45","0.28-0.60","0.30-0.34","0.39-0.38","0.39-0.39","0.6-0.41","0.72-0.59" } };
				[750] = { x = 0.382, y = 0.16399999, overlay = { "0.37-0.14","0.37-0.13","0.38-0.16" } };
			  }, displayID = 61712 }; --null
	[97380] = { zoneID = 628, artID = { 651 }, x = 0.602, y = 0.726, overlay = { "0.48-0.59","0.49-0.61","0.49-0.63","0.5-0.63","0.50-0.60","0.50-0.66","0.50-0.59","0.50-0.64","0.51-0.63","0.51-0.64","0.51-0.65","0.51-0.62","0.51-0.61","0.52-0.68","0.52-0.62","0.52-0.67","0.52-0.61","0.52-0.66","0.53-0.64","0.53-0.68","0.53-0.66","0.53-0.59","0.53-0.69","0.53-0.60","0.54-0.62","0.54-0.64","0.54-0.58","0.54-0.65","0.54-0.67","0.54-0.60","0.55-0.59","0.55-0.62","0.55-0.64","0.55-0.66","0.55-0.67","0.55-0.69","0.55-0.65","0.55-0.63","0.55-0.70","0.56-0.60","0.56-0.61","0.56-0.66","0.56-0.67","0.56-0.63","0.57-0.65","0.57-0.70","0.57-0.64","0.57-0.62","0.57-0.66","0.57-0.68","0.58-0.65","0.58-0.68","0.58-0.70","0.58-0.62","0.58-0.64","0.58-0.61","0.59-0.68","0.59-0.70","0.59-0.62","0.60-0.72" }, displayID = 65195 }; --Splint
	[97381] = { zoneID = 628, artID = { 651 }, x = 0.6, y = 0.714, overlay = { "0.45-0.52","0.49-0.58","0.50-0.59","0.50-0.61","0.51-0.57","0.51-0.59","0.52-0.61","0.52-0.54","0.52-0.63","0.52-0.6","0.53-0.60","0.53-0.56","0.53-0.62","0.53-0.64","0.53-0.55","0.54-0.6","0.54-0.62","0.54-0.64","0.54-0.61","0.54-0.65","0.55-0.59","0.55-0.63","0.55-0.60","0.55-0.68","0.56-0.61","0.56-0.64","0.56-0.66","0.57-0.64","0.57-0.62","0.57-0.70","0.58-0.62","0.58-0.63","0.58-0.66","0.6-0.71" }, displayID = 57484 }; --Screek
	[97384] = { zoneID = 628, artID = { 651 }, x = 0.71599996, y = 0.21200001, overlay = { "0.66-0.21","0.66-0.20","0.67-0.22","0.67-0.24","0.67-0.20","0.67-0.18","0.67-0.23","0.68-0.25","0.68-0.23","0.68-0.19","0.68-0.18","0.68-0.21","0.69-0.16","0.69-0.18","0.69-0.17","0.69-0.24","0.69-0.26","0.69-0.22","0.69-0.20","0.69-0.25","0.7-0.21","0.70-0.23","0.70-0.24","0.70-0.22","0.70-0.25","0.71-0.21","0.71-0.20" }, displayID = 12200 }; --Segacedi
	[97387] = { zoneID = 628, artID = { 651 }, x = 0.58, y = 0.42400002, overlay = { "0.46-0.35","0.47-0.35","0.48-0.36","0.49-0.38","0.50-0.37","0.50-0.40","0.50-0.39","0.51-0.40","0.51-0.39","0.52-0.41","0.53-0.42","0.55-0.37","0.55-0.38","0.56-0.39","0.56-0.38","0.56-0.44","0.57-0.39","0.57-0.40","0.57-0.41","0.58-0.42" }, displayID = 61125 }; --Mana Seeper
	[97388] = { zoneID = 628, artID = { 651 }, x = 0.584, y = 0.66199994, overlay = { "0.34-0.43","0.35-0.43","0.37-0.45","0.37-0.43","0.37-0.42","0.38-0.43","0.38-0.42","0.39-0.42","0.39-0.44","0.39-0.41","0.40-0.41","0.41-0.42","0.42-0.43","0.43-0.44","0.45-0.46","0.58-0.66" }, displayID = 65157 }; --Xullorax
	[97390] = { zoneID = 628, artID = { 651 }, x = 0.752, y = 0.84, overlay = { "0.38-0.45","0.38-0.44","0.38-0.46","0.39-0.51","0.39-0.53","0.40-0.43","0.40-0.41","0.41-0.42","0.42-0.43","0.43-0.44","0.44-0.42","0.44-0.45","0.45-0.47","0.47-0.48","0.49-0.59","0.49-0.50","0.50-0.51","0.50-0.54","0.51-0.61","0.54-0.63","0.63-0.70","0.64-0.69","0.71-0.81","0.72-0.82","0.75-0.82","0.75-0.84" }, displayID = 57377 }; --Thieving Scoundrel
	[97587] = { zoneID = 628, artID = { 651 }, x = 0.616, y = 0.708, overlay = { "0.57-0.69","0.57-0.70","0.58-0.70","0.58-0.67","0.58-0.69","0.58-0.68","0.58-0.72","0.59-0.70","0.59-0.67","0.59-0.7","0.59-0.72","0.59-0.69","0.59-0.71","0.6-0.73","0.60-0.67","0.60-0.68","0.60-0.73","0.61-0.69","0.61-0.70" }, displayID = 47090 }; --Crazed Mage
	[97589] = { zoneID = 628, artID = { 651 }, x = 0.636, y = 0.474, overlay = { "0.62-0.43","0.62-0.44","0.62-0.45","0.63-0.47","0.63-0.46" }, displayID = 36525 }; --Rotten Egg
	[102064] = { zoneID = 630, artID = { 653 }, x = 0.372, y = 0.83599997, overlay = { "0.37-0.83" }, displayID = 71821, questID = { 44035 } }; --Torrentius
	[103975] = { zoneID = 630, artID = { 653 }, x = 0.408, y = 0.768, overlay = { "0.40-0.76" }, displayID = 71941, questID = { 43957 } }; --Jade Darkhaven
	[105938] = { zoneID = 630, artID = { 653 }, x = 0.436, y = 0.246, overlay = { "0.43-0.24" }, displayID = 69438, questID = { 42069 } }; --Felwing
	[106990] = { zoneID = 630, artID = { 653 }, x = 0.65599996, y = 0.568, overlay = { "0.65-0.56" }, displayID = 66509, questID = { 42221 } }; --Chief Bitterbrine
	[107105] = { zoneID = 630, artID = { 653 }, x = 0.33200002, y = 0.41599998, overlay = { "0.33-0.41" }, displayID = 65926, questID = { 44670 } }; --Broodmother Lizax
	[107113] = { zoneID = 630, artID = { 653 }, x = 0.372, y = 0.432, overlay = { "0.36-0.43","0.37-0.43" }, displayID = 69841, questID = { 42280 } }; --Vorthax
	[107127] = { zoneID = 630, artID = { 653 }, x = 0.552, y = 0.458, overlay = { "0.55-0.45" }, displayID = 66814, questID = { 42450 } }; --Brawlgoth
	[107136] = { zoneID = 630, artID = { 653 }, x = 0.308, y = 0.478, overlay = { "0.30-0.48","0.30-0.47" }, displayID = 18345, questID = { 42286 } }; --Houndmaster Stroxis
	[107169] = { zoneID = 630, artID = { 653 }, x = 0.308, y = 0.478, overlay = { "0.30-0.48","0.30-0.46","0.30-0.47" }, displayID = 62737, questID = { 42286 } }; --Horux
	[107170] = { zoneID = 630, artID = { 653 }, x = 0.308, y = 0.47599998, overlay = { "0.30-0.47","0.30-0.48" }, displayID = 62737, questID = { 42286 } }; --Zorux
	[107266] = { zoneID = 630, artID = { 653 }, x = 0.278, y = 0.51, overlay = { "0.27-0.51" }, displayID = 68039, questID = { 44673 } }; --Commander Soraax
	[107269] = { zoneID = 630, artID = { 653 }, x = 0.282, y = 0.52, overlay = { "0.28-0.52" }, displayID = 69190, questID = { 42376 } }; --Inquisitor Tivos
	[107327] = { zoneID = 630, artID = { 653 }, x = 0.294, y = 0.53400004, overlay = { "0.29-0.53" }, displayID = 65280, questID = { 42417 } }; --Bilebrain
	[107657] = { zoneID = 630, artID = { 653 }, x = 0.36, y = 0.34, overlay = { "0.35-0.33","0.36-0.34" }, displayID = 70214, questID = { 42505 } }; --Arcanist Shal'iman
	[107960] = { zoneID = 630, artID = { 653 }, x = 0.33400002, y = 0.048, overlay = { "0.33-0.04" }, friendly = { "A","H" }, displayID = 66423 }; --Alluvanon
	[108136] = { zoneID = 630, artID = { 653 }, x = 0.58599997, y = 0.796, overlay = { "0.58-0.78","0.58-0.79" }, displayID = 70411, questID = { 44671 } }; --The Muscle
	[108255] = { zoneID = 630, artID = { 653 }, x = 0.55799997, y = 0.694, overlay = { "0.55-0.7","0.55-0.69" }, displayID = 70491, questID = { 42699 } }; --Coura
	[108366] = { zoneID = 630, artID = { 653 }, x = 0.634, y = 0.54, overlay = { "0.37-0.21","0.44-0.59","0.45-0.17","0.47-0.62","0.49-0.54","0.51-0.57","0.55-0.10","0.56-0.25","0.57-0.31","0.57-0.16","0.58-0.24","0.63-0.54" }, friendly = { "A","H" }, displayID = 3211 }; --Long-Forgotten Hippogryph
	[109504] = { zoneID = 630, artID = { 653 }, x = 0.32599998, y = 0.488, overlay = { "0.32-0.48" }, displayID = 20914, questID = { 44108 } }; --Ragemaw
	[109575] = { zoneID = 630, artID = { 653 }, x = 0.582, y = 0.214, overlay = { "0.58-0.21" }, displayID = 70161, questID = { 45515 } }; --Valakar the Thirsty
	[109584] = { zoneID = 630, artID = { 653 }, x = 0.666, y = 0.4, overlay = { "0.66-0.40","0.66-0.39","0.66-0.4" }, displayID = 67253, questID = { 45499 } }; --Fjordun
	[109594] = { zoneID = 630, artID = { 653 }, x = 0.512, y = 0.574, overlay = { "0.51-0.58","0.51-0.57" }, displayID = 65235, questID = { 45497 } }; --Stormfeather
	[109620] = { zoneID = 630, artID = { 653 }, x = 0.436, y = 0.081999995, overlay = { "0.43-0.07","0.43-0.08" }, displayID = 66889 }; --The Whisperer
	[109630] = { zoneID = 630, artID = { 653 }, x = 0.286, y = 0.498, overlay = { "0.28-0.48","0.28-0.49" }, displayID = 68732, questID = { 45495 } }; --Immolian
	[109641] = { zoneID = 630, artID = { 653 }, x = 0.57, y = 0.11, overlay = { "0.57-0.11" }, displayID = 71119, questID = { 45494 } }; --Arcanor Prime
	[109653] = { zoneID = 630, artID = { 653 }, x = 0.342, y = 0.28, overlay = { "0.33-0.28","0.34-0.28" }, displayID = 71125, questID = { 45492 } }; --Marblub the Massive
	[109677] = { zoneID = 630, artID = { 653 }, x = 0.588, y = 0.768, overlay = { "0.58-0.76" }, displayID = 13991, questID = { 45491 } }; --Chief Treasurer Jabrill
	[109702] = { zoneID = 630, artID = { 653 }, x = 0.55799997, y = 0.636, overlay = { "0.55-0.63" }, displayID = 64628, questID = { 45489 } }; --Deepclaw
	[110824] = { zoneID = {
				[630] = { x = 0.636, y = 0.142, overlay = { "0.63-0.14" } };
				[680] = { x = 0.186, y = 0.61, overlay = { "0.18-0.61","0.18-0.60" } };
			  }, displayID = 70524, questID = { 44124,43542 } }; --Tideclaw
	[111434] = { zoneID = 630, artID = { 653 }, x = 0.44599998, y = 0.866, overlay = { "0.44-0.85","0.44-0.86" }, displayID = 68605, questID = { 44039 } }; --Sea King Tidross
	[111454] = { zoneID = 630, artID = { 653 }, x = 0.41799998, y = 0.88199997, overlay = { "0.41-0.88" }, displayID = 71831, questID = { 43961 } }; --Bestrix
	[111674] = { zoneID = 630, artID = { 653 }, x = 0.468, y = 0.77599996, overlay = { "0.46-0.77" }, displayID = 71877, questID = { 43960 } }; --Cinderwing
	[111731] = { zoneID = 630, artID = { 653 }, x = 0.45599997, y = 0.77599996, overlay = { "0.45-0.77" }, displayID = 69841, questID = { 43815 } }; --Karthax
	[111939] = { zoneID = 630, artID = { 653 }, x = 0.436, y = 0.89599997, overlay = { "0.43-0.89","0.43-0.9" }, displayID = 71940, questID = { 43956 } }; --Lysanis Shadesoul
	[112636] = { zoneID = 630, artID = { 653 }, x = 0.506, y = 0.52, overlay = { "0.50-0.52" }, displayID = 69430, questID = { 44081 } }; --Sinister Leyrunner
	[112637] = { zoneID = 630, artID = { 653 }, x = 0.506, y = 0.522, overlay = { "0.50-0.52" }, displayID = 72132, questID = { 44081 } }; --Devious Sunrunner
	[89016] = { zoneID = 630, artID = { 653 }, x = 0.41599998, y = 0.414, overlay = { "0.40-0.41","0.41-0.41" }, displayID = 26768, questID = { 37537 } }; --Ravyn-Drath
	[89650] = { zoneID = 630, artID = { 653 }, x = 0.472, y = 0.342, overlay = { "0.47-0.34" }, displayID = 20641, questID = { 37726 } }; --Valiyaka the Stormbringer
	[89816] = { zoneID = 630, artID = { 653 }, x = 0.65599996, y = 0.4, overlay = { "0.65-0.4" }, displayID = 66813, questID = { 37820 } }; --Golza the Iron Fin
	[89846] = { zoneID = 630, artID = { 653 }, x = 0.53400004, y = 0.44, overlay = { "0.53-0.44" }, displayID = 61814, questID = { 37821 } }; --Captain Volo'ren
	[89850] = { zoneID = 630, artID = { 653 }, x = 0.59599996, y = 0.556, overlay = { "0.59-0.55" }, displayID = 21930, questID = { 37822 } }; --The Oracle
	[89865] = { zoneID = 630, artID = { 653 }, x = 0.5, y = 0.346, overlay = { "0.5-0.34" }, displayID = 4088, questID = { 37823 } }; --Mrrgrl the Tide Reaver
	[89884] = { zoneID = 630, artID = { 653 }, x = 0.45599997, y = 0.58, overlay = { "0.45-0.57","0.45-0.58" }, displayID = 66819, questID = { 37824 } }; --Flog the Captain-Eater
	[90057] = { zoneID = 630, artID = { 653 }, x = 0.51, y = 0.316, overlay = { "0.51-0.31" }, displayID = 64535, questID = { 37869 } }; --Daggerbeak
	[90164] = { zoneID = 630, artID = { 653 }, x = 0.50200003, y = 0.556, overlay = { "0.47-0.53","0.48-0.54","0.49-0.55","0.50-0.55" }, displayID = 64006, questID = { 37909 } }; --Warbringer Mox'na
	[90173] = { zoneID = 630, artID = { 653 }, x = 0.51, y = 0.56, overlay = { "0.47-0.53","0.48-0.54","0.48-0.55","0.49-0.55","0.50-0.55","0.51-0.56" }, displayID = 1913, questID = { 37909 } }; --Arcana Stalker
	[90217] = { zoneID = 630, artID = { 653 }, x = 0.496, y = 0.086, overlay = { "0.49-0.08" }, displayID = 23223, questID = { 37928 } }; --Normantis the Deposed
	[90244] = { zoneID = 630, artID = { 653 }, x = 0.598, y = 0.12, overlay = { "0.59-0.12" }, displayID = 35822, questID = { 37932 } }; --Arcavellus
	[90505] = { zoneID = 630, artID = { 653 }, x = 0.672, y = 0.516, overlay = { "0.67-0.51" }, displayID = 65962, questID = { 37989 } }; --Syphonus
	[90803] = { zoneID = 630, artID = { 653 }, x = 0.354, y = 0.50200003, overlay = { "0.35-0.50" }, displayID = 62180, questID = { 38037 } }; --Infernal Lord
	[90901] = { zoneID = 630, artID = { 653 }, x = 0.56, y = 0.29, overlay = { "0.56-0.29" }, displayID = 69191, questID = { 38061 } }; --Pridelord Meowl
	[91100] = { zoneID = 630, artID = { 653 }, x = 0.592, y = 0.46400002, overlay = { "0.59-0.46" }, displayID = 62262, questID = { 38212 } }; --Brogozog
	[91113] = { zoneID = 630, artID = { 653 }, x = 0.612, y = 0.62, overlay = { "0.61-0.62" }, displayID = 62271, questID = { 38217 } }; --Tide Behemoth
	[91114] = { zoneID = 630, artID = { 653 }, x = 0.612, y = 0.62, overlay = { "0.61-0.62" }, displayID = 62272, questID = { 38217 } }; --Tide Behemoth
	[91115] = { zoneID = 630, artID = { 653 }, x = 0.612, y = 0.62, overlay = { "0.61-0.62" }, displayID = 62273, questID = { 38217 } }; --Tide Behemoth
	[91187] = { zoneID = 630, artID = { 653 }, x = 0.32799998, y = 0.284, overlay = { "0.32-0.28","0.32-0.29","0.32-0.3" }, displayID = 61075, questID = { 38238 } }; --Beacher
	[91289] = { zoneID = 630, artID = { 653 }, x = 0.52599996, y = 0.22600001, overlay = { "0.52-0.22" }, displayID = 67183, questID = { 38268 } }; --Cailyn Paledoom
	[91579] = { zoneID = 630, artID = { 653 }, x = 0.432, y = 0.282, overlay = { "0.43-0.28" }, displayID = 20915, questID = { 38352 } }; --Doomlord Kazrok
	[93622] = { zoneID = 630, artID = { 653 }, x = 0.406, y = 0.44799998, overlay = { "0.40-0.44" }, displayID = 63166, questID = { 45516 } }; --Mortiferous
	[99846] = { zoneID = {
				[630] = { x = 0.52599996, y = 0.132, overlay = { "0.44-0.37","0.52-0.13" } };
				[641] = { x = 0.45200002, y = 0.56, overlay = { "0.45-0.56" } };
				[650] = { x = 0.47, y = 0.32799998, overlay = { "0.47-0.32" } };
			  }, displayID = 12239 }; --null
	[99886] = { zoneID = {
				[630] = { x = 0.52599996, y = 0.132, overlay = { "0.44-0.37","0.52-0.13" } };
				[634] = { x = 0.65199995, y = 0.402, overlay = { "0.53-0.6","0.65-0.40" } };
				[641] = { x = 0.58599997, y = 0.734, overlay = { "0.45-0.55","0.58-0.73" } };
				[650] = { x = 0.552, y = 0.618, overlay = { "0.47-0.32","0.55-0.61" } };
			  }, friendly = { "A","H" }, displayID = 1109 }; --null
	[100067] = { zoneID = 634, artID = { 657 }, x = 0.638, y = 0.32599998, overlay = { "0.63-0.32" }, friendly = { "A","H" }, displayID = 66423 }; --Hydrannon
	[100223] = { zoneID = 634, artID = { 657 }, x = 0.65199995, y = 0.402, overlay = { "0.53-0.6","0.65-0.40" }, displayID = 64208 }; --Vrykul Earthshaper Spirit
	[100224] = { zoneID = 634, artID = { 657 }, x = 0.65199995, y = 0.402, overlay = { "0.53-0.6","0.65-0.40" }, displayID = 25814 }; --Vrykul Earthmaiden Spirit
	[107023] = { zoneID = 634, artID = { 657 }, x = 0.466, y = 0.3, overlay = { "0.46-0.30","0.46-0.3" }, displayID = 69816 }; --Nithogg
	[107487] = { zoneID = 634, artID = { 657 }, x = 0.546, y = 0.296, overlay = { "0.54-0.29" }, displayID = 70116, questID = { 42437 } }; --Starbuck
	[107544] = { zoneID = 634, artID = { 657 }, x = 0.466, y = 0.3, displayID = 69816 }; --Nithogg
	[107926] = { zoneID = 634, artID = { 657 }, x = 0.516, y = 0.746, overlay = { "0.51-0.74" }, displayID = 70346, questID = { 42591 } }; --Hannval the Butcher
	[108790] = { zoneID = 634, artID = { 657 }, x = 0.38599998, y = 0.706, overlay = { "0.38-0.68","0.38-0.69","0.38-0.7","0.38-0.70" }, displayID = 70702 }; --Den Mother Ylva
	[108822] = { zoneID = 634, artID = { 657 }, x = 0.396, y = 0.65800005, overlay = { "0.39-0.65" }, displayID = 70726 }; --Huntress Estrid
	[108823] = { zoneID = 634, artID = { 657 }, x = 0.396, y = 0.65800005, overlay = { "0.39-0.65" }, displayID = 69724 }; --Halfdan
	[108827] = { zoneID = 634, artID = { 657 }, x = 0.686, y = 0.536, overlay = { "0.65-0.54","0.65-0.55","0.66-0.5","0.66-0.51","0.66-0.50","0.67-0.51","0.67-0.52","0.67-0.56","0.68-0.52","0.68-0.53" }, displayID = 60399, questID = { 45507 } }; --Fjorlag
	[108885] = { zoneID = 634, artID = { 657 }, x = 0.522, y = 0.23799999, overlay = { "0.52-0.23" }, displayID = 67541 }; --Aegir Wavecrusher
	[109015] = { zoneID = 634, artID = { 657 }, x = 0.62, y = 0.732, overlay = { "0.62-0.73" }, displayID = 70811 }; --Lagertha
	[109113] = { zoneID = 634, artID = { 657 }, x = 0.31, y = 0.338, overlay = { "0.31-0.33" }, displayID = 36326 }; --Boulderfall
	[109195] = { zoneID = 634, artID = { 657 }, x = 0.816, y = 0.046, overlay = { "0.81-0.04" }, displayID = 70931 }; --Soulbinder Halldora
	[109317] = { zoneID = 634, artID = { 657 }, x = 0.81, y = 0.096, overlay = { "0.80-0.11","0.80-0.12","0.81-0.09" }, displayID = 66121 }; --Rulf Bonesnapper
	[109318] = { zoneID = 634, artID = { 657 }, x = 0.77800006, y = 0.09, overlay = { "0.77-0.09" }, displayID = 71036 }; --Runeseer Sigvid
	[109994] = { zoneID = 634, artID = { 657 }, x = 0.64, y = 0.258, overlay = { "0.58-0.29","0.59-0.31","0.6-0.23","0.60-0.26","0.61-0.28","0.61-0.24","0.62-0.23","0.63-0.24","0.64-0.25" }, displayID = 69899, reset = true }; --Stormtalon
	[110363] = { zoneID = 634, artID = { 657 }, x = 0.582, y = 0.34, overlay = { "0.58-0.34" }, displayID = 44691, questID = { 43342 } }; --Roteye
	[111463] = { zoneID = 634, artID = { 657 }, x = 0.73800004, y = 0.84800005, overlay = { "0.73-0.84" }, displayID = 70876 }; --Bulvinkel
	[117850] = { zoneID = 634, artID = { 657 }, x = 0.376, y = 0.404, overlay = { "0.37-0.40" }, displayID = 20535 }; --Simone the Seductress
	[90139] = { zoneID = 634, artID = { 657 }, x = 0.636, y = 0.746, overlay = { "0.63-0.74" }, displayID = 64719, questID = { 37908 } }; --Inquisitor Ernstenbok
	[91529] = { zoneID = 634, artID = { 657 }, x = 0.41599998, y = 0.666, overlay = { "0.41-0.66" }, displayID = 62488, questID = { 38333 } }; --Glimar Ironfist
	[91780] = { zoneID = 634, artID = { 657 }, x = 0.35599998, y = 0.186, overlay = { "0.35-0.18" }, friendly = { "A" }, displayID = 62999, questID = { 38422 } }; --Mother Clacker
	[91795] = { zoneID = 634, artID = { 657 }, x = 0.496, y = 0.71800005, overlay = { "0.49-0.71","0.49-0.72" }, displayID = 67132, questID = { 38423 } }; --Stormwing Matriarch
	[91803] = { zoneID = 634, artID = { 657 }, x = 0.466, y = 0.83800006, overlay = { "0.46-0.83" }, displayID = 67127, questID = { 38425 } }; --Fathnyr
	[91874] = { zoneID = 634, artID = { 657 }, x = 0.458, y = 0.774, overlay = { "0.45-0.77" }, displayID = 62651, questID = { 38431 } }; --Bladesquall
	[91892] = { zoneID = 634, artID = { 657 }, x = 0.412, y = 0.71800005, overlay = { "0.41-0.71" }, displayID = 62359, questID = { 38424 } }; --Thane Irglov the Merciless
	[92152] = { zoneID = 634, artID = { 657 }, x = 0.366, y = 0.516, overlay = { "0.36-0.51" }, displayID = 62814, questID = { 38472 } }; --Whitewater Typhoon
	[92590] = { zoneID = 634, artID = { 657 }, x = 0.42, y = 0.576, overlay = { "0.42-0.57" }, friendly = { "H" }, displayID = 27773, questID = { 38625 } }; --Hook
	[92591] = { zoneID = 634, artID = { 657 }, x = 0.42, y = 0.576, overlay = { "0.42-0.57" }, friendly = { "H" }, displayID = 63163, questID = { 38625 } }; --Sinker
	[92599] = { zoneID = 634, artID = { 657 }, x = 0.4, y = 0.38599998, overlay = { "0.37-0.41","0.37-0.42","0.37-0.40","0.38-0.42","0.38-0.43","0.39-0.44","0.39-0.38","0.39-0.39","0.4-0.38" }, displayID = 71540, questID = { 38626 } }; --Bloodstalker Alpha
	[92604] = { zoneID = 634, artID = { 657 }, x = 0.442, y = 0.22799999, overlay = { "0.44-0.22" }, friendly = { "A" }, displayID = 63182, questID = { 38627 } }; --Champion Elodie
	[92609] = { zoneID = 634, artID = { 657 }, x = 0.44599998, y = 0.22799999, overlay = { "0.44-0.22" }, friendly = { "A" }, displayID = 63185, questID = { 38627 } }; --Tracker Jack
	[92611] = { zoneID = 634, artID = { 657 }, x = 0.444, y = 0.22799999, overlay = { "0.44-0.22" }, friendly = { "A" }, displayID = 63184, questID = { 38627 } }; --Ambusher Daggerfang
	[92613] = { zoneID = 634, artID = { 657 }, x = 0.44599998, y = 0.22799999, overlay = { "0.44-0.22" }, friendly = { "A" }, displayID = 63190, questID = { 38627 } }; --Priestess Liza
	[92626] = { zoneID = 634, artID = { 657 }, x = 0.442, y = 0.22799999, overlay = { "0.44-0.22" }, friendly = { "H" }, displayID = 63196, questID = { 38630 } }; --Deathguard Adams
	[92631] = { zoneID = 634, artID = { 657 }, x = 0.442, y = 0.22799999, overlay = { "0.44-0.22" }, friendly = { "H" }, displayID = 30072, questID = { 38630 } }; --Dark Ranger Jess
	[92633] = { zoneID = 634, artID = { 657 }, x = 0.442, y = 0.22799999, overlay = { "0.44-0.22" }, friendly = { "H" }, displayID = 63203, questID = { 38630 } }; --Assassin Huwe
	[92634] = { zoneID = 634, artID = { 657 }, x = 0.442, y = 0.22799999, overlay = { "0.44-0.22" }, friendly = { "H" }, displayID = 63204, questID = { 38630 } }; --Apothecary Perez
	[92682] = { zoneID = 634, artID = { 657 }, x = 0.578, y = 0.45, overlay = { "0.57-0.45" }, displayID = 25633, questID = { 38642 } }; --Helmouth Raider
	[92685] = { zoneID = 634, artID = { 657 }, x = 0.578, y = 0.45, overlay = { "0.57-0.45" }, displayID = 25668, questID = { 38642 } }; --Captain Brvet
	[92703] = { zoneID = 634, artID = { 657 }, x = 0.578, y = 0.45, overlay = { "0.57-0.45" }, displayID = 23553, questID = { 38642 } }; --Helmouth Raider
	[92751] = { zoneID = 634, artID = { 657 }, x = 0.612, y = 0.682, overlay = { "0.59-0.68","0.61-0.68" }, displayID = 24814, questID = { 39031 } }; --Ivory Sentinel
	[92763] = { zoneID = 634, artID = { 657 }, x = 0.672, y = 0.398, overlay = { "0.67-0.39" }, displayID = 25940, questID = { 38685 } }; --The Nameless King
	[92951] = { zoneID = 634, artID = { 657 }, x = 0.472, y = 0.572, overlay = { "0.47-0.57" }, friendly = { "A" }, displayID = 63377, questID = { 38712 } }; --Houndmaster Ely
	[93166] = { zoneID = 634, artID = { 657 }, x = 0.488, y = 0.506, overlay = { "0.45-0.5","0.46-0.5","0.48-0.49","0.48-0.50" }, displayID = 34706, questID = { 38774 } }; --Tiptog the Lost
	[93371] = { zoneID = 634, artID = { 657 }, x = 0.726, y = 0.5, overlay = { "0.72-0.50","0.72-0.49","0.72-0.5" }, displayID = 63533, questID = { 38837 } }; --Mordvigbjorn
	[93401] = { zoneID = 634, artID = { 657 }, x = 0.65, y = 0.514, overlay = { "0.64-0.51","0.65-0.51" }, displayID = 63553, questID = { 38847 } }; --Urgev the Flayer
	[94313] = { zoneID = 634, artID = { 657 }, x = 0.584, y = 0.754, overlay = { "0.58-0.75" }, friendly = { "A" }, displayID = 63930, questID = { 39048 } }; --Daniel "Boomer" Vorick
	[94347] = { zoneID = 634, artID = { 657 }, x = 0.766, y = 0.632, overlay = { "0.72-0.63","0.72-0.59","0.73-0.60","0.74-0.61","0.74-0.62","0.74-0.63","0.74-0.64","0.75-0.6","0.75-0.60","0.76-0.60","0.76-0.61","0.76-0.63" }, friendly = { "H" }, displayID = 63942, questID = { 43343 } }; --Dread-Rider Cortis
	[94413] = { zoneID = 634, artID = { 657 }, x = 0.62, y = 0.606, overlay = { "0.62-0.60" }, displayID = 69471, questID = { 39120 } }; --Isel the Hammer
	[98188] = { zoneID = 634, artID = { 657 }, x = 0.41599998, y = 0.338, overlay = { "0.41-0.33" }, displayID = 65687, questID = { 40068 } }; --Egyl the Enduring
	[98268] = { zoneID = 634, artID = { 657 }, x = 0.616, y = 0.436, overlay = { "0.61-0.43" }, displayID = 69269, questID = { 40081 } }; --Tarben
	[98421] = { zoneID = 634, artID = { 657 }, x = 0.734, y = 0.47599998, overlay = { "0.73-0.47" }, displayID = 71158, questID = { 40109 } }; --Kottr Vondyr
	[98503] = { zoneID = 634, artID = { 657 }, x = 0.78800005, y = 0.612, overlay = { "0.78-0.61" }, displayID = 5293, questID = { 40113 } }; --Grrvrgull the Conqueror
	[103785] = { zoneID = 641, artID = { 664 }, x = 0.69, y = 0.59599996, overlay = { "0.49-0.46","0.59-0.66","0.60-0.66","0.69-0.59" }, displayID = 68383 }; --Well-Fed Bear
	[104523] = { zoneID = 641, artID = { 664 }, x = 0.522, y = 0.39400002, overlay = { "0.52-0.39" }, displayID = 68610, questID = { 45500 } }; --Shalas'aman
	[107924] = { zoneID = {
				[641] = { x = 0.58599997, y = 0.736, overlay = { "0.58-0.73" } };
				[650] = { x = 0.552, y = 0.618, overlay = { "0.55-0.61" } };
			  }, displayID = 69056 }; --null
	[108678] = { zoneID = 641, artID = { 664 }, x = 0.568, y = 0.44599998, overlay = { "0.55-0.42","0.55-0.43","0.55-0.44","0.56-0.44" }, displayID = 70659 }; --Shar'thos
	[108879] = { zoneID = 641, artID = { 664 }, x = 0.246, y = 0.696, overlay = { "0.24-0.69","0.24-0.70" }, displayID = 67258 }; --Humongris
	[109125] = { zoneID = 641, artID = { 664 }, x = 0.45599997, y = 0.83599997, overlay = { "0.45-0.83" }, displayID = 70887 }; --Kathaw the Savage
	[109281] = { zoneID = 641, artID = { 664 }, x = 0.436, y = 0.76, overlay = { "0.42-0.76","0.42-0.75","0.43-0.76","0.43-0.75" }, displayID = 68639, questID = { 45501 } }; --Malisandra
	[109648] = { zoneID = 641, artID = { 664 }, x = 0.24200001, y = 0.704, overlay = { "0.23-0.71","0.24-0.70" }, displayID = 71124, questID = { 45493 } }; --Witchdoctor Grgl-Brgl
	[109692] = { zoneID = 641, artID = { 664 }, x = 0.346, y = 0.62, overlay = { "0.31-0.58","0.32-0.60","0.33-0.61","0.34-0.61","0.34-0.62" }, displayID = 71135, questID = { 45490 } }; --Lytheron
	[109708] = { zoneID = 641, artID = { 664 }, x = 0.67, y = 0.694, overlay = { "0.66-0.69","0.67-0.69" }, displayID = 71136, questID = { 43176 } }; --Undergrell Ringleader
	[109990] = { zoneID = 641, artID = { 664 }, x = 0.324, y = 0.482, overlay = { "0.32-0.48" }, displayID = 66889, questID = { 45488 } }; --Nylaathria the Forgotten
	[110342] = { zoneID = 641, artID = { 664 }, x = 0.698, y = 0.576, overlay = { "0.69-0.57" }, displayID = 66106, questID = { 45487 } }; --Rabxach
	[110346] = { zoneID = 641, artID = { 664 }, x = 0.598, y = 0.506, overlay = { "0.59-0.50" }, displayID = 69644, questID = { 45485 } }; --Aodh Witherpetal
	[110361] = { zoneID = 641, artID = { 664 }, x = 0.704, y = 0.53, overlay = { "0.70-0.52","0.70-0.53" }, displayID = 69081, questID = { 45484 } }; --Harbinger of Screams
	[110367] = { zoneID = 641, artID = { 664 }, x = 0.628, y = 0.42400002, overlay = { "0.62-0.42" }, displayID = 71539, questID = { 45483 } }; --Ealdis
	[110562] = { zoneID = 641, artID = { 664 }, x = 0.45599997, y = 0.886, overlay = { "0.45-0.87","0.45-0.88" }, displayID = 71578, questID = { 43446 } }; --Bahagar
	[92117] = { zoneID = 641, artID = { 664 }, x = 0.59599996, y = 0.77599996, overlay = { "0.59-0.76","0.59-0.77" }, displayID = 31979, questID = { 38468 } }; --Gorebeak
	[92180] = { zoneID = 641, artID = { 664 }, x = 0.41599998, y = 0.786, overlay = { "0.41-0.78" }, displayID = 63713, questID = { 38479 } }; --Seersei
	[92423] = { zoneID = 641, artID = { 664 }, x = 0.38, y = 0.528, overlay = { "0.38-0.52" }, displayID = 8783, questID = { 38772 } }; --Theryssia
	[92965] = { zoneID = 641, artID = { 664 }, x = 0.442, y = 0.52, overlay = { "0.43-0.54","0.43-0.53","0.44-0.52" }, displayID = 64387, questID = { 38767 } }; --Darkshade
	[93030] = { zoneID = 641, artID = { 664 }, x = 0.592, y = 0.33200002, overlay = { "0.58-0.34","0.59-0.32","0.59-0.33" }, displayID = 65064, questID = { 40080 } }; --Ironbranch
	[93205] = { zoneID = 641, artID = { 664 }, x = 0.626, y = 0.47599998, overlay = { "0.62-0.47" }, displayID = 64255, questID = { 38780 } }; --Thondrax
	[93654] = { zoneID = 641, artID = { 664 }, x = 0.61, y = 0.88, overlay = { "0.61-0.88" }, displayID = 21122, questID = { 38887 } }; --Skul'vrax
	[93679] = { zoneID = 641, artID = { 664 }, x = 0.492, y = 0.49, overlay = { "0.49-0.49" }, displayID = 62741, questID = { 38212 } }; --Gathenak the Subjugator
	[93686] = { zoneID = 641, artID = { 664 }, x = 0.528, y = 0.876, overlay = { "0.52-0.87" }, displayID = 50910, questID = { 38889 } }; --Jinikki the Puncturer
	[94414] = { zoneID = 641, artID = { 664 }, x = 0.344, y = 0.584, overlay = { "0.34-0.58" }, displayID = 63999, questID = { 39121 } }; --Kiranys Duskwhisper
	[94485] = { zoneID = 641, artID = { 664 }, x = 0.676, y = 0.45, overlay = { "0.66-0.45","0.66-0.44","0.67-0.44","0.67-0.46","0.67-0.45" }, displayID = 49027, questID = { 39130 } }; --Pollous the Fetid
	[95123] = { zoneID = 641, artID = { 664 }, x = 0.65800005, y = 0.536, overlay = { "0.65-0.53" }, displayID = 65231, questID = { 40126 } }; --Grelda the Hag
	[95221] = { zoneID = 641, artID = { 664 }, x = 0.472, y = 0.578, overlay = { "0.47-0.57" }, displayID = 64327, questID = { 39357 } }; --Mad Henryk
	[95318] = { zoneID = 641, artID = { 664 }, x = 0.61, y = 0.696, overlay = { "0.61-0.69" }, displayID = 64801, questID = { 39596 } }; --Perrexx
	[97504] = { zoneID = 641, artID = { 664 }, x = 0.66800004, y = 0.368, overlay = { "0.66-0.37","0.66-0.36" }, displayID = 65235, questID = { 39856 } }; --Wraithtalon
	[97517] = { zoneID = 641, artID = { 664 }, x = 0.602, y = 0.442, overlay = { "0.60-0.44" }, displayID = 70202, questID = { 39858 } }; --Dreadbog
	[98241] = { zoneID = 641, artID = { 664 }, x = 0.618, y = 0.29799998, overlay = { "0.61-0.29" }, displayID = 63669, questID = { 40079 } }; --Lyrath Moonfeather
	[116166] = { zoneID = 646, artID = { 669 }, x = 0.65199995, y = 0.316, overlay = { "0.64-0.30","0.65-0.31" }, displayID = 76140 }; --Eye of Gurgh
	[116953] = { zoneID = 646, artID = { 669 }, x = 0.608, y = 0.532, overlay = { "0.60-0.53","0.60-0.52" }, displayID = 74379 }; --Corrupted Bonebreaker
	[117086] = { zoneID = 646, artID = { 669 }, x = 0.528, y = 0.43400002, overlay = { "0.51-0.42","0.51-0.43","0.51-0.44","0.52-0.42","0.52-0.44","0.52-0.43" }, displayID = 62180 }; --Emberfire
	[117089] = { zoneID = 646, artID = { 669 }, x = 0.62, y = 0.382, overlay = { "0.62-0.38" }, displayID = 67378 }; --Inquisitor Chillbane
	[117090] = { zoneID = 646, artID = { 669 }, x = 0.506, y = 0.498, overlay = { "0.48-0.47","0.48-0.46","0.49-0.48","0.49-0.49","0.50-0.49" }, displayID = 71253 }; --Xorogun the Flamecarver
	[117091] = { zoneID = 646, artID = { 669 }, x = 0.396, y = 0.41799998, overlay = { "0.39-0.42","0.39-0.41" }, displayID = 20853 }; --Felmaw Emberfiend
	[117093] = { zoneID = 646, artID = { 669 }, x = 0.6, y = 0.45, overlay = { "0.56-0.50","0.56-0.49","0.57-0.49","0.57-0.48","0.57-0.40","0.57-0.41","0.58-0.41","0.58-0.43","0.58-0.46","0.58-0.47","0.59-0.45","0.6-0.45" }, displayID = 67324 }; --Felbringer Xar'thok
	[117094] = { zoneID = 646, artID = { 669 }, x = 0.444, y = 0.426, overlay = { "0.42-0.42","0.42-0.43","0.43-0.41","0.44-0.42" }, displayID = 74429 }; --Malorus the Soulkeeper
	[117095] = { zoneID = 646, artID = { 669 }, x = 0.61, y = 0.33200002, overlay = { "0.56-0.29","0.57-0.30","0.57-0.31","0.57-0.28","0.58-0.31","0.58-0.28","0.58-0.32","0.58-0.27","0.59-0.26","0.60-0.33","0.61-0.33" }, displayID = 64681 }; --Dreadblade Annihilator
	[117096] = { zoneID = 646, artID = { 669 }, x = 0.568, y = 0.56200004, overlay = { "0.56-0.56" }, displayID = 64632 }; --Potionmaster Gloop
	[117103] = { zoneID = 646, artID = { 669 }, x = 0.898, y = 0.308, overlay = { "0.88-0.31","0.89-0.30" }, displayID = 74433 }; --Felcaller Zelthae
	[117136] = { zoneID = 646, artID = { 669 }, x = 0.50200003, y = 0.36400002, overlay = { "0.49-0.37","0.49-0.38","0.5-0.35","0.50-0.36" }, displayID = 68312 }; --Doombringer Zar'thoz
	[117140] = { zoneID = 646, artID = { 669 }, x = 0.706, y = 0.254, overlay = { "0.64-0.31","0.64-0.32","0.65-0.28","0.65-0.31","0.65-0.30","0.66-0.31","0.66-0.29","0.67-0.29","0.67-0.30","0.68-0.3","0.68-0.29","0.69-0.29","0.69-0.28","0.69-0.30","0.69-0.3","0.70-0.26","0.70-0.25" }, displayID = 76061 }; --Salethan the Broodwalker
	[117141] = { zoneID = 646, artID = { 669 }, x = 0.59599996, y = 0.272, overlay = { "0.57-0.27","0.58-0.27","0.59-0.27" }, displayID = 72964 }; --Malgrazoth
	[117239] = { zoneID = 646, artID = { 669 }, x = 0.59599996, y = 0.288, overlay = { "0.58-0.28","0.59-0.29","0.59-0.28" }, displayID = 66677 }; --Brutallus
	[117303] = { zoneID = 646, artID = { 669 }, x = 0.61, y = 0.294, overlay = { "0.58-0.28","0.58-0.27","0.59-0.28","0.59-0.29","0.59-0.27","0.60-0.28","0.61-0.29" }, displayID = 63619 }; --Malificus
	[117470] = { zoneID = 646, artID = { 669 }, x = 0.89599997, y = 0.336, overlay = { "0.88-0.33","0.89-0.31","0.89-0.32","0.89-0.33" }, displayID = 74528 }; --Si'vash
	[118993] = { zoneID = 646, artID = { 669 }, x = 0.45200002, y = 0.79800004, overlay = { "0.36-0.77","0.36-0.79","0.37-0.79","0.37-0.76","0.38-0.8","0.38-0.80","0.39-0.79","0.39-0.80","0.39-0.78","0.40-0.80","0.40-0.78","0.41-0.78","0.41-0.80","0.41-0.8","0.41-0.77","0.42-0.80","0.42-0.8","0.42-0.79","0.42-0.78","0.43-0.79","0.43-0.78","0.44-0.79","0.45-0.78","0.45-0.79" }, displayID = 75013 }; --Dreadeye
	[119629] = { zoneID = 646, artID = { 669 }, x = 0.45200002, y = 0.518, overlay = { "0.44-0.52","0.44-0.53","0.45-0.51" }, displayID = 62555 }; --Lord Hel'Nurath
	[119718] = { zoneID = 646, artID = { 669 }, x = 0.602, y = 0.45, overlay = { "0.60-0.45" }, displayID = 65648 }; --Imp Mother Bruva
	[120583] = { zoneID = 646, artID = { 669 }, x = 0.84, y = 0.53, overlay = { "0.39-0.32","0.39-0.31","0.44-0.50","0.45-0.51","0.49-0.16","0.5-0.15","0.50-0.14","0.50-0.18","0.51-0.65","0.52-0.43","0.57-0.48","0.58-0.49","0.58-0.46","0.58-0.44","0.58-0.62","0.59-0.63","0.60-0.63","0.75-0.28","0.75-0.29","0.76-0.28","0.76-0.27","0.82-0.52","0.82-0.49","0.82-0.51","0.83-0.52","0.83-0.50","0.84-0.51","0.84-0.53" }, displayID = 75867 }; --Than'otalion
	[120641] = { zoneID = 646, artID = { 669 }, x = 0.828, y = 0.518, overlay = { "0.4-0.26","0.43-0.37","0.45-0.50","0.52-0.64","0.77-0.29","0.82-0.29","0.82-0.51" }, displayID = 17287 }; --Skulguloth
	[120665] = { zoneID = 646, artID = { 669 }, x = 0.58, y = 0.47599998, overlay = { "0.38-0.26","0.39-0.25","0.42-0.5","0.42-0.48","0.42-0.40","0.50-0.43","0.54-0.66","0.58-0.47" }, displayID = 64027 }; --Force-Commander Xillious
	[120675] = { zoneID = 646, artID = { 669 }, x = 0.83599997, y = 0.492, overlay = { "0.32-0.32","0.33-0.34","0.34-0.34","0.34-0.33","0.38-0.31","0.38-0.27","0.39-0.25","0.41-0.46","0.42-0.42","0.43-0.41","0.44-0.41","0.44-0.42","0.44-0.36","0.44-0.40","0.44-0.47","0.44-0.39","0.44-0.4","0.45-0.49","0.45-0.50","0.45-0.52","0.45-0.35","0.45-0.38","0.45-0.53","0.48-0.44","0.49-0.43","0.50-0.10","0.51-0.46","0.51-0.44","0.51-0.45","0.51-0.66","0.52-0.41","0.53-0.15","0.53-0.41","0.54-0.15","0.54-0.67","0.54-0.13","0.54-0.12","0.54-0.68","0.55-0.13","0.55-0.67","0.56-0.66","0.58-0.48","0.58-0.45","0.58-0.49","0.58-0.44","0.59-0.42","0.59-0.43","0.61-0.47","0.61-0.48","0.76-0.24","0.76-0.26","0.81-0.50","0.81-0.28","0.81-0.27","0.82-0.29","0.82-0.26","0.82-0.25","0.82-0.50","0.83-0.49" }, displayID = 75945 }; --An'thyna
	[120681] = { zoneID = 646, artID = { 669 }, x = 0.83, y = 0.514, overlay = { "0.37-0.3","0.38-0.25","0.38-0.24","0.38-0.26","0.39-0.25","0.40-0.25","0.42-0.40","0.42-0.39","0.42-0.4","0.43-0.41","0.43-0.40","0.43-0.39","0.44-0.45","0.44-0.40","0.44-0.41","0.44-0.39","0.44-0.49","0.45-0.49","0.45-0.51","0.45-0.48","0.49-0.43","0.49-0.42","0.50-0.44","0.51-0.42","0.51-0.44","0.52-0.42","0.55-0.14","0.58-0.47","0.82-0.48","0.82-0.50","0.83-0.51" }, displayID = 67647 }; --Fel Obliterator
	[120686] = { zoneID = 646, artID = { 669 }, x = 0.834, y = 0.278, overlay = { "0.38-0.32","0.44-0.41","0.44-0.4","0.45-0.49","0.45-0.5","0.45-0.35","0.48-0.42","0.50-0.43","0.51-0.44","0.53-0.66","0.77-0.28","0.78-0.29","0.83-0.26","0.83-0.27" }, displayID = 75992 }; --Illisthyndria
	[120998] = { zoneID = 646, artID = { 669 }, x = 0.402, y = 0.598, overlay = { "0.39-0.60","0.40-0.59" }, displayID = 76060 }; --Flllurlokkr
	[121016] = { zoneID = 646, artID = { 669 }, x = 0.538, y = 0.78800005, overlay = { "0.53-0.78" }, displayID = 76065 }; --Aqueux
	[121029] = { zoneID = 646, artID = { 669 }, x = 0.398, y = 0.336, overlay = { "0.38-0.34","0.39-0.32","0.39-0.30","0.39-0.31","0.39-0.33" }, displayID = 76067 }; --Brood Mother Nix
	[121037] = { zoneID = 646, artID = { 669 }, x = 0.78800005, y = 0.252, overlay = { "0.77-0.23","0.77-0.25","0.78-0.22","0.78-0.24","0.78-0.25" }, displayID = 76070 }; --Grossir
	[121046] = { zoneID = 646, artID = { 669 }, x = 0.79, y = 0.408, overlay = { "0.78-0.39","0.79-0.37","0.79-0.40" }, displayID = 76254 }; --Brother Badatin
	[121049] = { zoneID = 646, artID = { 669 }, x = 0.86800003, y = 0.27, overlay = { "0.36-0.57","0.36-0.24","0.38-0.44","0.38-0.45","0.42-0.18","0.42-0.49","0.43-0.42","0.44-0.76","0.46-0.67","0.47-0.68","0.51-0.10","0.53-0.41","0.54-0.41","0.54-0.69","0.55-0.46","0.55-0.68","0.55-0.26","0.56-0.35","0.56-0.36","0.57-0.35","0.57-0.56","0.58-0.55","0.62-0.41","0.62-0.58","0.62-0.59","0.63-0.26","0.65-0.32","0.66-0.42","0.66-0.43","0.68-0.26","0.69-0.26","0.73-0.30","0.74-0.30","0.74-0.34","0.74-0.35","0.75-0.34","0.85-0.54","0.86-0.27" }, displayID = 76108 }; --Baleful Knight-Captain
	[121051] = { zoneID = 646, artID = { 669 }, x = 0.864, y = 0.276, overlay = { "0.35-0.57","0.36-0.24","0.36-0.57","0.38-0.45","0.41-0.49","0.41-0.18","0.42-0.18","0.42-0.14","0.43-0.42","0.44-0.76","0.45-0.76","0.46-0.67","0.47-0.67","0.52-0.10","0.53-0.41","0.54-0.41","0.54-0.68","0.55-0.26","0.55-0.46","0.56-0.35","0.57-0.56","0.62-0.41","0.62-0.57","0.62-0.58","0.63-0.26","0.65-0.31","0.65-0.32","0.66-0.33","0.66-0.42","0.66-0.43","0.68-0.26","0.73-0.34","0.73-0.30","0.74-0.34","0.85-0.54","0.86-0.27" }, displayID = 76077 }; --Unstable Abyssal
	[121056] = { zoneID = 646, artID = { 669 }, x = 0.86800003, y = 0.272, overlay = { "0.35-0.57","0.36-0.24","0.36-0.57","0.38-0.45","0.38-0.44","0.41-0.49","0.42-0.18","0.42-0.5","0.42-0.50","0.43-0.41","0.43-0.42","0.44-0.74","0.44-0.75","0.44-0.76","0.46-0.67","0.46-0.68","0.47-0.67","0.52-0.10","0.54-0.41","0.54-0.46","0.54-0.68","0.55-0.28","0.55-0.46","0.55-0.26","0.55-0.45","0.57-0.35","0.57-0.36","0.57-0.37","0.57-0.55","0.6-0.62","0.62-0.58","0.62-0.41","0.63-0.26","0.65-0.32","0.66-0.33","0.66-0.43","0.68-0.26","0.74-0.30","0.74-0.34","0.85-0.54","0.86-0.27" }, displayID = 76102 }; --Malformed Terrorguard
	[121068] = { zoneID = 646, artID = { 669 }, x = 0.862, y = 0.274, overlay = { "0.36-0.57","0.36-0.24","0.38-0.45","0.41-0.49","0.42-0.18","0.43-0.42","0.44-0.76","0.46-0.67","0.52-0.10","0.54-0.41","0.54-0.68","0.55-0.46","0.55-0.26","0.56-0.35","0.57-0.56","0.62-0.58","0.62-0.41","0.63-0.26","0.65-0.32","0.66-0.43","0.68-0.26","0.74-0.30","0.74-0.34","0.85-0.54","0.86-0.27" }, displayID = 76081 }; --Volatile Imp
	[121073] = { zoneID = 646, artID = { 669 }, x = 0.864, y = 0.272, overlay = { "0.36-0.24","0.36-0.57","0.38-0.45","0.41-0.49","0.42-0.18","0.42-0.49","0.43-0.42","0.44-0.76","0.45-0.76","0.46-0.67","0.47-0.67","0.51-0.11","0.52-0.10","0.54-0.41","0.54-0.68","0.54-0.69","0.55-0.26","0.55-0.46","0.56-0.35","0.57-0.35","0.57-0.55","0.58-0.55","0.62-0.58","0.62-0.41","0.63-0.26","0.65-0.32","0.66-0.42","0.68-0.26","0.74-0.30","0.74-0.34","0.85-0.54","0.86-0.27" }, displayID = 76099 }; --Deranged Succubus
	[121077] = { zoneID = 646, artID = { 669 }, x = 0.866, y = 0.276, overlay = { "0.36-0.57","0.36-0.23","0.38-0.45","0.41-0.19","0.42-0.18","0.42-0.49","0.43-0.42","0.44-0.76","0.47-0.67","0.52-0.10","0.54-0.41","0.54-0.68","0.54-0.45","0.55-0.46","0.55-0.26","0.56-0.34","0.56-0.35","0.57-0.56","0.58-0.55","0.62-0.58","0.62-0.41","0.63-0.26","0.65-0.32","0.66-0.42","0.68-0.26","0.74-0.30","0.74-0.34","0.85-0.54","0.86-0.27" }, displayID = 76084 }; --Lambent Felhunter
	[121088] = { zoneID = 646, artID = { 669 }, x = 0.864, y = 0.276, overlay = { "0.36-0.24","0.36-0.57","0.38-0.45","0.41-0.49","0.42-0.18","0.43-0.42","0.44-0.76","0.47-0.67","0.52-0.10","0.54-0.41","0.54-0.68","0.55-0.46","0.55-0.26","0.56-0.35","0.57-0.55","0.62-0.58","0.62-0.41","0.63-0.26","0.65-0.32","0.66-0.32","0.66-0.42","0.68-0.26","0.74-0.30","0.74-0.34","0.85-0.54","0.86-0.27" }, displayID = 76107 }; --Warped Voidlord
	[121090] = { zoneID = 646, artID = { 669 }, x = 0.862, y = 0.274, overlay = { "0.36-0.57","0.36-0.24","0.38-0.45","0.41-0.49","0.42-0.17","0.43-0.42","0.44-0.76","0.46-0.67","0.52-0.10","0.54-0.40","0.54-0.68","0.54-0.69","0.55-0.46","0.55-0.26","0.56-0.35","0.57-0.55","0.62-0.58","0.62-0.41","0.63-0.26","0.65-0.32","0.66-0.42","0.68-0.26","0.74-0.30","0.74-0.34","0.85-0.54","0.86-0.27" }, displayID = 76106 }; --Demented Shivarra
	[121092] = { zoneID = 646, artID = { 669 }, x = 0.866, y = 0.276, overlay = { "0.36-0.24","0.36-0.57","0.38-0.45","0.41-0.18","0.41-0.49","0.43-0.42","0.44-0.42","0.44-0.76","0.46-0.67","0.52-0.10","0.54-0.41","0.54-0.68","0.55-0.46","0.55-0.26","0.55-0.45","0.56-0.35","0.57-0.56","0.62-0.42","0.62-0.58","0.62-0.41","0.63-0.26","0.65-0.32","0.66-0.42","0.68-0.26","0.73-0.32","0.74-0.30","0.74-0.34","0.85-0.54","0.86-0.27" }, displayID = 76090 }; --Anomalous Observer
	[121107] = { zoneID = 646, artID = { 669 }, x = 0.426, y = 0.184, overlay = { "0.41-0.16","0.41-0.17","0.42-0.17","0.42-0.15","0.42-0.18" }, displayID = 76101 }; --Lady Eldrathe
	[121108] = { zoneID = 646, artID = { 669 }, x = 0.866, y = 0.272, overlay = { "0.35-0.57","0.35-0.60","0.36-0.23","0.37-0.48","0.38-0.45","0.38-0.46","0.38-0.47","0.41-0.18","0.41-0.17","0.41-0.49","0.42-0.5","0.42-0.18","0.42-0.49","0.43-0.40","0.43-0.42","0.44-0.77","0.44-0.76","0.45-0.4","0.46-0.67","0.47-0.67","0.47-0.68","0.51-0.10","0.52-0.10","0.53-0.41","0.53-0.40","0.54-0.67","0.54-0.68","0.55-0.67","0.55-0.46","0.55-0.26","0.55-0.27","0.55-0.25","0.55-0.66","0.56-0.35","0.56-0.36","0.57-0.55","0.58-0.55","0.58-0.54","0.58-0.53","0.58-0.52","0.60-0.41","0.61-0.26","0.61-0.42","0.62-0.58","0.62-0.26","0.62-0.41","0.63-0.26","0.65-0.32","0.65-0.33","0.66-0.42","0.68-0.27","0.69-0.26","0.69-0.28","0.73-0.34","0.73-0.3","0.74-0.30","0.74-0.36","0.74-0.34","0.74-0.35","0.85-0.54","0.86-0.27" }, displayID = 76103 }; --Ruinous Overfiend
	[121112] = { zoneID = 646, artID = { 669 }, x = 0.336, y = 0.574, overlay = { "0.27-0.60","0.27-0.61","0.27-0.56","0.27-0.58","0.27-0.62","0.28-0.57","0.28-0.60","0.28-0.61","0.28-0.55","0.29-0.59","0.29-0.61","0.29-0.55","0.29-0.58","0.29-0.57","0.30-0.55","0.30-0.60","0.31-0.55","0.31-0.59","0.31-0.6","0.31-0.60","0.32-0.59","0.32-0.56","0.32-0.57","0.33-0.6","0.33-0.58","0.33-0.57" }, displayID = 76109 }; --Somber Dawn
	[121124] = { zoneID = 646, artID = { 669 }, x = 0.6, y = 0.628, overlay = { "0.59-0.62","0.6-0.62" }, displayID = 67647 }; --Apocron
	[121134] = { zoneID = 646, artID = { 669 }, x = 0.78800005, y = 0.264, overlay = { "0.77-0.29","0.78-0.28","0.78-0.27","0.78-0.26" }, displayID = 76121 }; --Duke Sithizi
	[109163] = { zoneID = 649, artID = { 673 }, x = 0.72, y = 0.22799999, overlay = { "0.66-0.23","0.67-0.23","0.68-0.19","0.68-0.20","0.69-0.20","0.69-0.22","0.69-0.21","0.7-0.19","0.7-0.20","0.70-0.21","0.70-0.18","0.71-0.19","0.71-0.22","0.71-0.23","0.71-0.20","0.71-0.21","0.72-0.21","0.72-0.22" }, displayID = 69849 }; --Captain Dargun
	[115732] = { zoneID = 649, artID = { 673 }, x = 0.35, y = 0.462, overlay = { "0.26-0.42","0.27-0.43","0.28-0.43","0.28-0.42","0.29-0.44","0.30-0.44","0.35-0.46" }, displayID = 23553, questID = { 46949 } }; --Jorvild the Trusted
	[92040] = { zoneID = 649, artID = { 673 }, x = 0.85, y = 0.50200003, overlay = { "0.83-0.48","0.84-0.48","0.84-0.49","0.85-0.50" }, displayID = 70084, questID = { 38461 } }; --Fenri
	[97630] = { zoneID = 649, artID = { 673 }, x = 0.296, y = 0.626, overlay = { "0.27-0.62","0.27-0.64","0.27-0.63","0.28-0.63","0.28-0.64","0.29-0.61","0.29-0.60","0.29-0.62" }, displayID = 65302, questID = { 39870 } }; --Soulthirster
	[100230] = { zoneID = 650, artID = { 674 }, x = 0.43400002, y = 0.474, overlay = { "0.43-0.47" }, displayID = 66048, questID = { 40413 } }; --"Sure-Shot" Arnie
	[100231] = { zoneID = 650, artID = { 674 }, x = 0.43400002, y = 0.474, overlay = { "0.43-0.47" }, displayID = 65989, questID = { 40413 } }; --Dargok Thunderuin
	[100232] = { zoneID = 650, artID = { 674 }, x = 0.43400002, y = 0.474, overlay = { "0.43-0.47" }, displayID = 65987, questID = { 40413 } }; --Ryael Dawndrifter
	[100302] = { zoneID = 650, artID = { 674 }, x = 0.524, y = 0.584, overlay = { "0.52-0.58" }, displayID = 66606, questID = { 40423 } }; --Puck
	[100303] = { zoneID = 650, artID = { 674 }, x = 0.524, y = 0.58599997, overlay = { "0.52-0.58" }, displayID = 66607, questID = { 40423 } }; --Zenobia
	[100495] = { zoneID = 650, artID = { 674 }, x = 0.544, y = 0.412, overlay = { "0.54-0.41" }, displayID = 60684, questID = { 40414 } }; --Devouring Darkness
	[101077] = { zoneID = {
				[650] = { x = 0.45599997, y = 0.554, overlay = { "0.45-0.54","0.45-0.55" } };
				[750] = { x = 0.372, y = 0.04, overlay = { "0.36-0.08","0.36-0.06","0.36-0.07","0.36-0.12","0.37-0.06","0.37-0.08","0.37-0.04" } };
			  }, displayID = 64387, questID = { 40681 } }; --Sekhan
	[101649] = { zoneID = 650, artID = { 674 }, x = 0.546, y = 0.756, overlay = { "0.51-0.80","0.51-0.79","0.54-0.75","0.54-0.74" }, displayID = 67284, questID = { 40773 } }; --Frostshard
	[104481] = { zoneID = 650, artID = { 674 }, x = 0.284, y = 0.538, overlay = { "0.28-0.52","0.28-0.53" }, displayID = 68615, questID = { 45514 } }; --Ala'washte
	[104484] = { zoneID = 650, artID = { 674 }, x = 0.338, y = 0.216, overlay = { "0.33-0.20","0.33-0.21" }, displayID = 67541, questID = { 45511 } }; --Olokk the Shipbreaker
	[104513] = { zoneID = 650, artID = { 674 }, x = 0.57, y = 0.48400003, overlay = { "0.56-0.48","0.57-0.48" }, displayID = 68639, questID = { 45513 } }; --Defilia
	[104517] = { zoneID = 650, artID = { 674 }, x = 0.588, y = 0.72800004, overlay = { "0.58-0.71","0.58-0.72" }, displayID = 62814, questID = { 45512 } }; --Mawat'aki
	[104524] = { zoneID = 650, artID = { 674 }, x = 0.52599996, y = 0.584, overlay = { "0.52-0.58" }, displayID = 68613, questID = { 45510 } }; --Ormagrogg
	[109498] = { zoneID = 650, artID = { 674 }, x = 0.52599996, y = 0.582, overlay = { "0.52-0.58" }, displayID = 72158, questID = { 40423 } }; --Xaander
	[109500] = { zoneID = 650, artID = { 674 }, x = 0.52599996, y = 0.582, overlay = { "0.52-0.58" }, displayID = 72159, questID = { 40423 } }; --Jak
	[109501] = { zoneID = 650, artID = { 674 }, x = 0.524, y = 0.58599997, overlay = { "0.52-0.58" }, displayID = 72160, questID = { 40423 } }; --Darkful
	[110378] = { zoneID = 650, artID = { 674 }, x = 0.58599997, y = 0.71199995, overlay = { "0.58-0.71","0.58-0.72" }, displayID = 68225 }; --Drugon the Frostblood
	[94877] = { zoneID = 650, artID = { 674 }, x = 0.56200004, y = 0.72400004, overlay = { "0.56-0.72" }, displayID = 64340, questID = { 39235 } }; --Brogrul the Mighty
	[95204] = { zoneID = 650, artID = { 674 }, x = 0.474, y = 0.73800004, overlay = { "0.47-0.73" }, displayID = 67881, questID = { 39435 } }; --Oubdob da Smasher
	[95872] = { zoneID = 650, artID = { 674 }, x = 0.514, y = 0.318, overlay = { "0.51-0.31" }, displayID = 65068, questID = { 39465 } }; --Skullhat
	[96072] = { zoneID = 650, artID = { 674 }, x = 0.438, y = 0.756, overlay = { "0.43-0.75" }, displayID = 68264, questID = { 45508 } }; --Durguth
	[96410] = { zoneID = 650, artID = { 674 }, x = 0.492, y = 0.29, overlay = { "0.45-0.25","0.45-0.30","0.46-0.30","0.46-0.31","0.47-0.33","0.47-0.32","0.47-0.30","0.48-0.25","0.49-0.29" }, displayID = 64893, questID = { 39646 } }; --Majestic Elderhorn
	[96590] = { zoneID = 650, artID = { 674 }, x = 0.568, y = 0.59599996, overlay = { "0.55-0.61","0.56-0.59","0.56-0.60","0.56-0.61" }, displayID = 34706, questID = { 40347 } }; --Gurbog da Basher
	[96621] = { zoneID = 650, artID = { 674 }, x = 0.488, y = 0.27, overlay = { "0.48-0.27" }, displayID = 66107, questID = { 40242 } }; --Mellok
	[97093] = { zoneID = 650, artID = { 674 }, x = 0.51, y = 0.258, overlay = { "0.51-0.25" }, displayID = 65446, questID = { 39762 } }; --Shara Felbreath
	[97102] = { zoneID = 650, artID = { 674 }, x = 0.522, y = 0.514, overlay = { "0.52-0.51" }, displayID = 27992, questID = { 39824 } }; --Ram'Pag
	[97203] = { zoneID = 650, artID = { 674 }, x = 0.42, y = 0.41599998, overlay = { "0.42-0.41" }, displayID = 65546, questID = { 39782 } }; --Tenpak Flametotem
	[97220] = { zoneID = 650, artID = { 674 }, x = 0.488, y = 0.5, overlay = { "0.48-0.5" }, displayID = 20827, questID = { 40601 } }; --Arru
	[97326] = { zoneID = 650, artID = { 674 }, x = 0.51, y = 0.482, overlay = { "0.51-0.48" }, displayID = 65224, questID = { 39802 } }; --Hartli the Snatcher
	[97345] = { zoneID = 650, artID = { 674 }, x = 0.48400003, y = 0.406, overlay = { "0.48-0.40" }, displayID = 65258, questID = { 39806 } }; --Crawshuk the Hungry
	[97449] = { zoneID = 650, artID = { 674 }, x = 0.38, y = 0.45599997, overlay = { "0.38-0.45" }, displayID = 51827, questID = { 40405 } }; --Bristlemaul
	[97593] = { zoneID = 650, artID = { 674 }, x = 0.546, y = 0.406, overlay = { "0.54-0.40" }, displayID = 64303, questID = { 39866 } }; --Mynta Talonscreech
	[97653] = { zoneID = 650, artID = { 674 }, x = 0.538, y = 0.512, overlay = { "0.53-0.51" }, displayID = 65324, questID = { 39872 } }; --Taurson
	[97793] = { zoneID = 650, artID = { 674 }, x = 0.412, y = 0.58, overlay = { "0.41-0.58" }, displayID = 65423, questID = { 39963 } }; --Flamescale
	[97928] = { zoneID = 650, artID = { 674 }, x = 0.458, y = 0.124, overlay = { "0.43-0.10","0.43-0.1","0.44-0.11","0.44-0.12","0.45-0.12" }, displayID = 70524, questID = { 39994 } }; --Tamed Coralback
	[97933] = { zoneID = 650, artID = { 674 }, x = 0.462, y = 0.12, overlay = { "0.43-0.10","0.44-0.11","0.44-0.12","0.45-0.12","0.46-0.12" }, displayID = 1995, questID = { 39994 } }; --Crab Rider Grmlrml
	[98024] = { zoneID = 650, artID = { 674 }, x = 0.508, y = 0.346, overlay = { "0.50-0.34" }, displayID = 68669, questID = { 40406 } }; --Luggut the Eggeater
	[98299] = { zoneID = 650, artID = { 674 }, x = 0.368, y = 0.162, overlay = { "0.36-0.16" }, displayID = 66811, questID = { 40084 } }; --Bodash the Hoarder
	[98311] = { zoneID = 650, artID = { 674 }, x = 0.466, y = 0.076, overlay = { "0.46-0.07" }, displayID = 22530, questID = { 40096 } }; --Mrrklr
	[98890] = { zoneID = 650, artID = { 674 }, x = 0.414, y = 0.318, overlay = { "0.41-0.31" }, displayID = 37737, questID = { 40175 } }; --Slumber
	[99929] = { zoneID = 650, artID = { 674 }, x = 0.492, y = 0.076, overlay = { "0.49-0.07" }, displayID = 66811 }; --Flotsam
	[125951] = { zoneID = 658, artID = { 680 }, x = 0.554, y = 0.84400004, overlay = { "0.52-0.83","0.52-0.81","0.53-0.80","0.53-0.82","0.53-0.83","0.54-0.83","0.54-0.84","0.55-0.84" }, displayID = 68688 }; --Obsidian Deathwarder
	[97057] = { zoneID = 672, artID = { 696 }, x = 0.812, y = 0.426, overlay = { "0.8-0.43","0.80-0.40","0.80-0.42","0.80-0.41","0.81-0.42" }, displayID = 65494, questID = { 40233 } }; --Overseer Brutarg
	[97058] = { zoneID = {
				[672] = { x = 0.636, y = 0.236, overlay = { "0.63-0.23" } };
				[674] = { x = 0.572, y = 0.53400004, overlay = { "0.47-0.64","0.48-0.58","0.48-0.6","0.49-0.57","0.49-0.55","0.49-0.56","0.5-0.54","0.5-0.58","0.5-0.61","0.50-0.57","0.50-0.59","0.51-0.53","0.51-0.54","0.51-0.58","0.51-0.59","0.51-0.61","0.52-0.60","0.52-0.57","0.53-0.56","0.53-0.59","0.53-0.54","0.53-0.58","0.53-0.62","0.53-0.60","0.54-0.61","0.54-0.55","0.57-0.63","0.57-0.53" } };
			  }, displayID = 62700, questID = { 40231 } }; --Count Nefarious
	[97059] = { zoneID = 672, artID = { 696 }, x = 0.744, y = 0.572, overlay = { "0.74-0.57" }, displayID = 66977, questID = { 40232 } }; --King Voras
	[97370] = { zoneID = 672, artID = { 696 }, x = 0.686, y = 0.278, overlay = { "0.68-0.27" }, displayID = 58049, questID = { 40234 } }; --General Volroth
	[100864] = { zoneID = 680, artID = { 704 }, x = 0.682, y = 0.58599997, overlay = { "0.68-0.58" }, displayID = 32568, questID = { 41135 } }; --Cora'kar
	[102303] = { zoneID = 680, artID = { 704 }, x = 0.48599997, y = 0.568, overlay = { "0.48-0.56" }, displayID = 73503, questID = { 40905 } }; --Lieutenant Strathmar
	[103183] = { zoneID = 680, artID = { 704 }, x = 0.802, y = 0.706, overlay = { "0.79-0.72","0.79-0.67","0.79-0.71","0.8-0.68","0.80-0.69","0.80-0.70" }, displayID = 66812, questID = { 40680 } }; --Rok'nash
	[103214] = { zoneID = 680, artID = { 704 }, x = 0.67800003, y = 0.708, overlay = { "0.67-0.70" }, displayID = 68084, questID = { 41136 } }; --Har'kess the Insatiable
	[103223] = { zoneID = 680, artID = { 704 }, x = 0.616, y = 0.396, overlay = { "0.61-0.39" }, displayID = 71158, questID = { 43993 } }; --Hertha Grimdottir
	[103575] = { zoneID = 680, artID = { 704 }, x = 0.786, y = 0.56200004, overlay = { "0.74-0.56","0.75-0.57","0.75-0.58","0.76-0.58","0.77-0.58","0.77-0.57","0.78-0.56" }, displayID = 68273, questID = { 44003 } }; --Reef Lord Raj'his
	[103787] = { zoneID = 680, artID = { 704 }, x = 0.758, y = 0.50200003, overlay = { "0.24-0.49","0.38-0.29","0.39-0.29","0.75-0.50" }, displayID = 66850 }; --Baconlisk
	[103827] = { zoneID = 680, artID = { 704 }, x = 0.874, y = 0.626, overlay = { "0.87-0.62" }, displayID = 68605, questID = { 41786 } }; --King Morgalash
	[103841] = { zoneID = 680, artID = { 704 }, x = 0.17, y = 0.266, overlay = { "0.16-0.25","0.16-0.26","0.17-0.26" }, displayID = 64536, questID = { 43996 } }; --Shadowquill
	[104519] = { zoneID = 680, artID = { 704 }, x = 0.246, y = 0.54, overlay = { "0.23-0.58","0.23-0.57","0.23-0.56","0.24-0.54" }, displayID = 66577, questID = { 45503 } }; --Colerian
	[104521] = { zoneID = 680, artID = { 704 }, x = 0.244, y = 0.542, overlay = { "0.23-0.58","0.23-0.57","0.23-0.56","0.24-0.54" }, displayID = 66269, questID = { 45504 } }; --Alteria
	[104522] = { zoneID = 680, artID = { 704 }, x = 0.246, y = 0.54, overlay = { "0.23-0.58","0.23-0.57","0.23-0.56","0.23-0.55","0.24-0.55","0.24-0.54" }, displayID = 66268, questID = { 45502 } }; --Selenyi
	[104698] = { zoneID = 680, artID = { 704 }, x = 0.244, y = 0.54, overlay = { "0.23-0.58","0.23-0.56","0.23-0.57","0.23-0.55","0.24-0.55","0.24-0.54" }, displayID = 66577, questID = { 45503 } }; --Colerian
	[105547] = { zoneID = 680, artID = { 704 }, x = 0.23799999, y = 0.256, overlay = { "0.23-0.26","0.23-0.25" }, displayID = 69191, questID = { 43484 } }; --Rauren
	[105632] = { zoneID = 680, artID = { 704 }, x = 0.25, y = 0.44, overlay = { "0.25-0.44" }, displayID = 69220, questID = { 99999 } }; --Broodmother Shu'malis
	[105728] = { zoneID = 680, artID = { 704 }, x = 0.236, y = 0.45599997, overlay = { "0.23-0.45" }, displayID = 72663, questID = { 45505 } }; --Scythemaster Cil'raman
	[105739] = { zoneID = 680, artID = { 704 }, x = 0.198, y = 0.4, overlay = { "0.18-0.39","0.19-0.40","0.19-0.4" }, displayID = 69268 }; --Sanaar
	[105899] = { zoneID = 680, artID = { 704 }, x = 0.67800003, y = 0.56200004, overlay = { "0.65-0.53","0.65-0.54","0.66-0.53","0.66-0.54","0.66-0.55","0.67-0.56","0.67-0.55" }, displayID = 72653, questID = { 45506 } }; --Oglok the Furious
	[106351] = { zoneID = 680, artID = { 704 }, x = 0.338, y = 0.15, overlay = { "0.33-0.15" }, displayID = 66577, questID = { 43717 } }; --Artificer Lothaire
	[106526] = { zoneID = 680, artID = { 704 }, x = 0.35599998, y = 0.672, overlay = { "0.35-0.67" }, displayID = 52317, questID = { 44675 } }; --Lady Rivantas
	[106532] = { zoneID = 680, artID = { 704 }, x = 0.38, y = 0.704, overlay = { "0.37-0.70","0.38-0.70" }, displayID = 64719, questID = { 44569 } }; --Inquisitor Volitix
	[107846] = { zoneID = 680, artID = { 704 }, x = 0.666, y = 0.672, overlay = { "0.66-0.67","0.66-0.66" }, displayID = 699, questID = { 43968 } }; --Pinchshank
	[109054] = { zoneID = 680, artID = { 704 }, x = 0.26, y = 0.41, overlay = { "0.26-0.41" }, displayID = 70831, questID = { 42831 } }; --Shal'an
	[109954] = { zoneID = 680, artID = { 704 }, x = 0.42, y = 0.8, overlay = { "0.42-0.8" }, displayID = 66591, questID = { 43348 } }; --Magister Phaedris
	[110024] = { zoneID = 680, artID = { 704 }, x = 0.342, y = 0.608, overlay = { "0.34-0.60" }, displayID = 71290, questID = { 43351 } }; --Mal'Dreth the Corruptor
	[110340] = { zoneID = 680, artID = { 704 }, x = 0.408, y = 0.32799998, overlay = { "0.40-0.33","0.40-0.32" }, displayID = 71536, questID = { 43358 } }; --Myonix
	[110438] = { zoneID = 680, artID = { 704 }, x = 0.372, y = 0.216, overlay = { "0.37-0.21" }, displayID = 69530, questID = { 43369 } }; --Siegemaster Aedrin
	[110577] = { zoneID = 680, artID = { 704 }, x = 0.246, y = 0.472, overlay = { "0.24-0.47" }, displayID = 70831, questID = { 43449 } }; --Oreth the Vile
	[110656] = { zoneID = 680, artID = { 704 }, x = 0.65599996, y = 0.59, overlay = { "0.65-0.59" }, displayID = 70697, questID = { 43481 } }; --Arcanist Lylandre
	[110726] = { zoneID = 680, artID = { 704 }, x = 0.626, y = 0.49, overlay = { "0.62-0.46","0.62-0.48","0.62-0.47","0.62-0.49" }, displayID = 69435, questID = { 43495 } }; --Cadraeus
	[110832] = { zoneID = 680, artID = { 704 }, x = 0.276, y = 0.65400004, overlay = { "0.27-0.65" }, displayID = 65304, questID = { 43992 } }; --Gorgroth
	[110870] = { zoneID = 680, artID = { 704 }, x = 0.42200002, y = 0.566, overlay = { "0.42-0.56" }, displayID = 71580, questID = { 43580 } }; --Apothecary Faldren
	[110944] = { zoneID = 680, artID = { 704 }, x = 0.606, y = 0.528, overlay = { "0.56-0.50","0.57-0.50","0.58-0.51","0.60-0.52","0.60-0.51" }, displayID = 67465, questID = { 43597 } }; --Guardian Thor'el
	[111007] = { zoneID = 680, artID = { 704 }, x = 0.496, y = 0.79, overlay = { "0.49-0.79" }, displayID = 69435, questID = { 43603 } }; --Randril
	[111197] = { zoneID = 680, artID = { 704 }, x = 0.336, y = 0.516, overlay = { "0.33-0.51" }, displayID = 55080, questID = { 43954 } }; --Anax
	[111329] = { zoneID = 680, artID = { 704 }, x = 0.36, y = 0.34, overlay = { "0.36-0.34" }, displayID = 64303, questID = { 43718 } }; --Matron Hagatha
	[111649] = { zoneID = 680, artID = { 704 }, x = 0.552, y = 0.632, overlay = { "0.54-0.62","0.54-0.64","0.54-0.63","0.55-0.63" }, displayID = 64719, questID = { 43794 } }; --Ambassador D'vwinn
	[111651] = { zoneID = 680, artID = { 704 }, x = 0.546, y = 0.56200004, overlay = { "0.54-0.56" }, displayID = 71874, questID = { 43792 } }; --Degren
	[111653] = { zoneID = 680, artID = { 704 }, x = 0.626, y = 0.636, overlay = { "0.62-0.63" }, displayID = 71875, questID = { 43793 } }; --Miasu
	[112497] = { zoneID = 680, artID = { 704 }, x = 0.246, y = 0.35, overlay = { "0.24-0.35" }, displayID = 68526, questID = { 44071 } }; --Maia the White
	[112705] = { zoneID = 680, artID = { 704 }, x = 0.572, y = 0.76, overlay = { "0.56-0.74","0.56-0.75","0.57-0.76" }, displayID = 72198, questID = { 45478 } }; --Achronos
	[112756] = { zoneID = 680, artID = { 704 }, x = 0.292, y = 0.888, overlay = { "0.29-0.88" }, displayID = 63676, questID = { 45477 } }; --Sorallus
	[112757] = { zoneID = 680, artID = { 704 }, x = 0.496, y = 0.796, overlay = { "0.49-0.79" }, displayID = 72280, questID = { 45476 } }; --Magistrix Vilessa
	[112758] = { zoneID = 680, artID = { 704 }, x = 0.576, y = 0.67, overlay = { "0.56-0.67","0.57-0.67" }, displayID = 72281, questID = { 45475 } }; --Auditor Esiel
	[112759] = { zoneID = 680, artID = { 704 }, x = 0.816, y = 0.618, overlay = { "0.81-0.62","0.81-0.61" }, displayID = 68084, questID = { 45471 } }; --Az'jatar
	[112760] = { zoneID = 680, artID = { 704 }, x = 0.496, y = 0.58, overlay = { "0.49-0.58" }, displayID = 72244, questID = { 45474 } }; --Volshax
	[112802] = { zoneID = 680, artID = { 704 }, x = 0.138, y = 0.524, overlay = { "0.13-0.53","0.13-0.52" }, displayID = 44781, questID = { 44124 } }; --Mar'tura
	[113694] = { zoneID = 680, artID = { 704 }, x = 0.66199994, y = 0.536, overlay = { "0.60-0.40","0.62-0.46","0.62-0.52","0.62-0.53","0.64-0.47","0.64-0.48","0.66-0.53" }, displayID = 67421 }; --Pashya
	[99610] = { zoneID = 680, artID = { 704 }, x = 0.53, y = 0.30200002, overlay = { "0.53-0.30" }, displayID = 64664, questID = { 40897 } }; --Garvrulg
	[99792] = { zoneID = 680, artID = { 704 }, x = 0.236, y = 0.53, overlay = { "0.22-0.51","0.23-0.52","0.23-0.53" }, displayID = 66341, questID = { 41319 } }; --Elfbane
	[99899] = { zoneID = 680, artID = { 704 }, x = 0.802, y = 0.65800005, overlay = { "0.76-0.60","0.76-0.58","0.76-0.59","0.79-0.58","0.79-0.65","0.79-0.62","0.8-0.65","0.80-0.65" }, displayID = 68227, questID = { 44669 } }; --Vicious Whale Shark
	[96647] = { zoneID = 703, artID = { 727 }, x = 0.25, y = 0.546, displayID = 34706 }; --Earlnoc the Beastbreaker
	[99802] = { zoneID = 703, artID = { 727 }, x = 0.55799997, y = 0.60400003, displayID = 24490 }; --Arthfael
	[103045] = { zoneID = 707, artID = { 731 }, x = 0.41599998, y = 0.598, displayID = 67969, questID = { 43691 } }; --Plaguemaw
	[103605] = { zoneID = 707, artID = { 731 }, x = 0.312, y = 0.584, displayID = 65753, questID = { 43690 } }; --Shroudseeker
	[108494] = { zoneID = 707, artID = { 731 }, x = 0.318, y = 0.56, displayID = 70577, questID = { 43689 } }; --Soulfiend Tagerma
	[108794] = { zoneID = 707, artID = { 731 }, x = 0.314, y = 0.552, displayID = 65753 }; --Shroudseeker's Shadow
	[96997] = { zoneID = 711, artID = { 735 }, x = 0.532, y = 0.296, overlay = { "0.46-0.28","0.47-0.28","0.48-0.33","0.48-0.29","0.48-0.30","0.48-0.31","0.48-0.28","0.48-0.3","0.49-0.31","0.49-0.32","0.49-0.33","0.5-0.27","0.50-0.31","0.50-0.27","0.50-0.30","0.51-0.29","0.52-0.30","0.53-0.29" }, displayID = 68182, questID = { 40251 } }; --Kethrazor
	[97069] = { zoneID = 711, artID = { 735 }, x = 0.696, y = 0.278, overlay = { "0.68-0.28","0.69-0.26","0.69-0.27","0.69-0.28","0.69-0.30" }, displayID = 20047, questID = { 40301 } }; --Wrath-Lord Lekos
	[101411] = { zoneID = 713, artID = { 737 }, x = 0.24200001, y = 0.31, displayID = 44923 }; --Gom Crabbar
	[101467] = { zoneID = 713, artID = { 737 }, x = 0.886, y = 0.35799998, overlay = { "0.88-0.36","0.88-0.35" }, displayID = 17654 }; --Jaggen-Ra
	[108541] = { zoneID = 713, artID = { 737 }, x = 0.254, y = 0.29799998, displayID = 27870 }; --Dread Corsair
	[108543] = { zoneID = 713, artID = { 737 }, x = 0.258, y = 0.304, overlay = { "0.25-0.30" }, displayID = 35574 }; --Dread Captain Thedon
	[91788] = { zoneID = 713, artID = { 737 }, x = 0.314, y = 0.506, displayID = 67197 }; --Shellmaw
	[112708] = { zoneID = 726, artID = { 750 }, x = 0.276, y = 0.428, overlay = { "0.25-0.41","0.27-0.42" }, displayID = 32457 }; --Grimtotem Champion
	[103199] = { zoneID = 731, artID = { 756 }, x = 0.354, y = 0.794, displayID = 68076 }; --Ragoul
	[103247] = { zoneID = 731, artID = { 756 }, x = 0.622, y = 0.88199997, displayID = 68143 }; --Ultanok
	[103271] = { zoneID = 731, artID = { 756 }, x = 0.42200002, y = 0.126, displayID = 66850 }; --Kraxa
	[101641] = { zoneID = 733, artID = { 758 }, x = 0.2997, y = 0.3924, displayID = 67273 }; --Mythana
	[101660] = { zoneID = 733, artID = { 758 }, x = 0.17, y = 0.202, displayID = 67290 }; --Rage Rot
	[99362] = { zoneID = 733, artID = { 758 }, x = 0.33400002, y = 0.812, displayID = 57886 }; --Kudzilla
	[111021] = { zoneID = 749, artID = { 774 }, x = 0.4802, y = 0.8153, displayID = 32962 }; --Sludge Face
	[111052] = { zoneID = 749, artID = { 774 }, x = 0.472, y = 0.412, displayID = 71702 }; --Silver Serpent
	[111057] = { zoneID = 749, artID = { 774 }, x = 0.346, y = 0.50200003, displayID = 20852 }; --The Rat King
	[115914] = { zoneID = 764, artID = { 789 }, x = 0.469, y = 0.5643, displayID = 71134 }; --Torm the Brute
	[112712] = { zoneID = 765, artID = { 790 }, x = 0.45, y = 0.30200002, displayID = 72206 }; --Gilded Guardian
	[115847] = { zoneID = 765, artID = { 790 }, x = 0.3959, y = 0.4378, displayID = 73967 }; --Ariadne
	[116008] = { zoneID = 765, artID = { 790 }, x = 0.4624, y = 0.4487, displayID = 74021 }; --Kar'zun
	[116395] = { zoneID = 766, artID = { 791 }, x = 0.4493, y = 0.4882, displayID = 69552 }; --Nightwell Diviner
	[115853] = { zoneID = 767, artID = { 792 }, x = 0.5758, y = 0.4823, displayID = 55774 }; --Doomlash
	[116004] = { zoneID = 767, artID = { 792 }, x = 0.2075, y = 0.588, displayID = 66836 }; --Flightmaster Volnath
	[116059] = { zoneID = 767, artID = { 792 }, x = 0.2095, y = 0.5999, displayID = 74348 }; --Regal Cloudwing
	[116159] = { zoneID = 767, artID = { 792 }, x = 0, y = 0, displayID = 69961 }; --Wily Sycophant
	[116185] = { zoneID = 767, artID = { 792 }, x = 0, y = 0, displayID = 74089 }; --Attendant Keeper
	[116158] = { zoneID = 771, artID = { 796 }, x = 0.5935, y = 0.4813, displayID = 69968 }; --Tower Concubine
	[116230] = { zoneID = 771, artID = { 796 }, x = 0.5006, y = 0.342, displayID = 74106 }; --Exotic Concubine
	[111573] = { zoneID = 790, artID = { 815 }, x = 0.478, y = 0.492, overlay = { "0.45-0.50","0.46-0.49","0.46-0.47","0.46-0.50","0.47-0.47","0.47-0.49","0.47-0.48" }, displayID = 71850, questID = { 45479 } }; --Kosumoth the Hungering
	[120393] = { zoneID = 830, artID = { 855 }, x = 0.58599997, y = 0.768, overlay = { "0.58-0.75","0.58-0.76" }, displayID = 75765, questID = { 48627 } }; --Siegemaster Voraan
	[122911] = { zoneID = 830, artID = { 855 }, x = 0.396, y = 0.588, overlay = { "0.38-0.59","0.39-0.59","0.39-0.58" }, displayID = 78156, questID = { 48563 } }; --Commander Vecaya
	[122912] = { zoneID = 830, artID = { 855 }, x = 0.336, y = 0.752, overlay = { "0.33-0.75" }, displayID = 78814, questID = { 48562 } }; --Commander Sathrenael
	[123464] = { zoneID = 830, artID = { 855 }, x = 0.53, y = 0.31, overlay = { "0.52-0.31","0.53-0.31" }, displayID = 77324, questID = { 48565 } }; --Sister Subversia
	[123689] = { zoneID = 830, artID = { 855 }, x = 0.556, y = 0.8, overlay = { "0.54-0.81","0.55-0.80","0.55-0.8" }, displayID = 77540, questID = { 48628 } }; --Talestra the Vile
	[124775] = { zoneID = 830, artID = { 855 }, x = 0.45, y = 0.588, overlay = { "0.44-0.58","0.45-0.58" }, displayID = 78200, questID = { 48564 } }; --Commander Endaxis
	[124804] = { zoneID = 830, artID = { 855 }, x = 0.696, y = 0.568, overlay = { "0.69-0.56","0.69-0.57" }, displayID = 78217, questID = { 48664 } }; --Tereck the Selector
	[125388] = { zoneID = 830, artID = { 855 }, x = 0.61, y = 0.206, overlay = { "0.60-0.19","0.61-0.20" }, displayID = 74446, questID = { 48629 } }; --Vagath the Betrayed
	[125479] = { zoneID = 830, artID = { 855 }, x = 0.70199996, y = 0.816, overlay = { "0.69-0.80","0.7-0.81","0.70-0.81" }, displayID = 41574, questID = { 48665 } }; --Tar Spitter
	[125820] = { zoneID = 830, artID = { 855 }, x = 0.42200002, y = 0.7, overlay = { "0.42-0.7" }, displayID = 72942, questID = { 48666 } }; --Imp Mother Laglath
	[126419] = { zoneID = 830, artID = { 855 }, x = 0.71, y = 0.324, overlay = { "0.70-0.34","0.70-0.33","0.71-0.32" }, displayID = 78926, questID = { 48667 } }; --Naroua
	[125824] = { zoneID = 833, artID = { 858 }, x = 0.44799998, y = 0.482, overlay = { "0.36-0.35","0.36-0.37","0.36-0.36","0.37-0.38","0.37-0.35","0.37-0.4","0.38-0.36","0.38-0.42","0.38-0.39","0.38-0.4","0.38-0.41","0.38-0.37","0.39-0.40","0.39-0.42","0.39-0.38","0.39-0.41","0.39-0.37","0.39-0.39","0.4-0.43","0.40-0.42","0.40-0.45","0.40-0.38","0.40-0.43","0.40-0.41","0.41-0.40","0.41-0.43","0.41-0.45","0.41-0.42","0.42-0.44","0.42-0.45","0.42-0.47","0.43-0.47","0.43-0.48","0.43-0.49","0.44-0.48" }, displayID = 78946, questID = { 48561 } }; --Khazaduum
	[120713] = { zoneID = 845, artID = { 870 }, x = 0.7227, y = 0.5109, displayID = 20914 }; --Wa'glur
	[120715] = { zoneID = 845, artID = { 870 }, x = 0.6015, y = 0.1868, displayID = 66219 }; --Raga'yut
	[120717] = { zoneID = 845, artID = { 870 }, x = 0.475, y = 0.1167, displayID = 57400 }; --Mistress Dominix
	[120716] = { zoneID = 847, artID = { 872 }, x = 0.5283, y = 0.1898, displayID = 74572 }; --Dreadspeaker Serilis
	[120712] = { zoneID = 848, artID = { 873 }, x = 0.4703, y = 0.8746, displayID = 29442 }; --Larithia
	[120020] = { zoneID = 850, artID = { 875 }, x = 0.6278, y = 0.5702, displayID = 76068 }; --Erdu'val
	[120012] = { zoneID = 851, artID = { 876 }, x = 0.6397, y = 0.6256, displayID = 75602 }; --Dresanoth
	[120021] = { zoneID = 851, artID = { 876 }, x = 0.3274, y = 0.5179, displayID = 75607 }; --Kelpfist
	[120003] = { zoneID = 852, artID = { 877 }, x = 0.6436, y = 0.6463, displayID = 75588 }; --Warlord Darjah
	[120013] = { zoneID = 852, artID = { 877 }, x = 0.5935, y = 0.8776, displayID = 75603 }; --The Dread Stalker
	[120019] = { zoneID = 852, artID = { 877 }, x = 0.5138, y = 0.3825, displayID = 75605 }; --Ryul the Fading
	[120022] = { zoneID = 852, artID = { 877 }, x = 0.6192, y = 0.8647, displayID = 75608 }; --Deepmaw
	[122004] = { zoneID = 862, artID = { 887 }, x = 0.71199995, y = 0.324, overlay = { "0.71-0.32" }, displayID = 83645, questID = { 47567 } }; --Umbra'jin
	[124185] = { zoneID = 862, artID = { 887 }, x = 0.74, y = 0.282, overlay = { "0.74-0.28" }, displayID = 42949, questID = { 47792 } }; --Golrakahn
	[126637] = { zoneID = 862, artID = { 887 }, x = 0.686, y = 0.48599997, overlay = { "0.68-0.48" }, displayID = 79019, questID = { 48543 } }; --Kandak
	[127939] = { zoneID = 862, artID = { 887 }, x = 0.468, y = 0.65599996, overlay = { "0.46-0.65" }, displayID = 79702, questID = { 49004 } }; --Torraske the Eternal
	[128699] = { zoneID = 862, artID = { 887 }, x = 0.598, y = 0.184, overlay = { "0.59-0.18" }, displayID = 83539, questID = { 49267 } }; --Bloodbulge
	[129343] = { zoneID = 862, artID = { 887 }, x = 0.498, y = 0.576, overlay = { "0.49-0.57" }, displayID = 86628, questID = { 49410 } }; --Avatar of Xolotal
	[129954] = { zoneID = 862, artID = { 887 }, x = 0.644, y = 0.324, overlay = { "0.64-0.32" }, displayID = 58892, questID = { 50439 } }; --Gahz'ralka
	[129961] = { zoneID = 862, artID = { 887 }, x = 0.81, y = 0.216, overlay = { "0.80-0.21","0.81-0.21" }, displayID = 82078, questID = { 50280 } }; --Atal'zul Gotaka
	[130643] = { zoneID = 862, artID = { 887 }, x = 0.768, y = 0.278, overlay = { "0.76-0.27" }, displayID = 82976, questID = { 50333 } }; --Twisted Child of Rezan
	[131233] = { zoneID = 862, artID = { 887 }, x = 0.588, y = 0.742, overlay = { "0.58-0.74" }, displayID = 42065, questID = { 49911 } }; --Lei-zhi
	[131476] = { zoneID = 862, artID = { 887 }, x = 0.482, y = 0.542, overlay = { "0.48-0.54" }, displayID = 81852, questID = { 49972 } }; --Zayoos
	[131687] = { zoneID = 862, artID = { 887 }, x = 0.77599996, y = 0.11, overlay = { "0.77-0.11","0.77-0.10" }, displayID = 44916, questID = { 50013 } }; --Tambano
	[131704] = { zoneID = 862, artID = { 887 }, x = 0.628, y = 0.14, overlay = { "0.62-0.14" }, displayID = 83795, questID = { 50661 } }; --Coati
	[131718] = { zoneID = 862, artID = { 887 }, x = 0.666, y = 0.324, overlay = { "0.66-0.32" }, displayID = 76655, questID = { 50034 } }; --Bramblewing
	[132244] = { zoneID = 862, artID = { 887 }, x = 0.756, y = 0.36, overlay = { "0.75-0.35","0.75-0.36" }, displayID = 77474, questID = { 50159 } }; --Kiboku
	[132253] = { zoneID = 862, artID = { 887 }, x = 0.69609916, y = 0.2948838, overlay = { "0.69-0.31" }, displayID = 76667, weeklyReset = true, questID = { 52998 } }; --Ji'arak
	[133155] = { zoneID = 862, artID = { 887 }, x = 0.8, y = 0.36, overlay = { "0.8-0.36" }, displayID = 68084, questID = { 50260 } }; --G'Naat
	[133163] = { zoneID = 862, artID = { 887 }, x = 0.64599997, y = 0.236, overlay = { "0.64-0.23" }, displayID = 47818, questID = { 50263 } }; --Tia'Kawan
	[133190] = { zoneID = 862, artID = { 887 }, x = 0.742, y = 0.396, overlay = { "0.74-0.39" }, displayID = 40913, questID = { 50269 } }; --Daggerjaw
	[133842] = { zoneID = 862, artID = { 887 }, x = 0.44, y = 0.256, overlay = { "0.44-0.25" }, displayID = 79721, questID = { 50438 } }; --Warcrawler Karkithiss
	[134048] = { zoneID = 862, artID = { 887 }, x = 0.62, y = 0.462, overlay = { "0.62-0.46" }, displayID = 4065, questID = { 50508 } }; --Vukuba
	[134637] = { zoneID = 862, artID = { 887 }, x = 0.63, y = 0.14, overlay = { "0.63-0.14" }, displayID = 83842, questID = { 50661 } }; --Headhunter Lee'za
	[134717] = { zoneID = 862, artID = { 887 }, x = 0.49, y = 0.292, overlay = { "0.49-0.29" }, displayID = 53283, questID = { 50673 } }; --Umbra'rix
	[134738] = { zoneID = 862, artID = { 887 }, x = 0.42200002, y = 0.36, overlay = { "0.42-0.36" }, displayID = 83798, questID = { 50677 } }; --Hakbi the Risen
	[134760] = { zoneID = 862, artID = { 887 }, x = 0.65199995, y = 0.102, overlay = { "0.65-0.10" }, displayID = 83849, questID = { 50693 } }; --Darkspeaker Jo'la
	[134782] = { zoneID = 862, artID = { 887 }, x = 0.606, y = 0.66199994, overlay = { "0.60-0.66" }, displayID = 55918, questID = { 50281 } }; --Murderbeak
	[136413] = { zoneID = 862, artID = { 887 }, x = 0.536, y = 0.44799998, overlay = { "0.53-0.44" }, displayID = 74896, questID = { 51080 } }; --Syrawon the Dominus
	[136428] = { zoneID = 862, artID = { 887 }, x = 0.44, y = 0.766, overlay = { "0.44-0.76" }, displayID = 83266, questID = { 51083 } }; --Dark Chronicler
	[142434] = { zoneID = 862, artID = { 887 }, x = 0.706, y = 0.081999995, overlay = { "0.70-0.08" }, displayID = 8844 }; --Loo'ay
	[142475] = { zoneID = 862, artID = { 887 }, x = 0.706, y = 0.081999995, overlay = { "0.70-0.08" }, displayID = 33971 }; --Ka'za the Mezmerizing
	[143314] = { zoneID = 862, artID = { 887 }, x = 0.45599997, y = 0.79, overlay = { "0.45-0.79" }, displayID = 83608, reset = true }; --Bane of the Woods
	[143536] = { zoneID = 862, artID = { 887 }, x = 0.516, y = 0.582, overlay = { "0.51-0.58" }, friendly = { "H" }, displayID = 82682 }; --High Warlord Volrath
	[145391] = { zoneID = 862, artID = { 887 }, x = 0.77199996, y = 0.376, overlay = { "0.77-0.37" }, friendly = { "A" }, displayID = 90018, questReset = true, questID = { 54016 } }; --Caravan Leader
	[148198] = { zoneID = 862, artID = { 887 }, x = 0.77199996, y = 0.41799998, overlay = { "0.77-0.41" }, friendly = { "H" }, displayID = 89913, questID = { 54504 } }; --Scout Captain Grizzleknob
	[148231] = { zoneID = 862, artID = { 887 }, x = 0.76199996, y = 0.35599998, overlay = { "0.76-0.35" }, friendly = { "H" }, displayID = 89929, questReset = true, questID = { 54508 } }; --Siegebreaker Vol'gar
	[148253] = { zoneID = 862, artID = { 887 }, x = 0.786, y = 0.55799997, overlay = { "0.78-0.55" }, friendly = { "H" }, displayID = 89938, questReset = true, questID = { 54511 } }; --Death Captain Detheca
	[148257] = { zoneID = 862, artID = { 887 }, x = 0.786, y = 0.55799997, overlay = { "0.78-0.55" }, friendly = { "H" }, displayID = 89939, questReset = true, questID = { 54511 } }; --Death Captain Danielle
	[148259] = { zoneID = 862, artID = { 887 }, x = 0.786, y = 0.55799997, overlay = { "0.78-0.55" }, friendly = { "H" }, displayID = 89941, questReset = true, questID = { 54511 } }; --Death Captain Delilah
	[148264] = { zoneID = 862, artID = { 887 }, x = 0.674, y = 0.376, overlay = { "0.67-0.37" }, friendly = { "H" }, displayID = 89945, questReset = true, questID = { 54513 } }; --Dinomancer Dajingo
	[148276] = { zoneID = 862, artID = { 887 }, x = 0.83199996, y = 0.528, overlay = { "0.83-0.52" }, friendly = { "H" }, displayID = 89947, questID = { 54515 } }; --Tidebinder Maka
	[148308] = { zoneID = 862, artID = { 887 }, x = 0.77599996, y = 0.48400003, overlay = { "0.77-0.48" }, displayID = 89964, questReset = true, questID = { 54522 } }; --Eric Quietfist
	[148322] = { zoneID = 862, artID = { 887 }, x = 0.76199996, y = 0.336, overlay = { "0.76-0.33" }, friendly = { "A" }, displayID = 89968, questID = { 54523 } }; --Blinky Gizmospark
	[148343] = { zoneID = 862, artID = { 887 }, x = 0.648, y = 0.398, overlay = { "0.64-0.39" }, friendly = { "A" }, displayID = 89972, questID = { 54527 } }; --Dinohunter Wildbeard
	[148390] = { zoneID = 862, artID = { 887 }, x = 0.756, y = 0.36, overlay = { "0.75-0.36" }, friendly = { "A" }, displayID = 90008, questReset = true, questID = { 54532 } }; --Jessibelle Moonshield
	[148393] = { zoneID = 862, artID = { 887 }, x = 0.756, y = 0.36, overlay = { "0.75-0.36" }, friendly = { "A" }, displayID = 54675, questReset = true, questID = { 54532 } }; --Ancient Defender
	[148403] = { zoneID = 862, artID = { 887 }, x = 0.79, y = 0.44599998, overlay = { "0.79-0.44" }, friendly = { "A" }, displayID = 90013, questID = { 54535 } }; --Portal Keeper Romiir
	[148428] = { zoneID = 862, artID = { 887 }, x = 0.752, y = 0.496, overlay = { "0.75-0.49" }, friendly = { "H" }, displayID = 88884, questID = { 54537 } }; --Bilestomper
	[149147] = { zoneID = 862, artID = { 887 }, x = 0.696, y = 0.378, overlay = { "0.69-0.35","0.69-0.36","0.69-0.37" }, displayID = 83648, questID = { 54770 } }; --N'chala the Egg Thief
	[121242] = { zoneID = 863, artID = { 888 }, x = 0.688, y = 0.576, overlay = { "0.68-0.56","0.68-0.57" }, displayID = 32264, questID = { 50361 } }; --Glompmaw
	[124375] = { zoneID = 863, artID = { 888 }, x = 0.626, y = 0.644, overlay = { "0.62-0.65","0.62-0.64" }, displayID = 77980, questID = { 47827 } }; --Overstuffed Saurolisk
	[124397] = { zoneID = 863, artID = { 888 }, x = 0.528, y = 0.136, overlay = { "0.52-0.13" }, displayID = 80333, questID = { 47843 } }; --Kal'draxa
	[124399] = { zoneID = 863, artID = { 888 }, x = 0.246, y = 0.77800006, overlay = { "0.24-0.78","0.24-0.77" }, displayID = 74268, questID = { 47877 } }; --Infected Direhorn
	[124475] = { zoneID = 863, artID = { 888 }, x = 0.292, y = 0.556, overlay = { "0.29-0.55" }, displayID = 79803, questID = { 47878 } }; --Shambling Ambusher
	[125214] = { zoneID = 863, artID = { 888 }, x = 0.76, y = 0.366, overlay = { "0.75-0.36","0.76-0.36" }, displayID = 50962, questID = { 48052 } }; --Krubbs
	[125232] = { zoneID = 863, artID = { 888 }, x = 0.818, y = 0.306, overlay = { "0.81-0.30" }, displayID = 80189, questID = { 48057 } }; --Captain Mu'kala
	[125250] = { zoneID = 863, artID = { 888 }, x = 0.67800003, y = 0.296, overlay = { "0.67-0.29" }, displayID = 78396, questID = { 48063 } }; --Ancient Jawbreaker
	[126056] = { zoneID = 863, artID = { 888 }, x = 0.49400002, y = 0.376, overlay = { "0.49-0.37" }, displayID = 78669, questID = { 48406 } }; --Totem Maker Jash'ga
	[126142] = { zoneID = 863, artID = { 888 }, x = 0.428, y = 0.606, overlay = { "0.42-0.60" }, displayID = 78750, questID = { 48439 } }; --Bajiatha
	[126187] = { zoneID = 863, artID = { 888 }, x = 0.41599998, y = 0.53400004, overlay = { "0.41-0.53" }, displayID = 78779, questID = { 48462 } }; --Corpse Bringer Yal'kar
	[126460] = { zoneID = 863, artID = { 888 }, x = 0.316, y = 0.38599998, overlay = { "0.31-0.38" }, displayID = 81103, questID = { 48508 } }; --Tainted Guardian
	[126635] = { zoneID = 863, artID = { 888 }, x = 0.432, y = 0.91199994, overlay = { "0.43-0.91" }, displayID = 79016, questID = { 48541 } }; --Blood Priest Xak'lar
	[126907] = { zoneID = 863, artID = { 888 }, x = 0.49, y = 0.508, overlay = { "0.49-0.50" }, displayID = 79159, questID = { 48623 } }; --Wardrummer Zurula
	[126926] = { zoneID = 863, artID = { 888 }, x = 0.29799998, y = 0.518, overlay = { "0.29-0.50","0.29-0.51" }, displayID = 40269, questID = { 48626 } }; --Venomjaw
	[127001] = { zoneID = 863, artID = { 888 }, x = 0.338, y = 0.862, overlay = { "0.33-0.87","0.33-0.86" }, displayID = 79591, questID = { 48638 } }; --Gwugnug the Cursed
	[127820] = { zoneID = 863, artID = { 888 }, x = 0.59, y = 0.39, overlay = { "0.59-0.39" }, displayID = 82183, questID = { 48972 } }; --Scout Skrasniss
	[127873] = { zoneID = 863, artID = { 888 }, x = 0.58599997, y = 0.096, overlay = { "0.57-0.09","0.57-0.08","0.58-0.09" }, displayID = 79648, questID = { 48980 } }; --Scrounger Patriarch
	[128426] = { zoneID = 863, artID = { 888 }, x = 0.32599998, y = 0.436, overlay = { "0.32-0.43","0.32-0.42" }, displayID = 79919, questID = { 49231 } }; --Gutrip
	[128578] = { zoneID = 863, artID = { 888 }, x = 0.396, y = 0.506, overlay = { "0.39-0.5","0.39-0.49","0.39-0.50" }, displayID = 65837, questID = { 50460 } }; --Zujothgul
	[128584] = { zoneID = 863, artID = { 888 }, x = 0.468, y = 0.338, overlay = { "0.46-0.33" }, displayID = 66284, questID = { 50366 } }; --Vugthuth
	[128610] = { zoneID = 863, artID = { 888 }, x = 0.498, y = 0.67, overlay = { "0.49-0.67" }, displayID = 88376, questID = { 50467 } }; --Maw of Shul-Nagruth
	[128930] = { zoneID = 863, artID = { 888 }, x = 0.52599996, y = 0.546, overlay = { "0.52-0.53","0.52-0.54" }, displayID = 78853, questID = { 50040 } }; --Rohnkor
	[128935] = { zoneID = 863, artID = { 888 }, x = 0.528, y = 0.546, overlay = { "0.52-0.53","0.52-0.54" }, displayID = 76134, questID = { 50040 } }; --Mala'kili
	[128965] = { zoneID = 863, artID = { 888 }, x = 0.442, y = 0.488, overlay = { "0.44-0.48" }, displayID = 80299, questID = { 49305 } }; --Uroku the Bound
	[128974] = { zoneID = 863, artID = { 888 }, x = 0.578, y = 0.674, overlay = { "0.57-0.67" }, displayID = 80307, questID = { 49312 } }; --Queen Tzxi'kik
	[129005] = { zoneID = 863, artID = { 888 }, x = 0.532, y = 0.428, overlay = { "0.53-0.42" }, displayID = 80326, questID = { 49317 } }; --King Kooba
	[129657] = { zoneID = 863, artID = { 888 }, x = 0.38799998, y = 0.27, overlay = { "0.38-0.27" }, displayID = 80299, questID = { 49469 } }; --Za'amar the Queen's Blade
	[132701] = { zoneID = 863, artID = { 888 }, x = 0.35599998, y = 0.336, overlay = { "0.35-0.32","0.35-0.33" }, displayID = 82592, weeklyReset = true, questID = { 52181 } }; --T'zane
	[133373] = { zoneID = 863, artID = { 888 }, x = 0.45599997, y = 0.52599996, overlay = { "0.45-0.51","0.45-0.52" }, displayID = 82877, questID = { 50307 } }; --Jax'teb the Reanimated
	[133527] = { zoneID = 863, artID = { 888 }, x = 0.286, y = 0.336, overlay = { "0.27-0.34","0.28-0.34","0.28-0.33","0.28-0.35" }, displayID = 47819, questID = { 50342 } }; --Juba the Scarred
	[133531] = { zoneID = 863, artID = { 888 }, x = 0.366, y = 0.506, overlay = { "0.36-0.50" }, displayID = 82986, questID = { 50348 } }; --Xu'ba
	[133539] = { zoneID = 863, artID = { 888 }, x = 0.786, y = 0.442, overlay = { "0.77-0.44","0.77-0.45","0.78-0.44" }, displayID = 82989, questID = { 50355 } }; --Lo'kuno
	[133812] = { zoneID = 863, artID = { 888 }, x = 0.38799998, y = 0.71599996, overlay = { "0.38-0.71" }, displayID = 83646, questID = { 50423 } }; --Zanxib
	[134002] = { zoneID = 863, artID = { 888 }, x = 0.552, y = 0.578, overlay = { "0.55-0.57" }, displayID = 63570, questID = { 50480 } }; --Underlord Xerxiz
	[134293] = { zoneID = 863, artID = { 888 }, x = 0.33200002, y = 0.276, overlay = { "0.33-0.27" }, displayID = 82998, questID = { 50563 } }; --Azerite-Infused Slag
	[134294] = { zoneID = 863, artID = { 888 }, x = 0.816, y = 0.61, overlay = { "0.81-0.60","0.81-0.61" }, displayID = 34274, questID = { 50565 } }; --Enraged Water Elemental
	[134296] = { zoneID = 863, artID = { 888 }, x = 0.68, y = 0.2, overlay = { "0.68-0.2" }, displayID = 71937, questID = { 50567 } }; --Lucille
	[134298] = { zoneID = 863, artID = { 888 }, x = 0.54, y = 0.808, overlay = { "0.54-0.80" }, displayID = 83535, questID = { 50569 } }; --Azerite-Infused Elemental
	[143311] = { zoneID = 863, artID = { 888 }, x = 0.736, y = 0.488, overlay = { "0.73-0.49","0.73-0.48" }, displayID = 83606, reset = true }; --Toadcruel
	[143316] = { zoneID = 863, artID = { 888 }, x = 0.52599996, y = 0.7, overlay = { "0.52-0.69","0.52-0.7" }, displayID = 83607, reset = true }; --Skullcap
	[148637] = { zoneID = 863, artID = { 888 }, x = 0.52599996, y = 0.22600001, overlay = { "0.52-0.22" }, friendly = { "H" }, displayID = 90085, questReset = true, questID = { 54663 } }; --Shadow Hunter Vol'tris
	[148642] = { zoneID = 863, artID = { 888 }, x = 0.826, y = 0.43, overlay = { "0.82-0.41","0.82-0.42","0.82-0.43" }, friendly = { "A" }, displayID = 90018, questReset = true, questID = { 54664 } }; --Caravan Leader
	[148651] = { zoneID = 863, artID = { 888 }, x = 0.426, y = 0.22799999, overlay = { "0.42-0.22","0.42-0.23" }, friendly = { "A" }, displayID = 89962, questReset = true, questID = { 54671 } }; --Overgrown Ancient
	[148674] = { zoneID = 863, artID = { 888 }, x = 0.71199995, y = 0.186, overlay = { "0.71-0.18" }, friendly = { "H" }, displayID = 90101, questReset = true, questID = { 54680 } }; --Plague Master Herbert
	[148679] = { zoneID = 863, artID = { 888 }, x = 0.632, y = 0.03, overlay = { "0.63-0.04","0.63-0.03" }, friendly = { "H" }, displayID = 90105, questReset = true, questID = { 54684 } }; --Arcanist Quintril
	[148744] = { zoneID = 863, artID = { 888 }, x = 0.508, y = 0.266, overlay = { "0.50-0.26" }, friendly = { "H" }, displayID = 90116, questReset = true, questID = { 54691 } }; --Brewmaster Lin
	[148753] = { zoneID = 863, artID = { 888 }, x = 0.528, y = 0.136, overlay = { "0.52-0.13" }, friendly = { "H" }, displayID = 90125, questReset = true, questID = { 54693 } }; --Ptin'go
	[148759] = { zoneID = 863, artID = { 888 }, x = 0.49, y = 0.162, overlay = { "0.48-0.16","0.49-0.16" }, friendly = { "H" }, displayID = 90128, questReset = true, questID = { 54694 } }; --Stormcaller Morka
	[148779] = { zoneID = 863, artID = { 888 }, x = 0.808, y = 0.156, overlay = { "0.80-0.15" }, friendly = { "A" }, displayID = 75584, questReset = true, questID = { 54697 } }; --Lightforged Warframe
	[148792] = { zoneID = 863, artID = { 888 }, x = 0.488, y = 0.118, overlay = { "0.48-0.11" }, friendly = { "A" }, displayID = 90131, questReset = true, questID = { 54699 } }; --Skycaptain Thermospark
	[148813] = { zoneID = 863, artID = { 888 }, x = 0.524, y = 0.274, overlay = { "0.52-0.27" }, friendly = { "A" }, displayID = 90138, questReset = true, questID = { 54700 } }; --Thomas Vandergrief
	[148842] = { zoneID = 863, artID = { 888 }, x = 0.542, y = 0.078, overlay = { "0.54-0.07" }, friendly = { "A" }, displayID = 32648, questReset = true, questID = { 54707 } }; --Siegeotron
	[149383] = { zoneID = 863, artID = { 888 }, x = 0.506, y = 0.176, overlay = { "0.50-0.17" }, friendly = { "H" }, displayID = 90305, questReset = true, questID = { 54839 } }; --Xizz Gutshank
	[124722] = { zoneID = 864, artID = { 889 }, x = 0.428, y = 0.926, overlay = { "0.42-0.92" }, displayID = 79859, questID = { 50905 } }; --Commodore Calhoun
	[127776] = { zoneID = 864, artID = { 889 }, x = 0.44599998, y = 0.802, overlay = { "0.44-0.80" }, displayID = 79365, questID = { 48960 } }; --Scaleclaw Broodmother
	[128497] = { zoneID = 864, artID = { 889 }, x = 0.312, y = 0.804, overlay = { "0.31-0.80" }, displayID = 80176, questID = { 49251 } }; --Bajiani the Slick
	[128553] = { zoneID = 864, artID = { 889 }, x = 0.488, y = 0.89, overlay = { "0.48-0.89" }, displayID = 82998, questID = { 49252 } }; --Azer'tor
	[128674] = { zoneID = 864, artID = { 889 }, x = 0.64, y = 0.47599998, overlay = { "0.64-0.47" }, displayID = 80078, questID = { 49270 } }; --Gut-Gut the Glutton
	[128686] = { zoneID = 864, artID = { 889 }, x = 0.352, y = 0.516, overlay = { "0.35-0.51" }, displayID = 83351, questID = { 50528 } }; --Kamid the Trapper
	[128951] = { zoneID = 864, artID = { 889 }, x = 0.438, y = 0.864, overlay = { "0.43-0.86" }, displayID = 80291, questID = { 50898 } }; --Nez'ara
	[129027] = { zoneID = 864, artID = { 889 }, x = 0.59599996, y = 0.088, overlay = { "0.57-0.06","0.58-0.07","0.59-0.08" }, displayID = 76904, questID = { 50362 } }; --Golanar
	[129180] = { zoneID = 864, artID = { 889 }, x = 0.37, y = 0.466, overlay = { "0.37-0.46" }, displayID = 80424, questID = { 49373 } }; --Warbringer Hozzik
	[129283] = { zoneID = 864, artID = { 889 }, x = 0.376, y = 0.84800005, overlay = { "0.37-0.84" }, displayID = 80500, questID = { 49392 } }; --Jumbo Sandsnapper
	[129411] = { zoneID = 864, artID = { 889 }, x = 0.44, y = 0.53400004, overlay = { "0.43-0.53","0.44-0.53" }, displayID = 80585, questID = { 48319 } }; --Zunashi the Exile
	[129476] = { zoneID = 864, artID = { 889 }, x = 0.49, y = 0.5, overlay = { "0.48-0.50","0.49-0.5" }, displayID = 80618, questID = { 47562 } }; --Bloated Krolusk
	[130401] = { zoneID = 864, artID = { 889 }, x = 0.572, y = 0.732, overlay = { "0.57-0.73" }, displayID = 81189, questID = { 49674 } }; --Vathikur
	[130439] = { zoneID = 864, artID = { 889 }, x = 0.546, y = 0.156, overlay = { "0.54-0.15" }, displayID = 49064, questID = { 47532 } }; --Ashmane
	[130443] = { zoneID = 864, artID = { 889 }, x = 0.536, y = 0.536, overlay = { "0.53-0.53" }, displayID = 81233, questID = { 47533 } }; --Hivemother Kraxi
	[133843] = { zoneID = 864, artID = { 889 }, x = 0.41599998, y = 0.24, overlay = { "0.41-0.24" }, displayID = 80412, questID = { 51073 } }; --First Mate Swainbeak
	[134571] = { zoneID = 864, artID = { 889 }, x = 0.47, y = 0.256, overlay = { "0.47-0.25" }, displayID = 83761, questID = { 50637 } }; --Skycaller Teskris
	[134625] = { zoneID = 864, artID = { 889 }, x = 0.508, y = 0.31, overlay = { "0.50-0.31" }, displayID = 82117, questID = { 50658 } }; --Warmother Captive
	[134638] = { zoneID = 864, artID = { 889 }, x = 0.3, y = 0.52599996, overlay = { "0.3-0.52" }, displayID = 80681, questID = { 50662 } }; --Warlord Zothix
	[134643] = { zoneID = 864, artID = { 889 }, x = 0.3, y = 0.462, overlay = { "0.3-0.46" }, displayID = 83810 }; --Brgl-Lrgl the Basher
	[134694] = { zoneID = 864, artID = { 889 }, x = 0.376, y = 0.88, overlay = { "0.37-0.88" }, displayID = 83816, questID = { 50666 } }; --Mor'fani the Exile
	[134745] = { zoneID = 864, artID = { 889 }, x = 0.516, y = 0.36, overlay = { "0.51-0.36" }, displayID = 83840, questID = { 50686 } }; --Skycarver Krakit
	[135852] = { zoneID = 864, artID = { 889 }, x = 0.506, y = 0.812, overlay = { "0.50-0.81" }, displayID = 76667, questID = { 51058 } }; --Ak'tar
	[136304] = { zoneID = 864, artID = { 889 }, x = 0.66800004, y = 0.246, overlay = { "0.66-0.24" }, displayID = 81433, questID = { 51063 } }; --Songstress Nahjeen
	[136323] = { zoneID = 864, artID = { 889 }, x = 0.536, y = 0.348, overlay = { "0.53-0.34" }, displayID = 80487, questID = { 51065 } }; --Fangcaller Xorreth
	[136335] = { zoneID = 864, artID = { 889 }, x = 0.618, y = 0.378, overlay = { "0.61-0.37" }, displayID = 75589, questID = { 51077 } }; --Enraged Krolusk
	[136336] = { zoneID = 864, artID = { 889 }, x = 0.32799998, y = 0.65599996, overlay = { "0.32-0.65" }, displayID = 37539, questID = { 51076 } }; --Scorpox
	[136338] = { zoneID = 864, artID = { 889 }, x = 0.248, y = 0.686, overlay = { "0.24-0.68" }, displayID = 81654, questID = { 51075 } }; --Sirokar
	[136340] = { zoneID = 864, artID = { 889 }, x = 0.49, y = 0.72, overlay = { "0.49-0.72" }, displayID = 84744, questID = { 51126 } }; --Relic Hunter Hazaak
	[136341] = { zoneID = 864, artID = { 889 }, x = 0.606, y = 0.17799999, overlay = { "0.60-0.17" }, displayID = 1104, questID = { 51074 } }; --Jungleweb Hunter
	[136346] = { zoneID = 864, artID = { 889 }, x = 0.41599998, y = 0.24, overlay = { "0.41-0.24" }, displayID = 84741, questID = { 51073 } }; --Captain Stef "Marrow" Quin
	[136393] = { zoneID = 864, artID = { 889 }, x = 0.56, y = 0.536, overlay = { "0.56-0.53" }, displayID = 3248, questID = { 51079 } }; --Bloodwing Bonepicker
	[137553] = { zoneID = 864, artID = { 889 }, x = 0.58599997, y = 0.592, overlay = { "0.58-0.59" }, displayID = 85374, reset = true }; --General Krathax
	[137681] = { zoneID = 864, artID = { 889 }, x = 0.382, y = 0.412, overlay = { "0.38-0.41" }, displayID = 85438, questID = { 51424 } }; --King Clickyclack
	[138794] = { zoneID = 864, artID = { 889 }, x = 0.44599998, y = 0.56200004, overlay = { "0.44-0.55","0.44-0.56" }, displayID = 88375, weeklyReset = true, questID = { 53000 } }; --Dunegorger Kraulok
	[143313] = { zoneID = 864, artID = { 889 }, x = 0.61, y = 0.18200001, overlay = { "0.61-0.18" }, displayID = 83605, reset = true }; --Portakillo
	[146942] = { zoneID = 864, artID = { 889 }, x = 0.396, y = 0.376, overlay = { "0.39-0.37" }, friendly = { "A" }, displayID = 85310, questReset = true, questID = { 54646 } }; --Grand Marshal Fury
	[146979] = { zoneID = 864, artID = { 889 }, x = 0.36, y = 0.496, overlay = { "0.35-0.49","0.36-0.49" }, friendly = { "A" }, displayID = 89469, questReset = true, questID = { 54170 } }; --Ormin Rocketbop
	[148446] = { zoneID = 864, artID = { 889 }, x = 0.406, y = 0.496, overlay = { "0.40-0.48","0.40-0.49" }, friendly = { "H" }, displayID = 90022, questReset = true, questID = { 54554 } }; --Wolfleader Skraug
	[148451] = { zoneID = 864, artID = { 889 }, x = 0.36400002, y = 0.38599998, overlay = { "0.36-0.38" }, friendly = { "H" }, displayID = 84094, questReset = true, questID = { 54555 } }; --Siege O' Matic 9000
	[148456] = { zoneID = 864, artID = { 889 }, x = 0.33200002, y = 0.71599996, overlay = { "0.33-0.71" }, friendly = { "H" }, displayID = 90024, questReset = true, questID = { 54574 } }; --Jin'tago
	[148477] = { zoneID = 864, artID = { 889 }, x = 0.348, y = 0.42400002, overlay = { "0.34-0.42" }, friendly = { "H" }, displayID = 90032, questReset = true, questID = { 54609 } }; --Beastlord Drakara
	[148494] = { zoneID = 864, artID = { 889 }, x = 0.408, y = 0.412, overlay = { "0.40-0.41" }, friendly = { "H" }, displayID = 90039, questReset = true, questID = { 54636 } }; --Sandbinder Sodir
	[148510] = { zoneID = 864, artID = { 889 }, x = 0.368, y = 0.638, overlay = { "0.36-0.64","0.36-0.62","0.36-0.63" }, friendly = { "H" }, displayID = 90041, questReset = true, questID = { 54638 } }; --Drox'ar Morgar
	[148534] = { zoneID = 864, artID = { 889 }, x = 0.39200002, y = 0.676, overlay = { "0.39-0.67" }, friendly = { "A" }, displayID = 90044, questReset = true, questID = { 54643 } }; --Evezon the Eternal
	[148550] = { zoneID = 864, artID = { 889 }, x = 0.398, y = 0.406, overlay = { "0.39-0.4","0.39-0.40" }, friendly = { "A" }, displayID = 90018, questReset = true, questID = { 54644 } }; --Caravan Leader
	[148558] = { zoneID = 864, artID = { 889 }, x = 0.43, y = 0.38599998, overlay = { "0.43-0.38" }, friendly = { "A" }, displayID = 67251, questReset = true, questID = { 54645 } }; --Rockfury
	[148597] = { zoneID = 864, artID = { 889 }, x = 0.382, y = 0.41599998, overlay = { "0.38-0.41" }, friendly = { "A" }, displayID = 90078, questID = { 54649 } }; --Iron Shaman Grimbeard
	[122838] = { zoneID = 882, artID = { 907 }, x = 0.44799998, y = 0.714, overlay = { "0.44-0.71" }, displayID = 77107, questID = { 48692 } }; --Shadowcaster Voruun
	[124440] = { zoneID = 882, artID = { 907 }, x = 0.59599996, y = 0.376, overlay = { "0.58-0.37","0.59-0.37" }, displayID = 78505, questID = { 48714 } }; --Overseer Y'Beda
	[125497] = { zoneID = 882, artID = { 907 }, x = 0.578, y = 0.296, overlay = { "0.56-0.29","0.56-0.28","0.56-0.30","0.56-0.32","0.57-0.26","0.57-0.27","0.57-0.29","0.57-0.31","0.57-0.30","0.57-0.28" }, displayID = 78506, questID = { 48716 } }; --Overseer Y'Sorna
	[125498] = { zoneID = 882, artID = { 907 }, x = 0.606, y = 0.29799998, overlay = { "0.60-0.29" }, displayID = 78507, questID = { 48717 } }; --Overseer Y'Morna
	[126815] = { zoneID = 882, artID = { 907 }, x = 0.53, y = 0.67800003, overlay = { "0.52-0.68","0.52-0.66","0.52-0.67","0.53-0.67" }, displayID = 79114, questID = { 48693 } }; --Soultwisted Monstrosity
	[126852] = { zoneID = 882, artID = { 907 }, x = 0.556, y = 0.606, overlay = { "0.54-0.59","0.55-0.59","0.55-0.60" }, displayID = 79133, questID = { 48695 } }; --Wrangler Kravos
	[126860] = { zoneID = 882, artID = { 907 }, x = 0.378, y = 0.548, overlay = { "0.37-0.55","0.37-0.54" }, displayID = 79136, questID = { 48697 } }; --Kaara the Pale
	[126862] = { zoneID = 882, artID = { 907 }, x = 0.442, y = 0.59400004, overlay = { "0.43-0.60","0.44-0.60","0.44-0.61","0.44-0.59" }, displayID = 79137, questID = { 48700 } }; --Baruut the Bloodthirsty
	[126864] = { zoneID = 882, artID = { 907 }, x = 0.41799998, y = 0.111999996, overlay = { "0.41-0.11" }, displayID = 79139, questID = { 48702 } }; --Feasel the Muffin Thief
	[126865] = { zoneID = 882, artID = { 907 }, x = 0.366, y = 0.236, overlay = { "0.36-0.23" }, displayID = 79927, questID = { 48703 } }; --Vigilant Thanos
	[126866] = { zoneID = 882, artID = { 907 }, x = 0.636, y = 0.64599997, overlay = { "0.63-0.64" }, displayID = 79928, questID = { 48704 } }; --Vigilant Kuro
	[126867] = { zoneID = 882, artID = { 907 }, x = 0.338, y = 0.474, overlay = { "0.33-0.48","0.33-0.47" }, displayID = 75569, questID = { 48705 } }; --Venomtail Skyfin
	[126868] = { zoneID = 882, artID = { 907 }, x = 0.38599998, y = 0.65199995, overlay = { "0.38-0.64","0.38-0.65" }, displayID = 79143, questID = { 48706 } }; --Turek the Lucid
	[126869] = { zoneID = 882, artID = { 907 }, x = 0.276, y = 0.304, overlay = { "0.27-0.30" }, displayID = 76899, questID = { 48707 } }; --Captain Faruq
	[126885] = { zoneID = 882, artID = { 907 }, x = 0.348, y = 0.376, overlay = { "0.33-0.37","0.34-0.37","0.34-0.38","0.34-0.36" }, displayID = 76479, questID = { 48708 } }; --Umbraliss
	[126887] = { zoneID = 882, artID = { 907 }, x = 0.306, y = 0.41599998, overlay = { "0.29-0.41","0.30-0.40","0.30-0.39","0.30-0.41" }, displayID = 76477, questID = { 48709 } }; --Ataxon
	[126889] = { zoneID = 882, artID = { 907 }, x = 0.70199996, y = 0.46, overlay = { "0.70-0.46" }, displayID = 79150, questID = { 48710 } }; --Sorolis the Ill-Fated
	[126896] = { zoneID = 882, artID = { 907 }, x = 0.35799998, y = 0.588, overlay = { "0.35-0.58" }, displayID = 79060, questID = { 48711 } }; --Herald of Chaos
	[126898] = { zoneID = 882, artID = { 907 }, x = 0.45200002, y = 0.49, overlay = { "0.43-0.47","0.43-0.49","0.43-0.48","0.43-0.46","0.44-0.49","0.44-0.50","0.45-0.49" }, displayID = 79156, questID = { 48712 } }; --Sabuul
	[126899] = { zoneID = 882, artID = { 907 }, x = 0.488, y = 0.41799998, overlay = { "0.48-0.40","0.48-0.41" }, displayID = 79157, questID = { 48713 } }; --Jed'hin Champion Vorusk
	[126900] = { zoneID = 882, artID = { 907 }, x = 0.622, y = 0.492, overlay = { "0.61-0.50","0.62-0.49" }, displayID = 79160, questID = { 48718 } }; --Instructor Tarahna
	[126908] = { zoneID = 882, artID = { 907 }, x = 0.666, y = 0.286, overlay = { "0.66-0.28" }, displayID = 77098, questID = { 48719 } }; --Zul'tan the Numerous
	[126910] = { zoneID = 882, artID = { 907 }, x = 0.568, y = 0.156, overlay = { "0.55-0.13","0.56-0.14","0.56-0.15" }, displayID = 78364, questID = { 48720 } }; --Commander Xethgar
	[126912] = { zoneID = 882, artID = { 907 }, x = 0.506, y = 0.098000005, overlay = { "0.48-0.11","0.49-0.11","0.49-0.09","0.49-0.1","0.49-0.10","0.5-0.09","0.50-0.09" }, displayID = 76684, questID = { 48721 } }; --Skreeg the Devourer
	[126913] = { zoneID = 882, artID = { 907 }, x = 0.48599997, y = 0.536, overlay = { "0.48-0.52","0.48-0.54","0.48-0.53" }, displayID = 63407, questID = { 48935 } }; --Slithon the Last
	[122947] = { zoneID = 885, artID = { 910 }, x = 0.576, y = 0.336, overlay = { "0.57-0.33" }, displayID = 80099, questID = { 49240 } }; --Mistress Il'thendra
	[122958] = { zoneID = 885, artID = { 910 }, x = 0.618, y = 0.376, overlay = { "0.61-0.38","0.61-0.37" }, displayID = 78588, questID = { 49183 } }; --Blistermaw
	[122999] = { zoneID = 885, artID = { 910 }, x = 0.56200004, y = 0.466, overlay = { "0.54-0.46","0.55-0.45","0.56-0.45","0.56-0.46" }, displayID = 20907, questID = { 49241 } }; --Gar'zoth
	[126040] = { zoneID = 885, artID = { 910 }, x = 0.64, y = 0.20799999, overlay = { "0.64-0.20" }, displayID = 66039, questID = { 48809 } }; --Puscilla
	[126115] = { zoneID = 885, artID = { 910 }, x = 0.636, y = 0.57, overlay = { "0.63-0.57" }, displayID = 71834, questID = { 48811 } }; --Ven'orn
	[126199] = { zoneID = 885, artID = { 910 }, x = 0.53, y = 0.366, overlay = { "0.53-0.35","0.53-0.36" }, displayID = 78785, questID = { 48810 } }; --Vrax'thul
	[126208] = { zoneID = 885, artID = { 910 }, x = 0.65, y = 0.516, overlay = { "0.64-0.49","0.64-0.50","0.65-0.51" }, displayID = 78793, questID = { 48812 } }; --Varga
	[126254] = { zoneID = 885, artID = { 910 }, x = 0.626, y = 0.544, overlay = { "0.62-0.53","0.62-0.54" }, displayID = 78814, questID = { 48813 } }; --Lieutenant Xakaar
	[126338] = { zoneID = 885, artID = { 910 }, x = 0.616, y = 0.65, overlay = { "0.61-0.65","0.61-0.64" }, displayID = 78873, questID = { 48814 } }; --Wrath-Lord Yarez
	[126946] = { zoneID = 885, artID = { 910 }, x = 0.606, y = 0.48599997, overlay = { "0.60-0.48" }, displayID = 78785, questID = { 48815 } }; --Inquisitor Vethroz
	[127084] = { zoneID = 885, artID = { 910 }, x = 0.826, y = 0.65800005, overlay = { "0.82-0.65","0.82-0.66" }, displayID = 71253, questID = { 48816 } }; --Commander Texlaz
	[127090] = { zoneID = 885, artID = { 910 }, x = 0.736, y = 0.71800005, overlay = { "0.73-0.71" }, displayID = 76275, questID = { 48817 } }; --Admiral Rel'var
	[127096] = { zoneID = 885, artID = { 910 }, x = 0.76, y = 0.56200004, overlay = { "0.75-0.56","0.76-0.56" }, displayID = 64719, questID = { 48818 } }; --All-Seer Xanarian
	[127118] = { zoneID = 885, artID = { 910 }, x = 0.548, y = 0.542, overlay = { "0.50-0.55","0.51-0.55","0.51-0.54","0.51-0.53","0.52-0.52","0.54-0.55","0.54-0.54" }, displayID = 79261, questID = { 48820 } }; --Worldsplitter Skuul
	[127288] = { zoneID = 885, artID = { 910 }, x = 0.638, y = 0.22, overlay = { "0.63-0.23","0.63-0.22" }, displayID = 71965, questID = { 48821 } }; --Houndmaster Kerrax
	[127291] = { zoneID = 885, artID = { 910 }, x = 0.532, y = 0.284, overlay = { "0.53-0.29","0.53-0.28" }, displayID = 74729, questID = { 48822 } }; --Watcher Aival
	[127300] = { zoneID = 885, artID = { 910 }, x = 0.556, y = 0.218, overlay = { "0.55-0.21" }, displayID = 78507, questID = { 48824 } }; --Void Warden Valsuran
	[127376] = { zoneID = 885, artID = { 910 }, x = 0.612, y = 0.216, overlay = { "0.61-0.21" }, displayID = 64632, questID = { 48865 } }; --Chief Alchemist Munculus
	[127581] = { zoneID = 885, artID = { 910 }, x = 0.548, y = 0.39, overlay = { "0.54-0.39" }, displayID = 78135, questID = { 48966 } }; --The Many-Faced Devourer
	[127700] = { zoneID = 885, artID = { 910 }, x = 0.84599996, y = 0.81, overlay = { "0.84-0.81" }, displayID = 78814, questID = { 48967 } }; --Squadron Commander Vishax
	[127703] = { zoneID = 885, artID = { 910 }, x = 0.58599997, y = 0.116000004, overlay = { "0.57-0.12","0.58-0.11","0.58-0.12" }, displayID = 68312, questID = { 48968 } }; --Doomcaster Suprax
	[127705] = { zoneID = 885, artID = { 910 }, x = 0.666, y = 0.17799999, overlay = { "0.66-0.17" }, displayID = 65648, questID = { 48970 } }; --Mother Rosula
	[127706] = { zoneID = 885, artID = { 910 }, x = 0.65400004, y = 0.814, overlay = { "0.65-0.82","0.65-0.81" }, displayID = 74729, questID = { 48971 } }; --Rezira the Seer
	[127289] = { zoneID = 895, artID = { 920 }, x = 0.58599997, y = 0.148, overlay = { "0.58-0.14" }, displayID = 6533, questID = { 48806 } }; --Saurolisk Tamer Mugg
	[127290] = { zoneID = 895, artID = { 920 }, x = 0.588, y = 0.148, overlay = { "0.58-0.14" }, displayID = 81866, questID = { 48806 } }; --Mugg
	[129181] = { zoneID = 895, artID = { 920 }, x = 0.766, y = 0.83199996, overlay = { "0.76-0.83" }, displayID = 80425, questID = { 50233 } }; --Barman Bill
	[130508] = { zoneID = 895, artID = { 920 }, x = 0.83599997, y = 0.44799998, overlay = { "0.83-0.44" }, displayID = 81342, questID = { 49999 } }; --Broodmother Razora
	[131252] = { zoneID = 895, artID = { 920 }, x = 0.432, y = 0.168, overlay = { "0.43-0.16" }, displayID = 82052, questID = { 49921 } }; --Merianae
	[131262] = { zoneID = 895, artID = { 920 }, x = 0.39, y = 0.152, overlay = { "0.39-0.15" }, displayID = 68526, questID = { 49923 } }; --Pack Leader Asenya
	[131389] = { zoneID = 895, artID = { 920 }, x = 0.64, y = 0.506, overlay = { "0.63-0.50","0.64-0.50" }, displayID = 81799, questID = { 49942 } }; --Teres
	[131520] = { zoneID = 895, artID = { 920 }, x = 0.482, y = 0.22600001, overlay = { "0.48-0.22" }, displayID = 47803, questID = { 49984 } }; --Kulett the Ornery
	[131984] = { zoneID = 895, artID = { 920 }, x = 0.704, y = 0.124, overlay = { "0.70-0.12" }, displayID = 82226, questID = { 50073 } }; --Twin-hearted Construct
	[132052] = { zoneID = 895, artID = { 920 }, x = 0.65400004, y = 0.126, overlay = { "0.51-0.32","0.54-0.26","0.65-0.12" }, friendly = { "H" }, displayID = 82194 }; --Vol'Jim
	[132068] = { zoneID = 895, artID = { 920 }, x = 0.346, y = 0.30200002, overlay = { "0.34-0.30" }, displayID = 55832, questID = { 50094 } }; --Bashmu
	[132076] = { zoneID = 895, artID = { 920 }, x = 0.468, y = 0.206, overlay = { "0.46-0.20" }, displayID = 82225, questID = { 50095 } }; --Totes
	[132086] = { zoneID = 895, artID = { 920 }, x = 0.566, y = 0.7, overlay = { "0.56-0.7" }, displayID = 82224, questID = { 50096 } }; --Black-Eyed Bart
	[132088] = { zoneID = 895, artID = { 920 }, x = 0.38599998, y = 0.21, overlay = { "0.38-0.20","0.38-0.21" }, displayID = 82223, questID = { 50097 } }; --Captain Wintersail
	[132127] = { zoneID = 895, artID = { 920 }, x = 0.606, y = 0.22, overlay = { "0.6-0.22","0.60-0.22" }, displayID = 82239, questID = { 50137 } }; --Foxhollow Skyterror
	[132179] = { zoneID = 895, artID = { 920 }, x = 0.648, y = 0.584, overlay = { "0.64-0.58","0.64-0.59" }, displayID = 83949, questID = { 50148 } }; --Raging Swell
	[132182] = { zoneID = 895, artID = { 920 }, x = 0.752, y = 0.78400004, overlay = { "0.75-0.78" }, friendly = { "A" }, displayID = 82274, questID = { 50156 } }; --Auditor Dolp
	[132211] = { zoneID = 895, artID = { 920 }, x = 0.90199995, y = 0.77800006, overlay = { "0.90-0.77" }, displayID = 82292, questID = { 50155 } }; --Fowlmouth
	[132280] = { zoneID = 895, artID = { 920 }, x = 0.808, y = 0.826, overlay = { "0.80-0.82" }, displayID = 82370, questID = { 50160 } }; --Squacks
	[133356] = { zoneID = 895, artID = { 920 }, x = 0.606, y = 0.174, overlay = { "0.60-0.17" }, displayID = 82869, questID = { 50301 } }; --Tempestria
	[134106] = { zoneID = 895, artID = { 920 }, x = 0.686, y = 0.202, overlay = { "0.67-0.19","0.68-0.20","0.68-0.2" }, displayID = 79804, questID = { 50525 } }; --Lumbergrasp Sentinel
	[136385] = { zoneID = 895, artID = { 920 }, x = 0.62, y = 0.24, overlay = { "0.61-0.24","0.62-0.24" }, displayID = 58717, weeklyReset = true, questID = { 52997 } }; --Azurethos
	[137183] = { zoneID = 895, artID = { 920 }, x = 0.64199996, y = 0.19399999, overlay = { "0.64-0.19" }, displayID = 78242, questID = { 51321 } }; --Honey-Coated Slitherer
	[138279] = { zoneID = 895, artID = { 920 }, x = 0.85400003, y = 0.43400002, overlay = { "0.85-0.43" }, displayID = 85796, questID = { 54953 } }; --Adhara White
	[138288] = { zoneID = 895, artID = { 920 }, x = 0.698, y = 0.46400002, overlay = { "0.69-0.47","0.69-0.46" }, displayID = 75598, reset = true }; --Ghost of the Deep
	[138299] = { zoneID = 895, artID = { 920 }, x = 0.59, y = 0.336, overlay = { "0.58-0.33","0.59-0.33" }, displayID = 55454 }; --Bloodmaw
	[139135] = { zoneID = 895, artID = { 920 }, x = 0.488, y = 0.37, overlay = { "0.48-0.37" }, displayID = 75808, questID = { 51807 } }; --Squirgle of the Depths
	[139145] = { zoneID = 895, artID = { 920 }, x = 0.852, y = 0.734, overlay = { "0.85-0.73" }, displayID = 66132, questID = { 51808 } }; --Blackthorne
	[139152] = { zoneID = 895, artID = { 920 }, x = 0.726, y = 0.812, overlay = { "0.72-0.81" }, friendly = { "A" }, displayID = 86170, questID = { 51809 } }; --Carla Smirk
	[139205] = { zoneID = 895, artID = { 920 }, x = 0.65199995, y = 0.64599997, overlay = { "0.65-0.64" }, displayID = 74804, questID = { 51833 } }; --P4-N73R4
	[139233] = { zoneID = 895, artID = { 920 }, x = 0.578, y = 0.566, overlay = { "0.57-0.56" }, displayID = 78151, questID = { 53373 } }; --Gulliver
	[139235] = { zoneID = 895, artID = { 920 }, x = 0.706, y = 0.55799997, overlay = { "0.70-0.55" }, displayID = 42658, questID = { 51835 } }; --Tort Jaw
	[139278] = { zoneID = 895, artID = { 920 }, x = 0.682, y = 0.636, overlay = { "0.68-0.63" }, displayID = 913, questID = { 51872 } }; --Ranja
	[139280] = { zoneID = 895, artID = { 920 }, x = 0.66800004, y = 0.138, overlay = { "0.66-0.14","0.66-0.13" }, displayID = 45092, questID = { 51873 } }; --Sythian the Swift
	[139285] = { zoneID = 895, artID = { 920 }, x = 0.55, y = 0.32599998, overlay = { "0.55-0.32" }, displayID = 78240, questID = { 51876 } }; --Shiverscale the Toxic
	[139289] = { zoneID = 895, artID = { 920 }, x = 0.556, y = 0.518, overlay = { "0.55-0.51" }, displayID = 63970, questID = { 51879 } }; --Tentulos the Drifter
	[139290] = { zoneID = 895, artID = { 920 }, x = 0.58599997, y = 0.49, overlay = { "0.58-0.50","0.58-0.49" }, displayID = 75380, questID = { 51880 } }; --Maison the Portable
	[144722] = { zoneID = 895, artID = { 920 }, x = 0.792, y = 0.378, overlay = { "0.79-0.37" }, friendly = { "H" }, displayID = 88804, questReset = true, questID = { 54237 } }; --Togoth Cruelarm
	[145112] = { zoneID = 895, artID = { 920 }, x = 0.766, y = 0.43, overlay = { "0.76-0.42","0.76-0.43" }, friendly = { "H" }, displayID = 88964, questReset = true, questID = { 53772 } }; --Zagg Brokeneye
	[145286] = { zoneID = 895, artID = { 920 }, x = 0.77, y = 0.41599998, overlay = { "0.77-0.41" }, friendly = { "H" }, displayID = 89030, questReset = true, questID = { 53812 } }; --Motega Bloodshield
	[145287] = { zoneID = 895, artID = { 920 }, x = 0.77199996, y = 0.412, overlay = { "0.77-0.41" }, friendly = { "H" }, displayID = 89031, questReset = true, questID = { 53812 } }; --Zunjo of Sen'jin
	[145292] = { zoneID = 895, artID = { 920 }, x = 0.77199996, y = 0.412, overlay = { "0.77-0.41" }, friendly = { "H" }, displayID = 89032, questReset = true, questID = { 53812 } }; --Alsian Vistreth
	[145308] = { zoneID = 895, artID = { 920 }, x = 0.86, y = 0.426, overlay = { "0.85-0.43","0.85-0.42","0.86-0.42" }, friendly = { "H" }, displayID = 89043, questReset = true, questID = { 53814 } }; --First Sergeant Steelfang
	[145392] = { zoneID = 895, artID = { 920 }, x = 0.8, y = 0.41599998, overlay = { "0.79-0.42","0.8-0.41" }, friendly = { "A" }, displayID = 89064, questReset = true, questID = { 54251 } }; --Ambassador Gaines
	[145395] = { zoneID = 895, artID = { 920 }, x = 0.8, y = 0.41599998, overlay = { "0.79-0.42","0.8-0.41" }, friendly = { "A" }, displayID = 89065, questReset = true, questID = { 54251 } }; --Katrianna
	[146611] = { zoneID = 895, artID = { 920 }, x = 0.78, y = 0.492, overlay = { "0.78-0.49" }, friendly = { "A" }, displayID = 89365, questReset = true, questID = { 54091 } }; --Strong Arm John
	[146651] = { zoneID = 895, artID = { 920 }, x = 0.746, y = 0.44599998, overlay = { "0.74-0.44" }, friendly = { "A" }, displayID = 43848, questReset = true, questID = { 54112 } }; --Mistweaver Nian
	[146675] = { zoneID = 895, artID = { 920 }, x = 0.802, y = 0.37, overlay = { "0.80-0.37" }, friendly = { "A" }, displayID = 89389, questReset = true, questID = { 54119 } }; --Hartford Sternbach
	[146773] = { zoneID = 895, artID = { 920 }, x = 0.84599996, y = 0.47599998, overlay = { "0.84-0.47" }, friendly = { "H" }, displayID = 89426, questReset = true, questID = { 54129 } }; --First Mate Malone
	[147061] = { zoneID = 895, artID = { 920 }, x = 0.84199995, y = 0.352, overlay = { "0.84-0.35" }, friendly = { "H" }, displayID = 30262, questReset = true, questID = { 54182 } }; --Grubb
	[147489] = { zoneID = {
				[895] = { x = 0.76, y = 0.396, overlay = { "0.76-0.39" } };
				[1161] = { x = 0.77199996, y = 0.806, overlay = { "0.77-0.80" } };
			  }, friendly = { "A" }, displayID = 89713, questReset = true, questID = { 54257 } }; --Captain Greensails
	[147750] = { zoneID = 895, artID = { 920 }, x = 0.83199996, y = 0.406, overlay = { "0.83-0.40" }, friendly = { "A" }, displayID = 89780, questReset = true, questID = { 54295 } }; --Artillery Master Goodwin
	[124548] = { zoneID = 896, artID = { 921 }, x = 0.58599997, y = 0.336, overlay = { "0.58-0.33" }, displayID = 81256, questID = { 47884 } }; --Betsy
	[125453] = { zoneID = 896, artID = { 921 }, x = 0.666, y = 0.426, overlay = { "0.66-0.42" }, displayID = 43647, questID = { 48178 } }; --Quillrat Matriarch
	[126621] = { zoneID = 896, artID = { 921 }, x = 0.666, y = 0.51, overlay = { "0.66-0.50","0.66-0.51" }, displayID = 80957, questID = { 48978 } }; --Bonesquall
	[127129] = { zoneID = 896, artID = { 921 }, x = 0.506, y = 0.206, overlay = { "0.50-0.20" }, displayID = 77268, questID = { 49388 } }; --Grozgore
	[127333] = { zoneID = 896, artID = { 921 }, x = 0.59, y = 0.176, overlay = { "0.59-0.17" }, displayID = 85629, questID = { 48842 } }; --Barbthorn Queen
	[127651] = { zoneID = 896, artID = { 921 }, x = 0.72800004, y = 0.606, overlay = { "0.72-0.60" }, displayID = 21936, questID = { 48928 } }; --Vicemaul
	[127844] = { zoneID = 896, artID = { 921 }, x = 0.63, y = 0.696, overlay = { "0.63-0.69" }, displayID = 13990, questID = { 48979 } }; --Gluttonous Yeti
	[127877] = { zoneID = 896, artID = { 921 }, x = 0.59400004, y = 0.552, overlay = { "0.59-0.55" }, displayID = 79676, questID = { 48981 } }; --Longfang
	[127901] = { zoneID = 896, artID = { 921 }, x = 0.59400004, y = 0.552, overlay = { "0.59-0.55" }, displayID = 79282, questID = { 48981 } }; --Henry Breakwater
	[128707] = { zoneID = 896, artID = { 921 }, x = 0.59599996, y = 0.71599996, overlay = { "0.59-0.71" }, displayID = 74168, questID = { 49269 } }; --Rimestone
	[128973] = { zoneID = 896, artID = { 921 }, x = 0.648, y = 0.216, overlay = { "0.64-0.21" }, displayID = 24932, questID = { 49311 } }; --Whargarble the Ill-Tempered
	[129805] = { zoneID = 896, artID = { 921 }, x = 0.506, y = 0.3, overlay = { "0.50-0.3" }, displayID = 37738, questID = { 49481 } }; --Beshol
	[129835] = { zoneID = 896, artID = { 921 }, x = 0.572, y = 0.44599998, overlay = { "0.57-0.44" }, displayID = 80884, questID = { 49480 } }; --Gorehorn
	[129904] = { zoneID = 896, artID = { 921 }, x = 0.52, y = 0.468, overlay = { "0.52-0.46" }, displayID = 80909, questID = { 49216 } }; --Cottontail Matron
	[129950] = { zoneID = 896, artID = { 921 }, x = 0.322, y = 0.4, overlay = { "0.31-0.41","0.32-0.4" }, displayID = 81102, questID = { 49528 } }; --Talon
	[129995] = { zoneID = 896, artID = { 921 }, x = 0.634, y = 0.402, overlay = { "0.63-0.40" }, displayID = 80936, questID = { 49530 } }; --Emily Mayville
	[130138] = { zoneID = 896, artID = { 921 }, x = 0.6, y = 0.45599997, overlay = { "0.6-0.45" }, displayID = 80965, questID = { 49601 } }; --Nevermore
	[130143] = { zoneID = 896, artID = { 921 }, x = 0.59400004, y = 0.282, overlay = { "0.55-0.29","0.56-0.29","0.57-0.29","0.58-0.29","0.59-0.28" }, displayID = 81005, questID = { 49602 } }; --Balethorn
	[131735] = { zoneID = 896, artID = { 921 }, x = 0.65, y = 0.83199996, overlay = { "0.65-0.83" }, displayID = 82027, questID = { 52061 } }; --Idej the Wise
	[132319] = { zoneID = 896, artID = { 921 }, x = 0.35599998, y = 0.32599998, overlay = { "0.35-0.33","0.35-0.32" }, displayID = 34168, questID = { 50163 } }; --Bilefang Mother
	[134213] = { zoneID = 896, artID = { 921 }, x = 0.308, y = 0.186, overlay = { "0.30-0.18" }, displayID = 83387, questID = { 50546 } }; --Executioner Blackwell
	[134706] = { zoneID = 896, artID = { 921 }, x = 0.186, y = 0.61, overlay = { "0.18-0.60","0.18-0.61" }, displayID = 83607, questID = { 50669 } }; --Deathcap
	[134754] = { zoneID = 896, artID = { 921 }, x = 0.23, y = 0.492, overlay = { "0.23-0.49" }, displayID = 87598, questID = { 50688 } }; --Hyo'gi
	[135796] = { zoneID = 896, artID = { 921 }, x = 0.28, y = 0.142, overlay = { "0.26-0.14","0.27-0.14","0.28-0.14" }, displayID = 84410, questID = { 50939 } }; --Captain Leadfist
	[137529] = { zoneID = 896, artID = { 921 }, x = 0.35, y = 0.69, overlay = { "0.35-0.69" }, displayID = 85351, questID = { 51383 } }; --Arvon the Betrayed
	[137665] = { zoneID = 896, artID = { 921 }, x = 0.272, y = 0.548, overlay = { "0.26-0.54","0.27-0.54" }, displayID = 79366, questID = { 52002 } }; --Soul Goliath
	[137704] = { zoneID = 896, artID = { 921 }, x = 0.348, y = 0.206, overlay = { "0.34-0.2","0.34-0.20" }, displayID = 84208, questID = { 52000 } }; --Matron Morana
	[137708] = { zoneID = 896, artID = { 921 }, x = 0.5, y = 0.432, overlay = { "0.49-0.43","0.5-0.43" }, displayID = 86197, questID = { 51999 } }; --Stone Golem
	[137824] = { zoneID = 896, artID = { 921 }, x = 0.292, y = 0.688, overlay = { "0.29-0.68" }, displayID = 85538, questID = { 51470 } }; --Arclight
	[137825] = { zoneID = 896, artID = { 921 }, x = 0.44599998, y = 0.86800003, overlay = { "0.43-0.88","0.44-0.85","0.44-0.87","0.44-0.86" }, displayID = 85539, questID = { 51471 } }; --Avalanche
	[138618] = { zoneID = 896, artID = { 921 }, x = 0.23799999, y = 0.294, overlay = { "0.23-0.30","0.23-0.29" }, displayID = 84422, questID = { 51698 } }; --Haywire Golem
	[138667] = { zoneID = 896, artID = { 921 }, x = 0.35799998, y = 0.116000004, overlay = { "0.35-0.11" }, displayID = 86207, questID = { 52001 } }; --Blighted Monstrosity
	[138675] = { zoneID = 896, artID = { 921 }, x = 0.286, y = 0.256, overlay = { "0.27-0.25","0.28-0.26","0.28-0.25" }, displayID = 55858, questID = { 51700 } }; --Gorged Boar
	[138863] = { zoneID = 896, artID = { 921 }, x = 0.33, y = 0.57, overlay = { "0.33-0.57" }, displayID = 85383, questID = { 51748 } }; --Sister Martha
	[138866] = { zoneID = 896, artID = { 921 }, x = 0.244, y = 0.22, overlay = { "0.24-0.22" }, displayID = 83611, questID = { 51749 } }; --Mack
	[138870] = { zoneID = 896, artID = { 921 }, x = 0.244, y = 0.22, overlay = { "0.24-0.22" }, displayID = 83618, questID = { 51749 } }; --Mick
	[138871] = { zoneID = 896, artID = { 921 }, x = 0.244, y = 0.22, overlay = { "0.24-0.22" }, displayID = 83594, questID = { 51749 } }; --Ernie
	[139321] = { zoneID = 896, artID = { 921 }, x = 0.276, y = 0.59599996, overlay = { "0.27-0.59" }, displayID = 85390, questID = { 51922 } }; --Braedan Whitewall
	[139322] = { zoneID = 896, artID = { 921 }, x = 0.296, y = 0.64, overlay = { "0.29-0.64" }, displayID = 86221, questID = { 51923 } }; --Whitney "Steelclaw" Ramsay
	[139358] = { zoneID = 896, artID = { 921 }, x = 0.252, y = 0.16, overlay = { "0.25-0.16" }, displayID = 85614, questID = { 51949 } }; --The Caterer
	[140252] = { zoneID = 896, artID = { 921 }, x = 0.492, y = 0.746, overlay = { "0.49-0.74" }, displayID = 80964, weeklyReset = true }; --Hailstone Construct
	[144855] = { zoneID = 896, artID = { 921 }, x = 0.352, y = 0.41599998, overlay = { "0.35-0.41" }, friendly = { "H" }, displayID = 88880, questReset = true, questID = { 53714 } }; --Apothecary Jerrod
	[145465] = { zoneID = 896, artID = { 921 }, x = 0.286, y = 0.432, overlay = { "0.27-0.43","0.28-0.43" }, friendly = { "H" }, displayID = 89084, questReset = true, questID = { 53867 } }; --Engineer Bolthold
	[145466] = { zoneID = 896, artID = { 921 }, x = 0.286, y = 0.43400002, overlay = { "0.27-0.43","0.28-0.43" }, friendly = { "H" }, displayID = 58115 }; --Shredatron-2000
	[146607] = { zoneID = 896, artID = { 921 }, x = 0.318, y = 0.33, overlay = { "0.31-0.33" }, friendly = { "H" }, displayID = 89363, questReset = true, questID = { 54089 } }; --Omgar Doombow
	[148146] = { zoneID = 896, artID = { 921 }, x = 0.31, y = 0.36, overlay = { "0.30-0.35","0.30-0.37","0.31-0.36" }, friendly = { "H" }, displayID = 89895, questReset = true, questID = { 54488 } }; --Zul'aki the Headhunter
	[148155] = { zoneID = 896, artID = { 921 }, x = 0.336, y = 0.378, overlay = { "0.33-0.37" }, friendly = { "H" }, displayID = 79522, questReset = true, questID = { 54650 } }; --Muk'luk
	[148563] = { zoneID = 896, artID = { 921 }, x = 0.402, y = 0.506, overlay = { "0.40-0.50" }, friendly = { "H" }, displayID = 90076, questReset = true, questID = { 54665 } }; --Duchess Fallensong the Frigid
	[148648] = { zoneID = 896, artID = { 921 }, x = 0.44, y = 0.38, overlay = { "0.43-0.39","0.43-0.38","0.44-0.38" }, friendly = { "H" }, displayID = 90097, questReset = true, questID = { 54666 } }; --Packmaster Swiftarrow
	[148676] = { zoneID = 896, artID = { 921 }, x = 0.322, y = 0.466, overlay = { "0.32-0.46" }, friendly = { "A" }, displayID = 90102, questReset = true, questID = { 54681 } }; --Caravan Commander Veronica
	[148695] = { zoneID = 896, artID = { 921 }, x = 0.316, y = 0.41599998, overlay = { "0.31-0.41" }, friendly = { "A" }, displayID = 90108, questReset = true, questID = { 54686 } }; --Doctor Lazane
	[148717] = { zoneID = 896, artID = { 921 }, x = 0.278, y = 0.336, overlay = { "0.27-0.33" }, friendly = { "A" }, displayID = 90110, questReset = true, questID = { 54688 } }; --Inquisitor Erik
	[148723] = { zoneID = 896, artID = { 921 }, x = 0.348, y = 0.33, overlay = { "0.34-0.33" }, friendly = { "A" }, displayID = 90111, questReset = true, questID = { 54690 } }; --Maddok the Sniper
	[148739] = { zoneID = 896, artID = { 921 }, x = 0.396, y = 0.32599998, overlay = { "0.39-0.32" }, friendly = { "A" }, displayID = 90114, questReset = true, questID = { 54692 } }; --Magister Crystalynn
	[148860] = { zoneID = 896, artID = { 921 }, x = 0.4, y = 0.41599998, overlay = { "0.39-0.41","0.39-0.4","0.39-0.40","0.39-0.39","0.4-0.41" }, friendly = { "A" }, displayID = 73603, questReset = true, questID = { 54711 } }; --Grizzwald
	[148862] = { zoneID = 896, artID = { 921 }, x = 0.398, y = 0.41599998, overlay = { "0.38-0.42","0.39-0.40","0.39-0.39","0.39-0.4","0.39-0.41" }, friendly = { "A" }, displayID = 90144, questReset = true, questID = { 54711 } }; --Zillie Wunderwrench
	[122519] = { zoneID = 897, artID = { 922 }, x = 0.528, y = 0.48, overlay = { "0.51-0.44","0.52-0.44","0.52-0.50","0.52-0.45","0.52-0.47","0.52-0.49","0.52-0.46","0.52-0.48" }, displayID = 24855 }; --Dregmar Runebrand
	[122520] = { zoneID = 897, artID = { 922 }, x = 0.436, y = 0.346, overlay = { "0.43-0.29","0.43-0.3","0.43-0.30","0.43-0.31","0.43-0.32","0.43-0.33","0.43-0.34" }, displayID = 24850 }; --Icefist
	[122521] = { zoneID = 897, artID = { 922 }, x = 0.574, y = 0.566, overlay = { "0.57-0.54","0.57-0.55","0.57-0.52","0.57-0.51","0.57-0.56" }, displayID = 24854 }; --Bonesunder
	[122522] = { zoneID = 897, artID = { 922 }, x = 0.624, y = 0.674, overlay = { "0.60-0.70","0.61-0.7","0.61-0.69","0.62-0.68","0.62-0.67" }, displayID = 24850 }; --Iceshatter
	[122524] = { zoneID = 897, artID = { 922 }, x = 0.58599997, y = 0.648, overlay = { "0.55-0.61","0.56-0.61","0.57-0.61","0.58-0.62","0.58-0.64","0.58-0.61","0.58-0.63" }, displayID = 24854 }; --Bloodfeast
	[122456] = { zoneID = 903, artID = { 928 }, x = 0.2918, y = 0.3133, displayID = 35903 }; --Voidmaw
	[122457] = { zoneID = 903, artID = { 928 }, x = 0.3781, y = 0.7343, displayID = 76915 }; --Darkcaller
	[127882] = { zoneID = 903, artID = { 928 }, x = 0.3788, y = 0.4289, displayID = 79724 }; --Vixx the Collector
	[127906] = { zoneID = 903, artID = { 928 }, x = 0.5527, y = 0.1453, displayID = 77198 }; --Twilight-Harbinger Tharuul
	[127911] = { zoneID = 903, artID = { 928 }, x = 0.4209, y = 0.3548, displayID = 77624 }; --Void-Blade Zedaat
	[129803] = { zoneID = 942, artID = { 967 }, x = 0.472, y = 0.65800005, overlay = { "0.47-0.65" }, displayID = 81164, questID = { 52296 } }; --Whiplash
	[129836] = { zoneID = 942, artID = { 967 }, x = 0.552, y = 0.616, overlay = { "0.55-0.61" }, displayID = 85413, reset = true }; --Spelltwister Moephus
	[130897] = { zoneID = 942, artID = { 967 }, x = 0.472, y = 0.65599996, overlay = { "0.47-0.65" }, displayID = 81688, questID = { 50170 } }; --Captain Razorspine
	[131404] = { zoneID = 942, artID = { 967 }, x = 0.64599997, y = 0.65800005, overlay = { "0.64-0.65" }, displayID = 81809, questID = { 49951 } }; --Foreman Scripps
	[132007] = { zoneID = 942, artID = { 967 }, x = 0.714, y = 0.546, overlay = { "0.71-0.54" }, displayID = 33826, questID = { 50075 } }; --Galestorm
	[132047] = { zoneID = 942, artID = { 967 }, x = 0.696, y = 0.51, overlay = { "0.69-0.51","0.69-0.52" }, displayID = 84924 }; --Reinforced Hullbreaker
	[134147] = { zoneID = 942, artID = { 967 }, x = 0.666, y = 0.748, overlay = { "0.66-0.74" }, displayID = 83359 }; --Beehemoth
	[134884] = { zoneID = 942, artID = { 967 }, x = 0.41599998, y = 0.746, overlay = { "0.41-0.73","0.41-0.74" }, displayID = 8550, questID = { 50725 } }; --Ragna
	[134897] = { zoneID = 942, artID = { 967 }, x = 0.68, y = 0.39400002, overlay = { "0.67-0.40","0.67-0.4","0.68-0.39" }, displayID = 36700, questID = { 50731 } }; --Dagrus the Scorned
	[135939] = { zoneID = 942, artID = { 967 }, x = 0.498, y = 0.682, overlay = { "0.49-0.68" }, displayID = 88563, questID = { 50037 } }; --Vinespeaker Ratha
	[136183] = { zoneID = 942, artID = { 967 }, x = 0.516, y = 0.554, overlay = { "0.51-0.55" }, displayID = 83864, questID = { 52466 } }; --Crushtacean
	[136189] = { zoneID = 942, artID = { 967 }, x = 0.518, y = 0.796, overlay = { "0.51-0.79" }, displayID = 83603, questID = { 50974 } }; --The Lichen King
	[137025] = { zoneID = 942, artID = { 967 }, x = 0.292, y = 0.696, overlay = { "0.29-0.69" }, displayID = 85021, questID = { 51298 } }; --Broodmother
	[137649] = { zoneID = 942, artID = { 967 }, x = 0.384, y = 0.372, overlay = { "0.36-0.37","0.38-0.37" }, displayID = 85878, questID = { 53612 } }; --Pest Remover Mk. II
	[138938] = { zoneID = 942, artID = { 967 }, x = 0.34, y = 0.38599998, overlay = { "0.33-0.37","0.34-0.38" }, displayID = 66812, questID = { 51757 } }; --Seabreaker Skoloth
	[138963] = { zoneID = 942, artID = { 967 }, x = 0.43400002, y = 0.45, overlay = { "0.43-0.45" }, friendly = { "A" }, displayID = 507, questID = { 51762 } }; --Nestmother Acada
	[139298] = { zoneID = 942, artID = { 967 }, x = 0.38599998, y = 0.51, overlay = { "0.38-0.51" }, displayID = 86218, questID = { 51959 } }; --Pinku'shon
	[139319] = { zoneID = 942, artID = { 967 }, x = 0.41799998, y = 0.284, overlay = { "0.41-0.28" }, displayID = 86220, questID = { 51958 } }; --Slickspill
	[139328] = { zoneID = 942, artID = { 967 }, x = 0.346, y = 0.324, overlay = { "0.34-0.32" }, displayID = 86224, questID = { 51956 } }; --Sabertron
	[139335] = { zoneID = 942, artID = { 967 }, x = 0.346, y = 0.324, overlay = { "0.34-0.32" }, displayID = 86225 }; --Sabertron
	[139336] = { zoneID = 942, artID = { 967 }, x = 0.342, y = 0.32, overlay = { "0.34-0.32" }, displayID = 86226 }; --Sabertron
	[139356] = { zoneID = 942, artID = { 967 }, x = 0.342, y = 0.32, overlay = { "0.34-0.32" }, displayID = 86227 }; --Sabertron
	[139359] = { zoneID = 942, artID = { 967 }, x = 0.34, y = 0.32, overlay = { "0.34-0.32" }, displayID = 86228 }; --Sabertron
	[139385] = { zoneID = 942, artID = { 967 }, x = 0.53, y = 0.504, overlay = { "0.52-0.51","0.53-0.50" }, displayID = 71540, questID = { 50692 } }; --Deepfang
	[139968] = { zoneID = 942, artID = { 967 }, x = 0.686, y = 0.48, overlay = { "0.66-0.51","0.66-0.50","0.67-0.49","0.68-0.48" }, displayID = 85042, questID = { 52121 } }; --Corrupted Tideskipper
	[139980] = { zoneID = 942, artID = { 967 }, x = 0.6, y = 0.466, overlay = { "0.6-0.46" }, displayID = 83643, questID = { 52123 } }; --Taja the Tidehowler
	[139988] = { zoneID = 942, artID = { 967 }, x = 0.736, y = 0.606, overlay = { "0.73-0.60" }, displayID = 78242, questID = { 52125 } }; --Sandfang
	[140163] = { zoneID = 942, artID = { 967 }, x = 0.83199996, y = 0.496, overlay = { "0.83-0.49" }, displayID = 84332, weeklyReset = true }; --Warbringer Yenajz
	[140398] = { zoneID = 942, artID = { 967 }, x = 0.316, y = 0.556, overlay = { "0.31-0.54","0.31-0.55" }, displayID = 74020, questID = { 53624 } }; --Zeritarj
	[140474] = { zoneID = {
				[942] = { x = 0.4585, y = 0.3617, artID = { 967 }, overlay = { "0.45-0.36" } };
				[1182] = { x = 0.5929, y = 0.5485, artID = { 1155 }, overlay = { "0.59-0.54" } };
			  }, displayID = 86696, questID = { 53428,53429 } }; --Adherent of the Abyss
	[140925] = { zoneID = 942, artID = { 967 }, x = 0.536, y = 0.64199996, overlay = { "0.53-0.64" }, friendly = { "A" }, displayID = 87015, questID = { 52323 } }; --Doc Marrtens
	[140938] = { zoneID = 942, artID = { 967 }, x = 0.628, y = 0.336, overlay = { "0.62-0.33","0.62-0.32" }, displayID = 55080, questID = { 52303 } }; --Croaker
	[140997] = { zoneID = 942, artID = { 967 }, x = 0.22600001, y = 0.732, overlay = { "0.22-0.73" }, displayID = 87012, questID = { 50938 } }; --Severus the Outcast
	[141029] = { zoneID = 942, artID = { 967 }, x = 0.316, y = 0.616, overlay = { "0.31-0.61","0.31-0.62" }, displayID = 82209, questID = { 52318 } }; --Kickers
	[141039] = { zoneID = 942, artID = { 967 }, x = 0.636, y = 0.83599997, overlay = { "0.63-0.83" }, displayID = 34274, questID = { 52327 } }; --Ice Sickle
	[141043] = { zoneID = 942, artID = { 967 }, x = 0.536, y = 0.64199996, overlay = { "0.53-0.64" }, friendly = { "H" }, displayID = 87022, questID = { 52324 } }; --Jakala the Cruel
	[141059] = { zoneID = 942, artID = { 967 }, x = 0.626, y = 0.73800004, overlay = { "0.62-0.73" }, displayID = 40806, questID = { 52329 } }; --Grimscowl the Harebrained
	[141088] = { zoneID = 942, artID = { 967 }, x = 0.572, y = 0.754, overlay = { "0.57-0.75" }, displayID = 58870, questID = { 52433 } }; --Squall
	[141143] = { zoneID = 942, artID = { 967 }, x = 0.616, y = 0.57, overlay = { "0.61-0.57" }, displayID = 87079, questID = { 52441 } }; --Sister Absinthe
	[141175] = { zoneID = 942, artID = { 967 }, x = 0.708, y = 0.32599998, overlay = { "0.70-0.32" }, displayID = 75702, questID = { 52448 } }; --Song Mistress Dadalea
	[141226] = { zoneID = 942, artID = { 967 }, x = 0.35599998, y = 0.774, overlay = { "0.35-0.77" }, displayID = 68226, questID = { 52460 } }; --Haegol the Hammer
	[141239] = { zoneID = 942, artID = { 967 }, x = 0.42, y = 0.636, overlay = { "0.41-0.62","0.42-0.63" }, displayID = 87178, questID = { 52461 } }; --Osca the Bloodied
	[141286] = { zoneID = 942, artID = { 967 }, x = 0.346, y = 0.67800003, overlay = { "0.34-0.67" }, displayID = 87187, questID = { 52469 } }; --Poacher Zane
	[142088] = { zoneID = 942, artID = { 967 }, x = 0.47, y = 0.414, overlay = { "0.46-0.42","0.47-0.41" }, displayID = 85524, questID = { 52457 } }; --Whirlwing
	[144915] = { zoneID = 942, artID = { 967 }, x = 0.496, y = 0.49, overlay = { "0.49-0.49" }, friendly = { "H" }, displayID = 88897, questReset = true, questID = { 53715 } }; --Firewarden Viton Darkflare
	[144987] = { zoneID = 942, artID = { 967 }, x = 0.366, y = 0.518, overlay = { "0.36-0.51" }, friendly = { "H" }, displayID = 88923, questReset = true, questID = { 53724 } }; --Shadow Hunter Mutumba
	[144997] = { zoneID = 942, artID = { 967 }, x = 0.468, y = 0.46, overlay = { "0.46-0.46" }, friendly = { "H" }, displayID = 88925, questReset = true, questID = { 53771 } }; --Gurin Stonebinder
	[145020] = { zoneID = 942, artID = { 967 }, x = 0.468, y = 0.46, overlay = { "0.46-0.46" }, friendly = { "H" }, displayID = 2075, questReset = true, questID = { 53771 } }; --Dolizite
	[145278] = { zoneID = 942, artID = { 967 }, x = 0.346, y = 0.578, overlay = { "0.34-0.58","0.34-0.57" }, friendly = { "H" }, displayID = 89026, questReset = true, questID = { 53804 } }; --Dinomancer Zakuru
	[145415] = { zoneID = 942, artID = { 967 }, x = 0.376, y = 0.47599998, overlay = { "0.37-0.47" }, friendly = { "H" }, displayID = 89071, questReset = true, questID = { 53857 } }; --Cap'n Gorok
	[147562] = { zoneID = 942, artID = { 967 }, x = 0.43, y = 0.46400002, overlay = { "0.42-0.46","0.43-0.46" }, friendly = { "H" }, displayID = 89734, questReset = true, questID = { 54266 } }; --Mortar Master Zapfritz
	[147923] = { zoneID = 942, artID = { 967 }, x = 0.32599998, y = 0.588, overlay = { "0.31-0.58","0.32-0.58" }, friendly = { "A" }, displayID = 89806, questReset = true, questID = { 54328 } }; --Knight-Captain Joesiph
	[147941] = { zoneID = 942, artID = { 967 }, x = 0.41599998, y = 0.52, overlay = { "0.41-0.52" }, friendly = { "A" }, displayID = 89823, questReset = true, questID = { 54403 } }; --Tidesage Clarissa
	[147951] = { zoneID = 942, artID = { 967 }, x = 0.41599998, y = 0.52599996, overlay = { "0.41-0.52" }, friendly = { "A" }, displayID = 88525, questReset = true, questID = { 54403 } }; --Alkalinius
	[147998] = { zoneID = 942, artID = { 967 }, x = 0.412, y = 0.54, overlay = { "0.41-0.54" }, friendly = { "A" }, displayID = 89838, questReset = true, questID = { 54434 } }; --Voidmaster Evenshade
	[148044] = { zoneID = 942, artID = { 967 }, x = 0.51, y = 0.52599996, overlay = { "0.51-0.52" }, friendly = { "A" }, displayID = 89851, questReset = true, questID = { 54437 } }; --Owynn Graddock
	[148075] = { zoneID = 942, artID = { 967 }, x = 0.35, y = 0.606, overlay = { "0.35-0.60" }, friendly = { "A" }, displayID = 89856, questReset = true, questID = { 54442 } }; --Beast Tamer Watkins
	[148092] = { zoneID = 942, artID = { 967 }, x = 0.45200002, y = 0.496, overlay = { "0.44-0.49","0.44-0.48","0.45-0.49" }, friendly = { "A" }, displayID = 89857, questReset = true, questID = { 54468 } }; --Nalaess Featherseeker
	[154154] = { zoneID = 942, artID = { 967 }, x = 0.626, y = 0.16600001, overlay = { "0.59-0.17","0.59-0.18","0.60-0.18","0.61-0.16","0.61-0.15","0.61-0.17","0.62-0.15","0.62-0.16" }, displayID = 68060, questID = { 57674 } }; --Honey Smasher
	[155055] = { zoneID = 942, artID = { 967 }, x = 0.61, y = 0.31, overlay = { "0.25-0.73","0.33-0.32","0.40-0.62","0.47-0.32","0.57-0.51","0.61-0.31","0.63-0.21","0.66-0.69","0.72-0.52" }, displayID = 68061, weeklyReset = true }; --Gurg the Hivethief
	[155059] = { zoneID = 942, artID = { 967 }, x = 0.72199994, y = 0.522, overlay = { "0.25-0.73","0.33-0.32","0.40-0.62","0.47-0.32","0.57-0.51","0.61-0.31","0.63-0.21","0.66-0.69","0.72-0.52" }, displayID = 79522, weeklyReset = true }; --Yorag the Jelly Feaster
	[155171] = { zoneID = 942, artID = { 967 }, x = 0.4, y = 0.62, overlay = { "0.25-0.73","0.33-0.32","0.40-0.62","0.47-0.32","0.57-0.51","0.61-0.31","0.63-0.21","0.66-0.69","0.72-0.52" }, displayID = 92246, weeklyReset = true }; --The Hivekiller
	[155172] = { zoneID = 942, artID = { 967 }, x = 0.57, y = 0.51, overlay = { "0.25-0.73","0.33-0.32","0.40-0.62","0.47-0.32","0.57-0.51","0.61-0.31","0.63-0.21","0.66-0.7","0.72-0.52" }, displayID = 2537, weeklyReset = true }; --Trapdoor Bee Hunter
	[155173] = { zoneID = 942, artID = { 967 }, x = 0.25, y = 0.73, overlay = { "0.25-0.73","0.33-0.32","0.40-0.62","0.47-0.32","0.57-0.51","0.61-0.31","0.62-0.31","0.63-0.21","0.66-0.7","0.66-0.69","0.72-0.52","0.72-0.51" }, displayID = 81965, weeklyReset = true }; --Honeyback Usurper
	[155176] = { zoneID = 942, artID = { 967 }, x = 0.66, y = 0.69, overlay = { "0.25-0.73","0.33-0.32","0.40-0.62","0.47-0.32","0.57-0.51","0.61-0.31","0.63-0.21","0.66-0.69","0.72-0.52" }, displayID = 77271, weeklyReset = true }; --Old Nasha
	[126427] = { zoneID = 943, artID = { 968 }, x = 0.506, y = 0.56, overlay = { "0.34-0.49","0.34-0.50","0.34-0.48","0.35-0.50","0.35-0.49","0.35-0.52","0.36-0.52","0.36-0.46","0.36-0.50","0.36-0.48","0.36-0.49","0.36-0.55","0.36-0.51","0.37-0.54","0.37-0.5","0.37-0.53","0.37-0.51","0.37-0.46","0.37-0.48","0.38-0.51","0.38-0.50","0.38-0.52","0.38-0.53","0.38-0.49","0.38-0.55","0.38-0.45","0.38-0.56","0.39-0.48","0.39-0.52","0.39-0.53","0.39-0.45","0.39-0.55","0.39-0.49","0.4-0.52","0.4-0.54","0.40-0.47","0.40-0.50","0.40-0.54","0.40-0.5","0.40-0.48","0.41-0.46","0.41-0.52","0.41-0.41","0.41-0.45","0.41-0.48","0.41-0.38","0.41-0.44","0.41-0.51","0.42-0.4","0.42-0.45","0.42-0.53","0.42-0.47","0.42-0.48","0.42-0.39","0.42-0.42","0.42-0.43","0.43-0.37","0.43-0.47","0.43-0.24","0.43-0.51","0.43-0.54","0.43-0.55","0.43-0.46","0.44-0.5","0.44-0.48","0.45-0.55","0.46-0.55","0.46-0.52","0.46-0.51","0.46-0.46","0.47-0.55","0.5-0.55","0.50-0.56" }, displayID = 56952 }; --Branchlord Aldrus
	[126432] = { zoneID = 943, artID = { 968 }, x = 0.56894577, y = 0.6120317, overlay = { "0.47-0.56","0.48-0.59","0.49-0.60","0.49-0.59","0.49-0.57","0.51-0.58","0.52-0.53","0.52-0.58","0.52-0.59","0.53-0.57","0.53-0.59","0.54-0.60","0.55-0.61","0.55-0.60","0.55-0.62","0.56-0.6","0.57-0.61","0.58-0.61","0.58-0.76","0.59-0.61","0.60-0.61","0.62-0.62","0.62-0.66","0.62-0.68","0.62-0.72","0.63-0.62","0.63-0.69","0.63-0.70","0.63-0.71","0.63-0.67","0.64-0.70","0.64-0.71","0.64-0.72","0.65-0.69","0.65-0.62","0.65-0.67","0.65-0.68","0.65-0.66","0.65-0.70","0.65-0.7","0.65-0.72","0.66-0.67","0.66-0.72","0.66-0.68","0.67-0.67" }, displayID = 37987 }; --Rumbling Goliath
	[126462] = { zoneID = 943, artID = { 968 }, x = 0.69, y = 0.46400002, overlay = { "0.47-0.67","0.47-0.65","0.48-0.55","0.48-0.61","0.49-0.55","0.49-0.59","0.49-0.57","0.5-0.56","0.5-0.57","0.50-0.54","0.50-0.55","0.51-0.56","0.51-0.57","0.51-0.54","0.51-0.53","0.52-0.43","0.52-0.52","0.52-0.55","0.52-0.48","0.52-0.50","0.52-0.57","0.52-0.47","0.52-0.49","0.52-0.51","0.52-0.5","0.53-0.53","0.53-0.58","0.53-0.56","0.53-0.59","0.53-0.49","0.54-0.56","0.54-0.53","0.55-0.55","0.55-0.44","0.56-0.52","0.56-0.53","0.56-0.55","0.56-0.54","0.57-0.52","0.57-0.54","0.57-0.47","0.57-0.50","0.57-0.33","0.57-0.51","0.58-0.51","0.58-0.53","0.58-0.54","0.58-0.55","0.59-0.38","0.59-0.51","0.59-0.54","0.59-0.52","0.60-0.53","0.60-0.55","0.61-0.50","0.61-0.56","0.61-0.55","0.61-0.52","0.62-0.54","0.62-0.55","0.62-0.56","0.63-0.54","0.64-0.46","0.65-0.53","0.65-0.51","0.65-0.50","0.66-0.48","0.66-0.43","0.66-0.44","0.69-0.46" }, friendly = { "A" }, displayID = 12814 }; --Fozruk
	[142251] = { zoneID = 943, artID = { 968 }, x = 0.582, y = 0.346, overlay = { "0.38-0.26","0.40-0.28","0.41-0.29","0.42-0.29","0.42-0.35","0.42-0.41","0.42-0.39","0.42-0.26","0.42-0.27","0.42-0.30","0.42-0.31","0.42-0.34","0.42-0.24","0.42-0.32","0.42-0.38","0.43-0.26","0.43-0.27","0.43-0.35","0.43-0.25","0.43-0.28","0.43-0.32","0.43-0.34","0.43-0.24","0.43-0.29","0.43-0.31","0.43-0.33","0.43-0.23","0.44-0.33","0.44-0.25","0.44-0.26","0.44-0.29","0.44-0.27","0.44-0.28","0.44-0.30","0.45-0.30","0.45-0.22","0.45-0.26","0.45-0.27","0.45-0.31","0.46-0.23","0.46-0.29","0.46-0.19","0.46-0.20","0.46-0.30","0.47-0.19","0.47-0.27","0.47-0.22","0.47-0.23","0.47-0.18","0.48-0.23","0.48-0.29","0.48-0.31","0.53-0.35","0.57-0.32","0.58-0.34" }, displayID = 66633 }; --Yogursa
	[142301] = { zoneID = 943, artID = { 968 }, x = 0.536, y = 0.222, overlay = { "0.46-0.20","0.46-0.19","0.48-0.13","0.49-0.13","0.51-0.11","0.51-0.10","0.51-0.12","0.51-0.09","0.51-0.07","0.52-0.13","0.52-0.10","0.53-0.10","0.53-0.17","0.53-0.22" }, displayID = 46232 }; --Venomarus
	[142312] = { zoneID = 943, artID = { 968 }, x = 0.666, y = 0.566, overlay = { "0.65-0.56","0.65-0.57","0.65-0.59","0.65-0.53","0.65-0.54","0.65-0.55","0.66-0.53","0.66-0.56","0.66-0.58","0.66-0.57" }, displayID = 61297 }; --Skullripper
	[142321] = { zoneID = 943, artID = { 968 }, x = 0.48400003, y = 0.55, overlay = { "0.33-0.40","0.33-0.42","0.33-0.43","0.33-0.41","0.33-0.44","0.34-0.39","0.34-0.38","0.34-0.41","0.35-0.42","0.37-0.39","0.37-0.32","0.48-0.55" }, displayID = 37771 }; --Ragebeak
	[142361] = { zoneID = 943, artID = { 968 }, x = 0.77599996, y = 0.296, overlay = { "0.67-0.40","0.68-0.33","0.7-0.35","0.71-0.31","0.72-0.41","0.72-0.31","0.72-0.40","0.73-0.36","0.74-0.41","0.74-0.33","0.74-0.34","0.75-0.32","0.75-0.28","0.75-0.30","0.75-0.31","0.76-0.29","0.76-0.30","0.77-0.30","0.77-0.31","0.77-0.29" }, displayID = 54845 }; --Plaguefeather
	[142418] = { zoneID = 943, artID = { 968 }, x = 0.48400003, y = 0.576, overlay = { "0.36-0.54","0.37-0.53","0.37-0.52","0.37-0.54","0.38-0.54","0.38-0.58","0.39-0.58","0.40-0.57","0.40-0.59","0.43-0.55","0.45-0.55","0.47-0.57","0.48-0.57" }, displayID = 62045 }; --Cresting Goliath
	[142419] = { zoneID = 943, artID = { 968 }, x = 0.61, y = 0.498, overlay = { "0.53-0.58","0.59-0.48","0.60-0.48","0.60-0.47","0.60-0.49","0.61-0.49" }, displayID = 54195 }; --Thundering Goliath
	[135448] = { zoneID = 976, artID = { 976 }, x = 0.3556, y = 0.4744, overlay = { "0.35-0.47" }, displayID = 84258 }; --Gol'than the Malodorous
	[140123] = { zoneID = 1004, artID = { 1001 }, x = 0.5441, y = 0.4922, displayID = 86571 }; --Weaponmaster Halu
	[136945] = { zoneID = 1016, artID = { 1007 }, x = 0.2404, y = 0.3449, displayID = 80965 }; --Corvus 
	[134112] = { zoneID = 1018, artID = { 1009 }, x = 0.5138, y = 0.6374, displayID = 81890 }; --Matron Christiane
	[139194] = { zoneID = 1041, artID = { 1021 }, x = 0.6218468, y = 0.63534534, displayID = 57548 }; --Rotmaw
	[140593] = { zoneID = 1041, artID = { 1021 }, x = 0.4605, y = 0.2511, displayID = 84330 }; --Restless Horror
	[137983] = { zoneID = 1161, artID = { 1138 }, x = 0.336, y = 0.67, overlay = { "0.24-0.64","0.25-0.64","0.26-0.63","0.28-0.69","0.29-0.63","0.29-0.69","0.29-0.68","0.29-0.70","0.3-0.67","0.30-0.63","0.30-0.67","0.30-0.68","0.30-0.69","0.31-0.67","0.31-0.63","0.31-0.69","0.31-0.64","0.31-0.65","0.32-0.63","0.32-0.67","0.32-0.69","0.32-0.66","0.32-0.64","0.33-0.61","0.33-0.66","0.33-0.67" }, friendly = { "A" }, displayID = 85666 }; --Rear Admiral Hainsworth
	[138039] = { zoneID = 1161, artID = { 1138 }, x = 0.338, y = 0.676, overlay = { "0.28-0.62","0.29-0.63","0.30-0.66","0.31-0.67","0.31-0.63","0.31-0.64","0.32-0.66","0.33-0.67" }, friendly = { "H" }, displayID = 30071 }; --Dark Ranger Clea
	[139287] = { zoneID = 1161, artID = { 1138 }, x = 0.83, y = 0.496, overlay = { "0.75-0.37","0.75-0.38","0.75-0.41","0.76-0.39","0.76-0.46","0.76-0.38","0.76-0.42","0.76-0.43","0.76-0.36","0.76-0.44","0.76-0.50","0.76-0.37","0.77-0.40","0.77-0.42","0.77-0.43","0.77-0.46","0.77-0.47","0.77-0.48","0.77-0.49","0.77-0.45","0.77-0.5","0.78-0.37","0.78-0.38","0.78-0.44","0.78-0.46","0.78-0.49","0.78-0.41","0.78-0.47","0.78-0.39","0.79-0.46","0.79-0.52","0.79-0.40","0.79-0.41","0.79-0.42","0.79-0.48","0.79-0.49","0.79-0.50","0.79-0.44","0.79-0.47","0.8-0.43","0.8-0.44","0.8-0.45","0.80-0.49","0.80-0.45","0.80-0.47","0.80-0.48","0.81-0.49","0.81-0.50","0.82-0.51","0.83-0.49" }, displayID = 80474, questID = { 51877 } }; --Sawtooth
	[143559] = { zoneID = 1161, artID = { 1138 }, x = 0.56200004, y = 0.26, overlay = { "0.56-0.26" }, friendly = { "A" }, displayID = 82677 }; --Grand Marshal Tremblade
	[143560] = { zoneID = 1161, artID = { 1138 }, x = 0.564, y = 0.258, overlay = { "0.56-0.25" }, friendly = { "A" }, displayID = 82676 }; --Marshal Gabriel
	[145161] = { zoneID = 1161, artID = { 1138 }, x = 0.346, y = 0.684, overlay = { "0.30-0.63","0.30-0.68","0.30-0.62","0.31-0.64","0.31-0.63","0.31-0.66","0.32-0.65","0.32-0.62","0.32-0.63","0.32-0.61","0.32-0.67","0.32-0.66","0.32-0.64","0.33-0.65","0.33-0.61","0.33-0.62","0.33-0.66","0.34-0.68" }, friendly = { "H" }, displayID = 88988 }; --Siege Engineer Krackleboom
	[120899] = { zoneID = 1165, artID = { 1143 }, x = 0.55, y = 0.83599997, overlay = { "0.55-0.82","0.55-0.83" }, displayID = 76019, questID = { 48333 } }; --Kul'krazahn
	[122639] = { zoneID = 1165, artID = { 1143 }, x = 0.506, y = 0.59599996, overlay = { "0.49-0.59","0.5-0.59","0.50-0.59" }, friendly = { "H" }, displayID = 47367 }; --Old R'gal
	[125816] = { zoneID = 1165, artID = { 1143 }, x = 0.506, y = 0.85, overlay = { "0.49-0.84","0.5-0.82","0.5-0.83","0.5-0.85","0.5-0.86","0.50-0.81","0.50-0.82","0.50-0.84","0.50-0.85" }, friendly = { "H" }, displayID = 78593 }; --Sky Queen
	[130079] = { zoneID = 1183, artID = { 1156 }, x = 0.4241, y = 0.7507, displayID = 88565, questID = { 50819 } }; --Wagga Snarltusk
	[145242] = { zoneID = 1332, artID = { 1185 }, x = 0.536, y = 0.706, overlay = { "0.52-0.72","0.52-0.70","0.52-0.71","0.53-0.69","0.53-0.70" }, displayID = 67608 }; --Scalefiend
	[145250] = { zoneID = 1332, artID = { 1185 }, x = 0.458, y = 0.83800006, overlay = { "0.44-0.84","0.44-0.86","0.44-0.85","0.45-0.83","0.45-0.86" }, displayID = 67206 }; --Madfeather
	[145269] = { zoneID = 1332, artID = { 1185 }, x = 0.44599998, y = 0.35799998, overlay = { "0.44-0.35" }, displayID = 89029 }; --Glimmerspine
	[148144] = { zoneID = 1332, artID = { 1185 }, x = 0.58599997, y = 0.512, overlay = { "0.57-0.51","0.58-0.51" }, friendly = { "H" }, displayID = 77979 }; --Croz Bloodrage
	[148147] = { zoneID = 1332, artID = { 1185 }, x = 0.376, y = 0.574, overlay = { "0.36-0.54","0.36-0.55","0.36-0.56","0.36-0.57","0.37-0.53","0.37-0.54","0.37-0.55","0.37-0.57" }, friendly = { "H" }, displayID = 89896 }; --Orwell Stevenson
	[148154] = { zoneID = 1332, artID = { 1185 }, x = 0.566, y = 0.35599998, overlay = { "0.55-0.35","0.56-0.35" }, friendly = { "H" }, displayID = 89897 }; --Agathe Wyrmwood
	[149512] = { zoneID = 1332, artID = { 1185 }, x = 0.37, y = 0.55799997, overlay = { "0.36-0.54","0.36-0.55","0.37-0.55" }, friendly = { "A" }, displayID = 62590 }; --Shadowclaw
	[149514] = { zoneID = 1332, artID = { 1185 }, x = 0.58599997, y = 0.514, overlay = { "0.57-0.51","0.58-0.51" }, friendly = { "A" }, displayID = 89315 }; --Grimhorn
	[149516] = { zoneID = 1332, artID = { 1185 }, x = 0.568, y = 0.35599998, overlay = { "0.56-0.35","0.56-0.37" }, friendly = { "A" }, displayID = 707 }; --Blackpaw
	[144644] = { zoneID = 1355, artID = { 1186 }, x = 0.734, y = 0.288, overlay = { "0.24-0.35","0.26-0.42","0.27-0.27","0.27-0.28","0.27-0.42","0.28-0.27","0.28-0.28","0.29-0.48","0.31-0.42","0.31-0.43","0.32-0.34","0.32-0.49","0.33-0.35","0.34-0.26","0.34-0.43","0.34-0.35","0.34-0.37","0.35-0.47","0.35-0.33","0.35-0.34","0.35-0.49","0.35-0.81","0.35-0.48","0.35-0.28","0.36-0.47","0.36-0.78","0.36-0.87","0.36-0.38","0.37-0.56","0.37-0.77","0.37-0.16","0.37-0.39","0.38-0.42","0.38-0.49","0.38-0.57","0.38-0.12","0.38-0.30","0.38-0.78","0.39-0.30","0.39-0.56","0.39-0.81","0.39-0.42","0.39-0.57","0.40-0.85","0.41-0.62","0.41-0.61","0.41-0.60","0.42-0.80","0.42-0.42","0.42-0.12","0.43-0.61","0.44-0.53","0.44-0.63","0.44-0.37","0.45-0.59","0.45-0.49","0.45-0.5","0.45-0.61","0.45-0.24","0.45-0.32","0.46-0.6","0.46-0.28","0.46-0.47","0.46-0.60","0.47-0.59","0.48-0.46","0.5-0.50","0.50-0.50","0.50-0.57","0.50-0.48","0.50-0.65","0.51-0.56","0.51-0.67","0.52-0.38","0.55-0.51","0.55-0.28","0.55-0.27","0.57-0.53","0.57-0.13","0.57-0.35","0.58-0.30","0.58-0.26","0.59-0.26","0.59-0.3","0.59-0.09","0.59-0.15","0.59-0.38","0.6-0.09","0.60-0.15","0.60-0.14","0.60-0.28","0.60-0.35","0.60-0.50","0.60-0.32","0.60-0.33","0.61-0.27","0.61-0.19","0.61-0.52","0.62-0.48","0.63-0.17","0.63-0.18","0.65-0.24","0.67-0.26","0.67-0.31","0.69-0.28","0.71-0.46","0.71-0.36","0.72-0.36","0.73-0.26","0.73-0.28" }, displayID = 91114, questID = { 56274 } }; --Mirecrawler
	[149653] = { zoneID = 1355, artID = { 1186 }, x = 0.548, y = 0.41799998, overlay = { "0.54-0.41" }, displayID = 80467, questID = { 55366 } }; --Carnivorous Lasher
	[150191] = { zoneID = 1355, artID = { 1186 }, x = 0.368, y = 0.116000004, overlay = { "0.36-0.11" }, displayID = 90991, questID = { 55584 } }; --Avarius
	[150468] = { zoneID = 1355, artID = { 1186 }, x = 0.482, y = 0.24200001, overlay = { "0.48-0.24" }, displayID = 91869, questID = { 55603 } }; --Vor'koth
	[150583] = { zoneID = 1355, artID = { 1186 }, x = 0.82199997, y = 0.376, overlay = { "0.27-0.30","0.27-0.31","0.29-0.42","0.29-0.40","0.29-0.41","0.3-0.40","0.30-0.42","0.32-0.33","0.32-0.34","0.32-0.35","0.33-0.37","0.33-0.46","0.33-0.47","0.33-0.33","0.34-0.47","0.34-0.33","0.34-0.48","0.34-0.34","0.35-0.33","0.35-0.34","0.37-0.74","0.37-0.39","0.37-0.40","0.37-0.44","0.37-0.73","0.37-0.41","0.38-0.74","0.38-0.85","0.38-0.75","0.38-0.86","0.39-0.56","0.39-0.58","0.39-0.87","0.39-0.57","0.39-0.64","0.4-0.85","0.40-0.46","0.40-0.62","0.40-0.64","0.40-0.67","0.40-0.47","0.40-0.66","0.41-0.48","0.41-0.49","0.41-0.66","0.41-0.59","0.41-0.61","0.41-0.62","0.41-0.86","0.42-0.87","0.43-0.87","0.44-0.65","0.45-0.64","0.45-0.66","0.45-0.43","0.45-0.42","0.46-0.32","0.46-0.41","0.46-0.64","0.47-0.74","0.47-0.75","0.47-0.44","0.47-0.43","0.47-0.72","0.48-0.74","0.48-0.42","0.48-0.70","0.48-0.67","0.49-0.73","0.49-0.70","0.49-0.71","0.49-0.72","0.52-0.44","0.52-0.43","0.54-0.54","0.54-0.42","0.55-0.54","0.55-0.53","0.55-0.48","0.55-0.46","0.56-0.40","0.56-0.41","0.56-0.51","0.56-0.46","0.57-0.46","0.59-0.44","0.6-0.49","0.60-0.49","0.60-0.48","0.60-0.43","0.61-0.53","0.61-0.54","0.62-0.54","0.62-0.53","0.63-0.44","0.63-0.43","0.63-0.46","0.63-0.45","0.64-0.46","0.64-0.45","0.65-0.44","0.67-0.44","0.67-0.49","0.68-0.33","0.68-0.4","0.68-0.42","0.68-0.38","0.68-0.37","0.68-0.41","0.68-0.45","0.69-0.41","0.69-0.42","0.69-0.49","0.69-0.33","0.69-0.50","0.70-0.40","0.70-0.30","0.71-0.29","0.71-0.49","0.71-0.46","0.71-0.27","0.72-0.28","0.73-0.31","0.73-0.29","0.74-0.27","0.76-0.24","0.76-0.28","0.76-0.25","0.76-0.26","0.76-0.31","0.76-0.39","0.77-0.28","0.77-0.38","0.77-0.39","0.77-0.31","0.77-0.40","0.77-0.24","0.77-0.32","0.77-0.42","0.77-0.41","0.78-0.29","0.78-0.38","0.78-0.31","0.78-0.35","0.78-0.30","0.78-0.32","0.79-0.4","0.79-0.35","0.8-0.37","0.80-0.41","0.80-0.35","0.80-0.37","0.80-0.39","0.80-0.40","0.80-0.36","0.81-0.37","0.82-0.37" }, displayID = 90992, questID = { 56291 } }; --Rockweed Shambler
	[151719] = { zoneID = 1355, artID = { 1186 }, x = 0.676, y = 0.346, overlay = { "0.67-0.34" }, displayID = 90988, questID = { 56300 } }; --Voice in the Deeps
	[151870] = { zoneID = 1355, artID = { 1186 }, x = 0.85400003, y = 0.35799998, overlay = { "0.25-0.31","0.26-0.28","0.26-0.32","0.26-0.29","0.26-0.33","0.27-0.27","0.27-0.28","0.27-0.30","0.27-0.32","0.27-0.33","0.27-0.37","0.27-0.38","0.28-0.29","0.28-0.33","0.28-0.38","0.28-0.39","0.28-0.30","0.28-0.47","0.28-0.43","0.29-0.31","0.29-0.38","0.29-0.47","0.29-0.33","0.29-0.46","0.29-0.29","0.29-0.36","0.29-0.40","0.29-0.42","0.29-0.32","0.29-0.4","0.29-0.30","0.3-0.36","0.3-0.38","0.3-0.47","0.30-0.42","0.30-0.36","0.30-0.29","0.30-0.35","0.30-0.41","0.31-0.41","0.31-0.30","0.31-0.36","0.31-0.29","0.31-0.32","0.31-0.35","0.32-0.32","0.32-0.36","0.32-0.33","0.32-0.46","0.32-0.34","0.33-0.29","0.33-0.31","0.33-0.27","0.33-0.35","0.33-0.49","0.33-0.28","0.33-0.3","0.33-0.30","0.33-0.48","0.34-0.49","0.34-0.29","0.34-0.36","0.34-0.41","0.34-0.48","0.35-0.20","0.35-0.44","0.35-0.28","0.35-0.29","0.35-0.36","0.35-0.33","0.35-0.35","0.35-0.40","0.35-0.53","0.35-0.34","0.35-0.45","0.35-0.22","0.36-0.39","0.36-0.21","0.36-0.37","0.36-0.40","0.36-0.68","0.36-0.16","0.36-0.17","0.36-0.22","0.36-0.38","0.36-0.43","0.36-0.55","0.36-0.18","0.36-0.30","0.36-0.44","0.36-0.77","0.37-0.20","0.37-0.30","0.37-0.21","0.37-0.24","0.37-0.27","0.37-0.31","0.37-0.36","0.37-0.43","0.37-0.54","0.37-0.56","0.37-0.65","0.37-0.72","0.37-0.25","0.37-0.26","0.37-0.29","0.37-0.35","0.37-0.40","0.37-0.42","0.37-0.76","0.37-0.37","0.37-0.39","0.37-0.77","0.37-0.28","0.37-0.41","0.37-0.71","0.38-0.36","0.38-0.57","0.38-0.11","0.38-0.19","0.38-0.66","0.38-0.69","0.38-0.16","0.38-0.23","0.38-0.43","0.38-0.70","0.38-0.09","0.38-0.15","0.38-0.30","0.38-0.38","0.38-0.39","0.39-0.19","0.39-0.21","0.39-0.22","0.39-0.23","0.39-0.43","0.39-0.25","0.39-0.39","0.39-0.72","0.39-0.49","0.39-0.45","0.4-0.25","0.4-0.26","0.4-0.40","0.4-0.41","0.4-0.43","0.40-0.14","0.40-0.49","0.40-0.78","0.40-0.8","0.40-0.25","0.40-0.28","0.40-0.42","0.40-0.38","0.40-0.16","0.40-0.26","0.40-0.27","0.40-0.77","0.41-0.14","0.41-0.17","0.41-0.24","0.41-0.37","0.41-0.77","0.41-0.19","0.41-0.78","0.41-0.40","0.41-0.65","0.41-0.67","0.41-0.13","0.41-0.23","0.41-0.39","0.41-0.42","0.41-0.49","0.42-0.15","0.42-0.39","0.42-0.67","0.42-0.68","0.42-0.71","0.42-0.79","0.42-0.40","0.42-0.42","0.42-0.16","0.42-0.21","0.42-0.47","0.42-0.48","0.42-0.60","0.42-0.38","0.42-0.41","0.42-0.59","0.42-0.74","0.42-0.75","0.42-0.17","0.42-0.20","0.42-0.22","0.42-0.72","0.43-0.15","0.43-0.21","0.43-0.23","0.43-0.39","0.43-0.43","0.43-0.49","0.43-0.55","0.43-0.58","0.43-0.79","0.43-0.42","0.43-0.52","0.43-0.54","0.43-0.76","0.43-0.47","0.43-0.16","0.44-0.49","0.44-0.50","0.44-0.54","0.44-0.61","0.44-0.78","0.44-0.59","0.44-0.76","0.44-0.16","0.45-0.47","0.45-0.48","0.45-0.29","0.45-0.61","0.45-0.74","0.45-0.30","0.45-0.59","0.45-0.60","0.46-0.49","0.46-0.50","0.46-0.61","0.46-0.73","0.46-0.76","0.46-0.47","0.46-0.48","0.46-0.65","0.46-0.74","0.46-0.52","0.47-0.48","0.47-0.51","0.47-0.46","0.47-0.76","0.47-0.66","0.47-0.52","0.47-0.62","0.47-0.75","0.48-0.47","0.48-0.68","0.48-0.69","0.48-0.72","0.48-0.48","0.48-0.70","0.48-0.36","0.48-0.40","0.48-0.51","0.48-0.49","0.49-0.36","0.49-0.40","0.49-0.65","0.49-0.66","0.49-0.67","0.49-0.35","0.49-0.49","0.49-0.51","0.49-0.58","0.49-0.68","0.49-0.69","0.49-0.76","0.49-0.46","0.49-0.50","0.49-0.4","0.5-0.32","0.5-0.36","0.5-0.45","0.50-0.39","0.50-0.70","0.50-0.32","0.50-0.26","0.50-0.75","0.51-0.20","0.51-0.32","0.51-0.2","0.51-0.35","0.51-0.56","0.51-0.36","0.51-0.22","0.51-0.25","0.51-0.34","0.52-0.35","0.52-0.36","0.52-0.21","0.52-0.24","0.52-0.28","0.52-0.32","0.52-0.41","0.52-0.55","0.52-0.3","0.52-0.42","0.52-0.43","0.52-0.22","0.52-0.25","0.52-0.26","0.52-0.34","0.53-0.28","0.53-0.32","0.53-0.53","0.53-0.26","0.53-0.18","0.54-0.29","0.54-0.54","0.54-0.24","0.54-0.55","0.54-0.41","0.54-0.28","0.54-0.20","0.54-0.49","0.54-0.56","0.55-0.12","0.55-0.42","0.55-0.48","0.55-0.51","0.55-0.52","0.55-0.55","0.55-0.54","0.55-0.41","0.55-0.43","0.56-0.13","0.56-0.20","0.56-0.47","0.56-0.21","0.56-0.26","0.56-0.45","0.56-0.55","0.56-0.57","0.56-0.11","0.56-0.14","0.56-0.44","0.56-0.50","0.56-0.51","0.56-0.56","0.56-0.49","0.56-0.54","0.57-0.12","0.57-0.49","0.57-0.53","0.57-0.55","0.57-0.24","0.57-0.28","0.57-0.45","0.57-0.25","0.57-0.44","0.57-0.57","0.57-0.11","0.57-0.22","0.57-0.5","0.57-0.10","0.58-0.10","0.58-0.26","0.58-0.28","0.58-0.40","0.58-0.44","0.58-0.53","0.58-0.56","0.58-0.43","0.58-0.47","0.58-0.49","0.58-0.54","0.58-0.09","0.58-0.41","0.58-0.42","0.58-0.52","0.58-0.08","0.58-0.46","0.58-0.48","0.59-0.47","0.59-0.48","0.59-0.53","0.59-0.45","0.59-0.52","0.59-0.55","0.59-0.13","0.59-0.26","0.59-0.28","0.59-0.29","0.59-0.51","0.59-0.39","0.59-0.54","0.6-0.08","0.6-0.26","0.6-0.41","0.6-0.43","0.6-0.51","0.6-0.54","0.60-0.14","0.60-0.24","0.60-0.43","0.60-0.45","0.60-0.5","0.60-0.56","0.60-0.57","0.60-0.13","0.60-0.25","0.60-0.55","0.60-0.41","0.61-0.09","0.61-0.14","0.61-0.18","0.61-0.24","0.61-0.21","0.61-0.29","0.61-0.51","0.61-0.1","0.61-0.26","0.61-0.27","0.61-0.3","0.61-0.43","0.61-0.44","0.61-0.52","0.61-0.54","0.61-0.10","0.61-0.16","0.61-0.30","0.61-0.31","0.61-0.37","0.62-0.44","0.62-0.50","0.62-0.54","0.62-0.10","0.62-0.16","0.62-0.38","0.62-0.43","0.62-0.12","0.62-0.23","0.62-0.46","0.62-0.56","0.62-0.57","0.62-0.11","0.62-0.22","0.62-0.28","0.62-0.45","0.62-0.15","0.63-0.17","0.63-0.22","0.63-0.35","0.63-0.48","0.63-0.58","0.63-0.21","0.63-0.25","0.63-0.34","0.63-0.39","0.63-0.41","0.63-0.44","0.63-0.47","0.63-0.46","0.63-0.33","0.64-0.2","0.64-0.20","0.64-0.37","0.64-0.38","0.64-0.48","0.64-0.57","0.64-0.19","0.64-0.39","0.64-0.44","0.64-0.16","0.64-0.17","0.64-0.28","0.64-0.43","0.64-0.46","0.64-0.14","0.64-0.51","0.65-0.13","0.65-0.25","0.65-0.28","0.65-0.39","0.65-0.43","0.65-0.49","0.65-0.41","0.65-0.48","0.65-0.5","0.65-0.29","0.65-0.38","0.65-0.16","0.65-0.27","0.65-0.37","0.66-0.17","0.66-0.42","0.66-0.19","0.66-0.21","0.66-0.23","0.66-0.40","0.66-0.41","0.66-0.47","0.66-0.25","0.66-0.46","0.66-0.28","0.66-0.22","0.66-0.26","0.67-0.26","0.67-0.36","0.67-0.38","0.67-0.44","0.67-0.47","0.67-0.37","0.67-0.40","0.67-0.41","0.67-0.43","0.67-0.48","0.67-0.51","0.67-0.39","0.67-0.42","0.67-0.35","0.68-0.38","0.68-0.48","0.68-0.32","0.68-0.33","0.68-0.35","0.68-0.36","0.68-0.50","0.68-0.41","0.68-0.45","0.68-0.46","0.68-0.51","0.68-0.47","0.68-0.49","0.68-0.52","0.68-0.40","0.69-0.37","0.69-0.45","0.69-0.49","0.69-0.26","0.69-0.28","0.69-0.52","0.69-0.53","0.69-0.25","0.69-0.48","0.69-0.55","0.69-0.30","0.69-0.51","0.7-0.25","0.7-0.36","0.7-0.37","0.70-0.32","0.70-0.36","0.70-0.29","0.70-0.50","0.70-0.27","0.70-0.37","0.70-0.51","0.71-0.22","0.71-0.41","0.71-0.34","0.71-0.39","0.71-0.44","0.71-0.45","0.71-0.46","0.71-0.48","0.71-0.54","0.71-0.35","0.71-0.38","0.71-0.47","0.71-0.37","0.72-0.29","0.72-0.41","0.72-0.45","0.72-0.42","0.72-0.5","0.72-0.50","0.72-0.28","0.72-0.38","0.73-0.28","0.73-0.29","0.73-0.31","0.73-0.40","0.73-0.46","0.73-0.48","0.73-0.26","0.73-0.35","0.73-0.43","0.73-0.44","0.73-0.36","0.73-0.45","0.74-0.36","0.74-0.42","0.74-0.47","0.74-0.48","0.74-0.26","0.74-0.30","0.74-0.38","0.74-0.39","0.74-0.40","0.74-0.35","0.75-0.26","0.75-0.39","0.75-0.42","0.75-0.45","0.75-0.24","0.75-0.29","0.75-0.30","0.75-0.37","0.75-0.44","0.75-0.25","0.75-0.31","0.75-0.34","0.75-0.32","0.75-0.35","0.75-0.27","0.76-0.41","0.76-0.25","0.76-0.27","0.76-0.34","0.76-0.37","0.76-0.31","0.76-0.33","0.76-0.4","0.77-0.38","0.77-0.24","0.77-0.35","0.77-0.42","0.77-0.23","0.77-0.29","0.77-0.36","0.77-0.39","0.77-0.28","0.77-0.40","0.77-0.43","0.78-0.36","0.78-0.41","0.78-0.46","0.78-0.48","0.78-0.3","0.78-0.44","0.78-0.26","0.78-0.28","0.78-0.31","0.78-0.32","0.78-0.33","0.78-0.38","0.78-0.47","0.79-0.36","0.79-0.27","0.79-0.29","0.79-0.35","0.79-0.40","0.79-0.4","0.8-0.31","0.80-0.30","0.80-0.34","0.80-0.41","0.81-0.30","0.81-0.35","0.81-0.40","0.81-0.4","0.82-0.39","0.82-0.40","0.83-0.33","0.84-0.34","0.84-0.39","0.84-0.37","0.85-0.35","0.85-0.38" }, displayID = 47677, questID = { 56276 } }; --Sandcastle
	[152290] = { zoneID = 1355, artID = { 1186 }, x = 0.648, y = 0.518, overlay = { "0.53-0.41","0.53-0.42","0.54-0.50","0.54-0.49","0.57-0.51","0.58-0.41","0.6-0.47","0.62-0.59","0.64-0.51" }, displayID = 92542, questID = { 56298 } }; --Soundless
	[152291] = { zoneID = 1355, artID = { 1186 }, x = 0.618, y = 0.48, overlay = { "0.52-0.43","0.52-0.53","0.52-0.54","0.52-0.42","0.52-0.44","0.52-0.52","0.53-0.53","0.53-0.55","0.53-0.42","0.53-0.44","0.53-0.52","0.53-0.56","0.53-0.4","0.53-0.41","0.53-0.43","0.53-0.51","0.53-0.54","0.54-0.52","0.55-0.42","0.55-0.41","0.56-0.44","0.56-0.48","0.56-0.51","0.56-0.42","0.56-0.45","0.56-0.50","0.56-0.52","0.56-0.41","0.56-0.47","0.56-0.54","0.57-0.47","0.57-0.49","0.57-0.52","0.57-0.50","0.58-0.41","0.58-0.55","0.58-0.51","0.58-0.53","0.58-0.54","0.59-0.48","0.59-0.56","0.59-0.55","0.59-0.51","0.59-0.52","0.59-0.49","0.6-0.48","0.60-0.47","0.60-0.55","0.60-0.48","0.60-0.51","0.60-0.52","0.60-0.49","0.61-0.48","0.61-0.52","0.61-0.5" }, displayID = 90735, questID = { 56272 } }; --Deepglider
	[152323] = { zoneID = 1355, artID = { 1186 }, x = 0.292, y = 0.29, overlay = { "0.28-0.29","0.29-0.29" }, displayID = 91234, questID = { 55671 } }; --King Gakula
	[152359] = { zoneID = 1355, artID = { 1186 }, x = 0.71599996, y = 0.548, overlay = { "0.71-0.54" }, displayID = 90766, questID = { 56297 } }; --Siltstalker the Packmother
	[152360] = { zoneID = 1355, artID = { 1186 }, x = 0.692, y = 0.45200002, overlay = { "0.64-0.47","0.64-0.46","0.65-0.50","0.67-0.47","0.68-0.46","0.69-0.45" }, displayID = 90767, questID = { 56278 } }; --Toxigore the Alpha
	[152361] = { zoneID = 1355, artID = { 1186 }, x = 0.732, y = 0.538, overlay = { "0.71-0.54","0.72-0.54","0.73-0.53" }, displayID = 90768, questID = { 56282 } }; --Banescale the Packfather
	[152397] = { zoneID = 1355, artID = { 1186 }, x = 0.78400004, y = 0.256, overlay = { "0.77-0.24","0.78-0.24","0.78-0.25" }, displayID = 91479, questID = { 56288 } }; --Oronu
	[152414] = { zoneID = 1355, artID = { 1186 }, x = 0.66, y = 0.336, overlay = { "0.63-0.34","0.63-0.31","0.63-0.32","0.63-0.33","0.64-0.34","0.64-0.35","0.64-0.32","0.65-0.32","0.65-0.33","0.66-0.33" }, displayID = 91242, questID = { 56284 } }; --Elder Unu
	[152415] = { zoneID = 1355, artID = { 1186 }, x = 0.52599996, y = 0.426, overlay = { "0.52-0.42" }, displayID = 91242, questID = { 56279 } }; --Alga the Eyeless
	[152416] = { zoneID = 1355, artID = { 1186 }, x = 0.71, y = 0.346, overlay = { "0.65-0.37","0.65-0.36","0.65-0.38","0.66-0.40","0.67-0.37","0.68-0.36","0.69-0.40","0.71-0.34" }, displayID = 91242, questID = { 56280 } }; --Allseer Oma'kil
	[152448] = { zoneID = 1355, artID = { 1186 }, x = 0.616, y = 0.426, overlay = { "0.40-0.49","0.40-0.48","0.42-0.47","0.43-0.54","0.43-0.48","0.44-0.55","0.45-0.47","0.45-0.56","0.45-0.55","0.46-0.54","0.46-0.52","0.47-0.55","0.47-0.56","0.49-0.51","0.56-0.57","0.58-0.40","0.61-0.42" }, displayID = 90947, questID = { 56286 } }; --Iridescent Glimmershell
	[152464] = { zoneID = 1355, artID = { 1186 }, x = 0.41325283, y = 0.08827776, displayID = 91024, questID = { 56283 } }; --Caverndark Terror
	[152465] = { zoneID = 1355, artID = { 1186 }, x = 0.706, y = 0.246, overlay = { "0.39-0.27","0.39-0.28","0.46-0.25","0.46-0.30","0.47-0.30","0.48-0.17","0.50-0.19","0.56-0.08","0.70-0.24" }, displayID = 91027, questID = { 56275 } }; --Needlespine
	[152542] = { zoneID = 1355, artID = { 1186 }, x = 0.288, y = 0.466, overlay = { "0.28-0.46" }, displayID = 90033, questID = { 56294 } }; --Scale Matriarch Zodia
	[152545] = { zoneID = 1355, artID = { 1186 }, x = 0.276, y = 0.37, overlay = { "0.27-0.37" }, displayID = 90034, questID = { 56293 } }; --Scale Matriarch Vynara
	[152548] = { zoneID = 1355, artID = { 1186 }, x = 0.35599998, y = 0.41, overlay = { "0.35-0.41" }, displayID = 90035, questID = { 56292 } }; --Scale Matriarch Gratinax
	[152552] = { zoneID = 1355, artID = { 1186 }, x = 0.65599996, y = 0.058000002, overlay = { "0.62-0.08","0.63-0.07","0.64-0.07","0.64-0.05","0.64-0.06","0.65-0.05" }, displayID = 74318, questID = { 56295 } }; --Shassera
	[152553] = { zoneID = 1355, artID = { 1186 }, x = 0.398, y = 0.436, overlay = { "0.31-0.35","0.32-0.36","0.32-0.33","0.35-0.45","0.36-0.45","0.36-0.39","0.36-0.44","0.36-0.40","0.36-0.41","0.37-0.40","0.37-0.47","0.37-0.39","0.38-0.43","0.39-0.43","0.39-0.42" }, displayID = 50760, questID = { 56273 } }; --Garnetscale
	[152555] = { zoneID = 1355, artID = { 1186 }, x = 0.52, y = 0.756, overlay = { "0.51-0.75","0.52-0.75" }, displayID = 78243, questID = { 56285 } }; --Elderspawn Nalaada
	[152556] = { zoneID = 1355, artID = { 1186 }, x = 0.496, y = 0.88, overlay = { "0.49-0.88" }, displayID = 78240, questID = { 56270 } }; --Chasm-Haunter
	[152566] = { zoneID = 1355, artID = { 1186 }, x = 0.58599997, y = 0.536, overlay = { "0.58-0.52","0.58-0.53" }, displayID = 91523, questID = { 56281 } }; --Anemonar
	[152567] = { zoneID = 1355, artID = { 1186 }, x = 0.506, y = 0.692, overlay = { "0.49-0.69","0.49-0.70","0.5-0.69","0.50-0.69" }, displayID = 91524, questID = { 56287 } }; --Kelpwillow
	[152568] = { zoneID = 1355, artID = { 1186 }, x = 0.316, y = 0.306, overlay = { "0.31-0.29","0.31-0.30" }, displayID = 91525, questID = { 56299 } }; --Urduu
	[152671] = { zoneID = 1355, artID = { 1186 }, x = 0.428, y = 0.77800006, overlay = { "0.42-0.77" }, displayID = 91861, weeklyReset = true, questID = { 56055 } }; --Wekemara
	[152681] = { zoneID = 1355, artID = { 1186 }, x = 0.43, y = 0.878, overlay = { "0.42-0.87","0.43-0.87" }, displayID = 58886, questID = { 56289 } }; --Prince Typhonus
	[152682] = { zoneID = 1355, artID = { 1186 }, x = 0.436, y = 0.744, overlay = { "0.42-0.74","0.42-0.75","0.43-0.74" }, displayID = 65631, questID = { 56290 } }; --Prince Vortran
	[152712] = { zoneID = 1355, artID = { 1186 }, x = 0.376, y = 0.826, overlay = { "0.37-0.82" }, displayID = 75839, questID = { 56269 } }; --Blindlight
	[152736] = { zoneID = 1355, artID = { 1186 }, x = 0.84599996, y = 0.35799998, overlay = { "0.83-0.35","0.83-0.36","0.83-0.37","0.84-0.34","0.84-0.35" }, displayID = 91573, weeklyReset = true, questID = { 56058 } }; --Guardian Tyr'mar
	[152756] = { zoneID = 1355, artID = { 1186 }, x = 0.726, y = 0.258, overlay = { "0.26-0.28","0.26-0.29","0.27-0.30","0.28-0.31","0.38-0.58","0.39-0.58","0.39-0.59","0.4-0.83","0.40-0.28","0.40-0.81","0.41-0.59","0.47-0.76","0.48-0.19","0.48-0.21","0.50-0.74","0.57-0.4","0.57-0.40","0.7-0.42","0.70-0.32","0.71-0.33","0.71-0.27","0.71-0.28","0.72-0.25","0.72-0.27","0.72-0.28" }, displayID = 90944, questID = { 56271 } }; --Daggertooth Terror
	[152794] = { zoneID = 1355, artID = { 1186 }, x = 0.796, y = 0.428, overlay = { "0.25-0.32","0.26-0.34","0.27-0.27","0.28-0.34","0.28-0.27","0.31-0.42","0.31-0.43","0.32-0.38","0.33-0.49","0.33-0.35","0.34-0.37","0.34-0.41","0.34-0.43","0.35-0.37","0.35-0.33","0.35-0.48","0.35-0.28","0.36-0.48","0.36-0.24","0.36-0.78","0.36-0.47","0.37-0.16","0.37-0.39","0.38-0.78","0.38-0.30","0.39-0.45","0.39-0.17","0.39-0.19","0.39-0.57","0.4-0.24","0.4-0.57","0.40-0.20","0.40-0.42","0.41-0.32","0.41-0.60","0.41-0.61","0.42-0.42","0.43-0.4","0.43-0.20","0.43-0.61","0.44-0.2","0.44-0.53","0.45-0.53","0.45-0.49","0.45-0.50","0.45-0.59","0.45-0.61","0.45-0.32","0.45-0.39","0.46-0.18","0.46-0.6","0.46-0.15","0.46-0.29","0.46-0.60","0.46-0.61","0.47-0.59","0.48-0.46","0.5-0.50","0.50-0.48","0.51-0.67","0.52-0.36","0.52-0.33","0.52-0.56","0.54-0.55","0.54-0.5","0.55-0.28","0.56-0.18","0.56-0.55","0.57-0.18","0.57-0.53","0.58-0.30","0.59-0.3","0.59-0.15","0.6-0.48","0.60-0.14","0.60-0.39","0.60-0.28","0.61-0.27","0.61-0.52","0.61-0.36","0.61-0.54","0.62-0.32","0.63-0.19","0.64-0.18","0.65-0.51","0.67-0.23","0.67-0.27","0.68-0.33","0.68-0.18","0.70-0.25","0.79-0.42" }, displayID = 90519, questID = { 56268 } }; --Amethyst Spireshell
	[152795] = { zoneID = 1355, artID = { 1186 }, x = 0.84400004, y = 0.406, overlay = { "0.51-0.51","0.51-0.52","0.56-0.44","0.63-0.47","0.63-0.48","0.64-0.54","0.65-0.41","0.68-0.32","0.73-0.45","0.74-0.31","0.74-0.44","0.76-0.52","0.78-0.32","0.78-0.31","0.79-0.38","0.79-0.27","0.80-0.38","0.80-0.42","0.81-0.41","0.81-0.4","0.82-0.41","0.84-0.40" }, displayID = 75368, questID = { 56277 } }; --Sandclaw Stoneshell
	[153658] = { zoneID = 1355, artID = { 1186 }, x = 0.41799998, y = 0.154, overlay = { "0.37-0.14","0.38-0.14","0.38-0.09","0.38-0.17","0.38-0.10","0.38-0.16","0.39-0.16","0.40-0.12","0.40-0.15","0.40-0.11","0.41-0.11","0.41-0.15" }, displayID = 91870, questID = { 56296 } }; --Shiz'narasz the Consumer
	[153898] = { zoneID = 1355, artID = { 1186 }, x = 0.626, y = 0.296, overlay = { "0.62-0.29" }, displayID = 58886, questID = { 56122 } }; --Tidelord Aquatus
	[153928] = { zoneID = 1355, artID = { 1186 }, x = 0.58, y = 0.278, overlay = { "0.57-0.26","0.58-0.26","0.58-0.27" }, displayID = 58886, questID = { 56123 } }; --Tidelord Dispersius
	[154148] = { zoneID = 1355, artID = { 1186 }, x = 0.666, y = 0.236, overlay = { "0.65-0.23","0.66-0.22","0.66-0.23" }, displayID = 68617, questID = { 56106 } }; --Tidemistress Leth'sindra
	[155811] = { zoneID = 1355, artID = { 1186 }, x = 0.336, y = 0.31, overlay = { "0.33-0.3","0.33-0.31","0.33-0.30" }, displayID = 88870, questReset = true, questID = { 56882 } }; --Commander Minzera
	[155836] = { zoneID = 1355, artID = { 1186 }, x = 0.496, y = 0.65599996, overlay = { "0.49-0.66","0.49-0.65" }, displayID = 92499, questReset = true, questID = { 56890 } }; --Theurgist Nitara
	[155838] = { zoneID = 1355, artID = { 1186 }, x = 0.796, y = 0.51, overlay = { "0.78-0.50","0.79-0.51" }, displayID = 92501, questReset = true }; --Incantatrix Vazina
	[155840] = { zoneID = 1355, artID = { 1186 }, x = 0.47599998, y = 0.33200002, overlay = { "0.47-0.32","0.47-0.31","0.47-0.33" }, displayID = 91768, questReset = true, questID = { 56893 } }; --Warlord Zalzjar
	[155841] = { zoneID = 1355, artID = { 1186 }, x = 0.73800004, y = 0.314, overlay = { "0.73-0.31" }, displayID = 92503, questReset = true, questID = { 56894 } }; --Shadowbinder Athissa
	[156676] = { zoneID = 1409, artID = { 1193 }, x = 0.60400003, y = 0.6, overlay = { "0.60-0.6","0.60-0.61","0.60-0.60","0.61-0.61","0.61-0.62","0.6-0.58","0.6-0.61","0.60-0.59" }, friendly = { "H" }, displayID = 86424 }; --Ogre Overseer
	[156986] = { zoneID = 1409, artID = { 1193 }, x = 0.574, y = 0.408, overlay = { "0.57-0.40","0.57-0.41","0.58-0.40","0.58-0.42","0.58-0.43","0.58-0.39","0.58-0.41","0.59-0.39","0.59-0.41","0.59-0.40","0.56-0.41","0.58-0.4","0.59-0.38","0.59-0.4","0.60-0.41","0.60-0.40","0.56-0.42" }, friendly = { "H" }, displayID = 92831 }; --Ogre Taskmaster
	[135497] = { zoneID = 1462, artID = { 1276 }, x = 0.544, y = 0.414, overlay = { "0.38-0.42","0.38-0.29","0.38-0.31","0.38-0.30","0.38-0.35","0.39-0.31","0.39-0.29","0.39-0.32","0.39-0.35","0.4-0.28","0.40-0.30","0.40-0.42","0.40-0.34","0.40-0.37","0.40-0.38","0.40-0.39","0.40-0.4","0.40-0.41","0.40-0.47","0.40-0.44","0.40-0.48","0.40-0.3","0.41-0.41","0.41-0.35","0.41-0.37","0.41-0.39","0.41-0.40","0.41-0.43","0.41-0.49","0.41-0.33","0.41-0.47","0.41-0.34","0.41-0.46","0.42-0.36","0.42-0.38","0.42-0.32","0.42-0.39","0.42-0.42","0.42-0.43","0.42-0.49","0.42-0.48","0.42-0.34","0.42-0.51","0.42-0.31","0.42-0.37","0.42-0.41","0.42-0.52","0.43-0.32","0.43-0.41","0.43-0.35","0.43-0.38","0.43-0.40","0.43-0.46","0.43-0.48","0.43-0.5","0.43-0.39","0.43-0.42","0.44-0.31","0.44-0.36","0.44-0.42","0.44-0.46","0.44-0.47","0.44-0.50","0.44-0.32","0.44-0.34","0.44-0.40","0.44-0.43","0.44-0.44","0.44-0.33","0.44-0.35","0.44-0.41","0.44-0.45","0.45-0.36","0.45-0.37","0.45-0.39","0.45-0.49","0.45-0.43","0.45-0.46","0.45-0.47","0.45-0.50","0.45-0.45","0.45-0.34","0.45-0.51","0.46-0.42","0.46-0.47","0.46-0.39","0.46-0.40","0.46-0.29","0.46-0.37","0.46-0.43","0.46-0.45","0.46-0.48","0.46-0.5","0.47-0.39","0.47-0.40","0.47-0.42","0.47-0.43","0.48-0.40","0.48-0.42","0.48-0.45","0.48-0.48","0.48-0.43","0.48-0.47","0.48-0.39","0.48-0.41","0.48-0.38","0.49-0.41","0.49-0.42","0.49-0.44","0.49-0.46","0.49-0.48","0.49-0.36","0.49-0.47","0.49-0.35","0.49-0.39","0.49-0.43","0.49-0.45","0.49-0.37","0.49-0.38","0.50-0.49","0.50-0.37","0.50-0.48","0.50-0.38","0.50-0.44","0.50-0.46","0.50-0.47","0.51-0.41","0.51-0.42","0.51-0.43","0.51-0.45","0.51-0.38","0.52-0.41","0.52-0.46","0.52-0.40","0.52-0.47","0.52-0.49","0.52-0.43","0.54-0.41" }, displayID = 91307, questID = { 55367 } }; --Fungarian Furor
	[149847] = { zoneID = 1462, artID = { 1276 }, x = 0.82199997, y = 0.21200001, overlay = { "0.81-0.21","0.82-0.21" }, displayID = 89858, questID = { 55812 } }; --Crazed Trogg
	[150342] = { zoneID = 1462, artID = { 1276 }, x = 0.638, y = 0.244, overlay = { "0.62-0.26","0.63-0.25","0.63-0.24" }, displayID = 160, questID = { 55814 } }; --Earthbreaker Gulroc
	[150394] = { zoneID = 1462, artID = { 1276 }, x = 0.636, y = 0.38599998, overlay = { "0.6-0.45","0.61-0.41","0.61-0.42","0.62-0.40","0.62-0.39","0.63-0.38" }, displayID = 90757, questID = { 55546 } }; --Armored Vaultbot
	[150575] = { zoneID = 1462, artID = { 1276 }, x = 0.396, y = 0.536, overlay = { "0.38-0.53","0.39-0.53" }, displayID = 21246, questID = { 55368 } }; --Rumblerocks
	[150937] = { zoneID = 1462, artID = { 1276 }, x = 0.19600001, y = 0.79800004, overlay = { "0.19-0.79","0.19-0.8","0.19-0.80" }, displayID = 86469, questID = { 55545 } }; --Seaspit
	[151124] = { zoneID = 1462, artID = { 1276 }, x = 0.572, y = 0.52599996, overlay = { "0.56-0.54","0.57-0.53","0.57-0.52" }, displayID = 91217, questID = { 55207 } }; --Mechagonian Nullifier
	[151159] = { zoneID = 1462, artID = { 1276 }, x = 0.78400004, y = 0.384, overlay = { "0.45-0.4","0.45-0.40","0.46-0.40","0.47-0.40","0.47-0.4","0.48-0.39","0.48-0.4","0.49-0.39","0.49-0.40","0.50-0.39","0.50-0.37","0.50-0.41","0.50-0.40","0.51-0.37","0.51-0.42","0.51-0.43","0.51-0.44","0.51-0.45","0.51-0.49","0.51-0.50","0.51-0.36","0.52-0.46","0.52-0.49","0.52-0.45","0.53-0.34","0.53-0.35","0.53-0.45","0.53-0.49","0.53-0.31","0.53-0.32","0.53-0.33","0.53-0.58","0.53-0.47","0.54-0.44","0.54-0.48","0.54-0.49","0.54-0.58","0.54-0.35","0.54-0.59","0.55-0.35","0.55-0.44","0.55-0.59","0.55-0.50","0.55-0.43","0.56-0.50","0.56-0.61","0.56-0.34","0.56-0.59","0.56-0.33","0.56-0.51","0.56-0.62","0.56-0.43","0.57-0.33","0.57-0.32","0.57-0.43","0.57-0.50","0.57-0.58","0.57-0.5","0.58-0.31","0.58-0.50","0.58-0.57","0.58-0.29","0.58-0.3","0.58-0.44","0.58-0.51","0.58-0.56","0.58-0.52","0.59-0.44","0.59-0.28","0.59-0.27","0.59-0.47","0.59-0.48","0.59-0.52","0.59-0.56","0.59-0.45","0.6-0.52","0.60-0.27","0.60-0.52","0.60-0.56","0.60-0.66","0.60-0.54","0.60-0.26","0.60-0.44","0.61-0.53","0.61-0.57","0.61-0.65","0.61-0.39","0.61-0.4","0.61-0.42","0.61-0.44","0.61-0.40","0.61-0.41","0.61-0.64","0.61-0.43","0.62-0.40","0.62-0.58","0.62-0.27","0.62-0.52","0.62-0.60","0.62-0.62","0.62-0.26","0.62-0.32","0.62-0.33","0.62-0.35","0.62-0.36","0.62-0.37","0.62-0.44","0.62-0.57","0.62-0.61","0.62-0.51","0.62-0.34","0.63-0.28","0.63-0.31","0.63-0.25","0.63-0.29","0.63-0.45","0.63-0.50","0.63-0.55","0.63-0.49","0.64-0.54","0.64-0.30","0.64-0.46","0.64-0.47","0.64-0.49","0.64-0.44","0.64-0.31","0.64-0.43","0.64-0.45","0.64-0.48","0.64-0.29","0.65-0.43","0.65-0.48","0.65-0.31","0.65-0.28","0.65-0.41","0.65-0.42","0.65-0.49","0.65-0.50","0.65-0.51","0.65-0.32","0.65-0.40","0.65-0.52","0.66-0.48","0.66-0.55","0.66-0.28","0.66-0.38","0.66-0.49","0.66-0.33","0.66-0.36","0.66-0.37","0.66-0.53","0.66-0.54","0.66-0.5","0.66-0.35","0.66-0.42","0.67-0.27","0.67-0.46","0.67-0.50","0.67-0.34","0.67-0.41","0.67-0.25","0.67-0.26","0.68-0.46","0.68-0.50","0.68-0.35","0.68-0.51","0.68-0.41","0.68-0.52","0.69-0.52","0.69-0.53","0.69-0.35","0.69-0.55","0.69-0.46","0.69-0.54","0.69-0.56","0.69-0.57","0.7-0.59","0.70-0.32","0.70-0.36","0.70-0.60","0.70-0.46","0.70-0.56","0.71-0.33","0.71-0.35","0.71-0.36","0.71-0.37","0.71-0.56","0.72-0.33","0.72-0.34","0.72-0.55","0.72-0.32","0.72-0.38","0.72-0.31","0.73-0.19","0.73-0.3","0.73-0.20","0.73-0.29","0.73-0.38","0.73-0.44","0.73-0.45","0.73-0.55","0.73-0.2","0.73-0.35","0.73-0.54","0.74-0.21","0.74-0.28","0.74-0.39","0.74-0.22","0.74-0.46","0.74-0.24","0.74-0.26","0.74-0.27","0.74-0.44","0.74-0.54","0.74-0.23","0.74-0.25","0.75-0.54","0.75-0.42","0.75-0.46","0.75-0.38","0.75-0.39","0.75-0.41","0.75-0.55","0.75-0.47","0.75-0.40","0.76-0.56","0.76-0.38","0.76-0.39","0.77-0.49","0.77-0.56","0.77-0.38","0.77-0.50","0.77-0.52","0.77-0.55","0.77-0.39","0.77-0.51","0.77-0.53","0.77-0.54","0.78-0.38" }, displayID = 36372, questID = { 55515 } }; --Fleetfoot
	[151202] = { zoneID = 1462, artID = { 1276 }, x = 0.65800005, y = 0.518, overlay = { "0.65-0.51","0.65-0.52" }, displayID = 90423, questID = { 55513 } }; --Foul Manifestation
	[151296] = { zoneID = 1462, artID = { 1276 }, x = 0.572, y = 0.39400002, overlay = { "0.56-0.40","0.56-0.4","0.56-0.39","0.57-0.39" }, displayID = 36372, questID = { 55515 } }; --Rocket
	[151308] = { zoneID = 1462, artID = { 1276 }, x = 0.556, y = 0.266, overlay = { "0.53-0.31","0.53-0.32","0.53-0.33","0.54-0.31","0.54-0.26","0.54-0.29","0.54-0.28","0.55-0.27","0.55-0.25","0.55-0.26" }, displayID = 11611, questID = { 55539 } }; --Boggac Skullbash
	[151569] = { zoneID = 1462, artID = { 1276 }, x = 0.35599998, y = 0.428, overlay = { "0.35-0.42","0.35-0.43" }, displayID = 92887, questID = { 55514 } }; --Deepwater Maw
	[151623] = { zoneID = 1462, artID = { 1276 }, x = 0.726, y = 0.506, overlay = { "0.71-0.49","0.72-0.49","0.72-0.50" }, displayID = 59347, questID = { 55364 } }; --The Scrap King
	[151625] = { zoneID = 1462, artID = { 1276 }, x = 0.72800004, y = 0.506, overlay = { "0.71-0.48","0.71-0.49","0.72-0.49","0.72-0.50" }, displayID = 91218, questID = { 55364 } }; --The Scrap King
	[151627] = { zoneID = 1462, artID = { 1276 }, x = 0.612, y = 0.614, overlay = { "0.59-0.60","0.60-0.60","0.61-0.61","0.61-0.60" }, displayID = 24118, questID = { 55859 } }; --Mr. Fixthis
	[151672] = { zoneID = 1462, artID = { 1276 }, x = 0.878, y = 0.216, overlay = { "0.87-0.20","0.87-0.21" }, displayID = 73603, questID = { 55386 } }; --Mecharantula
	[151684] = { zoneID = 1462, artID = { 1276 }, x = 0.768, y = 0.44599998, overlay = { "0.76-0.44" }, displayID = 68856, questID = { 55399 } }; --Jawbreaker
	[151702] = { zoneID = 1462, artID = { 1276 }, x = 0.24200001, y = 0.674, overlay = { "0.20-0.68","0.21-0.68","0.21-0.70","0.22-0.70","0.22-0.68","0.22-0.69","0.23-0.67","0.23-0.68","0.24-0.67" }, displayID = 68226, questID = { 55405 } }; --Paol Pondwader
	[151933] = { zoneID = 1462, artID = { 1276 }, x = 0.616, y = 0.41599998, overlay = { "0.60-0.42","0.61-0.41" }, displayID = 92457, questID = { 55544 } }; --Malfunctioning Beastbot
	[151934] = { zoneID = 1462, artID = { 1276 }, x = 0.536, y = 0.408, overlay = { "0.51-0.41","0.52-0.41","0.52-0.40","0.53-0.40" }, displayID = 73601, questID = { 55512 } }; --Arachnoid Harvester
	[151940] = { zoneID = 1462, artID = { 1276 }, x = 0.588, y = 0.246, overlay = { "0.57-0.21","0.58-0.22","0.58-0.23","0.58-0.24" }, displayID = 90502, questID = { 55538 } }; --Uncle T'Rogg
	[152001] = { zoneID = 1462, artID = { 1276 }, x = 0.666, y = 0.234, overlay = { "0.65-0.23","0.65-0.24","0.65-0.25","0.65-0.22","0.65-0.26","0.66-0.23" }, displayID = 77483, questID = { 55537 } }; --Bonepicker
	[152007] = { zoneID = 1462, artID = { 1276 }, x = 0.506, y = 0.48599997, overlay = { "0.38-0.3","0.38-0.29","0.39-0.30","0.39-0.31","0.39-0.44","0.39-0.32","0.4-0.44","0.40-0.30","0.40-0.34","0.40-0.43","0.40-0.44","0.40-0.29","0.40-0.33","0.40-0.42","0.41-0.30","0.41-0.34","0.41-0.28","0.41-0.29","0.41-0.49","0.41-0.33","0.42-0.49","0.42-0.48","0.43-0.44","0.43-0.47","0.44-0.43","0.44-0.44","0.45-0.45","0.45-0.44","0.47-0.48","0.48-0.48","0.49-0.47","0.49-0.48","0.50-0.46","0.50-0.48" }, displayID = 90855, questID = { 55369 } }; --Killsaw
	[152113] = { zoneID = 1462, artID = { 1276 }, x = 0.71800005, y = 0.498, overlay = { "0.66-0.40","0.66-0.47","0.66-0.46","0.66-0.48","0.67-0.42","0.67-0.46","0.68-0.46","0.68-0.47","0.69-0.45","0.71-0.49" }, displayID = 90876, questID = { 55858 } }; --The Kleptoboss
	[152182] = { zoneID = 1462, artID = { 1276 }, x = 0.65800005, y = 0.796, overlay = { "0.65-0.77","0.65-0.78","0.65-0.79" }, displayID = 59007, questID = { 55811 } }; --Rustfeather
	[152569] = { zoneID = 1462, artID = { 1276 }, x = 0.82199997, y = 0.21200001, overlay = { "0.81-0.21","0.82-0.21" }, displayID = 89858, questID = { 55812 } }; --Crazed Trogg
	[152570] = { zoneID = 1462, artID = { 1276 }, x = 0.82199997, y = 0.21200001, overlay = { "0.81-0.21","0.82-0.21" }, displayID = 89858, questID = { 55812 } }; --Crazed Trogg
	[152764] = { zoneID = 1462, artID = { 1276 }, x = 0.592, y = 0.59400004, overlay = { "0.53-0.60","0.54-0.61","0.55-0.57","0.55-0.56","0.55-0.58","0.55-0.59","0.55-0.60","0.55-0.6","0.56-0.62","0.56-0.59","0.57-0.60","0.57-0.63","0.57-0.62","0.58-0.59","0.59-0.59" }, displayID = 2028, questID = { 55856 } }; --Oxidized Leachbeast
	[152922] = { zoneID = 1462, artID = { 1276 }, x = 0.63, y = 0.57, overlay = { "0.63-0.56","0.63-0.57" }, displayID = 92480, questID = { 57387 } }; --Data Anomaly
	[152923] = { zoneID = 1462, artID = { 1276 }, x = 0.632, y = 0.576, overlay = { "0.63-0.56","0.63-0.57" }, displayID = 92478, questID = { 57385 } }; --Data Anomaly
	[152958] = { zoneID = 1462, artID = { 1276 }, x = 0.634, y = 0.576, overlay = { "0.63-0.56","0.63-0.57" }, displayID = 92477, questID = { 57385 } }; --Data Anomaly
	[152961] = { zoneID = 1462, artID = { 1276 }, x = 0.634, y = 0.576, overlay = { "0.63-0.56","0.63-0.57" }, displayID = 92479, questID = { 57387 } }; --Data Anomaly
	[152979] = { zoneID = 1462, artID = { 1276 }, x = 0.63, y = 0.57, overlay = { "0.63-0.56","0.63-0.57" }, displayID = 92481, questID = { 57388 } }; --Data Anomaly
	[152983] = { zoneID = 1462, artID = { 1276 }, x = 0.632, y = 0.576, overlay = { "0.62-0.56","0.63-0.57" }, displayID = 92482, questID = { 57388 } }; --Data Anomaly
	[153000] = { zoneID = 1462, artID = { 1276 }, x = 0.834, y = 0.218, overlay = { "0.78-0.30","0.78-0.29","0.79-0.28","0.79-0.29","0.8-0.28","0.80-0.27","0.81-0.23","0.81-0.24","0.81-0.25","0.81-0.26","0.82-0.22","0.82-0.23","0.83-0.21" }, displayID = 73601, questID = { 55810 } }; --Motobrain Spider
	[153200] = { zoneID = 1462, artID = { 1276 }, x = 0.516, y = 0.5, overlay = { "0.51-0.50","0.51-0.49","0.51-0.5" }, displayID = 90423, questID = { 55857 } }; --Boilburn
	[153205] = { zoneID = 1462, artID = { 1276 }, x = 0.59599996, y = 0.672, overlay = { "0.57-0.69","0.58-0.68","0.59-0.67" }, displayID = 89818, questID = { 55855 } }; --Gemicide
	[153206] = { zoneID = 1462, artID = { 1276 }, x = 0.566, y = 0.35599998, overlay = { "0.55-0.35","0.55-0.39","0.55-0.38","0.56-0.36","0.56-0.37","0.56-0.35" }, displayID = 55680, questID = { 55853 } }; --Ol' Big Tusk
	[153226] = { zoneID = 1462, artID = { 1276 }, x = 0.262, y = 0.786, overlay = { "0.24-0.77","0.25-0.77","0.25-0.76","0.26-0.78" }, displayID = 75702, questID = { 55854 } }; --Steel Singer Freza
	[153228] = { zoneID = 1462, artID = { 1276 }, x = 0.67, y = 0.548, overlay = { "0.23-0.81","0.42-0.49","0.51-0.49","0.51-0.5","0.55-0.59","0.55-0.60","0.55-0.6","0.56-0.59","0.56-0.61","0.58-0.51","0.58-0.52","0.59-0.51","0.59-0.52","0.59-0.67","0.66-0.54","0.67-0.53","0.67-0.54" }, displayID = 91932, questID = { 55852 } }; --Gear Checker Cogstar
	[153486] = { zoneID = 1462, artID = { 1276 }, x = 0.63, y = 0.57, overlay = { "0.62-0.56","0.63-0.57" }, displayID = 92483, questID = { 57389 } }; --Data Anomaly
	[154153] = { zoneID = 1462, artID = { 1276 }, x = 0.566, y = 0.552, overlay = { "0.55-0.57","0.55-0.56","0.55-0.55","0.55-0.58","0.55-0.59","0.55-0.6","0.56-0.55" }, displayID = 90855, questID = { 56207 } }; --Enforcer KX-T57
	[154225] = { zoneID = 1462, artID = { 1276 }, x = 0.582, y = 0.59, overlay = { "0.57-0.57","0.57-0.58","0.58-0.57","0.58-0.59" }, displayID = 92038, questID = { 56182 } }; --The Rusty Prince
	[154342] = { zoneID = 1462, artID = { 1276 }, x = 0.536, y = 0.406, overlay = { "0.52-0.41","0.52-0.42","0.52-0.39","0.52-0.40","0.53-0.40" }, displayID = 73601, questID = { 55512 } }; --Arachnoid Harvester
	[154701] = { zoneID = 1462, artID = { 1276 }, x = 0.8, y = 0.544, overlay = { "0.66-0.58","0.70-0.55","0.71-0.53","0.71-0.54","0.71-0.56","0.72-0.49","0.72-0.56","0.72-0.55","0.73-0.54","0.73-0.6","0.73-0.61","0.73-0.55","0.74-0.53","0.74-0.54","0.75-0.55","0.76-0.56","0.76-0.47","0.77-0.54","0.8-0.54" }, displayID = 76384, questID = { 56367 } }; --Gorged Gear-Cruncher
	[154739] = { zoneID = 1462, artID = { 1276 }, x = 0.736, y = 0.548, overlay = { "0.66-0.58","0.66-0.59","0.73-0.54" }, displayID = 91906, questID = { 56368 } }; --Caustic Mechaslime
	[154968] = { zoneID = 1462, artID = { 1276 }, x = 0.536, y = 0.496, overlay = { "0.53-0.49" }, displayID = 90757, questID = { 55546 } }; --Armored Vaultbot
	[155583] = { zoneID = 1462, artID = { 1276 }, x = 0.826, y = 0.77800006, overlay = { "0.81-0.76","0.81-0.77","0.82-0.76","0.82-0.77" }, displayID = 91409, questID = { 56737 } }; --Scrapclaw
	[160708] = { zoneID = {
				[1469] = { x = 0.67800003, y = 0.39200002, overlay = { "0.39-0.48","0.39-0.79","0.39-0.82","0.39-0.81","0.4-0.78","0.42-0.74","0.49-0.78","0.51-0.76","0.52-0.75","0.52-0.76","0.52-0.77","0.57-0.52","0.57-0.51","0.58-0.55","0.59-0.52","0.59-0.53","0.59-0.51","0.6-0.51","0.60-0.5","0.60-0.52","0.67-0.39" } };
				[1470] = { x = 0.764, y = 0.648, overlay = { "0.49-0.86","0.5-0.85","0.54-0.55","0.54-0.56","0.54-0.57","0.55-0.57","0.56-0.56","0.59-0.69","0.60-0.72","0.61-0.73","0.61-0.74","0.61-0.75","0.62-0.30","0.62-0.31","0.62-0.32","0.62-0.3","0.62-0.72","0.65-0.76","0.74-0.62","0.75-0.63","0.75-0.64","0.76-0.64" } };
			  }, displayID = 92712 }; --null
	[156820] = { zoneID = 1470, artID = { 1340 }, x = 0.76, y = 0.536, overlay = { "0.75-0.53","0.75-0.54","0.76-0.53" }, displayID = 92784 }; --Dod
	[158284] = { zoneID = 1470, artID = { 1340 }, x = 0.676, y = 0.66, overlay = { "0.55-0.75","0.56-0.69","0.56-0.67","0.56-0.70","0.56-0.66","0.56-0.71","0.57-0.62","0.57-0.63","0.57-0.65","0.57-0.73","0.57-0.74","0.58-0.64","0.58-0.63","0.59-0.63","0.59-0.64","0.60-0.62","0.61-0.61","0.62-0.61","0.64-0.61","0.65-0.62","0.65-0.63","0.66-0.64","0.67-0.65","0.67-0.63","0.67-0.66" }, displayID = 37850 }; --Craggle Wobbletop
	[160341] = { zoneID = 1470, artID = { 1340 }, x = 0.70199996, y = 0.618, overlay = { "0.54-0.56","0.56-0.65","0.59-0.63","0.59-0.61","0.59-0.58","0.59-0.62","0.6-0.58","0.6-0.60","0.6-0.61","0.60-0.42","0.61-0.56","0.61-0.58","0.61-0.60","0.61-0.62","0.61-0.5","0.61-0.6","0.61-0.51","0.61-0.52","0.61-0.59","0.61-0.50","0.61-0.57","0.61-0.54","0.61-0.55","0.62-0.53","0.62-0.55","0.62-0.60","0.62-0.51","0.62-0.61","0.62-0.52","0.62-0.50","0.62-0.59","0.63-0.6","0.63-0.47","0.63-0.61","0.63-0.49","0.63-0.50","0.64-0.66","0.64-0.51","0.64-0.60","0.64-0.50","0.65-0.52","0.65-0.61","0.65-0.65","0.65-0.63","0.65-0.64","0.66-0.61","0.66-0.62","0.66-0.52","0.66-0.59","0.66-0.6","0.66-0.54","0.66-0.56","0.66-0.58","0.66-0.60","0.67-0.50","0.67-0.51","0.67-0.56","0.67-0.62","0.67-0.60","0.67-0.65","0.67-0.54","0.67-0.63","0.67-0.64","0.67-0.52","0.67-0.58","0.67-0.59","0.67-0.61","0.68-0.51","0.68-0.52","0.68-0.64","0.68-0.65","0.68-0.66","0.68-0.49","0.68-0.60","0.68-0.53","0.68-0.62","0.69-0.60","0.69-0.67","0.69-0.53","0.69-0.62","0.70-0.61" }, displayID = 74885 }; --Sewer Beastling
	[155779] = { zoneID = 1525, artID = { 1306 }, x = 0.43833843, y = 0.79396695, overlay = { "0.43-0.79","0.42-0.79" }, displayID = 94408, questID = { 56877 } }; --Tomb Burster <Dread Crawler Queen>
	[156916] = { zoneID = 1525, artID = { 1306 }, x = 0.6974498, y = 0.47257584, overlay = { "0.69-0.47" }, displayID = 93863 }; --Inquisitor Sorin
	[156918] = { zoneID = 1525, artID = { 1306 }, x = 0.647, y = 0.464, overlay = { "0.64-0.46" }, displayID = 93002 }; --Inquisitor Otilia
	[156919] = { zoneID = 1525, artID = { 1306 }, x = 0.67273396, y = 0.43412733, overlay = { "0.67-0.43" }, displayID = 93008 }; --Inquisitor Petre
	[159151] = { zoneID = 1525, artID = { 1306 }, x = 0.7591456, y = 0.5162251, overlay = { "0.76-0.51","0.76-0.52","0.75-0.51" }, displayID = 93863 }; --Inquisitor Traian
	[159152] = { zoneID = 1525, artID = { 1306 }, x = 0.75308555, y = 0.44165516, overlay = { "0.75-0.44" }, displayID = 93073 }; --High Inquisitor Gabi
	[159153] = { zoneID = 1525, artID = { 1306 }, x = 0.71230125, y = 0.4234302, overlay = { "0.71-0.42" }, displayID = 93054 }; --High Inquisitor Radu
	[159154] = { zoneID = 1525, artID = { 1306 }, x = 0.698, y = 0.523, overlay = { "0.69-0.52","0.69-0.51" }, displayID = 93847 }; --High Inquisitor Magda
	[159155] = { zoneID = 1525, artID = { 1306 }, x = 0.72098255, y = 0.5315644, overlay = { "0.72-0.52","0.72-0.53" }, displayID = 93864 }; --High Inquisitor Dacian
	[159156] = { zoneID = 1525, artID = { 1306 }, x = 0.64499146, y = 0.52717555, overlay = { "0.64-0.52" }, displayID = 93845 }; --Grand Inquisitor Nicu
	[159157] = { zoneID = 1525, artID = { 1306 }, x = 0.6937098, y = 0.44692808, overlay = { "0.69-0.45","0.69-0.44","0.70-0.45" }, displayID = 93844 }; --Grand Inquisitor Aurica
	[159496] = { zoneID = 1525, artID = { 1306 }, x = 0.3286, y = 0.1501, overlay = { "0.32-0.15","0.33-0.15","0.32-0.14","0.32-0.17" }, displayID = 98029, questID = { 61618 } }; --Forgemaster Madalav
	[159503] = { zoneID = 1525, artID = { 1306 }, x = 0.3094989, y = 0.22952689, overlay = { "0.31-0.23","0.30-0.23","0.30-0.22","0.24-0.39","0.29-0.26","0.29-0.25","0.3-0.23","0.32-0.24" }, displayID = 98018, questID = { 62220 } }; --Stonefist
	[160385] = { zoneID = 1525, artID = { 1306 }, x = 0.78938466, y = 0.4974557, overlay = { "0.78-0.49" }, displayID = 94233, questID = { 58130 } }; --Soulstalker Doina
	[160392] = { zoneID = 1525, artID = { 1306 }, x = 0.6503278, y = 0.55971825, overlay = { "0.65-0.56","0.65-0.57","0.65-0.55" }, displayID = 94233, questID = { 58130 } }; --Soulstalker Doina
	[160393] = { zoneID = 1525, artID = { 1306 }, x = 0.4877531, y = 0.47958362, overlay = { "0.48-0.48","0.48-0.47" }, displayID = 94233, questID = { 58130 } }; --Soulstalker Doina
	[160640] = { zoneID = 1525, artID = { 1306 }, x = 0.21397164, y = 0.36153728, overlay = { "0.21-0.36" }, displayID = 93068, questID = { 58210 } }; --Innervus
	[160675] = { zoneID = 1525, artID = { 1306 }, x = 0.3781392, y = 0.68754023, overlay = { "0.38-0.69","0.37-0.68","0.38-0.68" }, displayID = 94369, questID = { 58213 } }; --Scrivener Lenua
	[160821] = { zoneID = 1525, artID = { 1306 }, x = 0.38560203, y = 0.72243625, overlay = { "0.38-0.72","0.39-0.71","0.37-0.72","0.38-0.69","0.38-0.71","0.38-0.70","0.39-0.72" }, displayID = 94402, questID = { 58259 } }; --Worldedge Gorger
	[160857] = { zoneID = 1525, artID = { 1306 }, x = 0.360162, y = 0.58037674, overlay = { "0.33-0.55","0.34-0.56","0.34-0.55","0.35-0.62","0.33-0.54","0.33-0.53","0.33-0.56","0.34-0.52","0.34-0.54","0.35-0.53","0.35-0.56","0.36-0.58" }, displayID = 94416, questID = { 58263 } }; --Sire Ladinas <The Lightrazed>
	[161310] = { zoneID = 1525, artID = { 1306 }, x = 0.4445434, y = 0.51459455, overlay = { "0.43-0.50","0.44-0.51","0.42-0.49","0.43-0.49","0.43-0.52","0.42-0.51","0.42-0.48","0.43-0.51","0.41-0.50","0.41-0.51","0.43-0.48","0.44-0.50" }, displayID = 94521, questID = { 58441 } }; --Executioner Adrastia
	[161891] = { zoneID = 1525, artID = { 1306 }, x = 0.7594525, y = 0.61593515, overlay = { "0.75-0.61","0.75-0.60","0.75-0.62","0.75-0.63","0.76-0.60" }, displayID = 94703, questID = { 58633 } }; --Lord Mortegore
	[162481] = { zoneID = 1525, artID = { 1306 }, x = 0.67451096, y = 0.3043906, overlay = { "0.67-0.30" }, displayID = 94868, questID = { 62252 } }; --Sinstone Hoarder
	[162503] = { zoneID = 1525, artID = { 1306 }, x = 0.67454326, y = 0.30486298, overlay = { "0.67-0.30" }, displayID = 94890, questID = { 62252 } }; --Catacombs Cache
	[164388] = { zoneID = 1525, artID = { 1306 }, x = 0.2531695, y = 0.4851632, overlay = { "0.25-0.48","0.24-0.49","0.26-0.49" }, displayID = 69223, questID = { 59584 } }; --Amalgamation of Light
	[165152] = { zoneID = 1525, artID = { 1306 }, x = 0.67974335, y = 0.81797343, overlay = { "0.67-0.82","0.67-0.81" }, displayID = 90426, questID = { 59580 } }; --Leeched Soul
	[165175] = { zoneID = 1525, artID = { 1306 }, x = 0.67771614, y = 0.8201868, overlay = { "0.67-0.82","0.67-0.81" }, displayID = 95669, questID = { 59580 } }; --Prideful Hulk
	[165206] = { zoneID = 1525, artID = { 1306 }, x = 0.66648245, y = 0.5932914, overlay = { "0.66-0.59" }, displayID = 93853, questID = { 59582 } }; --Endlurker
	[165230] = { zoneID = 1525, artID = { 1306 }, x = 0.66588247, y = 0.59426856, overlay = { "0.66-0.59" }, questID = { 59582 } }; --Vignette Bunny
	[165253] = { zoneID = 1525, artID = { 1306 }, x = 0.66706556, y = 0.7120523, overlay = { "0.66-0.71","0.66-0.70" }, displayID = 93077, questID = { 59595 } }; --Tollkeeper Varaboss
	[165290] = { zoneID = 1525, artID = { 1306 }, x = 0.45080197, y = 0.79527265, overlay = { "0.45-0.79","0.46-0.78","0.45-0.78" }, displayID = 92703, questID = { 59612 } }; --Harika the Horrid
	[165980] = { zoneID = 1525, artID = { 1306 }, x = 0.617894, y = 0.7891343, overlay = { "0.61-0.78" }, nameplate = true, questID = { 60022 } }; --Geza
	[165981] = { zoneID = 1525, artID = { 1306 }, x = 0.6184753, y = 0.7942918, overlay = { "0.61-0.79" }, nameplate = true, questID = { 60022 } }; --Reza
	[166292] = { zoneID = 1525, artID = { 1306 }, x = 0.33975807, y = 0.32670188, overlay = { "0.33-0.32","0.35-0.32","0.36-0.30","0.33-0.33","0.34-0.32","0.34-0.34","0.34-0.33","0.35-0.33","0.36-0.31","0.32-0.32","0.33-0.31","0.35-0.31","0.36-0.32","0.37-0.29","0.37-0.30","0.37-0.32","0.37-0.31","0.37-0.28","0.38-0.29","0.31-0.31","0.32-0.33","0.32-0.31","0.36-0.3","0.37-0.3","0.38-0.31","0.38-0.32" }, displayID = 96261, questID = { 59823 } }; --Bog Beast
	[166393] = { zoneID = 1525, artID = { 1306 }, x = 0.53255945, y = 0.7300231, overlay = { "0.53-0.72","0.53-0.73" }, displayID = 91695, questID = { 59854 } }; --Amalgamation of Filth
	[166483] = { zoneID = 1525, artID = { 1306 }, x = 0.62492, y = 0.47165966, overlay = { "0.62-0.47" }, displayID = 96097, questID = { 59869 } }; --Buscadora Hilda
	[166521] = { zoneID = 1525, artID = { 1306 }, x = 0.62868726, y = 0.47704992, overlay = { "0.62-0.47","0.63-0.48","0.62-0.46","0.62-0.48","0.63-0.46","0.63-0.45","0.63-0.47" }, displayID = 94229, questID = { 59869 } }; --Famu the Infinite
	[166576] = { zoneID = 1525, artID = { 1306 }, x = 0.355218, y = 0.6847832, overlay = { "0.34-0.68","0.35-0.68","0.35-0.70","0.36-0.68","0.35-0.69","0.33-0.68" }, displayID = 95209, questID = { 59893 } }; --Azgar
	[166679] = { zoneID = 1525, artID = { 1306 }, x = 0.5206616, y = 0.5181178, overlay = { "0.51-0.51","0.51-0.52","0.52-0.51","0.50-0.52","0.51-0.50","0.52-0.52" }, displayID = 95369, questID = { 59900 } }; --Hopecrusher
	[166682] = { zoneID = 1525, artID = { 1306 }, x = 0.5198185, y = 0.5180235, overlay = { "0.51-0.51" }, questID = { 59900 } }; --Large Prey
	[166710] = { zoneID = 1525, artID = { 1306 }, x = 0.36643192, y = 0.47398767, overlay = { "0.37-0.47","0.36-0.47","0.37-0.46","0.37-0.48","0.36-0.45","0.36-0.49" }, displayID = 94737, questID = { 59913 } }; --Executioner Aatron
	[166993] = { zoneID = 1525, artID = { 1306 }, x = 0.617034, y = 0.79504395, overlay = { "0.61-0.78","0.61-0.79","0.61-0.77" }, displayID = 96391, questID = { 60022 } }; --Huntmaster Petrus
	[167464] = { zoneID = 1525, artID = { 1306 }, x = 0.20493443, y = 0.529916, overlay = { "0.20-0.53","0.20-0.54","0.20-0.52" }, displayID = 96483, questID = { 60173 } }; --Grand Arcanist Dimitri
	[169253] = { zoneID = 1525, artID = { 1306 }, x = 0.42969894, y = 0.7916527, overlay = { "0.42-0.79" }, questID = { 56877 } }; --Spell Bunny
	[170048] = { zoneID = 1525, artID = { 1306 }, x = 0.49067134, y = 0.34969762, overlay = { "0.49-0.35","0.49-0.34","0.48-0.34","0.49-0.33","0.5-0.34" }, displayID = 95669, questID = { 60729 } }; --Manifestation of Wrath
	[170434] = { zoneID = 1525, artID = { 1306 }, x = 0.6573, y = 0.2915, overlay = { "0.65-0.29" }, displayID = 94868, questID = { 60836 } }; --Amalgamation of Sin
	[173468] = { zoneID = 1525, artID = { 1306 }, x = 0.6291, y = 0.4309, overlay = { "0.62-0.43" }, displayID = 98448, nameplate = true, questID = { 62050 } }; --Dead Blanchy
	[176347] = { zoneID = 1525, artID = { 1306 }, x = 0.37836614, y = 0.6872248, overlay = { "0.37-0.68" }, questID = { 58213 } }; --Escribana Lenua
	[151609] = { zoneID = 1527, artID = { 1343 }, x = 0.736, y = 0.742, overlay = { "0.73-0.74" }, displayID = 34745, zoneQuestId = { 55350 }, questID = { 55353 } }; --Sun Prophet Epaphos
	[151852] = { zoneID = 1527, artID = { 1343 }, x = 0.816, y = 0.518, overlay = { "0.77-0.52","0.78-0.51","0.78-0.52","0.79-0.51","0.79-0.52","0.80-0.52","0.80-0.51","0.81-0.51" }, displayID = 91292, zoneQuestId = { 55350 }, questID = { 55461 } }; --Watcher Rehu
	[151878] = { zoneID = 1527, artID = { 1343 }, x = 0.79, y = 0.638, overlay = { "0.79-0.63" }, displayID = 91296, zoneQuestId = { 57157,55350,56308 }, questID = { 58613 } }; --Sun King Nahkotep
	[151883] = { zoneID = 1527, artID = { 1343 }, x = 0.748, y = 0.52, overlay = { "0.68-0.51","0.68-0.53","0.69-0.50","0.69-0.53","0.70-0.50","0.70-0.53","0.71-0.53","0.72-0.51","0.72-0.52","0.73-0.50","0.73-0.51","0.73-0.53","0.74-0.51","0.74-0.52" }, displayID = 81080, zoneQuestId = { 55350 }, questID = { 55468 } }; --Anaua
	[151897] = { zoneID = 1527, artID = { 1343 }, x = 0.84599996, y = 0.57, overlay = { "0.84-0.57" }, displayID = 92920, zoneQuestId = { 55350 }, questID = { 55479 } }; --Sun Priestess Nubitt
	[151948] = { zoneID = 1527, artID = { 1343 }, x = 0.73800004, y = 0.64599997, overlay = { "0.73-0.64" }, displayID = 37352, zoneQuestId = { 55350 }, questID = { 55496 } }; --Senbu the Pridefather
	[151995] = { zoneID = 1527, artID = { 1343 }, x = 0.806, y = 0.47599998, overlay = { "0.77-0.46","0.78-0.45","0.79-0.45","0.80-0.46","0.80-0.47" }, displayID = 91333, zoneQuestId = { 55350 }, questID = { 55502 } }; --Hik-ten the Taskmaster
	[152040] = { zoneID = 1527, artID = { 1343 }, x = 0.696, y = 0.42, overlay = { "0.69-0.41","0.69-0.42" }, displayID = 91321, zoneQuestId = { 55350 }, questID = { 55518 } }; --Scoutmaster Moswen
	[152431] = { zoneID = 1527, artID = { 1343 }, x = 0.77199996, y = 0.5, overlay = { "0.77-0.5" }, displayID = 34901, zoneQuestId = { 57157,55350,56308 }, questID = { 55629 } }; --Kaneb-ti
	[152657] = { zoneID = 1527, artID = { 1343 }, x = 0.68, y = 0.368, overlay = { "0.64-0.36","0.65-0.36","0.65-0.38","0.66-0.34","0.66-0.38","0.67-0.32","0.67-0.33","0.67-0.34","0.67-0.38","0.67-0.35","0.67-0.37","0.68-0.36" }, displayID = 4689, zoneQuestId = { 55350 }, questID = { 55682 } }; --Tat the Bonechewer
	[152677] = { zoneID = 1527, artID = { 1343 }, x = 0.62, y = 0.256, overlay = { "0.62-0.24","0.62-0.25" }, displayID = 91304, zoneQuestId = { 55350 }, questID = { 55684 } }; --Nebet the Ascended
	[152757] = { zoneID = 1527, artID = { 1343 }, x = 0.65, y = 0.516, overlay = { "0.65-0.51" }, displayID = 37539, zoneQuestId = { 55350 }, questID = { 55710 } }; --Atekhramun
	[152788] = { zoneID = 1527, artID = { 1343 }, x = 0.676, y = 0.638, overlay = { "0.67-0.63" }, displayID = 91589, zoneQuestId = { 55350 }, questID = { 55716 } }; --Uat-ka the Sun's Wrath
	[154576] = { zoneID = 1527, artID = { 1343 }, x = 0.47599998, y = 0.588, overlay = { "0.26-0.55","0.26-0.53","0.27-0.51","0.27-0.53","0.27-0.55","0.27-0.54","0.28-0.57","0.28-0.54","0.28-0.56","0.28-0.61","0.28-0.62","0.28-0.55","0.28-0.59","0.29-0.54","0.29-0.57","0.29-0.59","0.29-0.65","0.29-0.61","0.29-0.64","0.29-0.66","0.3-0.64","0.3-0.65","0.30-0.61","0.30-0.62","0.31-0.63","0.31-0.64","0.31-0.66","0.31-0.68","0.31-0.65","0.31-0.67","0.32-0.68","0.32-0.69","0.33-0.44","0.33-0.51","0.33-0.57","0.33-0.58","0.33-0.63","0.33-0.64","0.33-0.45","0.33-0.55","0.33-0.66","0.33-0.43","0.33-0.52","0.33-0.56","0.33-0.65","0.33-0.54","0.34-0.18","0.34-0.19","0.34-0.44","0.34-0.52","0.34-0.64","0.34-0.51","0.34-0.17","0.34-0.66","0.35-0.44","0.35-0.65","0.35-0.66","0.35-0.19","0.35-0.50","0.36-0.44","0.36-0.50","0.36-0.43","0.36-0.5","0.36-0.55","0.36-0.56","0.36-0.57","0.36-0.58","0.37-0.53","0.37-0.48","0.37-0.49","0.38-0.21","0.38-0.48","0.38-0.23","0.38-0.43","0.38-0.42","0.39-0.43","0.39-0.22","0.39-0.23","0.39-0.36","0.39-0.37","0.39-0.35","0.39-0.34","0.4-0.35","0.40-0.44","0.40-0.33","0.40-0.42","0.40-0.34","0.40-0.45","0.41-0.32","0.41-0.42","0.41-0.46","0.41-0.40","0.41-0.41","0.41-0.44","0.42-0.43","0.43-0.42","0.43-0.60","0.44-0.58","0.47-0.58","0.47-0.57" }, displayID = 90724, zoneQuestId = { 57157,55350,56308 }, questID = { 58614 } }; --Aqir Titanus
	[154578] = { zoneID = 1527, artID = { 1343 }, x = 0.45599997, y = 0.546, overlay = { "0.29-0.63","0.32-0.68","0.32-0.16","0.32-0.67","0.32-0.62","0.32-0.66","0.32-0.17","0.33-0.63","0.33-0.19","0.34-0.18","0.35-0.22","0.36-0.19","0.36-0.21","0.37-0.47","0.37-0.48","0.37-0.41","0.37-0.20","0.37-0.42","0.38-0.43","0.38-0.45","0.39-0.43","0.39-0.46","0.39-0.38","0.39-0.42","0.39-0.44","0.4-0.44","0.40-0.24","0.40-0.4","0.40-0.22","0.40-0.43","0.40-0.44","0.41-0.24","0.41-0.38","0.41-0.42","0.41-0.45","0.41-0.40","0.41-0.41","0.42-0.57","0.43-0.59","0.44-0.61","0.45-0.54" }, displayID = 91910, zoneQuestId = { 57157,56308,55350 }, questID = { 58612 } }; --Aqir Flayer
	[154604] = { zoneID = 1527, artID = { 1343 }, x = 0.346, y = 0.188, overlay = { "0.34-0.18" }, displayID = 90723, zoneQuestId = { 56308 }, questID = { 56340 } }; --Lord Aj'qirai
	[155531] = { zoneID = 1527, artID = { 1343 }, x = 0.262, y = 0.616, overlay = { "0.17-0.60","0.17-0.62","0.17-0.59","0.18-0.60","0.18-0.62","0.18-0.63","0.18-0.65","0.19-0.62","0.19-0.60","0.19-0.64","0.2-0.61","0.20-0.59","0.20-0.60","0.20-0.62","0.20-0.64","0.20-0.58","0.20-0.63","0.21-0.58","0.21-0.64","0.21-0.57","0.21-0.63","0.22-0.60","0.22-0.55","0.22-0.56","0.22-0.59","0.22-0.61","0.22-0.64","0.22-0.57","0.22-0.63","0.23-0.60","0.23-0.56","0.23-0.58","0.23-0.62","0.24-0.62","0.24-0.60","0.24-0.61","0.24-0.63","0.24-0.58","0.24-0.65","0.24-0.57","0.24-0.59","0.25-0.64","0.25-0.63","0.26-0.61" }, displayID = 22122, zoneQuestId = { 57157,55350,56308 }, questID = { 56823 } }; --Infested Wastewander Captain
	[155703] = { zoneID = 1527, artID = { 1343 }, x = 0.32599998, y = 0.644, overlay = { "0.32-0.64" }, displayID = 85193, zoneQuestId = { 57157,55350,56308 }, questID = { 56834 } }; --Anq'uri the Titanic
	[156078] = { zoneID = 1527, artID = { 1343 }, x = 0.33400002, y = 0.66199994, overlay = { "0.30-0.66","0.30-0.68","0.31-0.68","0.31-0.66","0.31-0.64","0.32-0.63","0.32-0.68","0.32-0.62","0.32-0.64","0.32-0.69","0.33-0.66" }, displayID = 93287, zoneQuestId = { 56308 }, questID = { 56952 } }; --Magus Rehleth
	[156299] = { zoneID = 1527, artID = { 1343 }, x = 0.59599996, y = 0.69, overlay = { "0.50-0.50","0.50-0.48","0.51-0.49","0.51-0.51","0.51-0.50","0.52-0.49","0.52-0.50","0.52-0.48","0.52-0.52","0.53-0.48","0.53-0.49","0.53-0.51","0.53-0.50","0.53-0.47","0.54-0.49","0.54-0.53","0.54-0.50","0.54-0.51","0.54-0.47","0.54-0.52","0.55-0.49","0.55-0.48","0.55-0.51","0.56-0.52","0.56-0.53","0.56-0.54","0.57-0.51","0.57-0.54","0.57-0.57","0.57-0.55","0.57-0.56","0.57-0.58","0.57-0.72","0.57-0.74","0.57-0.75","0.57-0.77","0.57-0.78","0.57-0.79","0.57-0.76","0.58-0.58","0.58-0.59","0.58-0.61","0.58-0.73","0.58-0.76","0.58-0.80","0.58-0.57","0.58-0.63","0.58-0.64","0.58-0.71","0.58-0.75","0.58-0.77","0.58-0.81","0.58-0.66","0.58-0.68","0.58-0.69","0.58-0.70","0.58-0.78","0.58-0.8","0.58-0.56","0.58-0.62","0.58-0.72","0.58-0.74","0.58-0.79","0.59-0.69" }, displayID = 84332, zoneQuestId = { 57157,56308 }, questID = { 57430 } }; --R'khuzj the Unfathomable
	[156654] = { zoneID = 1527, artID = { 1343 }, x = 0.58599997, y = 0.828, overlay = { "0.58-0.82" }, displayID = 84407, zoneQuestId = { 57157 }, questID = { 57432 } }; --Shol'thoss the Doomspeaker
	[156655] = { zoneID = 1527, artID = { 1343 }, x = 0.71, y = 0.74, overlay = { "0.70-0.74","0.71-0.74" }, displayID = 76647, zoneQuestId = { 57157 }, questID = { 57433 } }; --Korzaran the Slaughterer
	[157120] = { zoneID = 1527, artID = { 1343 }, x = 0.75, y = 0.686, overlay = { "0.74-0.68","0.75-0.68" }, displayID = 91321, zoneQuestId = { 56308,55350 }, questID = { 57258 } }; --Fangtaker Orsa
	[157134] = { zoneID = 1527, artID = { 1343 }, x = 0.73800004, y = 0.83599997, overlay = { "0.73-0.83" }, displayID = 62509, zoneQuestId = { 57157,55350,56308 }, questID = { 57259 } }; --Ishak of the Four Winds
	[157146] = { zoneID = 1527, artID = { 1343 }, x = 0.68, y = 0.316, overlay = { "0.68-0.31" }, displayID = 10824, zoneQuestId = { 55350 }, questID = { 57273 } }; --Rotfeaster
	[157157] = { zoneID = 1527, artID = { 1343 }, x = 0.66800004, y = 0.202, overlay = { "0.66-0.19","0.66-0.2","0.66-0.20" }, displayID = 91298, zoneQuestId = { 55350 }, questID = { 57277 } }; --Muminah the Incandescent
	[157164] = { zoneID = 1527, artID = { 1343 }, x = 0.8, y = 0.576, overlay = { "0.8-0.57" }, displayID = 91321, zoneQuestId = { 55350 }, questID = { 57279 } }; --Zealot Tekem
	[157167] = { zoneID = 1527, artID = { 1343 }, x = 0.756, y = 0.52599996, overlay = { "0.75-0.51","0.75-0.52" }, displayID = 91322, zoneQuestId = { 56308,55350 }, questID = { 57280 } }; --Champion Sen-mat
	[157170] = { zoneID = 1527, artID = { 1343 }, x = 0.64599997, y = 0.258, overlay = { "0.64-0.25" }, displayID = 34738, zoneQuestId = { 55350 }, questID = { 57281 } }; --Acolyte Taspu
	[157188] = { zoneID = 1527, artID = { 1343 }, x = 0.84599996, y = 0.47, overlay = { "0.84-0.47" }, displayID = 85021, zoneQuestId = { 55350 }, questID = { 57285 } }; --The Tomb Widow
	[157390] = { zoneID = 1527, artID = { 1343 }, x = 0.552, y = 0.796, overlay = { "0.5-0.78","0.50-0.87","0.50-0.88","0.55-0.79" }, displayID = 92720, zoneQuestId = { 57157 }, questID = { 57434 } }; --R'oyolok the Reality Eater
	[157469] = { zoneID = 1527, artID = { 1343 }, x = 0.552, y = 0.792, overlay = { "0.5-0.78","0.50-0.87","0.54-0.79","0.55-0.79" }, displayID = 32501, zoneQuestId = { 57157 }, questID = { 57435 } }; --Zoth'rum the Intellect Pillager
	[157470] = { zoneID = 1527, artID = { 1343 }, x = 0.55, y = 0.794, overlay = { "0.5-0.78","0.50-0.87","0.50-0.88","0.54-0.79","0.55-0.79" }, displayID = 92716, zoneQuestId = { 57157 }, questID = { 57436 } }; --R'aas the Anima Devourer
	[157472] = { zoneID = 1527, artID = { 1343 }, x = 0.552, y = 0.792, overlay = { "0.5-0.78","0.50-0.87","0.50-0.88","0.54-0.79","0.55-0.79" }, displayID = 93173, zoneQuestId = { 57157 }, questID = { 57437 } }; --Aphrom the Guise of Madness
	[157473] = { zoneID = 1527, artID = { 1343 }, x = 0.552, y = 0.794, overlay = { "0.5-0.78","0.50-0.88","0.50-0.87","0.55-0.79" }, displayID = 88850, zoneQuestId = { 57157 }, questID = { 57438 } }; --Yiphrim the Will Ravager
	[157476] = { zoneID = 1527, artID = { 1343 }, x = 0.552, y = 0.796, overlay = { "0.5-0.78","0.50-0.87","0.50-0.78","0.50-0.88","0.54-0.79","0.55-0.79" }, displayID = 92610, zoneQuestId = { 57157 }, questID = { 57439 } }; --Shugshul the Flesh Gorger
	[157593] = { zoneID = 1527, artID = { 1343 }, x = 0.598, y = 0.726, overlay = { "0.59-0.72" }, displayID = 92609, zoneQuestId = { 57157 }, questID = { 57667 } }; --Amalgamation of Flesh
	[158491] = { zoneID = 1527, artID = { 1343 }, x = 0.532, y = 0.708, overlay = { "0.44-0.78","0.44-0.77","0.45-0.76","0.46-0.75","0.46-0.73","0.46-0.74","0.46-0.72","0.47-0.73","0.48-0.73","0.48-0.72","0.49-0.71","0.49-0.69","0.51-0.69","0.51-0.68","0.53-0.68","0.53-0.70" }, displayID = 92662, zoneQuestId = { 57157 }, questID = { 57662 } }; --Falconer Amenophis
	[158528] = { zoneID = 1527, artID = { 1343 }, x = 0.47599998, y = 0.77199996, overlay = { "0.47-0.77" }, displayID = 91296, zoneQuestId = { 57157 }, questID = { 57664 } }; --High Guard Reshef
	[158531] = { zoneID = 1527, artID = { 1343 }, x = 0.51, y = 0.714, overlay = { "0.47-0.78","0.47-0.80","0.49-0.82","0.5-0.78","0.5-0.81","0.50-0.78","0.50-0.74","0.50-0.83","0.50-0.85","0.50-0.81","0.50-0.82","0.50-0.86","0.50-0.73","0.50-0.76","0.51-0.71" }, displayID = 34807, zoneQuestId = { 57157 }, questID = { 57665 } }; --Corrupted Neferset Guard
	[158557] = { zoneID = 1527, artID = { 1343 }, x = 0.666, y = 0.742, overlay = { "0.66-0.73","0.66-0.74" }, displayID = 88705, zoneQuestId = { 57157 }, questID = { 57669 } }; --Actiss the Deceiver
	[158594] = { zoneID = 1527, artID = { 1343 }, x = 0.496, y = 0.382, overlay = { "0.49-0.38" }, displayID = 92752, zoneQuestId = { 57157 }, questID = { 57672 } }; --Doomsayer Vathiris
	[158595] = { zoneID = 1527, artID = { 1343 }, x = 0.598, y = 0.49400002, overlay = { "0.59-0.49" }, displayID = 89291, zoneQuestId = { 57157 }, questID = { 57673 } }; --Thoughtstealer Vos
	[158597] = { zoneID = 1527, artID = { 1343 }, x = 0.546, y = 0.432, overlay = { "0.54-0.43" }, displayID = 93552, zoneQuestId = { 57157 }, questID = { 57675 } }; --High Executor Yothrim
	[158632] = { zoneID = {
				[1527] = { x = 0.71800005, y = 0.77, overlay = { "0.43-0.28","0.44-0.28","0.44-0.30","0.45-0.26","0.45-0.30","0.46-0.39","0.46-0.34","0.46-0.43","0.46-0.29","0.46-0.31","0.46-0.33","0.46-0.35","0.46-0.40","0.46-0.42","0.46-0.45","0.46-0.41","0.46-0.36","0.46-0.38","0.47-0.36","0.47-0.39","0.47-0.42","0.47-0.28","0.47-0.30","0.47-0.32","0.47-0.44","0.47-0.27","0.47-0.43","0.47-0.29","0.47-0.37","0.47-0.4","0.47-0.41","0.48-0.30","0.48-0.34","0.48-0.43","0.48-0.27","0.48-0.35","0.48-0.45","0.48-0.26","0.48-0.32","0.48-0.28","0.48-0.36","0.49-0.33","0.49-0.41","0.49-0.27","0.49-0.35","0.49-0.42","0.5-0.42","0.5-0.44","0.5-0.45","0.50-0.28","0.50-0.29","0.50-0.30","0.50-0.35","0.50-0.46","0.50-0.27","0.50-0.43","0.50-0.47","0.50-0.44","0.51-0.45","0.51-0.46","0.51-0.51","0.51-0.30","0.51-0.49","0.51-0.32","0.51-0.48","0.51-0.5","0.51-0.50","0.52-0.34","0.52-0.31","0.52-0.30","0.52-0.35","0.53-0.33","0.53-0.50","0.53-0.31","0.53-0.48","0.53-0.51","0.53-0.32","0.53-0.34","0.54-0.47","0.54-0.22","0.54-0.46","0.54-0.49","0.54-0.5","0.54-0.52","0.54-0.53","0.55-0.24","0.55-0.31","0.55-0.34","0.55-0.49","0.55-0.51","0.55-0.20","0.55-0.22","0.55-0.23","0.55-0.26","0.55-0.27","0.55-0.28","0.55-0.29","0.55-0.48","0.55-0.32","0.56-0.29","0.56-0.53","0.56-0.54","0.56-0.18","0.56-0.33","0.56-0.34","0.56-0.17","0.56-0.32","0.56-0.35","0.56-0.28","0.56-0.52","0.57-0.31","0.57-0.51","0.57-0.53","0.57-0.29","0.57-0.44","0.57-0.56","0.57-0.57","0.57-0.73","0.57-0.80","0.57-0.21","0.57-0.22","0.57-0.32","0.57-0.46","0.57-0.72","0.57-0.74","0.57-0.78","0.57-0.83","0.57-0.13","0.57-0.30","0.57-0.54","0.57-0.76","0.57-0.20","0.57-0.85","0.58-0.26","0.58-0.54","0.58-0.58","0.58-0.61","0.58-0.82","0.58-0.21","0.58-0.24","0.58-0.46","0.58-0.64","0.58-0.65","0.58-0.68","0.58-0.70","0.58-0.71","0.58-0.74","0.58-0.77","0.58-0.81","0.58-0.18","0.58-0.19","0.58-0.22","0.58-0.40","0.58-0.47","0.58-0.48","0.58-0.49","0.58-0.56","0.58-0.59","0.58-0.66","0.58-0.78","0.58-0.80","0.58-0.84","0.58-0.41","0.58-0.42","0.58-0.57","0.58-0.69","0.58-0.7","0.58-0.72","0.58-0.75","0.58-0.76","0.58-0.79","0.58-0.44","0.58-0.51","0.58-0.60","0.59-0.17","0.59-0.26","0.59-0.51","0.59-0.63","0.59-0.74","0.59-0.21","0.59-0.29","0.59-0.44","0.59-0.81","0.59-0.32","0.59-0.33","0.59-0.36","0.59-0.39","0.59-0.48","0.59-0.49","0.59-0.53","0.59-0.54","0.59-0.45","0.59-0.85","0.59-0.31","0.59-0.34","0.59-0.47","0.59-0.50","0.6-0.53","0.6-0.82","0.60-0.29","0.60-0.31","0.60-0.36","0.60-0.37","0.60-0.41","0.60-0.51","0.60-0.78","0.60-0.35","0.60-0.39","0.60-0.42","0.60-0.56","0.60-0.58","0.60-0.80","0.60-0.33","0.60-0.49","0.60-0.52","0.60-0.54","0.60-0.60","0.60-0.77","0.60-0.79","0.60-0.85","0.60-0.40","0.61-0.36","0.61-0.40","0.61-0.76","0.61-0.83","0.61-0.14","0.61-0.35","0.61-0.50","0.61-0.41","0.61-0.15","0.61-0.34","0.61-0.78","0.61-0.37","0.61-0.8","0.62-0.77","0.62-0.80","0.62-0.38","0.62-0.37","0.62-0.39","0.62-0.79","0.62-0.81","0.63-0.41","0.63-0.81","0.63-0.77","0.63-0.64","0.63-0.65","0.63-0.78","0.64-0.64","0.64-0.66","0.64-0.8","0.64-0.77","0.64-0.67","0.64-0.65","0.65-0.65","0.65-0.69","0.65-0.77","0.65-0.79","0.65-0.76","0.65-0.67","0.65-0.73","0.65-0.68","0.65-0.75","0.66-0.75","0.66-0.66","0.66-0.69","0.66-0.78","0.66-0.72","0.66-0.74","0.67-0.69","0.67-0.77","0.67-0.78","0.67-0.70","0.67-0.72","0.67-0.75","0.67-0.73","0.67-0.71","0.67-0.76","0.68-0.75","0.68-0.69","0.68-0.71","0.68-0.77","0.68-0.70","0.68-0.74","0.69-0.76","0.69-0.71","0.69-0.73","0.70-0.76","0.70-0.75","0.70-0.78","0.70-0.74","0.70-0.77","0.71-0.75","0.71-0.76","0.71-0.77" } };
				[1530] = { x = 0.872, y = 0.432, overlay = { "0.4-0.39","0.4-0.40","0.40-0.4","0.41-0.45","0.41-0.39","0.41-0.40","0.41-0.38","0.42-0.41","0.42-0.45","0.42-0.42","0.42-0.40","0.43-0.37","0.43-0.42","0.43-0.43","0.43-0.46","0.43-0.38","0.43-0.40","0.43-0.41","0.43-0.44","0.43-0.47","0.44-0.38","0.44-0.47","0.44-0.39","0.44-0.41","0.44-0.45","0.45-0.36","0.45-0.39","0.45-0.43","0.45-0.40","0.45-0.42","0.45-0.45","0.45-0.41","0.46-0.38","0.46-0.47","0.46-0.37","0.46-0.40","0.46-0.39","0.46-0.41","0.47-0.4","0.47-0.41","0.47-0.36","0.47-0.37","0.47-0.46","0.47-0.40","0.49-0.37","0.53-0.43","0.53-0.39","0.54-0.39","0.54-0.40","0.55-0.40","0.55-0.42","0.55-0.41","0.56-0.43","0.56-0.42","0.56-0.59","0.57-0.31","0.57-0.43","0.57-0.58","0.57-0.41","0.57-0.59","0.57-0.27","0.57-0.42","0.57-0.56","0.57-0.57","0.58-0.27","0.58-0.40","0.58-0.59","0.58-0.60","0.58-0.61","0.59-0.31","0.59-0.57","0.59-0.59","0.59-0.60","0.59-0.6","0.59-0.27","0.59-0.62","0.6-0.28","0.6-0.32","0.6-0.56","0.60-0.29","0.60-0.35","0.60-0.42","0.60-0.58","0.60-0.31","0.60-0.34","0.60-0.57","0.60-0.59","0.60-0.28","0.60-0.33","0.60-0.54","0.60-0.60","0.61-0.32","0.61-0.34","0.61-0.43","0.61-0.55","0.61-0.56","0.61-0.60","0.61-0.28","0.61-0.61","0.62-0.32","0.62-0.57","0.62-0.58","0.62-0.59","0.62-0.28","0.63-0.35","0.63-0.34","0.63-0.28","0.63-0.59","0.63-0.57","0.64-0.34","0.64-0.48","0.64-0.5","0.64-0.61","0.64-0.44","0.64-0.51","0.64-0.49","0.64-0.54","0.65-0.28","0.65-0.22","0.65-0.44","0.65-0.45","0.65-0.46","0.65-0.53","0.65-0.54","0.65-0.26","0.65-0.33","0.65-0.27","0.65-0.56","0.65-0.39","0.65-0.48","0.65-0.52","0.66-0.32","0.66-0.34","0.66-0.44","0.66-0.47","0.66-0.48","0.66-0.26","0.66-0.39","0.66-0.22","0.66-0.35","0.66-0.45","0.66-0.54","0.66-0.25","0.66-0.27","0.66-0.53","0.66-0.23","0.66-0.37","0.66-0.55","0.67-0.27","0.67-0.29","0.67-0.34","0.67-0.24","0.67-0.30","0.67-0.35","0.67-0.47","0.67-0.53","0.67-0.23","0.67-0.33","0.67-0.37","0.67-0.46","0.67-0.36","0.67-0.32","0.67-0.44","0.68-0.24","0.68-0.3","0.68-0.30","0.68-0.25","0.68-0.29","0.68-0.33","0.68-0.26","0.68-0.27","0.68-0.28","0.68-0.45","0.68-0.32","0.68-0.42","0.68-0.46","0.69-0.21","0.69-0.44","0.69-0.45","0.69-0.23","0.69-0.24","0.69-0.31","0.69-0.32","0.69-0.46","0.69-0.47","0.69-0.25","0.69-0.22","0.69-0.30","0.69-0.28","0.7-0.24","0.7-0.46","0.7-0.47","0.70-0.26","0.70-0.27","0.70-0.31","0.70-0.47","0.70-0.48","0.71-0.47","0.71-0.27","0.71-0.25","0.71-0.46","0.72-0.46","0.73-0.27","0.74-0.28","0.76-0.51","0.76-0.49","0.77-0.45","0.77-0.50","0.77-0.47","0.78-0.53","0.78-0.45","0.78-0.5","0.78-0.51","0.78-0.52","0.78-0.54","0.79-0.46","0.79-0.43","0.79-0.45","0.79-0.48","0.79-0.50","0.79-0.51","0.79-0.52","0.79-0.54","0.79-0.55","0.79-0.49","0.8-0.45","0.8-0.49","0.8-0.54","0.80-0.45","0.80-0.42","0.80-0.43","0.80-0.47","0.80-0.48","0.80-0.44","0.80-0.49","0.81-0.46","0.81-0.52","0.81-0.41","0.81-0.44","0.81-0.50","0.81-0.53","0.81-0.48","0.81-0.51","0.81-0.54","0.81-0.49","0.82-0.51","0.82-0.50","0.82-0.44","0.82-0.52","0.83-0.46","0.83-0.47","0.83-0.49","0.84-0.45","0.84-0.47","0.84-0.48","0.84-0.50","0.84-0.52","0.84-0.46","0.84-0.51","0.85-0.50","0.85-0.51","0.86-0.5","0.87-0.43" } };
			  }, displayID = 92232, questID = { 58691 } }; --Corrupted Fleshbeast
	[158633] = { zoneID = 1527, artID = { 1343 }, x = 0.566, y = 0.536, overlay = { "0.53-0.50","0.54-0.51","0.54-0.5","0.54-0.50","0.54-0.49","0.55-0.53","0.55-0.50","0.55-0.51","0.55-0.52","0.55-0.54","0.56-0.53" }, displayID = 90719, zoneQuestId = { 57157 }, questID = { 57680 } }; --Gaze of N'Zoth
	[158636] = { zoneID = 1527, artID = { 1343 }, x = 0.496, y = 0.826, overlay = { "0.49-0.82" }, displayID = 93573, zoneQuestId = { 57157 }, questID = { 57688 } }; --The Grand Executor
	[159087] = { zoneID = {
				[1527] = { x = 0.85400003, y = 0.59400004, overlay = { "0.13-0.69","0.31-0.73","0.36-0.81","0.39-0.26","0.4-0.17","0.41-0.21","0.42-0.24","0.42-0.26","0.43-0.26","0.44-0.27","0.46-0.28","0.47-0.29","0.49-0.31","0.50-0.33","0.52-0.37","0.52-0.39","0.52-0.43","0.52-0.38","0.52-0.41","0.52-0.42","0.52-0.90","0.53-0.38","0.54-0.44","0.54-0.45","0.55-0.39","0.55-0.38","0.56-0.25","0.56-0.24","0.56-0.39","0.56-0.40","0.56-0.44","0.56-0.49","0.56-0.23","0.56-0.4","0.56-0.46","0.56-0.20","0.56-0.48","0.57-0.17","0.57-0.35","0.57-0.46","0.57-0.27","0.57-0.37","0.57-0.4","0.57-0.36","0.58-0.17","0.58-0.31","0.58-0.52","0.58-0.34","0.58-0.53","0.58-0.30","0.59-0.14","0.59-0.54","0.59-0.56","0.59-0.58","0.59-0.60","0.59-0.68","0.59-0.78","0.59-0.57","0.59-0.63","0.59-0.75","0.59-0.6","0.6-0.59","0.60-0.83","0.61-0.63","0.61-0.89","0.61-0.81","0.62-0.73","0.62-0.75","0.63-0.67","0.63-0.76","0.63-0.77","0.64-0.70","0.64-0.69","0.65-0.74","0.65-0.70","0.75-0.79","0.84-0.55","0.85-0.59" } };
				[1530] = { x = 0.916, y = 0.458, overlay = { "0.62-0.48","0.62-0.49","0.62-0.50","0.62-0.52","0.62-0.53","0.63-0.50","0.63-0.53","0.63-0.48","0.63-0.52","0.63-0.54","0.63-0.49","0.64-0.51","0.64-0.53","0.64-0.54","0.64-0.52","0.70-0.39","0.70-0.41","0.70-0.4","0.70-0.30","0.71-0.26","0.71-0.28","0.71-0.38","0.71-0.44","0.71-0.35","0.71-0.41","0.71-0.36","0.71-0.56","0.72-0.26","0.72-0.29","0.72-0.43","0.72-0.55","0.72-0.45","0.72-0.24","0.72-0.25","0.72-0.56","0.72-0.36","0.72-0.44","0.73-0.28","0.73-0.25","0.73-0.26","0.73-0.29","0.73-0.55","0.73-0.58","0.73-0.27","0.73-0.30","0.74-0.29","0.74-0.58","0.75-0.43","0.75-0.34","0.75-0.56","0.76-0.54","0.76-0.57","0.77-0.55","0.77-0.59","0.77-0.39","0.77-0.41","0.77-0.58","0.78-0.38","0.78-0.55","0.78-0.56","0.78-0.39","0.81-0.42","0.81-0.43","0.82-0.44","0.82-0.45","0.82-0.42","0.85-0.44","0.85-0.43","0.85-0.45","0.86-0.46","0.87-0.43","0.87-0.45","0.88-0.43","0.88-0.45","0.88-0.44","0.89-0.44","0.89-0.46","0.89-0.47","0.9-0.46","0.90-0.45","0.90-0.46","0.90-0.44","0.90-0.48","0.91-0.45" } };
			  }, displayID = 91925, questID = { 57834 } }; --Corrupted Bonestripper
	[160532] = { zoneID = 1527, artID = { 1343 }, x = 0.616, y = 0.746, overlay = { "0.60-0.74","0.61-0.74" }, displayID = 93954, zoneQuestId = { 57157,56308 }, questID = { 58169 } }; --Shoth the Darkened
	[160623] = { zoneID = 1527, artID = { 1343 }, x = 0.6, y = 0.396, overlay = { "0.59-0.39","0.6-0.39" }, displayID = 92231, zoneQuestId = { 57157 }, questID = { 58206 } }; --Hungering Miasma
	[160631] = { zoneID = 1527, artID = { 1343 }, x = 0.6, y = 0.396, overlay = { "0.6-0.39" }, displayID = 94300, zoneQuestId = { 55350 } }; --Hungering Miasma
	[160970] = { zoneID = 1527, artID = { 1343 }, x = 0.45599997, y = 0.16600001, overlay = { "0.45-0.16" }, displayID = 85193, weeklyReset = true, questID = { 58510 } }; --Vuk'laz the Earthbreaker
	[161033] = { zoneID = 1527, artID = { 1343 }, x = 0.578, y = 0.366, overlay = { "0.52-0.37","0.52-0.38","0.52-0.42","0.52-0.43","0.53-0.42","0.56-0.4","0.56-0.40","0.56-0.39","0.57-0.35","0.57-0.36" }, displayID = 91925, zoneQuestId = { 57157 }, questID = { 58333 } }; --Shadowmaw
	[162140] = { zoneID = 1527, artID = { 1343 }, x = 0.24, y = 0.622, overlay = { "0.23-0.62","0.24-0.62" }, displayID = 91809, zoneQuestId = { 56308 }, questID = { 58697 } }; --Skikx'traz
	[162141] = { zoneID = 1527, artID = { 1343 }, x = 0.408, y = 0.426, overlay = { "0.40-0.43","0.40-0.42" }, displayID = 91910, zoneQuestId = { 56308 }, questID = { 58695 } }; --Zuythiz
	[162142] = { zoneID = 1527, artID = { 1343 }, x = 0.376, y = 0.606, overlay = { "0.37-0.59","0.37-0.60" }, displayID = 92904, zoneQuestId = { 56308 }, questID = { 58693 } }; --Qho
	[162147] = { zoneID = 1527, artID = { 1343 }, x = 0.308, y = 0.496, overlay = { "0.30-0.49" }, displayID = 91811, zoneQuestId = { 56308 }, questID = { 58696 } }; --Corpse Eater
	[162163] = { zoneID = 1527, artID = { 1343 }, x = 0.478, y = 0.602, overlay = { "0.42-0.56","0.42-0.57","0.42-0.58","0.42-0.59","0.43-0.56","0.43-0.60","0.43-0.55","0.43-0.57","0.44-0.56","0.44-0.59","0.44-0.60","0.44-0.62","0.45-0.56","0.45-0.59","0.45-0.60","0.45-0.54","0.45-0.58","0.46-0.56","0.46-0.58","0.46-0.55","0.46-0.59","0.46-0.60","0.47-0.55","0.47-0.59","0.47-0.56","0.47-0.58","0.47-0.60" }, displayID = 92755, zoneQuestId = { 56308 }, questID = { 58701 } }; --High Priest Ytaessis
	[162170] = { zoneID = 1527, artID = { 1343 }, x = 0.336, y = 0.256, overlay = { "0.33-0.25" }, displayID = 93286, zoneQuestId = { 56308 }, questID = { 58702 } }; --Warcaster Xeshro
	[162171] = { zoneID = 1527, artID = { 1343 }, x = 0.45599997, y = 0.578, overlay = { "0.45-0.57" }, displayID = 22125, zoneQuestId = { 56308 }, questID = { 58699 } }; --Captain Dunewalker
	[162172] = { zoneID = 1527, artID = { 1343 }, x = 0.472, y = 0.58599997, overlay = { "0.21-0.64","0.22-0.62","0.23-0.63","0.23-0.59","0.24-0.59","0.24-0.63","0.29-0.64","0.30-0.51","0.30-0.65","0.30-0.67","0.30-0.68","0.31-0.66","0.31-0.67","0.32-0.3","0.32-0.31","0.32-0.60","0.32-0.63","0.32-0.67","0.33-0.2","0.33-0.66","0.33-0.65","0.33-0.68","0.33-0.63","0.34-0.20","0.34-0.26","0.34-0.63","0.34-0.17","0.34-0.68","0.34-0.31","0.35-0.16","0.35-0.18","0.35-0.17","0.35-0.31","0.36-0.47","0.37-0.14","0.38-0.45","0.39-0.45","0.39-0.38","0.39-0.37","0.39-0.40","0.4-0.39","0.4-0.41","0.4-0.44","0.40-0.36","0.40-0.4","0.40-0.44","0.40-0.43","0.41-0.41","0.41-0.4","0.41-0.38","0.41-0.42","0.42-0.41","0.42-0.40","0.43-0.37","0.45-0.59","0.46-0.57","0.46-0.58","0.47-0.58" }, displayID = 91909, zoneQuestId = { 57157,55350,56308 }, questID = { 58694 } }; --Aqir Warcaster
	[162173] = { zoneID = 1527, artID = { 1343 }, x = 0.378, y = 0.1, overlay = { "0.27-0.07","0.27-0.08","0.28-0.09","0.28-0.13","0.28-0.14","0.29-0.09","0.29-0.18","0.29-0.19","0.29-0.23","0.30-0.27","0.30-0.09","0.30-0.30","0.30-0.31","0.30-0.29","0.30-0.32","0.31-0.1","0.32-0.10","0.33-0.11","0.35-0.10","0.36-0.10","0.37-0.1" }, displayID = 90724, zoneQuestId = { 56308 }, questID = { 58864 } }; --R'krox the Runt
	[162196] = { zoneID = 1527, artID = { 1343 }, x = 0.35, y = 0.176, overlay = { "0.35-0.17" }, displayID = 92907, zoneQuestId = { 57157,55350,56308 }, questID = { 58681 } }; --Obsidian Annihilator
	[162352] = { zoneID = 1527, artID = { 1343 }, x = 0.5, y = 0.4, overlay = { "0.5-0.4" }, displayID = 35691, zoneQuestId = { 55350,56308 }, questID = { 58716 } }; --Spirit of Dark Ritualist Zakahn
	[162370] = { zoneID = 1527, artID = { 1343 }, x = 0.45599997, y = 0.428, overlay = { "0.43-0.41","0.44-0.44","0.44-0.42","0.44-0.40","0.44-0.41","0.44-0.43","0.45-0.42","0.45-0.41" }, displayID = 37353, zoneQuestId = { 55350,56308 }, questID = { 58718 } }; --Armagedillo
	[162372] = { zoneID = 1527, artID = { 1343 }, x = 0.71, y = 0.742, overlay = { "0.58-0.61","0.58-0.82","0.66-0.68","0.70-0.74","0.71-0.74" }, displayID = 36707, zoneQuestId = { 55350,56308 }, questID = { 58715 } }; --Spirit of Cyrus the Black
	[154087] = { zoneID = 1530, artID = { 1342 }, x = 0.71599996, y = 0.408, overlay = { "0.69-0.41","0.70-0.40","0.70-0.41","0.71-0.40" }, displayID = 91352, zoneQuestId = { 56064 }, questID = { 56084 } }; --Zror'um the Infinite
	[154106] = { zoneID = 1530, artID = { 1342 }, x = 0.9, y = 0.46, overlay = { "0.89-0.47","0.89-0.46","0.9-0.46" }, displayID = 51214, zoneQuestId = { 56064 }, questID = { 56094 } }; --Quid
	[154332] = { zoneID = 1530, artID = { 1342 }, x = 0.706, y = 0.286, overlay = { "0.63-0.28","0.64-0.28","0.65-0.27","0.65-0.26","0.65-0.28","0.65-0.30","0.65-0.25","0.66-0.27","0.66-0.29","0.66-0.26","0.66-0.30","0.66-0.31","0.66-0.28","0.67-0.25","0.67-0.26","0.67-0.31","0.67-0.3","0.67-0.28","0.67-0.29","0.67-0.32","0.68-0.30","0.68-0.25","0.68-0.26","0.69-0.28","0.69-0.25","0.69-0.31","0.69-0.26","0.69-0.3","0.7-0.31","0.70-0.27","0.70-0.28" }, displayID = 92065, zoneQuestId = { 56064 }, questID = { 56183 } }; --Voidtender Malketh
	[154394] = { zoneID = 1530, artID = { 1342 }, x = 0.86800003, y = 0.426, overlay = { "0.85-0.41","0.86-0.41","0.86-0.42" }, displayID = 94601, zoneQuestId = { 56064 }, questID = { 56213 } }; --Veskan the Fallen
	[154447] = { zoneID = 1530, artID = { 1342 }, x = 0.576, y = 0.41, overlay = { "0.56-0.41","0.57-0.40","0.57-0.41" }, displayID = 88700, zoneQuestId = { 56064 }, questID = { 56237 } }; --Brother Meller
	[154467] = { zoneID = 1530, artID = { 1342 }, x = 0.81, y = 0.64599997, overlay = { "0.80-0.63","0.81-0.64" }, displayID = 41335, zoneQuestId = { 56064 }, questID = { 56255 } }; --Chief Mek-mek
	[154490] = { zoneID = 1530, artID = { 1342 }, x = 0.644, y = 0.516, overlay = { "0.64-0.51" }, displayID = 91869, zoneQuestId = { 56064 }, questID = { 56302 } }; --Rijz'x the Devourer
	[154495] = { zoneID = 1530, artID = { 1342 }, x = 0.536, y = 0.626, overlay = { "0.52-0.61","0.52-0.62","0.53-0.62" }, displayID = 66204, zoneQuestId = { 56064 }, questID = { 56303 } }; --Will of N'Zoth
	[154559] = { zoneID = 1530, artID = { 1342 }, x = 0.7, y = 0.66800004, overlay = { "0.65-0.67","0.65-0.68","0.66-0.66","0.66-0.69","0.66-0.67","0.66-0.68","0.67-0.67","0.67-0.66","0.67-0.69","0.67-0.68","0.68-0.66","0.68-0.67","0.68-0.68","0.68-0.69","0.69-0.67","0.7-0.66" }, displayID = 90740, zoneQuestId = { 56064 }, questID = { 56323 } }; --Deeplord Zrihj
	[154600] = { zoneID = 1530, artID = { 1342 }, x = 0.47599998, y = 0.64199996, overlay = { "0.47-0.64" }, displayID = 44005, zoneQuestId = { 57008 }, questID = { 56332 } }; --Teng the Awakened
	[155958] = { zoneID = 1530, artID = { 1342 }, x = 0.308, y = 0.22399999, overlay = { "0.29-0.22","0.30-0.22" }, displayID = 94569, zoneQuestId = { 57008 }, questID = { 58507 } }; --Tashara
	[156083] = { zoneID = 1530, artID = { 1342 }, x = 0.47599998, y = 0.56, overlay = { "0.45-0.56","0.46-0.57","0.46-0.55","0.46-0.56","0.46-0.58","0.47-0.56","0.47-0.55" }, displayID = 38186, zoneQuestId = { 57008 }, questID = { 56954 } }; --Sanguifang
	[157153] = { zoneID = 1530, artID = { 1342 }, x = 0.368, y = 0.336, overlay = { "0.28-0.4","0.29-0.39","0.30-0.41","0.30-0.40","0.31-0.40","0.31-0.41","0.31-0.43","0.32-0.41","0.35-0.32","0.36-0.35","0.36-0.33" }, displayID = 58718, zoneQuestId = { 57008 }, questID = { 57344 } }; --Ha-Li
	[157160] = { zoneID = 1530, artID = { 1342 }, x = 0.138, y = 0.28, overlay = { "0.08-0.34","0.08-0.32","0.08-0.35","0.09-0.35","0.09-0.30","0.09-0.31","0.09-0.32","0.09-0.34","0.10-0.33","0.10-0.30","0.10-0.31","0.10-0.32","0.11-0.31","0.11-0.30","0.12-0.29","0.12-0.26","0.12-0.27","0.12-0.28","0.13-0.28" }, displayID = 92869, zoneQuestId = { 57008 }, questID = { 57345 } }; --Houndlord Ren
	[157162] = { zoneID = 1530, artID = { 1342 }, x = 0.22600001, y = 0.14, overlay = { "0.21-0.12","0.21-0.13","0.22-0.14" }, displayID = 40795, zoneQuestId = { 57008 }, questID = { 57346 } }; --Rei Lun
	[157171] = { zoneID = 1530, artID = { 1342 }, x = 0.288, y = 0.39400002, overlay = { "0.28-0.40","0.28-0.41","0.28-0.39" }, displayID = 86357, zoneQuestId = { 57008 }, questID = { 57347 } }; --Heixi the Stonelord
	[157176] = { zoneID = 1530, artID = { 1342 }, x = 0.52, y = 0.426, overlay = { "0.51-0.41","0.52-0.42" }, displayID = 92929, zoneQuestId = { 56064 }, questID = { 57342 } }; --The Forgotten
	[157183] = { zoneID = 1530, artID = { 1342 }, x = 0.21, y = 0.636, overlay = { "0.16-0.67","0.17-0.66","0.17-0.65","0.19-0.63","0.19-0.72","0.19-0.73","0.2-0.63","0.2-0.65","0.20-0.64","0.20-0.62","0.20-0.65","0.21-0.63" }, displayID = 47926, zoneQuestId = { 57008 }, questID = { 58296 } }; --Coagulated Anima
	[157266] = { zoneID = 1530, artID = { 1342 }, x = 0.506, y = 0.65599996, overlay = { "0.44-0.63","0.45-0.61","0.45-0.59","0.46-0.70","0.47-0.68","0.47-0.70","0.48-0.58","0.48-0.6","0.48-0.68","0.49-0.60","0.49-0.68","0.49-0.61","0.49-0.62","0.49-0.66","0.49-0.65","0.49-0.67","0.50-0.64","0.50-0.63","0.50-0.65" }, displayID = 92710, zoneQuestId = { 56064 }, questID = { 57341 } }; --Kilxl the Gaping Maw
	[157267] = { zoneID = 1530, artID = { 1342 }, x = 0.466, y = 0.438, overlay = { "0.44-0.44","0.44-0.40","0.44-0.46","0.44-0.45","0.45-0.39","0.45-0.45","0.45-0.44","0.45-0.46","0.45-0.47","0.45-0.40","0.45-0.42","0.45-0.43","0.45-0.41","0.46-0.38","0.46-0.43","0.46-0.47","0.46-0.37","0.46-0.39" }, displayID = 92609, zoneQuestId = { 56064 }, questID = { 57343 } }; --Escaped Mutation
	[157279] = { zoneID = 1530, artID = { 1342 }, x = 0.276, y = 0.736, overlay = { "0.23-0.76","0.23-0.77","0.24-0.76","0.25-0.76","0.25-0.75","0.26-0.73","0.26-0.74","0.27-0.73","0.27-0.74","0.27-0.71","0.27-0.72" }, displayID = 44449, zoneQuestId = { 57008 }, questID = { 57348 } }; --Stormhowl
	[157287] = { zoneID = 1530, artID = { 1342 }, x = 0.478, y = 0.53400004, overlay = { "0.36-0.60","0.37-0.58","0.37-0.60","0.37-0.62","0.37-0.59","0.37-0.61","0.38-0.56","0.38-0.55","0.38-0.60","0.38-0.59","0.38-0.63","0.38-0.61","0.39-0.56","0.39-0.57","0.39-0.62","0.39-0.59","0.39-0.58","0.39-0.60","0.39-0.63","0.39-0.64","0.39-0.65","0.39-0.67","0.4-0.54","0.40-0.56","0.40-0.61","0.40-0.65","0.40-0.57","0.40-0.62","0.40-0.54","0.40-0.63","0.41-0.57","0.41-0.58","0.41-0.61","0.41-0.62","0.41-0.52","0.41-0.55","0.41-0.56","0.41-0.6","0.42-0.54","0.42-0.56","0.42-0.59","0.42-0.62","0.42-0.53","0.42-0.55","0.42-0.61","0.42-0.57","0.42-0.60","0.43-0.53","0.43-0.54","0.43-0.55","0.43-0.52","0.43-0.57","0.44-0.49","0.44-0.5","0.44-0.51","0.44-0.53","0.44-0.55","0.44-0.52","0.44-0.54","0.45-0.5","0.45-0.52","0.45-0.51","0.45-0.54","0.45-0.50","0.45-0.56","0.46-0.50","0.46-0.53","0.46-0.56","0.47-0.49","0.47-0.51","0.47-0.52","0.47-0.55","0.47-0.53" }, displayID = 47527, zoneQuestId = { 57008 }, questID = { 57349 } }; --Dokani Obliterator
	[157290] = { zoneID = 1530, artID = { 1342 }, x = 0.274, y = 0.126, overlay = { "0.26-0.10","0.26-0.11","0.27-0.11","0.27-0.12" }, displayID = 45362, zoneQuestId = { 57008 }, questID = { 57350 } }; --Jade Watcher
	[157291] = { zoneID = 1530, artID = { 1342 }, x = 0.186, y = 0.376, overlay = { "0.17-0.38","0.17-0.37","0.18-0.37" }, displayID = 95242, zoneQuestId = { 57008 }, questID = { 57351 } }; --Spymaster Hul'ach
	[157443] = { zoneID = 1530, artID = { 1342 }, x = 0.536, y = 0.49, overlay = { "0.53-0.49" }, displayID = 41987, zoneQuestId = { 57008 }, questID = { 57358 } }; --Xiln the Mountain
	[157466] = { zoneID = 1530, artID = { 1342 }, x = 0.35, y = 0.686, overlay = { "0.33-0.67","0.33-0.68","0.34-0.68","0.34-0.67","0.35-0.68" }, displayID = 45835, zoneQuestId = { 57008 }, questID = { 57363 } }; --Anh-De the Loyal
	[157468] = { zoneID = 1530, artID = { 1342 }, x = 0.098000005, y = 0.674, overlay = { "0.09-0.67" }, displayID = 53161, zoneQuestId = { 56064,57728,57008 }, questID = { 57364 } }; --Tisiphon
	[160810] = { zoneID = 1530, artID = { 1342 }, x = 0.29799998, y = 0.536, overlay = { "0.28-0.52","0.29-0.51","0.29-0.52","0.29-0.53" }, displayID = 93279, zoneQuestId = { 57728 }, questID = { 58299 } }; --Harbinger Il'koxik
	[160825] = { zoneID = 1530, artID = { 1342 }, x = 0.198, y = 0.74, overlay = { "0.19-0.73","0.19-0.74" }, displayID = 93289, zoneQuestId = { 57728 }, questID = { 58300 } }; --Amber-Shaper Esh'ri
	[160826] = { zoneID = 1530, artID = { 1342 }, x = 0.21200001, y = 0.64599997, overlay = { "0.20-0.62","0.21-0.63","0.21-0.64" }, displayID = 93295, zoneQuestId = { 57728 }, questID = { 58301 } }; --Hive-Guard Naz'ruzek
	[160867] = { zoneID = 1530, artID = { 1342 }, x = 0.31, y = 0.39200002, overlay = { "0.19-0.37","0.20-0.39","0.20-0.40","0.20-0.38","0.21-0.38","0.21-0.4","0.21-0.36","0.21-0.37","0.21-0.40","0.22-0.35","0.22-0.38","0.22-0.44","0.22-0.36","0.22-0.37","0.22-0.42","0.22-0.43","0.23-0.34","0.23-0.38","0.23-0.36","0.23-0.37","0.23-0.39","0.23-0.40","0.23-0.44","0.23-0.33","0.23-0.4","0.24-0.36","0.24-0.43","0.24-0.40","0.24-0.41","0.24-0.34","0.24-0.38","0.24-0.42","0.24-0.46","0.25-0.34","0.25-0.39","0.25-0.4","0.25-0.43","0.25-0.45","0.25-0.33","0.25-0.36","0.25-0.35","0.26-0.40","0.26-0.42","0.26-0.35","0.26-0.39","0.26-0.44","0.26-0.46","0.26-0.43","0.27-0.34","0.27-0.48","0.27-0.36","0.27-0.41","0.27-0.45","0.27-0.33","0.27-0.37","0.27-0.39","0.27-0.4","0.27-0.42","0.27-0.43","0.28-0.37","0.28-0.44","0.28-0.45","0.28-0.33","0.28-0.41","0.28-0.35","0.28-0.36","0.28-0.40","0.28-0.34","0.29-0.44","0.29-0.42","0.29-0.45","0.29-0.35","0.29-0.37","0.3-0.34","0.30-0.38","0.30-0.35","0.31-0.39" }, displayID = 43351, zoneQuestId = { 57728 }, questID = { 58302 } }; --Kzit'kovok
	[160868] = { zoneID = 1530, artID = { 1342 }, x = 0.13, y = 0.516, overlay = { "0.13-0.51" }, displayID = 93282, zoneQuestId = { 57728 }, questID = { 58303 } }; --Harrier Nir'verash
	[160872] = { zoneID = 1530, artID = { 1342 }, x = 0.28, y = 0.694, overlay = { "0.09-0.31","0.09-0.30","0.09-0.33","0.10-0.29","0.10-0.30","0.10-0.31","0.10-0.34","0.11-0.29","0.11-0.39","0.11-0.28","0.11-0.31","0.11-0.32","0.11-0.27","0.11-0.34","0.12-0.30","0.12-0.31","0.12-0.34","0.12-0.35","0.12-0.37","0.12-0.38","0.12-0.28","0.12-0.32","0.12-0.36","0.12-0.41","0.13-0.27","0.13-0.31","0.13-0.34","0.13-0.38","0.13-0.29","0.13-0.35","0.13-0.37","0.13-0.40","0.13-0.33","0.14-0.28","0.14-0.32","0.14-0.33","0.14-0.38","0.14-0.36","0.14-0.37","0.14-0.39","0.14-0.34","0.14-0.4","0.14-0.40","0.15-0.37","0.15-0.36","0.15-0.38","0.16-0.35","0.16-0.40","0.16-0.34","0.16-0.39","0.16-0.38","0.16-0.41","0.17-0.35","0.17-0.37","0.17-0.34","0.17-0.39","0.17-0.46","0.17-0.33","0.17-0.41","0.18-0.34","0.18-0.38","0.18-0.48","0.18-0.37","0.18-0.40","0.18-0.45","0.18-0.35","0.18-0.44","0.19-0.40","0.19-0.42","0.19-0.43","0.19-0.49","0.2-0.50","0.20-0.44","0.20-0.46","0.20-0.48","0.20-0.51","0.20-0.41","0.20-0.43","0.20-0.45","0.20-0.47","0.21-0.41","0.21-0.43","0.21-0.42","0.21-0.39","0.21-0.44","0.22-0.41","0.22-0.42","0.22-0.44","0.22-0.46","0.22-0.65","0.22-0.49","0.22-0.66","0.23-0.39","0.23-0.44","0.23-0.45","0.23-0.67","0.23-0.65","0.23-0.64","0.23-0.66","0.23-0.68","0.23-0.40","0.23-0.69","0.24-0.63","0.24-0.64","0.24-0.66","0.24-0.44","0.24-0.46","0.24-0.47","0.25-0.61","0.25-0.63","0.25-0.66","0.25-0.69","0.25-0.64","0.25-0.65","0.25-0.67","0.25-0.71","0.26-0.67","0.26-0.68","0.26-0.69","0.26-0.65","0.26-0.66","0.27-0.63","0.27-0.67","0.27-0.68","0.27-0.66","0.28-0.69" }, displayID = 43654, zoneQuestId = { 57728 }, questID = { 58304 } }; --Destroyer Krox'tazar
	[160874] = { zoneID = 1530, artID = { 1342 }, x = 0.128, y = 0.41599998, overlay = { "0.10-0.40","0.10-0.41","0.10-0.38","0.11-0.39","0.11-0.40","0.12-0.40","0.12-0.41" }, displayID = 93271, zoneQuestId = { 57728 }, questID = { 58305 } }; --Drone Keeper Ak'thet
	[160876] = { zoneID = 1530, artID = { 1342 }, x = 0.126, y = 0.414, overlay = { "0.10-0.39","0.10-0.40","0.10-0.41","0.11-0.38","0.11-0.39","0.11-0.40","0.11-0.41","0.12-0.38","0.12-0.41" }, displayID = 35371, zoneQuestId = { 57728 }, questID = { 58306 } }; --Enraged Amber Elemental
	[160878] = { zoneID = 1530, artID = { 1342 }, x = 0.094, y = 0.706, overlay = { "0.06-0.67","0.06-0.68","0.06-0.69","0.06-0.70","0.06-0.71","0.07-0.70","0.09-0.70" }, displayID = 93300, zoneQuestId = { 57728 }, questID = { 58307 } }; --Buh'gzaki the Blasphemous
	[160893] = { zoneID = 1530, artID = { 1342 }, x = 0.088, y = 0.706, overlay = { "0.02-0.52","0.03-0.60","0.03-0.48","0.03-0.52","0.03-0.49","0.03-0.64","0.03-0.65","0.04-0.47","0.04-0.49","0.04-0.51","0.04-0.52","0.04-0.53","0.04-0.55","0.04-0.56","0.04-0.57","0.04-0.59","0.04-0.60","0.04-0.62","0.04-0.48","0.04-0.63","0.04-0.64","0.04-0.50","0.05-0.63","0.05-0.64","0.05-0.48","0.05-0.52","0.05-0.60","0.06-0.48","0.06-0.70","0.06-0.41","0.06-0.42","0.06-0.43","0.06-0.44","0.06-0.45","0.06-0.46","0.06-0.47","0.06-0.65","0.06-0.66","0.06-0.67","0.06-0.69","0.06-0.64","0.06-0.68","0.07-0.71","0.08-0.70" }, displayID = 93295, zoneQuestId = { 57728 }, questID = { 58308 } }; --Captain Vor'lek
	[160906] = { zoneID = 1530, artID = { 1342 }, x = 0.296, y = 0.47599998, overlay = { "0.22-0.47","0.22-0.48","0.23-0.45","0.23-0.46","0.23-0.47","0.23-0.48","0.24-0.43","0.24-0.47","0.24-0.44","0.24-0.46","0.24-0.48","0.25-0.44","0.25-0.46","0.25-0.48","0.25-0.49","0.25-0.45","0.25-0.40","0.25-0.5","0.26-0.47","0.26-0.50","0.26-0.44","0.26-0.49","0.26-0.41","0.26-0.43","0.26-0.5","0.26-0.51","0.26-0.52","0.26-0.45","0.26-0.48","0.27-0.43","0.27-0.45","0.27-0.39","0.27-0.44","0.27-0.42","0.27-0.48","0.28-0.44","0.28-0.46","0.28-0.48","0.28-0.49","0.28-0.45","0.29-0.46","0.29-0.47" }, displayID = 80032, zoneQuestId = { 57728 }, questID = { 58309 } }; --Skiver
	[160920] = { zoneID = 1530, artID = { 1342 }, x = 0.186, y = 0.106000006, overlay = { "0.17-0.09","0.17-0.08","0.18-0.09","0.18-0.10" }, displayID = 44400, zoneQuestId = { 57728 }, questID = { 58310 } }; --Kal'tik the Blight
	[160922] = { zoneID = 1530, artID = { 1342 }, x = 0.168, y = 0.38799998, overlay = { "0.13-0.32","0.13-0.33","0.13-0.34","0.13-0.35","0.14-0.31","0.14-0.32","0.14-0.37","0.15-0.38","0.16-0.38" }, displayID = 93302, zoneQuestId = { 57728 }, questID = { 58311 } }; --Needler Zhesalla
	[160930] = { zoneID = 1530, artID = { 1342 }, x = 0.19600001, y = 0.65599996, overlay = { "0.17-0.65","0.17-0.63","0.17-0.64","0.17-0.66","0.17-0.67","0.18-0.63","0.19-0.63","0.19-0.64","0.19-0.67","0.19-0.65" }, displayID = 33011, zoneQuestId = { 57728 }, questID = { 58312 } }; --Infused Amber Ooze
	[160968] = { zoneID = 1530, artID = { 1342 }, x = 0.176, y = 0.126, overlay = { "0.16-0.12","0.17-0.11","0.17-0.12" }, displayID = 94433, zoneQuestId = { 57008 }, questID = { 58295 } }; --Jade Colossus
	[161150] = { zoneID = 1530, artID = { 1342 }, x = 0.198, y = 0.744, overlay = { "0.19-0.73","0.19-0.74" }, displayID = 35371, questID = { 58300 } }; --Lesser Amber Elemental
	[163042] = { zoneID = 1530, artID = { 1342 }, x = 0.036, y = 0.618, overlay = { "0.03-0.61","0.03-0.63","0.04-0.60","0.04-0.63","0.04-0.58","0.04-0.59","0.05-0.56","0.05-0.54","0.06-0.54","0.06-0.51","0.06-0.52","0.06-0.53","0.06-0.50","0.07-0.49","0.07-0.65","0.07-0.47","0.08-0.64","0.08-0.46","0.09-0.65","0.09-0.44","0.10-0.65","0.11-0.66","0.12-0.68","0.12-0.69","0.13-0.71","0.14-0.28","0.14-0.26","0.14-0.27","0.15-0.24","0.15-0.73","0.16-0.22","0.20-0.7","0.21-0.68","0.22-0.18","0.23-0.64","0.23-0.58","0.24-0.63","0.24-0.18","0.24-0.59","0.25-0.55","0.25-0.62","0.25-0.60","0.26-0.55","0.26-0.58","0.26-0.57","0.27-0.52","0.27-0.54","0.27-0.55","0.28-0.49","0.28-0.51","0.28-0.52","0.28-0.57","0.28-0.17","0.28-0.55","0.29-0.55","0.29-0.58","0.30-0.55","0.31-0.45","0.32-0.17","0.37-0.17","0.38-0.42","0.39-0.42","0.40-0.20","0.41-0.21","0.41-0.59","0.43-0.68","0.44-0.22","0.46-0.67","0.47-0.66","0.48-0.66","0.48-0.22","0.48-0.23","0.50-0.23","0.51-0.63","0.54-0.18","0.58-0.21","0.59-0.59","0.60-0.24","0.62-0.59","0.63-0.29","0.70-0.56","0.72-0.34","0.75-0.37","0.77-0.56","0.78-0.39","0.80-0.56","0.80-0.46","0.81-0.54","0.81-0.49" }, friendly = { "A","H" }, displayID = 91729, questReset = true, nameplate = true }; --Ivory Cloud Serpent
	[156339] = { zoneID = 1533, artID = { 1321 }, x = 0.2271, y = 0.2288, overlay = { "0.22-0.22" }, displayID = 97749, questID = { 61634 } }; --Eliminator Sotiros
	[156340] = { zoneID = 1533, artID = { 1321 }, x = 0.2271, y = 0.2288, overlay = { "0.22-0.22" }, displayID = 97750, questID = { 61634 } }; --Larionrider Orstus
	[158659] = { zoneID = 1533, artID = { 1321 }, x = 0.42907804, y = 0.8265939, overlay = { "0.42-0.82","0.43-0.82" }, displayID = 92534, questID = { 57705 } }; --Herculon <Aspirant Assessor>
	[160629] = { zoneID = 1533, artID = { 1321 }, x = 0.5131854, y = 0.4076909, overlay = { "0.51-0.40" }, displayID = 97288, questID = { 58648 } }; --Baedos
	[160721] = { zoneID = 1533, artID = { 1321 }, x = 0.6058364, y = 0.7373352, overlay = { "0.60-0.73","0.6-0.73","0.60-0.74","0.60-0.72","0.59-0.73" }, displayID = 94310, questID = { 58222 } }; --Fallen Acolyte Erisne
	[160882] = { zoneID = 1533, artID = { 1321 }, x = 0.51065445, y = 0.6832439, overlay = { "0.51-0.68","0.51-0.67" }, displayID = 94421, questID = { 58319 } }; --Nikara Blackheart
	[160985] = { zoneID = 1533, artID = { 1321 }, x = 0.514, y = 0.684, overlay = { "0.51-0.68","0.52-0.68","0.61-0.50" }, displayID = 94437, questID = { 58320 } }; --Selena the Reborn
	[161527] = { zoneID = 1533, artID = { 1321 }, x = 0.55336857, y = 0.8028053, overlay = { "0.55-0.80" }, displayID = 94631, questID = { 60570 } }; --Sigilback
	[161528] = { zoneID = 1533, artID = { 1321 }, x = 0.5533336, y = 0.8029497, overlay = { "0.55-0.80" }, displayID = 94632, questID = { 58526 } }; --Aethon
	[161529] = { zoneID = 1533, artID = { 1321 }, x = 0.55323815, y = 0.80308104, overlay = { "0.55-0.80" }, displayID = 94634, questID = { 60569 } }; --Nemaeus
	[161530] = { zoneID = 1533, artID = { 1321 }, x = 0.5534226, y = 0.8027526, overlay = { "0.55-0.80","0.56-0.81" }, displayID = 94633, questID = { 60571 } }; --Cloudtail
	[161557] = { zoneID = 1533, artID = { 1321 }, x = 0.5533895, y = 0.8027858, overlay = { "0.55-0.80" }, questID = { 60571,60569,58526,60570 } }; --Generic Bunny
	[163460] = { zoneID = 1533, artID = { 1321 }, x = 0.4134825, y = 0.4888028, overlay = { "0.41-0.47","0.41-0.48","0.41-0.49" }, displayID = 95126, questID = { 62650 } }; --Dionae
	[167078] = { zoneID = 1533, artID = { 1321 }, x = 0.40622327, y = 0.5306163, overlay = { "0.40-0.52","0.40-0.53","0.41-0.52","0.41-0.54","0.41-0.55","0.40-0.51","0.41-0.53" }, displayID = 96395, questID = { 60314 } }; --Wingflayer the Cruel
	[170439] = { zoneID = 1533, artID = { 1321 }, x = 0.6094027, y = 0.791782, overlay = { "0.61-0.95","0.61-0.89","0.61-0.90","0.59-0.95","0.60-0.95","0.61-0.9","0.61-0.92","0.61-0.94","0.61-0.87","0.62-0.87","0.62-0.84","0.62-0.85","0.62-0.82","0.58-0.96","0.60-0.79","0.61-0.79","0.61-0.91","0.61-0.93","0.61-0.80","0.61-0.86","0.62-0.81","0.62-0.83","0.62-0.86","0.60-0.78","0.58-0.97","0.59-0.96","0.59-0.94","0.6-0.93","0.60-0.93","0.59-0.93","0.61-0.88" }, displayID = 94295 }; --Sundancer
	[170623] = { zoneID = 1533, artID = { 1321 }, x = 0.27825132, y = 0.30150113, overlay = { "0.27-0.30","0.27-0.3" }, displayID = 97349, questID = { 60883 } }; --Dark Watcher
	[170659] = { zoneID = 1533, artID = { 1321 }, x = 0.4829391, y = 0.530428, overlay = { "0.49-0.49","0.48-0.51","0.48-0.50","0.48-0.53" }, displayID = 93463, questID = { 60897 } }; --Basilofos, King of the Hill
	[170832] = { zoneID = 1533, artID = { 1321 }, x = 0.5349574, y = 0.8814117, overlay = { "0.53-0.88","0.32-0.17","0.53-0.84","0.53-0.87","0.54-0.86" }, displayID = 97392, questID = { 60933 } }; --Champion of Loyalty
	[170833] = { zoneID = 1533, artID = { 1321 }, x = 0.5349574, y = 0.8814117, overlay = { "0.53-0.88","0.39-0.20" }, displayID = 97393, questID = { 60933 } }; --Champion of Wisdom
	[170834] = { zoneID = 1533, artID = { 1321 }, x = 0.53461504, y = 0.87902945, overlay = { "0.53-0.88","0.64-0.69","0.53-0.87","0.52-0.86","0.54-0.86" }, displayID = 99355, questID = { 60933 } }; --Champion of Purity
	[170835] = { zoneID = 1533, artID = { 1321 }, x = 0.53461504, y = 0.87902945, overlay = { "0.53-0.88","0.53-0.87","0.33-0.59","0.54-0.87","0.54-0.86","0.54-0.80" }, displayID = 99353, questID = { 60933 } }; --Champion of Courage
	[170836] = { zoneID = 1533, artID = { 1321 }, x = 0.53461504, y = 0.87902945, overlay = { "0.53-0.88","0.53-0.87","0.54-0.87" }, displayID = 99354, questID = { 60933 } }; --Champion of Humility
	[170932] = { zoneID = 1533, artID = { 1321 }, x = 0.5076282, y = 0.5728171, overlay = { "0.49-0.59","0.50-0.59","0.50-0.58","0.49-0.58","0.49-0.56","0.5-0.59","0.50-0.57","0.51-0.58" }, displayID = 95116, questID = { 60978 } }; --Cloudfeather Guardian
	[171008] = { zoneID = 1533, artID = { 1321 }, x = 0.4348464, y = 0.25243407, overlay = { "0.43-0.25","0.43-0.24","0.42-0.24","0.43-0.26" }, displayID = 94277, questID = { 60997 } }; --Unstable Memory
	[171009] = { zoneID = 1533, artID = { 1321 }, x = 0.50631094, y = 0.18803789, overlay = { "0.50-0.19","0.51-0.16","0.50-0.18","0.51-0.17","0.52-0.18","0.50-0.17","0.50-0.20","0.51-0.18","0.51-0.19","0.52-0.16","0.52-0.17" }, displayID = 92664, questID = { 60998 } }; --Enforcer Aegeon
	[171011] = { zoneID = 1533, artID = { 1321 }, x = 0.37068382, y = 0.41907135, overlay = { "0.37-0.41","0.36-0.41","0.37-0.40","0.38-0.40","0.4-0.41","0.40-0.40","0.40-0.39","0.39-0.40","0.4-0.40","0.40-0.41","0.39-0.41" }, displayID = 96574, questID = { 61069 } }; --Demi the Relic Hoarder
	[171013] = { zoneID = 1533, artID = { 1321 }, x = 0.47991186, y = 0.4296499, overlay = { "0.63-0.35","0.48-0.42","0.47-0.42","0.55-0.14","0.59-0.52","0.48-0.43","0.47-0.44","0.48-0.41","0.52-0.32","0.54-0.15","0.55-0.15","0.59-0.51","0.63-0.36","0.44-0.47","0.46-0.42","0.47-0.41","0.47-0.43","0.55-0.12","0.55-0.13","0.56-0.14","0.59-0.50","0.59-0.53","0.6-0.52","0.45-0.44","0.46-0.43","0.47-0.4","0.48-0.44","0.48-0.45","0.51-0.33","0.62-0.38","0.64-0.36","0.64-0.35","0.46-0.45","0.47-0.39" }, displayID = 94225, questID = { 61001 } }; --Embodied Hunger
	[171014] = { zoneID = 1533, artID = { 1321 }, x = 0.66011477, y = 0.43675017, overlay = { "0.66-0.43" }, displayID = 94640 }; --Collector Astorestes
	[171040] = { zoneID = 1533, artID = { 1321 }, x = 0.47991186, y = 0.4296499, overlay = { "0.63-0.35","0.47-0.42","0.59-0.51","0.52-0.32","0.55-0.14","0.47-0.43","0.48-0.42","0.56-0.14","0.45-0.41","0.46-0.42","0.46-0.43","0.46-0.41","0.47-0.40","0.48-0.43","0.48-0.44","0.49-0.42","0.63-0.36","0.44-0.42","0.46-0.45","0.47-0.44","0.52-0.31","0.52-0.30","0.63-0.38","0.47-0.39" }, displayID = 94227, questID = { 61046 } }; --Xixin the Ravening
	[171041] = { zoneID = 1533, artID = { 1321 }, x = 0.47991186, y = 0.4296499, overlay = { "0.48-0.42","0.56-0.14","0.59-0.51","0.47-0.42","0.51-0.32","0.52-0.31","0.55-0.14","0.63-0.36","0.48-0.43","0.59-0.52","0.46-0.43","0.47-0.43","0.48-0.44","0.48-0.39","0.50-0.39","0.51-0.21","0.52-0.32","0.57-0.53","0.57-0.49","0.58-0.51","0.58-0.53","0.59-0.50","0.63-0.35","0.63-0.37","0.64-0.33","0.44-0.42","0.46-0.41","0.48-0.41","0.49-0.44","0.5-0.4","0.50-0.20","0.51-0.31","0.52-0.72","0.52-0.61","0.54-0.30","0.55-0.15","0.55-0.13","0.56-0.12","0.56-0.15","0.58-0.50","0.63-0.38","0.63-0.34","0.64-0.35","0.65-0.34","0.45-0.42","0.48-0.45","0.51-0.33","0.56-0.55","0.57-0.52","0.57-0.51","0.58-0.49","0.59-0.46" }, displayID = 94229, questID = { 61047 } }; --Worldfeaster Chronn
	[171189] = { zoneID = 1533, artID = { 1321 }, x = 0.5563951, y = 0.6324752, overlay = { "0.57-0.63","0.55-0.64","0.55-0.62","0.55-0.63","0.55-0.61","0.55-0.60","0.56-0.62","0.56-0.60","0.57-0.62","0.57-0.64","0.56-0.61","0.54-0.64","0.56-0.63" }, displayID = 92192, questID = { 59022 } }; --Bookkeeper Mnemis
	[171211] = { zoneID = 1533, artID = { 1321 }, x = 0.3259029, y = 0.23344253, overlay = { "0.32-0.23" }, displayID = 97513, questID = { 61083 } }; --Aspirant Eolis
	[171255] = { zoneID = 1533, artID = { 1321 }, x = 0.46213415, y = 0.6765708, overlay = { "0.46-0.63","0.45-0.68","0.45-0.65","0.44-0.65","0.44-0.64","0.45-0.67","0.46-0.64","0.46-0.66","0.47-0.66","0.47-0.65","0.45-0.64","0.45-0.66","0.47-0.64","0.46-0.67","0.44-0.68" }, displayID = 99373, questID = { 61082 } }; --Echo of Aella <Hand of Courage>
	[171300] = { zoneID = 1533, artID = { 1321 }, x = 0.56866336, y = 0.47669974, overlay = { "0.56-0.47" }, displayID = 92676, questID = { 60999 } }; --Malfunctioning Clawguard
	[171327] = { zoneID = 1533, artID = { 1321 }, x = 0.3164255, y = 0.55161184, overlay = { "0.31-0.55","0.3-0.55","0.30-0.55","0.29-0.54" }, displayID = 96773 }; --Reekmonger
	[176543] = { zoneID = 1533, artID = { 1321 }, x = 0.43494788, y = 0.25236973, overlay = { "0.43-0.25" }, questID = { 60997 } }; --Generic Bunny
	[356756] = { zoneID = 1533, artID = { 1321 }, x = 0.4163994, y = 0.54530585, overlay = { "0.41-0.54" } }; --Horn of Courage
	[157058] = { zoneID = 1536, artID = { 1323 }, x = 0.26386362, y = 0.26326233, overlay = { "0.26-0.26","0.26-0.27" }, displayID = 96437, questID = { 58335 } }; --Corspecutter Moroc
	[157125] = { zoneID = 1536, artID = { 1323 }, x = 0.28943902, y = 0.5131967, overlay = { "0.28-0.51","0.29-0.51" }, displayID = 94813, questID = { 59290 } }; --Zargox the Reborn
	[157294] = { zoneID = 1536, artID = { 1323 }, x = 0.58187515, y = 0.74249834, overlay = { "0.58-0.74" }, displayID = 85116, questID = { 61718 } }; --Pulsing Leech
	[157307] = { zoneID = 1536, artID = { 1323 }, x = 0.58207834, y = 0.7421619, overlay = { "0.58-0.74","0.58-0.72","0.58-0.73" }, displayID = 88651 }; --Gelloh
	[157308] = { zoneID = 1536, artID = { 1323 }, x = 0.58207834, y = 0.7421619, overlay = { "0.58-0.74" }, displayID = 100404, questID = { 61719 } }; --Corrupted Sediment
	[157309] = { zoneID = 1536, artID = { 1323 }, x = 0.58207834, y = 0.7421619, overlay = { "0.58-0.74","0.59-0.73" }, displayID = 48942 }; --Violet Mistake
	[157310] = { zoneID = 1536, artID = { 1323 }, x = 0.58207834, y = 0.7421619, overlay = { "0.58-0.74" }, displayID = 95844 }; --Boneslurp
	[157311] = { zoneID = 1536, artID = { 1323 }, x = 0.58207834, y = 0.7421619, overlay = { "0.58-0.74" }, displayID = 70785 }; --Burnblister
	[157312] = { zoneID = 1536, artID = { 1323 }, x = 0.5819174, y = 0.74228823, overlay = { "0.58-0.74","0.58-0.73","0.59-0.73" }, displayID = 96717, questID = { 61724 } }; --Oily Invertebrate
	[158406] = { zoneID = 1536, artID = { 1323 }, x = 0.6183857, y = 0.7593939, overlay = { "0.62-0.75","0.61-0.76","0.61-0.75" }, displayID = 93547, questID = { 58006 } }; --Scunner
	[159105] = { zoneID = 1536, artID = { 1323 }, x = 0.48753992, y = 0.23815544, overlay = { "0.49-0.22","0.48-0.23","0.49-0.23","0.48-0.24","0.49-0.24","0.50-0.25","0.46-0.24","0.47-0.24","0.48-0.25","0.48-0.22","0.49-0.19","0.49-0.21","0.5-0.21","0.5-0.24","0.50-0.24","0.50-0.26","0.50-0.22","0.51-0.27","0.50-0.23" }, displayID = 94041, questID = { 58005 } }; --Collector Kash
	[159753] = { zoneID = 1536, artID = { 1323 }, x = 0.53806174, y = 0.1928677, overlay = { "0.53-0.18","0.53-0.19","0.54-0.19","0.53-0.16","0.54-0.18","0.53-0.20","0.54-0.17","0.54-0.16","0.54-0.20","0.55-0.16","0.55-0.19" }, displayID = 92246, questID = { 58004 } }; --Ravenomous
	[159886] = { zoneID = 1536, artID = { 1323 }, x = 0.5545496, y = 0.23531534, overlay = { "0.55-0.23","0.55-0.24","0.55-0.22","0.54-0.22","0.54-0.21" }, displayID = 96755, questID = { 58003 } }; --Sister Chelicerae
	[160059] = { zoneID = 1536, artID = { 1323 }, x = 0.5055597, y = 0.20127194, overlay = { "0.50-0.20","0.49-0.20","0.50-0.19","0.50-0.2","0.51-0.2","0.50-0.18","0.50-0.22" }, displayID = 94146, questID = { 58091 } }; --Taskmaster Xox <Master Taskmaster>
	[161105] = { zoneID = 1536, artID = { 1323 }, x = 0.3875425, y = 0.42594925, overlay = { "0.38-0.42","0.38-0.43","0.39-0.43","0.37-0.43" }, displayID = 94450, questID = { 58332 } }; --Indomitable Schmitd
	[161857] = { zoneID = 1536, artID = { 1323 }, x = 0.5034132, y = 0.6330262, overlay = { "0.50-0.62","0.50-0.63","0.5-0.63","0.50-0.61","0.50-0.64" }, displayID = 96863, questID = { 58629 } }; --Nirvaska the Summoner
	[162180] = { zoneID = 1536, artID = { 1323 }, x = 0.2417045, y = 0.43033752, overlay = { "0.24-0.43","0.24-0.42" }, displayID = 95830, questID = { 58678 } }; --Thread Mistress Leeda
	[162528] = { zoneID = 1536, artID = { 1323 }, x = 0.4244468, y = 0.5348967, overlay = { "0.42-0.53","0.43-0.52","0.46-0.53","0.43-0.53","0.43-0.51","0.44-0.53","0.44-0.52","0.45-0.51","0.49-0.55" }, displayID = 98589, questID = { 58768 } }; --Smorgas the Feaster
	[162586] = { zoneID = 1536, artID = { 1323 }, x = 0.44072732, y = 0.5076287, overlay = { "0.44-0.50","0.43-0.51","0.44-0.52","0.44-0.51","0.45-0.52","0.43-0.50","0.45-0.51","0.43-0.52" }, displayID = 96462, questID = { 58783 } }; --Tahonta
	[162588] = { zoneID = 1536, artID = { 1323 }, x = 0.57392347, y = 0.510403, overlay = { "0.57-0.52","0.57-0.50","0.56-0.51","0.57-0.51","0.56-0.49","0.56-0.50" }, displayID = 94882, questID = { 58837 } }; --Gristlebeak
	[162669] = { zoneID = 1536, artID = { 1323 }, x = 0.45803404, y = 0.26997077, overlay = { "0.44-0.28","0.45-0.28","0.44-0.29","0.45-0.27","0.45-0.30","0.45-0.26","0.44-0.27","0.45-0.25","0.46-0.26","0.46-0.27","0.44-0.26","0.46-0.28" }, displayID = 96375, questID = { 58835 } }; --Devour'us
	[162690] = { zoneID = 1536, artID = { 1323 }, x = 0.6603312, y = 0.3532475, overlay = { "0.65-0.36","0.65-0.35","0.66-0.35","0.65-0.37","0.65-0.34","0.66-0.34","0.66-0.36","0.66-0.37","0.67-0.36","0.67-0.37" }, displayID = 94945, questID = { 58851 } }; --Nerissa Heartless
	[162711] = { zoneID = 1536, artID = { 1323 }, x = 0.7689662, y = 0.57107216, overlay = { "0.76-0.57","0.76-0.56" }, displayID = 83605, questID = { 58868 } }; --Deadly Dapperling
	[162727] = { zoneID = 1536, artID = { 1323 }, x = 0.5268869, y = 0.3559498, overlay = { "0.52-0.35","0.53-0.35","0.51-0.35","0.52-0.34","0.51-0.36","0.52-0.36","0.53-0.34" }, displayID = 48061, questID = { 58870 } }; --Bubbleblood
	[162741] = { zoneID = 1536, artID = { 1323 }, x = 0.31487226, y = 0.35398957, overlay = { "0.31-0.35" }, displayID = 97217, questID = { 58872 } }; --Gieger <Experimental Construct>
	[162767] = { zoneID = 1536, artID = { 1323 }, x = 0.53805745, y = 0.60984343, overlay = { "0.53-0.61","0.53-0.60","0.54-0.60" }, displayID = 34902, questID = { 58875 } }; --Pesticide
	[162797] = { zoneID = 1536, artID = { 1323 }, x = 0.46786094, y = 0.45552233, overlay = { "0.46-0.45","0.48-0.51","0.54-0.45","0.53-0.45","0.47-0.45","0.47-0.52","0.48-0.50","0.48-0.52" }, displayID = 96897, questID = { 58878 } }; --Deepscar <Pit Hound>
	[162818] = { zoneID = 1536, artID = { 1323 }, x = 0.3356494, y = 0.8072747, overlay = { "0.33-0.80","0.33-0.8","0.33-0.79" }, displayID = 96452 }; --Wartusk
	[162819] = { zoneID = 1536, artID = { 1323 }, x = 0.33555752, y = 0.8075535, overlay = { "0.33-0.80","0.33-0.79","0.34-0.79","0.33-0.82","0.33-0.77","0.33-0.78","0.33-0.8","0.34-0.78" }, displayID = 93242, questID = { 58889 } }; --Warbringer Mal'Korak
	[168147] = { zoneID = 1536, artID = { 1323 }, x = 0.504, y = 0.482, overlay = { "0.50-0.48","0.50-0.47","0.49-0.46","0.51-0.47" }, displayID = 98584, questID = { 58784 } }; --Sabriel the Bonecleaver
	[168148] = { zoneID = 1536, artID = { 1323 }, x = 0.50200003, y = 0.48400003, overlay = { "0.50-0.48","0.50-0.47","0.49-0.46","0.5-0.46","0.50-0.46" }, displayID = 99075, questID = { 58784 } }; --Drolkrad
	[170995] = { zoneID = 1536, artID = { 1323 }, x = 0.33400002, y = 0.81, overlay = { "0.33-0.81","0.33-0.80" }, displayID = 96452 }; --Warbringer Mal'korak
	[174108] = { zoneID = 1536, artID = { 1323 }, x = 0.7287974, y = 0.28918695, overlay = { "0.72-0.28","0.73-0.29" }, displayID = 97852, questID = { 62369 } }; --Necromantic Anomaly
	[154330] = { zoneID = 1543, artID = { 1329 }, x = 0.274, y = 0.494, overlay = { "0.27-0.49","0.19-0.46","0.2-0.45" }, displayID = 92779, questID = { 57509 } }; --Eternas the Tormentor
	[156203] = { zoneID = 1543, artID = { 1329 }, x = 0.37079144, y = 0.44630924, overlay = { "0.37-0.44","0.35-0.42","0.36-0.41","0.36-0.43","0.36-0.44","0.37-0.45","0.35-0.44","0.35-0.43","0.34-0.41","0.34-0.42","0.36-0.45" }, displayID = 38549, questID = { 63371 } }; --Stygian Incinerator
	[157833] = { zoneID = 1543, artID = { 1329 }, x = 0.39107066, y = 0.41156742, overlay = { "0.40-0.41","0.39-0.41","0.39-0.39","0.40-0.39","0.39-0.43","0.4-0.39","0.4-0.43","0.38-0.39","0.39-0.38","0.39-0.40","0.39-0.42","0.40-0.40","0.40-0.42","0.4-0.42","0.41-0.40","0.38-0.41" }, displayID = 97331, questID = { 57469 } }; --Borr-Geth
	[157964] = { zoneID = 1543, artID = { 1329 }, x = 0.25928944, y = 0.31159225, overlay = { "0.25-0.31","0.25-0.32" }, displayID = 96828, questID = { 57482 } }; --Adjutant Dekaris
	[158025] = { zoneID = 1543, artID = { 1329 }, x = 0.4899468, y = 0.8174491, overlay = { "0.48-0.81","0.47-0.81","0.48-0.80","0.48-0.78","0.47-0.82","0.47-0.80","0.48-0.82","0.48-0.83","0.48-0.79","0.48-0.8","0.49-0.81","0.49-0.84","0.49-0.82" }, displayID = 31119, questID = { 62282 } }; --Darklord Taraxis
	[158278] = { zoneID = 1543, artID = { 1329 }, x = 0.45489886, y = 0.7376865, overlay = { "0.46-0.72","0.46-0.74","0.45-0.73" }, displayID = 93213, questID = { 158278 } }; --Nascent Devourer
	[158314] = { zoneID = 1543, artID = { 1329 }, x = 0.31971738, y = 0.21237443, overlay = { "0.31-0.21","0.31-0.18","0.31-0.19","0.32-0.20","0.32-0.17","0.32-0.18","0.33-0.18","0.33-0.21","0.33-0.22","0.34-0.2","0.34-0.21","0.32-0.21","0.30-0.21","0.30-0.20","0.32-0.19","0.32-0.22","0.31-0.20" }, displayID = 97776, questID = { 59183 } }; --Drifting Sorrow
	[160770] = { zoneID = 1543, artID = { 1329 }, x = 0.612, y = 0.482, overlay = { "0.61-0.48" }, displayID = 97237, questID = { 62281 } }; --Darithis the Bleak
	[162452] = { zoneID = 1543, artID = { 1329 }, x = 0.25826964, y = 0.14800903, overlay = { "0.25-0.15","0.26-0.15","0.26-0.14","0.25-0.14","0.26-0.16" }, displayID = 92418, questID = { 59230 } }; --Dartanos <Flayer of Souls>
	[162829] = { zoneID = 1543, artID = { 1329 }, x = 0.2617715, y = 0.3744676, overlay = { "0.26-0.37","0.26-0.36","0.27-0.36","0.27-0.37","0.27-0.35" }, displayID = 92410, questID = { 63374 } }; --Razkazzar <Lord of Axes>
	[162844] = { zoneID = 1543, artID = { 1329 }, x = 0.18959875, y = 0.57968295, overlay = { "0.18-0.57","0.19-0.58","0.19-0.57","0.19-0.56" }, displayID = 100462, questID = { 61140 } }; --Dath Rezara <Lord of Blades>
	[162845] = { zoneID = 1543, artID = { 1329 }, x = 0.25359043, y = 0.4875919, overlay = { "0.25-0.48","0.25-0.47","0.26-0.48","0.25-0.46","0.25-0.49","0.26-0.46","0.26-0.47" }, displayID = 92410, questID = { 60991 } }; --Orrholyn <Lord of Bloodletting>
	[162849] = { zoneID = 1543, artID = { 1329 }, x = 0.1670942, y = 0.50617534, overlay = { "0.16-0.50","0.16-0.51","0.16-0.49","0.17-0.49","0.17-0.50" }, displayID = 92410, questID = { 60987 } }; --Morguliax <Lord of Decapitation>
	[162965] = { zoneID = 1543, artID = { 1329 }, x = 0.20803142, y = 0.29680428, overlay = { "0.20-0.29","0.21-0.29","0.21-0.30","0.21-0.28" }, displayID = 93213, questID = { 58918 } }; --Huwerath
	[164064] = { zoneID = 1543, artID = { 1329 }, x = 0.48796147, y = 0.18306938, overlay = { "0.48-0.17","0.48-0.18","0.47-0.18","0.47-0.17","0.49-0.17","0.49-0.16" }, displayID = 92781, questID = { 60667 } }; --Obolos <Prime Collector>
	[165047] = { zoneID = 1543, artID = { 1329 }, x = 0.36206466, y = 0.37340462, overlay = { "0.36-0.37","0.35-0.36","0.37-0.36","0.37-0.35","0.37-0.37","0.38-0.37","0.36-0.36" }, displayID = 92410, questID = { 59441 } }; --Soulsmith Yol-Mattar
	[166398] = { zoneID = 1543, artID = { 1329 }, x = 0.3598901, y = 0.4149425, overlay = { "0.34-0.39","0.34-0.41","0.35-0.43","0.35-0.42","0.35-0.41","0.36-0.41","0.35-0.40","0.36-0.39" }, displayID = 92416, questID = { 60834 } }; --Soulforger Rhovus
	[168693] = { zoneID = 1543, artID = { 1329 }, x = 0.29626676, y = 0.25553066, overlay = { "0.27-0.23","0.28-0.25","0.28-0.24","0.29-0.23","0.27-0.27","0.27-0.24","0.29-0.25","0.26-0.29","0.27-0.28","0.28-0.23","0.3-0.25","0.29-0.26" }, displayID = 94400, questID = { 61346 } }; --Cyrixia <The Willbreaker>
	[169102] = { zoneID = 1543, artID = { 1329 }, x = 0.28207123, y = 0.44510227, overlay = { "0.28-0.44","0.22-0.41","0.23-0.42","0.27-0.43","0.27-0.44","0.27-0.45","0.28-0.46" }, displayID = 97472, questID = { 61136 } }; --Agonix
	[169827] = { zoneID = 1543, artID = { 1329 }, x = 0.425, y = 0.212, overlay = { "0.42-0.21","0.42-0.20","0.42-0.19" }, displayID = 97235, questID = { 60666 } }; --Ekphoras, Herald of Grief
	[170301] = { zoneID = 1543, artID = { 1329 }, x = 0.19349606, y = 0.41762525, overlay = { "0.19-0.41","0.19-0.42" }, displayID = 97234, questID = { 60788 } }; --Apholeias, Herald of Loss
	[170302] = { zoneID = 1543, artID = { 1329 }, x = 0.28706488, y = 0.120400555, overlay = { "0.26-0.13","0.26-0.11","0.28-0.11","0.28-0.12","0.29-0.12" }, displayID = 97237, questID = { 60789 } }; --Talaporas, Herald of Pain
	[170303] = { zoneID = 1543, artID = { 1329 }, x = 0.205, y = 0.694, overlay = { "0.20-0.69","0.19-0.69","0.2-0.69","0.2-0.70","0.20-0.68","0.20-0.70","0.21-0.70","0.21-0.71","0.20-0.7" }, displayID = 97236, questID = { 62260 } }; --Exos, Herald of Domination
	[170634] = { zoneID = 1543, artID = { 1329 }, x = 0.32876346, y = 0.66408396, overlay = { "0.29-0.59","0.31-0.6","0.31-0.60","0.32-0.67","0.33-0.66","0.33-0.67","0.34-0.67","0.32-0.66","0.32-0.68" }, displayID = 92780, questID = { 170634 } }; --Shadeweaver Zeris
	[170692] = { zoneID = 1543, artID = { 1329 }, x = 0.3084571, y = 0.68669134, overlay = { "0.30-0.68","0.31-0.67","0.31-0.68","0.32-0.68" }, displayID = 94397, questID = { 60903 } }; --Krala <Death's Wings>
	[170711] = { zoneID = 1543, artID = { 1329 }, x = 0.28042084, y = 0.6062194, overlay = { "0.32-0.65","0.28-0.57","0.28-0.59","0.28-0.60" }, displayID = 97235, questID = { 60909 } }; --Dolos <Death's Knife>
	[170731] = { zoneID = 1543, artID = { 1329 }, x = 0.2738269, y = 0.71498764, overlay = { "0.27-0.71","0.25-0.69" }, displayID = 100037, questID = { 60914 } }; --Thanassos <Death's Voice>
	[170774] = { zoneID = 1543, artID = { 1329 }, x = 0.237524, y = 0.53412914, overlay = { "0.23-0.53","0.23-0.52","0.22-0.52" }, displayID = 96828, questID = { 60915 } }; --Eketra <The Impaler>
	[170787] = { zoneID = 1543, artID = { 1329 }, x = 0.34095797, y = 0.7452792, overlay = { "0.26-0.54","0.34-0.73","0.34-0.74" }, displayID = 100039, questID = { 60920 } }; --Akros <Death's Hammer>
	[171316] = { zoneID = 1543, artID = { 1329 }, x = 0.27344117, y = 0.17552327, overlay = { "0.27-0.17","0.26-0.18","0.27-0.18" }, displayID = 97472, questID = { 61125 } }; --Malevolent Stygia
	[171317] = { zoneID = 1543, artID = { 1329 }, x = 0.27725777, y = 0.13048199, overlay = { "0.26-0.12","0.27-0.13","0.28-0.13","0.28-0.14","0.26-0.13","0.27-0.10","0.27-0.12","0.27-0.14","0.28-0.15" }, displayID = 97472, questID = { 61106 } }; --Conjured Death
	[171783] = { zoneID = 1543, artID = { 1329 }, x = 0.404, y = 0.516, overlay = { "0.40-0.51","0.41-0.51","0.41-0.50","0.41-0.5" }, displayID = 97472 }; --Malevolent Death
	[172207] = { zoneID = 1543, artID = { 1329 }, x = 0.38642764, y = 0.28802338, overlay = { "0.38-0.29","0.38-0.28","0.43-0.46","0.43-0.47","0.43-0.48","0.44-0.49" }, displayID = 97235, questID = { 62618 } }; --Odalrik
	[172521] = { zoneID = 1543, artID = { 1329 }, x = 0.55628, y = 0.63193274, overlay = { "0.55-0.63","0.56-0.64" }, displayID = 96828, questID = { 62210 } }; --Sanngror the Torturer
	[172523] = { zoneID = 1543, artID = { 1329 }, x = 0.6045409, y = 0.64751595, overlay = { "0.6-0.65","0.59-0.63","0.60-0.64","0.59-0.65","0.59-0.64","0.60-0.65","0.6-0.64" }, displayID = 92416, questID = { 62209 } }; --Houndmaster Vasanok
	[172524] = { zoneID = 1543, artID = { 1329 }, x = 0.61724085, y = 0.7798308, overlay = { "0.61-0.78","0.61-0.79","0.61-0.77" }, displayID = 96556, questID = { 62211 } }; --Skittering Broodmother
	[172577] = { zoneID = 1543, artID = { 1329 }, x = 0.23691879, y = 0.21419168, overlay = { "0.23-0.21","0.23-0.22" }, displayID = 96312, questID = { 61519 } }; --Orophea
	[172629] = { zoneID = 1543, artID = { 1329 }, x = 0.5477689, y = 0.68623376, overlay = { "0.54-0.68" }, displayID = 92628, questReset = true, worldmap = true }; --Controller 01: Shadehounds
	[172631] = { zoneID = 1543, artID = { 1329 }, x = 0.5477689, y = 0.68623376, overlay = { "0.54-0.68" }, displayID = 97789, questReset = true, worldmap = true }; --Controller 02: Soul Eaters
	[172632] = { zoneID = 1543, artID = { 1329 }, x = 0.5477689, y = 0.68623376, overlay = { "0.54-0.68" }, displayID = 97343, questReset = true, worldmap = true }; --Controller 03: Death Elementals
	[172862] = { zoneID = 1543, artID = { 1329 }, x = 0.3743298, y = 0.6200337, overlay = { "0.37-0.62","0.37-0.65","0.38-0.62","0.37-0.60","0.37-0.66","0.37-0.61","0.39-0.60","0.39-0.58","0.38-0.61","0.36-0.61","0.36-0.62","0.37-0.59","0.37-0.58","0.38-0.58","0.38-0.63","0.38-0.60","0.39-0.59" }, displayID = 94426, questID = { 61568 } }; --Yero the Skittish
	[173086] = { zoneID = 1543, artID = { 1329 }, x = 0.40694788, y = 0.59629166, overlay = { "0.40-0.59","0.39-0.59","0.40-0.60","0.40-0.6" }, displayID = 97237, questID = { 61728 } }; --Valis the Cruel
	[175012] = { zoneID = 1543, artID = { 1329 }, x = 0.4172496, y = 0.5276582, overlay = { "0.38-0.51","0.29-0.49","0.36-0.52","0.31-0.48","0.33-0.49","0.36-0.50","0.42-0.51","0.26-0.51","0.30-0.46","0.31-0.46","0.33-0.47","0.33-0.48","0.34-0.48","0.39-0.50","0.42-0.52","0.44-0.51","0.30-0.48","0.25-0.5","0.25-0.49","0.27-0.49","0.28-0.46","0.28-0.48","0.29-0.47","0.33-0.45","0.35-0.49","0.35-0.52","0.36-0.49","0.36-0.5","0.39-0.65","0.39-0.67","0.39-0.66","0.39-0.49","0.40-0.50","0.41-0.51","0.42-0.50","0.43-0.52","0.43-0.50","0.43-0.51","0.44-0.52","0.45-0.53","0.45-0.54","0.25-0.59","0.23-0.54","0.29-0.48","0.28-0.68","0.30-0.47","0.32-0.48","0.41-0.63","0.39-0.51","0.44-0.53","0.43-0.56","0.41-0.52" }, displayID = 100033, questID = { 62788 } }; --Ikras the Devourer
	[175821] = { zoneID = 1543, artID = { 1329 }, x = 0.22676702, y = 0.4224243, overlay = { "0.22-0.42","0.21-0.42","0.21-0.41" }, displayID = 95169, questID = { 63044 } }; --Ratgusher <10,000 Mawrats in a Suit of Armor>
	[175846] = { zoneID = 1543, artID = { 1329 }, x = 0.162, y = 0.506, overlay = { "0.16-0.50","0.16-0.49","0.17-0.49","0.17-0.48","0.18-0.48","0.29-0.15","0.3-0.14","0.30-0.14","0.30-0.13","0.30-0.66","0.31-0.13","0.31-0.64","0.31-0.67","0.31-0.62","0.31-0.61" }, displayID = 96827, questReset = true, worldmap = true }; --Dathlane the Herald <Torghast Executioner>
	[175877] = { zoneID = 1543, artID = { 1329 }, x = 0.16, y = 0.506, overlay = { "0.16-0.50","0.16-0.49","0.17-0.49","0.18-0.48","0.19-0.48","0.19-0.47","0.28-0.15","0.29-0.14","0.29-0.15","0.3-0.14","0.30-0.14","0.30-0.13","0.30-0.66","0.31-0.65","0.31-0.66","0.31-0.62","0.31-0.63","0.31-0.64" }, displayID = 100045, questReset = true, worldmap = true }; --Lumisende <Torghast Executioner>
	[175881] = { zoneID = 1543, artID = { 1329 }, x = 0.162, y = 0.506, overlay = { "0.16-0.50","0.16-0.49","0.17-0.49","0.19-0.48","0.29-0.14","0.3-0.14","0.30-0.14","0.30-0.13","0.31-0.65","0.31-0.66","0.31-0.64","0.31-0.62" }, displayID = 96442, questReset = true, worldmap = true }; --Naelcrotix <Torghast Executioner>
	[175885] = { zoneID = 1543, artID = { 1329 }, x = 0.5477689, y = 0.68623376, overlay = { "0.54-0.68" }, questReset = true, worldmap = true }; --Controller 04: Flying Soul Eater
	[176141] = { zoneID = 1543, artID = { 1329 }, x = 0.546, y = 0.58, overlay = { "0.54-0.58" }, displayID = 100426 }; --Rakul <The Soul Ravager>
	[176173] = { zoneID = 1543, artID = { 1329 }, x = 0.22261684, y = 0.47913542, overlay = { "0.22-0.47","0.16-0.50","0.16-0.49","0.17-0.48","0.18-0.48","0.28-0.15","0.29-0.15","0.3-0.14","0.30-0.14","0.30-0.13","0.31-0.13","0.31-0.66","0.31-0.64","0.31-0.63","0.17-0.49","0.31-0.62","0.19-0.48" }, displayID = 97235, questReset = true, worldmap = true }; --Zograthos <Torghast Executioner>
	[160448] = { zoneID = 1565, artID = { 1338 }, x = 0.6745394, y = 0.5166407, overlay = { "0.67-0.51","0.67-0.52","0.67-0.50","0.66-0.52","0.64-0.51","0.66-0.51" }, displayID = 96274, questID = { 59221 } }; --Hunter Vivanna <The Wild Hunt>
	[161481] = { zoneID = 1565, artID = { 1338 }, x = 0.402, y = 0.53, overlay = { "0.40-0.53" }, displayID = 22174 }; --Vinyeti <Vignette Placeholder>
	[163229] = { zoneID = 1565, artID = { 1338 }, x = 0.48538068, y = 0.768936, overlay = { "0.48-0.75","0.48-0.76","0.49-0.76","0.48-0.77","0.47-0.75","0.49-0.75","0.49-0.77" }, displayID = 97941, questID = { 58987 } }; --Dustbrawl
	[163370] = { zoneID = 1565, artID = { 1338 }, x = 0.5360447, y = 0.75950134, overlay = { "0.53-0.75","0.53-0.76","0.53-0.77","0.54-0.74","0.54-0.75","0.54-0.76" }, displayID = 94201, questID = { 59006 } }; --Gormbore
	[164093] = { zoneID = 1565, artID = { 1338 }, x = 0.579386, y = 0.29407313, overlay = { "0.32-0.44","0.36-0.48","0.47-0.40","0.57-0.29","0.58-0.29" }, displayID = 70936 }; --Macabre
	[164107] = { zoneID = 1565, artID = { 1338 }, x = 0.2760201, y = 0.49077937, overlay = { "0.29-0.54","0.27-0.56","0.26-0.57","0.27-0.57","0.27-0.53","0.28-0.55","0.29-0.53","0.29-0.56","0.26-0.58","0.26-0.56","0.26-0.59","0.27-0.52","0.27-0.54","0.27-0.58","0.28-0.52","0.28-0.50","0.28-0.53","0.28-0.57","0.29-0.55","0.30-0.55","0.31-0.54","0.27-0.49" }, displayID = 41946, questID = { 59145 } }; --Gormtamer Tizo
	[164112] = { zoneID = 1565, artID = { 1338 }, x = 0.32424718, y = 0.30264962, overlay = { "0.31-0.30","0.32-0.30","0.32-0.3","0.32-0.29","0.32-0.31" }, displayID = 98601, questID = { 59157 } }; --Humon'gozz
	[164122] = { zoneID = 1565, artID = { 1338 }, x = 0.32424718, y = 0.30264962, overlay = { "0.32-0.30" }, displayID = 94288, questID = { 59157 } }; --Rapidly Growing Mushroom
	[164147] = { zoneID = 1565, artID = { 1338 }, x = 0.58342457, y = 0.61796236, overlay = { "0.58-0.61","0.57-0.61" }, displayID = 81163, questID = { 59170 } }; --Wrigglemortis
	[164179] = { zoneID = 1565, artID = { 1338 }, x = 0.5834244, y = 0.6179625, overlay = { "0.58-0.61" }, displayID = 95366, questID = { 59170 } }; --Wriggling Tendril
	[164238] = { zoneID = 1565, artID = { 1338 }, x = 0.468924, y = 0.2690341, overlay = { "0.46-0.21","0.46-0.22","0.46-0.24","0.46-0.25","0.46-0.26","0.47-0.27","0.47-0.21","0.47-0.28","0.48-0.27","0.48-0.21","0.49-0.22","0.49-0.25","0.49-0.23","0.49-0.24","0.46-0.23","0.48-0.26","0.48-0.22" }, displayID = 94195, questID = { 59201 } }; --Deifir the Untamed
	[164391] = { zoneID = 1565, artID = { 1338 }, x = 0.5140117, y = 0.58510417, overlay = { "0.51-0.57","0.51-0.58","0.50-0.57","0.52-0.58","0.48-0.54","0.49-0.56","0.50-0.58","0.52-0.57" }, displayID = 95115, questID = { 59208 } }; --Old Ardeite
	[164415] = { zoneID = 1565, artID = { 1338 }, x = 0.37739557, y = 0.5906426, overlay = { "0.37-0.59","0.37-0.60","0.37-0.6","0.36-0.60" }, displayID = 96776, questID = { 59220 } }; --Skuld Vit
	[164477] = { zoneID = 1565, artID = { 1338 }, x = 0.3463524, y = 0.679927, overlay = { "0.34-0.68","0.34-0.67" }, displayID = 96777, questID = { 59226 } }; --Deathbinder Hroth
	[164547] = { zoneID = 1565, artID = { 1338 }, x = 0.6303749, y = 0.35761765, overlay = { "0.49-0.20","0.5-0.20","0.62-0.36","0.64-0.34","0.65-0.32","0.65-0.30","0.65-0.28","0.38-0.44","0.38-0.45","0.39-0.47","0.45-0.42","0.52-0.33","0.53-0.29","0.53-0.44","0.53-0.34","0.54-0.28","0.55-0.28","0.55-0.34","0.56-0.33","0.57-0.35","0.59-0.36","0.60-0.37","0.61-0.36","0.63-0.37","0.63-0.36","0.64-0.35","0.64-0.33","0.65-0.33","0.37-0.37","0.37-0.39","0.37-0.41","0.38-0.42","0.38-0.43","0.38-0.37","0.40-0.38","0.42-0.39","0.42-0.50","0.42-0.4","0.44-0.51","0.44-0.40","0.44-0.5","0.44-0.49","0.45-0.49","0.47-0.45","0.48-0.45","0.49-0.45","0.50-0.45","0.52-0.29","0.53-0.33","0.54-0.27","0.55-0.3","0.55-0.41","0.55-0.27","0.55-0.31","0.56-0.32","0.56-0.34","0.58-0.36","0.59-0.37","0.63-0.35","0.65-0.31","0.65-0.29","0.38-0.38","0.38-0.46","0.39-0.38","0.39-0.48","0.40-0.49","0.40-0.48","0.41-0.50","0.45-0.43","0.46-0.43","0.52-0.30","0.53-0.31","0.53-0.32","0.53-0.43","0.54-0.43","0.54-0.42","0.55-0.30","0.55-0.29","0.56-0.40","0.58-0.38","0.58-0.37","0.60-0.36","0.64-0.32","0.66-0.27","0.42-0.51","0.43-0.49","0.51-0.45","0.53-0.28","0.56-0.35","0.57-0.39","0.65-0.3","0.43-0.51","0.54-0.34","0.55-0.32" }, displayID = 93787, questID = { 59235 } }; --Mystic Rainbowhorn
	[165053] = { zoneID = 1565, artID = { 1338 }, x = 0.61288303, y = 0.2560361, overlay = { "0.61-0.25","0.62-0.24","0.61-0.24" }, displayID = 95696, questID = { 59431 } }; --Mymaen
	[166135] = { zoneID = 1565, artID = { 1338 }, x = 0.41280442, y = 0.44340083, overlay = { "0.41-0.44","0.41-0.45" }, displayID = 94474, questID = { 61201 } }; --Astra, As Azshara <An Infamous Queen>
	[166138] = { zoneID = 1565, artID = { 1338 }, x = 0.41280442, y = 0.44340083, overlay = { "0.41-0.44" }, displayID = 99719, questID = { 61202 } }; --Mi'kai, As Argus, the Unmaker <A Corrupted World Soul>
	[166139] = { zoneID = 1565, artID = { 1338 }, x = 0.415, y = 0.4482, overlay = { "0.41-0.44" }, displayID = 99664, questID = { 61203 } }; --Glimmerdust, As Kil'jaeden <of The Burning Legion>
	[166140] = { zoneID = 1565, artID = { 1338 }, x = 0.41280442, y = 0.44340083, overlay = { "0.41-0.44" }, displayID = 95055, questID = { 61204 } }; --Senthii, As Gul'dan <From an Alternate Timeline>
	[166142] = { zoneID = 1565, artID = { 1338 }, x = 0.41280442, y = 0.44340083, overlay = { "0.41-0.44" }, displayID = 99664, questID = { 61205 } }; --Glimmerdust, As Jaina <A Magic Ice Princess>
	[166145] = { zoneID = 1565, artID = { 1338 }, x = 0.41280442, y = 0.44340083, overlay = { "0.41-0.44","0.40-0.43","0.41-0.45","0.41-0.47","0.42-0.45" }, displayID = 94430, questID = { 61206 } }; --Dreamweaver, As N'Zoth <An Eldritch Abomination>
	[166146] = { zoneID = 1565, artID = { 1338 }, x = 0.41280442, y = 0.44340083, overlay = { "0.41-0.44" }, displayID = 95232, questID = { 61207 } }; --Niya, As Xavius <Some Kind of Evil Sylvar>
	[167721] = { zoneID = 1565, artID = { 1338 }, x = 0.59442234, y = 0.46656504, overlay = { "0.59-0.46" }, displayID = 95201, questID = { 60290 } }; --The Slumbering Emperor
	[167724] = { zoneID = 1565, artID = { 1338 }, x = 0.6572125, y = 0.24042606, overlay = { "0.65-0.24","0.65-0.22" }, displayID = 19530, questID = { 60258 } }; --Rotbriar Boggart
	[167726] = { zoneID = 1565, artID = { 1338 }, x = 0.65053564, y = 0.44336516, overlay = { "0.64-0.44","0.65-0.44","0.63-0.42","0.64-0.41","0.64-0.40","0.64-0.42","0.64-0.43" }, displayID = 55772, questID = { 60273 } }; --Rootwrithe
	[167851] = { zoneID = 1565, artID = { 1338 }, x = 0.5785902, y = 0.29538903, overlay = { "0.58-0.29","0.57-0.29" }, displayID = 94204, questID = { 60266 } }; --Egg-Tender Leh'go
	[167916] = { zoneID = 1565, artID = { 1338 }, x = 0.6508152, y = 0.44263986, overlay = { "0.65-0.44" } }; --Flor durmiente
	[167928] = { zoneID = 1565, artID = { 1338 }, x = 0.6500024, y = 0.44328418, overlay = { "0.65-0.44" }, questID = { 60273 } }; --Dormant Blossom
	[167929] = { zoneID = 1565, artID = { 1338 }, x = 0.650025, y = 0.44238627, overlay = { "0.65-0.44" }, questID = { 60273 } }; --Dormant Blossom
	[168053] = { zoneID = 1565, artID = { 1338 }, x = 0.5944361, y = 0.4666357, overlay = { "0.59-0.46" }, questID = { 60290 } }; --Sleepy Bunny
	[168135] = { zoneID = 1565, artID = { 1338 }, x = 0.6202847, y = 0.5085544, overlay = { "0.62-0.53","0.62-0.50","0.58-0.49","0.59-0.56","0.59-0.49","0.6-0.49","0.60-0.48","0.60-0.56","0.60-0.5","0.60-0.57","0.61-0.49","0.61-0.50","0.61-0.56","0.61-0.55","0.62-0.55","0.62-0.51","0.62-0.52","0.62-0.54","0.63-0.51","0.62-0.56","0.6-0.56" }, displayID = 94297 }; --Night Mare
	[168647] = { zoneID = 1565, artID = { 1338 }, x = 0.30590025, y = 0.5499304, overlay = { "0.30-0.55","0.30-0.54","0.29-0.56","0.29-0.55","0.3-0.55","0.31-0.53","0.27-0.54","0.27-0.56","0.27-0.59","0.28-0.56","0.28-0.58","0.28-0.55","0.29-0.60","0.31-0.54","0.32-0.53","0.32-0.54","0.32-0.55","0.33-0.55","0.33-0.56","0.34-0.50","0.34-0.53","0.35-0.51","0.37-0.51" }, displayID = 96087, questID = { 61632 } }; --Valfir the Unrelenting
	[171451] = { zoneID = 1565, artID = { 1338 }, x = 0.72435015, y = 0.5175118, overlay = { "0.72-0.51" }, displayID = 96776, questID = { 61177 } }; --Soultwister Cero
	[171688] = { zoneID = 1565, artID = { 1338 }, x = 0.68556076, y = 0.2786728, overlay = { "0.68-0.28","0.68-0.27" }, displayID = 86207, questID = { 61184 } }; --Faeflayer
	[171690] = { zoneID = 1565, artID = { 1338 }, x = 0.6566082, y = 0.25297427, overlay = { "0.65-0.25" }, displayID = 97756, questID = { 60258 } }; --Gwynceirw
	[156451] = { zoneID = 1570, artID = { 1363 }, x = 0.91379154, y = 0.65222836, displayID = 92744 }; --Darkspeaker Thul'grsh
	[159103] = { zoneID = 1570, artID = { 1363 }, x = 0.8701674, y = 0.59488, displayID = 90739 }; --Manipulator Shrog'lth
	[159318] = { zoneID = 1570, artID = { 1363 }, x = 0.8176807, y = 0.5552708, displayID = 93172 }; --Shadow-Walker Yash'gth
	[160126] = { zoneID = 1570, artID = { 1363 }, x = 0.9107797, y = 0.65257007, displayID = 90739 }; --Manipulator Yggshoth
	[160127] = { zoneID = 1570, artID = { 1363 }, x = 0.8772523, y = 0.682464, displayID = 92744 }; --Darkspeaker Shath'gul
	[160805] = { zoneID = 1570, artID = { 1363 }, x = 0.8785557, y = 0.639712, displayID = 92229 }; --Gloopy Globule
	[160841] = { zoneID = 1570, artID = { 1363 }, x = 0.87837493, y = 0.68816483, displayID = 92229 }; --Blubbery Blobule
	[161139] = { zoneID = 1571, artID = { 1364 }, x = 0.5512126, y = 0.3465163, overlay = { "0.55-0.34" }, displayID = 93720 }; --Acolyte of N'Zoth
	[161451] = { zoneID = 1571, artID = { 1364 }, x = 0.566, y = 0.338, overlay = { "0.55-0.33","0.56-0.33" }, displayID = 90739 }; --Manipulator Yar'shath
	[161463] = { zoneID = 1571, artID = { 1364 }, x = 0.554, y = 0.36400002, overlay = { "0.55-0.36" }, displayID = 94554 }; --Depthcaller Velshen
	[161467] = { zoneID = 1571, artID = { 1364 }, x = 0.566, y = 0.33, overlay = { "0.56-0.33" }, displayID = 94556 }; --Portalkeeper Jin'tashal
	[161683] = { zoneID = 1571, artID = { 1364 }, x = 0.58599997, y = 0.318, overlay = { "0.53-0.33","0.54-0.31","0.54-0.32","0.54-0.34","0.54-0.35","0.55-0.35","0.55-0.34","0.56-0.31","0.56-0.34","0.57-0.31","0.57-0.33","0.57-0.32","0.58-0.31" }, displayID = 93954 }; --Antak'shal
	[152508] = { zoneID = {
				[1618] = { x = 0.49733055, y = 0.60849226, artID = { 1375 }, overlay = { "0.49-0.60" } };
				[1784] = { x = 0.45146632, y = 0.5663026, artID = { 1494 }, overlay = { "0.45-0.56" } };
			  }, displayID = 100490 }; --Dusky Tremorbeast
	[173051] = { zoneID = {
				[1618] = { x = 0.51627135, y = 0.635631, artID = { 1375 }, overlay = { "0.51-0.63" } };
				[1805] = { x = 0.7916551, y = 0.49468654, artID = { 1514 }, overlay = { "0.79-0.49" } };
			  }, displayID = 97235 }; --Suppressor Xelors
	[155483] = { zoneID = 1619, artID = { 1376 }, x = 0.6273219, y = 0.4030078, overlay = { "0.62-0.40" }, displayID = 95199 }; --Faeleaf Shimmerwing
	[173191] = { zoneID = 1623, artID = { 1379 }, x = 0.39413923, y = 0.32205677, overlay = { "0.39-0.32" }, displayID = 92415 }; --Soulstalker V'lara
	[156134] = { zoneID = 1632, artID = { 1383 }, x = 0.5175, y = 0.3653, overlay = { "0.51-0.36" }, displayID = 97041 }; --Ghastly Charger
	[165786] = { zoneID = 1644, artID = { 1398 }, x = 0.826, y = 0.36, overlay = { "0.82-0.36","0.84-0.35" }, displayID = 97721 }; --High Inquisitor Vetar
	[171705] = { zoneID = 1644, artID = { 1398 }, x = 0.36400002, y = 0.382, overlay = { "0.36-0.38","0.32-0.39","0.32-0.38","0.33-0.38","0.33-0.39","0.34-0.38","0.35-0.38","0.35-0.37","0.36-0.37","0.36-0.36","0.37-0.38","0.38-0.34","0.38-0.35","0.42-0.32","0.30-0.32","0.31-0.30","0.32-0.40","0.32-0.33","0.33-0.37","0.34-0.34","0.34-0.35","0.34-0.40","0.34-0.36","0.35-0.35","0.37-0.36","0.37-0.35","0.38-0.37","0.38-0.33","0.38-0.36","0.39-0.37","0.39-0.39","0.39-0.38","0.39-0.35","0.4-0.38","0.40-0.34","0.40-0.35","0.40-0.31","0.40-0.32","0.40-0.40","0.40-0.33","0.41-0.39","0.41-0.36","0.41-0.31","0.41-0.37","0.41-0.38","0.41-0.35","0.41-0.32","0.42-0.34","0.42-0.35","0.43-0.39","0.43-0.31","0.43-0.36","0.43-0.29","0.43-0.44","0.44-0.41","0.37-0.37","0.40-0.37","0.41-0.30","0.42-0.31","0.43-0.28","0.44-0.37","0.40-0.3" }, displayID = 97758 }; --Court Crusher
	[171731] = { zoneID = 1644, artID = { 1398 }, x = 0.708, y = 0.52, overlay = { "0.70-0.52","0.71-0.50" }, displayID = 94529 }; --Sineater
	[171749] = { zoneID = 1644, artID = { 1398 }, x = 0.77199996, y = 0.366, overlay = { "0.77-0.36","0.83-0.35" }, displayID = 97769 }; --Sloppy
	[172164] = { zoneID = 1644, artID = { 1398 }, x = 0.44599998, y = 0.324, overlay = { "0.44-0.32","0.40-0.32","0.40-0.31","0.41-0.31","0.41-0.33","0.42-0.31","0.42-0.30","0.42-0.28","0.43-0.32","0.43-0.31","0.43-0.34","0.43-0.38","0.44-0.33","0.44-0.36","0.44-0.40","0.44-0.29","0.44-0.43","0.44-0.38","0.44-0.26","0.45-0.32","0.45-0.35","0.45-0.43","0.45-0.30","0.45-0.33","0.45-0.36","0.45-0.4","0.45-0.41","0.45-0.37","0.45-0.44","0.45-0.45","0.45-0.39","0.45-0.42","0.45-0.51","0.46-0.32","0.46-0.46","0.46-0.49","0.46-0.31","0.46-0.3","0.47-0.29","0.47-0.31","0.47-0.47","0.47-0.30","0.47-0.32","0.47-0.44","0.48-0.29","0.48-0.43","0.48-0.45","0.48-0.47","0.48-0.28","0.49-0.30","0.49-0.26","0.49-0.27","0.49-0.38","0.5-0.29","0.50-0.30","0.50-0.39","0.50-0.48","0.51-0.48","0.52-0.28","0.52-0.29","0.52-0.31","0.52-0.46","0.53-0.32","0.53-0.33","0.53-0.34","0.53-0.27","0.53-0.46","0.54-0.35","0.54-0.31","0.54-0.34","0.54-0.39","0.54-0.46","0.54-0.30","0.54-0.33","0.55-0.36","0.55-0.39","0.55-0.35","0.55-0.43","0.55-0.41","0.55-0.42","0.55-0.37","0.56-0.35","0.56-0.39","0.56-0.38","0.57-0.36","0.40-0.30","0.42-0.26","0.42-0.35","0.43-0.29","0.43-0.33","0.43-0.28","0.43-0.27","0.43-0.35","0.44-0.34","0.44-0.39","0.44-0.42","0.45-0.47","0.45-0.29","0.46-0.34","0.47-0.43","0.47-0.49","0.49-0.47","0.49-0.31","0.49-0.48","0.49-0.50","0.51-0.3","0.51-0.25","0.51-0.52","0.52-0.27","0.53-0.30","0.53-0.45","0.54-0.44","0.56-0.36","0.56-0.37","0.56-0.42","0.41-0.35","0.42-0.32","0.42-0.36","0.43-0.37","0.43-0.39","0.44-0.31","0.45-0.53","0.45-0.38","0.45-0.31","0.50-0.26","0.51-0.31","0.52-0.32","0.53-0.31","0.55-0.38" }, displayID = 82239 }; --Ember Skyterror
	[172180] = { zoneID = 1644, artID = { 1398 }, x = 0.488, y = 0.626, overlay = { "0.48-0.62","0.39-0.69","0.39-0.63","0.40-0.71","0.43-0.64","0.44-0.63","0.44-0.62","0.44-0.69","0.45-0.61","0.45-0.63","0.45-0.64","0.45-0.65","0.45-0.62","0.46-0.62","0.46-0.64","0.46-0.63","0.46-0.61","0.47-0.62","0.47-0.63","0.47-0.61","0.47-0.64","0.48-0.61","0.48-0.63","0.49-0.62","0.49-0.60","0.50-0.61","0.50-0.62","0.51-0.62","0.51-0.64","0.51-0.61","0.41-0.63","0.43-0.62","0.44-0.68","0.45-0.66","0.46-0.65","0.47-0.60","0.48-0.64","0.49-0.61","0.53-0.64","0.53-0.61","0.43-0.63" }, displayID = 95785 }; --Blustery Boil
	[172182] = { zoneID = 1644, artID = { 1398 }, x = 0.33400002, y = 0.308, overlay = { "0.33-0.30","0.34-0.34","0.35-0.36","0.36-0.36","0.37-0.34","0.37-0.32","0.37-0.33","0.37-0.35","0.38-0.34","0.38-0.37","0.38-0.33","0.38-0.35","0.39-0.34","0.39-0.36","0.39-0.35","0.42-0.32","0.32-0.38","0.34-0.35","0.35-0.37","0.37-0.37","0.37-0.36","0.40-0.32","0.43-0.38","0.38-0.36","0.39-0.37","0.40-0.33","0.43-0.46" }, displayID = 97879 }; --Venthyr Provocateur
	[172186] = { zoneID = 1644, artID = { 1398 }, x = 0.428, y = 0.34, overlay = { "0.42-0.34","0.43-0.35","0.41-0.31","0.42-0.35","0.43-0.34","0.43-0.32","0.43-0.33","0.44-0.33","0.42-0.32","0.43-0.37","0.43-0.36","0.44-0.38","0.44-0.35","0.44-0.40","0.44-0.37","0.45-0.40","0.45-0.44","0.45-0.33","0.50-0.29","0.51-0.31","0.53-0.32" }, displayID = 97444 }; --Knockerbock <"Premier" Party Supplies>
	[156142] = { zoneID = 1751, artID = { 1464 }, x = 0.59994113, y = 0.74144906, overlay = { "0.60-0.73","0.59-0.74" }, displayID = 98720 }; --Seeker of Souls
	[170385] = { zoneID = 1776, artID = { 1486 }, x = 0.49783915, y = 0.3332342, overlay = { "0.49-0.33" }, displayID = 94278 }; --Writhing Misery
	[152517] = { zoneID = 1780, artID = { 1490 }, x = 0.6205417, y = 0.49242198, overlay = { "0.62-0.49" }, displayID = 90427 }; --Deadsoul Lifetaker
	[169823] = { zoneID = 1780, artID = { 1490 }, x = 0.6196178, y = 0.5126988, overlay = { "0.61-0.51" }, displayID = 94207 }; --Gorm Behemoth
	[152612] = { zoneID = 1782, artID = { 1492 }, x = 0.4739313, y = 0.36637175, overlay = { "0.47-0.36" }, displayID = 100485 }; --Subjugator Klontzas
	[170417] = { zoneID = 1798, artID = { 1507 }, x = 0.36009884, y = 0.5341363, overlay = { "0.36-0.53" }, displayID = 88739 }; --Animated Stygia
	[173134] = { zoneID = 1798, artID = { 1507 }, x = 0.3386, y = 0.4752, overlay = { "0.33-0.47" }, displayID = 92664 }; --Darksworn Goliath
	[170414] = { zoneID = 1802, artID = { 1511 }, x = 0.6142491, y = 0.5478275, overlay = { "0.61-0.54" }, displayID = 88583 }; --Howling Spectre
	[152500] = { zoneID = 1806, artID = { 1521 }, x = 0.55725074, y = 0.8000362, overlay = { "0.55-0.80" }, displayID = 97777 }; --Deadsoul Amalgam
	[173080] = { zoneID = 1806, artID = { 1521 }, x = 0.5610496, y = 0.81930625, overlay = { "0.56-0.81" }, displayID = 96338 }; --Wandering Death
	[173238] = { zoneID = 1806, artID = { 1521 }, x = 0.56176734, y = 0.8404454, overlay = { "0.56-0.84" }, displayID = 98490 }; --Deadsoul Strider
	[170228] = { zoneID = 1811, artID = { 1519 }, x = 0.60168165, y = 0.6838672, overlay = { "0.60-0.68" }, displayID = 94814 }; --Bone Husk
	[173114] = { zoneID = 1811, artID = { 1519 }, x = 0.5587324, y = 0.7167461, overlay = { "0.55-0.71" }, displayID = 18722 }; --Invasive Decayfly
	[173136] = { zoneID = 1811, artID = { 1519 }, x = 0.5703057, y = 0.70572066, overlay = { "0.57-0.70" }, displayID = 98171 }; --Blightsmasher
	[156158] = { zoneID = 1913, artID = { 1485 }, x = 0.6292875, y = 0.51344234, overlay = { "0.62-0.51" }, displayID = 93906 }; --Adjutant Felipos
}
