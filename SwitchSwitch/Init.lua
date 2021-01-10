--############################################
-- Namespace
--############################################
local addonName, addon = ...

addon.LastInstanceID = -1

--##########################################################################################################################
--                                  Default configurations
--##########################################################################################################################
local function GetDefaultConfig()
    return {
        ["Version"] = addon.version,
        ["debug"] = false,
        ["autoUseItems"] = true,
        ["SelectedTalentsProfile"] = "",
        ["SuggestionFramePoint"] =
        {
            ["point"] = "CENTER",
            ["relativePoint"] = "CENTER",
            ["frameX"] = 0,
            ["frameY"] = 0
        },
        ["maxTimeSuggestionFrame"] = 15,
        ["autoSuggest"] = 
        {
            ["pvp"] = "",
            ["arena"] = "",
            ["raid"] = "",
            ["party"] = 
            {
                ["HM"] = "",
                ["MM"] = ""                
            }
        }
    }
end

--##########################################################################################################################
--                                  Event handling
--##########################################################################################################################
function addon:eventHandler(event, arg1)
    if (event == "ADDON_LOADED") then
        if(arg1 ~= addonName) then
            --Check if talents have been loaded to create our frame in top of it.
            if(arg1 == "Blizzard_TalentUI") then
                addon.TalentUIFrame:CreateTalentFrameUI()
            end
            return 
        end

        --Talents table
        if(SwitchSwitchTalents == nil) then
            --Default talents table
            SwitchSwitchTalents =
            {
                ["Version"] = addon.version,
            }
        end

        -- Global talents progile table
        if(SwitchSwitchProfiles == nil) then
            SwitchSwitchProfiles =
            {
                ["Version"] = addon.version,
                ["Profiles"] = {}
            }
        end

        if(SwitchSwitchConfig == nil) then
            --Default config
            SwitchSwitchConfig = GetDefaultConfig()
        end

        --Add the global variables to the addon global
        addon.sv = {}
        addon.sv.Talents = SwitchSwitchProfiles
        addon.sv.config = SwitchSwitchConfig
    elseif(event == "PLAYER_LOGIN") then
        --Update the tables in case they are not updated
        addon:Update();
        
        --Load Commands
        addon.Commands:Init()
        --Load global frame
        addon.GlobalFrames:Init()

        --Load the UI if not currently loaded
        if(not IsAddOnLoaded("Blizzard_TalentUI")) then
            LoadAddOn("Blizzard_TalentUI")
        end

        --Unregister current event
        self:UnregisterEvent(event)
        self:RegisterEvent("AZERITE_ESSENCE_UPDATE")
        self:RegisterEvent("PLAYER_TALENT_UPDATE")
    elseif(event == "PLAYER_TALENT_UPDATE" or event == "AZERITE_ESSENCE_UPDATE") then
        do --修改方案前必然修改天赋,记录下此时的方案即可
            local last = addon.sv.config.SelectedTalentsProfile
            if last and last ~= addon.CustomProfileName and last ~= "custom" then
                addon.lastSelectedProfile = last
            end
        end
        addon.sv.config.SelectedTalentsProfile = addon:GetCurrentProfileFromSaved()
    elseif(event == "PLAYER_ENTERING_WORLD") then
        --Check if we actually switched map from last time
        local instanceID = select(8,GetInstanceInfo())
        --Debuging
        addon:Debug("Entering instance:" .. string.join(" - ", tostringall(GetInstanceInfo())))
        if(addon.LastInstanceID == instanceID) then
            return
        end
        addon.LastInstanceID = instanceID
        --Check if we are in an instance
        local inInstance, instanceType = IsInInstance()
        if(inInstance) then
            local profileNameToUse = addon.sv.config.autoSuggest[instanceType]

            addon:Debug("Instance type: " .. instanceType)

            --Party is a table so we need to ge the profile out via dificullty
            if(instanceType == "party") then
                local difficulty = GetDungeonDifficultyID()
                local difficultyByID = 
                {
                    [1] = "HM", -- Normal mode but we truncate it up to hc profile mode
                    [2] = "HM",
                    [23] = "MM"
                }
                profileNameToUse = addon.sv.config.autoSuggest[instanceType][difficultyByID[difficulty]]
            end
            --Check if we are already in the current profile
            if(profileNameToUse ~= nil and profileNameToUse ~= "") then
                if(not addon:IsCurrentTalentProfile(profileNameToUse)) then 
                    addon:Debug("Atuo suggest changing to profile: " .. profileNameToUse)
                    addon.GlobalFrames:ToggleSuggestionFrame(profileNameToUse)
                else
                    addon:Debug("Profile " .. profileNameToUse .. " is already in use.")
                end
            else
                addon:Debug("No profile set for this type of instance.")
            end
        end
    end
end

function addon:Update()
    --Get the old version
    local oldConfigVersion = addon.version
    if(addon.sv.config ~= nil and type(addon.sv.config.Version) == "string") then
        oldConfigVersion = addon.sv.config.Version
    end

    local oldTalentsVersion = addon.version
    if(addon.sv.Talents ~= nil and type(addon.sv.Talents.Version) == "string") then
        oldConfigVersion = addon.sv.config.Version
    end

    --Check special format
    if(addon:Repeats(oldConfigVersion, "%.") == 2) then
        local index = addon:findLastInString(oldConfigVersion, "%.")
        oldConfigVersion = string.sub( oldConfigVersion, 1, index-1) .. string.sub( oldConfigVersion, index+1)
    end

    if(addon:Repeats(oldTalentsVersion, "%.") == 2) then
        local index = addon:findLastInString(oldTalentsVersion, "%.")
        oldTalentsVersion = string.sub( oldTalentsVersion, 1, index-1) .. string.sub( oldTalentsVersion, index+1)
    end

    --Convert the string to numbers
    oldConfigVersion = tonumber(oldConfigVersion)
    oldTalentsVersion = tonumber(oldTalentsVersion)
    --Get current version in number
    local currentVersion = tonumber(addon.version)

    --Update talents table
    if(oldTalentsVersion ~= currentVersion) then
    end

    --Update config
    if(oldConfigVersion ~= currentVersion) then
        --Current selected talents are not in normal config saved now
        if(oldConfigVersion < 1.6) then
            addon.sv.config.SelectedTalentsProfile = ""
            addon.sv.config.autoSuggest = 
            {
                ["pvp"] = "",
                ["arena"] = "",
                ["raid"] = "",
                ["party"] = 
                {
                    ["HM"] = "",
                    ["MM"] = ""                
                }
            }
        end
    end

    addon.sv.Talents.Version = addon.version
    addon.sv.config.Version = addon.version
end

-- Event handling frame
addon.event_frame = CreateFrame("Frame")
-- Set Scripts
addon.event_frame:SetScript("OnEvent", addon.eventHandler)
-- Register events
addon.event_frame:RegisterEvent("ADDON_LOADED")
addon.event_frame:RegisterEvent("PLAYER_LOGIN")
addon.event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
