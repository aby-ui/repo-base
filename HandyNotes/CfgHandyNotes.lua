U1RegisterAddon("HandyNotes", {
    title = "地图标记",
    tags = { TAG_MAPQUEST, TAG_BIG },
    defaultEnable = 0,
    load = "LATER",
    optionsAfterLogin = 1,

    icon = [[Interface\Icons\Ability_Hunter_MarkedForDeath]],
    desc = "一个小巧且全能的地图标记注释功能类插件.``ALT+右键 添加一个注释标记`Ctrl+Shift+拖拽 移动已经添加的注释标记```设置口令：/handynotes",
    nopic = 1,

    toggle = function(name, info, enable, justload)
        if justload then
            local function hook(overlayFrame)
                local plugins = { "HandyNotes_MechagonAndNazjatar", "HandyNotesArgus", "HandyNotes_VisionsOfNZoth", "LegionRaresTreasures", "BattleForAzerothTreasures" }
                hooksecurefunc(overlayFrame, 'InitializeDropDown', function(self)
                    local function OnSelection(button)
                        self:OnSelection(button.value, button.checked);
                    end

                    UIDropDownMenu_AddSeparator();
                    local info = UIDropDownMenu_CreateInfo();

                    info.notCheckable = nil;
                    info.isNotRadio = true;
                    info.keepShownOnClick = true;
                    info.func = OnSelection;

                    info.text = "显示HandyNotes宝箱稀有";
                    info.value = "ShowHandyNotesRares";
                    local db = HandyNotes.db.profile
                    db.enabledPlugins = db.enabledPlugins or {}
                    info.checked = true
                    for _, k in pairs(plugins) do
                        if db.enabledPlugins[k] == false then
                            info.checked = false
                        end
                    end
                    UIDropDownMenu_AddButton(info);
                end)

                local origOverlayFrame_onSelection = overlayFrame.OnSelection;
                overlayFrame.OnSelection = function(self, value, checked)
                    if (value == "ShowHandyNotesRares") then
                        if IsModifierKeyDown() then
                            LibStub("AceConfigDialog-3.0"):Open("HandyNotes")
                            LibStub("AceConfigDialog-3.0"):SelectGroup("HandyNotes", "plugins")
                        end
                        local db = HandyNotes.db.profile
                        db.enabledPlugins = db.enabledPlugins or {}
                        for _, k in pairs(plugins) do
                            local old = db.enabledPlugins[k]
                            if old == nil then old = true end
                            db.enabledPlugins[k] = checked
                            if (checked and true or false) ~= old then
                                HandyNotes:UpdatePluginMap(nil, k)
                            end
                        end
                    end
                    origOverlayFrame_onSelection(self, value, checked)
                end
            end

            for _, overlayFrame in next, WorldMapFrame.overlayFrames do
                if(overlayFrame.Border and overlayFrame.Border:GetTexture() == 'Interface\\Minimap\\MiniMap-TrackingBorder') then
                    hook(overlayFrame)
                    break
                end
            end
        end
    end,

    {
        text = "配置选项",
        callback = function()
            LibStub("AceConfigDialog-3.0"):Open("HandyNotes")
            LibStub("AceConfigDialog-3.0"):SelectGroup("HandyNotes", "plugins")
        end
    },
    {
        text = "重置数据",
        tip = "说明`为了加快载入速度，爱不易修改HandyNotes每个版本只查询一次数据，把数据保存起来，如果有问题请重置一下",
        reload = 1,
        callback = function()
            HandyNotesDB._mapData = nil
            U1Message("数据已重置，请重载界面")
        end
    }
});

U1RegisterAddon("HandyNotes_VisionsOfNZoth", {
    title = "恩佐斯幻象(8.3)",
    defaultEnable = 1,
    load = "LATER",
});

U1RegisterAddon("HandyNotes_MechagonAndNazjatar", {
    title = "麦卡贡和纳沙塔尔(8.2)",
    defaultEnable = 1,
    load = "LATER",
});

U1RegisterAddon("HandyNotes_WarfrontRares", {
    title = "战争前线稀有位置(8.1)",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_BattleForAzerothTreasures", {
    title = "争霸艾酱地图宝箱(8.0)",
    defaultEnable = 1,
    load = "LATER",
    desc = "在8.0新地图上显示宝藏和稀有精英的位置, 数据量很大, 可能会造成卡顿, 请在需要时开启.",
})

U1RegisterAddon("HandyNotes_Argus", {
    title = "阿古斯地图宝箱(7.3)",
    defaultEnable = 0,
    load = "LATER",
    modifier = "Vincero@NGA汉化",
})

U1RegisterAddon("HandyNotes_LegionRaresTreasures", {
    title = "军团再临地图宝箱(7.0)",
    defaultEnable = 0,
    load = "LATER",
    desc = "在军团再临地图上显示宝藏和稀有精英的位置, 数据量很大, 可能会造成卡顿, 请在需要时开启.",
    modifier = "Vincero@NGA汉化",
})

U1RegisterAddon("HandyNotes_SuramarTelemancy", {
    title = "苏拉玛传送门(7.0)",
    desc = "苏拉玛传送门及魔网标记, NGA网友karlock汉化补充",
    modifier = "karlock",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_DraenorTreasures", {
    title = "德拉诺地图宝箱(6.0)",
    defaultEnable = 0,
    load = "LATER",
    desc = "在德拉诺地图上显示宝藏和稀有精英的位置, 数据量很大, 可能会造成卡顿, 请在需要时开启.",
    modifier = "Vincero@NGA汉化",
})

U1RegisterAddon("HandyNotes_HallowsEnd", {
    title = "万圣节糖罐位置",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_SummerFestival", {
    title = "仲夏节篝火位置",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_LunarFestival", {
    title = "春节长者位置",
    defaultEnable = 1,
    load = "LATER",
})

U1RegisterAddon("HandyNotes_DungeonLocations", {
    title = "老地图副本入口",
    defaultEnable = 1,
    load = "LATER",
})
