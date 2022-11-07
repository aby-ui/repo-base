--[[
-- File: ExpansionData.lua
-- Author: enderneko (enderneko-dev@outlook.com)
-- File Created: 2022/08/26 04:40:40 +0800
-- Last Modified: 2022/09/21 16:10:28 +0800
--]]

local _, Cell = ...
local F = Cell.funcs

-------------------------------------------------
-- expansions
-------------------------------------------------
local list = {}

list.enUS = {
    -- "Shadowlands",
    -- "Battle for Azeroth",
    -- "Legion",
    -- "Warlords of Draenor",
    -- "Mists of Pandaria",
    -- "Cataclysm",
    "Wrath of the Lich King",
    "Burning Crusade",
    "Classic",
}

list.zhCN = {
    -- "暗影国度",
    -- "争霸艾泽拉斯",
    -- "军团再临",
    -- "德拉诺之王",
    -- "熊猫人之谜",
    -- "大地的裂变",
    "巫妖王之怒",
    "燃烧的远征",
    "经典旧世",
}

list.zhTW = {
    -- "暗影之境",
    -- "決戰艾澤拉斯",
    -- "軍臨天下",
    -- "德拉諾之霸",
    -- "潘達利亞之謎",
    -- "浩劫與重生",
    "巫妖王之怒",
    "燃燒的遠征",
    "艾澤拉斯",
}

list.koKR = {
    -- "어둠땅",
    -- "격전의 아제로스",
    -- "군단",
    -- "드레노어의 전쟁군주",
    -- "판다리아의 안개",
    -- "대격변",
    "리치 왕의 분노",
    "불타는 성전",
    "오리지널",
}

-------------------------------------------------
-- instances & bosses
-------------------------------------------------
local data = {}

data.enUS = {
    ["Battle for Azeroth"] = {
        {
            ["id"] = 1028,
            ["image"] = 2178279,
            ["name"] = "Azeroth",
            ["bosses"] = {
                {
                    ["id"] = 2378,
                    ["image"] = 3284400,
                    ["name"] = "Grand Empress Shek'zara",
                }, -- [1]
                {
                    ["id"] = 2381,
                    ["image"] = 3284401,
                    ["name"] = "Vuk'laz the Earthbreaker",
                }, -- [2]
                {
                    ["id"] = 2363,
                    ["image"] = 3012063,
                    ["name"] = "Wekemara",
                }, -- [3]
                {
                    ["id"] = 2362,
                    ["image"] = 3012061,
                    ["name"] = "Ulmath, the Soulbinder",
                }, -- [4]
                {
                    ["id"] = 2329,
                    ["image"] = 2497782,
                    ["name"] = "Ivus the Forest Lord",
                }, -- [5]
                {
                    ["id"] = 2212,
                    ["image"] = 2176752,
                    ["name"] = "The Lion's Roar",
                }, -- [6]
                {
                    ["id"] = 2139,
                    ["image"] = 2176755,
                    ["name"] = "T'zane",
                }, -- [7]
                {
                    ["id"] = 2141,
                    ["image"] = 2176734,
                    ["name"] = "Ji'arak",
                }, -- [8]
                {
                    ["id"] = 2197,
                    ["image"] = 2176731,
                    ["name"] = "Hailstone Construct",
                }, -- [9]
                {
                    ["id"] = 2198,
                    ["image"] = 2176760,
                    ["name"] = "Warbringer Yenajz",
                }, -- [10]
                {
                    ["id"] = 2199,
                    ["image"] = 2176716,
                    ["name"] = "Azurethos, The Winged Typhoon",
                }, -- [11]
                {
                    ["id"] = 2210,
                    ["image"] = 2176723,
                    ["name"] = "Dunegorger Kraulok",
                }, -- [12]
            },
        }, -- [1]
        {
            ["id"] = 1031,
            ["image"] = 2178277,
            ["name"] = "Uldir",
            ["bosses"] = {
                {
                    ["id"] = 2168,
                    ["image"] = 2176749,
                    ["name"] = "Taloc",
                }, -- [1]
                {
                    ["id"] = 2167,
                    ["image"] = 2176741,
                    ["name"] = "MOTHER",
                }, -- [2]
                {
                    ["id"] = 2146,
                    ["image"] = 2176725,
                    ["name"] = "Fetid Devourer",
                }, -- [3]
                {
                    ["id"] = 2169,
                    ["image"] = 2176761,
                    ["name"] = "Zek'voz, Herald of N'Zoth",
                }, -- [4]
                {
                    ["id"] = 2166,
                    ["image"] = 2176757,
                    ["name"] = "Vectis",
                }, -- [5]
                {
                    ["id"] = 2195,
                    ["image"] = 2176762,
                    ["name"] = "Zul, Reborn",
                }, -- [6]
                {
                    ["id"] = 2194,
                    ["image"] = 2176742,
                    ["name"] = "Mythrax the Unraveler",
                }, -- [7]
                {
                    ["id"] = 2147,
                    ["image"] = 2176728,
                    ["name"] = "G'huun",
                }, -- [8]
            },
        }, -- [2]
        {
            ["id"] = 1176,
            ["image"] = 2482729,
            ["name"] = "Battle of Dazar'alor",
            ["bosses"] = {
                {
                    ["id"] = 2333,
                    ["image"] = 2497778,
                    ["name"] = "Champion of the Light",
                }, -- [1]
                {
                    ["id"] = 2325,
                    ["image"] = 2497783,
                    ["name"] = "Grong, the Jungle Lord",
                }, -- [2]
                {
                    ["id"] = 2341,
                    ["image"] = 2529383,
                    ["name"] = "Jadefire Masters",
                }, -- [3]
                {
                    ["id"] = 2342,
                    ["image"] = 2497790,
                    ["name"] = "Opulence",
                }, -- [4]
                {
                    ["id"] = 2330,
                    ["image"] = 2497779,
                    ["name"] = "Conclave of the Chosen",
                }, -- [5]
                {
                    ["id"] = 2335,
                    ["image"] = 2497784,
                    ["name"] = "King Rastakhan",
                }, -- [6]
                {
                    ["id"] = 2334,
                    ["image"] = 2497788,
                    ["name"] = "High Tinker Mekkatorque",
                }, -- [7]
                {
                    ["id"] = 2337,
                    ["image"] = 2497786,
                    ["name"] = "Stormwall Blockade",
                }, -- [8]
                {
                    ["id"] = 2343,
                    ["image"] = 2497785,
                    ["name"] = "Lady Jaina Proudmoore",
                }, -- [9]
            },
        }, -- [3]
        {
            ["id"] = 1177,
            ["image"] = 2498193,
            ["name"] = "Crucible of Storms",
            ["bosses"] = {
                {
                    ["id"] = 2328,
                    ["image"] = 2497795,
                    ["name"] = "The Restless Cabal",
                }, -- [1]
                {
                    ["id"] = 2332,
                    ["image"] = 2497794,
                    ["name"] = "Uu'nat, Harbinger of the Void",
                }, -- [2]
            },
        }, -- [4]
        {
            ["id"] = 1179,
            ["image"] = 3025320,
            ["name"] = "The Eternal Palace",
            ["bosses"] = {
                {
                    ["id"] = 2352,
                    ["image"] = 3012047,
                    ["name"] = "Abyssal Commander Sivara",
                }, -- [1]
                {
                    ["id"] = 2347,
                    ["image"] = 3012062,
                    ["name"] = "Blackwater Behemoth",
                }, -- [2]
                {
                    ["id"] = 2353,
                    ["image"] = 3012058,
                    ["name"] = "Radiance of Azshara",
                }, -- [3]
                {
                    ["id"] = 2354,
                    ["image"] = 3012055,
                    ["name"] = "Lady Ashvane",
                }, -- [4]
                {
                    ["id"] = 2351,
                    ["image"] = 3012054,
                    ["name"] = "Orgozoa",
                }, -- [5]
                {
                    ["id"] = 2359,
                    ["image"] = 3012057,
                    ["name"] = "The Queen's Court",
                }, -- [6]
                {
                    ["id"] = 2349,
                    ["image"] = 3012064,
                    ["name"] = "Za'qul, Harbinger of Ny'alotha",
                }, -- [7]
                {
                    ["id"] = 2361,
                    ["image"] = 3012056,
                    ["name"] = "Queen Azshara",
                }, -- [8]
            },
        }, -- [5]
        {
            ["id"] = 1180,
            ["image"] = 3221463,
            ["name"] = "Ny'alotha, the Waking City",
            ["bosses"] = {
                {
                    ["id"] = 2368,
                    ["image"] = 3256385,
                    ["name"] = "Wrathion, the Black Emperor",
                }, -- [1]
                {
                    ["id"] = 2365,
                    ["image"] = 3256380,
                    ["name"] = "Maut",
                }, -- [2]
                {
                    ["id"] = 2369,
                    ["image"] = 3256384,
                    ["name"] = "The Prophet Skitra",
                }, -- [3]
                {
                    ["id"] = 2377,
                    ["image"] = 3256386,
                    ["name"] = "Dark Inquisitor Xanesh",
                }, -- [4]
                {
                    ["id"] = 2372,
                    ["image"] = 3256378,
                    ["name"] = "The Hivemind",
                }, -- [5]
                {
                    ["id"] = 2367,
                    ["image"] = 3256383,
                    ["name"] = "Shad'har the Insatiable",
                }, -- [6]
                {
                    ["id"] = 2373,
                    ["image"] = 3256377,
                    ["name"] = "Drest'agath",
                }, -- [7]
                {
                    ["id"] = 2374,
                    ["image"] = 3256379,
                    ["name"] = "Il'gynoth, Corruption Reborn",
                }, -- [8]
                {
                    ["id"] = 2370,
                    ["image"] = 3257677,
                    ["name"] = "Vexiona",
                }, -- [9]
                {
                    ["id"] = 2364,
                    ["image"] = 3256382,
                    ["name"] = "Ra-den the Despoiled",
                }, -- [10]
                {
                    ["id"] = 2366,
                    ["image"] = 3256376,
                    ["name"] = "Carapace of N'Zoth",
                }, -- [11]
                {
                    ["id"] = 2375,
                    ["image"] = 3256381,
                    ["name"] = "N'Zoth the Corruptor",
                }, -- [12]
            },
        }, -- [6]
        {
            ["id"] = 968,
            ["image"] = 1778892,
            ["name"] = "Atal'Dazar",
            ["bosses"] = {
                {
                    ["id"] = 2082,
                    ["image"] = 1778348,
                    ["name"] = "Priestess Alun'za",
                }, -- [1]
                {
                    ["id"] = 2036,
                    ["image"] = 1778352,
                    ["name"] = "Vol'kaal",
                }, -- [2]
                {
                    ["id"] = 2083,
                    ["image"] = 1778349,
                    ["name"] = "Rezan",
                }, -- [3]
                {
                    ["id"] = 2030,
                    ["image"] = 1778353,
                    ["name"] = "Yazma",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 1001,
            ["image"] = 1778893,
            ["name"] = "Freehold",
            ["bosses"] = {
                {
                    ["id"] = 2102,
                    ["image"] = 1778351,
                    ["name"] = "Skycap'n Kragg",
                }, -- [1]
                {
                    ["id"] = 2093,
                    ["image"] = 1778346,
                    ["name"] = "Council o' Captains",
                }, -- [2]
                {
                    ["id"] = 2094,
                    ["image"] = 1778350,
                    ["name"] = "Ring of Booty",
                }, -- [3]
                {
                    ["id"] = 2095,
                    ["image"] = 1778347,
                    ["name"] = "Harlan Sweete",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 1041,
            ["image"] = 2178269,
            ["name"] = "Kings' Rest",
            ["bosses"] = {
                {
                    ["id"] = 2165,
                    ["image"] = 2176751,
                    ["name"] = "The Golden Serpent",
                }, -- [1]
                {
                    ["id"] = 2171,
                    ["image"] = 2176738,
                    ["name"] = "Mchimba the Embalmer",
                }, -- [2]
                {
                    ["id"] = 2170,
                    ["image"] = 2176750,
                    ["name"] = "The Council of Tribes",
                }, -- [3]
                {
                    ["id"] = 2172,
                    ["image"] = 2176720,
                    ["name"] = "Dazar, The First King",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 1178,
            ["image"] = 3025325,
            ["name"] = "Operation: Mechagon",
            ["bosses"] = {
                {
                    ["id"] = 2357,
                    ["image"] = 3012050,
                    ["name"] = "King Gobbamak",
                }, -- [1]
                {
                    ["id"] = 2358,
                    ["image"] = 3012048,
                    ["name"] = "Gunker",
                }, -- [2]
                {
                    ["id"] = 2360,
                    ["image"] = 3012059,
                    ["name"] = "Trixie & Naeno",
                }, -- [3]
                {
                    ["id"] = 2355,
                    ["image"] = 3012049,
                    ["name"] = "HK-8 Aerial Oppression Unit",
                }, -- [4]
                {
                    ["id"] = 2336,
                    ["image"] = 3012060,
                    ["name"] = "Tussle Tonks",
                }, -- [5]
                {
                    ["id"] = 2339,
                    ["image"] = 3012052,
                    ["name"] = "K.U.-J.0.",
                }, -- [6]
                {
                    ["id"] = 2348,
                    ["image"] = 3012053,
                    ["name"] = "Machinist's Garden",
                }, -- [7]
                {
                    ["id"] = 2331,
                    ["image"] = 3012051,
                    ["name"] = "King Mechagon",
                }, -- [8]
            },
        }, -- [10]
        {
            ["id"] = 1036,
            ["image"] = 2178271,
            ["name"] = "Shrine of the Storm",
            ["bosses"] = {
                {
                    ["id"] = 2153,
                    ["image"] = 2176712,
                    ["name"] = "Aqu'sirr",
                }, -- [1]
                {
                    ["id"] = 2154,
                    ["image"] = 2176754,
                    ["name"] = "Tidesage Council",
                }, -- [2]
                {
                    ["id"] = 2155,
                    ["image"] = 2176737,
                    ["name"] = "Lord Stormsong",
                }, -- [3]
                {
                    ["id"] = 2156,
                    ["image"] = 2176759,
                    ["name"] = "Vol'zith the Whisperer",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 1023,
            ["image"] = 2178272,
            ["name"] = "Siege of Boralus",
            ["bosses"] = {
                {
                    ["id"] = 2133,
                    ["image"] = 2176746,
                    ["name"] = "Sergeant Bainbridge",
                }, -- [1]
                {
                    ["id"] = 2173,
                    ["image"] = 2176722,
                    ["name"] = "Dread Captain Lockwood",
                }, -- [2]
                {
                    ["id"] = 2134,
                    ["image"] = 2176730,
                    ["name"] = "Hadal Darkfathom",
                }, -- [3]
                {
                    ["id"] = 2140,
                    ["image"] = 2176758,
                    ["name"] = "Viq'Goth",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 1030,
            ["image"] = 2178273,
            ["name"] = "Temple of Sethraliss",
            ["bosses"] = {
                {
                    ["id"] = 2142,
                    ["image"] = 2176710,
                    ["name"] = "Adderis and Aspix",
                }, -- [1]
                {
                    ["id"] = 2143,
                    ["image"] = 2176739,
                    ["name"] = "Merektha",
                }, -- [2]
                {
                    ["id"] = 2144,
                    ["image"] = 2176727,
                    ["name"] = "Galvazzt",
                }, -- [3]
                {
                    ["id"] = 2145,
                    ["image"] = 2176713,
                    ["name"] = "Avatar of Sethraliss",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 1012,
            ["image"] = 2178274,
            ["name"] = "The MOTHERLODE!!",
            ["bosses"] = {
                {
                    ["id"] = 2109,
                    ["image"] = 2176718,
                    ["name"] = "Coin-Operated Crowd Pummeler",
                }, -- [1]
                {
                    ["id"] = 2114,
                    ["image"] = 2176714,
                    ["name"] = "Azerokk",
                }, -- [2]
                {
                    ["id"] = 2115,
                    ["image"] = 2176745,
                    ["name"] = "Rixxa Fluxflame",
                }, -- [3]
                {
                    ["id"] = 2116,
                    ["image"] = 2176740,
                    ["name"] = "Mogul Razdunk",
                }, -- [4]
            },
        }, -- [14]
        {
            ["id"] = 1022,
            ["image"] = 2178275,
            ["name"] = "The Underrot",
            ["bosses"] = {
                {
                    ["id"] = 2157,
                    ["image"] = 2176724,
                    ["name"] = "Elder Leaxa",
                }, -- [1]
                {
                    ["id"] = 2131,
                    ["image"] = 2176719,
                    ["name"] = "Cragmaw the Infested",
                }, -- [2]
                {
                    ["id"] = 2130,
                    ["image"] = 2176748,
                    ["name"] = "Sporecaller Zancha",
                }, -- [3]
                {
                    ["id"] = 2158,
                    ["image"] = 2176756,
                    ["name"] = "Unbound Abomination",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 1002,
            ["image"] = 2178276,
            ["name"] = "Tol Dagor",
            ["bosses"] = {
                {
                    ["id"] = 2097,
                    ["image"] = 2176753,
                    ["name"] = "The Sand Queen",
                }, -- [1]
                {
                    ["id"] = 2098,
                    ["image"] = 2176733,
                    ["name"] = "Jes Howlis",
                }, -- [2]
                {
                    ["id"] = 2099,
                    ["image"] = 2176735,
                    ["name"] = "Knight Captain Valyri",
                }, -- [3]
                {
                    ["id"] = 2096,
                    ["image"] = 2176743,
                    ["name"] = "Overseer Korgus",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 1021,
            ["image"] = 2178278,
            ["name"] = "Waycrest Manor",
            ["bosses"] = {
                {
                    ["id"] = 2125,
                    ["image"] = 2176732,
                    ["name"] = "Heartsbane Triad",
                }, -- [1]
                {
                    ["id"] = 2126,
                    ["image"] = 2176747,
                    ["name"] = "Soulbound Goliath",
                }, -- [2]
                {
                    ["id"] = 2127,
                    ["image"] = 2176744,
                    ["name"] = "Raal the Gluttonous",
                }, -- [3]
                {
                    ["id"] = 2128,
                    ["image"] = 2176736,
                    ["name"] = "Lord and Lady Waycrest",
                }, -- [4]
                {
                    ["id"] = 2129,
                    ["image"] = 2176729,
                    ["name"] = "Gorak Tul",
                }, -- [5]
            },
        }, -- [17]
    },
    ["Classic"] = {
        {
            ["id"] = 741,
            ["image"] = 1396586,
            ["name"] = "Molten Core",
            ["bosses"] = {
                {
                    ["id"] = 1519,
                    ["image"] = 1378993,
                    ["name"] = "Lucifron",
                }, -- [1]
                {
                    ["id"] = 1520,
                    ["image"] = 1378995,
                    ["name"] = "Magmadar",
                }, -- [2]
                {
                    ["id"] = 1521,
                    ["image"] = 1378976,
                    ["name"] = "Gehennas",
                }, -- [3]
                {
                    ["id"] = 1522,
                    ["image"] = 1378975,
                    ["name"] = "Garr",
                }, -- [4]
                {
                    ["id"] = 1523,
                    ["image"] = 1379013,
                    ["name"] = "Shazzrah",
                }, -- [5]
                {
                    ["id"] = 1524,
                    ["image"] = 1378966,
                    ["name"] = "Baron Geddon",
                }, -- [6]
                {
                    ["id"] = 1525,
                    ["image"] = 1379015,
                    ["name"] = "Sulfuron Harbinger",
                }, -- [7]
                {
                    ["id"] = 1526,
                    ["image"] = 1378978,
                    ["name"] = "Golemagg the Incinerator",
                }, -- [8]
                {
                    ["id"] = 1527,
                    ["image"] = 1378998,
                    ["name"] = "Majordomo Executus",
                }, -- [9]
                {
                    ["id"] = 1528,
                    ["image"] = 522261,
                    ["name"] = "Ragnaros",
                }, -- [10]
            },
        }, -- [1]
        {
            ["id"] = 742,
            ["image"] = 1396580,
            ["name"] = "Blackwing Lair",
            ["bosses"] = {
                {
                    ["id"] = 1529,
                    ["image"] = 1379008,
                    ["name"] = "Razorgore the Untamed",
                }, -- [1]
                {
                    ["id"] = 1530,
                    ["image"] = 1379022,
                    ["name"] = "Vaelastrasz the Corrupt",
                }, -- [2]
                {
                    ["id"] = 1531,
                    ["image"] = 1378968,
                    ["name"] = "Broodlord Lashlayer",
                }, -- [3]
                {
                    ["id"] = 1532,
                    ["image"] = 1378973,
                    ["name"] = "Firemaw",
                }, -- [4]
                {
                    ["id"] = 1533,
                    ["image"] = 1378971,
                    ["name"] = "Ebonroc",
                }, -- [5]
                {
                    ["id"] = 1534,
                    ["image"] = 1378974,
                    ["name"] = "Flamegor",
                }, -- [6]
                {
                    ["id"] = 1535,
                    ["image"] = 1378969,
                    ["name"] = "Chromaggus",
                }, -- [7]
                {
                    ["id"] = 1536,
                    ["image"] = 1379001,
                    ["name"] = "Nefarian",
                }, -- [8]
            },
        }, -- [2]
        {
            ["id"] = 743,
            ["image"] = 1396591,
            ["name"] = "Ruins of Ahn'Qiraj",
            ["bosses"] = {
                {
                    ["id"] = 1537,
                    ["image"] = 1385749,
                    ["name"] = "Kurinnaxx",
                }, -- [1]
                {
                    ["id"] = 1538,
                    ["image"] = 1385734,
                    ["name"] = "General Rajaxx",
                }, -- [2]
                {
                    ["id"] = 1539,
                    ["image"] = 1385755,
                    ["name"] = "Moam",
                }, -- [3]
                {
                    ["id"] = 1540,
                    ["image"] = 1385723,
                    ["name"] = "Buru the Gorger",
                }, -- [4]
                {
                    ["id"] = 1541,
                    ["image"] = 1385718,
                    ["name"] = "Ayamiss the Hunter",
                }, -- [5]
                {
                    ["id"] = 1542,
                    ["image"] = 1385759,
                    ["name"] = "Ossirian the Unscarred",
                }, -- [6]
            },
        }, -- [3]
        {
            ["id"] = 744,
            ["image"] = 1396593,
            ["name"] = "Temple of Ahn'Qiraj",
            ["bosses"] = {
                {
                    ["id"] = 1543,
                    ["image"] = 1385769,
                    ["name"] = "The Prophet Skeram",
                }, -- [1]
                {
                    ["id"] = 1547,
                    ["image"] = 1390436,
                    ["name"] = "Silithid Royalty",
                }, -- [2]
                {
                    ["id"] = 1544,
                    ["image"] = 1385720,
                    ["name"] = "Battleguard Sartura",
                }, -- [3]
                {
                    ["id"] = 1545,
                    ["image"] = 1385728,
                    ["name"] = "Fankriss the Unyielding",
                }, -- [4]
                {
                    ["id"] = 1548,
                    ["image"] = 1385771,
                    ["name"] = "Viscidus",
                }, -- [5]
                {
                    ["id"] = 1546,
                    ["image"] = 1385761,
                    ["name"] = "Princess Huhuran",
                }, -- [6]
                {
                    ["id"] = 1549,
                    ["image"] = 1390437,
                    ["name"] = "The Twin Emperors",
                }, -- [7]
                {
                    ["id"] = 1550,
                    ["image"] = 1385760,
                    ["name"] = "Ouro",
                }, -- [8]
                {
                    ["id"] = 1551,
                    ["image"] = 1385726,
                    ["name"] = "C'Thun",
                }, -- [9]
            },
        }, -- [4]
        {
            ["id"] = 227,
            ["image"] = 608195,
            ["name"] = "Blackfathom Deeps",
            ["bosses"] = {
                {
                    ["id"] = 368,
                    ["image"] = 1064179,
                    ["name"] = "Ghamoo-Ra",
                }, -- [1]
                {
                    ["id"] = 436,
                    ["image"] = 1064180,
                    ["name"] = "Domina",
                }, -- [2]
                {
                    ["id"] = 426,
                    ["image"] = 522214,
                    ["name"] = "Subjugator Kor'ul",
                }, -- [3]
                {
                    ["id"] = 1145,
                    ["image"] = 1064181,
                    ["name"] = "Thruk",
                }, -- [4]
                {
                    ["id"] = 447,
                    ["image"] = 1064182,
                    ["name"] = "Guardian of the Deep",
                }, -- [5]
                {
                    ["id"] = 1144,
                    ["image"] = 1064183,
                    ["name"] = "Executioner Gore",
                }, -- [6]
                {
                    ["id"] = 437,
                    ["image"] = 1064184,
                    ["name"] = "Twilight Lord Bathiel",
                }, -- [7]
                {
                    ["id"] = 444,
                    ["image"] = 607532,
                    ["name"] = "Aku'mai",
                }, -- [8]
            },
        }, -- [5]
        {
            ["id"] = 228,
            ["image"] = 608196,
            ["name"] = "Blackrock Depths",
            ["bosses"] = {
                {
                    ["id"] = 369,
                    ["image"] = 607644,
                    ["name"] = "High Interrogator Gerstahn",
                }, -- [1]
                {
                    ["id"] = 370,
                    ["image"] = 607697,
                    ["name"] = "Lord Roccor",
                }, -- [2]
                {
                    ["id"] = 371,
                    ["image"] = 607647,
                    ["name"] = "Houndmaster Grebmar",
                }, -- [3]
                {
                    ["id"] = 372,
                    ["image"] = 608314,
                    ["name"] = "Ring of Law",
                }, -- [4]
                {
                    ["id"] = 373,
                    ["image"] = 607749,
                    ["name"] = "Pyromancer Loregrain",
                }, -- [5]
                {
                    ["id"] = 374,
                    ["image"] = 607694,
                    ["name"] = "Lord Incendius",
                }, -- [6]
                {
                    ["id"] = 375,
                    ["image"] = 607814,
                    ["name"] = "Warder Stilgiss",
                }, -- [7]
                {
                    ["id"] = 376,
                    ["image"] = 607602,
                    ["name"] = "Fineous Darkvire",
                }, -- [8]
                {
                    ["id"] = 377,
                    ["image"] = 607549,
                    ["name"] = "Bael'Gar",
                }, -- [9]
                {
                    ["id"] = 378,
                    ["image"] = 607610,
                    ["name"] = "General Angerforge",
                }, -- [10]
                {
                    ["id"] = 379,
                    ["image"] = 607618,
                    ["name"] = "Golem Lord Argelmach",
                }, -- [11]
                {
                    ["id"] = 380,
                    ["image"] = 607650,
                    ["name"] = "Hurley Blackbreath",
                }, -- [12]
                {
                    ["id"] = 381,
                    ["image"] = 607740,
                    ["name"] = "Phalanx",
                }, -- [13]
                {
                    ["id"] = 383,
                    ["image"] = 607741,
                    ["name"] = "Plugger Spazzring",
                }, -- [14]
                {
                    ["id"] = 384,
                    ["image"] = 607535,
                    ["name"] = "Ambassador Flamelash",
                }, -- [15]
                {
                    ["id"] = 385,
                    ["image"] = 607587,
                    ["name"] = "The Seven",
                }, -- [16]
                {
                    ["id"] = 386,
                    ["image"] = 607705,
                    ["name"] = "Magmus",
                }, -- [17]
                {
                    ["id"] = 387,
                    ["image"] = 607595,
                    ["name"] = "Emperor Dagran Thaurissan",
                }, -- [18]
            },
        }, -- [6]
        {
            ["id"] = 63,
            ["image"] = 522352,
            ["name"] = "Deadmines",
            ["bosses"] = {
                {
                    ["id"] = 89,
                    ["image"] = 522228,
                    ["name"] = "Glubtok",
                }, -- [1]
                {
                    ["id"] = 90,
                    ["image"] = 522234,
                    ["name"] = "Helix Gearbreaker",
                }, -- [2]
                {
                    ["id"] = 91,
                    ["image"] = 522225,
                    ["name"] = "Foe Reaper 5000",
                }, -- [3]
                {
                    ["id"] = 92,
                    ["image"] = 522189,
                    ["name"] = "Admiral Ripsnarl",
                }, -- [4]
                {
                    ["id"] = 93,
                    ["image"] = 522210,
                    ["name"] = "\"Captain\" Cookie",
                }, -- [5]
            },
        }, -- [7]
        {
            ["id"] = 230,
            ["image"] = 608200,
            ["name"] = "Dire Maul",
            ["bosses"] = {
                {
                    ["id"] = 402,
                    ["image"] = 607824,
                    ["name"] = "Zevrim Thornhoof",
                }, -- [1]
                {
                    ["id"] = 403,
                    ["image"] = 607653,
                    ["name"] = "Hydrospawn",
                }, -- [2]
                {
                    ["id"] = 404,
                    ["image"] = 607686,
                    ["name"] = "Lethtendris",
                }, -- [3]
                {
                    ["id"] = 405,
                    ["image"] = 607533,
                    ["name"] = "Alzzin the Wildshaper",
                }, -- [4]
                {
                    ["id"] = 406,
                    ["image"] = 607785,
                    ["name"] = "Tendris Warpwood",
                }, -- [5]
                {
                    ["id"] = 407,
                    ["image"] = 607656,
                    ["name"] = "Illyanna Ravenoak",
                }, -- [6]
                {
                    ["id"] = 408,
                    ["image"] = 607703,
                    ["name"] = "Magister Kalendris",
                }, -- [7]
                {
                    ["id"] = 409,
                    ["image"] = 607657,
                    ["name"] = "Immol'thar",
                }, -- [8]
                {
                    ["id"] = 410,
                    ["image"] = 607745,
                    ["name"] = "Prince Tortheldrin",
                }, -- [9]
                {
                    ["id"] = 411,
                    ["image"] = 607630,
                    ["name"] = "Guard Mol'dar",
                }, -- [10]
                {
                    ["id"] = 412,
                    ["image"] = 607777,
                    ["name"] = "Stomper Kreeg",
                }, -- [11]
                {
                    ["id"] = 413,
                    ["image"] = 607629,
                    ["name"] = "Guard Fengus",
                }, -- [12]
                {
                    ["id"] = 414,
                    ["image"] = 607631,
                    ["name"] = "Guard Slip'kik",
                }, -- [13]
                {
                    ["id"] = 415,
                    ["image"] = 607560,
                    ["name"] = "Captain Kromcrush",
                }, -- [14]
                {
                    ["id"] = 416,
                    ["image"] = 607565,
                    ["name"] = "Cho'Rush the Observer",
                }, -- [15]
                {
                    ["id"] = 417,
                    ["image"] = 607673,
                    ["name"] = "King Gordok",
                }, -- [16]
            },
        }, -- [8]
        {
            ["id"] = 231,
            ["image"] = 608202,
            ["name"] = "Gnomeregan",
            ["bosses"] = {
                {
                    ["id"] = 419,
                    ["image"] = 607628,
                    ["name"] = "Grubbis",
                }, -- [1]
                {
                    ["id"] = 420,
                    ["image"] = 607808,
                    ["name"] = "Viscous Fallout",
                }, -- [2]
                {
                    ["id"] = 421,
                    ["image"] = 607594,
                    ["name"] = "Electrocutioner 6000",
                }, -- [3]
                {
                    ["id"] = 418,
                    ["image"] = 607572,
                    ["name"] = "Crowd Pummeler 9-60",
                }, -- [4]
                {
                    ["id"] = 422,
                    ["image"] = 607714,
                    ["name"] = "Mekgineer Thermaplugg",
                }, -- [5]
            },
        }, -- [9]
        {
            ["id"] = 229,
            ["image"] = 608197,
            ["name"] = "Lower Blackrock Spire",
            ["bosses"] = {
                {
                    ["id"] = 388,
                    ["image"] = 607645,
                    ["name"] = "Highlord Omokk",
                }, -- [1]
                {
                    ["id"] = 389,
                    ["image"] = 607769,
                    ["name"] = "Shadow Hunter Vosh'gajin",
                }, -- [2]
                {
                    ["id"] = 390,
                    ["image"] = 607810,
                    ["name"] = "War Master Voone",
                }, -- [3]
                {
                    ["id"] = 391,
                    ["image"] = 607719,
                    ["name"] = "Mother Smolderweb",
                }, -- [4]
                {
                    ["id"] = 392,
                    ["image"] = 607801,
                    ["name"] = "Urok Doomhowl",
                }, -- [5]
                {
                    ["id"] = 393,
                    ["image"] = 607751,
                    ["name"] = "Quartermaster Zigris",
                }, -- [6]
                {
                    ["id"] = 394,
                    ["image"] = 607634,
                    ["name"] = "Halycon",
                }, -- [7]
                {
                    ["id"] = 395,
                    ["image"] = 607615,
                    ["name"] = "Gizrul the Slavener",
                }, -- [8]
                {
                    ["id"] = 396,
                    ["image"] = 607737,
                    ["name"] = "Overlord Wyrmthalak",
                }, -- [9]
            },
        }, -- [10]
        {
            ["id"] = 232,
            ["image"] = 608209,
            ["name"] = "Maraudon",
            ["bosses"] = {
                {
                    ["id"] = 423,
                    ["image"] = 607728,
                    ["name"] = "Noxxion",
                }, -- [1]
                {
                    ["id"] = 424,
                    ["image"] = 607756,
                    ["name"] = "Razorlash",
                }, -- [2]
                {
                    ["id"] = 425,
                    ["image"] = 607796,
                    ["name"] = "Tinkerer Gizlock",
                }, -- [3]
                {
                    ["id"] = 427,
                    ["image"] = 607699,
                    ["name"] = "Lord Vyletongue",
                }, -- [4]
                {
                    ["id"] = 428,
                    ["image"] = 607562,
                    ["name"] = "Celebras the Cursed",
                }, -- [5]
                {
                    ["id"] = 429,
                    ["image"] = 607684,
                    ["name"] = "Landslide",
                }, -- [6]
                {
                    ["id"] = 430,
                    ["image"] = 607761,
                    ["name"] = "Rotgrip",
                }, -- [7]
                {
                    ["id"] = 431,
                    ["image"] = 607747,
                    ["name"] = "Princess Theradras",
                }, -- [8]
            },
        }, -- [11]
        {
            ["id"] = 226,
            ["image"] = 608211,
            ["name"] = "Ragefire Chasm",
            ["bosses"] = {
                {
                    ["id"] = 694,
                    ["image"] = 608309,
                    ["name"] = "Adarogg",
                }, -- [1]
                {
                    ["id"] = 695,
                    ["image"] = 608310,
                    ["name"] = "Dark Shaman Koranthal",
                }, -- [2]
                {
                    ["id"] = 696,
                    ["image"] = 522251,
                    ["name"] = "Slagmaw",
                }, -- [3]
                {
                    ["id"] = 697,
                    ["image"] = 608315,
                    ["name"] = "Lava Guard Gordoth",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 233,
            ["image"] = 608212,
            ["name"] = "Razorfen Downs",
            ["bosses"] = {
                {
                    ["id"] = 1142,
                    ["image"] = 607633,
                    ["name"] = "Aarux",
                }, -- [1]
                {
                    ["id"] = 433,
                    ["image"] = 607718,
                    ["name"] = "Mordresh Fire Eye",
                }, -- [2]
                {
                    ["id"] = 1143,
                    ["image"] = 1064178,
                    ["name"] = "Mushlump",
                }, -- [3]
                {
                    ["id"] = 1146,
                    ["image"] = 607584,
                    ["name"] = "Death Speaker Blackthorn",
                }, -- [4]
                {
                    ["id"] = 1141,
                    ["image"] = 607537,
                    ["name"] = "Amnennar the Coldbringer",
                }, -- [5]
            },
        }, -- [13]
        {
            ["id"] = 234,
            ["image"] = 608213,
            ["name"] = "Razorfen Kraul",
            ["bosses"] = {
                {
                    ["id"] = 896,
                    ["image"] = 607531,
                    ["name"] = "Hunter Bonetusk",
                }, -- [1]
                {
                    ["id"] = 895,
                    ["image"] = 607760,
                    ["name"] = "Roogug",
                }, -- [2]
                {
                    ["id"] = 899,
                    ["image"] = 607736,
                    ["name"] = "Warlord Ramtusk",
                }, -- [3]
                {
                    ["id"] = 900,
                    ["image"] = 1064175,
                    ["name"] = "Groyat, the Blind Hunter",
                }, -- [4]
                {
                    ["id"] = 901,
                    ["image"] = 607563,
                    ["name"] = "Charlga Razorflank",
                }, -- [5]
            },
        }, -- [14]
        {
            ["id"] = 311,
            ["image"] = 643262,
            ["name"] = "Scarlet Halls",
            ["bosses"] = {
                {
                    ["id"] = 660,
                    ["image"] = 630833,
                    ["name"] = "Houndmaster Braun",
                }, -- [1]
                {
                    ["id"] = 654,
                    ["image"] = 630816,
                    ["name"] = "Armsmaster Harlan",
                }, -- [2]
                {
                    ["id"] = 656,
                    ["image"] = 630825,
                    ["name"] = "Flameweaver Koegler",
                }, -- [3]
            },
        }, -- [15]
        {
            ["id"] = 316,
            ["image"] = 608214,
            ["name"] = "Scarlet Monastery",
            ["bosses"] = {
                {
                    ["id"] = 688,
                    ["image"] = 630853,
                    ["name"] = "Thalnos the Soulrender",
                }, -- [1]
                {
                    ["id"] = 671,
                    ["image"] = 630818,
                    ["name"] = "Brother Korloff",
                }, -- [2]
                {
                    ["id"] = 674,
                    ["image"] = 607643,
                    ["name"] = "High Inquisitor Whitemane",
                }, -- [3]
            },
        }, -- [16]
        {
            ["id"] = 246,
            ["image"] = 608215,
            ["name"] = "Scholomance",
            ["bosses"] = {
                {
                    ["id"] = 659,
                    ["image"] = 630835,
                    ["name"] = "Instructor Chillheart",
                }, -- [1]
                {
                    ["id"] = 663,
                    ["image"] = 607666,
                    ["name"] = "Jandice Barov",
                }, -- [2]
                {
                    ["id"] = 665,
                    ["image"] = 607755,
                    ["name"] = "Rattlegore",
                }, -- [3]
                {
                    ["id"] = 666,
                    ["image"] = 630838,
                    ["name"] = "Lilian Voss",
                }, -- [4]
                {
                    ["id"] = 684,
                    ["image"] = 607582,
                    ["name"] = "Darkmaster Gandling",
                }, -- [5]
            },
        }, -- [17]
        {
            ["id"] = 64,
            ["image"] = 522358,
            ["name"] = "Shadowfang Keep",
            ["bosses"] = {
                {
                    ["id"] = 96,
                    ["image"] = 522205,
                    ["name"] = "Baron Ashbury",
                }, -- [1]
                {
                    ["id"] = 97,
                    ["image"] = 522206,
                    ["name"] = "Baron Silverlaine",
                }, -- [2]
                {
                    ["id"] = 98,
                    ["image"] = 522213,
                    ["name"] = "Commander Springvale",
                }, -- [3]
                {
                    ["id"] = 99,
                    ["image"] = 522249,
                    ["name"] = "Lord Walden",
                }, -- [4]
                {
                    ["id"] = 100,
                    ["image"] = 522247,
                    ["name"] = "Lord Godfrey",
                }, -- [5]
            },
        }, -- [18]
        {
            ["id"] = 236,
            ["image"] = 608216,
            ["name"] = "Stratholme",
            ["bosses"] = {
                {
                    ["id"] = 443,
                    ["image"] = 607637,
                    ["name"] = "Hearthsinger Forresten",
                }, -- [1]
                {
                    ["id"] = 445,
                    ["image"] = 607795,
                    ["name"] = "Timmy the Cruel",
                }, -- [2]
                {
                    ["id"] = 749,
                    ["image"] = 607569,
                    ["name"] = "Commander Malor",
                }, -- [3]
                {
                    ["id"] = 446,
                    ["image"] = 607818,
                    ["name"] = "Willey Hopebreaker",
                }, -- [4]
                {
                    ["id"] = 448,
                    ["image"] = 607660,
                    ["name"] = "Instructor Galford",
                }, -- [5]
                {
                    ["id"] = 449,
                    ["image"] = 607551,
                    ["name"] = "Balnazzar",
                }, -- [6]
                {
                    ["id"] = 450,
                    ["image"] = 607792,
                    ["name"] = "The Unforgiven",
                }, -- [7]
                {
                    ["id"] = 451,
                    ["image"] = 607553,
                    ["name"] = "Baroness Anastari",
                }, -- [8]
                {
                    ["id"] = 452,
                    ["image"] = 607724,
                    ["name"] = "Nerub'enkan",
                }, -- [9]
                {
                    ["id"] = 453,
                    ["image"] = 607707,
                    ["name"] = "Maleki the Pallid",
                }, -- [10]
                {
                    ["id"] = 454,
                    ["image"] = 607791,
                    ["name"] = "Magistrate Barthilas",
                }, -- [11]
                {
                    ["id"] = 455,
                    ["image"] = 607752,
                    ["name"] = "Ramstein the Gorger",
                }, -- [12]
                {
                    ["id"] = 456,
                    ["image"] = 607692,
                    ["name"] = "Lord Aurius Rivendare",
                }, -- [13]
            },
        }, -- [19]
        {
            ["id"] = 238,
            ["image"] = 608223,
            ["name"] = "The Stockade",
            ["bosses"] = {
                {
                    ["id"] = 464,
                    ["image"] = 607646,
                    ["name"] = "Hogger",
                }, -- [1]
                {
                    ["id"] = 465,
                    ["image"] = 607695,
                    ["name"] = "Lord Overheat",
                }, -- [2]
                {
                    ["id"] = 466,
                    ["image"] = 607753,
                    ["name"] = "Randolph Moloch",
                }, -- [3]
            },
        }, -- [20]
        {
            ["id"] = 237,
            ["image"] = 608217,
            ["name"] = "The Temple of Atal'hakkar",
            ["bosses"] = {
                {
                    ["id"] = 457,
                    ["image"] = 607548,
                    ["name"] = "Avatar of Hakkar",
                }, -- [1]
                {
                    ["id"] = 458,
                    ["image"] = 607665,
                    ["name"] = "Jammal'an the Prophet",
                }, -- [2]
                {
                    ["id"] = 459,
                    ["image"] = 608311,
                    ["name"] = "Wardens of the Dream",
                }, -- [3]
                {
                    ["id"] = 463,
                    ["image"] = 607768,
                    ["name"] = "Shade of Eranikus",
                }, -- [4]
            },
        }, -- [21]
        {
            ["id"] = 239,
            ["image"] = 608225,
            ["name"] = "Uldaman",
            ["bosses"] = {
                {
                    ["id"] = 467,
                    ["image"] = 607757,
                    ["name"] = "Revelosh",
                }, -- [1]
                {
                    ["id"] = 468,
                    ["image"] = 607550,
                    ["name"] = "The Lost Dwarves",
                }, -- [2]
                {
                    ["id"] = 469,
                    ["image"] = 607664,
                    ["name"] = "Ironaya",
                }, -- [3]
                {
                    ["id"] = 748,
                    ["image"] = 607729,
                    ["name"] = "Obsidian Sentinel",
                }, -- [4]
                {
                    ["id"] = 470,
                    ["image"] = 607538,
                    ["name"] = "Ancient Stone Keeper",
                }, -- [5]
                {
                    ["id"] = 471,
                    ["image"] = 607606,
                    ["name"] = "Galgann Firehammer",
                }, -- [6]
                {
                    ["id"] = 472,
                    ["image"] = 607626,
                    ["name"] = "Grimlok",
                }, -- [7]
                {
                    ["id"] = 473,
                    ["image"] = 607546,
                    ["name"] = "Archaedas",
                }, -- [8]
            },
        }, -- [22]
        {
            ["id"] = 240,
            ["image"] = 608229,
            ["name"] = "Wailing Caverns",
            ["bosses"] = {
                {
                    ["id"] = 474,
                    ["image"] = 607680,
                    ["name"] = "Lady Anacondra",
                }, -- [1]
                {
                    ["id"] = 476,
                    ["image"] = 607696,
                    ["name"] = "Lord Pythas",
                }, -- [2]
                {
                    ["id"] = 475,
                    ["image"] = 607693,
                    ["name"] = "Lord Cobrahn",
                }, -- [3]
                {
                    ["id"] = 477,
                    ["image"] = 607676,
                    ["name"] = "Kresh",
                }, -- [4]
                {
                    ["id"] = 478,
                    ["image"] = 607775,
                    ["name"] = "Skum",
                }, -- [5]
                {
                    ["id"] = 479,
                    ["image"] = 607698,
                    ["name"] = "Lord Serpentis",
                }, -- [6]
                {
                    ["id"] = 480,
                    ["image"] = 607805,
                    ["name"] = "Verdan the Everliving",
                }, -- [7]
                {
                    ["id"] = 481,
                    ["image"] = 607721,
                    ["name"] = "Mutanus the Devourer",
                }, -- [8]
            },
        }, -- [23]
        {
            ["id"] = 241,
            ["image"] = 608230,
            ["name"] = "Zul'Farrak",
            ["bosses"] = {
                {
                    ["id"] = 483,
                    ["image"] = 607614,
                    ["name"] = "Gahz'rilla",
                }, -- [1]
                {
                    ["id"] = 484,
                    ["image"] = 607541,
                    ["name"] = "Antu'sul",
                }, -- [2]
                {
                    ["id"] = 485,
                    ["image"] = 607793,
                    ["name"] = "Theka the Martyr",
                }, -- [3]
                {
                    ["id"] = 486,
                    ["image"] = 607819,
                    ["name"] = "Witch Doctor Zum'rah",
                }, -- [4]
                {
                    ["id"] = 487,
                    ["image"] = 607723,
                    ["name"] = "Nekrum & Sezz'ziz",
                }, -- [5]
                {
                    ["id"] = 489,
                    ["image"] = 607564,
                    ["name"] = "Chief Ukorz Sandscalp",
                }, -- [6]
            },
        }, -- [24]
    },
    ["Burning Crusade"] = {
        {
            ["id"] = 745,
            ["image"] = 1396584,
            ["name"] = "Karazhan",
            ["bosses"] = {
                {
                    ["id"] = 1552,
                    ["image"] = 1385766,
                    ["name"] = "Servant's Quarters",
                }, -- [1]
                {
                    ["id"] = 1553,
                    ["image"] = 1378965,
                    ["name"] = "Attumen the Huntsman",
                }, -- [2]
                {
                    ["id"] = 1554,
                    ["image"] = 1378999,
                    ["name"] = "Moroes",
                }, -- [3]
                {
                    ["id"] = 1555,
                    ["image"] = 1378997,
                    ["name"] = "Maiden of Virtue",
                }, -- [4]
                {
                    ["id"] = 1556,
                    ["image"] = 1385758,
                    ["name"] = "Opera Hall",
                }, -- [5]
                {
                    ["id"] = 1557,
                    ["image"] = 1379020,
                    ["name"] = "The Curator",
                }, -- [6]
                {
                    ["id"] = 1559,
                    ["image"] = 1379012,
                    ["name"] = "Shade of Aran",
                }, -- [7]
                {
                    ["id"] = 1560,
                    ["image"] = 1379017,
                    ["name"] = "Terestian Illhoof",
                }, -- [8]
                {
                    ["id"] = 1561,
                    ["image"] = 1379002,
                    ["name"] = "Netherspite",
                }, -- [9]
                {
                    ["id"] = 1764,
                    ["image"] = 1385724,
                    ["name"] = "Chess Event",
                }, -- [10]
                {
                    ["id"] = 1563,
                    ["image"] = 1379006,
                    ["name"] = "Prince Malchezaar",
                }, -- [11]
            },
        }, -- [1]
        {
            ["id"] = 746,
            ["image"] = 1396582,
            ["name"] = "Gruul's Lair",
            ["bosses"] = {
                {
                    ["id"] = 1564,
                    ["image"] = 1378985,
                    ["name"] = "High King Maulgar",
                }, -- [1]
                {
                    ["id"] = 1565,
                    ["image"] = 1378982,
                    ["name"] = "Gruul the Dragonkiller",
                }, -- [2]
            },
        }, -- [2]
        {
            ["id"] = 747,
            ["image"] = 1396585,
            ["name"] = "Magtheridon's Lair",
            ["bosses"] = {
                {
                    ["id"] = 1566,
                    ["image"] = 1378996,
                    ["name"] = "Magtheridon",
                }, -- [1]
            },
        }, -- [3]
        {
            ["id"] = 748,
            ["image"] = 608199,
            ["name"] = "Serpentshrine Cavern",
            ["bosses"] = {
                {
                    ["id"] = 1567,
                    ["image"] = 1385741,
                    ["name"] = "Hydross the Unstable",
                }, -- [1]
                {
                    ["id"] = 1568,
                    ["image"] = 1385768,
                    ["name"] = "The Lurker Below",
                }, -- [2]
                {
                    ["id"] = 1569,
                    ["image"] = 1385751,
                    ["name"] = "Leotheras the Blind",
                }, -- [3]
                {
                    ["id"] = 1570,
                    ["image"] = 1385729,
                    ["name"] = "Fathom-Lord Karathress",
                }, -- [4]
                {
                    ["id"] = 1571,
                    ["image"] = 1385756,
                    ["name"] = "Morogrim Tidewalker",
                }, -- [5]
                {
                    ["id"] = 1572,
                    ["image"] = 1385750,
                    ["name"] = "Lady Vashj",
                }, -- [6]
            },
        }, -- [4]
        {
            ["id"] = 749,
            ["image"] = 608218,
            ["name"] = "The Eye",
            ["bosses"] = {
                {
                    ["id"] = 1573,
                    ["image"] = 1385712,
                    ["name"] = "Al'ar",
                }, -- [1]
                {
                    ["id"] = 1574,
                    ["image"] = 1385772,
                    ["name"] = "Void Reaver",
                }, -- [2]
                {
                    ["id"] = 1575,
                    ["image"] = 1385739,
                    ["name"] = "High Astromancer Solarian",
                }, -- [3]
                {
                    ["id"] = 1576,
                    ["image"] = 607669,
                    ["name"] = "Kael'thas Sunstrider",
                }, -- [4]
            },
        }, -- [5]
        {
            ["id"] = 750,
            ["image"] = 608198,
            ["name"] = "The Battle for Mount Hyjal",
            ["bosses"] = {
                {
                    ["id"] = 1577,
                    ["image"] = 1385762,
                    ["name"] = "Rage Winterchill",
                }, -- [1]
                {
                    ["id"] = 1578,
                    ["image"] = 1385714,
                    ["name"] = "Anetheron",
                }, -- [2]
                {
                    ["id"] = 1579,
                    ["image"] = 1385745,
                    ["name"] = "Kaz'rogal",
                }, -- [3]
                {
                    ["id"] = 1580,
                    ["image"] = 1385719,
                    ["name"] = "Azgalor",
                }, -- [4]
                {
                    ["id"] = 1581,
                    ["image"] = 1385716,
                    ["name"] = "Archimonde",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 751,
            ["image"] = 1396579,
            ["name"] = "Black Temple",
            ["bosses"] = {
                {
                    ["id"] = 1582,
                    ["image"] = 1378986,
                    ["name"] = "High Warlord Naj'entus",
                }, -- [1]
                {
                    ["id"] = 1583,
                    ["image"] = 1379016,
                    ["name"] = "Supremus",
                }, -- [2]
                {
                    ["id"] = 1584,
                    ["image"] = 1379011,
                    ["name"] = "Shade of Akama",
                }, -- [3]
                {
                    ["id"] = 1585,
                    ["image"] = 1379018,
                    ["name"] = "Teron Gorefiend",
                }, -- [4]
                {
                    ["id"] = 1586,
                    ["image"] = 1378983,
                    ["name"] = "Gurtogg Bloodboil",
                }, -- [5]
                {
                    ["id"] = 1587,
                    ["image"] = 1385764,
                    ["name"] = "Reliquary of Souls",
                }, -- [6]
                {
                    ["id"] = 1588,
                    ["image"] = 1379000,
                    ["name"] = "Mother Shahraz",
                }, -- [7]
                {
                    ["id"] = 1589,
                    ["image"] = 1385743,
                    ["name"] = "The Illidari Council",
                }, -- [8]
                {
                    ["id"] = 1590,
                    ["image"] = 1378987,
                    ["name"] = "Illidan Stormrage",
                }, -- [9]
            },
        }, -- [7]
        {
            ["id"] = 752,
            ["image"] = 1396592,
            ["name"] = "Sunwell Plateau",
            ["bosses"] = {
                {
                    ["id"] = 1591,
                    ["image"] = 1385744,
                    ["name"] = "Kalecgos",
                }, -- [1]
                {
                    ["id"] = 1592,
                    ["image"] = 1385722,
                    ["name"] = "Brutallus",
                }, -- [2]
                {
                    ["id"] = 1593,
                    ["image"] = 1385730,
                    ["name"] = "Felmyst",
                }, -- [3]
                {
                    ["id"] = 1594,
                    ["image"] = 1390438,
                    ["name"] = "The Eredar Twins",
                }, -- [4]
                {
                    ["id"] = 1595,
                    ["image"] = 1385757,
                    ["name"] = "M'uru",
                }, -- [5]
                {
                    ["id"] = 1596,
                    ["image"] = 1385746,
                    ["name"] = "Kil'jaeden",
                }, -- [6]
            },
        }, -- [8]
        {
            ["id"] = 247,
            ["image"] = 608193,
            ["name"] = "Auchenai Crypts",
            ["bosses"] = {
                {
                    ["id"] = 523,
                    ["image"] = 607771,
                    ["name"] = "Shirrak the Dead Watcher",
                }, -- [1]
                {
                    ["id"] = 524,
                    ["image"] = 607600,
                    ["name"] = "Exarch Maladaar",
                }, -- [2]
            },
        }, -- [9]
        {
            ["id"] = 248,
            ["image"] = 608207,
            ["name"] = "Hellfire Ramparts",
            ["bosses"] = {
                {
                    ["id"] = 527,
                    ["image"] = 607817,
                    ["name"] = "Watchkeeper Gargolmar",
                }, -- [1]
                {
                    ["id"] = 528,
                    ["image"] = 607734,
                    ["name"] = "Omor the Unscarred",
                }, -- [2]
                {
                    ["id"] = 529,
                    ["image"] = 607803,
                    ["name"] = "Vazruden the Herald",
                }, -- [3]
            },
        }, -- [10]
        {
            ["id"] = 249,
            ["image"] = 608208,
            ["name"] = "Magisters' Terrace",
            ["bosses"] = {
                {
                    ["id"] = 530,
                    ["image"] = 607767,
                    ["name"] = "Selin Fireheart",
                }, -- [1]
                {
                    ["id"] = 531,
                    ["image"] = 607806,
                    ["name"] = "Vexallus",
                }, -- [2]
                {
                    ["id"] = 532,
                    ["image"] = 607742,
                    ["name"] = "Priestess Delrissa",
                }, -- [3]
                {
                    ["id"] = 533,
                    ["image"] = 607669,
                    ["name"] = "Kael'thas Sunstrider",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 250,
            ["image"] = 608193,
            ["name"] = "Mana-Tombs",
            ["bosses"] = {
                {
                    ["id"] = 534,
                    ["image"] = 607738,
                    ["name"] = "Pandemonius",
                }, -- [1]
                {
                    ["id"] = 535,
                    ["image"] = 607782,
                    ["name"] = "Tavarok",
                }, -- [2]
                {
                    ["id"] = 537,
                    ["image"] = 607726,
                    ["name"] = "Nexus-Prince Shaffar",
                }, -- [3]
            },
        }, -- [12]
        {
            ["id"] = 251,
            ["image"] = 608198,
            ["name"] = "Old Hillsbrad Foothills",
            ["bosses"] = {
                {
                    ["id"] = 538,
                    ["image"] = 607689,
                    ["name"] = "Lieutenant Drake",
                }, -- [1]
                {
                    ["id"] = 539,
                    ["image"] = 607561,
                    ["name"] = "Captain Skarloc",
                }, -- [2]
                {
                    ["id"] = 540,
                    ["image"] = 607596,
                    ["name"] = "Epoch Hunter",
                }, -- [3]
            },
        }, -- [13]
        {
            ["id"] = 252,
            ["image"] = 608193,
            ["name"] = "Sethekk Halls",
            ["bosses"] = {
                {
                    ["id"] = 541,
                    ["image"] = 607583,
                    ["name"] = "Darkweaver Syth",
                }, -- [1]
                {
                    ["id"] = 543,
                    ["image"] = 607780,
                    ["name"] = "Talon King Ikiss",
                }, -- [2]
            },
        }, -- [14]
        {
            ["id"] = 253,
            ["image"] = 608193,
            ["name"] = "Shadow Labyrinth",
            ["bosses"] = {
                {
                    ["id"] = 544,
                    ["image"] = 607536,
                    ["name"] = "Ambassador Hellmaw",
                }, -- [1]
                {
                    ["id"] = 545,
                    ["image"] = 607555,
                    ["name"] = "Blackheart the Inciter",
                }, -- [2]
                {
                    ["id"] = 546,
                    ["image"] = 607625,
                    ["name"] = "Grandmaster Vorpil",
                }, -- [3]
                {
                    ["id"] = 547,
                    ["image"] = 607720,
                    ["name"] = "Murmur",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 254,
            ["image"] = 608218,
            ["name"] = "The Arcatraz",
            ["bosses"] = {
                {
                    ["id"] = 548,
                    ["image"] = 607823,
                    ["name"] = "Zereketh the Unbound",
                }, -- [1]
                {
                    ["id"] = 549,
                    ["image"] = 607574,
                    ["name"] = "Dalliah the Doomsayer",
                }, -- [2]
                {
                    ["id"] = 550,
                    ["image"] = 607820,
                    ["name"] = "Wrath-Scryer Soccothrates",
                }, -- [3]
                {
                    ["id"] = 551,
                    ["image"] = 607635,
                    ["name"] = "Harbinger Skyriss",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 255,
            ["image"] = 608198,
            ["name"] = "The Black Morass",
            ["bosses"] = {
                {
                    ["id"] = 552,
                    ["image"] = 607566,
                    ["name"] = "Chrono Lord Deja",
                }, -- [1]
                {
                    ["id"] = 553,
                    ["image"] = 607784,
                    ["name"] = "Temporus",
                }, -- [2]
                {
                    ["id"] = 554,
                    ["image"] = 607529,
                    ["name"] = "Aeonus",
                }, -- [3]
            },
        }, -- [17]
        {
            ["id"] = 256,
            ["image"] = 608207,
            ["name"] = "The Blood Furnace",
            ["bosses"] = {
                {
                    ["id"] = 555,
                    ["image"] = 607789,
                    ["name"] = "The Maker",
                }, -- [1]
                {
                    ["id"] = 556,
                    ["image"] = 607558,
                    ["name"] = "Broggok",
                }, -- [2]
                {
                    ["id"] = 557,
                    ["image"] = 607670,
                    ["name"] = "Keli'dan the Breaker",
                }, -- [3]
            },
        }, -- [18]
        {
            ["id"] = 257,
            ["image"] = 608218,
            ["name"] = "The Botanica",
            ["bosses"] = {
                {
                    ["id"] = 558,
                    ["image"] = 607570,
                    ["name"] = "Commander Sarannis",
                }, -- [1]
                {
                    ["id"] = 559,
                    ["image"] = 607641,
                    ["name"] = "High Botanist Freywinn",
                }, -- [2]
                {
                    ["id"] = 560,
                    ["image"] = 607794,
                    ["name"] = "Thorngrin the Tender",
                }, -- [3]
                {
                    ["id"] = 561,
                    ["image"] = 607683,
                    ["name"] = "Laj",
                }, -- [4]
                {
                    ["id"] = 562,
                    ["image"] = 607816,
                    ["name"] = "Warp Splinter",
                }, -- [5]
            },
        }, -- [19]
        {
            ["id"] = 258,
            ["image"] = 608218,
            ["name"] = "The Mechanar",
            ["bosses"] = {
                {
                    ["id"] = 563,
                    ["image"] = 607712,
                    ["name"] = "Mechano-Lord Capacitus",
                }, -- [1]
                {
                    ["id"] = 564,
                    ["image"] = 607725,
                    ["name"] = "Nethermancer Sepethrea",
                }, -- [2]
                {
                    ["id"] = 565,
                    ["image"] = 607739,
                    ["name"] = "Pathaleon the Calculator",
                }, -- [3]
            },
        }, -- [20]
        {
            ["id"] = 259,
            ["image"] = 608207,
            ["name"] = "The Shattered Halls",
            ["bosses"] = {
                {
                    ["id"] = 566,
                    ["image"] = 607624,
                    ["name"] = "Grand Warlock Nethekurse",
                }, -- [1]
                {
                    ["id"] = 568,
                    ["image"] = 607811,
                    ["name"] = "Warbringer O'mrogg",
                }, -- [2]
                {
                    ["id"] = 569,
                    ["image"] = 607812,
                    ["name"] = "Warchief Kargath Bladefist",
                }, -- [3]
            },
        }, -- [21]
        {
            ["id"] = 260,
            ["image"] = 608199,
            ["name"] = "The Slave Pens",
            ["bosses"] = {
                {
                    ["id"] = 570,
                    ["image"] = 607715,
                    ["name"] = "Mennu the Betrayer",
                }, -- [1]
                {
                    ["id"] = 571,
                    ["image"] = 607759,
                    ["name"] = "Rokmar the Crackler",
                }, -- [2]
                {
                    ["id"] = 572,
                    ["image"] = 607750,
                    ["name"] = "Quagmirran",
                }, -- [3]
            },
        }, -- [22]
        {
            ["id"] = 261,
            ["image"] = 608199,
            ["name"] = "The Steamvault",
            ["bosses"] = {
                {
                    ["id"] = 573,
                    ["image"] = 607651,
                    ["name"] = "Hydromancer Thespia",
                }, -- [1]
                {
                    ["id"] = 574,
                    ["image"] = 607713,
                    ["name"] = "Mekgineer Steamrigger",
                }, -- [2]
                {
                    ["id"] = 575,
                    ["image"] = 607815,
                    ["name"] = "Warlord Kalithresh",
                }, -- [3]
            },
        }, -- [23]
        {
            ["id"] = 262,
            ["image"] = 608199,
            ["name"] = "The Underbog",
            ["bosses"] = {
                {
                    ["id"] = 576,
                    ["image"] = 607649,
                    ["name"] = "Hungarfen",
                }, -- [1]
                {
                    ["id"] = 577,
                    ["image"] = 607614,
                    ["name"] = "Ghaz'an",
                }, -- [2]
                {
                    ["id"] = 578,
                    ["image"] = 607779,
                    ["name"] = "Swamplord Musel'ek",
                }, -- [3]
                {
                    ["id"] = 579,
                    ["image"] = 607788,
                    ["name"] = "The Black Stalker",
                }, -- [4]
            },
        }, -- [24]
    },
    ["Legion"] = {
        {
            ["id"] = 822,
            ["image"] = 1411854,
            ["name"] = "Broken Isles",
            ["bosses"] = {
                {
                    ["id"] = 1790,
                    ["image"] = 1411023,
                    ["name"] = "Ana-Mouz",
                }, -- [1]
                {
                    ["id"] = 1956,
                    ["image"] = 1134499,
                    ["name"] = "Apocron",
                }, -- [2]
                {
                    ["id"] = 1883,
                    ["image"] = 1385722,
                    ["name"] = "Brutallus",
                }, -- [3]
                {
                    ["id"] = 1774,
                    ["image"] = 1411024,
                    ["name"] = "Calamir",
                }, -- [4]
                {
                    ["id"] = 1789,
                    ["image"] = 1411025,
                    ["name"] = "Drugon the Frostblood",
                }, -- [5]
                {
                    ["id"] = 1795,
                    ["image"] = 1472454,
                    ["name"] = "Flotsam",
                }, -- [6]
                {
                    ["id"] = 1770,
                    ["image"] = 1411026,
                    ["name"] = "Humongris",
                }, -- [7]
                {
                    ["id"] = 1769,
                    ["image"] = 1411027,
                    ["name"] = "Levantus",
                }, -- [8]
                {
                    ["id"] = 1884,
                    ["image"] = 1579937,
                    ["name"] = "Malificus",
                }, -- [9]
                {
                    ["id"] = 1783,
                    ["image"] = 1411028,
                    ["name"] = "Na'zak the Fiend",
                }, -- [10]
                {
                    ["id"] = 1749,
                    ["image"] = 1411029,
                    ["name"] = "Nithogg",
                }, -- [11]
                {
                    ["id"] = 1763,
                    ["image"] = 1411030,
                    ["name"] = "Shar'thos",
                }, -- [12]
                {
                    ["id"] = 1885,
                    ["image"] = 1579941,
                    ["name"] = "Si'vash",
                }, -- [13]
                {
                    ["id"] = 1756,
                    ["image"] = 1411031,
                    ["name"] = "The Soultakers",
                }, -- [14]
                {
                    ["id"] = 1796,
                    ["image"] = 1472455,
                    ["name"] = "Withered J'im",
                }, -- [15]
            },
        }, -- [1]
        {
            ["id"] = 768,
            ["image"] = 1452687,
            ["name"] = "The Emerald Nightmare",
            ["bosses"] = {
                {
                    ["id"] = 1703,
                    ["image"] = 1410972,
                    ["name"] = "Nythendra",
                }, -- [1]
                {
                    ["id"] = 1738,
                    ["image"] = 1410960,
                    ["name"] = "Il'gynoth, Heart of Corruption",
                }, -- [2]
                {
                    ["id"] = 1744,
                    ["image"] = 1410947,
                    ["name"] = "Elerethe Renferal",
                }, -- [3]
                {
                    ["id"] = 1667,
                    ["image"] = 1410991,
                    ["name"] = "Ursoc",
                }, -- [4]
                {
                    ["id"] = 1704,
                    ["image"] = 1410945,
                    ["name"] = "Dragons of Nightmare",
                }, -- [5]
                {
                    ["id"] = 1750,
                    ["image"] = 1410940,
                    ["name"] = "Cenarius",
                }, -- [6]
                {
                    ["id"] = 1726,
                    ["image"] = 1410994,
                    ["name"] = "Xavius",
                }, -- [7]
            },
        }, -- [2]
        {
            ["id"] = 861,
            ["image"] = 1537284,
            ["name"] = "Trial of Valor",
            ["bosses"] = {
                {
                    ["id"] = 1819,
                    ["image"] = 1410974,
                    ["name"] = "Odyn",
                }, -- [1]
                {
                    ["id"] = 1830,
                    ["image"] = 1536491,
                    ["name"] = "Guarm",
                }, -- [2]
                {
                    ["id"] = 1829,
                    ["image"] = 1410957,
                    ["name"] = "Helya",
                }, -- [3]
            },
        }, -- [3]
        {
            ["id"] = 786,
            ["image"] = 1450575,
            ["name"] = "The Nighthold",
            ["bosses"] = {
                {
                    ["id"] = 1706,
                    ["image"] = 1410981,
                    ["name"] = "Skorpyron",
                }, -- [1]
                {
                    ["id"] = 1725,
                    ["image"] = 1410941,
                    ["name"] = "Chronomatic Anomaly",
                }, -- [2]
                {
                    ["id"] = 1731,
                    ["image"] = 1410989,
                    ["name"] = "Trilliax",
                }, -- [3]
                {
                    ["id"] = 1751,
                    ["image"] = 1410983,
                    ["name"] = "Spellblade Aluriel",
                }, -- [4]
                {
                    ["id"] = 1762,
                    ["image"] = 1410987,
                    ["name"] = "Tichondrius",
                }, -- [5]
                {
                    ["id"] = 1713,
                    ["image"] = 1410965,
                    ["name"] = "Krosus",
                }, -- [6]
                {
                    ["id"] = 1761,
                    ["image"] = 1410939,
                    ["name"] = "High Botanist Tel'arn",
                }, -- [7]
                {
                    ["id"] = 1732,
                    ["image"] = 1410984,
                    ["name"] = "Star Augur Etraeus",
                }, -- [8]
                {
                    ["id"] = 1743,
                    ["image"] = 1410954,
                    ["name"] = "Grand Magistrix Elisande",
                }, -- [9]
                {
                    ["id"] = 1737,
                    ["image"] = 1410955,
                    ["name"] = "Gul'dan",
                }, -- [10]
            },
        }, -- [4]
        {
            ["id"] = 875,
            ["image"] = 1616106,
            ["name"] = "Tomb of Sargeras",
            ["bosses"] = {
                {
                    ["id"] = 1862,
                    ["image"] = 1579934,
                    ["name"] = "Goroth",
                }, -- [1]
                {
                    ["id"] = 1867,
                    ["image"] = 1579936,
                    ["name"] = "Demonic Inquisition",
                }, -- [2]
                {
                    ["id"] = 1856,
                    ["image"] = 1579940,
                    ["name"] = "Harjatan",
                }, -- [3]
                {
                    ["id"] = 1903,
                    ["image"] = 1579935,
                    ["name"] = "Sisters of the Moon",
                }, -- [4]
                {
                    ["id"] = 1861,
                    ["image"] = 1579939,
                    ["name"] = "Mistress Sassz'ine",
                }, -- [5]
                {
                    ["id"] = 1896,
                    ["image"] = 1579943,
                    ["name"] = "The Desolate Host",
                }, -- [6]
                {
                    ["id"] = 1897,
                    ["image"] = 1579933,
                    ["name"] = "Maiden of Vigilance",
                }, -- [7]
                {
                    ["id"] = 1873,
                    ["image"] = 1579932,
                    ["name"] = "Fallen Avatar",
                }, -- [8]
                {
                    ["id"] = 1898,
                    ["image"] = 1385746,
                    ["name"] = "Kil'jaeden",
                }, -- [9]
            },
        }, -- [5]
        {
            ["id"] = 946,
            ["image"] = 1718211,
            ["name"] = "Antorus, the Burning Throne",
            ["bosses"] = {
                {
                    ["id"] = 1992,
                    ["image"] = 1715210,
                    ["name"] = "Garothi Worldbreaker",
                }, -- [1]
                {
                    ["id"] = 1987,
                    ["image"] = 1715209,
                    ["name"] = "Felhounds of Sargeras",
                }, -- [2]
                {
                    ["id"] = 1997,
                    ["image"] = 1715225,
                    ["name"] = "Antoran High Command",
                }, -- [3]
                {
                    ["id"] = 1985,
                    ["image"] = 1715219,
                    ["name"] = "Portal Keeper Hasabel",
                }, -- [4]
                {
                    ["id"] = 2025,
                    ["image"] = 1715208,
                    ["name"] = "Eonar the Life-Binder",
                }, -- [5]
                {
                    ["id"] = 2009,
                    ["image"] = 1715211,
                    ["name"] = "Imonar the Soulhunter",
                }, -- [6]
                {
                    ["id"] = 2004,
                    ["image"] = 1715213,
                    ["name"] = "Kin'garoth",
                }, -- [7]
                {
                    ["id"] = 1983,
                    ["image"] = 1715223,
                    ["name"] = "Varimathras",
                }, -- [8]
                {
                    ["id"] = 1986,
                    ["image"] = 1715222,
                    ["name"] = "The Coven of Shivarra",
                }, -- [9]
                {
                    ["id"] = 1984,
                    ["image"] = 1715207,
                    ["name"] = "Aggramar",
                }, -- [10]
                {
                    ["id"] = 2031,
                    ["image"] = 1715536,
                    ["name"] = "Argus the Unmaker",
                }, -- [11]
            },
        }, -- [6]
        {
            ["id"] = 959,
            ["image"] = 1718212,
            ["name"] = "Invasion Points",
            ["bosses"] = {
                {
                    ["id"] = 2010,
                    ["image"] = 1715215,
                    ["name"] = "Matron Folnuna",
                }, -- [1]
                {
                    ["id"] = 2011,
                    ["image"] = 1715216,
                    ["name"] = "Mistress Alluradel",
                }, -- [2]
                {
                    ["id"] = 2012,
                    ["image"] = 1715212,
                    ["name"] = "Inquisitor Meto",
                }, -- [3]
                {
                    ["id"] = 2013,
                    ["image"] = 1715217,
                    ["name"] = "Occularus",
                }, -- [4]
                {
                    ["id"] = 2014,
                    ["image"] = 1715221,
                    ["name"] = "Sotanathor",
                }, -- [5]
                {
                    ["id"] = 2015,
                    ["image"] = 1715218,
                    ["name"] = "Pit Lord Vilemus",
                }, -- [6]
            },
        }, -- [7]
        {
            ["id"] = 777,
            ["image"] = 1498155,
            ["name"] = "Assault on Violet Hold",
            ["bosses"] = {
                {
                    ["id"] = 1693,
                    ["image"] = 1410950,
                    ["name"] = "Festerface",
                }, -- [1]
                {
                    ["id"] = 1694,
                    ["image"] = 1410980,
                    ["name"] = "Shivermaw",
                }, -- [2]
                {
                    ["id"] = 1702,
                    ["image"] = 1410938,
                    ["name"] = "Blood-Princess Thal'ena",
                }, -- [3]
                {
                    ["id"] = 1686,
                    ["image"] = 1410969,
                    ["name"] = "Mindflayer Kaahrj",
                }, -- [4]
                {
                    ["id"] = 1688,
                    ["image"] = 1410968,
                    ["name"] = "Millificent Manastorm",
                }, -- [5]
                {
                    ["id"] = 1696,
                    ["image"] = 1410935,
                    ["name"] = "Anub'esset",
                }, -- [6]
                {
                    ["id"] = 1697,
                    ["image"] = 1410977,
                    ["name"] = "Sael'orn",
                }, -- [7]
                {
                    ["id"] = 1711,
                    ["image"] = 1410948,
                    ["name"] = "Fel Lord Betrug",
                }, -- [8]
            },
        }, -- [8]
        {
            ["id"] = 740,
            ["image"] = 1411853,
            ["name"] = "Black Rook Hold",
            ["bosses"] = {
                {
                    ["id"] = 1518,
                    ["image"] = 1410986,
                    ["name"] = "The Amalgam of Souls",
                }, -- [1]
                {
                    ["id"] = 1653,
                    ["image"] = 1410961,
                    ["name"] = "Illysanna Ravencrest",
                }, -- [2]
                {
                    ["id"] = 1664,
                    ["image"] = 1410982,
                    ["name"] = "Smashspite the Hateful",
                }, -- [3]
                {
                    ["id"] = 1672,
                    ["image"] = 1410967,
                    ["name"] = "Lord Kur'talos Ravencrest",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 900,
            ["image"] = 1616922,
            ["name"] = "Cathedral of Eternal Night",
            ["bosses"] = {
                {
                    ["id"] = 1905,
                    ["image"] = 1579930,
                    ["name"] = "Agronox",
                }, -- [1]
                {
                    ["id"] = 1906,
                    ["image"] = 1579942,
                    ["name"] = "Thrashbite the Scornful",
                }, -- [2]
                {
                    ["id"] = 1904,
                    ["image"] = 1579931,
                    ["name"] = "Domatrax",
                }, -- [3]
                {
                    ["id"] = 1878,
                    ["image"] = 1579938,
                    ["name"] = "Mephistroth",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 800,
            ["image"] = 1498156,
            ["name"] = "Court of Stars",
            ["bosses"] = {
                {
                    ["id"] = 1718,
                    ["image"] = 1410975,
                    ["name"] = "Patrol Captain Gerdo",
                }, -- [1]
                {
                    ["id"] = 1719,
                    ["image"] = 1410985,
                    ["name"] = "Talixae Flamewreath",
                }, -- [2]
                {
                    ["id"] = 1720,
                    ["image"] = 1410933,
                    ["name"] = "Advisor Melandrus",
                }, -- [3]
            },
        }, -- [11]
        {
            ["id"] = 762,
            ["image"] = 1411855,
            ["name"] = "Darkheart Thicket",
            ["bosses"] = {
                {
                    ["id"] = 1654,
                    ["image"] = 1410936,
                    ["name"] = "Archdruid Glaidalis",
                }, -- [1]
                {
                    ["id"] = 1655,
                    ["image"] = 1410973,
                    ["name"] = "Oakheart",
                }, -- [2]
                {
                    ["id"] = 1656,
                    ["image"] = 1410946,
                    ["name"] = "Dresaron",
                }, -- [3]
                {
                    ["id"] = 1657,
                    ["image"] = 1410979,
                    ["name"] = "Shade of Xavius",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 716,
            ["image"] = 1498157,
            ["name"] = "Eye of Azshara",
            ["bosses"] = {
                {
                    ["id"] = 1480,
                    ["image"] = 1410992,
                    ["name"] = "Warlord Parjesh",
                }, -- [1]
                {
                    ["id"] = 1490,
                    ["image"] = 1410966,
                    ["name"] = "Lady Hatecoil",
                }, -- [2]
                {
                    ["id"] = 1491,
                    ["image"] = 1410964,
                    ["name"] = "King Deepbeard",
                }, -- [3]
                {
                    ["id"] = 1479,
                    ["image"] = 1410978,
                    ["name"] = "Serpentrix",
                }, -- [4]
                {
                    ["id"] = 1492,
                    ["image"] = 1410993,
                    ["name"] = "Wrath of Azshara",
                }, -- [5]
            },
        }, -- [13]
        {
            ["id"] = 721,
            ["image"] = 1498158,
            ["name"] = "Halls of Valor",
            ["bosses"] = {
                {
                    ["id"] = 1485,
                    ["image"] = 1410958,
                    ["name"] = "Hymdall",
                }, -- [1]
                {
                    ["id"] = 1486,
                    ["image"] = 1410959,
                    ["name"] = "Hyrja",
                }, -- [2]
                {
                    ["id"] = 1487,
                    ["image"] = 1410949,
                    ["name"] = "Fenryr",
                }, -- [3]
                {
                    ["id"] = 1488,
                    ["image"] = 1410953,
                    ["name"] = "God-King Skovald",
                }, -- [4]
                {
                    ["id"] = 1489,
                    ["image"] = 1410974,
                    ["name"] = "Odyn",
                }, -- [5]
            },
        }, -- [14]
        {
            ["id"] = 727,
            ["image"] = 1411856,
            ["name"] = "Maw of Souls",
            ["bosses"] = {
                {
                    ["id"] = 1502,
                    ["image"] = 1410995,
                    ["name"] = "Ymiron, the Fallen King",
                }, -- [1]
                {
                    ["id"] = 1512,
                    ["image"] = 1410956,
                    ["name"] = "Harbaron",
                }, -- [2]
                {
                    ["id"] = 1663,
                    ["image"] = 1410957,
                    ["name"] = "Helya",
                }, -- [3]
            },
        }, -- [15]
        {
            ["id"] = 767,
            ["image"] = 1450574,
            ["name"] = "Neltharion's Lair",
            ["bosses"] = {
                {
                    ["id"] = 1662,
                    ["image"] = 1410976,
                    ["name"] = "Rokmora",
                }, -- [1]
                {
                    ["id"] = 1665,
                    ["image"] = 1410990,
                    ["name"] = "Ularogg Cragshaper",
                }, -- [2]
                {
                    ["id"] = 1673,
                    ["image"] = 1410971,
                    ["name"] = "Naraxas",
                }, -- [3]
                {
                    ["id"] = 1687,
                    ["image"] = 1410944,
                    ["name"] = "Dargrul the Underking",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 860,
            ["image"] = 1537283,
            ["name"] = "Return to Karazhan",
            ["bosses"] = {
                {
                    ["id"] = 1820,
                    ["image"] = 1536495,
                    ["name"] = "Opera Hall: Wikket",
                }, -- [1]
                {
                    ["id"] = 1826,
                    ["image"] = 1536494,
                    ["name"] = "Opera Hall: Westfall Story",
                }, -- [2]
                {
                    ["id"] = 1827,
                    ["image"] = 1536493,
                    ["name"] = "Opera Hall: Beautiful Beast",
                }, -- [3]
                {
                    ["id"] = 1825,
                    ["image"] = 1378997,
                    ["name"] = "Maiden of Virtue",
                }, -- [4]
                {
                    ["id"] = 1835,
                    ["image"] = 1536490,
                    ["name"] = "Attumen the Huntsman",
                }, -- [5]
                {
                    ["id"] = 1837,
                    ["image"] = 1378999,
                    ["name"] = "Moroes",
                }, -- [6]
                {
                    ["id"] = 1836,
                    ["image"] = 1379020,
                    ["name"] = "The Curator",
                }, -- [7]
                {
                    ["id"] = 1817,
                    ["image"] = 1536496,
                    ["name"] = "Shade of Medivh",
                }, -- [8]
                {
                    ["id"] = 1818,
                    ["image"] = 1536492,
                    ["name"] = "Mana Devourer",
                }, -- [9]
                {
                    ["id"] = 1838,
                    ["image"] = 1536497,
                    ["name"] = "Viz'aduum the Watcher",
                }, -- [10]
            },
        }, -- [17]
        {
            ["id"] = 945,
            ["image"] = 1718213,
            ["name"] = "Seat of the Triumvirate",
            ["bosses"] = {
                {
                    ["id"] = 1979,
                    ["image"] = 1715226,
                    ["name"] = "Zuraal the Ascended",
                }, -- [1]
                {
                    ["id"] = 1980,
                    ["image"] = 1715220,
                    ["name"] = "Saprish",
                }, -- [2]
                {
                    ["id"] = 1981,
                    ["image"] = 1715224,
                    ["name"] = "Viceroy Nezhar",
                }, -- [3]
                {
                    ["id"] = 1982,
                    ["image"] = 1715214,
                    ["name"] = "L'ura",
                }, -- [4]
            },
        }, -- [18]
        {
            ["id"] = 726,
            ["image"] = 1411857,
            ["name"] = "The Arcway",
            ["bosses"] = {
                {
                    ["id"] = 1497,
                    ["image"] = 1410963,
                    ["name"] = "Ivanyr",
                }, -- [1]
                {
                    ["id"] = 1498,
                    ["image"] = 1410943,
                    ["name"] = "Corstilax",
                }, -- [2]
                {
                    ["id"] = 1499,
                    ["image"] = 1410951,
                    ["name"] = "General Xakal",
                }, -- [3]
                {
                    ["id"] = 1500,
                    ["image"] = 1410970,
                    ["name"] = "Nal'tira",
                }, -- [4]
                {
                    ["id"] = 1501,
                    ["image"] = 1410934,
                    ["name"] = "Advisor Vandros",
                }, -- [5]
            },
        }, -- [19]
        {
            ["id"] = 707,
            ["image"] = 1411858,
            ["name"] = "Vault of the Wardens",
            ["bosses"] = {
                {
                    ["id"] = 1467,
                    ["image"] = 1410988,
                    ["name"] = "Tirathon Saltheril",
                }, -- [1]
                {
                    ["id"] = 1695,
                    ["image"] = 1410962,
                    ["name"] = "Inquisitor Tormentorum",
                }, -- [2]
                {
                    ["id"] = 1468,
                    ["image"] = 1410937,
                    ["name"] = "Ash'golm",
                }, -- [3]
                {
                    ["id"] = 1469,
                    ["image"] = 1410952,
                    ["name"] = "Glazer",
                }, -- [4]
                {
                    ["id"] = 1470,
                    ["image"] = 1410942,
                    ["name"] = "Cordana Felsong",
                }, -- [5]
            },
        }, -- [20]
    },
    ["Shadowlands"] = {
        {
            ["id"] = 1192,
            ["image"] = 3850569,
            ["name"] = "Shadowlands",
            ["bosses"] = {
                {
                    ["id"] = 2430,
                    ["image"] = 3752195,
                    ["name"] = "Valinor, the Light of Eons",
                }, -- [1]
                {
                    ["id"] = 2431,
                    ["image"] = 3752183,
                    ["name"] = "Mortanis",
                }, -- [2]
                {
                    ["id"] = 2432,
                    ["image"] = 3752188,
                    ["name"] = "Oranomonos the Everbranching",
                }, -- [3]
                {
                    ["id"] = 2433,
                    ["image"] = 3752187,
                    ["name"] = "Nurgash Muckformed",
                }, -- [4]
                {
                    ["id"] = 2456,
                    ["image"] = 4071436,
                    ["name"] = "Mor'geth, Tormentor of the Damned",
                }, -- [5]
                {
                    ["id"] = 2468,
                    ["image"] = 4529365,
                    ["name"] = "Antros",
                }, -- [6]
            },
        }, -- [1]
        {
            ["id"] = 1190,
            ["image"] = 3759906,
            ["name"] = "Castle Nathria",
            ["bosses"] = {
                {
                    ["id"] = 2393,
                    ["image"] = 3752190,
                    ["name"] = "Shriekwing",
                }, -- [1]
                {
                    ["id"] = 2429,
                    ["image"] = 3753151,
                    ["name"] = "Huntsman Altimor",
                }, -- [2]
                {
                    ["id"] = 2422,
                    ["image"] = 3753157,
                    ["name"] = "Sun King's Salvation",
                }, -- [3]
                {
                    ["id"] = 2418,
                    ["image"] = 3752156,
                    ["name"] = "Artificer Xy'mox",
                }, -- [4]
                {
                    ["id"] = 2428,
                    ["image"] = 3752174,
                    ["name"] = "Hungering Destroyer",
                }, -- [5]
                {
                    ["id"] = 2420,
                    ["image"] = 3752178,
                    ["name"] = "Lady Inerva Darkvein",
                }, -- [6]
                {
                    ["id"] = 2426,
                    ["image"] = 3753159,
                    ["name"] = "The Council of Blood",
                }, -- [7]
                {
                    ["id"] = 2394,
                    ["image"] = 3752191,
                    ["name"] = "Sludgefist",
                }, -- [8]
                {
                    ["id"] = 2425,
                    ["image"] = 3753156,
                    ["name"] = "Stone Legion Generals",
                }, -- [9]
                {
                    ["id"] = 2424,
                    ["image"] = 3752159,
                    ["name"] = "Sire Denathrius",
                }, -- [10]
            },
        }, -- [2]
        {
            ["id"] = 1193,
            ["image"] = 4182020,
            ["name"] = "Sanctum of Domination",
            ["bosses"] = {
                {
                    ["id"] = 2435,
                    ["image"] = 4071444,
                    ["name"] = "The Tarragrue",
                }, -- [1]
                {
                    ["id"] = 2442,
                    ["image"] = 4071426,
                    ["name"] = "The Eye of the Jailer",
                }, -- [2]
                {
                    ["id"] = 2439,
                    ["image"] = 4071445,
                    ["name"] = "The Nine",
                }, -- [3]
                {
                    ["id"] = 2444,
                    ["image"] = 4071439,
                    ["name"] = "Remnant of Ner'zhul",
                }, -- [4]
                {
                    ["id"] = 2445,
                    ["image"] = 4071442,
                    ["name"] = "Soulrender Dormazain",
                }, -- [5]
                {
                    ["id"] = 2443,
                    ["image"] = 4079051,
                    ["name"] = "Painsmith Raznal",
                }, -- [6]
                {
                    ["id"] = 2446,
                    ["image"] = 4071428,
                    ["name"] = "Guardian of the First Ones",
                }, -- [7]
                {
                    ["id"] = 2447,
                    ["image"] = 4071427,
                    ["name"] = "Fatescribe Roh-Kalo",
                }, -- [8]
                {
                    ["id"] = 2440,
                    ["image"] = 4071435,
                    ["name"] = "Kel'Thuzad",
                }, -- [9]
                {
                    ["id"] = 2441,
                    ["image"] = 4071443,
                    ["name"] = "Sylvanas Windrunner",
                }, -- [10]
            },
        }, -- [3]
        {
            ["id"] = 1195,
            ["image"] = 4423752,
            ["name"] = "Sepulcher of the First Ones",
            ["bosses"] = {
                {
                    ["id"] = 2458,
                    ["image"] = 4465340,
                    ["name"] = "Vigilant Guardian",
                }, -- [1]
                {
                    ["id"] = 2465,
                    ["image"] = 4465339,
                    ["name"] = "Skolex, the Insatiable Ravener",
                }, -- [2]
                {
                    ["id"] = 2470,
                    ["image"] = 4423749,
                    ["name"] = "Artificer Xy'mox",
                }, -- [3]
                {
                    ["id"] = 2459,
                    ["image"] = 4465333,
                    ["name"] = "Dausegne, the Fallen Oracle",
                }, -- [4]
                {
                    ["id"] = 2460,
                    ["image"] = 4465337,
                    ["name"] = "Prototype Pantheon",
                }, -- [5]
                {
                    ["id"] = 2461,
                    ["image"] = 4465335,
                    ["name"] = "Lihuvim, Principal Architect",
                }, -- [6]
                {
                    ["id"] = 2463,
                    ["image"] = 4423738,
                    ["name"] = "Halondrus the Reclaimer",
                }, -- [7]
                {
                    ["id"] = 2469,
                    ["image"] = 4423747,
                    ["name"] = "Anduin Wrynn",
                }, -- [8]
                {
                    ["id"] = 2457,
                    ["image"] = 4465336,
                    ["name"] = "Lords of Dread",
                }, -- [9]
                {
                    ["id"] = 2467,
                    ["image"] = 4465338,
                    ["name"] = "Rygelon",
                }, -- [10]
                {
                    ["id"] = 2464,
                    ["image"] = 4465334,
                    ["name"] = "The Jailer",
                }, -- [11]
            },
        }, -- [4]
        {
            ["id"] = 1188,
            ["image"] = 3759915,
            ["name"] = "De Other Side",
            ["bosses"] = {
                {
                    ["id"] = 2408,
                    ["image"] = 3752170,
                    ["name"] = "Hakkar the Soulflayer",
                }, -- [1]
                {
                    ["id"] = 2409,
                    ["image"] = 3752193,
                    ["name"] = "The Manastorms",
                }, -- [2]
                {
                    ["id"] = 2398,
                    ["image"] = 3753147,
                    ["name"] = "Dealer Xy'exa",
                }, -- [3]
                {
                    ["id"] = 2410,
                    ["image"] = 3752184,
                    ["name"] = "Mueh'zala",
                }, -- [4]
            },
        }, -- [5]
        {
            ["id"] = 1185,
            ["image"] = 3759908,
            ["name"] = "Halls of Atonement",
            ["bosses"] = {
                {
                    ["id"] = 2406,
                    ["image"] = 3752171,
                    ["name"] = "Halkias, the Sin-Stained Goliath",
                }, -- [1]
                {
                    ["id"] = 2387,
                    ["image"] = 3752165,
                    ["name"] = "Echelon",
                }, -- [2]
                {
                    ["id"] = 2411,
                    ["image"] = 3753150,
                    ["name"] = "High Adjudicator Aleez",
                }, -- [3]
                {
                    ["id"] = 2413,
                    ["image"] = 3752179,
                    ["name"] = "Lord Chamberlain",
                }, -- [4]
            },
        }, -- [6]
        {
            ["id"] = 1184,
            ["image"] = 3759909,
            ["name"] = "Mists of Tirna Scithe",
            ["bosses"] = {
                {
                    ["id"] = 2400,
                    ["image"] = 3753152,
                    ["name"] = "Ingra Maloch",
                }, -- [1]
                {
                    ["id"] = 2402,
                    ["image"] = 3752181,
                    ["name"] = "Mistcaller",
                }, -- [2]
                {
                    ["id"] = 2405,
                    ["image"] = 3752194,
                    ["name"] = "Tred'ova",
                }, -- [3]
            },
        }, -- [7]
        {
            ["id"] = 1183,
            ["image"] = 3759911,
            ["name"] = "Plaguefall",
            ["bosses"] = {
                {
                    ["id"] = 2419,
                    ["image"] = 3752168,
                    ["name"] = "Globgrog",
                }, -- [1]
                {
                    ["id"] = 2403,
                    ["image"] = 3752162,
                    ["name"] = "Doctor Ickus",
                }, -- [2]
                {
                    ["id"] = 2423,
                    ["image"] = 3752163,
                    ["name"] = "Domina Venomblade",
                }, -- [3]
                {
                    ["id"] = 2404,
                    ["image"] = 3752180,
                    ["name"] = "Margrave Stradama",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 1189,
            ["image"] = 3759912,
            ["name"] = "Sanguine Depths",
            ["bosses"] = {
                {
                    ["id"] = 2388,
                    ["image"] = 3753153,
                    ["name"] = "Kryxis the Voracious",
                }, -- [1]
                {
                    ["id"] = 2415,
                    ["image"] = 3753148,
                    ["name"] = "Executor Tarvold",
                }, -- [2]
                {
                    ["id"] = 2421,
                    ["image"] = 3753149,
                    ["name"] = "Grand Proctor Beryllia",
                }, -- [3]
                {
                    ["id"] = 2407,
                    ["image"] = 3752167,
                    ["name"] = "General Kaal",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 1186,
            ["image"] = 3759913,
            ["name"] = "Spires of Ascension",
            ["bosses"] = {
                {
                    ["id"] = 2399,
                    ["image"] = 3752177,
                    ["name"] = "Kin-Tara",
                }, -- [1]
                {
                    ["id"] = 2416,
                    ["image"] = 3752198,
                    ["name"] = "Ventunax",
                }, -- [2]
                {
                    ["id"] = 2414,
                    ["image"] = 3752189,
                    ["name"] = "Oryphrion",
                }, -- [3]
                {
                    ["id"] = 2412,
                    ["image"] = 3752160,
                    ["name"] = "Devos, Paragon of Doubt",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 1194,
            ["image"] = 4182022,
            ["name"] = "Tazavesh, the Veiled Market",
            ["bosses"] = {
                {
                    ["id"] = 2437,
                    ["image"] = 4071449,
                    ["name"] = "Zo'phex the Sentinel",
                }, -- [1]
                {
                    ["id"] = 2454,
                    ["image"] = 4071447,
                    ["name"] = "The Grand Menagerie",
                }, -- [2]
                {
                    ["id"] = 2436,
                    ["image"] = 4071438,
                    ["name"] = "Mailroom Mayhem",
                }, -- [3]
                {
                    ["id"] = 2452,
                    ["image"] = 4071448,
                    ["name"] = "Myza's Oasis",
                }, -- [4]
                {
                    ["id"] = 2451,
                    ["image"] = 4071440,
                    ["name"] = "So'azmi",
                }, -- [5]
                {
                    ["id"] = 2448,
                    ["image"] = 4071429,
                    ["name"] = "Hylbrande",
                }, -- [6]
                {
                    ["id"] = 2449,
                    ["image"] = 4071446,
                    ["name"] = "Timecap'n Hooktail",
                }, -- [7]
                {
                    ["id"] = 2455,
                    ["image"] = 4071441,
                    ["name"] = "So'leah",
                }, -- [8]
            },
        }, -- [11]
        {
            ["id"] = 1182,
            ["image"] = 3759910,
            ["name"] = "The Necrotic Wake",
            ["bosses"] = {
                {
                    ["id"] = 2395,
                    ["image"] = 3752157,
                    ["name"] = "Blightbone",
                }, -- [1]
                {
                    ["id"] = 2391,
                    ["image"] = 3753146,
                    ["name"] = "Amarth, The Harvester",
                }, -- [2]
                {
                    ["id"] = 2392,
                    ["image"] = 3753158,
                    ["name"] = "Surgeon Stitchflesh",
                }, -- [3]
                {
                    ["id"] = 2396,
                    ["image"] = 3753155,
                    ["name"] = "Nalthor the Rimebinder",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 1187,
            ["image"] = 3759914,
            ["name"] = "Theater of Pain",
            ["bosses"] = {
                {
                    ["id"] = 2397,
                    ["image"] = 3752153,
                    ["name"] = "An Affront of Challengers",
                }, -- [1]
                {
                    ["id"] = 2401,
                    ["image"] = 3752169,
                    ["name"] = "Gorechop",
                }, -- [2]
                {
                    ["id"] = 2390,
                    ["image"] = 3752199,
                    ["name"] = "Xav the Unfallen",
                }, -- [3]
                {
                    ["id"] = 2389,
                    ["image"] = 3753154,
                    ["name"] = "Kul'tharok",
                }, -- [4]
                {
                    ["id"] = 2417,
                    ["image"] = 3752182,
                    ["name"] = "Mordretha, the Endless Empress",
                }, -- [5]
            },
        }, -- [13]
    },
    ["Cataclysm"] = {
        {
            ["id"] = 75,
            ["image"] = 522349,
            ["name"] = "Baradin Hold",
            ["bosses"] = {
                {
                    ["id"] = 139,
                    ["image"] = 522198,
                    ["name"] = "Argaloth",
                }, -- [1]
                {
                    ["id"] = 140,
                    ["image"] = 523207,
                    ["name"] = "Occu'thar",
                }, -- [2]
                {
                    ["id"] = 339,
                    ["image"] = 571742,
                    ["name"] = "Alizabal, Mistress of Hate",
                }, -- [3]
            },
        }, -- [1]
        {
            ["id"] = 73,
            ["image"] = 522351,
            ["name"] = "Blackwing Descent",
            ["bosses"] = {
                {
                    ["id"] = 169,
                    ["image"] = 522250,
                    ["name"] = "Omnotron Defense System",
                }, -- [1]
                {
                    ["id"] = 170,
                    ["image"] = 522251,
                    ["name"] = "Magmaw",
                }, -- [2]
                {
                    ["id"] = 171,
                    ["image"] = 522202,
                    ["name"] = "Atramedes",
                }, -- [3]
                {
                    ["id"] = 172,
                    ["image"] = 522211,
                    ["name"] = "Chimaeron",
                }, -- [4]
                {
                    ["id"] = 173,
                    ["image"] = 522252,
                    ["name"] = "Maloriak",
                }, -- [5]
                {
                    ["id"] = 174,
                    ["image"] = 522255,
                    ["name"] = "Nefarian's End",
                }, -- [6]
            },
        }, -- [2]
        {
            ["id"] = 72,
            ["image"] = 522355,
            ["name"] = "The Bastion of Twilight",
            ["bosses"] = {
                {
                    ["id"] = 156,
                    ["image"] = 522232,
                    ["name"] = "Halfus Wyrmbreaker",
                }, -- [1]
                {
                    ["id"] = 157,
                    ["image"] = 522274,
                    ["name"] = "Theralion and Valiona",
                }, -- [2]
                {
                    ["id"] = 158,
                    ["image"] = 522224,
                    ["name"] = "Ascendant Council",
                }, -- [3]
                {
                    ["id"] = 167,
                    ["image"] = 522212,
                    ["name"] = "Cho'gall",
                }, -- [4]
            },
        }, -- [3]
        {
            ["id"] = 74,
            ["image"] = 522359,
            ["name"] = "Throne of the Four Winds",
            ["bosses"] = {
                {
                    ["id"] = 154,
                    ["image"] = 522196,
                    ["name"] = "The Conclave of Wind",
                }, -- [1]
                {
                    ["id"] = 155,
                    ["image"] = 522191,
                    ["name"] = "Al'Akir",
                }, -- [2]
            },
        }, -- [4]
        {
            ["id"] = 78,
            ["image"] = 522353,
            ["name"] = "Firelands",
            ["bosses"] = {
                {
                    ["id"] = 192,
                    ["image"] = 522208,
                    ["name"] = "Beth'tilac",
                }, -- [1]
                {
                    ["id"] = 193,
                    ["image"] = 522248,
                    ["name"] = "Lord Rhyolith",
                }, -- [2]
                {
                    ["id"] = 194,
                    ["image"] = 522193,
                    ["name"] = "Alysrazor",
                }, -- [3]
                {
                    ["id"] = 195,
                    ["image"] = 522268,
                    ["name"] = "Shannox",
                }, -- [4]
                {
                    ["id"] = 196,
                    ["image"] = 522204,
                    ["name"] = "Baleroc, the Gatekeeper",
                }, -- [5]
                {
                    ["id"] = 197,
                    ["image"] = 522223,
                    ["name"] = "Majordomo Staghelm",
                }, -- [6]
                {
                    ["id"] = 198,
                    ["image"] = 522261,
                    ["name"] = "Ragnaros",
                }, -- [7]
            },
        }, -- [5]
        {
            ["id"] = 187,
            ["image"] = 571753,
            ["name"] = "Dragon Soul",
            ["bosses"] = {
                {
                    ["id"] = 311,
                    ["image"] = 536058,
                    ["name"] = "Morchok",
                }, -- [1]
                {
                    ["id"] = 324,
                    ["image"] = 536061,
                    ["name"] = "Warlord Zon'ozz",
                }, -- [2]
                {
                    ["id"] = 325,
                    ["image"] = 536062,
                    ["name"] = "Yor'sahj the Unsleeping",
                }, -- [3]
                {
                    ["id"] = 317,
                    ["image"] = 536057,
                    ["name"] = "Hagara the Stormbinder",
                }, -- [4]
                {
                    ["id"] = 331,
                    ["image"] = 571750,
                    ["name"] = "Ultraxion",
                }, -- [5]
                {
                    ["id"] = 332,
                    ["image"] = 571752,
                    ["name"] = "Warmaster Blackhorn",
                }, -- [6]
                {
                    ["id"] = 318,
                    ["image"] = 536056,
                    ["name"] = "Spine of Deathwing",
                }, -- [7]
                {
                    ["id"] = 333,
                    ["image"] = 536055,
                    ["name"] = "Madness of Deathwing",
                }, -- [8]
            },
        }, -- [6]
        {
            ["id"] = 66,
            ["image"] = 522350,
            ["name"] = "Blackrock Caverns",
            ["bosses"] = {
                {
                    ["id"] = 105,
                    ["image"] = 522266,
                    ["name"] = "Rom'ogg Bonecrusher",
                }, -- [1]
                {
                    ["id"] = 106,
                    ["image"] = 522216,
                    ["name"] = "Corla, Herald of Twilight",
                }, -- [2]
                {
                    ["id"] = 107,
                    ["image"] = 522244,
                    ["name"] = "Karsh Steelbender",
                }, -- [3]
                {
                    ["id"] = 108,
                    ["image"] = 522207,
                    ["name"] = "Beauty",
                }, -- [4]
                {
                    ["id"] = 109,
                    ["image"] = 522201,
                    ["name"] = "Ascendant Lord Obsidius",
                }, -- [5]
            },
        }, -- [7]
        {
            ["id"] = 63,
            ["image"] = 522352,
            ["name"] = "Deadmines",
            ["bosses"] = {
                {
                    ["id"] = 89,
                    ["image"] = 522228,
                    ["name"] = "Glubtok",
                }, -- [1]
                {
                    ["id"] = 90,
                    ["image"] = 522234,
                    ["name"] = "Helix Gearbreaker",
                }, -- [2]
                {
                    ["id"] = 91,
                    ["image"] = 522225,
                    ["name"] = "Foe Reaper 5000",
                }, -- [3]
                {
                    ["id"] = 92,
                    ["image"] = 522189,
                    ["name"] = "Admiral Ripsnarl",
                }, -- [4]
                {
                    ["id"] = 93,
                    ["image"] = 522210,
                    ["name"] = "\"Captain\" Cookie",
                }, -- [5]
            },
        }, -- [8]
        {
            ["id"] = 184,
            ["image"] = 571754,
            ["name"] = "End Time",
            ["bosses"] = {
                {
                    ["id"] = 340,
                    ["image"] = 571744,
                    ["name"] = "Echo of Baine",
                }, -- [1]
                {
                    ["id"] = 285,
                    ["image"] = 571745,
                    ["name"] = "Echo of Jaina",
                }, -- [2]
                {
                    ["id"] = 323,
                    ["image"] = 571748,
                    ["name"] = "Echo of Sylvanas",
                }, -- [3]
                {
                    ["id"] = 283,
                    ["image"] = 571749,
                    ["name"] = "Echo of Tyrande",
                }, -- [4]
                {
                    ["id"] = 289,
                    ["image"] = 536059,
                    ["name"] = "Murozond",
                }, -- [5]
            },
        }, -- [9]
        {
            ["id"] = 71,
            ["image"] = 522354,
            ["name"] = "Grim Batol",
            ["bosses"] = {
                {
                    ["id"] = 131,
                    ["image"] = 522227,
                    ["name"] = "General Umbriss",
                }, -- [1]
                {
                    ["id"] = 132,
                    ["image"] = 522226,
                    ["name"] = "Forgemaster Throngus",
                }, -- [2]
                {
                    ["id"] = 133,
                    ["image"] = 522218,
                    ["name"] = "Drahga Shadowburner",
                }, -- [3]
                {
                    ["id"] = 134,
                    ["image"] = 522222,
                    ["name"] = "Erudax, the Duke of Below",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 70,
            ["image"] = 522356,
            ["name"] = "Halls of Origination",
            ["bosses"] = {
                {
                    ["id"] = 124,
                    ["image"] = 522272,
                    ["name"] = "Temple Guardian Anhuur",
                }, -- [1]
                {
                    ["id"] = 125,
                    ["image"] = 522219,
                    ["name"] = "Earthrager Ptah",
                }, -- [2]
                {
                    ["id"] = 126,
                    ["image"] = 522195,
                    ["name"] = "Anraphet",
                }, -- [3]
                {
                    ["id"] = 127,
                    ["image"] = 522241,
                    ["name"] = "Isiset, Construct of Magic",
                }, -- [4]
                {
                    ["id"] = 128,
                    ["image"] = 522194,
                    ["name"] = "Ammunae, Construct of Life",
                }, -- [5]
                {
                    ["id"] = 129,
                    ["image"] = 522267,
                    ["name"] = "Setesh, Construct of Destruction",
                }, -- [6]
                {
                    ["id"] = 130,
                    ["image"] = 522262,
                    ["name"] = "Rajh, Construct of Sun",
                }, -- [7]
            },
        }, -- [11]
        {
            ["id"] = 186,
            ["image"] = 571755,
            ["name"] = "Hour of Twilight",
            ["bosses"] = {
                {
                    ["id"] = 322,
                    ["image"] = 571743,
                    ["name"] = "Arcurion",
                }, -- [1]
                {
                    ["id"] = 342,
                    ["image"] = 536054,
                    ["name"] = "Asira Dawnslayer",
                }, -- [2]
                {
                    ["id"] = 341,
                    ["image"] = 536053,
                    ["name"] = "Archbishop Benedictus",
                }, -- [3]
            },
        }, -- [12]
        {
            ["id"] = 69,
            ["image"] = 522357,
            ["name"] = "Lost City of the Tol'vir",
            ["bosses"] = {
                {
                    ["id"] = 117,
                    ["image"] = 523205,
                    ["name"] = "General Husam",
                }, -- [1]
                {
                    ["id"] = 118,
                    ["image"] = 522246,
                    ["name"] = "Lockmaw",
                }, -- [2]
                {
                    ["id"] = 119,
                    ["image"] = 522239,
                    ["name"] = "High Prophet Barim",
                }, -- [3]
                {
                    ["id"] = 122,
                    ["image"] = 522269,
                    ["name"] = "Siamat",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 64,
            ["image"] = 522358,
            ["name"] = "Shadowfang Keep",
            ["bosses"] = {
                {
                    ["id"] = 96,
                    ["image"] = 522205,
                    ["name"] = "Baron Ashbury",
                }, -- [1]
                {
                    ["id"] = 97,
                    ["image"] = 522206,
                    ["name"] = "Baron Silverlaine",
                }, -- [2]
                {
                    ["id"] = 98,
                    ["image"] = 522213,
                    ["name"] = "Commander Springvale",
                }, -- [3]
                {
                    ["id"] = 99,
                    ["image"] = 522249,
                    ["name"] = "Lord Walden",
                }, -- [4]
                {
                    ["id"] = 100,
                    ["image"] = 522247,
                    ["name"] = "Lord Godfrey",
                }, -- [5]
            },
        }, -- [14]
        {
            ["id"] = 67,
            ["image"] = 522360,
            ["name"] = "The Stonecore",
            ["bosses"] = {
                {
                    ["id"] = 110,
                    ["image"] = 522215,
                    ["name"] = "Corborus",
                }, -- [1]
                {
                    ["id"] = 111,
                    ["image"] = 522271,
                    ["name"] = "Slabhide",
                }, -- [2]
                {
                    ["id"] = 112,
                    ["image"] = 522258,
                    ["name"] = "Ozruk",
                }, -- [3]
                {
                    ["id"] = 113,
                    ["image"] = 522237,
                    ["name"] = "High Priestess Azil",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 68,
            ["image"] = 522361,
            ["name"] = "The Vortex Pinnacle",
            ["bosses"] = {
                {
                    ["id"] = 114,
                    ["image"] = 522229,
                    ["name"] = "Grand Vizier Ertan",
                }, -- [1]
                {
                    ["id"] = 115,
                    ["image"] = 522192,
                    ["name"] = "Altairus",
                }, -- [2]
                {
                    ["id"] = 116,
                    ["image"] = 522200,
                    ["name"] = "Asaad, Caliph of Zephyrs",
                }, -- [3]
            },
        }, -- [16]
        {
            ["id"] = 65,
            ["image"] = 522362,
            ["name"] = "Throne of the Tides",
            ["bosses"] = {
                {
                    ["id"] = 101,
                    ["image"] = 522245,
                    ["name"] = "Lady Naz'jar",
                }, -- [1]
                {
                    ["id"] = 102,
                    ["image"] = 522214,
                    ["name"] = "Commander Ulthok, the Festering Prince",
                }, -- [2]
                {
                    ["id"] = 103,
                    ["image"] = 522253,
                    ["name"] = "Mindbender Ghur'sha",
                }, -- [3]
                {
                    ["id"] = 104,
                    ["image"] = 522259,
                    ["name"] = "Ozumat",
                }, -- [4]
            },
        }, -- [17]
        {
            ["id"] = 185,
            ["image"] = 571756,
            ["name"] = "Well of Eternity",
            ["bosses"] = {
                {
                    ["id"] = 290,
                    ["image"] = 536060,
                    ["name"] = "Peroth'arn",
                }, -- [1]
                {
                    ["id"] = 291,
                    ["image"] = 571747,
                    ["name"] = "Queen Azshara",
                }, -- [2]
                {
                    ["id"] = 292,
                    ["image"] = 571746,
                    ["name"] = "Mannoroth and Varo'then",
                }, -- [3]
            },
        }, -- [18]
        {
            ["id"] = 77,
            ["image"] = 522363,
            ["name"] = "Zul'Aman",
            ["bosses"] = {
                {
                    ["id"] = 186,
                    ["image"] = 522190,
                    ["name"] = "Akil'zon",
                }, -- [1]
                {
                    ["id"] = 187,
                    ["image"] = 522254,
                    ["name"] = "Nalorakk",
                }, -- [2]
                {
                    ["id"] = 188,
                    ["image"] = 522242,
                    ["name"] = "Jan'alai",
                }, -- [3]
                {
                    ["id"] = 189,
                    ["image"] = 522231,
                    ["name"] = "Halazzi",
                }, -- [4]
                {
                    ["id"] = 190,
                    ["image"] = 522235,
                    ["name"] = "Hex Lord Malacrass",
                }, -- [5]
                {
                    ["id"] = 191,
                    ["image"] = 522217,
                    ["name"] = "Daakara",
                }, -- [6]
            },
        }, -- [19]
        {
            ["id"] = 76,
            ["image"] = 522364,
            ["name"] = "Zul'Gurub",
            ["bosses"] = {
                {
                    ["id"] = 175,
                    ["image"] = 522236,
                    ["name"] = "High Priest Venoxis",
                }, -- [1]
                {
                    ["id"] = 176,
                    ["image"] = 522209,
                    ["name"] = "Bloodlord Mandokir",
                }, -- [2]
                {
                    ["id"] = 177,
                    ["image"] = 522230,
                    ["name"] = "Cache of Madness - Gri'lek",
                }, -- [3]
                {
                    ["id"] = 178,
                    ["image"] = 522233,
                    ["name"] = "Cache of Madness - Hazza'rah",
                }, -- [4]
                {
                    ["id"] = 179,
                    ["image"] = 522263,
                    ["name"] = "Cache of Madness - Renataki",
                }, -- [5]
                {
                    ["id"] = 180,
                    ["image"] = 522279,
                    ["name"] = "Cache of Madness - Wushoolay",
                }, -- [6]
                {
                    ["id"] = 181,
                    ["image"] = 522238,
                    ["name"] = "High Priestess Kilnara",
                }, -- [7]
                {
                    ["id"] = 184,
                    ["image"] = 522280,
                    ["name"] = "Zanzil",
                }, -- [8]
                {
                    ["id"] = 185,
                    ["image"] = 522243,
                    ["name"] = "Jin'do the Godbreaker",
                }, -- [9]
            },
        }, -- [20]
    },
    ["Mists of Pandaria"] = {
        {
            ["id"] = 322,
            ["image"] = 652218,
            ["name"] = "Pandaria",
            ["bosses"] = {
                {
                    ["id"] = 691,
                    ["image"] = 630847,
                    ["name"] = "Sha of Anger",
                }, -- [1]
                {
                    ["id"] = 725,
                    ["image"] = 630819,
                    ["name"] = "Salyis's Warband",
                }, -- [2]
                {
                    ["id"] = 814,
                    ["image"] = 796778,
                    ["name"] = "Nalak, The Storm Lord",
                }, -- [3]
                {
                    ["id"] = 826,
                    ["image"] = 796779,
                    ["name"] = "Oondasta",
                }, -- [4]
                {
                    ["id"] = 857,
                    ["image"] = 901155,
                    ["name"] = "Chi-Ji, The Red Crane",
                }, -- [5]
                {
                    ["id"] = 858,
                    ["image"] = 901173,
                    ["name"] = "Yu'lon, The Jade Serpent",
                }, -- [6]
                {
                    ["id"] = 859,
                    ["image"] = 901165,
                    ["name"] = "Niuzao, The Black Ox",
                }, -- [7]
                {
                    ["id"] = 860,
                    ["image"] = 901172,
                    ["name"] = "Xuen, The White Tiger",
                }, -- [8]
                {
                    ["id"] = 861,
                    ["image"] = 901167,
                    ["name"] = "Ordos, Fire-God of the Yaungol",
                }, -- [9]
            },
        }, -- [1]
        {
            ["id"] = 317,
            ["image"] = 632273,
            ["name"] = "Mogu'shan Vaults",
            ["bosses"] = {
                {
                    ["id"] = 679,
                    ["image"] = 630820,
                    ["name"] = "The Stone Guard",
                }, -- [1]
                {
                    ["id"] = 689,
                    ["image"] = 630824,
                    ["name"] = "Feng the Accursed",
                }, -- [2]
                {
                    ["id"] = 682,
                    ["image"] = 630826,
                    ["name"] = "Gara'jal the Spiritbinder",
                }, -- [3]
                {
                    ["id"] = 687,
                    ["image"] = 630861,
                    ["name"] = "The Spirit Kings",
                }, -- [4]
                {
                    ["id"] = 726,
                    ["image"] = 630823,
                    ["name"] = "Elegon",
                }, -- [5]
                {
                    ["id"] = 677,
                    ["image"] = 630836,
                    ["name"] = "Will of the Emperor",
                }, -- [6]
            },
        }, -- [2]
        {
            ["id"] = 330,
            ["image"] = 632271,
            ["name"] = "Heart of Fear",
            ["bosses"] = {
                {
                    ["id"] = 745,
                    ["image"] = 630834,
                    ["name"] = "Imperial Vizier Zor'lok",
                }, -- [1]
                {
                    ["id"] = 744,
                    ["image"] = 630817,
                    ["name"] = "Blade Lord Ta'yak",
                }, -- [2]
                {
                    ["id"] = 713,
                    ["image"] = 630827,
                    ["name"] = "Garalon",
                }, -- [3]
                {
                    ["id"] = 741,
                    ["image"] = 630856,
                    ["name"] = "Wind Lord Mel'jarak",
                }, -- [4]
                {
                    ["id"] = 737,
                    ["image"] = 630815,
                    ["name"] = "Amber-Shaper Un'sok",
                }, -- [5]
                {
                    ["id"] = 743,
                    ["image"] = 630830,
                    ["name"] = "Grand Empress Shek'zeer",
                }, -- [6]
            },
        }, -- [3]
        {
            ["id"] = 320,
            ["image"] = 643264,
            ["name"] = "Terrace of Endless Spring",
            ["bosses"] = {
                {
                    ["id"] = 683,
                    ["image"] = 630844,
                    ["name"] = "Protectors of the Endless",
                }, -- [1]
                {
                    ["id"] = 742,
                    ["image"] = 630854,
                    ["name"] = "Tsulong",
                }, -- [2]
                {
                    ["id"] = 729,
                    ["image"] = 630837,
                    ["name"] = "Lei Shi",
                }, -- [3]
                {
                    ["id"] = 709,
                    ["image"] = 630849,
                    ["name"] = "Sha of Fear",
                }, -- [4]
            },
        }, -- [4]
        {
            ["id"] = 362,
            ["image"] = 828453,
            ["name"] = "Throne of Thunder",
            ["bosses"] = {
                {
                    ["id"] = 827,
                    ["image"] = 796776,
                    ["name"] = "Jin'rokh the Breaker",
                }, -- [1]
                {
                    ["id"] = 819,
                    ["image"] = 796774,
                    ["name"] = "Horridon",
                }, -- [2]
                {
                    ["id"] = 816,
                    ["image"] = 796770,
                    ["name"] = "Council of Elders",
                }, -- [3]
                {
                    ["id"] = 825,
                    ["image"] = 796781,
                    ["name"] = "Tortos",
                }, -- [4]
                {
                    ["id"] = 821,
                    ["image"] = 796786,
                    ["name"] = "Megaera",
                }, -- [5]
                {
                    ["id"] = 828,
                    ["image"] = 796785,
                    ["name"] = "Ji-Kun",
                }, -- [6]
                {
                    ["id"] = 818,
                    ["image"] = 796772,
                    ["name"] = "Durumu the Forgotten",
                }, -- [7]
                {
                    ["id"] = 820,
                    ["image"] = 796780,
                    ["name"] = "Primordius",
                }, -- [8]
                {
                    ["id"] = 824,
                    ["image"] = 796771,
                    ["name"] = "Dark Animus",
                }, -- [9]
                {
                    ["id"] = 817,
                    ["image"] = 796775,
                    ["name"] = "Iron Qon",
                }, -- [10]
                {
                    ["id"] = 829,
                    ["image"] = 796773,
                    ["name"] = "Twin Empyreans",
                }, -- [11]
                {
                    ["id"] = 832,
                    ["image"] = 796777,
                    ["name"] = "Lei Shen",
                }, -- [12]
            },
        }, -- [5]
        {
            ["id"] = 369,
            ["image"] = 904981,
            ["name"] = "Siege of Orgrimmar",
            ["bosses"] = {
                {
                    ["id"] = 852,
                    ["image"] = 901160,
                    ["name"] = "Immerseus",
                }, -- [1]
                {
                    ["id"] = 849,
                    ["image"] = 901159,
                    ["name"] = "The Fallen Protectors",
                }, -- [2]
                {
                    ["id"] = 866,
                    ["image"] = 901166,
                    ["name"] = "Norushen",
                }, -- [3]
                {
                    ["id"] = 867,
                    ["image"] = 901168,
                    ["name"] = "Sha of Pride",
                }, -- [4]
                {
                    ["id"] = 868,
                    ["image"] = 901156,
                    ["name"] = "Galakras",
                }, -- [5]
                {
                    ["id"] = 864,
                    ["image"] = 901161,
                    ["name"] = "Iron Juggernaut",
                }, -- [6]
                {
                    ["id"] = 856,
                    ["image"] = 901163,
                    ["name"] = "Kor'kron Dark Shaman",
                }, -- [7]
                {
                    ["id"] = 850,
                    ["image"] = 901158,
                    ["name"] = "General Nazgrim",
                }, -- [8]
                {
                    ["id"] = 846,
                    ["image"] = 901164,
                    ["name"] = "Malkorok",
                }, -- [9]
                {
                    ["id"] = 870,
                    ["image"] = 901170,
                    ["name"] = "Spoils of Pandaria",
                }, -- [10]
                {
                    ["id"] = 851,
                    ["image"] = 901171,
                    ["name"] = "Thok the Bloodthirsty",
                }, -- [11]
                {
                    ["id"] = 865,
                    ["image"] = 901169,
                    ["name"] = "Siegecrafter Blackfuse",
                }, -- [12]
                {
                    ["id"] = 853,
                    ["image"] = 901162,
                    ["name"] = "Paragons of the Klaxxi",
                }, -- [13]
                {
                    ["id"] = 869,
                    ["image"] = 901157,
                    ["name"] = "Garrosh Hellscream",
                }, -- [14]
            },
        }, -- [6]
        {
            ["id"] = 303,
            ["image"] = 632270,
            ["name"] = "Gate of the Setting Sun",
            ["bosses"] = {
                {
                    ["id"] = 655,
                    ["image"] = 630846,
                    ["name"] = "Saboteur Kip'tilak",
                }, -- [1]
                {
                    ["id"] = 675,
                    ["image"] = 630851,
                    ["name"] = "Striker Ga'dok",
                }, -- [2]
                {
                    ["id"] = 676,
                    ["image"] = 630821,
                    ["name"] = "Commander Ri'mok",
                }, -- [3]
                {
                    ["id"] = 649,
                    ["image"] = 630845,
                    ["name"] = "Raigonn",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 321,
            ["image"] = 632272,
            ["name"] = "Mogu'shan Palace",
            ["bosses"] = {
                {
                    ["id"] = 708,
                    ["image"] = 630842,
                    ["name"] = "Trial of the King",
                }, -- [1]
                {
                    ["id"] = 690,
                    ["image"] = 630828,
                    ["name"] = "Gekkan",
                }, -- [2]
                {
                    ["id"] = 698,
                    ["image"] = 630859,
                    ["name"] = "Xin the Weaponmaster",
                }, -- [3]
            },
        }, -- [8]
        {
            ["id"] = 311,
            ["image"] = 643262,
            ["name"] = "Scarlet Halls",
            ["bosses"] = {
                {
                    ["id"] = 660,
                    ["image"] = 630833,
                    ["name"] = "Houndmaster Braun",
                }, -- [1]
                {
                    ["id"] = 654,
                    ["image"] = 630816,
                    ["name"] = "Armsmaster Harlan",
                }, -- [2]
                {
                    ["id"] = 656,
                    ["image"] = 630825,
                    ["name"] = "Flameweaver Koegler",
                }, -- [3]
            },
        }, -- [9]
        {
            ["id"] = 316,
            ["image"] = 608214,
            ["name"] = "Scarlet Monastery",
            ["bosses"] = {
                {
                    ["id"] = 688,
                    ["image"] = 630853,
                    ["name"] = "Thalnos the Soulrender",
                }, -- [1]
                {
                    ["id"] = 671,
                    ["image"] = 630818,
                    ["name"] = "Brother Korloff",
                }, -- [2]
                {
                    ["id"] = 674,
                    ["image"] = 607643,
                    ["name"] = "High Inquisitor Whitemane",
                }, -- [3]
            },
        }, -- [10]
        {
            ["id"] = 246,
            ["image"] = 608215,
            ["name"] = "Scholomance",
            ["bosses"] = {
                {
                    ["id"] = 659,
                    ["image"] = 630835,
                    ["name"] = "Instructor Chillheart",
                }, -- [1]
                {
                    ["id"] = 663,
                    ["image"] = 607666,
                    ["name"] = "Jandice Barov",
                }, -- [2]
                {
                    ["id"] = 665,
                    ["image"] = 607755,
                    ["name"] = "Rattlegore",
                }, -- [3]
                {
                    ["id"] = 666,
                    ["image"] = 630838,
                    ["name"] = "Lilian Voss",
                }, -- [4]
                {
                    ["id"] = 684,
                    ["image"] = 607582,
                    ["name"] = "Darkmaster Gandling",
                }, -- [5]
            },
        }, -- [11]
        {
            ["id"] = 312,
            ["image"] = 632274,
            ["name"] = "Shado-Pan Monastery",
            ["bosses"] = {
                {
                    ["id"] = 673,
                    ["image"] = 630831,
                    ["name"] = "Gu Cloudstrike",
                }, -- [1]
                {
                    ["id"] = 657,
                    ["image"] = 630841,
                    ["name"] = "Master Snowdrift",
                }, -- [2]
                {
                    ["id"] = 685,
                    ["image"] = 630850,
                    ["name"] = "Sha of Violence",
                }, -- [3]
                {
                    ["id"] = 686,
                    ["image"] = 630852,
                    ["name"] = "Taran Zhu",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 324,
            ["image"] = 643263,
            ["name"] = "Siege of Niuzao Temple",
            ["bosses"] = {
                {
                    ["id"] = 693,
                    ["image"] = 630855,
                    ["name"] = "Vizier Jin'bak",
                }, -- [1]
                {
                    ["id"] = 738,
                    ["image"] = 630822,
                    ["name"] = "Commander Vo'jak",
                }, -- [2]
                {
                    ["id"] = 692,
                    ["image"] = 630829,
                    ["name"] = "General Pa'valak",
                }, -- [3]
                {
                    ["id"] = 727,
                    ["image"] = 630857,
                    ["name"] = "Wing Leader Ner'onok",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 302,
            ["image"] = 632275,
            ["name"] = "Stormstout Brewery",
            ["bosses"] = {
                {
                    ["id"] = 668,
                    ["image"] = 630843,
                    ["name"] = "Ook-Ook",
                }, -- [1]
                {
                    ["id"] = 669,
                    ["image"] = 630832,
                    ["name"] = "Hoptallus",
                }, -- [2]
                {
                    ["id"] = 670,
                    ["image"] = 630860,
                    ["name"] = "Yan-Zhu the Uncasked",
                }, -- [3]
            },
        }, -- [14]
        {
            ["id"] = 313,
            ["image"] = 632276,
            ["name"] = "Temple of the Jade Serpent",
            ["bosses"] = {
                {
                    ["id"] = 672,
                    ["image"] = 630858,
                    ["name"] = "Wise Mari",
                }, -- [1]
                {
                    ["id"] = 664,
                    ["image"] = 630840,
                    ["name"] = "Lorewalker Stonestep",
                }, -- [2]
                {
                    ["id"] = 658,
                    ["image"] = 630839,
                    ["name"] = "Liu Flameheart",
                }, -- [3]
                {
                    ["id"] = 335,
                    ["image"] = 630848,
                    ["name"] = "Sha of Doubt",
                }, -- [4]
            },
        }, -- [15]
    },
    ["Current Season"] = {
        {
            ["id"] = 1194,
            ["image"] = 4182022,
            ["name"] = "Tazavesh, the Veiled Market",
            ["bosses"] = {
                {
                    ["id"] = 2437,
                    ["image"] = 4071449,
                    ["name"] = "Zo'phex the Sentinel",
                }, -- [1]
                {
                    ["id"] = 2454,
                    ["image"] = 4071447,
                    ["name"] = "The Grand Menagerie",
                }, -- [2]
                {
                    ["id"] = 2436,
                    ["image"] = 4071438,
                    ["name"] = "Mailroom Mayhem",
                }, -- [3]
                {
                    ["id"] = 2452,
                    ["image"] = 4071448,
                    ["name"] = "Myza's Oasis",
                }, -- [4]
                {
                    ["id"] = 2451,
                    ["image"] = 4071440,
                    ["name"] = "So'azmi",
                }, -- [5]
                {
                    ["id"] = 2448,
                    ["image"] = 4071429,
                    ["name"] = "Hylbrande",
                }, -- [6]
                {
                    ["id"] = 2449,
                    ["image"] = 4071446,
                    ["name"] = "Timecap'n Hooktail",
                }, -- [7]
                {
                    ["id"] = 2455,
                    ["image"] = 4071441,
                    ["name"] = "So'leah",
                }, -- [8]
            },
        }, -- [1]
        {
            ["id"] = 860,
            ["image"] = 1537283,
            ["name"] = "Return to Karazhan",
            ["bosses"] = {
                {
                    ["id"] = 1820,
                    ["image"] = 1536495,
                    ["name"] = "Opera Hall: Wikket",
                }, -- [1]
                {
                    ["id"] = 1826,
                    ["image"] = 1536494,
                    ["name"] = "Opera Hall: Westfall Story",
                }, -- [2]
                {
                    ["id"] = 1827,
                    ["image"] = 1536493,
                    ["name"] = "Opera Hall: Beautiful Beast",
                }, -- [3]
                {
                    ["id"] = 1825,
                    ["image"] = 1378997,
                    ["name"] = "Maiden of Virtue",
                }, -- [4]
                {
                    ["id"] = 1835,
                    ["image"] = 1536490,
                    ["name"] = "Attumen the Huntsman",
                }, -- [5]
                {
                    ["id"] = 1837,
                    ["image"] = 1378999,
                    ["name"] = "Moroes",
                }, -- [6]
                {
                    ["id"] = 1836,
                    ["image"] = 1379020,
                    ["name"] = "The Curator",
                }, -- [7]
                {
                    ["id"] = 1817,
                    ["image"] = 1536496,
                    ["name"] = "Shade of Medivh",
                }, -- [8]
                {
                    ["id"] = 1818,
                    ["image"] = 1536492,
                    ["name"] = "Mana Devourer",
                }, -- [9]
                {
                    ["id"] = 1838,
                    ["image"] = 1536497,
                    ["name"] = "Viz'aduum the Watcher",
                }, -- [10]
            },
        }, -- [2]
        {
            ["id"] = 1178,
            ["image"] = 3025325,
            ["name"] = "Operation: Mechagon",
            ["bosses"] = {
                {
                    ["id"] = 2357,
                    ["image"] = 3012050,
                    ["name"] = "King Gobbamak",
                }, -- [1]
                {
                    ["id"] = 2358,
                    ["image"] = 3012048,
                    ["name"] = "Gunker",
                }, -- [2]
                {
                    ["id"] = 2360,
                    ["image"] = 3012059,
                    ["name"] = "Trixie & Naeno",
                }, -- [3]
                {
                    ["id"] = 2355,
                    ["image"] = 3012049,
                    ["name"] = "HK-8 Aerial Oppression Unit",
                }, -- [4]
                {
                    ["id"] = 2336,
                    ["image"] = 3012060,
                    ["name"] = "Tussle Tonks",
                }, -- [5]
                {
                    ["id"] = 2339,
                    ["image"] = 3012052,
                    ["name"] = "K.U.-J.0.",
                }, -- [6]
                {
                    ["id"] = 2348,
                    ["image"] = 3012053,
                    ["name"] = "Machinist's Garden",
                }, -- [7]
                {
                    ["id"] = 2331,
                    ["image"] = 3012051,
                    ["name"] = "King Mechagon",
                }, -- [8]
            },
        }, -- [3]
        {
            ["id"] = 558,
            ["image"] = 1060548,
            ["name"] = "Iron Docks",
            ["bosses"] = {
                {
                    ["id"] = 1235,
                    ["image"] = 1044380,
                    ["name"] = "Fleshrender Nok'gar",
                }, -- [1]
                {
                    ["id"] = 1236,
                    ["image"] = 1044340,
                    ["name"] = "Grimrail Enforcers",
                }, -- [2]
                {
                    ["id"] = 1237,
                    ["image"] = 1044359,
                    ["name"] = "Oshir",
                }, -- [3]
                {
                    ["id"] = 1238,
                    ["image"] = 1044367,
                    ["name"] = "Skulloc",
                }, -- [4]
            },
        }, -- [4]
        {
            ["id"] = 536,
            ["image"] = 1041996,
            ["name"] = "Grimrail Depot",
            ["bosses"] = {
                {
                    ["id"] = 1138,
                    ["image"] = 1044360,
                    ["name"] = "Rocketspark and Borka",
                }, -- [1]
                {
                    ["id"] = 1163,
                    ["image"] = 1044339,
                    ["name"] = "Nitrogg Thundertower",
                }, -- [2]
                {
                    ["id"] = 1133,
                    ["image"] = 1044376,
                    ["name"] = "Skylord Tovra",
                }, -- [3]
            },
        }, -- [5]
    },
    ["Warlords of Draenor"] = {
        {
            ["id"] = 557,
            ["image"] = 1041995,
            ["name"] = "Draenor",
            ["bosses"] = {
                {
                    ["id"] = 1291,
                    ["image"] = 1044483,
                    ["name"] = "Drov the Ruiner",
                }, -- [1]
                {
                    ["id"] = 1211,
                    ["image"] = 1044371,
                    ["name"] = "Tarlna the Ageless",
                }, -- [2]
                {
                    ["id"] = 1262,
                    ["image"] = 1044364,
                    ["name"] = "Rukhmar",
                }, -- [3]
                {
                    ["id"] = 1452,
                    ["image"] = 1134508,
                    ["name"] = "Supreme Lord Kazzak",
                }, -- [4]
            },
        }, -- [1]
        {
            ["id"] = 477,
            ["image"] = 1041997,
            ["name"] = "Highmaul",
            ["bosses"] = {
                {
                    ["id"] = 1128,
                    ["image"] = 1044352,
                    ["name"] = "Kargath Bladefist",
                }, -- [1]
                {
                    ["id"] = 971,
                    ["image"] = 1044375,
                    ["name"] = "The Butcher",
                }, -- [2]
                {
                    ["id"] = 1195,
                    ["image"] = 1044372,
                    ["name"] = "Tectus",
                }, -- [3]
                {
                    ["id"] = 1196,
                    ["image"] = 1044342,
                    ["name"] = "Brackenspore",
                }, -- [4]
                {
                    ["id"] = 1148,
                    ["image"] = 1044377,
                    ["name"] = "Twin Ogron",
                }, -- [5]
                {
                    ["id"] = 1153,
                    ["image"] = 1044343,
                    ["name"] = "Ko'ragh",
                }, -- [6]
                {
                    ["id"] = 1197,
                    ["image"] = 1044349,
                    ["name"] = "Imperator Mar'gok",
                }, -- [7]
            },
        }, -- [2]
        {
            ["id"] = 457,
            ["image"] = 1041993,
            ["name"] = "Blackrock Foundry",
            ["bosses"] = {
                {
                    ["id"] = 1202,
                    ["image"] = 1044484,
                    ["name"] = "Oregorger",
                }, -- [1]
                {
                    ["id"] = 1155,
                    ["image"] = 1044345,
                    ["name"] = "Hans'gar and Franzok",
                }, -- [2]
                {
                    ["id"] = 1122,
                    ["image"] = 1044338,
                    ["name"] = "Beastlord Darmac",
                }, -- [3]
                {
                    ["id"] = 1161,
                    ["image"] = 1044346,
                    ["name"] = "Gruul",
                }, -- [4]
                {
                    ["id"] = 1123,
                    ["image"] = 1044344,
                    ["name"] = "Flamebender Ka'graz",
                }, -- [5]
                {
                    ["id"] = 1147,
                    ["image"] = 1044357,
                    ["name"] = "Operator Thogar",
                }, -- [6]
                {
                    ["id"] = 1154,
                    ["image"] = 1044374,
                    ["name"] = "The Blast Furnace",
                }, -- [7]
                {
                    ["id"] = 1162,
                    ["image"] = 1044353,
                    ["name"] = "Kromog",
                }, -- [8]
                {
                    ["id"] = 1203,
                    ["image"] = 1044350,
                    ["name"] = "The Iron Maidens",
                }, -- [9]
                {
                    ["id"] = 959,
                    ["image"] = 1044378,
                    ["name"] = "Blackhand",
                }, -- [10]
            },
        }, -- [3]
        {
            ["id"] = 669,
            ["image"] = 1135118,
            ["name"] = "Hellfire Citadel",
            ["bosses"] = {
                {
                    ["id"] = 1426,
                    ["image"] = 1134502,
                    ["name"] = "Hellfire Assault",
                }, -- [1]
                {
                    ["id"] = 1425,
                    ["image"] = 1134499,
                    ["name"] = "Iron Reaver",
                }, -- [2]
                {
                    ["id"] = 1392,
                    ["image"] = 1134504,
                    ["name"] = "Kormrok",
                }, -- [3]
                {
                    ["id"] = 1432,
                    ["image"] = 1134501,
                    ["name"] = "Hellfire High Council",
                }, -- [4]
                {
                    ["id"] = 1396,
                    ["image"] = 1134503,
                    ["name"] = "Kilrogg Deadeye",
                }, -- [5]
                {
                    ["id"] = 1372,
                    ["image"] = 1134500,
                    ["name"] = "Gorefiend",
                }, -- [6]
                {
                    ["id"] = 1433,
                    ["image"] = 1134506,
                    ["name"] = "Shadow-Lord Iskar",
                }, -- [7]
                {
                    ["id"] = 1427,
                    ["image"] = 1134507,
                    ["name"] = "Socrethar the Eternal",
                }, -- [8]
                {
                    ["id"] = 1391,
                    ["image"] = 1134498,
                    ["name"] = "Fel Lord Zakuun",
                }, -- [9]
                {
                    ["id"] = 1447,
                    ["image"] = 1134510,
                    ["name"] = "Xhul'horac",
                }, -- [10]
                {
                    ["id"] = 1394,
                    ["image"] = 1134509,
                    ["name"] = "Tyrant Velhari",
                }, -- [11]
                {
                    ["id"] = 1395,
                    ["image"] = 1134505,
                    ["name"] = "Mannoroth",
                }, -- [12]
                {
                    ["id"] = 1438,
                    ["image"] = 1134497,
                    ["name"] = "Archimonde",
                }, -- [13]
            },
        }, -- [4]
        {
            ["id"] = 547,
            ["image"] = 1041992,
            ["name"] = "Auchindoun",
            ["bosses"] = {
                {
                    ["id"] = 1185,
                    ["image"] = 1044336,
                    ["name"] = "Vigilant Kaathar",
                }, -- [1]
                {
                    ["id"] = 1186,
                    ["image"] = 1044370,
                    ["name"] = "Soulbinder Nyami",
                }, -- [2]
                {
                    ["id"] = 1216,
                    ["image"] = 1044337,
                    ["name"] = "Azzakel",
                }, -- [3]
                {
                    ["id"] = 1225,
                    ["image"] = 1044373,
                    ["name"] = "Teron'gor",
                }, -- [4]
            },
        }, -- [5]
        {
            ["id"] = 385,
            ["image"] = 1041994,
            ["name"] = "Bloodmaul Slag Mines",
            ["bosses"] = {
                {
                    ["id"] = 893,
                    ["image"] = 1044355,
                    ["name"] = "Magmolatus",
                }, -- [1]
                {
                    ["id"] = 888,
                    ["image"] = 1044368,
                    ["name"] = "Slave Watcher Crushto",
                }, -- [2]
                {
                    ["id"] = 887,
                    ["image"] = 1044363,
                    ["name"] = "Roltall",
                }, -- [3]
                {
                    ["id"] = 889,
                    ["image"] = 1044347,
                    ["name"] = "Gug'rokk",
                }, -- [4]
            },
        }, -- [6]
        {
            ["id"] = 536,
            ["image"] = 1041996,
            ["name"] = "Grimrail Depot",
            ["bosses"] = {
                {
                    ["id"] = 1138,
                    ["image"] = 1044360,
                    ["name"] = "Rocketspark and Borka",
                }, -- [1]
                {
                    ["id"] = 1163,
                    ["image"] = 1044339,
                    ["name"] = "Nitrogg Thundertower",
                }, -- [2]
                {
                    ["id"] = 1133,
                    ["image"] = 1044376,
                    ["name"] = "Skylord Tovra",
                }, -- [3]
            },
        }, -- [7]
        {
            ["id"] = 558,
            ["image"] = 1060548,
            ["name"] = "Iron Docks",
            ["bosses"] = {
                {
                    ["id"] = 1235,
                    ["image"] = 1044380,
                    ["name"] = "Fleshrender Nok'gar",
                }, -- [1]
                {
                    ["id"] = 1236,
                    ["image"] = 1044340,
                    ["name"] = "Grimrail Enforcers",
                }, -- [2]
                {
                    ["id"] = 1237,
                    ["image"] = 1044359,
                    ["name"] = "Oshir",
                }, -- [3]
                {
                    ["id"] = 1238,
                    ["image"] = 1044367,
                    ["name"] = "Skulloc",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 537,
            ["image"] = 1041998,
            ["name"] = "Shadowmoon Burial Grounds",
            ["bosses"] = {
                {
                    ["id"] = 1139,
                    ["image"] = 1044366,
                    ["name"] = "Sadana Bloodfury",
                }, -- [1]
                {
                    ["id"] = 1168,
                    ["image"] = 1053564,
                    ["name"] = "Nhallish",
                }, -- [2]
                {
                    ["id"] = 1140,
                    ["image"] = 1044341,
                    ["name"] = "Bonemaw",
                }, -- [3]
                {
                    ["id"] = 1160,
                    ["image"] = 1044356,
                    ["name"] = "Ner'zhul",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 476,
            ["image"] = 1041999,
            ["name"] = "Skyreach",
            ["bosses"] = {
                {
                    ["id"] = 965,
                    ["image"] = 1044362,
                    ["name"] = "Ranjit",
                }, -- [1]
                {
                    ["id"] = 966,
                    ["image"] = 1044334,
                    ["name"] = "Araknath",
                }, -- [2]
                {
                    ["id"] = 967,
                    ["image"] = 1044365,
                    ["name"] = "Rukhran",
                }, -- [3]
                {
                    ["id"] = 968,
                    ["image"] = 1044348,
                    ["name"] = "High Sage Viryx",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 556,
            ["image"] = 1060547,
            ["name"] = "The Everbloom",
            ["bosses"] = {
                {
                    ["id"] = 1214,
                    ["image"] = 1044381,
                    ["name"] = "Witherbark",
                }, -- [1]
                {
                    ["id"] = 1207,
                    ["image"] = 1053563,
                    ["name"] = "Ancient Protectors",
                }, -- [2]
                {
                    ["id"] = 1208,
                    ["image"] = 1044335,
                    ["name"] = "Archmage Sol",
                }, -- [3]
                {
                    ["id"] = 1209,
                    ["image"] = 1044382,
                    ["name"] = "Xeri'tac",
                }, -- [4]
                {
                    ["id"] = 1210,
                    ["image"] = 1044383,
                    ["name"] = "Yalnu",
                }, -- [5]
            },
        }, -- [11]
        {
            ["id"] = 559,
            ["image"] = 1042000,
            ["name"] = "Upper Blackrock Spire",
            ["bosses"] = {
                {
                    ["id"] = 1226,
                    ["image"] = 1044358,
                    ["name"] = "Orebender Gor'ashan",
                }, -- [1]
                {
                    ["id"] = 1227,
                    ["image"] = 1044354,
                    ["name"] = "Kyrak",
                }, -- [2]
                {
                    ["id"] = 1228,
                    ["image"] = 1044351,
                    ["name"] = "Commander Tharbek",
                }, -- [3]
                {
                    ["id"] = 1229,
                    ["image"] = 1044361,
                    ["name"] = "Ragewing the Untamed",
                }, -- [4]
                {
                    ["id"] = 1234,
                    ["image"] = 1044379,
                    ["name"] = "Warlord Zaela",
                }, -- [5]
            },
        }, -- [12]
    },
    ["Wrath of the Lich King"] = {
        {
            ["id"] = 753,
            ["image"] = 1396596,
            ["name"] = "Vault of Archavon",
            ["bosses"] = {
                {
                    ["id"] = 1597,
                    ["image"] = 1385715,
                    ["name"] = "Archavon the Stone Watcher",
                }, -- [1]
                {
                    ["id"] = 1598,
                    ["image"] = 1385727,
                    ["name"] = "Emalon the Storm Watcher",
                }, -- [2]
                {
                    ["id"] = 1599,
                    ["image"] = 1385748,
                    ["name"] = "Koralon the Flame Watcher",
                }, -- [3]
                {
                    ["id"] = 1600,
                    ["image"] = 1385767,
                    ["name"] = "Toravon the Ice Watcher",
                }, -- [4]
            },
        }, -- [1]
        {
            ["id"] = 754,
            ["image"] = 1396587,
            ["name"] = "Naxxramas",
            ["bosses"] = {
                {
                    ["id"] = 1601,
                    ["image"] = 1378964,
                    ["name"] = "Anub'Rekhan",
                }, -- [1]
                {
                    ["id"] = 1602,
                    ["image"] = 1378980,
                    ["name"] = "Grand Widow Faerlina",
                }, -- [2]
                {
                    ["id"] = 1603,
                    ["image"] = 1378994,
                    ["name"] = "Maexxna",
                }, -- [3]
                {
                    ["id"] = 1604,
                    ["image"] = 1379004,
                    ["name"] = "Noth the Plaguebringer",
                }, -- [4]
                {
                    ["id"] = 1605,
                    ["image"] = 1378984,
                    ["name"] = "Heigan the Unclean",
                }, -- [5]
                {
                    ["id"] = 1606,
                    ["image"] = 1378991,
                    ["name"] = "Loatheb",
                }, -- [6]
                {
                    ["id"] = 1607,
                    ["image"] = 1378988,
                    ["name"] = "Instructor Razuvious",
                }, -- [7]
                {
                    ["id"] = 1608,
                    ["image"] = 1378979,
                    ["name"] = "Gothik the Harvester",
                }, -- [8]
                {
                    ["id"] = 1609,
                    ["image"] = 1385732,
                    ["name"] = "The Four Horsemen",
                }, -- [9]
                {
                    ["id"] = 1610,
                    ["image"] = 1379005,
                    ["name"] = "Patchwerk",
                }, -- [10]
                {
                    ["id"] = 1611,
                    ["image"] = 1378981,
                    ["name"] = "Grobbulus",
                }, -- [11]
                {
                    ["id"] = 1612,
                    ["image"] = 1378977,
                    ["name"] = "Gluth",
                }, -- [12]
                {
                    ["id"] = 1613,
                    ["image"] = 1379019,
                    ["name"] = "Thaddius",
                }, -- [13]
                {
                    ["id"] = 1614,
                    ["image"] = 1379010,
                    ["name"] = "Sapphiron",
                }, -- [14]
                {
                    ["id"] = 1615,
                    ["image"] = 1378989,
                    ["name"] = "Kel'Thuzad",
                }, -- [15]
            },
        }, -- [2]
        {
            ["id"] = 755,
            ["image"] = 1396588,
            ["name"] = "The Obsidian Sanctum",
            ["bosses"] = {
                {
                    ["id"] = 1616,
                    ["image"] = 1385765,
                    ["name"] = "Sartharion",
                }, -- [1]
            },
        }, -- [3]
        {
            ["id"] = 756,
            ["image"] = 1396581,
            ["name"] = "The Eye of Eternity",
            ["bosses"] = {
                {
                    ["id"] = 1617,
                    ["image"] = 1385753,
                    ["name"] = "Malygos",
                }, -- [1]
            },
        }, -- [4]
        {
            ["id"] = 759,
            ["image"] = 1396595,
            ["name"] = "Ulduar",
            ["bosses"] = {
                {
                    ["id"] = 1637,
                    ["image"] = 1385731,
                    ["name"] = "Flame Leviathan",
                }, -- [1]
                {
                    ["id"] = 1638,
                    ["image"] = 1385742,
                    ["name"] = "Ignis the Furnace Master",
                }, -- [2]
                {
                    ["id"] = 1639,
                    ["image"] = 1385763,
                    ["name"] = "Razorscale",
                }, -- [3]
                {
                    ["id"] = 1640,
                    ["image"] = 1385773,
                    ["name"] = "XT-002 Deconstructor",
                }, -- [4]
                {
                    ["id"] = 1641,
                    ["image"] = 1390439,
                    ["name"] = "The Assembly of Iron",
                }, -- [5]
                {
                    ["id"] = 1642,
                    ["image"] = 1385747,
                    ["name"] = "Kologarn",
                }, -- [6]
                {
                    ["id"] = 1643,
                    ["image"] = 1385717,
                    ["name"] = "Auriaya",
                }, -- [7]
                {
                    ["id"] = 1644,
                    ["image"] = 1385740,
                    ["name"] = "Hodir",
                }, -- [8]
                {
                    ["id"] = 1645,
                    ["image"] = 1385770,
                    ["name"] = "Thorim",
                }, -- [9]
                {
                    ["id"] = 1646,
                    ["image"] = 1385733,
                    ["name"] = "Freya",
                }, -- [10]
                {
                    ["id"] = 1647,
                    ["image"] = 1385754,
                    ["name"] = "Mimiron",
                }, -- [11]
                {
                    ["id"] = 1648,
                    ["image"] = 1385735,
                    ["name"] = "General Vezax",
                }, -- [12]
                {
                    ["id"] = 1649,
                    ["image"] = 1385774,
                    ["name"] = "Yogg-Saron",
                }, -- [13]
                {
                    ["id"] = 1650,
                    ["image"] = 1385713,
                    ["name"] = "Algalon the Observer",
                }, -- [14]
            },
        }, -- [5]
        {
            ["id"] = 757,
            ["image"] = 1396594,
            ["name"] = "Trial of the Crusader",
            ["bosses"] = {
                {
                    ["id"] = 1618,
                    ["image"] = 1390440,
                    ["name"] = "The Northrend Beasts",
                }, -- [1]
                {
                    ["id"] = 1619,
                    ["image"] = 1385752,
                    ["name"] = "Lord Jaraxxus",
                }, -- [2]
                {
                    ["id"] = Cell.vars.playerFaction == "Horde" and 1620 or 1621,
                    ["image"] = Cell.vars.playerFaction == "Horde" and 1390442 or 1390441,
                    ["name"] = Cell.vars.playerFaction == "Horde" and "Champions of the Alliance" or "Champions of the Horde",
                }, -- [3]
                {
                    ["id"] = 1622,
                    ["image"] = 1390443,
                    ["name"] = "Twin Val'kyr",
                }, -- [4]
                {
                    ["id"] = 1623,
                    ["image"] = 607542,
                    ["name"] = "Anub'arak",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 760,
            ["image"] = 1396589,
            ["name"] = "Onyxia's Lair",
            ["bosses"] = {
                {
                    ["id"] = 1651,
                    ["image"] = 1379025,
                    ["name"] = "Onyxia",
                }, -- [1]
            },
        }, -- [7]
        {
            ["id"] = 758,
            ["image"] = 1396583,
            ["name"] = "Icecrown Citadel",
            ["bosses"] = {
                {
                    ["id"] = 1624,
                    ["image"] = 1378992,
                    ["name"] = "Lord Marrowgar",
                }, -- [1]
                {
                    ["id"] = 1625,
                    ["image"] = 1378990,
                    ["name"] = "Lady Deathwhisper",
                }, -- [2]
                {
                    ["id"] = 1627,
                    ["image"] = 1385736,
                    ["name"] = "Icecrown Gunship Battle",
                }, -- [3]
                {
                    ["id"] = 1628,
                    ["image"] = 1378970,
                    ["name"] = "Deathbringer Saurfang",
                }, -- [4]
                {
                    ["id"] = 1629,
                    ["image"] = 1378972,
                    ["name"] = "Festergut",
                }, -- [5]
                {
                    ["id"] = 1630,
                    ["image"] = 1379009,
                    ["name"] = "Rotface",
                }, -- [6]
                {
                    ["id"] = 1631,
                    ["image"] = 1379007,
                    ["name"] = "Professor Putricide",
                }, -- [7]
                {
                    ["id"] = 1632,
                    ["image"] = 1385721,
                    ["name"] = "Blood Prince Council",
                }, -- [8]
                {
                    ["id"] = 1633,
                    ["image"] = 1378967,
                    ["name"] = "Blood-Queen Lana'thel",
                }, -- [9]
                {
                    ["id"] = 1634,
                    ["image"] = 1379023,
                    ["name"] = "Valithria Dreamwalker",
                }, -- [10]
                {
                    ["id"] = 1635,
                    ["image"] = 1379014,
                    ["name"] = "Sindragosa",
                }, -- [11]
                {
                    ["id"] = 1636,
                    ["image"] = 607688,
                    ["name"] = "The Lich King",
                }, -- [12]
            },
        }, -- [8]
        {
            ["id"] = 761,
            ["image"] = 1396590,
            ["name"] = "The Ruby Sanctum",
            ["bosses"] = {
                {
                    ["id"] = 1652,
                    ["image"] = 1385738,
                    ["name"] = "Halion",
                }, -- [1]
            },
        }, -- [9]
        {
            ["id"] = 271,
            ["image"] = 608192,
            ["name"] = "Ahn'kahet: The Old Kingdom",
            ["bosses"] = {
                {
                    ["id"] = 580,
                    ["image"] = 607593,
                    ["name"] = "Elder Nadox",
                }, -- [1]
                {
                    ["id"] = 581,
                    ["image"] = 607744,
                    ["name"] = "Prince Taldaram",
                }, -- [2]
                {
                    ["id"] = 582,
                    ["image"] = 607667,
                    ["name"] = "Jedoga Shadowseeker",
                }, -- [3]
                {
                    ["id"] = 583,
                    ["image"] = 607534,
                    ["name"] = "Amanitar",
                }, -- [4]
                {
                    ["id"] = 584,
                    ["image"] = 607639,
                    ["name"] = "Herald Volazj",
                }, -- [5]
            },
        }, -- [10]
        {
            ["id"] = 272,
            ["image"] = 608194,
            ["name"] = "Azjol-Nerub",
            ["bosses"] = {
                {
                    ["id"] = 585,
                    ["image"] = 607678,
                    ["name"] = "Krik'thir the Gatewatcher",
                }, -- [1]
                {
                    ["id"] = 586,
                    ["image"] = 607633,
                    ["name"] = "Hadronox",
                }, -- [2]
                {
                    ["id"] = 587,
                    ["image"] = 607542,
                    ["name"] = "Anub'arak",
                }, -- [3]
            },
        }, -- [11]
        {
            ["id"] = 273,
            ["image"] = 608201,
            ["name"] = "Drak'Tharon Keep",
            ["bosses"] = {
                {
                    ["id"] = 588,
                    ["image"] = 607798,
                    ["name"] = "Trollgore",
                }, -- [1]
                {
                    ["id"] = 589,
                    ["image"] = 607727,
                    ["name"] = "Novos the Summoner",
                }, -- [2]
                {
                    ["id"] = 590,
                    ["image"] = 607672,
                    ["name"] = "King Dred",
                }, -- [3]
                {
                    ["id"] = 591,
                    ["image"] = 607790,
                    ["name"] = "The Prophet Tharon'ja",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 274,
            ["image"] = 608203,
            ["name"] = "Gundrak",
            ["bosses"] = {
                {
                    ["id"] = 592,
                    ["image"] = 607776,
                    ["name"] = "Slad'ran",
                }, -- [1]
                {
                    ["id"] = 593,
                    ["image"] = 607589,
                    ["name"] = "Drakkari Colossus",
                }, -- [2]
                {
                    ["id"] = 594,
                    ["image"] = 607716,
                    ["name"] = "Moorabi",
                }, -- [3]
                {
                    ["id"] = 595,
                    ["image"] = 607592,
                    ["name"] = "Eck the Ferocious",
                }, -- [4]
                {
                    ["id"] = 596,
                    ["image"] = 607605,
                    ["name"] = "Gal'darah",
                }, -- [5]
            },
        }, -- [13]
        {
            ["id"] = 275,
            ["image"] = 608204,
            ["name"] = "Halls of Lightning",
            ["bosses"] = {
                {
                    ["id"] = 597,
                    ["image"] = 607611,
                    ["name"] = "General Bjarngrim",
                }, -- [1]
                {
                    ["id"] = 598,
                    ["image"] = 607809,
                    ["name"] = "Volkhan",
                }, -- [2]
                {
                    ["id"] = 599,
                    ["image"] = 607663,
                    ["name"] = "Ionar",
                }, -- [3]
                {
                    ["id"] = 600,
                    ["image"] = 607690,
                    ["name"] = "Loken",
                }, -- [4]
            },
        }, -- [14]
        {
            ["id"] = 276,
            ["image"] = 608205,
            ["name"] = "Halls of Reflection",
            ["bosses"] = {
                {
                    ["id"] = 601,
                    ["image"] = 607601,
                    ["name"] = "Falric",
                }, -- [1]
                {
                    ["id"] = 602,
                    ["image"] = 607710,
                    ["name"] = "Marwyn",
                }, -- [2]
                {
                    ["id"] = 603,
                    ["image"] = 607688,
                    ["name"] = "Escape from Arthas",
                }, -- [3]
            },
        }, -- [15]
        {
            ["id"] = 277,
            ["image"] = 608206,
            ["name"] = "Halls of Stone",
            ["bosses"] = {
                {
                    ["id"] = 604,
                    ["image"] = 607679,
                    ["name"] = "Krystallus",
                }, -- [1]
                {
                    ["id"] = 605,
                    ["image"] = 607706,
                    ["name"] = "Maiden of Grief",
                }, -- [2]
                {
                    ["id"] = 606,
                    ["image"] = 607797,
                    ["name"] = "Tribunal of Ages",
                }, -- [3]
                {
                    ["id"] = 607,
                    ["image"] = 607772,
                    ["name"] = "Sjonnir the Ironshaper",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 278,
            ["image"] = 608210,
            ["name"] = "Pit of Saron",
            ["bosses"] = {
                {
                    ["id"] = 608,
                    ["image"] = 607603,
                    ["name"] = "Forgemaster Garfrost",
                }, -- [1]
                {
                    ["id"] = 609,
                    ["image"] = 607677,
                    ["name"] = "Ick & Krick",
                }, -- [2]
                {
                    ["id"] = 610,
                    ["image"] = 607765,
                    ["name"] = "Scourgelord Tyrannus",
                }, -- [3]
            },
        }, -- [17]
        {
            ["id"] = 279,
            ["image"] = 608219,
            ["name"] = "The Culling of Stratholme",
            ["bosses"] = {
                {
                    ["id"] = 611,
                    ["image"] = 607711,
                    ["name"] = "Meathook",
                }, -- [1]
                {
                    ["id"] = 612,
                    ["image"] = 607763,
                    ["name"] = "Salramm the Fleshcrafter",
                }, -- [2]
                {
                    ["id"] = 613,
                    ["image"] = 607567,
                    ["name"] = "Chrono-Lord Epoch",
                }, -- [3]
                {
                    ["id"] = 614,
                    ["image"] = 607708,
                    ["name"] = "Mal'Ganis",
                }, -- [4]
            },
        }, -- [18]
        {
            ["id"] = 280,
            ["image"] = 608220,
            ["name"] = "The Forge of Souls",
            ["bosses"] = {
                {
                    ["id"] = 615,
                    ["image"] = 607559,
                    ["name"] = "Bronjahm",
                }, -- [1]
                {
                    ["id"] = 616,
                    ["image"] = 607585,
                    ["name"] = "Devourer of Souls",
                }, -- [2]
            },
        }, -- [19]
        {
            ["id"] = 281,
            ["image"] = 608221,
            ["name"] = "The Nexus",
            ["bosses"] = {
                {
                    ["id"] = Cell.vars.playerFaction == "Horde" and 617 or 833,
                    ["image"] = Cell.vars.playerFaction == "Horde" and 607571 or 607568,
                    ["name"] = Cell.vars.playerFaction == "Horde" and "Commander Stoutbeard" or "Commander Kolurg",
                }, -- [1]
                {
                    ["id"] = 618,
                    ["image"] = 607623,
                    ["name"] = "Grand Magus Telestra",
                }, -- [2]
                {
                    ["id"] = 619,
                    ["image"] = 607540,
                    ["name"] = "Anomalus",
                }, -- [3]
                {
                    ["id"] = 620,
                    ["image"] = 607735,
                    ["name"] = "Ormorok the Tree-Shaper",
                }, -- [4]
                {
                    ["id"] = 621,
                    ["image"] = 607671,
                    ["name"] = "Keristrasza",
                }, -- [5]
            },
        }, -- [20]
        {
            ["id"] = 282,
            ["image"] = 608222,
            ["name"] = "The Oculus",
            ["bosses"] = {
                {
                    ["id"] = 622,
                    ["image"] = 607590,
                    ["name"] = "Drakos the Interrogator",
                }, -- [1]
                {
                    ["id"] = 623,
                    ["image"] = 607802,
                    ["name"] = "Varos Cloudstrider",
                }, -- [2]
                {
                    ["id"] = 624,
                    ["image"] = 607702,
                    ["name"] = "Mage-Lord Urom",
                }, -- [3]
                {
                    ["id"] = 625,
                    ["image"] = 607687,
                    ["name"] = "Ley-Guardian Eregos",
                }, -- [4]
            },
        }, -- [21]
        {
            ["id"] = 283,
            ["image"] = 608228,
            ["name"] = "The Violet Hold",
            ["bosses"] = {
                {
                    ["id"] = 626,
                    ["image"] = 607597,
                    ["name"] = "Erekem",
                }, -- [1]
                {
                    ["id"] = 627,
                    ["image"] = 607717,
                    ["name"] = "Moragg",
                }, -- [2]
                {
                    ["id"] = 628,
                    ["image"] = 607654,
                    ["name"] = "Ichoron",
                }, -- [3]
                {
                    ["id"] = 629,
                    ["image"] = 607821,
                    ["name"] = "Xevozz",
                }, -- [4]
                {
                    ["id"] = 630,
                    ["image"] = 607685,
                    ["name"] = "Lavanthor",
                }, -- [5]
                {
                    ["id"] = 631,
                    ["image"] = 607825,
                    ["name"] = "Zuramat the Obliterator",
                }, -- [6]
                {
                    ["id"] = 632,
                    ["image"] = 607573,
                    ["name"] = "Cyanigosa",
                }, -- [7]
            },
        }, -- [22]
        {
            ["id"] = 284,
            ["image"] = 608224,
            ["name"] = "Trial of the Champion",
            ["bosses"] = {
                {
                    ["id"] = 834,
                    ["image"] = 607621,
                    ["name"] = "Grand Champions",
                }, -- [1]
                {
                    ["id"] = 635,
                    ["image"] = 607591,
                    ["name"] = "Eadric the Pure",
                }, -- [2]
                {
                    ["id"] = 636,
                    ["image"] = 607547,
                    ["name"] = "Argent Confessor Paletress",
                }, -- [3]
                {
                    ["id"] = 637,
                    ["image"] = 607787,
                    ["name"] = "The Black Knight",
                }, -- [4]
            },
        }, -- [23]
        {
            ["id"] = 285,
            ["image"] = 608226,
            ["name"] = "Utgarde Keep",
            ["bosses"] = {
                {
                    ["id"] = 638,
                    ["image"] = 607743,
                    ["name"] = "Prince Keleseth",
                }, -- [1]
                {
                    ["id"] = 639,
                    ["image"] = 607774,
                    ["name"] = "Skarvald & Dalronn",
                }, -- [2]
                {
                    ["id"] = 640,
                    ["image"] = 607659,
                    ["name"] = "Ingvar the Plunderer",
                }, -- [3]
            },
        }, -- [24]
        {
            ["id"] = 286,
            ["image"] = 608227,
            ["name"] = "Utgarde Pinnacle",
            ["bosses"] = {
                {
                    ["id"] = 641,
                    ["image"] = 607778,
                    ["name"] = "Svala Sorrowgrave",
                }, -- [1]
                {
                    ["id"] = 642,
                    ["image"] = 607620,
                    ["name"] = "Gortok Palehoof",
                }, -- [2]
                {
                    ["id"] = 643,
                    ["image"] = 607773,
                    ["name"] = "Skadi the Ruthless",
                }, -- [3]
                {
                    ["id"] = 644,
                    ["image"] = 607674,
                    ["name"] = "King Ymiron",
                }, -- [4]
            },
        }, -- [25]
    },
}

data.zhCN = {
    ["德拉诺之王"] = {
        {
            ["id"] = 557,
            ["image"] = 1041995,
            ["name"] = "德拉诺",
            ["bosses"] = {
                {
                    ["id"] = 1291,
                    ["image"] = 1044483,
                    ["name"] = "毁灭者多弗",
                }, -- [1]
                {
                    ["id"] = 1211,
                    ["image"] = 1044371,
                    ["name"] = "永恒的塔尔纳",
                }, -- [2]
                {
                    ["id"] = 1262,
                    ["image"] = 1044364,
                    ["name"] = "鲁克玛",
                }, -- [3]
                {
                    ["id"] = 1452,
                    ["image"] = 1134508,
                    ["name"] = "霸主卡扎克",
                }, -- [4]
            },
        }, -- [1]
        {
            ["id"] = 477,
            ["image"] = 1041997,
            ["name"] = "悬槌堡",
            ["bosses"] = {
                {
                    ["id"] = 1128,
                    ["image"] = 1044352,
                    ["name"] = "卡加斯·刃拳",
                }, -- [1]
                {
                    ["id"] = 971,
                    ["image"] = 1044375,
                    ["name"] = "屠夫",
                }, -- [2]
                {
                    ["id"] = 1195,
                    ["image"] = 1044372,
                    ["name"] = "泰克图斯",
                }, -- [3]
                {
                    ["id"] = 1196,
                    ["image"] = 1044342,
                    ["name"] = "布兰肯斯波",
                }, -- [4]
                {
                    ["id"] = 1148,
                    ["image"] = 1044377,
                    ["name"] = "独眼魔双子",
                }, -- [5]
                {
                    ["id"] = 1153,
                    ["image"] = 1044343,
                    ["name"] = "克拉戈",
                }, -- [6]
                {
                    ["id"] = 1197,
                    ["image"] = 1044349,
                    ["name"] = "元首马尔高克",
                }, -- [7]
            },
        }, -- [2]
        {
            ["id"] = 457,
            ["image"] = 1041993,
            ["name"] = "黑石铸造厂",
            ["bosses"] = {
                {
                    ["id"] = 1202,
                    ["image"] = 1044484,
                    ["name"] = "奥尔高格",
                }, -- [1]
                {
                    ["id"] = 1155,
                    ["image"] = 1044345,
                    ["name"] = "汉斯加尔与弗兰佐克",
                }, -- [2]
                {
                    ["id"] = 1122,
                    ["image"] = 1044338,
                    ["name"] = "兽王达玛克",
                }, -- [3]
                {
                    ["id"] = 1161,
                    ["image"] = 1044346,
                    ["name"] = "格鲁尔",
                }, -- [4]
                {
                    ["id"] = 1123,
                    ["image"] = 1044344,
                    ["name"] = "缚火者卡格拉兹",
                }, -- [5]
                {
                    ["id"] = 1147,
                    ["image"] = 1044357,
                    ["name"] = "主管索戈尔",
                }, -- [6]
                {
                    ["id"] = 1154,
                    ["image"] = 1044374,
                    ["name"] = "爆裂熔炉",
                }, -- [7]
                {
                    ["id"] = 1162,
                    ["image"] = 1044353,
                    ["name"] = "克罗莫格",
                }, -- [8]
                {
                    ["id"] = 1203,
                    ["image"] = 1044350,
                    ["name"] = "钢铁女武神",
                }, -- [9]
                {
                    ["id"] = 959,
                    ["image"] = 1044378,
                    ["name"] = "黑手",
                }, -- [10]
            },
        }, -- [3]
        {
            ["id"] = 669,
            ["image"] = 1135118,
            ["name"] = "地狱火堡垒",
            ["bosses"] = {
                {
                    ["id"] = 1426,
                    ["image"] = 1134502,
                    ["name"] = "奇袭地狱火",
                }, -- [1]
                {
                    ["id"] = 1425,
                    ["image"] = 1134499,
                    ["name"] = "钢铁掠夺者",
                }, -- [2]
                {
                    ["id"] = 1392,
                    ["image"] = 1134504,
                    ["name"] = "考莫克",
                }, -- [3]
                {
                    ["id"] = 1432,
                    ["image"] = 1134501,
                    ["name"] = "高阶地狱火议会",
                }, -- [4]
                {
                    ["id"] = 1396,
                    ["image"] = 1134503,
                    ["name"] = "基尔罗格·死眼",
                }, -- [5]
                {
                    ["id"] = 1372,
                    ["image"] = 1134500,
                    ["name"] = "血魔",
                }, -- [6]
                {
                    ["id"] = 1433,
                    ["image"] = 1134506,
                    ["name"] = "暗影领主艾斯卡",
                }, -- [7]
                {
                    ["id"] = 1427,
                    ["image"] = 1134507,
                    ["name"] = "永恒者索克雷萨",
                }, -- [8]
                {
                    ["id"] = 1391,
                    ["image"] = 1134498,
                    ["name"] = "邪能领主扎昆",
                }, -- [9]
                {
                    ["id"] = 1447,
                    ["image"] = 1134510,
                    ["name"] = "祖霍拉克",
                }, -- [10]
                {
                    ["id"] = 1394,
                    ["image"] = 1134509,
                    ["name"] = "暴君维哈里",
                }, -- [11]
                {
                    ["id"] = 1395,
                    ["image"] = 1134505,
                    ["name"] = "玛诺洛斯",
                }, -- [12]
                {
                    ["id"] = 1438,
                    ["image"] = 1134497,
                    ["name"] = "阿克蒙德",
                }, -- [13]
            },
        }, -- [4]
        {
            ["id"] = 547,
            ["image"] = 1041992,
            ["name"] = "奥金顿",
            ["bosses"] = {
                {
                    ["id"] = 1185,
                    ["image"] = 1044336,
                    ["name"] = "警戒者凯萨尔",
                }, -- [1]
                {
                    ["id"] = 1186,
                    ["image"] = 1044370,
                    ["name"] = "缚魂者尼娅米",
                }, -- [2]
                {
                    ["id"] = 1216,
                    ["image"] = 1044337,
                    ["name"] = "阿扎凯尔",
                }, -- [3]
                {
                    ["id"] = 1225,
                    ["image"] = 1044373,
                    ["name"] = "塔隆戈尔",
                }, -- [4]
            },
        }, -- [5]
        {
            ["id"] = 537,
            ["image"] = 1041998,
            ["name"] = "影月墓地",
            ["bosses"] = {
                {
                    ["id"] = 1139,
                    ["image"] = 1044366,
                    ["name"] = "莎达娜·血怒",
                }, -- [1]
                {
                    ["id"] = 1168,
                    ["image"] = 1053564,
                    ["name"] = "纳利什",
                }, -- [2]
                {
                    ["id"] = 1140,
                    ["image"] = 1044341,
                    ["name"] = "骨喉",
                }, -- [3]
                {
                    ["id"] = 1160,
                    ["image"] = 1044356,
                    ["name"] = "耐奥祖",
                }, -- [4]
            },
        }, -- [6]
        {
            ["id"] = 536,
            ["image"] = 1041996,
            ["name"] = "恐轨车站",
            ["bosses"] = {
                {
                    ["id"] = 1138,
                    ["image"] = 1044360,
                    ["name"] = "箭火和波尔卡",
                }, -- [1]
                {
                    ["id"] = 1163,
                    ["image"] = 1044339,
                    ["name"] = "尼托格·雷塔",
                }, -- [2]
                {
                    ["id"] = 1133,
                    ["image"] = 1044376,
                    ["name"] = "啸天者托瓦拉",
                }, -- [3]
            },
        }, -- [7]
        {
            ["id"] = 556,
            ["image"] = 1060547,
            ["name"] = "永茂林地",
            ["bosses"] = {
                {
                    ["id"] = 1214,
                    ["image"] = 1044381,
                    ["name"] = "枯木",
                }, -- [1]
                {
                    ["id"] = 1207,
                    ["image"] = 1053563,
                    ["name"] = "远古的保卫者",
                }, -- [2]
                {
                    ["id"] = 1208,
                    ["image"] = 1044335,
                    ["name"] = "大法师索尔",
                }, -- [3]
                {
                    ["id"] = 1209,
                    ["image"] = 1044382,
                    ["name"] = "艾里塔克",
                }, -- [4]
                {
                    ["id"] = 1210,
                    ["image"] = 1044383,
                    ["name"] = "雅努",
                }, -- [5]
            },
        }, -- [8]
        {
            ["id"] = 385,
            ["image"] = 1041994,
            ["name"] = "血槌炉渣矿井",
            ["bosses"] = {
                {
                    ["id"] = 893,
                    ["image"] = 1044355,
                    ["name"] = "玛格莫拉图斯",
                }, -- [1]
                {
                    ["id"] = 888,
                    ["image"] = 1044368,
                    ["name"] = "守奴人库鲁斯托",
                }, -- [2]
                {
                    ["id"] = 887,
                    ["image"] = 1044363,
                    ["name"] = "罗托尔",
                }, -- [3]
                {
                    ["id"] = 889,
                    ["image"] = 1044347,
                    ["name"] = "戈洛克",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 476,
            ["image"] = 1041999,
            ["name"] = "通天峰",
            ["bosses"] = {
                {
                    ["id"] = 965,
                    ["image"] = 1044362,
                    ["name"] = "兰吉特",
                }, -- [1]
                {
                    ["id"] = 966,
                    ["image"] = 1044334,
                    ["name"] = "阿拉卡纳斯",
                }, -- [2]
                {
                    ["id"] = 967,
                    ["image"] = 1044365,
                    ["name"] = "鲁克兰",
                }, -- [3]
                {
                    ["id"] = 968,
                    ["image"] = 1044348,
                    ["name"] = "高阶贤者维里克斯",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 558,
            ["image"] = 1060548,
            ["name"] = "钢铁码头",
            ["bosses"] = {
                {
                    ["id"] = 1235,
                    ["image"] = 1044380,
                    ["name"] = "血肉撕裂者诺格加尔",
                }, -- [1]
                {
                    ["id"] = 1236,
                    ["image"] = 1044340,
                    ["name"] = "恐轨押运员",
                }, -- [2]
                {
                    ["id"] = 1237,
                    ["image"] = 1044359,
                    ["name"] = "奥舍尔",
                }, -- [3]
                {
                    ["id"] = 1238,
                    ["image"] = 1044367,
                    ["name"] = "斯古洛克",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 559,
            ["image"] = 1042000,
            ["name"] = "黑石塔上层",
            ["bosses"] = {
                {
                    ["id"] = 1226,
                    ["image"] = 1044358,
                    ["name"] = "折铁者高尔山",
                }, -- [1]
                {
                    ["id"] = 1227,
                    ["image"] = 1044354,
                    ["name"] = "奇拉克",
                }, -- [2]
                {
                    ["id"] = 1228,
                    ["image"] = 1044351,
                    ["name"] = "指挥官萨贝克",
                }, -- [3]
                {
                    ["id"] = 1229,
                    ["image"] = 1044361,
                    ["name"] = "狂野的怒翼",
                }, -- [4]
                {
                    ["id"] = 1234,
                    ["image"] = 1044379,
                    ["name"] = "督军扎伊拉",
                }, -- [5]
            },
        }, -- [12]
    },
    ["巫妖王之怒"] = {
        {
            ["id"] = 753,
            ["image"] = 1396596,
            ["name"] = "阿尔卡冯的宝库",
            ["bosses"] = {
                {
                    ["id"] = 1597,
                    ["image"] = 1385715,
                    ["name"] = "岩石看守者阿尔卡冯",
                }, -- [1]
                {
                    ["id"] = 1598,
                    ["image"] = 1385727,
                    ["name"] = "风暴看守者埃玛尔隆",
                }, -- [2]
                {
                    ["id"] = 1599,
                    ["image"] = 1385748,
                    ["name"] = "火焰看守者科拉隆",
                }, -- [3]
                {
                    ["id"] = 1600,
                    ["image"] = 1385767,
                    ["name"] = "寒冰看守者图拉旺",
                }, -- [4]
            },
        }, -- [1]
        {
            ["id"] = 754,
            ["image"] = 1396587,
            ["name"] = "纳克萨玛斯",
            ["bosses"] = {
                {
                    ["id"] = 1601,
                    ["image"] = 1378964,
                    ["name"] = "阿努布雷坎",
                }, -- [1]
                {
                    ["id"] = 1602,
                    ["image"] = 1378980,
                    ["name"] = "黑女巫法琳娜",
                }, -- [2]
                {
                    ["id"] = 1603,
                    ["image"] = 1378994,
                    ["name"] = "迈克斯纳",
                }, -- [3]
                {
                    ["id"] = 1604,
                    ["image"] = 1379004,
                    ["name"] = "药剂师诺斯",
                }, -- [4]
                {
                    ["id"] = 1605,
                    ["image"] = 1378984,
                    ["name"] = "肮脏的希尔盖",
                }, -- [5]
                {
                    ["id"] = 1606,
                    ["image"] = 1378991,
                    ["name"] = "洛欧塞布",
                }, -- [6]
                {
                    ["id"] = 1607,
                    ["image"] = 1378988,
                    ["name"] = "教官拉苏维奥斯",
                }, -- [7]
                {
                    ["id"] = 1608,
                    ["image"] = 1378979,
                    ["name"] = "收割者戈提克",
                }, -- [8]
                {
                    ["id"] = 1609,
                    ["image"] = 1385732,
                    ["name"] = "天启四骑士",
                }, -- [9]
                {
                    ["id"] = 1610,
                    ["image"] = 1379005,
                    ["name"] = "帕奇维克",
                }, -- [10]
                {
                    ["id"] = 1611,
                    ["image"] = 1378981,
                    ["name"] = "格罗布鲁斯",
                }, -- [11]
                {
                    ["id"] = 1612,
                    ["image"] = 1378977,
                    ["name"] = "格拉斯",
                }, -- [12]
                {
                    ["id"] = 1613,
                    ["image"] = 1379019,
                    ["name"] = "塔迪乌斯",
                }, -- [13]
                {
                    ["id"] = 1614,
                    ["image"] = 1379010,
                    ["name"] = "萨菲隆",
                }, -- [14]
                {
                    ["id"] = 1615,
                    ["image"] = 1378989,
                    ["name"] = "克尔苏加德",
                }, -- [15]
            },
        }, -- [2]
        {
            ["id"] = 755,
            ["image"] = 1396588,
            ["name"] = "黑曜石圣殿",
            ["bosses"] = {
                {
                    ["id"] = 1616,
                    ["image"] = 1385765,
                    ["name"] = "萨塔里奥",
                }, -- [1]
            },
        }, -- [3]
        {
            ["id"] = 756,
            ["image"] = 1396581,
            ["name"] = "永恒之眼",
            ["bosses"] = {
                {
                    ["id"] = 1617,
                    ["image"] = 1385753,
                    ["name"] = "玛里苟斯",
                }, -- [1]
            },
        }, -- [4]
        {
            ["id"] = 759,
            ["image"] = 1396595,
            ["name"] = "奥杜尔",
            ["bosses"] = {
                {
                    ["id"] = 1637,
                    ["image"] = 1385731,
                    ["name"] = "烈焰巨兽",
                }, -- [1]
                {
                    ["id"] = 1638,
                    ["image"] = 1385742,
                    ["name"] = "掌炉者伊格尼斯",
                }, -- [2]
                {
                    ["id"] = 1639,
                    ["image"] = 1385763,
                    ["name"] = "锋鳞",
                }, -- [3]
                {
                    ["id"] = 1640,
                    ["image"] = 1385773,
                    ["name"] = "XT-002拆解者",
                }, -- [4]
                {
                    ["id"] = 1641,
                    ["image"] = 1390439,
                    ["name"] = "钢铁议会",
                }, -- [5]
                {
                    ["id"] = 1642,
                    ["image"] = 1385747,
                    ["name"] = "科隆加恩",
                }, -- [6]
                {
                    ["id"] = 1643,
                    ["image"] = 1385717,
                    ["name"] = "欧尔莉亚",
                }, -- [7]
                {
                    ["id"] = 1644,
                    ["image"] = 1385740,
                    ["name"] = "霍迪尔",
                }, -- [8]
                {
                    ["id"] = 1645,
                    ["image"] = 1385770,
                    ["name"] = "托里姆",
                }, -- [9]
                {
                    ["id"] = 1646,
                    ["image"] = 1385733,
                    ["name"] = "弗蕾亚",
                }, -- [10]
                {
                    ["id"] = 1647,
                    ["image"] = 1385754,
                    ["name"] = "米米尔隆",
                }, -- [11]
                {
                    ["id"] = 1648,
                    ["image"] = 1385735,
                    ["name"] = "维扎克斯将军",
                }, -- [12]
                {
                    ["id"] = 1649,
                    ["image"] = 1385774,
                    ["name"] = "尤格-萨隆",
                }, -- [13]
                {
                    ["id"] = 1650,
                    ["image"] = 1385713,
                    ["name"] = "观察者奥尔加隆",
                }, -- [14]
            },
        }, -- [5]
        {
            ["id"] = 757,
            ["image"] = 1396594,
            ["name"] = "十字军的试炼",
            ["bosses"] = {
                {
                    ["id"] = 1618,
                    ["image"] = 1390440,
                    ["name"] = "诺森德猛兽",
                }, -- [1]
                {
                    ["id"] = 1619,
                    ["image"] = 1385752,
                    ["name"] = "加拉克苏斯大王",
                }, -- [2]
                {
                    ["id"] = Cell.vars.playerFaction == "Horde" and 1620 or 1621,
                    ["image"] = Cell.vars.playerFaction == "Horde" and 1390442 or 1390441,
                    ["name"] = Cell.vars.playerFaction == "Horde" and "联盟的冠军" or "部落的冠军",
                }, -- [3]
                {
                    ["id"] = 1622,
                    ["image"] = 1390443,
                    ["name"] = "瓦格里双子",
                }, -- [4]
                {
                    ["id"] = 1623,
                    ["image"] = 607542,
                    ["name"] = "阿努巴拉克",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 760,
            ["image"] = 1396589,
            ["name"] = "奥妮克希亚的巢穴",
            ["bosses"] = {
                {
                    ["id"] = 1651,
                    ["image"] = 1379025,
                    ["name"] = "奥妮克希亚",
                }, -- [1]
            },
        }, -- [7]
        {
            ["id"] = 758,
            ["image"] = 1396583,
            ["name"] = "冰冠堡垒",
            ["bosses"] = {
                {
                    ["id"] = 1624,
                    ["image"] = 1378992,
                    ["name"] = "玛洛加尔领主",
                }, -- [1]
                {
                    ["id"] = 1625,
                    ["image"] = 1378990,
                    ["name"] = "亡语者女士",
                }, -- [2]
                {
                    ["id"] = 1627,
                    ["image"] = 1385736,
                    ["name"] = "冰冠冰川炮舰战",
                }, -- [3]
                {
                    ["id"] = 1628,
                    ["image"] = 1378970,
                    ["name"] = "死亡使者萨鲁法尔",
                }, -- [4]
                {
                    ["id"] = 1629,
                    ["image"] = 1378972,
                    ["name"] = "烂肠",
                }, -- [5]
                {
                    ["id"] = 1630,
                    ["image"] = 1379009,
                    ["name"] = "腐面",
                }, -- [6]
                {
                    ["id"] = 1631,
                    ["image"] = 1379007,
                    ["name"] = "普崔塞德教授",
                }, -- [7]
                {
                    ["id"] = 1632,
                    ["image"] = 1385721,
                    ["name"] = "鲜血王子议会",
                }, -- [8]
                {
                    ["id"] = 1633,
                    ["image"] = 1378967,
                    ["name"] = "鲜血女王兰娜瑟尔",
                }, -- [9]
                {
                    ["id"] = 1634,
                    ["image"] = 1379023,
                    ["name"] = "踏梦者瓦莉瑟瑞娅",
                }, -- [10]
                {
                    ["id"] = 1635,
                    ["image"] = 1379014,
                    ["name"] = "辛达苟萨",
                }, -- [11]
                {
                    ["id"] = 1636,
                    ["image"] = 607688,
                    ["name"] = "巫妖王",
                }, -- [12]
            },
        }, -- [8]
        {
            ["id"] = 761,
            ["image"] = 1396590,
            ["name"] = "红玉圣殿",
            ["bosses"] = {
                {
                    ["id"] = 1652,
                    ["image"] = 1385738,
                    ["name"] = "海里昂",
                }, -- [1]
            },
        }, -- [9]
        {
            ["id"] = 286,
            ["image"] = 608227,
            ["name"] = "乌特加德之巅",
            ["bosses"] = {
                {
                    ["id"] = 641,
                    ["image"] = 607778,
                    ["name"] = "席瓦拉·索格蕾",
                }, -- [1]
                {
                    ["id"] = 642,
                    ["image"] = 607620,
                    ["name"] = "戈托克·苍蹄",
                }, -- [2]
                {
                    ["id"] = 643,
                    ["image"] = 607773,
                    ["name"] = "残忍的斯卡迪",
                }, -- [3]
                {
                    ["id"] = 644,
                    ["image"] = 607674,
                    ["name"] = "伊米隆国王",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 285,
            ["image"] = 608226,
            ["name"] = "乌特加德城堡",
            ["bosses"] = {
                {
                    ["id"] = 638,
                    ["image"] = 607743,
                    ["name"] = "凯雷塞斯王子",
                }, -- [1]
                {
                    ["id"] = 639,
                    ["image"] = 607774,
                    ["name"] = "斯卡瓦尔德和达尔隆",
                }, -- [2]
                {
                    ["id"] = 640,
                    ["image"] = 607659,
                    ["name"] = "掠夺者因格瓦尔",
                }, -- [3]
            },
        }, -- [11]
        {
            ["id"] = 284,
            ["image"] = 608224,
            ["name"] = "冠军的试炼",
            ["bosses"] = {
                {
                    ["id"] = 834,
                    ["image"] = 607621,
                    ["name"] = "总冠军",
                }, -- [1]
                {
                    ["id"] = 635,
                    ["image"] = 607591,
                    ["name"] = "纯洁者耶德瑞克",
                }, -- [2]
                {
                    ["id"] = 636,
                    ["image"] = 607547,
                    ["name"] = "银色神官帕尔崔丝",
                }, -- [3]
                {
                    ["id"] = 637,
                    ["image"] = 607787,
                    ["name"] = "黑骑士",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 279,
            ["image"] = 608219,
            ["name"] = "净化斯坦索姆",
            ["bosses"] = {
                {
                    ["id"] = 611,
                    ["image"] = 607711,
                    ["name"] = "肉钩",
                }, -- [1]
                {
                    ["id"] = 612,
                    ["image"] = 607763,
                    ["name"] = "塑血者沙尔拉姆",
                }, -- [2]
                {
                    ["id"] = 613,
                    ["image"] = 607567,
                    ["name"] = "时光领主埃博克",
                }, -- [3]
                {
                    ["id"] = 614,
                    ["image"] = 607708,
                    ["name"] = "玛尔加尼斯",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 274,
            ["image"] = 608203,
            ["name"] = "古达克",
            ["bosses"] = {
                {
                    ["id"] = 592,
                    ["image"] = 607776,
                    ["name"] = "斯拉德兰",
                }, -- [1]
                {
                    ["id"] = 593,
                    ["image"] = 607589,
                    ["name"] = "达卡莱巨像",
                }, -- [2]
                {
                    ["id"] = 594,
                    ["image"] = 607716,
                    ["name"] = "莫拉比",
                }, -- [3]
                {
                    ["id"] = 595,
                    ["image"] = 607592,
                    ["name"] = "凶残的伊克",
                }, -- [4]
                {
                    ["id"] = 596,
                    ["image"] = 607605,
                    ["name"] = "迦尔达拉",
                }, -- [5]
            },
        }, -- [14]
        {
            ["id"] = 271,
            ["image"] = 608192,
            ["name"] = "安卡赫特：古代王国",
            ["bosses"] = {
                {
                    ["id"] = 580,
                    ["image"] = 607593,
                    ["name"] = "纳多克斯长老",
                }, -- [1]
                {
                    ["id"] = 581,
                    ["image"] = 607744,
                    ["name"] = "塔达拉姆王子",
                }, -- [2]
                {
                    ["id"] = 582,
                    ["image"] = 607667,
                    ["name"] = "耶戈达·觅影者",
                }, -- [3]
                {
                    ["id"] = 583,
                    ["image"] = 607534,
                    ["name"] = "埃曼尼塔",
                }, -- [4]
                {
                    ["id"] = 584,
                    ["image"] = 607639,
                    ["name"] = "传令官沃拉兹",
                }, -- [5]
            },
        }, -- [15]
        {
            ["id"] = 277,
            ["image"] = 608206,
            ["name"] = "岩石大厅",
            ["bosses"] = {
                {
                    ["id"] = 604,
                    ["image"] = 607679,
                    ["name"] = "克莱斯塔卢斯",
                }, -- [1]
                {
                    ["id"] = 605,
                    ["image"] = 607706,
                    ["name"] = "悲伤圣女",
                }, -- [2]
                {
                    ["id"] = 606,
                    ["image"] = 607797,
                    ["name"] = "远古法庭",
                }, -- [3]
                {
                    ["id"] = 607,
                    ["image"] = 607772,
                    ["name"] = "塑铁者斯约尼尔",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 276,
            ["image"] = 608205,
            ["name"] = "映像大厅",
            ["bosses"] = {
                {
                    ["id"] = 601,
                    ["image"] = 607601,
                    ["name"] = "法瑞克",
                }, -- [1]
                {
                    ["id"] = 602,
                    ["image"] = 607710,
                    ["name"] = "玛维恩",
                }, -- [2]
                {
                    ["id"] = 603,
                    ["image"] = 607688,
                    ["name"] = "逃离阿尔萨斯",
                }, -- [3]
            },
        }, -- [17]
        {
            ["id"] = 280,
            ["image"] = 608220,
            ["name"] = "灵魂洪炉",
            ["bosses"] = {
                {
                    ["id"] = 615,
                    ["image"] = 607559,
                    ["name"] = "布隆亚姆",
                }, -- [1]
                {
                    ["id"] = 616,
                    ["image"] = 607585,
                    ["name"] = "噬魂者",
                }, -- [2]
            },
        }, -- [18]
        {
            ["id"] = 283,
            ["image"] = 608228,
            ["name"] = "紫罗兰监狱",
            ["bosses"] = {
                {
                    ["id"] = 626,
                    ["image"] = 607597,
                    ["name"] = "埃雷克姆",
                }, -- [1]
                {
                    ["id"] = 627,
                    ["image"] = 607717,
                    ["name"] = "摩拉格",
                }, -- [2]
                {
                    ["id"] = 628,
                    ["image"] = 607654,
                    ["name"] = "艾库隆",
                }, -- [3]
                {
                    ["id"] = 629,
                    ["image"] = 607821,
                    ["name"] = "谢沃兹",
                }, -- [4]
                {
                    ["id"] = 630,
                    ["image"] = 607685,
                    ["name"] = "拉文索尔",
                }, -- [5]
                {
                    ["id"] = 631,
                    ["image"] = 607825,
                    ["name"] = "湮灭者祖拉玛特",
                }, -- [6]
                {
                    ["id"] = 632,
                    ["image"] = 607573,
                    ["name"] = "塞安妮苟萨",
                }, -- [7]
            },
        }, -- [19]
        {
            ["id"] = 272,
            ["image"] = 608194,
            ["name"] = "艾卓-尼鲁布",
            ["bosses"] = {
                {
                    ["id"] = 585,
                    ["image"] = 607678,
                    ["name"] = "看门者克里克希尔",
                }, -- [1]
                {
                    ["id"] = 586,
                    ["image"] = 607633,
                    ["name"] = "哈多诺克斯",
                }, -- [2]
                {
                    ["id"] = 587,
                    ["image"] = 607542,
                    ["name"] = "阿努巴拉克",
                }, -- [3]
            },
        }, -- [20]
        {
            ["id"] = 278,
            ["image"] = 608210,
            ["name"] = "萨隆矿坑",
            ["bosses"] = {
                {
                    ["id"] = 608,
                    ["image"] = 607603,
                    ["name"] = "熔炉之主加弗斯特",
                }, -- [1]
                {
                    ["id"] = 609,
                    ["image"] = 607677,
                    ["name"] = "伊克和科瑞克",
                }, -- [2]
                {
                    ["id"] = 610,
                    ["image"] = 607765,
                    ["name"] = "天灾领主泰兰努斯",
                }, -- [3]
            },
        }, -- [21]
        {
            ["id"] = 273,
            ["image"] = 608201,
            ["name"] = "达克萨隆要塞",
            ["bosses"] = {
                {
                    ["id"] = 588,
                    ["image"] = 607798,
                    ["name"] = "托尔戈",
                }, -- [1]
                {
                    ["id"] = 589,
                    ["image"] = 607727,
                    ["name"] = "召唤者诺沃斯",
                }, -- [2]
                {
                    ["id"] = 590,
                    ["image"] = 607672,
                    ["name"] = "暴龙之王爵德",
                }, -- [3]
                {
                    ["id"] = 591,
                    ["image"] = 607790,
                    ["name"] = "先知萨隆亚",
                }, -- [4]
            },
        }, -- [22]
        {
            ["id"] = 275,
            ["image"] = 608204,
            ["name"] = "闪电大厅",
            ["bosses"] = {
                {
                    ["id"] = 597,
                    ["image"] = 607611,
                    ["name"] = "比亚格里将军",
                }, -- [1]
                {
                    ["id"] = 598,
                    ["image"] = 607809,
                    ["name"] = "沃尔坎",
                }, -- [2]
                {
                    ["id"] = 599,
                    ["image"] = 607663,
                    ["name"] = "艾欧纳尔",
                }, -- [3]
                {
                    ["id"] = 600,
                    ["image"] = 607690,
                    ["name"] = "洛肯",
                }, -- [4]
            },
        }, -- [23]
        {
            ["id"] = 281,
            ["image"] = 608221,
            ["name"] = "魔枢",
            ["bosses"] = {
                {
                    ["id"] = Cell.vars.playerFaction == "Horde" and 617 or 833,
                    ["image"] = Cell.vars.playerFaction == "Horde" and 607571 or 607568,
                    ["name"] = Cell.vars.playerFaction == "Horde" and "指挥官斯托比德" or "指挥官库鲁尔格",
                }, -- [1]
                {
                    ["id"] = 618,
                    ["image"] = 607623,
                    ["name"] = "大魔导师泰蕾丝塔",
                }, -- [2]
                {
                    ["id"] = 619,
                    ["image"] = 607540,
                    ["name"] = "阿诺玛鲁斯",
                }, -- [3]
                {
                    ["id"] = 620,
                    ["image"] = 607735,
                    ["name"] = "塑树者奥莫洛克",
                }, -- [4]
                {
                    ["id"] = 621,
                    ["image"] = 607671,
                    ["name"] = "克莉斯塔萨",
                }, -- [5]
            },
        }, -- [24]
        {
            ["id"] = 282,
            ["image"] = 608222,
            ["name"] = "魔环",
            ["bosses"] = {
                {
                    ["id"] = 622,
                    ["image"] = 607590,
                    ["name"] = "审讯者达库斯",
                }, -- [1]
                {
                    ["id"] = 623,
                    ["image"] = 607802,
                    ["name"] = "瓦尔洛斯·云击",
                }, -- [2]
                {
                    ["id"] = 624,
                    ["image"] = 607702,
                    ["name"] = "法师领主伊洛姆",
                }, -- [3]
                {
                    ["id"] = 625,
                    ["image"] = 607687,
                    ["name"] = "魔网守护者埃雷苟斯",
                }, -- [4]
            },
        }, -- [25]
    },
    ["熊猫人之谜"] = {
        {
            ["id"] = 322,
            ["image"] = 652218,
            ["name"] = "潘达利亚",
            ["bosses"] = {
                {
                    ["id"] = 691,
                    ["image"] = 630847,
                    ["name"] = "怒之煞",
                }, -- [1]
                {
                    ["id"] = 725,
                    ["image"] = 630819,
                    ["name"] = "萨莱斯的兵团",
                }, -- [2]
                {
                    ["id"] = 814,
                    ["image"] = 796778,
                    ["name"] = "暴风领主纳拉克",
                }, -- [3]
                {
                    ["id"] = 826,
                    ["image"] = 796779,
                    ["name"] = "乌达斯塔",
                }, -- [4]
                {
                    ["id"] = 857,
                    ["image"] = 901155,
                    ["name"] = "朱鹤赤精",
                }, -- [5]
                {
                    ["id"] = 858,
                    ["image"] = 901173,
                    ["name"] = "青龙玉珑",
                }, -- [6]
                {
                    ["id"] = 859,
                    ["image"] = 901165,
                    ["name"] = "玄牛砮皂",
                }, -- [7]
                {
                    ["id"] = 860,
                    ["image"] = 901172,
                    ["name"] = "白虎雪怒",
                }, -- [8]
                {
                    ["id"] = 861,
                    ["image"] = 901167,
                    ["name"] = "野牛人火神斡耳朵斯",
                }, -- [9]
            },
        }, -- [1]
        {
            ["id"] = 317,
            ["image"] = 632273,
            ["name"] = "魔古山宝库",
            ["bosses"] = {
                {
                    ["id"] = 679,
                    ["image"] = 630820,
                    ["name"] = "石头守卫",
                }, -- [1]
                {
                    ["id"] = 689,
                    ["image"] = 630824,
                    ["name"] = "受诅者魔封",
                }, -- [2]
                {
                    ["id"] = 682,
                    ["image"] = 630826,
                    ["name"] = "缚灵者戈拉亚",
                }, -- [3]
                {
                    ["id"] = 687,
                    ["image"] = 630861,
                    ["name"] = "先王之魂",
                }, -- [4]
                {
                    ["id"] = 726,
                    ["image"] = 630823,
                    ["name"] = "伊拉贡",
                }, -- [5]
                {
                    ["id"] = 677,
                    ["image"] = 630836,
                    ["name"] = "皇帝的意志",
                }, -- [6]
            },
        }, -- [2]
        {
            ["id"] = 330,
            ["image"] = 632271,
            ["name"] = "恐惧之心",
            ["bosses"] = {
                {
                    ["id"] = 745,
                    ["image"] = 630834,
                    ["name"] = "皇家宰相佐尔洛克",
                }, -- [1]
                {
                    ["id"] = 744,
                    ["image"] = 630817,
                    ["name"] = "刀锋领主塔亚克",
                }, -- [2]
                {
                    ["id"] = 713,
                    ["image"] = 630827,
                    ["name"] = "加拉隆",
                }, -- [3]
                {
                    ["id"] = 741,
                    ["image"] = 630856,
                    ["name"] = "风领主梅尔加拉克",
                }, -- [4]
                {
                    ["id"] = 737,
                    ["image"] = 630815,
                    ["name"] = "琥珀塑形者昂舒克",
                }, -- [5]
                {
                    ["id"] = 743,
                    ["image"] = 630830,
                    ["name"] = "大女皇夏柯希尔",
                }, -- [6]
            },
        }, -- [3]
        {
            ["id"] = 320,
            ["image"] = 643264,
            ["name"] = "永春台",
            ["bosses"] = {
                {
                    ["id"] = 683,
                    ["image"] = 630844,
                    ["name"] = "无尽守护者",
                }, -- [1]
                {
                    ["id"] = 742,
                    ["image"] = 630854,
                    ["name"] = "烛龙",
                }, -- [2]
                {
                    ["id"] = 729,
                    ["image"] = 630837,
                    ["name"] = "雷施",
                }, -- [3]
                {
                    ["id"] = 709,
                    ["image"] = 630849,
                    ["name"] = "惧之煞",
                }, -- [4]
            },
        }, -- [4]
        {
            ["id"] = 362,
            ["image"] = 828453,
            ["name"] = "雷电王座",
            ["bosses"] = {
                {
                    ["id"] = 827,
                    ["image"] = 796776,
                    ["name"] = "击碎者金罗克",
                }, -- [1]
                {
                    ["id"] = 819,
                    ["image"] = 796774,
                    ["name"] = "赫利东",
                }, -- [2]
                {
                    ["id"] = 816,
                    ["image"] = 796770,
                    ["name"] = "长者议会",
                }, -- [3]
                {
                    ["id"] = 825,
                    ["image"] = 796781,
                    ["name"] = "托多斯",
                }, -- [4]
                {
                    ["id"] = 821,
                    ["image"] = 796786,
                    ["name"] = "墨格瑞拉",
                }, -- [5]
                {
                    ["id"] = 828,
                    ["image"] = 796785,
                    ["name"] = "季鹍",
                }, -- [6]
                {
                    ["id"] = 818,
                    ["image"] = 796772,
                    ["name"] = "遗忘者杜鲁姆",
                }, -- [7]
                {
                    ["id"] = 820,
                    ["image"] = 796780,
                    ["name"] = "普利莫修斯",
                }, -- [8]
                {
                    ["id"] = 824,
                    ["image"] = 796771,
                    ["name"] = "黑暗意志",
                }, -- [9]
                {
                    ["id"] = 817,
                    ["image"] = 796775,
                    ["name"] = "铁穹",
                }, -- [10]
                {
                    ["id"] = 829,
                    ["image"] = 796773,
                    ["name"] = "神女双天",
                }, -- [11]
                {
                    ["id"] = 832,
                    ["image"] = 796777,
                    ["name"] = "雷神",
                }, -- [12]
            },
        }, -- [5]
        {
            ["id"] = 369,
            ["image"] = 904981,
            ["name"] = "决战奥格瑞玛",
            ["bosses"] = {
                {
                    ["id"] = 852,
                    ["image"] = 901160,
                    ["name"] = "伊墨苏斯",
                }, -- [1]
                {
                    ["id"] = 849,
                    ["image"] = 901159,
                    ["name"] = "堕落的守护者",
                }, -- [2]
                {
                    ["id"] = 866,
                    ["image"] = 901166,
                    ["name"] = "诺鲁什",
                }, -- [3]
                {
                    ["id"] = 867,
                    ["image"] = 901168,
                    ["name"] = "傲之煞",
                }, -- [4]
                {
                    ["id"] = 868,
                    ["image"] = 901156,
                    ["name"] = "迦拉卡斯",
                }, -- [5]
                {
                    ["id"] = 864,
                    ["image"] = 901161,
                    ["name"] = "钢铁战蝎",
                }, -- [6]
                {
                    ["id"] = 856,
                    ["image"] = 901163,
                    ["name"] = "库卡隆黑暗萨满",
                }, -- [7]
                {
                    ["id"] = 850,
                    ["image"] = 901158,
                    ["name"] = "纳兹戈林将军",
                }, -- [8]
                {
                    ["id"] = 846,
                    ["image"] = 901164,
                    ["name"] = "马尔考罗克",
                }, -- [9]
                {
                    ["id"] = 870,
                    ["image"] = 901170,
                    ["name"] = "潘达利亚战利品",
                }, -- [10]
                {
                    ["id"] = 851,
                    ["image"] = 901171,
                    ["name"] = "嗜血的索克",
                }, -- [11]
                {
                    ["id"] = 865,
                    ["image"] = 901169,
                    ["name"] = "攻城匠师黑索",
                }, -- [12]
                {
                    ["id"] = 853,
                    ["image"] = 901162,
                    ["name"] = "卡拉克西英杰",
                }, -- [13]
                {
                    ["id"] = 869,
                    ["image"] = 901157,
                    ["name"] = "加尔鲁什·地狱咆哮",
                }, -- [14]
            },
        }, -- [6]
        {
            ["id"] = 324,
            ["image"] = 643263,
            ["name"] = "围攻砮皂寺",
            ["bosses"] = {
                {
                    ["id"] = 693,
                    ["image"] = 630855,
                    ["name"] = "宰相金巴卡",
                }, -- [1]
                {
                    ["id"] = 738,
                    ["image"] = 630822,
                    ["name"] = "指挥官沃加克",
                }, -- [2]
                {
                    ["id"] = 692,
                    ["image"] = 630829,
                    ["name"] = "将军帕瓦拉克",
                }, -- [3]
                {
                    ["id"] = 727,
                    ["image"] = 630857,
                    ["name"] = "翼虫首领尼诺洛克",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 312,
            ["image"] = 632274,
            ["name"] = "影踪禅院",
            ["bosses"] = {
                {
                    ["id"] = 673,
                    ["image"] = 630831,
                    ["name"] = "古·穿云",
                }, -- [1]
                {
                    ["id"] = 657,
                    ["image"] = 630841,
                    ["name"] = "雪流大师",
                }, -- [2]
                {
                    ["id"] = 685,
                    ["image"] = 630850,
                    ["name"] = "狂之煞",
                }, -- [3]
                {
                    ["id"] = 686,
                    ["image"] = 630852,
                    ["name"] = "祝踏岚",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 303,
            ["image"] = 632270,
            ["name"] = "残阳关",
            ["bosses"] = {
                {
                    ["id"] = 655,
                    ["image"] = 630846,
                    ["name"] = "破坏者吉普提拉克",
                }, -- [1]
                {
                    ["id"] = 675,
                    ["image"] = 630851,
                    ["name"] = "突袭者加杜卡",
                }, -- [2]
                {
                    ["id"] = 676,
                    ["image"] = 630821,
                    ["name"] = "指挥官瑞魔克",
                }, -- [3]
                {
                    ["id"] = 649,
                    ["image"] = 630845,
                    ["name"] = "莱公",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 316,
            ["image"] = 608214,
            ["name"] = "血色修道院",
            ["bosses"] = {
                {
                    ["id"] = 688,
                    ["image"] = 630853,
                    ["name"] = "裂魂者萨尔诺斯",
                }, -- [1]
                {
                    ["id"] = 671,
                    ["image"] = 630818,
                    ["name"] = "科洛夫修士",
                }, -- [2]
                {
                    ["id"] = 674,
                    ["image"] = 607643,
                    ["name"] = "大检察官怀特迈恩",
                }, -- [3]
            },
        }, -- [10]
        {
            ["id"] = 311,
            ["image"] = 643262,
            ["name"] = "血色大厅",
            ["bosses"] = {
                {
                    ["id"] = 660,
                    ["image"] = 630833,
                    ["name"] = "驯犬者布兰恩",
                }, -- [1]
                {
                    ["id"] = 654,
                    ["image"] = 630816,
                    ["name"] = "武器大师哈兰",
                }, -- [2]
                {
                    ["id"] = 656,
                    ["image"] = 630825,
                    ["name"] = "织焰者孔格勒",
                }, -- [3]
            },
        }, -- [11]
        {
            ["id"] = 246,
            ["image"] = 608215,
            ["name"] = "通灵学院",
            ["bosses"] = {
                {
                    ["id"] = 659,
                    ["image"] = 630835,
                    ["name"] = "指导者寒心",
                }, -- [1]
                {
                    ["id"] = 663,
                    ["image"] = 607666,
                    ["name"] = "詹迪斯·巴罗夫",
                }, -- [2]
                {
                    ["id"] = 665,
                    ["image"] = 607755,
                    ["name"] = "血骨傀儡",
                }, -- [3]
                {
                    ["id"] = 666,
                    ["image"] = 630838,
                    ["name"] = "莉莉安·沃斯",
                }, -- [4]
                {
                    ["id"] = 684,
                    ["image"] = 607582,
                    ["name"] = "黑暗院长加丁",
                }, -- [5]
            },
        }, -- [12]
        {
            ["id"] = 313,
            ["image"] = 632276,
            ["name"] = "青龙寺",
            ["bosses"] = {
                {
                    ["id"] = 672,
                    ["image"] = 630858,
                    ["name"] = "贤者马里",
                }, -- [1]
                {
                    ["id"] = 664,
                    ["image"] = 630840,
                    ["name"] = "游学者石步",
                }, -- [2]
                {
                    ["id"] = 658,
                    ["image"] = 630839,
                    ["name"] = "刘·焰心",
                }, -- [3]
                {
                    ["id"] = 335,
                    ["image"] = 630848,
                    ["name"] = "疑之煞",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 302,
            ["image"] = 632275,
            ["name"] = "风暴烈酒酿造厂",
            ["bosses"] = {
                {
                    ["id"] = 668,
                    ["image"] = 630843,
                    ["name"] = "乌克乌克",
                }, -- [1]
                {
                    ["id"] = 669,
                    ["image"] = 630832,
                    ["name"] = "跳跳大王",
                }, -- [2]
                {
                    ["id"] = 670,
                    ["image"] = 630860,
                    ["name"] = "破桶而出的炎诛",
                }, -- [3]
            },
        }, -- [14]
        {
            ["id"] = 321,
            ["image"] = 632272,
            ["name"] = "魔古山宫殿",
            ["bosses"] = {
                {
                    ["id"] = 708,
                    ["image"] = 630842,
                    ["name"] = "君王的试炼",
                }, -- [1]
                {
                    ["id"] = 690,
                    ["image"] = 630828,
                    ["name"] = "杰翰",
                }, -- [2]
                {
                    ["id"] = 698,
                    ["image"] = 630859,
                    ["name"] = "武器大师席恩",
                }, -- [3]
            },
        }, -- [15]
    },
    ["燃烧的远征"] = {
        {
            ["id"] = 745,
            ["image"] = 1396584,
            ["name"] = "卡拉赞",
            ["bosses"] = {
                {
                    ["id"] = 1552,
                    ["image"] = 1385766,
                    ["name"] = "仆役宿舍",
                }, -- [1]
                {
                    ["id"] = 1553,
                    ["image"] = 1378965,
                    ["name"] = "猎手阿图门",
                }, -- [2]
                {
                    ["id"] = 1554,
                    ["image"] = 1378999,
                    ["name"] = "莫罗斯",
                }, -- [3]
                {
                    ["id"] = 1555,
                    ["image"] = 1378997,
                    ["name"] = "贞节圣女",
                }, -- [4]
                {
                    ["id"] = 1556,
                    ["image"] = 1385758,
                    ["name"] = "歌剧院",
                }, -- [5]
                {
                    ["id"] = 1557,
                    ["image"] = 1379020,
                    ["name"] = "馆长",
                }, -- [6]
                {
                    ["id"] = 1559,
                    ["image"] = 1379012,
                    ["name"] = "埃兰之影",
                }, -- [7]
                {
                    ["id"] = 1560,
                    ["image"] = 1379017,
                    ["name"] = "特雷斯坦·邪蹄",
                }, -- [8]
                {
                    ["id"] = 1561,
                    ["image"] = 1379002,
                    ["name"] = "虚空幽龙",
                }, -- [9]
                {
                    ["id"] = 1764,
                    ["image"] = 1385724,
                    ["name"] = "国际象棋",
                }, -- [10]
                {
                    ["id"] = 1563,
                    ["image"] = 1379006,
                    ["name"] = "玛克扎尔王子",
                }, -- [11]
            },
        }, -- [1]
        {
            ["id"] = 746,
            ["image"] = 1396582,
            ["name"] = "格鲁尔的巢穴",
            ["bosses"] = {
                {
                    ["id"] = 1564,
                    ["image"] = 1378985,
                    ["name"] = "莫加尔大王",
                }, -- [1]
                {
                    ["id"] = 1565,
                    ["image"] = 1378982,
                    ["name"] = "屠龙者格鲁尔",
                }, -- [2]
            },
        }, -- [2]
        {
            ["id"] = 747,
            ["image"] = 1396585,
            ["name"] = "玛瑟里顿的巢穴",
            ["bosses"] = {
                {
                    ["id"] = 1566,
                    ["image"] = 1378996,
                    ["name"] = "玛瑟里顿",
                }, -- [1]
            },
        }, -- [3]
        {
            ["id"] = 748,
            ["image"] = 608199,
            ["name"] = "毒蛇神殿",
            ["bosses"] = {
                {
                    ["id"] = 1567,
                    ["image"] = 1385741,
                    ["name"] = "不稳定的海度斯",
                }, -- [1]
                {
                    ["id"] = 1568,
                    ["image"] = 1385768,
                    ["name"] = "鱼斯拉",
                }, -- [2]
                {
                    ["id"] = 1569,
                    ["image"] = 1385751,
                    ["name"] = "盲眼者莱欧瑟拉斯",
                }, -- [3]
                {
                    ["id"] = 1570,
                    ["image"] = 1385729,
                    ["name"] = "深水领主卡拉瑟雷斯",
                }, -- [4]
                {
                    ["id"] = 1571,
                    ["image"] = 1385756,
                    ["name"] = "莫洛格里·踏潮者",
                }, -- [5]
                {
                    ["id"] = 1572,
                    ["image"] = 1385750,
                    ["name"] = "瓦丝琪",
                }, -- [6]
            },
        }, -- [4]
        {
            ["id"] = 749,
            ["image"] = 608218,
            ["name"] = "风暴要塞",
            ["bosses"] = {
                {
                    ["id"] = 1573,
                    ["image"] = 1385712,
                    ["name"] = "奥",
                }, -- [1]
                {
                    ["id"] = 1574,
                    ["image"] = 1385772,
                    ["name"] = "空灵机甲",
                }, -- [2]
                {
                    ["id"] = 1575,
                    ["image"] = 1385739,
                    ["name"] = "大星术师索兰莉安",
                }, -- [3]
                {
                    ["id"] = 1576,
                    ["image"] = 607669,
                    ["name"] = "凯尔萨斯·逐日者",
                }, -- [4]
            },
        }, -- [5]
        {
            ["id"] = 750,
            ["image"] = 608198,
            ["name"] = "海加尔山之战",
            ["bosses"] = {
                {
                    ["id"] = 1577,
                    ["image"] = 1385762,
                    ["name"] = "雷基·冬寒",
                }, -- [1]
                {
                    ["id"] = 1578,
                    ["image"] = 1385714,
                    ["name"] = "安纳塞隆",
                }, -- [2]
                {
                    ["id"] = 1579,
                    ["image"] = 1385745,
                    ["name"] = "卡兹洛加",
                }, -- [3]
                {
                    ["id"] = 1580,
                    ["image"] = 1385719,
                    ["name"] = "阿兹加洛",
                }, -- [4]
                {
                    ["id"] = 1581,
                    ["image"] = 1385716,
                    ["name"] = "阿克蒙德",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 751,
            ["image"] = 1396579,
            ["name"] = "黑暗神殿",
            ["bosses"] = {
                {
                    ["id"] = 1582,
                    ["image"] = 1378986,
                    ["name"] = "高阶督军纳因图斯",
                }, -- [1]
                {
                    ["id"] = 1583,
                    ["image"] = 1379016,
                    ["name"] = "苏普雷姆斯",
                }, -- [2]
                {
                    ["id"] = 1584,
                    ["image"] = 1379011,
                    ["name"] = "阿卡玛之影",
                }, -- [3]
                {
                    ["id"] = 1585,
                    ["image"] = 1379018,
                    ["name"] = "塔隆·血魔",
                }, -- [4]
                {
                    ["id"] = 1586,
                    ["image"] = 1378983,
                    ["name"] = "古尔图格·血沸",
                }, -- [5]
                {
                    ["id"] = 1587,
                    ["image"] = 1385764,
                    ["name"] = "灵魂之匣",
                }, -- [6]
                {
                    ["id"] = 1588,
                    ["image"] = 1379000,
                    ["name"] = "莎赫拉丝主母",
                }, -- [7]
                {
                    ["id"] = 1589,
                    ["image"] = 1385743,
                    ["name"] = "伊利达雷议会",
                }, -- [8]
                {
                    ["id"] = 1590,
                    ["image"] = 1378987,
                    ["name"] = "伊利丹·怒风",
                }, -- [9]
            },
        }, -- [7]
        {
            ["id"] = 752,
            ["image"] = 1396592,
            ["name"] = "太阳之井高地",
            ["bosses"] = {
                {
                    ["id"] = 1591,
                    ["image"] = 1385744,
                    ["name"] = "卡雷苟斯",
                }, -- [1]
                {
                    ["id"] = 1592,
                    ["image"] = 1385722,
                    ["name"] = "布鲁塔卢斯",
                }, -- [2]
                {
                    ["id"] = 1593,
                    ["image"] = 1385730,
                    ["name"] = "菲米丝",
                }, -- [3]
                {
                    ["id"] = 1594,
                    ["image"] = 1390438,
                    ["name"] = "艾瑞达双子",
                }, -- [4]
                {
                    ["id"] = 1595,
                    ["image"] = 1385757,
                    ["name"] = "穆鲁",
                }, -- [5]
                {
                    ["id"] = 1596,
                    ["image"] = 1385746,
                    ["name"] = "基尔加丹",
                }, -- [6]
            },
        }, -- [8]
        {
            ["id"] = 248,
            ["image"] = 608207,
            ["name"] = "地狱火城墙",
            ["bosses"] = {
                {
                    ["id"] = 527,
                    ["image"] = 607817,
                    ["name"] = "巡视者加戈玛",
                }, -- [1]
                {
                    ["id"] = 528,
                    ["image"] = 607734,
                    ["name"] = "无疤者奥摩尔",
                }, -- [2]
                {
                    ["id"] = 529,
                    ["image"] = 607803,
                    ["name"] = "传令官瓦兹德",
                }, -- [3]
            },
        }, -- [9]
        {
            ["id"] = 252,
            ["image"] = 608193,
            ["name"] = "塞泰克大厅",
            ["bosses"] = {
                {
                    ["id"] = 541,
                    ["image"] = 607583,
                    ["name"] = "黑暗编织者塞斯",
                }, -- [1]
                {
                    ["id"] = 543,
                    ["image"] = 607780,
                    ["name"] = "利爪之王艾吉斯",
                }, -- [2]
            },
        }, -- [10]
        {
            ["id"] = 247,
            ["image"] = 608193,
            ["name"] = "奥金尼地穴",
            ["bosses"] = {
                {
                    ["id"] = 523,
                    ["image"] = 607771,
                    ["name"] = "死亡观察者希尔拉克",
                }, -- [1]
                {
                    ["id"] = 524,
                    ["image"] = 607600,
                    ["name"] = "大主教玛拉达尔",
                }, -- [2]
            },
        }, -- [11]
        {
            ["id"] = 260,
            ["image"] = 608199,
            ["name"] = "奴隶围栏",
            ["bosses"] = {
                {
                    ["id"] = 570,
                    ["image"] = 607715,
                    ["name"] = "背叛者门努",
                }, -- [1]
                {
                    ["id"] = 571,
                    ["image"] = 607759,
                    ["name"] = "巨钳鲁克玛尔",
                }, -- [2]
                {
                    ["id"] = 572,
                    ["image"] = 607750,
                    ["name"] = "夸格米拉",
                }, -- [3]
            },
        }, -- [12]
        {
            ["id"] = 262,
            ["image"] = 608199,
            ["name"] = "幽暗沼泽",
            ["bosses"] = {
                {
                    ["id"] = 576,
                    ["image"] = 607649,
                    ["name"] = "霍加尔芬",
                }, -- [1]
                {
                    ["id"] = 577,
                    ["image"] = 607614,
                    ["name"] = "加兹安",
                }, -- [2]
                {
                    ["id"] = 578,
                    ["image"] = 607779,
                    ["name"] = "沼地领主穆塞雷克",
                }, -- [3]
                {
                    ["id"] = 579,
                    ["image"] = 607788,
                    ["name"] = "黑色阔步者",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 251,
            ["image"] = 608198,
            ["name"] = "旧希尔斯布莱德丘陵",
            ["bosses"] = {
                {
                    ["id"] = 538,
                    ["image"] = 607689,
                    ["name"] = "德拉克中尉",
                }, -- [1]
                {
                    ["id"] = 539,
                    ["image"] = 607561,
                    ["name"] = "斯卡洛克上尉",
                }, -- [2]
                {
                    ["id"] = 540,
                    ["image"] = 607596,
                    ["name"] = "时空猎手",
                }, -- [3]
            },
        }, -- [14]
        {
            ["id"] = 253,
            ["image"] = 608193,
            ["name"] = "暗影迷宫",
            ["bosses"] = {
                {
                    ["id"] = 544,
                    ["image"] = 607536,
                    ["name"] = "赫尔默大使",
                }, -- [1]
                {
                    ["id"] = 545,
                    ["image"] = 607555,
                    ["name"] = "煽动者布莱卡特",
                }, -- [2]
                {
                    ["id"] = 546,
                    ["image"] = 607625,
                    ["name"] = "沃匹尔大师",
                }, -- [3]
                {
                    ["id"] = 547,
                    ["image"] = 607720,
                    ["name"] = "摩摩尔",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 250,
            ["image"] = 608193,
            ["name"] = "法力陵墓",
            ["bosses"] = {
                {
                    ["id"] = 534,
                    ["image"] = 607738,
                    ["name"] = "潘德莫努斯",
                }, -- [1]
                {
                    ["id"] = 535,
                    ["image"] = 607782,
                    ["name"] = "塔瓦洛克",
                }, -- [2]
                {
                    ["id"] = 537,
                    ["image"] = 607726,
                    ["name"] = "节点亲王沙法尔",
                }, -- [3]
            },
        }, -- [16]
        {
            ["id"] = 257,
            ["image"] = 608218,
            ["name"] = "生态船",
            ["bosses"] = {
                {
                    ["id"] = 558,
                    ["image"] = 607570,
                    ["name"] = "指挥官萨拉妮丝",
                }, -- [1]
                {
                    ["id"] = 559,
                    ["image"] = 607641,
                    ["name"] = "高级植物学家弗雷温",
                }, -- [2]
                {
                    ["id"] = 560,
                    ["image"] = 607794,
                    ["name"] = "看管者索恩格林",
                }, -- [3]
                {
                    ["id"] = 561,
                    ["image"] = 607683,
                    ["name"] = "拉伊",
                }, -- [4]
                {
                    ["id"] = 562,
                    ["image"] = 607816,
                    ["name"] = "迁跃扭木",
                }, -- [5]
            },
        }, -- [17]
        {
            ["id"] = 259,
            ["image"] = 608207,
            ["name"] = "破碎大厅",
            ["bosses"] = {
                {
                    ["id"] = 566,
                    ["image"] = 607624,
                    ["name"] = "高阶术士奈瑟库斯",
                }, -- [1]
                {
                    ["id"] = 568,
                    ["image"] = 607811,
                    ["name"] = "战争使者沃姆罗格",
                }, -- [2]
                {
                    ["id"] = 569,
                    ["image"] = 607812,
                    ["name"] = "酋长卡加斯·刃拳",
                }, -- [3]
            },
        }, -- [18]
        {
            ["id"] = 254,
            ["image"] = 608218,
            ["name"] = "禁魔监狱",
            ["bosses"] = {
                {
                    ["id"] = 548,
                    ["image"] = 607823,
                    ["name"] = "自由的瑟雷凯斯",
                }, -- [1]
                {
                    ["id"] = 549,
                    ["image"] = 607574,
                    ["name"] = "末日预言者达尔莉安",
                }, -- [2]
                {
                    ["id"] = 550,
                    ["image"] = 607820,
                    ["name"] = "天怒预言者苏克拉底",
                }, -- [3]
                {
                    ["id"] = 551,
                    ["image"] = 607635,
                    ["name"] = "预言者斯克瑞斯",
                }, -- [4]
            },
        }, -- [19]
        {
            ["id"] = 258,
            ["image"] = 608218,
            ["name"] = "能源舰",
            ["bosses"] = {
                {
                    ["id"] = 563,
                    ["image"] = 607712,
                    ["name"] = "机械领主卡帕西图斯",
                }, -- [1]
                {
                    ["id"] = 564,
                    ["image"] = 607725,
                    ["name"] = "灵术师塞比瑟蕾",
                }, -- [2]
                {
                    ["id"] = 565,
                    ["image"] = 607739,
                    ["name"] = "计算者帕萨雷恩",
                }, -- [3]
            },
        }, -- [20]
        {
            ["id"] = 261,
            ["image"] = 608199,
            ["name"] = "蒸汽地窟",
            ["bosses"] = {
                {
                    ["id"] = 573,
                    ["image"] = 607651,
                    ["name"] = "水术师瑟丝比娅",
                }, -- [1]
                {
                    ["id"] = 574,
                    ["image"] = 607713,
                    ["name"] = "机械师斯蒂里格",
                }, -- [2]
                {
                    ["id"] = 575,
                    ["image"] = 607815,
                    ["name"] = "督军卡利瑟里斯",
                }, -- [3]
            },
        }, -- [21]
        {
            ["id"] = 249,
            ["image"] = 608208,
            ["name"] = "魔导师平台",
            ["bosses"] = {
                {
                    ["id"] = 530,
                    ["image"] = 607767,
                    ["name"] = "塞林·火心",
                }, -- [1]
                {
                    ["id"] = 531,
                    ["image"] = 607806,
                    ["name"] = "维萨鲁斯",
                }, -- [2]
                {
                    ["id"] = 532,
                    ["image"] = 607742,
                    ["name"] = "女祭司德莉希亚",
                }, -- [3]
                {
                    ["id"] = 533,
                    ["image"] = 607669,
                    ["name"] = "凯尔萨斯·逐日者",
                }, -- [4]
            },
        }, -- [22]
        {
            ["id"] = 256,
            ["image"] = 608207,
            ["name"] = "鲜血熔炉",
            ["bosses"] = {
                {
                    ["id"] = 555,
                    ["image"] = 607789,
                    ["name"] = "制造者",
                }, -- [1]
                {
                    ["id"] = 556,
                    ["image"] = 607558,
                    ["name"] = "布洛戈克",
                }, -- [2]
                {
                    ["id"] = 557,
                    ["image"] = 607670,
                    ["name"] = "击碎者克里丹",
                }, -- [3]
            },
        }, -- [23]
        {
            ["id"] = 255,
            ["image"] = 608198,
            ["name"] = "黑色沼泽",
            ["bosses"] = {
                {
                    ["id"] = 552,
                    ["image"] = 607566,
                    ["name"] = "时空领主德亚",
                }, -- [1]
                {
                    ["id"] = 553,
                    ["image"] = 607784,
                    ["name"] = "坦普卢斯",
                }, -- [2]
                {
                    ["id"] = 554,
                    ["image"] = 607529,
                    ["name"] = "埃欧努斯",
                }, -- [3]
            },
        }, -- [24]
    },
    ["暗影国度"] = {
        {
            ["id"] = 1192,
            ["image"] = 3850569,
            ["name"] = "暗影界",
            ["bosses"] = {
                {
                    ["id"] = 2430,
                    ["image"] = 3752195,
                    ["name"] = "瓦里诺，万古之光",
                }, -- [1]
                {
                    ["id"] = 2431,
                    ["image"] = 3752183,
                    ["name"] = "莫塔尼斯",
                }, -- [2]
                {
                    ["id"] = 2432,
                    ["image"] = 3752188,
                    ["name"] = "“长青之枝”奥拉诺莫诺斯",
                }, -- [3]
                {
                    ["id"] = 2433,
                    ["image"] = 3752187,
                    ["name"] = "诺尔伽什·泥躯",
                }, -- [4]
                {
                    ["id"] = 2456,
                    ["image"] = 4071436,
                    ["name"] = "莫盖斯，罪人的折磨者",
                }, -- [5]
                {
                    ["id"] = 2468,
                    ["image"] = 4529365,
                    ["name"] = "安特洛斯",
                }, -- [6]
            },
        }, -- [1]
        {
            ["id"] = 1190,
            ["image"] = 3759906,
            ["name"] = "纳斯利亚堡",
            ["bosses"] = {
                {
                    ["id"] = 2393,
                    ["image"] = 3752190,
                    ["name"] = "啸翼",
                }, -- [1]
                {
                    ["id"] = 2429,
                    ["image"] = 3753151,
                    ["name"] = "猎手阿尔迪莫",
                }, -- [2]
                {
                    ["id"] = 2422,
                    ["image"] = 3753157,
                    ["name"] = "太阳之王的救赎",
                }, -- [3]
                {
                    ["id"] = 2418,
                    ["image"] = 3752156,
                    ["name"] = "圣物匠赛·墨克斯",
                }, -- [4]
                {
                    ["id"] = 2428,
                    ["image"] = 3752174,
                    ["name"] = "饥饿的毁灭者",
                }, -- [5]
                {
                    ["id"] = 2420,
                    ["image"] = 3752178,
                    ["name"] = "伊涅瓦·暗脉女勋爵",
                }, -- [6]
                {
                    ["id"] = 2426,
                    ["image"] = 3753159,
                    ["name"] = "猩红议会",
                }, -- [7]
                {
                    ["id"] = 2394,
                    ["image"] = 3752191,
                    ["name"] = "泥拳",
                }, -- [8]
                {
                    ["id"] = 2425,
                    ["image"] = 3753156,
                    ["name"] = "顽石军团干将",
                }, -- [9]
                {
                    ["id"] = 2424,
                    ["image"] = 3752159,
                    ["name"] = "德纳修斯大帝",
                }, -- [10]
            },
        }, -- [2]
        {
            ["id"] = 1193,
            ["image"] = 4182020,
            ["name"] = "统御圣所",
            ["bosses"] = {
                {
                    ["id"] = 2435,
                    ["image"] = 4071444,
                    ["name"] = "塔拉格鲁",
                }, -- [1]
                {
                    ["id"] = 2442,
                    ["image"] = 4071426,
                    ["name"] = "典狱长之眼",
                }, -- [2]
                {
                    ["id"] = 2439,
                    ["image"] = 4071445,
                    ["name"] = "九武神",
                }, -- [3]
                {
                    ["id"] = 2444,
                    ["image"] = 4071439,
                    ["name"] = "耐奥祖的残迹",
                }, -- [4]
                {
                    ["id"] = 2445,
                    ["image"] = 4071442,
                    ["name"] = "裂魂者多尔玛赞",
                }, -- [5]
                {
                    ["id"] = 2443,
                    ["image"] = 4079051,
                    ["name"] = "痛楚工匠莱兹纳尔",
                }, -- [6]
                {
                    ["id"] = 2446,
                    ["image"] = 4071428,
                    ["name"] = "初诞者的卫士",
                }, -- [7]
                {
                    ["id"] = 2447,
                    ["image"] = 4071427,
                    ["name"] = "命运撰写师罗-卡洛",
                }, -- [8]
                {
                    ["id"] = 2440,
                    ["image"] = 4071435,
                    ["name"] = "克尔苏加德",
                }, -- [9]
                {
                    ["id"] = 2441,
                    ["image"] = 4071443,
                    ["name"] = "希尔瓦娜斯·风行者",
                }, -- [10]
            },
        }, -- [3]
        {
            ["id"] = 1195,
            ["image"] = 4423752,
            ["name"] = "初诞者圣墓",
            ["bosses"] = {
                {
                    ["id"] = 2458,
                    ["image"] = 4465340,
                    ["name"] = "警戒卫士",
                }, -- [1]
                {
                    ["id"] = 2465,
                    ["image"] = 4465339,
                    ["name"] = "司垢莱克斯，无穷噬灭者",
                }, -- [2]
                {
                    ["id"] = 2470,
                    ["image"] = 4423749,
                    ["name"] = "圣物匠赛·墨克斯",
                }, -- [3]
                {
                    ["id"] = 2459,
                    ["image"] = 4465333,
                    ["name"] = "道茜歌妮，堕落先知",
                }, -- [4]
                {
                    ["id"] = 2460,
                    ["image"] = 4465337,
                    ["name"] = "死亡万神殿原型体",
                }, -- [5]
                {
                    ["id"] = 2461,
                    ["image"] = 4465335,
                    ["name"] = "首席造物师利许威姆",
                }, -- [6]
                {
                    ["id"] = 2463,
                    ["image"] = 4423738,
                    ["name"] = "回收者黑伦度斯",
                }, -- [7]
                {
                    ["id"] = 2469,
                    ["image"] = 4423747,
                    ["name"] = "安度因·乌瑞恩",
                }, -- [8]
                {
                    ["id"] = 2457,
                    ["image"] = 4465336,
                    ["name"] = "恐惧双王",
                }, -- [9]
                {
                    ["id"] = 2467,
                    ["image"] = 4465338,
                    ["name"] = "莱葛隆",
                }, -- [10]
                {
                    ["id"] = 2464,
                    ["image"] = 4465334,
                    ["name"] = "典狱长",
                }, -- [11]
            },
        }, -- [4]
        {
            ["id"] = 1187,
            ["image"] = 3759914,
            ["name"] = "伤逝剧场",
            ["bosses"] = {
                {
                    ["id"] = 2397,
                    ["image"] = 3752153,
                    ["name"] = "狭路相逢",
                }, -- [1]
                {
                    ["id"] = 2401,
                    ["image"] = 3752169,
                    ["name"] = "斩血",
                }, -- [2]
                {
                    ["id"] = 2390,
                    ["image"] = 3752199,
                    ["name"] = "无堕者哈夫",
                }, -- [3]
                {
                    ["id"] = 2389,
                    ["image"] = 3753154,
                    ["name"] = "库尔萨洛克",
                }, -- [4]
                {
                    ["id"] = 2417,
                    ["image"] = 3752182,
                    ["name"] = "无尽女皇莫德蕾莎",
                }, -- [5]
            },
        }, -- [5]
        {
            ["id"] = 1183,
            ["image"] = 3759911,
            ["name"] = "凋魂之殇",
            ["bosses"] = {
                {
                    ["id"] = 2419,
                    ["image"] = 3752168,
                    ["name"] = "酤团",
                }, -- [1]
                {
                    ["id"] = 2403,
                    ["image"] = 3752162,
                    ["name"] = "伊库斯博士",
                }, -- [2]
                {
                    ["id"] = 2423,
                    ["image"] = 3752163,
                    ["name"] = "多米娜·毒刃",
                }, -- [3]
                {
                    ["id"] = 2404,
                    ["image"] = 3752180,
                    ["name"] = "斯特拉达玛侯爵",
                }, -- [4]
            },
        }, -- [6]
        {
            ["id"] = 1194,
            ["image"] = 4182022,
            ["name"] = "塔扎维什，帷纱集市",
            ["bosses"] = {
                {
                    ["id"] = 2437,
                    ["image"] = 4071449,
                    ["name"] = "哨卫佐·菲克斯",
                }, -- [1]
                {
                    ["id"] = 2454,
                    ["image"] = 4071447,
                    ["name"] = "卖品会",
                }, -- [2]
                {
                    ["id"] = 2436,
                    ["image"] = 4071438,
                    ["name"] = "收发室乱战",
                }, -- [3]
                {
                    ["id"] = 2452,
                    ["image"] = 4071448,
                    ["name"] = "麦扎的绿洲",
                }, -- [4]
                {
                    ["id"] = 2451,
                    ["image"] = 4071440,
                    ["name"] = "索·阿兹密",
                }, -- [5]
                {
                    ["id"] = 2448,
                    ["image"] = 4071429,
                    ["name"] = "希尔布兰德",
                }, -- [6]
                {
                    ["id"] = 2449,
                    ["image"] = 4071446,
                    ["name"] = "时空船长钩尾",
                }, -- [7]
                {
                    ["id"] = 2455,
                    ["image"] = 4071441,
                    ["name"] = "索·莉亚",
                }, -- [8]
            },
        }, -- [7]
        {
            ["id"] = 1184,
            ["image"] = 3759909,
            ["name"] = "塞兹仙林的迷雾",
            ["bosses"] = {
                {
                    ["id"] = 2400,
                    ["image"] = 3753152,
                    ["name"] = "英格拉·马洛克",
                }, -- [1]
                {
                    ["id"] = 2402,
                    ["image"] = 3752181,
                    ["name"] = "唤雾者",
                }, -- [2]
                {
                    ["id"] = 2405,
                    ["image"] = 3752194,
                    ["name"] = "特雷德奥瓦",
                }, -- [3]
            },
        }, -- [8]
        {
            ["id"] = 1188,
            ["image"] = 3759915,
            ["name"] = "彼界",
            ["bosses"] = {
                {
                    ["id"] = 2408,
                    ["image"] = 3752170,
                    ["name"] = "夺灵者哈卡",
                }, -- [1]
                {
                    ["id"] = 2409,
                    ["image"] = 3752193,
                    ["name"] = "法力风暴夫妇",
                }, -- [2]
                {
                    ["id"] = 2398,
                    ["image"] = 3753147,
                    ["name"] = "商人赛·艾柯莎",
                }, -- [3]
                {
                    ["id"] = 2410,
                    ["image"] = 3752184,
                    ["name"] = "穆厄扎拉",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 1186,
            ["image"] = 3759913,
            ["name"] = "晋升高塔",
            ["bosses"] = {
                {
                    ["id"] = 2399,
                    ["image"] = 3752177,
                    ["name"] = "金-塔拉",
                }, -- [1]
                {
                    ["id"] = 2416,
                    ["image"] = 3752198,
                    ["name"] = "雯图纳柯丝",
                }, -- [2]
                {
                    ["id"] = 2414,
                    ["image"] = 3752189,
                    ["name"] = "奥莱芙莉安",
                }, -- [3]
                {
                    ["id"] = 2412,
                    ["image"] = 3752160,
                    ["name"] = "疑虑圣杰德沃丝",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 1185,
            ["image"] = 3759908,
            ["name"] = "赎罪大厅",
            ["bosses"] = {
                {
                    ["id"] = 2406,
                    ["image"] = 3752171,
                    ["name"] = "哈尔吉亚斯，罪污巨像",
                }, -- [1]
                {
                    ["id"] = 2387,
                    ["image"] = 3752165,
                    ["name"] = "艾谢朗",
                }, -- [2]
                {
                    ["id"] = 2411,
                    ["image"] = 3753150,
                    ["name"] = "高阶裁决官阿丽兹",
                }, -- [3]
                {
                    ["id"] = 2413,
                    ["image"] = 3752179,
                    ["name"] = "宫务大臣",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 1189,
            ["image"] = 3759912,
            ["name"] = "赤红深渊",
            ["bosses"] = {
                {
                    ["id"] = 2388,
                    ["image"] = 3753153,
                    ["name"] = "贪食的克里克西斯",
                }, -- [1]
                {
                    ["id"] = 2415,
                    ["image"] = 3753148,
                    ["name"] = "执行者塔沃德",
                }, -- [2]
                {
                    ["id"] = 2421,
                    ["image"] = 3753149,
                    ["name"] = "大学监贝律莉娅",
                }, -- [3]
                {
                    ["id"] = 2407,
                    ["image"] = 3752167,
                    ["name"] = "卡尔将军",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 1182,
            ["image"] = 3759910,
            ["name"] = "通灵战潮",
            ["bosses"] = {
                {
                    ["id"] = 2395,
                    ["image"] = 3752157,
                    ["name"] = "凋骨",
                }, -- [1]
                {
                    ["id"] = 2391,
                    ["image"] = 3753146,
                    ["name"] = "收割者阿玛厄斯",
                }, -- [2]
                {
                    ["id"] = 2392,
                    ["image"] = 3753158,
                    ["name"] = "外科医生缝肉",
                }, -- [3]
                {
                    ["id"] = 2396,
                    ["image"] = 3753155,
                    ["name"] = "缚霜者纳尔佐",
                }, -- [4]
            },
        }, -- [13]
    },
    ["大地的裂变"] = {
        {
            ["id"] = 75,
            ["image"] = 522349,
            ["name"] = "巴拉丁监狱",
            ["bosses"] = {
                {
                    ["id"] = 139,
                    ["image"] = 522198,
                    ["name"] = "阿尔加洛斯",
                }, -- [1]
                {
                    ["id"] = 140,
                    ["image"] = 523207,
                    ["name"] = "欧库塔尔",
                }, -- [2]
                {
                    ["id"] = 339,
                    ["image"] = 571742,
                    ["name"] = "憎恨女王阿丽萨巴尔",
                }, -- [3]
            },
        }, -- [1]
        {
            ["id"] = 72,
            ["image"] = 522355,
            ["name"] = "暮光堡垒",
            ["bosses"] = {
                {
                    ["id"] = 156,
                    ["image"] = 522232,
                    ["name"] = "哈尔弗斯·碎龙者",
                }, -- [1]
                {
                    ["id"] = 157,
                    ["image"] = 522274,
                    ["name"] = "瑟纳利昂和瓦里昂娜",
                }, -- [2]
                {
                    ["id"] = 158,
                    ["image"] = 522224,
                    ["name"] = "升腾者议会",
                }, -- [3]
                {
                    ["id"] = 167,
                    ["image"] = 522212,
                    ["name"] = "古加尔",
                }, -- [4]
            },
        }, -- [2]
        {
            ["id"] = 74,
            ["image"] = 522359,
            ["name"] = "风神王座",
            ["bosses"] = {
                {
                    ["id"] = 154,
                    ["image"] = 522196,
                    ["name"] = "风之议会",
                }, -- [1]
                {
                    ["id"] = 155,
                    ["image"] = 522191,
                    ["name"] = "奥拉基尔",
                }, -- [2]
            },
        }, -- [3]
        {
            ["id"] = 73,
            ["image"] = 522351,
            ["name"] = "黑翼血环",
            ["bosses"] = {
                {
                    ["id"] = 169,
                    ["image"] = 522250,
                    ["name"] = "全能金刚防御系统",
                }, -- [1]
                {
                    ["id"] = 170,
                    ["image"] = 522251,
                    ["name"] = "熔喉",
                }, -- [2]
                {
                    ["id"] = 171,
                    ["image"] = 522202,
                    ["name"] = "艾卓曼德斯",
                }, -- [3]
                {
                    ["id"] = 172,
                    ["image"] = 522211,
                    ["name"] = "奇美隆",
                }, -- [4]
                {
                    ["id"] = 173,
                    ["image"] = 522252,
                    ["name"] = "马洛拉克",
                }, -- [5]
                {
                    ["id"] = 174,
                    ["image"] = 522255,
                    ["name"] = "奈法利安的末日",
                }, -- [6]
            },
        }, -- [4]
        {
            ["id"] = 78,
            ["image"] = 522353,
            ["name"] = "火焰之地",
            ["bosses"] = {
                {
                    ["id"] = 192,
                    ["image"] = 522208,
                    ["name"] = "贝丝缇拉克",
                }, -- [1]
                {
                    ["id"] = 193,
                    ["image"] = 522248,
                    ["name"] = "雷奥利斯领主",
                }, -- [2]
                {
                    ["id"] = 194,
                    ["image"] = 522193,
                    ["name"] = "奥利瑟拉佐尔",
                }, -- [3]
                {
                    ["id"] = 195,
                    ["image"] = 522268,
                    ["name"] = "沙恩诺克斯",
                }, -- [4]
                {
                    ["id"] = 196,
                    ["image"] = 522204,
                    ["name"] = "护门人贝尔洛克",
                }, -- [5]
                {
                    ["id"] = 197,
                    ["image"] = 522223,
                    ["name"] = "管理者鹿盔",
                }, -- [6]
                {
                    ["id"] = 198,
                    ["image"] = 522261,
                    ["name"] = "拉格纳罗斯",
                }, -- [7]
            },
        }, -- [5]
        {
            ["id"] = 187,
            ["image"] = 571753,
            ["name"] = "巨龙之魂",
            ["bosses"] = {
                {
                    ["id"] = 311,
                    ["image"] = 536058,
                    ["name"] = "莫卓克",
                }, -- [1]
                {
                    ["id"] = 324,
                    ["image"] = 536061,
                    ["name"] = "督军佐诺兹",
                }, -- [2]
                {
                    ["id"] = 325,
                    ["image"] = 536062,
                    ["name"] = "不眠的约萨希",
                }, -- [3]
                {
                    ["id"] = 317,
                    ["image"] = 536057,
                    ["name"] = "缚风者哈格拉",
                }, -- [4]
                {
                    ["id"] = 331,
                    ["image"] = 571750,
                    ["name"] = "奥卓克希昂",
                }, -- [5]
                {
                    ["id"] = 332,
                    ["image"] = 571752,
                    ["name"] = "战争大师黑角",
                }, -- [6]
                {
                    ["id"] = 318,
                    ["image"] = 536056,
                    ["name"] = "死亡之翼的背脊",
                }, -- [7]
                {
                    ["id"] = 333,
                    ["image"] = 536055,
                    ["name"] = "疯狂的死亡之翼",
                }, -- [8]
            },
        }, -- [6]
        {
            ["id"] = 67,
            ["image"] = 522360,
            ["name"] = "巨石之核",
            ["bosses"] = {
                {
                    ["id"] = 110,
                    ["image"] = 522215,
                    ["name"] = "克伯鲁斯",
                }, -- [1]
                {
                    ["id"] = 111,
                    ["image"] = 522271,
                    ["name"] = "岩皮",
                }, -- [2]
                {
                    ["id"] = 112,
                    ["image"] = 522258,
                    ["name"] = "欧泽鲁克",
                }, -- [3]
                {
                    ["id"] = 113,
                    ["image"] = 522237,
                    ["name"] = "高阶女祭司艾苏尔",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 64,
            ["image"] = 522358,
            ["name"] = "影牙城堡",
            ["bosses"] = {
                {
                    ["id"] = 96,
                    ["image"] = 522205,
                    ["name"] = "灰葬男爵",
                }, -- [1]
                {
                    ["id"] = 97,
                    ["image"] = 522206,
                    ["name"] = "席瓦莱恩男爵",
                }, -- [2]
                {
                    ["id"] = 98,
                    ["image"] = 522213,
                    ["name"] = "指挥官斯普林瓦尔",
                }, -- [3]
                {
                    ["id"] = 99,
                    ["image"] = 522249,
                    ["name"] = "沃登勋爵",
                }, -- [4]
                {
                    ["id"] = 100,
                    ["image"] = 522247,
                    ["name"] = "高弗雷勋爵",
                }, -- [5]
            },
        }, -- [8]
        {
            ["id"] = 69,
            ["image"] = 522357,
            ["name"] = "托维尔失落之城",
            ["bosses"] = {
                {
                    ["id"] = 117,
                    ["image"] = 523205,
                    ["name"] = "胡辛姆将军",
                }, -- [1]
                {
                    ["id"] = 118,
                    ["image"] = 522246,
                    ["name"] = "锁喉",
                }, -- [2]
                {
                    ["id"] = 119,
                    ["image"] = 522239,
                    ["name"] = "高阶预言者巴林姆",
                }, -- [3]
                {
                    ["id"] = 122,
                    ["image"] = 522269,
                    ["name"] = "希亚玛特",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 68,
            ["image"] = 522361,
            ["name"] = "旋云之巅",
            ["bosses"] = {
                {
                    ["id"] = 114,
                    ["image"] = 522229,
                    ["name"] = "大宰相埃尔坦",
                }, -- [1]
                {
                    ["id"] = 115,
                    ["image"] = 522192,
                    ["name"] = "阿尔泰鲁斯",
                }, -- [2]
                {
                    ["id"] = 116,
                    ["image"] = 522200,
                    ["name"] = "西风君王阿萨德",
                }, -- [3]
            },
        }, -- [10]
        {
            ["id"] = 184,
            ["image"] = 571754,
            ["name"] = "时光之末",
            ["bosses"] = {
                {
                    ["id"] = 340,
                    ["image"] = 571744,
                    ["name"] = "贝恩的残影",
                }, -- [1]
                {
                    ["id"] = 285,
                    ["image"] = 571745,
                    ["name"] = "吉安娜的残影",
                }, -- [2]
                {
                    ["id"] = 323,
                    ["image"] = 571748,
                    ["name"] = "希尔瓦娜斯的残影",
                }, -- [3]
                {
                    ["id"] = 283,
                    ["image"] = 571749,
                    ["name"] = "泰兰德的残影",
                }, -- [4]
                {
                    ["id"] = 289,
                    ["image"] = 536059,
                    ["name"] = "姆诺兹多",
                }, -- [5]
            },
        }, -- [11]
        {
            ["id"] = 186,
            ["image"] = 571755,
            ["name"] = "暮光审判",
            ["bosses"] = {
                {
                    ["id"] = 322,
                    ["image"] = 571743,
                    ["name"] = "阿奎里恩",
                }, -- [1]
                {
                    ["id"] = 342,
                    ["image"] = 536054,
                    ["name"] = "埃希拉·黎明克星",
                }, -- [2]
                {
                    ["id"] = 341,
                    ["image"] = 536053,
                    ["name"] = "大主教本尼迪塔斯",
                }, -- [3]
            },
        }, -- [12]
        {
            ["id"] = 71,
            ["image"] = 522354,
            ["name"] = "格瑞姆巴托",
            ["bosses"] = {
                {
                    ["id"] = 131,
                    ["image"] = 522227,
                    ["name"] = "乌比斯将军",
                }, -- [1]
                {
                    ["id"] = 132,
                    ["image"] = 522226,
                    ["name"] = "铸炉之主索朗格斯",
                }, -- [2]
                {
                    ["id"] = 133,
                    ["image"] = 522218,
                    ["name"] = "达加·燃影者",
                }, -- [3]
                {
                    ["id"] = 134,
                    ["image"] = 522222,
                    ["name"] = "地狱公爵埃鲁达克",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 63,
            ["image"] = 522352,
            ["name"] = "死亡矿井",
            ["bosses"] = {
                {
                    ["id"] = 89,
                    ["image"] = 522228,
                    ["name"] = "格拉布托克",
                }, -- [1]
                {
                    ["id"] = 90,
                    ["image"] = 522234,
                    ["name"] = "赫利克斯·破甲",
                }, -- [2]
                {
                    ["id"] = 91,
                    ["image"] = 522225,
                    ["name"] = "死神5000",
                }, -- [3]
                {
                    ["id"] = 92,
                    ["image"] = 522189,
                    ["name"] = "撕心狼将军",
                }, -- [4]
                {
                    ["id"] = 93,
                    ["image"] = 522210,
                    ["name"] = "“船长”曲奇",
                }, -- [5]
            },
        }, -- [14]
        {
            ["id"] = 185,
            ["image"] = 571756,
            ["name"] = "永恒之井",
            ["bosses"] = {
                {
                    ["id"] = 290,
                    ["image"] = 536060,
                    ["name"] = "佩罗萨恩",
                }, -- [1]
                {
                    ["id"] = 291,
                    ["image"] = 571747,
                    ["name"] = "艾萨拉女王",
                }, -- [2]
                {
                    ["id"] = 292,
                    ["image"] = 571746,
                    ["name"] = "玛诺洛斯与瓦罗森",
                }, -- [3]
            },
        }, -- [15]
        {
            ["id"] = 65,
            ["image"] = 522362,
            ["name"] = "潮汐王座",
            ["bosses"] = {
                {
                    ["id"] = 101,
                    ["image"] = 522245,
                    ["name"] = "纳兹夏尔女士",
                }, -- [1]
                {
                    ["id"] = 102,
                    ["image"] = 522214,
                    ["name"] = "指挥官乌尔索克，腐烂王子",
                }, -- [2]
                {
                    ["id"] = 103,
                    ["image"] = 522253,
                    ["name"] = "蛊心魔古厄夏",
                }, -- [3]
                {
                    ["id"] = 104,
                    ["image"] = 522259,
                    ["name"] = "厄祖玛特",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 76,
            ["image"] = 522364,
            ["name"] = "祖尔格拉布",
            ["bosses"] = {
                {
                    ["id"] = 175,
                    ["image"] = 522236,
                    ["name"] = "高阶祭司温诺希斯",
                }, -- [1]
                {
                    ["id"] = 176,
                    ["image"] = 522209,
                    ["name"] = "血领主曼多基尔",
                }, -- [2]
                {
                    ["id"] = 177,
                    ["image"] = 522230,
                    ["name"] = "疯狂之缘——格里雷克",
                }, -- [3]
                {
                    ["id"] = 178,
                    ["image"] = 522233,
                    ["name"] = "疯狂之缘——哈扎拉尔",
                }, -- [4]
                {
                    ["id"] = 179,
                    ["image"] = 522263,
                    ["name"] = "疯狂之缘——雷纳塔基",
                }, -- [5]
                {
                    ["id"] = 180,
                    ["image"] = 522279,
                    ["name"] = "疯狂之缘——乌苏雷",
                }, -- [6]
                {
                    ["id"] = 181,
                    ["image"] = 522238,
                    ["name"] = "高阶祭司基尔娜拉",
                }, -- [7]
                {
                    ["id"] = 184,
                    ["image"] = 522280,
                    ["name"] = "赞吉尔",
                }, -- [8]
                {
                    ["id"] = 185,
                    ["image"] = 522243,
                    ["name"] = "碎神者金度",
                }, -- [9]
            },
        }, -- [17]
        {
            ["id"] = 77,
            ["image"] = 522363,
            ["name"] = "祖阿曼",
            ["bosses"] = {
                {
                    ["id"] = 186,
                    ["image"] = 522190,
                    ["name"] = "埃基尔松",
                }, -- [1]
                {
                    ["id"] = 187,
                    ["image"] = 522254,
                    ["name"] = "纳洛拉克",
                }, -- [2]
                {
                    ["id"] = 188,
                    ["image"] = 522242,
                    ["name"] = "加亚莱",
                }, -- [3]
                {
                    ["id"] = 189,
                    ["image"] = 522231,
                    ["name"] = "哈尔拉兹",
                }, -- [4]
                {
                    ["id"] = 190,
                    ["image"] = 522235,
                    ["name"] = "妖术领主玛拉卡斯",
                }, -- [5]
                {
                    ["id"] = 191,
                    ["image"] = 522217,
                    ["name"] = "达卡拉",
                }, -- [6]
            },
        }, -- [18]
        {
            ["id"] = 70,
            ["image"] = 522356,
            ["name"] = "起源大厅",
            ["bosses"] = {
                {
                    ["id"] = 124,
                    ["image"] = 522272,
                    ["name"] = "神殿守护者安努尔",
                }, -- [1]
                {
                    ["id"] = 125,
                    ["image"] = 522219,
                    ["name"] = "地怒者塔赫",
                }, -- [2]
                {
                    ["id"] = 126,
                    ["image"] = 522195,
                    ["name"] = "安拉斐特",
                }, -- [3]
                {
                    ["id"] = 127,
                    ["image"] = 522241,
                    ["name"] = "伊希斯特，魔法的造物",
                }, -- [4]
                {
                    ["id"] = 128,
                    ["image"] = 522194,
                    ["name"] = "阿穆纳伊，生命的造物",
                }, -- [5]
                {
                    ["id"] = 129,
                    ["image"] = 522267,
                    ["name"] = "塞特斯，毁灭的造物",
                }, -- [6]
                {
                    ["id"] = 130,
                    ["image"] = 522262,
                    ["name"] = "拉夏，太阳的造物",
                }, -- [7]
            },
        }, -- [19]
        {
            ["id"] = 66,
            ["image"] = 522350,
            ["name"] = "黑石岩窟",
            ["bosses"] = {
                {
                    ["id"] = 105,
                    ["image"] = 522266,
                    ["name"] = "摧骨者罗姆欧格",
                }, -- [1]
                {
                    ["id"] = 106,
                    ["image"] = 522216,
                    ["name"] = "柯尔拉，暮光之兆",
                }, -- [2]
                {
                    ["id"] = 107,
                    ["image"] = 522244,
                    ["name"] = "卡尔什·断钢",
                }, -- [3]
                {
                    ["id"] = 108,
                    ["image"] = 522207,
                    ["name"] = "如花",
                }, -- [4]
                {
                    ["id"] = 109,
                    ["image"] = 522201,
                    ["name"] = "升腾者领主奥西迪斯",
                }, -- [5]
            },
        }, -- [20]
    },
    ["经典旧世"] = {
        {
            ["id"] = 741,
            ["image"] = 1396586,
            ["name"] = "熔火之心",
            ["bosses"] = {
                {
                    ["id"] = 1519,
                    ["image"] = 1378993,
                    ["name"] = "鲁西弗隆",
                }, -- [1]
                {
                    ["id"] = 1520,
                    ["image"] = 1378995,
                    ["name"] = "玛格曼达",
                }, -- [2]
                {
                    ["id"] = 1521,
                    ["image"] = 1378976,
                    ["name"] = "基赫纳斯",
                }, -- [3]
                {
                    ["id"] = 1522,
                    ["image"] = 1378975,
                    ["name"] = "加尔",
                }, -- [4]
                {
                    ["id"] = 1523,
                    ["image"] = 1379013,
                    ["name"] = "沙斯拉尔",
                }, -- [5]
                {
                    ["id"] = 1524,
                    ["image"] = 1378966,
                    ["name"] = "迦顿男爵",
                }, -- [6]
                {
                    ["id"] = 1525,
                    ["image"] = 1379015,
                    ["name"] = "萨弗隆先驱者",
                }, -- [7]
                {
                    ["id"] = 1526,
                    ["image"] = 1378978,
                    ["name"] = "焚化者古雷曼格",
                }, -- [8]
                {
                    ["id"] = 1527,
                    ["image"] = 1378998,
                    ["name"] = "管理者埃克索图斯",
                }, -- [9]
                {
                    ["id"] = 1528,
                    ["image"] = 522261,
                    ["name"] = "拉格纳罗斯",
                }, -- [10]
            },
        }, -- [1]
        {
            ["id"] = 742,
            ["image"] = 1396580,
            ["name"] = "黑翼之巢",
            ["bosses"] = {
                {
                    ["id"] = 1529,
                    ["image"] = 1379008,
                    ["name"] = "狂野的拉佐格尔",
                }, -- [1]
                {
                    ["id"] = 1530,
                    ["image"] = 1379022,
                    ["name"] = "堕落的瓦拉斯塔兹",
                }, -- [2]
                {
                    ["id"] = 1531,
                    ["image"] = 1378968,
                    ["name"] = "勒什雷尔",
                }, -- [3]
                {
                    ["id"] = 1532,
                    ["image"] = 1378973,
                    ["name"] = "费尔默",
                }, -- [4]
                {
                    ["id"] = 1533,
                    ["image"] = 1378971,
                    ["name"] = "埃博诺克",
                }, -- [5]
                {
                    ["id"] = 1534,
                    ["image"] = 1378974,
                    ["name"] = "弗莱格尔",
                }, -- [6]
                {
                    ["id"] = 1535,
                    ["image"] = 1378969,
                    ["name"] = "克洛玛古斯",
                }, -- [7]
                {
                    ["id"] = 1536,
                    ["image"] = 1379001,
                    ["name"] = "奈法利安",
                }, -- [8]
            },
        }, -- [2]
        {
            ["id"] = 743,
            ["image"] = 1396591,
            ["name"] = "安其拉废墟",
            ["bosses"] = {
                {
                    ["id"] = 1537,
                    ["image"] = 1385749,
                    ["name"] = "库林纳克斯",
                }, -- [1]
                {
                    ["id"] = 1538,
                    ["image"] = 1385734,
                    ["name"] = "拉贾克斯将军",
                }, -- [2]
                {
                    ["id"] = 1539,
                    ["image"] = 1385755,
                    ["name"] = "莫阿姆",
                }, -- [3]
                {
                    ["id"] = 1540,
                    ["image"] = 1385723,
                    ["name"] = "吞咽者布鲁",
                }, -- [4]
                {
                    ["id"] = 1541,
                    ["image"] = 1385718,
                    ["name"] = "狩猎者阿亚米斯",
                }, -- [5]
                {
                    ["id"] = 1542,
                    ["image"] = 1385759,
                    ["name"] = "无疤者奥斯里安",
                }, -- [6]
            },
        }, -- [3]
        {
            ["id"] = 744,
            ["image"] = 1396593,
            ["name"] = "安其拉神殿",
            ["bosses"] = {
                {
                    ["id"] = 1543,
                    ["image"] = 1385769,
                    ["name"] = "预言者斯克拉姆",
                }, -- [1]
                {
                    ["id"] = 1547,
                    ["image"] = 1390436,
                    ["name"] = "安其拉三宝",
                }, -- [2]
                {
                    ["id"] = 1544,
                    ["image"] = 1385720,
                    ["name"] = "沙尔图拉",
                }, -- [3]
                {
                    ["id"] = 1545,
                    ["image"] = 1385728,
                    ["name"] = "顽强的范克瑞斯",
                }, -- [4]
                {
                    ["id"] = 1548,
                    ["image"] = 1385771,
                    ["name"] = "维希度斯",
                }, -- [5]
                {
                    ["id"] = 1546,
                    ["image"] = 1385761,
                    ["name"] = "哈霍兰公主",
                }, -- [6]
                {
                    ["id"] = 1549,
                    ["image"] = 1390437,
                    ["name"] = "双子皇帝",
                }, -- [7]
                {
                    ["id"] = 1550,
                    ["image"] = 1385760,
                    ["name"] = "奥罗",
                }, -- [8]
                {
                    ["id"] = 1551,
                    ["image"] = 1385726,
                    ["name"] = "克苏恩",
                }, -- [9]
            },
        }, -- [4]
        {
            ["id"] = 234,
            ["image"] = 608213,
            ["name"] = "剃刀沼泽",
            ["bosses"] = {
                {
                    ["id"] = 896,
                    ["image"] = 607531,
                    ["name"] = "猎手布塔斯克",
                }, -- [1]
                {
                    ["id"] = 895,
                    ["image"] = 607760,
                    ["name"] = "鲁古格",
                }, -- [2]
                {
                    ["id"] = 899,
                    ["image"] = 607736,
                    ["name"] = "督军拉姆塔斯",
                }, -- [3]
                {
                    ["id"] = 900,
                    ["image"] = 1064175,
                    ["name"] = "盲眼猎手格罗亚特",
                }, -- [4]
                {
                    ["id"] = 901,
                    ["image"] = 607563,
                    ["name"] = "卡尔加·刺肋",
                }, -- [5]
            },
        }, -- [5]
        {
            ["id"] = 233,
            ["image"] = 608212,
            ["name"] = "剃刀高地",
            ["bosses"] = {
                {
                    ["id"] = 1142,
                    ["image"] = 607633,
                    ["name"] = "阿鲁克斯",
                }, -- [1]
                {
                    ["id"] = 433,
                    ["image"] = 607718,
                    ["name"] = "火眼莫德雷斯",
                }, -- [2]
                {
                    ["id"] = 1143,
                    ["image"] = 1064178,
                    ["name"] = "麦什伦",
                }, -- [3]
                {
                    ["id"] = 1146,
                    ["image"] = 607584,
                    ["name"] = "亡语者布莱克松",
                }, -- [4]
                {
                    ["id"] = 1141,
                    ["image"] = 607537,
                    ["name"] = "寒冰之王亚门纳尔",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 230,
            ["image"] = 608200,
            ["name"] = "厄运之槌",
            ["bosses"] = {
                {
                    ["id"] = 402,
                    ["image"] = 607824,
                    ["name"] = "瑟雷姆·刺蹄",
                }, -- [1]
                {
                    ["id"] = 403,
                    ["image"] = 607653,
                    ["name"] = "海多斯博恩",
                }, -- [2]
                {
                    ["id"] = 404,
                    ["image"] = 607686,
                    ["name"] = "蕾瑟塔蒂丝",
                }, -- [3]
                {
                    ["id"] = 405,
                    ["image"] = 607533,
                    ["name"] = "荒野变形者奥兹恩",
                }, -- [4]
                {
                    ["id"] = 406,
                    ["image"] = 607785,
                    ["name"] = "特迪斯·扭木",
                }, -- [5]
                {
                    ["id"] = 407,
                    ["image"] = 607656,
                    ["name"] = "伊琳娜·暗木",
                }, -- [6]
                {
                    ["id"] = 408,
                    ["image"] = 607703,
                    ["name"] = "卡雷迪斯镇长",
                }, -- [7]
                {
                    ["id"] = 409,
                    ["image"] = 607657,
                    ["name"] = "伊莫塔尔",
                }, -- [8]
                {
                    ["id"] = 410,
                    ["image"] = 607745,
                    ["name"] = "托塞德林王子",
                }, -- [9]
                {
                    ["id"] = 411,
                    ["image"] = 607630,
                    ["name"] = "卫兵摩尔达",
                }, -- [10]
                {
                    ["id"] = 412,
                    ["image"] = 607777,
                    ["name"] = "践踏者克雷格",
                }, -- [11]
                {
                    ["id"] = 413,
                    ["image"] = 607629,
                    ["name"] = "卫兵芬古斯",
                }, -- [12]
                {
                    ["id"] = 414,
                    ["image"] = 607631,
                    ["name"] = "卫兵斯里基克",
                }, -- [13]
                {
                    ["id"] = 415,
                    ["image"] = 607560,
                    ["name"] = "克罗卡斯",
                }, -- [14]
                {
                    ["id"] = 416,
                    ["image"] = 607565,
                    ["name"] = "观察者克鲁什",
                }, -- [15]
                {
                    ["id"] = 417,
                    ["image"] = 607673,
                    ["name"] = "戈多克大王",
                }, -- [16]
            },
        }, -- [7]
        {
            ["id"] = 240,
            ["image"] = 608229,
            ["name"] = "哀嚎洞穴",
            ["bosses"] = {
                {
                    ["id"] = 474,
                    ["image"] = 607680,
                    ["name"] = "安娜科德拉",
                }, -- [1]
                {
                    ["id"] = 476,
                    ["image"] = 607696,
                    ["name"] = "皮萨斯",
                }, -- [2]
                {
                    ["id"] = 475,
                    ["image"] = 607693,
                    ["name"] = "考布莱恩",
                }, -- [3]
                {
                    ["id"] = 477,
                    ["image"] = 607676,
                    ["name"] = "克雷什",
                }, -- [4]
                {
                    ["id"] = 478,
                    ["image"] = 607775,
                    ["name"] = "斯卡姆",
                }, -- [5]
                {
                    ["id"] = 479,
                    ["image"] = 607698,
                    ["name"] = "瑟芬迪斯",
                }, -- [6]
                {
                    ["id"] = 480,
                    ["image"] = 607805,
                    ["name"] = "永生者沃尔丹",
                }, -- [7]
                {
                    ["id"] = 481,
                    ["image"] = 607721,
                    ["name"] = "吞噬者穆坦努斯",
                }, -- [8]
            },
        }, -- [8]
        {
            ["id"] = 239,
            ["image"] = 608225,
            ["name"] = "奥达曼",
            ["bosses"] = {
                {
                    ["id"] = 467,
                    ["image"] = 607757,
                    ["name"] = "鲁维罗什",
                }, -- [1]
                {
                    ["id"] = 468,
                    ["image"] = 607550,
                    ["name"] = "失踪的矮人",
                }, -- [2]
                {
                    ["id"] = 469,
                    ["image"] = 607664,
                    ["name"] = "艾隆纳亚",
                }, -- [3]
                {
                    ["id"] = 748,
                    ["image"] = 607729,
                    ["name"] = "黑曜石哨兵",
                }, -- [4]
                {
                    ["id"] = 470,
                    ["image"] = 607538,
                    ["name"] = "远古巨石卫士",
                }, -- [5]
                {
                    ["id"] = 471,
                    ["image"] = 607606,
                    ["name"] = "加加恩·火锤",
                }, -- [6]
                {
                    ["id"] = 472,
                    ["image"] = 607626,
                    ["name"] = "格瑞姆洛克",
                }, -- [7]
                {
                    ["id"] = 473,
                    ["image"] = 607546,
                    ["name"] = "阿扎达斯",
                }, -- [8]
            },
        }, -- [9]
        {
            ["id"] = 64,
            ["image"] = 522358,
            ["name"] = "影牙城堡",
            ["bosses"] = {
                {
                    ["id"] = 96,
                    ["image"] = 522205,
                    ["name"] = "灰葬男爵",
                }, -- [1]
                {
                    ["id"] = 97,
                    ["image"] = 522206,
                    ["name"] = "席瓦莱恩男爵",
                }, -- [2]
                {
                    ["id"] = 98,
                    ["image"] = 522213,
                    ["name"] = "指挥官斯普林瓦尔",
                }, -- [3]
                {
                    ["id"] = 99,
                    ["image"] = 522249,
                    ["name"] = "沃登勋爵",
                }, -- [4]
                {
                    ["id"] = 100,
                    ["image"] = 522247,
                    ["name"] = "高弗雷勋爵",
                }, -- [5]
            },
        }, -- [10]
        {
            ["id"] = 226,
            ["image"] = 608211,
            ["name"] = "怒焰裂谷",
            ["bosses"] = {
                {
                    ["id"] = 694,
                    ["image"] = 608309,
                    ["name"] = "阿达罗格",
                }, -- [1]
                {
                    ["id"] = 695,
                    ["image"] = 608310,
                    ["name"] = "黑暗萨满柯兰萨",
                }, -- [2]
                {
                    ["id"] = 696,
                    ["image"] = 522251,
                    ["name"] = "焰喉",
                }, -- [3]
                {
                    ["id"] = 697,
                    ["image"] = 608315,
                    ["name"] = "熔岩守卫戈多斯",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 236,
            ["image"] = 608216,
            ["name"] = "斯坦索姆",
            ["bosses"] = {
                {
                    ["id"] = 443,
                    ["image"] = 607637,
                    ["name"] = "弗雷斯特恩",
                }, -- [1]
                {
                    ["id"] = 445,
                    ["image"] = 607795,
                    ["name"] = "悲惨的提米",
                }, -- [2]
                {
                    ["id"] = 749,
                    ["image"] = 607569,
                    ["name"] = "指挥官玛洛尔",
                }, -- [3]
                {
                    ["id"] = 446,
                    ["image"] = 607818,
                    ["name"] = "希望破坏者威利",
                }, -- [4]
                {
                    ["id"] = 448,
                    ["image"] = 607660,
                    ["name"] = "档案管理员加尔福特",
                }, -- [5]
                {
                    ["id"] = 449,
                    ["image"] = 607551,
                    ["name"] = "巴纳扎尔",
                }, -- [6]
                {
                    ["id"] = 450,
                    ["image"] = 607792,
                    ["name"] = "不可宽恕者",
                }, -- [7]
                {
                    ["id"] = 451,
                    ["image"] = 607553,
                    ["name"] = "安娜丝塔丽男爵夫人",
                }, -- [8]
                {
                    ["id"] = 452,
                    ["image"] = 607724,
                    ["name"] = "奈鲁布恩坎",
                }, -- [9]
                {
                    ["id"] = 453,
                    ["image"] = 607707,
                    ["name"] = "苍白的玛勒基",
                }, -- [10]
                {
                    ["id"] = 454,
                    ["image"] = 607791,
                    ["name"] = "巴瑟拉斯镇长",
                }, -- [11]
                {
                    ["id"] = 455,
                    ["image"] = 607752,
                    ["name"] = "吞咽者拉姆斯登",
                }, -- [12]
                {
                    ["id"] = 456,
                    ["image"] = 607692,
                    ["name"] = "奥里克斯·瑞文戴尔领主",
                }, -- [13]
            },
        }, -- [12]
        {
            ["id"] = 63,
            ["image"] = 522352,
            ["name"] = "死亡矿井",
            ["bosses"] = {
                {
                    ["id"] = 89,
                    ["image"] = 522228,
                    ["name"] = "格拉布托克",
                }, -- [1]
                {
                    ["id"] = 90,
                    ["image"] = 522234,
                    ["name"] = "赫利克斯·破甲",
                }, -- [2]
                {
                    ["id"] = 91,
                    ["image"] = 522225,
                    ["name"] = "死神5000",
                }, -- [3]
                {
                    ["id"] = 92,
                    ["image"] = 522189,
                    ["name"] = "撕心狼将军",
                }, -- [4]
                {
                    ["id"] = 93,
                    ["image"] = 522210,
                    ["name"] = "“船长”曲奇",
                }, -- [5]
            },
        }, -- [13]
        {
            ["id"] = 232,
            ["image"] = 608209,
            ["name"] = "玛拉顿",
            ["bosses"] = {
                {
                    ["id"] = 423,
                    ["image"] = 607728,
                    ["name"] = "诺克赛恩",
                }, -- [1]
                {
                    ["id"] = 424,
                    ["image"] = 607756,
                    ["name"] = "锐刺鞭笞者",
                }, -- [2]
                {
                    ["id"] = 425,
                    ["image"] = 607796,
                    ["name"] = "工匠吉兹洛克",
                }, -- [3]
                {
                    ["id"] = 427,
                    ["image"] = 607699,
                    ["name"] = "维利塔恩",
                }, -- [4]
                {
                    ["id"] = 428,
                    ["image"] = 607562,
                    ["name"] = "被诅咒的塞雷布拉斯",
                }, -- [5]
                {
                    ["id"] = 429,
                    ["image"] = 607684,
                    ["name"] = "兰斯利德",
                }, -- [6]
                {
                    ["id"] = 430,
                    ["image"] = 607761,
                    ["name"] = "洛特格里普",
                }, -- [7]
                {
                    ["id"] = 431,
                    ["image"] = 607747,
                    ["name"] = "瑟莱德丝公主",
                }, -- [8]
            },
        }, -- [14]
        {
            ["id"] = 238,
            ["image"] = 608223,
            ["name"] = "监狱",
            ["bosses"] = {
                {
                    ["id"] = 464,
                    ["image"] = 607646,
                    ["name"] = "霍格",
                }, -- [1]
                {
                    ["id"] = 465,
                    ["image"] = 607695,
                    ["name"] = "灼热勋爵",
                }, -- [2]
                {
                    ["id"] = 466,
                    ["image"] = 607753,
                    ["name"] = "兰多菲·摩洛克",
                }, -- [3]
            },
        }, -- [15]
        {
            ["id"] = 241,
            ["image"] = 608230,
            ["name"] = "祖尔法拉克",
            ["bosses"] = {
                {
                    ["id"] = 483,
                    ["image"] = 607614,
                    ["name"] = "加兹瑞拉",
                }, -- [1]
                {
                    ["id"] = 484,
                    ["image"] = 607541,
                    ["name"] = "安图苏尔",
                }, -- [2]
                {
                    ["id"] = 485,
                    ["image"] = 607793,
                    ["name"] = "殉教者塞卡",
                }, -- [3]
                {
                    ["id"] = 486,
                    ["image"] = 607819,
                    ["name"] = "巫医祖穆拉恩",
                }, -- [4]
                {
                    ["id"] = 487,
                    ["image"] = 607723,
                    ["name"] = "耐克鲁姆和塞瑟斯",
                }, -- [5]
                {
                    ["id"] = 489,
                    ["image"] = 607564,
                    ["name"] = "乌克兹·沙顶",
                }, -- [6]
            },
        }, -- [16]
        {
            ["id"] = 316,
            ["image"] = 608214,
            ["name"] = "血色修道院",
            ["bosses"] = {
                {
                    ["id"] = 688,
                    ["image"] = 630853,
                    ["name"] = "裂魂者萨尔诺斯",
                }, -- [1]
                {
                    ["id"] = 671,
                    ["image"] = 630818,
                    ["name"] = "科洛夫修士",
                }, -- [2]
                {
                    ["id"] = 674,
                    ["image"] = 607643,
                    ["name"] = "大检察官怀特迈恩",
                }, -- [3]
            },
        }, -- [17]
        {
            ["id"] = 311,
            ["image"] = 643262,
            ["name"] = "血色大厅",
            ["bosses"] = {
                {
                    ["id"] = 660,
                    ["image"] = 630833,
                    ["name"] = "驯犬者布兰恩",
                }, -- [1]
                {
                    ["id"] = 654,
                    ["image"] = 630816,
                    ["name"] = "武器大师哈兰",
                }, -- [2]
                {
                    ["id"] = 656,
                    ["image"] = 630825,
                    ["name"] = "织焰者孔格勒",
                }, -- [3]
            },
        }, -- [18]
        {
            ["id"] = 231,
            ["image"] = 608202,
            ["name"] = "诺莫瑞根",
            ["bosses"] = {
                {
                    ["id"] = 419,
                    ["image"] = 607628,
                    ["name"] = "格鲁比斯",
                }, -- [1]
                {
                    ["id"] = 420,
                    ["image"] = 607808,
                    ["name"] = "粘性辐射尘",
                }, -- [2]
                {
                    ["id"] = 421,
                    ["image"] = 607594,
                    ["name"] = "电刑器6000型",
                }, -- [3]
                {
                    ["id"] = 418,
                    ["image"] = 607572,
                    ["name"] = "群体打击者9-60",
                }, -- [4]
                {
                    ["id"] = 422,
                    ["image"] = 607714,
                    ["name"] = "机械师瑟玛普拉格",
                }, -- [5]
            },
        }, -- [19]
        {
            ["id"] = 246,
            ["image"] = 608215,
            ["name"] = "通灵学院",
            ["bosses"] = {
                {
                    ["id"] = 659,
                    ["image"] = 630835,
                    ["name"] = "指导者寒心",
                }, -- [1]
                {
                    ["id"] = 663,
                    ["image"] = 607666,
                    ["name"] = "詹迪斯·巴罗夫",
                }, -- [2]
                {
                    ["id"] = 665,
                    ["image"] = 607755,
                    ["name"] = "血骨傀儡",
                }, -- [3]
                {
                    ["id"] = 666,
                    ["image"] = 630838,
                    ["name"] = "莉莉安·沃斯",
                }, -- [4]
                {
                    ["id"] = 684,
                    ["image"] = 607582,
                    ["name"] = "黑暗院长加丁",
                }, -- [5]
            },
        }, -- [20]
        {
            ["id"] = 237,
            ["image"] = 608217,
            ["name"] = "阿塔哈卡神庙",
            ["bosses"] = {
                {
                    ["id"] = 457,
                    ["image"] = 607548,
                    ["name"] = "哈卡的化身",
                }, -- [1]
                {
                    ["id"] = 458,
                    ["image"] = 607665,
                    ["name"] = "预言者迦玛兰",
                }, -- [2]
                {
                    ["id"] = 459,
                    ["image"] = 608311,
                    ["name"] = "梦境守望者",
                }, -- [3]
                {
                    ["id"] = 463,
                    ["image"] = 607768,
                    ["name"] = "伊兰尼库斯的阴影",
                }, -- [4]
            },
        }, -- [21]
        {
            ["id"] = 227,
            ["image"] = 608195,
            ["name"] = "黑暗深渊",
            ["bosses"] = {
                {
                    ["id"] = 368,
                    ["image"] = 1064179,
                    ["name"] = "加摩拉",
                }, -- [1]
                {
                    ["id"] = 436,
                    ["image"] = 1064180,
                    ["name"] = "多米尼娜",
                }, -- [2]
                {
                    ["id"] = 426,
                    ["image"] = 522214,
                    ["name"] = "征服者克鲁尔",
                }, -- [3]
                {
                    ["id"] = 1145,
                    ["image"] = 1064181,
                    ["name"] = "苏克",
                }, -- [4]
                {
                    ["id"] = 447,
                    ["image"] = 1064182,
                    ["name"] = "深渊守护者",
                }, -- [5]
                {
                    ["id"] = 1144,
                    ["image"] = 1064183,
                    ["name"] = "刽子手戈尔",
                }, -- [6]
                {
                    ["id"] = 437,
                    ["image"] = 1064184,
                    ["name"] = "暮光领主巴赛尔",
                }, -- [7]
                {
                    ["id"] = 444,
                    ["image"] = 607532,
                    ["name"] = "阿库麦尔",
                }, -- [8]
            },
        }, -- [22]
        {
            ["id"] = 229,
            ["image"] = 608197,
            ["name"] = "黑石塔下层",
            ["bosses"] = {
                {
                    ["id"] = 388,
                    ["image"] = 607645,
                    ["name"] = "欧莫克大王",
                }, -- [1]
                {
                    ["id"] = 389,
                    ["image"] = 607769,
                    ["name"] = "暗影猎手沃什加斯",
                }, -- [2]
                {
                    ["id"] = 390,
                    ["image"] = 607810,
                    ["name"] = "指挥官沃恩",
                }, -- [3]
                {
                    ["id"] = 391,
                    ["image"] = 607719,
                    ["name"] = "烟网蛛后",
                }, -- [4]
                {
                    ["id"] = 392,
                    ["image"] = 607801,
                    ["name"] = "尤洛克·暗嚎",
                }, -- [5]
                {
                    ["id"] = 393,
                    ["image"] = 607751,
                    ["name"] = "军需官兹格雷斯",
                }, -- [6]
                {
                    ["id"] = 394,
                    ["image"] = 607634,
                    ["name"] = "哈雷肯",
                }, -- [7]
                {
                    ["id"] = 395,
                    ["image"] = 607615,
                    ["name"] = "奴役者基兹鲁尔",
                }, -- [8]
                {
                    ["id"] = 396,
                    ["image"] = 607737,
                    ["name"] = "维姆萨拉克",
                }, -- [9]
            },
        }, -- [23]
        {
            ["id"] = 228,
            ["image"] = 608196,
            ["name"] = "黑石深渊",
            ["bosses"] = {
                {
                    ["id"] = 369,
                    ["image"] = 607644,
                    ["name"] = "审讯官格斯塔恩",
                }, -- [1]
                {
                    ["id"] = 370,
                    ["image"] = 607697,
                    ["name"] = "洛考尔",
                }, -- [2]
                {
                    ["id"] = 371,
                    ["image"] = 607647,
                    ["name"] = "驯犬者格雷布玛尔",
                }, -- [3]
                {
                    ["id"] = 372,
                    ["image"] = 608314,
                    ["name"] = "秩序竞技场",
                }, -- [4]
                {
                    ["id"] = 373,
                    ["image"] = 607749,
                    ["name"] = "控火师罗格雷恩",
                }, -- [5]
                {
                    ["id"] = 374,
                    ["image"] = 607694,
                    ["name"] = "伊森迪奥斯",
                }, -- [6]
                {
                    ["id"] = 375,
                    ["image"] = 607814,
                    ["name"] = "典狱官斯迪尔基斯",
                }, -- [7]
                {
                    ["id"] = 376,
                    ["image"] = 607602,
                    ["name"] = "弗诺斯·达克维尔",
                }, -- [8]
                {
                    ["id"] = 377,
                    ["image"] = 607549,
                    ["name"] = "贝尔加",
                }, -- [9]
                {
                    ["id"] = 378,
                    ["image"] = 607610,
                    ["name"] = "怒炉将军",
                }, -- [10]
                {
                    ["id"] = 379,
                    ["image"] = 607618,
                    ["name"] = "傀儡统帅阿格曼奇",
                }, -- [11]
                {
                    ["id"] = 380,
                    ["image"] = 607650,
                    ["name"] = "霍尔雷·黑须",
                }, -- [12]
                {
                    ["id"] = 381,
                    ["image"] = 607740,
                    ["name"] = "法拉克斯",
                }, -- [13]
                {
                    ["id"] = 383,
                    ["image"] = 607741,
                    ["name"] = "普拉格",
                }, -- [14]
                {
                    ["id"] = 384,
                    ["image"] = 607535,
                    ["name"] = "弗莱拉斯总大使",
                }, -- [15]
                {
                    ["id"] = 385,
                    ["image"] = 607587,
                    ["name"] = "黑铁七贤",
                }, -- [16]
                {
                    ["id"] = 386,
                    ["image"] = 607705,
                    ["name"] = "玛格姆斯",
                }, -- [17]
                {
                    ["id"] = 387,
                    ["image"] = 607595,
                    ["name"] = "达格兰·索瑞森大帝",
                }, -- [18]
            },
        }, -- [24]
    },
    ["争霸艾泽拉斯"] = {
        {
            ["id"] = 1028,
            ["image"] = 2178279,
            ["name"] = "艾泽拉斯",
            ["bosses"] = {
                {
                    ["id"] = 2378,
                    ["image"] = 3284400,
                    ["name"] = "大女皇夏柯扎拉",
                }, -- [1]
                {
                    ["id"] = 2381,
                    ["image"] = 3284401,
                    ["name"] = "碎地者弗克拉兹",
                }, -- [2]
                {
                    ["id"] = 2363,
                    ["image"] = 3012063,
                    ["name"] = "维科玛拉",
                }, -- [3]
                {
                    ["id"] = 2362,
                    ["image"] = 3012061,
                    ["name"] = "奥玛斯，缚魂者",
                }, -- [4]
                {
                    ["id"] = 2329,
                    ["image"] = 2497782,
                    ["name"] = "森林之王伊弗斯",
                }, -- [5]
                {
                    ["id"] = 2212,
                    ["image"] = 2176752,
                    ["name"] = "雄狮之吼",
                }, -- [6]
                {
                    ["id"] = 2139,
                    ["image"] = 2176755,
                    ["name"] = "提赞",
                }, -- [7]
                {
                    ["id"] = 2141,
                    ["image"] = 2176734,
                    ["name"] = "基阿拉克",
                }, -- [8]
                {
                    ["id"] = 2197,
                    ["image"] = 2176731,
                    ["name"] = "冰雹构造体",
                }, -- [9]
                {
                    ["id"] = 2198,
                    ["image"] = 2176760,
                    ["name"] = "战争使者耶纳基兹",
                }, -- [10]
                {
                    ["id"] = 2199,
                    ["image"] = 2176716,
                    ["name"] = "蔚索斯，飞翼台风",
                }, -- [11]
                {
                    ["id"] = 2210,
                    ["image"] = 2176723,
                    ["name"] = "食沙者克劳洛克",
                }, -- [12]
            },
        }, -- [1]
        {
            ["id"] = 1031,
            ["image"] = 2178277,
            ["name"] = "奥迪尔",
            ["bosses"] = {
                {
                    ["id"] = 2168,
                    ["image"] = 2176749,
                    ["name"] = "塔罗克",
                }, -- [1]
                {
                    ["id"] = 2167,
                    ["image"] = 2176741,
                    ["name"] = "纯净圣母",
                }, -- [2]
                {
                    ["id"] = 2146,
                    ["image"] = 2176725,
                    ["name"] = "腐臭吞噬者",
                }, -- [3]
                {
                    ["id"] = 2169,
                    ["image"] = 2176761,
                    ["name"] = "泽克沃兹，恩佐斯的传令官",
                }, -- [4]
                {
                    ["id"] = 2166,
                    ["image"] = 2176757,
                    ["name"] = "维克提斯",
                }, -- [5]
                {
                    ["id"] = 2195,
                    ["image"] = 2176762,
                    ["name"] = "重生者祖尔",
                }, -- [6]
                {
                    ["id"] = 2194,
                    ["image"] = 2176742,
                    ["name"] = "拆解者米斯拉克斯",
                }, -- [7]
                {
                    ["id"] = 2147,
                    ["image"] = 2176728,
                    ["name"] = "戈霍恩",
                }, -- [8]
            },
        }, -- [2]
        {
            ["id"] = 1176,
            ["image"] = 2482729,
            ["name"] = "达萨罗之战",
            ["bosses"] = {
                {
                    ["id"] = 2333,
                    ["image"] = 2497778,
                    ["name"] = "圣光勇士",
                }, -- [1]
                {
                    ["id"] = 2325,
                    ["image"] = 2497783,
                    ["name"] = "丛林之王格洛恩",
                }, -- [2]
                {
                    ["id"] = 2341,
                    ["image"] = 2529383,
                    ["name"] = "玉火大师",
                }, -- [3]
                {
                    ["id"] = 2342,
                    ["image"] = 2497790,
                    ["name"] = "丰灵",
                }, -- [4]
                {
                    ["id"] = 2330,
                    ["image"] = 2497779,
                    ["name"] = "神选者教团",
                }, -- [5]
                {
                    ["id"] = 2335,
                    ["image"] = 2497784,
                    ["name"] = "拉斯塔哈大王",
                }, -- [6]
                {
                    ["id"] = 2334,
                    ["image"] = 2497788,
                    ["name"] = "大工匠梅卡托克",
                }, -- [7]
                {
                    ["id"] = 2337,
                    ["image"] = 2497786,
                    ["name"] = "风暴之墙阻击战",
                }, -- [8]
                {
                    ["id"] = 2343,
                    ["image"] = 2497785,
                    ["name"] = "吉安娜·普罗德摩尔",
                }, -- [9]
            },
        }, -- [3]
        {
            ["id"] = 1177,
            ["image"] = 2498193,
            ["name"] = "风暴熔炉",
            ["bosses"] = {
                {
                    ["id"] = 2328,
                    ["image"] = 2497795,
                    ["name"] = "无眠秘党",
                }, -- [1]
                {
                    ["id"] = 2332,
                    ["image"] = 2497794,
                    ["name"] = "乌纳特，虚空先驱",
                }, -- [2]
            },
        }, -- [4]
        {
            ["id"] = 1179,
            ["image"] = 3025320,
            ["name"] = "永恒王宫",
            ["bosses"] = {
                {
                    ["id"] = 2352,
                    ["image"] = 3012047,
                    ["name"] = "深渊指挥官西瓦拉",
                }, -- [1]
                {
                    ["id"] = 2347,
                    ["image"] = 3012062,
                    ["name"] = "黑水巨鳗",
                }, -- [2]
                {
                    ["id"] = 2353,
                    ["image"] = 3012058,
                    ["name"] = "艾萨拉之辉",
                }, -- [3]
                {
                    ["id"] = 2354,
                    ["image"] = 3012055,
                    ["name"] = "艾什凡女勋爵",
                }, -- [4]
                {
                    ["id"] = 2351,
                    ["image"] = 3012054,
                    ["name"] = "奥戈佐亚",
                }, -- [5]
                {
                    ["id"] = 2359,
                    ["image"] = 3012057,
                    ["name"] = "女王法庭",
                }, -- [6]
                {
                    ["id"] = 2349,
                    ["image"] = 3012064,
                    ["name"] = "扎库尔，尼奥罗萨先驱",
                }, -- [7]
                {
                    ["id"] = 2361,
                    ["image"] = 3012056,
                    ["name"] = "艾萨拉女王",
                }, -- [8]
            },
        }, -- [5]
        {
            ["id"] = 1180,
            ["image"] = 3221463,
            ["name"] = "尼奥罗萨，觉醒之城",
            ["bosses"] = {
                {
                    ["id"] = 2368,
                    ["image"] = 3256385,
                    ["name"] = "黑龙帝王拉希奥",
                }, -- [1]
                {
                    ["id"] = 2365,
                    ["image"] = 3256380,
                    ["name"] = "玛乌特",
                }, -- [2]
                {
                    ["id"] = 2369,
                    ["image"] = 3256384,
                    ["name"] = "先知斯基特拉",
                }, -- [3]
                {
                    ["id"] = 2377,
                    ["image"] = 3256386,
                    ["name"] = "黑暗审判官夏奈什",
                }, -- [4]
                {
                    ["id"] = 2372,
                    ["image"] = 3256378,
                    ["name"] = "主脑",
                }, -- [5]
                {
                    ["id"] = 2367,
                    ["image"] = 3256383,
                    ["name"] = "无厌者夏德哈",
                }, -- [6]
                {
                    ["id"] = 2373,
                    ["image"] = 3256377,
                    ["name"] = "德雷阿佳丝",
                }, -- [7]
                {
                    ["id"] = 2374,
                    ["image"] = 3256379,
                    ["name"] = "伊格诺斯，重生之蚀",
                }, -- [8]
                {
                    ["id"] = 2370,
                    ["image"] = 3257677,
                    ["name"] = "维克修娜",
                }, -- [9]
                {
                    ["id"] = 2364,
                    ["image"] = 3256382,
                    ["name"] = "虚无者莱登",
                }, -- [10]
                {
                    ["id"] = 2366,
                    ["image"] = 3256376,
                    ["name"] = "恩佐斯的外壳",
                }, -- [11]
                {
                    ["id"] = 2375,
                    ["image"] = 3256381,
                    ["name"] = "腐蚀者恩佐斯",
                }, -- [12]
            },
        }, -- [6]
        {
            ["id"] = 1023,
            ["image"] = 2178272,
            ["name"] = "围攻伯拉勒斯",
            ["bosses"] = {
                {
                    ["id"] = 2133,
                    ["image"] = 2176746,
                    ["name"] = "拜恩比吉中士",
                }, -- [1]
                {
                    ["id"] = 2173,
                    ["image"] = 2176722,
                    ["name"] = "恐怖船长洛克伍德",
                }, -- [2]
                {
                    ["id"] = 2134,
                    ["image"] = 2176730,
                    ["name"] = "哈达尔·黑渊",
                }, -- [3]
                {
                    ["id"] = 2140,
                    ["image"] = 2176758,
                    ["name"] = "维克戈斯",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 1022,
            ["image"] = 2178275,
            ["name"] = "地渊孢林",
            ["bosses"] = {
                {
                    ["id"] = 2157,
                    ["image"] = 2176724,
                    ["name"] = "长者莉娅克萨",
                }, -- [1]
                {
                    ["id"] = 2131,
                    ["image"] = 2176719,
                    ["name"] = "被感染的岩喉",
                }, -- [2]
                {
                    ["id"] = 2130,
                    ["image"] = 2176748,
                    ["name"] = "孢子召唤师赞查",
                }, -- [3]
                {
                    ["id"] = 2158,
                    ["image"] = 2176756,
                    ["name"] = "不羁畸变怪",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 1030,
            ["image"] = 2178273,
            ["name"] = "塞塔里斯神庙",
            ["bosses"] = {
                {
                    ["id"] = 2142,
                    ["image"] = 2176710,
                    ["name"] = "阿德里斯和阿斯匹克斯",
                }, -- [1]
                {
                    ["id"] = 2143,
                    ["image"] = 2176739,
                    ["name"] = "米利克萨",
                }, -- [2]
                {
                    ["id"] = 2144,
                    ["image"] = 2176727,
                    ["name"] = "加瓦兹特",
                }, -- [3]
                {
                    ["id"] = 2145,
                    ["image"] = 2176713,
                    ["name"] = "塞塔里斯的化身",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 1002,
            ["image"] = 2178276,
            ["name"] = "托尔达戈",
            ["bosses"] = {
                {
                    ["id"] = 2097,
                    ["image"] = 2176753,
                    ["name"] = "泥沙女王",
                }, -- [1]
                {
                    ["id"] = 2098,
                    ["image"] = 2176733,
                    ["name"] = "杰斯·豪里斯",
                }, -- [2]
                {
                    ["id"] = 2099,
                    ["image"] = 2176735,
                    ["name"] = "骑士队长瓦莱莉",
                }, -- [3]
                {
                    ["id"] = 2096,
                    ["image"] = 2176743,
                    ["name"] = "科古斯狱长",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 1012,
            ["image"] = 2178274,
            ["name"] = "暴富矿区！！",
            ["bosses"] = {
                {
                    ["id"] = 2109,
                    ["image"] = 2176718,
                    ["name"] = "投币式群体打击者",
                }, -- [1]
                {
                    ["id"] = 2114,
                    ["image"] = 2176714,
                    ["name"] = "艾泽洛克",
                }, -- [2]
                {
                    ["id"] = 2115,
                    ["image"] = 2176745,
                    ["name"] = "瑞克莎·流火",
                }, -- [3]
                {
                    ["id"] = 2116,
                    ["image"] = 2176740,
                    ["name"] = "商业大亨拉兹敦克",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 1021,
            ["image"] = 2178278,
            ["name"] = "维克雷斯庄园",
            ["bosses"] = {
                {
                    ["id"] = 2125,
                    ["image"] = 2176732,
                    ["name"] = "毒心三姝",
                }, -- [1]
                {
                    ["id"] = 2126,
                    ["image"] = 2176747,
                    ["name"] = "魂缚巨像",
                }, -- [2]
                {
                    ["id"] = 2127,
                    ["image"] = 2176744,
                    ["name"] = "贪食的拉尔",
                }, -- [3]
                {
                    ["id"] = 2128,
                    ["image"] = 2176736,
                    ["name"] = "维克雷斯勋爵和夫人",
                }, -- [4]
                {
                    ["id"] = 2129,
                    ["image"] = 2176729,
                    ["name"] = "高莱克·图尔",
                }, -- [5]
            },
        }, -- [12]
        {
            ["id"] = 1001,
            ["image"] = 1778893,
            ["name"] = "自由镇",
            ["bosses"] = {
                {
                    ["id"] = 2102,
                    ["image"] = 1778351,
                    ["name"] = "天空上尉库拉格",
                }, -- [1]
                {
                    ["id"] = 2093,
                    ["image"] = 1778346,
                    ["name"] = "海盗议会",
                }, -- [2]
                {
                    ["id"] = 2094,
                    ["image"] = 1778350,
                    ["name"] = "藏宝竞技场",
                }, -- [3]
                {
                    ["id"] = 2095,
                    ["image"] = 1778347,
                    ["name"] = "哈兰·斯威提",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 1041,
            ["image"] = 2178269,
            ["name"] = "诸王之眠",
            ["bosses"] = {
                {
                    ["id"] = 2165,
                    ["image"] = 2176751,
                    ["name"] = "黄金风蛇",
                }, -- [1]
                {
                    ["id"] = 2171,
                    ["image"] = 2176738,
                    ["name"] = "殓尸者姆沁巴",
                }, -- [2]
                {
                    ["id"] = 2170,
                    ["image"] = 2176750,
                    ["name"] = "部族议会",
                }, -- [3]
                {
                    ["id"] = 2172,
                    ["image"] = 2176720,
                    ["name"] = "始皇达萨",
                }, -- [4]
            },
        }, -- [14]
        {
            ["id"] = 968,
            ["image"] = 1778892,
            ["name"] = "阿塔达萨",
            ["bosses"] = {
                {
                    ["id"] = 2082,
                    ["image"] = 1778348,
                    ["name"] = "女祭司阿伦扎",
                }, -- [1]
                {
                    ["id"] = 2036,
                    ["image"] = 1778352,
                    ["name"] = "沃卡尔",
                }, -- [2]
                {
                    ["id"] = 2083,
                    ["image"] = 1778349,
                    ["name"] = "莱赞",
                }, -- [3]
                {
                    ["id"] = 2030,
                    ["image"] = 1778353,
                    ["name"] = "亚兹玛",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 1036,
            ["image"] = 2178271,
            ["name"] = "风暴神殿",
            ["bosses"] = {
                {
                    ["id"] = 2153,
                    ["image"] = 2176712,
                    ["name"] = "阿库希尔",
                }, -- [1]
                {
                    ["id"] = 2154,
                    ["image"] = 2176754,
                    ["name"] = "海贤议会",
                }, -- [2]
                {
                    ["id"] = 2155,
                    ["image"] = 2176737,
                    ["name"] = "斯托颂勋爵",
                }, -- [3]
                {
                    ["id"] = 2156,
                    ["image"] = 2176759,
                    ["name"] = "低语者沃尔兹斯",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 1178,
            ["image"] = 3025325,
            ["name"] = "麦卡贡行动",
            ["bosses"] = {
                {
                    ["id"] = 2357,
                    ["image"] = 3012050,
                    ["name"] = "戈巴马克国王",
                }, -- [1]
                {
                    ["id"] = 2358,
                    ["image"] = 3012048,
                    ["name"] = "冈克",
                }, -- [2]
                {
                    ["id"] = 2360,
                    ["image"] = 3012059,
                    ["name"] = "崔克茜和耐诺",
                }, -- [3]
                {
                    ["id"] = 2355,
                    ["image"] = 3012049,
                    ["name"] = "HK-8型空中压制单位",
                }, -- [4]
                {
                    ["id"] = 2336,
                    ["image"] = 3012060,
                    ["name"] = "坦克大战",
                }, -- [5]
                {
                    ["id"] = 2339,
                    ["image"] = 3012052,
                    ["name"] = "狂犬K.U.-J.0.",
                }, -- [6]
                {
                    ["id"] = 2348,
                    ["image"] = 3012053,
                    ["name"] = "机械师的花园",
                }, -- [7]
                {
                    ["id"] = 2331,
                    ["image"] = 3012051,
                    ["name"] = "麦卡贡国王",
                }, -- [8]
            },
        }, -- [17]
    },
    ["军团再临"] = {
        {
            ["id"] = 822,
            ["image"] = 1411854,
            ["name"] = "破碎群岛",
            ["bosses"] = {
                {
                    ["id"] = 1790,
                    ["image"] = 1411023,
                    ["name"] = "鬼母阿娜",
                }, -- [1]
                {
                    ["id"] = 1956,
                    ["image"] = 1134499,
                    ["name"] = "阿波克隆",
                }, -- [2]
                {
                    ["id"] = 1883,
                    ["image"] = 1385722,
                    ["name"] = "布鲁塔卢斯",
                }, -- [3]
                {
                    ["id"] = 1774,
                    ["image"] = 1411024,
                    ["name"] = "卡拉米尔",
                }, -- [4]
                {
                    ["id"] = 1789,
                    ["image"] = 1411025,
                    ["name"] = "冷血的杜贡",
                }, -- [5]
                {
                    ["id"] = 1795,
                    ["image"] = 1472454,
                    ["name"] = "浮骸",
                }, -- [6]
                {
                    ["id"] = 1770,
                    ["image"] = 1411026,
                    ["name"] = "胡墨格里斯",
                }, -- [7]
                {
                    ["id"] = 1769,
                    ["image"] = 1411027,
                    ["name"] = "勒凡图斯",
                }, -- [8]
                {
                    ["id"] = 1884,
                    ["image"] = 1579937,
                    ["name"] = "马利费库斯",
                }, -- [9]
                {
                    ["id"] = 1783,
                    ["image"] = 1411028,
                    ["name"] = "魔王纳扎克",
                }, -- [10]
                {
                    ["id"] = 1749,
                    ["image"] = 1411029,
                    ["name"] = "尼索格",
                }, -- [11]
                {
                    ["id"] = 1763,
                    ["image"] = 1411030,
                    ["name"] = "沙索斯",
                }, -- [12]
                {
                    ["id"] = 1885,
                    ["image"] = 1579941,
                    ["name"] = "丝瓦什",
                }, -- [13]
                {
                    ["id"] = 1756,
                    ["image"] = 1411031,
                    ["name"] = "夺魂者",
                }, -- [14]
                {
                    ["id"] = 1796,
                    ["image"] = 1472455,
                    ["name"] = "凋零者吉姆",
                }, -- [15]
            },
        }, -- [1]
        {
            ["id"] = 768,
            ["image"] = 1452687,
            ["name"] = "翡翠梦魇",
            ["bosses"] = {
                {
                    ["id"] = 1703,
                    ["image"] = 1410972,
                    ["name"] = "尼珊德拉",
                }, -- [1]
                {
                    ["id"] = 1738,
                    ["image"] = 1410960,
                    ["name"] = "伊格诺斯，腐蚀之心",
                }, -- [2]
                {
                    ["id"] = 1744,
                    ["image"] = 1410947,
                    ["name"] = "艾乐瑞瑟·雷弗拉尔",
                }, -- [3]
                {
                    ["id"] = 1667,
                    ["image"] = 1410991,
                    ["name"] = "乌索克",
                }, -- [4]
                {
                    ["id"] = 1704,
                    ["image"] = 1410945,
                    ["name"] = "梦魇之龙",
                }, -- [5]
                {
                    ["id"] = 1750,
                    ["image"] = 1410940,
                    ["name"] = "塞纳留斯",
                }, -- [6]
                {
                    ["id"] = 1726,
                    ["image"] = 1410994,
                    ["name"] = "萨维斯",
                }, -- [7]
            },
        }, -- [2]
        {
            ["id"] = 861,
            ["image"] = 1537284,
            ["name"] = "勇气试炼",
            ["bosses"] = {
                {
                    ["id"] = 1819,
                    ["image"] = 1410974,
                    ["name"] = "奥丁",
                }, -- [1]
                {
                    ["id"] = 1830,
                    ["image"] = 1536491,
                    ["name"] = "高姆",
                }, -- [2]
                {
                    ["id"] = 1829,
                    ["image"] = 1410957,
                    ["name"] = "海拉",
                }, -- [3]
            },
        }, -- [3]
        {
            ["id"] = 786,
            ["image"] = 1450575,
            ["name"] = "暗夜要塞",
            ["bosses"] = {
                {
                    ["id"] = 1706,
                    ["image"] = 1410981,
                    ["name"] = "斯考匹隆",
                }, -- [1]
                {
                    ["id"] = 1725,
                    ["image"] = 1410941,
                    ["name"] = "时空畸体",
                }, -- [2]
                {
                    ["id"] = 1731,
                    ["image"] = 1410989,
                    ["name"] = "崔利艾克斯",
                }, -- [3]
                {
                    ["id"] = 1751,
                    ["image"] = 1410983,
                    ["name"] = "魔剑士奥鲁瑞尔",
                }, -- [4]
                {
                    ["id"] = 1762,
                    ["image"] = 1410987,
                    ["name"] = "提克迪奥斯",
                }, -- [5]
                {
                    ["id"] = 1713,
                    ["image"] = 1410965,
                    ["name"] = "克洛苏斯",
                }, -- [6]
                {
                    ["id"] = 1761,
                    ["image"] = 1410939,
                    ["name"] = "高级植物学家特尔安",
                }, -- [7]
                {
                    ["id"] = 1732,
                    ["image"] = 1410984,
                    ["name"] = "占星师艾塔乌斯",
                }, -- [8]
                {
                    ["id"] = 1743,
                    ["image"] = 1410954,
                    ["name"] = "大魔导师艾利桑德",
                }, -- [9]
                {
                    ["id"] = 1737,
                    ["image"] = 1410955,
                    ["name"] = "古尔丹",
                }, -- [10]
            },
        }, -- [4]
        {
            ["id"] = 875,
            ["image"] = 1616106,
            ["name"] = "萨格拉斯之墓",
            ["bosses"] = {
                {
                    ["id"] = 1862,
                    ["image"] = 1579934,
                    ["name"] = "格罗斯",
                }, -- [1]
                {
                    ["id"] = 1867,
                    ["image"] = 1579936,
                    ["name"] = "恶魔审判庭",
                }, -- [2]
                {
                    ["id"] = 1856,
                    ["image"] = 1579940,
                    ["name"] = "哈亚坦",
                }, -- [3]
                {
                    ["id"] = 1903,
                    ["image"] = 1579935,
                    ["name"] = "月之姐妹",
                }, -- [4]
                {
                    ["id"] = 1861,
                    ["image"] = 1579939,
                    ["name"] = "主母萨丝琳",
                }, -- [5]
                {
                    ["id"] = 1896,
                    ["image"] = 1579943,
                    ["name"] = "绝望的聚合体",
                }, -- [6]
                {
                    ["id"] = 1897,
                    ["image"] = 1579933,
                    ["name"] = "戒卫侍女",
                }, -- [7]
                {
                    ["id"] = 1873,
                    ["image"] = 1579932,
                    ["name"] = "堕落的化身",
                }, -- [8]
                {
                    ["id"] = 1898,
                    ["image"] = 1385746,
                    ["name"] = "基尔加丹",
                }, -- [9]
            },
        }, -- [5]
        {
            ["id"] = 959,
            ["image"] = 1718212,
            ["name"] = "侵入点",
            ["bosses"] = {
                {
                    ["id"] = 2010,
                    ["image"] = 1715215,
                    ["name"] = "主母芙努娜",
                }, -- [1]
                {
                    ["id"] = 2011,
                    ["image"] = 1715216,
                    ["name"] = "妖女奥露拉黛儿",
                }, -- [2]
                {
                    ["id"] = 2012,
                    ["image"] = 1715212,
                    ["name"] = "审判官梅托",
                }, -- [3]
                {
                    ["id"] = 2013,
                    ["image"] = 1715217,
                    ["name"] = "奥库拉鲁斯",
                }, -- [4]
                {
                    ["id"] = 2014,
                    ["image"] = 1715221,
                    ["name"] = "索塔纳索尔",
                }, -- [5]
                {
                    ["id"] = 2015,
                    ["image"] = 1715218,
                    ["name"] = "深渊领主维尔姆斯",
                }, -- [6]
            },
        }, -- [6]
        {
            ["id"] = 946,
            ["image"] = 1718211,
            ["name"] = "安托鲁斯，燃烧王座",
            ["bosses"] = {
                {
                    ["id"] = 1992,
                    ["image"] = 1715210,
                    ["name"] = "加洛西灭世者",
                }, -- [1]
                {
                    ["id"] = 1987,
                    ["image"] = 1715209,
                    ["name"] = "萨格拉斯的恶犬",
                }, -- [2]
                {
                    ["id"] = 1997,
                    ["image"] = 1715225,
                    ["name"] = "安托兰统帅议会",
                }, -- [3]
                {
                    ["id"] = 1985,
                    ["image"] = 1715219,
                    ["name"] = "传送门守护者哈萨贝尔",
                }, -- [4]
                {
                    ["id"] = 2025,
                    ["image"] = 1715208,
                    ["name"] = "生命的缚誓者艾欧娜尔",
                }, -- [5]
                {
                    ["id"] = 2009,
                    ["image"] = 1715211,
                    ["name"] = "猎魂者伊墨纳尔",
                }, -- [6]
                {
                    ["id"] = 2004,
                    ["image"] = 1715213,
                    ["name"] = "金加洛斯",
                }, -- [7]
                {
                    ["id"] = 1983,
                    ["image"] = 1715223,
                    ["name"] = "瓦里玛萨斯",
                }, -- [8]
                {
                    ["id"] = 1986,
                    ["image"] = 1715222,
                    ["name"] = "破坏魔女巫会",
                }, -- [9]
                {
                    ["id"] = 1984,
                    ["image"] = 1715207,
                    ["name"] = "阿格拉玛",
                }, -- [10]
                {
                    ["id"] = 2031,
                    ["image"] = 1715536,
                    ["name"] = "寂灭者阿古斯",
                }, -- [11]
            },
        }, -- [7]
        {
            ["id"] = 727,
            ["image"] = 1411856,
            ["name"] = "噬魂之喉",
            ["bosses"] = {
                {
                    ["id"] = 1502,
                    ["image"] = 1410995,
                    ["name"] = "堕落君王伊米隆",
                }, -- [1]
                {
                    ["id"] = 1512,
                    ["image"] = 1410956,
                    ["name"] = "哈布隆",
                }, -- [2]
                {
                    ["id"] = 1663,
                    ["image"] = 1410957,
                    ["name"] = "海拉",
                }, -- [3]
            },
        }, -- [8]
        {
            ["id"] = 767,
            ["image"] = 1450574,
            ["name"] = "奈萨里奥的巢穴",
            ["bosses"] = {
                {
                    ["id"] = 1662,
                    ["image"] = 1410976,
                    ["name"] = "洛克莫拉",
                }, -- [1]
                {
                    ["id"] = 1665,
                    ["image"] = 1410990,
                    ["name"] = "乌拉罗格·塑山",
                }, -- [2]
                {
                    ["id"] = 1673,
                    ["image"] = 1410971,
                    ["name"] = "纳拉萨斯",
                }, -- [3]
                {
                    ["id"] = 1687,
                    ["image"] = 1410944,
                    ["name"] = "地底之王达古尔",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 707,
            ["image"] = 1411858,
            ["name"] = "守望者地窟",
            ["bosses"] = {
                {
                    ["id"] = 1467,
                    ["image"] = 1410988,
                    ["name"] = "提拉宋·萨瑟利尔",
                }, -- [1]
                {
                    ["id"] = 1695,
                    ["image"] = 1410962,
                    ["name"] = "审判官托蒙托鲁姆",
                }, -- [2]
                {
                    ["id"] = 1468,
                    ["image"] = 1410937,
                    ["name"] = "阿什高姆",
                }, -- [3]
                {
                    ["id"] = 1469,
                    ["image"] = 1410952,
                    ["name"] = "格雷泽",
                }, -- [4]
                {
                    ["id"] = 1470,
                    ["image"] = 1410942,
                    ["name"] = "科达娜·邪歌",
                }, -- [5]
            },
        }, -- [10]
        {
            ["id"] = 945,
            ["image"] = 1718213,
            ["name"] = "执政团之座",
            ["bosses"] = {
                {
                    ["id"] = 1979,
                    ["image"] = 1715226,
                    ["name"] = "晋升者祖拉尔",
                }, -- [1]
                {
                    ["id"] = 1980,
                    ["image"] = 1715220,
                    ["name"] = "萨普瑞什",
                }, -- [2]
                {
                    ["id"] = 1981,
                    ["image"] = 1715224,
                    ["name"] = "总督奈扎尔",
                }, -- [3]
                {
                    ["id"] = 1982,
                    ["image"] = 1715214,
                    ["name"] = "鲁拉",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 900,
            ["image"] = 1616922,
            ["name"] = "永夜大教堂",
            ["bosses"] = {
                {
                    ["id"] = 1905,
                    ["image"] = 1579930,
                    ["name"] = "阿格洛诺克斯",
                }, -- [1]
                {
                    ["id"] = 1906,
                    ["image"] = 1579942,
                    ["name"] = "轻蔑的萨什比特",
                }, -- [2]
                {
                    ["id"] = 1904,
                    ["image"] = 1579931,
                    ["name"] = "多玛塔克斯",
                }, -- [3]
                {
                    ["id"] = 1878,
                    ["image"] = 1579938,
                    ["name"] = "孟菲斯托斯",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 777,
            ["image"] = 1498155,
            ["name"] = "突袭紫罗兰监狱",
            ["bosses"] = {
                {
                    ["id"] = 1693,
                    ["image"] = 1410950,
                    ["name"] = "溃面",
                }, -- [1]
                {
                    ["id"] = 1694,
                    ["image"] = 1410980,
                    ["name"] = "颤栗之喉",
                }, -- [2]
                {
                    ["id"] = 1702,
                    ["image"] = 1410938,
                    ["name"] = "鲜血公主萨安娜",
                }, -- [3]
                {
                    ["id"] = 1686,
                    ["image"] = 1410969,
                    ["name"] = "夺心者卡什",
                }, -- [4]
                {
                    ["id"] = 1688,
                    ["image"] = 1410968,
                    ["name"] = "米尔菲丝·法力风暴",
                }, -- [5]
                {
                    ["id"] = 1696,
                    ["image"] = 1410935,
                    ["name"] = "阿努贝斯特",
                }, -- [6]
                {
                    ["id"] = 1697,
                    ["image"] = 1410977,
                    ["name"] = "赛尔奥隆",
                }, -- [7]
                {
                    ["id"] = 1711,
                    ["image"] = 1410948,
                    ["name"] = "邪能领主贝图格",
                }, -- [8]
            },
        }, -- [13]
        {
            ["id"] = 800,
            ["image"] = 1498156,
            ["name"] = "群星庭院",
            ["bosses"] = {
                {
                    ["id"] = 1718,
                    ["image"] = 1410975,
                    ["name"] = "巡逻队长加多",
                }, -- [1]
                {
                    ["id"] = 1719,
                    ["image"] = 1410985,
                    ["name"] = "塔丽克萨·火冠",
                }, -- [2]
                {
                    ["id"] = 1720,
                    ["image"] = 1410933,
                    ["name"] = "顾问麦兰杜斯",
                }, -- [3]
            },
        }, -- [14]
        {
            ["id"] = 716,
            ["image"] = 1498157,
            ["name"] = "艾萨拉之眼",
            ["bosses"] = {
                {
                    ["id"] = 1480,
                    ["image"] = 1410992,
                    ["name"] = "督军帕杰什",
                }, -- [1]
                {
                    ["id"] = 1490,
                    ["image"] = 1410966,
                    ["name"] = "积怨夫人",
                }, -- [2]
                {
                    ["id"] = 1491,
                    ["image"] = 1410964,
                    ["name"] = "深须国王",
                }, -- [3]
                {
                    ["id"] = 1479,
                    ["image"] = 1410978,
                    ["name"] = "瑟芬崔斯克",
                }, -- [4]
                {
                    ["id"] = 1492,
                    ["image"] = 1410993,
                    ["name"] = "艾萨拉之怒",
                }, -- [5]
            },
        }, -- [15]
        {
            ["id"] = 721,
            ["image"] = 1498158,
            ["name"] = "英灵殿",
            ["bosses"] = {
                {
                    ["id"] = 1485,
                    ["image"] = 1410958,
                    ["name"] = "海姆达尔",
                }, -- [1]
                {
                    ["id"] = 1486,
                    ["image"] = 1410959,
                    ["name"] = "赫娅",
                }, -- [2]
                {
                    ["id"] = 1487,
                    ["image"] = 1410949,
                    ["name"] = "芬雷尔",
                }, -- [3]
                {
                    ["id"] = 1488,
                    ["image"] = 1410953,
                    ["name"] = "神王斯科瓦尔德",
                }, -- [4]
                {
                    ["id"] = 1489,
                    ["image"] = 1410974,
                    ["name"] = "奥丁",
                }, -- [5]
            },
        }, -- [16]
        {
            ["id"] = 860,
            ["image"] = 1537283,
            ["name"] = "重返卡拉赞",
            ["bosses"] = {
                {
                    ["id"] = 1820,
                    ["image"] = 1536495,
                    ["name"] = "歌剧院：魔法坏女巫",
                }, -- [1]
                {
                    ["id"] = 1826,
                    ["image"] = 1536494,
                    ["name"] = "歌剧院：西部故事",
                }, -- [2]
                {
                    ["id"] = 1827,
                    ["image"] = 1536493,
                    ["name"] = "歌剧院：美女与野兽",
                }, -- [3]
                {
                    ["id"] = 1825,
                    ["image"] = 1378997,
                    ["name"] = "贞节圣女",
                }, -- [4]
                {
                    ["id"] = 1835,
                    ["image"] = 1536490,
                    ["name"] = "猎手阿图门",
                }, -- [5]
                {
                    ["id"] = 1837,
                    ["image"] = 1378999,
                    ["name"] = "莫罗斯",
                }, -- [6]
                {
                    ["id"] = 1836,
                    ["image"] = 1379020,
                    ["name"] = "馆长",
                }, -- [7]
                {
                    ["id"] = 1817,
                    ["image"] = 1536496,
                    ["name"] = "麦迪文之影",
                }, -- [8]
                {
                    ["id"] = 1818,
                    ["image"] = 1536492,
                    ["name"] = "魔力吞噬者",
                }, -- [9]
                {
                    ["id"] = 1838,
                    ["image"] = 1536497,
                    ["name"] = "监视者维兹艾德姆",
                }, -- [10]
            },
        }, -- [17]
        {
            ["id"] = 726,
            ["image"] = 1411857,
            ["name"] = "魔法回廊",
            ["bosses"] = {
                {
                    ["id"] = 1497,
                    ["image"] = 1410963,
                    ["name"] = "伊凡尔",
                }, -- [1]
                {
                    ["id"] = 1498,
                    ["image"] = 1410943,
                    ["name"] = "科蒂拉克斯",
                }, -- [2]
                {
                    ["id"] = 1499,
                    ["image"] = 1410951,
                    ["name"] = "萨卡尔将军",
                }, -- [3]
                {
                    ["id"] = 1500,
                    ["image"] = 1410970,
                    ["name"] = "纳尔提拉",
                }, -- [4]
                {
                    ["id"] = 1501,
                    ["image"] = 1410934,
                    ["name"] = "顾问凡多斯",
                }, -- [5]
            },
        }, -- [18]
        {
            ["id"] = 762,
            ["image"] = 1411855,
            ["name"] = "黑心林地",
            ["bosses"] = {
                {
                    ["id"] = 1654,
                    ["image"] = 1410936,
                    ["name"] = "大德鲁伊格兰达里斯",
                }, -- [1]
                {
                    ["id"] = 1655,
                    ["image"] = 1410973,
                    ["name"] = "橡树之心",
                }, -- [2]
                {
                    ["id"] = 1656,
                    ["image"] = 1410946,
                    ["name"] = "德萨隆",
                }, -- [3]
                {
                    ["id"] = 1657,
                    ["image"] = 1410979,
                    ["name"] = "萨维斯之影",
                }, -- [4]
            },
        }, -- [19]
        {
            ["id"] = 740,
            ["image"] = 1411853,
            ["name"] = "黑鸦堡垒",
            ["bosses"] = {
                {
                    ["id"] = 1518,
                    ["image"] = 1410986,
                    ["name"] = "融合之魂",
                }, -- [1]
                {
                    ["id"] = 1653,
                    ["image"] = 1410961,
                    ["name"] = "伊莉萨娜·拉文凯斯",
                }, -- [2]
                {
                    ["id"] = 1664,
                    ["image"] = 1410982,
                    ["name"] = "可恨的斯麦斯帕",
                }, -- [3]
                {
                    ["id"] = 1672,
                    ["image"] = 1410967,
                    ["name"] = "库塔洛斯·拉文凯斯",
                }, -- [4]
            },
        }, -- [20]
    },
}

data.zhTW = {
    ["艾澤拉斯"] = {
        {
            ["id"] = 741,
            ["image"] = 1396586,
            ["name"] = "熔火之心",
            ["bosses"] = {
                {
                    ["id"] = 1519,
                    ["image"] = 1378993,
                    ["name"] = "魯西弗隆",
                }, -- [1]
                {
                    ["id"] = 1520,
                    ["image"] = 1378995,
                    ["name"] = "瑪格曼達",
                }, -- [2]
                {
                    ["id"] = 1521,
                    ["image"] = 1378976,
                    ["name"] = "基赫納斯",
                }, -- [3]
                {
                    ["id"] = 1522,
                    ["image"] = 1378975,
                    ["name"] = "加爾",
                }, -- [4]
                {
                    ["id"] = 1523,
                    ["image"] = 1379013,
                    ["name"] = "沙斯拉爾",
                }, -- [5]
                {
                    ["id"] = 1524,
                    ["image"] = 1378966,
                    ["name"] = "迦頓男爵",
                }, -- [6]
                {
                    ["id"] = 1525,
                    ["image"] = 1379015,
                    ["name"] = "薩弗隆先驅者",
                }, -- [7]
                {
                    ["id"] = 1526,
                    ["image"] = 1378978,
                    ["name"] = "『焚化者』古雷曼格",
                }, -- [8]
                {
                    ["id"] = 1527,
                    ["image"] = 1378998,
                    ["name"] = "管理者埃克索圖斯",
                }, -- [9]
                {
                    ["id"] = 1528,
                    ["image"] = 522261,
                    ["name"] = "拉格納羅斯",
                }, -- [10]
            },
        }, -- [1]
        {
            ["id"] = 742,
            ["image"] = 1396580,
            ["name"] = "黑翼之巢",
            ["bosses"] = {
                {
                    ["id"] = 1529,
                    ["image"] = 1379008,
                    ["name"] = "狂野的拉佐格爾",
                }, -- [1]
                {
                    ["id"] = 1530,
                    ["image"] = 1379022,
                    ["name"] = "墮落的瓦拉斯塔茲",
                }, -- [2]
                {
                    ["id"] = 1531,
                    ["image"] = 1378968,
                    ["name"] = "幼龍領主勒西雷爾",
                }, -- [3]
                {
                    ["id"] = 1532,
                    ["image"] = 1378973,
                    ["name"] = "費爾默",
                }, -- [4]
                {
                    ["id"] = 1533,
                    ["image"] = 1378971,
                    ["name"] = "埃博諾克",
                }, -- [5]
                {
                    ["id"] = 1534,
                    ["image"] = 1378974,
                    ["name"] = "弗萊格爾",
                }, -- [6]
                {
                    ["id"] = 1535,
                    ["image"] = 1378969,
                    ["name"] = "克洛瑪古斯",
                }, -- [7]
                {
                    ["id"] = 1536,
                    ["image"] = 1379001,
                    ["name"] = "奈法利安",
                }, -- [8]
            },
        }, -- [2]
        {
            ["id"] = 743,
            ["image"] = 1396591,
            ["name"] = "安其拉廢墟",
            ["bosses"] = {
                {
                    ["id"] = 1537,
                    ["image"] = 1385749,
                    ["name"] = "庫林納克斯",
                }, -- [1]
                {
                    ["id"] = 1538,
                    ["image"] = 1385734,
                    ["name"] = "拉賈克斯將軍",
                }, -- [2]
                {
                    ["id"] = 1539,
                    ["image"] = 1385755,
                    ["name"] = "莫阿姆",
                }, -- [3]
                {
                    ["id"] = 1540,
                    ["image"] = 1385723,
                    ["name"] = "『暴食者』布魯",
                }, -- [4]
                {
                    ["id"] = 1541,
                    ["image"] = 1385718,
                    ["name"] = "『狩獵者』阿亞米斯",
                }, -- [5]
                {
                    ["id"] = 1542,
                    ["image"] = 1385759,
                    ["name"] = "『無疤者』奧斯里安",
                }, -- [6]
            },
        }, -- [3]
        {
            ["id"] = 744,
            ["image"] = 1396593,
            ["name"] = "安其拉神廟",
            ["bosses"] = {
                {
                    ["id"] = 1543,
                    ["image"] = 1385769,
                    ["name"] = "預言者斯克拉姆",
                }, -- [1]
                {
                    ["id"] = 1547,
                    ["image"] = 1390436,
                    ["name"] = "異種蠍皇族",
                }, -- [2]
                {
                    ["id"] = 1544,
                    ["image"] = 1385720,
                    ["name"] = "戰地衛士沙爾圖拉",
                }, -- [3]
                {
                    ["id"] = 1545,
                    ["image"] = 1385728,
                    ["name"] = "不屈的范克里斯",
                }, -- [4]
                {
                    ["id"] = 1548,
                    ["image"] = 1385771,
                    ["name"] = "維希度斯",
                }, -- [5]
                {
                    ["id"] = 1546,
                    ["image"] = 1385761,
                    ["name"] = "哈霍蘭公主",
                }, -- [6]
                {
                    ["id"] = 1549,
                    ["image"] = 1390437,
                    ["name"] = "雙子帝王",
                }, -- [7]
                {
                    ["id"] = 1550,
                    ["image"] = 1385760,
                    ["name"] = "奧羅",
                }, -- [8]
                {
                    ["id"] = 1551,
                    ["image"] = 1385726,
                    ["name"] = "克蘇恩",
                }, -- [9]
            },
        }, -- [4]
        {
            ["id"] = 234,
            ["image"] = 608213,
            ["name"] = "剃刀沼澤",
            ["bosses"] = {
                {
                    ["id"] = 896,
                    ["image"] = 607531,
                    ["name"] = "獵人骨牙",
                }, -- [1]
                {
                    ["id"] = 895,
                    ["image"] = 607760,
                    ["name"] = "魯古格",
                }, -- [2]
                {
                    ["id"] = 899,
                    ["image"] = 607736,
                    ["name"] = "督軍拉姆塔斯",
                }, -- [3]
                {
                    ["id"] = 900,
                    ["image"] = 1064175,
                    ["name"] = "『盲眼獵手』格羅亞特",
                }, -- [4]
                {
                    ["id"] = 901,
                    ["image"] = 607563,
                    ["name"] = "卡爾加‧刺肋",
                }, -- [5]
            },
        }, -- [5]
        {
            ["id"] = 233,
            ["image"] = 608212,
            ["name"] = "剃刀高地",
            ["bosses"] = {
                {
                    ["id"] = 1142,
                    ["image"] = 607633,
                    ["name"] = "阿魯斯",
                }, -- [1]
                {
                    ["id"] = 433,
                    ["image"] = 607718,
                    ["name"] = "火眼莫德雷斯",
                }, -- [2]
                {
                    ["id"] = 1143,
                    ["image"] = 1064178,
                    ["name"] = "肉疙瘩",
                }, -- [3]
                {
                    ["id"] = 1146,
                    ["image"] = 607584,
                    ["name"] = "亡語者黑棘",
                }, -- [4]
                {
                    ["id"] = 1141,
                    ["image"] = 607537,
                    ["name"] = "『寒冰使者』亞門納爾",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 230,
            ["image"] = 608200,
            ["name"] = "厄運之槌",
            ["bosses"] = {
                {
                    ["id"] = 402,
                    ["image"] = 607824,
                    ["name"] = "瑟雷姆‧刺蹄",
                }, -- [1]
                {
                    ["id"] = 403,
                    ["image"] = 607653,
                    ["name"] = "海多斯博恩",
                }, -- [2]
                {
                    ["id"] = 404,
                    ["image"] = 607686,
                    ["name"] = "蕾瑟塔蒂絲",
                }, -- [3]
                {
                    ["id"] = 405,
                    ["image"] = 607533,
                    ["name"] = "『狂野變形者』奧茲恩",
                }, -- [4]
                {
                    ["id"] = 406,
                    ["image"] = 607785,
                    ["name"] = "特迪斯‧扭木",
                }, -- [5]
                {
                    ["id"] = 407,
                    ["image"] = 607656,
                    ["name"] = "伊琳娜‧鴉橡",
                }, -- [6]
                {
                    ["id"] = 408,
                    ["image"] = 607703,
                    ["name"] = "博學者卡雷迪斯",
                }, -- [7]
                {
                    ["id"] = 409,
                    ["image"] = 607657,
                    ["name"] = "伊莫塔爾",
                }, -- [8]
                {
                    ["id"] = 410,
                    ["image"] = 607745,
                    ["name"] = "托塞德林王子",
                }, -- [9]
                {
                    ["id"] = 411,
                    ["image"] = 607630,
                    ["name"] = "守衛摩爾達",
                }, -- [10]
                {
                    ["id"] = 412,
                    ["image"] = 607777,
                    ["name"] = "踐踏者克雷格",
                }, -- [11]
                {
                    ["id"] = 413,
                    ["image"] = 607629,
                    ["name"] = "守衛芬古斯",
                }, -- [12]
                {
                    ["id"] = 414,
                    ["image"] = 607631,
                    ["name"] = "守衛斯里基克",
                }, -- [13]
                {
                    ["id"] = 415,
                    ["image"] = 607560,
                    ["name"] = "隊長克羅卡斯",
                }, -- [14]
                {
                    ["id"] = 416,
                    ["image"] = 607565,
                    ["name"] = "『觀察者』克魯什",
                }, -- [15]
                {
                    ["id"] = 417,
                    ["image"] = 607673,
                    ["name"] = "戈多克大王",
                }, -- [16]
            },
        }, -- [7]
        {
            ["id"] = 240,
            ["image"] = 608229,
            ["name"] = "哀嚎洞穴",
            ["bosses"] = {
                {
                    ["id"] = 474,
                    ["image"] = 607680,
                    ["name"] = "安娜科德拉女士",
                }, -- [1]
                {
                    ["id"] = 476,
                    ["image"] = 607696,
                    ["name"] = "皮薩斯領主",
                }, -- [2]
                {
                    ["id"] = 475,
                    ["image"] = 607693,
                    ["name"] = "考布萊恩領主",
                }, -- [3]
                {
                    ["id"] = 477,
                    ["image"] = 607676,
                    ["name"] = "克雷什",
                }, -- [4]
                {
                    ["id"] = 478,
                    ["image"] = 607775,
                    ["name"] = "斯卡姆",
                }, -- [5]
                {
                    ["id"] = 479,
                    ["image"] = 607698,
                    ["name"] = "瑟芬迪斯領主",
                }, -- [6]
                {
                    ["id"] = 480,
                    ["image"] = 607805,
                    ["name"] = "永生的沃爾丹",
                }, -- [7]
                {
                    ["id"] = 481,
                    ["image"] = 607721,
                    ["name"] = "『吞噬者』穆坦努斯",
                }, -- [8]
            },
        }, -- [8]
        {
            ["id"] = 239,
            ["image"] = 608225,
            ["name"] = "奧達曼",
            ["bosses"] = {
                {
                    ["id"] = 467,
                    ["image"] = 607757,
                    ["name"] = "魯維羅什",
                }, -- [1]
                {
                    ["id"] = 468,
                    ["image"] = 607550,
                    ["name"] = "失蹤的矮人",
                }, -- [2]
                {
                    ["id"] = 469,
                    ["image"] = 607664,
                    ["name"] = "艾隆納亞",
                }, -- [3]
                {
                    ["id"] = 748,
                    ["image"] = 607729,
                    ["name"] = "黑曜石哨兵",
                }, -- [4]
                {
                    ["id"] = 470,
                    ["image"] = 607538,
                    ["name"] = "上古石之守衛者",
                }, -- [5]
                {
                    ["id"] = 471,
                    ["image"] = 607606,
                    ["name"] = "加加恩‧火錘",
                }, -- [6]
                {
                    ["id"] = 472,
                    ["image"] = 607626,
                    ["name"] = "格瑞姆洛克",
                }, -- [7]
                {
                    ["id"] = 473,
                    ["image"] = 607546,
                    ["name"] = "阿札達斯",
                }, -- [8]
            },
        }, -- [9]
        {
            ["id"] = 64,
            ["image"] = 522358,
            ["name"] = "影牙城堡",
            ["bosses"] = {
                {
                    ["id"] = 96,
                    ["image"] = 522205,
                    ["name"] = "艾胥柏利男爵",
                }, -- [1]
                {
                    ["id"] = 97,
                    ["image"] = 522206,
                    ["name"] = "席瓦萊恩男爵",
                }, -- [2]
                {
                    ["id"] = 98,
                    ["image"] = 522213,
                    ["name"] = "指揮官斯普林瓦爾",
                }, -- [3]
                {
                    ["id"] = 99,
                    ["image"] = 522249,
                    ["name"] = "瓦爾登領主",
                }, -- [4]
                {
                    ["id"] = 100,
                    ["image"] = 522247,
                    ["name"] = "高佛雷領主",
                }, -- [5]
            },
        }, -- [10]
        {
            ["id"] = 226,
            ["image"] = 608211,
            ["name"] = "怒焰裂谷",
            ["bosses"] = {
                {
                    ["id"] = 694,
                    ["image"] = 608309,
                    ["name"] = "阿達洛葛",
                }, -- [1]
                {
                    ["id"] = 695,
                    ["image"] = 608310,
                    ["name"] = "黑暗薩滿坷蘭索",
                }, -- [2]
                {
                    ["id"] = 696,
                    ["image"] = 522251,
                    ["name"] = "斯納格瑪",
                }, -- [3]
                {
                    ["id"] = 697,
                    ["image"] = 608315,
                    ["name"] = "熔岩守衛哥爾多斯",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 236,
            ["image"] = 608216,
            ["name"] = "斯坦索姆",
            ["bosses"] = {
                {
                    ["id"] = 443,
                    ["image"] = 607637,
                    ["name"] = "爐邊歌手弗瑞斯坦",
                }, -- [1]
                {
                    ["id"] = 445,
                    ["image"] = 607795,
                    ["name"] = "殘忍的提米",
                }, -- [2]
                {
                    ["id"] = 749,
                    ["image"] = 607569,
                    ["name"] = "指揮官瑪洛爾",
                }, -- [3]
                {
                    ["id"] = 446,
                    ["image"] = 607818,
                    ["name"] = "威利‧希望破除者",
                }, -- [4]
                {
                    ["id"] = 448,
                    ["image"] = 607660,
                    ["name"] = "古卷管理者加爾福特",
                }, -- [5]
                {
                    ["id"] = 449,
                    ["image"] = 607551,
                    ["name"] = "巴納札爾",
                }, -- [6]
                {
                    ["id"] = 450,
                    ["image"] = 607792,
                    ["name"] = "不可寬恕者",
                }, -- [7]
                {
                    ["id"] = 451,
                    ["image"] = 607553,
                    ["name"] = "安娜絲塔麗男爵夫人",
                }, -- [8]
                {
                    ["id"] = 452,
                    ["image"] = 607724,
                    ["name"] = "奈幽布恩坎",
                }, -- [9]
                {
                    ["id"] = 453,
                    ["image"] = 607707,
                    ["name"] = "蒼白的瑪勒基",
                }, -- [10]
                {
                    ["id"] = 454,
                    ["image"] = 607791,
                    ["name"] = "巴瑟拉斯鎮長",
                }, -- [11]
                {
                    ["id"] = 455,
                    ["image"] = 607752,
                    ["name"] = "『暴食者』拉姆斯登",
                }, -- [12]
                {
                    ["id"] = 456,
                    ["image"] = 607692,
                    ["name"] = "奧里爾斯‧瑞文戴爾領主",
                }, -- [13]
            },
        }, -- [12]
        {
            ["id"] = 63,
            ["image"] = 522352,
            ["name"] = "死亡礦坑",
            ["bosses"] = {
                {
                    ["id"] = 89,
                    ["image"] = 522228,
                    ["name"] = "格魯巴托克",
                }, -- [1]
                {
                    ["id"] = 90,
                    ["image"] = 522234,
                    ["name"] = "赫利克斯‧碎輪者",
                }, -- [2]
                {
                    ["id"] = 91,
                    ["image"] = 522225,
                    ["name"] = "敵人收割者5000型",
                }, -- [3]
                {
                    ["id"] = 92,
                    ["image"] = 522189,
                    ["name"] = "利普斯納爾上將",
                }, -- [4]
                {
                    ["id"] = 93,
                    ["image"] = 522210,
                    ["name"] = "『船長』餅乾",
                }, -- [5]
            },
        }, -- [13]
        {
            ["id"] = 232,
            ["image"] = 608209,
            ["name"] = "瑪拉頓",
            ["bosses"] = {
                {
                    ["id"] = 423,
                    ["image"] = 607728,
                    ["name"] = "諾克賽恩",
                }, -- [1]
                {
                    ["id"] = 424,
                    ["image"] = 607756,
                    ["name"] = "銳刺鞭笞者",
                }, -- [2]
                {
                    ["id"] = 425,
                    ["image"] = 607796,
                    ["name"] = "技工吉茲洛克",
                }, -- [3]
                {
                    ["id"] = 427,
                    ["image"] = 607699,
                    ["name"] = "維利塔恩領主",
                }, -- [4]
                {
                    ["id"] = 428,
                    ["image"] = 607562,
                    ["name"] = "被詛咒的塞雷布拉斯",
                }, -- [5]
                {
                    ["id"] = 429,
                    ["image"] = 607684,
                    ["name"] = "蘭斯利德",
                }, -- [6]
                {
                    ["id"] = 430,
                    ["image"] = 607761,
                    ["name"] = "洛特格里普",
                }, -- [7]
                {
                    ["id"] = 431,
                    ["image"] = 607747,
                    ["name"] = "瑟萊德絲公主",
                }, -- [8]
            },
        }, -- [14]
        {
            ["id"] = 238,
            ["image"] = 608223,
            ["name"] = "監獄",
            ["bosses"] = {
                {
                    ["id"] = 464,
                    ["image"] = 607646,
                    ["name"] = "霍格",
                }, -- [1]
                {
                    ["id"] = 465,
                    ["image"] = 607695,
                    ["name"] = "歐玻西特王",
                }, -- [2]
                {
                    ["id"] = 466,
                    ["image"] = 607753,
                    ["name"] = "藍道夫‧摩洛克",
                }, -- [3]
            },
        }, -- [15]
        {
            ["id"] = 241,
            ["image"] = 608230,
            ["name"] = "祖爾法拉克",
            ["bosses"] = {
                {
                    ["id"] = 483,
                    ["image"] = 607614,
                    ["name"] = "加茲瑞拉",
                }, -- [1]
                {
                    ["id"] = 484,
                    ["image"] = 607541,
                    ["name"] = "安圖蘇爾",
                }, -- [2]
                {
                    ["id"] = 485,
                    ["image"] = 607793,
                    ["name"] = "『殉教者』塞卡",
                }, -- [3]
                {
                    ["id"] = 486,
                    ["image"] = 607819,
                    ["name"] = "巫醫祖穆拉恩",
                }, -- [4]
                {
                    ["id"] = 487,
                    ["image"] = 607723,
                    ["name"] = "耐克倫&塞瑟斯",
                }, -- [5]
                {
                    ["id"] = 489,
                    ["image"] = 607564,
                    ["name"] = "烏克茲‧沙頂",
                }, -- [6]
            },
        }, -- [16]
        {
            ["id"] = 316,
            ["image"] = 608214,
            ["name"] = "血色修道院",
            ["bosses"] = {
                {
                    ["id"] = 688,
                    ["image"] = 630853,
                    ["name"] = "『靈魂撕裂者』薩爾諾斯",
                }, -- [1]
                {
                    ["id"] = 671,
                    ["image"] = 630818,
                    ["name"] = "克羅夫修士",
                }, -- [2]
                {
                    ["id"] = 674,
                    ["image"] = 607643,
                    ["name"] = "高階審判官懷特邁恩",
                }, -- [3]
            },
        }, -- [17]
        {
            ["id"] = 311,
            ["image"] = 643262,
            ["name"] = "血色大廳",
            ["bosses"] = {
                {
                    ["id"] = 660,
                    ["image"] = 630833,
                    ["name"] = "馴犬者布勞恩",
                }, -- [1]
                {
                    ["id"] = 654,
                    ["image"] = 630816,
                    ["name"] = "武器大師哈倫",
                }, -- [2]
                {
                    ["id"] = 656,
                    ["image"] = 630825,
                    ["name"] = "織焰者喀格勒",
                }, -- [3]
            },
        }, -- [18]
        {
            ["id"] = 231,
            ["image"] = 608202,
            ["name"] = "諾姆瑞根",
            ["bosses"] = {
                {
                    ["id"] = 419,
                    ["image"] = 607628,
                    ["name"] = "格魯比斯",
                }, -- [1]
                {
                    ["id"] = 420,
                    ["image"] = 607808,
                    ["name"] = "黏性輻射塵",
                }, -- [2]
                {
                    ["id"] = 421,
                    ["image"] = 607594,
                    ["name"] = "電刑器6000型",
                }, -- [3]
                {
                    ["id"] = 418,
                    ["image"] = 607572,
                    ["name"] = "群體打擊者9-60",
                }, -- [4]
                {
                    ["id"] = 422,
                    ["image"] = 607714,
                    ["name"] = "機電師瑟瑪普拉格",
                }, -- [5]
            },
        }, -- [19]
        {
            ["id"] = 246,
            ["image"] = 608215,
            ["name"] = "通靈學院",
            ["bosses"] = {
                {
                    ["id"] = 659,
                    ["image"] = 630835,
                    ["name"] = "講師冷心",
                }, -- [1]
                {
                    ["id"] = 663,
                    ["image"] = 607666,
                    ["name"] = "詹迪斯‧巴羅夫",
                }, -- [2]
                {
                    ["id"] = 665,
                    ["image"] = 607755,
                    ["name"] = "血骨傀儡",
                }, -- [3]
                {
                    ["id"] = 666,
                    ["image"] = 630838,
                    ["name"] = "莉莉安‧佛斯",
                }, -- [4]
                {
                    ["id"] = 684,
                    ["image"] = 607582,
                    ["name"] = "黑暗院長加丁",
                }, -- [5]
            },
        }, -- [20]
        {
            ["id"] = 237,
            ["image"] = 608217,
            ["name"] = "阿塔哈卡神廟",
            ["bosses"] = {
                {
                    ["id"] = 457,
                    ["image"] = 607548,
                    ["name"] = "哈卡的化身",
                }, -- [1]
                {
                    ["id"] = 458,
                    ["image"] = 607665,
                    ["name"] = "『預言者』迦瑪蘭",
                }, -- [2]
                {
                    ["id"] = 459,
                    ["image"] = 608311,
                    ["name"] = "夢境看守者",
                }, -- [3]
                {
                    ["id"] = 463,
                    ["image"] = 607768,
                    ["name"] = "伊蘭尼庫斯之影",
                }, -- [4]
            },
        }, -- [21]
        {
            ["id"] = 227,
            ["image"] = 608195,
            ["name"] = "黑澗深淵",
            ["bosses"] = {
                {
                    ["id"] = 368,
                    ["image"] = 1064179,
                    ["name"] = "加摩拉",
                }, -- [1]
                {
                    ["id"] = 436,
                    ["image"] = 1064180,
                    ["name"] = "朵米娜",
                }, -- [2]
                {
                    ["id"] = 426,
                    ["image"] = 522214,
                    ["name"] = "征服者寇烏爾",
                }, -- [3]
                {
                    ["id"] = 1145,
                    ["image"] = 1064181,
                    ["name"] = "瑟拉克",
                }, -- [4]
                {
                    ["id"] = 447,
                    ["image"] = 1064182,
                    ["name"] = "深淵守護者",
                }, -- [5]
                {
                    ["id"] = 1144,
                    ["image"] = 1064183,
                    ["name"] = "處決者戈爾",
                }, -- [6]
                {
                    ["id"] = 437,
                    ["image"] = 1064184,
                    ["name"] = "暮光領主巴賽爾",
                }, -- [7]
                {
                    ["id"] = 444,
                    ["image"] = 607532,
                    ["name"] = "阿庫麥爾",
                }, -- [8]
            },
        }, -- [22]
        {
            ["id"] = 229,
            ["image"] = 608197,
            ["name"] = "黑石塔下層",
            ["bosses"] = {
                {
                    ["id"] = 388,
                    ["image"] = 607645,
                    ["name"] = "歐莫克大王",
                }, -- [1]
                {
                    ["id"] = 389,
                    ["image"] = 607769,
                    ["name"] = "暗影獵手沃許加斯",
                }, -- [2]
                {
                    ["id"] = 390,
                    ["image"] = 607810,
                    ["name"] = "將領沃恩",
                }, -- [3]
                {
                    ["id"] = 391,
                    ["image"] = 607719,
                    ["name"] = "煙網蛛后",
                }, -- [4]
                {
                    ["id"] = 392,
                    ["image"] = 607801,
                    ["name"] = "烏洛克‧末日嚎",
                }, -- [5]
                {
                    ["id"] = 393,
                    ["image"] = 607751,
                    ["name"] = "軍需官茲格雷斯",
                }, -- [6]
                {
                    ["id"] = 394,
                    ["image"] = 607634,
                    ["name"] = "哈雷肯",
                }, -- [7]
                {
                    ["id"] = 395,
                    ["image"] = 607615,
                    ["name"] = "『奴役者』基茲盧爾",
                }, -- [8]
                {
                    ["id"] = 396,
                    ["image"] = 607737,
                    ["name"] = "維姆薩拉克主宰",
                }, -- [9]
            },
        }, -- [23]
        {
            ["id"] = 228,
            ["image"] = 608196,
            ["name"] = "黑石深淵",
            ["bosses"] = {
                {
                    ["id"] = 369,
                    ["image"] = 607644,
                    ["name"] = "高階審問者格斯塔恩",
                }, -- [1]
                {
                    ["id"] = 370,
                    ["image"] = 607697,
                    ["name"] = "洛考爾領主",
                }, -- [2]
                {
                    ["id"] = 371,
                    ["image"] = 607647,
                    ["name"] = "馴犬者格雷布瑪爾",
                }, -- [3]
                {
                    ["id"] = 372,
                    ["image"] = 608314,
                    ["name"] = "秩序競技場",
                }, -- [4]
                {
                    ["id"] = 373,
                    ["image"] = 607749,
                    ["name"] = "火占師羅格雷恩",
                }, -- [5]
                {
                    ["id"] = 374,
                    ["image"] = 607694,
                    ["name"] = "伊森迪奧斯領主",
                }, -- [6]
                {
                    ["id"] = 375,
                    ["image"] = 607814,
                    ["name"] = "護衛斯迪爾基斯",
                }, -- [7]
                {
                    ["id"] = 376,
                    ["image"] = 607602,
                    ["name"] = "弗諾斯‧達克維爾",
                }, -- [8]
                {
                    ["id"] = 377,
                    ["image"] = 607549,
                    ["name"] = "貝爾加",
                }, -- [9]
                {
                    ["id"] = 378,
                    ["image"] = 607610,
                    ["name"] = "安格弗將軍",
                }, -- [10]
                {
                    ["id"] = 379,
                    ["image"] = 607618,
                    ["name"] = "魔像領主阿格曼奇",
                }, -- [11]
                {
                    ["id"] = 380,
                    ["image"] = 607650,
                    ["name"] = "霍爾雷‧黑息",
                }, -- [12]
                {
                    ["id"] = 381,
                    ["image"] = 607740,
                    ["name"] = "法拉克斯",
                }, -- [13]
                {
                    ["id"] = 383,
                    ["image"] = 607741,
                    ["name"] = "普拉格‧史帕齊林",
                }, -- [14]
                {
                    ["id"] = 384,
                    ["image"] = 607535,
                    ["name"] = "弗萊拉斯大使",
                }, -- [15]
                {
                    ["id"] = 385,
                    ["image"] = 607587,
                    ["name"] = "七賢",
                }, -- [16]
                {
                    ["id"] = 386,
                    ["image"] = 607705,
                    ["name"] = "瑪格姆斯",
                }, -- [17]
                {
                    ["id"] = 387,
                    ["image"] = 607595,
                    ["name"] = "達格蘭‧索瑞森大帝",
                }, -- [18]
            },
        }, -- [24]
    },
    ["軍臨天下"] = {
        {
            ["id"] = 822,
            ["image"] = 1411854,
            ["name"] = "破碎群島",
            ["bosses"] = {
                {
                    ["id"] = 1790,
                    ["image"] = 1411023,
                    ["name"] = "亞娜慕茲",
                }, -- [1]
                {
                    ["id"] = 1956,
                    ["image"] = 1134499,
                    ["name"] = "亞破克隆",
                }, -- [2]
                {
                    ["id"] = 1883,
                    ["image"] = 1385722,
                    ["name"] = "布魯托魯斯",
                }, -- [3]
                {
                    ["id"] = 1774,
                    ["image"] = 1411024,
                    ["name"] = "卡拉米爾",
                }, -- [4]
                {
                    ["id"] = 1789,
                    ["image"] = 1411025,
                    ["name"] = "『霜血』督剛",
                }, -- [5]
                {
                    ["id"] = 1795,
                    ["image"] = 1472454,
                    ["name"] = "弗洛山",
                }, -- [6]
                {
                    ["id"] = 1770,
                    ["image"] = 1411026,
                    ["name"] = "休蒙格里斯",
                }, -- [7]
                {
                    ["id"] = 1769,
                    ["image"] = 1411027,
                    ["name"] = "利薇妲絲",
                }, -- [8]
                {
                    ["id"] = 1884,
                    ["image"] = 1579937,
                    ["name"] = "梅里費克斯",
                }, -- [9]
                {
                    ["id"] = 1783,
                    ["image"] = 1411028,
                    ["name"] = "惡魔納札卡",
                }, -- [10]
                {
                    ["id"] = 1749,
                    ["image"] = 1411029,
                    ["name"] = "尼索格",
                }, -- [11]
                {
                    ["id"] = 1763,
                    ["image"] = 1411030,
                    ["name"] = "薩索斯",
                }, -- [12]
                {
                    ["id"] = 1885,
                    ["image"] = 1579941,
                    ["name"] = "希娃旭",
                }, -- [13]
                {
                    ["id"] = 1756,
                    ["image"] = 1411031,
                    ["name"] = "奪魂者",
                }, -- [14]
                {
                    ["id"] = 1796,
                    ["image"] = 1472455,
                    ["name"] = "凋萎者吉姆",
                }, -- [15]
            },
        }, -- [1]
        {
            ["id"] = 768,
            ["image"] = 1452687,
            ["name"] = "翡翠夢魘",
            ["bosses"] = {
                {
                    ["id"] = 1703,
                    ["image"] = 1410972,
                    ["name"] = "奈珊卓拉",
                }, -- [1]
                {
                    ["id"] = 1738,
                    ["image"] = 1410960,
                    ["name"] = "『腐化之心』伊蓋諾斯",
                }, -- [2]
                {
                    ["id"] = 1744,
                    ["image"] = 1410947,
                    ["name"] = "艾樂瑞斯‧雷弗拉爾",
                }, -- [3]
                {
                    ["id"] = 1667,
                    ["image"] = 1410991,
                    ["name"] = "厄索克",
                }, -- [4]
                {
                    ["id"] = 1704,
                    ["image"] = 1410945,
                    ["name"] = "夢魘之龍",
                }, -- [5]
                {
                    ["id"] = 1750,
                    ["image"] = 1410940,
                    ["name"] = "塞納留斯",
                }, -- [6]
                {
                    ["id"] = 1726,
                    ["image"] = 1410994,
                    ["name"] = "薩維斯",
                }, -- [7]
            },
        }, -- [2]
        {
            ["id"] = 861,
            ["image"] = 1537284,
            ["name"] = "勇氣試煉",
            ["bosses"] = {
                {
                    ["id"] = 1819,
                    ["image"] = 1410974,
                    ["name"] = "歐丁",
                }, -- [1]
                {
                    ["id"] = 1830,
                    ["image"] = 1536491,
                    ["name"] = "加爾姆",
                }, -- [2]
                {
                    ["id"] = 1829,
                    ["image"] = 1410957,
                    ["name"] = "黑爾雅",
                }, -- [3]
            },
        }, -- [3]
        {
            ["id"] = 786,
            ["image"] = 1450575,
            ["name"] = "暗夜堡",
            ["bosses"] = {
                {
                    ["id"] = 1706,
                    ["image"] = 1410981,
                    ["name"] = "斯寇派隆",
                }, -- [1]
                {
                    ["id"] = 1725,
                    ["image"] = 1410941,
                    ["name"] = "時光異象",
                }, -- [2]
                {
                    ["id"] = 1731,
                    ["image"] = 1410989,
                    ["name"] = "提里埃斯",
                }, -- [3]
                {
                    ["id"] = 1751,
                    ["image"] = 1410983,
                    ["name"] = "法刃艾露莉亞",
                }, -- [4]
                {
                    ["id"] = 1762,
                    ["image"] = 1410987,
                    ["name"] = "提克迪奧斯",
                }, -- [5]
                {
                    ["id"] = 1713,
                    ["image"] = 1410965,
                    ["name"] = "克羅索斯",
                }, -- [6]
                {
                    ["id"] = 1761,
                    ["image"] = 1410939,
                    ["name"] = "大植物學家泰亞恩",
                }, -- [7]
                {
                    ["id"] = 1732,
                    ["image"] = 1410984,
                    ["name"] = "星占師伊崔斯",
                }, -- [8]
                {
                    ["id"] = 1743,
                    ["image"] = 1410954,
                    ["name"] = "大博學者艾莉珊德",
                }, -- [9]
                {
                    ["id"] = 1737,
                    ["image"] = 1410955,
                    ["name"] = "古爾丹",
                }, -- [10]
            },
        }, -- [4]
        {
            ["id"] = 875,
            ["image"] = 1616106,
            ["name"] = "薩格拉斯之墓",
            ["bosses"] = {
                {
                    ["id"] = 1862,
                    ["image"] = 1579934,
                    ["name"] = "苟洛斯",
                }, -- [1]
                {
                    ["id"] = 1867,
                    ["image"] = 1579936,
                    ["name"] = "惡魔審判官",
                }, -- [2]
                {
                    ["id"] = 1856,
                    ["image"] = 1579940,
                    ["name"] = "哈亞潭",
                }, -- [3]
                {
                    ["id"] = 1903,
                    ["image"] = 1579935,
                    ["name"] = "月光議會",
                }, -- [4]
                {
                    ["id"] = 1861,
                    ["image"] = 1579939,
                    ["name"] = "薩絲茵女士",
                }, -- [5]
                {
                    ["id"] = 1896,
                    ["image"] = 1579943,
                    ["name"] = "荒寂聚合體",
                }, -- [6]
                {
                    ["id"] = 1897,
                    ["image"] = 1579933,
                    ["name"] = "戒守聖女",
                }, -- [7]
                {
                    ["id"] = 1873,
                    ["image"] = 1579932,
                    ["name"] = "墮落化身",
                }, -- [8]
                {
                    ["id"] = 1898,
                    ["image"] = 1385746,
                    ["name"] = "基爾加丹",
                }, -- [9]
            },
        }, -- [5]
        {
            ["id"] = 959,
            ["image"] = 1718212,
            ["name"] = "侵略點",
            ["bosses"] = {
                {
                    ["id"] = 2010,
                    ["image"] = 1715215,
                    ["name"] = "鬼母佛努娜",
                }, -- [1]
                {
                    ["id"] = 2011,
                    ["image"] = 1715216,
                    ["name"] = "魔女雅露拉黛兒",
                }, -- [2]
                {
                    ["id"] = 2012,
                    ["image"] = 1715212,
                    ["name"] = "審判官梅托",
                }, -- [3]
                {
                    ["id"] = 2013,
                    ["image"] = 1715217,
                    ["name"] = "歐庫雷洛斯",
                }, -- [4]
                {
                    ["id"] = 2014,
                    ["image"] = 1715221,
                    ["name"] = "梭塔納索",
                }, -- [5]
                {
                    ["id"] = 2015,
                    ["image"] = 1715218,
                    ["name"] = "深淵領主邪莫斯",
                }, -- [6]
            },
        }, -- [6]
        {
            ["id"] = 946,
            ["image"] = 1718211,
            ["name"] = "安托洛斯，燃燒王座",
            ["bosses"] = {
                {
                    ["id"] = 1992,
                    ["image"] = 1715210,
                    ["name"] = "加洛斯碎界者",
                }, -- [1]
                {
                    ["id"] = 1987,
                    ["image"] = 1715209,
                    ["name"] = "薩格拉斯惡魔犬",
                }, -- [2]
                {
                    ["id"] = 1997,
                    ["image"] = 1715225,
                    ["name"] = "安托洛斯至高戰事議會",
                }, -- [3]
                {
                    ["id"] = 1985,
                    ["image"] = 1715219,
                    ["name"] = "『守門者』海瑟貝爾",
                }, -- [4]
                {
                    ["id"] = 2025,
                    ["image"] = 1715208,
                    ["name"] = "『生命守縛者』伊歐娜",
                }, -- [5]
                {
                    ["id"] = 2009,
                    ["image"] = 1715211,
                    ["name"] = "『獵魂者』伊莫納爾",
                }, -- [6]
                {
                    ["id"] = 2004,
                    ["image"] = 1715213,
                    ["name"] = "金加洛斯",
                }, -- [7]
                {
                    ["id"] = 1983,
                    ["image"] = 1715223,
                    ["name"] = "瓦里瑪薩斯",
                }, -- [8]
                {
                    ["id"] = 1986,
                    ["image"] = 1715222,
                    ["name"] = "希瓦拉巫女",
                }, -- [9]
                {
                    ["id"] = 1984,
                    ["image"] = 1715207,
                    ["name"] = "阿格拉瑪",
                }, -- [10]
                {
                    ["id"] = 2031,
                    ["image"] = 1715536,
                    ["name"] = "『滅界者』阿古斯",
                }, -- [11]
            },
        }, -- [7]
        {
            ["id"] = 945,
            ["image"] = 1718213,
            ["name"] = "三傑議會之座",
            ["bosses"] = {
                {
                    ["id"] = 1979,
                    ["image"] = 1715226,
                    ["name"] = "『超凡者』祖拉爾",
                }, -- [1]
                {
                    ["id"] = 1980,
                    ["image"] = 1715220,
                    ["name"] = "賽普瑞許",
                }, -- [2]
                {
                    ["id"] = 1981,
                    ["image"] = 1715224,
                    ["name"] = "副將聶薩",
                }, -- [3]
                {
                    ["id"] = 1982,
                    ["image"] = 1715214,
                    ["name"] = "路拉",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 767,
            ["image"] = 1450574,
            ["name"] = "奈薩里奧巢穴",
            ["bosses"] = {
                {
                    ["id"] = 1662,
                    ["image"] = 1410976,
                    ["name"] = "羅克摩拉",
                }, -- [1]
                {
                    ["id"] = 1665,
                    ["image"] = 1410990,
                    ["name"] = "烏拉羅格‧塑崖者",
                }, -- [2]
                {
                    ["id"] = 1673,
                    ["image"] = 1410971,
                    ["name"] = "納拉薩斯",
                }, -- [3]
                {
                    ["id"] = 1687,
                    ["image"] = 1410944,
                    ["name"] = "『地底之王』達古爾",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 726,
            ["image"] = 1411857,
            ["name"] = "幽暗地道",
            ["bosses"] = {
                {
                    ["id"] = 1497,
                    ["image"] = 1410963,
                    ["name"] = "伊凡爾",
                }, -- [1]
                {
                    ["id"] = 1498,
                    ["image"] = 1410943,
                    ["name"] = "寇斯提拉斯",
                }, -- [2]
                {
                    ["id"] = 1499,
                    ["image"] = 1410951,
                    ["name"] = "薩卡爾將軍",
                }, -- [3]
                {
                    ["id"] = 1500,
                    ["image"] = 1410970,
                    ["name"] = "納爾提拉",
                }, -- [4]
                {
                    ["id"] = 1501,
                    ["image"] = 1410934,
                    ["name"] = "諫言者凡卓斯",
                }, -- [5]
            },
        }, -- [10]
        {
            ["id"] = 762,
            ["image"] = 1411855,
            ["name"] = "暗心灌木林",
            ["bosses"] = {
                {
                    ["id"] = 1654,
                    ["image"] = 1410936,
                    ["name"] = "大德魯伊葛萊達利斯",
                }, -- [1]
                {
                    ["id"] = 1655,
                    ["image"] = 1410973,
                    ["name"] = "橡心",
                }, -- [2]
                {
                    ["id"] = 1656,
                    ["image"] = 1410946,
                    ["name"] = "德瑞薩隆",
                }, -- [3]
                {
                    ["id"] = 1657,
                    ["image"] = 1410979,
                    ["name"] = "薩維斯之影",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 900,
            ["image"] = 1616922,
            ["name"] = "永夜聖殿",
            ["bosses"] = {
                {
                    ["id"] = 1905,
                    ["image"] = 1579930,
                    ["name"] = "阿格諾斯",
                }, -- [1]
                {
                    ["id"] = 1906,
                    ["image"] = 1579942,
                    ["name"] = "『厭惡者』痛咬",
                }, -- [2]
                {
                    ["id"] = 1904,
                    ["image"] = 1579931,
                    ["name"] = "多瑪崔斯",
                }, -- [3]
                {
                    ["id"] = 1878,
                    ["image"] = 1579938,
                    ["name"] = "梅菲斯托",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 740,
            ["image"] = 1411853,
            ["name"] = "玄鴉堡",
            ["bosses"] = {
                {
                    ["id"] = 1518,
                    ["image"] = 1410986,
                    ["name"] = "眾魂融合體",
                }, -- [1]
                {
                    ["id"] = 1653,
                    ["image"] = 1410961,
                    ["name"] = "伊麗珊娜‧黑羽",
                }, -- [2]
                {
                    ["id"] = 1664,
                    ["image"] = 1410982,
                    ["name"] = "『憎恨者』惡擊",
                }, -- [3]
                {
                    ["id"] = 1672,
                    ["image"] = 1410967,
                    ["name"] = "克塔羅斯‧黑羽堡主",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 707,
            ["image"] = 1411858,
            ["name"] = "看守者鐵獄",
            ["bosses"] = {
                {
                    ["id"] = 1467,
                    ["image"] = 1410988,
                    ["name"] = "泰拉松‧薩瑟里",
                }, -- [1]
                {
                    ["id"] = 1695,
                    ["image"] = 1410962,
                    ["name"] = "酷刑審判官",
                }, -- [2]
                {
                    ["id"] = 1468,
                    ["image"] = 1410937,
                    ["name"] = "艾胥貢",
                }, -- [3]
                {
                    ["id"] = 1469,
                    ["image"] = 1410952,
                    ["name"] = "格雷瑟",
                }, -- [4]
                {
                    ["id"] = 1470,
                    ["image"] = 1410942,
                    ["name"] = "寇達娜‧魔歌",
                }, -- [5]
            },
        }, -- [14]
        {
            ["id"] = 800,
            ["image"] = 1498156,
            ["name"] = "眾星之廷",
            ["bosses"] = {
                {
                    ["id"] = 1718,
                    ["image"] = 1410975,
                    ["name"] = "巡邏隊長葛陀",
                }, -- [1]
                {
                    ["id"] = 1719,
                    ["image"] = 1410985,
                    ["name"] = "塔莉仙‧火冠",
                }, -- [2]
                {
                    ["id"] = 1720,
                    ["image"] = 1410933,
                    ["name"] = "諫言者梅朗卓斯",
                }, -- [3]
            },
        }, -- [15]
        {
            ["id"] = 777,
            ["image"] = 1498155,
            ["name"] = "紫羅蘭堡之襲",
            ["bosses"] = {
                {
                    ["id"] = 1693,
                    ["image"] = 1410950,
                    ["name"] = "膿臉",
                }, -- [1]
                {
                    ["id"] = 1694,
                    ["image"] = 1410980,
                    ["name"] = "顫喉",
                }, -- [2]
                {
                    ["id"] = 1702,
                    ["image"] = 1410938,
                    ["name"] = "血腥公主薩蕾娜",
                }, -- [3]
                {
                    ["id"] = 1686,
                    ["image"] = 1410969,
                    ["name"] = "笞靈者卡哈杰",
                }, -- [4]
                {
                    ["id"] = 1688,
                    ["image"] = 1410968,
                    ["name"] = "米歐菲瑟‧曼納斯頓",
                }, -- [5]
                {
                    ["id"] = 1696,
                    ["image"] = 1410935,
                    ["name"] = "阿努貝賽特",
                }, -- [6]
                {
                    ["id"] = 1697,
                    ["image"] = 1410977,
                    ["name"] = "賽蘿恩",
                }, -- [7]
                {
                    ["id"] = 1711,
                    ["image"] = 1410948,
                    ["name"] = "惡魔領主貝楚格",
                }, -- [8]
            },
        }, -- [16]
        {
            ["id"] = 716,
            ["image"] = 1498157,
            ["name"] = "艾薩拉之眼",
            ["bosses"] = {
                {
                    ["id"] = 1480,
                    ["image"] = 1410992,
                    ["name"] = "督軍帕傑許",
                }, -- [1]
                {
                    ["id"] = 1490,
                    ["image"] = 1410966,
                    ["name"] = "盤恨女士",
                }, -- [2]
                {
                    ["id"] = 1491,
                    ["image"] = 1410964,
                    ["name"] = "深鬍子大王",
                }, -- [3]
                {
                    ["id"] = 1479,
                    ["image"] = 1410978,
                    ["name"] = "巨鱗蛇",
                }, -- [4]
                {
                    ["id"] = 1492,
                    ["image"] = 1410993,
                    ["name"] = "艾薩拉之怒",
                }, -- [5]
            },
        }, -- [17]
        {
            ["id"] = 721,
            ["image"] = 1498158,
            ["name"] = "英靈殿",
            ["bosses"] = {
                {
                    ["id"] = 1485,
                    ["image"] = 1410958,
                    ["name"] = "海姆達爾",
                }, -- [1]
                {
                    ["id"] = 1486,
                    ["image"] = 1410959,
                    ["name"] = "海爾珈",
                }, -- [2]
                {
                    ["id"] = 1487,
                    ["image"] = 1410949,
                    ["name"] = "芬里爾",
                }, -- [3]
                {
                    ["id"] = 1488,
                    ["image"] = 1410953,
                    ["name"] = "神御之王斯寇瓦德",
                }, -- [4]
                {
                    ["id"] = 1489,
                    ["image"] = 1410974,
                    ["name"] = "歐丁",
                }, -- [5]
            },
        }, -- [18]
        {
            ["id"] = 860,
            ["image"] = 1537283,
            ["name"] = "重返卡拉贊",
            ["bosses"] = {
                {
                    ["id"] = 1820,
                    ["image"] = 1536495,
                    ["name"] = "歌劇大廳：綠野巫蹤",
                }, -- [1]
                {
                    ["id"] = 1826,
                    ["image"] = 1536494,
                    ["name"] = "歌劇大廳：西荒故事",
                }, -- [2]
                {
                    ["id"] = 1827,
                    ["image"] = 1536493,
                    ["name"] = "歌劇大廳：美女與猛獸",
                }, -- [3]
                {
                    ["id"] = 1825,
                    ["image"] = 1378997,
                    ["name"] = "貞潔聖女",
                }, -- [4]
                {
                    ["id"] = 1835,
                    ["image"] = 1536490,
                    ["name"] = "獵人阿圖曼",
                }, -- [5]
                {
                    ["id"] = 1837,
                    ["image"] = 1378999,
                    ["name"] = "摩洛斯",
                }, -- [6]
                {
                    ["id"] = 1836,
                    ["image"] = 1379020,
                    ["name"] = "館長",
                }, -- [7]
                {
                    ["id"] = 1817,
                    ["image"] = 1536496,
                    ["name"] = "麥迪文之影",
                }, -- [8]
                {
                    ["id"] = 1818,
                    ["image"] = 1536492,
                    ["name"] = "法力吞噬者",
                }, -- [9]
                {
                    ["id"] = 1838,
                    ["image"] = 1536497,
                    ["name"] = "『監視者』維茲亞頓",
                }, -- [10]
            },
        }, -- [19]
        {
            ["id"] = 727,
            ["image"] = 1411856,
            ["name"] = "靈魂之喉",
            ["bosses"] = {
                {
                    ["id"] = 1502,
                    ["image"] = 1410995,
                    ["name"] = "『墮落之王』伊米倫",
                }, -- [1]
                {
                    ["id"] = 1512,
                    ["image"] = 1410956,
                    ["name"] = "赫柏隆",
                }, -- [2]
                {
                    ["id"] = 1663,
                    ["image"] = 1410957,
                    ["name"] = "黑爾雅",
                }, -- [3]
            },
        }, -- [20]
    },
    ["德拉諾之霸"] = {
        {
            ["id"] = 557,
            ["image"] = 1041995,
            ["name"] = "德拉諾",
            ["bosses"] = {
                {
                    ["id"] = 1291,
                    ["image"] = 1044483,
                    ["name"] = "『毀滅者』德羅夫",
                }, -- [1]
                {
                    ["id"] = 1211,
                    ["image"] = 1044371,
                    ["name"] = "『不朽者』塔爾納",
                }, -- [2]
                {
                    ["id"] = 1262,
                    ["image"] = 1044364,
                    ["name"] = "魯克馬爾",
                }, -- [3]
                {
                    ["id"] = 1452,
                    ["image"] = 1134508,
                    ["name"] = "至高領主卡札克",
                }, -- [4]
            },
        }, -- [1]
        {
            ["id"] = 477,
            ["image"] = 1041997,
            ["name"] = "天槌",
            ["bosses"] = {
                {
                    ["id"] = 1128,
                    ["image"] = 1044352,
                    ["name"] = "卡加斯‧刃拳",
                }, -- [1]
                {
                    ["id"] = 971,
                    ["image"] = 1044375,
                    ["name"] = "屠夫",
                }, -- [2]
                {
                    ["id"] = 1195,
                    ["image"] = 1044372,
                    ["name"] = "泰克塔",
                }, -- [3]
                {
                    ["id"] = 1196,
                    ["image"] = 1044342,
                    ["name"] = "綠蕨孢子巨人",
                }, -- [4]
                {
                    ["id"] = 1148,
                    ["image"] = 1044377,
                    ["name"] = "歐格隆雙胞胎",
                }, -- [5]
                {
                    ["id"] = 1153,
                    ["image"] = 1044343,
                    ["name"] = "寇拉夫",
                }, -- [6]
                {
                    ["id"] = 1197,
                    ["image"] = 1044349,
                    ["name"] = "統治者瑪爾戈克",
                }, -- [7]
            },
        }, -- [2]
        {
            ["id"] = 457,
            ["image"] = 1041993,
            ["name"] = "黑石鑄造場",
            ["bosses"] = {
                {
                    ["id"] = 1202,
                    ["image"] = 1044484,
                    ["name"] = "礦吞",
                }, -- [1]
                {
                    ["id"] = 1155,
                    ["image"] = 1044345,
                    ["name"] = "漢斯格爾和法蘭佐克",
                }, -- [2]
                {
                    ["id"] = 1122,
                    ["image"] = 1044338,
                    ["name"] = "獸王達馬克",
                }, -- [3]
                {
                    ["id"] = 1161,
                    ["image"] = 1044346,
                    ["name"] = "戈魯爾",
                }, -- [4]
                {
                    ["id"] = 1123,
                    ["image"] = 1044344,
                    ["name"] = "控火者卡格拉茲",
                }, -- [5]
                {
                    ["id"] = 1147,
                    ["image"] = 1044357,
                    ["name"] = "站長索加爾",
                }, -- [6]
                {
                    ["id"] = 1154,
                    ["image"] = 1044374,
                    ["name"] = "高爐",
                }, -- [7]
                {
                    ["id"] = 1162,
                    ["image"] = 1044353,
                    ["name"] = "克羅莫格",
                }, -- [8]
                {
                    ["id"] = 1203,
                    ["image"] = 1044350,
                    ["name"] = "鐵娘子軍",
                }, -- [9]
                {
                    ["id"] = 959,
                    ["image"] = 1044378,
                    ["name"] = "黑手",
                }, -- [10]
            },
        }, -- [3]
        {
            ["id"] = 669,
            ["image"] = 1135118,
            ["name"] = "地獄火堡壘",
            ["bosses"] = {
                {
                    ["id"] = 1426,
                    ["image"] = 1134502,
                    ["name"] = "地獄火突襲戰",
                }, -- [1]
                {
                    ["id"] = 1425,
                    ["image"] = 1134499,
                    ["name"] = "鋼鐵劫奪者",
                }, -- [2]
                {
                    ["id"] = 1392,
                    ["image"] = 1134504,
                    ["name"] = "寇姆洛克",
                }, -- [3]
                {
                    ["id"] = 1432,
                    ["image"] = 1134501,
                    ["name"] = "地獄火高階議會",
                }, -- [4]
                {
                    ["id"] = 1396,
                    ["image"] = 1134503,
                    ["name"] = "基爾羅格‧亡眼",
                }, -- [5]
                {
                    ["id"] = 1372,
                    ["image"] = 1134500,
                    ["name"] = "血魔",
                }, -- [6]
                {
                    ["id"] = 1433,
                    ["image"] = 1134506,
                    ["name"] = "暗影領主伊斯卡",
                }, -- [7]
                {
                    ["id"] = 1427,
                    ["image"] = 1134507,
                    ["name"] = "『永恆者』索奎薩爾",
                }, -- [8]
                {
                    ["id"] = 1391,
                    ["image"] = 1134498,
                    ["name"] = "惡魔領主札昆",
                }, -- [9]
                {
                    ["id"] = 1447,
                    ["image"] = 1134510,
                    ["name"] = "祖霍拉克",
                }, -- [10]
                {
                    ["id"] = 1394,
                    ["image"] = 1134509,
                    ["name"] = "女暴君維哈里",
                }, -- [11]
                {
                    ["id"] = 1395,
                    ["image"] = 1134505,
                    ["name"] = "瑪諾洛斯",
                }, -- [12]
                {
                    ["id"] = 1438,
                    ["image"] = 1134497,
                    ["name"] = "阿克蒙德",
                }, -- [13]
            },
        }, -- [4]
        {
            ["id"] = 547,
            ["image"] = 1041992,
            ["name"] = "奧齊頓",
            ["bosses"] = {
                {
                    ["id"] = 1185,
                    ["image"] = 1044336,
                    ["name"] = "警覺的卡薩爾",
                }, -- [1]
                {
                    ["id"] = 1186,
                    ["image"] = 1044370,
                    ["name"] = "縛魂者妮雅蜜",
                }, -- [2]
                {
                    ["id"] = 1216,
                    ["image"] = 1044337,
                    ["name"] = "阿扎克爾",
                }, -- [3]
                {
                    ["id"] = 1225,
                    ["image"] = 1044373,
                    ["name"] = "泰朗戈爾",
                }, -- [4]
            },
        }, -- [5]
        {
            ["id"] = 537,
            ["image"] = 1041998,
            ["name"] = "影月墓地",
            ["bosses"] = {
                {
                    ["id"] = 1139,
                    ["image"] = 1044366,
                    ["name"] = "莎妲娜‧血怒",
                }, -- [1]
                {
                    ["id"] = 1168,
                    ["image"] = 1053564,
                    ["name"] = "納里旭",
                }, -- [2]
                {
                    ["id"] = 1140,
                    ["image"] = 1044341,
                    ["name"] = "骨喉",
                }, -- [3]
                {
                    ["id"] = 1160,
                    ["image"] = 1044356,
                    ["name"] = "耐祖奧",
                }, -- [4]
            },
        }, -- [6]
        {
            ["id"] = 536,
            ["image"] = 1041996,
            ["name"] = "恐軌車站",
            ["bosses"] = {
                {
                    ["id"] = 1138,
                    ["image"] = 1044360,
                    ["name"] = "火箭光和波爾卡",
                }, -- [1]
                {
                    ["id"] = 1163,
                    ["image"] = 1044339,
                    ["name"] = "奈楚格‧雷塔",
                }, -- [2]
                {
                    ["id"] = 1133,
                    ["image"] = 1044376,
                    ["name"] = "傲天者托芙菈",
                }, -- [3]
            },
        }, -- [7]
        {
            ["id"] = 476,
            ["image"] = 1041999,
            ["name"] = "擎天峰",
            ["bosses"] = {
                {
                    ["id"] = 965,
                    ["image"] = 1044362,
                    ["name"] = "蘭吉特",
                }, -- [1]
                {
                    ["id"] = 966,
                    ["image"] = 1044334,
                    ["name"] = "阿拉卡納斯",
                }, -- [2]
                {
                    ["id"] = 967,
                    ["image"] = 1044365,
                    ["name"] = "盧克然",
                }, -- [3]
                {
                    ["id"] = 968,
                    ["image"] = 1044348,
                    ["name"] = "大賢者維瑞思",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 556,
            ["image"] = 1060547,
            ["name"] = "永茂林",
            ["bosses"] = {
                {
                    ["id"] = 1214,
                    ["image"] = 1044381,
                    ["name"] = "枯木",
                }, -- [1]
                {
                    ["id"] = 1207,
                    ["image"] = 1053563,
                    ["name"] = "古樹保衛者",
                }, -- [2]
                {
                    ["id"] = 1208,
                    ["image"] = 1044335,
                    ["name"] = "大法師蘇兒",
                }, -- [3]
                {
                    ["id"] = 1209,
                    ["image"] = 1044382,
                    ["name"] = "榭里塔克",
                }, -- [4]
                {
                    ["id"] = 1210,
                    ["image"] = 1044383,
                    ["name"] = "亞爾努",
                }, -- [5]
            },
        }, -- [9]
        {
            ["id"] = 385,
            ["image"] = 1041994,
            ["name"] = "血槌熔渣礦場",
            ["bosses"] = {
                {
                    ["id"] = 893,
                    ["image"] = 1044355,
                    ["name"] = "瑪格默拉圖斯",
                }, -- [1]
                {
                    ["id"] = 888,
                    ["image"] = 1044368,
                    ["name"] = "奴隸看守者庫拉多",
                }, -- [2]
                {
                    ["id"] = 887,
                    ["image"] = 1044363,
                    ["name"] = "洛托爾",
                }, -- [3]
                {
                    ["id"] = 889,
                    ["image"] = 1044347,
                    ["name"] = "古格洛克",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 558,
            ["image"] = 1060548,
            ["name"] = "鋼鐵碼頭",
            ["bosses"] = {
                {
                    ["id"] = 1235,
                    ["image"] = 1044380,
                    ["name"] = "『血肉撕裂者』諾加爾",
                }, -- [1]
                {
                    ["id"] = 1236,
                    ["image"] = 1044340,
                    ["name"] = "恐軌執行者",
                }, -- [2]
                {
                    ["id"] = 1237,
                    ["image"] = 1044359,
                    ["name"] = "歐席爾",
                }, -- [3]
                {
                    ["id"] = 1238,
                    ["image"] = 1044367,
                    ["name"] = "史庫洛克",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 559,
            ["image"] = 1042000,
            ["name"] = "黑石塔上層",
            ["bosses"] = {
                {
                    ["id"] = 1226,
                    ["image"] = 1044358,
                    ["name"] = "控礦者古拉杉",
                }, -- [1]
                {
                    ["id"] = 1227,
                    ["image"] = 1044354,
                    ["name"] = "凱拉克",
                }, -- [2]
                {
                    ["id"] = 1228,
                    ["image"] = 1044351,
                    ["name"] = "指揮官薩貝克",
                }, -- [3]
                {
                    ["id"] = 1229,
                    ["image"] = 1044361,
                    ["name"] = "狂野的怒翼",
                }, -- [4]
                {
                    ["id"] = 1234,
                    ["image"] = 1044379,
                    ["name"] = "札伊拉酋長",
                }, -- [5]
            },
        }, -- [12]
    },
    ["潘達利亞之謎"] = {
        {
            ["id"] = 322,
            ["image"] = 652218,
            ["name"] = "潘達利亞",
            ["bosses"] = {
                {
                    ["id"] = 691,
                    ["image"] = 630847,
                    ["name"] = "憤怒之煞",
                }, -- [1]
                {
                    ["id"] = 725,
                    ["image"] = 630819,
                    ["name"] = "沙利斯的劫掠兵團",
                }, -- [2]
                {
                    ["id"] = 814,
                    ["image"] = 796778,
                    ["name"] = "『風暴龍王』納拉卡",
                }, -- [3]
                {
                    ["id"] = 826,
                    ["image"] = 796779,
                    ["name"] = "烏達斯塔",
                }, -- [4]
                {
                    ["id"] = 857,
                    ["image"] = 901155,
                    ["name"] = "『紅鶴』赤吉",
                }, -- [5]
                {
                    ["id"] = 858,
                    ["image"] = 901173,
                    ["name"] = "『玉蛟』玉龍",
                }, -- [6]
                {
                    ["id"] = 859,
                    ["image"] = 901165,
                    ["name"] = "『玄牛』怒兆",
                }, -- [7]
                {
                    ["id"] = 860,
                    ["image"] = 901172,
                    ["name"] = "『白虎』雪怒",
                }, -- [8]
                {
                    ["id"] = 861,
                    ["image"] = 901167,
                    ["name"] = "『揚古火神』歐朵斯",
                }, -- [9]
            },
        }, -- [1]
        {
            ["id"] = 317,
            ["image"] = 632273,
            ["name"] = "魔古山寶庫",
            ["bosses"] = {
                {
                    ["id"] = 679,
                    ["image"] = 630820,
                    ["name"] = "石衛士",
                }, -- [1]
                {
                    ["id"] = 689,
                    ["image"] = 630824,
                    ["name"] = "『咒魔』馮",
                }, -- [2]
                {
                    ["id"] = 682,
                    ["image"] = 630826,
                    ["name"] = "『縛靈者』卡拉賈",
                }, -- [3]
                {
                    ["id"] = 687,
                    ["image"] = 630861,
                    ["name"] = "帝王之魂",
                }, -- [4]
                {
                    ["id"] = 726,
                    ["image"] = 630823,
                    ["name"] = "艾拉岡",
                }, -- [5]
                {
                    ["id"] = 677,
                    ["image"] = 630836,
                    ["name"] = "大帝之志",
                }, -- [6]
            },
        }, -- [2]
        {
            ["id"] = 330,
            ["image"] = 632271,
            ["name"] = "恐懼之心",
            ["bosses"] = {
                {
                    ["id"] = 745,
                    ["image"] = 630834,
                    ["name"] = "女皇大臣索拉格",
                }, -- [1]
                {
                    ["id"] = 744,
                    ["image"] = 630817,
                    ["name"] = "刀鋒領主塔亞克",
                }, -- [2]
                {
                    ["id"] = 713,
                    ["image"] = 630827,
                    ["name"] = "加拉隆",
                }, -- [3]
                {
                    ["id"] = 741,
                    ["image"] = 630856,
                    ["name"] = "風領主瑪爾加拉克",
                }, -- [4]
                {
                    ["id"] = 737,
                    ["image"] = 630815,
                    ["name"] = "塑珀者翁索克",
                }, -- [5]
                {
                    ["id"] = 743,
                    ["image"] = 630830,
                    ["name"] = "杉齊爾女皇",
                }, -- [6]
            },
        }, -- [3]
        {
            ["id"] = 320,
            ["image"] = 643264,
            ["name"] = "豐泉台",
            ["bosses"] = {
                {
                    ["id"] = 683,
                    ["image"] = 630844,
                    ["name"] = "豐泉守衛者",
                }, -- [1]
                {
                    ["id"] = 742,
                    ["image"] = 630854,
                    ["name"] = "楚龍",
                }, -- [2]
                {
                    ["id"] = 729,
                    ["image"] = 630837,
                    ["name"] = "蕾希",
                }, -- [3]
                {
                    ["id"] = 709,
                    ["image"] = 630849,
                    ["name"] = "恐懼之煞",
                }, -- [4]
            },
        }, -- [4]
        {
            ["id"] = 362,
            ["image"] = 828453,
            ["name"] = "雷霆王座",
            ["bosses"] = {
                {
                    ["id"] = 827,
                    ["image"] = 796776,
                    ["name"] = "『擊破者』金羅克",
                }, -- [1]
                {
                    ["id"] = 819,
                    ["image"] = 796774,
                    ["name"] = "哈里登",
                }, -- [2]
                {
                    ["id"] = 816,
                    ["image"] = 796770,
                    ["name"] = "長老議會",
                }, -- [3]
                {
                    ["id"] = 825,
                    ["image"] = 796781,
                    ["name"] = "托爾托斯",
                }, -- [4]
                {
                    ["id"] = 821,
                    ["image"] = 796786,
                    ["name"] = "梅賈拉",
                }, -- [5]
                {
                    ["id"] = 828,
                    ["image"] = 796785,
                    ["name"] = "稷坤",
                }, -- [6]
                {
                    ["id"] = 818,
                    ["image"] = 796772,
                    ["name"] = "『遺忘之眼』獨顱目",
                }, -- [7]
                {
                    ["id"] = 820,
                    ["image"] = 796780,
                    ["name"] = "普莫迪斯",
                }, -- [8]
                {
                    ["id"] = 824,
                    ["image"] = 796771,
                    ["name"] = "黑暗憎惡魔像",
                }, -- [9]
                {
                    ["id"] = 817,
                    ["image"] = 796775,
                    ["name"] = "鐵穹",
                }, -- [10]
                {
                    ["id"] = 829,
                    ["image"] = 796773,
                    ["name"] = "孤慍雙絕",
                }, -- [11]
                {
                    ["id"] = 832,
                    ["image"] = 796777,
                    ["name"] = "雷神",
                }, -- [12]
            },
        }, -- [5]
        {
            ["id"] = 369,
            ["image"] = 904981,
            ["name"] = "圍攻奧格瑪",
            ["bosses"] = {
                {
                    ["id"] = 852,
                    ["image"] = 901160,
                    ["name"] = "伊莫爾西斯",
                }, -- [1]
                {
                    ["id"] = 849,
                    ["image"] = 901159,
                    ["name"] = "墮落的保衛者",
                }, -- [2]
                {
                    ["id"] = 866,
                    ["image"] = 901166,
                    ["name"] = "諾努衫",
                }, -- [3]
                {
                    ["id"] = 867,
                    ["image"] = 901168,
                    ["name"] = "傲慢之煞",
                }, -- [4]
                {
                    ["id"] = 868,
                    ["image"] = 901156,
                    ["name"] = "葛拉卡斯",
                }, -- [5]
                {
                    ["id"] = 864,
                    ["image"] = 901161,
                    ["name"] = "鋼鐵破滅邪神",
                }, -- [6]
                {
                    ["id"] = 856,
                    ["image"] = 901163,
                    ["name"] = "柯爾克隆黑暗薩滿",
                }, -- [7]
                {
                    ["id"] = 850,
                    ["image"] = 901158,
                    ["name"] = "納茲格寧姆將軍",
                }, -- [8]
                {
                    ["id"] = 846,
                    ["image"] = 901164,
                    ["name"] = "馬可羅克",
                }, -- [9]
                {
                    ["id"] = 870,
                    ["image"] = 901170,
                    ["name"] = "潘達利亞之寶",
                }, -- [10]
                {
                    ["id"] = 851,
                    ["image"] = 901171,
                    ["name"] = "『嗜血巨龍』梭克",
                }, -- [11]
                {
                    ["id"] = 865,
                    ["image"] = 901169,
                    ["name"] = "攻城機匠黑引信",
                }, -- [12]
                {
                    ["id"] = 853,
                    ["image"] = 901162,
                    ["name"] = "卡拉西聖螳",
                }, -- [13]
                {
                    ["id"] = 869,
                    ["image"] = 901157,
                    ["name"] = "卡爾洛斯‧地獄吼",
                }, -- [14]
            },
        }, -- [6]
        {
            ["id"] = 324,
            ["image"] = 643263,
            ["name"] = "圍攻怒兆寺",
            ["bosses"] = {
                {
                    ["id"] = 693,
                    ["image"] = 630855,
                    ["name"] = "大臣金巴克",
                }, -- [1]
                {
                    ["id"] = 738,
                    ["image"] = 630822,
                    ["name"] = "指揮官沃賈克",
                }, -- [2]
                {
                    ["id"] = 692,
                    ["image"] = 630829,
                    ["name"] = "帕伐拉克將軍",
                }, -- [3]
                {
                    ["id"] = 727,
                    ["image"] = 630857,
                    ["name"] = "飛翼領袖紐若納克",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 312,
            ["image"] = 632274,
            ["name"] = "影潘僧院",
            ["bosses"] = {
                {
                    ["id"] = 673,
                    ["image"] = 630831,
                    ["name"] = "古‧雲擊",
                }, -- [1]
                {
                    ["id"] = 657,
                    ["image"] = 630841,
                    ["name"] = "雪迅大師",
                }, -- [2]
                {
                    ["id"] = 685,
                    ["image"] = 630850,
                    ["name"] = "暴力之煞",
                }, -- [3]
                {
                    ["id"] = 686,
                    ["image"] = 630852,
                    ["name"] = "塔蘭‧祝",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 313,
            ["image"] = 632276,
            ["name"] = "玉蛟寺",
            ["bosses"] = {
                {
                    ["id"] = 672,
                    ["image"] = 630858,
                    ["name"] = "智者瑪利",
                }, -- [1]
                {
                    ["id"] = 664,
                    ["image"] = 630840,
                    ["name"] = "博學行者石步",
                }, -- [2]
                {
                    ["id"] = 658,
                    ["image"] = 630839,
                    ["name"] = "劉‧焰心",
                }, -- [3]
                {
                    ["id"] = 335,
                    ["image"] = 630848,
                    ["name"] = "疑惑之煞",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 303,
            ["image"] = 632270,
            ["name"] = "落陽關",
            ["bosses"] = {
                {
                    ["id"] = 655,
                    ["image"] = 630846,
                    ["name"] = "『破壞者』奇普提拉克",
                }, -- [1]
                {
                    ["id"] = 675,
                    ["image"] = 630851,
                    ["name"] = "打擊者卡多克",
                }, -- [2]
                {
                    ["id"] = 676,
                    ["image"] = 630821,
                    ["name"] = "指揮官黎莫克",
                }, -- [3]
                {
                    ["id"] = 649,
                    ["image"] = 630845,
                    ["name"] = "雷剛",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 316,
            ["image"] = 608214,
            ["name"] = "血色修道院",
            ["bosses"] = {
                {
                    ["id"] = 688,
                    ["image"] = 630853,
                    ["name"] = "『靈魂撕裂者』薩爾諾斯",
                }, -- [1]
                {
                    ["id"] = 671,
                    ["image"] = 630818,
                    ["name"] = "克羅夫修士",
                }, -- [2]
                {
                    ["id"] = 674,
                    ["image"] = 607643,
                    ["name"] = "高階審判官懷特邁恩",
                }, -- [3]
            },
        }, -- [11]
        {
            ["id"] = 311,
            ["image"] = 643262,
            ["name"] = "血色大廳",
            ["bosses"] = {
                {
                    ["id"] = 660,
                    ["image"] = 630833,
                    ["name"] = "馴犬者布勞恩",
                }, -- [1]
                {
                    ["id"] = 654,
                    ["image"] = 630816,
                    ["name"] = "武器大師哈倫",
                }, -- [2]
                {
                    ["id"] = 656,
                    ["image"] = 630825,
                    ["name"] = "織焰者喀格勒",
                }, -- [3]
            },
        }, -- [12]
        {
            ["id"] = 246,
            ["image"] = 608215,
            ["name"] = "通靈學院",
            ["bosses"] = {
                {
                    ["id"] = 659,
                    ["image"] = 630835,
                    ["name"] = "講師冷心",
                }, -- [1]
                {
                    ["id"] = 663,
                    ["image"] = 607666,
                    ["name"] = "詹迪斯‧巴羅夫",
                }, -- [2]
                {
                    ["id"] = 665,
                    ["image"] = 607755,
                    ["name"] = "血骨傀儡",
                }, -- [3]
                {
                    ["id"] = 666,
                    ["image"] = 630838,
                    ["name"] = "莉莉安‧佛斯",
                }, -- [4]
                {
                    ["id"] = 684,
                    ["image"] = 607582,
                    ["name"] = "黑暗院長加丁",
                }, -- [5]
            },
        }, -- [13]
        {
            ["id"] = 302,
            ["image"] = 632275,
            ["name"] = "風暴烈酒酒坊",
            ["bosses"] = {
                {
                    ["id"] = 668,
                    ["image"] = 630843,
                    ["name"] = "歐克‧歐克",
                }, -- [1]
                {
                    ["id"] = 669,
                    ["image"] = 630832,
                    ["name"] = "跳跳巨兔妖",
                }, -- [2]
                {
                    ["id"] = 670,
                    ["image"] = 630860,
                    ["name"] = "『破罈者』嚴祝",
                }, -- [3]
            },
        }, -- [14]
        {
            ["id"] = 321,
            ["image"] = 632272,
            ["name"] = "魔古山宮",
            ["bosses"] = {
                {
                    ["id"] = 708,
                    ["image"] = 630842,
                    ["name"] = "帝王的試煉",
                }, -- [1]
                {
                    ["id"] = 690,
                    ["image"] = 630828,
                    ["name"] = "蓋肯",
                }, -- [2]
                {
                    ["id"] = 698,
                    ["image"] = 630859,
                    ["name"] = "『武器大師』辛",
                }, -- [3]
            },
        }, -- [15]
    },
    ["巫妖王之怒"] = {
        {
            ["id"] = 753,
            ["image"] = 1396596,
            ["name"] = "亞夏梵穹殿",
            ["bosses"] = {
                {
                    ["id"] = 1597,
                    ["image"] = 1385715,
                    ["name"] = "『石之看守者』亞夏梵",
                }, -- [1]
                {
                    ["id"] = 1598,
                    ["image"] = 1385727,
                    ["name"] = "『風暴看守者』艾瑪隆",
                }, -- [2]
                {
                    ["id"] = 1599,
                    ["image"] = 1385748,
                    ["name"] = "『烈焰看守者』寇拉隆",
                }, -- [3]
                {
                    ["id"] = 1600,
                    ["image"] = 1385767,
                    ["name"] = "『寒冰看守者』拓拉梵",
                }, -- [4]
            },
        }, -- [1]
        {
            ["id"] = 754,
            ["image"] = 1396587,
            ["name"] = "納克薩瑪斯",
            ["bosses"] = {
                {
                    ["id"] = 1601,
                    ["image"] = 1378964,
                    ["name"] = "阿努比瑞克漢",
                }, -- [1]
                {
                    ["id"] = 1602,
                    ["image"] = 1378980,
                    ["name"] = "大寡婦費琳娜",
                }, -- [2]
                {
                    ["id"] = 1603,
                    ["image"] = 1378994,
                    ["name"] = "梅克絲娜",
                }, -- [3]
                {
                    ["id"] = 1604,
                    ["image"] = 1379004,
                    ["name"] = "『瘟疫使者』諾斯",
                }, -- [4]
                {
                    ["id"] = 1605,
                    ["image"] = 1378984,
                    ["name"] = "『不潔者』海根",
                }, -- [5]
                {
                    ["id"] = 1606,
                    ["image"] = 1378991,
                    ["name"] = "憎恨者",
                }, -- [6]
                {
                    ["id"] = 1607,
                    ["image"] = 1378988,
                    ["name"] = "講師拉祖維斯",
                }, -- [7]
                {
                    ["id"] = 1608,
                    ["image"] = 1378979,
                    ["name"] = "『收割者』高希",
                }, -- [8]
                {
                    ["id"] = 1609,
                    ["image"] = 1385732,
                    ["name"] = "四騎士",
                }, -- [9]
                {
                    ["id"] = 1610,
                    ["image"] = 1379005,
                    ["name"] = "縫補者",
                }, -- [10]
                {
                    ["id"] = 1611,
                    ["image"] = 1378981,
                    ["name"] = "葛羅巴斯",
                }, -- [11]
                {
                    ["id"] = 1612,
                    ["image"] = 1378977,
                    ["name"] = "古魯斯",
                }, -- [12]
                {
                    ["id"] = 1613,
                    ["image"] = 1379019,
                    ["name"] = "泰迪斯",
                }, -- [13]
                {
                    ["id"] = 1614,
                    ["image"] = 1379010,
                    ["name"] = "薩菲隆",
                }, -- [14]
                {
                    ["id"] = 1615,
                    ["image"] = 1378989,
                    ["name"] = "科爾蘇加德",
                }, -- [15]
            },
        }, -- [2]
        {
            ["id"] = 755,
            ["image"] = 1396588,
            ["name"] = "黑曜聖所",
            ["bosses"] = {
                {
                    ["id"] = 1616,
                    ["image"] = 1385765,
                    ["name"] = "撒爾薩里安",
                }, -- [1]
            },
        }, -- [3]
        {
            ["id"] = 756,
            ["image"] = 1396581,
            ["name"] = "永恆之眼",
            ["bosses"] = {
                {
                    ["id"] = 1617,
                    ["image"] = 1385753,
                    ["name"] = "瑪里苟斯",
                }, -- [1]
            },
        }, -- [4]
        {
            ["id"] = 759,
            ["image"] = 1396595,
            ["name"] = "奧杜亞",
            ["bosses"] = {
                {
                    ["id"] = 1637,
                    ["image"] = 1385731,
                    ["name"] = "烈焰戰輪",
                }, -- [1]
                {
                    ["id"] = 1638,
                    ["image"] = 1385742,
                    ["name"] = "『火爐之主』伊格尼司",
                }, -- [2]
                {
                    ["id"] = 1639,
                    ["image"] = 1385763,
                    ["name"] = "銳鱗",
                }, -- [3]
                {
                    ["id"] = 1640,
                    ["image"] = 1385773,
                    ["name"] = "XT-002拆解者",
                }, -- [4]
                {
                    ["id"] = 1641,
                    ["image"] = 1390439,
                    ["name"] = "鐵之集會",
                }, -- [5]
                {
                    ["id"] = 1642,
                    ["image"] = 1385747,
                    ["name"] = "柯洛剛恩",
                }, -- [6]
                {
                    ["id"] = 1643,
                    ["image"] = 1385717,
                    ["name"] = "奧芮雅",
                }, -- [7]
                {
                    ["id"] = 1644,
                    ["image"] = 1385740,
                    ["name"] = "霍迪爾",
                }, -- [8]
                {
                    ["id"] = 1645,
                    ["image"] = 1385770,
                    ["name"] = "索林姆",
                }, -- [9]
                {
                    ["id"] = 1646,
                    ["image"] = 1385733,
                    ["name"] = "芙蕾雅",
                }, -- [10]
                {
                    ["id"] = 1647,
                    ["image"] = 1385754,
                    ["name"] = "彌米倫",
                }, -- [11]
                {
                    ["id"] = 1648,
                    ["image"] = 1385735,
                    ["name"] = "威札斯將軍",
                }, -- [12]
                {
                    ["id"] = 1649,
                    ["image"] = 1385774,
                    ["name"] = "尤格薩倫",
                }, -- [13]
                {
                    ["id"] = 1650,
                    ["image"] = 1385713,
                    ["name"] = "『觀察者』艾爾加隆",
                }, -- [14]
            },
        }, -- [5]
        {
            ["id"] = 757,
            ["image"] = 1396594,
            ["name"] = "十字軍試煉",
            ["bosses"] = {
                {
                    ["id"] = 1618,
                    ["image"] = 1390440,
                    ["name"] = "北裂境野獸",
                }, -- [1]
                {
                    ["id"] = 1619,
                    ["image"] = 1385752,
                    ["name"] = "賈拉克瑟斯領主",
                }, -- [2]
                {
                    ["id"] = Cell.vars.playerFaction == "Horde" and 1620 or 1621,
                    ["image"] = Cell.vars.playerFaction == "Horde" and 1390442 or 1390441,
                    ["name"] = Cell.vars.playerFaction == "Horde" and "聯盟勇士" or "部落勇士",
                }, -- [3]
                {
                    ["id"] = 1622,
                    ["image"] = 1390443,
                    ["name"] = "華爾琪雙子",
                }, -- [4]
                {
                    ["id"] = 1623,
                    ["image"] = 607542,
                    ["name"] = "阿努巴拉克",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 760,
            ["image"] = 1396589,
            ["name"] = "奧妮克希亞的巢穴",
            ["bosses"] = {
                {
                    ["id"] = 1651,
                    ["image"] = 1379025,
                    ["name"] = "奧妮克希亞",
                }, -- [1]
            },
        }, -- [7]
        {
            ["id"] = 758,
            ["image"] = 1396583,
            ["name"] = "冰冠城塞",
            ["bosses"] = {
                {
                    ["id"] = 1624,
                    ["image"] = 1378992,
                    ["name"] = "瑪洛嘉領主",
                }, -- [1]
                {
                    ["id"] = 1625,
                    ["image"] = 1378990,
                    ["name"] = "亡語女士",
                }, -- [2]
                {
                    ["id"] = 1627,
                    ["image"] = 1385736,
                    ["name"] = "冰冠城塞砲艇戰",
                }, -- [3]
                {
                    ["id"] = 1628,
                    ["image"] = 1378970,
                    ["name"] = "死亡使者薩魯法爾",
                }, -- [4]
                {
                    ["id"] = 1629,
                    ["image"] = 1378972,
                    ["name"] = "膿腸",
                }, -- [5]
                {
                    ["id"] = 1630,
                    ["image"] = 1379009,
                    ["name"] = "腐臉",
                }, -- [6]
                {
                    ["id"] = 1631,
                    ["image"] = 1379007,
                    ["name"] = "普崔希德教授",
                }, -- [7]
                {
                    ["id"] = 1632,
                    ["image"] = 1385721,
                    ["name"] = "血親王議會",
                }, -- [8]
                {
                    ["id"] = 1633,
                    ["image"] = 1378967,
                    ["name"] = "血腥女王菈娜薩爾",
                }, -- [9]
                {
                    ["id"] = 1634,
                    ["image"] = 1379023,
                    ["name"] = "瓦莉絲瑞雅‧夢行者",
                }, -- [10]
                {
                    ["id"] = 1635,
                    ["image"] = 1379014,
                    ["name"] = "辛德拉苟莎",
                }, -- [11]
                {
                    ["id"] = 1636,
                    ["image"] = 607688,
                    ["name"] = "巫妖王",
                }, -- [12]
            },
        }, -- [8]
        {
            ["id"] = 761,
            ["image"] = 1396590,
            ["name"] = "晶紅聖所",
            ["bosses"] = {
                {
                    ["id"] = 1652,
                    ["image"] = 1385738,
                    ["name"] = "海萊恩",
                }, -- [1]
            },
        }, -- [9]
        {
            ["id"] = 286,
            ["image"] = 608227,
            ["name"] = "俄特加德之巔",
            ["bosses"] = {
                {
                    ["id"] = 641,
                    ["image"] = 607778,
                    ["name"] = "絲瓦拉‧悲傷亡墓",
                }, -- [1]
                {
                    ["id"] = 642,
                    ["image"] = 607620,
                    ["name"] = "戈托克‧白蹄",
                }, -- [2]
                {
                    ["id"] = 643,
                    ["image"] = 607773,
                    ["name"] = "無情的斯卡迪",
                }, -- [3]
                {
                    ["id"] = 644,
                    ["image"] = 607674,
                    ["name"] = "依米倫王",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 285,
            ["image"] = 608226,
            ["name"] = "俄特加德要塞",
            ["bosses"] = {
                {
                    ["id"] = 638,
                    ["image"] = 607743,
                    ["name"] = "凱雷希斯親王",
                }, -- [1]
                {
                    ["id"] = 639,
                    ["image"] = 607774,
                    ["name"] = "史卡沃&達隆恩",
                }, -- [2]
                {
                    ["id"] = 640,
                    ["image"] = 607659,
                    ["name"] = "『盜掠者』因格瓦",
                }, -- [3]
            },
        }, -- [11]
        {
            ["id"] = 276,
            ["image"] = 608205,
            ["name"] = "倒影大廳",
            ["bosses"] = {
                {
                    ["id"] = 601,
                    ["image"] = 607601,
                    ["name"] = "法勒瑞克",
                }, -- [1]
                {
                    ["id"] = 602,
                    ["image"] = 607710,
                    ["name"] = "麥爾溫",
                }, -- [2]
                {
                    ["id"] = 603,
                    ["image"] = 607688,
                    ["name"] = "逃離阿薩斯",
                }, -- [3]
            },
        }, -- [12]
        {
            ["id"] = 274,
            ["image"] = 608203,
            ["name"] = "剛德拉克",
            ["bosses"] = {
                {
                    ["id"] = 592,
                    ["image"] = 607776,
                    ["name"] = "史拉德銳",
                }, -- [1]
                {
                    ["id"] = 593,
                    ["image"] = 607589,
                    ["name"] = "德拉克瑞巨像",
                }, -- [2]
                {
                    ["id"] = 594,
                    ["image"] = 607716,
                    ["name"] = "慕拉比",
                }, -- [3]
                {
                    ["id"] = 595,
                    ["image"] = 607592,
                    ["name"] = "『兇猛』埃克",
                }, -- [4]
                {
                    ["id"] = 596,
                    ["image"] = 607605,
                    ["name"] = "蓋爾達拉",
                }, -- [5]
            },
        }, -- [13]
        {
            ["id"] = 284,
            ["image"] = 608224,
            ["name"] = "勇士試煉",
            ["bosses"] = {
                {
                    ["id"] = 834,
                    ["image"] = 607621,
                    ["name"] = "大勇士",
                }, -- [1]
                {
                    ["id"] = 635,
                    ["image"] = 607591,
                    ["name"] = "『純淨者』埃卓克",
                }, -- [2]
                {
                    ["id"] = 636,
                    ["image"] = 607547,
                    ["name"] = "銀白告解者帕爾璀絲",
                }, -- [3]
                {
                    ["id"] = 637,
                    ["image"] = 607787,
                    ["name"] = "黑騎士",
                }, -- [4]
            },
        }, -- [14]
        {
            ["id"] = 281,
            ["image"] = 608221,
            ["name"] = "奧核之心",
            ["bosses"] = {
                {
                    ["id"] = Cell.vars.playerFaction == "Horde" and 617 or 833,
                    ["image"] = Cell.vars.playerFaction == "Horde" and 607571 or 607568,
                    ["name"] = Cell.vars.playerFaction == "Horde" and "指揮官厚鬚" or "指揮官寇勒格",
                }, -- [1]
                {
                    ["id"] = 618,
                    ["image"] = 607623,
                    ["name"] = "大魔導師特雷斯翠",
                }, -- [2]
                {
                    ["id"] = 619,
                    ["image"] = 607540,
                    ["name"] = "艾諾瑪路斯",
                }, -- [3]
                {
                    ["id"] = 620,
                    ["image"] = 607735,
                    ["name"] = "『塑樹者』歐爾莫洛克",
                }, -- [4]
                {
                    ["id"] = 621,
                    ["image"] = 607671,
                    ["name"] = "凱瑞史卓莎",
                }, -- [5]
            },
        }, -- [15]
        {
            ["id"] = 282,
            ["image"] = 608222,
            ["name"] = "奧核之眼",
            ["bosses"] = {
                {
                    ["id"] = 622,
                    ["image"] = 607590,
                    ["name"] = "『審問者』德拉高斯",
                }, -- [1]
                {
                    ["id"] = 623,
                    ["image"] = 607802,
                    ["name"] = "瓦羅斯‧雲行者",
                }, -- [2]
                {
                    ["id"] = 624,
                    ["image"] = 607702,
                    ["name"] = "法師領主厄隆",
                }, -- [3]
                {
                    ["id"] = 625,
                    ["image"] = 607687,
                    ["name"] = "地脈守護者伊瑞茍斯",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 271,
            ["image"] = 608192,
            ["name"] = "安卡罕特：古王國",
            ["bosses"] = {
                {
                    ["id"] = 580,
                    ["image"] = 607593,
                    ["name"] = "那杜斯長老",
                }, -- [1]
                {
                    ["id"] = 581,
                    ["image"] = 607744,
                    ["name"] = "泰爾達朗親王",
                }, -- [2]
                {
                    ["id"] = 582,
                    ["image"] = 607667,
                    ["name"] = "潔杜佳‧尋影者",
                }, -- [3]
                {
                    ["id"] = 583,
                    ["image"] = 607534,
                    ["name"] = "毒蕈魔",
                }, -- [4]
                {
                    ["id"] = 584,
                    ["image"] = 607639,
                    ["name"] = "信使沃菈齊",
                }, -- [5]
            },
        }, -- [17]
        {
            ["id"] = 273,
            ["image"] = 608201,
            ["name"] = "德拉克薩隆要塞",
            ["bosses"] = {
                {
                    ["id"] = 588,
                    ["image"] = 607798,
                    ["name"] = "血角食人妖",
                }, -- [1]
                {
                    ["id"] = 589,
                    ["image"] = 607727,
                    ["name"] = "『召喚者』諾沃司",
                }, -- [2]
                {
                    ["id"] = 590,
                    ["image"] = 607672,
                    ["name"] = "崔德王",
                }, -- [3]
                {
                    ["id"] = 591,
                    ["image"] = 607790,
                    ["name"] = "預言者薩隆杰",
                }, -- [4]
            },
        }, -- [18]
        {
            ["id"] = 279,
            ["image"] = 608219,
            ["name"] = "斯坦索姆的抉擇",
            ["bosses"] = {
                {
                    ["id"] = 611,
                    ["image"] = 607711,
                    ["name"] = "肉鉤",
                }, -- [1]
                {
                    ["id"] = 612,
                    ["image"] = 607763,
                    ["name"] = "『血肉工匠』塞歐朗姆",
                }, -- [2]
                {
                    ["id"] = 613,
                    ["image"] = 607567,
                    ["name"] = "紀元時間領主",
                }, -- [3]
                {
                    ["id"] = 614,
                    ["image"] = 607708,
                    ["name"] = "瑪爾加尼斯",
                }, -- [4]
            },
        }, -- [19]
        {
            ["id"] = 280,
            ["image"] = 608220,
            ["name"] = "眾魂熔爐",
            ["bosses"] = {
                {
                    ["id"] = 615,
                    ["image"] = 607559,
                    ["name"] = "布朗吉姆",
                }, -- [1]
                {
                    ["id"] = 616,
                    ["image"] = 607585,
                    ["name"] = "眾魂吞噬者",
                }, -- [2]
            },
        }, -- [20]
        {
            ["id"] = 277,
            ["image"] = 608206,
            ["name"] = "石之大廳",
            ["bosses"] = {
                {
                    ["id"] = 604,
                    ["image"] = 607679,
                    ["name"] = "克利斯托魯斯",
                }, -- [1]
                {
                    ["id"] = 605,
                    ["image"] = 607706,
                    ["name"] = "悲嘆少女",
                }, -- [2]
                {
                    ["id"] = 606,
                    ["image"] = 607797,
                    ["name"] = "歲月議庭",
                }, -- [3]
                {
                    ["id"] = 607,
                    ["image"] = 607772,
                    ["name"] = "『塑鐵者』斯雍尼爾",
                }, -- [4]
            },
        }, -- [21]
        {
            ["id"] = 283,
            ["image"] = 608228,
            ["name"] = "紫羅蘭堡",
            ["bosses"] = {
                {
                    ["id"] = 626,
                    ["image"] = 607597,
                    ["name"] = "伊銳坎",
                }, -- [1]
                {
                    ["id"] = 627,
                    ["image"] = 607717,
                    ["name"] = "摩拉革",
                }, -- [2]
                {
                    ["id"] = 628,
                    ["image"] = 607654,
                    ["name"] = "艾克膿",
                }, -- [3]
                {
                    ["id"] = 629,
                    ["image"] = 607821,
                    ["name"] = "基沃滋",
                }, -- [4]
                {
                    ["id"] = 630,
                    ["image"] = 607685,
                    ["name"] = "拉方索",
                }, -- [5]
                {
                    ["id"] = 631,
                    ["image"] = 607825,
                    ["name"] = "『消滅者』舒拉邁特",
                }, -- [6]
                {
                    ["id"] = 632,
                    ["image"] = 607573,
                    ["name"] = "霞妮苟莎",
                }, -- [7]
            },
        }, -- [22]
        {
            ["id"] = 278,
            ["image"] = 608210,
            ["name"] = "薩倫之淵",
            ["bosses"] = {
                {
                    ["id"] = 608,
                    ["image"] = 607603,
                    ["name"] = "鍛造大師加弗羅斯",
                }, -- [1]
                {
                    ["id"] = 609,
                    ["image"] = 607677,
                    ["name"] = "艾克與克瑞克",
                }, -- [2]
                {
                    ["id"] = 610,
                    ["image"] = 607765,
                    ["name"] = "天譴領主提朗紐斯",
                }, -- [3]
            },
        }, -- [23]
        {
            ["id"] = 272,
            ["image"] = 608194,
            ["name"] = "阿茲歐-奈幽",
            ["bosses"] = {
                {
                    ["id"] = 585,
                    ["image"] = 607678,
                    ["name"] = "『守門者』齊力克西爾",
                }, -- [1]
                {
                    ["id"] = 586,
                    ["image"] = 607633,
                    ["name"] = "哈卓諾克斯",
                }, -- [2]
                {
                    ["id"] = 587,
                    ["image"] = 607542,
                    ["name"] = "阿努巴拉克",
                }, -- [3]
            },
        }, -- [24]
        {
            ["id"] = 275,
            ["image"] = 608204,
            ["name"] = "雷光大廳",
            ["bosses"] = {
                {
                    ["id"] = 597,
                    ["image"] = 607611,
                    ["name"] = "畢亞格林將軍",
                }, -- [1]
                {
                    ["id"] = 598,
                    ["image"] = 607809,
                    ["name"] = "渥克瀚",
                }, -- [2]
                {
                    ["id"] = 599,
                    ["image"] = 607663,
                    ["name"] = "埃歐納",
                }, -- [3]
                {
                    ["id"] = 600,
                    ["image"] = 607690,
                    ["name"] = "洛肯",
                }, -- [4]
            },
        }, -- [25]
    },
    ["浩劫與重生"] = {
        {
            ["id"] = 75,
            ["image"] = 522349,
            ["name"] = "巴拉丁堡",
            ["bosses"] = {
                {
                    ["id"] = 139,
                    ["image"] = 522198,
                    ["name"] = "阿加羅斯",
                }, -- [1]
                {
                    ["id"] = 140,
                    ["image"] = 523207,
                    ["name"] = "歐庫薩",
                }, -- [2]
                {
                    ["id"] = 339,
                    ["image"] = 571742,
                    ["name"] = "『仇恨仕女』阿利札巴",
                }, -- [3]
            },
        }, -- [1]
        {
            ["id"] = 74,
            ["image"] = 522359,
            ["name"] = "四風王座",
            ["bosses"] = {
                {
                    ["id"] = 154,
                    ["image"] = 522196,
                    ["name"] = "風之議會",
                }, -- [1]
                {
                    ["id"] = 155,
                    ["image"] = 522191,
                    ["name"] = "奧拉基爾",
                }, -- [2]
            },
        }, -- [2]
        {
            ["id"] = 72,
            ["image"] = 522355,
            ["name"] = "暮光堡壘",
            ["bosses"] = {
                {
                    ["id"] = 156,
                    ["image"] = 522232,
                    ["name"] = "哈福斯‧破龍者",
                }, -- [1]
                {
                    ["id"] = 157,
                    ["image"] = 522274,
                    ["name"] = "瑟拉里恩和瓦莉歐娜",
                }, -- [2]
                {
                    ["id"] = 158,
                    ["image"] = 522224,
                    ["name"] = "卓越者議會",
                }, -- [3]
                {
                    ["id"] = 167,
                    ["image"] = 522212,
                    ["name"] = "丘加利",
                }, -- [4]
            },
        }, -- [3]
        {
            ["id"] = 73,
            ["image"] = 522351,
            ["name"] = "黑翼陷窟",
            ["bosses"] = {
                {
                    ["id"] = 169,
                    ["image"] = 522250,
                    ["name"] = "全能魔像防衛系統",
                }, -- [1]
                {
                    ["id"] = 170,
                    ["image"] = 522251,
                    ["name"] = "熔喉",
                }, -- [2]
                {
                    ["id"] = 171,
                    ["image"] = 522202,
                    ["name"] = "亞特拉米德",
                }, -- [3]
                {
                    ["id"] = 172,
                    ["image"] = 522211,
                    ["name"] = "奇瑪隆",
                }, -- [4]
                {
                    ["id"] = 173,
                    ["image"] = 522252,
                    ["name"] = "瑪洛里亞克",
                }, -- [5]
                {
                    ["id"] = 174,
                    ["image"] = 522255,
                    ["name"] = "奈法利安的末路",
                }, -- [6]
            },
        }, -- [4]
        {
            ["id"] = 78,
            ["image"] = 522353,
            ["name"] = "火源之界",
            ["bosses"] = {
                {
                    ["id"] = 192,
                    ["image"] = 522208,
                    ["name"] = "貝絲堤拉克",
                }, -- [1]
                {
                    ["id"] = 193,
                    ["image"] = 522248,
                    ["name"] = "萊爾利斯領主",
                }, -- [2]
                {
                    ["id"] = 194,
                    ["image"] = 522193,
                    ["name"] = "艾里絲拉卓",
                }, -- [3]
                {
                    ["id"] = 195,
                    ["image"] = 522268,
                    ["name"] = "夏諾克斯",
                }, -- [4]
                {
                    ["id"] = 196,
                    ["image"] = 522204,
                    ["name"] = "巴勒羅克，守門人",
                }, -- [5]
                {
                    ["id"] = 197,
                    ["image"] = 522223,
                    ["name"] = "管理者鹿盔",
                }, -- [6]
                {
                    ["id"] = 198,
                    ["image"] = 522261,
                    ["name"] = "拉格納羅斯",
                }, -- [7]
            },
        }, -- [5]
        {
            ["id"] = 187,
            ["image"] = 571753,
            ["name"] = "巨龍之魂",
            ["bosses"] = {
                {
                    ["id"] = 311,
                    ["image"] = 536058,
                    ["name"] = "魔寇",
                }, -- [1]
                {
                    ["id"] = 324,
                    ["image"] = 536061,
                    ["name"] = "督軍松奧茲",
                }, -- [2]
                {
                    ["id"] = 325,
                    ["image"] = 536062,
                    ["name"] = "未眠者尤沙吉",
                }, -- [3]
                {
                    ["id"] = 317,
                    ["image"] = 536057,
                    ["name"] = "『暴風守縛者』哈甲拉",
                }, -- [4]
                {
                    ["id"] = 331,
                    ["image"] = 571750,
                    ["name"] = "奧特拉賽恩",
                }, -- [5]
                {
                    ["id"] = 332,
                    ["image"] = 571752,
                    ["name"] = "將領黑角",
                }, -- [6]
                {
                    ["id"] = 318,
                    ["image"] = 536056,
                    ["name"] = "死亡之翼的脊椎",
                }, -- [7]
                {
                    ["id"] = 333,
                    ["image"] = 536055,
                    ["name"] = "死亡之翼的狂亂",
                }, -- [8]
            },
        }, -- [6]
        {
            ["id"] = 64,
            ["image"] = 522358,
            ["name"] = "影牙城堡",
            ["bosses"] = {
                {
                    ["id"] = 96,
                    ["image"] = 522205,
                    ["name"] = "艾胥柏利男爵",
                }, -- [1]
                {
                    ["id"] = 97,
                    ["image"] = 522206,
                    ["name"] = "席瓦萊恩男爵",
                }, -- [2]
                {
                    ["id"] = 98,
                    ["image"] = 522213,
                    ["name"] = "指揮官斯普林瓦爾",
                }, -- [3]
                {
                    ["id"] = 99,
                    ["image"] = 522249,
                    ["name"] = "瓦爾登領主",
                }, -- [4]
                {
                    ["id"] = 100,
                    ["image"] = 522247,
                    ["name"] = "高佛雷領主",
                }, -- [5]
            },
        }, -- [7]
        {
            ["id"] = 69,
            ["image"] = 522357,
            ["name"] = "托維爾的失落之城",
            ["bosses"] = {
                {
                    ["id"] = 117,
                    ["image"] = 523205,
                    ["name"] = "胡薩姆將軍",
                }, -- [1]
                {
                    ["id"] = 118,
                    ["image"] = 522246,
                    ["name"] = "鎖喉",
                }, -- [2]
                {
                    ["id"] = 119,
                    ["image"] = 522239,
                    ["name"] = "高階預言者巴瑞姆",
                }, -- [3]
                {
                    ["id"] = 122,
                    ["image"] = 522269,
                    ["name"] = "希亞梅特",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 186,
            ["image"] = 571755,
            ["name"] = "暮光之時",
            ["bosses"] = {
                {
                    ["id"] = 322,
                    ["image"] = 571743,
                    ["name"] = "阿奇里森",
                }, -- [1]
                {
                    ["id"] = 342,
                    ["image"] = 536054,
                    ["name"] = "阿希拉黎明殺戮者",
                }, -- [2]
                {
                    ["id"] = 341,
                    ["image"] = 536053,
                    ["name"] = "大主教本尼迪塔斯",
                }, -- [3]
            },
        }, -- [9]
        {
            ["id"] = 71,
            ["image"] = 522354,
            ["name"] = "格瑞姆巴托",
            ["bosses"] = {
                {
                    ["id"] = 131,
                    ["image"] = 522227,
                    ["name"] = "昂布里斯將軍",
                }, -- [1]
                {
                    ["id"] = 132,
                    ["image"] = 522226,
                    ["name"] = "鍛造大師瑟隆葛斯",
                }, -- [2]
                {
                    ["id"] = 133,
                    ["image"] = 522218,
                    ["name"] = "德拉卡‧燃影者",
                }, -- [3]
                {
                    ["id"] = 134,
                    ["image"] = 522222,
                    ["name"] = "伊魯達克斯，地獄公爵",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 63,
            ["image"] = 522352,
            ["name"] = "死亡礦坑",
            ["bosses"] = {
                {
                    ["id"] = 89,
                    ["image"] = 522228,
                    ["name"] = "格魯巴托克",
                }, -- [1]
                {
                    ["id"] = 90,
                    ["image"] = 522234,
                    ["name"] = "赫利克斯‧碎輪者",
                }, -- [2]
                {
                    ["id"] = 91,
                    ["image"] = 522225,
                    ["name"] = "敵人收割者5000型",
                }, -- [3]
                {
                    ["id"] = 92,
                    ["image"] = 522189,
                    ["name"] = "利普斯納爾上將",
                }, -- [4]
                {
                    ["id"] = 93,
                    ["image"] = 522210,
                    ["name"] = "『船長』餅乾",
                }, -- [5]
            },
        }, -- [11]
        {
            ["id"] = 185,
            ["image"] = 571756,
            ["name"] = "永恆之井",
            ["bosses"] = {
                {
                    ["id"] = 290,
                    ["image"] = 536060,
                    ["name"] = "佩洛薩恩",
                }, -- [1]
                {
                    ["id"] = 291,
                    ["image"] = 571747,
                    ["name"] = "艾薩拉女王",
                }, -- [2]
                {
                    ["id"] = 292,
                    ["image"] = 571746,
                    ["name"] = "瑪諾洛斯與瓦羅森",
                }, -- [3]
            },
        }, -- [12]
        {
            ["id"] = 65,
            ["image"] = 522362,
            ["name"] = "海潮王座",
            ["bosses"] = {
                {
                    ["id"] = 101,
                    ["image"] = 522245,
                    ["name"] = "納茲賈爾女士",
                }, -- [1]
                {
                    ["id"] = 102,
                    ["image"] = 522214,
                    ["name"] = "指揮官烏索克，膿瘡王子",
                }, -- [2]
                {
                    ["id"] = 103,
                    ["image"] = 522253,
                    ["name"] = "屈心者哥爾薩",
                }, -- [3]
                {
                    ["id"] = 104,
                    ["image"] = 522259,
                    ["name"] = "歐蘇瑪特",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 68,
            ["image"] = 522361,
            ["name"] = "漩渦尖塔",
            ["bosses"] = {
                {
                    ["id"] = 114,
                    ["image"] = 522229,
                    ["name"] = "首相伊爾丹",
                }, -- [1]
                {
                    ["id"] = 115,
                    ["image"] = 522192,
                    ["name"] = "艾塔伊洛斯",
                }, -- [2]
                {
                    ["id"] = 116,
                    ["image"] = 522200,
                    ["name"] = "『微風統治者』亞沙德",
                }, -- [3]
            },
        }, -- [14]
        {
            ["id"] = 67,
            ["image"] = 522360,
            ["name"] = "石岩之心",
            ["bosses"] = {
                {
                    ["id"] = 110,
                    ["image"] = 522215,
                    ["name"] = "寇伯拉斯",
                }, -- [1]
                {
                    ["id"] = 111,
                    ["image"] = 522271,
                    ["name"] = "岩革",
                }, -- [2]
                {
                    ["id"] = 112,
                    ["image"] = 522258,
                    ["name"] = "歐茲魯克",
                }, -- [3]
                {
                    ["id"] = 113,
                    ["image"] = 522237,
                    ["name"] = "高階祭司艾吉兒",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 76,
            ["image"] = 522364,
            ["name"] = "祖爾格拉布",
            ["bosses"] = {
                {
                    ["id"] = 175,
                    ["image"] = 522236,
                    ["name"] = "高階祭司溫諾希斯",
                }, -- [1]
                {
                    ["id"] = 176,
                    ["image"] = 522209,
                    ["name"] = "血領主曼多基爾",
                }, -- [2]
                {
                    ["id"] = 177,
                    ["image"] = 522230,
                    ["name"] = "狂性儲納所:格里雷克",
                }, -- [3]
                {
                    ["id"] = 178,
                    ["image"] = 522233,
                    ["name"] = "狂性儲納所:哈札拉爾",
                }, -- [4]
                {
                    ["id"] = 179,
                    ["image"] = 522263,
                    ["name"] = "狂性儲納所:雷納塔基",
                }, -- [5]
                {
                    ["id"] = 180,
                    ["image"] = 522279,
                    ["name"] = "狂性儲納所:烏蘇雷",
                }, -- [6]
                {
                    ["id"] = 181,
                    ["image"] = 522238,
                    ["name"] = "高階祭司基爾娜拉",
                }, -- [7]
                {
                    ["id"] = 184,
                    ["image"] = 522280,
                    ["name"] = "贊吉爾",
                }, -- [8]
                {
                    ["id"] = 185,
                    ["image"] = 522243,
                    ["name"] = "破神者金度",
                }, -- [9]
            },
        }, -- [16]
        {
            ["id"] = 77,
            ["image"] = 522363,
            ["name"] = "祖阿曼",
            ["bosses"] = {
                {
                    ["id"] = 186,
                    ["image"] = 522190,
                    ["name"] = "阿奇爾森",
                }, -- [1]
                {
                    ["id"] = 187,
                    ["image"] = 522254,
                    ["name"] = "納羅拉克",
                }, -- [2]
                {
                    ["id"] = 188,
                    ["image"] = 522242,
                    ["name"] = "賈納雷",
                }, -- [3]
                {
                    ["id"] = 189,
                    ["image"] = 522231,
                    ["name"] = "哈拉齊",
                }, -- [4]
                {
                    ["id"] = 190,
                    ["image"] = 522235,
                    ["name"] = "妖術領主瑪拉克雷斯",
                }, -- [5]
                {
                    ["id"] = 191,
                    ["image"] = 522217,
                    ["name"] = "達卡拉",
                }, -- [6]
            },
        }, -- [17]
        {
            ["id"] = 184,
            ["image"] = 571754,
            ["name"] = "終焉之刻",
            ["bosses"] = {
                {
                    ["id"] = 340,
                    ["image"] = 571744,
                    ["name"] = "貝恩的回音",
                }, -- [1]
                {
                    ["id"] = 285,
                    ["image"] = 571745,
                    ["name"] = "珍娜的回音",
                }, -- [2]
                {
                    ["id"] = 323,
                    ["image"] = 571748,
                    ["name"] = "希瓦娜斯的回音",
                }, -- [3]
                {
                    ["id"] = 283,
                    ["image"] = 571749,
                    ["name"] = "泰蘭妲的回音",
                }, -- [4]
                {
                    ["id"] = 289,
                    ["image"] = 536059,
                    ["name"] = "姆多茲諾",
                }, -- [5]
            },
        }, -- [18]
        {
            ["id"] = 70,
            ["image"] = 522356,
            ["name"] = "起源大廳",
            ["bosses"] = {
                {
                    ["id"] = 124,
                    ["image"] = 522272,
                    ["name"] = "神殿守護者安胡爾",
                }, -- [1]
                {
                    ["id"] = 125,
                    ["image"] = 522219,
                    ["name"] = "地怒者普塔",
                }, -- [2]
                {
                    ["id"] = 126,
                    ["image"] = 522195,
                    ["name"] = "安拉斐特",
                }, -- [3]
                {
                    ["id"] = 127,
                    ["image"] = 522241,
                    ["name"] = "伊希賽特，魔法造物",
                }, -- [4]
                {
                    ["id"] = 128,
                    ["image"] = 522194,
                    ["name"] = "安姆內，生命造物",
                }, -- [5]
                {
                    ["id"] = 129,
                    ["image"] = 522267,
                    ["name"] = "賽特胥，毀滅造物",
                }, -- [6]
                {
                    ["id"] = 130,
                    ["image"] = 522262,
                    ["name"] = "拉頡，太陽造物",
                }, -- [7]
            },
        }, -- [19]
        {
            ["id"] = 66,
            ["image"] = 522350,
            ["name"] = "黑石洞穴",
            ["bosses"] = {
                {
                    ["id"] = 105,
                    ["image"] = 522266,
                    ["name"] = "羅姆歐格‧裂骨者",
                }, -- [1]
                {
                    ["id"] = 106,
                    ["image"] = 522216,
                    ["name"] = "暮光信使柯爾菈",
                }, -- [2]
                {
                    ["id"] = 107,
                    ["image"] = 522244,
                    ["name"] = "卡爾許‧控鋼者",
                }, -- [3]
                {
                    ["id"] = 108,
                    ["image"] = 522207,
                    ["name"] = "美麗",
                }, -- [4]
                {
                    ["id"] = 109,
                    ["image"] = 522201,
                    ["name"] = "卓越者統領奧希迪厄斯",
                }, -- [5]
            },
        }, -- [20]
    },
    ["暗影之境"] = {
        {
            ["id"] = 1192,
            ["image"] = 3850569,
            ["name"] = "暗影之境",
            ["bosses"] = {
                {
                    ["id"] = 2430,
                    ["image"] = 3752195,
                    ["name"] = "瓦立諾，紀元光輝",
                }, -- [1]
                {
                    ["id"] = 2431,
                    ["image"] = 3752183,
                    ["name"] = "莫塔尼斯",
                }, -- [2]
                {
                    ["id"] = 2432,
                    ["image"] = 3752188,
                    ["name"] = "『恆枝』奧蘭諾莫諾斯",
                }, -- [3]
                {
                    ["id"] = 2433,
                    ["image"] = 3752187,
                    ["name"] = "『淤泥化身』納苟許",
                }, -- [4]
                {
                    ["id"] = 2456,
                    ["image"] = 4071436,
                    ["name"] = "『譴罪折磨者』莫傑斯",
                }, -- [5]
                {
                    ["id"] = 2468,
                    ["image"] = 4529365,
                    ["name"] = "安托斯",
                }, -- [6]
            },
        }, -- [1]
        {
            ["id"] = 1190,
            ["image"] = 3759906,
            ["name"] = "納撒亞城",
            ["bosses"] = {
                {
                    ["id"] = 2393,
                    ["image"] = 3752190,
                    ["name"] = "石嘯翼蝠",
                }, -- [1]
                {
                    ["id"] = 2429,
                    ["image"] = 3753151,
                    ["name"] = "獵人亞提默",
                }, -- [2]
                {
                    ["id"] = 2422,
                    ["image"] = 3753157,
                    ["name"] = "太陽之王的救贖",
                }, -- [3]
                {
                    ["id"] = 2418,
                    ["image"] = 3752156,
                    ["name"] = "工藝師希莫斯",
                }, -- [4]
                {
                    ["id"] = 2428,
                    ["image"] = 3752174,
                    ["name"] = "飢餓破壞者",
                }, -- [5]
                {
                    ["id"] = 2420,
                    ["image"] = 3752178,
                    ["name"] = "茵娜瓦‧暗脈女士",
                }, -- [6]
                {
                    ["id"] = 2426,
                    ["image"] = 3753159,
                    ["name"] = "血之議會",
                }, -- [7]
                {
                    ["id"] = 2394,
                    ["image"] = 3752191,
                    ["name"] = "泥拳",
                }, -- [8]
                {
                    ["id"] = 2425,
                    ["image"] = 3753156,
                    ["name"] = "石源魔軍團將軍",
                }, -- [9]
                {
                    ["id"] = 2424,
                    ["image"] = 3752159,
                    ["name"] = "戴納瑟斯王",
                }, -- [10]
            },
        }, -- [2]
        {
            ["id"] = 1193,
            ["image"] = 4182020,
            ["name"] = "統御聖所",
            ["bosses"] = {
                {
                    ["id"] = 2435,
                    ["image"] = 4071444,
                    ["name"] = "泰拉古魯",
                }, -- [1]
                {
                    ["id"] = 2442,
                    ["image"] = 4071426,
                    ["name"] = "獄主之眼",
                }, -- [2]
                {
                    ["id"] = 2439,
                    ["image"] = 4071445,
                    ["name"] = "九魂使",
                }, -- [3]
                {
                    ["id"] = 2444,
                    ["image"] = 4071439,
                    ["name"] = "耐祖奧的殘骸",
                }, -- [4]
                {
                    ["id"] = 2445,
                    ["image"] = 4071442,
                    ["name"] = "靈魂撕裂者多瑪贊",
                }, -- [5]
                {
                    ["id"] = 2443,
                    ["image"] = 4079051,
                    ["name"] = "苦痛工匠拉茲內爾",
                }, -- [6]
                {
                    ["id"] = 2446,
                    ["image"] = 4071428,
                    ["name"] = "首創者的守護者",
                }, -- [7]
                {
                    ["id"] = 2447,
                    ["image"] = 4071427,
                    ["name"] = "述命者羅卡洛",
                }, -- [8]
                {
                    ["id"] = 2440,
                    ["image"] = 4071435,
                    ["name"] = "科爾蘇加德",
                }, -- [9]
                {
                    ["id"] = 2441,
                    ["image"] = 4071443,
                    ["name"] = "希瓦娜斯‧風行者",
                }, -- [10]
            },
        }, -- [3]
        {
            ["id"] = 1195,
            ["image"] = 4423752,
            ["name"] = "首創者聖塚",
            ["bosses"] = {
                {
                    ["id"] = 2458,
                    ["image"] = 4465340,
                    ["name"] = "戒備守護者",
                }, -- [1]
                {
                    ["id"] = 2465,
                    ["image"] = 4465339,
                    ["name"] = "貪婪掠食者史寇雷斯",
                }, -- [2]
                {
                    ["id"] = 2470,
                    ["image"] = 4423749,
                    ["name"] = "工藝師希莫斯",
                }, -- [3]
                {
                    ["id"] = 2459,
                    ["image"] = 4465333,
                    ["name"] = "墮落神諭者達奧賽恩",
                }, -- [4]
                {
                    ["id"] = 2460,
                    ["image"] = 4465337,
                    ["name"] = "原型萬神殿",
                }, -- [5]
                {
                    ["id"] = 2461,
                    ["image"] = 4465335,
                    ["name"] = "首席設計者利胡敏",
                }, -- [6]
                {
                    ["id"] = 2463,
                    ["image"] = 4423738,
                    ["name"] = "回收者哈隆德魯斯",
                }, -- [7]
                {
                    ["id"] = 2469,
                    ["image"] = 4423747,
                    ["name"] = "安杜因‧烏瑞恩",
                }, -- [8]
                {
                    ["id"] = 2457,
                    ["image"] = 4465336,
                    ["name"] = "驚懼領主",
                }, -- [9]
                {
                    ["id"] = 2467,
                    ["image"] = 4465338,
                    ["name"] = "雷吉隆",
                }, -- [10]
                {
                    ["id"] = 2464,
                    ["image"] = 4465334,
                    ["name"] = "閻獄之主",
                }, -- [11]
            },
        }, -- [4]
        {
            ["id"] = 1194,
            ["image"] = 4182022,
            ["name"] = "『帷幕市集』塔札維許",
            ["bosses"] = {
                {
                    ["id"] = 2437,
                    ["image"] = 4071449,
                    ["name"] = "哨兵佐菲克斯",
                }, -- [1]
                {
                    ["id"] = 2454,
                    ["image"] = 4071447,
                    ["name"] = "大展示廳",
                }, -- [2]
                {
                    ["id"] = 2436,
                    ["image"] = 4071438,
                    ["name"] = "收發室大騷動",
                }, -- [3]
                {
                    ["id"] = 2452,
                    ["image"] = 4071448,
                    ["name"] = "奧彌薩的綠洲",
                }, -- [4]
                {
                    ["id"] = 2451,
                    ["image"] = 4071440,
                    ["name"] = "索阿茲米",
                }, -- [5]
                {
                    ["id"] = 2448,
                    ["image"] = 4071429,
                    ["name"] = "海布藍德",
                }, -- [6]
                {
                    ["id"] = 2449,
                    ["image"] = 4071446,
                    ["name"] = "時光船長鉤尾",
                }, -- [7]
                {
                    ["id"] = 2455,
                    ["image"] = 4071441,
                    ["name"] = "索利亞",
                }, -- [8]
            },
        }, -- [5]
        {
            ["id"] = 1188,
            ["image"] = 3759915,
            ["name"] = "彼界境地",
            ["bosses"] = {
                {
                    ["id"] = 2408,
                    ["image"] = 3752170,
                    ["name"] = "『奪魂者』哈卡",
                }, -- [1]
                {
                    ["id"] = 2409,
                    ["image"] = 3752193,
                    ["name"] = "曼納斯頓夫婦",
                }, -- [2]
                {
                    ["id"] = 2398,
                    ["image"] = 3753147,
                    ["name"] = "商人希夏",
                }, -- [3]
                {
                    ["id"] = 2410,
                    ["image"] = 3752184,
                    ["name"] = "繆薩拉",
                }, -- [4]
            },
        }, -- [6]
        {
            ["id"] = 1186,
            ["image"] = 3759913,
            ["name"] = "晉升之巔",
            ["bosses"] = {
                {
                    ["id"] = 2399,
                    ["image"] = 3752177,
                    ["name"] = "金塔拉",
                }, -- [1]
                {
                    ["id"] = 2416,
                    ["image"] = 3752198,
                    ["name"] = "溫圖納斯",
                }, -- [2]
                {
                    ["id"] = 2414,
                    ["image"] = 3752189,
                    ["name"] = "奧利菲翁",
                }, -- [3]
                {
                    ["id"] = 2412,
                    ["image"] = 3752160,
                    ["name"] = "『猜疑楷模』德沃絲",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 1182,
            ["image"] = 3759910,
            ["name"] = "死靈戰地",
            ["bosses"] = {
                {
                    ["id"] = 2395,
                    ["image"] = 3752157,
                    ["name"] = "荒骨",
                }, -- [1]
                {
                    ["id"] = 2391,
                    ["image"] = 3753146,
                    ["name"] = "『收割者』亞瑪斯",
                }, -- [2]
                {
                    ["id"] = 2392,
                    ["image"] = 3753158,
                    ["name"] = "縫補師縫肉",
                }, -- [3]
                {
                    ["id"] = 2396,
                    ["image"] = 3753155,
                    ["name"] = "『霜縛者』納爾索",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 1184,
            ["image"] = 3759909,
            ["name"] = "特那希迷霧",
            ["bosses"] = {
                {
                    ["id"] = 2400,
                    ["image"] = 3753152,
                    ["name"] = "英拉馬洛克",
                }, -- [1]
                {
                    ["id"] = 2402,
                    ["image"] = 3752181,
                    ["name"] = "喚霧者",
                }, -- [2]
                {
                    ["id"] = 2405,
                    ["image"] = 3752194,
                    ["name"] = "崔朵瓦",
                }, -- [3]
            },
        }, -- [9]
        {
            ["id"] = 1183,
            ["image"] = 3759911,
            ["name"] = "瘟疫之臨",
            ["bosses"] = {
                {
                    ["id"] = 2419,
                    ["image"] = 3752168,
                    ["name"] = "葛洛格羅",
                }, -- [1]
                {
                    ["id"] = 2403,
                    ["image"] = 3752162,
                    ["name"] = "伊克思博士",
                }, -- [2]
                {
                    ["id"] = 2423,
                    ["image"] = 3752163,
                    ["name"] = "多米娜‧毒刃",
                }, -- [3]
                {
                    ["id"] = 2404,
                    ["image"] = 3752180,
                    ["name"] = "藩侯史特拉達瑪",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 1187,
            ["image"] = 3759914,
            ["name"] = "苦痛劇場",
            ["bosses"] = {
                {
                    ["id"] = 2397,
                    ["image"] = 3752153,
                    ["name"] = "蔑視挑戰者",
                }, -- [1]
                {
                    ["id"] = 2401,
                    ["image"] = 3752169,
                    ["name"] = "肉排",
                }, -- [2]
                {
                    ["id"] = 2390,
                    ["image"] = 3752199,
                    ["name"] = "『未逝者』薩夫",
                }, -- [3]
                {
                    ["id"] = 2389,
                    ["image"] = 3753154,
                    ["name"] = "庫薩洛克",
                }, -- [4]
                {
                    ["id"] = 2417,
                    ["image"] = 3752182,
                    ["name"] = "『不朽女皇』莫瑞莎",
                }, -- [5]
            },
        }, -- [11]
        {
            ["id"] = 1189,
            ["image"] = 3759912,
            ["name"] = "血紅深淵",
            ["bosses"] = {
                {
                    ["id"] = 2388,
                    ["image"] = 3753153,
                    ["name"] = "貪婪的奎西斯",
                }, -- [1]
                {
                    ["id"] = 2415,
                    ["image"] = 3753148,
                    ["name"] = "處決者塔沃德",
                }, -- [2]
                {
                    ["id"] = 2421,
                    ["image"] = 3753149,
                    ["name"] = "總監督者貝莉亞",
                }, -- [3]
                {
                    ["id"] = 2407,
                    ["image"] = 3752167,
                    ["name"] = "凱厄將軍",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 1185,
            ["image"] = 3759908,
            ["name"] = "贖罪之殿",
            ["bosses"] = {
                {
                    ["id"] = 2406,
                    ["image"] = 3752171,
                    ["name"] = "『罪污巨人』哈奇厄斯",
                }, -- [1]
                {
                    ["id"] = 2387,
                    ["image"] = 3752165,
                    ["name"] = "艾可隆",
                }, -- [2]
                {
                    ["id"] = 2411,
                    ["image"] = 3753150,
                    ["name"] = "至高判決者阿利茲",
                }, -- [3]
                {
                    ["id"] = 2413,
                    ["image"] = 3752179,
                    ["name"] = "宮務大臣",
                }, -- [4]
            },
        }, -- [13]
    },
    ["Current Season"] = {
        {
            ["id"] = 1194,
            ["image"] = 4182022,
            ["name"] = "『帷幕市集』塔札維許",
            ["bosses"] = {
                {
                    ["id"] = 2437,
                    ["image"] = 4071449,
                    ["name"] = "哨兵佐菲克斯",
                }, -- [1]
                {
                    ["id"] = 2454,
                    ["image"] = 4071447,
                    ["name"] = "大展示廳",
                }, -- [2]
                {
                    ["id"] = 2436,
                    ["image"] = 4071438,
                    ["name"] = "收發室大騷動",
                }, -- [3]
                {
                    ["id"] = 2452,
                    ["image"] = 4071448,
                    ["name"] = "奧彌薩的綠洲",
                }, -- [4]
                {
                    ["id"] = 2451,
                    ["image"] = 4071440,
                    ["name"] = "索阿茲米",
                }, -- [5]
                {
                    ["id"] = 2448,
                    ["image"] = 4071429,
                    ["name"] = "海布藍德",
                }, -- [6]
                {
                    ["id"] = 2449,
                    ["image"] = 4071446,
                    ["name"] = "時光船長鉤尾",
                }, -- [7]
                {
                    ["id"] = 2455,
                    ["image"] = 4071441,
                    ["name"] = "索利亞",
                }, -- [8]
            },
        }, -- [1]
        {
            ["id"] = 860,
            ["image"] = 1537283,
            ["name"] = "重返卡拉贊",
            ["bosses"] = {
                {
                    ["id"] = 1820,
                    ["image"] = 1536495,
                    ["name"] = "歌劇大廳：綠野巫蹤",
                }, -- [1]
                {
                    ["id"] = 1826,
                    ["image"] = 1536494,
                    ["name"] = "歌劇大廳：西荒故事",
                }, -- [2]
                {
                    ["id"] = 1827,
                    ["image"] = 1536493,
                    ["name"] = "歌劇大廳：美女與猛獸",
                }, -- [3]
                {
                    ["id"] = 1825,
                    ["image"] = 1378997,
                    ["name"] = "貞潔聖女",
                }, -- [4]
                {
                    ["id"] = 1835,
                    ["image"] = 1536490,
                    ["name"] = "獵人阿圖曼",
                }, -- [5]
                {
                    ["id"] = 1837,
                    ["image"] = 1378999,
                    ["name"] = "摩洛斯",
                }, -- [6]
                {
                    ["id"] = 1836,
                    ["image"] = 1379020,
                    ["name"] = "館長",
                }, -- [7]
                {
                    ["id"] = 1817,
                    ["image"] = 1536496,
                    ["name"] = "麥迪文之影",
                }, -- [8]
                {
                    ["id"] = 1818,
                    ["image"] = 1536492,
                    ["name"] = "法力吞噬者",
                }, -- [9]
                {
                    ["id"] = 1838,
                    ["image"] = 1536497,
                    ["name"] = "『監視者』維茲亞頓",
                }, -- [10]
            },
        }, -- [2]
        {
            ["id"] = 1178,
            ["image"] = 3025325,
            ["name"] = "機械岡行動",
            ["bosses"] = {
                {
                    ["id"] = 2357,
                    ["image"] = 3012050,
                    ["name"] = "勾巴馬克王",
                }, -- [1]
                {
                    ["id"] = 2358,
                    ["image"] = 3012048,
                    ["name"] = "髒克",
                }, -- [2]
                {
                    ["id"] = 2360,
                    ["image"] = 3012059,
                    ["name"] = "崔克西和奈洛",
                }, -- [3]
                {
                    ["id"] = 2355,
                    ["image"] = 3012049,
                    ["name"] = "HK-8型空中壓制單位",
                }, -- [4]
                {
                    ["id"] = 2336,
                    ["image"] = 3012060,
                    ["name"] = "暴力機兵",
                }, -- [5]
                {
                    ["id"] = 2339,
                    ["image"] = 3012052,
                    ["name"] = "K.U.-J.0.機械犬",
                }, -- [6]
                {
                    ["id"] = 2348,
                    ["image"] = 3012053,
                    ["name"] = "機械工花園",
                }, -- [7]
                {
                    ["id"] = 2331,
                    ["image"] = 3012051,
                    ["name"] = "機械岡國王",
                }, -- [8]
            },
        }, -- [3]
        {
            ["id"] = 558,
            ["image"] = 1060548,
            ["name"] = "鋼鐵碼頭",
            ["bosses"] = {
                {
                    ["id"] = 1235,
                    ["image"] = 1044380,
                    ["name"] = "『血肉撕裂者』諾加爾",
                }, -- [1]
                {
                    ["id"] = 1236,
                    ["image"] = 1044340,
                    ["name"] = "恐軌執行者",
                }, -- [2]
                {
                    ["id"] = 1237,
                    ["image"] = 1044359,
                    ["name"] = "歐席爾",
                }, -- [3]
                {
                    ["id"] = 1238,
                    ["image"] = 1044367,
                    ["name"] = "史庫洛克",
                }, -- [4]
            },
        }, -- [4]
        {
            ["id"] = 536,
            ["image"] = 1041996,
            ["name"] = "恐軌車站",
            ["bosses"] = {
                {
                    ["id"] = 1138,
                    ["image"] = 1044360,
                    ["name"] = "火箭光和波爾卡",
                }, -- [1]
                {
                    ["id"] = 1163,
                    ["image"] = 1044339,
                    ["name"] = "奈楚格‧雷塔",
                }, -- [2]
                {
                    ["id"] = 1133,
                    ["image"] = 1044376,
                    ["name"] = "傲天者托芙菈",
                }, -- [3]
            },
        }, -- [5]
    },
    ["決戰艾澤拉斯"] = {
        {
            ["id"] = 1028,
            ["image"] = 2178279,
            ["name"] = "艾澤拉斯",
            ["bosses"] = {
                {
                    ["id"] = 2378,
                    ["image"] = 3284400,
                    ["name"] = "杉札拉女皇",
                }, -- [1]
                {
                    ["id"] = 2381,
                    ["image"] = 3284401,
                    ["name"] = "『碎地者』巫克拉茲",
                }, -- [2]
                {
                    ["id"] = 2363,
                    ["image"] = 3012063,
                    ["name"] = "威克瑪拉",
                }, -- [3]
                {
                    ["id"] = 2362,
                    ["image"] = 3012061,
                    ["name"] = "『縛魂者』烏爾瑪斯",
                }, -- [4]
                {
                    ["id"] = 2329,
                    ["image"] = 2497782,
                    ["name"] = "『森林之王』伊弗斯",
                }, -- [5]
                {
                    ["id"] = 2212,
                    ["image"] = 2176752,
                    ["name"] = "雄獅之吼",
                }, -- [6]
                {
                    ["id"] = 2139,
                    ["image"] = 2176755,
                    ["name"] = "特薩恩",
                }, -- [7]
                {
                    ["id"] = 2141,
                    ["image"] = 2176734,
                    ["name"] = "吉亞拉克",
                }, -- [8]
                {
                    ["id"] = 2197,
                    ["image"] = 2176731,
                    ["name"] = "冰雹傀儡",
                }, -- [9]
                {
                    ["id"] = 2198,
                    ["image"] = 2176760,
                    ["name"] = "戰爭使者葉南茲",
                }, -- [10]
                {
                    ["id"] = 2199,
                    ["image"] = 2176716,
                    ["name"] = "艾索埃瑟斯，飛翼颱風",
                }, -- [11]
                {
                    ["id"] = 2210,
                    ["image"] = 2176723,
                    ["name"] = "『噬漠者』夸勞克",
                }, -- [12]
            },
        }, -- [1]
        {
            ["id"] = 1031,
            ["image"] = 2178277,
            ["name"] = "奧迪爾",
            ["bosses"] = {
                {
                    ["id"] = 2168,
                    ["image"] = 2176749,
                    ["name"] = "塔羅克",
                }, -- [1]
                {
                    ["id"] = 2167,
                    ["image"] = 2176741,
                    ["name"] = "母親大人",
                }, -- [2]
                {
                    ["id"] = 2146,
                    ["image"] = 2176725,
                    ["name"] = "噬臭者",
                }, -- [3]
                {
                    ["id"] = 2169,
                    ["image"] = 2176761,
                    ["name"] = "『恩若司信使』札克沃茲",
                }, -- [4]
                {
                    ["id"] = 2166,
                    ["image"] = 2176757,
                    ["name"] = "維克提斯",
                }, -- [5]
                {
                    ["id"] = 2195,
                    ["image"] = 2176762,
                    ["name"] = "重生的祖爾",
                }, -- [6]
                {
                    ["id"] = 2194,
                    ["image"] = 2176742,
                    ["name"] = "揭滅者謎思拉克斯",
                }, -- [7]
                {
                    ["id"] = 2147,
                    ["image"] = 2176728,
                    ["name"] = "古翰",
                }, -- [8]
            },
        }, -- [2]
        {
            ["id"] = 1176,
            ["image"] = 2482729,
            ["name"] = "達薩亞洛之戰",
            ["bosses"] = {
                {
                    ["id"] = 2333,
                    ["image"] = 2497778,
                    ["name"] = "聖光勇士",
                }, -- [1]
                {
                    ["id"] = 2325,
                    ["image"] = 2497783,
                    ["name"] = "『森林之王』葛隆",
                }, -- [2]
                {
                    ["id"] = 2341,
                    ["image"] = 2529383,
                    ["name"] = "碧火大師",
                }, -- [3]
                {
                    ["id"] = 2342,
                    ["image"] = 2497790,
                    ["name"] = "金輝魔靈",
                }, -- [4]
                {
                    ["id"] = 2330,
                    ["image"] = 2497779,
                    ["name"] = "天選者衛隊",
                }, -- [5]
                {
                    ["id"] = 2335,
                    ["image"] = 2497784,
                    ["name"] = "神王拉斯塔哈",
                }, -- [6]
                {
                    ["id"] = 2334,
                    ["image"] = 2497788,
                    ["name"] = "大工匠梅卡托克",
                }, -- [7]
                {
                    ["id"] = 2337,
                    ["image"] = 2497786,
                    ["name"] = "風暴屏障封鎖部隊",
                }, -- [8]
                {
                    ["id"] = 2343,
                    ["image"] = 2497785,
                    ["name"] = "珍娜‧普勞德摩爾女士",
                }, -- [9]
            },
        }, -- [3]
        {
            ["id"] = 1177,
            ["image"] = 2498193,
            ["name"] = "風暴邪淵",
            ["bosses"] = {
                {
                    ["id"] = 2328,
                    ["image"] = 2497795,
                    ["name"] = "不息者秘教",
                }, -- [1]
                {
                    ["id"] = 2332,
                    ["image"] = 2497794,
                    ["name"] = "『虛無使者』烏納特",
                }, -- [2]
            },
        }, -- [4]
        {
            ["id"] = 1179,
            ["image"] = 3025320,
            ["name"] = "永恆宮殿",
            ["bosses"] = {
                {
                    ["id"] = 2352,
                    ["image"] = 3012047,
                    ["name"] = "深淵指揮官希瓦菈",
                }, -- [1]
                {
                    ["id"] = 2347,
                    ["image"] = 3012062,
                    ["name"] = "黑水巨鰻",
                }, -- [2]
                {
                    ["id"] = 2353,
                    ["image"] = 3012058,
                    ["name"] = "艾薩拉光輝",
                }, -- [3]
                {
                    ["id"] = 2354,
                    ["image"] = 3012055,
                    ["name"] = "艾胥凡女士",
                }, -- [4]
                {
                    ["id"] = 2351,
                    ["image"] = 3012054,
                    ["name"] = "歐格澤亞",
                }, -- [5]
                {
                    ["id"] = 2359,
                    ["image"] = 3012057,
                    ["name"] = "女王法庭",
                }, -- [6]
                {
                    ["id"] = 2349,
                    ["image"] = 3012064,
                    ["name"] = "『奈奧羅薩使者』札奎爾",
                }, -- [7]
                {
                    ["id"] = 2361,
                    ["image"] = 3012056,
                    ["name"] = "艾薩拉女王",
                }, -- [8]
            },
        }, -- [5]
        {
            ["id"] = 1180,
            ["image"] = 3221463,
            ["name"] = "奈奧羅薩，甦醒之城",
            ["bosses"] = {
                {
                    ["id"] = 2368,
                    ["image"] = 3256385,
                    ["name"] = "『黑暗帝王』怒西昂",
                }, -- [1]
                {
                    ["id"] = 2365,
                    ["image"] = 3256380,
                    ["name"] = "默特",
                }, -- [2]
                {
                    ["id"] = 2369,
                    ["image"] = 3256384,
                    ["name"] = "預言者斯奇崔",
                }, -- [3]
                {
                    ["id"] = 2377,
                    ["image"] = 3256386,
                    ["name"] = "黑暗審判官克珊內絲",
                }, -- [4]
                {
                    ["id"] = 2372,
                    ["image"] = 3256378,
                    ["name"] = "蟲群首腦",
                }, -- [5]
                {
                    ["id"] = 2367,
                    ["image"] = 3256383,
                    ["name"] = "『無盡飢餓』薩德哈",
                }, -- [6]
                {
                    ["id"] = 2373,
                    ["image"] = 3256377,
                    ["name"] = "卓雷阿葛斯",
                }, -- [7]
                {
                    ["id"] = 2374,
                    ["image"] = 3256379,
                    ["name"] = "『腐化重生』伊蓋諾斯",
                }, -- [8]
                {
                    ["id"] = 2370,
                    ["image"] = 3257677,
                    ["name"] = "薇希歐娜",
                }, -- [9]
                {
                    ["id"] = 2364,
                    ["image"] = 3256382,
                    ["name"] = "『掠心喪神』萊公",
                }, -- [10]
                {
                    ["id"] = 2366,
                    ["image"] = 3256376,
                    ["name"] = "恩若司的外殼",
                }, -- [11]
                {
                    ["id"] = 2375,
                    ["image"] = 3256381,
                    ["name"] = "『腐化者』恩若司",
                }, -- [12]
            },
        }, -- [6]
        {
            ["id"] = 1021,
            ["image"] = 2178278,
            ["name"] = "威奎斯特莊園",
            ["bosses"] = {
                {
                    ["id"] = 2125,
                    ["image"] = 2176732,
                    ["name"] = "禍心女巫三姊妹",
                }, -- [1]
                {
                    ["id"] = 2126,
                    ["image"] = 2176747,
                    ["name"] = "縛魂巨怪",
                }, -- [2]
                {
                    ["id"] = 2127,
                    ["image"] = 2176744,
                    ["name"] = "『貪吃鬼』雷爾",
                }, -- [3]
                {
                    ["id"] = 2128,
                    ["image"] = 2176736,
                    ["name"] = "威奎斯特領主和夫人",
                }, -- [4]
                {
                    ["id"] = 2129,
                    ["image"] = 2176729,
                    ["name"] = "勾拉圖爾",
                }, -- [5]
            },
        }, -- [7]
        {
            ["id"] = 1022,
            ["image"] = 2178275,
            ["name"] = "幽腐深窟",
            ["bosses"] = {
                {
                    ["id"] = 2157,
                    ["image"] = 2176724,
                    ["name"] = "黎克沙長老",
                }, -- [1]
                {
                    ["id"] = 2131,
                    ["image"] = 2176719,
                    ["name"] = "感染者岩喉",
                }, -- [2]
                {
                    ["id"] = 2130,
                    ["image"] = 2176748,
                    ["name"] = "喚孢者贊查",
                }, -- [3]
                {
                    ["id"] = 2158,
                    ["image"] = 2176756,
                    ["name"] = "無縛異怪",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 1002,
            ["image"] = 2178276,
            ["name"] = "托達戈爾",
            ["bosses"] = {
                {
                    ["id"] = 2097,
                    ["image"] = 2176753,
                    ["name"] = "沙后",
                }, -- [1]
                {
                    ["id"] = 2098,
                    ["image"] = 2176733,
                    ["name"] = "傑斯‧嚎里斯",
                }, -- [2]
                {
                    ["id"] = 2099,
                    ["image"] = 2176735,
                    ["name"] = "騎士隊長瓦萊麗",
                }, -- [3]
                {
                    ["id"] = 2096,
                    ["image"] = 2176743,
                    ["name"] = "監督者寇格斯",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 1012,
            ["image"] = 2178274,
            ["name"] = "晶喜鎮！",
            ["bosses"] = {
                {
                    ["id"] = 2109,
                    ["image"] = 2176718,
                    ["name"] = "投幣式群眾鎮壓機器人",
                }, -- [1]
                {
                    ["id"] = 2114,
                    ["image"] = 2176714,
                    ["name"] = "艾澤洛克",
                }, -- [2]
                {
                    ["id"] = 2115,
                    ["image"] = 2176745,
                    ["name"] = "芮克莎‧熔焰",
                }, -- [3]
                {
                    ["id"] = 2116,
                    ["image"] = 2176740,
                    ["name"] = "瑞茲當克老大",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 1178,
            ["image"] = 3025325,
            ["name"] = "機械岡行動",
            ["bosses"] = {
                {
                    ["id"] = 2357,
                    ["image"] = 3012050,
                    ["name"] = "勾巴馬克王",
                }, -- [1]
                {
                    ["id"] = 2358,
                    ["image"] = 3012048,
                    ["name"] = "髒克",
                }, -- [2]
                {
                    ["id"] = 2360,
                    ["image"] = 3012059,
                    ["name"] = "崔克西和奈洛",
                }, -- [3]
                {
                    ["id"] = 2355,
                    ["image"] = 3012049,
                    ["name"] = "HK-8型空中壓制單位",
                }, -- [4]
                {
                    ["id"] = 2336,
                    ["image"] = 3012060,
                    ["name"] = "暴力機兵",
                }, -- [5]
                {
                    ["id"] = 2339,
                    ["image"] = 3012052,
                    ["name"] = "K.U.-J.0.機械犬",
                }, -- [6]
                {
                    ["id"] = 2348,
                    ["image"] = 3012053,
                    ["name"] = "機械工花園",
                }, -- [7]
                {
                    ["id"] = 2331,
                    ["image"] = 3012051,
                    ["name"] = "機械岡國王",
                }, -- [8]
            },
        }, -- [11]
        {
            ["id"] = 1023,
            ["image"] = 2178272,
            ["name"] = "波拉勒斯圍城戰",
            ["bosses"] = {
                {
                    ["id"] = 2133,
                    ["image"] = 2176746,
                    ["name"] = "班布里吉中士",
                }, -- [1]
                {
                    ["id"] = 2173,
                    ["image"] = 2176722,
                    ["name"] = "恐怖船長洛克伍德",
                }, -- [2]
                {
                    ["id"] = 2134,
                    ["image"] = 2176730,
                    ["name"] = "哈達爾‧黑淵",
                }, -- [3]
                {
                    ["id"] = 2140,
                    ["image"] = 2176758,
                    ["name"] = "維克高斯",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 1030,
            ["image"] = 2178273,
            ["name"] = "瑟沙利斯神廟",
            ["bosses"] = {
                {
                    ["id"] = 2142,
                    ["image"] = 2176710,
                    ["name"] = "阿德利斯和艾斯匹",
                }, -- [1]
                {
                    ["id"] = 2143,
                    ["image"] = 2176739,
                    ["name"] = "莫芮克莎",
                }, -- [2]
                {
                    ["id"] = 2144,
                    ["image"] = 2176727,
                    ["name"] = "加瓦茲特",
                }, -- [3]
                {
                    ["id"] = 2145,
                    ["image"] = 2176713,
                    ["name"] = "瑟沙利斯化身",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 1001,
            ["image"] = 1778893,
            ["name"] = "自由港",
            ["bosses"] = {
                {
                    ["id"] = 2102,
                    ["image"] = 1778351,
                    ["name"] = "天空隊長克拉格",
                }, -- [1]
                {
                    ["id"] = 2093,
                    ["image"] = 1778346,
                    ["name"] = "船長議會",
                }, -- [2]
                {
                    ["id"] = 2094,
                    ["image"] = 1778350,
                    ["name"] = "藏寶競技場",
                }, -- [3]
                {
                    ["id"] = 2095,
                    ["image"] = 1778347,
                    ["name"] = "哈蘭‧史威特",
                }, -- [4]
            },
        }, -- [14]
        {
            ["id"] = 1041,
            ["image"] = 2178269,
            ["name"] = "諸王之眠",
            ["bosses"] = {
                {
                    ["id"] = 2165,
                    ["image"] = 2176751,
                    ["name"] = "黃金風蛇",
                }, -- [1]
                {
                    ["id"] = 2171,
                    ["image"] = 2176738,
                    ["name"] = "『墓葬者』瑪欽巴",
                }, -- [2]
                {
                    ["id"] = 2170,
                    ["image"] = 2176750,
                    ["name"] = "部族議會",
                }, -- [3]
                {
                    ["id"] = 2172,
                    ["image"] = 2176720,
                    ["name"] = "達薩，開國神王",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 968,
            ["image"] = 1778892,
            ["name"] = "阿塔達薩",
            ["bosses"] = {
                {
                    ["id"] = 2082,
                    ["image"] = 1778348,
                    ["name"] = "女祭司艾露薩",
                }, -- [1]
                {
                    ["id"] = 2036,
                    ["image"] = 1778352,
                    ["name"] = "沃卡爾",
                }, -- [2]
                {
                    ["id"] = 2083,
                    ["image"] = 1778349,
                    ["name"] = "瑞贊",
                }, -- [3]
                {
                    ["id"] = 2030,
                    ["image"] = 1778353,
                    ["name"] = "亞茲瑪",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 1036,
            ["image"] = 2178271,
            ["name"] = "風暴聖壇",
            ["bosses"] = {
                {
                    ["id"] = 2153,
                    ["image"] = 2176712,
                    ["name"] = "渦庫瑟",
                }, -- [1]
                {
                    ["id"] = 2154,
                    ["image"] = 2176754,
                    ["name"] = "浪潮賢者議會",
                }, -- [2]
                {
                    ["id"] = 2155,
                    ["image"] = 2176737,
                    ["name"] = "斯陀頌恩領主",
                }, -- [3]
                {
                    ["id"] = 2156,
                    ["image"] = 2176759,
                    ["name"] = "『低語者』沃澤斯",
                }, -- [4]
            },
        }, -- [17]
    },
    ["燃燒的遠征"] = {
        {
            ["id"] = 745,
            ["image"] = 1396584,
            ["name"] = "卡拉贊",
            ["bosses"] = {
                {
                    ["id"] = 1552,
                    ["image"] = 1385766,
                    ["name"] = "佣人區",
                }, -- [1]
                {
                    ["id"] = 1553,
                    ["image"] = 1378965,
                    ["name"] = "獵人阿圖曼",
                }, -- [2]
                {
                    ["id"] = 1554,
                    ["image"] = 1378999,
                    ["name"] = "摩洛斯",
                }, -- [3]
                {
                    ["id"] = 1555,
                    ["image"] = 1378997,
                    ["name"] = "貞潔聖女",
                }, -- [4]
                {
                    ["id"] = 1556,
                    ["image"] = 1385758,
                    ["name"] = "歌劇大廳",
                }, -- [5]
                {
                    ["id"] = 1557,
                    ["image"] = 1379020,
                    ["name"] = "館長",
                }, -- [6]
                {
                    ["id"] = 1559,
                    ["image"] = 1379012,
                    ["name"] = "埃蘭之影",
                }, -- [7]
                {
                    ["id"] = 1560,
                    ["image"] = 1379017,
                    ["name"] = "泰瑞斯提安‧疫蹄",
                }, -- [8]
                {
                    ["id"] = 1561,
                    ["image"] = 1379002,
                    ["name"] = "尼德斯",
                }, -- [9]
                {
                    ["id"] = 1764,
                    ["image"] = 1385724,
                    ["name"] = "西洋棋事件",
                }, -- [10]
                {
                    ["id"] = 1563,
                    ["image"] = 1379006,
                    ["name"] = "莫克札王子",
                }, -- [11]
            },
        }, -- [1]
        {
            ["id"] = 746,
            ["image"] = 1396582,
            ["name"] = "戈魯爾之巢",
            ["bosses"] = {
                {
                    ["id"] = 1564,
                    ["image"] = 1378985,
                    ["name"] = "大君王莫卡爾",
                }, -- [1]
                {
                    ["id"] = 1565,
                    ["image"] = 1378982,
                    ["name"] = "弒龍者戈魯爾",
                }, -- [2]
            },
        }, -- [2]
        {
            ["id"] = 747,
            ["image"] = 1396585,
            ["name"] = "瑪瑟里頓的巢穴",
            ["bosses"] = {
                {
                    ["id"] = 1566,
                    ["image"] = 1378996,
                    ["name"] = "瑪瑟里頓",
                }, -- [1]
            },
        }, -- [3]
        {
            ["id"] = 748,
            ["image"] = 608199,
            ["name"] = "毒蛇神殿洞穴",
            ["bosses"] = {
                {
                    ["id"] = 1567,
                    ["image"] = 1385741,
                    ["name"] = "不穩定者海卓司",
                }, -- [1]
                {
                    ["id"] = 1568,
                    ["image"] = 1385768,
                    ["name"] = "海底潛伏者",
                }, -- [2]
                {
                    ["id"] = 1569,
                    ["image"] = 1385751,
                    ["name"] = "『盲目者』李奧薩拉斯",
                }, -- [3]
                {
                    ["id"] = 1570,
                    ["image"] = 1385729,
                    ["name"] = "深淵之王卡拉薩瑞斯",
                }, -- [4]
                {
                    ["id"] = 1571,
                    ["image"] = 1385756,
                    ["name"] = "莫洛葛利姆‧潮行者",
                }, -- [5]
                {
                    ["id"] = 1572,
                    ["image"] = 1385750,
                    ["name"] = "瓦許女士",
                }, -- [6]
            },
        }, -- [4]
        {
            ["id"] = 749,
            ["image"] = 608218,
            ["name"] = "風暴核心",
            ["bosses"] = {
                {
                    ["id"] = 1573,
                    ["image"] = 1385712,
                    ["name"] = "歐爾",
                }, -- [1]
                {
                    ["id"] = 1574,
                    ["image"] = 1385772,
                    ["name"] = "虛無劫奪者",
                }, -- [2]
                {
                    ["id"] = 1575,
                    ["image"] = 1385739,
                    ["name"] = "高階星術師索拉瑞恩",
                }, -- [3]
                {
                    ["id"] = 1576,
                    ["image"] = 607669,
                    ["name"] = "凱爾薩斯‧逐日者",
                }, -- [4]
            },
        }, -- [5]
        {
            ["id"] = 750,
            ["image"] = 608198,
            ["name"] = "海加爾山之戰",
            ["bosses"] = {
                {
                    ["id"] = 1577,
                    ["image"] = 1385762,
                    ["name"] = "瑞齊‧凜冬",
                }, -- [1]
                {
                    ["id"] = 1578,
                    ["image"] = 1385714,
                    ["name"] = "安納塞隆",
                }, -- [2]
                {
                    ["id"] = 1579,
                    ["image"] = 1385745,
                    ["name"] = "卡茲洛加",
                }, -- [3]
                {
                    ["id"] = 1580,
                    ["image"] = 1385719,
                    ["name"] = "亞茲加洛",
                }, -- [4]
                {
                    ["id"] = 1581,
                    ["image"] = 1385716,
                    ["name"] = "阿克蒙德",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 751,
            ["image"] = 1396579,
            ["name"] = "黑暗神廟",
            ["bosses"] = {
                {
                    ["id"] = 1582,
                    ["image"] = 1378986,
                    ["name"] = "高階督軍納珍塔斯",
                }, -- [1]
                {
                    ["id"] = 1583,
                    ["image"] = 1379016,
                    ["name"] = "瑟普莫斯",
                }, -- [2]
                {
                    ["id"] = 1584,
                    ["image"] = 1379011,
                    ["name"] = "阿卡瑪的黑暗面",
                }, -- [3]
                {
                    ["id"] = 1585,
                    ["image"] = 1379018,
                    ["name"] = "泰朗‧血魔",
                }, -- [4]
                {
                    ["id"] = 1586,
                    ["image"] = 1378983,
                    ["name"] = "葛塔格‧血沸",
                }, -- [5]
                {
                    ["id"] = 1587,
                    ["image"] = 1385764,
                    ["name"] = "靈魂聖匣",
                }, -- [6]
                {
                    ["id"] = 1588,
                    ["image"] = 1379000,
                    ["name"] = "薩拉茲女士",
                }, -- [7]
                {
                    ["id"] = 1589,
                    ["image"] = 1385743,
                    ["name"] = "伊利達瑞議會",
                }, -- [8]
                {
                    ["id"] = 1590,
                    ["image"] = 1378987,
                    ["name"] = "伊利丹‧怒風",
                }, -- [9]
            },
        }, -- [7]
        {
            ["id"] = 752,
            ["image"] = 1396592,
            ["name"] = "太陽之井高地",
            ["bosses"] = {
                {
                    ["id"] = 1591,
                    ["image"] = 1385744,
                    ["name"] = "卡雷苟斯",
                }, -- [1]
                {
                    ["id"] = 1592,
                    ["image"] = 1385722,
                    ["name"] = "布魯托魯斯",
                }, -- [2]
                {
                    ["id"] = 1593,
                    ["image"] = 1385730,
                    ["name"] = "魔龍謎霧",
                }, -- [3]
                {
                    ["id"] = 1594,
                    ["image"] = 1390438,
                    ["name"] = "埃雷達爾雙子",
                }, -- [4]
                {
                    ["id"] = 1595,
                    ["image"] = 1385757,
                    ["name"] = "莫魯",
                }, -- [5]
                {
                    ["id"] = 1596,
                    ["image"] = 1385746,
                    ["name"] = "基爾加丹",
                }, -- [6]
            },
        }, -- [8]
        {
            ["id"] = 254,
            ["image"] = 608218,
            ["name"] = "亞克崔茲",
            ["bosses"] = {
                {
                    ["id"] = 548,
                    ["image"] = 607823,
                    ["name"] = "無約束的希瑞奇斯",
                }, -- [1]
                {
                    ["id"] = 549,
                    ["image"] = 607574,
                    ["name"] = "末日預言者達利亞",
                }, -- [2]
                {
                    ["id"] = 550,
                    ["image"] = 607820,
                    ["name"] = "怒鐮者索寇斯瑞特",
                }, -- [3]
                {
                    ["id"] = 551,
                    ["image"] = 607635,
                    ["name"] = "先驅者史蓋力司",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 249,
            ["image"] = 608208,
            ["name"] = "博學者殿堂",
            ["bosses"] = {
                {
                    ["id"] = 530,
                    ["image"] = 607767,
                    ["name"] = "賽林‧炎心",
                }, -- [1]
                {
                    ["id"] = 531,
                    ["image"] = 607806,
                    ["name"] = "維克索魯斯",
                }, -- [2]
                {
                    ["id"] = 532,
                    ["image"] = 607742,
                    ["name"] = "女牧師戴利莎",
                }, -- [3]
                {
                    ["id"] = 533,
                    ["image"] = 607669,
                    ["name"] = "凱爾薩斯‧逐日者",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 248,
            ["image"] = 608207,
            ["name"] = "地獄火壁壘",
            ["bosses"] = {
                {
                    ["id"] = 527,
                    ["image"] = 607817,
                    ["name"] = "看護者卡爾古瑪",
                }, -- [1]
                {
                    ["id"] = 528,
                    ["image"] = 607734,
                    ["name"] = "『無疤者』歐瑪爾",
                }, -- [2]
                {
                    ["id"] = 529,
                    ["image"] = 607803,
                    ["name"] = "『信使』維斯路登",
                }, -- [3]
            },
        }, -- [11]
        {
            ["id"] = 252,
            ["image"] = 608193,
            ["name"] = "塞司克大廳",
            ["bosses"] = {
                {
                    ["id"] = 541,
                    ["image"] = 607583,
                    ["name"] = "暗織者希斯",
                }, -- [1]
                {
                    ["id"] = 543,
                    ["image"] = 607780,
                    ["name"] = "鷹王伊奇斯",
                }, -- [2]
            },
        }, -- [12]
        {
            ["id"] = 247,
            ["image"] = 608193,
            ["name"] = "奧奇奈地穴",
            ["bosses"] = {
                {
                    ["id"] = 523,
                    ["image"] = 607771,
                    ["name"] = "死亡看守者辛瑞克",
                }, -- [1]
                {
                    ["id"] = 524,
                    ["image"] = 607600,
                    ["name"] = "瑪拉達爾主教",
                }, -- [2]
            },
        }, -- [13]
        {
            ["id"] = 260,
            ["image"] = 608199,
            ["name"] = "奴隸監獄",
            ["bosses"] = {
                {
                    ["id"] = 570,
                    ["image"] = 607715,
                    ["name"] = "『背叛者』曼紐",
                }, -- [1]
                {
                    ["id"] = 571,
                    ["image"] = 607759,
                    ["name"] = "『爆裂者』洛克瑪",
                }, -- [2]
                {
                    ["id"] = 572,
                    ["image"] = 607750,
                    ["name"] = "奎克米瑞",
                }, -- [3]
            },
        }, -- [14]
        {
            ["id"] = 251,
            ["image"] = 608198,
            ["name"] = "希爾斯布萊德丘陵舊址",
            ["bosses"] = {
                {
                    ["id"] = 538,
                    ["image"] = 607689,
                    ["name"] = "中尉崔克",
                }, -- [1]
                {
                    ["id"] = 539,
                    ["image"] = 607561,
                    ["name"] = "史卡拉克上尉",
                }, -- [2]
                {
                    ["id"] = 540,
                    ["image"] = 607596,
                    ["name"] = "紀元狩獵者",
                }, -- [3]
            },
        }, -- [15]
        {
            ["id"] = 253,
            ["image"] = 608193,
            ["name"] = "暗影迷宮",
            ["bosses"] = {
                {
                    ["id"] = 544,
                    ["image"] = 607536,
                    ["name"] = "海爾瑪大使",
                }, -- [1]
                {
                    ["id"] = 545,
                    ["image"] = 607555,
                    ["name"] = "『煽動者』黑心",
                }, -- [2]
                {
                    ["id"] = 546,
                    ["image"] = 607625,
                    ["name"] = "宗師瓦皮歐",
                }, -- [3]
                {
                    ["id"] = 547,
                    ["image"] = 607720,
                    ["name"] = "莫爾墨",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 250,
            ["image"] = 608193,
            ["name"] = "法力墓地",
            ["bosses"] = {
                {
                    ["id"] = 534,
                    ["image"] = 607738,
                    ["name"] = "班提蒙尼厄斯",
                }, -- [1]
                {
                    ["id"] = 535,
                    ["image"] = 607782,
                    ["name"] = "塔瓦洛克",
                }, -- [2]
                {
                    ["id"] = 537,
                    ["image"] = 607726,
                    ["name"] = "奈薩斯王子薩法爾",
                }, -- [3]
            },
        }, -- [17]
        {
            ["id"] = 257,
            ["image"] = 608218,
            ["name"] = "波塔尼卡",
            ["bosses"] = {
                {
                    ["id"] = 558,
                    ["image"] = 607570,
                    ["name"] = "指揮官薩瑞尼斯",
                }, -- [1]
                {
                    ["id"] = 559,
                    ["image"] = 607641,
                    ["name"] = "大植物學家費瑞衛恩",
                }, -- [2]
                {
                    ["id"] = 560,
                    ["image"] = 607794,
                    ["name"] = "『看管者』索古林",
                }, -- [3]
                {
                    ["id"] = 561,
                    ["image"] = 607683,
                    ["name"] = "拉杰",
                }, -- [4]
                {
                    ["id"] = 562,
                    ["image"] = 607816,
                    ["name"] = "扭曲分裂者",
                }, -- [5]
            },
        }, -- [18]
        {
            ["id"] = 262,
            ["image"] = 608199,
            ["name"] = "深幽泥沼",
            ["bosses"] = {
                {
                    ["id"] = 576,
                    ["image"] = 607649,
                    ["name"] = "飢餓之牙",
                }, -- [1]
                {
                    ["id"] = 577,
                    ["image"] = 607614,
                    ["name"] = "高薩安",
                }, -- [2]
                {
                    ["id"] = 578,
                    ["image"] = 607779,
                    ["name"] = "沼澤之王莫斯萊克",
                }, -- [3]
                {
                    ["id"] = 579,
                    ["image"] = 607788,
                    ["name"] = "黑色潛獵者",
                }, -- [4]
            },
        }, -- [19]
        {
            ["id"] = 259,
            ["image"] = 608207,
            ["name"] = "破碎大廳",
            ["bosses"] = {
                {
                    ["id"] = 566,
                    ["image"] = 607624,
                    ["name"] = "大術士奈德克斯",
                }, -- [1]
                {
                    ["id"] = 568,
                    ["image"] = 607811,
                    ["name"] = "戰爭使者歐姆拉格",
                }, -- [2]
                {
                    ["id"] = 569,
                    ["image"] = 607812,
                    ["name"] = "大酋長卡加斯‧刃拳",
                }, -- [3]
            },
        }, -- [20]
        {
            ["id"] = 261,
            ["image"] = 608199,
            ["name"] = "蒸汽洞窟",
            ["bosses"] = {
                {
                    ["id"] = 573,
                    ["image"] = 607651,
                    ["name"] = "水占師希斯比亞",
                }, -- [1]
                {
                    ["id"] = 574,
                    ["image"] = 607713,
                    ["name"] = "機電師蒸汽操控者",
                }, -- [2]
                {
                    ["id"] = 575,
                    ["image"] = 607815,
                    ["name"] = "督軍卡利斯瑞",
                }, -- [3]
            },
        }, -- [21]
        {
            ["id"] = 256,
            ["image"] = 608207,
            ["name"] = "血熔爐",
            ["bosses"] = {
                {
                    ["id"] = 555,
                    ["image"] = 607789,
                    ["name"] = "造物者",
                }, -- [1]
                {
                    ["id"] = 556,
                    ["image"] = 607558,
                    ["name"] = "布洛克",
                }, -- [2]
                {
                    ["id"] = 557,
                    ["image"] = 607670,
                    ["name"] = "『破壞者』凱利丹",
                }, -- [3]
            },
        }, -- [22]
        {
            ["id"] = 258,
            ["image"] = 608218,
            ["name"] = "麥克納爾",
            ["bosses"] = {
                {
                    ["id"] = 563,
                    ["image"] = 607712,
                    ["name"] = "機械領主卡帕希特斯",
                }, -- [1]
                {
                    ["id"] = 564,
                    ["image"] = 607725,
                    ["name"] = "虛空術師賽菲瑞雅",
                }, -- [2]
                {
                    ["id"] = 565,
                    ["image"] = 607739,
                    ["name"] = "操縱者帕薩里歐",
                }, -- [3]
            },
        }, -- [23]
        {
            ["id"] = 255,
            ["image"] = 608198,
            ["name"] = "黑色沼澤",
            ["bosses"] = {
                {
                    ["id"] = 552,
                    ["image"] = 607566,
                    ["name"] = "時間領主迪賈",
                }, -- [1]
                {
                    ["id"] = 553,
                    ["image"] = 607784,
                    ["name"] = "坦普拉斯",
                }, -- [2]
                {
                    ["id"] = 554,
                    ["image"] = 607529,
                    ["name"] = "艾奧那斯",
                }, -- [3]
            },
        }, -- [24]
    },
}

data.koKR = {
    ["대격변"] = {
        {
            ["id"] = 75,
            ["image"] = 522349,
            ["name"] = "바라딘 요새",
            ["bosses"] = {
                {
                    ["id"] = 139,
                    ["image"] = 522198,
                    ["name"] = "아르갈로스",
                }, -- [1]
                {
                    ["id"] = 140,
                    ["image"] = 523207,
                    ["name"] = "오큐타르",
                }, -- [2]
                {
                    ["id"] = 339,
                    ["image"] = 571742,
                    ["name"] = "증오의 여군주 알리자발",
                }, -- [3]
            },
        }, -- [1]
        {
            ["id"] = 73,
            ["image"] = 522351,
            ["name"] = "검은날개 강림지",
            ["bosses"] = {
                {
                    ["id"] = 169,
                    ["image"] = 522250,
                    ["name"] = "만능골렘 방어 시스템",
                }, -- [1]
                {
                    ["id"] = 170,
                    ["image"] = 522251,
                    ["name"] = "용암아귀",
                }, -- [2]
                {
                    ["id"] = 171,
                    ["image"] = 522202,
                    ["name"] = "아트라메데스",
                }, -- [3]
                {
                    ["id"] = 172,
                    ["image"] = 522211,
                    ["name"] = "키마이론",
                }, -- [4]
                {
                    ["id"] = 173,
                    ["image"] = 522252,
                    ["name"] = "말로리악",
                }, -- [5]
                {
                    ["id"] = 174,
                    ["image"] = 522255,
                    ["name"] = "네파리안의 최후",
                }, -- [6]
            },
        }, -- [2]
        {
            ["id"] = 74,
            ["image"] = 522359,
            ["name"] = "네 바람의 왕좌",
            ["bosses"] = {
                {
                    ["id"] = 154,
                    ["image"] = 522196,
                    ["name"] = "바람의 비밀의회",
                }, -- [1]
                {
                    ["id"] = 155,
                    ["image"] = 522191,
                    ["name"] = "알아키르",
                }, -- [2]
            },
        }, -- [3]
        {
            ["id"] = 72,
            ["image"] = 522355,
            ["name"] = "황혼의 요새",
            ["bosses"] = {
                {
                    ["id"] = 156,
                    ["image"] = 522232,
                    ["name"] = "할푸스 웜브레이커",
                }, -- [1]
                {
                    ["id"] = 157,
                    ["image"] = 522274,
                    ["name"] = "테랄리온과 발리오나",
                }, -- [2]
                {
                    ["id"] = 158,
                    ["image"] = 522224,
                    ["name"] = "승천 의회",
                }, -- [3]
                {
                    ["id"] = 167,
                    ["image"] = 522212,
                    ["name"] = "초갈",
                }, -- [4]
            },
        }, -- [4]
        {
            ["id"] = 78,
            ["image"] = 522353,
            ["name"] = "불의 땅",
            ["bosses"] = {
                {
                    ["id"] = 192,
                    ["image"] = 522208,
                    ["name"] = "베스틸락",
                }, -- [1]
                {
                    ["id"] = 193,
                    ["image"] = 522248,
                    ["name"] = "군주 라이올리스",
                }, -- [2]
                {
                    ["id"] = 194,
                    ["image"] = 522193,
                    ["name"] = "알리스라조르",
                }, -- [3]
                {
                    ["id"] = 195,
                    ["image"] = 522268,
                    ["name"] = "샤녹스",
                }, -- [4]
                {
                    ["id"] = 196,
                    ["image"] = 522204,
                    ["name"] = "문지기 발레록",
                }, -- [5]
                {
                    ["id"] = 197,
                    ["image"] = 522223,
                    ["name"] = "청지기 스태그헬름",
                }, -- [6]
                {
                    ["id"] = 198,
                    ["image"] = 522261,
                    ["name"] = "라그나로스",
                }, -- [7]
            },
        }, -- [5]
        {
            ["id"] = 187,
            ["image"] = 571753,
            ["name"] = "용의 영혼",
            ["bosses"] = {
                {
                    ["id"] = 311,
                    ["image"] = 536058,
                    ["name"] = "모르초크",
                }, -- [1]
                {
                    ["id"] = 324,
                    ["image"] = 536061,
                    ["name"] = "장군 존오즈",
                }, -- [2]
                {
                    ["id"] = 325,
                    ["image"] = 536062,
                    ["name"] = "잠들지 않는 요르사지",
                }, -- [3]
                {
                    ["id"] = 317,
                    ["image"] = 536057,
                    ["name"] = "폭풍술사 하가라",
                }, -- [4]
                {
                    ["id"] = 331,
                    ["image"] = 571750,
                    ["name"] = "울트락시온",
                }, -- [5]
                {
                    ["id"] = 332,
                    ["image"] = 571752,
                    ["name"] = "전투대장 블랙혼",
                }, -- [6]
                {
                    ["id"] = 318,
                    ["image"] = 536056,
                    ["name"] = "데스윙의 등",
                }, -- [7]
                {
                    ["id"] = 333,
                    ["image"] = 536055,
                    ["name"] = "데스윙의 광기",
                }, -- [8]
            },
        }, -- [6]
        {
            ["id"] = 66,
            ["image"] = 522350,
            ["name"] = "검은바위 동굴",
            ["bosses"] = {
                {
                    ["id"] = 105,
                    ["image"] = 522266,
                    ["name"] = "해골분쇄자 롬오그",
                }, -- [1]
                {
                    ["id"] = 106,
                    ["image"] = 522216,
                    ["name"] = "황혼의 전령 코를라",
                }, -- [2]
                {
                    ["id"] = 107,
                    ["image"] = 522244,
                    ["name"] = "카쉬 스틸벤더",
                }, -- [3]
                {
                    ["id"] = 108,
                    ["image"] = 522207,
                    ["name"] = "아름이",
                }, -- [4]
                {
                    ["id"] = 109,
                    ["image"] = 522201,
                    ["name"] = "승천 군주 옵시디우스",
                }, -- [5]
            },
        }, -- [7]
        {
            ["id"] = 71,
            ["image"] = 522354,
            ["name"] = "그림 바톨",
            ["bosses"] = {
                {
                    ["id"] = 131,
                    ["image"] = 522227,
                    ["name"] = "장군 움브리스",
                }, -- [1]
                {
                    ["id"] = 132,
                    ["image"] = 522226,
                    ["name"] = "제련장인 트롱구스",
                }, -- [2]
                {
                    ["id"] = 133,
                    ["image"] = 522218,
                    ["name"] = "드라가 섀도버너",
                }, -- [3]
                {
                    ["id"] = 134,
                    ["image"] = 522222,
                    ["name"] = "지하 군주 에루닥스",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 64,
            ["image"] = 522358,
            ["name"] = "그림자송곳니 성채",
            ["bosses"] = {
                {
                    ["id"] = 96,
                    ["image"] = 522205,
                    ["name"] = "남작 애쉬버리",
                }, -- [1]
                {
                    ["id"] = 97,
                    ["image"] = 522206,
                    ["name"] = "남작 실버레인",
                }, -- [2]
                {
                    ["id"] = 98,
                    ["image"] = 522213,
                    ["name"] = "사령관 스프링베일",
                }, -- [3]
                {
                    ["id"] = 99,
                    ["image"] = 522249,
                    ["name"] = "월든 경",
                }, -- [4]
                {
                    ["id"] = 100,
                    ["image"] = 522247,
                    ["name"] = "고드프리 경",
                }, -- [5]
            },
        }, -- [9]
        {
            ["id"] = 67,
            ["image"] = 522360,
            ["name"] = "바위심장부",
            ["bosses"] = {
                {
                    ["id"] = 110,
                    ["image"] = 522215,
                    ["name"] = "코보루스",
                }, -- [1]
                {
                    ["id"] = 111,
                    ["image"] = 522271,
                    ["name"] = "돌거죽",
                }, -- [2]
                {
                    ["id"] = 112,
                    ["image"] = 522258,
                    ["name"] = "오즈룩",
                }, -- [3]
                {
                    ["id"] = 113,
                    ["image"] = 522237,
                    ["name"] = "대여사제 아질",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 68,
            ["image"] = 522361,
            ["name"] = "소용돌이 누각",
            ["bosses"] = {
                {
                    ["id"] = 114,
                    ["image"] = 522229,
                    ["name"] = "대장로 에르탄",
                }, -- [1]
                {
                    ["id"] = 115,
                    ["image"] = 522192,
                    ["name"] = "알타이루스",
                }, -- [2]
                {
                    ["id"] = 116,
                    ["image"] = 522200,
                    ["name"] = "서풍의 통치자 아사드",
                }, -- [3]
            },
        }, -- [11]
        {
            ["id"] = 184,
            ["image"] = 571754,
            ["name"] = "시간의 끝",
            ["bosses"] = {
                {
                    ["id"] = 340,
                    ["image"] = 571744,
                    ["name"] = "바인의 환영",
                }, -- [1]
                {
                    ["id"] = 285,
                    ["image"] = 571745,
                    ["name"] = "제이나의 환영",
                }, -- [2]
                {
                    ["id"] = 323,
                    ["image"] = 571748,
                    ["name"] = "실바나스의 환영",
                }, -- [3]
                {
                    ["id"] = 283,
                    ["image"] = 571749,
                    ["name"] = "티란데의 환영",
                }, -- [4]
                {
                    ["id"] = 289,
                    ["image"] = 536059,
                    ["name"] = "무르도즈노",
                }, -- [5]
            },
        }, -- [12]
        {
            ["id"] = 70,
            ["image"] = 522356,
            ["name"] = "시초의 전당",
            ["bosses"] = {
                {
                    ["id"] = 124,
                    ["image"] = 522272,
                    ["name"] = "사원 수호자 안후르",
                }, -- [1]
                {
                    ["id"] = 125,
                    ["image"] = 522219,
                    ["name"] = "대지전복자 프타",
                }, -- [2]
                {
                    ["id"] = 126,
                    ["image"] = 522195,
                    ["name"] = "안라펫",
                }, -- [3]
                {
                    ["id"] = 127,
                    ["image"] = 522241,
                    ["name"] = "마법의 지배신 이시세트",
                }, -- [4]
                {
                    ["id"] = 128,
                    ["image"] = 522194,
                    ["name"] = "생명의 지배신 아뮤내",
                }, -- [5]
                {
                    ["id"] = 129,
                    ["image"] = 522267,
                    ["name"] = "파괴의 지배신 세테쉬",
                }, -- [6]
                {
                    ["id"] = 130,
                    ["image"] = 522262,
                    ["name"] = "태양의 지배신 라지",
                }, -- [7]
            },
        }, -- [13]
        {
            ["id"] = 185,
            ["image"] = 571756,
            ["name"] = "영원의 샘",
            ["bosses"] = {
                {
                    ["id"] = 290,
                    ["image"] = 536060,
                    ["name"] = "페로스안",
                }, -- [1]
                {
                    ["id"] = 291,
                    ["image"] = 571747,
                    ["name"] = "여왕 아즈샤라",
                }, -- [2]
                {
                    ["id"] = 292,
                    ["image"] = 571746,
                    ["name"] = "만노로스와 바로덴",
                }, -- [3]
            },
        }, -- [14]
        {
            ["id"] = 63,
            ["image"] = 522352,
            ["name"] = "죽음의 폐광",
            ["bosses"] = {
                {
                    ["id"] = 89,
                    ["image"] = 522228,
                    ["name"] = "글럽톡",
                }, -- [1]
                {
                    ["id"] = 90,
                    ["image"] = 522234,
                    ["name"] = "헬릭스 기어브레이커",
                }, -- [2]
                {
                    ["id"] = 91,
                    ["image"] = 522225,
                    ["name"] = "전투 절단기 5000",
                }, -- [3]
                {
                    ["id"] = 92,
                    ["image"] = 522189,
                    ["name"] = "제독 으르렁니",
                }, -- [4]
                {
                    ["id"] = 93,
                    ["image"] = 522210,
                    ["name"] = "\"선장\" 쿠키",
                }, -- [5]
            },
        }, -- [15]
        {
            ["id"] = 76,
            ["image"] = 522364,
            ["name"] = "줄구룹",
            ["bosses"] = {
                {
                    ["id"] = 175,
                    ["image"] = 522236,
                    ["name"] = "대사제 베녹시스",
                }, -- [1]
                {
                    ["id"] = 176,
                    ["image"] = 522209,
                    ["name"] = "혈군주 만도키르",
                }, -- [2]
                {
                    ["id"] = 177,
                    ["image"] = 522230,
                    ["name"] = "광란의 은닉처 - 그리렉",
                }, -- [3]
                {
                    ["id"] = 178,
                    ["image"] = 522233,
                    ["name"] = "광란의 은닉처 - 하자라",
                }, -- [4]
                {
                    ["id"] = 179,
                    ["image"] = 522263,
                    ["name"] = "광란의 은닉처 - 레나타키",
                }, -- [5]
                {
                    ["id"] = 180,
                    ["image"] = 522279,
                    ["name"] = "광란의 은닉처 - 우슐레이",
                }, -- [6]
                {
                    ["id"] = 181,
                    ["image"] = 522238,
                    ["name"] = "대여사제 킬나라",
                }, -- [7]
                {
                    ["id"] = 184,
                    ["image"] = 522280,
                    ["name"] = "잔질",
                }, -- [8]
                {
                    ["id"] = 185,
                    ["image"] = 522243,
                    ["name"] = "신파괴자 진도",
                }, -- [9]
            },
        }, -- [16]
        {
            ["id"] = 77,
            ["image"] = 522363,
            ["name"] = "줄아만",
            ["bosses"] = {
                {
                    ["id"] = 186,
                    ["image"] = 522190,
                    ["name"] = "아킬존",
                }, -- [1]
                {
                    ["id"] = 187,
                    ["image"] = 522254,
                    ["name"] = "날로라크",
                }, -- [2]
                {
                    ["id"] = 188,
                    ["image"] = 522242,
                    ["name"] = "잔알라이",
                }, -- [3]
                {
                    ["id"] = 189,
                    ["image"] = 522231,
                    ["name"] = "할라지",
                }, -- [4]
                {
                    ["id"] = 190,
                    ["image"] = 522235,
                    ["name"] = "사술 군주 말라크라스",
                }, -- [5]
                {
                    ["id"] = 191,
                    ["image"] = 522217,
                    ["name"] = "다카라",
                }, -- [6]
            },
        }, -- [17]
        {
            ["id"] = 69,
            ["image"] = 522357,
            ["name"] = "톨비르의 잃어버린 도시",
            ["bosses"] = {
                {
                    ["id"] = 117,
                    ["image"] = 523205,
                    ["name"] = "장군 후삼",
                }, -- [1]
                {
                    ["id"] = 118,
                    ["image"] = 522246,
                    ["name"] = "톱니아귀",
                }, -- [2]
                {
                    ["id"] = 119,
                    ["image"] = 522239,
                    ["name"] = "고위 사제 바림",
                }, -- [3]
                {
                    ["id"] = 122,
                    ["image"] = 522269,
                    ["name"] = "시아마트",
                }, -- [4]
            },
        }, -- [18]
        {
            ["id"] = 65,
            ["image"] = 522362,
            ["name"] = "파도의 왕좌",
            ["bosses"] = {
                {
                    ["id"] = 101,
                    ["image"] = 522245,
                    ["name"] = "여군주 나즈자르",
                }, -- [1]
                {
                    ["id"] = 102,
                    ["image"] = 522214,
                    ["name"] = "부패한 왕자, 사령관 울톡",
                }, -- [2]
                {
                    ["id"] = 103,
                    ["image"] = 522253,
                    ["name"] = "환각술사 구르샤",
                }, -- [3]
                {
                    ["id"] = 104,
                    ["image"] = 522259,
                    ["name"] = "오주마트",
                }, -- [4]
            },
        }, -- [19]
        {
            ["id"] = 186,
            ["image"] = 571755,
            ["name"] = "황혼의 시간",
            ["bosses"] = {
                {
                    ["id"] = 322,
                    ["image"] = 571743,
                    ["name"] = "아큐리온",
                }, -- [1]
                {
                    ["id"] = 342,
                    ["image"] = 536054,
                    ["name"] = "아시라 돈슬레이어",
                }, -- [2]
                {
                    ["id"] = 341,
                    ["image"] = 536053,
                    ["name"] = "대주교 베네딕투스",
                }, -- [3]
            },
        }, -- [20]
    },
    ["군단"] = {
        {
            ["id"] = 822,
            ["image"] = 1411854,
            ["name"] = "부서진 섬",
            ["bosses"] = {
                {
                    ["id"] = 1790,
                    ["image"] = 1411023,
                    ["name"] = "아나무즈",
                }, -- [1]
                {
                    ["id"] = 1956,
                    ["image"] = 1134499,
                    ["name"] = "아포크론",
                }, -- [2]
                {
                    ["id"] = 1883,
                    ["image"] = 1385722,
                    ["name"] = "브루탈루스",
                }, -- [3]
                {
                    ["id"] = 1774,
                    ["image"] = 1411024,
                    ["name"] = "칼라미르",
                }, -- [4]
                {
                    ["id"] = 1789,
                    ["image"] = 1411025,
                    ["name"] = "냉혈의 드루곤",
                }, -- [5]
                {
                    ["id"] = 1795,
                    ["image"] = 1472454,
                    ["name"] = "바다떠돌이",
                }, -- [6]
                {
                    ["id"] = 1770,
                    ["image"] = 1411026,
                    ["name"] = "휴몽그리스",
                }, -- [7]
                {
                    ["id"] = 1769,
                    ["image"] = 1411027,
                    ["name"] = "레반투스",
                }, -- [8]
                {
                    ["id"] = 1884,
                    ["image"] = 1579937,
                    ["name"] = "말리피쿠스",
                }, -- [9]
                {
                    ["id"] = 1783,
                    ["image"] = 1411028,
                    ["name"] = "마귀 나자크",
                }, -- [10]
                {
                    ["id"] = 1749,
                    ["image"] = 1411029,
                    ["name"] = "니소그",
                }, -- [11]
                {
                    ["id"] = 1763,
                    ["image"] = 1411030,
                    ["name"] = "샤르토스",
                }, -- [12]
                {
                    ["id"] = 1885,
                    ["image"] = 1579941,
                    ["name"] = "시바쉬",
                }, -- [13]
                {
                    ["id"] = 1756,
                    ["image"] = 1411031,
                    ["name"] = "영혼약탈자",
                }, -- [14]
                {
                    ["id"] = 1796,
                    ["image"] = 1472455,
                    ["name"] = "메마른 짐",
                }, -- [15]
            },
        }, -- [1]
        {
            ["id"] = 768,
            ["image"] = 1452687,
            ["name"] = "에메랄드의 악몽",
            ["bosses"] = {
                {
                    ["id"] = 1703,
                    ["image"] = 1410972,
                    ["name"] = "니센드라",
                }, -- [1]
                {
                    ["id"] = 1738,
                    ["image"] = 1410960,
                    ["name"] = "타락의 심장 일기노스",
                }, -- [2]
                {
                    ["id"] = 1744,
                    ["image"] = 1410947,
                    ["name"] = "엘레레스 렌퍼럴",
                }, -- [3]
                {
                    ["id"] = 1667,
                    ["image"] = 1410991,
                    ["name"] = "우르속",
                }, -- [4]
                {
                    ["id"] = 1704,
                    ["image"] = 1410945,
                    ["name"] = "악몽의 용",
                }, -- [5]
                {
                    ["id"] = 1750,
                    ["image"] = 1410940,
                    ["name"] = "세나리우스",
                }, -- [6]
                {
                    ["id"] = 1726,
                    ["image"] = 1410994,
                    ["name"] = "자비우스",
                }, -- [7]
            },
        }, -- [2]
        {
            ["id"] = 861,
            ["image"] = 1537284,
            ["name"] = "용맹의 시험",
            ["bosses"] = {
                {
                    ["id"] = 1819,
                    ["image"] = 1410974,
                    ["name"] = "오딘",
                }, -- [1]
                {
                    ["id"] = 1830,
                    ["image"] = 1536491,
                    ["name"] = "구아름",
                }, -- [2]
                {
                    ["id"] = 1829,
                    ["image"] = 1410957,
                    ["name"] = "헬리아",
                }, -- [3]
            },
        }, -- [3]
        {
            ["id"] = 786,
            ["image"] = 1450575,
            ["name"] = "밤의 요새",
            ["bosses"] = {
                {
                    ["id"] = 1706,
                    ["image"] = 1410981,
                    ["name"] = "스코르파이론",
                }, -- [1]
                {
                    ["id"] = 1725,
                    ["image"] = 1410941,
                    ["name"] = "시간 변형체",
                }, -- [2]
                {
                    ["id"] = 1731,
                    ["image"] = 1410989,
                    ["name"] = "트릴리악스",
                }, -- [3]
                {
                    ["id"] = 1751,
                    ["image"] = 1410983,
                    ["name"] = "마법검사 알루리엘",
                }, -- [4]
                {
                    ["id"] = 1762,
                    ["image"] = 1410987,
                    ["name"] = "티콘드리우스",
                }, -- [5]
                {
                    ["id"] = 1713,
                    ["image"] = 1410965,
                    ["name"] = "크로서스",
                }, -- [6]
                {
                    ["id"] = 1761,
                    ["image"] = 1410939,
                    ["name"] = "고위 식물학자 텔아른",
                }, -- [7]
                {
                    ["id"] = 1732,
                    ["image"] = 1410984,
                    ["name"] = "별 점술가 에트레우스",
                }, -- [8]
                {
                    ["id"] = 1743,
                    ["image"] = 1410954,
                    ["name"] = "대마법학자 엘리산드",
                }, -- [9]
                {
                    ["id"] = 1737,
                    ["image"] = 1410955,
                    ["name"] = "굴단",
                }, -- [10]
            },
        }, -- [4]
        {
            ["id"] = 875,
            ["image"] = 1616106,
            ["name"] = "살게라스의 무덤",
            ["bosses"] = {
                {
                    ["id"] = 1862,
                    ["image"] = 1579934,
                    ["name"] = "고로스",
                }, -- [1]
                {
                    ["id"] = 1867,
                    ["image"] = 1579936,
                    ["name"] = "악마 심문관",
                }, -- [2]
                {
                    ["id"] = 1856,
                    ["image"] = 1579940,
                    ["name"] = "하르자탄",
                }, -- [3]
                {
                    ["id"] = 1903,
                    ["image"] = 1579935,
                    ["name"] = "달의 자매",
                }, -- [4]
                {
                    ["id"] = 1861,
                    ["image"] = 1579939,
                    ["name"] = "여군주 사스즈인",
                }, -- [5]
                {
                    ["id"] = 1896,
                    ["image"] = 1579943,
                    ["name"] = "황폐의 숙주",
                }, -- [6]
                {
                    ["id"] = 1897,
                    ["image"] = 1579933,
                    ["name"] = "경계의 여신",
                }, -- [7]
                {
                    ["id"] = 1873,
                    ["image"] = 1579932,
                    ["name"] = "몰락한 화신",
                }, -- [8]
                {
                    ["id"] = 1898,
                    ["image"] = 1385746,
                    ["name"] = "킬제덴",
                }, -- [9]
            },
        }, -- [5]
        {
            ["id"] = 946,
            ["image"] = 1718211,
            ["name"] = "안토러스 - 불타는 왕좌",
            ["bosses"] = {
                {
                    ["id"] = 1992,
                    ["image"] = 1715210,
                    ["name"] = "가로시 세계파괴자",
                }, -- [1]
                {
                    ["id"] = 1987,
                    ["image"] = 1715209,
                    ["name"] = "살게라스의 지옥사냥개",
                }, -- [2]
                {
                    ["id"] = 1997,
                    ["image"] = 1715225,
                    ["name"] = "안토란 총사령부",
                }, -- [3]
                {
                    ["id"] = 1985,
                    ["image"] = 1715219,
                    ["name"] = "차원문 수호병 하사벨",
                }, -- [4]
                {
                    ["id"] = 2025,
                    ["image"] = 1715208,
                    ["name"] = "생명의 어머니 이오나",
                }, -- [5]
                {
                    ["id"] = 2009,
                    ["image"] = 1715211,
                    ["name"] = "영혼사냥꾼 이모나르",
                }, -- [6]
                {
                    ["id"] = 2004,
                    ["image"] = 1715213,
                    ["name"] = "킨가로스",
                }, -- [7]
                {
                    ["id"] = 1983,
                    ["image"] = 1715223,
                    ["name"] = "바리마트라스",
                }, -- [8]
                {
                    ["id"] = 1986,
                    ["image"] = 1715222,
                    ["name"] = "쉬바라의 집회",
                }, -- [9]
                {
                    ["id"] = 1984,
                    ["image"] = 1715207,
                    ["name"] = "아그라마르",
                }, -- [10]
                {
                    ["id"] = 2031,
                    ["image"] = 1715536,
                    ["name"] = "사멸자 아르거스",
                }, -- [11]
            },
        }, -- [6]
        {
            ["id"] = 959,
            ["image"] = 1718212,
            ["name"] = "침공 거점",
            ["bosses"] = {
                {
                    ["id"] = 2010,
                    ["image"] = 1715215,
                    ["name"] = "대모 폴누나",
                }, -- [1]
                {
                    ["id"] = 2011,
                    ["image"] = 1715216,
                    ["name"] = "여군주 알루라델",
                }, -- [2]
                {
                    ["id"] = 2012,
                    ["image"] = 1715212,
                    ["name"] = "심문관 메토",
                }, -- [3]
                {
                    ["id"] = 2013,
                    ["image"] = 1715217,
                    ["name"] = "오큘라러스",
                }, -- [4]
                {
                    ["id"] = 2014,
                    ["image"] = 1715221,
                    ["name"] = "소타나토르",
                }, -- [5]
                {
                    ["id"] = 2015,
                    ["image"] = 1715218,
                    ["name"] = "지옥의 군주 바일머스",
                }, -- [6]
            },
        }, -- [7]
        {
            ["id"] = 707,
            ["image"] = 1411858,
            ["name"] = "감시관의 금고",
            ["bosses"] = {
                {
                    ["id"] = 1467,
                    ["image"] = 1410988,
                    ["name"] = "티라손 살데릴",
                }, -- [1]
                {
                    ["id"] = 1695,
                    ["image"] = 1410962,
                    ["name"] = "심문관 토르멘토룸",
                }, -- [2]
                {
                    ["id"] = 1468,
                    ["image"] = 1410937,
                    ["name"] = "잿바위거수",
                }, -- [3]
                {
                    ["id"] = 1469,
                    ["image"] = 1410952,
                    ["name"] = "꿈벅마",
                }, -- [4]
                {
                    ["id"] = 1470,
                    ["image"] = 1410942,
                    ["name"] = "콜다나 펠송",
                }, -- [5]
            },
        }, -- [8]
        {
            ["id"] = 740,
            ["image"] = 1411853,
            ["name"] = "검은 떼까마귀 요새",
            ["bosses"] = {
                {
                    ["id"] = 1518,
                    ["image"] = 1410986,
                    ["name"] = "영혼의 융합체",
                }, -- [1]
                {
                    ["id"] = 1653,
                    ["image"] = 1410961,
                    ["name"] = "일리산나 레이븐크레스트",
                }, -- [2]
                {
                    ["id"] = 1664,
                    ["image"] = 1410982,
                    ["name"] = "혐오스러운 원한강타",
                }, -- [3]
                {
                    ["id"] = 1672,
                    ["image"] = 1410967,
                    ["name"] = "군주 쿠르탈로스 레이븐크레스트",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 767,
            ["image"] = 1450574,
            ["name"] = "넬타리온의 둥지",
            ["bosses"] = {
                {
                    ["id"] = 1662,
                    ["image"] = 1410976,
                    ["name"] = "로크모라",
                }, -- [1]
                {
                    ["id"] = 1665,
                    ["image"] = 1410990,
                    ["name"] = "바위구체자 울라로그",
                }, -- [2]
                {
                    ["id"] = 1673,
                    ["image"] = 1410971,
                    ["name"] = "나락사스",
                }, -- [3]
                {
                    ["id"] = 1687,
                    ["image"] = 1410944,
                    ["name"] = "지저왕 다르그룰",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 860,
            ["image"] = 1537283,
            ["name"] = "다시 찾은 카라잔",
            ["bosses"] = {
                {
                    ["id"] = 1820,
                    ["image"] = 1536495,
                    ["name"] = "오페라 극장: 우끼드",
                }, -- [1]
                {
                    ["id"] = 1826,
                    ["image"] = 1536494,
                    ["name"] = "오페라 극장: 서부 몰락지대 이야기",
                }, -- [2]
                {
                    ["id"] = 1827,
                    ["image"] = 1536493,
                    ["name"] = "오페라 극장: 미녀와 짐승",
                }, -- [3]
                {
                    ["id"] = 1825,
                    ["image"] = 1378997,
                    ["name"] = "고결의 여신",
                }, -- [4]
                {
                    ["id"] = 1835,
                    ["image"] = 1536490,
                    ["name"] = "사냥꾼 어튜멘",
                }, -- [5]
                {
                    ["id"] = 1837,
                    ["image"] = 1378999,
                    ["name"] = "모로스",
                }, -- [6]
                {
                    ["id"] = 1836,
                    ["image"] = 1379020,
                    ["name"] = "전시 관리인",
                }, -- [7]
                {
                    ["id"] = 1817,
                    ["image"] = 1536496,
                    ["name"] = "메디브의 망령",
                }, -- [8]
                {
                    ["id"] = 1818,
                    ["image"] = 1536492,
                    ["name"] = "마나 포식자",
                }, -- [9]
                {
                    ["id"] = 1838,
                    ["image"] = 1536497,
                    ["name"] = "감시자 비즈아둠",
                }, -- [10]
            },
        }, -- [11]
        {
            ["id"] = 800,
            ["image"] = 1498156,
            ["name"] = "별의 궁정",
            ["bosses"] = {
                {
                    ["id"] = 1718,
                    ["image"] = 1410975,
                    ["name"] = "경비대 대장 게르도",
                }, -- [1]
                {
                    ["id"] = 1719,
                    ["image"] = 1410985,
                    ["name"] = "탈릭세이 플레임리스",
                }, -- [2]
                {
                    ["id"] = 1720,
                    ["image"] = 1410933,
                    ["name"] = "조언가 멜란드루스",
                }, -- [3]
            },
        }, -- [12]
        {
            ["id"] = 777,
            ["image"] = 1498155,
            ["name"] = "보랏빛 요새 침공",
            ["bosses"] = {
                {
                    ["id"] = 1693,
                    ["image"] = 1410950,
                    ["name"] = "구린얼굴",
                }, -- [1]
                {
                    ["id"] = 1694,
                    ["image"] = 1410980,
                    ["name"] = "한기아귀",
                }, -- [2]
                {
                    ["id"] = 1702,
                    ["image"] = 1410938,
                    ["name"] = "피의 공주 탈레나",
                }, -- [3]
                {
                    ["id"] = 1686,
                    ["image"] = 1410969,
                    ["name"] = "정신파괴자 카르즈",
                }, -- [4]
                {
                    ["id"] = 1688,
                    ["image"] = 1410968,
                    ["name"] = "밀리피센트 마나스톰",
                }, -- [5]
                {
                    ["id"] = 1696,
                    ["image"] = 1410935,
                    ["name"] = "아눕에세트",
                }, -- [6]
                {
                    ["id"] = 1697,
                    ["image"] = 1410977,
                    ["name"] = "사엘로른",
                }, -- [7]
                {
                    ["id"] = 1711,
                    ["image"] = 1410948,
                    ["name"] = "지옥 군주 베트루그",
                }, -- [8]
            },
        }, -- [13]
        {
            ["id"] = 726,
            ["image"] = 1411857,
            ["name"] = "비전로",
            ["bosses"] = {
                {
                    ["id"] = 1497,
                    ["image"] = 1410963,
                    ["name"] = "아이반니르",
                }, -- [1]
                {
                    ["id"] = 1498,
                    ["image"] = 1410943,
                    ["name"] = "코스틸락스",
                }, -- [2]
                {
                    ["id"] = 1499,
                    ["image"] = 1410951,
                    ["name"] = "장군 자칼",
                }, -- [3]
                {
                    ["id"] = 1500,
                    ["image"] = 1410970,
                    ["name"] = "날티라",
                }, -- [4]
                {
                    ["id"] = 1501,
                    ["image"] = 1410934,
                    ["name"] = "조언자 반드로스",
                }, -- [5]
            },
        }, -- [14]
        {
            ["id"] = 945,
            ["image"] = 1718213,
            ["name"] = "삼두정의 권좌",
            ["bosses"] = {
                {
                    ["id"] = 1979,
                    ["image"] = 1715226,
                    ["name"] = "승천자 주라알",
                }, -- [1]
                {
                    ["id"] = 1980,
                    ["image"] = 1715220,
                    ["name"] = "사프리쉬",
                }, -- [2]
                {
                    ["id"] = 1981,
                    ["image"] = 1715224,
                    ["name"] = "총독 네자르",
                }, -- [3]
                {
                    ["id"] = 1982,
                    ["image"] = 1715214,
                    ["name"] = "르우라",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 716,
            ["image"] = 1498157,
            ["name"] = "아즈샤라의 눈",
            ["bosses"] = {
                {
                    ["id"] = 1480,
                    ["image"] = 1410992,
                    ["name"] = "전쟁군주 파르제쉬",
                }, -- [1]
                {
                    ["id"] = 1490,
                    ["image"] = 1410966,
                    ["name"] = "증오갈퀴 여군주",
                }, -- [2]
                {
                    ["id"] = 1491,
                    ["image"] = 1410964,
                    ["name"] = "국왕 딥비어드",
                }, -- [3]
                {
                    ["id"] = 1479,
                    ["image"] = 1410978,
                    ["name"] = "서펜트릭스",
                }, -- [4]
                {
                    ["id"] = 1492,
                    ["image"] = 1410993,
                    ["name"] = "아즈샤라의 분노",
                }, -- [5]
            },
        }, -- [16]
        {
            ["id"] = 762,
            ["image"] = 1411855,
            ["name"] = "어둠심장 숲",
            ["bosses"] = {
                {
                    ["id"] = 1654,
                    ["image"] = 1410936,
                    ["name"] = "대드루이드 글라이달리스",
                }, -- [1]
                {
                    ["id"] = 1655,
                    ["image"] = 1410973,
                    ["name"] = "나무심장",
                }, -- [2]
                {
                    ["id"] = 1656,
                    ["image"] = 1410946,
                    ["name"] = "드레사론",
                }, -- [3]
                {
                    ["id"] = 1657,
                    ["image"] = 1410979,
                    ["name"] = "자비우스의 망령",
                }, -- [4]
            },
        }, -- [17]
        {
            ["id"] = 900,
            ["image"] = 1616922,
            ["name"] = "영원한 밤의 대성당",
            ["bosses"] = {
                {
                    ["id"] = 1905,
                    ["image"] = 1579930,
                    ["name"] = "아그로녹스",
                }, -- [1]
                {
                    ["id"] = 1906,
                    ["image"] = 1579942,
                    ["name"] = "경멸하는 난타이빨",
                }, -- [2]
                {
                    ["id"] = 1904,
                    ["image"] = 1579931,
                    ["name"] = "도마트락스",
                }, -- [3]
                {
                    ["id"] = 1878,
                    ["image"] = 1579938,
                    ["name"] = "메피스트로스",
                }, -- [4]
            },
        }, -- [18]
        {
            ["id"] = 727,
            ["image"] = 1411856,
            ["name"] = "영혼의 아귀",
            ["bosses"] = {
                {
                    ["id"] = 1502,
                    ["image"] = 1410995,
                    ["name"] = "타락한 왕 이미론",
                }, -- [1]
                {
                    ["id"] = 1512,
                    ["image"] = 1410956,
                    ["name"] = "하르바론",
                }, -- [2]
                {
                    ["id"] = 1663,
                    ["image"] = 1410957,
                    ["name"] = "헬리아",
                }, -- [3]
            },
        }, -- [19]
        {
            ["id"] = 721,
            ["image"] = 1498158,
            ["name"] = "용맹의 전당",
            ["bosses"] = {
                {
                    ["id"] = 1485,
                    ["image"] = 1410958,
                    ["name"] = "하임달",
                }, -- [1]
                {
                    ["id"] = 1486,
                    ["image"] = 1410959,
                    ["name"] = "히리아",
                }, -- [2]
                {
                    ["id"] = 1487,
                    ["image"] = 1410949,
                    ["name"] = "펜리르",
                }, -- [3]
                {
                    ["id"] = 1488,
                    ["image"] = 1410953,
                    ["name"] = "신왕 스코발드",
                }, -- [4]
                {
                    ["id"] = 1489,
                    ["image"] = 1410974,
                    ["name"] = "오딘",
                }, -- [5]
            },
        }, -- [20]
    },
    ["어둠땅"] = {
        {
            ["id"] = 1192,
            ["image"] = 3850569,
            ["name"] = "어둠땅",
            ["bosses"] = {
                {
                    ["id"] = 2430,
                    ["image"] = 3752195,
                    ["name"] = "영겁의 빛 발리노어",
                }, -- [1]
                {
                    ["id"] = 2431,
                    ["image"] = 3752183,
                    ["name"] = "모르타니스",
                }, -- [2]
                {
                    ["id"] = 2432,
                    ["image"] = 3752188,
                    ["name"] = "영원히 뻗어나가는 오라노모노스",
                }, -- [3]
                {
                    ["id"] = 2433,
                    ["image"] = 3752187,
                    ["name"] = "진흙살이 누르가쉬",
                }, -- [4]
                {
                    ["id"] = 2456,
                    ["image"] = 4071436,
                    ["name"] = "저주받은 자들의 고문관 모르제스",
                }, -- [5]
                {
                    ["id"] = 2468,
                    ["image"] = 4529365,
                    ["name"] = "안트로스",
                }, -- [6]
            },
        }, -- [1]
        {
            ["id"] = 1190,
            ["image"] = 3759906,
            ["name"] = "나스리아 성채",
            ["bosses"] = {
                {
                    ["id"] = 2393,
                    ["image"] = 3752190,
                    ["name"] = "절규날개",
                }, -- [1]
                {
                    ["id"] = 2429,
                    ["image"] = 3753151,
                    ["name"] = "사냥꾼 알티모르",
                }, -- [2]
                {
                    ["id"] = 2422,
                    ["image"] = 3753157,
                    ["name"] = "태양왕의 구원",
                }, -- [3]
                {
                    ["id"] = 2418,
                    ["image"] = 3752156,
                    ["name"] = "기술자 자이목스",
                }, -- [4]
                {
                    ["id"] = 2428,
                    ["image"] = 3752174,
                    ["name"] = "굶주린 파괴자",
                }, -- [5]
                {
                    ["id"] = 2420,
                    ["image"] = 3752178,
                    ["name"] = "귀부인 이네르바 다크베인",
                }, -- [6]
                {
                    ["id"] = 2426,
                    ["image"] = 3753159,
                    ["name"] = "혈기의 의회",
                }, -- [7]
                {
                    ["id"] = 2394,
                    ["image"] = 3752191,
                    ["name"] = "진흙주먹",
                }, -- [8]
                {
                    ["id"] = 2425,
                    ["image"] = 3753156,
                    ["name"] = "돌 군단 장군",
                }, -- [9]
                {
                    ["id"] = 2424,
                    ["image"] = 3752159,
                    ["name"] = "대영주 데나트리우스",
                }, -- [10]
            },
        }, -- [2]
        {
            ["id"] = 1193,
            ["image"] = 4182020,
            ["name"] = "지배의 성소",
            ["bosses"] = {
                {
                    ["id"] = 2435,
                    ["image"] = 4071444,
                    ["name"] = "대지공포",
                }, -- [1]
                {
                    ["id"] = 2442,
                    ["image"] = 4071426,
                    ["name"] = "간수의 눈",
                }, -- [2]
                {
                    ["id"] = 2439,
                    ["image"] = 4071445,
                    ["name"] = "아홉 발키르",
                }, -- [3]
                {
                    ["id"] = 2444,
                    ["image"] = 4071439,
                    ["name"] = "넬쥴의 잔재",
                }, -- [4]
                {
                    ["id"] = 2445,
                    ["image"] = 4071442,
                    ["name"] = "영혼분리자 도르마잔",
                }, -- [5]
                {
                    ["id"] = 2443,
                    ["image"] = 4079051,
                    ["name"] = "고통장이 라즈날",
                }, -- [6]
                {
                    ["id"] = 2446,
                    ["image"] = 4071428,
                    ["name"] = "태초의 존재의 수호자",
                }, -- [7]
                {
                    ["id"] = 2447,
                    ["image"] = 4071427,
                    ["name"] = "운명필경사 로칼로",
                }, -- [8]
                {
                    ["id"] = 2440,
                    ["image"] = 4071435,
                    ["name"] = "켈투자드",
                }, -- [9]
                {
                    ["id"] = 2441,
                    ["image"] = 4071443,
                    ["name"] = "실바나스 윈드러너",
                }, -- [10]
            },
        }, -- [3]
        {
            ["id"] = 1195,
            ["image"] = 4423752,
            ["name"] = "태초의 존재의 매장터",
            ["bosses"] = {
                {
                    ["id"] = 2458,
                    ["image"] = 4465340,
                    ["name"] = "경계하는 수호자",
                }, -- [1]
                {
                    ["id"] = 2465,
                    ["image"] = 4465339,
                    ["name"] = "만족을 모르는 강탈자 스콜렉스",
                }, -- [2]
                {
                    ["id"] = 2470,
                    ["image"] = 4423749,
                    ["name"] = "기술자 자이목스",
                }, -- [3]
                {
                    ["id"] = 2459,
                    ["image"] = 4465333,
                    ["name"] = "타락한 예언자 다우세그네",
                }, -- [4]
                {
                    ["id"] = 2460,
                    ["image"] = 4465337,
                    ["name"] = "판테온의 원형",
                }, -- [5]
                {
                    ["id"] = 2461,
                    ["image"] = 4465335,
                    ["name"] = "최고위 설계사 리후빔",
                }, -- [6]
                {
                    ["id"] = 2463,
                    ["image"] = 4423738,
                    ["name"] = "되찾는 자 할론드루스",
                }, -- [7]
                {
                    ["id"] = 2469,
                    ["image"] = 4423747,
                    ["name"] = "안두인 린",
                }, -- [8]
                {
                    ["id"] = 2457,
                    ["image"] = 4465336,
                    ["name"] = "공포의 군주",
                }, -- [9]
                {
                    ["id"] = 2467,
                    ["image"] = 4465338,
                    ["name"] = "라이겔론",
                }, -- [10]
                {
                    ["id"] = 2464,
                    ["image"] = 4465334,
                    ["name"] = "간수",
                }, -- [11]
            },
        }, -- [4]
        {
            ["id"] = 1187,
            ["image"] = 3759914,
            ["name"] = "고통의 투기장",
            ["bosses"] = {
                {
                    ["id"] = 2397,
                    ["image"] = 3752153,
                    ["name"] = "오만불손한 도전자",
                }, -- [1]
                {
                    ["id"] = 2401,
                    ["image"] = 3752169,
                    ["name"] = "선혈토막",
                }, -- [2]
                {
                    ["id"] = 2390,
                    ["image"] = 3752199,
                    ["name"] = "몰락하지 않은 자 자브",
                }, -- [3]
                {
                    ["id"] = 2389,
                    ["image"] = 3753154,
                    ["name"] = "쿨타로크",
                }, -- [4]
                {
                    ["id"] = 2417,
                    ["image"] = 3752182,
                    ["name"] = "무한의 여제 모르드레타",
                }, -- [5]
            },
        }, -- [5]
        {
            ["id"] = 1194,
            ["image"] = 4182022,
            ["name"] = "미지의 시장 타자베쉬",
            ["bosses"] = {
                {
                    ["id"] = 2437,
                    ["image"] = 4071449,
                    ["name"] = "파수꾼 조펙스",
                }, -- [1]
                {
                    ["id"] = 2454,
                    ["image"] = 4071447,
                    ["name"] = "대사육장",
                }, -- [2]
                {
                    ["id"] = 2436,
                    ["image"] = 4071438,
                    ["name"] = "우편물실 대소동",
                }, -- [3]
                {
                    ["id"] = 2452,
                    ["image"] = 4071448,
                    ["name"] = "마이자의 오아시스",
                }, -- [4]
                {
                    ["id"] = 2451,
                    ["image"] = 4071440,
                    ["name"] = "소아즈미",
                }, -- [5]
                {
                    ["id"] = 2448,
                    ["image"] = 4071429,
                    ["name"] = "힐브란데",
                }, -- [6]
                {
                    ["id"] = 2449,
                    ["image"] = 4071446,
                    ["name"] = "시간선장 후크테일",
                }, -- [7]
                {
                    ["id"] = 2455,
                    ["image"] = 4071441,
                    ["name"] = "소레아",
                }, -- [8]
            },
        }, -- [6]
        {
            ["id"] = 1185,
            ["image"] = 3759908,
            ["name"] = "속죄의 전당",
            ["bosses"] = {
                {
                    ["id"] = 2406,
                    ["image"] = 3752171,
                    ["name"] = "죄악에 물든 거수 할키아스",
                }, -- [1]
                {
                    ["id"] = 2387,
                    ["image"] = 3752165,
                    ["name"] = "에첼론",
                }, -- [2]
                {
                    ["id"] = 2411,
                    ["image"] = 3753150,
                    ["name"] = "대심판관 알리즈",
                }, -- [3]
                {
                    ["id"] = 2413,
                    ["image"] = 3752179,
                    ["name"] = "시종장",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 1186,
            ["image"] = 3759913,
            ["name"] = "승천의 첨탑",
            ["bosses"] = {
                {
                    ["id"] = 2399,
                    ["image"] = 3752177,
                    ["name"] = "킨타라",
                }, -- [1]
                {
                    ["id"] = 2416,
                    ["image"] = 3752198,
                    ["name"] = "벤투낙스",
                }, -- [2]
                {
                    ["id"] = 2414,
                    ["image"] = 3752189,
                    ["name"] = "오리프리온",
                }, -- [3]
                {
                    ["id"] = 2412,
                    ["image"] = 3752160,
                    ["name"] = "의심의 용장 데보스",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 1183,
            ["image"] = 3759911,
            ["name"] = "역병 몰락지",
            ["bosses"] = {
                {
                    ["id"] = 2419,
                    ["image"] = 3752168,
                    ["name"] = "점액살거수",
                }, -- [1]
                {
                    ["id"] = 2403,
                    ["image"] = 3752162,
                    ["name"] = "의사 이커스",
                }, -- [2]
                {
                    ["id"] = 2423,
                    ["image"] = 3752163,
                    ["name"] = "도미나 베놈블레이드",
                }, -- [3]
                {
                    ["id"] = 2404,
                    ["image"] = 3752180,
                    ["name"] = "후작 스트라다마",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 1188,
            ["image"] = 3759915,
            ["name"] = "저편",
            ["bosses"] = {
                {
                    ["id"] = 2408,
                    ["image"] = 3752170,
                    ["name"] = "영혼약탈자 학카르",
                }, -- [1]
                {
                    ["id"] = 2409,
                    ["image"] = 3752193,
                    ["name"] = "마나스톰 부부",
                }, -- [2]
                {
                    ["id"] = 2398,
                    ["image"] = 3753147,
                    ["name"] = "무역업자 자이엑사",
                }, -- [3]
                {
                    ["id"] = 2410,
                    ["image"] = 3752184,
                    ["name"] = "무에젤라",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 1182,
            ["image"] = 3759910,
            ["name"] = "죽음의 상흔",
            ["bosses"] = {
                {
                    ["id"] = 2395,
                    ["image"] = 3752157,
                    ["name"] = "역병뼈닥이",
                }, -- [1]
                {
                    ["id"] = 2391,
                    ["image"] = 3753146,
                    ["name"] = "수확자 아마스",
                }, -- [2]
                {
                    ["id"] = 2392,
                    ["image"] = 3753158,
                    ["name"] = "의사 스티치플레시",
                }, -- [3]
                {
                    ["id"] = 2396,
                    ["image"] = 3753155,
                    ["name"] = "냉기결속사 날토르",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 1184,
            ["image"] = 3759909,
            ["name"] = "티르너 사이드의 안개",
            ["bosses"] = {
                {
                    ["id"] = 2400,
                    ["image"] = 3753152,
                    ["name"] = "잉그라 말로크",
                }, -- [1]
                {
                    ["id"] = 2402,
                    ["image"] = 3752181,
                    ["name"] = "미스트콜러",
                }, -- [2]
                {
                    ["id"] = 2405,
                    ["image"] = 3752194,
                    ["name"] = "트레도바",
                }, -- [3]
            },
        }, -- [12]
        {
            ["id"] = 1189,
            ["image"] = 3759912,
            ["name"] = "핏빛 심연",
            ["bosses"] = {
                {
                    ["id"] = 2388,
                    ["image"] = 3753153,
                    ["name"] = "탐식자 크릭시스",
                }, -- [1]
                {
                    ["id"] = 2415,
                    ["image"] = 3753148,
                    ["name"] = "집행관 타르볼드",
                }, -- [2]
                {
                    ["id"] = 2421,
                    ["image"] = 3753149,
                    ["name"] = "대감독관 베릴리아",
                }, -- [3]
                {
                    ["id"] = 2407,
                    ["image"] = 3752167,
                    ["name"] = "장군 카알",
                }, -- [4]
            },
        }, -- [13]
    },
    ["판다리아의 안개"] = {
        {
            ["id"] = 322,
            ["image"] = 652218,
            ["name"] = "판다리아",
            ["bosses"] = {
                {
                    ["id"] = 691,
                    ["image"] = 630847,
                    ["name"] = "분노의 샤",
                }, -- [1]
                {
                    ["id"] = 725,
                    ["image"] = 630819,
                    ["name"] = "살리스의 전투부대",
                }, -- [2]
                {
                    ["id"] = 814,
                    ["image"] = 796778,
                    ["name"] = "폭풍 군주 나락크",
                }, -- [3]
                {
                    ["id"] = 826,
                    ["image"] = 796779,
                    ["name"] = "운다스타",
                }, -- [4]
                {
                    ["id"] = 857,
                    ["image"] = 901155,
                    ["name"] = "주학 츠지",
                }, -- [5]
                {
                    ["id"] = 858,
                    ["image"] = 901173,
                    ["name"] = "옥룡 위론",
                }, -- [6]
                {
                    ["id"] = 859,
                    ["image"] = 901165,
                    ["name"] = "흑우 니우짜오",
                }, -- [7]
                {
                    ["id"] = 860,
                    ["image"] = 901172,
                    ["name"] = "백호 쉬엔",
                }, -- [8]
                {
                    ["id"] = 861,
                    ["image"] = 901167,
                    ["name"] = "오르도스 - 야운골의 화염신",
                }, -- [9]
            },
        }, -- [1]
        {
            ["id"] = 317,
            ["image"] = 632273,
            ["name"] = "모구샨 금고",
            ["bosses"] = {
                {
                    ["id"] = 679,
                    ["image"] = 630820,
                    ["name"] = "바위 수호자",
                }, -- [1]
                {
                    ["id"] = 689,
                    ["image"] = 630824,
                    ["name"] = "저주받은 펑",
                }, -- [2]
                {
                    ["id"] = 682,
                    ["image"] = 630826,
                    ["name"] = "영혼결속자 가라잘",
                }, -- [3]
                {
                    ["id"] = 687,
                    ["image"] = 630861,
                    ["name"] = "유령 왕",
                }, -- [4]
                {
                    ["id"] = 726,
                    ["image"] = 630823,
                    ["name"] = "엘레곤",
                }, -- [5]
                {
                    ["id"] = 677,
                    ["image"] = 630836,
                    ["name"] = "황제의 의지",
                }, -- [6]
            },
        }, -- [2]
        {
            ["id"] = 330,
            ["image"] = 632271,
            ["name"] = "공포의 심장",
            ["bosses"] = {
                {
                    ["id"] = 745,
                    ["image"] = 630834,
                    ["name"] = "황실 장로 조르로크",
                }, -- [1]
                {
                    ["id"] = 744,
                    ["image"] = 630817,
                    ["name"] = "칼날군주 타야크",
                }, -- [2]
                {
                    ["id"] = 713,
                    ["image"] = 630827,
                    ["name"] = "가랄론",
                }, -- [3]
                {
                    ["id"] = 741,
                    ["image"] = 630856,
                    ["name"] = "바람군주 멜자라크",
                }, -- [4]
                {
                    ["id"] = 737,
                    ["image"] = 630815,
                    ["name"] = "호박석구체자 운속",
                }, -- [5]
                {
                    ["id"] = 743,
                    ["image"] = 630830,
                    ["name"] = "위대한 여제 셰크지르",
                }, -- [6]
            },
        }, -- [3]
        {
            ["id"] = 320,
            ["image"] = 643264,
            ["name"] = "영원한 봄의 정원",
            ["bosses"] = {
                {
                    ["id"] = 683,
                    ["image"] = 630844,
                    ["name"] = "영원의 수호병",
                }, -- [1]
                {
                    ["id"] = 742,
                    ["image"] = 630854,
                    ["name"] = "출롱",
                }, -- [2]
                {
                    ["id"] = 729,
                    ["image"] = 630837,
                    ["name"] = "레이 스",
                }, -- [3]
                {
                    ["id"] = 709,
                    ["image"] = 630849,
                    ["name"] = "공포의 샤",
                }, -- [4]
            },
        }, -- [4]
        {
            ["id"] = 362,
            ["image"] = 828453,
            ["name"] = "천둥의 왕좌",
            ["bosses"] = {
                {
                    ["id"] = 827,
                    ["image"] = 796776,
                    ["name"] = "파괴자 진로크",
                }, -- [1]
                {
                    ["id"] = 819,
                    ["image"] = 796774,
                    ["name"] = "호리돈",
                }, -- [2]
                {
                    ["id"] = 816,
                    ["image"] = 796770,
                    ["name"] = "장로회",
                }, -- [3]
                {
                    ["id"] = 825,
                    ["image"] = 796781,
                    ["name"] = "토르토스",
                }, -- [4]
                {
                    ["id"] = 821,
                    ["image"] = 796786,
                    ["name"] = "메가이라",
                }, -- [5]
                {
                    ["id"] = 828,
                    ["image"] = 796785,
                    ["name"] = "지쿤",
                }, -- [6]
                {
                    ["id"] = 818,
                    ["image"] = 796772,
                    ["name"] = "잊혀진 두루무",
                }, -- [7]
                {
                    ["id"] = 820,
                    ["image"] = 796780,
                    ["name"] = "프리모디우스",
                }, -- [8]
                {
                    ["id"] = 824,
                    ["image"] = 796771,
                    ["name"] = "암흑 원령",
                }, -- [9]
                {
                    ["id"] = 817,
                    ["image"] = 796775,
                    ["name"] = "강철의 퀀",
                }, -- [10]
                {
                    ["id"] = 829,
                    ["image"] = 796773,
                    ["name"] = "쌍둥이 왕비",
                }, -- [11]
                {
                    ["id"] = 832,
                    ["image"] = 796777,
                    ["name"] = "레이 션",
                }, -- [12]
            },
        }, -- [5]
        {
            ["id"] = 369,
            ["image"] = 904981,
            ["name"] = "오그리마 공성전",
            ["bosses"] = {
                {
                    ["id"] = 852,
                    ["image"] = 901160,
                    ["name"] = "잿빛너울",
                }, -- [1]
                {
                    ["id"] = 849,
                    ["image"] = 901159,
                    ["name"] = "쓰러진 수호자들",
                }, -- [2]
                {
                    ["id"] = 866,
                    ["image"] = 901166,
                    ["name"] = "노루셴",
                }, -- [3]
                {
                    ["id"] = 867,
                    ["image"] = 901168,
                    ["name"] = "교만의 샤",
                }, -- [4]
                {
                    ["id"] = 868,
                    ["image"] = 901156,
                    ["name"] = "갈라크라스",
                }, -- [5]
                {
                    ["id"] = 864,
                    ["image"] = 901161,
                    ["name"] = "강철의 거대괴수",
                }, -- [6]
                {
                    ["id"] = 856,
                    ["image"] = 901163,
                    ["name"] = "코르크론 암흑주술사",
                }, -- [7]
                {
                    ["id"] = 850,
                    ["image"] = 901158,
                    ["name"] = "장군 나즈그림",
                }, -- [8]
                {
                    ["id"] = 846,
                    ["image"] = 901164,
                    ["name"] = "말코록",
                }, -- [9]
                {
                    ["id"] = 870,
                    ["image"] = 901170,
                    ["name"] = "판다리아의 전리품",
                }, -- [10]
                {
                    ["id"] = 851,
                    ["image"] = 901171,
                    ["name"] = "피에 굶주린 토크",
                }, -- [11]
                {
                    ["id"] = 865,
                    ["image"] = 901169,
                    ["name"] = "공성기술자 블랙퓨즈",
                }, -- [12]
                {
                    ["id"] = 853,
                    ["image"] = 901162,
                    ["name"] = "클락시 용장들",
                }, -- [13]
                {
                    ["id"] = 869,
                    ["image"] = 901157,
                    ["name"] = "가로쉬 헬스크림",
                }, -- [14]
            },
        }, -- [6]
        {
            ["id"] = 324,
            ["image"] = 643263,
            ["name"] = "니우짜오 사원 공성전투",
            ["bosses"] = {
                {
                    ["id"] = 693,
                    ["image"] = 630855,
                    ["name"] = "장로 진바크",
                }, -- [1]
                {
                    ["id"] = 738,
                    ["image"] = 630822,
                    ["name"] = "사령관 보자크",
                }, -- [2]
                {
                    ["id"] = 692,
                    ["image"] = 630829,
                    ["name"] = "장군 파발락",
                }, -- [3]
                {
                    ["id"] = 727,
                    ["image"] = 630857,
                    ["name"] = "편대사령관 네르오노크",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 321,
            ["image"] = 632272,
            ["name"] = "모구샨 궁전",
            ["bosses"] = {
                {
                    ["id"] = 708,
                    ["image"] = 630842,
                    ["name"] = "왕의 시험",
                }, -- [1]
                {
                    ["id"] = 690,
                    ["image"] = 630828,
                    ["name"] = "게칸",
                }, -- [2]
                {
                    ["id"] = 698,
                    ["image"] = 630859,
                    ["name"] = "무기달인 신",
                }, -- [3]
            },
        }, -- [8]
        {
            ["id"] = 316,
            ["image"] = 608214,
            ["name"] = "붉은십자군 수도원",
            ["bosses"] = {
                {
                    ["id"] = 688,
                    ["image"] = 630853,
                    ["name"] = "영혼분리자 탈노스",
                }, -- [1]
                {
                    ["id"] = 671,
                    ["image"] = 630818,
                    ["name"] = "수사 콜로프",
                }, -- [2]
                {
                    ["id"] = 674,
                    ["image"] = 607643,
                    ["name"] = "종교재판관 화이트메인",
                }, -- [3]
            },
        }, -- [9]
        {
            ["id"] = 311,
            ["image"] = 643262,
            ["name"] = "붉은십자군 전당",
            ["bosses"] = {
                {
                    ["id"] = 660,
                    ["image"] = 630833,
                    ["name"] = "사냥개조련사 브라운",
                }, -- [1]
                {
                    ["id"] = 654,
                    ["image"] = 630816,
                    ["name"] = "무기전문가 할란",
                }, -- [2]
                {
                    ["id"] = 656,
                    ["image"] = 630825,
                    ["name"] = "화염술사 쾨글러",
                }, -- [3]
            },
        }, -- [10]
        {
            ["id"] = 303,
            ["image"] = 632270,
            ["name"] = "석양문",
            ["bosses"] = {
                {
                    ["id"] = 655,
                    ["image"] = 630846,
                    ["name"] = "파괴자 키프틸락",
                }, -- [1]
                {
                    ["id"] = 675,
                    ["image"] = 630851,
                    ["name"] = "공습병 가도크",
                }, -- [2]
                {
                    ["id"] = 676,
                    ["image"] = 630821,
                    ["name"] = "사령관 리모크",
                }, -- [3]
                {
                    ["id"] = 649,
                    ["image"] = 630845,
                    ["name"] = "라이곤",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 246,
            ["image"] = 608215,
            ["name"] = "스칼로맨스",
            ["bosses"] = {
                {
                    ["id"] = 659,
                    ["image"] = 630835,
                    ["name"] = "조교 칠하트",
                }, -- [1]
                {
                    ["id"] = 663,
                    ["image"] = 607666,
                    ["name"] = "잔다이스 바로브",
                }, -- [2]
                {
                    ["id"] = 665,
                    ["image"] = 607755,
                    ["name"] = "들창엄니",
                }, -- [3]
                {
                    ["id"] = 666,
                    ["image"] = 630838,
                    ["name"] = "릴리안 보스",
                }, -- [4]
                {
                    ["id"] = 684,
                    ["image"] = 607582,
                    ["name"] = "암흑스승 간들링",
                }, -- [5]
            },
        }, -- [12]
        {
            ["id"] = 302,
            ["image"] = 632275,
            ["name"] = "스톰스타우트 양조장",
            ["bosses"] = {
                {
                    ["id"] = 668,
                    ["image"] = 630843,
                    ["name"] = "우끼우끼",
                }, -- [1]
                {
                    ["id"] = 669,
                    ["image"] = 630832,
                    ["name"] = "홉탈루스",
                }, -- [2]
                {
                    ["id"] = 670,
                    ["image"] = 630860,
                    ["name"] = "담기지 않는 옌주",
                }, -- [3]
            },
        }, -- [13]
        {
            ["id"] = 313,
            ["image"] = 632276,
            ["name"] = "옥룡사",
            ["bosses"] = {
                {
                    ["id"] = 672,
                    ["image"] = 630858,
                    ["name"] = "현명한 마리",
                }, -- [1]
                {
                    ["id"] = 664,
                    ["image"] = 630840,
                    ["name"] = "전승지기 스톤스텝",
                }, -- [2]
                {
                    ["id"] = 658,
                    ["image"] = 630839,
                    ["name"] = "리우 플레임하트",
                }, -- [3]
                {
                    ["id"] = 335,
                    ["image"] = 630848,
                    ["name"] = "의심의 샤",
                }, -- [4]
            },
        }, -- [14]
        {
            ["id"] = 312,
            ["image"] = 632274,
            ["name"] = "음영파 수도원",
            ["bosses"] = {
                {
                    ["id"] = 673,
                    ["image"] = 630831,
                    ["name"] = "구우 클라우드스트라이크",
                }, -- [1]
                {
                    ["id"] = 657,
                    ["image"] = 630841,
                    ["name"] = "사부 스노우드리프트",
                }, -- [2]
                {
                    ["id"] = 685,
                    ["image"] = 630850,
                    ["name"] = "폭력의 샤",
                }, -- [3]
                {
                    ["id"] = 686,
                    ["image"] = 630852,
                    ["name"] = "타란 주",
                }, -- [4]
            },
        }, -- [15]
    },
    ["드레노어의 전쟁군주"] = {
        {
            ["id"] = 557,
            ["image"] = 1041995,
            ["name"] = "드레노어",
            ["bosses"] = {
                {
                    ["id"] = 1291,
                    ["image"] = 1044483,
                    ["name"] = "파괴의 현신 드로브",
                }, -- [1]
                {
                    ["id"] = 1211,
                    ["image"] = 1044371,
                    ["name"] = "영생의 탈르나",
                }, -- [2]
                {
                    ["id"] = 1262,
                    ["image"] = 1044364,
                    ["name"] = "루크마르",
                }, -- [3]
                {
                    ["id"] = 1452,
                    ["image"] = 1134508,
                    ["name"] = "고위 군주 카자크",
                }, -- [4]
            },
        }, -- [1]
        {
            ["id"] = 477,
            ["image"] = 1041997,
            ["name"] = "높은망치",
            ["bosses"] = {
                {
                    ["id"] = 1128,
                    ["image"] = 1044352,
                    ["name"] = "카르가스 블레이드피스트",
                }, -- [1]
                {
                    ["id"] = 971,
                    ["image"] = 1044375,
                    ["name"] = "도살자",
                }, -- [2]
                {
                    ["id"] = 1195,
                    ["image"] = 1044372,
                    ["name"] = "텍터스",
                }, -- [3]
                {
                    ["id"] = 1196,
                    ["image"] = 1044342,
                    ["name"] = "담쟁이포자",
                }, -- [4]
                {
                    ["id"] = 1148,
                    ["image"] = 1044377,
                    ["name"] = "쌍둥이 오그론",
                }, -- [5]
                {
                    ["id"] = 1153,
                    ["image"] = 1044343,
                    ["name"] = "코라그",
                }, -- [6]
                {
                    ["id"] = 1197,
                    ["image"] = 1044349,
                    ["name"] = "높은군주 마르고크",
                }, -- [7]
            },
        }, -- [2]
        {
            ["id"] = 457,
            ["image"] = 1041993,
            ["name"] = "검은바위 용광로",
            ["bosses"] = {
                {
                    ["id"] = 1202,
                    ["image"] = 1044484,
                    ["name"] = "광물먹보",
                }, -- [1]
                {
                    ["id"] = 1155,
                    ["image"] = 1044345,
                    ["name"] = "한스가르와 프란조크",
                }, -- [2]
                {
                    ["id"] = 1122,
                    ["image"] = 1044338,
                    ["name"] = "야수군주 다르마크",
                }, -- [3]
                {
                    ["id"] = 1161,
                    ["image"] = 1044346,
                    ["name"] = "그룰",
                }, -- [4]
                {
                    ["id"] = 1123,
                    ["image"] = 1044344,
                    ["name"] = "화염칼날 카그라즈",
                }, -- [5]
                {
                    ["id"] = 1147,
                    ["image"] = 1044357,
                    ["name"] = "기관사 토가르",
                }, -- [6]
                {
                    ["id"] = 1154,
                    ["image"] = 1044374,
                    ["name"] = "격노의 가열로",
                }, -- [7]
                {
                    ["id"] = 1162,
                    ["image"] = 1044353,
                    ["name"] = "크로모그",
                }, -- [8]
                {
                    ["id"] = 1203,
                    ["image"] = 1044350,
                    ["name"] = "강철의 여전사들",
                }, -- [9]
                {
                    ["id"] = 959,
                    ["image"] = 1044378,
                    ["name"] = "블랙핸드",
                }, -- [10]
            },
        }, -- [3]
        {
            ["id"] = 669,
            ["image"] = 1135118,
            ["name"] = "지옥불 성채",
            ["bosses"] = {
                {
                    ["id"] = 1426,
                    ["image"] = 1134502,
                    ["name"] = "지옥불 공성전",
                }, -- [1]
                {
                    ["id"] = 1425,
                    ["image"] = 1134499,
                    ["name"] = "강철절단기",
                }, -- [2]
                {
                    ["id"] = 1392,
                    ["image"] = 1134504,
                    ["name"] = "코름록",
                }, -- [3]
                {
                    ["id"] = 1432,
                    ["image"] = 1134501,
                    ["name"] = "지옥불 고위 의회",
                }, -- [4]
                {
                    ["id"] = 1396,
                    ["image"] = 1134503,
                    ["name"] = "킬로그 데드아이",
                }, -- [5]
                {
                    ["id"] = 1372,
                    ["image"] = 1134500,
                    ["name"] = "고어핀드",
                }, -- [6]
                {
                    ["id"] = 1433,
                    ["image"] = 1134506,
                    ["name"] = "그림자군주 이스카르",
                }, -- [7]
                {
                    ["id"] = 1427,
                    ["image"] = 1134507,
                    ["name"] = "영원한 소크레타르",
                }, -- [8]
                {
                    ["id"] = 1391,
                    ["image"] = 1134498,
                    ["name"] = "지옥 군주 자쿠운",
                }, -- [9]
                {
                    ["id"] = 1447,
                    ["image"] = 1134510,
                    ["name"] = "줄호락",
                }, -- [10]
                {
                    ["id"] = 1394,
                    ["image"] = 1134509,
                    ["name"] = "폭군 벨하리",
                }, -- [11]
                {
                    ["id"] = 1395,
                    ["image"] = 1134505,
                    ["name"] = "만노로스",
                }, -- [12]
                {
                    ["id"] = 1438,
                    ["image"] = 1134497,
                    ["name"] = "아키몬드",
                }, -- [13]
            },
        }, -- [4]
        {
            ["id"] = 558,
            ["image"] = 1060548,
            ["name"] = "강철 선착장",
            ["bosses"] = {
                {
                    ["id"] = 1235,
                    ["image"] = 1044380,
                    ["name"] = "살점분리자 녹가르",
                }, -- [1]
                {
                    ["id"] = 1236,
                    ["image"] = 1044340,
                    ["name"] = "파멸철로 집행단",
                }, -- [2]
                {
                    ["id"] = 1237,
                    ["image"] = 1044359,
                    ["name"] = "오시르",
                }, -- [3]
                {
                    ["id"] = 1238,
                    ["image"] = 1044367,
                    ["name"] = "스컬록",
                }, -- [4]
            },
        }, -- [5]
        {
            ["id"] = 559,
            ["image"] = 1042000,
            ["name"] = "검은바위 첨탑 상층",
            ["bosses"] = {
                {
                    ["id"] = 1226,
                    ["image"] = 1044358,
                    ["name"] = "금속술사 고라샨",
                }, -- [1]
                {
                    ["id"] = 1227,
                    ["image"] = 1044354,
                    ["name"] = "카이락",
                }, -- [2]
                {
                    ["id"] = 1228,
                    ["image"] = 1044351,
                    ["name"] = "사령관 탈베크",
                }, -- [3]
                {
                    ["id"] = 1229,
                    ["image"] = 1044361,
                    ["name"] = "폭군 격노날개",
                }, -- [4]
                {
                    ["id"] = 1234,
                    ["image"] = 1044379,
                    ["name"] = "전쟁군주 잴라",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 556,
            ["image"] = 1060547,
            ["name"] = "상록숲",
            ["bosses"] = {
                {
                    ["id"] = 1214,
                    ["image"] = 1044381,
                    ["name"] = "마른껍질",
                }, -- [1]
                {
                    ["id"] = 1207,
                    ["image"] = 1053563,
                    ["name"] = "고대 수호자",
                }, -- [2]
                {
                    ["id"] = 1208,
                    ["image"] = 1044335,
                    ["name"] = "대마법사 솔",
                }, -- [3]
                {
                    ["id"] = 1209,
                    ["image"] = 1044382,
                    ["name"] = "제리타크",
                }, -- [4]
                {
                    ["id"] = 1210,
                    ["image"] = 1044383,
                    ["name"] = "얄누",
                }, -- [5]
            },
        }, -- [7]
        {
            ["id"] = 547,
            ["image"] = 1041992,
            ["name"] = "아킨둔",
            ["bosses"] = {
                {
                    ["id"] = 1185,
                    ["image"] = 1044336,
                    ["name"] = "수호자 카타르",
                }, -- [1]
                {
                    ["id"] = 1186,
                    ["image"] = 1044370,
                    ["name"] = "영혼술사 니아미",
                }, -- [2]
                {
                    ["id"] = 1216,
                    ["image"] = 1044337,
                    ["name"] = "아자켈",
                }, -- [3]
                {
                    ["id"] = 1225,
                    ["image"] = 1044373,
                    ["name"] = "테론고르",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 537,
            ["image"] = 1041998,
            ["name"] = "어둠달 지하묘지",
            ["bosses"] = {
                {
                    ["id"] = 1139,
                    ["image"] = 1044366,
                    ["name"] = "새다나 블러드퓨리",
                }, -- [1]
                {
                    ["id"] = 1168,
                    ["image"] = 1053564,
                    ["name"] = "날리쉬",
                }, -- [2]
                {
                    ["id"] = 1140,
                    ["image"] = 1044341,
                    ["name"] = "해골아귀",
                }, -- [3]
                {
                    ["id"] = 1160,
                    ["image"] = 1044356,
                    ["name"] = "넬쥴",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 536,
            ["image"] = 1041996,
            ["name"] = "파멸철로 정비소",
            ["bosses"] = {
                {
                    ["id"] = 1138,
                    ["image"] = 1044360,
                    ["name"] = "로켓스파크와 보르카",
                }, -- [1]
                {
                    ["id"] = 1163,
                    ["image"] = 1044339,
                    ["name"] = "니트로그 썬더타워",
                }, -- [2]
                {
                    ["id"] = 1133,
                    ["image"] = 1044376,
                    ["name"] = "하늘군주 토브라",
                }, -- [3]
            },
        }, -- [10]
        {
            ["id"] = 385,
            ["image"] = 1041994,
            ["name"] = "피망치 잿가루 광산",
            ["bosses"] = {
                {
                    ["id"] = 893,
                    ["image"] = 1044355,
                    ["name"] = "용암주먹",
                }, -- [1]
                {
                    ["id"] = 888,
                    ["image"] = 1044368,
                    ["name"] = "노예감시자 크러쉬토",
                }, -- [2]
                {
                    ["id"] = 887,
                    ["image"] = 1044363,
                    ["name"] = "롤탈",
                }, -- [3]
                {
                    ["id"] = 889,
                    ["image"] = 1044347,
                    ["name"] = "구그로크",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 476,
            ["image"] = 1041999,
            ["name"] = "하늘탑",
            ["bosses"] = {
                {
                    ["id"] = 965,
                    ["image"] = 1044362,
                    ["name"] = "란지트",
                }, -- [1]
                {
                    ["id"] = 966,
                    ["image"] = 1044334,
                    ["name"] = "아라크나스",
                }, -- [2]
                {
                    ["id"] = 967,
                    ["image"] = 1044365,
                    ["name"] = "루크란",
                }, -- [3]
                {
                    ["id"] = 968,
                    ["image"] = 1044348,
                    ["name"] = "대현자 비릭스",
                }, -- [4]
            },
        }, -- [12]
    },
    ["리치 왕의 분노"] = {
        {
            ["id"] = 753,
            ["image"] = 1396596,
            ["name"] = "아카본 석실",
            ["bosses"] = {
                {
                    ["id"] = 1597,
                    ["image"] = 1385715,
                    ["name"] = "바위 감시자 아카본",
                }, -- [1]
                {
                    ["id"] = 1598,
                    ["image"] = 1385727,
                    ["name"] = "폭풍 감시자 에말론",
                }, -- [2]
                {
                    ["id"] = 1599,
                    ["image"] = 1385748,
                    ["name"] = "화염 감시자 코랄론",
                }, -- [3]
                {
                    ["id"] = 1600,
                    ["image"] = 1385767,
                    ["name"] = "얼음 감시자 토라본",
                }, -- [4]
            },
        }, -- [1]
        {
            ["id"] = 754,
            ["image"] = 1396587,
            ["name"] = "낙스라마스",
            ["bosses"] = {
                {
                    ["id"] = 1601,
                    ["image"] = 1378964,
                    ["name"] = "아눕레칸",
                }, -- [1]
                {
                    ["id"] = 1602,
                    ["image"] = 1378980,
                    ["name"] = "귀부인 팰리나",
                }, -- [2]
                {
                    ["id"] = 1603,
                    ["image"] = 1378994,
                    ["name"] = "맥스나",
                }, -- [3]
                {
                    ["id"] = 1604,
                    ["image"] = 1379004,
                    ["name"] = "역병술사 노스",
                }, -- [4]
                {
                    ["id"] = 1605,
                    ["image"] = 1378984,
                    ["name"] = "부정의 헤이건",
                }, -- [5]
                {
                    ["id"] = 1606,
                    ["image"] = 1378991,
                    ["name"] = "로데브",
                }, -- [6]
                {
                    ["id"] = 1607,
                    ["image"] = 1378988,
                    ["name"] = "훈련교관 라주비어스",
                }, -- [7]
                {
                    ["id"] = 1608,
                    ["image"] = 1378979,
                    ["name"] = "영혼 착취자 고딕",
                }, -- [8]
                {
                    ["id"] = 1609,
                    ["image"] = 1385732,
                    ["name"] = "4인 기사단",
                }, -- [9]
                {
                    ["id"] = 1610,
                    ["image"] = 1379005,
                    ["name"] = "패치워크",
                }, -- [10]
                {
                    ["id"] = 1611,
                    ["image"] = 1378981,
                    ["name"] = "그라불루스",
                }, -- [11]
                {
                    ["id"] = 1612,
                    ["image"] = 1378977,
                    ["name"] = "글루스",
                }, -- [12]
                {
                    ["id"] = 1613,
                    ["image"] = 1379019,
                    ["name"] = "타디우스",
                }, -- [13]
                {
                    ["id"] = 1614,
                    ["image"] = 1379010,
                    ["name"] = "사피론",
                }, -- [14]
                {
                    ["id"] = 1615,
                    ["image"] = 1378989,
                    ["name"] = "켈투자드",
                }, -- [15]
            },
        }, -- [2]
        {
            ["id"] = 755,
            ["image"] = 1396588,
            ["name"] = "흑요석 성소",
            ["bosses"] = {
                {
                    ["id"] = 1616,
                    ["image"] = 1385765,
                    ["name"] = "살타리온",
                }, -- [1]
            },
        }, -- [3]
        {
            ["id"] = 756,
            ["image"] = 1396581,
            ["name"] = "영원의 눈",
            ["bosses"] = {
                {
                    ["id"] = 1617,
                    ["image"] = 1385753,
                    ["name"] = "말리고스",
                }, -- [1]
            },
        }, -- [4]
        {
            ["id"] = 759,
            ["image"] = 1396595,
            ["name"] = "울두아르",
            ["bosses"] = {
                {
                    ["id"] = 1637,
                    ["image"] = 1385731,
                    ["name"] = "거대 화염전차",
                }, -- [1]
                {
                    ["id"] = 1638,
                    ["image"] = 1385742,
                    ["name"] = "용광로 군주 이그니스",
                }, -- [2]
                {
                    ["id"] = 1639,
                    ["image"] = 1385763,
                    ["name"] = "칼날비늘",
                }, -- [3]
                {
                    ["id"] = 1640,
                    ["image"] = 1385773,
                    ["name"] = "XT-002 해체자",
                }, -- [4]
                {
                    ["id"] = 1641,
                    ["image"] = 1390439,
                    ["name"] = "무쇠 평의회",
                }, -- [5]
                {
                    ["id"] = 1642,
                    ["image"] = 1385747,
                    ["name"] = "콜로간",
                }, -- [6]
                {
                    ["id"] = 1643,
                    ["image"] = 1385717,
                    ["name"] = "아우리아야",
                }, -- [7]
                {
                    ["id"] = 1644,
                    ["image"] = 1385740,
                    ["name"] = "호디르",
                }, -- [8]
                {
                    ["id"] = 1645,
                    ["image"] = 1385770,
                    ["name"] = "토림",
                }, -- [9]
                {
                    ["id"] = 1646,
                    ["image"] = 1385733,
                    ["name"] = "프레이야",
                }, -- [10]
                {
                    ["id"] = 1647,
                    ["image"] = 1385754,
                    ["name"] = "미미론",
                }, -- [11]
                {
                    ["id"] = 1648,
                    ["image"] = 1385735,
                    ["name"] = "장군 베작스",
                }, -- [12]
                {
                    ["id"] = 1649,
                    ["image"] = 1385774,
                    ["name"] = "요그사론",
                }, -- [13]
                {
                    ["id"] = 1650,
                    ["image"] = 1385713,
                    ["name"] = "관찰자 알갈론",
                }, -- [14]
            },
        }, -- [5]
        {
            ["id"] = 757,
            ["image"] = 1396594,
            ["name"] = "십자군의 시험장",
            ["bosses"] = {
                {
                    ["id"] = 1618,
                    ["image"] = 1390440,
                    ["name"] = "노스렌드 야수",
                }, -- [1]
                {
                    ["id"] = 1619,
                    ["image"] = 1385752,
                    ["name"] = "군주 자락서스",
                }, -- [2]
                {
                    ["id"] = Cell.vars.playerFaction == "Horde" and 1620 or 1621,
                    ["image"] = Cell.vars.playerFaction == "Horde" and 1390442 or 1390441,
                    ["name"] = Cell.vars.playerFaction == "Horde" and "얼라이언스의 용사" or "호드의 용사",
                }, -- [3]
                {
                    ["id"] = 1622,
                    ["image"] = 1390443,
                    ["name"] = "발키르 쌍둥이",
                }, -- [4]
                {
                    ["id"] = 1623,
                    ["image"] = 607542,
                    ["name"] = "아눕아락",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 760,
            ["image"] = 1396589,
            ["name"] = "오닉시아의 둥지",
            ["bosses"] = {
                {
                    ["id"] = 1651,
                    ["image"] = 1379025,
                    ["name"] = "오닉시아",
                }, -- [1]
            },
        }, -- [7]
        {
            ["id"] = 758,
            ["image"] = 1396583,
            ["name"] = "얼음왕관 성채",
            ["bosses"] = {
                {
                    ["id"] = 1624,
                    ["image"] = 1378992,
                    ["name"] = "군주 매로우가르",
                }, -- [1]
                {
                    ["id"] = 1625,
                    ["image"] = 1378990,
                    ["name"] = "여교주 데스위스퍼",
                }, -- [2]
                {
                    ["id"] = 1627,
                    ["image"] = 1385736,
                    ["name"] = "얼음왕관 비행포격선 전투",
                }, -- [3]
                {
                    ["id"] = 1628,
                    ["image"] = 1378970,
                    ["name"] = "죽음의 인도자 사울팽",
                }, -- [4]
                {
                    ["id"] = 1629,
                    ["image"] = 1378972,
                    ["name"] = "구린속",
                }, -- [5]
                {
                    ["id"] = 1630,
                    ["image"] = 1379009,
                    ["name"] = "썩은얼굴",
                }, -- [6]
                {
                    ["id"] = 1631,
                    ["image"] = 1379007,
                    ["name"] = "교수 퓨트리사이드",
                }, -- [7]
                {
                    ["id"] = 1632,
                    ["image"] = 1385721,
                    ["name"] = "피의 공작 의회",
                }, -- [8]
                {
                    ["id"] = 1633,
                    ["image"] = 1378967,
                    ["name"] = "피의 여왕 라나텔",
                }, -- [9]
                {
                    ["id"] = 1634,
                    ["image"] = 1379023,
                    ["name"] = "발리스리아 드림워커",
                }, -- [10]
                {
                    ["id"] = 1635,
                    ["image"] = 1379014,
                    ["name"] = "신드라고사",
                }, -- [11]
                {
                    ["id"] = 1636,
                    ["image"] = 607688,
                    ["name"] = "리치 왕",
                }, -- [12]
            },
        }, -- [8]
        {
            ["id"] = 761,
            ["image"] = 1396590,
            ["name"] = "루비 성소",
            ["bosses"] = {
                {
                    ["id"] = 1652,
                    ["image"] = 1385738,
                    ["name"] = "할리온",
                }, -- [1]
            },
        }, -- [9]
        {
            ["id"] = 274,
            ["image"] = 608203,
            ["name"] = "군드락",
            ["bosses"] = {
                {
                    ["id"] = 592,
                    ["image"] = 607776,
                    ["name"] = "슬라드란",
                }, -- [1]
                {
                    ["id"] = 593,
                    ["image"] = 607589,
                    ["name"] = "드라카리 거대골렘",
                }, -- [2]
                {
                    ["id"] = 594,
                    ["image"] = 607716,
                    ["name"] = "무라비",
                }, -- [3]
                {
                    ["id"] = 595,
                    ["image"] = 607592,
                    ["name"] = "사나운 엑크",
                }, -- [4]
                {
                    ["id"] = 596,
                    ["image"] = 607605,
                    ["name"] = "갈다라",
                }, -- [5]
            },
        }, -- [10]
        {
            ["id"] = 277,
            ["image"] = 608206,
            ["name"] = "돌의 전당",
            ["bosses"] = {
                {
                    ["id"] = 604,
                    ["image"] = 607679,
                    ["name"] = "크리스탈루스",
                }, -- [1]
                {
                    ["id"] = 605,
                    ["image"] = 607706,
                    ["name"] = "고뇌의 마녀",
                }, -- [2]
                {
                    ["id"] = 606,
                    ["image"] = 607797,
                    ["name"] = "시대의 심판장",
                }, -- [3]
                {
                    ["id"] = 607,
                    ["image"] = 607772,
                    ["name"] = "무쇠구체자 쇼니르",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 273,
            ["image"] = 608201,
            ["name"] = "드락타론 성채",
            ["bosses"] = {
                {
                    ["id"] = 588,
                    ["image"] = 607798,
                    ["name"] = "송곳아귀",
                }, -- [1]
                {
                    ["id"] = 589,
                    ["image"] = 607727,
                    ["name"] = "소환사 노보스",
                }, -- [2]
                {
                    ["id"] = 590,
                    ["image"] = 607672,
                    ["name"] = "랩터왕 서슬발톱",
                }, -- [3]
                {
                    ["id"] = 591,
                    ["image"] = 607790,
                    ["name"] = "예언자 타론자",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 282,
            ["image"] = 608222,
            ["name"] = "마력의 눈",
            ["bosses"] = {
                {
                    ["id"] = 622,
                    ["image"] = 607590,
                    ["name"] = "심문관 드라코스",
                }, -- [1]
                {
                    ["id"] = 623,
                    ["image"] = 607802,
                    ["name"] = "바로스 클라우드스트라이더",
                }, -- [2]
                {
                    ["id"] = 624,
                    ["image"] = 607702,
                    ["name"] = "마법사 군주 우롬",
                }, -- [3]
                {
                    ["id"] = 625,
                    ["image"] = 607687,
                    ["name"] = "지맥 수호자 에레고스",
                }, -- [4]
            },
        }, -- [13]
        {
            ["id"] = 281,
            ["image"] = 608221,
            ["name"] = "마력의 탑",
            ["bosses"] = {
                {
                    ["id"] = Cell.vars.playerFaction == "Horde" and 617 or 833,
                    ["image"] = Cell.vars.playerFaction == "Horde" and 607571 or 607568,
                    ["name"] = Cell.vars.playerFaction == "Horde" and "사령관 스타우트비어드" or "사령관 콜루르그",
                }, -- [1]
                {
                    ["id"] = 618,
                    ["image"] = 607623,
                    ["name"] = "대학자 텔레스트라",
                }, -- [2]
                {
                    ["id"] = 619,
                    ["image"] = 607540,
                    ["name"] = "아노말루스",
                }, -- [3]
                {
                    ["id"] = 620,
                    ["image"] = 607735,
                    ["name"] = "정원사 오르모로크",
                }, -- [4]
                {
                    ["id"] = 621,
                    ["image"] = 607671,
                    ["name"] = "케리스트라자",
                }, -- [5]
            },
        }, -- [14]
        {
            ["id"] = 275,
            ["image"] = 608204,
            ["name"] = "번개의 전당",
            ["bosses"] = {
                {
                    ["id"] = 597,
                    ["image"] = 607611,
                    ["name"] = "장군 비야른그림",
                }, -- [1]
                {
                    ["id"] = 598,
                    ["image"] = 607809,
                    ["name"] = "볼칸",
                }, -- [2]
                {
                    ["id"] = 599,
                    ["image"] = 607663,
                    ["name"] = "아이오나",
                }, -- [3]
                {
                    ["id"] = 600,
                    ["image"] = 607690,
                    ["name"] = "로켄",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 283,
            ["image"] = 608228,
            ["name"] = "보랏빛 요새",
            ["bosses"] = {
                {
                    ["id"] = 626,
                    ["image"] = 607597,
                    ["name"] = "에레켐",
                }, -- [1]
                {
                    ["id"] = 627,
                    ["image"] = 607717,
                    ["name"] = "모라그",
                }, -- [2]
                {
                    ["id"] = 628,
                    ["image"] = 607654,
                    ["name"] = "이코론",
                }, -- [3]
                {
                    ["id"] = 629,
                    ["image"] = 607821,
                    ["name"] = "제보즈",
                }, -- [4]
                {
                    ["id"] = 630,
                    ["image"] = 607685,
                    ["name"] = "라반토르",
                }, -- [5]
                {
                    ["id"] = 631,
                    ["image"] = 607825,
                    ["name"] = "파멸자 주라마트",
                }, -- [6]
                {
                    ["id"] = 632,
                    ["image"] = 607573,
                    ["name"] = "시아니고사",
                }, -- [7]
            },
        }, -- [16]
        {
            ["id"] = 278,
            ["image"] = 608210,
            ["name"] = "사론의 구덩이",
            ["bosses"] = {
                {
                    ["id"] = 608,
                    ["image"] = 607603,
                    ["name"] = "제련장인 가프로스트",
                }, -- [1]
                {
                    ["id"] = 609,
                    ["image"] = 607677,
                    ["name"] = "이크와 크리크",
                }, -- [2]
                {
                    ["id"] = 610,
                    ["image"] = 607765,
                    ["name"] = "스컬지군주 티라누스",
                }, -- [3]
            },
        }, -- [17]
        {
            ["id"] = 272,
            ["image"] = 608194,
            ["name"] = "아졸네룹",
            ["bosses"] = {
                {
                    ["id"] = 585,
                    ["image"] = 607678,
                    ["name"] = "문지기 크릭시르",
                }, -- [1]
                {
                    ["id"] = 586,
                    ["image"] = 607633,
                    ["name"] = "하드로녹스",
                }, -- [2]
                {
                    ["id"] = 587,
                    ["image"] = 607542,
                    ["name"] = "아눕아락",
                }, -- [3]
            },
        }, -- [18]
        {
            ["id"] = 271,
            ["image"] = 608192,
            ["name"] = "안카헤트: 고대 왕국",
            ["bosses"] = {
                {
                    ["id"] = 580,
                    ["image"] = 607593,
                    ["name"] = "장로 나독스",
                }, -- [1]
                {
                    ["id"] = 581,
                    ["image"] = 607744,
                    ["name"] = "공작 탈다람",
                }, -- [2]
                {
                    ["id"] = 582,
                    ["image"] = 607667,
                    ["name"] = "어둠추적자 제도가",
                }, -- [3]
                {
                    ["id"] = 583,
                    ["image"] = 607534,
                    ["name"] = "아마니타르",
                }, -- [4]
                {
                    ["id"] = 584,
                    ["image"] = 607639,
                    ["name"] = "사자 볼라즈",
                }, -- [5]
            },
        }, -- [19]
        {
            ["id"] = 280,
            ["image"] = 608220,
            ["name"] = "영혼의 제련소",
            ["bosses"] = {
                {
                    ["id"] = 615,
                    ["image"] = 607559,
                    ["name"] = "브론잠",
                }, -- [1]
                {
                    ["id"] = 616,
                    ["image"] = 607585,
                    ["name"] = "영혼의 포식자",
                }, -- [2]
            },
        }, -- [20]
        {
            ["id"] = 279,
            ["image"] = 608219,
            ["name"] = "옛 스트라솔름",
            ["bosses"] = {
                {
                    ["id"] = 611,
                    ["image"] = 607711,
                    ["name"] = "살덩이갈고리",
                }, -- [1]
                {
                    ["id"] = 612,
                    ["image"] = 607763,
                    ["name"] = "살덩이창조자 살람",
                }, -- [2]
                {
                    ["id"] = 613,
                    ["image"] = 607567,
                    ["name"] = "시간의 군주 에포크",
                }, -- [3]
                {
                    ["id"] = 614,
                    ["image"] = 607708,
                    ["name"] = "말가니스",
                }, -- [4]
            },
        }, -- [21]
        {
            ["id"] = 284,
            ["image"] = 608224,
            ["name"] = "용사의 시험장",
            ["bosses"] = {
                {
                    ["id"] = 834,
                    ["image"] = 607621,
                    ["name"] = "최고 용사",
                }, -- [1]
                {
                    ["id"] = 635,
                    ["image"] = 607591,
                    ["name"] = "성기사 에드릭",
                }, -- [2]
                {
                    ["id"] = 636,
                    ["image"] = 607547,
                    ["name"] = "은빛 고해사제 페일트레스",
                }, -- [3]
                {
                    ["id"] = 637,
                    ["image"] = 607787,
                    ["name"] = "흑기사",
                }, -- [4]
            },
        }, -- [22]
        {
            ["id"] = 285,
            ["image"] = 608226,
            ["name"] = "우트가드 성채",
            ["bosses"] = {
                {
                    ["id"] = 638,
                    ["image"] = 607743,
                    ["name"] = "공작 켈레세스",
                }, -- [1]
                {
                    ["id"] = 639,
                    ["image"] = 607774,
                    ["name"] = "스카발드와 달론",
                }, -- [2]
                {
                    ["id"] = 640,
                    ["image"] = 607659,
                    ["name"] = "약탈자 잉그바르",
                }, -- [3]
            },
        }, -- [23]
        {
            ["id"] = 286,
            ["image"] = 608227,
            ["name"] = "우트가드 첨탑",
            ["bosses"] = {
                {
                    ["id"] = 641,
                    ["image"] = 607778,
                    ["name"] = "스발라 소로우그레이브",
                }, -- [1]
                {
                    ["id"] = 642,
                    ["image"] = 607620,
                    ["name"] = "고르톡 페일후프",
                }, -- [2]
                {
                    ["id"] = 643,
                    ["image"] = 607773,
                    ["name"] = "학살자 스카디",
                }, -- [3]
                {
                    ["id"] = 644,
                    ["image"] = 607674,
                    ["name"] = "왕 이미론",
                }, -- [4]
            },
        }, -- [24]
        {
            ["id"] = 276,
            ["image"] = 608205,
            ["name"] = "투영의 전당",
            ["bosses"] = {
                {
                    ["id"] = 601,
                    ["image"] = 607601,
                    ["name"] = "팔릭",
                }, -- [1]
                {
                    ["id"] = 602,
                    ["image"] = 607710,
                    ["name"] = "마윈",
                }, -- [2]
                {
                    ["id"] = 603,
                    ["image"] = 607688,
                    ["name"] = "아서스에게서 도망치기",
                }, -- [3]
            },
        }, -- [25]
    },
    ["격전의 아제로스"] = {
        {
            ["id"] = 1028,
            ["image"] = 2178279,
            ["name"] = "아제로스",
            ["bosses"] = {
                {
                    ["id"] = 2378,
                    ["image"] = 3284400,
                    ["name"] = "위대한 여제 셰크자라",
                }, -- [1]
                {
                    ["id"] = 2381,
                    ["image"] = 3284401,
                    ["name"] = "대지파괴자 부클라즈",
                }, -- [2]
                {
                    ["id"] = 2363,
                    ["image"] = 3012063,
                    ["name"] = "웨케마라",
                }, -- [3]
                {
                    ["id"] = 2362,
                    ["image"] = 3012061,
                    ["name"] = "영혼술사 울매스",
                }, -- [4]
                {
                    ["id"] = 2329,
                    ["image"] = 2497782,
                    ["name"] = "숲군주 이부스",
                }, -- [5]
                {
                    ["id"] = 2212,
                    ["image"] = 2176752,
                    ["name"] = "사자의 포효",
                }, -- [6]
                {
                    ["id"] = 2139,
                    ["image"] = 2176755,
                    ["name"] = "티제인",
                }, -- [7]
                {
                    ["id"] = 2141,
                    ["image"] = 2176734,
                    ["name"] = "지아라크",
                }, -- [8]
                {
                    ["id"] = 2197,
                    ["image"] = 2176731,
                    ["name"] = "우박 피조물",
                }, -- [9]
                {
                    ["id"] = 2198,
                    ["image"] = 2176760,
                    ["name"] = "전쟁인도자 예나즈",
                }, -- [10]
                {
                    ["id"] = 2199,
                    ["image"] = 2176716,
                    ["name"] = "날개 달린 태풍 아주레토스",
                }, -- [11]
                {
                    ["id"] = 2210,
                    ["image"] = 2176723,
                    ["name"] = "모래먹보 크롤로크",
                }, -- [12]
            },
        }, -- [1]
        {
            ["id"] = 1031,
            ["image"] = 2178277,
            ["name"] = "울디르",
            ["bosses"] = {
                {
                    ["id"] = 2168,
                    ["image"] = 2176749,
                    ["name"] = "탈록",
                }, -- [1]
                {
                    ["id"] = 2167,
                    ["image"] = 2176741,
                    ["name"] = "마더",
                }, -- [2]
                {
                    ["id"] = 2146,
                    ["image"] = 2176725,
                    ["name"] = "악취나는 포식자",
                }, -- [3]
                {
                    ["id"] = 2169,
                    ["image"] = 2176761,
                    ["name"] = "느조스의 전령 제크보즈",
                }, -- [4]
                {
                    ["id"] = 2166,
                    ["image"] = 2176757,
                    ["name"] = "벡티스",
                }, -- [5]
                {
                    ["id"] = 2195,
                    ["image"] = 2176762,
                    ["name"] = "부활한 줄",
                }, -- [6]
                {
                    ["id"] = 2194,
                    ["image"] = 2176742,
                    ["name"] = "종결자 미스락스",
                }, -- [7]
                {
                    ["id"] = 2147,
                    ["image"] = 2176728,
                    ["name"] = "그훈",
                }, -- [8]
            },
        }, -- [2]
        {
            ["id"] = 1176,
            ["image"] = 2482729,
            ["name"] = "다자알로 전투",
            ["bosses"] = {
                {
                    ["id"] = 2333,
                    ["image"] = 2497778,
                    ["name"] = "빛의 용사",
                }, -- [1]
                {
                    ["id"] = 2325,
                    ["image"] = 2497783,
                    ["name"] = "밀림의 군주 그롱",
                }, -- [2]
                {
                    ["id"] = 2341,
                    ["image"] = 2529383,
                    ["name"] = "비취불길의 대가",
                }, -- [3]
                {
                    ["id"] = 2342,
                    ["image"] = 2497790,
                    ["name"] = "금은보화",
                }, -- [4]
                {
                    ["id"] = 2330,
                    ["image"] = 2497779,
                    ["name"] = "선택받은 자의 비밀의회",
                }, -- [5]
                {
                    ["id"] = 2335,
                    ["image"] = 2497784,
                    ["name"] = "왕 라스타칸",
                }, -- [6]
                {
                    ["id"] = 2334,
                    ["image"] = 2497788,
                    ["name"] = "땜장이왕 멕카토크",
                }, -- [7]
                {
                    ["id"] = 2337,
                    ["image"] = 2497786,
                    ["name"] = "폭풍장벽 봉쇄군",
                }, -- [8]
                {
                    ["id"] = 2343,
                    ["image"] = 2497785,
                    ["name"] = "여군주 제이나 프라우드무어",
                }, -- [9]
            },
        }, -- [3]
        {
            ["id"] = 1177,
            ["image"] = 2498193,
            ["name"] = "폭풍의 용광로",
            ["bosses"] = {
                {
                    ["id"] = 2328,
                    ["image"] = 2497795,
                    ["name"] = "잠들지 못하는 비밀결사단",
                }, -- [1]
                {
                    ["id"] = 2332,
                    ["image"] = 2497794,
                    ["name"] = "공허의 전령 우우나트",
                }, -- [2]
            },
        }, -- [4]
        {
            ["id"] = 1179,
            ["image"] = 3025320,
            ["name"] = "영원한 궁전",
            ["bosses"] = {
                {
                    ["id"] = 2352,
                    ["image"] = 3012047,
                    ["name"] = "심연 사령관 사이바라",
                }, -- [1]
                {
                    ["id"] = 2347,
                    ["image"] = 3012062,
                    ["name"] = "검은바다 거수",
                }, -- [2]
                {
                    ["id"] = 2353,
                    ["image"] = 3012058,
                    ["name"] = "아즈샤라의 광채",
                }, -- [3]
                {
                    ["id"] = 2354,
                    ["image"] = 3012055,
                    ["name"] = "여군주 애쉬베인",
                }, -- [4]
                {
                    ["id"] = 2351,
                    ["image"] = 3012054,
                    ["name"] = "올고조아",
                }, -- [5]
                {
                    ["id"] = 2359,
                    ["image"] = 3012057,
                    ["name"] = "여왕의 궁정",
                }, -- [6]
                {
                    ["id"] = 2349,
                    ["image"] = 3012064,
                    ["name"] = "나이알로사의 전령 자쿨",
                }, -- [7]
                {
                    ["id"] = 2361,
                    ["image"] = 3012056,
                    ["name"] = "여왕 아즈샤라",
                }, -- [8]
            },
        }, -- [5]
        {
            ["id"] = 1180,
            ["image"] = 3221463,
            ["name"] = "깨어난 도시 나이알로사",
            ["bosses"] = {
                {
                    ["id"] = 2368,
                    ["image"] = 3256385,
                    ["name"] = "검은 황제 래시온",
                }, -- [1]
                {
                    ["id"] = 2365,
                    ["image"] = 3256380,
                    ["name"] = "마우트",
                }, -- [2]
                {
                    ["id"] = 2369,
                    ["image"] = 3256384,
                    ["name"] = "예언자 스키트라",
                }, -- [3]
                {
                    ["id"] = 2377,
                    ["image"] = 3256386,
                    ["name"] = "암흑 심문관 자네쉬",
                }, -- [4]
                {
                    ["id"] = 2372,
                    ["image"] = 3256378,
                    ["name"] = "군체의식",
                }, -- [5]
                {
                    ["id"] = 2367,
                    ["image"] = 3256383,
                    ["name"] = "만족할 줄 모르는 샤드하르",
                }, -- [6]
                {
                    ["id"] = 2373,
                    ["image"] = 3256377,
                    ["name"] = "드레스타가스",
                }, -- [7]
                {
                    ["id"] = 2374,
                    ["image"] = 3256379,
                    ["name"] = "다시 태어난 타락 일기노스",
                }, -- [8]
                {
                    ["id"] = 2370,
                    ["image"] = 3257677,
                    ["name"] = "벡시오나",
                }, -- [9]
                {
                    ["id"] = 2364,
                    ["image"] = 3256382,
                    ["name"] = "약탈당한 자 라덴",
                }, -- [10]
                {
                    ["id"] = 2366,
                    ["image"] = 3256376,
                    ["name"] = "느조스의 껍질",
                }, -- [11]
                {
                    ["id"] = 2375,
                    ["image"] = 3256381,
                    ["name"] = "타락자 느조스",
                }, -- [12]
            },
        }, -- [6]
        {
            ["id"] = 1023,
            ["image"] = 2178272,
            ["name"] = "보랄러스 공성전",
            ["bosses"] = {
                {
                    ["id"] = 2133,
                    ["image"] = 2176746,
                    ["name"] = "하사관 베인브릿지",
                }, -- [1]
                {
                    ["id"] = 2173,
                    ["image"] = 2176722,
                    ["name"] = "공포의 선장 록우드",
                }, -- [2]
                {
                    ["id"] = 2134,
                    ["image"] = 2176730,
                    ["name"] = "하달 다크패덤",
                }, -- [3]
                {
                    ["id"] = 2140,
                    ["image"] = 2176758,
                    ["name"] = "비크고스",
                }, -- [4]
            },
        }, -- [7]
        {
            ["id"] = 1030,
            ["image"] = 2178273,
            ["name"] = "세스랄리스 사원",
            ["bosses"] = {
                {
                    ["id"] = 2142,
                    ["image"] = 2176710,
                    ["name"] = "애더리스와 아스픽스",
                }, -- [1]
                {
                    ["id"] = 2143,
                    ["image"] = 2176739,
                    ["name"] = "메레크타",
                }, -- [2]
                {
                    ["id"] = 2144,
                    ["image"] = 2176727,
                    ["name"] = "갈바즈트",
                }, -- [3]
                {
                    ["id"] = 2145,
                    ["image"] = 2176713,
                    ["name"] = "세스랄리스의 화신",
                }, -- [4]
            },
        }, -- [8]
        {
            ["id"] = 1022,
            ["image"] = 2178275,
            ["name"] = "썩은굴",
            ["bosses"] = {
                {
                    ["id"] = 2157,
                    ["image"] = 2176724,
                    ["name"] = "장로 리악사",
                }, -- [1]
                {
                    ["id"] = 2131,
                    ["image"] = 2176719,
                    ["name"] = "감염된 돌쩌귀",
                }, -- [2]
                {
                    ["id"] = 2130,
                    ["image"] = 2176748,
                    ["name"] = "포자소환사 잔차",
                }, -- [3]
                {
                    ["id"] = 2158,
                    ["image"] = 2176756,
                    ["name"] = "풀려난 흉물",
                }, -- [4]
            },
        }, -- [9]
        {
            ["id"] = 968,
            ["image"] = 1778892,
            ["name"] = "아탈다자르",
            ["bosses"] = {
                {
                    ["id"] = 2082,
                    ["image"] = 1778348,
                    ["name"] = "여사제 알룬자",
                }, -- [1]
                {
                    ["id"] = 2036,
                    ["image"] = 1778352,
                    ["name"] = "볼카알",
                }, -- [2]
                {
                    ["id"] = 2083,
                    ["image"] = 1778349,
                    ["name"] = "레잔",
                }, -- [3]
                {
                    ["id"] = 2030,
                    ["image"] = 1778353,
                    ["name"] = "야즈마",
                }, -- [4]
            },
        }, -- [10]
        {
            ["id"] = 1012,
            ["image"] = 2178274,
            ["name"] = "왕노다지 광산!!",
            ["bosses"] = {
                {
                    ["id"] = 2109,
                    ["image"] = 2176718,
                    ["name"] = "동전 투입식 군중 난타기",
                }, -- [1]
                {
                    ["id"] = 2114,
                    ["image"] = 2176714,
                    ["name"] = "아제로크",
                }, -- [2]
                {
                    ["id"] = 2115,
                    ["image"] = 2176745,
                    ["name"] = "릭사 플럭스플레임",
                }, -- [3]
                {
                    ["id"] = 2116,
                    ["image"] = 2176740,
                    ["name"] = "모굴 라즈덩크",
                }, -- [4]
            },
        }, -- [11]
        {
            ["id"] = 1041,
            ["image"] = 2178269,
            ["name"] = "왕들의 안식처",
            ["bosses"] = {
                {
                    ["id"] = 2165,
                    ["image"] = 2176751,
                    ["name"] = "황금 날뱀",
                }, -- [1]
                {
                    ["id"] = 2171,
                    ["image"] = 2176738,
                    ["name"] = "장의사 음침바",
                }, -- [2]
                {
                    ["id"] = 2170,
                    ["image"] = 2176750,
                    ["name"] = "부족 의회",
                }, -- [3]
                {
                    ["id"] = 2172,
                    ["image"] = 2176720,
                    ["name"] = "초대 왕 다자르",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 1021,
            ["image"] = 2178278,
            ["name"] = "웨이크레스트 저택",
            ["bosses"] = {
                {
                    ["id"] = 2125,
                    ["image"] = 2176732,
                    ["name"] = "심장파멸 3인조",
                }, -- [1]
                {
                    ["id"] = 2126,
                    ["image"] = 2176747,
                    ["name"] = "영혼결속 거한",
                }, -- [2]
                {
                    ["id"] = 2127,
                    ["image"] = 2176744,
                    ["name"] = "식탐귀 라알",
                }, -- [3]
                {
                    ["id"] = 2128,
                    ["image"] = 2176736,
                    ["name"] = "웨이크레스트 부부",
                }, -- [4]
                {
                    ["id"] = 2129,
                    ["image"] = 2176729,
                    ["name"] = "고라크 툴",
                }, -- [5]
            },
        }, -- [13]
        {
            ["id"] = 1001,
            ["image"] = 1778893,
            ["name"] = "자유지대",
            ["bosses"] = {
                {
                    ["id"] = 2102,
                    ["image"] = 1778351,
                    ["name"] = "하늘선장 크라그",
                }, -- [1]
                {
                    ["id"] = 2093,
                    ["image"] = 1778346,
                    ["name"] = "선장의 의회",
                }, -- [2]
                {
                    ["id"] = 2094,
                    ["image"] = 1778350,
                    ["name"] = "무법의 링",
                }, -- [3]
                {
                    ["id"] = 2095,
                    ["image"] = 1778347,
                    ["name"] = "할란 스위트",
                }, -- [4]
            },
        }, -- [14]
        {
            ["id"] = 1178,
            ["image"] = 3025325,
            ["name"] = "작전명: 메카곤",
            ["bosses"] = {
                {
                    ["id"] = 2357,
                    ["image"] = 3012050,
                    ["name"] = "왕 고바막",
                }, -- [1]
                {
                    ["id"] = 2358,
                    ["image"] = 3012048,
                    ["name"] = "진창오물",
                }, -- [2]
                {
                    ["id"] = 2360,
                    ["image"] = 3012059,
                    ["name"] = "트릭시 & 네노",
                }, -- [3]
                {
                    ["id"] = 2355,
                    ["image"] = 3012049,
                    ["name"] = "HK-8 공중 압박 유닛",
                }, -- [4]
                {
                    ["id"] = 2336,
                    ["image"] = 3012060,
                    ["name"] = "통통 격투",
                }, -- [5]
                {
                    ["id"] = 2339,
                    ["image"] = 3012052,
                    ["name"] = "쿠.조.",
                }, -- [6]
                {
                    ["id"] = 2348,
                    ["image"] = 3012053,
                    ["name"] = "기계공의 정원",
                }, -- [7]
                {
                    ["id"] = 2331,
                    ["image"] = 3012051,
                    ["name"] = "왕 메카곤",
                }, -- [8]
            },
        }, -- [15]
        {
            ["id"] = 1002,
            ["image"] = 2178276,
            ["name"] = "톨 다고르",
            ["bosses"] = {
                {
                    ["id"] = 2097,
                    ["image"] = 2176753,
                    ["name"] = "모래 여왕",
                }, -- [1]
                {
                    ["id"] = 2098,
                    ["image"] = 2176733,
                    ["name"] = "제스 하울리스",
                }, -- [2]
                {
                    ["id"] = 2099,
                    ["image"] = 2176735,
                    ["name"] = "기사대장 발리리",
                }, -- [3]
                {
                    ["id"] = 2096,
                    ["image"] = 2176743,
                    ["name"] = "감독관 코르거스",
                }, -- [4]
            },
        }, -- [16]
        {
            ["id"] = 1036,
            ["image"] = 2178271,
            ["name"] = "폭풍의 사원",
            ["bosses"] = {
                {
                    ["id"] = 2153,
                    ["image"] = 2176712,
                    ["name"] = "아쿠시르",
                }, -- [1]
                {
                    ["id"] = 2154,
                    ["image"] = 2176754,
                    ["name"] = "파도현자 의회",
                }, -- [2]
                {
                    ["id"] = 2155,
                    ["image"] = 2176737,
                    ["name"] = "군주 스톰송",
                }, -- [3]
                {
                    ["id"] = 2156,
                    ["image"] = 2176759,
                    ["name"] = "속삭임의 볼지스",
                }, -- [4]
            },
        }, -- [17]
    },
    ["Current Season"] = {
        {
            ["id"] = 1194,
            ["image"] = 4182022,
            ["name"] = "미지의 시장 타자베쉬",
            ["bosses"] = {
                {
                    ["id"] = 2437,
                    ["image"] = 4071449,
                    ["name"] = "파수꾼 조펙스",
                }, -- [1]
                {
                    ["id"] = 2454,
                    ["image"] = 4071447,
                    ["name"] = "대사육장",
                }, -- [2]
                {
                    ["id"] = 2436,
                    ["image"] = 4071438,
                    ["name"] = "우편물실 대소동",
                }, -- [3]
                {
                    ["id"] = 2452,
                    ["image"] = 4071448,
                    ["name"] = "마이자의 오아시스",
                }, -- [4]
                {
                    ["id"] = 2451,
                    ["image"] = 4071440,
                    ["name"] = "소아즈미",
                }, -- [5]
                {
                    ["id"] = 2448,
                    ["image"] = 4071429,
                    ["name"] = "힐브란데",
                }, -- [6]
                {
                    ["id"] = 2449,
                    ["image"] = 4071446,
                    ["name"] = "시간선장 후크테일",
                }, -- [7]
                {
                    ["id"] = 2455,
                    ["image"] = 4071441,
                    ["name"] = "소레아",
                }, -- [8]
            },
        }, -- [1]
        {
            ["id"] = 860,
            ["image"] = 1537283,
            ["name"] = "다시 찾은 카라잔",
            ["bosses"] = {
                {
                    ["id"] = 1820,
                    ["image"] = 1536495,
                    ["name"] = "오페라 극장: 우끼드",
                }, -- [1]
                {
                    ["id"] = 1826,
                    ["image"] = 1536494,
                    ["name"] = "오페라 극장: 서부 몰락지대 이야기",
                }, -- [2]
                {
                    ["id"] = 1827,
                    ["image"] = 1536493,
                    ["name"] = "오페라 극장: 미녀와 짐승",
                }, -- [3]
                {
                    ["id"] = 1825,
                    ["image"] = 1378997,
                    ["name"] = "고결의 여신",
                }, -- [4]
                {
                    ["id"] = 1835,
                    ["image"] = 1536490,
                    ["name"] = "사냥꾼 어튜멘",
                }, -- [5]
                {
                    ["id"] = 1837,
                    ["image"] = 1378999,
                    ["name"] = "모로스",
                }, -- [6]
                {
                    ["id"] = 1836,
                    ["image"] = 1379020,
                    ["name"] = "전시 관리인",
                }, -- [7]
                {
                    ["id"] = 1817,
                    ["image"] = 1536496,
                    ["name"] = "메디브의 망령",
                }, -- [8]
                {
                    ["id"] = 1818,
                    ["image"] = 1536492,
                    ["name"] = "마나 포식자",
                }, -- [9]
                {
                    ["id"] = 1838,
                    ["image"] = 1536497,
                    ["name"] = "감시자 비즈아둠",
                }, -- [10]
            },
        }, -- [2]
        {
            ["id"] = 1178,
            ["image"] = 3025325,
            ["name"] = "작전명: 메카곤",
            ["bosses"] = {
                {
                    ["id"] = 2357,
                    ["image"] = 3012050,
                    ["name"] = "왕 고바막",
                }, -- [1]
                {
                    ["id"] = 2358,
                    ["image"] = 3012048,
                    ["name"] = "진창오물",
                }, -- [2]
                {
                    ["id"] = 2360,
                    ["image"] = 3012059,
                    ["name"] = "트릭시 & 네노",
                }, -- [3]
                {
                    ["id"] = 2355,
                    ["image"] = 3012049,
                    ["name"] = "HK-8 공중 압박 유닛",
                }, -- [4]
                {
                    ["id"] = 2336,
                    ["image"] = 3012060,
                    ["name"] = "통통 격투",
                }, -- [5]
                {
                    ["id"] = 2339,
                    ["image"] = 3012052,
                    ["name"] = "쿠.조.",
                }, -- [6]
                {
                    ["id"] = 2348,
                    ["image"] = 3012053,
                    ["name"] = "기계공의 정원",
                }, -- [7]
                {
                    ["id"] = 2331,
                    ["image"] = 3012051,
                    ["name"] = "왕 메카곤",
                }, -- [8]
            },
        }, -- [3]
        {
            ["id"] = 558,
            ["image"] = 1060548,
            ["name"] = "강철 선착장",
            ["bosses"] = {
                {
                    ["id"] = 1235,
                    ["image"] = 1044380,
                    ["name"] = "살점분리자 녹가르",
                }, -- [1]
                {
                    ["id"] = 1236,
                    ["image"] = 1044340,
                    ["name"] = "파멸철로 집행단",
                }, -- [2]
                {
                    ["id"] = 1237,
                    ["image"] = 1044359,
                    ["name"] = "오시르",
                }, -- [3]
                {
                    ["id"] = 1238,
                    ["image"] = 1044367,
                    ["name"] = "스컬록",
                }, -- [4]
            },
        }, -- [4]
        {
            ["id"] = 536,
            ["image"] = 1041996,
            ["name"] = "파멸철로 정비소",
            ["bosses"] = {
                {
                    ["id"] = 1138,
                    ["image"] = 1044360,
                    ["name"] = "로켓스파크와 보르카",
                }, -- [1]
                {
                    ["id"] = 1163,
                    ["image"] = 1044339,
                    ["name"] = "니트로그 썬더타워",
                }, -- [2]
                {
                    ["id"] = 1133,
                    ["image"] = 1044376,
                    ["name"] = "하늘군주 토브라",
                }, -- [3]
            },
        }, -- [5]
    },
    ["오리지널"] = {
        {
            ["id"] = 741,
            ["image"] = 1396586,
            ["name"] = "화산 심장부",
            ["bosses"] = {
                {
                    ["id"] = 1519,
                    ["image"] = 1378993,
                    ["name"] = "루시프론",
                }, -- [1]
                {
                    ["id"] = 1520,
                    ["image"] = 1378995,
                    ["name"] = "마그마다르",
                }, -- [2]
                {
                    ["id"] = 1521,
                    ["image"] = 1378976,
                    ["name"] = "게헨나스",
                }, -- [3]
                {
                    ["id"] = 1522,
                    ["image"] = 1378975,
                    ["name"] = "가르",
                }, -- [4]
                {
                    ["id"] = 1523,
                    ["image"] = 1379013,
                    ["name"] = "샤즈라",
                }, -- [5]
                {
                    ["id"] = 1524,
                    ["image"] = 1378966,
                    ["name"] = "남작 게돈",
                }, -- [6]
                {
                    ["id"] = 1525,
                    ["image"] = 1379015,
                    ["name"] = "설퍼론 선구자",
                }, -- [7]
                {
                    ["id"] = 1526,
                    ["image"] = 1378978,
                    ["name"] = "초열의 골레마그",
                }, -- [8]
                {
                    ["id"] = 1527,
                    ["image"] = 1378998,
                    ["name"] = "청지기 이그젝큐투스",
                }, -- [9]
                {
                    ["id"] = 1528,
                    ["image"] = 522261,
                    ["name"] = "라그나로스",
                }, -- [10]
            },
        }, -- [1]
        {
            ["id"] = 742,
            ["image"] = 1396580,
            ["name"] = "검은날개 둥지",
            ["bosses"] = {
                {
                    ["id"] = 1529,
                    ["image"] = 1379008,
                    ["name"] = "폭군 서슬송곳니",
                }, -- [1]
                {
                    ["id"] = 1530,
                    ["image"] = 1379022,
                    ["name"] = "타락한 밸라스트라즈",
                }, -- [2]
                {
                    ["id"] = 1531,
                    ["image"] = 1378968,
                    ["name"] = "용기대장 래쉬레이어",
                }, -- [3]
                {
                    ["id"] = 1532,
                    ["image"] = 1378973,
                    ["name"] = "화염아귀",
                }, -- [4]
                {
                    ["id"] = 1533,
                    ["image"] = 1378971,
                    ["name"] = "에본로크",
                }, -- [5]
                {
                    ["id"] = 1534,
                    ["image"] = 1378974,
                    ["name"] = "플레임고르",
                }, -- [6]
                {
                    ["id"] = 1535,
                    ["image"] = 1378969,
                    ["name"] = "크로마구스",
                }, -- [7]
                {
                    ["id"] = 1536,
                    ["image"] = 1379001,
                    ["name"] = "네파리안",
                }, -- [8]
            },
        }, -- [2]
        {
            ["id"] = 743,
            ["image"] = 1396591,
            ["name"] = "안퀴라즈 폐허",
            ["bosses"] = {
                {
                    ["id"] = 1537,
                    ["image"] = 1385749,
                    ["name"] = "쿠린낙스",
                }, -- [1]
                {
                    ["id"] = 1538,
                    ["image"] = 1385734,
                    ["name"] = "장군 라작스",
                }, -- [2]
                {
                    ["id"] = 1539,
                    ["image"] = 1385755,
                    ["name"] = "모암",
                }, -- [3]
                {
                    ["id"] = 1540,
                    ["image"] = 1385723,
                    ["name"] = "먹보 부루",
                }, -- [4]
                {
                    ["id"] = 1541,
                    ["image"] = 1385718,
                    ["name"] = "사냥꾼 아야미스",
                }, -- [5]
                {
                    ["id"] = 1542,
                    ["image"] = 1385759,
                    ["name"] = "무적의 오시리안",
                }, -- [6]
            },
        }, -- [3]
        {
            ["id"] = 744,
            ["image"] = 1396593,
            ["name"] = "안퀴라즈 사원",
            ["bosses"] = {
                {
                    ["id"] = 1543,
                    ["image"] = 1385769,
                    ["name"] = "예언자 스케람",
                }, -- [1]
                {
                    ["id"] = 1547,
                    ["image"] = 1390436,
                    ["name"] = "실리시드 왕실",
                }, -- [2]
                {
                    ["id"] = 1544,
                    ["image"] = 1385720,
                    ["name"] = "전투감시병 살투라",
                }, -- [3]
                {
                    ["id"] = 1545,
                    ["image"] = 1385728,
                    ["name"] = "불굴의 판크리스",
                }, -- [4]
                {
                    ["id"] = 1548,
                    ["image"] = 1385771,
                    ["name"] = "비시두스",
                }, -- [5]
                {
                    ["id"] = 1546,
                    ["image"] = 1385761,
                    ["name"] = "공주 후후란",
                }, -- [6]
                {
                    ["id"] = 1549,
                    ["image"] = 1390437,
                    ["name"] = "쌍둥이 제왕",
                }, -- [7]
                {
                    ["id"] = 1550,
                    ["image"] = 1385760,
                    ["name"] = "아우로",
                }, -- [8]
                {
                    ["id"] = 1551,
                    ["image"] = 1385726,
                    ["name"] = "크툰",
                }, -- [9]
            },
        }, -- [4]
        {
            ["id"] = 233,
            ["image"] = 608212,
            ["name"] = "가시덩굴 구릉",
            ["bosses"] = {
                {
                    ["id"] = 1142,
                    ["image"] = 607633,
                    ["name"] = "아룩스",
                }, -- [1]
                {
                    ["id"] = 433,
                    ["image"] = 607718,
                    ["name"] = "불꽃눈 모드레쉬",
                }, -- [2]
                {
                    ["id"] = 1143,
                    ["image"] = 1064178,
                    ["name"] = "살점곤죽",
                }, -- [3]
                {
                    ["id"] = 1146,
                    ["image"] = 607584,
                    ["name"] = "죽음예언자 블랙쏜",
                }, -- [4]
                {
                    ["id"] = 1141,
                    ["image"] = 607537,
                    ["name"] = "혹한의 암네나르",
                }, -- [5]
            },
        }, -- [5]
        {
            ["id"] = 234,
            ["image"] = 608213,
            ["name"] = "가시덩굴 우리",
            ["bosses"] = {
                {
                    ["id"] = 896,
                    ["image"] = 607531,
                    ["name"] = "사냥꾼 본터스크",
                }, -- [1]
                {
                    ["id"] = 895,
                    ["image"] = 607760,
                    ["name"] = "루구그",
                }, -- [2]
                {
                    ["id"] = 899,
                    ["image"] = 607736,
                    ["name"] = "장군 램터스크",
                }, -- [3]
                {
                    ["id"] = 900,
                    ["image"] = 1064175,
                    ["name"] = "눈먼사냥꾼 그로얏",
                }, -- [4]
                {
                    ["id"] = 901,
                    ["image"] = 607563,
                    ["name"] = "서슬깃 차를가",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 228,
            ["image"] = 608196,
            ["name"] = "검은바위 나락",
            ["bosses"] = {
                {
                    ["id"] = 369,
                    ["image"] = 607644,
                    ["name"] = "대심문관 게르스탄",
                }, -- [1]
                {
                    ["id"] = 370,
                    ["image"] = 607697,
                    ["name"] = "불의 군주 록코르",
                }, -- [2]
                {
                    ["id"] = 371,
                    ["image"] = 607647,
                    ["name"] = "사냥개조련사 그렙마르",
                }, -- [3]
                {
                    ["id"] = 372,
                    ["image"] = 608314,
                    ["name"] = "법의 심판장",
                }, -- [4]
                {
                    ["id"] = 373,
                    ["image"] = 607749,
                    ["name"] = "화염술사 로어그레인",
                }, -- [5]
                {
                    ["id"] = 374,
                    ["image"] = 607694,
                    ["name"] = "불의 군주 인센디우스",
                }, -- [6]
                {
                    ["id"] = 375,
                    ["image"] = 607814,
                    ["name"] = "문지기 스틸기스",
                }, -- [7]
                {
                    ["id"] = 376,
                    ["image"] = 607602,
                    ["name"] = "파이너스 다크바이어",
                }, -- [8]
                {
                    ["id"] = 377,
                    ["image"] = 607549,
                    ["name"] = "밸가르",
                }, -- [9]
                {
                    ["id"] = 378,
                    ["image"] = 607610,
                    ["name"] = "사령관 앵거포지",
                }, -- [10]
                {
                    ["id"] = 379,
                    ["image"] = 607618,
                    ["name"] = "골렘 군주 아젤마크",
                }, -- [11]
                {
                    ["id"] = 380,
                    ["image"] = 607650,
                    ["name"] = "헐레이 블랙브레스",
                }, -- [12]
                {
                    ["id"] = 381,
                    ["image"] = 607740,
                    ["name"] = "팔랑크스",
                }, -- [13]
                {
                    ["id"] = 383,
                    ["image"] = 607741,
                    ["name"] = "플러거 스패즈링",
                }, -- [14]
                {
                    ["id"] = 384,
                    ["image"] = 607535,
                    ["name"] = "사자 화염채찍",
                }, -- [15]
                {
                    ["id"] = 385,
                    ["image"] = 607587,
                    ["name"] = "일곱 현자",
                }, -- [16]
                {
                    ["id"] = 386,
                    ["image"] = 607705,
                    ["name"] = "마그무스",
                }, -- [17]
                {
                    ["id"] = 387,
                    ["image"] = 607595,
                    ["name"] = "제왕 다그란 타우릿산",
                }, -- [18]
            },
        }, -- [7]
        {
            ["id"] = 229,
            ["image"] = 608197,
            ["name"] = "검은바위 첨탑 하층",
            ["bosses"] = {
                {
                    ["id"] = 388,
                    ["image"] = 607645,
                    ["name"] = "대영주 오모크",
                }, -- [1]
                {
                    ["id"] = 389,
                    ["image"] = 607769,
                    ["name"] = "어둠사냥꾼 보쉬가진",
                }, -- [2]
                {
                    ["id"] = 390,
                    ["image"] = 607810,
                    ["name"] = "대장군 부네",
                }, -- [3]
                {
                    ["id"] = 391,
                    ["image"] = 607719,
                    ["name"] = "여왕 불그물거미",
                }, -- [4]
                {
                    ["id"] = 392,
                    ["image"] = 607801,
                    ["name"] = "우로크 둠하울",
                }, -- [5]
                {
                    ["id"] = 393,
                    ["image"] = 607751,
                    ["name"] = "병참장교 지그리스",
                }, -- [6]
                {
                    ["id"] = 394,
                    ["image"] = 607634,
                    ["name"] = "할리콘",
                }, -- [7]
                {
                    ["id"] = 395,
                    ["image"] = 607615,
                    ["name"] = "흉포한 기즈룰",
                }, -- [8]
                {
                    ["id"] = 396,
                    ["image"] = 607737,
                    ["name"] = "대군주 웜타라크",
                }, -- [9]
            },
        }, -- [8]
        {
            ["id"] = 227,
            ["image"] = 608195,
            ["name"] = "검은심연 나락",
            ["bosses"] = {
                {
                    ["id"] = 368,
                    ["image"] = 1064179,
                    ["name"] = "가무라",
                }, -- [1]
                {
                    ["id"] = 436,
                    ["image"] = 1064180,
                    ["name"] = "도미나",
                }, -- [2]
                {
                    ["id"] = 426,
                    ["image"] = 522214,
                    ["name"] = "정복자 코르울",
                }, -- [3]
                {
                    ["id"] = 1145,
                    ["image"] = 1064181,
                    ["name"] = "쓰럭",
                }, -- [4]
                {
                    ["id"] = 447,
                    ["image"] = 1064182,
                    ["name"] = "심연의 수호자",
                }, -- [5]
                {
                    ["id"] = 1144,
                    ["image"] = 1064183,
                    ["name"] = "집행자 고어",
                }, -- [6]
                {
                    ["id"] = 437,
                    ["image"] = 1064184,
                    ["name"] = "황혼의 군주 바시엘",
                }, -- [7]
                {
                    ["id"] = 444,
                    ["image"] = 607532,
                    ["name"] = "아쿠마이",
                }, -- [8]
            },
        }, -- [9]
        {
            ["id"] = 64,
            ["image"] = 522358,
            ["name"] = "그림자송곳니 성채",
            ["bosses"] = {
                {
                    ["id"] = 96,
                    ["image"] = 522205,
                    ["name"] = "남작 애쉬버리",
                }, -- [1]
                {
                    ["id"] = 97,
                    ["image"] = 522206,
                    ["name"] = "남작 실버레인",
                }, -- [2]
                {
                    ["id"] = 98,
                    ["image"] = 522213,
                    ["name"] = "사령관 스프링베일",
                }, -- [3]
                {
                    ["id"] = 99,
                    ["image"] = 522249,
                    ["name"] = "월든 경",
                }, -- [4]
                {
                    ["id"] = 100,
                    ["image"] = 522247,
                    ["name"] = "고드프리 경",
                }, -- [5]
            },
        }, -- [10]
        {
            ["id"] = 231,
            ["image"] = 608202,
            ["name"] = "놈리건",
            ["bosses"] = {
                {
                    ["id"] = 419,
                    ["image"] = 607628,
                    ["name"] = "그루비스",
                }, -- [1]
                {
                    ["id"] = 420,
                    ["image"] = 607808,
                    ["name"] = "방사성 폐기물",
                }, -- [2]
                {
                    ["id"] = 421,
                    ["image"] = 607594,
                    ["name"] = "기계화 문지기 6000",
                }, -- [3]
                {
                    ["id"] = 418,
                    ["image"] = 607572,
                    ["name"] = "고철 압축기 9-60",
                }, -- [4]
                {
                    ["id"] = 422,
                    ["image"] = 607714,
                    ["name"] = "기계박사 텔마플러그",
                }, -- [5]
            },
        }, -- [11]
        {
            ["id"] = 232,
            ["image"] = 608209,
            ["name"] = "마라우돈",
            ["bosses"] = {
                {
                    ["id"] = 423,
                    ["image"] = 607728,
                    ["name"] = "녹시온",
                }, -- [1]
                {
                    ["id"] = 424,
                    ["image"] = 607756,
                    ["name"] = "칼날채찍",
                }, -- [2]
                {
                    ["id"] = 425,
                    ["image"] = 607796,
                    ["name"] = "땜장이 기즐록",
                }, -- [3]
                {
                    ["id"] = 427,
                    ["image"] = 607699,
                    ["name"] = "군주 바일텅",
                }, -- [4]
                {
                    ["id"] = 428,
                    ["image"] = 607562,
                    ["name"] = "저주받은 셀레브라스",
                }, -- [5]
                {
                    ["id"] = 429,
                    ["image"] = 607684,
                    ["name"] = "산사태",
                }, -- [6]
                {
                    ["id"] = 430,
                    ["image"] = 607761,
                    ["name"] = "썩은아귀",
                }, -- [7]
                {
                    ["id"] = 431,
                    ["image"] = 607747,
                    ["name"] = "공주 테라드라스",
                }, -- [8]
            },
        }, -- [12]
        {
            ["id"] = 316,
            ["image"] = 608214,
            ["name"] = "붉은십자군 수도원",
            ["bosses"] = {
                {
                    ["id"] = 688,
                    ["image"] = 630853,
                    ["name"] = "영혼분리자 탈노스",
                }, -- [1]
                {
                    ["id"] = 671,
                    ["image"] = 630818,
                    ["name"] = "수사 콜로프",
                }, -- [2]
                {
                    ["id"] = 674,
                    ["image"] = 607643,
                    ["name"] = "종교재판관 화이트메인",
                }, -- [3]
            },
        }, -- [13]
        {
            ["id"] = 311,
            ["image"] = 643262,
            ["name"] = "붉은십자군 전당",
            ["bosses"] = {
                {
                    ["id"] = 660,
                    ["image"] = 630833,
                    ["name"] = "사냥개조련사 브라운",
                }, -- [1]
                {
                    ["id"] = 654,
                    ["image"] = 630816,
                    ["name"] = "무기전문가 할란",
                }, -- [2]
                {
                    ["id"] = 656,
                    ["image"] = 630825,
                    ["name"] = "화염술사 쾨글러",
                }, -- [3]
            },
        }, -- [14]
        {
            ["id"] = 226,
            ["image"] = 608211,
            ["name"] = "성난불길 협곡",
            ["bosses"] = {
                {
                    ["id"] = 694,
                    ["image"] = 608309,
                    ["name"] = "아다로그",
                }, -- [1]
                {
                    ["id"] = 695,
                    ["image"] = 608310,
                    ["name"] = "암흑주술사 코란살",
                }, -- [2]
                {
                    ["id"] = 696,
                    ["image"] = 522251,
                    ["name"] = "화산아귀",
                }, -- [3]
                {
                    ["id"] = 697,
                    ["image"] = 608315,
                    ["name"] = "용암경비병 고르도스",
                }, -- [4]
            },
        }, -- [15]
        {
            ["id"] = 246,
            ["image"] = 608215,
            ["name"] = "스칼로맨스",
            ["bosses"] = {
                {
                    ["id"] = 659,
                    ["image"] = 630835,
                    ["name"] = "조교 칠하트",
                }, -- [1]
                {
                    ["id"] = 663,
                    ["image"] = 607666,
                    ["name"] = "잔다이스 바로브",
                }, -- [2]
                {
                    ["id"] = 665,
                    ["image"] = 607755,
                    ["name"] = "들창엄니",
                }, -- [3]
                {
                    ["id"] = 666,
                    ["image"] = 630838,
                    ["name"] = "릴리안 보스",
                }, -- [4]
                {
                    ["id"] = 684,
                    ["image"] = 607582,
                    ["name"] = "암흑스승 간들링",
                }, -- [5]
            },
        }, -- [16]
        {
            ["id"] = 238,
            ["image"] = 608223,
            ["name"] = "스톰윈드 지하감옥",
            ["bosses"] = {
                {
                    ["id"] = 464,
                    ["image"] = 607646,
                    ["name"] = "들창코",
                }, -- [1]
                {
                    ["id"] = 465,
                    ["image"] = 607695,
                    ["name"] = "군주 열지옥",
                }, -- [2]
                {
                    ["id"] = 466,
                    ["image"] = 607753,
                    ["name"] = "란돌프 몰로크",
                }, -- [3]
            },
        }, -- [17]
        {
            ["id"] = 236,
            ["image"] = 608216,
            ["name"] = "스트라솔름",
            ["bosses"] = {
                {
                    ["id"] = 443,
                    ["image"] = 607637,
                    ["name"] = "하스싱어 포레스턴",
                }, -- [1]
                {
                    ["id"] = 445,
                    ["image"] = 607795,
                    ["name"] = "잔혹한 티미",
                }, -- [2]
                {
                    ["id"] = 749,
                    ["image"] = 607569,
                    ["name"] = "사령관 말로",
                }, -- [3]
                {
                    ["id"] = 446,
                    ["image"] = 607818,
                    ["name"] = "윌리 호프브레이커",
                }, -- [4]
                {
                    ["id"] = 448,
                    ["image"] = 607660,
                    ["name"] = "교관 갈포드",
                }, -- [5]
                {
                    ["id"] = 449,
                    ["image"] = 607551,
                    ["name"] = "발나자르",
                }, -- [6]
                {
                    ["id"] = 450,
                    ["image"] = 607792,
                    ["name"] = "용서받지 못한 자",
                }, -- [7]
                {
                    ["id"] = 451,
                    ["image"] = 607553,
                    ["name"] = "남작부인 아나스타리",
                }, -- [8]
                {
                    ["id"] = 452,
                    ["image"] = 607724,
                    ["name"] = "네룹엔칸",
                }, -- [9]
                {
                    ["id"] = 453,
                    ["image"] = 607707,
                    ["name"] = "냉혈한 말레키",
                }, -- [10]
                {
                    ["id"] = 454,
                    ["image"] = 607791,
                    ["name"] = "집정관 발실라스",
                }, -- [11]
                {
                    ["id"] = 455,
                    ["image"] = 607752,
                    ["name"] = "먹보 람스타인",
                }, -- [12]
                {
                    ["id"] = 456,
                    ["image"] = 607692,
                    ["name"] = "군주 아우리우스 리븐데어",
                }, -- [13]
            },
        }, -- [18]
        {
            ["id"] = 237,
            ["image"] = 608217,
            ["name"] = "아탈학카르 신전",
            ["bosses"] = {
                {
                    ["id"] = 457,
                    ["image"] = 607548,
                    ["name"] = "학카르의 화신",
                }, -- [1]
                {
                    ["id"] = 458,
                    ["image"] = 607665,
                    ["name"] = "예언자 잠말란",
                }, -- [2]
                {
                    ["id"] = 459,
                    ["image"] = 608311,
                    ["name"] = "꿈의 감독관",
                }, -- [3]
                {
                    ["id"] = 463,
                    ["image"] = 607768,
                    ["name"] = "에라니쿠스의 사령",
                }, -- [4]
            },
        }, -- [19]
        {
            ["id"] = 239,
            ["image"] = 608225,
            ["name"] = "울다만",
            ["bosses"] = {
                {
                    ["id"] = 467,
                    ["image"] = 607757,
                    ["name"] = "레벨로쉬",
                }, -- [1]
                {
                    ["id"] = 468,
                    ["image"] = 607550,
                    ["name"] = "길 잃은 드워프",
                }, -- [2]
                {
                    ["id"] = 469,
                    ["image"] = 607664,
                    ["name"] = "아이로나야",
                }, -- [3]
                {
                    ["id"] = 748,
                    ["image"] = 607729,
                    ["name"] = "흑요석 파수꾼",
                }, -- [4]
                {
                    ["id"] = 470,
                    ["image"] = 607538,
                    ["name"] = "고대 바위 문지기",
                }, -- [5]
                {
                    ["id"] = 471,
                    ["image"] = 607606,
                    ["name"] = "갈간 파이어해머",
                }, -- [6]
                {
                    ["id"] = 472,
                    ["image"] = 607626,
                    ["name"] = "그림로크",
                }, -- [7]
                {
                    ["id"] = 473,
                    ["image"] = 607546,
                    ["name"] = "아카에다스",
                }, -- [8]
            },
        }, -- [20]
        {
            ["id"] = 63,
            ["image"] = 522352,
            ["name"] = "죽음의 폐광",
            ["bosses"] = {
                {
                    ["id"] = 89,
                    ["image"] = 522228,
                    ["name"] = "글럽톡",
                }, -- [1]
                {
                    ["id"] = 90,
                    ["image"] = 522234,
                    ["name"] = "헬릭스 기어브레이커",
                }, -- [2]
                {
                    ["id"] = 91,
                    ["image"] = 522225,
                    ["name"] = "전투 절단기 5000",
                }, -- [3]
                {
                    ["id"] = 92,
                    ["image"] = 522189,
                    ["name"] = "제독 으르렁니",
                }, -- [4]
                {
                    ["id"] = 93,
                    ["image"] = 522210,
                    ["name"] = "\"선장\" 쿠키",
                }, -- [5]
            },
        }, -- [21]
        {
            ["id"] = 241,
            ["image"] = 608230,
            ["name"] = "줄파락",
            ["bosses"] = {
                {
                    ["id"] = 483,
                    ["image"] = 607614,
                    ["name"] = "가즈릴라",
                }, -- [1]
                {
                    ["id"] = 484,
                    ["image"] = 607541,
                    ["name"] = "안투술",
                }, -- [2]
                {
                    ["id"] = 485,
                    ["image"] = 607793,
                    ["name"] = "순교자 데카",
                }, -- [3]
                {
                    ["id"] = 486,
                    ["image"] = 607819,
                    ["name"] = "의술사 줌라",
                }, -- [4]
                {
                    ["id"] = 487,
                    ["image"] = 607723,
                    ["name"] = "네크룸과 세즈지즈",
                }, -- [5]
                {
                    ["id"] = 489,
                    ["image"] = 607564,
                    ["name"] = "족장 우코르즈 샌드스칼프",
                }, -- [6]
            },
        }, -- [22]
        {
            ["id"] = 240,
            ["image"] = 608229,
            ["name"] = "통곡의 동굴",
            ["bosses"] = {
                {
                    ["id"] = 474,
                    ["image"] = 607680,
                    ["name"] = "여군주 아나콘드라",
                }, -- [1]
                {
                    ["id"] = 476,
                    ["image"] = 607696,
                    ["name"] = "군주 피타스",
                }, -- [2]
                {
                    ["id"] = 475,
                    ["image"] = 607693,
                    ["name"] = "군주 코브란",
                }, -- [3]
                {
                    ["id"] = 477,
                    ["image"] = 607676,
                    ["name"] = "크레쉬",
                }, -- [4]
                {
                    ["id"] = 478,
                    ["image"] = 607775,
                    ["name"] = "스컴",
                }, -- [5]
                {
                    ["id"] = 479,
                    ["image"] = 607698,
                    ["name"] = "군주 서펜티스",
                }, -- [6]
                {
                    ["id"] = 480,
                    ["image"] = 607805,
                    ["name"] = "영생의 베르단",
                }, -- [7]
                {
                    ["id"] = 481,
                    ["image"] = 607721,
                    ["name"] = "걸신들린 무타누스",
                }, -- [8]
            },
        }, -- [23]
        {
            ["id"] = 230,
            ["image"] = 608200,
            ["name"] = "혈투의 전장",
            ["bosses"] = {
                {
                    ["id"] = 402,
                    ["image"] = 607824,
                    ["name"] = "제브림 쏜후프",
                }, -- [1]
                {
                    ["id"] = 403,
                    ["image"] = 607653,
                    ["name"] = "히드로스폰",
                }, -- [2]
                {
                    ["id"] = 404,
                    ["image"] = 607686,
                    ["name"] = "레스텐드리스",
                }, -- [3]
                {
                    ["id"] = 405,
                    ["image"] = 607533,
                    ["name"] = "칼날바람 알진",
                }, -- [4]
                {
                    ["id"] = 406,
                    ["image"] = 607785,
                    ["name"] = "굽이나무 텐드리스",
                }, -- [5]
                {
                    ["id"] = 407,
                    ["image"] = 607656,
                    ["name"] = "일리아나 레이븐오크",
                }, -- [6]
                {
                    ["id"] = 408,
                    ["image"] = 607703,
                    ["name"] = "마법학자 칼렌드리스",
                }, -- [7]
                {
                    ["id"] = 409,
                    ["image"] = 607657,
                    ["name"] = "이몰타르",
                }, -- [8]
                {
                    ["id"] = 410,
                    ["image"] = 607745,
                    ["name"] = "왕자 토르텔드린",
                }, -- [9]
                {
                    ["id"] = 411,
                    ["image"] = 607630,
                    ["name"] = "경비병 몰다르",
                }, -- [10]
                {
                    ["id"] = 412,
                    ["image"] = 607777,
                    ["name"] = "천둥발 크리그",
                }, -- [11]
                {
                    ["id"] = 413,
                    ["image"] = 607629,
                    ["name"] = "경비병 펜구스",
                }, -- [12]
                {
                    ["id"] = 414,
                    ["image"] = 607631,
                    ["name"] = "경비병 슬립킥",
                }, -- [13]
                {
                    ["id"] = 415,
                    ["image"] = 607560,
                    ["name"] = "대장 크롬크러쉬",
                }, -- [14]
                {
                    ["id"] = 416,
                    ["image"] = 607565,
                    ["name"] = "정찰병 초루쉬",
                }, -- [15]
                {
                    ["id"] = 417,
                    ["image"] = 607673,
                    ["name"] = "왕 고르독",
                }, -- [16]
            },
        }, -- [24]
    },
    ["불타는 성전"] = {
        {
            ["id"] = 745,
            ["image"] = 1396584,
            ["name"] = "카라잔",
            ["bosses"] = {
                {
                    ["id"] = 1552,
                    ["image"] = 1385766,
                    ["name"] = "하인 숙소",
                }, -- [1]
                {
                    ["id"] = 1553,
                    ["image"] = 1378965,
                    ["name"] = "사냥꾼 어튜멘",
                }, -- [2]
                {
                    ["id"] = 1554,
                    ["image"] = 1378999,
                    ["name"] = "모로스",
                }, -- [3]
                {
                    ["id"] = 1555,
                    ["image"] = 1378997,
                    ["name"] = "고결의 여신",
                }, -- [4]
                {
                    ["id"] = 1556,
                    ["image"] = 1385758,
                    ["name"] = "오페라 극장",
                }, -- [5]
                {
                    ["id"] = 1557,
                    ["image"] = 1379020,
                    ["name"] = "전시 관리인",
                }, -- [6]
                {
                    ["id"] = 1559,
                    ["image"] = 1379012,
                    ["name"] = "아란의 망령",
                }, -- [7]
                {
                    ["id"] = 1560,
                    ["image"] = 1379017,
                    ["name"] = "테레스티안 일후프",
                }, -- [8]
                {
                    ["id"] = 1561,
                    ["image"] = 1379002,
                    ["name"] = "황천의 원령",
                }, -- [9]
                {
                    ["id"] = 1764,
                    ["image"] = 1385724,
                    ["name"] = "체스 이벤트",
                }, -- [10]
                {
                    ["id"] = 1563,
                    ["image"] = 1379006,
                    ["name"] = "공작 말체자르",
                }, -- [11]
            },
        }, -- [1]
        {
            ["id"] = 746,
            ["image"] = 1396582,
            ["name"] = "그룰의 둥지",
            ["bosses"] = {
                {
                    ["id"] = 1564,
                    ["image"] = 1378985,
                    ["name"] = "왕중왕 마울가르",
                }, -- [1]
                {
                    ["id"] = 1565,
                    ["image"] = 1378982,
                    ["name"] = "용 학살자 그룰",
                }, -- [2]
            },
        }, -- [2]
        {
            ["id"] = 747,
            ["image"] = 1396585,
            ["name"] = "마그테리돈의 둥지",
            ["bosses"] = {
                {
                    ["id"] = 1566,
                    ["image"] = 1378996,
                    ["name"] = "마그테리돈",
                }, -- [1]
            },
        }, -- [3]
        {
            ["id"] = 748,
            ["image"] = 608199,
            ["name"] = "불뱀 제단",
            ["bosses"] = {
                {
                    ["id"] = 1567,
                    ["image"] = 1385741,
                    ["name"] = "불안정한 히드로스",
                }, -- [1]
                {
                    ["id"] = 1568,
                    ["image"] = 1385768,
                    ["name"] = "심연의 잠복꾼",
                }, -- [2]
                {
                    ["id"] = 1569,
                    ["image"] = 1385751,
                    ["name"] = "눈먼 레오테라스",
                }, -- [3]
                {
                    ["id"] = 1570,
                    ["image"] = 1385729,
                    ["name"] = "심해군주 카라드레스",
                }, -- [4]
                {
                    ["id"] = 1571,
                    ["image"] = 1385756,
                    ["name"] = "겅둥파도 모로그림",
                }, -- [5]
                {
                    ["id"] = 1572,
                    ["image"] = 1385750,
                    ["name"] = "여군주 바쉬",
                }, -- [6]
            },
        }, -- [4]
        {
            ["id"] = 749,
            ["image"] = 608218,
            ["name"] = "폭풍우 눈",
            ["bosses"] = {
                {
                    ["id"] = 1573,
                    ["image"] = 1385712,
                    ["name"] = "알라르",
                }, -- [1]
                {
                    ["id"] = 1574,
                    ["image"] = 1385772,
                    ["name"] = "공허의 절단기",
                }, -- [2]
                {
                    ["id"] = 1575,
                    ["image"] = 1385739,
                    ["name"] = "고위 점성술사 솔라리안",
                }, -- [3]
                {
                    ["id"] = 1576,
                    ["image"] = 607669,
                    ["name"] = "캘타스 선스트라이더",
                }, -- [4]
            },
        }, -- [5]
        {
            ["id"] = 750,
            ["image"] = 608198,
            ["name"] = "하이잘 산 전투",
            ["bosses"] = {
                {
                    ["id"] = 1577,
                    ["image"] = 1385762,
                    ["name"] = "격노한 윈터칠",
                }, -- [1]
                {
                    ["id"] = 1578,
                    ["image"] = 1385714,
                    ["name"] = "아네테론",
                }, -- [2]
                {
                    ["id"] = 1579,
                    ["image"] = 1385745,
                    ["name"] = "카즈로갈",
                }, -- [3]
                {
                    ["id"] = 1580,
                    ["image"] = 1385719,
                    ["name"] = "아즈갈로",
                }, -- [4]
                {
                    ["id"] = 1581,
                    ["image"] = 1385716,
                    ["name"] = "아키몬드",
                }, -- [5]
            },
        }, -- [6]
        {
            ["id"] = 751,
            ["image"] = 1396579,
            ["name"] = "검은 사원",
            ["bosses"] = {
                {
                    ["id"] = 1582,
                    ["image"] = 1378986,
                    ["name"] = "대장군 나젠투스",
                }, -- [1]
                {
                    ["id"] = 1583,
                    ["image"] = 1379016,
                    ["name"] = "궁극의 심연",
                }, -- [2]
                {
                    ["id"] = 1584,
                    ["image"] = 1379011,
                    ["name"] = "아카마의 망령",
                }, -- [3]
                {
                    ["id"] = 1585,
                    ["image"] = 1379018,
                    ["name"] = "테론 고어핀드",
                }, -- [4]
                {
                    ["id"] = 1586,
                    ["image"] = 1378983,
                    ["name"] = "구르토그 블러드보일",
                }, -- [5]
                {
                    ["id"] = 1587,
                    ["image"] = 1385764,
                    ["name"] = "영혼의 성물함",
                }, -- [6]
                {
                    ["id"] = 1588,
                    ["image"] = 1379000,
                    ["name"] = "대모 샤라즈",
                }, -- [7]
                {
                    ["id"] = 1589,
                    ["image"] = 1385743,
                    ["name"] = "일리다리 의회",
                }, -- [8]
                {
                    ["id"] = 1590,
                    ["image"] = 1378987,
                    ["name"] = "일리단 스톰레이지",
                }, -- [9]
            },
        }, -- [7]
        {
            ["id"] = 752,
            ["image"] = 1396592,
            ["name"] = "태양샘 고원",
            ["bosses"] = {
                {
                    ["id"] = 1591,
                    ["image"] = 1385744,
                    ["name"] = "칼렉고스",
                }, -- [1]
                {
                    ["id"] = 1592,
                    ["image"] = 1385722,
                    ["name"] = "브루탈루스",
                }, -- [2]
                {
                    ["id"] = 1593,
                    ["image"] = 1385730,
                    ["name"] = "지옥안개",
                }, -- [3]
                {
                    ["id"] = 1594,
                    ["image"] = 1390438,
                    ["name"] = "에레다르 쌍둥이",
                }, -- [4]
                {
                    ["id"] = 1595,
                    ["image"] = 1385757,
                    ["name"] = "므우루",
                }, -- [5]
                {
                    ["id"] = 1596,
                    ["image"] = 1385746,
                    ["name"] = "킬제덴",
                }, -- [6]
            },
        }, -- [8]
        {
            ["id"] = 260,
            ["image"] = 608199,
            ["name"] = "강제 노역소",
            ["bosses"] = {
                {
                    ["id"] = 570,
                    ["image"] = 607715,
                    ["name"] = "배반자 멘누",
                }, -- [1]
                {
                    ["id"] = 571,
                    ["image"] = 607759,
                    ["name"] = "딱딱이 로크마르",
                }, -- [2]
                {
                    ["id"] = 572,
                    ["image"] = 607750,
                    ["name"] = "쿠아그미란",
                }, -- [3]
            },
        }, -- [9]
        {
            ["id"] = 255,
            ["image"] = 608198,
            ["name"] = "검은늪",
            ["bosses"] = {
                {
                    ["id"] = 552,
                    ["image"] = 607566,
                    ["name"] = "시간의 군주 데자",
                }, -- [1]
                {
                    ["id"] = 553,
                    ["image"] = 607784,
                    ["name"] = "템퍼루스",
                }, -- [2]
                {
                    ["id"] = 554,
                    ["image"] = 607529,
                    ["name"] = "아에누스",
                }, -- [3]
            },
        }, -- [10]
        {
            ["id"] = 250,
            ["image"] = 608193,
            ["name"] = "마나 무덤",
            ["bosses"] = {
                {
                    ["id"] = 534,
                    ["image"] = 607738,
                    ["name"] = "팬더모니우스",
                }, -- [1]
                {
                    ["id"] = 535,
                    ["image"] = 607782,
                    ["name"] = "타바로크",
                }, -- [2]
                {
                    ["id"] = 537,
                    ["image"] = 607726,
                    ["name"] = "연합왕자 샤파르",
                }, -- [3]
            },
        }, -- [11]
        {
            ["id"] = 249,
            ["image"] = 608208,
            ["name"] = "마법학자의 정원",
            ["bosses"] = {
                {
                    ["id"] = 530,
                    ["image"] = 607767,
                    ["name"] = "셀린 파이어하트",
                }, -- [1]
                {
                    ["id"] = 531,
                    ["image"] = 607806,
                    ["name"] = "벡살루스",
                }, -- [2]
                {
                    ["id"] = 532,
                    ["image"] = 607742,
                    ["name"] = "여사제 델리사",
                }, -- [3]
                {
                    ["id"] = 533,
                    ["image"] = 607669,
                    ["name"] = "캘타스 선스트라이더",
                }, -- [4]
            },
        }, -- [12]
        {
            ["id"] = 258,
            ["image"] = 608218,
            ["name"] = "메카나르",
            ["bosses"] = {
                {
                    ["id"] = 563,
                    ["image"] = 607712,
                    ["name"] = "기계군주 캐퍼시투스",
                }, -- [1]
                {
                    ["id"] = 564,
                    ["image"] = 607725,
                    ["name"] = "황천술사 세페스레아",
                }, -- [2]
                {
                    ["id"] = 565,
                    ["image"] = 607739,
                    ["name"] = "철두철미한 파탈리온",
                }, -- [3]
            },
        }, -- [13]
        {
            ["id"] = 252,
            ["image"] = 608193,
            ["name"] = "세데크 전당",
            ["bosses"] = {
                {
                    ["id"] = 541,
                    ["image"] = 607583,
                    ["name"] = "흑마술사 시스",
                }, -- [1]
                {
                    ["id"] = 543,
                    ["image"] = 607780,
                    ["name"] = "갈퀴대왕 이키스",
                }, -- [2]
            },
        }, -- [14]
        {
            ["id"] = 257,
            ["image"] = 608218,
            ["name"] = "신록의 정원",
            ["bosses"] = {
                {
                    ["id"] = 558,
                    ["image"] = 607570,
                    ["name"] = "지휘관 새래니스",
                }, -- [1]
                {
                    ["id"] = 559,
                    ["image"] = 607641,
                    ["name"] = "고위 식물학자 프레이윈",
                }, -- [2]
                {
                    ["id"] = 560,
                    ["image"] = 607794,
                    ["name"] = "감시인 쏜그린",
                }, -- [3]
                {
                    ["id"] = 561,
                    ["image"] = 607683,
                    ["name"] = "라즈",
                }, -- [4]
                {
                    ["id"] = 562,
                    ["image"] = 607816,
                    ["name"] = "차원의 분리자",
                }, -- [5]
            },
        }, -- [15]
        {
            ["id"] = 247,
            ["image"] = 608193,
            ["name"] = "아키나이 납골당",
            ["bosses"] = {
                {
                    ["id"] = 523,
                    ["image"] = 607771,
                    ["name"] = "죽음의 감시인 쉴라크",
                }, -- [1]
                {
                    ["id"] = 524,
                    ["image"] = 607600,
                    ["name"] = "총독 말라다르",
                }, -- [2]
            },
        }, -- [16]
        {
            ["id"] = 254,
            ["image"] = 608218,
            ["name"] = "알카트라즈",
            ["bosses"] = {
                {
                    ["id"] = 548,
                    ["image"] = 607823,
                    ["name"] = "속박 풀린 제레케스",
                }, -- [1]
                {
                    ["id"] = 549,
                    ["image"] = 607574,
                    ["name"] = "파멸의 예언자 달리아",
                }, -- [2]
                {
                    ["id"] = 550,
                    ["image"] = 607820,
                    ["name"] = "격노의 점술사 소코드라테스",
                }, -- [3]
                {
                    ["id"] = 551,
                    ["image"] = 607635,
                    ["name"] = "선구자 스키리스",
                }, -- [4]
            },
        }, -- [17]
        {
            ["id"] = 253,
            ["image"] = 608193,
            ["name"] = "어둠의 미궁",
            ["bosses"] = {
                {
                    ["id"] = 544,
                    ["image"] = 607536,
                    ["name"] = "사자 지옥아귀",
                }, -- [1]
                {
                    ["id"] = 545,
                    ["image"] = 607555,
                    ["name"] = "선동자 검은심장",
                }, -- [2]
                {
                    ["id"] = 546,
                    ["image"] = 607625,
                    ["name"] = "단장 보르필",
                }, -- [3]
                {
                    ["id"] = 547,
                    ["image"] = 607720,
                    ["name"] = "울림",
                }, -- [4]
            },
        }, -- [18]
        {
            ["id"] = 251,
            ["image"] = 608198,
            ["name"] = "옛 언덕마루 구릉지",
            ["bosses"] = {
                {
                    ["id"] = 538,
                    ["image"] = 607689,
                    ["name"] = "부관 드레이크",
                }, -- [1]
                {
                    ["id"] = 539,
                    ["image"] = 607561,
                    ["name"] = "경비대장 스칼록",
                }, -- [2]
                {
                    ["id"] = 540,
                    ["image"] = 607596,
                    ["name"] = "시대의 사냥꾼",
                }, -- [3]
            },
        }, -- [19]
        {
            ["id"] = 259,
            ["image"] = 608207,
            ["name"] = "으스러진 손의 전당",
            ["bosses"] = {
                {
                    ["id"] = 566,
                    ["image"] = 607624,
                    ["name"] = "대흑마법사 네더쿠르스",
                }, -- [1]
                {
                    ["id"] = 568,
                    ["image"] = 607811,
                    ["name"] = "전쟁인도자 오므로그",
                }, -- [2]
                {
                    ["id"] = 569,
                    ["image"] = 607812,
                    ["name"] = "대족장 카르가스 블레이드피스트",
                }, -- [3]
            },
        }, -- [20]
        {
            ["id"] = 261,
            ["image"] = 608199,
            ["name"] = "증기 저장고",
            ["bosses"] = {
                {
                    ["id"] = 573,
                    ["image"] = 607651,
                    ["name"] = "풍수사 세스피아",
                }, -- [1]
                {
                    ["id"] = 574,
                    ["image"] = 607713,
                    ["name"] = "기계박사 스팀리거",
                }, -- [2]
                {
                    ["id"] = 575,
                    ["image"] = 607815,
                    ["name"] = "장군 칼리스레쉬",
                }, -- [3]
            },
        }, -- [21]
        {
            ["id"] = 248,
            ["image"] = 608207,
            ["name"] = "지옥불 성루",
            ["bosses"] = {
                {
                    ["id"] = 527,
                    ["image"] = 607817,
                    ["name"] = "감시자 가르골마르",
                }, -- [1]
                {
                    ["id"] = 528,
                    ["image"] = 607734,
                    ["name"] = "무적의 오모르",
                }, -- [2]
                {
                    ["id"] = 529,
                    ["image"] = 607803,
                    ["name"] = "사자 바즈루덴",
                }, -- [3]
            },
        }, -- [22]
        {
            ["id"] = 262,
            ["image"] = 608199,
            ["name"] = "지하수렁",
            ["bosses"] = {
                {
                    ["id"] = 576,
                    ["image"] = 607649,
                    ["name"] = "헝가르펜",
                }, -- [1]
                {
                    ["id"] = 577,
                    ["image"] = 607614,
                    ["name"] = "가즈안",
                }, -- [2]
                {
                    ["id"] = 578,
                    ["image"] = 607779,
                    ["name"] = "늪군주 뮤즐레크",
                }, -- [3]
                {
                    ["id"] = 579,
                    ["image"] = 607788,
                    ["name"] = "검은 추적자",
                }, -- [4]
            },
        }, -- [23]
        {
            ["id"] = 256,
            ["image"] = 608207,
            ["name"] = "피의 용광로",
            ["bosses"] = {
                {
                    ["id"] = 555,
                    ["image"] = 607789,
                    ["name"] = "재앙의 창조자",
                }, -- [1]
                {
                    ["id"] = 556,
                    ["image"] = 607558,
                    ["name"] = "브로고크",
                }, -- [2]
                {
                    ["id"] = 557,
                    ["image"] = 607670,
                    ["name"] = "파괴자 켈리단",
                }, -- [3]
            },
        }, -- [24]
    },
}

-------------------------------------------------
-- functions
-------------------------------------------------
function F:GetExpansionList()
    return list[GetLocale()] or list.enUS
end

function F:GetExpansionData()
    return data[GetLocale()] or data.enUS
end