U1RegisterAddon("BlizzMove", {
    title = "面板移动",
    desc = "移动系统的界面框体，支持几乎所有的系统面板，如拍卖行、法术书、好友公会等等，并且支持按住SHIFT拖动玩家能量界面，例如骑士圣能、死骑符文、萨满图腾、鹌鹑日蚀、术士灵魂碎片。` `按住Ctrl点击任意面板可以设置是否保存面板位置；Ctrl+Alt+Shift点击可以重置为默认位置；在面板上按住Ctrl并滚动鼠标滚轮可以缩放面板大小。",
    secure = 1,
    load = "LOGIN",
    optdeps = {"Mapster"},
    defaultEnable = 1,

    tags = { TAG_INTERFACE, TAG_CHAT, TAG_DEV },
    icon = [[Interface\Icons\INV_Gizmo_GoblinBoomBox_01]],
    ------- Options --------
    {
        var = "powerbar",
        text = "允许移动职业能量界面",
        tip = "说明`（拖动需要按住SHIFT键）是否允许移动各职业特有的能量界面，包括骑士圣能、死骑符文、萨满图腾、鹌鹑日蚀、术士灵魂碎片，此选项可能会与一些职业专用插件冲突，所以请在遇到问题时关闭。",
        reload = 1,
        default = 1,
        --删除Callback是因为初始DB的情况无法处理，只能用U1GetCfgValue
    },
    {
        var = "movecastbar",
        text = "允许移动施法条",
        tip = "说明`允许移动施法条，施法条出现的时候，用鼠标拖动就可以移了，建议炉石的时候移。注意，开启此选项后，鼠标将无法透过施法条点击，另外此选项可能跟某些插件冲突，导致找不到施法条，请关闭并重载界面。",
        reload = 1,
    },
    {
        text = "重置所有面板位置",
        callback = function(cfg, v, loading)
            BlizzMove_ResetDB();
        end,
    },
});