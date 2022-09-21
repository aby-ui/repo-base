-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

private.EVENT_INFO = {
	[150904] = { zoneID = 23, artID = { 24 }, x = 7425, y = 5294, overlay = { "7425-5294" }, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[150905] = { zoneID = 83, artID = { 88 }, x = 5961, y = 5025, overlay = { "5961-5025" }, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[150942] = { zoneID = 84, artID = { 89 }, x = 6660, y = 3760, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[145826] = { zoneID = 85, artID = { 90 }, x = 6013, y = 5054, overlay = { "6013-5054" }, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[150945] = { zoneID = 111, artID = { 116 }, x = 6775, y = 2769, overlay = { "6775-2769" }, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[150946] = { zoneID = 116, artID = { 121 }, x = 4980, y = 5155, overlay = { "4980-5155" }, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[146961] = { zoneID = 376, artID = { 388 }, x = 6190, y = 5875, overlay = { "6190-5875" }, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[150950] = { zoneID = 535, artID = { 552 }, x = 8426, y = 3146, overlay = { "8426-3146" }, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[220903] = { zoneID = 554, x = 5849, y = 6012, overlay = { "5849-6012" }, weeklyReset = true }; --Estatua de la Grulla reluciente
	[71876] = { zoneID = 554, artID = { 571 }, x = 4501, y = 3606, overlay = { "4501-3606" } }; --Zarhym Altogether
	[90232] = { zoneID = 630, x = 5984, y = 1206 }; --null
	[150948] = { zoneID = 634, artID = { 657 }, x = 6027, y = 5253, overlay = { "6027-5253" }, resetTimer = 31536000, worldmap = true }; --Free T-Shirt
	[241528] = { zoneID = 634, x = 5800, y = 4508, overlay = { "5800-4508" } }; --Asaltantes Boca Infernal
	[112612] = { zoneID = 641, x = 5197, y = 6934, overlay = { "5197-6934" } }; --null
	[112812] = { zoneID = 641, x = 4799, y = 3754, overlay = { "4799-3754" } }; --null
	[241127] = { zoneID = 641, x = 5555, y = 7761, overlay = { "5555-7761" } }; --null
	[241128] = { zoneID = 641, x = 5555, y = 7761 }; --null
	[93677] = { zoneID = 641, x = 5273, y = 8749 }; --null
	[97584] = { zoneID = 650, x = 5454, y = 4063, overlay = { "5454-4063" } }; --null
	[97653] = { zoneID = 650, x = 5370, y = 5127, overlay = { "5370-5127" } }; --null
	[125230] = { zoneID = 863, x = 8186, y = 3058, overlay = { "8186-3058" } }; --El arcón maldito
	[141124] = { zoneID = 863, artID = { 888 }, x = 5296, y = 7205, overlay = { "5296-7205" } }; --Aiji el Detestable
	[282660] = { zoneID = 863, artID = { 888 }, x = 3808, y = 5768, overlay = { "3808-5768" } }; --Urna de Agussu
	[137180] = { zoneID = 895, x = 6430, y = 1937, overlay = { "6430-1937" } }; --Mercaderes en peligro
	[137183] = { zoneID = 895, x = 6403, y = 1963, overlay = { "6403-1963" } }; --null
	[127651] = { zoneID = 896, x = 7315, y = 6010, overlay = { "7315-6010" } }; --null
	[129904] = { zoneID = 896, x = 5229, y = 4686, overlay = { "5229-4686" } }; --null
	[277329] = { zoneID = 896, x = 4195, y = 3648, overlay = { "4195-3648" } }; --Sarcófago antiguo
	[277389] = { zoneID = 896, x = 5206, y = 4696, overlay = { "5206-4696" } }; --Calavera de ritual bestial
	[277896] = { zoneID = 896, x = 6799, y = 6688, overlay = { "6799-6688" } }; --Alijo hirviente
	[277897] = { zoneID = 896, x = 6799, y = 6688, overlay = { "6799-6688" } }; --Alijo hirviente
	[155069] = { zoneID = 942, artID = { 967 }, x = 7232, y = 5224, overlay = { "7232-5224" } }; --Cosechadora mielabdomen
	[149653] = { zoneID = 1355, artID = { 1186 }, x = 5470, y = 4171, overlay = { "5470-4171" } }; --null
	[150191] = { zoneID = 1355, artID = { 1186 }, x = 3690, y = 1123, overlay = { "3690-1123" } }; --null
	[150468] = { zoneID = 1355, artID = { 1186 }, x = 4809, y = 2426, overlay = { "4809-2426" } }; --null
	[153898] = { zoneID = 1355, artID = { 1186 }, x = 6245, y = 2964, overlay = { "6245-2964" } }; --null
	[154148] = { zoneID = 1355, artID = { 1186 }, x = 6592, y = 2231, overlay = { "6592-2231" } }; --null
	[152227] = { zoneID = 1527, artID = { 1343 }, x = 6449, y = 2982, overlay = { "6449-2982" }, zoneQuestId = { 55350 }, questID = { 55359 } }; --Ritual de ascensión
	[152398] = { zoneID = 1527, artID = { 1343 }, x = 8349, y = 6187, overlay = { "8349-6187" }, zoneQuestId = { 55350 }, questID = { 55357 } }; --Baliza del Rey del Sol
	[152439] = { zoneID = 1527, artID = { 1343 }, x = 6993, y = 5983, overlay = { "6993-5983" }, zoneQuestId = { 55350 }, questID = { 55360 } }; --La tumba abierta
	[152628] = { zoneID = 1527, artID = { 1343 }, x = 8418, y = 5555, overlay = { "8418-5555" }, zoneQuestId = { 55350 }, questID = { 55670 } }; --Flota de asalto amathet
	[156614] = { zoneID = 1527, artID = { 1343 }, x = 6444, y = 2270, overlay = { "6444-2270" }, zoneQuestId = { 55350 }, questID = { 55355 } }; --Campo de entrenamiento de hoja de luz
	[156648] = { zoneID = 1527, artID = { 1343 }, x = 6137, y = 4710, overlay = { "6137-4710" }, zoneQuestId = { 55350 }, questID = { 55354 } }; --El frente de Vir'naal
	[156849] = { zoneID = 1527, artID = { 1343 }, x = 7172, y = 6952, overlay = { "7172-6952" }, zoneQuestId = { 55350 }, questID = { 57217 } }; --Centinela desenterrado
	[156857] = { zoneID = 1527, artID = { 1343 }, x = 8252, y = 4798, overlay = { "8252-4798" }, zoneQuestId = { 55350 }, questID = { 57218 } }; --Centinela desenterrado
	[156865] = { zoneID = 1527, artID = { 1343 }, x = 6551, y = 3781, overlay = { "6551-3781" }, zoneQuestId = { 55350 }, questID = { 57219 } }; --Centinela desenterrado
	[156869] = { zoneID = 1527, artID = { 1343 }, x = 7820, y = 5754, overlay = { "7820-5754" }, zoneQuestId = { 55350 }, questID = { 57223 } }; --Centinela desenterrado
	[156956] = { zoneID = 1527, artID = { 1343 }, x = 8025, y = 6606, overlay = { "8025-6606" }, zoneQuestId = { 55350 }, questID = { 57234 } }; --Recolector solar
	[156993] = { zoneID = 1527, artID = { 1343 }, x = 6651, y = 5030, overlay = { "6651-5030" }, zoneQuestId = { 55350 }, questID = { 57235 } }; --Recolector solar
	[157794] = { zoneID = 1527, artID = { 1343 }, x = 4751, y = 4491, overlay = { "4751-4491" }, questID = { 57456 } }; --Bebedor de espíritus
	[158718] = { zoneID = 1527, artID = { 1343 }, x = 5057, y = 8829, overlay = { "5057-8829" }, zoneQuestId = { 57157 }, questID = { 57359 } }; --Portal de invocación
	[158719] = { zoneID = 1527, artID = { 1343 }, x = 5000, y = 7869, overlay = { "5000-7869" } }; --Portal de invocación
	[158720] = { zoneID = 1527, artID = { 1343 }, x = 5520, y = 7932, overlay = { "5520-7932" }, zoneQuestId = { 57157 }, questID = { 57621 } }; --Portal de invocación
	[158721] = { zoneID = 1527, artID = { 1343 }, x = 6019, y = 3789, overlay = { "6019-3789" }, questID = { 57449 } }; --Ejecutor de N'Zoth
	[158725] = { zoneID = 1527, artID = { 1343 }, x = 5195, y = 5071, overlay = { "5195-5071" }, zoneQuestId = { 57157 }, questID = { 57543 } }; --Ejecutor de N'Zoth
	[158726] = { zoneID = 1527, artID = { 1343 }, x = 5900, y = 4664, overlay = { "5900-4664" }, questID = { 57580 } }; --Ejecutor de N'Zoth
	[158727] = { zoneID = 1527, artID = { 1343 }, x = 6644, y = 6803, overlay = { "6644-6803" }, zoneQuestId = { 57157 }, questID = { 57582 } }; --Ejecutor de N'Zoth
	[158728] = { zoneID = 1527, artID = { 1343 }, x = 5704, y = 4952, overlay = { "5704-4952" }, zoneQuestId = { 57157 }, questID = { 57592 } }; --Ejecutor de N'Zoth
	[158736] = { zoneID = 1527, artID = { 1343 }, x = 4849, y = 8485, overlay = { "4849-8485" }, zoneQuestId = { 57157 }, questID = { 57522 } }; --Llamada del Vacío
	[158737] = { zoneID = 1527, artID = { 1343 }, x = 6589, y = 7287, overlay = { "6589-7287" }, zoneQuestId = { 57157 }, questID = { 57541 } }; --Llamada del Vacío
	[158738] = { zoneID = 1527, artID = { 1343 }, x = 5368, y = 7569, overlay = { "5368-7569" }, questID = { 57585 } }; --Llamada del Vacío
	[158754] = { zoneID = 1527, artID = { 1343 }, x = 5976, y = 7240, overlay = { "5976-7240" }, zoneQuestId = { 57157 }, questID = { 57429 } }; --Pira del Amalgamado
	[160818] = { zoneID = 1527, artID = { 1343 }, x = 6202, y = 7070, overlay = { "6202-7070" }, zoneQuestId = { 57157 }, questID = { 58271 } }; --Ritual de llama del Vacío
	[160915] = { zoneID = 1527, artID = { 1343 }, x = 5055, y = 8232, overlay = { "5055-8232" }, zoneQuestId = { 57157 }, questID = { 58275 } }; --Invocación monstruosa
	[160928] = { zoneID = 1527, artID = { 1343 }, x = 4940, y = 3935, overlay = { "4940-3935" }, zoneQuestId = { 57157 }, questID = { 58276 } }; --Mar'at en llamas
	[163120] = { zoneID = 1527, artID = { 1343 }, x = 6446, y = 2983, overlay = { "6446-2983" }, zoneQuestId = { 55350 }, questID = { 57215 } }; --Motor de ascensión
	[163132] = { zoneID = 1527, artID = { 1343 }, x = 7608, y = 4796, overlay = { "7608-4796" }, zoneQuestId = { 55350 }, questID = { 57243 } }; --Campamento de esclavos amathet
	[163198] = { zoneID = 1527, artID = { 1343 }, x = 3707, y = 4778, overlay = { "3707-4778" }, zoneQuestId = { 56308 }, questID = { 58961 } }; --Colonos emboscados
	[163204] = { zoneID = 1527, artID = { 1343 }, x = 2776, y = 5705, overlay = { "2776-5705" }, zoneQuestId = { 56308 }, questID = { 58974 } }; --Colonos emboscados
	[163223] = { zoneID = 1527, artID = { 1343 }, x = 4685, y = 5807, overlay = { "4685-5807" }, zoneQuestId = { 56308 }, questID = { 58981 } }; --Colmena aguerrida
	[163264] = { zoneID = 1527, artID = { 1343 }, x = 2832, y = 6559, overlay = { "2832-6559" }, zoneQuestId = { 56308 }, questID = { 58990 } }; --Huevo de titanus
	[163300] = { zoneID = 1527, artID = { 1343 }, x = 4780, y = 3190, overlay = { "4780-3190" }, zoneQuestId = { 57157 }, questID = { 57586 } }; --Bebedor de espíritus
	[163301] = { zoneID = 1527, artID = { 1343 }, x = 5398, y = 3202, overlay = { "5398-3202" }, zoneQuestId = { 57157 }, questID = { 57587 } }; --Bebedor de espíritus
	[163303] = { zoneID = 1527, artID = { 1343 }, x = 6017, y = 3120, overlay = { "6017-3120" }, zoneQuestId = { 57157 }, questID = { 57588 } }; --Bebedor de espíritus
	[163304] = { zoneID = 1527, artID = { 1343 }, x = 6398, y = 6593, overlay = { "6398-6593" }, zoneQuestId = { 57157 }, questID = { 57589 } }; --Bebedor de espíritus
	[163306] = { zoneID = 1527, artID = { 1343 }, x = 5907, y = 8021, overlay = { "5907-8021" }, zoneQuestId = { 57157 }, questID = { 57590 } }; --Bebedor de espíritus
	[163308] = { zoneID = 1527, artID = { 1343 }, x = 6058, y = 5867, overlay = { "6058-5867" }, questID = { 57591 } }; --Bebedor de espíritus
	[163337] = { zoneID = 1527, artID = { 1343 }, x = 3653, y = 2066, overlay = { "3653-2066" }, zoneQuestId = { 56308 }, questID = { 59003 } }; --Crisálidas inflamables
	[163356] = { zoneID = 1527, artID = { 1343 }, x = 3160, y = 4381, overlay = { "3160-4381" }, zoneQuestId = { 56308 }, questID = { 58660 } }; --Terrores cavadores
	[163357] = { zoneID = 1527, artID = { 1343 }, x = 4513, y = 4306, overlay = { "4513-4306" }, zoneQuestId = { 56308 }, questID = { 58661 } }; --Terrores cavadores
	[163358] = { zoneID = 1527, artID = { 1343 }, x = 3713, y = 6708, overlay = { "3713-6708" }, zoneQuestId = { 56308 }, questID = { 58662 } }; --Terrores cavadores
	[163359] = { zoneID = 1527, artID = { 1343 }, x = 3140, y = 5555, overlay = { "3140-5555" }, zoneQuestId = { 56308 }, questID = { 58667 } }; --Extracción de obsidiana
	[163360] = { zoneID = 1527, artID = { 1343 }, x = 2073, y = 5906, overlay = { "2073-5906" }, zoneQuestId = { 56308 }, questID = { 58676 } }; --Destructor durmiente
	[163361] = { zoneID = 1527, artID = { 1343 }, x = 3440, y = 2929, overlay = { "3440-2929" }, zoneQuestId = { 56308 }, questID = { 58679 } }; --Destructor durmiente
	[163362] = { zoneID = 1527, artID = { 1343 }, x = 2242, y = 6412, overlay = { "2242-6412" }, zoneQuestId = { 56308 }, questID = { 58952 } }; --Llamas purgantes
	[164358] = { zoneID = 1527, artID = { 1343 }, x = 6205, y = 2071, overlay = { "6205-2071" }, zoneQuestId = { 57375 }, questID = { 55356 } }; --Baliza del Rey del Sol
	[164359] = { zoneID = 1527, artID = { 1343 }, x = 8351, y = 6186, overlay = { "8351-6186" }, zoneQuestId = { 55350 } }; --Baliza del Rey del Sol
	[164361] = { zoneID = 1527, artID = { 1343 }, x = 7159, y = 4586, overlay = { "7159-4586" }, zoneQuestId = { 55350 }, questID = { 55358 } }; --Baliza del Rey del Sol
	[339382] = { zoneID = 1527, artID = { 1343 }, x = 6014, y = 4557, overlay = { "6014-4557" }, zoneQuestId = { 57157 }, questID = { 58216 } }; --Fauces acuciantes
	[339484] = { zoneID = 1527, artID = { 1343 }, x = 4679, y = 3424, overlay = { "4679-3424" }, zoneQuestId = { 57157 }, questID = { 58256 } }; --Fauces acuciantes
	[339488] = { zoneID = 1527, artID = { 1343 }, x = 5540, y = 2133, overlay = { "5540-2133" }, zoneQuestId = { 57157 }, questID = { 58257 } }; --Fauces acuciantes
	[339494] = { zoneID = 1527, artID = { 1343 }, x = 6241, y = 7932, overlay = { "6241-7932" }, zoneQuestId = { 57157 }, questID = { 58258 } }; --Fauces acuciantes
	[153241] = { zoneID = 1530, artID = { 1342 }, x = 1828, y = 7232, overlay = { "1828-7232" }, zoneQuestId = { 57008 }, questID = { 57384 } }; --Monstruosidad reparadora
	[154095] = { zoneID = 1530, artID = { 1342 }, x = 4233, y = 6703, overlay = { "4233-6703" }, questID = { 56090 } }; --Proteger al robusto
	[154104] = { zoneID = 1530, artID = { 1342 }, x = 4005, y = 6367, overlay = { "4005-6367" } }; --Ritual abisal
	[154118] = { zoneID = 1530, artID = { 1342 }, x = 6042, y = 6781, overlay = { "6042-6781" }, zoneQuestId = { 56064 }, questID = { 56099 } }; --Fuente de corrupción
	[154187] = { zoneID = 1530, artID = { 1342 }, x = 6057, y = 4328, overlay = { "6057-4328" }, zoneQuestId = { 56064 }, questID = { 56163 } }; --Guardián vinculado
	[154328] = { zoneID = 1530, artID = { 1342 }, x = 7953, y = 5431, overlay = { "7953-5431" }, zoneQuestId = { 56064 }, questID = { 56180 } }; --Guardián vinculado
	[156289] = { zoneID = 1530, artID = { 1342 }, x = 1098, y = 6446, overlay = { "1098-6446" }, zoneQuestId = { 57008 }, questID = { 57085 } }; --Carro de guerra potenciado
	[156389] = { zoneID = 1530, artID = { 1342 }, x = 4765, y = 2162, overlay = { "4765-2162" } }; --Jaula de dragones Zan-Tien
	[156472] = { zoneID = 1530, artID = { 1342 }, x = 4358, y = 4147, overlay = { "4358-4147" }, zoneQuestId = { 56064 }, questID = { 57146 } }; --Rasgadura de corrupción
	[156549] = { zoneID = 1530, artID = { 1342 }, x = 1453, y = 2306, overlay = { "1453-2306" }, zoneQuestId = { 57008 }, questID = { 57158 } }; --Potenciación eléctrica
	[156623] = { zoneID = 1530, artID = { 1342 }, x = 2055, y = 1263, overlay = { "2055-1263" }, questID = { 57171 } }; --Guardián de Ramaoro
	[157106] = { zoneID = 1530, artID = { 1342 }, x = 1704, y = 4571, overlay = { "1704-4571" }, zoneQuestId = { 57008 }, questID = { 57256 } }; --Arena de Electormenta
	[157144] = { zoneID = 1530, artID = { 1342 }, x = 1918, y = 7202, overlay = { "1918-7202" }, zoneQuestId = { 57008 }, questID = { 57272 } }; --Efigie Vinculasangre
	[157341] = { zoneID = 1530, artID = { 1342 }, x = 2471, y = 4793, overlay = { "2471-4793" }, questID = { 57323 } }; --Vinculación de dragón
	[157525] = { zoneID = 1530, artID = { 1342 }, x = 6929, y = 2178, overlay = { "6929-2178" }, zoneQuestId = { 56064 }, questID = { 57375 } }; --Túmulo palpitante
	[157581] = { zoneID = 1530, artID = { 1342 }, x = 2663, y = 4637, overlay = { "2663-4637" }, questID = { 57404 } }; --Colmena de devastadores
	[157601] = { zoneID = 1530, artID = { 1342 }, x = 2922, y = 6090, overlay = { "2922-6090" }, questID = { 57445 } }; --Carrito de fideos de Chin
	[157718] = { zoneID = 1530, artID = { 1342 }, x = 1417, y = 3179, overlay = { "1417-3179" }, questID = { 57453 } }; --Invocador de enjambre
	[157874] = { zoneID = 1530, artID = { 1342 }, x = 1133, y = 4097, overlay = { "1133-4097" }, questID = { 57476 } }; --Zona de alimentación Vil'thik
	[157934] = { zoneID = 1530, artID = { 1342 }, x = 1691, y = 4565, overlay = { "1691-4565" }, questID = { 57484 } }; --Ritual del despertar
	[158016] = { zoneID = 1530, artID = { 1342 }, x = 1099, y = 4847, overlay = { "1099-4847" }, zoneQuestId = { 57008 }, questID = { 57508 } }; --Estandarte de guerra Vil'thik
	[158033] = { zoneID = 1530, artID = { 1342 }, x = 2556, y = 3654, overlay = { "2556-3654" }, questID = { 57517 } }; --Invocador de enjambre
	[158036] = { zoneID = 1530, artID = { 1342 }, x = 2700, y = 1716, overlay = { "2700-1716" }, questID = { 57519 } }; --Invocador de enjambre
	[158037] = { zoneID = 1530, artID = { 1342 }, x = 0882, y = 2679, overlay = { "0882-2679" }, zoneQuestId = { 57008 }, questID = { 57521 } }; --Carro de guerra potenciado
	[158069] = { zoneID = 1530, artID = { 1342 }, x = 1853, y = 6576, overlay = { "1853-6576" }, zoneQuestId = { 57008 }, questID = { 57540 } }; --Incubadora kunchong
	[158114] = { zoneID = 1530, artID = { 1342 }, x = 3112, y = 6103, overlay = { "3112-6103" }, questID = { 57542 } }; --Invocador de enjambre
	[158467] = { zoneID = 1530, artID = { 1342 }, x = 2252, y = 0994, overlay = { "2252-0994" }, questID = { 57023 } }; --Artefacto mogu pesado
	[158470] = { zoneID = 1530, artID = { 1342 }, x = 2566, y = 1744, overlay = { "2566-1744" }, questID = { 57339 } }; --Ritual de construcción
	[158472] = { zoneID = 1530, artID = { 1342 }, x = 3133, y = 2892, overlay = { "3133-2892" }, questID = { 57087 } }; --Obliterador baruk
	[158521] = { zoneID = 1530, artID = { 1342 }, x = 5012, y = 6347, overlay = { "5012-6347" }, questID = { 57299 } }; --Sarcófago misterioso
	[161048] = { zoneID = 1530, artID = { 1342 }, x = 3336, y = 7117, overlay = { "3336-7117" }, zoneQuestId = { 57008 }, questID = { 58334 } }; --Bruma Otoñal en llamas
	[161053] = { zoneID = 1530, artID = { 1342 }, x = 2194, y = 2370, overlay = { "2194-2370" } }; --Artefacto mogu pesado
	[161055] = { zoneID = 1530, artID = { 1342 }, x = 2194, y = 2370, overlay = { "2194-2370" } }; --Cámara de almas
	[161070] = { zoneID = 1530, artID = { 1342 }, x = 2241, y = 3649, overlay = { "2241-3649" }, questID = { 58367 } }; --Demoledor potenciado
	[161089] = { zoneID = 1530, artID = { 1342 }, x = 2666, y = 1699, overlay = { "2666-1699" }, zoneQuestId = { 57008 }, questID = { 58370 } }; --Demoledor potenciado
	[161095] = { zoneID = 1530, artID = { 1342 }, x = 2194, y = 2370, overlay = { "2194-2370" } }; --Ritual de construcción
	[161181] = { zoneID = 1530, artID = { 1342 }, x = 7643, y = 5162, overlay = { "7643-5162" }, zoneQuestId = { 56064 }, questID = { 57379 } }; --Estatua de jade infestada
	[164301] = { zoneID = 1530, artID = { 1342 }, x = 0648, y = 7068, overlay = { "0648-7068" }, zoneQuestId = { 57008 } }; --Criadero mántide
	[164307] = { zoneID = 1530, artID = { 1342 }, x = 0647, y = 4227, overlay = { "0647-4227" }, questID = { 57558,57089 } }; --Criadero mántide
	[164331] = { zoneID = 1530, artID = { 1342 }, x = 7423, y = 3997, overlay = { "7423-3997" }, zoneQuestId = { 56064 }, questID = { 56076 } }; --Ritual abisal
	[327229] = { zoneID = 1530, artID = { 1342 }, x = 4936, y = 6668, overlay = { "4936-6668" }, questID = { 56074 } }; --Conducto del Vacío
	[327553] = { zoneID = 1530, artID = { 1342 }, x = 7925, y = 3314, overlay = { "7925-3314" }, zoneQuestId = { 56064 }, questID = { 56177 } }; --Conducto del Vacío
	[327554] = { zoneID = 1530, artID = { 1342 }, x = 5668, y = 5932, overlay = { "5668-5932" }, zoneQuestId = { 56064 }, questID = { 56178 } }; --Conducto del Vacío
	[333213] = { zoneID = 1530, artID = { 1342 }, x = 1987, y = 0750, overlay = { "1987-0750" }, questID = { 57049 } }; --Cámara de almas
	[339756] = { zoneID = 1530, artID = { 1342 }, x = 4638, y = 5717, overlay = { "4638-5717" }, questID = { 58438 } }; --Fauces acuciantes
	[339856] = { zoneID = 1530, artID = { 1342 }, x = 4132, y = 4540, overlay = { "4132-4540" }, zoneQuestId = { 56064 }, questID = { 58439 } }; --Fauces acuciantes
	[339870] = { zoneID = 1530, artID = { 1342 }, x = 8135, y = 4952, overlay = { "8135-4952" }, zoneQuestId = { 56064 }, questID = { 58442 } }; --Fauces acuciantes
	[160869] = { zoneID = 1533, artID = { 1321 }, x = 5145, y = 6860, overlay = { "5145-6860" } }; --Reparar campana de vísperas: Aria de Sophia
	[170899] = { zoneID = 1533, artID = { 1321 }, x = 5350, y = 8836, overlay = { "5350-8836" }, questID = { 60933 } }; --El Consejo de los Ascendidos
	[174607] = { zoneID = 1533, artID = { 1321 }, x = 6129, y = 5094, overlay = { "6129-5094" } }; --Reparar campana de vísperas: Obertura de Sophia
	[176103] = { zoneID = 1543, artID = { 1693 }, x = 2905, y = 6240, overlay = { "2905-6240" } }; --Evento: Cólera del Carcelero
	[177525] = { zoneID = 1543, artID = { 1693 }, x = 2799, y = 4773, overlay = { "2799-4773" }, resetTimer = 7200, worldmap = true }; --Tormentors event
	[180293] = { zoneID = 1543, artID = { 1693 }, x = 5765, y = 6330, overlay = { "5765-6330" }, questID = { 64258 }, worldmap = true }; --Assault Supply Carriage
	[180181] = { zoneID = 1961, artID = { 1648 }, x = 5821, y = 1767, overlay = { "5821-1767" }, questID = { 64258 }, worldmap = true }; --Assault Supply Carriage
}
