CoreOnEvent("PLAYER_LOGIN", function()
    U1DBG.quest_font_height = U1DBG.quest_font_height or 15
    local origin_font, origin_size, origin_style = QuestFont:GetFont()
    local function toggle_font(self, button)
        if(self:GetChecked() or IsControlKeyDown() or IsAltKeyDown()) then
            U1DBG.quest_font_height = U1DBG.quest_font_height + (not (IsControlKeyDown() or IsAltKeyDown()) and 0 or button == "LeftButton" and 1 or -1)
            QuestFont:SetFont(ChatFontNormal:GetFont(), U1DBG.quest_font_height)
            self:SetChecked(true)
        else
            QuestFont:SetFont(origin_font, origin_size, origin_style)
        end
        U1DBG.quest_font_modify = self:GetChecked()
    end
    local btn1 = WW:CheckButton(nil, QuestLogPopupDetailFrame, "UICheckButtonTemplate")
    :RegisterForClicks("AnyUp"):SetSize(22, 22):TR(-60, 0):SetScript("OnClick", toggle_font):un()
    btn1.text:SetText("字体")
    CoreUIEnableTooltip(btn1, "说明", "简单的改变任务说明字体功能\n按住CTRL点击：放大字体\n按住ALT点击:缩小字体\nby: 爱不易，祝你愉快")
    local btn2 = WW:CheckButton(nil, QuestFrame, "UICheckButtonTemplate")
    :RegisterForClicks("AnyUp"):SetSize(22, 22):TR(-40, 0):SetScript("OnClick", toggle_font):un()
    btn2.text:SetText("字")
    local btn3 = WW:CheckButton(nil, GossipFrame, "UICheckButtonTemplate")
    :RegisterForClicks("AnyUp"):SetSize(22, 22):TR(-40, 0):SetScript("OnClick", toggle_font):un()
    btn3.text:SetText("字")
    if U1DBG.quest_font_modify then
        btn1:SetChecked(true)
        btn2:SetChecked(true)
        btn3:SetChecked(true)
        toggle_font(btn1)
    end
end)