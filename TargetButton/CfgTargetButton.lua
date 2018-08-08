U1RegisterAddon("TargetButton", {
    title = "目标头像按钮",
    defaultEnable = 1,
    --optionsAfterVar = 1,

    tags = { TAG_INTERFACE },
    icon = [[Interface\Icons\INV_Misc_Dice_01]],
    desc = "占用很小的插件，在目标头像上增加交易/跟随/观察的快捷按钮。",

    author = "取自Isler包，少量修改",
    --modifier = "|cffcd1a1c[爱不易]|r",

    toggle = function(name, info, enable, justload)
        if not justload then
            if enable then
                TargetButtonsFrame:RegisterEvent("PLAYER_TARGET_CHANGED");
                TargetButton_Redraw(TargetButtonsFrame);
            else
                TargetButtonsFrame:UnregisterEvent("PLAYER_TARGET_CHANGED");
                TargetButtonsFrame_FollowButton:Hide();
                TargetButtonsFrame_TradeButton:Hide();
                TargetButtonsFrame_InspectButton:Hide();
            end
        end
    end,

    --[[------ Options --------
    {
        var = "",
        default = "",
        text = "", 
        callback = function(cfg, v, loading) end, 
    },
    {
        var = "",
        default = "",
        text = "",
        callback = function(cfg, v, loading) end,
    },
    --]]
});
