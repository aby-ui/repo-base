
local _, LunarFestival = ...
local points = LunarFestival.points
-- points[<mapfile>] = { [<coordinates>] = { <quest ID>, <achievement ID>, <achievement criteria ID>, <is in dungeon>}, }


----------------------
-- Eastern Kingdoms --
----------------------
points[242] = { -- "BlackrockDepths"
	[50536287] = { 8619, 910, 5 }, -- Elder Morndeep
}

points[33] = { -- "BlackrockMountain"
	[40173941] = { 8619, 910, 5 }, -- Elder Morndeep
	[80324027] = { 8644, 910, 4 }, -- Elder Stonefort
}

points[35] = { -- "BlackrockMountain"
	[38841820] = { 8619, 910, 5 }, -- Elder Morndeep
}

points[252] = { -- "BlackrockSpire"
	[61814000] = { 8644, 910, 4 }, -- Elder Stonefort
}

points[17] = { -- "BlastedLands"
	[54284949] = { 8647, 912, 2 }, -- Elder Bellowrage
}

points[36] = { -- "BurningSteppes"
	[70114539] = { 8636, 912, 9 }, -- Elder Rumblerock
	[52382394] = { 8683, 912, 10 }, -- Elder Dawnstrider
	[27592544] = { 8644, 910, 4, true }, -- Elder Stonefort in Lower Blackrock Spire
	[18452526] = { 8619, 910, 5, true }, -- Elder Morndeep in Blackrock Depths
}

points[27] = { -- "DunMorogh"
	[62962194] = { 8866, 915, 2 }, -- Elder Bronzebeard
	[53914991] = { 8653, 912, 1 }, -- Elder Goldwell
}

points[23] = { -- "EasternPlaguelands"
	[35586881] = { 8688, 912, 15 }, -- Elder Windrun
	[75735456] = { 8650, 912, 16 }, -- Elder Snowcrown
	[27091252] = { 8727, 910, 6, true }, -- Elder Farwhisper in Stratholme
}

points[37] = { -- "Elwynn"
	[34565026] = { 8646, 915, 3 }, -- Elder Hammershout
	[39796367] = { 8649, 912, 3 }, -- Elder Stormbrow
}

points[26] = { -- "Hinterlands"
	[50004804] = { 8643, 912, 11 }, -- Elder Highpeak
}

points[87] = { -- "Ironforge"
	[29331715] = { 8866, 915, 2 }, -- Elder Bronzebeard
}

points[48] = { -- "LochModan"
	[33324654] = { 8642, 912, 7 }, -- Elder Silvervein
}

points[32] = { -- "SearingGorge"
	[21307911] = { 8651, 912, 12 }, -- Elder Ironband
}

points[21] = { -- "Silverpine"
	[44984114] = { 8645, 912, 14 }, -- Elder Obsidian
}

points[50] = { -- "StranglethornJungle"
	[71043430] = { 8716, 912, 5 }, -- Elder Starglade
}

points[317] = { -- "Stratholme"
	[78622215] = { 8727, 910, 6 }, -- Elder Farwhisper
}

points[51] = { -- "SwampOfSorrows"
	[69665348] = { 8713, 910, 2, true }, -- Elder Starsong in Sunken Temple
}

points[210] = { -- "TheCapeOfStranglethorn"
	[39957250] = { 8674, 912, 6 }, -- Elder Winterhoof
}

points[220] = { -- "TheTempleOfAtalHakkar"
	[62913448] = { 8713, 910, 2 }, -- Elder Starsong
}

points[18] = { -- "Tirisfal"
	[61957317] = { 8648, 914, 3 }, -- Elder Darkcore
	[61865391] = { 8652, 912, 13 }, -- Elder Graveborn
}

points[90] = { -- "Undercity"
	[66633821] = { 8648, 914, 3 }, -- Elder Darkcore
}

points[22] = { -- "WesternPlaguelands"
	[63513612] = { 8722, 912, 4 }, -- Elder Meadowrun
	[69187345] = { 8714, 912, 17 }, -- Elder Moonstrike
}

points[52] = { -- "Westfall"
	[56654709] = { 8675, 912, 8 }, -- Elder Skychaser
}


--------------
-- Kalimdor --
--------------
points[63] = { -- "Ashenvale"
	[35544891] = { 8725, 911, 9 }, -- Elder Riversong
}

points[76] = { -- "Aszhara"
	[64737934] = { 8720, 911, 2 }, -- Elder Skygleam
}

points[10] = { -- "Barrens"
	[48525927] = { 8717, 911, 3 }, -- Elder Moonwarden
	[68366996] = { 8680, 911, 5 }, -- Elder Windtotem
}

points[62] = { -- "Darkshore"
	[49541894] = { 8721, 911, 7 }, -- Elder Starweave
}

points[89] = { -- "Darnassus"
	[39213185] = { 8718, 915, 1 }, -- Elder Bladeswift
}

points[66] = { -- "Desolace"
	[29106255] = { 8635, 910, 3, true }, -- Elder Splitrock in Maraudon
}

points[68] = { -- "Desolace"
	[44637652] = { 8635, 910, 3, true }, -- Elder Splitrock in Maraudon
}

points[1] = { -- "Durotar"
	[46390050] = { 8677, 914, 1 }, -- Elder Darkhorn
	[53224361] = { 8670, 911, 1 }, -- Elder Runetotem
}

points[69] = { -- "Feralas"
	[76713789] = { 8679, 911, 10 }, -- Elder Grimtotem
	[62563107] = { 8685, 911, 11 }, -- Elder Mistwalker
}

points[77] = { -- "Felwood"
	[38355285] = { 8723, 911, 12 }, -- Elder Nightwind
}

points[281] = { -- "Maraudon"
	[51479373] = { 8635, 910, 3 }, -- Elder Splitrock
}

points[7] = { -- "Mulgore"
	[44942323] = { 8678, 914, 2 }, -- Elder Wheathoof
	[48505324] = { 8673, 911, 8 }, -- Elder Bloodhoof
}

points[85] = { -- "Orgrimmar"
	[52256001] = { 8677, 914, 1 }, -- Elder Darkhorn
}

points[81] = { -- "Silithus"
	[30811332] = { 8654, 911, 20 }, -- Elder Primestone
	[53023548] = { 8719, 911, 21 }, -- Elder Bladesing
}

points[199] = { -- "SouthernBarrens"
	[41594745] = { 8686, 911, 4 }, -- Elder Highmountain
}

points[71] = { -- "Tanaris"
	[37247906] = { 8671, 911, 15 }, -- Elder Ragetotem
	[51402881] = { 8684, 911, 16 }, -- Elder Dreamseer
	[39212126] = { 8676, 910, 1, true }, -- Elder Wildmane in Zul'Farrak
}

points[57] = { -- "Teldrassil"
	[28114367] = { 8718, 915, 1 }, -- Elder Bladeswift
	[56855311] = { 8715, 911, 6 }, -- Elder Bladeleaf
}

points[64] = { -- "ThousandNeedles"
	[46345101] = { 8682, 911, 13 }, -- Elder Skyseer
	[77097561] = { 8724, 911, 14 }, -- Elder Morningdew
}

points[88] = { -- "ThunderBluff"
	[72982338] = { 8678, 914, 2 }, -- Elder Wheathoof
}

points[78] = { -- "UngoroCrater"
	[50377616] = { 8681, 911, 17 }, -- Elder Thunderhorn
}

points[83] = { -- "Winterspring"
	[53235675] = { 8726, 911, 18 }, -- Elder Brightspear
	[59964994] = { 8672, 911, 19 }, -- Elder Stonespire
}

points[219] = { -- "ZulFarrak"
	[34503934] = { 8676, 910, 1 }, -- Elder Wildmane
}


---------------
-- Northrend --
---------------
points[157] = { -- "AzjolNerub"
	[21774356] = { 13022, 910, 9 }, -- Elder Nurgen
}

points[114] = { -- "BoreanTundra"
	[27502598] = { 13021, 910, 8, true }, -- Elder Igasho in The Nexus
	[59096563] = { 13012, 1396, 1 }, -- Elder Sardis
	[57394373] = { 13033, 1396, 5 }, -- Elder Arp
	[33803436] = { 13016, 1396, 6 }, -- Elder Northal
	[42934958] = { 13029, 1396, 15 }, -- Elder Pamuya
}

points[115] = { -- "Dragonblight"
	[25945089] = { 13022, 910, 9, true }, -- Elder Nurgen in Azjol-Nerub
	[29755590] = { 13014, 1396, 3 }, -- Elder Morthie
	[48767818] = { 13019, 1396, 12 }, -- Elder Thoim
	[35104835] = { 13031, 1396, 17 }, -- Elder Skywarden
}

points[160] = { -- "DrakTharonKeep"
	[68887912] = { 13023, 910, 10 }, -- Elder Kilias
}

points[116] = { -- "GrizzlyHills"
	[60572768] = { 13013, 1396, 2 }, -- Elder Beldak
	[80523712] = { 13025, 1396, 9 }, -- Elder Lunaro
	[64164700] = { 13030, 1396, 16 }, -- Elder Whurain
}

points[154] = { -- "Gundrak"
	[45676153] = { 13065, 910, 11 }, -- Elder Ohanzee
}

points[117] = { -- "HowlingFjord"
	[57994998] = { 13017, 910, 7, true }, -- Elder Jarten in Utgarde Keep
	[57264668] = { 13067, 910, 13, true }, -- Elder Chogan'gada in Utgarde Pinnacle
}

points[123] = { -- "LakeWintergrasp"
	[49021393] = { 13026, 1396, 10 }, -- Elder Bluewolf
}

points[119] = { -- "SholazarBasin"
	[49786362] = { 13018, 1396, 7 }, -- Elder Sandrene
	[63804902] = { 13024, 1396, 8 }, -- Elder Wanikaya
}

points[129] = { -- "TheNexus"
	[55206471] = { 13021, 910, 8 }, -- Elder Igasho
}

points[120] = { -- "TheStormPeaks"
	[39582691] = { 13066, 910, 12, true }, -- Elder Yurauk in Halls of Stone
	[28897371] = { 13015, 1396, 4 }, -- Elder Fargal
	[41168473] = { 13028, 1396, 13 }, -- Elder Graymane
	[31273762] = { 13020, 1396, 14 }, -- Elder Stonebeard
	[64595134] = { 13032, 1396, 18 }, -- Elder Muraco
}

points[140] = { -- "Ulduar77", Halls of Stone
	[29376205] = { 13066, 910, 12 }, -- Elder Yurauk
}

points[133] = { -- "UtgardeKeep"
	[47426963] = { 13017, 910, 7 }, -- Elder Jarten
}

points[136] = { -- "UtgardePinnacle"
	[48772298] = { 13067, 910, 13 }, -- Elder Chogan'gada
}

points[121] = { -- "ZulDrak"
	[28528694] = { 13023, 910, 10, true }, -- Elder Kilias in Drak'Tharon Keep
	[76162102] = { 13065, 910, 11, true }, -- Elder Ohanzee in Gundrak
	[58915597] = { 13027, 1396, 11 }, -- Elder Tauros
}


---------------
-- Cataclysm --
---------------
points[207] = { -- "Deepholm"
	[49705488] = { 29735, 6006, 1 }, -- Elder Stonebrand
	[27706918] = { 29734, 6006, 9 }, -- Elder Deepforge
}

points[198] = { -- "Hyjal"
	[26696205] = { 29739, 6006, 6 }, -- Elder Windsong
	[62542282] = { 29740, 6006, 7 }, -- Elder Evershade
}

points[241] = { -- "TwilightHighlands"
	[50917045] = { 29737, 6006, 4 }, -- Elder Firebeard
	[51883306] = { 29736, 6006, 5 }, -- Elder Darkfeather
}

points[249] = { -- "Uldum"
	[65521867] = { 29742, 6006, 2 }, -- Elder Menkhaf
	[31596298] = { 29741, 6006, 3 }, -- Elder Sekhemi
}

points[205] = { -- "VashjirRuins"
	[57268615] = { 29738, 6006, 8 }, -- Elder Moonlance
}
