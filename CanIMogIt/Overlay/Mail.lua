-- Overlay for mail.


----------------------------
-- UpdateIcon functions   --
----------------------------


function MailFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local frameID = self:GetParent():GetID()

    local messageIndex;
    for i=1,CanIMogIt.NUM_MAIL_INBOX_ITEMS do
        local mailFrame = _G["MailItem"..i.."Button"]
        if mailFrame:IsShown() and mailFrame:GetChecked() then
            messageIndex = mailFrame.index
        end
    end
    if not messageIndex then
        CIMI_SetIcon(self, MailFrame_CIMIUpdateIcon, "")
        return
    end

    local itemLink = GetInboxItemLink(messageIndex, frameID)
    CIMI_SetIcon(self, MailFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


function MailFrame_CIMIOnClick()
    for i=1,ATTACHMENTS_MAX_SEND do
        local frame = _G["OpenMailAttachmentButton"..i]
        if frame then
            MailFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


local function HookOverlayMail(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for the Mail inbox frames.
    for i=1,ATTACHMENTS_MAX_SEND do
        local frame = _G["OpenMailAttachmentButton"..i]
        if frame then
            CIMI_AddToFrame(frame, MailFrame_CIMIUpdateIcon)
        end
    end

    -- Add hook for clicking on mail (since there is no event).
    for i=1,CanIMogIt.NUM_MAIL_INBOX_ITEMS do
        local frame = _G["MailItem"..i.."Button"]
        if frame then
            frame:HookScript("OnClick", MailFrame_CIMIOnClick)
        end
    end
end

CanIMogIt.frame:AddEventFunction(HookOverlayMail)


------------------------
-- Event functions    --
------------------------
