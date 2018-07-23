
if UnitFactionGroup("player") ~= "Alliance" then return end


local _, HallowsEnd = ...
local points = HallowsEnd.points
-- points[<mapfile>] = { [<coordinates>] = <quest ID> }


----------------------
-- Eastern Kingdoms --
----------------------
points["Arathi"] = {
	[40094914] = 28954, -- Refuge Pointe
}

points["Badlands"] = {
	[65863565] = 28955, -- Fuselight
	[20875632] = 28956, -- Dragon's Mouth
}

points["BlastedLands"] = {
	[48160728] = "Zidormi",
	[60691407] = 28960, -- Nethergarde Keep
	[44348759] = 28961, -- Surwich
}

points["DunMorogh"] = {
	[54485076] = 12332, -- Kharanos
	[61202744] = 12335, -- The Commons, Ironforge
}

points["Duskwood"] = {
	[73804425] = 12344, -- Darkshire
}

points["EasternPlaguelands"] = {
	[75575230] = 12402, -- Light's Hope Chapel
}

points["Elwynn"] = {
	[43746590] = 12286, -- Goldshire
	[24894013] = 12336, -- Trade District, Stormwind City
}

points["Hinterlands"] = {
	[14194460] = 12351, -- Aerie Peak
	[66164443] = 28970, -- Stormfeather Outpost
}

points["Ironforge"] = {
	[18505083] = 12335, -- The Commons
}

points["LochModan"] = {
	[35544850] = 12339, -- Thelsamar
	[83036353] = 28963, -- Farstrider Lodge
}

points["Redridge"] = {
	[26484156] = 12342, -- Lakeshire
}

points["SearingGorge"] = {
	[39486603] = 28965, -- Iron Summit
}

points["StormwindCity"] = {
	[60517532] = 12336, -- Trade District
}

points["StranglethornJungle"] = {
	[53166698] = 28964, -- Fort Livingston
}

points["StranglethornVale"] = {
	[37907993] = 12397, -- Booty Bay, Southern Stranglethorn
	[52094310] = 28964, -- Fort Livingston, Northern Stranglethorn
}

points["SwampOfSorrows"] = {
	[71651410] = 28967, -- Bogpaddle
	[28933240] = 28968, -- The Harbourage
}

points["TheCapeOfStranglethorn"] = {
	[40917372] = 12397, -- Booty Bay
}

points["WesternPlaguelands"] = {
	[43418439] = 28988, -- Chillwind Camp
}

points["Wetlands"] = {
	[10816095] = 12343, -- Menethil Harbour
	[26092597] = 28990, -- Swiftgear Station
	[58183921] = 28991, -- Greenwarden's Grove
}


--------------
-- Kalimdor --
--------------
points["Ashenvale"] = {
	[37014926] = 12345, -- Astranaar
}

points["AzuremystIsle"] = {
	[48494905] = 12333, -- Azure Watch
	[29293485] = 12337, -- Seat of the Naaru, The Exodar
}

points["Barrens"] = {
	[67347466] = 12396, -- Ratchet
}

points["BloodmystIsle"] = {
	[55695997] = 12341, -- Blood Watch
}

points["Darkshore"] = {
	[50801890] = 28951, -- Lor'danel
}

points["Darnassus"] = {
	[62273316] = 12334, -- Craftsman's Terrace
}

points["Desolace"] = {
	[66330659] = 12348, -- Nijel's Point
	[56725012] = 28993, -- Karnum's Glade
}

points["Dustwallow"] = {
	[55804960] = "Zidormi",
	[66604528] = 12349, -- Theramore Isle
	[41867409] = 12398, -- Mudsprocket
}

points["Felwood"] = {
	[44582898] = 28994, -- Whisperwind Grove
	[61862671] = 28995, -- Talonbranch Glade
}

points["Feralas"] = {
	[46334519] = 12350, -- Feathermoon Stronghold
	[51071782] = 28952, -- Dreamer's Rest
}

points["Silithus"] = {
	[55473679] = 12401, -- Cenarion Hold
}

points["SouthernBarrens"] = {
	[39011098] = 29006, -- Honour's Stand
	[65604654] = 29007, -- Northwatch Hold
	[49056850] = 29008, -- Fort Triumph
}

points["StonetalonMountains"] = {
	[71027908] = 29010, -- Northwatch Expedition Base Camp
	[59055633] = 29011, -- Windshear Hold
	[39483281] = 29012, -- Thal'darah Overlook
	[31536066] = 29013, -- Farwatcher's Glen
}

points["Tanaris"] = {
	[52562710] = 12399, -- Gadgetzan
	[55706096] = 29014, -- Bootlegger Outpost
}

points["TheExodar"] = {
	[59251847] = 12337, -- Seat of the Naaru
}

points["Teldrassil"] = {
	[55365229] = 12331, -- Dolanaar
	[34164401] = 12334, -- Craftsman's Terrace, Darnassus
}

points["UngoroCrater"] = {
	[55276212] = 29018, -- Marshal's Stand
}

points["Winterspring"] = {
	[59835122] = 12400, -- Everlook
}


-------------
-- Outland --
-------------
points["BladesEdgeMountains"] = {
	[62903830] = 12406, -- Evergrove
	[35806380] = 12358, -- Sylvanaar
	[61006810] = 12359, -- Toshley's Station
}

points["Hellfire"] = {
	[54306360] = 12352, -- Honour Hold
	[23403650] = 12353, -- Temple of Telhamat
}

points["Nagrand"] = {
	[54207580] = 12357, -- Telaar
}

points["Netherstorm"] = {
	[32006440] = 12407, -- Area 52
	[43403610] = 12408, -- The Stormspire
}

points["ShadowmoonValley"] = {
	[37105820] = 12360, -- Wildhammer Stronghold
	[61002820] = 12409, -- Altar of Sha'tar
	[56305980] = 12409, -- Sanctum of the Stars
}

points["ShattrathCity"] = {
	[28104900] = 12404, -- Aldor Rise
	[56208180] = 12404, -- Scryer's Tier
}

points["TerokkarForest"] = {
	[56605320] = 12356, -- Allerian Stronghold
}

points["Zangarmarsh"] = {
	[67204900] = 12354, -- Telredor
	[41902620] = 12355, -- Orebor Harbourage
	[78506290] = 12403, -- Cenarion Refuge
}


---------------
-- Northrend --
---------------
points["BoreanTundra"] = {
	[58506790] = 13436, -- Valliance Keep
	[57101880] = 13437, -- Fizzcrank Airstrip
	[78404920] = 13460, -- Unu'pe
}

points["CrystalsongForest"] = {
	[29053658] = 13463, -- The Ledgerdemain Lounge, Dalaran
	[27294136] = 13472, -- The Underbelly, Dalaran
	[27284323] = 13473, -- The Silver Enclave, Dalaran
}

points["Dalaran"] = {
	[48144132] = 13463, -- The Ledgerdemain Lounge
	[38235958] = 13472, -- The Underbelly
	[42346308] = 13473, -- The Silver Enclave
}

points["Dragonblight"] = {
	[29005620] = 13438, -- Stars' Rest
	[77505130] = 13439, -- Wintergarde Keep
	[60105350] = 13456, -- Wyrmrest Temple
	[48207470] = 13459, -- Moa'ki Harbour
}

points["GrizzlyHills"] = {
	[32006020] = 12944, -- Amberpine Lodge
	[59602640] = 12945, -- Westfall Brigade
}

points["HowlingFjord"] = {
	[58406280] = 13433, -- Valgarde
	[30804150] = 13434, -- Westguard Keep
	[60501590] = 13435, -- Fort Wildevar
	[25405980] = 13452, -- Kamagua
}

points["SholazarBasin"] = {
	[26705920] = 12950, -- Nesingwary Base Camp
}

points["TheStormPeaks"] = {
	[28707430] = 13448, -- Frosthold
	[41108590] = 13461, -- K3
	[30903720] = 13462, -- Bouldercrag's Refuge
}

points["ZulDrak"] = {
	[59305720] = 12940, -- Zim'Torga
	[40806600] = 12941, -- The Argent Stand
}


---------------
-- Cataclysm --
---------------
points["Deepholm"] = {
	[47365171] = 29020, -- Temple of Earth
}

points["Hyjal"] = {
	[63052415] = 28999, -- Nordrassil
	[18623732] = 29000, -- Grove of Aessina
	[42684571] = 29001, -- Shrine of Aviana
}

points["TwilightHighlands"] = {
	[60355825] = 28977, -- Firebeard's Patrol
	[79487855] = 28980, -- Highbank
	[49583036] = 28978, -- Thundermar
	[43505727] = 28979, -- Victor's Point
}

points["Uldum"] = {
	[26580724] = 29016, -- Oasis of Vir'sar
	[54683301] = 29017, -- Ramkahen
}

points["Vashjir"] = {
	[78653071] = 28981, -- Deepmist Grotto, Kelp'thar Forest
	[64195159] = 28982, -- Silver Tide Hollow, Shimmering Expanse
	[64566242] = 28983, -- Tranquil Wash, Shimmering Expanse
	[39576790] = 28985, -- Darkbreak Cove, Abyssal Depths
}

points["VashjirDepths"] = {
	[54677212] = 28985, -- Darkbreak Cove
}

points["VashjirKelpForest"] = {
	[63506017] = 28981, -- Deepmist Grotto
}

points["VashjirRuins"] = {
	[49174188] = 28982, -- Silver Tide Hollow
	[49725739] = 28983, -- Tranquil Wash
}


--------------
-- Pandaria --
--------------
points["DreadWastes"] = {
	[55217117] = 32023, -- Soggy's Gamble
	[55913228] = 32024, -- Klaxxi'vess
}

points["Krasarang"] = {
	[51437729] = 32034, -- Marista
	[75930691] = 32036, -- Zhu's Watch
}

points["KunLaiSummit"] = {
	[72719226] = 32039, -- Binan Village
	[64226125] = 32041, -- The Grummle Bazaar
	[57475994] = 32037, -- One Keg
	[54078278] = 32042, -- Westwind Rest
	[62482892] = 32051, -- Zouchin Village
}

points["ShrineofSevenStars"] = {
	[37866593] = 32052, -- Shrine of Seven Stars, Vale of Eternal Blossoms
}

points["TheHiddenPass"] = {
	[55037224] = 32026, -- Tavern in the Mists
}

points["TheJadeForest"] = {
	[45784360] = 32027, -- Dawn's Blossom
	[48083464] = 32029, -- Greenstone Village
	[54626335] = 32032, -- Jade Temple Grounds
	[44808439] = 32049, -- Paw'don Village
	[59558322] = 32033, -- Pearlfin Village
	[55732440] = 32031, -- Sri-La Village
	[41672316] = 32021, -- Tian Monastery
}

points["TownlongWastes"] = {
	[71135780] = 32043, -- Longying Outpost
}

points["ValeofEternalBlossoms"] = {
	[35137777] = 32044, -- Mistfall Village
	[87036889] = 32052, -- Shrine of Seven Stars
}

points["ValleyoftheFourWinds"] = {
	[83642019] = 32048, -- Pang's Stead
	[19885582] = 32046, -- Stoneplow
}


-------------
-- Draenor --
-------------
points["garrisonsmvalliance_tier3"] = {
	[43765159] = 39657, -- Lunarfall Garrison
}

points["ShadowmoonValleyDR"] = {
	[30181800] = 39657, -- Lunarfall Garrison
}


------------------
-- Broken Isles --
------------------
points["BrokenIsles"] = {
	[45776429] = 43055, -- The Ledgerdemain Lounge
	[45486526] = 43056, -- Greyfang Enclave
}

points["Dalaran70"] = {
	[47954177] = 43055, -- The Ledgerdemain Lounge
	[41486398] = 43056, -- Greyfang Enclave
}
