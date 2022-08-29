ELP_VERSION_TIER = 9 --GetServerExpansionLevel() + 1 + 1 --8.0时接口返回7, 前夕再加1 --abyuiPW
ELP_SEASON_TAB_ID = 5

--最新团本和宿命团本
ELP_NEWEST_RAID, ELP_WEEK_RAID = ELP_GetNewestRaidAndEmpoweredRaid(ELP_VERSION_TIER)

ELP_SEASON_RAIDS = {
    { ELP_NEWEST_RAID },
    { 1193 }, --统御圣所  --abyuiPW
    { 1190 }, --纳斯利亚堡
}

-- loot table from https://www.wowhead.com/news/list-of-currently-confirmed-loot-drops-from-season-4-mythic-grimrail-depot-iron-328237
ELP_LOOT_LIST = {
    Grimrail = {
        [109866] = true, [109846] = true, [109972] = true, [109932] = true, [109901] = true, --Cloth
        [109869] = true, [109978] = true, [109937] = true, [109897] = true, [109934] = true, --Leather
        [109983] = true, [109890] = true, [109942] = true, --Mail
        [109895] = true, [109988] = true, [109840] = true, [109821] = true, [109946] = true, --Plate
        [110052] = true, [110053] = true, [110054] = true, [110051] = true, [109996] = true, [110001] = true,
    },
    IronDocks = {
        [109881] = true, [109903] = true, [109948] = true,
        [109979] = true, [109885] = true,
        [109875] = true, [109887] = true, [109980] = true, [109939] = true,
        [109879] = true, [109859] = true, [109802] = true, [109822] = true,
        [110058] = true, [110056] = true, [110055] = true, [110057] = true, [110059] = true, [110060] = true, [110017] = true, [110002] = true, [109997] = true,
    },
}

ELP_SEASON_MYTHICS = {
    --instanceID, challengeMapId, name(or empty), bosses or empty
    --after init: instanceID, challengeMapId, name, bossMap/"all", bossList/nil
    --/dump EncounterJournal.instanceID, EncounterJournal.encounterID
    { 860,  234, "重返卡拉赞-上层", {1836,1817,1818,1838,} },
    { 860,  227, "重返卡拉赞-下层", {1820,1826,1827,1825,1835,1837,} },
    { 1194, 391, "塔扎维什-天街", {2437,2454,2436,2452,2451,} },
    { 1194, 392, "塔扎维什-宏图", {2448,2449,2455,} },
    { 1178, 370, "麦卡贡-车间", {2336,2339,2348,2331,} },
    { 1178, 369, "麦卡贡-垃圾场", {2357,2358,2360,2355,} },
    { 536,  166, }, --恐轨车站
    { 558,  169, }, --钢铁码头
}

--为了能够利用系统筛选, 只能选择多个副本然后再筛掉
ELP_LOOT_TABLES = {
    [536] = { lootTable = ELP_LOOT_LIST.Grimrail, otherInstances = { 558 } }, --恐轨车站
    [558] = { lootTable = ELP_LOOT_LIST.IronDocks, otherInstances = { 536 } }, --钢铁码头
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
    for k, v in pairs(ELP_LOOT_TABLES) do
        ELP_LOOT_TABLE_OTHER[k] = {}
        for _, insID in ipairs(v.otherInstances) do
            ELP_LOOT_TABLE_OTHER[k][insID] = { bosses = "all", lootTable = ELP_LOOT_TABLE_LOOTS[k] } --lootTable要用副本自身的
        end
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

if not ((GetBuildInfo() == "9.2.5") or (GetBuildInfo() == "9.2.7")) then
    ELP_SEASON_RAIDS = { { ELP_NEWEST_RAID, "", }, }
    ELP_SEASON_MYTHICS = {}
end

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
    FILTERS[1] = { type = "multi", text = "全部赛季地下城", short = "赛季大秘", instances = mythics}
    local mythics_and_week = u1copy(mythics, { [ELP_WEEK_RAID] = { bosses = "all" } })
    FILTERS[2] = { type = "multi", text = "全部赛季地下城和宿命团本", short = "本周副本", instances = mythics_and_week }
    local raids = {}; for _, v in ipairs(ELP_SEASON_RAIDS) do raids[v[1]] = { bosses = "all" } end
    FILTERS[3] = { type = "multi", text = "全部团本", instances = raids }
    local all = u1copy(mythics); u1copy(raids, all)
    FILTERS[4] = { type = "multi", text = "全部赛季地下城和全部团本", short = "全部副本", instances = all }

    for i, v in ipairs(ELP_SEASON_MYTHICS) do
        tinsert(FILTERS, { type = "dungeon", text = v[3], instances = { [v[1]] = { bosses = v[4], lootTable = ELP_LOOT_TABLE_LOOTS[v[1]] } }, bosslist = v[5], otherInstances = ELP_LOOT_TABLE_OTHER[v[1]] })
        ELP_CHALLENGE_MAPID_FILTER_INDEX[v[2]] = #FILTERS
    end
    for i, v in ipairs(ELP_SEASON_RAIDS) do
        tinsert(FILTERS, { type = "raid", text = v[3], instances = { [v[1]] = { bosses = v[4] } }})
    end

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