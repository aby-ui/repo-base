U1RegisterAddon("AutoTurnIn", {
    title = "自动交接任务",
    defaultEnable = 1,

    tags = { TAG_MAPQUEST, },
    icon = [[Interface\Icons\INV_Letter_18]],
    desc = "说明``自动交接任务，并在任务奖励处直接显示物品售价(此功能来自Abin的QuestPrice)",
    nopic = 1,
    toggle = function(name, info, enable, justload)
        if ( justload ) then
            AutoTurnInTrackerQuickSwitch:SetChecked(AutoTurnIn.db.profile.enabled)
            hooksecurefunc(AutoTurnIn, "SetEnabled", function(self, enabled)
                AutoTurnInTrackerQuickSwitch:SetChecked(enabled);
            end)
        end
    end,
    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            local func = CoreIOF_OTC or InterfaceOptionsFrame_OpenToCategory
            func("AutoTurnIn")
        end
    }
});

if not CreateFrame then return end
local checkbox = CreateFrame("CheckButton", "AutoTurnInTrackerQuickSwitch", ObjectiveTrackerFrame, "UICheckButtonTemplate");
checkbox:SetChecked(false)
checkbox:SetParent(ObjectiveTrackerBlocksFrame.QuestHeader)
checkbox:RegisterForClicks("AnyUp")
checkbox:SetWidth(22);
checkbox:SetHeight(22);
checkbox.text:SetText("交接")
checkbox:SetPoint("BOTTOMRIGHT", ObjectiveTrackerBlocksFrame.QuestHeader, "BOTTOMRIGHT", -90, 2);
CoreDependCall("!KalielsTracker", function()
    checkbox:SetParent(KT_ObjectiveTrackerBlocksFrame.QuestHeader)
    checkbox.text:SetText("接")
    checkbox:SetPoint("BOTTOMRIGHT", KT_ObjectiveTrackerBlocksFrame.QuestHeader, "BOTTOMRIGHT", -85, 2)
end)
checkbox:SetScript("OnClick", function(self, button)
    if( not IsAddOnLoaded("AutoTurnIn") ) then U1LoadAddOn("AutoTurnIn") end
    if( not IsAddOnLoaded("AutoTurnIn") ) then U1Message("请安装AutoTurnIn插件") return end
    if(button == "RightButton") then
        LibStub("AceConfigDialog-3.0"):Open("AutoTurnIn")
        self:SetChecked(not self:GetChecked())
    else
        AutoTurnIn:SetEnabled(self:GetChecked())
    end
end);
CoreUIEnableTooltip(checkbox, "自动交接任务", "左键：开启/关闭自动交接任务\n右键：设置选项\n\n按住热键(默认SHIFT)点击NPC，则暂时停用或启用自动交接。")