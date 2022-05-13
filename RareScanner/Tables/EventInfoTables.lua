-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

private.EVENT_INFO = {
	[125230] = { zoneID = 863, x = 0.81867903470993, y = 0.305899769067764 }; 
	[141124] = { zoneID = 863, artID = { 888 }, x = 0.529609858989716, y = 0.72052788734436 }; 
	[282660] = { zoneID = 863, artID = { 888 }, x = 0.380861282348633, y = 0.576815903186798 }; 
	[137180] = { zoneID = 895, x = 0.643052101135254, y = 0.193795710802078 }; 
	[127651] = { zoneID = 896, x = 0.731506824493408, y = 0.601005792617798 }; 
	[277897] = { zoneID = 896, x = 0.679904878139496, y = 0.668847680091858 }; 
	[277389] = { zoneID = 896, x = 0.520686864852905, y = 0.46967226266861 }; 
	[129904] = { zoneID = 896, x = 0.522991597652435, y = 0.468662261962891 }; 
	[277896] = { zoneID = 896, x = 0.679904878139496, y = 0.668847680091858 }; 
	[277329] = { zoneID = 896, x = 0.419520884752274, y = 0.364805787801743 }; 
	[220903] = { zoneID = 554, x = 0.58499938249588, y = 0.601230502128601, weeklyReset = true }; 
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
	[149653] = { zoneID = 1355, artID = { 1186 }, x = 0.547032356262207, y = 0.4171630144119263 }; 
	[97584] = { zoneID = 650, x = 0.545431911945343, y = 0.40630105137825 }; 
	[153898] = { zoneID = 1355, artID = { 1186 }, x = 0.6245176792144775, y = 0.2964340448379517 }; 
	[150191] = { zoneID = 1355, artID = { 1186 }, x = 0.3690873980522156, y = 0.112368106842041 }; 
	[150468] = { zoneID = 1355, artID = { 1186 }, x = 0.4809307456016541, y = 0.2426183819770813 }; 
	[157341] = { zoneID = 1530, artID = { 1342 }, x = 0.2471784949302673, y = 0.4793208837509155, questID = { 57323 } }; 
	[157106] = { zoneID = 1530, artID = { 1342 }, x = 0.1704696267843247, y = 0.4571837484836578, zoneQuestId = { 57008 }, questID = { 57256 } }; 
	[157144] = { zoneID = 1530, artID = { 1342 }, x = 0.1918946206569672, y = 0.7202214598655701, zoneQuestId = { 57008 }, questID = { 57272 } }; 
	[161048] = { zoneID = 1530, artID = { 1342 }, x = 0.3336693346500397, y = 0.7117160558700562, zoneQuestId = { 57008 }, questID = { 58334 } }; 
	[158521] = { zoneID = 1530, artID = { 1342 }, x = 0.5012921094894409, y = 0.6347827911376953, questID = { 57299 } }; 
	[161089] = { zoneID = 1530, artID = { 1342 }, x = 0.2666595876216888, y = 0.1699821501970291, zoneQuestId = { 57008 }, questID = { 58370 } }; 
	[339488] = { zoneID = 1527, artID = { 1343 }, x = 0.5540052652359009, y = 0.213327944278717, zoneQuestId = { 57157 }, questID = { 58257 } }; 
	[158728] = { zoneID = 1527, artID = { 1343 }, x = 0.5704429149627686, y = 0.4952114820480347, zoneQuestId = { 57157 }, questID = { 57592 } }; 
	[339756] = { zoneID = 1530, artID = { 1342 }, x = 0.4638642966747284, y = 0.5717616677284241, questID = { 58438 } }; 
	[154118] = { zoneID = 1530, artID = { 1342 }, x = 0.6042100787162781, y = 0.6781296730041504, zoneQuestId = { 56064 }, questID = { 56099 } }; 
	[157525] = { zoneID = 1530, artID = { 1342 }, x = 0.6929396390914917, y = 0.2178856432437897, zoneQuestId = { 56064 }, questID = { 57375 } }; 
	[150904] = { zoneID = 23, artID = { 24 }, x = 0.7425389885902405, y = 0.5294924378395081, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[164331] = { zoneID = 1530, artID = { 1342 }, x = 0.7423943877220154, y = 0.3997679054737091, zoneQuestId = { 56064 }, questID = { 56076 } }; 
	[152439] = { zoneID = 1527, artID = { 1343 }, x = 0.6990320086479187, y = 0.599304735660553, zoneQuestId = { 55350 }, questID = { 55360 } }; 
	[150905] = { zoneID = 83, artID = { 88 }, x = 0.5961592197418213, y = 0.502562940120697, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[164358] = { zoneID = 1527, artID = { 1343 }, x = 0.620536744594574, y = 0.207141101360321, zoneQuestId = { 57375 }, questID = { 55356 } }; 
	[150945] = { zoneID = 111, artID = { 116 }, x = 0.6775355339050293, y = 0.2769795358181, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[145826] = { zoneID = 85, artID = { 90 }, x = 0.6013631820678711, y = 0.5054622292518616, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[161181] = { zoneID = 1530, artID = { 1342 }, x = 0.7643964886665344, y = 0.5162886381149292, zoneQuestId = { 56064 }, questID = { 57379 } }; 
	[156956] = { zoneID = 1527, artID = { 1343 }, x = 0.8025810718536377, y = 0.6606475710868835, zoneQuestId = { 55350 }, questID = { 57234 } }; 
	[150946] = { zoneID = 116, artID = { 121 }, x = 0.4980393648147583, y = 0.5155892372131348, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[152227] = { zoneID = 1527, artID = { 1343 }, x = 0.6449587345123291, y = 0.2982923090457916, zoneQuestId = { 55350 }, questID = { 55359 } }; 
	[150950] = { zoneID = 535, artID = { 552 }, x = 0.8426051139831543, y = 0.3146704137325287, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[327229] = { zoneID = 1530, artID = { 1342 }, x = 0.4936759769916534, y = 0.6668639779090881, questID = { 56074 } }; 
	[152628] = { zoneID = 1527, artID = { 1343 }, x = 0.841895341873169, y = 0.5555481910705566, zoneQuestId = { 55350 }, questID = { 55670 } }; 
	[156849] = { zoneID = 1527, artID = { 1343 }, x = 0.7135091423988342, y = 0.6852005124092102, zoneQuestId = { 55350 }, questID = { 57217 } }; 
	[156472] = { zoneID = 1530, artID = { 1342 }, x = 0.4358922243118286, y = 0.4147782921791077, zoneQuestId = { 56064 }, questID = { 57146 } }; 
	[156857] = { zoneID = 1527, artID = { 1343 }, x = 0.8252951502799988, y = 0.4798605442047119, zoneQuestId = { 55350 }, questID = { 57218 } }; 
	[156865] = { zoneID = 1527, artID = { 1343 }, x = 0.6551008820533752, y = 0.378152072429657, zoneQuestId = { 55350 }, questID = { 57219 } }; 
	[156993] = { zoneID = 1527, artID = { 1343 }, x = 0.6651955842971802, y = 0.503006100654602, zoneQuestId = { 55350 }, questID = { 57235 } }; 
	[156869] = { zoneID = 1527, artID = { 1343 }, x = 0.7820659279823303, y = 0.5754558444023132, zoneQuestId = { 55350 }, questID = { 57223 } }; 
	[327553] = { zoneID = 1530, artID = { 1342 }, x = 0.7925209403038025, y = 0.3314825296401978, zoneQuestId = { 56064 }, questID = { 56177 } }; 
	[154187] = { zoneID = 1530, artID = { 1342 }, x = 0.6057466864585876, y = 0.4328959286212921, zoneQuestId = { 56064 }, questID = { 56163 } }; 
	[339856] = { zoneID = 1530, artID = { 1342 }, x = 0.4132890403270721, y = 0.4540150761604309, zoneQuestId = { 56064 }, questID = { 58439 } }; 
	[150948] = { zoneID = 634, artID = { 657 }, x = 0.6027488708496094, y = 0.5253653526306152, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[339870] = { zoneID = 1530, artID = { 1342 }, x = 0.813557505607605, y = 0.49526047706604, zoneQuestId = { 56064 }, questID = { 58442 } }; 
	[146961] = { zoneID = 376, artID = { 388 }, x = 0.6190728545188904, y = 0.5875246524810791, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[156648] = { zoneID = 1527, artID = { 1343 }, x = 0.6137528419494629, y = 0.4710197746753693, zoneQuestId = { 55350 }, questID = { 55354 } }; 
	[154328] = { zoneID = 1530, artID = { 1342 }, x = 0.7953048944473267, y = 0.5431650876998901, zoneQuestId = { 56064 }, questID = { 56180 } }; 
	[152398] = { zoneID = 1527, artID = { 1343 }, x = 0.8349800705909729, y = 0.618715226650238, zoneQuestId = { 55350 }, questID = { 55357 } }; 
	[164359] = { zoneID = 1527, artID = { 1343 }, x = 0.83515465259552, y = 0.6186872124671936, zoneQuestId = { 55350 } }; 
	[154095] = { zoneID = 1530, artID = { 1342 }, x = 0.4233199954032898, y = 0.6703577637672424, questID = { 56090 } }; 
	[154104] = { zoneID = 1530, artID = { 1342 }, x = 0.4005548059940338, y = 0.6367207765579224 }; 
	[163120] = { zoneID = 1527, artID = { 1343 }, x = 0.6446269154548645, y = 0.2983224093914032, zoneQuestId = { 55350 }, questID = { 57215 } }; 
	[163132] = { zoneID = 1527, artID = { 1343 }, x = 0.7608276009559631, y = 0.4796346127986908, zoneQuestId = { 55350 }, questID = { 57243 } }; 
	[156614] = { zoneID = 1527, artID = { 1343 }, x = 0.6444364190101624, y = 0.2270469963550568, zoneQuestId = { 55350 }, questID = { 55355 } }; 
	[327554] = { zoneID = 1530, artID = { 1342 }, x = 0.5668133497238159, y = 0.593210756778717, zoneQuestId = { 56064 }, questID = { 56178 } }; 
	[164361] = { zoneID = 1527, artID = { 1343 }, x = 0.7159016728401184, y = 0.4586372673511505, zoneQuestId = { 55350 }, questID = { 55358 } }; 
	[163356] = { zoneID = 1527, artID = { 1343 }, x = 0.3160574436187744, y = 0.4381363987922669, zoneQuestId = { 56308 }, questID = { 58660 } }; 
	[163357] = { zoneID = 1527, artID = { 1343 }, x = 0.451382577419281, y = 0.4306272268295288, zoneQuestId = { 56308 }, questID = { 58661 } }; 
	[163358] = { zoneID = 1527, artID = { 1343 }, x = 0.3713153004646301, y = 0.6708606481552124, zoneQuestId = { 56308 }, questID = { 58662 } }; 
	[163359] = { zoneID = 1527, artID = { 1343 }, x = 0.314061164855957, y = 0.555548906326294, zoneQuestId = { 56308 }, questID = { 58667 } }; 
	[163360] = { zoneID = 1527, artID = { 1343 }, x = 0.2073018252849579, y = 0.5906980633735657, zoneQuestId = { 56308 }, questID = { 58676 } }; 
	[163361] = { zoneID = 1527, artID = { 1343 }, x = 0.344004213809967, y = 0.2929791212081909, zoneQuestId = { 56308 }, questID = { 58679 } }; 
	[163362] = { zoneID = 1527, artID = { 1343 }, x = 0.2242819964885712, y = 0.6412353515625, zoneQuestId = { 56308 }, questID = { 58952 } }; 
	[163204] = { zoneID = 1527, artID = { 1343 }, x = 0.2776930332183838, y = 0.5705471038818359, zoneQuestId = { 56308 }, questID = { 58974 } }; 
	[163223] = { zoneID = 1527, artID = { 1343 }, x = 0.4685384333133698, y = 0.580745279788971, zoneQuestId = { 56308 }, questID = { 58981 } }; 
	[163264] = { zoneID = 1527, artID = { 1343 }, x = 0.2832901775836945, y = 0.6559913158416748, zoneQuestId = { 56308 }, questID = { 58990 } }; 
	[163337] = { zoneID = 1527, artID = { 1343 }, x = 0.3653130233287811, y = 0.2066219300031662, zoneQuestId = { 56308 }, questID = { 59003 } }; 
	[163198] = { zoneID = 1527, artID = { 1343 }, x = 0.3707422912120819, y = 0.4778100848197937, zoneQuestId = { 56308 }, questID = { 58961 } }; 
	[158467] = { zoneID = 1530, artID = { 1342 }, x = 0.2252452373504639, y = 0.09943251311779022, questID = { 57023 } }; 
	[158725] = { zoneID = 1527, artID = { 1343 }, x = 0.519591212272644, y = 0.5071959495544434, zoneQuestId = { 57157 }, questID = { 57543 } }; 
	[158470] = { zoneID = 1530, artID = { 1342 }, x = 0.2566867470741272, y = 0.1744803041219711, questID = { 57339 } }; 
	[158726] = { zoneID = 1527, artID = { 1343 }, x = 0.5900968313217163, y = 0.4664180874824524, questID = { 57580 } }; 
	[158736] = { zoneID = 1527, artID = { 1343 }, x = 0.4849959015846252, y = 0.8485234379768372, zoneQuestId = { 57157 }, questID = { 57522 } }; 
	[161053] = { zoneID = 1530, artID = { 1342 }, x = 0.2194723635911942, y = 0.2370020598173142 }; 
	[161055] = { zoneID = 1530, artID = { 1342 }, x = 0.2194723635911942, y = 0.2370020598173142 }; 
	[158754] = { zoneID = 1527, artID = { 1343 }, x = 0.5976463556289673, y = 0.7240833640098572, zoneQuestId = { 57157 }, questID = { 57429 } }; 
	[161070] = { zoneID = 1530, artID = { 1342 }, x = 0.2241828441619873, y = 0.3649220168590546, questID = { 58367 } }; 
	[339494] = { zoneID = 1527, artID = { 1343 }, x = 0.624107837677002, y = 0.7932321429252625, zoneQuestId = { 57157 }, questID = { 58258 } }; 
	[156623] = { zoneID = 1530, artID = { 1342 }, x = 0.2041187584400177, y = 0.1251626163721085, questID = { 57171 } }; 
	[161095] = { zoneID = 1530, artID = { 1342 }, x = 0.2194723635911942, y = 0.2370020598173142 }; 
	[158472] = { zoneID = 1530, artID = { 1342 }, x = 0.3133207857608795, y = 0.2892553806304932, questID = { 57087 } }; 
	[157794] = { zoneID = 1527, artID = { 1343 }, x = 0.4751136898994446, y = 0.4491817057132721, questID = { 57456 } }; 
	[339484] = { zoneID = 1527, artID = { 1343 }, x = 0.4679155051708221, y = 0.3424578905105591, zoneQuestId = { 57157 }, questID = { 58256 } }; 
	[158727] = { zoneID = 1527, artID = { 1343 }, x = 0.6644486784934998, y = 0.6803215146064758, zoneQuestId = { 57157 }, questID = { 57582 } }; 
	[158738] = { zoneID = 1527, artID = { 1343 }, x = 0.5368455052375793, y = 0.7569568157196045, questID = { 57585 } }; 
	[333213] = { zoneID = 1530, artID = { 1342 }, x = 0.1987849771976471, y = 0.07504889369010925, questID = { 57049 } }; 
	[163303] = { zoneID = 1527, artID = { 1343 }, x = 0.5763975381851196, y = 0.2365084886550903, zoneQuestId = { 57157 }, questID = { 57588 } }; 
	[163306] = { zoneID = 1527, artID = { 1343 }, x = 0.5996774435043335, y = 0.8016309142112732, zoneQuestId = { 57157 }, questID = { 57590 } }; 
	[158721] = { zoneID = 1527, artID = { 1343 }, x = 0.6019589900970459, y = 0.3789906799793243, questID = { 57449 } }; 
	[160818] = { zoneID = 1527, artID = { 1343 }, x = 0.6202905774116516, y = 0.7070708274841309, zoneQuestId = { 57157 }, questID = { 58271 } }; 
	[156549] = { zoneID = 1530, artID = { 1342 }, x = 0.1453410536050797, y = 0.2306835502386093, zoneQuestId = { 57008 }, questID = { 57158 } }; 
	[160915] = { zoneID = 1527, artID = { 1343 }, x = 0.5055815577507019, y = 0.8232239484786987, zoneQuestId = { 57157 }, questID = { 58275 } }; 
	[157934] = { zoneID = 1530, artID = { 1342 }, x = 0.1675191521644592, y = 0.4433813691139221, questID = { 57484 } }; 
	[158033] = { zoneID = 1530, artID = { 1342 }, x = 0.2566305100917816, y = 0.3649516105651856, questID = { 57517 } }; 
	[158036] = { zoneID = 1530, artID = { 1342 }, x = 0.2700923681259155, y = 0.1716282665729523, questID = { 57519 } }; 
	[164307] = { zoneID = 1530, artID = { 1342 }, x = 0.06478842347860336, y = 0.4227440059185028, questID = { 57558, 57089 } }; 
	[157581] = { zoneID = 1530, artID = { 1342 }, x = 0.2663237154483795, y = 0.4637896716594696, questID = { 57404 } }; 
	[157601] = { zoneID = 1530, artID = { 1342 }, x = 0.2922923564910889, y = 0.6090689301490784, questID = { 57445 } }; 
	[158737] = { zoneID = 1527, artID = { 1343 }, x = 0.6589252352714539, y = 0.7287113070487976, zoneQuestId = { 57157 }, questID = { 57541 } }; 
	[158016] = { zoneID = 1530, artID = { 1342 }, x = 0.109915591776371, y = 0.4847046136856079, zoneQuestId = { 57008 }, questID = { 57508 } }; 
	[158037] = { zoneID = 1530, artID = { 1342 }, x = 0.08826902508735657, y = 0.2679904997348785, zoneQuestId = { 57008 }, questID = { 57521 } }; 
	[156289] = { zoneID = 1530, artID = { 1342 }, x = 0.1098682433366776, y = 0.6446087956428528, zoneQuestId = { 57008 }, questID = { 57085 } }; 
	[163308] = { zoneID = 1527, artID = { 1343 }, x = 0.5987523198127747, y = 0.539728045463562, questID = { 57591 } }; 
	[163301] = { zoneID = 1527, artID = { 1343 }, x = 0.5398914813995361, y = 0.3202493786811829, zoneQuestId = { 57157 }, questID = { 57587 } }; 
	[157718] = { zoneID = 1530, artID = { 1342 }, x = 0.1427250355482101, y = 0.331129252910614, questID = { 57453 } }; 
	[157874] = { zoneID = 1530, artID = { 1342 }, x = 0.1133598536252976, y = 0.4097681641578674, questID = { 57476 } }; 
	[158069] = { zoneID = 1530, artID = { 1342 }, x = 0.1853993088006973, y = 0.6576223969459534, zoneQuestId = { 57008 }, questID = { 57540 } }; 
	[153241] = { zoneID = 1530, artID = { 1342 }, x = 0.1924487501382828, y = 0.7240005135536194, zoneQuestId = { 57008 }, questID = { 57384 } }; 
	[339382] = { zoneID = 1527, artID = { 1343 }, x = 0.6014058589935303, y = 0.4557120501995087, zoneQuestId = { 57157 }, questID = { 58216 } }; 
	[158114] = { zoneID = 1530, artID = { 1342 }, x = 0.3181815147399902, y = 0.6187859773635864, questID = { 57542 } }; 
	[163300] = { zoneID = 1527, artID = { 1343 }, x = 0.4780512750148773, y = 0.3190105855464935, zoneQuestId = { 57157 }, questID = { 57586 } }; 
	[160928] = { zoneID = 1527, artID = { 1343 }, x = 0.4940674901008606, y = 0.3935791552066803, zoneQuestId = { 57157 }, questID = { 58276 } }; 
	[164301] = { zoneID = 1530, artID = { 1342 }, x = 0.06480100005865097, y = 0.7068420648574829, zoneQuestId = { 57008 } }; 
	[163304] = { zoneID = 1527, artID = { 1343 }, x = 0.6397323608398438, y = 0.6591629981994629, zoneQuestId = { 57157 }, questID = { 57589 } }; 
	[158718] = { zoneID = 1527, artID = { 1343 }, x = 0.5057405829429626, y = 0.8829352855682373, zoneQuestId = { 57157 }, questID = { 57359 } }; 
	[158720] = { zoneID = 1527, artID = { 1343 }, x = 0.5520068407058716, y = 0.793234646320343, zoneQuestId = { 57157 }, questID = { 57621 } }; 
	[170899] = { zoneID = 1533, artID = { 1321 }, x = 0.5362, y = 0.8822,  questID = { 60933 } }; 
	[356756] = { zoneID = 1533, artID = { 1321 }, x = 0.4163994, y = 0.54530585, questID = { 60314 }, worldmap = true }; --Horn of Courage
	[180293] = { zoneID = 1543, artID = { 1693 }, x = 0.6276826858520508, y = 0.6724420189857483, questID = { 64258 }, worldmap = true }; --Assault Supply Carriage
	[180181] = { zoneID = 1961, artID = { 1648 }, x = 0.5818808674812317, y = 0.1763358116149902, questID = { 64258 }, worldmap = true }; --Assault Supply Carriage
	[177525] = { zoneID = 1543, artID = { 1693 }, x = 0.2799704074859619, y = 0.4773745238780975, resetTimer = 7200, worldmap = true }; --Tormentors event
	[150942] = { zoneID = 84, artID = { 89 }, x = 0.666, y = 0.376, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[71876] = { zoneID = 554, artID = { 571 }, x = 4207, y = 3230 }; --Zarhym Altogether
}
