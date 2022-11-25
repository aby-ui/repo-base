U1RegisterAddon("DressingSlots", {
    title = "试穿助手",
    defaultEnable = 1,
    tags = { TAG_ITEM, },
	nopic= 1,
    desc = "可缩放试穿界面，并增加多个实用按钮，可以试穿目标装备，或将以目标为模特试穿自身装备，并且可以脱掉单件装备。",
    icon = [[Interface\Icons\INV_Gizmo_NewGoggles]],

    {
        text = "显示试穿窗口",
        callback = function()
            DressUpFrame_Show(DressUpFrame)
        end
    }
});

