U1RegisterAddon("GearManagerEx", {
    title = "一键换装",
    defaultEnable = 1,
    load = "LOGIN",
    frames = {"GearManagerExToolBarFrame"},
    modifier = "|cffcd1a1c[爱不易]|r, doneykoo",

    tags = { TAG_ITEM, },
    icon = [[Interface\Icons\INV_Gizmo_03]],
    desc = "增强系统默认的换装系统，在人物头像上方显示一键换装工具条，支持图标和数字显示模式。`左键点击快捷栏标题按钮可以一键脱光/穿回，右键点击套装可以设置和天赋绑定（切换天赋时自动装备此套装）、存放到银行等功能。",

    toggle = function(name, info, enable, justload)
        if justload then
            CoreHideOnPetBattle(GearManagerExToolBarFrame)
        end
        return true
    end,

    -------- Options --------
    {
        var = "toolbar",
        default = 1,
        text = "启用换装工具条",
        callback = function(cfg, v, loading) GearManagerEx_OnMenuHide(not v) end,
    },
    {
        text = "一键脱光/穿回",
        callback = function(cfg, v, loading) GearManagerEx:QuickStrip() end,
    },
    {
        text = "按键绑定",
        callback = function(cfg, v, loading) CoreUIShowKeyBindingFrame("HEADER_GEARMANAGEREX_TITLE") end,
    },
    {
        text = '重置快捷条',
        callback = function(cfg, v, loading)
            return loading or GearManagerExToolBarCheckFrameButton and GearManagerExToolBarCheckFrameButton:Click()
        end,
    },
    --]]
});
