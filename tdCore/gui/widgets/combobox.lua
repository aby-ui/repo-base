
local GUI = tdCore('GUI')

local List = GUI('List')
local ComboBox = GUI:NewModule('ComboBox', CreateFrame('Button'), 'UIObject', 'Control')
ComboBox:SetVerticalArgs(40, -15, 0, -20)
ComboBox:RegisterHandle('OnValueChanged')

local function OnClick(self)
    self:GetParent():OnClick()
end

local function OnEnable(self)
    ComboBox.OnEnable(self)
    self.__button:Enable()
end

local function OnDisable(self)
    ComboBox.OnDisable(self)
    self.__button:Disable()
end

function ComboBox:New(parent)
    local obj = self:Bind(CreateFrame('Button', nil, parent))
    if parent then
        obj:SetHeight(20)
        obj:SetBackdrop{
            bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
            edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
            edgeSize = 14, tileSize = 20, tile = true,
            insets = {left = 2, right = 2, top = 2, bottom = 2},
        }
        obj:SetBackdropColor(0, 0, 0, 0.4)
        obj:SetBackdropBorderColor(0.7, 0.7, 0.7, 0.7)
        
        obj:SetNormalFontObject('GameFontHighlightSmall')
        obj:SetHighlightTexture([[Interface\TokenFrame\UI-TokenFrame-CategoryButton]])
        obj:GetHighlightTexture():SetTexCoord(0, 1, 0.609375, 0.796875)
        obj:GetHighlightTexture():SetAlpha(0.5)
        obj:GetHighlightTexture():SetPoint('TOPLEFT', 3, -3)
        obj:GetHighlightTexture():SetPoint('BOTTOMRIGHT', -3, 3)
        
        obj:GetLabelFontString():SetPoint('BOTTOMLEFT', obj, 'TOPLEFT')
        obj:GetValueFontString():SetPoint('CENTER')
        obj:SetFontString(obj:GetValueFontString())
        
        local button = CreateFrame('Button', nil, obj)
        button:SetSize(22, 22)
        button:SetPoint('LEFT', obj, 'RIGHT', -3, 0)
        button:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
        button:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
        button:SetDisabledTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]])
        button:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
        button:SetScript('OnClick', OnClick)
        
        obj.__button = button
        
        obj:SetScript('OnClick', self.OnClick)
        obj:SetScript('OnEnable', OnEnable)
        obj:SetScript('OnDisable', OnDisable)
    end
    return obj
end

function ComboBox:OnClick()
    self:ToggleMenu('ComboMenu', self:GetItemList())
end

function ComboBox:Update()
    local value = self:GetProfileValue()
    
    local list = self:GetItemList()
    if not list then return end
    
    for i = 1, list:GetItemCount() do
        if value == list:GetValue(i) then
            self:SetText(list:GetText(i))
            return
        end
    end
end

function ComboBox:SetValue(value)
    self:SetProfileValue(value)
    self:Update()
    self:RunHandle('OnValueChanged', value)
end

function ComboBox:SetItemList(itemList)
    self.__itemList = List:New(itemList)
end

function ComboBox:GetItemList()
    return self.__itemList
end

---- FontComboBox

local Media = GUI('Media')
local FontComboBox = GUI:NewModule('FontComboBox', ComboBox:New())

function FontComboBox:New(parent)
    local obj = self:Bind(ComboBox:New(parent))
    
    obj:SetText('ABCdef 123456 字体预览')
    obj:SetScript('OnClick', self.OnClick)
    
    return obj
end

function FontComboBox:Update()
    local value = self:GetProfileValue()
    
    local list = Media:GetFonts()
    for i = 1, list:GetItemCount() do
        if value == list:GetValue(i) then
            self:GetValueFontString():SetFont(list:GetValue(i), 14, 'OUTLINE')
            return
        end
    end
end

function FontComboBox:OnClick()
    self:ToggleMenu('FontMenu')
end
