local E = select(2, ...):unpack()

E.spell_db = {
	["WARRIOR"] = {
		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=236273,["spec"]=true,["name"]="Duel",["duration"]=60,["icon"]=1455893,["spellID"]=236273, },
		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=198817,["spec"]=true,["name"]="Sharpen Blade",["duration"]=25,["icon"]=1380678,["spellID"]=198817, },
		{ ["class"]="WARRIOR",["type"]="counterCC",["buff"]=236321,["spec"]=true,["name"]="War Banner",["duration"]=90,["icon"]=603532,["spellID"]=236320, },


		{ ["class"]="WARRIOR",["type"]="other",["buff"]=329038,["spec"]=true,["name"]="Bloodrage",["duration"]=20,["icon"]=132277,["spellID"]=329038, },
		{ ["class"]="WARRIOR",["type"]="other",["buff"]=355,["name"]="Taunt",["duration"]=8,["icon"]=136080,["spellID"]=355,["talent"]=205800, },

		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=132404,["name"]="Shield Block",["duration"]=16,["icon"]=132110,["spellID"]=2565,["charges"]={[73]=2,["default"]=1}, },
		{ ["class"]="WARRIOR",["type"]="interrupt",["buff"]=6552,["name"]="Pummel",["duration"]=15,["icon"]=132938,["spellID"]=6552, },
		{ ["class"]="WARRIOR",["type"]="other",["buff"]=100,["name"]="Charge",["duration"]=20,["icon"]=132337,["spellID"]=100, },
		{ ["class"]="WARRIOR",["type"]="other",["buff"]=205800,["spec"]=true,["name"]="Oppressor",["duration"]=20,["icon"]=136080,["spellID"]=205800, },
		{ ["class"]="WARRIOR",["type"]="other",["buff"]=206572,["spec"]=true,["name"]="Dragon Charge",["duration"]=20,["icon"]=1380676,["spellID"]=206572, },

		{ ["class"]="WARRIOR",["type"]="disarm",["buff"]=236077,["spec"]=true,["name"]="Disarm",["duration"]=45,["icon"]=132343,["spellID"]=236077, },
		{ ["class"]="WARRIOR",["type"]="externalDefensive",["buff"]=213871,["spec"]=true,["name"]="Bodyguard",["duration"]=15,["icon"]=132359,["spellID"]=213871, },











		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=260708,["spec"]=true,["maxRanks"]=1,["name"]="Sweeping Strikes",["ID"]=11,["duration"]=30,["icon"]=132306,["spellID"]=260708, },







		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=118038,["spec"]=true,["maxRanks"]=1,["name"]="Die by the Sword",["ID"]=19,["duration"]=120,["icon"]=132336,["spellID"]=118038, },




		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=260643,["spec"]=true,["maxRanks"]=1,["name"]="Skullsplitter",["ID"]=24,["duration"]=21,["icon"]=2065621,["spellID"]=260643, },





		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=262161,["spec"]=true,["maxRanks"]=1,["name"]="Warbreaker",["ID"]=30,["duration"]=45,["icon"]=2065633,["spellID"]=262161, },




		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=167105,["spec"]=true,["maxRanks"]=1,["name"]="Colossus Smash",["ID"]=33,["duration"]=45,["icon"]=464973,["spellID"]=167105,["talent"]=262161, },






		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=12975,["spec"]=true,["maxRanks"]=1,["name"]="Last Stand",["ID"]=40,["duration"]=180,["icon"]=135871,["spellID"]=12975, },







		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=1160,["spec"]=true,["maxRanks"]=1,["name"]="Demoralizing Shout",["ID"]=48,["duration"]=45,["icon"]=132366,["spellID"]=1160, },

		{ ["class"]="WARRIOR",["type"]="interrupt",["buff"]=386071,["spec"]=true,["maxRanks"]=1,["name"]="Disrupting Shout",["ID"]=50,["duration"]=90,["icon"]=132091,["spellID"]=386071, },

		{ ["class"]="WARRIOR",["type"]="other",["buff"]=1161,["spec"]=true,["maxRanks"]=1,["name"]="Challenging Shout",["ID"]=52,["duration"]=120,["icon"]=132091,["spellID"]=1161,["talent"]=386071, },



		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=871,["spec"]=true,["maxRanks"]=1,["name"]="Shield Wall",["charges"]=1,["ID"]=55,["duration"]=210,["icon"]=132362,["spellID"]=871, },





		{ ["class"]="WARRIOR",["type"]="cc",["buff"]=385952,["spec"]=true,["maxRanks"]=1,["name"]="Shield Charge",["ID"]=60,["duration"]=45,["icon"]=4667427,["spellID"]=385952, },










		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=202168,["spec"]=true,["maxRanks"]=1,["name"]="Impending Victory",["ID"]=69,["duration"]=25,["icon"]=589768,["spellID"]=202168, },


		{ ["class"]="WARRIOR",["type"]="counterCC",["buff"]=3411,["spec"]=true,["maxRanks"]=1,["name"]="Intervene",["ID"]=72,["duration"]=30,["icon"]=132365,["spellID"]=3411, },

		{ ["class"]="WARRIOR",["type"]="raidDefensive",["buff"]=97463,["spec"]=true,["maxRanks"]=1,["name"]="Rallying Cry",["ID"]=74,["duration"]=180,["icon"]=132351,["spellID"]=97462, },









		{ ["class"]="WARRIOR",["type"]="cc",["buff"]=107570,["spec"]=true,["maxRanks"]=1,["name"]="Storm Bolt",["ID"]=80,["duration"]=30,["icon"]=613535,["spellID"]=107570, },









		{ ["class"]="WARRIOR",["type"]="other",["buff"]=202164,["spec"]=true,["maxRanks"]=1,["name"]="Heroic Leap",["charges"]=1,["ID"]=89,["duration"]=45,["icon"]=236171,["spellID"]=6544, },

		{ ["class"]="WARRIOR",["type"]="other",["buff"]=12323,["spec"]=true,["maxRanks"]=1,["name"]="Piercing Howl",["ID"]=91,["duration"]=30,["icon"]=136147,["spellID"]=12323, },
		{ ["class"]="WARRIOR",["type"]="counterCC",["buff"]=384100,["spec"]=true,["maxRanks"]=1,["name"]="Berserker Shout",["ID"]=91,["duration"]=60,["icon"]=136009,["spellID"]=384100, },


		{ ["class"]="WARRIOR",["type"]="other",["buff"]=64382,["spec"]=true,["maxRanks"]=1,["name"]="Shattering Throw",["ID"]=94,["duration"]=180,["icon"]=311430,["spellID"]=64382, },
		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=384110,["spec"]=true,["maxRanks"]=1,["name"]="Wrecking Throw",["ID"]=94,["duration"]=45,["icon"]=460959,["spellID"]=384110, },




		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=383762,["spec"]=true,["maxRanks"]=1,["name"]="Bitter Immunity",["ID"]=99,["duration"]=180,["icon"]=136088,["spellID"]=383762, },


		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=384318,["spec"]=true,["maxRanks"]=1,["name"]="Thunderous Roar",["ID"]=102,["duration"]=90,["icon"]=642418,["spellID"]=384318, },








		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=107574,["spec"]=true,["maxRanks"]=1,["name"]="Avatar",["ID"]=108,["duration"]=90,["icon"]=613534,["spellID"]=107574, },






		{ ["class"]="WARRIOR",["type"]="counterCC",["buff"]=18499,["spec"]=true,["maxRanks"]=1,["name"]="Berserker Rage",["ID"]=115,["duration"]=60,["icon"]=136009,["spellID"]=18499,["talent"]=384100, },


		{ ["class"]="WARRIOR",["type"]="cc",["buff"]=46968,["spec"]=true,["maxRanks"]=1,["name"]="Shockwave",["ID"]=118,["duration"]=40,["icon"]=236312,["spellID"]=46968, },




		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=376079,["spec"]={376079,321076},["maxRanks"]=1,["name"]="Spear of Bastion",["ID"]=123,["duration"]=90,["icon"]=3565453,["spellID"]=376079, },




		{ ["class"]="WARRIOR",["type"]="cc",["buff"]=5246,["spec"]=true,["maxRanks"]=1,["name"]="Intimidating Shout",["ID"]=127,["duration"]=90,["icon"]=132154,["spellID"]=5246, },
		{ ["class"]="WARRIOR",["type"]="counterCC",["buff"]=23920,["spec"]=true,["maxRanks"]=1,["name"]="Spell Reflection",["charges"]=1,["ID"]=128,["duration"]=25,["icon"]=132361,["spellID"]=23920, },


		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=228920,["spec"]=true,["maxRanks"]=1,["name"]="Ravager",["charges"]=1,["ID"]=131,["duration"]=90,["icon"]=970854,["spellID"]=228920, },







		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=184364,["spec"]=true,["maxRanks"]=1,["name"]="Enraged Regeneration",["ID"]=138,["duration"]=120,["icon"]=132345,["spellID"]=184364, },
















		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=1719,["spec"]=true,["maxRanks"]=1,["name"]="Recklessness",["ID"]=155,["duration"]=90,["icon"]=458972,["spellID"]=1719, },







		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=385059,["spec"]=true,["maxRanks"]=1,["name"]="Odyn's Fury",["ID"]=161,["duration"]=45,["icon"]=1278409,["spellID"]=385059, },
















		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=386394,["spec"]=true,["maxRanks"]=1,["name"]="Battle-Scarred Veteran",["ID"]=178,["duration"]=180,["icon"]=132344,["spellID"]=386394, },






		{ ["class"]="WARRIOR",["type"]="offensive",["buff"]=227847,["spec"]=true,["maxRanks"]=1,["name"]="Bladestorm",["ID"]=184,["duration"]=90,["icon"]=236303,["spellID"]=227847, },









		{ ["class"]="WARRIOR",["type"]="defensive",["buff"]=392966,["spec"]=true,["maxRanks"]=1,["name"]="Spell Block",["ID"]=193,["duration"]=90,["icon"]=132358,["spellID"]=392966, },








	},
	["ROGUE"] = {
		{ ["class"]="ROGUE",["type"]="cc",["buff"]=207736,["spec"]=true,["name"]="Shadowy Duel",["duration"]=120,["icon"]=1020341,["spellID"]=207736, },
		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=315341,["spec"]=260,["name"]="Between the Eyes",["duration"]=45,["icon"]=135610,["spellID"]=315341, },

		{ ["class"]="ROGUE",["type"]="other",["buff"]=114018,["name"]="Shroud of Concealment",["duration"]=360,["icon"]=635350,["spellID"]=114018, },
		{ ["class"]="ROGUE",["type"]="cc",["buff"]=408,["name"]="Kidney Shot",["duration"]=20,["icon"]=132298,["spellID"]=408, },
		{ ["class"]="ROGUE",["type"]="interrupt",["buff"]=1766,["name"]="Kick",["duration"]=15,["icon"]=132219,["spellID"]=1766, },
		{ ["class"]="ROGUE",["type"]="other",["buff"]=1725,["name"]="Distract",["duration"]=30,["icon"]=132289,["spellID"]=1725, },
		{ ["class"]="ROGUE",["type"]="defensive",["buff"]=185311,["name"]="Crimson Vial",["duration"]=30,["icon"]=1373904,["spellID"]=185311, },
		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=221622,["spec"]=true,["name"]="Thick as Thieves",["duration"]=30,["icon"]=236283,["spellID"]=221622, },
		{ ["class"]="ROGUE",["type"]="disarm",["buff"]=207777,["spec"]=true,["name"]="Dismantle",["duration"]=45,["icon"]=236272,["spellID"]=207777, },
		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=269513,["spec"]=true,["name"]="Death from Above",["duration"]=30,["icon"]=1043573,["spellID"]=269513, },
		{ ["class"]="ROGUE",["type"]="cc",["buff"]=212182,["spec"]=true,["name"]="Smoke Bomb",["duration"]=180,["icon"]=458733,["spellID"]=212182, },
		{ ["class"]="ROGUE",["type"]="cc",["buff"]=359053,["spec"]=true,["name"]="Smoke Bomb",["duration"]=120,["icon"]=458733,["spellID"]=359053, },
		{ ["class"]="ROGUE",["type"]="defensive",["buff"]=11327,["name"]="Vanish",["duration"]=120,["icon"]=132331,["spellID"]=1856, },
		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=212283,["spec"]=261,["name"]="Symbols of Death",["duration"]=30,["icon"]=252272,["spellID"]=212283, },
		{ ["class"]="ROGUE",["type"]="other",["buff"]=2983,["name"]="Sprint",["duration"]=0,["icon"]=132307,["spellID"]=2983, },


		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=385424,["spec"]={385424,321078},["maxRanks"]=1,["name"]="Serrated Bone Spike",["charges"]=3,["ID"]=3,["duration"]=30,["icon"]=3578230,["spellID"]=385424, },
		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=385408,["spec"]={385408,321077},["maxRanks"]=1,["name"]="Sepsis",["ID"]=3,["duration"]=90,["icon"]=3636848,["spellID"]=385408, },

















		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=385616,["spec"]={385616,321076},["maxRanks"]=1,["name"]="Echoing Reprimand",["ID"]=20,["duration"]=45,["icon"]=3565450,["spellID"]=385616, },




		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=271877,["spec"]=true,["maxRanks"]=1,["name"]="Blade Rush",["ID"]=25,["duration"]=45,["icon"]=1016243,["spellID"]=271877, },







		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=381989,["spec"]=true,["maxRanks"]=1,["name"]="Keep It Rolling",["ID"]=33,["duration"]=420,["icon"]=4667423,["spellID"]=381989, },




		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=315508,["spec"]=true,["maxRanks"]=1,["name"]="Roll the Bones",["ID"]=38,["duration"]=45,["icon"]=1373910,["spellID"]=315508, },

		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=13750,["spec"]=true,["maxRanks"]=1,["name"]="Adrenaline Rush",["ID"]=40,["duration"]=180,["icon"]=136206,["spellID"]=13750, },




		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=343142,["spec"]=true,["maxRanks"]=1,["name"]="Dreadblades",["ID"]=45,["duration"]=120,["icon"]=1301078,["spellID"]=343142, },
		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=51690,["spec"]=true,["maxRanks"]=1,["name"]="Killing Spree",["ID"]=45,["duration"]=120,["icon"]=236277,["spellID"]=51690, },









		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=13877,["spec"]=true,["maxRanks"]=1,["name"]="Blade Flurry",["ID"]=55,["duration"]=30,["icon"]=132350,["spellID"]=13877, },


		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=196937,["spec"]=true,["maxRanks"]=1,["name"]="Ghostly Strike",["ID"]=58,["duration"]=35,["icon"]=132094,["spellID"]=196937, },





		{ ["class"]="ROGUE",["type"]="other",["buff"]=195457,["spec"]=true,["maxRanks"]=1,["name"]="Grappling Hook",["ID"]=63,["duration"]=45,["icon"]=1373906,["spellID"]=195457, },

		{ ["class"]="ROGUE",["type"]="cc",["buff"]=2094,["spec"]=true,["maxRanks"]=1,["name"]="Blind",["ID"]=65,["duration"]=120,["icon"]=136175,["spellID"]=2094, },

		{ ["class"]="ROGUE",["type"]="other",["buff"]=57934,["spec"]=true,["maxRanks"]=1,["name"]="Tricks of the Trade",["ID"]=67,["duration"]=30,["icon"]=236283,["spellID"]=57934,["talent"]=221622, },


		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=185422,["spec"]={261,185313},["maxRanks"]=1,["name"]="Shadow Dance",["ID"]=70,["duration"]=60,["icon"]=236279,["spellID"]=185313, },





		{ ["class"]="ROGUE",["type"]="other",["buff"]=36554,["spec"]=true,["maxRanks"]=1,["name"]="Shadowstep",["ID"]=76,["duration"]=30,["icon"]=132303,["spellID"]=36554, },

		{ ["class"]="ROGUE",["type"]="defensive",["buff"]=31224,["spec"]=true,["maxRanks"]=1,["name"]="Cloak of Shadows",["ID"]=78,["duration"]=120,["icon"]=136177,["spellID"]=31224, },

















		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=280719,["spec"]=true,["maxRanks"]=1,["name"]="Secret Technique",["ID"]=96,["duration"]=60,["icon"]=132305,["spellID"]=280719, },
		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=277925,["spec"]=true,["maxRanks"]=1,["name"]="Shuriken Tornado",["ID"]=97,["duration"]=60,["icon"]=236282,["spellID"]=277925, },

		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=384631,["spec"]={384631,321079},["maxRanks"]=1,["name"]="Flagellation",["ID"]=99,["duration"]=90,["icon"]=3565724,["spellID"]=384631, },







		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=121471,["spec"]=true,["maxRanks"]=1,["name"]="Shadow Blades",["ID"]=107,["duration"]=180,["icon"]=376022,["spellID"]=121471, },















		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=5938,["spec"]=true,["maxRanks"]=1,["name"]="Shiv",["charges"]=1,["ID"]=121,["duration"]=25,["icon"]=135428,["spellID"]=5938, },
		{ ["class"]="ROGUE",["type"]="cc",["buff"]=1776,["spec"]=true,["maxRanks"]=1,["name"]="Gouge",["ID"]=122,["duration"]=20,["icon"]=132155,["spellID"]=1776, },
		{ ["class"]="ROGUE",["type"]="defensive",["buff"]=1966,["spec"]=true,["maxRanks"]=1,["name"]="Feint",["ID"]=123,["duration"]=15,["icon"]=132294,["spellID"]=1966, },




		{ ["class"]="ROGUE",["type"]="defensive",["buff"]=31230,["spec"]=true,["maxRanks"]=1,["name"]="Cheat Death",["ID"]=128,["duration"]=360,["icon"]=132285,["spellID"]=31230, },

		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=382245,["spec"]=true,["maxRanks"]=1,["name"]="Cold Blood",["ID"]=129,["duration"]=45,["icon"]=135988,["spellID"]=382245, },

		{ ["class"]="ROGUE",["type"]="other",["buff"]=137619,["spec"]=true,["maxRanks"]=1,["name"]="Marked for Death",["ID"]=131,["duration"]={[260]=60,["default"]=30},["icon"]=236364,["spellID"]=137619, },






		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=381623,["spec"]=true,["maxRanks"]=1,["name"]="Thistle Tea",["charges"]=3,["ID"]=137,["duration"]=60,["icon"]=132819,["spellID"]=381623, },








		{ ["class"]="ROGUE",["type"]="defensive",["buff"]=5277,["spec"]=true,["maxRanks"]=1,["name"]="Evasion",["ID"]=145,["duration"]=120,["icon"]=136205,["spellID"]=5277, },




		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=360194,["spec"]=true,["maxRanks"]=1,["name"]="Deathmark",["ID"]=150,["duration"]=120,["icon"]=4667421,["spellID"]=360194, },




		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=381802,["spec"]=true,["maxRanks"]=1,["name"]="Indiscriminate Carnage",["ID"]=155,["duration"]=60,["icon"]=4667422,["spellID"]=381802, },




		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=200806,["spec"]=true,["maxRanks"]=1,["name"]="Exsanguinate",["ID"]=160,["duration"]=180,["icon"]=538040,["spellID"]=200806, },




		{ ["class"]="ROGUE",["type"]="offensive",["buff"]=385627,["spec"]=true,["maxRanks"]=1,["name"]="Kingsbane",["ID"]=165,["duration"]=60,["icon"]=1259291,["spellID"]=385627, },


	},
	["DEMONHUNTER"] = {
		{ ["class"]="DEMONHUNTER",["type"]="defensive",["buff"]=212800,["spec"]=577,["name"]="Blur",["duration"]=60,["icon"]=1305150,["spellID"]=198589, },
		{ ["class"]="DEMONHUNTER",["type"]="other",["buff"]=189110,["spec"]=581,["name"]="Infernal Strike",["duration"]=20,["icon"]=1344650,["spellID"]=189110,["charges"]=2, },
		{ ["class"]="DEMONHUNTER",["type"]="defensive",["buff"]=203720,["spec"]=581,["name"]="Demon Spikes",["duration"]=20,["icon"]=1344645,["spellID"]=203720,["charges"]=2, },
		{ ["class"]="DEMONHUNTER",["type"]="other",["buff"]=205629,["spec"]=true,["name"]="Demonic Trample",["duration"]=20,["icon"]=134294,["spellID"]=205629,["charges"]=2, },
		{ ["class"]="DEMONHUNTER",["type"]="other",["buff"]=207029,["spec"]=true,["name"]="Tormentor",["duration"]=20,["icon"]=1344654,["spellID"]=207029, },
		{ ["class"]="DEMONHUNTER",["type"]="cc",["buff"]=205630,["spec"]=true,["name"]="Illidan's Grasp",["duration"]=60,["icon"]=1380367,["spellID"]=205630, },
		{ ["class"]="DEMONHUNTER",["type"]="other",["buff"]=185245,["name"]="Torment",["duration"]=8,["icon"]=1344654,["spellID"]=185245,["talent"]=207029, },

		{ ["class"]="DEMONHUNTER",["type"]="other",["buff"]=188501,["name"]="Spectral Sight",["duration"]=30,["icon"]=1247266,["spellID"]=188501, },
		{ ["class"]="DEMONHUNTER",["type"]="defensive",["buff"]=187827,["spec"]=581,["name"]="Metamorphosis",["duration"]=240,["icon"]=1247262,["spellID"]=187827, },
		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=162264,["spec"]=577,["name"]="Metamorphosis",["duration"]=240,["icon"]=1247262,["spellID"]=191427, },
		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=258920,["name"]="Immolation Aura",["duration"]={[581]=15,["default"]=30},["icon"]=1344649,["spellID"]=258920, },
		{ ["class"]="DEMONHUNTER",["type"]="interrupt",["buff"]=183752,["name"]="Disrupt",["duration"]=15,["icon"]=1305153,["spellID"]=183752, },
		{ ["class"]="DEMONHUNTER",["type"]="defensive",["buff"]=206803,["spec"]=true,["name"]="Rain from Above",["duration"]=60,["icon"]=1380371,["spellID"]=206803, },
		{ ["class"]="DEMONHUNTER",["type"]="counterCC",["buff"]=205604,["spec"]=true,["name"]="Reverse Magic",["duration"]=60,["icon"]=1380372,["spellID"]=205604, },


		{ ["class"]="DEMONHUNTER",["type"]="defensive",["buff"]=196555,["spec"]=true,["maxRanks"]=1,["name"]="Netherwalk",["ID"]=2,["duration"]=180,["icon"]=463284,["spellID"]=196555, },














		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=370965,["spec"]={370965,321077},["maxRanks"]=1,["name"]="The Hunt",["ID"]=16,["duration"]=90,["icon"]=3636838,["spellID"]=370965, },




		{ ["class"]="DEMONHUNTER",["type"]="other",["buff"]=232893,["spec"]=true,["maxRanks"]=1,["name"]="Felblade",["ID"]=21,["duration"]=15,["icon"]=1344646,["spellID"]=232893, },










		{ ["class"]="DEMONHUNTER",["type"]="other",["buff"]=198793,["spec"]=true,["maxRanks"]=1,["name"]="Vengeful Retreat",["ID"]=31,["duration"]=25,["icon"]=1348401,["spellID"]=198793, },
		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=204596,["spec"]=true,["maxRanks"]=1,["name"]="Sigil of Flame",["ID"]=32,["duration"]=30,["icon"]=1344652,["spellID"]=204596, },




		{ ["class"]="DEMONHUNTER",["type"]="cc",["buff"]=207684,["spec"]=true,["maxRanks"]=1,["name"]="Sigil of Misery",["ID"]=35,["duration"]=120,["icon"]=1418287,["spellID"]=207684, },




		{ ["class"]="DEMONHUNTER",["type"]="defensive",["buff"]=204021,["spec"]=true,["maxRanks"]=1,["name"]="Fiery Brand",["charges"]=1,["ID"]=40,["duration"]=60,["icon"]=1344647,["spellID"]=204021, },


		{ ["class"]="DEMONHUNTER",["type"]="disarm",["buff"]=202138,["spec"]=true,["maxRanks"]=1,["name"]="Sigil of Chains",["ID"]=43,["duration"]=60,["icon"]=1418286,["spellID"]=202138, },

		{ ["class"]="DEMONHUNTER",["type"]="defensive",["buff"]=263648,["spec"]=true,["maxRanks"]=1,["name"]="Soul Barrier",["ID"]=45,["duration"]=30,["icon"]=2065625,["spellID"]=263648, },
		{ ["class"]="DEMONHUNTER",["type"]="cc",["buff"]=320341,["spec"]=true,["maxRanks"]=1,["name"]="Bulk Extraction",["ID"]=45,["duration"]=90,["icon"]=136194,["spellID"]=320341, },



		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=390163,["spec"]={390163,321076},["maxRanks"]=1,["name"]="Elysian Decree",["ID"]=49,["duration"]=60,["icon"]=3565443,["spellID"]=390163, },




















		{ ["class"]="DEMONHUNTER",["type"]="defensive",["buff"]=209258,["spec"]=true,["maxRanks"]=1,["name"]="Last Resort",["ID"]=68,["duration"]=480,["icon"]=1348655,["spellID"]=209258, },


		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=207407,["spec"]=true,["maxRanks"]=1,["name"]="Soul Carver",["ID"]=71,["duration"]=60,["icon"]=1309072,["spellID"]=207407, },





		{ ["class"]="DEMONHUNTER",["type"]="disarm",["buff"]=202137,["spec"]=true,["maxRanks"]=1,["name"]="Sigil of Silence",["ID"]=77,["duration"]=60,["icon"]=1418288,["spellID"]=202137, },



		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=212084,["spec"]=true,["maxRanks"]=1,["name"]="Fel Devastation",["ID"]=80,["duration"]=60,["icon"]=1450143,["spellID"]=212084, },


		{ ["class"]="DEMONHUNTER",["type"]="cc",["buff"]=179057,["spec"]=true,["maxRanks"]=1,["name"]="Chaos Nova",["ID"]=82,["duration"]=60,["icon"]=135795,["spellID"]=179057, },









		{ ["class"]="DEMONHUNTER",["type"]="raidDefensive",["buff"]=209426,["spec"]=true,["maxRanks"]=1,["name"]="Darkness",["ID"]=91,["duration"]=300,["icon"]=1305154,["spellID"]=196718, },




		{ ["class"]="DEMONHUNTER",["type"]="dispel",["buff"]=278326,["spec"]=true,["maxRanks"]=1,["name"]="Consume Magic",["ID"]=95,["duration"]=10,["icon"]=828455,["spellID"]=278326, },
		{ ["class"]="DEMONHUNTER",["type"]="cc",["buff"]=217832,["spec"]=true,["maxRanks"]=1,["name"]="Imprison",["ID"]=96,["duration"]=45,["icon"]=1380368,["spellID"]=217832, },







		{ ["class"]="DEMONHUNTER",["type"]="cc",["buff"]=211881,["spec"]=true,["maxRanks"]=1,["name"]="Fel Eruption",["ID"]=103,["duration"]=30,["icon"]=1118739,["spellID"]=211881, },



		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=198013,["spec"]=true,["maxRanks"]=1,["name"]="Eye Beam",["ID"]=107,["duration"]=40,["icon"]=1305156,["spellID"]=198013, },





		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=258925,["spec"]=true,["maxRanks"]=1,["name"]="Fel Barrage",["ID"]=112,["duration"]=60,["icon"]=2065580,["spellID"]=258925, },
		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=342817,["spec"]=true,["maxRanks"]=1,["name"]="Glaive Tempest",["ID"]=112,["duration"]=20,["icon"]=1455916,["spellID"]=342817, },









		{ ["class"]="DEMONHUNTER",["type"]="offensive",["buff"]=258860,["spec"]=true,["maxRanks"]=1,["name"]="Essence Break",["ID"]=122,["duration"]=40,["icon"]=136189,["spellID"]=258860, },



	},
	["MONK"] = {
		{ ["class"]="MONK",["type"]="other",["buff"]=207025,["spec"]=true,["name"]="Admonishment",["duration"]=20,["icon"]=620830,["spellID"]=207025, },
		{ ["class"]="MONK",["type"]="cc",["buff"]=202335,["spec"]=true,["name"]="Double Barrel",["duration"]=45,["icon"]=644378,["spellID"]=202335 },
		{ ["class"]="MONK",["type"]="counterCC",["buff"]=354540,["spec"]=true,["name"]="Nimble Brew",["duration"]=90,["icon"]=839394,["spellID"]=354540, },
		{ ["class"]="MONK",["type"]="externalDefensive",["buff"]=202162,["spec"]=true,["name"]="Avert Harm",["duration"]=45,["icon"]=620829,["spellID"]=202162, },

		{ ["class"]="MONK",["type"]="dispel",["buff"]=115450,["spec"]=270,["name"]="Detox",["duration"]=8,["icon"]=460692,["spellID"]=115450, },
		{ ["class"]="MONK",["type"]="counterCC",["buff"]=209584,["spec"]=true,["name"]="Zen Focus Tea",["duration"]=30,["icon"]=651940,["spellID"]=209584, },

		{ ["class"]="MONK",["type"]="offensive",["buff"]=322109,["name"]="Touch of Death",["duration"]=180,["icon"]=606552,["spellID"]=322109, },
		{ ["class"]="MONK",["type"]="other",["buff"]=115546,["name"]="Provoke",["duration"]=8,["icon"]=620830,["spellID"]=115546,["talent"]=207025, },
		{ ["class"]="MONK",["type"]="cc",["buff"]=119381,["name"]="Leg Sweep",["duration"]=60,["icon"]=642414,["spellID"]=119381, },

		{ ["class"]="MONK",["type"]="disarm",["buff"]=202370,["spec"]=true,["name"]="Mighty Ox Kick",["duration"]=30,["icon"]=1381297,["spellID"]=202370, },
		{ ["class"]="MONK",["type"]="disarm",["buff"]=233759,["spec"]=true,["name"]="Grapple Weapon",["duration"]=45,["icon"]=132343,["spellID"]=233759, },
		{ ["class"]="MONK",["type"]="other",["buff"]=119996,["spec"]=101643,["name"]="Transcendence: Transfer",["duration"]=45,["icon"]=237585,["spellID"]=119996, },
		{ ["class"]="MONK",["type"]="other",["buff"]=109132,["name"]="Roll",["duration"]=20,["icon"]=574574,["spellID"]=109132,["talent"]=115008, },



		{ ["class"]="MONK",["type"]="offensive",["buff"]=388193,["spec"]={388193,321077},["maxRanks"]=1,["name"]="Faeline Stomp",["charges"]=1,["ID"]=3,["duration"]=30,["icon"]=3636842,["spellID"]=388193, },
		{ ["class"]="MONK",["type"]="cc",["buff"]=198898,["spec"]=true,["maxRanks"]=1,["name"]="Song of Chi-Ji",["ID"]=4,["duration"]=30,["icon"]=332402,["spellID"]=198898, },


		{ ["class"]="MONK",["type"]="offensive",["buff"]=196725,["spec"]=true,["maxRanks"]=1,["name"]="Refreshing Jade Wind",["ID"]=6,["duration"]=45,["icon"]=606549,["spellID"]=196725, },




		{ ["class"]="MONK",["type"]="offensive",["buff"]=124081,["spec"]=true,["maxRanks"]=1,["name"]="Zen Pulse",["ID"]=9,["duration"]=30,["icon"]=613397,["spellID"]=124081, },








		{ ["class"]="MONK",["type"]="raidDefensive",["buff"]=388615,["spec"]=true,["maxRanks"]=1,["name"]="Restoral",["charges"]=1,["ID"]=17,["duration"]=180,["icon"]=1381300,["spellID"]=388615, },
		{ ["class"]="MONK",["type"]="raidDefensive",["buff"]=115310,["spec"]=true,["maxRanks"]=1,["name"]="Revival",["charges"]=1,["ID"]=17,["duration"]=180,["icon"]=1020466,["spellID"]=115310, },











		{ ["class"]="MONK",["type"]="externalDefensive",["buff"]=116849,["spec"]=true,["maxRanks"]=1,["name"]="Life Cocoon",["ID"]=27,["duration"]=120,["icon"]=627485,["spellID"]=116849, },

		{ ["class"]="MONK",["type"]="offensive",["buff"]=386276,["spec"]={386276,321078},["maxRanks"]=1,["name"]="Bonedust Brew",["ID"]=29,["duration"]=60,["icon"]=3578227,["spellID"]=386276, },



		{ ["class"]="MONK",["type"]="offensive",["buff"]=322118,["spec"]=true,["maxRanks"]=1,["name"]="Invoke Yu'lon, the Jade Serpent",["ID"]=33,["duration"]=180,["icon"]=574571,["spellID"]=322118, },
		{ ["class"]="MONK",["type"]="offensive",["buff"]=325197,["spec"]=true,["maxRanks"]=1,["name"]="Invoke Chi-Ji, the Red Crane",["ID"]=33,["duration"]=180,["icon"]=877514,["spellID"]=325197, },












		{ ["class"]="MONK",["type"]="offensive",["buff"]=116680,["spec"]=true,["maxRanks"]=1,["name"]="Thunder Focus Tea",["ID"]=43,["duration"]=30,["icon"]=611418,["spellID"]=116680, },





		{ ["class"]="MONK",["type"]="dispel",["buff"]=218164,["spec"]=true,["maxRanks"]=1,["name"]="Detox",["charges"]=1,["ID"]=49,["duration"]=8,["icon"]=460692,["spellID"]=218164, },



		{ ["class"]="MONK",["type"]="immunity",["buff"]=125174,["spec"]=true,["maxRanks"]=1,["name"]="Touch of Karma",["ID"]=53,["duration"]=90,["icon"]=651728,["spellID"]=122470, },


		{ ["class"]="MONK",["type"]="offensive",["buff"]=113656,["spec"]=true,["maxRanks"]=1,["name"]="Fists of Fury",["ID"]=56,["duration"]=24,["icon"]=627606,["spellID"]=113656, },




		{ ["class"]="MONK",["type"]="offensive",["buff"]=137639,["spec"]=true,["maxRanks"]=1,["name"]="Storm, Earth, and Fire",["charges"]=2,["ID"]=61,["duration"]=90,["icon"]=136038,["spellID"]=137639, },
		{ ["class"]="MONK",["type"]="offensive",["buff"]=152173,["spec"]=true,["maxRanks"]=1,["name"]="Serenity",["ID"]=61,["duration"]=90,["icon"]=988197,["spellID"]=152173, },


		{ ["class"]="MONK",["type"]="other",["buff"]=101545,["spec"]=true,["maxRanks"]=1,["name"]="Flying Serpent Kick",["ID"]=64,["duration"]=25,["icon"]=606545,["spellID"]=101545, },







		{ ["class"]="MONK",["type"]="disarm",["buff"]=324312,["spec"]=true,["maxRanks"]=1,["name"]="Clash",["ID"]=72,["duration"]=30,["icon"]=628134,["spellID"]=324312, },









		{ ["class"]="MONK",["type"]="defensive",["buff"]=115399,["spec"]=true,["maxRanks"]=1,["name"]="Black Ox Brew",["ID"]=79,["duration"]=120,["icon"]=629483,["spellID"]=115399, },


		{ ["class"]="MONK",["type"]="defensive",["buff"]=119582,["spec"]=true,["maxRanks"]=1,["name"]="Purifying Brew",["charges"]=1,["ID"]=82,["duration"]=20,["icon"]=133701,["spellID"]=119582, },




		{ ["class"]="MONK",["type"]="defensive",["buff"]=122281,["spec"]=true,["maxRanks"]=1,["name"]="Healing Elixir",["charges"]=2,["ID"]=87,["duration"]=30,["icon"]=608939,["spellID"]=122281, },




		{ ["class"]="MONK",["type"]="defensive",["buff"]=322507,["spec"]=true,["maxRanks"]=1,["name"]="Celestial Brew",["ID"]=92,["duration"]=60,["icon"]=1360979,["spellID"]=322507, },









		{ ["class"]="MONK",["type"]="offensive",["buff"]=123904,["spec"]=true,["maxRanks"]=1,["name"]="Invoke Xuen, the White Tiger",["ID"]=100,["duration"]=120,["icon"]=620832,["spellID"]=123904, },
		{ ["class"]="MONK",["type"]="offensive",["buff"]=152175,["spec"]=true,["maxRanks"]=1,["name"]="Whirling Dragon Punch",["ID"]=101,["duration"]=24,["icon"]=988194,["spellID"]=152175, },
















		{ ["class"]="MONK",["type"]="offensive",["buff"]=392983,["spec"]=true,["maxRanks"]=1,["name"]="Strike of the Windlord",["ID"]=118,["duration"]=40,["icon"]=1282595,["spellID"]=392983, },




		{ ["class"]="MONK",["type"]="defensive",["buff"]=120954,["spec"]=true,["maxRanks"]=1,["name"]="Fortifying Brew",["ID"]=123,["duration"]=360,["icon"]=615341,["spellID"]=115203, },





		{ ["class"]="MONK",["type"]="other",["buff"]=115008,["spec"]=true,["maxRanks"]=1,["name"]="Chi Torpedo",["charges"]=1,["ID"]=128,["duration"]=20,["icon"]=607849,["spellID"]=115008, },

		{ ["class"]="MONK",["type"]="interrupt",["buff"]=116705,["spec"]=true,["maxRanks"]=1,["name"]="Spear Hand Strike",["ID"]=129,["duration"]=15,["icon"]=608940,["spellID"]=116705, },

		{ ["class"]="MONK",["type"]="cc",["buff"]=115078,["spec"]=true,["maxRanks"]=1,["name"]="Paralysis",["ID"]=131,["duration"]=45,["icon"]=629534,["spellID"]=115078, },
		{ ["class"]="MONK",["type"]="other",["buff"]=116841,["spec"]=true,["maxRanks"]=1,["name"]="Tiger's Lust",["ID"]=132,["duration"]=30,["icon"]=651727,["spellID"]=116841, },







		{ ["class"]="MONK",["type"]="defensive",["buff"]=122783,["spec"]=true,["maxRanks"]=1,["name"]="Diffuse Magic",["ID"]=140,["duration"]=90,["icon"]=775460,["spellID"]=122783, },
		{ ["class"]="MONK",["type"]="disarm",["buff"]=116844,["spec"]=true,["maxRanks"]=1,["name"]="Ring of Peace",["ID"]=141,["duration"]=45,["icon"]=839107,["spellID"]=116844, },


		{ ["class"]="MONK",["type"]="offensive",["buff"]=388686,["spec"]=true,["maxRanks"]=1,["name"]="Summon White Tiger Statue",["ID"]=144,["duration"]=120,["icon"]=4667418,["spellID"]=388686, },


		{ ["class"]="MONK",["type"]="defensive",["buff"]=122278,["spec"]=true,["maxRanks"]=1,["name"]="Dampen Harm",["ID"]=147,["duration"]=120,["icon"]=620827,["spellID"]=122278, },





		{ ["class"]="MONK",["type"]="offensive",["buff"]=123986,["spec"]=true,["maxRanks"]=1,["name"]="Chi Burst",["ID"]=152,["duration"]=30,["icon"]=135734,["spellID"]=123986, },










		{ ["class"]="MONK",["type"]="offensive",["buff"]=387184,["spec"]={387184,321076},["maxRanks"]=1,["name"]="Weapons of Order",["ID"]=162,["duration"]=120,["icon"]=3565447,["spellID"]=387184, },


		{ ["class"]="MONK",["type"]="offensive",["buff"]=325153,["spec"]=true,["maxRanks"]=1,["name"]="Exploding Keg",["ID"]=165,["duration"]=60,["icon"]=644378,["spellID"]=325153, },

		{ ["class"]="MONK",["type"]="defensive",["buff"]=132578,["spec"]=true,["maxRanks"]=1,["name"]="Invoke Niuzao, the Black Ox",["ID"]=167,["duration"]=180,["icon"]=608951,["spellID"]=132578, },


		{ ["class"]="MONK",["type"]="defensive",["buff"]=115176,["spec"]=true,["maxRanks"]=1,["name"]="Zen Meditation",["ID"]=169,["duration"]=300,["icon"]=642417,["spellID"]=115176, },







	},
	["DEATHKNIGHT"] = {
		{ ["class"]="DEATHKNIGHT",["type"]="cc",["buff"]=47481,["spec"]=252,["duration"]=90,["name"]="Gnaw",["icon"]=237524,["spellID"]=47481, },
		{ ["class"]="DEATHKNIGHT",["type"]="interrupt",["buff"]=47482,["spec"]=252,["duration"]=30,["name"]="Leap",["icon"]=237569,["spellID"]=47482, },
		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=203173,["spec"]=true,["duration"]=30,["name"]="Death Chain",["icon"]=1390941,["spellID"]=203173, },
		{ ["class"]="DEATHKNIGHT",["type"]="other",["buff"]=207018,["spec"]=true,["duration"]=20,["name"]="Murderous Intent",["icon"]=136088,["spellID"]=207018, },
		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=196770,["spec"]=true,["duration"]=45,["name"]="Dead of Winter",["icon"]=538770,["spellID"]=287250, },
		{ ["class"]="DEATHKNIGHT",["type"]="counterCC",["buff"]=49039,["duration"]=120,["name"]="Lichborne",["icon"]=136187,["spellID"]=49039, },
		{ ["class"]="DEATHKNIGHT",["type"]="other",["buff"]=48265,["duration"]=45,["name"]="Death's Advance",["icon"]=237561,["spellID"]=48265, },
		{ ["class"]="DEATHKNIGHT",["type"]="disarm",["buff"]=49576,["duration"]={[250]=15,["default"]=25},["name"]="Death Grip",["icon"]=237532,["spellID"]=49576, },
		{ ["class"]="DEATHKNIGHT",["type"]="other",["buff"]=56222,["duration"]=8,["name"]="Dark Command",["icon"]=136088,["spellID"]=56222,["talent"]=207018, },
		{ ["class"]="DEATHKNIGHT",["type"]="disarm",["buff"]=47476,["spec"]=true,["duration"]=60,["name"]="Strangulate",["icon"]=136214,["spellID"]=47476, },
		{ ["class"]="DEATHKNIGHT",["type"]="other",["buff"]=77606,["spec"]=true,["duration"]=20,["name"]="Dark Simulacrum",["icon"]=135888,["spellID"]=77606, },
		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=288853,["spec"]=true,["duration"]=90,["name"]="Raise Abomination",["icon"]=298667,["spellID"]=288853, },












		{ ["class"]="DEATHKNIGHT",["type"]="cc",["buff"]=207167,["spec"]=true,["maxRanks"]=1,["name"]="Blinding Sleet",["ID"]=12,["duration"]=60,["icon"]=135836,["spellID"]=207167, },




		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=383269,["spec"]={383269,321078},["maxRanks"]=1,["name"]="Abomination Limb",["ID"]=17,["duration"]=120,["icon"]=3578196,["spellID"]=383269, },
		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=47568,["spec"]=true,["maxRanks"]=1,["name"]="Empower Rune Weapon",["ID"]=18,["duration"]=120,["icon"]=135372,["spellID"]=47568, },














		{ ["class"]="DEATHKNIGHT",["type"]="cc",["buff"]=221562,["spec"]=true,["maxRanks"]=1,["name"]="Asphyxiate",["ID"]=32,["duration"]=45,["icon"]=538558,["spellID"]=221562, },
		{ ["class"]="DEATHKNIGHT",["type"]="raidDefensive",["buff"]=51052,["spec"]=true,["maxRanks"]=1,["name"]="Anti-Magic Zone",["ID"]=33,["duration"]=120,["icon"]=237510,["spellID"]=51052, },




		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=48707,["spec"]=true,["maxRanks"]=1,["name"]="Anti-Magic Shell",["ID"]=38,["duration"]=60,["icon"]=136120,["spellID"]=48707, },

		{ ["class"]="DEATHKNIGHT",["type"]="other",["buff"]=46585,["spec"]=true,["maxRanks"]=1,["name"]="Raise Dead",["ID"]=40,["duration"]=120,["icon"]=1100170,["spellID"]=46585, },

		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=327574,["spec"]=true,["maxRanks"]=1,["name"]="Sacrificial Pact",["ID"]=42,["duration"]=120,["icon"]=136133,["spellID"]=327574, },


		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=48743,["spec"]=true,["maxRanks"]=1,["name"]="Death Pact",["ID"]=45,["duration"]=120,["icon"]=136146,["spellID"]=48743, },
		{ ["class"]="DEATHKNIGHT",["type"]="other",["buff"]=212552,["spec"]=true,["maxRanks"]=1,["name"]="Wraith Walk",["ID"]=46,["duration"]=60,["icon"]=1100041,["spellID"]=212552, },



		{ ["class"]="DEATHKNIGHT",["type"]="interrupt",["buff"]=47528,["spec"]=true,["maxRanks"]=1,["name"]="Mind Freeze",["ID"]=50,["duration"]=15,["icon"]=237527,["spellID"]=47528, },

		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=48792,["spec"]=true,["maxRanks"]=1,["name"]="Icebound Fortitude",["ID"]=52,["duration"]=180,["icon"]=237525,["spellID"]=48792, },








		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=152279,["spec"]=true,["maxRanks"]=1,["name"]="Breath of Sindragosa",["ID"]=61,["duration"]=120,["icon"]=1029007,["spellID"]=152279, },

		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=279302,["spec"]=true,["maxRanks"]=1,["name"]="Frostwyrm's Fury",["ID"]=63,["duration"]=180,["icon"]=341980,["spellID"]=279302, },



		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=305392,["spec"]=true,["maxRanks"]=1,["name"]="Chill Streak",["ID"]=66,["duration"]=45,["icon"]=429386,["spellID"]=305392, },





		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=51271,["spec"]=true,["maxRanks"]=1,["name"]="Pillar of Frost",["ID"]=72,["duration"]=60,["icon"]=458718,["spellID"]=51271, },





		{ ["class"]="DEATHKNIGHT",["type"]="other",["buff"]=57330,["spec"]=true,["maxRanks"]=1,["name"]="Horn of Winter",["ID"]=78,["duration"]=45,["icon"]=134228,["spellID"]=57330, },

		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=196770,["spec"]=true,["maxRanks"]=1,["name"]="Remorseless Winter",["ID"]=80,["duration"]=20,["icon"]=538770,["spellID"]=196770,["talent"]=287250, },















		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=194844,["spec"]=true,["maxRanks"]=1,["name"]="Bonestorm",["ID"]=95,["duration"]=60,["icon"]=342917,["spellID"]=194844, },





		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=114556,["spec"]=true,["maxRanks"]=1,["name"]="Purgatory",["ID"]=101,["duration"]=240,["icon"]=134430,["spellID"]=114556, },


		{ ["class"]="DEATHKNIGHT",["type"]="other",["buff"]=108199,["spec"]=true,["maxRanks"]=1,["name"]="Gorefiend's Grasp",["ID"]=104,["duration"]=120,["icon"]=538767,["spellID"]=108199, },

		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=81256,["spec"]=true,["maxRanks"]=1,["name"]="Dancing Rune Weapon",["ID"]=106,["duration"]=120,["icon"]=135277,["spellID"]=49028, },

		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=219809,["spec"]=true,["maxRanks"]=1,["name"]="Tombstone",["ID"]=107,["duration"]=60,["icon"]=132151,["spellID"]=219809, },


		{ ["class"]="DEATHKNIGHT",["type"]="other",["buff"]=221699,["spec"]=true,["maxRanks"]=1,["name"]="Blood Tap",["charges"]=2,["ID"]=110,["duration"]=60,["icon"]=237515,["spellID"]=221699, },
		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=206931,["spec"]=true,["maxRanks"]=1,["name"]="Blooddrinker",["ID"]=111,["duration"]=30,["icon"]=838812,["spellID"]=206931, },
		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=274156,["spec"]=true,["maxRanks"]=1,["name"]="Consumption",["ID"]=111,["duration"]=30,["icon"]=1121487,["spellID"]=274156, },

		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=194679,["spec"]=true,["maxRanks"]=1,["name"]="Rune Tap",["charges"]=2,["ID"]=113,["duration"]=25,["icon"]=237529,["spellID"]=194679, },






		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=207289,["spec"]=true,["maxRanks"]=1,["name"]="Unholy Assault",["ID"]=119,["duration"]=90,["icon"]=136224,["spellID"]=207289, },







		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=390279,["spec"]=true,["maxRanks"]=1,["name"]="Vile Contagion",["ID"]=127,["duration"]=90,["icon"]=136182,["spellID"]=390279, },


		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=115989,["spec"]=true,["maxRanks"]=1,["name"]="Unholy Blight",["ID"]=130,["duration"]=45,["icon"]=136132,["spellID"]=115989, },











		{ ["class"]="DEATHKNIGHT",["type"]="defensive",["buff"]=55233,["spec"]=true,["maxRanks"]=1,["name"]="Vampiric Blood",["ID"]=141,["duration"]=90,["icon"]=136168,["spellID"]=55233, },


		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=49206,["spec"]=true,["maxRanks"]=1,["name"]="Summon Gargoyle",["ID"]=144,["duration"]=180,["icon"]=458967,["spellID"]=49206, },










		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=275699,["spec"]=true,["maxRanks"]=1,["name"]="Apocalypse",["ID"]=153,["duration"]=90,["icon"]=1392565,["spellID"]=275699, },

		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=63560,["spec"]=true,["maxRanks"]=1,["name"]="Dark Transformation",["ID"]=155,["duration"]=60,["icon"]=342913,["spellID"]=63560, },
		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=46584,["spec"]=true,["maxRanks"]=1,["name"]="Raise Dead",["ID"]=156,["duration"]=30,["icon"]=1100170,["spellID"]=46584, },







		{ ["class"]="DEATHKNIGHT",["type"]="offensive",["buff"]=42650,["spec"]=true,["maxRanks"]=1,["name"]="Army of the Dead",["ID"]=164,["duration"]=480,["icon"]=237511,["spellID"]=42650,["talent"]=288853, },

	},
	["HUNTER"] = {

		{ ["class"]="HUNTER",["type"]="disarm",["buff"]=212638,["spec"]=true,["name"]="Tracker's Net",["duration"]=25,["icon"]=1412207,["spellID"]=212638, },
		{ ["class"]="HUNTER",["type"]="dispel",["buff"]=212640,["spec"]=true,["name"]="Mending Bandage",["duration"]=25,["icon"]=1014022,["spellID"]=212640, },

		{ ["class"]="HUNTER",["type"]="other",["buff"]=272651,["name"]="Command Pet",["duration"]=45,["icon"]=457329,["spellID"]=272651, },
		{ ["class"]="HUNTER",["type"]="cc",["buff"]=187650,["name"]="Freezing Trap",["duration"]=30,["icon"]=135834,["spellID"]=187650, },
		{ ["class"]="HUNTER",["type"]="other",["buff"]=1543,["name"]="Flare",["duration"]=20,["icon"]=135815,["spellID"]=1543, },
		{ ["class"]="HUNTER",["type"]="other",["buff"]=5384,["name"]="Feign Death",["duration"]=30,["icon"]=132293,["spellID"]=5384, },
		{ ["class"]="HUNTER",["type"]="other",["buff"]=781,["name"]="Disengage",["duration"]=20,["icon"]=132294,["spellID"]=781, },
		{ ["class"]="HUNTER",["type"]="immunity",["buff"]=186265,["name"]="Aspect of the Turtle",["duration"]=180,["icon"]=132199,["spellID"]=186265, },
		{ ["class"]="HUNTER",["type"]="other",["buff"]=186257,["name"]="Aspect of the Cheetah",["duration"]=180,["icon"]=132242,["spellID"]=186257, },
		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=208652,["spec"]=true,["name"]="Dire Beast: Hawk",["duration"]=30,["icon"]=612363,["spellID"]=208652, },
		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=205691,["spec"]=true,["name"]="Dire Beast: Basilisk",["duration"]=120,["icon"]=1412204,["spellID"]=205691, },
		{ ["class"]="HUNTER",["type"]="other",["buff"]=356707,["spec"]=true,["name"]="Wild Kingdom",["duration"]=60,["icon"]=236159,["spellID"]=356707, },
		{ ["class"]="HUNTER",["type"]="defensive",["buff"]=53480,["spec"]=true,["name"]="Roar of Sacrifice",["duration"]=60,["icon"]=464604,["spellID"]=53480, },
		{ ["class"]="HUNTER",["type"]="disarm",["buff"]=356719,["spec"]=true,["name"]="Chimaeral Sting",["duration"]=60,["icon"]=132211,["spellID"]=356719, },
		{ ["class"]="HUNTER",["type"]="defensive",["buff"]=248519,["spec"]=true,["name"]="Interlope",["duration"]=45,["icon"]=132180,["spellID"]=248518, },
		{ ["class"]="HUNTER",["type"]="defensive",["buff"]=109304,["name"]="Exhilaration",["duration"]=120,["icon"]=461117,["spellID"]=109304, },











		{ ["class"]="HUNTER",["type"]="defensive",["buff"]=264735,["spec"]=true,["maxRanks"]=1,["name"]="Survival of the Fittest",["ID"]=9,["duration"]=180,["icon"]=136094,["spellID"]=264735, },















		{ ["class"]="HUNTER",["type"]="interrupt",["buff"]=187707,["spec"]=true,["maxRanks"]=1,["name"]="Muzzle",["ID"]=25,["duration"]=15,["icon"]=1376045,["spellID"]=187707, },



		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=269751,["spec"]=true,["maxRanks"]=1,["name"]="Flanking Strike",["ID"]=29,["duration"]=30,["icon"]=236184,["spellID"]=269751, },
		{ ["class"]="HUNTER",["type"]="other",["buff"]=190925,["spec"]=true,["maxRanks"]=1,["name"]="Harpoon",["charges"]=1,["ID"]=30,["duration"]=30,["icon"]=1376040,["spellID"]=190925, },










		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=203415,["spec"]=true,["maxRanks"]=1,["name"]="Fury of the Eagle",["ID"]=40,["duration"]=45,["icon"]=1239829,["spellID"]=203415,["pve"]=true, },










		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=259495,["spec"]=true,["maxRanks"]=1,["name"]="Wildfire Bomb",["charges"]=1,["ID"]=51,["duration"]=18,["icon"]=2065634,["spellID"]=259495, },


		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=360952,["spec"]=true,["maxRanks"]=1,["name"]="Coordinated Assault",["ID"]=53,["duration"]=120,["icon"]=2032587,["spellID"]=360952, },
		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=360966,["spec"]=true,["maxRanks"]=1,["name"]="Spearhead",["ID"]=54,["duration"]=90,["icon"]=4667416,["spellID"]=360966, },





		{ ["class"]="HUNTER",["type"]="disarm",["buff"]=186387,["spec"]=true,["maxRanks"]=1,["name"]="Bursting Shot",["ID"]=60,["duration"]=30,["icon"]=1376038,["spellID"]=186387, },

		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=260402,["spec"]=true,["maxRanks"]=1,["name"]="Double Tap",["ID"]=62,["duration"]=60,["icon"]=537468,["spellID"]=260402, },





		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=257044,["spec"]=true,["maxRanks"]=1,["name"]="Rapid Fire",["ID"]=68,["duration"]=20,["icon"]=461115,["spellID"]=257044, },

		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=288613,["spec"]=true,["maxRanks"]=1,["name"]="Trueshot",["ID"]=70,["duration"]=120,["icon"]=132329,["spellID"]=288613, },







		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=260243,["spec"]=true,["maxRanks"]=1,["name"]="Volley",["ID"]=78,["duration"]=45,["icon"]=132205,["spellID"]=260243, },




















		{ ["class"]="HUNTER",["type"]="dispel",["buff"]=19801,["spec"]=true,["maxRanks"]=1,["name"]="Tranquilizing Shot",["ID"]=95,["duration"]=10,["icon"]=136020,["spellID"]=19801, },
		{ ["class"]="HUNTER",["type"]="disarm",["buff"]=162488,["spec"]=true,["maxRanks"]=1,["name"]="Steel Trap",["ID"]=96,["duration"]=30,["icon"]=1467588,["spellID"]=162488, },

		{ ["class"]="HUNTER",["type"]="cc",["buff"]=19577,["spec"]=true,["maxRanks"]=1,["name"]="Intimidation",["ID"]=98,["duration"]=60,["icon"]=132111,["spellID"]=19577, },
		{ ["class"]="HUNTER",["type"]="disarm",["buff"]=236776,["spec"]=true,["maxRanks"]=1,["name"]="High Explosive Trap",["ID"]=98,["duration"]=40,["icon"]=135826,["spellID"]=236776, },


		{ ["class"]="HUNTER",["type"]="interrupt",["buff"]=147362,["spec"]=true,["maxRanks"]=1,["name"]="Counter Shot",["ID"]=100,["duration"]=24,["icon"]=249170,["spellID"]=147362, },

		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=120360,["spec"]=true,["maxRanks"]=1,["name"]="Barrage",["ID"]=102,["duration"]=20,["icon"]=236201,["spellID"]=120360, },
		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=212431,["spec"]=true,["maxRanks"]=1,["name"]="Explosive Shot",["ID"]=102,["duration"]=30,["icon"]=236178,["spellID"]=212431, },

		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=375891,["spec"]={375891,321078},["maxRanks"]=1,["name"]="Death Chakram",["ID"]=104,["duration"]=45,["icon"]=3578207,["spellID"]=375891, },
		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=201430,["spec"]=true,["maxRanks"]=1,["name"]="Stampede",["ID"]=104,["duration"]=120,["icon"]=461112,["spellID"]=201430, },







		{ ["class"]="HUNTER",["type"]="other",["buff"]=34477,["spec"]=true,["maxRanks"]=1,["name"]="Misdirection",["ID"]=112,["duration"]=30,["icon"]=132180,["spellID"]=34477,["talent"]=248518, },



		{ ["class"]="HUNTER",["type"]="other",["buff"]=187698,["spec"]=true,["maxRanks"]=1,["name"]="Tar Trap",["ID"]=116,["duration"]=30,["icon"]=576309,["spellID"]=187698, },




		{ ["class"]="HUNTER",["type"]="other",["buff"]=199483,["spec"]=true,["maxRanks"]=1,["name"]="Camouflage",["ID"]=121,["duration"]=60,["icon"]=461113,["spellID"]=199483, },


		{ ["class"]="HUNTER",["type"]="cc",["buff"]=213691,["spec"]=true,["maxRanks"]=1,["name"]="Scatter Shot",["ID"]=124,["duration"]=30,["icon"]=132153,["spellID"]=213691, },
		{ ["class"]="HUNTER",["type"]="disarm",["buff"]=109248,["spec"]=true,["maxRanks"]=1,["name"]="Binding Shot",["ID"]=124,["duration"]=45,["icon"]=462650,["spellID"]=109248, },
		{ ["class"]="HUNTER",["type"]="disarm",["buff"]=392060,["spec"]=true,["maxRanks"]=1,["name"]="Wailing Arrow",["ID"]=125,["duration"]=60,["icon"]=132323,["spellID"]=392060, },




		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=321530,["spec"]=true,["maxRanks"]=1,["name"]="Bloodshed",["ID"]=130,["duration"]=60,["icon"]=132139,["spellID"]=321530, },
		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=131894,["spec"]=true,["maxRanks"]=1,["name"]="A Murder of Crows",["ID"]=130,["duration"]=60,["icon"]=645217,["spellID"]=131894, },







		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=193530,["spec"]=true,["maxRanks"]=1,["name"]="Aspect of the Wild",["ID"]=137,["duration"]=120,["icon"]=136074,["spellID"]=193530, },




		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=19574,["spec"]=true,["maxRanks"]=1,["name"]="Bestial Wrath",["ID"]=142,["duration"]=90,["icon"]=132127,["spellID"]=19574, },



		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=120679,["spec"]=true,["maxRanks"]=1,["name"]="Dire Beast",["ID"]=146,["duration"]=20,["icon"]=236186,["spellID"]=120679, },









		{ ["class"]="HUNTER",["type"]="offensive",["buff"]=359844,["spec"]=true,["maxRanks"]=1,["name"]="Call of the Wild",["ID"]=154,["duration"]=180,["icon"]=4667415,["spellID"]=359844, },


	},
	["EVOKER"] = {
		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=377509,["spec"]=true,["name"]="Dream Projection",["duration"]=90,["icon"]=4622475,["spellID"]=377509, },
		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=390386,["name"]="Fury of the Aspects",["duration"]=300,["icon"]=4723908,["spellID"]=390386,["pve"]=true, },
		{ ["class"]="EVOKER",["type"]="defensive",["buff"]=355913,["spec"]=1467,["name"]="Emerald Blossom",["duration"]=30,["icon"]=4622457,["spellID"]=355913, },
		{ ["class"]="EVOKER",["type"]="counterCC",["buff"]=378464,["spec"]=true,["name"]="Nullifying Shroud",["duration"]=90,["icon"]=135752,["spellID"]=378464, },
		{ ["class"]="EVOKER",["type"]="disarm",["buff"]=370388,["spec"]=true,["name"]="Swoop Up",["duration"]=90,["icon"]=4622446,["spellID"]=370388, },
		{ ["class"]="EVOKER",["type"]="immunity",["buff"]=378441,["spec"]=true,["name"]="Time Stop",["duration"]=120,["icon"]=4631367,["spellID"]=378441, },
		{ ["class"]="EVOKER",["type"]="disarm",["buff"]=383005,["spec"]=true,["name"]="Chrono Loop",["duration"]=90,["icon"]=4630470,["spellID"]=383005, },
		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=357210,["name"]="Deep Breath",["duration"]=120,["icon"]=4622450,["spellID"]=357210, },
		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=382266,["name"]="Fire Breath",["duration"]=30,["icon"]=4622458,["spellID"]=382266, },
		{ ["class"]="EVOKER",["type"]="other",["buff"]=358267,["name"]="Hover",["duration"]=35,["icon"]=4622463,["spellID"]=358267, },





		{ ["class"]="EVOKER",["type"]="cc",["buff"]=360806,["spec"]=true,["maxRanks"]=1,["name"]="Sleep Walk",["ID"]=4,["duration"]=15,["icon"]=1396974,["spellID"]=360806, },






		{ ["class"]="EVOKER",["type"]="defensive",["buff"]=370960,["spec"]=true,["maxRanks"]=1,["name"]="Emerald Communion",["ID"]=10,["duration"]=180,["icon"]=4630447,["spellID"]=370960, },


		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=359816,["spec"]=true,["maxRanks"]=1,["name"]="Dream Flight",["ID"]=13,["duration"]=120,["icon"]=4622455,["spellID"]=359816, },





		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=370537,["spec"]=true,["maxRanks"]=1,["name"]="Stasis",["ID"]=18,["duration"]=90,["icon"]=4630476,["spellID"]=370537, },
		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=368412,["spec"]=true,["maxRanks"]=1,["name"]="Time of Need",["ID"]=19,["duration"]=90,["icon"]=4630462,["spellID"]=368412, },







		{ ["class"]="EVOKER",["type"]="raidDefensive",["buff"]=363534,["spec"]=true,["maxRanks"]=1,["name"]="Rewind",["charges"]=1,["ID"]=26,["duration"]=240,["icon"]=4622474,["spellID"]=363534, },
		{ ["class"]="EVOKER",["type"]="externalDefensive",["buff"]=357170,["spec"]=true,["maxRanks"]=1,["name"]="Time Dilation",["ID"]=27,["duration"]=60,["icon"]=4622478,["spellID"]=357170, },











		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=367226,["spec"]=true,["maxRanks"]=1,["name"]="Spiritbloom",["ID"]=37,["duration"]=30,["icon"]=4622476,["spellID"]=367226, },

		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=355936,["spec"]=true,["maxRanks"]=1,["name"]="Dream Breath",["ID"]=39,["duration"]=30,["icon"]=4622454,["spellID"]=355936, },



















		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=359073,["spec"]=true,["maxRanks"]=1,["name"]="Eternity Surge",["ID"]=56,["duration"]=30,["icon"]=4630444,["spellID"]=359073, },











		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=368847,["spec"]=true,["maxRanks"]=1,["name"]="Firestorm",["ID"]=68,["duration"]=20,["icon"]=4622459,["spellID"]=368847, },





		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=375087,["spec"]=true,["maxRanks"]=1,["name"]="Dragonrage",["ID"]=74,["duration"]=120,["icon"]=4622452,["spellID"]=375087, },










		{ ["class"]="EVOKER",["type"]="other",["buff"]=375234,["spec"]=true,["maxRanks"]=1,["name"]="Time Spiral",["ID"]=83,["duration"]=120,["icon"]=4622479,["spellID"]=374968, },


		{ ["class"]="EVOKER",["type"]="defensive",["buff"]=374348,["spec"]=true,["maxRanks"]=1,["name"]="Renewing Blaze",["ID"]=86,["duration"]=90,["icon"]=4630463,["spellID"]=374348, },


		{ ["class"]="EVOKER",["type"]="raidDefensive",["buff"]=374227,["spec"]=true,["maxRanks"]=1,["name"]="Zephyr",["ID"]=88,["duration"]=120,["icon"]=4630449,["spellID"]=374227, },


		{ ["class"]="EVOKER",["type"]="other",["buff"]=370665,["spec"]=true,["maxRanks"]=1,["name"]="Rescue",["ID"]=91,["duration"]=60,["icon"]=4622460,["spellID"]=370665, },






		{ ["class"]="EVOKER",["type"]="interrupt",["buff"]=351338,["spec"]=true,["maxRanks"]=1,["name"]="Quell",["ID"]=98,["duration"]=40,["icon"]=4622469,["spellID"]=351338, },


		{ ["class"]="EVOKER",["type"]="cc",["buff"]=372048,["spec"]=true,["maxRanks"]=1,["name"]="Oppressing Roar",["ID"]=101,["duration"]=120,["icon"]=4622466,["spellID"]=372048, },




		{ ["class"]="EVOKER",["type"]="dispel",["buff"]=374251,["spec"]=true,["maxRanks"]=1,["name"]="Cauterizing Flame",["ID"]=106,["duration"]=60,["icon"]=4630446,["spellID"]=374251, },

		{ ["class"]="EVOKER",["type"]="defensive",["buff"]=363916,["spec"]=true,["maxRanks"]=1,["name"]="Obsidian Scales",["charges"]=1,["ID"]=108,["duration"]=90,["icon"]=1394891,["spellID"]=363916, },





		{ ["class"]="EVOKER",["type"]="disarm",["buff"]=358385,["spec"]=true,["maxRanks"]=1,["name"]="Landslide",["ID"]=114,["duration"]=90,["icon"]=1016245,["spellID"]=358385, },




		{ ["class"]="EVOKER",["type"]="offensive",["buff"]=370553,["spec"]=true,["maxRanks"]=1,["name"]="Tip the Scales",["ID"]=119,["duration"]=120,["icon"]=4622480,["spellID"]=370553, },

		{ ["class"]="EVOKER",["type"]="other",["buff"]=360995,["spec"]=true,["maxRanks"]=1,["name"]="Verdant Embrace",["ID"]=121,["duration"]={[1468]=18,["default"]=24},["icon"]=4622471,["spellID"]=360995, },
		{ ["class"]="EVOKER",["type"]="dispel",["buff"]=365585,["spec"]=true,["maxRanks"]=1,["name"]="Expunge",["ID"]=122,["duration"]=8,["icon"]=4630445,["spellID"]=365585, },
	},
	["DRUID"] = {

		{ ["class"]="DRUID",["type"]="other",["buff"]=1850,["duration"]=120,["name"]="Dash",["icon"]=132120,["spellID"]=1850,["talent"]=252216, },
		{ ["class"]="DRUID",["type"]="disarm",["buff"]=209749,["spec"]=true,["duration"]=30,["name"]="Faerie Swarm",["icon"]=538516,["spellID"]=209749, },
		{ ["class"]="DRUID",["type"]="defensive",["buff"]=305497,["spec"]=true,["duration"]=45,["name"]="Thorns",["icon"]=136104,["spellID"]=305497, },
		{ ["class"]="DRUID",["type"]="defensive",["buff"]=354654,["spec"]=true,["duration"]=60,["name"]="Grove Protection",["icon"]=4067364,["spellID"]=354654, },
		{ ["class"]="DRUID",["type"]="other",["buff"]=207017,["spec"]=true,["duration"]=20,["name"]="Alpha Challenge",["icon"]=132270,["spellID"]=207017, },
		{ ["class"]="DRUID",["type"]="other",["buff"]=329042,["spec"]=true,["duration"]=120,["name"]="Emerald Slumber",["icon"]=1394953,["spellID"]=329042, },
		{ ["class"]="DRUID",["type"]="cc",["buff"]=202246,["spec"]=true,["duration"]=25,["name"]="Overrun",["icon"]=1408833,["spellID"]=202246, },
		{ ["class"]="DRUID",["type"]="defensive",["buff"]=201664,["spec"]=true,["duration"]=30,["name"]="Demoralizing Roar",["icon"]=132117,["spellID"]=201664, },
		{ ["class"]="DRUID",["type"]="dispel",["buff"]=88423,["duration"]=8,["name"]="Nature's Cure",["icon"]=236288,["spellID"]=88423, },
		{ ["class"]="DRUID",["type"]="other",["buff"]=5215,["duration"]=6,["name"]="Prowl",["icon"]=514640,["spellID"]=5215, },
		{ ["class"]="DRUID",["type"]="offensive",["buff"]=50334,["spec"]=104,["duration"]=180,["name"]="Berserk",["icon"]=236149,["spellID"]=50334,["talent"]=102558, },
		{ ["class"]="DRUID",["type"]="defensive",["buff"]=22812,["duration"]=60,["name"]="Barkskin",["icon"]=136097,["spellID"]=22812, },
		{ ["class"]="DRUID",["type"]="other",["buff"]=6795,["duration"]=8,["name"]="Growl",["icon"]=132270,["spellID"]=6795,["talent"]=207017, },









		{ ["class"]="DRUID",["type"]="other",["buff"]=132158,["spec"]=true,["maxRanks"]=1,["name"]="Nature's Swiftness",["ID"]=8,["duration"]=60,["icon"]=136076,["spellID"]=132158, },



		{ ["class"]="DRUID",["type"]="offensive",["buff"]=102351,["spec"]=true,["maxRanks"]=1,["name"]="Cenarion Ward",["ID"]=10,["duration"]=30,["icon"]=132137,["spellID"]=102351, },


		{ ["class"]="DRUID",["type"]="raidDefensive",["buff"]=157982,["spec"]=true,["maxRanks"]=1,["name"]="Tranquility",["ID"]=12,["duration"]=180,["icon"]=136107,["spellID"]=740, },







		{ ["class"]="DRUID",["type"]="offensive",["buff"]=203651,["spec"]=true,["maxRanks"]=1,["name"]="Overgrowth",["ID"]=19,["duration"]=60,["icon"]=1408836,["spellID"]=203651, },


		{ ["class"]="DRUID",["type"]="offensive",["buff"]=117679,["spec"]=true,["maxRanks"]=1,["name"]="Incarnation: Tree of Life",["ID"]=22,["duration"]=180,["icon"]=236157,["spellID"]=33891, },
		{ ["class"]="DRUID",["type"]="offensive",["buff"]=391528,["spec"]={391528,321077},["maxRanks"]=1,["name"]="Convoke the Spirits",["ID"]=22,["duration"]=120,["icon"]=3636839,["spellID"]=391528, },


		{ ["class"]="DRUID",["type"]="offensive",["buff"]=391888,["spec"]={391888,321078},["maxRanks"]=1,["name"]="Adaptive Swarm",["ID"]=25,["duration"]=25,["icon"]=3578197,["spellID"]=391888, },










		{ ["class"]="DRUID",["type"]="offensive",["buff"]=392160,["spec"]=true,["maxRanks"]=1,["name"]="Invigorate",["ID"]=35,["duration"]=20,["icon"]=136073,["spellID"]=392160, },

		{ ["class"]="DRUID",["type"]="offensive",["buff"]=197721,["spec"]=true,["maxRanks"]=1,["name"]="Flourish",["ID"]=37,["duration"]=90,["icon"]=538743,["spellID"]=197721, },




		{ ["class"]="DRUID",["type"]="externalDefensive",["buff"]=102342,["spec"]=true,["maxRanks"]=1,["name"]="Ironbark",["ID"]=40,["duration"]=90,["icon"]=572025,["spellID"]=102342, },




















		{ ["class"]="DRUID",["type"]="cc",["buff"]=106951,["spec"]=true,["maxRanks"]=1,["name"]="Berserk",["ID"]=59,["duration"]=180,["icon"]=236149,["spellID"]=106951,["talent"]=102543, },







		{ ["class"]="DRUID",["type"]="offensive",["buff"]=274837,["spec"]=true,["maxRanks"]=1,["name"]="Feral Frenzy",["ID"]=66,["duration"]=45,["icon"]=132140,["spellID"]=274837, },




		{ ["class"]="DRUID",["type"]="offensive",["buff"]=391891,["spec"]=true,["maxRanks"]=1,["name"]="Adaptive Swarm",["ID"]=70,["duration"]=25,["icon"]=3578197,["spellID"]=391888, },

		{ ["class"]="DRUID",["type"]="offensive",["buff"]=102543,["spec"]=true,["maxRanks"]=1,["name"]="Incarnation: Avatar of Ashamane",["ID"]=72,["duration"]=180,["icon"]=571586,["spellID"]=102543, },


		{ ["class"]="DRUID",["type"]="defensive",["buff"]=61336,["spec"]=true,["maxRanks"]=1,["name"]="Survival Instincts",["charges"]=1,["ID"]=74,["duration"]=180,["icon"]=236169,["spellID"]=61336, },







		{ ["class"]="DRUID",["type"]="offensive",["buff"]=5217,["spec"]=true,["maxRanks"]=1,["name"]="Tiger's Fury",["ID"]=82,["duration"]=30,["icon"]=132242,["spellID"]=5217, },











		{ ["class"]="DRUID",["type"]="offensive",["buff"]=102558,["spec"]=true,["maxRanks"]=1,["name"]="Incarnation: Guardian of Ursoc",["ID"]=94,["duration"]=180,["icon"]=571586,["spellID"]=102558, },






		{ ["class"]="DRUID",["type"]="defensive",["buff"]=200851,["spec"]=true,["maxRanks"]=1,["name"]="Rage of the Sleeper",["ID"]=99,["duration"]=90,["icon"]=1129695,["spellID"]=200851, },












		{ ["class"]="DRUID",["type"]="defensive",["buff"]=80313,["spec"]=true,["maxRanks"]=1,["name"]="Pulverize",["ID"]=111,["duration"]=45,["icon"]=1033490,["spellID"]=80313, },








		{ ["class"]="DRUID",["type"]="other",["buff"]=155835,["spec"]=true,["maxRanks"]=1,["name"]="Bristling Fur",["ID"]=119,["duration"]=40,["icon"]=1033476,["spellID"]=155835, },


		{ ["class"]="DRUID",["type"]="other",["buff"]=102401,["spec"]=true,["maxRanks"]=1,["name"]="Wild Charge",["ID"]=122,["duration"]=15,["icon"]=538771,["spellID"]=102401, },
		{ ["class"]="DRUID",["type"]="other",["buff"]=252216,["spec"]=true,["maxRanks"]=1,["name"]="Tiger Dash",["ID"]=122,["duration"]=45,["icon"]=1817485,["spellID"]=252216, },





		{ ["class"]="DRUID",["type"]="dispel",["buff"]=2782,["spec"]=true,["maxRanks"]=1,["name"]="Remove Corruption",["ID"]=128,["duration"]=8,["icon"]=135952,["spellID"]=2782, },




		{ ["class"]="DRUID",["type"]="disarm",["buff"]=132469,["spec"]=true,["maxRanks"]=1,["name"]="Typhoon",["ID"]=133,["duration"]=30,["icon"]=236170,["spellID"]=132469, },










		{ ["class"]="DRUID",["type"]="defensive",["buff"]=22842,["spec"]=true,["maxRanks"]=1,["name"]="Frenzied Regeneration",["charges"]=1,["ID"]=144,["duration"]=36,["icon"]=132091,["spellID"]=22842, },
		{ ["class"]="DRUID",["type"]="cc",["buff"]=22570,["spec"]=true,["maxRanks"]=1,["name"]="Maim",["ID"]=145,["duration"]=20,["icon"]=132134,["spellID"]=22570, },


		{ ["class"]="DRUID",["type"]="interrupt",["buff"]=106839,["spec"]=true,["maxRanks"]=1,["name"]="Skull Bash",["ID"]=148,["duration"]=15,["icon"]=236946,["spellID"]=106839, },




		{ ["class"]="DRUID",["type"]="dispel",["buff"]=2908,["spec"]=true,["maxRanks"]=1,["name"]="Soothe",["ID"]=153,["duration"]=10,["icon"]=132163,["spellID"]=2908, },

		{ ["class"]="DRUID",["type"]="offensive",["buff"]=319454,["spec"]=true,["maxRanks"]=1,["name"]="Heart of the Wild",["ID"]=155,["duration"]=300,["icon"]=135879,["spellID"]=319454, },
		{ ["class"]="DRUID",["type"]="defensive",["buff"]=108238,["spec"]=true,["maxRanks"]=1,["name"]="Renewal",["ID"]=156,["duration"]=90,["icon"]=136059,["spellID"]=108238, },

		{ ["class"]="DRUID",["type"]="raidMovement",["buff"]=106898,["spec"]=true,["maxRanks"]=1,["name"]="Stampeding Roar",["ID"]=158,["duration"]=120,["icon"]=464343,["spellID"]=106898, },


		{ ["class"]="DRUID",["type"]="cc",["buff"]=5211,["spec"]=true,["maxRanks"]=1,["name"]="Mighty Bash",["ID"]=161,["duration"]=60,["icon"]=132114,["spellID"]=5211, },
		{ ["class"]="DRUID",["type"]="cc",["buff"]=99,["spec"]=true,["maxRanks"]=1,["name"]="Incapacitating Roar",["ID"]=161,["duration"]=30,["icon"]=132121,["spellID"]=99, },




		{ ["class"]="DRUID",["type"]="disarm",["buff"]=102359,["spec"]=true,["maxRanks"]=1,["name"]="Mass Entanglement",["ID"]=166,["duration"]=30,["icon"]=538515,["spellID"]=102359, },
		{ ["class"]="DRUID",["type"]="disarm",["buff"]=102793,["spec"]=true,["maxRanks"]=1,["name"]="Ursol's Vortex",["ID"]=166,["duration"]=60,["icon"]=571588,["spellID"]=102793, },
		{ ["class"]="DRUID",["type"]="other",["buff"]=29166,["spec"]=true,["maxRanks"]=1,["name"]="Innervate",["ID"]=167,["duration"]=180,["icon"]=136048,["spellID"]=29166, },
		{ ["class"]="DRUID",["type"]="defensive",["buff"]=124974,["spec"]=true,["maxRanks"]=1,["name"]="Nature's Vigil",["ID"]=168,["duration"]=90,["icon"]=236764,["spellID"]=124974, },










		{ ["class"]="DRUID",["type"]="offensive",["buff"]=394013,["spec"]=394013,["maxRanks"]=1,["name"]="Incarnation: Chosen of Elune",["ID"]=178,["duration"]=180,["icon"]=571586,["spellID"]=102560, },



		{ ["class"]="DRUID",["type"]="other",["buff"]=205636,["spec"]=true,["maxRanks"]=1,["name"]="Force of Nature",["ID"]=182,["duration"]=60,["icon"]=132129,["spellID"]=205636, },




		{ ["class"]="DRUID",["type"]="offensive",["buff"]=194223,["spec"]=true,["maxRanks"]=1,["name"]="Celestial Alignment",["ID"]=187,["duration"]=180,["icon"]=136060,["spellID"]=194223,["talent"]=394013, },




		{ ["class"]="DRUID",["type"]="offensive",["buff"]=88747,["spec"]=true,["maxRanks"]=1,["name"]="Wild Mushroom",["charges"]=3,["ID"]=192,["duration"]=30,["icon"]=464341,["spellID"]=88747, },




		{ ["class"]="DRUID",["type"]="offensive",["buff"]=202770,["spec"]=true,["maxRanks"]=1,["name"]="Fury of Elune",["ID"]=196,["duration"]=60,["icon"]=132123,["spellID"]=202770, },
		{ ["class"]="DRUID",["type"]="offensive",["buff"]=274281,["spec"]=true,["maxRanks"]=1,["name"]="New Moon",["charges"]=3,["ID"]=196,["duration"]=20,["icon"]=1392545,["spellID"]=274281, },





		{ ["class"]="DRUID",["type"]="interrupt",["buff"]=78675,["spec"]=true,["maxRanks"]=1,["name"]="Solar Beam",["ID"]=202,["duration"]=60,["icon"]=252188,["spellID"]=78675, },

		{ ["class"]="DRUID",["type"]="offensive",["buff"]=202425,["spec"]=true,["maxRanks"]=1,["name"]="Warrior of Elune",["ID"]=204,["duration"]=45,["icon"]=135900,["spellID"]=202425, },

		{ ["class"]="DRUID",["type"]="other",["buff"]=202359,["spec"]=true,["maxRanks"]=1,["name"]="Astral Communion",["ID"]=206,["duration"]=60,["icon"]=611423,["spellID"]=202359, },











	},
	["WARLOCK"] = {
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=344566,["spec"]=true,["duration"]=30,["name"]="Rapid Contagion",["icon"]=237557,["spellID"]=344566, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=234877,["spec"]=true,["duration"]=30,["name"]="Bane of Shadows",["icon"]=615099,["spellID"]=234877, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=264106,["spec"]=true,["duration"]=30,["name"]="Deathbolt",["icon"]=425953,["spellID"]=264106, },
		{ ["class"]="WARLOCK",["type"]="interrupt",["buff"]=212619,["spec"]=true,["duration"]=60,["name"]="Call Felhunter",["icon"]=136174,["spellID"]=212619, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=212459,["spec"]=true,["duration"]=120,["name"]="Call Fel Lord",["icon"]=1113433,["spellID"]=212459, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=353601,["spec"]=true,["duration"]=45,["name"]="Fel Obelisk",["icon"]=1718002,["spellID"]=353601, },


		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=201996,["spec"]=true,["duration"]=90,["name"]="Call Observer",["icon"]=538445,["spellID"]=201996, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=353753,["spec"]=true,["duration"]=30,["name"]="Bonds of Fel",["icon"]=1117883,["spellID"]=353753, },
		{ ["class"]="WARLOCK",["type"]="other",["buff"]=353294,["spec"]=true,["duration"]=60,["name"]="Shadow Rift",["icon"]=4067372,["spellID"]=353294, },
		{ ["class"]="WARLOCK",["type"]="counterCC",["buff"]=221705,["spec"]=true,["duration"]=60,["name"]="Casting Circle",["icon"]=1392953,["spellID"]=221703, },
		{ ["class"]="WARLOCK",["type"]="counterCC",["buff"]=212295,["spec"]=true,["duration"]=45,["name"]="Nether Ward",["icon"]=135796,["spellID"]=212295, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=199954,["spec"]=true,["duration"]=45,["name"]="Bane of Fragility",["icon"]=132097,["spellID"]=199954, },
		{ ["class"]="WARLOCK",["type"]="other",["buff"]=200546,["spec"]=true,["duration"]=45,["name"]="Bane of Havoc",["icon"]=1380866,["spellID"]=200546, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=89751,["spec"]=266,["duration"]=30,["name"]="Felstorm",["icon"]=236303,["spellID"]=89751, },
		{ ["class"]="WARLOCK",["type"]="interrupt",["buff"]=119898,["duration"]=24,["name"]="Command Demon",["icon"]=236292,["spellID"]=119898, },
		{ ["class"]="WARLOCK",["type"]="other",["buff"]=113942,["spec"]=111771,["duration"]=90,["name"]="Demonic Gateway",["icon"]=607512,["spellID"]=113942, },
		{ ["class"]="WARLOCK",["type"]="other",["buff"]=48020,["duration"]=30,["name"]="Demonic Circle: Teleport",["icon"]=237560,["spellID"]=48020, },
		{ ["class"]="WARLOCK",["type"]="defensive",["buff"]=104773,["duration"]=180,["name"]="Unending Resolve",["icon"]=136150,["spellID"]=104773, },
















		{ ["class"]="WARLOCK",["type"]="other",["buff"]=333889,["spec"]=true,["maxRanks"]=1,["name"]="Fel Domination",["ID"]=17,["duration"]=180,["icon"]=237564,["spellID"]=333889, },


		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=328774,["spec"]=true,["maxRanks"]=1,["name"]="Amplify Curse",["ID"]=20,["duration"]=30,["icon"]=136132,["spellID"]=328774, },

		{ ["class"]="WARLOCK",["type"]="defensive",["buff"]=108416,["spec"]=true,["maxRanks"]=1,["name"]="Dark Pact",["ID"]=22,["duration"]=60,["icon"]=136146,["spellID"]=108416, },








		{ ["class"]="WARLOCK",["type"]="cc",["buff"]=30283,["spec"]=true,["maxRanks"]=1,["name"]="Shadowfury",["ID"]=28,["duration"]=60,["icon"]=607865,["spellID"]=30283, },




		{ ["class"]="WARLOCK",["type"]="cc",["buff"]=5484,["spec"]=true,["maxRanks"]=1,["name"]="Howl of Terror",["ID"]=33,["duration"]=40,["icon"]=607852,["spellID"]=5484, },
		{ ["class"]="WARLOCK",["type"]="cc",["buff"]=6789,["spec"]=true,["maxRanks"]=1,["name"]="Mortal Coil",["ID"]=33,["duration"]=45,["icon"]=607853,["spellID"]=6789, },





















		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=387976,["spec"]=true,["maxRanks"]=1,["name"]="Dimensional Rift",["charges"]=3,["ID"]=52,["duration"]=45,["icon"]=607513,["spellID"]=387976, },







		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=152108,["spec"]=true,["maxRanks"]=1,["name"]="Cataclysm",["ID"]=60,["duration"]=30,["icon"]=409545,["spellID"]=152108, },




		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=6353,["spec"]=true,["maxRanks"]=1,["name"]="Soul Fire",["ID"]=64,["duration"]=45,["icon"]=135809,["spellID"]=6353, },
		{ ["class"]="WARLOCK",["type"]="other",["buff"]=80240,["spec"]=true,["maxRanks"]=1,["name"]="Havoc",["ID"]=65,["duration"]=30,["icon"]=460695,["spellID"]=80240,["talent"]=200546, },








		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=1122,["spec"]=true,["maxRanks"]=1,["name"]="Summon Infernal",["ID"]=71,["duration"]=180,["icon"]=136219,["spellID"]=1122, },














		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=267218,["spec"]=true,["maxRanks"]=1,["name"]="Nether Portal",["ID"]=83,["duration"]=180,["icon"]=2065615,["spellID"]=267217, },





		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=264130,["spec"]=true,["maxRanks"]=1,["name"]="Power Siphon",["ID"]=89,["duration"]=30,["icon"]=236290,["spellID"]=264130, },

		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=386833,["spec"]=true,["maxRanks"]=1,["name"]="Guillotine",["ID"]=91,["duration"]=45,["icon"]=1109118,["spellID"]=386833, },







		{ ["class"]="WARLOCK",["type"]="cc",["buff"]=111898,["spec"]=true,["maxRanks"]=1,["name"]="Grimoire: Felguard",["ID"]=99,["duration"]=120,["icon"]=136216,["spellID"]=111898, },





		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=264119,["spec"]=true,["maxRanks"]=1,["name"]="Summon Vilefiend",["ID"]=105,["duration"]=45,["icon"]=1616211,["spellID"]=264119, },


		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=267171,["spec"]=true,["maxRanks"]=1,["name"]="Demonic Strength",["ID"]=107,["duration"]=60,["icon"]=236292,["spellID"]=267171, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=267211,["spec"]=true,["maxRanks"]=1,["name"]="Bilescourge Bombers",["ID"]=107,["duration"]=30,["icon"]=132182,["spellID"]=267211, },

		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=104316,["spec"]=true,["maxRanks"]=1,["name"]="Call Dreadstalkers",["ID"]=109,["duration"]=20,["icon"]=1378282,["spellID"]=104316, },






		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=265273,["spec"]=true,["maxRanks"]=1,["name"]="Summon Demonic Tyrant",["ID"]=116,["duration"]=90,["icon"]=2065628,["spellID"]=265187, },



		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=205180,["spec"]=true,["maxRanks"]=1,["name"]="Summon Darkglare",["ID"]=120,["duration"]=120,["icon"]=1416161,["spellID"]=205180, },

		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=278350,["spec"]=true,["maxRanks"]=1,["name"]="Vile Taint",["ID"]=122,["duration"]=30,["icon"]=1391774,["spellID"]=278350, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=205179,["spec"]=true,["maxRanks"]=1,["name"]="Phantom Singularity",["ID"]=122,["duration"]=45,["icon"]=132886,["spellID"]=205179, },
		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=386951,["spec"]=true,["maxRanks"]=1,["name"]="Soul Swap",["ID"]=123,["duration"]=30,["icon"]=460857,["spellID"]=386951, },

















		{ ["class"]="WARLOCK",["type"]="other",["buff"]=108503,["spec"]=true,["maxRanks"]=1,["name"]="Grimoire of Sacrifice",["ID"]=140,["duration"]=30,["icon"]=538443,["spellID"]=108503, },

		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=386997,["spec"]={386997,321077},["maxRanks"]=1,["name"]="Soul Rot",["ID"]=142,["duration"]=60,["icon"]=3636850,["spellID"]=386997, },







		{ ["class"]="WARLOCK",["type"]="offensive",["buff"]=196447,["spec"]=true,["maxRanks"]=1,["name"]="Channel Demonfire",["ID"]=150,["duration"]=25,["icon"]=840407,["spellID"]=196447, },






	},
	["PRIEST"] = {
		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=211522,["spec"]=true,["name"]="Psyfiend",["duration"]=45,["icon"]=537021,["spellID"]=211522 },
		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=197871,["spec"]=true,["name"]="Dark Archangel",["duration"]=60,["icon"]=1445237,["spellID"]=197871 },
		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=197862,["spec"]=true,["name"]="Archangel",["duration"]=60,["icon"]=458225,["spellID"]=197862 },

		{ ["class"]="PRIEST",["type"]="dispel",["buff"]=527,["spec"]={256,257},["name"]="Purify",["duration"]=8,["icon"]=135894,["spellID"]=527 },
		{ ["class"]="PRIEST",["type"]="defensive",["buff"]=215769,["spec"]=215982,["name"]="Spirit of the Redeemer",["duration"]=120,["icon"]=132864,["spellID"]=215769 },
		{ ["class"]="PRIEST",["type"]="defensive",["buff"]=328530,["spec"]=true,["name"]="Divine Ascension",["duration"]=60,["icon"]=642580,["spellID"]=328530, },
		{ ["class"]="PRIEST",["type"]="externalDefensive",["buff"]=197268,["spec"]=true,["name"]="Ray of Hope",["duration"]=90,["icon"]=1445239,["spellID"]=197268, },

		{ ["class"]="PRIEST",["type"]="counterCC",["buff"]=213610,["spec"]=true,["name"]="Holy Ward",["duration"]=45,["icon"]=458722,["spellID"]=213610, },
		{ ["class"]="PRIEST",["type"]="cc",["buff"]=8122,["name"]="Psychic Scream",["duration"]=45,["icon"]=136184,["spellID"]=8122, },

		{ ["class"]="PRIEST",["type"]="other",["buff"]=586,["name"]="Fade",["duration"]=30,["icon"]=135994,["spellID"]=586, },
		{ ["class"]="PRIEST",["type"]="defensive",["buff"]=19236,["name"]="Desperate Prayer",["duration"]=90,["icon"]=237550,["spellID"]=19236, },
		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=316262,["spec"]=true,["name"]="Thoughtsteal",["duration"]=90,["icon"]=3718862,["spellID"]=316262, },




		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=372760,["spec"]=true,["maxRanks"]=1,["name"]="Divine Word",["ID"]=3,["duration"]=60,["icon"]=521584,["spellID"]=372760, },


		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=205385,["spec"]=true,["maxRanks"]=1,["name"]="Shadow Crash",["ID"]=6,["duration"]=30,["icon"]=136201,["spellID"]=205385, },







		{ ["class"]="PRIEST",["type"]="raidDefensive",["buff"]=81782,["spec"]=true,["maxRanks"]=1,["name"]="Power Word: Barrier",["ID"]=13,["duration"]=180,["icon"]=253400,["spellID"]=62618, },

		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=246287,["spec"]=true,["maxRanks"]=1,["name"]="Evangelism",["ID"]=15,["duration"]=90,["icon"]=135895,["spellID"]=246287, },








		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=373178,["spec"]=true,["maxRanks"]=1,["name"]="Light's Wrath",["ID"]=23,["duration"]=90,["icon"]=1271590,["spellID"]=373178, },




		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=214621,["spec"]=true,["maxRanks"]=1,["name"]="Schism",["ID"]=27,["duration"]=24,["icon"]=463285,["spellID"]=214621, },

		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=314867,["spec"]=true,["maxRanks"]=1,["name"]="Shadow Covenant",["ID"]=29,["duration"]=30,["icon"]=136221,["spellID"]=314867, },



		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=123040,["spec"]=true,["maxRanks"]=1,["name"]="Mindbender",["ID"]=32,["duration"]=60,["icon"]=136214,["spellID"]=123040, },


		{ ["class"]="PRIEST",["type"]="externalDefensive",["buff"]=33206,["spec"]=true,["maxRanks"]=1,["name"]="Pain Suppression",["ID"]=35,["duration"]=180,["icon"]=135936,["spellID"]=33206, },













		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=47536,["spec"]=true,["maxRanks"]=1,["name"]="Rapture",["ID"]=46,["duration"]=90,["icon"]=237548,["spellID"]=47536, },




		{ ["class"]="PRIEST",["type"]="raidDefensive",["buff"]=372835,["spec"]=true,["maxRanks"]=1,["name"]="Lightwell",["ID"]=51,["duration"]=180,["icon"]=135980,["spellID"]=372835, },


		{ ["class"]="PRIEST",["type"]="defensive",["buff"]=391124,["spec"]=true,["maxRanks"]=1,["name"]="Restitution",["ID"]=53,["duration"]=600,["icon"]=1295528,["spellID"]=391124, },


		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=372616,["spec"]=true,["maxRanks"]=1,["name"]="Empyreal Blaze",["ID"]=55,["duration"]=60,["icon"]=525023,["spellID"]=372616, },


		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=200183,["spec"]=true,["maxRanks"]=1,["name"]="Apotheosis",["ID"]=58,["duration"]=120,["icon"]=1060983,["spellID"]=200183, },
		{ ["class"]="PRIEST",["type"]="raidDefensive",["buff"]=265202,["spec"]=true,["maxRanks"]=1,["name"]="Holy Word: Salvation",["ID"]=58,["duration"]=720,["icon"]=458225,["spellID"]=265202, },







		{ ["class"]="PRIEST",["type"]="other",["buff"]=64901,["spec"]=true,["maxRanks"]=1,["name"]="Symbol of Hope",["ID"]=65,["duration"]=180,["icon"]=135982,["spellID"]=64901, },



		{ ["class"]="PRIEST",["type"]="raidDefensive",["buff"]=64843,["spec"]=true,["maxRanks"]=1,["name"]="Divine Hymn",["ID"]=69,["duration"]=180,["icon"]=237540,["spellID"]=64843, },











		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=34861,["spec"]=true,["maxRanks"]=1,["name"]="Holy Word: Sanctify",["charges"]=1,["ID"]=80,["duration"]=60,["icon"]=237541,["spellID"]=34861, },






		{ ["class"]="PRIEST",["type"]="externalDefensive",["buff"]=47788,["spec"]=true,["maxRanks"]=1,["name"]="Guardian Spirit",["ID"]=85,["duration"]=180,["icon"]=237542,["spellID"]=47788, },
		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=2050,["spec"]=true,["maxRanks"]=1,["name"]="Holy Word: Serenity",["charges"]=1,["ID"]=86,["duration"]=60,["icon"]=135937,["spellID"]=2050, },
		{ ["class"]="PRIEST",["type"]="cc",["buff"]=88625,["spec"]=true,["maxRanks"]=1,["name"]="Holy Word: Chastise",["ID"]=87,["duration"]=60,["icon"]=135886,["spellID"]=88625, },









		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=200174,["spec"]=true,["maxRanks"]=1,["name"]="Mindbender",["ID"]=96,["duration"]=60,["icon"]=136214,["spellID"]=200174, },

		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=263346,["spec"]=true,["maxRanks"]=1,["name"]="Dark Void",["ID"]=98,["duration"]=30,["icon"]=132851,["spellID"]=263346, },

		{ ["class"]="PRIEST",["type"]="interrupt",["buff"]=15487,["spec"]=true,["maxRanks"]=1,["name"]="Silence",["ID"]=99,["duration"]=45,["icon"]=458230,["spellID"]=15487, },
		{ ["class"]="PRIEST",["type"]="cc",["buff"]=64044,["spec"]=true,["maxRanks"]=1,["name"]="Psychic Horror",["ID"]=100,["duration"]=45,["icon"]=237568,["spellID"]=64044, },


		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=263165,["spec"]=true,["maxRanks"]=1,["name"]="Void Torrent",["ID"]=102,["duration"]=60,["icon"]=1386551,["spellID"]=263165, },
		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=341374,["spec"]=true,["maxRanks"]=1,["name"]="Damnation",["ID"]=102,["duration"]=60,["icon"]=236295,["spellID"]=341374, },


		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=391109,["spec"]=true,["maxRanks"]=1,["name"]="Dark Ascension",["ID"]=105,["duration"]=60,["icon"]=1445237,["spellID"]=391109, },
		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=228260,["spec"]=true,["maxRanks"]=1,["name"]="Void Eruption",["ID"]=105,["duration"]=120,["icon"]=1386548,["spellID"]=228260, },






		{ ["class"]="PRIEST",["type"]="defensive",["buff"]=47585,["spec"]=true,["maxRanks"]=1,["name"]="Dispersion",["ID"]=111,["duration"]=120,["icon"]=237563,["spellID"]=47585, },











		{ ["class"]="PRIEST",["type"]="defensive",["buff"]=108968,["spec"]=true,["maxRanks"]=1,["name"]="Void Shift",["ID"]=122,["duration"]=300,["icon"]=537079,["spellID"]=108968, },

		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=373481,["spec"]=true,["maxRanks"]=1,["name"]="Power Word: Life",["ID"]=124,["duration"]=30,["icon"]=4667420,["spellID"]=373481, },




		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=120644,["spec"]=true,["maxRanks"]=1,["name"]="Halo",["ID"]=128,["duration"]=40,["icon"]=632353,["spellID"]=120644, },



		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=120517,["spec"]=true,["maxRanks"]=1,["name"]="Halo",["ID"]=130,["duration"]=40,["icon"]=632352,["spellID"]=120517, },




		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=375901,["spec"]={375901,321079},["maxRanks"]=1,["name"]="Mindgames",["ID"]=135,["duration"]=45,["icon"]=3565723,["spellID"]=375901, },



		{ ["class"]="PRIEST",["type"]="defensive",["buff"]=15286,["spec"]=true,["maxRanks"]=1,["name"]="Vampiric Embrace",["ID"]=139,["duration"]=120,["icon"]=136230,["spellID"]=15286, },


		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=10060,["spec"]=true,["maxRanks"]=1,["name"]="Power Infusion",["ID"]=142,["duration"]=120,["icon"]=135939,["spellID"]=10060, },




		{ ["class"]="PRIEST",["type"]="dispel",["buff"]=32375,["spec"]=true,["maxRanks"]=1,["name"]="Mass Dispel",["ID"]=147,["duration"]=45,["icon"]=135739,["spellID"]=32375, },



		{ ["class"]="PRIEST",["type"]="other",["buff"]=121557,["spec"]=true,["maxRanks"]=1,["name"]="Angelic Feather",["charges"]=3,["ID"]=151,["duration"]=20,["icon"]=642580,["spellID"]=121536, },
		{ ["class"]="PRIEST",["type"]="dispel",["buff"]=213634,["spec"]=true,["maxRanks"]=1,["name"]="Purify Disease",["charges"]=1,["ID"]=152,["duration"]=8,["icon"]=135935,["spellID"]=213634, },





		{ ["class"]="PRIEST",["type"]="disarm",["buff"]=108920,["spec"]=true,["maxRanks"]=1,["name"]="Void Tendrils",["ID"]=156,["duration"]=60,["icon"]=537022,["spellID"]=108920, },

		{ ["class"]="PRIEST",["type"]="cc",["buff"]=205364,["spec"]=true,["maxRanks"]=1,["name"]="Dominate Mind",["ID"]=158,["duration"]=30,["icon"]=1386549,["spellID"]=205364, },


		{ ["class"]="PRIEST",["type"]="counterCC",["buff"]=32379,["spec"]=true,["maxRanks"]=1,["name"]="Shadow Word: Death",["charges"]=1,["ID"]=160,["duration"]=20,["icon"]=136149,["spellID"]=32379, },
		{ ["class"]="PRIEST",["type"]="offensive",["buff"]=34433,["spec"]=true,["maxRanks"]=1,["name"]="Shadowfiend",["ID"]=161,["duration"]=180,["icon"]=136199,["spellID"]=34433,["talent"]=200174, },


		{ ["class"]="PRIEST",["type"]="other",["buff"]=73325,["spec"]=true,["maxRanks"]=1,["name"]="Leap of Faith",["ID"]=164,["duration"]=90,["icon"]=463835,["spellID"]=73325, },








	},
	["PALADIN"] = {
		{ ["class"]="PALADIN",["type"]="dispel",["buff"]=4987,["spec"]=65,["duration"]=8,["name"]="Cleanse",["icon"]=135949,["spellID"]=4987, },
		{ ["class"]="PALADIN",["type"]="externalDefensive",["buff"]=199452,["spec"]=true,["duration"]=60,["name"]="Ultimate Sacrifice",["icon"]=135966,["spellID"]=199452, },
		{ ["class"]="PALADIN",["type"]="disarm",["buff"]=215652,["spec"]=true,["duration"]=45,["name"]="Shield of Virtue",["icon"]=237452,["spellID"]=215652, },
		{ ["class"]="PALADIN",["type"]="other",["buff"]=207028,["spec"]=true,["duration"]=20,["name"]="Inquisition",["icon"]=135984,["spellID"]=207028, },
		{ ["class"]="PALADIN",["type"]="immunity",["buff"]=228049,["spec"]=true,["duration"]=300,["name"]="Guardian of the Forgotten Queen",["icon"]=135919,["spellID"]=228049, },





		{ ["class"]="PALADIN",["type"]="cc",["buff"]=853,["duration"]=60,["name"]="Hammer of Justice",["icon"]=135963,["spellID"]=853, },
		{ ["class"]="PALADIN",["type"]="counterCC",["buff"]=210256,["spec"]=true,["duration"]=15,["name"]="Blessing of Sanctuary",["icon"]=135911,["spellID"]=210256, },

		{ ["class"]="PALADIN",["type"]="other",["buff"]=62124,["duration"]=8,["name"]="Hand of Reckoning",["icon"]=135984,["spellID"]=62124,["talent"]=207028, },
		{ ["class"]="PALADIN",["type"]="immunity",["buff"]=642,["duration"]=300,["name"]="Divine Shield",["icon"]=524354,["spellID"]=642, },














		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=31850,["spec"]=true,["maxRanks"]=1,["name"]="Ardent Defender",["ID"]=12,["duration"]=120,["icon"]=135870,["spellID"]=31850, },


		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=389539,["spec"]=true,["maxRanks"]=1,["name"]="Sentinel",["ID"]=14,["duration"]=120,["icon"]=135922,["spellID"]=389539, },
		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=378279,["spec"]=true,["maxRanks"]=2,["name"]="Gift of the Golden Val'kyr",["ID"]=15,["duration"]=45,["icon"]=1349535,["spellID"]=378279, },




		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=378974,["spec"]=true,["maxRanks"]=1,["name"]="Bastion of Light",["ID"]=19,["duration"]=120,["icon"]=535594,["spellID"]=378974, },

		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=86659,["spec"]=true,["maxRanks"]=1,["name"]="Guardian of Ancient Kings",["ID"]=21,["duration"]=300,["icon"]=135919,["spellID"]=86659,["talent"]=228049, },








		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=375576,["spec"]={375576,321076},["maxRanks"]=1,["name"]="Divine Toll",["ID"]=27,["duration"]=60,["icon"]=3565448,["spellID"]=375576, },
		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=387174,["spec"]=true,["maxRanks"]=1,["name"]="Eye of Tyr",["ID"]=28,["duration"]=60,["icon"]=1272527,["spellID"]=387174, },




		{ ["class"]="PALADIN",["type"]="interrupt",["buff"]=31935,["spec"]=true,["maxRanks"]=1,["name"]="Avenger's Shield",["ID"]=33,["duration"]=15,["icon"]=135874,["spellID"]=31935, },


		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=327193,["spec"]=true,["maxRanks"]=1,["name"]="Moment of Glory",["ID"]=36,["duration"]=90,["icon"]=237537,["spellID"]=327193, },

		{ ["class"]="PALADIN",["type"]="dispel",["buff"]=213644,["spec"]=true,["maxRanks"]=1,["name"]="Cleanse Toxins",["charges"]=1,["ID"]=38,["duration"]=8,["icon"]=135953,["spellID"]=213644, },









		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=205191,["spec"]=true,["maxRanks"]=1,["name"]="Eye for an Eye",["ID"]=48,["duration"]=60,["icon"]=135986,["spellID"]=205191, },






		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=383469,["spec"]=384052,["maxRanks"]=1,["name"]="Radiant Decree",["ID"]=54,["duration"]=15,["icon"]=1109507,["spellID"]=383469, },

		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=255937,["spec"]=true,["maxRanks"]=1,["name"]="Wake of Ashes",["ID"]=55,["duration"]=45,["icon"]=1112939,["spellID"]=255937,["talent"]=384052, },

		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=231895,["spec"]=true,["maxRanks"]=1,["name"]="Crusade",["ID"]=56,["duration"]=120,["icon"]=236262,["spellID"]=231895, },













		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=343527,["spec"]=true,["maxRanks"]=1,["name"]="Execution Sentence",["ID"]=68,["duration"]=60,["icon"]=613954,["spellID"]=343527, },



		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=183218,["spec"]=true,["maxRanks"]=1,["name"]="Hand of Hindrance",["ID"]=72,["duration"]=30,["icon"]=1360760,["spellID"]=183218, },
		{ ["class"]="PALADIN",["type"]="cc",["buff"]=383185,["spec"]=true,["maxRanks"]=1,["name"]="Exorcism",["ID"]=73,["duration"]=20,["icon"]=135903,["spellID"]=383185, },



		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=184662,["spec"]=true,["maxRanks"]=1,["name"]="Shield of Vengeance",["ID"]=76,["duration"]=120,["icon"]=236264,["spellID"]=184662, },
		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=498,["spec"]=true,["maxRanks"]=1,["name"]="Divine Protection",["ID"]=76,["duration"]={[70]=120,["default"]=60},["icon"]=524353,["spellID"]=498, },


		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=343721,["spec"]=true,["maxRanks"]=1,["name"]="Final Reckoning",["ID"]=79,["duration"]=60,["icon"]=135878,["spellID"]=343721, },












		{ ["class"]="PALADIN",["type"]="externalDefensive",["buff"]=148039,["spec"]=true,["maxRanks"]=1,["name"]="Barrier of Faith",["ID"]=89,["duration"]=30,["icon"]=4067370,["spellID"]=148039, },



		{ ["class"]="PALADIN",["type"]="other",["buff"]=214202,["spec"]=true,["maxRanks"]=1,["name"]="Rule of Law",["charges"]=2,["ID"]=93,["duration"]=30,["icon"]=571556,["spellID"]=214202, },
		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=157047,["spec"]=true,["maxRanks"]=1,["name"]="Saved by the Light",["ID"]=94,["duration"]=60,["icon"]=1030102,["spellID"]=157047, },





		{ ["class"]="PALADIN",["type"]="raidDefensive",["buff"]=31821,["spec"]=true,["maxRanks"]=1,["name"]="Aura Mastery",["ID"]=98,["duration"]=180,["icon"]=135872,["spellID"]=31821, },


		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=210294,["spec"]=true,["maxRanks"]=1,["name"]="Divine Favor",["ID"]=101,["duration"]=45,["icon"]=135915,["spellID"]=210294, },








		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=114165,["spec"]=true,["maxRanks"]=1,["name"]="Holy Prism",["ID"]=108,["duration"]=20,["icon"]=613408,["spellID"]=114165, },
		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=114158,["spec"]=true,["maxRanks"]=1,["name"]="Light's Hammer",["ID"]=108,["duration"]=60,["icon"]=613955,["spellID"]=114158, },






		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=216331,["spec"]=true,["maxRanks"]=1,["name"]="Avenging Crusader",["ID"]=115,["duration"]=120,["icon"]=589117,["spellID"]=216331, },




		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=200652,["spec"]=true,["maxRanks"]=1,["name"]="Tyr's Deliverance",["ID"]=119,["duration"]=90,["icon"]=1122562,["spellID"]=200652, },





		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=388007,["spec"]={388007,321077},["maxRanks"]=1,["name"]="Blessing of Summer",["ID"]=124,["duration"]=45,["icon"]=3636845,["spellID"]=388007, },



		{ ["class"]="PALADIN",["type"]="defensive",["buff"]=633,["spec"]=true,["maxRanks"]=1,["name"]="Lay on Hands",["ID"]=128,["duration"]=600,["icon"]=135928,["spellID"]=633, },
		{ ["class"]="PALADIN",["type"]="cc",["buff"]=115750,["spec"]=true,["maxRanks"]=1,["name"]="Blinding Light",["ID"]=129,["duration"]=90,["icon"]=571553,["spellID"]=115750, },
		{ ["class"]="PALADIN",["type"]="cc",["buff"]=20066,["spec"]=true,["maxRanks"]=1,["name"]="Repentance",["ID"]=129,["duration"]=15,["icon"]=135942,["spellID"]=20066, },

		{ ["class"]="PALADIN",["type"]="other",["buff"]=1044,["spec"]=true,["maxRanks"]=1,["name"]="Blessing of Freedom",["charges"]=1,["ID"]=131,["duration"]=25,["icon"]=135968,["spellID"]=1044, },



		{ ["class"]="PALADIN",["type"]="interrupt",["buff"]=96231,["spec"]=true,["maxRanks"]=1,["name"]="Rebuke",["ID"]=135,["duration"]=15,["icon"]=523893,["spellID"]=96231, },

		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=31884,["spec"]=true,["maxRanks"]=1,["name"]="Avenging Wrath",["ID"]=137,["duration"]=120,["icon"]=135875,["spellID"]=31884,["talent"]={216331,231895,389539}, },








		{ ["class"]="PALADIN",["type"]="externalDefensive",["buff"]=6940,["spec"]=true,["maxRanks"]=1,["name"]="Blessing of Sacrifice",["charges"]=1,["ID"]=145,["duration"]=120,["icon"]=135966,["spellID"]=6940,["talent"]=199452, },

		{ ["class"]="PALADIN",["type"]="externalDefensive",["buff"]=1022,["spec"]=true,["maxRanks"]=1,["name"]="Blessing of Protection",["charges"]=1,["ID"]=147,["duration"]=300,["icon"]=135964,["spellID"]=1022, },


		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=105809,["spec"]=true,["maxRanks"]=1,["name"]="Holy Avenger",["ID"]=149,["duration"]=180,["icon"]=571555,["spellID"]=105809, },

		{ ["class"]="PALADIN",["type"]="offensive",["buff"]=152262,["spec"]=true,["maxRanks"]=1,["name"]="Seraphim",["ID"]=151,["duration"]=45,["icon"]=1030103,["spellID"]=152262, },











		{ ["class"]="PALADIN",["type"]="cc",["buff"]=10326,["spec"]=true,["maxRanks"]=1,["name"]="Turn Evil",["ID"]=161,["duration"]=15,["icon"]=571559,["spellID"]=10326, },


		{ ["class"]="PALADIN",["type"]="other",["buff"]=221886,["spec"]=true,["maxRanks"]=1,["name"]="Divine Steed",["charges"]=1,["ID"]=163,["duration"]=45,["icon"]=1360759,["spellID"]=190784, },
		{ ["class"]="PALADIN",["type"]="externalDefensive",["buff"]=204018,["spec"]=true,["maxRanks"]=1,["name"]="Blessing of Spellwarding",["charges"]=1,["ID"]=164,["duration"]=300,["icon"]=135880,["spellID"]=204018, },


	},
	["SHAMAN"] = {
		{ ["class"]="SHAMAN",["type"]="other",["buff"]=2484,["name"]="Earthbind Totem",["duration"]=30,["icon"]=136102,["spellID"]=2484, },
		{ ["class"]="SHAMAN",["type"]="defensive",["buff"]=210918,["spec"]=true,["name"]="Ethereal Form",["duration"]=60,["icon"]=237572,["spellID"]=210918, },
		{ ["class"]="SHAMAN",["type"]="other",["buff"]=204366,["spec"]=true,["name"]="Thundercharge",["duration"]=45,["icon"]=1385916,["spellID"]=204366, },
		{ ["class"]="SHAMAN",["type"]="disarm",["buff"]=355580,["spec"]=true,["name"]="Static Field Totem",["duration"]=60,["icon"]=1020304,["spellID"]=355580, },
		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=193876,["spec"]=true,["name"]="Shamanism",["duration"]=60,["icon"]=454482,["spellID"]=193876, },
		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=2825,["name"]="Bloodlust",["duration"]=300,["icon"]=236288,["spellID"]=2825,["pve"]=true,["talent"]=193876, },
		{ ["class"]="SHAMAN",["type"]="dispel",["buff"]=77130,["spec"]=264,["name"]="Purify Spirit",["duration"]=8,["icon"]=236288,["spellID"]=77130, },
		{ ["class"]="SHAMAN",["type"]="disarm",["buff"]=356736,["spec"]=true,["name"]="Unleashed Shield",["duration"]=30,["icon"]=538567,["spellID"]=356736, },
		{ ["class"]="SHAMAN",["type"]="counterCC",["buff"]=204336,["spec"]=true,["name"]="Grounding Totem",["duration"]=30,["icon"]=136039,["spellID"]=204336, },
		{ ["class"]="SHAMAN",["type"]="defensive",["buff"]=204331,["spec"]=true,["name"]="Counterstrike Totem",["duration"]=45,["icon"]=511726,["spellID"]=204331, },
		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=204330,["spec"]=true,["name"]="Skyfury Totem",["duration"]=40,["icon"]=135829,["spellID"]=204330, },
		{ ["class"]="SHAMAN",["type"]="other",["buff"]=20608,["name"]="Reincarnation",["duration"]=1800,["icon"]=451167,["spellID"]=20608, },












		{ ["class"]="SHAMAN",["type"]="other",["buff"]=196884,["spec"]=true,["maxRanks"]=1,["name"]="Feral Lunge",["ID"]=10,["duration"]=30,["icon"]=1027879,["spellID"]=196884, },











		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=384352,["spec"]=true,["maxRanks"]=1,["name"]="Doom Winds",["ID"]=22,["duration"]=90,["icon"]=1035054,["spellID"]=384352, },





		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=375982,["spec"]={375982,321078},["maxRanks"]=1,["name"]="Primordial Wave",["charges"]=1,["ID"]=28,["duration"]=45,["icon"]=3578231,["spellID"]=375982, },







		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=51533,["spec"]=true,["maxRanks"]=1,["name"]="Feral Spirit",["ID"]=35,["duration"]=90,["icon"]=237577,["spellID"]=51533, },










		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=198067,["spec"]=true,["maxRanks"]=1,["name"]="Fire Elemental",["charges"]=1,["ID"]=44,["duration"]=150,["icon"]=135790,["spellID"]=198067, },
		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=192249,["spec"]=true,["maxRanks"]=1,["name"]="Storm Elemental",["charges"]=1,["ID"]=44,["duration"]=150,["icon"]=2065626,["spellID"]=192249, },









		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=191634,["spec"]=true,["maxRanks"]=1,["name"]="Stormkeeper",["ID"]=52,["duration"]=60,["icon"]=839977,["spellID"]=191634, },









		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=210714,["spec"]=true,["maxRanks"]=1,["name"]="Icefury",["ID"]=60,["duration"]=30,["icon"]=135855,["spellID"]=210714, },







		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=114050,["spec"]=true,["maxRanks"]=1,["name"]="Ascendance",["ID"]=66,["duration"]=180,["icon"]=135791,["spellID"]=114050, },





		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=192222,["spec"]=true,["maxRanks"]=1,["name"]="Liquid Magma Totem",["ID"]=71,["duration"]=60,["icon"]=971079,["spellID"]=192222, },



























		{ ["class"]="SHAMAN",["type"]="raidDefensive",["buff"]=108280,["spec"]=true,["maxRanks"]=1,["name"]="Healing Tide Totem",["ID"]=95,["duration"]=180,["icon"]=538569,["spellID"]=108280, },
		{ ["class"]="SHAMAN",["type"]="raidDefensive",["buff"]=98008,["spec"]=true,["maxRanks"]=1,["name"]="Spirit Link Totem",["charges"]=1,["ID"]=96,["duration"]=180,["icon"]=237586,["spellID"]=98008, },















		{ ["class"]="SHAMAN",["type"]="other",["buff"]=16191,["spec"]=true,["maxRanks"]=1,["name"]="Mana Tide Totem",["ID"]=108,["duration"]=180,["icon"]=4667424,["spellID"]=16191, },
		{ ["class"]="SHAMAN",["type"]="defensive",["buff"]=198838,["spec"]=true,["maxRanks"]=1,["name"]="Earthen Wall Totem",["ID"]=109,["duration"]=60,["icon"]=136098,["spellID"]=198838, },
		{ ["class"]="SHAMAN",["type"]="defensive",["buff"]=207399,["spec"]=true,["maxRanks"]=1,["name"]="Ancestral Protection Totem",["ID"]=109,["duration"]=300,["icon"]=136080,["spellID"]=207399, },

		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=157153,["spec"]=true,["maxRanks"]=1,["name"]="Cloudburst Totem",["charges"]=1,["ID"]=111,["duration"]=45,["icon"]=971076,["spellID"]=157153, },



		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=197995,["spec"]=true,["maxRanks"]=1,["name"]="Wellspring",["ID"]=114,["duration"]=20,["icon"]=893778,["spellID"]=197995, },


		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=382029,["spec"]=true,["maxRanks"]=1,["name"]="Ever-Rising Tide",["ID"]=116,["duration"]=30,["icon"]=132852,["spellID"]=382029, },

		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=114052,["spec"]=true,["maxRanks"]=1,["name"]="Ascendance",["ID"]=118,["duration"]=180,["icon"]=135791,["spellID"]=114052, },


		{ ["class"]="SHAMAN",["type"]="defensive",["buff"]=108271,["spec"]=true,["maxRanks"]=1,["name"]="Astral Shift",["ID"]=120,["duration"]=120,["icon"]=538565,["spellID"]=108271,["talent"]=210918, },






		{ ["class"]="SHAMAN",["type"]="defensive",["buff"]=198103,["spec"]=true,["maxRanks"]=1,["name"]="Earth Elemental",["ID"]=127,["duration"]=300,["icon"]=136024,["spellID"]=198103, },


		{ ["class"]="SHAMAN",["type"]="other",["buff"]=79206,["spec"]=true,["maxRanks"]=1,["name"]="Spiritwalker's Grace",["ID"]=129,["duration"]=120,["icon"]=451170,["spellID"]=79206, },

		{ ["class"]="SHAMAN",["type"]="interrupt",["buff"]=57994,["spec"]=true,["maxRanks"]=1,["name"]="Wind Shear",["ID"]=131,["duration"]=12,["icon"]=136018,["spellID"]=57994, },
		{ ["class"]="SHAMAN",["type"]="counterCC",["buff"]=8143,["spec"]=true,["maxRanks"]=1,["name"]="Tremor Totem",["ID"]=132,["duration"]=60,["icon"]=136108,["spellID"]=8143, },


		{ ["class"]="SHAMAN",["type"]="cc",["buff"]=192058,["spec"]=true,["maxRanks"]=1,["name"]="Capacitor Totem",["ID"]=134,["duration"]=60,["icon"]=136013,["spellID"]=192058, },




		{ ["class"]="SHAMAN",["type"]="dispel",["buff"]=51886,["spec"]=true,["maxRanks"]=1,["name"]="Cleanse Spirit",["ID"]=138,["duration"]=8,["icon"]=236288,["spellID"]=51886, },

		{ ["class"]="SHAMAN",["type"]="dispel",["buff"]=378773,["spec"]=true,["maxRanks"]=1,["name"]="Greater Purge",["ID"]=139,["duration"]=12,["icon"]=451166,["spellID"]=378773, },



		{ ["class"]="SHAMAN",["type"]="cc",["buff"]=51514,["spec"]=true,["maxRanks"]=1,["name"]="Hex",["ID"]=142,["duration"]=30,["icon"]=237579,["spellID"]=51514, },

		{ ["class"]="SHAMAN",["type"]="defensive",["buff"]=30884,["spec"]=true,["maxRanks"]=2,["name"]="Nature's Guardian",["ID"]=144,["duration"]=45,["icon"]=136060,["spellID"]=30884, },
		{ ["class"]="SHAMAN",["type"]="disarm",["buff"]=51485,["spec"]=true,["maxRanks"]=1,["name"]="Earthgrab Totem",["ID"]=145,["duration"]=60,["icon"]=136100,["spellID"]=51485, },
		{ ["class"]="SHAMAN",["type"]="raidMovement",["buff"]=192077,["spec"]=true,["maxRanks"]=1,["name"]="Wind Rush Totem",["ID"]=145,["duration"]=120,["icon"]=538576,["spellID"]=192077, },





		{ ["class"]="SHAMAN",["type"]="other",["buff"]=192063,["spec"]=true,["maxRanks"]=1,["name"]="Gust of Wind",["ID"]=151,["duration"]=30,["icon"]=1029585,["spellID"]=192063, },
		{ ["class"]="SHAMAN",["type"]="other",["buff"]=58875,["spec"]=true,["maxRanks"]=1,["name"]="Spirit Walk",["ID"]=151,["duration"]=60,["icon"]=132328,["spellID"]=58875, },



		{ ["class"]="SHAMAN",["type"]="other",["buff"]=108285,["spec"]=true,["maxRanks"]=1,["name"]="Totemic Recall",["ID"]=154,["duration"]=180,["icon"]=538570,["spellID"]=108285, },

		{ ["class"]="SHAMAN",["type"]="dispel",["buff"]=383013,["spec"]=true,["maxRanks"]=1,["name"]="Poison Cleansing Totem",["ID"]=156,["duration"]=45,["icon"]=136070,["spellID"]=383013, },

		{ ["class"]="SHAMAN",["type"]="defensive",["buff"]=383017,["spec"]=true,["maxRanks"]=1,["name"]="Stoneskin Totem",["ID"]=158,["duration"]=30,["icon"]=4667425,["spellID"]=383017, },
		{ ["class"]="SHAMAN",["type"]="counterCC",["buff"]=383019,["spec"]=true,["maxRanks"]=1,["name"]="Tranquil Air Totem",["ID"]=158,["duration"]=60,["icon"]=538575,["spellID"]=383019, },
		{ ["class"]="SHAMAN",["type"]="cc",["buff"]=305483,["spec"]=true,["maxRanks"]=1,["name"]="Lightning Lasso",["ID"]=159,["duration"]=45,["icon"]=1385911,["spellID"]=305483, },

		{ ["class"]="SHAMAN",["type"]="disarm",["buff"]=51490,["spec"]=true,["maxRanks"]=1,["name"]="Thunderstorm",["ID"]=160,["duration"]=30,["icon"]=237589,["spellID"]=51490, },

		{ ["class"]="SHAMAN",["type"]="other",["buff"]=378081,["spec"]=true,["maxRanks"]=1,["name"]="Nature's Swiftness",["ID"]=162,["duration"]=60,["icon"]=136076,["spellID"]=378081, },
		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=5394,["spec"]=true,["maxRanks"]=1,["name"]="Healing Stream Totem",["ID"]=163,["duration"]=30,["icon"]=135127,["spellID"]=5394, },

		{ ["class"]="SHAMAN",["type"]="defensive",["buff"]=108281,["spec"]=true,["maxRanks"]=1,["name"]="Ancestral Guidance",["ID"]=165,["duration"]=120,["icon"]=538564,["spellID"]=108281, },





		{ ["class"]="SHAMAN",["type"]="offensive",["buff"]=114051,["spec"]=true,["maxRanks"]=1,["name"]="Ascendance",["ID"]=170,["duration"]=180,["icon"]=135791,["spellID"]=114051, },
	},
	["MAGE"] = {
		{ ["class"]="MAGE",["type"]="offensive",["buff"]=353128,["spec"]=true,["duration"]=45,["name"]="Arcanosphere",["icon"]=4226155,["spellID"]=353128, },
		{ ["class"]="MAGE",["type"]="dispel",["buff"]=198100,["spec"]=true,["duration"]=30,["name"]="Kleptomania",["icon"]=610472,["spellID"]=198100, },
		{ ["class"]="MAGE",["type"]="defensive",["buff"]=198111,["spec"]=true,["duration"]=45,["name"]="Temporal Shield",["icon"]=610472,["spellID"]=198111, },
		{ ["class"]="MAGE",["type"]="defensive",["buff"]=198158,["spec"]=true,["duration"]=60,["name"]="Mass Invisibility",["icon"]=1387356,["spellID"]=198158, },

		{ ["class"]="MAGE",["type"]="cc",["buff"]=389794,["spec"]=true,["duration"]=45,["name"]="Snowdrift",["icon"]=135783,["spellID"]=389794, },

		{ ["class"]="MAGE",["type"]="offensive",["buff"]=353082,["spec"]=true,["duration"]=30,["name"]="Ring of Fire",["icon"]=4067368,["spellID"]=353082, },
		{ ["class"]="MAGE",["type"]="disarm",["buff"]=352278,["spec"]=true,["duration"]=90,["name"]="Ice Wall",["icon"]=4226156,["spellID"]=352278, },
		{ ["class"]="MAGE",["type"]="offensive",["buff"]=198144,["spec"]=true,["duration"]=60,["name"]="Ice Form",["icon"]=1387355,["spellID"]=198144, },
		{ ["class"]="MAGE",["type"]="offensive",["buff"]=80353,["duration"]=300,["name"]="Time Warp",["icon"]=458224,["spellID"]=80353, },

		{ ["class"]="MAGE",["type"]="interrupt",["buff"]=2139,["duration"]=24,["name"]="Counterspell",["icon"]=135856,["spellID"]=2139, },
		{ ["class"]="MAGE",["type"]="disarm",["buff"]=122,["duration"]=30,["name"]="Frost Nova",["icon"]=135848,["spellID"]=122, },
		{ ["class"]="MAGE",["type"]="other",["buff"]=1953,["duration"]=15,["name"]="Blink",["icon"]=135736,["spellID"]=1953,["talent"]=212653, },


		{ ["class"]="MAGE",["type"]="offensive",["buff"]=382440,["spec"]={382440,321077},["maxRanks"]=1,["name"]="Shifting Power",["ID"]=3,["duration"]=60,["icon"]=3636841,["spellID"]=382440, },


		{ ["class"]="MAGE",["type"]="cc",["buff"]=113724,["spec"]=true,["maxRanks"]=1,["name"]="Ring of Frost",["ID"]=6,["duration"]=45,["icon"]=464484,["spellID"]=113724, },

		{ ["class"]="MAGE",["type"]="offensive",["buff"]=153561,["spec"]=true,["maxRanks"]=1,["name"]="Meteor",["ID"]=8,["duration"]=45,["icon"]=1033911,["spellID"]=153561, },
		{ ["class"]="MAGE",["type"]="cc",["buff"]=31661,["spec"]=true,["maxRanks"]=1,["name"]="Dragon's Breath",["ID"]=9,["duration"]=45,["icon"]=134153,["spellID"]=31661, },
		{ ["class"]="MAGE",["type"]="other",["buff"]=389713,["spec"]=true,["maxRanks"]=1,["name"]="Displacement",["ID"]=10,["duration"]=45,["icon"]=132171,["spellID"]=389713, },



		{ ["class"]="MAGE",["type"]="defensive",["buff"]=110959,["spec"]=true,["maxRanks"]=1,["name"]="Greater Invisibility",["ID"]=13,["duration"]=120,["icon"]=575584,["spellID"]=110959, },







		{ ["class"]="MAGE",["type"]="disarm",["buff"]=157981,["spec"]=true,["maxRanks"]=1,["name"]="Blast Wave",["ID"]=21,["duration"]=30,["icon"]=135903,["spellID"]=157981, },

		{ ["class"]="MAGE",["type"]="other",["buff"]=212653,["spec"]=true,["maxRanks"]=1,["name"]="Shimmer",["charges"]=2,["ID"]=23,["duration"]=25,["icon"]=135739,["spellID"]=212653, },
		{ ["class"]="MAGE",["type"]="other",["buff"]=108839,["spec"]=true,["maxRanks"]=1,["name"]="Ice Floes",["charges"]=3,["ID"]=23,["duration"]=20,["icon"]=610877,["spellID"]=108839, },
		{ ["class"]="MAGE",["type"]="cc",["buff"]=383121,["spec"]=true,["maxRanks"]=1,["name"]="Mass Polymorph",["ID"]=24,["duration"]=60,["icon"]=575585,["spellID"]=383121, },







		{ ["class"]="MAGE",["type"]="offensive",["buff"]=116011,["spec"]=true,["maxRanks"]=1,["name"]="Rune of Power",["charges"]=1,["ID"]=31,["duration"]=45,["icon"]=609815,["spellID"]=116011, },

		{ ["class"]="MAGE",["type"]="defensive",["buff"]=342246,["spec"]=true,["maxRanks"]=1,["name"]="Alter Time",["ID"]=33,["duration"]=60,["icon"]=609811,["spellID"]=342245, },
		{ ["class"]="MAGE",["type"]="dispel",["buff"]=475,["spec"]=true,["maxRanks"]=1,["name"]="Remove Curse",["ID"]=34,["duration"]=8,["icon"]=136082,["spellID"]=475, },
		{ ["class"]="MAGE",["type"]="defensive",["buff"]=11426,["spec"]=true,["maxRanks"]=1,["name"]="Ice Barrier",["ID"]=35,["duration"]=25,["icon"]=135988,["spellID"]=11426, },
		{ ["class"]="MAGE",["type"]="defensive",["buff"]=66,["spec"]=true,["maxRanks"]=1,["name"]="Invisibility",["ID"]=36,["duration"]=300,["icon"]=132220,["spellID"]=66, },
		{ ["class"]="MAGE",["type"]="defensive",["buff"]=235313,["spec"]=true,["maxRanks"]=1,["name"]="Blazing Barrier",["ID"]=37,["duration"]=25,["icon"]=132221,["spellID"]=235313, },

		{ ["class"]="MAGE",["type"]="defensive",["buff"]=235450,["spec"]=true,["maxRanks"]=1,["name"]="Prismatic Barrier",["ID"]=39,["duration"]=25,["icon"]=135991,["spellID"]=235450, },
		{ ["class"]="MAGE",["type"]="immunity",["buff"]=45438,["spec"]=true,["maxRanks"]=1,["name"]="Ice Block",["ID"]=40,["duration"]=240,["icon"]=135841,["spellID"]=45438, },

		{ ["class"]="MAGE",["type"]="defensive",["buff"]=55342,["spec"]=true,["maxRanks"]=1,["name"]="Mirror Image",["ID"]=42,["duration"]=120,["icon"]=135994,["spellID"]=55342, },


		{ ["class"]="MAGE",["type"]="disarm",["buff"]=157997,["spec"]=true,["maxRanks"]=1,["name"]="Ice Nova",["ID"]=44,["duration"]=25,["icon"]=1033909,["spellID"]=157997, },





















		{ ["class"]="MAGE",["type"]="offensive",["buff"]=205025,["spec"]=true,["maxRanks"]=1,["name"]="Presence of Mind",["ID"]=64,["duration"]=45,["icon"]=136031,["spellID"]=205025, },
		{ ["class"]="MAGE",["type"]="other",["buff"]=12051,["spec"]=true,["maxRanks"]=1,["name"]="Evocation",["charges"]=1,["ID"]=65,["duration"]=90,["icon"]=136075,["spellID"]=12051, },














		{ ["class"]="MAGE",["type"]="offensive",["buff"]=205021,["spec"]=true,["maxRanks"]=1,["name"]="Ray of Frost",["ID"]=80,["duration"]=75,["icon"]=1698700,["spellID"]=205021, },







		{ ["class"]="MAGE",["type"]="offensive",["buff"]=12472,["spec"]=true,["maxRanks"]=1,["name"]="Icy Veins",["ID"]=88,["duration"]=180,["icon"]=135838,["spellID"]=12472,["talent"]=198144, },


		{ ["class"]="MAGE",["type"]="other",["buff"]=31687,["spec"]=true,["maxRanks"]=1,["name"]="Summon Water Elemental",["ID"]=90,["duration"]=30,["icon"]=135862,["spellID"]=31687, },
		{ ["class"]="MAGE",["type"]="defensive",["buff"]=235219,["spec"]=true,["maxRanks"]=1,["name"]="Cold Snap",["ID"]=91,["duration"]=300,["icon"]=135865,["spellID"]=235219, },


		{ ["class"]="MAGE",["type"]="offensive",["buff"]=84714,["spec"]=true,["maxRanks"]=1,["name"]="Frozen Orb",["ID"]=94,["duration"]=60,["icon"]=629077,["spellID"]=84714, },
		{ ["class"]="MAGE",["type"]="offensive",["buff"]=44614,["spec"]=true,["maxRanks"]=1,["name"]="Flurry",["charges"]=1,["ID"]=95,["duration"]=30,["icon"]=1506795,["spellID"]=44614, },


		{ ["class"]="MAGE",["type"]="offensive",["buff"]=257537,["spec"]=true,["maxRanks"]=1,["name"]="Ebonbolt",["ID"]=97,["duration"]=45,["icon"]=1392551,["spellID"]=257537, },


		{ ["class"]="MAGE",["type"]="offensive",["buff"]=153595,["spec"]=true,["maxRanks"]=1,["name"]="Comet Storm",["ID"]=100,["duration"]=30,["icon"]=2126034,["spellID"]=153595, },
























		{ ["class"]="MAGE",["type"]="defensive",["buff"]=86949,["spec"]=true,["maxRanks"]=1,["name"]="Cauterize",["ID"]=123,["duration"]=300,["icon"]=252268,["spellID"]=86949, },
		{ ["class"]="MAGE",["type"]="offensive",["buff"]=190319,["spec"]=true,["maxRanks"]=1,["name"]="Combustion",["ID"]=124,["duration"]=120,["icon"]=135824,["spellID"]=190319, },









		{ ["class"]="MAGE",["type"]="offensive",["buff"]=257541,["spec"]=true,["maxRanks"]=1,["name"]="Phoenix Flames",["charges"]=2,["ID"]=134,["duration"]=25,["icon"]=1392549,["spellID"]=257541, },




		{ ["class"]="MAGE",["type"]="disarm",["buff"]=157980,["spec"]=true,["maxRanks"]=1,["name"]="Supernova",["ID"]=138,["duration"]=25,["icon"]=1033912,["spellID"]=157980, },








		{ ["class"]="MAGE",["type"]="offensive",["buff"]=365350,["spec"]=true,["maxRanks"]=1,["name"]="Arcane Surge",["ID"]=147,["duration"]=90,["icon"]=4667417,["spellID"]=365350, },


		{ ["class"]="MAGE",["type"]="offensive",["buff"]=321507,["spec"]=true,["maxRanks"]=1,["name"]="Touch of the Magi",["ID"]=150,["duration"]=45,["icon"]=236222,["spellID"]=321507, },

		{ ["class"]="MAGE",["type"]="offensive",["buff"]=376103,["spec"]={376103,321076},["maxRanks"]=1,["name"]="Radiant Spark",["ID"]=152,["duration"]=30,["icon"]=3565446,["spellID"]=376103, },



		{ ["class"]="MAGE",["type"]="offensive",["buff"]=153626,["spec"]=true,["maxRanks"]=1,["name"]="Arcane Orb",["charges"]=1,["ID"]=156,["duration"]=20,["icon"]=1033906,["spellID"]=153626, },




	},
	["RACIAL"] = {
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Will to Survive",["buff"]=59752,["race"]=1,["duration"]=180,["icon"]=136129,["spellID"]=59752, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Blood Fury",["buff"]=20572,["race"]=2,["duration"]=120,["icon"]=135726,["spellID"]=20572, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Stoneform",["buff"]=20594,["race"]=3,["duration"]=120,["icon"]=136225,["spellID"]=20594, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Shadowmeld",["buff"]=58984,["race"]=4,["duration"]=120,["icon"]=132089,["spellID"]=58984, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Will of the Forsaken",["buff"]=7744,["race"]=5,["duration"]=120,["icon"]=136187,["spellID"]=7744, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="War Stomp",["buff"]=20549,["race"]=6,["duration"]=90,["icon"]=132368,["spellID"]=20549, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Escape Artist",["buff"]=20589,["race"]=7,["duration"]=60,["icon"]=132309,["spellID"]=20589, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Berserking",["buff"]=26297,["race"]=8,["duration"]=180,["icon"]=135727,["spellID"]=26297, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Rocket Jump",["buff"]=69070,["race"]=9,["duration"]=90,["icon"]=370769,["spellID"]=69070, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Arcane Torrent",["buff"]=129597,["race"]=10,["duration"]=120,["icon"]=136222,["spellID"]=129597, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Gift of the Naaru",["buff"]=59542,["race"]=11,["duration"]=180,["icon"]=135923,["spellID"]=59542, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Darkflight",["buff"]=68992,["race"]=22,["duration"]=120,["icon"]=366937,["spellID"]=68992, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Quaking Palm",["buff"]=107079,["race"]={25,26},["duration"]=120,["icon"]=572035,["spellID"]=107079, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Arcane Pulse",["buff"]=260364,["race"]=27,["duration"]=180,["icon"]=1851463,["spellID"]=260364, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Bull Rush",["buff"]=255654,["race"]=28,["duration"]=120,["icon"]=1723987,["spellID"]=255654, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Spatial Rift",["buff"]=256948,["race"]=29,["duration"]=180,["icon"]=1724004,["spellID"]=256948, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Light's Judgment",["buff"]=255647,["race"]=30,["duration"]=150,["icon"]=1724000,["spellID"]=255647, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Regeneratin'",["buff"]=291944,["race"]=31,["duration"]=150,["icon"]=1850550,["spellID"]=291944, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Haymaker",["buff"]=287712,["race"]=32,["duration"]=150,["icon"]=2447782,["spellID"]=287712, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Fireblood",["buff"]=273104,["race"]=34,["duration"]=120,["icon"]=1786406,["spellID"]=265221, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Bag of Tricks",["buff"]=312411,["race"]=35,["duration"]=90,["icon"]=3193416,["spellID"]=312411, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Ancestral Call",["buff"]=274740,["race"]=36,["duration"]=120,["icon"]=2021574,["spellID"]=274738, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Hyper Organic Light Originator",["buff"]=312924,["race"]=37,["duration"]=180,["icon"]=3192686,["spellID"]=312924, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Emergency Failsafe",["buff"]=312916,["race"]=37,["duration"]=150,["icon"]=3192688,["spellID"]=312916, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Tail Swipe",["buff"]=368970,["race"]=70,["duration"]=90,["icon"]=4622486,["spellID"]=368970, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Wing Buffet",["buff"]=357214,["race"]=70,["duration"]=90,["icon"]=4622488,["spellID"]=357214, },
		{ ["class"]="RACIAL",["type"]="racial",["name"]="Soar",["buff"]=369536,["race"]=70,["duration"]=240,["icon"]=4622485,["spellID"]=369536, },
	},
	["PVPTRINKET"] = {

		{ ["class"]="PVPTRINKET",["type"]="pvptrinket",["name"]="Gladiator's Medallion",["buff"]=336126,["duration"]=120,["icon"]=1322720,["spellID"]=336126,["item"]=181333, },
		{ ["class"]="PVPTRINKET",["type"]="pvptrinket",["name"]="Adaptation",["buff"]=336135,["duration"]=60,["icon"]=895886,["spellID"]=336135,["item"]=181816, },

		{ ["class"]="PVPTRINKET",["type"]="trinket",["name"]="Gladiator's Emblem",["buff"]=345231,["duration"]=120,["icon"]=132344,["spellID"]=345231,["item"]=178447, },
		{ ["class"]="PVPTRINKET",["type"]="trinket",["name"]="Gladiator's Badge",["buff"]=345228,["duration"]=60,["icon"]=135884,["spellID"]=345228,["item"]=175921, },





	},
	["TRINKET"] = {
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Inexorable Resonator",["buff"]=386001,["duration"]=120,["icon"]=1028997,["spellID"]=386001,["item"]=193805, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Slicing Maelstrom",["buff"]=214980,["duration"]=120,["icon"]=1029585,["spellID"]=214980,["item"]=137486, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Storm-Eater's Boon",["buff"]=377453,["duration"]=180,["icon"]=4554454,["spellID"]=377453,["item"]=194302, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Tome of Unstable Power",["buff"]=388583,["duration"]=180,["icon"]=646780,["spellID"]=388583,["item"]=193628, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Miniature Singing Stone",["buff"]=388855,["duration"]=120,["icon"]=4638394,["spellID"]=388881,["item"]=193678, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Treemouth's Festering Splinter",["buff"]=395175,["duration"]=90,["icon"]=4635241,["spellID"]=395175,["item"]=193652, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Water's Beating Heart",["buff"]=383934,["duration"]=120,["icon"]=839910,["spellID"]=383934,["item"]=193736, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Expel Light",["buff"]=214198,["duration"]=90,["icon"]=237541,["spellID"]=214198,["item"]=133646, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Spear of Light",["buff"]=214203,["duration"]=60,["icon"]=236263,["spellID"]=214203,["item"]=133647, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Voidmender's Shadowgem",["buff"]=397399,["duration"]=90,["icon"]=133266,["spellID"]=397399,["item"]=110007, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Valarjar's Path",["buff"]=215956,["duration"]=120,["icon"]=134229,["spellID"]=215956,["item"]=133642, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Iceblood Deathsnare",["buff"]=377455,["duration"]=120,["icon"]=237430,["spellID"]=377455,["item"]=194304, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Consume Pods",["buff"]=384658,["duration"]=30,["icon"]=4554354,["spellID"]=384636,["item"]=193634, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Algeth'ar Puzzle",["buff"]=383781,["duration"]=180,["icon"]=133876,["spellID"]=383781,["item"]=193701, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Crumbling Power",["buff"]=383941,["duration"]=180,["icon"]=4638427,["spellID"]=383941,["item"]=193743, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Spoils of Neltharus",["buff"]=381957,["duration"]=120,["icon"]=4638544,["spellID"]=381768,["item"]=193773, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Time-Breaching Talon",["buff"]=382126,["duration"]=150,["icon"]=1416740,["spellID"]=385884,["item"]=193791, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Homeland Raid Horn",["buff"]=382139,["duration"]=120,["icon"]=252172,["spellID"]=382139,["item"]=193815, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Erupting Spear Fragment",["buff"]=381471,["duration"]=90,["icon"]=4638721,["spellID"]=381471,["item"]=193769, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Bound by Fire and Blaze",["buff"]=383926,["duration"]=120,["icon"]=4638646,["spellID"]=383926,["item"]=193762, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Globe of Jagged Ice",["buff"]=388931,["duration"]=30,["icon"]=609814,["spellID"]=388931,["item"]=193732, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Dragon Games Equipment",["buff"]=386692,["duration"]=120,["icon"]=4641307,["spellID"]=386692,["item"]=193719, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Bonemaw's Big Toe",["buff"]=397400,["duration"]=120,["icon"]=133718,["spellID"]=397400,["item"]=110012, },
		{ ["class"]="TRINKET",["type"]="trinket",["name"]="Cataclysmic Punch",["buff"]=392359,["duration"]=120,["icon"]=133718,["spellID"]=392359,["item"]=200868, },
	},
}

E.iconFix = {}
E.buffFix = {

	[51052] = 145629,
	[196718] = 209426,

	[248518] = 248519,
	[116011] = 116014,

	[228049] = 228050,
	[62618] = 81782,
	[236320] = 236321,
}

E.buffFixNoCLEU = {
	[125174] = 10,
}

E.spellDefaults = {
	336126, 336135, 345231,
	59752, 7744,
	47482, 47528, 48707, 48792, 114556, 51052,
	183752, 196555, 198589, 209258, 187827, 196718, 191427, 205604, 740,
	351338, 372048, 378441, 357170, 363916, 374348, 374227, 359816, 363534, 377509, 378464,
	106839, 78675, 22812, 102342, 108238, 61336, 33891,
	147362, 187707, 187650, 186265, 109304, 53480,
	2139, 45438, 342246, 342245, 86949, 235219, 198111, 190319,
	116705, 116849, 122470, 122783, 122278, 115203, 115310,
	31935, 96231, 215652, 853, 115750, 642, 228049, 199452, 1022, 216331, 31884, 231895, 210256, 31821,
	15487, 64044, 8122, 197268, 19236, 47585, 47788, 33206, 215982, 108968, 62618, 47536, 64843, 265202, 15286,
	1766, 2094, 31230, 31224, 5277, 1856, 360194,
	57994, 108271, 198838, 210918, 30884, 114052, 98008, 204336, 8143, 108280,
	212619, 119898, 6789, 48020, 104773, 212295,
	6552, 5246, 118038, 184364, 871, 97462, 23920, 236320,
}

E.raidDefaults = {
	51052, 196718, 740, 374227, 359816, 363534, 115310, 31821, 64843, 265202, 62618, 15286, 108280, 98008, 97462,
}
