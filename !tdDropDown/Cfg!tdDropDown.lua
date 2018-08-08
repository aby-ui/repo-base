U1RegisterAddon("!tdDropDown", {
    title = "下拉菜单增强",
    defaultEnable = 1,

    tags = { TAG_INTERFACE },
    modifier = "|cffcd1a1c[爱不易]|r",

    desc = "在邮箱收件人、拍卖行和商业技能的搜索框上，添加下拉菜单，用来保存之前输入过的文字。`特别方便的是可以自动记录拍卖行的搜索历史，而且选中之后会直接搜索拍卖。（此功能可通过选项关闭）``如需添加选项，请先输入文字然后点下拉按钮，选择'添加选项'；如需修改选项，请先从下拉菜单中点击要删除的项，然后再次点击下拉按钮，选择'删除选项'",
    icon = [[Interface\Icons\misc_arrowdown]],
    pics = 2,

    toggle = function(name, info, enable, justload)
        if enable then
            if IsAddOnLoaded("Blizzard_AuctionUI") then U1SimulateEvent("ADDON_LOADED", "Blizzard_AuctionUI"); end
            if IsAddOnLoaded("Blizzard_TradeSkillUI") then U1SimulateEvent("ADDON_LOADED", "Blizzard_TradeSkillUI"); end
            --if IsAddOnLoaded("Blizzard_GlyphUI") then U1SimulateEvent("ADDON_LOADED", "Blizzard_GlyphUI"); end
            if IsAddOnLoaded("Blizzard_EncounterJournal") then U1SimulateEvent("ADDON_LOADED", "Blizzard_EncounterJournal"); end
        end
        return true;
    end,
    ------- Options --------
    {
        var = "autoauction",
        default = 1,
        type = "checkbox",
        text = "自动记录拍卖行搜索项目",
        tip = "说明`选中此项，则下拉菜单增强功能会自动记录拍卖行搜索的每一个项目，而不必手工添加。请在必要时启用",
        callback = function(cfg, v, loading)
            togglehook(nil, "tdHookAuctionSearch", noop, not v);
        end,
    },
    {
        var = "automail",
        default = 1,
        type = "checkbox",
        text = "自动记录收件人",
        tip = "说明`选中此项，则每次发送邮件的人名都会自动记录，不必手工添加。请在必要时启用",
        callback = function(cfg, v, loading)
            togglehook(nil, "tdHookSendMail", noop, not v);
        end,
    },
    {
        var = "size",
        default = 25,
        type = "spin",
        range = {10, 50, 5},
        text = "最大列表数量",
        tip = "说明`超过此值则自动创建下一页",
        callback = function(cfg, v, loading)
            if tdDropDown_Option then tdDropDown_Option.MAX = v end
        end,
    },
});
