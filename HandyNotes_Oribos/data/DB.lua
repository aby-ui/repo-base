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

----------------------------------------------------------------------------------------------------
----------------------------------------------DATABASE----------------------------------------------
----------------------------------------------------------------------------------------------------

local DB = {}
private.DB = DB

DB.points = {

[1670] = { -- Ring of Fates
    -- HALL OF SHAPES
    -- Juwe
    [34574459] = { vendor=true, npc=156733, profession=755 },
    [35204130] = { trainer=true, npc=156670, profession=755 },
    -- Engineer
    [37684297] = { vendor=true, npc=156692, profession=202 },
    [38074470] = { trainer=true, npc=156691, profession=202 },
    [38334378] = { auctioneer=true, npc=173571, profession=202 },
    -- Inscription
    [35963855] = { vendor=true, npc=156732, profession=773 },
    [36503673] = { trainer=true, npc=156685, profession=773 },
    [37193554] = { vendor=true, npc=164736, profession=773 },
    -- Alchemy
    [38873943] = { vendor=true, npc=156689, profession=171 },
    [39244037] = { trainer=true, npc=156687, profession=171 },
    -- Herbalism
    [40233828] = { trainer=true, npc=156686, profession=182 },

    [38653356] = { anvil=true, npc=156777 },
    -- Mining
    [39353297] = { trainer=true, npc=156668, profession=186 },
    -- Blacksmith
    [40473150] = { trainer=true, npc=156666, profession=164 },
    -- Skinning
    [42162811] = { trainer=true, npc=156667, profession=393 },
    -- Leatherworking
    [42292666] = { trainer=true, npc=156669, profession=165 },
    [44502653] = { vendor=true, npc=156696, profession=165 },
    -- Tailor
    [45493182] = { trainer=true, npc=156681, profession=197 },
    -- Cooking
    [47492372] = { vendor=true, npc=168353 },
    [46822268] = { trainer=true, npc=156672 }, -- , profession=185
    -- Fishing
    [46282576] = { vendor=true, npc=156690 },
    [46172640] = { trainer=true, npc=156671 }, -- , profession=356
    -- Enchanting
    [48412939] = { trainer=true, npc=156683, profession=333 },
    [47572905] = { vendor=true, npc=156694, profession=333 },

    -- HALL OF HOLDING
    -- Banker
    [59812681] = { banker=true, npc=156479 },
    [60432950] = { banker=true, npc=156479 },
    [58693031] = { banker=true, npc=156479 },
    [58102771] = { banker=true, npc=156479 },
--    65203600 "Guild Vault"

    -- THE IDYLLIA
    [62815176] = { mail=true, label=L["Mailbox"] },
    [73854906] = { mail=true, label=L["Mailbox"] },
    [67485033] = { innkeeper=true, npc=156688 },

    -- HALL OF CURIOSITIES
    [64456418] = { barber=true, npc=156735 },
    [65196756] = { vendor=true, npc=156769 },
    [64596987] = { transmogrifier=true, npc=156663 },
    [64407055] = { void=true, npc=156664 },
    [61767215] = { vendor=true, npc=169524 },
    [59257541] = { stablemaster=true, npc=156791 },
    [56787554] = { anvil=true, npc=173369 },
    [56727171] = { vendor=true, npc=173370 },

    -- THE ENCLAVE
    [47867789] = { vendor=true, npc=176067 }, -- Quartermaster
    [47577721] = { vendor=true, npc=176064 }, -- Quartermaster
    [47087695] = { vendor=true, npc=176065 }, -- Quartermaster
    [46677736] = { vendor=true, npc=176066 }, -- Quartermaster
    [46227780] = { vendor=true, npc=176368 }, -- Quartermaster

    [35055815] = { vendor=true, npc=164095 },
    [34445752] = { vendor=true, npc=168011 },
    [34645648] = { reforge=true, npc=164096 },

    [23324895] = { portaltrainer=true, npc=176186, class="MAGE" },

    [20835477] = { portal=true, label=PtoOG, note=Durotar, faction="Horde", quest=60151 },
    [20894567] = { portal=true, label=PtoSW, note=ElwynnForest, faction="Alliance", quest=60151 },

    [52094278] = { tpplatform=true, label=RingTransference },
    [57145040] = { tpplatform=true, label=RingTransference },
    [52095784] = { tpplatform=true, label=RingTransference },
    [47055029] = { tpplatform=true, label=RingTransference },
},

[1671] = { -- Ring of Transference
    [49525107] = { portal=true, label=IntoTheMaw },
    [49504243] = { tpplatform=true, label=RingFates },
    [55735162] = { tpplatform=true, label=RingFates },
    [49506073] = { tpplatform=true, label=RingFates },
    [43375150] = { tpplatform=true, label=RingFates },

    [62183266] = { kyrian=true, label=C_Map.GetMapInfo(1533).name, scale=1.5 },
    [67345157] = { necrolord=true, label=C_Map.GetMapInfo(1536).name, scale=1.5 },
    [49587788] = { nightfae=true, label=C_Map.GetMapInfo(1565).name, scale=1.5 },
    [32015156] = { venthyr=true, label=C_Map.GetMapInfo(1525).name, scale=1.5 },
},

[1672] = {
    [51284300] = { vendor=true, npc=167881 },
},

} -- DB ENDE