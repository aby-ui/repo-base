U1RegisterAddon("WorldQuestTracker", {
    title = "世界任务增强",
    tags = { TAG_MAPQUEST },
    defaultEnable = 1,

    load = "NORMAL",

    nopic = 1,
    icon = "Interface\\Icons\\Icon_TreasureMap",

    desc = "助您更好的进行破碎群岛世界任务`在世界地图下方会有一行菜单，可以进行操作",

    toggle = function(name, info, enable, justload)
        if justload and IsLoggedIn() then
            GameCooltipFrame1:Hide()
            GameCooltipFrame2:Hide()
        end
        return true
    end,

    {
        text = "配置选项",
        callback = function()
            if not WorldMapFrame.firstRun then
                ToggleWorldMap()
            end
            local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestTrackerAddon", true)
            InterfaceOptionsFrame_OpenToCategory(L["World Quest Tracker"])
        end
    }
});