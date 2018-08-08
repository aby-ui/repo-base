-- Overlay for quests.
-- Note that the Blizzard functions are "Quest" vs "QuestLog"


local function GetChoicesAndRewards()
    local questInfoFrame = _G["QuestInfoFrame"]
    if questInfoFrame.questLog then
        return GetNumQuestLogChoices(), GetNumQuestLogRewards()
    else
        return GetNumQuestChoices(), GetNumQuestRewards()
    end
end


local function GetItemLinkForQuests(rewardType, id)
    local questInfoFrame = _G["QuestInfoFrame"]
    if questInfoFrame.questLog then
        return GetQuestLogItemLink(rewardType, id)
    else
        return GetQuestItemLink(rewardType, id)
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


local function QuestOverlayOnEvent(frameName)
    local numChoices, numRewards = GetChoicesAndRewards()
    local totalRewards = numChoices + numRewards
    for i=1,totalRewards do
        local frame = _G[frameName..i]
        if frame then
            QuestFrameUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


local function AddIndexInfoToCIMIFrame(cimiFrame, numChoices, index, doingChoices)
    -- Add the index of the frame, so we can reference it
    cimiFrame.id = index
    index = index + 1
    if doingChoices then
        cimiFrame.rewardType = "choice"
        if index > numChoices then
            index = 1
            doingChoices = false
        end
    else
        cimiFrame.rewardType = "reward"
    end
    return index, doingChoices
end


local function AddAndUpdateQuestFrames(frameName)
    -- Add to the Quest Frame, and update if added.
    local numChoices, numRewards = GetChoicesAndRewards()
    local totalRewards = numChoices + numRewards

    local doingChoices = true
    local index = 1
    for i=1,totalRewards do
        local frame = _G[frameName..i]
        if frame then
            local cimiFrame = CIMI_AddToFrame(frame, QuestFrameUpdateIcon)
            if frame.CanIMogItOverlay then
                index, doingChoices = AddIndexInfoToCIMIFrame(frame.CanIMogItOverlay,
                    numChoices, index, doingChoices)
                QuestFrameUpdateIcon(frame.CanIMogItOverlay)
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
            function () AddAndUpdateQuestFrames("QuestInfoRewardsFrameQuestInfoItem") end)
    end
    if _G["MapQuestInfoRewardsFrame"] then
        _G["MapQuestInfoRewardsFrame"]:HookScript("OnShow",
            function () AddAndUpdateQuestFrames("MapQuestInfoRewardsFrameQuestInfoItem") end)
    end
end

CanIMogIt.frame:AddEventFunction(HookOverlayQuest)


------------------------
-- Event functions    --
------------------------

local function QuestOverlayEvents(event, ...)
    QuestOverlayOnEvent("QuestInfoRewardsFrameQuestInfoItem")
    QuestOverlayOnEvent("MapQuestInfoRewardsFrameQuestInfoItem")
end

CanIMogIt.frame:AddOverlayEventFunction(QuestOverlayEvents)
