--############################################
-- Namespace
--############################################
local addonName, addon = ...

addon.ConfigFrame = {}
local ConfigFrame = addon.ConfigFrame

--##########################################################################################################################
--                                  Config Frame Init
--##########################################################################################################################
local function CreateConfigFrame()
    --Create the main frame and set some its look
    local frame = CreateFrame("FRAME", "SS_MainConfigFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetPoint("CENTER")
    frame:SetSize(400,500)
    frame.TitleText:SetText(addon.L["Switch Switch Options"])

    --General Text seperator
    frame.GeneralText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLargeLeft")
    frame.GeneralText:SetText(addon.L["General"])
    frame.GeneralText:SetPoint("TOPLEFT", frame.InsetBorderTopLeft, "BOTTOMRIGHT", 5, -7)
    frame.GeneralText:SetPoint("TOPRIGHT", frame.InsetBorderTopRight, "BOTTOMLEFT", -5, -7)

    --------- Create subelements to actually change the options
    frame.DebugModeCB = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    frame.DebugModeCB:SetPoint("TOPLEFT", frame.GeneralText, "BOTTOMLEFT", 2, -5)
    frame.DebugModeCB.text:SetText(addon.L["Debug mode"])
    frame.DebugModeCB.text:SetFontObject("GameFontWhite")
    frame.DebugModeCB:SetScript("OnClick", function(self) addon.sv.config.debug = self:GetChecked()  end)

    frame.autoUseItemsCB = CreateFrame("CheckButton", nil, frame, "UICheckButtonTemplate")
    frame.autoUseItemsCB:SetPoint("TOPLEFT", frame.DebugModeCB, "BOTTOMLEFT")
    frame.autoUseItemsCB.text:SetText(addon.L["Prompact to use Tome to change talents?"])
    frame.autoUseItemsCB.text:SetFontObject("GameFontWhite")
    frame.autoUseItemsCB:SetScript("OnClick", function(self) addon.sv.config.autoUseItems = self:GetChecked()  end)

    frame.autoUseItemsCDText = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.autoUseItemsCDText:SetText(addon.L["Autofade timer for auto-change frame"]..":")
    frame.autoUseItemsCDText:SetPoint("TOPLEFT", frame.autoUseItemsCB, "BOTTOMLEFT", 10, -3)

    frame.autoUseItemsCDSlider = CreateFrame("Slider", nil, frame, "OptionsSliderTemplate")
    frame.autoUseItemsCDSlider:SetPoint("TOPRIGHT", frame.autoUseItemsCDText, "BOTTOMLEFT", 150, -10)
    frame.autoUseItemsCDSlider:SetMinMaxValues(0, 30)
    frame.autoUseItemsCDSlider.minValue, frame.autoUseItemsCDSlider.maxValue = frame.autoUseItemsCDSlider:GetMinMaxValues() 
    frame.autoUseItemsCDSlider.Low:SetText(frame.autoUseItemsCDSlider.minValue)
    frame.autoUseItemsCDSlider.High:SetText(frame.autoUseItemsCDSlider.maxValue)
    local point, relativeTo, relativePoint, xOfs, yOfs = frame.autoUseItemsCDSlider.Text:GetPoint()
    frame.autoUseItemsCDSlider.Text:SetPoint("TOP", relativeTo, "BOTTOM", 0, -25)
    frame.autoUseItemsCDSlider.Text:SetText("15")
    frame.autoUseItemsCDSlider:SetValueStep(1)
    frame.autoUseItemsCDSlider.Text2 = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.autoUseItemsCDSlider.Text2:SetPoint("LEFT", frame.autoUseItemsCDSlider, "RIGHT", 15, 0)
    frame.autoUseItemsCDSlider.Text2:SetText(addon.L["(0 to disable auto-fade)"])
    frame.autoUseItemsCDSlider:SetScript("OnValueChanged", function(self,value, userInput)
        frame.autoUseItemsCDSlider.Text:SetText(string.format("%.f", value))
        addon.sv.config.maxTimeSuggestionFrame = tonumber(string.format("%.f", value))
    end)
    frame.autoUseItemsCDSlider:SetValue(addon.sv.config.maxTimeSuggestionFrame)

    frame.ProfilesConfigText = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLargeLeft")
    frame.ProfilesConfigText:SetText(addon.L["Profiles for instance auto-change:"])
    frame.ProfilesConfigText:SetPoint("TOPLEFT", frame.autoUseItemsCDSlider.Low, "BOTTOMLEFT", -13, -10)

    frame.ProfilesConfigText.Description = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.ProfilesConfigText.Description:SetText(addon.L["If you select a profile from any of the dropdown boxes, when etering the specific instance, you will be greeted with a popup that will ask you if you want to change to that profile."])
    frame.ProfilesConfigText.Description:SetPoint("TOPLEFT", frame.ProfilesConfigText, "BOTTOMLEFT", 5, -5)
    frame.ProfilesConfigText.Description:SetWidth(350)
    frame.ProfilesConfigText.Description:SetJustifyH("LEFT")

    frame.ArenaText = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.ArenaText:SetPoint("TOPLEFT", frame.ProfilesConfigText.Description, "BOTTOMLEFT", 0, -20)
    frame.ArenaText:SetText(addon.L["Arenas"] .. ":")
    frame.ArenaText.DropDownMenu = CreateFrame("FRAME", nil, frame, "UIDropDownMenuTemplate")
    frame.ArenaText.DropDownMenu:SetPoint("LEFT", frame.ArenaText, "RIGHT", 0, -5)
    frame.ArenaText.DropDownMenu.funcName = "arena"
    UIDropDownMenu_SetWidth(frame.ArenaText.DropDownMenu, 200)
    UIDropDownMenu_Initialize(frame.ArenaText.DropDownMenu, ConfigFrame.SetUpButtons)


    frame.BattlegroundText = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.BattlegroundText:SetPoint("TOPLEFT", frame.ArenaText, "BOTTOMLEFT", 0, -20)
    frame.BattlegroundText:SetText(addon.L["Battlegrounds"]..":")
    frame.BattlegroundText.DropDownMenu = CreateFrame("FRAME", nil, frame, "UIDropDownMenuTemplate")
    frame.BattlegroundText.DropDownMenu:SetPoint("LEFT", frame.BattlegroundText, "RIGHT", 0, -5)
    frame.BattlegroundText.DropDownMenu.funcName = "bg"
    UIDropDownMenu_SetWidth(frame.BattlegroundText.DropDownMenu, 200)
    UIDropDownMenu_Initialize(frame.BattlegroundText.DropDownMenu, ConfigFrame.SetUpButtons)


    frame.RaidText = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.RaidText:SetPoint("TOPLEFT", frame.BattlegroundText, "BOTTOMLEFT", 0, -20)
    frame.RaidText:SetText(addon.L["Raid"] .. ":")
    frame.RaidText.DropDownMenu = CreateFrame("FRAME", nil, frame, "UIDropDownMenuTemplate")
    frame.RaidText.DropDownMenu:SetPoint("LEFT", frame.RaidText, "RIGHT", 0, -5)
    frame.RaidText.DropDownMenu.funcName = "raid"
    UIDropDownMenu_SetWidth(frame.RaidText.DropDownMenu, 200)
    UIDropDownMenu_Initialize(frame.RaidText.DropDownMenu, ConfigFrame.SetUpButtons)


    frame.Party = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.Party:SetPoint("TOPLEFT", frame.RaidText, "BOTTOMLEFT", 0, -20)
    frame.Party:SetText(addon.L["Party"] .. ":")


    frame.Party.HC = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.Party.HC:SetPoint("TOPLEFT", frame.Party, "BOTTOMLEFT", 30, -10)
    frame.Party.HC:SetText(addon.L["Heroic"] .. ":")
    frame.Party.HC.DropDownMenu = CreateFrame("FRAME", nil, frame, "UIDropDownMenuTemplate")
    frame.Party.HC.DropDownMenu:SetPoint("LEFT", frame.Party.HC, "RIGHT", 0, -5)
    frame.Party.HC.DropDownMenu.funcName = "partyhc"
    UIDropDownMenu_SetWidth(frame.Party.HC.DropDownMenu, 200)
    UIDropDownMenu_Initialize(frame.Party.HC.DropDownMenu, ConfigFrame.SetUpButtons)


    frame.Party.MM = frame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
    frame.Party.MM:SetPoint("TOPLEFT", frame.Party.HC, "BOTTOMLEFT", 0, -20)
    frame.Party.MM:SetText(addon.L["Mythic"] .. ":")
    frame.Party.MM.DropDownMenu = CreateFrame("FRAME", nil, frame, "UIDropDownMenuTemplate")
    frame.Party.MM.DropDownMenu:SetPoint("LEFT", frame.Party.MM, "RIGHT", 0, -5)
    frame.Party.MM.DropDownMenu.funcName = "partymm"
    UIDropDownMenu_SetWidth(frame.Party.MM.DropDownMenu, 200)
    UIDropDownMenu_Initialize(frame.Party.MM.DropDownMenu, ConfigFrame.SetUpButtons)


    --Make the frame moveable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end);

    --Set on shown script
    frame:SetScript("OnShow", function(self)
        self.autoUseItemsCDSlider:SetValue(addon.sv.config.maxTimeSuggestionFrame)
        self.autoUseItemsCB:SetChecked(addon.sv.config.autoUseItems)
        self.DebugModeCB:SetChecked(addon.sv.config.debug)
        UIDropDownMenu_SetSelectedValue(self.ArenaText.DropDownMenu, addon.sv.config.autoSuggest.arena)
        UIDropDownMenu_SetSelectedValue(self.BattlegroundText.DropDownMenu, addon.sv.config.autoSuggest.pvp)
        UIDropDownMenu_SetSelectedValue(self.RaidText.DropDownMenu, addon.sv.config.autoSuggest.raid)
        UIDropDownMenu_SetSelectedValue(self.Party.HC.DropDownMenu, addon.sv.config.autoSuggest.party.HM)
        UIDropDownMenu_SetSelectedValue(self.Party.MM.DropDownMenu, addon.sv.config.autoSuggest.party.MM)
        UIDropDownMenu_SetText(self.ArenaText.DropDownMenu, addon.sv.config.autoSuggest.arena ~= "" and addon.sv.config.autoSuggest.arena or NONE)
        UIDropDownMenu_SetText(self.BattlegroundText.DropDownMenu, addon.sv.config.autoSuggest.pvp ~= "" and addon.sv.config.autoSuggest.pvp or NONE)
        UIDropDownMenu_SetText(self.RaidText.DropDownMenu, addon.sv.config.autoSuggest.raid ~= "" and addon.sv.config.autoSuggest.raid or NONE)
        UIDropDownMenu_SetText(self.Party.HC.DropDownMenu, addon.sv.config.autoSuggest.party.HM ~= "" and addon.sv.config.autoSuggest.party.HM or NONE)
        UIDropDownMenu_SetText(self.Party.MM.DropDownMenu, addon.sv.config.autoSuggest.party.MM ~= "" and addon.sv.config.autoSuggest.party.MM or NONE)
        
    end)

    --Hide the frame by default
    frame:Hide()
    --Return the frame
    return frame
end

function ConfigFrame:ToggleFrame()
    addon.ConfigFrame.Frame = addon.ConfigFrame.Frame or CreateConfigFrame()
    addon.ConfigFrame.Frame:SetShown(not addon.ConfigFrame.Frame:IsShown())
end

--##########################################################################################################################
--                                  Dropdown functions
--##########################################################################################################################
function ConfigFrame.SetUpButtons(self, level, menuList)
    local menuList = {
        {
            text = NONE,
            value = ""
        }
    }
    --Get all profile names and create the list for the dropdown menu
    for TalentProfileName, data in pairs(addon:GetCurrentProfilesTable()) do
        table.insert(menuList, {
            text = TalentProfileName
        })
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
            info.func = ConfigFrame.SetSelectedValueAutoChange
			UIDropDownMenu_AddButton( info, level )
		end
	end
end

function ConfigFrame.SetSelectedValueAutoChange(self, arg1, arg2, checked)
    if(not checked) then
        UIDropDownMenu_SetSelectedValue(arg1, self.value)
        if(arg1.funcName == "arena") then
            addon.sv.config.autoSuggest.arena = self.value
        elseif(arg1.funcName == "bg") then
            addon.sv.config.autoSuggest.pvp = self.value
        elseif(arg1.funcName == "raid") then
            addon.sv.config.autoSuggest.raid = self.value
        elseif(arg1.funcName == "partyhc") then
            addon.sv.config.autoSuggest.party.HM = self.value
        elseif(arg1.funcName == "partymm") then
            addon.sv.config.autoSuggest.party.MM = self.value
        end
    end
end
