
local WIDGET, VERSION = 'InputBox', 4

local GUI = LibStub('NetEaseGUI-2.0')
local InputBox = GUI:NewClass(WIDGET, 'EditBox', VERSION)
if not InputBox then
    return
end

local ARROW_DELTA = {
    UP = -1,
    DOWN = 1
}

function InputBox:Constructor()
    local tLeft = self:CreateTexture(nil, 'BACKGROUND') do
        tLeft:SetTexture([[Interface\Common\Common-Input-Border]])
        tLeft:SetTexCoord(0, 0.0625, 0, 0.625)
        tLeft:SetSize(8, 20)
        tLeft:SetPoint('LEFT')
    end

    local tRight = self:CreateTexture(nil, 'BACKGROUND') do
        tRight:SetTexture([[Interface\Common\Common-Input-Border]])
        tRight:SetTexCoord(0.9375, 1.0, 0, 0.625)
        tRight:SetSize(8, 20)
        tRight:SetPoint('RIGHT')
    end

    local tMid = self:CreateTexture(nil, 'BACKGROUND') do
        tMid:SetTexture([[Interface\Common\Common-Input-Border]])
        tMid:SetTexCoord(0.0625, 0.9375, 0, 0.625)
        tMid:SetPoint('TOPLEFT', tLeft, 'TOPRIGHT')
        tMid:SetPoint('BOTTOMRIGHT', tRight, 'BOTTOMLEFT')
    end

    local Prompt = self:CreateFontString(nil, 'ARTWORK', 'GameFontDisableSmall') do
        Prompt:SetJustifyH('LEFT')
        Prompt:SetJustifyV('TOP')
        Prompt:SetPoint('LEFT', 8, 0)
    end

    self.Prompt = Prompt
    self.Label = Label
    self.tLeft = tLeft
    self.tRight = tRight

    self:SetFontObject('GameFontHighlightSmall')
    self:SetAutoFocus(nil)
    self:SetTextInsets(8, 8, 0, 0)

    self:SetScript('OnEscapePressed', self.ClearFocus)
    self:SetScript('OnEnterPressed', self.OnEnterPressed)
    self:SetScript('OnEditFocusLost', self.OnEditFocusLost)
    self:SetScript('OnEditFocusGained', self.OnEditFocusGained)
    self:SetScript('OnTextChanged', self.OnTextChanged)
    self:SetScript('OnDisable', self.OnDisable)
    self:SetScript('OnEnable', self.OnEnable)
end

function InputBox:OnEnterPressed()
    if self.enableAutoComplete and self.AutoCompleteMenu then
        local item = self.AutoCompleteMenu:GetSelectedItem()
        if item then
            self:SetText(item)
        end
    end
    self:ClearFocus()
end

function InputBox:OnEditFocusLost()
    self:HighlightText(0, 0)
    self:HideAutoCompleteMenu()
    self:Fire('OnEditFocusLost')
end

function InputBox:OnEditFocusGained()
    self:HighlightText()
    self:RefreshAutoComplete()
    self:Fire('OnEditFocusGained')
end

function InputBox:OnArrowPressed(key)
    if not self.AutoCompleteMenu then
        return
    end
    local delta = ARROW_DELTA[key]
    if not delta then
        return
    end

    local index = self.AutoCompleteMenu:GetSelected()
    local count = self.AutoCompleteMenu:GetItemCount()

    if not index then
        index = delta == 1 and 1 or count
    else
        index = (index + delta - 1) % count + 1
    end

    local offset = self.AutoCompleteMenu:GetOffset()
    local maxCount = self.AutoCompleteMenu:GetMaxCount()

    if index < offset then
        offset = index
    elseif index >= offset + maxCount then
        offset = index - maxCount + 1
    end

    self.AutoCompleteMenu:SetOffset(offset)
    self.AutoCompleteMenu:SetSelected(index)
end

function InputBox:OnTextChanged(...)
    self.Prompt:SetShown(self:GetText() == '')
    self:RefreshAutoComplete()
    self:Fire('OnTextChanged', ...)
end

function InputBox:OnDisable()
    if self.Label:IsShown() then
        self.Label:SetAlpha(0.5)
        self:SetFontObject('GameFontDisableSmall')
    end
end

function InputBox:OnEnable()
    if self.Label:IsShown() then
        self.Label:SetAlpha(1)
        self:SetFontObject('GameFontHighlightSmall')
    end
end

function InputBox:SetPrompt(prompt)
    self.Prompt:SetText(prompt)
end

function InputBox:GetPrompt()
    return self.Prompt:GetText()
end

function InputBox:SetLabel(text, anchor, spacing)
    if not text or text == '' then
        if self.Label then
            self.Label:Hide()
        end
        return
    end

    if not self.Label then
        self.Label = self:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
    end

    anchor = anchor or 'LEFT'
    spacing = spacing or 5
    if anchor == 'LEFT' then
        self.Label:SetPoint('RIGHT', self, 'LEFT', -spacing, 0)
    elseif anchor == 'RIGHT' then
        self.Label:SetPoint('LEFT', self, 'RIGHT', spacing, 0)
    end

    self.Label:SetText(text)
    self.Label:Show()
end

function InputBox:SetText(text)
    return self:SuperCall('SetText', text or '')
end

function InputBox:EnableAutoComplete(flag)
    self.enableAutoComplete = flag
    self:SetScript('OnArrowPressed', flag and self.OnArrowPressed or nil)
    self:RefreshAutoComplete()
end

function InputBox:IsAutoCompleteEnabled()
    return self.enableAutoComplete
end

function InputBox:EnableAutoCompleteFilter(flag)
    self.disableAutoCompleteFilter = not flag or nil
    self:RefreshAutoComplete()
end

function InputBox:IsAutoCompleteFilterEnabled()
    return not self.disableAutoCompleteFilter
end

function InputBox:SetAutoCompleteList(data)
    self.autoCompleteData = data
    self:RefreshAutoComplete()
end

function InputBox:GetAutoCompleteList()
    return self.autoCompleteData
end

function InputBox:RefreshAutoComplete()
    if not self.enableAutoComplete or not self.autoCompleteData or not self:HasFocus() then
        return self:HideAutoCompleteMenu()
    end

    local text = self:GetText():lower()
    local list
    if self.disableAutoCompleteFilter or text == '' then
        list = self.autoCompleteData
    else
        list = {} do
            for i, v in ipairs(self.autoCompleteData) do
                if v:lower():find(text, 1, true) then
                    tinsert(list, v)
                end
            end
        end
    end
    if #list == 0 then
        return self:HideAutoCompleteMenu()
    end
    self:OpenAutoCompleteMenu(list)
end

function InputBox:HideAutoCompleteMenu()
    if self.AutoCompleteMenu and self.AutoCompleteMenu:GetParent() == self then
        self.AutoCompleteMenu:Hide()
    end
end

function InputBox:OpenAutoCompleteMenu(list)
    if not self.AutoCompleteMenu then
        local AutoCompleteMenu = GUI:GetClass('AutoCompleteFrame'):New(UIParent) do
            AutoCompleteMenu:SetColumnCount(1)
            AutoCompleteMenu:SetRowCount(10)
            AutoCompleteMenu:SetScrollStep(9)
            AutoCompleteMenu:Hide()
            AutoCompleteMenu:SetSize(1, 1)
            AutoCompleteMenu:SetSelectMode('RADIO')

            AutoCompleteMenu:SetCallback('OnItemFormatted', function(_, button, data)
                button:SetText(data)
            end)
            AutoCompleteMenu:SetCallback('OnItemClick', function(AutoCompleteMenu, _, data)
                AutoCompleteMenu:GetParent():SetText(data)
                AutoCompleteMenu:GetParent():ClearFocus()
            end)
            AutoCompleteMenu:SetScript('OnHide', function(AutoCompleteMenu)
                AutoCompleteMenu:SetSelected(nil)
            end)
        end
        InputBox.AutoCompleteMenu = AutoCompleteMenu
    end
    self.AutoCompleteMenu:SetItemList(list)
    self.AutoCompleteMenu:SetParent(self)
    self.AutoCompleteMenu:SetFrameStrata(self:GetFrameStrata())
    self.AutoCompleteMenu:SetFrameLevel(self:GetFrameLevel() + 30)
    self.AutoCompleteMenu:SetPoint('TOPLEFT', self.tLeft, 'BOTTOMLEFT', 7, 0)
    self.AutoCompleteMenu:SetPoint('TOPRIGHT', self.tRight, 'BOTTOMRIGHT', -9, 0)
    self.AutoCompleteMenu:Show()
    self.AutoCompleteMenu:Refresh()
end