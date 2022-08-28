local _, TS = ...

--定义要显示的成就
--[[
    {
        tab = "test",
        bosses = {1017,621,13},
        idName = { [1017] = "养他", [621] = "战袍", [13] = "80级", },
    },
    {
        tab = "ULD(25)",
        bosses = {2885,2875,2882,3256,3257,3258,2879,2880,2883,2881},
        idName = { [2885] = "议会", [2875] = "左右手", [2882] = "猫女", [3256] = "霍迪尔", [3257] = "托里姆", [3258] = "弗蕾亚", [2879] = "米米隆", [2880] = "将军", [2883] = "尤格", [2881] = "观察者", },
    },
]]

TS.DATA_VERSION = 20220808

--abyuiPW
TS.VERSION_BOSSES = { -14460, "帝", -15134, "希", -15470, "狱" } -- -13784, "艾", -14068, "恩", -13322, "吉", -13418, "乌", 12110, "阿" -11874, "基" -- -11195, "古", --引领潮流 -11194, "萨", -11581, "海", 引领潮流：Ahead of the Curve: 千钧一发 Cutting Edge:

local RES = {
  {
      tab = "总览",
      ids = { -15690, {-15692,-15693,-15694,-15695,-15500} }, -- -15498, -15499, "S3征服", "S3大师" -15077, -15078, "S2征服", "S2大师" -14531, -14532, "S1征服", "S1大师", -14145, "S4大师", -13781, "S3大师", -13449, "S2大师"
      --{-15045,-15046,-15047,-15048,-15049,-15050,-15051,-15052}, 64, "钥石英雄", "钥石英雄光辉成就（账号共享，限时完成20层史诗钥石副本）",
      widths = { 54, 64 },
      names = { "S4大师", "钥石英雄", },
      tips = { "《暗影国度》钥石大师（账号共享，任意角色史诗钥石评分2000分）", "钥石英雄光辉成就（账号共享，限时完成20层史诗钥石副本，第四赛季集市、卡拉赞、麦卡贡、码头、车站共5个）"},
      reports = { false, false, },
  },
}

local INSTANCES = {
    {
        bosses = {
            { "啸翼", 14419, 14420, { 14421, -14356, }, },
            { "猎手阿尔迪莫", 14423, 14424, { 14425, -14357, }, },
            { "完成太阳之王的救赎", 14435, 14436, { 14437, -14360 } },
            { "圣物匠赛·墨克斯", 14431, 14432, { 14433, -14359, }, },
            { "饥饿的毁灭者", 14427, 14428, { 14429, -14358, }, },
            { "伊涅瓦·暗脉女勋爵", 14439, 14440, { 14441, -14361, }, },
            { "猩红议会", 14443, 14444, { 14445, -14362, }, },
            { "泥拳", 14447, 14448, { 14449, -14363, }, },
            { "顽石军团干将", 14451, 14452, { 14453, -14364, }, },
            { "德纳修斯大帝", 14455, 14456, { 14457, -14365, }, },
        },
        diff = { "", "", "M纳堡", },
        tab = "纳斯利亚堡",
    },

    {
        bosses = {
            { "塔拉格鲁", 15137, 15138, { 15139, -15112, }, },
            { "典狱长之眼", 15141, 15142, { 15143, -15113, }, },
            { "九武神", 15145, 15146, { 15147, -15114, }, },
            { "耐奥祖的残迹", 15149, 15150, { 15151, -15115, }, },
            { "裂魂者多尔玛赞", 15153, 15154, { 15155, -15116, }, },
            { "痛楚工匠莱兹纳尔", 15157, 15158, { 15159, -15117, }, },
            { "初诞者的卫士", 15161, 15162, { 15163, -15118, }, },
            { "命运撰写师罗-卡洛", 15165, 15166, { 15167, -15119, }, },
            { "克尔苏加德", 15170, 15171, { 15172, -15120, }, },
            { "希尔瓦娜斯·风行者", 15174, 15175, { 15176, -15121, }, },
        },
        diff = { "", "", "M统御", },
        tab = "统御圣所",
    },

    {
        bosses = {
            { "道茜歌妮", 15437, 15438, { 15439, -15482, }, },
            { "恐惧双王", 15457, 15458, { 15459, -15487, }, },
            { "典狱长", 15465, 15466, { 15467, -15489, }, },
            { "莱葛隆", 15461, 15462, { 15463, -15488, }, },
            { "安度因", 15453, 15454, { 15455, -15486, }, },
            { "黑伦度斯", 15449, 15450, { 15451, -15485, }, },
            { "利许威姆", 15445, 15446, { 15447, -15484, }, },
            { "死亡万神殿原型体", 15441, 15442, { 15443, -15483, }, },
            { "圣物匠赛·墨克斯", 15433, 15434, { 15435, -15481, }, },
            { "司垢莱克斯", 15429, 15430, { 15431, -15480, }, },
            { "警戒卫士", 15425, 15426, { 15427, -15479, }, },
        },
        diff = { "", "", "M圣墓", },
        tab = "初诞者圣墓",
    }
}

-- {
--    ids = { 7399, 11162, {id1, id2, id3, ...}, {}, ... },
--    names = { "秘境数", "15层", "M翡翠", "H勇气", ...},
--    tab = "总览",
--  },
local TABS = {}

for ord, tab in next, RES do
    local one = { ids = {}, names = {}, tips = {}, tab = tab.tab, widths = {}, reports = {} }
    for i = 1, #tab.ids do
        if tab.names[i] and #tab.names[i] > 0 then
            one.ids[i] = tab.ids[i]
            one.names[i] = tab.names[i]
            one.tips[i] = tab.tips[i]
            one.widths[i] = tab.widths[i]
            one.reports[i] = tab.reports[i]
        end
    end

    for i, ins in ipairs(INSTANCES) do
        for j, diff in ipairs(ins.diff) do
            if diff and #diff > 0 then
                local bosses = {}
                for k = 1, #ins.bosses do
                    bosses[k] = ins.bosses[k][j + 1]
                end
                table.insert(one.ids, bosses)
                table.insert(one.names, diff)
                table.insert(one.reports, ins.report == nil and true or ins.report)
                table.insert(one.widths, 54)
            end
        end
    end
    tinsert(TABS, one)
end

--local tip = "完成史诗副本的次数，注意包括普通史诗（非钥石）难度，因为暴雪的BUG，所以很多副本不准"
--table.insert(TABS, {
--    tab = "史诗副本次数",
--    ids = { 14407, 14398, 14395, 14389, 14401, 14392, 14205, 14404, },
--    widths = { 40, 40, 40, 40, 40, 40, 40, },
--    tips = { tip, tip, tip, tip, tip, tip, tip, tip, tip, tip, tip, tip, tip,  },
--    names = { "伤逝", "凋魂", "仙林", "彼界", "高塔",  "赎罪", "赤红", "通灵", },
--})

table.insert(TABS, {
    tab = "千钧一发",
    any_done = true,
    ids = {
        {-15471}, {-15135}, {-14461}, {-14069}, {-13785}, {-13419}, {-13323}, {-12535},
        {-12111}, {-11875}, {-11192}, {-11580}, {-11191},
        {-10045}, {-9443}, {-9442},
        {-8401, -8400}, {-8260}, {-8238}, {-7487}, {-7486}, {-7485},
    },
    widths = { 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, },
    tips = {
        "千钧一发：典狱长", "千钧一发：希尔瓦娜斯", "千钧一发：德纳修斯大帝", "千钧一发：恩佐斯", "千钧一发：艾萨拉", "千钧一发：乌纳特", "千钧一发：吉安娜", "千钧一发：戈霍恩",
        "千钧一发：阿古斯", "千钧一发：基尔加丹", "千钧一发：古尔丹", "千钧一发：海拉", "千钧一发：萨维斯",
        "千钧一发：黑暗之门（阿克蒙德）", "千钧一发：黑手的熔炉", "千钧一发：元首之陨",
        "千钧一发：加尔鲁什·地狱咆哮（10人或25人）", "千钧一发：莱登", "千钧一发：雷神",
        "千钧一发：惧之煞", "千钧一发：大女皇夏柯希尔", "千钧一发：皇帝的意志",
    },
    names = { "狱长", "希瓦", "大帝", "恩佐", "艾萨", "乌纳", "珍娜", "戈霍", "阿古", "基丹", "古尔", "海拉", "萨维", "阿克", "黑手", "悬槌", "小吼", "莱登", "雷神", "永春", "恐心", "魔古" },
})

TS.TABS = TABS

--[==[
-- 鼠标移到统计项目上 /run a=GetMouseFocus().id print(a, GetAchievementInfo(a))

--之前的版本可以省略bossID, 从idName里取key
for _, v in next, TS.TABS do
    if(not v.bosses) then
        v.bosses = {}
        for k in next, v.idName do
            tinsert(v.bosses, k)
        end
        table.sort(v.bosses)
    end
end

-- GetAchievementInfo(6168) => 6168, "死亡之翼英雄模式擊殺數(巨龍之魂)", 0, false, nil, nil, nil, "", 9, "Interface\Icons\achievment_boss_madnessofdeathwing", "", false, false, nil

----------------------------------------------------------------------------------------------------
-- 一个boss一个boss的列出不同难度
local instanceList = { '初诞者圣墓' } --'尼奥罗萨，觉醒之城', '翡翠梦魇', '勇气试炼', '暗夜要塞', '萨格拉斯之墓', '安托鲁斯，燃烧王座', '奥迪尔' }
local mythicPatterns = { '击败%s的%s（史诗难度）', '在%s中击败%s（史诗难度）', '在%s击败%s（史诗难度）', '击败%s的%s（史诗难度）', '击败%s的%s（史诗难度）' }
local diff = { "普通", "英雄", "史诗" }
local pattern = "[ ]*（{diff}{instance}）"
local prefixes = {"击败", "消灭", "掠夺", "通过", "救赎", "击杀", "保卫" }

-- 获取成就很卡
if not ACHIEVE_DATAS then
    ACHIEVE_DATAS = {}
    for _, cate in next, GetStatisticsCategoryList() do
        for i = 1, GetCategoryNumAchievements(cate) do
            local id, name = GetAchievementInfo(cate, i)
            ACHIEVE_DATAS[id] = name
        end
    end
end

if not ACHIEVE_DESCS then
    ACHIEVE_DESCS = {}
    for _, cate in next, GetCategoryList() do
        for i = 1, GetCategoryNumAchievements(cate) do
            local id, name, _, _, _, _, _, desc = GetAchievementInfo(cate, i)
            if desc and desc:find("（史诗难度）") then ACHIEVE_DESCS[desc:gsub("。$", ""):gsub("，腐蚀之心", "")] = id end
        end
    end
end

INSTANCES = {}
for kk = 1, #instanceList do
    local instanceName = instanceList[kk]
    local mythicPattern = mythicPatterns[kk]
    local DATA = { tab = instanceName, diff = u1copy(diff), bosses = {} }
    tinsert(INSTANCES, DATA);
    for id, name in pairs(ACHIEVE_DATAS) do
        for diffId, diffName in next, diff do
            local search = pattern:gsub("{diff}", diffName):gsub("{instance}", instanceName)
            if(name:find(search)) then
                for _, prefix in  next, prefixes do name = name:gsub("^"..prefix, "") end
                name = name:gsub(search, "")
                local foundBoss
                for j, boss in next, DATA.bosses do
                    if boss[1] == name then
                        foundBoss = boss
                        break
                    end
                end
                if not foundBoss then
                    foundBoss = { name }
                    tinsert(DATA.bosses, foundBoss)
                end
                if diffName == '史诗' and mythicPattern then
                    local desc = mythicPattern:format(instanceName, name)
                    local aid = ACHIEVE_DESCS[desc]
                    if aid then
                        --print(desc, aid)
                        foundBoss[diffId+1] = { id, -aid }
                    end
                end
                foundBoss[diffId+1] = foundBoss[diffId+1] or id
                --print(id, name, diffName, instanceName)
            end
        end
    end
    for _, boss in next, DATA.bosses do
        --boss[1] = instanceList[kk+1].." "..boss[1]
    end
end
wowluacopy(INSTANCES)
--------------------------------------------------------------
{
  {
    bosses = {
      { "伊墨苏斯", 8551, 8552, 8553, 8554, },
      { "堕落的守护者", 8557, 8558, 8559, 8560, },
      { "诺鲁什的试炼", 8563, 8564, 8565, 8566, },
      { "傲之煞", 8569, 8570, 8571, 8573, },
      { "迦拉卡斯", 8576, 8577, 8578, 8579, },
      { "钢铁战蝎", 8582, 8583, 8584, 8585, },
      { "黑暗萨满", 8588, 8589, 8590, 8591, },
      { "纳兹戈林将军", 8595, 8596, 8597, 8598, },
      { "马尔考罗克", 8601, 8602, 8603, 8604, },
      { "潘达利亚战利品", 8608, 8609, 8610, 8612, },
      { "嗜血的索克", 8616, 8617, 8618, 8619, },
      { "攻城匠师黑索", 8622, 8623, 8624, 8625, },
      { "卡拉克西英杰", 8628, 8629, 8630, 8631, },
      { "加尔鲁什·地狱咆哮", 8635, 8636, 8637, 8638, },
    },
    diff = {
      { "10人普通", "10", },
      { "25人普通", "25", },
      { "10人英雄", "10H", },
      { "25人英雄", "25H", },
    },
    tab = "决战奥格瑞玛",
  },
}

--老版本的以副本来
local pattern = "（{diff}{instance}）"
local instanceList = { '决战奥格瑞玛', }
local diff = {
  {"随机", ""},
  {"弹性", ""},
  {"10人普通", "10人"},
  {"25人普通", "25人"},
  {"10人英雄", "10H"},
  {"25人英雄", "25H"},
}
local prefixes = {"击败", "消灭", "掠夺", "通过"}
INSTANCES = {}
for _, instanceName in next, instanceList do
  for _, cate in next, GetStatisticsCategoryList() do
    for i = 1, GetCategoryNumAchievements(cate) do
      local id, name = GetAchievementInfo(cate, i)  
      for diffId, diffData in next, diff do
        local search = pattern:gsub("{diff}", diffData[1]):gsub("{instance}", instanceName)
        if(name:find(search)) then
          for _, prefix in  next, prefixes do name = name:gsub("^"..prefix, "") end
          name = name:gsub(search, "")
          local foundBoss
          for j, boss in next, INSTANCES do
            if boss.tab == name then 
              foundBoss = boss
              break
            end
          end
          if not foundBoss then
            foundBoss = { tab = name, bosses = {}, idName = {} }
            tinsert(INSTANCES, foundBoss)
          end
          tinsert(foundBoss.bosses, id)
          foundBoss.idName[id] = diffData[2]
        end
      end
    end
  end
end
wowluacopy(INSTANCES)

--]==]
