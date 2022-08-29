--[[ --9.0早期资料片下拉菜单没有没有暗影国度的选项
CoreDependCall("Blizzard_EncounterJournal", function()
    hooksecurefunc("EJTierDropDown_Initialize", function(self, level)
        if not level then return end
        local listFrame = _G["DropDownList"..level];
        local expId = ELP_CURRENT_TIER
        if listFrame.numButtons >= expId then return end
        local info = UIDropDownMenu_CreateInfo();
        info.text = EJ_GetTierInfo(expId);
        info.func = EncounterJournal_TierDropDown_Select
        info.checked = expId == EJ_GetCurrentTier;
        info.arg1 = expId;
        UIDropDownMenu_AddButton(info, 1)
    end)
end)
--]]