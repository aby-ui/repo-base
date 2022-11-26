DressingSlots = DressingSlots or {}

local function SetModel(unit, playerActor)
    if unit == "player" then
        playerActor:SetModelByUnit("player")
    elseif unit == "target" then
        if not UnitIsPlayer("target") then return U1Message("无法设置非玩家目标,否则可能导致游戏崩溃") end
        local nativeForm = nil
        if select(2, UnitClass("target")) == "EVOKER" then nativeForm = false end
        playerActor:SetModelByUnit("target", true, true, false, nativeForm) --unit, heldWeapon, autoDress, hideWeapon, nativeForm
    end
end

local undress2Button = WW:Button(nil, DressUpFrame, "UIPanelButtonTemplate"):SetSize(26, 22):SetText("脱"):SetPoint("RIGHT", "DressUpFrameResetButton", "LEFT"):RegisterForClicks("AnyUp"):kv("tooltipAnchorPoint", "ANCHOR_BOTTOM"):un()
undress2Button:SetScript("OnClick", function()
    local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
    if DressingSlots.lastUndress then
        DressUpItemTransmogInfoList(DressingSlots.lastUndress)
        DressingSlots.lastUndress = nil
    else
        DressingSlots.lastUndress = playerActor:GetItemTransmogInfoList()
        playerActor:Undress()
    end
end)
CoreUIEnableTooltip(undress2Button, "脱衣/穿衣", "再次点击可以穿回之前的装备")

local targetButton = WW:Button(nil, DressUpFrame, "UIPanelButtonTemplate"):SetSize(44, 22):SetText("目标"):SetPoint("RIGHT", undress2Button, "LEFT"):RegisterForClicks("AnyUp"):kv("tooltipAnchorPoint", "ANCHOR_BOTTOM"):un()
targetButton:SetScript("OnClick", function(self, button)
    local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
    if button == "RightButton" then
        SetModel("player", playerActor)
        C_Timer.After(0, function()
            local set = playerActor:GetItemTransmogInfoList()
            SetModel("target", playerActor)
            DressUpItemTransmogInfoList(set)
            DressingSlots.lastSetModel = set
        end)
    else
        SetModel("target", playerActor)
    end
end)
CoreUIEnableTooltip(targetButton, "目标模型", "左键：目标自身套装\n右键：试穿玩家装备")

local selfButton = WW:Button(nil, DressUpFrame, "UIPanelButtonTemplate"):SetSize(44, 22):SetText("自身"):SetPoint("RIGHT", targetButton, "LEFT"):RegisterForClicks("AnyUp"):kv("tooltipAnchorPoint", "ANCHOR_BOTTOM"):un()
selfButton:SetScript("OnClick", function(self, button)
    local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
    if button == "RightButton" then
        SetModel("target", playerActor)
        C_Timer.After(0, function()
            local set = playerActor:GetItemTransmogInfoList()
            SetModel("player", playerActor)
            DressUpItemTransmogInfoList(set)
            DressingSlots.lastSetModel = set
        end)
    else
        SetModel("player", playerActor)
    end
end)
CoreUIEnableTooltip(selfButton, "玩家模型", "左键：玩家自身套装\n右键：试穿目标装备")

local originWidth = DressUpFrame.LinkButton:GetWidth()
local originText = DressUpFrame.LinkButton:GetText()
local function adjustLinkButtonSize()
    local shrink = DressUpFrame.LinkButton:GetLeft() + originWidth > selfButton:GetLeft()
    DressUpFrame.LinkButton:SetWidth(shrink and 40 or originWidth)
    DressUpFrame.LinkButton:SetText(shrink and (LOCALE_zhCN and "链接" or "Link") or originText)
end
DressUpFrame:HookScript("OnShow", adjustLinkButtonSize)
hooksecurefunc(DressUpFrame, "SetSize", adjustLinkButtonSize)
hooksecurefunc(DressUpFrame, "StopMovingOrSizing", adjustLinkButtonSize)

hooksecurefunc(DressUpFrame.ModelScene, "InitializeActor", function()
    local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
    if playerActor and not playerActor._aby_hooked then
        playerActor._aby_hooked = 1
        hooksecurefunc(playerActor, "SetModelByUnit", function(self)
            DressingSlots.lastSetModel = self:GetItemTransmogInfoList()
            DressingSlots.lastUndress = nil
        end)
    end
end)

DressUpFrame.ResetButton:HookScript("OnMouseUp", function(self, button)
    if button == "RightButton" and DressingSlots.lastSetModel then
        DressUpItemTransmogInfoList(DressingSlots.lastSetModel)
    end
end)