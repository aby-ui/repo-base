----------------------------------------------------------------------------------------------------
------------------------------------------AddOn NAMESPACE-------------------------------------------
----------------------------------------------------------------------------------------------------

local FOLDER_NAME, private = ...
local L = private.locale

----------------------------------------------------------------------------------------------------
-----------------------------------------------LOCALS-----------------------------------------------
----------------------------------------------------------------------------------------------------

local function GetMapNames(id1, id2)
    return format("%s, %s", C_Map.GetMapInfo(id1).name, C_Map.GetMapInfo(id2).name)
end

local PtoOG = L["Portal to Orgrimmar"]
local Durotar = GetMapNames(12, 1)
local PtoSW = L["Portal to Stormwind"]
local ElwynnForest = GetMapNames(13, 37)
local RingTransference = L["To Ring of Transference"]
local RingFates = L["To Ring of Fates"]
local IntoTheMaw = L["Into the Maw"]
local Korthia = GetMapNames(1543, 1961)
local KeepersRespite = L["To Keeper's Respite"]

local guildvault = L["config_guildvault"]
local mailbox = L["Mailbox"]

----------------------------------------------------------------------------------------------------
----------------------------------------------DATABASE----------------------------------------------
----------------------------------------------------------------------------------------------------

local DB = {}
private.DB = DB

DB.points = {

[1670] = { -- Ring of Fates
    -- HALL OF SHAPES
    -- Juwe
    [34574459] = { icon="vendor", npc=156733, profession=755, picon="jewelcrafting" },
    [35204130] = { icon="trainer", npc=156670, profession=755, picon="jewelcrafting" },
    -- Engineer
    [37684297] = { icon="vendor", npc=156692, profession=202, picon="engineering" },
    [38074470] = { icon="trainer", npc=156691, profession=202, picon="engineering" },
    [38334378] = { icon="auctioneer", npc=173571, profession=202 },
    -- Inscription
    [35963855] = { icon="vendor", npc=156732, profession=773, picon="inscription" },
    [36503673] = { icon="trainer", npc=156685, profession=773, picon="inscription" },
    [37193554] = { icon="vendor", npc=164736, profession=773, picon="inscription" },
    -- Alchemy
    [38873943] = { icon="vendor", npc=156689, profession=171, picon="alchemy" },
    [39244037] = { icon="trainer", npc=156687, profession=171, picon="alchemy" },
    -- Herbalism
    [40233828] = { icon="trainer", npc=156686, profession=182, picon="herbalism" },

    [38653356] = { icon="anvil", npc=156777 },
    -- Mining
    [39353297] = { icon="trainer", npc=156668, profession=186, picon="mining" },
    -- Blacksmith
    [40473150] = { icon="trainer", npc=156666, profession=164, picon="blacksmithing" },
    -- Skinning
    [42162811] = { icon="trainer", npc=156667, profession=393, picon="skinning" },
    -- Leatherworking
    [42292666] = { icon="trainer", npc=156669, profession=165, picon="leatherworking" },
    [44502653] = { icon="vendor", npc=156696, profession=165, picon="leatherworking" },
    -- Tailor
    [45493182] = { icon="trainer", npc=156681, profession=197, picon="tailoring" },
    -- Cooking
    [47492372] = { icon="vendor", npc=168353, picon="cooking" },
    [46822268] = { icon="trainer", npc=156672, picon="cooking" }, -- , profession=185
    -- Fishing
    [46282576] = { icon="vendor", npc=156690, picon="fishing" },
    [46172640] = { icon="trainer", npc=156671, picon="fishing" }, -- , profession=356
    -- Enchanting
    [48412939] = { icon="trainer", npc=156683, profession=333, picon="enchanting" },
    [47572905] = { icon="vendor", npc=156694, profession=333, picon="enchanting" },

    -- HALL OF HOLDING
    -- Banker
    [59812681] = { icon="banker", npc=156479 },
    [60432950] = { icon="banker", npc=156479 },
    [58693031] = { icon="banker", npc=156479 },
    [58102771] = { icon="banker", npc=156479 },
    [58163602] = { icon="mail", label=mailbox },
    [65203600] = { icon="guildvault", label=guildvault },

    -- THE IDYLLIA
    [62935176] = { icon="mail", label=mailbox },
    [73734910] = { icon="mail", label=mailbox },
    [67485033] = { icon="innkeeper", npc=156688 },

    -- HALL OF CURIOSITIES
    [64456418] = { icon="barber", npc=156735 },
    [65196756] = { icon="vendor", npc=156769 },
    [64596987] = { icon="transmogrifier", npc=156663 },
    [64407055] = { icon="void", npc=156664 },
    [61767215] = { icon="vendor", npc=169524 },
    [59257541] = { icon="stablemaster", npc=156791 },
    [56787554] = { icon="anvil", npc=173369 },
    [56727171] = { icon="vendor", npc=173370 },

    -- THE ENCLAVE
    [47867789] = { icon="vendor", npc=176067 }, -- Quartermaster
    [47577721] = { icon="vendor", npc=176064 }, -- Quartermaster
    [47087695] = { icon="vendor", npc=176065 }, -- Quartermaster
    [46677736] = { icon="vendor", npc=176066 }, -- Quartermaster
    [46227780] = { icon="vendor", npc=176368 }, -- Quartermaster

    [35055815] = { icon="vendor", npc=164095 },
    [34445752] = { icon="vendor", npc=168011 },
    [34645648] = { icon="reforge", npc=164096 },

    [23324895] = { icon="portaltrainer", npc=176186, class="MAGE" },
    [30645226] = { icon="mail", label=mailbox },

    [20835477] = { icon="portal", label=PtoOG, note=Durotar, faction="Horde", quest=60151 },
    [20894567] = { icon="portal", label=PtoSW, note=ElwynnForest, faction="Alliance", quest=60151 },

    [52094278] = { icon="tpplatform", label=RingTransference },
    [57145040] = { icon="tpplatform", label=RingTransference },
    [52095784] = { icon="tpplatform", label=RingTransference },
    [47055029] = { icon="tpplatform", label=RingTransference },
},

[1671] = { -- Ring of Transference
    [49525107] = { icon="portal", label=IntoTheMaw },
    [30702319] = { icon="portal", label=KeepersRespite, note=Korthia, quest=63665 },
    [49504243] = { icon="tpplatform", label=RingFates },
    [55735162] = { icon="tpplatform", label=RingFates },
    [49506073] = { icon="tpplatform", label=RingFates },
    [43375150] = { icon="tpplatform", label=RingFates },

    [67345157] = { icon="kyrian", label=C_Map.GetMapInfo(1533).name },
    [62183266] = { icon="necrolord", label=C_Map.GetMapInfo(1536).name },
    [49587788] = { icon="nightfae", label=C_Map.GetMapInfo(1565).name },
    [32015156] = { icon="venthyr", label=C_Map.GetMapInfo(1525).name },
},

[1672] = {
    [51284300] = { icon="vendor", npc=167881 },
},

} -- DB ENDE