-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local NPCs = private.Data.NPCs


-- ----------------------------------------------------------------------------
-- Dazar'alor
-- ----------------------------------------------------------------------------
NPCs[120899] = { -- Kul'krazahn
	achievementQuestID = 48333, -- Kul'krazahn
	vignetteID = 2038,
}

NPCs[122639] = { -- Old R'gal
	factionGroup = "Horde",
	questID = 50856, -- Old R'gal
	vignetteID = 2784,
}

NPCs[125816] = { -- Sky Queen
	factionGroup = "Horde",
	questID = 53567,
	vignetteID = 3271,
}

-- ----------------------------------------------------------------------------
-- Nazmir
-- ----------------------------------------------------------------------------
NPCs[121242] = { -- Glompmaw
	achievementQuestID = 50361, -- Glompmaw
	vignetteID = 2603,
}

NPCs[124375] = { -- Overstuffed Saurolisk
	questID = 47827,
	vignetteID = 2009,
}

NPCs[124397] = { -- Kal'draxa
	achievementQuestID = 47843, -- Kal'draxa
	vignetteID = 2010,
}

NPCs[124399] = { -- Infected Direhorn
	achievementQuestID = 47877, -- Infected Direhorn
	vignetteID = 2013,
}

NPCs[124475] = { -- Shambling Ambusher
	questID = 47878,
	vignetteID = 2014, -- Abandoned Treasure
}

NPCs[125214] = { -- Krubbs
	achievementQuestID = 48052, -- Krubbs
	isTameable = true,
	vignetteID = 2028,
}

NPCs[125232] = { -- Captain Mu'kala
	achievementQuestID = 48057, -- Cursed Chest
	vignetteID = 2029, -- The Cursed Chest
}

NPCs[125250] = { -- Ancient Jawbreaker
	achievementQuestID = 48063, -- Ancient Jawbreaker
	isTameable = true,
	vignetteID = 2031,
}

NPCs[126056] = { -- Totem Maker Jash'ga
	achievementQuestID = 48406, -- Totem Maker Jash'ga
	vignetteID = 2068,
}

NPCs[126142] = { -- Bajiatha
	achievementQuestID = 48439, -- Bajiatha
	isTameable = true,
	vignetteID = 2120,
}

NPCs[126187] = { -- Corpse Bringer Yal'kar
	achievementQuestID = 48462, -- Corpse Bringer Yal'kar
	mounts = {
		{
			itemID = 163575, -- Reins of a Tamed Bloodfeaster
			spellID = 243795 -- Leaping Veinseeker
		}
	},
	vignetteID = 2130,
}

NPCs[126460] = { -- Tainted Guardian
	achievementQuestID = 48508, -- Tainted Guardian
	vignetteID = 2192,
}

NPCs[126635] = { -- Blood Priest Xak'lar
	achievementQuestID = 48541, -- Blood Priest Xak'lar
	vignetteID = 2195,
}

NPCs[126907] = { -- Wardrummer Zurula
	achievementQuestID = 48623, -- Wardrummer Zurula
	vignetteID = 2219,
}

NPCs[126926] = { -- Venomjaw
	achievementQuestID = 48626, -- Venomjaw
	vignetteID = 2221,
}

NPCs[127001] = { -- Gwugnug the Cursed
	achievementQuestID = 48638, -- Gwugnug the Cursed
	vignetteID = 2224,
}

NPCs[127820] = { -- Scout Skrasniss
	achievementQuestID = 48972, -- Scout Skrasnis
	vignetteID = 2306,
}

NPCs[127873] = { -- Scrounger Patriarch
	achievementQuestID = 48980, -- Scrounger Patriarch
	vignetteID = 2310,
}

NPCs[128426] = { -- Gutrip
	achievementQuestID = 49231, -- Gutrip the Hungry
	vignetteID = 2337, -- Gutrip the Hungry
}

NPCs[128584] = { -- Vugthuth
	classification = "rareelite",
	questID = 50366,
	vignetteID = 2605,
}

NPCs[128578] = { -- Zujothgul
	classification = "rareelite",
	questID = 50460, -- Zujothgul
	vignetteID = 2640,
}

NPCs[128610] = { -- Maw of Shul-Nagruth
	classification = "rareelite",
	questID = 50467,
	vignetteID = 2642,
}

NPCs[128930] = { -- Rohnkor
	achievementQuestID = 50040, -- Mala'kili and Rohnkor
	vignetteID = 2529, -- Mala'kili and Rohnkor
}

NPCs[128935] = { -- Mala'kili
	achievementQuestID = 50040, -- Mala'kili and Rohnkor
	vignetteID = 2529, -- Mala'kili and Rohnkor
}

NPCs[128965] = { -- Uroku the Bound
	achievementQuestID = 49305, -- Uroku the Bound
	vignetteID = 2376,
}

NPCs[128974] = { -- Queen Tzxi'kik
	achievementQuestID = 49312, -- Queen Tzxi'kik
	isTameable = true,
	vignetteID = 2381,
}

NPCs[129005] = { -- King Kooba
	achievementQuestID = 49317, -- King Kooba
	isTameable = true,
	vignetteID = 2383,
}

NPCs[129657] = { -- Za'amar the Queen's Blade
	achievementQuestID = 49469, -- Za'amar the Queen's Blade
	vignetteID = 2194,
}

NPCs[133373] = { -- Jax'teb the Reanimated
	achievementQuestID = 50307, -- Jax'teb the Reanimated
	vignetteID = 2593,
}

NPCs[133505] = { -- Aiji the Accursed
	classification = "elite",
	questID = 50339,
	vignetteID = 2796,
}

NPCs[133527] = { -- Juba the Scarred
	achievementQuestID = 50342, -- Juba the Scarred
	vignetteID = 2599,
}

NPCs[133531] = { -- Xu'ba
	achievementQuestID = 50348, -- Xu'ba the Bone Collector
	vignetteID = 2600, -- Xu'ba the Bone Collector
}

NPCs[133539] = { -- Lo'kuno
	achievementQuestID = 50355, -- Lo'kuno
	vignetteID = 2601,
}

NPCs[135565] = { -- Guardian of Agussu
	achievementQuestID = 50888, -- Urn of Agussu
	vignetteID = 2788, -- Urn of Agussu
}

NPCs[133812] = { -- Zanxib
	achievementQuestID = 50423, -- Zanxib the Engorged
	isTameable = true,
	vignetteID = 2630, -- Zanxib the Engorged
}

NPCs[134002] = { -- Underlord Xerxiz
	classification = "rareelite",
	questID = 50480, -- Underlord Xerxiz
	vignetteID = 2648,
}

NPCs[134293] = { -- Azerite-Infused Slag
	achievementQuestID = 50563, -- Azerite Infused Slag
	vignetteID = 2658, -- Azerite Infused Slag
}

NPCs[134294] = { -- Enraged Water Elemental
	achievementQuestID = 50565, -- Lost Scroll
	vignetteID = 2659, -- Lost Scroll
}

NPCs[134296] = { -- Lucille
	achievementQuestID = 50567, -- Chag's Challenge
	vignetteID = 2660, -- Chag's Challenge
}

NPCs[134298] = { -- Azerite-Infused Elemental
	achievementQuestID = 50569, -- Azerite Infused Elemental
	vignetteID = 2661, -- Azerite Infused Elemental
}

NPCs[143898] = { -- Makatau
	classification = "elite",
}

-- ----------------------------------------------------------------------------
-- Vol'dun
-- ----------------------------------------------------------------------------
NPCs[124722] = { -- Commodore Calhoun
	questID = 50905, -- Commodore Calhoun
	vignetteID = 2797,
}

NPCs[127776] = { -- Scaleclaw Broodmother
	isTameable = true,
	questID = 48960,
	vignetteID = 2298,
}

NPCs[128497] = { -- Bajiani the Slick
	questID = 49251, -- Bajiani the Slick
	vignetteID = 2351,
}

NPCs[128553] = { -- Azer'tor
	questID = 49252,
	vignetteID = 2352,
}

NPCs[128674] = { -- Gut-Gut the Glutton
	questID = 49270, -- Gut-Gut the Glutton
	vignetteID = 2361,
}

NPCs[128686] = { -- Kamid the Trapper
	questID = 50528,
	vignetteID = 2655,
}

NPCs[128951] = { -- Nez'ara
	questID = 50898,
	vignetteID = 2795,
}

NPCs[129027] = { -- Golanar
	questID = 50362,
	vignetteID = 2604,
}

NPCs[129180] = { -- Warbringer Hozzik
	questID = 49373,
	vignetteID = 2391,
}

NPCs[129283] = { -- Jumbo Sandsnapper
	isTameable = true,
	questID = 49392,
	vignetteID = 2406,
}

NPCs[129411] = { -- Zunashi the Exile
	questID = 48319,
	vignetteID = 2410,
}

NPCs[129476] = { -- Bloated Krolusk
	questID = 47562,
	vignetteID = 2411, -- Bloated Ruincrawler
}

NPCs[130401] = { -- Vathikur
	questID = 49674,
	vignetteID = 2445,
}

NPCs[130439] = { -- Ashmane
	isTameable = true,
	questID = 47532, -- Ashmane
	vignetteID = 2446,
}

NPCs[130443] = { -- Hivemother Kraxi
	isTameable = true,
	questID = 47533,
	vignetteID = 2447,
}

NPCs[133843] = { -- First Mate Swainbeak
	questID = 51073, -- Stef "Marrow" Quin
	vignetteID = 2889,
}

NPCs[134571] = { -- Skycaller Teskris
	questID = 50637,
	vignetteID = 2668,
}

NPCs[134625] = { -- Warmother Captive
	questID = 50658,
	vignetteID = 2672,
}

NPCs[134638] = { -- Warlord Zothix
	questID = 50662,
	vignetteID = 2674,
}

NPCs[134643] = { -- Brgl-Lrgl the Basher
	questID = 50663,
	vignetteID = 2675,
}

NPCs[134694] = { -- Mor'fani the Exile
	questID = 50666,
	vignetteID = 2677,
}

NPCs[134745] = { -- Skycarver Krakit
	questID = 50686,
	vignetteID = 2683,
}

NPCs[135852] = { -- Ak'tar
	questID = 51058, -- Ak'tar
	vignetteID = 2885,
}

NPCs[136304] = { -- Songstress Nahjeen
	questID = 51063,
	vignetteID = 2886,
}

NPCs[136323] = { -- Fangcaller Xorreth
	questID = 51065, -- Fangcaller Xorreth
	vignetteID = 2887,
}

NPCs[136335] = { -- Enraged Krolusk
	isTameable = true,
	questID = 51077, -- Enraged Krolusk
	vignetteID = 2893,
}

NPCs[136336] = { -- Scorpox
	isTameable = true,
	questID = 51076,
	vignetteID = 2892,
}

NPCs[136338] = { -- Sirokar
	questID = 51075,
	vignetteID = 2891,
}

NPCs[136340] = { -- Relic Hunter Hazaak
	questID = 51126,
	vignetteID = 2899,
}

NPCs[136341] = { -- Jungleweb Hunter
	isTameable = true,
	questID = 51074,
	vignetteID = 2890,
}

NPCs[136346] = { -- Captain Stef "Marrow" Quin
	questID = 51073, -- Stef "Marrow" Quin
	vignetteID = 2889,
}

NPCs[136393] = { -- Bloodwing Bonepicker
	isTameable = true,
	questID = 51079, -- Bloodwing Bonepicker
	vignetteID = 2894,
}

NPCs[137553] = { -- General Krathax
	classification = "rareelite",
	questID = -1,
	vignetteID = -1,
}

NPCs[137681] = { -- King Clickyclack
	isTameable = true,
	questID = 51424,
	vignetteID = 2954,
}

NPCs[138794] = { -- Dunegorger Kraulok
	classification = "elite",
	questID = 52196, -- Sandswept Bones
}

-- ----------------------------------------------------------------------------
-- Zuldazar
-- ----------------------------------------------------------------------------
NPCs[122004] = { -- Umbra'jin
	questID = 47567,
	vignetteID = 1998,
}

NPCs[123502] = { -- King K'tal
	classification = "elite",
}

NPCs[124185] = { -- Golrakahn
	achievementQuestID = 47792, -- Golrakahn
	vignetteID = 2004,
}

NPCs[126637] = { -- Kandak
	achievementQuestID = 48543, -- Kandak
	vignetteID = 2196,
}

NPCs[127939] = { -- Torraske the Eternal
	achievementQuestID = 49004, -- Torraske the Eternal
	isTameable = true,
	vignetteID = 2314, -- Torrsake the Eternal
}

NPCs[128699] = { -- Bloodbulge
	achievementQuestID = 49267, -- Bloodbulge
	vignetteID = 2359,
}

NPCs[129323] = { -- Sabertusk Empress
	classification = "elite",
}

NPCs[129343] = { -- Avatar of Xolotal
	achievementQuestID = 49410, -- Avatar of Xolotal
	vignetteID = 2407,
}

NPCs[129954] = { -- Gahz'ralka
	achievementQuestID = 50439, -- Gahz'ralka
	vignetteID = 2636,
}

NPCs[129961] = { -- Atal'zul Gotaka
	achievementQuestID = 50280, -- Atal'zul Gotaka
	vignetteID = 2588,
}

NPCs[130643] = { -- Twisted Child of Rezan
	questID = 50333, -- Twisted Child of Rezan
	vignetteID = 2597,
}

NPCs[130741] = { -- Nol'ixwan
	classification = "elite",
}

NPCs[131233] = { -- Lei-zhi
	achievementQuestID = 49911, -- Lei-Zhi
	vignetteID = 2496,
}

NPCs[131476] = { -- Zayoos
	achievementQuestID = 49972, -- Zayoos
	vignetteID = 2513, -- Zayoos
}

NPCs[131687] = { -- Tambano
	achievementQuestID = 50013, -- Tambano
	isTameable = true,
	vignetteID = 2524,
}

NPCs[131704] = { -- Coati
	isTameable = true,
	questID = 50846,
	vignetteID = 2525,
}

NPCs[131718] = { -- Bramblewing
	achievementQuestID = 50034, -- Bramblewing
	vignetteID = 2527,
}

NPCs[132244] = { -- Kiboku
	achievementQuestID = 50159, -- Kiboku
	isTameable = true,
	vignetteID = 2548,
}

NPCs[132253] = { -- Ji'arak
	questID = 52169, -- The Matriarch
}

NPCs[133155] = { -- G'Naat
	achievementQuestID = 50260, -- G'Naat
	vignetteID = 2581,
}

NPCs[133163] = { -- Tia'Kawan
	questID = 50263,
	vignetteID = 2584,
}

NPCs[133190] = { -- Daggerjaw
	achievementQuestID = 50269, -- Daggerjaw
	vignetteID = 2587,
}

NPCs[133842] = { -- Warcrawler Karkithiss
	achievementQuestID = 50438, -- Warcrawler Karkithiss
	vignetteID = 2635,
}

NPCs[134048] = { -- Vukuba
	achievementQuestID = 50508, -- Vukuba
	vignetteID = 2650, -- Strange Egg
}

NPCs[134637] = { -- Headhunter Lee'za
	questID = 50661, -- Headhunter Lee'za
	vignetteID = 2673,
}

NPCs[134717] = { -- Umbra'rix
	classification = "rareelite",
	questID = 50673, -- Umbra'rix
	vignetteID = 2680,
}

NPCs[134738] = { -- Hakbi the Risen
	achievementQuestID = 50677, -- Hakbi the Risen
	vignetteID = 2682,
}

NPCs[134760] = { -- Darkspeaker Jo'la
	achievementQuestID = 50693, -- Darkspeaker Jo'la
	vignetteID = 2685,
}

NPCs[134782] = { -- Murderbeak
	achievementQuestID = 50281, -- Murderbeak
	vignetteID = 2651, -- Chum Bucket
}

NPCs[135510] = { -- Azuresail the Ancient
	classification = "elite",
	isTameable = true,
}

NPCs[139365] = { -- Queenfeather
	classification = "elite",
	isTameable = true,
}

NPCs[135512] = { -- Thunderfoot
	classification = "elite",
}

NPCs[136413] = { -- Syrawon the Dominus
	achievementQuestID = 51080, -- Syrawon the Dominus
	vignetteID = 2895, -- Tehd & Marius
}

NPCs[136428] = { -- Dark Chronicler
	achievementQuestID = 51083, -- Dark Chronicler
	vignetteID = 2897,-- Dark Chronicler
}

NPCs[143536] = { -- High Warlord Volrath
	factionGroup = "Horde",
	vignetteID = 612,
}

NPCs[143910] = { -- Sludgecrusher
	classification = "elite",
}
