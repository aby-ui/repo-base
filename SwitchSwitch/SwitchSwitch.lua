--############################################
-- Namespace
--############################################
local _, addon = ...

addon.G = {}
addon.G.SwitchingTalents = false
addon.version = "1.66"
addon.CustomProfileName = "custom"

--##########################################################################################################################
--                                  Helper Functions
--##########################################################################################################################
-- Function to print a debug message
function addon:Debug(...)
    if(addon.sv.config.debug) then
        addon:Print(string.join(" ", "|cFFFF0000(DEBUG)|r", tostringall(... or "nil")));
    end
end

-- Function to print a message to the chat.
function addon:Print(...)
    local msg = string.join(" ","|cFF029CFC[SwitchSwitch]|r", tostringall(... or "nil"));
    DEFAULT_CHAT_FRAME:AddMessage(msg);
end

--Print a table, if the value of a key is a talbe recursivly call the function again
function addon:PrintTable(tbl, indent)
    if not indent then indent = 0 end
    if type(tbl) == 'table' then
        for k, v in pairs(tbl) do
            formatting = string.rep("  ", indent) .. k .. ": "
            if type(v) == "table" then
              addon:Print(formatting)
              addon:PrintTable(v, indent+1)
            else
                addon:Print(formatting .. tostring(v))
            end
        end
    end
end

function addon:HasHeartOfAzerothEquipped()
    return GetInventoryItemID("player", INVSLOT_NECK) == 158075
end

-- String helpers
function addon:findLastInString(str, value)
    local i=str:match(".*"..value.."()")
    if i==nil then return nil else return i-1 end
end

function addon:Repeats(s,c)
    local _,n = s:gsub(c,"")
    return n
end
-------------------------------------------------------------------- Talent table edition

-- Functionts to ensure tables exits, call before checking anything on the tables
function addon:EnsureTalentClassTableExits()
    local playerClass = select(3, UnitClass("player"))

    if(addon.sv.Talents.Profiles == nil) then
        addon.sv.Talents.Profiles = {}
    end
    
    if(playerClass) then
        if(addon.sv.Talents.Profiles[playerClass] == nil) then
            addon.sv.Talents.Profiles[playerClass] = {}
        end
    end
end

function addon:EnsureTablentSpecTableExits()
    addon:EnsureTalentClassTableExits()

	local playerClass = select(3, UnitClass("player"))
    local playerSpec = select(1, GetSpecializationInfo(GetSpecialization()))
    if (playerClass and playerSpec) then
		if(addon.sv.Talents.Profiles[playerClass][playerSpec] == nil) then
			addon.sv.Talents.Profiles[playerClass][playerSpec] = {}
		end
	end
end

--Checks if the talents Profile database contains the given Profile
function addon:DoesTalentProfileExist(Profile)
    --Iterate to find the profile (could use quick [profile] to see if it exits, but we want to compare allin lower (names are not case sentivies))
    for k,v in pairs(addon:GetCurrentProfilesTable()) do
        if(k:lower() == Profile:lower()) then
            --Profile exists
            return true
        end
    end
    --Profile does not exist
    return false
end

--Gets the table of a specific profile
function addon:GetTalentTable(Profile)
    if(addon:DoesTalentProfileExist(Profile)) then
        return addon.GetCurrentProfilesTable()[Profile:lower()]
    end
    return nil;
end

--Sets or creates a new table with the given table
function addon:SetTalentTable(Profile, tableToSet)
    addon:EnsureTablentSpecTableExits()
    
    local playerClass = select(3, UnitClass("player"))
    local playerSpec = select(1,GetSpecializationInfo(GetSpecialization()))
    
    if(playerClass and playerSpec) then
        addon.sv.Talents.Profiles[playerClass][playerSpec][Profile:lower()] = tableToSet
    end
end

--Deletes a profile table
function addon:DeleteTalentTable(Profile)
    if(addon:DoesTalentProfileExist(Profile)) then
        addon.sv.Talents.Profiles[select(3, UnitClass("player"))][select(1,GetSpecializationInfo(GetSpecialization()))][Profile:lower()] = nil
        addon:Debug("Deleted")
    end
end

--Gets the current global 
function addon:GetCurrentProfilesTable()
    addon:EnsureTablentSpecTableExits()

    local playerClass = select(3, UnitClass("player"))
	local playerSpec = select(1,GetSpecializationInfo(GetSpecialization()))
    local playerTable = {}
    if(playerClass and playerSpec) then
        playerTable = addon.sv.Talents.Profiles[playerClass][playerSpec]
    end
    return playerTable
end

function addon:CountCurrentTalentsProfile()
    local tbl = addon:GetCurrentProfilesTable()
    local count = 0
    
    for _ in pairs(tbl) do
        count = count + 1
    end
    
    return count
end

-----------------------------------------------------------------------------------------------------------------------------------------

--Get the talent from the current active spec
function addon:GetCurrentTalents(saveTalentsPVP)
    --If not provided save talents will be true
    if(saveTalentsPVP == nil) then
        saveTalentsPVP = true;
    end

    local talentSet =
    {
        ["pva"] = {},
        ["pvp"] = {},
        ["heart_of_azeroth_essences"] = {}
    }
    --Iterate over all tiers of talents normal
    for Tier = 1, GetMaxTalentTier() do
        --Create default table
        talentSet["pva"][Tier] =
        {
            ["id"] = nil,
            ["tier"] = nil,
            ["column"] = nil
        }
        --Iterate trought the 2 columnds
        for Column = 1, 3 do
            --Get talent info
            talentID, name, texture, selected, available, _, _, _, _, _, _ = GetTalentInfo(Tier, Column, GetActiveSpecGroup())
            --If the talent is selected store the nececary information
            if(selected) then
                talentSet["pva"][Tier]["id"] = talentID
                talentSet["pva"][Tier]["tier"] = Tier
                talentSet["pva"][Tier]["column"] = Column
                break
            end
        end
    end

    --Only save talents if requested
    if(saveTalentsPVP) then
        --Iterate over pvp talents
        for Tier = 1, 3 do
            pvpTalentInfo = C_SpecializationInfo.GetPvpTalentSlotInfo(Tier)
            talentSet["pvp"][Tier] =
            {
                ["unlocked"] = pvpTalentInfo.enabled,
                ["id"] = pvpTalentInfo.selectedTalentID,
                ["tier"] = Tier
            }
        end
    end

    --Get Essence information
    if(addon:HasHeartOfAzerothEquipped()) then
        local MilestoneIDs = {115,116,117,119}
        for index, id in ipairs(MilestoneIDs) do
            local milestonesInfo = C_AzeriteEssence.GetMilestoneInfo(id)
            if(milestonesInfo.unlocked) then
                talentSet["heart_of_azeroth_essences"][milestonesInfo.ID] = C_AzeriteEssence.GetMilestoneEssence(id)
            end
        end
    end

    --Return talents
    return talentSet;
end

--Check if we can switch talents
function addon:CanChangeTalents()
    --Quick return if resting for better performance
    if(IsResting()) then
        return true
    end
    -- If in combat we cannot change so lets exit early
   if(InCombatLockdown()) then
        return false		
   end
	
    --All buffs ids for the tomes
    local buffLookingFor = 
    {
        226234,
        227041,
        227563,
        227565,
        227569,
        256231,
        256229,
        --Arena preparation wow
        32727,
        32728,
        -- Dungeon preparation
        228128,
        -- Battleground Insight
        248473,
        44521,
        -- SL LVL 60
        -- Refuge of the dammed
        338907,
        -- Still mind tomes
        324029,
        324028,
        321923,		
        325012, --格里恩随从
    }
    local debuffsLookingFor =
    {
        --PRepare for battle
        290165,
        279737
    };
    --There is no quick way to get if a player has a specific buff so we need to go tought all players buff and check if its one of the one we need
    for i = 1, 40 do
        local spellID = select(10, UnitBuff("player", i))
        for index, id in ipairs(buffLookingFor) do
            if(spellID == id) then
                return true
            end
        end
    end
    --Check debufs aswell
    for i = 1, 40 do
        local spellID = select(10, UnitDebuff("player", i))
        for index, id in ipairs(debuffsLookingFor) do
            if(spellID == id) then
                return true
            end
        end
    end
    --Buff not found
    return false
end

function addon:ActivateTalentProfile(profileName)

    if(UnitAffectingCombat("Player")) then
        addon:Debug("Player is in combat.")
        return
    end

    --Check if profileName is not null
    if(not profileName or type(profileName) ~= "string") then
        addon:Debug("Given profile name is null")
        return
    end

    --Check  if table exits
    if(not addon:DoesTalentProfileExist(profileName)) then
        addon:Print(addon.L["Could not change talents to Profile '%s' as it does not exit"]:format(profileName))
        return
    end

    --If we cannot change talents why even try?
    if(not addon:CanChangeTalents()) then
        if(addon.sv.config.autoUseItems) then
            -- Now all tomes have level so lets add them based on character level
            local tomesID = {}
            --Check for level to add the Clear mind tome
            if (UnitLevel("player") <= 50) then
                table.insert(tomesID, 141640) -- Clear mind
                table.insert(tomesID, 141446) -- Tranquil mind crafted
                table.insert(tomesID, 143785) -- tranquil mind _ dalaran quest
                table.insert(tomesID, 143780)  -- tranquil mind _ random
            end

            if (UnitLevel("player") <= 59) then
                table.insert(tomesID, 153647) -- Quit mind
            end

            if (UnitLevel("player") <= 60) then
                table.insert(tomesID, 173049) -- Still mind
            end

            --Tomes that can be used
            local itemIDToUse = nil
            local bagID = 0
            local slot = 0
            --Find any tome usable in the bags
            for bag = 0, NUM_BAG_SLOTS + 1 do
                for bagSlot = 1, GetContainerNumSlots(bag) do
                    local currentItemInSlotID = GetContainerItemID(bag, bagSlot)
                    for index, id in ipairs(tomesID) do
                        if(id == currentItemInSlotID) then
                            itemIDToUse = currentItemInSlotID
                            bagID = bag
                            slot = bagSlot
                            break
                        end
                    end
                end
            end


            --Check if we found an item if not return false
            if(not itemIDToUse) then
                --No item found so return
                addon:Print(addon.L["Could not find a Tome to use and change talents"])
                return
            end

            -- Set the item attibute
            --Got an item so open the popup to ask to use it!
            local dialog = StaticPopup_Show("SwitchSwitch_ConfirmTomeUsage", nil, nil, bagID .. " " .. slot)
            if(dialog) then
                addon:Debug("Setting data to ask for tome usage to: " .. profileName)
                dialog.data2 = profileName
            end
        else
            --No check for usage so just return
            addon:Print(addon.L["Could not change talents as you are not in a rested area, or dont have the buff"])
        end
        return
    end

    --Function to set talents
    addon:SetTalents(profileName)
end
--Helper function to avoid needing to copy-caste every time...
function addon:SetTalents(profileName)
    --Make sure our event talent change does not detect this as custom switch
    addon.G.SwitchingTalents = true
    --addon:Print(addon.L["Changing talents"] .. ":" .. profileName)

    --Check if the talent addon is up
    if(not IsAddOnLoaded("Blizzard_TalentUI")) then
        LoadAddOn("Blizzard_TalentUI")
    end

    if(not addon:DoesTalentProfileExist(profileName)) then
        return;
    end

    local currentTalentPorfile = addon:GetTalentTable(profileName)

    --Learn talents normal talents
    if(currentTalentPorfile.pva ~= nil) then
        for i, talentTbl in ipairs(currentTalentPorfile.pva) do
            --Get the current talent info to see if the talent id changed
            local talent = GetTalentInfo(talentTbl.tier, talentTbl.column, 1)
            if talentTbl.tier > 0 and talentTbl.column > 0  then
                LearnTalents(talent)
                --If talent id changed let the user know that the talents might be wrong
                if(select(1, talent) ~= talentTbl.id) then
                    addon:Print(addon.L["It seems like the talent from tier: '%s' and column: '%s' have been moved or changed, check you talents!"]:format(tostring(talentTbl.tier), tostring(talentTbl.column)))
                end
            end
        end
    end

    if(currentTalentPorfile.pvp ~= nil) then
        --Leanr pvp talent
        for i, pvpTalentTabl in ipairs(currentTalentPorfile.pvp) do
            if(pvpTalentTabl.unlocked and pvpTalentTabl.id ~= nil) then
                --Make sure the talent is not used anywhere else, set to random if used in anothet tier
                for i2 = 0, 3 do
                    local pvpTalentInfo = C_SpecializationInfo.GetPvpTalentSlotInfo(i2)
                    if(pvpTalentInfo ~= nil and pvpTalentTabl.id == pvpTalentInfo.selectedTalentID and pvpTalentTabl.tier ~= i2) then
                        --Get random talent
                        LearnPvpTalent(pvpTalentInfo.availableTalentIDs[math.random(#pvpTalentInfo.availableTalentIDs)], i2)
                    end
                end
                --Lern the talent in the tier
                LearnPvpTalent(pvpTalentTabl.id, pvpTalentTabl.tier)
            end
        end 
    end


    if(currentTalentPorfile.heart_of_azeroth_essences ~= nil and addon:HasHeartOfAzerothEquipped()) then
        --Learn essences
        for milestoneID, essenceID in pairs(currentTalentPorfile.heart_of_azeroth_essences) do
            C_AzeriteEssence.ActivateEssence(essenceID, milestoneID)
        end
    end

    --Change gear set if available
    if(currentTalentPorfile.gearSet ~= nil) then
        addon:Debug("ID: ", currentTalentPorfile.gearSet)
        local name, iconFileID, setID, isEquipped, numItems, numEquipped, numInInventory, numLost, numIgnored = C_EquipmentSet.GetEquipmentSetInfo(currentTalentPorfile.gearSet)
        if(not isEquipped) then
            C_EquipmentSet.UseEquipmentSet(currentTalentPorfile.gearSet)
        end
    end


    --Print and return
    addon:Print(addon.L["Changed talents to '%s'"]:format(profileName))
    --Set the global switching variable to false so we detect custom talents switches (after a time as the evnt might fire late)
    C_Timer.After(1.0,function() addon.G.SwitchingTalents = false end)
    --Set the global value of the current Profile so we can remember it later
    addon.sv.config.SelectedTalentsProfile = profileName:lower()
end

--Check if a given profile is the current talents
function addon:IsCurrentTalentProfile(profileName)
    --Check if null or not existing
    if(not addon:DoesTalentProfileExist(profileName)) then
        addon:Debug(string.format("Profile name does not exist [%s]", profileName))
        return false
    end

    local currentActiveTalents = addon:GetCurrentTalents()
    local currentprofile = addon:GetTalentTable(profileName)

    if(currentprofile.heart_of_azeroth_essences ~= nil and addon:HasHeartOfAzerothEquipped()) then
        --Check essences
        for milestoneID, essenceID in pairs(currentActiveTalents.heart_of_azeroth_essences) do
            if(currentprofile.heart_of_azeroth_essences[milestoneID] == nil or essenceID ~= currentprofile.heart_of_azeroth_essences[milestoneID]) then
                addon:Debug("Essences do not match");
                return false   
            end
        end
    end

    --Check pvp talents
    local currentPVPTalentsTable = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
    if(currentprofile.pvp ~= nil) then
        for i, pvpTalentInfo in ipairs(currentprofile.pvp) do
            --Check if we got the talent
            local hasTalent = false
            for k, talentID in ipairs(currentPVPTalentsTable) do
                if(talentID == pvpTalentInfo.id) then
                    hasTalent = true;
                end
            end
            --We dont have the talent so just return false
            if(not hasTalent) then
                addon:Debug("PVP tlanets does not match");
                return false
            end
        end
    end

    if(currentprofile.pva ~= nil) then
        --Check normal talents
        for i, talentInfo in ipairs(currentprofile.pva) do
            talentID, name, _, selected, available, _, _, row, column, known, _ = GetTalentInfoByID(talentInfo.id, GetActiveSpecGroup())
            if(not known) then
                addon:Debug(string.format("Talent with the name %s is not leanred", name))
                return false
            end
        end
    end
    return true
end

--Gets the profile that is active from all the saved profiles
function addon:GetCurrentProfileFromSaved()
    --Iterate trough every talent profile
    for name, TalentArray in pairs(addon:GetCurrentProfilesTable()) do
        if(addon:IsCurrentTalentProfile(name)) then
            --Return the currentprofilename
            addon:Debug("Detected:" .. name)
            return name:lower()
        end
    end
    addon:Debug("No profiles match current talnets")
    --Return the custom profile name
    return addon.CustomProfileName
end
--Lua helper functions
--creates a deep copy of the table
function addon:deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[addon:deepcopy(orig_key)] = addon:deepcopy(orig_value)
        end
        setmetatable(copy, addon:deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function addon:tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end
