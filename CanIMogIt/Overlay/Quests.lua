-- Overlay for quests.
-- Note that the Blizzard functions are "Quest" vs "QuestLog"


local function GetItemLinkForQuests(rewardType, id)
    -- Gets the item link for the currently selected quest.
    -- rewardType is either "choice" or "reward"
    -- id is the ID of the reward button frame.
    local questInfoFrame = _G["QuestInfoFrame"]
    if questInfoFrame.questLog then
        return GetQuestLogItemLink(rewardType, id)
    else
        return GetQuestItemLink(rewardType, id)
    end
end


local function GetRewardButtons()
    -- Gets the reward buttons that the CIMI frame is attached to.
    -- Works for both the map quest details and the standalone quest details.
    local questInfoFrame = _G["QuestInfoFrame"]
    if questInfoFrame and questInfoFrame.rewardsFrame then
        return questInfoFrame.rewardsFrame.RewardButtons
    end
end

----------------------------
-- UpdateIcon functions   --
----------------------------


local function QuestFrameUpdateIcon(self)
    -- Updates the icons for the Quest Frame
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    if not self.rewardType
       or not self.id
       or self.objectType ~= "item" then
        return
    end
    local itemLink = GetItemLinkForQuests(self.rewardType, self.id)
    self.itemLink = itemLink
    if itemLink == nil then
        CIMI_SetIcon(self, QuestFrameUpdateIcon, nil)
    else
        CIMI_SetIcon(self, QuestFrameUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end


------------------------
-- Function hooks     --
------------------------


----------------------------
-- Begin adding to frames --
----------------------------


local function AddIndexInfoToCIMIFrame(cimiFrame, rewardButton)
    -- Save the index/ID of the frame, and if it is a choice or not, so we can reference it
    -- when figuring out the icon.
    cimiFrame.id = rewardButton:GetID()
    cimiFrame.rewardType = rewardButton.type
    cimiFrame.objectType = rewardButton.objectType
    return index
end


local function AddAndUpdateQuestFrames()
    -- Add to the Quest Frame, and update if added.
    -- Use MapQuestInfoRewardsFrameQuestInfoItem#, which has questID on it <-- map log details frame
    -- Use QuestInfoRewardsFrameQuestInfoItem#, which has questID on it <-- old stand alone details frame
    -- Right-click on objectives quest for old stand alone frame
    local rewardButtons = GetRewardButtons()
    if rewardButtons then
        for _, rewardButton in ipairs(rewardButtons) do
            if rewardButton then
                local cimiFrame = CIMI_AddToFrame(rewardButton, QuestFrameUpdateIcon, nil, "TOPRIGHT")
                if rewardButton.CanIMogItOverlay then
                    AddIndexInfoToCIMIFrame(rewardButton.CanIMogItOverlay, rewardButton)
                    QuestFrameUpdateIcon(rewardButton.CanIMogItOverlay)
                end
            end
        end
    end
end


local function HookOverlayQuest(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for clicking on the Continue button in the
    -- quest frame (since there is no event).
    if _G["QuestInfoRewardsFrame"] then
        _G["QuestInfoRewardsFrame"]:HookScript("OnShow",
            function () AddAndUpdateQuestFrames() end)
    end
    if _G["MapQuestInfoRewardsFrame"] then
        _G["MapQuestInfoRewardsFrame"]:HookScript("OnShow",
            function () AddAndUpdateQuestFrames() end)
    end
end

CanIMogIt.frame:AddEventFunction(HookOverlayQuest)


------------------------
-- Event functions    --
------------------------

local function QuestOverlayEvents(event, ...)
    local rewardButtons = GetRewardButtons()
    if rewardButtons then
        for _, rewardButton in ipairs(rewardButtons) do
            if rewardButton then
                QuestFrameUpdateIcon(rewardButton.CanIMogItOverlay)
            end
        end
    end
end

CanIMogIt.frame:AddOverlayEventFunction(QuestOverlayEvents)
hooksecurefunc("QuestLogPopupDetailFrame_Update", QuestOverlayEvents)

CanIMogIt:RegisterMessage("OptionUpdate", QuestOverlayEvents)
