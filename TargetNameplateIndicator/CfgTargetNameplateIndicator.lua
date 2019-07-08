U1RegisterAddon("TargetNameplateIndicator", {
    title = "目标姓名板标记",
    defaultEnable = 1,
    load = "LOGIN",  --不然好像会报错

    tags = { TAG_INTERFACE },
    icon = [[Interface\Icons\Ability_Hisek_Aim]],
    nopic = 1,

    desc = "说明`在当前目标头顶显示一个选择的图标, 注意必须开启姓名版才能生效，因为这个图标是依附在姓名版上的，姓名版不显示的时候自然也没有标记。",

    toggle = function(name, info, enable, justload)
        TargetNameplateIndicator:SetOptions()
    end,

    {
        text = "启用动画",
        var = "anim",
        default = true,
        callback = function() TargetNameplateIndicator:SetOptions() end,

        {
            text = "动画幅度",
            var = "bounce_off",
            default = 5,
            type = "spin",
            range = { 5, 50, 5 },
            callback = function() TargetNameplateIndicator:SetOptions() end,
        },
        {
            text = "动画时长",
            var = "bounce_dur",
            default = 0.3,
            type = "spin",
            range = { 0.1, 1, 0.1 },
            callback = function() TargetNameplateIndicator:SetOptions() end,
        }
    },

    {
        text = "选择图标样式",
        var = "tex",
        type = "radio",
        options = {
            "猎人标记", "Hunters_Mark",
            "小地图箭头","deadarrow",
            "圆形准星","Reticule",
            "圆形准星发光","NeonReticule",
            "发光箭头","NeonRedArrow",
            "渐变箭头","RedChevronArrow",
            "加速箭头","PaleRedChevronArrow",
            "圆形标靶","circles_target",
            "绿色锥形","arrow_tip_green",
            "红色锥形","arrow_tip_red",
            "蓝色箭头","BlueArrow",
            "蓝色弧形","bluearrow1",
            "战争机器","gearsofwar",
            "绿色点状","greenarrowtarget",
            "智慧天使","malthael",
            "绿色发光","NeonGreenArrow",
            "红色箭头","NewRedArrow",
            "白色骷髅","NewSkull",
            "紫色弧形","PurpleArrow",
            "红色五星","red_star",
            "盾牌","Shield",
            "大骷髅","skull",
            "新绿色火焰", "Q_FelFlamingSkull",
            "新绿色定位", "Q_GreenGPS",
            "新绿色目标", "Q_GreenTarget",
            "新红色火焰", "Q_RedFlamingSkull",
            "新红色定位", "Q_RedGPS",
            "新红色目标", "Q_RedTarget",
            "新紫色火焰", "Q_ShadowFlamingSkull",
            "新白色定位", "Q_WhiteGPS",
            "新白色目标", "Q_WhiteTarget",
        },
        default = "NeonRedArrow",
        callback = function() TargetNameplateIndicator:SetOptions() end,
    },

    {
        text = "标记大小",
        var = "size",
        default = 40,
        type = "spin",
        range = { 20, 80, 5 },
        callback = function() TargetNameplateIndicator:SetOptions() end,
    },

    {
        text = "水平位置",
        var = "x",
        default = 0,
        type = "spin",
        range = { -80, 80, 5 },
        callback = function() TargetNameplateIndicator:SetOptions() end,
    },

    {
        text = "垂直位置",
        var = "y",
        default = 5,
        type = "spin",
        range = { -80, 80, 5 },
        callback = function() TargetNameplateIndicator:SetOptions() end,
    },

    {
        text = "恢复默认设置",
        lower = false,
        callback = function()
            local addon = "^targetnameplateindicator/"
            for k,v in pairs(U1DB.configs) do
                if k:find(addon) then
                    U1DB.configs[k] = nil
                end
            end
            UUI.Right.TabChange(1)
            TargetNameplateIndicator:SetOptions()
        end
    }
});
