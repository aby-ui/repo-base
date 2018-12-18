
local wipe = wipe
local tinsert = table.insert

local db, list

U1RegisterAddon("LiteBuff", {
    title = "职业快捷按钮",
    defaultEnable = 1,
    tags = { TAG_COMBATINFO },
    frames = { 'LiteBuffFrame' },
    optionsAfterVar = 1,
    load = "LOGIN",
    icon = [[Interface\Icons\INV_Relics_Warpring]],
    desc = "Abin的最新作品，针对每个职业配置的快捷施法条。例如潜行者有3个按钮，分别代表主手、副手、远程武器，鼠标滚轮选择要使用的毒药，左键点击是上毒，右键点击是移除毒药。再比如法师开门，也是滚动选择目的地，左键开门，右键自己传送。部分状态类的按钮上，红色表示缺失此状态，黄色表示部分人员缺失，绿色表示齐备。`此外还提供了天赋切换、精炼合计、随机坐骑的按钮。插件完全使用安全模板开发，战斗中不会出错，Abin出品值得信赖。",
    author = "Abin",
    --modifier = "|cffcd1a1c[Warbaby@163]|r",

    toggle = function(name, info, enable, justload)
        if not justload then
            if not InCombatLockdown() then
                CoreUIShowOrHide(LiteBuffFrame, enable)
            end
        end
        if(not InCombatLockdown()) then
            return LiteBuff:RefreshLiteBuffs()
        end
    end,

    {
        var = 'growh',
        text = '横向排列',
        default = 1,
        callback = function(cfg, v, loading)
            if(not loading) then LiteBuff:RefreshLiteBuffs() end
        end,
    },

    {
        var = 'locked',
        text = '锁定位置',
        default = false,
        callback = function(cfg, v, loading)
            LiteBuff.chardb.lock = v
        end,
    },

    {
        var = 'iconsize',
        text = '图标尺寸',
        default = 36,
        type = "spin",
        range = {24, 48, 1},
        callback = function(cfg, v, loading)
            if(not loading) then LiteBuff:RefreshLiteBuffs() end
        end,
    },

    {
        var = 'gap',
        text = '图标间隔',
        default = 4,
        type = "spin",
        range = {-2, 20, 1},
        callback = function(cfg, v, loading)
            if(not loading) then LiteBuff:RefreshLiteBuffs() end
        end,
    },

    {
        type = 'spin',
        var = 'scale',
        text = '缩放',
        range = { .2, 3, .05 }, -- Limit from litebuff itself
        default = 1,
        -- getvalue = function()
        --     if(LiteBuff) then
        --         return LiteBuff.profile.scale / 100
        --     else
        --         return 1
        --     end
        -- end,
        callback = function(cfg, v, loading)
            local scale = v * 100
            if(scale > 300 or scale < 20) then
                scale = 100
            end
            LiteBuff.db.scale = scale
            LiteBuff.frame:SetScale(scale / 100)
        end,
    },
    {
        var = 'simpletip',
        text = '简短提示',
        default = false,
        -- getvalue = function()
        --     return LiteBuff and LiteBuff.db.simpletip
        -- end,
        callback = function(cfg, v, loading)
            LiteBuff.db.simpletip = v
        end,
    },

    {
        type = 'checklist',
        text = '禁用按鈕',
        getvalue = function()
            db = db or {}
            wipe(db)
            for i = 1, LiteBuff:GetNumButtons() do
                local b = LiteBuff:GetButton(i)
                db[b.key] = LiteBuff:LoadData('disabledb', b.key)
            end
            return db
        end, 

        callback = function(cfg, v, loading)
            if(loading) then return end
            db = v
            for key, checked in next, v do
                if(checked ~= LiteBuff:LoadData('disabledb', key)) then
                    LiteBuff:SaveData("disabledb", key, checked)
                    local button = LiteBuff:GetButton(key)
                    if checked then
                        button:Disable()
                    else
                        button:Enable()
                    end
                end
            end
        end, 

        options = function()
            list = list or {}
            wipe(list)
            if(LiteBuff) then
                for i = 1, LiteBuff:GetNumButtons() do
                    local b = LiteBuff:GetButton(i)
                    tinsert(list, b.title)
                    tinsert(list, b.key)
                end
            end
            return list
        end,
        indent = nil,
        cols = 2,
    },

    {
        var = 'alertMissing',
        text = '提示缺失',
        tip = '说明`在屏幕中央提示某些必须且容易遗忘的状态，例如惩戒骑的祝福',
        default = false,
    },

});