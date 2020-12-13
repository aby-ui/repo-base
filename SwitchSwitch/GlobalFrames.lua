--############################################
-- Namespace
--############################################
local _, addon = ...

--Set up frame helper gobal tables
addon.GlobalFrames = {}
local GlobalFrames = addon.GlobalFrames


--##########################################################################################################################
--                                  Frames Init
--##########################################################################################################################
function GlobalFrames:Init()
    GlobalFrames.SavePVPTalents = CreateFrame("CheckButton", "SS_CheckboxSavePVPTalents", UIParent, "UICheckButtonTemplate")
    GlobalFrames.SavePVPTalents.text:SetText(addon.L["Save pvp talents?"])
    GlobalFrames.SavePVPTalents:SetChecked(true)
    GlobalFrames.SavePVPTalents:Hide()

    --Popup to notify the user if they want the addon to automaticly use a tome
    StaticPopupDialogs["SwitchSwitch_ConfirmTomeUsage"] =
    {
        text = addon.L["Do you want to use a tome to change talents?"],
        button1 = addon.L["Yes"],
        button2 = addon.L["No"],
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
        exclusive = true,
        enterClicksFirstButton = true,
        OnShow = function(self, data) 
            --Wellll as there is no build-in way to have secure button as part of a static popuop we need to replace the buttons shig
            -- so we do
            if(self.sbutton == nil) then
                self.sbutton = CreateFrame("Button", "SS_ButtonUseTomePopup", self, "UIPanelButtonTemplate, SecureActionButtonTemplate");
                self.sbutton:SetAttribute("type", "item");
                self.sbutton:SetAttribute("item", data)
                self.sbutton:SetParent(self)
                self.sbutton:ClearAllPoints()
                self.sbutton:SetPoint(self.button1:GetPoint())
                self.sbutton:SetWidth(self.button1:GetWidth())
                self.sbutton:SetHeight(self.button1:GetHeight())
                self.sbutton:SetText(self.button1:GetText())
                self.sbutton:SetScript("PostClick", function() self.button1:Click() end)
            end
            self.sbutton:Show()
            self.button1:Hide()
         end,
         OnAccept = function(self, data, data2)
            --Execute it after a timer so that the the call is not executed when we still dont have the buff as it takes time to activate
            addon:Debug("Changing talents after 1 seconds to " .. data2)
            C_Timer.After(1, function() addon:ActivateTalentProfile(data2) end)
            self.sbutton:Hide()
        end,
    }
end

local function CreateSuggestionFrame()
    --Frame for auto profile sugestor in instance
    local frame = CreateFrame("FRAME", "SS_SuggestionFrame", UIParent, "InsetFrameTemplate3")
    frame:SetPoint(addon.sv.config.SuggestionFramePoint.point, UIParent, addon.sv.config.SuggestionFramePoint.relativePoint, addon.sv.config.SuggestionFramePoint.frameX, addon.sv.config.SuggestionFramePoint.frameY)
    frame:SetSize(300, 100)
    --Add the first text tp notify the user what talent we ar about to change
    frame.InfoText = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite") 
    frame.InfoText:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
    frame.InfoText:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
    frame.InfoText:SetText("PLACEHOLDER")
    --Add the text to let the user know how long until auto closo of the frame
    frame.RemainingText = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.RemainingText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
    frame.RemainingText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
    frame.RemainingText:SetText("PLACEHOLDER")
    --Add Buttons for the frame
    --Change button
    frame.ChangeProfileButton = CreateFrame("BUTTON", "SS_SuggestionFrameChangeButton", frame, "UIPanelButtonTemplate")
    frame.ChangeProfileButton:SetPoint("LEFT", frame, "LEFT", 10, -5)
    frame.ChangeProfileButton:SetSize(125, 40)
    frame.ChangeProfileButton:SetText(addon.L["Change!"])
    --Cancel button to close the frame up
    frame.CancelButton = CreateFrame("BUTTON", "SS_SuggestionCancelButton", frame, "UIPanelButtonTemplate")
    frame.CancelButton:SetPoint("RIGHT", frame, "RIGHT", -10, -5)
    frame.CancelButton:SetSize(125, 40)
    frame.CancelButton:SetText(addon.L["Cancel"])

    --Set the buttons functions
    --Cancel button
    frame.CancelButton:SetScript("OnClick", function(self)  self:GetParent():Hide() end)
    --Change button
    frame.ChangeProfileButton:SetScript("OnClick", function(self)
        addon:Debug("Clicked change talents to recomended: " .. self.Profile)
        addon:ActivateTalentProfile(self.Profile)
        self:GetParent():Hide()
    end)

    --Make the frame moveable
    frame:SetMovable(true);
    frame:EnableMouse(true);
    frame:RegisterForDrag("LeftButton");
    frame:SetScript("OnDragStart", frame.StartMoving);
    frame:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing();
            point1, _, relativePoint1, xOfs, yOfs = self:GetPoint(1);
            addon.sv.config.SuggestionFramePoint.point = point1;
            addon.sv.config.SuggestionFramePoint.relativePoint = relativePoint1;
            addon.sv.config.SuggestionFramePoint.frameX = xOfs;
            addon.sv.config.SuggestionFramePoint.frameY = yOfs;
    end);

    -- Add update to the frame so it can dissaper after a certain time
    frame:SetScript("OnShow", function(self)
        self.ElapsedTime = 0
        self.InfoText:SetText(addon.L["Would you like to change you talents to %s?"]:format(self.ChangeProfileButton.Profile))
        --If no time is given then hide the text
        if(addon.sv.config.maxTimeSuggestionFrame == 0) then
            self.RemainingText:Hide()
        else 
            self.RemainingText:Show()
        end
    end)
    frame:SetScript("OnUpdate", function(self, elapsed)
        --If the max time is 0 then not update anything
        if(addon.sv.config.maxTimeSuggestionFrame == 0) then
            return
        end
        --Update elapsed time and string
        self.ElapsedTime = self.ElapsedTime + elapsed
        self.RemainingText:SetText(addon.L["Frame will close after %s seconds..."]:format(string.format("%.0f",addon.sv.config.maxTimeSuggestionFrame - self.ElapsedTime)))
        --If the time given passed hide
        if(self.ElapsedTime >= addon.sv.config.maxTimeSuggestionFrame) then
            self:Hide()
        end
    end)
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:SetScript("OnEvent", function(self, event, ...)
        if event =="PLAYER_REGEN_DISABLED" then
            self:Hide()
        end
        self:UnregisterEvent(event)
    end)

    --Debuging text
    addon:Debug("Created Suggestion frame!")

    --Hide the frame by default
    frame:Hide()

    return frame
end


function GlobalFrames:ToggleSuggestionFrame(profileToActivate)
    --First check if the profile is valid and exists
    if(not profileToActivate or profileToActivate == "" or not addon:DoesTalentProfileExist(profileToActivate)) then
        addon:Debug("Could not open 'Sugestion frame' as either the profile is null or does not exist")
        return
    end
    addon:Debug("Showing Toggle suggestion frame with profile: " .. profileToActivate)
    --Set the frame or create it, set data and show the frame.
    GlobalFrames.ProfileSuggestion = GlobalFrames.ProfileSuggestion or CreateSuggestionFrame()
    GlobalFrames.ProfileSuggestion.ChangeProfileButton.Profile = profileToActivate
    GlobalFrames.ProfileSuggestion:Show()
end
