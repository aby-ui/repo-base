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

TS.DATA_VERSION = 20190510

TS.VERSION_BOSSES = { -13322, "娜", -13418, "乌", } --12110, "阿" -11874, "基" -- -11195, "古", --引领潮流 -11194, "萨", -11581, "海", 引领潮流：Ahead of the Curve: 千钧一发 Cutting Edge:


local RES = {
  {
      tab = "总览",
      ids = { 7399, -13080, -13449},
      widths = { 70, 50, 50 },
      names = { "大秘次数", "S1大师", "S2大师"},
      tips = { "史诗秘钥副本总次数（包括旧版本）", "《争霸艾泽拉斯》钥石征服者：第一赛季（全10层限时）", "《争霸艾泽拉斯》钥石大师：第一赛季（全15层限时）", "《争霸艾泽拉斯》钥石征服者：第二赛季（全10层限时）", "《争霸艾泽拉斯》钥石大师：第二赛季（全15层限时）"}
  },
}

local INSTANCES = {
    {
        bosses = {
            { "圣光勇士", 13329, 13330, {13331,-13292} },
            { "格洛恩", 13333, 13334, {13336,-13293} },
            { "弗雷菲斯和明光者", 13355, 13356, {13357,-13295} },
            { "丰灵", 13359, 13361, {13362,-13299} },
            { "神选者教团", 13364, 13365, {13366,-13300} },
            { "拉斯塔哈大王", 13368, 13369, {13370,-13311} },
            { "梅卡托克", 13372, 13373, {13374,-13312} },
            { "赢得风暴之墙阻击战", 13376, 13377, {13378,-13313} },
            { "吉安娜·普罗德摩尔", 13380, 13381, {13382,-13314} },
        },
        diff = { "", "H达萨", "M达萨", },
        tab = "达萨罗之战",
    },
    {
      bosses = {
        { "乌纳特，虚空先驱", 13411, 13412, 13413, },
        { "无眠秘党", 13405, 13406, 13407, },
      },
      diff = { "", "H风暴", "M风暴", },
      tab = "风暴熔炉",
    }
}

-- {
--    ids = { 7399, 11162, {id1, id2, id3, ...}, {}, ... },
--    names = { "秘境数", "15层", "M翡翠", "H勇气", ...},
--    tab = "总览",
--  },
local TABS = {}

for ord, tab in next, RES do
    local one = { ids = {}, names = {}, tips = {}, tab = tab.tab, widths = {} }
    for i = 1, #tab.ids do
        if tab.names[i] and #tab.names[i] > 0 then
            one.ids[i] = tab.ids[i]
            one.names[i] = tab.names[i]
            one.tips[i] = tab.tips[i]
            one.widths[i] = tab.widths[i]
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
            end
        end
    end
    tinsert(TABS, one)
end

local tip = "完成史诗副本的次数，注意包括普通史诗（非钥石）难度，因为暴雪的BUG，所以很多副本不准"
table.insert(TABS, {
    tab = "史诗副本次数",
    ids = { 12749, 12752, 12763, 12768, 12773, 12776, 12779, 12745, 12782, 12785 },
    widths = { 40, 40, 40, 40, 40, 40, 40, 40, 40, },
    tips = { tip, tip, tip, tip, tip, tip, tip, tip, tip, tip, tip, tip, tip,  },
    names = { "阿塔", "自由", "诸王", "风暴", "围攻", "神庙", "暴富", "地渊", "监狱", "庄园"},
})

table.insert(TABS, {
    tab = "千钧一发",
    any_done = true,
    ids = {
        {-13419}, {-13323}, {-12535},
        {-12111}, {-11875}, {-11192}, {-11580}, {-11191},
        {-10045}, {-9443}, {-9442},
        {-8401, -8400}, {-8260}, {-8238}, {-7487}, {-7486}, {-7485},
    },
    widths = { 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, },
    tips = {
        "千钧一发：乌纳特", "千钧一发：吉安娜", "千钧一发：戈霍恩",
        "千钧一发：阿古斯", "千钧一发：基尔加丹", "千钧一发：古尔丹", "千钧一发：海拉", "千钧一发：萨维斯",
        "千钧一发：黑暗之门（阿克蒙德）", "千钧一发：黑手的熔炉", "千钧一发：元首之陨",
        "千钧一发：加尔鲁什·地狱咆哮（10人或25人）", "千钧一发：莱登", "千钧一发：雷神",
        "千钧一发：惧之煞", "千钧一发：大女皇夏柯希尔", "千钧一发：皇帝的意志",
    },
    names = { "乌纳", "珍娜", "戈霍", "阿古", "基丹", "古尔", "海拉", "萨维", "阿克", "黑手", "悬槌", "小吼", "莱登", "雷神", "永春", "恐心", "魔古" },
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
local instanceList = { '安托鲁斯，燃烧王座', '奥迪尔' } --'翡翠梦魇', '勇气试炼', '暗夜要塞', '萨格拉斯之墓', '安托鲁斯，燃烧王座' }
local mythicPatterns = { '在%s击败%s（史诗难度）', '在%s中击败%s（史诗难度）', '在%s击败%s（史诗难度）', '击败%s的%s（史诗难度）' }
local diff = { "普通", "英雄", "史诗" }
local pattern = "（{diff}{instance}）"
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
    local DATA = { tab = instanceName, diff = copy(diff), bosses = {} }
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
