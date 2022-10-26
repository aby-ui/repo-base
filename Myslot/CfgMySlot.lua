U1RegisterAddon("MySlot", {
    title = "技能栏保存",
    defaultEnable = 1,
    tags = { TAG_MANAGEMENT, },
    icon = [[Interface\Icons\INV_Pet_SwapPet.png]],
    minimap = "LibDBIcon10_Myslot",
    desc = "可以将当前角色的全部技能栏/宏命令/按键设置导出为一大段文本，另行保存到记事本里，这样洗掉专精再换回来时可以再导回来，也可以避免被其他人误修改。",
    nopic = 1,

    {
        text = "导入 / 导出",
        callback = function(cfg, v, loading) SlashCmdList[ "MYSLOT" ]("") end,
    },
});

--保存之前先检查合法性
local function valid(s)
    local private = _G["_163ui_MySlot"]
    local crc32 = private.crc32
    local base64 = private.base64
    s = string.gsub(s,"(@.[^\n]*\n*)","")
    s = string.gsub(s,"(#.[^\n]*\n*)","")
    s = string.gsub(s,"\n","")
    s = string.gsub(s,"\r","")
    s = base64.dec(s)

    if #s < 8  then
        U1Message("当前文本不正确，请先导出.")
        return false
    end

    local ver = s[1]
    local crc = s[5] * 2^24 + s[6] * 2^16 + s[7] * 2^8 + s[8]
    s[5], s[6], s[7] ,s[8] = 0, 0 ,0 ,0

    if ( crc ~= bit.band(crc32.enc(s), 2^32 - 1)) then
        U1Message("当前文本校验失败, 请重新导出.")
        return false
    end
    return true
end

CoreDependCall("MySlot", function()
    RunOnNextFrame(function()
        --MYSLOT_ReportFrame:SetHeight(370)
        --MYSLOT_ScrollFrame:SetHeight(300)
        --MYSLOT_ScrollFrame_Child:SetHeight(300)
        --MYSLOT_ReportFrame_EditBox:SetHeight(270)
        MYSLOT_ReportFrame_EditBox:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
        MYSLOT_ReportFrame_EditBox:SetScript("OnEditFocusLost", function(self) self:HighlightText(0, 0) end)

        MYSLOT_ScrollFrame:HookScript("OnScrollRangeChanged", function(self) self:SetVerticalScroll(0) end);

        --CoreUICreateMover(MYSLOT_ReportFrame, 26, 0, 0, 0)
        --MYSLOT_ReportFrame:EnableMouse(false)

        local private = _G["_163ui_MySlot"]
        hooksecurefunc(private, "Export", function() MYSLOT_ReportFrame_EditBox:SetFocus() CoreScheduleTimer(false, 0.1, function() MYSLOT_ScrollFrame:SetVerticalScroll(0) end) end)

        --[[ --删除宏会导致其他专精都受影响，不能提供这个选项
        StaticPopupDialogs["ABYUI_MYSLOT_CLEAR_MACRO"] = {preferredIndex = 3,
            text = "确定要删除所有通用宏和角色专用宏吗？此功能仅用于清理未知宏，被删除的宏如果没有备份就会永久删除无法恢复！！如果你确实知道自己是在做什么，请按住CTRL+ALT键点击确认按钮",
            button1 = YES,
            button2 = CANCEL,
            OnAccept = function(self, data)
                if IsControlKeyDown() and IsAltKeyDown() then
                    for i=138,1,-1 do DeleteMacro(i) end
                    U1Message("你按住了CTRL+ALT, 全部宏已清理, 希望你有备份")
                else
                    U1Message("操作失败，请同时按住CTRL+ALT再点击确认")
                end
            end,
            OnCancel = function(self, data)
            end,
            hideOnEscape = 1,
            timeout = 0,
            exclusive = 1,
            whileDead = 1,
        }

        local deleteMacros = TplPanelButton(MYSLOT_ReportFrame, "$parent_ClearMacro", 32)
            :SetText("删除全部宏"):SetWidth(100):SetPoint("BOTTOMRIGHT", -210, 65)
            :SetScript("OnClick", function(self)
                StaticPopup_Show("ABYUI_MYSLOT_CLEAR_MACRO", _G[SELECTED_CHAT_FRAME:GetName().."Tab"]:GetText());
            end):un()
        CoreUIEnableTooltip(deleteMacros, "请注意", "MySlot导出时会保存全部宏。但导入时，只会覆盖同名宏，不会删除已有宏。如果宏的位置不够，就无法全部导入。所以导入前可以用这个按钮删除当前所有的宏，然后再导入。但是注意，后来创建的宏也就被删除而且无法恢复了（当然，你可以再导出一个备份）")
        --]]

        ---[[ --TODO 先隐藏，日后再删除U1DB.configs['myslot/save1']
        local ct = WW:Frame("$parent_ct", MYSLOT_ReportFrame):Size(1,1):TL("$parent", "BL", 0, 0):un()
        for i = 1, 3 do
            --欺骗CtlRegularSaveValue用的
            local providedCfg = {var=1, _path='myslot/save'..i, confirm='此位置已经有一个存档，确定要覆盖吗？'};

            local b1 = TplPanelButton(ct, "$parent_save"..i, 26)
            :SetText("存档"..i):SetWidth(60):TL((i-1)*150+65, 0)
            :SetScript("OnClick", function(self)
                local s = MYSLOT_ReportFrame_EditBox:GetText() or ""
                if valid(s) then
                    CtlRegularSaveValue(nil, s, providedCfg);
                end
            end):un()

            local b2 = TplPanelButton(ct, "$parent_load"..i, 26)
            b2:SetText("取出"):SetWidth(60):TL(b1, "TR", 5, 0)
            :SetScript("OnClick", function(self)
                MYSLOT_ReportFrame_EditBox:SetText(U1LoadDBValue(providedCfg) or "");
                MYSLOT_ReportFrame_EditBox:SetFocus();
                MYSLOT_ReportFrame_EditBox:HighlightText();
                CoreScheduleTimer(false, 0.1, function() MYSLOT_ScrollFrame:SetVerticalScroll(0) end)
            end):un()
        end
        SetOrHookScript(MYSLOT_ReportFrame, "OnShow", function()
            for i = 1, 3 do
                local show = MYSLOT3SHOW ~= nil
                CoreUIShowOrHide(_G["MYSLOT_ReportFrame_ct_save" .. i], show)
                CoreUIShowOrHide(_G["MYSLOT_ReportFrame_ct_load" .. i], show)
            end
        end)
        --]]
    end)
end)