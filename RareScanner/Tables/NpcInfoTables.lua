-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...

private.NPC_INFO = {
	[181265] = { zoneID = 0, displayID = 97275 }; --Observer Gast
	[181656] = { zoneID = 0, displayID = 34547 }; --Atramedes [DNT]
	[184238] = { zoneID = 0, displayID = 102545 }; --Wild Water Whirlwind
	[185381] = { zoneID = 0, displayID = 24835, questID = { 66004 } }; --Galgresh
	[185382] = { zoneID = 0, displayID = 100536 }; --[PH] Vignette, Wardog Alpha
	[185383] = { zoneID = 0, displayID = 103507 }; --[PH] Vignette, the Stormbearer
	[185384] = { zoneID = 0, displayID = 101656 }; --[PH] Vignette, the Iron Spear
	[185897] = { zoneID = 0, displayID = 55139 }; --Nomadic Vinyeti <Vignette Placeholder>
	[185918] = { zoneID = 0, displayID = 40954 }; --Bugchewer
	[186168] = { zoneID = 0, displayID = 102031 }; --[DNT] Sootscale the Indomitable (5/1)
	[186463] = { zoneID = 0, displayID = 101247 }; --Frostmaul
	[186466] = { zoneID = 0, displayID = 103373 }; --Gur Grikpaw
	[186837] = { zoneID = 0, displayID = 103279 }; --Eggkidu
	[187026] = { zoneID = 0, displayID = 102911 }; --His Fuzziness
	[187056] = { zoneID = 0, displayID = 106005 }; --Gorbo the Usurper <Even Bigger Guy>
	[187298] = { zoneID = 0, displayID = 106004 }; --Herodofin <Gorloc Historian>
	[187603] = { zoneID = 0, displayID = 55139 }; --Vinyeti <Vignette Placeholder>
	[187612] = { zoneID = 0, displayID = 105340 }; --Balak the Breaker
	[187614] = { zoneID = 0, displayID = 105353 }; --Hamiir of the Winds
	[187619] = { zoneID = 0, displayID = 100207 }; --Kol Marsiik
	[188024] = { zoneID = 0, displayID = 1293 }; --Creature Name
	[188025] = { zoneID = 0, displayID = 1293 }; --Creature Name
	[188033] = { zoneID = 0, displayID = 98797 }; --Automaton Rare
	[188387] = { zoneID = 0, displayID = 102552 }; --[DNT] Unstable Fumerole <(RARE ELITE) FIGHTER:LAVA>
	[188388] = { zoneID = 0, displayID = 103250 }; --Terramaw <(T3 ELITE) FIGHTER:EARTH>
	[189861] = { zoneID = 0, displayID = 105897 }; --Soulspeaker Han
	[189871] = { zoneID = 0, displayID = 105337 }; --Weaponmaster Hasi
	[189872] = { zoneID = 0, displayID = 107019 }; --Nakiin the Shatterer
	[190161] = { zoneID = 0, displayID = 106316 }; --Sarana
	[190465] = { zoneID = 0, displayID = 103588 }; --Venomous Stonegazer
	[190514] = { zoneID = 0, displayID = 106434 }; --Tempisyn
	[190518] = { zoneID = 0, displayID = 106025 }; --Vulkara
	[190520] = { zoneID = 0, displayID = 106439 }; --Shatterfang
	[190521] = { zoneID = 0, displayID = 105819 }; --Shaleheart
	[190523] = { zoneID = 0, displayID = 106472 }; --General Galerend
	[190538] = { zoneID = 0, displayID = 102505 }; --Lord Searsinge
	[190574] = { zoneID = 0, displayID = 107164 }; --Rimecaller Hazek
	[190599] = { zoneID = 0, displayID = 106015 }; --Stoneroot the Calm
	[190601] = { zoneID = 0, displayID = 107188 }; --The Ravager
	[190625] = { zoneID = 0, displayID = 106906 }; --Smokescale
	[190634] = { zoneID = 0, displayID = 102949 }; --Glacierstomp
	[190641] = { zoneID = 0, displayID = 102922 }; --Ascendant Soilclaw
	[190713] = { zoneID = 0, displayID = 55139 }; --Vinyeti <Vignette Placeholder>
	[190751] = { zoneID = 0, displayID = 107247 }; --Earthrender Kasrak
	[190752] = { zoneID = 0, displayID = 107250 }; --The Drowned One
	[190756] = { zoneID = 0, displayID = 108327 }; --Blade of the Tempest
	[190757] = { zoneID = 0, displayID = 102719 }; --General Flarescale
	[190907] = { zoneID = 0, displayID = 104743 }; --Blitztusk
	[190968] = { zoneID = 0, displayID = 106754 }; --Norbett
	[191103] = { zoneID = 0, displayID = 107233 }; --Uranto the Swift
	[191125] = { zoneID = 0, displayID = 107344 }; --Earth-Warder's Vault
	[191130] = { zoneID = 0, displayID = 106024 }; --Apex Fire Proto
	[191151] = { zoneID = 0, displayID = 107344 }; --Earth-Warder's Vault
	[191462] = { zoneID = 0, displayID = 105963 }; --Towering Fickleshells
	[191649] = { zoneID = 0, displayID = 104743 }; --Apex Mammoth
	[191650] = { zoneID = 0, displayID = 106316 }; --Apex Sabertooth
	[191651] = { zoneID = 0, displayID = 107581 }; --Apex Stomphoof
	[191950] = { zoneID = 0, displayID = 106291 }; --Porta the Overgrown
	[192519] = { zoneID = 0, displayID = 102555 }; --Ensorcelled Muck
	[192557] = { zoneID = 0, displayID = 110389 }; --Quackers the Terrible
	[193124] = { zoneID = 0, displayID = 24835 }; --[DNT]
	[193167] = { zoneID = 0, displayID = 103563 }; --Swagraal the Swollen
	[193272] = { zoneID = 0, displayID = 107364 }; --Nalrusza
	[193311] = { zoneID = 0, displayID = 103584 }; --Melkhop
	[193330] = { zoneID = 0, displayID = 108030, questID = { 73916 } }; --Galzuda
	[193341] = { zoneID = 0, displayID = 100537 }; --Angen
	[193381] = { zoneID = 0, displayID = 102868 }; --Urveda the Stormbinder
	[193412] = { zoneID = 0, displayID = 108274 }; --Ara'rotan the Corrupted
	[193629] = { zoneID = 0, displayID = 9491 }; --PH [DNT]
	[193674] = { zoneID = 0, displayID = 106471, questID = { 69969 } }; --Voraazka
	[193678] = { zoneID = 0, displayID = 108255 }; --Fieraan <Second Iceblade>
	[193681] = { zoneID = 0, displayID = 108258 }; --Animated Earthen Core
	[193690] = { zoneID = 0, displayID = 108265 }; --Jareeza <<Passage Stalker>>
	[193693] = { zoneID = 0, displayID = 103198 }; --Rusthide
	[193704] = { zoneID = 0, displayID = 100214 }; --Honmor
	[193722] = { zoneID = 0, displayID = 104140 }; --Tomnu
	[193724] = { zoneID = 0, displayID = 102372 }; --Uurtus
	[193836] = { zoneID = 0, displayID = 102872 }; --Windmancer Navati
	[193853] = { zoneID = 0, displayID = 38391 }; --Galnmor
	[193885] = { zoneID = 0, displayID = 103585 }; --Salkii
	[193896] = { zoneID = 0, displayID = 102554 }; --Borzgas
	[194225] = { zoneID = 0, displayID = 103433 }; --Muugurv
	[194240] = { zoneID = 0, displayID = 104037 }; --Gamgus
	[194489] = { zoneID = 0, displayID = 106631 }; --Elusive Elder Drake
	[194491] = { zoneID = 0, displayID = 100223 }; --Elusive Elder Frigidpelt
	[194608] = { zoneID = 0, displayID = 104135 }; --Kholdeg
	[194624] = { zoneID = 0, displayID = 104128 }; --Zumakh
	[194761] = { zoneID = 0, displayID = 105554 }; --Khuumog
	[194763] = { zoneID = 0, displayID = 104874 }; --Tenmod
	[195286] = { zoneID = 0, displayID = 102548 }; --Mantai
	[195431] = { zoneID = 0, displayID = 107658 }; --Diluu
	[195465] = { zoneID = 0, displayID = 104065 }; --Elusive Tempest Lizard
	[195472] = { zoneID = 0, displayID = 106316 }; --Elusive Ferocious Titanfang
	[195492] = { zoneID = 0, displayID = 103433 }; --Elusive Deepwater Salamanther
	[195509] = { zoneID = 0, displayID = 107445 }; --Elusive Proto Skyterror
	[195541] = { zoneID = 0, displayID = 100337 }; --Elusive Flourishing Quillbloom
	[196244] = { zoneID = 0, displayID = 104744 }; --Hen the Stomper
	[196246] = { zoneID = 0, displayID = 109112 }; --Harat the Ancient
	[196250] = { zoneID = 0, displayID = 107074 }; --Thunder Talek <Lord of the Plains>
	[196324] = { zoneID = 0, displayID = 104705 }; --Milah the Galedancer
	[196326] = { zoneID = 0, displayID = 101619 }; --Packleader Fenka <Shadepaw Pack>
	[196334] = { zoneID = 0, displayID = 103920 }; --The Great Enla <Scourge of the Plains>
	[196350] = { zoneID = 0, displayID = 103920 }; --Old Stormhide
	[196535] = { zoneID = 0, displayID = 109225 }; --Nezascar the Sightless
	[197409] = { zoneID = 0, displayID = 109531 }; --Rhuzast the Tempest
	[197501] = { zoneID = 0, displayID = 109554 }; --Krolkoth the Mountain
	[5809] = { zoneID = 1, artID = { 2 }, x = 5920, y = 5820, overlay = { "5920-5820" }, friendly = { "A" }, displayID = 33165 }; --Sergeant Curtis
	[5822] = { zoneID = {
				[1] = { x = 5280, y = 0892, artID = { 2 }, overlay = { "5280-0892" } };
				[5] = { x = 2120, y = 6080, artID = { 7 }, overlay = { "2120-6080","2180-5760","2220-5880","2360-6240","3800-4020","5580-2380","5820-2760" } };
			  }, displayID = 4594 }; --null
	[5823] = { zoneID = 1, artID = { 2 }, x = 3900, y = 4596, overlay = { "3440-4460","3480-4340","3540-4600","3640-4440","3720-4580","3720-4760","3800-4460","3840-4340","3840-4680","3880-4860","3960-4520","3980-4400" }, displayID = 2491 }; --Death Flayer
	[5824] = { zoneID = 1, artID = { 2 }, x = 4242, y = 3741, overlay = { "3860-5380","4240-3860","4420-4980" }, displayID = 1343 }; --Captain Flat Tusk <Captain of the Battlegu>
	[5826] = { zoneID = 1, artID = { 2 }, x = 4263, y = 3782, overlay = { "4320-3940","4340-4980","4700-4940","4263-3782" }, displayID = 6093 }; --Geolord Mottle
	[3058] = { zoneID = 7, artID = { 8 }, x = 4800, y = 6860, overlay = { "4800-6860","5040-6660","5040-6840","5140-6520","5180-6840","5240-6380","5320-6220","5380-6900","5460-6800","5480-6240","5480-7000","5620-6320","5620-7000","5700-6580","5780-6760","5780-6900" }, displayID = 10916 }; --Arra'chea
	[3068] = { zoneID = 7, artID = { 8 }, x = 4240, y = 4540, overlay = { "4240-4540","4360-4100","4440-4740","4560-4720","4680-4680","4720-4060","4880-4340","5000-4260" }, displayID = 1961 }; --Mazzranache
	[43613] = { zoneID = 7, artID = { 8 }, x = 3380, y = 3700, overlay = { "3380-3700" }, displayID = 33430 }; --Doomsayer Wiserunner <Twilight's Ham>
	[43720] = { zoneID = {
				[7] = { x = 4295, y = 8914, artID = { 8 }, overlay = { "4295-8914" } };
				[462] = { x = 2120, y = 7100, artID = { 474 }, overlay = { "2040-7060" } };
			  }, displayID = 52724 }; --null
	[5785] = { zoneID = 7, artID = { 8 }, x = 3200, y = 2440, overlay = { "3200-2440","5240-1180","5340-1260" }, displayID = 2163 }; --Sister Hatelash
	[5786] = { zoneID = 7, artID = { 8 }, x = 4840, y = 7040, overlay = { "4840-7040","5320-7120" }, displayID = 488 }; --Snagglespear
	[5787] = { zoneID = 7, artID = { 8 }, x = 6040, y = 4740, overlay = { "6040-4740" }, displayID = 610 }; --Enforcer Emilgund
	[5807] = { zoneID = 7, artID = { 8 }, x = 4960, y = 2200, overlay = { "4960-2200","4980-2500","5000-2320","5040-2620","5080-2160","5100-2840","5220-2120","5340-1940","5340-2960","5440-2020","5540-2400","5580-2560" }, displayID = 1973 }; --The Rake
	[3270] = { zoneID = 10, artID = { 11 }, x = 5640, y = 5160, overlay = { "5640-5160","5820-4960","6080-5240" }, displayID = 6112 }; --Elder Mystic Razorsnout
	[3295] = { zoneID = 10, artID = { 11 }, x = 5740, y = 1920, overlay = { "5740-1920","5760-2040" }, displayID = 360 }; --Sludge Anomaly
	[3398] = { zoneID = 10, artID = { 11 }, x = 4003, y = 7454, overlay = { "4000-7460" }, displayID = 1397 }; --Gesharahan
	[3470] = { zoneID = 10, artID = { 11 }, x = 4155, y = 3949, overlay = { "4120-3920","4220-3840" }, displayID = 5047 }; --Rathorian
	[3652] = { zoneID = {
				[10] = { x = 4275, y = 6364, artID = { 11 }, overlay = { "4275-6364" } };
				[11] = { x = 6040, y = 3859, artID = { 12 }, overlay = { "6040-3860","6040-4060","6160-4120","6200-3880","6240-3740" } };
			  }, displayID = 1092 }; --null
	[3672] = { zoneID = {
				[10] = { x = 4266, y = 6509, artID = { 11 }, overlay = { "4266-6509" } };
				[11] = { x = 6003, y = 4967, artID = { 12 }, overlay = { "6760-5740","6820-5900","7080-5780","7400-2560","7800-4000","7920-3920" } };
			  }, displayID = 4212 }; --null
	[5828] = { zoneID = 10, artID = { 11 }, x = 6720, y = 6400, overlay = { "6720-6400" }, displayID = 4424 }; --Humar the Pridelord
	[5830] = { zoneID = 10, artID = { 11 }, x = 2540, y = 3320, overlay = { "2540-3320" }, displayID = 10876 }; --Sister Rathtalon
	[5831] = { zoneID = 10, artID = { 11 }, x = 6320, y = 6340, overlay = { "6320-6340","6480-6040" }, displayID = 6084 }; --Swiftmane
	[5835] = { zoneID = 10, artID = { 11 }, x = 5720, y = 1939, overlay = { "5720-1940","5720-2060" }, displayID = 4593 }; --Foreman Grills
	[5836] = { zoneID = 10, artID = { 11 }, x = 5800, y = 2040, overlay = { "5800-2040" }, displayID = 7049 }; --Engineer Whirleygig
	[5837] = { zoneID = {
				[10] = { x = 3180, y = 4840, artID = { 11 }, overlay = { "3180-4840","3240-5240","4000-4560" } };
				[199] = { x = 4060, y = 0880, artID = { 204 }, overlay = { "4060-0880" } };
			  }, displayID = 4874 }; --null
	[5838] = { zoneID = 10, artID = { 11 }, x = 5224, y = 7575, overlay = { "5140-8340","5180-7540","5380-8700","5780-8220","5840-7760" }, displayID = 9448 }; --Brokespear
	[5841] = { zoneID = 10, artID = { 11 }, x = 5900, y = 8060, overlay = { "5900-8060","5920-7940" }, displayID = 9533 }; --Rocklance
	[5842] = { zoneID = 10, artID = { 11 }, x = 6340, y = 3600, overlay = { "6340-3600" }, displayID = 1337 }; --Takk the Leaper
	[5865] = { zoneID = 10, artID = { 11 }, x = 4520, y = 5280, overlay = { "4520-5280","4540-3300","4880-5180" }, displayID = 1043 }; --Dishu
	[141615] = { zoneID = 14, artID = { 1137 }, x = 3063, y = 4472, overlay = { "2920-4440","2940-4560","3040-4340","3040-4480" }, displayID = 37986, questID = { 53017,53506 } }; --Burning Goliath
	[141616] = { zoneID = 14, artID = { 1137 }, x = 4634, y = 5214, overlay = { "4520-5200","4640-5140" }, displayID = 54195, questID = { 53023,53527 } }; --Thundering Goliath
	[141618] = { zoneID = 14, artID = { 1137 }, x = 6209, y = 3150, overlay = { "6140-3140","6220-3260" }, displayID = 62045, questID = { 53018,53531 } }; --Cresting Goliath
	[141620] = { zoneID = 14, artID = { 1137 }, x = 2986, y = 5985, overlay = { "2920-5940","2940-6100","3020-5820" }, displayID = 37987, questID = { 53021,53523 } }; --Rumbling Goliath
	[141668] = { zoneID = 14, artID = { 1137 }, x = 5707, y = 3473, overlay = { "5620-3440","5640-3560","5680-3320","5700-3800","5720-3660","5760-3440" }, displayID = 77145, questID = { 53059,53508 } }; --Echo of Myzrael
	[141942] = { zoneID = 14, artID = { 1137 }, x = 4766, y = 7804, overlay = { "4680-7720","4740-7860","4860-7720" }, displayID = 87784, questID = { 53057,53516 } }; --Molok the Crusher
	[142112] = { zoneID = 14, artID = { 1137 }, x = 4918, y = 8416, overlay = { "4900-8340" }, displayID = 88105, questID = { 53058,53513 } }; --Kor'gresh Coldrage
	[142423] = { zoneID = 14, artID = { 1137 }, x = 3282, y = 3870, overlay = { "2700-5640","3300-3640","3300-3760" }, displayID = 64568, questID = { 53014,53518 } }; --Overseer Krix
	[142433] = { zoneID = 14, artID = { 1137 }, x = 5938, y = 2833, overlay = { "3020-4800","4720-4960","5920-3020","5940-2740","5940-2860","5940-3140","6000-3260","6020-3400","6100-3180" }, displayID = 12814, questID = { 53019,53510 } }; --Fozruk <Son of Fozruk>
	[142435] = { zoneID = 14, artID = { 1137 }, x = 3685, y = 6238, overlay = { "3520-6480","3540-6140","3540-6280","3660-6140","3680-6520","3720-6340","3720-6660" }, displayID = 54845, questID = { 53020,53519 } }; --Plaguefeather
	[142436] = { zoneID = 14, artID = { 1137 }, x = 1206, y = 5218, overlay = { "1200-5200","1840-2800" }, displayID = 37771, questID = { 53016,53522 } }; --Ragebeak
	[142437] = { zoneID = 14, artID = { 1137 }, x = 5589, y = 4467, overlay = { "5640-4420","5640-4540","5680-4660","5760-4440","5760-4560" }, displayID = 61297, questID = { 53022,53526 } }; --Skullripper
	[142438] = { zoneID = 14, artID = { 1137 }, x = 5726, y = 5413, overlay = { "5620-5460","5640-5340","5760-5340","5760-5460" }, displayID = 46232, questID = { 53024,53528 } }; --Venomarus
	[142440] = { zoneID = 14, artID = { 1137 }, x = 1425, y = 3736, overlay = { "1320-3540","1340-3700","1380-3860","1460-3620","1460-3740" }, displayID = 66633, questID = { 53015,53529 } }; --Yogursa
	[142508] = { zoneID = 14, artID = { 1137 }, x = 2269, y = 2240, overlay = { "2120-1960","2140-2100","2140-2300","2240-1860","2260-2040","2280-2260","2360-2120" }, displayID = 56952, questID = { 53013,53505 } }; --Branchlord Aldrus
	[142662] = { zoneID = 14, artID = { 1137 }, x = 7942, y = 2942, overlay = { "7940-2940" }, displayID = 27190, questID = { 53060,53511 } }; --Geomancer Flintdagger
	[142682] = { zoneID = 14, artID = { 1137 }, x = 6289, y = 8112, overlay = { "6240-8020" }, displayID = 88246, questID = { 53094,53530 } }; --Zalas Witherbark <Warband Leader>
	[142683] = { zoneID = 14, artID = { 1137 }, x = 4290, y = 5649, overlay = { "4280-5640" }, displayID = 88093, questID = { 53092,53524 } }; --Ruul Onestone
	[142684] = { zoneID = 14, artID = { 1137 }, x = 2517, y = 4846, overlay = { "2460-4740","2500-4860","2660-4740" }, displayID = 87968, questID = { 53089,53514 } }; --Kovork
	[142686] = { zoneID = 14, artID = { 1137 }, x = 2232, y = 5112, overlay = { "2220-4940","2220-5060" }, displayID = 88106, questID = { 53086,53509 } }; --Foulbelly
	[142688] = { zoneID = 14, artID = { 1137 }, x = 5087, y = 3657, overlay = { "5020-3760","5040-6100","5087-3657" }, displayID = 4027, questID = { 53084,53507 } }; --Darbel Montrose
	[142690] = { zoneID = 14, artID = { 1137 }, x = 5117, y = 3990, overlay = { "5060-5740","5080-4060" }, displayID = 4026, questID = { 53093,53525 } }; --Singer
	[142692] = { zoneID = 14, artID = { 1137 }, x = 6762, y = 6086, overlay = { "6740-6040" }, displayID = 88253, questID = { 53091,53517 } }; --Nimar the Slayer <Warband Leader>
	[142709] = { zoneID = 14, artID = { 1137 }, x = 6473, y = 7168, overlay = { "6480-7160","6540-6880","6540-7040","6600-6760","6680-6540","6780-6640" }, displayID = 88188, questID = { 53083,53504 } }; --Beastrider Kama
	[142716] = { zoneID = 14, artID = { 1137 }, x = 5208, y = 7275, overlay = { "5180-7620","5200-7240","5200-7440" }, displayID = 88095, questID = { 53090,53515 } }; --Man-Hunter Rog
	[142725] = { zoneID = 14, artID = { 1137 }, x = 1943, y = 6131, overlay = { "1940-6140","2620-3120","2640-3260" }, displayID = 60824, questID = { 53087,53512 } }; --Horrific Apparition
	[142739] = { zoneID = 14, artID = { 1137 }, x = 4890, y = 3994, overlay = { "4740-4120","4840-4040","4940-3760","4940-3940" }, friendly = { "A" }, displayID = 87988, questID = { 53088 } }; --Knight-Captain Aldrin <League of Arathor>
	[142741] = { zoneID = 14, artID = { 1137 }, x = 5380, y = 5720, overlay = { "5320-5600","5320-5740" }, friendly = { "H" }, displayID = 87703, questID = { 53085 } }; --Doomrider Helgrim <The Defilers>
	[2598] = { zoneID = 14, artID = { 15 }, x = 1920, y = 6459, overlay = { "1920-6460" }, displayID = 4027 }; --Darbel Montrose
	[2600] = { zoneID = 14, artID = { 15 }, x = 2740, y = 2780, overlay = { "2740-2780" }, displayID = 4026 }; --Singer
	[2601] = { zoneID = 14, artID = { 15 }, x = 1400, y = 6740, overlay = { "1400-6740","1420-6940","1500-6840" }, displayID = 20018 }; --Foulbelly
	[2602] = { zoneID = 14, artID = { 15 }, x = 1800, y = 3120, overlay = { "1800-3120","1960-3060" }, displayID = 32547 }; --Ruul Onestone
	[2603] = { zoneID = 14, artID = { 15 }, x = 2420, y = 4440, overlay = { "2420-4440" }, displayID = 25189 }; --Kovork
	[2604] = { zoneID = 14, artID = { 15 }, x = 4660, y = 7719, overlay = { "4660-7720","4700-7500","4780-7680","4780-7880" }, displayID = 20017 }; --Molok the Crusher
	[2605] = { zoneID = 14, artID = { 15 }, x = 6240, y = 8000, overlay = { "6240-8000" }, displayID = 28239 }; --Zalas Witherbark <Warband Lea>
	[2606] = { zoneID = 14, artID = { 15 }, x = 6780, y = 6640, overlay = { "6780-6640" }, displayID = 28818 }; --Nimar the Slayer <Warband Lea>
	[2609] = { zoneID = 14, artID = { 15 }, x = 7940, y = 2940, overlay = { "7940-2940" }, displayID = 27190 }; --Geomancer Flintdagger
	[2779] = { zoneID = 14, artID = { 15 }, x = 1400, y = 8660, overlay = { "1400-8660","1420-9240","1540-8880","1620-8700","1620-9320","1640-9120" }, displayID = 6763 }; --Prince Nazjak
	[50337] = { zoneID = 14, artID = { 15 }, x = 2260, y = 8760, overlay = { "2100-8760","2180-8620","2220-8780" }, displayID = 46227 }; --Cackle
	[50770] = { zoneID = {
				[14] = { x = 2200, y = 1400, artID = { 15 }, overlay = { "2160-1540","2200-1400" } };
				[25] = { x = 7700, y = 6000, artID = { 26 }, overlay = { "7700-6000" } };
			  }, displayID = 46232 }; --null
	[50804] = { zoneID = 14, artID = { 15 }, x = 3720, y = 6360, overlay = { "3540-6180","3600-6340","3660-6140","3720-6360" }, displayID = 10827 }; --Ripwing
	[50865] = { zoneID = 14, artID = { 15 }, x = 4320, y = 3480, overlay = { "4180-3440","4180-3560","4320-3480" }, displayID = 21825 }; --Saurix
	[50891] = { zoneID = 14, artID = { 15 }, x = 4859, y = 3579, overlay = { "4740-3380","4820-3660","4840-3520" }, displayID = 46235 }; --Boros
	[50940] = { zoneID = 14, artID = { 15 }, x = 5660, y = 5660, overlay = { "5560-5760","5640-5640" }, displayID = 20814 }; --Swee
	[51040] = { zoneID = 14, artID = { 15 }, x = 2680, y = 2720, overlay = { "2520-2760","2680-2720" }, displayID = 30222 }; --Snuffles
	[51063] = { zoneID = 14, artID = { 15 }, x = 4859, y = 8140, overlay = { "4780-8220" }, displayID = 46226 }; --Phalanax
	[51067] = { zoneID = 14, artID = { 15 }, x = 3060, y = 6140, overlay = { "3000-6100","3040-6340" }, displayID = 36634 }; --Glint
	[14224] = { zoneID = 15, artID = { 16 }, x = 7800, y = 3259, overlay = { "7800-3260","7840-3140" }, displayID = 6889 }; --7:XT <Long Distance Recovery U>
	[2744] = { zoneID = 15, artID = { 16 }, x = 3940, y = 2440, overlay = { "3940-2440" }, displayID = 4937 }; --Shadowforge Commander
	[2749] = { zoneID = 15, artID = { 16 }, x = 0940, y = 4880, overlay = { "0940-4880","2700-3780" }, displayID = 10802 }; --Barricade
	[2751] = { zoneID = 15, artID = { 16 }, x = 4840, y = 2620, overlay = { "4840-2620" }, displayID = 5747 }; --War Golem
	[2752] = { zoneID = 15, artID = { 16 }, x = 1580, y = 2979, overlay = { "1580-2980" }, displayID = 37714 }; --Rumbler
	[2753] = { zoneID = 15, artID = { 16 }, x = 3940, y = 5820, overlay = { "3940-5820","3940-5940","4060-6020","4080-5880" }, displayID = 9372 }; --Barnabus
	[2754] = { zoneID = 15, artID = { 16 }, x = 0800, y = 6640, overlay = { "0800-6640","0880-6520" }, displayID = 35463 }; --Anathemus
	[2850] = { zoneID = 15, artID = { 16 }, x = 2239, y = 6080, overlay = { "2240-6080" }, displayID = 21192 }; --Broken Tooth
	[2931] = { zoneID = 15, artID = { 16 }, x = 5500, y = 4320, overlay = { "5500-4320","5540-4440","5540-4580","5660-4340" }, displayID = 37577 }; --Zaricotl
	[50726] = { zoneID = 15, artID = { 16 }, x = 3240, y = 3420, overlay = { "3200-3520" }, displayID = 46250 }; --Kalixx
	[50728] = { zoneID = 15, artID = { 16 }, x = 7019, y = 5340, overlay = { "6940-5360" }, displayID = 20308 }; --Deathstrike
	[50731] = { zoneID = 15, artID = { 16 }, x = 5080, y = 7260, overlay = { "5040-7240" }, displayID = 17062 }; --Needlefang
	[50838] = { zoneID = 15, artID = { 16 }, x = 5859, y = 6060, overlay = { "5820-6040" }, displayID = 46251 }; --Tabbs
	[51000] = { zoneID = 15, artID = { 16 }, x = 7219, y = 2740, overlay = { "7020-2960","7180-2800" }, displayID = 46248 }; --Blackshell the Impenetrable
	[51007] = { zoneID = 15, artID = { 16 }, x = 2760, y = 3800, overlay = { "2640-3800","2760-3800" }, displayID = 46252 }; --Serkett
	[51018] = { zoneID = 15, artID = { 16 }, x = 5180, y = 3420, overlay = { "5140-3420" }, displayID = 19996 }; --Zormus
	[51021] = { zoneID = 15, artID = { 16 }, x = 2320, y = 3760, overlay = { "2180-3740","2320-3720" }, displayID = 20910 }; --Vorticus
	[45257] = { zoneID = 17, artID = { 18 }, x = 6060, y = 2979, overlay = { "6040-2920" }, displayID = 6786 }; --Mordak Nightbender
	[45258] = { zoneID = 17, artID = { 18 }, x = 6060, y = 7540, overlay = { "6040-7540" }, displayID = 5029 }; --Cassia the Slitherqueen
	[45260] = { zoneID = 17, artID = { 18 }, x = 3100, y = 7060, overlay = { "3100-6980" }, displayID = 12929 }; --Blackleaf
	[45262] = { zoneID = 17, artID = { 18 }, x = 3240, y = 4440, overlay = { "3200-4460" }, displayID = 19949 }; --Narixxus the Doombringer
	[7846] = { zoneID = 17, artID = { 18 }, x = 5120, y = 4820, overlay = { "5120-4820","5120-5040","5140-4620","5160-4460","5160-5200","5160-5380","5240-4920","5280-4580","5300-4420","5320-5400","5440-4340","5440-4500","5500-5420","5580-4380","5620-4540","5640-5340","5680-4680","5720-4840","5720-5220","5780-5000" }, displayID = 6378 }; --Teremus the Devourer
	[8296] = { zoneID = 17, artID = { 18 }, x = 4640, y = 2620, overlay = { "4640-2620" }, displayID = 11562 }; --Mojo the Twisted
	[8297] = { zoneID = 17, artID = { 18 }, x = 4640, y = 3920, overlay = { "4640-3920" }, displayID = 11564 }; --Magronos the Unyielding
	[8298] = { zoneID = 17, artID = { 18 }, x = 7340, y = 5500, overlay = { "7340-5500" }, displayID = 10920 }; --Akubar the Seer
	[8299] = { zoneID = 17, artID = { 18 }, x = 5940, y = 3540, overlay = { "5940-3540","5940-3660","5940-3820","6000-3420","6080-4000","6160-3260","6200-3660","6200-4020","6320-4020","6340-3300","6440-3800","6460-3360","6460-3600","6460-3940" }, displayID = 37536 }; --Spiteflayer
	[8300] = { zoneID = 17, artID = { 18 }, x = 4900, y = 3440, overlay = { "4900-3440","4920-3560" }, displayID = 34324 }; --Ravage
	[8301] = { zoneID = 17, artID = { 18 }, x = 4720, y = 1380, overlay = { "4720-1380" }, displayID = 15433 }; --Clack the Reaver
	[8302] = { zoneID = 17, artID = { 18 }, x = 5120, y = 2720, overlay = { "5120-2720","5160-2560","5240-2740","5240-2900","5340-2640" }, displayID = 46053 }; --Deatheye
	[8303] = { zoneID = 17, artID = { 18 }, x = 5440, y = 3940, overlay = { "5440-3940","5520-3840","5540-4020" }, displayID = 24741 }; --Grunter
	[8304] = { zoneID = 17, artID = { 18 }, x = 3660, y = 2820, overlay = { "3660-2820","3700-2940" }, displayID = 7844 }; --Dreadscorn
	[10356] = { zoneID = 18, artID = { 19 }, x = 4599, y = 4847, overlay = { "4540-4880","4660-5020" }, displayID = 37773 }; --Bayne
	[10357] = { zoneID = 18, artID = { 19 }, x = 5370, y = 5776, overlay = { "5220-5640","5340-5740","5360-5860","5420-5620" }, displayID = 16053 }; --Ressan the Needler
	[10358] = { zoneID = 18, artID = { 19 }, x = 7700, y = 5980, overlay = { "7700-5980" }, displayID = 16254 }; --Fellicent's Shade
	[10359] = { zoneID = 18, artID = { 19 }, x = 8440, y = 4920, overlay = { "8440-4920" }, displayID = 22185 }; --Sri'skulk
	[1531] = { zoneID = 18, artID = { 19 }, x = 4500, y = 3760, overlay = { "4500-3760","4860-3420","4900-3540","4920-3260","5320-4540","5320-4840" }, displayID = 985 }; --Lost Soul
	[1533] = { zoneID = 18, artID = { 19 }, x = 4380, y = 3140, overlay = { "4380-3140","4380-3380","4500-3160","4520-3560","4640-3040","4660-3160","4740-3260","4740-3500","4820-3360" }, displayID = 9534 }; --Tormented Spirit
	[1910] = { zoneID = 18, artID = { 19 }, x = 3590, y = 4281, overlay = { "3580-4300" }, displayID = 5243 }; --Muad
	[1911] = { zoneID = 18, artID = { 19 }, x = 7240, y = 2580, overlay = { "7240-2580" }, displayID = 5293 }; --Deeb
	[1936] = { zoneID = 18, artID = { 19 }, x = 3410, y = 5207, overlay = { "3420-5200","3720-4920","3800-5140" }, displayID = 3535 }; --Farmer Solliden
	[50763] = { zoneID = 18, artID = { 19 }, x = 3800, y = 5200, overlay = { "3800-5200" }, displayID = 67596 }; --Shadowstalker
	[50803] = { zoneID = 18, artID = { 19 }, x = 3259, y = 4640, overlay = { "3120-4640","3220-4720" }, displayID = 37992 }; --Bonechewer
	[50908] = { zoneID = 18, artID = { 19 }, x = 4280, y = 2840, overlay = { "4240-2840" }, displayID = 46667 }; --Nighthowl
	[50930] = { zoneID = 18, artID = { 19 }, x = 4759, y = 7019, overlay = { "4680-6920","4760-7020" }, displayID = 70192 }; --Hibernus the Sleeper
	[51044] = { zoneID = 18, artID = { 19 }, x = 5780, y = 3300, overlay = { "5780-3300" }, displayID = 46668 }; --Plague
	[12431] = { zoneID = 21, artID = { 22 }, x = 5633, y = 2375, overlay = { "5600-2300","5620-2520","5720-1600","5740-1740","5860-1500","6000-0900" }, displayID = 11413 }; --Gorefang
	[12433] = { zoneID = 21, artID = { 22 }, x = 3460, y = 1560, overlay = { "3460-1560","3460-1760","3540-1420","3620-1520","3660-1700","3800-1580","3840-1420" }, displayID = 22185 }; --Krethis the Shadowspinner
	[46981] = { zoneID = 21, artID = { 22 }, x = 5320, y = 2480, overlay = { "5120-2600","5180-2780","5240-2520","5240-2640","5300-2800" }, displayID = 915 }; --Nightlash
	[46992] = { zoneID = 21, artID = { 22 }, x = 4360, y = 5080, overlay = { "4320-5080" }, displayID = 35373 }; --Berard the Moon-Crazed
	[47003] = { zoneID = 21, artID = { 22 }, x = 4880, y = 2540, overlay = { "4840-2420","4880-2540" }, displayID = 35381 }; --Bolgaff <The Mad Hun>
	[47008] = { zoneID = 21, artID = { 22 }, x = 5940, y = 3380, overlay = { "5940-3340" }, displayID = 10834 }; --Fenwick Thatros
	[47009] = { zoneID = 21, artID = { 22 }, x = 6260, y = 6619, overlay = { "5700-6420","5740-6260","5820-6620","5900-6260","5980-6140","5980-6540","6080-6320","6120-6560","6120-6680","6180-6420","6260-6620" }, displayID = 35383 }; --Aquarius the Unbound
	[47012] = { zoneID = 21, artID = { 22 }, x = 4700, y = 6940, overlay = { "4680-6980" }, displayID = 26799 }; --Effritus
	[47015] = { zoneID = 21, artID = { 22 }, x = 5660, y = 3200, overlay = { "4560-3000","4640-2480","4640-2780","4680-2340","4840-2100","4840-2300","4840-3420","4940-3520","5020-2000","5280-1920","5400-4280","5420-4700","5420-5400","5440-2080","5440-6420","5460-4840","5460-5160","5500-2300","5500-3820","5500-4500","5500-7380","5520-3700","5520-7100","5520-7580","5540-3140","5560-6140","5580-3300","5580-4100","5620-2640","5620-2880","5620-3440","5620-7860","5660-3200" }, displayID = 563 }; --Lost Son of Arugal
	[47023] = { zoneID = 21, artID = { 22 }, x = 5020, y = 6000, overlay = { "5020-6000" }, displayID = 4430 }; --Thule Ravenclaw
	[50330] = { zoneID = 21, artID = { 22 }, x = 6160, y = 0640, overlay = { "6020-0680","6160-0640" }, displayID = 34130 }; --Kree
	[50814] = { zoneID = 21, artID = { 22 }, x = 4920, y = 6820, overlay = { "4920-6820" }, displayID = 23481 }; --Corpsefeeder
	[50949] = { zoneID = 21, artID = { 22 }, x = 6400, y = 4660, overlay = { "6400-4660" }, displayID = 4714 }; --Finn's Gambit
	[51026] = { zoneID = 21, artID = { 22 }, x = 5000, y = 2940, overlay = { "4920-2940" }, displayID = 46569 }; --Gnath
	[51037] = { zoneID = 21, artID = { 22 }, x = 6020, y = 4040, overlay = { "5720-4240","5840-4100","5960-4080" }, displayID = 33998 }; --Lost Gilnean Wardog
	[111122] = { zoneID = 22, artID = { 23 }, x = 6900, y = 4580, overlay = { "6900-4540" }, displayID = 40728 }; --Large Vile Slime
	[1837] = { zoneID = 22, artID = { 23 }, x = 6922, y = 4955, overlay = { "6900-4940" }, displayID = 10355 }; --Scarlet Judge
	[1838] = { zoneID = 22, artID = { 23 }, x = 4500, y = 5200, overlay = { "4500-5200" }, displayID = 10343 }; --Scarlet Interrogator
	[1839] = { zoneID = 22, artID = { 23 }, x = 4100, y = 5200, overlay = { "4100-5200","4160-5320" }, displayID = 10342 }; --Scarlet High Clerist
	[1841] = { zoneID = 22, artID = { 23 }, x = 5080, y = 4040, overlay = { "5080-4040" }, displayID = 10344 }; --Scarlet Executioner
	[1847] = { zoneID = 22, artID = { 23 }, x = 5400, y = 8040, overlay = { "5400-8040" }, displayID = 30656 }; --Foulmane
	[1848] = { zoneID = 22, artID = { 23 }, x = 6537, y = 4757, overlay = { "6540-4740" }, displayID = 10356 }; --Lord Maldazzar
	[1849] = { zoneID = 22, artID = { 23 }, x = 6380, y = 5640, overlay = { "6380-5640" }, displayID = 30520 }; --Dreadwhisper
	[1850] = { zoneID = 22, artID = { 23 }, x = 6940, y = 7300, overlay = { "6940-7300" }, displayID = 10612 }; --Putridius
	[1851] = { zoneID = 22, artID = { 23 }, x = 6300, y = 8280, overlay = { "6300-8280","6400-8360" }, displayID = 9013 }; --The Husk
	[1885] = { zoneID = 22, artID = { 23 }, x = 5388, y = 4408, overlay = { "5380-4420" }, displayID = 10346 }; --Scarlet Smith
	[50345] = { zoneID = 22, artID = { 23 }, x = 3259, y = 7219, overlay = { "3100-7180","3200-7300" }, displayID = 21133 }; --Alit
	[50778] = { zoneID = 22, artID = { 23 }, x = 5220, y = 6840, overlay = { "5120-7020","5220-6840" }, displayID = 42742 }; --Ironweb
	[50809] = { zoneID = 22, artID = { 23 }, x = 3579, y = 5259, overlay = { "3480-5240","3480-5380" }, displayID = 46740 }; --Heress
	[50906] = { zoneID = 22, artID = { 23 }, x = 5259, y = 2760, overlay = { "5220-2720" }, displayID = 37857 }; --Mutilax
	[50922] = { zoneID = 22, artID = { 23 }, x = 5820, y = 6140, overlay = { "5600-6260","5700-6180","5700-6340","5720-6060","5820-6140" }, displayID = 35394 }; --Warg
	[50931] = { zoneID = 22, artID = { 23 }, x = 6660, y = 5460, overlay = { "6600-5540" }, displayID = 70191 }; --Mange
	[50937] = { zoneID = 22, artID = { 23 }, x = 4360, y = 3600, overlay = { "4300-3440","4320-3560" }, displayID = 6122 }; --Hamhide
	[51029] = { zoneID = 22, artID = { 23 }, x = 6200, y = 7360, overlay = { "6140-7280" }, displayID = 23998 }; --Parasitus
	[51031] = { zoneID = 22, artID = { 23 }, x = 6260, y = 4720, overlay = { "6220-4760" }, displayID = 46741 }; --Tracker
	[51058] = { zoneID = 22, artID = { 23 }, x = 6260, y = 3540, overlay = { "6240-3520" }, displayID = 34900 }; --Aphis
	[100000] = { zoneID = 23, artID = { 24 }, x = 7560, y = 4900, overlay = { "7560-4900" }, friendly = { "A","H" }, displayID = 16066 }; --Johnny Awesomer
	[10817] = { zoneID = 23, artID = { 24 }, x = 3596, y = 6206, overlay = { "3580-6200" }, displayID = 10374 }; --Duggan Wildhammer
	[10818] = { zoneID = 23, artID = { 24 }, x = 6540, y = 2440, overlay = { "6540-2440" }, displayID = 6380 }; --Death Knight Soulbearer
	[10819] = { zoneID = 23, artID = { 24 }, x = 3570, y = 2149, overlay = { "3540-2120" }, displayID = 6380 }; --Baron Bloodbane
	[10820] = { zoneID = 23, artID = { 24 }, x = 2706, y = 1325, overlay = { "2640-1160","2700-1300","2780-1160" }, displayID = 6380 }; --Duke Ragereaver
	[10821] = { zoneID = 23, artID = { 24 }, x = 7900, y = 3900, overlay = { "7900-3900" }, displayID = 10709 }; --Hed'mush the Rotting
	[10823] = { zoneID = 23, artID = { 24 }, x = 6400, y = 1240, overlay = { "6400-1240" }, displayID = 10443 }; --Zul'Brin Warpbranch
	[10824] = { zoneID = 23, artID = { 24 }, x = 4733, y = 2133, overlay = { "4720-2140" }, displayID = 19824 }; --Death-Hunter Hawkspear
	[10825] = { zoneID = 23, artID = { 24 }, x = 2580, y = 6800, overlay = { "2580-6800" }, displayID = 7616 }; --Gish the Unmoving
	[10826] = { zoneID = 23, artID = { 24 }, x = 3693, y = 4411, overlay = { "3320-4740","3340-4880","3400-4620","3440-4480","3520-4720","3560-4860","3620-4340","3640-4720","3720-4540" }, displayID = 27984 }; --Lord Darkscythe
	[10827] = { zoneID = 23, artID = { 24 }, x = 1713, y = 7841, overlay = { "1700-7840","1800-7700","1880-7860" }, displayID = 37768 }; --Deathspeaker Selendre <Cult of the Dam>
	[10828] = { zoneID = 23, artID = { 24 }, x = 7740, y = 7219, overlay = { "7740-7220" }, displayID = 37769 }; --Lynnia Abbendis <The Fallen H>
	[16184] = { zoneID = 23, artID = { 24 }, x = 0420, y = 3600, overlay = { "0420-3600" }, displayID = 14698 }; --Nerubian Overseer
	[1843] = { zoneID = 23, artID = { 24 }, x = 5520, y = 6860, overlay = { "5520-6860" }, displayID = 37598 }; --Foreman Jerris
	[1844] = { zoneID = 23, artID = { 24 }, x = 5380, y = 6840, overlay = { "5380-6840" }, displayID = 37600 }; --Foreman Marcrid
	[50775] = { zoneID = 23, artID = { 24 }, x = 1300, y = 7140, overlay = { "1160-7020","1220-7160" }, displayID = 46518 }; --Likk the Hunter
	[50779] = { zoneID = 23, artID = { 24 }, x = 3940, y = 5560, overlay = { "3940-5560" }, displayID = 18029 }; --Sporeggon
	[50813] = { zoneID = 23, artID = { 24 }, x = 4935, y = 4424, overlay = { "4960-4320" }, displayID = 46516 }; --Fene-mal
	[50856] = { zoneID = 23, artID = { 24 }, x = 3960, y = 8459, overlay = { "3780-8400","3920-8400" }, displayID = 31352 }; --Snark
	[50915] = { zoneID = 23, artID = { 24 }, x = 5760, y = 7980, overlay = { "5740-8000" }, displayID = 46520 }; --Snort
	[50947] = { zoneID = 23, artID = { 24 }, x = 1160, y = 2800, overlay = { "1140-2820" }, displayID = 46532 }; --Varah
	[51027] = { zoneID = 23, artID = { 24 }, x = 7460, y = 5880, overlay = { "7420-5840" }, displayID = 46534 }; --Spirocula
	[51042] = { zoneID = 23, artID = { 24 }, x = 7180, y = 4580, overlay = { "7180-4540" }, displayID = 46517 }; --Bleakheart
	[51053] = { zoneID = 23, artID = { 24 }, x = 2379, y = 7860, overlay = { "2360-7840" }, displayID = 37580 }; --Quirix
	[14221] = { zoneID = 25, artID = { 26 }, x = 5540, y = 2379, overlay = { "5540-2380","5620-2500","5660-2360","5740-2500" }, displayID = 3729 }; --Gravis Slipknot
	[14222] = { zoneID = 25, artID = { 26 }, x = 4420, y = 5400, overlay = { "4420-5400" }, displayID = 37735 }; --Araga
	[14223] = { zoneID = 25, artID = { 26 }, x = 5660, y = 6160, overlay = { "5660-6160","5740-6000","5920-5860","6020-5700","6040-5520","6060-4740","6080-5080","6080-5200","6080-5400","6120-4540","6140-4160","6140-4300","6220-4040","6280-3920","6400-3860","6460-3720","6540-3600","6720-3480","6840-3060","6860-3260" }, displayID = 21240 }; --Cranky Benj
	[14275] = { zoneID = 25, artID = { 26 }, x = 6320, y = 8580, overlay = { "6320-8580" }, friendly = { "A" }, displayID = 37740 }; --Tamra Stormpike
	[14276] = { zoneID = 25, artID = { 26 }, x = 3220, y = 7940, overlay = { "3220-7940" }, displayID = 5243 }; --Scargil
	[14277] = { zoneID = 25, artID = { 26 }, x = 5440, y = 7640, overlay = { "5440-7660" }, displayID = 11260 }; --Lady Zephris
	[14278] = { zoneID = 25, artID = { 26 }, x = 5700, y = 7460, overlay = { "5700-7460","5740-7320","5740-7620","5800-7200","5840-7500","5920-7320" }, displayID = 34276 }; --Ro'Bark
	[14279] = { zoneID = 25, artID = { 26 }, x = 4340, y = 7520, overlay = { "4340-7520" }, displayID = 37738 }; --Creepthess
	[14280] = { zoneID = 25, artID = { 26 }, x = 6340, y = 5259, overlay = { "6340-5260" }, displayID = 70189 }; --Big Samras
	[14281] = { zoneID = 25, artID = { 26 }, x = 4980, y = 5020, overlay = { "4980-5020" }, displayID = 3616 }; --Jimmy the Bleeder
	[2258] = { zoneID = 25, artID = { 26 }, x = 6020, y = 2880, overlay = { "6020-2880" }, displayID = 36325 }; --Maggarrak <The Mountain L>
	[2452] = { zoneID = 25, artID = { 26 }, x = 4340, y = 3780, overlay = { "4340-3780" }, displayID = 7336 }; --Skhowl
	[2453] = { zoneID = 25, artID = { 26 }, x = 4940, y = 1840, overlay = { "4940-1840" }, displayID = 32547 }; --Lo'Grosh
	[47010] = { zoneID = 25, artID = { 26 }, x = 3160, y = 4000, overlay = { "3140-3980" }, displayID = 9995 }; --Indigos
	[50335] = { zoneID = 25, artID = { 26 }, x = 4740, y = 6820, overlay = { "4600-6620","4740-6820" }, displayID = 26255 }; --Alitus
	[50765] = { zoneID = 25, artID = { 26 }, x = 3700, y = 6820, overlay = { "3700-6820" }, displayID = 27683 }; --Miasmiss
	[50818] = { zoneID = 25, artID = { 26 }, x = 3300, y = 5500, overlay = { "3300-5500" }, displayID = 26618 }; --The Dark Prowler
	[50858] = { zoneID = 25, artID = { 26 }, x = 2860, y = 8380, overlay = { "2780-8360" }, displayID = 46551 }; --Dustwing
	[50929] = { zoneID = 25, artID = { 26 }, x = 3500, y = 7840, overlay = { "3460-7880" }, displayID = 46552 }; --Little Bjorn
	[50955] = { zoneID = 25, artID = { 26 }, x = 4680, y = 7600, overlay = { "4660-7660" }, displayID = 46558 }; --Carcinak
	[50967] = { zoneID = 25, artID = { 26 }, x = 5180, y = 8720, overlay = { "5180-8680" }, displayID = 32807 }; --Craw the Ravager
	[51022] = { zoneID = 25, artID = { 26 }, x = 5680, y = 5480, overlay = { "5620-5440" }, displayID = 37540 }; --Chordix
	[51057] = { zoneID = 25, artID = { 26 }, x = 4559, y = 5380, overlay = { "4540-5240","4560-5380" }, displayID = 34898 }; --Weevil
	[51076] = { zoneID = 25, artID = { 26 }, x = 6880, y = 5600, overlay = { "6880-5600" }, displayID = 40191 }; --Lopex
	[107617] = { zoneID = 26, artID = { 27 }, x = 7680, y = 4980, overlay = { "4260-6180","4280-5940","4300-6380","4400-5520","4400-5960","4440-6460","4460-5360","4700-5620","4880-5920","4920-5720","5100-5560","5120-5380","5120-5900","5240-5100","5420-4540","5600-4600","5800-4660","5820-5320","5900-4880","6100-5040","6200-5400","6260-4760","6280-4500","6320-5420","6340-4240","6420-4120","6480-5720","6540-5840","6780-4700","6780-5740","6940-5060","7160-5020","7180-5180","7280-4920","7400-5460","7580-5180","7680-4980" }, displayID = 70190 }; --Ol' Muddle
	[8210] = { zoneID = 26, artID = { 27 }, x = 6600, y = 5300, overlay = { "6600-5300" }, displayID = 37771 }; --Razortalon
	[8211] = { zoneID = 26, artID = { 27 }, x = 1320, y = 5380, overlay = { "1320-5380" }, displayID = 11414 }; --Old Cliff Jumper
	[8212] = { zoneID = 26, artID = { 27 }, x = 5740, y = 4300, overlay = { "5740-4300" }, displayID = 37772 }; --The Reak
	[8213] = { zoneID = 26, artID = { 27 }, x = 7940, y = 5660, overlay = { "7940-5660","8020-5820","8060-5620" }, displayID = 37770 }; --Ironback
	[8214] = { zoneID = 26, artID = { 27 }, x = 3440, y = 5500, overlay = { "3440-5500" }, friendly = { "A" }, displayID = 19816 }; --Jalinde Summerdrake
	[8215] = { zoneID = 26, artID = { 27 }, x = 7140, y = 6100, overlay = { "7140-6100","7160-6260","7200-5980","7260-5860","7280-5700","7380-5580","7460-5260","7480-5420","7500-5540","7600-5440","7620-5260","7660-5560","7740-5020","7860-5080" }, displayID = 12816 }; --Grimungous
	[8216] = { zoneID = 26, artID = { 27 }, x = 4740, y = 6640, overlay = { "4740-6640","4820-6740" }, displayID = 28248 }; --Retherokk the Berserker
	[8217] = { zoneID = 26, artID = { 27 }, x = 6480, y = 8140, overlay = { "6480-8140" }, displayID = 28256 }; --Mith'rethis the Enchanter
	[8218] = { zoneID = 26, artID = { 27 }, x = 3940, y = 6619, overlay = { "3940-6620" }, displayID = 28230 }; --Witherheart the Stalker
	[8219] = { zoneID = 26, artID = { 27 }, x = 2460, y = 6540, overlay = { "2460-6540" }, displayID = 28230 }; --Zul'arek Hatefowler
	[107431] = { zoneID = {
				[27] = { x = 4407, y = 3410, artID = { 28 }, overlay = { "4407-3410" } };
				[469] = { x = 6613, y = 2712, artID = { 481 }, overlay = { "6220-2780","6440-2820","6460-2520","6540-2920","6600-2560","6640-2700","6700-2860","6740-3060" } };
			  }, displayID = 68291 }; --null
	[1130] = { zoneID = 27, artID = { 28 }, x = 6768, y = 5899, overlay = { "6620-5980","6720-5800","6920-5580","6980-5860" }, displayID = 70185 }; --Bjarn
	[1132] = { zoneID = {
				[27] = { x = 4440, y = 3726, artID = { 28 }, overlay = { "4440-3726" } };
				[469] = { x = 6434, y = 2751, artID = { 481 }, overlay = { "6600-3360","6600-3720","6720-3560","6740-3400","6780-3740","6900-3440","6960-3800","6434-2751" } };
			  }, displayID = 10278 }; --null
	[1260] = { zoneID = {
				[27] = { x = 2940, y = 4980, artID = { 28 }, overlay = { "2940-4980","4880-3780" } };
				[469] = { x = 2920, y = 6800, artID = { 481 }, overlay = { "2920-6800","2960-6600","3060-6420" } };
			  }, displayID = 27504 }; --null
	[8503] = { zoneID = {
				[27] = { x = 3419, y = 4082, artID = { 28 }, overlay = { "3419-4082" } };
				[469] = { x = 4020, y = 4420, artID = { 481 }, overlay = { "4020-4420","4040-4620" } };
			  }, displayID = 7807 }; --null
	[1137] = { zoneID = 29, artID = { 31 }, x = 3180, y = 4400, overlay = { "3180-4400","3220-4920","3380-5220","3400-4880","3460-4520","3520-4960","3560-5360","3800-5100","3920-4660" }, displayID = 13990 }; --Edan the Howler
	[1119] = { zoneID = 31, artID = { 30 }, x = 5240, y = 3220, overlay = { "5240-3220","5540-3640","5620-3840","5620-3980","5660-3720" }, displayID = 11165 }; --Hammerspine
	[50846] = { zoneID = 32, artID = { 33 }, x = 5900, y = 2540, overlay = { "5700-2560","5720-2380","5820-2240","5900-2540" }, displayID = 5240 }; --Slavermaw
	[50876] = { zoneID = 32, artID = { 33 }, x = 7159, y = 1920, overlay = { "7060-1860","7140-1680" }, displayID = 1746 }; --Avis
	[50946] = { zoneID = 32, artID = { 33 }, x = 2220, y = 7780, overlay = { "2120-7880","2220-7780" }, displayID = 2450 }; --Hogzilla
	[50948] = { zoneID = 32, artID = { 33 }, x = 6700, y = 4520, overlay = { "6440-4620","6520-4500","6580-4760","6600-4620","6640-4440" }, displayID = 46566 }; --Crystalback
	[51002] = { zoneID = 32, artID = { 33 }, x = 1840, y = 3879, overlay = { "1780-3840" }, displayID = 15336 }; --Scorpoxx
	[51010] = { zoneID = 32, artID = { 33 }, x = 3620, y = 5300, overlay = { "3500-5200","3620-5300" }, displayID = 46248 }; --Snips
	[51048] = { zoneID = 32, artID = { 33 }, x = 4280, y = 4720, overlay = { "3940-5060","3980-5300","4040-4940","4140-5060","4280-4720" }, displayID = 35356 }; --Rexxus
	[8277] = { zoneID = 32, artID = { 33 }, x = 2920, y = 6780, overlay = { "2920-6780","3020-6860","3040-7020","3040-7180","3160-7200","3180-7320" }, displayID = 37685 }; --Rekk'tilac
	[8278] = { zoneID = 32, artID = { 33 }, x = 4800, y = 3840, overlay = { "4800-3840","4920-3700","4920-3940" }, displayID = 33498 }; --Smoldar
	[8279] = { zoneID = 32, artID = { 33 }, x = 5800, y = 5640, overlay = { "5800-5640","6200-6100","6220-5960","6300-6300" }, displayID = 10800 }; --Faulty War Golem
	[8280] = { zoneID = 32, artID = { 33 }, x = 5579, y = 4520, overlay = { "5580-4520","5660-4660","5720-4480","5740-4340","5840-4440" }, displayID = 2346 }; --Shleipnarr
	[8281] = { zoneID = 32, artID = { 33 }, x = 4020, y = 5859, overlay = { "4020-5860","4040-5740" }, displayID = 12231 }; --Scald
	[8282] = { zoneID = 32, artID = { 33 }, x = 2940, y = 2540, overlay = { "2940-2540","3100-2640" }, displayID = 7835 }; --Highlord Mastrogonde
	[8283] = { zoneID = 32, artID = { 33 }, x = 3740, y = 4420, overlay = { "3740-4420" }, displayID = 7819 }; --Slave Master Blackheart
	[50839] = { zoneID = {
				[33] = { x = 6200, y = 4479, artID = { 34 }, overlay = { "3560-6080","3600-4960","3720-6600","3820-4460","3880-4260","4040-4020","4080-7320","4240-7480","4300-7600","4360-3600","4440-7660","4460-3760","4460-7500","4500-3600","4640-3500","4640-7880","4680-7760","4740-3600","4800-7860","4880-3500","5000-3520","5060-7860","5440-3580","5460-7620","5620-7600","5700-3640","5780-3800","5960-4140","6100-4340","6200-4480" } };
				[36] = { x = 2400, y = 3040, artID = { 37 }, overlay = { "1780-3160","1840-2540","1880-3300","1940-2440","2020-3380","2080-2400","2220-3340","2280-2540","2400-3040" } };
			  }, displayID = 29539 }; --null
	[51066] = { zoneID = 35, artID = { 36 }, x = 3400, y = 2000, overlay = { "3320-1900","3400-2000" }, displayID = 33863 }; --Crystalfang
	[8924] = { zoneID = 35, artID = { 36 }, x = 4013, y = 6061, overlay = { "4013-6061" }, displayID = 8390 }; --The Behemoth
	[10077] = { zoneID = 36, artID = { 37 }, x = 6280, y = 3140, overlay = { "6280-3140","6340-3260","6740-5460","6960-5560","7020-5680","7060-3120","7080-2980","7220-5900","7300-5160" }, displayID = 37671 }; --Deathmaw
	[10078] = { zoneID = 36, artID = { 37 }, x = 5620, y = 3300, overlay = { "5620-3300","5700-3140","5700-3460","5780-3320","6000-3020" }, displayID = 37683 }; --Terrorspark
	[10119] = { zoneID = 36, artID = { 37 }, x = 1880, y = 4340, overlay = { "1880-4340","1940-4120","2120-4140","2260-4180" }, displayID = 12232 }; --Volchan
	[50357] = { zoneID = 36, artID = { 37 }, x = 0980, y = 5440, overlay = { "0840-5460","0940-5240","0960-5500" }, displayID = 45201 }; --Sunwing
	[50361] = { zoneID = 36, artID = { 37 }, x = 5060, y = 6060, overlay = { "5040-6020" }, displayID = 20596 }; --Ornat
	[50725] = { zoneID = 36, artID = { 37 }, x = 7280, y = 2260, overlay = { "7180-2300" }, displayID = 20309 }; --Azelisk
	[50730] = { zoneID = 36, artID = { 37 }, x = 0580, y = 3820, overlay = { "0520-3860" }, displayID = 20297 }; --Venomspine
	[50792] = { zoneID = 36, artID = { 37 }, x = 3540, y = 2680, overlay = { "3520-2620" }, displayID = 46278 }; --Chiaa
	[50807] = { zoneID = 36, artID = { 37 }, x = 6500, y = 5380, overlay = { "6360-5420","6400-5200","6460-5320" }, displayID = 46277 }; --Catal
	[50810] = { zoneID = 36, artID = { 37 }, x = 7560, y = 5340, overlay = { "7320-5300","7420-5200","7500-5320","7540-5180" }, displayID = 20347 }; --Favored of Isiset
	[50842] = { zoneID = 36, artID = { 37 }, x = 2920, y = 3140, overlay = { "2840-3300","2900-3480","2920-3140" }, displayID = 12168 }; --Magmagan
	[50855] = { zoneID = 36, artID = { 37 }, x = 4700, y = 2420, overlay = { "4700-2420" }, displayID = 79025 }; --Jaxx the Rabid
	[8976] = { zoneID = 36, artID = { 37 }, x = 2770, y = 5921, overlay = { "2640-5820","2740-5900" }, displayID = 6369 }; --Hematos
	[8978] = { zoneID = 36, artID = { 37 }, x = 4380, y = 3980, overlay = { "4380-3980" }, displayID = 11511 }; --Thauris Balgarr
	[8979] = { zoneID = 36, artID = { 37 }, x = 3340, y = 3680, overlay = { "3340-3680","3480-3660" }, friendly = { "H" }, displayID = 11510 }; --Gruklash
	[8981] = { zoneID = 36, artID = { 37 }, x = 5100, y = 3640, overlay = { "5100-3640","5260-3840","5340-3600","5500-4360" }, displayID = 23822 }; --Malfunctioning Reaver
	[9602] = { zoneID = 36, artID = { 37 }, x = 6840, y = 4040, overlay = { "6840-4040" }, displayID = 11564 }; --Hahk'Zor
	[9604] = { zoneID = 36, artID = { 37 }, x = 6340, y = 4740, overlay = { "6340-4740","6440-4660" }, displayID = 11562 }; --Gorgon'och
	[100] = { zoneID = 37, artID = { 41 }, x = 2760, y = 8880, overlay = { "2520-9320","2540-9100","2640-8920","2640-9340","2680-8680","2680-9080","2740-8840","2880-8820" }, displayID = 603 }; --Gruff Swiftbite
	[471] = { zoneID = {
				[37] = { x = 6192, y = 4783, artID = { 41 }, overlay = { "6192-4783" } };
				[40] = { x = 3940, y = 2120, artID = { 42 }, overlay = { "3940-2120","4040-2000","4700-2400","5140-3020","5240-2860","5400-3320" } };
			  }, displayID = 36505 }; --null
	[472] = { zoneID = 37, artID = { 41 }, x = 6794, y = 3952, overlay = { "6640-4040","6680-4160","6700-3920","6780-4700","6800-4440","6920-3860","7020-4000" }, displayID = 543 }; --Fedfennel
	[50752] = { zoneID = 37, artID = { 41 }, x = 6760, y = 6320, overlay = { "6520-6460","6640-6300","6760-6320" }, displayID = 2537 }; --Tarantis
	[50916] = { zoneID = 37, artID = { 41 }, x = 5259, y = 6320, overlay = { "5140-6240","5140-6360","5260-6320" }, displayID = 46543 }; --Lamepaw the Whimperer
	[50926] = { zoneID = 37, artID = { 41 }, x = 2860, y = 6660, overlay = { "2740-6740","2740-6920","2860-6660" }, displayID = 70199 }; --Grizzled Ben
	[50942] = { zoneID = 37, artID = { 41 }, x = 7060, y = 7980, overlay = { "6780-8220","6920-7700","6920-7820","6940-7960","7060-7980" }, displayID = 1208 }; --Snoot the Rooter
	[51014] = { zoneID = {
				[37] = { x = 7400, y = 8480, artID = { 41 }, overlay = { "5060-8720","5340-8780","5520-8660","5620-8540","5840-8380","5960-8300","6080-8240","6260-8240","6340-8340","6600-8440","6740-8440","6860-8460","7020-8540","7200-8440","7300-8520" } };
				[47] = { x = 6100, y = 1260, artID = { 52 }, overlay = { "4940-1080","6100-1220" } };
			  }, displayID = 7837 }; --null
	[51077] = { zoneID = 37, artID = { 41 }, x = 8380, y = 8500, overlay = { "8160-8520","8240-8400","8300-8280","8300-8580" }, displayID = 30254 }; --Bushtail
	[61] = { zoneID = 37, artID = { 41 }, x = 5063, y = 8308, overlay = { "4920-8200","5040-8320","5040-8440","5060-8160" }, displayID = 3341 }; --Thuros Lightfingers
	[62] = { zoneID = {
				[37] = { x = 4763, y = 3182, artID = { 41 }, overlay = { "4763-3182" } };
				[425] = { x = 3140, y = 1700, artID = { 437 }, overlay = { "3140-1700" } };
			  }, displayID = 511 }; --null
	[79] = { zoneID = 37, artID = { 41 }, x = 3720, y = 8340, overlay = { "3720-8340","3800-8140","3840-8340" }, displayID = 774 }; --Narg the Taskmaster
	[99] = { zoneID = 37, artID = { 41 }, x = 3080, y = 6500, overlay = { "3080-6500" }, displayID = 3320 }; --Morgaine the Sly
	[116034] = { zoneID = 47, artID = { 52 }, x = 4960, y = 7560, overlay = { "4900-7540","4920-7680" }, displayID = 74030 }; --The Cow King
	[118244] = { zoneID = 47, artID = { 52 }, x = 1669, y = 5444, overlay = { "1669-5444","2300-2900","1600-6000","2431-3969","2358-7666","3023-4171" }, displayID = 74736 }; --Lightning Paw
	[45739] = { zoneID = 47, artID = { 52 }, x = 9059, y = 3060, overlay = { "8940-3060","9060-3040" }, displayID = 34648 }; --The Unknown Soldier
	[45740] = { zoneID = 47, artID = { 52 }, x = 8180, y = 5920, overlay = { "7940-6960","7940-7080","7960-6740","8060-6940","8080-6240","8080-6540","8080-6820","8120-5960" }, displayID = 34649 }; --Watcher Eva <The Restless D>
	[45771] = { zoneID = 47, artID = { 52 }, x = 6519, y = 7040, overlay = { "5800-7720","5860-8000","6040-7560","6120-7300","6140-7040","6140-7180","6200-7460","6300-7300","6320-6820","6320-8340","6360-7000","6500-6860","6520-7040" }, displayID = 34669 }; --Marus <The Pack Lea>
	[45785] = { zoneID = 47, artID = { 52 }, x = 5120, y = 7480, overlay = { "4680-7440","4720-7220","4740-7080","4780-7640","4820-7400","4860-7100","4940-7560","4960-7200","5020-7400","5040-7000","5080-7180","5120-7480" }, displayID = 34671 }; --Carved One
	[45801] = { zoneID = 47, artID = { 52 }, x = 2760, y = 3360, overlay = { "2700-3100","2740-3260" }, displayID = 34682 }; --Eliza <Bride of the Embal>
	[45811] = { zoneID = 47, artID = { 52 }, x = 0800, y = 3660, overlay = { "0740-3280","0740-3540","0780-3420","0800-3660" }, displayID = 4277 }; --Marina DeSirrus <Thief of the D>
	[507] = { zoneID = 47, artID = { 52 }, x = 5900, y = 3000, overlay = { "5900-3000","6120-4000","6140-4160","6240-4340","6320-4180","6380-4500","6380-4880","6400-5120" }, displayID = 34650 }; --Fenros
	[521] = { zoneID = 47, artID = { 52 }, x = 5954, y = 1956, overlay = { "5880-1860","5900-2000","5980-2100","6020-1880","6020-2280","6380-1940","6440-2180","6480-2060","6520-1820","6540-1940","6600-2160","6660-1900","6900-2420","6920-2560","6940-2280","7040-2560","7080-2220","7080-2380" }, displayID = 10278 }; --Lupos
	[534] = { zoneID = 47, artID = { 52 }, x = 7400, y = 7860, overlay = { "7400-7860" }, displayID = 34651 }; --Nefaru <The Den Mot>
	[574] = { zoneID = 47, artID = { 52 }, x = 8640, y = 4800, overlay = { "8640-4800" }, displayID = 963 }; --Naraxis
	[1398] = { zoneID = 48, artID = { 53 }, x = 6680, y = 6900, overlay = { "6680-6900","6800-6600","6880-6840","6900-5960","6920-6660","7000-6060","7000-6240","7040-6360","7040-6760","7060-6540","7120-6060" }, displayID = 5945 }; --Boss Galgosh <Stonesplinter Chieft>
	[1399] = { zoneID = 48, artID = { 53 }, x = 3080, y = 7500, overlay = { "3080-7500" }, displayID = 6528 }; --Magosh <Stonesplinter Tribal Sha>
	[1425] = { zoneID = 48, artID = { 53 }, x = 2440, y = 3000, overlay = { "2440-3000","2480-2800","2560-2940","2560-3080","2600-2700" }, displayID = 774 }; --Kubb <Master of Meats and Fis>
	[14266] = { zoneID = 48, artID = { 53 }, x = 6140, y = 7340, overlay = { "6140-7340","6160-7460" }, displayID = 34437 }; --Shanda the Spinner
	[14267] = { zoneID = 48, artID = { 53 }, x = 6600, y = 2140, overlay = { "6600-2140","6720-2220","6800-2720","6820-2140","6840-2380","6840-2900","6860-2580","6940-2700","6980-2240","6980-2580","7000-2360","7100-2000","7120-2280","7120-2420","7240-2180","7240-2540" }, displayID = 25191 }; --Emogg the Crusher
	[14268] = { zoneID = 48, artID = { 53 }, x = 6619, y = 7119, overlay = { "6620-7120","6620-7320","6740-7600","6880-7500","6900-7380","7080-7340","7080-7500","7100-7220","7200-7100","7220-7240","7360-7120","7420-6580","7420-6860","7440-6300","7440-7000","7480-6720","7480-7360","7500-7120","7580-6300","7600-7380","7720-7340","7780-6460","7800-6760","7800-7020","7800-7600","7820-6880","7820-7180","7820-7460","7900-6300","7920-6600" }, displayID = 25868 }; --Lord Condar
	[2476] = { zoneID = 48, artID = { 53 }, x = 5280, y = 5780, overlay = { "5280-5780","5300-5580","5360-5420","5400-5660","5520-5420","5540-5300","5560-5580","5640-5180" }, displayID = 32813 }; --Gosh-Haldir <The Clutch Mot>
	[45369] = { zoneID = 48, artID = { 53 }, x = 4080, y = 6260, overlay = { "3740-6220","3880-6200","4000-6120","4040-6500","4080-6240" }, displayID = 3452 }; --Morick Darkbrew <Dark Iron Cour>
	[45380] = { zoneID = 48, artID = { 53 }, x = 7759, y = 4159, overlay = { "6660-4000","6760-4280","6840-3780","6880-3600","6960-4200","7000-3740","7040-3560","7100-4280","7220-3700","7240-4220","7300-3540","7300-4340","7320-4460","7380-3640","7400-3400","7460-4380","7520-4260","7620-4380","7640-3840","7640-4240","7660-3500","7700-3680","7760-4160" }, displayID = 30239 }; --Ashtail
	[45384] = { zoneID = 48, artID = { 53 }, x = 2560, y = 4479, overlay = { "2540-4320","2560-4480" }, displayID = 10796 }; --Sagepaw <Mosshide Chieft>
	[45398] = { zoneID = 48, artID = { 53 }, x = 3559, y = 1560, overlay = { "3540-1540" }, displayID = 27195 }; --Grizlak <Associate Troggwhac>
	[45399] = { zoneID = 48, artID = { 53 }, x = 7800, y = 7780, overlay = { "7140-7640","7220-7800","7340-7800","7480-7640","7520-7860","7620-8040","7640-8180","7700-8320","7740-8000","7760-7880","7800-7700" }, displayID = 10664 }; --Optimo
	[45401] = { zoneID = 48, artID = { 53 }, x = 4960, y = 5700, overlay = { "4180-4400","4220-4660","4240-4160","4260-4800","4280-4320","4280-4540","4340-4040","4360-4880","4400-3900","4440-5140","4460-4960","4480-3800","4480-5260","4500-5380","4520-4740","4560-5160","4600-5480","4720-5100","4740-5540","4820-5640","4920-5760" }, displayID = 5286 }; --Whitefin
	[45402] = { zoneID = 48, artID = { 53 }, x = 5940, y = 4060, overlay = { "5040-3780","5080-3600","5120-4060","5220-3600","5220-4160","5240-3480","5380-3520","5380-4100","5380-4320","5540-3460","5540-3580","5540-4020","5540-4200","5580-3900","5600-3700","5680-3820","5680-4160","5720-3420","5740-3580","5740-4000","5760-4260","5840-3860","5880-3980","5880-4160" }, displayID = 18723 }; --Nix
	[45404] = { zoneID = 48, artID = { 53 }, x = 5000, y = 2400, overlay = { "5000-2400" }, displayID = 34187 }; --Geoshaper Maren
	[14269] = { zoneID = 49, artID = { 54 }, x = 6980, y = 5520, overlay = { "6980-5520","7020-5380","7100-5500","7160-5660" }, displayID = 5564 }; --Seeker Aqualon
	[14270] = { zoneID = 49, artID = { 54 }, x = 3620, y = 4260, overlay = { "3620-4260","3680-4140","3740-4260" }, displayID = 5243 }; --Squiddic
	[14271] = { zoneID = 49, artID = { 54 }, x = 2780, y = 6160, overlay = { "2780-6160","2880-5960","2940-6100","2940-6320","3000-5760","3060-6260","3080-6140" }, displayID = 37621 }; --Ribchaser
	[14272] = { zoneID = 49, artID = { 54 }, x = 3400, y = 5700, overlay = { "3400-5700","3440-6000","3540-6160","3560-6040" }, displayID = 6378 }; --Snarlflare
	[14273] = { zoneID = 49, artID = { 54 }, x = 5640, y = 5140, overlay = { "5640-5140" }, displayID = 5229 }; --Boulderheart
	[147222] = { zoneID = 49, artID = { 54 }, x = 2435, y = 7096, overlay = { "2440-7040" }, displayID = 8014 }; --Gnollfeaster
	[52146] = { zoneID = 49, artID = { 54 }, x = 6419, y = 6440, overlay = { "6320-6660","6340-6520" }, displayID = 909 }; --Chitter
	[584] = { zoneID = 49, artID = { 54 }, x = 3340, y = 1020, overlay = { "3340-1020","3420-1200" }, displayID = 6041 }; --Kazon
	[616] = { zoneID = 49, artID = { 54 }, x = 3640, y = 3380, overlay = { "3640-3380","3680-3620","3780-3440","3820-3580" }, displayID = 37620 }; --Chatter
	[947] = { zoneID = 49, artID = { 54 }, x = 6660, y = 3600, overlay = { "6660-3600","6800-3540" }, displayID = 37623 }; --Rohh the Silent
	[11383] = { zoneID = 50, artID = { 55 }, x = 6700, y = 3160, overlay = { "6700-3160","6700-3400" }, displayID = 11295 }; --High Priestess Hai'watna
	[14487] = { zoneID = 50, artID = { 55 }, x = 4362, y = 4336, overlay = { "4000-3880","4120-3960","4200-4120","4200-4240","4320-4100","4320-4340" }, displayID = 22530 }; --Gluggl
	[14488] = { zoneID = 50, artID = { 55 }, x = 4479, y = 5320, overlay = { "4480-5320","4520-5440","4540-5100","4540-5560","4580-4680","4580-4820","4600-4500","4640-5420","4680-5580","4720-4560" }, displayID = 37382 }; --Roloch
	[51658] = { zoneID = 50, artID = { 55 }, x = 6280, y = 7460, overlay = { "6220-7300","6240-7420" }, displayID = 37596 }; --Mogh the Dead <Skullsplitter Clan Witchdoc>
	[51661] = { zoneID = 50, artID = { 55 }, x = 4759, y = 3320, overlay = { "4700-3200","4760-3320" }, displayID = 10133 }; --Tsul'Kalu <The Earth Spi>
	[51662] = { zoneID = 50, artID = { 55 }, x = 5500, y = 3060, overlay = { "5340-3020","5420-3160","5440-2920","5500-3060" }, displayID = 37613 }; --Mahamba <The Water Spi>
	[51663] = { zoneID = 50, artID = { 55 }, x = 3700, y = 2979, overlay = { "3620-2920" }, displayID = 37615 }; --Pogeyan <The Fire Spi>
	[1063] = { zoneID = 51, artID = { 56 }, x = 3000, y = 4540, overlay = { "3000-4540","3000-4800","3080-4680","3220-4640" }, displayID = 7975 }; --Jade <Victim of the Nightm>
	[1106] = { zoneID = 51, artID = { 56 }, x = 6160, y = 2760, overlay = { "6160-2760","6240-2520","6240-2640","6300-2760","6360-2620" }, displayID = 18349 }; --Lost One Cook
	[14445] = { zoneID = 51, artID = { 56 }, x = 7380, y = 4440, overlay = { "7380-4440","7500-4540" }, displayID = 7976 }; --Captain Wyrmak <Victim of the Nightm>
	[14446] = { zoneID = 51, artID = { 56 }, x = 7700, y = 8480, overlay = { "7700-8480","7720-8200","7760-8360","7840-8580" }, displayID = 5286 }; --Fingat
	[14447] = { zoneID = 51, artID = { 56 }, x = 8900, y = 6820, overlay = { "8900-6820","8920-6660","8960-6540","9020-6760" }, displayID = 37634 }; --Gilmorian
	[14448] = { zoneID = 51, artID = { 56 }, x = 4820, y = 4080, overlay = { "4820-4080","4920-4260","4980-4140" }, displayID = 14497 }; --Molt Thorn
	[50738] = { zoneID = 51, artID = { 56 }, x = 5780, y = 5240, overlay = { "5540-5460","5580-5260","5660-5460","5720-5200" }, displayID = 25009 }; --Shimmerscale
	[50790] = { zoneID = 51, artID = { 56 }, x = 4080, y = 3579, overlay = { "3900-3400","3980-3300","3980-3520" }, displayID = 47120 }; --Ionis
	[50797] = { zoneID = 51, artID = { 56 }, x = 7080, y = 6500, overlay = { "6920-6640","6940-6780","7040-6480","7060-6620" }, displayID = 47126 }; --Yukiko
	[50837] = { zoneID = 51, artID = { 56 }, x = 8020, y = 2960, overlay = { "7820-2720","7820-2960","7940-2680","7940-2980","7960-2820" }, displayID = 46575 }; --Kash
	[50882] = { zoneID = 51, artID = { 56 }, x = 2780, y = 6360, overlay = { "2700-6100","2740-6300" }, displayID = 19743 }; --Chupacabros
	[50886] = { zoneID = 51, artID = { 56 }, x = 9059, y = 3920, overlay = { "8020-1620","8180-1700","8500-2420","8540-2220","8720-2460","8760-3040","8800-2660","8880-3120","8880-3300","8900-2880","8940-2720","8940-3580","9040-3680","9040-3880" }, displayID = 21268 }; --Seawing
	[50903] = { zoneID = 51, artID = { 56 }, x = 1860, y = 3820, overlay = { "1600-3600","1720-3860","1740-3720","1860-3540","1860-3820" }, displayID = 37856 }; --Orlix the Swamplord
	[51052] = { zoneID = 51, artID = { 56 }, x = 1779, y = 4800, overlay = { "1640-4720","1760-4720" }, displayID = 46574 }; --Gib the Banana-Hoarder
	[5348] = { zoneID = 51, artID = { 56 }, x = 1800, y = 6980, overlay = { "1800-6980" }, displayID = 625 }; --Dreamwatcher Forktongue <Victim of the Nightm>
	[763] = { zoneID = 51, artID = { 56 }, x = 5959, y = 2640, overlay = { "5960-2640","6120-2560","6140-2340","6140-2760","6280-2480","6380-1900","6380-2360","6460-2260","6560-2340" }, displayID = 18620 }; --Lost One Chieftain
	[1424] = { zoneID = 52, artID = { 57 }, x = 4600, y = 1840, overlay = { "4600-1840" }, displayID = 774 }; --Master Digger
	[462] = { zoneID = 52, artID = { 57 }, x = 4840, y = 3300, overlay = { "4840-3300","4900-2800","4900-3520","4940-2640","4980-3240","5020-2820","5420-2420","5440-2580","5520-3500","5540-2360","5620-3340","5640-2080","5640-3520","5720-1940","5780-2060","5800-1800" }, displayID = 507 }; --Vultros
	[506] = { zoneID = 52, artID = { 57 }, x = 5959, y = 7440, overlay = { "5960-7440","6000-7300","6080-7480","6300-7240","6320-7380","6340-7580","6460-7500" }, displayID = 383 }; --Sergeant Brashclaw
	[519] = { zoneID = 52, artID = { 57 }, x = 4980, y = 1039, overlay = { "4980-1040","5200-1060","5340-0980","5400-1180","5460-1040","5560-0900","5620-1120" }, displayID = 540 }; --Slark
	[520] = { zoneID = 52, artID = { 57 }, x = 2880, y = 7280, overlay = { "2880-7280" }, displayID = 652 }; --Brack
	[572] = { zoneID = 52, artID = { 57 }, x = 4120, y = 2840, overlay = { "4120-2840","4140-2960","4260-2880" }, displayID = 1065 }; --Leprithus
	[573] = { zoneID = 52, artID = { 57 }, x = 3851, y = 5159, overlay = { "3800-5100","3860-5260","4400-3600","5400-3300","5500-3180","6240-6120","6360-6100" }, displayID = 548 }; --Foe Reaper 4000
	[596] = { zoneID = {
				[52] = { x = 4100, y = 7660, artID = { 57 }, overlay = { "4100-7660","4240-7660","4280-7900" } };
				[55] = { x = 6151, y = 6573, artID = { 60 }, overlay = { "6151-6573" } };
			  }, displayID = 3267 }; --null
	[599] = { zoneID = {
				[52] = { x = 3966, y = 7819, artID = { 57 }, overlay = { "3966-7819" } };
				[55] = { x = 2960, y = 6140, artID = { 60 }, overlay = { "2960-6140","2980-5920","3280-5680","3420-5500","3460-5680","3620-5600","3740-5640","3860-5680","3960-5580","4140-5660","5060-5360","5140-5480","5180-6520","5200-5620","5220-5780","5260-5420","5320-6320","5420-5400","5420-5700","5420-6820","5440-5540","5460-6940","5600-6400","5600-6660","5620-6780","5620-7080","5700-6520","5720-6940","6280-5920" } };
			  }, displayID = 2355 }; --null
	[1112] = { zoneID = 56, artID = { 61 }, x = 4680, y = 6340, overlay = { "4680-6340" }, displayID = 283 }; --Leech Widow
	[1140] = { zoneID = 56, artID = { 61 }, x = 6980, y = 2920, overlay = { "6980-2920" }, displayID = 11316 }; --Razormaw Matriarch
	[14424] = { zoneID = 56, artID = { 61 }, x = 5040, y = 3020, overlay = { "5040-3020","5060-3240","5140-2880","5140-3380","5220-3540","5220-3680","5240-2760","5280-3420","5380-2720","5380-2840","5400-3340","5460-3200","5500-3040","5520-2740","5560-2900","5620-3060" }, displayID = 697 }; --Mirelow
	[14425] = { zoneID = 56, artID = { 61 }, x = 3040, y = 3300, overlay = { "3040-3300","3140-2900","3160-3240","3160-3360","3440-2720","3500-2860" }, displayID = 501 }; --Gnawbone
	[14433] = { zoneID = 56, artID = { 61 }, x = 4440, y = 2480, overlay = { "4440-2480" }, displayID = 15463 }; --Sludginn
	[2090] = { zoneID = 56, artID = { 61 }, x = 4800, y = 7420, overlay = { "4800-7420" }, displayID = 4914 }; --Ma'ruk Wyrmscale <Dragonmaw Warl>
	[2108] = { zoneID = 56, artID = { 61 }, x = 3820, y = 4580, overlay = { "3820-4580" }, displayID = 4913 }; --Garneg Charskull
	[44224] = { zoneID = 56, artID = { 61 }, x = 1560, y = 4000, overlay = { "1320-3780","1340-3900","1340-4140","1340-4260","1500-3840","1520-3720","1520-4000" }, displayID = 1763 }; --Two-Toes
	[44225] = { zoneID = 56, artID = { 61 }, x = 4280, y = 3259, overlay = { "4260-3220" }, displayID = 32448 }; --Rufus Darkshot
	[44226] = { zoneID = 56, artID = { 61 }, x = 3360, y = 5100, overlay = { "3240-5080","3360-5100" }, displayID = 33737 }; --Sarltooth
	[44227] = { zoneID = 56, artID = { 61 }, x = 6160, y = 5780, overlay = { "6140-5740" }, displayID = 3199 }; --Gazz the Loch-Hunter
	[50964] = { zoneID = 56, artID = { 61 }, x = 5800, y = 0860, overlay = { "5720-0900","5780-0720" }, displayID = 46230 }; --Chops
	[14428] = { zoneID = 57, artID = { 62 }, x = 6519, y = 5120, overlay = { "6520-5120" }, displayID = 6818 }; --Uruson
	[14429] = { zoneID = 57, artID = { 62 }, x = 5160, y = 3840, overlay = { "5160-3840" }, displayID = 1011 }; --Grimmaw
	[14430] = { zoneID = 57, artID = { 62 }, x = 5220, y = 6740, overlay = { "5220-6740","5400-6660","5700-6640","5940-6440","5940-6560" }, displayID = 37558 }; --Duskstalker
	[14431] = { zoneID = 57, artID = { 62 }, x = 3700, y = 3040, overlay = { "3700-3040","3740-3160","3820-3340","3920-3660","3940-3540" }, displayID = 2296 }; --Fury Shelda
	[14432] = { zoneID = 57, artID = { 62 }, x = 5300, y = 4420, overlay = { "5300-4420" }, displayID = 904 }; --Threggil
	[2162] = { zoneID = 57, artID = { 62 }, x = 4720, y = 4479, overlay = { "4720-4480" }, displayID = 936 }; --Agal
	[3535] = { zoneID = 57, artID = { 62 }, x = 5200, y = 6380, overlay = { "5200-6340" }, displayID = 1549 }; --Blackmoss the Fetid
	[144946] = { zoneID = 62, artID = { 1176 }, x = 4070, y = 3566, overlay = { "4140-3600" }, displayID = 90400, questID = { 54865,54896 } }; --Ivus the Forest Lord
	[147240] = { zoneID = 62, artID = { 1176 }, x = 5243, y = 3213, overlay = { "5240-3200" }, displayID = 88619, questID = { 54227,54228 } }; --Hydrath
	[147241] = { zoneID = 62, artID = { 1176 }, x = 4373, y = 5357, overlay = { "4380-5340" }, displayID = 8714, questID = { 54229,54230 } }; --Cyclarus
	[147260] = { zoneID = 62, artID = { 1176 }, x = 3928, y = 6203, overlay = { "3920-6180" }, displayID = 1070, questID = { 54232,54233 } }; --Conflagros
	[147261] = { zoneID = 62, artID = { 1176 }, x = 4839, y = 5557, overlay = { "4820-5560" }, displayID = 1162, questID = { 54234,54235 } }; --Granokk
	[147332] = { zoneID = 62, artID = { 1176 }, x = 4550, y = 5898, overlay = { "4540-5880" }, displayID = 89635, questID = { 54247,54248 } }; --Stonebinder Ssra'vess
	[147435] = { zoneID = 62, artID = { 1176 }, x = 6212, y = 1652, overlay = { "6200-1640" }, friendly = { "A" }, displayID = 89707, questID = { 54252 } }; --Thelar Moonstrike
	[147664] = { zoneID = 62, artID = { 1176 }, x = 6240, y = 0980, overlay = { "6240-0940" }, friendly = { "H" }, displayID = 89764, questID = { 54274 } }; --Zim'kaga <Shatterspear Tribe>
	[147701] = { zoneID = 62, artID = { 1176 }, x = 6700, y = 1880, overlay = { "6320-2000","6460-1940","6580-1980","6700-1880" }, friendly = { "H" }, displayID = 89768, questID = { 54277 } }; --Moxo the Beheader <Shatterspear Tribe>
	[147708] = { zoneID = 62, artID = { 1176 }, x = 5847, y = 2432, overlay = { "5840-2440" }, displayID = 66623, questID = { 54278,54279 } }; --Athrikus Narassin
	[147744] = { zoneID = 62, artID = { 1176 }, x = 5738, y = 1567, overlay = { "5740-1540" }, displayID = 75372, questID = { 54285,54286 } }; --Amberclaw <Glrglrr's Mount>
	[147751] = { zoneID = 62, artID = { 1176 }, x = 4348, y = 2940, overlay = { "4340-2920" }, displayID = 82155, questID = { 54289,54290 } }; --Shattershard
	[147758] = { zoneID = 62, artID = { 1176 }, x = 4521, y = 7494, overlay = { "4520-7500" }, friendly = { "A" }, displayID = 1455, questID = { 54291 } }; --Onu <Ancient of Lore>
	[147845] = { zoneID = 62, artID = { 1176 }, x = 4660, y = 8660, overlay = { "4640-8580" }, friendly = { "H" }, displayID = 89798, questID = { 54309 } }; --Commander Drald
	[147897] = { zoneID = 62, artID = { 1176 }, x = 4061, y = 8532, overlay = { "4040-8440","4060-8560" }, displayID = 85923, questID = { 54320,54321 } }; --Soggoth the Slitherer
	[147942] = { zoneID = 62, artID = { 1176 }, x = 4060, y = 8268, overlay = { "4040-8240" }, displayID = 89822, questID = { 54397,54398 } }; --Twilight Prophet Graeme
	[147966] = { zoneID = 62, artID = { 1176 }, x = 3782, y = 8478, overlay = { "3740-8420" }, displayID = 1698, questID = { 54405,54406 } }; --Aman
	[147970] = { zoneID = 62, artID = { 1176 }, x = 3583, y = 8176, overlay = { "3540-8140" }, displayID = 72659, questID = { 54408,54409 } }; --Mrggr'marr
	[148025] = { zoneID = 62, artID = { 1176 }, x = 3794, y = 7624, overlay = { "3740-7620" }, displayID = 84029, questID = { 54426,54427 } }; --Commander Ral'esh
	[148031] = { zoneID = 62, artID = { 1176 }, x = 4091, y = 5644, overlay = { "4080-5640" }, displayID = 1010, questID = { 54428,54429 } }; --Gren Tornfur
	[148037] = { zoneID = 62, artID = { 1176 }, x = 4077, y = 7313, overlay = { "4080-7300","4080-7420","4140-7640" }, friendly = { "A" }, displayID = 89379, questID = { 54431 } }; --Athil Dewfire
	[148103] = { zoneID = 62, artID = { 1176 }, x = 3297, y = 8394, overlay = { "3300-8380" }, friendly = { "A" }, displayID = 89860, questID = { 54452 } }; --Sapper Odette
	[148295] = { zoneID = 62, artID = { 1176 }, x = 4159, y = 3600, overlay = { "4120-3540","4140-3660" }, displayID = 89962, questID = { 54862,54895 } }; --Ivus the Decayed
	[148787] = { zoneID = 62, artID = { 1176 }, x = 5647, y = 3076, overlay = { "5640-3080" }, displayID = 89749, questID = { 54695,54696 } }; --Alash'anir <Venom and Storm>
	[149141] = { zoneID = 62, artID = { 1176 }, x = 4159, y = 7680, overlay = { "4140-7640" }, friendly = { "H" }, displayID = 56590, questID = { 54768 } }; --Burninator Mark V
	[149652] = { zoneID = 62, artID = { 1176 }, x = 4960, y = 2500, overlay = { "4940-2480" }, friendly = { "H" }, displayID = 89897, questID = { 54883 } }; --Agathe Wyrmwood
	[149654] = { zoneID = 62, artID = { 1176 }, x = 4350, y = 1963, overlay = { "4340-1980" }, displayID = 89029, questID = { 54884,54885 } }; --Glimmerspine
	[149655] = { zoneID = 62, artID = { 1176 }, x = 5060, y = 3259, overlay = { "5040-3240" }, friendly = { "H" }, displayID = 77979, questID = { 54886 } }; --Croz Bloodrage
	[149657] = { zoneID = 62, artID = { 1176 }, x = 4398, y = 4852, overlay = { "4400-4840" }, displayID = 67206, questID = { 54887,54888 } }; --Madfeather
	[149659] = { zoneID = 62, artID = { 1176 }, x = 3960, y = 3360, overlay = { "3940-3340" }, friendly = { "H" }, displayID = 89896, questID = { 54889 } }; --Orwell Stevenson <Hunter Extraordina>
	[149660] = { zoneID = 62, artID = { 1176 }, x = 4966, y = 2494, overlay = { "4940-2480" }, friendly = { "A" }, displayID = 707, questID = { 54890 } }; --Blackpaw
	[149662] = { zoneID = 62, artID = { 1176 }, x = 5069, y = 3232, overlay = { "5040-3240" }, friendly = { "A" }, displayID = 89315, questID = { 54891 } }; --Grimhorn
	[149663] = { zoneID = 62, artID = { 1176 }, x = 3979, y = 3288, overlay = { "3980-3240" }, friendly = { "A" }, displayID = 89243, questID = { 54892 } }; --Shadowclaw
	[149665] = { zoneID = 62, artID = { 1176 }, x = 4763, y = 4454, overlay = { "4740-4460" }, displayID = 67608, questID = { 54893,54894 } }; --Scalefiend
	[2172] = { zoneID = 62, artID = { 67 }, x = 4080, y = 4840, overlay = { "4080-4840" }, displayID = 38 }; --Strider Clutchmother
	[2175] = { zoneID = 62, artID = { 67 }, x = 4120, y = 3640, overlay = { "4120-3640" }, displayID = 37555 }; --Shadowclaw
	[2184] = { zoneID = 62, artID = { 67 }, x = 4479, y = 5660, overlay = { "4480-5660" }, displayID = 5774 }; --Lady Moongazer
	[2186] = { zoneID = 62, artID = { 67 }, x = 4420, y = 8240, overlay = { "4420-8240" }, displayID = 5773 }; --Carnivous the Breaker
	[2191] = { zoneID = 62, artID = { 67 }, x = 5720, y = 3279, overlay = { "5720-3280" }, displayID = 37531 }; --Licillin
	[2192] = { zoneID = 62, artID = { 67 }, x = 4000, y = 8300, overlay = { "4000-8300" }, displayID = 5772 }; --Firecaller Radison
	[7015] = { zoneID = 62, artID = { 67 }, x = 5740, y = 1520, overlay = { "5740-1520","5800-1180","5840-0980" }, displayID = 1305 }; --Flagglemurk the Cruel
	[7016] = { zoneID = 62, artID = { 67 }, x = 4640, y = 4140, overlay = { "4640-4140","4840-4120","4860-3900" }, displayID = 4982 }; --Lady Vespira
	[7017] = { zoneID = 62, artID = { 67 }, x = 3400, y = 8340, overlay = { "3400-8340" }, displayID = 31547 }; --Lord Sinslayer
	[10559] = { zoneID = 63, artID = { 68 }, x = 1200, y = 1500, overlay = { "1200-1500","1240-2920","1500-2420" }, displayID = 4979 }; --Lady Vespia
	[10639] = { zoneID = 63, artID = { 68 }, x = 3700, y = 3360, overlay = { "3700-3360" }, displayID = 6800 }; --Rorgish Jowl
	[10640] = { zoneID = 63, artID = { 68 }, x = 5400, y = 6220, overlay = { "5400-6220","5580-6260","5640-6440" }, displayID = 5773 }; --Oakpaw
	[10641] = { zoneID = 63, artID = { 68 }, x = 4240, y = 4620, overlay = { "4240-4620","4320-4740","4340-4860","4360-5020","4380-5220","4400-5360","4540-4700","4640-4820","4660-5160" }, displayID = 8389 }; --Branch Snapper
	[10642] = { zoneID = 63, artID = { 68 }, x = 4640, y = 6940, overlay = { "4640-6940","4640-7060","4700-7180","4720-6840","4860-6840","4920-7160","4980-6900","4980-7040","5100-7080" }, displayID = 33846 }; --Eck'alom
	[10644] = { zoneID = 63, artID = { 68 }, x = 2520, y = 2680, overlay = { "2520-2680","2620-1540" }, displayID = 165 }; --Mist Howler
	[10647] = { zoneID = 63, artID = { 68 }, x = 6660, y = 5680, overlay = { "6660-5680","7840-4520","8100-4920" }, displayID = 11331 }; --Prince Raze
	[12037] = { zoneID = 63, artID = { 68 }, x = 8940, y = 4640, overlay = { "8940-4640","9280-4540" }, displayID = 70188 }; --Ursol'lok
	[3735] = { zoneID = 63, artID = { 68 }, x = 3140, y = 2239, overlay = { "3140-2240" }, friendly = { "H" }, displayID = 4156 }; --Apothecary Falthis
	[3736] = { zoneID = 63, artID = { 68 }, x = 7240, y = 7100, overlay = { "7240-7100","7360-7360","7520-7100" }, friendly = { "H" }, displayID = 4155 }; --Darkslayer Mordenthal
	[3773] = { zoneID = 63, artID = { 68 }, x = 2500, y = 6040, overlay = { "2500-6040" }, displayID = 1912 }; --Akkrilus
	[3792] = { zoneID = 63, artID = { 68 }, x = 5300, y = 3740, overlay = { "5300-3740" }, displayID = 522 }; --Terrowulf Packlord
	[14426] = { zoneID = 64, artID = { 69 }, x = 3840, y = 2720, overlay = { "3840-2720" }, displayID = 3898 }; --Harb Foulmountain
	[14427] = { zoneID = 64, artID = { 69 }, x = 3980, y = 3259, overlay = { "3980-3260" }, displayID = 511 }; --Gibblesnik
	[4132] = { zoneID = 64, artID = { 69 }, x = 6980, y = 8560, overlay = { "6980-8560" }, displayID = 37583 }; --Krkk'kx
	[50329] = { zoneID = 64, artID = { 69 }, x = 9080, y = 4060, overlay = { "9000-3980","9040-3840" }, displayID = 46999 }; --Rrakk
	[50727] = { zoneID = 64, artID = { 69 }, x = 9460, y = 8160, overlay = { "9340-8060","9440-8160" }, displayID = 20834 }; --Strix the Barbed
	[50741] = { zoneID = 64, artID = { 69 }, x = 3760, y = 5600, overlay = { "3740-5580" }, displayID = 1561 }; --Kaxx
	[50748] = { zoneID = 64, artID = { 69 }, x = 4459, y = 4040, overlay = { "4400-4040" }, displayID = 481 }; --Nyaj
	[50785] = { zoneID = 64, artID = { 69 }, x = 9420, y = 5859, overlay = { "9380-5740","9420-5860" }, displayID = 46995 }; --Skyshadow
	[50892] = { zoneID = 64, artID = { 69 }, x = 5520, y = 4060, overlay = { "5520-4040" }, displayID = 25857 }; --Cyn
	[50952] = { zoneID = 64, artID = { 69 }, x = 4159, y = 3680, overlay = { "4100-3620" }, displayID = 46994 }; --Barnacle Jim
	[51001] = { zoneID = 64, artID = { 69 }, x = 8180, y = 9600, overlay = { "8140-9580" }, displayID = 15423 }; --Venomclaw
	[51008] = { zoneID = 64, artID = { 69 }, x = 7119, y = 9480, overlay = { "7120-9480" }, displayID = 20912 }; --The Barbed Horror
	[5933] = { zoneID = 64, artID = { 69 }, x = 6960, y = 4940, overlay = { "6960-4940","7020-5060","7100-4900","7200-5000" }, displayID = 9418 }; --Achellios the Banished
	[5935] = { zoneID = 64, artID = { 69 }, x = 6120, y = 6700, overlay = { "6120-6700" }, displayID = 46055 }; --Ironeye the Invincible
	[5937] = { zoneID = 64, artID = { 69 }, x = 0612, y = 4203, overlay = { "0540-4200" }, displayID = 10988 }; --Vile Sting
	[4015] = { zoneID = 65, artID = { 70 }, x = 5500, y = 4500, overlay = { "5500-4500","5540-4640" }, displayID = 35655 }; --Pridewing Patriarch
	[4066] = { zoneID = 65, artID = { 70 }, x = 4840, y = 7340, overlay = { "4840-7340" }, displayID = 8471 }; --Nal'taszar
	[50343] = { zoneID = 65, artID = { 70 }, x = 6000, y = 6340, overlay = { "5960-6400" }, displayID = 46988 }; --Quall
	[50759] = { zoneID = 65, artID = { 70 }, x = 5440, y = 7480, overlay = { "5440-7480" }, displayID = 42742 }; --Iriss the Widow
	[50786] = { zoneID = 65, artID = { 70 }, x = 5900, y = 8660, overlay = { "5880-8640" }, displayID = 46990 }; --Sparkwing
	[50812] = { zoneID = 65, artID = { 70 }, x = 4940, y = 6559, overlay = { "4940-6560" }, displayID = 46229 }; --Arae
	[50825] = { zoneID = 65, artID = { 70 }, x = 7600, y = 9119, overlay = { "7600-9120" }, displayID = 46987 }; --Feras
	[50874] = { zoneID = 65, artID = { 70 }, x = 4440, y = 4920, overlay = { "4440-4920" }, displayID = 19733 }; --Tenok
	[50884] = { zoneID = 65, artID = { 70 }, x = 4479, y = 5579, overlay = { "4480-5580" }, displayID = 21268 }; --Dustflight the Cowardly
	[50895] = { zoneID = 65, artID = { 70 }, x = 3980, y = 4600, overlay = { "3980-4600" }, displayID = 46998 }; --Volux
	[50986] = { zoneID = 65, artID = { 70 }, x = 8219, y = 7920, overlay = { "8220-7920" }, displayID = 5245 }; --Goldenback
	[51062] = { zoneID = 65, artID = { 70 }, x = 7460, y = 7320, overlay = { "7460-7320" }, displayID = 46225 }; --Khep-Re
	[5915] = { zoneID = 65, artID = { 70 }, x = 4179, y = 1900, overlay = { "4180-1900" }, displayID = 4599 }; --Brother Ravenoak
	[5928] = { zoneID = 65, artID = { 70 }, x = 5020, y = 4120, overlay = { "5020-4120" }, displayID = 11012 }; --Sorrow Wing
	[5930] = { zoneID = 65, artID = { 70 }, x = 4040, y = 7080, overlay = { "4040-7080" }, displayID = 10875 }; --Sister Riven
	[5932] = { zoneID = 65, artID = { 70 }, x = 6440, y = 4540, overlay = { "6440-4540" }, displayID = 487 }; --Taskmaster Whipfang
	[11688] = { zoneID = {
				[66] = { x = 2786, y = 6266, artID = { 71 }, overlay = { "2786-6266" } };
				[67] = { x = 1994, y = 3927, artID = { 72 }, overlay = { "1220-5000","1300-4720","1440-4880","1460-4720","1520-4560","1520-5040","1580-3840","1580-4200","1640-4520","1640-5240","1660-3740","1680-5460","1700-4000","1720-4140","1740-5640","1760-3820","1760-4380","1820-5780","1840-6040","1860-4640","1900-4320","1920-4480","1920-5940","1940-3840","2020-5060","2040-4540","2040-6120","2060-4660","2100-4400","2100-4900","2140-5260","2140-5460","2200-4680","2200-5660","2200-5960","2260-6160","2280-4480","2340-4300","2680-4280","2940-4280" } };
			  }, displayID = 11640 }; --null
	[14225] = { zoneID = 66, artID = { 71 }, x = 7440, y = 1240, overlay = { "7440-1240","7540-1880","7740-2380" }, displayID = 2879 }; --Prince Kellen
	[14226] = { zoneID = 66, artID = { 71 }, x = 5000, y = 7200, overlay = { "5000-7200","5040-8120","5100-7520","5100-7660","5120-8480","5520-7640","5680-7440" }, displayID = 14255 }; --Kaskk
	[14227] = { zoneID = 66, artID = { 71 }, x = 4179, y = 4660, overlay = { "4180-4720","4240-4580","4300-4260","4300-6120","4620-5300","5140-4760","5140-4880" }, displayID = 45445 }; --Hissperak
	[14228] = { zoneID = 66, artID = { 71 }, x = 5740, y = 0840, overlay = { "5740-0840","5740-1000","5860-1840","5900-1720","6000-2540","6020-2400","6300-3420","6380-1960","6420-3360","6600-2420","6640-2580" }, displayID = 2714 }; --Giggler
	[14229] = { zoneID = 66, artID = { 71 }, x = 2900, y = 1340, overlay = { "2900-1340","2900-1460","3040-1880","3160-1340","3220-0580","3260-1500","3420-0940" }, displayID = 9135 }; --Accursed Slitherblade
	[18241] = { zoneID = 66, artID = { 71 }, x = 3440, y = 2160, overlay = { "3440-2160","3440-2340","3500-2000","3520-2540","3580-2400","3620-2240","3700-1980","3800-2080","3840-1900","3960-1800","4120-1880" }, displayID = 27692 }; --Crusty
	[11447] = { zoneID = 69, artID = { 74 }, x = 6920, y = 6140, overlay = { "6920-6140","6940-5980","6960-5820","6980-6260","7120-6340","7140-5780","7160-6140","7180-5940","7260-6280" }, displayID = 14382 }; --Mushgog
	[11497] = { zoneID = 69, artID = { 74 }, x = 8450, y = 4970, overlay = { "8450-4970" }, displayID = 37571 }; --The Razza
	[11498] = { zoneID = 69, artID = { 74 }, x = 8419, y = 3700, overlay = { "8420-3700" }, displayID = 10169 }; --Skarr the Broken
	[115537] = { zoneID = 69, artID = { 74 }, x = 5660, y = 7360, overlay = { "5420-7140","5440-7300","5460-7560","5540-7180","5580-7320","5580-7520" }, displayID = 73851 }; --Lorthalium <Ancient Frayfeather Matria>
	[43488] = { zoneID = 69, artID = { 74 }, x = 4960, y = 3060, overlay = { "4920-3020" }, displayID = 21120 }; --Mordei the Earthrender
	[5343] = { zoneID = 69, artID = { 74 }, x = 3040, y = 4580, overlay = { "3040-4580","3100-4260","3180-4520","3240-4380" }, displayID = 11262 }; --Lady Szallah
	[5345] = { zoneID = 69, artID = { 74 }, x = 4900, y = 2079, overlay = { "4900-2080" }, displayID = 1817 }; --Diamond Head
	[5346] = { zoneID = 69, artID = { 74 }, x = 5180, y = 6060, overlay = { "5180-6060","5280-5940" }, displayID = 7336 }; --Bloodroar the Stalker
	[5347] = { zoneID = 69, artID = { 74 }, x = 5340, y = 6880, overlay = { "5340-6880","5360-7080","5380-6760","5400-6640","5440-6520","5460-7360","5480-6900","5520-6660","5520-7080" }, displayID = 10889 }; --Antilus the Soarer
	[5349] = { zoneID = 69, artID = { 74 }, x = 3740, y = 2200, overlay = { "3740-2200","3780-2340","3880-2420","3900-2040","4020-2460","4040-2240","4140-2400" }, displayID = 7569 }; --Arash-ethis
	[5350] = { zoneID = 69, artID = { 74 }, x = 7340, y = 6400, overlay = { "7340-6400","7640-6120" }, displayID = 11142 }; --Qirot
	[5352] = { zoneID = 69, artID = { 74 }, x = 5540, y = 6120, overlay = { "5540-6120","5580-5980","5580-6240","5600-5760","5720-6220","5760-5880","5860-6240","5880-5900","5920-6100","6000-5940","6080-6040","6080-6200" }, displayID = 706 }; --Old Grizzlegut
	[5354] = { zoneID = 69, artID = { 74 }, x = 6940, y = 4220, overlay = { "6940-4220","6940-4420","7000-4100","7060-4600","7120-4040","7140-3920","7180-4200","7180-4540","7200-4340","7240-4080","7260-3940" }, displayID = 2168 }; --Gnarl Leafbrother
	[5356] = { zoneID = 69, artID = { 74 }, x = 7520, y = 3640, overlay = { "7520-3640","7600-3860","7780-3780","7940-3920","8120-3860","8140-3980","8340-3880","8460-3800" }, displayID = 780 }; --Snarler
	[54533] = { zoneID = {
				[69] = { x = 4859, y = 7900, artID = { 74 }, overlay = { "4760-7460","4800-7840" } };
				[81] = { x = 2140, y = 0640, artID = { 86 }, overlay = { "2060-0840","2140-0640" } };
			  }, displayID = 39009 }; --null
	[90816] = { zoneID = 69, artID = { 74 }, x = 5360, y = 6459, overlay = { "5360-6460" }, displayID = 12589 }; --Skystormer <The Unr>
	[14230] = { zoneID = 70, artID = { 498,75 }, x = 5904, y = 0933, overlay = { "5740-1660","5920-0920","6240-0820" }, displayID = 391 }; --Burgle Eye
	[14231] = { zoneID = 70, artID = { 498,75 }, x = 3980, y = 1924, overlay = { "3760-1840","3900-1820","3940-1960" }, displayID = 18313 }; --Drogoth the Roamer
	[14232] = { zoneID = 70, artID = { 498,75 }, x = 5142, y = 1686, overlay = { "4680-1740","4720-1600","4720-1860","4740-2000","4820-1420","4840-1580","4900-1720","4900-1880","5142-1686" }, displayID = 788 }; --Dart
	[14233] = { zoneID = 70, artID = { 498,75 }, x = 4378, y = 4999, overlay = { "3760-4920","3760-5060","4180-5520","4360-5080","4740-5440","4740-5560","4900-5760" }, displayID = 37748 }; --Ripscale
	[14234] = { zoneID = 70, artID = { 498,75 }, x = 4740, y = 6140, overlay = { "4740-6140","4780-6320","4840-5980","4860-6160" }, displayID = 2703 }; --Hayoc
	[14235] = { zoneID = 70, artID = { 498,75 }, x = 5163, y = 6069, overlay = { "5140-6060","5300-5880" }, displayID = 46282 }; --The Rot
	[14236] = { zoneID = 70, artID = { 498,75 }, x = 5594, y = 6328, overlay = { "5520-6320","5580-6500","5660-6240" }, displayID = 14257 }; --Lord Angler
	[14237] = { zoneID = 70, artID = { 498,75 }, x = 3711, y = 6256, overlay = { "3640-6240" }, displayID = 12336 }; --Oozeworm
	[4339] = { zoneID = 70, artID = { 498,75 }, x = 5020, y = 7540, overlay = { "5020-7540" }, displayID = 6369 }; --Brimgore
	[4380] = { zoneID = 70, artID = { 498,75 }, x = 3340, y = 2279, overlay = { "3340-2280" }, displayID = 17814 }; --Darkmist Widow
	[50342] = { zoneID = 70, artID = { 498,75 }, x = 3995, y = 2829, overlay = { "3940-2860" }, displayID = 33004 }; --Heronis
	[50735] = { zoneID = 70, artID = { 498,75 }, x = 5147, y = 1679, overlay = { "5140-1680" }, displayID = 4435 }; --Blinkeye the Rattler
	[50764] = { zoneID = 70, artID = { 498,75 }, x = 3859, y = 7484, overlay = { "3800-7440" }, displayID = 46518 }; --Paraliss
	[50784] = { zoneID = 70, artID = { 498,75 }, x = 3434, y = 3040, overlay = { "3220-3100","3434-3040" }, displayID = 47124 }; --Anith
	[50875] = { zoneID = 70, artID = { 498,75 }, x = 3388, y = 7037, overlay = { "3400-7040" }, displayID = 46287 }; --Nychus
	[50901] = { zoneID = 70, artID = { 498,75 }, x = 4110, y = 4048, overlay = { "4180-4340","4200-4200","4110-4048" }, displayID = 46235 }; --Teromak
	[50945] = { zoneID = 70, artID = { 498,75 }, x = 2934, y = 4377, overlay = { "2940-4340","2940-4460" }, displayID = 4714 }; --Scruff
	[50957] = { zoneID = 70, artID = { 498,75 }, x = 5384, y = 4374, overlay = { "5380-4340" }, displayID = 46285 }; --Hugeclaw
	[51061] = { zoneID = 70, artID = { 498,75 }, x = 5011, y = 8474, overlay = { "5020-8440" }, displayID = 15339 }; --Roth-Salam
	[51069] = { zoneID = 70, artID = { 498,75 }, x = 5595, y = 8570, overlay = { "5580-8560" }, displayID = 46290 }; --Scintillex
	[39183] = { zoneID = 71, artID = { 76 }, x = 4957, y = 5876, overlay = { "4940-5840" }, displayID = 31351 }; --Scorpitar
	[39185] = { zoneID = 71, artID = { 76 }, x = 4017, y = 6768, overlay = { "4000-6780" }, displayID = 31352 }; --Slaverjaw
	[39186] = { zoneID = 71, artID = { 76 }, x = 4080, y = 4120, overlay = { "4080-4120" }, displayID = 45946 }; --Hellgazer
	[44714] = { zoneID = 71, artID = { 76 }, x = 5702, y = 8963, overlay = { "5700-8980" }, displayID = 34030 }; --Fronkle the Disturbed
	[44722] = { zoneID = 71, artID = { 76 }, x = 6459, y = 1980, overlay = { "6440-2000" }, displayID = 11757 }; --Twisted Reflection of Narain
	[44750] = { zoneID = 71, artID = { 76 }, x = 4702, y = 6511, overlay = { "4700-6520" }, displayID = 9169 }; --Caliph Scorpidsting
	[44759] = { zoneID = 71, artID = { 76 }, x = 6950, y = 5720, overlay = { "6940-5700" }, displayID = 9073 }; --Andre Firebeard
	[44761] = { zoneID = 71, artID = { 76 }, x = 6952, y = 4982, overlay = { "6940-5000" }, displayID = 5564 }; --Aquementas the Unchained
	[44767] = { zoneID = 71, artID = { 76 }, x = 6100, y = 5060, overlay = { "6100-5040" }, displayID = 19060 }; --Occulus the Corrupted
	[47386] = { zoneID = 71, artID = { 76 }, x = 3680, y = 4759, overlay = { "3240-4860","3380-4600","3500-4460","3640-4240","3680-4380","3680-4660" }, displayID = 37549 }; --Ainamiss the Hive Queen
	[47387] = { zoneID = 71, artID = { 76 }, x = 5254, y = 6557, overlay = { "5040-7240","5240-6540","5280-7060","5560-6440","5620-6880" }, displayID = 15657 }; --Harakiss the Infestor
	[8199] = { zoneID = 71, artID = { 76 }, x = 4080, y = 2920, overlay = { "4080-2920" }, displayID = 9023 }; --Warleader Krazzilak
	[8200] = { zoneID = 71, artID = { 76 }, x = 3740, y = 2600, overlay = { "3740-2600","4080-3020" }, displayID = 9024 }; --Jin'Zallah the Sandbringer
	[8201] = { zoneID = 71, artID = { 76 }, x = 4224, y = 5233, overlay = { "3780-5680","3840-5340","3840-5460","3860-5200","3880-5820","3960-5060","4040-5860","4120-4980","4120-5140","4220-5480","4240-5280","4300-5580" }, displayID = 20017 }; --Omgorn the Lost
	[8203] = { zoneID = 71, artID = { 76 }, x = 7503, y = 4545, overlay = { "7120-4680","7340-4740","7500-4540" }, displayID = 7509 }; --Kregg Keelhaul
	[8204] = { zoneID = {
				[71] = { x = 3491, y = 4625, artID = { 76 }, overlay = { "3491-4625" } };
				[72] = { x = 5340, y = 6780, artID = { 78 }, overlay = { "5340-6780","5340-7040" } };
			  }, displayID = 14521 }; --null
	[8205] = { zoneID = {
				[71] = { x = 5672, y = 6839, artID = { 76 }, overlay = { "5672-6839" } };
				[73] = { x = 6015, y = 2538, artID = { 77 }, overlay = { "5820-2340","6020-2780","6060-2160","6080-2540" } };
			  }, displayID = 15439 }; --null
	[8207] = { zoneID = 71, artID = { 76 }, x = 4440, y = 4040, overlay = { "4440-4040","4820-4540" }, displayID = 34048 }; --Emberwing
	[107477] = { zoneID = 76, artID = { 81 }, x = 4400, y = 7640, overlay = { "4360-7660","4380-7520" }, displayID = 70105 }; --N.U.T.Z.
	[13896] = { zoneID = 76, artID = { 81 }, x = 4220, y = 5020, overlay = { "4220-5020","4240-4640","4240-4840","4300-5160","4300-5280" }, displayID = 7046 }; --Scalebeard
	[6118] = { zoneID = 76, artID = { 81 }, x = 3673, y = 7750, overlay = { "3240-7720","3300-7500","3340-7640","3400-7340","3420-7160","3500-7720","3580-7120","3740-7440","3673-7750" }, displayID = 21587 }; --Varo'then's Ghost
	[6648] = { zoneID = 76, artID = { 81 }, x = 4440, y = 2640, overlay = { "4440-2640","4440-2760" }, displayID = 3212 }; --Antilos
	[6649] = { zoneID = 76, artID = { 81 }, x = 4400, y = 5980, overlay = { "4400-5980" }, displayID = 11261 }; --Lady Sesspira
	[6650] = { zoneID = 76, artID = { 81 }, x = 5880, y = 7700, overlay = { "5880-7700","6040-7760","6160-7880","6180-7720","6300-7960","6300-8120" }, displayID = 11257 }; --General Fangferror
	[6651] = { zoneID = 76, artID = { 81 }, x = 3273, y = 3282, overlay = { "3300-3240" }, friendly = { "A","H" }, displayID = 1012 }; --Gatekeeper Rageroar
	[8660] = { zoneID = 76, artID = { 81 }, x = 1380, y = 5060, overlay = { "1380-5060","1440-5740" }, displayID = 37569 }; --The Evalcharr
	[107595] = { zoneID = 77, artID = { 82 }, x = 3840, y = 4479, overlay = { "3820-4540" }, displayID = 70193 }; --Grimrot
	[107596] = { zoneID = 77, artID = { 82 }, x = 3820, y = 4540, overlay = { "3820-4540" }, displayID = 70194 }; --Grimrot
	[14339] = { zoneID = 77, artID = { 82 }, x = 4820, y = 7440, overlay = { "4820-7440","5380-8480" }, displayID = 36341 }; --Death Howl
	[14340] = { zoneID = 77, artID = { 82 }, x = 3920, y = 8000, overlay = { "3920-8000","4000-8220","4080-8380","4240-8460","4320-8560" }, displayID = 2879 }; --Alshirr Banebreath
	[14342] = { zoneID = 77, artID = { 82 }, x = 4859, y = 8900, overlay = { "4860-8900" }, displayID = 1012 }; --Ragepaw
	[14343] = { zoneID = 77, artID = { 82 }, x = 5440, y = 2640, overlay = { "5440-2640","5480-2320","5620-2360","5700-1840","5740-1960" }, displayID = 37568 }; --Olm the Wise
	[14344] = { zoneID = 77, artID = { 82 }, x = 4340, y = 7580, overlay = { "4340-7580","4680-8200" }, displayID = 70186 }; --Mongress
	[14345] = { zoneID = 77, artID = { 82 }, x = 4200, y = 4580, overlay = { "4200-4580" }, displayID = 682 }; --The Ongar
	[50362] = { zoneID = 77, artID = { 82 }, x = 3480, y = 5959, overlay = { "3480-5960" }, displayID = 20596 }; --Blackbog the Fang
	[50724] = { zoneID = 77, artID = { 82 }, x = 6060, y = 2220, overlay = { "6040-2200" }, displayID = 20297 }; --Spinecrawl
	[50777] = { zoneID = 77, artID = { 82 }, x = 5100, y = 3420, overlay = { "5100-3420" }, displayID = 18041 }; --Needle
	[50833] = { zoneID = 77, artID = { 82 }, x = 4060, y = 3100, overlay = { "3940-3160" }, displayID = 38913 }; --Duskcoat
	[50864] = { zoneID = 77, artID = { 82 }, x = 5959, y = 0680, overlay = { "5940-0680" }, displayID = 46831 }; --Thicket
	[50905] = { zoneID = 77, artID = { 82 }, x = 4500, y = 3180, overlay = { "4500-3180" }, displayID = 46830 }; --Cida
	[50925] = { zoneID = 77, artID = { 82 }, x = 3820, y = 7260, overlay = { "3820-7260" }, displayID = 9569 }; --Grovepaw
	[51017] = { zoneID = 77, artID = { 82 }, x = 5259, y = 3160, overlay = { "5240-3140" }, displayID = 20142 }; --Gezan
	[51025] = { zoneID = 77, artID = { 82 }, x = 4220, y = 4820, overlay = { "4220-4740" }, displayID = 12335 }; --Dilennaa
	[51046] = { zoneID = 77, artID = { 82 }, x = 3859, y = 5280, overlay = { "3840-5280" }, displayID = 46517 }; --Fidonis
	[7104] = { zoneID = 77, artID = { 82 }, x = 5780, y = 1939, overlay = { "5780-1940" }, displayID = 9013 }; --Dessecus
	[7137] = { zoneID = 77, artID = { 82 }, x = 4060, y = 4340, overlay = { "4060-4340","4140-4200","4180-3860" }, displayID = 0 }; --Immolatus
	[6581] = { zoneID = 78, artID = { 83 }, x = 6080, y = 7280, overlay = { "6080-7280","6640-6700" }, displayID = 11319 }; --Ravasaur Matriarch
	[6582] = { zoneID = {
				[78] = { x = 4875, y = 8529, artID = { 83 }, overlay = { "4875-8529" } };
				[79] = { x = 7680, y = 5240, artID = { 84 }, overlay = { "7680-5240","7860-4780","8020-4560" } };
			  }, displayID = 11084 }; --null
	[6583] = { zoneID = 78, artID = { 83 }, x = 3180, y = 7819, overlay = { "3180-7820","3300-7940" }, displayID = 37587 }; --Gruff
	[6584] = { zoneID = 78, artID = { 83 }, x = 2900, y = 3640, overlay = { "2900-3640","2920-4740","2940-4240","2940-4600","3000-3560","3000-4440","3080-3180","3120-2940","3140-3660","3200-3040","3260-3660","3340-2840","3340-3560","3420-3720","3520-3580","3520-3900","3620-3700","3640-3060","3640-3540","3680-3220","3700-2940","3700-3380","3760-3100" }, displayID = 5305 }; --King Mosh
	[6585] = { zoneID = 78, artID = { 83 }, x = 6280, y = 1840, overlay = { "6280-1840" }, displayID = 8129 }; --Uhk'loc
	[122609] = { zoneID = 80, artID = { 85 }, x = 6880, y = 6000, overlay = { "6540-5940","6540-6080","6660-6080","6700-5920","6760-6220","6780-6020" }, displayID = 64706 }; --Xavinox
	[132578] = { zoneID = 81, artID = { 962,86 }, x = 5915, y = 1154, overlay = { "5720-1240","5720-1360","5800-1500","5900-1200","5960-1320","6080-1400" }, displayID = 82490 }; --Qroshekx
	[132580] = { zoneID = 81, artID = { 962,86 }, x = 5457, y = 7973, overlay = { "5300-7920","5440-7800","5440-7920","5440-8100","5580-7780","5580-8000" }, displayID = 82491 }; --Ssinkrix
	[132584] = { zoneID = 81, artID = { 962,86 }, x = 2949, y = 3491, overlay = { "2940-3420","2940-3560" }, displayID = 82492 }; --Xaarshej
	[132591] = { zoneID = 81, artID = { 962,86 }, x = 3100, y = 7700, overlay = { "2640-7380","2720-7680","2740-7480","2760-7240","2820-7100","2820-7780","2840-7660","2900-7500","2940-7300","2980-7700","3000-7060","3020-7400","3080-6840","3080-7220","3100-7540","3100-7700" }, displayID = 53683 }; --Ogmot the Mad <Twilight's Ham>
	[137906] = { zoneID = 81, artID = { 962,86 }, x = 4693, y = 3337, overlay = { "4460-3560","4700-3240","4800-3140","4880-5140","4980-5240","5060-5380" }, displayID = 82155 }; --Infused Bedrock
	[14471] = { zoneID = 81, artID = { 86 }, x = 3600, y = 8219, overlay = { "3600-8220" }, displayID = 5965 }; --Setis
	[14472] = { zoneID = 81, artID = { 86 }, x = 3559, y = 3800, overlay = { "3560-3800","3580-3960","3640-4200","4440-5100","4460-4900","4560-5040","5160-5620","5300-5460","5300-5580","6400-5760" }, displayID = 1104 }; --Gretheer
	[14473] = { zoneID = 81, artID = { 86 }, x = 5540, y = 7100, overlay = { "5540-7100","5600-7440","5720-7500","5860-6680","6080-6880","6160-6600","6300-7340","6360-8200","6560-7520" }, displayID = 37593 }; --Lapress
	[14474] = { zoneID = 81, artID = { 86 }, x = 2700, y = 6200, overlay = { "2700-6200","3200-5580","3380-5340" }, displayID = 37548 }; --Zora
	[14475] = { zoneID = 81, artID = { 86 }, x = 5100, y = 2300, overlay = { "5100-2300","5140-2660","5200-2480" }, displayID = 37579 }; --Rex Ashil
	[14476] = { zoneID = 81, artID = { 86 }, x = 6240, y = 1840, overlay = { "6240-1840","6440-3900","6720-2920","6920-3680" }, displayID = 6068 }; --Krellack
	[14477] = { zoneID = 81, artID = { 86 }, x = 3400, y = 7320, overlay = { "3400-7320","3440-7100","4100-6580","4120-6440","4880-7140","4920-7260","4940-6380","5020-6140","5080-6260" }, displayID = 14523 }; --Grubthor
	[14478] = { zoneID = 81, artID = { 86 }, x = 2920, y = 1920, overlay = { "2920-1920","3020-2420","3080-2620","3200-1560","3220-2660","3320-1480","3420-2600","3520-1620","3620-1780","3660-2200","3680-2360" }, displayID = 14525 }; --Huricanian
	[14479] = { zoneID = 81, artID = { 86 }, x = 2540, y = 7719, overlay = { "2540-7720","2620-7500","2640-7640","3300-3000","3440-3180","3500-3040","4420-4020","4520-4260","4660-4120" }, displayID = 14526 }; --Twilight Lord Everun <Twilight's Ham>
	[50370] = { zoneID = 81, artID = { 86 }, x = 5760, y = 1480, overlay = { "5700-1440" }, displayID = 20067 }; --Karapax
	[50737] = { zoneID = 81, artID = { 86 }, x = 7360, y = 1600, overlay = { "7360-1600" }, displayID = 46985 }; --Acroniss
	[50742] = { zoneID = 81, artID = { 86 }, x = 4400, y = 1720, overlay = { "4380-1760" }, displayID = 46982 }; --Qem
	[50743] = { zoneID = 81, artID = { 86 }, x = 6780, y = 6680, overlay = { "6720-6640" }, displayID = 46983 }; --Manax
	[50744] = { zoneID = 81, artID = { 86 }, x = 5460, y = 2660, overlay = { "5440-2640" }, displayID = 46981 }; --Qu'rik
	[50745] = { zoneID = 81, artID = { 86 }, x = 4260, y = 5660, overlay = { "4220-5580","4220-5700" }, displayID = 15658 }; --Losaj
	[50746] = { zoneID = 81, artID = { 86 }, x = 6360, y = 8880, overlay = { "6260-8940" }, displayID = 15656 }; --Bornix the Burrower
	[50747] = { zoneID = {
				[81] = { x = 3800, y = 8580, artID = { 86 }, overlay = { "3800-8580" } };
				[327] = { x = 6080, y = 0660, artID = { 339 }, overlay = { "6040-0620" } };
			  }, displayID = 15334 }; --null
	[50897] = { zoneID = 81, artID = { 86 }, x = 3300, y = 5340, overlay = { "3220-5300" }, displayID = 46980 }; --Ffexk the Dunestalker
	[51004] = { zoneID = 81, artID = { 86 }, x = 4280, y = 1820, overlay = { "4240-1720" }, displayID = 46984 }; --Toxx
	[10196] = { zoneID = 83, artID = { 88 }, x = 5560, y = 6419, overlay = { "5560-6420","5640-6560","5780-6560","5900-6540","6060-6400","6240-6420" }, displayID = 9489 }; --General Colbatann
	[10197] = { zoneID = 83, artID = { 88 }, x = 2400, y = 5040, overlay = { "2400-5040","2420-5160" }, displayID = 3208 }; --Mezzir the Howler
	[10198] = { zoneID = 83, artID = { 88 }, x = 6120, y = 8380, overlay = { "6120-8380" }, displayID = 10317 }; --Kashoch the Reaver
	[10199] = { zoneID = 83, artID = { 88 }, x = 6840, y = 5020, overlay = { "6840-5020" }, displayID = 9491 }; --Grizzle Snowpaw
	[10200] = { zoneID = 83, artID = { 88 }, x = 4680, y = 1939, overlay = { "4680-1940","4740-1820" }, displayID = 10054 }; --Rak'shiri
	[10202] = { zoneID = 83, artID = { 88 }, x = 5240, y = 5900, overlay = { "5240-5900","5260-6180","5680-5700","5800-5600","6080-5380","6180-5460","6300-5480","6420-5600","6560-6640","6560-6760","6580-5860","6580-6100","6580-6440","6600-6300" }, displayID = 6373 }; --Azurous
	[10741] = { zoneID = 83, artID = { 88 }, x = 4580, y = 1740, overlay = { "4580-1740" }, displayID = 10114 }; --Sian-Rotam
	[50346] = { zoneID = 83, artID = { 88 }, x = 5980, y = 4280, overlay = { "5940-4260" }, displayID = 17093 }; --Ronak
	[50348] = { zoneID = 83, artID = { 88 }, x = 5959, y = 2400, overlay = { "5940-2380" }, displayID = 17092 }; --Norissis
	[50353] = { zoneID = 83, artID = { 88 }, x = 6400, y = 8000, overlay = { "6400-8000" }, displayID = 45200 }; --Manas
	[50788] = { zoneID = 83, artID = { 88 }, x = 6680, y = 8359, overlay = { "6680-8340" }, displayID = 46996 }; --Quetzl
	[50819] = { zoneID = 83, artID = { 88 }, x = 5200, y = 1880, overlay = { "5200-1840" }, displayID = 9951 }; --Iceclaw
	[50993] = { zoneID = 83, artID = { 88 }, x = 3559, y = 4880, overlay = { "3540-4840" }, displayID = 26267 }; --Gal'dorak
	[50995] = { zoneID = 83, artID = { 88 }, x = 6600, y = 4200, overlay = { "6540-4160","6580-4280" }, displayID = 28648 }; --Bruiser
	[50997] = { zoneID = 83, artID = { 88 }, x = 6240, y = 2480, overlay = { "5920-1640","5980-1760","6220-2440" }, displayID = 26295 }; --Bornak the Gorer
	[51028] = { zoneID = 83, artID = { 88 }, x = 5060, y = 7219, overlay = { "5060-7220" }, displayID = 37551 }; --The Deep Tunneler
	[51045] = { zoneID = 83, artID = { 88 }, x = 4800, y = 5959, overlay = { "4800-5940" }, displayID = 24906 }; --Arcanus
	[149886] = { zoneID = 84, artID = { 89 }, x = 8522, y = 2483, overlay = { "8522-2483" }, friendly = { "H","A" }, displayID = 90574, questID = { 54950 } }; --Stanley
	[3581] = { zoneID = 84, artID = { 89 }, x = 4840, y = 6180, overlay = { "4840-6180","5220-6420","5400-6820","5420-6480","5440-7080","5480-6940","5560-6500","5600-7280","5620-7420","5620-7660","5760-4280","5760-7340","5780-7760","5800-4120","5840-7920","5900-4300","5940-4520","6020-4300","6040-7220","6120-4720","6180-4880","6200-5100","6360-4900","6440-6040","6500-6540","6560-5080","6600-6120","6640-6420","6660-5840","6700-5500","6740-5300","6740-6200","6780-6400","6780-6600","6860-5340","6880-5040","6900-6540","6940-5160","6940-6340","6960-4920","7020-6580","7060-6800","7100-4880" }, displayID = 2850 }; --Sewer Beast
	[149887] = { zoneID = 85, artID = { 90 }, x = 5349, y = 7076, overlay = { "5349-7076" }, friendly = { "H","A" }, displayID = 90571, questID = { 54948 } }; --Stanley
	[16854] = { zoneID = 94, artID = { 99 }, x = 6820, y = 4500, overlay = { "6820-4500","6860-4620","6900-4840","6980-4640","6980-4960" }, displayID = 14272 }; --Eldinarcus
	[16855] = { zoneID = 94, artID = { 99 }, x = 6280, y = 7960, overlay = { "6280-7960","6320-7820","6460-7800","6480-6720","6600-6900","6620-7900","6800-7940","6860-7180","6900-8120","6920-7320","6940-7460","6940-7840","7020-7240","7080-7540" }, displayID = 16406 }; --Tregla
	[22062] = { zoneID = 95, artID = { 100 }, x = 2940, y = 8840, overlay = { "2940-8840","3420-4860","3440-4720","3540-8860","4000-5000" }, displayID = 16176 }; --Dr. Whitherlimb
	[18677] = { zoneID = 100, artID = { 105 }, x = 4262, y = 6436, overlay = { "4100-7100","4160-6900","4180-6760","4220-6540","4280-6420","4380-6240","4460-5960","4480-3960","4500-4280","4540-4440","4560-4100","4600-5960","4660-4440","4680-4620","4700-5840","4820-5020","4860-5360","4960-5240","5020-5080","5180-5120","5320-5060","5560-5040","6480-7240","6520-7100","6740-6840","6760-7340","6780-7680","6880-7020","6960-6900" }, displayID = 20761 }; --Mekthorg the Wild
	[18678] = { zoneID = 100, artID = { 105 }, x = 2360, y = 5680, overlay = { "2360-5680","2360-5820","2360-5960","2360-6100","2480-4800","2480-4960","2580-4580","2620-4380","2740-4240","2860-6580","2900-4080","3000-6480","3080-3700","3140-6120","3360-6120","3540-5700","3720-5280","4040-5180","4240-7220","4360-5040","4380-7100","4500-4880","4640-6980","4900-7040","5080-7020","5340-7160","5460-7180","5660-7180" }, displayID = 17445 }; --Fulgorge
	[18679] = { zoneID = 100, artID = { 105 }, x = 7140, y = 5600, overlay = { "7140-5600","7400-3780" }, displayID = 20044 }; --Vorakem Doomspeaker <Herald of Doom Lord Kaz>
	[18680] = { zoneID = 102, artID = { 107 }, x = 0980, y = 5220, overlay = { "0980-5220","1080-4720","1080-5520","1100-5040","1340-4540","1460-4460","1500-4040","1500-4340","1600-3820","1680-3620","1760-3460","3780-3840","3880-3380","4040-3360","4220-3360","4300-3460","4460-3420","4700-3200","4740-3060","5000-3080","5240-3240","5400-3300","7020-3980","7040-3740","7360-3620","7380-4660","7580-4840","7700-5140","7880-5360" }, displayID = 45045 }; --Marticar
	[18681] = { zoneID = 102, artID = { 107 }, x = 2540, y = 3740, overlay = { "2540-3740","2580-4240","2620-4660","5980-3640","6200-6920","6300-3800","6340-4380","6380-6500","6440-6940","6480-4140","7040-7280","7220-7600","7340-8240","7480-7700" }, displayID = 20768 }; --Coilfang Emissary
	[18682] = { zoneID = 102, artID = { 107 }, x = 2300, y = 2140, overlay = { "2300-2140","2440-2060","2820-2320","4020-6180","4480-5900","4920-5820","8480-7960","8600-8420","8600-8960","8600-9120" }, displayID = 20769 }; --Bog Lurker
	[110486] = { zoneID = 103, artID = { 108 }, x = 6480, y = 8520, overlay = { "5580-7880","5700-7420","5720-9080","5740-7600","5740-8140","5740-9240","5780-7300","5780-7880","5780-8480","5860-8280","5920-7820","6020-8020","6080-8240","6140-8040","6480-8520" }, displayID = 71965 }; --Huk'roth the Huntmaster
	[18694] = { zoneID = 104, artID = { 109 }, x = 3660, y = 4500, overlay = { "3660-4500","3760-4320","3940-4280","5500-7120","5880-7040","6660-2620","6720-2320","7060-2880","7300-3020","7360-2900" }, displayID = 20590 }; --Collidus the Warp-Watcher
	[18695] = { zoneID = 104, artID = { 109 }, x = 2800, y = 4840, overlay = { "2800-4840","2900-5500","2920-5040","2960-5260","3060-5820","4500-2880","4500-3060","4620-2880","4640-6600","4640-6940","4660-2620","4660-2760","4660-7100","4780-6720","5580-3800","5620-3560","5700-3860","5740-3500","5740-3700","5860-3640","6800-6120","6880-5980","7100-6220" }, displayID = 11347 }; --Ambassador Jerrikar <Servant of Illi>
	[18696] = { zoneID = 104, artID = { 109 }, x = 3100, y = 4520, overlay = { "3100-4520","4180-4060","4200-3940","4200-6880","4540-1240","5940-4640" }, displayID = 20810 }; --Kraator
	[18690] = { zoneID = 105, artID = { 110 }, x = 6040, y = 2480, overlay = { "6040-2480","6340-5160","6720-4780","6800-6700","6840-6940","6880-4660","7100-2920" }, displayID = 20862 }; --Morcrush
	[18692] = { zoneID = 105, artID = { 110 }, x = 2800, y = 6619, overlay = { "2800-6620","2840-6760","2920-6360","2940-4940","2940-7000","2980-4740","2980-7120","3000-4540","3000-6500","3020-6740","3040-5140","3100-6900","3140-5700","3180-5300","3180-5560" }, displayID = 8574 }; --Hemathion
	[18693] = { zoneID = 105, artID = { 110 }, x = 3920, y = 5640, overlay = { "3920-5640","4060-5560","4080-4820","4080-4960","4140-5120","4140-5420","4180-5600","4240-5000","4240-8200","4340-8000","4380-7860","4520-7640","4640-7800","4680-7640","4720-7520","5580-3560","5600-2580","5620-3420","5640-2440","5640-2700","5740-2900","5740-3340","5760-3020","5780-3220","6440-1920","6520-2100","6560-2240","6620-2400","6620-2520","6640-2660" }, displayID = 20762 }; --Speaker Mar'grom
	[22060] = { zoneID = 106, artID = { 111 }, x = 1480, y = 5460, overlay = { "1480-5460" }, displayID = 20771 }; --Fenissa the Assassin
	[17144] = { zoneID = 107, artID = { 112 }, x = 4140, y = 4140, overlay = { "4140-4140","4400-4700","4480-4040","5820-2780","7460-7600","7580-7560","7600-7960","7600-8080","7620-7800" }, displayID = 20763 }; --Goretooth
	[18683] = { zoneID = 107, artID = { 112 }, x = 3220, y = 7040, overlay = { "3220-7040","3220-7160","3240-7320","3280-6880","3300-7460","3340-6740","3360-7580","3420-6620","3500-7680","3580-6560","3620-7700","3720-6580","3820-7600","3900-6820","3900-7440","3940-7320","3960-7080","3960-7200" }, displayID = 19681 }; --Voidhunter Yar
	[18684] = { zoneID = 107, artID = { 112 }, x = 2560, y = 5180, overlay = { "2560-5180","2700-4200","5000-5220","6000-7520","6020-7160","6040-7660","6080-7280","6480-7700","6760-7380","6920-7160","6980-7040" }, displayID = 18070 }; --Bro'Gaz the Clanless
	[18685] = { zoneID = 108, artID = { 113 }, x = 3040, y = 4340, overlay = { "3040-4340","3180-4220","4900-1740","4980-1880","5600-7040","5620-6920","5660-6780","5680-7140","5700-6580","5780-2320","5920-2420" }, displayID = 20766 }; --Okrek
	[18686] = { zoneID = 108, artID = { 113 }, x = 3559, y = 3780, overlay = { "3560-3780","3580-3440","3580-3580","3580-3920","3640-4060","3640-4220","4100-2560","4240-2660","4380-2640","4500-2640","4660-2640","4840-2560","4960-2520","5080-2500","5240-2380","5300-2220","5420-2060","5540-1980","5540-3240","5660-3260","5900-3440","6060-3520","6200-3640","6360-3840","6440-3940","6540-4120","6720-4520","6880-4740","7040-4880" }, displayID = 20767 }; --Doomsayer Jurim
	[18689] = { zoneID = 108, artID = { 113 }, x = 3040, y = 6380, overlay = { "3040-6380","3200-5520","3240-5200","3820-6500","3820-6640","3920-6820","3960-4860","4000-5040","4000-6240","4120-6540","4140-6340","4480-5620","4520-7400","4520-7920","4580-5960","4760-6260","4820-7460","4840-5540","4840-5740","4940-7100" }, displayID = 12073 }; --Crippler
	[21724] = { zoneID = 108, artID = { 113 }, x = 7619, y = 8120, overlay = { "7620-8120" }, displayID = 20425 }; --Hawkbane
	[18697] = { zoneID = 109, artID = { 114 }, x = 2620, y = 4040, overlay = { "2620-4040","2640-4240","2680-3600","2700-3720","2720-3840","2800-4000","4620-8000","4640-8220","4720-8080","4740-8460","4820-8160","5860-6400","5880-6260","5920-6720","6080-6560" }, displayID = 20765 }; --Chief Engineer Lorthander
	[18698] = { zoneID = 109, artID = { 114 }, x = 2060, y = 6820, overlay = { "2060-6820","2120-7640","2280-6440","2400-7560","2440-4140","2600-4220","2680-6500","2680-7280","2700-6980","2720-4260","2800-4120","2920-4000","2960-4140","3080-4180","5760-3900","5760-4260","5960-3340","5980-3520","6100-4660","6120-3220","6500-3260" }, displayID = 20764 }; --Ever-Core the Punisher
	[20932] = { zoneID = 109, artID = { 114 }, x = 2320, y = 7880, overlay = { "2320-7880","2480-8020","2680-8140","3280-3040","3300-3200","3420-2080","3440-2500","3440-2760","3520-1960","3560-2440","3560-7800","3840-7840","4040-7720","4420-7180","5420-5980","5640-5880","5720-6020","6360-5880","6560-5820","6760-6040" }, displayID = 19913 }; --Nuramoc
	[32357] = { zoneID = 114, artID = { 119 }, x = 3380, y = 3080, overlay = { "3380-3080" }, displayID = 24960 }; --Old Crystalbark
	[32358] = { zoneID = 114, artID = { 119 }, x = 5760, y = 1880, overlay = { "5760-1880","5900-2320","5920-2480","6020-1540","6140-2260","6140-3020","6160-2060","6260-1880","6260-3480","6340-1600","6340-2780","6500-1740","6580-3500","6600-1980","6620-3620","6680-2200","6780-2860","6840-3660","6860-1920","6960-3140","6960-3740","6980-3860","7060-2960","7100-3420","7200-3600","7220-2720" }, displayID = 24103 }; --Fumblub Gearwind
	[32361] = { zoneID = 114, artID = { 119 }, x = 8040, y = 4600, overlay = { "8040-4600","8120-3160","8460-4680","8540-3440","8820-3960","9140-3240" }, displayID = 26286 }; --Icehorn
	[32400] = { zoneID = 115, artID = { 120 }, x = 5460, y = 5440, overlay = { "5460-5440","5700-5080","5740-4840","5860-5940","5940-2880","5960-4300","6080-3260","6140-5820","6160-4840","6220-5020","6240-5440","6260-5280","6360-3620","6700-3100","6760-2980","6800-5880","6900-4840","6920-5600","6960-5420" }, displayID = 27951 }; --Tukemuth
	[32409] = { zoneID = 115, artID = { 120 }, x = 1540, y = 4520, overlay = { "1540-4520","1540-5820","2020-5500","2400-5340","2640-5800","2860-6140","3040-5860","3320-5680" }, displayID = 28284 }; --Crazed Indu'le Survivor
	[32417] = { zoneID = 115, artID = { 120 }, x = 6900, y = 7580, overlay = { "6900-7580","7120-2240","7180-7320","7200-2540","7200-7040","7540-2720","8580-3660","8640-4080","8800-3640" }, displayID = 10294 }; --Scarlet Highlord Daion
	[32422] = { zoneID = 116, artID = { 121 }, x = 1020, y = 3720, overlay = { "1020-3720","1040-3940","1100-4120","1120-7100","1140-4260","1200-5560","1220-4360","1240-5400","1260-4500","1280-5000","1300-4800","1320-4660","1320-5140","1340-5500","1340-7040","1420-5340","1480-5160","1500-7000","1520-5040","1640-6940","1720-7040","1840-7240","1880-7100","2000-7240","2020-5620","2100-7160","2140-5700","2220-7220","2240-7360","2260-5740","2380-5620","2400-5440","2400-5940","2460-6060","2480-5540","2500-5820","2620-5640","2800-4180" }, displayID = 26663 }; --Grocklar
	[32429] = { zoneID = 116, artID = { 121 }, x = 2820, y = 4540, overlay = { "2800-4560","3400-4920","3840-4920","3960-5060","4000-4840" }, displayID = 18083 }; --Seething Hate
	[32438] = { zoneID = 116, artID = { 121 }, x = 6200, y = 3680, overlay = { "6120-3520","6180-3660","6440-3580","6500-3000","6560-3360","6580-2840","6580-3680","6600-3940","6620-3560","6640-4140","6700-3800","6760-2800","6860-2680","6880-3080","7020-3340","7160-3500","7360-3760","7500-3820","7620-4160" }, displayID = 27970 }; --Syreian the Bonecarver
	[38453] = { zoneID = 116, artID = { 121 }, x = 3100, y = 5579, overlay = { "3100-5580" }, displayID = 31094 }; --Arcturis
	[32377] = { zoneID = 117, artID = { 122 }, x = 5020, y = 0480, overlay = { "5020-0480","5300-1200","6060-2000","6840-1640","6840-1760","7120-1380" }, displayID = 28051 }; --Perobas the Bloodthirster
	[32386] = { zoneID = 117, artID = { 122 }, x = 6860, y = 4840, overlay = { "6800-4480","6840-4680","6860-4840","6900-5880","6940-5720","6980-4940","7040-5100","7060-5680","7100-5560","7120-5320","7140-4400","7140-4520","7140-4760","7240-4940","7240-5100","7240-5280","7260-4420","7260-6140","7280-4060","7280-4600","7340-4740","7400-4500","7400-5240","7420-4640","7440-4860","7440-5400","7440-5520","7440-5660","7440-6040","7480-5100","7480-5880","7500-4140","7520-4980","7540-4480","7540-4720","7580-4280" }, displayID = 27063 }; --Vigdis the War Maiden
	[32398] = { zoneID = 117, artID = { 122 }, x = 2600, y = 6400, overlay = { "2600-6400","3080-7120","3120-5680","3200-7580","3320-8020" }, displayID = 27950 }; --King Ping
	[174048] = { zoneID = 118, artID = { 123 }, x = 4417, y = 4916, overlay = { "4420-4900" }, displayID = 27407, resetTimer = 1200, questID = { 62326 }, event = 1 }; --Elder Nadox
	[174049] = { zoneID = 118, artID = { 123 }, x = 2951, y = 6213, overlay = { "2940-6220" }, displayID = 30856, resetTimer = 1200, questID = { 62327 }, event = 1 }; --Prince Taldaram
	[174050] = { zoneID = 118, artID = { 123 }, x = 6750, y = 5816, overlay = { "6740-5800" }, displayID = 27394, resetTimer = 1200, questID = { 62328 }, event = 1 }; --Krik'thir the Gatewatcher
	[174051] = { zoneID = 118, artID = { 123 }, x = 5831, y = 3930, overlay = { "5840-3920" }, displayID = 26352, resetTimer = 1200, questID = { 62329 }, event = 1 }; --Trollgore
	[174052] = { zoneID = 118, artID = { 123 }, x = 7788, y = 6610, overlay = { "7780-6600" }, displayID = 26292, resetTimer = 1200, questID = { 62330 }, event = 1 }; --Novos the Summoner
	[174053] = { zoneID = 118, artID = { 123 }, x = 8031, y = 6134, overlay = { "8020-6120" }, displayID = 27072, resetTimer = 1200, questID = { 62331 }, event = 1 }; --The Prophet Tharon'ja
	[174054] = { zoneID = 118, artID = { 123 }, x = 5017, y = 8809, overlay = { "5020-8820" }, displayID = 30972, resetTimer = 1200, questID = { 62332 }, event = 1 }; --Falric
	[174055] = { zoneID = 118, artID = { 123 }, x = 5816, y = 8347, overlay = { "5820-8340" }, displayID = 30973, resetTimer = 1200, questID = { 62333 }, event = 1 }; --Marwyn
	[174056] = { zoneID = 118, artID = { 123 }, x = 5910, y = 7237, overlay = { "5900-7220" }, displayID = 30843, resetTimer = 1200, questID = { 62334 }, event = 1 }; --Forgemaster Garfrost
	[174057] = { zoneID = 118, artID = { 123 }, x = 4712, y = 6592, overlay = { "4720-6600" }, displayID = 30277, resetTimer = 1200, questID = { 62335 }, event = 1 }; --Scourgelord Tyrannus
	[174058] = { zoneID = 118, artID = { 123 }, x = 7061, y = 3854, overlay = { "7060-3840" }, displayID = 30226, resetTimer = 1200, questID = { 62336 }, event = 1 }; --Bronjahm <Godfather of Souls>
	[174059] = { zoneID = 118, artID = { 123 }, x = 6480, y = 2210, overlay = { "6480-2220" }, displayID = 29837, resetTimer = 1200, questID = { 62337 }, event = 1 }; --The Black Knight
	[174060] = { zoneID = 118, artID = { 123 }, x = 5394, y = 4467, overlay = { "5380-4480" }, displayID = 30857, resetTimer = 1200, questID = { 62338 }, event = 1 }; --Prince Keleseth
	[174061] = { zoneID = 118, artID = { 123 }, x = 5230, y = 5255, overlay = { "5240-5240" }, displayID = 26351, resetTimer = 1200, questID = { 62339 }, event = 1 }; --Ingvar the Plunderer
	[174062] = { zoneID = 118, artID = { 123 }, x = 5762, y = 5593, overlay = { "5740-5600" }, displayID = 27418, resetTimer = 1200, questID = { 62340 }, event = 1 }; --Skadi the Ruthless
	[174063] = { zoneID = 118, artID = { 123 }, x = 5117, y = 7854, overlay = { "5120-7840" }, displayID = 30893, resetTimer = 1200, questID = { 62341 }, event = 1 }; --Lady Deathwhisper
	[174064] = { zoneID = 118, artID = { 123 }, x = 5708, y = 3052, overlay = { "5700-3040" }, displayID = 30881, resetTimer = 1200, questID = { 62342 }, event = 1 }; --Professor Putricide
	[174065] = { zoneID = 118, artID = { 123 }, x = 4958, y = 3226, overlay = { "4940-3240" }, displayID = 31165, resetTimer = 1200, questID = { 62343 }, event = 1 }; --Blood Queen Lana'thel
	[174066] = { zoneID = 118, artID = { 123 }, x = 3655, y = 6766, overlay = { "3640-6740" }, displayID = 16174, resetTimer = 1200, questID = { 62344 }, event = 1 }; --Patchwerk
	[174067] = { zoneID = 118, artID = { 123 }, x = 3154, y = 7034, overlay = { "3140-7020" }, displayID = 16590, resetTimer = 1200, questID = { 62345 }, event = 1 }; --Noth the Plaguebringer
	[32487] = { zoneID = 118, artID = { 123 }, x = 4380, y = 5780, overlay = { "4380-5720","4420-5580","4440-5400","4440-5900","4480-5100","4480-6040","4540-4980","4540-6180","4560-6320","4640-6520","4660-4860","4740-4740","4820-4520","4880-4280","4960-4160","5100-3980","5140-4180","5260-4120","5280-3880","5400-3840","5400-4120","5520-4120","5720-4060","5820-4160","5940-4060","6040-4240","6080-4120","6180-4240","6340-4380","6400-4540","6500-4740","6520-4860","6520-5100","6600-5240","6640-5420","6700-5600","6740-5800","6740-5920","6800-6040","6800-6260","6820-6900","6840-6480","6880-6760","6920-6300" }, displayID = 27979 }; --Putridus the Ancient
	[32495] = { zoneID = 118, artID = { 123 }, x = 2840, y = 4580, overlay = { "2840-4580","3040-3840","3120-3980","3140-2820","3140-2960","3260-4040","3700-2440","5480-5220","5600-5320","5940-5860","5940-6220" }, displayID = 67148 }; --Hildana Deathstealer
	[32501] = { zoneID = 118, artID = { 123 }, x = 3120, y = 6220, overlay = { "3120-6220","3120-6380","3120-6860","3140-6580","3160-6720","3200-6980","3340-7040","3440-6940","3520-7060","4640-8480","4720-8060","4740-7820","4740-8600","4780-8440","4800-8180","4840-8680","4860-7820","4860-8020","4900-8420","4960-8620","6700-3740","6740-3860","6780-3980","6800-4120","6960-4080","7080-3920","7080-4140","7120-3760","7200-3640","7200-3920","7280-3500","7380-3140","7400-3380" }, displayID = 27988 }; --High Thane Jorfus
	[32481] = { zoneID = 119, artID = { 124 }, x = 4040, y = 5959, overlay = { "4040-5960","4120-6840","4200-7380","4300-5240","4320-5080","4420-6940","4680-5500","5240-7240","5440-5180","5640-6520","5760-6540" }, displayID = 27975 }; --Aotona
	[32485] = { zoneID = 119, artID = { 124 }, x = 2600, y = 4800, overlay = { "2600-4800","2740-4840","3000-4400","3020-3940","3280-3320","3300-3460","3400-3240","3680-3000","3700-2820","4600-4140","4680-4280","4760-4180","4760-4420","4920-4420","5020-4200","5040-4380","5080-8180","5160-4260","5240-8400","5460-8360","5680-8040","5700-8160","5800-8260","6080-8360","6260-8280","6380-7900","6560-7880" }, displayID = 28052 }; --King Krush
	[32517] = { zoneID = 119, artID = { 124 }, x = 2060, y = 7000, overlay = { "2060-7000","2180-6880","3040-6680","3540-3020","5100-8160","5820-2200","6620-7900","7080-7120" }, displayID = 28010 }; --Loque'nahak <Mate of Har'>
	[103154] = { zoneID = 120, artID = { 125 }, x = 3340, y = 5820, overlay = { "3340-5820" }, friendly = { "A","H" }, displayID = 70574 }; --Hati
	[32475] = { zoneID = {
				[120] = { x = 7160, y = 7500, artID = { 125 }, overlay = { "7160-7500" } };
				[121] = { x = 5259, y = 3200, artID = { 126 }, overlay = { "5200-3280","5320-3140","6040-3560","6120-3660","7080-2980","7140-2320","7140-2840","7180-2460","7400-6600","7520-6660","7700-4240","8140-3440" } };
			  }, displayID = 27683 }; --null
	[32491] = { zoneID = {
				[120] = { x = 2800, y = 6540, artID = { 125 }, overlay = { "3300-6500","3000-6400","2700-6600","2700-6000","2600-5600","2700-5200","2900-4800","3100-4600","3500-4000","3700-3900","3900-4000","4000-4400","4000-4900","3800-5100","3700-5600","3600-6000","2800-4400","2800-4000","2700-3600","2800-3300","3500-3100","3300-3100","3100-3200","3600-2900","3800-2800","4100-2700","4400-2600","4500-2500","4800-2500","5000-2500","5100-2700","5300-3100","5000-3500","5100-3300","4500-3600","4700-3500","4400-3800","4400-4000","4500-4200","4700-4600","4900-4900","4900-5200","4700-5300","4400-5600","4100-6000","3900-6100","3600-6300","4200-5700","2700-4700","3800-6500","4000-6300","4200-6100","4400-6100","4700-6400","4700-6800","4600-7100","4400-7400","4300-7600","4300-7800","4100-8200","3700-8500","3300-8000","3500-7700","3700-7600","3700-7300","3700-6900","3700-6700","3800-8400","3400-8400","3300-8200","3500-8500","2700-6200","2700-6900","2500-7100","2500-7400","2600-7700","2800-7800","2900-7900","3100-7900","3500-6700","3500-6900","3600-7100","3500-7400","3400-4100","3300-4400","2800-4200","4600-4400","3700-5300","3600-5700" } };
				[550] = { x = 9060, y = 2960, artID = { 567 }, overlay = { "9060-2960" } };
			  }, displayID = 26711 }; --null
	[32500] = { zoneID = 120, artID = { 125 }, x = 3780, y = 5840, overlay = { "3780-5840","4100-5140","4140-3900","4140-4040","6800-4740" }, displayID = 27986 }; --Dirkee
	[32630] = { zoneID = 120, artID = { 125 }, x = 2600, y = 7380, overlay = { "2600-7380","2640-4140","2700-7120","2720-4540","2740-5920","2740-6040","2780-7000","2840-6520","2880-8020","2900-6640","2980-6740","3080-6560","3120-6960","3200-6600","3400-6620","3540-3440","3540-6620","3620-6480","3660-6860","3660-6980","3680-7120","3680-7240","3680-7380","3680-8040","3700-7900","3720-6200","3720-7700","3800-6060","3840-3200","3860-8360","3980-5780","4020-4860","4040-6560","4080-5240","4080-5400","4080-8400","4100-7080","4220-5960","4360-5820","4420-3100","4580-6140","4800-4020","4820-6600","5000-6880","5080-7040" }, displayID = 28110 }; --Vyragosa
	[35189] = { zoneID = 120, artID = { 125 }, x = 2780, y = 5040, overlay = { "2780-5040","3020-6440","4620-6440" }, displayID = 29673 }; --Skoll
	[32447] = { zoneID = 121, artID = { 126 }, x = 2279, y = 8280, overlay = { "2280-8280","2840-8280","2900-7680","2900-8120","2920-7560","4040-5380","4040-5520","4040-5840","4040-5960","4040-6220","4040-6420","4240-7020","4360-7240","4500-5880","4560-6020","4620-7660","4700-7800" }, displayID = 26589 }; --Zul'Drak Sentinel
	[32471] = { zoneID = 121, artID = { 126 }, x = 1440, y = 5620, overlay = { "1440-5620","1740-7020","1740-7140","2040-7880","2040-8020","2100-7160","2140-7020","2240-6180","2360-6200","2380-6080","2440-7660","2620-5560","2620-7160","2640-7040","2720-5440" }, displayID = 25926 }; --Griegen
	[33776] = { zoneID = 121, artID = { 126 }, x = 6100, y = 6340, overlay = { "6100-6340","6140-6160","6320-4280","6740-7760","6940-4840","7720-7000" }, displayID = 28871 }; --Gondria
	[32435] = { zoneID = 126, artID = { 131 }, x = 5120, y = 3140, overlay = { "5120-3140","5260-3180","5380-3340","5400-2880","5500-3380","5560-3080","5700-3080" }, displayID = 20763 }; --Vern
	[50053] = { zoneID = 198, artID = { 203,227 }, x = 5920, y = 3760, overlay = { "3440-2600","3640-2640","3960-2600","4140-3040","4260-3160","4420-3260","4560-3240","4680-3360","4860-3420","5040-3300","5140-3200","5200-3080","5300-3000","5420-2940","5540-2860","5620-3460","5660-3280","5700-3140","5720-2840","5740-3560","5760-2960","5860-3620","5920-3760" }, displayID = 36700 }; --Thartuk the Exile
	[50056] = { zoneID = 198, artID = { 203,227 }, x = 4060, y = 8140, overlay = { "3720-7240","3720-7440","3740-7560","3780-7820","3800-7700","3820-8300","3900-7880","3900-8200","4000-8380","4020-8020","4020-8140" }, displayID = 37307 }; --Garr
	[50057] = { zoneID = 198, artID = { 203,227 }, x = 6780, y = 5500, overlay = { "4500-6040","5600-5720","6580-5480","6780-5500" }, displayID = 36701 }; --Blazewing
	[50058] = { zoneID = 198, artID = { 203,227 }, x = 5680, y = 7540, overlay = { "5220-8320","5380-8200","5420-8000","5560-7620","5680-7540" }, displayID = 37282 }; --Terrorpene
	[54318] = { zoneID = 198, artID = { 203,227 }, x = 2740, y = 5100, overlay = { "2740-5120","2880-5220","3000-5140","3240-5140","3320-5260","3440-5320","3500-5460","3600-5380","3800-5420","3920-5480","4040-5340" }, displayID = 38748 }; --Ankha
	[54319] = { zoneID = 198, artID = { 203,227 }, x = 2740, y = 5140, overlay = { "2740-5140","2900-5240","3000-5160","3120-5120","3240-5140","3340-5260","3460-5300","3520-5460","3640-5420","3780-5420","3880-5500","3960-5380","4080-5400" }, displayID = 38749 }; --Magria
	[54320] = { zoneID = 198, artID = { 203,227 }, x = 2800, y = 6220, overlay = { "2580-6120","2600-6520","2620-6280","2640-6000","2720-6420","2760-6020","2780-6260" }, displayID = 38634 }; --Ban'thalos
	[3253] = { zoneID = 199, artID = { 204 }, x = 4120, y = 6700, overlay = { "4120-6700" }, displayID = 37581 }; --Silithid Harvester
	[5829] = { zoneID = 199, artID = { 204 }, x = 4540, y = 4340, overlay = { "4540-4340" }, displayID = 34324 }; --Snort the Heckler
	[5832] = { zoneID = 199, artID = { 204 }, x = 4440, y = 7740, overlay = { "4440-7740","4440-8000","4620-7900","4820-7440","4980-7920","4980-8060" }, displayID = 37778 }; --Thunderstomp
	[5834] = { zoneID = 199, artID = { 204 }, x = 4220, y = 5340, overlay = { "4220-5340","4240-5480","4300-5620","4360-5740","4380-5480","4420-5900","4460-5620","4600-5740","4620-5520" }, displayID = 2702 }; --Azzere the Skyblade
	[5847] = { zoneID = 199, artID = { 204 }, x = 4700, y = 8860, overlay = { "4700-8860" }, friendly = { "A" }, displayID = 4595 }; --Heggin Stonewhisker <Bael'dun Chief Engin>
	[5848] = { zoneID = 199, artID = { 204 }, x = 4740, y = 8580, overlay = { "4740-8580" }, friendly = { "A" }, displayID = 4597 }; --Malgin Barleybrew <Bael'dun Morale Offi>
	[5849] = { zoneID = 199, artID = { 204 }, x = 4780, y = 8819, overlay = { "4780-8820" }, friendly = { "A" }, displayID = 4596 }; --Digger Flameforge <Excavation Special>
	[5851] = { zoneID = 199, artID = { 204 }, x = 4960, y = 8940, overlay = { "4960-8940" }, friendly = { "A" }, displayID = 4598 }; --Captain Gerogg Hammertoe <Bael'dun Captain of the Gu>
	[5859] = { zoneID = 199, artID = { 204 }, x = 4040, y = 8300, overlay = { "4040-8300","4180-8440","4320-8440" }, displayID = 6114 }; --Hagg Taurenbane <Razormane Champ>
	[5863] = { zoneID = 199, artID = { 204 }, x = 4200, y = 4260, overlay = { "4200-4260","4420-4200" }, displayID = 6100 }; --Geopriest Gukk'rok
	[5864] = { zoneID = 199, artID = { 204 }, x = 3859, y = 3340, overlay = { "3860-3340" }, displayID = 6114 }; --Swinegart Spearhide
	[49913] = { zoneID = 201, artID = { 206 }, x = 6160, y = 7540, overlay = { "5620-7780","5720-8020","5940-7520","6000-7680","6020-7040","6040-6920","6100-7500" }, displayID = 36660 }; --Lady La-La <Siren of the De>
	[51071] = { zoneID = {
				[203] = { x = 6840, y = 7380, artID = { 208 }, overlay = { "6840-7380" } };
				[205] = { x = 5520, y = 7380, artID = { 210 }, overlay = { "5520-7320" } };
			  }, friendly = { "A" }, displayID = 4693 }; --null
	[51079] = { zoneID = 203, artID = { 208 }, x = 6680, y = 6960, overlay = { "6680-6940" }, friendly = { "H" }, displayID = 30103 }; --Captain Foulwind
	[50005] = { zoneID = {
				[204] = { x = 4220, y = 7600, artID = { 209 }, overlay = { "3940-7160","4040-7380","4100-7660","4180-7340","4220-7600" } };
				[205] = { x = 6700, y = 4320, artID = { 210 }, overlay = { "3780-6680","3940-6880","3980-6640","4440-4940","4620-4860","5640-8200","5720-8080","5740-8360","5820-8160","6580-4320","6700-4320" } };
			  }, displayID = 37308 }; --null
	[50009] = { zoneID = 204, artID = { 209 }, x = 7740, y = 2680, overlay = { "6300-3060","6340-2500","6340-3200","6420-2320","6580-2040","6700-1900","6820-3960","6840-1820","6980-1740","6980-4020","7180-1840","7320-2000","7480-2040","7560-3660","7700-2540","7720-2900","7720-3180","7740-2680" }, displayID = 37338 }; --Mobus <The Crushing T>
	[50050] = { zoneID = 204, artID = { 209 }, x = 5100, y = 3220, overlay = { "4180-3240","4620-2940","4800-2740","4800-3460","5100-3220" }, displayID = 37335 }; --Shok'sharak
	[50051] = { zoneID = 204, artID = { 209 }, x = 3140, y = 8060, overlay = { "1280-8260","1500-7740","1500-8740","1900-7740","2000-5800","2040-6840","2200-6500","2420-7180","2440-8040","2600-8140","2820-8220","3120-7800","3140-8060" }, displayID = 37396 }; --Ghostcrawler
	[50052] = { zoneID = 205, artID = { 210 }, x = 5760, y = 6980, overlay = { "5640-7000","5720-6900" }, displayID = 36699 }; --Burgy Blackheart <Dreaded Captain of Diane's Fa>
	[49822] = { zoneID = 207, artID = { 212 }, x = 6120, y = 2260, overlay = { "6120-2240" }, displayID = 36636 }; --Jadefang
	[50059] = { zoneID = 207, artID = { 212 }, x = 4580, y = 8419, overlay = { "3240-7680","3720-7980","3720-8160","3860-8320","4280-8760","4540-8400" }, displayID = 37364 }; --Golgarok <The Crimson Shatte>
	[50060] = { zoneID = 207, artID = { 212 }, x = 5520, y = 2440, overlay = { "5420-2540","5520-2440" }, displayID = 36703 }; --Terborus
	[50061] = { zoneID = 207, artID = { 212 }, x = 5859, y = 5120, overlay = { "4040-5280","4060-5580","4080-4740","4080-5700","4100-4580","4200-4360","4200-6000","4280-4180","4300-6140","4360-4060","4420-6240","4440-6360","4540-3900","4620-6440","4640-3800","4740-6500","4960-3800","5040-6540","5260-6460","5300-3880","5440-4000","5540-6180","5580-4320","5620-6040","5720-5840","5740-4420","5760-5640","5820-5100" }, displayID = 32229 }; --Xariona
	[50062] = { zoneID = 207, artID = { 212 }, x = 6600, y = 6440, overlay = { "3120-4260","3500-4200","3940-4880","4140-8240","4260-4680","4280-5840","4320-4840","4340-6040","4640-4480","4700-5740","4740-5900","5160-4280","6040-2620","6160-2700","6480-1920","6600-6440" }, displayID = 37149 }; --Aeonaxx <Mate of Aeos>
	[108715] = { zoneID = 210, artID = { 215 }, x = 3940, y = 6380, overlay = { "3380-6220","3400-6740","3440-6600","3500-6180","3520-6760","3540-6940","3620-6220","3640-6720","3680-6080","3680-6420","3720-6880","3740-6240","3740-6620","3780-6740","3780-7000","3880-6620","3880-6860","3940-6380" }, displayID = 70668 }; --Ol' Eary
	[14490] = { zoneID = 210, artID = { 215 }, x = 4120, y = 7180, overlay = { "4120-7180" }, displayID = 14528 }; --Rippa
	[14491] = { zoneID = 210, artID = { 215 }, x = 4800, y = 5800, overlay = { "4800-5800","4940-5660","5060-5560","5100-5440","5220-5320","5360-5320","5440-5220","5540-5120","5620-5020","5620-5280","5720-4920","5800-4780" }, displayID = 3188 }; --Kurmokk
	[14492] = { zoneID = 210, artID = { 215 }, x = 5300, y = 2760, overlay = { "5300-2760" }, displayID = 7232 }; --Verifonix <The Surve>
	[1552] = { zoneID = 210, artID = { 215 }, x = 6780, y = 2520, overlay = { "6780-2520" }, displayID = 45945 }; --Scale Belly
	[2541] = { zoneID = 210, artID = { 215 }, x = 4320, y = 4960, overlay = { "4320-4960" }, displayID = 21160 }; --Lord Sakrasis
	[10080] = { zoneID = 219, artID = { 230 }, x = 5200, y = 4100, displayID = 9291 }; --Sandarr Dunereaver
	[10081] = { zoneID = 219, artID = { 230 }, x = 3620, y = 1780, overlay = { "3620-1780" }, displayID = 9292 }; --Dustwraith
	[10082] = { zoneID = 219, artID = { 230 }, x = 5300, y = 4000, displayID = 9293 }; --Zerillis
	[6228] = { zoneID = 229, artID = { 240 }, x = 2800, y = 5200, displayID = 6669 }; --Dark Iron Ambassador
	[11467] = { zoneID = 237, artID = { 248 }, x = 3200, y = 2800, displayID = 11250 }; --Tsu'zee
	[14506] = { zoneID = 238, artID = { 249 }, x = 3800, y = 5900, friendly = { "A" }, displayID = 14556 }; --Lord Hel'nurath
	[50085] = { zoneID = 241, artID = { 338,252 }, x = 5800, y = 3380, overlay = { "5780-3340" }, displayID = 36711 }; --Overlord Sunderfury
	[50086] = { zoneID = 241, artID = { 338,252 }, x = 5100, y = 8240, overlay = { "5080-8260" }, displayID = 36714 }; --Tarvus the Vile
	[50089] = { zoneID = 241, artID = { 338,252 }, x = 5980, y = 0680, overlay = { "5020-0880","5080-0740","5200-0720","5220-1060","5240-0920","5320-0800","5320-1200","5360-1080","5500-1180","5620-1260","5640-0820","5660-1100","5700-0700","5800-0960","5880-0620" }, displayID = 24301 }; --Julak-Doom <The Eye of>
	[50138] = { zoneID = 241, artID = { 338,252 }, x = 6559, y = 6060, overlay = { "4920-7420","4980-7540","5380-5320","5420-7620","5460-7500","5820-6360","5920-4340","6540-6020" }, displayID = 36726 }; --Karoma <The Wolf Spi>
	[50159] = { zoneID = 241, artID = { 338,252 }, x = 6880, y = 2580, overlay = { "3820-5300","4260-3860","6880-2580" }, displayID = 37352 }; --Sambas
	[8923] = { zoneID = 243, artID = { 254 }, x = 5000, y = 3700, displayID = 8270 }; --Panzor the Invincible
	[50063] = { zoneID = 249, artID = { 260,289 }, x = 3800, y = 6060, overlay = { "3800-6020" }, displayID = 34573 }; --Akma'hat <Dirge of the Eternal Sa>
	[50064] = { zoneID = 249, artID = { 260,289 }, x = 7080, y = 7420, overlay = { "5800-8240","5820-6120","6640-6800","7080-7420" }, displayID = 36707 }; --Cyrus the Black
	[50065] = { zoneID = 249, artID = { 260,289 }, x = 4520, y = 4220, overlay = { "4440-4200" }, displayID = 37353 }; --Armagedillo
	[50154] = { zoneID = 249, artID = { 260,289 }, x = 5380, y = 1939, overlay = { "4440-1040","4440-2180","4700-1740","4760-1860","5000-2380","5020-1960","5040-2100","5340-1860" }, displayID = 36728 }; --Madexx
	[51401] = { zoneID = 249, artID = { 260,289 }, x = 5320, y = 1980, overlay = { "4420-1080","4460-2140","4740-1900","5020-2380","5040-2020","5320-1980" }, displayID = 37360 }; --Madexx
	[51402] = { zoneID = 249, artID = { 260,289 }, x = 5320, y = 1939, overlay = { "4440-1040","4440-2200","5080-2020","5320-1940" }, displayID = 37362 }; --Madexx
	[51403] = { zoneID = 249, artID = { 260,289 }, x = 5340, y = 1900, overlay = { "4780-1820","5020-2380","5100-2040","5340-1900" }, displayID = 37359 }; --Madexx
	[51404] = { zoneID = 249, artID = { 260,289 }, x = 5320, y = 1980, overlay = { "4440-1020","4440-2180","4740-1840","5000-2060","5000-2400","5100-1960","5320-1980" }, displayID = 37361 }; --Madexx
	[10263] = { zoneID = 251, artID = { 262 }, x = 6600, y = 4100, displayID = 5047 }; --Burning Felguard
	[10376] = { zoneID = 251, artID = { 262 }, x = 5700, y = 7800, displayID = 9755 }; --Crystal Fang
	[9217] = { zoneID = 252, artID = { 263 }, x = 4100, y = 5800, displayID = 11578 }; --Spirestone Lord Magus
	[9218] = { zoneID = 252, artID = { 263 }, x = 3500, y = 5600, displayID = 11576 }; --Spirestone Battle Lord
	[9219] = { zoneID = 252, artID = { 263 }, x = 5120, y = 5670, displayID = 11574 }; --Spirestone Butcher
	[9596] = { zoneID = 252, artID = { 263 }, x = 4790, y = 6419, displayID = 9668 }; --Bannok Grimaxe
	[9718] = { zoneID = 255, artID = { 266 }, x = 3500, y = 7400, displayID = 11809 }; --Ghok Bashguud <Bloodaxe Champ>
	[9736] = { zoneID = 255, artID = { 266 }, x = 5390, y = 8440, overlay = { "5390-8440","5520-8410" }, displayID = 9738 }; --Quartermaster Zigris <Bloodaxe Leg>
	[56080] = { zoneID = 274, artID = { 285 }, x = 6120, y = 4110, friendly = { "A","H" }, displayID = 39299 }; --Little Samras
	[56081] = { zoneID = 274, artID = { 285 }, x = 4800, y = 6430, friendly = { "A","H" }, displayID = 5027 }; --Optimistic Benj
	[5912] = { zoneID = 279, artID = { 290 }, x = 7200, y = 6600, overlay = { "7200-6600" }, displayID = 1267 }; --Deviate Faerie Dragon
	[12237] = { zoneID = 280, artID = { 291 }, x = 2500, y = 7900, displayID = 9014 }; --Meshlok the Harvester
	[75590] = { zoneID = 301, artID = { 313 }, x = 1225, y = 3341, displayID = 52785 }; --Enormous Bullfrog
	[3872] = { zoneID = 316, artID = { 328 }, x = 6800, y = 6000, displayID = 37296 }; --Deathsworn Captain
	[10393] = { zoneID = 317, artID = { 329 }, x = 5600, y = 6600, displayID = 2606 }; --Skul
	[10558] = { zoneID = {
				[317] = { x = 8300, y = 2300, artID = { 329 }, overlay = { "8300-2300" } };
				[318] = { x = 6050, y = 3130, artID = { 330 }, overlay = { "6050-3130" } };
			  }, displayID = 10482 }; --null
	[10809] = { zoneID = 318, artID = { 330 }, x = 6700, y = 3000, displayID = 7856 }; --Stonespine
	[50815] = { zoneID = 338, artID = { 350 }, x = 3740, y = 3559, overlay = { "3300-5220","3680-3480" }, displayID = 19607 }; --Skarr
	[50959] = { zoneID = 338, artID = { 350 }, x = 3760, y = 3540, overlay = { "3300-5220","3680-3480" }, displayID = 88834 }; --Karkin
	[54321] = { zoneID = 338, artID = { 350 }, x = 6060, y = 5959, overlay = { "6020-5860","6040-6020" }, displayID = 38780 }; --Solix
	[54322] = { zoneID = 338, artID = { 350 }, x = 7320, y = 5940, overlay = { "6800-7140","6940-6980","7300-5800","7320-5940" }, displayID = 38424 }; --Deth'tilac <The Smouldering Darkn>
	[54323] = { zoneID = 338, artID = { 350 }, x = 3160, y = 5680, overlay = { "2660-6640","2700-6200","2900-7300","2980-5520","3020-5800","3040-5680","3160-5680" }, displayID = 38453 }; --Kirix
	[54324] = { zoneID = 338, artID = { 350 }, x = 2000, y = 5080, overlay = { "1860-5260","1940-4740","1940-4880","2000-5080" }, displayID = 38779 }; --Skitterflame
	[54338] = { zoneID = 338, artID = { 350 }, x = 5660, y = 4140, overlay = { "5260-4120","5380-3960","5460-4180","5480-3840","5660-4140" }, displayID = 38426 }; --Anthriss
	[16179] = { zoneID = 351, artID = { 363 }, x = 5959, y = 2870, overlay = { "5960-2870" }, displayID = 15938 }; --Hyakiss the Lurker
	[16180] = { zoneID = 351, artID = { 363 }, x = 5959, y = 2870, overlay = { "5960-2870" }, displayID = 16053 }; --Shadikith the Glider
	[16181] = { zoneID = 351, artID = { 363 }, x = 5959, y = 2870, overlay = { "5960-2870" }, displayID = 16054 }; --Rokad the Ravager
	[50338] = { zoneID = 371, artID = { 383 }, x = 4400, y = 7580, overlay = { "4340-7640","4360-7220","4400-7400" }, displayID = 44274 }; --Kor'nas Nightsavage
	[50350] = { zoneID = 371, artID = { 383 }, x = 4221, y = 1741, overlay = { "4080-1520","4220-1720","4240-1600","4640-1680","4800-1840","4820-2040" }, displayID = 44346 }; --Morgrinn Crackfang
	[50363] = { zoneID = 371, artID = { 383 }, x = 3951, y = 6260, overlay = { "3940-6240" }, displayID = 44394 }; --Krax'ik
	[50750] = { zoneID = 371, artID = { 383 }, x = 3355, y = 5078, overlay = { "3340-5080" }, displayID = 44203 }; --Aethis
	[50782] = { zoneID = 371, artID = { 383 }, x = 6445, y = 7410, overlay = { "6440-7400" }, displayID = 44255 }; --Sarnak
	[50808] = { zoneID = 371, artID = { 383 }, x = 5740, y = 7140, overlay = { "5720-7160" }, displayID = 44362 }; --Urobi the Walker
	[50823] = { zoneID = 371, artID = { 383 }, x = 4254, y = 3885, overlay = { "4240-3880" }, displayID = 44236 }; --Mister Ferocious
	[51078] = { zoneID = 371, artID = { 383 }, x = 5640, y = 4800, overlay = { "5200-4440","5340-4940","5360-4540","5420-4240","5640-4800" }, displayID = 43977 }; --Ferdinand
	[69768] = { zoneID = {
				[371] = { x = 5420, y = 2760, artID = { 383 }, overlay = { "4320-1720","4440-1760","4680-1880","4740-2100","4880-2140","4940-2020","5080-3680","5100-2000","5260-1940","5260-2180","5260-2340","5260-3260","5300-3460","5320-3060","5340-2940","5420-2760" } };
				[379] = { x = 6475, y = 6414, artID = { 391 }, overlay = { "6460-6400","6620-6500","6720-8180","6740-7960","6800-6440","6960-6560","6960-7680","7060-7540","7080-6600","7120-7420","7160-7240","7240-6640","7240-7140","7320-6900","7420-6720" } };
				[388] = { x = 4940, y = 7300, artID = { 400 }, overlay = { "3680-8520","3740-8660","3760-8420","3860-8740","3880-8260","3940-8140","3960-8820","4040-7740","4080-8980","4200-9020","4360-9080","4420-7480","4560-7520","4620-8980","4680-7480","4840-7420","4840-8600","4880-8460","4940-7300" } };
				[418] = { x = 5780, y = 2920, artID = { 499 }, overlay = { "3620-6020","3720-6240","3840-6560","3920-6360","5780-2920" } };
				[422] = { x = 5760, y = 6600, artID = { 434 }, overlay = { "3740-4840","3900-4640","3940-4940","4120-5020","4300-5160","4540-5600","4600-5840","4640-5960","4700-6080","4840-6100","4900-6260","4960-6380","5340-6660","5600-6660","5760-6600" } };
			  }, displayID = 47673 }; --null
	[69769] = { zoneID = {
				[371] = { x = 5259, y = 1900, artID = { 383 }, overlay = { "5240-1880" } };
				[379] = { x = 7500, y = 6760, artID = { 391 }, overlay = { "7500-6740" } };
				[388] = { x = 3660, y = 8560, artID = { 400 }, overlay = { "3640-8540" } };
				[418] = { x = 3980, y = 6559, artID = { 499 }, overlay = { "3860-6720","3980-6540" } };
				[422] = { x = 4759, y = 6160, artID = { 434 }, overlay = { "4720-6100" } };
			  }, displayID = 47681 }; --null
	[69841] = { zoneID = {
				[371] = { x = 5259, y = 1900, artID = { 383 }, overlay = { "5240-1880" } };
				[379] = { x = 7500, y = 6760, artID = { 391 }, overlay = { "7500-6740" } };
				[388] = { x = 3660, y = 8560, artID = { 400 }, overlay = { "3640-8540" } };
				[422] = { x = 4740, y = 6160, artID = { 434 }, overlay = { "4720-6140" } };
			  }, displayID = 47681 }; --null
	[69842] = { zoneID = {
				[371] = { x = 5259, y = 1900, artID = { 383 }, overlay = { "5240-1880" } };
				[379] = { x = 7500, y = 6760, artID = { 391 }, overlay = { "7500-6740" } };
				[388] = { x = 3660, y = 8560, artID = { 400 }, overlay = { "3640-8540" } };
				[422] = { x = 4759, y = 6160, artID = { 434 }, overlay = { "4720-6140" } };
			  }, displayID = 47681 }; --null
	[70323] = { zoneID = {
				[371] = { x = 5660, y = 2180, artID = { 383 }, overlay = { "5080-2080","5580-2140" } };
				[376] = { x = 3720, y = 7060, artID = { 388 }, overlay = { "3720-7060" } };
				[379] = { x = 7340, y = 8640, artID = { 391 }, overlay = { "3300-4440","7280-8520","7320-8660" } };
				[388] = { x = 3559, y = 5300, artID = { 400 }, overlay = { "3520-5120","3540-5300" } };
				[418] = { x = 3460, y = 3420, artID = { 499 }, overlay = { "3240-3420","3320-3320","3460-3420" } };
				[422] = { x = 2640, y = 1600, artID = { 434 }, overlay = { "2640-1600" } };
				[554] = { x = 4759, y = 5480, artID = { 571 }, overlay = { "4740-5500" } };
			  }, displayID = 48006 }; --null
	[50339] = { zoneID = 376, artID = { 388 }, x = 3694, y = 2574, overlay = { "3680-2540" }, displayID = 44282 }; --Sulik'shor
	[50351] = { zoneID = 376, artID = { 388 }, x = 1860, y = 7770, overlay = { "1840-7740" }, displayID = 44347 }; --Jonn-Dar
	[50364] = { zoneID = 376, artID = { 388 }, x = 0871, y = 6012, overlay = { "0820-5940","0840-5620","0840-5760","0860-6080","0880-5080","0920-4740","0920-5400","0940-4560","0940-4880","0960-5740","0980-5240","0980-5620","1040-4740","1100-5660","1120-5500","1120-5860","1140-4880","1180-5220","1200-5080","1280-4980" }, displayID = 44395 }; --Nal'lak the Ripper
	[50766] = { zoneID = 376, artID = { 388 }, x = 5444, y = 3633, overlay = { "5220-2860","5400-3140","5420-3260","5440-3640","5740-3340","5800-3820","5920-3720","5960-3840" }, displayID = 44222 }; --Sele'na
	[50783] = { zoneID = 376, artID = { 388 }, x = 6776, y = 5875, overlay = { "6740-5940","6820-5820","6900-5280","6900-5620","6940-5440","7020-5320","7100-5220","7260-5240","7380-5240","7400-5080","7420-4940","7500-4820","7520-4700" }, displayID = 44267 }; --Salyin Warscout
	[50811] = { zoneID = 376, artID = { 388 }, x = 8839, y = 1785, overlay = { "8840-1800" }, displayID = 44370 }; --Nasra Spothide
	[50828] = { zoneID = 376, artID = { 388 }, x = 1395, y = 3847, overlay = { "1380-3860","1540-3240","1560-3100","1640-3520","1640-4080","1900-3540" }, displayID = 44242 }; --Bonobos <The Bananaman>
	[51059] = { zoneID = 376, artID = { 388 }, x = 3455, y = 5922, overlay = { "3280-6240","3440-5940","3760-6040","3940-5740" }, displayID = 44161 }; --Blackhoof
	[62346] = { zoneID = 376, artID = { 388 }, x = 7094, y = 6233, overlay = { "7160-6440","7094-6233" }, displayID = 42439, questReset = true, nameplate = true, questID = { 32098 } }; --Galleon
	[50332] = { zoneID = 379, artID = { 391 }, x = 5076, y = 8059, overlay = { "4740-8140","4860-8000","5000-8060","5120-7940","5140-8060" }, displayID = 44163 }; --Korda Torros
	[50341] = { zoneID = 379, artID = { 391 }, x = 5543, y = 4397, overlay = { "5540-4340" }, displayID = 44283 }; --Borginn Darkfist
	[50354] = { zoneID = 379, artID = { 391 }, x = 5935, y = 7375, overlay = { "5700-7600","5920-7380" }, displayID = 44349 }; --Havak
	[50733] = { zoneID = 379, artID = { 391 }, x = 3660, y = 7960, overlay = { "3640-7960" }, displayID = 44397 }; --Ski'thik
	[50769] = { zoneID = 379, artID = { 391 }, x = 7386, y = 7724, overlay = { "7320-7640","7440-7920" }, displayID = 44226 }; --Zai the Outcast
	[50789] = { zoneID = 379, artID = { 391 }, x = 6389, y = 1373, overlay = { "6380-1380" }, displayID = 44269 }; --Nessos the Oracle
	[50817] = { zoneID = 379, artID = { 391 }, x = 4080, y = 4240, overlay = { "4060-4280" }, displayID = 44372 }; --Ahone the Wanderer
	[50831] = { zoneID = 379, artID = { 391 }, x = 4720, y = 6300, overlay = { "4480-6360","4480-6520","4620-6180","4720-6300" }, displayID = 44246 }; --Scritch
	[60491] = { zoneID = 379, artID = { 391 }, x = 5419, y = 6466, overlay = { "5440-6320","5419-6466" }, displayID = 41448, questReset = true, nameplate = true, questID = { 32099 } }; --Sha of Anger
	[50333] = { zoneID = 388, artID = { 400 }, x = 6646, y = 5167, overlay = { "6420-4980","6540-5060","6640-4480","6640-5220","6680-5100","6720-4700","6740-4560","6760-5000" }, displayID = 44164 }; --Lon the Bull
	[50344] = { zoneID = 388, artID = { 400 }, x = 5389, y = 6349, overlay = { "5380-6360" }, displayID = 44284 }; --Norlaxx
	[50355] = { zoneID = 388, artID = { 400 }, x = 6300, y = 3559, overlay = { "6280-3540" }, displayID = 44350 }; --Kah'tir
	[50734] = { zoneID = 388, artID = { 400 }, x = 4786, y = 8854, overlay = { "4180-7860","4620-7460","4780-8420","4780-8840" }, displayID = 44398 }; --Lith'ik the Stalker
	[50772] = { zoneID = 388, artID = { 400 }, x = 6536, y = 8746, overlay = { "6540-8740","6780-8740","6880-8900" }, displayID = 44228 }; --Eshelon
	[50791] = { zoneID = 388, artID = { 400 }, x = 5920, y = 8560, overlay = { "5920-8540" }, displayID = 44270 }; --Siltriss the Sharpener
	[50820] = { zoneID = 388, artID = { 400 }, x = 3200, y = 6180, overlay = { "3200-6180" }, displayID = 44373 }; --Yul Wildpaw
	[50832] = { zoneID = 388, artID = { 400 }, x = 6761, y = 7460, overlay = { "6760-7440" }, displayID = 44249 }; --The Yowler
	[50336] = { zoneID = 390, artID = { 402 }, x = 8808, y = 4433, overlay = { "8780-4440" }, displayID = 44159 }; --Yorik Sharpeye
	[50349] = { zoneID = 390, artID = { 402 }, x = 1523, y = 3521, overlay = { "1500-3520" }, displayID = 44286 }; --Kang the Soul Thief
	[50359] = { zoneID = 390, artID = { 402 }, x = 3957, y = 2514, overlay = { "3940-2520" }, displayID = 44352 }; --Urgolax
	[50749] = { zoneID = 390, artID = { 402 }, x = 1384, y = 5864, overlay = { "1400-5820" }, displayID = 44400 }; --Kal'tik the Blight
	[50780] = { zoneID = 390, artID = { 402 }, x = 6940, y = 3064, overlay = { "6920-3020" }, displayID = 44230 }; --Sahn Tidehunter
	[50806] = { zoneID = 390, artID = { 402 }, x = 3519, y = 6050, overlay = { "3500-6160","3540-6020","3640-5940","3660-5820","3760-5580","3760-5720","3860-5500","3920-5360","4140-5300","4260-5380","4380-5100" }, displayID = 44272 }; --Moldo One-Eye
	[50822] = { zoneID = 390, artID = { 402 }, x = 4283, y = 6924, overlay = { "4240-6900" }, displayID = 44375 }; --Ai-Ran the Shifting Cloud
	[50840] = { zoneID = 390, artID = { 402 }, x = 3100, y = 9160, overlay = { "3040-9140" }, displayID = 44251 }; --Major Nanners
	[58474] = { zoneID = 390, artID = { 402 }, x = 2700, y = 1460, overlay = { "2700-1460" }, displayID = 36513 }; --Bloodtip <Ashweb Matria>
	[58768] = { zoneID = 390, artID = { 402 }, x = 4644, y = 5934, overlay = { "4620-5900" }, displayID = 44455 }; --Cracklefang
	[58769] = { zoneID = 390, artID = { 402 }, x = 3737, y = 5090, overlay = { "3480-5080","3720-5120" }, displayID = 42333 }; --Vicejaw
	[58771] = { zoneID = 390, artID = { 402 }, x = 6650, y = 3931, overlay = { "6640-3920" }, displayID = 40357 }; --Quid <Spirit of the Misty Fa>
	[58778] = { zoneID = 390, artID = { 402 }, x = 3500, y = 8959, overlay = { "3500-8940" }, displayID = 42736 }; --Aetha <Spirit of the Golden Wi>
	[58817] = { zoneID = 390, artID = { 402 }, x = 4743, y = 6566, overlay = { "4740-6620" }, displayID = 40299 }; --Spirit of Lao-Fe <The Slavebin>
	[58949] = { zoneID = 390, artID = { 402 }, x = 1699, y = 4858, overlay = { "1680-4820" }, displayID = 45743 }; --Bai-Jin the Butcher <Shao-Tien Imper>
	[62880] = { zoneID = 390, artID = { 402 }, x = 2685, y = 1311, overlay = { "2700-1340" }, displayID = 45741 }; --Gochao the Ironfist <Shao-Tien Imper>
	[63101] = { zoneID = 390, artID = { 402 }, x = 2896, y = 5707, overlay = { "2640-5120","2660-5260","2740-5380","2800-5520","2840-5660","2940-5760","3060-5820","3080-5980" }, displayID = 45786 }; --General Temuja <The Soul-Sla>
	[63240] = { zoneID = 390, artID = { 402 }, x = 3058, y = 7837, overlay = { "3040-7800" }, displayID = 45785 }; --Shadowmaster Sydow <The Soul-Gathe>
	[63510] = { zoneID = 390, artID = { 402 }, x = 4534, y = 7624, overlay = { "4520-7620" }, displayID = 43097 }; --Wulon <The Granite Senti>
	[63691] = { zoneID = 390, artID = { 402 }, x = 2680, y = 1580, overlay = { "2680-1580" }, displayID = 45739 }; --Huo-Shuang <Shao-Tien Imper>
	[63695] = { zoneID = 390, artID = { 402 }, x = 2869, y = 4337, overlay = { "2840-4320" }, displayID = 45745 }; --Baolai the Immolator <Shao-Tien Imper>
	[63977] = { zoneID = 390, artID = { 402 }, x = 0792, y = 3384, overlay = { "0800-3340" }, displayID = 43377 }; --Vyraxxis <Krik'thik Swarm-L>
	[63978] = { zoneID = 390, artID = { 402 }, x = 0603, y = 5854, overlay = { "0620-5780" }, displayID = 43409 }; --Kri'chon <The Corpse-Rea>
	[62881] = { zoneID = 395, artID = { 403 }, x = 5480, y = 5840, overlay = { "5280-6080","5340-5940","5480-5840" }, displayID = 45744 }; --Gaohun the Soul-Severer <Shao-Tien Imper>
	[71992] = { zoneID = 407, artID = { 419 }, x = 4320, y = 4580, overlay = { "3600-4980","3700-4660","3740-4020","3740-5060","3820-4240","3820-4940","3840-4780","3920-4340","3920-4540","3940-4700","3940-4960","3980-4220","4020-5080","4060-4580","4060-4820","4120-4440","4140-5100","4160-4240","4180-4640","4280-4540","4300-4340","4300-4760" }, displayID = 49249 }; --Moonfang <Darkmoon Den Mot>
	[122899] = { zoneID = 408, artID = { 420 }, x = 2649, y = 3257, overlay = { "2640-3160","3040-3540","3040-3840","3120-3740","3140-3440","3240-3740","3280-3100","3280-3440","3280-3880","3280-4180","3300-3620","3300-4020","3320-4540","3400-3440","3440-3800","3440-4100","3500-4260","3520-3260","3520-3540","3520-3900","3520-4460","3600-4020","3640-3540","3640-3660","3640-4460","3640-4920","3660-3820","3660-4580","3660-4760","3680-3360","3680-4240","3740-3940","3740-4080","3740-4380","3760-3160","3780-4880","3800-3740","3820-3520","3820-4680","3840-4220","3860-4000","3880-3200","3880-3880","3880-5080","3940-3720","3940-4360","3960-3460","3960-4120","3960-4780","3980-3080","4000-3320","4000-3900","4020-4640","4020-4960","4040-4500","4060-5120","4080-3540","4080-4000","4080-4240","4080-4780","4100-3740","4120-4400","4140-4960","4160-3320","4160-4520","4180-4080","4180-5100","4200-3900","4200-4680","4220-3500","4220-4220","4240-3760","4300-4540","4320-3960","4340-3640","4340-4380","4340-4800","4360-3320","4360-4140","4400-3520","4400-5060","4420-3780","4460-3400","4460-4240","4460-4440","4480-4040","4520-4900","4540-3780","4540-5280","4560-4140","4580-4540","4660-4240" }, displayID = 77425 }; --Death Metal Knight
	[50331] = { zoneID = 418, artID = { 430,499 }, x = 3940, y = 2880, overlay = { "3940-2880","4040-2440" }, displayID = 44162 }; --Go-Kan
	[50340] = { zoneID = 418, artID = { 430,499 }, x = 5571, y = 3517, overlay = { "5340-3860","5400-3220","5620-2800","5620-3520","5620-3820","5860-3120","5860-3440" }, displayID = 44281 }; --Gaarn the Toxic
	[50352] = { zoneID = 418, artID = { 430,499 }, x = 7040, y = 1820, overlay = { "6720-2300","7040-1820" }, displayID = 44348 }; --Qu'nas
	[50388] = { zoneID = 418, artID = { 430,499 }, x = 1560, y = 3559, overlay = { "1420-3160","1440-3540","1460-3040","1560-3520" }, displayID = 44396 }; --Torik-Ethis
	[50768] = { zoneID = 418, artID = { 430,499 }, x = 3104, y = 3462, overlay = { "3060-3820","3100-3440" }, displayID = 44224 }; --Cournith Waterstrider
	[50787] = { zoneID = 418, artID = { 430,499 }, x = 5859, y = 4380, overlay = { "5620-4680","5860-4380" }, displayID = 44268 }; --Arness the Scale
	[50816] = { zoneID = 418, artID = { 430,499 }, x = 4283, y = 5286, overlay = { "3940-5520","4040-5280","4140-5520","4280-5280" }, displayID = 44371 }; --Ruun Ghostpaw
	[50830] = { zoneID = 418, artID = { 430,499 }, x = 5420, y = 8900, overlay = { "5220-8880","5420-8900" }, displayID = 44243 }; --Spriggin
	[68317] = { zoneID = 418, artID = { 430,499 }, x = 8900, y = 2680, overlay = { "8440-3100","8900-2680" }, friendly = { "A" }, displayID = 46743 }; --Mavis Harms <Champion of the Shad>
	[68318] = { zoneID = 418, artID = { 430,499 }, x = 8959, y = 2239, overlay = { "8480-2720","8940-2260" }, friendly = { "A" }, displayID = 46747 }; --Dalan Nightbreaker <Champion of A>
	[68319] = { zoneID = 418, artID = { 430,499 }, x = 9220, y = 2480, overlay = { "8740-2920","9220-2480" }, friendly = { "A" }, displayID = 46745 }; --Disha Fearwarden <Champion of the Li>
	[68320] = { zoneID = 418, artID = { 430,499 }, x = 1320, y = 6600, overlay = { "1220-6460","1300-6660" }, friendly = { "H" }, displayID = 46744 }; --Ubunti the Shade <Champion of the Shad>
	[68321] = { zoneID = 418, artID = { 430,499 }, x = 1400, y = 5700, overlay = { "1340-5480","1400-5700" }, friendly = { "H" }, displayID = 46748 }; --Kar Warmaker <Champion of A>
	[68322] = { zoneID = 418, artID = { 430,499 }, x = 1060, y = 5700, overlay = { "0960-5440","1040-5680" }, friendly = { "H" }, displayID = 46746 }; --Muerta <Champion of the Li>
	[50334] = { zoneID = 422, artID = { 434 }, x = 2520, y = 2860, overlay = { "2520-2840" }, displayID = 44166 }; --Dak the Breaker
	[50347] = { zoneID = 422, artID = { 434 }, x = 7180, y = 3760, overlay = { "7180-3740" }, displayID = 44285 }; --Karr the Darkener
	[50356] = { zoneID = 422, artID = { 434 }, x = 7297, y = 2203, overlay = { "7280-2220","7320-2040","7340-2340" }, displayID = 44351 }; --Krol the Blade
	[50739] = { zoneID = 422, artID = { 434 }, x = 3561, y = 3053, overlay = { "3560-3080","3780-2940","3920-4180" }, displayID = 44399 }; --Gar'lok
	[50776] = { zoneID = 422, artID = { 434 }, x = 6424, y = 5846, overlay = { "6420-5840" }, displayID = 44229 }; --Nalash Verdantis
	[50805] = { zoneID = 422, artID = { 434 }, x = 3615, y = 6366, overlay = { "3620-6240","3640-6120","3640-6400","3800-6360","3820-5800","3920-6240","3940-5860","3960-6040" }, displayID = 44271 }; --Omnis Grinlok
	[50821] = { zoneID = 422, artID = { 434 }, x = 3473, y = 2323, overlay = { "3480-2320" }, displayID = 44374 }; --Ai-Li Skymirror
	[50836] = { zoneID = 422, artID = { 434 }, x = 5534, y = 6354, overlay = { "5520-6380" }, displayID = 44250 }; --Ik-Ik the Nimble
	[70126] = { zoneID = 433, artID = { 445 }, x = 6380, y = 7560, overlay = { "5360-8220","5560-7360","6240-7460","6360-7360","6380-7540" }, displayID = 47874 }; --Willy Wilder
	[50328] = { zoneID = 465, artID = { 477 }, x = 6519, y = 7980, overlay = { "6080-7780","6160-7960","6280-8060","6400-8000","6400-8140","6520-7980" }, displayID = 46665 }; --Fangor
	[59369] = { zoneID = 479, artID = { 491 }, x = 3520, y = 3620, displayID = 40741 }; --Doctor Theolen Krastinov <The Butc>
	[50358] = { zoneID = 504, artID = { 521 }, x = 5020, y = 9080, overlay = { "4800-8880","4820-8720","4920-8640","4920-8980","5020-9080" }, displayID = 47695 }; --Haywire Sunreaver Construct
	[69099] = { zoneID = 504, artID = { 521 }, x = 6050, y = 3730, overlay = { "6050-3730" }, displayID = 47227, questReset = true, nameplate = true, questID = { 32518 } }; --Nalak <The Storm L>
	[69664] = { zoneID = 504, artID = { 521 }, x = 3500, y = 6260, overlay = { "3500-6240" }, displayID = 47873 }; --Mumta <Thief of So>
	[69996] = { zoneID = 504, artID = { 521 }, x = 3760, y = 8260, overlay = { "3300-8100","3420-8140","3540-8140","3680-8220" }, displayID = 47886 }; --Ku'lai the Skyclaw <Ward of Bea>
	[69997] = { zoneID = 504, artID = { 521 }, x = 5100, y = 7119, overlay = { "5100-7120" }, displayID = 47889 }; --Progenitus <The Firstb>
	[69998] = { zoneID = 504, artID = { 521 }, x = 5380, y = 5323, overlay = { "5360-5300" }, displayID = 47809 }; --Goda
	[69999] = { zoneID = 504, artID = { 521 }, x = 6160, y = 4980, overlay = { "6140-4940" }, displayID = 47595 }; --God-Hulk Ramuk
	[70000] = { zoneID = 504, artID = { 521 }, x = 4472, y = 2979, overlay = { "4460-3000" }, displayID = 47902 }; --Al'tabim the All-Seeing
	[70002] = { zoneID = 504, artID = { 521 }, x = 5460, y = 3579, overlay = { "5440-3540" }, displayID = 47917 }; --Lu-Ban <The War Craf>
	[70003] = { zoneID = 504, artID = { 521 }, x = 5959, y = 3613, overlay = { "5940-3640","6340-4900" }, displayID = 47900 }; --Molthor <The Gatekee>
	[70530] = { zoneID = 504, artID = { 521 }, x = 3960, y = 8120, overlay = { "3940-8140" }, displayID = 48097 }; --Ra'sha <Tender of Sacrifi>
	[70001] = { zoneID = 505, artID = { 522 }, x = 4459, y = 4100, overlay = { "3480-2720","3520-2560","3800-2680","4220-3220","4260-3380","4280-2900","4440-3660","4460-4100" }, displayID = 47810 }; --Backbreaker Uru
	[69161] = { zoneID = 507, artID = { 524 }, x = 5002, y = 5832, overlay = { "4990-5400","5002-5832" }, displayID = 47257, questReset = true, nameplate = true, questID = { 32519 } }; --Oondasta
	[70096] = { zoneID = 507, artID = { 524 }, x = 7860, y = 8060, overlay = { "7640-8340","7740-8240","7760-8020","7800-8380","7820-8140" }, displayID = 47868 }; --War-God Dokah <Ward of Bea>
	[70440] = { zoneID = 509, artID = { 526 }, x = 5840, y = 7759, displayID = 48053 }; --Monara <The Last Qu>
	[70276] = { zoneID = 510, artID = { 527 }, x = 2680, y = 2260, displayID = 47975 }; --No'ku Stormsayer <Lord of Temp>
	[70430] = { zoneID = 511, artID = { 528 }, x = 3960, y = 3920, displayID = 34264 }; --Rocky Horror
	[70238] = { zoneID = 513, artID = { 530 }, x = 6640, y = 2860, displayID = 47963 }; --Unblinking Eye
	[70243] = { zoneID = 513, artID = { 530 }, x = 4240, y = 6880, displayID = 47952 }; --Archritualist Kelada
	[70249] = { zoneID = 513, artID = { 530 }, x = 7600, y = 2900, overlay = { "7600-2900" }, displayID = 47963 }; --Focused Eye
	[70429] = { zoneID = 513, artID = { 530 }, x = 4473, y = 5910, displayID = 48039 }; --Flesh'rok the Diseased <Primordial Saurok Hor>
	[69843] = { zoneID = 514, artID = { 531 }, x = 0000, y = 0000, displayID = 48164 }; --Zao'cho <The Emperor's Shi>
	[50992] = { zoneID = 525, artID = { 542 }, x = 6459, y = 5200, overlay = { "2240-6600","5160-5040","5780-2040","5840-1920","6340-7960","6360-8100","6440-5240" }, displayID = 61218 }; --Gorok
	[71665] = { zoneID = 525, artID = { 542 }, x = 5471, y = 2237, overlay = { "5460-2220" }, displayID = 52167, questID = { 32918 } }; --Giant-Slayer Kul
	[71721] = { zoneID = 525, artID = { 542 }, x = 3380, y = 2300, overlay = { "3380-2300" }, displayID = 49096, questID = { 32941 } }; --Canyon Icemother
	[72156] = { zoneID = 525, artID = { 542 }, x = 6260, y = 4240, overlay = { "6260-4240" }, displayID = 52424, questID = { 33511 } }; --Borrok the Devourer
	[72294] = { zoneID = 525, artID = { 542 }, x = 4159, y = 4859, overlay = { "4040-4700","4140-4840","4160-4640" }, displayID = 38175, questID = { 33014 } }; --Cindermaw
	[72364] = { zoneID = 525, artID = { 542 }, x = 7100, y = 2740, overlay = { "7080-2760" }, displayID = 49769, questID = { 37562 } }; --Gorg'ak the Lava Guzzler
	[74613] = { zoneID = 525, artID = { 542 }, x = 6660, y = 3160, overlay = { "6500-3160","6660-3160" }, displayID = 54953, questID = { 33843 } }; --Broodmother Reeg'ak
	[74971] = { zoneID = 525, artID = { 542 }, x = 7140, y = 4680, overlay = { "7140-4680" }, displayID = 57874, questID = { 33504 } }; --Firefury Giant
	[76914] = { zoneID = 525, artID = { 542 }, x = 5419, y = 6794, overlay = { "5400-6820","5440-6960","5500-7120" }, displayID = 52652, questID = { 34131 } }; --Coldtusk
	[76918] = { zoneID = 525, artID = { 542 }, x = 3700, y = 3380, overlay = { "3700-3380" }, displayID = 52900, questID = { 33938 } }; --Primalist Mur'og
	[77513] = { zoneID = 525, artID = { 542 }, x = 2680, y = 5540, overlay = { "2540-5500","2620-5640" }, displayID = 52404, questID = { 34129 } }; --Coldstomp the Griever
	[77519] = { zoneID = 525, artID = { 542 }, x = 5761, y = 3754, overlay = { "5700-3800","5840-3160","5840-3540","5860-3360" }, displayID = 53946, questID = { 34130 } }; --Giantbane
	[77526] = { zoneID = 525, artID = { 542 }, x = 7640, y = 6340, overlay = { "7640-6340" }, displayID = 53943, questID = { 34132 } }; --Scout Goreseeker
	[77527] = { zoneID = 525, artID = { 542 }, x = 2691, y = 3190, overlay = { "2680-3140" }, displayID = 55865, questID = { 34133 } }; --The Beater <Champion of the Circle of Bl>
	[78128] = { zoneID = 525, artID = { 542 }, x = 5880, y = 3360, overlay = { "5740-3700","5840-3320","5840-3540","5860-3700" }, displayID = 54319, questID = { 34130 } }; --Gronnstalker Dawarn
	[78134] = { zoneID = 525, artID = { 542 }, x = 5880, y = 3340, overlay = { "5740-3700","5800-3520","5840-3320" }, displayID = 54321, questID = { 34130 } }; --Pathfinder Jalog
	[78144] = { zoneID = 525, artID = { 542 }, x = 5880, y = 3360, overlay = { "5740-3660","5820-3420","5860-3240" }, displayID = 54332, questID = { 34130 } }; --Giantslayer Kimla
	[78150] = { zoneID = 525, artID = { 542 }, x = 5940, y = 3120, overlay = { "5640-3740","5760-3620","5780-3760","5820-3200","5820-3320","5860-3480","5940-3120" }, displayID = 54337, questID = { 34130 } }; --Beastcarver Saramor
	[78151] = { zoneID = 525, artID = { 542 }, x = 5940, y = 3140, overlay = { "5640-3740","5760-3760","5820-3180","5820-3520","5840-3320","5940-3140" }, displayID = 54343, questID = { 34130 } }; --Huntmaster Kuang
	[78169] = { zoneID = 525, artID = { 542 }, x = 5880, y = 3420, overlay = { "5640-3740","5680-3860","5760-3760","5820-3220","5820-3420","5840-3540" }, displayID = 54345, questID = { 34130 } }; --Cloudspeaker Daber
	[78265] = { zoneID = 525, artID = { 542 }, x = 7219, y = 3300, overlay = { "7220-3300" }, displayID = 55699, questID = { 37361 } }; --The Bone Crawler
	[78606] = { zoneID = 525, artID = { 542 }, x = 2820, y = 6660, overlay = { "2820-6640" }, displayID = 54749, questID = { 34470 } }; --Pale Fishmonger
	[78621] = { zoneID = 525, artID = { 542 }, x = 6760, y = 7880, overlay = { "6640-7720","6640-7860","6760-7720","6760-7880" }, displayID = 47661, questID = { 34477 } }; --Cyclonic Fury
	[78867] = { zoneID = 525, artID = { 542 }, x = 2760, y = 5000, overlay = { "2740-5000" }, displayID = 47661, questID = { 34497 } }; --Breathless
	[79104] = { zoneID = 525, artID = { 542 }, x = 4040, y = 1220, overlay = { "4040-1220" }, displayID = 57149, questID = { 34522 } }; --Ug'lok the Frozen
	[79145] = { zoneID = 525, artID = { 542 }, x = 4060, y = 2780, overlay = { "4040-2740" }, displayID = 52170, questID = { 34559 } }; --Yaga the Scarred
	[80190] = { zoneID = 525, artID = { 542 }, x = 5180, y = 6480, overlay = { "5040-5240","5180-6480" }, displayID = 56636, questID = { 34825 } }; --Gruuk
	[80235] = { zoneID = 525, artID = { 542 }, x = 4700, y = 5520, overlay = { "4700-5520" }, displayID = 56636, questID = { 34839 } }; --Gurun <Son of S>
	[80242] = { zoneID = 525, artID = { 542 }, x = 4120, y = 6820, overlay = { "4120-6820" }, displayID = 55721, questID = { 34843 } }; --Chillfang
	[80312] = { zoneID = 525, artID = { 542 }, x = 3859, y = 6280, overlay = { "3840-6300" }, displayID = 55657, questID = { 34865 } }; --Grutush the Pillager
	[81001] = { zoneID = 525, artID = { 542 }, x = 1360, y = 5100, overlay = { "1300-5040" }, displayID = 61674 }; --Nok-Karosh <Warrior's De>
	[82536] = { zoneID = 525, artID = { 542 }, x = 3800, y = 1400, overlay = { "3800-1400" }, displayID = 57051, questID = { 37388 } }; --Gorivax <Spawn of the Soulgrin>
	[82614] = { zoneID = 525, artID = { 542 }, x = 4260, y = 2160, overlay = { "4240-2140" }, displayID = 58329, questID = { 37387 } }; --Moltnoma
	[82616] = { zoneID = 525, artID = { 542 }, x = 4866, y = 2336, overlay = { "4820-2420" }, displayID = 55133, questID = { 37386 } }; --Jabberjaw <Devourer of Og>
	[82617] = { zoneID = 525, artID = { 542 }, x = 4459, y = 1520, overlay = { "4460-1520" }, displayID = 57263, questID = { 37385 } }; --Slogtusk the Corpse-Eater
	[82618] = { zoneID = 525, artID = { 542 }, x = 4360, y = 0880, overlay = { "4340-0900" }, displayID = 52899, questID = { 37384 } }; --Tor'goroth <The Soul-Gor>
	[82620] = { zoneID = 525, artID = { 542 }, x = 3820, y = 1600, overlay = { "3820-1600" }, displayID = 57313, questID = { 37383 } }; --Son of Goramal
	[84374] = { zoneID = 525, artID = { 542 }, x = 8680, y = 4660, overlay = { "8680-4640" }, displayID = 58318, questID = { 37404 } }; --Kaga the Ironbender
	[84376] = { zoneID = 525, artID = { 542 }, x = 8419, y = 4660, overlay = { "8420-4640" }, displayID = 58318, questID = { 37403 } }; --Earthshaker Holar
	[84378] = { zoneID = 525, artID = { 542 }, x = 8849, y = 5746, overlay = { "8840-5740" }, displayID = 58319, questID = { 37525 } }; --Ak'ox the Slaughterer
	[84392] = { zoneID = 525, artID = { 542 }, x = 8680, y = 4900, overlay = { "8680-4900" }, displayID = 58330, questID = { 37401 } }; --Ragore Driftstalker
	[87348] = { zoneID = 525, artID = { 542 }, x = 6808, y = 1987, overlay = { "6800-1980" }, displayID = 58879, questID = { 37382 } }; --Hoarfrost <Tempest of>
	[87351] = { zoneID = 525, artID = { 542 }, x = 7260, y = 2260, overlay = { "7240-2280" }, displayID = 60566, questID = { 37381 } }; --Mother of Goren
	[87352] = { zoneID = 525, artID = { 542 }, x = 6660, y = 2540, overlay = { "6660-2540" }, displayID = 54953, questID = { 37380 } }; --Gibblette the Cowardly
	[87356] = { zoneID = 525, artID = { 542 }, x = 7060, y = 3900, overlay = { "7040-3920" }, displayID = 60457, questID = { 37379 } }; --Vrok the Ancient
	[87357] = { zoneID = 525, artID = { 542 }, x = 7280, y = 2500, overlay = { "6880-2880","6900-2740","6940-2580","6980-2980","7040-2440","7120-2900","7200-2400","7200-2720","7260-2600" }, displayID = 55835, questID = { 37378 } }; --Valkor <Might of the Mount>
	[87600] = { zoneID = 525, artID = { 542 }, x = 8500, y = 5220, overlay = { "8500-5220" }, displayID = 60386 }; --Jaluk the Pacifist
	[87622] = { zoneID = 525, artID = { 542 }, x = 8660, y = 4859, overlay = { "8420-4720","8440-4900","8560-4700","8600-4880" }, displayID = 58663, questID = { 37402 } }; --Ogom the Mangler
	[80398] = { zoneID = 534, artID = { 551 }, x = 3980, y = 8219, overlay = { "3980-8220" }, displayID = 55718, questID = { 37407 } }; --Keravnos
	[89675] = { zoneID = 534, artID = { 551 }, x = 5120, y = 4660, overlay = { "4720-4580","4780-4440","4820-4660","4940-4480","4940-4760","5020-4340","5060-4540","5120-4660" }, displayID = 63416, questID = { 38749 } }; --Commander Org'mok
	[90024] = { zoneID = 534, artID = { 551 }, x = 4280, y = 3660, overlay = { "4140-3740","4280-3640" }, displayID = 61851, questID = { 37953 } }; --Sergeant Mor'grak
	[90094] = { zoneID = 534, artID = { 551 }, x = 3960, y = 3259, overlay = { "3940-3240" }, displayID = 61867, questID = { 39046 } }; --Harbormaster Korak
	[90122] = { zoneID = 534, artID = { 551 }, x = 3700, y = 3300, overlay = { "3700-3300" }, displayID = 56178, questID = { 39045 } }; --Zoug the Heavy
	[90429] = { zoneID = 534, artID = { 551 }, x = 3160, y = 7260, overlay = { "3080-7160","3160-7260" }, displayID = 62118, questID = { 38026 } }; --Imp-Master Valessa
	[90434] = { zoneID = 534, artID = { 551 }, x = 3151, y = 6796, overlay = { "3140-6800" }, displayID = 62027, questID = { 38031 } }; --Ceraxas
	[90437] = { zoneID = 534, artID = { 551 }, x = 2660, y = 7520, overlay = { "2640-7540" }, displayID = 62187, questID = { 38030 } }; --Jax'zor
	[90438] = { zoneID = 534, artID = { 551 }, x = 2580, y = 7640, overlay = { "2540-7640" }, displayID = 54366, questID = { 38029 } }; --Lady Oran
	[90442] = { zoneID = 534, artID = { 551 }, x = 2580, y = 7960, overlay = { "2580-7920" }, displayID = 29442, questID = { 38032 } }; --Mistress Thavra
	[90519] = { zoneID = 534, artID = { 551 }, x = 4459, y = 3780, overlay = { "4440-3740" }, displayID = 58329, questID = { 37990 } }; --Cindral the Wildfire
	[90777] = { zoneID = 534, artID = { 551 }, x = 2260, y = 4000, overlay = { "2020-3740","2020-4020","2040-4140","2060-3860","2160-4080","2200-3720","2220-3900" }, displayID = 62123, questID = { 38028 } }; --High Priest Ikzan <Shadow Coun>
	[90782] = { zoneID = 534, artID = { 551 }, x = 1738, y = 4281, overlay = { "1740-4240" }, displayID = 7757, questID = { 38034 } }; --Rasthe <Son of Se>
	[90884] = { zoneID = 534, artID = { 551 }, x = 2360, y = 5200, overlay = { "2360-5200" }, displayID = 62140, questID = { 38262 } }; --Bilkor the Thrower <Bleeding Hollow Spearmas>
	[90885] = { zoneID = 534, artID = { 551 }, x = 2060, y = 5000, overlay = { "2040-4960" }, displayID = 62141, questID = { 38263 } }; --Rogond the Tracker <Bleeding Hollow Huntmas>
	[90887] = { zoneID = 534, artID = { 551 }, x = 2480, y = 4640, overlay = { "2080-5120","2120-4960","2220-5140","2240-4900","2340-4800","2420-4640" }, displayID = 60108, questID = { 38265 } }; --Dorg the Bloody <Bleeding Hollow Aberrat>
	[90888] = { zoneID = 534, artID = { 551 }, x = 2565, y = 4611, overlay = { "2540-4620" }, displayID = 62142, questID = { 38264 } }; --Drivnul <Master of Ritu>
	[90936] = { zoneID = 534, artID = { 551 }, x = 2460, y = 5000, overlay = { "2080-5260","2140-5380","2180-5140","2280-5300","2300-5080","2340-4940","2360-5200","2460-5000" }, displayID = 62169, questID = { 38266 } }; --Bloodhunter Zulk <Bleeding Hollow Assas>
	[91009] = { zoneID = 534, artID = { 551 }, x = 5760, y = 2320, overlay = { "5700-2240" }, displayID = 14173, questID = { 38457 } }; --Putre'thar
	[91087] = { zoneID = 534, artID = { 551 }, x = 4840, y = 2860, overlay = { "4820-2840" }, displayID = 61981, questID = { 38207 } }; --Zeter'el
	[91093] = { zoneID = 534, artID = { 551 }, x = 4103, y = 6850, overlay = { "3900-6840","3960-6980","4100-6760","4100-6880" }, displayID = 62258, questID = { 38209 } }; --Bramblefell
	[91098] = { zoneID = 534, artID = { 551 }, x = 5300, y = 2700, overlay = { "5220-2740","5260-2540" }, displayID = 20431, questID = { 38211 } }; --Felspark
	[91227] = { zoneID = 534, artID = { 551 }, x = 2220, y = 5060, overlay = { "2220-5040" }, displayID = 64424, questID = { 39159 } }; --Remnant of the Blood Moon
	[91232] = { zoneID = 534, artID = { 551 }, x = 1500, y = 5420, overlay = { "1500-5420" }, displayID = 62357, questID = { 38746 } }; --Commander Krag'goth
	[91243] = { zoneID = 534, artID = { 551 }, x = 1360, y = 5760, overlay = { "1340-5640","1340-5760" }, displayID = 63341, questID = { 38747 } }; --Tho'gar Gorefist
	[91374] = { zoneID = 534, artID = { 551 }, x = 1680, y = 4960, overlay = { "1680-4840","1680-4960" }, displayID = 62418, questID = { 38282 } }; --Podlord Wakkawam
	[91695] = { zoneID = 534, artID = { 551 }, x = 4759, y = 4120, overlay = { "4580-4240","4620-4060","4700-4280","4740-3980","4740-4100" }, displayID = 62706, questID = { 38400 } }; --Grand Warlock Nethekurse
	[91727] = { zoneID = 534, artID = { 551 }, x = 4980, y = 3620, overlay = { "4980-3620" }, displayID = 64023, questID = { 38411 } }; --Executor Riloth
	[91871] = { zoneID = 534, artID = { 551 }, x = 5259, y = 4060, overlay = { "5240-4020" }, displayID = 54516, questID = { 38430 } }; --Argosh the Destroyer
	[92197] = { zoneID = 534, artID = { 551 }, x = 2627, y = 5424, overlay = { "2620-5440" }, displayID = 63547, questID = { 38496 } }; --Relgor <Bleeding Hollow Master Sc>
	[92274] = { zoneID = 534, artID = { 551 }, x = 5360, y = 2160, overlay = { "5340-2140" }, displayID = 20385, questID = { 38557 } }; --Painmistress Selora
	[92408] = { zoneID = 534, artID = { 551 }, x = 6000, y = 2100, overlay = { "6000-2100" }, displayID = 20590, questID = { 38579 } }; --Xanzith the Everlasting
	[92411] = { zoneID = 534, artID = { 551 }, x = 5300, y = 1960, overlay = { "5220-1980" }, displayID = 63026, questID = { 38580 } }; --Overlord Ma'gruth <Shadow Coun>
	[92429] = { zoneID = 534, artID = { 551 }, x = 5760, y = 6720, overlay = { "5760-6720" }, displayID = 58756, questID = { 38589 } }; --Broodlord Ixkor
	[92451] = { zoneID = 534, artID = { 551 }, x = 2760, y = 3259, overlay = { "2740-3240" }, displayID = 62632, questID = { 37937 } }; --Varyx the Damned
	[92465] = { zoneID = 534, artID = { 551 }, x = 4920, y = 7360, overlay = { "4880-7300" }, displayID = 63052, questID = { 38597 } }; --The Blackfang <Warboss of the Blackf>
	[92495] = { zoneID = 534, artID = { 551 }, x = 6268, y = 7203, overlay = { "6260-7220" }, displayID = 63078, questID = { 38600 } }; --Soulslicer <Corrupted Sha>
	[92508] = { zoneID = 534, artID = { 551 }, x = 6357, y = 8122, overlay = { "6340-8100" }, displayID = 63082, questID = { 38604 } }; --Gloomtalon <Clawshaper of the Blackf>
	[92517] = { zoneID = 534, artID = { 551 }, x = 5203, y = 8393, overlay = { "5180-8340" }, displayID = 63093, questID = { 38605 } }; --Krell the Serene <Blademaster of the Blackf>
	[92552] = { zoneID = 534, artID = { 551 }, x = 3559, y = 4660, overlay = { "3540-4680" }, displayID = 63139, questID = { 38609 } }; --Belgork <Grom'kar Strikelea>
	[92574] = { zoneID = 534, artID = { 551 }, x = 3400, y = 4459, overlay = { "3400-4440" }, displayID = 55860, questID = { 38620 } }; --Thromma the Gutslicer
	[92606] = { zoneID = 534, artID = { 551 }, x = 4100, y = 7880, overlay = { "4100-7880" }, displayID = 51135, questID = { 38628 } }; --Sylissa <Marshwater Qu>
	[92627] = { zoneID = 534, artID = { 551 }, x = 4380, y = 7260, overlay = { "3720-6860","3780-6700","3880-7700","3900-7480","3920-6900","3920-7040","3940-7200","4020-7400","4060-7160","4120-7700","4140-7520","4200-7040","4240-7180","4240-7340","4240-7760","4260-7640","4340-7920","4360-7240","4360-7400" }, displayID = 63197, questID = { 38631 } }; --Rendrak <Direwing Al>
	[92636] = { zoneID = 534, artID = { 551 }, x = 4479, y = 7240, overlay = { "3680-6740","3680-7040","3800-6880","3800-7100","3800-7260","3800-7900","3840-7620","3920-7480","3940-7360","3980-7900","4040-7020","4040-7720","4060-7300","4180-6900","4200-7780","4260-7460","4340-6820","4380-7180","4380-7400","4400-7820","4420-7620" }, displayID = 63206, questID = { 38632 } }; --The Night Haunter
	[92645] = { zoneID = 534, artID = { 551 }, x = 4420, y = 7240, overlay = { "3740-6780","3820-7920","3840-7220","3880-7480","4040-7320","4080-7740","4120-6920","4220-7760","4280-7440","4380-6760","4420-7240" }, displayID = 63206, questID = { 38632 } }; --The Night Haunter
	[92647] = { zoneID = 534, artID = { 551 }, x = 4580, y = 4700, overlay = { "4580-4700" }, displayID = 63208, questID = { 38634 } }; --Felsmith Damorka
	[92657] = { zoneID = 534, artID = { 551 }, x = 5089, y = 7423, overlay = { "5080-7440" }, displayID = 63342, questID = { 38696 } }; --Bleeding Hollow Horror
	[92694] = { zoneID = 534, artID = { 551 }, x = 3460, y = 7260, overlay = { "3440-7240" }, displayID = 63223, questID = { 38654 } }; --The Goreclaw
	[92887] = { zoneID = 534, artID = { 551 }, x = 6559, y = 3680, overlay = { "6540-3680" }, displayID = 64723, questID = { 38700 } }; --Steelsnout
	[92941] = { zoneID = 534, artID = { 551 }, x = 3320, y = 3579, overlay = { "3260-3540" }, displayID = 62142, questID = { 38709 } }; --Gorabosh <Keeper of the C>
	[92977] = { zoneID = 534, artID = { 551 }, x = 1260, y = 5680, overlay = { "1240-5680" }, displayID = 58123, questID = { 38751 } }; --The Iron Houndmaster
	[93001] = { zoneID = 534, artID = { 551 }, x = 1660, y = 5620, overlay = { "1580-5740","1640-5620" }, displayID = 62816, questID = { 38752 } }; --Szirek the Twisted
	[93002] = { zoneID = 534, artID = { 551 }, x = 5220, y = 6519, overlay = { "5220-6520" }, displayID = 61301, questID = { 38726 } }; --Magwia
	[93028] = { zoneID = 534, artID = { 551 }, x = 2020, y = 5340, overlay = { "2000-5380" }, displayID = 63549, questID = { 38736 } }; --Driss Vile <Iron Horde Master Sni>
	[93057] = { zoneID = 534, artID = { 551 }, x = 1600, y = 5920, overlay = { "1600-5920" }, displayID = 62816, questID = { 38750 } }; --Grannok
	[93076] = { zoneID = 534, artID = { 551 }, x = 3660, y = 7960, overlay = { "3540-8040","3620-7900" }, displayID = 63424, questID = { 34727,38756 } }; --Captain Ironbeard <The True Scourge of the Iron S>
	[93125] = { zoneID = 534, artID = { 551 }, x = 3460, y = 7800, overlay = { "3440-7780" }, displayID = 19658, questID = { 38764 } }; --Glub'glok
	[93168] = { zoneID = 534, artID = { 551 }, x = 2860, y = 5077, overlay = { "2880-5100" }, displayID = 62261, questID = { 38775 } }; --Felbore
	[93236] = { zoneID = 534, artID = { 551 }, x = 4978, y = 6131, overlay = { "4960-6100" }, displayID = 21371, questID = { 38812 } }; --Shadowthrash
	[93264] = { zoneID = 534, artID = { 551 }, x = 4859, y = 5720, overlay = { "4840-5720" }, displayID = 63416, questID = { 38820 } }; --Captain Grok'mar
	[93279] = { zoneID = 534, artID = { 551 }, x = 3958, y = 6812, overlay = { "3960-6820" }, displayID = 63514, questID = { 38825 } }; --Kris'kar the Unredeemed <Crusader of Rukh>
	[95044] = { zoneID = 534, artID = { 551 }, x = 1580, y = 6380, overlay = { "1340-5940","1420-6060","1440-6180","1520-6360" }, displayID = 64258, questID = { 39288 } }; --Terrorfist <Son of Korm>
	[95053] = { zoneID = 534, artID = { 551 }, x = 2300, y = 4020, overlay = { "2300-4020" }, displayID = 64266, questID = { 39287 } }; --Deathtalon <Avatar of Is>
	[95054] = { zoneID = 534, artID = { 551 }, x = 3259, y = 7400, overlay = { "3240-7380" }, displayID = 64263, questID = { 39290 } }; --Vengeance <Avatar of Velh>
	[95056] = { zoneID = 534, artID = { 551 }, x = 4700, y = 5259, overlay = { "4700-5240" }, displayID = 63059, questID = { 39289 } }; --Doomroller <Mar'tak's Creat>
	[96235] = { zoneID = 534, artID = { 551 }, x = 6960, y = 3820, overlay = { "6900-3820" }, displayID = 62785 }; --Xemirkol
	[98283] = { zoneID = 534, artID = { 551 }, x = 8345, y = 4366, overlay = { "8340-4340" }, displayID = 65788, questID = { 40105 } }; --Drakum <Hollow's Sp>
	[98284] = { zoneID = 534, artID = { 551 }, x = 8036, y = 5684, overlay = { "8040-5660" }, displayID = 65789, questID = { 40106 } }; --Gondar <Hollow's>
	[98285] = { zoneID = 534, artID = { 551 }, x = 8812, y = 5581, overlay = { "8800-5580" }, displayID = 58598, questID = { 40104 } }; --Smashum Grabb <Hollow's F>
	[98408] = { zoneID = 534, artID = { 551 }, x = 8750, y = 5610, overlay = { "8750-5610" }, displayID = 65796, questID = { 40107 } }; --Fel Overseer Mudlump <Beater of Pe>
	[51015] = { zoneID = 535, artID = { 552 }, x = 8040, y = 5600, overlay = { "5500-8120","6200-4540","6240-3320","6240-4700","6720-5980","7940-5540" }, displayID = 61216 }; --Silthide
	[77529] = { zoneID = 535, artID = { 552 }, x = 5380, y = 2580, overlay = { "5380-2580" }, displayID = 53936, questID = { 34135 } }; --Yazheera the Incinerator
	[77561] = { zoneID = 535, artID = { 552 }, x = 6860, y = 1560, overlay = { "6820-1580" }, displayID = 53949, questID = { 34142 } }; --Dr. Gloom
	[77614] = { zoneID = 535, artID = { 552 }, x = 4620, y = 5500, overlay = { "4620-5500" }, displayID = 47651, questID = { 34145 } }; --Frenzied Golem <Vortex, Arcane Enchanted, Dampen>
	[77620] = { zoneID = 535, artID = { 552 }, x = 3760, y = 7040, overlay = { "3740-7040" }, displayID = 53979, questID = { 34165 } }; --Cro Fleshrender
	[77626] = { zoneID = 535, artID = { 552 }, x = 7840, y = 5080, overlay = { "7540-5080","7660-5040","7720-5160","7800-5040" }, displayID = 58713, questID = { 34167 } }; --Hen-Mother Hami
	[77634] = { zoneID = 535, artID = { 552 }, x = 5900, y = 8740, overlay = { "5880-8760" }, displayID = 54564, questID = { 34171 } }; --Taladorantula
	[77664] = { zoneID = 535, artID = { 552 }, x = 3660, y = 9600, overlay = { "3640-9600" }, friendly = { "A","H" }, displayID = 61239, questID = { 34182 } }; --Aarko
	[77715] = { zoneID = 535, artID = { 552 }, x = 6519, y = 4300, overlay = { "6020-4780","6100-4600","6120-4480","6140-4920","6220-4720","6240-4440","6360-4360","6360-4500","6520-4300" }, displayID = 52415, questID = { 34185 } }; --Hammertooth
	[77719] = { zoneID = 535, artID = { 552 }, x = 3320, y = 6360, overlay = { "3040-6420","3220-6360","3220-6560","3280-6240" }, displayID = 59748, questID = { 34189 } }; --Glimmerwing
	[77741] = { zoneID = 535, artID = { 552 }, x = 5940, y = 5959, overlay = { "5940-5940" }, displayID = 59725, questID = { 34196 } }; --Ra'kahn
	[77750] = { zoneID = 535, artID = { 552 }, x = 7860, y = 5560, overlay = { "7780-5660","7860-5560" }, displayID = 56084 }; --Kaavu the Crimson Claw
	[77776] = { zoneID = 535, artID = { 552 }, x = 6960, y = 3360, overlay = { "6940-3320" }, displayID = 54079, questID = { 34205 } }; --Wandering Vindicator
	[77784] = { zoneID = 535, artID = { 552 }, x = 4920, y = 9231, overlay = { "4900-9200" }, displayID = 54092, questID = { 34208 } }; --Lo'marg Jawcrusher
	[77795] = { zoneID = 535, artID = { 552 }, x = 3420, y = 5700, overlay = { "3420-5700" }, displayID = 39019, questID = { 34221 } }; --Echo of Murmur
	[77828] = { zoneID = 535, artID = { 552 }, x = 3400, y = 5720, overlay = { "3400-5720" }, friendly = { "A","H" }, displayID = 39019, questID = { 34221 } }; --Echo of Murmur
	[78710] = { zoneID = 535, artID = { 552 }, x = 5660, y = 6619, overlay = { "5620-6540","5640-6320","5640-6680" }, displayID = 18531, questID = { 35219 } }; --Kharazos the Triumphant
	[78713] = { zoneID = 535, artID = { 552 }, x = 5660, y = 6260, overlay = { "5620-6540","5640-6280" }, displayID = 20919, questID = { 35219 } }; --Galzomar
	[78715] = { zoneID = 535, artID = { 552 }, x = 5660, y = 6640, overlay = { "5620-6400","5620-6540" }, displayID = 21252, questID = { 35219 } }; --Sikthiss, Maiden of Slaughter
	[78872] = { zoneID = 535, artID = { 552 }, x = 6680, y = 8560, overlay = { "6680-8540" }, displayID = 46518, questID = { 34498 } }; --Klikixx
	[79334] = { zoneID = 535, artID = { 552 }, x = 8615, y = 2982, overlay = { "8580-2920","8640-3080" }, displayID = 18194, questID = { 34859 } }; --No'losh
	[79485] = { zoneID = 535, artID = { 552 }, x = 5380, y = 9100, overlay = { "5380-9100" }, displayID = 56284, questID = { 34668 } }; --Talonpriest Zorkra
	[80204] = { zoneID = 535, artID = { 552 }, x = 5080, y = 8380, overlay = { "4920-8340","4940-8520","5020-8620","5060-8340","5060-8460" }, displayID = 55632, questID = { 35018 } }; --Felbark
	[80471] = { zoneID = 535, artID = { 552 }, x = 6740, y = 8060, overlay = { "6740-8040" }, displayID = 55763, questID = { 34929 } }; --Gennadian
	[80524] = { zoneID = 535, artID = { 552 }, x = 6379, y = 2070, overlay = { "6360-2080" }, displayID = 55807, questID = { 34945 } }; --Underseer Bloodmane
	[82920] = { zoneID = 535, artID = { 552 }, x = 3100, y = 2680, overlay = { "3100-2680" }, displayID = 61253, questID = { 37345 } }; --Lord Korinak
	[82922] = { zoneID = 535, artID = { 552 }, x = 3759, y = 1464, overlay = { "3740-1460" }, displayID = 58310, questID = { 37343 } }; --Xothear, the Destroyer
	[82930] = { zoneID = 535, artID = { 552 }, x = 4100, y = 4200, overlay = { "4100-4200" }, displayID = 57394, questID = { 37347 } }; --Shadowflame Terrorwalker
	[82942] = { zoneID = 535, artID = { 552 }, x = 3360, y = 3780, overlay = { "3340-3780" }, displayID = 60856, questID = { 37346 } }; --Lady Demlash <Shadow Coun>
	[82988] = { zoneID = 535, artID = { 552 }, x = 3740, y = 3760, overlay = { "3740-3740" }, displayID = 57440, questID = { 37348 } }; --Kurlosh Doomfang <Shadow Coun>
	[82992] = { zoneID = 535, artID = { 552 }, x = 4760, y = 3292, overlay = { "4760-3280" }, displayID = 57441, questID = { 37341 } }; --Felfire Consort
	[82998] = { zoneID = 535, artID = { 552 }, x = 3875, y = 4978, overlay = { "3880-4940" }, displayID = 21252, questID = { 37349 } }; --Matron of Sin
	[83008] = { zoneID = 535, artID = { 552 }, x = 4800, y = 2520, overlay = { "4800-2520" }, displayID = 57459, questID = { 37312 } }; --Haakun the All-Consuming
	[83019] = { zoneID = 535, artID = { 552 }, x = 4759, y = 3900, overlay = { "4740-3920" }, displayID = 57470, questID = { 37340 } }; --Gug'tol <Shadow Coun>
	[85572] = { zoneID = 535, artID = { 552 }, x = 2220, y = 7420, overlay = { "2220-7420" }, displayID = 58979, questID = { 36919 } }; --Grrbrrgle
	[86549] = { zoneID = 535, artID = { 552 }, x = 6800, y = 3500, overlay = { "6740-3560" }, displayID = 59683, questID = { 36858 } }; --Steeltusk
	[87597] = { zoneID = 535, artID = { 552 }, x = 4479, y = 4100, overlay = { "4300-3780","4400-3980","4420-3720","4480-4100" }, displayID = 60385, questID = { 37339 } }; --Bombardier Gu'gok <Shadow Coun>
	[87668] = { zoneID = 535, artID = { 552 }, x = 3140, y = 4759, overlay = { "3140-4740" }, displayID = 60429, questID = { 37344 } }; --Orumo the Observer
	[88043] = { zoneID = 535, artID = { 552 }, x = 4820, y = 3520, overlay = { "4440-3440","4540-3200","4540-3640","4560-3420","4660-3520","4780-3580","4800-3440" }, displayID = 56554, questID = { 37338 } }; --Avatar of Socrethar <Shadow Coun>
	[88071] = { zoneID = 535, artID = { 552 }, x = 4759, y = 2860, overlay = { "4340-2700","4400-2840","4400-2980","4520-2680","4540-3080","4640-2880","4680-3120","4760-2860" }, displayID = 60730, questID = { 37337 } }; --Strategist Ankor <Sargerei War Coun>
	[88072] = { zoneID = 535, artID = { 552 }, x = 4759, y = 2860, overlay = { "4380-2640","4400-2840","4400-2980","4540-2680","4540-3080","4640-2880","4680-3100","4760-2840" }, displayID = 60728, questID = { 37337 } }; --Archmagus Tekar <Sargerei War Coun>
	[88083] = { zoneID = 535, artID = { 552 }, x = 4759, y = 2860, overlay = { "4340-2660","4380-2780","4400-2980","4460-2680","4540-3080","4560-2780","4640-2880","4680-3100","4720-2980","4760-2860" }, displayID = 60729, questID = { 37337 } }; --Soulbinder Naylana <Sargerei War Coun>
	[88436] = { zoneID = 535, artID = { 552 }, x = 3820, y = 4380, overlay = { "3640-4040","3720-4220","3760-4040" }, displayID = 60902, questID = { 37350 } }; --Vigilant Paarthos <Protector of Shattr>
	[88494] = { zoneID = 535, artID = { 552 }, x = 3800, y = 2060, overlay = { "3800-2040" }, displayID = 60931, questID = { 37342 } }; --Legion Vanguard
	[79543] = { zoneID = 537, artID = { 554 }, x = 6920, y = 2360, overlay = { "6620-2460","6920-2360" }, displayID = 58984, questID = { 34671 } }; --Shirzir
	[50883] = { zoneID = 539, artID = { 556 }, x = 5680, y = 5220, overlay = { "3860-3700","3960-3500","4240-3080","4320-3260","4420-4320","4580-6740","5320-3020","5620-5200" }, displayID = 61221 }; --Pathrunner
	[72362] = { zoneID = 539, artID = { 556 }, x = 3220, y = 3500, overlay = { "3220-3500" }, displayID = 53720, questID = { 33039 } }; --Ku'targ the Voidseer
	[72537] = { zoneID = 539, artID = { 556 }, x = 3768, y = 1440, overlay = { "3740-1440" }, displayID = 55451, questID = { 33055 } }; --Leaf-Reader Kurri
	[72606] = { zoneID = 539, artID = { 556 }, x = 5280, y = 5080, overlay = { "5280-5080" }, displayID = 53607, questID = { 34068 } }; --Rockhoof
	[74206] = { zoneID = 539, artID = { 556 }, x = 4080, y = 4440, overlay = { "4080-4440" }, displayID = 55523, questID = { 33043 } }; --Killmaw
	[75071] = { zoneID = 539, artID = { 556 }, x = 4400, y = 5740, overlay = { "4380-5760" }, displayID = 53061, questID = { 33642 } }; --Mother Om'ra <Chieft>
	[75434] = { zoneID = 539, artID = { 556 }, x = 4280, y = 4040, overlay = { "4260-4060" }, displayID = 56900, questID = { 33038 } }; --Windfang Matriarch
	[75435] = { zoneID = 539, artID = { 556 }, x = 4859, y = 6660, overlay = { "4820-6540","4860-6420","4860-6660" }, displayID = 54696, questID = { 33389 } }; --Yggdrel
	[75482] = { zoneID = 539, artID = { 556 }, x = 2180, y = 2100, overlay = { "2140-2080" }, displayID = 53360, questID = { 33640 } }; --Veloss
	[75492] = { zoneID = 539, artID = { 556 }, x = 5460, y = 7019, overlay = { "5440-7020" }, displayID = 53225, questID = { 33643 } }; --Venomshade
	[76380] = { zoneID = 539, artID = { 556 }, x = 3320, y = 3520, overlay = { "3320-3520" }, displayID = 54744, questID = { 33664 } }; --Gorum
	[77085] = { zoneID = 539, artID = { 556 }, x = 4859, y = 4360, overlay = { "4840-4340" }, displayID = 35903, questID = { 33064 } }; --Dark Emanation
	[77140] = { zoneID = 539, artID = { 556 }, x = 4159, y = 3279, overlay = { "2920-3080","2960-3220","3000-2960","3100-3220","3120-2860","3200-3300","3260-2800","3320-3360","3420-2820","3520-2900","3540-3500","3660-3580","3720-2960","3820-3660","3960-3640","4040-3540","4120-3080","4140-3280" }, displayID = 60896, questID = { 33061 } }; --Amaukwa <The Breath of M>
	[77310] = { zoneID = 539, artID = { 556 }, x = 4479, y = 2079, overlay = { "4440-2100" }, displayID = 57479, questID = { 35906 } }; --Mad King Sporeon
	[79524] = { zoneID = 539, artID = { 556 }, x = 3760, y = 4900, overlay = { "3740-4880" }, displayID = 55232, questID = { 35558 } }; --Hypnocroak
	[79686] = { zoneID = 539, artID = { 556 }, x = 6160, y = 6780, overlay = { "6140-6800" }, displayID = 54690, questID = { 34743 } }; --Silverleaf Ancient
	[79692] = { zoneID = 539, artID = { 556 }, x = 6160, y = 6780, overlay = { "6140-6740" }, displayID = 54691, questID = { 34743 } }; --Silverleaf Ancient
	[79693] = { zoneID = 539, artID = { 556 }, x = 6200, y = 6740, overlay = { "6160-6780" }, displayID = 55275, questID = { 34743 } }; --Silverleaf Ancient
	[81406] = { zoneID = 539, artID = { 556 }, x = 3060, y = 0660, overlay = { "2840-0520","2940-0660","2980-0520","3060-0660" }, displayID = 56398, questID = { 35281 } }; --Bahameye
	[81639] = { zoneID = 539, artID = { 556 }, x = 4500, y = 7759, overlay = { "4480-7720" }, displayID = 56713, questID = { 33383 } }; --Brambleking Fili
	[82207] = { zoneID = 539, artID = { 556 }, x = 6160, y = 6180, overlay = { "6160-6140" }, displayID = 56898, questID = { 35725 } }; --Faebright
	[82268] = { zoneID = 539, artID = { 556 }, x = 4260, y = 8380, overlay = { "3840-8360","3880-8240","3900-8100","4000-8320","4040-8160","4140-8280","4220-8380" }, displayID = 56933, questID = { 35448 } }; --Darkmaster Go'vid
	[82326] = { zoneID = 539, artID = { 556 }, x = 5280, y = 1660, overlay = { "5280-1640" }, displayID = 61022, questID = { 35731 } }; --Ba'ruun
	[82362] = { zoneID = 539, artID = { 556 }, x = 3859, y = 7060, overlay = { "3840-7040" }, displayID = 56962, questID = { 35523 } }; --Morva Soultwister <The Prop>
	[82374] = { zoneID = 539, artID = { 556 }, x = 4880, y = 2239, overlay = { "4860-2260" }, displayID = 36061, questID = { 35553 } }; --Rai'vosh
	[82411] = { zoneID = 539, artID = { 556 }, x = 4960, y = 4200, overlay = { "4940-4180" }, displayID = 59726, questID = { 35555 } }; --Darktalon
	[82415] = { zoneID = 539, artID = { 556 }, x = 6360, y = 5760, overlay = { "5920-5540","5920-5700","5980-5260","5980-5860","6000-5440","6040-5140","6120-5040","6140-5320","6140-5740","6160-4900","6180-5580","6260-5860","6280-5020","6320-5220","6320-5720","6340-5420","6360-5540" }, displayID = 61254, questID = { 35732 } }; --Shinri
	[82676] = { zoneID = 539, artID = { 556 }, x = 6780, y = 6380, overlay = { "6780-6380" }, displayID = 52573, questID = { 35688 } }; --Enavra
	[82742] = { zoneID = 539, artID = { 556 }, x = 6780, y = 6380, overlay = { "6780-6380" }, friendly = { "A","H" }, displayID = 52573, questID = { 35688 } }; --Enavra
	[83385] = { zoneID = 539, artID = { 556 }, x = 3259, y = 4159, overlay = { "3260-4140" }, displayID = 57526, questID = { 35847 } }; --Voidseer Kalurg
	[83553] = { zoneID = 539, artID = { 556 }, x = 5740, y = 4859, overlay = { "5740-4840" }, displayID = 57801, questID = { 35909 } }; --Insha'tar
	[84911] = { zoneID = 539, artID = { 556 }, x = 4600, y = 7180, overlay = { "4600-7140" }, displayID = 60685, questID = { 37351 } }; --Demidos <Devourer of Lig>
	[84925] = { zoneID = 539, artID = { 556 }, x = 5020, y = 7260, overlay = { "5000-7240" }, displayID = 58574, questID = { 37352 } }; --Quartermaster Hershak
	[85001] = { zoneID = 539, artID = { 556 }, x = 5200, y = 7960, overlay = { "5140-7680","5180-7820","5200-7960" }, displayID = 58607, questID = { 37353 } }; --Master Sergeant Milgra
	[85029] = { zoneID = 539, artID = { 556 }, x = 4820, y = 8080, overlay = { "4820-8080" }, displayID = 58619, questID = { 37354 } }; --Shadowspeaker Niir
	[85121] = { zoneID = 539, artID = { 556 }, x = 4800, y = 7759, overlay = { "4800-7740" }, displayID = 21455, questID = { 37355 } }; --Lady Temptessa <The Hidden Bl>
	[85451] = { zoneID = 539, artID = { 556 }, x = 2960, y = 5080, overlay = { "2960-5080" }, displayID = 58894, questID = { 37357 } }; --Malgosh Shadowkeeper
	[85555] = { zoneID = 539, artID = { 556 }, x = 6060, y = 8980, overlay = { "6040-9000" }, displayID = 55833, questID = { 37409 } }; --Nagidna
	[85568] = { zoneID = 539, artID = { 556 }, x = 6720, y = 8459, overlay = { "6700-8420" }, displayID = 57985, questID = { 37410 } }; --Avalanche
	[85837] = { zoneID = 539, artID = { 556 }, x = 6160, y = 8880, overlay = { "6140-8860" }, displayID = 29878, questID = { 37411 } }; --Slivermaw
	[86213] = { zoneID = 539, artID = { 556 }, x = 5080, y = 7900, overlay = { "5080-7900" }, displayID = 58879, questID = { 37356 } }; --Aqualir
	[86689] = { zoneID = 539, artID = { 556 }, x = 2760, y = 4360, overlay = { "2740-4340" }, displayID = 59853, questID = { 36880 } }; --Sneevel
	[79938] = { zoneID = 542, artID = { 559 }, x = 5180, y = 3559, overlay = { "5180-3540" }, displayID = 58947, questID = { 36478 } }; --Shadowbark
	[80372] = { zoneID = 542, artID = { 559 }, x = 6960, y = 5380, overlay = { "6920-5380" }, displayID = 55712, questID = { 37406 } }; --Echidna
	[80614] = { zoneID = 542, artID = { 559 }, x = 4681, y = 2324, overlay = { "4680-2300" }, displayID = 58821, questID = { 35599 } }; --Blade-Dancer Aeryx <Rukhmar's Ta>
	[82050] = { zoneID = 542, artID = { 559 }, x = 2960, y = 4200, overlay = { "2940-4140" }, displayID = 58892, questID = { 35334 } }; --Varasha
	[82247] = { zoneID = 542, artID = { 559 }, x = 3620, y = 5259, overlay = { "3620-5240" }, displayID = 56921, questID = { 36129 } }; --Nas Dunberlin <Executio>
	[83990] = { zoneID = 542, artID = { 559 }, x = 5197, y = 0725, overlay = { "5200-0740" }, displayID = 56656, questID = { 37394 } }; --Solar Magnifier
	[84417] = { zoneID = 542, artID = { 559 }, x = 5391, y = 8851, overlay = { "5340-8880","5460-8840" }, displayID = 58314, questID = { 36396 } }; --Mutafen <The Shamb>
	[84775] = { zoneID = 542, artID = { 559 }, x = 5720, y = 7380, overlay = { "5720-7380" }, displayID = 59469, questID = { 36254 } }; --Tesska the Broken
	[84805] = { zoneID = 542, artID = { 559 }, x = 3360, y = 2200, overlay = { "3340-2200" }, displayID = 58506, questID = { 36265 } }; --Stonespite
	[84807] = { zoneID = 542, artID = { 559 }, x = 4640, y = 2860, overlay = { "4640-2840" }, displayID = 58508, questID = { 36267 } }; --Durkath Steelmaw
	[84810] = { zoneID = 542, artID = { 559 }, x = 6280, y = 3760, overlay = { "6280-3740" }, displayID = 59470, questID = { 36268 } }; --Kalos the Bloodbathed
	[84833] = { zoneID = 542, artID = { 559 }, x = 6880, y = 4900, overlay = { "6880-4900" }, displayID = 60286, questID = { 36276 } }; --Sangrikass <Spawn of Se>
	[84836] = { zoneID = 542, artID = { 559 }, x = 5460, y = 6320, overlay = { "5440-6320" }, displayID = 58523, questID = { 36278 } }; --Talonbreaker <Bloodmane High Sha>
	[84838] = { zoneID = 542, artID = { 559 }, x = 5959, y = 3760, overlay = { "5940-3740" }, displayID = 58524, questID = { 36279 } }; --Poisonmaster Bortusk
	[84856] = { zoneID = 542, artID = { 559 }, x = 6520, y = 6800, overlay = { "6420-6520","6480-6640","6520-6780" }, displayID = 52740, questID = { 36283 } }; --Blightglow
	[84872] = { zoneID = 542, artID = { 559 }, x = 6500, y = 5400, overlay = { "6500-5400" }, displayID = 54715, questID = { 36288 } }; --Oskiira the Vengeful
	[84887] = { zoneID = 542, artID = { 559 }, x = 5840, y = 8419, overlay = { "5820-8440" }, displayID = 58549, questID = { 36291 } }; --Betsi Boombasket <Demolitions Exp>
	[84890] = { zoneID = 542, artID = { 559 }, x = 5480, y = 3980, overlay = { "5480-3940" }, displayID = 58554, questID = { 36297 } }; --Festerbloom
	[84912] = { zoneID = 542, artID = { 559 }, x = 5859, y = 4500, overlay = { "5840-4520" }, displayID = 58569, questID = { 36298 } }; --Sunderthorn <Queen of the Stingt>
	[84951] = { zoneID = 542, artID = { 559 }, x = 3360, y = 5880, overlay = { "3340-5880" }, displayID = 45374, questID = { 36305 } }; --Gobblefin
	[84955] = { zoneID = 542, artID = { 559 }, x = 5645, y = 9477, overlay = { "5640-9440" }, displayID = 55723, questID = { 36306 } }; --Jiasska the Sporegorger
	[85026] = { zoneID = 542, artID = { 559 }, x = 7260, y = 1960, overlay = { "7240-1940" }, displayID = 58618, questID = { 37358 } }; --Soul-Twister Torek
	[85036] = { zoneID = 542, artID = { 559 }, x = 7260, y = 1939, overlay = { "7200-1960" }, displayID = 60982, questID = { 37360 } }; --Formless Nightmare
	[85037] = { zoneID = 542, artID = { 559 }, x = 7060, y = 2420, overlay = { "7040-2380" }, displayID = 61035, questID = { 37361 } }; --Kenos the Unraveler
	[85078] = { zoneID = 542, artID = { 559 }, x = 7480, y = 3240, overlay = { "7300-3040","7300-3160","7400-3240" }, displayID = 58638, questID = { 37359 } }; --Voidreaver Urnae
	[85504] = { zoneID = 542, artID = { 559 }, x = 3839, y = 2797, overlay = { "3820-2780" }, displayID = 59514, questID = { 36470 } }; --Rotcap
	[85520] = { zoneID = 542, artID = { 559 }, x = 5280, y = 5480, overlay = { "5280-5480" }, displayID = 55425, questID = { 36472 } }; --Swarmleaf <Keeper of the H>
	[86621] = { zoneID = 542, artID = { 559 }, x = 7360, y = 4500, overlay = { "7340-4500" }, displayID = 18615 }; --Morphed Sentient
	[86724] = { zoneID = 542, artID = { 559 }, x = 5928, y = 1484, overlay = { "5920-1500" }, displayID = 59886, questID = { 36887 } }; --Hermit Palefur
	[86978] = { zoneID = 542, artID = { 559 }, x = 2520, y = 2420, overlay = { "2520-2420" }, displayID = 20526, questID = { 36943 } }; --Gaze
	[87019] = { zoneID = 542, artID = { 559 }, x = 7460, y = 4360, overlay = { "7440-4340" }, displayID = 61736, questID = { 37390 } }; --Gluttonous Giant
	[87026] = { zoneID = 542, artID = { 559 }, x = 7440, y = 3879, overlay = { "7420-3840" }, displayID = 60199, questID = { 37391 } }; --Mecha Plunderer
	[87027] = { zoneID = 542, artID = { 559 }, x = 7159, y = 3300, overlay = { "7120-3320" }, displayID = 58740, questID = { 37392 } }; --Shadow Hulk
	[87029] = { zoneID = 542, artID = { 559 }, x = 7159, y = 4479, overlay = { "7140-4480" }, displayID = 60145, questID = { 37393 } }; --Giga Sentinel
	[50985] = { zoneID = 543, artID = { 560 }, x = 5140, y = 4310, overlay = { "4200-2500","4320-5550","4540-4750","4700-5410","5140-4310" }, displayID = 61217 }; --Poundfist
	[76473] = { zoneID = 543, artID = { 560 }, x = 5340, y = 7819, overlay = { "5340-7820" }, displayID = 17180, questID = { 34726 } }; --Mother Araneae
	[79629] = { zoneID = 543, artID = { 560 }, x = 3815, y = 6628, overlay = { "3820-6620" }, displayID = 55225, questID = { 35910 } }; --Stomper Kreego <The Dr>
	[80371] = { zoneID = 543, artID = { 560 }, x = 7560, y = 4260, overlay = { "7540-4240" }, displayID = 55711, questID = { 37405 } }; --Typhon
	[80725] = { zoneID = 543, artID = { 560 }, x = 4120, y = 6100, overlay = { "4040-6020" }, displayID = 58882, questID = { 36394 } }; --Sulfurious
	[80868] = { zoneID = 543, artID = { 560 }, x = 4600, y = 5080, overlay = { "4600-5080" }, displayID = 56082, questID = { 36204 } }; --Glut
	[81038] = { zoneID = 543, artID = { 560 }, x = 4179, y = 4559, overlay = { "4180-4540" }, displayID = 55863, questID = { 36391 } }; --Gelgor of the Blue Flame
	[82058] = { zoneID = 543, artID = { 560 }, x = 7260, y = 4060, overlay = { "7240-4040" }, displayID = 56891, questID = { 37370 } }; --Depthroot
	[82085] = { zoneID = 543, artID = { 560 }, x = 4000, y = 7900, overlay = { "4000-7900" }, displayID = 57020, questID = { 35335 } }; --Bashiok
	[82311] = { zoneID = 543, artID = { 560 }, x = 5360, y = 4459, overlay = { "5340-4460" }, displayID = 61421, questID = { 35503 } }; --Char the Burning
	[83522] = { zoneID = 543, artID = { 560 }, x = 5240, y = 7014, overlay = { "5220-7020" }, displayID = 57771, questID = { 35908 } }; --Hive Queen Skrikka
	[84406] = { zoneID = 543, artID = { 560 }, x = 5060, y = 5320, overlay = { "5060-5320" }, displayID = 58334, questID = { 36178 } }; --Mandrakor
	[84431] = { zoneID = 543, artID = { 560 }, x = 4680, y = 4300, overlay = { "4680-4300" }, displayID = 54327, questID = { 36186 } }; --Greldrok the Cunning
	[85250] = { zoneID = 543, artID = { 560 }, x = 5735, y = 6864, overlay = { "5740-6840" }, displayID = 55055, questID = { 36387 } }; --Fossilwood the Petrified
	[85264] = { zoneID = 543, artID = { 560 }, x = 4780, y = 4159, overlay = { "4780-4120" }, displayID = 55755, questID = { 36393 } }; --Rolkor
	[85907] = { zoneID = 543, artID = { 560 }, x = 3940, y = 7460, overlay = { "3940-7460" }, displayID = 59205, questID = { 36597 } }; --Berthora
	[85970] = { zoneID = 543, artID = { 560 }, x = 3756, y = 8147, overlay = { "3740-8140" }, displayID = 59579, questID = { 36600 } }; --Riptar
	[86137] = { zoneID = 543, artID = { 560 }, x = 4459, y = 9220, overlay = { "4460-9220" }, displayID = 59384, questID = { 36656 } }; --Sunclaw
	[86257] = { zoneID = 543, artID = { 560 }, x = 6920, y = 4459, overlay = { "6920-4460" }, displayID = 57964, questID = { 37369 } }; --Basten
	[86258] = { zoneID = 543, artID = { 560 }, x = 6940, y = 4459, overlay = { "6940-4440" }, displayID = 57019, questID = { 37369 } }; --Nultra
	[86259] = { zoneID = 543, artID = { 560 }, x = 6940, y = 4459, overlay = { "6940-4440" }, displayID = 57020, questID = { 37369 } }; --Valstil
	[86266] = { zoneID = 543, artID = { 560 }, x = 6340, y = 3080, overlay = { "6340-3080" }, displayID = 61588, questID = { 37372 } }; --Venolasix
	[86268] = { zoneID = 543, artID = { 560 }, x = 7140, y = 4040, overlay = { "5620-4080","5860-4120","7140-4040" }, displayID = 59427, questID = { 37371 } }; --Alkali
	[86410] = { zoneID = 543, artID = { 560 }, x = 6540, y = 6080, overlay = { "6300-6160","6440-6080" }, displayID = 59571, questID = { 36794 } }; --Sylldross
	[86520] = { zoneID = 543, artID = { 560 }, x = 5489, y = 7117, overlay = { "5380-7320","5440-7140" }, displayID = 57735, questID = { 36837 } }; --Stompalupagus
	[86562] = { zoneID = 543, artID = { 560 }, x = 4900, y = 3300, overlay = { "4900-3300" }, displayID = 58895, questID = { 37363 } }; --Maniacal Madgard
	[86566] = { zoneID = 543, artID = { 560 }, x = 4825, y = 2082, overlay = { "4820-2100" }, displayID = 59693, questID = { 37362 } }; --Defector Dazgo <Iron Ho>
	[86571] = { zoneID = 543, artID = { 560 }, x = 4975, y = 2343, overlay = { "4960-2340" }, displayID = 55755, questID = { 37366 } }; --Durp the Hated
	[86574] = { zoneID = 543, artID = { 560 }, x = 4759, y = 3080, overlay = { "4760-3080" }, displayID = 59700, questID = { 37367 } }; --Inventor Blammo
	[86577] = { zoneID = 543, artID = { 560 }, x = 4600, y = 2780, overlay = { "4540-2580","4600-2780" }, displayID = 59702, questID = { 37365 } }; --Horgg
	[86579] = { zoneID = 543, artID = { 560 }, x = 4600, y = 3140, overlay = { "4580-3240" }, displayID = 59703, questID = { 37368 } }; --Blademaster Ro'gor
	[86582] = { zoneID = 543, artID = { 560 }, x = 4660, y = 2300, overlay = { "4580-2400","4660-2300" }, displayID = 59892, questID = { 37364 } }; --Morgo Kain <Emissary of Highm>
	[88580] = { zoneID = 543, artID = { 560 }, x = 5780, y = 3660, overlay = { "5780-3640" }, displayID = 58491, questID = { 37373 } }; --Firestarter Grash
	[88582] = { zoneID = 543, artID = { 560 }, x = 5959, y = 3200, overlay = { "5960-3200" }, displayID = 58756, questID = { 37374 } }; --Swift Onyx Flayer
	[88583] = { zoneID = 543, artID = { 560 }, x = 5959, y = 4300, overlay = { "5960-4300" }, displayID = 57964, questID = { 37375 } }; --Grove Warden Yal
	[88586] = { zoneID = 543, artID = { 560 }, x = 6160, y = 3920, overlay = { "6140-3920" }, displayID = 55211, questID = { 37376 } }; --Mogamago
	[88672] = { zoneID = 543, artID = { 560 }, x = 5480, y = 4620, overlay = { "5480-4620" }, displayID = 60623, questID = { 37377 } }; --Hunter Bal'ra
	[78260] = { zoneID = 549, artID = { 562 }, x = 4380, y = 7580, overlay = { "4140-7160","4140-7540","4220-7340","4380-7580" }, displayID = 54399, questID = { 37412 } }; --King Slime
	[78269] = { zoneID = 549, artID = { 562 }, x = 5880, y = 3740, overlay = { "4840-3760","5060-3820","5200-3680","5220-3520","5240-3320","5320-3220","5340-3820","5360-3660","5400-3040","5460-3220","5460-3860","5560-3360","5560-3480","5580-3720","5780-3660","5880-3740" }, displayID = 54318, questID = { 37413 } }; --Gnarljaw
	[50981] = { zoneID = 550, artID = { 567 }, x = 8419, y = 6360, overlay = { "6620-4400","7220-5380","7440-3240","7600-3060","7940-5500","7960-5640","8420-6360" }, displayID = 61220 }; --Luk'hok
	[50990] = { zoneID = 550, artID = { 567 }, x = 6440, y = 2000, overlay = { "5000-3420","5440-3560","6020-3200","6240-1480","6260-1800","6440-2000" }, displayID = 61219 }; --Nakk the Thunderer
	[78161] = { zoneID = 550, artID = { 567 }, x = 8700, y = 5480, overlay = { "8700-5480" }, displayID = 60442, questID = { 34862 } }; --Hyperious
	[79024] = { zoneID = 550, artID = { 567 }, x = 8260, y = 7619, overlay = { "8260-7620" }, displayID = 54837, questID = { 34645 } }; --Warmaster Blugthol <Gorian Head Centur>
	[79725] = { zoneID = 550, artID = { 567 }, x = 3460, y = 7700, overlay = { "3440-7680" }, displayID = 55286, questID = { 34727,38756 } }; --Captain Ironbeard <Scourge of the Iron S>
	[80057] = { zoneID = 550, artID = { 567 }, x = 7560, y = 6519, overlay = { "7540-6520" }, displayID = 55683, questID = { 36128 } }; --Soulfang
	[80122] = { zoneID = 550, artID = { 567 }, x = 4360, y = 7759, overlay = { "4340-7760" }, displayID = 55460, questID = { 34725 } }; --Gaz'orda
	[80370] = { zoneID = 550, artID = { 567 }, x = 5259, y = 9000, overlay = { "5180-8940" }, displayID = 55710, questID = { 37408 } }; --Lernaea
	[82486] = { zoneID = 550, artID = { 567 }, x = 8880, y = 4120, overlay = { "8880-4120" }, displayID = 57034, questID = { 35623 } }; --Explorer Nozzand <Steamwheedle Preservation Soci>
	[82755] = { zoneID = 550, artID = { 567 }, x = 7360, y = 5780, overlay = { "7360-5780" }, displayID = 57245, questID = { 35712 } }; --Redclaw the Feral
	[82758] = { zoneID = 550, artID = { 567 }, x = 6680, y = 5120, overlay = { "6680-5120" }, displayID = 60416, questID = { 35714 } }; --Greatfeather
	[82764] = { zoneID = 550, artID = { 567 }, x = 5220, y = 5579, overlay = { "5220-5580" }, displayID = 57251, questID = { 35715 } }; --Gar'lua <The Wolfmot>
	[82778] = { zoneID = 550, artID = { 567 }, x = 6660, y = 5660, overlay = { "6660-5640" }, displayID = 53744, questID = { 35717 } }; --Gnarlhoof the Rabid
	[82826] = { zoneID = 550, artID = { 567 }, x = 7700, y = 6419, overlay = { "7640-6440" }, displayID = 59990, questID = { 35735 } }; --Berserk T-300 Series Mark II <Ultimate Shredder the Sec>
	[82899] = { zoneID = 550, artID = { 567 }, x = 8459, y = 5360, overlay = { "8460-5340" }, displayID = 57365, questID = { 35778 } }; --Ancient Blademaster
	[82912] = { zoneID = 550, artID = { 567 }, x = 8940, y = 7260, overlay = { "8940-7240" }, displayID = 57383, questID = { 36051,35784 } }; --Grizzlemaw
	[82975] = { zoneID = 550, artID = { 567 }, x = 7480, y = 1180, overlay = { "7480-1180" }, displayID = 31786, questID = { 35836 } }; --Fangler
	[83401] = { zoneID = 550, artID = { 567 }, x = 4759, y = 7060, overlay = { "4740-7020" }, displayID = 9595, questID = { 35865 } }; --Netherspawn
	[83409] = { zoneID = 550, artID = { 567 }, x = 4540, y = 4740, overlay = { "3900-4900","4020-4940","4120-5120","4200-5020","4300-4940","4400-4840","4520-4760" }, displayID = 60197, questID = { 35875 } }; --Ophiis
	[83428] = { zoneID = 550, artID = { 567 }, x = 7060, y = 2920, overlay = { "7040-2920" }, displayID = 57702, questID = { 35877 } }; --Windcaller Korast <Tamer of Sto>
	[83483] = { zoneID = 550, artID = { 567 }, x = 6980, y = 4200, overlay = { "6980-4140" }, displayID = 57735, questID = { 35893 } }; --Flinthide
	[83509] = { zoneID = 550, artID = { 567 }, x = 9320, y = 2820, overlay = { "9320-2820" }, displayID = 57758, questID = { 35898 } }; --Gorepetal
	[83526] = { zoneID = 550, artID = { 567 }, x = 5780, y = 8380, overlay = { "5780-8340" }, displayID = 18279, questID = { 35900 } }; --Ru'klaa
	[83542] = { zoneID = 550, artID = { 567 }, x = 6080, y = 4759, overlay = { "6080-4760" }, displayID = 57788, questID = { 35912 } }; --Sean Whitesea <Master Highway>
	[83591] = { zoneID = 550, artID = { 567 }, x = 6489, y = 3912, overlay = { "6500-3920" }, displayID = 56062, questID = { 35920 } }; --Tura'aka
	[83603] = { zoneID = 550, artID = { 567 }, x = 8060, y = 3060, overlay = { "8040-3040" }, displayID = 57398, questID = { 35923 } }; --Hunter Blacktooth
	[83634] = { zoneID = 550, artID = { 567 }, x = 5480, y = 6120, overlay = { "5480-6120" }, displayID = 57846, questID = { 35931 } }; --Scout Pokhar
	[83643] = { zoneID = 550, artID = { 567 }, x = 8120, y = 6000, overlay = { "8120-6000" }, displayID = 57848, questID = { 35932 } }; --Malroc Stonesunder <Warsong Forward Comman>
	[83680] = { zoneID = 550, artID = { 567 }, x = 6180, y = 6900, overlay = { "6180-6900" }, displayID = 57878, questID = { 35943 } }; --Outrider Duretha
	[84263] = { zoneID = 550, artID = { 567 }, x = 8380, y = 3680, overlay = { "8340-3700" }, displayID = 58234, questID = { 36159 } }; --Graveltooth
	[84435] = { zoneID = 550, artID = { 567 }, x = 4559, y = 1520, overlay = { "4560-1520" }, displayID = 19658, questID = { 36229 } }; --Mr. Pinchy Sr.
	[86729] = { zoneID = 550, artID = { 567 }, x = 6020, y = 3859, overlay = { "6020-3840" }, displayID = 56848, reset = true }; --Direhoof
	[86732] = { zoneID = 550, artID = { 567 }, x = 6600, y = 2440, overlay = { "6100-1220","6220-1720","6240-1440","6240-1580","6340-1980","6460-2000","6520-2140","6580-2460" }, displayID = 58621, reset = true }; --Bergruu
	[86743] = { zoneID = 550, artID = { 567 }, x = 6419, y = 3040, overlay = { "6400-3060" }, displayID = 54470, reset = true }; --Dekorhan
	[86750] = { zoneID = 550, artID = { 567 }, x = 5211, y = 4033, overlay = { "4940-3800","5020-3700","5040-4000","5180-3940","5220-3560","5300-3940","5340-3500","5480-3460","5500-3340","5520-3800","5640-3680","5720-3180","5780-3580","5820-3060","5880-3480","5940-2980","6000-3280","6040-2840","6080-2720","6100-2520","6100-3140","6120-2280","6220-3020","6260-2280","6320-2460","6320-2920","6400-2820","6440-2620" }, displayID = 61652, reset = true }; --Thek'talon
	[86771] = { zoneID = 550, artID = { 567 }, x = 4814, y = 2206, overlay = { "4820-2220" }, displayID = 60220, reset = true }; --Gagrog the Brutal
	[86774] = { zoneID = 550, artID = { 567 }, x = 5157, y = 1606, overlay = { "5140-1600" }, displayID = 59928, reset = true }; --Aogexon
	[86835] = { zoneID = 550, artID = { 567 }, x = 4159, y = 4500, overlay = { "4140-4440" }, displayID = 61274, reset = true }; --Xelganak
	[86959] = { zoneID = 550, artID = { 567 }, x = 4580, y = 3480, overlay = { "4580-3480" }, displayID = 60200, questID = { 37399 } }; --Karosh Blackwind
	[87234] = { zoneID = 550, artID = { 567 }, x = 4300, y = 3620, overlay = { "4300-3620" }, displayID = 60198, questID = { 37400 } }; --Brutag Grimblade
	[87239] = { zoneID = 550, artID = { 567 }, x = 4260, y = 3620, overlay = { "4240-3640" }, displayID = 60253, questID = { 37473 } }; --Krahl Deadeye
	[87344] = { zoneID = 550, artID = { 567 }, x = 4260, y = 3620, overlay = { "4220-3660" }, displayID = 60268, questID = { 37472 } }; --Gortag Steelgrip
	[87666] = { zoneID = 550, artID = { 567 }, x = 3403, y = 5148, overlay = { "3400-5160" }, displayID = 61301, reset = true }; --Mu'gra
	[87788] = { zoneID = 550, artID = { 567 }, x = 3879, y = 2300, overlay = { "3540-2100","3560-2240","3640-2360","3700-1980","3780-2080","3840-2400","3860-2240" }, displayID = 61423, questID = { 37395 } }; --Durg Spinecrusher
	[87837] = { zoneID = 550, artID = { 567 }, x = 4003, y = 1317, overlay = { "3840-1500","3940-1320" }, displayID = 57863, questID = { 37396 } }; --Bonebreaker
	[87846] = { zoneID = 550, artID = { 567 }, x = 4140, y = 1400, overlay = { "3940-1440","4140-1400" }, displayID = 57863, questID = { 37397 } }; --Pit Slayer
	[88208] = { zoneID = 550, artID = { 567 }, x = 5820, y = 1840, overlay = { "5800-1860" }, displayID = 48084, questID = { 37637 } }; --Pit Beast
	[88210] = { zoneID = 550, artID = { 567 }, x = 5820, y = 1200, overlay = { "5820-1200" }, displayID = 61512, questID = { 37398 } }; --Krud the Eviscerator
	[88951] = { zoneID = 550, artID = { 567 }, x = 3723, y = 3898, overlay = { "3720-3900" }, displayID = 61300, reset = true }; --Vileclaw
	[98198] = { zoneID = 550, artID = { 567 }, x = 2596, y = 3471, overlay = { "2620-3420" }, displayID = 60608, questID = { 98198 } }; --Rukdug
	[98199] = { zoneID = 550, artID = { 567 }, x = 2815, y = 2962, overlay = { "2850-3030" }, displayID = 57973, questID = { 98199 } }; --Pugg
	[98200] = { zoneID = 550, artID = { 567 }, x = 2377, y = 3861, overlay = { "2380-3790" }, displayID = 65699, questID = { 98200 } }; --Guk
	[71864] = { zoneID = 554, artID = { 571 }, x = 5920, y = 4840, overlay = { "5800-4860","5920-4840" }, displayID = 40976 }; --Spelurk
	[71919] = { zoneID = 554, artID = { 571 }, x = 3745, y = 7741, overlay = { "3720-7720" }, displayID = 44361 }; --Zhu-Gon the Sour
	[72045] = { zoneID = 554, artID = { 571 }, x = 2520, y = 3600, overlay = { "2520-3540" }, displayID = 44784 }; --Chelon
	[72048] = { zoneID = 554, artID = { 571 }, x = 6060, y = 8780, overlay = { "6020-8740" }, displayID = 49277 }; --Rattleskew
	[72049] = { zoneID = 554, artID = { 571 }, x = 4380, y = 6960, overlay = { "4380-6940" }, displayID = 39588 }; --Cranegnasher
	[72193] = { zoneID = 554, artID = { 571 }, x = 3380, y = 8580, overlay = { "3380-8520" }, displayID = 29487 }; --Karkanos <The Gushing>
	[72245] = { zoneID = 554, artID = { 571 }, x = 4724, y = 8803, overlay = { "4700-8740" }, displayID = 51015 }; --Zesqua
	[72775] = { zoneID = 554, artID = { 571 }, x = 6489, y = 7483, overlay = { "6200-7640","6340-7300","6480-7420","6520-6920","6640-6720","6660-6540" }, displayID = 48112 }; --Bufo
	[72808] = { zoneID = 554, artID = { 571 }, x = 5420, y = 4280, overlay = { "5400-4240" }, displayID = 51132 }; --Tsavo'ka <Ghost in the Darkn>
	[72909] = { zoneID = 554, artID = { 571 }, x = 4202, y = 7323, overlay = { "3020-7100","3020-7280","3120-7020","3140-7440","3180-7600","3220-7740","3260-7080","3340-7940","3420-7100","3520-7000","3520-8000","3640-8060","3680-6940","3720-8220","3860-8220","3940-6980","4020-8280","4040-7920","4040-8140","4080-6920","4120-7760","4140-7100","4140-7260","4220-7400","4220-7600" }, displayID = 46461 }; --Gu'chi the Swarmbringer
	[72970] = { zoneID = 554, artID = { 571 }, x = 6320, y = 6120, overlay = { "6120-6380","6200-6240" }, displayID = 51013 }; --Golganarr
	[73158] = { zoneID = 554, artID = { 571 }, x = 4479, y = 5360, overlay = { "2940-5020","2980-4540","2980-6140","2980-6600","3000-6260","3020-5800","3040-4360","3040-6480","3060-5240","3080-5000","3100-6600","3120-6260","3120-7940","3160-4000","3200-5260","3220-4880","3220-8060","3320-3940","3620-3940","3620-4060","3640-8380","3760-4160","3920-4340","3920-6800","4000-3940","4040-4080","4040-4340","4220-7020","4240-6680","4240-6800","4340-5520","4420-6100","4440-5400" }, displayID = 51264 }; --Emerald Gander
	[73160] = { zoneID = 554, artID = { 571 }, x = 4459, y = 4380, overlay = { "2780-5120","2780-6000","2820-4020","2860-4740","2920-4300","2920-4440","2940-7140","2960-4580","2980-7000","3080-4740","3080-7080","3120-5760","3160-4320","3160-5880","3220-4480","3320-3860","3340-6120","3360-3720","3420-7100","3520-4180","3540-6740","3600-7060","3940-3840","4160-3960","4380-4380" }, displayID = 51284 }; --Ironfur Steelhorn
	[73161] = { zoneID = 554, artID = { 571 }, x = 2660, y = 7240, overlay = { "2060-4320","2100-4440","2140-6460","2140-6620","2200-4260","2200-6160","2220-5360","2220-6780","2240-4580","2260-6540","2300-4740","2320-6320","2320-6980","2340-4900","2340-6060","2360-5340","2380-5920","2440-5780","2540-5040","2540-5240","2540-5580","2560-5780","2580-5440","2580-7160" }, displayID = 51127 }; --Great Turtle Furyshell
	[73163] = { zoneID = 554, artID = { 571 }, x = 5300, y = 5880, overlay = { "2560-4640","2740-6140","2740-6920","2880-6200","2900-4340","2900-6360","2940-7320","3020-3660","3100-7540","3340-4560","3440-7420","3620-7360","4420-6620","5040-4620","5300-5840" }, displayID = 51135 }; --Imperial Python
	[73166] = { zoneID = 554, artID = { 571 }, x = 6880, y = 7480, overlay = { "1740-5240","1740-7260","1820-5460","1820-7520","1860-6400","1880-5780","2020-7700","2040-4800","2060-7080","2100-3620","2120-4680","2120-6420","2140-3260","2220-3100","2320-3440","2340-2840","2340-3580","2420-7500","2540-7440","2620-7340","2700-7520","2740-7980","2820-8120","3060-3120","3540-8700","3640-8620","3800-8600","3860-8720","4020-9060","4480-8920","4560-9040","5220-8660","6160-8320","6320-7980","6540-7780","6720-7760","6800-7420" }, displayID = 51146 }; --Monstrous Spineclaw
	[73167] = { zoneID = 554, artID = { 571 }, x = 5662, y = 5582, overlay = { "5740-5780","6500-5720","6540-3620","6600-5880","6660-5760","6720-5900","6860-5840","6940-5740","7240-5440","7300-5080","7420-4160","7440-4360","5662-5582" }, displayID = 51161 }; --Huolon <The Black W>
	[73169] = { zoneID = 554, artID = { 571 }, x = 5330, y = 8315, overlay = { "5300-8240" }, displayID = 51210 }; --Jakur of Ordon
	[73170] = { zoneID = 554, artID = { 571 }, x = 5758, y = 7676, overlay = { "5720-7640" }, displayID = 51211 }; --Watcher Osu
	[73171] = { zoneID = 554, artID = { 571 }, x = 7100, y = 4720, overlay = { "6060-4840","6100-4660","6140-4540","6240-4420","6420-4120","6420-4240","6540-4260","6540-6020","6640-5840","6660-4260","6720-5740","6780-4180","6820-4420","6840-5480","6840-5680","6920-5840","6940-4560","6960-4440","6960-5500","7020-5200","7040-4920","7040-5080","7080-4760","7100-4480","7100-4640" }, displayID = 51202 }; --Champion of the Black Flame
	[73172] = { zoneID = 554, artID = { 571 }, x = 4868, y = 3566, overlay = { "4040-2640","4080-2780","4380-3340","4640-3980","4840-3620","5540-3800" }, displayID = 51193 }; --Flintlord Gairan
	[73173] = { zoneID = 554, artID = { 571 }, x = 4435, y = 2705, overlay = { "4340-2600","4460-2540","4435-2705" }, displayID = 51194 }; --Urdur the Cauterizer
	[73174] = { zoneID = 554, artID = { 571 }, x = 5808, y = 2504, overlay = { "4840-3280","4960-3360","4980-2360","5040-2240","5060-2460","5540-3520","5660-2420","5660-3540","5720-2700","5800-2520" }, displayID = 51203 }; --Archiereus of Flame
	[73175] = { zoneID = 554, artID = { 571 }, x = 5460, y = 5380, overlay = { "5400-5240","5440-5360" }, displayID = 51192 }; --Cinderfall
	[73277] = { zoneID = 554, artID = { 571 }, x = 6725, y = 4421, overlay = { "6720-4400" }, displayID = 51206 }; --Leafmender
	[73279] = { zoneID = 554, artID = { 571 }, x = 3937, y = 9623, overlay = { "1360-3620","1400-3760","1400-5800","1420-2960","1420-5240","1440-4340","1440-4460","1460-5960","1480-5680","1540-6220","1560-2660","1620-6320","1640-2380","1680-2240","1740-2060","1760-6760","1820-6880","1920-7040","1940-7240","1960-1480","2080-7400","2080-7580","2200-7740","2220-7860","2380-0840","2400-8280","2620-8540","2700-0560","2840-8720","2880-0380","3120-8940","3260-9000","3640-9340","3920-9580","4040-9680","4160-0320","4460-9760","4580-0320","4920-9780","5080-9760","5700-0640","5900-9680","6140-9680","6360-9520","6500-9340","7100-8760","7440-1780","7600-2100","7820-2580","8020-3400" }, displayID = 37338 }; --Evermaw <Gnawing Hunger of the D>
	[73281] = { zoneID = 554, artID = { 571 }, x = 2600, y = 2340, overlay = { "2600-2340" }, displayID = 51213 }; --Dread Ship Vazuvius
	[73282] = { zoneID = 554, artID = { 571 }, x = 6500, y = 2740, overlay = { "6320-3000","6400-2720","6420-2840" }, displayID = 51214 }; --Garnia
	[73293] = { zoneID = 554, artID = { 571 }, x = 4280, y = 5940, overlay = { "3500-5240","4000-6300","4140-4740","4260-5960" }, friendly = { "A","H" }, displayID = 37498 }; --Whizzig <Merchant of T>
	[73666] = { zoneID = 554, artID = { 571 }, x = 3460, y = 3160, overlay = { "3420-3140","3440-3020" }, displayID = 51203 }; --Archiereus of Flame
	[73704] = { zoneID = 554, artID = { 571 }, x = 7119, y = 8260, overlay = { "7120-8240" }, displayID = 51813 }; --Stinkbraid <Southsea Capt>
	[72769] = { zoneID = 555, artID = { 572 }, x = 7480, y = 3460, overlay = { "4800-6120","4840-6380","5240-7260","5360-7160","5400-6800","5600-2880","5600-3080","6220-3380","6220-3800","6240-3500","6400-4780","6400-6320","6500-6440","6920-6100","7020-6220","7280-2860","7380-3100","7440-3240","7480-3460" }, displayID = 51316 }; --Spirit of Jadefire
	[73157] = { zoneID = 555, artID = { 572 }, x = 5000, y = 2940, overlay = { "4200-3320","4240-3200","4360-3440","4400-3000","4400-3260","4520-3120","4540-3260","4580-2140","4640-3360","4660-3240","4700-3480","4740-3620","4840-3040","4940-3560","4980-2760","5000-2940" }, displayID = 51118 }; --Rock Moss
	[96323] = { zoneID = {
				[579] = { x = 7400, y = 3540, artID = { 602 }, overlay = { "6820-3900","6940-3960","7040-3800","7240-3520","7240-3660","7360-3600" } };
				[580] = { x = 7400, y = 3540, artID = { 602 }, overlay = { "6820-3900","6940-3960","7040-3800","7240-3520","7240-3660","7360-3600" } };
				[581] = { x = 7400, y = 3540, artID = { 602 }, overlay = { "6820-3900","6940-3960","7040-3800","7240-3520","7240-3660","7360-3600" } };
				[582] = { x = 7400, y = 3540, artID = { 602 }, overlay = { "6820-3900","6940-3960","7040-3800","7240-3520","7240-3660","7360-3600" } };
				[585] = { x = 5710, y = 8856, artID = { 614 }, overlay = { "5520-8740","5600-8640","5660-8780","5720-8540","5760-8700","5760-8880" } };
				[586] = { x = 5710, y = 8856, artID = { 614 }, overlay = { "5520-8740","5600-8640","5660-8780","5720-8540","5760-8700","5760-8880" } };
				[587] = { x = 5710, y = 8856, artID = { 614 }, overlay = { "5520-8740","5600-8640","5660-8780","5720-8540","5760-8700","5760-8880" } };
				[590] = { x = 5710, y = 8856, artID = { 614 }, overlay = { "5520-8740","5600-8640","5660-8780","5720-8540","5760-8700","5760-8880" } };
			  }, displayID = 65160, questID = { 39617 } }; --Arachnis
	[82876] = { zoneID = 588, artID = { 611 }, x = 4520, y = 7940, overlay = { "4520-7940","4540-7600" }, friendly = { "A" }, displayID = 59096 }; --Grand Marshal Tremblade <Allliance War Capt>
	[82877] = { zoneID = 588, artID = { 611 }, x = 4820, y = 2560, overlay = { "4620-2180","4800-2860","4800-3040","4820-2540" }, friendly = { "H" }, displayID = 58184 }; --High Warlord Volrath <Horde War Capt>
	[82878] = { zoneID = 588, artID = { 611 }, x = 4520, y = 7940, overlay = { "4520-7940","4560-7600" }, friendly = { "A" }, displayID = 61636 }; --Marshal Gabriel
	[82880] = { zoneID = 588, artID = { 611 }, x = 4520, y = 7940, overlay = { "4520-7940","4540-7580" }, friendly = { "A" }, displayID = 59960 }; --Marshal Karsh Stormforge
	[82882] = { zoneID = 588, artID = { 611 }, x = 4840, y = 2620, overlay = { "4620-2180","4840-2620" }, friendly = { "H" }, displayID = 59969 }; --General Aevd
	[82883] = { zoneID = 588, artID = { 611 }, x = 4800, y = 2600, overlay = { "4640-2160","4800-2600" }, friendly = { "H" }, displayID = 59146 }; --Warlord Noktyn
	[83683] = { zoneID = 588, artID = { 611 }, x = 3080, y = 3060, overlay = { "3020-3140" }, displayID = 56932 }; --Mandragoraster
	[83691] = { zoneID = 588, artID = { 611 }, x = 5980, y = 5900, overlay = { "5840-5800","5940-5880" }, displayID = 59046 }; --Panthora
	[83713] = { zoneID = 588, artID = { 611 }, x = 6559, y = 6920, overlay = { "4900-5300" }, displayID = 60821 }; --Titarus
	[83819] = { zoneID = 588, artID = { 611 }, x = 6180, y = 3020, overlay = { "6180-3020","6280-2900" }, displayID = 57974 }; --Brickhouse <Mig>
	[84110] = { zoneID = 588, artID = { 611 }, x = 3700, y = 6700, overlay = { "3700-6640" }, displayID = 58134 }; --Korthall Soulgorger
	[84196] = { zoneID = 588, artID = { 611 }, x = 4459, y = 5300, overlay = { "3500-6060","3540-6620","3740-5540","3840-5660","3880-6200","3920-6440","4200-5920","4340-5780","4440-5300" }, displayID = 24925 }; --Web-wrapped Soldier
	[84465] = { zoneID = 588, artID = { 611 }, x = 6480, y = 7159, overlay = { "5540-7500","5620-7200","5800-6560","5800-7280","5840-6680","6080-6940","6240-7240","6340-6920","6480-7160" }, friendly = { "A","H" }, displayID = 54287 }; --Leaping Gorger
	[84746] = { zoneID = 588, artID = { 611 }, x = 6160, y = 3340, overlay = { "5440-3200","5860-2920","5880-3200","6020-3000","6140-2320","6140-3340" }, displayID = 53490 }; --Captured Gor'vosh Stoneshaper
	[84854] = { zoneID = 588, artID = { 611 }, x = 3879, y = 3960, overlay = { "3080-3000","3120-3140","3160-3460","3560-3580","3680-3500","3720-3880","3780-3600","3860-3880" }, friendly = { "A","H" }, displayID = 58535 }; --Slippery Slime
	[84875] = { zoneID = 588, artID = { 611 }, x = 3400, y = 5020, overlay = { "3400-5020" }, displayID = 61521 }; --Ancient Inferno
	[84893] = { zoneID = 588, artID = { 611 }, x = 3579, y = 5320, overlay = { "3440-5320","3580-5320" }, displayID = 52698 }; --Goregore
	[84904] = { zoneID = 588, artID = { 611 }, x = 3420, y = 4700, overlay = { "3180-4920","3220-4720","3260-4600","3420-4640" }, displayID = 58566 }; --Oraggro
	[84926] = { zoneID = 588, artID = { 611 }, x = 3800, y = 5060, overlay = { "3180-5020","3260-4660","3440-5260","3460-4760","3580-5300","3660-4960","3680-4840","3720-5200","3800-4980" }, friendly = { "A","H" }, displayID = 0 }; --Burning Power
	[85763] = { zoneID = 588, artID = { 611 }, x = 5940, y = 3740, overlay = { "5940-3740" }, displayID = 59148 }; --Cursed Ravager
	[85766] = { zoneID = 588, artID = { 611 }, x = 5859, y = 4220, overlay = { "5859-4220" }, displayID = 59468 }; --Cursed Sharptalon
	[85767] = { zoneID = 588, artID = { 611 }, x = 5880, y = 3879, overlay = { "5880-3879" }, displayID = 59473 }; --Cursed Harbinger
	[85771] = { zoneID = 588, artID = { 611 }, x = 5980, y = 4320, overlay = { "5980-4320" }, displayID = 59472 }; --Elder Darkweaver Kath
	[87362] = { zoneID = 588, artID = { 611 }, x = 4980, y = 3660, overlay = { "4740-6900","4760-2840","4780-3020","4840-5880","4980-3660" }, displayID = 46574 }; --Gibby <Hemet Nesingwary's>
	[91921] = { zoneID = 588, artID = { 611 }, x = 5400, y = 5800, overlay = { "5400-5800" }, displayID = 59296 }; --Wyrmple
	[94113] = { zoneID = 588, artID = { 611 }, x = 4179, y = 4640, overlay = { "4180-4640" }, displayID = 63877 }; --Rukmaz
	[77081] = { zoneID = 618, artID = { 641 }, x = 3540, y = 3740, displayID = 53656 }; --The Lanticore
	[116041] = { zoneID = {
				[628] = { x = 7980, y = 8480, artID = { 651 }, overlay = { "2820-4620","2900-4520","3000-4240","3020-4620","3120-4260","3240-4320","3340-4400","3440-4320","3560-4340","3700-4380","3700-5180","3740-4220","3840-4540","3880-4220","3900-5060","3920-4380","4100-5160","4140-4600","4140-5280","4240-4280","4260-5020","4320-4400","4400-3960","4400-4720","4400-4920","4420-4220","4420-4540","4440-5120","4480-5820","4500-5340","4560-4620","4600-4740","4600-4940","4700-4580","4700-5800","4720-5920","4760-4860","4760-5100","4800-4980","4820-4720","4840-5720","4860-5560","4880-4840","4900-5980","4920-5860","4940-6300","4960-5400","4980-4640","5000-5680","5040-5800","5040-6060","5060-6600","5080-5460","5100-4560","5100-5160","5120-5900","5120-6240","5160-5780","5180-6360","5180-6540","5200-5580","5200-6820","5220-4100","5220-5400","5220-6000","5220-6160","5240-5880","5260-4420","5300-4260","5320-5680","5340-5180","5360-5920","5380-6320","5380-6600","5400-4400","5400-5780","5400-6120","5520-3780","5520-6000","5540-4460","5540-6240","5540-6380","5540-6620","5560-3660","5560-5800","5560-6900","5580-4660","5660-4340","5660-6060","5660-6200","5660-6600","5680-3700","5680-3920","5680-4060","5680-4460","5700-4660","5720-6440","5720-6780","5740-4180","5740-4780","5740-5940","5760-5060","5780-4560","5780-7000","5800-6320","5820-4440","5820-6160","5840-4040","5840-4680","5840-6620","5860-4200","5860-4900","5860-7120","5880-6760","5880-7540","5900-4340","5900-7340","5900-7680","5940-6340","5960-4060","5960-5080","5960-6660","5980-3860","5980-4640","5980-4760","6000-7100","6000-7520","6020-4460","6020-6120","6020-6480","6020-6840","6020-7660","6020-7940","6040-4960","6040-6980","6080-3720","6080-7800","6100-4620","6100-6700","6120-5120","6120-6280","6120-6400","6160-7900","6220-4520","6240-4380","6240-5300","6240-6480","6240-6600","6260-6360","6280-6820","6280-7940","6300-4640","6300-5180","6320-6240","6360-4460","6360-6480","6380-4800","6440-3080","6460-8000","6500-5460","6500-7840","6560-2860","6580-7960","6620-7500","6640-7760","6660-7620","6760-7720","6760-7960","6820-2340","6860-1740","6880-2200","6900-8320","6920-2020","6920-7680","6920-8080","6940-1840","6960-1480","7000-1600","7020-1320","7020-2260","7040-8140","7060-1920","7100-1420","7100-8300","7240-1680","7240-8240","7340-8400","7360-8220","7460-8360","7520-8200","7520-8480","7560-8680","7660-8400","7680-8020","7680-8140","7680-8620","7800-8100","7800-8440","7800-8620","7840-8300","7920-8200","7980-8340","7980-8480" } };
				[630] = { x = 6559, y = 3720, artID = { 653 }, overlay = { "4620-4760","5200-1120","5340-5880","5780-2840","6080-3600","6480-3120","6500-3660" } };
				[634] = { x = 7320, y = 5740, artID = { 657 }, overlay = { "3680-2680","3800-4060","4120-6340","4500-5460","4600-4100","5920-3000","6220-5400","6580-4760","7300-5760" } };
				[641] = { x = 7100, y = 4680, artID = { 664 }, overlay = { "4720-5520","4900-7720","4940-8420","5400-6740","5720-6180","6220-7200","6320-4200","6520-7580","6540-7700","6560-6780","7100-4680" } };
				[650] = { x = 5680, y = 5859, artID = { 674 }, overlay = { "2780-4160","3740-6600","3780-4060","4320-5040","4540-5520","4740-3280","4780-1060","4920-7100","4940-4340","5060-4360","5680-5860" } };
				[680] = { x = 7200, y = 5900, artID = { 704 }, overlay = { "2140-2660","2340-6020","2800-4560","2860-6020","3040-3400","3920-3840","3920-3960","6000-4140","7200-5900" } };
				[750] = { x = 3820, y = 1639, artID = { 775 }, overlay = { "3700-1440","3820-1640" } };
			  }, displayID = 61712 }; --null
	[97380] = { zoneID = 628, artID = { 651 }, x = 6020, y = 7260, overlay = { "4880-5940","4920-6100","4920-6340","5040-6020","5040-6600","5080-6400","5140-6240","5200-6840","5240-6100","5240-6620","5260-6280","5280-6740","5300-6440","5340-5900","5360-6900","5380-6080","5400-6280","5420-6580","5420-6780","5500-5960","5500-6420","5500-6680","5500-6920","5540-6280","5560-7060","5580-6540","5580-6780","5600-6080","5660-6660","5680-6340","5700-6520","5700-7040","5740-6200","5780-6640","5780-6880","5860-6440","5880-6100","5900-6860","5900-7040","5940-6260","6020-7260" }, displayID = 65195 }; --Splint
	[97381] = { zoneID = 628, artID = { 651 }, x = 6000, y = 7140, overlay = { "4580-5220","4980-5860","5020-5520","5060-6100","5080-5960","5100-5720","5200-6180","5240-5480","5240-6340","5280-6000","5320-5680","5420-6000","5440-6240","5440-6480","5500-5900","5500-6360","5560-6040","5580-6820","5620-6400","5620-6600","5740-6400","5760-6200","5780-7080","5800-6660","6000-7140" }, displayID = 57484 }; --Screek
	[97384] = { zoneID = 628, artID = { 651 }, x = 7159, y = 2120, overlay = { "6600-2180","6620-2060","6720-2260","6720-2440","6740-2040","6760-1820","6820-2360","6880-1980","6880-2100","6900-1640","6900-1840","6920-2460","6920-2600","6940-2220","7000-2100","7060-2340","7080-2200","7080-2500","7140-2020" }, displayID = 12200 }; --Segacedi
	[97387] = { zoneID = 628, artID = { 651 }, x = 5800, y = 4240, overlay = { "4680-3540","4840-3680","4920-3800","5040-4040","5180-3960","5200-4140","5340-4260","5540-3720","5620-3900","5660-4440","5780-4020","5800-4240" }, displayID = 61125 }; --Mana Seeper
	[97388] = { zoneID = 628, artID = { 651 }, x = 5840, y = 6619, overlay = { "3220-4320","3560-4320","3700-4540","3720-4340","3840-4240","3920-4480","3960-4260","3980-4140","4100-4220","4200-4300","4360-4420","4560-4680","5840-6620" }, displayID = 65157 }; --Xullorax
	[97390] = { zoneID = 628, artID = { 651 }, x = 7520, y = 8400, overlay = { "3840-4560","3860-4440","3860-4680","3920-5180","3980-5380","4020-4320","4040-4140","4140-4220","4220-4340","4340-4460","4440-4280","4480-4580","4580-4740","4700-4800","4940-5920","4980-5040","5020-5180","5040-5420","5160-6100","5400-6340","6300-7080","6460-6980","7120-8180","7240-8240","7500-8240","7520-8400" }, displayID = 57377 }; --Thieving Scoundrel
	[97587] = { zoneID = 628, artID = { 651 }, x = 6160, y = 7080, overlay = { "5740-6980","5820-7080","5840-6780","5880-6920","5880-7220","5980-7000","5980-7120","6000-7380","6040-6780","6120-6900","6140-7020" }, displayID = 47090 }; --Crazed Mage
	[97589] = { zoneID = 628, artID = { 651 }, x = 6360, y = 4740, overlay = { "6200-4320","6200-4460","6220-4580","6340-4700" }, displayID = 36525 }; --Rotten Egg
	[123087] = { zoneID = 629, artID = { 652 }, x = 4460, y = 2540, overlay = { "4460-2540","4540-2660","4640-2780","4780-2880" }, friendly = { "A","H" }, displayID = 78148 }; --Al'Abas <The Magnific>
	[102064] = { zoneID = 630, artID = { 653 }, x = 3720, y = 8359, overlay = { "3720-8360" }, displayID = 71821, questID = { 44035 } }; --Torrentius <The Raging St>
	[103975] = { zoneID = 630, artID = { 653 }, x = 4080, y = 7680, overlay = { "4020-7660" }, displayID = 71941, questID = { 43957 } }; --Jade Darkhaven <Felsworn Comman>
	[105938] = { zoneID = 630, artID = { 653 }, x = 4360, y = 2460, overlay = { "4340-2440" }, displayID = 69438, questID = { 42069 } }; --Felwing
	[106990] = { zoneID = 630, artID = { 653 }, x = 6565, y = 5690, overlay = { "6520-5640" }, displayID = 66509, questID = { 42221 } }; --Chief Bitterbrine
	[107105] = { zoneID = 630, artID = { 653 }, x = 3320, y = 4159, overlay = { "3320-4140" }, displayID = 65926, questID = { 44670 } }; --Broodmother Lizax
	[107113] = { zoneID = 630, artID = { 653 }, x = 3728, y = 4320, overlay = { "3680-4360" }, displayID = 69841, questID = { 42280 } }; --Vorthax
	[107127] = { zoneID = 630, artID = { 653 }, x = 5520, y = 4580, overlay = { "5520-4580" }, displayID = 66814, questID = { 42450 } }; --Brawlgoth
	[107136] = { zoneID = 630, artID = { 653 }, x = 3080, y = 4780, overlay = { "3020-4840" }, displayID = 18345, questID = { 42286 } }; --Houndmaster Stroxis
	[107169] = { zoneID = 630, artID = { 653 }, x = 3080, y = 4780, overlay = { "3020-4840","3080-4640" }, displayID = 62737, questID = { 42286 } }; --Horux
	[107170] = { zoneID = 630, artID = { 653 }, x = 3080, y = 4759, overlay = { "3040-4740","3060-4860" }, displayID = 62737, questID = { 42286 } }; --Zorux
	[107266] = { zoneID = 630, artID = { 653 }, x = 2780, y = 5100, overlay = { "2780-5100" }, displayID = 68039, questID = { 44673 } }; --Commander Soraax
	[107269] = { zoneID = 630, artID = { 653 }, x = 2820, y = 5200, overlay = { "2820-5200" }, displayID = 69190, questID = { 42376 } }; --Inquisitor Tivos
	[107327] = { zoneID = 630, artID = { 653 }, x = 2940, y = 5340, overlay = { "2920-5360" }, displayID = 65280, questID = { 42417 } }; --Bilebrain
	[107657] = { zoneID = 630, artID = { 653 }, x = 3600, y = 3400, overlay = { "3500-3380" }, displayID = 70214, questID = { 42505 } }; --Arcanist Shal'iman
	[107960] = { zoneID = 630, artID = { 653 }, x = 3340, y = 0480, overlay = { "3340-0480" }, friendly = { "A","H" }, displayID = 66423 }; --Alluvanon
	[108136] = { zoneID = 630, artID = { 653 }, x = 5859, y = 7960, overlay = { "5840-7880" }, displayID = 70411, questID = { 44671 } }; --The Muscle <Blacksail C>
	[108255] = { zoneID = 630, artID = { 653 }, x = 5562, y = 7011, overlay = { "5540-7000" }, displayID = 70491, questID = { 42699 } }; --Coura, Mistress of Arcana
	[108366] = { zoneID = 630, artID = { 653 }, x = 6340, y = 5400, overlay = { "3700-2160","4400-5980","4720-6200","4980-5400","5180-5760","5560-1020","5680-2580","5700-3120","5740-1660","5820-2460","6340-5400" }, friendly = { "A","H" }, displayID = 3211 }; --Long-Forgotten Hippogryph
	[109504] = { zoneID = 630, artID = { 653 }, x = 3259, y = 4872, overlay = { "3260-4880" }, displayID = 20914, questID = { 44108 } }; --Ragemaw
	[109575] = { zoneID = 630, artID = { 653 }, x = 5820, y = 2140, overlay = { "5820-2140" }, displayID = 70161, questID = { 45515 } }; --Valakar the Thirsty
	[109584] = { zoneID = 630, artID = { 653 }, x = 6660, y = 4000, overlay = { "6600-4020","6660-3900" }, displayID = 67253, questID = { 45499 } }; --Fjordun
	[109594] = { zoneID = 630, artID = { 653 }, x = 5120, y = 5740, overlay = { "5100-5800" }, displayID = 65235, questID = { 45497 } }; --Stormfeather
	[109620] = { zoneID = 630, artID = { 653 }, x = 4360, y = 0819, overlay = { "4320-0780" }, displayID = 66889 }; --The Whisperer
	[109630] = { zoneID = 630, artID = { 653 }, x = 2860, y = 4980, overlay = { "2840-4840","2840-4960" }, displayID = 68732, questID = { 45495 } }; --Immolian
	[109641] = { zoneID = 630, artID = { 653 }, x = 5700, y = 1100, overlay = { "5700-1100" }, displayID = 71119, questID = { 45494 } }; --Arcanor Prime
	[109653] = { zoneID = 630, artID = { 653 }, x = 3420, y = 2800, overlay = { "3380-2860" }, displayID = 71125, questID = { 45492 } }; --Marblub the Massive
	[109677] = { zoneID = 630, artID = { 653 }, x = 5880, y = 7680, overlay = { "5880-7660" }, displayID = 13991, questID = { 45491 } }; --Chief Treasurer Jabrill <Blacksail C>
	[109702] = { zoneID = 630, artID = { 653 }, x = 5579, y = 6360, overlay = { "5580-6340" }, displayID = 64628, questID = { 45489 } }; --Deepclaw
	[110824] = { zoneID = {
				[630] = { x = 6360, y = 1420, artID = { 653 }, overlay = { "6360-1420" } };
				[680] = { x = 1860, y = 6100, artID = { 704 }, overlay = { "1840-6100" } };
			  }, displayID = 70524, questID = { 44124,43542 } }; --Tideclaw
	[111434] = { zoneID = 630, artID = { 653 }, x = 4459, y = 8660, overlay = { "4420-8540","4440-8660" }, displayID = 68605, questID = { 44039 } }; --Sea King Tidross
	[111454] = { zoneID = 630, artID = { 653 }, x = 4179, y = 8819, overlay = { "4160-8860" }, displayID = 71831, questID = { 43961 } }; --Bestrix <Brood Mot>
	[111674] = { zoneID = 630, artID = { 653 }, x = 4680, y = 7759, overlay = { "4680-7740" }, displayID = 71877, questID = { 43960 } }; --Cinderwing
	[111731] = { zoneID = 630, artID = { 653 }, x = 4559, y = 7759, overlay = { "4540-7720" }, displayID = 69841, questID = { 43815 } }; --Karthax
	[111939] = { zoneID = 630, artID = { 653 }, x = 4360, y = 8959, overlay = { "4340-8940" }, displayID = 71940, questID = { 43956 } }; --Lysanis Shadesoul <Felsworn Comman>
	[112636] = { zoneID = 630, artID = { 653 }, x = 5061, y = 5191, overlay = { "5040-5200" }, displayID = 69430, questID = { 44081 } }; --Sinister Leyrunner
	[112637] = { zoneID = 630, artID = { 653 }, x = 5051, y = 5204, overlay = { "5040-5200" }, displayID = 72132, questID = { 44081 } }; --Devious Sunrunner
	[89016] = { zoneID = 630, artID = { 653 }, x = 4100, y = 4181, overlay = { "4120-4160" }, displayID = 26768, questID = { 37537 } }; --Ravyn-Drath
	[89650] = { zoneID = 630, artID = { 653 }, x = 4746, y = 3445, overlay = { "4720-3420" }, displayID = 20641, questID = { 37726 } }; --Valiyaka the Stormbringer
	[89816] = { zoneID = 630, artID = { 653 }, x = 6559, y = 4000, overlay = { "6540-4000" }, displayID = 66813, questID = { 37820 } }; --Golza the Iron Fin
	[89846] = { zoneID = 630, artID = { 653 }, x = 5340, y = 4400, overlay = { "5340-4400" }, displayID = 61814, questID = { 37821 } }; --Captain Volo'ren
	[89850] = { zoneID = 630, artID = { 653 }, x = 5968, y = 5516, overlay = { "5960-5520" }, displayID = 21930, questID = { 37822 } }; --The Oracle
	[89865] = { zoneID = 630, artID = { 653 }, x = 5000, y = 3460, overlay = { "5000-3440" }, displayID = 4088, questID = { 37823 } }; --Mrrgrl the Tide Reaver
	[89884] = { zoneID = 630, artID = { 653 }, x = 4559, y = 5800, overlay = { "4520-5780" }, displayID = 66819, questID = { 37824 } }; --Flog the Captain-Eater
	[90057] = { zoneID = 630, artID = { 653 }, x = 5100, y = 3160, overlay = { "5100-3140" }, displayID = 64535, questID = { 37869 } }; --Daggerbeak
	[90164] = { zoneID = 630, artID = { 653 }, x = 5020, y = 5560, overlay = { "4740-5300","4840-5460","4960-5540" }, displayID = 64006, questID = { 37909 } }; --Warbringer Mox'na
	[90173] = { zoneID = 630, artID = { 653 }, x = 5100, y = 5600, overlay = { "4740-5300","4840-5460","4960-5540","5100-5600" }, displayID = 1913, questID = { 37909 } }; --Arcana Stalker
	[90217] = { zoneID = 630, artID = { 653 }, x = 4960, y = 0860, overlay = { "4940-0860" }, displayID = 23223, questID = { 37928 } }; --Normantis the Deposed <Former Kirin>
	[90244] = { zoneID = 630, artID = { 653 }, x = 5980, y = 1200, overlay = { "5980-1200" }, displayID = 35822, questID = { 37932 } }; --Arcavellus
	[90505] = { zoneID = 630, artID = { 653 }, x = 6720, y = 5160, overlay = { "6720-5140" }, displayID = 65962, questID = { 37989 } }; --Syphonus
	[90803] = { zoneID = 630, artID = { 653 }, x = 3540, y = 5020, overlay = { "3540-5020" }, displayID = 62180, questID = { 38037 } }; --Infernal Lord
	[90901] = { zoneID = 630, artID = { 653 }, x = 5600, y = 2900, overlay = { "5600-2900" }, displayID = 69191, questID = { 38061 } }; --Pridelord Meowl
	[91100] = { zoneID = 630, artID = { 653 }, x = 5920, y = 4640, overlay = { "5900-4660" }, displayID = 62262, questID = { 38212 } }; --Brogozog
	[91113] = { zoneID = 630, artID = { 653 }, x = 6130, y = 6202, overlay = { "6120-6200" }, displayID = 62271, questID = { 38217 } }; --Tide Behemoth
	[91114] = { zoneID = 630, artID = { 653 }, x = 6120, y = 6200, overlay = { "6120-6200" }, displayID = 62272, questID = { 38217 } }; --Tide Behemoth
	[91115] = { zoneID = 630, artID = { 653 }, x = 6120, y = 6200, overlay = { "6120-6200" }, displayID = 62273, questID = { 38217 } }; --Tide Behemoth
	[91187] = { zoneID = 630, artID = { 653 }, x = 3279, y = 2840, overlay = { "3240-2840","3240-2960" }, displayID = 61075, questID = { 38238 } }; --Beacher
	[91289] = { zoneID = 630, artID = { 653 }, x = 5259, y = 2260, overlay = { "5240-2240" }, displayID = 67183, questID = { 38268 } }; --Cailyn Paledoom <Felsw>
	[91579] = { zoneID = 630, artID = { 653 }, x = 4320, y = 2820, overlay = { "4320-2820" }, displayID = 20915, questID = { 38352 } }; --Doomlord Kazrok
	[93622] = { zoneID = 630, artID = { 653 }, x = 4062, y = 4467, overlay = { "4040-4440" }, displayID = 63166, questID = { 45516 } }; --Mortiferous
	[99846] = { zoneID = {
				[630] = { x = 5259, y = 1320, artID = { 653 }, overlay = { "4420-3700","5240-1320" } };
				[641] = { x = 4520, y = 5600, artID = { 664 }, overlay = { "4520-5600" } };
				[650] = { x = 4700, y = 3279, artID = { 674 }, overlay = { "4700-3280" } };
			  }, displayID = 12239 }; --null
	[99886] = { zoneID = {
				[630] = { x = 5259, y = 1320, artID = { 653 }, overlay = { "4420-3700","5260-1320" } };
				[634] = { x = 6519, y = 4020, artID = { 657 }, overlay = { "5360-6000","6520-4020" } };
				[641] = { x = 5859, y = 7340, artID = { 664 }, overlay = { "4500-5580","5840-7340" } };
				[650] = { x = 5520, y = 6180, artID = { 674 }, overlay = { "4700-3280","5520-6180" } };
			  }, friendly = { "A","H" }, displayID = 1109 }; --null
	[100067] = { zoneID = 634, artID = { 657 }, x = 6380, y = 3259, overlay = { "6380-3260" }, friendly = { "A","H" }, displayID = 66423 }; --Hydrannon
	[100223] = { zoneID = 634, artID = { 657 }, x = 6519, y = 4020, overlay = { "5360-6000","6520-4020" }, displayID = 64208 }; --Vrykul Earthshaper Spirit
	[100224] = { zoneID = 634, artID = { 657 }, x = 6519, y = 4020, overlay = { "5340-6000","6520-4020" }, displayID = 25814 }; --Vrykul Earthmaiden Spirit
	[107023] = { zoneID = 634, artID = { 657 }, x = 4660, y = 3000, overlay = { "4620-3060" }, displayID = 69816 }; --Nithogg
	[107487] = { zoneID = 634, artID = { 657 }, x = 5460, y = 2960, overlay = { "5440-2920" }, displayID = 70116, questID = { 42437 } }; --Starbuck
	[107544] = { zoneID = 634, artID = { 657 }, x = 4660, y = 3000, overlay = { "4660-3000" }, displayID = 69816 }; --Nithogg
	[107926] = { zoneID = 634, artID = { 657 }, x = 5160, y = 7460, overlay = { "5160-7440" }, displayID = 70346, questID = { 42591 } }; --Hannval the Butcher
	[108790] = { zoneID = 634, artID = { 657 }, x = 3859, y = 7060, overlay = { "3820-6840","3840-7000" }, displayID = 70702 }; --Den Mother Ylva
	[108822] = { zoneID = 634, artID = { 657 }, x = 3960, y = 6580, overlay = { "3940-6580" }, displayID = 70726 }; --Huntress Estrid
	[108823] = { zoneID = 634, artID = { 657 }, x = 3960, y = 6580, overlay = { "3940-6580" }, displayID = 69724 }; --Halfdan
	[108827] = { zoneID = 634, artID = { 657 }, x = 6860, y = 5360, overlay = { "6520-5460","6620-5000","6720-5160","6760-5600","6800-5280" }, displayID = 60399, questID = { 45507 } }; --Fjorlag, the Grave's Chill
	[108885] = { zoneID = 634, artID = { 657 }, x = 5220, y = 2379, overlay = { "5200-2340" }, displayID = 67541 }; --Aegir Wavecrusher
	[109015] = { zoneID = 634, artID = { 657 }, x = 6200, y = 7320, overlay = { "6200-7320" }, displayID = 70811 }; --Lagertha <Fallen Valk>
	[109113] = { zoneID = 634, artID = { 657 }, x = 3100, y = 3380, overlay = { "3100-3340" }, displayID = 36326 }; --Boulderfall, the Eroded
	[109195] = { zoneID = 634, artID = { 657 }, x = 8160, y = 0460, overlay = { "8160-0460" }, displayID = 70931 }; --Soulbinder Halldora
	[109317] = { zoneID = 634, artID = { 657 }, x = 8100, y = 0960, overlay = { "8040-1160","8100-0960" }, displayID = 66121 }; --Rulf Bonesnapper
	[109318] = { zoneID = 634, artID = { 657 }, x = 7780, y = 0900, overlay = { "7760-0960" }, displayID = 71036 }; --Runeseer Sigvid
	[109994] = { zoneID = 634, artID = { 657 }, x = 6400, y = 2580, overlay = { "5800-2920","5980-3180","6000-2380","6060-2620","6120-2820","6140-2440","6260-2340","6380-2460","6400-2580" }, displayID = 69899, reset = true }; --Stormtalon
	[110363] = { zoneID = 634, artID = { 657 }, x = 5820, y = 3400, overlay = { "5820-3400" }, displayID = 44691, questID = { 43342 } }; --Roteye
	[111463] = { zoneID = 634, artID = { 657 }, x = 7340, y = 8400, overlay = { "7340-8400" }, displayID = 70876 }; --Bulvinkel
	[117850] = { zoneID = 634, artID = { 657 }, x = 3760, y = 4040, overlay = { "3740-4020" }, displayID = 20535 }; --Simone the Seductress
	[90139] = { zoneID = 634, artID = { 657 }, x = 6368, y = 7429, overlay = { "6340-7440" }, displayID = 64719, questID = { 37908 } }; --Inquisitor Ernstenbok
	[91529] = { zoneID = 634, artID = { 657 }, x = 4159, y = 6660, overlay = { "4140-6640" }, displayID = 62488, questID = { 38333 } }; --Glimar Ironfist
	[91780] = { zoneID = 634, artID = { 657 }, x = 3559, y = 1860, overlay = { "3540-1840" }, friendly = { "A" }, displayID = 62999, questID = { 38422 } }; --Mother Clacker
	[91795] = { zoneID = 634, artID = { 657 }, x = 4960, y = 7180, overlay = { "4940-7140" }, displayID = 67132, questID = { 38423 } }; --Stormwing Matriarch
	[91803] = { zoneID = 634, artID = { 657 }, x = 4682, y = 8412, overlay = { "4640-8320" }, displayID = 67127, questID = { 38425 } }; --Fathnyr
	[91874] = { zoneID = 634, artID = { 657 }, x = 4580, y = 7740, overlay = { "4580-7740" }, displayID = 62651, questID = { 38431 } }; --Bladesquall
	[91892] = { zoneID = 634, artID = { 657 }, x = 4120, y = 7180, overlay = { "4120-7180" }, displayID = 62359, questID = { 38424 } }; --Thane Irglov the Merciless
	[92152] = { zoneID = 634, artID = { 657 }, x = 3649, y = 5174, overlay = { "3640-5140" }, displayID = 62814, questID = { 38472 } }; --Whitewater Typhoon
	[92590] = { zoneID = 634, artID = { 657 }, x = 4200, y = 5760, overlay = { "4200-5760" }, friendly = { "H" }, displayID = 27773, questID = { 38625 } }; --Hook
	[92591] = { zoneID = 634, artID = { 657 }, x = 4200, y = 5760, overlay = { "4200-5760" }, friendly = { "H" }, displayID = 63163, questID = { 38625 } }; --Sinker
	[92599] = { zoneID = 634, artID = { 657 }, x = 4000, y = 3859, overlay = { "3740-4140","3780-4020","3820-4280","3900-4440","3940-3840" }, displayID = 71540, questID = { 38626 } }; --Bloodstalker Alpha
	[92604] = { zoneID = 634, artID = { 657 }, x = 4420, y = 2279, overlay = { "4420-2280" }, friendly = { "A" }, displayID = 63182, questID = { 38627 } }; --Champion Elodie
	[92609] = { zoneID = 634, artID = { 657 }, x = 4459, y = 2279, overlay = { "4440-2280" }, friendly = { "A" }, displayID = 63185, questID = { 38627 } }; --Tracker Jack
	[92611] = { zoneID = 634, artID = { 657 }, x = 4440, y = 2279, overlay = { "4440-2280" }, friendly = { "A" }, displayID = 63184, questID = { 38627 } }; --Ambusher Daggerfang
	[92613] = { zoneID = 634, artID = { 657 }, x = 4459, y = 2279, overlay = { "4440-2280" }, friendly = { "A" }, displayID = 63190, questID = { 38627 } }; --Priestess Liza
	[92626] = { zoneID = 634, artID = { 657 }, x = 4420, y = 2279, overlay = { "4420-2280" }, friendly = { "H" }, displayID = 63196, questID = { 38630 } }; --Deathguard Adams
	[92631] = { zoneID = 634, artID = { 657 }, x = 4420, y = 2279, overlay = { "4420-2280" }, friendly = { "H" }, displayID = 30072, questID = { 38630 } }; --Dark Ranger Jess
	[92633] = { zoneID = 634, artID = { 657 }, x = 4420, y = 2279, overlay = { "4420-2280" }, friendly = { "H" }, displayID = 63203, questID = { 38630 } }; --Assassin Huwe
	[92634] = { zoneID = 634, artID = { 657 }, x = 4420, y = 2279, overlay = { "4420-2240" }, friendly = { "H" }, displayID = 63204, questID = { 38630 } }; --Apothecary Perez
	[92682] = { zoneID = 634, artID = { 657 }, x = 5780, y = 4500, overlay = { "5780-4500" }, displayID = 25633, questID = { 38642 } }; --Helmouth Raider
	[92685] = { zoneID = 634, artID = { 657 }, x = 5780, y = 4500, overlay = { "5780-4500" }, displayID = 25668, questID = { 38642 } }; --Captain Brvet
	[92703] = { zoneID = 634, artID = { 657 }, x = 5780, y = 4500, overlay = { "5780-4500" }, displayID = 23553, questID = { 38642 } }; --Helmouth Raider
	[92751] = { zoneID = 634, artID = { 657 }, x = 5980, y = 6811, overlay = { "5980-6800","6120-6820" }, displayID = 24814, questID = { 39031 } }; --Ivory Sentinel
	[92763] = { zoneID = 634, artID = { 657 }, x = 6720, y = 3980, overlay = { "6720-3980" }, displayID = 25940, questID = { 38685 } }; --The Nameless King
	[92951] = { zoneID = 634, artID = { 657 }, x = 4720, y = 5720, overlay = { "4720-5720" }, friendly = { "A" }, displayID = 63377, questID = { 38712 } }; --Houndmaster Ely
	[93166] = { zoneID = 634, artID = { 657 }, x = 4880, y = 5060, overlay = { "4540-5000","4680-5000","4800-4980" }, displayID = 34706, questID = { 38774 } }; --Tiptog the Lost
	[93371] = { zoneID = 634, artID = { 657 }, x = 7249, y = 4993, overlay = { "7220-5060","7240-4940" }, displayID = 63533, questID = { 38837 } }; --Mordvigbjorn
	[93401] = { zoneID = 634, artID = { 657 }, x = 6500, y = 5140, overlay = { "6480-5160" }, displayID = 63553, questID = { 38847 } }; --Urgev the Flayer <Champion of the Runea>
	[94313] = { zoneID = 634, artID = { 657 }, x = 5842, y = 7562, overlay = { "5820-7560" }, friendly = { "A" }, displayID = 63930, questID = { 39048 } }; --Daniel Boomer Vorick <Master Demolition>
	[94347] = { zoneID = 634, artID = { 657 }, x = 7660, y = 6320, overlay = { "7220-6320","7240-5940","7380-6040","7420-6240","7440-6420","7520-6000","7580-6460","7620-6160","7660-6320" }, friendly = { "H" }, displayID = 63942, questID = { 43343 } }; --Dread-Rider Cortis
	[94413] = { zoneID = 634, artID = { 657 }, x = 6200, y = 6060, overlay = { "6200-6040" }, displayID = 69471, questID = { 39120 } }; --Isel the Hammer <Forger of Shie>
	[98188] = { zoneID = 634, artID = { 657 }, x = 4159, y = 3380, overlay = { "4140-3340" }, displayID = 65687, questID = { 40068 } }; --Egyl the Enduring
	[98268] = { zoneID = 634, artID = { 657 }, x = 6160, y = 4360, overlay = { "6120-4360" }, displayID = 69269, questID = { 40081 } }; --Tarben <Jarl of Tideskorn Har>
	[98421] = { zoneID = 634, artID = { 657 }, x = 7346, y = 4766, overlay = { "7340-4740" }, displayID = 71158, questID = { 40109 } }; --Kottr Vondyr <High Inkbin>
	[98503] = { zoneID = 634, artID = { 657 }, x = 7880, y = 6120, overlay = { "7880-6120" }, displayID = 5293, questID = { 40113 } }; --Grrvrgull the Conqueror <Champion of the Bilge>
	[103785] = { zoneID = 641, artID = { 664 }, x = 6900, y = 5959, overlay = { "4920-4680","5960-6680","6900-5940" }, displayID = 68383 }; --Well-Fed Bear
	[104523] = { zoneID = 641, artID = { 664 }, x = 5220, y = 3940, overlay = { "5200-3980" }, displayID = 68610, questID = { 45500 } }; --Shalas'aman
	[107924] = { zoneID = {
				[641] = { x = 5859, y = 7360, artID = { 664 }, overlay = { "5840-7340" } };
				[650] = { x = 5520, y = 6180, artID = { 674 }, overlay = { "5520-6180" } };
			  }, displayID = 69056 }; --null
	[108678] = { zoneID = 641, artID = { 664 }, x = 5680, y = 4459, overlay = { "5540-4240","5540-4360","5680-4460" }, displayID = 70659 }; --Shar'thos
	[108879] = { zoneID = 641, artID = { 664 }, x = 2460, y = 6960, overlay = { "2440-6940","2440-7060" }, displayID = 67258 }; --Humongris <The Wiz>
	[109125] = { zoneID = 641, artID = { 664 }, x = 4559, y = 8359, overlay = { "4540-8380" }, displayID = 70887 }; --Kathaw the Savage
	[109281] = { zoneID = 641, artID = { 664 }, x = 4360, y = 7600, overlay = { "4220-7640","4280-7520" }, displayID = 68639, questID = { 45501 } }; --Malisandra
	[109648] = { zoneID = 641, artID = { 664 }, x = 2420, y = 7040, overlay = { "2340-7100" }, displayID = 71124, questID = { 45493 } }; --Witchdoctor Grgl-Brgl
	[109692] = { zoneID = 641, artID = { 664 }, x = 3167, y = 5860, overlay = { "3160-5880","3240-6020","3340-6100","3460-6200" }, displayID = 71135, questID = { 45490 } }; --Lytheron
	[109708] = { zoneID = 641, artID = { 664 }, x = 6700, y = 6940, overlay = { "6680-6960" }, displayID = 71136, questID = { 43176 } }; --Undergrell Ringleader
	[109990] = { zoneID = 641, artID = { 664 }, x = 3240, y = 4820, overlay = { "3220-4860" }, displayID = 66889, questID = { 45488 } }; --Nylaathria the Forgotten
	[110342] = { zoneID = 641, artID = { 664 }, x = 6980, y = 5760, overlay = { "6940-5740" }, displayID = 66106, questID = { 45487 } }; --Rabxach
	[110346] = { zoneID = 641, artID = { 664 }, x = 5983, y = 5049, overlay = { "5980-5040" }, displayID = 69644, questID = { 45485 } }; --Aodh Witherpetal
	[110361] = { zoneID = 641, artID = { 664 }, x = 7040, y = 5300, overlay = { "7020-5220" }, displayID = 69081, questID = { 45484 } }; --Harbinger of Screams
	[110367] = { zoneID = 641, artID = { 664 }, x = 6280, y = 4240, overlay = { "6240-4280" }, displayID = 71539, questID = { 45483 } }; --Ealdis
	[110562] = { zoneID = 641, artID = { 664 }, x = 4559, y = 8860, overlay = { "4520-8740","4540-8860" }, displayID = 71578, questID = { 43446 } }; --Bahagar
	[92117] = { zoneID = 641, artID = { 664 }, x = 5959, y = 7759, overlay = { "5940-7640","5960-7760" }, displayID = 31979, questID = { 38468 } }; --Gorebeak
	[92180] = { zoneID = 641, artID = { 664 }, x = 4159, y = 7860, overlay = { "4140-7800" }, displayID = 63713, questID = { 38479 } }; --Seersei
	[92423] = { zoneID = 641, artID = { 664 }, x = 3800, y = 5280, overlay = { "3800-5280" }, displayID = 8783, questID = { 38772 } }; --Theryssia
	[92965] = { zoneID = 641, artID = { 664 }, x = 4420, y = 5200, overlay = { "4340-5400","4400-5260" }, displayID = 64387, questID = { 38767 } }; --Darkshade
	[93030] = { zoneID = 641, artID = { 664 }, x = 5920, y = 3320, overlay = { "5880-3400","5900-3240" }, displayID = 65064, questID = { 40080 } }; --Ironbranch <Ancient of>
	[93205] = { zoneID = 641, artID = { 664 }, x = 6260, y = 4759, overlay = { "6260-4740" }, displayID = 64255, questID = { 38780 } }; --Thondrax <Darkgrove Kee>
	[93654] = { zoneID = 641, artID = { 664 }, x = 6100, y = 8800, overlay = { "6100-8800" }, displayID = 21122, questID = { 38887 } }; --Skul'vrax
	[93679] = { zoneID = 641, artID = { 664 }, x = 4920, y = 4900, overlay = { "4920-4900" }, displayID = 62741, questID = { 38212 } }; --Gathenak the Subjugator
	[93686] = { zoneID = 641, artID = { 664 }, x = 5280, y = 8760, overlay = { "5280-8740" }, displayID = 50910, questID = { 38889 } }; --Jinikki the Puncturer
	[94414] = { zoneID = 641, artID = { 664 }, x = 3440, y = 5840, overlay = { "3440-5840" }, displayID = 63999, questID = { 39121 } }; --Kiranys Duskwhisper
	[94485] = { zoneID = 641, artID = { 664 }, x = 6689, y = 4457, overlay = { "6640-4500","6740-4680","6760-4400" }, displayID = 49027, questID = { 39130 } }; --Pollous the Fetid
	[95123] = { zoneID = 641, artID = { 664 }, x = 6580, y = 5360, overlay = { "6580-5320" }, displayID = 65231, questID = { 40126 } }; --Grelda the Hag
	[95221] = { zoneID = 641, artID = { 664 }, x = 4720, y = 5780, overlay = { "4720-5780" }, displayID = 64327, questID = { 39357 } }; --Mad Henryk
	[95318] = { zoneID = 641, artID = { 664 }, x = 6100, y = 6960, overlay = { "6100-6940" }, displayID = 64801, questID = { 39596 } }; --Perrexx
	[97504] = { zoneID = 641, artID = { 664 }, x = 6676, y = 3647, overlay = { "6660-3760" }, displayID = 65235, questID = { 39856 } }; --Wraithtalon
	[97517] = { zoneID = 641, artID = { 664 }, x = 6020, y = 4420, overlay = { "6020-4420" }, displayID = 70202, questID = { 39858 } }; --Dreadbog
	[98241] = { zoneID = 641, artID = { 664 }, x = 6181, y = 2961, overlay = { "6180-2980" }, displayID = 63669, questID = { 40079 } }; --Lyrath Moonfeather
	[116166] = { zoneID = 646, artID = { 669 }, x = 6519, y = 3160, overlay = { "6440-3020","6520-3160" }, displayID = 76140 }; --Eye of Gurgh
	[116953] = { zoneID = 646, artID = { 669 }, x = 6080, y = 5320, overlay = { "6040-5320" }, displayID = 74379 }; --Corrupted Bonebreaker
	[117086] = { zoneID = 646, artID = { 669 }, x = 5280, y = 4340, overlay = { "5120-4220","5140-4340","5140-4460","5260-4440" }, displayID = 62180 }; --Emberfire
	[117089] = { zoneID = 646, artID = { 669 }, x = 6200, y = 3820, overlay = { "6200-3820" }, displayID = 67378 }; --Inquisitor Chillbane
	[117090] = { zoneID = 646, artID = { 669 }, x = 5060, y = 4980, overlay = { "4820-4780","4880-4640","4940-4860","5060-4980" }, displayID = 71253 }; --Xorogun the Flamecarver
	[117091] = { zoneID = 646, artID = { 669 }, x = 3960, y = 4179, overlay = { "3920-4200" }, displayID = 20853 }; --Felmaw Emberfiend
	[117093] = { zoneID = 646, artID = { 669 }, x = 6000, y = 4500, overlay = { "5620-5060","5720-4900","5780-4040","5800-4180","5820-4300","5820-4640","5820-4760","5900-4500" }, displayID = 67324 }; --Felbringer Xar'thok
	[117094] = { zoneID = 646, artID = { 669 }, x = 4440, y = 4260, overlay = { "4240-4240","4240-4360","4380-4180" }, displayID = 74429 }; --Malorus the Soulkeeper
	[117095] = { zoneID = 646, artID = { 669 }, x = 6100, y = 3320, overlay = { "5680-2940","5740-3060","5780-2860","5800-3180","5880-2740","5940-2620","6020-3320" }, displayID = 64681 }; --Dreadblade Annihilator
	[117096] = { zoneID = 646, artID = { 669 }, x = 5680, y = 5620, overlay = { "5680-5620" }, displayID = 64632 }; --Potionmaster Gloop
	[117103] = { zoneID = 646, artID = { 669 }, x = 8980, y = 3080, overlay = { "8840-3100","8980-3080" }, displayID = 74433 }; --Felcaller Zelthae
	[117136] = { zoneID = 646, artID = { 669 }, x = 5020, y = 3640, overlay = { "4980-3700","5000-3540" }, displayID = 68312 }; --Doombringer Zar'thoz
	[117140] = { zoneID = 646, artID = { 669 }, x = 7060, y = 2540, overlay = { "6440-3100","6540-2860","6560-3020","6600-3180","6720-2920","6760-3060","6840-2940","6920-2800","6960-3080","7020-2600" }, displayID = 76061 }; --Salethan the Broodwalker
	[117141] = { zoneID = 646, artID = { 669 }, x = 5959, y = 2720, overlay = { "5740-2740","5940-2720" }, displayID = 72964 }; --Malgrazoth
	[117239] = { zoneID = 646, artID = { 669 }, x = 5959, y = 2880, overlay = { "5840-2800","5900-2980" }, displayID = 66677 }; --Brutallus
	[117303] = { zoneID = 646, artID = { 669 }, x = 6100, y = 2940, overlay = { "5820-2820","5940-2840","5940-2960","5960-2720","6060-2820","6100-2940" }, displayID = 63619 }; --Malificus
	[117470] = { zoneID = 646, artID = { 669 }, x = 8959, y = 3360, overlay = { "8800-3300","8920-3120","8940-3280" }, displayID = 74528 }; --Si'vash
	[118993] = { zoneID = 646, artID = { 669 }, x = 4520, y = 7980, overlay = { "3680-7780","3680-7920","3740-7620","3800-8000","3900-7920","3920-8040","4040-7880","4100-8060","4160-7740","4220-8000","4280-7840","4360-7960","4500-7860","4520-7980" }, displayID = 75013 }; --Dreadeye
	[119629] = { zoneID = 646, artID = { 669 }, x = 4520, y = 5180, overlay = { "4440-5240" }, displayID = 62555 }; --Lord Hel'Nurath
	[119718] = { zoneID = 646, artID = { 669 }, x = 6020, y = 4500, overlay = { "6020-4500" }, displayID = 65648 }; --Imp Mother Bruva
	[120583] = { zoneID = 646, artID = { 669 }, x = 8400, y = 5300, overlay = { "3900-3220","4420-5080","4540-5140","4960-1660","5040-1460","5040-1840","5180-6520","5200-4300","5760-4820","5840-4640","5860-4420","5860-6220","5960-6380","6060-6300","7540-2860","7640-2780","8220-5220","8240-4960","8280-5100","8340-5220" }, displayID = 75867 }; --Than'otalion <Lord of Dominat>
	[120641] = { zoneID = 646, artID = { 669 }, x = 8280, y = 5180, overlay = { "4000-2660","4360-3760","4520-5020","5260-6400","7760-2960","8260-2940","8280-5180" }, displayID = 17287 }; --Skulguloth <Fel Sprea>
	[120665] = { zoneID = 646, artID = { 669 }, x = 5800, y = 4759, overlay = { "3880-2660","3960-2560","4220-5000","4260-4880","4280-4060","5080-4380","5420-6600","5800-4760" }, displayID = 64027 }; --Force-Commander Xillious
	[120675] = { zoneID = 646, artID = { 669 }, x = 8359, y = 4920, overlay = { "3260-3240","3320-3420","3440-3340","3820-3120","3880-2760","3920-2560","4160-4640","4280-4240","4340-4120","4440-3640","4440-4040","4460-4740","4520-4900","4520-5040","4520-5200","4540-3840","4580-5320","4880-4420","5020-1080","5140-4600","5160-4480","5180-6680","5240-4120","5320-1540","5360-4120","5440-6740","5460-1340","5620-6600","5840-4860","5860-4580","5880-4400","5940-4240","6140-4720","7620-2480","7620-2640","8100-5080","8140-2800","8220-2620","8260-2500","8260-5060","8360-4920" }, displayID = 75945 }; --An'thyna <Venom Qu>
	[120681] = { zoneID = 646, artID = { 669 }, x = 8300, y = 5140, overlay = { "3740-3000","3840-2520","3980-2580","4240-4040","4300-4160","4360-3940","4400-4580","4420-4080","4460-4920","4520-5160","4900-4360","4940-4240","5020-4420","5120-4220","5140-4400","5240-4260","5500-1480","5840-4740","8220-4860","8220-5040" }, displayID = 67647 }; --Fel Obliterator
	[120686] = { zoneID = 646, artID = { 669 }, x = 8340, y = 2780, overlay = { "3860-3220","4400-4180","4460-4000","4500-4920","4540-3560","4820-4260","5020-4380","5340-6680","7720-2880","7880-2980","8340-2680" }, displayID = 75992 }; --Illisthyndria <Keeper of Kni>
	[120998] = { zoneID = 646, artID = { 669 }, x = 4020, y = 5980, overlay = { "3940-6020" }, displayID = 76060 }; --Flllurlokkr
	[121016] = { zoneID = 646, artID = { 669 }, x = 5380, y = 7880, overlay = { "5380-7880" }, displayID = 76065 }; --Aqueux
	[121029] = { zoneID = 646, artID = { 669 }, x = 3986, y = 3418, overlay = { "3860-3440","3940-3240","3960-3020","3980-3360" }, displayID = 76067 }; --Brood Mother Nix
	[121037] = { zoneID = 646, artID = { 669 }, x = 7880, y = 2520, overlay = { "7720-2320","7780-2520","7820-2240","7880-2400" }, displayID = 76070 }; --Grossir
	[121046] = { zoneID = 646, artID = { 669 }, x = 7900, y = 4080, overlay = { "7840-3940","7900-3780","7900-4080" }, displayID = 76254 }; --Brother Badatin
	[121049] = { zoneID = 646, artID = { 669 }, x = 8680, y = 2700, overlay = { "3600-5720","3620-2400","3800-4440","3820-4560","4200-1800","4200-4900","4380-4240","4460-7680","4680-6720","5180-1040","5380-4120","5440-6840","5500-4620","5520-2640","5680-3580","5780-5600","6240-4140","6240-5820","6320-2640","6540-3220","6620-4240","6640-4360","6840-2660","7340-3040","7420-3420","8540-5480","8620-2780" }, displayID = 76108 }; --Baleful Knight-Captain
	[121051] = { zoneID = 646, artID = { 669 }, x = 8640, y = 2760, overlay = { "3580-5720","3600-2400","3800-4500","4160-4940","4180-1820","4240-1480","4360-4240","4480-7660","4680-6720","5200-1060","5380-4160","5460-6880","5520-2640","5520-4600","5660-3540","5760-5600","6220-4160","6220-5760","6300-2660","6540-3180","6620-3360","6640-4240","6880-2640","7360-3460","7380-3020","8560-5420","8640-2720" }, displayID = 76077 }; --Unstable Abyssal
	[121056] = { zoneID = 646, artID = { 669 }, x = 8680, y = 2720, overlay = { "3580-5760","3600-2420","3800-4520","4180-4940","4220-1800","4280-5060","4300-4180","4400-7480","4460-7640","4620-6740","5220-1040","5400-4100","5440-4660","5440-6820","5500-2840","5520-2640","5560-4580","5700-3520","5700-3720","5780-5580","6000-6200","6220-5860","6240-4140","6340-2640","6580-3220","6620-3340","6640-4300","6880-2620","7400-3020","7440-3400","8500-5440","8640-2700" }, displayID = 76102 }; --Malformed Terrorguard
	[121068] = { zoneID = 646, artID = { 669 }, x = 8620, y = 2740, overlay = { "3600-5740","3620-2400","3800-4540","4180-4940","4200-1800","4380-4240","4480-7640","4680-6720","5220-1040","5420-4100","5460-6880","5520-4600","5560-2620","5680-3520","5760-5600","6220-5840","6240-4140","6340-2640","6540-3200","6640-4300","6880-2640","7400-3020","7440-3400","8560-5440","8620-2740" }, displayID = 76081 }; --Volatile Imp
	[121073] = { zoneID = 646, artID = { 669 }, x = 8640, y = 2720, overlay = { "3600-2420","3600-5720","3800-4540","4180-4920","4200-1820","4380-4240","4480-7680","4680-6720","5160-1160","5220-1040","5420-4100","5460-6840","5520-2640","5520-4600","5680-3560","5780-5580","6220-5880","6240-4140","6320-2640","6580-3240","6640-4280","6880-2600","7400-3040","7440-3420","8560-5400","8620-2760" }, displayID = 76099 }; --Deranged Succubus
	[121077] = { zoneID = 646, artID = { 669 }, x = 8660, y = 2760, overlay = { "3600-5780","3620-2380","3800-4540","4160-1900","4200-4940","4360-4240","4480-7640","4700-6720","5200-1040","5400-4100","5460-6860","5480-4500","5540-2620","5680-3420","5680-3560","5760-5600","6220-5860","6240-4140","6320-2640","6580-3240","6620-4280","6880-2620","7400-3040","7440-3420","8560-5440","8600-2780" }, displayID = 76084 }; --Lambent Felhunter
	[121088] = { zoneID = 646, artID = { 669 }, x = 8640, y = 2760, overlay = { "3600-2400","3600-5740","3800-4520","4180-4920","4200-1820","4380-4240","4480-7660","4700-6700","5200-1040","5420-4120","5440-6880","5520-4600","5540-2640","5680-3520","5780-5580","6220-5860","6240-4140","6320-2640","6580-3240","6640-4280","6840-2680","7400-3040","7420-3400","8560-5460","8640-2740" }, displayID = 76107 }; --Warped Voidlord
	[121090] = { zoneID = 646, artID = { 669 }, x = 8620, y = 2740, overlay = { "3600-5740","3620-2440","3800-4540","4180-4920","4200-1760","4380-4240","4480-7640","4680-6720","5220-1040","5420-4080","5460-6840","5520-4600","5540-2620","5680-3540","5760-5580","6220-5840","6240-4140","6320-2640","6560-3220","6620-4280","6880-2600","7400-3040","7400-3420","8560-5440","8620-2740" }, displayID = 76106 }; --Demented Shivarra
	[121092] = { zoneID = 646, artID = { 669 }, x = 8660, y = 2760, overlay = { "3600-2420","3600-5740","3800-4540","4180-1820","4180-4920","4380-4240","4460-7640","4680-6720","5220-1040","5400-4100","5460-6840","5520-4600","5540-2620","5640-3520","5760-5600","6200-4220","6200-5860","6320-2640","6580-3220","6620-4240","6860-2640","7300-3240","7400-3020","7420-3420","8520-5460","8620-2740" }, displayID = 76090 }; --Anomalous Observer
	[121107] = { zoneID = 646, artID = { 669 }, x = 4260, y = 1840, overlay = { "4140-1640","4200-1760","4240-1560" }, displayID = 76101 }; --Lady Eldrathe
	[121108] = { zoneID = 646, artID = { 669 }, x = 8660, y = 2720, overlay = { "3540-5740","3560-6060","3620-2380","3780-4880","3800-4520","3880-4720","4100-1800","4180-4920","4220-1800","4320-4080","4360-4240","4400-7700","4520-4000","4620-6740","5180-1060","5320-4120","5440-6780","5520-4600","5540-2640","5540-2760","5580-6600","5680-3520","5780-5580","5840-5440","5880-5280","6020-4140","6100-2600","6140-4200","6220-5840","6240-2660","6260-4140","6560-3220","6580-3360","6620-4240","6820-2780","6900-2620","7340-3480","7380-3000","7420-3660","7460-3500","8500-5480","8640-2720" }, displayID = 76103 }; --Ruinous Overfiend
	[121112] = { zoneID = 646, artID = { 669 }, x = 2785, y = 5840, overlay = { "2700-6020","2740-6180","2780-5680","2780-5860","2860-5560","2880-6160","2900-5960","2980-5720","3020-5580","3080-6080","3100-5920","3160-5540","3220-5980","3240-5640","3320-5800" }, displayID = 76109 }; --Somber Dawn
	[121124] = { zoneID = 646, artID = { 669 }, x = 6000, y = 6280, overlay = { "5920-6200" }, displayID = 67647 }; --Apocron
	[121134] = { zoneID = 646, artID = { 669 }, x = 7880, y = 2640, overlay = { "7740-2920","7820-2740","7860-2880" }, displayID = 76121 }; --Duke Sithizi
	[109163] = { zoneID = 649, artID = { 673 }, x = 7200, y = 2279, overlay = { "6660-2320","6840-1920","6840-2040","6940-2240","6960-2120","7000-1920","7080-1800","7100-2220","7160-1940" }, displayID = 69849 }; --Captain Dargun
	[115732] = { zoneID = 649, artID = { 673 }, x = 3500, y = 4620, overlay = { "2680-4200","2740-4320","2860-4280","2960-4400","3080-4400","3500-4620" }, displayID = 23553, questID = { 46949 } }; --Jorvild the Trusted
	[92040] = { zoneID = 649, artID = { 673 }, x = 8500, y = 5020, overlay = { "8340-4820","8440-4900","8500-5020" }, displayID = 70084, questID = { 38461 } }; --Fenri
	[97630] = { zoneID = 649, artID = { 673 }, x = 2960, y = 6260, overlay = { "2700-6260","2720-6440","2840-6300","2860-6420","2900-6160","2940-6020" }, displayID = 65302, questID = { 39870 } }; --Soulthirster
	[100230] = { zoneID = 650, artID = { 674 }, x = 4340, y = 4740, overlay = { "4320-4760" }, displayID = 66048, questID = { 40413 } }; --Sure-Shot Arnie <Amateur Hun>
	[100231] = { zoneID = 650, artID = { 674 }, x = 4340, y = 4740, overlay = { "4320-4760" }, displayID = 65989, questID = { 40413 } }; --Dargok Thunderuin <Amateur Hun>
	[100232] = { zoneID = 650, artID = { 674 }, x = 4340, y = 4740, overlay = { "4320-4760" }, displayID = 65987, questID = { 40413 } }; --Ryael Dawndrifter <Amateur Hun>
	[100302] = { zoneID = 650, artID = { 674 }, x = 5240, y = 5840, overlay = { "5240-5840" }, displayID = 66606, questID = { 40423 } }; --Puck <Unethical Adventur>
	[100303] = { zoneID = 650, artID = { 674 }, x = 5240, y = 5859, overlay = { "5240-5840" }, displayID = 66607, questID = { 40423 } }; --Zenobia <Unethical Adventur>
	[100495] = { zoneID = 650, artID = { 674 }, x = 5444, y = 4126, overlay = { "5440-4120" }, displayID = 60684, questID = { 40414 } }; --Devouring Darkness
	[101077] = { zoneID = {
				[650] = { x = 4559, y = 5540, artID = { 674 }, overlay = { "4520-5440","4520-5580" } };
				[750] = { x = 3720, y = 0400, artID = { 775 }, overlay = { "3600-0800","3620-0620","3680-1280","3720-0400" } };
			  }, displayID = 64387, questID = { 40681 } }; --Sekhan
	[101649] = { zoneID = 650, artID = { 674 }, x = 5460, y = 7560, overlay = { "5100-8080","5180-7900","5400-7580","5440-7440" }, displayID = 67284, questID = { 40773 } }; --Frostshard
	[104481] = { zoneID = 650, artID = { 674 }, x = 2840, y = 5380, overlay = { "2820-5280" }, displayID = 68615, questID = { 45514 } }; --Ala'washte
	[104484] = { zoneID = 650, artID = { 674 }, x = 3380, y = 2160, overlay = { "3340-2080" }, displayID = 67541, questID = { 45511 } }; --Olokk the Shipbreaker
	[104513] = { zoneID = 650, artID = { 674 }, x = 5668, y = 4869, overlay = { "5640-4860" }, displayID = 68639, questID = { 45513 } }; --Defilia <Skywitch Her>
	[104517] = { zoneID = 650, artID = { 674 }, x = 5880, y = 7280, overlay = { "5840-7140","5840-7260" }, displayID = 62814, questID = { 45512 } }; --Mawat'aki <Winters>
	[104524] = { zoneID = 650, artID = { 674 }, x = 5259, y = 5840, overlay = { "5220-5860" }, displayID = 68613, questID = { 45510 } }; --Ormagrogg
	[109498] = { zoneID = 650, artID = { 674 }, x = 5259, y = 5820, overlay = { "5240-5840" }, displayID = 72158, questID = { 40423 } }; --Xaander <Unethical Adventur>
	[109500] = { zoneID = 650, artID = { 674 }, x = 5259, y = 5820, overlay = { "5220-5860" }, displayID = 72159, questID = { 40423 } }; --Jak <Unethical Adventur>
	[109501] = { zoneID = 650, artID = { 674 }, x = 5240, y = 5859, overlay = { "5240-5840" }, displayID = 72160, questID = { 40423 } }; --Darkful <Unethical Adventur>
	[110378] = { zoneID = 650, artID = { 674 }, x = 5859, y = 7119, overlay = { "5820-7140","5840-7260" }, displayID = 68225 }; --Drugon the Frostblood
	[94877] = { zoneID = 650, artID = { 674 }, x = 5620, y = 7240, overlay = { "5620-7240" }, displayID = 64340, questID = { 39235 } }; --Brogrul the Mighty
	[95204] = { zoneID = 650, artID = { 674 }, x = 4740, y = 7380, overlay = { "4700-7320" }, displayID = 67881, questID = { 39435 } }; --Oubdob da Smasher
	[95872] = { zoneID = 650, artID = { 674 }, x = 5140, y = 3180, overlay = { "5140-3180" }, displayID = 65068, questID = { 39465 } }; --Skullhat <Skywhisker Taskmas>
	[96072] = { zoneID = 650, artID = { 674 }, x = 4380, y = 7560, overlay = { "4380-7540" }, displayID = 68264, questID = { 45508 } }; --Durguth <King of the H>
	[96410] = { zoneID = 650, artID = { 674 }, x = 4920, y = 2900, overlay = { "4520-2580","4540-3020","4660-3140","4700-3360","4780-3040","4780-3200","4840-2520","4920-2900" }, displayID = 64893, questID = { 39646 } }; --Majestic Elderhorn
	[96590] = { zoneID = 650, artID = { 674 }, x = 5680, y = 5959, overlay = { "5580-6140","5640-5920" }, displayID = 34706, questID = { 40347 } }; --Gurbog da Basher
	[96621] = { zoneID = 650, artID = { 674 }, x = 4880, y = 2700, overlay = { "4840-2740" }, displayID = 66107, questID = { 40242 } }; --Mellok, Son of Torok
	[97093] = { zoneID = 650, artID = { 674 }, x = 5100, y = 2580, overlay = { "5100-2580" }, displayID = 65446, questID = { 39762 } }; --Shara Felbreath <Feltotem Warl>
	[97102] = { zoneID = 650, artID = { 674 }, x = 5220, y = 5140, overlay = { "5220-5140" }, displayID = 27992, questID = { 39824 } }; --Ram'Pag <The Treasure W>
	[97203] = { zoneID = 650, artID = { 674 }, x = 4196, y = 4160, overlay = { "4200-4140" }, displayID = 65546, questID = { 39782 } }; --Tenpak Flametotem <The Exiled Sha>
	[97220] = { zoneID = 650, artID = { 674 }, x = 4880, y = 5000, overlay = { "4880-5000" }, displayID = 20827, questID = { 40601 } }; --Arru <The Ter>
	[97326] = { zoneID = 650, artID = { 674 }, x = 5107, y = 4823, overlay = { "5100-4820" }, displayID = 65224, questID = { 39802 } }; --Hartli the Snatcher
	[97345] = { zoneID = 650, artID = { 674 }, x = 4840, y = 4060, overlay = { "4840-4040" }, displayID = 65258, questID = { 39806 } }; --Crawshuk the Hungry
	[97449] = { zoneID = 650, artID = { 674 }, x = 3813, y = 4557, overlay = { "3800-4540" }, displayID = 51827, questID = { 40405 } }; --Bristlemaul
	[97593] = { zoneID = 650, artID = { 674 }, x = 5460, y = 4060, overlay = { "5440-4060" }, displayID = 64303, questID = { 39866 } }; --Mynta Talonscreech
	[97653] = { zoneID = 650, artID = { 674 }, x = 5380, y = 5120, overlay = { "5380-5120" }, displayID = 65324, questID = { 39872 } }; --Taurson <The Beastly Bo>
	[97793] = { zoneID = 650, artID = { 674 }, x = 4120, y = 5800, overlay = { "4120-5800" }, displayID = 65423, questID = { 39963 } }; --Flamescale
	[97928] = { zoneID = 650, artID = { 674 }, x = 4580, y = 1240, overlay = { "4300-1040","4400-1120","4440-1260","4580-1240" }, displayID = 70524, questID = { 39994 } }; --Tamed Coralback
	[97933] = { zoneID = 650, artID = { 674 }, x = 4436, y = 1252, overlay = { "4300-1040","4400-1120","4440-1240","4620-1200" }, displayID = 1995, questID = { 39994 } }; --Crab Rider Grmlrml
	[98024] = { zoneID = 650, artID = { 674 }, x = 5080, y = 3460, overlay = { "5080-3460" }, displayID = 68669, questID = { 40406 } }; --Luggut the Eggeater
	[98299] = { zoneID = 650, artID = { 674 }, x = 3680, y = 1620, overlay = { "3640-1640" }, displayID = 66811, questID = { 40084 } }; --Bodash the Hoarder
	[98311] = { zoneID = 650, artID = { 674 }, x = 4660, y = 0760, overlay = { "4640-0700" }, displayID = 22530, questID = { 40096 } }; --Mrrklr
	[98890] = { zoneID = 650, artID = { 674 }, x = 4140, y = 3180, overlay = { "4140-3180" }, displayID = 37737, questID = { 40175 } }; --Slumber
	[99929] = { zoneID = 650, artID = { 674 }, x = 4920, y = 0760, overlay = { "4920-0740" }, displayID = 66811 }; --Flotsam
	[125951] = { zoneID = 658, artID = { 680 }, x = 5540, y = 8440, overlay = { "5200-8300","5220-8160","5320-8040","5340-8340","5480-8480" }, displayID = 68688 }; --Obsidian Deathwarder
	[97057] = { zoneID = 672, artID = { 696 }, x = 8120, y = 4260, overlay = { "8000-4320","8040-4080","8120-4260" }, displayID = 65494, questID = { 40233 } }; --Overseer Brutarg
	[97058] = { zoneID = {
				[672] = { x = 6338, y = 2314, artID = { 696 }, overlay = { "6338-2314" } };
				[674] = { x = 5720, y = 5340, artID = { 697 }, overlay = { "4760-6480","4860-5880","4860-6000","4920-5740","4940-5500","4940-5620","5000-6160","5060-5740","5060-5900","5120-5300","5120-5420","5140-6180","5180-5860","5200-6040","5240-5700","5320-5960","5340-5420","5340-6200","5380-6080","5460-5560","5700-6380","5720-5340" } };
			  }, displayID = 62700, questID = { 40231 } }; --Count Nefarious
	[97059] = { zoneID = 672, artID = { 696 }, x = 7440, y = 5720, overlay = { "7420-5760" }, displayID = 66977, questID = { 40232 } }; --King Voras <Brood Queen Tyranna's Cons>
	[97370] = { zoneID = 672, artID = { 696 }, x = 6868, y = 2751, overlay = { "6840-2740" }, displayID = 58049, questID = { 40234 } }; --General Volroth
	[100864] = { zoneID = 680, artID = { 704 }, x = 6820, y = 5859, overlay = { "6820-5840" }, displayID = 32568, questID = { 41135 } }; --Cora'kar <Sashj'tar Jai>
	[102303] = { zoneID = 680, artID = { 704 }, x = 4852, y = 5666, overlay = { "4840-5640" }, displayID = 73503, questID = { 40905 } }; --Lieutenant Strathmar
	[103183] = { zoneID = 680, artID = { 704 }, x = 8020, y = 7060, overlay = { "7960-7260","7980-6720","8020-6920","8020-7040" }, displayID = 66812, questID = { 40680 } }; --Rok'nash <Eel Her>
	[103214] = { zoneID = 680, artID = { 704 }, x = 6763, y = 7097, overlay = { "6780-7080" }, displayID = 68084, questID = { 41136 } }; --Har'kess the Insatiable
	[103223] = { zoneID = 680, artID = { 704 }, x = 6160, y = 3960, overlay = { "6140-3960" }, displayID = 71158, questID = { 43993 } }; --Hertha Grimdottir
	[103575] = { zoneID = 680, artID = { 704 }, x = 7634, y = 5853, overlay = { "7440-5660","7540-5780","7700-5800","7820-5680" }, displayID = 68273, questID = { 44003 } }; --Reef Lord Raj'his
	[103787] = { zoneID = 680, artID = { 704 }, x = 7580, y = 5020, overlay = { "2440-4960","3880-2960","7580-5020" }, displayID = 66850 }; --Baconlisk
	[103827] = { zoneID = 680, artID = { 704 }, x = 8740, y = 6260, overlay = { "8740-6240" }, displayID = 68605, questID = { 41786 } }; --King Morgalash
	[103841] = { zoneID = 680, artID = { 704 }, x = 1674, y = 2674, overlay = { "1620-2540","1640-2680" }, displayID = 64536, questID = { 43996 } }; --Shadowquill
	[104519] = { zoneID = 680, artID = { 704 }, x = 2460, y = 5400, overlay = { "2320-5820","2360-5640","2420-5460" }, displayID = 66577, questID = { 45503 } }; --Colerian
	[104521] = { zoneID = 680, artID = { 704 }, x = 2440, y = 5420, overlay = { "2300-5860","2340-5720","2420-5460" }, displayID = 66269, questID = { 45504 } }; --Alteria
	[104522] = { zoneID = 680, artID = { 704 }, x = 2460, y = 5400, overlay = { "2300-5860","2340-5740","2380-5560","2440-5420" }, displayID = 66268, questID = { 45502 } }; --Selenyi
	[104698] = { zoneID = 680, artID = { 704 }, x = 2440, y = 5400, overlay = { "2300-5860","2320-5640","2400-5500" }, displayID = 66577, questID = { 45503 } }; --Colerian
	[105547] = { zoneID = 680, artID = { 704 }, x = 2398, y = 2552, overlay = { "2340-2600" }, displayID = 69191, questID = { 43484 } }; --Rauren <Owlkitten Mat>
	[105632] = { zoneID = 680, artID = { 704 }, x = 2500, y = 4400, overlay = { "2500-4400" }, displayID = 69220, questID = { 99999 } }; --Broodmother Shu'malis
	[105728] = { zoneID = 680, artID = { 704 }, x = 2360, y = 4559, overlay = { "2340-4520" }, displayID = 72663, questID = { 45505 } }; --Scythemaster Cil'raman
	[105739] = { zoneID = 680, artID = { 704 }, x = 1980, y = 4000, overlay = { "1840-3960","1940-4060" }, displayID = 69268 }; --Sanaar
	[105899] = { zoneID = 680, artID = { 704 }, x = 6780, y = 5620, overlay = { "6520-5380","6660-5440","6720-5620" }, displayID = 72653, questID = { 45506 } }; --Oglok the Furious
	[106351] = { zoneID = 680, artID = { 704 }, x = 3383, y = 1559, overlay = { "3380-1500" }, displayID = 66577, questID = { 43717 } }; --Artificer Lothaire
	[106526] = { zoneID = 680, artID = { 704 }, x = 3559, y = 6720, overlay = { "3520-6700" }, displayID = 52317, questID = { 44675 } }; --Lady Rivantas
	[106532] = { zoneID = 680, artID = { 704 }, x = 3800, y = 7040, overlay = { "3780-7060" }, displayID = 64719, questID = { 44569 } }; --Inquisitor Volitix
	[107846] = { zoneID = 680, artID = { 704 }, x = 6665, y = 6712, overlay = { "6640-6720" }, displayID = 699, questID = { 43968 } }; --Pinchshank <Evil Death C>
	[109054] = { zoneID = 680, artID = { 704 }, x = 2600, y = 4100, overlay = { "2600-4100" }, displayID = 70831, questID = { 42831 } }; --Shal'an <Subject>
	[109954] = { zoneID = 680, artID = { 704 }, x = 4206, y = 8012, overlay = { "4200-8000" }, displayID = 66591, questID = { 43348 } }; --Magister Phaedris <Master of Decept>
	[110024] = { zoneID = 680, artID = { 704 }, x = 3420, y = 6080, overlay = { "3400-6040" }, displayID = 71290, questID = { 43351 } }; --Mal'Dreth the Corruptor
	[110340] = { zoneID = 680, artID = { 704 }, x = 4093, y = 3277, overlay = { "4040-3340" }, displayID = 71536, questID = { 43358 } }; --Myonix <Manasaber Mat>
	[110438] = { zoneID = 680, artID = { 704 }, x = 3696, y = 2110, overlay = { "3720-2140" }, displayID = 69530, questID = { 43369 } }; --Siegemaster Aedrin
	[110577] = { zoneID = 680, artID = { 704 }, x = 2460, y = 4743, overlay = { "2440-4720" }, displayID = 70831, questID = { 43449 } }; --Oreth the Vile
	[110656] = { zoneID = 680, artID = { 704 }, x = 6558, y = 5913, overlay = { "6540-5920" }, displayID = 70697, questID = { 43481 } }; --Arcanist Lylandre
	[110726] = { zoneID = 680, artID = { 704 }, x = 6273, y = 4855, overlay = { "6240-4660","6240-4840" }, displayID = 69435, questID = { 43495 } }; --Cadraeus
	[110832] = { zoneID = 680, artID = { 704 }, x = 2760, y = 6540, overlay = { "2720-6580" }, displayID = 65304, questID = { 43992 } }; --Gorgroth
	[110870] = { zoneID = 680, artID = { 704 }, x = 4225, y = 5657, overlay = { "4220-5640" }, displayID = 71580, questID = { 43580 } }; --Apothecary Faldren
	[110944] = { zoneID = 680, artID = { 704 }, x = 5931, y = 5186, overlay = { "5640-5040","5760-5080","5860-5160","6040-5240" }, displayID = 67465, questID = { 43597 } }; --Guardian Thor'el <The Eighth Shi>
	[111007] = { zoneID = 680, artID = { 704 }, x = 4964, y = 7898, overlay = { "4940-7900" }, displayID = 69435, questID = { 43603 } }; --Randril
	[111197] = { zoneID = 680, artID = { 704 }, x = 3366, y = 5177, overlay = { "3340-5100" }, displayID = 55080, questID = { 43954 } }; --Anax
	[111329] = { zoneID = 680, artID = { 704 }, x = 3618, y = 3384, overlay = { "3600-3400" }, displayID = 64303, questID = { 43718 } }; --Matron Hagatha
	[111649] = { zoneID = 680, artID = { 704 }, x = 5457, y = 6370, overlay = { "5440-6280","5440-6420" }, displayID = 64719, questID = { 43794 } }; --Ambassador D'vwinn
	[111651] = { zoneID = 680, artID = { 704 }, x = 5441, y = 5612, overlay = { "5441-5612" }, displayID = 71874, questID = { 43792 } }; --Degren
	[111653] = { zoneID = 680, artID = { 704 }, x = 6260, y = 6360, overlay = { "6240-6340" }, displayID = 71875, questID = { 43793 } }; --Miasu <Fel Aspir>
	[112497] = { zoneID = 680, artID = { 704 }, x = 2441, y = 3516, overlay = { "2440-3520" }, displayID = 68526, questID = { 44071 } }; --Maia the White
	[112705] = { zoneID = 680, artID = { 704 }, x = 5720, y = 7600, overlay = { "5600-7420","5720-7600" }, displayID = 72198, questID = { 45478 } }; --Achronos
	[112756] = { zoneID = 680, artID = { 704 }, x = 2935, y = 8889, overlay = { "2920-8880" }, displayID = 63676, questID = { 45477 } }; --Sorallus
	[112757] = { zoneID = 680, artID = { 704 }, x = 4960, y = 7960, overlay = { "4940-7940" }, displayID = 72280, questID = { 45476 } }; --Magistrix Vilessa
	[112758] = { zoneID = 680, artID = { 704 }, x = 5760, y = 6700, overlay = { "5680-6760" }, displayID = 72281, questID = { 45475 } }; --Auditor Esiel
	[112759] = { zoneID = 680, artID = { 704 }, x = 8160, y = 6180, overlay = { "8120-6260" }, displayID = 68084, questID = { 45471 } }; --Az'jatar
	[112760] = { zoneID = 680, artID = { 704 }, x = 4960, y = 5800, overlay = { "4940-5820" }, displayID = 72244, questID = { 45474 } }; --Volshax, Breaker of Will
	[112802] = { zoneID = 680, artID = { 704 }, x = 1380, y = 5240, overlay = { "1340-5340" }, displayID = 44781, questID = { 44124 } }; --Mar'tura
	[113694] = { zoneID = 680, artID = { 704 }, x = 6619, y = 5360, overlay = { "6020-4080","6200-4680","6240-5220","6420-4740","6620-5340" }, displayID = 67421 }; --Pashya
	[99610] = { zoneID = 680, artID = { 704 }, x = 5300, y = 3020, overlay = { "5300-3020" }, displayID = 64664, questID = { 40897 } }; --Garvrulg <Slatecrusher Ex>
	[99792] = { zoneID = 680, artID = { 704 }, x = 2215, y = 5178, overlay = { "2200-5140","2300-5220" }, displayID = 66341, questID = { 41319 } }; --Elfbane
	[99899] = { zoneID = 680, artID = { 704 }, x = 8020, y = 6580, overlay = { "7600-6080","7620-5820","7900-5800","7900-6500","7920-6240","8020-6580" }, displayID = 68227, questID = { 44669 } }; --Vicious Whale Shark
	[96647] = { zoneID = 703, artID = { 727 }, x = 2500, y = 5460, displayID = 34706 }; --Earlnoc the Beastbreaker
	[99802] = { zoneID = 703, artID = { 727 }, x = 5579, y = 6040, displayID = 24490 }; --Arthfael
	[103045] = { zoneID = 707, artID = { 731 }, x = 4159, y = 5980, displayID = 67969, questID = { 43691 } }; --Plaguemaw
	[103605] = { zoneID = 707, artID = { 731 }, x = 3120, y = 5840, displayID = 65753, questID = { 43690 } }; --Shroudseeker
	[108494] = { zoneID = 707, artID = { 731 }, x = 3180, y = 5600, displayID = 70577, questID = { 43689 } }; --Soulfiend Tagerma <Corruptor of the S>
	[108794] = { zoneID = 707, artID = { 731 }, x = 3140, y = 5520, displayID = 65753 }; --Shroudseeker's Shadow
	[96997] = { zoneID = 711, artID = { 735 }, x = 5320, y = 2960, overlay = { "4620-2840","4820-3340","4840-2920","4840-3120","4900-3240","4940-3360","5000-2700","5020-3120","5180-2920","5320-2960" }, displayID = 68182, questID = { 40251 } }; --Kethrazor
	[97069] = { zoneID = 711, artID = { 735 }, x = 6960, y = 2780, overlay = { "6800-2800","6900-2620","6900-2880","6900-3020" }, displayID = 20047, questID = { 40301 } }; --Wrath-Lord Lekos
	[101411] = { zoneID = 713, artID = { 737 }, x = 2420, y = 3100, displayID = 44923 }; --Gom Crabbar <One Huge C>
	[101467] = { zoneID = 713, artID = { 737 }, x = 8860, y = 3579, overlay = { "8820-3600" }, displayID = 17654 }; --Jaggen-Ra <Stepping St>
	[108541] = { zoneID = 713, artID = { 737 }, x = 2540, y = 2979, displayID = 27870 }; --Dread Corsair
	[108543] = { zoneID = 713, artID = { 737 }, x = 2580, y = 3040, overlay = { "2580-3040" }, displayID = 35574 }; --Dread Captain Thedon
	[91788] = { zoneID = 713, artID = { 737 }, x = 3140, y = 5060, displayID = 67197 }; --Shellmaw <Maw in a Sh>
	[112708] = { zoneID = 726, artID = { 750 }, x = 2760, y = 4280, overlay = { "2520-4140","2720-4240" }, displayID = 32457 }; --Grimtotem Champion
	[103199] = { zoneID = 731, artID = { 756 }, x = 3540, y = 7940, displayID = 68076 }; --Ragoul
	[103247] = { zoneID = 731, artID = { 756 }, x = 6220, y = 8819, displayID = 68143 }; --Ultanok
	[103271] = { zoneID = 731, artID = { 756 }, x = 4220, y = 1260, displayID = 66850 }; --Kraxa <Mother of Gnash>
	[101641] = { zoneID = 733, artID = { 758 }, x = 2997, y = 3924, displayID = 67273 }; --Mythana
	[101660] = { zoneID = 733, artID = { 758 }, x = 1700, y = 2020, displayID = 67290 }; --Rage Rot
	[99362] = { zoneID = 733, artID = { 758 }, x = 3340, y = 8120, displayID = 57886 }; --Kudzilla
	[111021] = { zoneID = 749, artID = { 774 }, x = 4802, y = 8153, displayID = 32962 }; --Sludge Face
	[111052] = { zoneID = 749, artID = { 774 }, x = 4720, y = 4120, displayID = 71702 }; --Silver Serpent
	[111057] = { zoneID = 749, artID = { 774 }, x = 3460, y = 5020, displayID = 20852 }; --The Rat King
	[115847] = { zoneID = 765, artID = { 790 }, x = 3959, y = 4378, displayID = 73967 }; --Ariadne
	[115914] = { zoneID = 765, artID = { 790 }, x = 4690, y = 5643, displayID = 71134 }; --Torm the Brute
	[112712] = { zoneID = 766, artID = { 791 }, x = 4500, y = 3020, displayID = 72206 }; --Gilded Guardian <Spellblade's Constr>
	[116008] = { zoneID = 766, artID = { 791 }, x = 4624, y = 4487, displayID = 74021 }; --Kar'zun
	[116004] = { zoneID = 767, artID = { 792 }, x = 2075, y = 5880, displayID = 66836 }; --Flightmaster Volnath <Flight Mas>
	[116059] = { zoneID = 767, artID = { 792 }, x = 2095, y = 5999, displayID = 74348 }; --Regal Cloudwing
	[116158] = { zoneID = 767, artID = { 792 }, x = 5935, y = 4813, displayID = 69968 }; --Tower Concubine
	[116159] = { zoneID = 767, artID = { 792 }, x = 0000, y = 0000, displayID = 69961 }; --Wily Sycophant
	[116185] = { zoneID = 767, artID = { 792 }, x = 0000, y = 0000, displayID = 74089 }; --Attendant Keeper
	[116395] = { zoneID = 767, artID = { 792 }, x = 4493, y = 4882, displayID = 69552 }; --Nightwell Diviner
	[115853] = { zoneID = 768, artID = { 793 }, x = 5758, y = 4823, displayID = 55774 }; --Doomlash
	[116230] = { zoneID = 772, artID = { 797 }, x = 5006, y = 0342, displayID = 74106 }; --Exotic Concubine
	[111573] = { zoneID = 790, artID = { 815 }, x = 5106, y = 5092, overlay = { "4520-5060","4620-4980","4640-4780","4760-4780","4780-4920","5106-5092" }, displayID = 71850, questID = { 45479 } }; --Kosumoth the Hungering
	[120393] = { zoneID = 830, artID = { 855 }, x = 5833, y = 7584, overlay = { "5820-7540","5840-7660" }, displayID = 75765, questID = { 48627 } }; --Siegemaster Voraan
	[122911] = { zoneID = 830, artID = { 855 }, x = 3960, y = 5880, overlay = { "3820-5940","3960-5840" }, displayID = 78156, questID = { 48563 } }; --Commander Vecaya
	[122912] = { zoneID = 830, artID = { 855 }, x = 3340, y = 7570, overlay = { "3320-7580" }, displayID = 78814, questID = { 48562 } }; --Commander Sathrenael
	[123464] = { zoneID = 830, artID = { 855 }, x = 5282, y = 3096, overlay = { "5240-3140" }, displayID = 77324, questID = { 48565 } }; --Sister Subversia <Coven of Shiva>
	[123689] = { zoneID = 830, artID = { 855 }, x = 5560, y = 8000, overlay = { "5480-8120" }, displayID = 77540, questID = { 48628 } }; --Talestra the Vile
	[124775] = { zoneID = 830, artID = { 855 }, x = 4529, y = 5881, overlay = { "4440-5860" }, displayID = 78200, questID = { 48564 } }; --Commander Endaxis
	[124804] = { zoneID = 830, artID = { 855 }, x = 6960, y = 5680, overlay = { "6940-5680" }, displayID = 78217, questID = { 48664 } }; --Tereck the Selector
	[125388] = { zoneID = 830, artID = { 855 }, x = 6100, y = 2060, overlay = { "6080-1980" }, displayID = 74446, questID = { 48629 } }; --Vagath the Betrayed
	[125479] = { zoneID = 830, artID = { 855 }, x = 6981, y = 8091, overlay = { "6940-8060","7020-8160" }, displayID = 41574, questID = { 48665 } }; --Tar Spitter
	[125820] = { zoneID = 830, artID = { 855 }, x = 4242, y = 6987, overlay = { "4220-7000" }, displayID = 72942, questID = { 48666 } }; --Imp Mother Laglath
	[126419] = { zoneID = 830, artID = { 855 }, x = 7092, y = 3338, overlay = { "7040-3400","7100-3240" }, displayID = 78926, questID = { 48667 } }; --Naroua <King of the For>
	[125824] = { zoneID = 833, artID = { 858 }, x = 4479, y = 4820, overlay = { "3620-3560","3620-3720","3700-3860","3740-4000","3800-3640","3800-4240","3840-4100","3860-3940","3920-4200","3940-3840","3960-3720","3980-4060","4020-4520","4040-4260","4040-4380","4100-4040","4160-4240","4160-4500","4240-4740","4340-4840","4480-4820" }, displayID = 78946, questID = { 48561 } }; --Khazaduum
	[120713] = { zoneID = 846, artID = { 871 }, x = 7227, y = 5109, displayID = 20914 }; --Wa'glur
	[120715] = { zoneID = 846, artID = { 871 }, x = 6015, y = 1868, displayID = 66219 }; --Raga'yut
	[120717] = { zoneID = 846, artID = { 871 }, x = 4750, y = 1167, displayID = 57400 }; --Mistress Dominix
	[120716] = { zoneID = 848, artID = { 873 }, x = 5283, y = 1898, displayID = 74572 }; --Dreadspeaker Serilis
	[120712] = { zoneID = 849, artID = { 874 }, x = 4703, y = 8746, displayID = 29442 }; --Larithia
	[120020] = { zoneID = 851, artID = { 876 }, x = 6278, y = 5702, displayID = 76068 }; --Erdu'val
	[120003] = { zoneID = 852, artID = { 877 }, x = 6436, y = 6463, displayID = 75588 }; --Warlord Darjah
	[120012] = { zoneID = 852, artID = { 877 }, x = 6397, y = 6256, displayID = 75602 }; --Dresanoth
	[120013] = { zoneID = 852, artID = { 877 }, x = 5935, y = 8776, displayID = 75603 }; --The Dread Stalker
	[120021] = { zoneID = 852, artID = { 877 }, x = 3274, y = 5179, displayID = 75607 }; --Kelpfist
	[120022] = { zoneID = 852, artID = { 877 }, x = 6192, y = 8647, displayID = 75608 }; --Deepmaw
	[120019] = { zoneID = 853, artID = { 878 }, x = 5138, y = 3825, displayID = 75605 }; --Ryul the Fading
	[122004] = { zoneID = 862, artID = { 887 }, x = 7141, y = 3239, overlay = { "7120-3240" }, displayID = 83645, questID = { 47567 } }; --Umbra'jin <The Night Hun>
	[124185] = { zoneID = 862, artID = { 887 }, x = 7411, y = 2850, overlay = { "7400-2820" }, displayID = 42949, questID = { 47792 } }; --Golrakahn
	[126637] = { zoneID = 862, artID = { 887 }, x = 6865, y = 4876, overlay = { "6860-4840" }, displayID = 79019, questID = { 48543 } }; --Kandak
	[127939] = { zoneID = 862, artID = { 887 }, x = 4673, y = 6532, overlay = { "4640-6520" }, displayID = 79702, questID = { 49004 } }; --Torraske the Eternal
	[128699] = { zoneID = 862, artID = { 887 }, x = 5984, y = 1829, overlay = { "5940-1840" }, displayID = 83539, questID = { 49267 } }; --Bloodbulge
	[129343] = { zoneID = 862, artID = { 887 }, x = 4983, y = 5742, overlay = { "4980-5740" }, displayID = 86628, questID = { 49410 } }; --Avatar of Xolotal
	[129954] = { zoneID = 862, artID = { 887 }, x = 6389, y = 3310, overlay = { "6420-3280" }, displayID = 58892, questID = { 50439 } }; --Gahz'ralka
	[129961] = { zoneID = 862, artID = { 887 }, x = 8096, y = 2160, overlay = { "8080-2140" }, displayID = 82078, questID = { 50280 } }; --Atal'zul Gotaka
	[130643] = { zoneID = 862, artID = { 887 }, x = 7679, y = 2775, overlay = { "7660-2740" }, displayID = 82976, questID = { 50333 } }; --Twisted Child of Rezan
	[131233] = { zoneID = 862, artID = { 887 }, x = 5867, y = 7417, overlay = { "5880-7420" }, displayID = 42065, questID = { 49911 } }; --Lei-zhi
	[131476] = { zoneID = 862, artID = { 887 }, x = 4799, y = 5423, overlay = { "4820-5420" }, displayID = 81852, questID = { 49972 } }; --Zayoos <Da'kani Witch Doc>
	[131687] = { zoneID = 862, artID = { 887 }, x = 7766, y = 1050, overlay = { "7740-1120" }, displayID = 44916, questID = { 50013 } }; --Tambano <The Clawed Hor>
	[131704] = { zoneID = 862, artID = { 887 }, x = 6276, y = 1408, overlay = { "6280-1400" }, displayID = 83795, questID = { 50661 } }; --Coati
	[131718] = { zoneID = 862, artID = { 887 }, x = 6674, y = 3229, overlay = { "6640-3240" }, displayID = 76655, questID = { 50034 } }; --Bramblewing
	[132244] = { zoneID = 862, artID = { 887 }, x = 7562, y = 3590, overlay = { "7540-3580" }, displayID = 77474, questID = { 50159 } }; --Kiboku <The Hillsha>
	[132253] = { zoneID = 862, artID = { 887 }, x = 6960, y = 2948, overlay = { "6960-2948" }, displayID = 76667, weeklyReset = true, questID = { 52998 } }; --Ji'arak
	[133155] = { zoneID = 862, artID = { 887 }, x = 7997, y = 3595, overlay = { "8000-3600" }, displayID = 68084, questID = { 50260 } }; --G'Naat <The Boiling T>
	[133163] = { zoneID = 862, artID = { 887 }, x = 6428, y = 2324, overlay = { "6440-2300" }, displayID = 47818, questID = { 50263 } }; --Tia'Kawan <The Ill-Tempe>
	[133190] = { zoneID = 862, artID = { 887 }, x = 7416, y = 3932, overlay = { "7420-3940" }, displayID = 40913, questID = { 50269 } }; --Daggerjaw
	[133842] = { zoneID = 862, artID = { 887 }, x = 4393, y = 2543, overlay = { "4400-2540" }, displayID = 79721, questID = { 50438 } }; --Warcrawler Karkithiss
	[134048] = { zoneID = 862, artID = { 887 }, x = 6187, y = 4623, overlay = { "6200-4620" }, displayID = 4065, questID = { 50508 } }; --Vukuba <The Impos>
	[134637] = { zoneID = 862, artID = { 887 }, x = 6292, y = 1391, overlay = { "6300-1400" }, displayID = 83842, questID = { 50661 } }; --Headhunter Lee'za
	[134717] = { zoneID = 862, artID = { 887 }, x = 4917, y = 2927, overlay = { "4900-2920" }, displayID = 53283, questID = { 50673 } }; --Umbra'rix <Servant of Sha>
	[134738] = { zoneID = 862, artID = { 887 }, x = 4203, y = 3621, overlay = { "4220-3600" }, displayID = 83798, questID = { 50677 } }; --Hakbi the Risen
	[134760] = { zoneID = 862, artID = { 887 }, x = 6536, y = 1023, overlay = { "6520-1020" }, displayID = 83849, questID = { 50693 } }; --Darkspeaker Jo'la <Adherent of>
	[134782] = { zoneID = 862, artID = { 887 }, x = 6043, y = 6652, overlay = { "6060-6620" }, displayID = 55918, questID = { 50281 } }; --Murderbeak
	[136413] = { zoneID = 862, artID = { 887 }, x = 5339, y = 4465, overlay = { "5340-4460" }, displayID = 74896, questID = { 51080 } }; --Syrawon the Dominus
	[136428] = { zoneID = 862, artID = { 887 }, x = 4412, y = 7651, overlay = { "4400-7640" }, displayID = 83266, questID = { 51083 } }; --Dark Chronicler <Voice of the Bo>
	[142434] = { zoneID = 862, artID = { 887 }, x = 7060, y = 0819, overlay = { "7060-0820" }, displayID = 8844 }; --Loo'ay <King of the Monk>
	[142475] = { zoneID = 862, artID = { 887 }, x = 7060, y = 0819, overlay = { "7060-0820" }, displayID = 33971 }; --Ka'za the Mezmerizing
	[143314] = { zoneID = 862, artID = { 887 }, x = 4559, y = 7900, overlay = { "4540-7920" }, displayID = 83608, reset = true }; --Bane of the Woods
	[143536] = { zoneID = 862, artID = { 887 }, x = 5160, y = 5820, overlay = { "5140-5820" }, friendly = { "H" }, displayID = 82682 }; --High Warlord Volrath <War Capt>
	[145391] = { zoneID = 862, artID = { 887 }, x = 7733, y = 3737, overlay = { "7720-3740" }, friendly = { "A" }, displayID = 90018, questReset = true, questID = { 54016 } }; --Caravan Leader
	[148198] = { zoneID = 862, artID = { 887 }, x = 7719, y = 4179, overlay = { "7720-4180" }, friendly = { "H" }, displayID = 89913, questID = { 54504 } }; --Scout Captain Grizzleknob
	[148231] = { zoneID = 862, artID = { 887 }, x = 7619, y = 3559, overlay = { "7620-3540" }, friendly = { "H" }, displayID = 89929, questReset = true, questID = { 54508 } }; --Siegebreaker Vol'gar
	[148253] = { zoneID = 862, artID = { 887 }, x = 7860, y = 5579, overlay = { "7840-5540" }, friendly = { "H" }, displayID = 89938, questReset = true, questID = { 54511 } }; --Death Captain Detheca
	[148257] = { zoneID = 862, artID = { 887 }, x = 7860, y = 5579, overlay = { "7840-5540" }, friendly = { "H" }, displayID = 89939, questReset = true, questID = { 54511 } }; --Death Captain Danielle
	[148259] = { zoneID = 862, artID = { 887 }, x = 7860, y = 5579, overlay = { "7840-5540" }, friendly = { "H" }, displayID = 89941, questReset = true, questID = { 54511 } }; --Death Captain Delilah
	[148264] = { zoneID = 862, artID = { 887 }, x = 6740, y = 3760, overlay = { "6720-3740" }, friendly = { "H" }, displayID = 89945, questReset = true, questID = { 54513 } }; --Dinomancer Dajingo
	[148276] = { zoneID = 862, artID = { 887 }, x = 8319, y = 5280, overlay = { "8320-5280" }, friendly = { "H" }, displayID = 89947, questID = { 54515 } }; --Tidebinder Maka
	[148308] = { zoneID = 862, artID = { 887 }, x = 7709, y = 4890, overlay = { "7700-4880" }, displayID = 89964, questReset = true, questID = { 54522 } }; --Eric Quietfist
	[148322] = { zoneID = 862, artID = { 887 }, x = 7627, y = 3349, overlay = { "7620-3340" }, friendly = { "A" }, displayID = 89968, questID = { 54523 } }; --Blinky Gizmospark
	[148343] = { zoneID = 862, artID = { 887 }, x = 6491, y = 3999, overlay = { "6480-3980" }, friendly = { "A" }, displayID = 89972, questID = { 54527 } }; --Dinohunter Wildbeard
	[148390] = { zoneID = 862, artID = { 887 }, x = 7547, y = 3590, overlay = { "7540-3600" }, friendly = { "A" }, displayID = 90008, questReset = true, questID = { 54532 } }; --Jessibelle Moonshield
	[148393] = { zoneID = 862, artID = { 887 }, x = 7567, y = 3576, overlay = { "7540-3600" }, friendly = { "A" }, displayID = 54675, questReset = true, questID = { 54532 } }; --Ancient Defender
	[148403] = { zoneID = 862, artID = { 887 }, x = 7956, y = 4378, overlay = { "7900-4440" }, friendly = { "A" }, displayID = 90013, questID = { 54535 } }; --Portal Keeper Romiir
	[148428] = { zoneID = 862, artID = { 887 }, x = 7520, y = 4960, overlay = { "7520-4940" }, friendly = { "H" }, displayID = 88884, questID = { 54537 } }; --Bilestomper
	[149147] = { zoneID = 862, artID = { 887 }, x = 6958, y = 3765, overlay = { "6940-3540","6940-3680" }, displayID = 83648, questID = { 54770 } }; --N'chala the Egg Thief
	[121242] = { zoneID = 863, artID = { 888 }, x = 6877, y = 5747, overlay = { "6840-5640","6840-5760" }, displayID = 32264, questID = { 50361 } }; --Glompmaw
	[124375] = { zoneID = 863, artID = { 888 }, x = 6210, y = 6520, overlay = { "6200-6500" }, displayID = 77980, questID = { 47827 } }; --Overstuffed Saurolisk
	[124397] = { zoneID = 863, artID = { 888 }, x = 5290, y = 1315, overlay = { "5280-1320" }, displayID = 80333, questID = { 47843 } }; --Kal'draxa <Bane of Blood Tro>
	[124399] = { zoneID = 863, artID = { 888 }, x = 2439, y = 7791, overlay = { "2440-7800" }, displayID = 74268, questID = { 47877 } }; --Infected Direhorn
	[124475] = { zoneID = 863, artID = { 888 }, x = 2915, y = 5585, overlay = { "2920-5540" }, displayID = 79803, questID = { 47878 } }; --Shambling Ambusher
	[125214] = { zoneID = 863, artID = { 888 }, x = 7570, y = 3593, overlay = { "7580-3600" }, displayID = 50962, questID = { 48052 } }; --Krubbs <The Iron Sh>
	[125232] = { zoneID = 863, artID = { 888 }, x = 8160, y = 2920, overlay = { "8180-3040","8160-2920" }, displayID = 80189, questID = { 48057 } }; --Captain Mu'kala <The Cur>
	[125250] = { zoneID = 863, artID = { 888 }, x = 6780, y = 2947, overlay = { "6740-2940" }, displayID = 78396, questID = { 48063 } }; --Ancient Jawbreaker
	[126056] = { zoneID = 863, artID = { 888 }, x = 4942, y = 3769, overlay = { "4940-3740" }, displayID = 78669, questID = { 48406 } }; --Totem Maker Jash'ga
	[126142] = { zoneID = 863, artID = { 888 }, x = 4283, y = 6053, overlay = { "4200-6060" }, displayID = 78750, questID = { 48439 } }; --Bajiatha <The  Scavenger Matria>
	[126187] = { zoneID = 863, artID = { 888 }, x = 4131, y = 5343, overlay = { "4120-5340" }, displayID = 78779, questID = { 48462 } }; --Corpse Bringer Yal'kar
	[126460] = { zoneID = 863, artID = { 888 }, x = 3146, y = 3818, overlay = { "3140-3820" }, displayID = 81103, questID = { 48508 } }; --Tainted Guardian
	[126635] = { zoneID = 863, artID = { 888 }, x = 4320, y = 9137, overlay = { "4320-9120" }, displayID = 79016, questID = { 48541 } }; --Blood Priest Xak'lar
	[126907] = { zoneID = 863, artID = { 888 }, x = 4897, y = 5077, overlay = { "4900-5080" }, displayID = 79159, questID = { 48623 } }; --Wardrummer Zurula
	[126926] = { zoneID = 863, artID = { 888 }, x = 2986, y = 5069, overlay = { "2920-5040","2980-5180" }, displayID = 40269, questID = { 48626 } }; --Venomjaw
	[127001] = { zoneID = 863, artID = { 888 }, x = 3380, y = 8599, overlay = { "3340-8700" }, displayID = 79591, questID = { 48638 } }; --Gwugnug the Cursed
	[127820] = { zoneID = 863, artID = { 888 }, x = 5913, y = 3878, overlay = { "5900-3900" }, displayID = 82183, questID = { 48972 } }; --Scout Skrasniss
	[127873] = { zoneID = 863, artID = { 888 }, x = 5808, y = 0893, overlay = { "5740-0940","5760-0820","5860-0940" }, displayID = 83648, questID = { 48980 } }; --Scrounger Patriarch
	[128426] = { zoneID = 863, artID = { 888 }, x = 3276, y = 4312, overlay = { "3240-4340","3260-4220" }, displayID = 79919, questID = { 49231 } }; --Gutrip <The Hun>
	[128578] = { zoneID = 863, artID = { 888 }, x = 3957, y = 4983, overlay = { "3940-5000" }, displayID = 65837, questID = { 50460 } }; --Zujothgul <The Terrace Guard>
	[128584] = { zoneID = 863, artID = { 888 }, x = 4674, y = 3373, overlay = { "4680-3340" }, displayID = 66284, questID = { 50366 } }; --Vugthuth <The Underrot Abominat>
	[128610] = { zoneID = 863, artID = { 888 }, x = 4989, y = 6720, overlay = { "4980-6700" }, displayID = 88376, questID = { 50467 } }; --Maw of Shul-Nagruth
	[128930] = { zoneID = 863, artID = { 888 }, x = 5261, y = 5434, overlay = { "5240-5340","5240-5460" }, displayID = 78853, questID = { 50040 } }; --Rohnkor
	[128935] = { zoneID = 863, artID = { 888 }, x = 5262, y = 5382, overlay = { "5240-5340","5280-5460" }, displayID = 76134, questID = { 50040 } }; --Mala'kili <Rohnkor Kee>
	[128965] = { zoneID = 863, artID = { 888 }, x = 4426, y = 4877, overlay = { "4400-4840" }, displayID = 80299, questID = { 49305 } }; --Uroku the Bound
	[128974] = { zoneID = 863, artID = { 888 }, x = 5771, y = 6770, overlay = { "5740-6780" }, displayID = 80307, questID = { 49312 } }; --Queen Tzxi'kik
	[129005] = { zoneID = 863, artID = { 888 }, x = 5342, y = 4283, overlay = { "5320-4280" }, displayID = 80326, questID = { 49317 } }; --King Kooba
	[129657] = { zoneID = 863, artID = { 888 }, x = 3879, y = 2676, overlay = { "3880-2700" }, displayID = 80186, questID = { 49469 } }; --Za'amar the Queen's Blade
	[132701] = { zoneID = 863, artID = { 888 }, x = 3547, y = 3322, overlay = { "3540-3240","3540-3360" }, displayID = 82592, weeklyReset = true, questID = { 52181 } }; --T'zane <The Soul Ter>
	[133373] = { zoneID = 863, artID = { 888 }, x = 4517, y = 5189, overlay = { "4520-5180" }, displayID = 82877, questID = { 50307 } }; --Jax'teb the Reanimated
	[133527] = { zoneID = 863, artID = { 888 }, x = 2807, y = 3382, overlay = { "2740-3420","2860-3340" }, displayID = 47819, questID = { 50342 } }; --Juba the Scarred
	[133531] = { zoneID = 863, artID = { 888 }, x = 3653, y = 5051, overlay = { "3660-5040" }, displayID = 82986, questID = { 50348 } }; --Xu'ba <The Bone Collec>
	[133539] = { zoneID = 863, artID = { 888 }, x = 7775, y = 4509, overlay = { "7740-4440","7740-4560","7860-4420" }, displayID = 82989, questID = { 50355 } }; --Lo'kuno
	[133812] = { zoneID = 863, artID = { 888 }, x = 3877, y = 7144, overlay = { "3840-7140" }, displayID = 83646, questID = { 50423 } }; --Zanxib <The Engor>
	[134002] = { zoneID = 863, artID = { 888 }, x = 5534, y = 5763, overlay = { "5520-5740" }, displayID = 63570, questID = { 50480 } }; --Underlord Xerxiz
	[134293] = { zoneID = 863, artID = { 888 }, x = 3313, y = 2699, overlay = { "3320-2700" }, displayID = 82998, questID = { 50563 } }; --Azerite-Infused Slag
	[134294] = { zoneID = 863, artID = { 888 }, x = 8169, y = 6089, overlay = { "8140-6080" }, displayID = 34274, questID = { 50565 } }; --Enraged Water Elemental
	[134296] = { zoneID = 863, artID = { 888 }, x = 6810, y = 2023, overlay = { "6800-2000" }, displayID = 71937, questID = { 50567 } }; --Lucille
	[134298] = { zoneID = 863, artID = { 888 }, x = 5411, y = 8107, overlay = { "5400-8040" }, displayID = 83535, questID = { 50569 } }; --Azerite-Infused Elemental
	[143311] = { zoneID = 863, artID = { 888 }, x = 7360, y = 4880, overlay = { "7340-4900" }, displayID = 83606, reset = true }; --Toadcruel
	[143316] = { zoneID = 863, artID = { 888 }, x = 5259, y = 7000, overlay = { "5240-6920" }, displayID = 83607, reset = true }; --Skullcap
	[148637] = { zoneID = 863, artID = { 888 }, x = 5259, y = 2260, overlay = { "5220-2240" }, friendly = { "H" }, displayID = 90085, questReset = true, questID = { 54663 } }; --Shadow Hunter Vol'tris
	[148642] = { zoneID = 863, artID = { 888 }, x = 8266, y = 4218, overlay = { "8240-4140","8260-4300" }, friendly = { "A" }, displayID = 90018, questReset = true, questID = { 54664 } }; --Caravan Leader
	[148651] = { zoneID = 863, artID = { 888 }, x = 4229, y = 2302, overlay = { "4220-2240","4240-2360" }, friendly = { "A" }, displayID = 89962, questReset = true, questID = { 54671 } }; --Overgrown Ancient
	[148674] = { zoneID = 863, artID = { 888 }, x = 7119, y = 1860, overlay = { "7120-1840" }, friendly = { "H" }, displayID = 90101, questReset = true, questID = { 54680 } }; --Plague Master Herbert
	[148679] = { zoneID = 863, artID = { 888 }, x = 6320, y = 0300, overlay = { "6300-0400" }, friendly = { "H" }, displayID = 90105, questReset = true, questID = { 54684 } }; --Arcanist Quintril
	[148744] = { zoneID = 863, artID = { 888 }, x = 5080, y = 2660, overlay = { "5080-2640" }, friendly = { "H" }, displayID = 90116, questReset = true, questID = { 54691 } }; --Brewmaster Lin
	[148753] = { zoneID = 863, artID = { 888 }, x = 5280, y = 1360, overlay = { "5280-1340" }, friendly = { "H" }, displayID = 90125, questReset = true, questID = { 54693 } }; --Ptin'go <Pterror of the Sk>
	[148759] = { zoneID = 863, artID = { 888 }, x = 4900, y = 1620, overlay = { "4880-1660" }, friendly = { "H" }, displayID = 90128, questReset = true, questID = { 54694 } }; --Stormcaller Morka
	[148779] = { zoneID = 863, artID = { 888 }, x = 8065, y = 1546, overlay = { "8040-1540" }, friendly = { "A" }, displayID = 75584, questReset = true, questID = { 54697 } }; --Lightforged Warframe
	[148792] = { zoneID = 863, artID = { 888 }, x = 4888, y = 1174, overlay = { "4880-1180" }, friendly = { "A" }, displayID = 90131, questReset = true, questID = { 54699 } }; --Skycaptain Thermospark
	[148813] = { zoneID = 863, artID = { 888 }, x = 5218, y = 2766, overlay = { "5220-2760" }, friendly = { "A" }, displayID = 90138, questReset = true, questID = { 54700 } }; --Thomas Vandergrief
	[148842] = { zoneID = 863, artID = { 888 }, x = 5420, y = 0780, overlay = { "5400-0740" }, friendly = { "A" }, displayID = 32648, questReset = true, questID = { 54707 } }; --Siegeotron
	[149383] = { zoneID = 863, artID = { 888 }, x = 5060, y = 1760, overlay = { "5040-1720" }, friendly = { "H" }, displayID = 90305, questReset = true, questID = { 54839 } }; --Xizz Gutshank
	[124722] = { zoneID = 864, artID = { 889 }, x = 4251, y = 9208, overlay = { "4260-9220" }, displayID = 79859, questID = { 50905 } }; --Commodore Calhoun <Ashvane Trading>
	[127776] = { zoneID = 864, artID = { 889 }, x = 4422, y = 8014, overlay = { "4440-8020" }, displayID = 79365, questID = { 48960 } }; --Scaleclaw Broodmother
	[128497] = { zoneID = 864, artID = { 889 }, x = 3100, y = 8108, overlay = { "3100-8080" }, displayID = 80176, questID = { 49251 } }; --Bajiani the Slick <The Grogmas>
	[128553] = { zoneID = 864, artID = { 889 }, x = 4902, y = 8903, overlay = { "4880-8900" }, displayID = 82998, questID = { 49252 } }; --Azer'tor
	[128674] = { zoneID = 864, artID = { 889 }, x = 6402, y = 4750, overlay = { "6400-4760" }, displayID = 80078, questID = { 49270 } }; --Gut-Gut the Glutton
	[128686] = { zoneID = 864, artID = { 889 }, x = 3506, y = 5183, overlay = { "3520-5140" }, displayID = 83351, questID = { 50528 } }; --Kamid the Trapper
	[128951] = { zoneID = 864, artID = { 889 }, x = 4376, y = 8623, overlay = { "4380-8640" }, displayID = 80291, questID = { 50898 } }; --Nez'ara
	[129027] = { zoneID = 864, artID = { 889 }, x = 5923, y = 0785, overlay = { "5740-0640","5840-0760","5940-0860" }, displayID = 76904, questID = { 50362 } }; --Golanar <The River L>
	[129180] = { zoneID = 864, artID = { 889 }, x = 3706, y = 4604, overlay = { "3700-4620" }, displayID = 80424, questID = { 49373 } }; --Warbringer Hozzik
	[129283] = { zoneID = 864, artID = { 889 }, x = 3740, y = 8522, overlay = { "3740-8440" }, displayID = 80500, questID = { 49392 } }; --Jumbo Sandsnapper
	[129411] = { zoneID = 864, artID = { 889 }, x = 4390, y = 5404, overlay = { "4380-5380" }, displayID = 80585, questID = { 48319 } }; --Zunashi the Exile
	[129476] = { zoneID = 864, artID = { 889 }, x = 4887, y = 5002, overlay = { "4880-5060" }, displayID = 80618, questID = { 47562 } }; --Bloated Krolusk
	[130401] = { zoneID = 864, artID = { 889 }, x = 5731, y = 7329, overlay = { "5720-7320" }, displayID = 81189, questID = { 49674 } }; --Vathikur
	[130439] = { zoneID = 864, artID = { 889 }, x = 5470, y = 1513, overlay = { "5460-1520" }, displayID = 49064, questID = { 47532 } }; --Ashmane
	[130443] = { zoneID = 864, artID = { 889 }, x = 5360, y = 5372, overlay = { "5360-5340" }, displayID = 81233, questID = { 47533 } }; --Hivemother Kraxi
	[133843] = { zoneID = 864, artID = { 889 }, x = 4157, y = 2384, overlay = { "4120-2420" }, displayID = 80412, questID = { 51073 } }; --First Mate Swainbeak <The Tropic Temp>
	[134571] = { zoneID = 864, artID = { 889 }, x = 4697, y = 2517, overlay = { "4700-2540" }, displayID = 83761, questID = { 50637 } }; --Skycaller Teskris <The Thun>
	[134625] = { zoneID = 864, artID = { 889 }, x = 5071, y = 3088, overlay = { "5080-3100" }, displayID = 82117, questID = { 50658 } }; --Warmother Captive
	[134638] = { zoneID = 864, artID = { 889 }, x = 3019, y = 5255, overlay = { "3000-5240" }, displayID = 80681, questID = { 50662 } }; --Warlord Zothix
	[134643] = { zoneID = 864, artID = { 889 }, x = 2978, y = 4646, overlay = { "3000-4620" }, displayID = 83810 }; --Brgl-Lrgl the Basher
	[134694] = { zoneID = 864, artID = { 889 }, x = 3743, y = 8910, overlay = { "3740-8820" }, displayID = 83816, questID = { 50666 } }; --Mor'fani the Exile
	[134745] = { zoneID = 864, artID = { 889 }, x = 5129, y = 3645, overlay = { "5140-3620" }, displayID = 83840, questID = { 50686 } }; --Skycarver Krakit
	[135852] = { zoneID = 864, artID = { 889 }, x = 5032, y = 8163, overlay = { "5020-8160" }, displayID = 76667, questID = { 51058 } }; --Ak'tar <Slateclaw Matria>
	[136304] = { zoneID = 864, artID = { 889 }, x = 6689, y = 2445, overlay = { "6680-2440" }, displayID = 81433, questID = { 51063 } }; --Songstress Nahjeen
	[136323] = { zoneID = 864, artID = { 889 }, x = 5361, y = 3467, overlay = { "5360-3480" }, displayID = 80487, questID = { 51065 } }; --Fangcaller Xorreth
	[136335] = { zoneID = 864, artID = { 889 }, x = 6198, y = 3784, overlay = { "6180-3740" }, displayID = 75589, questID = { 51077 } }; --Enraged Krolusk
	[136336] = { zoneID = 864, artID = { 889 }, x = 3270, y = 6509, overlay = { "3280-6500" }, displayID = 37539, questID = { 51076 } }; --Scorpox
	[136338] = { zoneID = 864, artID = { 889 }, x = 2457, y = 6845, overlay = { "2460-6840" }, displayID = 81654, questID = { 51075 } }; --Sirokar
	[136340] = { zoneID = 864, artID = { 889 }, x = 4899, y = 7216, overlay = { "4900-7200" }, displayID = 84744, questID = { 51126 } }; --Relic Hunter Hazaak
	[136341] = { zoneID = 864, artID = { 889 }, x = 6055, y = 1801, overlay = { "6040-1740" }, displayID = 1104, questID = { 51074 } }; --Jungleweb Hunter
	[136346] = { zoneID = 864, artID = { 889 }, x = 4155, y = 2384, overlay = { "4120-2420" }, displayID = 84741, questID = { 51073 } }; --Captain Stef Marrow Quin <The Tropic Temp>
	[136393] = { zoneID = 864, artID = { 889 }, x = 5591, y = 5364, overlay = { "5600-5340" }, displayID = 3248, questID = { 51079 } }; --Bloodwing Bonepicker
	[137553] = { zoneID = 864, artID = { 889 }, x = 6060, y = 6260, overlay = { "5820-5960","6060-6260" }, displayID = 85374, reset = true }; --General Krathax
	[137681] = { zoneID = 864, artID = { 889 }, x = 3827, y = 4140, overlay = { "3820-4120" }, displayID = 85438, questID = { 51424 } }; --King Clickyclack <King of the Tide Po>
	[138794] = { zoneID = 864, artID = { 889 }, x = 4460, y = 5620, overlay = { "4400-5540" }, displayID = 88375, weeklyReset = true, questID = { 53000 } }; --Dunegorger Kraulok
	[143313] = { zoneID = 864, artID = { 889 }, x = 6100, y = 1820, overlay = { "6100-1820" }, displayID = 83605, reset = true }; --Portakillo
	[146942] = { zoneID = 864, artID = { 889 }, x = 3960, y = 3760, overlay = { "3940-3740" }, friendly = { "A" }, displayID = 85310, questReset = true, questID = { 54646 } }; --Grand Marshal Fury
	[146979] = { zoneID = 864, artID = { 889 }, x = 3604, y = 4961, overlay = { "3580-4940" }, friendly = { "A" }, displayID = 89469, questReset = true, questID = { 54170 } }; --Ormin Rocketbop <Weapon Special>
	[148446] = { zoneID = 864, artID = { 889 }, x = 4060, y = 4960, overlay = { "4020-4840","4020-4960" }, friendly = { "H" }, displayID = 90022, questReset = true, questID = { 54554 } }; --Wolfleader Skraug
	[148451] = { zoneID = 864, artID = { 889 }, x = 3640, y = 3859, overlay = { "3640-3840" }, friendly = { "H" }, displayID = 84094, questReset = true, questID = { 54555 } }; --Siege O' Matic 9000
	[148456] = { zoneID = 864, artID = { 889 }, x = 3320, y = 7159, overlay = { "3320-7140" }, friendly = { "H" }, displayID = 90024, questReset = true, questID = { 54574 } }; --Jin'tago
	[148477] = { zoneID = 864, artID = { 889 }, x = 3480, y = 4240, overlay = { "3460-4260" }, friendly = { "H" }, displayID = 90032, questReset = true, questID = { 54609 } }; --Beastlord Drakara
	[148494] = { zoneID = 864, artID = { 889 }, x = 4080, y = 4120, overlay = { "4080-4120" }, friendly = { "H" }, displayID = 90039, questReset = true, questID = { 54636 } }; --Sandbinder Sodir
	[148510] = { zoneID = 864, artID = { 889 }, x = 3680, y = 6380, overlay = { "3600-6400","3680-6220" }, friendly = { "H" }, displayID = 90041, questReset = true, questID = { 54638 } }; --Drox'ar Morgar
	[148534] = { zoneID = 864, artID = { 889 }, x = 3914, y = 6730, overlay = { "3920-6720" }, friendly = { "A" }, displayID = 90044, questReset = true, questID = { 54643 } }; --Evezon the Eternal
	[148550] = { zoneID = 864, artID = { 889 }, x = 3980, y = 4060, overlay = { "3940-4000" }, friendly = { "A" }, displayID = 90018, questReset = true, questID = { 54644 } }; --Caravan Leader
	[148558] = { zoneID = 864, artID = { 889 }, x = 4299, y = 3842, overlay = { "4300-3840" }, friendly = { "A" }, displayID = 67251, questReset = true, questID = { 54645 } }; --Rockfury
	[148597] = { zoneID = 864, artID = { 889 }, x = 3829, y = 4149, overlay = { "3820-4140" }, friendly = { "A" }, displayID = 90078, questID = { 54649 } }; --Iron Shaman Grimbeard
	[122838] = { zoneID = 882, artID = { 907 }, x = 4454, y = 7164, overlay = { "4440-7160" }, displayID = 77107, questID = { 48692 } }; --Shadowcaster Voruun
	[124440] = { zoneID = 882, artID = { 907 }, x = 5959, y = 3760, overlay = { "5840-3740","5960-3760" }, displayID = 78505, questID = { 48714 } }; --Overseer Y'Beda
	[125497] = { zoneID = 882, artID = { 907 }, x = 5637, y = 2938, overlay = { "5600-2980","5640-2840","5680-3260","5700-2640","5740-2960","5740-3080","5760-2840" }, displayID = 78506, questID = { 48716 } }; --Overseer Y'Sorna
	[125498] = { zoneID = 882, artID = { 907 }, x = 6088, y = 2978, overlay = { "6040-2940" }, displayID = 78507, questID = { 48717 } }; --Overseer Y'Morna
	[126815] = { zoneID = 882, artID = { 907 }, x = 5308, y = 6737, overlay = { "5240-6860","5280-6640" }, displayID = 79114, questID = { 48693 } }; --Soultwisted Monstrosity
	[126852] = { zoneID = 882, artID = { 907 }, x = 5553, y = 6015, overlay = { "5440-5940","5540-6060","5560-5940" }, displayID = 79133, questID = { 48695 } }; --Wrangler Kravos
	[126860] = { zoneID = 882, artID = { 907 }, x = 3768, y = 5433, overlay = { "3740-5500" }, displayID = 79136, questID = { 48697 } }; --Kaara the Pale
	[126862] = { zoneID = 882, artID = { 907 }, x = 4383, y = 6064, overlay = { "4340-6060","4420-5940" }, displayID = 79137, questID = { 48700 } }; --Baruut the Bloodthirsty
	[126864] = { zoneID = 882, artID = { 907 }, x = 4114, y = 1149, overlay = { "4120-1180" }, displayID = 79139, questID = { 48702 } }; --Feasel the Muffin Thief
	[126865] = { zoneID = 882, artID = { 907 }, x = 3660, y = 2360, overlay = { "3640-2340" }, displayID = 79927, questID = { 48703 } }; --Vigilant Thanos
	[126866] = { zoneID = 882, artID = { 907 }, x = 6386, y = 6435, overlay = { "6340-6420" }, displayID = 79928, questID = { 48704 } }; --Vigilant Kuro
	[126867] = { zoneID = 882, artID = { 907 }, x = 3364, y = 4806, overlay = { "3340-4820" }, displayID = 75569, questID = { 48705 } }; --Venomtail Skyfin
	[126868] = { zoneID = 882, artID = { 907 }, x = 3784, y = 6409, overlay = { "3820-6440" }, displayID = 79143, questID = { 48706 } }; --Turek the Lucid
	[126869] = { zoneID = 882, artID = { 907 }, x = 2717, y = 3001, overlay = { "2720-3040" }, displayID = 76899, questID = { 48707 } }; --Captain Faruq
	[126885] = { zoneID = 882, artID = { 907 }, x = 3480, y = 3760, overlay = { "3400-3780","3480-3640" }, displayID = 76479, questID = { 48708 } }; --Umbraliss <Voidstalker Matria>
	[126887] = { zoneID = 882, artID = { 907 }, x = 3011, y = 4020, overlay = { "2940-4100","3060-3980","3060-4160" }, displayID = 76477, questID = { 48709 } }; --Ataxon
	[126889] = { zoneID = 882, artID = { 907 }, x = 7019, y = 4600, overlay = { "7020-4600" }, displayID = 79150, questID = { 48710 } }; --Sorolis the Ill-Fated
	[126896] = { zoneID = 882, artID = { 907 }, x = 3595, y = 5897, overlay = { "3540-5840" }, displayID = 79060, questID = { 48711 } }; --Herald of Chaos
	[126898] = { zoneID = 882, artID = { 907 }, x = 4520, y = 4900, overlay = { "4300-4740","4340-4860","4400-5080" }, displayID = 79156, questID = { 48712 } }; --Sabuul
	[126899] = { zoneID = 882, artID = { 907 }, x = 4880, y = 4179, overlay = { "4820-4040","4840-4160" }, displayID = 79157, questID = { 48713 } }; --Jed'hin Champion Vorusk
	[126900] = { zoneID = 882, artID = { 907 }, x = 6220, y = 4920, overlay = { "6140-5040","6220-4920" }, displayID = 79160, questID = { 48718 } }; --Instructor Tarahna
	[126908] = { zoneID = 882, artID = { 907 }, x = 6660, y = 2860, overlay = { "6640-2840" }, displayID = 77098, questID = { 48719 } }; --Zul'tan the Numerous
	[126910] = { zoneID = 882, artID = { 907 }, x = 5680, y = 1560, overlay = { "5560-1380","5640-1480" }, displayID = 78364, questID = { 48720 } }; --Commander Xethgar
	[126912] = { zoneID = 882, artID = { 907 }, x = 4910, y = 0981, overlay = { "4860-1160","4940-0980","5060-0980" }, displayID = 76684, questID = { 48721 } }; --Skreeg the Devourer
	[126913] = { zoneID = 882, artID = { 907 }, x = 4887, y = 5235, overlay = { "4840-5240","4840-5420" }, displayID = 63407, questID = { 48935 } }; --Slithon the Last
	[122947] = { zoneID = 885, artID = { 910 }, x = 5735, y = 3355, overlay = { "5740-3340" }, displayID = 80099, questID = { 49240 } }; --Mistress Il'thendra
	[122958] = { zoneID = 885, artID = { 910 }, x = 6182, y = 3690, overlay = { "6140-3780" }, displayID = 78588, questID = { 49183 } }; --Blistermaw
	[122999] = { zoneID = 885, artID = { 910 }, x = 5570, y = 4593, overlay = { "5480-4660","5520-4500","5620-4660" }, displayID = 20907, questID = { 49241 } }; --Gar'zoth
	[126040] = { zoneID = 885, artID = { 910 }, x = 6400, y = 2079, overlay = { "6400-2080" }, displayID = 66039, questID = { 48809 } }; --Puscilla
	[126115] = { zoneID = 885, artID = { 910 }, x = 6302, y = 5735, overlay = { "6320-5720" }, displayID = 71834, questID = { 48811 } }; --Ven'orn
	[126199] = { zoneID = 885, artID = { 910 }, x = 5303, y = 3602, overlay = { "5300-3540","5300-3660" }, displayID = 78785, questID = { 48810 } }; --Vrax'thul
	[126208] = { zoneID = 885, artID = { 910 }, x = 6500, y = 5160, overlay = { "6440-4940","6500-5120" }, displayID = 78793, questID = { 48812 } }; --Varga
	[126254] = { zoneID = 885, artID = { 910 }, x = 6260, y = 5440, overlay = { "6220-5340" }, displayID = 78814, questID = { 48813 } }; --Lieutenant Xakaar <Hand of Svi>
	[126338] = { zoneID = 885, artID = { 910 }, x = 6132, y = 6521, overlay = { "6120-6560","6140-6440" }, displayID = 78873, questID = { 48814 } }; --Wrath-Lord Yarez
	[126946] = { zoneID = 885, artID = { 910 }, x = 6063, y = 4839, overlay = { "6040-4800" }, displayID = 78785, questID = { 48815 } }; --Inquisitor Vethroz
	[127084] = { zoneID = 885, artID = { 910 }, x = 8267, y = 6557, overlay = { "8240-6580" }, displayID = 71253, questID = { 48816 } }; --Commander Texlaz
	[127090] = { zoneID = 885, artID = { 910 }, x = 7360, y = 7180, overlay = { "7340-7140" }, displayID = 76275, questID = { 48817 } }; --Admiral Rel'var
	[127096] = { zoneID = 885, artID = { 910 }, x = 7613, y = 5612, overlay = { "7540-5660" }, displayID = 64719, questID = { 48818 } }; --All-Seer Xanarian
	[127118] = { zoneID = 885, artID = { 910 }, x = 5778, y = 5071, overlay = { "5040-5560","5140-5440","5180-5320","5400-5500","5778-5071" }, displayID = 79261, questID = { 48820 } }; --Worldsplitter Skuul
	[127288] = { zoneID = 885, artID = { 910 }, x = 6380, y = 2200, overlay = { "6340-2300" }, displayID = 71965, questID = { 48821 } }; --Houndmaster Kerrax
	[127291] = { zoneID = 885, artID = { 910 }, x = 5296, y = 2936, overlay = { "5300-2900" }, displayID = 74729, questID = { 48822 } }; --Watcher Aival
	[127300] = { zoneID = 885, artID = { 910 }, x = 5526, y = 2155, overlay = { "5540-2180" }, displayID = 78507, questID = { 48824 } }; --Void Warden Valsuran
	[127376] = { zoneID = 885, artID = { 910 }, x = 6140, y = 2086, overlay = { "6120-2120" }, displayID = 64632, questID = { 48865 } }; --Chief Alchemist Munculus
	[127581] = { zoneID = 885, artID = { 910 }, x = 5501, y = 3891, overlay = { "5480-3900" }, displayID = 78135, questID = { 48966 } }; --The Many-Faced Devourer
	[127700] = { zoneID = 885, artID = { 910 }, x = 8459, y = 8100, overlay = { "8440-8100" }, displayID = 78814, questID = { 48967 } }; --Squadron Commander Vishax
	[127703] = { zoneID = 885, artID = { 910 }, x = 5859, y = 1160, overlay = { "5740-1220","5840-1140" }, displayID = 68312, questID = { 48968 } }; --Doomcaster Suprax
	[127705] = { zoneID = 885, artID = { 910 }, x = 6660, y = 1779, overlay = { "6660-1780" }, displayID = 65648, questID = { 48970 } }; --Mother Rosula
	[127706] = { zoneID = 885, artID = { 910 }, x = 6540, y = 8140, overlay = { "6500-8240" }, displayID = 74729, questID = { 48971 } }; --Rezira the Seer
	[127289] = { zoneID = 895, artID = { 920 }, x = 5865, y = 1480, overlay = { "5820-1480" }, displayID = 6533, questID = { 48806 } }; --Saurolisk Tamer Mugg
	[127290] = { zoneID = 895, artID = { 920 }, x = 5865, y = 1480, overlay = { "5840-1480" }, displayID = 81866, questID = { 48806 } }; --Mugg
	[129181] = { zoneID = 895, artID = { 920 }, x = 7609, y = 8287, overlay = { "7600-8360" }, displayID = 80425, questID = { 50233 } }; --Barman Bill
	[130508] = { zoneID = 895, artID = { 920 }, x = 8354, y = 4482, overlay = { "8320-4440" }, displayID = 81342, questID = { 49999 } }; --Broodmother Razora
	[131252] = { zoneID = 895, artID = { 920 }, x = 4304, y = 1675, overlay = { "4320-1680" }, displayID = 82052, questID = { 49921 } }; --Merianae
	[131262] = { zoneID = 895, artID = { 920 }, x = 3889, y = 1530, overlay = { "3900-1520" }, displayID = 68526, questID = { 49923 } }; --Pack Leader Asenya
	[131389] = { zoneID = 895, artID = { 920 }, x = 6365, y = 5036, overlay = { "6380-5040" }, displayID = 81799, questID = { 49942 } }; --Teres
	[131520] = { zoneID = 895, artID = { 920 }, x = 4790, y = 2263, overlay = { "4800-2220" }, displayID = 47803, questID = { 49984 } }; --Kulett the Ornery
	[131984] = { zoneID = 895, artID = { 920 }, x = 7034, y = 1248, overlay = { "7020-1260" }, displayID = 82226, questID = { 50073 } }; --Twin-hearted Construct
	[132052] = { zoneID = 895, artID = { 920 }, x = 6540, y = 1260, overlay = { "5100-3200","5480-2620","6540-1260" }, friendly = { "H" }, displayID = 82194 }; --Vol'Jim <Troll Unda da Bri>
	[132068] = { zoneID = 895, artID = { 920 }, x = 3450, y = 3035, overlay = { "3420-3060" }, displayID = 55832, questID = { 50094 } }; --Bashmu
	[132076] = { zoneID = 895, artID = { 920 }, x = 4685, y = 2064, overlay = { "4685-2064" }, displayID = 82225, questID = { 50095 } }; --Totes
	[132086] = { zoneID = 895, artID = { 920 }, x = 5618, y = 6995, overlay = { "5640-7000" }, displayID = 82224, questID = { 50096 } }; --Black-Eyed Bart <Scourge of the Great>
	[132088] = { zoneID = 895, artID = { 920 }, x = 3861, y = 2144, overlay = { "3840-2080" }, displayID = 82223, questID = { 50097 } }; --Captain Wintersail
	[132127] = { zoneID = 895, artID = { 920 }, x = 6010, y = 2219, overlay = { "6000-2260" }, displayID = 82239, questID = { 50137 } }; --Foxhollow Skyterror
	[132179] = { zoneID = 895, artID = { 920 }, x = 6477, y = 5861, overlay = { "6440-5840" }, displayID = 83949, questID = { 50148 } }; --Raging Swell
	[132182] = { zoneID = 895, artID = { 920 }, x = 7491, y = 7894, overlay = { "7500-7880" }, friendly = { "A" }, displayID = 82274, questID = { 50156 } }; --Auditor Dolp <Irontide Raid>
	[132211] = { zoneID = 895, artID = { 920 }, x = 9070, y = 7723, overlay = { "9020-7720" }, displayID = 82292, questID = { 50155 } }; --Fowlmouth <The Last of His C>
	[132280] = { zoneID = 895, artID = { 920 }, x = 8091, y = 8283, overlay = { "8080-8240" }, displayID = 82370, questID = { 50160 } }; --Squacks
	[133356] = { zoneID = 895, artID = { 920 }, x = 6092, y = 1701, overlay = { "6060-1740" }, displayID = 82869, questID = { 50301 } }; --Tempestria
	[134106] = { zoneID = 895, artID = { 920 }, x = 6833, y = 2001, overlay = { "6740-1960","6860-2020" }, displayID = 79804, questID = { 50525 } }; --Lumbergrasp Sentinel
	[136385] = { zoneID = 895, artID = { 920 }, x = 6200, y = 2400, overlay = { "6140-2440" }, displayID = 58717, weeklyReset = true, questID = { 52997 } }; --Azurethos
	[137183] = { zoneID = 895, artID = { 920 }, x = 6419, y = 1939, overlay = { "6420-1940" }, displayID = 78242, questID = { 51321 } }; --Honey-Coated Slitherer
	[138279] = { zoneID = 895, artID = { 920 }, x = 8554, y = 4339, overlay = { "8540-4340" }, displayID = 85796, questID = { 54953 } }; --Adhara White <Tol Dagor Esca>
	[138288] = { zoneID = 895, artID = { 920 }, x = 6999, y = 4718, overlay = { "6940-4700" }, displayID = 75598, reset = true }; --Ghost of the Deep
	[138299] = { zoneID = 895, artID = { 920 }, x = 5880, y = 3300, overlay = { "5880-3320" }, displayID = 55454 }; --Bloodmaw
	[139135] = { zoneID = 895, artID = { 920 }, x = 4888, y = 3701, overlay = { "4880-3700" }, displayID = 75808, questID = { 51807 } }; --Squirgle of the Depths
	[139145] = { zoneID = 895, artID = { 920 }, x = 8525, y = 7343, overlay = { "8520-7340" }, displayID = 66132, questID = { 51808 } }; --Blackthorne
	[139152] = { zoneID = 895, artID = { 920 }, x = 7243, y = 8100, overlay = { "7240-8100" }, friendly = { "A" }, displayID = 86170, questID = { 51809 } }; --Carla Smirk <Pirate Instruc>
	[139205] = { zoneID = 895, artID = { 920 }, x = 6523, y = 6452, overlay = { "6520-6440" }, displayID = 74804, questID = { 51833 } }; --P4-N73R4
	[139233] = { zoneID = 895, artID = { 920 }, x = 5784, y = 5590, overlay = { "5740-5600" }, displayID = 78151, questID = { 53373 } }; --Gulliver
	[139235] = { zoneID = 895, artID = { 920 }, x = 7041, y = 5574, overlay = { "7040-5540" }, displayID = 42658, questID = { 51835 } }; --Tort Jaw
	[139278] = { zoneID = 895, artID = { 920 }, x = 6830, y = 6356, overlay = { "6820-6340" }, displayID = 913, questID = { 51872 } }; --Ranja <The Last Chill>
	[139280] = { zoneID = 895, artID = { 920 }, x = 6673, y = 1318, overlay = { "6620-1400" }, displayID = 45092, questID = { 51873 } }; --Sythian the Swift
	[139285] = { zoneID = 895, artID = { 920 }, x = 5512, y = 3240, overlay = { "5500-3240" }, displayID = 78240, questID = { 51876 } }; --Shiverscale the Toxic
	[139289] = { zoneID = 895, artID = { 920 }, x = 5531, y = 5153, overlay = { "5520-5140" }, displayID = 63970, questID = { 51879 } }; --Tentulos the Drifter
	[139290] = { zoneID = 895, artID = { 920 }, x = 5851, y = 4946, overlay = { "5820-5020","5860-4900" }, displayID = 75380, questID = { 51880 } }; --Maison the Portable
	[144722] = { zoneID = 895, artID = { 920 }, x = 7920, y = 3780, overlay = { "7920-3740" }, friendly = { "H" }, displayID = 88804, questReset = true, questID = { 54237 } }; --Togoth Cruelarm <Unit Comman>
	[145112] = { zoneID = 895, artID = { 920 }, x = 7660, y = 4300, overlay = { "7640-4280" }, friendly = { "H" }, displayID = 88964, questReset = true, questID = { 53772 } }; --Zagg Brokeneye
	[145286] = { zoneID = 895, artID = { 920 }, x = 7700, y = 4159, overlay = { "7700-4120" }, friendly = { "H" }, displayID = 89030, questReset = true, questID = { 53812 } }; --Motega Bloodshield
	[145287] = { zoneID = 895, artID = { 920 }, x = 7719, y = 4120, overlay = { "7700-4160" }, friendly = { "H" }, displayID = 89031, questReset = true, questID = { 53812 } }; --Zunjo of Sen'jin
	[145292] = { zoneID = 895, artID = { 920 }, x = 7719, y = 4120, overlay = { "7720-4120" }, friendly = { "H" }, displayID = 89032, questReset = true, questID = { 53812 } }; --Alsian Vistreth
	[145308] = { zoneID = 895, artID = { 920 }, x = 8600, y = 4260, overlay = { "8540-4340" }, friendly = { "H" }, displayID = 89043, questReset = true, questID = { 53814 } }; --First Sergeant Steelfang
	[145392] = { zoneID = 895, artID = { 920 }, x = 7886, y = 4233, overlay = { "7920-4220" }, friendly = { "A" }, displayID = 89064, questReset = true, questID = { 54251 } }; --Ambassador Gaines
	[145395] = { zoneID = 895, artID = { 920 }, x = 7885, y = 4232, overlay = { "7920-4220" }, friendly = { "A" }, displayID = 89065, questReset = true, questID = { 54251 } }; --Katrianna <Ambassador Gaines' Guard>
	[146611] = { zoneID = 895, artID = { 920 }, x = 7798, y = 4915, overlay = { "7800-4920" }, friendly = { "A" }, displayID = 89365, questReset = true, questID = { 54091 } }; --Strong Arm John
	[146651] = { zoneID = 895, artID = { 920 }, x = 7448, y = 4494, overlay = { "7440-4480" }, friendly = { "A" }, displayID = 43848, questReset = true, questID = { 54112 } }; --Mistweaver Nian
	[146675] = { zoneID = 895, artID = { 920 }, x = 8028, y = 3685, overlay = { "8020-3700" }, friendly = { "A" }, displayID = 89389, questReset = true, questID = { 54119 } }; --Hartford Sternbach
	[146773] = { zoneID = 895, artID = { 920 }, x = 8459, y = 4759, overlay = { "8440-4740" }, friendly = { "H" }, displayID = 89426, questReset = true, questID = { 54129 } }; --First Mate Malone <The Fogsail Freeboot>
	[147061] = { zoneID = 895, artID = { 920 }, x = 8419, y = 3520, overlay = { "8420-3520" }, friendly = { "H" }, displayID = 30262, questReset = true, questID = { 54182 } }; --Grubb <Bilgewater Bash Broth>
	[147489] = { zoneID = {
				[895] = { x = 7600, y = 3960, artID = { 920 }, overlay = { "7600-3940" } };
				[1161] = { x = 7719, y = 8060, artID = { 1138 }, overlay = { "7720-8060" } };
			  }, friendly = { "A" }, displayID = 89713, questReset = true, questID = { 54257 } }; --Captain Greensails
	[147750] = { zoneID = 895, artID = { 920 }, x = 8319, y = 4050, overlay = { "8300-4040" }, friendly = { "A" }, displayID = 89780, questReset = true, questID = { 54295 } }; --Artillery Master Goodwin
	[124548] = { zoneID = 896, artID = { 921 }, x = 5846, y = 3317, overlay = { "5840-3340" }, displayID = 81256, questID = { 47884 } }; --Betsy <Shelvey's Prized>
	[125453] = { zoneID = 896, artID = { 921 }, x = 6657, y = 4273, overlay = { "6640-4240" }, displayID = 43647, questID = { 48178 } }; --Quillrat Matriarch
	[126621] = { zoneID = 896, artID = { 921 }, x = 6669, y = 5097, overlay = { "6640-5080" }, displayID = 80957, questID = { 48978 } }; --Bonesquall
	[127129] = { zoneID = 896, artID = { 921 }, x = 5034, y = 2063, overlay = { "5040-2040" }, displayID = 77268, questID = { 49388 } }; --Grozgore
	[127333] = { zoneID = 896, artID = { 921 }, x = 5910, y = 1676, overlay = { "5900-1700" }, displayID = 85629, questID = { 48842 } }; --Barbthorn Queen
	[127651] = { zoneID = 896, artID = { 921 }, x = 7280, y = 6060, overlay = { "7280-6040" }, displayID = 21936, questID = { 48928 } }; --Vicemaul
	[127844] = { zoneID = 896, artID = { 921 }, x = 6310, y = 6973, overlay = { "6300-6940" }, displayID = 13990, questID = { 48979 } }; --Gluttonous Yeti
	[127877] = { zoneID = 896, artID = { 921 }, x = 5924, y = 5525, overlay = { "5940-5520" }, displayID = 79676, questID = { 48981 } }; --Longfang
	[127901] = { zoneID = 896, artID = { 921 }, x = 5935, y = 5540, overlay = { "5940-5520" }, displayID = 79282, questID = { 48981 } }; --Henry Breakwater
	[128707] = { zoneID = 896, artID = { 921 }, x = 5961, y = 7183, overlay = { "5960-7140" }, displayID = 74168, questID = { 49269 } }; --Rimestone
	[128973] = { zoneID = 896, artID = { 921 }, x = 6496, y = 2143, overlay = { "6480-2140" }, displayID = 24932, questID = { 49311 } }; --Whargarble the Ill-Tempered <Harbor Patria>
	[129805] = { zoneID = 896, artID = { 921 }, x = 5054, y = 3006, overlay = { "5040-3000" }, displayID = 37738, questID = { 49481 } }; --Beshol
	[129835] = { zoneID = 896, artID = { 921 }, x = 5711, y = 4431, overlay = { "5700-4420" }, displayID = 80884, questID = { 49480 } }; --Gorehorn <Trophy B>
	[129904] = { zoneID = 896, artID = { 921 }, x = 5200, y = 4680, overlay = { "5200-4680" }, displayID = 80909, questID = { 49216 } }; --Cottontail Matron
	[129950] = { zoneID = 896, artID = { 921 }, x = 3193, y = 4062, overlay = { "3180-4100" }, displayID = 81102, questID = { 49528 } }; --Talon
	[129995] = { zoneID = 896, artID = { 921 }, x = 6340, y = 4009, overlay = { "6340-4020" }, displayID = 80936, questID = { 49530 } }; --Emily Mayville
	[130138] = { zoneID = 896, artID = { 921 }, x = 5994, y = 4548, overlay = { "6000-4540" }, displayID = 80965, questID = { 49601 } }; --Nevermore
	[130143] = { zoneID = 896, artID = { 921 }, x = 5866, y = 2989, overlay = { "5580-2920","5740-2980","5880-2980","5940-2820" }, displayID = 81005, questID = { 49602 } }; --Balethorn
	[131735] = { zoneID = 896, artID = { 921 }, x = 6500, y = 8319, overlay = { "6500-8320" }, displayID = 82027, questID = { 52061 } }; --Idej the Wise
	[132319] = { zoneID = 896, artID = { 921 }, x = 3505, y = 3325, overlay = { "3520-3300" }, displayID = 34168, questID = { 50163 } }; --Bilefang Mother
	[134213] = { zoneID = 896, artID = { 921 }, x = 3088, y = 1839, overlay = { "3080-1840" }, displayID = 83387, questID = { 50546 } }; --Executioner Blackwell
	[134706] = { zoneID = 896, artID = { 921 }, x = 1871, y = 6138, overlay = { "1860-6040" }, displayID = 83607, questID = { 50669 } }; --Deathcap
	[134754] = { zoneID = 896, artID = { 921 }, x = 2293, y = 4948, overlay = { "2300-4920" }, displayID = 87598, questID = { 50688 } }; --Hyo'gi
	[135796] = { zoneID = 896, artID = { 921 }, x = 2727, y = 1422, overlay = { "2660-1460","2800-1420" }, displayID = 84410, questID = { 50939 } }; --Captain Leadfist <Irontide Raid>
	[137529] = { zoneID = 896, artID = { 921 }, x = 3479, y = 6924, overlay = { "3500-6900" }, displayID = 85351, questID = { 51383 } }; --Arvon the Betrayed <The Crimson Cutthro>
	[137665] = { zoneID = 896, artID = { 921 }, x = 2718, y = 5488, overlay = { "2640-5440" }, displayID = 79366, questID = { 52002 } }; --Soul Goliath
	[137704] = { zoneID = 896, artID = { 921 }, x = 3484, y = 1986, overlay = { "3480-2000" }, displayID = 84208, questID = { 52000 } }; --Matron Morana
	[137708] = { zoneID = 896, artID = { 921 }, x = 4976, y = 4379, overlay = { "4980-4360" }, displayID = 86197, questID = { 51999 } }; --Stone Golem
	[137824] = { zoneID = 896, artID = { 921 }, x = 2922, y = 6902, overlay = { "2920-6880" }, displayID = 85538, questID = { 51470 } }; --Arclight
	[137825] = { zoneID = 896, artID = { 921 }, x = 4449, y = 8758, overlay = { "4380-8820","4440-8540","4460-8680" }, displayID = 85539, questID = { 51471 } }; --Avalanche
	[138618] = { zoneID = 896, artID = { 921 }, x = 2432, y = 3001, overlay = { "2340-3040" }, displayID = 84422, questID = { 51698 } }; --Haywire Golem
	[138667] = { zoneID = 896, artID = { 921 }, x = 3588, y = 1163, overlay = { "3580-1120" }, displayID = 86207, questID = { 52001 } }; --Blighted Monstrosity
	[138675] = { zoneID = 896, artID = { 921 }, x = 2799, y = 2595, overlay = { "2780-2540" }, displayID = 55858, questID = { 51700 } }; --Gorged Boar
	[138863] = { zoneID = 896, artID = { 921 }, x = 3298, y = 5711, overlay = { "3300-5700" }, displayID = 85383, questID = { 51748 } }; --Sister Martha
	[138866] = { zoneID = 896, artID = { 921 }, x = 2446, y = 2195, overlay = { "2440-2200" }, displayID = 83611, questID = { 51749 } }; --Mack
	[138870] = { zoneID = 896, artID = { 921 }, x = 2440, y = 2200, overlay = { "2440-2200" }, displayID = 83618, questID = { 51749 } }; --Mick
	[138871] = { zoneID = 896, artID = { 921 }, x = 2420, y = 2180, overlay = { "2440-2200" }, displayID = 83594, questID = { 51749 } }; --Ernie
	[139321] = { zoneID = 896, artID = { 921 }, x = 2763, y = 5958, overlay = { "2740-5960" }, displayID = 85390, questID = { 51922 } }; --Braedan Whitewall
	[139322] = { zoneID = 896, artID = { 921 }, x = 2950, y = 6410, overlay = { "2940-6400" }, displayID = 86221, questID = { 51923 } }; --Whitney Steelclaw Ramsay
	[139358] = { zoneID = 896, artID = { 921 }, x = 2515, y = 1624, overlay = { "2520-1600" }, displayID = 85614, questID = { 51949 } }; --The Caterer
	[140252] = { zoneID = 896, artID = { 921 }, x = 4979, y = 7301, overlay = { "4920-7420","4979-7301" }, displayID = 80964, weeklyReset = true }; --Hailstone Construct
	[144855] = { zoneID = 896, artID = { 921 }, x = 3520, y = 4159, overlay = { "3500-4140" }, friendly = { "H" }, displayID = 88880, questReset = true, questID = { 53714 } }; --Apothecary Jerrod <Royal Apothecary Soci>
	[145465] = { zoneID = 896, artID = { 921 }, x = 2860, y = 4320, overlay = { "2740-4340","2860-4320" }, friendly = { "H" }, displayID = 89084, questReset = true, questID = { 53867 } }; --Engineer Bolthold
	[145466] = { zoneID = 896, artID = { 921 }, x = 2860, y = 4340, overlay = { "2740-4340","2860-4340" }, friendly = { "H" }, displayID = 58115 }; --Shredatron-2000
	[146607] = { zoneID = 896, artID = { 921 }, x = 3180, y = 3300, overlay = { "3180-3300" }, friendly = { "H" }, displayID = 89363, questReset = true, questID = { 54089 } }; --Omgar Doombow
	[148146] = { zoneID = 896, artID = { 921 }, x = 3100, y = 3600, overlay = { "3080-3540","3080-3700" }, friendly = { "H" }, displayID = 89895, questReset = true, questID = { 54488 } }; --Zul'aki the Headhunter
	[148155] = { zoneID = 896, artID = { 921 }, x = 3360, y = 3780, overlay = { "3340-3720" }, friendly = { "H" }, displayID = 79522, questReset = true, questID = { 54650 } }; --Muk'luk
	[148563] = { zoneID = 896, artID = { 921 }, x = 4020, y = 5060, overlay = { "4020-5040" }, friendly = { "H" }, displayID = 90076, questReset = true, questID = { 54665 } }; --Duchess Fallensong the Frigid
	[148648] = { zoneID = 896, artID = { 921 }, x = 4400, y = 3800, overlay = { "4340-3920","4400-3800" }, friendly = { "H" }, displayID = 90097, questReset = true, questID = { 54666 } }; --Packmaster Swiftarrow
	[148676] = { zoneID = 896, artID = { 921 }, x = 3214, y = 4671, overlay = { "3200-4640" }, friendly = { "A" }, displayID = 90102, questReset = true, questID = { 54681 } }; --Caravan Commander Veronica
	[148695] = { zoneID = 896, artID = { 921 }, x = 3167, y = 4160, overlay = { "3140-4140" }, friendly = { "A" }, displayID = 90108, questReset = true, questID = { 54686 } }; --Doctor Lazane <Field Surg>
	[148717] = { zoneID = 896, artID = { 921 }, x = 2757, y = 3367, overlay = { "2780-3340" }, friendly = { "A" }, displayID = 90110, questReset = true, questID = { 54688 } }; --Inquisitor Erik <Order of Emb>
	[148723] = { zoneID = 896, artID = { 921 }, x = 3480, y = 3300, overlay = { "3480-3300" }, friendly = { "A" }, displayID = 90111, questReset = true, questID = { 54690 } }; --Maddok the Sniper
	[148739] = { zoneID = 896, artID = { 921 }, x = 3948, y = 3265, overlay = { "3940-3240" }, friendly = { "A" }, displayID = 90114, questReset = true, questID = { 54692 } }; --Magister Crystalynn
	[148860] = { zoneID = 896, artID = { 921 }, x = 4003, y = 3975, overlay = { "3920-4180","3940-4000" }, friendly = { "A" }, displayID = 73603, questReset = true, questID = { 54711 } }; --Grizzwald
	[148862] = { zoneID = 896, artID = { 921 }, x = 3951, y = 3956, overlay = { "3880-4200","3920-4060","3940-3940" }, friendly = { "A" }, displayID = 90144, questReset = true, questID = { 54711 } }; --Zillie Wunderwrench
	[122519] = { zoneID = 897, artID = { 922 }, x = 5280, y = 4800, overlay = { "5140-4420","5200-5080","5240-4560","5240-4780","5240-4920" }, displayID = 24855 }; --Dregmar Runebrand
	[122520] = { zoneID = 897, artID = { 922 }, x = 4360, y = 3460, overlay = { "4340-2940","4340-3080","4340-3280","4360-3460" }, displayID = 24850 }; --Icefist
	[122521] = { zoneID = 897, artID = { 922 }, x = 5740, y = 5660, overlay = { "5700-5420","5720-5220","5720-5580" }, displayID = 24854 }; --Bonesunder
	[122522] = { zoneID = 897, artID = { 922 }, x = 6240, y = 6740, overlay = { "6040-7040","6140-6940","6220-6800" }, displayID = 24850 }; --Iceshatter
	[122524] = { zoneID = 897, artID = { 922 }, x = 5859, y = 6480, overlay = { "5520-6120","5680-6120","5840-6220","5840-6440" }, displayID = 24854 }; --Bloodfeast
	[122456] = { zoneID = 903, artID = { 928 }, x = 2918, y = 3133, displayID = 35903 }; --Voidmaw
	[122457] = { zoneID = 903, artID = { 928 }, x = 3781, y = 7343, displayID = 76915 }; --Darkcaller
	[127882] = { zoneID = 903, artID = { 928 }, x = 3788, y = 4289, displayID = 79724 }; --Vixx the Collector
	[127906] = { zoneID = 903, artID = { 928 }, x = 5527, y = 1453, displayID = 77198 }; --Twilight-Harbinger Tharuul
	[127911] = { zoneID = 903, artID = { 928 }, x = 4209, y = 3548, displayID = 77624 }; --Void-Blade Zedaat
	[129803] = { zoneID = 942, artID = { 967 }, x = 4736, y = 6583, overlay = { "4720-6540" }, displayID = 81164, questID = { 52296 } }; --Whiplash
	[129836] = { zoneID = 942, artID = { 967 }, x = 5520, y = 6160, overlay = { "5520-6140" }, displayID = 85413, reset = true }; --Spelltwister Moephus
	[130079] = { zoneID = {
				[942] = { x = 4202, y = 7476, overlay = { "4202-7476" } };
				[1183] = { x = 4241, y = 7507, artID = { 1156 }, overlay = { "4241-7507" } };
			  }, displayID = 88565, questID = { 50819 } }; --Wagga Snarltusk <Briarback Mys>
	[130897] = { zoneID = 942, artID = { 967 }, x = 4727, y = 6591, overlay = { "4720-6540" }, displayID = 81688, questID = { 50170 } }; --Captain Razorspine
	[131404] = { zoneID = 942, artID = { 967 }, x = 6443, y = 6591, overlay = { "6420-6540" }, displayID = 81809, questID = { 49951 } }; --Foreman Scripps
	[132007] = { zoneID = 942, artID = { 967 }, x = 7144, y = 5435, overlay = { "7140-5420" }, displayID = 33826, questID = { 50075 } }; --Galestorm
	[132047] = { zoneID = 942, artID = { 967 }, x = 6901, y = 5201, overlay = { "6900-5140","6900-5260" }, displayID = 84924 }; --Reinforced Hullbreaker
	[134147] = { zoneID = 942, artID = { 967 }, x = 6648, y = 7479, overlay = { "6620-7440" }, displayID = 83359 }; --Beehemoth
	[134884] = { zoneID = 942, artID = { 967 }, x = 4164, y = 7435, overlay = { "4120-7320","4140-7460" }, displayID = 8550, questID = { 50725 } }; --Ragna
	[134897] = { zoneID = 942, artID = { 967 }, x = 6785, y = 3983, overlay = { "6740-4040" }, displayID = 36700, questID = { 50731 } }; --Dagrus the Scorned
	[135939] = { zoneID = 942, artID = { 967 }, x = 4961, y = 6806, overlay = { "4980-6820" }, displayID = 88563, questID = { 50037 } }; --Vinespeaker Ratha
	[136183] = { zoneID = 942, artID = { 967 }, x = 5125, y = 5552, overlay = { "5140-5540" }, displayID = 83864, questID = { 52466 } }; --Crushtacean
	[136189] = { zoneID = 942, artID = { 967 }, x = 5178, y = 7978, overlay = { "5180-7940" }, displayID = 83603, questID = { 50974 } }; --The Lichen King
	[137025] = { zoneID = 942, artID = { 967 }, x = 2946, y = 6961, overlay = { "2920-6940" }, displayID = 85021, questID = { 51298 } }; --Broodmother
	[137649] = { zoneID = 942, artID = { 967 }, x = 3636, y = 3763, overlay = { "3600-3700","3840-3720" }, displayID = 85878, questID = { 53612 } }; --Pest Remover Mk. II
	[138938] = { zoneID = 942, artID = { 967 }, x = 3376, y = 3841, overlay = { "3320-3740","3400-3860" }, displayID = 66812, questID = { 51757 } }; --Seabreaker Skoloth
	[138963] = { zoneID = 942, artID = { 967 }, x = 4320, y = 4500, overlay = { "4340-4500" }, friendly = { "A" }, displayID = 507, questID = { 51762 } }; --Nestmother Acada
	[139298] = { zoneID = 942, artID = { 967 }, x = 3826, y = 5113, overlay = { "3820-5100" }, displayID = 86218, questID = { 51959 } }; --Pinku'shon
	[139319] = { zoneID = 942, artID = { 967 }, x = 4183, y = 2842, overlay = { "4160-2860" }, displayID = 86220, questID = { 51958 } }; --Slickspill
	[139328] = { zoneID = 942, artID = { 967 }, x = 3420, y = 3240, overlay = { "3400-3200" }, displayID = 86224, questID = { 51956 } }; --Sabertron
	[139335] = { zoneID = 942, artID = { 967 }, x = 3460, y = 3240, overlay = { "3400-3200" }, displayID = 86225 }; --Sabertron
	[139336] = { zoneID = 942, artID = { 967 }, x = 3420, y = 3200, overlay = { "3420-3200" }, displayID = 86226 }; --Sabertron
	[139356] = { zoneID = 942, artID = { 967 }, x = 3420, y = 3200, overlay = { "3420-3200" }, displayID = 86227 }; --Sabertron
	[139359] = { zoneID = 942, artID = { 967 }, x = 3400, y = 3200, overlay = { "3400-3200" }, displayID = 86228 }; --Sabertron
	[139385] = { zoneID = 942, artID = { 967 }, x = 5302, y = 5101, overlay = { "5280-5140" }, displayID = 71540, questID = { 50692 } }; --Deepfang
	[139968] = { zoneID = 942, artID = { 967 }, x = 6614, y = 5172, overlay = { "6600-5160","6680-5040","6700-4900","6840-4820" }, displayID = 85042, questID = { 52121 } }; --Corrupted Tideskipper
	[139980] = { zoneID = 942, artID = { 967 }, x = 5996, y = 4585, overlay = { "6000-4600" }, displayID = 83643, questID = { 52123 } }; --Taja the Tidehowler
	[139988] = { zoneID = 942, artID = { 967 }, x = 7351, y = 6064, overlay = { "7340-6040" }, displayID = 78242, questID = { 52125 } }; --Sandfang
	[140163] = { zoneID = 942, artID = { 967 }, x = 8319, y = 4960, overlay = { "8300-4920" }, displayID = 84332, weeklyReset = true }; --Warbringer Yenajz
	[140398] = { zoneID = 942, artID = { 967 }, x = 3159, y = 5509, overlay = { "3120-5440","3140-5560" }, displayID = 74020, questID = { 53624 } }; --Zeritarj
	[140925] = { zoneID = 942, artID = { 967 }, x = 5344, y = 6434, overlay = { "5340-6420" }, friendly = { "A" }, displayID = 87015, questID = { 52323 } }; --Doc Marrtens <Veterinar>
	[140938] = { zoneID = 942, artID = { 967 }, x = 6293, y = 3282, overlay = { "6240-3340" }, displayID = 55080, questID = { 52303 } }; --Croaker
	[140997] = { zoneID = 942, artID = { 967 }, x = 2257, y = 7321, overlay = { "2240-7300" }, displayID = 87012, questID = { 50938 } }; --Severus the Outcast
	[141029] = { zoneID = 942, artID = { 967 }, x = 3130, y = 6171, overlay = { "3120-6180" }, displayID = 82209, questID = { 52318 } }; --Kickers
	[141039] = { zoneID = 942, artID = { 967 }, x = 6353, y = 8357, overlay = { "6340-8340" }, displayID = 34274, questID = { 52327 } }; --Ice Sickle
	[141043] = { zoneID = 942, artID = { 967 }, x = 5360, y = 6419, overlay = { "5340-6420" }, friendly = { "H" }, displayID = 87022, questID = { 52324 } }; --Jakala the Cruel
	[141059] = { zoneID = 942, artID = { 967 }, x = 6193, y = 7386, overlay = { "6200-7340" }, displayID = 40806, questID = { 52329 } }; --Grimscowl the Harebrained
	[141088] = { zoneID = 942, artID = { 967 }, x = 5704, y = 7598, overlay = { "5700-7580" }, displayID = 58870, questID = { 52433 } }; --Squall
	[141143] = { zoneID = 942, artID = { 967 }, x = 6157, y = 5705, overlay = { "6140-5700" }, displayID = 87079, questID = { 52441 } }; --Sister Absinthe
	[141175] = { zoneID = 942, artID = { 967 }, x = 7086, y = 3222, overlay = { "7080-3240" }, displayID = 75702, questID = { 52448 } }; --Song Mistress Dadalea
	[141226] = { zoneID = 942, artID = { 967 }, x = 3518, y = 7779, overlay = { "3520-7780" }, displayID = 68226, questID = { 52460 } }; --Haegol the Hammer
	[141239] = { zoneID = 942, artID = { 967 }, x = 4226, y = 6324, overlay = { "4180-6240","4200-6360" }, displayID = 87178, questID = { 52461 } }; --Osca the Bloodied
	[141286] = { zoneID = 942, artID = { 967 }, x = 3465, y = 6796, overlay = { "3440-6740" }, displayID = 87187, questID = { 52469 } }; --Poacher Zane
	[142088] = { zoneID = 942, artID = { 967 }, x = 4681, y = 4236, overlay = { "4680-4220" }, displayID = 85524, questID = { 52457 } }; --Whirlwing
	[144915] = { zoneID = 942, artID = { 967 }, x = 4960, y = 4900, overlay = { "4940-4900" }, friendly = { "H" }, displayID = 88897, questReset = true, questID = { 53715 } }; --Firewarden Viton Darkflare
	[144987] = { zoneID = 942, artID = { 967 }, x = 3660, y = 5180, overlay = { "3640-5140" }, friendly = { "H" }, displayID = 88923, questReset = true, questID = { 53724 } }; --Shadow Hunter Mutumba
	[144997] = { zoneID = 942, artID = { 967 }, x = 4680, y = 4600, overlay = { "4680-4600" }, friendly = { "H" }, displayID = 88925, questReset = true, questID = { 53771 } }; --Gurin Stonebinder
	[145020] = { zoneID = 942, artID = { 967 }, x = 4680, y = 4600, overlay = { "4680-4600" }, friendly = { "H" }, displayID = 2075, questReset = true, questID = { 53771 } }; --Dolizite
	[145278] = { zoneID = 942, artID = { 967 }, x = 3460, y = 5780, overlay = { "3440-5800" }, friendly = { "H" }, displayID = 89026, questReset = true, questID = { 53804 } }; --Dinomancer Zakuru
	[145415] = { zoneID = 942, artID = { 967 }, x = 3760, y = 4759, overlay = { "3740-4740" }, friendly = { "H" }, displayID = 89071, questReset = true, questID = { 53857 } }; --Cap'n Gorok
	[147562] = { zoneID = 942, artID = { 967 }, x = 4300, y = 4640, overlay = { "4280-4660" }, friendly = { "H" }, displayID = 89734, questReset = true, questID = { 54266 } }; --Mortar Master Zapfritz
	[147923] = { zoneID = 942, artID = { 967 }, x = 3178, y = 5848, overlay = { "3180-5840" }, friendly = { "A" }, displayID = 89806, questReset = true, questID = { 54328 } }; --Knight-Captain Joesiph
	[147941] = { zoneID = 942, artID = { 967 }, x = 4146, y = 5205, overlay = { "4140-5200" }, friendly = { "A" }, displayID = 89823, questReset = true, questID = { 54403 } }; --Tidesage Clarissa
	[147951] = { zoneID = 942, artID = { 967 }, x = 4146, y = 5214, overlay = { "4140-5200" }, friendly = { "A" }, displayID = 88525, questReset = true, questID = { 54403 } }; --Alkalinius
	[147998] = { zoneID = 942, artID = { 967 }, x = 4135, y = 5397, overlay = { "4120-5400" }, friendly = { "A" }, displayID = 89838, questReset = true, questID = { 54434 } }; --Voidmaster Evenshade
	[148044] = { zoneID = 942, artID = { 967 }, x = 5089, y = 5228, overlay = { "5100-5220" }, friendly = { "A" }, displayID = 89851, questReset = true, questID = { 54437 } }; --Owynn Graddock <S>
	[148075] = { zoneID = 942, artID = { 967 }, x = 3499, y = 6030, overlay = { "3500-6040" }, friendly = { "A" }, displayID = 89856, questReset = true, questID = { 54442 } }; --Beast Tamer Watkins
	[148092] = { zoneID = 942, artID = { 967 }, x = 4428, y = 4883, overlay = { "4440-4900" }, friendly = { "A" }, displayID = 89857, questReset = true, questID = { 54468 } }; --Nalaess Featherseeker
	[154154] = { zoneID = 942, artID = { 967 }, x = 6260, y = 1660, overlay = { "5940-1700","6000-1860","6100-1680","6180-1540","6240-1680" }, displayID = 68060, questID = { 57674 } }; --Honey Smasher
	[155055] = { zoneID = 942, artID = { 967 }, x = 6100, y = 3100, overlay = { "2560-7320","3340-3280","4080-6200","4740-3220","5700-5120","6180-3100","6300-2120","6620-6980","7220-5220" }, displayID = 68061, weeklyReset = true }; --Gurg the Hivethief
	[155059] = { zoneID = 942, artID = { 967 }, x = 7261, y = 5238, overlay = { "2560-7320","3340-3280","4080-6200","4740-3220","5720-5120","6180-3100","6300-2120","6620-6980","7220-5220" }, displayID = 79522, weeklyReset = true }; --Yorag the Jelly Feaster
	[155171] = { zoneID = 942, artID = { 967 }, x = 4000, y = 6200, overlay = { "2560-7320","3340-3280","4080-6200","4740-3220","5720-5120","6180-3100","6300-2120","6640-6980","7240-5220" }, displayID = 92246, weeklyReset = true }; --The Hivekiller
	[155172] = { zoneID = 942, artID = { 967 }, x = 5700, y = 5100, overlay = { "2560-7320","3340-3280","4080-6200","4740-3220","5720-5120","6180-3100","6300-2120","6620-6980","7240-5220" }, displayID = 2537, weeklyReset = true }; --Trapdoor Bee Hunter
	[155173] = { zoneID = 942, artID = { 967 }, x = 2500, y = 7300, overlay = { "2560-7320","3340-3280","4080-6200","4740-3220","5720-5120","6180-3100","6300-2120","6640-7000","7220-5220" }, displayID = 81965, weeklyReset = true }; --Honeyback Usurper
	[155176] = { zoneID = 942, artID = { 967 }, x = 6600, y = 6900, overlay = { "2560-7320","3340-3280","4080-6200","4740-3220","5720-5120","6180-3100","6300-2120","6620-6980","7220-5220" }, displayID = 77271, weeklyReset = true }; --Old Nasha
	[126427] = { zoneID = 943, artID = { 968 }, x = 5060, y = 5600, overlay = { "3420-4940","3480-4800","3500-5080","3540-4920","3560-5260","3620-4640","3620-5060","3660-4820","3660-4940","3660-5500","3720-5320","3740-5160","3760-4680","3780-4820","3820-5040","3840-5540","3860-5300","3880-4540","3900-4840","3940-4960","4000-5260","4000-5440","4020-4720","4060-5000","4120-4180","4120-4540","4160-4840","4180-3800","4180-4420","4180-5180","4200-4000","4200-5380","4240-4280","4260-4760","4300-3700","4320-2480","4320-5120","4320-5440","4380-4680","4420-5000","4440-4880","4500-5560","4640-5240","4680-4660","4700-5540","5000-5520" }, displayID = 56952 }; --Branchlord Aldrus
	[126432] = { zoneID = 943, artID = { 968 }, x = 5689, y = 6120, overlay = { "4700-5620","4800-5940","4900-6020","4920-5900","4960-5740","5100-5880","5200-5360","5240-5860","5320-5980","5460-6040","5540-6180","5620-6000","5720-6100","5840-6100","5840-7620","6060-6180","6240-6220","6240-6660","6240-6860","6260-7280","6340-7020","6340-7140","6360-6760","6460-7220","6500-6920","6520-6220","6520-6720","6540-7040","6580-7260","6620-6840","6700-6720" }, displayID = 37987 }; --Rumbling Goliath
	[126462] = { zoneID = 943, artID = { 968 }, x = 6900, y = 4640, overlay = { "4740-6700","4780-6500","4820-5580","4840-6120","4920-5920","4940-5740","5040-5480","5120-5680","5160-5380","5200-4360","5200-5240","5200-5560","5220-4880","5220-5080","5260-4700","5300-5380","5300-5820","5320-5680","5360-4960","5440-5380","5440-5660","5580-4400","5580-5560","5600-5260","5600-5380","5720-5220","5720-5420","5740-4780","5740-5080","5780-3380","5840-5180","5840-5300","5860-5460","5880-5580","5900-3860","5960-5200","5980-5420","6080-5500","6120-5040","6180-5260","6200-5440","6200-5560","6360-5440","6460-4640","6540-5320","6560-5160","6580-5040","6600-4820","6640-4360","6900-4640" }, friendly = { "A" }, displayID = 12814 }; --Fozruk <Son of Foz>
	[142251] = { zoneID = 943, artID = { 968 }, x = 4429, y = 2822, overlay = { "3880-2640","4020-2820","4120-2980","4200-3580","4200-4100","4220-3920","4240-2680","4240-3040","4240-3400","4280-2400","4280-3240","4320-2540","4320-2880","4360-3340","4380-2320","4380-3100","4440-2500","4440-2680","4440-2920","4480-2800","4480-3320","4540-3080","4560-2260","4560-2620","4600-2380","4600-2900","4620-1980","4680-3040","4700-2700","4720-2240","4760-1860","4800-2340","4820-2980","4860-3180","5320-3560","5760-3280","5820-3460" }, displayID = 66633 }; --Yogursa
	[142301] = { zoneID = 943, artID = { 968 }, x = 5163, y = 0936, overlay = { "4600-2080","4680-1920","4800-1300","4980-1340","5100-1180","5120-1040","5160-0760","5240-1360","5280-1060","5340-1740","5360-2220" }, displayID = 46232 }; --Venomarus
	[142312] = { zoneID = 943, artID = { 968 }, x = 6633, y = 5754, overlay = { "6520-5660","6520-5780","6520-5920","6540-5340","6560-5540","6660-5660" }, displayID = 61297 }; --Skullripper
	[142321] = { zoneID = 943, artID = { 968 }, x = 3315, y = 4183, overlay = { "3300-4040","3300-4260","3300-4380","3380-4140","3400-3900","3520-4200","3700-3960","3780-3260","4840-5500" }, displayID = 37771 }; --Ragebeak
	[142361] = { zoneID = 943, artID = { 968 }, x = 7759, y = 2960, overlay = { "6740-4020","6860-3340","7000-3540","7100-3120","7220-4120","7260-3160","7340-3620","7420-4140","7440-3300","7440-3460","7540-2860","7540-3040","7560-3160","7660-2940","7680-3080" }, displayID = 54845 }; --null
	[142418] = { zoneID = 943, artID = { 968 }, x = 3935, y = 5850, overlay = { "3680-5460","3720-5340","3860-5420","3880-5820","4060-5720","4060-5940","4320-5540","4540-5560","4760-5720" }, displayID = 62045 }; --Cresting Goliath
	[142419] = { zoneID = 943, artID = { 968 }, x = 6070, y = 4872, overlay = { "5320-5820","5980-4840","6080-4920" }, displayID = 54195 }; --Thundering Goliath
	[135448] = { zoneID = 974, artID = { 974 }, x = 3556, y = 4744, displayID = 84258 }; --Gol'than the Malodorous
	[140123] = { zoneID = 1004, artID = { 1001 }, x = 5441, y = 4922, displayID = 86571 }; --Weaponmaster Halu
	[136945] = { zoneID = 1016, artID = { 1007 }, x = 2404, y = 3449, displayID = 80965 }; --Corvus
	[134112] = { zoneID = 1018, artID = { 1009 }, x = 5138, y = 6374, displayID = 81890 }; --Matron Christiane
	[139194] = { zoneID = 1041, artID = { 1021 }, x = 6218, y = 6353, overlay = { "6218-6353" }, displayID = 57548 }; --Rotmaw
	[140593] = { zoneID = 1041, artID = { 1021 }, x = 4605, y = 2511, displayID = 84330 }; --Restless Horror
	[137983] = { zoneID = 1161, artID = { 1138 }, x = 3142, y = 6391, overlay = { "2440-6480","2620-6300","2860-6940","2900-6380","2940-6840","2980-7020","3000-6720","3040-6380","3060-6920","3140-6480","3180-6340","3200-6720","3200-6980","3240-6600","3260-6480","3320-6160","3360-6700" }, friendly = { "A" }, displayID = 85666 }; --Rear Admiral Hainsworth
	[138039] = { zoneID = 1161, artID = { 1138 }, x = 3142, y = 6391, overlay = { "2840-6200","2900-6380","3020-6680","3140-6320","3140-6460","3220-6600","3380-6760" }, friendly = { "H" }, displayID = 30071 }; --Dark Ranger Clea
	[139287] = { zoneID = 1161, artID = { 1138 }, x = 7885, y = 3876, overlay = { "7540-3740","7580-4120","7600-3980","7600-4600","7620-3860","7640-4300","7660-3620","7660-4480","7660-5060","7700-4080","7740-4600","7740-4740","7740-4900","7800-3740","7820-4420","7840-4140","7880-3900","7880-4720","7900-5280","7920-4020","7940-4240","7940-4880","7940-5060","7960-4420","8000-4560","8060-4720","8080-4880","8160-5040","8300-4960" }, displayID = 80474, questID = { 51877 } }; --Sawtooth
	[143559] = { zoneID = 1161, artID = { 1138 }, x = 5620, y = 2600, overlay = { "5620-2600" }, friendly = { "A" }, displayID = 82677 }; --Grand Marshal Tremblade <War Capt>
	[143560] = { zoneID = 1161, artID = { 1138 }, x = 5640, y = 2580, overlay = { "5640-2580" }, friendly = { "A" }, displayID = 82676 }; --Marshal Gabriel <Second-in-Comm>
	[145161] = { zoneID = 1161, artID = { 1138 }, x = 3460, y = 6840, overlay = { "3020-6340","3040-6800","3120-6460","3140-6300","3140-6600","3240-6140","3240-6700","3260-6300","3280-6460","3360-6140","3360-6640","3460-6840" }, friendly = { "H" }, displayID = 88988 }; --Siege Engineer Krackleboom
	[120899] = { zoneID = 1165, artID = { 1143 }, x = 5498, y = 8253, overlay = { "5500-8200","5500-8360" }, displayID = 76019, questID = { 48333 } }; --Kul'krazahn <Amani Champ>
	[122639] = { zoneID = 1165, artID = { 1143 }, x = 5060, y = 5959, overlay = { "4940-5940","5060-5940" }, friendly = { "H" }, displayID = 47367 }; --Old R'gal <Strength of Re>
	[125816] = { zoneID = 1165, artID = { 1143 }, x = 5060, y = 8500, overlay = { "4940-8460","5000-8240","5000-8680","5060-8420" }, friendly = { "H" }, displayID = 78593 }; --Sky Queen
	[140474] = { zoneID = 1182, artID = { 1155 }, x = 5850, y = 5458, overlay = { "5850-5458" }, displayID = 86696, questID = { 53428,53429 } }; --Adherent of the Abyss
	[145242] = { zoneID = 1332, artID = { 1185 }, x = 5268, y = 7139, overlay = { "5260-7200","5280-7040" }, displayID = 67608 }; --Scalefiend
	[145250] = { zoneID = 1332, artID = { 1185 }, x = 4580, y = 8380, overlay = { "4400-8440","4440-8620","4580-8380" }, displayID = 67206 }; --Madfeather
	[145269] = { zoneID = 1332, artID = { 1185 }, x = 4449, y = 3570, overlay = { "4440-3520" }, displayID = 89029 }; --Glimmerspine
	[148144] = { zoneID = 1332, artID = { 1185 }, x = 5859, y = 5120, overlay = { "5740-5140","5860-5120" }, friendly = { "H" }, displayID = 77979 }; --Croz Bloodrage
	[148147] = { zoneID = 1332, artID = { 1185 }, x = 3760, y = 5740, overlay = { "3620-5440","3640-5580","3680-5760","3700-5320","3740-5440","3760-5580" }, friendly = { "H" }, displayID = 89896 }; --Orwell Stevenson <Hunter Extraordina>
	[148154] = { zoneID = 1332, artID = { 1185 }, x = 5660, y = 3559, overlay = { "5540-3540","5660-3540" }, friendly = { "H" }, displayID = 89897 }; --Agathe Wyrmwood
	[149512] = { zoneID = 1332, artID = { 1185 }, x = 3652, y = 5551, overlay = { "3652-5551" }, friendly = { "A" }, displayID = 89243 }; --Shadowclaw
	[149514] = { zoneID = 1332, artID = { 1185 }, x = 5611, y = 5389, overlay = { "5611-5389" }, friendly = { "A" }, displayID = 89315 }; --Grimhorn
	[149516] = { zoneID = 1332, artID = { 1185 }, x = 5589, y = 3336, overlay = { "5589-3336" }, friendly = { "A" }, displayID = 707 }; --Blackpaw
	[144644] = { zoneID = 1355, artID = { 1186 }, x = 4513, y = 6117, overlay = { "2400-3540","2700-2700","2700-2860","2700-4200","2840-2720","2960-4840","3140-4260","3240-3460","3240-4920","3340-3540","3440-2660","3440-4340","3460-3520","3480-3760","3500-4720","3540-3340","3540-4940","3540-8100","3580-2800","3620-7880","3620-8740","3640-3820","3680-4720","3680-7760","3720-5640","3740-1680","3760-3980","3800-4220","3800-4940","3840-5740","3880-1200","3880-3060","3880-7820","3920-8160","3960-4220","3980-5740","4040-8500","4120-6240","4180-6020","4200-8080","4220-4200","4280-1280","4340-6100","4400-5380","4400-6340","4420-3740","4500-5980","4520-4940","4520-6120","4540-2440","4540-3240","4640-6000","4660-4740","4760-7660","4780-5960","4800-4640","5000-5040","5020-5760","5040-4840","5120-6720","5240-3860","5540-2860","5700-5300","5740-1340","5840-3020","5880-2680","5980-0980","5980-1580","5980-3820","6040-1420","6040-2860","6040-5060","6060-3380","6100-2720","6140-1920","6160-5240","6200-4880","6340-1880","6780-3140","6960-2820","7140-4640","7180-3600","7340-2620","7340-2880" }, displayID = 91114, questID = { 56274 } }; --Mirecrawler
	[149653] = { zoneID = 1355, artID = { 1186 }, x = 5480, y = 4179, overlay = { "5480-4180" }, displayID = 80467, questID = { 55366 } }; --Carnivorous Lasher
	[150191] = { zoneID = 1355, artID = { 1186 }, x = 3680, y = 1160, overlay = { "3680-1120" }, displayID = 90991, questID = { 55584 } }; --Avarius <Guardian of the Dep>
	[150468] = { zoneID = 1355, artID = { 1186 }, x = 4820, y = 2420, overlay = { "4820-2420" }, displayID = 91869, questID = { 55603 } }; --Vor'koth
	[150583] = { zoneID = 1355, artID = { 1186 }, x = 5274, y = 4368, overlay = { "2700-3040","2740-3160","2940-4200","2980-4080","3060-4240","3240-3340","3240-3460","3260-3580","3300-3700","3340-4600","3360-4720","3380-3360","3460-4840","3480-3440","3700-7460","3740-3980","3740-4420","3740-7340","3780-4160","3800-8580","3820-7560","3860-7440","3900-5600","3920-5820","3920-8700","3980-6460","4000-8560","4040-4660","4040-6200","4040-6700","4100-4840","4100-4960","4120-5900","4160-6620","4180-6120","4180-8640","4220-8780","4440-6560","4500-6440","4540-4320","4640-3240","4640-4160","4640-7640","4660-6480","4720-7440","4760-4340","4780-7280","4800-6820","4820-7020","4900-7380","4940-7040","4940-7160","5200-4420","5440-5440","5480-4220","5540-5340","5560-4860","5560-5460","5580-4660","5620-4020","5640-4160","5640-5140","5660-4760","5760-4640","5940-4420","6020-4920","6080-4360","6140-5360","6300-4460","6340-4620","6460-4520","6780-4440","6780-4920","6840-3340","6840-4000","6840-4200","6880-3720","6880-3840","6920-4960","6940-3160","6940-5080","6960-3320","6960-4160","7040-4040","7080-3080","7100-2940","7120-4920","7140-4640","7180-2740","7320-3100","7340-2940","7460-2780","7620-2400","7620-2860","7640-2560","7640-2680","7640-3120","7640-3980","7720-3840","7740-4060","7760-2400","7760-3280","7760-4220","7780-2920","7840-3140","7840-3560","7860-3020","7920-4000","7960-3520","8000-3720","8020-4100","8040-3920","8080-3540","8220-3760" }, displayID = 90992, questID = { 56291 } }; --Rockweed Shambler
	[151719] = { zoneID = 1355, artID = { 1186 }, x = 6733, y = 3462, overlay = { "6720-3440" }, displayID = 90988, questID = { 56300 } }; --Voice in the Deeps
	[151870] = { zoneID = 1355, artID = { 1186 }, x = 5797, y = 5784, overlay = { "2580-3120","2600-2880","2600-3280","2700-2740","2700-3020","2720-3200","2720-3360","2740-3740","2800-3880","2840-2900","2840-3060","2840-4740","2860-4360","2900-3180","2900-3800","2920-4640","2940-3640","2940-4040","2940-4200","2980-2900","2980-3020","3060-3660","3060-4280","3080-3540","3100-4140","3140-3060","3160-2900","3160-3220","3220-3680","3240-3360","3240-4460","3240-4600","3320-2920","3320-3140","3340-2740","3340-3540","3340-4900","3460-4180","3460-4900","3480-2960","3500-2040","3500-4460","3520-2840","3520-3640","3540-3380","3540-3500","3540-4040","3540-5300","3580-2220","3620-3720","3620-6800","3640-1620","3640-1760","3640-3860","3640-4340","3640-7720","3660-5520","3680-3080","3700-2040","3720-2400","3720-2760","3720-3600","3720-5400","3720-6580","3720-7240","3740-2160","3740-2540","3740-2920","3740-4020","3740-4200","3740-5660","3740-7640","3760-3780","3780-7120","3800-1140","3820-1940","3820-6680","3820-6980","3840-1600","3840-2360","3840-4320","3880-0920","3880-3060","3880-3820","3880-3980","3900-2100","3900-2240","3920-2580","3940-4920","3940-7240","3960-4580","4000-4020","4000-4140","4000-4360","4020-1460","4020-7860","4020-8000","4040-2540","4040-2820","4060-4940","4080-1640","4080-2660","4080-3880","4080-7640","4100-1340","4100-2400","4120-1960","4140-4060","4140-6540","4140-6700","4160-7840","4180-4220","4180-4960","4200-1540","4200-3920","4200-6860","4200-7160","4240-2140","4240-4740","4240-6020","4260-4860","4260-7460","4260-7580","4280-1740","4280-2280","4280-7260","4300-4300","4300-5560","4300-5820","4300-7940","4320-5260","4340-5400","4340-7680","4360-4760","4380-1620","4380-7800","4400-4940","4400-5060","4420-6100","4440-5940","4500-4780","4540-2940","4540-6120","4540-7480","4560-3060","4560-5940","4600-4920","4620-5060","4620-7340","4620-7660","4640-4700","4640-6540","4680-5280","4740-7620","4760-6680","4780-6280","4800-4700","4800-6820","4800-6960","4800-7240","4820-4860","4820-7080","4840-3660","4840-4060","4840-5120","4900-6520","4920-6660","4940-3540","4940-3980","4940-4980","4940-5800","4940-6860","4940-6980","4940-7640","4960-4660","4960-5120","5000-3200","5000-3660","5000-4540","5020-3840","5040-7060","5080-2620","5080-7540","5100-2060","5100-3280","5140-3540","5140-5620","5180-2260","5180-2500","5180-3420","5200-3720","5240-2140","5240-2840","5240-3240","5240-4180","5260-3000","5260-4380","5260-5560","5280-2660","5300-3440","5300-5340","5340-1800","5380-2840","5400-2960","5400-5440","5420-2460","5420-5580","5440-4160","5440-5320","5480-2080","5480-4900","5520-1280","5520-4260","5520-5140","5540-5500","5560-5260","5580-4140","5600-2040","5600-4700","5620-1380","5620-2160","5620-2620","5620-4540","5620-5640","5620-5760","5640-1140","5640-4400","5640-5020","5680-5440","5700-5300","5720-2860","5740-2540","5740-5760","5760-1160","5760-2220","5760-5000","5780-1020","5780-2400","5780-4540","5800-2660","5800-4020","5800-4420","5800-4700","5800-5640","5820-5300","5820-5460","5840-0900","5840-4200","5880-4860","5920-4540","5920-5560","5940-1380","5940-2600","5940-2840","5940-2960","5940-5120","5940-5280","5960-3920","5960-4760","5980-5440","6000-0880","6000-4140","6000-4300","6020-1480","6020-2440","6040-5000","6040-5600","6060-1320","6060-4500","6100-1820","6120-2120","6120-2940","6120-5140","6140-1000","6140-2640","6140-4340","6140-5280","6140-5440","6160-2420","6180-1640","6180-3140","6180-3720","6180-4460","6220-3860","6240-1240","6240-4620","6240-5600","6240-5760","6260-2280","6260-2820","6280-1560","6280-4320","6300-1740","6300-2600","6300-3520","6300-4800","6320-2140","6320-3400","6340-3920","6340-4100","6340-4480","6360-4620","6400-2000","6400-3720","6400-5720","6440-1680","6440-2840","6440-4340","6460-4480","6480-1400","6480-4640","6480-5120","6500-2580","6500-3960","6500-4940","6520-4120","6520-4820","6540-2960","6540-3840","6560-1680","6580-2700","6580-3720","6600-2380","6600-4260","6620-1920","6620-2140","6620-4040","6620-4740","6640-2520","6640-4620","6660-2840","6700-2660","6700-3880","6700-4480","6720-3600","6720-3720","6720-4140","6720-4320","6740-4880","6740-5140","6820-3240","6820-3360","6820-5040","6840-4180","6840-4540","6840-4680","6860-3600","6860-5200","6880-4040","6900-3720","6940-2600","6940-2820","6940-5360","6960-4800","6960-5540","6980-3060","6980-5120","7020-3280","7020-3600","7040-2920","7080-2780","7080-3720","7100-2220","7100-4100","7120-3420","7120-3940","7120-4440","7120-4600","7120-4860","7120-5400","7140-3540","7140-4740","7200-2940","7220-4180","7240-5040","7280-2840","7280-3800","7300-3120","7300-4020","7300-4640","7300-4860","7340-2620","7340-3580","7340-4340","7340-4480","7380-2960","7420-4200","7420-4720","7440-3080","7440-3840","7440-4040","7440-4880","7480-3580","7500-2680","7500-4520","7520-2440","7520-2920","7540-2560","7540-3160","7540-3400","7540-3720","7560-3920","7600-4120","7640-2700","7680-3180","7680-3340","7680-3700","7680-4000","7700-4240","7720-2420","7720-3500","7740-2920","7800-3620","7800-4100","7800-4640","7800-4820","7840-2620","7840-3140","7840-3320","7840-3840","7840-4440","7860-2860","7940-2760","7940-2980","7940-3500","7940-3660","7940-4020","8000-3180","8060-3900","8080-3040","8080-4160","8100-3500","8220-3920","8220-4040","8340-3320","8400-3960","8460-3700","8480-3420","8520-3840","8540-3580" }, displayID = 47677, questID = { 56276 } }; --Sandcastle
	[152290] = { zoneID = 1355, artID = { 1186 }, x = 5804, y = 4200, overlay = { "5360-4140","5380-4260","5440-5040","5740-5140","5800-4180","6000-4780","6240-5940","6440-5160" }, displayID = 92542, questID = { 56298 } }; --Soundless
	[152291] = { zoneID = 1355, artID = { 1186 }, x = 6180, y = 4800, overlay = { "5220-4300","5220-5440","5240-5240","5320-4220","5320-4460","5320-5340","5320-5600","5360-4000","5360-5180","5360-5460","5480-5240","5500-4240","5620-4480","5620-4840","5620-5060","5640-4240","5640-5280","5680-5440","5700-4740","5720-4940","5740-5060","5820-4120","5820-5560","5840-5180","5840-5320","5840-5440","5860-5020","5920-4880","5960-5260","5960-5540","5960-5660","5980-5120","6020-4720","6060-4880","6100-5280","6160-5000","6180-4800" }, displayID = 90735, questID = { 56272 } }; --Deepglider
	[152323] = { zoneID = 1355, artID = { 1186 }, x = 2944, y = 2900, overlay = { "2840-2900" }, displayID = 91234, questID = { 55671 } }; --King Gakula
	[152359] = { zoneID = 1355, artID = { 1186 }, x = 7164, y = 5483, overlay = { "7120-5440" }, displayID = 90766, questID = { 56297 } }; --Siltstalker the Packmother
	[152360] = { zoneID = 1355, artID = { 1186 }, x = 6922, y = 4518, overlay = { "6440-4720","6540-5040","6740-4700","6920-4520" }, displayID = 90767, questID = { 56278 } }; --Toxigore the Alpha
	[152361] = { zoneID = 1355, artID = { 1186 }, x = 7397, y = 5390, overlay = { "7060-5420","7200-5400","7320-5380" }, displayID = 90768, questID = { 56282 } }; --Banescale the Packfather
	[152397] = { zoneID = 1355, artID = { 1186 }, x = 7813, y = 2500, overlay = { "7740-2440","7840-2560" }, displayID = 91479, questID = { 56288 } }; --Oronu
	[152414] = { zoneID = 1355, artID = { 1186 }, x = 6369, y = 3272, overlay = { "6320-3480","6340-3200","6420-3560","6520-3260","6600-3360" }, displayID = 91242, questID = { 56284 } }; --Elder Unu
	[152415] = { zoneID = 1355, artID = { 1186 }, x = 5237, y = 4172, overlay = { "5240-4200" }, displayID = 91242, questID = { 56279 } }; --Alga the Eyeless
	[152416] = { zoneID = 1355, artID = { 1186 }, x = 7106, y = 3436, overlay = { "6500-3760","6540-3880","6620-4040","6780-3700","6940-4040","7100-3440" }, displayID = 91242, questID = { 56280 } }; --Allseer Oma'kil
	[152448] = { zoneID = 1355, artID = { 1186 }, x = 4722, y = 5611, overlay = { "4020-4940","4220-4800","4340-5420","4440-5540","4540-4700","4560-5580","4600-5440","4660-5240","4700-5540","4940-5140","5620-5700" }, displayID = 90947, questID = { 56286 } }; --Iridescent Glimmershell
	[152464] = { zoneID = 1355, artID = { 1186 }, x = 4078, y = 0735, overlay = { "4078-0735" }, displayID = 91024, questID = { 56283 } }; --Caverndark Terror
	[152465] = { zoneID = 1355, artID = { 1186 }, x = 5012, y = 1907, overlay = { "3940-2740","4600-2520","4680-3020","4840-1700","5020-1920","5640-0880","7040-2460" }, displayID = 91027, questID = { 56275 } }; --Needlespine
	[152542] = { zoneID = 1355, artID = { 1186 }, x = 2904, y = 4597, overlay = { "2880-4640" }, displayID = 90033, questID = { 56294 } }; --Scale Matriarch Zodia
	[152545] = { zoneID = 1355, artID = { 1186 }, x = 2716, y = 3703, overlay = { "2740-3700" }, displayID = 90034, questID = { 56293 } }; --Scale Matriarch Vynara
	[152548] = { zoneID = 1355, artID = { 1186 }, x = 3553, y = 4128, overlay = { "3500-4160" }, displayID = 90035, questID = { 56292 } }; --Scale Matriarch Gratinax
	[152552] = { zoneID = 1355, artID = { 1186 }, x = 6427, y = 0598, overlay = { "6260-0840","6340-0700","6440-0540","6560-0580" }, displayID = 74318, questID = { 56295 } }; --Shassera <Nightmare in the Depths>
	[152553] = { zoneID = 1355, artID = { 1186 }, x = 3717, y = 4751, overlay = { "3140-3540","3220-3660","3240-3340","3640-4420","3640-4560","3660-3940","3660-4080","3740-4740","3840-4300","3940-4220","3980-4360" }, displayID = 50760, questID = { 56273 } }; --Garnetscale
	[152555] = { zoneID = 1355, artID = { 1186 }, x = 5207, y = 7544, overlay = { "5140-7520" }, displayID = 78243, questID = { 56285 } }; --Elderspawn Nalaada <The Writhing>
	[152556] = { zoneID = 1355, artID = { 1186 }, x = 4919, y = 8875, overlay = { "4900-8840" }, displayID = 78240, questID = { 56270 } }; --Chasm-Haunter
	[152566] = { zoneID = 1355, artID = { 1186 }, x = 5859, y = 5360, overlay = { "5840-5240","5840-5360" }, displayID = 91523, questID = { 56281 } }; --Anemonar
	[152567] = { zoneID = 1355, artID = { 1186 }, x = 5017, y = 6952, overlay = { "4940-6940","4940-7060","5060-6920" }, displayID = 91524, questID = { 56287 } }; --Kelpwillow
	[152568] = { zoneID = 1355, artID = { 1186 }, x = 3160, y = 3060, overlay = { "3140-2940","3140-3060" }, displayID = 91525, questID = { 56299 } }; --Urduu
	[152671] = { zoneID = 1355, artID = { 1186 }, x = 4359, y = 7847, overlay = { "4280-7780" }, displayID = 92425, weeklyReset = true, questID = { 56055 } }; --Wekemara
	[152681] = { zoneID = 1355, artID = { 1186 }, x = 4304, y = 8794, overlay = { "4240-8760" }, displayID = 58886, questID = { 56289 } }; --Prince Typhonus
	[152682] = { zoneID = 1355, artID = { 1186 }, x = 4299, y = 7552, overlay = { "4240-7440","4280-7560","4360-7440" }, displayID = 65631, questID = { 56290 } }; --Prince Vortran
	[152712] = { zoneID = 1355, artID = { 1186 }, x = 3740, y = 8254, overlay = { "3720-8260" }, displayID = 75839, questID = { 56269 } }; --Blindlight <Necrofin Chieftain>
	[152736] = { zoneID = 1355, artID = { 1186 }, x = 8338, y = 3562, overlay = { "8340-3540","8340-3680","8460-3580" }, displayID = 91573, weeklyReset = true, questID = { 56058 } }; --Guardian Tannin
	[152756] = { zoneID = 1355, artID = { 1186 }, x = 3818, y = 2587, overlay = { "2600-2820","2660-2940","2740-3060","3880-5800","3980-5900","4000-8340","4040-2820","4040-8100","4180-5900","4780-7680","4800-2100","4840-1940","5060-7420","5720-4000","7000-4240","7040-3300","7140-2760","7180-2880","7200-2580","3818-2587" }, displayID = 90944, questID = { 56271 } }; --Daggertooth Terror
	[152794] = { zoneID = 1355, artID = { 1186 }, x = 5447, y = 5526, overlay = { "2580-3240","2620-3400","2700-2700","2720-3520","2820-3440","3140-4280","3220-3840","3360-3500","3420-3700","3420-4100","3440-4360","3540-3380","3580-2800","3600-4820","3660-2400","3680-4720","3700-7760","3760-1680","3760-3980","3880-3060","3900-4540","3940-1980","3960-5740","4000-2440","4040-2060","4060-4260","4120-3240","4180-6020","4220-4200","4340-2060","4340-6100","4440-5300","4460-2000","4500-5980","4520-5020","4540-3240","4540-6140","4580-3940","4640-6000","4660-1580","4660-6180","4800-4640","5000-5040","5040-4820","5200-3660","5260-3320","5260-5680","5500-5020","5540-2860","5640-5540","5700-5300","5840-3040","5980-1560","6000-4840","6040-1420","6060-2840","6100-2720","6160-3600","6200-5400","6220-3220","6320-1980","6440-1860","6500-5120","6700-2340","6840-1880","6840-3320","7040-2520","7960-4280","5447-5526" }, displayID = 90519, questID = { 56268 } }; --Amethyst Spireshell
	[152795] = { zoneID = 1355, artID = { 1186 }, x = 6544, y = 4087, overlay = { "5180-5140","5180-5260","5600-4400","6340-4720","6380-4860","6420-5480","6520-4160","6840-3240","7340-4560","7440-3100","7440-4400","7620-5200","7840-3220","7940-3860","7980-2740","8060-4200","8120-4000","8280-4180","8420-4040" }, displayID = 75368, questID = { 56277 } }; --Sandclaw Stoneshell
	[153658] = { zoneID = 1355, artID = { 1186 }, x = 3856, y = 1750, overlay = { "3740-1440","3840-0940","3840-1720","3860-1080","4040-1200","4040-1520","4160-1560" }, displayID = 91870, questID = { 56296 } }; --Shiz'narasz the Consumer
	[153898] = { zoneID = 1355, artID = { 1186 }, x = 6260, y = 2960, overlay = { "6240-2940" }, displayID = 58886, questID = { 56122 } }; --Tidelord Aquatus
	[153928] = { zoneID = 1355, artID = { 1186 }, x = 5800, y = 2780, overlay = { "5740-2640","5800-2780" }, displayID = 58886, questID = { 56123 } }; --Tidelord Dispersius
	[154148] = { zoneID = 1355, artID = { 1186 }, x = 6660, y = 2360, overlay = { "6540-2320","6660-2340" }, displayID = 68617, questID = { 56106 } }; --Tidemistress Leth'sindra
	[155811] = { zoneID = 1355, artID = { 1186 }, x = 3133, y = 2990, overlay = { "3340-3000","3133-2990" }, displayID = 88870, questReset = true, questID = { 56882 } }; --Commander Minzera <Battlemaiden of Zanj>
	[155836] = { zoneID = 1355, artID = { 1186 }, x = 4790, y = 6738, overlay = { "4900-6660","4940-6540","4790-6738" }, displayID = 92499, questReset = true, questID = { 56890 } }; --Theurgist Nitara <Battlemaiden of Azsh'>
	[155838] = { zoneID = 1355, artID = { 1186 }, x = 7933, y = 4963, overlay = { "7880-5040" }, displayID = 92501, questReset = true }; --Incantatrix Vazina <Battlemaiden of Shirak>
	[155840] = { zoneID = 1355, artID = { 1186 }, x = 4742, y = 3220, overlay = { "4740-3220" }, displayID = 91768, questReset = true, questID = { 56893 } }; --Warlord Zalzjar <Champion of Zanj>
	[155841] = { zoneID = 1355, artID = { 1186 }, x = 7340, y = 3140, overlay = { "7340-3140" }, displayID = 92503, questReset = true, questID = { 56894 } }; --Shadowbinder Athissa <Champion of Shirak>
	[156676] = { zoneID = 1409, artID = { 1193 }, x = 6040, y = 6000, overlay = { "6040-6000","6100-6120" }, friendly = { "H" }, displayID = 86424 }; --Ogre Overseer
	[156986] = { zoneID = 1409, artID = { 1193 }, x = 5740, y = 4080, overlay = { "5620-4180","5820-4060","5840-3940","5840-4220","5900-3820","5960-4060","6040-4160","6080-4040" }, friendly = { "H" }, displayID = 92831 }; --Ogre Taskmaster
	[135497] = { zoneID = 1462, artID = { 1276 }, x = 4972, y = 4721, overlay = { "3800-4200","3820-2940","3820-3120","3880-3500","3920-4140","3940-2940","3940-3180","4020-4260","4040-3440","4040-3720","4040-3920","4040-4120","4040-4780","4060-4420","4080-3000","4120-3560","4120-4940","4140-3340","4180-3980","4180-4620","4180-4740","4200-3820","4220-3200","4220-4200","4220-4340","4240-3660","4240-4860","4260-3440","4260-5100","4280-4460","4280-5220","4320-3820","4320-4040","4320-4680","4340-3580","4340-5000","4360-4800","4380-4260","4400-3140","4440-3260","4440-3400","4440-4060","4440-4380","4460-3620","4480-4520","4520-3780","4520-3900","4540-4740","4540-4940","4540-5080","4560-4360","4580-3480","4600-4240","4620-4040","4640-2960","4660-3760","4660-4520","4660-4740","4680-4360","4680-5000","4740-3920","4740-4200","4800-4040","4800-4580","4800-4860","4820-4360","4820-4740","4860-3920","4880-3800","4920-4220","4940-3620","4940-4460","4940-4700","4960-4100","4960-4880","5060-3700","5060-4580","5080-3840","5080-4440","5080-4760","5120-4100","5140-4260","5200-4640","5220-4780","5220-4940","5260-4120","5280-4340","5440-4140" }, displayID = 86350, questID = { 55367 } }; --Mushroom
	[149847] = { zoneID = 1462, artID = { 1276 }, x = 8245, y = 2093, overlay = { "8140-2180","8245-2093" }, displayID = 89858, questID = { 55812 } }; --Crazed Trogg
	[150342] = { zoneID = 1462, artID = { 1276 }, x = 6380, y = 2440, overlay = { "6260-2660","6320-2540" }, displayID = 160, questID = { 55814 } }; --Earthbreaker Gulroc
	[150394] = { zoneID = 1462, artID = { 1276 }, x = 5333, y = 4979, overlay = { "5340-4940","6000-4500","6180-4180","6240-4020","6320-3840" }, displayID = 90757, questID = { 55546 } }; --Armored Vaultbot
	[150575] = { zoneID = 1462, artID = { 1276 }, x = 3914, y = 5304, overlay = { "3840-5320","3960-5320" }, displayID = 21246, questID = { 55368 } }; --Rumblerocks
	[150937] = { zoneID = 1462, artID = { 1276 }, x = 1960, y = 7980, overlay = { "1940-7940","1940-8060" }, displayID = 86469, questID = { 55545 } }; --Seaspit
	[151124] = { zoneID = 1462, artID = { 1276 }, x = 5720, y = 5259, overlay = { "5680-5460","5720-5240" }, displayID = 91217, questID = { 55207 } }; --Mechagonian Nullifier
	[151159] = { zoneID = 1462, artID = { 1276 }, x = 6118, y = 4509, overlay = { "4540-4000","4660-4040","4780-4060","4800-3940","4940-3940","5040-3720","5040-4140","5120-4360","5140-4580","5140-4940","5160-3640","5300-4580","5320-3460","5320-4940","5340-3100","5340-3320","5340-5800","5380-4740","5400-4440","5440-3560","5440-5060","5440-5880","5560-4380","5560-5040","5580-5960","5600-6180","5620-3440","5680-4320","5700-3340","5720-5000","5740-5820","5800-3180","5820-5080","5820-5720","5840-2940","5840-4440","5860-3060","5860-5200","5900-2820","5940-4700","5940-5620","5960-4500","6020-2700","6020-6620","6040-5300","6040-5440","6060-5620","6120-6520","6140-3940","6140-4220","6140-4420","6140-5760","6160-5380","6180-4060","6180-6380","6220-5260","6220-6020","6220-6260","6240-2620","6240-2760","6240-3200","6240-3320","6240-3520","6240-3680","6280-4420","6280-5700","6300-3060","6300-5080","6320-2880","6320-5540","6360-4960","6400-5440","6420-3040","6420-4620","6440-4440","6440-4780","6480-2900","6500-3140","6500-4300","6540-4140","6540-4960","6540-5080","6560-5200","6580-3240","6600-3960","6600-5500","6620-2840","6640-3360","6640-3640","6640-3800","6640-4840","6640-5340","6660-5000","6680-4200","6740-2540","6740-2740","6740-3460","6740-4620","6800-5080","6820-4140","6840-3560","6860-4640","6880-5220","6940-5400","6940-5540","6980-4640","6980-5720","7000-5900","7020-3240","7020-3640","7020-6040","7080-5620","7140-3380","7140-3540","7140-3720","7220-5580","7240-3220","7240-3820","7320-3000","7340-1920","7340-2080","7340-4440","7340-4580","7380-3580","7380-5480","7400-2840","7400-3960","7420-2280","7420-4680","7440-2400","7440-2600","7480-4420","7500-5420","7520-4200","7540-3840","7540-5560","7560-4720","7580-4040","7640-5660","7660-3920","7700-4940","7740-5080","7740-5260","7740-5520","7780-3880" }, displayID = 36372, questID = { 55515 } }; --OOX-Fleetfoot/MG
	[151202] = { zoneID = 1462, artID = { 1276 }, x = 6563, y = 5161, overlay = { "6540-5100" }, displayID = 90423, questID = { 55513 } }; --Foul Manifestation
	[151296] = { zoneID = 1462, artID = { 1276 }, x = 5720, y = 3940, overlay = { "5620-4060","5720-3940" }, displayID = 36372, questID = { 55515 } }; --OOX-Avenger/MG
	[151308] = { zoneID = 1462, artID = { 1276 }, x = 5560, y = 2660, overlay = { "5340-3140","5340-3260","5440-2680","5440-2940","5540-2540","5560-2660" }, displayID = 11611, questID = { 55539 } }; --Boggac Skullbash
	[151569] = { zoneID = 1462, artID = { 1276 }, x = 3528, y = 4291, overlay = { "3520-4240" }, displayID = 92887, questID = { 55514 } }; --Deepwater Maw
	[151623] = { zoneID = 1462, artID = { 1276 }, x = 7260, y = 5060, overlay = { "7140-4920","7220-5060","7260-4940" }, displayID = 59347, questID = { 55364 } }; --The Scrap King
	[151625] = { zoneID = 1462, artID = { 1276 }, x = 7220, y = 4999, overlay = { "7100-4840","7140-4960","7260-4940","7280-5060" }, displayID = 91218, questID = { 55364 } }; --The Scrap King
	[151627] = { zoneID = 1462, artID = { 1276 }, x = 6102, y = 6144, overlay = { "5940-6080","6100-6160","6120-6040" }, displayID = 24118, questID = { 55859 } }; --Mr. Fixthis
	[151672] = { zoneID = 1462, artID = { 1276 }, x = 8789, y = 2061, overlay = { "8740-2040","8740-2160" }, displayID = 73603, questID = { 55386 } }; --Mecharantula
	[151684] = { zoneID = 1462, artID = { 1276 }, x = 7724, y = 4471, overlay = { "7724-4471" }, displayID = 68856, questID = { 55399 } }; --Jawbreaker
	[151702] = { zoneID = 1462, artID = { 1276 }, x = 2566, y = 7787, overlay = { "2040-6820","2140-7020","2240-6840","2260-6960","2360-6800","2566-7787" }, displayID = 68226, questID = { 55405 } }; --Paol Pondwader
	[151933] = { zoneID = 1462, artID = { 1276 }, x = 6066, y = 4214, overlay = { "6080-4200" }, displayID = 92457, questID = { 55544 } }; --Malfunctioning Beastbot
	[151934] = { zoneID = 1462, artID = { 1276 }, x = 5360, y = 4080, overlay = { "5140-4120","5240-4040","5360-4080" }, displayID = 73601, questID = { 55512 } }; --Arachnoid Harvester
	[151940] = { zoneID = 1462, artID = { 1276 }, x = 5880, y = 2460, overlay = { "5740-2200","5840-2360" }, displayID = 90502, questID = { 55538 } }; --Uncle T'Rogg
	[152001] = { zoneID = 1462, artID = { 1276 }, x = 6566, y = 2278, overlay = { "6540-2340","6540-2480","6580-2660","6660-2340" }, displayID = 77483, questID = { 55537 } }; --Bonepicker
	[152007] = { zoneID = 1462, artID = { 1276 }, x = 4079, y = 3430, overlay = { "3840-3000","3920-3160","3920-4480","4040-3020","4040-3340","4040-3480","4040-4340","4060-4460","4120-4960","4160-3040","4160-3340","4160-3460","4180-2900","4240-4840","4260-4980","4340-4420","4360-4740","4440-4340","4480-4460","4500-4580","4600-4460","4780-4860","4940-4740","4980-4880","5020-4640" }, displayID = 90855, questID = { 55369 } }; --Killsaw
	[152113] = { zoneID = 1462, artID = { 1276 }, x = 7180, y = 4980, overlay = { "6620-4040","6640-4780","6680-4600","6700-4280","6840-4680","6900-4540","7140-4920" }, displayID = 90876, questID = { 55858 } }; --The Kleptoboss
	[152182] = { zoneID = 1462, artID = { 1276 }, x = 6583, y = 7917, overlay = { "6500-7740","6540-7860" }, displayID = 59007, questID = { 55811 } }; --Rustfeather
	[152569] = { zoneID = 1462, artID = { 1276 }, x = 8245, y = 2093, overlay = { "8140-2180","8245-2093" }, displayID = 89858, questID = { 55812 } }; --Crazed Trogg
	[152570] = { zoneID = 1462, artID = { 1276 }, x = 8245, y = 2093, overlay = { "8140-2160","8245-2093" }, displayID = 89858, questID = { 55812 } }; --Crazed Trogg
	[152764] = { zoneID = 1462, artID = { 1276 }, x = 5752, y = 6072, overlay = { "5340-6040","5420-6160","5500-5700","5540-5940","5540-6060","5620-6200","5660-5940","5740-6040","5740-6360","5800-5900","5920-5940" }, displayID = 2028, questID = { 55856 } }; --Oxidized Leachbeast
	[152922] = { zoneID = 1462, artID = { 1276 }, x = 6311, y = 5648, overlay = { "6300-5640","6320-5760" }, displayID = 92480, questID = { 57387 } }; --Data Anomaly <Captain Kromcr>
	[152923] = { zoneID = 1462, artID = { 1276 }, x = 6279, y = 5702, overlay = { "6300-5640","6320-5760" }, displayID = 92478, questID = { 57385 } }; --Data Anomaly <Razorclaw the Butc>
	[152958] = { zoneID = 1462, artID = { 1276 }, x = 6340, y = 5760, overlay = { "6300-5640","6340-5760" }, displayID = 92477, questID = { 57385 } }; --Data Anomaly <Hog>
	[152961] = { zoneID = 1462, artID = { 1276 }, x = 6284, y = 5724, overlay = { "6300-5640","6340-5760" }, displayID = 92479, questID = { 57387 } }; --Data Anomaly <Balnaz>
	[152979] = { zoneID = 1462, artID = { 1276 }, x = 6300, y = 5700, overlay = { "6300-5620","6320-5760" }, displayID = 92481, questID = { 57388 } }; --Data Anomaly <Baron Ka>
	[152983] = { zoneID = 1462, artID = { 1276 }, x = 6320, y = 5760, overlay = { "6280-5640","6320-5760" }, displayID = 92482, questID = { 57388 } }; --Data Anomaly <Crowd Pummeler 9>
	[153000] = { zoneID = 1462, artID = { 1276 }, x = 8160, y = 2513, overlay = { "7840-3040","7940-2840","8040-2740","8140-2340","8140-2540","8160-2660","8220-2240","8340-2180" }, displayID = 73601, questID = { 55810 } }; --Sparkqueen P'Emp
	[153200] = { zoneID = 1462, artID = { 1276 }, x = 5058, y = 5108, overlay = { "5100-5060","5140-4940" }, displayID = 90423, questID = { 55857 } }; --Boilburn
	[153205] = { zoneID = 1462, artID = { 1276 }, x = 5959, y = 6720, overlay = { "5740-6940","5840-6840","5940-6740" }, displayID = 89818, questID = { 55855 } }; --Gemicide
	[153206] = { zoneID = 1462, artID = { 1276 }, x = 5660, y = 3559, overlay = { "5540-3540","5540-3940","5600-3680","5660-3540" }, displayID = 55680, questID = { 55853 } }; --Ol' Big Tusk <The Trogg Go>
	[153226] = { zoneID = 1462, artID = { 1276 }, x = 2545, y = 7737, overlay = { "2440-7720","2540-7640","2560-7780" }, displayID = 75702, questID = { 55854 } }; --Steel Singer Freza
	[153228] = { zoneID = 1462, artID = { 1276 }, x = 6700, y = 5480, overlay = { "2300-8140","4240-4940","5140-4940","5540-5920","5540-6060","5620-6180","5660-5920","5840-5140","5940-5260","5980-6700","6640-5480","6700-5340" }, displayID = 91932, questID = { 55852 } }; --Gear Checker Cogstar <Sentry Champ>
	[153486] = { zoneID = 1462, artID = { 1276 }, x = 6114, y = 6051, overlay = { "6300-5620","6114-6051" }, displayID = 92483, questID = { 57389 } }; --Data Anomaly <Baron Ged>
	[154153] = { zoneID = 1462, artID = { 1276 }, x = 5538, y = 5517, overlay = { "5500-5760","5540-5540","5540-5880","5580-6000","5660-5520" }, displayID = 90855, questID = { 56207 } }; --Enforcer KX-T57
	[154225] = { zoneID = 1462, artID = { 1276 }, x = 5687, y = 5889, overlay = { "5700-5860","5800-5740","5820-5900" }, displayID = 92038, questID = { 56182 } }; --The Rusty Prince
	[154342] = { zoneID = 1462, artID = { 1276 }, x = 5260, y = 4058, overlay = { "5220-4160","5240-3940","5360-4060" }, displayID = 73601, questID = { 55512 } }; --Arachnoid Harvester
	[154701] = { zoneID = 1462, artID = { 1276 }, x = 8000, y = 5440, overlay = { "6680-5820","7020-5560","7120-5300","7160-5440","7160-5660","7200-4940","7280-5560","7320-5420","7320-6000","7320-6160","7460-5400","7520-5560","7680-4720","7740-5460","8000-5440" }, displayID = 76384, questID = { 56367 } }; --Gorged Gear-Cruncher
	[154739] = { zoneID = 1462, artID = { 1276 }, x = 7360, y = 5480, overlay = { "6640-5880","7340-5420" }, displayID = 91906, questID = { 56368 } }; --Caustic Mechaslime <Devourer of Mechagno>
	[154968] = { zoneID = 1462, artID = { 1276 }, x = 5373, y = 4957, overlay = { "5340-4940" }, displayID = 90757, questID = { 55546 } }; --Armored Vaultbot
	[155583] = { zoneID = 1462, artID = { 1276 }, x = 8229, y = 7772, overlay = { "8140-7620","8220-7740" }, displayID = 91409, questID = { 56737 } }; --Scrapclaw
	[160708] = { zoneID = {
				[1469] = { x = 6780, y = 3920, artID = { 1319 }, overlay = { "3940-4840","3940-7940","3960-8220","4060-4780","4260-7480","4920-7860","5140-7660","5220-7540","5260-7720","5720-5200","5860-5560","5880-5140","5900-5280","6000-5100","6080-5220","6740-3940" } };
				[1470] = { x = 7640, y = 6480, artID = { 1340 }, overlay = { "4940-8640","5400-5540","5440-5720","5560-5700","5960-6980","6060-7280","6180-7540","6200-3040","6220-7380","6260-3240","6280-7260","6540-7600","7400-6220","7540-6320","7540-6440" } };
			  }, displayID = 92712 }; --null
	[156820] = { zoneID = 1470, artID = { 1340 }, x = 7599, y = 5368, overlay = { "7540-5340" }, displayID = 92784 }; --Dod <Drink Delive>
	[158284] = { zoneID = 1470, artID = { 1340 }, x = 6048, y = 6207, overlay = { "5620-6900","5640-6720","5640-7020","5680-7160","5700-6240","5740-6540","5740-7300","5780-7460","5820-6440","5900-6340","6040-6220","6140-6140","6280-6100","6440-6120","6540-6280","6620-6400","6740-6560","6760-6380" }, displayID = 37850 }; --Craggle Wobbletop <Toys and Novelt>
	[160341] = { zoneID = 1470, artID = { 1340 }, x = 6837, y = 5089, overlay = { "5480-5640","5620-6540","5900-6320","5940-6140","5960-5880","6000-6020","6040-4280","6100-5820","6100-6200","6120-4500","6120-5000","6120-6000","6140-5180","6180-5440","6200-5300","6200-5580","6220-6160","6260-5040","6280-5200","6280-5940","6320-4780","6340-6120","6360-4920","6420-6660","6440-5120","6440-6040","6460-5260","6500-6160","6520-6500","6540-6300","6600-5280","6640-5940","6640-6080","6680-5440","6680-5660","6680-5820","6680-6200","6700-5080","6720-6520","6760-5920","6760-6400","6800-5260","6820-6600","6840-4980","6840-6080","6860-6260","6880-5380","6920-6760","7020-6180" }, displayID = 74885 }; --Sewer Beastling
	[155779] = { zoneID = 1525, artID = { 1306 }, x = 4383, y = 7939, overlay = { "4300-7900" }, displayID = 94408, questID = { 56877 } }; --Tomb Burster <Dread Crawler Qu>
	[156916] = { zoneID = 1525, artID = { 1306 }, x = 6974, y = 4725, overlay = { "6940-4740" }, displayID = 93863 }; --Inquisitor Sorin
	[156918] = { zoneID = 1525, artID = { 1306 }, x = 6454, y = 4671, overlay = { "6460-4620" }, displayID = 93002 }; --Inquisitor Otilia
	[156919] = { zoneID = 1525, artID = { 1306 }, x = 6727, y = 4341, overlay = { "6720-4340" }, displayID = 93008 }; --Inquisitor Petre
	[159151] = { zoneID = 1525, artID = { 1306 }, x = 7591, y = 5162, overlay = { "7600-5180" }, displayID = 93863 }; --Inquisitor Traian
	[159152] = { zoneID = 1525, artID = { 1306 }, x = 7527, y = 4406, overlay = { "7500-4460" }, displayID = 93073 }; --High Inquisitor Gabi
	[159153] = { zoneID = 1525, artID = { 1306 }, x = 7218, y = 4249, overlay = { "7140-4220" }, displayID = 93054 }; --High Inquisitor Radu
	[159154] = { zoneID = 1525, artID = { 1306 }, x = 6977, y = 5225, overlay = { "6940-5180" }, displayID = 93847 }; --High Inquisitor Magda
	[159155] = { zoneID = 1525, artID = { 1306 }, x = 7224, y = 5305, overlay = { "7200-5300" }, displayID = 93864 }; --High Inquisitor Dacian
	[159156] = { zoneID = 1525, artID = { 1306 }, x = 6477, y = 5284, overlay = { "6440-5260" }, displayID = 93845 }; --Grand Inquisitor Nicu
	[159157] = { zoneID = 1525, artID = { 1306 }, x = 6937, y = 4469, overlay = { "6960-4440" }, displayID = 93844 }; --Grand Inquisitor Aurica
	[159496] = { zoneID = 1525, artID = { 1306 }, x = 3265, y = 1545, overlay = { "3240-1540" }, displayID = 98029, questID = { 61618 } }; --Forgemaster Madalav
	[159503] = { zoneID = 1525, artID = { 1306 }, x = 3132, y = 2325, overlay = { "3020-2360","3060-2240" }, displayID = 98018, questID = { 62220 } }; --Stonefist
	[160385] = { zoneID = 1525, artID = { 1306 }, x = 7893, y = 4974, overlay = { "7840-4960" }, displayID = 94233, questID = { 58130 } }; --Soulstalker Doina
	[160392] = { zoneID = 1525, artID = { 1306 }, x = 6503, y = 5597, overlay = { "6500-5620" }, displayID = 94233, questID = { 58130 } }; --Soulstalker Doina
	[160393] = { zoneID = 1525, artID = { 1306 }, x = 4877, y = 4795, overlay = { "4880-4840" }, displayID = 94233, questID = { 58130 } }; --Soulstalker Doina
	[160640] = { zoneID = 1525, artID = { 1306 }, x = 2139, y = 3615, overlay = { "2140-3600" }, displayID = 93068, questID = { 58210 } }; --Innervus
	[160675] = { zoneID = 1525, artID = { 1306 }, x = 3828, y = 6902, overlay = { "3800-6840" }, displayID = 94369, questID = { 58213 } }; --Scrivener Lenua
	[160821] = { zoneID = 1525, artID = { 1306 }, x = 3857, y = 7216, overlay = { "3880-7200" }, displayID = 94402, questID = { 58259 } }; --Worldedge Gorger
	[160857] = { zoneID = 1525, artID = { 1306 }, x = 3479, y = 6011, overlay = { "3400-5540" }, displayID = 94416, questID = { 58263 } }; --Sire Ladinas <The Lightra>
	[161310] = { zoneID = 1525, artID = { 1306 }, x = 4317, y = 5204, overlay = { "4180-5120","4240-4920","4340-5140","4380-4940" }, displayID = 94521, questID = { 58441 } }; --Executioner Adrastia
	[161891] = { zoneID = 1525, artID = { 1306 }, x = 7594, y = 6159, overlay = { "7580-6140" }, displayID = 94703, questID = { 58633 } }; --Lord Mortegore
	[162481] = { zoneID = 1525, artID = { 1306 }, x = 6745, y = 3043, overlay = { "6740-3040" }, displayID = 94868, questID = { 62252 } }; --Sinstone Hoarder
	[162503] = { zoneID = 1525, artID = { 1306 }, x = 6745, y = 3048, overlay = { "6745-3048" }, displayID = 94890, questID = { 62252 } }; --Catacombs Cache
	[164388] = { zoneID = 1525, artID = { 1306 }, x = 2531, y = 4851, overlay = { "2520-4860" }, displayID = 69223, questID = { 59584 } }; --Amalgamation of Light
	[165152] = { zoneID = 1525, artID = { 1306 }, x = 6797, y = 8179, overlay = { "6780-8180" }, displayID = 90426, questID = { 59580 } }; --Leeched Soul
	[165175] = { zoneID = 1525, artID = { 1306 }, x = 6777, y = 8201, overlay = { "6780-8200" }, displayID = 95669, questID = { 59580 } }; --Prideful Hulk
	[165206] = { zoneID = 1525, artID = { 1306 }, x = 6664, y = 5923, overlay = { "6640-5940" }, displayID = 93853, questID = { 59582 } }; --Endlurker
	[165253] = { zoneID = 1525, artID = { 1306 }, x = 6648, y = 7149, overlay = { "6640-7120" }, displayID = 93077, questID = { 59595 } }; --Tollkeeper Varaboss
	[165290] = { zoneID = 1525, artID = { 1306 }, x = 4520, y = 7821, overlay = { "4600-7840" }, displayID = 92703, questID = { 59612 } }; --Harika the Horrid
	[165980] = { zoneID = 1525, artID = { 1306 }, x = 6162, y = 7940, overlay = { "6160-7940" }, displayID = 97158, nameplate = true, questID = { 60022 } }; --Geza
	[165981] = { zoneID = 1525, artID = { 1306 }, x = 6184, y = 7942, overlay = { "6180-7840" }, displayID = 97157, nameplate = true, questID = { 60022 } }; --Reza
	[166292] = { zoneID = 1525, artID = { 1306 }, x = 3787, y = 3128, overlay = { "3280-3200","3340-3320","3460-3360","3520-3220","3580-3360","3640-3100","3680-3240","3760-2980","3787-3128" }, displayID = 96261, questID = { 59823 } }; --Bog Beast
	[166393] = { zoneID = 1525, artID = { 1306 }, x = 5325, y = 7300, overlay = { "5320-7280" }, displayID = 91695, questID = { 59854 } }; --Amalgamation of Filth
	[166521] = { zoneID = 1525, artID = { 1306 }, x = 6198, y = 4682, overlay = { "6240-4680" }, displayID = 94229, questID = { 59869 } }; --Famu the Infinite
	[166576] = { zoneID = 1525, artID = { 1306 }, x = 3580, y = 7056, overlay = { "3380-6860","3540-6840","3580-7020" }, displayID = 95209, questID = { 59893 } }; --Azgar
	[166679] = { zoneID = 1525, artID = { 1306 }, x = 5206, y = 5181, overlay = { "5140-5240" }, displayID = 95369, questID = { 59900 } }; --Hopecrusher
	[166682] = { zoneID = 1525, artID = { 1306 }, x = 5198, y = 5180, overlay = { "5180-5180" }, displayID = 92701, questID = { 59900 } }; --Large Prey
	[166710] = { zoneID = 1525, artID = { 1306 }, x = 3667, y = 4839, overlay = { "3700-4640","3720-4760" }, displayID = 94737, questID = { 59913 } }; --Executioner Aatron
	[166993] = { zoneID = 1525, artID = { 1306 }, x = 6170, y = 7950, overlay = { "6180-7840" }, displayID = 96391, questID = { 60022 } }; --Huntmaster Petrus
	[167464] = { zoneID = 1525, artID = { 1306 }, x = 2049, y = 5299, overlay = { "2040-5320" }, displayID = 96483, questID = { 60173 } }; --Grand Arcanist Dimitri
	[169253] = { zoneID = 1525, artID = { 1306 }, x = 4296, y = 7916, overlay = { "4296-7916" }, questID = { 56877 } }; --Spell Bunny
	[170048] = { zoneID = 1525, artID = { 1306 }, x = 4906, y = 3496, overlay = { "4900-3480" }, displayID = 95669, questID = { 60729 } }; --Manifestation of Wrath
	[170434] = { zoneID = 1525, artID = { 1306 }, x = 6592, y = 2923, overlay = { "6580-2900" }, displayID = 94868, questID = { 60836 } }; --Amalgamation of Sin
	[173468] = { zoneID = 1525, artID = { 1306 }, x = 6309, y = 4311, overlay = { "6320-4300" }, displayID = 98448, nameplate = true, questID = { 62050 } }; --Dead Blanchy
	[151609] = { zoneID = 1527, artID = { 1343 }, x = 7320, y = 7446, overlay = { "7340-7440" }, displayID = 34745, zoneQuestId = { 55350 }, questID = { 55353 } }; --Sun Prophet Epaphos
	[151852] = { zoneID = 1527, artID = { 1343 }, x = 8113, y = 5215, overlay = { "7740-5220","7940-5140","7940-5280","8060-5220" }, displayID = 91292, zoneQuestId = { 55350 }, questID = { 55461 } }; --Watcher Rehu
	[151878] = { zoneID = 1527, artID = { 1343 }, x = 7900, y = 6392, overlay = { "7900-6340" }, displayID = 91296, zoneQuestId = { 57157,55350,56308 }, questID = { 58613 } }; --Sun King Nahkotep
	[151883] = { zoneID = 1527, artID = { 1343 }, x = 7276, y = 5292, overlay = { "6860-5120","6860-5320","7040-5040","7040-5380","7240-5140","7340-5320","7360-5040","7380-5180" }, displayID = 81080, zoneQuestId = { 55350 }, questID = { 55468 } }; --Anaua
	[151897] = { zoneID = 1527, artID = { 1343 }, x = 8448, y = 5696, overlay = { "8440-5700" }, displayID = 92920, zoneQuestId = { 55350 }, questID = { 55479 } }; --Sun Priestess Nubitt
	[151948] = { zoneID = 1527, artID = { 1343 }, x = 7352, y = 6459, overlay = { "7340-6420" }, displayID = 37352, zoneQuestId = { 55350 }, questID = { 55496 } }; --Senbu the Pridefather
	[151995] = { zoneID = 1527, artID = { 1343 }, x = 7805, y = 4585, overlay = { "7740-4600","7860-4560","7980-4560","8040-4680" }, displayID = 91333, zoneQuestId = { 55350 }, questID = { 55502 } }; --Hik-ten the Taskmaster
	[152040] = { zoneID = 1527, artID = { 1343 }, x = 6971, y = 4218, overlay = { "6960-4140" }, displayID = 91321, zoneQuestId = { 55350 }, questID = { 55518 } }; --Scoutmaster Moswen
	[152431] = { zoneID = 1527, artID = { 1343 }, x = 7719, y = 5000, overlay = { "7720-5000" }, displayID = 34901, zoneQuestId = { 57157,55350,56308 }, questID = { 55629 } }; --Kaneb-ti
	[152657] = { zoneID = 1527, artID = { 1343 }, x = 6803, y = 3746, overlay = { "6440-3740","6500-3600","6500-3860","6620-3460","6620-3840","6720-3200","6740-3340","6740-3460","6740-3800","6780-3580" }, displayID = 4689, zoneQuestId = { 55350 }, questID = { 55682 } }; --Tat the Bonechewer
	[152677] = { zoneID = 1527, artID = { 1343 }, x = 6198, y = 2459, overlay = { "6200-2500" }, displayID = 91304, zoneQuestId = { 55350 }, questID = { 55684 } }; --Nebet the Ascended
	[152757] = { zoneID = 1527, artID = { 1343 }, x = 6486, y = 5147, overlay = { "6500-5120" }, displayID = 37539, zoneQuestId = { 55350 }, questID = { 55710 } }; --Atekhramun
	[152788] = { zoneID = 1527, artID = { 1343 }, x = 6760, y = 6380, overlay = { "6740-6340" }, displayID = 91589, zoneQuestId = { 55350 }, questID = { 55716 } }; --Uat-ka the Sun's Wrath
	[154576] = { zoneID = 1527, artID = { 1343 }, x = 3339, y = 6619, overlay = { "2640-5520","2680-5140","2680-5280","2800-5700","2820-5440","2840-6100","2880-5580","2880-5980","2900-5780","2920-6500","2960-6660","3020-6140","3020-6260","3120-6340","3140-6460","3140-6640","3140-6820","3240-6920","3320-4440","3320-5100","3320-5820","3320-6340","3320-6460","3340-5540","3340-6620","3360-5280","3380-4560","3380-5420","3400-1840","3440-1980","3440-5180","3480-6600","3500-4460","3540-5040","3620-4220","3620-4340","3640-5540","3680-5740","3700-4760","3700-5360","3740-4940","3740-5880","3800-2180","3840-2340","3840-4300","3840-4840","3920-2220","3940-3640","3960-2380","3980-3440","4020-4440","4040-3320","4040-4280","4100-4600","4140-4020","4160-4420","4260-4300","4340-6040","4420-5840","4700-5820" }, displayID = 90724, zoneQuestId = { 57157,55350,56308 }, questID = { 58614 } }; --Aqir Titanus
	[154578] = { zoneID = 1527, artID = { 1343 }, x = 3930, y = 4354, overlay = { "2980-6300","3200-6880","3220-1640","3220-6720","3240-6260","3260-1780","3340-6340","3360-1940","3400-6860","3480-1800","3540-2060","3540-2220","3600-1900","3700-2220","3720-4740","3720-4860","3740-4180","3760-2060","3800-4320","3800-4560","3920-4340","3920-4600","3940-3880","4000-4460","4020-2400","4020-4040","4060-2280","4080-3820","4080-4260","4100-4560","4120-2480","4140-4140","4260-5740","4300-5940","4480-6180","4560-5480" }, displayID = 91910, zoneQuestId = { 57157,56308,55350 }, questID = { 58612 } }; --Aqir Flayer
	[154604] = { zoneID = 1527, artID = { 1343 }, x = 3467, y = 1889, overlay = { "3440-1840" }, displayID = 90723, zoneQuestId = { 56308 }, questID = { 56340 } }; --Lord Aj'qirai
	[155531] = { zoneID = 1527, artID = { 1343 }, x = 2189, y = 6487, overlay = { "1720-6040","1720-6260","1740-5920","1800-6360","1800-6560","1860-6040","1900-6240","1920-6560","1940-6400","2000-6100","2020-5940","2020-6240","2080-6440","2120-5560","2120-5720","2200-6040","2220-5640","2220-6160","2220-6340","2220-6460","2320-5840","2320-6240","2360-5640","2420-6020","2420-6380","2440-5820","2440-6520","2460-6220","2560-6340","2620-6160" }, displayID = 22122, zoneQuestId = { 57157,55350,56308 }, questID = { 56823 } }; --Infested Wastewander Captain
	[155703] = { zoneID = 1527, artID = { 1343 }, x = 3150, y = 6326, overlay = { "3240-6440","3150-6326" }, displayID = 85193, zoneQuestId = { 57157,55350,56308 }, questID = { 56834 } }; --Anq'uri the Titanic
	[156078] = { zoneID = 1527, artID = { 1343 }, x = 3144, y = 6407, overlay = { "3040-6600","3120-6860","3140-6480","3220-6320","3260-6920","3340-6620" }, displayID = 93287, zoneQuestId = { 56308 }, questID = { 56952 } }; --Magus Rehleth
	[156299] = { zoneID = 1527, artID = { 1343 }, x = 5852, y = 7996, overlay = { "5020-5080","5040-4880","5140-5020","5160-5240","5220-4840","5320-4960","5320-5180","5340-4840","5420-5320","5440-5020","5440-5180","5460-4740","5540-5260","5560-4840","5560-4960","5580-5140","5640-5400","5680-5240","5740-5580","5740-5780","5740-7240","5740-7400","5740-7520","5740-7700","5740-7820","5760-5420","5800-5900","5800-6140","5800-8060","5820-6300","5820-6440","5820-7140","5820-8180","5840-6640","5840-6820","5840-7020","5860-5640","5860-7280","5860-7480","5860-7700","5860-7840","5960-6900" }, displayID = 84332, zoneQuestId = { 57157,56308 }, questID = { 57430 } }; --R'khuzj the Unfathomable
	[156654] = { zoneID = 1527, artID = { 1343 }, x = 5917, y = 8178, overlay = { "5840-8240" }, displayID = 84407, zoneQuestId = { 57157 }, questID = { 57432 } }; --Shol'thoss the Doomspeaker
	[156655] = { zoneID = 1527, artID = { 1343 }, x = 7123, y = 7373, overlay = { "7040-7460","7123-7373" }, displayID = 76647, zoneQuestId = { 57157 }, questID = { 57433 } }; --Korzaran the Slaughterer
	[157120] = { zoneID = 1527, artID = { 1343 }, x = 7494, y = 6824, overlay = { "7480-6820" }, displayID = 91321, zoneQuestId = { 56308,55350 }, questID = { 57258 } }; --Fangtaker Orsa
	[157134] = { zoneID = 1527, artID = { 1343 }, x = 7368, y = 8500, overlay = { "7380-8340","7368-8500" }, displayID = 62509, zoneQuestId = { 57157,55350,56308 }, questID = { 57259 } }; --Ishak of the Four Winds
	[157146] = { zoneID = 1527, artID = { 1343 }, x = 6823, y = 3167, overlay = { "6800-3140" }, displayID = 10824, zoneQuestId = { 55350 }, questID = { 57273 } }; --Rotfeaster
	[157157] = { zoneID = 1527, artID = { 1343 }, x = 6687, y = 2023, overlay = { "6640-1940","6640-2080" }, displayID = 91298, zoneQuestId = { 55350 }, questID = { 57277 } }; --Muminah the Incandescent
	[157164] = { zoneID = 1527, artID = { 1343 }, x = 8015, y = 5707, overlay = { "8000-5720" }, displayID = 91321, zoneQuestId = { 55350 }, questID = { 57279 } }; --Zealot Tekem <Greatest of Fi>
	[157167] = { zoneID = 1527, artID = { 1343 }, x = 7541, y = 5221, overlay = { "7520-5140","7540-5260" }, displayID = 91322, zoneQuestId = { 56308,55350 }, questID = { 57280 } }; --Champion Sen-mat
	[157170] = { zoneID = 1527, artID = { 1343 }, x = 6450, y = 2563, overlay = { "6440-2580" }, displayID = 34738, zoneQuestId = { 55350 }, questID = { 57281 } }; --Acolyte Taspu
	[157188] = { zoneID = 1527, artID = { 1343 }, x = 8459, y = 4700, overlay = { "8420-4720" }, displayID = 85021, zoneQuestId = { 55350 }, questID = { 57285 } }; --The Tomb Widow
	[157390] = { zoneID = 1527, artID = { 1343 }, x = 5057, y = 8831, overlay = { "5000-7840","5040-8740","5520-7920" }, displayID = 92720, zoneQuestId = { 57157 }, questID = { 57434 } }; --R'oyolok the Reality Eater
	[157469] = { zoneID = 1527, artID = { 1343 }, x = 5520, y = 7931, overlay = { "5000-7840","5040-8740","5480-7960" }, displayID = 32501, zoneQuestId = { 57157 }, questID = { 57435 } }; --Zoth'rum the Intellect Pillager
	[157470] = { zoneID = 1527, artID = { 1343 }, x = 5500, y = 7940, overlay = { "5000-7840","5040-8740","5460-7960" }, displayID = 92716, zoneQuestId = { 57157 }, questID = { 57436 } }; --R'aas the Anima Devourer
	[157472] = { zoneID = 1527, artID = { 1343 }, x = 5520, y = 7920, overlay = { "5000-7840","5040-8740","5460-7960" }, displayID = 93173, zoneQuestId = { 57157 }, questID = { 57437 } }; --Aphrom the Guise of Madness
	[157473] = { zoneID = 1527, artID = { 1343 }, x = 5000, y = 7867, overlay = { "5000-7840","5040-8800","5520-7920" }, displayID = 88850, zoneQuestId = { 57157 }, questID = { 57438 } }; --Yiphrim the Will Ravager
	[157476] = { zoneID = 1527, artID = { 1343 }, x = 5520, y = 7931, overlay = { "5000-7840","5040-8740","5440-7960" }, displayID = 92610, zoneQuestId = { 57157 }, questID = { 57439 } }; --Shugshul the Flesh Gorger
	[157593] = { zoneID = 1527, artID = { 1343 }, x = 5989, y = 7241, overlay = { "5980-7220" }, displayID = 92609, zoneQuestId = { 57157 }, questID = { 57667 } }; --Amalgamation of Flesh
	[158491] = { zoneID = 1527, artID = { 1343 }, x = 4509, y = 7742, overlay = { "4440-7820","4540-7640","4640-7280","4640-7420","4760-7340","4900-7140","4980-6960","5120-6900","5300-6820","5320-7040" }, displayID = 92662, zoneQuestId = { 57157 }, questID = { 57662 } }; --Falconer Amenophis
	[158528] = { zoneID = 1527, artID = { 1343 }, x = 4708, y = 7766, overlay = { "4740-7720" }, displayID = 91296, zoneQuestId = { 57157 }, questID = { 57664 } }; --High Guard Reshef
	[158531] = { zoneID = 1527, artID = { 1343 }, x = 5100, y = 7140, overlay = { "4740-7820","4740-8040","4980-8260","5000-7860","5000-8140","5040-7460","5040-8520","5060-7720","5060-8360","5080-7320","5100-7140" }, displayID = 34807, zoneQuestId = { 57157 }, questID = { 57665 } }; --Corrupted Neferset Guard
	[158557] = { zoneID = 1527, artID = { 1343 }, x = 6679, y = 7434, overlay = { "6640-7380" }, displayID = 88705, zoneQuestId = { 57157 }, questID = { 57669 } }; --Actiss the Deceiver
	[158594] = { zoneID = 1527, artID = { 1343 }, x = 4936, y = 3822, overlay = { "4940-3840" }, displayID = 92752, zoneQuestId = { 57157 }, questID = { 57672 } }; --Doomsayer Vathiris
	[158595] = { zoneID = 1527, artID = { 1343 }, x = 5986, y = 4934, overlay = { "5940-4980" }, displayID = 89291, zoneQuestId = { 57157 }, questID = { 57673 } }; --Thoughtstealer Vos
	[158597] = { zoneID = 1527, artID = { 1343 }, x = 5468, y = 4316, overlay = { "5460-4320" }, displayID = 93552, zoneQuestId = { 57157 }, questID = { 57675 } }; --High Executor Yothrim
	[158632] = { zoneID = {
				[1527] = { x = 7180, y = 7700, artID = { 1343 }, overlay = { "4320-2840","4440-2840","4460-3040","4520-2660","4600-3920","4620-3460","4620-4300","4640-2940","4640-3160","4640-3320","4640-3580","4640-4080","4640-4500","4680-3800","4720-2800","4720-3980","4740-3080","4760-4420","4780-3380","4780-4140","4800-4300","4820-2700","4820-3520","4820-4540","4840-3200","4860-3660","4940-4100","4960-2740","4980-3540","5000-3060","5000-4260","5000-4400","5020-2940","5020-4600","5060-4760","5100-4500","5120-3040","5120-5180","5140-3200","5140-4900","5160-4640","5180-5060","5220-3400","5260-3060","5320-5040","5340-3180","5340-4800","5340-5160","5380-3420","5440-2280","5440-4640","5440-4920","5440-5260","5520-2460","5520-5140","5540-2040","5540-2640","5540-2820","5540-2980","5540-3140","5540-3420","5540-4840","5560-2240","5600-5340","5620-1880","5620-5460","5640-3340","5660-1740","5660-2780","5660-3460","5680-2960","5680-5220","5700-3140","5700-5100","5720-2120","5720-4440","5720-5360","5720-5680","5720-7300","5720-8040","5740-2260","5740-4560","5740-7880","5740-8380","5760-1340","5760-7600","5780-8540","5800-1980","5800-2500","5800-5480","5800-5800","5800-6120","5800-6500","5800-6860","5820-2640","5820-5960","5820-7180","5820-7440","5820-8160","5840-1840","5840-4080","5840-4720","5840-4940","5840-5620","5840-6680","5840-7000","5860-4280","5860-7820","5860-7960","5860-8440","5880-4400","5880-5140","5880-7680","5880-8280","5900-1700","5900-6340","5920-2180","5920-2960","5920-3580","5940-3200","5940-3360","5940-3940","5940-4520","5940-4860","5940-5320","5940-8140","5960-2680","5980-4740","5980-5060","5980-5440","6000-8260","6020-3780","6020-4140","6020-7820","6040-3000","6040-3500","6040-4260","6040-5640","6040-5840","6060-3300","6060-3640","6060-4940","6060-5260","6060-6040","6060-7980","6060-8540","6080-3940","6100-7680","6120-1520","6140-4120","6140-8320","6160-3480","6160-7800","6180-3720","6180-8000","6200-3840","6240-3980","6280-8160","6300-4160","6320-7740","6340-6440","6400-8000","6420-6620","6420-7660","6500-6900","6500-7780","6500-7920","6540-6640","6540-6780","6560-7380","6580-7560","6620-6980","6620-7840","6640-7280","6700-7580","6720-7740","6740-6920","6740-7080","6760-7320","6780-7480","6800-7840","6860-7060","6860-7180","6900-7620","6960-7300","7020-7680","7040-7540","7040-7840","7060-7400","7160-7620" } };
				[1530] = { x = 8720, y = 4320, artID = { 1342 }, overlay = { "4000-3940","4100-4560","4120-3920","4200-4120","4240-4280","4320-3780","4340-4200","4340-4640","4360-4000","4360-4480","4420-3880","4440-4780","4520-3680","4520-4300","4540-4060","4540-4180","4540-4620","4580-3820","4660-4160","4700-4000","4760-3640","4760-4660","4940-3780","5340-4320","5360-3900","5440-4080","5540-4220","5580-4040","5660-5960","5680-4380","5700-4180","5720-3100","5720-5800","5760-2720","5760-5680","5780-4300","5820-4080","5840-5980","5880-6160","5900-3180","5900-5780","5960-3580","5960-6000","5980-2780","5980-6240","6000-3260","6000-5640","6020-2980","6020-4280","6040-3120","6040-3420","6040-5900","6080-3620","6080-5440","6120-4380","6140-5600","6160-6020","6180-2820","6180-3120","6180-3420","6220-5720","6260-5920","6320-3580","6360-2820","6380-5740","6400-3440","6420-6120","6440-4420","6440-4940","6440-5140","6480-5480","6500-2860","6500-4540","6520-2260","6520-5300","6540-2600","6540-3320","6540-4660","6560-5620","6580-3960","6580-4840","6600-4440","6640-2260","6640-3240","6640-3500","6640-5420","6660-2560","6660-2780","6680-3760","6700-2940","6720-3060","6720-4780","6720-5300","6740-2340","6740-4640","6760-3600","6780-3240","6780-3480","6780-4460","6820-2500","6820-2920","6840-2620","6860-2740","6860-3040","6880-4200","6900-2140","6900-4420","6920-2360","6920-3260","6920-4620","6920-4760","6960-2480","6980-2860","6980-3080","7000-2700","7060-4800","7120-2760","7140-2560","7180-4660","7300-2740","7400-2860","7620-5120","7640-4980","7720-4520","7780-4700","7800-5040","7800-5340","7840-4500","7900-4680","7920-4360","7920-4820","7920-5020","7920-5160","7920-5280","7940-5440","8000-4540","8040-4240","8040-4360","8040-4700","8040-4820","8080-5520","8100-5200","8120-5040","8120-5320","8140-4440","8160-4640","8180-4820","8260-5060","8280-4480","8280-5220","8300-4640","8340-4760","8340-4960","8400-4480","8400-5160","8420-4860","8480-4680","8540-5080","8720-4320" } };
			  }, displayID = 92232, questID = { 58691 } }; --Corrupted Fleshbeast
	[158633] = { zoneID = 1527, artID = { 1343 }, x = 5464, y = 5045, overlay = { "5320-5020","5420-5140","5440-5020","5500-5300","5540-5160","5560-5040","5580-5420" }, displayID = 90719, zoneQuestId = { 57157 }, questID = { 57680 } }; --Gaze of N'Zoth
	[158636] = { zoneID = 1527, artID = { 1343 }, x = 4932, y = 8234, overlay = { "4920-8260" }, displayID = 93573, zoneQuestId = { 57157 }, questID = { 57688 } }; --The Grand Executor
	[159087] = { zoneID = {
				[1527] = { x = 8540, y = 5940, artID = { 1343 }, overlay = { "1320-6920","1780-6720","3100-7300","3200-7520","3680-8140","3980-2680","4000-1780","4120-2100","4180-2660","4220-2440","4300-2620","4500-2780","4640-2860","4900-3180","5020-3320","5100-3440","5200-3720","5220-3900","5220-4340","5280-4120","5280-9020","5440-4440","5520-3940","5560-4400","5580-3820","5620-2520","5640-3940","5640-4920","5660-2380","5660-4060","5660-4600","5680-2080","5720-1700","5720-3560","5740-2740","5740-3700","5840-1460","5840-3160","5840-5260","5860-3480","5880-3020","5900-5460","5920-5640","5940-5800","5940-6000","5940-6820","5940-7800","5960-6360","5960-7500","5980-1420","6020-8100","6040-8340","6100-6260","6100-8940","6180-8140","6260-7320","6280-6620","6280-7500","6360-7640","6380-6740","6380-7760","6420-7060","6440-6920","6460-7340","6520-9020","7480-7980","8420-5540","8540-5940","8660-4900" } };
				[1530] = { x = 9160, y = 4580, artID = { 1342 }, overlay = { "6220-4840","6220-4980","6220-5240","6300-5080","6320-5380","6340-4880","6340-5200","6440-5320","6460-5180","7000-3880","7040-4100","7060-3020","7100-2680","7100-2860","7100-4440","7120-3500","7140-4180","7160-3680","7180-5680","7200-5520","7220-2800","7220-4320","7220-4540","7240-2480","7240-2660","7260-3600","7280-2980","7360-5540","7360-5820","7380-2760","7380-3060","7420-4360","7440-2900","7480-5860","7520-3460","7520-5680","7620-5400","7680-5760","7700-5520","7700-5980","7740-3960","7740-4120","7780-5880","7800-5660","7820-3820","7820-5500","7860-3940","8100-4260","8220-4400","8220-4520","8240-4200","8540-4460","8560-4340","8680-4340","8680-4620","8800-4300","8800-4540","8920-4480","8940-4640","8940-4760","9040-4540","9060-4660","9080-4820","9160-4580" } };
			  }, displayID = 91925, questID = { 57834 } }; --Corrupted Bonestripper
	[160532] = { zoneID = 1527, artID = { 1343 }, x = 6128, y = 7486, overlay = { "6080-7440" }, displayID = 93954, zoneQuestId = { 57157,56308 }, questID = { 58169 } }; --Shoth the Darkened
	[160623] = { zoneID = 1527, artID = { 1343 }, x = 6003, y = 3952, overlay = { "5940-3940" }, displayID = 92231, zoneQuestId = { 57157 }, questID = { 58206 } }; --Hungering Miasma
	[160631] = { zoneID = 1527, artID = { 1343 }, x = 6003, y = 3916, overlay = { "6000-3940" }, displayID = 94300, zoneQuestId = { 55350 } }; --Hungering Miasma
	[160970] = { zoneID = 1527, artID = { 1343 }, x = 4664, y = 1835, overlay = { "4540-1620","4664-1835" }, displayID = 85193, weeklyReset = true, questID = { 58510 } }; --Vuk'laz the Earthbreaker
	[161033] = { zoneID = 1527, artID = { 1343 }, x = 5706, y = 3884, overlay = { "5240-3740","5240-4240","5280-4360","5620-4000","5740-3540","5780-3660","5706-3884" }, displayID = 91925, zoneQuestId = { 57157 }, questID = { 58333 } }; --Shadowmaw
	[162140] = { zoneID = 1527, artID = { 1343 }, x = 2354, y = 6232, overlay = { "2340-6220" }, displayID = 91809, zoneQuestId = { 56308 }, questID = { 58697 } }; --Skikx'traz
	[162141] = { zoneID = 1527, artID = { 1343 }, x = 4102, y = 4215, overlay = { "4040-4300" }, displayID = 91910, zoneQuestId = { 56308 }, questID = { 58695 } }; --Zuythiz
	[162142] = { zoneID = 1527, artID = { 1343 }, x = 3798, y = 6010, overlay = { "3720-5940","3740-6060" }, displayID = 92904, zoneQuestId = { 56308 }, questID = { 58693 } }; --Qho
	[162147] = { zoneID = 1527, artID = { 1343 }, x = 3080, y = 4974, overlay = { "3080-4940" }, displayID = 91811, zoneQuestId = { 56308 }, questID = { 58696 } }; --Corpse Eater
	[162163] = { zoneID = 1527, artID = { 1343 }, x = 4780, y = 6020, overlay = { "4240-5620","4240-5740","4240-5860","4340-6040","4360-5500","4360-5780","4360-5920","4380-5660","4420-6160","4500-5600","4520-5940","4520-6080","4540-5460","4540-5820","4620-5660","4640-5540","4660-5900","4660-6060","4760-5640","4760-5820","4780-6020" }, displayID = 92755, zoneQuestId = { 56308 }, questID = { 58701 } }; --High Priest Ytaessis
	[162170] = { zoneID = 1527, artID = { 1343 }, x = 3364, y = 2629, overlay = { "3340-2540" }, displayID = 93286, zoneQuestId = { 56308 }, questID = { 58702 } }; --Warcaster Xeshro
	[162171] = { zoneID = 1527, artID = { 1343 }, x = 4559, y = 5776, overlay = { "4540-5740" }, displayID = 22125, zoneQuestId = { 56308 }, questID = { 58699 } }; --Captain Dunewalker
	[162172] = { zoneID = 1527, artID = { 1343 }, x = 4006, y = 4426, overlay = { "2140-6440","2200-6260","2300-6340","2340-5940","2480-6360","2960-6400","3020-5120","3020-6540","3040-6720","3160-6680","3200-2980","3200-3140","3200-6080","3200-6320","3260-6500","3320-2000","3360-6820","3380-6340","3400-2680","3420-1740","3440-3120","3500-1600","3520-1820","3560-3140","3680-4700","3700-1400","3820-4540","3940-3880","3960-4580","3980-3760","3980-4060","4000-4460","4020-3640","4040-4300","4100-4140","4140-4000","4180-3800","4180-4240","4240-4100","4300-3740","4580-5960","4660-5720","4720-5860" }, displayID = 91909, zoneQuestId = { 57157,55350,56308 }, questID = { 58694 } }; --Aqir Warcaster
	[162173] = { zoneID = 1527, artID = { 1343 }, x = 2945, y = 1976, overlay = { "2460-0720","2540-0900","2580-0540","2620-1140","2720-0580","2780-0720","2840-0900","2840-1320","2840-1540","2920-1820","2940-1960","2980-2360","3000-0900","3020-2720","3020-3340","3040-2900","3040-3040","3040-3160","3140-1000","3280-1060","3540-1080","3740-1000" }, displayID = 90724, zoneQuestId = { 56308 }, questID = { 58864 } }; --R'krox the Runt
	[162196] = { zoneID = 1527, artID = { 1343 }, x = 3505, y = 1729, overlay = { "3500-1720" }, displayID = 92907, zoneQuestId = { 57157,55350,56308 }, questID = { 58681 } }; --Obsidian Annihilator
	[162352] = { zoneID = 1527, artID = { 1343 }, x = 4992, y = 4011, overlay = { "5000-4000" }, displayID = 35691, zoneQuestId = { 55350,56308 }, questID = { 58716 } }; --Spirit of Dark Ritualist Zakahn
	[162370] = { zoneID = 1527, artID = { 1343 }, x = 4520, y = 4168, overlay = { "4380-4140","4420-4460","4440-4260","4460-4040","4560-4180" }, displayID = 37353, zoneQuestId = { 55350,56308 }, questID = { 58718 } }; --Armagedillo
	[162372] = { zoneID = 1527, artID = { 1343 }, x = 7100, y = 7420, overlay = { "5800-6160","5800-8240","6640-6800","7080-7460" }, displayID = 36707, zoneQuestId = { 55350,56308 }, questID = { 58715 } }; --Spirit of Cyrus the Black
	[154087] = { zoneID = 1530, artID = { 1342 }, x = 7094, y = 4055, overlay = { "6940-4140","7040-4040","7060-4160","7160-4080" }, displayID = 91352, zoneQuestId = { 56064 }, questID = { 56084 } }; --Zror'um the Infinite
	[154106] = { zoneID = 1530, artID = { 1342 }, x = 9020, y = 4600, overlay = { "8900-4760","8940-4640" }, displayID = 51214, zoneQuestId = { 56064 }, questID = { 56094 } }; --Quid <Spirit of the Darkened Fa>
	[154332] = { zoneID = 1530, artID = { 1342 }, x = 6674, y = 2814, overlay = { "6300-2800","6440-2860","6520-2720","6540-3020","6560-2540","6560-2880","6640-3160","6660-2720","6700-2540","6720-3000","6760-2840","6760-3200","6880-2520","6880-2660","6900-2800","6940-3120","6960-3000","7020-2760" }, displayID = 92065, zoneQuestId = { 56064 }, questID = { 56183 } }; --Voidtender Malketh
	[154394] = { zoneID = 1530, artID = { 1342 }, x = 8667, y = 4167, overlay = { "8540-4120","8640-4260","8660-4140" }, displayID = 94601, zoneQuestId = { 56064 }, questID = { 56213 } }; --Veskan the Fallen <Clearscale Chieft>
	[154447] = { zoneID = 1530, artID = { 1342 }, x = 5710, y = 4095, overlay = { "5640-4120","5760-4100" }, displayID = 88700, zoneQuestId = { 56064 }, questID = { 56237 } }; --Brother Meller
	[154467] = { zoneID = 1530, artID = { 1342 }, x = 8015, y = 5970, overlay = { "8040-6360","8015-5970" }, displayID = 41335, zoneQuestId = { 56064 }, questID = { 56255 } }; --Chief Mek-mek
	[154490] = { zoneID = 1530, artID = { 1342 }, x = 6417, y = 5173, overlay = { "6440-5140" }, displayID = 91869, zoneQuestId = { 56064 }, questID = { 56302 } }; --Rijz'x the Devourer
	[154495] = { zoneID = 1530, artID = { 1342 }, x = 5262, y = 6211, overlay = { "5240-6140","5240-6260","5360-6260" }, displayID = 66204, zoneQuestId = { 56064 }, questID = { 56303 } }; --Will of N'Zoth
	[154559] = { zoneID = 1530, artID = { 1342 }, x = 6656, y = 6795, overlay = { "6500-6700","6540-6840","6620-6640","6620-6960","6700-6780","6740-6960","6780-6640","6860-6760","6860-6880" }, displayID = 90740, zoneQuestId = { 56064 }, questID = { 56323 } }; --Deeplord Zrihj
	[154600] = { zoneID = 1530, artID = { 1342 }, x = 4746, y = 6373, overlay = { "4740-6420" }, displayID = 44005, zoneQuestId = { 57008 }, questID = { 56332 } }; --Teng the Awakened
	[155958] = { zoneID = 1530, artID = { 1342 }, x = 2935, y = 2225, overlay = { "2940-2220","3060-2260" }, displayID = 94569, zoneQuestId = { 57008 }, questID = { 58507 } }; --Tashara
	[156083] = { zoneID = 1530, artID = { 1342 }, x = 4640, y = 5711, overlay = { "4540-5680","4640-5540","4640-5780","4760-5600" }, displayID = 38186, zoneQuestId = { 57008 }, questID = { 56954 } }; --Sanguifang
	[157153] = { zoneID = 1530, artID = { 1342 }, x = 3189, y = 3634, overlay = { "3040-4100","3140-4180","3140-4340","3160-4040","3280-4140","3580-3280","3620-3540","3680-3360","3189-3634" }, displayID = 58718, zoneQuestId = { 57008 }, questID = { 57344 } }; --Ha-Li
	[157160] = { zoneID = 1530, artID = { 1342 }, x = 1310, y = 2595, overlay = { "0880-3560","0940-3100","0940-3440","1020-3340","1040-3200","1140-3040","1160-3160","1240-2640","1240-2840","1360-2840" }, displayID = 92869, zoneQuestId = { 57008 }, questID = { 57345 } }; --Houndlord Ren
	[157162] = { zoneID = 1530, artID = { 1342 }, x = 2079, y = 1245, overlay = { "2140-1240","2140-1360" }, displayID = 40795, zoneQuestId = { 57008 }, questID = { 57346 } }; --Rei Lun <Chalcedony Constr>
	[157171] = { zoneID = 1530, artID = { 1342 }, x = 2822, y = 4047, overlay = { "2840-4020" }, displayID = 86357, zoneQuestId = { 57008 }, questID = { 57347 } }; --Heixi the Stonelord
	[157176] = { zoneID = 1530, artID = { 1342 }, x = 5201, y = 4173, overlay = { "5200-4120","5200-4260" }, displayID = 92929, zoneQuestId = { 56064 }, questID = { 57342 } }; --The Forgotten
	[157183] = { zoneID = 1530, artID = { 1342 }, x = 2076, y = 6176, overlay = { "1640-6760","1700-6640","1940-6340","1940-7240","1940-7360","2000-6460","2040-6220","2120-6380" }, displayID = 47926, zoneQuestId = { 57008 }, questID = { 58296 } }; --Coagulated Anima
	[157266] = { zoneID = 1530, artID = { 1342 }, x = 5029, y = 6303, overlay = { "4460-6320","4500-6140","4520-5900","4640-7020","4800-5840","4840-6000","4840-6840","4940-6140","4940-6280","4940-6620","4960-6780","5040-6400","5060-6560" }, displayID = 92710, zoneQuestId = { 56064 }, questID = { 57341 } }; --Kilxl the Gaping Maw
	[157267] = { zoneID = 1530, artID = { 1342 }, x = 4465, y = 4586, overlay = { "4400-4420","4420-4060","4420-4660","4440-4540","4500-3940","4520-4440","4520-4760","4540-4080","4540-4200","4560-4640","4600-3820","4620-4360" }, displayID = 92609, zoneQuestId = { 56064 }, questID = { 57343 } }; --Escaped Mutation
	[157279] = { zoneID = 1530, artID = { 1342 }, x = 2513, y = 7606, overlay = { "2340-7640","2340-7760","2500-7620","2640-7340","2640-7460","2720-7140","2760-7360" }, displayID = 44449, zoneQuestId = { 57008 }, questID = { 57348 } }; --Stormhowl <Thundermaw Al>
	[157287] = { zoneID = 1530, artID = { 1342 }, x = 4391, y = 5497, overlay = { "3640-6040","3700-5840","3700-6160","3740-5960","3780-6300","3800-5640","3820-5520","3820-6080","3900-5720","3900-6280","3920-5940","3940-6060","3940-6460","3940-6700","4000-5480","4020-5640","4040-6160","4040-6280","4040-6560","4060-5220","4060-5860","4140-5520","4140-5720","4140-6020","4200-6200","4220-5620","4240-5320","4240-6440","4260-5940","4280-5760","4300-5500","4340-5240","4400-4900","4440-5120","4460-5460","4500-5000","4500-5320","4560-5200","4580-5460","4640-5020","4640-5600","4640-5720","4680-5320","4740-5200" }, displayID = 47527, zoneQuestId = { 57008 }, questID = { 57349 } }; --Dokani Obliterator
	[157290] = { zoneID = 1530, artID = { 1342 }, x = 2669, y = 1062, overlay = { "2640-1040","2700-1160" }, displayID = 45362, zoneQuestId = { 57008 }, questID = { 57350 } }; --Jade Watcher
	[157291] = { zoneID = 1530, artID = { 1342 }, x = 1751, y = 3618, overlay = { "1720-3860","1740-3740","1860-3740","1751-3618" }, displayID = 95242, zoneQuestId = { 57008 }, questID = { 57351 } }; --Spymaster Hul'ach
	[157443] = { zoneID = 1530, artID = { 1342 }, x = 5380, y = 4886, overlay = { "5320-4960" }, displayID = 41987, zoneQuestId = { 57008 }, questID = { 57358 } }; --Xiln the Mountain
	[157466] = { zoneID = 1530, artID = { 1342 }, x = 3413, y = 6858, overlay = { "3340-6740","3440-6860","3460-6740" }, displayID = 45835, zoneQuestId = { 57008 }, questID = { 57363 } }; --Anh-De the Loyal
	[157468] = { zoneID = 1530, artID = { 1342 }, x = 1070, y = 6749, overlay = { "0940-6740","1070-6749" }, displayID = 53161, zoneQuestId = { 56064,57728,57008 }, questID = { 57364 } }; --Tisiphon
	[160810] = { zoneID = 1530, artID = { 1342 }, x = 2911, y = 5171, overlay = { "2820-5260","2920-5140","2960-5320" }, displayID = 93279, zoneQuestId = { 57728 }, questID = { 58299 } }; --Harbinger Il'koxik
	[160825] = { zoneID = 1530, artID = { 1342 }, x = 1993, y = 7420, overlay = { "1940-7340" }, displayID = 93289, zoneQuestId = { 57728 }, questID = { 58300 } }; --Amber-Shaper Esh'ri
	[160826] = { zoneID = 1530, artID = { 1342 }, x = 2076, y = 6241, overlay = { "2020-6140","2100-6300","2120-6460" }, displayID = 93295, zoneQuestId = { 57728 }, questID = { 58301 } }; --Hive-Guard Naz'ruzek
	[160867] = { zoneID = 1530, artID = { 1342 }, x = 2851, y = 3761, overlay = { "1980-3700","2040-3960","2040-4080","2080-3840","2140-3600","2160-4000","2200-3840","2220-4420","2240-4220","2320-3520","2320-3640","2320-4100","2340-3780","2340-3960","2340-4420","2380-3340","2420-4260","2460-4660","2480-4120","2500-3420","2500-3940","2500-4380","2520-3660","2520-3800","2520-4500","2600-4060","2600-4220","2640-3540","2640-3920","2640-4440","2660-4660","2700-4800","2720-4120","2740-3320","2740-3740","2740-4000","2740-4240","2760-3440","2780-4360","2800-4480","2840-4640","2860-3540","2860-4020","2880-3340","2880-3680","2900-4400","2920-4240","2920-4520","2980-3580","2980-3780","3000-3440","3100-3920","3120-3740" }, displayID = 43351, zoneQuestId = { 57728 }, questID = { 58302 } }; --Kzit'kovok
	[160868] = { zoneID = 1530, artID = { 1342 }, x = 1283, y = 5130, overlay = { "1300-5140" }, displayID = 93282, zoneQuestId = { 57728 }, questID = { 58303 } }; --Harrier Nir'verash
	[160872] = { zoneID = 1530, artID = { 1342 }, x = 2562, y = 6709, overlay = { "0920-3180","0980-3380","1020-2900","1040-3120","1080-3480","1100-3940","1140-2860","1140-3200","1180-2700","1200-3020","1200-3380","1220-3580","1220-3820","1220-4080","1260-3160","1300-2740","1320-3480","1340-2960","1340-3740","1340-4020","1380-3340","1400-2820","1400-3220","1420-3840","1440-3600","1480-4000","1500-3720","1560-3600","1560-3860","1620-4080","1640-3440","1640-3960","1660-3720","1700-3560","1740-4620","1760-3340","1780-4100","1820-3860","1820-4880","1840-3740","1840-4500","1860-3500","1900-4040","1920-4240","1940-4360","1980-4900","2000-5080","2020-4480","2020-4680","2040-4120","2060-4800","2100-4340","2140-3940","2160-4100","2160-4460","2200-4640","2200-6580","2240-4960","2260-4380","2300-3960","2300-4500","2300-6780","2320-6520","2340-6400","2380-4060","2380-6680","2420-4640","2420-6280","2440-6480","2440-6940","2460-4440","2460-4760","2520-6180","2520-6620","2540-6320","2540-6780","2540-7140","2560-6440","2620-6960","2660-6520","2660-6720","2720-6380","2720-6860","2780-6640" }, displayID = 43654, zoneQuestId = { 57728 }, questID = { 58304 } }; --Destroyer Krox'tazar
	[160874] = { zoneID = 1530, artID = { 1342 }, x = 1257, y = 4105, overlay = { "1040-4040","1080-3840","1160-3940","1200-4060","1280-4160" }, displayID = 93271, zoneQuestId = { 57728 }, questID = { 58305 } }; --Drone Keeper Ak'thet
	[160876] = { zoneID = 1530, artID = { 1342 }, x = 1127, y = 4053, overlay = { "0980-3860","1040-4020","1100-3840","1160-4040","1160-4160" }, displayID = 35371, zoneQuestId = { 57728 }, questID = { 58306 } }; --Enraged Amber Elemental
	[160878] = { zoneID = 1530, artID = { 1342 }, x = 0658, y = 7121, overlay = { "0640-6840","0640-7020","0640-7160","0760-7060","0940-7060" }, displayID = 93300, zoneQuestId = { 57728 }, questID = { 58307 } }; --Buh'gzaki the Blasphemous
	[160893] = { zoneID = 1530, artID = { 1342 }, x = 0398, y = 5379, overlay = { "0240-5240","0300-6040","0320-4840","0340-4960","0340-6460","0400-4740","0400-5140","0400-5260","0400-5540","0400-5720","0400-5940","0400-6220","0440-4860","0460-6060","0460-6340","0520-6460","0560-5240","0580-6040","0600-4880","0600-7080","0640-4140","0640-4280","0640-4400","0640-4520","0640-4720","0640-6540","0640-6680","0640-6940","0660-6420","0660-6800","0720-7100","0880-7060" }, displayID = 93295, zoneQuestId = { 57728 }, questID = { 58308 } }; --Captain Vor'lek
	[160906] = { zoneID = 1530, artID = { 1342 }, x = 2960, y = 4759, overlay = { "2220-4720","2220-4840","2260-4460","2320-4600","2340-4820","2420-4340","2420-4480","2440-4640","2460-4880","2520-5140","2540-4520","2580-4020","2580-4800","2580-5000","2640-4140","2640-4320","2660-4900","2660-5180","2680-4500","2720-4640","2740-3940","2760-4400","2780-4280","2780-4840","2860-4620","2960-4700","3000-4220" }, displayID = 80032, zoneQuestId = { 57728 }, questID = { 58309 } }; --Skiver
	[160920] = { zoneID = 1530, artID = { 1342 }, x = 1783, y = 0907, overlay = { "1740-0920","1820-1060","1860-0920" }, displayID = 44400, zoneQuestId = { 57728 }, questID = { 58310 } }; --Kal'tik the Blight
	[160922] = { zoneID = 1530, artID = { 1342 }, x = 1458, y = 3735, overlay = { "1340-3240","1340-3420","1340-3580","1420-3140","1440-3720","1460-3260","1540-3800","1660-3840" }, displayID = 93302, zoneQuestId = { 57728 }, questID = { 58311 } }; --Needler Zhesalla
	[160930] = { zoneID = 1530, artID = { 1342 }, x = 1965, y = 6464, overlay = { "1720-6540","1740-6340","1740-6660","1860-6340","1920-6780","1940-6480" }, displayID = 33011, zoneQuestId = { 57728 }, questID = { 58312 } }; --Infused Amber Ooze
	[160968] = { zoneID = 1530, artID = { 1342 }, x = 1743, y = 1238, overlay = { "1640-1240","1760-1180" }, displayID = 94433, zoneQuestId = { 57008 }, questID = { 58295 } }; --Jade Colossus
	[161150] = { zoneID = 1530, artID = { 1342 }, x = 1985, y = 7427, overlay = { "1940-7340","1960-7460" }, displayID = 35371, questID = { 58300 } }; --Lesser Amber Elemental
	[163042] = { zoneID = 1530, artID = { 1342 }, x = 0360, y = 6180, overlay = { "0360-6180","0360-6360","0400-6020","0460-5800","0540-5600","0560-5460","0640-5120","0640-5300","0700-4980","0700-6500","0780-4740","0820-6480","0940-6500","0980-4420","1180-6680","1240-6860","1240-6980","1340-7140","1420-2840","1440-2640","1440-3200","1500-2460","1500-7340","1660-2240","1940-7120","1980-2080","2020-7000","2180-6860","2240-1880","2260-6660","2340-6460","2380-5800","2400-6320","2420-1880","2460-5900","2500-5540","2520-6220","2560-6040","2640-5820","2700-5260","2720-5440","2720-5560","2820-4960","2820-5180","2820-5700","2860-1760","2880-5560","2900-5800","3040-5520","3120-1760","3180-4580","3240-1760","3360-4420","3740-1840","3880-4220","4020-2040","4100-4660","4140-2100","4160-5960","4180-5720","4200-6440","4260-6720","4440-2220","4660-6740","4800-6640","4820-2280","5020-2320","5100-6380","5440-1860","5640-6060","5780-6000","5820-2100","5980-5980","6020-2480","6160-2680","6280-5920","6320-2980","6500-5940","7020-5640","7220-3420","7540-5680","7580-3700","7700-5620","7840-3980","8020-5600","8040-4620","8120-4780","8120-5440","8160-4940" }, friendly = { "A","H" }, displayID = 91729, questReset = true, nameplate = true }; --Ivory Cloud Serpent
	[156339] = { zoneID = 1533, artID = { 1321 }, x = 2251, y = 2288, overlay = { "2240-2280" }, displayID = 97749, questID = { 61634 } }; --Eliminator Sotiros
	[156340] = { zoneID = 1533, artID = { 1321 }, x = 2264, y = 2276, overlay = { "2220-2240" }, displayID = 97750, questID = { 61634 } }; --Larionrider Orstus
	[158659] = { zoneID = 1533, artID = { 1321 }, x = 4290, y = 8265, overlay = { "4280-8240" }, displayID = 92534, questID = { 57705 } }; --Herculon <Aspirant Asses>
	[160629] = { zoneID = 1533, artID = { 1321 }, x = 5131, y = 4076, overlay = { "5120-4040" }, displayID = 97288, questID = { 58648 } }; --Baedos
	[160721] = { zoneID = 1533, artID = { 1321 }, x = 6058, y = 7373, overlay = { "6020-7300" }, displayID = 94310, questID = { 58222 } }; --Fallen Acolyte Erisne
	[160882] = { zoneID = 1533, artID = { 1321 }, x = 5106, y = 6832, overlay = { "5180-6820" }, displayID = 94421, questID = { 58319 } }; --Nikara Blackheart
	[160985] = { zoneID = 1533, artID = { 1321 }, x = 5140, y = 6840, overlay = { "6120-5040" }, displayID = 94437, questID = { 58320 } }; --Selena the Reborn
	[161527] = { zoneID = 1533, artID = { 1321 }, x = 5533, y = 8028, overlay = { "5533-8028" }, displayID = 94631, questID = { 60570 } }; --Sigilback
	[161528] = { zoneID = 1533, artID = { 1321 }, x = 5533, y = 8029, overlay = { "5520-8040" }, displayID = 94632, questID = { 58526 } }; --Aethon
	[161529] = { zoneID = 1533, artID = { 1321 }, x = 5532, y = 8030, overlay = { "5520-8040" }, displayID = 94634, questID = { 60569 } }; --Nemaeus
	[161530] = { zoneID = 1533, artID = { 1321 }, x = 5534, y = 8027, overlay = { "5520-8040" }, displayID = 94633, questID = { 60571 } }; --Cloudtail
	[161557] = { zoneID = 1533, artID = { 1321 }, x = 5533, y = 8027, overlay = { "5533-8027" }, questID = { 60571,60569,58526,60570 } }; --Generic Bunny
	[163460] = { zoneID = 1533, artID = { 1321 }, x = 4134, y = 4888, overlay = { "4120-4840" }, displayID = 95126, questID = { 62650 } }; --Dionae
	[167078] = { zoneID = 1533, artID = { 1321 }, x = 4062, y = 5306, overlay = { "4040-5340","4140-5440" }, displayID = 96395, questID = { 60314 } }; --Wingflayer the Cruel
	[170439] = { zoneID = 1533, artID = { 1321 }, x = 6147, y = 7996, overlay = { "5980-9340","6020-9540","6140-9100","6200-8620","6240-8200","6240-8440" }, displayID = 94295 }; --Sundancer
	[170623] = { zoneID = 1533, artID = { 1321 }, x = 2782, y = 3015, overlay = { "2780-3000" }, displayID = 97349, questID = { 60883 } }; --Dark Watcher
	[170659] = { zoneID = 1533, artID = { 1321 }, x = 4829, y = 5304, overlay = { "4840-5040" }, displayID = 93463, questID = { 60897 } }; --Basilofos, King of the Hill
	[170832] = { zoneID = 1533, artID = { 1321 }, x = 5349, y = 8814, overlay = { "5340-8840" }, displayID = 97392, questID = { 60933 } }; --Champion of Loyalty
	[170833] = { zoneID = 1533, artID = { 1321 }, x = 5349, y = 8814, overlay = { "3900-2040","5340-8840" }, displayID = 97393, questID = { 60933 } }; --Champion of Wisdom
	[170834] = { zoneID = 1533, artID = { 1321 }, x = 5346, y = 8790, overlay = { "5340-8840" }, displayID = 99355, questID = { 60933 } }; --Champion of Purity
	[170835] = { zoneID = 1533, artID = { 1321 }, x = 5346, y = 8790, overlay = { "5340-8840" }, displayID = 99353, questID = { 60933 } }; --Champion of Courage
	[170836] = { zoneID = 1533, artID = { 1321 }, x = 5346, y = 8790, overlay = { "5340-8840" }, displayID = 99354, questID = { 60933 } }; --Champion of Humility
	[170932] = { zoneID = 1533, artID = { 1321 }, x = 5097, y = 5843, overlay = { "5040-5900" }, displayID = 95116, questID = { 60978 } }; --Cloudfeather Guardian
	[171008] = { zoneID = 1533, artID = { 1321 }, x = 4348, y = 2524, overlay = { "4340-2520" }, displayID = 94277, questID = { 60997 } }; --Unstable Memory
	[171009] = { zoneID = 1533, artID = { 1321 }, x = 5141, y = 1862, overlay = { "5100-1960" }, displayID = 92664, questID = { 60998 } }; --Enforcer Aegeon
	[171011] = { zoneID = 1533, artID = { 1321 }, x = 4033, y = 4099, overlay = { "3700-4180","3800-4060","3980-4140" }, displayID = 96574, questID = { 61069 } }; --Demi the Relic Hoarder
	[171013] = { zoneID = 1533, artID = { 1321 }, x = 4799, y = 4296, overlay = { "4740-4240","4800-4360","5200-3240","5600-1440","5980-5140","6340-3580" }, displayID = 94225, questID = { 61001 } }; --Embodied Hunger
	[171014] = { zoneID = 1533, artID = { 1321 }, x = 6605, y = 4236, overlay = { "6600-4340" }, displayID = 94640, questID = { 61002 } }; --Collector Astorestes
	[171040] = { zoneID = 1533, artID = { 1321 }, x = 4799, y = 4296, overlay = { "4740-4280","5200-3260","5600-1440","5960-5140","6340-3580" }, displayID = 94227, questID = { 61046 } }; --Xixin the Ravening
	[171041] = { zoneID = 1533, artID = { 1321 }, x = 4799, y = 4296, overlay = { "4740-4280","5200-3240","5600-1440","5940-5180","6340-3580" }, displayID = 94229, questID = { 61047 } }; --Worldfeaster Chronn
	[171189] = { zoneID = 1533, artID = { 1321 }, x = 5564, y = 6328, overlay = { "5520-6360","5540-6220","5660-6220","5700-6400" }, displayID = 92192, questID = { 59022 } }; --Bookkeeper Mnemis
	[171211] = { zoneID = 1533, artID = { 1321 }, x = 3259, y = 2334, overlay = { "3240-2340" }, displayID = 97513, questID = { 61083 } }; --Aspirant Eolis
	[171255] = { zoneID = 1533, artID = { 1321 }, x = 4513, y = 6863, overlay = { "4460-6560","4500-6440","4520-6860","4540-6660","4640-6380","4660-6660" }, displayID = 99373, questID = { 61082 } }; --Echo of Aella <Hand of Courage>
	[171300] = { zoneID = 1533, artID = { 1321 }, x = 5686, y = 4766, overlay = { "5680-4740" }, displayID = 92676, questID = { 60999 } }; --Malfunctioning Clawguard
	[171327] = { zoneID = 1533, artID = { 1321 }, x = 3164, y = 5516, overlay = { "2940-5420","2980-5660","3040-5320","3040-5520","3100-5660","3160-5520" }, displayID = 96773 }; --Reekmonger
	[176543] = { zoneID = 1533, artID = { 1321 }, x = 4349, y = 2523, overlay = { "4349-2523" }, questID = { 60997 } }; --Generic Bunny
	[157058] = { zoneID = 1536, artID = { 1323 }, x = 2638, y = 2632, overlay = { "2640-2640" }, displayID = 96437, questID = { 58335 } }; --Corpsecutter Moroc
	[157125] = { zoneID = 1536, artID = { 1323 }, x = 2894, y = 5131, overlay = { "2880-5140" }, displayID = 94813, questID = { 59290 } }; --Zargox the Reborn
	[157294] = { zoneID = 1536, artID = { 1323 }, x = 5818, y = 7424, overlay = { "5840-7420" }, displayID = 85116, questID = { 61718 } }; --Pulsing Leech
	[157307] = { zoneID = 1536, artID = { 1323 }, x = 5820, y = 7421, overlay = { "5840-7420" }, displayID = 88651 }; --Gelloh
	[157308] = { zoneID = 1536, artID = { 1323 }, x = 5820, y = 7421, overlay = { "5840-7420" }, displayID = 100404, questID = { 61719 } }; --Corrupted Sediment
	[157309] = { zoneID = 1536, artID = { 1323 }, x = 5820, y = 7421, overlay = { "5840-7420" }, displayID = 48942 }; --Violet Mistake
	[157310] = { zoneID = 1536, artID = { 1323 }, x = 5820, y = 7421, overlay = { "5840-7420" }, displayID = 95844 }; --Boneslurp
	[157311] = { zoneID = 1536, artID = { 1323 }, x = 5820, y = 7421, overlay = { "5840-7420" }, displayID = 70785 }; --Burnblister
	[157312] = { zoneID = 1536, artID = { 1323 }, x = 5819, y = 7422, overlay = { "5840-7420" }, displayID = 96717, questID = { 61724 } }; --Oily Invertebrate
	[158406] = { zoneID = 1536, artID = { 1323 }, x = 6212, y = 7579, overlay = { "6140-7620" }, displayID = 93547, questID = { 58006 } }; --Scunner
	[159105] = { zoneID = 1536, artID = { 1323 }, x = 4877, y = 2378, overlay = { "4840-2340","4960-2320" }, displayID = 94041, questID = { 58005 } }; --Collector Kash
	[159753] = { zoneID = 1536, artID = { 1323 }, x = 5380, y = 1928, overlay = { "5380-1840","5380-1960" }, displayID = 92246, questID = { 58004 } }; --Ravenomous
	[159886] = { zoneID = 1536, artID = { 1323 }, x = 5575, y = 2430, overlay = { "5540-2340" }, displayID = 96755, questID = { 58003 } }; --Sister Chelicerae
	[160059] = { zoneID = 1536, artID = { 1323 }, x = 5055, y = 2012, overlay = { "5060-1940","5060-2060" }, displayID = 94146, questID = { 58091 } }; --Taskmaster Xox <Master Taskmas>
	[161105] = { zoneID = 1536, artID = { 1323 }, x = 3875, y = 4259, overlay = { "3840-4280" }, displayID = 94450, questID = { 58332 } }; --Indomitable Schmitd
	[161857] = { zoneID = 1536, artID = { 1323 }, x = 5034, y = 6330, overlay = { "5020-6360" }, displayID = 96863, questID = { 58629 } }; --Nirvaska the Summoner
	[162180] = { zoneID = 1536, artID = { 1323 }, x = 2417, y = 4303, overlay = { "2400-4280" }, displayID = 95830, questID = { 58678 } }; --Thread Mistress Leeda
	[162528] = { zoneID = 1536, artID = { 1323 }, x = 4227, y = 5390, overlay = { "4240-5340" }, displayID = 98589, questID = { 58768 } }; --Smorgas the Feaster
	[162586] = { zoneID = 1536, artID = { 1323 }, x = 4416, y = 5080, overlay = { "4400-5040","4440-5200" }, displayID = 96462, questID = { 58783 } }; --Tahonta
	[162588] = { zoneID = 1536, artID = { 1323 }, x = 5697, y = 4994, overlay = { "5740-5140","5697-4994" }, displayID = 94882, questID = { 58837 } }; --Gristlebeak
	[162669] = { zoneID = 1536, artID = { 1323 }, x = 4580, y = 2699, overlay = { "4540-2640","4580-2760" }, displayID = 96375, questID = { 58835 } }; --Devour'us
	[162690] = { zoneID = 1536, artID = { 1323 }, x = 6603, y = 3532, overlay = { "6540-3520" }, displayID = 94945, questID = { 58851 } }; --Nerissa Heartless
	[162711] = { zoneID = 1536, artID = { 1323 }, x = 7689, y = 5710, overlay = { "7640-5660" }, displayID = 83605, questID = { 58868 } }; --Deadly Dapperling
	[162727] = { zoneID = 1536, artID = { 1323 }, x = 5255, y = 3578, overlay = { "5240-3520" }, displayID = 48061, questID = { 58870 } }; --Bubbleblood
	[162741] = { zoneID = 1536, artID = { 1323 }, x = 3148, y = 3539, overlay = { "3140-3540" }, displayID = 97217, questID = { 58872 } }; --Gieger <Experimental Constr>
	[162767] = { zoneID = 1536, artID = { 1323 }, x = 5373, y = 6131, overlay = { "5380-6100" }, displayID = 34902, questID = { 58875 } }; --Pesticide
	[162797] = { zoneID = 1536, artID = { 1323 }, x = 5395, y = 4551, overlay = { "4640-4540","4800-5200","5380-4560" }, displayID = 96897, questID = { 58878 } }; --Deepscar <Pit Ho>
	[162818] = { zoneID = 1536, artID = { 1323 }, x = 3373, y = 7988, overlay = { "3380-7940" }, displayID = 96452 }; --Wartusk
	[162819] = { zoneID = 1536, artID = { 1323 }, x = 3374, y = 7985, overlay = { "3380-7940" }, displayID = 93242, questID = { 58889 } }; --Warbringer Mal'Korak
	[168147] = { zoneID = 1536, artID = { 1323 }, x = 4907, y = 4458, overlay = { "5020-4860","5040-4740" }, displayID = 98584, questID = { 58784 } }; --Sabriel the Bonecleaver
	[168148] = { zoneID = 1536, artID = { 1323 }, x = 4909, y = 4462, overlay = { "5020-4740" }, displayID = 99075, questID = { 58784 } }; --Drolkrad
	[170995] = { zoneID = 1536, artID = { 1323 }, x = 3340, y = 8100, overlay = { "3340-8100" }, displayID = 96452 }; --Warbringer Mal'korak
	[174108] = { zoneID = 1536, artID = { 1323 }, x = 7287, y = 2891, overlay = { "7220-2840" }, displayID = 97852, questID = { 62369 } }; --Necromantic Anomaly
	[154330] = { zoneID = 1543, artID = { 1329,1693 }, x = 1919, y = 4608, overlay = { "1920-4600" }, displayID = 92779, questID = { 57509 } }; --Eternas the Tormentor
	[156203] = { zoneID = 1543, artID = { 1329,1693 }, x = 3702, y = 4442, overlay = { "3600-4340","3620-4460" }, displayID = 38549, questID = { 63371 } }; --Stygian Incinerator
	[157833] = { zoneID = 1543, artID = { 1329,1693 }, x = 3910, y = 4115, overlay = { "3920-4100" }, displayID = 101416, questID = { 57469 } }; --Borr-Geth
	[157964] = { zoneID = 1543, artID = { 1329,1693 }, x = 2592, y = 3115, overlay = { "2520-3200" }, displayID = 96828, questID = { 57482 } }; --Adjutant Dekaris
	[158025] = { zoneID = 1543, artID = { 1329,1693 }, x = 4903, y = 8153, overlay = { "4740-8100","4820-8200","4860-8040","4960-8220" }, displayID = 31119, questID = { 62282 } }; --Darklord Taraxis
	[158278] = { zoneID = 1543, artID = { 1329,1693 }, x = 4548, y = 7376, overlay = { "4560-7380" }, displayID = 93213, questID = { 158278 } }; --Nascent Devourer
	[158314] = { zoneID = 1543, artID = { 1329,1693 }, x = 3197, y = 2123, overlay = { "3140-2020","3140-2160","3280-2140" }, displayID = 97776, questID = { 59183 } }; --Drifting Sorrow
	[160770] = { zoneID = 1543, artID = { 1329,1693 }, x = 6096, y = 4805, overlay = { "6100-4820" }, displayID = 97237, questID = { 62281 } }; --Darithis the Bleak
	[162452] = { zoneID = 1543, artID = { 1329,1693 }, x = 2521, y = 1372, overlay = { "2500-1340","2580-1480" }, displayID = 92418, questID = { 59230 } }; --Dartanos <Flayer of So>
	[162829] = { zoneID = 1543, artID = { 1329,1693 }, x = 2617, y = 3744, overlay = { "2640-3740" }, displayID = 92410, questID = { 63374 } }; --Razkazzar <Lord of A>
	[162844] = { zoneID = 1543, artID = { 1329,1693 }, x = 1895, y = 5796, overlay = { "1900-5760" }, displayID = 100462, questID = { 61140 } }; --Dath Rezara <Lord of Bla>
	[162845] = { zoneID = 1543, artID = { 1329,1693 }, x = 2535, y = 4875, overlay = { "2540-4840" }, displayID = 92410, questID = { 60991 } }; --Orrholyn <Lord of Bloodlett>
	[162849] = { zoneID = 1543, artID = { 1329,1693 }, x = 1895, y = 4413, overlay = { "1640-4940","1640-5060","1920-4340" }, displayID = 92410, questID = { 60987 } }; --Morguliax <Lord of Decapitat>
	[162965] = { zoneID = 1543, artID = { 1329,1693 }, x = 2080, y = 2968, overlay = { "2100-2960" }, displayID = 93213, questID = { 58918 } }; --Huwerath
	[164064] = { zoneID = 1543, artID = { 1329,1693 }, x = 4879, y = 1830, overlay = { "4820-1860" }, displayID = 92781, questID = { 60667 } }; --Obolos <Prime Collec>
	[165047] = { zoneID = 1543, artID = { 1329,1693 }, x = 3620, y = 3734, overlay = { "3640-3740" }, displayID = 92410, questID = { 59441 } }; --Soulsmith Yol-Mattar
	[166398] = { zoneID = 1543, artID = { 1329,1693 }, x = 3598, y = 4149, overlay = { "3540-4200" }, displayID = 92416, questID = { 60834 } }; --Soulforger Rhovus
	[168693] = { zoneID = 1543, artID = { 1329,1693 }, x = 2889, y = 2515, overlay = { "2800-2420","2889-2515" }, displayID = 94400, questID = { 61346 } }; --Cyrixia <The Willbrea>
	[169102] = { zoneID = 1543, artID = { 1329,1693 }, x = 2820, y = 4451, overlay = { "2800-4440" }, displayID = 97472, questID = { 61136 } }; --Agonix
	[169827] = { zoneID = 1543, artID = { 1329,1693 }, x = 4250, y = 2120, overlay = { "4240-2040" }, displayID = 97235, questID = { 60666 } }; --Ekphoras, Herald of Grief
	[170301] = { zoneID = 1543, artID = { 1329,1693 }, x = 1934, y = 4176, overlay = { "1940-4140" }, displayID = 97234, questID = { 60788 } }; --Apholeias, Herald of Loss
	[170302] = { zoneID = 1543, artID = { 1329,1693 }, x = 2870, y = 1204, overlay = { "2840-1140","2840-1260" }, displayID = 97237, questID = { 60789 } }; --Talaporas, Herald of Pain
	[170303] = { zoneID = 1543, artID = { 1329,1693 }, x = 2059, y = 6936, overlay = { "2040-6940","2100-7060" }, displayID = 97236, questID = { 62260 } }; --Exos, Herald of Domination
	[170634] = { zoneID = 1543, artID = { 1329,1693 }, x = 3287, y = 6640, overlay = { "3240-6800","3300-6640" }, displayID = 92780, questID = { 170634 } }; --Shadeweaver Zeris
	[170692] = { zoneID = 1543, artID = { 1329,1693 }, x = 3084, y = 6866, overlay = { "3080-6860","3120-6740" }, displayID = 94397, questID = { 60903 } }; --Krala <Death's Wings>
	[170711] = { zoneID = 1543, artID = { 1329,1693 }, x = 2804, y = 6062, overlay = { "2800-5940","2820-6060" }, displayID = 97235, questID = { 60909 } }; --Dolos <Death's Knife>
	[170731] = { zoneID = 1543, artID = { 1329,1693 }, x = 2738, y = 7149, overlay = { "2720-7140" }, displayID = 100037, questID = { 60914 } }; --Thanassos <Death's Voice>
	[170774] = { zoneID = 1543, artID = { 1329,1693 }, x = 2375, y = 5341, overlay = { "2300-5240","2340-5360" }, displayID = 96828, questID = { 60915 } }; --Eketra <The Impaler>
	[170787] = { zoneID = 1543, artID = { 1329,1693 }, x = 3409, y = 7452, overlay = { "3400-7340","3400-7460" }, displayID = 100039, questID = { 60920 } }; --Akros <Death's Hammer>
	[171316] = { zoneID = 1543, artID = { 1329,1693 }, x = 2734, y = 1755, overlay = { "2720-1740","2720-1860" }, displayID = 97472, questID = { 61125 } }; --Malevolent Stygia
	[171317] = { zoneID = 1543, artID = { 1329,1693 }, x = 2860, y = 1934, overlay = { "2740-1300","2860-1960" }, displayID = 97472, questID = { 61106 } }; --Conjured Death
	[171783] = { zoneID = 1543, artID = { 1329,1693 }, x = 4040, y = 5160, overlay = { "4040-5160" }, displayID = 97472 }; --Malevolent Death
	[172207] = { zoneID = 1543, artID = { 1329,1693 }, x = 3864, y = 2880, overlay = { "3840-2840" }, displayID = 97235, questID = { 62618 } }; --Odalrik
	[172521] = { zoneID = 1543, artID = { 1329,1693 }, x = 5563, y = 6318, overlay = { "5560-6340" }, displayID = 96828, questID = { 62210 } }; --Sanngror the Torturer
	[172523] = { zoneID = 1543, artID = { 1329,1693 }, x = 6054, y = 6479, overlay = { "6000-6580","6020-6440" }, displayID = 92416, questID = { 62209 } }; --Houndmaster Vasanok
	[172524] = { zoneID = 1543, artID = { 1329,1693 }, x = 5432, y = 8492, overlay = { "6120-7920" }, displayID = 96556, questID = { 62211 } }; --Skittering Broodmother
	[172577] = { zoneID = 1543, artID = { 1329,1693 }, x = 2369, y = 2141, overlay = { "2380-2140" }, displayID = 96312, questID = { 61519 } }; --Orophea
	[172629] = { zoneID = 1543, artID = { 1329,1693 }, x = 5343, y = 7876, overlay = { "5343-7876" }, displayID = 4626, questReset = true, worldmap = true }; --Controller 01: Shadehounds
	[172631] = { zoneID = 1543, artID = { 1329,1693 }, x = 5477, y = 6862, overlay = { "5477-6862" }, displayID = 4626, questReset = true, worldmap = true }; --Controller 02: Soul Eaters
	[172632] = { zoneID = 1543, artID = { 1329,1693 }, x = 5140, y = 7837, overlay = { "5140-7837" }, displayID = 4626, questReset = true, worldmap = true }; --Controller 03: Death Elementals
	[172862] = { zoneID = 1543, artID = { 1329,1693 }, x = 3743, y = 6205, overlay = { "3720-6140","3740-5900","3900-5940" }, displayID = 94426, questID = { 61568 } }; --Yero the Skittish
	[173086] = { zoneID = 1543, artID = { 1329,1693 }, x = 4069, y = 5962, overlay = { "4040-5980" }, displayID = 97237, questID = { 61728 } }; --Valis the Cruel
	[175012] = { zoneID = 1543, artID = { 1329,1693 }, x = 2789, y = 6633, overlay = { "2780-4920","2880-4820","3040-4640","3160-4680","3300-4740","3340-4860","3440-5140","3540-5220","3620-4940","3640-5060","3900-6720","3940-5080","4220-5100","4520-5340","4540-5480","4580-5600","2789-6633" }, displayID = 100033, questID = { 62788 } }; --Ikras the Devourer
	[175821] = { zoneID = 1543, artID = { 1329,1693 }, x = 2267, y = 4224, overlay = { "2140-4180","2260-4220" }, displayID = 101411, questID = { 63044 } }; --Ratgusher <10,000 Mawrats in a Suit of Armor>
	[175846] = { zoneID = 1543, artID = { 1329,1693 }, x = 3131, y = 1261, overlay = { "1620-5060","1640-4940","1780-4880","1900-4860","2940-1500","3060-1380","3100-6640","3120-6480","3140-6240","3140-6760","3131-1261" }, displayID = 96827, questReset = true, worldmap = true }; --Dathlane the Herald <Torghast Executioner>
	[175877] = { zoneID = 1543, artID = { 1329,1693 }, x = 2189, y = 4606, overlay = { "1600-5060","1640-4940","1760-4900","1900-4860","2820-1500","2940-1500","3040-1420","3080-6600","3140-6340","3160-6200","3160-6760","3200-5840","2189-4606" }, displayID = 100045, questReset = true, worldmap = true }; --Lumisende <Torghast Executioner>
	[175881] = { zoneID = 1543, artID = { 1329,1693 }, x = 3004, y = 5828, overlay = { "1620-5060","1640-4940","1760-4900","1900-4840","2940-1480","3060-1380","3100-6540","3100-6660","3140-6280","3160-6400","3004-5828" }, displayID = 96442, questReset = true, worldmap = true }; --Naelcrotix <Torghast Executioner>
	[175885] = { zoneID = 1543, artID = { 1329,1693 }, x = 5140, y = 7837, overlay = { "5140-7837" }, displayID = 4626, questReset = true, worldmap = true }; --Controller 04: Flying Soul Eater
	[176141] = { zoneID = 1543, artID = { 1329,1693 }, x = 5460, y = 5800, displayID = 100426 }; --Rakul <The Soul Ravager>
	[176173] = { zoneID = 1543, artID = { 1329,1693 }, x = 2922, y = 2224, overlay = { "1620-5060","1640-4940","1760-4880","1880-4860","1960-4740","2740-1580","2840-1500","2980-1560","3020-1440","3100-1320","3100-6540","3100-6660","3140-6220","3140-6380","2922-2224" }, displayID = 97235, questReset = true, worldmap = true }; --Zograthos <Torghast Executioner>
	[177330] = { zoneID = 1543, artID = { 1329,1693 }, x = 2287, y = 3556, overlay = { "2240-3520","2240-5220","2800-4840","2940-1500","3040-1400","3340-4220","3940-6080","4380-4500","4420-4640","4480-4760" }, displayID = 98531, resetTimer = 108000, questID = { 64694 }, worldmap = true }; --Promathiz <Tormentor of Torghast>
	[177331] = { zoneID = 1543, artID = { 1329,1693 }, x = 2769, y = 4944, overlay = { "2240-3520","2240-5240","2800-4880","3000-1460","3080-1340","3340-4220","3460-4200","3940-6080","4420-4640","4480-4760" }, displayID = 102018, resetTimer = 108000, worldmap = true }; --Sentinel Pyrophus <Tormentor of Torghast>
	[177427] = { zoneID = 1543, artID = { 1329,1693 }, x = 2160, y = 3700, overlay = { "2240-3520","2240-5200","2780-4900","2940-1480","3060-1380","3340-4220","3920-6100","4020-6020","4440-4640","4480-4760" }, displayID = 101592, resetTimer = 108000, worldmap = true }; --The Mass of Souls <Tormentor of Torghast>
	[177444] = { zoneID = 1543, artID = { 1329,1693 }, x = 6638, y = 4190, overlay = { "6640-4220","6760-4240","6860-4340" }, displayID = 96790, questID = { 64152 } }; --Ylva <Mate of Guarm>
	[177972] = { zoneID = 1543, artID = { 1329,1693 }, x = 2200, y = 3320, overlay = { "2240-3520","2240-5240","2800-4840","3000-1460","3340-4220","3460-4220","3920-6160","3980-6040","4380-4540","4420-4680" }, displayID = 101591, resetTimer = 108000, worldmap = true }; --Malleus Grakizz <Tormentor of Torghast>
	[177979] = { zoneID = 1543, artID = { 1329,1693 }, x = 2769, y = 4944, overlay = { "2240-3520","2240-5220","2800-4880","2940-1480","3060-1380","3340-4220","3880-6160","3980-6060","4420-4640","4480-4760" }, displayID = 101589, resetTimer = 108000, worldmap = true }; --Gralebboih <Tormentor of Torghast>
	[177980] = { zoneID = 1543, artID = { 1329,1693 }, x = 2200, y = 3380, overlay = { "2080-5520","2120-3500","2200-5440","2240-3440","2240-3560","2240-5140","2240-5260","2400-3620","2700-1820","2720-1620","2760-4980","2800-4700","2800-4840","2820-1520","2900-1400","2900-1660","3040-1420","3060-1660","3340-4220","3440-4140","3460-4260","3500-5900","3540-6100","3660-6220","3660-6420","3780-6380","3820-6160","3940-6040","3960-4780","3980-6160","4060-5980","4100-4640","4200-4540","4200-4740","4300-4660","4340-4320","4380-4540","4400-4760","4460-4640" }, displayID = 101586, resetTimer = 108000, worldmap = true }; --Gruukuuek the Elder <Tormentor of Torghast>
	[177981] = { zoneID = 1543, artID = { 1329,1693 }, x = 2769, y = 4944, overlay = { "2220-3560","2280-5220","2800-4840","3020-1460","3080-1340","3340-4220","3940-6100","4420-4640" }, displayID = 101593, resetTimer = 108000, questID = { 64120 }, worldmap = true }; --Versya the Damned <Tormentor of Torghast>
	[178002] = { zoneID = 1543, artID = { 1329,1693 }, x = 2287, y = 3556, overlay = { "2000-5640","2080-5420","2120-3700","2140-3400","2140-3540","2140-5580","2200-5380","2220-5020","2220-5220","2260-3440","2260-3560","2280-3300","2360-5140","2360-5300","2720-1560","2740-4940","2780-4640","2820-1440","2860-4740","2860-4860","2900-1700","2940-1440","2960-1560","3060-1380","3340-4200","3440-4120","3460-4280","3540-6000","3660-6500","3740-6320","3800-6160","3940-6040","3960-6180","4060-5020","4060-5960","4220-4700","4220-4860","4240-4400","4240-4540","4360-4420","4400-4180","4420-4640","4440-4780","4500-4060" }, displayID = 101588, resetTimer = 108000, worldmap = true }; --Mugrem the Soul Devourer <Tormentor of Torghast>
	[178004] = { zoneID = 1543, artID = { 1329,1693 }, x = 4499, y = 4790, overlay = { "4499-4790" }, displayID = 101538, resetTimer = 108000, worldmap = true }; --Intercessor Razzra <Tormentor of Torghast>
	[178882] = { zoneID = 1543, artID = { 1329,1693 }, x = 2287, y = 3556, overlay = { "2240-3440","2240-3560","2240-5200","2800-4840","3020-1460","3100-1340","3340-4220","3460-4200","3940-6100","4380-4540","4440-4660" }, displayID = 102016, resetTimer = 108000, worldmap = true }; --Kazj The Sentinel <Tormentor of Torghast>
	[178883] = { zoneID = 1543, artID = { 1329,1693 }, x = 2000, y = 5600, overlay = { "2000-5600","2060-5460","2120-3560","2120-5140","2220-3420","2220-5360","2240-3540","2240-4940","2240-5140","2380-5300","2740-4940","2820-4720","2820-4840","2960-1540","3040-1400","3340-4220","3440-4140","3500-4260","3520-5840","3540-5960","3600-6160","3680-6360","3740-6140","3780-6280","3880-6400","3900-6160","3920-5940","4020-6020","4040-4660","4140-4580","4200-4740","4240-4920","4260-4400","4280-5060","4300-4560","4320-4240","4420-4440","4420-4640","4420-4760" }, displayID = 102017, resetTimer = 108000, worldmap = true }; --Sentinel Shakorzeth <Tormentor of Torghast>
	[178886] = { zoneID = 1543, artID = { 1329,1693 }, x = 2200, y = 3559, overlay = { "2220-5200","2240-3540","2800-4900","3340-4220","3920-6080","4360-4540","4440-4680" }, displayID = 101587, resetTimer = 108000, worldmap = true }; --Zul'gath the Flayer <Tormentor of Torghast>
	[178897] = { zoneID = 1543, artID = { 1329,1693 }, x = 2200, y = 5280, overlay = { "2240-3520","2240-5200","2800-4840","3340-4220","3940-6100","4420-4640","4480-4760" }, displayID = 101578, resetTimer = 108000, worldmap = true }; --Algel the Haunter <Tormentor of Torghast>
	[178898] = { zoneID = 1543, artID = { 1329,1693 }, x = 2120, y = 3579, overlay = { "2000-5500","2080-5360","2140-3540","2140-3700","2140-5160","2140-5560","2180-3280","2200-5040","2200-5420","2220-3420","2240-5240","2260-3560","2340-5140","2360-3660","2360-5300","2760-1580","2760-4960","2780-4640","2820-4840","2860-1440","2900-4740","2920-1560","3020-1440","3020-1660","3340-4220","3440-4140","3460-5760","3480-4260","3500-5900","3580-6080","3680-6280","3680-6480","3800-6240","3800-6360","3940-6040","3980-6160","4020-4660","4040-5940","4060-4780","4120-5000","4140-4600","4200-4780","4200-5140","4240-4380","4300-4560","4360-4200","4360-4320","4400-4760","4420-4520","4460-4640" }, displayID = 101590, resetTimer = 108000, worldmap = true }; --Golmak The Monstrosity <Tormentor of Torghast>
	[178899] = { zoneID = 1543, artID = { 1329,1693 }, x = 2040, y = 5620, overlay = { "2220-5200","2240-3520","2800-4820","2940-1460","3060-1380","3340-4220","3460-4200","3900-6100","4420-4640","4480-4760" }, displayID = 101579, resetTimer = 108000, worldmap = true }; --Manifestation of Pain <Tormentor of Torghast>
	[179460] = { zoneID = 1543, artID = { 1329,1693 }, x = 3605, y = 2963, overlay = { "1640-4960","1800-4840","1920-4860","1980-4740","2080-4580","2140-4400","2200-4140","2280-4040","2560-2160","2600-1780","2620-1660","2640-1980","2740-1580","2820-3520","2840-1480","2880-3380","2920-3260","2920-6120","2920-6260","2940-1560","2960-3640","2980-2060","3020-4540","3040-1660","3040-4200","3120-1780","3120-2320","3140-2800","3140-2980","3140-3720","3140-4100","3140-4360","3220-4480","3240-1760","3240-3900","3240-4600","3240-5780","3300-3560","3340-5640","3360-4540","3400-2420","3420-3400","3440-2560","3440-4660","3440-5400","3460-5580","3460-5700","3480-5280","3500-5120","3520-2700","3520-5940","3540-4760","3540-4880","3600-2880","3600-3340","3620-3200","3640-6280","3660-3020","3660-4760","3720-3440","3860-3520","3940-3680","4020-3860","4020-4620","4140-3960","4180-4560","4200-4860","4240-4420","4260-4040","4320-4280","4360-4140","4440-6240","4580-6240","4620-5680","4740-6080" }, displayID = 98542, questID = { 64164 } }; --Fallen Charger
	[179735] = { zoneID = 1543, artID = { 1329,1693 }, x = 2864, y = 2508, overlay = { "2800-2420","2840-2560" }, displayID = 97777, nameplate = true, questID = { 64232 } }; --Torglluun <Lord of Shades>
	[179779] = { zoneID = 1543, artID = { 1329,1693 }, x = 6117, y = 4133, overlay = { "6140-4140","6260-4140" }, displayID = 96336, questID = { 64251 } }; --Deomen the Vortex
	[179791] = { zoneID = 1543, artID = { 1329,1693 }, x = 6120, y = 4131, overlay = { "6120-4160" }, displayID = 96336 }; --Deomen the Vortex
	[179805] = { zoneID = 1543, artID = { 1329,1693 }, x = 6840, y = 4701, overlay = { "6620-4940","6640-4820","6640-5060","6660-5180","6760-4760","6800-5000","6840-4640","6920-4840","6960-4640" }, displayID = 95379, questID = { 64439 } }; --Traitor Balthier <Maldraxxi Champion>
	[179851] = { zoneID = 1543, artID = { 1329,1693 }, x = 5007, y = 7466, overlay = { "4820-7320","4920-7180","4940-6780","4940-6940","4940-7380","5020-6680","5020-7680","5040-7560","5060-6960","5120-7260","5140-6720","5140-7420","5200-6880","5260-6740","5260-7460","5260-7580","5300-7280","5340-6880","5340-7020","5400-6740","5420-7140","5480-7020","5560-7120" }, displayID = 101400, questID = { 64272 } }; --Guard Orguluus
	[179853] = { zoneID = 1543, artID = { 1329,1693 }, x = 3596, y = 4156, overlay = { "3340-4220","3540-4200","3540-4360","3560-4480" }, displayID = 22731, questID = { 64276 } }; --Blinding Shadow
	[179883] = { zoneID = 1543, artID = { 1329,1693 }, x = 6648, y = 5817, overlay = { "3300-6640","4440-5120","4620-5720","4720-7940","6220-6420" }, displayID = 100767, questID = { 64283 } }; --Zovaal's Vault
	[180246] = { zoneID = 1543, artID = { 1329,1693 }, x = 4637, y = 5678, overlay = { "4560-5540","4620-5660" }, displayID = 98536, questID = { 64258 } }; --Carriage Crusher
	[160448] = { zoneID = 1565, artID = { 1338 }, x = 6736, y = 5166, overlay = { "6720-5160" }, displayID = 96274, questID = { 59221 } }; --Hunter Vivanna <The Wild Hunt>
	[163229] = { zoneID = 1565, artID = { 1338 }, x = 4853, y = 7689, overlay = { "4800-7640","4900-7760" }, displayID = 97941, questID = { 58987 } }; --Dustbrawl
	[163370] = { zoneID = 1565, artID = { 1338 }, x = 5360, y = 7595, overlay = { "5340-7560" }, displayID = 94201, questID = { 59006 } }; --Gormbore
	[164093] = { zoneID = 1565, artID = { 1338 }, x = 5793, y = 2940, overlay = { "3280-4440","3640-4820","4780-4020","5800-2940" }, displayID = 70936, questID = { 59140 } }; --Macabre
	[164107] = { zoneID = 1565, artID = { 1338 }, x = 2760, y = 4907, overlay = { "2740-5240","2740-5760","2760-5620","2840-5500","2860-5320" }, displayID = 41946, questID = { 59145 } }; --Gormtamer Tizo
	[164112] = { zoneID = 1565, artID = { 1338 }, x = 3242, y = 3026, displayID = 98601, questID = { 59157 } }; --Humon'gozz
	[164122] = { zoneID = 1565, artID = { 1338 }, x = 3257, y = 3030, overlay = { "3240-3020" }, displayID = 94288, questID = { 59157 } }; --Rapidly Growing Mushroom
	[164147] = { zoneID = 1565, artID = { 1338 }, x = 5834, y = 6179, overlay = { "5800-6140" }, displayID = 81163, questID = { 59170 } }; --Wrigglemortis
	[164179] = { zoneID = 1565, artID = { 1338 }, x = 5834, y = 6179, overlay = { "5820-6180" }, displayID = 95366, questID = { 59170 } }; --Wriggling Tendril
	[164238] = { zoneID = 1565, artID = { 1338 }, x = 4958, y = 2386, overlay = { "4640-2320","4640-2460","4660-2640","4740-2140","4740-2820","4860-2640","4880-2200","4920-2320" }, displayID = 94195, questID = { 59201 } }; --Deifir the Untamed
	[164391] = { zoneID = 1565, artID = { 1338 }, x = 5035, y = 5725, overlay = { "5040-5720","5120-5840","5260-5860" }, displayID = 95115, questID = { 59208 } }; --Old Ardeite
	[164415] = { zoneID = 1565, artID = { 1338 }, x = 3773, y = 5906, overlay = { "3680-6020","3760-5920" }, displayID = 96776, questID = { 59220 } }; --Skuld Vit
	[164477] = { zoneID = 1565, artID = { 1338 }, x = 3463, y = 6799, overlay = { "3460-6800" }, displayID = 96777, questID = { 59226 } }; --Deathbinder Hroth
	[164547] = { zoneID = 1565, artID = { 1338 }, x = 6527, y = 3068, overlay = { "5220-3300","5540-2980","5660-3440","5780-3600","5880-3720","6060-3680","6180-3660","6300-3540","6340-3660","6440-3440","6480-3320","6500-3180","6540-2940" }, displayID = 93787, questID = { 59235 } }; --Mystic Rainbowhorn
	[165053] = { zoneID = 1565, artID = { 1338 }, x = 6221, y = 2518, overlay = { "6120-2560","6140-2440","6260-2420" }, displayID = 95696, questID = { 59431 } }; --Mymaen
	[166135] = { zoneID = 1565, artID = { 1338 }, x = 4128, y = 4434, overlay = { "4120-4440" }, displayID = 94474, questID = { 61201 } }; --Astra, As Azshara <An Infamous Queen>
	[166138] = { zoneID = 1565, artID = { 1338 }, x = 4128, y = 4434, overlay = { "4120-4440" }, displayID = 99719, questID = { 61202 } }; --Mi'kai, As Argus, the Unmaker <A Corrupted World Soul>
	[166139] = { zoneID = 1565, artID = { 1338 }, x = 4150, y = 4482, overlay = { "4120-4440" }, displayID = 99664, questID = { 61203 } }; --Glimmerdust, As Kil'jaeden <of The Burning Leg>
	[166140] = { zoneID = 1565, artID = { 1338 }, x = 4128, y = 4434, overlay = { "4120-4440" }, displayID = 95055, questID = { 61204 } }; --Senthii, As Gul'dan <From an Alternate Timel>
	[166142] = { zoneID = 1565, artID = { 1338 }, x = 4128, y = 4434, overlay = { "4120-4440" }, displayID = 99664, questID = { 61205 } }; --Glimmerdust, As Jaina <A Magic Ice Princ>
	[166145] = { zoneID = 1565, artID = { 1338 }, x = 4128, y = 4434, overlay = { "4120-4440" }, displayID = 94430, questID = { 61206 } }; --Dreamweaver, As N'Zoth <An Eldritch Abominat>
	[166146] = { zoneID = 1565, artID = { 1338 }, x = 4128, y = 4434, overlay = { "4120-4440" }, displayID = 95232, questID = { 61207 } }; --Niya, As Xavius <Some Kind of Evil Syl>
	[167721] = { zoneID = 1565, artID = { 1338 }, x = 5944, y = 4666, overlay = { "5940-4640" }, displayID = 95201, questID = { 60290 } }; --The Slumbering Emperor
	[167724] = { zoneID = 1565, artID = { 1338 }, x = 6573, y = 2291, overlay = { "6560-2400" }, displayID = 19530, questID = { 60258 } }; --Rotbriar Boggart
	[167726] = { zoneID = 1565, artID = { 1338 }, x = 6505, y = 4433, overlay = { "6500-4420" }, displayID = 55772, questID = { 60273 } }; --Rootwrithe
	[167851] = { zoneID = 1565, artID = { 1338 }, x = 5785, y = 2953, overlay = { "5780-2940" }, displayID = 94204, questID = { 60266 } }; --Egg-Tender Leh'go
	[167916] = { zoneID = 1565, artID = { 1338 }, x = 6508, y = 4426, overlay = { "6500-4420" }, displayID = 80463 }; --Dormant Blossom
	[167928] = { zoneID = 1565, artID = { 1338 }, x = 6500, y = 4432, overlay = { "6500-4420" }, displayID = 80463, questID = { 60273 } }; --Dormant Blossom
	[167929] = { zoneID = 1565, artID = { 1338 }, x = 6500, y = 4423, overlay = { "6500-4420" }, displayID = 80463, questID = { 60273 } }; --Dormant Blossom
	[168053] = { zoneID = 1565, artID = { 1338 }, x = 5944, y = 4666, questID = { 60290 } }; --Sleepy Bunny
	[168135] = { zoneID = 1565, artID = { 1338 }, x = 5840, y = 4882, overlay = { "5740-5020","5820-4920","5880-5080","5940-5620","6000-4940","6040-5780","6060-5660","6080-4820","6140-5080","6140-5540","6160-4940","6220-5220","6220-5340","6260-5460","6260-5620" }, displayID = 94297, questID = { 60306 } }; --Night Mare
	[168647] = { zoneID = 1565, artID = { 1338 }, x = 3050, y = 5549, overlay = { "3020-5560" }, displayID = 96087, questID = { 61632 } }; --Valfir the Unrelenting
	[171451] = { zoneID = 1565, artID = { 1338 }, x = 7243, y = 5175, overlay = { "7240-5180" }, displayID = 96776, questID = { 61177 } }; --Soultwister Cero
	[171688] = { zoneID = 1565, artID = { 1338 }, x = 6855, y = 2786, overlay = { "6840-2820" }, displayID = 86207, questID = { 61184 } }; --Faeflayer
	[171690] = { zoneID = 1565, artID = { 1338 }, x = 6566, y = 2529, overlay = { "6560-2440" }, displayID = 97756, questID = { 60258 } }; --Gwynceirw <The Winter Wolf>
	[156451] = { zoneID = 1570, artID = { 1363 }, x = 9137, y = 6522, overlay = { "9137-6522" }, displayID = 92744 }; --Darkspeaker Thul'grsh
	[159103] = { zoneID = 1570, artID = { 1363 }, x = 8701, y = 5948, overlay = { "8701-5948" }, displayID = 90739 }; --Manipulator Shrog'lth
	[159318] = { zoneID = 1570, artID = { 1363 }, x = 8176, y = 5552, overlay = { "8176-5552" }, displayID = 93172 }; --Shadow-Walker Yash'gth
	[160126] = { zoneID = 1570, artID = { 1363 }, x = 9160, y = 6762, overlay = { "9160-6762" }, displayID = 90739 }; --Manipulator Yggshoth
	[160127] = { zoneID = 1570, artID = { 1363 }, x = 8772, y = 6876, overlay = { "8772-6876" }, displayID = 92744 }; --Darkspeaker Shath'gul
	[160805] = { zoneID = 1570, artID = { 1363 }, x = 9110, y = 6525, overlay = { "9110-6525" }, displayID = 92229 }; --Gloopy Globule
	[160841] = { zoneID = 1570, artID = { 1363 }, x = 8783, y = 6881, overlay = { "8783-6881" }, displayID = 92229 }; --Blubbery Blobule
	[161139] = { zoneID = 1571, artID = { 1364 }, x = 5512, y = 3465, overlay = { "5380-3300","5500-3460","5520-3320","5520-3680","5580-3560","5640-3300","5700-3540" }, displayID = 93720 }; --Acolyte of N'Zoth
	[161451] = { zoneID = 1571, artID = { 1364 }, x = 5646, y = 3383, overlay = { "5540-3380","5660-3380" }, displayID = 90739 }; --Manipulator Yar'shath
	[161463] = { zoneID = 1571, artID = { 1364 }, x = 5523, y = 3695, overlay = { "5520-3680" }, displayID = 94554 }; --Depthcaller Velshen
	[161467] = { zoneID = 1571, artID = { 1364 }, x = 5648, y = 3297, overlay = { "5640-3300" }, displayID = 94556 }; --Portalkeeper Jin'tashal
	[161683] = { zoneID = 1571, artID = { 1364 }, x = 5740, y = 3223, overlay = { "5360-3360","5400-3140","5440-3460","5560-3460","5580-3160","5700-3100","5740-3340","5840-3140" }, displayID = 93954 }; --Antak'shal
	[152508] = { zoneID = {
				[1618] = { x = 4973, y = 6084, artID = { 1375 }, overlay = { "4973-6084" } };
				[1784] = { x = 4514, y = 5663, artID = { 1494 }, overlay = { "4514-5663" } };
			  }, displayID = 100490 }; --null
	[173051] = { zoneID = {
				[1618] = { x = 5162, y = 6356, artID = { 1375 }, overlay = { "5162-6356" } };
				[1805] = { x = 7916, y = 4946, artID = { 1514 }, overlay = { "7916-4946" } };
			  }, displayID = 97235 }; --null
	[155483] = { zoneID = 1619, artID = { 1376 }, x = 6273, y = 4030, overlay = { "6273-4030" }, displayID = 95199 }; --Faeleaf Shimmerwing
	[173191] = { zoneID = 1623, artID = { 1379 }, x = 3941, y = 3220, overlay = { "3941-3220" }, displayID = 92415 }; --Soulstalker V'lara
	[156134] = { zoneID = 1632, artID = { 1383 }, x = 5175, y = 3653, displayID = 97041 }; --Ghastly Charger
	[165686] = { zoneID = 1644, artID = { 1398 }, x = 3520, y = 6320, overlay = { "3240-6300","3300-4240","3340-6160","3360-4360","3380-6280","3400-4560","3460-6400","3500-6240","3500-6520","3580-3680","3720-3480","3740-3300","3780-3600","3860-3340","3880-4640","3900-3460","3920-3140","3920-4440","4040-3260","4060-3420","4060-3540","4060-4500","4080-3140","4180-4100","4360-5040","4580-3980","4620-4460","4640-4620","4720-4160","4720-4280","4720-4760","4740-4400","4820-4920","4840-4520","4900-4760","4980-4900","5080-4760","5180-1600","5220-1960","5240-1780","5260-5000","5320-2060","5320-2500","5400-1960","5520-2000","5540-2220","5600-5060","5620-5220","5640-1900","5640-2080","5720-1720","5740-5120","5760-1860","5780-2060","5820-1360","5820-5260","5860-5000","5900-1620","5920-4860","6220-3520","6440-3120","6440-3440","6480-3320","6500-3580","6560-3440","6660-3180","6660-3540","6760-5540","6820-3500","7020-3880","7080-5220","7140-5100","7180-5340","7200-4800","7200-4960","7240-4640" }, displayID = 95209 }; --Ashen Amalgamation
	[165786] = { zoneID = 1644, artID = { 1398 }, x = 8260, y = 3600, overlay = { "7380-3580","7460-3860","7500-3520","7660-3500","7780-3520","7920-3480","8080-3440","8140-3560","8260-3340","8300-3560","8360-3440","8420-3660","8480-3540","8600-3660","8620-3540","8760-3380","8760-3540","8940-3520" }, displayID = 97721 }; --High Inquisitor Vetar
	[171405] = { zoneID = 1644, artID = { 1398 }, x = 4020, y = 3440, overlay = { "2720-4320","2820-3980","2940-3940","3020-3840","3300-4240","3840-5860","3920-2760","3920-2920","4020-3440","4020-5920","4120-7220","4140-5900","5480-4960","5720-5060","5740-1820","5760-1940","5780-5180","5820-4980","5860-4780","6480-2020","6660-4800","6660-4980","6820-2480" }, displayID = 95695 }; --Tricky Trik
	[171540] = { zoneID = 1644, artID = { 1398 }, x = 3140, y = 5920, overlay = { "3140-5920" }, displayID = 90580 }; --Swollen Experiment
	[171705] = { zoneID = 1644, artID = { 1398 }, x = 3640, y = 3820, overlay = { "3220-3900","3340-3900","3480-3840","3620-3820" }, displayID = 97758 }; --Court Crusher
	[171708] = { zoneID = 1644, artID = { 1398 }, x = 6220, y = 3120, overlay = { "6040-3500","6180-3560","6180-3880","6200-2540","6220-2780","6220-2940","6220-3120","6220-3380","6240-4360","6260-3740","6280-4100","6300-3560","6300-4760","6340-3960","6460-3540","6480-3400","6520-3040","6620-3560" }, displayID = 97759 }; --Drezgruda <The Fifth Talon>
	[171731] = { zoneID = 1644, artID = { 1398 }, x = 7080, y = 5200, overlay = { "6300-6160","6340-5920","6540-6040","6580-5780","6660-5600","6680-6020","6680-6300","6700-5720","6700-5880","6720-6620","6780-5380","6780-6440","6800-5520","6820-4280","6820-5040","6840-5240","6860-3500","6860-5920","6900-5400","6900-6080","6920-5720","6920-6440","6940-4720","6940-5540","6960-4080","7000-4480","7000-5100","7000-6160","7040-5280","7040-5440","7040-5700","7040-6020","7060-5560","7120-4940","7120-5160","7160-5360","7160-5480","7160-5780","7180-4240","7180-4720","7260-4840","7260-5040","7300-4640","7440-4540" }, displayID = 94529 }; --Sineater
	[171741] = { zoneID = 1644, artID = { 1398 }, x = 6180, y = 3300, overlay = { "6140-3340","6140-3520","6180-3200","6200-2880","6220-4000","6240-3060","6240-3680","6260-3460","6320-3200" }, displayID = 97766 }; --Kedu <The Final Fate>
	[171749] = { zoneID = 1644, artID = { 1398 }, x = 7719, y = 3660, overlay = { "7060-3560","7300-3400","7300-3560","7360-4000","7400-3780","7420-3420","7520-3540","7640-3560","7700-3420","7720-3660","7840-3440","7860-3560","8020-3520","8140-3440","8180-3560","8320-3420","8440-3540","8480-3420","8560-3580","8700-3500","8740-3660","8840-3440","8840-3580" }, displayID = 97769 }; --Sloppy
	[172164] = { zoneID = 1644, artID = { 1398 }, x = 4459, y = 3240, overlay = { "3800-3800","4020-3200","4080-3020","4080-3620","4140-3820","4160-3520","4180-3300","4200-3080","4240-2620","4240-2840","4240-3960","4260-5600","4300-2980","4300-3360","4320-3120","4320-4580","4340-3600","4340-3760","4340-4080","4360-2780","4380-3460","4420-3920","4420-4300","4440-3100","4440-4160","4480-3540","4500-2620","4500-2960","4500-3280","4520-4720","4520-5320","4540-3720","4540-4500","4560-3120","4560-3420","4560-4300","4580-3960","4580-4840","4580-5120","4620-2880","4620-4980","4640-4140","4660-3700","4660-4420","4680-3260","4680-4640","4700-3140","4700-3540","4720-2780","4720-4300","4740-3000","4780-2660","4780-4800","4800-3260","4800-4500","4800-5000","4840-2840","4860-4340","4880-3020","4880-3920","4880-4680","4920-2740","4920-4860","4940-3160","4940-4140","4940-5060","4980-2560","4980-2940","5020-3980","5060-3060","5060-4800","5080-2680","5080-2800","5100-4980","5140-2920","5140-5200","5160-4060","5180-2580","5180-3040","5180-4840","5220-3260","5220-3400","5220-3720","5240-2740","5300-2460","5300-3160","5300-4700","5300-4920","5320-4120","5320-4540","5340-2580","5340-3300","5360-2240","5360-2720","5400-3540","5420-3660","5440-3020","5440-3900","5440-4440","5440-4620","5460-2880","5480-3240","5500-4020","5520-4160","5520-4320","5540-3440","5560-3560","5560-4700","5560-4820","5580-3700","5580-3900","5660-2800","5660-4040","5680-3300","5680-4160","5700-3440","5700-3660","5780-4040","5820-3680","5860-2940","5900-3580","6060-3560","6120-3680","6320-3540" }, displayID = 82239 }; --Ember Skyterror
	[172180] = { zoneID = 1644, artID = { 1398 }, x = 4880, y = 6260, overlay = { "3780-6240","3900-6940","3920-6340","4060-7100","4100-5960","4100-6300","4140-6140","4160-6600","4180-6440","4180-7220","4200-6960","4240-6800","4260-6220","4320-6400","4320-6940","4320-7100","4380-7300","4400-6520","4420-6220","4420-6740","4440-6960","4520-6360","4540-6540","4580-6020","4600-6700","4640-6220","4680-6360","4700-6520","4720-6040","4780-6220","4860-6380","4900-6020","4920-6140","4960-5400","4960-6260","5040-6360","5060-6100","5060-6700","5100-6480","5160-6260","5180-6040","5300-6420","5300-6780","5320-6020","5340-6220","5360-6600","5380-5540","5380-5900","5440-6400","5500-5460" }, displayID = 95785 }; --Blustery Boil
	[172182] = { zoneID = 1644, artID = { 1398 }, x = 3340, y = 3080, overlay = { "2860-2720","2980-2780","2980-3200","2980-3580","3080-3300","3080-3460","3100-2940","3120-3100","3200-3220","3220-3340","3240-2880","3280-3880","3340-3080","3340-3360","3340-3540","3360-2640","3440-2780","3460-3540","3500-3220","3500-3780","3520-3660","3580-3540","3600-3340","3620-3780","3680-3620","3740-3220","3740-3360","3800-3600","3800-3720","3820-3860","3860-3340","3860-3460","3900-3140","3960-3700","3980-3540","4000-2820","4000-3000","4000-3940","4020-3120","4020-3340","4040-2700","4060-5000","4080-3840","4100-3640","4160-3300","4180-3080","4180-3740","4220-3480","4280-3360","4300-3060","4300-3180","4320-3800","4340-2820","4340-4600","4360-3580","4380-2600","4440-4220","4460-4520","4480-3860" }, displayID = 97879 }; --Venthyr Provocateur
	[172186] = { zoneID = 1644, artID = { 1398 }, x = 4280, y = 3400, overlay = { "3560-3780","3680-3740","3720-3540","3840-3500","3880-3700","3980-3220","3980-3360","3980-3540","4000-2840","4000-3660","4020-3780","4080-2960","4100-3140","4120-3480","4140-3300","4160-3700","4180-3900","4220-2720","4240-3020","4240-3480","4320-2900","4320-3120","4320-3680","4320-3860","4320-4240","4340-3340","4360-3520","4400-2540","4400-4020","4440-3020","4440-3740","4460-2800","4460-3240","4460-3360","4480-3500","4480-3920","4480-4260","4520-4400","4620-4480","4640-2920","4640-3140","4640-4220","4720-2720","4820-3040","5020-2960","5160-3120","5300-3220","5360-3660" }, displayID = 97444 }; --Knockerbock <"Premier" Party Supplies>
	[172384] = { zoneID = 1644, artID = { 1398 }, x = 4700, y = 5300, overlay = { "4700-5300" }, displayID = 80465 }; --Withered Emberbloom
	[156142] = { zoneID = 1751, artID = { 1464 }, x = 5999, y = 7414, overlay = { "5999-7414" }, displayID = 98720 }; --Seeker of Souls
	[170385] = { zoneID = 1776, artID = { 1486 }, x = 4978, y = 3332, overlay = { "4978-3332" }, displayID = 94278 }; --Writhing Misery
	[152517] = { zoneID = 1780, artID = { 1490 }, x = 6205, y = 4924, overlay = { "6205-4924" }, displayID = 90427 }; --Deadsoul Lifetaker
	[169823] = { zoneID = 1780, artID = { 1490 }, x = 6196, y = 5126, overlay = { "6196-5126" }, displayID = 94207 }; --Gorm Behemoth
	[152612] = { zoneID = 1782, artID = { 1492 }, x = 4739, y = 3663, overlay = { "4739-3663" }, displayID = 100485 }; --Subjugator Klontzas
	[173293] = { zoneID = 1782, artID = { 1492 }, x = 4796, y = 2893, overlay = { "4796-2893" }, displayID = 94614 }; --Lady Audat
	[179136] = { zoneID = 1795, artID = { 1504 }, x = 3628, y = 3948, overlay = { "3628-3948" }, displayID = 99098 }; --Karthazel
	[170417] = { zoneID = 1798, artID = { 1507 }, x = 3600, y = 5341, overlay = { "3600-5341" }, displayID = 88739 }; --Animated Stygia
	[173134] = { zoneID = 1798, artID = { 1507 }, x = 3386, y = 4752, overlay = { "3386-4752" }, displayID = 92664 }; --Darksworn Goliath
	[170414] = { zoneID = 1802, artID = { 1511 }, x = 6142, y = 5478, overlay = { "6142-5478" }, displayID = 88583 }; --Howling Spectre
	[184010] = { zoneID = 1805, artID = { 1514 }, x = 7999, y = 4438, overlay = { "7999-4438" }, displayID = 101911 }; --Oracle of Torment
	[152500] = { zoneID = 1806, artID = { 1521 }, x = 5572, y = 8000, overlay = { "5572-8000" }, displayID = 97777 }; --Deadsoul Amalgam
	[173080] = { zoneID = 1806, artID = { 1521 }, x = 5610, y = 8193, overlay = { "5610-8193" }, displayID = 96338 }; --Wandering Death
	[173238] = { zoneID = 1806, artID = { 1521 }, x = 5617, y = 8404, overlay = { "5617-8404" }, displayID = 98490 }; --Deadsoul Strider
	[159323] = { zoneID = 1807, artID = { 1516 }, x = 3503, y = 5543, overlay = { "3503-5543" }, displayID = 93165 }; --Stoneward Trampler
	[179135] = { zoneID = 1810, artID = { 1522 }, x = 4730, y = 2478, overlay = { "4730-2478" }, displayID = 100090 }; --Sath'zuul
	[170228] = { zoneID = 1811, artID = { 1519 }, x = 6016, y = 6838, overlay = { "6016-6838" }, displayID = 94814 }; --Bone Husk
	[173114] = { zoneID = 1811, artID = { 1519 }, x = 5587, y = 7167, overlay = { "5587-7167" }, displayID = 18722 }; --Invasive Decayfly
	[173136] = { zoneID = 1811, artID = { 1519 }, x = 5703, y = 7057, overlay = { "5703-7057" }, displayID = 98171 }; --Blightsmasher
	[156158] = { zoneID = 1913, artID = { 1485 }, x = 6292, y = 5134, overlay = { "6292-5134" }, displayID = 93906 }; --Adjutant Felipos
	[177336] = { zoneID = 1961, artID = { 1648 }, x = 2771, y = 5883, overlay = { "2771-5883" }, displayID = 100574, questID = { 64442 } }; --Zelnithop
	[177903] = { zoneID = 1961, artID = { 1648 }, x = 5181, y = 2080, overlay = { "5200-2100" }, displayID = 100907, questID = { 63830 } }; --Dominated Protector
	[179108] = { zoneID = 1961, artID = { 1648 }, x = 6167, y = 3303, overlay = { "5700-3660","5740-3540","5820-3440","5840-3740","5900-3560","5940-3440","6020-3340","6040-3660","6140-3500","6160-3340","6160-3660" }, displayID = 100480, questID = { 64428 } }; --Kroke the Tormented
	[179472] = { zoneID = 1961, artID = { 1648 }, x = 5930, y = 5202, overlay = { "4440-2940","4460-4300","4700-3540","5140-4140","5220-2120","5620-6700","5880-5140" }, displayID = 101533, questID = { 64246 } }; --Konthrogz the Obliterator
	[179565] = { zoneID = 1961, artID = { 1648 }, x = 6316, y = 3011, overlay = { "3800-3980","3800-4620","3820-3720","3860-4940","3920-3880","3940-4040","3980-4220","4020-4920","4040-4740","4200-5100","4440-2940","4540-5520","4560-2820","4740-5300","4740-5480","4760-2720","4840-4860","4940-5040","5140-2680","5220-5040","5240-2200","5240-2820","5300-5240","5360-2220","5380-4840","5420-2860","5420-4620","5420-5140","5440-5380","5500-5240","5520-1720","5520-3540","5540-2160","5620-3240","5640-2240","5640-3680","5640-4940","5680-5480","5700-3140","5760-3780","5780-3240","5780-4120","5840-3500","5880-3620","5880-3800","5900-3940","5900-4060","6200-3120","6240-2960","6380-3040" }, displayID = 100364, reset = true, nameplate = true, questID = { 64434 } }; --Relic Gorger
	[179608] = { zoneID = 1961, artID = { 1648 }, x = 4475, y = 4297, overlay = { "4440-4240","4440-4360" }, displayID = 97777, questID = { 64263 } }; --Screaming Shade
	[179684] = { zoneID = 1961, artID = { 1648 }, x = 4535, y = 3034, overlay = { "4440-2940" }, displayID = 100418, questID = { 64233 } }; --Malbog
	[179755] = { zoneID = 1961, artID = { 1648 }, x = 5275, y = 4031, overlay = { "5140-4140","5240-4040" }, displayID = 99133, questID = { 64243 } }; --Consumption
	[179760] = { zoneID = 1961, artID = { 1648 }, x = 4576, y = 7921, overlay = { "2940-4500","3060-4500","4440-2940","4440-4300","4560-7840","4560-7960","5140-4140","5220-2120","5240-4040","5720-7020","5820-3520","5880-5120","5940-3440","5940-4240","5940-4360","5940-5240","6080-3420","6100-3660","6160-3540" }, displayID = 98535, questID = { 64245 } }; --Towering Exterminator
	[179768] = { zoneID = 1961, artID = { 1648 }, x = 5115, y = 4177, overlay = { "5140-4140" }, displayID = 96337, questID = { 64243 } }; --Consumption
	[179769] = { zoneID = 1961, artID = { 1648 }, x = 5094, y = 4136, overlay = { "5020-4260","5140-4140" }, displayID = 96338, questID = { 64243 } }; --Consumption
	[179802] = { zoneID = 1961, artID = { 1648 }, x = 3937, y = 5240, overlay = { "5220-3280" }, displayID = 101000, questID = { 64257 } }; --Yarxhov the Pillager
	[179823] = { zoneID = 1961, artID = { 1648 }, x = 3793, y = 3986, overlay = { "3800-4000","3800-4620","3820-3700","3880-3820","3880-4940","3920-4680","3960-4140","3980-4260","4020-4920","4100-4640","4160-5040","4200-5180","4440-2940","4500-5400","4540-5540","4740-5280","4740-5400","4760-2740","4820-4820","4860-5200","4920-5080","5140-2700","5220-5040","5240-2200","5240-2820","5300-5260","5420-4640","5420-4760","5420-5240","5420-5380","5440-2220","5440-2800","5520-3540","5540-1720","5540-4940","5600-3640","5620-2220","5620-3240","5660-4920","5680-5480","5700-3140","5700-3760","5780-3240","5780-4100","5800-3440","5840-3740","5880-3920","5900-4060","6180-3100","6320-3020" }, displayID = 92628, reset = true, nameplate = true }; --Relic Gatherer
	[179859] = { zoneID = 1961, artID = { 1648 }, x = 4497, y = 3545, overlay = { "5520-2940" }, displayID = 100505, questID = { 64278 } }; --Xyraxz the Unknowable
	[179911] = { zoneID = 1961, artID = { 1648 }, x = 5772, y = 7055, overlay = { "5740-7020" }, displayID = 97275, questID = { 64284 } }; --Silent Soulstalker
	[179912] = { zoneID = 1961, artID = { 1648 }, x = 4114, y = 3988, overlay = { "2980-5560","3300-3880","3580-4640","3580-6220","3840-3140","3980-3480","4100-3940","4120-2780","4320-3120","4920-4180","5020-2300","5980-1520","6120-4020","6240-4980","6800-3000" }, displayID = 94296, nameplate = true, questID = { 64298,64292 } }; --Maelie the Wanderer
	[179913] = { zoneID = 1961, artID = { 1648 }, x = 5939, y = 5230, overlay = { "5880-5140","5940-5260" }, displayID = 98490, questID = { 64285 } }; --Deadsoul Hatcher
	[179914] = { zoneID = 1961, artID = { 1648 }, x = 5025, y = 7591, overlay = { "4940-7500","5060-7520" }, displayID = 97275, questID = { 64369 } }; --Observer Yorik
	[179931] = { zoneID = 1961, artID = { 1648 }, x = 2914, y = 4418, overlay = { "2280-4200","2800-3960","2820-3840","2940-4440" }, displayID = 101493, questID = { 64291 } }; --Relic Breaker Krelva
	[179985] = { zoneID = 1961, artID = { 1648 }, x = 4566, y = 8026, overlay = { "4540-7960","4560-7840" }, displayID = 97344, questID = { 64313 } }; --Stygian Stonecrusher
	[180014] = { zoneID = 1961, artID = { 1648 }, x = 3007, y = 3762, overlay = { "3007-3762" }, displayID = 101002, questID = { 64320 } }; --Escaped Wilderling
	[180032] = { zoneID = 1961, artID = { 1648 }, x = 5687, y = 3237, overlay = { "4700-3540" }, displayID = 97785, questID = { 64338 } }; --Wild Worldcracker
	[180042] = { zoneID = 1961, artID = { 1648 }, x = 5987, y = 4376, overlay = { "5940-4320" }, displayID = 101525, questID = { 64349 } }; --Fleshwing <Lord of the Heap>
	[180160] = { zoneID = 1961, artID = { 1648 }, x = 5658, y = 6498, overlay = { "5620-6640","5640-6760" }, displayID = 100248, questID = { 64455 } }; --Reliwik the Defiant
	[180162] = { zoneID = 1961, artID = { 1648 }, x = 6144, y = 5782, overlay = { "3280-4320","4240-5960","4320-6760","4900-2900","6140-5780" }, displayID = 96510, questID = { 64457 } }; --Ve'rayn <Assets and Liabilities>
	[178229] = { zoneID = 1970, artID = { 1650 }, x = 6210, y = 5991, overlay = { "6200-6040","6031-5288","6120-5160","6160-5900","6240-5280","6300-5660","6220-5480","6280-5900","6400-5860" }, displayID = 103108, questID = { 65557 } }; --Feasting
	[178508] = { zoneID = 1970, artID = { 1650 }, x = 5453, y = 3439, overlay = { "5420-3480","5520-3340" }, displayID = 103098, questID = { 65547 } }; --Mother Phestis <Tarachnid Prime>
	[178563] = { zoneID = 1970, artID = { 1650 }, x = 5251, y = 2503, overlay = { "5220-2600","5280-2720","5340-2600" }, displayID = 100373, questID = { 65581 } }; --Hadeon the Stonebreaker <Scarabid Prime>
	[178778] = { zoneID = 1970, artID = { 1650 }, x = 5308, y = 9305, overlay = { "5260-9320","5360-9220","5380-9020" }, displayID = 80467, questID = { 65579 } }; --Gluttonous Overgrowth
	[178963] = { zoneID = 1970, artID = { 1650 }, x = 8085, y = 4887, overlay = { "7520-6100","7540-5920","7580-4580","7660-4480","8020-4620","7660-5920","8000-4760","8080-4880","7535-6283","7560-4760","7580-5780","7920-4500" }, displayID = 104871, questID = { 63988 } }; --Gorkek <Bufonid Prime>
	[179006] = { zoneID = 1970, artID = { 1650 }, x = 6474, y = 3368, overlay = { "6480-3380","6392-3713" }, displayID = 98869, questID = { 65549 } }; --Akkaris <Annelid Prime>
	[179043] = { zoneID = 1970, artID = { 1650 }, x = 5612, y = 7072, overlay = { "5560-6920","5640-6820","5520-6800","5420-6940","5620-6560","5620-7100","5640-6700","5780-6960","5460-7180","5820-6840" }, displayID = 103119, questID = { 65582 } }; --Orixal <Gastropod Prime>
	[180746] = { zoneID = 1970, artID = { 1650 }, x = 3887, y = 2762, overlay = { "3880-2760","3960-2660" }, displayID = 100685, questID = { 64668 } }; --Protector of the First Ones
	[180917] = { zoneID = 1970, artID = { 1650 }, x = 5363, y = 4436, overlay = { "5360-4440" }, displayID = 105437, questID = { 64716 } }; --Destabilized Core
	[180924] = { zoneID = 1970, artID = { 1650 }, x = 6906, y = 3663, overlay = { "6820-3780","6906-3663","6800-3600" }, displayID = 105595, questID = { 64719 } }; --Garudeon <Raptora Prime>
	[180978] = { zoneID = 1970, artID = { 1650 }, x = 5236, y = 7550, overlay = { "5236-7550","5040-7380","5040-7500","5160-7420" }, displayID = 104736, questID = { 65548 } }; --Hirukon <Aurelid Prime>
	[181249] = { zoneID = 1970, artID = { 1650 }, x = 5450, y = 7346, overlay = { "5420-7240","5460-7400","5560-7280" }, displayID = 102119, questID = { 65550 } }; --Tethos
	[181360] = { zoneID = 1970, artID = { 1650 }, x = 3955, y = 5737, overlay = { "3880-5480","3900-5600","3940-5720" }, displayID = 105174, questID = { 65239 } }; --Vexis <Lupine Prime>
	[182114] = { zoneID = 1970, artID = { 1650 }, x = 6320, y = 2607, overlay = { "6395-2702","6371-2541","6200-2720","6220-2500","6360-2420" }, displayID = 96827, questID = { 65706 } }; --Iska, Outrider of Ruin
	[182155] = { zoneID = 1970, artID = { 1650 }, x = 6318, y = 2600, overlay = { "6318-2600","6420-2680","6180-2640","6360-2440" }, displayID = 100926, questID = { 65586 } }; --High Reaver Damaris
	[182158] = { zoneID = 1970, artID = { 1650 }, x = 6321, y = 2605, overlay = { "6315-2541","6380-2660","6240-2700","6360-2420" }, displayID = 100015, questID = { 65587 } }; --Reanimatrox Marzan
	[182318] = { zoneID = 1970, artID = { 1650 }, x = 5960, y = 2129, overlay = { "5920-2040","5920-2200","6080-2040" }, displayID = 100980, questID = { 65583 } }; --General Zarathura <Army of the Endless>
	[183516] = { zoneID = 1970, artID = { 1650 }, x = 4367, y = 7604, overlay = { "4420-7520" }, displayID = 105289, questID = { 65580 } }; --The Engulfer
	[183596] = { zoneID = 1970, artID = { 1650 }, x = 4961, y = 6967, overlay = { "4860-6680","4920-6840","5020-7380","5040-6780","5040-6980","5160-6800","5280-6760","4920-6960","5020-6640","5040-7120","4740-7040" }, displayID = 105144, questID = { 65553 } }; --Chitali the Eldest <Cervid Prime>
	[183646] = { zoneID = 1970, artID = { 1650 }, x = 6450, y = 5861, overlay = { "6420-5840","6300-6020" }, displayID = 98873, questID = { 65544 } }; --Furidian
	[183722] = { zoneID = 1970, artID = { 1650 }, x = 3587, y = 7121, overlay = { "3500-6720","3540-6980","3540-7120" }, displayID = 104968, questID = { 65240 } }; --Sorranos <Vombata Prime>
	[183737] = { zoneID = 1970, artID = { 1650 }, x = 6406, y = 4975, overlay = { "6320-4900" }, displayID = 99094, questID = { 65241 } }; --Xy'rath the Covetous <Cartel Xy>
	[183746] = { zoneID = 1970, artID = { 1650 }, x = 4323, y = 8898, overlay = { "4320-8740","4340-8880","4420-8600","4480-9060" }, displayID = 105175, questID = { 65556 } }; --Otiosen
	[183747] = { zoneID = 1970, artID = { 1650 }, x = 4706, y = 4697, overlay = { "4660-4780","4700-4640" }, displayID = 101903, questID = { 65584 } }; --Vitiane
	[183748] = { zoneID = 1970, artID = { 1650 }, x = 5833, y = 6839, overlay = { "5780-6860","5920-6860","5883-6988" }, displayID = 105231, questID = { 65551 } }; --Helmix
	[183749] = { zoneID = 1970, artID = { 1650 }, x = 5816, y = 6853, overlay = { "5780-6880","5860-6780","5872-7004" }, displayID = 105231, questID = { 65551 } }; --Helmix
	[183764] = { zoneID = 1970, artID = { 1650 }, x = 4352, y = 3294, overlay = { "4340-3300","4140-3300","4300-3420","4380-3180" }, displayID = 105300, questID = { 65251 } }; --Zatojin <Vespoid Prime>
	[183814] = { zoneID = 1970, artID = { 1650 }, x = 5865, y = 4035, overlay = { "5840-3900","5840-4020","5860-3720" }, displayID = 104823, questID = { 65257 } }; --Otaris the Provoked
	[183925] = { zoneID = 1970, artID = { 1650 }, x = 4998, y = 4002, overlay = { "4900-3720","5006-3977","4928-3883","4940-4080","5060-3780" }, displayID = 105599, questID = { 65272 } }; --Tahkwitz
	[183927] = { zoneID = 1970, artID = { 1650 }, x = 5338, y = 4707, overlay = { "5280-4640","5380-4900","5280-4780" }, displayID = 100368, questID = { 65574 } }; --Sand Matriarch Ileus
	[183953] = { zoneID = 1970, artID = { 1650 }, x = 4746, y = 6221, overlay = { "4740-6240","4740-6400" }, displayID = 101972, questID = { 65273 } }; --Corrupted Architect
	[184409] = { zoneID = 1970, artID = { 1650 }, x = 4748, y = 4514, overlay = { "4700-4440","4760-4300" }, displayID = 101907, questID = { 65555 } }; --Euv'ouk
	[184413] = { zoneID = 1970, artID = { 1650 }, x = 4230, y = 2099, overlay = { "4220-2140","4280-2300" }, displayID = 101916, questID = { 65549 } }; --Shifting Stargorger
	[184804] = { zoneID = 1970, artID = { 1650 }, x = 5821, y = 6848, overlay = { "5860-6780","5889-6957","5680-7000" }, displayID = 105231, questID = { 65551 } }; --Helmix
	[179133] = { zoneID = 1987, artID = { 1687 }, x = 6771, y = 5789, overlay = { "6771-5789" }, displayID = 99101 }; --Vil'thras
	[184853] = { zoneID = 2022, artID = { 1706 }, x = 8120, y = 3796, overlay = { "8114-3793" }, displayID = 105190, questID = { 66074 } }; --Primal Scythid Queen
	[186200] = { zoneID = 2022, artID = { 1706 }, x = 4214, y = 3945, overlay = { "4214-3945" }, displayID = 105660, questID = { 74000 } }; --Harkyn Grymstone <Dragon Hunter>
	[186201] = { zoneID = 2022, artID = { 1706 }, x = 4249, y = 3932, overlay = { "4214-3945" }, displayID = 105661, questID = { 74003 }, worldmap = true }; --Groth <Dragon Hunter>
	[186202] = { zoneID = 2022, artID = { 1706 }, x = 4220, y = 3980, overlay = { "4214-3945" }, displayID = 105756, questID = { 74033 }, worldmap = true }; --Voll <Dragon Hunter>
	[186203] = { zoneID = 2022, artID = { 1706 }, x = 4249, y = 3932, overlay = { "4214-3945" }, displayID = 105755, questID = { 74037 }, worldmap = true }; --Snee <Dragon Hunter>
	[186783] = { zoneID = 2022, artID = { 1706 }, x = 3047, y = 5593, overlay = { "2874-6170","2580-5980","3100-5600","2580-5720","2660-5840","2740-6020","2940-5260","3000-5480","2940-5640","3020-5360","3260-5560" }, displayID = 110318, questID = { 74042 } }; --Cauldronbearer Blakor
	[186827] = { zoneID = 2022, artID = { 1706 }, x = 4031, y = 6357, overlay = { "3945-6268","4004-6475","4031-6357" }, displayID = 106302, questID = { 74010 } }; --Magmaton
	[186859] = { zoneID = 2022, artID = { 1706 }, x = 3005, y = 5568, overlay = { "3000-5540" }, displayID = 102449, questID = { 70763 } }; --Worldcarver A'tir
	[187111] = { zoneID = 2022, artID = { 1706 }, x = 7729, y = 2219, overlay = { "7729-2203" }, displayID = 103584, questID = { 72835 } }; --Ancient Hornswog
	[187209] = { zoneID = 2022, artID = { 1706 }, x = 5471, y = 8223, overlay = { "5469-8261" }, displayID = 102923, questID = { 66960 } }; --Klozicc the Ascended
	[187306] = { zoneID = 2022, artID = { 1706 }, x = 3240, y = 5243, overlay = { "3222-5193" }, displayID = 107452, questID = { 74067 } }; --Morchok <Harbinger of Twilight>
	[187598] = { zoneID = 2022, artID = { 1706 }, x = 2832, y = 5898, overlay = { "2520-6000","2580-6120","2680-6240","2720-6120","2920-5920","3040-6080","2620-5840","2820-6000","2840-5820","3160-6200" }, displayID = 102460, questID = { 74052 } }; --Rohzor Forgesmash <Djaradin Smithmaster>
	[187886] = { zoneID = 2022, artID = { 1706 }, x = 3353, y = 5570, overlay = { "3358-5577" }, displayID = 110047, questID = { 74054 } }; --Turboris
	[187945] = { zoneID = 2022, artID = { 1706 }, x = 5867, y = 4014, overlay = { "5864-4022" }, displayID = 110070, questID = { 73865 } }; --Anhydros the Tidetaker
	[189289] = { zoneID = 2022, artID = { 1706 }, x = 2424, y = 5399, overlay = { "2411-5389","2480-5520" }, displayID = 106874, questID = { 74019 } }; --Penumbrus
	[189822] = { zoneID = 2022, artID = { 1706 }, x = 2390, y = 5758, overlay = { "2380-5740" }, displayID = 26776, questID = { 74077 } }; --Shas'ith
	[190718] = { zoneID = 2022, artID = { 1706 }, x = 4695, y = 5735, overlay = { "4703-5771" }, displayID = 105159 }; --Monsoo, The Boiling Rage
	[190985] = { zoneID = 2022, artID = { 1706 }, x = 3042, y = 5357, overlay = { "3183-5439","2982-5709","2660-5780","2760-6100","2880-5520","2900-5820","2940-5360","3080-5300","3120-5640","2540-6060","2620-5900","2640-6200","2720-5600","3240-5560" }, displayID = 109963, questID = { 73074 } }; --Death's Shadow
	[190986] = { zoneID = 2022, artID = { 1706 }, x = 2858, y = 5902, overlay = { "2827-5851","2780-6120","2900-5980","2920-5680","2980-5860" }, displayID = 102630, questID = { 74040 } }; --Battlehorn Pyrhus
	[190991] = { zoneID = 2022, artID = { 1706 }, x = 2969, y = 4884, overlay = { "3021-4876","2880-5080","2960-5280","3140-5200","2840-4960","3000-5580","3060-5400","3180-5420","3000-5100" }, displayID = 107316, questID = { 74043 } }; --Char
	[191611] = { zoneID = 2022, artID = { 1706 }, x = 6425, y = 3320, overlay = { "6417-3289" }, displayID = 107559, questID = { 65994 } }; --Dragonhunter Igordan
	[192362] = { zoneID = 2022, artID = { 1706 }, x = 6460, y = 6940, overlay = { "6460-6940" }, displayID = 103585, questID = { 70864 } }; --Possessive Hornswog
	[192737] = { zoneID = 2022, artID = { 1706 }, x = 3452, y = 7082, overlay = { "3935-6779","4260-7240","4720-7300","4760-7160","4800-6780","5240-6700","4980-6549","5120-6640","5320-6600","4540-7380","4840-6640","3480-7200","3660-7120","3780-6980","4120-6920","4420-7360","4200-7040","3380-7040","3860-6880","4780-6900" }, displayID = 102633, questID = { 73890 } }; --Qalashi War Mammoth <Qalashi War Party>
	[192738] = { zoneID = 2022, artID = { 1706 }, x = 3448, y = 7145, overlay = { "5323-6708","3844-6902","4783-6845","3745-7053","5296-6533","4220-7140","4840-6600","5120-6640","4120-6880","4320-7280","4640-7340","4740-7180","5000-6520","3520-7160","3660-7140","3940-6800","4520-7380","4760-6720","4000-6960","4760-7000" }, displayID = 102465, questID = { 73890 } }; --Brundin the Dragonbane <Qalashi War Party>
	[192741] = { zoneID = 2022, artID = { 1706 }, x = 3500, y = 7160, overlay = { "4084-6855","3896-6863","3642-7174","4200-7140","4760-7180","4780-7060","5124-6646","5280-6580","4280-7240","4640-7340","4780-6900","4800-6640","4980-6540","3500-7160","3740-7000","4180-7000","4780-6760","3380-7120","4420-7340" }, displayID = 102482, questID = { 73890 } }; --Flamebreaker Grella <Qalashi War Party>
	[192743] = { zoneID = 2022, artID = { 1706 }, x = 3471, y = 7160, overlay = { "4260-7264","3905-6864","3742-7171","5309-6701","5120-6640","5320-6580","4200-7100","4640-7340","4780-7120","4820-6620","4940-6520","3520-7160","3740-6980","4420-7320","4760-6740","3380-7120","4140-6980","4760-6900" }, displayID = 102490, questID = { 73890 } }; --Stonefist Rejara <Qalashi War Party>
	[192744] = { zoneID = 2022, artID = { 1706 }, x = 3464, y = 7171, overlay = { "4263-7258","3993-6822","3530-7246","5246-6681","5120-6640","4740-7200","4820-6620","3640-7160","3760-7060","3820-6880","4200-7060","4560-7380","4760-6760","4920-6500","3460-7140","4420-7320","4780-7000" }, displayID = 102011, questID = { 73890 } }; --Scalemelter Dorbane <Qalashi War Party>
	[193118] = { zoneID = 2022, artID = { 1706 }, x = 7975, y = 5350, overlay = { "8146-5036","8137-4894","7983-5358","8223-4808","8088-5201" }, displayID = 67252, questID = { 70983 } }; --O'nank Shorescour
	[193120] = { zoneID = 2022, artID = { 1706 }, x = 6861, y = 6482, overlay = { "6861-6482","6980-6440","6920-6620" }, displayID = 103584, questID = { 69668 } }; --Smogswog the Firebreather
	[193132] = { zoneID = 2022, artID = { 1706 }, x = 6361, y = 5492, overlay = { "6369-5508" }, displayID = 101210, questID = { 73981 } }; --Amethyzar the Glittering
	[193134] = { zoneID = 2022, artID = { 1706 }, x = 2177, y = 6526, overlay = { "2166-6492" }, displayID = 110379, questID = { 73072 } }; --Enkine the Voracious
	[193135] = { zoneID = 2022, artID = { 1706 }, x = 5472, y = 7157, overlay = { "5451-7154" }, displayID = 108091, questID = { 73984 } }; --Azra's Prized Peony
	[193148] = { zoneID = 2022, artID = { 1706 }, x = 4539, y = 3542, overlay = { "4544-3541" }, displayID = 104065, questID = { 73899 } }; --Thunderous Matriarch
	[193152] = { zoneID = 2022, artID = { 1706 }, x = 2159, y = 7644, overlay = { "2140-7654" }, displayID = 103916, questID = { 69848 } }; --Massive Magmashell
	[193154] = { zoneID = 2022, artID = { 1706 }, x = 3311, y = 7629, overlay = { "3311-7629" }, displayID = 110581, questID = { 73073 } }; --Forgotten Gryphon
	[193171] = { zoneID = 2022, artID = { 1706 }, x = 6059, y = 8285, overlay = { "6059-8285" }, displayID = 108102, questID = { 70751 } }; --Terillod the Devout
	[193175] = { zoneID = 2022, artID = { 1706 }, x = 3432, y = 8950, overlay = { "3454-8950","3577-8982" }, displayID = 104032, questID = { 74079 } }; --Slurpo, the Incredible Snail
	[193177] = { zoneID = 2022, artID = { 1706 }, x = 2986, y = 7827, overlay = { "3000-7820","2740-7980","2820-7800","2960-7960" }, displayID = 108103, questID = { 73902 } }; --Beakers
	[193181] = { zoneID = 2022, artID = { 1706 }, x = 4815, y = 1886, overlay = { "3960-4120","3820-3900","4280-3000","4380-2700","4520-2460","4680-2300","4840-1720","3840-4080","4000-3500","4020-3880","4260-3140","4300-2800","4740-1980","4140-3300","4420-2580","3940-3620","4815-1886" }, displayID = 101622, questID = { 73895 } }; --Skewersnout <Raypier of the Deep>
	[193198] = { zoneID = 2022, artID = { 1706 }, x = 2696, y = 7567, overlay = { "2700-7600","2620-7780" }, displayID = 108107, questID = { 72127 } }; --Captain Lancer
	[193217] = { zoneID = 2022, artID = { 1706 }, x = 5350, y = 6162, overlay = { "6860-5160","7280-4700","4720-7700","4920-7380","4980-6960","4980-7220","5160-3560","5220-5060","5360-5320","5520-5820","5900-3760","6360-5860","6760-6020","6920-5480","6920-5680","6920-5960","6960-4260","5000-3980","5060-3720","5080-4820","5320-6040","5440-6040","5480-5660","5700-3660","5960-3880","5980-5060","6020-4360","6020-4580","6040-3980","6120-5460","6500-5980","6760-4940","6860-5320","7340-4540","4920-4380","4920-7540","4980-6820","5000-4640","5280-6240","5340-5180","5480-3520","5540-3660","6000-5180","6240-5660","6780-4480","4940-4100","6040-5340","6960-5840","7060-4860","5080-6660","5200-6340","5440-5460","5960-4900","5980-4720","6020-4180" }, displayID = 103923, questID = { 73874 } }; --Drakewing
	[193226] = { zoneID = 2022, artID = { 1706 }, x = 7862, y = 5108, overlay = { "7880-5133","7855-4991" }, displayID = 108119, questID = { 69874 } }; --Gorjo the Crab Shackler
	[193228] = { zoneID = 2022, artID = { 1706 }, x = 7859, y = 4982, overlay = { "7880-5133","7871-4938" }, displayID = 103423, questID = { 69874 } }; --Snappy
	[193232] = { zoneID = 2022, artID = { 1706 }, x = 2412, y = 5874, overlay = { "3000-6020","2220-5900","2320-5980","2440-5820","3120-6180","2480-5700","2740-6100","2880-5920","2560-5920" }, displayID = 110319, questID = { 74051 } }; --Rasnar the War Ender
	[193256] = { zoneID = 2022, artID = { 1706 }, x = 5600, y = 4592, overlay = { "5600-4592" }, displayID = 108127, questID = { 73888 } }; --Nulltheria the Void Gazer
	[193263] = { zoneID = 2022, artID = { 1706 }, x = 4361, y = 7517, overlay = { "4300-7451" }, displayID = 106367, questID = { 73880 } }; --Helmet Missingway
	[193266] = { zoneID = 2022, artID = { 1706 }, x = 3395, y = 8591, overlay = { "3360-8640" }, displayID = 108200, questID = { 74065 } }; --Lepidoralia the Resplendent
	[193271] = { zoneID = 2022, artID = { 1706 }, x = 4683, y = 7381, overlay = { "4697-7332" }, displayID = 108131, questID = { 70719 } }; --Shadeslash Trakken
	[193634] = { zoneID = 2022, artID = { 1706 }, x = 6559, y = 7395, overlay = { "6560-7380" }, displayID = 103584, questID = { 74084 } }; --Swog'ranka <Lunker>
	[193644] = { zoneID = 2022, artID = { 1706 }, x = 2620, y = 7560, overlay = { "2620-7560" }, displayID = 103250, questID = { 69951 } }; --Bouldron
	[193647] = { zoneID = 2022, artID = { 1706 }, x = 6402, y = 2670, overlay = { "6402-2670","2680-7540" }, displayID = 103249, questID = { 69953 } }; --Karantun
	[193654] = { zoneID = 2022, artID = { 1706 }, x = 2960, y = 5320, overlay = { "2953-5297" }, displayID = 102565, questID = { 73998 } }; --Gravlion <Progeny of Earth>
	[193655] = { zoneID = 2022, artID = { 1706 }, x = 2271, y = 7168, overlay = { "2953-5297","2271-7168" }, displayID = 102546, questID = { 69961 } }; --Frozion <Progeny of Water>
	[193675] = { zoneID = 2022, artID = { 1706 }, x = 2767, y = 7291, overlay = { "2767-7291","6400-2720" }, displayID = 108253, questID = { 69970 } }; --Kain Firebrand
	[193680] = { zoneID = 2022, artID = { 1706 }, x = 3175, y = 5169, overlay = { "3175-5169" }, displayID = 108257, questID = { 69972 } }; --Zurgaz Corebreaker
	[193686] = { zoneID = {
				[2022] = { x = 6680, y = 2720, artID = { 1706 }, overlay = { "6680-2720" } };
				[2024] = { x = 1194, y = 3355, artID = { 1707 }, overlay = { "1194-3355" } };
			  }, displayID = 108262, questID = { 74016 } }; --Neela Firebane
	[193708] = { zoneID = 2022, artID = { 1706 }, x = 3380, y = 6420, overlay = { "3380-6420" }, displayID = 107557, questID = { 74078 } }; --Skald the Impaler <Lunker>
	[193710] = { zoneID = 2022, artID = { 1706 }, x = 6564, y = 7392, overlay = { "6560-7400" }, displayID = 102545, questID = { 74074 } }; --Seereel, the Spring <Lunker>
	[193735] = { zoneID = 2022, artID = { 1706 }, x = 6556, y = 7394, overlay = { "6560-7380" }, displayID = 55833, questID = { 74068 } }; --Moth'go Deeploom <Lunker>
	[194251] = { zoneID = 2022, artID = { 1706 }, x = 4170, y = 8473, overlay = { "4170-8473" }, displayID = 109119, questID = { 70906 } }; --Degmakh
	[195915] = { zoneID = 2022, artID = { 1706 }, x = 5503, y = 2155, overlay = { "5639-2348","5440-2140","5620-2220","5680-2500" }, displayID = 109030, questID = { 70648 } }; --Firava the Rekindler
	[196056] = { zoneID = 2022, artID = { 1706 }, x = 5234, y = 5829, overlay = { "5234-5829" }, displayID = 102545, questID = { 70718 } }; --Gushgut the Beaksinker
	[198571] = { zoneID = {
				[2022] = { x = 5980, y = 6220, artID = { 1706 }, overlay = { "5340-6020","5400-6540","5580-6120","5720-5980","5980-6220","5420-5780","5560-5600","6000-6440" } };
				[2023] = { x = 2900, y = 5360, artID = { 1705 }, overlay = { "2900-5360","2440-6260","2480-6100","2920-5080","3140-5280","3260-5160","3280-5300","6200-5860","6240-6000" } };
				[2024] = { x = 3820, y = 5060, artID = { 1707 }, overlay = { "3820-5060","4020-5960","4400-3260","4720-2560","4820-2320","3840-6240","3920-6080","4060-6300","4440-6040","4460-5540" } };
				[2025] = { x = 3780, y = 6740, artID = { 1708 }, overlay = { "3780-6740","4920-6060","5140-5800" } };
			  }, displayID = 104693 }; --Enraged Sprout
	[187219] = { zoneID = 2023, artID = { 1705 }, x = 5860, y = 4940, overlay = { "5860-4940","6840-4820","6920-5020","6940-4620","6940-5200","6940-5920","6980-5340","7000-5700","7000-6280","7060-4280","7160-4000","7340-3700","7440-3360","6300-5280","6500-5120","7120-4160" }, displayID = 100207 }; --Nokhud Warmaster
	[187559] = { zoneID = 2023, artID = { 1705 }, x = 2982, y = 4116, overlay = { "2994-4107" }, displayID = 105802, questID = { 74075 } }; --Shade of Grief
	[187781] = { zoneID = 2023, artID = { 1705 }, x = 8520, y = 1540, overlay = { "8520-1540" }, displayID = 105443 }; --Hamett <Rockfang Matriarch>
	[188095] = { zoneID = 2023, artID = { 1705 }, x = 8048, y = 4219, overlay = { "8040-4240" }, displayID = 103430, questID = { 73966 } }; --Hunter of the Deep
	[188124] = { zoneID = 2023, artID = { 1705 }, x = 8040, y = 3860, overlay = { "8040-3860" }, displayID = 104874, questID = { 66356 } }; --Irontree
	[188451] = { zoneID = 2023, artID = { 1705 }, x = 7220, y = 2320, overlay = { "7220-2320" }, displayID = 106436, questID = { 73980 } }; --Zerimek <The Darkened Cloud>
	[189652] = { zoneID = 2023, artID = { 1705 }, x = 3042, y = 6654, overlay = { "2940-6780","3160-6820","3040-6620" }, displayID = 108096, questID = { 73872 } }; --Deadwaker Ghendish
	[191354] = { zoneID = 2023, artID = { 1705 }, x = 2607, y = 3413, overlay = { "2607-3413" }, displayID = 107453, questID = { 70143 } }; --Ty'foon the Ascended
	[191450] = { zoneID = 2023, artID = { 1705 }, x = 8723, y = 1353, overlay = { "8723-1353" }, displayID = 107239, questID = { 73909 } }; --Boolk
	[191842] = { zoneID = 2023, artID = { 1705 }, x = 7829, y = 8264, overlay = { "7829-8276" }, displayID = 82266, questID = { 73974 } }; --Sulfurion
	[192020] = { zoneID = 2023, artID = { 1705 }, x = 4965, y = 6671, overlay = { "4909-6673","5060-6700" }, displayID = 105345, questID = { 74063 } }; --Eaglemaster Niraak
	[192045] = { zoneID = 2023, artID = { 1705 }, x = 5861, y = 6845, overlay = { "5860-6820","5900-6680","6000-6520" }, displayID = 105359, questID = { 74088 } }; --Windseeker Avash
	[192364] = { zoneID = 2023, artID = { 1705 }, x = 8434, y = 4794, overlay = { "8420-4780" }, displayID = 107650, questID = { 73979 } }; --Windscale the Stormborn
	[192453] = { zoneID = 2023, artID = { 1705 }, x = 8337, y = 6231, overlay = { "8260-6360","8380-6560","8246-6601","8020-6320","8140-6540","8520-6140","8337-6231" }, displayID = 101440, questID = { 73978 } }; --Vaniik the Stormtouched <Corrupted Child of Ohn'ahra>
	[192949] = { zoneID = 2023, artID = { 1705 }, x = 4489, y = 4922, overlay = { "4487-4923" }, displayID = 105450, questID = { 70783 } }; --Skaara
	[192983] = { zoneID = 2023, artID = { 1705 }, x = 4322, y = 5055, overlay = { "4340-5040" }, displayID = 108030, questID = { 67717 } }; --Web-Queen Ashkaz
	[193123] = { zoneID = 2023, artID = { 1705 }, x = 5352, y = 7290, overlay = { "5342-7266" }, displayID = 103430, questID = { 74034 } }; --Steamgill
	[193128] = { zoneID = 2023, artID = { 1705 }, x = 9020, y = 4020, overlay = { "9020-4020" }, displayID = 108120, questID = { 73869 } }; --Blightpaw the Depraved
	[193133] = { zoneID = 2023, artID = { 1705 }, x = 6304, y = 4854, overlay = { "6304-4854" }, displayID = 105964, questID = { 69837 } }; --Sunscale Behemoth
	[193136] = { zoneID = 2023, artID = { 1705 }, x = 4966, y = 7613, overlay = { "4968-7649","4980-7440","5060-7560" }, displayID = 108083, questID = { 73893 } }; --Scav Notail
	[193140] = { zoneID = 2023, artID = { 1705 }, x = 3025, y = 6241, overlay = { "3020-6260" }, displayID = 104144, questID = { 72364 } }; --Zarizz
	[193142] = { zoneID = 2023, artID = { 1705 }, x = 5674, y = 8140, overlay = { "5671-8128" }, displayID = 102564, questID = { 69840 } }; --Enraged Sapphire
	[193153] = { zoneID = 2023, artID = { 1705 }, x = 2633, y = 6544, overlay = { "2635-6533" }, displayID = 105185, questID = { 69851 } }; --Ripsaw the Stalker
	[193163] = { zoneID = 2023, artID = { 1705 }, x = 2329, y = 6706, overlay = { "2284-6762","2240-6600" }, displayID = 103430, questID = { 69852 } }; --Territorial Coastling
	[193165] = { zoneID = 2023, artID = { 1705 }, x = 2100, y = 3867, overlay = { "2240-3960","2040-3800","2140-3880" }, displayID = 108098, questID = { 73896 } }; --Sparkspitter Vrak
	[193166] = { zoneID = 2023, artID = { 1705 }, x = 2996, y = 4103, overlay = { "2996-4103" }, displayID = 108097, questID = { 74075 }, worldmap = true }; --Solethus's Gravestone
	[193168] = { zoneID = 2023, artID = { 1705 }, x = 7249, y = 5607, overlay = { "7260-5560" }, displayID = 108100, questID = { 73903 } }; --Biryuk
	[193170] = { zoneID = 2023, artID = { 1705 }, x = 7518, y = 4747, overlay = { "7440-4760","7500-4580","7560-4760" }, displayID = 100698, questID = { 73994 } }; --Fulgurb
	[193173] = { zoneID = 2023, artID = { 1705 }, x = 6289, y = 7977, overlay = { "6302-7988" }, displayID = 102874, questID = { 69857 } }; --Mikrin of the Raging Winds
	[193188] = { zoneID = 2023, artID = { 1705 }, x = 6187, y = 1293, overlay = { "6180-1283" }, displayID = 108106, questID = { 73894 } }; --Seeker Teryx
	[193209] = { zoneID = 2023, artID = { 1705 }, x = 3145, y = 6392, overlay = { "3145-6392" }, displayID = 101441, questID = { 73901 } }; --Zenet Avis <The Hard Wind>
	[193212] = { zoneID = 2023, artID = { 1705 }, x = 7194, y = 4633, overlay = { "7145-4607" }, displayID = 108116, questID = { 69871 } }; --Malsegan
	[193215] = { zoneID = 2023, artID = { 1705 }, x = 1992, y = 4375, overlay = { "1980-4480","2020-4340" }, displayID = 108109, questID = { 74073 } }; --Scaleseeker Mezeri
	[193227] = { zoneID = 2023, artID = { 1705 }, x = 4336, y = 5558, overlay = { "4314-5572","4360-5440","4400-5680" }, displayID = 108122, questID = { 74026 } }; --Ronsak the Decimator
	[193231] = { zoneID = 2023, artID = { 1705 }, x = 9037, y = 3999, overlay = { "9000-4000" }, displayID = 104750, questID = { 73869 } }; --Ancient Tundrafur
	[193235] = { zoneID = 2023, artID = { 1705 }, x = 6108, y = 2470, overlay = { "5955-2293","6108-2470","5860-2640","6020-2640","6100-2820","6120-2940" }, displayID = 105489, questID = { 69877 } }; --Oshigol
	[193254] = { zoneID = 2023, artID = { 1705 }, x = 6609, y = 4288, overlay = { "6707-4368","6575-4321","6440-4400","6640-4220" }, displayID = 108129, questID = { 73904 } }; --Bloodgullet
	[193645] = { zoneID = 2023, artID = { 1705 }, x = 5898, y = 0101, overlay = { "3373-3375","3550-3683","5546-0206","5898-0101" }, displayID = 106437, questID = { 69952 } }; --Crystalus
	[193669] = { zoneID = 2023, artID = { 1705 }, x = 5991, y = 6694, overlay = { "5991-6694" }, displayID = 108251, questID = { 69968 } }; --Prozela Galeshot <Stormcaller Headmaster>
	[194409] = { zoneID = 2023, artID = { 1707 }, x = 5754, y = 4762, overlay = { "5754-4762" }, displayID = 105961 }; --Ergburk
	[194438] = { zoneID = 2023, artID = { 1705 }, x = 4823, y = 4873, overlay = { "4823-4873" }, displayID = 103769, questID = { 73921 } }; --Khomuur
	[194458] = { zoneID = 2023, artID = { 1705 }, x = 5576, y = 5069, overlay = { "5576-5069" }, displayID = 108306, questID = { 73930 } }; --Rokzul
	[194601] = { zoneID = 2023, artID = { 1705 }, x = 7712, y = 5164, overlay = { "7712-5164" }, displayID = 103765, questID = { 73948 } }; --Zagdech
	[195186] = { zoneID = 2023, artID = { 1705 }, x = 3148, y = 7635, overlay = { "3140-7620" }, displayID = 108793, questID = { 73950 } }; --Cinta the Forgotten
	[195204] = { zoneID = 2023, artID = { 1705 }, x = 2770, y = 5556, overlay = { "2740-5580" }, displayID = 108800, questID = { 73976 } }; --The Jolly Giant
	[195223] = { zoneID = 2023, artID = { 1705 }, x = 4239, y = 4455, overlay = { "4280-4103","4240-4480" }, displayID = 104703, questID = { 73973 } }; --Rustlily <Nimblewing Matriarch>
	[195409] = { zoneID = 2023, artID = { 1705 }, x = 3260, y = 3740, overlay = { "3260-3740","3240-3880" }, displayID = 108890 }; --Makhra the Ashtouched <Corrupted Child of Ohn'ahra>
	[195895] = { zoneID = 2023, artID = { 1705 }, x = 6683, y = 5900, overlay = { "6040-7140","6540-6520","5820-7200","6000-7540","6120-7040","6520-6640","6520-6900","6600-5880","6700-6280","6720-5180","6720-5780","6760-5660","6860-5160","5780-7360","6120-7580","6300-6980","6580-6080","6620-6400","6740-5300","6860-5300","6880-5560","5840-7480","6520-7060","6540-7400","6560-6220","5800-7000","6380-7600" }, displayID = 108783, questID = { 74093 } }; --Nergazurai
	[196010] = { zoneID = 2023, artID = { 1705 }, x = 3712, y = 5378, overlay = { "3614-5309","3700-5400" }, displayID = 107531, questID = { 70698 } }; --Researcher Sneakwing <The Sundered Flame>
	[197009] = { zoneID = 2023, artID = { 1705 }, x = 8747, y = 6156, overlay = { "8740-6140" }, displayID = 104005, questID = { 73882 } }; --Liskheszaera
	[186962] = { zoneID = 2024, artID = { 1707 }, x = 2330, y = 3350, overlay = { "2351-3282" }, displayID = 106017, questID = { 72836 } }; --Cascade
	[190244] = { zoneID = 2024, artID = { 1707 }, x = 3630, y = 3567, overlay = { "3579-3724","3651-3508","3700-3680","3960-3840","3700-3280" }, displayID = 104875, questID = { 73883 } }; --Mahg the Trampler
	[191356] = { zoneID = 2024, artID = { 1707 }, x = 5833, y = 4377, overlay = { "5820-4380" }, displayID = 103182, questID = { 73877 } }; --Frostpaw
	[192749] = { zoneID = 2024, artID = { 1707 }, x = 3677, y = 3247, overlay = { "3678-3248" }, displayID = 103643, questID = { 69599 } }; --Sharpfang
	[193116] = { zoneID = 2024, artID = { 1707 }, x = 7305, y = 2662, overlay = { "7317-2635" }, displayID = 101445, questID = { 73868 } }; --Beogoka
	[193149] = { zoneID = 2024, artID = { 1707 }, x = 2649, y = 4939, overlay = { "2649-4939" }, displayID = 104874, questID = { 72154 } }; --Skag the Thrower
	[193157] = { zoneID = 2024, artID = { 1707 }, x = 2767, y = 4563, overlay = { "2780-4580","2655-4650","2640-4520","2760-4780" }, displayID = 107559, questID = { 73873 } }; --Dragonhunter Gorund
	[193178] = { zoneID = 2024, artID = { 1707 }, x = 1345, y = 2248, overlay = { "1340-2240" }, displayID = 105638, questID = { 74058 } }; --Blightfur
	[193196] = { zoneID = 2024, artID = { 1707 }, x = 7027, y = 2513, overlay = { "7027-2492" }, displayID = 107933, questID = { 74087 } }; --Trilvarus Loreweaver
	[193201] = { zoneID = 2024, artID = { 1707 }, x = 5740, y = 5445, overlay = { "5740-5380" }, displayID = 108113, questID = { 73885 } }; --Mucka the Raker
	[193214] = { zoneID = 2024, artID = { 1707 }, x = 3817, y = 5902, overlay = { "3817-5902" }, displayID = 104019, questID = { 69864 } }; --Forgotten Creation
	[193223] = { zoneID = 2024, artID = { 1707 }, x = 1742, y = 4133, overlay = { "1736-4118" }, displayID = 108121, questID = { 69872 } }; --Vakril <The Strongest Tuskarr?>
	[193225] = { zoneID = {
				[2024] = { x = 3436, y = 2779, artID = { 1707 }, overlay = { "3436-2779" } };
				[2132] = { x = 4629, y = 3658, artID = { 1774 }, overlay = { "4629-3658" } };
			  }, displayID = 103446, questID = { 73887 } }; --Notfar the Unbearable
	[193238] = { zoneID = 2024, artID = { 1707 }, x = 5500, y = 3411, overlay = { "5503-3407" }, displayID = 108125, questID = { 74082 } }; --Spellwrought Snowman
	[193251] = { zoneID = 2024, artID = { 1707 }, x = 3260, y = 2920, overlay = { "3260-2920" }, displayID = 106545, questID = { 69885 } }; --Gruffy
	[193259] = { zoneID = 2024, artID = { 1707 }, x = 1650, y = 2790, overlay = { "1666-2786" }, displayID = 106536, questID = { 73870 } }; --Blue Terror
	[193269] = { zoneID = 2024, artID = { 1707 }, x = 1933, y = 4335, overlay = { "1933-4335" }, displayID = 104743, questID = { 69892 } }; --Grumbletrunk
	[193288] = { zoneID = 2024, artID = { 1707 }, x = 7014, y = 3362, overlay = { "7013-3327" }, displayID = 102563, questID = { 69895 } }; --Summoned Destroyer
	[193632] = { zoneID = 2024, artID = { 1707 }, x = 5942, y = 5516, overlay = { "5940-5520","6020-5620" }, displayID = 102545, questID = { 73900 } }; --Wilrive
	[193648] = { zoneID = 2024, artID = { 1707 }, x = 4698, y = 2305, overlay = { "1023-3026","4698-2305","5880-6840" }, displayID = 106023, questID = { 69954 } }; --Infernum
	[193650] = { zoneID = 2024, artID = { 1707 }, x = 1109, y = 3065, overlay = { "1109-3065" }, displayID = 102544, questID = { 69955 } }; --Emblazion <Progeny of Fire>
	[193653] = { zoneID = 2024, artID = { 1707 }, x = 4340, y = 3140, overlay = { "4340-3140" }, displayID = 102567, questID = { 69959 } }; --Gaelzion <Progeny of Air>
	[193677] = { zoneID = 2024, artID = { 1707 }, x = 1382, y = 3091, overlay = { "1382-3091","4860-2520" }, displayID = 108254, questID = { 69971 } }; --Maeleera <First Iceblade>
	[193679] = { zoneID = 2024, artID = { 1707 }, x = 4840, y = 2540, overlay = { "4840-2540" }, displayID = 108256 }; --Leerain <Third Iceblade>
	[193684] = { zoneID = 2024, artID = { 1707 }, x = 1208, y = 3332, overlay = { "1208-3332" }, displayID = 108260, questID = { 69974 } }; --Pipspark Thundersnap
	[193685] = { zoneID = 2024, artID = { 1707 }, x = 1177, y = 3297, overlay = { "1177-3297","6020-6680" }, displayID = 108261 }; --Chargum
	[193691] = { zoneID = 2024, artID = { 1707 }, x = 4923, y = 3843, overlay = { "4946-3607","4975-3803" }, displayID = 108266, questID = { 72730 } }; --Fisherman Tinnak <Angered Ghost>
	[193698] = { zoneID = 2024, artID = { 1707 }, x = 6500, y = 2998, overlay = { "6480-3000" }, displayID = 100223, questID = { 73876 } }; --Frigidpelt Den Mother
	[193706] = { zoneID = 2024, artID = { 1707 }, x = 5880, y = 3240, overlay = { "5860-3280" }, displayID = 101244 }; --Snufflegust <Lunker>
	[194210] = { zoneID = 2024, artID = { 1707 }, x = 5478, y = 3246, overlay = { "4944-3822","5259-3610","5093-3489","5498-3201","5220-3420","5000-3700","5320-3280","5680-3020","5940-3060","6160-3120","5840-3140","5440-3340","6040-3240","5380-3120","5560-3080","5620-3200" }, displayID = 108410, questID = { 73867 } }; --Azure Pathfinder
	[194270] = { zoneID = 2024, artID = { 1707 }, x = 5295, y = 3570, overlay = { "5294-3571" }, displayID = 69705, questID = { 73866 } }; --Arcane Devourer
	[194390] = { zoneID = 2024, artID = { 1707 }, x = 0874, y = 4873, overlay = { "0880-4860" }, displayID = 102556, questID = { 73871 } }; --Barnacle Brashe
	[194392] = { zoneID = 2024, artID = { 1707 }, x = 0888, y = 4858, overlay = { "0880-4860" }, displayID = 103415, questID = { 73871 } }; --Brackle
	[194760] = { zoneID = 2024, artID = { 1707 }, x = 3566, y = 3644, overlay = { "3566-3644" }, displayID = 106545, questID = { 73944 } }; --Uurhilt
	[195093] = { zoneID = 2024, artID = { 1707 }, x = 6667, y = 2785, overlay = { "6667-2785" }, displayID = 68370, questID = { 73926 } }; --Moskhoi
	[195101] = { zoneID = 2024, artID = { 1707 }, x = 6967, y = 2574, overlay = { "6967-2574" }, displayID = 100344, questID = { 73946 } }; --Yaankhi
	[195132] = { zoneID = 2024, artID = { 1707 }, x = 7299, y = 2736, overlay = { "7299-2736" }, displayID = 105554, questID = { 73939 } }; --Tevgai
	[195283] = { zoneID = 2024, artID = { 1707 }, x = 6619, y = 5159, overlay = { "6619-5159" }, displayID = 106545, questID = { 73947 } }; --Yamakh
	[195300] = { zoneID = 2024, artID = { 1707 }, x = 6638, y = 5956, overlay = { "6638-5956" }, displayID = 74166, questID = { 73907 } }; --Arkhuu
	[195353] = { zoneID = 2024, artID = { 1707 }, x = 2601, y = 4761, overlay = { "2880-4720","2500-4640","2600-4740","2620-4520","2660-4860","2700-4420","2800-4820","2820-4560","2980-4620" }, displayID = 108873 }; --Breezebiter
	[197344] = { zoneID = 2024, artID = { 1707 }, x = 1109, y = 3235, overlay = { "1127-3241","1220-3360" }, displayID = 105677, questID = { 74032 } }; --Snarglebone
	[197353] = { zoneID = 2024, artID = { 1707 }, x = 1376, y = 3092, overlay = { "1378-3098" }, displayID = 1083, questID = { 73985 } }; --Blisterhide <The Infested>
	[197354] = { zoneID = 2024, artID = { 1707 }, x = 1404, y = 3780, overlay = { "1408-3746","1474-3898" }, displayID = 54677, questID = { 73996 } }; --Gnarls
	[197356] = { zoneID = 2024, artID = { 1707 }, x = 1620, y = 3357, overlay = { "1621-3364" }, displayID = 106068, questID = { 74004 } }; --High Shaman Rotknuckle
	[197371] = { zoneID = 2024, artID = { 1707 }, x = 5860, y = 3280, overlay = { "5860-3280" }, displayID = 101244, questID = { 73891 } }; --Snufflegust <Lunker>
	[197557] = { zoneID = 2024, artID = { 1707 }, x = 1360, y = 4860, overlay = { "1360-4860" }, displayID = 102530, questID = { 70893 } }; --Bisquius
	[198004] = { zoneID = 2024, artID = { 1707 }, x = 4044, y = 4798, overlay = { "4040-4840" }, displayID = 109796, questID = { 73884 } }; --Mange the Outcast
	[183984] = { zoneID = 2025, artID = { 1708 }, x = 4636, y = 7304, overlay = { "4700-7280","4740-7160" }, displayID = 64922, questID = { 74086 } }; --The Weeping Vilomah
	[191305] = { zoneID = 2025, artID = { 1708 }, x = 3833, y = 6852, overlay = { "3842-6823" }, displayID = 105964, questID = { 74085 } }; --The Great Shellkhan
	[193125] = { zoneID = 2025, artID = { 1708 }, x = 5331, y = 4101, overlay = { "5300-4140" }, displayID = 105553, questID = { 73878 } }; --Goremaul the Gluttonous
	[193126] = { zoneID = 2025, artID = { 1708 }, x = 5808, y = 8142, overlay = { "5780-8380","5760-8260","5780-8140","6000-8340","6160-8100","5880-8040","6000-8080" }, displayID = 108093, questID = { 73881 } }; --Innumerable Ruination
	[193127] = { zoneID = 2025, artID = { 1708 }, x = 3760, y = 8528, overlay = { "3759-8553","3740-8240","3760-8420","3740-8680" }, displayID = 108133, questID = { 70986 } }; --Private Shikzar
	[193130] = { zoneID = 2025, artID = { 1708 }, x = 3750, y = 7878, overlay = { "3761-7870" }, displayID = 104007, questID = { 73889 } }; --Pleasant Alpha
	[193143] = { zoneID = 2025, artID = { 1708 }, x = 5000, y = 4960, overlay = { "5000-4960","5060-4600","5080-4760","5200-4420","5340-4300","5200-4580" }, displayID = 104007 }; --Razk'vex the Untamed
	[193146] = { zoneID = 2025, artID = { 1708 }, x = 3502, y = 7001, overlay = { "3502-7001" }, displayID = 108084, questID = { 70947 } }; --Treasure-Mad Trambladd
	[193161] = { zoneID = 2025, artID = { 1708 }, x = 4780, y = 4980, overlay = { "4780-4980" }, displayID = 108094, questID = { 69850 } }; --Woolfang
	[193176] = { zoneID = 2025, artID = { 1708 }, x = 3738, y = 7791, overlay = { "3738-7791" }, displayID = 102549, questID = { 69859 } }; --Sandana the Tempest <Timesand Thief>
	[193210] = { zoneID = 2025, artID = { 1708 }, x = 5852, y = 8491, overlay = { "5720-8420","5820-8620","5740-8280","5852-8491" }, displayID = 6914, questID = { 74021 } }; --Phleep <Time-Lost, Mind-Lost>
	[193220] = { zoneID = 2025, artID = { 1708 }, x = 5988, y = 7064, overlay = { "5988-7064" }, displayID = 34437, questID = { 69868 } }; --Broodweaver Araznae <Mother of Spiders>
	[193229] = { zoneID = 2025, artID = { 1708 }, x = 5579, y = 7725, overlay = { "5558-7749","5564-7624" }, displayID = 108123, questID = { 69873 } }; --Henlare
	[193234] = { zoneID = 2025, artID = { 1708 }, x = 4912, y = 5091, overlay = { "4767-5115","4940-5040","4940-5160" }, displayID = 100334, questID = { 73990 } }; --Eldoren the Reborn <Jewel of the Skies>
	[193240] = { zoneID = 2025, artID = { 1708 }, x = 4000, y = 7010, overlay = { "4020-7017" }, displayID = 103546, questID = { 74024 } }; --Riverwalker Tamopo <Terror of the Shallows>
	[193241] = { zoneID = 2025, artID = { 1708 }, x = 6224, y = 8172, overlay = { "6220-8160" }, displayID = 69326, questID = { 74066 } }; --Lord Epochbrgl <Time-Lost>
	[193243] = { zoneID = 2025, artID = { 1708 }, x = 4048, y = 7800, overlay = { "3905-7564","4060-7460","3660-7640","3940-7700","3960-8000","4048-7800","3740-7800","3820-7900","3760-7540" }, displayID = 108126, questID = { 72114 } }; --Acrosoth
	[193246] = { zoneID = 2025, artID = { 1708 }, x = 5288, y = 5923, overlay = { "5285-5908" }, displayID = 103429, questID = { 74013 } }; --Matriarch Remalla <Temple Menace>
	[193258] = { zoneID = 2025, artID = { 1708 }, x = 4736, y = 7986, overlay = { "4954-7946","4519-7940","4736-7986","5020-7840","4820-7820","5220-8420" }, displayID = 107903, questID = { 69886 } }; --Tempestrian <Stormbringer>
	[193273] = { zoneID = 2025, artID = { 1708 }, x = 3643, y = 7234, overlay = { "3677-7285" }, displayID = 107366, questID = { 72116 } }; --Liskron the Dazzling
	[193652] = { zoneID = 2025, artID = { 1708 }, x = 5940, y = 6160, overlay = { "5880-6120" }, displayID = 101447, questID = { 69956 } }; --Grizzlerock
	[193658] = { zoneID = 2025, artID = { 1708 }, x = 4484, y = 6921, overlay = { "4487-6906" }, displayID = 107595, questID = { 74060 } }; --Corrupted Proto-Dragon
	[193663] = { zoneID = 2025, artID = { 1708 }, x = 5310, y = 6756, overlay = { "5287-6749","4540-8500" }, displayID = 102507, questID = { 69964 } }; --Craggravated Elemental
	[193664] = { zoneID = 2025, artID = { 1708 }, x = 5890, y = 5890, overlay = { "5954-5917" }, displayID = 6089, questID = { 74055 } }; --Ancient Protector
	[193666] = { zoneID = 2025, artID = { 1708 }, x = 5000, y = 5180, overlay = { "5000-5180" }, displayID = 106316, questID = { 69966 } }; --Rokmur
	[193668] = { zoneID = 2025, artID = { 1708 }, x = 3682, y = 8575, overlay = { "3679-8557" }, displayID = 108250, questID = { 69967 } }; --Lookout Mordren
	[193682] = { zoneID = 2025, artID = { 1708 }, x = 0940, y = 2697, overlay = { "6151-6051","0984-2346","0940-2697" }, displayID = 108259, questID = { 74027 } }; --Rouen Icewind
	[193687] = { zoneID = 2025, artID = { 1708 }, x = 6160, y = 6051, overlay = { "6163-6058" }, displayID = 108263 }; --Mawgor
	[193688] = { zoneID = 2025, artID = { 1708 }, x = 6004, y = 6103, overlay = { "6026-6106" }, displayID = 106689, questID = { 74020 } }; --Phenran
	[195417] = { zoneID = 2025, artID = { 1708 }, x = 5003, y = 4790, overlay = { "5003-4790" }, displayID = 105560, questID = { 73942 } }; --Tsokorg
	[195430] = { zoneID = 2025, artID = { 1708 }, x = 5096, y = 4790, overlay = { "5096-4953" }, displayID = 103588, questID = { 73925 } }; --Molkeej
	[197411] = { zoneID = 2025, artID = { 1708 }, x = 5720, y = 6560, overlay = { "5720-6560" }, displayID = 102509 }; --Astray Splasher <Lunker>
	[181427] = { zoneID = {
				[2026] = { x = 5560, y = 4400, artID = { 1709 }, overlay = { "5520-4320","5600-4500","5500-4140" } };
				[2118] = { x = 5555, y = 4374, artID = { 1709 }, overlay = { "5555-4374" } };
			  }, displayID = 108009, questID = { 64859 } }; --Stormspine
	[181833] = { zoneID = {
				[2026] = { x = 7240, y = 3820, artID = { 1709 }, overlay = { "7240-3820","7100-3720","7460-4000","7600-3860" } };
				[2118] = { x = 7209, y = 3814, artID = { 1709 }, overlay = { "7209-3814" } };
			  }, displayID = 102561, questID = { 64971 } }; --Shimmermaw
	[182280] = { zoneID = {
				[2026] = { x = 7860, y = 7520, artID = { 1709 }, overlay = { "7840-7460","7940-7360","7960-7480","7840-7200" } };
				[2118] = { x = 7922, y = 7494, artID = { 1709 }, overlay = { "7922-7494" } };
			  }, displayID = 106940, questID = { 66973 } }; --Tazenrath <Brood of the Incarnate>
	[186355] = { zoneID = {
				[2026] = { x = 5780, y = 5940, artID = { 1709 }, overlay = { "5700-5920","5860-5920","5980-5920","5780-6060","6100-5920" } };
				[2118] = { x = 5757, y = 6023, artID = { 1709 }, overlay = { "5757-6023" } };
			  }, displayID = 103889, questID = { 65910 } }; --Tripletath the Lost
	[191713] = { zoneID = {
				[2026] = { x = 2860, y = 3580, artID = { 1709 }, overlay = { "2840-3640","2960-3720" } };
				[2118] = { x = 2885, y = 3681, artID = { 1709 }, overlay = { "2885-3681" } };
			  }, displayID = 105190, questID = { 66967 } }; --Scytherin
	[191729] = { zoneID = {
				[2026] = { x = 3320, y = 4240, artID = { 1709 }, overlay = { "3320-4120","3320-4240","3400-4360" } };
				[2118] = { x = 3317, y = 4160, artID = { 1709 }, overlay = { "3317-4160" } };
			  }, displayID = 104703, questID = { 66966 } }; --Deathrip
	[191746] = { zoneID = {
				[2026] = { x = 5640, y = 6360, artID = { 1709 }, overlay = { "5580-6640","5640-6360","5680-6540","5720-6200","5540-6500","5840-6420","5780-6620" } };
				[2118] = { x = 5561, y = 6512, artID = { 1709 }, overlay = { "5561-6512" } };
			  }, displayID = 107479, questID = { 66975 } }; --Ketess the Pillager
	[195851] = { zoneID = 2093, artID = { 1756 }, displayID = 109035 }; --Ukhel Deathspeaker
}
