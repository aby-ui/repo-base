
-------------------------------------
-- 物品邊框 Author: M
-------------------------------------

local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibSchedule = LibStub:GetLibrary("LibSchedule.7000")


local function SetItemAngularBorderScheduled(button, quality, itemIDOrLink)
    if (button.angularFrame) then return end
    LibSchedule:AddTask({
        identity  = tostring(button),
        begined   = math.random() / 2,
        elasped   = 0.5,
        expired   = GetTime() + 2,
        button    = button,
        onExecute = function(self)
            if (not self.button.angularFrame) then
                local anchor, w, h = self.button.IconBorder or self.button, self.button:GetSize()
                local ww, hh = anchor:GetSize()
                if (ww == 0 or hh == 0) then
                    anchor = self.button.Icon or self.button.icon or self.button
                    w, h = anchor:GetSize()
                else
                    w, h = min(w, ww), min(h, hh)
                end
                if (w > h * 1.28) then
                    w = h
                end
                self.button.angularFrame = CreateFrame("Frame", nil, self.button)
                self.button.angularFrame:SetFrameLevel(5)
                self.button.angularFrame:SetSize(w, h)
                self.button.angularFrame:SetPoint("CENTER", anchor, "CENTER", 0, 0)
                self.button.angularFrame:Hide()
                self.button.angularFrame.mask = CreateFrame("Frame", nil, self.button.angularFrame, BackdropTemplateMixin and "BackdropTemplate" or nil)
                self.button.angularFrame.mask:SetSize(w-2, h-2)
                self.button.angularFrame.mask:SetPoint("CENTER")
                self.button.angularFrame.mask:SetBackdrop({edgeFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeSize = 2})
                self.button.angularFrame.mask:SetBackdropBorderColor(0, 0, 0)
                self.button.angularFrame.border = CreateFrame("Frame", nil, self.button.angularFrame, BackdropTemplateMixin and "BackdropTemplate" or nil)
                self.button.angularFrame.border:SetSize(w, h)
                self.button.angularFrame.border:SetPoint("CENTER")
                self.button.angularFrame.border:SetBackdrop({edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
            end
            if (TinyInspectDB and TinyInspectDB.ShowItemBorder) then
                LibEvent:trigger("SET_ITEM_ANGULARBORDER", self.button.angularFrame, quality, itemIDOrLink)
            else
                self.button.angularFrame:Hide()
            end
            return true
        end,
    })
end

--直角邊框 @trigger SET_ITEM_ANGULARBORDER
local function SetItemAngularBorder(self, quality, itemIDOrLink)
    if (not self) then return end
    if (not self.angularFrame) then
        return SetItemAngularBorderScheduled(self, quality, itemIDOrLink)
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
    if (quality) then
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
if (false and RankFrame) then
    RankFrame:SetFrameLevel(8)
    RankFrame.Texture:Hide()
    RankFrame:SetPoint("CENTER", CharacterNeckSlot, "BOTTOM", 0, 8)
    local fontFile, fontSize, fontFlags = TextStatusBarText:GetFont()
    RankFrame.Label:SetFont(fontFile, fontSize, "THINOUTLINE")
    RankFrame.Label:SetTextColor(0, 0.9, 0.9)
end
