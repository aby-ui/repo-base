--############################################
-- Namespace
--############################################
local _, addon = ...

--Set up frame helper gobal tables
addon.TalentUIFrame = {}
local TalentUIFrame = addon.TalentUIFrame

--##########################################################################################################################
--                                  Init
--##########################################################################################################################
--Creates the edit frame
function TalentUIFrame:CreateEditUI()
    addon.TalentUIFrame.ProfileEditorFrame = CreateFrame("Frame", "SwitchSwitch_TalentFrameEditor", PlayerTalentFrame, "UIPanelDialogTemplate")
    local editorFrame =  addon.TalentUIFrame.ProfileEditorFrame
    
    --Editor frame config
    editorFrame:SetWidth(250)
    editorFrame:SetPoint("TOPLEFT", PlayerTalentFrame, "TOPRIGHT")
    editorFrame:SetPoint("BOTTOMLEFT", PlayerTalentFrame, "BOTTOMRIGHT")
    editorFrame.Title:SetText(addon.L["Talent Profile Editor"])
    editorFrame:HookScript("OnHide", function(self) 
        --Save all the data modified
        addon:Debug("Closed editor, saving data...")
        if(not self.GearSet:GetChecked() and addon:DoesTalentProfileExist(self.CurrentProfileEditing)) then
            local tbl = addon:GetTalentTable(self.CurrentProfileEditing) 
            tbl.gearSet = nil
            addon:SetTalentTable(self.CurrentProfileEditing, tbl)
        end
    end)
    editorFrame:Hide()
    editorFrame:HookScript("OnShow", function(self) 
        --Update the data
        addon:Debug("Updating Edit frame data...")
        self.InsideTitle:SetText(string.format(addon.L["Editing '%s'"], self.CurrentProfileEditing or "ERROR"))
        local tbl = addon:GetTalentTable(self.CurrentProfileEditing)
        if(addon:DoesTalentProfileExist(self.CurrentProfileEditing) and tbl.gearSet ~= nil) then
            self.GearSet:SetChecked(true)
            self.GearSet.SelectionFrame:Show()
            UIDropDownMenu_SetSelectedValue(self.GearSet.SelectionFrame.DropDown, tbl.gearSet)
            local name, iconFileID, setID, isEquipped, numItems, numEquipped, numInInventory, numLost, numIgnored = C_EquipmentSet.GetEquipmentSetInfo(tbl.gearSet)
            UIDropDownMenu_SetText(self.GearSet.SelectionFrame.DropDown, name)
        else 
            self.GearSet:SetChecked(false)
            self.GearSet.SelectionFrame:Hide()
            UIDropDownMenu_SetSelectedValue(self.GearSet.SelectionFrame.DropDown, "")
            UIDropDownMenu_SetText(self.GearSet.SelectionFrame.DropDown, NONE)
        end
    end)

    --Title
    editorFrame.InsideTitle = editorFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLargeLeft")
    editorFrame.InsideTitle:SetPoint("TOPLEFT", editorFrame, "TOPLEFT", 35, -35)

    --Selection of gear set
    editorFrame.GearSet = CreateFrame("CheckButton", nil, editorFrame, "UICheckButtonTemplate")
    editorFrame.GearSet:SetPoint("TOPLEFT", editorFrame.InsideTitle, "BOTTOMLEFT", -20, -10)
    editorFrame.GearSet.text:SetText(addon.L["Auto equip gear set with this talent profile?"])
    editorFrame.GearSet.text:SetFontObject("GameFontWhite")
    editorFrame.GearSet.text:SetWidth(190)
    editorFrame.GearSet:SetScript("OnClick", function(self)
        if(self:GetChecked()) then
           self.SelectionFrame:Show()
        else
            self.SelectionFrame:Hide()
        end
        end)

    --Frame for the gear selection
    editorFrame.GearSet.SelectionFrame = CreateFrame("Frame", nil, editorFrame.GearSet)
    editorFrame.GearSet.SelectionFrame:SetPoint("TOPLEFT", editorFrame.GearSet, "BOTTOMLEFT", 5, -5)
    editorFrame.GearSet.SelectionFrame:SetPoint("TOPRIGHT", editorFrame.GearSet, "BOTTOMRIGHT", 0, 0)
    editorFrame.GearSet.SelectionFrame:SetPoint("BOTTOMRIGHT", editorFrame.GearSet, "BOTTOMRIGHT", 0, -25)
    if(not editorFrame.GearSet:GetChecked()) then
        editorFrame.GearSet.SelectionFrame:Hide()
    end

    --Text information
    editorFrame.GearSet.SelectionFrame.Text = editorFrame.GearSet.SelectionFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    editorFrame.GearSet.SelectionFrame.Text:SetText(addon.L["Gear set to auto-equip:"])
    editorFrame.GearSet.SelectionFrame.Text:SetPoint("TOPLEFT", editorFrame.GearSet.SelectionFrame, "TOPLEFT")
    editorFrame.GearSet.SelectionFrame.Text:SetWidth(210)
    editorFrame.GearSet.SelectionFrame.Text:SetJustifyH("LEFT")

    --DropDown
    editorFrame.GearSet.SelectionFrame.DropDown = CreateFrame("FRAME", nil, editorFrame.GearSet.SelectionFrame, "UIDropDownMenuTemplate")
    editorFrame.GearSet.SelectionFrame.DropDown:SetPoint("TOPLEFT", editorFrame.GearSet.SelectionFrame.Text, "BOTTOMLEFT", -15, -5)
    editorFrame.GearSet.SelectionFrame.DropDown.funcName = "equipedGear"
    UIDropDownMenu_SetWidth(editorFrame.GearSet.SelectionFrame.DropDown, 190)
    UIDropDownMenu_Initialize(editorFrame.GearSet.SelectionFrame.DropDown, function(self)
        local info = UIDropDownMenu_CreateInfo()
        info.text = NONE
        info.value = ""
        info.index = 1
        info.arg1 = self
        info.func = TalentUIFrame.SetSelectedValueForDropDowns
        info.justifyH = "LEFT"
        UIDropDownMenu_AddButton(info, 1)

        for i, setID in ipairs(C_EquipmentSet.GetEquipmentSetIDs()) do
            local name, iconFileID, setID, isEquipped, numItems, numEquipped, numInInventory, numLost, numIgnored = C_EquipmentSet.GetEquipmentSetInfo(setID)
            info = UIDropDownMenu_CreateInfo()
            info.text = name
            info.value = setID
            info.index = i +1
            info.arg1 = self
            info.func = TalentUIFrame.SetSelectedValueForDropDowns
            info.justifyH = "LEFT"
            UIDropDownMenu_AddButton(info,1)
        end
    end)
    UIDropDownMenu_SetSelectedValue( editorFrame.GearSet.SelectionFrame.DropDown, "")

    --Delete button
    editorFrame.DeleteButton = TalentUIFrame:CreateButton("BOTTOMLEFT", editorFrame, editorFrame, "BOTTOMLEFT", addon.L["Delete"], 160, 25, 45, 20)
    editorFrame.DeleteButton:SetScript("OnClick", function()
        local dialog = StaticPopup_Show("SwitchSwitch_ConfirmDeleteprofile", addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing)
        if(dialog) then
            dialog.data = addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing
        end 
    end)

    --Rename button
    editorFrame.Rename = TalentUIFrame:CreateButton("BOTTOMLEFT", editorFrame, editorFrame, "BOTTOMLEFT", addon.L["Rename"], 160, 25, 45, 45)
    editorFrame.Rename:SetScript("OnClick", function()
        local dialog = StaticPopup_Show("SwitchSwitch_RenameProfile", addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing)
        if(dialog) then
            dialog.data = addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing
        end 
    end)


    --Popup generation
    StaticPopupDialogs["SwitchSwitch_RenameProfile"] =
    {
        text = addon.L["Rename profile"],
        button1 = addon.L["Ok"],
        button2 = addon.L["Cancel"],
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
        hasEditBox = true,
        exclusive = true,
        enterClicksFirstButton = true,
        OnAccept = function(self)
            TalentUIFrame:OnRenameAccepted(self)
        end,
        EditBoxOnEnterPressed = function(self)
            TalentUIFrame:OnRenameAccepted(self:GetParent())
            self:GetParent():Hide();
        end,
        EditBoxOnTextChanged = function (self)
            TalentUIFrame:OnRenameTextChanged(self)
        end,
        EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide();
        end,
    }

    
     --Create the confirim save popup
     StaticPopupDialogs["SwitchSwitch_ConfirmDeleteprofile"] =
     {
          text = addon.L["You want to delete the profile '%s'?"],
          button1 = addon.L["Delete"],
          button2 = addon.L["Cancel"],
          timeout = 0,
          whileDead = true,
          hideOnEscape = true,
          preferredIndex = 3,
          exclusive = true,
          enterClicksFirstButton = true,
          showAlert = true,
          OnAccept = function(self, data)
             TalentUIFrame:OnAcceptDeleteprofile(self, data)
          end,
     }
end 

function TalentUIFrame.SetSelectedValueForDropDowns(self, arg1, arg2, checked)
    if(not checked) then
        UIDropDownMenu_SetSelectedValue(arg1, self.value)
        if(arg1.funcName == "equipedGear") then
            local tbl = addon:GetTalentTable(addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing)
            tbl["gearSet"] = self.value
            if (self.value == "") then
                tbl["gearSet"] = nil
            end
            addon:SetTalentTable(addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing, tbl)
        end
    end
end

--##########################################################################################################################
--                                  Edit Frame Component handler
--##########################################################################################################################
function TalentUIFrame:OnRenameTextChanged(frame)
    local data = frame:GetParent().editBox:GetText()

    --Check if text is not nill or not empty
    if(data ~= nil and data ~= '') then

        if(data:lower() == addon.CustomProfileName:lower() or data:lower() == "custom") then
            --Text is "custom" so disable the Create button and give a warning
            frame:GetParent().text:SetText(addon.L["Rename profile"] .. "\n\n|cFFFF0000" .. addon.L["'Custom' cannot be used as name!"])
            frame:GetParent().button1:Disable()
        elseif(data:len() > 20) then
            --Text is too long, disable create button and give a warning
            frame:GetParent().text:SetText(addon.L["Rename profile"].. "\n\n|cFFFF0000" .. addon.L["Name too long!"])
            frame:GetParent().button1:Disable()
        elseif(addon:DoesTalentProfileExist(data)) then
            --Text is fine so enable everything
            frame:GetParent().button1:Enable()
            frame:GetParent().text:SetText(addon.L["Rename profile"] .. "\n\n|cFFFF0000" .. addon.L["Name already taken!"])
        else
            --Text is fine so enable everything
            frame:GetParent().button1:Enable()
            frame:GetParent().text:SetText(addon.L["Rename profile"])
        end
    else
        --Empty so disable Create button
        frame:GetParent().button1:Disable()
        frame:GetParent().text:SetText(addon.L["Rename profile"])
    end

    --Rezise the frame
    StaticPopup_Resize(frame:GetParent(), frame:GetParent().which)
end

function TalentUIFrame:OnRenameAccepted(frame)
    local newName = frame.editBox:GetText()
    addon:SetTalentTable(newName, addon:GetTalentTable(addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing))
    addon:DeleteTalentTable(addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing)
    addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing = newName
    addon.TalentUIFrame.ProfileEditorFrame:Hide();
    addon.TalentUIFrame.ProfileEditorFrame:Show();
    addon:Print(addon.L["Profile renamed correctly!"]);
end

--Creates the Frame inside the talent frame
function TalentUIFrame:CreateTalentFrameUI()
    self.CreateEditUI();
    --Create frame and hide it by default
    TalentUIFrame.UpperTalentsUI = CreateFrame("Frame", "SwitchSwitch_UpperTalentsUI", PlayerTalentFrameTalents)
    local UpperTalentsUI = TalentUIFrame.UpperTalentsUI
    UpperTalentsUI:SetPoint("TOPLEFT", PlayerTalentFrameTalents, "TOPLEFT", 60, 30)
    UpperTalentsUI:SetPoint("BOTTOMRIGHT", PlayerTalentFrameTalents, "TOPRIGHT", -110, 2)

    --Set variable for update
    UpperTalentsUI.LastProfileUpdateName = "Custom"

    --Set scripts for the fram
    UpperTalentsUI:SetScript("OnUpdate", TalentUIFrame.UpdateUpperFrame)

    --Create the edit button
    UpperTalentsUI.EditButton = TalentUIFrame:CreateButton("TOPRIGHT", UpperTalentsUI, UpperTalentsUI, "TOPRIGHT", addon.L["Edit"], 80, nil, -10, -2, "SS_EditButton_TF")
    UpperTalentsUI.EditButton:SetScript("OnClick", function()
        ToggleDropDownMenu(1, nil, TalentUIFrame.UpperTalentsUI.EditButtonContext)
    end)
    

    --New botton
    UpperTalentsUI.NewButton = TalentUIFrame:CreateButton("TOPRIGHT", UpperTalentsUI, UpperTalentsUI, "TOPRIGHT", addon.L["Save"], 80, nil, -95, -2) 
    UpperTalentsUI.NewButton:SetScript("OnClick", function() StaticPopup_Show("SwitchSwitch_NewTalentProfilePopUp" , nil, nil, nil, addon.GlobalFrames.SavePVPTalents)end)

    --Edit context menu
    UpperTalentsUI.EditButtonContext = CreateFrame("FRAME", nil, UpperTalentsUI.EditButton, "UIDropDownMenuTemplate")
    UpperTalentsUI.EditButtonContext:SetPoint("TOPLEFT", UpperTalentsUI.EditButton, "BOTTOMLEFT")
    UpperTalentsUI.EditButtonContext.funcName = "editProfileSelection"
    UIDropDownMenu_Initialize(UpperTalentsUI.EditButtonContext, function(self, level)
        local i = 2
        for pname, info in pairs(addon:GetCurrentProfilesTable()) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = pname
            info.index = i
            if(addon.sv.config.SelectedTalentsProfile == pname:lower()) then
                info.index = 1
            else
                i = i + 1
            end
            info.func = function(self)
                --abyui hide first or the settings will be changed
                addon.TalentUIFrame.ProfileEditorFrame:Hide()
                addon.TalentUIFrame.ProfileEditorFrame.CurrentProfileEditing = self.value
                addon.TalentUIFrame.ProfileEditorFrame:Show()
            end
            UIDropDownMenu_AddButton(info,1)
        end
    end, "MENU")
    
    --Create Talent string
    UpperTalentsUI.CurrentProfie = UpperTalentsUI:CreateFontString(nil, "ARTWORK", "GameFontNormalLeft")
    UpperTalentsUI.CurrentProfie:SetText(addon.L["Talents"] .. ":")
    UpperTalentsUI.CurrentProfie:SetPoint("LEFT")

    --Create Dropdown menu for talent groups
    UpperTalentsUI.DropDownTalents = CreateFrame("FRAME", "SwitchSwitch_UpperTalentsUI_Dropdown", UpperTalentsUI, "UIDropDownMenuTemplate")
    UpperTalentsUI.DropDownTalents:SetPoint("LEFT", UpperTalentsUI.CurrentProfie, "RIGHT", 0, -3)
    --Setup the UIDropDownMenu and set the SelectedProgile vatiable
    UIDropDownMenu_SetWidth(UpperTalentsUI.DropDownTalents, 120)
    UIDropDownMenu_Initialize(UpperTalentsUI.DropDownTalents, TalentUIFrame.Initialize_Talents_List)

    --abyui
    WW(UpperTalentsUI.NewButton):CLEAR():LEFT(UpperTalentsUI.DropDownTalents, "RIGHT", 0, 2):un()
    WW(UpperTalentsUI.EditButton):CLEAR():LEFT(UpperTalentsUI.NewButton, "RIGHT", 10, 0):un()

    --Create new Static popup dialog
    StaticPopupDialogs["SwitchSwitch_NewTalentProfilePopUp"] =
    {
        text = addon.L["Create/Ovewrite a profile"],
        button1 = addon.L["Save"],
        button2 = addon.L["Cancel"],
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
        hasEditBox = true,
        exclusive = true,
        enterClicksFirstButton = true,
        autoCompleteSource = TalentUIFrame.GetAutoCompleatProfiles,
        autoCompleteArgs = {},
        OnShow = function(self) 
            --Add the check box to ignore pvp talent
            self.insertedFrame:SetParent(self)
            self.editBox:ClearAllPoints()
            self.editBox:SetPoint("TOP", self, "TOP", 0, -38);
            do --abyui
                local last = addon.lastSelectedProfile
                if last and last ~= addon.CustomProfileName and last ~= "custom" then
                    self.editBox:SetText(last)
                    self.editBox:HighlightText()
                end
            end
            self.insertedFrame:ClearAllPoints()
            self.insertedFrame:SetPoint("BOTTOM", self, "BOTTOM", -self.insertedFrame.text:GetWidth()*0.5, 40)
            self.insertedFrame:Show()
         end,
        OnAccept = function(self)
            TalentUIFrame:OnAceptNewprofile(self)
        end,
        EditBoxOnEnterPressed = function(self)
            TalentUIFrame:OnAceptNewprofile(self:GetParent())
            self:GetParent():Hide();
        end,
        EditBoxOnTextChanged = function (self)
            TalentUIFrame:NewProfileOnTextChange(self)
        end,
        EditBoxOnEscapePressed = function(self)
            self:GetParent():Hide();
        end,
    }
    --Create the confirim save popup
    StaticPopupDialogs["SwitchSwitch_ConfirmTalemtsSavePopUp"] =
    {
        text = addon.L["Saving will override '%s' configuration"],
        button1 = addon.L["Save"],
        button2 = addon.L["Cancel"],
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
        exclusive = true,
        enterClicksFirstButton = true,
        showAlert = true,
        OnAccept = function(self, data)
            TalentUIFrame:OnAcceptOverwrrite(self, data.profile, data.savePVP)
        end,
        OnCancel = function(self, data)
            local dialog = StaticPopup_Show("SwitchSwitch_NewTalentProfilePopUp", nil, nil, nil, addon.GlobalFrames.SavePVPTalents)
            if(dialog) then
                dialog.editBox:SetText(data.profile)
            end
        end
    }
end

--##########################################################################################################################
--                                  Frames Component handler
--##########################################################################################################################
function TalentUIFrame.Initialize_Talents_List(self, level, menuLists)
    local menuList = {}
    --Get all profile names and create the list for the dropdown menu
    if(addon:GetCurrentProfilesTable()) then
        for TalentProfileName, data in pairs(addon:GetCurrentProfilesTable()) do
            table.insert(menuList, {
                text = TalentProfileName
            })
        end
    end

    --Make sure level is always set
    if(not level) then
        level = 1
    end

    --Create all buttons and attach the nececarry information
	for index = 1, #menuList do
        local info = menuList[index]
		if (info.text) then
            info.index = index
            info.arg1 = self
            info.func = TalentUIFrame.SetDropDownValue
			UIDropDownMenu_AddButton( info, level )
		end
    end
    UIDropDownMenu_Refresh(self)
end

function TalentUIFrame.SetDropDownValue(self, arg1, arg2, checked)
    if (not checked) then
        --Change Talents!
        addon:ActivateTalentProfile(self.value)
    end
end

function TalentUIFrame:NewProfileOnTextChange(frame) 
    local data = frame:GetParent().editBox:GetText()

    --Check if text is not nill or not empty
    if(data ~= nil and data ~= '') then

        if(data:lower() == addon.CustomProfileName:lower() or data:lower() == "custom") then
            --Text is "custom" so disable the Create button and give a warning
            frame:GetParent().text:SetText(addon.L["Create/Ovewrite a profile"] .. "\n\n|cFFFF0000" .. addon.L["'Custom' cannot be used as name!"])
            frame:GetParent().button1:Disable()
        elseif(data:len() > 20) then
            --Text is too long, disable create button and give a warning
            frame:GetParent().text:SetText(addon.L["Create/Ovewrite a profile"] .. "\n\n|cFFFF0000" .. addon.L["Name too long!"])
            frame:GetParent().button1:Disable()
        else
            --Text is fine so enable everything
            frame:GetParent().button1:Enable()
            frame:GetParent().text:SetText(addon.L["Create/Ovewrite a profile"])
        end
    else
        --Empty so disable Create button
        frame:GetParent().button1:Disable()
        frame:GetParent().text:SetText(addon.L["Create/Ovewrite a profile"])
    end
    --Rezise the frame
    StaticPopup_Resize(frame:GetParent(), frame:GetParent().which)
end

function TalentUIFrame:OnAceptNewprofile(frame)
    local profileName = frame.editBox:GetText()
    local savePVPTalents = frame.insertedFrame:GetChecked();
    --Check if the profile exits if so, change the text
    if(addon:DoesTalentProfileExist(profileName)) then
        frame.button1:Disable()
        local dialog = StaticPopup_Show("SwitchSwitch_ConfirmTalemtsSavePopUp", profileName)
        if(dialog) then
            dialog.data = {
                ["profile"] = profileName,
                ["savePVP"] = savePVPTalents
            }
        end
        return
    end

    --If talent spec table does not exist create one
    addon:SetTalentTable(profileName, addon:GetCurrentTalents(savePVPTalents))
    addon.sv.config.SelectedTalentsProfile = profileName:lower()

    --Let the user know that the profile has been created
    addon:Print(addon.L["Talent profile %s created!"]:format(profileName))
end

function TalentUIFrame:OnAcceptDeleteprofile(frame, profile)
    --Check if the Profile exists
    if(not addon:DoesTalentProfileExist(profile)) then
        return
    end

    --Delete the Profile
    addon:DeleteTalentTable(profile)
    if(profile:lower() == addon.sv.config.SelectedTalentsProfile) then
        addon.sv.config.SelectedTalentsProfile = addon.CustomProfileName
    end
    addon.TalentUIFrame.ProfileEditorFrame:Hide()
end

function TalentUIFrame:OnAcceptOverwrrite(frame, profile, savePVP)
    addon:SetTalentTable(profile, addon:GetCurrentTalents(savePVP))
    addon.sv.config.SelectedTalentsProfile = profile:lower()
    addon:Print(addon.L["Profile '%s' overwritten!"]:format(profile))
end

function TalentUIFrame.UpdateUpperFrame(self, elapsed)
    --Just to make sure we dont update all every frame, as 90% of the time it will not change
    self.LastUpdateTimerPassed = (self.LastUpdateTimerPassed or 1) + elapsed
    if(self.LastProfileUpdateName ~= addon.sv.config.SelectedTalentsProfile or self.LastUpdateTimerPassed >= 1) then
        --Update the local variable to avoud updating every frame
        self.LastProfileUpdateName = addon.sv.config.SelectedTalentsProfile
        self.LastUpdateTimerPassed = 0
        --Update the UI elements
        UIDropDownMenu_SetSelectedValue(self.DropDownTalents, addon.sv.config.SelectedTalentsProfile)

        if(addon.sv.config.SelectedTalentsProfile ~= "") then
            UIDropDownMenu_SetText(self.DropDownTalents, addon.sv.config.SelectedTalentsProfile)
        end
        -- Save button 
        if(addon.sv.config.SelectedTalentsProfile == addon.CustomProfileName or addon.sv.config.SelectedTalentsProfile == "custom") then
            self.NewButton:Show()
            self.NewButton:Enable()
        else
            self.NewButton:Disable()
            self.NewButton:Hide()
        end

        -- Edit button
        if(addon:CountCurrentTalentsProfile() == 0) then
            self.EditButton:Disable()
            self.EditButton:Hide()
        else
            self.EditButton:Show()
            self.EditButton:Enable()
        end
    end
end

--##########################################################################################################################
--                                  Helper Functions
--##########################################################################################################################
function TalentUIFrame:CreateButton(point, parentFrame, relativeFrame, relativePoint, text, width, height, xOffSet, yOffSet, ButtonName, TextHeight)
    --Set defalt values in case not specified
    width = width or 100
    height = height or 20
    xOffSet = xOffSet or 0
    yOffSet = yOffSet or 0
    TextHeight = TextHeight or ""
    text = text or "Not specified"
    --Create the button and set their value
    local button = CreateFrame("Button", ButtonName, parentFrame, "UIPanelButtonTemplate")
    button:SetPoint(point, relativeFrame, relativePoint, xOffSet, yOffSet)
    button:SetSize(width,height)
    button:SetText(text)
    button:SetNormalFontObject("GameFontNormal"..TextHeight)
    button:SetHighlightFontObject("GameFontHighlight"..TextHeight)
    --Return the button
    return button
end

function TalentUIFrame.GetAutoCompleatProfiles(currentString, ...)
    local returnNames = {};
    for name, _ in pairs(addon:GetCurrentProfilesTable()) do
        if(name:find(currentString) ~= nil) then
            table.insert(returnNames, {
                ["name"] = name,
                ["priority"] = LE_AUTOCOMPLETE_PRIORITY_OTHER
            })
        end
    end
    return returnNames;
end
