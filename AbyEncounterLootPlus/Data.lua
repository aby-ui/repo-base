ELP_VERSION_TIER = 10 --GetServerExpansionLevel() + 1 + 1 --8.0时接口返回7, 前夕再加1 --abyuiPW
ELP_SEASON_TAB_ID = 5

--最新团本和宿命团本
--ELP_NEWEST_RAID, ELP_WEEK_RAID = ELP_GetNewestRaidAndEmpoweredRaid(ELP_VERSION_TIER)

ELP_SEASON_RAIDS = {
    { 1200 }, --巨龙牢窟
    --{ 1205 }, --巨龙群岛, 只有280的
}

ELP_SEASON_DUNGEONS = {
    { 1201 }, --艾杰斯亚学院
    { 1196 }, --蕨皮山谷
    { 1204 }, --注能大厅
    { 1199 }, --奈萨鲁斯
    { 1202 }, --红玉新生法池
    { 1203 }, --碧蓝魔馆
    { 1198 }, --诺库德阻击战
    { 1197 }, --奥达曼：提尔的遗产
}

ELP_NEXT_SEASON_MYTHICS = {}

ELP_SEASON_MYTHICS = {
    --instanceID, challengeMapId, name(or empty), bosses or empty
    --after init: instanceID, challengeMapId, name, bossMap/"all", bossList/nil
    --/dump EncounterJournal.instanceID, EncounterJournal.encounterID
    --/run for _, v in ipairs(C_ChallengeMode.GetMapTable()) do print(v, C_ChallengeMode.GetMapUIInfo(v)) end
    { 1201, 402 }, --艾杰斯亚学院
    { 1202, 399 }, --红玉新生法池
    { 1203, 401 }, --碧蓝魔馆
    { 1198, 400 }, --诺库德阻击战
    { 537, 165 }, --影月墓地
    { 800, 210 }, --群星庭院
    { 721, 200 }, --英灵殿
    { 313, 002 }, --青龙寺
}

-- loot table from https://www.wowhead.com/news/list-of-currently-confirmed-loot-drops-from-season-4-mythic-grimrail-depot-iron-328237
ELP_LOOT_LIST = {
    Grimrail = { --[itemId] = true,
    },
    IronDocks = {
    },
}

--为了能够利用系统筛选, 只能选择多个副本然后再筛掉
ELP_LOOT_TABLES = {
    [536] = { lootTable = ELP_LOOT_LIST.Grimrail, otherInstances = { 558 } }, --恐轨车站
    [558] = { lootTable = ELP_LOOT_LIST.IronDocks, otherInstances = { 536, 385, } }, --钢铁码头, 385是血渣熔炉裂胆战靴不在恐轨车站掉
}
ELP_LOOT_TABLE_LOOTS = {}       --每个副本的lootTable, 初始化FILTER后丢弃
ELP_LOOT_TABLE_LOOTS_ALL = {}   --全部lootTable, 给多副本模式用, 初始化FILTER后丢弃
do
    for insID, v in pairs(ELP_LOOT_TABLES) do
        for itemID in pairs(v.lootTable) do v.lootTable[itemID] = insID end --保存每件装备的副本ID, 列表时需要
        ELP_LOOT_TABLE_LOOTS[insID] = v.lootTable
        u1copy(v.lootTable, ELP_LOOT_TABLE_LOOTS_ALL) --给全部副本搜索用
    end
end
ELP_LOOT_TABLE_OTHER = {}       --每个副本的关联副本, 初始化FILTER后丢弃
do
    for insID, v in pairs(ELP_LOOT_TABLES) do
        ELP_LOOT_TABLE_OTHER[insID] = {}
        for _, otherID in ipairs(v.otherInstances) do
            ELP_LOOT_TABLE_OTHER[insID][otherID] = { bosses = "all", lootTable = ELP_LOOT_TABLE_LOOTS[insID] } --lootTable要用副本自身的
        end
        v.otherInstances = nil
    end
end
ELP_LOOT_TABLES = nil

ELP_LINK_REPLACE = {
    [ 536 ] = "::::::::60:65::33:8:7359:8253:8765:8136:8116:6652:3173:6646:1:28:1279:::::",
    [ 558 ] = "::::::::60:65::33:8:7359:8253:8765:8136:8116:6652:3173:6646:1:28:1279:::::",
    [ 1178] = "::::::::60:65::16:8:7359:8267:8765:8136:8117:6652:3139:6646:1:28:464:::::",
    [ 860 ] = "::::::::60:65::34:10:8281:8765:6652:7579:7749:8136:8138:7578:3167:6646:1:28:1180:::::",
    [ 1194] = "::::::::60:65::33:7:8281:8765:7359:6652:7578:1605:6646:1:28:1279:::::",
}

--只需要处理5人副本难度，团本难度不用管
local dungeonDifficulty = 8
ELP_INSTANCE_DIFFICULTY = {}
for _, v in ipairs(ELP_SEASON_MYTHICS or {}) do ELP_INSTANCE_DIFFICULTY[v[1]] = dungeonDifficulty end
for _, v in ipairs(ELP_NEXT_SEASON_MYTHICS or {}) do ELP_INSTANCE_DIFFICULTY[v[1]] = dungeonDifficulty end
for _, v in ipairs(ELP_SEASON_DUNGEONS or {}) do ELP_INSTANCE_DIFFICULTY[v[1]] = dungeonDifficulty end
for insID, lt in pairs(ELP_LOOT_TABLE_OTHER or {}) do
    for _, v in ipairs(ELP_INSTANCE_DIFFICULTY[insID] and lt or {}) do ELP_INSTANCE_DIFFICULTY[v] = dungeonDifficulty end
end
--ELP_INSTANCE_DIFFICULTY[313] = 2 --前夕青龙寺只有英雄

--自动设置副本名称, 把instances转成map
ELP_ENCOUNTER_INSTANCE_NAME = {} -- 不同boss对应的副本名 encounterId => instanceName
ELP_ENCOUNTER_SAMEINSTANCE_BOSSES = {} --多副本模式选择LOOT时, 左侧显示BOSS用, 在DisplayInstance之前设置到ELP, 在EJ_GetEncounterInfoByIndex_ELP使用
for _, all in ipairs({ELP_SEASON_MYTHICS, ELP_SEASON_RAIDS}) do
    for _, v in ipairs(all) do
        if v[3] == nil or v[3] == "" then v[3] = v[2] and C_ChallengeMode.GetMapUIInfo(v[2]) or EJ_GetInstanceInfo(v[1]) end
        if v[4] == nil or #v[4] == 0 then
            v[4] = "all"
        else
            local map = {}
            for _, bossid in ipairs(v[4]) do
                map[bossid] = true
                ELP_ENCOUNTER_INSTANCE_NAME[bossid] = v[3]
                ELP_ENCOUNTER_SAMEINSTANCE_BOSSES[bossid] = v[4]
            end
            v[5] = v[4] --boss列表要用到原始的顺序
            v[4] = map
        end
    end
end

ELP_CHALLENGE_MAPID_FILTER_INDEX = {} --ChallengesGuildBest.lua里用

function ELP_InitFilters()
    local FILTERS = {}
    --[[
        type = "multi/dungeon/raid",
        text="下拉菜单名称",
        short="过滤文本名",
        instances = {
            [副本ID1] = {
                bosses = "all" / { [bossID1]=true, [bossID2]=true} },
                lootTable = { [itemID] = instanceID }, --如果instanceID不是当前instance则设置encounterID为最后一个
            }
        },
        bosslist = { bossID1, bossID2 }, --单副本模式boss列表要用到原始的顺序
        otherInstances = { 结构同上但不能有lootTable也不需要bosslist, 且bosses必然为"all" }, --仅当单副本且lootTable的时候用, 表示额外获取其他副本的数据，以便职业过滤
    --]]

    local mythics = {}; for _, v in ipairs(ELP_SEASON_MYTHICS) do mythics[v[1]] = { bosses = "all", lootTable = ELP_LOOT_TABLE_LOOTS[v[1]] and ELP_LOOT_TABLE_LOOTS_ALL or nil } end
    --选出others里不是本赛季副本的,加到赛季大秘里
    local others = {}; for _, v in pairs(ELP_LOOT_TABLE_OTHER) do for otherID, v2 in pairs(v) do if not mythics[otherID] then others[otherID] = { bosses = "all", lootTable = ELP_LOOT_TABLE_LOOTS_ALL } end end end
    tinsert(FILTERS, { type = "multi", text = "赛季史诗钥石地下城", short = "赛季大秘", instances = mythics, otherInstances = others})

    for i, v in ipairs(ELP_SEASON_RAIDS) do
        tinsert(FILTERS, { type = "raid", text = v[3], instances = { [v[1]] = { bosses = v[4] } }})
    end

    local dungeons = {}; for _, v in ipairs(ELP_SEASON_DUNGEONS) do dungeons[v[1]] = { bosses = "all" } end
    tinsert(FILTERS, { type = "multi", text = "巨龙时代5人本", instances = dungeons })

    --local mythics_and_week = u1copy(mythics, { [ELP_WEEK_RAID] = { bosses = "all" } })
    --FILTERS[2] = { type = "multi", text = "全部赛季地下城和宿命团本", short = "本周副本", instances = mythics_and_week, otherInstances = others }
    --local raids = {}; for _, v in ipairs(ELP_SEASON_RAIDS) do raids[v[1]] = { bosses = "all" } end
    --tinsert(FILTERS, { type = "multi", text = "全部团本", instances = raids })
    --local all = u1copy(mythics); u1copy(raids, all)
    --tinsert(FILTERS, { type = "multi", text = "全部赛季地下城和全部团本", short = "全部副本", instances = all, otherInstances = others })

    for i, v in ipairs(ELP_SEASON_MYTHICS) do
        tinsert(FILTERS, { type = "dungeon", text = v[3], instances = { [v[1]] = { bosses = v[4], lootTable = ELP_LOOT_TABLE_LOOTS[v[1]] } }, bosslist = v[5], otherInstances = ELP_LOOT_TABLE_OTHER[v[1]] })
        ELP_CHALLENGE_MAPID_FILTER_INDEX[v[2]] = #FILTERS
    end

    --local n_mythics = {}; for _, v in ipairs(ELP_NEXT_SEASON_MYTHICS) do n_mythics[v[1]] = { bosses = "all" } end
    --tinsert(FILTERS, { type = "multi", text = "巨龙1赛季(拾取未定)", instances = n_mythics })

    ELP_LOOT_TABLE_OTHER = nil
    ELP_LOOT_TABLE_LOOTS = nil
    ELP_SEASON_RAIDS = nil

    return FILTERS
end
ELP_FILTERS = ELP_InitFilters()

--用缓存尽量减少对每个物品GetItemInfo, 虽然ScanStats里调用了GetItemInfo, 但是用db缓存了, 所以实际不怎么调用
local SKIP_CACHE = {
    [1178] = { [169774] = true, [168842] = true, [169172] = true, }, --麦卡贡的精华齿轮图纸
    [860] = { [138798] = true, [138797] = true, }, --卡拉赞阳炎猫鼬
}
local SKIPS = { Karazan = 860, Mechagon = 1178 } --, Grimrail = 536, IronDocks = 558, }
local SKIPS_MAP = {}; for _,v in pairs(SKIPS) do SKIPS_MAP[v] = true SKIP_CACHE[v] = SKIP_CACHE[v] or {} end
function ELP_ShouldHideLootItem(itemID, insID)
    local skip = false
    if SKIPS_MAP[insID] then
        local v = SKIP_CACHE[insID][itemID] if v ~= nil then return v end
        local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice, classId, subClassId = GetItemInfo(itemID)
        if insID == SKIPS.Mechagon and classId == Enum.ItemClass.Gem and subClassId == Enum.ItemGemSubclass.Other then
            skip = true --麦卡贡去掉打孔卡
        end
        if insID == SKIPS.Karazan and classId == Enum.ItemClass.Gem and subClassId == Enum.ItemGemSubclass.Artifactrelic then
            skip = true --卡拉赞去掉神器
        end
        if skip then
            SKIP_CACHE[insID][itemID] = true
        elseif classId then
            SKIP_CACHE[insID][itemID] = false
        end
    end
    return skip
end