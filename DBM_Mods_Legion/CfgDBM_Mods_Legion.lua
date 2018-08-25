U1RegisterAddon("DBM_Mods_Legion", {
    title = "DBM军团再临",
    desc = "DBM首领模块, 7.0军团再临",
    icon = "Interface\\Icons\\Shop_Legion",
    nopic = 1,
    tags = { TAG_RAID },
    defaultEnable = 1,
    nolodbutton = 1,
    toggle = function(name, info, enable, justload)
    end,
});

U1RegisterAddon("DBM-AntorusBurningThrone", {title = 'DBM:燃烧王座', parent = "DBM_Mods_Legion", protected = 1, });
U1RegisterAddon("DBM-TombofSargeras", {title = 'DBM:萨格拉斯之墓', parent = "DBM_Mods_Legion", protected = 1, });
U1RegisterAddon("DBM-Nighthold", {title = 'DBM:暗夜要塞', parent = "DBM_Mods_Legion", protected = 1, });
U1RegisterAddon("DBM-TrialofValor", {title = 'DBM:勇气试炼', parent = "DBM_Mods_Legion", protected = 1, });
U1RegisterAddon("DBM-EmeraldNightmare", {title = "DBM:翡翠梦魇", parent = "DBM_Mods_Legion", protected = 1, });
U1RegisterAddon("DBM-Argus", {title = "DBM:阿古斯", parent = "DBM_Mods_Legion", protected = 1, });
U1RegisterAddon("DBM-BrokenIsles", {title = 'DBM:破碎群岛', parent = "DBM_Mods_Legion", protected = 1, });
U1RegisterAddon("DBM-Party-Legion", {title = 'DBM:军团5人本', parent = "DBM_Mods_Legion", protected = 1, });
