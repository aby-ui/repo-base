U1RegisterAddon("TidyPlates", {
    title = "美化姓名版",
    defaultEnable = 0,
    load = "NORMAL",
    optionsAfterLogin = 1,
    minimap = "LibDBIcon10_TidyPlatesIcon",

    tags = { TAG_INTERFACE, TAG_BIG, },
    icon = [[Interface\AddOns\TidyPlates\media\TidyPlatesIcon]],
    desc = "強大到爆的多功能姓名版美化插件。``设置口令：/tidyplates",
    nopic = 1,

    toggle = function(name, info, enable, justload)
        if justload and IsLoggedIn() then
            for i, frame in ipairs(C_NamePlate.GetNamePlates()) do
                Export163_OnNewNameplate(frame)
            end
        end
        if justload then
            --/run for k,v in pairs(TidyPlatesHubSettings) do v.force0913 = nil end
            for k,v in pairs(TidyPlatesHubSettings or {}) do
                if not v.force0913 and v.WidgetsDebuffTrackList then
                    v.force0913 = true
                    --if not v.WidgetsDebuffTrackList:find("戈霍恩共生体") then v.WidgetsDebuffTrackList = v.WidgetsDebuffTrackList .. "\n" .. "All 戈霍恩共生体" end
                    if not v.WidgetsDebuffTrackList:find("闪电之盾") then v.WidgetsDebuffTrackList = v.WidgetsDebuffTrackList .. "\n" .. "All 闪电之盾" end
                    TidyPlatesHubHelpers.ConvertDebuffListTable(v.WidgetsDebuffTrackList, v.WidgetsDebuffLookup, v.WidgetsDebuffPriority)
                end
            end
        end
        return true
    end,

    {
        text = "小地图按钮",
        type = "checkbox",
        var = "minimap",
        default = true,
        callback = function(cfg, v, loading)
            TidyPlatesOptions._EnableMiniButton = v
            if v then
                if not LibDBIcon10_TidyPlatesIcon then
                    TidyPlatesUtility:CreateMinimapButton()
                end
                TidyPlatesUtility:ShowMinimapButton()
            else
                if LibDBIcon10_TidyPlatesIcon then LibDBIcon10_TidyPlatesIcon:Hide() end
            end
        end
    },
    {
        text = "配置选项",
        callback = function(cfg, v, loading) slash_TidyPlates() end
    },
    {
        text = "重置所有控制台设定",
        callback = function(cfg, v, loading)
            TidyPlatesOptions = nil;
            TidyPlatesHubCache = nil;
            TidyPlatesHubGlobal = nil;
            TidyPlatesHubSettings = nil;
            TidyPlatesWidgetData = nil; 
            ReloadUI();
        end,
    },
    --[[
    {
        text = "支持在姓名板上显示个人资源",
        tip = "说明`开启此选项并在'界面-名字'中开启'在敌方目标上显示玩家的特殊资源'后，可以在TidyPlates的姓名板上显示。`注意，此功能和敌方DEBUFF同时显示时会有问题。",
        var = "resourceBar",
        default = false,
        callback = function(cfg, v, loading)
            if loading then
                CoreDependCall("Blizzard_NamePlates", function()
                    if NamePlateTargetResourceFrame then
                        hooksecurefunc(NamePlateTargetResourceFrame, "SetParent", function(self, parent)
                            if not self._settingByUs and U1GetCfgValue(cfg._path) then
                                self._settingByUs = 1
                                self:SetParent(parent:GetParent())
                                self._settingByUs = nil
                            end
                        end)
                    end
                end)
            end
        end
    }
    --]]

});

U1RegisterAddon("TidyPlatesWidgets", { protected = 1, load = "NORMAL" })
U1RegisterAddon("TidyPlatesHub", { protected = 1, load = "NORMAL" })
