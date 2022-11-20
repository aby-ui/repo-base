U1RegisterAddon("QuestAnnounce", {
    title = "任务进度通报",
    defaultEnable = 1,

    tags = { TAG_MAPQUEST, },
    icon = [[Interface\Icons\Ability_Druid_NaturalPerfection]],
    desc = "说明``任务进度通报，可以设置通报间隔、通报频道，以及声音提示",
    nopic = 1,
    toggle = function(name, info, enable, justload)
        if ( justload ) then
            local settings = LibStub("AceAddon-3.0"):GetAddon("QuestAnnounce").db.profile.settings
            QuestAnnounceTrackerQuickSwitch:SetChecked(settings.enable)
            CoreScheduleTimer(true, 0.5, function()
                QuestAnnounceTrackerQuickSwitch:SetChecked(settings.enable)
            end)
        end
    end,
    {
        text = "配置选项",
        callback = function(cfg, v, loading)
            local func = CoreIOF_OTC or InterfaceOptionsFrame_OpenToCategory
            func("QuestAnnounce")
        end
    }
});

if not CreateFrame then return end
local checkbox = CreateFrame("CheckButton", "QuestAnnounceTrackerQuickSwitch", ObjectiveTrackerFrame.HeaderMenu, "UICheckButtonTemplate");
checkbox:SetChecked(false)
checkbox:RegisterForClicks("AnyUp")
checkbox:SetWidth(22);
checkbox:SetHeight(22);
checkbox.text:SetText("通报")
checkbox:SetPoint("TOPRIGHT", ObjectiveTrackerFrame.HeaderMenu, "TOPRIGHT", -125, 11);
local function updateVisible() checkbox:SetShown(checkbox.noHide or not ObjectiveTrackerFrame.collapsed) end
hooksecurefunc("ObjectiveTracker_Collapse", updateVisible)
hooksecurefunc("ObjectiveTracker_Expand", updateVisible)
CoreDependCall("!KalielsTracker", function()
    local parent = _G["!KalielsTrackerFrame"]
    checkbox.text:SetText("报")
    checkbox:SetParent(parent)
    checkbox:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -125, -5);
    checkbox:Show() checkbox.noHide = 1
end)
checkbox:SetScript("OnClick", function(self, button)
    if( not IsAddOnLoaded("QuestAnnounce") ) then U1LoadAddOn("QuestAnnounce") end
    if( not IsAddOnLoaded("QuestAnnounce") ) then U1Message("请安装QuestAnnounce插件") return end
    if(button == "RightButton") then
        local func = CoreIOF_OTC or InterfaceOptionsFrame_OpenToCategory
        func("QuestAnnounce")
        self:SetChecked(not self:GetChecked())
    else
        LibStub("AceAddon-3.0"):GetAddon("QuestAnnounce").db.profile.settings.enable = self:GetChecked()
    end
end);
CoreUIEnableTooltip(checkbox, "进度通报", "左键：开启/关闭任务进度通报\n右键：设置选项\n（这俩按钮在爱不易设置里可关闭）")