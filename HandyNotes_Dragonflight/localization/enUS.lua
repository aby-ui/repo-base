local ADDON_NAME, ns = ...
local L = ns.NewLocale('enUS')
if not L then return end

-------------------------------------------------------------------------------
-------------------------------- DRAGON ISLES ---------------------------------
-------------------------------------------------------------------------------

L['dragon_glyph'] = 'Dragon Glyph'
L['options_icons_dragon_glyph'] = 'Dragon Glyphs'
L['options_icons_dragon_glyph_desc'] = 'Display the location of all 48 dragon glyphs.'

L['dragonscale_expedition_flag'] = 'Dragonscale Expedition Flag'
L['flags_placed'] = 'flags placed'
L['options_icons_flag'] = '{achievement:15890}'
L['options_icons_flag_desc'] = 'Display the location of all 20 flags for the achievement {achievement:15890}.'

L['options_icons_kite'] = '{achievement:16584}'
L['options_icons_kite_desc'] = 'Display the location of {npc:198118s} for the achievement {achievement:16584}.'

L['disturbed_dirt'] = 'Disturbed Dirt'
L['options_icons_disturbed_dirt'] = 'Disturbed dirt'
L['options_icons_disturbed_dirt_desc'] = 'Display the location of Disturbed Dirt.'

L['scout_pack'] = 'Expedition Scout\'s Pack'
L['options_icons_scout_pack'] = 'Expedition Scout\'s Packs'
L['options_icons_scout_pack_desc'] = 'Display the location of Expedition Scout\'s Packs.'

-------------------------------------------------------------------------------
------------------------------- THE AZURE SPAN --------------------------------
-------------------------------------------------------------------------------

L['blisterhide_note'] = 'Appears simultaneously with {npc:197344}, {npc:197356} and {npc:197354}'
L['fisherman_tinnak_note'] = 'Collect |cFFFFFD00Broken Fishing Pole|r, |cFFFFFD00Torn Fishing Net|r and |cFFFFFD00Old Harpoon|r to spawn the rare.'
L['gnarls_note'] = 'Appears simultaneously with {npc:197344}, {npc:197353} and {npc:197356}'
L['high_shaman_rotknuckle_note'] = 'Appears simultaneously with {npc:197344}, {npc:197353} and {npc:197354}'
L['snarglebone_note'] = 'Appears simultaneously with {npc:197353}, {npc:197356} and {npc:197354}'
L['trilvarus_loreweaver_note'] = 'Collect a |cFFFFFD00Singing Fragment|r to get {spell:382076} and use the |cFFFFFD00Uncharded Focus|r to spawn the rare.'

L['forgotten_jewel_box_note'] = 'Loot {item:199065} from a Clan Chest in Ridgewater Retreat (49.4 67.3) on the Ohn\'ahran Plains and use it.'
L['gnoll_fiend_flail_note'] = '{item:199066} can be found in Expedition Scout\'s Packs and Disturbed Dirts.'
L['pepper_hammer_note'] = 'Collect |cFFFFFD00Tree Sap|r and then use the |cFFFFFD00Stick|r to lure the {npc:195373}.\n\n|cFFFF0000(BUG: To click on the stick a reload might be necessary)|r'

L['leyline_note'] = 'Realign the ley line.'
L['options_icons_layline'] = '{achievement:16638}'
L['options_icons_layline_desc'] = 'Display the location of all ley line for the achievement {achievement:16638}.'

-------------------------------------------------------------------------------
------------------------------- FORBIDDEN REACH -------------------------------
-------------------------------------------------------------------------------

L['bag_of_enchanted_wind'] = 'Bag of Enchanted Wind'
L['bag_of_enchanted_wind_note'] = 'Located up in the tower.'
L['hessethiash_treasure'] = 'Hessethiash\'s Poorly Hidden Treasure'
L['lost_draconic_hourglass'] = 'Lost Draconic Hourglass'
L['mysterious_wand'] = 'Mysterious Wand'
L['mysterious_wand_note'] = 'Pick up the |cFFFFFD00Crystal Key|r and place it into the |cFFFFFD00Crystal Focus|r.'

-------------------------------------------------------------------------------
------------------------------ OHN'AHRAN PLAINS -------------------------------
-------------------------------------------------------------------------------

-- {quest:65901} = Sneaking Out
-- {currency:2003} = Dragon Isle Supplies
-- {item:192615} = Flourescent Fluid
-- {item:192658} = High-Fiber Leaf
-- {item:194966} = Thousandbite Piranha
-- {item:192636} = Woolly Mountain Pelt
-- {item:200598} = Meluun's Green Curry
-- {npc:190015} = Ohn Meluun
L['shade_of_grief_note'] = 'Click the {npc:193166} to spawn the rare.'

L['gold_swong_coin_note'] = 'Inside the cave with {npc:191608} to his right side.'
L['nokhud_warspear_note'] = '{item:194540} can be found in Expedition Scout\'s Packs and Disturbed Dirts.'
L['slightly_chewed_duck_egg_note'] = 'Find and pet {npc:192997} to get {item:195453} then use it. {item:199171} incubates in 3 days into {item:199172}.'
L['yennus_boat'] = 'Tuskarr Toy Boat'
L['yennus_boat_note'] = 'Loot the |cFFFFFD00Tuskarr Toy Boat|r to get {item:200876}, which starts the quest {quest:72063} that can be turned in at {npc:195252}.'

L['lizi_note'] = 'Complete the Initiate\'s Day Out storyline starting with {quest:65901}. Complete the quests each day to mend Lizi and receive your mount.\n\nIn addition to items required all quests require 150x {currency:2003} for a total of 750x {currency:2003}.'
L['lizi_note_day1'] = 'Collect 20x {item:192615} from insect mobs in the |cFFFFFD00Dragon Isles|r'
L['lizi_note_day2'] = 'Collect 10x {item:192658} from plant mobs in the |cFFFFFD00Dragon Isles|r'
L['lizi_note_day3'] = 'Collect 10x {item:194966} fished from any waters in the |cFFFFFD00Dragon Isles|r. Most commonly found in inland |cFFFFFD00Ohn\'ahran Plains|r'
L['lizi_note_day4'] = 'Collect 20x {item:192636} from mammoths in |cFFFFFD00Ohn\'ahran Plains|r'
L['lizi_note_day5'] = 'Purchase 1x {item:200598} from {npc:190015} in a tent south of |cFFFFFD00Ohn\'iri Springs|r'

L['ohnahra_note_start'] = 'Complete the Initiate\'s Day Out storyline starting with {quest:65901} then {npc:190022} will appear in |cFFFFFD00Ohn\'iri Springs|r behind a Windsage hut.\n\nGather the following materials:'
L['ohnahra_note_item1'] = 'Collect 3x {item:201929} from {npc:186151}, the final boss of the |cFFFFFD00Nokhud Offensive|r dungeon (Heroic difficulty). Not a 100% drop.'
L['ohnahra_note_item2'] = 'Purchase 1x {item:201323} from {npc:196707} for 50x {currency:2003} and 1x {item:194562}.\n{item:194562} can be looted from Time-Lost mobs in |cFFFFFD00Thaldrazsus|r.'
L['ohnahra_note_item3'] = 'Purchase 1x {item:191507} from the Auction House. (Alchemists can purchase {item:191588} from {npc:196707} starting at Renown 22)'
L['ohnahra_note_end'] = 'Once you have all materials, return to {npc:190022} and accept {quest:72512}. Go to {npc:194796} to turn in the quest and receive your mount.'

L['bakar_note'] = 'Pet the dog!'
L['bakar_ellam_note'] = 'If enough players pet this dog, she will lead you to her treasure.'
L['bakar_hugo_note'] = 'Travels with the Aylaag Camp.'
L['options_icons_bakar'] = '{achievement:16424}'
L['options_icons_bakar_desc'] = 'Display the location of all dogs (bakar) for the achievement {achievement:16424}.'

-------------------------------------------------------------------------------
--------------------------------- THALDRASZUS ---------------------------------
-------------------------------------------------------------------------------

L['acorn_harvester_note'] = 'Collect an |cFFFFFD00Acorn|r from the ground nearby to get {spell:388485} and then interact with {npc:196172}.'
L['cracked_hourglass_note'] = '{item:199068} can be found in Expedition Scout\'s Packs and Disturbed Dirts.'
L['sandy_wooden_duck_note'] = 'Collect {item:199069} and use it.'

-------------------------------------------------------------------------------
------------------------------ THE WAKING SHORE -------------------------------
-------------------------------------------------------------------------------

L['brundin_the_dragonbane_note'] = 'The Qalashi War Party travels on there {npc:192737} to this tower.'
L['shasith_note'] = 'Inside the |cFFFFFD00Obsidian Throne|r. \n\nYou and other Players have to return a total of 20x {item:191264}. To craft a key you need to combine 30x {item:191251} and 3x {item:193201}, you can get these items from Obsidian Citadel Mobs.'

L['bubble_drifter_note'] = '{item:199061} can be found in Expedition Scout\'s Packs and Disturbed Dirts.'
L['onyx_gem_cluster_note'] = 'Buy {item:200738} from {npc:189065} for 3 {item:192863} and 500 {currency:2003} at Renown 21 with the Dragonscale Expedition and use it.'
L['replica_dragon_goblet_note'] = 'Buy {item:198854} from {npc:193915} in |cFFFFFD00Wingrest Embassy|r and use it.'

L['fullsails_supply_chest'] = 'Fullsails Supply Chest'
L['hidden_hornswog_hoard'] = 'Hidden Hornswog Hoard'
L['hidden_hornswog_hoard_note'] = 'Collect {item:200064}, {item:200065} and {item:200066}, combine them at the |cFFFFFD00"Observant Riddles: A Field Guide"|r near the treasure then feed the frog.'
