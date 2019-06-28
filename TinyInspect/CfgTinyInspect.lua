U1RegisterAddon("TinyInspect", {
    title = "装等显示",
    defaultEnable = 1,
    load = 'LOGIN',

    tags = { TAG_ITEM },
    icon = [[Interface\Icons\Item_spellclothbolt]],
    desc = "国人作者loudsoul的Tiny系列插件之TinyInspect，在你能想到的所有地方，显示物品装等信息，"
    .. "包括人物面板、观察面板、背包物品、聊天链接、公会拾取、鼠标提示、商人出售、拍卖行等等等等，插件别名就是《到处都有装等》。"
    .. "`爱不易整合此插件取代了之前的背包装等、鼠标提示装等、装备边框染色等好几个插件。为了一些风格的统一，稍微改动了一下默认设置和配色等小地方，在此对原作者表示感谢。",
    nopic = 1,
    toggle = function(name, info, enable, justload) end,

    {
        text = "配置选项",
        callback = function(cfg, v, loading) SlashCmdList.TinyInspect("") end,
    },
    {
        text = "团队面板",
        tip = "说明`启用团队装等选项后，/ti raid可以显示团员的装等列表，不过爱不易用户也可以使用团员信息统计",
        callback = function(cfg, v, loading) SlashCmdList.TinyInspect("raid") end,
    },
    {
        text = "恢复默认设置",
        tip = "说明`爱不易整合的TinyInspect和原有插件功能保持一致，只是调整了一些默认值，如果你之前使用过单体的TinyInspect，建议重置一下选项。",
        confirm = "即将清除此插件的相关设置，会自动重载，请确定",
        callback = function(cfg, v, loading) TinyInspectDB = nil ReloadUI() end,
    },

});