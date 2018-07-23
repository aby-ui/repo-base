U1RegisterAddon("vBar", {
    title = "额外动作条v",
    defaultEnable = 0,
    load = "NORMAL",
    tags = { TAG_COMBATINFO, },
    defaultEnable = 0,

    icon = [[Interface\Icons\INV_Misc_PunchCards_Prismatic]],
    desc = "另一个额外动作条插件，战斗时可以拖动。",
    nopic = 1,
    {
        var = "changeOrder",
        default = 1,
        text = "更改默认按钮次序",
        tip = "说明`额外的动作条都是使用暴雪自带的后几页按钮，但不同插件使用的顺序不一样，如果你之前在用单体的vBar，关闭此选项就可以了，不需要重新拖技能。",
        reload = 1,
        callback = function(cfg, v, loading)
            VB_DEFAULT_SHAPE = 'zfslot9'
            VB_DEFAULT_LEFT = 400
            VB_DEFAULT_TOP = 500

            if not v then return end
            VB_NORMAL_SLOTS = {
               109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120,
               97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108,
               85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96,
            }
            VB_CLASS_SLOTS = {
               deathknight = VB_NORMAL_SLOTS,
               druid = VB_NORMAL_SLOTS,
               hunter = VB_NORMAL_SLOTS,
               mage = VB_NORMAL_SLOTS,
               moonkin = VB_NORMAL_SLOTS,
               paladin = VB_NORMAL_SLOTS,
               priest = VB_NORMAL_SLOTS,
               rogue = VB_NORMAL_SLOTS,
               shaman = VB_NORMAL_SLOTS,
               tree = VB_NORMAL_SLOTS,
               warlock = VB_NORMAL_SLOTS,
               warrior = VB_NORMAL_SLOTS,
               monk =  VB_NORMAL_SLOTS,
               demonhunter = VB_NORMAL_SLOTS
            }
        end,
    },
    {
        text = "没有技能时也显示按钮",
        var = "showGrid",
        default = true,
        secure = 1,
        callback = function(cfg, v, loading)
            if loading or InCombatLockdown() then return end
            local numpad = VB_GetNumpad()
            local keyboard = VB_KEYBOARDS[VBar.shape]
            local ddt = VBar.ddt
            local dft = VBar.dft
            local dst = VBar.dst
            for keynum, key in ipairs(keyboard) do
                local chosen = (key.type == ddt or key.type == dft or key.type == dst)
                if key.type == 'Numeric' or chosen then
                    local name = VBar.shape .. ddt .. dft .. dst .. keynum
                    local button = _G[name]
                    button:SetAttribute("showGrid", v and 1 or 0)
                    if v and not button:IsShown() then
                        button:Show()
                    end
                end
            end
        end
    },
    {
        text = "重置所有动作条",
        tip = "说明`会重置动作条的位置及设定，但不清除技能",
        confirm = "确定重置所有动作条?",
        callback = function()
            SlashCmdList['VB']("reset");
        end
    }
});