-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local AchievementID = private.Enum.AchievementID
local NPCs = private.Data.NPCs

-- ----------------------------------------------------------------------------
-- Frostfire Ridge
-- ----------------------------------------------------------------------------
NPCs[50992] = { -- Gorok
	mounts = {
		{
			itemID = 116674, -- Great Greytusk
			spellID = 171636, -- Great Greytusk
		},
	},
}

NPCs[71665] = { -- Giant-Slayer Kul
	questID = 32918, -- Giant-Slayer Kul
}

NPCs[71721] = { -- Canyon Icemother
	isTameable = true,
	questID = 32941, -- Oasis Icemother
}

NPCs[72294] = { -- Cindermaw
	questID = 33014, -- Cindermaw
}

NPCs[72364] = { -- Gorg'ak the Lava Guzzler
	questID = 33512, -- Lava-Gorged Goren
}

NPCs[74613] = { -- Broodmother Reeg'ak
	questID = 33843, -- Broodmother Reeg'ak
}

NPCs[74971] = { -- Firefury Giant
	questID = 33504, -- Shaman Fire Stone
}

NPCs[76914] = { -- Coldtusk
	isTameable = true,
	questID = 34131, -- Coldtusk
}

NPCs[76918] = { -- Primalist Mur'og
	questID = 33938, -- Ogre Primalist
}

NPCs[77513] = { -- Coldstomp the Griever
	isTameable = true,
	questID = 34129, -- Coldstomp
}

NPCs[77519] = { -- Giantbane
	isTameable = true,
}

NPCs[77526] = { -- Scout Goreseeker
	questID = 34132, -- Scout Goreseeker
}

NPCs[77527] = { -- The Beater
	questID = 34133, -- The Beater
}

NPCs[78151] = { -- Huntmaster Kuang
	questID = 34130, -- Giantstalker Hunting Party
}

NPCs[78265] = { -- The Bone Crawler
	questID = 34361, -- The Bone Crawler
}

NPCs[78606] = { -- Pale Fishmonger
	questID = 34470, -- Pale Gone Fishin'
}

NPCs[78621] = { -- Cyclonic Fury
	questID = 34477, -- Cyclonic Fury
}

NPCs[78867] = { -- Breathless
	questID = 34497, -- Breathless
	toys = {
		{ itemID = 111476 }, -- Stolen Breath
	},
}

NPCs[79104] = { -- Ug'lok the Frozen
	questID = 34522, -- Ug'lok the Frozen
}

NPCs[79145] = { -- Yaga the Scarred
	questID = 34559, -- Yaga the Scarred
}

NPCs[80190] = { -- Gruuk
	questID = 34825, -- Gruuk
}

NPCs[80235] = { -- Gurun
	questID = 34839, -- Skog
}

NPCs[80242] = { -- Chillfang
	isTameable = true,
	questID = 34843, -- Chillfang
}

NPCs[80312] = { -- Grutush the Pillager
	questID = 34865, -- Skog
}

NPCs[81001] = { -- Nok-Karosh
	isTameable = true,
	mounts = {
		{
			itemID = 116794, -- Garn Nighthowl
			spellID = 171851, -- Garn Nighthowl
		},
	},
}

NPCs[82536] = { -- Gorivax
	questID = 37388, -- Gorivax
	vignetteID = 372, -- Soulgrinder Portal
}

NPCs[82614] = { -- Moltnoma
	questID = 37387, -- Moltnoma
}

NPCs[82616] = { -- Jabberjaw
	isTameable = true,
	questID = 37386, -- Jabberjaw
}

NPCs[82617] = { -- Slogtusk the Corpse-Eater
	isTameable = true,
	questID = 37385, -- Slogtusk the Corpse Eater
	vignetteID = 374, -- Slogtusk
}

NPCs[82618] = { -- Tor'goroth
	questID = 37384, -- Tor'goroth
	toys = {
		{ itemID = 119163 }, -- Soul Inhaler
	},
}

NPCs[82620] = { -- Son of Goramal
	questID = 37383, -- Son of Goramal
}

NPCs[84374] = { -- Kaga the Ironbender
	questID = 37404, -- Kaga the Ironbender
}

NPCs[84376] = { -- Earthshaker Holar
	questID = 37403, -- Earthshaker Holar
}

NPCs[84378] = { -- Ak'ox the Slaughterer
	questID = 37525, -- Ak'ox the Slaughterer
}

NPCs[84392] = { -- Ragore Driftstalker
	questID = 37401, -- Ragore Driftstalker
}

NPCs[87348] = { -- Hoarfrost
	questID = 37382, -- Hoarfrost
}

NPCs[87351] = { -- Mother of Goren
	questID = 37381, -- Mother of Goren
}

NPCs[87352] = { -- Gibblette the Cowardly
	questID = 37380, -- Giblette the Cowardly
	toys = {
		{ itemID = 119180 }, -- Goren "Log" Roller
	},
	vignetteID = 546, -- Gibblette the Cowardly
}

NPCs[87356] = { -- Vrok the Ancient
	questID = 37379, -- Vrok the Ancient
}

NPCs[87357] = { -- Valkor
	questID = 37378, -- Valkor
}

NPCs[87600] = { -- Jaluk the Pacifist
	questID = 37556, -- Jaluk the Pacifist
	vignetteID = 601, -- Jaluk the Pacifist
}

NPCs[87622] = { -- Ogom the Mangler
	questID = 37402, -- Ogom the Mangler
}

-- ----------------------------------------------------------------------------
-- Tanaan Jungle
-- ----------------------------------------------------------------------------
NPCs[80398] = { -- Keravnos
	isTameable = true,
	questID = 37407, -- Keravnos
}

NPCs[89675] = { -- Commander Org'mok
	questID = 38749, -- Commander Org'mok
}

NPCs[90024] = { -- Sergeant Mor'grak
	questID = 37953, -- Sergeant Mor'grak
}

NPCs[90094] = { -- Harbormaster Korak
	questID = 39046, -- Harbormaster Korak
}

NPCs[90122] = { -- Zoug the Heavy
	questID = 39045, -- Zoug
}

NPCs[90429] = { -- Imp-Master Valessa
	questID = 38026, -- Imp-Master Valessa
	toys = {
		{ itemID = 127655 }, -- Sassy Imp
	},
}

NPCs[90434] = { -- Ceraxas
	questID = 38031, -- Ceraxas
}

NPCs[90437] = { -- Jax'zor
	questID = 38030, -- Houndmaster Jax'zor
	vignetteID = 703, -- Houndmaster Jax'zor
}

NPCs[90438] = { -- Lady Oran
	questID = 38029, -- Lady Oran
}

NPCs[90442] = { -- Mistress Thavra
	questID = 38032, -- Mistress Thavra
}

NPCs[90519] = { -- Cindral the Wildfire
	questID = 37990, -- Cindral
	vignetteID = 698, -- Cindral (TODO: possibly 699)
}

NPCs[90777] = { -- High Priest Ikzan
	questID = 38028, -- High Priest Ikzan
	toys = {
		{ itemID = 122117 }, -- Cursed Feather of Ikzan
	},
}

NPCs[90782] = { -- Rasthe
	questID = 38034, -- Rasthe
}

NPCs[90884] = { -- Bilkor the Thrower
	questID = 38262, -- Bilkor the Thrower
}

NPCs[90885] = { -- Rogond the Tracker
	questID = 38263, -- Rogond
}

NPCs[90887] = { -- Dorg the Bloody
	questID = 38265, -- Dorg
}

NPCs[90888] = { -- Drivnul
	questID = 38264, -- Drivnul
}

NPCs[90936] = { -- Bloodhunter Zulk
	questID = 38266, -- Zulk
}

NPCs[91009] = { -- Putre'thar
	questID = 38457, -- Putre'thar
}

NPCs[91087] = { -- Zeter'el
	questID = 38207, -- Zeter'el
}

NPCs[91093] = { -- Bramblefell
	questID = 38209, -- Bramblefell
	toys = {
		{ itemID = 127652 }, -- Felflame Campfire
	},
}

NPCs[91098] = { -- Felspark
	questID = 38211, -- Felspark
}

NPCs[91227] = { -- Remnant of the Blood Moon
	questID = 39159, -- Blood Moon Boss
	toys = {
		{ itemID = 127666 }, -- Vial of Red Goo
	},
	vignetteID = 730, -- Remnant of the Blood Moon
}

NPCs[91232] = { -- Commander Krag'goth
	questID = 38746, -- Iron Front Captain 1
}

NPCs[91243] = { -- Tho'gar Gorefist
	questID = 38747, -- Iron Front Captain 2
}

NPCs[91374] = { -- Podlord Wakkawam
	questID = 38282, -- Wakkawam
}

NPCs[91695] = { -- Grand Warlock Nethekurse
	questID = 38400, -- Grand Warlock Nethekurse
}

NPCs[91727] = { -- Executor Riloth
	questID = 38411, -- Executor Riloth
}

NPCs[91871] = { -- Argosh the Destroyer
	questID = 38430, -- Argosh the Destroyer
}

NPCs[92197] = { -- Relgor
	questID = 38496, -- BH Master Scout
	vignetteID = 798, -- Master Scout Relgor
}

NPCs[92274] = { -- Painmistress Selora
	questID = 38557, -- Invasion Point: Devastation
	vignetteID = 813, -- Invasion Point: Devastation
}

NPCs[92408] = { -- Xanzith the Everlasting
	questID = 38579, -- Xanzith the Everlasting
}

NPCs[92411] = { -- Overlord Ma'gruth
	questID = 38580, -- Overlord Ma'gruth
}

NPCs[92429] = { -- Broodlord Ixkor
	isTameable = true,
	questID = 38589, -- Ravager Broodlord
	vignetteID = 817, -- Broodlord Ixkor
}

NPCs[92451] = { -- Varyx the Damned
	questID = 37937, -- Varyx the Damned
}

NPCs[92465] = { -- The Blackfang
	questID = 38597, -- Panther Saberon Boss
	vignetteID = 818, -- The Blackfang
}

NPCs[92495] = { -- Soulslicer
	questID = 38600, -- Fel Saberon Shaman
	vignetteID = 819, -- Soulslicer
}

NPCs[92508] = { -- Gloomtalon
	questID = 38604, -- Saberon Shaman
	vignetteID = 820, -- Gloomtalon
}

NPCs[92517] = { -- Krell the Serene
	questID = 38605, -- Saberon Blademaster
	vignetteID = 821, -- Krell the Serene
}

NPCs[92552] = { -- Belgork
	questID = 38609, -- Iron Tunnel Foreman
	vignetteID = 822, -- Belgork
}

NPCs[92574] = { -- Thromma the Gutslicer
	questID = 38620, -- Pale Assassin
	vignetteID = 823, -- Thromma the Gutslicer
}

NPCs[92606] = { -- Sylissa
	questID = 38628, -- Giant Python
	vignetteID = 827, -- Sylissa
}

NPCs[92627] = { -- Rendrak
	isTameable = true,
	questID = 38631, -- Alpha Bat
	vignetteID = 829, -- Rendrak
}

NPCs[92636] = { -- The Night Haunter
	questID = 38632, -- Night Haunter
	toys = {
		{ itemID = 127652 }, -- Felflame Campfire
	},
}

NPCs[92645] = { -- The Night Haunter
	questID = 38632, -- Night Haunter
}

NPCs[92647] = { -- Felsmith Damorka
	questID = 38634, -- Felsmith Damorka
}

NPCs[92657] = { -- Bleeding Hollow Horror
	questID = 38696, -- Bleeding Hollow Horror
}

NPCs[92694] = { -- The Goreclaw
	isTameable = true,
	questID = 38654, -- Giant Raptor
	vignetteID = 834, -- The Goreclaw
}

NPCs[92887] = { -- Steelsnout
	isTameable = true,
	questID = 38700, -- Steelsnout
}

NPCs[92941] = { -- Gorabosh
	questID = 38709, -- Cave Keeper
	vignetteID = 846, -- Gorabosh
}

NPCs[92977] = { -- The Iron Houndmaster
	questID = 38751, -- Iron Houndmaster
	vignetteID = 860, -- The Iron Houndmaster
}

NPCs[93001] = { -- Szirek the Twisted
	questID = 38752, -- Szirek
	vignetteID = 861, -- Szirek the Twisted
}

NPCs[93002] = { -- Magwia
	isTameable = true,
	questID = 38726, -- Magwia
}

NPCs[93028] = { -- Driss Vile
	questID = 38736, -- IH Elite Sniper
	vignetteID = 853, -- Driss Vile
}

NPCs[93057] = { -- Grannok
	questID = 38750, -- Iron Front Captain 3
	vignetteID = 859, -- Grannok
}

NPCs[93076] = { -- Captain Ironbeard
	questID = 38756, -- Dead Orc Captain
	toys = {
		{ itemID = 127659 }, -- Ghostly Iron Buccaneer's Hat
	},
	vignetteID = 862, -- Captain Ironbeard
}

NPCs[93125] = { -- Glub'glok
	questID = 38764, -- Murktide Alpha
	vignetteID = 864, -- Murktide Alpha
}

NPCs[93168] = { -- Felbore
	questID = 38775, -- Felbore
}

NPCs[93236] = { -- Shadowthrash
	isTameable = true,
	questID = 38812, -- Shadowthrash
}

NPCs[93264] = { -- Captain Grok'mar
	questID = 38820, -- Captain Grok'mar
}

NPCs[93279] = { -- Kris'kar the Unredeemed
	questID = 38825, -- Blazing Crusader
}

NPCs[95044] = { -- Terrorfist
	mounts = {
		{
			itemID = 116658, -- Tundra Icehoof
			spellID = 171619, -- Tundra Icehoof
		},
		{
			itemID = 116669, -- Armored Razorback
			spellID = 171630, -- Armored Razorback
		},
		{
			itemID = 116780, -- Warsong Direfang
			spellID = 171837, -- Warsong Direfang
		},
	},
	questID = 39288, -- Terrorfist
}

NPCs[95053] = { -- Deathtalon
	mounts = {
		{
			itemID = 116658, -- Tundra Icehoof
			spellID = 171619, -- Tundra Icehoof
		},
		{
			itemID = 116669, -- Armored Razorback
			spellID = 171630, -- Armored Razorback
		},
		{
			itemID = 116780, -- Warsong Direfang
			spellID = 171837, -- Warsong Direfang
		},
	},
	questID = 39287, -- Deathtalon
}

NPCs[95054] = { -- Vengeance
	mounts = {
		{
			itemID = 116658, -- Tundra Icehoof
			spellID = 171619, -- Tundra Icehoof
		},
		{
			itemID = 116669, -- Armored Razorback
			spellID = 171630, -- Armored Razorback
		},
		{
			itemID = 116780, -- Warsong Direfang
			spellID = 171837, -- Warsong Direfang
		},
	},
	questID = 39290, -- Vengeance
}

NPCs[95056] = { -- Doomroller
	mounts = {
		{
			itemID = 116658, -- Tundra Icehoof
			spellID = 171619, -- Tundra Icehoof
		},
		{
			itemID = 116669, -- Armored Razorback
			spellID = 171630, -- Armored Razorback
		},
		{
			itemID = 116780, -- Warsong Direfang
			spellID = 171837, -- Warsong Direfang
		},
	},
	questID = 39289, -- Doomroller
}

NPCs[98283] = { -- Drakum
	questID = 40105, -- Drakum
	toys = {
		{ itemID = 108631 }, -- Crashin' Thrashin' Roller Controller
	},
}

NPCs[98284] = { -- Gondar
	questID = 40106, -- Gondar
	toys = {
		{ itemID = 108633 }, -- Crashin' Thrashin' Cannon Controller
	},
}

NPCs[98285] = { -- Smashum Grabb
	questID = 40104, -- Smashum Grabb
	toys = {
		{ itemID = 108634 }, -- Crashin' Thrashin' Mortar Controller
	},
}

NPCs[98408] = { -- Fel Overseer Mudlump
	questID = 40107, -- Mudlump
}

-- ----------------------------------------------------------------------------
-- Talador
-- ----------------------------------------------------------------------------
NPCs[51015] = { -- Silthide
	mounts = {
		{
			itemID = 116767, -- Sapphire Riverbeast
			spellID = 171824, -- Sapphire Riverbeast
		},
	},
}

NPCs[77529] = { -- Yazheera the Incinerator
	questID = 34135, -- Yazheera the Incinerator
}

NPCs[77561] = { -- Dr. Gloom
	questID = 34142, -- Dr. Gloom
}

NPCs[77614] = { -- Frenzied Golem
	questID = 34145, -- Vignette: Frenzied Animus
	vignetteID = 236, -- Frenzied Golem
}

NPCs[77620] = { -- Cro Fleshrender
	questID = 34165, -- Cro Fleshrender
}

NPCs[77626] = { -- Hen-Mother Hami
	isTameable = true,
	questID = 34167, -- Hen-Mother Hami
}

NPCs[77634] = { -- Taladorantula
	isTameable = true,
	questID = 34171, -- Taladorantula
}

NPCs[77664] = { -- Aarko
	questID = 34182, -- Aarkos - Looted Treasure
	vignetteID = 241, -- Aarko
}

NPCs[77715] = { -- Hammertooth
	isTameable = true,
	questID = 34185, -- Hammertooth
}

NPCs[77719] = { -- Glimmerwing
	isTameable = true,
	questID = 34189, -- Glimmerwing
	toys = {
		{ itemID = 116113 }, -- Breath of Talador
	},
}

NPCs[77741] = { -- Ra'kahn
	isTameable = true,
	questID = 34196, -- Ra'kahn
}

NPCs[77750] = { -- Kaavu the Crimson Claw
	questID = 34199, -- Anchorite's Sojourn
	vignetteID = 248, -- Saving Anchorite's Sojourn
}

NPCs[77776] = { -- Wandering Vindicator
	questID = 34205, -- Wandering Vindicator - Looted Treasure
	vignetteID = 249, -- Wandering Vindicator
}

NPCs[77784] = { -- Lo'marg Jawcrusher
	questID = 34208, -- Lo'marg Jawcrusher
}

NPCs[77795] = { -- Echo of Murmur
	questID = 34221, -- Echo of Murmur
	vignetteID = 251, -- Echo of Murmur
}

NPCs[77828] = { -- Echo of Murmur
	questID = 34220, -- Echo of Murmur
	toys = {
		{ itemID = 113670 }, -- Mournful Moan of Murmur
	},
}

NPCs[78710] = { -- Kharazos the Triumphant
	questID = 35219, -- Burning Front
	toys = {
		{ itemID = 116122 }, -- Burning Legion Missive
	},
	vignetteID = 262, -- Kharazos the Triumphant
}

NPCs[78713] = { -- Galzomar
	questID = 35219, -- Burning Front
	toys = {
		{ itemID = 116122 }, -- Burning Legion Missive
	},
	vignetteID = 263, -- Galzomar
}

NPCs[78715] = { -- Sikthiss, Maiden of Slaughter
	questID = 35219, -- Burning Front
	toys = {
		{ itemID = 116122 }, -- Burning Legion Missive
	},
	vignetteID = 346, -- "Sikthiss, Maiden of Slaughter"
}

NPCs[78872] = { -- Klikixx
	isTameable = true,
	questID = 34498, -- Klikixx
	toys = {
		{ itemID = 116125 }, -- Klikixx's Webspinner
	},
	vignetteID = 286, -- Klikixx
}

NPCs[79334] = { -- No'losh
	isTameable = true,
	questID = 34859, -- No'losh
	vignetteID = 331, -- No'losh
}

NPCs[79485] = { -- Talonpriest Zorkra
	questID = 34668, -- Talonpriest Zorkra
}

NPCs[79543] = { -- Shirzir
	questID = 34671, -- Shirzir
}

NPCs[80204] = { -- Felbark
	questID = 35018, -- Felbark
}

NPCs[80471] = { -- Gennadian
	isTameable = true,
	questID = 34929, -- Gennadian
	vignetteID = 335, -- Gennadian,
}

NPCs[80524] = { -- Underseer Bloodmane
	questID = 34945, -- Tracking Flag - Underseer Bloodmane Vignette
}

NPCs[82920] = { -- Lord Korinak
	questID = 37345, -- Lord Korinak
}

NPCs[82922] = { -- Xothear, the Destroyer
	questID = 37343, -- Xothear, The Destroyer
	vignetteID = 589, -- "Xothear, the Destroyer"
}

NPCs[82930] = { -- Shadowflame Terrorwalker
	questID = 37347, -- Shadowflame Terror
	vignetteID = 576, -- Shadowflame Terrorwalker
}

NPCs[82942] = { -- Lady Demlash
	questID = 37346, -- Lady Demlash
}

NPCs[82988] = { -- Kurlosh Doomfang
	questID = 37348, -- Kurlosh Doomfang
}

NPCs[82992] = { -- Felfire Consort
	questID = 37341, -- Felfire Consort
}

NPCs[82998] = { -- Matron of Sin
	questID = 37349, -- Matron of Sin
}

NPCs[83008] = { -- Haakun the All-Consuming
	questID = 37312, -- Haakun, The All-Consuming
	vignetteID = 562, -- "Haakun, the All-Consuming"
}

NPCs[83019] = { -- Gug'tol
	questID = 37340, -- Gug'tol
}

NPCs[85572] = { -- Grrbrrgle
	questID = 36919, -- Talador - Shore Vignette - Murloc Boss
}

NPCs[86549] = { -- Steeltusk
	questID = 36858, -- Steeltusk
}

NPCs[87597] = { -- Bombardier Gu'gok
	questID = 37339, -- Bombardier Gu'gok
}

NPCs[87668] = { -- Orumo the Observer
	pets = {
		{
			itemID = 119170, -- Eye of Observation
			npcID = 88490, -- Eye of Observation
		},
	},
	questID = 37344, -- Orumo the Observer
}

NPCs[88043] = { -- Avatar of Socrethar
	questID = 37338, -- Avatar of Sothrecar
	vignetteID = 561, -- Avatar of Socrethar
}

NPCs[88071] = { -- Strategist Ankor
	questID = 37337, -- Strategist Ankor
}

NPCs[88072] = { -- Archmagus Tekar
	questID = 37337, -- Strategist Ankor
}

NPCs[88083] = { -- Soulbinder Naylana
	questID = 37337, -- Strategist Ankor
}

NPCs[88436] = { -- Vigilant Paarthos
	questID = 37350, -- Vigilant Paarthos
}

NPCs[88494] = { -- Legion Vanguard
	questID = 37342, -- Legion Vanguard
}

-- ----------------------------------------------------------------------------
-- Shadowmoon Valley
-- ----------------------------------------------------------------------------
NPCs[50883] = { -- Pathrunner
	mounts = {
		{
			itemID = 116773, -- Swift Breezestrider
			spellID = 171830, -- Swift Breezestrider
		},
	},
}

NPCs[72362] = { -- Ku'targ the Voidseer
	questID = 33039, -- The Voidseer
	vignetteID = 13, -- The Voidseer
}

NPCs[72537] = { -- Leaf-Reader Kurri
	questID = 33055, -- Foreling Worship Circle
	vignetteID = 23, -- Leaf-Reader Kurri
}

NPCs[72606] = { -- Rockhoof
	isTameable = true,
	questID = 34068, -- Rockhoof
}

NPCs[74206] = { -- Killmaw
	isTameable = true,
	questID = 33043, -- Killmaw
}

NPCs[75071] = { -- Mother Om'ra
	questID = 33642, -- Mother Om'ra
	vignetteID = 399, -- Mother Om'ra
}

NPCs[75434] = { -- Windfang Matriarch
	questID = 33038, -- Embaari Defense Crystal
	vignetteID = 16, -- Embaari Defense Crystal
}

NPCs[75435] = { -- Yggdrel
	questID = 33389, -- Yggdrel the Corrupted
	toys = {
		{ itemID = 113570 }, -- Ancient's Bloom
	},
	vignetteID = 30, -- Yggdrel
}

NPCs[75482] = { -- Veloss
	isTameable = true,
	questID = 33640, -- Veloss
}

NPCs[75492] = { -- Venomshade
	questID = 33643, -- Venomshade (Plant Hydra)
	vignetteID = 207, -- Venomshade
}

NPCs[76380] = { -- Gorum
	questID = 33664, -- Gorum
}

NPCs[77085] = { -- Dark Emanation
	questID = 33064, -- Shadowmoon Cultist Ritual
	vignetteID = 215, -- Dark Emanation
}

NPCs[77140] = { -- Amaukwa
	isTameable = true,
	questID = 33061, -- Amaukwa
}

NPCs[77310] = { -- Mad "King" Sporeon
	questID = 35906, -- Mad "King" Sporeon
	vignetteID = 405, -- "Mad ""King"" Sporeon"
}

NPCs[79524] = { -- Hypnocroak
	questID = 35558, -- Hypnocroak
	toys = {
		{ itemID = 113631 }, -- Hypnosis Goggles
	},
}

NPCs[81406] = { -- Bahameye
	questID = 35281, -- Bahameye
}

NPCs[81639] = { -- Brambleking Fili
	questID = 33383, -- Brambleking Fili
}

NPCs[82207] = { -- Faebright
	questID = 35725, -- Faebright
	vignetteID = 385, -- Faebright
}

NPCs[82268] = { -- Darkmaster Go'vid
	questID = 35448, -- Darkmaster Go'vid
}

NPCs[82326] = { -- Ba'ruun
	questID = 35731, -- Ba'ruun
	toys = {
		{ itemID = 113540 }, -- Ba'ruun's Bountiful Bloom
	},
	vignetteID = 386, -- Ba'ruun
}

NPCs[82362] = { -- Morva Soultwister
	questID = 35523, -- Morva Soultwister
}

NPCs[82374] = { -- Rai'vosh
	questID = 35553, -- Rai'vosh
	toys = {
		{ itemID = 113542 }, -- Whispers of Rai'Vosh
	},
}

NPCs[82411] = { -- Darktalon
	questID = 35555, -- Darktalon
}

NPCs[82415] = { -- Shinri
	questID = 35732, -- Shinri
	toys = {
		{ itemID = 113543 }, -- Spirit of Shinri
	},
	vignetteID = 387, -- Shinri
}

NPCs[82676] = { -- Enavra
	questID = 35688, -- Enavra Varandi
}

NPCs[82742] = { -- Enavra
	questID = 35688, -- Enavra Varandi
}

NPCs[83385] = { -- Voidseer Kalurg
	questID = 35847, -- Voidseer Kalurg
}

NPCs[83553] = { -- Insha'tar
	isTameable = true,
	questID = 35909, -- Insha'tar
}

NPCs[84911] = { -- Demidos
	pets = {
		{
			itemID = 119431, -- Servant of Demidos
			npcID = 88692, -- Servant of Demidos
		},
	},
	questID = 37351, -- Demidos
}

NPCs[84925] = { -- Quartermaster Hershak
	questID = 37352, -- Quartermaster Hershak
}

NPCs[85001] = { -- Master Sergeant Milgra
	questID = 37353, -- Master Sergeant Milgra
}

NPCs[85029] = { -- Shadowspeaker Niir
	questID = 37354, -- Shadowspeaker Niir
}

NPCs[85121] = { -- Lady Temptessa
	questID = 37355, -- Lady Temptessa
}

NPCs[85451] = { -- Malgosh Shadowkeeper
	questID = 37357, -- Malgosh Shadowkeeper
}

NPCs[85555] = { -- Nagidna
	questID = 37409, -- Nagidna
}

NPCs[85568] = { -- Avalanche
	questID = 37410, -- Avalanche
}

NPCs[85837] = { -- Slivermaw
	questID = 37411, -- Slivermaw
}

NPCs[86213] = { -- Aqualir
	questID = 37356, -- Aqualir
}

NPCs[86689] = { -- Sneevel
	questID = 36880, -- Sneevel
}

-- ----------------------------------------------------------------------------
-- Spires of Arak
-- ----------------------------------------------------------------------------
NPCs[79938] = { -- Shadowbark
	questID = 36478, -- Spires - Vignette 020 - Shadowbark
}

NPCs[80372] = { -- Echidna
	isTameable = true,
	questID = 37406, -- Echidna
}

NPCs[80614] = { -- Blade-Dancer Aeryx
	questID = 35599, -- Blade-Dancer Aeryx
}

NPCs[82050] = { -- Varasha
	isTameable = true,
	questID = 35334, -- The Egg of Varasha
}

NPCs[82247] = { -- Nas Dunberlin
	questID = 36129, -- Nas Dunberlin
}

NPCs[83990] = { -- Solar Magnifier
	questID = 37394, -- Solar Magnifier
}

NPCs[84417] = { -- Mutafen
	questID = 36396, -- Spires - Vignette Boss - Mutafen
}

NPCs[84775] = { -- Tesska the Broken
	questID = 36254, -- Spires - Vignette Boss 002 - Tesska the Broken
}

NPCs[84805] = { -- Stonespite
	isTameable = true,
	questID = 36265, -- Spires - Vignette Boss 001 - Stonespite
}

NPCs[84807] = { -- Durkath Steelmaw
	questID = 36267, -- Spires - Vignette 005 - Durkath Steelmaw
}

NPCs[84810] = { -- Kalos the Bloodbathed
	questID = 36268, -- Spires - Vignette Boss 007 - Kalos the Bloodbathed
}

NPCs[84833] = { -- Sangrikass
	questID = 36276, -- Spires - Vignette Boss 008 - Spawn of Sethe
}

NPCs[84836] = { -- Talonbreaker
	questID = 36278, -- Spires - Vignette Boss 009 - Talonbreaker
}

NPCs[84838] = { -- Poisonmaster Bortusk
	questID = 36279, -- Spires - Vignette 010 - Poisonmaster Bortusk
}

NPCs[84856] = { -- Blightglow
	isTameable = true,
	questID = 36283, -- Spires - Vignette Boss 011 - Blightglow
}

NPCs[84872] = { -- Oskiira the Vengeful
	questID = 36288, -- Spires - Vignette Boss 012 - Oskiira
}

NPCs[84887] = { -- Betsi Boombasket
	questID = 36291, -- Spires - Vignette Boss 014 -  Betsi Boombasket
}

NPCs[84890] = { -- Festerbloom
	questID = 36297, -- Spires - Vignette Boss 016 - Festerbloom
}

NPCs[84912] = { -- Sunderthorn
	isTameable = true,
	questID = 36298, -- Spires - Vignette Boss 017 - Sunderthorn
	vignetteID = 457, -- Stingtail Nest
}

NPCs[84951] = { -- Gobblefin
	questID = 36305, -- Spires - Vignette Boss 023 - Gobblefin
}

NPCs[84955] = { -- Jiasska the Sporegorger
	isTameable = true,
	questID = 36306, -- Spires - Vignette Boss 024 - Jiasska the Sporegorger
}

NPCs[85026] = { -- Soul-Twister Torek
	questID = 37358, -- Soul-Twister Torek
	toys = {
		{ itemID = 119178 }, -- Black Whirlwind
	},
}

NPCs[85036] = { -- Formless Nightmare
	questID = 37360, -- Formless Nightmare
}

NPCs[85037] = { -- Kenos the Unraveler
	questID = 37361, -- Kenos the Unraveller
	vignetteID = 622, -- Kenos the Unraveler
}

NPCs[85078] = { -- Voidreaver Urnae
	questID = 37359, -- Voidreaver Urnae
}

NPCs[85504] = { -- Rotcap
	pets = {
		{
			itemID = 118107, -- Brilliant Spore
			npcID = 86719, -- Brilliant Spore
		},
	},
	questID = 36470, -- Spires - Vignette Boss 006 - Rotcap
}

NPCs[85520] = { -- Swarmleaf
	questID = 36472, -- Spires - Vignette Boss 028 - Wasp Ancient
}

NPCs[86621] = { -- Morphed Sentient
	questID = 37493, -- Morphed Sentient
}

NPCs[86724] = { -- Hermit Palefur
	questID = 36887, -- Spires - Vignette 029 - Hermit Palefur
}

NPCs[86978] = { -- Gaze
	questID = 36943, -- Spires - Vignette 030 - Gaze
}

NPCs[87019] = { -- Gluttonous Giant
	questID = 37390, -- Gluttonous Giant
}

NPCs[87026] = { -- Mecha Plunderer
	questID = 37391, -- Mecha Plunderer
}

NPCs[87027] = { -- Shadow Hulk
	questID = 37392, -- Shadow Hulk
}

NPCs[87029] = { -- Giga Sentinel
	questID = 37393, -- Giga Sentinel
}

-- ----------------------------------------------------------------------------
-- Gorgrond
-- ----------------------------------------------------------------------------
NPCs[50985] = { -- Poundfist
	mounts = {
		{
			itemID = 116792, -- Sunhide Gronnling
			spellID = 171849, -- Sunhide Gronnling
		},
	},
}

NPCs[76473] = { -- Mother Araneae
	isTameable = true,
	questID = 34726, -- Pale Spider Broodmother
	vignetteID = 336, -- Mother Araneae
}

NPCs[77093] = { -- Roardan the Sky Terror
	isTameable = true,
}

NPCs[78260] = { -- King Slime
	questID = 37412, -- King Slime
}

NPCs[78269] = { -- Gnarljaw
	questID = 37413, -- Gnarljaw
}

NPCs[79629] = { -- Stomper Kreego
	questID = 35910, -- Stomper Kreego
	toys = {
		{ itemID = 118224 }, -- Ogre Brewing Kit
	},
	vignetteID = 409, -- Stomper Kreego
}

NPCs[80371] = { -- Typhon
	questID = 37405, -- Typhon
}

NPCs[80725] = { -- Sulfurious
	questID = 36394, -- Sulfurious
	toys = {
		{ itemID = 114227 }, -- Bubble Wand
	},
}

NPCs[80868] = { -- Glut
	questID = 36204, -- Gorger the Hungry
	vignetteID = 434, -- Glut
}

NPCs[81038] = { -- Gelgor of the Blue Flame
	questID = 36391, -- The Blue Flame
}

NPCs[81537] = { -- Khargax the Devourer
	isTameable = true,
}

NPCs[81548] = { -- Charl Doomwing
	isTameable = true,
}

NPCs[82058] = { -- Depthroot
	questID = 37370, -- Depthroot
}

NPCs[82085] = { -- Bashiok
	questID = 35335, -- Bashiok
	toys = {
		{ itemID = 118222 }, -- Spirit of Bashiok
	},
}

NPCs[82311] = { -- Char the Burning
	questID = 35503, -- Char the Burning
}

NPCs[83522] = { -- Hive Queen Skrikka
	isTameable = true,
	questID = 35908, -- Stoneshard Broodmother
	vignetteID = 406, -- Hive Queen Skrikka
}

NPCs[84406] = { -- Mandrakor
	pets = {
		{
			itemID = 118709, -- Doom Bloom
			npcID = 88103, -- Doom Bloom
		},
	},
	questID = 36178, -- Mandrakor the Night Hunter
	vignetteID = 428, -- Mandrakor
}

NPCs[84431] = { -- Greldrok the Cunning
	questID = 36186, -- Greldrok the Cunning
}

NPCs[85250] = { -- Fossilwood the Petrified
	questID = 36387, -- Fossil the Petrified
	toys = {
		{ itemID = 118221 }, -- Petrification Stone
	},
}

NPCs[85264] = { -- Rolkor
	questID = 36393, -- Rolkor the Ironbreaker
}

NPCs[85907] = { -- Berthora
	isTameable = true,
	questID = 36597, -- Berthora
}

NPCs[85970] = { -- Riptar
	isTameable = true,
	questID = 36600, -- Riptar
}

NPCs[86137] = { -- Sunclaw
	questID = 36656, -- Sunclaw
}

NPCs[86257] = { -- Basten
	questID = 37369, -- Protectors of the Grove
	toys = {
		{ itemID = 119432 }, -- Botani Camouflage
	},
	vignetteID = 586, -- Protectors of the Grove
}

NPCs[86258] = { -- Nultra
	questID = 37369, -- Protectors of the Grove
	vignetteID = 586, -- Protectors of the Grove
}

NPCs[86259] = { -- Valstil
	questID = 37369, -- Protectors of the Grove
	vignetteID = 586, -- Protectors of the Grove
}

NPCs[86266] = { -- Venolasix
	isTameable = true,
	questID = 37372, -- Venolasix
}

NPCs[86268] = { -- Alkali
	questID = 37371, -- Alkali
}

NPCs[86410] = { -- Sylldross
	questID = 36794, -- Sylldross
}

NPCs[86520] = { -- Stompalupagus
	isTameable = true,
	questID = 36837, -- Stompalupagus
}

NPCs[86562] = { -- Maniacal Madgard
	questID = 37363, -- Maniacal Madgard
}

NPCs[86566] = { -- Defector Dazgo
	questID = 37362, -- Defector Dazgo
}

NPCs[86571] = { -- Durp the Hated
	questID = 37366, -- Durp the Hated
}

NPCs[86574] = { -- Inventor Blammo
	questID = 37367, -- Inventor Blammo
}

NPCs[86577] = { -- Horgg
	questID = 37365, -- Horgg
}

NPCs[86579] = { -- Blademaster Ro'gor
	questID = 37368, -- Blademaster Ro'gor
}

NPCs[86582] = { -- Morgo Kain
	questID = 37364, -- Morgo Kain
}

NPCs[88580] = { -- Firestarter Grash
	questID = 37373, -- Firestarter Grash
}

NPCs[88582] = { -- Swift Onyx Flayer
	questID = 37374, -- Swift Onyx Flayer
}

NPCs[88583] = { -- Grove Warden Yal
	questID = 37375, -- Grove Warden Yal
}

NPCs[88586] = { -- Mogamago
	isTameable = true,
	questID = 37376, -- Mogamago
}

NPCs[88672] = { -- Hunter Bal'ra
	questID = 37377, -- Hunter Bal'ra
}

-- ----------------------------------------------------------------------------
-- Nagrand
-- ----------------------------------------------------------------------------
NPCs[50981] = { -- Luk'hok
	mounts = {
		{
			itemID = 116661, -- Mottled Meadowstomper
			spellID = 171622, -- Mottled Meadowstomper
		},
	},
}

NPCs[50990] = { -- Nakk the Thunderer
	isTameable = true,
	mounts = {
		{
			itemID = 116659, -- Bloodhoof Bull
			spellID = 171620, -- Bloodhoof Bull
		},
	},
}

NPCs[78161] = { -- Hyperious
	questID = 34862, -- Light the Braziers
	vignetteID = 332, -- Light the Braziers
}

NPCs[79024] = { -- Warmaster Blugthol
	questID = 34645, -- Warmaster Blugthol
}

NPCs[79725] = { -- Captain Ironbeard
	questID = 34727, -- Sea Lord Torglork
	toys = {
		{ itemID = 118244 }, -- Iron Buccaneer's Hat
	},
	vignetteID = 318, -- Captain Ironbeard
}

NPCs[80057] = { -- Soulfang
	questID = 36128, -- Sabermaw - Saberon Vignette Boss
	vignetteID = 424, -- Soulfang
}

NPCs[80122] = { -- Gaz'orda
	isTameable = true,
	questID = 34725, -- Sea Hydra
	vignetteID = 339, -- Gaz'orda
}

NPCs[80370] = { -- Lernaea
	isTameable = true,
	questID = 37408, -- Lernaea
}

NPCs[82486] = { -- Explorer Nozzand
	questID = 35623, -- Nagrand - Vignette Boss - Explorer Rixak
}

NPCs[82755] = { -- Redclaw the Feral
	questID = 35712, -- Nagrand - Vignette Boss 012 - Redclaw the Feral
}

NPCs[82758] = { -- Greatfeather
	isTameable = true,
	questID = 35714, -- Nagrand - Vignette Boss 001 - Greatfeather
}

NPCs[82764] = { -- Gar'lua
	questID = 35715, -- Nagrand - Vignette Boss 002 - Gar'lua the Wolfmother
}

NPCs[82778] = { -- Gnarlhoof the Rabid
	isTameable = true,
	questID = 35717, -- Nagrand - Vignette Boss 015 - Gnarlhoof the Rabid
}

NPCs[82826] = { -- Berserk T-300 Series Mark II
	questID = 35735, -- Nagrand - Vignette Boss 021 - Berserk Shredder
}

NPCs[82899] = { -- Ancient Blademaster
	questID = 35778, -- Nagrand - Vignette Boss 020 - Ancient Blademaster - TSH
}

NPCs[82912] = { -- Grizzlemaw
	isTameable = true,
	questID = 35784, -- Vignette Boss
}

NPCs[82975] = { -- Fangler
	questID = 35836, -- Nagrand - Vignette Boss 008 - The Lunker
}

NPCs[83401] = { -- Netherspawn
	pets = {
		{
			itemID = 116815, -- Netherspawn, Spawn of Netherspawn
			npcID = 86081, -- Netherspawn, Spawn of Netherspawn
		},
	},
	questID = 35865, -- Nagrand - Vignette Boss 018 - Void Ooze
}

NPCs[83409] = { -- Ophiis
	questID = 35875, -- Nagrand - Vignette Boss 024 - Ophiis
}

NPCs[83428] = { -- Windcaller Korast
	questID = 35877, -- Nagrand - Vignette Boss 005 - Windcaller Korast
}

NPCs[83483] = { -- Flinthide
	isTameable = true,
	questID = 35893, -- Nagrand - Vignette Boss 011 - Flinthide
}

NPCs[83509] = { -- Gorepetal
	questID = 35898, -- Nagrand - Vignette Boss 005 - Gorepetal
}

NPCs[83526] = { -- Ru'klaa
	questID = 35900, -- Nagrand - Vignette Boss 013 - Ru'klaa
}

NPCs[83542] = { -- Sean Whitesea
	questID = 35912, -- Nagrand - Vignette Boss 017 - Swindler Whitesea
}

NPCs[83591] = { -- Tura'aka
	isTameable = true,
	questID = 35920, -- Nagrand - Vignette Boss 019 - Tura'aka
}

NPCs[83603] = { -- Hunter Blacktooth
	questID = 35923, -- Nagrand - Vignette Boss 006 - Hunter Blacktooth
}

NPCs[83634] = { -- Scout Pokhar
	questID = 35931, -- Nagrand - Vignette Boss 016 - Warsong Scout
}

NPCs[83643] = { -- Malroc Stonesunder
	questID = 35932, -- Nagrand - Vignette Boss 026 - Warsong Tactician
}

NPCs[83680] = { -- Outrider Duretha
	questID = 35943, -- Nagrand - Vignette Boss 026 - Duretha
}

NPCs[84263] = { -- Graveltooth
	questID = 36159, -- Nagrand - Vignette Boss 004 - Graveltooth
}

NPCs[84435] = { -- Mr. Pinchy Sr.
	questID = 36229, -- Nagrand - Vignette Boss - Mr. Pinchy Sr.
}

NPCs[86729] = { -- Direhoof
	isTameable = true,
}

NPCs[86732] = { -- Bergruu
	isTameable = true,
}

NPCs[86750] = { -- Thek'talon
	isTameable = true,
}

NPCs[86774] = { -- Aogexon
	isTameable = true,
}

NPCs[86835] = { -- Xelganak
	isTameable = true,
}

NPCs[86959] = { -- Karosh Blackwind
	questID = 37399, -- Karosh Blackwind
}

NPCs[87234] = { -- Brutag Grimblade
	questID = 37400, -- Brutag Grimblade
}

NPCs[87239] = { -- Krahl Deadeye
	questID = 37473, -- Krahl Deathwind
	vignetteID = 551, -- Krahl Deathwind
}

NPCs[87344] = { -- Gortag Steelgrip
	questID = 37472, -- Gortag Steelgrip
}

NPCs[87666] = { -- Mu'gra
	isTameable = true,
}

NPCs[87788] = { -- Durg Spinecrusher
	questID = 37395, -- Durg Spinecrusher
}

NPCs[87837] = { -- Bonebreaker
	questID = 37396, -- Bonebreaker
}

NPCs[87846] = { -- Pit Slayer
	questID = 37397, -- Pit-Slayer
	vignetteID = 559, -- Pit Slayer
}

NPCs[88208] = { -- Pit Beast
	questID = 37637, -- Pit Beast
}

NPCs[88210] = { -- Krud the Eviscerator
	questID = 37398, -- Krud the Eviscerator
}

NPCs[88951] = { -- Vileclaw
	isTameable = true,
}

NPCs[98198] = { -- Rukdug
	pets = {
		{
			itemID = 129216, -- Vibrating Arcane Crystal
			npcID = 98236, -- Energized Manafiend
		},
	},
	questID = 40075, -- Rukdug
}

NPCs[98199] = { -- Pugg
	pets = {
		{
			itemID = 129217, -- Warm Arcane Crystal
			npcID = 98237, -- Empowered Manafiend
		},
	},
	questID = 40073, -- Pugg
}

NPCs[98200] = { -- Guk
	pets = {
		{
			itemID = 129218, -- Glittering Arcane Crystal
			npcID = 98238, -- Empyreal Manafiend
		},
	},
	questID = 40074, -- Guk
}

-- ----------------------------------------------------------------------------
-- Alliance/Horde Garrisons
-- ----------------------------------------------------------------------------
NPCs[96323] = { -- Arachnis
	questID = 39617, -- Vignette Tracking Quest
}

-- ----------------------------------------------------------------------------
-- Ashran
-- ----------------------------------------------------------------------------
NPCs[82876] = { -- Grand Marshal Tremblade
	factionGroup = "Alliance",
}

NPCs[82877] = { -- High Warlord Volrath
	factionGroup = "Horde",
}

NPCs[82878] = { -- Marshal Gabriel
	factionGroup = "Alliance",
}

NPCs[82880] = { -- Marshal Karsh Stormforge
	factionGroup = "Alliance",
}

NPCs[82882] = { -- General Aevd
	factionGroup = "Horde",
}

NPCs[82883] = { -- Warlord Noktyn
	factionGroup = "Horde",
}

NPCs[84893] = { -- Goregore
	isTameable = true,
}

NPCs[87362] = { -- Gibby
	isTameable = true,
}
