local myname, ns = ...

-- note to self: I like Garr_TreasureIcon...

local merge = function(t1, t2)
    if not t2 then return t1 end
    for k, v in pairs(t2) do
        t1[k] = v
    end
end
ns.merge = merge

local AZERITE = 1553
local CHEST = 'Treasure Chest'
local CHEST_SM = 'Small Treasure Chest'
local CHEST_GLIM = 'Glimmering Treasure Chest'
local CHEST_MECH = 'Mechanized Chest'
local CHEST_AR = 'Arcane Chest'
local AR_TRUNK = 'Arcane Trunk'
local KITTY = 'Crystalline Cat Figurine'

local path_meta = {__index = {
    label = "Path to treasure",
    atlas = "map-icon-SuramarDoor.tga", -- 'PortalPurple'
    path = true,
    scale = 1.1,
}}
local path = function(details)
    return setmetatable(details or {}, path_meta)
end
ns.path = path

ns.map_spellids = {
    -- [862] = 0, -- Zuldazar
    -- [863] = 0, -- Nazmir
    -- [864] = 0, -- Vol'dun
    -- [895] = 0, -- Tiragarde Sound
    -- [896] = 0, -- Drustvar
    -- [942] = 0, -- Stormsong Valley
}

ns.points = {
    --[[ structure:
    [uiMapID] = { -- "_terrain1" etc will be stripped from attempts to fetch this
        [coord] = {
            label=[string], -- label: text that'll be the label, optional
            item=[id], -- itemid
            quest=[id], -- will be checked, for whether character already has it
            currency=[id], -- currencyid
            achievement=[id], -- will be shown in the tooltip
            junk=[bool], -- doesn't count for achievement
            npc=[id], -- related npc id, used to display names in tooltip
            note=[string], -- some text which might be helpful
            hide_before=[id], -- hide if quest not completed
            requires_buff=[id], -- hide if player does not have buff, mostly useful for buff-based zone phasing
            requires_no_buff=[id] -- hide if player has buff, mostly useful for buff-based zone phasing
        },
    },
    --]]
    [862] = { -- Zuldazar
        [54093150] = {quest=48938, achievement=12851, criteria=40988, note="On second floor",}, -- Offerings of the Chosen
        [64712167] = {quest=50259, achievement=12851, criteria=40989,}, -- Witch Doctor's Hoard
        [51718690] = {quest=49936, achievement=12851, criteria=40990, note="Bottom floor of ship",}, -- Spoils of Pandaria
        [51442661] = {quest=50582, achievement=12851, criteria=40991, note="Top of hill"}, -- Gift of the Brokenhearted
        [50112715] = path{quest=50582},
        [49506526] = {quest=49257, achievement=12851, criteria=40992, note="Top of ship",}, -- Warlord's Cache
        [38793444] = {quest=50707, achievement=12851, criteria=40993, note="Up on the rocks",}, -- Dazar's Forgotten Chest
        [41003328] = path{quest=50707, note="Path behind the waterfall"},
        [41973566] = path{quest=50707},
        [61065863] = {quest=50947, achievement=12851, criteria=40994, npc=133208, note="Event: kill Da White Shark first",}, -- Da White Shark's Bounty
        [71821677] = {quest=50949, item=163036, achievement=12851, criteria=40995, note="In cave",}, -- The Exile's Lament
        [71161767] = path{quest=50949},
        [56123806] = {quest=51338, achievement=12851, criteria=40996, note="In cave behind waterfall",}, -- Cache of Secrets
        [52974719] = {quest=51624, achievement=12851, criteria=40997}, -- Riches of Tor'nowa
        -- junk
        [50823158] = {quest=50711, junk=true, label=CHEST,},
        [65041636] = {quest=50715, junk=true, label=CHEST,},
        [68902222] = {quest=50715, junk=true, label=CHEST,},
        [68503365] = {quest=50716, junk=true, label=CHEST,},
        [66552896] = {quest=50720, junk=true, label=CHEST,},
        [63062832] = {quest=50720, junk=true, label=CHEST,},
        [75042303] = {quest=50721, junk=true, label=CHEST,},
        [48984088] = {quest=50722, junk=true, label=CHEST,},
        [45676019] = {quest=50723, junk=true, label=CHEST,},
        [47526049] = {quest=50723, junk=true, label=CHEST,},
        [80791415] = {quest=50724, junk=true, label=CHEST,},
        [80151648] = {quest=50724, junk=true, label=CHEST,},
        [41127489] = {quest=50726, junk=true, label=CHEST,},
        [43177297] = {quest=50726, junk=true, label=CHEST,},
        [40953756] = {quest=50727, junk=true, label=CHEST,},
        [81203857] = {quest=50728, junk=true, label=CHEST,},
        [80135512] = {quest=51346, junk=true, label=CHEST,},
        [82465431] = {quest=51346, junk=true, label=CHEST,},
        -- [71684127] = {quest=50308, junk=true, label="Mysterious trashpile", achievement="12482", note="Jani"},
    },
    [863] = { -- Nazmir
        [77903634] = {quest=49867, achievement=12771, criteria=40857,}, -- Lucky Horace's Lucky Chest
        [77884635] = {quest=50061, achievement=12771, criteria=40858, note="In dead hippo's mouth",}, -- Partially-Digested Treasure
        [43065078] = {quest=49979, achievement=12771, criteria=40859, note="In cave",}, -- Cursed Nazmani Chest
        [42275056] = path{quest=49979},
        [35668560] = {quest=49885, achievement=12771, criteria=40860, note="In cave",}, -- Cleverly Disguised Chest
        [62103487] = {quest=49891, achievement=12771, criteria=40861, note="Underwater cave",}, -- Lost Nazmani Treasure
        [42772620] = {quest=49484, achievement=12771, criteria=40862, note="Climb the tree",}, -- Offering to Bwonsamdi
        [66791735] = {quest=49483, achievement=12771, criteria=40863, note="Climb the tree",}, -- Shipwrecked Chest
        [46228295] = {quest=49889, achievement=12771, criteria=40864,}, -- Venomous Seal
        [76826220] = {quest=50045, achievement=12771, criteria=40865, note="Underwater cave",}, -- Swallowed Naga Chest
        [35455498] = {quest=49313, achievement=12771, criteria=40866, note="In cave",}, -- Wunja's Trove
        -- Hoppin' Sad (Lost Spawn of Krag'wa)
        [69105790] = {quest=53417, achievement=13028, minimap=true, atlas="WildBattlePetCapturable",}, --verify
        [65605090] = {quest=53418, achievement=13028, minimap=true, atlas="WildBattlePetCapturable",}, --verify
        [56106490] = {quest=53419, achievement=13028, minimap=true, atlas="WildBattlePetCapturable",},
        [52804290] = {quest=53420, achievement=13028, minimap=true, atlas="WildBattlePetCapturable",}, --verify
        [33506160] = {quest=53421, achievement=13028, minimap=true, atlas="WildBattlePetCapturable",},
        [45609100] = {quest=53422, achievement=13028, minimap=true, atlas="WildBattlePetCapturable",}, --verify
        [28408230] = {quest=53423, achievement=13028, minimap=true, atlas="WildBattlePetCapturable", note="Cave in cliffs",}, --verify
        [24209160] = {quest=53424, achievement=13028, minimap=true, atlas="WildBattlePetCapturable",}, --verify
        [21706930] = {quest=53425, achievement=13028, minimap=true, atlas="WildBattlePetCapturable",},
        -- [52804290] = {quest=53426, achievement=13828, minimap=true,}, -- maybe?
        [25694058] = {quest=53426, achievement=13028, minimap=true, atlas="WildBattlePetCapturable",},
        -- junk
        [41575046] = {quest=49916, junk=true, label=CHEST,},
        [41596574] = {quest=49916, junk=true, label=CHEST,},
        [28048187] = {quest=50895, junk=true, label=CHEST,},
    },
    [864] = { -- Vol'dun
        [46598801] = {quest=50237, achievement=12849, criteria=40966, note="Use mine cart",}, -- Ashvane Spoils
        [44339222] = path{quest=50237, label="Mine cart"},
        [49787940] = {quest=51132, achievement=12849, criteria=40968, note="Climb the rock arch",}, -- Lost Explorer's Bounty
        [44502613] = {quest=51135, achievement=12849, criteria=40970, note="Climb fallen tree",}, -- Stranded Cache
        [44712480] = path{quest=51135},
        [29388742] = {quest=51137, achievement=12849, criteria=40972, note="Under Disturbed Sand",}, -- Zem'lan's Buried Treasure
        [40578574] = {quest=52994, achievement=12849, criteria=41003,}, -- Deadwood Chest
        [38848290] = path{quest=52994},
        [48186469] = {quest=51093, achievement=12849, criteria=40967, note="Door on East side", hide_before=50550, faction="Horde",}, -- Grayal's Last Offering
        [49166469] = path{quest=51093},
        [47195846] = {quest=51133, achievement=12849, criteria=40969, note="Path from South side",}, -- Sandfury Reserve
        [47445984] = path{quest=51133},
        [57746464] = {quest=51136, achievement=12849, criteria=40971,}, -- Excavator's Greed
        [56696469] = path{quest=51136},
        [57061121] = {quest=52992, achievement=12849, criteria=41002, note="Enter at top of temple",}, -- Lost Offerings of Kimbul
        [26484534] = {quest=53004, item=163036, achievement=12849, criteria=41004, note="Use Abandoned Bobber",}, -- Sandsunken Treasure
        -- Scavenger of the Sands
        [56297011] = {quest=53132, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41342, note="Under the bridge",}, -- Jason's Rusty Blade
        [36217838] = {quest=53133, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41343, note="Inside the turned over box",}, -- Ian's Empty Bottle
        [53568981] = {quest=53134, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41344, note="On the table",}, -- Julie's Cracked Dish
        [37813049] = {quest=53135, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41345, note="Under the rock",}, -- Brian's Broken Compass
        [26775289] = {quest=53136, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41346, note="First floor, blue stone table",}, -- Ofer's Bound Journal
        [29455937] = {quest=53137, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41347, note="On the small hill",}, -- Skye's Pet Rock
        [52431439] = {quest=53138, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41348, note="Near the bones close to the cliff",}, -- Julien's Left Boot
        [43217700] = {quest=53139, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41349, note="Near the wall",}, -- Navarro's Flask
        [47067577] = {quest=53140, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41350, note="Under the stairs",}, -- Zach's Canteen
        [45883072] = {quest=53141, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41351, note="Hanging on the hut",}, -- Damarcus' Backpack
        [66413590] = {quest=53142, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41352, note="In cave",}, -- Rachel's Flute
        [64883632] = path{quest=53142},
        [47933673] = {quest=53143, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41353, note="Cave under the giant tree",}, -- Josh's Fang Necklace
        [45229114] = {quest=53144, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41354, note="On the wall",}, -- Portrait of Commander Martens
        [62832267] = {quest=53145, minimap=true, atlas="VignetteLootElite", scale=1.2, achievement=13016, criteria=41355, note="Down from Tortaka Refuge",}, -- Kurt's Ornate Key
        -- junk
        [46984656] = {quest=50883, junk=true, label="Mysterious trashpile", achievement=12482, note="In alcove, Summon Jani, give her Charged Ranishu Antennae"},
        [59631517] = {quest=50914, junk=true, label=CHEST,},
        [61071734] = {quest=50914, junk=true, label=CHEST,},
        [53841481] = {quest=50915, junk=true, label=CHEST,},
        [60843637] = {quest=50916, junk=true, label=CHEST,},
        [62783373] = {quest=50916, junk=true, label=CHEST,},
        [54363351] = {quest=50917, junk=true, label=CHEST,},
        [64172528] = {quest=50918, junk=true, label=CHEST,},
        [35095003] = {quest=50919, junk=true, label=CHEST,},
        [48338890] = {quest=50920, junk=true, label=CHEST, note="In cave"},
        [46384538] = {quest=50921, junk=true, label=CHEST,},
        [30344624] = {quest=50922, junk=true, label=CHEST,},
        [29815402] = {quest=50922, junk=true, label=CHEST,},
        [26496777] = {quest=50923, junk=true, label=CHEST,},
        [31158381] = {quest=50924, junk=true, label=CHEST,},
        [37577607] = {quest=50924, junk=true, label=CHEST,},
        [36918033] = {quest=50924, junk=true, label=CHEST,},
        [44858126] = {quest=50925, junk=true, label=CHEST,},
        [52747649] = {quest=50926, junk=true, label=CHEST,},
        [56496993] = {quest=50926, junk=true, label=CHEST,},
        [57545508] = {quest=50928, junk=true, label=CHEST,},
        [52328519] = {quest=51673, junk=true, label=CHEST,},
        [51908251] = {quest=51673, junk=true, label=CHEST,},
    },
    [895] = { -- Tiragarde Sound
        [61515233] = {quest=49963, achievement=12852, criteria=41012, note="Ride the Guardian",}, -- Hay Covered Chest
        [56033319] = {quest=52866, achievement=12852, criteria=41014,}, -- Precarious Noble Cache
        [72482169] = {quest=52870, achievement=12852, criteria=41016, note="In cave",}, -- Scrimshaw Cache
        [72495814] = {quest=50442, item=155381, achievement=12852, criteria=41013,}, -- Cutwater Treasure Chest
        [61786275] = {quest=52867, achievement=12852, criteria=41015, note="In cave",}, -- Forgotten Smuggler's Stash
        [73103950] = {quest=52195, item=161342, achievement=12852, criteria=41017, note="In Boralus, on Stomsong Monastary",}, -- Secret of the Depths
        [55769095] = {quest=52195, hide_before={52134, 52135, 52136, 52137, 52138}, item=161342, achievement=12852, criteria=41017, note="Teleport here from Stormsong, pick up the gem",}, -- Secret of the Depths
        -- Freehold treasure maps
        [80007600] = {quest=52853, item=162571, achievement=12852, criteria=41018, note="Kill pirates in Freehold until the map drops",}, -- Soggy Treasure Map 162571 (q:52853)
        [80708050] = {quest=52859, item=162581, achievement=12852, criteria=41020, note="Kill pirates in Freehold until the map drops",}, -- Yellowed Treasure Map 162581 (q:52859)
        [74008300] = {quest=52854, item=162580, achievement=12852, criteria=41019, note="Kill pirates in Freehold until the map drops",}, -- Fading Treasure Map 162580 (q:52854)
        [76008500] = {quest=52860, item=162584, achievement=12852, criteria=41021, note="Kill pirates in Freehold until the map drops",}, -- Singed Treasure Map 162584 (q:52860)
        -- ...and the actual treasures they point to
        [54994608] = {quest=52807, hide_before=52853, achievement=12852, criteria=41018, note="Kill pirates in Freehold until the map drops",}, -- Soggy Treasure Map 162571 (q:52853)
        [90507551] = {quest=52836, hide_before=52859, achievement=12852, criteria=41020, note="Kill pirates in Freehold until the map drops",}, -- Yellowed Treasure Map 162581 (q:52859)
        [29222534] = {quest=52833, hide_before=52854, achievement=12852, criteria=41019, note="Kill pirates in Freehold until the map drops",}, -- Fading Treasure Map 162580 (q:52854)
        [48983759] = {quest=52845, hide_before=52860, achievement=12852, criteria=41021, note="Kill pirates in Freehold until the map drops",}, -- Singed Treasure Map 162584 (q:52860)
        -- Shanty Raid
        [43382585] = {quest=53410, item=163715, atlas="poi-workorders", minimap=true, achievement=13057, criteria=41542, note="In a cave",}, -- Fruit Counting
        [76218305] = {quest=50233, item=163717, atlas="poi-workorders", minimap=true, achievement=13057, criteria=41544, note="Kill Barman Bill",}, -- Josephus
        [56706990] = {quest=50096, item=163718, atlas="poi-workorders", minimap=true, achievement=13057, criteria=41545, note="Kill Black-Eyed Bart",}, -- Black Sphere
        [73208410] = {quest=53411, item=163719, atlas="poi-workorders", minimap=true, achievement=13057, criteria=41546, note="Ground floor, on a table",}, -- Horse
        [70602270] = {quest=53407, item=163716, atlas="poi-workorders", minimap=true, achievement=13057, criteria=41543, note="Behind Jay the Tavern Bard",}, -- Inebriation
        [74403540] = {quest=53408, item=163714, atlas="poi-workorders", minimap=true, achievement=13057, criteria=41541, note="On the fireplace mantel",}, -- Lively Men
        -- junk:
        [83673580] = {quest=53631, junk=true, label="Dusty Marine Supplies",},
        [76967543] = {quest=48593, junk=true, label=CHEST_SM,},
        [78008050] = {quest=48595, junk=true, label=CHEST_SM,},
        [76358090] = {quest=48595, junk=true, label=CHEST_SM,},
        [73468317] = {quest=48596, junk=true, label=CHEST_SM,},
        [75758283] = {quest=48596, junk=true, label=CHEST_SM,},
        [38432868] = {quest=48598, junk=true, label=CHEST_SM,},
        [38762673] = {quest=48599, junk=true, label=CHEST_SM,},
        [78114901] = {quest=48607, junk=true, label=CHEST_SM,},
        [79205050] = {quest=48607, junk=true, label=CHEST_SM,},
        [81344938] = {quest=48607, junk=true, label=CHEST_SM,},
        [76126733] = {quest=48608, junk=true, label=CHEST_SM,},
        [68635108] = {quest=48609, junk=true, label=CHEST_SM,},
        [50842310] = {quest=48611, junk=true, label=CHEST_SM,},
        [47442365] = {quest=48611, junk=true, label=CHEST_SM,},
        [48392785] = {quest=48611, junk=true, label=CHEST_SM,},
        [61212836] = {quest=48612, junk=true, label=CHEST_SM,},
        [57311757] = {quest=48617, junk=true, label=CHEST_SM,},
        [87347379] = {quest=48618, junk=true, label=CHEST_SM,},
        [88387840] = {quest=48618, junk=true, label=CHEST_SM,},
        [69801270] = {quest=48619, junk=true, label=CHEST_SM,},
        [46481829] = {quest=48621, junk=true, label=CHEST_SM,},
    },
    [896] = { -- Drustvar
        [33713008] = {quest=53356, achievement=12995, criteria=41697,}, -- Web-Covered Chest
        [63306585] = {quest=53385, item=163743, achievement=12995, criteria=41699, note="Left Down Up Right",}, -- Runebound Cache
        [33687173] = {quest=53387, item=163740, achievement=12995, criteria=41701, note="Right Up Left Down",}, -- Runebound Coffer
        [55605181] = {quest=53472, item=163790, minimap=true, achievement=12995, criteria=41703, note="Click on Witch Torch",}, -- Bespelled Chest
        [25472416] = {quest=53474, item=163796, minimap=true, achievement=12995, criteria=41705, note="Click on Witch Torch",}, -- Enchanted Chest
        [25751995] = {quest=53357, achievement=12995, criteria=41698, note="Get keys from Gorging Raven",}, -- Merchant's Chest
        [44222770] = {quest=53386, item=163742, achievement=12995, criteria=41700, note="Left Right Down Up",}, -- Runebound Chest
        [18515133] = {quest=53471, item=163789, minimap=true, achievement=12995, criteria=41702, note="Click on Witch Torch",}, -- Hexed Chest
        [67767367] = {quest=53473, item=163791, minimap=true, achievement=12995, criteria=41704, note="Click on Witch Torch",}, -- Ensorcelled Chest
        [24304840] = {quest=53475, minimap=true, achievement=12995, criteria=41752,}, -- Stolen Thornspeaker Cache
        -- junk
        [65312905] = {quest=51871, junk=true, label=CHEST_SM,},
        [57862187] = {quest=51875, junk=true, label=CHEST_SM,},
        [58642825] = {quest=51875, junk=true, label=CHEST_SM,},
        [50332252] = {quest=51878, junk=true, label=CHEST_SM,},
        [62094463] = {quest=51882, junk=true, label=CHEST_SM,},
        [60306860] = {quest=51896, junk=true, label=CHEST_SM,},
        [26222993] = {quest=51907, junk=true, label=CHEST_SM,},
        [23181263] = {quest=5191, junk=true, label=CHEST_SM,},
        [24223681] = {quest=51911, junk=true, label=CHEST_SM,},
        [39326173] = {quest=51914, junk=true, label=CHEST_SM,},
    },
    [942] = { -- Stormsong Valley
        [66901200] = {quest=51449, achievement=12853, criteria=41061,}, -- Weathered Treasure Chest
        [42854723] = {quest=50089, achievement=12853, criteria=41062, note="In cave",}, -- Old Ironbound Chest
        [48968407] = {quest=50526, achievement=12853, criteria=41063,}, -- Frosty Treasure Chest
        [67224321] = {quest=50734, achievement=12853, criteria=41064, note="Under ship",}, -- Sunken Strongbox
        [59913907] = {quest=50937, achievement=12853, criteria=41065, note="On roof",}, -- Hidden Scholar's Chest
        [58608388] = {quest=49811, achievement=12853, criteria=41066, note="Under platform",}, -- Smuggler's Stash
        [58216368] = {quest=52326, achievement=12853, criteria=41067, note="Top shelf inside shed",}, -- Discarded Lunchbox
        [44447353] = {quest=52429, item=162000, achievement=12853, criteria=41068, note="Jump down onto platform",}, -- Carved Wooden Chest
        [36692323] = {quest=52976, achievement=12853, criteria=41069, note="Climb ladder onto ship",}, -- Venture Co. Supply Chest
        [46003069] = {quest=52980, achievement=12853, criteria=41070, note="Behind pillar",}, -- Forgotten Chest
        [41256950] = {achievement=13046, atlas="Food", minimap=true, note="Open an Unforgettable Luncheon here; buy them at the Inn, or loot one from the Discarded Lunchbox in Brennadam",}, -- These Hills Sing
        -- Legends of the Tidesages
        [49518090] = {achievement=13051, criteria=41425, minimap=true, atlas="poi-workorders",}, -- Part 1 (Near the waterfall)
        [59025954] = {achievement=13051, criteria=41426, minimap=true, atlas="poi-workorders",}, -- Part 2 (On top of the hill)
        [31957291] = {achievement=13051, criteria=41427, minimap=true, atlas="poi-workorders",}, -- Part 3 (Near the lake)
        [33813323] = {achievement=13051, criteria=41428, minimap=true, atlas="poi-workorders",}, -- Part 4 (On top of the island)
        [56023853] = {achievement=13051, criteria=41429, minimap=true, atlas="poi-workorders",}, -- Part 5 (Up the mountain right of Warfang Hold)
        [44183660] = {achievement=13051, criteria=41430, minimap=true, atlas="poi-workorders",}, -- Part 6 (Up the mountain left of Warfang Hold)
        [62083022] = {achievement=13051, criteria=41431, minimap=true, atlas="poi-workorders",}, -- Part 7
        [75073113] = {achievement=13051, criteria=41432, minimap=true, atlas="poi-workorders",}, -- Part 8 (Near the Shrine of the Storm entrance)
        -- junk
        [32126620] = {quest=53635, junk=true, label="Curious Grain Sack",},
        [32946967] = {quest=53652, junk=true, label="Curious Grain Sack",},
        [66567107] = {quest=50576, item=154476, label="Honey Vat", note="Strangely, not part of the achievement",},
        [62056563] = {quest=51184, junk=true, label=CHEST_SM,},
        [51796523] = {quest=51184, junk=true, label=CHEST_SM,},
        [70265958] = {quest=51927, junk=true, label=CHEST_SM,},
        [75103513] = {quest=51938, junk=true, label=CHEST_SM,},
        [64366899] = {quest=51939, junk=true, label=CHEST_SM,},
        [68067158] = {quest=51939, junk=true, label=CHEST_SM, note="In a bush",},
        [48406562] = {quest=51940, junk=true, label=CHEST_SM,},
        [44107300] = {quest=51942, junk=true, label=CHEST_SM,},
        [29776948] = {quest=51943, junk=true, label=CHEST_SM,},
        [29985150] = {quest=51944, junk=true, label=CHEST_SM,},
        [36272737] = {quest=51945, junk=true, label=CHEST_SM,},
        [57645092] = {quest=51946, junk=true, label=CHEST_SM,},
        [60865118] = {quest=51946, junk=true, label=CHEST_SM,},
        [46915393] = {quest=51949, junk=true, label=CHEST_SM,},
    },
    [1183] = { -- Thornheart
        [60804121] = {quest=52429, item=162000, achievement=12853, criteria=41068, note="Jump down from here",}, -- Carved Wooden chest
    },
    [1161] = { -- Boralus
        [61901010] = {quest=52870, achievement=12852, criteria=41016, note="In cave",}, -- Scrimshaw Cache
        -- Secret of the Depths:
        [61518382] = {quest=52195, atlas="MagePortalAlliance", minimap=true, achievement=12852, criteria=41017, note="Entrance to the underwater cave",},
        [55979126] = {quest=52134, atlas="poi-workorders", minimap=true, achievement=12852, criteria=41017, note="Read Damp Scrolls; in the underwater cave, from the monastary",},
        [61527772] = {quest=52135, atlas="poi-workorders", minimap=true, achievement=12852, criteria=41017, note="Read Damp Scrolls; underground",},
        [63078186] = {quest=52136, atlas="poi-workorders", minimap=true, achievement=12852, criteria=41017, note="Read Damp Scrolls; upstairs",},
        [70328576] = {quest=52137, atlas="poi-workorders", minimap=true, achievement=12852, criteria=41017, note="Read Damp Scrolls; underground",},
        [67147982] = {quest=52138, atlas="poi-workorders", minimap=true, achievement=12852, criteria=41017, note="Read Damp Scrolls",},
        [55769095] = {quest=52195, atlas="DemonInvasion2", scale=1.4, minimap=true, hide_before={52134, 52135, 52136, 52137, 52138}, item=161342, achievement=12852, criteria=41017, note="Ominous Altar; use it, get teleported, pick up the gem",}, -- Secret of the Depths
        -- Shanty Raid
        [72616853] = {quest=53408, item=163714, atlas="poi-workorders", minimap=true, achievement=13057, criteria=41541, note="On the fireplace mantel",}, -- Lively Men
        [53141767] = {quest=53407, item=163716, atlas="poi-workorders", minimap=true, achievement=13057, criteria=41543, note="Behind Jay the Tavern Bard",}, -- Inebriation
        -- junk
        [66758031] = {quest=50952, junk=true, label=CHEST_SM,},
    },
    [1165] = { -- Dazar'alor
        [59258870] = {quest=50947, minimap=true, achievement=12851, criteria=40994, npc=133208, note="Event: kill Da White Shark first",}, -- Da White Shark's Bounty
        [44472690] = {quest=51338, minimap=true, achievement=12851, criteria=40996, note="In cave behind waterfall",}, -- Cache of Secrets
        [38300716] = {quest=48938, minimap=true, achievement=12851, criteria=40988, note="On top of the Hall of the High Priests",}, -- Offerings of the Chosen
        [41141101] = path{quest=48938},
        -- junk
        [48981013] = {quest=49142, junk=true, label=CHEST,},
    },
    [1355] = { -- Nazjatar
        -- [43227436] = {quest=56290, minimap=true, achievement=13549, label=CHEST_AR,}, -- forgot what this is
        [85203860] = {quest=55938, minimap=true, achievement=13549, label=CHEST_AR,},
        [80302980] = {quest=55939, minimap=true, achievement=13549, label=CHEST_AR,},
        [74805320] = {quest=55940, minimap=true, achievement=13549, label=CHEST_AR,},
        [73313580] = {quest=55941, minimap=true, achievement=13549, label=CHEST_AR, note="Inside Temple, bottom floor"},
        [79502720] = {quest=55942, minimap=true, achievement=13549, label=CHEST_AR},
        [64303350] = {quest=55943, minimap=true, achievement=13549, label=CHEST_AR},
        [56493390] = {quest=55944, minimap=true, achievement=13549, label=CHEST_AR, note="Top of the cliffs"},
        [52904980] = {quest=55945, minimap=true, achievement=13549, label=CHEST_AR},
        [58103510] = {quest=55946, minimap=true, achievement=13549, label=CHEST_AR, note="Underwater Cave"}, [57303900] = path{quest=55946},
        [44804880] = {quest=55947, minimap=true, achievement=13549, label=CHEST_AR},
        [43305810] = {quest=55948, minimap=true, achievement=13549, label=CHEST_AR},
        [49506450] = {quest=55949, minimap=true, achievement=13549, label=CHEST_AR},
        [38707440] = {quest=55950, minimap=true, achievement=13549, label=CHEST_AR},
        [48508740] = {quest=55951, minimap=true, achievement=13549, label=CHEST_AR},
        [34704350] = {quest=55952, minimap=true, achievement=13549, label=CHEST_AR, note="Inside Cave"}, [37404280] = path{quest=55952},
        [26003230] = {quest=55953, minimap=true, achievement=13549, label=CHEST_AR, note="Under Starfish pile"},
        [34504050] = {quest=55954, minimap=true, achievement=13549, label=CHEST_AR},
        [50605000] = {quest=55955, minimap=true, achievement=13549, label=CHEST_AR, note="Inside Cave"}, [49705030] = path{quest=55955},
        [39804930] = {quest=55956, minimap=true, achievement=13549, label=CHEST_AR},
        [38006060] = {quest=55957, minimap=true, achievement=13549, label=CHEST_AR},

        [61502290] = {quest=55958, minimap=true, achievement=13549, label="Arcane Pylon", note="Inside Cave"}, [61401990] = path{quest=55958}, -- game quest id: 55359
        [37900604] = {quest=55959, minimap=true, achievement=13549, label=AR_TRUNK, note="Inside Cave"}, [39351005] = path{quest=55959},
        [55701440] = {quest=55961, minimap=true, achievement=13549, label=AR_TRUNK}, -- game quest id: 55998
        [64202850] = {quest=55962, minimap=true, achievement=13549, label=AR_TRUNK, note="Click Arcane device on the side on the right"}, -- game quest id: 55996
        [43901680] = {quest=55963, minimap=true, achievement=13549, label=AR_TRUNK},
        [37191919] = {quest=55960, minimap=true, achievement=13549, label=AR_TRUNK, note="Underwater Cave"},
        [24803520] = {quest=56912, minimap=true, achievement=13549, label="Arcane Pylon", note="Inside Cave"}, [26703380] = path{quest=56912}, -- game quest id: 56913
        [80503190] = {quest=56547, minimap=true, achievement=13549, label="Arcane Pylon", note="Up the building"}, [83003380] = path{quest=56547}, -- game quest id: 56913
        -- Cats!
        [28802910] = {quest=56983, minimap=true, achievement=13836, label=KITTY, note="Underwater cave", atlas="Warfront-AllianceHero-Silver", scale=1.2},
        [61102680] = {quest=56984, minimap=true, achievement=13836, label=KITTY, atlas="Warfront-AllianceHero-Silver", scale=1.2},
        [59103040] = {quest=56985, minimap=true, achievement=13836, label=KITTY, atlas="Warfront-AllianceHero-Silver", scale=1.2},
        [55302720] = {quest=56986, minimap=true, achievement=13836, label=KITTY, atlas="Warfront-AllianceHero-Silver", scale=1.2},
        [40158608] = {quest=56987, minimap=true, achievement=13836, label=KITTY, note="In underwater cave", atlas="Warfront-AllianceHero-Silver", scale=1.2}, [40318144] = path{quest=56987},
        [71402370] = {quest=56988, minimap=true, achievement=13836, label=KITTY, atlas="Warfront-AllianceHero-Silver", scale=1.2},
        [38004930] = {quest=56989, minimap=true, achievement=13836, label=KITTY, atlas="Warfront-AllianceHero-Silver", scale=1.2}, [38704930] = path{quest=56989},
        [58202200] = {quest=56990, minimap=true, achievement=13836, label=KITTY, atlas="Warfront-AllianceHero-Silver", scale=1.2},
        [61601070] = {quest=56991, minimap=true, achievement=13836, label=KITTY, atlas="Warfront-AllianceHero-Silver", scale=1.2},
        [73602590] = {quest=56992, minimap=true, achievement=13836, label=KITTY, atlas="Warfront-AllianceHero-Silver", scale=1.2},
    },
    [1462] = { -- Mechagon
        -- 325659
        [43304977] = {quest=55547, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 1 (of 9 in Normal Time)"},
        [52115326] = {quest=55547, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 1 (of 9 in Normal Time)"},
        [53254190] = {quest=55547, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 1 (of 9 in Normal Time)"},
        [49223021] = {quest=55547, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 1 (of 9 in Normal Time)"},
        [56973861] = {quest=55547, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 1 (of 9 in Normal Time)"},
        -- 325660
        [35683833] = {quest=55548, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 2 (of 9 in Normal Time)"},
        [30785183] = {quest=55548, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 2 (of 9 in Normal Time)"},
        [40155409] = {quest=55548, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 2 (of 9 in Normal Time)"},
        [20617141] = {quest=55548, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 2 (of 9 in Normal Time)"},
        -- 325661
        [80374838] = {quest=55549, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 3 (of 9 in Normal Time)"},
        [73515334] = {quest=55549, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 3 (of 9 in Normal Time)"},
        [67075645] = {quest=55549, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 3 (of 9 in Normal Time)"},
        [65866460] = {quest=55549, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 3 (of 9 in Normal Time)"},
        [59946357] = {quest=55549, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 3 (of 9 in Normal Time)"},
        -- 325662
        [65555284] = {quest=55550, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 4 (of 9 in Normal Time)"},
        [72594733] = {quest=55550, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 4 (of 9 in Normal Time)"},
        [73014950] = {quest=55550, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 4 (of 9 in Normal Time)"},
        [76215286] = {quest=55550, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 4 (of 9 in Normal Time)"},
        [81196149] = {quest=55550, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 4 (of 9 in Normal Time)"},
        -- 325663, Alt Mechagon only
        [61583230] = {quest=55551, criteria=0, label=CHEST_MECH, requires_buff=296644, note="Chest 1 (of 1 in Alternate Time)"},
        [58634160] = {quest=55551, criteria=0, label=CHEST_MECH, requires_buff=296644, note="Chest 1 (of 1 in Alternate Time)"},
        [70654796] = {quest=55551, criteria=0, label=CHEST_MECH, requires_buff=296644, note="Chest 1 (of 1 in Alternate Time)"},
        [64365961] = {quest=55551, criteria=0, label=CHEST_MECH, requires_buff=296644, note="Chest 1 (of 1 in Alternate Time)"},
        [56665739] = {quest=55551, criteria=0, label=CHEST_MECH, requires_buff=296644, note="Chest 1 (of 1 in Alternate Time)"},
        -- 325664
        [66432227] = {quest=55552, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 5 (of 9 in Normal Time)"},
        [64092627] = {quest=55552, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 5 (of 9 in Normal Time)"},
        [56782918] = {quest=55552, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 5 (of 9 in Normal Time)"},
        [57142283] = {quest=55552, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 5 (of 9 in Normal Time)"},
        [55612404] = {quest=55552, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 5 (of 9 in Normal Time)"},
        [50662858] = {quest=55552, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 5 (of 9 in Normal Time)"},
        -- 325665
        [67322289] = {quest=55553, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 6 (of 9 in Normal Time)"},
        [80691868] = {quest=55553, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 6 (of 9 in Normal Time)"},
        [86232042] = {quest=55553, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 6 (of 9 in Normal Time)"},
        [88732015] = {quest=55553, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 6 (of 9 in Normal Time)"},
        [85752824] = {quest=55553, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 6 (of 9 in Normal Time)"},
        -- 325666
        [48367595] = {quest=55554, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 7 (of 9 in Normal Time)"},
        [57258202] = {quest=55554, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 7 (of 9 in Normal Time)"},
        [62297390] = {quest=55554, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 7 (of 9 in Normal Time)"},
        [66767759] = {quest=55554, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 7 (of 9 in Normal Time)"},
        -- 325667
        [63626715] = {quest=55555, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 8 (of 9 in Normal Time)"},
        [72126545] = {quest=55555, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 8 (of 9 in Normal Time)"},
        [76516601] = {quest=55555, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 8 (of 9 in Normal Time)"},
        [81167231] = {quest=55555, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 8 (of 9 in Normal Time)"},
        [85166335] = {quest=55555, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 8 (of 9 in Normal Time)"},
        -- 325668
        [24796526] = {quest=55556, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 9 (of 9 in Normal Time)"},
        [20537696] = {quest=55556, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 9 (of 9 in Normal Time)"},
        [21788303] = {quest=55556, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 9 (of 9 in Normal Time)"},
        [12088568] = {quest=55556, criteria=0, label=CHEST_MECH, requires_no_buff=296644, note="Chest 9 (of 9 in Normal Time)"},
    },
}
