--[[------------------------------------------------------------
在专精和天赋按钮上稍作停留，就会出现快捷切换按钮
---------------------------------------------------------------]]
if TalentMicroButton then
    local CONFIG_NAME = "!!!163ui!!!/noSpecSwitch"

    local timer = "TalentSwitchButtonHideTimer"
    local buttons

    local function hideSwitchButtons()
        if not buttons then return end
        for i = 1, #buttons do
            buttons[i]:Hide()
        end
    end

    local function switchOnEnter()
        CoreCancelBucket(timer)
    end

    local function switchOnLeave()
        CoreScheduleBucket(timer, 0.3, hideSwitchButtons)
    end

    local function switchOnClick(self)
        if( UnitCastingInfo("player") ) then
            U1Message("施法中，无法切换至 |cffffff00"..self:GetText().."|r 专精", 1, .7, .7)
        elseif( InCombatLockdown() ) then
            U1Message("战斗中，无法切换至 |cffffff00"..self:GetText().."|r 专精", 1, .7, .7)
        else
            SetSpecialization(self.spec)
            U1Message("正在切换至 |cffffff00"..self:GetText().."|r 专精", .7, 1, .7)
            CoreScheduleBucket(timer, 0, hideSwitchButtons)
        end
    end

    local function showSwitchButtons()
        if InCombatLockdown() or U1DB.configs[CONFIG_NAME] then return end

        if buttons == nil then
            buttons = {}
            for i = 1, GetNumSpecializations() do
                buttons[i] = CreateFrame("Button", "$parentSpecSwitch" .. i, TalentMicroButton, "UIPanelButtonTemplate") --"UIMenuButtonStretchTemplate")
                buttons[i]:SetSize(60, 22)
                buttons[i]:SetText((select(2, GetSpecializationInfo(i))))
                buttons[i]:SetFrameStrata("Tooltip")
                buttons[i].spec = i
                buttons[i]:SetScript("OnEnter", switchOnEnter)
                buttons[i]:SetScript("OnLeave", switchOnLeave)
                buttons[i]:SetScript("OnClick", switchOnClick)
                buttons[i]:SetMotionScriptsWhileDisabled(true)
            end
        end

        local fromBottomUp = select(2, TalentMicroButton:GetBoundsRect()) < GetScreenHeight() / 2

        if fromBottomUp then
            for i = #buttons, 1, -1 do
                buttons[i]:ClearAllPoints()
                if (i == #buttons) then
                    buttons[i]:SetPoint("BOTTOMLEFT", TalentMicroButton, "BOTTOMLEFT", 0, 35)
                else
                    buttons[i]:SetPoint("BOTTOMLEFT", buttons[i + 1], "TOPLEFT", 0, 0)
                end
                buttons[i]:SetFrameStrata("Tooltip")
                buttons[i]:Show()
            end
        else
            for i = 1, #buttons do
                buttons[i]:ClearAllPoints()
                if (i == 1) then
                    buttons[i]:SetPoint("TOPLEFT", TalentMicroButton, "BOTTOMLEFT", 0, 0)
                else
                    buttons[i]:SetPoint("TOPLEFT", buttons[i - 1], "BOTTOMLEFT", 0, 0)
                end
                buttons[i]:Show()
            end
        end

        for i = 1, #buttons do
            if buttons[i].spec == GetSpecialization() then
                buttons[i]:SetEnabled(false)
            else
                buttons[i]:SetEnabled(true)
            end
        end

        CoreScheduleBucket(timer, 5, hideSwitchButtons)
    end

    SetOrHookScript(TalentMicroButton, "OnEnter", function()
        GameTooltip:AddDoubleLine("右键点击", "弹出专精切换按钮")
        GameTooltip:AddDoubleLine("Ctrl点击", "禁用/启用此功能")
        GameTooltip:Show()
    end)

    --SetOrHookScript(TalentMicroButton, "OnLeave", function()
    --    CoreScheduleBucket(timer, 0.5, hideSwitchButtons)
    --end)

    SetOrHookScript(TalentMicroButton, "OnClick", function(self, button)
        if button == "RightButton" then
            if InCombatLockdown() then return end
            if ClassTalentFrame:IsVisible() then
                ClassTalentFrame:Hide()
            end
            showSwitchButtons()
        elseif (IsControlKeyDown()) then
            U1DB.configs[CONFIG_NAME] = not U1DB.configs[CONFIG_NAME]
            U1Message("切换天赋按钮已 "..(U1DB.configs[CONFIG_NAME] and "禁用" or "启用"))
            if ClassTalentFrame:IsVisible() then
                ClassTalentFrame:Hide()
            end
        else
            hideSwitchButtons()
        end
    end)

    --[[
    TalentMicroButton:HookScript("OnClick", function()
        if IsModifierKeyDown() then
            HideUIPanel(PlayerTalentFrame);
            local all = GetNumSpecializations()
            if (all>1) then
                local old, new = GetSpecialization(), 1
                if(old ~= all) then new = old + 1 end
                SetSpecialization(new)
            end
        else
            --ToggleTalentFrame() --污染 PlayerTalentFrame_Toggle(false, GetActiveTalentGroup());  就会污染，原因不明 PlayerTalentFrame:Show()有时污染
        end
    end)
    --]]
end

CoreDependCall("Blizzard_ClassTalentUI", function()
    local btn = {}
    for i = 1, GetNumSpecializations() do
        btn[i] = CreateFrame("Button", "$parentSpecSwitch" .. i, ClassTalentFrame.TalentsTab.ButtonsParent, "UIPanelButtonTemplate") --"UIMenuButtonStretchTemplate")
        btn[i]:SetSize(60, 22)
        btn[i]:SetText((select(2, GetSpecializationInfo(i))))
        btn[i]:SetFrameStrata("MEDIUM")
        btn[i].spec = i
        btn[i]:SetScript("OnClick", switchOnClick)
        btn[i]:SetMotionScriptsWhileDisabled(true)
        if (i == 1) then
            btn[i]:SetPoint("BOTTOMLEFT", 0, 0)
        else
            btn[i]:SetPoint("TOPLEFT", btn[i - 1], "TOPRIGHT", 0, 0)
        end
    end

    local function update()
        for i, b in ipairs(btn) do
            CoreUIShowOrHide(b, not U1DB.configs[CONFIG_NAME])
            b:SetEnabled(b.spec ~= GetSpecialization() and not InCombatLockdown())
        end
    end
    ClassTalentFrame:HookScript("OnShow", update)
    CoreOnEvent("PLAYER_SPECIALIZATION_CHANGED", update)
    CoreOnEvent("PLAYER_REGEN_ENABLED", update)
    CoreOnEvent("PLAYER_REGEN_DISABLED", update)
end)

--[[------------------------------------------------------------
专精面板法术ID, 10.0自带
CoreDependCall("Blizzard_TalentUI", function()
    local function hookAbilityButton(index)
        local btn = PlayerTalentFrameSpecialization.spellsScroll.child["abilityButton"..index]
        if btn then
            btn:HookScript("OnEnter", function()
                GameTooltip:AddDoubleLine("法术ID", btn.spellID)
                GameTooltip:Show()
            end)
        else
            return true
        end
    end
    for i=1, 10 do
        if hookAbilityButton(i) then
            break
        end
    end
    hooksecurefunc("PlayerTalentFrame_CreateSpecSpellButton", function(self, index)
        hookAbilityButton(index)
    end)
end)
---------------------------------------------------------------]]
