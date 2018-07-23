U1RegisterAddon("SavedInstances", {
    title = "副本进度查询",
    defaultEnable = 0,
    tags = { TAG_MANAGEMENT, },
    icon = [[Interface\Icons\INV_Pet_SwapPet.png]],
    minimap = "LibDBIcon10_SavedInstances",
    desc = "增加小地图按钮，可以查看帐号下所有角色的副本进度和Boss击杀情况。",
    nopic = 1,
    {
        text = "显示副本进度框",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_SAVEDINSTANCES"]("show") end,
    },
    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList["ACECONSOLE_SAVEDINSTANCES"]("config") end,
    },
});