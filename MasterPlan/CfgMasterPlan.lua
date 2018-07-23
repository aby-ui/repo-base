U1RegisterAddon("MasterPlanA", {
    title = "要塞任务大师",
    defaultEnable = 0,

    tags = { TAG_MANAGEMENT },
    icon = [[Interface\Icons\UI_Promotion_Garrisons]],
    desc = "修改并简化追随者任务面板的操作。",
    nopic = true,
});

U1RegisterAddon("MasterPlan", {
    protected = 1,
    hide = 1,
    loadWith = "Blizzard_GarrisonUI",
    nolodbutton = 1,
});