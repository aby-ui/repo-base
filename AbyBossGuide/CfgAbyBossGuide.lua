U1RegisterAddon("AbyBossGuide", {
    title = "副本小攻略",
    defaultEnable = 0,
    frames = {"BossGuideFrame"},

    tags = { TAG_RAID, },
    icon = [[Interface\Icons\INV_Misc_Book_10]],
    desc = "显示五人副本各个BOSS的一句话攻略。`除了手工选择副本查看的功能外，副本中遇到对应的BOSS时，网易攻略框体会闪烁，此时鼠标停在框体上就能看到当前BOSS的攻略。`按ctrl点击可以将此条攻略发送到小队频道。",

    author = "|cffcd1a1c[爱不易原创]|r",

    toggle = function(name, info, enable, justload)
        if enable then BossGuide:Enable() else BossGuide:Disable() end
    end,

});
