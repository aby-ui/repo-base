U1RegisterAddon("DBM_Mods_BfA", {
    title = "DBM争霸艾泽拉斯",
    desc = "DBM首领模块, 8.0争霸艾泽拉斯",
    icon = "Interface\\Icons\\inv_heartofazeroth",
    nopic = 1,
    tags = { TAG_RAID },
    defaultEnable = 1,
    nolodbutton = 1,
    toggle = function(name, info, enable, justload)
    end,
});

U1RegisterAddon("DBM-BfA", { title = "争霸艾泽拉斯世界BOSS", parent = "DBM_Mods_BfA", protected = 1, });
U1RegisterAddon("DBM-Uldir", { title = "奥迪尔副本模块", parent = "DBM_Mods_BfA", protected = 1, });
U1RegisterAddon("DBM-ZuldazarRaid", { title = "达萨罗之战模块", parent = "DBM_Mods_BfA", protected = 1, });
U1RegisterAddon("DBM-CrucibleofStorms", { title = "风暴熔炉模块", parent = "DBM_Mods_BfA", protected = 1, });
U1RegisterAddon("DBM-EternalPalace", { title = "永恒王宫模块", parent = "DBM_Mods_BfA", protected = 1, });
U1RegisterAddon("DBM-Nyalotha", { title = "尼奥罗萨模块", parent = "DBM_Mods_BfA", protected = 1, });
U1RegisterAddon("DBM-Party-BfA", { title = "争霸艾泽拉斯5人副本", parent = "DBM_Mods_BfA", protected = 1, });
