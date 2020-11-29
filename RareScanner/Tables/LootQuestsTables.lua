---------------------------------------------------- 
--AddOn namespace.
---------------------------------------------------- 

local FOLDER_NAME, private = ...
	
private.LOOT_QUEST_IDS = {
	[60989] = { 26620 }; --Wolf Skirt Steak
	[5179] = { 927 }; --Moss-twined Heart
	[5168] = { 922,918 }; --Timberling Seed
	[3409] = { 488 }; --Nightsaber Fang
	[4759] = { 748 }; --Plainstrider Talon
	[8705] = { 2766 }; --OOX-22/FE Distress Beacon
	[8704] = { 485 }; --OOX-09/HL Distress Beacon
	[8623] = { 351 }; --OOX-17/TN Distress Beacon
	[5086] = { 845 }; --Zhevra Hooves
	[50371] = { 24691 }; --Silithid Leg
	[46380] = { 13903,13917 }; --Silithid Meat
	[6443] = { 1486 }; --Deviate Hide
	[57990] = { 26269 }; --Green Hills of Stranglethorn - Page 14
	[142377] = { 45044 }; --Badly Broken Dark Spear
	[11477] = { 4300 }; --White Ravasaur Claw
	[2794] = { 337 }; --An Old History Book
	[5030] = { 855 }; --Centaur Bracers
	[5204] = { 937 }; --Bloodfeather Belt
	[5884] = { 1206 }; --Unpopped Darkmist Eye
	[5959] = { 1322 }; --Acidic Venom Sac
	[8973] = { 2821,2822 }; --Thick Yeti Hide
	[68663] = { 29034,29040 }; --Winterspring Cat Toy
	[1357] = { 26353 }; --Captain Sanders' Treasure Map
	[5481] = { 6441,1032 }; --Satyr Horns
	[5847] = { 1177 }; --Mirefin Head
	[5803] = { 1116 }; --Speck of Dream Dust
	[4503] = { 691 }; --Witherbark Tusk
	[28513] = { 10144,10208 }; --Demonic Rune Stone
	[31655] = { 10852 }; --Veil Skith Prison Key
	[24427] = { 9801 }; --Fen Strider Tentacle
	[34084] = { 11455 }; --Bear Musk
	[35648] = { 11941 }; --Scintillating Fragment
	[42104] = { 12959 }; --Northern Ivory
	[60755] = { 27030 }; --Fluffy Fox Tail
	[60754] = { 27028 }; --Glassy Hornet Wing
	[60204] = { 26707 }; --Corpseweed
	[56083] = { 25849 }; --Fossilized Bone
	[60511] = { 26928 }; --Murloc Scent Gland
	[61307] = { 27475 }; --Servitor Core
	[60402] = { 26842 }; --Mosshide Ear
	[56081] = { 25867 }; --Trapper's Key
	[105715] = { 33338,33336 }; --Epoch Stone
	[86542] = { 31443 }; --Flying Tiger Gourami
	[86545] = { 31446 }; --Mimic Octopus
	[86544] = { 31444 }; --Spinefish Alpha
	[113294] = { 35683,35684 }; --Sargerei Insignia
	[115343] = { 36309 }; --Haephest's Satchel
	[114024] = { 36084 }; --Botani Bloom
	[114025] = { 36086 }; --Botani Bloom
	[103994] = { 35188 }; --Wooden Spear
	[113492] = { 35840,35846 }; --Frostfire Mission Orders
	[113494] = { 35840,35846 }; --Shadowmoon Mission Orders
	[113493] = { 35840,35846 }; --Spires of Arak Mission Orders
	[114029] = { 36092 }; --Ancient Branch
	[114030] = { 36094 }; --Ancient Branch
	[114972] = { 36236 }; --Cryptic Tome of Tailoring
	[115507] = { 36408 }; --Drained Crystal Fragment
	[115013] = { 36266 }; --Ceremonial Shadowmoon Robes
	[114018] = { 36075 }; --Worn Ogron Horn
	[114019] = { 36076 }; --Worn Ogron Horn
	[113590] = { 35948 }; --Acid-Stained Goren Tooth
	[113586] = { 35944 }; --Acid-Stained Goren Tooth
	[113103] = { 35342 }; --Mysterious Flask
	[115590] = { 36417 }; --Damaged Hexweave
	[114877] = { 36176 }; --Dirty Note
	[110714] = { 34512 }; --Saberon Claw
	[115278] = { 36286 }; --Gnomish Location Transponder
	[114037] = { 36105 }; --Elemental Crystal
	[114038] = { 36106 }; --Elemental Crystal
	[115593] = { 36435 }; --Illegible Sootstained Notes
	[105891] = { 33354 }; --Moonfang's Pelt
	[97979] = { 32839 }; --The Bear and the Lady Fair
	[97982] = { 32845 }; --Vial of Reddish Ooze
	[110438] = { 34321 }; --Pile of Elemental Ash
	[114996] = { 36221 }; --Blood Stone
	[114023] = { 36083 }; --Gronn Eye
	[114022] = { 36081 }; --Gronn Eye
	[114032] = { 36097 }; --Ravager Claw
	[114031] = { 36096 }; --Ravager Claw
	[113458] = { 35817 }; --Ebony Feather
	[113459] = { 35818 }; --Ebony Feather
	[128232] = { 39356 }; --Equipment Blueprint: High Intensity Fog Lights
	[128256] = { 39364 }; --Equipment Blueprint: Gyroscopic Internal Stabilizer
	[128258] = { 39366 }; --Equipment Blueprint: Felsmoke Launchers
	[126950] = { 38932 }; --Equipment Blueprint: Bilge Pump
	[128231] = { 39355 }; --Equipment Blueprint: Trained Shark Tank
	[128255] = { 39363 }; --Equipment Blueprint: Ice Cutter
	[128252] = { 39360 }; --Equipment Blueprint: True Iron Rudder
	[128346] = { 39432,39433 }; --Fel-Corrupted Apexis Fragment
	[128428] = { 39509,39567 }; --Bleeding Hollow Ritual Blade
	[127006] = { 38453,38560 }; --Bleeding Hollow Hunting Map
	[128438] = { 39529,39582 }; --Tanaan Jungle Tooth
	[128431] = { 39511,39569 }; --Vial of Fel Blood
	[128257] = { 39365 }; --Equipment Blueprint: Ghostly Spyglass
	[114984] = { 36239 }; --Mysterious Satchel
	[128429] = { 39510,39568 }; --Iron Horde Naval Manifest
	[128432] = { 39512,39570 }; --Shadow Council Missive
	[139534] = { 42350 }; --Bloody Letter
	[139532] = { 42345 }; --Fevered Prayer
	[139533] = { 42340 }; --Singed Plea
	[139531] = { 42058 }; --Crumpled Request
	[139524] = { 42333 }; --Crumpled Letter
	[137677] = { 43468,45146,37447 }; --Fel Blood
	[138817] = { 42918,43384 }; --Demonic Runestone
	[139535] = { 42351 }; --Bloody Prayer
	[139526] = { 42303 }; --Fevered Note
	[139528] = { 42309 }; --Bloody Request
	[139522] = { 42255 }; --Bloody Note
	[139520] = { 42250 }; --Fevered Plea
	[139521] = { 42245 }; --Singed Note
	[138991] = { 42103 }; --Demon Blood
	[132749] = { 40678 }; --Legion Portal Fragment
	[135511] = { 41242,41259,41260,41261,41262,41549,41550,41551,41552,41553,41554,41555,41556,41557,41558 }; --Thick Slab of Bacon
	[139527] = { 42308 }; --Bloody Plea
	[139530] = { 42215 }; --Singed Letter
	[139529] = { 41985 }; --Fevered Request
	[128286] = { 39392 }; --Bristlefur Pelt
	[134131] = { 41233 }; --Bristled Bear Skin
	[139523] = { 42323 }; --Fevered Letter
	[137335] = { 42276 }; --Felsurge Spider Egg
	[139525] = { 42334 }; --Crumpled Note
	[129972] = { 40179 }; --Vrykul Leather Binding
	[122610] = { 38337 }; --Storm Drake Scale
	[124037] = { 38616 }; --Storm Drake Scale
	[123971] = { 38501 }; --Masterwork Hatecoil Breastplate
	[136785] = { 42076 }; --Shadowfen Valuables
	[124501] = { 38802 }; --Ore-Choked Heart
	[124498] = { 38797 }; --Living Felslate Sample
	[136592] = { 40642 }; --Fel Essence
	[129204] = { 39957 }; --Vial of Felsoul Blood
	[133807] = { 40929 }; --Legion Emblem
	[134129] = { 41232 }; --Thick Ironhorn Hide
	[134816] = { 41342 }; --Thick Bear Hide
	[137185] = { 40048 }; --Rune of Dominance
	[136838] = { 42105 }; --Intact Murloc Eye
	[134806] = { 41322 }; --Unscratched Hippogryph Scale
	[138411] = { 42758 }; --Razor-Sharp Shark Tooth
	[134808] = { 41324 }; --Silky Prowler Fur
	[134130] = { 41234 }; --Shaggy Saber Hide
	[136833] = { 42101 }; --Oracle's Scrying Orb
	[134822] = { 41349 }; --Rock-Hard Crab Chitin
	[128921] = { 39843 }; --Spellsludge
	[147582] = { 47139 }; --Mark of the Sentinax
	[147430] = { 46765 }; --Mysterious Runebound Scroll
	[146700] = { 46694 }; --Ancient Gravenscale Armor
	[146684] = { 46682 }; --Ancient Imbued Silkweave Armor
	[153014] = { 48799 }; --Pristine Argunite
	[152204] = { 48230 }; --Glowing Key Fragment
	[152200] = { 48261 }; --Dendrite Cluster
	[151555] = { 47828 }; --Crystallized Memory
	[147763] = { 47101 }; --Fragmented Prayers
	[156797] = { 50229 }; --Twilight Silk
	[156794] = { 50226,50230 }; --Silithid Brain
	[172954] = { 57686 }; --Echo of Mortality
	[157782] = { 50393 }; --Pterrordax Egg
	[159790] = { 51223 }; --Sea Glass
	[159839] = { 51251 }; --Spider Silk
	[160453] = { 48768,52015 }; --Stolen Storm Silver Bar
	[160943] = { 51965 }; --Secott's Old Hand
	[152675] = { 48778 }; --Saurolisk Scale
	[168081] = { 55531 }; --Brinestone Pickaxe
	[168155] = { 55602 }; --Chum
	[167786] = { 55426 }; --Germinating Seed
	[170512] = { 57086 }; --Lesser Benthic Arcanocrystal
	[169226] = { 55103 }; --Torn Sheet Music
	[169236] = { 55103 }; --Latch-and-Lock Trigger
	[169231] = { 55103 }; --Optical Override Drive
	[169239] = { 55103 }; --Unknowable Cube
	[169238] = { 55103 }; --Modified Radio Receiver
	[169235] = { 55103 }; --Confusing Spring Box
	[169225] = { 55103 }; --Unstoppable Countdown Clock
	[169233] = { 55103 }; --Infinite Loop Spring
	[171248] = { 57327,57326 }; --Prototype Implant
	[169227] = { 55103 }; --Irradiated Bolts
	[169224] = { 55103 }; --Big Red Button
	[169232] = { 55103 }; --Dud Blast Canister
	[169229] = { 55103 }; --Exhaust Aromatics
	[169237] = { 55103 }; --Pulsating Marble
	[169230] = { 55103 }; --Reflective Plating
	[169228] = { 55103 }; --Hazardous Container
	[168908] = { 56087 }; --Blueprint: Experimental Adventurer Augment
	[168491] = { 55070 }; --Blueprint: Personal Time Displacer
	[169691] = { 56518 }; --Vinyl: Depths of Ulduar
	[167042] = { 55030 }; --Blueprint: Scrap Trap
	[167846] = { 55061 }; --Blueprint: Mechano-Treat
	[169170] = { 55078 }; --Blueprint: Utility Mechanoclaw
	[169234] = { 56151 }; --Fresh Unagi
	[169255] = { 55103 }; --Tuft of Red Fur
	[169253] = { 55103 }; --Shell Horn
	[169251] = { 55103 }; --Ancient Insect
	[169591] = { 56421 }; --Cracked Numeric Cylinder
	[169246] = { 55103 }; --Strangely Seasoned Meat
	[169252] = { 55103 }; --Resonant Pearl
	[169249] = { 55103 }; --Shark Tooth Necklace
	[169250] = { 55103 }; --Crude Eating Utensil
	[169247] = { 55103 }; --Throwing Rocks
	[169169] = { 55077 }; --Blueprint: Blue Spraybot
	[169167] = { 55075 }; --Blueprint: Orange Spraybot
	[167793] = { 55457 }; --Paint Vial: Overload Orange
	[169168] = { 55076 }; --Blueprint: Green Spraybot
	[167792] = { 55452 }; --Paint Vial: Fel Mint Green
	[169248] = { 55103 }; --Broken Sandals
	[169257] = { 55103 }; --Jagged Rune
	[167836] = { 55057 }; --Blueprint: Canned Minnows
	[169174] = { 55082 }; --Blueprint: Rustbolt Pocket Turret
	[167871] = { 55063 }; --Blueprint: G99.99 Landshark
	[169593] = { 56423 }; --Large Storage Fragment
	[167847] = { 55062 }; --Blueprint: Ultrasafe Transporter: Mechagon
	[169173] = { 55081 }; --Blueprint: Anti-Gravity Pack
	[169688] = { 56515 }; --Vinyl: Gnomeregan Forever
	[168490] = { 55069 }; --Blueprint: Protocol Transference Device
	[168248] = { 55068 }; --Blueprint: BAWLD-371
	[167794] = { 55454 }; --Paint Vial: Lemonade Steel
	[169594] = { 56424 }; --Rust Covered Disc
	[169595] = { 56425 }; --Scorched Data Disc
	[168001] = { 55517 }; --Paint Vial: Big-ol Bronze
	[168519] = { 55980,56152 }; --Hydra Scale
	[169241] = { 56306 }; --Family Jewelry
	[168063] = { 55065 }; --Blueprint: Rustbolt Kegerator
	[168198] = { 55661 }; --Venom Droplet
	[168247] = { 55701 }; --Snapdragon Claw
	[169689] = { 56516 }; --Vinyl: Mimiron's Brainstorm
	[169692] = { 56519 }; --Vinyl: Triumph of Gnomeregan
	[169690] = { 56517 }; --Vinyl: Battle of Gnomeregan
	[168062] = { 55064 }; --Blueprint: Rustbolt Gramophone
	[169779] = { 56566 }; --Deteriorating Cragscales
	[169767] = { 56565 }; --Deteriorating Cragscales
	[169658] = { 56091 }; --Usurper's Scent Gland
	[169657] = { 56092 }; --Hivethief's Jelly Stash
	[169659] = { 56144 }; --Old Nasha's Paw
	[169655] = { 56474 }; --Hivekiller Stinger
	[169656] = { 56473 }; --Envenomed Spider Fang
	[169654] = { 56475 }; --Spiral Yeti Horn
	[173985] = { 58281 }; --Amathet Armor
	[175020] = { 58817 }; --Amathet Figurine
	[175016] = { 58813,58858 }; --Corrupted Flesh
	[174008] = { 58291 }; --Rugged Hyena Pelt
	[172463] = { 57721 }; --Salvaged Mogu Armor
	[170384] = { 56539 }; --Mogu Scouting Report
	[174196] = { 58461 }; --Tome of Ancient Madness
	[175058] = { 58865 }; --Black Empire Armament
	[173986] = { 58284 }; --Writ of the Sun King
	[174451] = { 58641 }; --Sun King's Decree
	[174210] = { 58477 }; --Anima Globule
	[174009] = { 58321 }; --Titanic Core
	[175014] = { 58811 }; --Chunk of Meat
	[175015] = { 58812 }; --Insectoid Meat
	[174356] = { 58606,58010 }; --Aqir Bits
	[173954] = { 58231 }; --Maddened Writings
	[173956] = { 58234 }; --Coalesced Corruption
	[169888] = { 56575 }; --Ooze-covered Amber
	[174762] = { 58760 }; --Amber Blade
	[175001] = { 58807 }; --Aqir Webbing
	[168906] = { 56086 }; --Blueprint: Holographic Digitalization Relay
	[163852] = { 53476 }; --Tortollan Pilgrimage Scroll
	[163856] = { 53476 }; --Ancient Pilgrimage Scrollcasing
	[152659] = { 51060 }; --Cursed Treasure of Zem'lan
	[169216] = { 56240 }; --Silver Knife
	[167790] = { 55451 }; --Paint Vial: Fireball Red
	[174774] = { 58782 }; --Wastewander Supplies
	[174744] = { 58470 }; --Artifact of the Black Empire
	[173721] = { 58081 }; --Love and Terror
	[173705] = { 58069 }; --The Venthyr Diaries
	[179320] = { 60369,60370,60371,60372 }; --Wealdwood
	[179318] = { 60373,60378,60379,60380 }; --Sorrowvine
	[179363] = { 60517 }; --'Misplaced' Anima Tolls
	[179321] = { 60358,60363,60364,60365 }; --Gildenite
	[179317] = { 60374,60375,60376,60377 }; --Bonemetal
	[183091] = { 62246 }; --Lifewoven Bracelet
	[178044] = { 63133 }; --Shifting Cryptogram
	[180799] = { 63134 }; --Mawsworn Patrol Map
	[180803] = { 63137 }; --Puzzling Cryptogram
	[180801] = { 63135 }; --Coldheart Flight Routes
	[175769] = { 63132 }; --Constellan Writ
	[182759] = { 62200 }; --Functioning Anima Core
	[184561] = { 60457,60458,60459,60460 }; --Anima Embers
	[179327] = { 60414,60415,60416,60417 }; --Coin of Brokerage
	[175795] = { 59265 }; --Betrayer's Eye
	[180807] = { 63152 }; --Venthyr Concordat
	[169215] = { 56239 }; --Silver Knife
	[170147] = { 56908 }; --Paint Bottle: Goblin Green
	[173717] = { 58077 }; --Perfected Hand Mirror
	[173710] = { 58072 }; --Petrified Stonefiend
	[173715] = { 58075 }; --Dredger's Toolkit
	[173709] = { 58071 }; --Vial of Dredger Muck
	[182727] = { 62183 }; --A Leaking Package
	[182726] = { 62182 }; --Nadja's Letter
	[180453] = { 60889 }; --She Had a Stone Heart
	[182728] = { 62184 }; --A Crate of Sinvyr Ore
	[173720] = { 58080 }; --Glittering Primrose Necklace
	[182176] = { 62431 }; --Shadowstalker Soul
	[173707] = { 58070 }; --Soul Hunter's Blade
	[180806] = { 63145 }; --Shadebound Testimonial
	[180805] = { 63142 }; --Soulforge Blueprints
	[183066] = { 63160 }; --Korrath's Grimoire: Aleketh
	[183067] = { 63161 }; --Korrath's Grimoire: Belidir
	[183058] = { 63155 }; --Indecipherable Map
	[184622] = { 63206 }; --Stygian Hammer
	[183070] = { 63164 }; --Mawsworn Orders
	[152644] = { 48555 }; --Thistlevine Seeds
	[174763] = { 58755 }; --Golden Lotus Supplies
}
