local ADDON_NAME, ns = ...
local L = ns.NewLocale("enUS")
if not L then return end

-------------------------------------------------------------------------------
----------------------------------- DRUSTVAR ----------------------------------
-------------------------------------------------------------------------------

L["ancient_sarco_note"] = "Open the Ancient Sarcophagus to summon waves of {npc:128181}."
L["beshol_note"] = "Open the Obviously Safe Chest to summon the rare."
L["cottontail_matron_note"] = "Study the Beastly Ritual Skull to summon the rare."
L["gluttonous_yeti_note"] = "This {npc:127979} is doomed ..."
L["seething_cache_note"] = "Open the Seething Cache to summon waves of {npc:129031}."
L["the_caterer_note"] = "Study the Ruined Wedding Cake to activate."
L["vicemaul_note"] = "Click the {npc:127652} to reel in the rare."

L["merchants_chest_note"] = "Kill the nearby {npc:137468} that is holding a keyring to acquire {item:163710}"
L["wicker_pup_note"] = [[
Light the inactive {npc:143609es} to activate the chest. Combine the items from all four chests to create a {npc:143189}.

• Bespelled: {item:163790}
• Enchanted: {item:163796}
• Ensorcelled: {item:163791}
• Hexed: {item:163789}
]]

local runebound = "Activate the {npc:143688s} in the order shown on the metal plates behind the chest:\n\n"
L["runebound_cache_note"] = runebound.."Left -> Bottom -> Top -> Right"
L["runebound_chest_note"] = runebound.."Left -> Right -> Bottom -> Top"
L["runebound_coffer_note"] = runebound.."Right -> Top -> Left -> Bottom"

-- NOTE: These quotes (and for trainers in other zones) were taken from the quotes
-- for this NPC on Wowhead. If no quotes were listed, I started a battle with the NPC
-- and jotted down the opening line. Adds a little flavor to the tooltips.
L["captain_hermes_note"] = "Yeah! Crustacean power!"
L["dilbert_mcclint_note"] = "Hey there, name's {npc:140461}, Infestation Management. Always nice to battle a fellow arachnoid enthusiast."
L["fizzie_spark_note"] = "You think your pets have a chance against my Azerite infused team? You wish!"
L["michael_skarn_note"] = "Just remember as we start this battle, you asked for this."

L["drust_facts_note"] = "Read all of the steles to earn the achievement."
L["stele_forest_note"] = "Inside Ulfar's Den."
L["options_icons_drust_facts_desc"] = "Display stele locations for the {achievement:13064} achievement."
L["options_icons_drust_facts"] = "{achievement:13064}"

L["embers_crossbow_note"] = "Loot the {item:163749} on the ground between two trees, then return it to the ruins of Gol Var."
L["embers_flask_note"] = "Loot the {item:163746} in the water between two rocks, then return it to the ruins of Gol Var."
L["embers_hat_note"] = "Loot the {item:163748} from the pile of bones, then return it to the ruins of Gol Var."
L["embers_knife_note"] = "Pull the {item:163747} from the trunk of the tree, then return it to the ruins of Gol Var."
L["embers_golvar_note"] = "Return each relic to the ruins of Gol Var to complete the achievement."
L["golvar_ruins"] = "Ruins of Gol Var"
L["options_icons_ember_relics_desc"] = "Display relic locations for the {achievement:13082} achievement."
L["options_icons_ember_relics"] = "{achievement:13082}"

L["linda_deepwater_note"] = "To gain access, you must complete {npc:136458}'s quest line just outside of Anyport."

-------------------------------------------------------------------------------
----------------------------------- MECHAGON ----------------------------------
-------------------------------------------------------------------------------

L["avenger_note"] = "When {npc:155254} is in Rustbolt, kill the {npc:151159} (runs all over the zone) to spawn."
L["beastbot_note"] = "Craft a {item:168045} at {npc:150359} to activate."
L["cogstar_note"] = "Kill {npc:150667} mobs anywhere in the zone until he teleports in to reinforce them."
L["crazed_trogg_note"] = "Use a spraybot, paint filled bladder or the bots in Bondo's Yard to coat yourself in the color he yells."
L["deepwater_note"] = "Craft a {item:167649} at {npc:150359} to summon."
L["doppel_note"] = "Along with two other players, use a {item:169470} from {daily:56405} to activate."
L["foul_manifest_note"] = "Connect all three circuit breakers to the pylons in the water."
L["furor_note"] = "During {daily:55463}, click the small blue mushrooms until he spawns."
L["killsaw_note"] = "Spawns anywhere in the Fleeting Forest, likely in response to killing {npc:151871s}. Does not spawn on days when the Venture Company is in the forest and Clearcutters are not available."
L["leachbeast_note"] = "Shares a spawn with {npc:151745s} in Junkwatt Depot, which only spawn while the area is raining. Use an {item:168961} to activate the Weather Alteration Machine."
L["nullifier_note"] = [[
Hack the {npc:152174} using either:

• A {item:168435} punch card from {npc:151625}.

• A {item:168023} from minions that attack the JD41 and JD99 drill rigs.
]]
L["scrapclaw_note"] = "Off the shore in the water."
L["sparkqueen_note"] = "Spawns only when {daily:55765} is active."
L["rusty_note"] = "Craft a {item:169114} at {npc:150359} to enter the alternate future. Only spawns when {npc:153993} is NOT present in Rustbolt."
L["vaultbot_note"] = "Kite to the tesla coil in Bondo's Yard or craft a {item:167062} at {npc:150359} to break him open."

L["iron_chest"] = "Irontide Lockbox"
L["mech_chest"] = "Mechanized Chest"
L["msup_chest"] = "Mechanized Supply Chest"
L["rust_chest"] = "Old Rusty Chest"
L["iron_chest_note"] = "Open with an {item:169872} dropped from mobs in the Western Spray."
L["msup_chest_note"] = "Open with a {item:169873} dropped from mobs in the Western Spray."
L["rust_chest_note"] = "Open with an {item:169218} dropped from mobs in the Western Spray."

L["rec_rig_note"] = "To activate hard-mode, use the {spell:292352} weapon to convert all {npc:150825s} into {npc:151049s}. Pets are obtainable on both difficulties."

L["grease_bot_note"] = "Click the bot to gain 5% haste and 10% movement speed for 2 hours."
L["shock_bot_note"] = "Click the bot to gain a chain lightning damage proc for 2 hours."
L["welding_bot_note"] = "Click the bot to increase health and healing received by 10% for 2 hours."

L["options_icons_mech_buffs"] = "Buff Bots"
L["options_icons_mech_buffs_desc"] = "Display locations of grease, shock and welding bots on the map inside the dungeon."
L["options_icons_mech_chest"] = "Mechanized Chests"
L["options_icons_mech_chest_desc"] = "Display locations of mechanized chests. There are 10 unique chests that can be looted once a day and each chest has 4-5 spawn locations. Locations are grouped by color."
L["options_icons_locked_chest"] = "Locked Chests"
L["options_icons_locked_chest_desc"] = "Display locations of locked chests in the Western Spray."
L["options_icons_recrig"] = "{npc:150448}"
L["options_icons_recrig_desc"] = "Display the location of the {npc:150448} and its rewards."

-------------------------------------------------------------------------------
----------------------------------- NAZJATAR ----------------------------------
-------------------------------------------------------------------------------

L["naz_intro_note"] = "Complete the introductory quest chain to unlock rares, treasures, and world quests on Nazjatar."

L["alga_note"] = "CAUTION: Cloaked with four adds!"
L["allseer_note"] = "Spawns anywhere in lower Kal'methir."
L["anemonar_note"] = "Kill the {npc:150467} on top of him to activate."
L["avarius_note"] = "Use a {item:167012} to collect and place the colored crystals on the pedestals. You do not have to be a miner!"
L["banescale_note"] = "Small chance to spawn immediately after killing {npc:152359}."
L["elderunu_note"] = "Spawns anywhere in upper Kal'methir."
L["gakula_note"] = "Shoo away {npc:152275s} until he spawns."
L["glimmershell_note"] = "Small chance to spawn in place of {npc:152426s}."
L["kelpwillow_note"] = "Bring a {npc:154725} using a {item:167893} to activate."
L["lasher_note"] = "Plant a {item:166888} in the soil and feed it flies."
L["matriarch_note"] = "Shares a respawn timer with the other two Scale Matriarchs."
L["needle_note"] = "Usually spawns in the Gate of the Queen area."
L["oronu_note"] = "Summon a {npc:154849} pet to activate."
L["rockweed_note"] = "Kill {npc:152549} and {npc:151166} all over the zone until he spawns. A raid group is recommended as this can be a long grind."
L["sandcastle_note"] = "Use a {item:167077} to reveal chests anywhere in the zone until he spawns."
L["tidelord_note"] = "Kill the three {npc:145326s} and the summoned {npc:153999} until the Tidelord is summoned."
L["tidemistress_note"] = "Click Undisturbed Specimen eggs until she spawns."
L["urduu_note"] = "Kill a {npc:152563} in front of him to activate."
L["voice_deeps_notes"] = "Use a {item:168161} to break the rocks."
L["vorkoth_note"] = "Toss {item:167059} into the pool until it spawns."
L["area_spawn"] = "Spawns in the surrounding area."
L["cora_spawn"] = "Spawns anywhere in the Coral Forest."
L["cave_spawn"] = "Spawns in a cave."
L["east_spawn"] = "Spawns anywhere in the eastern half of the zone."
L["ucav_spawn"] = "Spawns in an underwater cave."
L["zone_spawn"] = "Spawns all over the zone."

L["assassin_looted"] = "looted while an assassin."

L["arcane_chest"] = "Arcane Chest"
L["glowing_chest"] = "Glowing Arcane Trunk"
L["arcane_chest_01"] = "Under some seaweed."
L["arcane_chest_02"] = "Inside the building upstairs."
L["arcane_chest_03"] = "On the second level."
L["arcane_chest_04"] = "In the water above the waterfall."
L["arcane_chest_05"] = "In the ruins."
L["arcane_chest_06"] = "" -- in the open
L["arcane_chest_07"] = "In the back of a cave. Entrance in Zanj'ir Wash to the east."
L["arcane_chest_08"] = "Hidden under some starfish."
L["arcane_chest_09"] = "In a cave behind {npc:154914}."
L["arcane_chest_10"] = "Under a molted shell."
L["arcane_chest_11"] = "At the top of the hill."
L["arcane_chest_12"] = "At the top of the waterfall."
L["arcane_chest_13"] = "At the top of the cliff, behind a tree."
L["arcane_chest_14"] = "Inside Elun'alor Temple."
L["arcane_chest_15"] = "In the right side of the building."
L["arcane_chest_16"] = "In an underwater cave. Entrance to the south."
L["arcane_chest_17"] = "At the top of the waterfall."
L["arcane_chest_18"] = "In a cave just below the path."
L["arcane_chest_19"] = "On top of the rock archway. Use a glider."
L["arcane_chest_20"] = "On top of the mountain."
L["glowing_chest_1"] = "In the back of an underwater cave. Defend the pylon."
L["glowing_chest_2"] = "Uncross the wires."
L["glowing_chest_3"] = "In the back of a cave. Defend the pylon."
L["glowing_chest_4"] = "Match 3 red runes."
L["glowing_chest_5"] = "In a cave. Defend the pylon."
L["glowing_chest_6"] = "Uncross the wires."
L["glowing_chest_7"] = "Match 4 blue runes."
L["glowing_chest_8"] = "On top of the roof. Defend the pylon."

L["slimy_cocoon"] = "Slimy Cocoon"
L["ravenous_slime_note"] = "Feed the slime a critter using a {item:167893}. Repeat five days until it spawns an egg with a pet inside. The slime will stay gone until the next weekly reset."
L["slimy_cocoon_note"] = "A pet is ready to be collected from the cocoon! If it does not appear for you, the egg in on cooldown in your phase. Change phases or check back later."

L["cat_figurine"] = "Crystalline Cat Figurine"
L["cat_figurine_01"] = "In an underwater cave. Figurine is on the floor in the open. Entrance to the east."
L["cat_figurine_02"] = "In a cave under the nearby waterfall. Figurine is under a starfish on the wall."
L["cat_figurine_03"] = "In an underwater cave. Figurine is hidden under some broken shells."
L["cat_figurine_04"] = "In an underwater cave. Figurine is on the floor in the open."
L["cat_figurine_05"] = "In a small cave. Figurine is hidden behind plant on the floor."
L["cat_figurine_06"] = "In an underwater cave filled with hostile Reefwalkers. Figurine is up on the wall. Entrance to the north."
L["cat_figurine_07"] = "In a small cave. Figurine is on the wall in some coral."
L["cat_figurine_08"] = "In a small cave. Dodge the arcane circles. Figurine is on a tall rock in the back."
L["cat_figurine_09"] = "In an underwater cave. Figurine is on the rock archway by the ceiling."
L["cat_figurine_10"] = "In a cave just below the path. Figurine is between three barrels."
L["figurines_found"] = "Crystalline Figurines Found"

L["mardivas_lab"] = "Mardivas's Laboratory"
L["no_reagent"] = "No reagents"
L["swater"] = "Small Water"
L["gwater"] = "Greater Water"
L["sfire"] = "Small Fire"
L["gfire"] = "Greater Fire"
L["searth"] = "Small Earth"
L["gearth"] = "Greater Earth"
L["Arcane"] = nil
L["Watery"] = nil
L["Burning"] = nil
L["Dusty"] = nil
L["Zomera"] = nil
L["Omus"] = nil
L["Osgen"] = nil
L["Moghiea"] = nil
L["Xue"] = nil
L["Ungormath"] = nil
L["Spawn"] = nil
L["Herald"] = nil
L["Salgos"] = nil
L["tentacle_taco"] = "Sells {item:170100} if you are wearing the Benthic {item:169489}."

L["options_icons_slimes_nazj"] = "{npc:151782s}"
L["options_icons_slimes_nazj_desc"] = "Display locations of the four {npc:151782s} that produce pets once fed."
L["options_icons_cats_nazj"] = "{achievement:13836}"
L["options_icons_cats_nazj_desc"] = "Display locations of the cat figurines for the {achievement:13836} achievement."
L["options_icons_misc_nazj"] = "Miscellaneous"
L["options_icons_misc_nazj_desc"] = "Display the location of {npc:152593}'s cave and Mardivas's Laboratory."

-------------------------------------------------------------------------------
------------------------------------ NAZMIR -----------------------------------
-------------------------------------------------------------------------------

L["captain_mukala_note"] = "Attempt to loot the Cursed Chest to summon the captain."
L["enraged_water_note"] = "Examine the {npc:134295} to summon the elemental."
L["lucille_note"] = "Talk to {npc:134297} to summon the rare."
L["offering_to_bwonsamdi_note"] = "Run up the nearby tree and jump into the broken structure."
L["shambling_ambusher_note"] = "Attempt to loot the {npc:124473} to activate the rare."
L["zaamar_note"] = "Inside the Necropolis Catacombs, entrance to the south."

L["grady_prett_note"] = "Time to get down and battle! Lets do this!"
L["korval_dark_note"] = "This place is spooky, lets make this a quick battle."
L["lozu_note"] = "Lets fight with honor, stranger."

L["tales_bwonsamdi_note"] = "At the destroyed pillar."
L["tales_hireek_note"] = "A Scroll on the table."
L["tales_kragwa_note"] = "At the destroyed wall."
L["tales_torga_note"] = "Underwater at a destroyed pillar."

L["carved_in_stone_41860"] = "Inside a destroyed building near the mountain."
L["carved_in_stone_41861"] = "At the destroyed pillar."
L["carved_in_stone_41862"] = "At the destroyed wall, in front of the huge pillar."
L["carved_in_stone_42116"] = "At a pillar next to {npc:126126}."
L["options_icons_carved_in_stone"] = "{achievement:13024}"
L["options_icons_carved_in_stone_desc"] = "Display pictograph locations for {achievement:13024}."

L["hoppin_sad_53419"] = "Behind two trees under a huge root."
L["hoppin_sad_53420"] = "In the ruins."
L["hoppin_sad_53424"] = "On a cliff."
L["hoppin_sad_53425"] = "On the tree near the waterfall."
L["hoppin_sad_53426"] = "Under a few roots."

L["options_icons_hoppin_sad"] = "{achievement:13028}"
L["options_icons_hoppin_sad_desc"] = "Display {npc:143317} locations for the {achievement:13028} achievement."

-------------------------------------------------------------------------------
------------------------------- STORMSONG VALLEY ------------------------------
-------------------------------------------------------------------------------

L["in_basement"] = "In the basement."
L["jakala_note"] = "Talk to {npc:140925}."
L["nestmother_acada_note"] = "Inspect Acada's Nest to spawn the rare."
L["sabertron_note"] = "Kill the {npc:139334} to activate one of the {npc:139328s}."
L["whiplash_note"] = "Only spawns when {wq:Whiplash} is active."

L["discarded_lunchbox_note"] = "In the building on top of the bookshelf."
L["hidden_scholars_chest_note"] = "On the roof of the building."
L["honey_vat"] =  "Honey Vat"
L["smugglers_stash_note"] = "In the water under the platform."
L["sunken_strongbox_note"] = "In the water under the ship."
L["venture_co_supply_chest_note"] = "Climb up the ladder on the ship."
L["weathered_treasure_chest_note"] = "In a hidden cave. There are three entrances, each hidden behind a cluster of trees."

L["curious_grain_sack"] = "Curious Grain Sack"
L["small_treasure_chest"] = "Small Treasure Chest"
L["small_treasure_51927"] = "In the building under the stairs."
L["small_treasure_51940"] = "In the building."

L["eddie_fixit_note"] = "Prepare to face my unbeatable team of highly modified and customized robots!"
L["ellie_vern_note"] = "I've found the toughest sea creatures around to battle for me, you don't stand a chance."
L["leana_darkwind_note"] = "Strange creatures on this island will make for a strange battle I suspect."

L["honeyback_harvester_note"] = "Talk to the {npc:155193} to begin the event. The Fresh Jelly Deposit can be looted once an hour and resets on the hour."
L["options_icons_honeybacks"] = "{npc:155193s}"
L["options_icons_honeybacks_desc"] = "Display {npc:155193} event locations for farming Honeyback Hive reputation."

L["lets_bee_friends_note"] = "Complete {daily:53371} seven times to earn the achievement and pet. To unlock the daily:"
L["lets_bee_friends_step_1"] = "Complete the Mildenhall Meadery questline through {quest:50553}."
L["lets_bee_friends_step_2"] = "Kill {npc:133429s} and {npc:131663s} at Mildenhall Meadery until you find an {item:163699}."
L["lets_bee_friends_step_3"] = "Bring {item:163699} to {npc:143128} in Boralus."
L["lets_bee_friends_step_4"] = "Bring {item:163702} to {npc:133907} at Mildenhall Meadery."
L["lets_bee_friends_step_5"] = "Complete {quest:53347} for {npc:133907}."

local luncheon = (UnitFactionGroup('player') == 'Alliance') and '{npc:138221} in Brennadam' or '{npc:138096} in Warfang Hold'
L["these_hills_sing_note"] = "Open {item:160485} here. Buy one from "..luncheon.." or loot one from the \"Discarded Lunchbox\" treasure in Brennadam."

L["ancient_tidesage_scroll"] = "Ancient Tidesage Scroll"
L["ancient_tidesage_scroll_note"] = "Read all 8 Ancient Tidesage Scrolls to earn the achievement."
L["options_icons_tidesage_legends"] = "{achievement:13051}"
L["options_icons_tidesage_legends_desc"] = "Display ancient scroll locations for the {achievement:13051} achievement."

L["long_forgotten_rum_note"] = "To enter the cave, {quest:50697} must be completed from {npc:134710} in Deadwash. Also sold by {npc:137040} in Drustvar."

-------------------------------------------------------------------------------
------------------------------- TIRAGARDE SOUND -------------------------------
-------------------------------------------------------------------------------

L["honey_slitherer_note"] = "Talk to {npc:137176} to summon the rare."
L["tempestria_note"] = "Inspect the Suspicious Pile of Meat to summon the rare."
L["twin_hearted_note"] = "Disturb the Ritual Effigy to activate the construct."
L["wintersail_note"] = "Destroy the Smuggler's Cache to summon the captain."

L["hay_covered_chest_note"] = "Ride the {npc:130350} down the road to {npc:131453} to spawn the treasure."
L["pirate_treasure_note"] = [[
Requires the corresponding treasure map.

The maps drop from any pirate mobs in Kul Tiras. Freehold (open world) is a good place to farm pirates.
]]

local damp_note =  "\n\nRead all five scrolls to gain access to the treasure."

L["damp_scroll"] = "A Damp Scroll"
L["damp_scroll_note_1"] = "Entrance in Stormsong Monastery."..damp_note
L["damp_scroll_note_2"] = "On the floor in a basement behind a {npc:136343}."..damp_note
L["damp_scroll_note_3"] = "On the floor upstairs next to a {npc:136343}."..damp_note
L["damp_scroll_note_4"] = "On the floor in a basement next to a {npc:136343}."..damp_note
L["damp_scroll_note_5"] = "In a corner under the boardwalk."..damp_note
L["ominous_altar"] = "Ominous Altar"
L["ominous_altar_note"] = "Talk to the Ominous Altar to be teleported to the treasure."
L["secret_of_the_depths_note"] = "Read all five Damp Scrolls, then talk to the Ominous Altar to teleport to the treasure."

L["burly_note"] = "These little guys are pretty strange, but they sure pack a punch. Are you sure you want this fight?"
L["delia_hanako_note"] = "Before we start, I just want to remind you to not feel too bad when my team annihilates yours."
L["kwint_note"] = "One person against one shark, maybe an even fight. One person against three? You're insane."

L["shanty_fruit_note"] = "Loot the Dusty Songbook, found on the floor in a small cave."
L["shanty_horse_note"] = "Loot the Scoundrel's Songbook, found on the bar inside the tavern."
L["shanty_inebriation_note"] = "Loot Jay's Songbook, found on the floor behind {npc:141066}."
L["shanty_lively_note"] = "Loot Russel's Songbook, found on top of the fireplace mantel."
L["options_icons_shanty_raid"] = "{achievement:13057}"
L["options_icons_shanty_raid_desc"] = "Display sea shanty locations for the {achievement:13057} achievement."

L["upright_citizens_node"] = [[
One of the three NPCs below will appear each time the {wq:Not Too Sober Citizens Brigade} assault quest is active.

• {npc:146295}
• {npc:145107}
• {npc:145101}

Recruit each one to complete the achievement. You will need to check the zone many times for the assault, world quest and correct NPCs to be active.
]]
L["options_icons_upright_citizens"] = "{achievement:13285}"
L["options_icons_upright_citizens_desc"] = "Display NPC locations for the {achievement:13285} achievement."

-------------------------------------------------------------------------------
------------------------------------ ULDUM ------------------------------------
-------------------------------------------------------------------------------

L["uldum_intro_note"] = "Complete the introductory quest chain to unlock rares, treasures and assault quests in Uldum."

L["aqir_flayer"] = "Shares a spawn with {npc:163114s} and {npc:154365s}."
L["aqir_titanus"] = "Shares a spawn with {npc:154353s}."
L["aqir_warcaster"] = "Shares a spawn with {npc:154352s}."
L["atekhramun"] = "Squish nearby {npc:152765s} until he spawns."
L["chamber_of_the_moon"] = "Underground in the Chamber of the Moon."
L["chamber_of_the_stars"] = "Underground in the Chamber of the Stars."
L["chamber_of_the_sun"] = "Inside the Chamber of the Sun."
L["dunewalker"] = "Click the Essence of the Sun on the platform above to release him."
L["friendly_alpaca"] = "Feed the alpaca {item:174858} seven times to learn it as a mount. Appears for 10 minutes in one location, then a long respawn."
L["gaze_of_nzoth"] = "Shares a spawn with {npc:156890s}."
L["gersahl_note"] = "Feed to the {npc:162765} seven times for a mount. Does not require Herbalism."
L["gersahl"] = "Gersahl Shrub"
L["hmiasma"] = "Feed it the surrounding oozes until it activates."
L["kanebti"] = "Collect a {item:168160} from a {npc:152427}, which shares a spawn with regular {npc:151859s}. Insert the figurine into the Scarab Shrine to summon the rare."
L["neferset_rare"] = "These six rares share the same three spawn locations in Neferset. After a number of Summoning Ritual events have been completed, a random set of three will spawn."
L["platform"] = "Spawns on top of the floating platform."
L["right_eye"] = "Drops the right half of the {item:175140} toy."
L["single_chest"] = "This chest spawns in only one location! If it is not there, wait a bit and it will respawn."
L["tomb_widow"] = "When the white egg-sacs are present by the pillars, kill the invisible spiders to summon."
L["uatka"] = "Along with two other players, click each Mysterious Device. Requires a {item:171208} from an Amathet Reliquary."
L["wastewander"] = "Shares a spawn with {npc:154369s}."

L["amathet_cache"] = "Amathet Cache"
L["black_empire_cache"] = "Black Empire Cache"
L["black_empire_coffer"] = "Black Empire Coffer"
L["infested_cache"] = "Infested Cache"
L["infested_strongbox"] = "Infested Strongbox"
L["amathet_reliquary"] = "Amathet Reliquary"

L["options_icons_assault_events"] = "Assault Events"
L["options_icons_assault_events_desc"] = "Display locations for possible assault events."
L["options_icons_coffers"] = "Locked Coffers"
L["options_icons_coffers_desc"] = "Display locations of locked coffers (lootable once per assault)."

L["ambush_settlers"] = "Defeat waves of mobs until the event ends."
L["burrowing_terrors"] = "Jump on the {npc:162073s} to squish them."
L["call_of_void"] = "Cleanse the Ritual Pylon."
L["combust_cocoon"] = "Throw the makeshift firebombs at the cocoons on the ceiling."
L["dormant_destroyer"] = "Click all the void conduit crystals."
L["executor_nzoth"] = "Kill the {npc:157680}, then destroy the Executor Anchor."
L["hardened_hive"] = "Pick up the {spell:317550} and burn all of the egg sacs."
L["in_flames"] = "Grab water buckets and douse the flames."
L["monstrous_summon"] = "Kill all of the {npc:160914s} to stop the summoning."
L["obsidian_extract"] = "Destroy every crystal of voidformed obsidian."
L["purging_flames"] = "Pick up the bodies and toss them into the fire."
L["pyre_amalgamated"] = "Cleanse the pyre, then kill all amalgamations until the rare spawns."
L["ritual_ascension"] = "Kill the {npc:152233s}."
L["solar_collector"] = "Enable all five cells on all sides of the collector. Clicking a cell also toggles all cells touching that cell."
L["summoning_ritual"] = "Kill the acolytes then close the summoning portal. After the event is completed a number of times, a set of three rares will spawn around Neferset."
L["titanus_egg"] = "Destroy the {npc:163257}, then defeat the {npc:163268}."
L["unearthed_keeper"] = "Destroy the {npc:156849}."
L["virnall_front"] = "Defeat waves of mobs until {npc:152163} spawns."
L["voidflame_ritual"] = "Extinguish all of the voidtouched candles."

L["beacon_of_sun_king"] = "Rotate all three statues inward."
L["engine_of_ascen"] = "Move all four statues into the beams."
L["lightblade_training"] = "Kill instructors and unprovens until {npc:152197} spawns."
L["raiding_fleet"] = "Burn all of the boats using the quest item."
L["slave_camp"] = "Open all of the nearby cages."
L["unsealed_tomb"] = "Protect {npc:152439} from waves of mobs."

-------------------------------------------------------------------------------
------------------------------------ VALE -------------------------------------
-------------------------------------------------------------------------------

L["vale_intro_note"] = "Complete the introductory quest chain to unlock rares, treasures and assault quests in the Vale of Eternal Blossoms."

L["big_blossom_mine"] = "Inside the Big Blossom Mine. Entrance to the north-east."
L["guolai"] = "Inside Guo-Lai Halls."
L["guolai_left"] = "Inside Guo-Lai Halls (left passage)."
L["guolai_center"] = "Inside Guo-Lai Halls (center passage)."
L["guolai_right"] = "Inside Guo-Lai Halls (right passage)."
L["left_eye"] = "Drops the left half of the {item:175140} toy."
L["pools_of_power"] = "Inside the Pools of Power. Entrance at The Golden Pagoda."
L["tisiphon"] = "Click on Danielle's Lucky Fishing Rod."

L["ambered_cache"] = "Ambered Cache"
L["ambered_coffer"] = "Ambered Coffer"
L["mogu_plunder"] = "Mogu Plunder"
L["mogu_strongbox"] = "Mogu Strongbox"

L["abyssal_ritual"] = "Kill the {npc:153179s} and then the {npc:153171}."
L["bound_guardian"] = "Kill the three {npc:154329s} to free the {npc:154328}."
L["colored_flames"] = "Collect the colored flames from their torches and bring them to the matching runes."
L["construction_ritual"] = "Push the tiger statue into the beam."
L["consuming_maw"] = "Purify growths and tentacles until kicked out."
L["corruption_tear"] = "Grab the {spell:305470} and close the tear without letting the whirling eyes hit you."
L["electric_empower"] = "Kill the {npc:153095s}, then {npc:156549}."
L["empowered_demo"] = "Close all of the spirit reliquaries."
L["empowered_wagon"] = "Pick up {npc:156300} and place them under the wagon."
L["feeding_grounds"] = "Destroy the amber vessels and suspension chambers."
L["font_corruption"] = "Rotate the mogu statues until both beams reach the back, then click the console."
L["goldbough_guardian"] = "Protect {npc:156623} from waves of mobs."
L["infested_statue"] = "Pull all the twitching eyes off the statue."
L["kunchong_incubator"] = "Destroy all the field generators."
L["mantid_hatch"] = "Pick up the {spell:305301} and destroy the larva incubators."
L["mending_monstro"] = "Destroy all the {npc:157552} crystals."
L["mystery_sacro"] = "Destroy all the Suspicious Headstones, then kill the {npc:157298}."
L["noodle_cart"] = "Defend {npc:157615} while he repairs his cart."
L["protect_stout"] = "Protect the cave from waves of mobs."
L["pulse_mound"] = "Kill the surrounding mobs, then the {npc:157529}."
L["ravager_hive"] = "Destroy all of the hives on the tree."
L["ritual_wakening"] = "Kill the {npc:157942s}."
L["serpent_binding"] = "Kill the {npc:157345s}, then {npc:157341}."
L["stormchosen_arena"] = "Clear all mobs in the arena, then kill the Clan General."
L["swarm_caller"] = "Destroy the {npc:157719} pylon."
L["vault_of_souls"] = "Open the vault and destroy all the statues."
L["void_conduit"] = "Click the Void Conduit and squish the watching eyes."
L["war_banner"] = "Burn the banners and kill waves of mobs until the commander appears."
L["weighted_artifact"] = "Pick up the Oddly Heavy Vase and navigate the maze back to the pedestal. Getting stunned by a statue drops the vase."

-------------------------------------------------------------------------------
----------------------------------- VISIONS -----------------------------------
-------------------------------------------------------------------------------

L["colored_potion"] = "Colored Potion"
L["colored_potion_note"] = [[
The potion next to the corpse of %s always indicates color of the negative-effect potion for the run.

The color of the +100 sanity potion can be determined by the color of this potion (|cFFFF0000bad|r => |cFF00FF00good|r):

Black => Green
Blue => Purple
Green => Red
Purple => Black
Red => Blue
]]

L["bear_spirit_note"] = "Kill the {npc:160404} and all waves of mobs to gain a 10% haste buff."
L["buffs_change"] = "Available buffs change each run. If the building is closed or the NPC/object is missing, that buff is not up this run."
L["clear_sight"] = "Requires {spell:307519} rank %d."
L["craggle"] = "Drop a toy on the ground (such as the {item:44606}) to distract him. Pull his bots away and kill them first."
L["empowered_note"] = "Go through the maze of mines and stand on the {npc:161324} upstairs for a 10% damage buff."
L["enriched_note"] = "Kill the {npc:161293} for a 10% crit buff."
L["ethereal_essence_note"] = "Kill {npc:161198} for a 10% crit buff."
L["ethereal_note"] = "Collect orange crystals hidden throughout the vision and return them to {npc:162358} for extra momentos. There are ten cystals total, two in each area.\n\n|cFF00FF00Don't forget to loot the chest!|r"
L["heroes_bulwark_note"] = "Kill {npc:158588} inside the inn for a 10% health buff."
L["inside_building"] = "Inside a building."
L["mailbox"] = "Mailbox"
L["mail_muncher"] = "When opened, the {npc:160708} has a chance to spawn."
L["odd_crystal"] = "Odd Crystal"
L["requited_bulwark_note"] = "Kill {npc:157700} to gain a 7% versatility buff."
L["shave_kit_note"] = "Inside the barber shop. Loot the crate on the table."
L["smiths_strength_note"] = "Kill {npc:158565} in the blacksmith hut for a 10% damage buff."
L["spirit_of_wind_note"] = "Kill {npc:161140} for a 10% haste and movement speed buff."
L["void_skull_note"] = "Click the skull on the ground to loot the toy."

L["c_alley_corner"] = "In a corner in the alleyway."
L["c_bar_upper"] = "In the bar on the upper level."
L["c_behind_bank_counter"] = "In the bank behind the counter in the back."
L["c_behind_boss"] = "In the refugee building behind the boss."
L["c_behind_boxes"] = "In the corner behind some boxes."
L["c_behind_cart"] = "Behind a destroyed cart."
L["c_behind_house_counter"] = "In the house behind the counter."
L["c_behind_mailbox"] = "Behind the mailbox."
L["c_behind_pillar"] = "Hidden behind a pillar behind the embassy building."
L["c_behind_rexxar"] = "Hidden to the right behind {npc:155098}'s building."
L["c_behind_stables"] = "Behind the stables by {npc:158157}."
L["c_by_pillar_boxes"] = "By the wall between a pillar and some boxes."
L["c_center_building"] = "On the bottom floor of the center building."
L["c_forge_corner"] = "In the corner by a forge."
L["c_hidden_boxes"] = "Hidden behind some boxes behind {npc:152089}'s building."
L["c_inside_auction"] = "Inside the auction house on the right."
L["c_inside_big_tent"] = "To the left inside the big tent."
L["c_inside_cacti"] = "Inside the cactus patch around the corner."
L["c_inside_hut"] = "Inside the first hut on the right."
L["c_inside_leatherwork"] = "Inside the leatherworking building."
L["c_inside_orphanage"] = "Inside the orphanage."
L["c_inside_transmog"] = "Inside the transmog hut."
L["c_left_cathedral"] = "Hidden left of the cathedral entrance."
L["c_left_inquisitor"] = "Behind the inquisitor miniboss to the left of the stairs."
L["c_on_small_hill"] = "On top of a small hill."
L["c_top_building"] = "On the top floor of the building."
L["c_underneath_bridge"] = "Underneath the bridge."
L["c_walkway_corner"] = "On the upper walkway in a corner."
L["c_walkway_platform"] = "On a platform above the upper walkway."

L["options_icons_visions_buffs"] = "Buffs"
L["options_icons_visions_buffs_desc"] = "Display locations of events that grant 1 hour damage buffs."
L["options_icons_visions_chest"] = "Chests"
L["options_icons_visions_chest_desc"] = "Display possible chest locations inside horrific visions."
L["options_icons_visions_crystals"] = "Odd Crystals"
L["options_icons_visions_crystals_desc"] = "Display possible odd crystal locations inside horrific visions."
L["options_icons_visions_mail"] = "Mailboxes"
L["options_icons_visions_mail_desc"] = "Display mailbox locations for the {item:174653} mount."
L["options_icons_visions_misc"] = "Miscellaneous"
L["options_icons_visions_misc_desc"] = "Display rare, toy, potion and ethereal locations inside horrific visions."

-------------------------------------------------------------------------------
----------------------------------- VOLDUN ------------------------------------
-------------------------------------------------------------------------------

L["bloodwing_bonepicker_note"] = "Collect the {npc:136390} at the summit to summon the vulture."
L["nezara_note"] = "Cut the ropes attached to all four {npc:128952s} to release the rare."
L["vathikur_note"] = "Kill the {npc:126894s} to summon the rare."
L["zunashi_note"] = "Entrance to the north in the mouth of a large skull."

L["ashvane_spoils_note"] = "Ride the {npc:132662} down the hill to spawn the treasure at the bottom."
L["excavators_greed_note"] = "Inside a collapsed tunnel."
L["grayals_offering_note"] = "After completing {quest:50702}, enter Atul'Aman and click the Ancient Altar to spawn the treasure."
L["kimbul_offerings_note"] = "On the hill above the Temple of Kimbul."
L["sandsunken_note"] = "Click the Abandoned Bobber to pull the treasure out of the sand."

L["keeyo_note"] = "Time for a great adventure!"
L["kusa_note"] = "I'm on a winning streak, you have no chance against me and my team."
L["sizzik_note"] = "I always appreciate a good battle with a new challenger."

L["tales_akunda_note"] = "In the pond."
L["tales_kimbul_note"] = "Next to the withered tree."
L["tales_sethraliss_note"] = "On the ground next to the table."

L["plank_1"] = "Where the sand ends at the top of the hill."
L["plank_2"] = "Next to a broken building."
L["plank_3"] = "On the side of the pyramid. Path starts at the other nearby plank."
L["plank_4"] = "At the top of a sand dune along the side of the pyramid."
L["plank_5"] = "Follow the serpent's tail to find the plank."
L["planks_ridden"] = "rickety planks ridden"
L["options_icons_dune_rider"] = "{achievement:13018}"
L["options_icons_dune_rider_desc"] = "Display rickety plank locations for the {achievement:13018} achievement."

L["options_icons_scavenger_of_the_sands"] = "{achievement:13016}"
L["options_icons_scavenger_of_the_sands_desc"] = "Show junk item locations for the {achievement:13016} achievement."

L["elusive_alpaca"] = "Feed {item:161128} to the {npc:162681} to learn it as a mount. Appears for 10 minutes in one location, then a long respawn."

-------------------------------------------------------------------------------
---------------------------------- WARFRONTS ----------------------------------
-------------------------------------------------------------------------------

L["boulderfist_outpost"] = "Inside Boulderfist Outpost (a large cave). Entrance to the northeast."
L["burning_goliath_note"] = "When defeated, a {npc:141663} will spawn near {npc:141668}."
L["cresting_goliath_note"] = "When defeated, a {npc:141658} will spawn near {npc:141668}."
L["rumbling_goliath_note"] = "When defeated, a {npc:141659} will spawn near {npc:141668}."
L["thundering_goliath_note"] = "When defeated, a {npc:141648} will spawn near {npc:141668}."
L["echo_of_myzrael_note"] = "Once all four elemental goliaths are defeated, {npc:141668} will appear."
L["frightened_kodo_note"] = "Despawns after a few minutes. Guaranteed to spawn after a server restart."

-------------------------------------------------------------------------------
----------------------------------- ZULDAZAR ----------------------------------
-------------------------------------------------------------------------------

L["murderbeak_note"] = "Toss the chum into the sea, then kill {npc:134780s} until {npc:134782} spawns."
L["vukuba_note"] = "Investigate the {npc:134049}, then kill waves of {npc:134047s} until {npc:134048} spawns."

L["cache_of_secrets_note"] = "Held by an {npc:137234} in a cave behind a waterfall."
L["da_white_shark_note"] = "Stand near {npc:133208} until she becomes hostile."
L["dazars_forgotten_chest_note"] = "Path begins near {npc:134738}."
L["gift_of_the_brokenhearted_note"] = "Place the incense to spawn the chest."
L["offerings_of_the_chosen_note"] = "On the second level of Zanchul."
L["riches_of_tornowa_note"] = "On the side of a cliff."
L["spoils_of_pandaria_note"] = "On the lowest deck of the ship."
L["tiny_voodoo_mask_note"] = "Sitting on the hut above {npc:141617}."
L["warlords_cache_note"] = "On top at the helm of the ship."

L["karaga_note"] = "I have not battled in a long while, I hope I am still a good challenge to you."
L["talia_spark_note"] = "The critters in this land are vicious, I hope you're ready for this."
L["zujai_note"] = "You come to face me in my own home? Good luck."

L["kuafon_note"] = [[
Loot a {item:157782} from any Pterrordax in Zandalar to begin the quest line. Some quests will take multiple days to complete.

The best mobs to farm are {npc:126618} in Zanchul or {npc:122113s} at Skyrender Eyrie south of Tal'gurub.
]]
L["torcali_note"] = "Complete quests at Warbeast Kraal until {quest:47261} becomes available. Some quests will take multiple days to complete."

L["totem_of_paku_note"] = "Speak to {npc:137510} north of the Great Seal to select Pa'ku as your loa in Zuldazar."
L["options_icons_paku_totems"] = "Totems of Pa'ku"
L["options_icons_paku_totems_desc"] = "Display {npc:131154} locations and their travel paths in Dazar'alor."

L["tales_gonk_note"] = "Lies on the blanket."
L["tales_gral_note"] = "At the roots of the tree."
L["tales_jani_note"] = "At the destroyed pillar."
L["tales_paku_note"] = "On top of the building, on a rock near the water."
L["tales_rezan_note"] = "Above the cave of {npc:136428}."
L["tales_shadra_note"] = "Next to the entrance, behind a torch."
L["tales_torcali_note"] = "Between a couple of barrels and the stairs."
L["tales_zandalar_note"] = "Behind {npc:132989}."

local shared_dinos = "The {daily:50860} daily must be active (one of four possible dailies) from the {npc:133680} quest line for them to appear. Anyone can see them on those days."
L["azuresail_note"] = "Shares a short respawn timer with {npc:135512} and {npc:135508}.\n\n"..shared_dinos
L["thunderfoot_note"] = "Shares a short respawn timer with {npc:135510} and {npc:135508}.\n\n"..shared_dinos
L["options_icons_life_finds_a_way"] = "{achievement:13048}"
L["options_icons_life_finds_a_way_desc"] = "Display fearsome dinosaur locations for the {achievement:13048} achievement."

-------------------------------------------------------------------------------
--------------------------------- ACROSS ZONES --------------------------------
-------------------------------------------------------------------------------

L["goramor_note"] = "Purchase a {item:163563} from {npc:126833} and feed it to {npc:143644}. {npc:126833} is located in a small cave near the Terrace of Sorrows."
L["makafon_note"] = "Purchase an {item:163564} from {npc:124034} in Scaletrader Post and feed it to {npc:130922}."
L["stompy_note"] = "Purchase a {item:163567} from {npc:133833} north of the Whistlebloom Oasis and feed it to {npc:143332}."
L["options_icons_brutosaurs"] = "{achievement:13029}"
L["options_icons_brutosaurs_desc"] = "Display brutosaur locations for the {achievement:13029} achievement."

local hekd_note = "\n\nTo gain access to {npc:126334}, you need to complete %s."
if UnitFactionGroup('player') == 'Horde' then
    hekd_note = hekd_note:format("{quest:47441} from {npc:127665} in Dazar'alor followed by {quest:47442} from {npc:126334}")
else
    hekd_note = hekd_note:format("{quest:51142} from {npc:136562} in Voldun followed by {quest:51145} from {npc:136559}")
end
local hekd_quest = "Complete the quest %s from {npc:126334}."..ns.color.Orange(hekd_note)
local hekd_item = "Loot a %s from %s near the trashpile and bring it to {npc:126334}."..ns.color.Orange(hekd_note)

L["charged_junk_note"] = format(hekd_item, "{item:158910}", "{npc:135727s}")
L["feathered_junk_note"] = format(hekd_item, "{item:157794}", "{npc:132410s}")
L["golden_junk_note"] = format(hekd_item, "{item:156963}", "{npc:122504s}")
L["great_hat_junk_note"] = format(hekd_quest, "{quest:50381}")
L["hunter_junk_note"] = format(hekd_quest, "{quest:50332}")
L["loa_road_junk_note"] = format(hekd_quest, "{quest:50444}")
L["nazwathan_junk_note"] = format(hekd_item, "{item:157802}", "{npc:131155s}")
L["redrock_junk_note"] = format(hekd_item, "{item:158916}", "{npc:134718s}")
L["ringhorn_junk_note"] = format(hekd_item, "{item:158915}", "{npc:130316s}")
L["saurid_junk_note"] = format(hekd_quest, "{quest:50901}")
L["snapjaw_junk_note"] = format(hekd_item, "{item:157801}", "{npc:126723s}")
L["vilescale_junk_note"] = format(hekd_item, "{item:157797}", "{npc:125393s}")
L["options_icons_get_hekd"] = "{achievement:12482}"
L["options_icons_get_hekd_desc"] = "Display tasks for {npc:126334} locations for the {achievement:12482} achievement."

L["options_icons_mushroom_harvest"] = "{achievement:13027}"
L["options_icons_mushroom_harvest_desc"] = "Display fungarian villain locations for the {achievement:13027} achievement."

L["options_icons_tales_of_de_loa"] = "{achievement:13036}"
L["options_icons_tales_of_de_loa_desc"] = "Display tablet locations for the {achievement:13036} achievement."

L["jani_note"] = "Click on the Mysterious Trashpile to reveal {npc:126334}."
L["rezan_note"] = ns.color.Red("Inside the Atal'Dazar dungeon.")
L["bow_to_your_masters_note"] = "Bow to the loa of Zandalar ("..ns.color.Orange('/bow')..")."
L["options_icons_bow_to_your_masters"] = "{achievement:13020}"
L["options_icons_bow_to_your_masters_desc"] = "Display loa locations for the {achievement:13020} achievement."

L["alisha_note"] = "This vendor requires quest progress in Drustvar."
L["elijah_note"] = "This vendor requires quest progress in Drustvar. He begins selling sausage after {quest:47945}."
L["raal_note"] = ns.color.Red("Inside the Waycrest Manor dungeon.")
L["sausage_sampler_note"] = "Eat one of every sausage to earn the achievement."
L["options_icons_sausage_sampler"] = "{achievement:13087}"
L["options_icons_sausage_sampler_desc"] = "Display vendor locations for the {achievement:13087} achievement."

-- For Horde, include a note about drinks that must be purchased on the AH
local horde_sheets = (UnitFactionGroup('player') == 'Horde') and [[ The following drinks are unavailable to Horde and must be purchased on the auction house:

• {item:163639}
• {item:163638}
• {item:158927}
• {item:162026}
• {item:162560}
• {item:163098}
]] or ''
L["three_sheets_note"] = "Acquire one of every drink to earn the achievement."..horde_sheets
L["options_icons_three_sheets"] = "{achievement:13061}"
L["options_icons_three_sheets_desc"] = "Display vendor locations for the {achievement:13061} achievement."

L["options_icons_daily_chests_desc"] = "Display locations of chests (lootable daily)."
L["options_icons_daily_chests"] = "Chests"

L["supply_chest"] = "War Supply Chest"
L["supply_chest_note"] = "A {npc:135181} or {npc:138694} will fly overhead once every 45 minutes and drop a {npc:135238} at one of three potential drop locations."
L["supply_single_drop"] = ns.color.Orange("This flight path always drops the supply crate at this location.")
L["options_icons_supplies_desc"] = "Display {npc:135238} drop locations."
L["options_icons_supplies"] = "{npc:135238s}"

L["secret_supply_chest"] = "Secret Supply Chest"
L["secret_supply_chest_note"] = "When a faction assault is active, a "..ns.color.Yellow("Secret Supply Chest").." can appear at one of these locations for a short time."
L["options_icons_secret_supplies"] = "Secret Supply Chests"
L["options_icons_secret_supplies_desc"] = "Display "..ns.color.Yellow("Secret Supply Chest").." locations for the {achievement:13317} achievement."