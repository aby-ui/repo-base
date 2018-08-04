
local LDB = LibStub and LibStub'LibDataBroker-1.1'
local tinsert = table.insert

local ChocolateBar
local get_ChocolateBar = function()
    ChocolateBar = ChocolateBar or LibStub'AceAddon-3.0':GetAddon('ChocolateBar', true --[[quiet]])
    return ChocolateBar
end

local L = setmetatable({
}, {__index = function(t, k)
    local addon_title = U1GetAddonInfo(k) and U1GetAddonTitle(k)
    t[k] = addon_title and addon_title:gsub("数据源：", "") or k
    return t[k]
end})

local function cleanup(dst)
    dst = dst or {}
    wipe(dst)
    return dst
end

local all_objs = {}
if(LDB) then
    local function add(e, n, o)
        if(o.type == 'data source' or o.type == 'launcher') then
            all_objs[n] = o
        end
    end
    LDB:RegisterCallback('LibDataBroker_DataObjectCreated', add)

    for name, obj in LDB:DataObjectIterator() do
        add('Loading', name, obj)
    end
end

local dbs = {}
local optlists = {}

local function get_option(_type)
    local list = optlists[_type] or {}
    optlists[_type] = list
    cleanup(list)

    for name, obj in next, all_objs do
        if(obj.type == _type) then
            tinsert(list, obj.configname or (obj.label and L[obj.label]) or L[name])
            tinsert(list, name)
        end
    end

    return list
end

local function get_db(_type)
    local list = dbs[_type] or {}
    dbs[_type] = list

    if(not get_ChocolateBar()) then return list end
    cleanup(list)

    for name, obj in next, all_objs do
        if(obj.type == _type) then
            local settings = ChocolateBar.db.profile.objSettings[name]
            if(settings and settings.enabled) then
                list[name] = true
            end
        end
    end

    return list
end

local function set_db(_type, cfg, db, loading)
    if(type(db) ~= 'table') then return end
    dbs[_type] = db
    if(not get_ChocolateBar()) then return end

    local objSettings = ChocolateBar.db.profile.objSettings

    for name in next, db do
        if(not (objSettings[name] and objSettings[name].enabled)) then
            ChocolateBar:EnableDataObject(name, all_objs[name])
        end
    end

    for name, set in next, objSettings do
        --     it's in all_objs so it exists
        if((all_objs[name] and all_objs[name].type == _type) and (set.enabled) and (not db[name])) then
            ChocolateBar:DisableDataObject(name)
        end
    end
end



local default = function()
    return nil
end

U1RegisterAddon("ChocolateBar", {
    title = "巧克力信息条",
    defaultEnable = 1,
    load = "LOGIN",

    tags = { TAG_MANAGEMENT, TAG_BIG },
    icon = [[Interface\Icons\Item_elementiumbar]],
    desc = "一个轻量的信息条插件，占用很小功能齐全。支持各种DataBroker数据源，其中爱不易精选了一些常用的，如世界战场、内存延迟等，用户也可自行添加。`按住信息条上的内容并拖动，可以调整左中右位置及具体顺序，拖到下面的禁用图标里可以关闭此内容。`右键点击信息条可以打开设置界面（此功能可配置）。可修改背景材质、高度、字体等选项，并可以创建新的动作条。在插件栏目里可以调整特定信息的图标大小、偏移等。",

    toggle = function(name, info, enable, justload)
        if(justload) then
            for _, v in U1IterateAllAddons() do
                if v.parent == name then v.toggle = v.toggle or noop end --关闭时不提示reload
            end
            if(not get_ChocolateBar()) then return end
            function ChocolateBar:UI_SCALE_CHANGED()
                for name,bar in pairs(self:GetBars()) do
                    bar:UpdateTexture(self.db.profile)
                end
            end
            ChocolateBar:RegisterEvent("UI_SCALE_CHANGED")
        else
            if(ChocolateBar) then
                if(enable) then
                    ChocolateBar:Enable()
                else
                    ChocolateBar:Disable()
                end
            end
        end
    end,

    {
        type = 'button',
        text = '配置选项',
        callback = function()
            get_ChocolateBar():LoadOptions(nil)
        end
    },

    -- {
    --     type = 'checklist',
    --     text = '选择信息条上的内容',
    --     getvalue = get,
    --     options = options,
    --     callback = set,
    --     indent = nil,
    --     cols = 2,
    --     defauilt = default,
    -- },

    {
        type = 'checklist',
        text = '选择信息条上的提示信息',
        getvalue = function() return get_db'data source' end,
        callback = function(...) return set_db('data source', ...) end,
        options = function() return get_option'data source' end,
        indent = nil,
        cols = 2,
    },

    {
        type = 'checklist',
        text = '选择信息条上的快捷按钮',
        getvalue = function() return get_db'launcher' end,
        callback = function(...) return set_db('launcher', ...) end,
        options = function() return get_option'launcher' end,
        indent = nil,
        cols = 2,
    },

    {
        type = 'button',
        text = '重置配置',
        confirm = "本插件所有设置将清除，无法恢复。请问您是否确定？",
        callback = function()
            ChocolateBarDB = nil ReloadUI();
        end
    },

});

--U1RegisterAddon('', {title = '', parent = 'ChocolateBar'})
U1RegisterAddon('ChocolateBar_Options', {title = '巧克力-设置', protected = 1, hide= 1})
U1RegisterAddon('Broker_CPU', {title = '数据源：内存帧数延迟', parent = 'ChocolateBar', minimap = "LibDBIcon10_Broker_CPU"})
U1RegisterAddon('picoEXP', {title = '数据源：升级经验统计', parent = 'ChocolateBar'})
U1RegisterAddon('Broker_Group', {title = '数据源：组队与掷骰', parent = 'ChocolateBar'})
U1RegisterAddon('Broker_Raidsave', {title = '数据源：副本进度', parent = 'ChocolateBar'})
U1RegisterAddon('Broker_DurabilityInfo', {title = '数据源：装备耐久', parent = 'ChocolateBar'})
U1RegisterAddon('Broker_Equipment', {title = '数据源：套装管理', parent = 'ChocolateBar'})
U1RegisterAddon('Broker_MicroMenu', {title = '数据源：延迟帧数及菜单', parent = 'ChocolateBar', defaultEnable = 0 })
U1RegisterAddon('Broker_Currency', {title = '数据源：金钱货币显示', parent = 'ChocolateBar',
    {
        text = "选择显示货币",
        callback = function() CoreIOF_OTC(Broker_Currency.menu) end
    }
})
--U1RegisterAddon('Broker_Garrison', {title = '数据源：要塞管家', parent = 'ChocolateBar', defaultEnable = 0})


