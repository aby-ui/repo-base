local questsDis = {}
_G["abyuiKTQuestDis"] = questsDis

local function UpdateQuestsDistance()

    if (QuestMapFrame and QuestMapFrame:IsVisible())
            or C_QuestLog.GetNumQuestWatches() < 1 then
        return
    end

    wipe(questsDis)

    --see Blizzard's QuestSuperTracking_ChooseClosestQuest
    for i = 1, C_QuestLog.GetNumQuestWatches() do
        local questID = C_QuestLog.GetQuestIDForQuestWatchIndex(i);
        if ( questID and QuestHasPOIInfo(questID) ) then
            local distSqr, onContinent = C_QuestLog.GetDistanceSqToQuest(questID);
            if ( onContinent ) then
                questsDis[questID] = distSqr
            else
                questsDis[questID] = i - 1000
            end
        end
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

frame:SetScript("OnEvent", function(self, event)
    CoreScheduleBucket("KTUpdateDistance", 0.2, UpdateQuestsDistance)
end)

local timer = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    timer = timer + elapsed
    if timer > 0.5 then
        timer = 0
        UpdateQuestsDistance()
    end
end)