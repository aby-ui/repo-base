--## Version: 0.1.1
--## Notes: Adds saved instances info to EncounterJournal
--## Author: PeckZeg

--[[------------------------------------------------------------
main.lua
---------------------------------------------------------------]]
local function GetSavedInstances()
    local db = {
        ["dungeons"] = {},
        ["raids"] = {},
    };

    for i = 1, GetNumSavedInstances() do
        local name, id, _, difficulty, locked, extended, _, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i);
        if name == "围攻伯拉勒斯" then numEncounters = 4 end
        local instances = isRaid and db.raids or db.dungeons;

        if instances[name] == nil then
            instances[name] = {};
        end

        if locked or extended then
            table.insert(instances[name], {
                ["index"] = i,
                ["name"] = name,
                ["difficulty"] = difficulty,
                ["locked"] = locked,
                ["extended"] = extended,
                ["isRaid"] = isRaid,
                ["maxPlayers"] = maxPlayers,
                ["difficultyName"] = difficultyName,
                ["numEncounters"] = numEncounters,
                ["encounterProgress"] = encounterProgress,
            });

            table.sort(instances[name], function(a, b)
                return a.difficulty < b.difficulty;
            end);
        end
    end

    return db;
end

local function GetEncounterJournalInstanceTabs()
    if EncounterJournal ~= nil then
        return EncounterJournal.dungeonsTab, EncounterJournal.raidsTab;
    end

    return nil, nil;
end

local function HandleEncounterJournalScrollInstances(func)
    if EncounterJournal then
        table.foreach(EncounterJournal.instanceSelect.ScrollBox.view.frames, function(index, instanceButton)
            if type(instanceButton) == "table" and instanceButton.instanceID then
                func(instanceButton);
            end
        end);
    end
end

local function ResetEncounterJournalScrollInstancesInfo()
    HandleEncounterJournalScrollInstances(function(instanceButton)
        if instanceButton.instanceInfoDifficulty == nil then
            instanceButton.instanceInfoDifficulty = instanceButton:CreateFontString(
                nil,
                "OVERLAY",
                "QuestTitleFontBlackShadow"
            );
        end

        if instanceButton.instanceInfoEncounterProgress == nil then
            instanceButton.instanceInfoEncounterProgress = instanceButton:CreateFontString(
                nil,
                "OVERLAY",
                "QuestTitleFontBlackShadow"
            );
        end

        local difficultyText = instanceButton.instanceInfoDifficulty;
        local encounterProgressText = instanceButton.instanceInfoEncounterProgress;
        local font = difficultyText:GetFont();

        difficultyText:SetPoint("BOTTOMLEFT", 9, 7);
        difficultyText:SetJustifyH("LEFT");
        difficultyText:SetFont(font, 12);
        difficultyText:SetText("")
        difficultyText:Hide();

        encounterProgressText:SetPoint("BOTTOMRIGHT", -7, 7);
        encounterProgressText:SetJustifyH("RIGHT");
        encounterProgressText:SetFont(font, 12);
        encounterProgressText:Hide();
        encounterProgressText:SetText("")
    end);
end

local function RenderInstanceInfo(instanceButton, savedInstance)
    local difficultyButton = instanceButton.instanceInfoDifficulty;
    local encounterProgressButton = instanceButton.instanceInfoEncounterProgress;
    local difficulty = "";
    local encounterProgress = "";

    table.foreach(savedInstance, function(index, instance)
        difficulty = difficulty .. "\n" .. instance.difficultyName;
        encounterProgress = encounterProgress .. "\n" .. string.format("%s/%s", instance.encounterProgress, instance.numEncounters);
    end);

    if difficultyButton then
        difficultyButton:SetText(difficulty);
        difficultyButton:SetWidth(difficultyButton:GetStringWidth() * 1.25);
        difficultyButton:Show();
    end

    if encounterProgressButton then
        encounterProgressButton:SetText(encounterProgress);
        encounterProgressButton:SetWidth(encounterProgressButton:GetStringWidth() * 1.25);
        encounterProgressButton:Show();
    end
end

local function RenderEncounterJournalInstances()
    local savedDB = GetSavedInstances();
    local dungeonsTab, raidsTab = GetEncounterJournalInstanceTabs();
    if EncounterJournal and EncounterJournal.selectedTab == 5 then return end
    local savedInstances = savedDB[(raidsTab ~= nil and not raidsTab:IsEnabled()) and "raids" or "dungeons"];

    --RenderSavedInstancesOverview(savedDB);

    HandleEncounterJournalScrollInstances(function(instanceButton)
        local instanceName = EJ_GetInstanceInfo(instanceButton.instanceID);
        local savedInstance = savedInstances[instanceName];

        if savedInstance ~= nil then
            RenderInstanceInfo(instanceButton, savedInstance);
        end
    end);
end

local function EncounterJournalInstanceTab_OnClick()
    for _, tab in ipairs({ "dungeonsTab", "raidsTab" }) do
        EncounterJournal[tab]:HookScript("OnClick", function(self, button, down)
            ResetEncounterJournalScrollInstancesInfo();
            RequestRaidInfo();
        end);
    end
end

function EncounterJournalPlus_InstanceInfo_OnLoad(self)
    self:RegisterEvent("ADDON_LOADED");
    self:RegisterEvent("UPDATE_INSTANCE_INFO");
end

function EncounterJournalPlus_InstanceInfo_OnEvent(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Blizzard_EncounterJournal" then
        hooksecurefunc("EJ_ContentTab_Select", function(id)
            if id ~= 1 and id ~= 3 then
                ResetEncounterJournalScrollInstancesInfo();
                RequestRaidInfo();
            end
        end)
        hooksecurefunc("EJ_SelectTier", function()
            ResetEncounterJournalScrollInstancesInfo();
            RequestRaidInfo();
        end);
        EncounterJournalInstanceTab_OnClick();
    elseif event == "UPDATE_INSTANCE_INFO" then
        RenderEncounterJournalInstances();
    end
end

local frame = CreateFrame("Frame")
EncounterJournalPlus_InstanceInfo_OnLoad(frame)
frame:SetScript("OnEvent", EncounterJournalPlus_InstanceInfo_OnEvent)