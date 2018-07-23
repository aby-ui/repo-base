U1RegisterAddon("Easy_Obliterate", {
    title = "抑魔金助手",
    defaultEnable = 1,

    tags = { TAG_ITEM, },
    icon = 1341656,
    nopic = 1,
    desc = "抑魔金界面增强，还可以在按键设置-插件-抑魔金助手里设置热键",
    toggle = function(name, info, enable, justload)
    end,
    --[[{
        text = "按键绑定",
        callback = function(cfg, v, loading) CoreUIShowKeyBindingFrame(BINDING_HEADER_EASYOBLITERATEHEAD) end,
    },]]
});