U1RegisterAddon("Kib_QuestMobs", {
    title = "任务怪物标记",
    defaultEnable = 1,
    load = "LOGIN", --不然刚看到的怪物没有标记

    tags = { TAG_GOOD, TAG_MAPQUEST },
    icon = [[Interface\AddOns\Kib_QuestMobs\media\Config_Icon.tga]],
    nopic = 1,

    desc = "说明`在当前任务所涉及的NPC怪物头上加个大叹号。注意必须开启姓名版才能生效，因为这个图标是依附在姓名版上的，姓名版不显示的时候自然也没有标记。",

    toggle = function(name, info, enable, justload)
        if justload then
            for _, v in ipairs(Kib_TransConfigsTo163()) do
                info[#info+1] = v
            end
            U1DeepInitConfigs(name, info)
            for i=1, #info do
                if info[i].var then
                    U1CfgCallBack(info[i], nil, false)
                end
            end
        end
        return true
    end,

    {
        text = "重置选项",
        lower = false,
        reload = 1,
        confirm = "设置将丢弃并重载界面，是否确定?",
        callback = function(cfg, v, loading)
            local info = U1GetAddonInfo("Kib_QuestMobs")
            for i=1, #info do
                if info[i].var then
                    U1DB.configs[info[i]._path] = nil
                end
            end
            ReloadUI()
        end
    }
});
