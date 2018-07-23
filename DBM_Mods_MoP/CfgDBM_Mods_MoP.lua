U1RegisterAddon("DBM_Mods_MoP", {
    title = "DBM潘达利亚",
    desc = "DBM首领模块, 5.0熊猫人之谜副本",
    icon = "Interface\\Icons\\expansionicon_mistsofpandaria",
    nopic = 1,
    tags = { TAG_RAID },
    defaultEnable = 1,
    nolodbutton = 1,
    toggle = function(name, info, enable, justload)
    end,
});

U1RegisterAddon("DBM-HeartofFear", {title = '恐惧之心', parent = "DBM_Mods_MoP", protected = 1, });
U1RegisterAddon("DBM-MogushanVaults", {title = '魔古山宝库', parent = "DBM_Mods_MoP", protected = 1, });
U1RegisterAddon("DBM-Pandaria", {title = '潘达利亚世界BOSS', parent = "DBM_Mods_MoP", protected = 1, });
U1RegisterAddon("DBM-Party-MoP", {title = "潘达利亚-5人本", parent = "DBM_Mods_MoP", protected = 1, });
U1RegisterAddon("DBM-Scenario-MoP", {title = '熊猫人之谜场景战役', parent = "DBM_Mods_MoP", protected = 1, });
U1RegisterAddon("DBM-SiegeOfOrgrimmarV2", {title = "决战奥格瑞玛", parent = "DBM_Mods_MoP", protected = 1, });
U1RegisterAddon("DBM-TerraceofEndlessSpring", {title = '永春台', parent = "DBM_Mods_MoP", protected = 1, });
U1RegisterAddon("DBM-ThroneofThunder", {title = "雷电王座", parent = "DBM_Mods_MoP", protected = 1, });

U1RegisterAddon("DBM-TimelessIsle", {title = "永恒岛", parent = "DBM_Mods_MoP", protected = 1, });

