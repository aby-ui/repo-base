-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Map = ns.WarfrontMap

local Collectible = ns.node.Collectible
local Rare = ns.Class('WFRare', ns.node.Rare, { questAny=true })

local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy

local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({ id=62, collector=118, settings=true, phased=false })

function map:Prepare ()
    Map.Prepare(self)

    -- Zidormi activates this quest to show the old Darkshore
    self.phased = not C_QuestLog.IsQuestFlaggedCompleted(54411)
end

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[56533078] = Rare({
    id=148787,
    quest={54695, 54696},
    rewards={
        Mount({item=166432, id=1200})
    }
}) -- Alash'anir

map.nodes[37688489] = Rare({
    id=147966,
    quest={54405, 54406}
}) -- Aman

map.nodes[57381568] = Rare({
    id=147744,
    quest={54285, 54286}
}) -- Amberclaw

map.nodes[58472424] = Rare({
    id=147708,
    quest={54278, 54279},
    rewards={
        Toy({item=166784})
    }
}) -- Athrikus Narassin

map.nodes[38037584] = Rare({
    id=148025,
    quest={54426, 54427},
    rewards={
        Toy({item=166787})
    }
}) -- Commander Ral'esh

map.nodes[39326213] = Rare({
    id=147260,
    quest={54232, 54233},
    rewards={
        Pet({item=166451, id=2546})
    }
}) -- Conflagros

map.nodes[43765348] = Rare({
    id=147241,
    quest={54229, 54230},
    rewards={
        Pet({item=166448, id=2545})
    }
}) -- Cyclarus

map.nodes[43531963] = Rare({
    id=149654,
    quest={54884, 54885}
}) -- Glimmerspine

map.nodes[48255561] = Rare({
    id=147261,
    quest={54234, 54235}
}) -- Granokk

map.nodes[40925645] = Rare({
    id=148031,
    quest={54428, 54429},
    rewards={
        Toy({item=166785})
    }
}) -- Gren Tornfur

map.nodes[52423217] = Rare({
    id=147240,
    quest={54227, 54228},
    rewards={
        Pet({item=166452, id=2547})
    }
}) -- Hydrath

map.nodes[43974849] = Rare({
    id=149657,
    quest={54887, 54888}
}) -- Madfeather

map.nodes[35898173] = Rare({
    id=147970,
    quest={54408, 54409}
}) -- Mrggr'marr

map.nodes[47274411] = Rare({
    id=149665,
    quest={54893, 54894}
}) -- Scalefiend

map.nodes[43502943] = Rare({
    id=147751,
    quest={54289, 54290}
}) -- Shattershard

map.nodes[40548527] = Rare({
    id=147897,
    quest={54320, 54321},
    rewards={
        Pet({item=166454, id=2549})
    }
}) -- Soggoth the SLitherer

map.nodes[45485896] = Rare({
    id=147332,
    quest={54247, 54248}
}) -- Stonebinder Ssra'vess

map.nodes[40618267] = Rare({
    id=147942,
    quest={54397, 54398},
    rewards={
        Pet({item=166455, id=2550})
    }
}) -- Twilight Prophet Graeme

------------------------------------ HORDE ------------------------------------

map.nodes[41607640] = Rare({
    id=148037,
    quest=54431,
    faction='Horde',
    rewards={
        Pet({item=166449, id=2544}),
        Mount({item=166803, id=1203})
    }
}) -- Athil Dewfire

map.nodes[49682495] = Rare({
    id=149651,
    quest=54890,
    faction='Horde',
    controllingFaction='Horde',
    rewards={
        Mount({item=166428, id=1199})
    }
}) -- Blackpaw

map.nodes[50703231] = Rare({
    id=149656,
    quest=54891,
    faction='Horde',
    controllingFaction='Horde',
    rewards={
        Pet({item=166528, id=2563})
    }
}) -- Grimhorn

map.nodes[45187494] = Rare({
    id=147758,
    quest=54291,
    faction='Horde',
    rewards={
        Pet({item=166453, id=2548})
    }
}) -- Onu

map.nodes[32768407] = Rare({
    id=148103,
    quest=54452,
    faction='Horde',
    rewards={
        Toy({item=166788})
    }
}) -- Sapper Odette

map.nodes[39763269] = Rare({
    id=149658,
    quest=54892,
    faction='Horde',
    rewards={
        Mount({item=166435, id=1205})
    }
}) -- Shadowclaw

map.nodes[62121651] = Rare({
    id=147435,
    quest=54252,
    faction='Horde',
    rewards={
        Toy({item=166790})
    }
}) -- Thelar Moonstrike

---------------------------------- ALLIANCE -----------------------------------

map.nodes[49502510] = Rare({
    id=149652,
    quest=54883,
    faction='Alliance',
    controllingFaction='Alliance',
    rewards={
        Mount({item=166438, id=1199})
    }
}) -- Agathe Wyrmwood

map.nodes[41607674] = Rare({
    id=149141,
    quest=54768,
    faction='Alliance',
    controllingFaction='Alliance',
    rewards={
        Toy({item=166788}),
        Pet({item=166449, id=2544})
    }
}) -- Burninator Mark V

map.nodes[46528585] = Rare({
    id=147845,
    quest=54309,
    faction='Alliance',
    rewards={
        Toy({item=166790})
    }
}) -- Commander Drald

map.nodes[50703230] = Rare({
    id=149661,
    quest=54886,
    faction='Alliance',
    controllingFaction='Alliance',
    rewards={
        Mount({item=166437, id=1205})
    }
}) -- Croz Bloodrage

map.nodes[67241877] = Rare({
    id=147701,
    quest=54277,
    faction='Alliance',
    rewards={
        Mount({item=166434, id=1203})
    }
}) -- Moxo the Beheader

map.nodes[39663344] = Rare({
    id=149664,
    quest=54889,
    faction='Alliance',
    controllingFaction='Alliance',
    rewards={
        Pet({item=166528, id=2563})
    }
}) -- Orwell Stevenson

map.nodes[62390986] = Rare({
    id=147664,
    quest=54274,
    faction='Alliance',
    rewards={
        Pet({item=166453, id=2548})
    }
}) -- Zim'kaga

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

-- 50552275 54909

-------------------------------------------------------------------------------
------------------------------- FRIGHTENED KODO -------------------------------
-------------------------------------------------------------------------------

map.nodes[41316548] = Collectible({
    id=148790,
    icon=132245,
    note=L["frightened_kodo_note"],
    rewards={
        Mount({item=166433, id=1201}) -- Frightened Kodo
    },
    pois={
        POI({41316548, 44046756, 41275401, 38006600, 39205650, 44006500})
    }
}) -- Frightened Kodo

