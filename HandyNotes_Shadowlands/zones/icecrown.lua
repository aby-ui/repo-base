-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.Map

local Intro = ns.node.Intro
local Rare = ns.node.Rare

local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Quest = ns.reward.Quest
local Section = ns.reward.Section
local Transmog = ns.reward.Transmog

local Arrow = ns.poi.Arrow
local POI = ns.poi.POI

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local map = Map({ id=118 })
local nodes = map.nodes

function map:Prepare ()
    Map.Prepare(self)

    -- Hide nodes until the "Return of the Scourge" is completed
    if ns.faction == 'Alliance' then
        self.phased = C_QuestLog.IsQuestFlaggedCompleted(60767)
    else
        self.phased = C_QuestLog.IsQuestFlaggedCompleted(60761)
    end
end

-------------------------------------------------------------------------------
------------------------------------ INTRO ------------------------------------
-------------------------------------------------------------------------------

if UnitFactionGroup('player') == 'Alliance' then
    map.intro = Intro({
        quest=60767,
        note=L["prepatch_intro"],
        rewards={
            Quest({id={60113, 60116, 60117, 59876, 60766, 60767}})
        }
    })
else
    map.intro = Intro({
        quest=60761,
        note=L["prepatch_intro"],
        rewards={
            Quest({id={60115, 60669, 60670, 60725, 60759, 60761}})
        }
    })
end

map.nodes[43905720] = map.intro

-------------------------------------------------------------------------------
--------------------------------- SPAWN TIMES ---------------------------------
-------------------------------------------------------------------------------

local SPAWNS = {}
local EXPECTED = {}

hooksecurefunc(ns.addon, 'OnInitialize', function ()
    SPAWNS = ns.GetDatabaseTable('prepatch', 'spawns')
    EXPECTED = ns.GetDatabaseTable('prepatch', 'expected')

    for npc = 174048, 174067 do
        if SPAWNS[npc] == nil then SPAWNS[npc] = 1 end
    end

    local function UpdateSpawnTimes(startNPC, time)
        EXPECTED[startNPC] = time + 24000 -- 6h40m
        local next = function (id) return (id == 174048) and 174067 or (id - 1) end
        local npc = next(startNPC)
        while npc ~= startNPC do
            time = time + 1200 -- 20 minutes
            EXPECTED[npc] = time
            npc = next(npc)
        end
    end

    ns.addon:RegisterEvent('VIGNETTES_UPDATED', function (...)
        for _, guid in ipairs(C_VignetteInfo.GetVignettes()) do
            local info = C_VignetteInfo.GetVignetteInfo(guid)
            if (info and info.objectGUID and info.onWorldMap) then
                local id = select(6, strsplit("-", info.objectGUID))
                local npc = tonumber(id)
                if SPAWNS[npc] and time() - SPAWNS[npc] > 3600 then
                    SPAWNS[npc] = time()
                    ns.Debug('Detected '..info.name..' spawn at '..date('%H:%M:%S', SPAWNS[npc]))
                    UpdateSpawnTimes(npc, SPAWNS[npc])
                end
            end
        end
    end)
end)

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

local ICCRare = Class('ICCRare', Rare, { fgroup='iccrares' })

function ICCRare.getters:note()
    if EXPECTED[self.id] and time() < EXPECTED[self.id] then
        local spawn = ns.color.Blue(date('%H:%M', EXPECTED[self.id]))
        return L["icecrown_rares"]..'\n\n'..L["next_spawn"]:format(spawn)
    end
    return L["icecrown_rares"]
end

function ICCRare:GetGlow(minimap)
    if EXPECTED[self.id] and EXPECTED[self.id] - time() < 1080 then
        local _, scale, alpha = self:GetDisplayInfo(minimap)
        self.glow.alpha = alpha
        self.glow.scale = scale * 1.1
        self.glow.r, self.glow.g, self.glow.b = 1, 0, 1
        return self.glow
    end
    return ns.node.NPC.GetGlow(self, minimap)
end

local SHARED = {
    ns.reward.Spacer(),
    Section(L["shared_loot"]),
    Transmog({item=183652, slot=L["bow"]}), -- Zod's Echoing Longbow
    Transmog({item=183682, slot=L["cloth"]}), -- Cinch of the Servant
    Transmog({item=183683, slot=L["leather"]}), -- Skittering Vestments
    Transmog({item=183640, slot=L["mail"]}), -- Leggings of Disreputable Charms
    Transmog({item=183654, slot=L["plate"]}), -- Etched Dragonbone Stompers
    Item({item=183616}) -- Accursed Keepsake
}

local function SharedLoot(rewards)
    for i, r in ipairs(SHARED) do
        rewards[#rewards + 1] = r
    end
    table.insert(rewards, 1, Section(L["unique_loot"]))
    return rewards
end

-------------------------------------------------------------------------------

nodes[31607050] = ICCRare({
    id=174067,
    --quest=62345,
    sublabel=L["orig_nax"],
    rlabel='(1)',
    rewards=SharedLoot({
        Transmog({item=183642, slot=L["cloth"]}), -- Robes of Rasped Breaths
        Item({item=183676, note=L["ring"]}) -- Hailstone Loop
    }),
    pois={ POI({44204910}), Arrow({44204910, 31607050}) }
}) -- Noth the Plaguebringer

nodes[36506740] = ICCRare({
    id=174066,
    --quest=62344,
    sublabel=L["orig_nax"],
    rlabel='(2)',
    rewards=SharedLoot({
        Transmog({item=183643, slot=L["2h_axe"]}), -- Severance of Mortality
        Transmog({item=183645, slot=L["leather"]}), -- Cinch of the Tortured
        Transmog({item=183644, slot=L["mail"]}) -- Regurgitator's Shoulderpads
    }),
    pois={ POI({31607050}), Arrow({31607050, 36506740}) }
}) -- Patchwerk

nodes[49703270] = ICCRare({
    id=174065,
    --quest=62343,
    sublabel=L["orig_icc"],
    rlabel='(3)',
    rewards=SharedLoot({
        Transmog({item=183647, slot=L["polearm"]}), -- Bloodspatter
        Transmog({item=183646, slot=L["mail"]}), -- Chestguard of Siphoned Vitality
        Transmog({item=183648, slot=L["plate"]}) -- Veincrusher Gauntlets
    }),
    pois={ POI({36506740}), Arrow({36506740, 49703270}) }
}) -- Blood Queen Lana'thel

nodes[57103030] = ICCRare({
    id=174064,
    --quest=62342,
    sublabel=L["orig_icc"],
    rlabel='(4)',
    rewards=SharedLoot({
        Transmog({item=183649, slot=L["leather"]}), -- Bag of Discarded Entrails
        Transmog({item=183651, slot=L["leather"]}), -- Chestplate of Septic Sutures
        Item({item=183650, note=L["trinket"]}) -- Miniscule Abomination in a Jar
    }),
    pois={ POI({49703270}), Arrow({49703270, 57103030}) }
}) -- Professor Putricide

nodes[51107850] = ICCRare({
    id=174063,
    --quest=62341,
    sublabel=L["orig_icc"],
    rlabel='(5)',
    rewards=SharedLoot({
        Transmog({item=183641, slot=L["cloth"]}), -- Shoulderpads of Corpal Rigidity
        Transmog({item=183653, slot=L["leather"]}), -- Deathwhisper Vestment
        Transmog({item=183655, slot=L["mail"]}) -- Handgrips of Rime and Sleet
    }),
    pois={ POI({57103030}), Arrow({57103030, 51107850}) }
}) -- Lady Deathwhisper

nodes[57805610] = ICCRare({
    id=174062,
    --quest=62340,
    sublabel=L["orig_utp"],
    rlabel='(6)',
    rewards=SharedLoot({
        Transmog({item=183656, slot=L["leather"]}), -- Drake Rider's Jerkin
        Transmog({item=183657, slot=L["mail"]}), -- Skadi's Scaled Sollerets
        Transmog({item=183670, slot=L["plate"]}), -- Skadi's Saronite Belt
        Mount({item=44151, id=264}) -- Reins of the Blue Proto-Drake
    }),
    pois={ POI({51107850}), Arrow({51107850, 57805610}) }
}) -- Skadi the Ruthless

nodes[52305260] = ICCRare({
    id=174061,
    --quest=62339,
    sublabel=L["orig_utk"],
    rlabel='(7)',
    rewards=SharedLoot({
        Transmog({item=183658, slot=L["2h_axe"]}), -- Ingvar's Monolithic Skullcleaver
        Transmog({item=183668, slot=L["leather"]}), -- Razor-Barbed Leather Belt
        Item({item=183659, note=L["ring"]}) -- Annhylde's Band
    }),
    pois={ POI({57805610}), Arrow({57805610, 52305260}) }
}) -- Ingvar the Plunderer

nodes[54004470] = ICCRare({
    id=174060,
    --quest=62338,
    sublabel=L["orig_utk"],
    rlabel='(8)',
    rewards=SharedLoot({
        Transmog({item=183678, slot=L["fist"]}), -- Keleseth's Influencer
        Transmog({item=183679, slot=L["leather"]}), -- Taldaram's Supple Slippers
        Transmog({item=183677, slot=L["mail"]}), -- Blood-Drinker's Belt
        Transmog({item=183661, slot=L["mail"]}), -- Drake Stabler's Gauntlets
        Transmog({item=183680, slot=L["cloak"]}), -- Royal Sanguine Cloak
        Item({item=183625, note=L["neck"]}) -- Reforged Necklace of Taldaram
    }),
    pois={ POI({52305260}), Arrow({52305260, 54004470}) }
}) -- Prince Keleseth

nodes[64802210] = ICCRare({
    id=174059,
    --quest=62337,
    sublabel=L["orig_tot"],
    rlabel='(9)',
    rewards=SharedLoot({
        Transmog({item=183638, slot=L["dagger"]}), -- Phantasmic Kris
        Transmog({item=183637, slot=L["leather"]}), -- Shoulderpads of the Notorious Knave
        Transmog({item=183636, slot=L["plate"]}) -- Helm of the Violent Fracas
    }),
    pois={ POI({54004470}), Arrow({54004470, 64802210}) }
}) -- The Black Knight

nodes[70603850] = ICCRare({
    id=174058,
    --quest=62336,
    sublabel=L["orig_fos"],
    rlabel='(10)',
    rewards=SharedLoot({
        Transmog({item=183675, slot=L["cloth"]}), -- Cold Sweat Mitts
        Transmog({item=183668, slot=L["leather"]}), -- Razor-Barbed Leather Belt
        Transmog({item=183639, slot=L["mail"]}), -- Gaze of Bewilderment
        Transmog({item=183635, slot=L["plate"]}), -- Grieving Gauntlets
        Item({item=183634}) -- Papa's Mint Condition Bag
    }),
    pois={ POI({64802210}), Arrow({64802210, 70603850}) }
}) -- Bronjahm

nodes[47136590] = ICCRare({
    id=174057,
    --quest=62335,
    sublabel=L["orig_pos"],
    rlabel='(11)',
    rewards=SharedLoot({
        Transmog({item=183674, slot=L["cloth"]}), -- Rimewoven Pantaloons
        Transmog({item=183633, slot=L["leather"]}), -- Fringed Wyrmleather Leggings
        Transmog({item=183632, slot=L["shield"]}) -- Protector of Stolen Souls
    }),
    pois={ POI({70603850}), Arrow({70603850, 47136590}) }
}) -- Scourgelord Tyrannus

nodes[59107240] = ICCRare({
    id=174056,
    --quest=62334,
    sublabel=L["orig_pos"],
    rlabel='(12)',
    rewards=SharedLoot({
        Transmog({item=183630, slot=L["2h_axe"]}), -- Garfrost's Two-Ton Bludgeon
        Transmog({item=183666, slot=L["plate"]}), -- Legguards of the Frosty Fathoms
        Item({item=183631, note=L["ring"]}) -- Ring of Carnelian and Sinew
    }),
    pois={ POI({47136590}), Arrow({47136590, 59107240}) }
}) -- Forgemaster Garfrost

nodes[58208350] = ICCRare({
    id=174055,
    --quest=62333,
    sublabel=L["orig_hor"],
    rlabel='(13)',
    rewards=SharedLoot({
        Transmog({item=183687, slot=L["cloth"]}), -- Frayed Flesh-Stitched Shoulderguards
        Transmog({item=183663, slot=L["cloth"]}), -- Sightless Capuchin of Ulmaas
        Transmog({item=183662, slot=L["mail"]}) -- Frostsworn Rattleshirt
    }),
    pois={ POI({59107240}), Arrow({59107240, 58208350}) }
}) -- Marwyn

nodes[50208810] = ICCRare({
    id=174054,
    --quest=62332,
    sublabel=L["orig_hor"],
    rlabel='(14)',
    rewards=SharedLoot({
        Transmog({item=183664, slot=L["cloth"]}), -- Bracer of Ground Molars
        Transmog({item=183665, slot=L["plate"]}), -- Valonforth's Marred Pauldrons
        Transmog({item=183666, slot=L["plate"]}) -- Legguards of the Frosty Fathoms
    }),
    pois={ POI({58208350}), Arrow({58208350, 50208810}) }
}) -- Falric

nodes[80326135] = ICCRare({
    id=174053,
    --quest=62331,
    sublabel=L["orig_dtk"],
    rlabel='(15)',
    rewards=SharedLoot({
        Transmog({item=183686, slot=L["leather"]}), -- Breeches of the Skeletal Serpent
        Transmog({item=183684, slot=L["shield"]}), -- Tharon'ja's Protectorate
        Item({item=183685, note=L["ring"]}) -- Phantasmic Seal of the Prophet
    }),
    pois={ POI({50208810}), Arrow({50208810, 80326135}) }
}) -- The Prophet Tharon'ja

nodes[77806610] = ICCRare({
    id=174052,
    --quest=62330,
    sublabel=L["orig_dtk"],
    rlabel='(16)',
    rewards=SharedLoot({
        Transmog({item=183627, slot=L["1h_mace"]}), -- Summoner's Granite Gavel
        Transmog({item=183671, slot=L["mail"]}), -- Necromantic Wristwraps
        Transmog({item=183672, slot=L["plate"]}) -- Cuirass of Undeath
    }),
    pois={ POI({80326135}), Arrow({80326135, 77806610}) }
}) -- Novos the Summoner

nodes[58303940] = ICCRare({
    id=174051,
    --quest=62329,
    sublabel=L["orig_dtk"],
    rlabel='(17)',
    rewards=SharedLoot({
        Transmog({item=183626, slot=L["2h_sword"]}), -- Troll Gorer
        Transmog({item=183669, slot=L["cloth"]}) -- Cowl of the Rampaging Troll
    }),
    pois={ POI({77806610}), Arrow({77806610, 58303940}) }
}) -- Trollgore

nodes[67505800] = ICCRare({
    id=174050,
    --quest=62328,
    sublabel=L["orig_azn"],
    rlabel='(18)',
    rewards=SharedLoot({
        Transmog({item=183681, slot=L["dagger"]}) -- Webrending Machete
    }),
    pois={ POI({58303940}), Arrow({58303940, 67505800}) }
}) -- Krik'thir the Gatewatcher

nodes[29606220] = ICCRare({
    id=174049,
    --quest=62327,
    sublabel=L["orig_atk"],
    rlabel='(19)',
    rewards=SharedLoot({
        Transmog({item=183678, slot=L["fist"]}), -- Keleseth's Influencer
        Transmog({item=183679, slot=L["leather"]}), -- Taldaram's Supple Slippers
        Transmog({item=183677, slot=L["mail"]}), -- Blood-Drinker's Belt
        Transmog({item=183661, slot=L["mail"]}), -- Drake Stabler's Gauntlets
        Transmog({item=183680, slot=L["cloak"]}), -- Royal Sanguine Cloak
        Item({item=183625, note=L["neck"]}) -- Reforged Necklace of Taldaram
    }),
    pois={ POI({67505800}), Arrow({67505800, 29606220}) }
}) -- Prince Taldaram

nodes[44204910] = ICCRare({
    id=174048,
    --quest=62326,
    sublabel=L["orig_atk"],
    rlabel='(20)',
    rewards=SharedLoot({
        Transmog({item=183641, slot=L["cloth"]}), -- Shoulderpads of Corpal Rigidity
        Transmog({item=183624, slot=L["dagger"]}), -- Serrated Blade of Nadox
        Item({item=183673, note=L["ring"]}) -- Nerubian Aegis Ring
    }),
    pois={ POI({29606220}), Arrow({29606220, 44204910}) }
}) -- Elder Nadox