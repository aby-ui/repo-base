U1RegisterAddon("DBM_Mods_WotLK", {
    title = "DBM巫妖王之怒",
    desc = "DBM首领模块, 3.0巫妖王之怒副本",
    --icon = "Interface\\Icons\\Achievement_Zone_Northrend_01",
    icon = "Interface\\Icons\\ExpansionIcon_WrathoftheLichKing",
    nopic = 1,
    tags = { TAG_RAID },
    defaultEnable = 1,
    nolodbutton = 1,
    toggle = function(name, info, enable, justload)
    end,
});

U1RegisterAddon("DBM-ChamberOfAspects", {title = "龙眠神殿", parent = "DBM_Mods_WotLK", protected = 1, });
U1RegisterAddon("DBM-Coliseum", {title = "十字军的试炼", parent = "DBM_Mods_WotLK", protected = 1, });
U1RegisterAddon("DBM-EyeOfEternity", {title = "永恒之眼", parent = "DBM_Mods_WotLK", protected = 1, });
U1RegisterAddon("DBM-Icecrown", {title = "冰冠堡垒", parent = "DBM_Mods_WotLK", protected = 1, });
U1RegisterAddon("DBM-Naxx", {title = "纳克萨玛斯", parent = "DBM_Mods_WotLK", protected = 1, });
U1RegisterAddon("DBM-Onyxia", {title = "奥妮克希亚", parent = "DBM_Mods_WotLK", protected = 1, });
U1RegisterAddon("DBM-Party-WotLK", {title = "巫妖王5人本", parent = "DBM_Mods_WotLK", protected = 1, });
U1RegisterAddon("DBM-Ulduar", {title = "奥杜尔", parent = "DBM_Mods_WotLK", protected = 1, });
U1RegisterAddon("DBM-VoA", {title = "阿尔卡冯的宝库", parent = "DBM_Mods_WotLK", protected = 1, });
