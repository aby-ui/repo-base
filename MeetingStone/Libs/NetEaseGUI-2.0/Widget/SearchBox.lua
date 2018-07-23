
local WIDGET, VERSION = 'SearchBox', 1

local GUI = LibStub('NetEaseGUI-2.0')
local InputBox = GUI:GetClass('InputBox')
local SearchBox = GUI:NewClass(WIDGET, InputBox, VERSION)
if not SearchBox then
    return
end

function SearchBox:Constructor(parent)
    local SearchIcon = self:CreateTexture(nil, 'ARTWORK') do
        SearchIcon:SetTexture([[Interface\Common\UI-Searchbox-Icon]])
        SearchIcon:SetPoint('LEFT', 5, -2)
        SearchIcon:SetSize(14, 14)
        SearchIcon:SetVertexColor(0.6, 0.6, 0.6)
    end

    local ClearButton = GUI:GetClass('ClearButton'):New(self) do
        ClearButton:SetPoint('RIGHT', -3, 0)
        ClearButton:SetScript('OnClick', function()
            self:Clear()
        end)
        ClearButton:Hide()
    end

    self.SearchIcon = SearchIcon
    self.ClearButton = ClearButton

    self:SetPrompt(SEARCH)
    self:SetTextInsets(21, 20, 0, 0)
    self:SetFontObject('GameFontHighlightSmall')

    self:SetScript('OnEditFocusLost', self.OnEditFocusLost)
    self:SetScript('OnEditFocusGained', self.OnEditFocusGained)
    self:SetScript('OnHide', self.OnHide)

    self.Prompt:ClearAllPoints();
    self.Prompt:SetPoint('TOPLEFT', self, 'TOPLEFT', 21, 0)
    self.Prompt:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -20, 0)
end

function SearchBox:OnEditFocusLost()
    local text = self:GetText()
    if text == '' then
        self.SearchIcon:SetVertexColor(0.6, 0.6, 0.6)
        self.ClearButton:Hide()
    end
    InputBox.OnEditFocusLost(self)
end

function SearchBox:OnEditFocusGained()
    self:HighlightText()
    self.SearchIcon:SetVertexColor(1.0, 1.0, 1.0)
    self.ClearButton:Show()
    InputBox.OnEditFocusGained(self)
end

function SearchBox:Clear()
    PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or 'igMainMenuOptionCheckBoxOn')
    self:SetText('')
    self:ClearFocus()
    self:OnEditFocusLost()
end

function SearchBox:OnHide()
    self:SetText('')
end
