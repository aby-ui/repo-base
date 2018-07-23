
if UnitFactionGroup("player") ~= "Horde" then return end


local _, SummerFestival = ...
local points = SummerFestival.points
-- points[<mapfile>] = { [<coordinates>] = "<questID>:<type>" }


----------------------
-- Eastern Kingdoms --
----------------------

points["Arathi"] = {
	[44594627] = "11732:D",	-- Refuge Pointe
	[69394259] = "11840:H",	-- Hammerfall
}

points["Badlands"] = {
	[18655612] = "28912:D",	-- Dragon's Mouth
	[23093745] = "11842:H",	-- New Kargath
}

points["BlastedLands"] = {
	[48160728] = "Zidormi",
	[46221379] = "28930:H",	-- Dreadmaul Hold
	[55211519] = "11737:D",	-- Nethergarde Keep
}

points["BurningSteppes"] = {
	[51112922] = "11844:H",	-- Flame Crest
	[68586006] = "11739:D",	-- Morgan's Vigil
}

points["DunMorogh"] = {
	[68682318] = "9331:C",	-- Stealing Ironforge's Flame
	[53744477] = "11742:D",	-- Kharanos
}

points["Duskwood"] = {
	[73215502] = "11743:D",	-- Darkshire
}

points["Elwynn"] = {
	[19483889] = "9330:C",	-- Stealing Stormwind's Flame
	[43086285] = "11745:D",	-- Goldshire
}

points["EversongWoods"] = {
	[46415060] = "11848:H",	-- Falconwing Square
}

points["Ironforge"] = {
	[64872541] = "9331:C",	-- Stealing Ironforge's Flame
}

points["Ghostlands"] = {
	[46892633] = "11850:H",	-- Tranquillien
}

points["HillsbradFoothills"] = {
	[54655009] = "11853:H",	-- Tarren Mill
}

points["Hinterlands"] = {
	[14514987] = "11755:D",	-- Aerie Peak
	[76627497] = "11860:H",	-- Revantusk Village
}

points["LochModan"] = {
	[32314009] = "11749:D",	-- Thelsamar
}

points["Redridge"] = {
	[24485388] = "11751:D",	-- Lakeshire
}

points["Silverpine"] = {
	[49633820] = "11584:H",	-- The Sepulcher
}

points["StormwindCity"] = {
	[49717284] = "9330:C",	-- Stealing Stormwind's Flame
}

points["StranglethornJungle"] = {
	[40585093] = "28924:H",	-- Grom'gol Base Camp
	[51676329] = "28910:D",	-- Fort Livingston
}

points["StranglethornVale"] = {
	[44223306] = "28924:H",	-- Grom'gol Base Camp, Northern Stranglethorn
	[51164079] = "28910:D",	-- Fort Livingston, Northern Stranglethorn
	[44467604] = "11761:D",	-- Wild Shore (north), Southern Stranglethorn
	[43627791] = "11837:H",	-- Wild Shore (south), Southern Stranglethorn
}

points["SwampOfSorrows"] = {
	[76361376] = "11857:H",	-- Bogpaddle (west)
	[70181427] = "28916:D",	-- Bogpaddle (east)
}

points["TheCapeOfStranglethorn"] = {
	[50417037] = "11837:H",	-- Wild Shore (south)
	[51796726] = "11761:D",	-- Wild Shore (north)
}

points["Tirisfal"] = {
	[57235177] = "11862:H",	-- Brill
}

points["WesternPlaguelands"] = {
	[29165735] = "28931:H",	-- The Bulwark
	[43568258] = "11756:D",	-- Chillwind Camp
}

points["Westfall"] = {
	[45146244] = "11581:D",	-- Moonbrook
}

points["Wetlands"] = {
	[13284724] = "11757:D",	-- Menethil Harbour
}


--------------
-- Kalimdor --
--------------

points["Ashenvale"] = {
	[51346615] = "11841:H",	-- Silverwind Refuge
	[86744146] = "11734:D",	-- Forest Song
}

points["Aszhara"] = {
	[60795348] = "28923:H",	-- Bilgewater Harbour
}

points["AzuremystIsle"] = {
	[24623673] = "11933:C",	-- Stealing the Exodar's Flame
	[44655277] = "11735:D",	-- Azure Watch
}

points["Barrens"] = {
	[49975462] = "11859:H",	-- The Crossroads
}

points["BloodmystIsle"] = {
	[55866852] = "11738:D",	-- Blood Watch
}

points["Darkshore"] = {
	[48962257] = "11740:D",	-- Lor'danel
}

points["Darnassus"] = {
	[63664679] = "9332:C",	-- Stealing Darnassus' Flame
}

points["Desolace"] = {
	[26137690] = "11845:H",	-- Silverprey Village
	[65861688] = "11741:D",	-- Nijel's Point
}

points["Durotar"] = {
	[52254739] = "11846:H",	-- Razor Hill
}

points["Dustwallow"] = {
	[33433092] = "11847:H",	-- Brackenwall Village
	[62064047] = "11744:D",	-- Theramore Isle
}

points["Feralas"] = {
	[46674366] = "11746:D",	-- Feathermoon Stronghold
	[72384780] = "11849:H",	-- Camp Mojache
}

points["Mulgore"] = {
	[51825924] = "11852:H",	-- Bloodhoof Village
}

points["Silithus"] = {
	[50844130] = "11836:H",	-- Cenarion Hold (south)
	[60553304] = "11760:D",	-- Cenarion Hold (east)
}

points["SouthernBarrens"] = {
	[48277251] = "28913:D",	-- Fort Triumph
	[40866779] = "28927:H",	-- Desolation Point
}

points["StonetalonMountains"] = {
	[49545510] = "28915:D",	-- Mirkfallon Lake
	[52926246] = "11856:H",	-- Sun Rock Retreat
}

points["Tanaris"] = {
	[49812786] = "11838:H",	-- Gadgetzan (west)
	[52673003] = "11762:D",	-- Gadgetzan (east)
}

points["Teldrassil"] = {
	[34524759] = "9332:C",	-- Stealing Darnassus' Flame
	[54745293] = "11753:D",	-- Dolanaar
}

points["TheExodar"] = {
	[41242570] = "11933:C",	-- Stealing the Exodar's Flame
}

points["UngoroCrater"] = {
	[56326636] = "28933:H",	-- Marshal's Stand (west)
	[59866284] = "28921:D",	-- Marshal's Stand (east)
}

points["Winterspring"] = {
	[58154751] = "11839:H",	-- Everlook (west)
	[61384710] = "11763:D",	-- Everlook (east)
}


-------------
-- Outland --
-------------

points["BladesEdgeMountains"] = {
	[41806603] = "11736:D",	-- Sylvanaar
	[49915867] = "11843:H",	-- Thunderlord Stronghold
}

points["Hellfire"] = {
	[47124205] = "11851:H",	-- Thrallmar
	[61945845] = "11747:D",	-- Honour Hold
}

points["Nagrand"] = {
	[49666980] = "11750:D",	-- Telaar
	[50913415] = "11854:H",	-- Garadar
}

points["Netherstorm"] = {
	[31046291] = "11759:D",	-- Area 52 (north-west)
	[32116833] = "11835:H",	-- Area 52 (south)
}

points["ShadowmoonValley"] = {
	[33403054] = "11855:H",	-- Shadowmoon Village
	[39525438] = "11752:D",	-- Wildhammer Stronghold
}

points["TerokkarForest"] = {
	[52014920] = "11858:H",	-- Stonebreaker Hold
	[54195546] = "11754:D",	-- Allerian Stronghold
}

points["Zangarmarsh"] = {
	[35435162] = "11863:H",	-- Zabra'jin
	[68575216] = "11758:D",	-- Telredor
}


---------------
-- Northrend --
---------------

points["BoreanTundra"] = {
	[51141154] = "13493:H",	-- Bor'gorok Outpost
	[55202022] = "13440:D",	-- Fizzcrank Airstrip
}

points["CrystalsongForest"] = {
	[77497516] = "13447:D",	-- Windrunner's Overlook
	[79975324] = "13499:H",	-- Sunreaver's Command
}

points["Dragonblight"] = {
	[38264848] = "13495:H",	-- Agmar's Hammer
	[75034379] = "13443:D",	-- Wintergarde Keep
}

points["GrizzlyHills"] = {
	[19326114] = "13497:H",	-- Conquest Hold
	[34226063] = "13445:D",	-- Amberpine Lodge
}

points["HowlingFjord"] = {
	[48621315] = "13496:H",	-- Camp Winterhoof
	[57751570] = "13444:D",	-- Fort Wildervar
}

points["SholazarBasin"] = {
	[47066157] = "13494:H",	-- River's Heart (north)
	[47866616] = "13442:D",	-- River's Heart (south)
}

points["TheStormPeaks"] = {
	[40278535] = "13498:H",	-- K3 (north-west)
	[41428706] = "13446:D",	-- K3 (south-east)
}

points["ZulDrak"] = {
	[43377176] = "13500:H",	-- The Argent Stand (south-east)
	[40526091] = "13449:D",	-- The Argent Stand (north)
}


---------------
-- Cataclysm --
---------------

points["Deepholm"] = {
	[49405132] = "29036:H",	-- Temple of Earth
}

points["Hyjal"] = {
	[62832271] = "29030:H",	-- Nordrassil
}

points["TwilightHighlands"] = {
	[47102822] = "28943:D",	-- Thundermar
	[53124616] = "28946:H",	-- Bloodgulch
}

points["Uldum"] = {
	[53393182] = "28947:D",	-- Ramkahen (north)
	[53163454] = "28949:H",	-- Ramkahen (south)
}

points["Vashjir"] = {
	[64315167] = "29031:H",	-- Silver Tide Hollow
}

points["VashjirRuins"] = {
	[49354199] = "29031:H",	-- Silver Tide Hollow
}


--------------
-- Pandaria --
--------------

points["DreadWastes"] = {
	[56076958] = "32497:H",	-- Soggy's Gamble
}

points["Krasarang"] = {
	[73990950] = "32499:H",	-- Zhu's Watch
}

points["KunLaiSummit"] = {
	[71159087] = "32500:H",	-- Binan Village
}

points["TheJadeForest"] = {
	[47184719] = "32498:H",	-- Dawn's Blossom
}

points["TownlongWastes"] = {
	[71525629] = "32501:H",	-- Longying Outpost
}

points["ValeofEternalBlossoms"] = {
	[77763400] = "32509:H",	-- Shrine of Two Moons
	[79673727] = "32503:D",	-- Shrine of Seven Stars
}

points["ValleyoftheFourWinds"] = {
	[51825133] = "32502:H",	-- Halfhill
}


-------------
-- Draenor --
-------------

points["ShadowmoonValleyDR"] = { [42623595] = "44582:D" }
points["FrostfireRidge"] = { [72566501] = "44580:H" }
points["Gorgrond"] = { [43939374] = "44573:H" }
points["Talador"] = { [43507173] = "44571:H" }
points["SpiresOfArak"] = { [47984466] = "44570:H" }
points["NagrandDraenor"] = { [80504770] = "44572:H" }

------------------
-- Broken Isles --
------------------

points["Azsuna"] = { [48282966] = "44574:H" }
points["Highmountain"] = { [55538447] = "44576:H" }
points["Stormheim"] = { [32514214] = "44577:H" }
points["Valsharah"] = { [44875789] = "44575:H" }
points["Suramar"] = { [30404540] = "44614:H", [22855830] = "44624:D" }
