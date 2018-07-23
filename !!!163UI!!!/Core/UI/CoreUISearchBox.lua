local searchBoxHandlers = {}
searchBoxHandlers.OnShow = function(self)
    if self.clear:IsShown() then return end --已有内容则不清除
    self:SetText(SEARCH);
    self:SetTextColor(0.5, 0.5, 0.5);
    self.icon:SetVertexColor(0.6, 0.6, 0.6);
    self.clear.tex:SetVertexColor(1, 1, 1, 0.8);
    self:SetTextInsets(16, 16, 0, 0);
end

searchBoxHandlers.OnEditFocusGained = function(self)
    self:HighlightText();
    if ( self:GetText() == SEARCH ) then
        self:SetText("");
    end
    self:SetTextColor(1,1,1);
    self.icon:SetVertexColor(1.0, 1.0, 1.0);
end

searchBoxHandlers.OnTextChanged = function(self)
    local text = self:GetText();
    if text == SEARCH or text == "" then
        self.clear:Hide();
    else
        self.clear:Show();
    end
    if(type(self.onTextChanged)=="function")then
        self.onTextChanged(self);
    end
end

searchBoxHandlers.OnEditFocusLost = function(self)
    self:HighlightText(0, 0);
    if ( self:GetText() == "" ) then
        self:SetText(SEARCH);
        self:SetTextColor(0.5, 0.5, 0.5);
        self.icon:SetVertexColor(0.6, 0.6, 0.6);
    end
end

searchBoxHandlers.OnEnterPressed = function(self)
    EditBox_ClearFocus(self);
    if(type(self.onEnterPressed)=="function")then
        self.onEnterPressed(self);
    end
end

searchBoxHandlers.OnEscapePressed = function(self)
    --self:SetText("")
    self:ClearFocus();
end

local clearOnClick = function(self)
    self:GetParent():SetText("")
    self:GetParent():SetFocus();
    self:GetParent():ClearFocus();
end

local getSearchText = function(self)
    local text = self:GetText();
    if text == SEARCH or text == nil then text = "" end
    return text;
end

local setSearchText = function(self, text)
    self:SetText(text)
    if not self:IsVisible() then
        --hidden frame will not trigger OnTextChanged
        self:GetScript("OnEditFocusGained")(self)
        self:GetScript("OnTextChanged")(self)
        self:GetScript("OnEditFocusLost")(self)
    end
end

--- 创建一个类似交易技能检索框
-- CoreUICreateSearchBox(name, UIParent, 90, 18):TOP(10,-20)
-- 返回的EditBox具有方法GetSearchText
function CoreUICreateSearchBox(name, parent, width, height)
    local box = WW:EditBox(name, parent):SetFontObject(height > 20 and ChatFontNormal or ChatFontSmall):SetAutoFocus(false):Size(width,height);

    local left = box:Texture(nil, "BACKGROUND", [[Interface\Common\Common-Input-Border]], 0,0.0625,0,0.625):Size(8/20*height,height):TOPLEFT(-5,0);
    local right = box:Texture(nil, "BACKGROUND", [[Interface\Common\Common-Input-Border]], 0.9375,1,0,0.625):Size(8/20*height,height):RIGHT(0,0);
    box:Texture(nil, "BACKGROUND", [[Interface\Common\Common-Input-Border]], 0.0625,0.9375,0,0.625):Size(8/20*height,height):LEFT(left,"RIGHT"):RIGHT(right,"LEFT");
    box.icon = box:Texture(nil, "OVERLAY", [[Interface\Common\UI-Searchbox-Icon]]):Size(height-6):LEFT(0, -2):SetVertexColor(0.7,0.7,0.7);
    box.clear = box:Button(nil):Size(height-8,height-8):RIGHT(-height/6,0):Texture(nil,"OVERLAY",[[Interface\COMMON\VOICECHAT-MUTED]]):ALL():Key("tex"):up():Hide()
    box.clear:SetScript("OnClick", clearOnClick);
    box.GetSearchText = getSearchText;
    box.SetSearchText = setSearchText;
    searchBoxHandlers.OnShow(box);
    for k,v in pairs(searchBoxHandlers) do box:SetScript(k, v); end
    return box;
end