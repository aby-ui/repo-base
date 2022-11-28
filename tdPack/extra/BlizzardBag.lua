
local tdPack = tdCore(...)
local L = tdPack:GetLocale()

local PackButton = tdCore(...)('PackButton')

local SIZE = 18
local NORMAL_TEXTURE_SIZE = 64 * (SIZE/36)

function PackButton:Init()
    self:SetSize(SIZE, SIZE)

    local nt = self:CreateTexture()
    nt:SetTexture([[Interface\Buttons\UI-Quickslot2]])
    nt:SetSize(NORMAL_TEXTURE_SIZE, NORMAL_TEXTURE_SIZE)
    nt:SetPoint('CENTER', 0, -1)
    self:SetNormalTexture(nt)

    local pt = self:CreateTexture()
    pt:SetTexture([[Interface\Buttons\UI-Quickslot-Depress]])
    pt:SetAllPoints(self)
    self:SetPushedTexture(pt)

    local ht = self:CreateTexture()
    ht:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
    ht:SetAllPoints(self)
    self:SetHighlightTexture(ht)

    local icon = self:CreateTexture()
    icon:SetAllPoints(self)
    icon:SetTexture([[Interface\Icons\INV_Misc_Bag_10_Green]])
end

local packButton = PackButton:GetPackButton(BagItemSearchBox)
packButton:SetPoint('RIGHT', BagItemSearchBox, 'LEFT', -10, -1)