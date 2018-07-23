
BuildEnv(...)

local ServerDataCache = Addon:NewModule('ServerDataCache', 'AceEvent-3.0')

local nepy = require('NetEasePinyin-1.0')

function ServerDataCache:OnInitialize()
    local AnnData = DataCache:NewObject('AnnData') do
        AnnData:SetCallback('OnCacheChanged', AnnData.SetData)
    end

    local MallData = DataCache:NewObject('MallData') do
        MallData:SetCallback('OnCacheChanged', function(MallData, cache)
            self:FormatMallData(MallData, cache)
        end)
        MallData:SetCallback('OnDataChanged', function(MallData, data)
            self:SendMessage('MEETINGSTONE_MALL_LIST_UPDATED', data, MallData:IsNew())
            MallData:SetIsNew(false)
        end)
    end

    local ActivitiesData = DataCache:NewObject('ActivitiesData') do
        ActivitiesData:SetCallback('OnCacheChanged', function(ActivitiesData, ...)
            self:FormatActivitiesData(ActivitiesData, ...)
        end)
        ActivitiesData:SetCallback('OnDataChanged', function(ActivitiesData, data)
            self:SendMessage('MEETINGSTONE_ACTIVITIES_DATA_UPDATED', data)
        end)
    end

    local FilterData = DataCache:NewObject('FilterData') do
        FilterData:SetCallback('OnCacheChanged', function(FilterData, ...)
            self:FormatFilterData(FilterData, ...)
        end)
        FilterData:SetCallback('OnDataChanged', function(FilterData, data)
            self:SendMessage('MEETINGSTONE_FILTER_DATA_UPDATED', data)
        end)
    end
end

local PLAYER_FACTION = UnitFactionGroup('player') == 'Alliance' and 1 or 2
local function UnpackMallGood(encode)
    if not encode or encode == '' then
        return {id = 0, price = 0}
    end
    local id, priceInfo, item, icon, faction, tip, startTime = strsplit(';', encode)
    local faction = tonumber(faction)
    if faction and faction ~= PLAYER_FACTION then
        return
    end

    local price, originalPrice, smallText = strsplit(',', priceInfo)
    local itemId = tonumber(item)
    local model = icon and tonumber(icon)
    local icon = not model and icon and icon:match('^!(.+)$')
    local tip = tip and tip ~= '' and {strsplit('@', tip)}
    local startTime = tonumber(startTime)
    local name = not itemId and item
    local priceType, price = price:match('^(!?)(%d+)$')

    return {
        id = tonumber(id),
        price = tonumber(price),
        originalPrice = tonumber(originalPrice),
        startTime = tonumber(startTime),
        name = name,
        itemId = itemId,
        model = model,
        icon = icon,
        tip = tip,
        priceType = priceType == '!' and 1 or 2,
        smallText = smallText,
    }
end

local function UnpackGoodList(encode)
    local list = {}
    if encode and encode ~= '' then
        for item in encode:gmatch('[^#]+') do
            local good = UnpackMallGood(item)
            if good then
                tinsert(list, good)
            end
        end
    end
    return list
end

local function UnpackScoreData(data)
    local enable, tabs, gift, mallList, mallData, lotteryItem, lottery = strsplit('`', data or '')
    if enable ~= '1' then
        return {
            noScore = true
        }
    end

    tabs = tonumber(tabs)

    local tabMall = bit.band(tabs, 1) > 0
    local tabLottery = bit.band(tabs, 2) > 0
    local mallList = UnpackGoodList(mallList)
    local mallData = {} do
        for i, v in ipairs(mallList) do
            mallData[v.id] = v
        end
    end
    local lotteryList, lotteryData = {}, {} do
        local lottery = UnpackGoodList(lottery)
        local count = #lottery
        for item in LOTTERY_ORDER:sub((count-2)*MAX_LOTTERY_COUNT+1,(count-1)*MAX_LOTTERY_COUNT):gmatch('.') do
            tinsert(lotteryList, lottery[tonumber(item) + 1])
        end
        for i, v in ipairs(lottery) do
            lotteryData[v.id] = v
        end
    end
    local lotteryId, lotteryPrice do
        local item = UnpackMallGood(lotteryItem)
        lotteryId = item.id
        lotteryPrice = item.price
    end

    return {
        noScore         = false,
        gift            = tonumber(gift),
        tabMall         = tabMall,
        tabLottery      = tabLottery,
        mallList        = mallList,
        mallData        = mallData,
        lotteryId       = lotteryId,
        lotteryPrice    = lotteryPrice,
        lotteryList     = lotteryList,
        lotteryData     = lotteryData,
    }
end

local function UnpackActivityData(data)
    local data = {strsplit('`', data or '')}
    if #data < 7 then
        return
    end

    signup = tonumber(data[7])

    return {
        id              = data[1],
        title           = data[2],
        subtitle        = data[3],
        summary         = SummaryToHtml(FormatActivitiesSummaryUrl(data[4], data[5])),
        url             = data[5],
        bg              = data[6],
        signUpLeader    = bit.band(signup, 1) > 0,
        signUpMember    = bit.band(signup, 2) > 0,
    }
end

function ServerDataCache:FormatMallData(MallData, cache)
    if MallData:GetData() and not MallData:IsNew() then
        return
    end

    local productList = {}

    for k, v in pairs(cache) do
        local categoryText, categoryOrder, new = ('#'):split(k)
        categoryOrder = tonumber(categoryOrder)

        local goods = {('#'):split(v)}

        local category = {
            text = categoryText,
            coord = MALL_CATEGORY_ICON_LIST[categoryOrder % 7],
            new = new,
            item = {},
        }

        for i, item in ipairs(goods) do
            local good = UnpackMallGood(item)
            if good then
                tinsert(category.item, good)
            end
        end

        productList[categoryOrder] = category
    end

    tinsert(productList, {
        text = L['其它游戏兑换'],
        coord = MALL_CATEGORY_ICON_LIST[6],
        item = {
            {
                id = 0,
                priceType = 2,
                name = L['积分兑换平台'],
                title = L['暴雪游戏'],
                model = false,
                itemId = false,
                web = 'http://reward.battlenet.com.cn/',
            },
        }
    })

    MallData:SetData(productList)
end

function ServerDataCache:FormatActivitiesData(ActivitiesData, goodData, ...)
    local data = UnpackScoreData(goodData) or {}

    data.activities = {}

    for i = 1, select('#', ...) do
        local activity = UnpackActivityData((select(i, ...)))
        if activity then
            tinsert(data.activities, activity)
        end
    end
    ActivitiesData:SetData(data)
end

function ServerDataCache:FormatFilterData(FilterData, ...)
    local data = {
        pinyin = {},
        normal = {},
    }

    for i = 1, select('#', ...) do
        local text = select(i, ...)
        if text then
            if text:sub(1,1) == '!' then
                tinsert(data.normal, text:sub(2))
            else
                tinsert(data.pinyin, nepy.topattern(text))
            end
        end
    end
    FilterData:SetData(data)
end
