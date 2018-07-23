local ThisAddon, AddonDB = ...
local LocalDatabase, _, SavedVars = unpack(AddonDB)

--<<IMPORTANT STUFF>>-------------------------------------------------------------------------------<<>>

    local Dummy = CreateFrame("Frame")
    Dummy:RegisterEvent("ADDON_LOADED")

--<<REGISTER EVENTS>>-------------------------------------------------------------------------------<<>>

    Dummy:SetScript("OnEvent", function(self,_, Addon)
        if Addon == ThisAddon then
            if SavedVars.State == true then
                self:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
                self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
                self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
                self:RegisterEvent("PLAYER_ENTERING_WORLD")
                self:RegisterEvent("UNIT_THREAT_LIST_UPDATE")

                self:SetScript("OnEvent", function(self, event, ...) LocalDatabase[event](...) end)

                LocalDatabase.InitConfigElements()  
            end

            self:UnregisterEvent("ADDON_LOADED")
        end
    end)

----------------------------------------------------------------------------------------------------<<END>>