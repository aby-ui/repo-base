
if UnitFactionGroup("player") ~= "Alliance" then return end


local _, HallowsEnd = ...
local points = HallowsEnd.points
-- points[<mapfile>] = { [<coordinates>] = <quest ID> }


----------------------
-- Eastern Kingdoms --
----------------------
points[14] = { -- "Arathi"
	[40094914] = 28954, -- Refuge Pointe
}

points[15] = { -- "Badlands"
	[65863565] = 28955, -- Fuselight
	[20875632] = 28956, -- Dragon's Mouth
}

points[17] = { -- "BlastedLands"
	[60691407] = 28960, -- Nethergarde Keep
	[44348759] = 28961, -- Surwich
}

points[27] = { -- "DunMorogh"
	[54485076] = 12332, -- Kharanos
	[61202744] = 12335, -- The Commons, Ironforge
}

points[47] = { -- "Duskwood"
	[73804425] = 12344, -- Darkshire
}

points[23] = { -- "EasternPlaguelands"
	[75575230] = 12402, -- Light's Hope Chapel
}

points[37] = { -- "Elwynn"
	[43746590] = 12286, -- Goldshire
	[24894013] = 12336, -- Trade District, Stormwind City
}

points[26] = { -- "Hinterlands"
	[14194460] = 12351, -- Aerie Peak
	[66164443] = 28970, -- Stormfeather Outpost
}

points[87] = { -- "Ironforge"
	[18505083] = 12335, -- The Commons
}

points[48] = { -- "LochModan"
	[35544850] = 12339, -- Thelsamar
	[83036353] = 28963, -- Farstrider Lodge
}

points[49] = { -- "Redridge"
	[26484156] = 12342, -- Lakeshire
}

points[32] = { -- "SearingGorge"
	[39486603] = 28965, -- Iron Summit
}

points[84] = { -- "StormwindCity"
	[60517532] = 12336, -- Trade District
}

points[50] = { -- "StranglethornJungle"
	[53166698] = 28964, -- Fort Livingston
}

points[51] = { -- "SwampOfSorrows"
	[71651410] = 28967, -- Bogpaddle
	[28933240] = 28968, -- The Harbourage
}

points[210] = { -- "TheCapeOfStranglethorn"
	[40917372] = 12397, -- Booty Bay
}

points[22] = { -- "WesternPlaguelands"
	[43418439] = 28988, -- Chillwind Camp
}

points[52] = { -- Westfall
	[52915374] = 12340, -- Sentinel Hill
}

points[56] = { -- "Wetlands"
	[10816095] = 12343, -- Menethil Harbour
	[26092597] = 28990, -- Swiftgear Station
	[58183921] = 28991, -- Greenwarden's Grove
}


--------------
-- Kalimdor --
--------------
points[63] = { -- "Ashenvale"
	[37014926] = 12345, -- Astranaar
}

points[97] = { -- "AzuremystIsle"
	[48494905] = 12333, -- Azure Watch
	[29293485] = 12337, -- Seat of the Naaru, The Exodar
}

points[10] = { -- "Barrens"
	[67347466] = 12396, -- Ratchet
}

points[106] = { -- "BloodmystIsle"
	[55695997] = 12341, -- Blood Watch
}

points[62] = { -- "Darkshore"
	[50801890] = 28951, -- Lor'danel
}

points[89] = { -- "Darnassus"
	[62273316] = 12334, -- Craftsman's Terrace
}

points[66] = { -- "Desolace"
	[66330659] = 12348, -- Nijel's Point
	[56725012] = 28993, -- Karnum's Glade
}

points[70] = { -- "Dustwallow"
	[66604528] = 12349, -- Theramore Isle
	[41867409] = 12398, -- Mudsprocket
}

points[77] = { -- "Felwood"
	[44582898] = 28994, -- Whisperwind Grove
	[61862671] = 28995, -- Talonbranch Glade
}

points[69] = { -- "Feralas"
	[46334519] = 12350, -- Feathermoon Stronghold
	[51071782] = 28952, -- Dreamer's Rest
}

points[81] = { -- "Silithus"
	[55473679] = 12401, -- Cenarion Hold
}

points[199] = { -- "SouthernBarrens"
	[39011098] = 29006, -- Honour's Stand
	[65604654] = 29007, -- Northwatch Hold
	[49056850] = 29008, -- Fort Triumph
}

points[65] = { -- "StonetalonMountains"
	[40531769] = 12347, -- Stonetalon Peak
	[71027908] = 29010, -- Northwatch Expedition Base Camp
	[59055633] = 29011, -- Windshear Hold
	[39483281] = 29012, -- Thal'darah Overlook
	[31536066] = 29013, -- Farwatcher's Glen
}

points[71] = { -- "Tanaris"
	[52562710] = 12399, -- Gadgetzan
	[55706096] = 29014, -- Bootlegger Outpost
}

points[103] = { -- "TheExodar"
	[59251847] = 12337, -- Seat of the Naaru
}

points[57] = { -- "Teldrassil"
	[55365229] = 12331, -- Dolanaar
	[34164401] = 12334, -- Craftsman's Terrace, Darnassus
}

points[78] = { -- "UngoroCrater"
	[55276212] = 29018, -- Marshal's Stand
}

points[83] = { -- "Winterspring"
	[59835122] = 12400, -- Everlook
}


-------------
-- Outland --
-------------
points[105] = { -- "BladesEdgeMountains"
	[62903830] = 12406, -- Evergrove
	[35806380] = 12358, -- Sylvanaar
	[61006810] = 12359, -- Toshley's Station
}

points[100] = { -- "Hellfire"
	[54306360] = 12352, -- Honour Hold
	[23403650] = 12353, -- Temple of Telhamat
}

points[107] = { -- "Nagrand"
	[54207580] = 12357, -- Telaar
}

points[109] = { -- "Netherstorm"
	[32006440] = 12407, -- Area 52
	[43403610] = 12408, -- The Stormspire
}

points[104] = { -- "ShadowmoonValley"
	[37105820] = 12360, -- Wildhammer Stronghold
}

points[111] = { -- "ShattrathCity"
}

points[108] = { -- "TerokkarForest"
	[56605320] = 12356, -- Allerian Stronghold
}

points[102] = { -- "Zangarmarsh"
	[67204900] = 12354, -- Telredor
	[41902620] = 12355, -- Orebor Harbourage
	[78506290] = 12403, -- Cenarion Refuge
}


---------------
-- Northrend --
---------------
points[114] = { -- "BoreanTundra"
	[58506790] = 13436, -- Valliance Keep
	[57101880] = 13437, -- Fizzcrank Airstrip
	[78404920] = 13460, -- Unu'pe
}

points[127] = { -- "CrystalsongForest"
	[29053658] = 13463, -- The Ledgerdemain Lounge, Dalaran
	[27294136] = 13472, -- The Underbelly, Dalaran
	[27284323] = 13473, -- The Silver Enclave, Dalaran
}

points[125] = { -- "Dalaran"
	[48144132] = 13463, -- The Ledgerdemain Lounge
	[42305680] = 13472, -- The Underbelly
	[42346308] = 13473, -- The Silver Enclave
}

points[126] = { -- "DalaranUnderbelly"
	[38225959] = 13472, -- The Underbelly
}

points[115] = { -- "Dragonblight"
	[29005620] = 13438, -- Stars' Rest
	[77505130] = 13439, -- Wintergarde Keep
	[60105350] = 13456, -- Wyrmrest Temple
	[48207470] = 13459, -- Moa'ki Harbour
}

points[116] = { -- "GrizzlyHills"
	[32006020] = 12944, -- Amberpine Lodge
	[59602640] = 12945, -- Westfall Brigade
}

points[117] = { -- "HowlingFjord"
	[58406280] = 13433, -- Valgarde
	[30804150] = 13434, -- Westguard Keep
	[60501590] = 13435, -- Fort Wildevar
	[25405980] = 13452, -- Kamagua
}

points[119] = { -- "SholazarBasin"
	[26705920] = 12950, -- Nesingwary Base Camp
}

points[120] = { -- "TheStormPeaks"
	[28707430] = 13448, -- Frosthold
	[41108590] = 13461, -- K3
	[30903720] = 13462, -- Bouldercrag's Refuge
}

points[121] = { -- "ZulDrak"
	[59305720] = 12940, -- Zim'Torga
	[40806600] = 12941, -- The Argent Stand
}


---------------
-- Cataclysm --
---------------
points[207] = { -- "Deepholm"
	[47365171] = 29020, -- Temple of Earth
}

points[198] = { -- "Hyjal"
	[63052415] = 28999, -- Nordrassil
	[18623732] = 29000, -- Grove of Aessina
	[42684571] = 29001, -- Shrine of Aviana
}

points[241] = { -- "TwilightHighlands"
	[60355825] = 28977, -- Firebeard's Patrol
	[79487855] = 28980, -- Highbank
	[49583036] = 28978, -- Thundermar
	[43505727] = 28979, -- Victor's Point
}

points[249] = { -- "Uldum"
	[26580724] = 29016, -- Oasis of Vir'sar
	[54683301] = 29017, -- Ramkahen
}

points[204] = { -- "VashjirDepths"
	[54677212] = 28985, -- Darkbreak Cove
}

points[201] = { -- "VashjirKelpForest"
	[63506017] = 28981, -- Deepmist Grotto
}

points[205] = { -- "VashjirRuins"
	[49174188] = 28982, -- Silver Tide Hollow
	[49725739] = 28983, -- Tranquil Wash
}


--------------
-- Pandaria --
--------------
points[422] = { -- "DreadWastes"
	[55217117] = 32023, -- Soggy's Gamble
	[55913228] = 32024, -- Klaxxi'vess
}

points[418] = { -- "Krasarang"
	[51437729] = 32034, -- Marista
	[75930691] = 32036, -- Zhu's Watch
}

points[379] = { -- "KunLaiSummit"
	[72719226] = 32039, -- Binan Village
	[64226125] = 32041, -- The Grummle Bazaar
	[57475994] = 32037, -- One Keg
	[54078278] = 32042, -- Westwind Rest
	[62482892] = 32051, -- Zouchin Village
}

points[393] = { -- "ShrineofSevenStars"
	[37866593] = 32052, -- Shrine of Seven Stars, Vale of Eternal Blossoms
}

points[433] = { -- "TheHiddenPass"
	[55037224] = 32026, -- Tavern in the Mists
}

points[371] = { -- "TheJadeForest"
	[45784360] = 32027, -- Dawn's Blossom
	[48083464] = 32029, -- Greenstone Village
	[54626335] = 32032, -- Jade Temple Grounds
	[44808439] = 32049, -- Paw'don Village
	[59558322] = 32033, -- Pearlfin Village
	[55732440] = 32031, -- Sri-La Village
	[41672316] = 32021, -- Tian Monastery
}

points[388] = { -- "TownlongWastes"
	[71135780] = 32043, -- Longying Outpost
}

points[390] = { -- "ValeofEternalBlossoms"
	[35137777] = 32044, -- Mistfall Village
	[87036889] = 32052, -- Shrine of Seven Stars
}

points[376] = { -- "ValleyoftheFourWinds"
	[83642019] = 32048, -- Pang's Stead
	[19885582] = 32046, -- Stoneplow
}


-------------
-- Draenor --
-------------
points[582] = { -- "garrisonsmvalliance_tier3"
	[43765159] = 39657, -- Lunarfall Garrison
}

points[539] = { -- "ShadowmoonValleyDR"
	[30181800] = 39657, -- Lunarfall Garrison
}


------------------
-- Broken Isles --
------------------
points[627] = { -- "Dalaran70"
	[47954177] = 43055, -- The Ledgerdemain Lounge
	[41486398] = 43056, -- Greyfang Enclave
}
