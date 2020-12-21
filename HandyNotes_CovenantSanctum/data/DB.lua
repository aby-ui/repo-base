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
--local PH = L["PH"] -- PLACEHOLDER

----------------------------------------------------------------------------------------------------
----------------------------------------------DATABASE----------------------------------------------
----------------------------------------------------------------------------------------------------

local DB = {}
private.DB = DB

DB.points = {
-----------------------------------------------KYRIAN-----------------------------------------------

[1707] = { -- Elysisan Hold - Archon's Rise
    [48816478] = { portal=true, label=L["Portal to Oribos"], covenant=Kyrian, sanctumtalent=1058 },

    [42747027] = { renown=true, npc=176100, covenant=Kyrian }, -- Hüterin des Ruhms

    [48275915] = { innkeeper=true, npc=174581, covenant=Kyrian }, -- Gastwirt
    [48545823] = { mail=true, label=L["Mailbox"], covenant=Kyrian }, -- Briefkasten

    [31584798] = { vendor=true, npc=171973, covenant=Kyrian, sanctumtalent=1091 }, -- quest 60489
    [31084725] = { vendor=true, npc=171981, covenant=Kyrian, sanctumtalent=1091 },
    [32784318] = { anvil=true, npc=154635, covenant=Kyrian },
    [27084093] = { vendor=true, npc=171959, covenant=Kyrian, sanctumtalent=1091 },
    [30393967] = { vendor=true, npc=171958, covenant=Kyrian, sanctumtalent=1091 },
    [29983878] = { trainer=true, npc=168430, covenant=Kyrian, sanctumtalent=1091 },
    [26373385] = { innkeeper=true, npc=174582, covenant=Kyrian }, -- Gastwirt
    [24023658] = { vendor=true, npc=174583, covenant=Kyrian },
    [24623230] = { mail=true, label=L["Mailbox"], covenant=Kyrian }, -- Briefkasten
    [22773160] = { stablemaster=true, npc=174580, covenant=Kyrian },

    [54788307] = { weaponsmith=true, npc=175522, covenant=Kyrian }, -- LFR
    [56068495] = { weaponsmith=true, npc=175521, covenant=Kyrian }, -- Normal
    [57167963] = { weaponsmith=true, npc=175523, covenant=Kyrian }, -- Heroic
    [58238118] = { weaponsmith=true, npc=175524, covenant=Kyrian }, -- Mythic
},

[1708] = { -- Elysisan Hold - Sanctum of Binding
    [63373045] = { vendor=true, npc=174937, covenant=Kyrian },
    [57383012] = { reforge=true, npc=175825, covenant=Kyrian },
    [56893093] = { vendor=true, npc=175823, covenant=Kyrian },

--    [59503420] = { vendor=true, npc=160212, covenant=Kyrian }, -- Seelenwächterin
},

---------------------------------------------NECROLORD----------------------------------------------

[1698] = { -- Seat of the Primus
    [56373149] = { portal=true, label=L["Portal to Oribos"], covenant=Necrolord, sanctumtalent=1052 },

    [61014409] = { weaponsmith=true, npc=175310, covenant=Necrolord }, -- LFR
    [61504564] = { weaponsmith=true, npc=175371, covenant=Necrolord }, -- Normal
    [61424747] = { weaponsmith=true, npc=175312, covenant=Necrolord }, -- Heroic
    [60654872] = { weaponsmith=true, npc=175370, covenant=Necrolord }, -- Mythic

    [57184866] = { vendor=true, npc=175311, covenant=Necrolord }, -- Paktrüstung
    [56234811] = { reforge=true, npc=175314, covenant=Necrolord }, -- Paktrüstungsaufwertungen

    [52724104] = { vendor=true, npc=172176, covenant=Necrolord }, -- Ruhmrüstmeisterin
    [46474023] = { renown=true, npc=175998, covenant=Necrolord }, -- Hüterin des Ruhms
--    [46684234] = { vendor=true, npc=167748, covenant=Necrolord }, -- Seelenwächter

    [42163153] = { anvil=true, npc=173022, covenant=Necrolord }, --

    [46913004] = { innkeeper=true, npc=161994, covenant=Necrolord }, -- Gastwirt
    [48352815] = { mail=true, label=L["Mailbox"], covenant=Necrolord }, -- Briefkasten
},

---------------------------------------------NIGHTFAE-----------------------------------------------

[1565] = { -- Ardenweald
--    [46605126] = { portal=true, label=L["Portal to Oribos"], covenant=Nightfae, sanctumtalent=1055 },
    [48975297] = { stablemaster=true, npc=168082, covenant=Nightfae }, -- Stallmeisterin
},

[1701] = { -- Hearth of the Forest - The Trunk
    [33623696] = { renown=true, npc=176096, covenant=Nightfae }, -- Hüterin des Ruhms
--    [34024355] = { vendor=true, npc=158553, covenant=Nightfae }, -- Seelenwächterin

    [46085651] = { vendor=true, npc=175418, covenant=Nightfae }, -- Rüstungshänderin der Nachtfae
    [46935676] = { reforge=true, npc=175419, covenant=Nightfae }, -- Fortgeschrittene Rüstungsschmiedin der Nachtfae

    [52525602] = { mail=true, label=L["Mailbox"], covenant=Nightfae }, -- Briefkasten
    [54735619] = { innkeeper=true, npc=160292, covenant=Nightfae }, -- Gastwirt
    [55085509] = { anvil=true, npc=158554, covenant=Nightfae }, --
    [60303270] = { vendor=true, npc=174914, covenant=Nightfae }, -- Ruhmrüstmeisterin
    [59473193] = { vendor=true, npc=158556, covenant=Nightfae }, -- Rüstmeisterin der Wilden Jagd

    [88013726] = { stablemaster=true, npc=168082, covenant=Nightfae }, -- Stallmeisterin
},

[1702] = { -- Hearth of the Forest - The Roots
    [59972842] = { portal=true, label=L["Portal to Oribos"], covenant=Nightfae, sanctumtalent=1055 },

    [46695388] = { weaponsmith=true, npc=175413, covenant=Nightfae }, -- LFR
    [48035327] = { weaponsmith=true, npc=175414, covenant=Nightfae }, -- Normal
    [49495377] = { weaponsmith=true, npc=175415, covenant=Nightfae }, -- Heroic
    [51365462] = { weaponsmith=true, npc=175417, covenant=Nightfae }, -- Mythic
},

----------------------------------------------VENTHYR-----------------------------------------------

[1699] = { -- Sinfall Reaches
    -- POTAL MISSING

    [66023348] = { innkeeper=true, npc=166137, covenant=Venthyr }, -- Gastwirt
    [54122456] = { vendor=true, npc=174710, covenant=Venthyr }, -- Ruhmrüstmeisterin
    [60054330] = { anvil=true, npc=166160, covenant=Venthyr}, -- Schmiedebedarf
    [59782904] = { mail=true, label=L["Mailbox"], covenant=Venthyr }, -- Briefkasten
    [54322626] = { renown=true, npc=175772, covenant=Venthyr}, -- Hüterin des Ruhms
--    [45412852] = { anvil=true, npc=164738, covenant=Venthyr}, -- Seelenwächter
},

[1700] = { -- Sinfall Depths
    [54924600] = { weaponsmith=true, npc=174183, covenant=Venthyr }, -- LFR
    [55305433] = { weaponsmith=true, npc=175407, covenant=Venthyr }, -- Normal
    [45406524] = { weaponsmith=true, npc=174709, covenant=Venthyr }, -- Heroic
    [40164648] = { weaponsmith=true, npc=175369, covenant=Venthyr }, -- Mythic
    [70632748] = { vendor=true, npc=175406, covenant=Venthyr}, -- Rüstmeister
    [73022671] = { reforge=true, npc=175408, covenant=Venthyr }, -- Paktrüstungsaufwertungen
    [67404719] = { flightmaster=true, npc=172649, covenant=Venthyr }, -- Oberflächenflieger
},

} -- DB ENDE