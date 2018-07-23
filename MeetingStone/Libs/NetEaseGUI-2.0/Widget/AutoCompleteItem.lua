
local WIDGET, VERSION = 'AutoCompleteItem', 2

local GUI = LibStub('NetEaseGUI-2.0')
local AutoCompleteItem = GUI:NewClass(WIDGET, GUI:GetClass('ItemButton'), VERSION)
if not AutoCompleteItem then
    return
end

function AutoCompleteItem:Constructor(parent)
    self:SetFrameLevel(parent:GetFrameLevel())
    
    self:SetNormalAtlas('_search-rowbg')
    self:SetPushedAtlas('_search-rowbg')
    self:SetHighlightAtlas('search-highlight')

    self:SetCheckedTexture([[Interface\Common\Search]])
    self:GetCheckedTexture():SetAtlas('search-select')

    local text = self:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight') do
        text:SetPoint('TOPLEFT', 5, 0)
        text:SetPoint('BOTTOMRIGHT')
        text:SetJustifyH('LEFT')
        self:SetFontString(text)
        self:SetNormalFontObject(GameFontHighlightSmall)
        self:SetHighlightFontObject(GameFontHighlightSmall)
        self:SetDisabledFontObject(GameFontDisableSmall)
    end
end
