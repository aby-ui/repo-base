local class = UnitClass and select(2, UnitClass("PLAYER"))
U1RegisterAddon("SwingBar", {
    title = "近战攻击条",
    defaultEnable = (class=="WARRIOR" or class=="PALADIN" or class=="DEATHKNIGHT" or class=='MONK'  or class=='DEMONHUNTER') and 0 or 0,
    frames = {"SwingBar"},

    tags = { TAG_CLASS, TAG_WARRIOR, TAG_PALADIN, TAG_ROGUE, TAG_DEATHKNIGHT, TAG_DRUID, TAG_SHAMAN, TAG_MONK, TAG_DEMONHUNTER, TAG_HUNTER },
    icon = [[Interface\Icons\INV_AXE_25]],
    desc = "仅占用8K的近战攻击进度条，支持副手武器。默认位置在施法条上方，控制台中可锁定/解锁，及调整大小和材质。",
    --pics = 2, -- 一共多少张图片，都在图片Pics/插件名.tga里，高度128，宽度200。
    --picsWidth = 1024, -- 图片材质的宽度，默认为1024，可以存两张图

    toggle = function(name, info, enable, justload)
        SwingBar_Toggle(enable)
    end,

    {
        var = "lock",
        text = "锁定位置",
        default = nil,
        callback = function(cfg, v, loading)
            SwingBar:EnableMouse(not v);
        end
    },
    {
        var = "width",
        default = 180,
        text = "计时条宽度",
        type = "spin",
        range = {100, 500, 10},
        callback = function(cfg, v, loading)
            SwingBar:SetWidth(v);
            WW(SwingBar.main):On("Show"):un();
            WW(SwingBar.off):On("Show"):un();
        end,
    },
    {
        var = "height",
        default = 17,
        text = "计时条高度",
        type = "spin",
        range = {15, 30, 1},
        callback = function(cfg, v, loading)
            SwingBar:SetHeight(v);
            WW(SwingBar.main):On("Show"):un();
            WW(SwingBar.off):On("Show"):un();
        end,
    },
    {
        var = "offheight",
        default = 4,
        text = "副手计时条高度",
        tip = "说明`副手计时条会智能显示，如果设置成0则永远隐藏。",
        type = "spin",
        range = {0, 15, 1},
        callback = function(cfg, v, loading)
            if v<=0 then
                SwingBar.off:SetHeight(0.01);
                SwingBar.off:Hide();
            else
                SwingBar.off:Show();
                SwingBar.off:SetHeight(v);
            end
            WW(SwingBar.off):On("Show"):un();
        end,
    },
    {
        var = "tex",
        text = "修改计时条材质",
        type = "drop",
        default = "Interface\\TargetingFrame\\UI-StatusBar",
        options = CtlSharedMediaOptions("statusbar"),
        callback = function(cfg, v, loading)
            SwingBar.main:SetStatusBarTexture(v);
            SwingBar.off:SetStatusBarTexture(v);
        end,
    },
    {
        text = "重置位置",
        callback = function(cfg, v, loading)
            WW(SwingBar):ClearAllPoints():BOTTOM("CastingBarFrame","TOP",0,"20"):un()
        end,
    },
});
