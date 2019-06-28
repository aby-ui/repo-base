U1RegisterAddon("DBM_Mods_WoD", {
    title = "DBM德拉诺之王",
    desc = "DBM首领模块, 6.0德拉诺之王副本",
    icon = "Interface\\Icons\\Achievement_Zone_Draenor_01",
    nopic = 1,
    tags = { TAG_RAID },
    defaultEnable = 1,
    nolodbutton = 1,
    toggle = function(name, info, enable, justload)
    end,
});

U1RegisterAddon("DBM-Draenor", {title = '德拉诺世界BOSS', parent = "DBM_Mods_WoD", protected = 1, });
U1RegisterAddon("DBM-Party-WoD", {title = "德拉诺5人本", parent = "DBM_Mods_WoD", protected = 1, });
U1RegisterAddon("DBM-GarrisonInvasions", {title = 'DBM:要塞入侵', parent = "DBM_Mods_WoD", protected = 1, });
U1RegisterAddon("DBM-Highmaul", {title = 'DBM:悬槌堡', parent = "DBM_Mods_WoD", protected = 1, });
U1RegisterAddon("DBM-HellfireCitadel", {title = 'DBM:地狱火堡垒', parent = "DBM_Mods_WoD", protected = 1, });
U1RegisterAddon("DBM-BlackrockFoundry", {title = 'DBM:黑石铸造厂', parent = "DBM_Mods_WoD", protected = 1, });