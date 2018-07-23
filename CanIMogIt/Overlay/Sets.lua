-- Overlay for the Appearances > Sets collection.


----------------------------
-- UpdateIcon functions   --
----------------------------


function CIMI_AddToFrameSets(parentFrame)
    -- Create the Texture and set OnUpdate
    if parentFrame and not parentFrame.CanIMogItOverlay then
        local frame = CreateFrame("Frame", "CIMIOverlayFrame_"..tostring(parentFrame:GetName()), parentFrame)
        parentFrame.CanIMogItOverlay = frame
        -- Get the frame to match the shape/size of its parent
        frame:SetAllPoints()

        -- Create the font frame.
        frame.CanIMogItSetText = frame:CreateFontString("CIMIOverlayFrame_"..tostring(parentFrame:GetName()), "OVERLAY", "GameFontNormalSmall")
        frame.CanIMogItSetText:SetPoint("BOTTOMRIGHT", -2, 2)

        function frame:UpdateText()
            if CanIMogItOptions["showSetInfo"] then
                frame.CanIMogItSetText:SetText(CanIMogIt:GetSetsVariantText(parentFrame.setID) or "")
            else
                frame.CanIMogItSetText:SetText("")
            end
        end
    end
end


------------------------
-- Function hooks     --
------------------------


function WardrobeCollectionFrame_CIMIOnValueChanged()
    -- For each button, update the text value
    for i=1,CanIMogIt.NUM_WARDROBE_COLLECTION_BUTTONS do
        local frame = _G["WardrobeCollectionFrameScrollFrameButton"..i]
        if frame and frame.CanIMogItOverlay then
            frame.CanIMogItOverlay:UpdateText()
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


------------------------
-- Event functions    --
------------------------


CanIMogIt.frame:HookScript("OnEvent", function (self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "Blizzard_Collections" then
        -- Add to frame initially
        for i=1,CanIMogIt.NUM_WARDROBE_COLLECTION_BUTTONS do
            local frame = _G["WardrobeCollectionFrameScrollFrameButton"..i]
            if frame then
                CIMI_AddToFrameSets(frame)
            end
        end

        -- When the scrollbar moves, update the display.
        _G["WardrobeCollectionFrameScrollFrameScrollBar"]:HookScript("OnValueChanged", WardrobeCollectionFrame_CIMIOnValueChanged)
        _G["WardrobeCollectionFrameTab2"]:HookScript("OnClick", WardrobeCollectionFrame_CIMIOnValueChanged)

        CanIMogIt:RegisterMessage("OptionUpdate", function () C_Timer.After(.25, WardrobeCollectionFrame_CIMIOnValueChanged) end)
    end
    if event == "TRANSMOG_SEARCH_UPDATED" then
        -- Must add a delay, as the frame updates after this is called.
        C_Timer.After(.25, WardrobeCollectionFrame_CIMIOnValueChanged)
    end
end)
