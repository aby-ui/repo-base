--[[
-- File: RaidDebuffs_MoP.lua
-- Author: enderneko (enderneko-dev@outlook.com)
-- File Created: 2022/08/05 16:10:47 +0800
-- Last Modified: 2022/12/12 06:33:13 +0800
--]]

local _, Cell = ...
local F = Cell.funcs

local debuffs = {
    [322] = { -- 潘达利亚
        [691] = { -- 怒之煞
        },
        [725] = { -- 萨莱斯的兵团
        },
        [814] = { -- 暴风领主纳拉克
        },
        [826] = { -- 乌达斯塔
        },
        [857] = { -- 朱鹤赤精
        },
        [858] = { -- 青龙玉珑
        },
        [859] = { -- 玄牛砮皂
        },
        [860] = { -- 白虎雪怒
        },
        [861] = { -- 野牛人火神斡耳朵斯
        },
    },

    [317] = { -- 魔古山宝库
        ["general"] = {
        },
        [679] = { -- 石头守卫
        },
        [689] = { -- 受诅者魔封
        },
        [682] = { -- 缚灵者戈拉亚
        },
        [687] = { -- 先王之魂
        },
        [726] = { -- 伊拉贡
        },
        [677] = { -- 皇帝的意志
        },
    },

    [330] = { -- 恐惧之心
        ["general"] = {
        },
        [745] = { -- 皇家宰相佐尔洛克
        },
        [744] = { -- 刀锋领主塔亚克
        },
        [713] = { -- 加拉隆
        },
        [741] = { -- 风领主梅尔加拉克
        },
        [737] = { -- 琥珀塑形者昂舒克
        },
        [743] = { -- 大女皇夏柯希尔
        },
    },

    [320] = { -- 永春台
        ["general"] = {
        },
        [683] = { -- 无尽守护者
        },
        [742] = { -- 烛龙
        },
        [729] = { -- 雷施
        },
        [709] = { -- 惧之煞
        },
    },

    [362] = { -- 雷电王座
        ["general"] = {
        },
        [827] = { -- 击碎者金罗克
        },
        [819] = { -- 赫利东
        },
        [816] = { -- 长者议会
        },
        [825] = { -- 托多斯
        },
        [821] = { -- 墨格瑞拉
        },
        [828] = { -- 季鹍
        },
        [818] = { -- 遗忘者杜鲁姆
        },
        [820] = { -- 普利莫修斯
        },
        [824] = { -- 黑暗意志
        },
        [817] = { -- 铁穹
        },
        [829] = { -- 神女双天
        },
        [832] = { -- 雷神
        },
    },

    [369] = { -- 决战奥格瑞玛
        ["general"] = {
        },
        [852] = { -- 伊墨苏斯
        },
        [849] = { -- 堕落的守护者
        },
        [866] = { -- 诺鲁什
        },
        [867] = { -- 傲之煞
        },
        [868] = { -- 迦拉卡斯
        },
        [864] = { -- 钢铁战蝎
        },
        [856] = { -- 库卡隆黑暗萨满
        },
        [850] = { -- 纳兹戈林将军
        },
        [846] = { -- 马尔考罗克
        },
        [870] = { -- 潘达利亚战利品
        },
        [851] = { -- 嗜血的索克
        },
        [865] = { -- 攻城匠师黑索
        },
        [853] = { -- 卡拉克西英杰
        },
        [869] = { -- 加尔鲁什·地狱咆哮
        },
    },

    [324] = { -- 围攻砮皂寺
        ["general"] = {
        },
        [693] = { -- 宰相金巴卡
        },
        [738] = { -- 指挥官沃加克
        },
        [692] = { -- 将军帕瓦拉克
        },
        [727] = { -- 翼虫首领尼诺洛克
        },
    },

    [312] = { -- 影踪禅院
        ["general"] = {
        },
        [673] = { -- 古·穿云
        },
        [657] = { -- 雪流大师
        },
        [685] = { -- 狂之煞
        },
        [686] = { -- 祝踏岚
        },
    },

    [303] = { -- 残阳关
        ["general"] = {
        },
        [655] = { -- 破坏者吉普提拉克
        },
        [675] = { -- 突袭者加杜卡
        },
        [676] = { -- 指挥官瑞魔克
        },
        [649] = { -- 莱公
        },
    },

    [316] = { -- 血色修道院
        ["general"] = {
        },
        [688] = { -- 裂魂者萨尔诺斯
        },
        [671] = { -- 科洛夫修士
        },
        [674] = { -- 大检察官怀特迈恩
        },
    },

    [311] = { -- 血色大厅
        ["general"] = {
        },
        [660] = { -- 驯犬者布兰恩
        },
        [654] = { -- 武器大师哈兰
        },
        [656] = { -- 织焰者孔格勒
        },
    },

    [246] = { -- 通灵学院
        ["general"] = {
        },
        [659] = { -- 指导者寒心
        },
        [663] = { -- 詹迪斯·巴罗夫
        },
        [665] = { -- 血骨傀儡
        },
        [666] = { -- 莉莉安·沃斯
        },
        [684] = { -- 黑暗院长加丁
        },
    },

    [313] = { -- 青龙寺
        ["general"] = {
            395872, -- 昏呆独白
            397899, -- 扫堂腿
            397911, -- 毁灭之触
            114803, -- 投掷火炬
            396093, -- 野蛮飞跃
            397914, -- 污染迷雾
            396003, -- 领地展示
            396019, -- 震荡打击
            397904, -- 残阳西沉踢
            110125, -- 粉碎决心
        },
        [672] = { -- 贤者马里
            397878, -- 腐化涟漪
            395829, -- 煞能残渣
        },
        [664] = { -- 游学者石步
            -396150, -- 优越感
            -396152, -- 自卑感
        },
        [658] = { -- 刘·焰心
            106823, -- 翔龙猛袭
            106841, -- 青龙猛袭
            107110, -- 玉火
            118540, -- 青龙泛波
        },
        [335] = { -- 疑之煞
            106113, -- 虚无之触
            106290, -- 自疑
        },
    },

    [302] = { -- 风暴烈酒酿造厂
        ["general"] = {
        },
        [668] = { -- 乌克乌克
        },
        [669] = { -- 跳跳大王
        },
        [670] = { -- 破桶而出的炎诛
        },
    },

    [321] = { -- 魔古山宫殿
        ["general"] = {
        },
        [708] = { -- 君王的试炼
        },
        [690] = { -- 杰翰
        },
        [698] = { -- 武器大师席恩
        },
    },
}

F:LoadBuiltInDebuffs(debuffs)