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


function WardrobeCollectionFrame_CIMIOnValueChanged(_, elapsed)
    -- For each button, update the text value
    if _G["WardrobeCollectionFrame"] == nil then return end
    if not CanIMogIt.FrameShouldUpdate("WardrobeSets", elapsed or 1) then return end
    local wardrobeSetsScrollFrame = _G["WardrobeCollectionFrame"].SetsCollectionFrame.ListContainer.ScrollBox
    local setFrames = wardrobeSetsScrollFrame:GetFrames()
    for i = 1, #setFrames do
        local frame = setFrames[i]
        if frame then
            -- add to frame
            CIMI_AddToFrameSets(frame)
        end
        if frame and frame.CanIMogItOverlay then
            -- update frame
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
        -- When the scrollbar moves, update the display.
        _G["WardrobeCollectionFrame"].SetsCollectionFrame.ListContainer:HookScript("OnUpdate", WardrobeCollectionFrame_CIMIOnValueChanged)
        _G["WardrobeCollectionFrameTab2"]:HookScript("OnClick", WardrobeCollectionFrame_CIMIOnValueChanged)

        CanIMogIt:RegisterMessage("OptionUpdate", function () C_Timer.After(.25, WardrobeCollectionFrame_CIMIOnValueChanged) end)
    end
    if event == "TRANSMOG_SEARCH_UPDATED" then
        -- Must add a delay, as the frame updates after this is called.
        C_Timer.After(.25, WardrobeCollectionFrame_CIMIOnValueChanged)
    end
end)
