local tdPack = tdCore(...)

CoreDependCall("Combuctor", function()

    local PackButton = tdPack('PackButton')

    local SIZE = 20
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

    local anchor = function(self, id)
        if CombuctorInventoryFrame1SearchBox and not CombuctorInventoryFrame1SearchBox.tdPackButton then
            CombuctorInventoryFrame1SearchBox.frameID = CombuctorInventoryFrame1SearchBox:GetParent().frameID
            CombuctorInventoryFrame1SearchBox:SetPoint('TOPLEFT', 70 + 30, -32)
            local inv = PackButton:GetPackButton(CombuctorInventoryFrame1SearchBox)
            inv:ClearAllPoints()
            inv:SetPoint("TOPLEFT", -30, 0)
        end
        if CombuctorBankFrame1SearchBox and not CombuctorBankFrame1SearchBox.tdPackButton then
            CombuctorBankFrame1SearchBox.frameID = CombuctorBankFrame1SearchBox:GetParent().frameID
            CombuctorBankFrame1SearchBox:SetPoint('TOPLEFT', 70 + 30, -32)
            local bnk = PackButton:GetPackButton(CombuctorBankFrame1SearchBox)
            bnk:ClearAllPoints()
            bnk:SetPoint("TOPLEFT", -30, 0)
        end
    end
    anchor()
    hooksecurefunc(Combuctor.Frame, "New", anchor)
end)