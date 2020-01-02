U1RegisterAddon("MySlot", {
    title = "技能栏保存",
    defaultEnable = 0,
    tags = { TAG_MANAGEMENT, },
    icon = [[Interface\Icons\INV_Pet_SwapPet.png]],
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
end)
end)