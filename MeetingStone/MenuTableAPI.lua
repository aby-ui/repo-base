
BuildEnv(...)

local makedCategorys = {}
local validCategorys = {}
local currentCodeCache

local historyMenuTables
local activityCodeCaches

do
    local function f()
        return {
            [ACTIVITY_FILTER_BROWSE] = {},
            [ACTIVITY_FILTER_CREATE] = {},
            [ACTIVITY_FILTER_OTHER]  = {},
        }
    end

    historyMenuTables = f()
    activityCodeCaches = f()
end

local function initValidCategorys()
    wipe(validCategorys)
    for i, baseFilter in ipairs({LE_LFG_LIST_FILTER_PVE, LE_LFG_LIST_FILTER_PVP}) do
        for _, categoryId in ipairs(C_LFGList.GetAvailableCategories(baseFilter)) do
            validCategorys[categoryId] = true
        end
    end
end

local function isCategoryValid(categoryId)
    return validCategorys[categoryId]
end

local function MakeActivityMenuTable(activityId, baseFilter, customId, ...)
    local fullName, _, categoryId, groupId, _, filters = C_LFGList.GetActivityInfo(activityId)

    if customId then
        fullName = ACTIVITY_CUSTOM_NAMES[customId]
    end

    local data      = {}
    data.text       = fullName
    data.fullName   = fullName
    data.categoryId = categoryId
    data.groupId    = groupId
    data.activityId = activityId
    data.customId   = customId
    data.filters    = filters
    data.baseFilter = baseFilter
    data.value      = GetActivityCode(activityId, customId, categoryId, groupId)

    data.tooltipTitle, data.tooltipText = ...
    data.tooltipOnButton = select('#', ...) > 0 or nil

    currentCodeCache[data.value] = data
    return data
end

local function MakeCustomActivityMenuTable(activityId, baseFilter, customId)
    local data = MakeActivityMenuTable(activityId, baseFilter, customId)

    local customData = ACTIVITY_CUSTOM_DATA.A[activityId]
    if customData and not customId then
        data.menuTable = {}
        data.hasArrow  = true

        for _, id in ipairs(customData) do
            tinsert(data.menuTable, MakeActivityMenuTable(activityId, baseFilter, id))
        end
    end
    return data
end

local function isClickable(menuType)
    if menuType == ACTIVITY_FILTER_BROWSE then
        return true
    elseif menuType == ACTIVITY_FILTER_OTHER then
        return true
    end
end

local function MakeGroupMenuTable(categoryId, groupId, baseFilter, menuType)
    local data = {}
    data.text = C_LFGList.GetActivityGroupInfo(groupId)
    data.fullName = data.text
    data.categoryId = categoryId
    data.groupId = groupId
    data.baseFilter = baseFilter
    -- data.notClickable = categoryId == 1 or not isClickable(menuType)
    data.notClickable = true
    data.value = not data.notClickable and GetActivityCode(nil, nil, categoryId, groupId)
    data.tooltipTitle = L['请选择具体副本难度']
    data.tooltipOnButton = true

    if data.value then
        currentCodeCache[data.value] = data
    end

    local menuTable = {}
    local shownActivities = {}

    for _, activityId in ipairs(C_LFGList.GetAvailableActivities(categoryId, groupId)) do
        tinsert(menuTable, MakeCustomActivityMenuTable(activityId, baseFilter))
        shownActivities[activityId] = true
    end

    local customData = ACTIVITY_CUSTOM_DATA.G[groupId]
    if customData then
        for _, id in ipairs(customData) do
            local activityId = ACTIVITY_CUSTOM_IDS[id]
            if activityId and shownActivities[activityId] then
                tinsert(menuTable, MakeActivityMenuTable(activityId, baseFilter, id))
            end
        end
    end

    if #menuTable > 0 then
        data.menuTable = menuTable
        data.hasArrow = true
    end
    return data
end

local function MakeVersionMenuTable(categoryId, versionId, baseFilter, menuType)
    local data = {}
    data.text = _G['EXPANSION_NAME'..versionId]
    data.notClickable = true

    local menuTable = {}

    for _, groupId in ipairs(C_LFGList.GetAvailableActivityGroups(categoryId)) do
        -- print(versionId, groupId)
        if CATEGORY[versionId] and CATEGORY[versionId].groups[groupId] then
            tinsert(menuTable, MakeGroupMenuTable(categoryId, groupId, baseFilter, menuType))
        end
    end

    for _, activityId in ipairs(C_LFGList.GetAvailableActivities(categoryId)) do
        if CATEGORY[versionId] and CATEGORY[versionId].activities[activityId] and select(4, C_LFGList.GetActivityInfo(activityId)) == 0 then
            tinsert(menuTable, MakeCustomActivityMenuTable(activityId, baseFilter))
        end
    end

    if #menuTable > 0 then
        data.menuTable = menuTable
        data.hasArrow  = true
    else
        return
    end
    return data
end

local function MakeCategoryMenuTable(categoryId, baseFilter, menuType)
    local name, _, autoChoose = C_LFGList.GetCategoryInfo(categoryId)
    local data = {}
    data.text = name
    data.categoryId = categoryId
    data.baseFilter = baseFilter
    data.notClickable = not isClickable(menuType)
    data.value = not data.notClickable and GetActivityCode(nil, nil, categoryId)

    if data.value then
        currentCodeCache[data.value] = data
    end

    local menuTable = {}
    makedCategorys[categoryId] = true

    if categoryId == 2 or categoryId == 3 then
        -- for i = #MAX_PLAYER_LEVEL_TABLE, 0, -1 do
        for i = 7, 0, -1 do
            local versionMenu = MakeVersionMenuTable(categoryId, i, baseFilter, menuType)
            if versionMenu then
                tinsert(menuTable, versionMenu)
            end
        end
    elseif autoChoose and categoryId ~= 6 then
        return MakeCustomActivityMenuTable(C_LFGList.GetAvailableActivities(categoryId)[1], baseFilter)
    else
        local list = C_LFGList.GetAvailableActivityGroups(categoryId)
        local s, e, step = 1, #list, 1
        if categoryId == 1 then
            s, e, step = e, s, -1
        end
        for i = s, e, step do
            tinsert(menuTable, MakeGroupMenuTable(categoryId, list[i], baseFilter, menuType))
        end
        for _, activityId in ipairs(C_LFGList.GetAvailableActivities(categoryId)) do
            if select(4, C_LFGList.GetActivityInfo(activityId)) == 0 then
                tinsert(menuTable, MakeCustomActivityMenuTable(activityId, baseFilter))
            end
        end
    end

    if #menuTable > 0 then
        data.menuTable = menuTable
        data.hasArrow  = true
    end

    return data
end

local PACKED_CATEGORYS = {
    ['PvP'] = {
        4, 7, 8, 9, 10,
        key = 'packedPvp',
    }
}

local function FindPacked(categoryId)
    for key, v in pairs(PACKED_CATEGORYS) do
        if Profile:GetSetting(v.key) then
            for _, c in ipairs(v) do
                if c == categoryId then
                    return key
                end
            end
        end
    end
end

local function MakePackedCategoryMenuTable(key, baseFilter, menuType)
    local menuTable = {
        text = key,
        hasArrow = true,
        notClickable = true,
        menuTable = {}
    }

    for _, categoryId in ipairs(PACKED_CATEGORYS[key]) do
        if isCategoryValid(categoryId) then
            tinsert(menuTable.menuTable, MakeCategoryMenuTable(categoryId, baseFilter, menuType))
        end
    end

    return menuTable
end

local function MakeMenuTable(list, baseFilter, menuType)
    list = list or {}

    for _, categoryId in ipairs(C_LFGList.GetAvailableCategories(baseFilter)) do
        if makedCategorys[categoryId] then

        else
            local packed = FindPacked(categoryId)
            if packed then
                tinsert(list, MakePackedCategoryMenuTable(packed, baseFilter, menuType))
            elseif categoryId ~= 6 or baseFilter ~= LE_LFG_LIST_FILTER_PVE then
                tinsert(list, MakeCategoryMenuTable(categoryId, baseFilter, menuType))
            end
        end
    end

    return list
end

function GetActivitesMenuTable(menuType)
    currentCodeCache = wipe(activityCodeCaches[menuType])
    wipe(makedCategorys)
    initValidCategorys()

    local list = {}
    MakeMenuTable(list, LE_LFG_LIST_FILTER_PVE, menuType)
    MakeMenuTable(list, LE_LFG_LIST_FILTER_PVP, menuType)

    if menuType == ACTIVITY_FILTER_BROWSE or menuType == ACTIVITY_FILTER_CREATE then
        tinsert(list, 1, {
            text = menuType == ACTIVITY_FILTER_CREATE and L['|cff00ff00最近创建|r'] or L['|cff00ff00最近搜索|r'],
            notClickable = true,
            hasArrow = true,
            menuTable = RefreshHistoryMenuTable(menuType),
        })
    end

    -- if UnitLevel('player') >= 70 then
    --     if menuType == ACTIVITY_FILTER_CREATE then
    --         tinsert(list, {
    --             text         = L['单刷'],
    --             notClickable = true,
    --             hasArrow     = true,
    --             menuTable    = {
    --                 MakeActivityMenuTable(
    --                     ACTIVITY_CUSTOM_IDS[SOLO_HIDDEN_CUSTOM_ID],
    --                     LE_LFG_LIST_FILTER_PVP,
    --                     SOLO_HIDDEN_CUSTOM_ID,
    --                     ACTIVITY_CUSTOM_NAMES[SOLO_HIDDEN_CUSTOM_ID],
    --                     L['单刷开团，不会被其他玩家干扰。']
    --                 ),
    --                 MakeActivityMenuTable(
    --                     ACTIVITY_CUSTOM_IDS[SOLO_VISIBLE_CUSTOM_ID],
    --                     LE_LFG_LIST_FILTER_PVE,
    --                     SOLO_VISIBLE_CUSTOM_ID,
    --                     ACTIVITY_CUSTOM_NAMES[SOLO_VISIBLE_CUSTOM_ID],
    --                     L['这个活动可以被玩家搜索到。']
    --                 )
    --             }
    --         })
    --     elseif menuType == ACTIVITY_FILTER_BROWSE then
    --         tinsert(list, MakeActivityMenuTable(
    --             ACTIVITY_CUSTOM_IDS[SOLO_VISIBLE_CUSTOM_ID],
    --             LE_LFG_LIST_FILTER_PVP,
    --             SOLO_VISIBLE_CUSTOM_ID,
    --             ACTIVITY_CUSTOM_NAMES[SOLO_VISIBLE_CUSTOM_ID]
    --         ))
    --     end
    -- end
    return list
end

function RefreshHistoryMenuTable(menuType)
    local menuTable = wipe(historyMenuTables[menuType])
    local currentCodeCache = activityCodeCaches[menuType]
    local list = Profile:GetHistoryList(menuType == ACTIVITY_FILTER_CREATE)

    for _, value in ipairs(list) do
        local data = currentCodeCache[value]
        if data then
            tinsert(menuTable, {
                categoryId = data.categoryId,
                groupId    = data.groupId,
                activityId = data.activityId,
                customId   = data.customId,
                filters    = data.filters,
                baseFilter = data.baseFilter,
                value      = data.value,
                text       = data.text,
                fullName   = data.fullName,
            })
        end
    end

    if #menuTable == 0 then
        tinsert(menuTable, {
            text     = L['暂无'],
            disabled = true,
        })
    end

    return menuTable
end
