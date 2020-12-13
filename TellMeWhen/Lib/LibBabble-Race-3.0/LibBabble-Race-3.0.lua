--[[
Name: LibBabble-Race-3.0
Revision: $Rev: 105 $
Maintainers: ckknight, nevcairiel, Ackis
Website: http://www.wowace.com/projects/libbabble-race-3-0/
Dependencies: None
License: MIT
]]

local MAJOR_VERSION = "LibBabble-Race-3.0"
local MINOR_VERSION = 90000 + tonumber(("$Rev: 105 $"):match("%d+"))

if not LibStub then error(MAJOR_VERSION .. " requires LibStub.") end
local lib = LibStub("LibBabble-3.0"):New(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

local GAME_LOCALE = GetLocale()

lib:SetBaseTranslations {
	["Blood Elf"] = "Blood Elf",
	["Blood elves"] = "Blood elves",
	["Dark Iron Dwarf"] = "Dark Iron Dwarf",
	["Dark Iron Dwarves"] = "Dark Iron Dwarves",
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Dwarf",
	["Dwarves"] = "Dwarves",
	["Felguard"] = "Felguard",
	["Felhunter"] = "Felhunter",
	["Gnome"] = "Gnome",
	["Gnomes"] = "Gnomes",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	["Highmountain Tauren"] = "Highmountain Tauren",
	["Highmountain Tauren_PL"] = "Highmountain Tauren",
	["Human"] = "Human",
	["Humans"] = "Humans",
	["Imp"] = "Imp",
	["Kul Tiran"] = "Kul Tiran",
	["Kul Tirans"] = "Kul Tirans",
	["Lightforged Draenei"] = "Lightforged Draenei",
	["Lightforged Draenei_PL"] = "Lightforged Draenei",
	["Mag'har Orc"] = "Mag'har Orc",
	["Mag'har Orcs"] = "Mag'har Orcs",
	["Night Elf"] = "Night Elf",
	["Night elves"] = "Night elves",
	["Nightborne"] = "Nightborne",
	["Nightborne_PL"] = "Nightborne",
	["Orc"] = "Orc",
	["Orcs"] = "Orcs",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Succubus",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Troll",
	["Trolls"] = "Trolls",
	["Undead"] = "Undead",
	["Undead_PL"] = "Undead",
	["Void Elf"] = "Void Elf",
	["Void elves"] = "Void elves",
	["Voidwalker"] = "Voidwalker",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgen",
	["Zandalari Troll"] = "Zandalari Troll",
	["Zandalari Trolls"] = "Zandalari Trolls"
}

if GAME_LOCALE == "enUS" then
	lib:SetCurrentTranslations(true)

elseif GAME_LOCALE == "deDE" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Blutelf",
	["Blood elves"] = "Blutelfen",
	["Dark Iron Dwarf"] = "Dunkeleisenzwerg",
	["Dark Iron Dwarves"] = "Dunkeleisenzwerge",
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Zwerg",
	["Dwarves"] = "Zwerge",
	["Felguard"] = "Teufelswache",
	["Felhunter"] = "Teufelsjäger",
	["Gnome"] = "Gnom",
	["Gnomes"] = "Gnome",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	["Highmountain Tauren"] = "Hochbergtauren",
	["Highmountain Tauren_PL"] = "Hochbergtauren",
	["Human"] = "Mensch",
	["Humans"] = "Menschen",
	["Imp"] = "Wichtel",
	--[[Translation missing --]]
	--[[ ["Kul Tiran"] = "Kul Tiran",--]] 
	--[[Translation missing --]]
	--[[ ["Kul Tirans"] = "Kul Tirans",--]] 
	["Lightforged Draenei"] = "Lichtgeschmiedete Draenei",
	["Lightforged Draenei_PL"] = "Lichtgeschmiedete Draenei",
	["Mag'har Orc"] = "Mag'har Ork",
	["Mag'har Orcs"] = "Mag'har Orks",
	["Night Elf"] = "Nachtelf",
	["Night elves"] = "Nachtelfen",
	["Nightborne"] = "Nachtgeboren",
	["Nightborne_PL"] = "Nachtgeborene",
	["Orc"] = "Ork",
	["Orcs"] = "Orks",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Sukkubus",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Troll",
	["Trolls"] = "Trolle",
	["Undead"] = "Untoter",
	["Undead_PL"] = "Untote",
	["Void Elf"] = "Leerenelf",
	["Void elves"] = "Leerenelfen",
	["Voidwalker"] = "Leerwandler",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgen",
	["Zandalari Troll"] = "Zandalari Troll",
	["Zandalari Trolls"] = "Zandalari Trolle"
}
elseif GAME_LOCALE == "frFR" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfe de sang",
	["Blood elves"] = "Elfes de sang",
	["Dark Iron Dwarf"] = "Nain sombrefer",
	["Dark Iron Dwarves"] = "Nains sombrefer",
	["Draenei"] = "Draeneï",
	["Draenei_PL"] = "Draeneï",
	["Dwarf"] = "Nain",
	["Dwarves"] = "Nains",
	["Felguard"] = "Gangregarde",
	["Felhunter"] = "Chasseur corrompu",
	["Gnome"] = "Gnome",
	["Gnomes"] = "Gnomes",
	["Goblin"] = "Gobelin",
	["Goblins"] = "Gobelins",
	["Highmountain Tauren"] = "Tauren de Haut-Roc",
	["Highmountain Tauren_PL"] = "Taurens de Haut-Roc",
	["Human"] = "Humain",
	["Humans"] = "Humains",
	["Imp"] = "Diablotin",
	--[[Translation missing --]]
	--[[ ["Kul Tiran"] = "Kul Tiran",--]] 
	--[[Translation missing --]]
	--[[ ["Kul Tirans"] = "Kul Tirans",--]] 
	["Lightforged Draenei"] = "Draeneï sancteforge",
	--[[Translation missing --]]
	--[[ ["Lightforged Draenei_PL"] = "Lightforged Draenei",--]] 
	--[[Translation missing --]]
	--[[ ["Mag'har Orc"] = "Mag'har Orc",--]] 
	--[[Translation missing --]]
	--[[ ["Mag'har Orcs"] = "Mag'har Orcs",--]] 
	["Night Elf"] = "Elfe de la nuit",
	["Night elves"] = "Elfes de la nuit",
	["Nightborne"] = "Sacrenuit",
	--[[Translation missing --]]
	--[[ ["Nightborne_PL"] = "Nightborne",--]] 
	["Orc"] = "Orc",
	["Orcs"] = "Orcs",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Succube",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Taurens",
	["Troll"] = "Troll",
	["Trolls"] = "Trolls",
	["Undead"] = "Mort-vivant",
	["Undead_PL"] = "Morts-vivants",
	["Void Elf"] = "Elfe du Vide",
	["Void elves"] = "Elfes du Vide",
	["Voidwalker"] = "Marcheur du Vide",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgens",
	["Zandalari Troll"] = "Troll zandalari",
	["Zandalari Trolls"] = "Trolls zandalari"
}
elseif GAME_LOCALE == "koKR" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "블러드 엘프",
	["Blood elves"] = "블러드 엘프",
	["Dark Iron Dwarf"] = "검은무쇠 드워프",
	["Dark Iron Dwarves"] = "검은무쇠 드워프",
	["Draenei"] = "드레나이",
	["Draenei_PL"] = "드레나이",
	["Dwarf"] = "드워프",
	["Dwarves"] = "드워프",
	["Felguard"] = "지옥수호병",
	["Felhunter"] = "지옥사냥개",
	["Gnome"] = "노움",
	["Gnomes"] = "노움",
	["Goblin"] = "고블린",
	["Goblins"] = "고블린",
	["Highmountain Tauren"] = "높은산 타우렌",
	["Highmountain Tauren_PL"] = "높은산 타우렌",
	["Human"] = "인간",
	["Humans"] = "인간",
	["Imp"] = "임프",
	--[[Translation missing --]]
	--[[ ["Kul Tiran"] = "Kul Tiran",--]] 
	--[[Translation missing --]]
	--[[ ["Kul Tirans"] = "Kul Tirans",--]] 
	["Lightforged Draenei"] = "빛벼림 드레나이",
	["Lightforged Draenei_PL"] = "빛벼림 드레나이",
	--[[Translation missing --]]
	--[[ ["Mag'har Orc"] = "Mag'har Orc",--]] 
	--[[Translation missing --]]
	--[[ ["Mag'har Orcs"] = "Mag'har Orcs",--]] 
	["Night Elf"] = "나이트 엘프",
	["Night elves"] = "나이트 엘프",
	["Nightborne"] = "나이트본",
	["Nightborne_PL"] = "나이트본",
	["Orc"] = "오크",
	["Orcs"] = "오크",
	["Pandaren"] = "판다렌",
	["Pandaren_PL"] = "판다렌",
	["Succubus"] = "서큐버스",
	["Tauren"] = "타우렌",
	["Tauren_PL"] = "타우렌",
	["Troll"] = "트롤",
	["Trolls"] = "트롤",
	["Undead"] = "언데드",
	["Undead_PL"] = "언데드",
	["Void Elf"] = "공허 엘프",
	["Void elves"] = "공허 엘프",
	["Voidwalker"] = "보이드워커",
	["Worgen"] = "늑대인간",
	["Worgen_PL"] = "늑대인간",
	["Zandalari Troll"] = "잔달라 트롤",
	["Zandalari Trolls"] = "잔달라 트롤"
}
elseif GAME_LOCALE == "esES" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfo de sangre",
	["Blood elves"] = "Elfos de sangre",
	--[[Translation missing --]]
	--[[ ["Dark Iron Dwarf"] = "Dark Iron Dwarf",--]] 
	--[[Translation missing --]]
	--[[ ["Dark Iron Dwarves"] = "Dark Iron Dwarves",--]] 
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Enano",
	["Dwarves"] = "Enanos",
	["Felguard"] = "Guardia vil",
	["Felhunter"] = "Manáfago",
	["Gnome"] = "Gnomo",
	["Gnomes"] = "Gnomos",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	--[[Translation missing --]]
	--[[ ["Highmountain Tauren"] = "Highmountain Tauren",--]] 
	--[[Translation missing --]]
	--[[ ["Highmountain Tauren_PL"] = "Highmountain Tauren",--]] 
	["Human"] = "Humano",
	["Humans"] = "Humanos",
	["Imp"] = "Diablillo",
	--[[Translation missing --]]
	--[[ ["Kul Tiran"] = "Kul Tiran",--]] 
	--[[Translation missing --]]
	--[[ ["Kul Tirans"] = "Kul Tirans",--]] 
	--[[Translation missing --]]
	--[[ ["Lightforged Draenei"] = "Lightforged Draenei",--]] 
	--[[Translation missing --]]
	--[[ ["Lightforged Draenei_PL"] = "Lightforged Draenei",--]] 
	--[[Translation missing --]]
	--[[ ["Mag'har Orc"] = "Mag'har Orc",--]] 
	--[[Translation missing --]]
	--[[ ["Mag'har Orcs"] = "Mag'har Orcs",--]] 
	["Night Elf"] = "Elfo de la noche",
	["Night elves"] = "Elfos de la noche",
	--[[Translation missing --]]
	--[[ ["Nightborne"] = "Nightborne",--]] 
	--[[Translation missing --]]
	--[[ ["Nightborne_PL"] = "Nightborne",--]] 
	["Orc"] = "Orco",
	["Orcs"] = "Orcos",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Súcubo",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Trol",
	["Trolls"] = "Trols",
	["Undead"] = "No-muerto",
	["Undead_PL"] = "No-muertos",
	--[[Translation missing --]]
	--[[ ["Void Elf"] = "Void Elf",--]] 
	--[[Translation missing --]]
	--[[ ["Void elves"] = "Void elves",--]] 
	["Voidwalker"] = "Abisario",
	["Worgen"] = "Huargen",
	["Worgen_PL"] = "Huargen",
	--[[Translation missing --]]
	--[[ ["Zandalari Troll"] = "Zandalari Troll",--]] 
	--[[Translation missing --]]
	--[[ ["Zandalari Trolls"] = "Zandalari Trolls",--]]
}
elseif GAME_LOCALE == "esMX" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfo de Sangre",
	["Blood elves"] = "Elfos de sangre",
	--[[Translation missing --]]
	--[[ ["Dark Iron Dwarf"] = "Dark Iron Dwarf",--]] 
	--[[Translation missing --]]
	--[[ ["Dark Iron Dwarves"] = "Dark Iron Dwarves",--]] 
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Enano",
	["Dwarves"] = "Enanos",
	["Felguard"] = "Guardia vil",
	["Felhunter"] = "Manáfago",
	["Gnome"] = "Gnomo",
	["Gnomes"] = "Gnomos",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	--[[Translation missing --]]
	--[[ ["Highmountain Tauren"] = "Highmountain Tauren",--]] 
	--[[Translation missing --]]
	--[[ ["Highmountain Tauren_PL"] = "Highmountain Tauren",--]] 
	["Human"] = "Humano",
	["Humans"] = "Humanos",
	["Imp"] = "Diablillo",
	--[[Translation missing --]]
	--[[ ["Kul Tiran"] = "Kul Tiran",--]] 
	--[[Translation missing --]]
	--[[ ["Kul Tirans"] = "Kul Tirans",--]] 
	--[[Translation missing --]]
	--[[ ["Lightforged Draenei"] = "Lightforged Draenei",--]] 
	--[[Translation missing --]]
	--[[ ["Lightforged Draenei_PL"] = "Lightforged Draenei",--]] 
	--[[Translation missing --]]
	--[[ ["Mag'har Orc"] = "Mag'har Orc",--]] 
	--[[Translation missing --]]
	--[[ ["Mag'har Orcs"] = "Mag'har Orcs",--]] 
	["Night Elf"] = "Elfo de la noche",
	["Night elves"] = "Elfos de la noche",
	--[[Translation missing --]]
	--[[ ["Nightborne"] = "Nightborne",--]] 
	--[[Translation missing --]]
	--[[ ["Nightborne_PL"] = "Nightborne",--]] 
	["Orc"] = "Orco",
	["Orcs"] = "Orcos",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Súcubo",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Trol",
	["Trolls"] = "Trols",
	["Undead"] = "No-muerto",
	["Undead_PL"] = "No-muertos",
	--[[Translation missing --]]
	--[[ ["Void Elf"] = "Void Elf",--]] 
	--[[Translation missing --]]
	--[[ ["Void elves"] = "Void elves",--]] 
	["Voidwalker"] = "Abisario",
	["Worgen"] = "Huargen",
	["Worgen_PL"] = "Huargen",
	--[[Translation missing --]]
	--[[ ["Zandalari Troll"] = "Zandalari Troll",--]] 
	--[[Translation missing --]]
	--[[ ["Zandalari Trolls"] = "Zandalari Trolls",--]]
}
elseif GAME_LOCALE == "ptBR" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfo Sangrento",
	["Blood elves"] = "Elfos Sangrentos",
	--[[Translation missing --]]
	--[[ ["Dark Iron Dwarf"] = "Dark Iron Dwarf",--]] 
	--[[Translation missing --]]
	--[[ ["Dark Iron Dwarves"] = "Dark Iron Dwarves",--]] 
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draeneis",
	["Dwarf"] = "Anão",
	["Dwarves"] = "Anões",
	["Felguard"] = "Guarda Vil",
	["Felhunter"] = "Caçador Vil",
	["Gnome"] = "Gnomo",
	["Gnomes"] = "Gnomos",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	--[[Translation missing --]]
	--[[ ["Highmountain Tauren"] = "Highmountain Tauren",--]] 
	--[[Translation missing --]]
	--[[ ["Highmountain Tauren_PL"] = "Highmountain Tauren",--]] 
	["Human"] = "Humano",
	["Humans"] = "Humanos",
	["Imp"] = "Diabrete",
	--[[Translation missing --]]
	--[[ ["Kul Tiran"] = "Kul Tiran",--]] 
	--[[Translation missing --]]
	--[[ ["Kul Tirans"] = "Kul Tirans",--]] 
	--[[Translation missing --]]
	--[[ ["Lightforged Draenei"] = "Lightforged Draenei",--]] 
	--[[Translation missing --]]
	--[[ ["Lightforged Draenei_PL"] = "Lightforged Draenei",--]] 
	--[[Translation missing --]]
	--[[ ["Mag'har Orc"] = "Mag'har Orc",--]] 
	--[[Translation missing --]]
	--[[ ["Mag'har Orcs"] = "Mag'har Orcs",--]] 
	["Night Elf"] = "Elfo Noturno",
	["Night elves"] = "Elfos Noturnos",
	--[[Translation missing --]]
	--[[ ["Nightborne"] = "Nightborne",--]] 
	--[[Translation missing --]]
	--[[ ["Nightborne_PL"] = "Nightborne",--]] 
	["Orc"] = "Orc",
	["Orcs"] = "Orcs",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandarens",
	["Succubus"] = "Súcubo",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Taurens",
	["Troll"] = "Troll",
	["Trolls"] = "Trolls",
	["Undead"] = "Renegado",
	["Undead_PL"] = "Renegados",
	--[[Translation missing --]]
	--[[ ["Void Elf"] = "Void Elf",--]] 
	--[[Translation missing --]]
	--[[ ["Void elves"] = "Void elves",--]] 
	["Voidwalker"] = "Emissário do Caos",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgens",
	--[[Translation missing --]]
	--[[ ["Zandalari Troll"] = "Zandalari Troll",--]] 
	--[[Translation missing --]]
	--[[ ["Zandalari Trolls"] = "Zandalari Trolls",--]]
}
elseif GAME_LOCALE == "itIT" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Elfo del Sangue",
	["Blood elves"] = "Elfi del Sangue",
	["Dark Iron Dwarf"] = "Nano Ferroscuro",
	["Dark Iron Dwarves"] = "Nani Ferroscuro",
	["Draenei"] = "Draenei",
	["Draenei_PL"] = "Draenei",
	["Dwarf"] = "Nano",
	["Dwarves"] = "Nani",
	["Felguard"] = "Vilguardiano",
	["Felhunter"] = "Vilsegugio",
	["Gnome"] = "Gnomo",
	["Gnomes"] = "Gnomi",
	["Goblin"] = "Goblin",
	["Goblins"] = "Goblins",
	["Highmountain Tauren"] = "Tauren di Alto Monte",
	["Highmountain Tauren_PL"] = "Tauren di Alto Monte",
	["Human"] = "Umano",
	["Humans"] = "Umani",
	["Imp"] = "Folletto",
	["Kul Tiran"] = "Kul Tirano",
	["Kul Tirans"] = "Kul Tirani",
	["Lightforged Draenei"] = "Draenei Forgialuce",
	["Lightforged Draenei_PL"] = "Draenei Forgialuce",
	["Mag'har Orc"] = "Orco Mag'har",
	["Mag'har Orcs"] = "Orchi Mag'har",
	["Night Elf"] = "Elfo della Notte",
	["Night elves"] = "Elfi della Notte",
	["Nightborne"] = "Nobile Oscuro",
	["Nightborne_PL"] = "Nobili Oscuri",
	["Orc"] = "Orco",
	["Orcs"] = "Orchi",
	["Pandaren"] = "Pandaren",
	["Pandaren_PL"] = "Pandaren",
	["Succubus"] = "Succube",
	["Tauren"] = "Tauren",
	["Tauren_PL"] = "Tauren",
	["Troll"] = "Troll",
	["Trolls"] = "Trolls",
	["Undead"] = "Non Morto",
	["Undead_PL"] = "Non Morti",
	["Void Elf"] = "Elfo del Vuoto",
	["Void elves"] = "Elfi del Vuoto",
	["Voidwalker"] = "Ombra del Vuoto",
	["Worgen"] = "Worgen",
	["Worgen_PL"] = "Worgens",
	["Zandalari Troll"] = "Troll Zandalari",
	["Zandalari Trolls"] = "Troll Zandalari"
}
elseif GAME_LOCALE == "ruRU" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "Эльф крови",
	["Blood elves"] = "Эльфы крови",
	["Dark Iron Dwarf"] = "Дворф из клана Черного Железа",
	["Dark Iron Dwarves"] = "Дворфы из клана Черного Железа",
	["Draenei"] = "Дреней",
	["Draenei_PL"] = "Дренеи",
	["Dwarf"] = "Дворф",
	["Dwarves"] = "Дворфы",
	["Felguard"] = "Страж Скверны",
	["Felhunter"] = "Охотник Скверны",
	["Gnome"] = "Гном",
	["Gnomes"] = "Гномы",
	["Goblin"] = "Гоблин",
	["Goblins"] = "Гоблины",
	["Highmountain Tauren"] = "Таурен Крутогорья",
	["Highmountain Tauren_PL"] = "Таурены Крутогорья",
	["Human"] = "Человек",
	["Humans"] = "Люди",
	["Imp"] = "Бес",
	["Kul Tiran"] = "Култирасец",
	["Kul Tirans"] = "Култирасцы",
	["Lightforged Draenei"] = "Озаренный дреней",
	["Lightforged Draenei_PL"] = "Озаренные дренеи",
	["Mag'har Orc"] = "Маг'хар",
	["Mag'har Orcs"] = "Маг'хары",
	["Night Elf"] = "Ночной эльф",
	["Night elves"] = "Ночные эльфы",
	["Nightborne"] = "Ночнорожденный",
	["Nightborne_PL"] = "Ночнорожденные",
	["Orc"] = "Орк",
	["Orcs"] = "Орки",
	["Pandaren"] = "Пандарен",
	["Pandaren_PL"] = "Пандарены",
	["Succubus"] = "Суккуб",
	["Tauren"] = "Таурен",
	["Tauren_PL"] = "Таурены",
	["Troll"] = "Тролль",
	["Trolls"] = "Тролли",
	["Undead"] = "Нежить",
	["Undead_PL"] = "Нежить",
	["Void Elf"] = "Эльф Бездны",
	["Void elves"] = "Эльфы Бездны",
	["Voidwalker"] = "Демон Бездны",
	["Worgen"] = "Ворген",
	["Worgen_PL"] = "Воргены",
	["Zandalari Troll"] = "Зандалар",
	["Zandalari Trolls"] = "Зандалары"
}
elseif GAME_LOCALE == "zhCN" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "血精灵",
	["Blood elves"] = "血精灵",
	["Dark Iron Dwarf"] = "黑铁矮人",
	["Dark Iron Dwarves"] = "黑铁矮人",
	["Draenei"] = "德莱尼",
	["Draenei_PL"] = "德莱尼",
	["Dwarf"] = "矮人",
	["Dwarves"] = "矮人",
	["Felguard"] = "恶魔卫士",
	["Felhunter"] = "地狱猎犬",
	["Gnome"] = "侏儒",
	["Gnomes"] = "侏儒",
	["Goblin"] = "地精",
	["Goblins"] = "地精",
	["Highmountain Tauren"] = "至高岭牛头人",
	["Highmountain Tauren_PL"] = "至高岭牛头人",
	["Human"] = "人类",
	["Humans"] = "人类",
	["Imp"] = "小鬼",
	["Kul Tiran"] = "库尔提拉斯人",
	["Kul Tirans"] = "库尔提拉斯人",
	["Lightforged Draenei"] = "光铸德莱尼",
	["Lightforged Draenei_PL"] = "光铸德莱尼",
	["Mag'har Orc"] = "玛格汉兽人",
	["Mag'har Orcs"] = "玛格汉兽人",
	["Night Elf"] = "暗夜精灵",
	["Night elves"] = "暗夜精灵",
	["Nightborne"] = "夜之子",
	["Nightborne_PL"] = "夜之子",
	["Orc"] = "兽人",
	["Orcs"] = "兽人",
	["Pandaren"] = "熊猫人",
	["Pandaren_PL"] = "熊猫人",
	["Succubus"] = "魅魔",
	["Tauren"] = "牛头人",
	["Tauren_PL"] = "牛头人",
	["Troll"] = "巨魔",
	["Trolls"] = "巨魔",
	["Undead"] = "亡灵",
	["Undead_PL"] = "亡灵",
	["Void Elf"] = "虚空精灵",
	["Void elves"] = "虚空精灵",
	["Voidwalker"] = "虚空行者",
	["Worgen"] = "狼人",
	["Worgen_PL"] = "狼人",
	["Zandalari Troll"] = "赞达拉巨魔",
	["Zandalari Trolls"] = "赞达拉巨魔"
}
elseif GAME_LOCALE == "zhTW" then
	lib:SetCurrentTranslations {
	["Blood Elf"] = "血精靈",
	["Blood elves"] = "血精靈",
	["Dark Iron Dwarf"] = "黑鐵矮人",
	["Dark Iron Dwarves"] = "黑鐵矮人",
	["Draenei"] = "德萊尼",
	["Draenei_PL"] = "德萊尼",
	["Dwarf"] = "矮人",
	["Dwarves"] = "矮人",
	["Felguard"] = "惡魔守衛",
	["Felhunter"] = "惡魔獵犬",
	["Gnome"] = "地精",
	["Gnomes"] = "地精",
	["Goblin"] = "哥布林",
	["Goblins"] = "哥布林",
	["Highmountain Tauren"] = "高嶺牛頭人",
	["Highmountain Tauren_PL"] = "高嶺牛頭人",
	["Human"] = "人類",
	["Humans"] = "人類",
	["Imp"] = "小鬼",
	["Kul Tiran"] = "庫爾提拉斯人",
	["Kul Tirans"] = "庫爾提拉斯人",
	["Lightforged Draenei"] = "光鑄德萊尼",
	["Lightforged Draenei_PL"] = "光鑄德萊尼",
	["Mag'har Orc"] = "瑪格哈獸人",
	["Mag'har Orcs"] = "瑪格哈獸人",
	["Night Elf"] = "夜精靈",
	["Night elves"] = "夜精靈",
	["Nightborne"] = "夜裔精靈",
	["Nightborne_PL"] = "夜裔精靈",
	["Orc"] = "獸人",
	["Orcs"] = "獸人",
	["Pandaren"] = "熊貓人",
	["Pandaren_PL"] = "熊貓人",
	["Succubus"] = "魅魔",
	["Tauren"] = "牛頭人",
	["Tauren_PL"] = "牛頭人",
	["Troll"] = "食人妖",
	["Trolls"] = "食人妖",
	["Undead"] = "不死族",
	["Undead_PL"] = "不死族",
	["Void Elf"] = "虛無精靈",
	["Void elves"] = "虛無精靈",
	["Voidwalker"] = "虛無行者",
	["Worgen"] = "狼人",
	["Worgen_PL"] = "狼人",
	["Zandalari Troll"] = "贊達拉食人妖",
	["Zandalari Trolls"] = "贊達拉食人妖"
}
else
	error(("%s: Locale %q not supported"):format(MAJOR_VERSION, GAME_LOCALE))
end
