----------------------------------------------------------------------------------------------------
------------------------------------------AddOn NAMESPACE-------------------------------------------
----------------------------------------------------------------------------------------------------

local FOLDER_NAME, private = ...
local L = private.locale

----------------------------------------------COVENANT----------------------------------------------

local Kyrian    = 1
local Venthyr   = 2
local Nightfae  = 3
local Necrolord = 4
local PtoOribos = L["Portal to Oribos"]
local Mailbox   = L["Mailbox"]
--local PH = L["PH"] -- PLACEHOLDER

----------------------------------------------------------------------------------------------------
----------------------------------------------DATABASE----------------------------------------------
----------------------------------------------------------------------------------------------------

local DB = {}
private.DB = DB

DB.points = {
-----------------------------------------------KYRIAN-----------------------------------------------

[1707] = { -- Elysisan Hold - Archon's Rise
    [48816478] = { icon="portal", label=PtoOribos, covenant=Kyrian, sanctumtalent=1058 },

    [42747027] = { icon="renown", npc=176100, covenant=Kyrian }, -- Hüterin des Ruhms

    [48275915] = { icon="innkeeper", npc=174581, covenant=Kyrian }, -- Gastwirt
    [48635827] = { icon="mail", label=Mailbox, covenant=Kyrian }, -- Briefkasten

    [31584798] = { icon="vendor", npc=171973, covenant=Kyrian, sanctumtalent=1091 }, -- quest 60489
    [31084725] = { icon="vendor", npc=171981, covenant=Kyrian, sanctumtalent=1091 },
    [32784318] = { icon="anvil", npc=154635, covenant=Kyrian },
    [27084093] = { icon="vendor", npc=171959, covenant=Kyrian, sanctumtalent=1091 },
    [30393967] = { icon="vendor", npc=171958, covenant=Kyrian, sanctumtalent=1091 },
    [29983878] = { icon="trainer", npc=168430, covenant=Kyrian, sanctumtalent=1091 },
    [26373385] = { icon="innkeeper", npc=174582, covenant=Kyrian }, -- Gastwirt
    [24023658] = { icon="vendor", npc=174583, covenant=Kyrian },
    [24623230] = { icon="mail", label=Mailbox, covenant=Kyrian }, -- Briefkasten
    [22773160] = { icon="stablemaster", npc=174580, covenant=Kyrian },

    [54788307] = { icon="weaponsmith", npc=175522, covenant=Kyrian }, -- LFR
    [56068495] = { icon="weaponsmith", npc=175521, covenant=Kyrian }, -- Normal
    [57167963] = { icon="weaponsmith", npc=175523, covenant=Kyrian }, -- Heroic
    [58238118] = { icon="weaponsmith", npc=175524, covenant=Kyrian }, -- Mythic
},

[1708] = { -- Elysisan Hold - Sanctum of Binding
    [63373045] = { icon="vendor", npc=174937, covenant=Kyrian },
    [57383012] = { icon="reforge", npc=175825, covenant=Kyrian },
    [56893093] = { icon="vendor", npc=175823, covenant=Kyrian },

--    [59503420] = { icon="vendor", npc=160212, covenant=Kyrian }, -- Seelenwächterin
},

---------------------------------------------NECROLORD----------------------------------------------

[1698] = { -- Seat of the Primus
    [56373149] = { icon="portal", label=PtoOribos, covenant=Necrolord, sanctumtalent=1052 },

    [61014409] = { icon="weaponsmith", npc=175310, covenant=Necrolord }, -- LFR
    [61504564] = { icon="weaponsmith", npc=175371, covenant=Necrolord }, -- Normal
    [61424747] = { icon="weaponsmith", npc=175312, covenant=Necrolord }, -- Heroic
    [60654872] = { icon="weaponsmith", npc=175370, covenant=Necrolord }, -- Mythic

    [57184866] = { icon="vendor", npc=175311, covenant=Necrolord }, -- Paktrüstung
    [56234811] = { icon="reforge", npc=175314, covenant=Necrolord }, -- Paktrüstungsaufwertungen

    [52724104] = { icon="vendor", npc=172176, covenant=Necrolord }, -- Ruhmrüstmeisterin
    [46474023] = { icon="renown", npc=175998, covenant=Necrolord }, -- Hüterin des Ruhms
--    [46684234] = { icon="vendor", npc=167748, covenant=Necrolord }, -- Seelenwächter

    [42163153] = { icon="anvil", npc=173022, covenant=Necrolord }, --

    [46913004] = { icon="innkeeper", npc=161994, covenant=Necrolord }, -- Gastwirt
    [48352815] = { icon="mail", label=Mailbox, covenant=Necrolord }, -- Briefkasten
},

---------------------------------------------NIGHTFAE-----------------------------------------------

[1565] = { -- Ardenweald
--    [46605126] = { icon="portal", label=PtoOribos, covenant=Nightfae, sanctumtalent=1055 },
    [48975297] = { icon="stablemaster", npc=168082, covenant=Nightfae }, -- Stallmeisterin
},

[1701] = { -- Hearth of the Forest - The Trunk
    [33623696] = { icon="renown", npc=176096, covenant=Nightfae }, -- Hüterin des Ruhms
--    [34024355] = { icon="vendor", npc=158553, covenant=Nightfae }, -- Seelenwächterin

    [46085651] = { icon="vendor", npc=175418, covenant=Nightfae }, -- Rüstungshänderin der Nachtfae
    [46935676] = { icon="reforge", npc=175419, covenant=Nightfae }, -- Fortgeschrittene Rüstungsschmiedin der Nachtfae

    [52525602] = { icon="mail", label=Mailbox, covenant=Nightfae }, -- Briefkasten
    [54735619] = { icon="innkeeper", npc=160292, covenant=Nightfae }, -- Gastwirt
    [55085509] = { icon="anvil", npc=158554, covenant=Nightfae }, --
    [60303270] = { icon="vendor", npc=174914, covenant=Nightfae }, -- Ruhmrüstmeisterin
    [59473193] = { icon="vendor", npc=158556, covenant=Nightfae }, -- Rüstmeisterin der Wilden Jagd

    [88013726] = { icon="stablemaster", npc=168082, covenant=Nightfae }, -- Stallmeisterin
},

[1702] = { -- Hearth of the Forest - The Roots
    [59972842] = { icon="portal", label=PtoOribos, covenant=Nightfae, sanctumtalent=1055 },

    [46695388] = { icon="weaponsmith", npc=175413, covenant=Nightfae }, -- LFR
    [48035327] = { icon="weaponsmith", npc=175414, covenant=Nightfae }, -- Normal
    [49495377] = { icon="weaponsmith", npc=175415, covenant=Nightfae }, -- Heroic
    [51365462] = { icon="weaponsmith", npc=175417, covenant=Nightfae }, -- Mythic
},

----------------------------------------------VENTHYR-----------------------------------------------

[1699] = { -- Sinfall Reaches
    [62052630] = { icon="portal", label=PtoOribos, covenant=Venthyr, sanctumtalent=1049 },
    [66023348] = { icon="innkeeper", npc=166137, covenant=Venthyr }, -- Gastwirt
    [71582896] = { icon="stablemaster", npc=159000, covenant=Venthyr }, -- Stallmeisterin
    [54122456] = { icon="vendor", npc=174710, covenant=Venthyr }, -- Ruhmrüstmeisterin
    [60054330] = { icon="anvil", npc=166160, covenant=Venthyr}, -- Schmiedebedarf
    [60022874] = { icon="mail", label=Mailbox, covenant=Venthyr }, -- Briefkasten
    [54322626] = { icon="renown", npc=175772, covenant=Venthyr}, -- Hüterin des Ruhms
    [41904841] = { icon="flightmaster", npc=172649, covenant=Venthyr }, -- Oberflächenflieger
--    [45412852] = { icon="anvil", npc=164738, covenant=Venthyr}, -- Seelenwächter
},

[1700] = { -- Sinfall Depths
    [54924600] = { icon="weaponsmith", npc=174183, covenant=Venthyr }, -- LFR
    [55305433] = { icon="weaponsmith", npc=175407, covenant=Venthyr }, -- Normal
    [45406524] = { icon="weaponsmith", npc=174709, covenant=Venthyr }, -- Heroic
    [40164648] = { icon="weaponsmith", npc=175369, covenant=Venthyr }, -- Mythic
    [70632748] = { icon="vendor", npc=175406, covenant=Venthyr}, -- Rüstmeister
    [73022671] = { icon="reforge", npc=175408, covenant=Venthyr }, -- Paktrüstungsaufwertungen
    [67404719] = { icon="flightmaster", npc=172649, covenant=Venthyr }, -- Oberflächenflieger
},

} -- DB ENDE