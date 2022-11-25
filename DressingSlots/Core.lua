local version, build, date, tocversion = GetBuildInfo()
local undressButton
local toggleSheatheButton
local resizeButton

-- Undress button
undressButton = CreateFrame("Button", nil, DressUpFrame.OutfitDetailsPanel, "UIPanelButtonTemplate")
undressButton:SetSize(80, 22)
undressButton:SetText(RESET)
undressButton:SetPoint("BOTTOMLEFT", 8, 9) --7
undressButton:SetScript("OnClick", function()
    --DressUpFrame.ModelScene:GetPlayerActor():Undress()
    if DressingSlots.lastSetModel then
        DressUpItemTransmogInfoList(DressingSlots.lastSetModel)
        PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
    end
end)

-- Toggle sheathe button
toggleSheatheButton = CreateFrame("Button", nil, DressUpFrame.OutfitDetailsPanel, "UIPanelButtonTemplate")
toggleSheatheButton:SetSize(120, 22)
toggleSheatheButton:SetText(LOCALE_zhCN and "收起/拿出武器" or "Toggle sheathe")
toggleSheatheButton:SetPoint("BOTTOMLEFT", 87, 9)
toggleSheatheButton:SetScript("OnClick", function()
    local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
    playerActor:SetSheathed(not playerActor:GetSheathed())
    PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
end)

-- Resize window button
resizeButton = CreateFrame("Button", nil, DressUpFrame)
resizeButton:SetSize(16, 16)
resizeButton:SetNormalTexture("Interface/ChatFrame/UI-ChatIM-SizeGrabber-Up")
resizeButton:SetHighlightTexture("Interface/ChatFrame/UI-ChatIM-SizeGrabber-Highlight")
resizeButton:SetPushedTexture("Interface/ChatFrame/UI-ChatIM-SizeGrabber-Down")
resizeButton:SetPoint("BOTTOMRIGHT", -2, 2)
resizeButton:SetScript("OnMouseDown", function(self, button)
    DressUpFrame:StartSizing("BOTTOMRIGHT")
end)
resizeButton:SetScript("OnMouseUp", function(self, button)
    DressUpFrame:StopMovingOrSizing()
    UpdateUIPanelPositions(self)
    DressHeight = DressUpFrame:GetHeight()
    DressWidth = DressUpFrame:GetWidth()
end)

DressUpFrame.ResetButton:HookScript("OnHide", function ()
    resizeButton:Hide()
end)
DressUpFrame.ResetButton:HookScript("OnShow", function ()
    resizeButton:Show()
end)

-- Hook onto DressUpFrame ConfigureSize in order to provide resize functionality
local _ConfigureSize = DressUpFrame.ConfigureSize
function DressUpFrame:ConfigureSize(isMinimized)
    local result = _ConfigureSize(self, isMinimized)
    -- Resize stuff
    DressUpFrameCancelButton:SetPoint("BOTTOMRIGHT", -14, 4)
    DressUpFrame:SetResizable(true)
    if tocversion < 100000 then
        DressUpFrame:SetMinResize(334, 423)
        DressUpFrame:SetMaxResize(DressUpFrame:GetTop() * 0.8, DressUpFrame:GetTop())
    else
        DressUpFrame:SetResizeBounds(334, 423, DressUpFrame:GetTop() * 0.8, DressUpFrame:GetTop())
    end
    if DressHeight and DressHeight <= DressUpFrame:GetTop() and DressWidth <= (DressUpFrame:GetTop()) then
        DressUpFrame:SetSize(DressWidth, DressHeight)
        UpdateUIPanelPositions(self)
    end
    -- Listen for minimize/maximize to reset size
    local maximize = DressUpFrame.MaximizeMinimizeFrame.MaximizeButton:GetScript("OnClick")
    DressUpFrame.MaximizeMinimizeFrame.MaximizeButton:SetScript("OnClick", function(self)
        DressHeight = nil
        DressWidth = nil
        maximize(self)
    end)
    local minimize = DressUpFrame.MaximizeMinimizeFrame.MinimizeButton:GetScript("OnClick")
    DressUpFrame.MaximizeMinimizeFrame.MinimizeButton:SetScript("OnClick", function(self)
        DressHeight = nil
        DressWidth = nil
        minimize(self)
    end)
    return result
end

-- Handle right-clicks for each "slot" in the appearance list
local _Acquire = DressUpFrame.OutfitDetailsPanel.slotPool.Acquire
function DressUpFrame.OutfitDetailsPanel.slotPool:Acquire()
    local frame, isNew = _Acquire(self)
    if isNew then
        frame:HookScript("OnMouseUp", function (self, button)
            if button == "RightButton" then
                local playerActor = DressUpFrame.ModelScene:GetPlayerActor()
                local itemTransmogInfo = playerActor:GetItemTransmogInfo(frame.slotID)
                if itemTransmogInfo then
                    if itemTransmogInfo.secondaryAppearanceID ~= Constants.Transmog.NoTransmogID and itemTransmogInfo.secondaryAppearanceID ~= -1 then
                        if frame.transmogID == itemTransmogInfo.appearanceID then
                            itemTransmogInfo.appearanceID = itemTransmogInfo.secondaryAppearanceID
                        end
                        if C_TransmogCollection.IsAppearanceHiddenVisual(itemTransmogInfo.appearanceID) then
                            itemTransmogInfo.secondaryAppearanceID = itemTransmogInfo.appearanceID
                            playerActor:SetItemTransmogInfo(itemTransmogInfo, frame.slotID, false)
                            playerActor:UndressSlot(frame.slotID)
                        else
                            itemTransmogInfo.secondaryAppearanceID = Constants.Transmog.NoTransmogID
                            playerActor:SetItemTransmogInfo(itemTransmogInfo, frame.slotID, false)
                        end
                    elseif frame.transmogID == itemTransmogInfo.illusionID then
                        itemTransmogInfo.illusionID = Constants.Transmog.NoTransmogID
                        playerActor:SetItemTransmogInfo(itemTransmogInfo, frame.slotID, false)
                    else
                        playerActor:UndressSlot(frame.slotID)
                    end
                    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
                end
            end
        end)
    end
    return frame, isNew
end
