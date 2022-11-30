----------------------------------------------------------------------------------------------------
------------------------------------------AddOn NAMESPACE-------------------------------------------
----------------------------------------------------------------------------------------------------

local FOLDER_NAME, private = ...
local L = private.locale

----------------------------------------------------------------------------------------------------
-----------------------------------------------LOCALS-----------------------------------------------
----------------------------------------------------------------------------------------------------

local function GetMapNames(id1, id2)
    if (id1 and id2) then
        return format("%s, %s", C_Map.GetMapInfo(id1).name, C_Map.GetMapInfo(id2).name)
    else
        return C_Map.GetMapInfo(id1).name
    end
end

local Durotar = GetMapNames(12, 1)
local ElwynnForest = GetMapNames(13, 37)
local Pandaria = GetMapNames(424)
local Draenor = GetMapNames(572)
local BrokenIsles = GetMapNames(619)

----------------------------------------------------------------------------------------------------
----------------------------------------------DATABASE----------------------------------------------
----------------------------------------------------------------------------------------------------

local DB = {}
private.DB = DB

DB.points = {
    [2112] = { -- Valdrakken

        [42365930] = { icon = "auctioneer", npc = 185714, sublabel = '' }, -- Imporigo
        [42405995] = { icon = "auctioneer", npc = 197911, sublabel = '' }, -- Antiqdormi
        [42626047] = { icon = "auctioneer", npc = 188661, sublabel = '' }, -- Expordira

        [45565906] = { icon = "mail", label = L["Mailbox"] },
        [48445104] = { icon = "mail", label = L["Mailbox"] },

        [53885502] = {
            icon = "portal",
            multilabel = { L["Portal to Jade Forest"], L["Portal to Shadowmoon Valley"], L["Portal to Dalaran"] },
            multinote = { Pandaria, Draenor, BrokenIsles }
        },

        [73975645] = { icon = "void", npc = 185689 }, -- Vaultkeeper Aleer
        [74485605] = { icon = "transmogrifier", npc = 185570 }, -- Warpweaver Dayelis

        [44046794] = { icon = "flightmaster", npc = 193321 }, -- Aluri

        [46677895] = { icon = "stablemaster", npc = 185561 }, -- Kaestrasz
        [48298294] = { icon = "vendor", npc = 193029 }, -- Lysindra PET SUPPLIES

        [27264736] = { icon = "trainer", npc = 193364 }, -- Lithragosa DRAGONRIDING
        [25835076] = { icon = "trainer", npc = 190839 }, -- Glensera TRANSFORMATION
        [25045064] = { icon = "rostrum", label = L["Rostrum of Transformation"] },

        [25563355] = { icon = "anvil", npc = 196637 }, -- Tethalash
        [26064004] = { icon = "vendor", npc = 195768 }, -- Sorotis


        -- Cascade's Edge
        [39898648] = { icon = "vendor", npc = 197080 }, -- Cadrestrasz


        -- Gladiator's Refuge
        [43064241] = { icon = "vendor", npc = 197553 }, -- Fieldmaster Emberath
        [43374251] = { icon = "anvil", npc = 196191 }, -- Malicia
        [45863872] = { icon = "vendor", npc = 199720 }, -- Glamora
        [45723818] = { icon = "reforge", npc = 199603 }, -- Corxian
        [44763682] = { icon = "vendor", npc = 199601 }, -- Seltherex
        [44313646] = { icon = "vendor", npc = 199599 }, -- Calderax


        -- Little Scales Daycare
        [10425826] = { icon = "vendor", npc = 185563, sublabel = '' }, -- Jyhanna
        -- [12895714] = { icon="vendor", npc=182082 }, -- Agapanthus


        -- The Artisan's Market
        -- Alchemy
        [36387171] = { icon = "trainer", npc = 185545, profession = 171, picon = "alchemy" }, -- Conflago
        -- Alchemy and Inscription
        [36006796] = { icon = "vendor", npc = 185569 }, -- Gohfyrr
        -- Enchanting
        [30806081] = { icon = "vendor", npc = 198587, profession = 333, picon = "enchanting" }, -- Andoris
        [31066137] = { icon = "trainer", npc = 193744, profession = 333, picon = "enchanting" }, -- Soragosa
        -- Fishing, profession=356
        [43987489] = { icon = "vendor", npc = 187783, picon = "fishing" }, -- Pakak
        [44837473] = { icon = "trainer", npc = 185359, picon = "fishing" }, -- Toklo
        -- Herbalism
        [37376687] = { icon = "trainer", npc = 185549, profession = 182, picon = "herbalism" }, -- Agrikus
        -- Inscription
        [38847339] = { icon = "trainer", npc = 185540, profession = 773, picon = "inscription" }, -- Talendara
        -- Juwe
        [39066180] = { icon = "vendor", npc = 198586, profession = 755, picon = "jewelcrafting" }, -- Shakey Flatlap
        [40786113] = { icon = "trainer", npc = 190094, profession = 755, picon = "jewelcrafting" }, -- Tuluradormi
        -- Leatherworking
        [28526132] = { icon = "trainer", npc = 185551, profession = 165, picon = "leatherworking" }, -- Hideshaper Koruz
        [28776236] = { icon = "anvil", npc = 196960, profession = 165, picon = "leatherworking" }, -- Nehmeh
        [28816099] = { icon = "anvil", npc = 195785, profession = 165, picon = "leatherworking" }, -- Samar
        -- Skinning
        [28536036] = { icon = "trainer", npc = 193846, profession = 393, picon = "skinning" }, -- Ralathor the Rugged
        -- Tailor
        [31966720] = { icon = "trainer", npc = 193649, profession = 197, picon = "tailoring" }, -- Threadfinder Fulafong
        [32126626] = { icon = "trainer", npc = 195850, profession = 197, picon = "tailoring" }, -- Threadfinder Pax

        -- [28796431] = { icon="bubble", npc=194480 }, -- Nomi
        [28826631] = { icon = "vendor", npc = 196975 }, -- Zinfandormu
        [29006488] = { icon = "vendor", npc = 196729 }, -- Gorgonzormu
        [29886737] = { icon = "vendor", npc = 195788 }, -- Nallu
        [31286972] = { icon = "vendor", npc = 195783 }, -- Clerk Nemora
        [31626932] = { icon = "vendor", npc = 195782 }, -- Giera
        [34536254] = { icon = "craftingorders", label = L["Crafting Orders"] }, -- CRAFTING ORDERS
        [35425910] = { icon = "vendor", npc = 194057 }, -- Rabul
        [35455968] = { icon = "mail", label = L["Mailbox"] },
        [36436280] = { icon = "vendor", npc = 191000 }, -- Dothenos


        -- The Bronze Enclave
        -- [84075357] = { icon="bubble", label=""Engine of Innovation", quest=70180 },


        -- The Emerals Encalve
        [74506309] = { icon = "vendor", npc = 189197 }, -- Groundskeeper Kama

        [58225436] = { icon = "guildvault", label = L["config_guildvault"] },
        [58205788] = { icon = "vendor", npc = 199605 }, -- Evantkis
        [60015392] = { icon = "banker", npc = 185572 }, -- Vekkalis
        [60575701] = { icon = "banker", npc = 189168 }, -- Aeoreon
        [61085510] = { icon = "banker", npc = 186794 }, -- Numernormi


        -- The Obsidian Enclave
        -- Blacksmith
        [36565063] = { icon = "anvil", npc = 193659, profession = 164, picon = "blacksmithing" }, -- Provisioner Thom
        [36944709] = { icon = "trainer", npc = 185546, profession = 164, picon = "blacksmithing" }, -- Metalshaper Kuroko
        -- Engineer
        [41514881] = { icon = "vendor", npc = 198580, profession = 202, picon = "engineering" }, -- Kognir
        [42244863] = { icon = "trainer", npc = 185548, profession = 202, picon = "engineering" }, -- Clinkyclick Shatterboom
        -- Mining
        [38875149] = { icon = "trainer", npc = 185553, profession = 186, picon = "mining" }, -- Sekita the Burrower

        [35954970] = { icon = "vendor", npc = 195770, sublabel = '' }, -- Armorsmith Terisk
        [36165194] = { icon = "vendor", npc = 195769, sublabel = '' }, -- Weaponsmith Koref
        [37654949] = { icon = "mail", label = L["Mailbox"] },


        -- The Patting Glass
        [72504716] = { icon = "innkeeper", npc = 197574 }, -- Mairadormi


        -- The Roasted Ram
        [46934566] = { icon = "vendor", npc = 188747 }, -- Kitror
        [47444620] = { icon = "innkeeper", npc = 185562 }, -- Tithris
        -- Cooking, profession=185
        [46464620] = { icon = "trainer", npc = 185556, picon = "cooking" }, -- Erugosa


        -- The Ruby Enclave
        [60731615] = { icon = "vendor", npc = 189041 }, -- Coulisa
        [57482359] = { icon = "vendor", npc = 198441 }, -- Gardener Cereus
        -- Alchemy
        [58841839] = { icon = "vendor", npc = 198438, profession = 171, picon = "alchemy" }, -- Gerdener Rafalsia WALKS AROUND


        -- The Sapphire Enclave
        [38093772] = { icon = "vendor", npc = 196516 }, -- Mythressa
        [38443674] = { icon = "vendor", npc = 196598 }, -- Rethelshi


        -- The Seat of the Aspects
        [56603821] = { icon = "portal", label = L["Portal to Orgrimmar"], note = Durotar, faction = "Horde" }, -- , quest=?, level=?
        [59834172] = { icon = "portal", label = L["Portal to Stormwind"], note = ElwynnForest, faction = "Alliance" }, -- , quest=?, level=?
        [61963208] = { icon = "tpplatform", label = L["Teleport to Seat of the Aspects"], level = 64 },
        [58173499] = { icon = "vendor", npc = 193015 }, -- Unatos
        [59204283] = { icon = "portaltrainer", npc = 198895, class = "MAGE" }, -- Alregosa


        -- The Victorious Visage
        [30334817] = { icon = "barber", label = L["Visage of True Self"] },


        -- Weyrnrest
        [22623065] = { icon = "innkeeper", npc = 196640 }, -- Yzinia INNKEEPER BUGGY

    }

} -- DB ENDE
