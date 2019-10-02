-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

private.CONTINENT_ZONE_IDS = {
	[905] = { zonefilter = true, id = 9, zones = {830,882,885} }; --Argus
	[619] = { zonefilter = true, id = 8, zones = {630,646,625,790,650,634,680,641,649,652} }; --Broken Isles
	[572] = { zonefilter = true, id = 7, zones = {588,525,590,543,582,550,539,542,535,534} }; --Draenor
	[13] = { zonefilter = true, id = 2, zones = {76,210,26,469,47,204,241,14}, current = { 14 } }; --Eastern Kingdoms
	[12] = { zonefilter = true, id = 1, zones = {198,338,81,77,103,80,69,62}, current = { 62 } }; --Kalimdor
	[113] = { zonefilter = true, id = 4, zones = {120} }; --Northrend
	[424] = { zonefilter = true, id = 6, zones = {422,507,504,418,379,371,433,554,388,376,390} }; --Pandaria
	--[101] = { id = 3, zones = {} }; --Outland
	[948] = { zonefilter = true, id = 5, zones = {207} }; --The Maelstrom
	[876] = { zonefilter = true, id = 10, zones = {942,895,896,1161,1462}, current = { "all" } }; --Kul Tiras
	[875] = { zonefilter = true, id = 11, zones = {864,863,862,1165}, current = { "all" } }; --Zandalar
	[1355] = { zonefilter = true, id = 12, zones = {1355}, current = { "all" } }; --Nazjatar
	[9999] = { zonefilter = true, zones = {628,672,276,734,702,695,747,378,739} }; --Class Halls
	[9998] = { zonefilter = true, zones = {407}, current = { "all" } }; --Darkmoon Island
	[9997] = { zonefilter = true, zones = {306,616,703,677,731,733,706,749,897,903} }; --Dungeons or scenarios
	[9996] = { zonefilter = true, zones = {909,856,772} }; --Raids
	[9995] = { zonefilter = false, zones = {0} }; --Unknown
}

private.SUBZONES_IDS = {
	[772] = {764,765,766,767,768,769,770,771}; --The Nighthold
	[856] = {851,852,853,854,855}; --Tomb of Sargeras
	[909] = {910,911,912,913,914,915,916,917,918,919,920}; --Antorus, the Burning Throne
	[677] = {678,679,710,711,712}; --Vault of the Wardens
	[703] = {704,705,829}; --Halls of Valor
	[706] = {707,708}; --Maw of Souls
	[845] = {846,847,848,849}; --Cathedral of Eternal Night
	[306] = {307,308,309,476,477,478,479}; --Scholomance
	[508] = {509,510,511,512,513,514,515}; --Throne of Thunder
	[616] = {617,618}; --Upper Blackrock Spire
	[749] = {798}; --The Arcway
	[407] = {408}; --Darkmoon Island
	[734] = {735}; --Hall of the Guardian (mage class hall)
	[672] = {719,720,721,879,880,861}; --Mardum, the Shattered Abyss (demon hunter class hall)
	[276] = {725,726,839,948}; --The Heart of Azeroth (shaman class hall)
	[378] = {709}; --The Wandering Isle (monk class hall)
}

private.RESETABLE_KILLS_ZONE_IDS = {
----[zoneId] = { artID or "all"};
	[830] = { "all" }; --Krokun
	[882] = { "all" }; --Mac-Aree
	[885] = { "all" }; --Antoran wastes
	[81] = { 962 }; --Silithus
	[1355] = { "all" }; --Nazjatar
	[1462] = { "all" }; --Mechagon
}

private.RESETABLE_WARFRONT_KILLS_ZONE_IDS = {
	[14] = { 1137 }; --Arathi Highlands
	[62] = { 1176 }; --Darkshore
}

private.PERMANENT_KILLS_ZONE_IDS = {
	[525] = { "all" };
	[539] = { "all" };
	[542] = { "all" };
	[543] = { "all" };
	[550] = { "all" };
	[535] = { "all" };
	[630] = { "all" };
	[646] = { "all" };
	[625] = { "all" };
	[790] = { "all" };
	[650] = { "all" };
	[634] = { "all" };
	[680] = { "all" };
	[641] = { "all" };
	[649] = { "all" };
	[942] = { "all" };
	[895] = { "all" };
	[896] = { "all" };
	[1161] = { "all" };
	[864] = { "all" };
	[863] = { "all" };
	[862] = { "all" };
	[1165] = { "all" };
	[1462] = { "all" };
}

-- Mechagon construction projects
private.CONSTRUCTION_PROJECTS = {
	["TR28"] = 153206; --Ol' Big Tusk
	["TR35"] = 150342; --Earthbreaker Gulroc
	["CC61"] = 154701; --Gorged Gear-Cruncher
	["CC73"] = 154739; --Caustic Mechaslime
	["CC88"] = 152113; --The Kleptoboss
	["JD41"] = 153200; --Boilburn
	["JD99"] = 153205; --Gemicide
}

private.ZONE_IDS = {
	[50062] = { zoneID = 207, x = 0.296, y = 0.412 }; --Aeonaxx
	[58778] = { zoneID = 390, x = 0.35, y = 0.894 }; --Aetha
	[50750] = { zoneID = 371, x = 0.335535854101181, y = 0.507828533649445 }; --Aethis
	[50817] = { zoneID = 379, x = 0.406, y = 0.428 }; --Ahone the Wanderer
	[50821] = { zoneID = 422, x = 0.347376525402069, y = 0.232313632965088 }; --Ai-Li Skymirror
	[50822] = { zoneID = 390, x = 0.428373157978058, y = 0.692486047744751 }; --Ai-Ran the Shifting Cloud
	[70000] = { zoneID = 504, x = 0.447204381227493, y = 0.297938674688339 }; --Al'tabim the All-Seeing
	[54318] = { zoneID = 198, x = 0.274, y = 0.51 }; --Ankha
	[54338] = { zoneID = 338, x = 0.52599996, y = 0.412 }; --Anthriss
	[73174] = { zoneID = 554, x = 0.580863654613495, y = 0.250483781099319 }; --Archiereus of Flame
	[73666] = { zoneID = 554, x = 0.342, y = 0.314 }; --Archiereus of Flame
	[70243] = { zoneID = 508, x = 0.42400002, y = 0.688 }; --Archritualist Kelada
	[50787] = { zoneID = 418, x = 0.561850666999817, y = 0.469431936740875 }; --Arness the Scale
	[70001] = { zoneID = 504, x = 0.48400003, y = 0.254 }; --Backbreaker Uru
	[58949] = { zoneID = 390, x = 0.169940397143364, y = 0.485803186893463 }; --Bai-Jin the Butcher
	[54320] = { zoneID = 198, x = 0.258, y = 0.612 }; --Ban'thalos
	[63695] = { zoneID = 390, x = 0.286942154169083, y = 0.433718740940094 }; --Baolai the Immolator
	[51059] = { zoneID = 376, x = 0.345522433519363, y = 0.592244207859039 }; --Blackhoof
	[58474] = { zoneID = 390, x = 0.27, y = 0.146 }; --Bloodtip
	[50828] = { zoneID = 376, x = 0.139538019895554, y = 0.384737640619278 }; --Bonobos
	[50341] = { zoneID = 379, x = 0.554, y = 0.43400002 }; --Borginn Darkfist
	[72775] = { zoneID = 554, x = 0.648963987827301, y = 0.748340606689453 }; --Bufo
	[73171] = { zoneID = 554, x = 0.6, y = 0.51 }; --Champion of the Black Flame
	[72045] = { zoneID = 554, x = 0.252, y = 0.354 }; --Chelon
	[73175] = { zoneID = 554, x = 0.54, y = 0.524 }; --Cinderfall
	[50768] = { zoneID = 418, x = 0.310473561286926, y = 0.346203923225403 }; --Cournith Waterstrider
	[58768] = { zoneID = 390, x = 0.464477688074112, y = 0.593426465988159 }; --Cracklefang
	[72049] = { zoneID = 554, x = 0.43400002, y = 0.7 }; --Cranegnasher
	[50334] = { zoneID = 422, x = 0.252, y = 0.284 }; --Dak the Breaker
	[68318] = { zoneID = 418, x = 0.849698066711426, y = 0.273732155561447 }; --Dalan Nightbreaker
	[54322] = { zoneID = 338, x = 0.676, y = 0.72199994 }; --Deth'tilac
	[68319] = { zoneID = 418, x = 0.874788701534271, y = 0.291870951652527 }; --Disha Fearwarden
	[59369] = { zoneID = 306, x = 0.352, y = 0.36200002 }; --Doctor Theolen Krastinov
	[73281] = { zoneID = 554, x = 0.26, y = 0.234 }; --Dread Ship Vazuvius
	[73158] = { zoneID = 554, x = 0.294, y = 0.5 }; --Emerald Gander
	[50772] = { zoneID = 388, x = 0.653664290904999, y = 0.874670684337616 }; --Eshelon
	[73279] = { zoneID = 554, x = 0.393703609704971, y = 0.962305128574371 }; --Evermaw
	[51078] = { zoneID = 371, x = 0.52, y = 0.44599998 }; --Ferdinand
	[70429] = { zoneID = 508, x = 0.5, y = 0.296 }; --Flesh'rok the Diseased
	[73172] = { zoneID = 554, x = 0.486857086420059, y = 0.356694608926773 }; --Flintlord Gairan
	[70249] = { zoneID = 508, x = 0.66400003, y = 0.396 }; --Focused Eye
	[50340] = { zoneID = 418, x = 0.563148975372315, y = 0.351216286420822 }; --Gaarn the Toxic
	[62881] = { zoneID = 390, x = 0.21200001, y = 0.17 }; --Gaohun the Soul-Severer
	[50739] = { zoneID = 422, x = 0.356169790029526, y = 0.305313229560852 }; --Gar'lok
	[73282] = { zoneID = 554, x = 0.64199996, y = 0.286 }; --Garnia
	[63101] = { zoneID = 390, x = 0.274521797895432, y = 0.534750819206238 }; --General Temuja
	[50051] = { zoneID = 204, x = 0.124, y = 0.83 }; --Ghostcrawler
	[50331] = { zoneID = 418, x = 0.39400002, y = 0.288 }; --Go-Kan
	[62880] = { zoneID = 390, x = 0.268594920635223, y = 0.13115082681179 }; --Gochao the Ironfist
	[69999] = { zoneID = 504, x = 0.614, y = 0.49400002 }; --God-Hulk Ramuk
	[69998] = { zoneID = 504, x = 0.538027942180634, y = 0.532343864440918 }; --Goda
	[72970] = { zoneID = 554, x = 0.60400003, y = 0.622 }; --Golganarr
	[73161] = { zoneID = 554, x = 0.204, y = 0.42400002 }; --Great Turtle Furyshell
	[72909] = { zoneID = 554, x = 0.420214861631393, y = 0.732303321361542 }; --Gu'chi the Swarmbringer
	[50354] = { zoneID = 379, x = 0.57, y = 0.758 }; --Havak
	[50358] = { zoneID = 504, x = 0.482, y = 0.87 }; --Haywire Sunreaver Construct
	[63691] = { zoneID = 390, x = 0.268, y = 0.158 }; --Huo-Shuang
	[73167] = { zoneID = 554, x = 0.566285252571106, y = 0.558225035667419 }; --Huolon
	[50836] = { zoneID = 422, x = 0.553440630435944, y = 0.635489344596863 }; --Ik-Ik the Nimble
	[73163] = { zoneID = 554, x = 0.287437081336975, y = 0.435767322778702 }; --Imperial Python
	[73160] = { zoneID = 554, x = 0.282, y = 0.45599997 }; --Ironfur Steelhorn
	[49822] = { zoneID = 207, x = 0.612, y = 0.22399999 }; --Jadefang
	[73169] = { zoneID = 554, x = 0.533075094223022, y = 0.831592202186585 }; --Jakur of Ordon
	[50351] = { zoneID = 376, x = 0.186050772666931, y = 0.777031004428864 }; --Jonn-Dar
	[50355] = { zoneID = 388, x = 0.628, y = 0.354 }; --Kah'tir
	[50749] = { zoneID = 390, x = 0.138450771570206, y = 0.586406707763672 }; --Kal'tik the Blight
	[50349] = { zoneID = 390, x = 0.152359038591385, y = 0.352149397134781 }; --Kang the Soul Thief
	[68321] = { zoneID = 418, x = 0.141389667987824, y = 0.57124787569046 }; --Kar Warmaker
	[72193] = { zoneID = 554, x = 0.338, y = 0.852 }; --Karkanos
	[50959] = { zoneID = 338, x = 0.33, y = 0.522 }; --Karkin
	[50138] = { zoneID = 241, x = 0.492, y = 0.744 }; --Karoma
	[50347] = { zoneID = 422, x = 0.71800005, y = 0.374 }; --Karr the Darkener
	[54323] = { zoneID = 338, x = 0.266, y = 0.66400003 }; --Kirix
	[50338] = { zoneID = 371, x = 0.43400002, y = 0.764 }; --Kor'nas Nightsavage
	[50332] = { zoneID = 379, x = 0.474, y = 0.812 }; --Korda Torros
	[70323] = { zoneID = 418, x = 0.324, y = 0.342 }; --Krakkanon
	[50363] = { zoneID = 371, x = 0.395167499780655, y = 0.626057624816895 }; --Krax'ik
	[63978] = { zoneID = 390, x = 0.0602045431733131, y = 0.585506498813629 }; --Kri'chon
	[50356] = { zoneID = 422, x = 0.72800004, y = 0.222 }; --Krol the Blade
	[69996] = { zoneID = 504, x = 0.33400002, y = 0.808 }; --Ku'lai the Skyclaw
	[73277] = { zoneID = 554, x = 0.672580301761627, y = 0.442125201225281 }; --Leafmender
	[50734] = { zoneID = 388, x = 0.41799998, y = 0.786 }; --Lith'ik the Stalker
	[50333] = { zoneID = 388, x = 0.664651691913605, y = 0.516795575618744 }; --Lon the Bull
	[70002] = { zoneID = 504, x = 0.544, y = 0.35599998 }; --Lu-Ban
	[54319] = { zoneID = 198, artID = 203, x = 0.274, y = 0.514 }; --Magria
	[50840] = { zoneID = 390, x = 0.304, y = 0.91400003 }; --Major Nanners
	[68317] = { zoneID = 418, x = 0.845799684524536, y = 0.311765968799591 }; --Mavis Harms
	[50823] = { zoneID = 371, x = 0.42400002, y = 0.38799998 }; --Mister Ferocious
	[50806] = { zoneID = 390, x = 0.378276735544205, y = 0.565828621387482 }; --Moldo One-Eye
	[70003] = { zoneID = 504, x = 0.595983922481537, y = 0.361371725797653 }; --Molthor
	[70440] = { zoneID = 508, x = 0.584, y = 0.77599996 }; --Monara
	[73166] = { zoneID = 554, x = 0.16600001, y = 0.598 }; --Monstrous Spineclaw
	[50350] = { zoneID = 371, x = 0.408, y = 0.152 }; --Morgrinn Crackfang
	[68322] = { zoneID = 418, x = 0.106829673051834, y = 0.568354487419128 }; --Muerta
	[69664] = { zoneID = 504, x = 0.35, y = 0.624 }; --Mumta
	[50364] = { zoneID = 376, x = 0.0871068835258484, y = 0.601235747337341 }; --Nal'lak the Ripper
	[50776] = { zoneID = 422, x = 0.642497837543488, y = 0.58460921049118 }; --Nalash Verdantis
	[50811] = { zoneID = 376, x = 0.883906960487366, y = 0.178552865982056 }; --Nasra Spothide
	[50789] = { zoneID = 379, x = 0.638989269733429, y = 0.137338951230049 }; --Nessos the Oracle
	[70276] = { zoneID = 508, x = 0.268, y = 0.22600001 }; --No'ku Stormsayer
	[50344] = { zoneID = 388, x = 0.538916528224945, y = 0.634905278682709 }; --Norlaxx
	[50805] = { zoneID = 422, x = 0.39200002, y = 0.624 }; --Omnis Grinlok
	[50085] = { zoneID = 241, x = 0.578, y = 0.33400002 }; --Overlord Sunderfury
	[54533] = { zoneID = 81, x = 0.20799999, y = 0.08 }; --Prince Lakma
	[69997] = { zoneID = 504, x = 0.51, y = 0.71199995 }; --Progenitus
	[50352] = { zoneID = 418, x = 0.67183256149292, y = 0.2325259745121 }; --Qu'nas
	[58771] = { zoneID = 390, x = 0.665071427822113, y = 0.393181025981903 }; --Quid
	[70530] = { zoneID = 504, x = 0.39400002, y = 0.814 }; --Ra'sha
	[72048] = { zoneID = 554, x = 0.602, y = 0.874 }; --Rattleskew
	[73157] = { zoneID = 554, x = 0.432, y = 0.314 }; --Rock Moss
	[70430] = { zoneID = 508, x = 0.396, y = 0.39200002 }; --Rocky Horror
	[50816] = { zoneID = 418, x = 0.393272221088409, y = 0.553268909454346 }; --Ruun Ghostpaw
	[50780] = { zoneID = 390, x = 0.694015204906464, y = 0.306471616029739 }; --Sahn Tidehunter
	[50783] = { zoneID = 376, x = 0.741763532161713, y = 0.503735661506653 }; --Salyin Warscout
	[50159] = { zoneID = 241, x = 0.382, y = 0.53 }; --Sambas
	[50782] = { zoneID = 371, x = 0.644578695297241, y = 0.741012692451477 }; --Sarnak
	[50831] = { zoneID = 379, x = 0.44799998, y = 0.636 }; --Scritch
	[50766] = { zoneID = 376, x = 0.544461965560913, y = 0.36332830786705 }; --Sele'na
	[63240] = { zoneID = 390, x = 0.305889517068863, y = 0.783703446388245 }; --Shadowmaster Sydow
	[50791] = { zoneID = 388, x = 0.593498051166534, y = 0.853703022003174 }; --Siltriss the Sharpener
	[50815] = { zoneID = 338, x = 0.33, y = 0.522 }; --Skarr
	[50733] = { zoneID = 379, x = 0.36400002, y = 0.796 }; --Ski'thik
	[54324] = { zoneID = 338, x = 0.19399999, y = 0.474 }; --Skitterflame
	[54321] = { zoneID = 338, x = 0.60400003, y = 0.602 }; --Solix
	[71864] = { zoneID = 554, x = 0.58, y = 0.48599997 }; --Spelurk
	[72769] = { zoneID = 554, x = 0.44, y = 0.372 }; --Spirit of Jadefire
	[58817] = { zoneID = 390, x = 0.474378854036331, y = 0.656650722026825 }; --Spirit of Lao-Fe
	[50830] = { zoneID = 418, x = 0.522, y = 0.888 }; --Spriggin
	[73704] = { zoneID = 554, x = 0.71199995, y = 0.824 }; --Stinkbraid
	[50339] = { zoneID = 376, x = 0.369444757699966, y = 0.257433742284775 }; --Sulik'shor
	[50086] = { zoneID = 241, x = 0.508, y = 0.826 }; --Tarvus the Vile
	[50832] = { zoneID = 388, artID = 400, x = 0.67615407705307, y = 0.746062636375427 }; --The Yowler
	[50388] = { zoneID = 418, x = 0.149390250444412, y = 0.352846682071686 }; --Torik-Ethis
	[72808] = { zoneID = 554, x = 0.54, y = 0.42200002 }; --Tsavo'ka
	[68320] = { zoneID = 418, x = 0.131346359848976, y = 0.662842214107513 }; --Ubunti the Shade
	[70238] = { zoneID = 508, x = 0.66400003, y = 0.286 }; --Unblinking Eye
	[73173] = { zoneID = 554, x = 0.443566411733627, y = 0.270530343055725 }; --Urdur the Cauterizer
	[50359] = { zoneID = 390, x = 0.395762115716934, y = 0.251451969146729 }; --Urgolax
	[50808] = { zoneID = 371, x = 0.572, y = 0.71599996 }; --Urobi the Walker
	[58769] = { zoneID = 390, x = 0.373783379793167, y = 0.50902932882309 }; --Vicejaw
	[63977] = { zoneID = 390, x = 0.0792632475495339, y = 0.338481426239014 }; --Vyraxxis
	[70096] = { zoneID = 502, x = 0.77599996, y = 0.82199997 }; --War-God Dokah
	[73170] = { zoneID = 554, x = 0.57585209608078, y = 0.767690479755402 }; --Watcher Osu
	[73293] = { zoneID = 554, x = 0.35, y = 0.524 }; --Whizzig
	[70126] = { zoneID = 433, x = 0.536, y = 0.82199997 }; --Willy Wilder
	[63510] = { zoneID = 390, x = 0.453419357538223, y = 0.762421667575836 }; --Wulon
	[50336] = { zoneID = 390, x = 0.880822241306305, y = 0.443360209465027 }; --Yorik Sharpeye
	[50820] = { zoneID = 388, x = 0.318518072366715, y = 0.619663238525391 }; --Yul Wildpaw
	[50769] = { zoneID = 379, x = 0.732, y = 0.764 }; --Zai the Outcast
	[69769] = { zoneID = { 
					[422] = { x = 0.476, y = 0.616 }; 
					[388] = { x = 0.366 , y = 0.856 };
					[418] = { x = 0.398, y = 0.656 };
					[379] = { x = 0.75, y = 0.676 };
					[371] = { x = 0.526, y = 0.19 };
			  } }; --Zandalari Warbringer cian
	[69842] = { zoneID = { 
					[422] = { x = 0.476, y = 0.616 }; 
					[388] = { x = 0.366 , y = 0.856 };
					[418] = { x = 0.398, y = 0.656 };
					[379] = { x = 0.75, y = 0.676 };
					[371] = { x = 0.526, y = 0.19 };
			  } }; --Zandalari Warbringer gray
	[69841] = { zoneID = { 
					[422] = { x = 0.476, y = 0.616 }; 
					[388] = { x = 0.366 , y = 0.856 };
					[418] = { x = 0.398, y = 0.656 };
					[379] = { x = 0.75, y = 0.676 };
					[371] = { x = 0.526, y = 0.19 };
			  } }; --Zandalari Warbringer silver
	[69768] = { zoneID = {
					[422] = { x = 0.536 , y = 0.666 };
					[388] = { x = 0.436 , y = 0.908 };
					[418] = { x = 0.362, y = 0.602 };
					[379] = { x = 0.662, y = 0.65 };
					[371] = { x = 0.532, y = 0.306 };
			  } }; --Zandalari Warscout
	[69843] = { zoneID = 508, x = 0.874, y = 0.532 }; --Zao'cho
	[72245] = { zoneID = 554, x = 0.472482472658157, y = 0.88034975528717 }; --Zesqua
	[71919] = { zoneID = 554, x = 0.374577552080154, y = 0.774188995361328 }; --Zhu-Gon the Sour
	[77140] = { zoneID = 539, x = 0.294, y = 0.29799998 }; --Amaukwa
	[82899] = { zoneID = 550, x = 0.84599996, y = 0.53400004 }; --Ancient Blademaster
	[86213] = { zoneID = 539, x = 0.508, y = 0.79 }; --Aqualir
	[88043] = { zoneID = 535, x = 0.447006523609161, y = 0.348047524690628 }; --Avatar of Socrethar
	[82326] = { zoneID = 539, x = 0.528, y = 0.16399999 }; --Ba'ruun
	[81406] = { zoneID = 539, x = 0.299960434436798, y = 0.0705062001943588 }; --Bahameye
	[82085] = { zoneID = 543, x = 0.4, y = 0.79 }; --Bashiok
	[78150] = { zoneID = 525, x = 0.574, y = 0.374 }; --Beastcarver Saramor
	[84887] = { zoneID = 542, x = 0.582, y = 0.84599996 }; --Betsi Boombasket
	[80614] = { zoneID = 542, x = 0.468172639608383, y = 0.232453018426895 }; --Blade-Dancer Aeryx
	[84856] = { zoneID = 542, artID = 559, x = 0.652028441429138, y = 0.680062651634216 }; --Blightglow
	[81639] = { zoneID = 539, x = 0.44799998, y = 0.76199996 }; --Brambleking Fili
	[78867] = { zoneID = 525, x = 0.268, y = 0.49400002 }; --Breathless
	[87234] = { zoneID = 550, x = 0.43, y = 0.36200002 }; --Brutag Grimblade
	[71721] = { zoneID = 525, x = 0.338, y = 0.23 }; --Canyon Icemother
	[82311] = { zoneID = 543, x = 0.534361600875855, y = 0.447248131036758 }; --Char the Burning
	[80242] = { zoneID = 525, x = 0.412, y = 0.682 }; --Chillfang
	[72294] = { zoneID = 525, x = 0.404, y = 0.47 }; --Cindermaw
	[78169] = { zoneID = 525, x = 0.564, y = 0.382 }; --Cloudspeaker Daber
	[77513] = { zoneID = 525, x = 0.254, y = 0.544 }; --Coldstomp the Griever
	[76914] = { zoneID = 525, x = 0.541958034038544, y = 0.679459929466248 }; --Coldtusk
	[77620] = { zoneID = 535, x = 0.372, y = 0.70199996 }; --Cro Fleshrender
	[78621] = { zoneID = 525, x = 0.66400003, y = 0.77199996 }; --Cyclonic Fury
	[77085] = { zoneID = 539, x = 0.48400003, y = 0.43400002 }; --Dark Emanation
	[82268] = { zoneID = 539, x = 0.38799998, y = 0.824 }; --Darkmaster Go'vid
	[82411] = { zoneID = 539, x = 0.49400002, y = 0.41799998 }; --Darktalon
	[77763] = { zoneID = 0 }; --Deadshot Kizi
	[82058] = { zoneID = 543, x = 0.72199994, y = 0.408 }; --Depthroot
	[86729] = { zoneID = 550, x = 0.602, y = 0.384 }; --Direhoof
	[77561] = { zoneID = 535, x = 0.682, y = 0.158 }; --Dr. Gloom
	[84807] = { zoneID = 542, x = 0.46400002, y = 0.284 }; --Durkath Steelmaw
	[77768] = { zoneID = 0 }; --Elementalist Utrah
	[82676] = { zoneID = 539, x = 0.67800003, y = 0.638 }; --Enavra
	[82742] = { zoneID = 539, x = 0.67800003, y = 0.638 }; --Enavra
	[82207] = { zoneID = 539, x = 0.616, y = 0.618 }; --Faebright
	[82975] = { zoneID = 550, x = 0.748, y = 0.118 }; --Fangler
	[80204] = { zoneID = 535, x = 0.492, y = 0.834 }; --Felbark
	[82992] = { zoneID = 535, x = 0.478, y = 0.33 }; --Felfire Consort
	[84890] = { zoneID = 542, x = 0.548, y = 0.39400002 }; --Festerbloom
	[74971] = { zoneID = 525, x = 0.714, y = 0.468 }; --Firefury Giant
	[88580] = { zoneID = 543, x = 0.578, y = 0.36400002 }; --Firestarter Grash
	[83483] = { zoneID = 550, x = 0.698248207569122, y = 0.419404953718185 }; --Flinthide
	[77648] = { zoneID = 0 }; --Forge Matron Targa
	[85250] = { zoneID = 543, x = 0.573517560958862, y = 0.686412930488586 }; --Fossilwood the Petrified
	[77614] = { zoneID = 535, x = 0.462, y = 0.55 }; --Frenzied Golem
	[78713] = { zoneID = 535, x = 0.56200004, y = 0.65400004 }; --Galzomar
	[82764] = { zoneID = 550, x = 0.522, y = 0.55799997 }; --Gar'lua
	[86058] = { zoneID = 0 }; --Garrison Ford
	[81038] = { zoneID = 543, x = 0.41799998, y = 0.45400003 }; --Gelgor of the Blue Flame
	[82882] = { zoneID = 588, x = 0.462, y = 0.218 }; --General Aevd
	[80471] = { zoneID = 535, x = 0.674, y = 0.804 }; --Gennadian
	[71665] = { zoneID = 525, x = 0.547116875648499, y = 0.223778963088989 }; --Giant-Slayer Kul
	[78144] = { zoneID = 525, x = 0.574, y = 0.374 }; --Giantslayer Kimla
	[77719] = { zoneID = 535, x = 0.304, y = 0.64 }; --Glimmerwing
	[80868] = { zoneID = 543, x = 0.46, y = 0.508 }; --Glut
	[82778] = { zoneID = 550, x = 0.666808009147644, y = 0.563355982303619 }; --Gnarlhoof the Rabid
	[76380] = { zoneID = 539, x = 0.33200002, y = 0.352 }; --Gorum
	[82876] = { zoneID = 588, artID = 611, x = 0.45200002, y = 0.794 }; --Grand Marshal Tremblade
	[82758] = { zoneID = 550, x = 0.66800004, y = 0.512 }; --Greatfeather
	[84431] = { zoneID = 543, x = 0.468, y = 0.432 }; --Greldrok the Cunning
	[82912] = { zoneID = 550, x = 0.89468115568161, y = 0.728309214115143 }; --Grizzlemaw
	[78128] = { zoneID = 525, x = 0.574, y = 0.376 }; --Gronnstalker Dawarn
	[88583] = { zoneID = 543, x = 0.59599996, y = 0.43 }; --Grove Warden Yal
	[80312] = { zoneID = 525, x = 0.384, y = 0.63 }; --Grutush the Pillager
	[80190] = { zoneID = 525, x = 0.504, y = 0.524 }; --Gruuk
	[80235] = { zoneID = 525, artID = 542, x = 0.47, y = 0.552 }; --Gurun
	[83008] = { zoneID = 535, x = 0.478, y = 0.256 }; --Haakun the All-Consuming
	[77715] = { zoneID = 535, x = 0.616644680500031, y = 0.441820740699768 }; --Hammertooth
	[77626] = { zoneID = 535, x = 0.769001364707947, y = 0.51526403427124 }; --Hen-Mother Hami
	[86724] = { zoneID = 542, x = 0.592816650867462, y = 0.148492470383644 }; --Hermit Palefur
	[82877] = { zoneID = 588, x = 0.462, y = 0.218 }; --High Warlord Volrath
	[88672] = { zoneID = 543, x = 0.548, y = 0.462 }; --Hunter Bal'ra
	[83603] = { zoneID = 550, x = 0.804, y = 0.304 }; --Hunter Blacktooth
	[78151] = { zoneID = 525, x = 0.564, y = 0.382 }; --Huntmaster Kuang
	[78161] = { zoneID = 550, x = 0.87, y = 0.548 }; --Hyperious
	[83553] = { zoneID = 539, x = 0.574, y = 0.48400003 }; --Insha'tar
	[82616] = { zoneID = 525, x = 0.482, y = 0.24200001 }; --Jabberjaw
	[87600] = { zoneID = 525, x = 0.85, y = 0.522 }; --Jaluk the Pacifist
	[84955] = { zoneID = 542, artID = 559, x = 0.56456732749939, y = 0.947757005691528 }; --Jiasska the Sporegorger
	[84810] = { zoneID = 542, x = 0.628, y = 0.374 }; --Kalos the Bloodbathed
	[86959] = { zoneID = 550, x = 0.458, y = 0.348 }; --Karosh Blackwind
	[78710] = { zoneID = 535, x = 0.56200004, y = 0.65400004 }; --Kharazos the Triumphant
	[74206] = { zoneID = 539, x = 0.406, y = 0.44599998 }; --Killmaw
	[78872] = { zoneID = 535, x = 0.66800004, y = 0.85400003 }; --Klikixx
	[72362] = { zoneID = 539, x = 0.322, y = 0.35 }; --Ku'targ the Voidseer
	[85121] = { zoneID = 539, x = 0.48, y = 0.774 }; --Lady Temptessa
	[72537] = { zoneID = 539, x = 0.376877993345261, y = 0.144014567136765 }; --Leaf-Reader Kurri
	[77784] = { zoneID = 535, x = 0.49201712012291, y = 0.923121631145477 }; --Lo'marg Jawcrusher
	[82920] = { zoneID = 535, x = 0.31, y = 0.268 }; --Lord Korinak
	[77310] = { zoneID = 539, x = 0.44799998, y = 0.20799999 }; --Mad "King" Sporeon
	[83643] = { zoneID = 550, x = 0.811054170131683, y = 0.598539710044861 }; --Malroc Stonesunder
	[84406] = { zoneID = 543, x = 0.506, y = 0.532 }; --Mandrakor
	[82878] = { zoneID = 588, artID = 611, x = 0.45200002, y = 0.794 }; --Marshal Gabriel
	[82880] = { zoneID = 588, artID = 611, x = 0.45200002, y = 0.794 }; --Marshal Karsh Stormforge
	[82998] = { zoneID = 535, x = 0.387516796588898, y = 0.497878015041351 }; --Matron of Sin
	[82362] = { zoneID = 539, x = 0.384, y = 0.704 }; --Morva Soultwister
	[76473] = { zoneID = 543, x = 0.53400004, y = 0.78199995 }; --Mother Araneae
	[75071] = { zoneID = 539, x = 0.438, y = 0.576 }; --Mother Om'ra
	[84417] = { zoneID = 542, artID = 559, x = 0.539148271083832, y = 0.885188937187195 }; --Mutafen
	[82247] = { zoneID = 542, x = 0.36200002, y = 0.524 }; --Nas Dunberlin
	[79334] = { zoneID = 535, x = 0.85800004, y = 0.292 }; --No'losh
	[83409] = { zoneID = 550, x = 0.39, y = 0.5 }; --Ophiis
	[84872] = { zoneID = 542, x = 0.65, y = 0.54 }; --Oskiira the Vengeful
	[83680] = { zoneID = 550, x = 0.618, y = 0.69 }; --Outrider Duretha
	[78606] = { zoneID = 525, x = 0.282, y = 0.66400003 }; --Pale Fishmonger
	[78134] = { zoneID = 525, x = 0.574, y = 0.376 }; --Pathfinder Jalog
	[77095] = { zoneID = 0 }; --Pathstalker Draga
	[88208] = { zoneID = 550, x = 0.58, y = 0.186 }; --Pit Beast
	[84838] = { zoneID = 542, x = 0.59400004, y = 0.374 }; --Poisonmaster Bortusk
	[76918] = { zoneID = 525, x = 0.37, y = 0.336 }; --Primalist Mur'og
	[77642] = { zoneID = 0 }; --Pyrecaster Zindra
	[77741] = { zoneID = 535, x = 0.59400004, y = 0.59400004 }; --Ra'kahn
	[84392] = { zoneID = 525, x = 0.86800003, y = 0.49 }; --Ragore Driftstalker
	[82374] = { zoneID = 539, x = 0.48599997, y = 0.22600001 }; --Rai'vosh
	[82755] = { zoneID = 550, x = 0.735717654228211, y = 0.579804122447968 }; --Redclaw the Feral
	[85504] = { zoneID = 542, x = 0.38390064239502, y = 0.279721200466156 }; --Rotcap
	[84833] = { zoneID = 542, x = 0.688, y = 0.49 }; --Sangrikass
	[77526] = { zoneID = 525, x = 0.765559434890747, y = 0.63541454076767 }; --Scout Goreseeker
	[83542] = { zoneID = 550, x = 0.608, y = 0.478 }; --Sean Whitesea
	[79938] = { zoneID = 542, x = 0.518, y = 0.354 }; --Shadowbark
	[82415] = { zoneID = 539, x = 0.59, y = 0.57 }; --Shinri
	[78715] = { zoneID = 535, x = 0.56200004, y = 0.64 }; --Sikthiss, Maiden of Slaughter
	[79686] = { zoneID = 539, x = 0.614, y = 0.68 }; --Silverleaf Ancient
	[79693] = { zoneID = 539, x = 0.614, y = 0.676 }; --Silverleaf Ancient
	[79692] = { zoneID = 539, x = 0.614, y = 0.674 }; --Silverleaf Ancient
	[83990] = { zoneID = 542, x = 0.519718766212463, y = 0.0725577026605606 }; --Solar Magnifier
	[80057] = { zoneID = 550, x = 0.754, y = 0.65199995 }; --Soulfang
	[86549] = { zoneID = 535, x = 0.674, y = 0.35599998 }; --Steeltusk
	[79629] = { zoneID = 543, x = 0.381577432155609, y = 0.662827372550964 }; --Stomper Kreego
	[84805] = { zoneID = 542, x = 0.33400002, y = 0.22 }; --Stonespite
	[80725] = { zoneID = 543, x = 0.39400002, y = 0.60400003 }; --Sulfurious
	[86137] = { zoneID = 543, x = 0.44599998, y = 0.922 }; --Sunclaw
	[84912] = { zoneID = 542, x = 0.584, y = 0.45200002 }; --Sunderthorn
	[85520] = { zoneID = 542, x = 0.528, y = 0.548 }; --Swarmleaf
	[88582] = { zoneID = 543, x = 0.59599996, y = 0.318 }; --Swift Onyx Flayer
	[84836] = { zoneID = 542, x = 0.544, y = 0.632 }; --Talonbreaker
	[79485] = { zoneID = 535, x = 0.538, y = 0.91 }; --Talonpriest Zorkra
	[84775] = { zoneID = 542, x = 0.572, y = 0.73800004 }; --Tesska the Broken
	[77527] = { zoneID = 525, x = 0.269196152687073, y = 0.319046556949616 }; --The Beater
	[82618] = { zoneID = 525, x = 0.43400002, y = 0.09 }; --Tor'goroth
	[83591] = { zoneID = 550, artID = 567, x = 0.648938357830048, y = 0.391267091035843 }; --Tura'aka
	[82050] = { zoneID = 542, x = 0.294, y = 0.414 }; --Varasha
	[75482] = { zoneID = 539, x = 0.214, y = 0.20799999 }; --Veloss
	[85078] = { zoneID = 542, x = 0.73, y = 0.304 }; --Voidreaver Urnae
	[83385] = { zoneID = 539, x = 0.32599998, y = 0.414 }; --Voidseer Kalurg
	[77926] = { zoneID = 0 }; --Vulceros
	[77776] = { zoneID = 535, x = 0.694, y = 0.33200002 }; --Wandering Vindicator
	[78733] = { zoneID = 0 }; --Warcaster Bargol
	[79024] = { zoneID = 550, x = 0.826, y = 0.76199996 }; --Warmaster Blugthol
	[75434] = { zoneID = 539, x = 0.426, y = 0.406 }; --Windfang Matriarch
	[82922] = { zoneID = 535, x = 0.372, y = 0.144 }; --Xothear, the Destroyer
	[79145] = { zoneID = 525, x = 0.404, y = 0.274 }; --Yaga the Scarred
	[77529] = { zoneID = 535, x = 0.538111388683319, y = 0.256903469562531 }; --Yazheera the Incinerator
	[75435] = { zoneID = 539, x = 0.48400003, y = 0.65400004 }; --Yggdrel
	[71992] = { zoneID = 407, x = 0.39200002, y = 0.45599997 }; --Moonfang
	[84875] = { zoneID = 588, x = 0.34, y = 0.50200003 }; --Ancient Inferno
	[83819] = { zoneID = 588, artID = 611, x = 0.618, y = 0.30200002 }; --Brickhouse
	[84911] = { zoneID = 539, x = 0.46, y = 0.714 }; --Demidos
	[85771] = { zoneID = 588, x = 0.59, y = 0.42400002 }; --Elder Darkweaver Kath
	[84893] = { zoneID = 588, x = 0.344, y = 0.532 }; --Goregore
	[84110] = { zoneID = 588, x = 0.37, y = 0.66400003 }; --Korthall Soulgorger
	[82988] = { zoneID = 535, x = 0.375238209962845, y = 0.375037252902985 }; --Kurlosh Doomfang
	[82942] = { zoneID = 535, x = 0.33400002, y = 0.378 }; --Lady Demlash
	[83683] = { zoneID = 588, x = 0.30200002, y = 0.314 }; --Mandragoraster
	[84904] = { zoneID = 588, x = 0.318, y = 0.492 }; --Oraggro
	[87668] = { zoneID = 535, x = 0.313572734594345, y = 0.47584456205368 }; --Orumo the Observer
	[83691] = { zoneID = 588, x = 0.584, y = 0.58 }; --Panthora
	[82930] = { zoneID = 535, x = 0.41, y = 0.42 }; --Shadowflame Terrorwalker
	[83713] = { zoneID = 588, x = 0.33400002, y = 0.498 }; --Titarus
	[88436] = { zoneID = 535, x = 0.377649903297424, y = 0.433884590864182 }; --Vigilant Paarthos
	[88072] = { zoneID = 535, x = 0.436, y = 0.266 }; --Archmagus Tekar
	[87597] = { zoneID = 535, x = 0.43, y = 0.38 }; --Bombardier Gu'gok
	[84746] = { zoneID = 588, x = 0.544, y = 0.32 }; --Captured Gor'vosh Stoneshaper
	[85767] = { zoneID = 588, x = 0.52, y = 0.406 }; --Cursed Harbinger
	[85763] = { zoneID = 588, x = 0.55, y = 0.38799998 }; --Cursed Ravager
	[85766] = { zoneID = 588, x = 0.49, y = 0.37 }; --Cursed Sharptalon
	[87352] = { zoneID = 525, x = 0.666, y = 0.254 }; --Gibblette the Cowardly
	[87362] = { zoneID = 588, x = 0.474, y = 0.69 }; --Gibby
	[83019] = { zoneID = 535, x = 0.475419759750366, y = 0.392842352390289 }; --Gug'tol
	[87348] = { zoneID = 525, x = 0.680850386619568, y = 0.198713853955269 }; --Hoarfrost
	[88494] = { zoneID = 535, x = 0.378, y = 0.206 }; --Legion Vanguard
	[85001] = { zoneID = 539, x = 0.514, y = 0.768 }; --Master Sergeant Milgra
	[82614] = { zoneID = 525, x = 0.42400002, y = 0.214 }; --Moltnoma
	[87351] = { zoneID = 525, x = 0.72199994, y = 0.22799999 }; --Mother of Goren
	[84925] = { zoneID = 539, x = 0.5, y = 0.72400004 }; --Quartermaster Hershak
	[85029] = { zoneID = 539, x = 0.482, y = 0.808 }; --Shadowspeaker Niir
	[82617] = { zoneID = 525, x = 0.44599998, y = 0.152 }; --Slogtusk the Corpse-Eater
	[82620] = { zoneID = 525, x = 0.384, y = 0.16399999 }; --Son of Goramal
	[88083] = { zoneID = 535, x = 0.436, y = 0.266 }; --Soulbinder Naylana
	[88071] = { zoneID = 535, x = 0.436, y = 0.27 }; --Strategist Ankor
	[78265] = { zoneID = 525, x = 0.72199994, y = 0.33 }; --The Bone Crawler
	[86579] = { zoneID = 543, x = 0.458, y = 0.324 }; --Blademaster Ro'gor
	[86566] = { zoneID = 543, x = 0.482544153928757, y = 0.208264529705048 }; --Defector Dazgo
	[86571] = { zoneID = 543, x = 0.497573018074036, y = 0.23431009054184 }; --Durp the Hated
	[82536] = { zoneID = 525, x = 0.38, y = 0.14 }; --Gorivax
	[86577] = { zoneID = 543, x = 0.45599997, y = 0.254 }; --Horgg
	[86574] = { zoneID = 543, x = 0.47599998, y = 0.308 }; --Inventor Blammo
	[86562] = { zoneID = 543, x = 0.49, y = 0.33 }; --Maniacal Madgard
	[86582] = { zoneID = 543, x = 0.458, y = 0.24 }; --Morgo Kain
	[77081] = { zoneID = 616, x = 0.354, y = 0.374 }; --The Lanticore
	[87357] = { zoneID = 525, x = 0.688, y = 0.282 }; --Valkor
	[87356] = { zoneID = 525, x = 0.704, y = 0.39200002 }; --Vrok the Ancient
	[82883] = { zoneID = 588, x = 0.46400002, y = 0.216 }; --Warlord Noktyn
	[84378] = { zoneID = 525, x = 0.884924411773682, y = 0.574636936187744 }; --Ak'ox the Slaughterer
	[86268] = { zoneID = 543, x = 0.56200004, y = 0.408 }; --Alkali
	[85568] = { zoneID = 539, x = 0.67, y = 0.84199995 }; --Avalanche
	[87837] = { zoneID = 550, x = 0.400321841239929, y = 0.131717354059219 }; --Bonebreaker
	[84926] = { zoneID = 588, x = 0.318, y = 0.50200003 }; --Burning Power
	[87788] = { zoneID = 550, x = 0.354, y = 0.21200001 }; --Durg Spinecrusher
	[87019] = { zoneID = 542, x = 0.744, y = 0.43400002 }; --Gluttonous Giant
	[78269] = { zoneID = 543, x = 0.528, y = 0.53400004 }; --Gnarljaw
	[72364] = { zoneID = 525, x = 0.708, y = 0.276 }; --Gorg'ak the Lava Guzzler
	[87344] = { zoneID = 550, x = 0.42200002, y = 0.366 }; --Gortag Steelgrip
	[78260] = { zoneID = 543, x = 0.522, y = 0.554 }; --King Slime
	[87239] = { zoneID = 550, x = 0.42400002, y = 0.36400002 }; --Krahl Deadeye
	[84465] = { zoneID = 588, x = 0.554, y = 0.75 }; --Leaping Gorger
	[85451] = { zoneID = 539, x = 0.294, y = 0.51 }; --Malgosh Shadowkeeper
	[87026] = { zoneID = 542, x = 0.744, y = 0.384 }; --Mecha Plunderer
	[88586] = { zoneID = 543, x = 0.614, y = 0.39200002 }; --Mogamago
	[84435] = { zoneID = 550, x = 0.45599997, y = 0.152 }; --Mr. Pinchy Sr.
	[85555] = { zoneID = 539, x = 0.60400003, y = 0.9 }; --Nagidna
	[87027] = { zoneID = 542, x = 0.714, y = 0.33200002 }; --Shadow Hulk
	[84854] = { zoneID = 588, x = 0.308, y = 0.3 }; --Slippery Slime
	[85837] = { zoneID = 539, x = 0.614, y = 0.886 }; --Slivermaw
	[85026] = { zoneID = 542, x = 0.72400004, y = 0.19399999 }; --Soul-Twister Torek
	[79104] = { zoneID = 525, x = 0.404, y = 0.124 }; --Ug'lok the Frozen
	[84196] = { zoneID = 588, x = 0.35, y = 0.606 }; --Web-wrapped Soldier
	[86774] = { zoneID = 550, x = 0.515765070915222, y = 0.160630822181702 }; --Aogexon
	[86257] = { zoneID = 543, x = 0.692, y = 0.44599998 }; --Basten
	[86732] = { zoneID = 550, x = 0.61, y = 0.122 }; --Bergruu
	[72156] = { zoneID = 525, x = 0.626, y = 0.42400002 }; --Borrok the Devourer
	[86743] = { zoneID = 550, x = 0.644, y = 0.304 }; --Dekorhan
	[80372] = { zoneID = 542, x = 0.692, y = 0.538 }; --Echidna
	[86771] = { zoneID = 550, x = 0.481411159038544, y = 0.220682844519615 }; --Gagrog the Brutal
	[80398] = { zoneID = 534, x = 0.398, y = 0.82 }; --Keravnos
	[88210] = { zoneID = 550, x = 0.582, y = 0.12 }; --Krud the Eviscerator
	[80370] = { zoneID = 550, x = 0.52, y = 0.898 }; --Lernaea
	[87666] = { zoneID = 550, x = 0.340372025966644, y = 0.514862060546875 }; --Mu'gra
	[86258] = { zoneID = 543, x = 0.694, y = 0.444 }; --Nultra
	[87846] = { zoneID = 550, x = 0.39400002, y = 0.144 }; --Pit Slayer
	[86750] = { zoneID = 550, x = 0.521128654479981, y = 0.403329789638519 }; --Thek'talon
	[80371] = { zoneID = 543, x = 0.754, y = 0.42400002 }; --Typhon
	[86259] = { zoneID = 543, x = 0.694, y = 0.444 }; --Valstil
	[86266] = { zoneID = 543, x = 0.634, y = 0.306 }; --Venolasix
	[88951] = { zoneID = 550, x = 0.372358560562134, y = 0.389896184206009 }; --Vileclaw
	[86835] = { zoneID = 550, x = 0.414, y = 0.45 }; --Xelganak
	[79725] = { zoneID = 550, x = 0.344, y = 0.77 }; --Captain Ironbeard
	[80122] = { zoneID = 550, x = 0.43400002, y = 0.77599996 }; --Gaz'orda
	[83401] = { zoneID = 550, x = 0.474, y = 0.70199996 }; --Netherspawn
	[83526] = { zoneID = 550, x = 0.578, y = 0.83800006 }; --Ru'klaa
	[83428] = { zoneID = 550, x = 0.704, y = 0.292 }; --Windcaller Korast
	[82826] = { zoneID = 550, x = 0.764, y = 0.644 }; --Berserk T-300 Series Mark II
	[82486] = { zoneID = 550, x = 0.888, y = 0.412 }; --Explorer Nozzand
	[83509] = { zoneID = 550, x = 0.932, y = 0.282 }; --Gorepetal
	[84263] = { zoneID = 550, x = 0.834, y = 0.37 }; --Graveltooth
	[83634] = { zoneID = 550, x = 0.548, y = 0.612 }; --Scout Pokhar
	[86978] = { zoneID = 542, x = 0.252, y = 0.24200001 }; --Gaze
	[84951] = { zoneID = 542, x = 0.33400002, y = 0.588 }; --Gobblefin
	[85572] = { zoneID = 535, x = 0.222, y = 0.742 }; --Grrbrrgle
	[77664] = { zoneID = 535, x = 0.36400002, y = 0.96 }; --Aarko
	[77828] = { zoneID = 535, x = 0.34, y = 0.572 }; --Echo of Murmur
	[77795] = { zoneID = 535, x = 0.341386169195175, y = 0.57202810049057 }; --Echo of Murmur
	[79543] = { zoneID = 535, x = 0.428, y = 0.542 }; --Shirzir
	[77634] = { zoneID = 535, x = 0.588, y = 0.876 }; --Taladorantula
	[80524] = { zoneID = 535, x = 0.636, y = 0.20799999 }; --Underseer Bloodmane
	[85264] = { zoneID = 543, x = 0.478, y = 0.412 }; --Rolkor
	[86410] = { zoneID = 543, x = 0.63, y = 0.616 }; --Sylldross
	[83522] = { zoneID = 543, x = 0.5240718126297, y = 0.701434016227722 }; --Hive Queen Skrikka
	[74613] = { zoneID = 525, x = 0.65400004, y = 0.314 }; --Broodmother Reeg'ak
	[77519] = { zoneID = 525, x = 0.576101720333099, y = 0.375438034534454 }; --Giantbane
	[86689] = { zoneID = 539, x = 0.274, y = 0.43400002 }; --Sneevel
	[86520] = { zoneID = 543, x = 0.548993408679962, y = 0.71173769235611 }; --Stompalupagus
	[85907] = { zoneID = 543, x = 0.39400002, y = 0.746 }; --Berthora
	[85970] = { zoneID = 543, x = 0.375622749328613, y = 0.814759433269501 }; --Riptar
	[79524] = { zoneID = 539, x = 0.374, y = 0.488 }; --Hypnocroak
	[72606] = { zoneID = 539, x = 0.528, y = 0.508 }; --Rockhoof
	[75492] = { zoneID = 539, x = 0.546, y = 0.70199996 }; --Venomshade
	[50990] = { zoneID = 550, x = 0.49, y = 0.342 }; --Nakk the Thunderer
	[50992] = { zoneID = 525, x = 0.634, y = 0.796 }; --Gorok
	[50981] = { zoneID = 550, x = 0.66400003, y = 0.432 }; --Luk'hok
	[50985] = { zoneID = 543, x = 0.42, y = 0.25 }; --Poundfist
	[51015] = { zoneID = 535, x = 0.544, y = 0.81 }; --Silthide
	[50883] = { zoneID = 539, x = 0.39200002, y = 0.378 }; --Pathrunner
	[81001] = { zoneID = 525, x = 0.132, y = 0.504 }; --Nok-Karosh
	[91871] = { zoneID = 534, x = 0.524, y = 0.402 }; --Argosh the Destroyer
	[92552] = { zoneID = 534, x = 0.354, y = 0.46400002 }; --Belgork
	[90884] = { zoneID = 534, x = 0.236, y = 0.52 }; --Bilkor the Thrower
	[92657] = { zoneID = 534, x = 0.508980453014374, y = 0.742322683334351 }; --Bleeding Hollow Horror
	[90936] = { zoneID = 534, x = 0.21, y = 0.524 }; --Bloodhunter Zulk
	[92429] = { zoneID = 534, x = 0.576, y = 0.672 }; --Broodlord Ixkor
	[93264] = { zoneID = 534, x = 0.48400003, y = 0.572 }; --Captain Grok'mar
	[93076] = { zoneID = 534, x = 0.35799998, y = 0.8 }; --Captain Ironbeard
	[90434] = { zoneID = 534, x = 0.315126210451126, y = 0.679607272148132 }; --Ceraxas
	[90519] = { zoneID = 534, x = 0.444, y = 0.374 }; --Cindral the Wildfire
	[90081] = { zoneID = 0 }; --Dark Summoner Rendkra
	[90887] = { zoneID = 534, x = 0.22799999, y = 0.488 }; --Dorg the Bloody
	[93028] = { zoneID = 534, x = 0.2, y = 0.536 }; --Driss Vile
	[90888] = { zoneID = 534, x = 0.25657045841217, y = 0.461195737123489 }; --Drivnul
	[91727] = { zoneID = 534, x = 0.496, y = 0.366 }; --Executor Riloth
	[93168] = { zoneID = 534, x = 0.286099493503571, y = 0.507739901542664 }; --Felbore
	[92647] = { zoneID = 534, x = 0.458, y = 0.47 }; --Felsmith Damorka
	[91098] = { zoneID = 534, x = 0.522, y = 0.274 }; --Felspark
	[92508] = { zoneID = 534, x = 0.634, y = 0.81 }; --Gloomtalon
	[92941] = { zoneID = 534, x = 0.324, y = 0.35599998 }; --Gorabosh
	[91695] = { zoneID = 534, x = 0.462, y = 0.408 }; --Grand Warlock Nethekurse
	[93057] = { zoneID = 534, x = 0.16, y = 0.592 }; --Grannok
	[90089] = { zoneID = 0 }; --Grobthok Skullbreaker
	[90094] = { zoneID = 534, x = 0.39400002, y = 0.324 }; --Harbormaster Korak
	[90281] = { zoneID = 0 }; --High Priest Ikzan
	[90777] = { zoneID = 534, x = 0.204, y = 0.4 }; --High Priest Ikzan
	[90429] = { zoneID = 534, x = 0.308, y = 0.714 }; --Imp-Master Valessa
	[90087] = { zoneID = 0 }; --Iron Captain Argha
	[90437] = { zoneID = 534, x = 0.264, y = 0.754 }; --Jax'zor
	[92517] = { zoneID = 534, x = 0.520345211029053, y = 0.83930504322052 }; --Krell the Serene
	[93279] = { zoneID = 534, x = 0.395832985639572, y = 0.681247651576996 }; --Kris'kar the Unredeemed
	[90438] = { zoneID = 534, x = 0.254, y = 0.764 }; --Lady Oran
	[93002] = { zoneID = 534, x = 0.522, y = 0.65199995 }; --Magwia
	[90442] = { zoneID = 534, x = 0.258, y = 0.796 }; --Mistress Thavra
	[90088] = { zoneID = 0 }; --Ormak Bloodbolt
	[92411] = { zoneID = 534, x = 0.522, y = 0.198 }; --Overlord Ma'gruth
	[92274] = { zoneID = 534, x = 0.53400004, y = 0.214 }; --Painmistress Selora
	[91374] = { zoneID = 534, x = 0.168, y = 0.48400003 }; --Podlord Wakkawam
	[91009] = { zoneID = 534, x = 0.57, y = 0.23 }; --Putre'thar
	[90782] = { zoneID = 534, x = 0.173880502581596, y = 0.428130924701691 }; --Rasthe
	[92197] = { zoneID = 534, x = 0.26271203160286, y = 0.542484879493713 }; --Relgor
	[91227] = { zoneID = 534, x = 0.222, y = 0.504 }; --Remnant of the Blood Moon
	[92627] = { zoneID = 534, x = 0.39200002, y = 0.708 }; --Rendrak
	[90885] = { zoneID = 534, x = 0.204, y = 0.498 }; --Rogond the Tracker
	[94113] = { zoneID = 588, x = 0.41799998, y = 0.46400002 }; --Rukmaz
	[90024] = { zoneID = 534, x = 0.414, y = 0.376 }; --Sergeant Mor'grak
	[93236] = { zoneID = 534, x = 0.497806191444397, y = 0.61315780878067 }; --Shadowthrash
	[92495] = { zoneID = 534, x = 0.626843094825745, y = 0.720392882823944 }; --Soulslicer
	[92887] = { zoneID = 534, x = 0.65400004, y = 0.36400002 }; --Steelsnout
	[92606] = { zoneID = 534, x = 0.409607827663422, y = 0.78848272562027 }; --Sylissa
	[93001] = { zoneID = 534, x = 0.158, y = 0.576 }; --Szirek the Twisted
	[92465] = { zoneID = 534, x = 0.492, y = 0.734 }; --The Blackfang
	[92694] = { zoneID = 534, x = 0.344, y = 0.72400004 }; --The Goreclaw
	[92977] = { zoneID = 534, x = 0.124, y = 0.568 }; --The Iron Houndmaster
	[92645] = { zoneID = 534, x = 0.374, y = 0.67800003 }; --The Night Haunter
	[92636] = { zoneID = 534, x = 0.378, y = 0.726 }; --The Night Haunter
	[91243] = { zoneID = 534, x = 0.134, y = 0.564 }; --Tho'gar Gorefist
	[92574] = { zoneID = 534, x = 0.34, y = 0.444 }; --Thromma the Gutslicer
	[92451] = { zoneID = 534, x = 0.274, y = 0.32599998 }; --Varyx the Damned
	[92408] = { zoneID = 534, x = 0.602, y = 0.21 }; --Xanzith the Everlasting
	[91087] = { zoneID = 534, x = 0.482, y = 0.284 }; --Zeter'el
	[90122] = { zoneID = 534, x = 0.37, y = 0.33 }; --Zoug the Heavy
	[91093] = { zoneID = 534, x = 0.410303235054016, y = 0.685073614120483 }; --Bramblefell
	[91232] = { zoneID = 534, x = 0.15, y = 0.542 }; --Commander Krag'goth
	[89675] = { zoneID = 534, x = 0.474, y = 0.44799998 }; --Commander Org'mok
	[95053] = { zoneID = 534, x = 0.22799999, y = 0.39400002 }; --Deathtalon
	[95056] = { zoneID = 534, x = 0.47, y = 0.524 }; --Doomroller
	[93125] = { zoneID = 534, x = 0.344, y = 0.77599996 }; --Glub'glok
	[95044] = { zoneID = 534, x = 0.134, y = 0.59400004 }; --Terrorfist
	[95054] = { zoneID = 534, x = 0.324, y = 0.73800004 }; --Vengeance
	[91921] = { zoneID = 588, x = 0.54, y = 0.58 }; --Wyrmple
	[96235] = { zoneID = 534, x = 0.69, y = 0.382 }; --Xemirkol
	[98200] = { zoneID = 550, x = 0.237790256738663, y = 0.386159986257553 }; --Guk
	[98199] = { zoneID = 550, x = 0.281533569097519, y = 0.296234786510468 }; --Pugg
	[98198] = { zoneID = 550, x = 0.25963494181633, y = 0.347172498703003 }; --Rukdug
	[98283] = { zoneID = 534, x = 0.834533870220184, y = 0.436603635549545 }; --Drakum
	[98284] = { zoneID = 534, x = 0.803625404834747, y = 0.568467736244202 }; --Gondar
	[98285] = { zoneID = 534, x = 0.88, y = 0.55799997 }; --Smashum Grabb
	[98408] = { zoneID = 534, x = 0.875, y = 0.561 }; --Fel Overseer Mudlump
	[96323] = { zoneID = { 
					[590] = { x = 0.572, y = 0.854 };
					[585] = { x = 0.572, y = 0.854 };
					[586] = { x = 0.572, y = 0.854 };
					[587] = { x = 0.572, y = 0.854 };
					[582] = { x = 0.728, y = 0.366 };
					[579] = { x = 0.728, y = 0.366 };
					[580] = { x = 0.728, y = 0.366 };
					[581] = { x = 0.728, y = 0.366 };
			  } }; --Arachnis
	[97209] = { zoneID = 0 }; --Eraakis
	[110378] = { zoneID = 650, x = 0.582, y = 0.714 }; --Drugon the Frostblood
	[99929] = { zoneID = 650, x = 0.492, y = 0.074 }; --Flotsam
	[108879] = { zoneID = 641, x = 0.24200001, y = 0.70199996 }; --Humongris
	[107544] = { zoneID = 0 }; --Nithogg
	[108678] = { zoneID = 641, x = 0.554, y = 0.42400002 }; --Shar'thos
	[100230] = { zoneID = 650, x = 0.432, y = 0.47599998 }; --"Sure-Shot" Arnie
	[97348] = { zoneID = 0 }; --Abesha
	[112705] = { zoneID = 680, x = 0.56, y = 0.742 }; --Achronos
	[108885] = { zoneID = 634, x = 0.52, y = 0.234 }; --Aegir Wavecrusher
	[104481] = { zoneID = 650, x = 0.282, y = 0.528 }; --Ala'washte
	[107960] = { zoneID = 630, x = 0.33400002, y = 0.048 }; --Alluvanon
	[104521] = { zoneID = 680, x = 0.23, y = 0.58599997 }; --Alteria
	[111649] = { zoneID = 680, x = 0.545716643333435, y = 0.637047648429871 }; --Ambassador D'vwinn
	[92611] = { zoneID = 634, x = 0.442, y = 0.22799999 }; --Ambusher Daggerfang
	[111197] = { zoneID = 680, x = 0.336616456508637, y = 0.517735958099365 }; --Anax
	[110346] = { zoneID = 641, x = 0.59834361076355, y = 0.504999279975891 }; --Aodh Witherpetal
	[110870] = { zoneID = 680, x = 0.422521829605103, y = 0.565759301185608 }; --Apothecary Faldren
	[92634] = { zoneID = 634, x = 0.442, y = 0.22399999 }; --Apothecary Perez
	[90173] = { zoneID = 630, x = 0.486163973808289, y = 0.547606825828552 }; --Arcana Stalker
	[110656] = { zoneID = 680, x = 0.655867755413055, y = 0.591315090656281 }; --Arcanist Lylandre
	[107657] = { zoneID = 630, x = 0.35, y = 0.338 }; --Arcanist Shal'iman
	[109641] = { zoneID = 630, x = 0.57, y = 0.11 }; --Arcanor Prime
	[90244] = { zoneID = 630, x = 0.598, y = 0.12 }; --Arcavellus
	[97220] = { zoneID = 650, x = 0.488, y = 0.5 }; --Arru
	[99802] = { zoneID = 703, x = 0.55799997, y = 0.60400003 }; --Arthfael
	[103801] = { zoneID = 0 }; --Arthfael
	[106351] = { zoneID = 680, x = 0.338312238454819, y = 0.155927464365959 }; --Artificer Lothaire
	[92633] = { zoneID = 634, x = 0.442, y = 0.22799999 }; --Assassin Huwe
	[112758] = { zoneID = 680, x = 0.568, y = 0.676 }; --Auditor Esiel
	[112759] = { zoneID = 680, x = 0.812, y = 0.626 }; --Az'jatar
	[103787] = { zoneID = 680, x = 0.244, y = 0.496 }; --Baconlisk
	[110562] = { zoneID = 641, x = 0.455853193998337, y = 0.887825787067413 }; --Bahagar
	[97637] = { zoneID = 0 }; --Barax the Mauler
	[91187] = { zoneID = 630, x = 0.324, y = 0.284 }; --Beacher
	[111454] = { zoneID = 630, x = 0.41599998, y = 0.886 }; --Bestrix
	[107327] = { zoneID = 630, x = 0.292, y = 0.536 }; --Bilebrain
	[91874] = { zoneID = 634, x = 0.458, y = 0.774 }; --Bladesquall
	[92599] = { zoneID = 634, x = 0.374, y = 0.414 }; --Bloodstalker Alpha
	[98361] = { zoneID = 0 }; --Bloody Raven
	[98299] = { zoneID = 650, x = 0.36400002, y = 0.16600001 }; --Bodash the Hoarder
	[98178] = { zoneID = 0 }; --Boulderfall
	[109113] = { zoneID = 634, x = 0.31, y = 0.33400002 }; --Boulderfall, the Eroded
	[107127] = { zoneID = 630, x = 0.551487028598785, y = 0.457404464483261 }; --Brawlgoth
	[106863] = { zoneID = 0 }; --Brinebeard the Risen
	[97449] = { zoneID = 650, x = 0.381330668926239, y = 0.455743461847305 }; --Bristlemaul
	[91100] = { zoneID = 630, x = 0.59, y = 0.466 }; --Brogozog
	[94877] = { zoneID = 650, x = 0.56200004, y = 0.72400004 }; --Brogrul the Mighty
	[107105] = { zoneID = 630, x = 0.33200002, y = 0.41599998 }; --Broodmother Lizax
	[105632] = { zoneID = 680, x = 0.25, y = 0.44 }; --Broodmother Shu'malis
	[102863] = { zoneID = 0 }; --Bruiser
	[111463] = { zoneID = 634, x = 0.734, y = 0.84 }; --Bulvinkel
	[110726] = { zoneID = 680, x = 0.627394199371338, y = 0.485593497753143 }; --Cadraeus
	[91289] = { zoneID = 630, x = 0.524, y = 0.22399999 }; --Cailyn Paledoom
	[92685] = { zoneID = 634, x = 0.578, y = 0.44799998 }; --Captain Brvet
	[109163] = { zoneID = 649, x = 0.666, y = 0.23200001 }; --Captain Dargun
	[89846] = { zoneID = 630, x = 0.53400004, y = 0.44 }; --Captain Volo'ren
	[92604] = { zoneID = 634, x = 0.442, y = 0.22799999 }; --Champion Elodie
	[101596] = { zoneID = 0 }; --Charfeather
	[106990] = { zoneID = 630, x = 0.656529426574707, y = 0.569093704223633 }; --Chief Bitterbrine
	[109677] = { zoneID = 630, x = 0.588, y = 0.768 }; --Chief Treasurer Jabrill
	[111674] = { zoneID = 630, x = 0.468, y = 0.774 }; --Cinderwing
	[104698] = { zoneID = 680, x = 0.23, y = 0.58599997 }; --Colerian
	[104519] = { zoneID = 680, x = 0.23200001, y = 0.582 }; --Colerian
	[107266] = { zoneID = 630, x = 0.278, y = 0.512 }; --Commander Soraax
	[100864] = { zoneID = 680, x = 0.682, y = 0.584 }; --Cora'kar
	[93778] = { zoneID = 0 }; --Coruscating Bloom
	[97058] = { zoneID = 672, x = 0.634, y = 0.234 }; --Count Nefarious
	[108255] = { zoneID = 630, x = 0.556253373622894, y = 0.701169669628143 }; --Coura, Mistress of Arcana
	[97933] = { zoneID = 650, x = 0.443684786558151, y = 0.125284925103188 }; --Crab Rider Grmlrml
	[97345] = { zoneID = 650, x = 0.482, y = 0.406 }; --Crawshuk the Hungry
	[90050] = { zoneID = 0 }; --Crystalbeard
	[105619] = { zoneID = 0 }; --Cyrilline
	[90057] = { zoneID = 630, x = 0.51, y = 0.314 }; --Daggerbeak
	[94313] = { zoneID = 634, x = 0.584240257740021, y = 0.756280481815338 }; --Daniel "Boomer" Vorick
	[100231] = { zoneID = 650, x = 0.432, y = 0.47599998 }; --Dargok Thunderuin
	[92631] = { zoneID = 634, x = 0.442, y = 0.22799999 }; --Dark Ranger Jess
	[92205] = { zoneID = 0 }; --Darkest Fear
	[107924] = { zoneID = 641, x = 0.584, y = 0.734 }; --Darkfiend Tormentor
	[109501] = { zoneID = 650, x = 0.524, y = 0.584 }; --Darkful
	[92965] = { zoneID = 641, x = 0.436367750167847, y = 0.537378430366516 }; --Darkshade
	[92626] = { zoneID = 634, x = 0.442, y = 0.22799999 }; --Deathguard Adams
	[109702] = { zoneID = 630, x = 0.55799997, y = 0.634 }; --Deepclaw
	[104513] = { zoneID = 650, x = 0.566899657249451, y = 0.486974596977234 }; --Defilia
	[111651] = { zoneID = 680, x = 0.544175386428833, y = 0.56124472618103 }; --Degren
	[108790] = { zoneID = 634, x = 0.382, y = 0.684 }; --Den Mother Ylva
	[112637] = { zoneID = 630, x = 0.505123972892761, y = 0.520433962345123 }; --Devious Sunrunner
	[100495] = { zoneID = 650, x = 0.544431626796722, y = 0.412618547677994 }; --Devouring Darkness
	[93088] = { zoneID = 0 }; --Direclaw
	[91579] = { zoneID = 630, x = 0.432, y = 0.282 }; --Doomlord Kazrok
	[109727] = { zoneID = 0 }; --Dorbash the Smasher
	[108543] = { zoneID = 790, x = 0.252, y = 0.312 }; --Dread Captain Thedon
	[108541] = { zoneID = 790, x = 0.254, y = 0.29799998 }; --Dread Corsair
	[108531] = { zoneID = 0 }; --Dread Ship Krazatoa
	[94347] = { zoneID = 634, x = 0.72199994, y = 0.632 }; --Dread-Rider Cortis
	[97517] = { zoneID = 641, x = 0.601876318454742, y = 0.44219246506691 }; --Dreadbog
	[96072] = { zoneID = 650, x = 0.438, y = 0.754 }; --Durguth
	[110367] = { zoneID = 641, x = 0.624, y = 0.428 }; --Ealdis
	[96647] = { zoneID = 703, x = 0.25, y = 0.546 }; --Earlnoc the Beastbreaker
	[98188] = { zoneID = 634, x = 0.414, y = 0.33400002 }; --Egyl the Enduring
	[99792] = { zoneID = 680, x = 0.221599534153938, y = 0.51789528131485 }; --Elfbane
	[93372] = { zoneID = 0 }; --Enraged Earthservant
	[109728] = { zoneID = 0 }; --Ettin
	[91803] = { zoneID = 634, x = 0.468252837657928, y = 0.841225266456604 }; --Fathnyr
	[98225] = { zoneID = 0 }; --Fathnyr
	[105938] = { zoneID = 630, x = 0.43400002, y = 0.244 }; --Felwing
	[92040] = { zoneID = 649, x = 0.834, y = 0.482 }; --Fenri
	[98276] = { zoneID = 0 }; --Fenri
	[109584] = { zoneID = 630, x = 0.66, y = 0.4 }; --Fjordun
	[108827] = { zoneID = 634, x = 0.632, y = 0.54 }; --Fjorlag, the Grave's Chill
	[97793] = { zoneID = 650, x = 0.412, y = 0.58 }; --Flamescale
	[89884] = { zoneID = 630, x = 0.45200002, y = 0.578 }; --Flog the Captain-Eater
	[101649] = { zoneID = 650, x = 0.544, y = 0.744 }; --Frostshard
	[109729] = { zoneID = 0 }; --Fury
	[99610] = { zoneID = 680, x = 0.532615065574646, y = 0.301962465047836 }; --Garvrulg
	[93679] = { zoneID = 641, x = 0.492, y = 0.49 }; --Gathenak the Subjugator
	[97370] = { zoneID = 672, x = 0.684, y = 0.274 }; --General Volroth
	[91529] = { zoneID = 634, x = 0.414, y = 0.66400003 }; --Glimar Ironfist
	[95988] = { zoneID = 0 }; --Globulus
	[89816] = { zoneID = 630, x = 0.65400004, y = 0.4 }; --Golza the Iron Fin
	[101411] = { zoneID = 790, x = 0.24200001, y = 0.31 }; --Gom Crabbar
	[92117] = { zoneID = 641, x = 0.59400004, y = 0.764 }; --Gorebeak
	[110832] = { zoneID = 680, x = 0.272, y = 0.65800005 }; --Gorgroth
	[95123] = { zoneID = 641, x = 0.657961845397949, y = 0.53433758020401 }; --Grelda the Hag
	[107595] = { zoneID = 77, x = 0.384, y = 0.44799998 }; --Grimrot
	[107596] = { zoneID = 77, x = 0.382, y = 0.45400003 }; --Grimrot
	[112708] = { zoneID = 726, x = 0.252, y = 0.414 }; --Grimtotem Champion
	[98503] = { zoneID = 634, x = 0.78800005, y = 0.612 }; --Grrvrgull the Conqueror
	[110944] = { zoneID = 680, x = 0.593141913414002, y = 0.518634557723999 }; --Guardian Thor'el
	[96590] = { zoneID = 650, x = 0.55799997, y = 0.614 }; --Gurbog da Basher
	[108823] = { zoneID = 634, x = 0.39400002, y = 0.65800005 }; --Halfdan
	[107926] = { zoneID = 634, x = 0.516, y = 0.744 }; --Hannval the Butcher
	[103214] = { zoneID = 680, x = 0.676333427429199, y = 0.709710001945496 }; --Har'kess the Insatiable
	[110361] = { zoneID = 641, x = 0.698, y = 0.516 }; --Harbinger of Screams
	[97326] = { zoneID = 650, x = 0.510739028453827, y = 0.482337236404419 }; --Hartli the Snatcher
	[103154] = { zoneID = 120, x = 0.33400002, y = 0.582 }; --Hati
	[92703] = { zoneID = 634, x = 0.578, y = 0.45 }; --Helmouth Raider
	[92682] = { zoneID = 634, x = 0.578, y = 0.45 }; --Helmouth Raider
	[103223] = { zoneID = 680, x = 0.614, y = 0.396 }; --Hertha Grimdottir
	[91649] = { zoneID = 0 }; --Hivequeen Zsala
	[92590] = { zoneID = 634, x = 0.42, y = 0.576 }; --Hook
	[107169] = { zoneID = 630, x = 0.30200002, y = 0.48400003 }; --Horux
	[92951] = { zoneID = 634, x = 0.472, y = 0.572 }; --Houndmaster Ely
	[107136] = { zoneID = 630, x = 0.30200002, y = 0.48400003 }; --Houndmaster Stroxis
	[110486] = { zoneID = 103, x = 0.55799997, y = 0.78800005 }; --Huk'roth the Huntmaster
	[108822] = { zoneID = 634, x = 0.39400002, y = 0.65800005 }; --Huntress Estrid
	[100067] = { zoneID = 634, x = 0.638, y = 0.32599998 }; --Hydrannon
	[92199] = { zoneID = 0 }; --Image of Ursoc
	[92200] = { zoneID = 0 }; --Image of Ursol
	[92189] = { zoneID = 0 }; --Imagined Horror
	[109630] = { zoneID = 630, x = 0.284, y = 0.48400003 }; --Immolian
	[90803] = { zoneID = 630, x = 0.354, y = 0.50200003 }; --Infernal Lord
	[90139] = { zoneID = 634, x = 0.63685405254364, y = 0.742911696434021 }; --Inquisitor Ernstenbok
	[107269] = { zoneID = 630, x = 0.282, y = 0.52 }; --Inquisitor Tivos
	[106532] = { zoneID = 680, x = 0.38, y = 0.704 }; --Inquisitor Volitix
	[93993] = { zoneID = 0 }; --Insatiable Gorger
	[93030] = { zoneID = 641, x = 0.587924182415009, y = 0.340315729379654 }; --Ironbranch
	[94413] = { zoneID = 634, x = 0.620634019374847, y = 0.604620575904846 }; --Isel the Hammer
	[109957] = { zoneID = 0 }; --Isel the Hammer
	[92751] = { zoneID = 634, x = 0.598038911819458, y = 0.681144893169403 }; --Ivory Sentinel
	[103975] = { zoneID = 630, x = 0.402, y = 0.766 }; --Jade Darkhaven
	[101467] = { zoneID = 790, x = 0.864, y = 0.376 }; --Jaggen-Ra
	[109500] = { zoneID = 650, x = 0.522, y = 0.58599997 }; --Jak
	[103203] = { zoneID = 0 }; --Jetsam
	[93686] = { zoneID = 641, x = 0.528, y = 0.874 }; --Jinikki the Puncturer
	[96208] = { zoneID = 0 }; --Jubei'thos
	[94636] = { zoneID = 0 }; --Kalazzius the Guileful
	[111731] = { zoneID = 630, x = 0.45400003, y = 0.77199996 }; --Karthax
	[109125] = { zoneID = 641, x = 0.45400003, y = 0.83599997 }; --Kathaw the Savage
	[96997] = { zoneID = 677, x = 0.472, y = 0.29 }; --Kethrazor
	[101063] = { zoneID = 0 }; --King Forgalash
	[103827] = { zoneID = 680, x = 0.874, y = 0.624 }; --King Morgalash
	[97059] = { zoneID = 672, x = 0.744, y = 0.572 }; --King Voras
	[94414] = { zoneID = 641, x = 0.343754470348358, y = 0.583009004592896 }; --Kiranys Duskwhisper
	[96212] = { zoneID = 0 }; --Korda Torros
	[111573] = { zoneID = 790, x = 0.45200002, y = 0.506 }; --Kosumoth the Hungering
	[98421] = { zoneID = 634, x = 0.734688699245453, y = 0.476635128259659 }; --Kottr Vondyr
	[103271] = { zoneID = 731, x = 0.42200002, y = 0.126 }; --Kraxa
	[96210] = { zoneID = 0 }; --Krol the Blade
	[99362] = { zoneID = 733, x = 0.33400002, y = 0.812 }; --Kudzilla
	[106526] = { zoneID = 680, x = 0.35, y = 0.66800004 }; --Lady Rivantas
	[109015] = { zoneID = 634, x = 0.62, y = 0.732 }; --Lagertha
	[102303] = { zoneID = 680, x = 0.485261172056198, y = 0.566624522209168 }; --Lieutenant Strathmar
	[100516] = { zoneID = 0 }; --Lilin the Ravenous
	[108366] = { zoneID = 630, x = 0.37, y = 0.216 }; --Long-Forgotten Hippogryph
	[98024] = { zoneID = 650, x = 0.508, y = 0.346 }; --Luggut the Eggeater
	[98241] = { zoneID = 641, x = 0.618141651153565, y = 0.296182692050934 }; --Lyrath Moonfeather
	[111939] = { zoneID = 630, x = 0.43400002, y = 0.894 }; --Lysanis Shadesoul
	[109692] = { zoneID = 641, x = 0.316738396883011, y = 0.586024940013886 }; --Lytheron
	[95221] = { zoneID = 641, x = 0.472, y = 0.578 }; --Mad Henryk
	[109954] = { zoneID = 680, x = 0.420644640922546, y = 0.801297307014465 }; --Magister Phaedris
	[112757] = { zoneID = 680, x = 0.49400002, y = 0.794 }; --Magistrix Vilessa
	[112497] = { zoneID = 680, x = 0.244119361042976, y = 0.351685285568237 }; --Maia the White
	[96410] = { zoneID = 650, x = 0.45200002, y = 0.258 }; --Majestic Elderhorn
	[110024] = { zoneID = 680, x = 0.341477870941162, y = 0.609886586666107 }; --Mal'Dreth the Corruptor
	[109281] = { zoneID = 641, x = 0.42200002, y = 0.764 }; --Malisandra
	[112802] = { zoneID = 680, x = 0.135135605931282, y = 0.534349977970123 }; --Mar'tura
	[109653] = { zoneID = 630, x = 0.338, y = 0.286 }; --Marblub the Massive
	[111329] = { zoneID = 680, x = 0.361803233623505, y = 0.338403522968292 }; --Matron Hagatha
	[104517] = { zoneID = 650, x = 0.584, y = 0.714 }; --Mawat'aki
	[96621] = { zoneID = 650, x = 0.48400003, y = 0.274 }; --Mellok, Son of Torok
	[111653] = { zoneID = 680, x = 0.624, y = 0.634 }; --Miasu
	[111055] = { zoneID = 0 }; --Monstrous Plague Rat
	[93371] = { zoneID = 634, x = 0.724948644638062, y = 0.499365538358688 }; --Mordvigbjorn
	[93622] = { zoneID = 630, x = 0.406227648258209, y = 0.44672754406929 }; --Mortiferous
	[91780] = { zoneID = 634, x = 0.354, y = 0.184 }; --Mother Clacker
	[89865] = { zoneID = 630, x = 0.5, y = 0.344 }; --Mrrgrl the Tide Reaver
	[98311] = { zoneID = 650, x = 0.46400002, y = 0.07 }; --Mrrklr
	[97593] = { zoneID = 650, x = 0.544, y = 0.406 }; --Mynta Talonscreech
	[110340] = { zoneID = 680, x = 0.409394949674606, y = 0.327724486589432 }; --Myonix
	[101641] = { zoneID = 0 }; --Mythana
	[107477] = { zoneID = 76, x = 0.436, y = 0.766 }; --N.U.T.Z.
	[108016] = { zoneID = 0 }; --Necromagus Toldrethar
	[110451] = { zoneID = 0 }; --Nightmare Crystal
	[106165] = { zoneID = 0 }; --Nightmare WardenNOT SPAWNED
	[107023] = { zoneID = 634, x = 0.462, y = 0.306 }; --Nithogg
	[90248] = { zoneID = 0 }; --Normantis the Deposed
	[90217] = { zoneID = 630, x = 0.49400002, y = 0.086 }; --Normantis the Deposed
	[90253] = { zoneID = 0 }; --Normantis the Deposed
	[105657] = { zoneID = 650 }; --Notgarn
	[109990] = { zoneID = 641, x = 0.314, y = 0.48400003 }; --Nylaathria the Forgotten
	[105899] = { zoneID = 680, x = 0.65199995, y = 0.538 }; --Oglok the Furious
	[108715] = { zoneID = 210, x = 0.354, y = 0.66800004 }; --Ol' Eary
	[107617] = { zoneID = 26, x = 0.438, y = 0.57 }; --Ol' Muddle
	[104484] = { zoneID = 650, x = 0.33400002, y = 0.21 }; --Olokk the Shipbreaker
	[110577] = { zoneID = 680, x = 0.246031731367111, y = 0.474370330572128 }; --Oreth the Vile
	[104524] = { zoneID = 650, x = 0.522, y = 0.58599997 }; --Ormagrogg
	[95204] = { zoneID = 650, x = 0.47, y = 0.732 }; --Oubdob da Smasher
	[97057] = { zoneID = 672, x = 0.802, y = 0.42 }; --Overseer Brutarg
	[99886] = { zoneID = 630, x = 0.442, y = 0.37 }; --Pacified Earth
	[110364] = { zoneID = 0 }; --Pale Dreadwing
	[113694] = { zoneID = 680, x = 0.602, y = 0.408 }; --Pashya
	[95318] = { zoneID = 641, x = 0.610491812229157, y = 0.693581163883209 }; --Perrexx
	[107846] = { zoneID = 680, x = 0.666571021080017, y = 0.671210110187531 }; --Pinchshank
	[103045] = { zoneID = 706, x = 0.41599998, y = 0.598 }; --Plaguemaw
	[94485] = { zoneID = 641, x = 0.668981373310089, y = 0.445778429508209 }; --Pollous the Fetid
	[108010] = { zoneID = 630 }; --Powdermaster Maclin
	[90901] = { zoneID = 630, x = 0.56, y = 0.29 }; --Pridelord Meowl
	[92613] = { zoneID = 634, x = 0.444, y = 0.22799999 }; --Priestess Liza
	[100302] = { zoneID = 650, x = 0.522, y = 0.58599997 }; --Puck
	[108256] = { zoneID = 0 }; --Quin'el, Master of Chillwind
	[110342] = { zoneID = 641, x = 0.694, y = 0.574 }; --Rabxach
	[101660] = { zoneID = 733, x = 0.17, y = 0.202 }; --Rage Rot
	[109504] = { zoneID = 630, x = 0.325970143079758, y = 0.487203568220139 }; --Ragemaw
	[99846] = { zoneID = 630, x = 0.442, y = 0.372 }; --Raging Earth
	[103199] = { zoneID = 731, x = 0.354, y = 0.794 }; --Ragoul
	[97102] = { zoneID = 650, x = 0.522, y = 0.514 }; --Ram'Pag
	[92140] = { zoneID = 0 }; --Rampant Mandragora
	[111007] = { zoneID = 680, x = 0.49647468328476, y = 0.789832532405853 }; --Randril
	[105547] = { zoneID = 680, x = 0.239824831485748, y = 0.255260318517685 }; --Rauren
	[89016] = { zoneID = 630, x = 0.410028517246246, y = 0.418138235807419 }; --Ravyn-Drath
	[103575] = { zoneID = 680, x = 0.757740795612335, y = 0.581636488437653 }; --Reef Lord Raj'his
	[103183] = { zoneID = 680, x = 0.796, y = 0.726 }; --Rok'nash
	[110363] = { zoneID = 634, x = 0.582, y = 0.34 }; --Roteye
	[109317] = { zoneID = 634, x = 0.804, y = 0.116000004 }; --Rulf Bonesnapper
	[109318] = { zoneID = 634, x = 0.77599996, y = 0.096 }; --Runeseer Sigvid
	[100232] = { zoneID = 650, x = 0.432, y = 0.47599998 }; --Ryael Dawndrifter
	[111010] = { zoneID = 0 }; --Saepher
	[111069] = { zoneID = 0 }; --Saepher
	[100184] = { zoneID = 0 }; --Sailor's Nightmare
	[105739] = { zoneID = 680, x = 0.184, y = 0.396 }; --Sanaar
	[105728] = { zoneID = 680, x = 0.234, y = 0.45200002 }; --Scythemaster Cil'raman
	[111434] = { zoneID = 630, x = 0.442, y = 0.85400003 }; --Sea King Tidross
	[92180] = { zoneID = 641, x = 0.416123867034912, y = 0.782509386539459 }; --Seersei
	[101077] = { zoneID = 652, x = 0.35799998, y = 0.098000005 }; --Sekhan
	[104522] = { zoneID = 680, x = 0.23, y = 0.58599997 }; --Selenyi
	[108251] = { zoneID = 0 }; --Selia, Master of Balefire
	[103841] = { zoneID = 680, x = 0.167422935366631, y = 0.267467975616455 }; --Shadowquill
	[109054] = { zoneID = 680, x = 0.26, y = 0.41 }; --Shal'an
	[104523] = { zoneID = 641, x = 0.52, y = 0.398 }; --Shalas'aman
	[97093] = { zoneID = 650, x = 0.51, y = 0.258 }; --Shara Felbreath
	[91788] = { zoneID = 790, x = 0.314, y = 0.506 }; --Shellmaw
	[103605] = { zoneID = 706, x = 0.312, y = 0.584 }; --Shroudseeker
	[108794] = { zoneID = 706, x = 0.314, y = 0.552 }; --Shroudseeker's Shadow
	[92090] = { zoneID = 0 }; --Shyama the Dreaded
	[110438] = { zoneID = 680, x = 0.369666248559952, y = 0.211025014519691 }; --Siegemaster Aedrin
	[111052] = { zoneID = 749, x = 0.472, y = 0.412 }; --Silver Serpent
	[112636] = { zoneID = 630, x = 0.506112992763519, y = 0.519163846969605 }; --Sinister Leyrunner
	[92591] = { zoneID = 634, x = 0.42, y = 0.576 }; --Sinker
	[93654] = { zoneID = 641, x = 0.61, y = 0.88 }; --Skul'vrax
	[95872] = { zoneID = 650, x = 0.514, y = 0.318 }; --Skullhat
	[111021] = { zoneID = 749 }; --Sludge Face
	[98890] = { zoneID = 650, x = 0.414, y = 0.318 }; --Slumber
	[92725] = { zoneID = 0 }; --Son of Goredome
	[112756] = { zoneID = 680, x = 0.293522119522095, y = 0.888957500457764 }; --Sorallus
	[109195] = { zoneID = 634, x = 0.814, y = 0.046 }; --Soulbinder Halldora
	[108494] = { zoneID = 706, x = 0.318, y = 0.56 }; --Soulfiend Tagerma
	[97630] = { zoneID = 649, x = 0.27, y = 0.626 }; --Soulthirster
	[107487] = { zoneID = 634, x = 0.544, y = 0.29 }; --Starbuck
	[109594] = { zoneID = 630, x = 0.51, y = 0.578 }; --Stormfeather
	[109994] = { zoneID = 634, x = 0.58, y = 0.294 }; --Stormtalon
	[91795] = { zoneID = 634, x = 0.49400002, y = 0.72 }; --Stormwing Matriarch
	[98309] = { zoneID = 0 }; --Sunbreeze [DO NOT SPAWN]
	[90505] = { zoneID = 630, x = 0.672, y = 0.514 }; --Syphonus
	[97928] = { zoneID = 650, x = 0.43, y = 0.103999995 }; --Tamed Coralback
	[98268] = { zoneID = 634, x = 0.612, y = 0.436 }; --Tarben
	[97653] = { zoneID = 650, x = 0.538, y = 0.512 }; --Taurson
	[97203] = { zoneID = 650, x = 0.419617474079132, y = 0.416064411401749 }; --Tenpak Flametotem
	[91892] = { zoneID = 634, x = 0.412, y = 0.71800005 }; --Thane Irglov the Merciless
	[108136] = { zoneID = 630, x = 0.584, y = 0.78800005 }; --The Muscle
	[92763] = { zoneID = 634, x = 0.672, y = 0.398 }; --The Nameless King
	[89850] = { zoneID = 630, x = 0.59688001871109, y = 0.551613748073578 }; --The Oracle
	[111057] = { zoneID = 749, x = 0.346, y = 0.50200003 }; --The Rat King
	[109620] = { zoneID = 630, x = 0.432, y = 0.076 }; --The Whisperer
	[92423] = { zoneID = 641, x = 0.380495548248291, y = 0.528114795684814 }; --Theryssia
	[93205] = { zoneID = 641, x = 0.626610040664673, y = 0.475149780511856 }; --Thondrax
	[91114] = { zoneID = 630, x = 0.612, y = 0.62 }; --Tide Behemoth
	[91115] = { zoneID = 630, x = 0.612, y = 0.62 }; --Tide Behemoth
	[91113] = { zoneID = 630, x = 0.613049507141113, y = 0.620258092880249 }; --Tide Behemoth
	[110824] = { zoneID = 680, x = 0.184, y = 0.61 }; --Tideclaw
	[93166] = { zoneID = 634, x = 0.45400003, y = 0.5 }; --Tiptog the Lost
	[102064] = { zoneID = 630, x = 0.372, y = 0.83599997 }; --Torrentius
	[92609] = { zoneID = 634, x = 0.444, y = 0.22799999 }; --Tracker Jack
	[89407] = { zoneID = 625 }; --Treasure Demon
	[95440] = { zoneID = 0 }; --Tremblade
	[91663] = { zoneID = 0 }; --Trubble
	[108881] = { zoneID = 0 }; --Turtle
	[103247] = { zoneID = 731, x = 0.622, y = 0.88199997 }; --Ultanok
	[109708] = { zoneID = 641, x = 0.66800004, y = 0.698 }; --Undergrell Ringleader
	[93401] = { zoneID = 634, x = 0.64199996, y = 0.516 }; --Urgev the Flayer
	[109575] = { zoneID = 630, x = 0.582, y = 0.214 }; --Valakar the Thirsty
	[109606] = { zoneID = 0 }; --Valitos
	[89650] = { zoneID = 630, x = 0.474646866321564, y = 0.34452161192894 }; --Valiyaka the Stormbringer
	[99899] = { zoneID = 680, x = 0.76, y = 0.608 }; --Vicious Whale Shark
	[91640] = { zoneID = 0 }; --Vinyeaty
	[91661] = { zoneID = 0 }; --Vinyeti
	[89906] = { zoneID = 0 }; --Vinyeti
	[105496] = { zoneID = 0 }; --Vis'ileth
	[112760] = { zoneID = 680, x = 0.49400002, y = 0.582 }; --Volshax, Breaker of Will
	[107113] = { zoneID = 630, x = 0.372807919979095, y = 0.432095795869827 }; --Vorthax
	[100224] = { zoneID = 634, x = 0.53400004, y = 0.6 }; --Vrykul Earthmaiden Spirit
	[100223] = { zoneID = 634, x = 0.536, y = 0.6 }; --Vrykul Earthshaper Spirit
	[90164] = { zoneID = 630, x = 0.489726096391678, y = 0.551094770431519 }; --Warbringer Mox'na
	[102092] = { zoneID = 0 }; --Warlord Vatilash
	[107431] = { zoneID = 469, x = 0.644, y = 0.272 }; --Weaponized Rabbot
	[103785] = { zoneID = 641, x = 0.492, y = 0.468 }; --Well-Fed Bear
	[92152] = { zoneID = 634, x = 0.364963531494141, y = 0.517422020435333 }; --Whitewater Typhoon
	[109648] = { zoneID = 641, x = 0.234, y = 0.71 }; --Witchdoctor Grgl-Brgl
	[97504] = { zoneID = 641, x = 0.667614698410034, y = 0.364756613969803 }; --Wraithtalon
	[97069] = { zoneID = 677, x = 0.68, y = 0.28 }; --Wrath-Lord Lekos
	[109498] = { zoneID = 650, x = 0.524, y = 0.584 }; --Xaander
	[104831] = { zoneID = 0 }; --Xavrix
	[100303] = { zoneID = 650, x = 0.524, y = 0.584 }; --Zenobia
	[107170] = { zoneID = 630, x = 0.30200002, y = 0.48400003 }; --Zorux
	[97587] = { zoneID = 625, x = 0.574, y = 0.696 }; --Crazed Mage
	[97380] = { zoneID = 625, x = 0.488, y = 0.59400004 }; --Splint
	[97390] = { zoneID = 625, x = 0.384, y = 0.45599997 }; --Thieving Scoundrel
	[97388] = { zoneID = 625, x = 0.35599998, y = 0.432 }; --Xullorax
	[97384] = { zoneID = 625, x = 0.66, y = 0.218 }; --Segacedi
	[97589] = { zoneID = 625, x = 0.62, y = 0.432 }; --Rotten Egg
	[97387] = { zoneID = 625, x = 0.47, y = 0.354 }; --Mana Seeper
	[97381] = { zoneID = 625, x = 0.458, y = 0.522 }; --Screek
	[115847] = { zoneID = 772 }; --Ariadne
	[116185] = { zoneID = 0 }; --Attendant Keeper
	[115853] = { zoneID = 772 }; --Doomlash
	[116230] = { zoneID = 0 }; --Exotic Concubine
	[116004] = { zoneID = 772 }; --Flightmaster Volnath
	[116008] = { zoneID = 772 }; --Kar'zun
	[116395] = { zoneID = 772 }; --Nightwell Diviner
	[112712] = { zoneID = 772, x = 0.45, y = 0.30200002 }; --Gilded Guardian
	[116036] = { zoneID = 0 }; --Regal Cloudwing
	[116059] = { zoneID = 0 }; --Regal Cloudwing
	[116034] = { zoneID = 47, x = 0.49, y = 0.754 }; --The Cow King
	[115914] = { zoneID = 772 }; --Torm the Brute
	[116158] = { zoneID = 0 }; --Tower Concubine
	[116652] = { zoneID = 625 }; --Treasure Goblin
	[116159] = { zoneID = 0 }; --Wily Sycophant
	[89407] = { zoneID = 680 }; --Wrymtongue Hoarder
	[116041] = { zoneID = 625, x = 0.282, y = 0.462 }; --Treasure Goblin
	[118244] = { zoneID = 47, x = 0.16399999, y = 0.54 }; --Lightning Paw
	[115537] = { zoneID = 69 }; --Lorthalium
	[121124] = { zoneID = 646, x = 0.592, y = 0.62 }; --Apocron
	[117303] = { zoneID = 646, x = 0.582, y = 0.282 }; --Malificus
	[117470] = { zoneID = 646, x = 0.88, y = 0.33 }; --Si'vash
	[116666] = { zoneID = 0 }; --Abyssal Ember
	[120675] = { zoneID = 646, x = 0.32599998, y = 0.324 }; --An'thyna
	[116657] = { zoneID = 0 }; --Angered Sea Giant
	[121092] = { zoneID = 646, x = 0.36, y = 0.24200001 }; --Anomalous Observer
	[121016] = { zoneID = 646, x = 0.538, y = 0.78800005 }; --Aqueux
	[121049] = { zoneID = 646, x = 0.36, y = 0.572 }; --Baleful Knight-Captain
	[121029] = { zoneID = 646, x = 0.38599998, y = 0.344 }; --Brood Mother Nix
	[121046] = { zoneID = 646, x = 0.78, y = 0.39400002 }; --Brother Badatin
	[117239] = { zoneID = 646, x = 0.584, y = 0.28 }; --Brutallus
	[116953] = { zoneID = 646, x = 0.60400003, y = 0.532 }; --Corrupted Bonebreaker
	[120022] = { zoneID = 856 }; --Deepmaw
	[121090] = { zoneID = 646, x = 0.35799998, y = 0.574 }; --Demented Shivarra
	[121073] = { zoneID = 646, x = 0.36, y = 0.24200001 }; --Deranged Succubus
	[117136] = { zoneID = 646, x = 0.498, y = 0.36200002 }; --Doombringer Zar'thoz
	[117095] = { zoneID = 646, x = 0.568, y = 0.294 }; --Dreadblade Annihilator
	[118993] = { zoneID = 646, x = 0.368, y = 0.77800006 }; --Dreadeye
	[120716] = { zoneID = 845 }; --Dreadspeaker Serilis
	[120012] = { zoneID = 856 }; --Dresanoth
	[121134] = { zoneID = 646, x = 0.774, y = 0.292 }; --Duke Sithizi
	[117086] = { zoneID = 646, x = 0.512, y = 0.42200002 }; --Emberfire
	[116671] = { zoneID = 0 }; --Emberon
	[120020] = { zoneID = 856 }; --Erdu'val
	[116166] = { zoneID = 646, x = 0.644, y = 0.30200002 }; --Eye of Gurgh
	[120681] = { zoneID = 646, x = 0.374, y = 0.3 }; --Fel Obliterator
	[117093] = { zoneID = 646, x = 0.56200004, y = 0.506 }; --Felbringer Xar'thok
	[117103] = { zoneID = 646, x = 0.884, y = 0.31 }; --Felcaller Zelthae
	[117342] = { zoneID = 0 }; --Felhound
	[117091] = { zoneID = 646, x = 0.39200002, y = 0.42 }; --Felmaw Emberfiend
	[120998] = { zoneID = 646, x = 0.39400002, y = 0.602 }; --Flllurlokkr
	[120665] = { zoneID = 646, x = 0.38799998, y = 0.266 }; --Force-Commander Xillious
	[117493] = { zoneID = 0 }; --Grimtotem Warrior
	[121037] = { zoneID = 646, x = 0.77199996, y = 0.23200001 }; --Grossir
	[118675] = { zoneID = 0 }; --Harth Stonebrew
	[120686] = { zoneID = 646, x = 0.38599998, y = 0.322 }; --Illisthyndria
	[119718] = { zoneID = 646, x = 0.602, y = 0.45 }; --Imp Mother Bruva
	[117089] = { zoneID = 646, x = 0.62, y = 0.382 }; --Inquisitor Chillbane
	[115732] = { zoneID = 649, x = 0.272, y = 0.42200002 }; --Jorvild the Trusted
	[120021] = { zoneID = 856 }; --Kelpfist
	[121107] = { zoneID = 646, x = 0.414, y = 0.16399999 }; --Lady Eldrathe
	[121077] = { zoneID = 646, x = 0.36, y = 0.578 }; --Lambent Felhunter
	[120712] = { zoneID = 845 }; --Larithia
	[119629] = { zoneID = 646, x = 0.444, y = 0.524 }; --Lord Hel'Nurath
	[121056] = { zoneID = 646, x = 0.36, y = 0.24200001 }; --Malformed Terrorguard
	[117141] = { zoneID = 646, x = 0.574, y = 0.274 }; --Malgrazoth
	[117094] = { zoneID = 646, x = 0.42400002, y = 0.42400002 }; --Malorus the Soulkeeper
	[120717] = { zoneID = 845 }; --Mistress Dominix
	[116912] = { zoneID = 0 }; --Mo'arg Brute
	[116668] = { zoneID = 0 }; --Mor'tec the Soulslaver
	[117096] = { zoneID = 646, x = 0.568, y = 0.56200004 }; --Potionmaster Gloop
	[120715] = { zoneID = 845 }; --Raga'yut
	[121108] = { zoneID = 646, x = 0.354, y = 0.574 }; --Ruinous Overfiend
	[120019] = { zoneID = 856 }; --Ryul the Fading
	[117140] = { zoneID = 646, x = 0.644, y = 0.31 }; --Salethan the Broodwalker
	[117850] = { zoneID = 634, x = 0.374, y = 0.402 }; --Simone the Seductress
	[120641] = { zoneID = 646, x = 0.4, y = 0.266 }; --Skulguloth
	[121112] = { zoneID = 646, x = 0.27, y = 0.602 }; --Somber Dawn
	[120583] = { zoneID = 646, x = 0.39, y = 0.322 }; --Than'otalion
	[120013] = { zoneID = 856 }; --The Dread Stalker
	[121051] = { zoneID = 646, x = 0.35799998, y = 0.572 }; --Unstable Abyssal
	[121068] = { zoneID = 646, x = 0.36, y = 0.574 }; --Volatile Imp
	[120713] = { zoneID = 845 }; --Wa'glur
	[120003] = { zoneID = 856 }; --Warlord Darjah
	[121088] = { zoneID = 646, x = 0.36, y = 0.574 }; --Warped Voidlord
	[117090] = { zoneID = 646, x = 0.482, y = 0.478 }; --Xorogun the Flamecarver
	[116316] = { zoneID = 0 }; --Zirux
	[123087] = { zoneID = 625, x = 0.428, y = 0.24200001 }; --Al'Abas
	[122524] = { zoneID = 897, x = 0.552, y = 0.60400003 }; --Bloodfeast
	[122521] = { zoneID = 897, x = 0.57, y = 0.54 }; --Bonesunder
	[122899] = { zoneID = 407, x = 0.24, y = 0.32 }; --Death Metal Knight
	[122519] = { zoneID = 897, x = 0.514, y = 0.44 }; --Dregmar Runebrand
	[122520] = { zoneID = 897, x = 0.43400002, y = 0.294 }; --Icefist
	[122522] = { zoneID = 897, x = 0.608, y = 0.708 }; --Iceshatter
	[122609] = { zoneID = 80 }; --Xavinox
	[127090] = { zoneID = 885, x = 0.732, y = 0.704 }; --Admiral Rel'var
	[127096] = { zoneID = 885, artID = 910, x = 0.7613534927368164, y = 0.5612897276878357 }; --All-Seer Xanarian
	[126887] = { zoneID = 882, x = 0.301190555095673, y = 0.402085304260254 }; --Ataxon
	[126862] = { zoneID = 882, artID = 907, x = 0.438358306884766, y = 0.606420278549194 }; --Baruut the Bloodthirsty
	[122958] = { zoneID = 885, x = 0.6182929873466492, y = 0.369049608707428 }; --Blistermaw
	[124479] = { zoneID = 0 }; --Blisterwing
	[126869] = { zoneID = 882, x = 0.271795690059662, y = 0.300196826457977 }; --Captain Faruq
	[127376] = { zoneID = 885, artID = 910, x = 0.6140248775482178, y = 0.2086676359176636 }; --Chief Alchemist Munculus
	[124775] = { zoneID = 830, x = 0.452994585037231, y = 0.588177084922791 }; --Commander Endaxis
	[122912] = { zoneID = 830, x = 0.334076285362244, y = 0.757020115852356 }; --Commander Sathrenael
	[127084] = { zoneID = 885, x = 0.826780915260315, y = 0.65571665763855 }; --Commander Texlaz
	[122911] = { zoneID = 830, x = 0.38, y = 0.582 }; --Commander Vecaya
	[126910] = { zoneID = 882, x = 0.546, y = 0.138 }; --Commander Xethgar
	[122457] = { zoneID = 903 }; --Darkcaller
	[127703] = { zoneID = 885, x = 0.582, y = 0.126 }; --Doomcaster Suprax
	[127341] = { zoneID = 0 }; --Everburning Doombringer
	[124717] = { zoneID = 0 }; --Executioner Vaal
	[124684] = { zoneID = 0 }; --Eye of the Torturer
	[126864] = { zoneID = 882, x = 0.4114360809326172, y = 0.1149210929870606 }; --Feasel the Muffin Thief
	[122999] = { zoneID = 885, x = 0.557023167610168, y = 0.459368109703064 }; --Gar'zoth
	[126896] = { zoneID = 882, artID = 907, x = 0.3595643043518066, y = 0.5897888541221619 }; --Herald of Chaos
	[124412] = { zoneID = 0 }; --Houndcaller Orox
	[127288] = { zoneID = 885, x = 0.632, y = 0.236 }; --Houndmaster Kerrax
	[125820] = { zoneID = 830, x = 0.424242496490479, y = 0.698739051818848 }; --Imp Mother Laglath
	[126946] = { zoneID = 885, x = 0.6063617467880249, y = 0.4839643836021423 }; --Inquisitor Vethroz
	[126900] = { zoneID = 882, x = 0.614, y = 0.504 }; --Instructor Tarahna
	[126899] = { zoneID = 882, x = 0.482, y = 0.404 }; --Jed'hin Champion Vorusk
	[126860] = { zoneID = 882, x = 0.37689208984375, y = 0.54334020614624 }; --Kaara the Pale
	[125824] = { zoneID = 830, x = 0.438, y = 0.064 }; --Khazaduum
	[126254] = { zoneID = 885, x = 0.622, y = 0.53400004 }; --Lieutenant Xakaar
	[122947] = { zoneID = 885, artID = 910, x = 0.5735042095184326, y = 0.3355348110198975 }; --Mistress Il'thendra
	[127705] = { zoneID = 885, x = 0.666, y = 0.17799999 }; --Mother Rosula
	[126419] = { zoneID = 830, x = 0.709208011627197, y = 0.333872020244598 }; --Naroua
	[124440] = { zoneID = 882, x = 0.584, y = 0.374 }; --Overseer Y'Beda
	[125498] = { zoneID = 882, artID = 907, x = 0.6088039875030518, y = 0.2978510856628418 }; --Overseer Y'Morna
	[125497] = { zoneID = 882, x = 0.563754677772522, y = 0.29387503862381 }; --Overseer Y'Sorna
	[126040] = { zoneID = 885, x = 0.64, y = 0.21 }; --Puscilla
	[124572] = { zoneID = 0 }; --Pyromancer Volarr
	[127706] = { zoneID = 885, x = 0.65, y = 0.824 }; --Rezira the Seer
	[126898] = { zoneID = 882, x = 0.4390869140625, y = 0.482702136039734 }; --Sabuul
	[122838] = { zoneID = 882, x = 0.445445060729981, y = 0.716422617435455 }; --Shadowcaster Voruun
	[120393] = { zoneID = 830, x = 0.583351075649262, y = 0.758428454399109 }; --Siegemaster Voraan
	[123464] = { zoneID = 830, x = 0.528259515762329, y = 0.309650540351868 }; --Sister Subversia
	[126912] = { zoneID = 882, x = 0.4910416603088379, y = 0.09815710783004761 }; --Skreeg the Devourer
	[126913] = { zoneID = 882, x = 0.488710463047028, y = 0.523534536361694 }; --Slithon the Last
	[126889] = { zoneID = 882, x = 0.702948212623596, y = 0.459836542606354 }; --Sorolis the Ill-Fated
	[127704] = { zoneID = 0 }; --Soultender Videx
	[126815] = { zoneID = 882, artID = 907, x = 0.5308129787445068, y = 0.6737957000732422 }; --Soultwisted Monstrosity
	[127700] = { zoneID = 885, x = 0.84400004, y = 0.81 }; --Squadron Commander Vishax
	[123689] = { zoneID = 830, x = 0.54906576871872, y = 0.810298085212708 }; --Talestra the Vile
	[125479] = { zoneID = 830, x = 0.698190450668335, y = 0.809173941612244 }; --Tar Spitter
	[124804] = { zoneID = 830, x = 0.694, y = 0.564 }; --Tereck the Selector
	[127581] = { zoneID = 885, x = 0.550112843513489, y = 0.389168381690979 }; --The Many-Faced Devourer
	[126868] = { zoneID = 882, artID = 907, x = 0.3784056305885315, y = 0.6409568786621094 }; --Turek the Lucid
	[127906] = { zoneID = 0 }; --Twilight-Harbinger Tharuul
	[126691] = { zoneID = 0 }; --Tyrannosaurus Rekt
	[126885] = { zoneID = 882, x = 0.349630534648895, y = 0.37076723575592 }; --Umbraliss
	[125388] = { zoneID = 830, x = 0.608, y = 0.198 }; --Vagath the Betrayed
	[126208] = { zoneID = 885, x = 0.644, y = 0.492 }; --Varga
	[126115] = { zoneID = 885, x = 0.630290269851685, y = 0.573504030704498 }; --Ven'orn
	[126867] = { zoneID = 882, x = 0.336476922035217, y = 0.480633616447449 }; --Venomtail Skyfin
	[126866] = { zoneID = 882, artID = 907, x = 0.6386376619338989, y = 0.6435004472732544 }; --Vigilant Kuro
	[126865] = { zoneID = 882, x = 0.35, y = 0.236 }; --Vigilant Thanos
	[127882] = { zoneID = 903 }; --Vixx the Collector
	[127300] = { zoneID = 885, artID = 910, x = 0.5526007413864136, y = 0.2155847549438477 }; --Void Warden Valsuran
	[127911] = { zoneID = 903 }; --Void-Blade Zedaat
	[122456] = { zoneID = 0 }; --Voidmaw
	[126199] = { zoneID = 885, x = 0.530388474464417, y = 0.360298156738281 }; --Vrax'thul
	[127291] = { zoneID = 885, x = 0.529603838920593, y = 0.293689787387848 }; --Watcher Aival
	[127118] = { zoneID = 885, x = 0.577834963798523, y = 0.507144808769226 }; --Worldsplitter Skuul
	[126852] = { zoneID = 882, x = 0.555345296859741, y = 0.601566255092621 }; --Wrangler Kravos
	[126338] = { zoneID = 885, x = 0.613229513168335, y = 0.652164340019226 }; --Wrath-Lord Yarez
	[126908] = { zoneID = 882, x = 0.65400004, y = 0.29 }; --Zul'tan the Numerous
	[124680] = { zoneID = 0 }; --Zul'zoloth
	[133044] = { zoneID = 0 }; --Grand Marshal Tremblade
	[133043] = { zoneID = 0 }; --High Warlord Volrath
	[125951] = { zoneID = 650 }; --Obsidian Deathwarder
	[132591] = { zoneID = 81, artID = 962, x = 0.274, y = 0.742 }; --Ogmot the Mad
	[132578] = { zoneID = 81, artID = 962, x = 0.588879227638245, y = 0.117889001965523 }; --Qroshekx
	[133042] = { zoneID = 0 }; --Sky Marshall Gabriel
	[132580] = { zoneID = 81, artID = 962, x = 0.545726895332336, y = 0.79739773273468 }; --Ssinkrix
	[132584] = { zoneID = 81, artID = 962, x = 0.294995754957199, y = 0.349105477333069 }; --Xaarshej
	
	-- Rares BFA 8.0.1
	[136385] = { zoneID = 0 }; --Azurethos
	[140252] = { zoneID = 896, x = 0.497973382472992, y = 0.730150938034058 }; --Hailstone Construct
	[132253] = { zoneID = 862, x = 0.696099162101746, y = 0.294883787631989 }; --Ji'arak
	[132701] = { zoneID = 863, x = 0.35475617647171, y = 0.332271933555603 }; --T'zane
	[140163] = { zoneID = 0 }; --Warbringer Yenajz
	[139767] = { zoneID = 0 }; --"Spyglass" Marie
	[134798] = { zoneID = 0 }; --Abyss Crawler
	[138279] = { zoneID = 895, x = 0.855462968349457, y = 0.433927416801453 }; --Adhara White
	[140474] = { zoneID = 0 }; --Adherent of the Abyss
	[135852] = { zoneID = 864, x = 0.503281533718109, y = 0.816349148750305 }; --Ak'tar
	[138948] = { zoneID = 864, x = 0.536000728607178, y = 0.537231802940369 }; --Akakakoo
	[140695] = { zoneID = 0 }; --Albino Dreadfang
	[136049] = { zoneID = 0 }; --Algenon
	[139229] = { zoneID = 0 }; --Aluna Leaf-Sister
	[138486] = { zoneID = 0 }; --Aluriak
	[122955] = { zoneID = 0 }; --Ambassador Terrick
	[138846] = { zoneID = 0 }; --Amberwinged Mindsinger
	[140090] = { zoneID = 0 }; --Ana'tashe
	[139350] = { zoneID = 0 }; --Anaha Witherbreath
	[129660] = { zoneID = 0 }; --Ancient Armor
	[125250] = { zoneID = 863, artID = 888, x = 0.678053319454193, y = 0.294774979352951 }; --Ancient Jawbreaker
	[134807] = { zoneID = 0 }; --Ancient Spineshell
	[139758] = { zoneID = 0 }; --Annie Two-Pistols
	[140268] = { zoneID = 0 }; --Ano Forest-Keeper
	[139041] = { zoneID = 0 }; --Aquamancer Lushu
	[139403] = { zoneID = 1501, artID = 1301, x = 0.5046864748001099, y = 0.7860791087150574 }; --Arassaz the Invader
	[137824] = { zoneID = 896, x = 0.292216658592224, y = 0.69026106595993 }; --Arclight
	[139679] = { zoneID = 0 }; --Argl
	[140109] = { zoneID = 0 }; --Armored Deathflayer
	[137529] = { zoneID = 896, x = 0.348381578922272, y = 0.691929519176483 }; --Arvon the Betrayed
	[138639] = { zoneID = 0 }; --Asennu
	[135721] = { zoneID = 0 }; --Asha'ne
	[130439] = { zoneID = 864, x = 0.547039091587067, y = 0.151398330926895 }; --Ashmane
	[135931] = { zoneID = 0 }; --Ashstone
	[129961] = { zoneID = 862, x = 0.809694886207581, y = 0.216058507561684 }; --Atal'zul Gotaka
	[138514] = { zoneID = 0 }; --Athiona
	[132182] = { zoneID = 895, x = 0.749113440513611, y = 0.789451897144318 }; --Auditor Dolp
	[140829] = { zoneID = 0 }; --Autumnbreeze
	[137825] = { zoneID = 896, x = 0.444986760616303, y = 0.875853896141052 }; --Avalanche
	[129343] = { zoneID = 862, x = 0.498327016830444, y = 0.574247598648071 }; --Avatar of Xolotal
	[140066] = { zoneID = 0 }; --Axeclaw
	[128553] = { zoneID = 864, x = 0.490243494510651, y = 0.890353441238403 }; --Azer'tor
	[134298] = { zoneID = 863, artID = 888, x = 0.541163146495819, y = 0.810748040676117 }; --Azerite-Infused Elemental
	[134293] = { zoneID = 863, x = 0.330107837915421, y = 0.281001359224319 }; --Azerite-Infused Slag
	[138511] = { zoneID = 0 }; --Azurescale
	[122606] = { zoneID = 0 }; --Azurewing
	[143931] = { zoneID = 0 }; --Azurewing
	[136877] = { zoneID = 0 }; --Baba Gufa
	[139598] = { zoneID = 0 }; --Backbreaker Bahaha
	[139442] = { zoneID = 0 }; --Backbreaker Zukan
	[139348] = { zoneID = 0 }; --Baga the Frostshield
	[134539] = { zoneID = 0 }; --Bajiani the Slick
	[128497] = { zoneID = 864, x = 0.310031145811081, y = 0.81087863445282 }; --Bajiani the Slick
	[126142] = { zoneID = 863, artID = 888, x = 0.428373396396637, y = 0.605336964130402 }; --Bajiatha
	[130143] = { zoneID = 896, x = 0.586628019809723, y = 0.298962503671646 }; --Balethorn
	[143314] = { zoneID = 0 }; --Bane of the Woods
	[139873] = { zoneID = 0 }; --Banechitter
	[136886] = { zoneID = 0 }; --Banner-Bearer Koral
	[127333] = { zoneID = 896, x = 0.591028869152069, y = 0.167611137032509 }; --Barbthorn Queen
	[129181] = { zoneID = 895, x = 0.760988891124725, y = 0.82877779006958 }; --Barman Bill
	[135929] = { zoneID = 0 }; --Baron Blazehollow
	[136854] = { zoneID = 0 }; --Baruun Flinthoof
	[132068] = { zoneID = 895, x = 0.345041394233704, y = 0.303578227758408 }; --Bashmu
	[138447] = { zoneID = 0 }; --Battle-Maiden Salaria
	[138847] = { zoneID = 0 }; --Battle-Mender Ka'vaz
	[132837] = { zoneID = 0 }; --Beach Strider
	[142709] = { zoneID = 14, artID = 1137, x = 0.647300124168396, y = 0.716875612735748 }; --Beastrider Kama
	[136853] = { zoneID = 0 }; --Beefa Warbeard
	[134147] = { zoneID = 942, x = 0.6648228168487549, y = 0.7479041218757629 }; --Beehemoth
	[138828] = { zoneID = 0 }; --Berhild the Fierce
	[139347] = { zoneID = 0 }; --Berserker Gola
	[136000] = { zoneID = 0 }; --Beryllus
	[129805] = { zoneID = 896, x = 0.505404770374298, y = 0.300619512796402 }; --Beshol
	[124548] = { zoneID = 896, x = 0.584667801856995, y = 0.331791013479233 }; --Betsy
	[140660] = { zoneID = 0 }; --Big-Horn
	[132319] = { zoneID = 896, x = 0.350583225488663, y = 0.33259704709053 }; --Bilefang Mother
	[140158] = { zoneID = 0 }; --Bilesoaked Rotclaw
	[138393] = { zoneID = 0 }; --Biter
	[132086] = { zoneID = 895, x = 0.561882138252258, y = 0.699587881565094 }; --Black-Eyed Bart
	[139145] = { zoneID = 895, x = 0.852585077285767, y = 0.734368741512299 }; --Blackthorne
	[138848] = { zoneID = 0 }; --Blade-Dancer Zorlak
	[140560] = { zoneID = 0 }; --Blazeseeker
	[139681] = { zoneID = 0 }; --Bleakfin
	[138667] = { zoneID = 896, x = 0.360037863254547, y = 0.111031614243984 }; --Blighted Monstrosity
	[129476] = { zoneID = 864, x = 0.488507866859436, y = 0.499569296836853 }; --Bloated Krolusk
	[126635] = { zoneID = 863, x = 0.432073563337326, y = 0.913715898990631 }; --Blood Priest Xak'lar
	[137062] = { zoneID = 0 }; --Blood-Hunter Akal
	[136991] = { zoneID = 0 }; --Blood-Hunter Dazal'ai
	[140692] = { zoneID = 0 }; --Bloodbore
	[128699] = { zoneID = 862, x = 0.598451912403107, y = 0.182979732751846 }; --Bloodbulge
	[134908] = { zoneID = 0 }; --Bloodfang
	[140440] = { zoneID = 0 }; --Bloodfur the Gorer
	[138299] = { zoneID = 895, x = 0.588, y = 0.33 }; --Bloodmaw
	[139023] = { zoneID = 0 }; --Bloodmaw the Savage
	[136859] = { zoneID = 0 }; --Bloodscalp
	[140070] = { zoneID = 0 }; --Bloodscent the Tracker
	[139871] = { zoneID = 0 }; --Bloodseeker Kilthix
	[134806] = { zoneID = 0 }; --Bloodsnapper
	[140064] = { zoneID = 0 }; --Bloodsoaked Grizzlefur
	[136011] = { zoneID = 0 }; --Bloodstone
	[135646] = { zoneID = 0 }; --Bloodstripe the Render
	[139021] = { zoneID = 0 }; --Bloodtracker
	[136393] = { zoneID = 864, x = 0.559163093566895, y = 0.53647518157959 }; --Bloodwing Bonepicker
	[129969] = { zoneID = 0 }; --Bloodwitch Ysinna
	[138827] = { zoneID = 0 }; --Bodalf the Strong
	[139420] = { zoneID = 0 }; --Bog Defender Vaszash
	[140160] = { zoneID = 0 }; --Boilhide the Raging
	[140330] = { zoneID = 0 }; --Boneclatter
	[126621] = { zoneID = 896, x = 0.666961014270783, y = 0.509763598442078 }; --Bonesquall
	[136874] = { zoneID = 981, artID = 981, x = 0.5481917858123779, y = 0.3375174403190613 }; --Bonk
	[138392] = { zoneID = 0 }; --Bono
	[138986] = { zoneID = 0 }; --Borgl the Seeker
	[137158] = { zoneID = 0 }; --Bound Lightning Elemental
	[136043] = { zoneID = 0 }; --Brackish
	[139321] = { zoneID = 896, x = 0.276353448629379, y = 0.595876932144165 }; --Braedan Whitewall
	[140453] = { zoneID = 0 }; --Bramblefur Herdleader
	[139213] = { zoneID = 0 }; --Bramblestomp
	[131718] = { zoneID = 862, x = 0.667450487613678, y = 0.32293227314949 }; --Bramblewing
	[139190] = { zoneID = 0 }; --Branch-Leaper the Swift
	[126427] = { zoneID = 14, artID = 1137 }; --Branchlord Aldrus CHECK IF DELETE
	[142508] = { zoneID = 14, x = 0.22693045437336, y = 0.224014028906822 }; --Branchlord Aldrus
	[134643] = { zoneID = 864, artID = 889, x = 0.297807991504669, y = 0.464617788791657 }; --Brgl-Lrgl the Basher
	[138244] = { zoneID = 896, x = 0.412, y = 0.38 }; --Briarwood Bulwark
	[140836] = { zoneID = 0 }; --Brightfire
	[139701] = { zoneID = 0 }; --Brineshell Minor Oracle
	[139700] = { zoneID = 0 }; --Brineshell Sea Shaman
	[140658] = { zoneID = 0 }; --Bristlefur
	[134947] = { zoneID = 0 }; --Bristlethorn Broodqueen
	[140266] = { zoneID = 0 }; --Broken-Horn the Ancient
	[137025] = { zoneID = 942, x = 0.29469445347786, y = 0.696112394332886 }; --Broodmother
	[133158] = { zoneID = 0 }; --Broodmother Chimal
	[130508] = { zoneID = 895, x = 0.835436940193176, y = 0.448254376649857 }; --Broodmother Razora
	[140547] = { zoneID = 0 }; --Broodqueen Cindrix
	[140545] = { zoneID = 0 }; --Broodqueen Flareanae
	[140553] = { zoneID = 0 }; --Broodqueen Shuzasz
	[140546] = { zoneID = 0 }; --Broodqueen Vyl'tilac
	[139882] = { zoneID = 0 }; --Broodwatcher Anub'akar
	[139880] = { zoneID = 0 }; --Broodwatcher Tal'nadix
	[139881] = { zoneID = 0 }; --Broodwatcher Taldim-Ra
	[138633] = { zoneID = 0 }; --Brother Maat
	[135724] = { zoneID = 981, artID = 981, x = 0.3540087938308716, y = 0.440126895904541 }; --Brushstalker
	[139594] = { zoneID = 0 }; --Brusier Gor
	[140180] = { zoneID = 0 }; --Brutalgore
	[136892] = { zoneID = 0 }; --Brutalsnout
	[139471] = { zoneID = 0 }; --Bugan the Flesh-Crusher
	[139593] = { zoneID = 0 }; --Burk the Literate
	[141615] = { zoneID = 14, artID = 1137, x = 0.306321948766708, y = 0.447503238916397 }; --Burning Goliath
	[139354] = { zoneID = 0 }; --Butun the Boneripper
	[139763] = { zoneID = 0 }; --Cannonmaster Arlin
	[140075] = { zoneID = 1501, artID = 1301, x = 0.4864931106567383, y = 0.678702712059021 }; --Canus
	[135796] = { zoneID = 896, x = 0.272763550281525, y = 0.142226248979568 }; --Captain Leadfist
	[125232] = { zoneID = 863, x = 0.816, y = 0.292 }; --Captain Mu'kala
	[130897] = { zoneID = 942, x = 0.472718566656113, y = 0.659158051013947 }; --Captain Razorspine
	[136346] = { zoneID = 864, x = 0.415420830249786, y = 0.239327698945999 }; --Captain Stef "Marrow" Quin
	[132088] = { zoneID = 895, x = 0.386129528284073, y = 0.214447349309921 }; --Captain Wintersail
	[139152] = { zoneID = 895, x = 0.724319100379944, y = 0.810072779655457 }; --Carla Smirk
	[124582] = { zoneID = 0 }; --Chasm-Hunter
	[140428] = { zoneID = 0 }; --Chasm-Jumper
	[123270] = { zoneID = 0 }; --Chef Gru
	[139817] = { zoneID = 0 }; --Chief Engineer Zazzy
	[140332] = { zoneID = 0 }; --Chitterbore
	[134909] = { zoneID = 0 }; --Chittering Spindleweb
	[138481] = { zoneID = 0 }; --Chromitus
	[140548] = { zoneID = 0 }; --Cinderfang Ambusher
	[136856] = { zoneID = 0 }; --Cinderhorn
	[129830] = { zoneID = 0 }; --Clackclaw the Behemoth
	[140114] = { zoneID = 0 }; --Clatterclaw
	[139698] = { zoneID = 0 }; --Clattercraw the Oracle
	[134764] = { zoneID = 0 }; --Clattershell
	[135649] = { zoneID = 0 }; --Clawflurry
	[138630] = { zoneID = 0 }; --Cleric Izzad
	[136799] = { zoneID = 0 }; --Cliffbreaker
	[140860] = { zoneID = 0 }; --Cliffracer
	[140341] = { zoneID = 0 }; --Cloudscraper
	[140800] = { zoneID = 0 }; --Cloudwing the Killthief
	[140338] = { zoneID = 1501, artID = 1301, x = 0.6941415071487427, y = 0.824459433555603 }; --Cltuch Guardian Jinka'lo
	[136802] = { zoneID = 0 }; --Coalbiter
	[131704] = { zoneID = 862, x = 0.6307864785194397, y = 0.1402434855699539 }; --Coati
	[139466] = { zoneID = 0 }; --Cobalt Stoneguard
	[138635] = { zoneID = 0 }; --Commander Husan
	[138845] = { zoneID = 0 }; --CommanderJo'vak
	[124722] = { zoneID = 864, x = 0.425121307373047, y = 0.920830368995667 }; --Commodore Calhoun
	[126187] = { zoneID = 863, artID = 888, x = 0.413166344165802, y = 0.534317910671234 }; --Corpse Bringer Yal'kar
	[140992] = { zoneID = 0 }; --Corpseburster
	[140370] = { zoneID = 0 }; --Corpsefeaster
	[140797] = { zoneID = 0 }; --Corpseharvest
	[139968] = { zoneID = 942, x = 0.661409139633179, y = 0.517293572425842 }; --Corrupted Tideskipper
	[136945] = { zoneID = 0 }; --Corvus
	[129904] = { zoneID = 896, x = 0.521701812744141, y = 0.469979286193848 }; --Cottontail Matron
	[134801] = { zoneID = 0 }; --Cracked-Shell
	[140970] = { zoneID = 0 }; --Cragburster
	[140798] = { zoneID = 0 }; --Cragcaw
	[140851] = { zoneID = 0 }; --Cragg
	[140427] = { zoneID = 0 }; --Craghoof Herdfather
	[136805] = { zoneID = 0 }; --Cragreaver
	[140181] = { zoneID = 0 }; --Cragtusk
	[135046] = { zoneID = 0 }; --Crawmog
	[139027] = { zoneID = 0 }; --Crescent Oracle
	[141618] = { zoneID = 14, artID = 1137, x = 0.620899558067322, y = 0.315035670995712 }; --Cresting Goliath
	[142418] = { zoneID = 943, x = 0.393534123897553, y = 0.585049092769623 }; --Cresting Goliath
	[138506] = { zoneID = 0 }; --Crimsonscale
	[140938] = { zoneID = 942, x = 0.62930178642273, y = 0.328283965587616 }; --Croaker
	[140162] = { zoneID = 0 }; --Crunchsnap the Vice
	[126451] = { zoneID = 0 }; --Crushclaw
	[140084] = { zoneID = 0 }; --Crushknuckle
	[140684] = { zoneID = 0 }; --Crushstomp
	[136183] = { zoneID = 942, x = 0.5125221014022827, y = 0.5552466511726379 }; --Crushtacean
	[136045] = { zoneID = 0 }; --Crushtide
	[140369] = { zoneID = 0 }; --Cryptseeker
	[132879] = { zoneID = 0 }; --Crystalline Giant
	[136990] = { zoneID = 0 }; --Cursed Ankali
	[139756] = { zoneID = 0 }; --Cutthroat Sheila
	[135837] = { zoneID = 0 }; --Cyclonic Lieutenant
	[140696] = { zoneID = 0 }; --Da'zu the Feared
	[133190] = { zoneID = 862, x = 0.741698086261749, y = 0.393229633569717 }; --Daggerjaw
	[130644] = { zoneID = 0 }; --Daggertooth
	[134897] = { zoneID = 942, x = 0.678599655628204, y = 0.398300379514694 }; --Dagrus the Scorned
	[140296] = { zoneID = 0 }; --Dampfur the Musky
	[133995] = { zoneID = 0 }; --Dangerpearl
	[132877] = { zoneID = 0 }; --Dankscale
	[142688] = { zoneID = 14, x = 0.503836929798126, y = 0.610293686389923 }; --Darbel Montrose
	[138890] = { zoneID = 0 }; --Dargulf the Spirit-Seeker
	[136428] = { zoneID = 862, x = 0.441243767738342, y = 0.76513284444809 }; --Dark Chronicler
	[138039] = { zoneID = 1161, x = 0.31429588794708, y = 0.63912308216095 }; --Dark Ranger Clea
	[123001] = { zoneID = 0 }; --Dark Water
	[140683] = { zoneID = 0 }; --Darkfur the Smasher
	[134911] = { zoneID = 0 }; --Darkhollow Widow
	[134794] = { zoneID = 0 }; --Darklurker
	[140361] = { zoneID = 0 }; --Darkshadow the Omen
	[134760] = { zoneID = 862, x = 0.653688848018646, y = 0.102394707500935 }; --Darkspeaker Jo'la
	[139391] = { zoneID = 0 }; --Darkwave Assassin
	[138016] = { zoneID = 0 }; --Darokk
	[135644] = { zoneID = 0 }; --Dawnstalker
	[139352] = { zoneID = 0 }; --Death-Caller Majuli
	[134706] = { zoneID = 896, x = 0.187137559056282, y = 0.613883554935455 }; --Deathcap
	[134767] = { zoneID = 0 }; --Deathclaw Egg-Mother
	[139345] = { zoneID = 0 }; --Deathwhisperer Kulu
	[139761] = { zoneID = 0 }; --Deckmaster O'Rourke
	[139040] = { zoneID = 0 }; --Deep Oracle Unani
	[140996] = { zoneID = 0 }; --Deepbore
	[139385] = { zoneID = 942, x = 0.530268132686615, y = 0.510118961334229 }; --Deepfang
	[139020] = { zoneID = 0 }; --Deepgrowl the Ferocious
	[140674] = { zoneID = 0 }; --Deephowl
	[139674] = { zoneID = 0 }; --Deepscale
	[140773] = { zoneID = 0 }; --Deepsea Tidecrusher
	[140331] = { zoneID = 0 }; --Deeptunnel Ambusher
	[139872] = { zoneID = 0 }; --Defender Zakar
	[140675] = { zoneID = 0 }; --Den Mother Mugo
	[139677] = { zoneID = 0 }; --Depth-Caller
	[140392] = { zoneID = 0 }; --Direbore of the Thousand Tunnels
	[140062] = { zoneID = 0 }; --Diremaul
	[140072] = { zoneID = 0 }; --Direprowl the Ravager
	[136888] = { zoneID = 0 }; --Dirt-Speaker Barrul
	[138638] = { zoneID = 0 }; --Djar
	[140925] = { zoneID = 942, x = 0.534430801868439, y = 0.643446326255798 }; --Doc Marrtens
	[134109] = { zoneID = 0 }; --Dominated Hydra
	[142741] = { zoneID = 0 }; --Doomrider Helgrim
	[140978] = { zoneID = 0 }; --Doomtunnel
	[140451] = { zoneID = 0 }; --Doting Calfmother
	[139344] = { zoneID = 0 }; --Drakani Death-Defiler
	[119000] = { zoneID = 0 }; --Dreadbeard
	[140159] = { zoneID = 0 }; --Dreadgrowl the Pustulent
	[139874] = { zoneID = 0 }; --Dreadswoop
	[135648] = { zoneID = 0 }; --Driftcoat
	[140429] = { zoneID = 0 }; --Drifthopper the Swift
	[140799] = { zoneID = 0 }; --Driftstalker
	[133971] = { zoneID = 0 }; --Drukengu
	[138445] = { zoneID = 0 }; --Duke Szzull
	[140161] = { zoneID = 0 }; --Duneburrower
	[137060] = { zoneID = 0 }; --Dunecaster Mu'na
	[140795] = { zoneID = 0 }; --Dunecircler the Bleak
	[140450] = { zoneID = 0 }; --Dunu the Blind
	[139439] = { zoneID = 0 }; --Duskbinder Zuun
	[126101] = { zoneID = 0 }; --Duskcoat Huntress
	[135719] = { zoneID = 0 }; --Duskrunner
	[136861] = { zoneID = 0 }; --Duskstalker Kuli
	[140861] = { zoneID = 0 }; --Duster
	[130338] = { zoneID = 0 }; --Dustfang
	[136808] = { zoneID = 0 }; --Dusthide
	[140672] = { zoneID = 0 }; --Dusthide the Mangy
	[135829] = { zoneID = 0 }; --Dustwind
	[138996] = { zoneID = 0 }; --Earth-Speaker Juwa
	[139530] = { zoneID = 0 }; --Earth-Wrought Siegebreaker
	[123347] = { zoneID = 0 }; --Earthcaller Malan
	[140760] = { zoneID = 0 }; --Earthliving Giant
	[140842] = { zoneID = 0 }; --Ebb
	[141668] = { zoneID = 14, artID = 1137, x = 0.570738434791565, y = 0.347373366355896 }; --Echo of Myzrael
	[139026] = { zoneID = 0 }; --Eclipse-Caller
	[139877] = { zoneID = 0 }; --Egg-Tender Kahasz
	[140371] = { zoneID = 0 }; --Egg-Tender Ny'xik
	[139878] = { zoneID = 0 }; --Elder Akar'azan
	[140168] = { zoneID = 0 }; --Elder Chest-Thump
	[140662] = { zoneID = 0 }; --Elder Greatfur
	[139217] = { zoneID = 0 }; --Elder Many-Blooms
	[140170] = { zoneID = 0 }; --Elder Mokka
	[138999] = { zoneID = 0 }; --Elder Ordol
	[135645] = { zoneID = 0 }; --Elder Pridemother
	[139000] = { zoneID = 0 }; --Elder Yur
	[140974] = { zoneID = 0 }; --Eldercraw
	[140685] = { zoneID = 0 }; --Elderhorn
	[140391] = { zoneID = 0 }; --Emerald Deepseeker
	[130016] = { zoneID = 0 }; --Emily Mayville
	[129995] = { zoneID = 896, x = 0.634058952331543, y = 0.400964945554733 }; --Emily Mayville
	[138515] = { zoneID = 0 }; --Endalion
	[136335] = { zoneID = 864, artID = 889, x = 0.619885861873627, y = 0.378450602293015 }; --Enraged Krolusk
	[134294] = { zoneID = 863, x = 0.816973626613617, y = 0.608972847461701 }; --Enraged Water Elemental
	[138871] = { zoneID = 896, x = 0.24200001, y = 0.218 }; --Ernie
	[139039] = { zoneID = 0 }; --Eso the Fathom-Hunter
	[139211] = { zoneID = 0 }; --Everbloom
	[138505] = { zoneID = 0 }; --Evolved Clutch-Warden
	[134213] = { zoneID = 896, x = 0.308804243803024, y = 0.183919593691826 }; --Executioner Blackwell
	[136010] = { zoneID = 0 }; --Faceted Earthbreaker
	[136323] = { zoneID = 864, artID = 889, x = 0.5364658236503601, y = 0.3457550704479218 }; --Fangcaller Xorreth
	[134950] = { zoneID = 0 }; --Fanged Terror
	[139407] = { zoneID = 0 }; --Fangterror
	[138446] = { zoneID = 0 }; --Fathom-Caller Zelissa
	[139675] = { zoneID = 0 }; --Fathom-Seeker
	[134799] = { zoneID = 0 }; --Fathomclaw
	[136051] = { zoneID = 0 }; --Fathomus
	[140671] = { zoneID = 0 }; --Feralclaw the Rager
	[139755] = { zoneID = 0 }; --First Mate McNally
	[133843] = { zoneID = 864, x = 0.414345920085907, y = 0.240411669015884 }; --First Mate Swainbeak
	[140550] = { zoneID = 0 }; --Flamechitter
	[132743] = { zoneID = 1501, artID = 1301, x = 0.3052218556404114, y = 0.8255899548530579 }; --Flamescale Wavebreaker
	[140555] = { zoneID = 0 }; --Flare Mongrel
	[140987] = { zoneID = 0 }; --Fleshmelter the Insatiable
	[140854] = { zoneID = 0 }; --Flow
	[131404] = { zoneID = 942, x = 0.644301950931549, y = 0.659166038036346 }; --Foreman Scripps
	[140272] = { zoneID = 0 }; --Forest-Strider
	[139386] = { zoneID = 1501, artID = 1301, x = 0.4560864567756653, y = 0.8058711290359497 }; --Forked-Tongue
	[139766] = { zoneID = 0 }; --Former Navigator Dublin
	[142686] = { zoneID = 14, artID = 1137, x = 0.223221302032471, y = 0.511286735534668 }; --Foulbelly
	[132211] = { zoneID = 895, x = 0.907093226909638, y = 0.772382318973541 }; --Fowlmouth
	[132127] = { zoneID = 895, x = 0.601013600826263, y = 0.221902117133141 }; --Foxhollow Skyterror
	[126462] = { zoneID = 14, artID = 1137 }; --Fozruk CHECK IF DELETE
	[140757] = { zoneID = 14, artID = 1137 }; --Fozruk CHECK IF DELETE
	[142433] = { zoneID = 14, artID = 1137, x = 0.603884696960449, y = 0.277620106935501 }; --Fozruk
	[139768] = { zoneID = 0 }; --Freebooter Dan
	[132448] = { zoneID = 0 }; --Frostbeard the Candlekeeper
	[140763] = { zoneID = 0 }; --Frosthill Giant
	[132746] = { zoneID = 0 }; --Frostscale Broodmother
	[140774] = { zoneID = 0 }; --Frozen Stonelord
	[140680] = { zoneID = 0 }; --Frozenhorn Rampager
	[133155] = { zoneID = 862, x = 0.799735426902771, y = 0.359570026397705 }; --G'Naat
	[129954] = { zoneID = 862, x = 0.642698168754578, y = 0.326890677213669 }; --Gahz'ralka
	[135830] = { zoneID = 0 }; --Galefury
	[132007] = { zoneID = 942, x = 0.714493572711945, y = 0.543581187725067 }; --Galestorm
	[131410] = { zoneID = 0 }; --Gargantuan Venomscale
	[139412] = { zoneID = 0 }; --Gashasz
	[135225] = { zoneID = 0 }; --Geirn the Windmill
	[139421] = { zoneID = 0 }; --Gekkaz Moss-Scaled
	[140777] = { zoneID = 0 }; --Gemshard Colossus
	[140385] = { zoneID = 0 }; --Gemshell Broodkeeper
	[138504] = { zoneID = 0 }; --General Drakkarion
	[138574] = { zoneID = 0 }; --General Erxuul
	[137553] = { zoneID = 864, x = 0.606, y = 0.626 }; --General Krathax
	[138573] = { zoneID = 0 }; --General Nu'aggth
	[138575] = { zoneID = 0 }; --General Shuul'aqar
	[138572] = { zoneID = 0 }; --General Uvosh
	[138444] = { zoneID = 0 }; --General Vesparak
	[136278] = { zoneID = 0 }; --General Zaviul
	[142662] = { zoneID = 14, x = 0.794278264045715, y = 0.294276773929596 }; --Geomancer Flintdagger
	[138288] = { zoneID = 0 }; --Ghost of the Deep
	[140299] = { zoneID = 0 }; --Ghostfang
	[140082] = { zoneID = 1501, artID = 1301, x = 0.415465772151947, y = 0.694817304611206 }; --Gibb
	[139672] = { zoneID = 0 }; --Gibberfin
	[132892] = { zoneID = 0 }; --Giddyleaf
	[140676] = { zoneID = 0 }; --Gigantic Stoneback
	[140864] = { zoneID = 0 }; --Gigglefit
	[140682] = { zoneID = 0 }; --Glacierfist
	[139599] = { zoneID = 0 }; --Gladiator Ortugg
	[140089] = { zoneID = 0 }; --Gloamhoof the Elder
	[121242] = { zoneID = 863, artID = 888, x = 0.687739431858063, y = 0.574723422527313 }; --Glompmaw
	[134793] = { zoneID = 0 }; --Glowspine
	[127844] = { zoneID = 896, x = 0.631081759929657, y = 0.697352588176727 }; --Gluttonous Yeti
	[140981] = { zoneID = 0 }; --Gnashing Horror
	[140298] = { zoneID = 0 }; --Gol'kun the Vicious
	[135448] = { zoneID = 0 }; --Gol'than the Malodorous
	[129027] = { zoneID = 864, x = 0.592328369617462, y = 0.0785175859928131 }; --Golanar
	[140769] = { zoneID = 0 }; --Goldenvein
	[136813] = { zoneID = 0 }; --Goldsniffer
	[124185] = { zoneID = 862, x = 0.741154730319977, y = 0.285000592470169 }; --Golrakahn
	[139596] = { zoneID = 0 }; --Gordo the Oracle
	[129835] = { zoneID = 896, x = 0.571188509464264, y = 0.443146258592606 }; --Gorehorn
	[130584] = { zoneID = 0 }; --Gorespike
	[136050] = { zoneID = 0 }; --Gorestream
	[138675] = { zoneID = 896, x = 0.279983341693878, y = 0.259585976600647 }; --Gorged Boar
	[140694] = { zoneID = 0 }; --Gorgejaw the Glutton
	[139588] = { zoneID = 0 }; --Gorkul the Unstoppable
	[143559] = { zoneID = 0 }; --Grand Marshal Tremblade
	[139349] = { zoneID = 0 }; --Grave-Caller Muja
	[136003] = { zoneID = 0 }; --Gravellus
	[136804] = { zoneID = 0 }; --Gravelspine
	[138997] = { zoneID = 0 }; --Grawlash the Frenzied
	[140097] = { zoneID = 0 }; --Great Dirtbelly
	[134946] = { zoneID = 0 }; --Great Huntsman
	[136863] = { zoneID = 0 }; --Great Mota
	[140147] = { zoneID = 0 }; --Great Ursu
	[140979] = { zoneID = 0 }; --Greatfangs
	[140267] = { zoneID = 0 }; --Greathorn Uwanu
	[140435] = { zoneID = 0 }; --Greyfur
	[135838] = { zoneID = 0 }; --Grimebreeze
	[141059] = { zoneID = 942, x = 0.619362235069275, y = 0.738605082035065 }; --Grimscowl the Harebrained
	[134822] = { zoneID = 0 }; --Gritplate Matriarch
	[140061] = { zoneID = 0 }; --Grizzlefur Den-Mother
	[124580] = { zoneID = 0 }; --Grotto Terrapin
	[136893] = { zoneID = 0 }; --Groundshaker Aggan
	[127129] = { zoneID = 896, x = 0.503427624702454, y = 0.206377133727074 }; --Grozgore
	[138991] = { zoneID = 0 }; --Grrl
	[138632] = { zoneID = 0 }; --Guardian Asuda
	[139431] = { zoneID = 0 }; --Guardian of Tombs
	[139233] = { zoneID = 895, x = 0.578459799289703, y = 0.559010028839111 }; --Gulliver
	[139355] = { zoneID = 0 }; --Guran the Frostblade
	[138993] = { zoneID = 0 }; --Gurlack
	[137057] = { zoneID = 0 }; --Gurthani the Elder
	[140681] = { zoneID = 0 }; --Gurudu The Gorge
	[128674] = { zoneID = 864, x = 0.640200614929199, y = 0.475015729665756 }; --Gut-Gut the Glutton
	[128426] = { zoneID = 863, artID = 888, x = 0.328894168138504, y = 0.430654585361481 }; --Gutrip
	[140768] = { zoneID = 0 }; --Guuru the Mountain-Breaker
	[127001] = { zoneID = 863, x = 0.338049709796906, y = 0.859970271587372 }; --Gwugnug the Cursed
	[141226] = { zoneID = 942, x = 0.351858049631119, y = 0.777995228767395 }; --Haegol the Hammer
	[134738] = { zoneID = 862, x = 0.42033988237381, y = 0.362165480852127 }; --Hakbi the Risen
	[138824] = { zoneID = 0 }; --Halfid Ironeye
	[138569] = { zoneID = 0 }; --Harbinger Vor'zzyx
	[134800] = { zoneID = 0 }; --Hardened Snapjaw
	[139406] = { zoneID = 0 }; --Hassan the Bloody Scale
	[138618] = { zoneID = 896, x = 0.243201300501823, y = 0.300116002559662 }; --Haywire Golem
	[139760] = { zoneID = 0 }; --Head Navigator Franklin
	[136878] = { zoneID = 981, artID = 981, x = 0.6799765825271606, y = 0.5675484538078308 }; --Headbang
	[140080] = { zoneID = 0 }; --Headbasher
	[134637] = { zoneID = 862, x = 0.6307862997055054, y = 0.1402785331010819 }; --Headhunter Lee'za
	[137059] = { zoneID = 0 }; --Headshrinker Gaha
	[135999] = { zoneID = 0 }; --Heliodor
	[127901] = { zoneID = 896, x = 0.593574404716492, y = 0.55403858423233 }; --Henry Breakwater
	[138637] = { zoneID = 0 }; --Hephet
	[138570] = { zoneID = 0 }; --Herald Razzaqi
	[137058] = { zoneID = 0 }; --Hexxer Magoda
	[139595] = { zoneID = 0 }; --High Guard Makag
	[139419] = { zoneID = 0 }; --High Oracle Asayza
	[139404] = { zoneID = 0 }; --High Prophet Massas
	[139697] = { zoneID = 0 }; --High Shaman Claxikar
	[139601] = { zoneID = 0 }; --High Shaman Morg
	[143536] = { zoneID = 862, x = 0.516, y = 0.582 }; --High Warlord Volrath
	[140693] = { zoneID = 0 }; --Hisskarath
	[140372] = { zoneID = 0 }; --Hive Guardian Ksh'ix
	[140374] = { zoneID = 0 }; --Hive Guardian Yx'nil
	[138849] = { zoneID = 0 }; --Hivelord Vix'ick
	[130443] = { zoneID = 864, x = 0.536000728607178, y = 0.537231802940369 }; --Hivemother Kraxi
	[138647] = { zoneID = 0 }; --Hjana Fogbringer
	[139875] = { zoneID = 0 }; --Hollow Widow
	[137183] = { zoneID = 895, x = 0.64199996, y = 0.192 }; --Honey-Coated Slitherer
	[138370] = { zoneID = 0 }; --Horko
	[142725] = { zoneID = 14, artID = 1137, x = 0.194308683276176, y = 0.613148748874664 }; --Horrific Apparition
	[138831] = { zoneID = 0 }; --Horvuld Oceanscythe
	[138653] = { zoneID = 0 }; --Hosvir of the Rotting Hull
	[135923] = { zoneID = 0 }; --Hound of Gazzran
	[137140] = { zoneID = 0 }; --Hulking Charger
	[140110] = { zoneID = 0 }; --Hydralurk
	[134754] = { zoneID = 896, x = 0.229381501674652, y = 0.494856029748917 }; --Hyo'gi
	[141039] = { zoneID = 942, x = 0.635375797748566, y = 0.835708200931549 }; --Ice Sickle
	[140982] = { zoneID = 0 }; --Icecracker
	[136047] = { zoneID = 981, artID = 981, x = 0.6935237050056458, y = 0.6615415811538696 }; --Iceheart
	[131735] = { zoneID = 0 }; --Idej the Wise
	[124399] = { zoneID = 863, x = 0.240957200527191, y = 0.775810658931732 }; --Infected Direhorn
	[140558] = { zoneID = 0 }; --Inferno Terror
	[137906] = { zoneID = 0 }; --Infused Bedrock
	[138825] = { zoneID = 0 }; --Ingathora Blood-Drinker
	[138829] = { zoneID = 0 }; --Ingel the Cunning
	[136890] = { zoneID = 0 }; --Iron Orkas
	[139188] = { zoneID = 0 }; --Ironfur
	[136850] = { zoneID = 0 }; --Ironhide Dulan
	[132913] = { zoneID = 0 }; --Island Ettin
	[135647] = { zoneID = 981, artID = 981, x = 0.4799362421035767, y = 0.3409149646759033 }; --Ituakee
	[139475] = { zoneID = 0 }; --Jade-Formed Bonesnapper
	[140857] = { zoneID = 0 }; --Jadeflare
	[134769] = { zoneID = 0 }; --Jagged Claw
	[139764] = { zoneID = 0 }; --Jaime the Cutlass
	[141043] = { zoneID = 942, x = 0.534797251224518, y = 0.645272314548492 }; --Jakala the Cruel
	[136858] = { zoneID = 0 }; --Jan'li
	[133373] = { zoneID = 863, artID = 888, x = 0.451775312423706, y = 0.518914878368378 }; --Jax'teb the Reanimated
	[140387] = { zoneID = 0 }; --Jeweled Queen
	[133527] = { zoneID = 863, x = 0.281568825244904, y = 0.338956534862518 }; --Juba the Scarred
	[129283] = { zoneID = 864, x = 0.37400621175766, y = 0.852293848991394 }; --Jumbo Sandsnapper
	[124927] = { zoneID = 0 }; --Jun-Ti
	[126169] = { zoneID = 0 }; --Jungle King Runtu
	[140079] = { zoneID = 0 }; --Jungle-Screamer
	[136341] = { zoneID = 864, x = 0.605554044246674, y = 0.180103063583374 }; --Jungleweb Hunter
	[142475] = { zoneID = 0 }; --Ka'za the Mezmerizing
	[139038] = { zoneID = 0 }; --Kaihu
	[124397] = { zoneID = 863, x = 0.529076397418976, y = 0.131552219390869 }; --Kal'draxa
	[138482] = { zoneID = 0 }; --Kaluriak the Alchemist
	[128686] = { zoneID = 864, x = 0.350692808628082, y = 0.518380403518677 }; --Kamid the Trapper
	[122062] = { zoneID = 0 }; --Kamul Cloudsong
	[126637] = { zoneID = 862, artID = 887, x = 0.686589300632477, y = 0.487611055374146 }; --Kandak
	[139227] = { zoneID = 0 }; --Keeper Undarius
	[130791] = { zoneID = 0 }; --Khut'een
	[132244] = { zoneID = 862, x = 0.756284356117249, y = 0.359045714139938 }; --Kiboku
	[141029] = { zoneID = 942, x = 0.313033282756805, y = 0.617177426815033 }; --Kickers
	[134936] = { zoneID = 0 }; --Kil'tilac
	[136852] = { zoneID = 0 }; --Kilnkeeper Odo
	[136835] = { zoneID = 0 }; --Kin'toga Beastbane
	[137681] = { zoneID = 864, x = 0.382785707712173, y = 0.414023399353027 }; --King Clickyclack
	[129005] = { zoneID = 863, artID = 888, x = 0.534226179122925, y = 0.428368985652924 }; --King Kooba
	[140081] = { zoneID = 0 }; --King Lukka
	[134796] = { zoneID = 0 }; --King Spineclaw
	[142739] = { zoneID = 14, artID = 1137, x = 0.48907858133316, y = 0.399451732635498 }; --Knight-Captain Aldrin
	[123269] = { zoneID = 0 }; --Kook
	[142112] = { zoneID = 14, x = 0.49181067943573, y = 0.841642618179321 }; --Kor'gresh Coldrage
	[142684] = { zoneID = 14, artID = 1137, x = 0.252199590206146, y = 0.485551804304123 }; --Kovork
	[129832] = { zoneID = 0 }; --Krack
	[125214] = { zoneID = 863, x = 0.757058322429657, y = 0.359346568584442 }; --Krubbs
	[138564] = { zoneID = 0 }; --Kshuun
	[120899] = { zoneID = 1165, artID = 1143, x = 0.549887120723724, y = 0.825321078300476 }; --Kul'krazahn
	[140083] = { zoneID = 0 }; --Kula the Thunderer
	[131520] = { zoneID = 895, x = 0.479090541601181, y = 0.226362377405167 }; --Kulett the Ornery
	[138388] = { zoneID = 0 }; --Kung
	[138440] = { zoneID = 0 }; --Lady Assana
	[134707] = { zoneID = 0 }; --Lady Seirine
	[136879] = { zoneID = 0 }; --Lava-Eater Mabutu
	[135930] = { zoneID = 0 }; --Lavarok
	[134903] = { zoneID = 0 }; --Leeching Horror
	[131233] = { zoneID = 862, x = 0.58678013086319, y = 0.741758644580841 }; --Lei-zhi
	[138826] = { zoneID = 0 }; --Leikneir the Brave
	[139218] = { zoneID = 0 }; --Life-Tender Olvarius
	[139680] = { zoneID = 0 }; --Lightless Hunter
	[133539] = { zoneID = 863, x = 0.777520179748535, y = 0.450991898775101 }; --Lo'kuno
	[127877] = { zoneID = 896, x = 0.592415630817413, y = 0.552555322647095 }; --Longfang
	[140092] = { zoneID = 0 }; --Longstrider
	[142434] = { zoneID = 0 }; --Loo'ay
	[136046] = { zoneID = 0 }; --Lord Abyssian
	[135936] = { zoneID = 0 }; --Lord Amar'zan
	[135994] = { zoneID = 0 }; --Lord Amythite
	[136042] = { zoneID = 0 }; --Lord Aquanoth
	[138436] = { zoneID = 0 }; --Lord Coilfin
	[135842] = { zoneID = 0 }; --Lord Fruzaan
	[135933] = { zoneID = 0 }; --Lord Gazzran
	[118172] = { zoneID = 0 }; --Lord Hydronicus
	[135934] = { zoneID = 0 }; --Lord Incindivar
	[135960] = { zoneID = 0 }; --Lord Jaggruk
	[135845] = { zoneID = 0 }; --Lord Kamet
	[135996] = { zoneID = 0 }; --Lord Korslate
	[135935] = { zoneID = 0 }; --Lord Magmarr
	[136048] = { zoneID = 0 }; --Lord Mercurius
	[135843] = { zoneID = 0 }; --Lord Mudal
	[135844] = { zoneID = 0 }; --Lord Sumar
	[135997] = { zoneID = 0 }; --Lord Zircon
	[139432] = { zoneID = 0 }; --Lu'si
	[134296] = { zoneID = 863, artID = 888, x = 0.681004285812378, y = 0.202328741550446 }; --Lucille
	[139189] = { zoneID = 0 }; --Lumberclaw the Ancient
	[134106] = { zoneID = 895, x = 0.683352112770081, y = 0.200146958231926 }; --Lumbergrasp Sentinel
	[134791] = { zoneID = 0 }; --Luminous Crawler
	[138866] = { zoneID = 896, x = 0.244668245315552, y = 0.219531953334808 }; --Mack
	[140764] = { zoneID = 0 }; --Magma Giant
	[139290] = { zoneID = 895, x = 0.585159420967102, y = 0.494630873203278 }; --Maison the Portable
	[128935] = { zoneID = 863, x = 0.526238262653351, y = 0.53823584318161 }; --Mala'kili
	[135958] = { zoneID = 0 }; --Malachite
	[142716] = { zoneID = 14, artID = 1137, x = 0.521666824817658, y = 0.767394900321961 }; --Man-Hunter Rog
	[138387] = { zoneID = 0 }; --Mangol
	[140454] = { zoneID = 0 }; --Many-Braids the Elder
	[139411] = { zoneID = 0 }; --Many-Fangs
	[139673] = { zoneID = 0 }; --Many-Teeth
	[140991] = { zoneID = 981, artID = 981, x = 0.5153030157089233, y = 0.5314074754714966 }; --Marrowbore
	[143560] = { zoneID = 0 }; --Marshal Gabriel
	[139600] = { zoneID = 0 }; --Maruk the Volcano
	[134112] = { zoneID = 0 }; --Matron Christiane
	[137704] = { zoneID = 896, artID = 921, x = 0.3484510183334351, y = 0.1986713856458664 }; --Matron Morana
	[128610] = { zoneID = 863, x = 0.498930662870407, y = 0.672028541564941 }; --Maw of Shul-Nagruth
	[135217] = { zoneID = 0 }; --Maximillian of Northshire
	[139814] = { zoneID = 0 }; --Merger Specialist Huzzle
	[131252] = { zoneID = 895, x = 0.430432260036469, y = 0.167540028691292 }; --Merianae
	[138870] = { zoneID = 896, x = 0.244, y = 0.22 }; --Mick
	[139414] = { zoneID = 0 }; --Mire Priest Vassz
	[139413] = { zoneID = 0 }; --Mirelurk Oasis-Speaker
	[139231] = { zoneID = 0 }; --Mirewood the Trampler
	[136379] = { zoneID = 0 }; --Misham Endseeker
	[140171] = { zoneID = 0 }; --Mistfur
	[140169] = { zoneID = 0 }; --Mogka the Rowdy
	[141942] = { zoneID = 14, x = 0.476612329483032, y = 0.78041410446167 }; --Molok the Crusher
	[135924] = { zoneID = 0 }; --Molten Fury
	[136855] = { zoneID = 0 }; --Molten Vordo
	[140549] = { zoneID = 0 }; --Moltenweb Devourer
	[135720] = { zoneID = 1501, artID = 1301, x = 0.627495527267456, y = 0.5800143480300903 }; --Moon-Touched Huntress
	[140426] = { zoneID = 0 }; --Moonbeard
	[140248] = { zoneID = 0 }; --Moonchaser the Swift
	[135723] = { zoneID = 0 }; --Moonclaw
	[139025] = { zoneID = 0 }; --Moonsong
	[134694] = { zoneID = 864, artID = 889, x = 0.3743573129177094, y = 0.8910739421844482 }; --Mor'fani the Exile
	[139694] = { zoneID = 0 }; --Mordshell
	[139670] = { zoneID = 0 }; --Morgok
	[140828] = { zoneID = 0 }; --Morningdew
	[134935] = { zoneID = 0 }; --Mother Vishis
	[140663] = { zoneID = 0 }; --Mountain Lord Grum
	[136012] = { zoneID = 0 }; --Mountanus the Immovable
	[138988] = { zoneID = 0 }; --Mrgl-Eye
	[136839] = { zoneID = 0 }; --Mrogan
	[138987] = { zoneID = 0 }; --Muckfin High Oracle
	[127290] = { zoneID = 895, x = 0.586507678031921, y = 0.14800001680851 }; --Mugg
	[139529] = { zoneID = 0 }; --Muklai
	[134782] = { zoneID = 862, x = 0.604328572750092, y = 0.665217518806458 }; --Murderbeak
	[140439] = { zoneID = 0 }; --Muskflank Herdleader
	[140065] = { zoneID = 0 }; --Muskhide
	[139759] = { zoneID = 0 }; --Mutineer Jalia
	[128498] = { zoneID = 0 }; --Mutineer Kabwalla
	[138565] = { zoneID = 0 }; --My'lyth
	[126223] = { zoneID = 0 }; --Mystic Sharpfang
	[132749] = { zoneID = 0 }; --NAME
	[132750] = { zoneID = 0 }; --NAME
	[136800] = { zoneID = 0 }; --NAME
	[136803] = { zoneID = 0 }; --NAME
	[136815] = { zoneID = 0 }; --NAME
	[138655] = { zoneID = 0 }; --NAME
	[138656] = { zoneID = 0 }; --NAME
	[138657] = { zoneID = 0 }; --NAME
	[138658] = { zoneID = 0 }; --NAME
	[132747] = { zoneID = 0 }; --NAME
	[138833] = { zoneID = 0 }; --NAME
	[138834] = { zoneID = 0 }; --NAME
	[138835] = { zoneID = 0 }; --NAME
	[132748] = { zoneID = 0 }; --NAME
	[138832] = { zoneID = 0 }; --NAME
	[138502] = { zoneID = 0 }; --Naroviak Wyrm-Bender
	[139219] = { zoneID = 0 }; --Nasira Morningfrost
	[139387] = { zoneID = 1501, artID = 1301, x = 0.5112245082855225, y = 0.7931448221206665 }; --Nassa the Cold-Blooded
	[139444] = { zoneID = 0 }; --Necrolord Zian
	[135589] = { zoneID = 0 }; --Necrotic Mass
	[136887] = { zoneID = 0 }; --Needlemane
	[138963] = { zoneID = 942, x = 0.432, y = 0.45 }; --Nestmother Acada
	[139589] = { zoneID = 0 }; --Netherweaver Ukk
	[130138] = { zoneID = 896, x = 0.599422335624695, y = 0.454817533493042 }; --Nevermore
	[128951] = { zoneID = 864, x = 0.437613397836685, y = 0.862346172332764 }; --Nez'ara
	[138309] = { zoneID = 0 }; --Nibnub
	[139024] = { zoneID = 0 }; --Nightfeather
	[139876] = { zoneID = 0 }; --Nightleech
	[134904] = { zoneID = 0 }; --Nightlurker
	[142692] = { zoneID = 14, artID = 1137, x = 0.676216185092926, y = 0.608678758144379 }; --Nimar the Slayer
	[140297] = { zoneID = 0 }; --Nok-arak
	[118192] = { zoneID = 0 }; --Norgor
	[138391] = { zoneID = 0 }; --Norko the Thrower
	[136851] = { zoneID = 0 }; --Nuru Emberbraid
	[138485] = { zoneID = 0 }; --Nuzoriak the Experimenter
	[138566] = { zoneID = 0 }; --Nyl'sozz
	[138483] = { zoneID = 0 }; --Obsidian Monstrosity
	[138479] = { zoneID = 0 }; --Obsidian Overlord
	[138484] = { zoneID = 0 }; --Obsidian Prophet
	[138487] = { zoneID = 0 }; --Obsidian Wing-Spreader
	[134797] = { zoneID = 0 }; --Ocean Recluse
	[139597] = { zoneID = 0 }; --Oggog Magmafist
	[138985] = { zoneID = 0 }; --Old Grmgl
	[140438] = { zoneID = 0 }; --Old Longtooth
	[140183] = { zoneID = 0 }; --Old Muckhide
	[140071] = { zoneID = 0 }; --Old One-Fang
	[122639] = { zoneID = 1165, x = 0.49895787239075, y = 0.59664618968964 }; --Old R'gal
	[140390] = { zoneID = 0 }; --Onyx Bilefeaster
	[136872] = { zoneID = 0 }; --Oof Brainbasher
	[138308] = { zoneID = 0 }; --Ook-Aak
	[139666] = { zoneID = 0 }; --Orgl the Totemic
	[136862] = { zoneID = 0 }; --Orgo
	[139591] = { zoneID = 0 }; --Oronn Many-Tongues
	[141239] = { zoneID = 942, x = 0.42269292473793, y = 0.63249546289444 }; --Osca the Bloodied
	[126019] = { zoneID = 0 }; --Overfed Mawfiend
	[136818] = { zoneID = 0 }; --Overseer Flamelicker
	[142423] = { zoneID = 14, artID = 1137, x = 0.274756163358688, y = 0.570993065834045 }; --Overseer Krix
	[138503] = { zoneID = 0 }; --Overseer of Twilight
	[136819] = { zoneID = 0 }; --Overseer Rat-Tail
	[136816] = { zoneID = 0 }; --Overseer Snorgle
	[136817] = { zoneID = 0 }; --Overseer Steelsnout
	[124375] = { zoneID = 863, artID = 888, x = 0.621072351932526, y = 0.6520676612854 }; --Overstuffed Saurolisk
	[139205] = { zoneID = 895, x = 0.652314186096191, y = 0.645278990268707 }; --P4-N73R4
	[131262] = { zoneID = 895, x = 0.388924062252045, y = 0.153003871440887 }; --Pack Leader Asenya
	[138631] = { zoneID = 0 }; --Pathfinder Qadim
	[137649] = { zoneID = 942, artID = 967, x = 0.363614559173584, y = 0.3763246834278107 }; --Pest Remover Mk. II
	[140452] = { zoneID = 0 }; --Pikehorn the Sleeper
	[140093] = { zoneID = 0 }; --Pinegraze Fawnmother
	[139298] = { zoneID = 942, x = 0.382612287998199, y = 0.511345088481903 }; --Pinku'shon
	[142435] = { zoneID = 14, artID = 1137, x = 0.369677752256393, y = 0.659718632698059 }; --Plaguefeather
	[142361] = { zoneID = 0 }; --Plaguefeather
	[141286] = { zoneID = 942, x = 0.346519261598587, y = 0.679694294929504 }; --Poacher Zane
	[143313] = { zoneID = 896, x = 0.666961014270783, y = 0.509763598442078 }; --Portakillo
	[138636] = { zoneID = 0 }; --Prince Abari
	[139884] = { zoneID = 0 }; --Prophet Doom-Ra
	[138634] = { zoneID = 0 }; --Prophet Lapisa
	[139885] = { zoneID = 0 }; --Prophet Nox'tir
	[139883] = { zoneID = 0 }; --Prophet Va'kiz'asha
	[140858] = { zoneID = 0 }; --Pyrekin
	[135925] = { zoneID = 0 }; --Pyroblaze
	[139467] = { zoneID = 981, artID = 981, x = 0.5984443426132202, y = 0.5457243919372559 }; --Qinsu the Granite Fist
	[139474] = { zoneID = 0 }; --Qor-Xin the Earth-Caller
	[135959] = { zoneID = 0 }; --Quakestomp the Rumbler
	[140373] = { zoneID = 0 }; --Queen Duneshell
	[140327] = { zoneID = 0 }; --Queen Stonehusk
	[128974] = { zoneID = 863, artID = 888, x = 0.577178299427033, y = 0.677038967609406 }; --Queen Tzxi'kik
	[125453] = { zoneID = 896, x = 0.665780901908875, y = 0.427338033914566 }; --Quillrat Matriarch
	[140155] = { zoneID = 0 }; --Rabid Rotclaw
	[140073] = { zoneID = 0 }; --Rabidmaw
	[139019] = { zoneID = 0 }; --Rageback
	[142436] = { zoneID = 14, x = 0.120678886771202, y = 0.521822869777679 }; --Ragebeak
	[142321] = { zoneID = 943, x = 0.331544041633606, y = 0.418363809585571 }; --Ragebeak
	[140673] = { zoneID = 0 }; --Ragesnarl
	[140659] = { zoneID = 0 }; --Ragestomp
	[132179] = { zoneID = 895, x = 0.647706508636475, y = 0.586164712905884 }; --Raging Swell
	[134884] = { zoneID = 942, x = 0.416468262672424, y = 0.743555128574371 }; --Ragna
	[140148] = { zoneID = 0 }; --Rampaging Grizzlefur
	[126181] = { zoneID = 0 }; --Ramut the Black
	[139278] = { zoneID = 895, x = 0.68305903673172, y = 0.635641515254974 }; --Ranja
	[115226] = { zoneID = 0 }; --Ravenian
	[134802] = { zoneID = 0 }; --Razorback
	[136889] = { zoneID = 0 }; --Razorcaller Tuk
	[140102] = { zoneID = 0 }; --Razorhog
	[128580] = { zoneID = 0 }; --Razorjaw
	[140343] = { zoneID = 0 }; --Razorwing
	[137983] = { zoneID = 1161, x = 0.31429588794708, y = 0.63912308216095 }; --Rear Admiral Hainsworth
	[132047] = { zoneID = 942, artID = 967, x = 0.710610330104828, y = 0.517039835453033 }; --Reinforced Hullbreaker
	[136340] = { zoneID = 864, artID = 889, x = 0.48990672826767, y = 0.721690893173218 }; --Relic Hunter Hazaak
	[135643] = { zoneID = 0 }; --Ren'kiri
	[140593] = { zoneID = 0 }; --Restless Horror
	[135650] = { zoneID = 0 }; --REUSE
	[140856] = { zoneID = 0 }; --REUSE
	[140862] = { zoneID = 0 }; --REUSE
	[140859] = { zoneID = 0 }; --REUSE
	[128707] = { zoneID = 896, x = 0.596167623996735, y = 0.718331217765808 }; --Rimestone
	[140557] = { zoneID = 0 }; --Ripface
	[140300] = { zoneID = 0 }; --Ripshread
	[136806] = { zoneID = 0 }; --Rockmagus Bargg
	[128930] = { zoneID = 863, x = 0.5261589884758, y = 0.543482959270477 }; --Rohnkor
	[140157] = { zoneID = 0 }; --Rotclaw Cub-Eater
	[139194] = { zoneID = 1041, x = 0.621846795082092, y = 0.635345339775086 }; --Rotmaw
	[139417] = { zoneID = 0 }; --Rotwood the Cursed
	[123293] = { zoneID = 0 }; --Royal Sand Crab
	[140388] = { zoneID = 0 }; --Ruby Scavenger
	[140863] = { zoneID = 0 }; --Rubywind Prankster
	[140995] = { zoneID = 0 }; --Ruinstalker
	[126432] = { zoneID = 943, x = 0.5689457654953, y = 0.612031698226929 }; --Rumbling Goliath
	[140765] = { zoneID = 0 }; --Rumbling Goliath
	[141620] = { zoneID = 14, artID = 1137, x = 0.298627108335495, y = 0.598020493984222 }; --Rumbling Goliath
	[140273] = { zoneID = 0 }; --Runehoof Denkeeper
	[142683] = { zoneID = 14, x = 0.429001748561859, y = 0.564952790737152 }; --Ruul Onestone
	[139335] = { zoneID = 0 }; --Sabertron
	[139328] = { zoneID = 942, x = 0.342, y = 0.324 }; --Sabertron
	[139356] = { zoneID = 942 }; --Sabertron
	[139359] = { zoneID = 0 }; --Sabertron
	[139336] = { zoneID = 0 }; --Sabertron
	[119103] = { zoneID = 0 }; --Sable Enforcer
	[138989] = { zoneID = 0 }; --Saltfin
	[141021] = { zoneID = 0 }; --Sand Apparition
	[138374] = { zoneID = 0 }; --Sand Fur
	[130581] = { zoneID = 0 }; --Sand-Eye
	[139988] = { zoneID = 942, x = 0.735142767429352, y = 0.606443643569946 }; --Sandfang
	[141306] = { zoneID = 0 }; --Sandscour
	[134768] = { zoneID = 0 }; --Sandskitter the Relentless
	[122090] = { zoneID = 0 }; --Sarashas the Pillager
	[127765] = { zoneID = 0 }; --Saurolisk Matriarch
	[127289] = { zoneID = 895, x = 0.586507678031921, y = 0.14800001680851 }; --Saurolisk Tamer Mugg
	[139287] = { zoneID = 1161, x = 0.788532674312592, y = 0.387624382972717 }; --Sawtooth
	[140111] = { zoneID = 0 }; --Scaldix the Poison Spear
	[127776] = { zoneID = 864, x = 0.440703064203262, y = 0.804166257381439 }; --Scaleclaw Broodmother
	[138443] = { zoneID = 0 }; --Scaleguard Buleth
	[139390] = { zoneID = 1501, artID = 1301, x = 0.5117604732513428, y = 0.7909072041511536 }; --Scaleguard Sarrisz
	[136834] = { zoneID = 0 }; --Scalper Bazuulu
	[140301] = { zoneID = 0 }; --Scarpaw
	[138984] = { zoneID = 0 }; --Scarscale
	[140794] = { zoneID = 0 }; --Scartalon
	[139762] = { zoneID = 0 }; --Scavenger Faith
	[136336] = { zoneID = 864, x = 0.327064871788025, y = 0.650914132595062 }; --Scorpox
	[127820] = { zoneID = 863, artID = 888, x = 0.591399550437927, y = 0.387850403785706 }; --Scout Skrasniss
	[127873] = { zoneID = 863, artID = 888, x = 0.580807864665985, y = 0.0893820598721504 }; --Scrounger Patriarch
	[140424] = { zoneID = 0 }; --Scythehorn
	[138938] = { zoneID = 942, x = 0.337620079517365, y = 0.384156703948975 }; --Seabreaker Skoloth
	[139769] = { zoneID = 0 }; --Second Mate Barnaby
	[139818] = { zoneID = 0 }; --Security Officer Durk
	[138995] = { zoneID = 0 }; --Seed-Keeper Ungan
	[139667] = { zoneID = 0 }; --Seer Grglok
	[139813] = { zoneID = 0 }; --Senior Producer Gixi
	[139470] = { zoneID = 0 }; --Serpent Master Xisho
	[140271] = { zoneID = 0 }; --Severhorn
	[140997] = { zoneID = 942, x = 0.225762754678726, y = 0.732128798961639 }; --Severus the Outcast
	[128923] = { zoneID = 0 }; --Sha'khee
	[134905] = { zoneID = 0 }; --Shadeweb Huntress
	[134902] = { zoneID = 0 }; --Shadow-Weaver
	[136836] = { zoneID = 0 }; --Shadowbreaker Urzula
	[139351] = { zoneID = 0 }; --Shadowspeaker Angolo
	[139669] = { zoneID = 0 }; --Shaman Garmr
	[124475] = { zoneID = 863, x = 0.291525572538376, y = 0.558570802211762 }; --Shambling Ambusher
	[139671] = { zoneID = 0 }; --Sharkslayer Mugluk
	[140074] = { zoneID = 0 }; --Sharptooth
	[138567] = { zoneID = 0 }; --Shathhoth the Punisher
	[134910] = { zoneID = 0 }; --Shimmerweb
	[140362] = { zoneID = 0 }; --Shimmerwing
	[139765] = { zoneID = 0 }; --Shipless Jimmy
	[139285] = { zoneID = 895, x = 0.551244556903839, y = 0.324088424444199 }; --Shiverscale the Toxic
	[139678] = { zoneID = 0 }; --Shoal-Walker
	[135044] = { zoneID = 0 }; --Shredmaw the Voracious
	[138568] = { zoneID = 1502, artID = 1302, x = 0.3579469323158264, y = 0.3875377774238586 }; --Shuk'shuguun the Subjugator
	[138648] = { zoneID = 0 }; --Sigrid the Shroud-Weaver
	[126449] = { zoneID = 0 }; --Siltspitter
	[142690] = { zoneID = 14, x = 0.505889534950256, y = 0.574513971805573 }; --Singer
	[136338] = { zoneID = 864, x = 0.245719775557518, y = 0.684502422809601 }; --Sirokar
	[141143] = { zoneID = 942, x = 0.615729331970215, y = 0.570583462715149 }; --Sister Absinthe
	[139226] = { zoneID = 0 }; --Sister Anana
	[138863] = { zoneID = 896, x = 0.329817295074463, y = 0.571168899536133 }; --Sister Martha
	[126508] = { zoneID = 0 }; --Skethik
	[143316] = { zoneID = 862, x = 0.494994431734085, y = 0.652647376060486 }; --Skullcap
	[142437] = { zoneID = 14, artID = 1137, x = 0.572123348712921, y = 0.442028939723969 }; --Skullripper
	[142312] = { zoneID = 943, artID = 968, x = 0.663362264633179, y = 0.57548850774765 }; --Skullripper
	[139602] = { zoneID = 0 }; --Skur the Unbroken
	[125816] = { zoneID = 1165, x = 0.500356078147888, y = 0.84046745300293 }; --Sky Queen
	[140344] = { zoneID = 0 }; --Sky Viper
	[134571] = { zoneID = 864, x = 0.46976238489151, y = 0.251730591058731 }; --Skycaller Teskris
	[134745] = { zoneID = 864, x = 0.512941122055054, y = 0.364561408758163 }; --Skycarver Krakit
	[139486] = { zoneID = 0 }; --Skycrack
	[140249] = { zoneID = 0 }; --Slatehide
	[134949] = { zoneID = 0 }; --Slateskitter
	[139319] = { zoneID = 942, x = 0.418368428945541, y = 0.284284234046936 }; --Slickspill
	[138439] = { zoneID = 0 }; --Slitherqueen Valla
	[139415] = { zoneID = 0 }; --Slitherscale
	[140437] = { zoneID = 0 }; --Slow Olo
	[139018] = { zoneID = 0 }; --Slumbering Mountain
	[138389] = { zoneID = 0 }; --Smasha
	[138307] = { zoneID = 0 }; --Smashface
	[140063] = { zoneID = 0 }; --Smashmaw the Man-Eater
	[140556] = { zoneID = 0 }; --Smokehound
	[135926] = { zoneID = 0 }; --Smolderheart
	[138375] = { zoneID = 0 }; --Smoos
	[140436] = { zoneID = 0 }; --Snorthoof
	[140091] = { zoneID = 0 }; --Snowhoof
	[141175] = { zoneID = 942, x = 0.708605170249939, y = 0.322270750999451 }; --Song Mistress Dadalea
	[136304] = { zoneID = 864, x = 0.668966114521027, y = 0.244509622454643 }; --Songstress Nahjeen
	[138441] = { zoneID = 0 }; --Songstress of the Deep
	[140358] = { zoneID = 0 }; --Sorrowcall
	[137665] = { zoneID = 896, artID = 921, x = 0.271853893995285, y = 0.5488458871841431 }; --Soul Goliath
	[138851] = { zoneID = 0 }; --Soul Hunter
	[139438] = { zoneID = 0 }; --Soul-Bringer Togan
	[139346] = { zoneID = 0 }; --Soul-Speaker Galani
	[139045] = { zoneID = 0 }; --Speaker Juchi
	[139042] = { zoneID = 0 }; --Spearmaster Kashai
	[139592] = { zoneID = 0 }; --Spellbinder Goro
	[138509] = { zoneID = 0 }; --Spellbinder Ulura
	[129836] = { zoneID = 942, x = 0.552, y = 0.616 }; --Spelltwister Moephus
	[139443] = { zoneID = 0 }; --Spinebender Kuntai
	[139468] = { zoneID = 0 }; --Spineripper Ku-Kon
	[135045] = { zoneID = 0 }; --Spinesnapper
	[136873] = { zoneID = 0 }; --Spitshot
	[132280] = { zoneID = 895, x = 0.80910849571228, y = 0.828341364860535 }; --Squacks
	[141088] = { zoneID = 942, x = 0.570468544960022, y = 0.759826123714447 }; --Squall
	[139135] = { zoneID = 895, x = 0.488860905170441, y = 0.370189428329468 }; --Squirgle of the Depths
	[139418] = { zoneID = 0 }; --Stagnant One
	[139389] = { zoneID = 0 }; --Steelscale Volshasis
	[140333] = { zoneID = 0 }; --Steelshell
	[140988] = { zoneID = 0 }; --Steelshred
	[132450] = { zoneID = 0 }; --Stinkboot
	[137708] = { zoneID = 896, artID = 921, x = 0.4976232051849365, y = 0.4379974007606506 }; --Stone Golem
	[139473] = { zoneID = 0 }; --Stone Machinist Nu-Xin
	[139472] = { zoneID = 0 }; --Stone-Lord Qinsho
	[140088] = { zoneID = 0 }; --Stonehorn the Charger
	[136809] = { zoneID = 0 }; --Stonejaw the Rock-Eater
	[140112] = { zoneID = 0 }; --Stonelash
	[118175] = { zoneID = 0 }; --Storm Elemental
	[140345] = { zoneID = 0 }; --Stormscreech
	[138473] = { zoneID = 0 }; --Stygia
	[137061] = { zoneID = 0 }; --Suluz Wind-Tamer
	[140360] = { zoneID = 0 }; --Sunback
	[140425] = { zoneID = 0 }; --Surefoot
	[139757] = { zoneID = 0 }; --Sureshot Johnson
	[136801] = { zoneID = 0 }; --Surveyor Grimesalt
	[139564] = { zoneID = 0 }; --Swainbeak
	[135839] = { zoneID = 0 }; --Swampgas
	[140101] = { zoneID = 0 }; --Swampwallow
	[139695] = { zoneID = 0 }; --Swipeclaw
	[138651] = { zoneID = 0 }; --Sylveria Reefcaller
	[136413] = { zoneID = 862, x = 0.534339964389801, y = 0.447046548128128 }; --Syrawon the Dominus
	[139280] = { zoneID = 895, x = 0.667342483997345, y = 0.131802096962929 }; --Sythian the Swift
	[138437] = { zoneID = 0 }; --Szerris the Invader
	[138842] = { zoneID = 0 }; --Ta'kil the Resonator
	[130788] = { zoneID = 0 }; --Taghira
	[126460] = { zoneID = 863, x = 0.314699292182922, y = 0.381827712059021 }; --Tainted Guardian
	[139980] = { zoneID = 942, x = 0.599677860736847, y = 0.458515167236328 }; --Taja the Tidehowler
	[134924] = { zoneID = 0 }; --Taloc IGC
	[129950] = { zoneID = 896, x = 0.319383561611176, y = 0.406205981969833 }; --Talon
	[138477] = { zoneID = 0 }; --Talonguard Vrykiss
	[131687] = { zoneID = 862, x = 0.776661217212677, y = 0.105015777051449 }; --Tambano
	[136814] = { zoneID = 0 }; --Tattertail
	[139539] = { zoneID = 0 }; --Tavok, Hammer of the Empress
	[131723] = { zoneID = 0 }; --Tehd and Marius
	[133356] = { zoneID = 895, x = 0.609269261360169, y = 0.170171156525612 }; --Tempestria
	[139289] = { zoneID = 895, x = 0.553134262561798, y = 0.51538759469986 }; --Tentulos the Drifter
	[131389] = { zoneID = 895, x = 0.636587262153626, y = 0.503649175167084 }; --Teres
	[139358] = { zoneID = 896, x = 0.25151252746582, y = 0.162454918026924 }; --The Caterer
	[136189] = { zoneID = 942, x = 0.517803370952606, y = 0.797846913337708 }; --The Lichen King
	[138998] = { zoneID = 0 }; --Thick-Hide
	[134948] = { zoneID = 0 }; --Thicket Stalker
	[140449] = { zoneID = 0 }; --Thickflank
	[138512] = { zoneID = 0 }; --Thorisiona
	[139016] = { zoneID = 0 }; --Thorncoat
	[139022] = { zoneID = 0 }; --Thornfur the Protector
	[138830] = { zoneID = 0 }; --Thorvast, Guided by the Stars
	[136841] = { zoneID = 0 }; --Thu'zun the Vile
	[140359] = { zoneID = 0 }; --Thunderhawk Devourer
	[142419] = { zoneID = 943, x = 0.607041954994202, y = 0.487267136573792 }; --Thundering Goliath
	[141616] = { zoneID = 14, x = 0.463370859622955, y = 0.521174490451813 }; --Thundering Goliath
	[118176] = { zoneID = 0 }; --Thundershock
	[140099] = { zoneID = 0 }; --Thundersnort the Loud
	[133163] = { zoneID = 862, x = 0.642841815948486, y = 0.232442662119865 }; --Tia'Kawan
	[141056] = { zoneID = 0 }; --Tide Lord Makuna
	[141058] = { zoneID = 0 }; --Tide Lord Szunis
	[141057] = { zoneID = 0 }; --Tide Lord Vorshasz
	[138652] = { zoneID = 0 }; --Tide-Cursed Mistress
	[138650] = { zoneID = 0 }; --Tide-Lost Champion
	[138431] = { zoneID = 0 }; --Tidemistress Najula
	[138432] = { zoneID = 0 }; --Tidemistress Nessa
	[132921] = { zoneID = 0 }; --Tidemistress Sser'ah
	[138433] = { zoneID = 981, artID = 981, x = 0.8493967652320862, y = 0.9042405486106873 }; --Tidemistress Vessana
	[138438] = { zoneID = 0 }; --Tidereaver Steelfang
	[139043] = { zoneID = 0 }; --Tidestriker Ocho
	[138994] = { zoneID = 0 }; --Timberfist
	[134804] = { zoneID = 1501, artID = 1301, x = 0.7010776400566101, y = 0.7466039657592773 }; --Timeless Runeback
	[140767] = { zoneID = 0 }; --TO DO
	[143311] = { zoneID = 863, x = 0.732, y = 0.496 }; --Toadcruel
	[140386] = { zoneID = 0 }; --Topaz Borer
	[127939] = { zoneID = 862, x = 0.46736291050911, y = 0.653291344642639 }; --Torraske the Eternal
	[139235] = { zoneID = 895, x = 0.704130411148071, y = 0.557437896728516 }; --Tort Jaw
	[138640] = { zoneID = 0 }; --Torus
	[126056] = { zoneID = 863, artID = 888, x = 0.494227945804596, y = 0.376948654651642 }; --Totem Maker Jash'ga
	[132076] = { zoneID = 895, x = 0.46851196885109, y = 0.206489250063896 }; --Totes
	[136860] = { zoneID = 0 }; --Tracker Vu'ka
	[136875] = { zoneID = 0 }; --Trader Udu
	[140182] = { zoneID = 0 }; --Trampleleaf the Jungle Quake
	[140855] = { zoneID = 0 }; --Trickle
	[139445] = { zoneID = 0 }; --Tumat
	[140389] = { zoneID = 0 }; --Tunnel-Keeper Ky'nyx
	[136891] = { zoneID = 0 }; --Tuskbreaker the Scarred
	[138510] = { zoneID = 0 }; --Twilight Doomcaller
	[138516] = { zoneID = 1501, artID = 1301, x = 0.6082821488380432, y = 0.8274484276771545 }; --Twilight Evolutionist
	[135722] = { zoneID = 1501, artID = 1301, x = 0.6732236742973328, y = 0.470425546169281 }; --Twilight Prowler
	[131984] = { zoneID = 895, x = 0.703424513339996, y = 0.124857723712921 }; --Twin-hearted Construct
	[130643] = { zoneID = 862, x = 0.76797753572464, y = 0.277539819478989 }; --Twisted Child of Rezan
	[138475] = { zoneID = 0 }; --Tyrantion
	[136876] = { zoneID = 0 }; --Ugh the Feared
	[136864] = { zoneID = 0 }; --Uguu the Feared
	[140269] = { zoneID = 0 }; --Ulu'tale
	[122004] = { zoneID = 862, x = 0.714141607284546, y = 0.323940843343735 }; --Umbra'jin
	[134717] = { zoneID = 862, x = 0.492218375205994, y = 0.294240534305573 }; --Umbra'rix
	[138474] = { zoneID = 0 }; --Umbralion
	[137579] = { zoneID = 0 }; --Unbound Azerite
	[134823] = { zoneID = 0 }; --Unbreakable Crystalspine
	[138508] = { zoneID = 0 }; --Unbreakable Vortax
	[139191] = { zoneID = 0 }; --Underbrush
	[134002] = { zoneID = 863, x = 0.553478240966797, y = 0.576387107372284 }; --Underlord Xerxiz
	[136857] = { zoneID = 0 }; --Undol the Herdmaster
	[139353] = { zoneID = 0 }; --Unliving Champion
	[138990] = { zoneID = 0 }; --Urgl the Blind
	[128965] = { zoneID = 863, artID = 888, x = 0.442639172077179, y = 0.487708687782288 }; --Uroku the Bound
	[138889] = { zoneID = 0 }; --Uvuld the Forseer
	[136865] = { zoneID = 0 }; --Uzan the Sandreaver
	[140339] = { zoneID = 0 }; --Vale Terror
	[140661] = { zoneID = 0 }; --Valethunder
	[130401] = { zoneID = 864, x = 0.573196887969971, y = 0.732954561710358 }; --Vathikur
	[134795] = { zoneID = 0 }; --Veiled Hermit
	[136837] = { zoneID = 981, artID = 981, x = 0.6080244779586792, y = 0.2072033286094666 }; --Venomancer Ant'su
	[142438] = { zoneID = 14, x = 0.572603166103363, y = 0.541368782520294 }; --Venomarus
	[142301] = { zoneID = 943, x = 0.519623756408691, y = 0.105818212032318 }; --Venomarus
	[139210] = { zoneID = 0 }; --Venombulb
	[126926] = { zoneID = 863, x = 0.292170405387878, y = 0.505377769470215 }; --Venomjaw
	[140113] = { zoneID = 0 }; --Venomlash
	[140357] = { zoneID = 0 }; --Venomreaver
	[136044] = { zoneID = 0 }; --Venomswell
	[139809] = { zoneID = 0 }; --Venture Acquisitions Specialist
	[139810] = { zoneID = 0 }; --Venture Middle Manager
	[139812] = { zoneID = 0 }; --Venture Producer
	[139811] = { zoneID = 0 }; --Venture Sub-Lead
	[138654] = { zoneID = 0 }; --Vestar of the Tattered Sail
	[138629] = { zoneID = 0 }; --Vicar Djosa
	[139820] = { zoneID = 0 }; --Vice President Fitzi Getzem
	[139821] = { zoneID = 0 }; --Vice President Frankie G.
	[139819] = { zoneID = 0 }; --Vice President Genni Newcom
	[139815] = { zoneID = 0 }; --Vice President Rax Blastem
	[127651] = { zoneID = 896, x = 0.726, y = 0.60400003 }; --Vicemaul
	[140098] = { zoneID = 0 }; --Vicious Scarhide
	[135043] = { zoneID = 0 }; --Vicious Vicejaw
	[140697] = { zoneID = 0 }; --Vile Asp
	[135834] = { zoneID = 0 }; --Vile Cloud
	[134821] = { zoneID = 0 }; --Vilegaze Petrifier
	[140156] = { zoneID = 0 }; --Vilemaw
	[134932] = { zoneID = 0 }; --Vileweb Broodqueen
	[139212] = { zoneID = 0 }; --Vinelash
	[135939] = { zoneID = 942, x = 0.496137499809265, y = 0.680618345737457 }; --Vinespeaker Ratha
	[128893] = { zoneID = 0 }; --Vinyeti
	[129977] = { zoneID = 0 }; --Vinyeti
	[129979] = { zoneID = 0 }; --Vinyeti
	[134912] = { zoneID = 0 }; --Violet Creeper
	[139410] = { zoneID = 0 }; --Visz the Silent Blade
	[139325] = { zoneID = 0 }; --Void Essence Kill Credit
	[132052] = { zoneID = 895, x = 0.51, y = 0.32 }; --Vol'Jim
	[135932] = { zoneID = 0 }; --Volcanar
	[140559] = { zoneID = 0 }; --Volcanor
	[139416] = { zoneID = 0 }; --Volshas
	[139889] = { zoneID = 0 }; --Vorus'arak
	[138563] = { zoneID = 0 }; --Vudax
	[128584] = { zoneID = 863, artID = 888, x = 0.467468827962875, y = 0.337344348430634 }; --Vugthuth
	[134048] = { zoneID = 862, x = 0.618749618530274, y = 0.462318748235703 }; --Vukuba
	[138649] = { zoneID = 0 }; --Vulf Stormshore
	[140329] = { zoneID = 0 }; --Vy'lix the Corpse-Mauler
	[133842] = { zoneID = 862, x = 0.439351499080658, y = 0.254376530647278 }; --Warcrawler Karkithiss
	[127831] = { zoneID = 0 }; --Warmother Zug
	[129411] = { zoneID = 864, x = 0.439035832881928, y = 0.540448129177094 }; --Zunashi the Exile
	[126095] = { zoneID = 0 }; --Vyliss
	[134805] = { zoneID = 0 }; --Wandering Behemoth
	[123282] = { zoneID = 0 }; --Warlord Mo'gosh
	[134766] = { zoneID = 0 }; --Wavespitter
	[134651] = { zoneID = 0 }; --Witch Doctor Habra'du
	[131476] = { zoneID = 862, x = 0.479982137680054, y = 0.542337834835053 }; --Zayoos
	[136838] = { zoneID = 0 }; --Zgordo the Brutalizer
	[136840] = { zoneID = 0 }; --Zoga
	[130079] = { zoneID = 942, x = 0.420291185379028, y = 0.747672557830811 }; --Wagga Snarltusk
	[129180] = { zoneID = 864, x = 0.370675086975098, y = 0.460459917783737 }; --Warbringer Hozzik
	[123189] = { zoneID = 0 }; --Warcaller Mog'ra
	[126907] = { zoneID = 863, artID = 888, x = 0.489739298820496, y = 0.507702112197876 }; --Wardrummer Zurula
	[134638] = { zoneID = 864, artID = 889, x = 0.301964282989502, y = 0.52557384967804 }; --Warlord Zothix
	[134625] = { zoneID = 864, x = 0.507168173789978, y = 0.308826357126236 }; --Warmother Captive
	[128973] = { zoneID = 896, x = 0.649695754051209, y = 0.21432276070118 }; --Whargarble the Ill-Tempered
	[129803] = { zoneID = 942, x = 0.473651260137558, y = 0.65836900472641 }; --Whiplash
	[134088] = { zoneID = 0 }; --Xibalan Apex
	[133531] = { zoneID = 863, artID = 888, x = 0.365385383367538, y = 0.505169451236725 }; --Xu'ba
	[124362] = { zoneID = 0 }; --Xu'e
	[129657] = { zoneID = 863, x = 0.387917220592499, y = 0.267669886350632 }; --Za'amar the Queen's Blade
	[133812] = { zoneID = 863, x = 0.380031049251556, y = 0.720523536205292 }; --Zanxib
	[131717] = { zoneID = 0 }; --Zayolin the Lifedrainer
	[128578] = { zoneID = 863, x = 0.395703166723251, y = 0.498361051082611 }; --Zujothgul
	[138513] = { zoneID = 0 }; --Vyrantion
	[138507] = { zoneID = 0 }; --Warlord Ultriss
	[138442] = { zoneID = 0 }; --Wavebreaker
	[138843] = { zoneID = 0 }; --Wingleader Srak'ik
	[138844] = { zoneID = 0 }; --Ya'vik the Imperial Blade
	[139220] = { zoneID = 0 }; --Vya Crystalbloom
	[139538] = { zoneID = 0 }; --Wall-Breaker Ha'vik
	[139405] = { zoneID = 0 }; --Wavebringer Sezzes'an
	[139044] = { zoneID = 0 }; --Wavemender Asha
	[139322] = { zoneID = 896, x = 0.295024067163467, y = 0.641008615493774 }; --Whitney "Steelclaw" Ramsay
	[139017] = { zoneID = 0 }; --Wildmane
	[139430] = { zoneID = 0 }; --Zaliz' Eternal Hound
	[139388] = { zoneID = 1501, artID = 1301, x = 0.5668027400970459, y = 0.8437842130661011 }; --Zess'ez
	[139469] = { zoneID = 0 }; --Zu-Xan of Thunder
	[140100] = { zoneID = 0 }; --Warsnort
	[139676] = { zoneID = 0 }; --Wave-Speaker Ormrg
	[139668] = { zoneID = 0 }; --Wavebinder Gorgl
	[140123] = { zoneID = 0 }; --Weaponmaster Halu
	[140270] = { zoneID = 0 }; --Wilderbuck
	[140398] = { zoneID = 942, x = 0.315911293029785, y = 0.550923585891724 }; --Zeritarj
	[140975] = { zoneID = 0 }; --Youngercraw
	[140844] = { zoneID = 0 }; --Zephis
	[142088] = { zoneID = 942, x = 0.468111276626587, y = 0.423692256212235 }; --Whirlwing
	[142251] = { zoneID = 943, artID = 968, x = 0.442937970161438, y = 0.282260119915009 }; --Yogursa
	[142440] = { zoneID = 14, x = 0.141743019223213, y = 0.376583099365234 }; --Yogursa
	[142682] = { zoneID = 14, x = 0.628907322883606, y = 0.811282753944397 }; --Zalas Witherbark
	[130350] = { zoneID = 895, x = 0.614758729934692, y = 0.516900360584259 }; --Guardian of the Spring
	[136390] = { zoneID = 864, x = 0.560652852058411, y = 0.535971939563751 }; --Enormous Egg
	[144420] = { zoneID = 942, x = 0.340152829885483, y = 0.319929927587509 }; 
	[140756] = { zoneID = 895, x = 0.631681978702545, y = 0.543679296970367 }; 
	[136410] = { zoneID = 862, x = 0.537307262420654, y = 0.449418932199478 }; 
	[127979] = { zoneID = 896, x = 0.630686223506928, y = 0.696623206138611 }; 

	-- Build 8.1.0.28366
	[149355] = { zoneID = 0 }; --Aberrant Azergem Crystalback
	[148154] = { zoneID = 0 }; --Agathe Wyrmwood
	[149517] = { zoneID = 0 }; --Agathe Wyrmwood
	[149652] = { zoneID = 62, artID = 1176, x = 0.49400002, y = 0.248 };  --Agathe Wyrmwood
	[146855] = { zoneID = 0 }; --Akina
	[148787] = { zoneID = 62, x = 0.564778208732605, y = 0.3076876997947693 }; --Alash'anir
	[147951] = { zoneID = 942, artID = 967, x = 0.414692044258118, y = 0.521476328372955 }; --Alkalinius
	[149241] = { zoneID = 0 }; --Alliance Captain
	[145292] = { zoneID = 0 }; --Alsian Vistreth
	[147966] = { zoneID = 62, x = 0.3782728910446167, y = 0.8478325605392456 }; --Aman
	[145392] = { zoneID = 895, artID = 920, x = 0.790230453014374, y = 0.422422796487808 }; --Ambassador Gaines
	[148393] = { zoneID = 862, x = 0.756736814975739, y = 0.357640296220779 }; --Ancient Defender
	[144855] = { zoneID = 0 }; --Apothecary Jerrod
	[148679] = { zoneID = 0 }; --Arcanist Quintril
	[147750] = { zoneID = 895, artID = 920, x = 0.831941902637482, y = 0.405085414648056 }; --Artillery Master Goodwin
	[147862] = { zoneID = 0 }; --Asennu
	[148037] = { zoneID = 62, x = 0.4089195430278778, y = 0.7278812527656555 }; --Athil Dewfire
	[147708] = { zoneID = 62, x = 0.5847851037979126, y = 0.243276059627533 }; --Athrikus Narassin
	[147957] = { zoneID = 0 }; --Azerchrysalis
	[149359] = { zoneID = 0 }; --Azerite Behemoth
	[146178] = { zoneID = 0 }; --Azurespine
	[146131] = { zoneID = 0 }; --Bartok the Burrower
	[149336] = { zoneID = 0 }; --Basaltic Azerite
	[148075] = { zoneID = 942, artID = 967, x = 0.349937230348587, y = 0.603082776069641 }; --Beast Tamer Watkins
	[148477] = { zoneID = 0 }; --Beastlord Drakara
	[148428] = { zoneID = 0 }; --Bilestomper
	[145272] = { zoneID = 0 }; --Blackpaw
	[149516] = { zoneID = 1332, artID = 1185, x = 0.567801594734192, y = 0.351940155029297 }; --Blackpaw
	[149651] = { zoneID = 0 }; --Blackpaw
	[149660] = { zoneID = 62, x = 0.4966042935848236, y = 0.2494930773973465 }; --Blackpaw
	[146238] = { zoneID = 0 }; --Blacksting
	[147854] = { zoneID = 0 }; --Blade-Dancer Zorlak
	[148322] = { zoneID = 862, artID = 887, x = 0.7627749443054199, y = 0.33497753739357 }; --Blinky Gizmospark
	[144954] = { zoneID = 0 }; --Bloodgorger
	[147866] = { zoneID = 0 }; --Bloodgorger
	[144827] = { zoneID = 0 }; --Bogbelcher
	[148744] = { zoneID = 0 }; --Brewmaster Lin
	[147873] = { zoneID = 0 }; --Broodqueen Cindrix
	[147872] = { zoneID = 0 }; --Broodqueen Vyl'tilac
	[149141] = { zoneID = 0 }; --Burninator Mark V
	[149349] = { zoneID = 0 }; --Calcified Azerite
	[147857] = { zoneID = 0 }; --Cannonmaster Arlin
	[145415] = { zoneID = 0 }; --Cap'n Gorok
	[147489] = { zoneID = 895, x = 0.759821712970734, y = 0.392704248428345 }; --Captain Greensails
	[148676] = { zoneID = 896, artID = 921, x = 0.321491658687592, y = 0.467117846012116 }; --Caravan Commander Veronica
	[145391] = { zoneID = 862, artID = 887, x = 0.77159309387207, y = 0.379059016704559 }; --Caravan Leader
	[145825] = { zoneID = 0 }; --Caravan Leader
	[148550] = { zoneID = 0 }; --Caravan Leader
	[148642] = { zoneID = 863, artID = 888, x = 0.826636254787445, y = 0.421838194131851 }; --Caravan Leader
	[145932] = { zoneID = 0 }; --Celestra Brightmoon
	[149337] = { zoneID = 0 }; --Coalesced Azerite
	[149358] = { zoneID = 0 }; --Colossal Azergem Crystalback
	[144831] = { zoneID = 0 }; --Colossal Spadefoot
	[147845] = { zoneID = 0 }; --Commander Drald
	[148025] = { zoneID = 62, x = 0.3794506192207336, y = 0.762427031993866 }; --Commander Ral'esh
	[147260] = { zoneID = 62, x = 0.3928767144680023, y = 0.6203259825706482 }; --Conflagros
	[148144] = { zoneID = 0 }; --Croz Bloodrage
	[149513] = { zoneID = 0 }; --Croz Bloodrage
	[149655] = { zoneID = 0 }; --Croz Bloodrage
	[149661] = { zoneID = 0 }; --Croz Bloodrage
	[147241] = { zoneID = 62, x = 0.4373315274715424, y = 0.5357814431190491 }; --Cyclarus
	[147880] = { zoneID = 0 }; --Dargulf the Spirit-Seeker
	[148257] = { zoneID = 0 }; --Death Captain Danielle
	[148259] = { zoneID = 0 }; --Death Captain Delilah
	[148253] = { zoneID = 0 }; --Death Captain Detheca
	[148343] = { zoneID = 862, artID = 887, x = 0.648285806179047, y = 0.398898929357529 }; --Dinohunter Wildbeard
	[148264] = { zoneID = 0 }; --Dinomancer Dajingo
	[145278] = { zoneID = 0 }; --Dinomancer Zakuru
	[148695] = { zoneID = 896, artID = 921, x = 0.31676921248436, y = 0.416014492511749 }; --Doctor Lazane
	[145020] = { zoneID = 0 }; --Dolizite
	[148510] = { zoneID = 0 }; --Drox'ar Morgar
	[148563] = { zoneID = 0 }; --Duchess Fallensong the Frigid
	[146848] = { zoneID = 0 }; --Eerie Conglomeration
	[145465] = { zoneID = 0 }; --Engineer Bolthold
	[149356] = { zoneID = 0 }; --Enraged Azergem Crystalback
	[148308] = { zoneID = 862, artID = 887, x = 0.770987033843994, y = 0.489081621170044 }; --Eric Quietfist
	[148534] = { zoneID = 864, artID = 889, x = 0.391450017690659, y = 0.673005223274231 }; --Evezon the Eternal
	[146188] = { zoneID = 0 }; --Firesting Dominator
	[144915] = { zoneID = 0 }; --Firewarden Viton Darkflare
	[146773] = { zoneID = 0 }; --First Mate Malone
	[145308] = { zoneID = 0 }; --First Sergeant Steelfang
	[146885] = { zoneID = 0 }; --Foulshriek
	[149343] = { zoneID = 0 }; --Frenzy Imbued Azerite
	[149344] = { zoneID = 0 }; --Fury Imbued Azerite
	[146882] = { zoneID = 0 }; --Gargantuan Blighthound
	[147958] = { zoneID = 0 }; --Geoactive Refraction
	[147955] = { zoneID = 0 }; --Georb
	[147928] = { zoneID = 0 }; --Geoscatter
	[147924] = { zoneID = 0 }; --Geoshard
	[146887] = { zoneID = 0 }; --Ghern the Rancid
	[146880] = { zoneID = 0 }; --Gholvran the Cryptic
	[145269] = { zoneID = 1332, x = 0.444968700408936, y = 0.357046842575073 }; --Glimmerspine
	[149654] = { zoneID = 62, artID = 1176, x = 0.4350595772266388, y = 0.1963830888271332 }; --Glimmerspine
	[147744] = { zoneID = 62, artID = 1176, x = 0.5738148093223572, y = 0.1567018181085587 }; --Glrglrr
	[147222] = { zoneID = 49, x = 0.243567138910294, y = 0.70962792634964 }; --Gnollfeaster
	[146139] = { zoneID = 0 }; --Goldspine
	[146942] = { zoneID = 0 }; --Grand Marshal Fury
	[146850] = { zoneID = 0 }; --Grand Master Ulrich
	[147877] = { zoneID = 0 }; --Grand Master Ulrich
	[147261] = { zoneID = 62, x = 0.4839521050453186, y = 0.5557230114936829 }; --Granokk
	[148031] = { zoneID = 62, x = 0.4091095328330994, y = 0.564441978931427 }; --Gren Tornfur
	[145271] = { zoneID = 0 }; --Grimhorn
	[149514] = { zoneID = 1332, artID = 1185, x = 0.589785218238831, y = 0.508006095886231 }; --Grimhorn
	[149656] = { zoneID = 0 }; --Grimhorn
	[149662] = { zoneID = 62, x = 0.5069974064826965, y = 0.3232641816139221 }; --Grimhorn
	[148860] = { zoneID = 0 }; --Grizzwald
	[147061] = { zoneID = 0 }; --Grubb
	[146813] = { zoneID = 0 }; --Gunther the Gray
	[144997] = { zoneID = 0 }; --Gurin Stonebinder
	[146869] = { zoneID = 0 }; --Gyrum the Virulent
	[146675] = { zoneID = 0 }; --Hartford Sternbach
	[147864] = { zoneID = 0 }; --Hisskarath
	[144952] = { zoneID = 0 }; --Hookfang
	[149245] = { zoneID = 0 }; --Horde Captain
	[146883] = { zoneID = 0 }; --Houndmaster Angvold
	[146886] = { zoneID = 0 }; --Hrolskald the Fetid
	[149360] = { zoneID = 0 }; --Hulking Azerite
	[147240] = { zoneID = 62, x = 0.5243692398071289, y = 0.3213121592998505 }; --Hydrath
	[145076] = { zoneID = 0 }; --In'le
	[149353] = { zoneID = 0 }; --Incandescent Azergem Crystalback
	[146112] = { zoneID = 0 }; --Inkfur Behemoth
	[148717] = { zoneID = 896, artID = 921, x = 0.278184205293655, y = 0.334144860506058 }; --Inquisitor Erik
	[148597] = { zoneID = 864, artID = 889, x = 0.382907688617706, y = 0.414916753768921 }; --Iron Shaman Grimbeard
	[145934] = { zoneID = 0 }; --Ivan the Mad
	[147849] = { zoneID = 0 }; --Jadeflare
	[146845] = { zoneID = 981, artID = 981, x = 0.7504346370697021, y = 0.443051815032959 }; --Jared the Jagged
	[148390] = { zoneID = 862, x = 0.754714548587799, y = 0.359031289815903 }; --Jessibelle Moonshield
	[149352] = { zoneID = 0 }; --Jeweled Azergem Crystalback
	[148456] = { zoneID = 0 }; --Jin'tago
	[146872] = { zoneID = 0 }; --Kachota the Exiled
	[145395] = { zoneID = 895, artID = 920, x = 0.790300190448761, y = 0.422120541334152 }; --Katrianna
	[146853] = { zoneID = 0 }; --Kefolkis the Unburied
	[147878] = { zoneID = 0 }; --Kefolkis the Unburied
	[147923] = { zoneID = 942, artID = 967, x = 0.317852884531021, y = 0.584820866584778 }; --Knight-Captain Joesiph
	[146852] = { zoneID = 0 }; --Konrad the Enslaver
	[148779] = { zoneID = 863, artID = 888, x = 0.8065462112426758, y = 0.1546286046504974 }; --Lightforged Warframe
	[145040] = { zoneID = 0 }; --Llorin the Clever
	[146876] = { zoneID = 0 }; --Machitu the Brutal
	[148723] = { zoneID = 0 }; --Maddok the Sniper
	[145250] = { zoneID = 0 }; --Madfeather
	[149657] = { zoneID = 62, x = 0.4398219883441925, y = 0.4852147996425629 }; --Madfeather
	[148739] = { zoneID = 0 }; --Magister Crystalynn
	[144826] = { zoneID = 0 }; --Man-Eater
	[146871] = { zoneID = 0 }; --Matriarch Nas'naya
	[146109] = { zoneID = 0 }; --Midnight Charger
	[146651] = { zoneID = 895, x = 0.744819045066834, y = 0.44949871301651 }; --Mistweaver Nian
	[149354] = { zoneID = 0 }; --Monstrous Azergem Crystalback
	[147562] = { zoneID = 0 }; --Mortar Master Zapfritz
	[145286] = { zoneID = 0 }; --Motega Bloodshield
	[147701] = { zoneID = 0 }; --Moxo the Beheader
	[147970] = { zoneID = 62, x = 0.3583525717258453, y = 0.8176379203796387 }; --Mrggr'marr
	[148155] = { zoneID = 0 }; --Muk'luk
	[146873] = { zoneID = 0 }; --Murderous Tempest
	[149147] = { zoneID = 862, x = 0.69566535949707, y = 0.367519974708557 }; --N'chala the Egg Thief
	[148092] = { zoneID = 942, artID = 967, x = 0.442843496799469, y = 0.4883924424648285 }; --Nalaess Featherseeker
	[146844] = { zoneID = 0 }; --Olfkrig the Indentured
	[146607] = { zoneID = 0 }; --Omgar Doombow
	[147758] = { zoneID = 62, x = 0.4521396160125732, y = 0.7494755983352661 }; --Onu
	[146979] = { zoneID = 864, artID = 889, x = 0.360472679138184, y = 0.496102064847946 }; --Ormin Rocketbop
	[148147] = { zoneID = 0 }; --Orwell Stevenson
	[149510] = { zoneID = 0 }; --Orwell Stevenson
	[149659] = { zoneID = 0 }; --Orwell Stevenson
	[149664] = { zoneID = 0 }; --Orwell Stevenson
	[148651] = { zoneID = 863, artID = 888, x = 0.422923773527145, y = 0.230231314897537 }; --Overgrown Ancient
	[146246] = { zoneID = 0 }; --Ovix the Toxic
	[148044] = { zoneID = 942, artID = 967, x = 0.508994996547699, y = 0.5228568911552429 }; --Owynn Graddock
	[148648] = { zoneID = 0 }; --Packmaster Swiftarrow
	[144951] = { zoneID = 0 }; --Palefur Devourer
	[149339] = { zoneID = 0 }; --Permeated Azerite
	[148674] = { zoneID = 0 }; --Plague Master Herbert
	[148403] = { zoneID = 0 }; --Portal Keeper Romiir
	[148753] = { zoneID = 0 }; --Ptin'go
	[146140] = { zoneID = 0 }; --Quilldozer
	[144956] = { zoneID = 0 }; --Razorbite
	[146143] = { zoneID = 0 }; --Razorspike
	[149351] = { zoneID = 0 }; --Rhodochrosite
	[148558] = { zoneID = 0 }; --Rockfury
	[148494] = { zoneID = 0 }; --Sandbinder Sodir
	[148103] = { zoneID = 62, artID = 1176, x = 0.3297478258609772, y = 0.8394355177879333 }; --Sapper Odette
	[145242] = { zoneID = 1332, artID = 1185, x = 0.52639228105545, y = 0.715166330337524 }; --Scalefiend
	[149665] = { zoneID = 62, x = 0.4763897657394409, y = 0.4454483985900879 }; --Scalefiend
	[148198] = { zoneID = 0 }; --Scout Captain Grizzleknob
	[144987] = { zoneID = 0 }; --Shadow Hunter Mutumba
	[148637] = { zoneID = 0 }; --Shadow Hunter Vol'tris
	[145268] = { zoneID = 0 }; --Shadowclaw
	[149512] = { zoneID = 1332, x = 0.365238547325134, y = 0.555191040039063 }; --Shadowclaw
	[149658] = { zoneID = 0 }; --Shadowclaw
	[149663] = { zoneID = 62, x = 0.3979129493236542, y = 0.3288328945636749 }; --Shadowclaw
	[144957] = { zoneID = 0 }; --Shali'i
	[147751] = { zoneID = 62, x = 0.4348946809768677, y = 0.2940788269042969 }; --Shattershard
	[145062] = { zoneID = 0 }; --Shi'sharin
	[147858] = { zoneID = 0 }; --Shipless Jimmy
	[145466] = { zoneID = 0 }; --Shredatron-2000
	[145161] = { zoneID = 0 }; --Siege Engineer Krackleboom
	[148451] = { zoneID = 0 }; --Siege O' Matic 9000
	[148231] = { zoneID = 0 }; --Siegebreaker Vol'gar
	[148842] = { zoneID = 0 }; --Siegeotron
	[147869] = { zoneID = 0 }; --Sigrid the Shroud-Weaver
	[146816] = { zoneID = 0 }; --Sir Barton Brigham
	[145928] = { zoneID = 0 }; --Skavis Nightstalker
	[146245] = { zoneID = 0 }; --Skitterwing
	[145232] = { zoneID = 0 }; --Skulli
	[148792] = { zoneID = 863, artID = 888, x = 0.488837718963623, y = 0.117439098656178 }; --Skycaptain Thermospark
	[147507] = { zoneID = 0 }; --Skycarver Krakit
	[145039] = { zoneID = 0 }; --Snowstalker
	[147897] = { zoneID = 62, x = 0.4061335325241089, y = 0.8532842397689819 }; --Soggoth the Slitherer
	[146881] = { zoneID = 0 }; --Soothsayer Brinvulf
	[146134] = { zoneID = 0 }; --Speedy
	[146870] = { zoneID = 0 }; --Spellbinder Ohnazae
	[146849] = { zoneID = 981, artID = 981, x = 0.6668627262115479, y = 0.4395135045051575 }; --Spirit Master Rowena
	[145927] = { zoneID = 0 }; --Starcaller Ellana
	[146854] = { zoneID = 0 }; --Stella Darkpaw
	[146244] = { zoneID = 0 }; --Stinging Fiend
	[147332] = { zoneID = 62, x = 0.4550538957118988, y = 0.5898854732513428 }; --Stonebinder Ssra'vess
	[145063] = { zoneID = 0 }; --Stormbeak
	[148759] = { zoneID = 0 }; --Stormcaller Morka
	[145226] = { zoneID = 0 }; --Strofnir
	[146611] = { zoneID = 895, artID = 920, x = 0.779812574386597, y = 0.491578489542007 }; --Strong Arm John
	[149346] = { zoneID = 0 }; --Suffused Azerite
	[146847] = { zoneID = 0 }; --Summoner Laniella
	[146114] = { zoneID = 0 }; --Surging Winds
	[145041] = { zoneID = 0 }; --Swifttail Stalker
	[149334] = { zoneID = 0 }; --Tectonic Azerite
	[145077] = { zoneID = 0 }; --Terrorwing
	[147435] = { zoneID = 62, x = 0.6212191581726074, y = 0.1652199476957321 }; --Thelar Moonstrike
	[148813] = { zoneID = 863, artID = 888, x = 0.521804869174957, y = 0.27666386961937 }; --Thomas Vandergrief
	[145229] = { zoneID = 0 }; --Throfnir
	[144829] = { zoneID = 0 }; --Thundercroak
	[146113] = { zoneID = 0 }; --Thunderhoof
	[147870] = { zoneID = 0 }; --Tide-Cursed Mistress
	[148276] = { zoneID = 0 }; --Tidebinder Maka
	[147941] = { zoneID = 942, artID = 967, x = 0.414681881666184, y = 0.520520210266113 }; --Tidesage Clarissa
	[144722] = { zoneID = 0 }; --Togoth Cruelarm
	[147860] = { zoneID = 0 }; --Torus
	[149335] = { zoneID = 0 }; --Tumultuous Azerite
	[146111] = { zoneID = 0 }; --Twenty Points
	[147942] = { zoneID = 62, x = 0.4060646593570709, y = 0.8268715739250183 }; --Twilight Prophet Graeme
	[147881] = { zoneID = 0 }; --Uvuld the Forseer
	[146875] = { zoneID = 0 }; --Valimok the Vicious
	[145228] = { zoneID = 0 }; --Valja
	[147321] = { zoneID = 0 }; --Venomjaw
	[144967] = { zoneID = 0 }; --Vinyeti
	[149341] = { zoneID = 0 }; --Vitrified Azerite
	[147998] = { zoneID = 942, artID = 967, x = 0.413508653640747, y = 0.539750218391418 }; --Voidmaster Evenshade
	[149338] = { zoneID = 1502, artID = 1302, x = 0.2432373762130737, y = 0.410154402256012 }; --Volatile Azerite
	[147853] = { zoneID = 0 }; --Wall-Breaker Ha'vik
	[146884] = { zoneID = 0 }; --Warlord Hjelskard
	[146110] = { zoneID = 0 }; --Waxing Moon
	[144833] = { zoneID = 0 }; --Whiptongue
	[146247] = { zoneID = 0 }; --White Death
	[146874] = { zoneID = 0 }; --Windcaller Mariah
	[148446] = { zoneID = 0 }; --Wolfleader Skraug
	[149383] = { zoneID = 0 }; --Xizz Gutshank
	[144830] = { zoneID = 0 }; --Yaz'za the Devourer
	[145112] = { zoneID = 0 }; --Zagg Brokeneye
	[144955] = { zoneID = 0 }; --Zal'zi the Bloodgorged
	[148862] = { zoneID = 896, x = 0.39440792798996, y = 0.399022817611694 }; --Zillie Wunderwrench
	[147664] = { zoneID = 0 }; --Zim'kaga
	[148146] = { zoneID = 0 }; --Zul'aki the Headhunter
	[145287] = { zoneID = 0 }; --Zunjo of Sen'jin
	[148295] = { zoneID = 62, artID = 1176, x = 0.412, y = 0.361 }; --Ivus the Decayed
	[144946] = { zoneID = 62, x = 0.412, y = 0.361 }; --Ivus the Forest Lord
	[149873] = { zoneID = 0 }; --Stanley
	[149886] = { zoneID = 0 }; --Stanley
	[149887] = { zoneID = 0 }; --Stanley
	[152557] = { zoneID = 0 }; --Trialmaster
	
	-- Build 8.2.0
	[152697] = { zoneID = 1355, artID = 1186, x = 0.8351465463638306, y = 0.3812071681022644 }; --Ulmath
	[153314] = { zoneID = 1355, artID = 1186, x = 0.5235252380371094, y = 0.255308985710144 }; --Aldrantiss
	[152415] = { zoneID = 1355, artID = 1186, x = 0.5950735211372375, y = 0.4362268447875977 }; --Alga the Eyeless
	[152416] = { zoneID = 1355, artID = 1186, x = 0.6803229451179504, y = 0.369282066822052 }; --Allseer Oma'kil
	[153309] = { zoneID = 1355, artID = 1186, x = 0.41599998, y = 0.246 }; --Alzana, Arrow of Thunder
	[152794] = { zoneID = 1355, artID = 1186, x = 0.5447224378585815, y = 0.5526800751686096 }; --Amethyst Spireshell
	[152566] = { zoneID = 1355, x = 0.578, y = 0.548 }; --Anemonar
	[151934] = { zoneID = 1462, artID = 1276, x = 0.5290257930755615, y = 0.4054615199565888 }; --Arachnoid Harvester
	[154342] = { zoneID = 1462, artID = 1276, x = 0.51, y = 0.37 }; --Arachnoid Harvester
	[150394] = { zoneID = 1462, artID = 1276, x = 0.603553831577301, y = 0.4468078911304474 }; --Armored Vaultbot
	[154968] = { zoneID = 1462, artID = 1276, x = 0.5655599236488342, y = 0.4509416222572327 }; --Armored Vaultbot
	[150191] = { zoneID = 1355, x = 0.368, y = 0.111999996 }; --Avarius
	[155331] = { zoneID = 0 }; --Azerite Behemoth
	[152361] = { zoneID = 1355, x = 0.698, y = 0.538 }; --Banescale the Packfather
	[152712] = { zoneID = 1355, artID = 1186, x = 0.3740364909172058, y = 0.8254230618476868 }; --Blindlight
	[153200] = { zoneID = 1462, artID = 1276, x = 0.5124651789665222, y = 0.5056332945823669 }; --Boilburn
	[153299] = { zoneID = 1355, artID = 1186, x = 0.638, y = 0.57 }; --Bonebreaker Szun
	[152001] = { zoneID = 1462, artID = 1276, x = 0.6601182222366333, y = 0.2819768786430359 }; --Bonepicker
	[151841] = { zoneID = 0 }; --Burgthok the Herald
	[149653] = { zoneID = 1355, x = 0.548, y = 0.42 }; --Carnivorous Lasher
	[154739] = { zoneID = 1462, artID = 1276, x = 0.6917940974235535, y = 0.5345146059989929 }; --Caustic Mechaslime
	[152464] = { zoneID = 1355, artID = 1186, x = 0.4132528305053711, y = 0.08827775716781616 }; --Caverndark Terror
	[152556] = { zoneID = 1355, artID = 1186, x = 0.491980254650116, y = 0.887514054775238 }; --Chasm-Haunter
	[151689] = { zoneID = 0 }; --Clawfoot the Leaper
	[151624] = { zoneID = 0 }; --Clockwork Giant
	[151850] = { zoneID = 0 }; --Commander Dilik
	[149847] = { zoneID = 1462, artID = 1276, x = 0.8245287537574768, y = 0.2093054950237274 }; --Crazed Trogg
	[152569] = { zoneID = 1462, artID = 1276, x = 0.8248880505561829, y = 0.2129155397415161 }; --Crazed Trogg
	[152570] = { zoneID = 1462, artID = 1276, x = 0.8245455026626587, y = 0.2093355804681778 }; --Crazed Trogg
	[152756] = { zoneID = 1355, artID = 1186, x = 0.3986904621124268, y = 0.2801477313041687 }; --Daggertooth Terror
	[151854] = { zoneID = 0 }; --Deathseeker Loshok
	[152291] = { zoneID = 1355, x = 0.56200004, y = 0.436 }; --Deepglider
	[151569] = { zoneID = 1462, artID = 1276, x = 0.3528560996055603, y = 0.4291911423206329 }; --Deepwater Maw
	[153315] = { zoneID = 1355, artID = 1186, x = 0.5147080421447754, y = 0.2556636333465576 }; --Eldanar
	[152414] = { zoneID = 1355, artID = 1186, x = 0.6561412215232849, y = 0.3285042643547058 }; --Elder Unu
	[152555] = { zoneID = 1355, artID = 1186, x = 0.5207043886184692, y = 0.7544835209846497 }; --Elderspawn Nalaada
	[154153] = { zoneID = 1462, artID = 1276, x = 0.5657069683074951, y = 0.6300513744354248 }; --Enforcer KX-T57
	[151159] = { zoneID = 1462, x = 0.45400003, y = 0.402 }; --Fleetfoot
	[151202] = { zoneID = 1462, artID = 1276, x = 0.6563528180122375, y = 0.5161255598068237 }; --Foul Manifestation
	[135497] = { zoneID = 1462, artID = 1276, x = 0.4521, y = 0.4312 }; --Fungarian Furor
	[153308] = { zoneID = 1355, artID = 1186, x = 0.48599997, y = 0.406 }; --Fury of Azshara
	[152553] = { zoneID = 1355, artID = 1186, x = 0.3672981858253479, y = 0.4012020230293274 }; --Garnetscale
	[153228] = { zoneID = 1462, artID = 1276, x = 0.6723161935806274, y = 0.5493391156196594 }; --Gear Checker Cogstar
	[150576] = { zoneID = 0 }; --Gears
	[153205] = { zoneID = 1462, artID = 1276, x = 0.5975485444068909, y = 0.6753897666931152 }; --Gemicide
	[153302] = { zoneID = 1355, artID = 1186, x = 0.42, y = 0.676 }; --Glacier Mage Zhiela
	[154701] = { zoneID = 1462, artID = 1276, x = 0.6966390013694763, y = 0.5424408912658691 }; --Gorged Gear-Cruncher
	[154640] = { zoneID = 1355, artID = 1186, x = 0.38, y = 0.554 }; --Grand Marshal Tremblade
	[152736] = { zoneID = 1355, artID = 1186, x = 0.837614893913269, y = 0.3539354205131531 }; --Guardian Tyr'mar
	[154641] = { zoneID = 1355, artID = 1186, x = 0.4876635074615479, y = 0.606906533241272 }; --High Warlord Volrath
	[154416] = { zoneID = 0 }; --Hisskari
	[155332] = { zoneID = 0 }; --Incandescent Azergem Crystalback
	[152448] = { zoneID = 1355, artID = 1186, x = 0.4722558856010437, y = 0.5611850023269653 }; --Iridescent Glimmershell
	[153300] = { zoneID = 1355, artID = 1186, x = 0.42200002, y = 0.69 }; --Iron Zoko
	[151684] = { zoneID = 1462, artID = 1276, x = 0.7716017961502075, y = 0.4455773532390595 }; --Jawbreaker
	[152567] = { zoneID = 1355, artID = 1186, x = 0.5017485618591309, y = 0.695204496383667 }; --Kelpwillow
	[152007] = { zoneID = 1462, artID = 1276, x = 0.4126, y = 0.3488 }; --Killsaw
	[152323] = { zoneID = 1355, artID = 1186, x = 0.2944130301475525, y = 0.2900329828262329 }; --King Gakula
	[152624] = { zoneID = 0 }; --King Gakula
	[153312] = { zoneID = 1355, artID = 1186, x = 0.414, y = 0.24 }; --Kyx'zhul the Deepspeaker
	[151845] = { zoneID = 0 }; --Lieutenant N'ot
	[151933] = { zoneID = 1462, artID = 1276, x = 0.606634795665741, y = 0.421489804983139 }; --Malfunctioning Beastbot
	[151124] = { zoneID = 1462, artID = 1276, x = 0.5691445469856262, y = 0.5210065245628357 }; --Mechagonian Nullifier 
	[150786] = { zoneID = 0 }; --Mechanized Crawler
	[151672] = { zoneID = 1462, artID = 1276, x = 0.8789516091346741, y = 0.2061178833246231 }; --Mecharantula
	[151688] = { zoneID = 0 }; --Melonsmasher
	[144644] = { zoneID = 1355, artID = 1186, x = 0.3650196194648743, y = 0.3830897808074951 }; --Mirecrawler
	[152729] = { zoneID = 1355, artID = 1186, x = 0.8385803699493408, y = 0.3394231796264648 }; --Moon Priestess Liara
	[153000] = { zoneID = 1462, artID = 1276, x = 0.8274032473564148, y = 0.2266615629196167 }; --Motobrain Spider
	[151627] = { zoneID = 1462, artID = 1276, x = 0.6102732419967651, y = 0.6144568920135498 }; --Mr. Fixthis
	[152465] = { zoneID = 1355, artID = 1186, x = 0.7099199295043945, y = 0.2458553314208984 }; --Needlespine
	[151686] = { zoneID = 1502, artID = 1302, x = 0.2981563806533814, y = 0.4423616528511047 }; --Nimblepaws the Thief
	[153206] = { zoneID = 1462, artID = 1276, x = 0.5574030876159668, y = 0.38020458817482 }; --Ol' Big Tusk
	[151680] = { zoneID = 1502, artID = 1302, x = 0.2978854179382324, y = 0.4073823094367981 }; --Orangetooth
	[152397] = { zoneID = 1355, artID = 1186, x = 0.7813016176223755, y = 0.2500696182250977 }; --Oronu
	[152764] = { zoneID = 1462, artID = 1276, x = 0.5741963386535645, y = 0.6375227570533752 }; --Oxidized Leachbeast
	[151702] = { zoneID = 1462, artID = 1276, x = 0.232584074139595, y = 0.6833801865577698 }; --Paol Pondwader
	[152681] = { zoneID = 1355, artID = 1186, x = 0.4304642081260681, y = 0.8794395923614502 }; --Prince Typhonus
	[152682] = { zoneID = 1355, artID = 1186, x = 0.4299296736717224, y = 0.7552899718284607 }; --Prince Vortran
	[155333] = { zoneID = 0 }; --Pulsing Azerite Geode
	[153310] = { zoneID = 1355, artID = 1186, x = 0.618, y = 0.122 }; --Qalina, Spear of Ice
	[151918] = { zoneID = 0 }; --Raz'kah of the North
	[153297] = { zoneID = 0 }; --REUSE
	[153298] = { zoneID = 0 }; --REUSE
	[151296] = { zoneID = 1462, artID = 1276, x = 0.5687886476516724, y = 0.3963374793529511 }; --Rocket
	[150583] = { zoneID = 1355, x = 0.3, y = 0.404 }; --Rockweed Shambler
	[150575] = { zoneID = 1462, artID = 1276, x = 0.396254688501358, y = 0.5306225419044495 }; --Rumblerocks
	[152182] = { zoneID = 1462, artID = 1276, x = 0.6583449840545654, y = 0.7917572855949402 }; --Rustfeather
	[152892] = { zoneID = 0 }; --Rusty Mechanocrawler
	[149746] = { zoneID = 0 }; --Rusty Mechaspider
	[151870] = { zoneID = 1355, artID = 1186, x = 0.6497119069099426, y = 0.2591013312339783 }; --Sandcastle
	[152795] = { zoneID = 1355, artID = 1186, x = 0.2874280214309692, y = 0.3857668042182922 }; --Sandclaw Stoneshell
	[152548] = { zoneID = 1355, x = 0.35599998, y = 0.412 }; --Scale Matriarch Gratinax
	[152545] = { zoneID = 1355, artID = 1186, x = 0.2716850638389587, y = 0.3703687191009522 }; --Scale Matriarch Vynara
	[152542] = { zoneID = 1355, x = 0.284, y = 0.46400002 }; --Scale Matriarch Zodia
	[150937] = { zoneID = 1462, artID = 1276, x = 0.1940868645906448, y = 0.8028293251991272 }; --Seaspit
	[153296] = { zoneID = 1355, artID = 1186, x = 0.336714506149292, y = 0.414139449596405 }; --Shalan'ali Stormtongue
	[152552] = { zoneID = 1355, artID = 1186, x = 0.6574263572692871, y = 0.05172550678253174 }; --Shassera
	[153088] = { zoneID = 0 }; --Shiny Mechaspider
	[153301] = { zoneID = 1355, artID = 1186, x = 0.33200002, y = 0.39200002 }; --Shirakess Starseeker
	[153658] = { zoneID = 1355, artID = 1186, x = 0.3733606934547424, y = 0.146463930606842 }; --Shiz'narasz the Consumer
	[151681] = { zoneID = 0 }; --Shorttail the Chucker
	[151687] = { zoneID = 0 }; --Shrieker
	[152359] = { zoneID = 1355, artID = 1186, x = 0.7164038419723511, y = 0.5483675003051758 }; --Siltstalker the Packmother
	[151690] = { zoneID = 0 }; --Singetooth
	[153311] = { zoneID = 1355, artID = 1186, x = 0.33400002, y = 0.30200002 }; --Slitherblade Azanz
	[152290] = { zoneID = 1355, artID = 1186, x = 0.5470188856124878, y = 0.502140998840332 }; --Soundless
	[151862] = { zoneID = 0 }; --Spiritwalker Fe'sal
	[154180] = { zoneID = 1355, artID = 1186, x = 0.3799697160720825, y = 0.5921164751052856 }; --Sslithara
	[153226] = { zoneID = 1462, artID = 1276, x = 0.235375314950943, y = 0.7796301245689392 }; --Steel Singer Freza
	[151685] = { zoneID = 0 }; --Stinkfur Denmother
	[150430] = { zoneID = 0 }; --Streetpig
	[151917] = { zoneID = 0 }; --Tar'al Bonespitter
	[154277] = { zoneID = 0 }; --Test Creature
	[152113] = { zoneID = 1462, artID = 1276, x = 0.6839, y = 0.4827 }; --The Kleptoboss
	[154225] = { zoneID = 1462, artID = 1276, x = 0.5721, y = 0.5838 }; --The Rusty Prince
	[151623] = { zoneID = 1462, artID = 1276, x = 0.7227, y = 0.5012 }; --The Scrap King
	[151625] = { zoneID = 1462, artID = 1276, x = 0.722007155418396, y = 0.4999014139175415 }; --The Scrap King
	[153898] = { zoneID = 1355, x = 0.61, y = 0.288 }; --Tidelord Aquatus
	[153928] = { zoneID = 1355, x = 0.576, y = 0.26 }; --Tidelord Dispersius
	[154148] = { zoneID = 1355, x = 0.65199995, y = 0.22600001 }; --Tidemistress Leth'sindra
	[152360] = { zoneID = 1355, artID = 1186, x = 0.6765625476837158, y = 0.4688071012496948 }; --Toxigore the Alpha
	[151940] = { zoneID = 1462, artID = 1276, x = 0.5796273946762085, y = 0.2214440107345581 }; --Uncle T'Rogg
	[153304] = { zoneID = 1355, artID = 1186, x = 0.682, y = 0.33 }; --Undana Frostbarb
	[153307] = { zoneID = 1355, artID = 1186, x = 0.48599997, y = 0.406 }; --Unleashed Arcanofiend
	[152568] = { zoneID = 1355, x = 0.314, y = 0.294 }; --Urduu
	[151719] = { zoneID = 1355, artID = 1186, x = 0.6729288101196289, y = 0.3458338975906372 }; --Voice in the Deeps
	[153303] = { zoneID = 1355, artID = 1186, x = 0.33, y = 0.4 }; --Voidblade Kassar
	[150468] = { zoneID = 1355, x = 0.482, y = 0.24200001 }; --Vor'koth
	[153313] = { zoneID = 1355, artID = 1186, x = 0.4183965921401978, y = 0.2334645390510559 }; --Vyz'olgo the Mind-Taker
	[152671] = { zoneID = 1355, artID = 1186, x = 0.4684925079345703, y = 0.7522476315498352 }; --Wekemara
	[151916] = { zoneID = 0 }; --Zaegra Sharpaxe
	[153305] = { zoneID = 1355, artID = 1186, x = 0.684, y = 0.33400002 }; --Zanj'ir Brutalizer
	[154949] = { zoneID = 0 }; --Zanj'ir Brutalizer
	[155811] = { zoneID = 1355, artID = 1186, x = 0.3344057202339172, y = 0.3012655973434448 }; --Commander Minzera
	[155838] = { zoneID = 1355, artID = 1186, x = 0.791060209274292, y = 0.509932816028595 }; --Incantatrix Vazina
	[155583] = { zoneID = 1462, artID = 1276, x = 0.8229547142982483, y = 0.7772676348686218 }; --Scrapclaw
	[155841] = { zoneID = 1355, artID = 1186, x = 0.734, y = 0.314 }; --Shadowbinder Athissa
	[155836] = { zoneID = 1355, artID = 1186, x = 0.4939302206039429, y = 0.6553937792778015 }; --Theurgist Nitara
	[155840] = { zoneID = 1355, artID = 1186, x = 0.4742978811264038, y = 0.3220067024230957 }; --Warlord Zalzjar
	[150342] = { zoneID = 1462, artID = 1276, x = 0.6408148407936096, y = 0.2405987530946732 }; --Earthbreaker Gulroc
	[151308] = { zoneID = 1462, artID = 1276, x = 0.5309227108955383, y = 0.3358480930328369 }; --Boggac Skullbash
	
	-- Build 8.2.5
	[155173] = { zoneID = 0 }; --Honeyback Usurper
	[155055] = { zoneID = 0 }; --Gurg the Hivethief
	[155176] = { zoneID = 0 }; --Old Nasha
	[158111] = { zoneID = 0 }; --Trialmaster
	[155171] = { zoneID = 0 }; --The Hivekiller
	[155172] = { zoneID = 0 }; --Trapdoor Bee Hunter
	[155059] = { zoneID = 0 }; --Yorag the Jelly Feaster
}

private.CONTAINER_ZONE_IDS = {
	[272771] = { zoneID = 830, x = 0.539505541324616, y = 0.676764726638794 }; 
	[272455] = { zoneID = 830, x = 0.51056182384491, y = 0.591467618942261 }; 
	[272456] = { zoneID = 830, x = 0.604903697967529, y = 0.278079926967621 }; 
	[273222] = { zoneID = 830, x = 0.718485116958618, y = 0.754145503044128 }; 
	[282722] = { zoneID = 863, artID = 888, x = 0.3316151797771454, y = 0.4366070330142975 }; 
	[282723] = { zoneID = 863, x = 0.3169411420822144, y = 0.7850332260131836 }; 
	[277561] = { zoneID = 862, x = 0.494994431734085, y = 0.652647376060486 }; 
	[281898] = { zoneID = 862, x = 0.387856274843216, y = 0.344339638948441 }; 
	[278456] = { zoneID = 862, artID = 887, x = 0.5971906185150146, y = 0.191363200545311 }; 
	[276735] = { zoneID = 1165, x = 0.382825076580048, y = 0.0714827105402947 }; 
	[278713] = { zoneID = 862, x = 0.6306034326553345, y = 0.2831933498382568 }; 
	[287320] = { zoneID = 864, x = 0.445057660341263, y = 0.261491566896439 }; 
	[278459] = { zoneID = 862, artID = 887, x = 0.4727555513381958, y = 0.6646109819412231 }; 
	[288596] = { zoneID = 1165, x = 0.444255739450455, y = 0.26922270655632 }; 
	[278460] = { zoneID = 862, artID = 887, x = 0.51072758436203, y = 0.4169873297214508 }; 
	[281903] = { zoneID = 862, artID = 887, x = 0.4088299572467804, y = 0.7651941776275635 }; 
	[278461] = { zoneID = 862, artID = 887, x = 0.493593603372574, y = 0.279375284910202 }; 
	[284454] = { zoneID = 1165, artID = 1143, x = 0.593013167381287, y = 0.886645793914795 }; 
	[278462] = { zoneID = 862, artID = 887, x = 0.6661543846130371, y = 0.3457407057285309 }; 
	[281905] = { zoneID = 862, artID = 887, x = 0.8108474612236023, y = 0.4071697592735291 }; 
	[287324] = { zoneID = 864, x = 0.577404975891113, y = 0.646397650241852 }; 
	[281906] = { zoneID = 862, x = 0.567527949810028, y = 0.753980457782745 }; 
	[280504] = { zoneID = 863, x = 0.768778026103973, y = 0.621428787708283 }; 
	[280951] = { zoneID = 864, x = 0.443273097276688, y = 0.92215222120285 }; 
	[290770] = { zoneID = 864, artID = 889, x = 0.5221953988075256, y = 0.8337863683700562 }; 
	[288604] = { zoneID = 862, artID = 887, x = 0.801415085792542, y = 0.550483405590057 }; 
	[279299] = { zoneID = 863, artID = 888, x = 0.462193876504898, y = 0.829722404479981 }; 
	[279366] = { zoneID = 863, artID = 888, x = 0.384000986814499, y = 0.268951743841171 }; 
	[278793] = { zoneID = 862, x = 0.6335594654083252, y = 0.1542438864707947 }; 
	[278795] = { zoneID = 862, artID = 887, x = 0.745059728622437, y = 0.247647061944008 }; 
	[271849] = { zoneID = 830, x = 0.568218350410461, y = 0.721074283123016 }; 
	[284408] = { zoneID = 864, artID = 889, x = 0.606896162033081, y = 0.1222416535019875 }; 
	[277715] = { zoneID = 863, artID = 888, x = 0.430601298809052, y = 0.507829606533051 }; 
	[284409] = { zoneID = 864, artID = 889, x = 0.535581827163696, y = 0.164618626236916 }; 
	[279373] = { zoneID = 863, artID = 888, x = 0.4103606343269348, y = 0.510258674621582 }; 
	[280522] = { zoneID = 863, x = 0.778979897499085, y = 0.463620781898499 }; 
	[284411] = { zoneID = 864, x = 0.529038071632385, y = 0.301978290081024 }; 
	[284413] = { zoneID = 864, x = 0.3849479258060455, y = 0.4681097567081451 }; 
	[290725] = { zoneID = 862, x = 0.529649674892426, y = 0.471931338310242 }; 
	[284416] = { zoneID = 864, artID = 889, x = 0.304890334606171, y = 0.538099825382233 }; 
	[279253] = { zoneID = 863, x = 0.776865720748901, y = 0.361358255147934 }; 
	[284418] = { zoneID = 864, artID = 889, x = 0.3758132457733154, y = 0.7604649066925049 }; 
	[279260] = { zoneID = 863, artID = 888, x = 0.356361865997314, y = 0.856095612049103 }; 
	[278716] = { zoneID = 862, artID = 887, x = 0.752567768096924, y = 0.623573303222656 }; 
	[272633] = { zoneID = 863, x = 0.817662239074707, y = 0.305250853300095 }; 
	[278436] = { zoneID = 863, x = 0.667924702167511, y = 0.173468172550201 }; 
	[281092] = { zoneID = 862, x = 0.647117555141449, y = 0.216731280088425 }; 
	[278437] = { zoneID = 863, x = 0.427721112966538, y = 0.261998921632767 }; 
	[284417] = { zoneID = 864, artID = 889, x = 0.318463087081909, y = 0.614532947540283 }; 
	[284420] = { zoneID = 864, artID = 889, x = 0.5497770309448242, y = 0.7612513899803162 }; 
	[132662] = { zoneID = 864, x = 0.465910941362381, y = 0.880130112171173 }; 
	[278694] = { zoneID = 862, artID = 887, x = 0.795598804950714, y = 0.157251968979836 }; 
	[284412] = { zoneID = 864, x = 0.6416643261909485, y = 0.2528935074806213 }; 
	[277885] = { zoneID = 863, artID = 888, x = 0.354499757289887, y = 0.549823462963104 }; 
	[284419] = { zoneID = 864, x = 0.50514429807663, y = 0.721499443054199 }; 
	[284414] = { zoneID = 864, x = 0.479725956916809, y = 0.867695510387421 }; 
	[287304] = { zoneID = 864, artID = 889, x = 0.497808903455734, y = 0.793953478336334 }; 
	[294317] = { zoneID = 864, x = 0.405703127384186, y = 0.857449233531952 }; 
	[279609] = { zoneID = 862, x = 0.517133891582489, y = 0.86875331401825 }; 
	[284455] = { zoneID = 862, x = 0.718238651752472, y = 0.167784661054611 }; 
	[281655] = { zoneID = 862, x = 0.5143, y = 0.2661 };
	[287326] = { zoneID = 864, artID = 889, x = 0.293794602155685, y = 0.874249041080475 }; 
	[287318] = { zoneID = 864, artID = 889, x = 0.471858739852905, y = 0.584622085094452 }; 
	[279352] = { zoneID = 864, x = 0.6672312021255493, y = 0.7316652536392212 }; 
	[284410] = { zoneID = 864, artID = 889, x = 0.6039547920227051, y = 0.3432454466819763 }; 
	[279378] = { zoneID = 863, x = 0.694839417934418, y = 0.303050100803375 }; 
	[284415] = { zoneID = 864, x = 0.4773680865764618, y = 0.463839590549469 }; 
	[279689] = { zoneID = 863, x = 0.620965301990509, y = 0.348738849163055 }; 
	[294316] = { zoneID = 864, x = 0.570560932159424, y = 0.112003736197948 }; 
	[287239] = { zoneID = 864, x = 0.48209804296494, y = 0.64719384908676 };
	[293962] = { zoneID = 895, x = 0.560275614261627, y = 0.331906259059906 }; 
	[293965] = { zoneID = 895, x = 0.726500689983368, y = 0.213304206728935 }; 
	[281397] = { zoneID = 895, x = 0.724904477596283, y = 0.581422507762909 }; 
	[293964] = { zoneID = 895, x = 0.617781519889832, y = 0.627453982830048 }; 
	[297825] = { zoneID = 896, x = 0.337101340293884, y = 0.300792425870895 }; 
	[297891] = { zoneID = 896, x = 0.632999837398529, y = 0.65853214263916 }; 
	[297893] = { zoneID = 896, x = 0.33682644367218, y = 0.717332065105438 }; 
	[297828] = { zoneID = 896, x = 0.257479280233383, y = 0.199462041258812 }; 
	[297892] = { zoneID = 896, x = 0.442192703485489, y = 0.276967883110046 }; 
	[289647] = { zoneID = 942, x = 0.669284641742706, y = 0.120616421103477 }; 
	[281494] = { zoneID = 942, x = 0.489747017621994, y = 0.841026067733765 }; 
	[284448] = { zoneID = 942, x = 0.599142849445343, y = 0.390672475099564 }; 
	[293349] = { zoneID = 942, x = 0.5821, y = 0.6368 }; 
	[294173] = { zoneID = 942, x = 0.36692026257515, y = 0.232342094182968 }; 
	[280619] = { zoneID = 942, x = 0.428546786308289, y = 0.472315937280655 }; 
	[282153] = { zoneID = 942, x = 0.67216569185257, y = 0.432080954313278 }; 
	[279042] = { zoneID = 942, x = 0.585993111133576, y = 0.83877170085907 }; 
	[293350] = { zoneID = 942, x = 0.444388657808304, y = 0.735307514667511 }; 
	[291254] = { zoneID = 942, artID = 967, x = 0.5974079370498657, y = 0.3895588517189026 }; 
	[291255] = { zoneID = 942, x = 0.736365377902985, y = 0.314059495925903 }; 
	[279379] = { zoneID = 863, x = 0.610132098197937, y = 0.210287019610405 }; 
	[277336] = { zoneID = 1165, artID = 1143, x = 0.442337185144424, y = 0.131876796483994 }; 
	[131453] = { zoneID = 895, x = 0.673954129219055, y = 0.516639292240143 }; 
	[291266] = { zoneID = 942, x = 0.3885087668895721, y = 0.4199527204036713 }; 
	[281176] = { zoneID = 862, x = 0.716771185398102, y = 0.412778198719025 }; 
	[273900] = { zoneID = 895, x = 0.770786345005035, y = 0.773464381694794 }; 
	[273902] = { zoneID = 895, x = 0.7768117189407349, y = 0.8504564762115479 }; 
	[273903] = { zoneID = 895, x = 0.73459392786026, y = 0.831866979598999 }; 
	[273905] = { zoneID = 895, artID = 920, x = 0.372227728366852, y = 0.283539295196533 }; 
	[273910] = { zoneID = 895, artID = 920, x = 0.4308087229728699, y = 0.3019811511039734 }; 
	[273917] = { zoneID = 895, x = 0.791729927062988, y = 0.505022525787354 }; 
	[275070] = { zoneID = 895, x = 0.5544219613075256, y = 0.1718996316194534 }; 
	[275071] = { zoneID = 895, x = 0.899773120880127, y = 0.782447695732117 }; 
	[275074] = { zoneID = 895, x = 0.670333981513977, y = 0.213616892695427 }; 
	[275076] = { zoneID = 895, artID = 920, x = 0.4853620529174805, y = 0.1829876750707626 }; 
	[273956] = { zoneID = 895, artID = 920, x = 0.610577464103699, y = 0.268900394439697 }; 
	[280751] = { zoneID = 895, artID = 920, x = 0.4097157120704651, y = 0.1414643377065659 }; 
	[273919] = { zoneID = 895, artID = 920, x = 0.6712417602539063, y = 0.5938888788223267 }; 
	[291228] = { zoneID = 896, artID = 921, x = 0.2668105661869049, y = 0.5160462260246277 }; 
	[291229] = { zoneID = 896, artID = 921, x = 0.2512378990650177, y = 0.6323861479759216 }; 
	[279750] = { zoneID = 895, x = 0.673626244068146, y = 0.516348123550415 }; 
	[291246] = { zoneID = 942, x = 0.6738020777702332, y = 0.4137649834156036 }; 
	[294174] = { zoneID = 942, x = 0.460047096014023, y = 0.306927144527435 }; 
	[273955] = { zoneID = 895, x = 0.5304228663444519, y = 0.3133111894130707 }; 
	[291244] = { zoneID = 942, artID = 967, x = 0.6927451491355896, y = 0.5793291330337524 }; 
	[302955] = { zoneID = 895, x = 0.836409330368042, y = 0.35724875330925 }; 
	[293881] = { zoneID = 895, x = 0.904966056346893, y = 0.755060434341431 }; 
	[293852] = { zoneID = 895, x = 0.549934208393097, y = 0.460786372423172 };
	[293884] = { zoneID = 895, x = 0.489785760641098, y = 0.375943332910538 }; 
	[293880] = { zoneID = 895, x = 0.292241752147675, y = 0.253416895866394 }; 
	[291204] = { zoneID = 896, artID = 921, x = 0.6155473589897156, y = 0.204302653670311 }; 
	[291213] = { zoneID = 896, x = 0.547276616096497, y = 0.444196552038193 }; 
	[291201] = { zoneID = 896, artID = 921, x = 0.6608323454856873, y = 0.2411868423223496 }; 
	[291217] = { zoneID = 896, artID = 921, x = 0.65118819475174, y = 0.518438220024109 }; 
	[291223] = { zoneID = 896, x = 0.679749667644501, y = 0.630029976367951 }; 
	[291224] = { zoneID = 896, x = 0.3017767071723938, y = 0.1821585595607758 }; 
	[291226] = { zoneID = 896, x = 0.232158660888672, y = 0.126123666763306 }; 
	[291211] = { zoneID = 896, artID = 921, x = 0.4625930488109589, y = 0.2688711285591126 }; 
	[297879] = { zoneID = 896, x = 0.556, y = 0.5181 }; 
	[297878] = { zoneID = 896, x = 0.18509602546692, y = 0.51338189840317 };
	[297881] = { zoneID = 896, x = 0.25455021858215, y = 0.24183428287506 };
	[291225] = { zoneID = 896, x = 0.2625250518321991, y = 0.2996868491172791 }; 
	[291227] = { zoneID = 896, artID = 921, x = 0.2509081363677979, y = 0.3593753576278687 }; 
	[291230] = { zoneID = 896, artID = 921, x = 0.3766935169696808, y = 0.5944631099700928 }; 
	[297880] = { zoneID = 896, x = 0.67761027812958, y = 0.7368004322052 };
	[291263] = { zoneID = 942, x = 0.4628048241138458, y = 0.727338969707489 }; 
	[291264] = { zoneID = 942, artID = 967, x = 0.2913675904273987, y = 0.6977316737174988 }; 
	[303039] = { zoneID = 942, x = 0.321534246206284, y = 0.662365257740021 }; 
	[291258] = { zoneID = 942, x = 0.4839732646942139, y = 0.657026469707489 }; 
	[303170] = { zoneID = 942, x = 0.328831404447556, y = 0.696503639221191 }; 
	[291265] = { zoneID = 942, artID = 967, x = 0.300043404102325, y = 0.514639973640442 }; 
	[284421] = { zoneID = 864, x = 0.5671544671058655, y = 0.5528174042701721 }; 
	[281646] = { zoneID = 942, x = 0.665571808815003, y = 0.711404800415039 };
	[294319] = { zoneID = 864, x = 0.264735639095306, y = 0.453562617301941 };
	[292673] = { zoneID = 1161, x = 0.71015405654907, y = 0.84429115056992 };
	[292674] = { zoneID = 1161, x = 0.67079365253448, y = 0.7967237830162 };
	[292675] = { zoneID = 1161, x = 0.61173903112411, y = 0.77888709306717 };
	[292676] = { zoneID = 1161, x = 0.63129240274429, y = 0.8186137676239 };
	[292677] = { zoneID = 1161, x = 0.55979037284851, y = 0.91297948360443 };
	[292686] = { zoneID = 1161, x = 0.5519585609436, y = 0.90129750967026 };
	[273407] = { zoneID = 882, artID = 907, x = 0.6220277547836304, y = 0.2635809183120728 }; 
	[273301] = { zoneID = 882, artID = 907, x = 0.4804967641830444, y = 0.6121742129325867 }; 
	[273412] = { zoneID = 882, artID = 907, x = 0.4053158760070801, y = 0.5537358522415161 }; 
	[273415] = { zoneID = 882, artID = 907, x = 0.494375705718994, y = 0.23897922039032 }; 
	[277637] = { zoneID = 882, x = 0.3233698010444641, y = 0.2129942178726196 }; 
	[237724] = { zoneID = 590, x = 0.421105861663818, y = 0.472295999526978 }; 
	[272770] = { zoneID = 830, x = 0.354208886623383, y = 0.563741266727448 }; 
	[220901] = { zoneID = 554, x = 0.496584266424179, y = 0.694025456905365 }; 
	[220902] = { zoneID = 554, x = 0.539355516433716, y = 0.472226858139038 }; 
	[252450] = { zoneID = 680, x = 0.297552525997162, y = 0.87988555431366 }; 
	[128662] = { zoneID = 864, x = 0.299600303173065, y = 0.51869809627533 }; 
	[128665] = { zoneID = 864, x = 0.288934528827667, y = 0.51412558555603 }; 
	[127025] = { zoneID = 864, x = 0.286262154579163, y = 0.884777784347534 }; 
	[296581] = { zoneID = 864, x = 0.294835567474365, y = 0.593443632125855 }; 
	[136466] = { zoneID = 864, x = 0.305164754390717, y = 0.878977179527283 }; 
	[136472] = { zoneID = 864, x = 0.303911149501801, y = 0.887622535228729 }; 
	[272622] = { zoneID = 864, x = 0.303978085517883, y = 0.887646377086639 }; 
	[277343] = { zoneID = 830, x = 0.75170624256134, y = 0.697440981864929 }; 
	[277344] = { zoneID = 830, x = 0.559185862541199, y = 0.742984175682068 }; 
	[128660] = { zoneID = 864, x = 0.299600303173065, y = 0.51869809627533 }; 
	[282647] = { zoneID = 864, x = 0.469758331775665, y = 0.465581923723221 }; 
	[287493] = { zoneID = 864, x = 0.307239174842835, y = 0.887985825538635 }; 
	[128661] = { zoneID = 864, x = 0.293765962123871, y = 0.538918495178223 }; 
	[136109] = { zoneID = 864, x = 0.304547965526581, y = 0.601355373859406 }; 
	[136144] = { zoneID = 864, x = 0.280950307846069, y = 0.641453504562378 };
	[298920] = { zoneID = 896, x = 0.244, y = 0.486 };
	[291257] = { zoneID = 942, artID = 967, x = 0.695321619510651, y = 0.680544853210449 }; 
	[291259] = { zoneID = 942, artID = 967, x = 0.4784861207008362, y = 0.5546790957450867 }; 
	[273918] = { zoneID = 895, x = 0.7610440850257874, y = 0.6732258200645447 }; 
	[291267] = { zoneID = 942, artID = 967, x = 0.608992040157318, y = 0.511746048927307 }; 
	[279325] = { zoneID = 863, artID = 888, x = 0.6122182011604309, y = 0.5762869119644165 }; 
	[287531] = { zoneID = 942, artID = 967, x = 0.6133604645729065, y = 0.6310023069381714 }; 
	[281381] = { zoneID = 863, x = 0.808919012546539, y = 0.46753516793251 }; 
	[281390] = { zoneID = 863, x = 0.685224831104279, y = 0.328186571598053 }; 
	[284469] = { zoneID = 895, x = 0.746005475521088, y = 0.397437125444412 }; 
	[282721] = { zoneID = 863, artID = 888, x = 0.6668678522109985, y = 0.5005109310150146 }; 
	[294311] = { zoneID = 942, x = 0.821177661418915, y = 0.44027104973793 }; 
	[279367] = { zoneID = 863, artID = 888, x = 0.4928281009197235, y = 0.3332444727420807 }; 
	[281388] = { zoneID = 863, x = 0.340138584375382, y = 0.751240253448486 }; 
	[291222] = { zoneID = 896, artID = 921, x = 0.6470158100128174, y = 0.61958247423172 }; 
	[237722] = { zoneID = 582, x = 0.370548129081726, y = 0.318072825670242 }; 
	[273414] = { zoneID = 882, x = 0.671606361865997, y = 0.537978172302246 }; 
	[281365] = { zoneID = 862, artID = 887, x = 0.627342820167542, y = 0.205701038241386 }; 
	[273443] = { zoneID = 882, x = 0.3766118288040161, y = 0.4221712350845337 }; 
	[281904] = { zoneID = 862, x = 0.421360433101654, y = 0.41658365726471 }; 
	[277342] = { zoneID = 882, x = 0.408472180366516, y = 0.697511315345764 }; 
	[277346] = { zoneID = 885, x = 0.574246644973755, y = 0.636650323867798 }; 
	[273519] = { zoneID = 885, x = 0.6213501691818237, y = 0.6937665939331055 }; 
	[273521] = { zoneID = 885, x = 0.516927540302277, y = 0.352976560592651 }; 
	[273524] = { zoneID = 885, x = 0.506362676620483, y = 0.57169634103775 }; 
	[273527] = { zoneID = 885, artID = 910, x = 0.6794126033782959, y = 0.4005668759346008 }; 
	[273535] = { zoneID = 885, x = 0.680888891220093, y = 0.507434844970703 }; 
	[273538] = { zoneID = 885, x = 0.6551705598831177, y = 0.4075368046760559 }; 
	[277384] = { zoneID = 903, x = 0.299846708774567, y = 0.740603685379028 }; 
	[236916] = { zoneID = 582, x = 0.370548129081726, y = 0.318072825670242 }; 
	[277208] = { zoneID = 885, x = 0.755987048149109, y = 0.526644349098206 }; 
	[244597] = { zoneID = 628, x = 0.636349499225617, y = 0.740448951721191 }; 
	[237191] = { zoneID = 590, x = 0.421105861663818, y = 0.472295999526978 }; 
	[290135] = { zoneID = 1165, x = 0.35664775967598, y = 0.185487285256386 }; 
	[320516] = { zoneID = 62, x = 0.423784613609314, y = 0.386017233133316 }; 
	[320517] = { zoneID = 62, x = 0.4559479355812073, y = 0.4843171536922455 }; 
	[320515] = { zoneID = 62, x = 0.5055818557739258, y = 0.2275784611701965 }; 
	[320514] = { zoneID = 62, artID = 1176, x = 0.6082080006599426, y = 0.2230420708656311 }; 
	[320518] = { zoneID = 62, x = 0.3792161345481873, y = 0.8412491083145142 }; 
	[252448] = { zoneID = 680, x = 0.419633239507675, y = 0.191859796643257 }; 
	[28441] = { zoneID = 903, x = 0.299846708774567, y = 0.740603685379028 }; 
	[254001] = { zoneID = 749, x = 0.410724103450775, y = 0.535785436630249 }; 
	[273523] = { zoneID = 885, artID = 910, x = 0.637017548084259, y = 0.2568875551223755 }; 
	[276224] = { zoneID = 882, x = 0.505763053894043, y = 0.383922278881073 }; 
	[273533] = { zoneID = 885, artID = 910, x = 0.596255898475647, y = 0.1399575471878052 }; 
	[273439] = { zoneID = 882, x = 0.253742933273315, y = 0.301466047763824 }; 
	[277207] = { zoneID = 885, x = 0.491382896900177, y = 0.59389990568161 }; 
	[276225] = { zoneID = 882, x = 0.611298263072968, y = 0.725621700286865 }; 
	[277340] = { zoneID = 882, x = 0.621334791183472, y = 0.224928438663483 }; 
	[273901] = { zoneID = 1169, x = 0.274347364902496, y = 0.667651534080505 }; 
	[273528] = { zoneID = 885, artID = 910, x = 0.7724431753158569, y = 0.5876553654670715 }; 
	[290129] = { zoneID = 62, x = 0.502631604671478, y = 0.426830559968948 }; 
	[326411] = { zoneID = 1355, artID = 1186, x = 0.3446361422538757, y = 0.4036139845848084 }; 
	[326399] = { zoneID = 1355, artID = 1186, x = 0.3790086507797241, y = 0.06442147493362427 }; 
	[326404] = { zoneID = 1355, artID = 1186, x = 0.7952965497970581, y = 0.2716021537780762 }; 
	[326416] = { zoneID = 1355, artID = 1186, x = 0.49577, y = 0.64488 }; 
	[326409] = { zoneID = 1355, artID = 1186, x = 0.39713, y = 0.49193 }; 
	[326419] = { zoneID = 1355, artID = 1186, x = 0.4474342465400696, y = 0.4891340136528015 }; 
	[326410] = { zoneID = 1355, artID = 1186, x = 0.50616055727005, y = 0.4995437860488892 }; 
	[326413] = { zoneID = 1355, artID = 1186, x = 0.3464608192443848, y = 0.4357816576957703 }; 
	[326405] = { zoneID = 1355, artID = 1186, x = 0.6431422233581543, y = 0.3335482478141785 }; 
	[326407] = { zoneID = 1355, artID = 1186, x = 0.5283011198043823, y = 0.4977533221244812 }; 
	[325664] = { zoneID = 1462, artID = 1276, x = 0.6643388271331787, y = 0.2226167321205139 }; 
	[325660] = { zoneID = 1462, artID = 1276, x = 0.3567829430103302, y = 0.3831669688224793 }; 
	[325665] = { zoneID = 1462, artID = 1276, x = 0.6732412576675415, y = 0.2287934273481369 }; 
	[326417] = { zoneID = 1355, artID = 1186, x = 0.433428168296814, y = 0.5818220376968384 }; 
	[326414] = { zoneID = 1355, artID = 1186, x = 0.4845185279846191, y = 0.8737642168998718 }; 
	[332220] = { zoneID = 1355, artID = 1186, x = 0.24852055311203, y = 0.3526488542556763 }; 
	[326412] = { zoneID = 1355, artID = 1186, x = 0.2594031095504761, y = 0.3240945935249329 }; 
	[326418] = { zoneID = 1355, artID = 1186, x = 0.3796876668930054, y = 0.6059074997901917 }; 
	[326394] = { zoneID = 1355, artID = 1186, x = 0.8528428077697754, y = 0.385873556137085 }; 
	[326395] = { zoneID = 1355, artID = 1186, x = 0.4395077228546143, y = 0.1691074967384338 }; 
	[326398] = { zoneID = 1355, artID = 1186, x = 0.3722167015075684, y = 0.1917858123779297 }; 
	[326401] = { zoneID = 1355, artID = 1186, x = 0.8035546541213989, y = 0.2981621026992798 }; 
	[326396] = { zoneID = 1355, artID = 1186, x = 0.642162561416626, y = 0.2858669757843018 }; 
	[326397] = { zoneID = 1355, artID = 1186, x = 0.5563167333602905, y = 0.1449252963066101 }; 
	[326400] = { zoneID = 1355, artID = 1186, x = 0.6140421628952026, y = 0.2285802960395813 }; 
	[326408] = { zoneID = 1355, artID = 1186, x = 0.5800838470458984, y = 0.3506006002426148 }; 
	[326403] = { zoneID = 1355, artID = 1186, x = 0.7326673269271851, y = 0.3580599427223206 }; 
	[326402] = { zoneID = 1355, artID = 1186, x = 0.747710645198822, y = 0.5319684743881226 }; 
	[326406] = { zoneID = 1355, artID = 1186, x = 0.5632744431495667, y = 0.3378702998161316 }; 
	[326415] = { zoneID = 1355, artID = 1186, x = 0.3871, y = 0.7441 };
	[329783] = { zoneID = 1355, artID = 1186, x = 0.8053988218307495, y = 0.3193854093551636 }; 
	[282668] = { zoneID = 864, artID = 889, x = 0.493608355522156, y = 0.844073057174683 }; 
	[325668] = { zoneID = 1462, artID = 1276, x = 0.2479983866214752, y = 0.6525334119796753 }; 
	[325659] = { zoneID = 1462, artID = 1276, x = 0.5211336612701416, y = 0.5327059030532837 }; 
	[325666] = { zoneID = 1462, artID = 1276, x = 0.6675953269004822, y = 0.7759378552436829 }; 
	[325661] = { zoneID = 1462, artID = 1276, x = 0.6723509430885315, y = 0.5626015663146973 }; 
	[325667] = { zoneID = 1462, artID = 1276, x = 0.7648739814758301, y = 0.6597946286201477 }; 
	[325662] = { zoneID = 1462, artID = 1276, x = 0.8118435144424438, y = 0.6148672699928284 }; 
	[311903] = { zoneID = 864, artID = 889, x = 0.416725099086762, y = 0.426605552434921 }; 
	[310709] = { zoneID = 37, x = 0.322314113378525, y = 0.634327173233032 }; 
	[232458] = { zoneID = 542, artID = 559, x = 0.608703076839447, y = 0.877829432487488 }; 
	[311902] = { zoneID = 864, artID = 889, x = 0.418345928192139, y = 0.424206167459488 }; 
	[253981] = { zoneID = 761, x = 0.672450125217438, y = 0.419978559017181 }; 
	[325663] = { zoneID = 1462, artID = 1276, x = 0.5665207505226135, y = 0.5738828778266907 }; 
}

private.EVENT_ZONE_IDS = {
	[125230] = { zoneID = 863, x = 0.81867903470993, y = 0.305899769067764 }; 
	[141124] = { zoneID = 863, artID = 888, x = 0.529609858989716, y = 0.72052788734436 }; 
	[282660] = { zoneID = 863, artID = 888, x = 0.380861282348633, y = 0.576815903186798 }; 
	[137180] = { zoneID = 895, x = 0.643052101135254, y = 0.193795710802078 }; 
	[127651] = { zoneID = 896, x = 0.731506824493408, y = 0.601005792617798 }; 
	[277897] = { zoneID = 896, x = 0.679904878139496, y = 0.668847680091858 }; 
	[277389] = { zoneID = 896, x = 0.520686864852905, y = 0.46967226266861 }; 
	[129904] = { zoneID = 896, x = 0.522991597652435, y = 0.468662261962891 }; 
	[277896] = { zoneID = 896, x = 0.679904878139496, y = 0.668847680091858 }; 
	[277329] = { zoneID = 896, x = 0.419520884752274, y = 0.364805787801743 }; 
	[220903] = { zoneID = 554, x = 0.58499938249588, y = 0.601230502128601 }; 
	[71944] = { zoneID = 554, x = 0.37471279501915, y = 0.774150490760803 }; 
	[137183] = { zoneID = 895, x = 0.640371322631836, y = 0.196355804800987 }; 
	[90232] = { zoneID = 630, x = 0.59846168756485, y = 0.120600633323193 }; 
	[241127] = { zoneID = 641, x = 0.555579364299774, y = 0.776155769824982 }; 
	[241128] = { zoneID = 641, x = 0.555579364299774, y = 0.776156783103943 }; 
	[93677] = { zoneID = 641, x = 0.527373492717743, y = 0.874972701072693 }; 
	[84037] = { zoneID = 535, x = 0.379681557416916, y = 0.208015531301498 }; 
	[112612] = { zoneID = 641, x = 0.519775390625, y = 0.693435430526733 }; 
	[97653] = { zoneID = 650, x = 0.537094652652741, y = 0.512776494026184 }; 
	[241528] = { zoneID = 634, x = 0.580043494701386, y = 0.450865179300308 }; 
	[112812] = { zoneID = 641, x = 0.479942560195923, y = 0.375454604625702 }; 
	[149653] = { zoneID = 1355, artID = 1186, x = 0.5472074747085571, y = 0.4172743558883667 }; 
	[97584] = { zoneID = 650, x = 0.545431911945343, y = 0.40630105137825 }; 
	[229366] = { zoneID = 525, x = 0.571704626083374, y = 0.521681666374207 }; 
	[75235] = { zoneID = 525, x = 0.617080867290497, y = 0.425273537635803 }; 
	[153898] = { zoneID = 1355, artID = 1186, x = 0.6245176792144775, y = 0.2964340448379517 }; 
	[150191] = { zoneID = 1355, artID = 1186, x = 0.3690873980522156, y = 0.112368106842041 }; 
	[150468] = { zoneID = 1355, artID = 1186, x = 0.4809307456016541, y = 0.2426183819770813 }; 
}
