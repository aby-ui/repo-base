--[[
Name: LibBabble-Faction-3.0
Revision: $Rev: 224 $
Maintainers: ckknight, nevcairiel, Ackis
Website: http://www.wowace.com/projects/libbabble-faction-3-0/
Dependencies: None
License: MIT
]]

local MAJOR_VERSION = "LibBabble-Faction-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Rev: 224 $"):match("%d+"))

if not LibStub then error(MAJOR_VERSION .. " requires LibStub.") end
local lib = LibStub("LibBabble-3.0"):New(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

local GAME_LOCALE = GetLocale()

lib:SetBaseTranslations {
	["Acquaintance"] = "Acquaintance",
	["Aeda Brightdawn"] = "Aeda Brightdawn",
	["Akule Riverhorn"] = "Akule Riverhorn",
	["Alliance"] = "Alliance",
	["Alliance Vanguard"] = "Alliance Vanguard",
	["Arakkoa Outcasts"] = "Arakkoa Outcasts",
	["Argent Crusade"] = "Argent Crusade",
	["Argent Dawn"] = "Argent Dawn",
	["Argussian Reach"] = "Argussian Reach",
	["Argussian Reach (Paragon)"] = "Argussian Reach (Paragon)",
	["Armies of Legionfall"] = "Armies of Legionfall",
	["Armies of Legionfall (Paragon)"] = "Armies of Legionfall (Paragon)",
	["Army of the Light"] = "Army of the Light",
	["Army of the Light (Paragon)"] = "Army of the Light (Paragon)",
	["Ashtongue Deathsworn"] = "Ashtongue Deathsworn",
	["Avengers of Hyjal"] = "Avengers of Hyjal",
	["Baradin's Wardens"] = "Baradin's Wardens",
	["Barracks Bodyguards"] = "Barracks Bodyguards",
	["Best Friend"] = "Best Friend",
	["Bilgewater Cartel"] = "Bilgewater Cartel",
	["Bizmo's Brawlpub"] = "Bizmo's Brawlpub",
	["Bloodsail Buccaneers"] = "Bloodsail Buccaneers",
	["Booty Bay"] = "Booty Bay",
	["Brawl'gar Arena"] = "Brawl'gar Arena",
	["Brood of Nozdormu"] = "Brood of Nozdormu",
	["Buddy"] = "Buddy",
	["Cenarion Circle"] = "Cenarion Circle",
	["Cenarion Expedition"] = "Cenarion Expedition",
	["Chee Chee"] = "Chee Chee",
	["Corbyn"] = "Corbyn",
	["Council of Exarchs"] = "Council of Exarchs",
	["Court of Farondis"] = "Court of Farondis",
	["Court of Farondis (Paragon)"] = "Court of Farondis (Paragon)",
	["Darkmoon Faire"] = "Darkmoon Faire",
	["Darkspear Trolls"] = "Darkspear Trolls",
	["Darnassus"] = "Darnassus",
	["Defender Illona"] = "Defender Illona",
	["Delvar Ironfist"] = "Delvar Ironfist",
	["Dominance Offensive"] = "Dominance Offensive",
	["Dragonmaw Clan"] = "Dragonmaw Clan",
	["Dreamweavers"] = "Dreamweavers",
	["Dreamweavers (Paragon)"] = "Dreamweavers (Paragon)",
	["Ella"] = "Ella",
	["Everlook"] = "Everlook",
	["Exalted"] = "Exalted",
	["Exodar"] = "Exodar",
	["Explorers' League"] = "Explorers' League",
	["Farmer Fung"] = "Farmer Fung",
	["Fish Fellreed"] = "Fish Fellreed",
	["Forest Hozen"] = "Forest Hozen",
	["Frenzyheart Tribe"] = "Frenzyheart Tribe",
	["Friend"] = "Friend",
	["Friendly"] = "Friendly",
	["Frostwolf Clan"] = "Frostwolf Clan",
	["Frostwolf Orcs"] = "Frostwolf Orcs",
	["Gadgetzan"] = "Gadgetzan",
	["Gelkis Clan Centaur"] = "Gelkis Clan Centaur",
	["Gilnean Survivors"] = "Gilnean Survivors",
	["Gilneas"] = "Gilneas",
	["Gina Mudclaw"] = "Gina Mudclaw",
	["Gnomeregan"] = "Gnomeregan",
	["Gnomeregan Exiles"] = "Gnomeregan Exiles",
	["Golden Lotus"] = "Golden Lotus",
	["Good Friend"] = "Good Friend",
	["Guardians of Hyjal"] = "Guardians of Hyjal",
	["Guild"] = "Guild",
	["Hand of the Prophet"] = "Hand of the Prophet",
	["Haohan Mudclaw"] = "Haohan Mudclaw",
	["Hellscream's Reach"] = "Hellscream's Reach",
	["Highmountain Tribe"] = "Highmountain Tribe",
	["Highmountain Tribe (Paragon)"] = "Highmountain Tribe (Paragon)",
	["Honor Hold"] = "Honor Hold",
	["Honored"] = "Honored",
	["Horde"] = "Horde",
	["Horde Expedition"] = "Horde Expedition",
	["Huojin Pandaren"] = "Huojin Pandaren",
	["Hydraxian Waterlords"] = "Hydraxian Waterlords",
	["Illidari"] = "Illidari",
	["Ilyssia of the Waters"] = "Ilyssia of the Waters",
	["Impus"] = "Impus",
	["Ironforge"] = "Ironforge",
	["Jandvik Vrykul"] = "Jandvik Vrykul",
	["Jogu the Drunk"] = "Jogu the Drunk",
	["Keeper Raynae"] = "Keeper Raynae",
	["Keepers of Time"] = "Keepers of Time",
	["Kirin Tor"] = "Kirin Tor",
	["Kirin Tor Offensive"] = "Kirin Tor Offensive",
	["Knights of the Ebon Blade"] = "Knights of the Ebon Blade",
	["Kurenai"] = "Kurenai",
	["Laughing Skull Orcs"] = "Laughing Skull Orcs",
	["Leorajh"] = "Leorajh",
	["Lower City"] = "Lower City",
	["Magram Clan Centaur"] = "Magram Clan Centaur",
	["Moon Guard"] = "Moon Guard",
	["Nat Pagle"] = "Nat Pagle",
	["Netherwing"] = "Netherwing",
	["Neutral"] = "Neutral",
	["Nomi"] = "Nomi",
	["Ogri'la"] = "Ogri'la",
	["Old Hillpaw"] = "Old Hillpaw",
	["Operation: Aardvark"] = "Operation: Aardvark",
	["Operation: Shieldwall"] = "Operation: Shieldwall",
	["Order of the Awakened"] = "Order of the Awakened",
	["Order of the Cloud Serpent"] = "Order of the Cloud Serpent",
	["Orgrimmar"] = "Orgrimmar",
	["Pearlfin Jinyu"] = "Pearlfin Jinyu",
	["Ramkahen"] = "Ramkahen",
	["Rank 1"] = "Rank 1",
	["Rank 2"] = "Rank 2",
	["Rank 3"] = "Rank 3",
	["Rank 4"] = "Rank 4",
	["Rank 5"] = "Rank 5",
	["Rank 6"] = "Rank 6",
	["Rank 7"] = "Rank 7",
	["Rank 8"] = "Rank 8",
	["Ratchet"] = "Ratchet",
	["Ravenholdt"] = "Ravenholdt",
	["Revered"] = "Revered",
	["Shado-Pan"] = "Shado-Pan",
	["Shado-Pan Assault"] = "Shado-Pan Assault",
	["Shadowmoon Exiles"] = "Shadowmoon Exiles",
	["Sha'leth"] = "Sha'leth",
	["Shang Xi's Academy"] = "Shang Xi's Academy",
	["Sha'tari Defense"] = "Sha'tari Defense",
	["Sha'tari Skyguard"] = "Sha'tari Skyguard",
	["Shattered Sun Offensive"] = "Shattered Sun Offensive",
	["Shen'dralar"] = "Shen'dralar",
	["Sho"] = "Sho",
	["Silvermoon City"] = "Silvermoon City",
	["Silverwing Sentinels"] = "Silverwing Sentinels",
	["Sporeggar"] = "Sporeggar",
	["Steamwheedle Draenor Expedition"] = "Steamwheedle Draenor Expedition",
	["Steamwheedle Preservation Society"] = "Steamwheedle Preservation Society",
	["Stormpike Guard"] = "Stormpike Guard",
	["Stormwind"] = "Stormwind",
	["Stranger"] = "Stranger",
	["Sunreaver Onslaught"] = "Sunreaver Onslaught",
	["Syndicate"] = "Syndicate",
	["Talonpriest Ishaal"] = "Talonpriest Ishaal",
	["The Aldor"] = "The Aldor",
	["The Anglers"] = "The Anglers",
	["The Ashen Verdict"] = "The Ashen Verdict",
	["The August Celestials"] = "The August Celestials",
	["The Black Prince"] = "The Black Prince",
	["The Brewmasters"] = "The Brewmasters",
	["The Consortium"] = "The Consortium",
	["The Defilers"] = "The Defilers",
	["The Earthen Ring"] = "The Earthen Ring",
	["The First Responders"] = "The First Responders",
	["The Frostborn"] = "The Frostborn",
	["The Hand of Vengeance"] = "The Hand of Vengeance",
	["The Kalu'ak"] = "The Kalu'ak",
	["The Klaxxi"] = "The Klaxxi",
	["The League of Arathor"] = "The League of Arathor",
	["The Lorewalkers"] = "The Lorewalkers",
	["The Mag'har"] = "The Mag'har",
	["The Nightfallen"] = "The Nightfallen",
	["The Nightfallen (Paragon)"] = "The Nightfallen (Paragon)",
	["The Oracles"] = "The Oracles",
	["The Saberstalkers"] = "The Saberstalkers",
	["The Scale of the Sands"] = "The Scale of the Sands",
	["The Scryers"] = "The Scryers",
	["The Sha'tar"] = "The Sha'tar",
	["The Silver Covenant"] = "The Silver Covenant",
	["The Sons of Hodir"] = "The Sons of Hodir",
	["The Sunreavers"] = "The Sunreavers",
	["The Taunka"] = "The Taunka",
	["The Tillers"] = "The Tillers",
	["The Violet Eye"] = "The Violet Eye",
	["The Wardens"] = "The Wardens",
	["The Wardens (Paragon)"] = "The Wardens (Paragon)",
	["The Wyrmrest Accord"] = "The Wyrmrest Accord",
	["Therazane"] = "Therazane",
	["Thorium Brotherhood"] = "Thorium Brotherhood",
	["Thrallmar"] = "Thrallmar",
	["Thunder Bluff"] = "Thunder Bluff",
	["Timbermaw Hold"] = "Timbermaw Hold",
	["Tina Mudclaw"] = "Tina Mudclaw",
	["Tormmok"] = "Tormmok",
	["Tranquillien"] = "Tranquillien",
	["Tushui Pandaren"] = "Tushui Pandaren",
	["Undercity"] = "Undercity",
	["Valarjar"] = "Valarjar",
	["Valarjar (Paragon)"] = "Valarjar (Paragon)",
	["Valiance Expedition"] = "Valiance Expedition",
	["Vivianne"] = "Vivianne",
	["Vol'jin's Headhunters"] = "Vol'jin's Headhunters",
	["Vol'jin's Spear"] = "Vol'jin's Spear",
	["Warsong Offensive"] = "Warsong Offensive",
	["Warsong Outriders"] = "Warsong Outriders",
	["Wildhammer Clan"] = "Wildhammer Clan",
	["Winterfin Retreat"] = "Winterfin Retreat",
	["Wintersaber Trainers"] = "Wintersaber Trainers",
	["Wrynn's Vanguard"] = "Wrynn's Vanguard",
	["Zandalar Tribe"] = "Zandalar Tribe"
}

if GAME_LOCALE == "enUS" then
	lib:SetCurrentTranslations(true)

elseif GAME_LOCALE == "deDE" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "Bekannter",
	["Aeda Brightdawn"] = "Aeda Morgenglanz",
	--[[Translation missing --]]
	--[[ ["Akule Riverhorn"] = "Akule Riverhorn",--]] 
	["Alliance"] = "Allianz",
	["Alliance Vanguard"] = "Vorposten der Allianz",
	["Arakkoa Outcasts"] = "Ausgestoßene Arakkoa",
	["Argent Crusade"] = "Argentumkreuzzug",
	["Argent Dawn"] = "Argentumdämmerung",
	--[[Translation missing --]]
	--[[ ["Argussian Reach"] = "Argussian Reach",--]] 
	--[[Translation missing --]]
	--[[ ["Argussian Reach (Paragon)"] = "Argussian Reach (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall"] = "Armies of Legionfall",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall (Paragon)"] = "Armies of Legionfall (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light"] = "Army of the Light",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light (Paragon)"] = "Army of the Light (Paragon)",--]] 
	["Ashtongue Deathsworn"] = "Die Todeshörigen",
	["Avengers of Hyjal"] = "Rächer des Hyjal",
	["Baradin's Wardens"] = "Wächter von Baradin",
	["Barracks Bodyguards"] = "Kasernenleibwächter",
	["Best Friend"] = "Bester Freund",
	["Bilgewater Cartel"] = "Bilgewasserkartell",
	["Bizmo's Brawlpub"] = "Bizmos Boxbar",
	["Bloodsail Buccaneers"] = "Blutsegelbukaniere",
	["Booty Bay"] = "Beutebucht",
	["Brawl'gar Arena"] = "Shlae'gararena",
	["Brood of Nozdormu"] = "Brut Nozdormus",
	["Buddy"] = "Kumpel",
	["Cenarion Circle"] = "Zirkel des Cenarius",
	["Cenarion Expedition"] = "Expedition des Cenarius",
	["Chee Chee"] = "Chi-Chi",
	--[[Translation missing --]]
	--[[ ["Corbyn"] = "Corbyn",--]] 
	["Council of Exarchs"] = "Exarchenrat",
	["Court of Farondis"] = "Farondis' Hofstaat",
	--[[Translation missing --]]
	--[[ ["Court of Farondis (Paragon)"] = "Court of Farondis (Paragon)",--]] 
	["Darkmoon Faire"] = "Dunkelmond-Jahrmarkt",
	["Darkspear Trolls"] = "Dunkelspeertrolle",
	["Darnassus"] = "Darnassus",
	["Defender Illona"] = "Beschützerin Illona",
	["Delvar Ironfist"] = "Delvar Eisenfaust",
	["Dominance Offensive"] = "Herrschaftsoffensive",
	["Dragonmaw Clan"] = "Drachenmalklan",
	["Dreamweavers"] = "Die Traumweber",
	--[[Translation missing --]]
	--[[ ["Dreamweavers (Paragon)"] = "Dreamweavers (Paragon)",--]] 
	["Ella"] = "Ella",
	["Everlook"] = "Ewige Warte",
	["Exalted"] = "Ehrfürchtig",
	["Exodar"] = "Die Exodar",
	["Explorers' League"] = "Forscherliga",
	["Farmer Fung"] = "Bauer Fung",
	["Fish Fellreed"] = "Fischi Rohrroder",
	["Forest Hozen"] = "Wald-Ho-zen",
	["Frenzyheart Tribe"] = "Stamm der Wildherzen",
	["Friend"] = "Freund",
	["Friendly"] = "Freundlich",
	["Frostwolf Clan"] = "Frostwolfklan",
	["Frostwolf Orcs"] = "Frostwolforcs",
	["Gadgetzan"] = "Gadgetzan",
	["Gelkis Clan Centaur"] = "Gelkisklan",
	["Gilnean Survivors"] = "Gilnearischer Überlebender",
	["Gilneas"] = "Gilneas",
	["Gina Mudclaw"] = "Gina Lehmkrall",
	["Gnomeregan"] = "Gnomeregan",
	["Gnomeregan Exiles"] = "Gnomeregangnome",
	["Golden Lotus"] = "Goldener Lotus",
	["Good Friend"] = "Guter Freund",
	["Guardians of Hyjal"] = "Wächter des Hyjal",
	["Guild"] = "Gilde",
	["Hand of the Prophet"] = "Hand des Propheten",
	["Haohan Mudclaw"] = "Haohan Lehmkrall",
	["Hellscream's Reach"] = "Höllschreis Hand",
	["Highmountain Tribe"] = "Der Hochbergstamm",
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe (Paragon)"] = "Highmountain Tribe (Paragon)",--]] 
	["Honor Hold"] = "Ehrenfeste",
	["Honored"] = "Wohlwollend",
	["Horde"] = "Horde",
	["Horde Expedition"] = "Expedition der Horde",
	["Huojin Pandaren"] = "Die Huojin",
	["Hydraxian Waterlords"] = "Hydraxianer",
	["Illidari"] = "Illidari",
	--[[Translation missing --]]
	--[[ ["Ilyssia of the Waters"] = "Ilyssia of the Waters",--]] 
	--[[Translation missing --]]
	--[[ ["Impus"] = "Impus",--]] 
	["Ironforge"] = "Eisenschmiede",
	["Jandvik Vrykul"] = "Vrykul von Jandvik",
	["Jogu the Drunk"] = "Jogu der Betrunkene",
	--[[Translation missing --]]
	--[[ ["Keeper Raynae"] = "Keeper Raynae",--]] 
	["Keepers of Time"] = "Hüter der Zeit",
	["Kirin Tor"] = "Kirin Tor",
	["Kirin Tor Offensive"] = "Offensive der Kirin Tor",
	["Knights of the Ebon Blade"] = "Ritter der Schwarzen Klinge",
	["Kurenai"] = "Kurenai",
	["Laughing Skull Orcs"] = "Orcs des Lachenden Schädels",
	["Leorajh"] = "Leorajh",
	["Lower City"] = "Unteres Viertel",
	["Magram Clan Centaur"] = "Magramklan",
	["Moon Guard"] = "Mondwache",
	["Nat Pagle"] = "Nat Pagle",
	["Netherwing"] = "Netherschwingen",
	["Neutral"] = "Neutral",
	["Nomi"] = "Nomi",
	["Ogri'la"] = "Ogri'la",
	["Old Hillpaw"] = "Der alte Hügelpranke",
	--[[Translation missing --]]
	--[[ ["Operation: Aardvark"] = "Operation: Aardvark",--]] 
	["Operation: Shieldwall"] = "Operation Schildwall",
	["Order of the Awakened"] = "Orden der Erwachten",
	["Order of the Cloud Serpent"] = "Der Orden der Wolkenschlange",
	["Orgrimmar"] = "Orgrimmar",
	["Pearlfin Jinyu"] = "Jinyu der Perlflossen",
	["Ramkahen"] = "Ramkahen",
	["Rank 1"] = "Rang 1",
	["Rank 2"] = "Rang 2",
	["Rank 3"] = "Rang 3",
	["Rank 4"] = "Rang 4",
	["Rank 5"] = "Rang 5",
	["Rank 6"] = "Rang 6",
	["Rank 7"] = "Rang 7",
	["Rank 8"] = "Rang 8",
	["Ratchet"] = "Ratschet",
	["Ravenholdt"] = "Rabenholdt",
	["Revered"] = "Respektvoll",
	["Shado-Pan"] = "Shado-Pan",
	["Shado-Pan Assault"] = "Shado-Pan-Vorstoß",
	["Shadowmoon Exiles"] = "Exilanten des Schattenmondklans",
	--[[Translation missing --]]
	--[[ ["Sha'leth"] = "Sha'leth",--]] 
	["Shang Xi's Academy"] = "Akademie des Shang Xi",
	["Sha'tari Defense"] = "Sha'tarverteidigung",
	["Sha'tari Skyguard"] = "Himmelswache der Sha'tari",
	["Shattered Sun Offensive"] = "Offensive der Zerschmetterten Sonne",
	["Shen'dralar"] = "Shen'dralar",
	["Sho"] = "Sho",
	["Silvermoon City"] = "Silbermond",
	["Silverwing Sentinels"] = "Silberschwingen",
	["Sporeggar"] = "Sporeggar",
	["Steamwheedle Draenor Expedition"] = "Draenorexpedition des Dampfdruckkartells",
	["Steamwheedle Preservation Society"] = "Werterhaltungsgesellschaft des Dampfdruckkartells",
	["Stormpike Guard"] = "Sturmlanzengarde",
	["Stormwind"] = "Sturmwind",
	["Stranger"] = "Fremder",
	["Sunreaver Onslaught"] = "Sonnenhäscheransturm",
	["Syndicate"] = "Syndikat",
	["Talonpriest Ishaal"] = "Krallenpriester Ishaal",
	["The Aldor"] = "Die Aldor",
	["The Anglers"] = "Die Angler",
	["The Ashen Verdict"] = "Das Äscherne Verdikt",
	["The August Celestials"] = "Die Himmlischen Erhabenen",
	["The Black Prince"] = "Der Schwarze Prinz",
	["The Brewmasters"] = "Die Braumeister",
	["The Consortium"] = "Das Konsortium",
	["The Defilers"] = "Die Entweihten",
	["The Earthen Ring"] = "Der Irdene Ring",
	["The First Responders"] = "Die Ersthelfer",
	["The Frostborn"] = "Die Frosterben",
	["The Hand of Vengeance"] = "Die Hand der Rache",
	["The Kalu'ak"] = "Die Kalu'ak",
	["The Klaxxi"] = "Die Klaxxi",
	["The League of Arathor"] = "Der Bund von Arathor",
	["The Lorewalkers"] = "Die Lehrensucher",
	["The Mag'har"] = "Die Mag'har",
	["The Nightfallen"] = "Die Nachtsüchtigen",
	--[[Translation missing --]]
	--[[ ["The Nightfallen (Paragon)"] = "The Nightfallen (Paragon)",--]] 
	["The Oracles"] = "Die Orakel",
	["The Saberstalkers"] = "Die Säbelzahnpirscher",
	["The Scale of the Sands"] = "Die Wächter der Sande",
	["The Scryers"] = "Die Seher",
	["The Sha'tar"] = "Die Sha'tar",
	["The Silver Covenant"] = "Der Silberbund",
	["The Sons of Hodir"] = "Die Söhne Hodirs",
	["The Sunreavers"] = "Die Sonnenhäscher",
	["The Taunka"] = "Die Taunka",
	["The Tillers"] = "Die Ackerbauern",
	["The Violet Eye"] = "Das Violette Auge",
	["The Wardens"] = "Die Wächterinnen",
	--[[Translation missing --]]
	--[[ ["The Wardens (Paragon)"] = "The Wardens (Paragon)",--]] 
	["The Wyrmrest Accord"] = "Der Wyrmruhpakt",
	["Therazane"] = "Therazane",
	["Thorium Brotherhood"] = "Thoriumbruderschaft",
	["Thrallmar"] = "Thrallmar",
	["Thunder Bluff"] = "Donnerfels",
	["Timbermaw Hold"] = "Holzschlundfeste",
	["Tina Mudclaw"] = "Tina Lehmkrall",
	["Tormmok"] = "Tormmok",
	["Tranquillien"] = "Tristessa",
	["Tushui Pandaren"] = "Die Tushui",
	["Undercity"] = "Unterstadt",
	["Valarjar"] = "Valarjar",
	--[[Translation missing --]]
	--[[ ["Valarjar (Paragon)"] = "Valarjar (Paragon)",--]] 
	["Valiance Expedition"] = "Expedition Valianz",
	["Vivianne"] = "Vivianne",
	["Vol'jin's Headhunters"] = "Vol'jins Kopfjäger",
	["Vol'jin's Spear"] = "Vol'jins Speer",
	["Warsong Offensive"] = "Kriegshymnenoffensive",
	["Warsong Outriders"] = "Vorhut des Kriegshymnenklan",
	["Wildhammer Clan"] = "Wildhammerklan",
	["Winterfin Retreat"] = "Zuflucht der Winterflossen",
	["Wintersaber Trainers"] = "Wintersäblerausbilder",
	["Wrynn's Vanguard"] = "Wrynns Vorhut",
	["Zandalar Tribe"] = "Stamm der Zandalari"
}
elseif GAME_LOCALE == "frFR" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "Connaissance",
	["Aeda Brightdawn"] = "Aeda Brillaube",
	--[[Translation missing --]]
	--[[ ["Akule Riverhorn"] = "Akule Riverhorn",--]] 
	["Alliance"] = "Alliance",
	["Alliance Vanguard"] = "Avant-garde de l'Alliance",
	["Arakkoa Outcasts"] = "Parias arakkoa",
	["Argent Crusade"] = "La Croisade d'argent",
	["Argent Dawn"] = "Aube d'argent",
	--[[Translation missing --]]
	--[[ ["Argussian Reach"] = "Argussian Reach",--]] 
	--[[Translation missing --]]
	--[[ ["Argussian Reach (Paragon)"] = "Argussian Reach (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall"] = "Armies of Legionfall",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall (Paragon)"] = "Armies of Legionfall (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light"] = "Army of the Light",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light (Paragon)"] = "Army of the Light (Paragon)",--]] 
	["Ashtongue Deathsworn"] = "Ligemort cendrelangue",
	["Avengers of Hyjal"] = "Vengeurs d’Hyjal",
	["Baradin's Wardens"] = "Gardiens de Baradin",
	["Barracks Bodyguards"] = "Gardes du corps de caserne",
	["Best Friend"] = "Meilleur ami",
	["Bilgewater Cartel"] = "Cartel Baille-Fonds",
	["Bizmo's Brawlpub"] = "Bar-Tabasse de Bizmo",
	["Bloodsail Buccaneers"] = "La Voile sanglante",
	["Booty Bay"] = "Baie-du-Butin",
	["Brawl'gar Arena"] = "Arène de Castagn’ar",
	["Brood of Nozdormu"] = "Progéniture de Nozdormu",
	["Buddy"] = "Camarade",
	["Cenarion Circle"] = "Cercle cénarien",
	["Cenarion Expedition"] = "Expédition cénarienne",
	["Chee Chee"] = "Chii Chii",
	--[[Translation missing --]]
	--[[ ["Corbyn"] = "Corbyn",--]] 
	["Council of Exarchs"] = "Conseil des exarques",
	["Court of Farondis"] = "Cour de Farondis",
	--[[Translation missing --]]
	--[[ ["Court of Farondis (Paragon)"] = "Court of Farondis (Paragon)",--]] 
	["Darkmoon Faire"] = "Foire de Sombrelune",
	["Darkspear Trolls"] = "Trolls Sombrelance",
	["Darnassus"] = "Darnassus",
	["Defender Illona"] = "Défenseur Illona",
	["Delvar Ironfist"] = "Delvar Poing-de-Fer",
	["Dominance Offensive"] = "Offensive Domination",
	["Dragonmaw Clan"] = "Clan Gueule-de-dragon",
	["Dreamweavers"] = "Tisse-Rêves",
	--[[Translation missing --]]
	--[[ ["Dreamweavers (Paragon)"] = "Dreamweavers (Paragon)",--]] 
	["Ella"] = "Ella",
	["Everlook"] = "Long-Guet",
	["Exalted"] = "Exalté",
	["Exodar"] = "Exodar",
	["Explorers' League"] = "Ligue des explorateurs",
	["Farmer Fung"] = "Fermier Fung",
	["Fish Fellreed"] = "Marée Pelage de Roseau",
	["Forest Hozen"] = "Hozen des forêts",
	["Frenzyheart Tribe"] = "Tribu Frénécœur",
	["Friend"] = "Ami",
	["Friendly"] = "Amical",
	["Frostwolf Clan"] = "Clan Loup-de-givre",
	["Frostwolf Orcs"] = "Orcs loups-de-givre",
	["Gadgetzan"] = "Gadgetzan",
	["Gelkis Clan Centaur"] = "Centaures (Gelkis)",
	["Gilnean Survivors"] = "Survivants gilnéens",
	["Gilneas"] = "Gilnéas",
	["Gina Mudclaw"] = "Gina Griffe de Tourbe",
	["Gnomeregan"] = "Gnomeregan",
	["Gnomeregan Exiles"] = "Exilés de Gnomeregan",
	["Golden Lotus"] = "Lotus doré",
	["Good Friend"] = "Bon ami",
	["Guardians of Hyjal"] = "Gardiens d'Hyjal",
	["Guild"] = "Guilde",
	["Hand of the Prophet"] = "Main du prophète",
	["Haohan Mudclaw"] = "Haohan Griffe de Tourbe",
	["Hellscream's Reach"] = "Poing de Hurlenfer",
	["Highmountain Tribe"] = "Tribu de Haut-Roc",
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe (Paragon)"] = "Highmountain Tribe (Paragon)",--]] 
	["Honor Hold"] = "Bastion de l'Honneur",
	["Honored"] = "Honoré",
	["Horde"] = "Horde",
	["Horde Expedition"] = "Expédition de la Horde",
	["Huojin Pandaren"] = "Les pandarens huojin",
	["Hydraxian Waterlords"] = "Les Hydraxiens",
	["Illidari"] = "Illidari",
	--[[Translation missing --]]
	--[[ ["Ilyssia of the Waters"] = "Ilyssia of the Waters",--]] 
	--[[Translation missing --]]
	--[[ ["Impus"] = "Impus",--]] 
	["Ironforge"] = "Forgefer",
	["Jandvik Vrykul"] = "Vrykuls de Jandvik",
	["Jogu the Drunk"] = "Jogu l’Ivrogne",
	--[[Translation missing --]]
	--[[ ["Keeper Raynae"] = "Keeper Raynae",--]] 
	["Keepers of Time"] = "Gardiens du Temps",
	["Kirin Tor"] = "Kirin Tor",
	["Kirin Tor Offensive"] = "Offensive du Kirin Tor",
	["Knights of the Ebon Blade"] = "Chevaliers de la Lame d'ébène",
	["Kurenai"] = "Kurenaï",
	["Laughing Skull Orcs"] = "Orcs du Crâne-Ricanant",
	["Leorajh"] = "Leorajh",
	["Lower City"] = "Ville basse",
	["Magram Clan Centaur"] = "Centaures (Magram)",
	["Moon Guard"] = "Garde de la Lune",
	["Nat Pagle"] = "Nat Pagle",
	["Netherwing"] = "Aile-du-Néant",
	["Neutral"] = "Neutre",
	["Nomi"] = "Nomi",
	["Ogri'la"] = "Ogri'la",
	["Old Hillpaw"] = "Vieux Patte des Hauts",
	["Operation: Aardvark"] = "Opération Fourmilier",
	["Operation: Shieldwall"] = "Opération Bouclier",
	["Order of the Awakened"] = "Ordre des Éveillés",
	["Order of the Cloud Serpent"] = "L’ordre du Serpent-nuage",
	["Orgrimmar"] = "Orgrimmar",
	["Pearlfin Jinyu"] = "Jinyu de Nageperle",
	["Ramkahen"] = "Ramkahen",
	["Rank 1"] = "Rang 1",
	["Rank 2"] = "Rang 2",
	["Rank 3"] = "Rang 3",
	["Rank 4"] = "Rang 4",
	["Rank 5"] = "Rang 5",
	["Rank 6"] = "Rang 6",
	["Rank 7"] = "Rang 7",
	["Rank 8"] = "Rang 8",
	["Ratchet"] = "Cabestan",
	["Ravenholdt"] = "Ravenholdt",
	["Revered"] = "Révéré",
	["Shado-Pan"] = "Pandashan",
	["Shado-Pan Assault"] = "Assaut des Pandashan",
	["Shadowmoon Exiles"] = "Exilés ombrelunes",
	--[[Translation missing --]]
	--[[ ["Sha'leth"] = "Sha'leth",--]] 
	["Shang Xi's Academy"] = "Académie de Shang Xi",
	["Sha'tari Defense"] = "Défense sha'tari",
	["Sha'tari Skyguard"] = "Garde-ciel sha'tari",
	["Shattered Sun Offensive"] = "Opération Soleil brisé",
	["Shen'dralar"] = "Shen'dralar",
	["Sho"] = "Sho",
	["Silvermoon City"] = "Lune-d'argent",
	["Silverwing Sentinels"] = "Sentinelles d'Aile-argent",
	["Sporeggar"] = "Sporeggar",
	["Steamwheedle Draenor Expedition"] = "Expédition de Gentepression en Draenor",
	["Steamwheedle Preservation Society"] = "Société de Conservation de Gentepression",
	["Stormpike Guard"] = "Garde Foudrepique",
	["Stormwind"] = "Hurlevent",
	["Stranger"] = "Etranger",
	["Sunreaver Onslaught"] = "Assaut des Saccage-soleil",
	["Syndicate"] = "Syndicat",
	["Talonpriest Ishaal"] = "Prêtre de la serre Ishaal",
	["The Aldor"] = "L'Aldor",
	["The Anglers"] = "Les Hameçonneurs",
	["The Ashen Verdict"] = "Le Verdict des cendres",
	["The August Celestials"] = "Les Astres vénérables",
	["The Black Prince"] = "Le prince noir",
	["The Brewmasters"] = "Les Maîtres brasseurs",
	["The Consortium"] = "Le Consortium",
	["The Defilers"] = "Les Profanateurs",
	["The Earthen Ring"] = "Le Cercle terrestre",
	["The First Responders"] = "Guérisseuses",
	["The Frostborn"] = "Les Givre-nés",
	["The Hand of Vengeance"] = "La Main de la vengeance",
	["The Kalu'ak"] = "Les Kalu'aks",
	["The Klaxxi"] = "Les Klaxxi",
	["The League of Arathor"] = "La Ligue d'Arathor",
	["The Lorewalkers"] = "Les Chroniqueurs",
	["The Mag'har"] = "Les Mag'har",
	["The Nightfallen"] = "Souffrenuit",
	--[[Translation missing --]]
	--[[ ["The Nightfallen (Paragon)"] = "The Nightfallen (Paragon)",--]] 
	["The Oracles"] = "Les Oracles",
	["The Saberstalkers"] = "Traquesabres",
	["The Scale of the Sands"] = "La Balance des sables",
	["The Scryers"] = "Les Clairvoyants",
	["The Sha'tar"] = "Les Sha'tar",
	["The Silver Covenant"] = "Le Concordat argenté",
	["The Sons of Hodir"] = "Les Fils de Hodir",
	["The Sunreavers"] = "Les Saccage-soleil",
	["The Taunka"] = "Les Taunkas",
	["The Tillers"] = "Les Laboureurs",
	["The Violet Eye"] = "L'Œil pourpre",
	["The Wardens"] = "Les Gardiennes",
	--[[Translation missing --]]
	--[[ ["The Wardens (Paragon)"] = "The Wardens (Paragon)",--]] 
	["The Wyrmrest Accord"] = "L'Accord du Repos du ver",
	["Therazane"] = "Therazane",
	["Thorium Brotherhood"] = "Confrérie du thorium",
	["Thrallmar"] = "Thrallmar",
	["Thunder Bluff"] = "Les Pitons-du-Tonnerre",
	["Timbermaw Hold"] = "Les Grumegueules",
	["Tina Mudclaw"] = "Tina Griffe de Tourbe",
	["Tormmok"] = "Tormmok",
	["Tranquillien"] = "Tranquillien",
	["Tushui Pandaren"] = "Les pandarens tushui",
	["Undercity"] = "Fossoyeuse",
	["Valarjar"] = "Valarjar",
	--[[Translation missing --]]
	--[[ ["Valarjar (Paragon)"] = "Valarjar (Paragon)",--]] 
	["Valiance Expedition"] = "Expédition de la Bravoure",
	["Vivianne"] = "Vivianne",
	["Vol'jin's Headhunters"] = "Chasseurs de têtes de Vol'jin",
	["Vol'jin's Spear"] = "Lance de Vol'jin",
	["Warsong Offensive"] = "Offensive chanteguerre",
	["Warsong Outriders"] = "Voltigeurs Chanteguerre",
	["Wildhammer Clan"] = "Clan Marteau-hardi",
	["Winterfin Retreat"] = "Retraite des Ailerons-d'hiver",
	["Wintersaber Trainers"] = "Éleveurs de sabres-d'hiver",
	["Wrynn's Vanguard"] = "Avant-garde de Wrynn",
	["Zandalar Tribe"] = "Tribu Zandalar"
}
elseif GAME_LOCALE == "koKR" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "지인",
	["Aeda Brightdawn"] = "에이다 브라이트돈",
	--[[Translation missing --]]
	--[[ ["Akule Riverhorn"] = "Akule Riverhorn",--]] 
	["Alliance"] = "얼라이언스",
	["Alliance Vanguard"] = "얼라이언스 선봉대",
	["Arakkoa Outcasts"] = "추방된 아라코아",
	["Argent Crusade"] = "은빛십자군",
	["Argent Dawn"] = "은빛 여명회",
	--[[Translation missing --]]
	--[[ ["Argussian Reach"] = "Argussian Reach",--]] 
	--[[Translation missing --]]
	--[[ ["Argussian Reach (Paragon)"] = "Argussian Reach (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall"] = "Armies of Legionfall",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall (Paragon)"] = "Armies of Legionfall (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light"] = "Army of the Light",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light (Paragon)"] = "Army of the Light (Paragon)",--]] 
	["Ashtongue Deathsworn"] = "잿빛혓바닥 결사단",
	["Avengers of Hyjal"] = "하이잘의 복수자",
	["Baradin's Wardens"] = "바라딘 집행단",
	["Barracks Bodyguards"] = "병영 경호원",
	["Best Friend"] = "가장 친한 친구",
	["Bilgewater Cartel"] = "빌지워터 무역회사",
	["Bizmo's Brawlpub"] = "비즈모의 싸움굴",
	["Bloodsail Buccaneers"] = "붉은 해적단",
	["Booty Bay"] = "무법항",
	["Brawl'gar Arena"] = "싸울가르 투기장",
	["Brood of Nozdormu"] = "노즈도르무 혈족",
	["Buddy"] = "동료",
	["Cenarion Circle"] = "세나리온 의회",
	["Cenarion Expedition"] = "세나리온 원정대",
	["Chee Chee"] = "치 치",
	--[[Translation missing --]]
	--[[ ["Corbyn"] = "Corbyn",--]] 
	["Council of Exarchs"] = "총독의 의회",
	["Court of Farondis"] = "파론디스의 궁정",
	--[[Translation missing --]]
	--[[ ["Court of Farondis (Paragon)"] = "Court of Farondis (Paragon)",--]] 
	["Darkmoon Faire"] = "다크문 유랑단",
	["Darkspear Trolls"] = "검은창 트롤",
	["Darnassus"] = "다르나서스",
	["Defender Illona"] = "수호병 일로나",
	["Delvar Ironfist"] = "델바 아이언피스트",
	["Dominance Offensive"] = "지배령 선봉대",
	["Dragonmaw Clan"] = "용아귀 부족",
	["Dreamweavers"] = "몽술사",
	--[[Translation missing --]]
	--[[ ["Dreamweavers (Paragon)"] = "Dreamweavers (Paragon)",--]] 
	["Ella"] = "엘라",
	["Everlook"] = "눈망루 마을",
	["Exalted"] = "확고한 동맹",
	["Exodar"] = "엑소다르",
	["Explorers' League"] = "탐험가 연맹",
	["Farmer Fung"] = "농부 펑",
	["Fish Fellreed"] = "피시 펠리드",
	["Forest Hozen"] = "숲 호젠",
	["Frenzyheart Tribe"] = "광란심장 일족",
	["Friend"] = "친구",
	["Friendly"] = "약간 우호적",
	["Frostwolf Clan"] = "서리늑대 부족",
	["Frostwolf Orcs"] = "서리늑대 오크",
	["Gadgetzan"] = "가젯잔",
	["Gelkis Clan Centaur"] = "겔키스 부족 켄타로우스",
	--[[Translation missing --]]
	--[[ ["Gilnean Survivors"] = "Gilnean Survivors",--]] 
	["Gilneas"] = "길니아스",
	["Gina Mudclaw"] = "지나 머드클로",
	["Gnomeregan"] = "놈리건",
	["Gnomeregan Exiles"] = "놈리건",
	["Golden Lotus"] = "황금 연꽃",
	["Good Friend"] = "좋은 친구",
	["Guardians of Hyjal"] = "하이잘의 수호자",
	["Guild"] = "길드",
	["Hand of the Prophet"] = "예언자의 손",
	["Haohan Mudclaw"] = "하오한 머드클로",
	["Hellscream's Reach"] = "헬스크림 세력단",
	["Highmountain Tribe"] = "높은산 부족",
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe (Paragon)"] = "Highmountain Tribe (Paragon)",--]] 
	["Honor Hold"] = "명예의 요새",
	["Honored"] = "우호적",
	["Horde"] = "호드",
	["Horde Expedition"] = "호드 원정대",
	["Huojin Pandaren"] = "후오진 판다렌",
	["Hydraxian Waterlords"] = "히드락시안 물의 군주",
	--[[Translation missing --]]
	--[[ ["Illidari"] = "Illidari",--]] 
	--[[Translation missing --]]
	--[[ ["Ilyssia of the Waters"] = "Ilyssia of the Waters",--]] 
	--[[Translation missing --]]
	--[[ ["Impus"] = "Impus",--]] 
	["Ironforge"] = "아이언포지",
	--[[Translation missing --]]
	--[[ ["Jandvik Vrykul"] = "Jandvik Vrykul",--]] 
	["Jogu the Drunk"] = "주정뱅이 조구",
	--[[Translation missing --]]
	--[[ ["Keeper Raynae"] = "Keeper Raynae",--]] 
	["Keepers of Time"] = "시간의 수호자",
	["Kirin Tor"] = "키린 토",
	["Kirin Tor Offensive"] = "키린 토 선봉대",
	["Knights of the Ebon Blade"] = "칠흑의 기사단",
	["Kurenai"] = "쿠레나이",
	["Laughing Skull Orcs"] = "웃는 해골 오크",
	["Leorajh"] = "레오라즈",
	["Lower City"] = "고난의 거리",
	["Magram Clan Centaur"] = "마그람 부족 켄타로우스",
	--[[Translation missing --]]
	--[[ ["Moon Guard"] = "Moon Guard",--]] 
	["Nat Pagle"] = "내트 페이글",
	["Netherwing"] = "황천의 용군단",
	["Neutral"] = "중립적",
	["Nomi"] = "노미",
	["Ogri'la"] = "오그릴라",
	["Old Hillpaw"] = "늙은 힐포우",
	--[[Translation missing --]]
	--[[ ["Operation: Aardvark"] = "Operation: Aardvark",--]] 
	["Operation: Shieldwall"] = "철벽방패 작전대",
	["Order of the Awakened"] = "깨어난 자들의 의회",
	["Order of the Cloud Serpent"] = "운룡단",
	["Orgrimmar"] = "오그리마",
	["Pearlfin Jinyu"] = "진주지느러미 진위",
	["Ramkahen"] = "람카헨",
	["Rank 1"] = "1 레벨",
	["Rank 2"] = "2 레벨",
	["Rank 3"] = "3 레벨",
	["Rank 4"] = "4 레벨",
	["Rank 5"] = "5 레벨",
	["Rank 6"] = "6 레벨",
	["Rank 7"] = "7 레벨",
	["Rank 8"] = "8 레벨",
	["Ratchet"] = "톱니항",
	["Ravenholdt"] = "라벤홀트",
	["Revered"] = "매우 우호적",
	["Shado-Pan"] = "음영파",
	["Shado-Pan Assault"] = "음영파 강습단",
	["Shadowmoon Exiles"] = "어둠달 유배자",
	--[[Translation missing --]]
	--[[ ["Sha'leth"] = "Sha'leth",--]] 
	["Shang Xi's Academy"] = "샹 시 도장",
	["Sha'tari Defense"] = "샤타리 수호대",
	["Sha'tari Skyguard"] = "샤타리 하늘경비대",
	["Shattered Sun Offensive"] = "무너진 태양 공격대",
	["Shen'dralar"] = "센드렐라",
	["Sho"] = "쇼",
	["Silvermoon City"] = "실버문",
	["Silverwing Sentinels"] = "은빛날개 파수대",
	["Sporeggar"] = "스포어가르",
	["Steamwheedle Draenor Expedition"] = "스팀휘들 유물 복원회",
	["Steamwheedle Preservation Society"] = "스팀휘들 유물 복원회",
	["Stormpike Guard"] = "스톰파이크 경비대",
	["Stormwind"] = "스톰윈드",
	["Stranger"] = "이방인",
	["Sunreaver Onslaught"] = "선리버 돌격대",
	["Syndicate"] = "비밀결사대",
	["Talonpriest Ishaal"] = "갈퀴사제 이샤알",
	["The Aldor"] = "알도르 사제회",
	["The Anglers"] = "강태공 연합",
	["The Ashen Verdict"] = "잿빛 선고단",
	["The August Celestials"] = "위대한 천신회",
	["The Black Prince"] = "검은 왕자",
	["The Brewmasters"] = "양조사 연합",
	["The Consortium"] = "무역연합",
	["The Defilers"] = "포세이큰 파멸단",
	["The Earthen Ring"] = "대지 고리회",
	--[[Translation missing --]]
	--[[ ["The First Responders"] = "The First Responders",--]] 
	["The Frostborn"] = "서릿결부족 드워프",
	["The Hand of Vengeance"] = "복수의 대리인",
	["The Kalu'ak"] = "칼루아크",
	["The Klaxxi"] = "클락시",
	["The League of Arathor"] = "아라소르 연맹",
	["The Lorewalkers"] = "전승지기",
	["The Mag'har"] = "마그하르",
	["The Nightfallen"] = "나이트폴른",
	--[[Translation missing --]]
	--[[ ["The Nightfallen (Paragon)"] = "The Nightfallen (Paragon)",--]] 
	["The Oracles"] = "점쟁이 조합",
	["The Saberstalkers"] = "서슬추적자",
	["The Scale of the Sands"] = "시간의 중재자",
	["The Scryers"] = "점술가 길드",
	["The Sha'tar"] = "샤타르",
	["The Silver Covenant"] = "은빛 서약단",
	["The Sons of Hodir"] = "호디르의 후예",
	["The Sunreavers"] = "선리버",
	["The Taunka"] = "타운카",
	["The Tillers"] = "농사꾼 연합",
	["The Violet Eye"] = "보랏빛 눈의 감시자",
	--[[Translation missing --]]
	--[[ ["The Wardens"] = "The Wardens",--]] 
	--[[Translation missing --]]
	--[[ ["The Wardens (Paragon)"] = "The Wardens (Paragon)",--]] 
	["The Wyrmrest Accord"] = "고룡쉼터 사원 용군단",
	["Therazane"] = "테라제인",
	["Thorium Brotherhood"] = "토륨 대장조합 ",
	["Thrallmar"] = "스랄마",
	["Thunder Bluff"] = "썬더 블러프",
	["Timbermaw Hold"] = "나무구렁 요새",
	["Tina Mudclaw"] = "티나 머드클로",
	["Tormmok"] = "토르모크",
	["Tranquillien"] = "트랜퀼리엔",
	["Tushui Pandaren"] = "투슈이 판다렌",
	["Undercity"] = "언더시티",
	["Valarjar"] = "발라리아르",
	--[[Translation missing --]]
	--[[ ["Valarjar (Paragon)"] = "Valarjar (Paragon)",--]] 
	["Valiance Expedition"] = "용맹의 원정대",
	["Vivianne"] = "비비안",
	["Vol'jin's Headhunters"] = "볼진의 인간사냥꾼",
	["Vol'jin's Spear"] = "볼진의 창",
	["Warsong Offensive"] = "전쟁노래 공격대",
	["Warsong Outriders"] = "전쟁노래 정찰대",
	["Wildhammer Clan"] = "와일드해머 부족",
	["Winterfin Retreat"] = "겨울지느러미 은신처",
	["Wintersaber Trainers"] = "눈호랑이 조련사",
	["Wrynn's Vanguard"] = "린의 선봉대",
	["Zandalar Tribe"] = "잔달라 부족"
}
elseif GAME_LOCALE == "esES" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "Conocido",
	["Aeda Brightdawn"] = "Aeda Alba Brillante",
	--[[Translation missing --]]
	--[[ ["Akule Riverhorn"] = "Akule Riverhorn",--]] 
	["Alliance"] = "Alianza",
	["Alliance Vanguard"] = "Vanguardia de la Alianza",
	["Arakkoa Outcasts"] = "Arakkoa desterrados",
	["Argent Crusade"] = "Cruzada Argenta",
	["Argent Dawn"] = "El Alba Argenta",
	--[[Translation missing --]]
	--[[ ["Argussian Reach"] = "Argussian Reach",--]] 
	--[[Translation missing --]]
	--[[ ["Argussian Reach (Paragon)"] = "Argussian Reach (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall"] = "Armies of Legionfall",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall (Paragon)"] = "Armies of Legionfall (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light"] = "Army of the Light",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light (Paragon)"] = "Army of the Light (Paragon)",--]] 
	["Ashtongue Deathsworn"] = "Juramorte Lengua de ceniza",
	["Avengers of Hyjal"] = "Vengadores de Hyjal",
	["Baradin's Wardens"] = "Celadores de Baradin",
	["Barracks Bodyguards"] = "Guardaespaldas del cuartel",
	["Best Friend"] = "Mejor amigo",
	["Bilgewater Cartel"] = "Cártel Pantoque",
	["Bizmo's Brawlpub"] = "Club de Lucha de Bizmo",
	["Bloodsail Buccaneers"] = "Bucaneros Velasangre",
	["Booty Bay"] = "Bahía del Botín",
	["Brawl'gar Arena"] = "Arena Liza'gar",
	["Brood of Nozdormu"] = "Linaje de Nozdormu",
	["Buddy"] = "Compañero",
	["Cenarion Circle"] = "Círculo Cenarion",
	["Cenarion Expedition"] = "Expedición Cenarion",
	["Chee Chee"] = "Chee Chee",
	--[[Translation missing --]]
	--[[ ["Corbyn"] = "Corbyn",--]] 
	["Council of Exarchs"] = "Consejo de Exarcas",
	--[[Translation missing --]]
	--[[ ["Court of Farondis"] = "Court of Farondis",--]] 
	--[[Translation missing --]]
	--[[ ["Court of Farondis (Paragon)"] = "Court of Farondis (Paragon)",--]] 
	["Darkmoon Faire"] = "Feria de la Luna Negra",
	["Darkspear Trolls"] = "Trols Lanza Negra",
	["Darnassus"] = "Darnassus",
	["Defender Illona"] = "Defensora Illona",
	["Delvar Ironfist"] = "Delvar Puño de Hierro",
	["Dominance Offensive"] = "Ofensiva de Dominancia",
	["Dragonmaw Clan"] = "Clan Faucedraco",
	--[[Translation missing --]]
	--[[ ["Dreamweavers"] = "Dreamweavers",--]] 
	--[[Translation missing --]]
	--[[ ["Dreamweavers (Paragon)"] = "Dreamweavers (Paragon)",--]] 
	["Ella"] = "Ella",
	["Everlook"] = "Vista Eterna",
	["Exalted"] = "Exaltado",
	["Exodar"] = "El Exodar",
	["Explorers' League"] = "Liga de Expedicionarios",
	["Farmer Fung"] = "Granjero Fung",
	["Fish Fellreed"] = "Pez Junco Talado",
	["Forest Hozen"] = "Hozen del bosque",
	["Frenzyheart Tribe"] = "Tribu Corazón Frenético",
	["Friend"] = "Amigo",
	["Friendly"] = "Amistoso",
	["Frostwolf Clan"] = "Clan Lobo Gélido",
	["Frostwolf Orcs"] = "Orcos Lobo Gélido",
	["Gadgetzan"] = "Gadgetzan",
	["Gelkis Clan Centaur"] = "Centauros del clan Gelkis",
	--[[Translation missing --]]
	--[[ ["Gilnean Survivors"] = "Gilnean Survivors",--]] 
	["Gilneas"] = "Gilneas",
	["Gina Mudclaw"] = "Gina Zarpa Fangosa",
	["Gnomeregan"] = "Gnomeran",
	["Gnomeregan Exiles"] = "Exiliados de Gnomeregan",
	["Golden Lotus"] = "Loto Dorado",
	["Good Friend"] = "Buen amigo",
	["Guardians of Hyjal"] = "Guardianes de Hyjal",
	["Guild"] = "Hermandad",
	--[[Translation missing --]]
	--[[ ["Hand of the Prophet"] = "Hand of the Prophet",--]] 
	["Haohan Mudclaw"] = "Haohan Zarpa Fangosa",
	["Hellscream's Reach"] = "Mando Grito Infernal",
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe"] = "Highmountain Tribe",--]] 
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe (Paragon)"] = "Highmountain Tribe (Paragon)",--]] 
	["Honor Hold"] = "Bastión del Honor",
	["Honored"] = "Honorable",
	["Horde"] = "Horda",
	["Horde Expedition"] = "Expedición de la Horda",
	["Huojin Pandaren"] = "Pandaren Huojin",
	["Hydraxian Waterlords"] = "Srs. del Agua de Hydraxis",
	--[[Translation missing --]]
	--[[ ["Illidari"] = "Illidari",--]] 
	--[[Translation missing --]]
	--[[ ["Ilyssia of the Waters"] = "Ilyssia of the Waters",--]] 
	--[[Translation missing --]]
	--[[ ["Impus"] = "Impus",--]] 
	["Ironforge"] = "Forjaz",
	--[[Translation missing --]]
	--[[ ["Jandvik Vrykul"] = "Jandvik Vrykul",--]] 
	["Jogu the Drunk"] = "Jogo el Ebrio",
	--[[Translation missing --]]
	--[[ ["Keeper Raynae"] = "Keeper Raynae",--]] 
	["Keepers of Time"] = "Vigilantes del Tiempo",
	["Kirin Tor"] = "Kirin Tor",
	["Kirin Tor Offensive"] = "Ofensiva del Kirin Tor",
	["Knights of the Ebon Blade"] = "Caballeros de la Espada de Ébano",
	["Kurenai"] = "Kurenai",
	["Laughing Skull Orcs"] = "Orcos Riecráneos",
	["Leorajh"] = "Leorajh",
	["Lower City"] = "Bajo Arrabal",
	["Magram Clan Centaur"] = "Centauros del clan Magram",
	--[[Translation missing --]]
	--[[ ["Moon Guard"] = "Moon Guard",--]] 
	["Nat Pagle"] = "Nat Pagle",
	["Netherwing"] = "Ala Abisal",
	["Neutral"] = "Neutral",
	["Nomi"] = "Nomi",
	["Ogri'la"] = "Ogri'la",
	["Old Hillpaw"] = "Viejo Zarpa Collado",
	["Operation: Aardvark"] = "Operación: Oricteropo",
	["Operation: Shieldwall"] = "Muro de escudos",
	--[[Translation missing --]]
	--[[ ["Order of the Awakened"] = "Order of the Awakened",--]] 
	["Order of the Cloud Serpent"] = "Orden del dragón nimbo",
	["Orgrimmar"] = "Orgrimmar",
	["Pearlfin Jinyu"] = "Jinyu Aleta de Nácar",
	["Ramkahen"] = "Ramkahen",
	["Rank 1"] = "Rango 1",
	["Rank 2"] = "Rango 2",
	["Rank 3"] = "Rango 3",
	["Rank 4"] = "Rango 4",
	["Rank 5"] = "Rango 5",
	["Rank 6"] = "Rango 6",
	["Rank 7"] = "Rango 7",
	["Rank 8"] = "Rango 8",
	["Ratchet"] = "Trinquete",
	["Ravenholdt"] = "Ravenholdt",
	["Revered"] = "Reverenciado",
	["Shado-Pan"] = "Shadopan",
	["Shado-Pan Assault"] = "Asalto del Shadopan",
	["Shadowmoon Exiles"] = "Exiliados Sombraluna",
	--[[Translation missing --]]
	--[[ ["Sha'leth"] = "Sha'leth",--]] 
	["Shang Xi's Academy"] = "Academia de Shang Xi",
	["Sha'tari Defense"] = "Defensa Sha'tari",
	["Sha'tari Skyguard"] = "Guardia del cielo Sha'tari",
	["Shattered Sun Offensive"] = "Ofensiva Sol Devastado",
	["Shen'dralar"] = "Shen'dralar",
	["Sho"] = "Sho",
	["Silvermoon City"] = "Ciudad de Lunargenta",
	["Silverwing Sentinels"] = "Centinelas Ala de Plata",
	["Sporeggar"] = "Esporaggar",
	["Steamwheedle Draenor Expedition"] = "Expedición Bonvapor de Draenor",
	["Steamwheedle Preservation Society"] = "Sociedad Patrimonial Bonvapor",
	["Stormpike Guard"] = "Guardia Pico Tormenta",
	["Stormwind"] = "Ventormenta",
	["Stranger"] = "Extraño",
	["Sunreaver Onslaught"] = "Embate de los Atracasol",
	["Syndicate"] = "La Hermandad",
	["Talonpriest Ishaal"] = "Sacerdote de la garra Ishaal",
	["The Aldor"] = "Los Aldor",
	["The Anglers"] = "Los Pescadores",
	["The Ashen Verdict"] = "El Veredicto Cinéreo",
	["The August Celestials"] = "Los Augustos Celestiales",
	["The Black Prince"] = "El Príncipe Negro",
	["The Brewmasters"] = "Los Maestros Cerveceros",
	["The Consortium"] = "El Consorcio",
	["The Defilers"] = "Los Rapiñadores",
	["The Earthen Ring"] = "Anillo de la Tierra",
	--[[Translation missing --]]
	--[[ ["The First Responders"] = "The First Responders",--]] 
	["The Frostborn"] = "Los Natoescarcha",
	["The Hand of Vengeance"] = "La Mano de la Venganza",
	["The Kalu'ak"] = "Los Kalu'ak",
	["The Klaxxi"] = "Los Klaxxi",
	["The League of Arathor"] = "Liga de Arathor",
	["The Lorewalkers"] = "Los Eremitas",
	["The Mag'har"] = "Los Mag'har",
	--[[Translation missing --]]
	--[[ ["The Nightfallen"] = "The Nightfallen",--]] 
	--[[Translation missing --]]
	--[[ ["The Nightfallen (Paragon)"] = "The Nightfallen (Paragon)",--]] 
	["The Oracles"] = "Los Oráculos",
	--[[Translation missing --]]
	--[[ ["The Saberstalkers"] = "The Saberstalkers",--]] 
	["The Scale of the Sands"] = "La Escama de las Arenas",
	["The Scryers"] = "Los Arúspices",
	["The Sha'tar"] = "Los Sha'tar",
	["The Silver Covenant"] = "El Pacto de Plata",
	["The Sons of Hodir"] = "Los Hijos de Hodir",
	["The Sunreavers"] = "Los Atracasol",
	["The Taunka"] = "Los Taunka",
	["The Tillers"] = "Los Labradores",
	["The Violet Eye"] = "El Ojo Violeta",
	--[[Translation missing --]]
	--[[ ["The Wardens"] = "The Wardens",--]] 
	--[[Translation missing --]]
	--[[ ["The Wardens (Paragon)"] = "The Wardens (Paragon)",--]] 
	["The Wyrmrest Accord"] = "El Acuerdo del Reposo del Dragón",
	["Therazane"] = "Therazane",
	["Thorium Brotherhood"] = "Hermandad del Torio",
	["Thrallmar"] = "Thrallmar",
	["Thunder Bluff"] = "Cima del Trueno",
	["Timbermaw Hold"] = "Bastión Fauces de Madera",
	["Tina Mudclaw"] = "Tina Zarpa Fangosa",
	["Tormmok"] = "Tormmok",
	["Tranquillien"] = "Tranquillien",
	["Tushui Pandaren"] = "Pandaren Tushui",
	["Undercity"] = "Entrañas",
	--[[Translation missing --]]
	--[[ ["Valarjar"] = "Valarjar",--]] 
	--[[Translation missing --]]
	--[[ ["Valarjar (Paragon)"] = "Valarjar (Paragon)",--]] 
	["Valiance Expedition"] = "Expedición de Denuedo",
	["Vivianne"] = "Vivianne",
	--[[Translation missing --]]
	--[[ ["Vol'jin's Headhunters"] = "Vol'jin's Headhunters",--]] 
	["Vol'jin's Spear"] = "Lanza de Vol'jin",
	["Warsong Offensive"] = "Ofensiva Grito de Guerra",
	["Warsong Outriders"] = "Escoltas Grito de Guerra",
	["Wildhammer Clan"] = "Clan Martillo Salvaje",
	["Winterfin Retreat"] = "Retiro Aleta Invernal",
	["Wintersaber Trainers"] = "Instructores de Sableinvernales",
	["Wrynn's Vanguard"] = "Vanguardia de Wrynn",
	["Zandalar Tribe"] = "Tribu Zandalar"
}
elseif GAME_LOCALE == "esMX" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "Conocido",
	--[[Translation missing --]]
	--[[ ["Aeda Brightdawn"] = "Aeda Brightdawn",--]] 
	--[[Translation missing --]]
	--[[ ["Akule Riverhorn"] = "Akule Riverhorn",--]] 
	["Alliance"] = "Alianza",
	["Alliance Vanguard"] = "Vanguardia de la Alianza",
	--[[Translation missing --]]
	--[[ ["Arakkoa Outcasts"] = "Arakkoa Outcasts",--]] 
	["Argent Crusade"] = "Cruzada Argenta",
	["Argent Dawn"] = "El Alba Argenta",
	--[[Translation missing --]]
	--[[ ["Argussian Reach"] = "Argussian Reach",--]] 
	--[[Translation missing --]]
	--[[ ["Argussian Reach (Paragon)"] = "Argussian Reach (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall"] = "Armies of Legionfall",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall (Paragon)"] = "Armies of Legionfall (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light"] = "Army of the Light",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light (Paragon)"] = "Army of the Light (Paragon)",--]] 
	["Ashtongue Deathsworn"] = "Juramorte Lengua de ceniza",
	["Avengers of Hyjal"] = "Vengadores de Hyjal",
	["Baradin's Wardens"] = "Celadores de Baradin",
	--[[Translation missing --]]
	--[[ ["Barracks Bodyguards"] = "Barracks Bodyguards",--]] 
	["Best Friend"] = "Mejor Amigo",
	["Bilgewater Cartel"] = "Cártel Pantoque",
	["Bizmo's Brawlpub"] = "Club de Lucha de Bizmo",
	["Bloodsail Buccaneers"] = "Bucaneros Velasangre",
	["Booty Bay"] = "Bahía del Botín",
	["Brawl'gar Arena"] = "Arena Liza'gar",
	["Brood of Nozdormu"] = "Linaje de Nozdormu",
	--[[Translation missing --]]
	--[[ ["Buddy"] = "Buddy",--]] 
	["Cenarion Circle"] = "Círculo Cenarion",
	["Cenarion Expedition"] = "Expedición Cenarion",
	["Chee Chee"] = "Chee Chee",
	--[[Translation missing --]]
	--[[ ["Corbyn"] = "Corbyn",--]] 
	--[[Translation missing --]]
	--[[ ["Council of Exarchs"] = "Council of Exarchs",--]] 
	--[[Translation missing --]]
	--[[ ["Court of Farondis"] = "Court of Farondis",--]] 
	--[[Translation missing --]]
	--[[ ["Court of Farondis (Paragon)"] = "Court of Farondis (Paragon)",--]] 
	["Darkmoon Faire"] = "Feria de la Luna Negra",
	["Darkspear Trolls"] = "Trols Lanza Negra",
	["Darnassus"] = "Darnassus",
	--[[Translation missing --]]
	--[[ ["Defender Illona"] = "Defender Illona",--]] 
	--[[Translation missing --]]
	--[[ ["Delvar Ironfist"] = "Delvar Ironfist",--]] 
	["Dominance Offensive"] = "Ofensiva de Dominancia",
	["Dragonmaw Clan"] = "Clan Faucedraco",
	--[[Translation missing --]]
	--[[ ["Dreamweavers"] = "Dreamweavers",--]] 
	--[[Translation missing --]]
	--[[ ["Dreamweavers (Paragon)"] = "Dreamweavers (Paragon)",--]] 
	["Ella"] = "Ella",
	["Everlook"] = "Vista Eterna",
	["Exalted"] = "Exaltado",
	["Exodar"] = "El Exodar",
	["Explorers' League"] = "Liga de Expedicionarios",
	["Farmer Fung"] = "Granjero Fung",
	["Fish Fellreed"] = "Pez Junco Talado",
	["Forest Hozen"] = "Hozen del bosque",
	["Frenzyheart Tribe"] = "Tribu Corazón Frenético",
	["Friend"] = "Amigo",
	["Friendly"] = "Amistoso",
	["Frostwolf Clan"] = "Clan Lobo Gélido",
	--[[Translation missing --]]
	--[[ ["Frostwolf Orcs"] = "Frostwolf Orcs",--]] 
	["Gadgetzan"] = "Gadgetzan",
	["Gelkis Clan Centaur"] = "Centauros del clan Gelkis",
	--[[Translation missing --]]
	--[[ ["Gilnean Survivors"] = "Gilnean Survivors",--]] 
	["Gilneas"] = "Gilneas",
	["Gina Mudclaw"] = "Gina Zarpa Fangosa",
	["Gnomeregan"] = "Gnomeregan",
	["Gnomeregan Exiles"] = "Exiliados de Gnomeregan",
	["Golden Lotus"] = "Loto Dorado",
	["Good Friend"] = "Buen Amigo",
	["Guardians of Hyjal"] = "Guardianes de Hyjal",
	["Guild"] = "Hermandad",
	--[[Translation missing --]]
	--[[ ["Hand of the Prophet"] = "Hand of the Prophet",--]] 
	["Haohan Mudclaw"] = "Haohan Zarpa Fangosa",
	["Hellscream's Reach"] = "Mando Grito Infernal",
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe"] = "Highmountain Tribe",--]] 
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe (Paragon)"] = "Highmountain Tribe (Paragon)",--]] 
	["Honor Hold"] = "Bastión del Honor",
	["Honored"] = "Honorable",
	["Horde"] = "Horda",
	["Horde Expedition"] = "Expedición de la Horda",
	["Huojin Pandaren"] = "Pandaren Houjin",
	["Hydraxian Waterlords"] = "Srs. del Agua de Hydraxis",
	--[[Translation missing --]]
	--[[ ["Illidari"] = "Illidari",--]] 
	--[[Translation missing --]]
	--[[ ["Ilyssia of the Waters"] = "Ilyssia of the Waters",--]] 
	--[[Translation missing --]]
	--[[ ["Impus"] = "Impus",--]] 
	["Ironforge"] = "Forjaz",
	--[[Translation missing --]]
	--[[ ["Jandvik Vrykul"] = "Jandvik Vrykul",--]] 
	["Jogu the Drunk"] = "Jogu el Ebrio",
	--[[Translation missing --]]
	--[[ ["Keeper Raynae"] = "Keeper Raynae",--]] 
	["Keepers of Time"] = "Vigilantes del Tiempo",
	["Kirin Tor"] = "Kirin Tor",
	["Kirin Tor Offensive"] = "Ofensiva del Kirin Tor",
	["Knights of the Ebon Blade"] = "Caballeros de la Espada de Ébano",
	["Kurenai"] = "Kurenai",
	--[[Translation missing --]]
	--[[ ["Laughing Skull Orcs"] = "Laughing Skull Orcs",--]] 
	--[[Translation missing --]]
	--[[ ["Leorajh"] = "Leorajh",--]] 
	["Lower City"] = "Bajo Arrabal",
	["Magram Clan Centaur"] = "Centauros del clan Magram",
	--[[Translation missing --]]
	--[[ ["Moon Guard"] = "Moon Guard",--]] 
	["Nat Pagle"] = "Nat Pagle",
	["Netherwing"] = "Ala Abisal",
	["Neutral"] = "Neutral",
	["Nomi"] = "Nomi",
	["Ogri'la"] = "Ogri'la",
	["Old Hillpaw"] = "Viejo Zarpa Collado",
	--[[Translation missing --]]
	--[[ ["Operation: Aardvark"] = "Operation: Aardvark",--]] 
	["Operation: Shieldwall"] = "Muro de Escudos",
	--[[Translation missing --]]
	--[[ ["Order of the Awakened"] = "Order of the Awakened",--]] 
	["Order of the Cloud Serpent"] = "Orden del Dragón Nimbo",
	["Orgrimmar"] = "Orgrimmar",
	["Pearlfin Jinyu"] = "Jinyu Aleta de Nácar",
	["Ramkahen"] = "Ramkahen",
	["Rank 1"] = "Rango 1",
	["Rank 2"] = "Rango 2",
	["Rank 3"] = "Rango 3",
	["Rank 4"] = "Rango 4",
	["Rank 5"] = "Rango 5",
	["Rank 6"] = "Rango 6",
	["Rank 7"] = "Rango 7",
	["Rank 8"] = "Rango 8",
	["Ratchet"] = "Trinquete",
	["Ravenholdt"] = "Ravenholdt",
	["Revered"] = "Reverenciado",
	["Shado-Pan"] = "Shadopan",
	["Shado-Pan Assault"] = "Asalto del Shadopan",
	--[[Translation missing --]]
	--[[ ["Shadowmoon Exiles"] = "Shadowmoon Exiles",--]] 
	--[[Translation missing --]]
	--[[ ["Sha'leth"] = "Sha'leth",--]] 
	["Shang Xi's Academy"] = "Academia de Shang Xi",
	--[[Translation missing --]]
	--[[ ["Sha'tari Defense"] = "Sha'tari Defense",--]] 
	["Sha'tari Skyguard"] = "Guardia del cielo Sha'tari",
	["Shattered Sun Offensive"] = "Ofensiva Sol Devastado",
	["Shen'dralar"] = "Shen'dralar",
	["Sho"] = "Sho",
	["Silvermoon City"] = "Ciudad de Lunargenta",
	["Silverwing Sentinels"] = "Centinelas Ala de Plata",
	["Sporeggar"] = "Esporaggar",
	--[[Translation missing --]]
	--[[ ["Steamwheedle Draenor Expedition"] = "Steamwheedle Draenor Expedition",--]] 
	--[[Translation missing --]]
	--[[ ["Steamwheedle Preservation Society"] = "Steamwheedle Preservation Society",--]] 
	["Stormpike Guard"] = "Guardia Pico Tormenta",
	["Stormwind"] = "Ventormenta",
	["Stranger"] = "Extraño",
	["Sunreaver Onslaught"] = "Embate de los Atracasol",
	["Syndicate"] = "La Hermandad",
	--[[Translation missing --]]
	--[[ ["Talonpriest Ishaal"] = "Talonpriest Ishaal",--]] 
	["The Aldor"] = "Los Aldor",
	["The Anglers"] = "Los Pescadores",
	["The Ashen Verdict"] = "El Veredicto Cinéreo",
	["The August Celestials"] = "Los Augustos Celestiales",
	["The Black Prince"] = "El Principe Negro",
	["The Brewmasters"] = "Los Maestros Cerveceros",
	["The Consortium"] = "El Consorcio",
	["The Defilers"] = "Los Rapiñadores",
	["The Earthen Ring"] = "El Anillo de la Tierra",
	--[[Translation missing --]]
	--[[ ["The First Responders"] = "The First Responders",--]] 
	["The Frostborn"] = "Los Natoescarcha",
	["The Hand of Vengeance"] = "La Mano de la Venganza",
	["The Kalu'ak"] = "Los Kalu'ak",
	["The Klaxxi"] = "Los Klaxxi",
	["The League of Arathor"] = "Liga de Arathor",
	["The Lorewalkers"] = "Los Eremitas",
	["The Mag'har"] = "Los Mag'har",
	--[[Translation missing --]]
	--[[ ["The Nightfallen"] = "The Nightfallen",--]] 
	--[[Translation missing --]]
	--[[ ["The Nightfallen (Paragon)"] = "The Nightfallen (Paragon)",--]] 
	["The Oracles"] = "Los Oráculos",
	--[[Translation missing --]]
	--[[ ["The Saberstalkers"] = "The Saberstalkers",--]] 
	["The Scale of the Sands"] = "La Escama de las Arenas",
	["The Scryers"] = "Los Arúspices",
	["The Sha'tar"] = "Los Sha'tar",
	["The Silver Covenant"] = "El Pacto de Plata",
	["The Sons of Hodir"] = "Los Hijos de Hodir",
	["The Sunreavers"] = "Los Atracasol",
	["The Taunka"] = "Los taunka",
	["The Tillers"] = "Los Labradores",
	["The Violet Eye"] = "El Ojo Violeta",
	--[[Translation missing --]]
	--[[ ["The Wardens"] = "The Wardens",--]] 
	--[[Translation missing --]]
	--[[ ["The Wardens (Paragon)"] = "The Wardens (Paragon)",--]] 
	["The Wyrmrest Accord"] = "El Acuerdo del Reposo del Dragón",
	["Therazane"] = "Therazane",
	["Thorium Brotherhood"] = "Hermandad del Torio",
	["Thrallmar"] = "Thrallmar",
	["Thunder Bluff"] = "Cima del Trueno",
	["Timbermaw Hold"] = "Bastión Fauces de Madera",
	["Tina Mudclaw"] = "Tina Zarpa Fangosa",
	--[[Translation missing --]]
	--[[ ["Tormmok"] = "Tormmok",--]] 
	["Tranquillien"] = "Tranquillien",
	["Tushui Pandaren"] = "Pandaren Tushui",
	["Undercity"] = "Entrañas",
	--[[Translation missing --]]
	--[[ ["Valarjar"] = "Valarjar",--]] 
	--[[Translation missing --]]
	--[[ ["Valarjar (Paragon)"] = "Valarjar (Paragon)",--]] 
	["Valiance Expedition"] = "Expedición de Denuedo",
	--[[Translation missing --]]
	--[[ ["Vivianne"] = "Vivianne",--]] 
	--[[Translation missing --]]
	--[[ ["Vol'jin's Headhunters"] = "Vol'jin's Headhunters",--]] 
	--[[Translation missing --]]
	--[[ ["Vol'jin's Spear"] = "Vol'jin's Spear",--]] 
	["Warsong Offensive"] = "Ofensiva Grito de Guerra",
	["Warsong Outriders"] = "Escoltas Grito de Guerra",
	["Wildhammer Clan"] = "Clan Martillo Salvaje",
	["Winterfin Retreat"] = "Retiro Aleta Invernal",
	["Wintersaber Trainers"] = "Instructores de sableinvernales",
	--[[Translation missing --]]
	--[[ ["Wrynn's Vanguard"] = "Wrynn's Vanguard",--]] 
	["Zandalar Tribe"] = "Tribu Zandalar"
}
elseif GAME_LOCALE == "ptBR" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "Conhecido",
	--[[Translation missing --]]
	--[[ ["Aeda Brightdawn"] = "Aeda Brightdawn",--]] 
	--[[Translation missing --]]
	--[[ ["Akule Riverhorn"] = "Akule Riverhorn",--]] 
	["Alliance"] = "Aliança",
	["Alliance Vanguard"] = "Vanguarda da Aliança",
	--[[Translation missing --]]
	--[[ ["Arakkoa Outcasts"] = "Arakkoa Outcasts",--]] 
	["Argent Crusade"] = "Cruzada Argêntea",
	["Argent Dawn"] = "Aurora Argêntea",
	--[[Translation missing --]]
	--[[ ["Argussian Reach"] = "Argussian Reach",--]] 
	--[[Translation missing --]]
	--[[ ["Argussian Reach (Paragon)"] = "Argussian Reach (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall"] = "Armies of Legionfall",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall (Paragon)"] = "Armies of Legionfall (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light"] = "Army of the Light",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light (Paragon)"] = "Army of the Light (Paragon)",--]] 
	["Ashtongue Deathsworn"] = "Devotos da Morte Grislíngua",
	["Avengers of Hyjal"] = "Vingadores de Hyjal",
	["Baradin's Wardens"] = "Protetores de Baradin",
	--[[Translation missing --]]
	--[[ ["Barracks Bodyguards"] = "Barracks Bodyguards",--]] 
	["Best Friend"] = "Melhor Amigo",
	["Bilgewater Cartel"] = "Cartel Bondebico",
	["Bizmo's Brawlpub"] = "Bar Brigalhada do Bizmo",
	["Bloodsail Buccaneers"] = "Bucaneiros da Vela Sangrenta",
	["Booty Bay"] = "Angra do Butim",
	["Brawl'gar Arena"] = "Arena de Brig'ga Fea",
	["Brood of Nozdormu"] = "Prole de Nozdormu",
	["Buddy"] = "Camarada",
	["Cenarion Circle"] = "Círculo Cenariano",
	["Cenarion Expedition"] = "Expedição Cenariana",
	["Chee Chee"] = "Tchi Tchi",
	--[[Translation missing --]]
	--[[ ["Corbyn"] = "Corbyn",--]] 
	--[[Translation missing --]]
	--[[ ["Council of Exarchs"] = "Council of Exarchs",--]] 
	--[[Translation missing --]]
	--[[ ["Court of Farondis"] = "Court of Farondis",--]] 
	--[[Translation missing --]]
	--[[ ["Court of Farondis (Paragon)"] = "Court of Farondis (Paragon)",--]] 
	["Darkmoon Faire"] = "Feira de Negraluna",
	["Darkspear Trolls"] = "Trolls Lançanegra",
	["Darnassus"] = "Darnassus",
	--[[Translation missing --]]
	--[[ ["Defender Illona"] = "Defender Illona",--]] 
	--[[Translation missing --]]
	--[[ ["Delvar Ironfist"] = "Delvar Ironfist",--]] 
	["Dominance Offensive"] = "Ofensiva de Dominância",
	["Dragonmaw Clan"] = "Clã Presa do Dragão",
	--[[Translation missing --]]
	--[[ ["Dreamweavers"] = "Dreamweavers",--]] 
	--[[Translation missing --]]
	--[[ ["Dreamweavers (Paragon)"] = "Dreamweavers (Paragon)",--]] 
	["Ella"] = "Ella",
	["Everlook"] = "Visteterna",
	["Exalted"] = "Exaltado",
	["Exodar"] = "Exodar",
	["Explorers' League"] = "Liga dos Exploradores",
	["Farmer Fung"] = "Fazendeiro Fung",
	["Fish Fellreed"] = "Peixe Cana Alta",
	["Forest Hozen"] = "Hozens da Floresta",
	["Frenzyheart Tribe"] = "Tribo Feralma",
	["Friend"] = "Amigo",
	["Friendly"] = "Respeitado",
	["Frostwolf Clan"] = "Clã Lobo do Gelo",
	--[[Translation missing --]]
	--[[ ["Frostwolf Orcs"] = "Frostwolf Orcs",--]] 
	["Gadgetzan"] = "Geringontzan",
	["Gelkis Clan Centaur"] = "Clã dos Centauros Gelkis",
	--[[Translation missing --]]
	--[[ ["Gilnean Survivors"] = "Gilnean Survivors",--]] 
	["Gilneas"] = "Guilnéas",
	["Gina Mudclaw"] = "Gina Garra de Barro",
	["Gnomeregan"] = "Gnomeregan",
	["Gnomeregan Exiles"] = "Gnomeregan",
	["Golden Lotus"] = "Lótus Dourado",
	["Good Friend"] = "Bom Amigo",
	["Guardians of Hyjal"] = "Guardiões de Hyjal",
	["Guild"] = "Guilda",
	--[[Translation missing --]]
	--[[ ["Hand of the Prophet"] = "Hand of the Prophet",--]] 
	["Haohan Mudclaw"] = "Haohan Garra de Barro",
	["Hellscream's Reach"] = "Confins do Grito Infernal",
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe"] = "Highmountain Tribe",--]] 
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe (Paragon)"] = "Highmountain Tribe (Paragon)",--]] 
	["Honor Hold"] = "Fortaleza da Honra",
	["Honored"] = "Honrado",
	["Horde"] = "Horda",
	["Horde Expedition"] = "Expedição da Horda",
	["Huojin Pandaren"] = "Pandarens Huojin",
	["Hydraxian Waterlords"] = "Senhores das Águas Hidraxianos",
	--[[Translation missing --]]
	--[[ ["Illidari"] = "Illidari",--]] 
	--[[Translation missing --]]
	--[[ ["Ilyssia of the Waters"] = "Ilyssia of the Waters",--]] 
	--[[Translation missing --]]
	--[[ ["Impus"] = "Impus",--]] 
	["Ironforge"] = "Altaforja",
	--[[Translation missing --]]
	--[[ ["Jandvik Vrykul"] = "Jandvik Vrykul",--]] 
	["Jogu the Drunk"] = "Be Bum, o Ébrio",
	--[[Translation missing --]]
	--[[ ["Keeper Raynae"] = "Keeper Raynae",--]] 
	["Keepers of Time"] = "Defensores do Tempo",
	["Kirin Tor"] = "Kirin Tor",
	["Kirin Tor Offensive"] = "Ofensiva do Kirin Tor",
	["Knights of the Ebon Blade"] = "Cavaleiros da Lâmina de Ébano",
	["Kurenai"] = "Kurenai",
	--[[Translation missing --]]
	--[[ ["Laughing Skull Orcs"] = "Laughing Skull Orcs",--]] 
	--[[Translation missing --]]
	--[[ ["Leorajh"] = "Leorajh",--]] 
	["Lower City"] = "Bairro Inferior",
	["Magram Clan Centaur"] = "Clã dos Centauros Magram",
	--[[Translation missing --]]
	--[[ ["Moon Guard"] = "Moon Guard",--]] 
	["Nat Pagle"] = "Nat Pagle",
	["Netherwing"] = "Asa Etérea",
	["Neutral"] = "Tolerado",
	["Nomi"] = "Nomi",
	["Ogri'la"] = "Ogri'la",
	["Old Hillpaw"] = "Velho Pata do Monte",
	--[[Translation missing --]]
	--[[ ["Operation: Aardvark"] = "Operation: Aardvark",--]] 
	["Operation: Shieldwall"] = "Operação: Muralha de Escudos",
	--[[Translation missing --]]
	--[[ ["Order of the Awakened"] = "Order of the Awakened",--]] 
	["Order of the Cloud Serpent"] = "Ordem da Serpente das Nuvens",
	["Orgrimmar"] = "Orgrimmar",
	["Pearlfin Jinyu"] = "Jinyus Barbatana de Pérola",
	["Ramkahen"] = "Ramkahen",
	["Rank 1"] = "Rank 1",
	["Rank 2"] = "Rank 2",
	["Rank 3"] = "Rank 3",
	["Rank 4"] = "Rank 4",
	["Rank 5"] = "Rank 5",
	["Rank 6"] = "Rank 5",
	["Rank 7"] = "Rank 6",
	["Rank 8"] = "Rank 8",
	["Ratchet"] = "Vila Catraca",
	["Ravenholdt"] = "Corvoforte",
	["Revered"] = "Reverenciado",
	["Shado-Pan"] = "Shado-pan",
	["Shado-Pan Assault"] = "Ataque Shado-pan",
	--[[Translation missing --]]
	--[[ ["Shadowmoon Exiles"] = "Shadowmoon Exiles",--]] 
	--[[Translation missing --]]
	--[[ ["Sha'leth"] = "Sha'leth",--]] 
	["Shang Xi's Academy"] = "Academia de Shang Xi",
	--[[Translation missing --]]
	--[[ ["Sha'tari Defense"] = "Sha'tari Defense",--]] 
	["Sha'tari Skyguard"] = "Guarda Aérea de Sha'tari",
	["Shattered Sun Offensive"] = "Ofensiva Sol Partido",
	["Shen'dralar"] = "Shen'dralar",
	["Sho"] = "Sho",
	["Silvermoon City"] = "Luaprata",
	["Silverwing Sentinels"] = "Sentinelas da Asa de Prata",
	["Sporeggar"] = "Sporeggar",
	--[[Translation missing --]]
	--[[ ["Steamwheedle Draenor Expedition"] = "Steamwheedle Draenor Expedition",--]] 
	--[[Translation missing --]]
	--[[ ["Steamwheedle Preservation Society"] = "Steamwheedle Preservation Society",--]] 
	["Stormpike Guard"] = "Guarda de Lançatroz",
	["Stormwind"] = "Ventobravo",
	["Stranger"] = "Estranho",
	["Sunreaver Onslaught"] = "Investida Fendessol",
	["Syndicate"] = "Camarilha",
	--[[Translation missing --]]
	--[[ ["Talonpriest Ishaal"] = "Talonpriest Ishaal",--]] 
	["The Aldor"] = "Os Aldor",
	["The Anglers"] = "Os Pescadores",
	["The Ashen Verdict"] = "Veredito Cinzento",
	["The August Celestials"] = "Os Celestiais Majestosos",
	["The Black Prince"] = "O Príncipe Negro",
	["The Brewmasters"] = "Os Mestres Cervejeiros",
	["The Consortium"] = "O Consórcio",
	["The Defilers"] = "Os Profanadores",
	["The Earthen Ring"] = "Harmonia Telúrica",
	--[[Translation missing --]]
	--[[ ["The First Responders"] = "The First Responders",--]] 
	["The Frostborn"] = "Os Gelonatos",
	["The Hand of Vengeance"] = "A Mão da Vingança",
	["The Kalu'ak"] = "Os Kalu'ak",
	["The Klaxxi"] = "Os Klaxxi",
	["The League of Arathor"] = "A Liga de Arathor",
	["The Lorewalkers"] = "Os Andarilhos das Lendas",
	["The Mag'har"] = "Os Mag'har",
	--[[Translation missing --]]
	--[[ ["The Nightfallen"] = "The Nightfallen",--]] 
	--[[Translation missing --]]
	--[[ ["The Nightfallen (Paragon)"] = "The Nightfallen (Paragon)",--]] 
	["The Oracles"] = "Os Oráculos",
	--[[Translation missing --]]
	--[[ ["The Saberstalkers"] = "The Saberstalkers",--]] 
	["The Scale of the Sands"] = "A Escama das Areias",
	["The Scryers"] = "Os Áugures",
	["The Sha'tar"] = "Os Sha'tar",
	["The Silver Covenant"] = "O Pacto de Prata",
	["The Sons of Hodir"] = "Os Filhos de Hodir",
	["The Sunreavers"] = "Os Fendessol",
	["The Taunka"] = "Os Taunka",
	["The Tillers"] = "Os Lavradores",
	["The Violet Eye"] = "O Olho Violeta",
	--[[Translation missing --]]
	--[[ ["The Wardens"] = "The Wardens",--]] 
	--[[Translation missing --]]
	--[[ ["The Wardens (Paragon)"] = "The Wardens (Paragon)",--]] 
	["The Wyrmrest Accord"] = "A Aliança do Repouso das Serpes",
	["Therazane"] = "Therazane",
	["Thorium Brotherhood"] = "Irmandade do Tório",
	["Thrallmar"] = "Thrallmar",
	["Thunder Bluff"] = "Penhasco do Trovão",
	["Timbermaw Hold"] = "Domínio dos Presamatos",
	["Tina Mudclaw"] = "Tina Garra de Barro",
	--[[Translation missing --]]
	--[[ ["Tormmok"] = "Tormmok",--]] 
	["Tranquillien"] = "Tranquillien",
	["Tushui Pandaren"] = "Pandarens Tushui",
	["Undercity"] = "Cidade Baixa",
	--[[Translation missing --]]
	--[[ ["Valarjar"] = "Valarjar",--]] 
	--[[Translation missing --]]
	--[[ ["Valarjar (Paragon)"] = "Valarjar (Paragon)",--]] 
	["Valiance Expedition"] = "Expedição Valentia",
	--[[Translation missing --]]
	--[[ ["Vivianne"] = "Vivianne",--]] 
	--[[Translation missing --]]
	--[[ ["Vol'jin's Headhunters"] = "Vol'jin's Headhunters",--]] 
	--[[Translation missing --]]
	--[[ ["Vol'jin's Spear"] = "Vol'jin's Spear",--]] 
	["Warsong Offensive"] = "Ofensiva Brado Guerreiro",
	["Warsong Outriders"] = "Pioneiros do Brado Guerreiro",
	["Wildhammer Clan"] = "Clã Martelo Feroz",
	["Winterfin Retreat"] = "Retiro da Falésia Invernal",
	["Wintersaber Trainers"] = "Treinadores de Sabres-do-inverno",
	--[[Translation missing --]]
	--[[ ["Wrynn's Vanguard"] = "Wrynn's Vanguard",--]] 
	["Zandalar Tribe"] = "Tribo dos Zandalar"
}
elseif GAME_LOCALE == "itIT" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "Conoscente",
	["Aeda Brightdawn"] = "Aeda Albaluce",
	--[[Translation missing --]]
	--[[ ["Akule Riverhorn"] = "Akule Riverhorn",--]] 
	["Alliance"] = "Alleanza",
	["Alliance Vanguard"] = "Avanguardia Dell'Alleanza",
	["Arakkoa Outcasts"] = "Esiliati Arakkoa",
	["Argent Crusade"] = "Crociata d'Argento",
	["Argent Dawn"] = "Alba D'Argento",
	--[[Translation missing --]]
	--[[ ["Argussian Reach"] = "Argussian Reach",--]] 
	--[[Translation missing --]]
	--[[ ["Argussian Reach (Paragon)"] = "Argussian Reach (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall"] = "Armies of Legionfall",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall (Paragon)"] = "Armies of Legionfall (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light"] = "Army of the Light",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light (Paragon)"] = "Army of the Light (Paragon)",--]] 
	["Ashtongue Deathsworn"] = "Congiurati di Linguamorta",
	["Avengers of Hyjal"] = "Vendicatori di Hyjal",
	["Baradin's Wardens"] = "Custodi di Baradin",
	["Barracks Bodyguards"] = "Guardie del Corpo della Caserma",
	["Best Friend"] = "Miglior Amico",
	["Bilgewater Cartel"] = "Cartello degli Acqualorda",
	["Bizmo's Brawlpub"] = "Club dei Combattenti di Bizmo",
	["Bloodsail Buccaneers"] = "Bucanieri Velerosse",
	["Booty Bay"] = "Baia del Bottino",
	["Brawl'gar Arena"] = "Arena dei Combattenti",
	["Brood of Nozdormu"] = "Stirpe di Nozdormu",
	["Buddy"] = "Compagno",
	["Cenarion Circle"] = "Circolo Cenariano",
	["Cenarion Expedition"] = "Spedizione Cenariana",
	["Chee Chee"] = "Ghi Ghi",
	--[[Translation missing --]]
	--[[ ["Corbyn"] = "Corbyn",--]] 
	["Council of Exarchs"] = "Concilio degli Esarchi",
	["Court of Farondis"] = "Corte di Farondis",
	--[[Translation missing --]]
	--[[ ["Court of Farondis (Paragon)"] = "Court of Farondis (Paragon)",--]] 
	["Darkmoon Faire"] = "Fiera di Lunacupa",
	["Darkspear Trolls"] = "Troll Lanciascura",
	["Darnassus"] = "Darnassus",
	["Defender Illona"] = "Difensore Illona",
	["Delvar Ironfist"] = "Devlar Pugnoferreo",
	["Dominance Offensive"] = "Offensiva del Dominio",
	["Dragonmaw Clan"] = "Clan Fauci di Drago",
	["Dreamweavers"] = "PLasmasogni",
	--[[Translation missing --]]
	--[[ ["Dreamweavers (Paragon)"] = "Dreamweavers (Paragon)",--]] 
	["Ella"] = "Ella",
	["Everlook"] = "Lungavista",
	["Exalted"] = "Osannato",
	["Exodar"] = "Exodar",
	["Explorers' League"] = "Lega degli Esploratori",
	["Farmer Fung"] = "Contadino Fung",
	["Fish Fellreed"] = "Trota Mezza Canna",
	["Forest Hozen"] = "Hozen della Foresta",
	["Frenzyheart Tribe"] = "Tribù dei Cuorferoce",
	["Friend"] = "Amico",
	["Friendly"] = "Amichevole",
	["Frostwolf Clan"] = "Clan Lupi Bianchi",
	["Frostwolf Orcs"] = "Orchi Lupi Bianchi",
	["Gadgetzan"] = "Meccania",
	["Gelkis Clan Centaur"] = "Centauri del Clan Gelkis",
	["Gilnean Survivors"] = "Sopravissuti di Gilneas",
	["Gilneas"] = "Gilneas",
	["Gina Mudclaw"] = "Gina Palmo Florido",
	["Gnomeregan"] = "Gnomeregan",
	["Gnomeregan Exiles"] = "Esiliati di Gnomeregan",
	["Golden Lotus"] = "Loto Dorato",
	["Good Friend"] = "Amico Intimo",
	["Guardians of Hyjal"] = "Guardiani di Hyjal",
	["Guild"] = "Gilda",
	["Hand of the Prophet"] = "Mano del Profeta",
	["Haohan Mudclaw"] = "Haoran Palmo Florido",
	["Hellscream's Reach"] = "Avanguardia di Malogrido",
	["Highmountain Tribe"] = "Tribù Alto Monte",
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe (Paragon)"] = "Highmountain Tribe (Paragon)",--]] 
	["Honor Hold"] = "Rocca dell'Onore",
	["Honored"] = "Onorato",
	["Horde"] = "Orda",
	["Horde Expedition"] = "Spedizione dell'Orda",
	["Huojin Pandaren"] = "Pandaren Huojin",
	["Hydraxian Waterlords"] = "Seguaci di Hydraxian",
	["Illidari"] = "Illidari",
	--[[Translation missing --]]
	--[[ ["Ilyssia of the Waters"] = "Ilyssia of the Waters",--]] 
	--[[Translation missing --]]
	--[[ ["Impus"] = "Impus",--]] 
	["Ironforge"] = "Forgiardente",
	["Jandvik Vrykul"] = "Vrykul di Jandvik",
	["Jogu the Drunk"] = "Jogu l'Ubriaco",
	--[[Translation missing --]]
	--[[ ["Keeper Raynae"] = "Keeper Raynae",--]] 
	["Keepers of Time"] = "Custodi del Tempo",
	["Kirin Tor"] = "Kirin Tor",
	["Kirin Tor Offensive"] = "Rivalsa del Kirin Tor",
	["Knights of the Ebon Blade"] = "Cavalieri della Spada d'Ebano",
	["Kurenai"] = "Kurenai",
	["Laughing Skull Orcs"] = "Orchi Teschio Ridente",
	["Leorajh"] = "Leorajh",
	["Lower City"] = "Città Bassa",
	["Magram Clan Centaur"] = "Centauri del Clan Magram",
	["Moon Guard"] = "Guardie della Luna",
	["Nat Pagle"] = "Nat Pagle",
	["Netherwing"] = "Alafatua",
	["Neutral"] = "Neutrale",
	["Nomi"] = "Nomi",
	["Ogri'la"] = "Ogri'la",
	["Old Hillpaw"] = "Vecchio Zampa Brulla",
	["Operation: Aardvark"] = "Operazione: Aardvark",
	["Operation: Shieldwall"] = "Operazione Baluardo",
	["Order of the Awakened"] = "Ordine dei Risvegliati",
	["Order of the Cloud Serpent"] = "Ordine della Serpe delle Nubi",
	["Orgrimmar"] = "Orgrimmar",
	["Pearlfin Jinyu"] = "Jinyu Pinnavitrea",
	["Ramkahen"] = "Ramkahen",
	["Rank 1"] = "Grado 1",
	["Rank 2"] = "Grado 2",
	["Rank 3"] = "Grado 3",
	["Rank 4"] = "Grado 4",
	["Rank 5"] = "Grado 5",
	["Rank 6"] = "Grado 6",
	["Rank 7"] = "Grado 7",
	["Rank 8"] = "Grado 8",
	["Ratchet"] = "Porto Paranco",
	["Ravenholdt"] = "Corvolesto",
	["Revered"] = "Riverito",
	["Shado-Pan"] = "Shandaren",
	["Shado-Pan Assault"] = "Avanzata degli Shandaren",
	["Shadowmoon Exiles"] = "Esiliati Torvaluna",
	--[[Translation missing --]]
	--[[ ["Sha'leth"] = "Sha'leth",--]] 
	["Shang Xi's Academy"] = "Accademia di Shang Xi",
	["Sha'tari Defense"] = "Protettori Sha'tari",
	["Sha'tari Skyguard"] = "Guardiacieli Sha'tari",
	["Shattered Sun Offensive"] = "Offensiva del Sole Infranto",
	["Shen'dralar"] = "Shen'dralar",
	["Sho"] = "Sho",
	["Silvermoon City"] = "Lunargenta",
	["Silverwing Sentinels"] = "Sentinelle Alargentea",
	["Sporeggar"] = "Sporeggar",
	["Steamwheedle Draenor Expedition"] = "Spedizione su Draenor degli Spargifumo",
	["Steamwheedle Preservation Society"] = "Società di Preservazione degli Spargifumo",
	["Stormpike Guard"] = "Guardia dei Piccatonante",
	["Stormwind"] = "Roccavento",
	["Stranger"] = "Estraneo",
	["Sunreaver Onslaught"] = "Furia dei Predatori del Sole",
	["Syndicate"] = "Lega dei Tagliagole",
	["Talonpriest Ishaal"] = "Sacerdote dell'Artiglio Ishaal",
	["The Aldor"] = "Veggenti",
	["The Anglers"] = "Lancialenza",
	["The Ashen Verdict"] = "Verdetto Cinereo",
	["The August Celestials"] = "Venerabili Celestiali",
	["The Black Prince"] = "Principe Nero",
	["The Brewmasters"] = "Padri della Birra",
	["The Consortium"] = "Consorzio",
	["The Defilers"] = "Profanatori",
	["The Earthen Ring"] = "Circolo della Terra",
	["The First Responders"] = "Primi Soccorsi",
	["The Frostborn"] = "Figli del Gelo",
	["The Hand of Vengeance"] = "Mano della Vendetta",
	["The Kalu'ak"] = "Kalu'ak",
	["The Klaxxi"] = "Klaxxi",
	["The League of Arathor"] = "Lega di Arathor",
	["The Lorewalkers"] = "Raminghi della Sapienza",
	["The Mag'har"] = "Mag'har",
	["The Nightfallen"] = "Esuli Oscuri",
	--[[Translation missing --]]
	--[[ ["The Nightfallen (Paragon)"] = "The Nightfallen (Paragon)",--]] 
	["The Oracles"] = "Tribù degli Oracoli",
	["The Saberstalkers"] = "Bracconieri Selvaggi",
	["The Scale of the Sands"] = "Scale delle Sabbie",
	["The Scryers"] = "Veggenti",
	["The Sha'tar"] = "Sha'tar",
	["The Silver Covenant"] = "Patto d'Argento",
	["The Sons of Hodir"] = "Figli di Hodir",
	["The Sunreavers"] = "Predatori del Sole",
	["The Taunka"] = "Taunka",
	["The Tillers"] = "Coltivatori",
	["The Violet Eye"] = "Occhio Violaceo",
	["The Wardens"] = "Custodi",
	--[[Translation missing --]]
	--[[ ["The Wardens (Paragon)"] = "The Wardens (Paragon)",--]] 
	["The Wyrmrest Accord"] = "Lega dei Draghi",
	["Therazane"] = "Therazane",
	["Thorium Brotherhood"] = "Fratellanza del Torio",
	["Thrallmar"] = "Thrallmar",
	["Thunder Bluff"] = "Picco del Tuono",
	["Timbermaw Hold"] = "Rifugio dei Mordilegno",
	["Tina Mudclaw"] = "Tina Palmo Florido",
	["Tormmok"] = "Tormmok",
	["Tranquillien"] = "Tranquillien",
	["Tushui Pandaren"] = "Pandaren Tushui",
	["Undercity"] = "Sepulcra",
	["Valarjar"] = "Valarjar",
	--[[Translation missing --]]
	--[[ ["Valarjar (Paragon)"] = "Valarjar (Paragon)",--]] 
	["Valiance Expedition"] = "Spedizione degli Arditi",
	["Vivianne"] = "Vivianne",
	["Vol'jin's Headhunters"] = "Cacciatori di Teste di Vol'jin",
	["Vol'jin's Spear"] = "Lancia di Vol'jin",
	["Warsong Offensive"] = "Offensiva dei Cantaguerra",
	["Warsong Outriders"] = "Predoni Cantaguerra",
	["Wildhammer Clan"] = "Clan Granmartello",
	["Winterfin Retreat"] = "Rifugio dei Pinnafredda",
	["Wintersaber Trainers"] = "Addestratori delle Fiere Glaciali",
	["Wrynn's Vanguard"] = "Lancia di Vol'jin",
	["Zandalar Tribe"] = "Tribù Zandalari"
}
elseif GAME_LOCALE == "ruRU" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "Знакомый",
	--[[Translation missing --]]
	--[[ ["Aeda Brightdawn"] = "Aeda Brightdawn",--]] 
	--[[Translation missing --]]
	--[[ ["Akule Riverhorn"] = "Akule Riverhorn",--]] 
	["Alliance"] = "Альянс",
	["Alliance Vanguard"] = "Авангард Альянса",
	--[[Translation missing --]]
	--[[ ["Arakkoa Outcasts"] = "Arakkoa Outcasts",--]] 
	["Argent Crusade"] = "Серебряный Авангард",
	["Argent Dawn"] = "Серебряный Рассвет",
	--[[Translation missing --]]
	--[[ ["Argussian Reach"] = "Argussian Reach",--]] 
	--[[Translation missing --]]
	--[[ ["Argussian Reach (Paragon)"] = "Argussian Reach (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall"] = "Armies of Legionfall",--]] 
	--[[Translation missing --]]
	--[[ ["Armies of Legionfall (Paragon)"] = "Armies of Legionfall (Paragon)",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light"] = "Army of the Light",--]] 
	--[[Translation missing --]]
	--[[ ["Army of the Light (Paragon)"] = "Army of the Light (Paragon)",--]] 
	["Ashtongue Deathsworn"] = "Пеплоусты-служители",
	["Avengers of Hyjal"] = "Хиджальские мстители",
	["Baradin's Wardens"] = "Защитники Тол Барада",
	--[[Translation missing --]]
	--[[ ["Barracks Bodyguards"] = "Barracks Bodyguards",--]] 
	["Best Friend"] = "Лучший друг",
	["Bilgewater Cartel"] = "Картель Трюмных Вод",
	["Bizmo's Brawlpub"] = "потасовочная \"У Бизмо\"",
	["Bloodsail Buccaneers"] = "Пираты Кровавого Паруса",
	["Booty Bay"] = "Пиратская бухта",
	["Brawl'gar Arena"] = "арена Морд’Бой",
	["Brood of Nozdormu"] = "Род Ноздорму",
	["Buddy"] = "Приятель",
	["Cenarion Circle"] = "Круг Кенария",
	["Cenarion Expedition"] = "Кенарийская экспедиция",
	["Chee Chee"] = "Чи-Чи",
	--[[Translation missing --]]
	--[[ ["Corbyn"] = "Corbyn",--]] 
	--[[Translation missing --]]
	--[[ ["Council of Exarchs"] = "Council of Exarchs",--]] 
	--[[Translation missing --]]
	--[[ ["Court of Farondis"] = "Court of Farondis",--]] 
	--[[Translation missing --]]
	--[[ ["Court of Farondis (Paragon)"] = "Court of Farondis (Paragon)",--]] 
	["Darkmoon Faire"] = "Ярмарка Новолуния",
	["Darkspear Trolls"] = "Тролли Черного Копья",
	["Darnassus"] = "Дарнас",
	--[[Translation missing --]]
	--[[ ["Defender Illona"] = "Defender Illona",--]] 
	--[[Translation missing --]]
	--[[ ["Delvar Ironfist"] = "Delvar Ironfist",--]] 
	["Dominance Offensive"] = "Армия Покорителей",
	["Dragonmaw Clan"] = "Клан Драконьей Пасти",
	--[[Translation missing --]]
	--[[ ["Dreamweavers"] = "Dreamweavers",--]] 
	--[[Translation missing --]]
	--[[ ["Dreamweavers (Paragon)"] = "Dreamweavers (Paragon)",--]] 
	["Ella"] = "Элла",
	["Everlook"] = "Круговзор",
	["Exalted"] = "Превознесение",
	["Exodar"] = "Экзодар",
	["Explorers' League"] = "Лига исследователей",
	["Farmer Fung"] = "Фермер Фун",
	["Fish Fellreed"] = "Рыба Тростниковая Шкура",
	["Forest Hozen"] = "Лесные хозены",
	["Frenzyheart Tribe"] = "Племя Бешеного Сердца",
	["Friend"] = "Друг",
	["Friendly"] = "Дружелюбие",
	["Frostwolf Clan"] = "Клан Северного Волка",
	--[[Translation missing --]]
	--[[ ["Frostwolf Orcs"] = "Frostwolf Orcs",--]] 
	["Gadgetzan"] = "Прибамбасск",
	["Gelkis Clan Centaur"] = "Кентавры из племени Гелкис",
	--[[Translation missing --]]
	--[[ ["Gilnean Survivors"] = "Gilnean Survivors",--]] 
	["Gilneas"] = "Гилнеас",
	["Gina Mudclaw"] = "Джина Грязный Коготь",
	["Gnomeregan"] = "Гномреган",
	["Gnomeregan Exiles"] = "Изгнанники Гномрегана",
	["Golden Lotus"] = "Золотой Лотос",
	["Good Friend"] = "Хороший друг",
	["Guardians of Hyjal"] = "Стражи Хиджала",
	["Guild"] = "Гильдия",
	--[[Translation missing --]]
	--[[ ["Hand of the Prophet"] = "Hand of the Prophet",--]] 
	["Haohan Mudclaw"] = "Хаохань Грязный Коготь",
	["Hellscream's Reach"] = "Батальон Адского Крика",
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe"] = "Highmountain Tribe",--]] 
	--[[Translation missing --]]
	--[[ ["Highmountain Tribe (Paragon)"] = "Highmountain Tribe (Paragon)",--]] 
	["Honor Hold"] = "Оплот Чести",
	["Honored"] = "Уважение",
	["Horde"] = "Орда",
	["Horde Expedition"] = "Экспедиция Орды",
	["Huojin Pandaren"] = "Пандарены Хоцзинь",
	["Hydraxian Waterlords"] = "Гидраксианские Повелители Вод",
	--[[Translation missing --]]
	--[[ ["Illidari"] = "Illidari",--]] 
	--[[Translation missing --]]
	--[[ ["Ilyssia of the Waters"] = "Ilyssia of the Waters",--]] 
	--[[Translation missing --]]
	--[[ ["Impus"] = "Impus",--]] 
	["Ironforge"] = "Стальгорн",
	--[[Translation missing --]]
	--[[ ["Jandvik Vrykul"] = "Jandvik Vrykul",--]] 
	["Jogu the Drunk"] = "Йогу Пьяный",
	--[[Translation missing --]]
	--[[ ["Keeper Raynae"] = "Keeper Raynae",--]] 
	["Keepers of Time"] = "Хранители Времени",
	["Kirin Tor"] = "Кирин-Тор",
	["Kirin Tor Offensive"] = "Армия Кирин-Тора",
	["Knights of the Ebon Blade"] = "Рыцари Черного Клинка",
	["Kurenai"] = "Куренай",
	--[[Translation missing --]]
	--[[ ["Laughing Skull Orcs"] = "Laughing Skull Orcs",--]] 
	--[[Translation missing --]]
	--[[ ["Leorajh"] = "Leorajh",--]] 
	["Lower City"] = "Нижний Город",
	["Magram Clan Centaur"] = "Кентавры из племени Маграм",
	--[[Translation missing --]]
	--[[ ["Moon Guard"] = "Moon Guard",--]] 
	["Nat Pagle"] = "Нат Пэгл",
	["Netherwing"] = "Крылья Пустоты",
	["Neutral"] = "Равнодушие",
	["Nomi"] = "Номи",
	["Ogri'la"] = "Огри'ла",
	["Old Hillpaw"] = "Старик Горная Лапа",
	--[[Translation missing --]]
	--[[ ["Operation: Aardvark"] = "Operation: Aardvark",--]] 
	["Operation: Shieldwall"] = "Операция \"Заслон\"",
	--[[Translation missing --]]
	--[[ ["Order of the Awakened"] = "Order of the Awakened",--]] 
	["Order of the Cloud Serpent"] = "Орден Облачного Змея",
	["Orgrimmar"] = "Оргриммар",
	["Pearlfin Jinyu"] = "Цзинь-юй Жемчужного Плавника",
	["Ramkahen"] = "Рамкахены",
	["Rank 1"] = "Ранг 1",
	["Rank 2"] = "Ранг 2",
	["Rank 3"] = "Ранг 3",
	["Rank 4"] = "Ранг 4",
	["Rank 5"] = "Ранг 5",
	["Rank 6"] = "Ранг 6",
	["Rank 7"] = "Ранг 7",
	["Rank 8"] = "Ранг 8",
	["Ratchet"] = "Кабестан",
	["Ravenholdt"] = "Черный Ворон",
	["Revered"] = "Почтение",
	["Shado-Pan"] = "Шадо-Пан",
	["Shado-Pan Assault"] = "Натиск Шадо-Пан",
	--[[Translation missing --]]
	--[[ ["Shadowmoon Exiles"] = "Shadowmoon Exiles",--]] 
	--[[Translation missing --]]
	--[[ ["Sha'leth"] = "Sha'leth",--]] 
	["Shang Xi's Academy"] = "Академия Шан Си",
	--[[Translation missing --]]
	--[[ ["Sha'tari Defense"] = "Sha'tari Defense",--]] 
	["Sha'tari Skyguard"] = "Стражи Небес Ша'тар",
	["Shattered Sun Offensive"] = "Армия Расколотого Солнца",
	["Shen'dralar"] = "Шен'дралар",
	["Sho"] = "Шо",
	["Silvermoon City"] = "Луносвет",
	["Silverwing Sentinels"] = "Среброкрылые Часовые",
	["Sporeggar"] = "Спореггар",
	--[[Translation missing --]]
	--[[ ["Steamwheedle Draenor Expedition"] = "Steamwheedle Draenor Expedition",--]] 
	--[[Translation missing --]]
	--[[ ["Steamwheedle Preservation Society"] = "Steamwheedle Preservation Society",--]] 
	["Stormpike Guard"] = "Стража Грозовой Вершины",
	["Stormwind"] = "Штормград",
	["Stranger"] = "Незнакомец",
	["Sunreaver Onslaught"] = "Войска Похитителей Солнца",
	["Syndicate"] = "Синдикат",
	--[[Translation missing --]]
	--[[ ["Talonpriest Ishaal"] = "Talonpriest Ishaal",--]] 
	["The Aldor"] = "Алдоры",
	["The Anglers"] = "Рыболовы",
	["The Ashen Verdict"] = "Пепельный союз",
	["The August Celestials"] = "Небожители",
	["The Black Prince"] = "Черный принц",
	["The Brewmasters"] = "Хмелевары",
	["The Consortium"] = "Консорциум",
	["The Defilers"] = "Осквернители",
	["The Earthen Ring"] = "Служители Земли",
	--[[Translation missing --]]
	--[[ ["The First Responders"] = "The First Responders",--]] 
	["The Frostborn"] = "Зиморожденные",
	["The Hand of Vengeance"] = "Карающая Длань",
	["The Kalu'ak"] = "Калу'ак",
	["The Klaxxi"] = "Клакси",
	["The League of Arathor"] = "Лига Аратора",
	["The Lorewalkers"] = "Хранители истории",
	["The Mag'har"] = "Маг'хары",
	--[[Translation missing --]]
	--[[ ["The Nightfallen"] = "The Nightfallen",--]] 
	--[[Translation missing --]]
	--[[ ["The Nightfallen (Paragon)"] = "The Nightfallen (Paragon)",--]] 
	["The Oracles"] = "Оракулы",
	--[[Translation missing --]]
	--[[ ["The Saberstalkers"] = "The Saberstalkers",--]] 
	["The Scale of the Sands"] = "Песчаная Чешуя",
	["The Scryers"] = "Провидцы",
	["The Sha'tar"] = "Ша'тар",
	["The Silver Covenant"] = "Серебряный союз",
	["The Sons of Hodir"] = "Сыны Ходира",
	["The Sunreavers"] = "Похитители Солнца",
	["The Taunka"] = "Таунка",
	["The Tillers"] = "Земледельцы",
	["The Violet Eye"] = "Аметистовое Око",
	--[[Translation missing --]]
	--[[ ["The Wardens"] = "The Wardens",--]] 
	--[[Translation missing --]]
	--[[ ["The Wardens (Paragon)"] = "The Wardens (Paragon)",--]] 
	["The Wyrmrest Accord"] = "Драконий союз",
	["Therazane"] = "Теразан",
	["Thorium Brotherhood"] = "Братство Тория",
	["Thrallmar"] = "Траллмар",
	["Thunder Bluff"] = "Громовой Утес",
	["Timbermaw Hold"] = "Древобрюхи",
	["Tina Mudclaw"] = "Тина Грязный Коготь",
	--[[Translation missing --]]
	--[[ ["Tormmok"] = "Tormmok",--]] 
	["Tranquillien"] = "Транквиллион",
	["Tushui Pandaren"] = "Пандарены Тушуй",
	["Undercity"] = "Подгород",
	--[[Translation missing --]]
	--[[ ["Valarjar"] = "Valarjar",--]] 
	--[[Translation missing --]]
	--[[ ["Valarjar (Paragon)"] = "Valarjar (Paragon)",--]] 
	["Valiance Expedition"] = "Экспедиция Отважных",
	--[[Translation missing --]]
	--[[ ["Vivianne"] = "Vivianne",--]] 
	--[[Translation missing --]]
	--[[ ["Vol'jin's Headhunters"] = "Vol'jin's Headhunters",--]] 
	--[[Translation missing --]]
	--[[ ["Vol'jin's Spear"] = "Vol'jin's Spear",--]] 
	["Warsong Offensive"] = "Армия Песни Войны",
	["Warsong Outriders"] = "Всадники Песни Войны",
	["Wildhammer Clan"] = "Клан Громового Молота",
	["Winterfin Retreat"] = "Холодный Плавник",
	["Wintersaber Trainers"] = "Укротители ледопардов",
	--[[Translation missing --]]
	--[[ ["Wrynn's Vanguard"] = "Wrynn's Vanguard",--]] 
	["Zandalar Tribe"] = "Племя Зандалар"
}
elseif GAME_LOCALE == "zhCN" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "熟人",
	["Aeda Brightdawn"] = "艾达·晨光",
	["Akule Riverhorn"] = "阿库勒·河角",
	["Alliance"] = "联盟",
	["Alliance Vanguard"] = "联盟先遣军",
	["Arakkoa Outcasts"] = "鸦人流亡者",
	["Argent Crusade"] = "银色北伐军",
	["Argent Dawn"] = "银色黎明",
	["Argussian Reach"] = "阿古斯防卫军",
	["Argussian Reach (Paragon)"] = "阿古斯防卫军（巅峰）",
	["Armies of Legionfall"] = "抗魔联军",
	["Armies of Legionfall (Paragon)"] = "抗魔联军（巅峰）",
	["Army of the Light"] = "圣光军团",
	["Army of the Light (Paragon)"] = "圣光军团（巅峰）",
	["Ashtongue Deathsworn"] = "灰舌死誓者",
	["Avengers of Hyjal"] = "海加尔复仇者",
	["Baradin's Wardens"] = "巴拉丁典狱官",
	["Barracks Bodyguards"] = "要塞保镖",
	["Best Friend"] = "挚友",
	["Bilgewater Cartel"] = "锈水财阀",
	["Bizmo's Brawlpub"] = "比兹莫搏击俱乐部",
	["Bloodsail Buccaneers"] = "血帆海盗",
	["Booty Bay"] = "藏宝海湾",
	["Brawl'gar Arena"] = "搏击竞技场",
	["Brood of Nozdormu"] = "诺兹多姆的子嗣",
	["Buddy"] = "哥们",
	["Cenarion Circle"] = "塞纳里奥议会",
	["Cenarion Expedition"] = "塞纳里奥远征队",
	["Chee Chee"] = "吱吱",
	["Corbyn"] = "科尔宾",
	["Council of Exarchs"] = "主教议会",
	["Court of Farondis"] = "法罗迪斯宫廷",
	["Court of Farondis (Paragon)"] = "法罗迪斯宫廷（巅峰）",
	["Darkmoon Faire"] = "暗月马戏团",
	["Darkspear Trolls"] = "暗矛巨魔",
	["Darnassus"] = "达纳苏斯",
	["Defender Illona"] = "防御者艾萝娜",
	["Delvar Ironfist"] = "德尔瓦·铁拳",
	["Dominance Offensive"] = "统御先锋军",
	["Dragonmaw Clan"] = "龙喉氏族",
	["Dreamweavers"] = "织梦者",
	["Dreamweavers (Paragon)"] = "织梦者（巅峰）",
	["Ella"] = "艾拉",
	["Everlook"] = "永望镇",
	["Exalted"] = "崇拜",
	["Exodar"] = "埃索达",
	["Explorers' League"] = "探险者协会",
	["Farmer Fung"] = "农夫老方",
	["Fish Fellreed"] = "玉儿·采苇",
	["Forest Hozen"] = "森林猢狲",
	["Frenzyheart Tribe"] = "狂心氏族",
	["Friend"] = "朋友",
	["Friendly"] = "友善",
	["Frostwolf Clan"] = "霜狼氏族",
	["Frostwolf Orcs"] = "霜狼兽人",
	["Gadgetzan"] = "加基森",
	["Gelkis Clan Centaur"] = "吉尔吉斯半人马",
	["Gilnean Survivors"] = "吉尔尼斯幸存者",
	["Gilneas"] = "吉尔尼斯",
	["Gina Mudclaw"] = "吉娜·泥爪",
	["Gnomeregan"] = "诺莫瑞根",
	["Gnomeregan Exiles"] = "诺莫瑞根流亡者",
	["Golden Lotus"] = "金莲教",
	["Good Friend"] = "好友",
	["Guardians of Hyjal"] = "海加尔守护者",
	["Guild"] = "公会",
	["Hand of the Prophet"] = "先知之手",
	["Haohan Mudclaw"] = "郝瀚·泥爪",
	["Hellscream's Reach"] = "地狱咆哮近卫军",
	["Highmountain Tribe"] = "高岭部族",
	["Highmountain Tribe (Paragon)"] = "高岭部族（巅峰）",
	["Honor Hold"] = "荣耀堡",
	["Honored"] = "尊敬",
	["Horde"] = "部落",
	["Horde Expedition"] = "部落先遣军",
	["Huojin Pandaren"] = "火金派熊猫人",
	["Hydraxian Waterlords"] = "海达希亚水元素",
	["Illidari"] = "伊利达雷",
	["Ilyssia of the Waters"] = "“活水”伊丽西娅",
	["Impus"] = "英帕斯",
	["Ironforge"] = "铁炉堡",
	["Jandvik Vrykul"] = "贾德维克维库人",
	["Jogu the Drunk"] = "醉鬼贾古",
	["Keeper Raynae"] = "守护者蕾娜",
	["Keepers of Time"] = "时光守护者",
	["Kirin Tor"] = "肯瑞托",
	["Kirin Tor Offensive"] = "肯瑞托远征军",
	["Knights of the Ebon Blade"] = "黑锋骑士团",
	["Kurenai"] = "库雷尼",
	["Laughing Skull Orcs"] = "嘲颅兽人",
	["Leorajh"] = "利奥拉",
	["Lower City"] = "贫民窟",
	["Magram Clan Centaur"] = "玛格拉姆半人马",
	["Moon Guard"] = "月之守卫",
	["Nat Pagle"] = "纳特·帕格",
	["Netherwing"] = "灵翼之龙",
	["Neutral"] = "中立",
	["Nomi"] = "诺米",
	["Ogri'la"] = "奥格瑞拉",
	["Old Hillpaw"] = "老农山掌",
	["Operation: Aardvark"] = "阿德瓦克讨伐军",
	["Operation: Shieldwall"] = "神盾守备军",
	["Order of the Awakened"] = "觉醒教派",
	["Order of the Cloud Serpent"] = "云端翔龙骑士团",
	["Orgrimmar"] = "奥格瑞玛",
	["Pearlfin Jinyu"] = "珠鳍锦鱼人",
	["Ramkahen"] = "拉穆卡恒",
	["Rank 1"] = "1级",
	["Rank 2"] = "2级",
	["Rank 3"] = "3级",
	["Rank 4"] = "4级",
	["Rank 5"] = "5级",
	["Rank 6"] = "6级",
	["Rank 7"] = "7级",
	["Rank 8"] = "8级",
	["Ratchet"] = "棘齿城",
	["Ravenholdt"] = "拉文霍德",
	["Revered"] = "崇敬",
	["Shado-Pan"] = "影踪派",
	["Shado-Pan Assault"] = "影踪突袭营",
	["Shadowmoon Exiles"] = "影月流亡者",
	["Sha'leth"] = "莎乐丝",
	["Shang Xi's Academy"] = "尚喜武院",
	["Sha'tari Defense"] = "沙塔尔防御者",
	["Sha'tari Skyguard"] = "沙塔尔天空卫士",
	["Shattered Sun Offensive"] = "破碎残阳",
	["Shen'dralar"] = "辛德拉",
	["Sho"] = "阿烁",
	["Silvermoon City"] = "银月城",
	["Silverwing Sentinels"] = "银翼哨兵",
	["Sporeggar"] = "孢子村",
	["Steamwheedle Draenor Expedition"] = "热砂港德拉诺探险队",
	["Steamwheedle Preservation Society"] = "热砂保护协会",
	["Stormpike Guard"] = "雷矛卫队",
	["Stormwind"] = "暴风城",
	["Stranger"] = "陌生人",
	["Sunreaver Onslaught"] = "夺日者先锋军",
	["Syndicate"] = "辛迪加",
	["Talonpriest Ishaal"] = "鸦爪祭司伊沙尔",
	["The Aldor"] = "奥尔多",
	["The Anglers"] = "垂钓翁",
	["The Ashen Verdict"] = "灰烬审判军",
	["The August Celestials"] = "至尊天神",
	["The Black Prince"] = "黑王子",
	["The Brewmasters"] = "酒仙会",
	["The Consortium"] = "星界财团",
	["The Defilers"] = "污染者",
	["The Earthen Ring"] = "大地之环",
	["The First Responders"] = "急救队",
	["The Frostborn"] = "霜脉矮人",
	["The Hand of Vengeance"] = "复仇之手",
	["The Kalu'ak"] = "卡鲁亚克",
	["The Klaxxi"] = "卡拉克西",
	["The League of Arathor"] = "阿拉索联军",
	["The Lorewalkers"] = "游学者",
	["The Mag'har"] = "玛格汉",
	["The Nightfallen"] = "堕夜精灵",
	["The Nightfallen (Paragon)"] = "堕夜精灵（巅峰）",
	["The Oracles"] = "神谕者",
	["The Saberstalkers"] = "刃牙追猎者",
	["The Scale of the Sands"] = "流沙之鳞",
	["The Scryers"] = "占星者",
	["The Sha'tar"] = "沙塔尔",
	["The Silver Covenant"] = "银色盟约",
	["The Sons of Hodir"] = "霍迪尔之子",
	["The Sunreavers"] = "夺日者",
	["The Taunka"] = "牦牛人",
	["The Tillers"] = "阡陌客",
	["The Violet Eye"] = "紫罗兰之眼",
	["The Wardens"] = "守望者",
	["The Wardens (Paragon)"] = "守望者（巅峰）",
	["The Wyrmrest Accord"] = "龙眠联军",
	["Therazane"] = "塞拉赞恩",
	["Thorium Brotherhood"] = "瑟银兄弟会",
	["Thrallmar"] = "萨尔玛",
	["Thunder Bluff"] = "雷霆崖",
	["Timbermaw Hold"] = "木喉要塞",
	["Tina Mudclaw"] = "迪娜·泥爪",
	["Tormmok"] = "托莫克",
	["Tranquillien"] = "塔奎林",
	["Tushui Pandaren"] = "土水派熊猫人",
	["Undercity"] = "幽暗城",
	["Valarjar"] = "瓦拉加尔",
	["Valarjar (Paragon)"] = "瓦拉加尔（巅峰）",
	["Valiance Expedition"] = "无畏远征军",
	["Vivianne"] = "薇薇安",
	["Vol'jin's Headhunters"] = "沃金之锋",
	["Vol'jin's Spear"] = "沃金之矛",
	["Warsong Offensive"] = "战歌远征军",
	["Warsong Outriders"] = "战歌侦察骑兵",
	["Wildhammer Clan"] = "蛮锤部族",
	["Winterfin Retreat"] = "冬鳞避难所",
	["Wintersaber Trainers"] = "冬刃豹训练师",
	["Wrynn's Vanguard"] = "乌瑞恩先锋军",
	["Zandalar Tribe"] = "赞达拉部族"
}
elseif GAME_LOCALE == "zhTW" then
	lib:SetCurrentTranslations {
	["Acquaintance"] = "熟識",
	["Aeda Brightdawn"] = "愛伊達‧明曦",
	["Akule Riverhorn"] = "阿庫爾‧河角",
	["Alliance"] = "聯盟",
	["Alliance Vanguard"] = "聯盟先鋒",
	["Arakkoa Outcasts"] = "阿拉卡流亡者",
	["Argent Crusade"] = "銀白十字軍",
	["Argent Dawn"] = "銀色黎明",
	["Argussian Reach"] = "阿古斯守望",
	["Argussian Reach (Paragon)"] = "阿古斯守望(典範)",
	["Armies of Legionfall"] = "軍團之殞部隊",
	["Armies of Legionfall (Paragon)"] = "軍團之殞部隊(典範)",
	["Army of the Light"] = "聖光軍團",
	["Army of the Light (Paragon)"] = "聖光軍團(典範)",
	["Ashtongue Deathsworn"] = "灰舌死亡誓言者",
	["Avengers of Hyjal"] = "海加爾復仇者",
	["Baradin's Wardens"] = "巴拉丁鐵衛",
	["Barracks Bodyguards"] = "兵營保鏢",
	["Best Friend"] = "最好的朋友",
	["Bilgewater Cartel"] = "污水企業聯合",
	["Bizmo's Brawlpub"] = "畢茲摩鬥陣俱樂部",
	["Bloodsail Buccaneers"] = "血帆海盜",
	["Booty Bay"] = "藏寶海灣",
	["Brawl'gar Arena"] = "鬥陣競技場",
	["Brood of Nozdormu"] = "諾茲多姆的子嗣",
	["Buddy"] = "夥伴",
	["Cenarion Circle"] = "塞納里奧議會",
	["Cenarion Expedition"] = "塞納里奧遠征隊",
	["Chee Chee"] = "奇奇",
	["Corbyn"] = "柯爾賓",
	["Council of Exarchs"] = "主教議會",
	["Court of Farondis"] = "法隆迪斯廷衛",
	["Court of Farondis (Paragon)"] = "法隆迪斯廷衛(典範)",
	["Darkmoon Faire"] = "暗月馬戲團",
	["Darkspear Trolls"] = "暗矛食人妖",
	["Darnassus"] = "達納蘇斯",
	["Defender Illona"] = "防衛者伊蘿娜",
	["Delvar Ironfist"] = "德爾瓦‧鐵拳",
	["Dominance Offensive"] = "制霸先鋒軍",
	["Dragonmaw Clan"] = "龍喉氏族",
	["Dreamweavers"] = "織夢者",
	["Dreamweavers (Paragon)"] = "織夢者(典範)",
	["Ella"] = "艾拉",
	["Everlook"] = "永望鎮",
	["Exalted"] = "崇拜",
	["Exodar"] = "艾克索達",
	["Explorers' League"] = "探險者協會",
	["Farmer Fung"] = "農夫老豐",
	["Fish Fellreed"] = "小魚·跌蘆",
	["Forest Hozen"] = "森林猴人",
	["Frenzyheart Tribe"] = "狂心部族",
	["Friend"] = "朋友",
	["Friendly"] = "友方",
	["Frostwolf Clan"] = "霜狼氏族",
	["Frostwolf Orcs"] = "霜狼獸人",
	["Gadgetzan"] = "加基森",
	["Gelkis Clan Centaur"] = "吉爾吉斯半人馬",
	["Gilnean Survivors"] = "吉爾尼斯倖存者",
	["Gilneas"] = "吉爾尼斯",
	["Gina Mudclaw"] = "吉娜·泥爪",
	["Gnomeregan"] = "諾姆瑞根",
	["Gnomeregan Exiles"] = "諾姆瑞根流亡者",
	["Golden Lotus"] = "金蓮會",
	["Good Friend"] = "好朋友",
	["Guardians of Hyjal"] = "海加爾守護者",
	["Guild"] = "公會",
	["Hand of the Prophet"] = "預言者之手",
	["Haohan Mudclaw"] = "好漢·泥爪",
	["Hellscream's Reach"] = "地獄吼先鋒",
	["Highmountain Tribe"] = "高嶺部族",
	["Highmountain Tribe (Paragon)"] = "高嶺部族(典範)",
	["Honor Hold"] = "榮譽堡",
	["Honored"] = "尊敬",
	["Horde"] = "部落",
	["Horde Expedition"] = "部落遠征軍",
	["Huojin Pandaren"] = "火金熊貓人",
	["Hydraxian Waterlords"] = "海達希亞水元素",
	["Illidari"] = "伊利達瑞",
	["Ilyssia of the Waters"] = "『水之守衛者』伊莉西亞",
	["Impus"] = "英普斯",
	["Ironforge"] = "鐵爐堡",
	["Jandvik Vrykul"] = "詹德維克維酷人",
	["Jogu the Drunk"] = "『酒鬼』酒骨",
	["Keeper Raynae"] = "守護者蕾奈",
	["Keepers of Time"] = "時光守望者",
	["Kirin Tor"] = "祈倫托",
	["Kirin Tor Offensive"] = "祈倫托先遣軍",
	["Knights of the Ebon Blade"] = "黯刃騎士團",
	["Kurenai"] = "卡爾奈",
	["Laughing Skull Orcs"] = "獰笑骷髏獸人",
	["Leorajh"] = "雷歐拉杰",
	["Lower City"] = "陰鬱城",
	["Magram Clan Centaur"] = "瑪格拉姆半人馬",
	["Moon Guard"] = "月之守衛",
	["Nat Pagle"] = "納特·帕格",
	["Netherwing"] = "虛空之翼",
	["Neutral"] = "中立",
	["Nomi"] = "糯米",
	["Ogri'la"] = "歐格利拉",
	["Old Hillpaw"] = "老丘爪",
	["Operation: Aardvark"] = "土豚行動",
	["Operation: Shieldwall"] = "鐵壁特遣行動",
	["Order of the Awakened"] = "覺醒者衛隊",
	["Order of the Cloud Serpent"] = "雲蛟衛",
	["Orgrimmar"] = "奧格瑪",
	["Pearlfin Jinyu"] = "珠鰭錦魚人",
	["Ramkahen"] = "蘭姆卡韓",
	["Rank 1"] = "第1階",
	["Rank 2"] = "第2階",
	["Rank 3"] = "第3階",
	["Rank 4"] = "第4階",
	["Rank 5"] = "第5階",
	["Rank 6"] = "第6階",
	["Rank 7"] = "第7階",
	["Rank 8"] = "第8階",
	["Ratchet"] = "棘齒城",
	["Ravenholdt"] = "拉文霍德",
	["Revered"] = "崇敬",
	["Shado-Pan"] = "影潘",
	["Shado-Pan Assault"] = "影潘之襲",
	["Shadowmoon Exiles"] = "影月流亡者",
	["Sha'leth"] = "夏蕾斯",
	["Shang Xi's Academy"] = "尚羲學院",
	["Sha'tari Defense"] = "撒塔斯守軍",
	["Sha'tari Skyguard"] = "薩塔禦天者",
	["Shattered Sun Offensive"] = "破碎之日進攻部隊",
	["Shen'dralar"] = "辛德拉",
	["Sho"] = "阿秀",
	["Silvermoon City"] = "銀月城",
	["Silverwing Sentinels"] = "銀翼哨兵",
	["Sporeggar"] = "斯博格爾",
	["Steamwheedle Draenor Expedition"] = "熱砂德拉諾遠征隊",
	["Steamwheedle Preservation Society"] = "熱砂保護協會",
	["Stormpike Guard"] = "雷矛衛隊",
	["Stormwind"] = "暴風城",
	["Stranger"] = "陌生人",
	["Sunreaver Onslaught"] = "奪日者先鋒軍",
	["Syndicate"] = "辛迪加",
	["Talonpriest Ishaal"] = "魔爪祭司艾夏歐",
	["The Aldor"] = "奧多爾",
	["The Anglers"] = "釣手隊",
	["The Ashen Verdict"] = "灰燼裁決軍",
	["The August Celestials"] = "聖獸天尊",
	["The Black Prince"] = "黑龍王子",
	["The Brewmasters"] = "釀酒大師",
	["The Consortium"] = "聯合團",
	["The Defilers"] = "污染者",
	["The Earthen Ring"] = "陶土議會",
	["The First Responders"] = "第一應援者",
	["The Frostborn"] = "霜誕矮人",
	["The Hand of Vengeance"] = "復仇之手",
	["The Kalu'ak"] = "卡魯耶克",
	["The Klaxxi"] = "卡拉西",
	["The League of Arathor"] = "阿拉索聯軍",
	["The Lorewalkers"] = "博學行者",
	["The Mag'har"] = "瑪格哈",
	["The Nightfallen"] = "夜落精靈",
	["The Nightfallen (Paragon)"] = "夜落精靈(典範)",
	["The Oracles"] = "神諭者",
	["The Saberstalkers"] = "劍齒潛獵者",
	["The Scale of the Sands"] = "流沙之鱗",
	["The Scryers"] = "占卜者",
	["The Sha'tar"] = "薩塔",
	["The Silver Covenant"] = "白銀誓盟",
	["The Sons of Hodir"] = "霍迪爾之子",
	["The Sunreavers"] = "奪日者",
	["The Taunka"] = "坦卡族",
	["The Tillers"] = "耕者工會",
	["The Violet Eye"] = "紫羅蘭之眼",
	["The Wardens"] = "看守者",
	["The Wardens (Paragon)"] = "看守者(典範)",
	["The Wyrmrest Accord"] = "龍眠協調者",
	["Therazane"] = "瑟拉贊恩",
	["Thorium Brotherhood"] = "瑟銀兄弟會",
	["Thrallmar"] = "索爾瑪",
	["Thunder Bluff"] = "雷霆崖",
	["Timbermaw Hold"] = "木喉要塞",
	["Tina Mudclaw"] = "蒂娜·泥爪",
	["Tormmok"] = "托爾瑪克",
	["Tranquillien"] = "安寧地",
	["Tushui Pandaren"] = "土水熊貓人",
	["Undercity"] = "幽暗城",
	["Valarjar"] = "華爾拉亞",
	["Valarjar (Paragon)"] = "華爾拉亞(典範)",
	["Valiance Expedition"] = "驍勇遠征軍",
	["Vivianne"] = "薇薇安妮",
	["Vol'jin's Headhunters"] = "沃金獵頭者",
	["Vol'jin's Spear"] = "沃金之矛",
	["Warsong Offensive"] = "戰歌進攻部隊",
	["Warsong Outriders"] = "戰歌先遣騎",
	["Wildhammer Clan"] = "蠻錘氏族",
	["Winterfin Retreat"] = "冬鰭避居地",
	["Wintersaber Trainers"] = "冬刃豹訓練師",
	["Wrynn's Vanguard"] = "烏瑞恩先鋒",
	["Zandalar Tribe"] = "贊達拉部族"
}
else
	error(("%s: Locale %q not supported"):format(MAJOR_VERSION, GAME_LOCALE))
end
