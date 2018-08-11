local QuestPOIGetIconInfo, GetNumQuestWatches, GetSuperTrackedQuestID, GetDistanceSqToQuest, QuestHasPOIInfo = QuestPOIGetIconInfo, GetNumQuestWatches, GetSuperTrackedQuestID, GetDistanceSqToQuest, QuestHasPOIInfo
local questsDis, orderedIndexes, GetQuestWatchInfo_old = {}, {}, GetQuestWatchInfo

local CONFIG = "!!!163ui!!!/questWatchSort"


local function ComparatorDist(id1, id2)
    local d1, d2 = questsDis[id1], questsDis[id2]
    if d1 < 0 and d2 >= 0 then return false end
    if d2 < 0 and d1 >= 0 then return true end
    return d1 < d2
end

--[[
function QSCalcDistance(questID)
    local _, x, y = QuestPOIGetIconInfo(questID)
    local px, py = GetPlayerMapPosition("player")
    x = x * 10000 y = y * 10000 px = px * 10000 py = py * 10000
    local d1 = ((px-x)*(px-x) + (py-y)*(py-y))
    local qI = GetQuestLogIndexByID(questID)
    local d2 = GetDistanceSqToQuest(qI)
    print(GetQuestLogTitle(qI), d1, d2, x, y, px, py)
end
--]]

local protectionTime = 0 --player manual click track button, protect for 5 seconds

local function UpdateQuestsDistance()

    if (QuestMapFrame and QuestMapFrame:IsVisible())
            or not U1DB.configs[CONFIG]
            or GetNumQuestWatches() < 1 then
        return
    end

    wipe(questsDis)
    wipe(orderedIndexes)

    --see Blizzard's QuestSuperTracking_ChooseClosestQuest
    for i = 1, GetNumQuestWatches() do
        orderedIndexes[i] = i
        local questID, title, questLogIndex = GetQuestWatchInfo_old(i);
        if ( questID and QuestHasPOIInfo(questID) ) then
            local distSqr, onContinent = GetDistanceSqToQuest(questLogIndex);
            --print(questLogIndex, distSqr, onContinent, title)
            if ( onContinent ) then
                questsDis[i] = distSqr
            else
                questsDis[i] = i - 1000
            end
        else
            questsDis[i] = i - 1000 -- < 0 and keep the order
        end
    end

    table.sort(orderedIndexes, ComparatorDist)

    local nearest = questsDis[orderedIndexes[1]]
    -- if the nearest is on the same map
    if nearest and nearest > 0 then
        --select super track, no need to call QuestSuperTracking_ChooseClosestQuest
        local questID, questLogTitle, questLogIndex = GetQuestWatchInfo_old(orderedIndexes[1])
        --print(nearest, orderedIndexes[1], questID, questLogTitle, questLogIndex)
        if (GetTime() > protectionTime and questID ~= GetSuperTrackedQuestID()) then
            --avoid frequent switching
            if WorldQuestTrackerAddon and WorldQuestTrackerAddon.SuperTracked and WorldQuestTrackerAddon.SuperTracked == GetSuperTrackedQuestID() then return end
            local currDist = GetDistanceSqToQuest(GetQuestLogIndexByID(GetSuperTrackedQuestID()))
            if currDist and currDist - nearest > nearest * 0.07 + 1000 then
                SetSuperTrackedQuestID(questID)
                PlaySoundFile("Sound\\Interface\\UI_BonusLootRoll_End_01.ogg")
                --PlaySoundFile("Sound\\Interface\\UI_BonusLootRoll_Start_01.ogg", "master")
                --PlaySound(73276, "master") --"UI_WorldQuest_Map_Select"
                --PlaySound(8939, "master") --"KeyRingClose"
                --WorldMapFrame_OnUserChangedSuperTrackedQuest(questID)
            end
        end

        -- force update
        if ObjectiveTrackerFrame and ObjectiveTrackerFrame:IsVisible() and not InCombatLockdown() then
            ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_QUEST);
            QuestObjectiveTracker_UpdatePOIs()
        end
    end
end

local function GetQuestWatchInfo_new(id)
    if(orderedIndexes and #orderedIndexes > 0) then
        return GetQuestWatchInfo_old(orderedIndexes[id] or id)
    else
        return GetQuestWatchInfo_old(id)
    end
end

local frame = CreateFrame("Frame", "QuestWatchSortEventFrame")

frame:RegisterEvent("QUEST_LOG_UPDATE");
frame:RegisterEvent("QUEST_WATCH_LIST_CHANGED");
frame:RegisterEvent("QUEST_AUTOCOMPLETE");
frame:RegisterEvent("QUEST_ACCEPTED");
frame:RegisterEvent("SCENARIO_UPDATE");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("ZONE_CHANGED");
frame:RegisterEvent("QUEST_POI_UPDATE");
frame:RegisterEvent("QUEST_TURNED_IN");
frame:RegisterEvent("NEW_WMO_CHUNK");

frame:RegisterEvent("VARIABLES_LOADED");

local function EnableOrDisable()
    if U1DB.configs[CONFIG] then
        if not frame.hooked then
            --only hook when necessary
            frame.hooked = 1
            GetQuestWatchInfo_old = GetQuestWatchInfo
            GetQuestWatchInfo = GetQuestWatchInfo_new
        end
        protectionTime = 0
        frame:Show()
    else
        frame:Hide()
    end
end

frame:SetScript("OnEvent", function(self, event)
    if(event == "VARIABLES_LOADED") then
        if U1DB.configs[CONFIG] == nil then U1DB.configs[CONFIG] = true end
        QuestWatchSortCheckButton:SetChecked(U1DB.configs[CONFIG])
        EnableOrDisable()
    else
        if (event == "NEW_WMO_CHUNK" and not WorldMapFrame:IsVisible()) then
            SetMapToCurrentZone() --Entering Dalaran Guardian Hall, map is not updated.
        end
        UpdateQuestsDistance()
    end
end)

local timer = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    timer = timer + elapsed
    if timer > 0.5 then
        timer = 0
        UpdateQuestsDistance()
    end
end)

--[[------------------------------------------------------------
If player manually click track button, hold for some time.
see QuestPOI_Initialize(self.BlocksFrame, function(self) end );
---------------------------------------------------------------]]
hooksecurefunc(ObjectiveTrackerFrame.BlocksFrame, "poiOnCreateFunc", function(button)
    if not button._hooked then
        button._hooked = 1
        button:HookScript("OnClick", function(self)
            local questID = self.questID;
            local questLogIndex = GetQuestLogIndexByID(questID);
            if ( not IsShiftKeyDown() ) then
                protectionTime = GetTime() + 5
            end
        end)
    end
end)
--[[------------------------------------------------------------
UI
---------------------------------------------------------------]]
local checkbox = CreateFrame("CheckButton", "QuestWatchSortCheckButton", ObjectiveTrackerFrame, "UICheckButtonTemplate");
checkbox:SetParent(ObjectiveTrackerBlocksFrame.QuestHeader)
checkbox:RegisterForClicks("AnyUp")
checkbox:SetWidth(22);
checkbox:SetHeight(22);
checkbox.text:SetText("")
checkbox:SetPoint("BOTTOMRIGHT", ObjectiveTrackerBlocksFrame.QuestHeader, "BOTTOMLEFT", 5, 2);
checkbox:SetScript("OnClick", function(self, button)
    U1DB.configs[CONFIG] = self:GetChecked()
    EnableOrDisable()
end)
CoreUIEnableTooltip(checkbox, "任务排序", "按任务远近进行排序\n\n暴雪的任务排序功能失效很久了,爱不易为您临时提供解决方案")


--[[------------------------------------------------------------
prevent blocking message
---------------------------------------------------------------]]
if WorldMapFrame.UIElementsFrame and WorldMapFrame.UIElementsFrame.ActionButton then
    -- WorldMapActionButtonMixin:Clear()
    local isEventRegistered
    hooksecurefunc(WorldMapFrame.UIElementsFrame.ActionButton, "RegisterUnitEvent", function(self, event)
        if (event == "UNIT_SPELLCAST_SUCCEEDED" and InCombatLockdown()) then
            local eventFrame = BaudErrorFrame or UIParent
            isEventRegistered = eventFrame:IsEventRegistered("ADDON_ACTION_BLOCKED")
            if isEventRegistered then eventFrame:UnregisterEvent("ADDON_ACTION_BLOCKED") end
        end
    end)

    hooksecurefunc(WorldMapFrame.UIElementsFrame.ActionButton, "UpdateCooldown", function(self)
        if isEventRegistered then
            isEventRegistered = nil
            local eventFrame = BaudErrorFrame or UIParent
            eventFrame:RegisterEvent("ADDON_ACTION_BLOCKED")
        end
    end)
end

if true then return end
--[[------------------------------------------------------------
接近任务目标时仍显示任务
---------------------------------------------------------------]]
local HDPins = LibStub("HereBeDragons-Pins-1.0")
local HD = LibStub("HereBeDragons-1.0")
CoreDependCall("Blizzard_ObjectiveTracker", function()

    local ref = CreateFrame("Frame")
    QuestPOI_Initialize(ref, nil)

    local hook_QuestObjectiveTracker_UpdatePOIs = function()
        if not checkbox:GetChecked() then return end
        HDPins:RemoveAllMinimapIcons(ref)
        local playerMoney = GetMoney();
        local numPOINumeric = 0;
        for i = 1, GetNumQuestWatches() do
            local questID, title, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isBounty, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i);
            if (questID) then
                -- see if we already have a block for this quest
                local block = QUEST_TRACKER_MODULE:GetExistingBlock(questID);
                if (block) then
                    if (isComplete and isComplete < 0) then
                        isComplete = false;
                    elseif (numObjectives == 0 and playerMoney >= requiredMoney and not startEvent) then
                        isComplete = true;
                    end
                    local poiButton;
                    local _, POIx, POIy = QuestPOIGetIconInfo(questID)
                    --print(questID, title, POIx, POIy)
                    if (hasLocalPOI and POIx) then
                        if (isComplete) then
                            --poiButton = QuestPOI_GetButton(ref, questID, "normal", nil, isStory);
                        else
                            numPOINumeric = numPOINumeric + 1;
                            poiButton = QuestPOI_GetButton(ref, questID, "numeric", numPOINumeric, isStory);
                        end
                    elseif (isComplete) then
                        --poiButton = QuestPOI_GetButton(ObjectiveTrackerFrame.BlocksFrame, questID, "remote", nil, isStory);
                    end
                    if (poiButton) then
                        local mapId, level, file, microDungeon = HD:GetPlayerZone()
                        poiButton.NormalTexture:SetSize(16, 16)
                        poiButton:SetAlpha(0.7)
                        poiButton:EnableMouse(false)
                        HDPins:AddMinimapIconMF(ref, poiButton, mapId, level, POIx, POIy, true)
                        if questID == GetSuperTrackedQuestID() then
                            QuestPOI_SelectButton(poiButton)
                        end
                        poiButton.Glow:Hide()
                    end
                end
            end
        end
        --QuestPOI_SelectButtonByQuestID(ObjectiveTrackerFrame.BlocksFrame, GetSuperTrackedQuestID());
        QuestPOI_HideUnusedButtons(ref);
    end

    hooksecurefunc("QuestObjectiveTracker_UpdatePOIs", hook_QuestObjectiveTracker_UpdatePOIs)

    checkbox:HookScript("OnClick", function(self)
        if not self:GetChecked() then
            QuestPOI_HideAllButtons(ref)
            HDPins:RemoveAllMinimapIcons(ref)
        else
            hook_QuestObjectiveTracker_UpdatePOIs()
        end
    end)
end)