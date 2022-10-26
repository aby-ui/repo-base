CoreOnEvent("PLAYER_LOGIN", function()
    U1DBG.quest_font_height = U1DBG.quest_font_height or 15
    local origin_font, origin_size, origin_style = QuestFont:GetFont()
    local function toggle_font(self, button)
        if button == "LeftButton" then
            if not self:GetChecked() then
                QuestFont:SetFont(origin_font, origin_size, origin_style)
            else
                QuestFont:SetFont(ChatFontNormal:GetFont(), U1DBG.quest_font_height, "")
            end
        elseif button == -1 or button == 1 then
            U1DBG.quest_font_height = U1DBG.quest_font_height + (-1 * button)
            QuestFont:SetFont(ChatFontNormal:GetFont(), U1DBG.quest_font_height, "")
            self:SetChecked(true)
        end
        U1DBG.quest_font_modify = self:GetChecked()
    end
    local function on_show(self)
        self:SetChecked(U1DBG.quest_font_modify)
    end
    local btn1 = WW:CheckButton(nil, QuestLogPopupDetailFrame, "UICheckButtonTemplate"):SetFrameStrata("HIGH"):SetScript("OnShow", on_show)
    :RegisterForClicks("AnyUp"):SetSize(22, 22):TR(-60, 0):SetScript("OnClick", toggle_font):SetScript("OnMouseWheel", toggle_font):un()
    btn1.text:SetText("字体")
    CoreUIEnableTooltip(btn1, "说明", "简单的改变任务说明字体功能\n鼠标滚轮在此滚动可缩放字体\nby: 爱不易，祝你愉快")
    local btn2 = WW:CheckButton("QuestFrameFB", QuestFrame, "UICheckButtonTemplate"):SetFrameStrata("HIGH"):SetScript("OnShow", on_show)
    :RegisterForClicks("AnyUp"):SetSize(22, 22):TR(-40, 0):SetScript("OnClick", toggle_font):SetScript("OnMouseWheel", toggle_font):un()
    btn2.text:SetText("字")
    CoreUIEnableTooltip(btn2, "说明", "简单的改变任务说明字体功能\n鼠标滚轮在此滚动可缩放字体\nby: 爱不易，祝你愉快")
    local btn3 = WW:CheckButton(nil, GossipFrame, "UICheckButtonTemplate"):SetFrameStrata("HIGH"):SetScript("OnShow", on_show)
    :RegisterForClicks("AnyUp"):SetSize(22, 22):TR(-40, 0):SetScript("OnClick", toggle_font):SetScript("OnMouseWheel", toggle_font):un()
    btn3.text:SetText("字")
    CoreUIEnableTooltip(btn3, "说明", "简单的改变任务说明字体功能\n鼠标滚轮在此滚动可缩放字体\nby: 爱不易，祝你愉快")
    if U1DBG.quest_font_modify then
        btn1:SetChecked(true)
        btn2:SetChecked(true)
        btn3:SetChecked(true)
        toggle_font(btn1, "LeftButton")
    end
end)