BuildEnv(...)

debug = IsAddOnLoaded('!!!!!tdDevTools') and print or nop

Addon = LibStub('AceAddon-3.0'):GetAddon('MeetingStone')

CheckBox = Addon:NewClass('CheckBox', 'Frame')

function CheckBox:Constructor()
    local Check = CreateFrame('CheckButton', nil, self) do
        Check:SetNormalTexture([[Interface\Buttons\UI-CheckBox-Up]])
        Check:SetPushedTexture([[Interface\Buttons\UI-CheckBox-Down]])
        Check:SetHighlightTexture([[Interface\Buttons\UI-CheckBox-Highlight]])
        Check:SetCheckedTexture([[Interface\Buttons\UI-CheckBox-Check]])
        Check:SetDisabledCheckedTexture([[Interface\Buttons\UI-CheckBox-Check-Disabled]])
        Check:SetSize(22, 22)
        Check:SetPoint('TOPLEFT')
        Check:SetFontString(Check:CreateFontString(nil, 'ARTWORK'))
        Check:GetFontString():SetPoint('LEFT', Check, 'RIGHT', 2, 0)
        Check:SetNormalFontObject('GameFontHighlightSmall')
        Check:SetHighlightFontObject('GameFontNormalSmall')
        Check:SetDisabledFontObject('GameFontDisableSmall')
        Check:SetScript('OnClick', function()
            self:OnCheckClick()
        end)
    end

    local function UpdateCheck()
        self:UpdateCheck()
    end

    self:SetHeight(20)

    self.Check = Check
    self.Check:SetChecked(false)
end

function CheckBox:UpdateCheck()
    -- if self.key ~= 'BossKilled' then
    --     self.Check:SetChecked(self.MinBox:GetNumber() ~= 0 or self.MaxBox:GetNumber() ~= 0)
    -- end
    self:Fire('OnChanged')
end

function CheckBox:OnCheckClick()
    self:Fire('OnChanged')
end

function CheckBox:Clear()
    self.Check:SetChecked(false)
end
function CheckChinese(s)
    local ret = {};
    local f = '[%z\1-\127\194-\244][\128-\191]*';
    local line, lastLine, isBreak = '', false, false;
    for v in s:gmatch(f) do
        table.insert(ret, {c=v, isChinese = (#v~=1) } );
    end
    return ret;
end
