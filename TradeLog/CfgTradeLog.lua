U1RegisterAddon("TradeLog", {
    title = "交易记录",
    defaultEnable = 1,
    minimap = "LibDBIcon10_TradeLog",

    tags = { TAG_TRADING },
    icon = [[Interface\Icons\ACHIEVEMENT_GUILDPERK_BARTERING]],
    desc = "交易后显示交易的详细情况，也可选择发送到频道中。另外，在交易窗口旁边可以列出与此人近期的交易，防止重复交易。`通过小地图按钮还可打开详细的交易历史记录界面。",
    pics = 2,

    author = "|cffcd1a1c[爱不易原创]|r",

    -------- Options --------
    {
        var = "recent",
        default = 1,
        text = "交易窗口旁边显示近期交易",
        tip = "说明`交易时在旁边显示近期与此人的交易情况，防止重复交易。",
        callback = function(cfg, v, loading)
            if v then
                RecentTradeFrame:RegisterEvent("TRADE_SHOW")
            else
                RecentTradeFrame:UnregisterEvent("TRADE_SHOW")
                RecentTradeFrame:Hide();
            end
        end,
    },
    {
        var = "channel",
        default = "WHISPER",
        text = "选择通知发送方式",
        type = "radio",
        options = {"不发送", "NONE", "密语", "WHISPER", "团队", "RAID", "小队", "PARTY", "说", "SAY", "喊", "YELL"},
        cols = 3,
        getvalue = function() if not TradeLog_Announce_Checked then return "NONE" else return TradeLog_AnnounceChannel end end,
        callback = function(cfg, v, loading)
            TradeLog_Announce_Checked = v ~= "NONE";
            TBT_AnnounceCB:SetChecked(TradeLog_Announce_Checked);
            if v == "NONE" then return end
            TradeLog_AnnounceChannel = v;
            UIDropDownMenu_Initialize(TBT_AnnounceChannelDropDown, TBT_AnnounceChannelDropDown_Initialize);
            UIDropDownMenu_SetSelectedValue(TBT_AnnounceChannelDropDown, v);
        end,
    },
    --]]
});
