local _, Cell = ...
local L = Cell.L
local I = Cell.iFuncs
local F = Cell.funcs

-------------------------------------------------
-- debuffBlacklist
-------------------------------------------------
local debuffBlacklist = {
    8326, -- 鬼魂
    160029, -- 正在复活
    57723, -- 筋疲力尽
    57724, -- 心满意足
    80354, -- 时空错位
    264689, -- 疲倦
    206151, -- 挑战者的负担
    195776, -- 月羽疫病
    352562, -- 起伏机动
    356419, -- 审判灵魂
}

function I:GetDefaultDebuffBlacklist()
    -- local temp = {}
    -- for i, id in pairs(debuffBlacklist) do
    --     temp[i] = GetSpellInfo(id)
    -- end
    -- return temp
    return debuffBlacklist
end

-------------------------------------------------
-- bigDebuffs
-------------------------------------------------
local bigDebuffs = {
    240443, -- 爆裂
    209858, -- 死疽溃烂
    46392, -- 专注打击
    -----------------------------------------------
    -- NOTE: Shrouded Affix - Shadowlands Season 4
    373391, -- 梦魇
    373429, -- 腐臭虫群
    -----------------------------------------------
    -----------------------------------------------
    -- NOTE: Encrypted Affix - Shadowlands Season 3
    -- 尤型拆卸者
    -- 366297, -- 解构
    -- 366288, -- 猛力砸击
    -----------------------------------------------
    -----------------------------------------------
    -- NOTE: Tormented Affix - Shadowlands Season 2
    -- 焚化者阿寇拉斯
    -- 355732, -- 融化灵魂
    -- 355738, -- 灼热爆破
    -- 凇心之欧罗斯
    -- 356667, -- 刺骨之寒
    -- 刽子手瓦卢斯
    -- 356925, -- 屠戮
    -- 356923, -- 撕裂
    -- 358973, -- 恐惧浪潮
    -- 粉碎者索苟冬
    -- 355806, -- 重压
    -- 358777, -- 痛苦之链
    -----------------------------------------------
}

function I:GetDefaultBigDebuffs()
    return bigDebuffs
end

-------------------------------------------------
-- aoeHealings
-------------------------------------------------
local aoeHealings = {
    -- druid
    740, -- 宁静
    145205, -- 百花齐放
    -- TODO: 自然的守护

    -- monk
    115098, -- 真气波
    123986, -- 真气爆裂
    115310, -- 还魂术
    -- 191837, -- 精华之泉
    322118, -- 青龙下凡 (SUMMON)

    -- paladin
    85222, -- 黎明之光
    119952, -- 弧形圣光
    114165, -- 神圣棱镜
    -- TODO: 复仇十字军，提尔的拯救

    -- priest
    120517, -- 光晕
    34861, -- 圣言术：灵
    596, -- 治疗祷言
    64843, -- 神圣赞美诗
    110744, -- 神圣之星
    204883, -- 治疗之环
    281265, -- 神圣新星
    314867, -- 暗影盟约
    -- TODO: 光明之泉，神言，吸血鬼的拥抱

    -- shaman
    1064, -- 治疗链
    73920, -- 治疗之雨
    108280, -- 治疗之潮图腾 (SUMMON)
    52042, -- 治疗之泉图腾 (SUMMON)
    197995, -- 奔涌之流
    157503, -- 暴雨图腾
    -- TODO: 先祖指引，始源之潮，倾盆大雨，升腾
}

local aoeHealingIDs = {
    [343819] = true, -- 朱鹤下凡，朱鹤产生的“迷雾之风”的施法者是玩家
}

do
    local temp = {}
    for _, id in pairs(aoeHealings) do
        temp[GetSpellInfo(id)] = true
    end
    aoeHealings = temp
end

function I:IsAoEHealing(nameOrID)
    if not nameOrID then return false end
    return aoeHealings[nameOrID] or aoeHealingIDs[nameOrID]
end

local summonDuration = {
    -- monk
    [322118] = 25, -- 青龙下凡

    -- shaman
    [108280] = 12, -- 治疗之潮图腾
    [52042] = 15, -- 治疗之泉图腾
}

do
    local temp = {}
    for id, duration in pairs(summonDuration) do
        temp[GetSpellInfo(id)] = duration
    end
    summonDuration = temp
end

function I:GetSummonDuration(spellName)
    return summonDuration[spellName]
end

-------------------------------------------------
-- externalCooldowns
-------------------------------------------------
local externalCooldowns = {
    -- death knight
    51052, -- 反魔法领域

    -- demon hunter
    196718, -- 黑暗

    -- druid
    102342, -- 铁木树皮

    -- monk
    116849, -- 作茧缚命
    202248, -- 偏转冥想

    -- paladin
    1022, -- 保护祝福
    6940, -- 牺牲祝福
    204018, -- 破咒祝福
    31821, -- 光环掌握
    211210, -- 提尔的保护
    210256, -- 庇护祝福
    216328, -- 光之优雅

    -- priest
    33206, -- 痛苦压制
    47788, -- 守护之魂
    62618, -- 真言术：障
    213610, -- 神圣守卫
    197268, -- 希望之光

    -- shaman
    98008, -- 灵魂链接图腾
    201633, -- 大地之墙图腾
    8178, -- 根基图腾
    -- TODO: 石肤图腾

    -- warrior
    97462, -- 集结呐喊
    3411, -- 援护
    213871, -- 护卫
}

local externals = {}
for _, id in pairs(externalCooldowns) do
    externals[GetSpellInfo(id)] = true
end
externalCooldowns = F:Copy(externals)

function I:UpdateCustomExternals(t)
    -- reset
    externalCooldowns = F:Copy(externals)
    -- insert
    for _, id in pairs(t) do
        local name = GetSpellInfo(id)
        if name then
            externalCooldowns[name] = true
        end
    end
end

local UnitIsUnit = UnitIsUnit
local bos = GetSpellInfo(6940) -- 牺牲祝福
function I:IsExternalCooldown(name, source, target)
    if name == bos then
        if source and target then
            -- NOTE: hide bos on caster
            return not UnitIsUnit(source, target)
        else
            return true
        end
    else
        return externalCooldowns[name]
    end
end

-------------------------------------------------
-- defensiveCooldowns
-------------------------------------------------
local defensiveCooldowns = {
    -- death knight
    48707, -- 反魔法护罩
    48792, -- 冰封之韧
    49028, -- 符文刃舞
    55233, -- 吸血鬼之血

    -- demon hunter
    196555, -- 虚空行走
    198589, -- 疾影
    187827, -- 恶魔变形

    -- druid
    22812, -- 树皮术
    -- 22842, -- REVIEW:狂暴回复
    61336, -- 生存本能

    -- hunter
    186265, -- 灵龟守护
    264735, -- 优胜劣汰

    -- mage
    45438, -- 寒冰屏障

    -- monk
    115176, -- 禅悟冥想
    115203, -- 壮胆酒
    122278, -- 躯不坏
    122783, -- 散魔功
    125174, -- 业报之触

    -- paladin
    498, -- 圣佑术
    642, -- 圣盾术
    31850, -- 炽热防御者
    212641, -- 远古列王守卫
    205191, -- 以眼还眼

    -- priest
    47585, -- 消散
    19236, -- 绝望祷言
    586, -- 渐隐术
    193065, -- 防护圣光

    -- rogue
    1966, -- 佯攻
    5277, -- 闪避
    31224, -- 暗影斗篷

    -- shaman
    108271, -- 星界转移
    210918, -- 灵体形态

    -- warlock
    104773, -- 不灭决心
    212295, -- 虚空守卫

    -- warrior
    871, -- 盾墙
    12975, -- 破釜沉舟
    23920, -- 法术反射
    118038, -- 剑在人在
    184364, -- 狂怒回复
}

local defensiveCooldownIDs = {
    [113862] = true, -- Greater Invisibility - 强化隐形术
}

local defensives = {}
for _, id in pairs(defensiveCooldowns) do
    defensives[GetSpellInfo(id)] = true
end
defensiveCooldowns = F:Copy(defensives)

function I:UpdateCustomDefensives(t)
    -- reset
    defensiveCooldowns = F:Copy(defensives)
    -- insert
    for _, id in pairs(t) do
        local name = GetSpellInfo(id)
        if name then
            defensiveCooldowns[name] = true
        end
    end
end
    
function I:IsDefensiveCooldown(nameOrID)
    return defensiveCooldowns[nameOrID] or defensiveCooldownIDs[nameOrID]
end

-------------------------------------------------
-- tankActiveMitigation
-------------------------------------------------
local tankActiveMitigations = {
    -- death knight
    77535, -- 鲜血护盾
    195181, -- 白骨之盾

    -- demon hunter
    203720, -- 恶魔尖刺

    -- druid
    192081, -- 铁鬃

    -- monk
    215479, -- 铁骨酒

    -- paladin
    132403, -- 正义盾击

    -- warrior
    2565, -- 盾牌格挡
}

local tankActiveMitigationNames = {
    -- death knight
    F:GetClassColorStr("DEATHKNIGHT")..GetSpellInfo(77535).."|r", -- 鲜血护盾
    F:GetClassColorStr("DEATHKNIGHT")..GetSpellInfo(195181).."|r", -- 白骨之盾

    -- demon hunter
    F:GetClassColorStr("DEMONHUNTER")..GetSpellInfo(203720).."|r", -- 恶魔尖刺

    -- druid
    F:GetClassColorStr("DRUID")..GetSpellInfo(192081).."|r", -- 铁鬃

    -- monk
    F:GetClassColorStr("MONK")..GetSpellInfo(215479).."|r", -- 铁骨酒

    -- paladin
    F:GetClassColorStr("PALADIN")..GetSpellInfo(132403).."|r", -- 正义盾击

    -- warrior
    F:GetClassColorStr("WARRIOR")..GetSpellInfo(2565).."|r", -- 盾牌格挡
}

do
    local temp = {}
    for _, id in pairs(tankActiveMitigations) do
        temp[GetSpellInfo(id)] = true
    end
    tankActiveMitigations = temp
end

function I:IsTankActiveMitigation(name)
    return tankActiveMitigations[name]
end

function I:GetTankActiveMitigationString()
    return table.concat(tankActiveMitigationNames, ", ").."."
end

-------------------------------------------------
-- dispels
-------------------------------------------------
local dispellable = {
    -- DRUID ----------------
        -- 102 - Balance
        [102] = {["Curse"] = true, ["Poison"] = true},
        -- 103 - Feral
        [103] = {["Curse"] = true, ["Poison"] = true},
        -- 104 - Guardian
        [104] = {["Curse"] = true, ["Poison"] = true},
        -- Restoration
        [105] = {["Curse"] = true, ["Magic"] = true, ["Poison"] = true},
    -------------------------
        
    -- MAGE -----------------
        -- 62 - Arcane
        [62] = {["Curse"] = true},
        -- 63 - Fire
        [63] = {["Curse"] = true},
        -- 64 - Frost
        [64] = {["Curse"] = true},
    -------------------------
        
    -- MONK -----------------
        -- 268 - Brewmaster
        [268] = {["Disease"] = true, ["Poison"] = true},
        -- 269 - Windwalker
        [269] = {["Disease"] = true, ["Poison"] = true},
        -- 270 - Mistweaver
        [270] = {["Disease"] = true, ["Magic"] = true, ["Poison"] = true},
    -------------------------

    -- PALADIN --------------
        -- 65 - Holy
        [65] = {["Disease"] = true, ["Magic"] = true, ["Poison"] = true},
        -- 66 - Protection
        [66] = {["Disease"] = true, ["Poison"] = true},
        -- 70 - Retribution
        [70] = {["Disease"] = true, ["Poison"] = true},
    -------------------------
    
    -- PRIEST ---------------
        -- 256 - Discipline
        [256] = {["Disease"] = true, ["Magic"] = true},
        -- 257 - Holy
        [257] = {["Disease"] = true, ["Magic"] = true},
        -- 258 - Shadow
        [258] = {["Disease"] = true, ["Magic"] = true},
    -------------------------

    -- SHAMAN ---------------
        -- 262 - Elemental
        [262] = {["Curse"] = true},
        -- 263 - Enhancement
        [263] = {["Curse"] = true},
        -- 264 - Restoration
        [264] = {["Curse"] = true, ["Magic"] = true},
    -------------------------

    -- WARLOCK --------------
        -- 265 - Affliction
        [265] = {["Magic"] = true},
        -- 266 - Demonology
        [266] = {["Magic"] = true},
        -- 267 - Destruction
        [267] = {["Magic"] = true},
    -------------------------
}

function I:CanDispel(dispelType)
    if dispellable[Cell.vars.playerSpecID] then
        return dispellable[Cell.vars.playerSpecID][dispelType]
    else
        return
    end
end

-------------------------------------------------
-- drinking
-------------------------------------------------
local drinks = {
    170906, -- 食物和饮水
    167152, -- 进食饮水
    430, -- 喝水
    43182, -- 饮水
    172786, -- 饮料
    308433, -- 食物和饮料
}

do
    local temp = {}
    for _, id in pairs(drinks) do
        temp[GetSpellInfo(id)] = true
    end
    drinks = temp
end

function I:IsDrinking(name)
    return drinks[name]
end

-------------------------------------------------
-- healer 
-------------------------------------------------
local spells =  {
    -- druid
    8936, -- 愈合
    774, -- 回春术
    33763, -- 生命绽放
    188550, -- 生命绽放
    48438, -- 野性成长
    102351, -- 塞纳里奥结界
    102352, -- 塞纳里奥结界
    391888, -- 激变蜂群
    
    -- monk
    119611, -- 复苏之雾
    124682, -- 氤氲之雾
    191840, -- 精华之泉
    325209, -- 氤氲之息
    -- 386276, -- 骨尘酒
    -- 343737, -- 抚慰之息
    -- 387766, -- 滋养真气

    -- paladin
    53563, -- 圣光道标
    223306, -- 赋予信仰
    148039, -- 信仰屏障
    156910, -- 信仰道标
    200025, -- 美德道标
    325966, -- 圣光闪烁
    -- TODO: 仲夏祝福
    
    -- priest
    139, -- 恢复
    41635, -- 愈合祷言
    17, -- 真言术：盾
    194384, -- 救赎
    77489, -- 圣光回响
    
    -- shaman
    974, -- 大地之盾
    61295, -- 激流
    382024, -- 大地生命武器
}

function F:FirstRun()
    local icons = "\n\n"
    for i, id in pairs(spells) do
        local icon = select(3, GetSpellInfo(id))
        icons = icons .. "|T"..icon..":0|t"
        if i % 11 == 0 then
            icons = icons .. "\n"    
        end
    end

    local popup = Cell:CreateConfirmPopup(Cell.frames.anchorFrame, 200, L["Would you like Cell to create a \"Healers\" indicator (icons)?"]..icons, function(self)
        local currentLayoutTable = Cell.vars.currentLayoutTable

        local last = #currentLayoutTable["indicators"]
        if currentLayoutTable["indicators"][last]["type"] == "built-in" then
            indicatorName = "indicator"..(last+1)
        else
            indicatorName = "indicator"..(tonumber(strmatch(currentLayoutTable["indicators"][last]["indicatorName"], "%d+"))+1)
        end
        
        tinsert(currentLayoutTable["indicators"], {
            ["name"] = "Healers",
            ["indicatorName"] = indicatorName,
            ["type"] = "icons",
            ["enabled"] = true,
            ["position"] = {"TOPRIGHT", "TOPRIGHT", 0, 3},
            ["frameLevel"] = 5,
            ["size"] = {13, 13},
            ["num"] = 5,
            ["orientation"] = "right-to-left",
            ["font"] = {"Cell ".._G.DEFAULT, 11, "Outline", 2, 1},
            ["showDuration"] = false,
            ["auraType"] = "buff",
            ["castByMe"] = true,
            ["auras"] = spells,
        })
        Cell:Fire("UpdateIndicators", Cell.vars.currentLayout, indicatorName, "create", currentLayoutTable["indicators"][last+1])
        CellDB["firstRun"] = false
    end, function()
        CellDB["firstRun"] = false
    end)
    popup:SetPoint("TOPLEFT")
    popup:Show()
end

-------------------------------------------------
-- cleuAuras
-------------------------------------------------
local cleuAuras = {}

-- local cleus = {}
-- for _, t in pairs(cleuAuras) do
--     local icon = select(3, GetSpellInfo(t[1]))
--     cleus[t[1]] = {t[2], icon}
-- end
-- cleuAuras = F:Copy(cleus)

function I:UpdateCleuAuras(t)
    -- reset
    wipe(cleuAuras)
    -- cleuAuras = F:Copy(cleus)
    -- insert
    for _, c in pairs(t) do
        local icon = select(3, GetSpellInfo(c[1]))
        cleuAuras[c[1]] = {c[2], icon}
    end
end
    
function I:CheckCleuAura(id)
    return cleuAuras[id]
end

-------------------------------------------------
-- targetedSpells
-------------------------------------------------
local targetedSpells = {
    320788, -- 冻结之缚
    344496, -- 震荡爆发
    319941, -- 碎石之跃
    322614, -- 心灵连接
    320132, -- 暗影之怒
    334053, -- 净化冲击波
    320596, -- 深重呕吐
    356924, -- 屠戮
    356666, -- 刺骨之寒
    319713, -- 巨兽奔袭
    338606, -- 病态凝视
    343556, -- 病态凝视
    324079, -- 收割之镰
    317963, -- 知识烦扰
    333861, -- 回旋利刃
    332234, -- 挥发精油
    -- 328429, -- 窒息勒压
}

function I:GetDefaultTargetedSpellsList()
    return targetedSpells
end

function I:GetDefaultTargetedSpellsGlow()
    return {"Pixel", {0.95,0.95,0.32,1}, 9, 0.25, 8, 2}
end

-------------------------------------------------
-- Consumables: Healing Potion & Healthstone
-------------------------------------------------
local consumables = {
    {
        6262, -- 治疗石
        {"A", {0.4, 1, 0}},
    },
    {
        359867, -- 宇宙治疗药水
        {"A", {1, 0.1, 0.1}},
    },
    {
        307192, -- 灵魂治疗药水
        {"A", {1, 0.1, 0.1}},
    },
}


function I:GetDefaultConsumables()
    return consumables
end

function I:ConvertConsumables(db)
    local temp = {}
    for _, t in pairs(db) do
        temp[t[1]] = t[2]
    end
    return temp
end