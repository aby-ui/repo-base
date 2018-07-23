
local L = {
    bags = '背包(原始界面)',
    bank = '银行(原始界面)',
    ['char-flyout'] = '装备选择框',
    char = '角色面板',
    gbank = '公会银行(原始界面)',
    inspect = '观察框',
    mail = '邮箱',
    merchant = '商人',
    trade = '商人',
    tradeskill = '商业技能面板',
    loot = '拾取框',
    voidstore = '虚空仓库',
}

local list_of_pipes = {}
local function get_list()
    local list = list_of_pipes
    wipe(list)
    if(oGlow and oGlow.ns.pipesTable) then
        for pipe in next, oGlow.ns.pipesTable do
            tinsert(list, L[pipe] or pipe)
            tinsert(list, pipe)
        end
    end

    return list
end

U1RegisterAddon("oGlow", { 
    title = "物品边框染色",
    tags = {TAG_ITEM},
    defaultEnable = 1,

    desc = "可以对物品图标的边框按品质染色（绿、蓝、紫），支持角色面板的装备图标及装备选择列表、商人购买、原始界面的背包和银行等等，请通过插件选项页进行设置。注意，如果使用了整合背包，则是在整合背包插件中单独设置的。",
    icon = [[Interface\Icons\INV_Bracer_Robe_DungeonRobe_C_05]],
    optionsAfterVar = 1,

    toggle = function(name, info, enable, justload)
        if justload then return end
        local v
        if(not enable) then
            v = {}
        end
        U1CfgCallBack(U1CfgFindChild("oGlow", "oGlowPipes"), v)
    end,

    {
        type = 'checklist',
        var = 'oGlowPipes',
        text = '要按品质染色的框体列表',
        options = get_list,
        indent = nil,
        cols = 2,

--         default = function()
--             local db = {}
--             for k in next, L do
--                 db[k] = true
--             end
--             --for pipe in next, oGlow.ns.pipesTable do
--             --    -- enable all by default
--             --    db[pipe] = true
--             --end
--             return db
--         end,

        getvalue = function()
            local db = {}
            for pipe in next, oGlow.ns.pipesTable do
                if(oGlowDB.EnabledPipes[pipe]) then
                    db[pipe] = true
                else
                    db[pipe] = false
                end
            end
            return db
        end,

        callback = function(cfg, v, loading)
            if(type(v) ~= 'table') then return end
            local db = v

            -- enabled pipes
            for pipe, enabled in next, db do
                if(enabled and oGlow.ns.pipesTable[pipe]) then
                    if(not oGlowDB.EnabledPipes[pipe]) then
                        oGlow:EnablePipe(pipe)
                        oGlow:UpdatePipe(pipe)
                    end
                end
            end

            -- disable pipes
            for pipe in next, oGlowDB.EnabledPipes do
                -- check if it's really been disabled
                if(db[pipe] == false) then
                    oGlow:DisablePipe(pipe)
                    oGlow:UpdatePipe(pipe)
                else
                    db[pipe] = true
                end
            end
        end,
    },

    {
        text="跳转到整合背包设置",
        tip="说明`整合背包的染色是单独设置的",
        callback = function(cfg, v, loading) UUI.OpenToAddon("bagnon") end,
    },

});
