
-------------------------------------
-- 物品邊框 Author: M
-------------------------------------

local LibEvent = LibStub:GetLibrary("LibEvent.7000")

--直角邊框 @trigger SET_ITEM_ANGULARBORDER
local function SetItemAngularBorder(self, quality, itemIDOrLink)
    if (not self) then return end
    if (not self.angularFrame) then
        local parent = self.IconBorder or self
        local w, h = parent:GetSize()
        if (parent ~= self) then 
            local sw, sh = self:GetSize()
            w, h = min(w, sw), min(h, sh)
        end
        self.angularFrame = CreateFrame("Frame", nil, self)
        self.angularFrame:SetFrameLevel(5)
        self.angularFrame:SetSize(w, h)
        self.angularFrame:SetPoint("CENTER", parent, "CENTER")
        self.angularFrame:Hide()
        self.angularFrame.mask = CreateFrame("Frame", nil, self.angularFrame)
        self.angularFrame.mask:SetSize(w-2, h-2)
        self.angularFrame.mask:SetPoint("CENTER")
        self.angularFrame.mask:SetBackdrop({edgeFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeSize = 2})
        self.angularFrame.mask:SetBackdropBorderColor(0, 0, 0)
        self.angularFrame.border = CreateFrame("Frame", nil, self.angularFrame)
        self.angularFrame.border:SetSize(w, h)
        self.angularFrame.border:SetPoint("CENTER")
        self.angularFrame.border:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
    end
    if (TinyInspectDB and TinyInspectDB.ShowItemBorder) then
        LibEvent:trigger("SET_ITEM_ANGULARBORDER", self.angularFrame, quality, itemIDOrLink)
    else
        self.angularFrame:Hide()
    end
end

--功能附着
hooksecurefunc("SetItemButtonQuality", SetItemAngularBorder)
LibEvent:attachEvent("ADDON_LOADED", function(self, addonName)
    if (addonName == "Blizzard_InspectUI") then
        hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(self)
            local textureName = GetInventoryItemTexture(InspectFrame.unit, self:GetID())
            if (not textureName) then SetItemAngularBorder(self, false) end
        end)
    end
end)

--設置物品直角邊框
LibEvent:attachTrigger("SET_ITEM_ANGULARBORDER", function(self, frame, quality, itemIDOrLink)
    if (quality and quality > 0) then
        local r, g, b = GetItemQualityColor(quality)
        if (quality <= 1) then
            r = r - 0.3
            g = g - 0.3
            b = b - 0.3
        end
        frame.border:SetBackdropBorderColor(r, g, b)
        frame:Show()
    else
        frame:Hide()
    end
end)

--直角邊框时需要调整艾泽拉斯项链等级框架
local RankFrame = CharacterNeckSlot and CharacterNeckSlot.RankFrame
if (RankFrame) then
    RankFrame.Texture:Hide()
    RankFrame:SetPoint("CENTER", CharacterNeckSlot, "BOTTOM", 0, 8)
    local fontFile, fontSize, fontFlags = TextStatusBarText:GetFont()
    RankFrame.Label:SetFont(fontFile, fontSize, "THINOUTLINE")
    RankFrame.Label:SetTextColor(0, 0.9, 0.9)
end
