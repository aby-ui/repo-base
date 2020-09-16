---所有函数返回的是wrapper对象, 接受parent和name两个参数
--************************************************************************************
-- 普通按钮
-- 对象属性：tooltipText, tooltipTitle, tooltipAnchorPoint
-- 结果属性：text,left,right,mid
--************************************************************************************
function TplPanelButton(parent, name, height)
    local btn = WW:Button(name, parent);
    btn:SetSize(40,height or 22);
    btn.left = btn:Texture(nil, "BACKGROUND", [[Interface\Buttons\UI-Panel-Button-Up]], 0, 0.09375,0,0.6875)
    :Size(12,22):TOPLEFT():BOTTOMLEFT():un();
    btn.right = btn:Texture(nil, "BACKGROUND", [[Interface\Buttons\UI-Panel-Button-Up]], 0.53125, 0.625,0,0.6875)
    :Size(12,22):TOPRIGHT():BOTTOMRIGHT():un();
    btn.mid = btn:Texture(nil, "BACKGROUND", [[Interface\Buttons\UI-Panel-Button-Up]], 0.09375, 0.53125,0,0.6875)
    :Size(12,22):TOPLEFT(btn.left,"TOPRIGHT"):BOTTOMRIGHT(btn.right,"BOTTOMLEFT"):un();

    btn:SetText(" ");
    btn.text = btn:GetFontString();
    btn:SetNormalFontObject(GameFontNormal);
    btn:SetHighlightFontObject(GameFontHighlight);
    btn:SetDisabledFontObject(GameFontDisable);
    btn:Texture(nil, "BACKGROUND", [[Interface\Buttons\UI-Panel-Button-Highlight]], 0, 0.625, 0, 0.6875):ToTexture("Highlight", "ADD"):un();

    btn:SetScript("OnMouseDown", TplPanelButton_OnMouseDown);
    btn:SetScript("OnMouseUp", TplPanelButton_OnMouseUp);
    btn:SetScript("OnShow", TplPanelButton_OnShow);
    btn:SetScript("OnDisable", TplPanelButton_OnDisable);
    btn:SetScript("OnEnable", TplPanelButton_OnEnable);
    btn:SetScript("OnEnter", TplPanelButton_OnEnter);
    btn:SetScript("OnLeave", TplPanelButton_OnLeave);

    return btn;
end
function TplPanelButton_OnMouseDown(self)
    if ( self:IsEnabled() ) then
        self.left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
        self.mid:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
        self.right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down");
    end
end
function TplPanelButton_OnMouseUp(self)
    if ( self:IsEnabled() ) then
        self.left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
        self.mid:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
        self.right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
    end
end
function TplPanelButton_OnShow(self)
    if ( self:IsEnabled() ) then
        -- we need to reset our textures just in case we were hidden before a mouse up fired
        self.left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
        self.mid:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
        self.right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
    end
end
function TplPanelButton_OnDisable(self)
    self.left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled");
    self.mid:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled");
    self.right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Disabled");
end
function TplPanelButton_OnEnable(self)
    self.left:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
    self.mid:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
    self.right:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up");
end
function TplPanelButton_OnEnter(self)
    CoreUIShowTooltip(self);
end
function TplPanelButton_OnLeave(self)
    GameTooltip:Hide();
end

--************************************************************************************
-- 复选框, 带文字
-- 默认大小32, font="ChatFontSmall"
-- 对象可以具有tooltipText, tooltipOwnerPoint(默认为ANCHOR_RIGHT), func(OnClick脚本)属性
-- 增加EnableOrDisable方法, 可以设置文字和图标的
--************************************************************************************
local TplCheckButtonScripts = {};
function TplCheckButton(parent, name)
    local cb = WW:CheckButton(name, parent);
    cb:SetMotionScriptsWhileDisabled(true);
    cb.text = cb:CreateFontString(nil, "ARTWORK", "ChatFontSmall"):SetJustifyH("LEFT"):LEFT(0, 1);
    cb:SetFontString(cb.text);
    cb.EnableOrDisable = TplCheckButtonEnableOrDisable
    cb:SetSize(26, 26);
    --cb:SetHitRectInsets(0,0-cb.text:GetWidth(),0,0);
    cb:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD");
    cb:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up");
    cb:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down");
    cb:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check");
    cb:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled");
    --设置文本后自动调整点击区域
    hooksecurefunc(cb.text, "SetText", TplCheckButton_OnTextSet);
    hooksecurefunc(cb.text, "SetWidth", TplCheckButton_OnTextSet)
    hooksecurefunc(cb(), "SetText", TplCheckButton_OnTextSet2)
    for k,v in pairs(TplCheckButtonScripts) do cb:SetScript(k, v); end
    return cb;
end
function TplCheckButtonEnableOrDisable(self, enable)
    if(enable) then
        self:Enable();
        if self.icon then
            self.icon:Enable();
            CoreUIUndesaturateTexture(self.icon.tex);
        end
    else
        self:Disable();
        if self.icon then
            self.icon:Disable();
            CoreUIDesaturateTexture(self.icon.tex);
        end
    end
end
function TplCheckButtonForceChecked(self, checked)
    self:Enable();
    local origin = self:GetScript("OnDisable");
    self:SetScript("OnDisable", noop)
    self:SetChecked(checked);
    self:Disable();
    self:SetScript("OnDisable", origin);
end
function TplCheckButtonScripts.OnClick(self)
    if(self.func)then self.func(self) end
end
function TplCheckButtonScripts.OnEnter(self)
    CoreUIShowTooltip(self, self.tooltipOwnerPoint);
    if(not GameTooltip:IsVisible()) then
        if(self.text:IsTruncated())then
            self.tooltipTitle = self.text:GetText()
            CoreUIShowTooltip(self, self.tooltipOwnerPoint);
            self.tooltipTitle = nil;
        end
    else
        if(self.text:IsTruncated())then
            GameTooltipTextLeft1:SetText(self.text:GetText().."\n"..(GameTooltipTextLeft1:GetText() or ""))
            GameTooltip:Show()
        end
    end
end
function TplCheckButtonScripts.OnLeave(self)
    GameTooltip:Hide();
end
function TplCheckButtonScripts.OnSizeChanged(self)
    self.text:SetPoint("LEFT", self, "RIGHT", -self:GetWidth()*0.183+2, 1);
end

function TplCheckButton_OnTextSet(self)
    --只要不设置FontString的宽度, 则GetStringWidth会自动调整
    self:GetParent():SetHitRectInsets(0, 0-self:GetWidth(),0,0);
end
function TplCheckButton_OnTextSet2(self)
    --CheckButton自身的SetText被调用时
    self:SetHitRectInsets(0, 0-self.text:GetWidth(),0,0);
end

--************************************************************************************
-- 单选框, 带文字
-- 默认大小16, font="ChatFontSmall"
-- 对象可以具有tooltipText, tooltipOwnerPoint(默认为ANCHOR_RIGHT), func(OnClick脚本)属性
--************************************************************************************
local TplRadioButtonScripts = {};
function TplRadioButton(parent, name)
    local rb = WW:CheckButton(name, parent);
    rb:SetMotionScriptsWhileDisabled(true);
    rb.text = rb:CreateFontString(nil, "ARTWORK", "ChatFontSmall"):SetJustifyH("LEFT");
    rb.text:SetPoint("LEFT", rb(), "RIGHT", -rb:GetWidth()*0.183-1, 0);
    rb:Texture(nil, nil, "Interface\\Buttons\\UI-RadioButton",0,.25,0,1):ToTexture("Normal"):ALL();
    rb:Texture(nil, nil, "Interface\\Buttons\\UI-RadioButton",.25,.5,0,1):ToTexture("Checked"):ALL();
    rb:Texture(nil, nil, "Interface\\Buttons\\UI-RadioButton",.5,.75,0,1):ToTexture("Highlight", "ADD"):ALL();
    rb:Texture(nil, nil, "Interface\\Buttons\\UI-RadioButton",.75,1,0,1):ToTexture("DisabledChecked"):ALL();
    --设置文本后自动调整点击区域
    --cb:SetHitRectInsets(0,0-cb.text:GetWidth(),0,0);
    hooksecurefunc(rb.text, "SetText", TplRadioButton_OnTextSet);
    for k,v in pairs(TplRadioButtonScripts) do rb:SetScript(k, v); end
    return rb;
end
function TplRadioButtonScripts.OnClick(self)
    if(self.func)then self.func(self) end
end
function TplRadioButtonScripts.OnEnter(self)
    if(self:IsEnabled())then
        local r,g,b = self.text:GetFontObject():GetTextColor();
        self.text:SetTextColor(1,1,1-b);
    end

    CoreUIShowTooltip(self, self.tooltipOwnerPoint);
    if(not GameTooltip:IsVisible() and self.text:IsTruncated())then
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
        GameTooltip:SetText(self.text:GetText());
        GameTooltip:Show();
    end
end
function TplRadioButtonScripts.OnLeave(self)
    if(self:IsEnabled())then self.text:SetTextColor(self.text:GetFontObject():GetTextColor()) end
    GameTooltip:Hide();
end
function TplRadioButtonScripts.OnDisable(self)
    self.text:SetTextColor(0.5, 0.5, 0.5);
end
function TplRadioButtonScripts.OnEnable(self)
    self.text:SetTextColor(self.text:GetFontObject():GetTextColor());
end
function TplRadioButton_OnTextSet(self)
    --只要不设置FontString的宽度, 则GetStringWidth会自动调整
    self:GetParent():SetHitRectInsets(0, 0-self:GetWidth(),0,0);
end

--*****************************************************************
-- 普通的ScrollFrame, 提供scrollBarHideable,smoothSize 设置scrollBar
--*****************************************************************
local TplScrollFrameScripts = {};
function TplScrollFrame(parent, name)
    local scroll = WW:ScrollFrame(name, parent);
    scroll:EnableMouseWheel(true);
    local scrollBar = CoreUICreateModernScrollBar(scroll, -1, 0, false, 6, 30, 1)
    scroll.scrollBar = scrollBar;
    scrollBar:SetFrameLevel(scrollBar:GetFrameLevel()+1);
    --scrollBar:SetScript("OnValueChanged", TplScrollFrameScrollBar_OnValueChanged);
    scrollBar:SetMinMaxValues(0, 0);
    scrollBar:SetValue(0);
    scroll.offset = 0;
    for k,v in pairs(TplScrollFrameScripts) do scroll:SetScript(k, v); end
    return scroll;
end
function TplScrollFrameScrollBar_OnValueChanged(self, value)
    self:GetParent():SetVerticalScroll(value);
end
function TplScrollFrameScripts.OnLoad(self)
    if ( self.scrollBarHideable ) then
        self.scrollBar:Hide();
    end
end
function TplScrollFrameScripts.OnScrollRangeChanged(self, xrange, yrange)
    local scrollBar = self.scrollBar;
    if ( not yrange ) then
        yrange = self:GetVerticalScrollRange();
    end
    local value = scrollBar:GetValue();
    if ( value > yrange ) then
        value = yrange;
    end
    scrollBar:SetMinMaxValues(0, yrange);
    scrollBar:SetValue(value);
    if ( floor(yrange) == 0 ) then
        if ( self.scrollBarHideable ) then
            scrollBar:Hide();
        end
        scrollBar.thumbTexture:Hide();
    else
        scrollBar:Show();
        scrollBar.thumbTexture:Show();
    end
end
function TplScrollFrameScripts.OnVerticalScroll(self, offset)
    local scrollBar = self.scrollBar;
    scrollBar:SetValue(offset);
end
function TplScrollFrameScripts.OnMouseWheel(self, value, scrollBar)
    scrollBar = scrollBar or self.scrollBar;
    value = (value>0 and -1 or 1)*(IsShiftKeyDown() and (self.smoothSize or 20) or self.scrollBar:GetHeight()/2)
    scrollBar:SetValue(scrollBar:GetValue() + value);
end

--[[------------------------------------------------------------
高亮提示 /run TalentMicroButton_OnEvent(self, "PLAYER_LEVEL_UP", 10)
返回对象具有 text, arrow close
---------------------------------------------------------------]]
local TplGlowHintHookSetText
function TplGlowHint(parent, name, width)
    local f = WW:Frame(name, parent, "GlowBoxTemplate"):SetFrameStrata("TOOLTIP"):SetToplevel(1):Size(width, 1):EnableMouse(true)
    :CreateFontString(nil, "OVERLAY", "GameFontHighlightLeft"):Key("text"):TL(16, -24):Size(width-32,0):up()
    :Button(nil, "UIPanelCloseButton", "close"):TR(6, 6):up()
    :Frame("$parentArrow", "GlowBoxArrowTemplate", "arrow"):TOP("$parent", "B", 0, 4):up()
    TplGlowHintHookSetText = TplGlowHintHookSetText or function(self) self:GetParent():SetHeight(self:GetHeight()+42+8) end
    hooksecurefunc(f.text, "SetText",  TplGlowHintHookSetText);
    return  f;
end

function TplColumnButton(parent, name, height, width)
    width = width or 50;
    local btn = WW:Button(name, parent):Size(width, height):EnableMouse(true):SetButtonFont("GameFontNormalSmall")

    btn:GetButtonText():LEFT(3,0):RIGHT(-3,0):SetJustifyH("CENTER"):SetWordWrap(false):up()
    :Texture(nil, "ARTWORK","Interface\\FriendsFrame\\WhoFrame-ColumnTabs",0,0.078125,0,0.75):Key("L"):Size(5,height):TL():up()
    :Texture(nil, "BACKGROUND","Interface\\FriendsFrame\\WhoFrame-ColumnTabs",0.90625,0.96875,0,0.75):Key("R"):Size(4,height):TR():up()
    :Texture(nil, "BACKGROUND","Interface\\FriendsFrame\\WhoFrame-ColumnTabs",0.078125,0.90625,0,0.75):Key("M"):TL(btn.L, "TR"):BR(btn.R, "BL"):up()
    :Texture(nil, nil, "Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight"):ToTexture("Highlight", "ADD"):TL(btn.L,-2,7):BR(btn.R,2,-7):up()

    return btn;
end

---还很不完善，只是给音量调整按钮用的
function TplSlider(parent, name, title, vertical, valueFormat, min, max, step)
    --local btnClose = WW:Button(n.."CloseButton", UIParent):Hide():ALL():AddFrameLevel(-1):RegisterForClicks("LeftButtonDown", "RightButtonDown")
    valueFormat = valueFormat or "%d"
    local slider = WW:Slider(name, parent):SetOrientation(vertical and "VERTICAL" or "HORIZONTAL")
    slider.format = valueFormat;
    min, max, step = min or 0, max or 100, step or 10
    return slider:SetMinMaxValues(min, max):SetValueStep(step):SetValue(min) --:Size(16,128):TOP(-10, -35)
    :Backdrop([[Interface\Buttons\UI-SliderBar-Background]],[[Interface\Buttons\UI-SliderBar-Border]],8,{3,3,6,6},8)
    :Texture():Size(32):SetTexture("Interface\\Buttons\\UI-SliderBar-Button-"..(vertical and "VERTICAL" or "HORIZONTAL")):ToTexture("Thumb"):up()
    :CreateFontString(nil, nil, "GameFontNormalSmall"):Key("title"):SetText(title):BOTTOM("$parent", "TOP", 10, 2):up()
    :CreateFontString(nil, nil, "GameFontNormalHuge"):SetText("-"):BL("$parent", "BR", 4, 3):SetTextColor(1,1,1):up()
    :CreateFontString(nil, nil, "GameFontNormalHuge"):SetText("+"):TL("$parent", "TR", 4, -3):SetTextColor(1,1,1):up()
    :CreateFontString(nil, nil, "FriendsFont_UserText"):Key("txtValue"):SetText(""):LEFT("$parent", "RIGHT", 1, 0):SetTextColor(1,1,1):up()
    :SetScript("OnValueChanged", function(self)
        local min, max = self:GetMinMaxValues()
        local value = "VERTICAL"==self:GetOrientation() and (max - self:GetValue() + min) or self:GetValue()
        self.txtValue:SetText(format(self.format, value))
        if(self.func) then self.func(self, value) end
    end)
end