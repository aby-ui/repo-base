
if not IsAddOnLoaded('BaudBag') then return end

local PackButton = tdCore(...)('PackButton')

local SIZE = 24

function PackButton:Init()
    self:SetSize(SIZE, SIZE)
    self:SetPushedTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Down]])
    self:SetNormalTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
    self:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]])
end

do
    local function InitButton(frame)
        local packButton = PackButton:GetPackButton(frame)
        packButton:SetPoint('LEFT', _G[frame:GetName() .. 'BagsButton'], 'RIGHT')
        _G[frame:GetName()..'Name']:SetJustifyH('CENTER')
    end
    
    InitButton(BaudBagContainer1_1)
    InitButton(BaudBagContainer2_1)
end
