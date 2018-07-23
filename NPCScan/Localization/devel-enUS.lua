local AddOnFolderName, private = ...
local L = _G.LibStub("AceLocale-3.0"):NewLocale(AddOnFolderName, "enUS", true)

L["Added %1$s (%2$d) to the user-defined NPC list."] = true
L["Alerts"] = true
L["Completed Achievement Criteria"] = true
L["Completed Quest Objectives"] = true
L["Dead NPCs"] = true
L["Detection"] = true
L["Drag to set the spawn point for targeting buttons."] = true
L["Duration"] = true
L["Hide Anchor"] = true
L["Hide During Combat"] = true
L["Horizontal offset from the anchor point."] = true
L["Ignore Mute"] = true
L["Interval"] = true
L["NPCs"] = true
L["Play alert sounds when sound is muted."] = true
L["Predefined NPCs cannot be added to or removed from the user-defined NPC list."] = true
L["Removed %1$s (%2$d) from the user-defined NPC list."] = true
L["Reset Position"] = true
L["Screen Flash"] = true
L["Screen Location"] = true
L["Show Anchor"] = true
L["Spawn Point"] = true
L["%1$s (%2$d) is already on the user-defined NPC list."] = true
L["%1$s (%2$d) is not on the user-defined NPC list."] = true
L["The number of minutes before an NPC will be detected again."] = true
L["The number of minutes a targeting button will exist before fading out."] = true
L["Type the name of a Continent, Dungeon, or Zone, or the partial name of an NPC. Accepts Lua patterns."] = true
L["Valid values are a numeric NPC ID, the word \"mouseover\" while you have your mouse cursor over an NPC, or the word \"target\" while you have an NPC set as your target."] = true
L["Vertical offset from the anchor point."] = true
L["X Offset"] = true
L["Y Offset"] = true

L["BOTTOM"] = "Bottom"
L["BOTTOMLEFT"] = "Bottom Left"
L["BOTTOMRIGHT"] = "Bottom Right"
L["CENTER"] = "Center"
L["LEFT"] = "Left"
L["RIGHT"] = "Right"
L["TOP"] = "Top"
L["TOPLEFT"] = "Top Left"
L["TOPRIGHT"] = "Top Right"

-- ----------------------------------------------------------------------------
-- Vignettes
-- ----------------------------------------------------------------------------
local VL = _G.LibStub("AceLocale-3.0"):NewLocale(AddOnFolderName .. "Vignette", "enUS", true)

VL["Aarkos - Looted Treasure"] = true
VL["Abandoned Fishing Pole"] = true
VL["Alpha Bat"] = true
VL["Amateur Hunters"] = true
VL["Ambassador D'vwinn"] = true
VL["Anax"] = true
VL["Anchorite's Sojourn"] = true
VL["Antydas Nightcaller's Hideaway"] = true
VL["Apothecary Faldren"] = true
VL["Arcanist Lylandre"] = true
VL["Arcanist Shal'iman"] = true
VL["Artificer Lothaire"] = true
VL["Avatar of Sothrecar"] = true

VL["Ba'ruun"] = true
VL["Bahagar"] = true
VL["Battle of the Barnacle"] = true
VL["Beacher"] = true
VL["Beastmaster Pao'lek"] = true
VL["BH Master Scout"] = true
VL["Bilebrain"] = true
VL["Bladesquall"] = true
VL["Bodash the Hoarder"] = true
VL["Brawlgoth"] = true
VL["Bristlemaul"] = true
VL["Brogrul the Mighty"] = true
VL["Broodmother Lizax"] = true

VL["Cache of Infernals"] = true
VL["Cadraeus"] = true
VL["Cailyn Paledoom"] = true
VL["Captain Volo'ren"] = true
VL["Captured Survivor"] = true
VL["Cave Keeper"] = true
VL["Champion Chomper"] = true
VL["Charfeather"] = true
VL["Chief Bitterbrine"] = true
VL["Cindral"] = true
VL["Coldstomp"] = true
VL["Commander Soraax"] = true                   -- The NPC isn't in the game (yet?). Quest ID 44673
VL["Cora'kar"] = true
VL["Coura, Master of Arcana"] = true
VL["Crab Rider Grmlrml"] = true
VL["Crawshuk the Hungry"] = true
VL["Crystalbeard"] = true                       -- The NPC isn't in the game (yet?). Quest ID 37867

VL["Daggerbeak"] = true
VL["Darkshade, Saber Matriarch"] = true
VL["Dead Orc Captain"] = true
VL["Devouring Darkness"] = true
VL["Dorg"] = true
VL["Dread-Rider Cortis"] = true
VL["Dreadbog"] = true

VL["Echo of Murmur"] = true
VL["Egyl the Enduring"] = true
VL["Embaari Defense Crystal"] = true
VL["Elfbane"] = true
VL["Elindya Featherlight"] = true
VL["Enavra Varandi"] = true

VL["Faebright"] = true
VL["Fathnyr"] = true
VL["Fel Saberon Shaman"] = true
VL["Fenri"] = true
VL["Flog the Captain-Eater"] = true
VL["Flotsam"] = true
VL["Foreling Worship Circle"] = true
VL["Forsaken Deathsquad"] = true
VL["Frenzied Animus"] = true
VL["Frostshard"] = true

VL["Galzomar"] = true
VL["Garvrulg"] = true
VL["Gennadian"] = true
VL["Giant Python"] = true
VL["Giant Raptor"] = true
VL["Giantstalker Hunting Party"] = true
VL["Giblette the Cowardly"] = true
VL["Glimar Ironfist"] = true
VL["Gom Crabbar"] = true
VL["Gorebeak"] = true
VL["Gorger the Hungry"] = true
VL["Gorgroth"] = true
VL["Grelda the Hag"] = true
VL["Grrvrgull the Conquerer"] = true
VL["Guardian Thor'el"] = true
VL["Gurbog da Basher"] = true

VL["Haakun, The All-Consuming"] = true
VL["Hannval the Butcher"] = true
VL["Har'kess the Insatiable"] = true
VL["Hartli the Snatcher"] = true
VL["Haunted Manor"] = true
VL["Helmouth Raiders"] = true
VL["Hertha Grimdottir"] = true
VL["Hook & Sinker"] = true
VL["Horn of the Siren"] = true
VL["Houndmaster Ely"] = true
VL["Houndmaster Jax'zor"] = true
VL["Houndmaster Stroxis"] = true
VL["Huk'roth the Houndmaster"] = true

VL["IH Elite Sniper"] = true
VL["Inquisitor Ernstenbok"] = true
VL["Inquisitor Tivos"] = true
VL["Inquisitor Volitix"] = true
VL["Invasion Point: Devastation"] = true
VL["Ironbranch"] = true
VL["Iron Front Captain 1"] = true
VL["Iron Front Captain 2"] = true
VL["Iron Front Captain 3"] = true
VL["Iron Houndmaster"] = true
VL["Iron Tunnel Foreman"] = true
VL["Isel the Hammer"] = true
VL["Ivory Sentinel"] = true

VL["Jade Darkhaven"] = true
VL["Jaluk the Pacifist"] = true
VL["Jetsam"] = true

VL["Kenos the Unraveller"] = true
VL["Kethrazor"] = true
VL["Kharazos the Triumphant"] = true
VL["Klikixx"] = true
VL["Kottr Vondyr"] = true
VL["Krahl Deathwind"] = true

VL["Lady Rivantas"] = true
VL["Lava-Gorged Goren"] = true
VL["Leaf-Reader Kurri"] = true
VL["Lieutenant Strathmar"] = true
VL["Light the Braziers"] = true
VL["Llorian"] = true
VL["Lost Ettin"] = true
VL["Luggut the Eggeater"] = true
VL["Lyrath Moonfeather"] = true

VL["Mad \"King\" Sporeon"] = true
VL["Magister Phaedris"] = true
VL["Maia the White"] = true
VL["Majestic Elderhorn"] = true
VL["Mal'Dreth the Corrupter"] = true
VL["Mandrakor the Night Hunter"] = true
VL["Mar'tura"] = true
VL["Marius & Tehd"] = true
VL["Matron Hagatha"] = true
VL["Mellok, Son of Torok"] = true
VL["Miasu"] = true
VL["Mordvigbjorn"] = true
VL["Mother Om'ra"] = true
VL["Mrrgrl the Tide Reaver"] = true
VL["Murktide Alpha"] = true
VL["Myonix"] = true

VL["Naroua, King of the Forest"] = true
VL["Nas Dunberlin"] = true
VL["Night Haunter"] = true
VL["No'losh"] = true
VL["Noble Blademaster"] = true
VL["Normantis the Deposed"] = true

VL["Oasis Icemother"] = true
VL["Ogre Primalist"] = true
VL["Old Bear Trap"] = true
VL["Oreth the Vile"] = true
VL["Oubdob da Smasher"] = true

VL["Pale Assassin"] = true
VL["Pale Gone Fishin'"] = true
VL["Pale Spider Broodmother"] = true
VL["Panther Saberon Boss"] = true
VL["Perrexx the Corruptor"] = true
VL["Pinchshank"] = true
VL["Pit-Slayer"] = true
VL["Pridelord Meowl"] = true
VL["Protectors of the Grove"] = true
VL["Purging the River"] = true

VL["Quin'el, Master of Chillwind"] = true       -- The NPC isn't in the game (yet?). Quest ID 42700

VL["Ragemaw"] = true
VL["Randril"] = true
VL["Rauren"] = true
VL["Ravager Broodlord"] = true
VL["Ravyn-Drath"] = true
VL["Really Skunky Beer"] = true
VL["Reef Lord Raj'his"] = true
VL["Remnant of the Blood Moon"] = true
VL["Rogond"] = true
VL["Rok'nash"] = true
VL["Roteye"] = true

VL["Saberon Blademaster"] = true
VL["Saberon Shaman"] = true
VL["Sapper Vorick"] = true
VL["Scout Harefoot"] = true
VL["Sea Giant King"] = true
VL["Sea Hydra"] = true
VL["Sea King Tidross"] = true
VL["Sea Lord Torglork"] = true
VL["Seek & Destroy Squad"] = true
VL["Seersei"] = true
VL["Sekhan"] = true
VL["Selia, Master of Balefire"] = true       -- The NPC isn't in the game (yet?). Quest ID 42698
VL["Seemingly Unguarded Treasure"] = true
VL["Shadowflame Terror"] = true
VL["Shadowmoon Cultist Ritual"] = true
VL["Shadowquill"] = true
VL["Shal'an"] = true
VL["Shaman Fire Stone"] = true
VL["Shara Felbreath"] = true
VL["Shinri"] = true
VL["Shivering Ashmaw Cub"] = true
VL["Siegemaster Aedrin"] = true
VL["Sikthiss, Maiden of Slaughter"] = true
VL["Skagg"] = true                              -- The NPC isn't in the game (yet?). Quest ID 35244
VL["Skog"] = true
VL["Skywhisker Taskmaster"] = true
VL["Slogtusk"] = true
VL["Slumbering Bear"] = true
VL["Soulfang"] = true
VL["Soulgrinder Portal"] = true
VL["Soulthirster"] = true
VL["Starbuck"] = true
VL["Stingtail Nest"] = true
VL["Stomper Kreego"] = true
VL["Stoneshard Broodmother"] = true
VL["Stormwing Matriarch"] = true
VL["Syphonus & Leodrath"] = true
VL["Szirek"] = true

VL["Tarben"] = true
VL["Thane's Mead Hall"] = true
VL["The Beastly Boxer"] = true
VL["The Blightcaller"] = true
VL["The Brood Queen's Court: Count Nefarious"] = true
VL["The Brood Queen's Court: General Volroth"] = true
VL["The Brood Queen's Court: King Voras"] = true
VL["The Brood Queen's Court: Overseer Brutarg"] = true
VL["The Exiled Shaman"] = true
VL["The Muscle"] = true
VL["The Nameless King"] = true
VL["The Oracle"] = true
VL["The Voidseer"] = true
VL["Theryssia"] = true
VL["Thondrax"] = true
VL["Tide Behemoth"] = true
VL["Tideclaw"] = true
VL["Torrentius"] = true
VL["Totally Safe Treasure Chest"] = true
VL["Trecherous Stallions"] = true

VL["Unbound Rift"] = true
VL["Undgrell Attack"] = true
VL["Unguarded Thistleleaf Treasure"] = true
VL["Urgev the Flayer"] = true

VL["Valiyaka the Stormbringer"] = true
VL["Venomshade (Plant Hydra)"] = true
VL["Vicious Whale Shark"] = true
VL["Vorthax"] = true

VL["Wakkawam"] = true
VL["Wandering Vindicator - Looted Treasure"] = true
VL["Whitewater Typhoon"] = true
VL["Worg Pack"] = true
VL["Worgen Stalkers"] = true
VL["Wraithtalon"] = true
VL["Wrath-Lord Lekos"] = true

VL["Xothear, The Destroyer"] = true

VL["Yggdrel"] = true

VL["Zoug"] = true
VL["Zulk"] = true
