--[[
-- File: RaidDebuffs_TBC.lua
-- Author: enderneko (enderneko-dev@outlook.com)
-- File Created: 2022/08/05 17:45:05 +0800
-- Last Modified: 2022/08/05 17:45:49 +0800
--]]

local _, Cell = ...
local F = Cell.funcs

local debuffs = {
    [745] = { -- 卡拉赞
        ["general"] = {
        },
        [1552] = { -- 仆役宿舍
        },
        [1553] = { -- 猎手阿图门
        },
        [1554] = { -- 莫罗斯
        },
        [1555] = { -- 贞节圣女
        },
        [1556] = { -- 歌剧院
        },
        [1557] = { -- 馆长
        },
        [1559] = { -- 埃兰之影
        },
        [1560] = { -- 特雷斯坦·邪蹄
        },
        [1561] = { -- 虚空幽龙
        },
        [1764] = { -- 国际象棋
        },
        [1563] = { -- 玛克扎尔王子
        },
    },

    [746] = { -- 格鲁尔的巢穴
        ["general"] = {
        },
        [1564] = { -- 莫加尔大王
        },
        [1565] = { -- 屠龙者格鲁尔
        },
    },

    [747] = { -- 玛瑟里顿的巢穴
        ["general"] = {
        },
        [1566] = { -- 玛瑟里顿
        },
    },

    [748] = { -- 毒蛇神殿
        ["general"] = {
        },
        [1567] = { -- 不稳定的海度斯
        },
        [1568] = { -- 鱼斯拉
        },
        [1569] = { -- 盲眼者莱欧瑟拉斯
        },
        [1570] = { -- 深水领主卡拉瑟雷斯
        },
        [1571] = { -- 莫洛格里·踏潮者
        },
        [1572] = { -- 瓦丝琪
        },
    },

    [749] = { -- 风暴要塞
        ["general"] = {
        },
        [1573] = { -- 奥
        },
        [1574] = { -- 空灵机甲
        },
        [1575] = { -- 大星术师索兰莉安
        },
        [1576] = { -- 凯尔萨斯·逐日者
        },
    },

    [750] = { -- 海加尔山之战
        ["general"] = {
        },
        [1577] = { -- 雷基·冬寒
        },
        [1578] = { -- 安纳塞隆
        },
        [1579] = { -- 卡兹洛加
        },
        [1580] = { -- 阿兹加洛
        },
        [1581] = { -- 阿克蒙德
        },
    },

    [751] = { -- 黑暗神殿
        ["general"] = {
        },
        [1582] = { -- 高阶督军纳因图斯
        },
        [1583] = { -- 苏普雷姆斯
        },
        [1584] = { -- 阿卡玛之影
        },
        [1585] = { -- 塔隆·血魔
        },
        [1586] = { -- 古尔图格·血沸
        },
        [1587] = { -- 灵魂之匣
        },
        [1588] = { -- 莎赫拉丝主母
        },
        [1589] = { -- 伊利达雷议会
        },
        [1590] = { -- 伊利丹·怒风
        },
    },

    [752] = { -- 太阳之井高地
        ["general"] = {
        },
        [1591] = { -- 卡雷苟斯
        },
        [1592] = { -- 布鲁塔卢斯
        },
        [1593] = { -- 菲米丝
        },
        [1594] = { -- 艾瑞达双子
        },
        [1595] = { -- 穆鲁
        },
        [1596] = { -- 基尔加丹
        },
    },

    [248] = { -- 地狱火城墙
        ["general"] = {
        },
        [527] = { -- 巡视者加戈玛
        },
        [528] = { -- 无疤者奥摩尔
        },
        [529] = { -- 传令官瓦兹德
        },
    },

    [252] = { -- 塞泰克大厅
        ["general"] = {
        },
        [541] = { -- 黑暗编织者塞斯
        },
        [543] = { -- 利爪之王艾吉斯
        },
    },

    [247] = { -- 奥金尼地穴
        ["general"] = {
        },
        [523] = { -- 死亡观察者希尔拉克
        },
        [524] = { -- 大主教玛拉达尔
        },
    },

    [260] = { -- 奴隶围栏
        ["general"] = {
        },
        [570] = { -- 背叛者门努
        },
        [571] = { -- 巨钳鲁克玛尔
        },
        [572] = { -- 夸格米拉
        },
    },

    [262] = { -- 幽暗沼泽
        ["general"] = {
        },
        [576] = { -- 霍加尔芬
        },
        [577] = { -- 加兹安
        },
        [578] = { -- 沼地领主穆塞雷克
        },
        [579] = { -- 黑色阔步者
        },
    },

    [251] = { -- 旧希尔斯布莱德丘陵
        ["general"] = {
        },
        [538] = { -- 德拉克中尉
        },
        [539] = { -- 斯卡洛克上尉
        },
        [540] = { -- 时空猎手
        },
    },

    [253] = { -- 暗影迷宫
        ["general"] = {
        },
        [544] = { -- 赫尔默大使
        },
        [545] = { -- 煽动者布莱卡特
        },
        [546] = { -- 沃匹尔大师
        },
        [547] = { -- 摩摩尔
        },
    },

    [250] = { -- 法力陵墓
        ["general"] = {
        },
        [534] = { -- 潘德莫努斯
        },
        [535] = { -- 塔瓦洛克
        },
        [537] = { -- 节点亲王沙法尔
        },
    },

    [257] = { -- 生态船
        ["general"] = {
        },
        [558] = { -- 指挥官萨拉妮丝
        },
        [559] = { -- 高级植物学家弗雷温
        },
        [560] = { -- 看管者索恩格林
        },
        [561] = { -- 拉伊
        },
        [562] = { -- 迁跃扭木
        },
    },

    [259] = { -- 破碎大厅
        ["general"] = {
        },
        [566] = { -- 高阶术士奈瑟库斯
        },
        [568] = { -- 战争使者沃姆罗格
        },
        [569] = { -- 酋长卡加斯·刃拳
        },
    },

    [254] = { -- 禁魔监狱
        ["general"] = {
        },
        [548] = { -- 自由的瑟雷凯斯
        },
        [549] = { -- 末日预言者达尔莉安
        },
        [550] = { -- 天怒预言者苏克拉底
        },
        [551] = { -- 预言者斯克瑞斯
        },
    },

    [258] = { -- 能源舰
        ["general"] = {
        },
        [563] = { -- 机械领主卡帕西图斯
        },
        [564] = { -- 灵术师塞比瑟蕾
        },
        [565] = { -- 计算者帕萨雷恩
        },
    },

    [261] = { -- 蒸汽地窟
        ["general"] = {
        },
        [573] = { -- 水术师瑟丝比娅
        },
        [574] = { -- 机械师斯蒂里格
        },
        [575] = { -- 督军卡利瑟里斯
        },
    },

    [249] = { -- 魔导师平台
        ["general"] = {
        },
        [530] = { -- 塞林·火心
        },
        [531] = { -- 维萨鲁斯
        },
        [532] = { -- 女祭司德莉希亚
        },
        [533] = { -- 凯尔萨斯·逐日者
        },
    },

    [256] = { -- 鲜血熔炉
        ["general"] = {
        },
        [555] = { -- 制造者
        },
        [556] = { -- 布洛戈克
        },
        [557] = { -- 击碎者克里丹
        },
    },

    [255] = { -- 黑色沼泽
        ["general"] = {
        },
        [552] = { -- 时空领主德亚
        },
        [553] = { -- 坦普卢斯
        },
        [554] = { -- 埃欧努斯
        },
    },
}

F:LoadBuiltInDebuffs(debuffs)