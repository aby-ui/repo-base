U1RegisterAddon("!KalielsTracker", {
    title = "任务追踪增强",
    tags = { TAG_MAPQUEST, TAG_GOOD },
    defaultEnable = 0,

    modifier = "|cffcd1a1c[爱不易]|r",
    desc = "增强的任务/成就追踪面板：`- 滚动显示更多内容 `- 自动追踪当前地图任务/成就`- 快捷使用任务物品`- 任务进度通报",
    load = "NORMAL", --load = "LATER", --LATER也可以，在justload里有处理，但不一定稳定

    nopic = 1,
    icon = [[Interface\AddOns\!KalielsTracker\Media\KT_logo.tga]],

    toggle = function(name, info, enable, justload)
        if justload then
            if IsLoggedIn() then
                local OTF = ObjectiveTrackerFrame
                OTF:GetScript("OnEvent")(OTF, "PLAYER_ENTERING_WORLD")
                OTF:GetScript("OnEvent")(OTF, "QUEST_WATCH_LIST_CHANGED")
                OTF:GetScript("OnEvent")(OTF, "QUEST_LOG_UPDATE")
            end
        end
        return true
    end,

    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            LibStub("AceAddon-3.0"):GetAddon('!KalielsTracker'):OpenOptions()
        end,
    }
});
