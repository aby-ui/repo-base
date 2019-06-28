U1RegisterAddon("ToyPlus", {
    title = "玩具箱",
    tags = { TAG_MANAGEMENT },
    defaultEnable = 0,

    desc = "便捷的玩具窗口，再也不用占用动作条位置了",
    load = "LATER",

    nopic = 1,
    icon = "Interface\\Icons\\INV_Misc_Toy_09",
    minimap = "LibDBIcon10_ToyPlus",

    toggle = function(name, info, enable, justload)
        if justload then
        end
        return true
    end,

    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            InterfaceOptionsFrame_OpenToCategory("ToyPlus")
        end,
    }
});

