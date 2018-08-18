
BuildEnv(...)

L = LibStub('AceLocale-3.0'):GetLocale('MeetingStone')

ADDON_NAME          = ...
ADDON_LOGO          = [[Interface\AddOns\]] .. ADDON_NAME .. [[\Media\Logo]]
ADDON_VERSION       = GetAddOnMetadata(ADDON_NAME, 'Version')
ADDON_VERSION_SHORT = ADDON_VERSION:gsub('(%d)%d(%d)%d%d%.(%d%d)','%1%2%3')
ADDON_REGIONSUPPORT = GetCurrentRegion() == 5
ADDON_SERVER        = (NETEASE_SERVER_PREFIX or 'S1') .. UnitFactionGroup('player')
SERVER_TIMEOUT      = 120
NO_SCAN_WORD        = true

_G.BINDING_NAME_MEETINGSTONE_TOGGLE = L['打开/关闭集合石']
_G.BINDING_HEADER_NETEASE           = '网易插件'
_G.BINDING_HEADER_MEETINGSTONE      = ADDON_TITLE

SOLO_HIDDEN_CUSTOM_ID       = 999
SOLO_VISIBLE_CUSTOM_ID      = 998
MAX_PLAYER_LEVEL            = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]
MAX_SEARCHBOX_HISTORY_LINES = 5

-- App
APP_WHISPER_DOT = '@'
COMMIT_INTERVAL = 60
APP_DOWNLOAD_URL = 'http://sh.hosapp.blz.netease.com/qrcode/download/wow'

ACTIVITY_BG_COUNT = 3
MAX_LOTTERY_COUNT = 8
LOTTERY_ORDER     = [[10101010102102021031203210432034105340251062345601234567]]

MAX_SUMMARY_LETTERS = 255
MAX_MEETINGSTONE_SUMMARY_LETTERS = 30
MIN_PLAYER_LEVEL    = 10

ACTIVITY_FILTER_BROWSE = 1
ACTIVITY_FILTER_CREATE = 2
ACTIVITY_FILTER_OTHER  = 3

FOLLOW_STATUS_UNKNOWN   = 0
FOLLOW_STATUS_STARED    = 1
FOLLOW_STATUS_FOLLOWER  = 2
FOLLOW_STATUS_FRIEND    = 3
FOLLOW_STATUS_THROTTLED = 4
FOLLOW_STATUS_MAX       = 5

DEFAULT_LOOT_LIST = {
    [4]              = 4,
    [7]              = 4,
    [8]              = 4,
    [9]              = 4,
    [10]             = 4,
    ['6-0-17-5']     = 4,
    ['6-0-17-0']     = 4,
    ['1-71-280-998'] = 3,
    ['1-71-280-999']  = 3,
}

DEFAULT_MODE_LIST = {
    [1]             = 9,
    ['1-124-419-0'] = 14,
    ['1-124-420-0'] = 14,
    ['1-124-421-0'] = 14,
    ['1-124-422-0'] = 14,
    ['1-124-423-0'] = 14,
    ['1-134-487-0'] = 14,
    ['1-134-488-0'] = 14,
    ['1-134-489-0'] = 14,
}

INVITE_STATUS_NAMES = {
    failed         = LFG_LIST_APP_CANCELLED,
    cancelled      = LFG_LIST_APP_CANCELLED,
    declined       = LFG_LIST_APP_DECLINED,
    timedout       = LFG_LIST_APP_TIMED_OUT,
    invited        = LFG_LIST_APP_INVITED,
    inviteaccepted = LFG_LIST_APP_INVITE_ACCEPTED,
    invitedeclined = LFG_LIST_APP_INVITE_DECLINED,
}

PROVING_GROUND_DATA = {
    {
        { id = 23690, text = LFG_LIST_PROVING_TANK_GOLD   },
        { id = 23687, text = LFG_LIST_PROVING_TANK_SILVER },
        { id = 23684, text = LFG_LIST_PROVING_TANK_BRONZE },
    },
    {
        { id = 23691, text = LFG_LIST_PROVING_HEALER_GOLD   },
        { id = 23688, text = LFG_LIST_PROVING_HEALER_SILVER },
        { id = 23685, text = LFG_LIST_PROVING_HEALER_BRONZE },
    },
    {
        { id = 23689, text = LFG_LIST_PROVING_DAMAGER_GOLD   },
        { id = 23686, text = LFG_LIST_PROVING_DAMAGER_SILVER },
        { id = 23683, text = LFG_LIST_PROVING_DAMAGER_BRONZE },
    },
}

-- last activity 491
-- last group 134

CATEGORY = {
    [0] = {
        groups = {
            [5]  = true,
            [18] = true,
            [19] = true,
            [30] = true,
            [31] = true,
        },
        activities = {
            [50]  = true,
            [52]  = true,
            [54]  = true,
            [55]  = true,
            [56]  = true,
            [57]  = true,
            [58]  = true,
            [59]  = true,
            [60]  = true,
            [61]  = true,
            [62]  = true,
            [63]  = true,
            [64]  = true,
            [65]  = true,
            [66]  = true,
            [9]   = true,
            [293] = true,
            [294] = true,
            [295] = true,
        },
    },
    [1] = {
        groups = {
            [20] = true,
            [21] = true,
            [22] = true,
            [23] = true,
            [24] = true,
            [25] = true,
            [26] = true,
            [27] = true,
            [28] = true,
            [29] = true,
            [32] = true,
            [33] = true,
            [34] = true,
            [35] = true,
            [36] = true,
            [37] = true,
        },
        activities = {
            [45]  = true,
            [296] = true,
            [297] = true,
            [298] = true,
            [299] = true,
            [300] = true,
            [301] = true,
        }
    },
    [2] = {
        groups = {
            [38] = true,
            [39] = true,
            [40] = true,
            [41] = true,
            [42] = true,
            [43] = true,
            [44] = true,
            [45] = true,
            [46] = true,
            [47] = true,
            [48] = true,
            [49] = true,
            [50] = true,
            [51] = true,
            [52] = true,
            [53] = true,
            [16] = true,
            [17] = true,
            [72] = true,
            [73] = true,
            [74] = true,
        },
        activities = {}
    },
    [3] = {
        groups = {
            [5]  = true,
            [19] = true,
            [54] = true,
            [55] = true,
            [56] = true,
            [57] = true,
            [58] = true,
            [59] = true,
            [60] = true,
            [75] = true,
            [76] = true,
            [77] = true,
            [78] = true,
            [79] = true,
        },
        activities = {
            [150] = true,
            [151] = true,
            [152] = true,
            [153] = true,
            [154] = true,
        }
    },
    [4] = {
        groups = {
            [18] = true,
            [30] = true,
            [31] = true,
            [61] = true,
            [62] = true,
            [63] = true,
            [64] = true,
            [65] = true,
            [66] = true,
            [84] = true,
            [1]  = true,
            [83] = true,
            [82] = true,
            [81] = true,
            [80] = true,
        },
        activities = {
            [397] = true,
        }
    },
    [5] = {
        groups = {
            [6]   = true,
            [7]   = true,
            [8]   = true,
            [9]   = true,
            [10]  = true,
            [11]  = true,
            [12]  = true,
            [13]  = true,
            [109] = true,
            [14]  = true,
            [15]  = true,
            [67]  = true,
            [110] = true,
        },
        activities = {
            [398] = true,
        }
    },
    [6] = {
        groups = {
            [111] = true,
            [112] = true,
            [113] = true,
            [114] = true,
            [115] = true,
            [116] = true,
            [117] = true,
            [118] = true,
            [119] = true,
            [120] = true,
            [121] = true,
            [122] = true,
            [123] = true,
            [124] = true,
            [125] = true,
            [126] = true,
            [127] = true,
            [128] = true,
            [129] = true,
            [130] = true,
            [131] = true,
            [132] = true,
            [133] = true,
        },
        activities = {
            [458] = true,
        },
    },
    [7] = {
        groups = {
            [136] = true,
            [137] = true,
            [138] = true,
            [139] = true,
            [140] = true,
            [141] = true,
            [142] = true,
            [143] = true,
            [144] = true,
            [145] = true,
            [146] = true,
            [147] = true,
        },
        activities = {}
    }
}

RAID_CLASS_COLORS = {}
CLASS_ICON_TCOORDS = {}
for i = 1, GetNumClasses() do
    local classLocale, class, id = GetClassInfo(i)

    RAID_CLASS_COLORS[id]          = _G.RAID_CLASS_COLORS[class]
    RAID_CLASS_COLORS[class]       = _G.RAID_CLASS_COLORS[class]
    RAID_CLASS_COLORS[classLocale] = _G.RAID_CLASS_COLORS[class]

    CLASS_ICON_TCOORDS[id]          = _G.CLASS_ICON_TCOORDS[class]
    CLASS_ICON_TCOORDS[class]       = _G.CLASS_ICON_TCOORDS[class]
    CLASS_ICON_TCOORDS[classLocale] = _G.CLASS_ICON_TCOORDS[class]
end

local defaultMeta = {__index = function(o) return rawget(o, 0xFF) end}

setmetatable(ACTIVITY_LOOT_NAMES, defaultMeta)
setmetatable(ACTIVITY_MODE_NAMES, defaultMeta)
setmetatable(ACTIVITY_LOOT_LONG_NAMES, defaultMeta)

MALL_CATEGORY_ICON_LIST = {
    [0] = {0, 0.25, 0, 0.5},
    [1] = {0.5, 0.75, 0.5, 1},
    [2] = {0.25, 0.5, 0.5, 1},
    [3] = {0, 0.25, 0.5, 1},
    [4] = {0.75, 1, 0, 0.5},
    [5] = {0.5, 0.75, 0, 0.5},
    [6] = {0.25, 0.5, 0, 0.5},
}

ACTIVITY_NAME_CACHE = setmetatable({}, {__index = function(t, k)
    if type(k) ~= 'number' then
        return
    end
    t[k] = C_LFGList.GetActivityInfo(k)
    return t[k]
end})

CUSTOM_PROGRESSION_LIST = {
}

RAID_PROGRESSION_LIST = {
    -- 7.0
    [482] = {
        { id = 11954, name = '加洛西灭世者' },
        { id = 11957, name = '萨格拉斯的恶犬' },
        { id = 11960, name = '安托兰统帅议会' },
        { id = 11963, name = '传送门守护者哈萨贝尔' },
        { id = 11966, name = '生命缚誓者艾欧娜尔' },
        { id = 11969, name = '猎魂者伊墨纳尔' },
        { id = 11972, name = '金加洛斯' },
        { id = 11975, name = '瓦里玛萨斯' },
        { id = 11978, name = '破坏魔女巫会' },
        { id = 11981, name = '阿格拉玛' },
        { id = 11984, name = '寂灭者阿古斯' },
    },  -- 安托鲁斯，燃烧王座（普通）
    [483] = {
        { id = 11955, name = '加洛西灭世者' },
        { id = 11958, name = '萨格拉斯的恶犬' },
        { id = 11961, name = '安托兰统帅议会' },
        { id = 11964, name = '传送门守护者哈萨贝尔' },
        { id = 11967, name = '生命缚誓者艾欧娜尔' },
        { id = 11970, name = '猎魂者伊墨纳尔' },
        { id = 11973, name = '金加洛斯' },
        { id = 11976, name = '瓦里玛萨斯' },
        { id = 11979, name = '破坏魔女巫会' },
        { id = 11982, name = '阿格拉玛' },
        { id = 11985, name = '寂灭者阿古斯' },
    },  -- 安托鲁斯，燃烧王座（英雄）
    [493] = {
        { id = 11956, name = '加洛西灭世者' },
        { id = 11959, name = '萨格拉斯的恶犬' },
        { id = 11962, name = '安托兰统帅议会' },
        { id = 11965, name = '传送门守护者哈萨贝尔' },
        { id = 11968, name = '生命缚誓者艾欧娜尔' },
        { id = 11971, name = '猎魂者伊墨纳尔' },
        { id = 11974, name = '金加洛斯' },
        { id = 11977, name = '瓦里玛萨斯' },
        { id = 11980, name = '破坏魔女巫会' },
        { id = 11983, name = '阿格拉玛' },
        { id = 11986, name = '寂灭者阿古斯' },
    },  -- 安托鲁斯，燃烧王座（史诗）
    [479] = {
        { id = 11878, name = '格罗斯' },
        { id = 11882, name = '恶魔审判庭' },
        { id = 11886, name = '哈亚坦' },
        { id = 11890, name = '月之姐妹' },
        { id = 11894, name = '主母萨丝琳' },
        { id = 11898, name = '绝望的聚合体' },
        { id = 11902, name = '戒卫侍女' },
        { id = 11906, name = '堕落的化身' },
        { id = 11910, name = '基尔加丹' },
    },  -- 萨格拉斯之墓（普通）
    [478] = {
        { id = 11879, name = '格罗斯' },
        { id = 11883, name = '恶魔审判庭' },
        { id = 11887, name = '哈亚坦' },
        { id = 11891, name = '月之姐妹' },
        { id = 11895, name = '主母萨丝琳' },
        { id = 11899, name = '绝望的聚合体' },
        { id = 11903, name = '戒卫侍女' },
        { id = 11907, name = '堕落的化身' },
        { id = 11911, name = '基尔加丹' },
    },  -- 萨格拉斯之墓（英雄）
    [492] = {
        { id = 11880, name = '格罗斯' },
        { id = 11884, name = '恶魔审判庭' },
        { id = 11888, name = '哈亚坦' },
        { id = 11892, name = '月之姐妹' },
        { id = 11896, name = '主母萨丝琳' },
        { id = 11900, name = '绝望的聚合体' },
        { id = 11904, name = '戒卫侍女' },
        { id = 11908, name = '堕落的化身' },
        { id = 11912, name = '基尔加丹' },
    },  -- 萨格拉斯之墓（史诗）
    [456] = {
        { id = 11408, name = '奥丁' },
        { id = 11412, name = '高姆' },
        { id = 11416, name = '海拉' },
    },  -- 勇气试炼（普通）
    [457] = {
        { id = 11409, name = '奥丁' },
        { id = 11413, name = '高姆' },
        { id = 11417, name = '海拉' },
    },  -- 勇气试炼（英雄）
    [480] = {
        { id = 11410, name = '奥丁' },
        { id = 11414, name = '高姆' },
        { id = 11418, name = '海拉' },
    },  -- 勇气试练（史诗）
    [413] = {
        { id = 10912, name = '尼珊德拉' },
        { id = 10921, name = '艾乐瑞瑟·雷弗拉尔' },
        { id = 10925, name = '伊格诺斯，腐蚀之心' },
        { id = 10916, name = '乌索克' },
        { id = 10929, name = '梦魇之龙' },
        { id = 10933, name = '塞纳留斯' },
        { id = 10937, name = '萨维斯' },
    },  -- 翡翠梦魇（普通）
    [414] = {
        { id = 10913, name = '尼珊德拉' },
        { id = 10922, name = '艾乐瑞瑟·雷弗拉尔' },
        { id = 10926, name = '伊格诺斯，腐蚀之心' },
        { id = 10917, name = '乌索克' },
        { id = 10930, name = '梦魇之龙' },
        { id = 10934, name = '塞纳留斯' },
        { id = 10938, name = '萨维斯' },
    },  -- 翡翠梦魇（英雄）
    [468] = {
        { id = 10914, name = '尼珊德拉' },
        { id = 10923, name = '艾乐瑞瑟·雷弗拉尔' },
        { id = 10927, name = '伊格诺斯，腐蚀之心' },
        { id = 10919, name = '乌索克' },
        { id = 10931, name = '梦魇之龙' },
        { id = 10935, name = '塞纳留斯' },
        { id = 10939, name = '萨维斯' },
    },  -- 翡翠梦魇（史诗）
    [415] = {
        { id = 10941, name = '斯考匹隆' },
        { id = 10945, name = '时空畸体' },
        { id = 10949, name = '崔利艾克斯' },
        { id = 10953, name = '魔剑士奥鲁瑞尔' },
        { id = 10957, name = '占星师艾塔乌斯' },
        { id = 10962, name = '高级植物学家特尔安' },
        { id = 10966, name = '提克迪奥斯' },
        { id = 10970, name = '克洛苏斯' },
        { id = 10974, name = '大魔导师艾利桑德' },
        { id = 10978, name = '古尔丹' },
    },  -- 暗夜要塞（普通）
    [416] = {
        { id = 10942, name = '斯考匹隆' },
        { id = 10946, name = '时空畸体' },
        { id = 10950, name = '崔利艾克斯' },
        { id = 10954, name = '魔剑士奥鲁瑞尔' },
        { id = 10959, name = '占星师艾塔乌斯' },
        { id = 10963, name = '高级植物学家特尔安' },
        { id = 10967, name = '提克迪奥斯' },
        { id = 10971, name = '克洛苏斯' },
        { id = 10975, name = '大魔导师艾利桑德' },
        { id = 10979, name = '古尔丹' },
    },  -- 暗夜要塞（英雄）
    [481] = {
        { id = 10943, name = '斯考匹隆' },
        { id = 10947, name = '时空畸体' },
        { id = 10951, name = '崔利艾克斯' },
        { id = 10955, name = '魔剑士奥鲁瑞尔' },
        { id = 10960, name = '占星师艾塔乌斯' },
        { id = 10964, name = '高级植物学家特尔安' },
        { id = 10968, name = '提克迪奥斯' },
        { id = 10972, name = '克洛苏斯' },
        { id = 10976, name = '大魔导师艾利桑德' },
        { id = 10980, name = '古尔丹' },
    },  -- 暗夜要塞（史诗）
    -- WOD
    [412] = {
        { id = 10204, name = '奇袭地狱火' },
        { id = 10208, name = '钢铁掠夺者' },
        { id = 10212, name = '考莫克' },
        { id = 10216, name = '高阶地狱火议会' },
        { id = 10220, name = '基尔罗格·死眼' },
        { id = 10224, name = '血魔' },
        { id = 10228, name = '暗影领主艾斯卡' },
        { id = 10232, name = '永恒者索克雷萨' },
        { id = 10236, name = '邪能领主扎昆' },
        { id = 10240, name = '祖霍拉克' },
        { id = 10244, name = '暴君维哈里' },
        { id = 10248, name = '玛诺洛斯' },
        { id = 10252, name = '阿克蒙德' },
    },  -- 地狱火堡垒（史诗）
    [409] = {
        { id = 10202, name = '奇袭地狱火' },
        { id = 10206, name = '钢铁掠夺者' },
        { id = 10210, name = '考莫克' },
        { id = 10214, name = '高阶地狱火议会' },
        { id = 10218, name = '基尔罗格·死眼' },
        { id = 10222, name = '血魔' },
        { id = 10226, name = '暗影领主艾斯卡' },
        { id = 10230, name = '永恒者索克雷萨' },
        { id = 10234, name = '邪能领主扎昆' },
        { id = 10238, name = '祖霍拉克' },
        { id = 10242, name = '暴君维哈里' },
        { id = 10246, name = '玛诺洛斯' },
        { id = 10250, name = '阿克蒙德' },
    },  -- 地狱火堡垒（普通）
    [410] = {
        { id = 10203, name = '奇袭地狱火' },
        { id = 10207, name = '钢铁掠夺者' },
        { id = 10211, name = '考莫克' },
        { id = 10215, name = '高阶地狱火议会' },
        { id = 10219, name = '基尔罗格·死眼' },
        { id = 10223, name = '血魔' },
        { id = 10227, name = '暗影领主艾斯卡' },
        { id = 10231, name = '永恒者索克雷萨' },
        { id = 10235, name = '邪能领主扎昆' },
        { id = 10239, name = '祖霍拉克' },
        { id = 10243, name = '暴君维哈里' },
        { id = 10247, name = '玛诺洛斯' },
        { id = 10251, name = '阿克蒙德' },
    },  -- 地狱火堡垒（英雄）
    [037] = {
        { id = 9282, name = '卡加斯·刃拳' },
        { id = 9287, name = '屠夫' },
        { id = 9297, name = '布兰肯斯波' },
        { id = 9292, name = '泰克图斯，活体之山' },
        { id = 9302, name = '独眼魔双子' },
        { id = 9308, name = '克拉戈' },
        { id = 9313, name = '元首马尔高克' },
    },  --  悬槌堡（普通）
    [038] = {
        { id = 9284, name = '卡加斯·刃拳' },
        { id = 9288, name = '屠夫' },
        { id = 9298, name = '布兰肯斯波' },
        { id = 9293, name = '泰克图斯，活体之山' },
        { id = 9303, name = '独眼魔双子' },
        { id = 9310, name = '克拉戈' },
        { id = 9314, name = '元首马尔高克' },
    },  --  悬槌堡（英雄）
    [399] = {
        { id = 9285, name = '卡加斯·刃拳' },
        { id = 9289, name = '屠夫' },
        { id = 9300, name = '布兰肯斯波' },
        { id = 9294, name = '泰克图斯，活体之山' },
        { id = 9304, name = '独眼魔双子' },
        { id = 9311, name = '克拉戈' },
        { id = 9315, name = '元首马尔高克' },
    },  -- 悬槌堡（史诗）
    [039] = {
        { id = 9317, name = '格鲁尔', },
        { id = 9321, name = '吞噬者奥尔高格' },
        { id = 9336, name = '兽王达玛克' },
        { id = 9331, name = '缚火者卡格拉兹' },
        { id = 9327, name = '汉斯加尔与弗兰佐克' },
        { id = 9340, name = '主管索戈尔' },
        { id = 9349, name = '爆裂熔炉' },
        { id = 9355, name = '克罗莫格，远山传奇' },
        { id = 9359, name = '钢铁女武神' },
        { id = 9363, name = '黑手' },
    },  --  黑石铸造厂（普通）
    [040] = {
        { id = 9318, name = '格鲁尔' },
        { id = 9322, name = '吞噬者奥尔高格' },
        { id = 9337, name = '兽王达玛克' },
        { id = 9332, name = '缚火者卡格拉兹' },
        { id = 9328, name = '汉斯加尔与弗兰佐克' },
        { id = 9341, name = '主管索戈尔' },
        { id = 9351, name = '爆裂熔炉' },
        { id = 9356, name = '克罗莫格，远山传奇' },
        { id = 9360, name = '钢铁女武神' },
        { id = 9364, name = '黑手' },
    },  --  黑石铸造厂（英雄）
    [400] = {
        { id = 9319, name = '格鲁尔' },
        { id = 9323, name = '吞噬者奥尔高格' },
        { id = 9338, name = '兽王达玛克' },
        { id = 9333, name = '缚火者卡格拉兹' },
        { id = 9329, name = '汉斯加尔与弗兰佐克' },
        { id = 9342, name = '主管索戈尔' },
        { id = 9353, name = '爆裂熔炉' },
        { id = 9357, name = '克罗莫格，远山传奇' },
        { id = 9361, name = '钢铁女武神' },
        { id = 9365, name = '黑手' },
    },  -- 黑石铸造厂（史诗）

    -- MOP
    [004] = {
        { id = 8550, name = '伊墨苏斯' },
        { id = 8556, name = '堕落的守护者' },
        { id = 8562, name = '诺鲁什' },
        { id = 8568, name = '傲之煞' },
        { id = 8575, name = '迦拉卡斯' },
        { id = 8581, name = '钢铁战蝎' },
        { id = 8587, name = '库卡隆黑暗萨满' },
        { id = 8594, name = '纳兹戈林将军' },
        { id = 8600, name = '马尔考罗克' },
        { id = 8606, name = '潘达利亚战利品' },
        { id = 8615, name = '嗜血的索克' },
        { id = 8621, name = '攻城匠师黑索' },
        { id = 8627, name = '卡拉克西英杰' },
        { id = 8634, name = '加尔鲁什·地狱咆哮' },
    },  --  决战奥格瑞玛（普通难度）
    [041] = {
        { id = 8551, id2 = 8552, name = '伊墨苏斯' },
        { id = 8557, id2 = 8558, name = '堕落的守护者' },
        { id = 8563, id2 = 8564, name = '诺鲁什' },
        { id = 8569, id2 = 8570, name = '傲之煞' },
        { id = 8576, id2 = 8577, name = '迦拉卡斯' },
        { id = 8582, id2 = 8583, name = '钢铁战蝎' },
        { id = 8588, id2 = 8589, name = '库卡隆黑暗萨满' },
        { id = 8595, id2 = 8596, name = '纳兹戈林将军' },
        { id = 8601, id2 = 8602, name = '马尔考罗克' },
        { id = 8608, id2 = 8609, name = '潘达利亚战利品' },
        { id = 8616, id2 = 8617, name = '嗜血的索克' },
        { id = 8622, id2 = 8623, name = '攻城匠师黑索' },
        { id = 8628, id2 = 8629, name = '卡拉克西英杰' },
        { id = 8635, id2 = 8636, name = '加尔鲁什·地狱咆哮' },
    },  --  决战奥格瑞玛（英雄）
    [042] = {
        { id = 8553, id2 = 8554, name = '伊墨苏斯' },
        { id = 8559, id2 = 8560, name = '堕落的守护者' },
        { id = 8565, id2 = 8566, name = '诺鲁什' },
        { id = 8571, id2 = 8573, name = '傲之煞' },
        { id = 8578, id2 = 8579, name = '迦拉卡斯' },
        { id = 8584, id2 = 8585, name = '钢铁战蝎' },
        { id = 8590, id2 = 8591, name = '库卡隆黑暗萨满' },
        { id = 8597, id2 = 8598, name = '纳兹戈林将军' },
        { id = 8603, id2 = 8604, name = '马尔考罗克' },
        { id = 8610, id2 = 8612, name = '潘达利亚战利品' },
        { id = 8618, id2 = 8619, name = '嗜血的索克' },
        { id = 8624, id2 = 8625, name = '攻城匠师黑索' },
        { id = 8630, id2 = 8631, name = '卡拉克西英杰' },
        { id = 8637, id2 = 8638, name = '加尔鲁什·地狱咆哮' },
    },  --  决战奥格瑞玛（史诗）
    [347] = {
        { id = 8142, name = '击碎者金罗克' },
        { id = 8149, name = '赫利东' },
        { id = 8154, name = '长者议会' },
        { id = 8159, name = '托多斯' },
        { id = 8164, name = '墨格瑞拉' },
        { id = 8169, name = '季鹍' },
        { id = 8174, name = '遗忘者杜鲁姆' },
        { id = 8179, name = '普利莫修斯' },
        { id = 8184, name = '黑暗意志' },
        { id = 8189, name = '铁穹' },
        { id = 8194, name = '魔古双后' },
        { id = 8199, name = '雷神' },
    },  --  雷电王座（10人普通）
    [348] = {
        { id = 8144, name = '击碎者金罗克' },
        { id = 8151, name = '赫利东' },
        { id = 8156, name = '长者议会' },
        { id = 8162, name = '托多斯' },
        { id = 8166, name = '墨格瑞拉' },
        { id = 8171, name = '季鹍' },
        { id = 8176, name = '遗忘者杜鲁姆' },
        { id = 8181, name = '普利莫修斯' },
        { id = 8186, name = '黑暗意志' },
        { id = 8191, name = '铁穹' },
        { id = 8196, name = '魔古双后' },
        { id = 8202, name = '雷神' },
        { id = 8203, name = '莱登' },
    },  --  雷电王座（10人英雄）
    [349] = {
        { id = 8145, name = '击碎者金罗克' },
        { id = 8152, name = '赫利东' },
        { id = 8157, name = '长者议会' },
        { id = 8161, name = '托多斯' },
        { id = 8167, name = '墨格瑞拉' },
        { id = 8172, name = '季鹍' },
        { id = 8177, name = '遗忘者杜鲁姆' },
        { id = 8180, name = '普利莫修斯' },
        { id = 8187, name = '黑暗意志' },
        { id = 8192, name = '铁穹' },
        { id = 8197, name = '魔古双后' },
        { id = 8201, name = '雷神' },
        { id = 8256, name = '莱登' },
    },  --  雷电王座（25人英雄）
    [350] = {
        { id = 8143, name = '击碎者金罗克' },
        { id = 8150, name = '赫利东' },
        { id = 8155, name = '长者议会' },
        { id = 8160, name = '托多斯' },
        { id = 8165, name = '墨格瑞拉' },
        { id = 8170, name = '季鹍' },
        { id = 8175, name = '遗忘者杜鲁姆' },
        { id = 8182, name = '普利莫修斯' },
        { id = 8185, name = '黑暗意志' },
        { id = 8190, name = '铁穹' },
        { id = 8195, name = '魔古双后' },
        { id = 8200, name = '雷神' },
    },  --  雷电王座（25人普通）
    [343] = {
        { id = 6813, name = '无尽守护者' },
        { id = 6815, name = '烛龙' },
        { id = 6817, name = '雷施' },
        { id = 6819, name = '惧之煞' },
    },  --  永春台（10人普通）
    [344] = {
        { id = 6814, name = '无尽守护者' },
        { id = 6816, name = '烛龙' },
        { id = 6818, name = '雷施' },
        { id = 6820, name = '惧之煞' },
    },  --  永春台（10人英雄）
    [345] = {
        { id = 7965, name = '无尽守护者' },
        { id = 7967, name = '烛龙' },
        { id = 7969, name = '雷施' },
        { id = 7971, name = '惧之煞' },
    },  --  永春台（25人普通）
    [346] = {
        { id = 7966, name = '无尽守护者' },
        { id = 7968, name = '烛龙' },
        { id = 7970, name = '雷施' },
        { id = 7972, name = '惧之煞' },
    },  --  永春台（25人英雄）
    [339] = {
        { id = 6801, name = '皇家宰相佐尔洛克' },
        { id = 6803, name = '刀锋领主塔亚克' },
        { id = 6805, name = '加拉隆' },
        { id = 6807, name = '风领主梅尔加拉克' },
        { id = 6809, name = '琥珀塑形者昂舒克' },
        { id = 6811, name = '大女皇夏柯希尔' },
    },  --  恐惧之心（10人普通）
    [340] = {
        { id = 6802, name = '皇家宰相佐尔洛克' },
        { id = 6804, name = '刀锋领主塔亚克' },
        { id = 6806, name = '加拉隆' },
        { id = 6808, name = '风领主梅尔加拉克' },
        { id = 6810, name = '琥珀塑形者昂舒克' },
        { id = 6812, name = '大女皇夏柯希尔' },
    },  --  恐惧之心（10人英雄）
    [341] = {
        { id = 7951, name = '皇家宰相佐尔洛克' },
        { id = 7954, name = '刀锋领主塔亚克' },
        { id = 7956, name = '加拉隆' },
        { id = 7958, name = '风领主梅尔加拉克' },
        { id = 7961, name = '琥珀塑形者昂舒克' },
        { id = 7963, name = '大女皇夏柯希尔' },
    },  --  恐惧之心（25人普通）
    [342] = {
        { id = 7953, name = '皇家宰相佐尔洛克' },
        { id = 7955, name = '刀锋领主塔亚克' },
        { id = 7957, name = '加拉隆' },
        { id = 7960, name = '风领主梅尔加拉克' },
        { id = 7962, name = '琥珀塑形者昂舒克' },
        { id = 7964, name = '大女皇夏柯希尔' },
    },  --  恐惧之心（25人英雄）
    [335] = {
        { id = 6789, name = '石头守卫' },
        { id = 6791, name = '受诅者魔封' },
        { id = 6793, name = '缚灵者戈拉亚' },
        { id = 6795, name = '先王之魂' },
        { id = 6797, name = '伊拉贡' },
        { id = 6799, name = '皇帝的意志' },
    },  --  魔古山宝库（10人普通）
    [336] = {
        { id = 6790, name = '石头守卫' },
        { id = 6792, name = '受诅者魔封' },
        { id = 6794, name = '缚灵者戈拉亚' },
        { id = 6796, name = '先王之魂' },
        { id = 6798, name = '伊拉贡' },
        { id = 6800, name = '皇帝的意志' },
    },  --  魔古山宝库（10人英雄）
    [337] = {
        { id = 7914, name = '石头守卫' },
        { id = 7917, name = '受诅者魔封' },
        { id = 7919, name = '缚灵者戈拉亚' },
        { id = 7921, name = '先王之魂' },
        { id = 7923, name = '伊拉贡' },
        { id = 7926, name = '皇帝的意志' },
    },  --  魔古山宝库（25人普通）
    [338] = {
        { id = 7915, name = '石头守卫' },
        { id = 7918, name = '受诅者魔封' },
        { id = 7920, name = '缚灵者戈拉亚' },
        { id = 7922, name = '先王之魂' },
        { id = 7924, name = '伊拉贡' },
        { id = 7927, name = '皇帝的意志' },
    },  --  魔古山宝库（25人英雄）
}

DEFAULT_SPAMWORD = [[
!%d+元
!tao.*bao
!支.*付.*宝
!淘.*宝
5173
急速低价
!手.*工
!马.*云
gzs
!必.*出
!必.*掉
橙装包
!歪.*歪
!电.*话
!代.*刷
!带.*刷
!带.*打
!代.*打
100-110
1-100
!手.*动
!手.*工
!支.*持
!加.*q
!账.*号
!g.*团
!老.*板
!消.*费
!顾.*客
xiao
fei
xf
!亻.*立
!灵.*魂.*兽
猎人跨服
LR跨服
!%d+元
5173
bug幽灵虎
bug黑市
!tao.*bao
!w.*信
!微.*信
!支.*付.*宝
!淘.*宝
112233
111111
333333
咨询
!^接.*
认准
平台
门票
LFG:
]]

ZONE_ACTIVITY_MAP = {
    -- [1014] = true,  -- 达拉然
    [1033] = '1-124-423-0',  -- 苏拉玛
    [1017] = '1-124-422-0',  -- 风暴峡湾
    [1024] = '1-124-421-0',  -- 至高岭
    [1018] = '1-124-420-0',  -- 瓦尔莎拉
    [1015] = '1-124-419-0',  -- 阿苏纳
    [1021] = '1-124-469-0',  -- 破碎海滩
    [1170] = '1-134-489-0',  -- 玛凯雷
    [1135] = '1-134-487-0',  -- 克罗库恩
    [1171] = '1-134-488-0',  -- 安托兰废土
    [1096] = '1-124-469-0',  -- 艾萨拉之眼
}

CATEGORY_BASEFILTERS = {
    [1]  = LE_LFG_LIST_FILTER_PVE,
    [2]  = LE_LFG_LIST_FILTER_PVE,
    [3]  = LE_LFG_LIST_FILTER_PVE,
    [4]  = LE_LFG_LIST_FILTER_PVP,
    [5]  = LE_LFG_LIST_FILTER_PVE,
    [6]  = LE_LFG_LIST_FILTER_PVE,
    [7]  = LE_LFG_LIST_FILTER_PVP,
    [8]  = LE_LFG_LIST_FILTER_PVP,
    [9]  = LE_LFG_LIST_FILTER_PVP,
    [10] = LE_LFG_LIST_FILTER_PVP,
}
