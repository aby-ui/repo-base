U1RegisterAddon("DBM_Mods_Cataclysm", {
    title = "DBM大地的裂变",
    desc = "DBM首领模块, 4.0大地的裂变副本",
    --icon = "Interface\\Icons\\Achievement_Zone_EasternKingdoms_01",
    icon = "Interface\\Icons\\ExpansionIcon_Cataclysm",
    nopic = 1,
    tags = { TAG_RAID },
    defaultEnable = 1,
    nolodbutton = 1,
    toggle = function(name, info, enable, justload)
    end,
});

U1RegisterAddon("DBM-BaradinHold", {title = "巴拉丁监狱", parent = "DBM_Mods_Cataclysm", protected = 1, });
U1RegisterAddon("DBM-BastionTwilight", {title = "暮光堡垒", parent = "DBM_Mods_Cataclysm", protected = 1, });
U1RegisterAddon("DBM-BlackwingDescent", {title = "黑翼血环", parent = "DBM_Mods_Cataclysm", protected = 1, });
U1RegisterAddon("DBM-DragonSoul", {title = "巨龙之魂", parent = "DBM_Mods_Cataclysm", protected = 1, });
U1RegisterAddon("DBM-Firelands", {title = "火源之地", parent = "DBM_Mods_Cataclysm", protected = 1, });
U1RegisterAddon("DBM-Party-Cataclysm", {title = "大灾变5人本", parent = "DBM_Mods_Cataclysm", protected = 1, });
U1RegisterAddon("DBM-ThroneFourWinds", {title = "风神王座", parent = "DBM_Mods_Cataclysm", protected = 1, });