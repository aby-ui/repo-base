---------------------------------------------------------------------------------------------------------------------
-- Tidy Plates Interface Panel
---------------------------------------------------------------------------------------------------------------------

local addonName, TidyPlatesInternal = ...
TidyPlatesPanel = {}

local SetTheme = TidyPlatesInternal.SetTheme	-- Use the protected version

local version = GetAddOnMetadata("TidyPlates", "version")
local versionString = "|cFF666666"..version

local TidyPlatesInterfacePanel = PanelHelpers:CreatePanelFrame( "TidyPlatesInterfacePanel", "Tidy Plates", nil )
InterfaceOptions_AddCategory(TidyPlatesInterfacePanel);

local CallIn = TidyPlatesUtility.CallIn
local copytable = TidyPlatesUtility.copyTable
local PanelHelpers = TidyPlatesUtility.PanelHelpers

local NO_AUTOMATION = "不自动"
local DURING_COMBAT = "战斗中显示, 战斗结束隐藏"
local OUT_OF_COMBAT = "战斗开始隐藏, 战斗结束显示"

local font = "Interface\\Addons\\TidyPlates\\Media\\DefaultFont.ttf"
local yellow, blue, red, orange = "|cffffff00", "|cFF3782D1", "|cFFFF1100", "|cFFFF6906"

local function SetCastBars(enable)
	if enable then TidyPlates:EnableCastBars()
		else TidyPlates:DisableCastBars()
	end
end


-------------------------------------------------------------------------------------
--  Default Options
-------------------------------------------------------------------------------------

local FirstTryTheme = "Neon"
local DefaultProfile = "Damage"

local ActiveProfile = "None"

TidyPlatesOptions = {

	ActiveTheme = FirstTryTheme,

	FirstSpecProfile = DefaultProfile,
	SecondSpecProfile = DefaultProfile,
	ThirdSpecProfile = DefaultProfile,
	FourthSpecProfile = DefaultProfile,

	FriendlyAutomation = NO_AUTOMATION,
	EnemyAutomation = NO_AUTOMATION,
	DisableCastBars = false,
	ForceBlizzardFont = false,
	WelcomeShown = false,
    _EnableMiniButton = true,
}

local TidyPlatesOptionsDefaults = copytable(TidyPlatesOptions)
local TidyPlatesThemeNames = {}

local AutomationDropdownItems = {
					{ text = NO_AUTOMATION, value = NO_AUTOMATION } ,
					{ text = DURING_COMBAT, value = DURING_COMBAT } ,
					{ text = OUT_OF_COMBAT, value = OUT_OF_COMBAT } ,
					}

local HubProfileList = {}


local function GetProfile()
	return ActiveProfile
end

TidyPlates.GetProfile = GetProfile


function TidyPlatesPanel.AddProfile(self, profileName )
	if  profileName then
		HubProfileList[#HubProfileList+1] = { text = profileName, value = profileName, }
	end
end

local function SetNameplateVisibility(cvar, mode, combat)
	if mode == DURING_COMBAT then
		if combat then
			SetCVar(cvar, 1)
		else
			SetCVar(cvar, 0)
		end
	elseif mode == OUT_OF_COMBAT then
		if combat then
			SetCVar(cvar, 0)
		else
			SetCVar(cvar, 1)
		end
	end
end

--[[
function TidyPlates:ReloadTheme()
	SetTheme(TidyPlatesInternal.activeThemeName)
	TidyPlatesOptions.ActiveTheme = TidyPlatesInternal.activeThemeName
	TidyPlates:ForceUpdate()
end
--]]


-------------------------------------------------------------------------------------
-- Panel
-------------------------------------------------------------------------------------
local ThemeDropdownMenuItems = {}

local function ApplyAutomationSettings()
	SetCastBars(not TidyPlatesOptions.DisableCastBars)
	TidyPlates.OverrideFonts( TidyPlatesOptions.ForceBlizzardFont)

	if not LibDBIcon10_TidyPlatesIcon and TidyPlatesOptions._EnableMiniButton then
		TidyPlatesUtility:CreateMinimapButton()
		TidyPlatesUtility:ShowMinimapButton()
	end

	TidyPlates:ForceUpdate()
end

local function ApplyPanelSettings()

	-- Theme
	SetTheme(TidyPlatesOptions.ActiveTheme or FirstTryTheme)

	-- This is here in case the theme couldn't be loaded, and the core falls back to defaults
	--TidyPlatesOptions.ActiveTheme = TidyPlatesInternal.activeThemeName
	--local theme = TidyPlatesThemeList[TidyPlatesInternal.activeThemeName]

	-- Load Hub Profile
	ActiveProfile = DefaultProfile

	local currentSpec = GetSpecialization()

	if currentSpec == 4 then
		ActiveProfile = TidyPlatesOptions.FourthSpecProfile
	elseif currentSpec == 3 then
		ActiveProfile = TidyPlatesOptions.ThirdSpecProfile
	elseif currentSpec == 2 then
		ActiveProfile = TidyPlatesOptions.SecondSpecProfile
	else
		ActiveProfile = TidyPlatesOptions.FirstSpecProfile
	end

	local _, specname = GetSpecializationInfo(currentSpec)

	local theme = TidyPlates:GetTheme()

	if theme and theme.OnChangeProfile then theme:OnChangeProfile(ActiveProfile) end

	-- Store it for external usage
	--TidyPlatesOptions.ActiveProfile = ActiveProfile
	-- ** Use TidyPlates:GetProfile()

	-- Reset Widgets
	TidyPlates:ResetWidgets()
	TidyPlates:ForceUpdate()
end





local function GetPanelValues(panel)
	TidyPlatesOptions.ActiveTheme = panel.ActiveThemeDropdown:GetValue()

	TidyPlatesOptions.FriendlyAutomation = panel.AutoShowFriendly:GetValue()
	TidyPlatesOptions.EnemyAutomation = panel.AutoShowEnemy:GetValue()
	TidyPlatesOptions.DisableCastBars = panel.DisableCastBars:GetChecked()
	TidyPlatesOptions.ForceBlizzardFont = panel.ForceBlizzardFont:GetChecked()
	TidyPlatesOptions.PrimaryProfile = panel.FirstSpecDropdown:GetValue()

	TidyPlatesOptions.FirstSpecProfile = panel.FirstSpecDropdown:GetValue()
	TidyPlatesOptions.SecondSpecProfile = panel.SecondSpecDropdown:GetValue()
	TidyPlatesOptions.ThirdSpecProfile = panel.ThirdSpecDropdown:GetValue()
	TidyPlatesOptions.FourthSpecProfile = panel.FourthSpecDropdown:GetValue()
end


local function SetPanelValues(panel)
	panel.ActiveThemeDropdown:SetValue(TidyPlatesOptions.ActiveTheme)

	panel.FirstSpecDropdown:SetValue(TidyPlatesOptions.FirstSpecProfile)
	panel.SecondSpecDropdown:SetValue(TidyPlatesOptions.SecondSpecProfile)
	panel.ThirdSpecDropdown:SetValue(TidyPlatesOptions.ThirdSpecProfile)
	panel.FourthSpecDropdown:SetValue(TidyPlatesOptions.FourthSpecProfile)

	panel.DisableCastBars:SetChecked(TidyPlatesOptions.DisableCastBars)
	panel.ForceBlizzardFont:SetChecked(TidyPlatesOptions.ForceBlizzardFont)
	panel.AutoShowFriendly:SetValue(TidyPlatesOptions.FriendlyAutomation)
	panel.AutoShowEnemy:SetValue(TidyPlatesOptions.EnemyAutomation)
end



local function OnValueChange(self)
	local panel = self:GetParent()
	GetPanelValues(panel)
	ApplyPanelSettings()
end


local function OnOkay(panel)
	GetPanelValues(panel)
	ApplyPanelSettings()
	ApplyAutomationSettings()
end


-- Loads values from the saved vars, and preps for display of the panel
local function OnRefresh(panel)

	if not panel then return end

	SetPanelValues(panel)

	------------------------
	-- Spec Notes
	------------------------
	local currentSpec = GetSpecialization()

	------------------------
	-- First Spec Details
	------------------------
	local id, name = GetSpecializationInfo(1)

	if name then
		if currentSpec == 1 then name = name.." (当前专精)" end
		panel.FirstSpecLabel:SetText(name)
	end
	------------------------
	-- Second Spec Details
	------------------------
	local id, name = GetSpecializationInfo(2)

	if name then
		if currentSpec == 2 then name = name.." (当前专精)" end
		panel.SecondSpecLabel:SetText(name)
	end
	------------------------
	-- Third Spec Details
	------------------------
	local id, name = GetSpecializationInfo(3)

	if name then
		if currentSpec == 3 then name = name.." (当前专精)" end
		panel.ThirdSpecLabel:SetText(name)
		panel.ThirdSpecLabel:Show()
		panel.ThirdSpecDropdown:Show()
	end
	------------------------
	-- Fourth Spec Details
	------------------------
	local id, name = GetSpecializationInfo(4)

	if name then
		if currentSpec == 4 then name = name.." (当前专精)" end
		panel.FourthSpecLabel:SetText(name)
		panel.FourthSpecLabel:Show()
		panel.FourthSpecDropdown:Show()
	end

end





local function CreateMenuTables()
	-- Convert the Theme List into a Menu List
	local themecount = 1

	ThemeDropdownMenuItems = {{text = "           ",},}

	if type(TidyPlatesThemeList) == "table" then
		for themename, themepointer in pairs(TidyPlatesThemeList) do
			TidyPlatesThemeNames[themecount] = themename
			--TidyPlatesThemeIndexes[themename] = themecount
			themecount = themecount + 1
		end
		-- Theme Choices
		for index, name in pairs(TidyPlatesThemeNames) do ThemeDropdownMenuItems[index] = {text = name, value = name } end
	end
	sort(ThemeDropdownMenuItems, function (a,b)
	  return (a.text < b.text)
    end)

end

local function BuildInterfacePanel(panel)
	panel:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", insets = { left = 2, right = 2, top = 2, bottom = 2 },})
	panel:SetBackdropColor(0.06, 0.06, 0.06, .7)

	panel.Label:SetFont("Interface\\Addons\\TidyPlates\\Media\\DefaultFont.ttf", 26)
	panel.Label:SetPoint("TOPLEFT", panel, "TOPLEFT", 16+6, -16-4)
	panel.Label:SetTextColor(255/255, 105/255, 6/255)

	panel.Version = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	panel.Version:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, -16-4)
	panel.Version:SetHeight(15)
	panel.Version:SetWidth(350)
	panel.Version:SetJustifyH("RIGHT")
	panel.Version:SetJustifyV("TOP")
	panel.Version:SetText(versionString)
	panel.Version:SetFont("Interface\\Addons\\TidyPlates\\Media\\DefaultFont.ttf", 18)

	panel.DividerLine = panel:CreateTexture(nil, 'ARTWORK')
	panel.DividerLine:SetTexture("Interface\\Addons\\TidyPlatesHub\\shared\\ThinBlackLine")
	panel.DividerLine:SetSize( 500, 12)
	panel.DividerLine:SetPoint("TOPLEFT", panel.Label, "BOTTOMLEFT", -6, -12)

	----------------------------------------------
	-- Theme
	----------------------------------------------
	panel.ThemeCategoryTitle = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	panel.ThemeCategoryTitle:SetFont(font, 22)
	panel.ThemeCategoryTitle:SetText("Theme")
	panel.ThemeCategoryTitle:SetPoint("TOPLEFT", 20, -70)
	panel.ThemeCategoryTitle:SetTextColor(255/255, 105/255, 6/255)

	-- Dropdown
	panel.ActiveThemeDropdown = PanelHelpers:CreateDropdownFrame("TidyPlatesChooserDropdown", panel, ThemeDropdownMenuItems, TidyPlatesDefaultThemeName, nil, true)
	panel.ActiveThemeDropdown:SetPoint("TOPLEFT", panel.ThemeCategoryTitle, "BOTTOMLEFT", -20, -4)

	----------------------------------------------
	-- Profiles
	----------------------------------------------
	panel.ProfileLabel = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	panel.ProfileLabel:SetFont(font, 22)
	panel.ProfileLabel:SetText("Profile")
	panel.ProfileLabel:SetPoint("TOPLEFT", panel.ActiveThemeDropdown, "BOTTOMLEFT", 20, -20)
	panel.ProfileLabel:SetTextColor(255/255, 105/255, 6/255)

    panel.LoadProfileOptionButton = CreateFrame("Button", "TidyPlatesLoadProfileOptionButton", panel, "UIPanelButtonTemplate")
    panel.LoadProfileOptionButton:SetText("加载选项\n\n8.0以后加载选项会造成卡顿，所以改成手工加载")
    panel.LoadProfileOptionButton:SetSize(410, 120)
    panel.LoadProfileOptionButton:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -15, -40)
    panel.LoadProfileOptionButton:SetScript("OnClick", function(self)
        if not IsAddOnLoaded("TidyPlatesHub") then
            LoadAddOn("TidyPlatesHub")
        end
        ShowTidyPlatesHubPanel()
        self:Hide()
    end)
    panel.LoadProfileOptionButton:SetScript("OnShow", function(self)
        if ShowTidyPlatesHubTankPanel then self:Hide() end
    end)

	---------------
	-- Column 1
	---------------
	-- Spec 1
	panel.FirstSpecLabel = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	panel.FirstSpecLabel:SetPoint("TOPLEFT", panel.ProfileLabel,"BOTTOMLEFT", 0, -4)
	panel.FirstSpecLabel:SetWidth(170)
	panel.FirstSpecLabel:SetJustifyH("LEFT")
	panel.FirstSpecLabel:SetText("First Spec")

	panel.FirstSpecDropdown = PanelHelpers:CreateDropdownFrame("TidyPlatesFirstSpecDropdown", panel, HubProfileList, DefaultProfile, nil, true)
	panel.FirstSpecDropdown:SetPoint("TOPLEFT", panel.FirstSpecLabel, "BOTTOMLEFT", -20, -2)

	-- Spec 3
	panel.ThirdSpecLabel = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	panel.ThirdSpecLabel:SetPoint("TOPLEFT", panel.FirstSpecDropdown,"BOTTOMLEFT", 20, -8)
	panel.ThirdSpecLabel:SetWidth(170)
	panel.ThirdSpecLabel:SetJustifyH("LEFT")
	panel.ThirdSpecLabel:SetText("Third Spec")
	panel.ThirdSpecLabel:Hide()

	panel.ThirdSpecDropdown = PanelHelpers:CreateDropdownFrame("TidyPlatesThirdSpecDropdown", panel, HubProfileList, DefaultProfile, nil, true)
	panel.ThirdSpecDropdown:SetPoint("TOPLEFT", panel.ThirdSpecLabel, "BOTTOMLEFT", -20, -2)
	panel.ThirdSpecLabel:Hide()

	---------------
	-- Column 2
	---------------
	-- Spec 2
	panel.SecondSpecLabel = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	panel.SecondSpecLabel:SetPoint("TOPLEFT", panel.FirstSpecLabel,"TOPLEFT", 180, 0)
	panel.SecondSpecLabel:SetWidth(170)
	panel.SecondSpecLabel:SetJustifyH("LEFT")
	panel.SecondSpecLabel:SetText("Second Spec")

	panel.SecondSpecDropdown = PanelHelpers:CreateDropdownFrame("TidyPlatesSecondSpecDropdown", panel, HubProfileList, DefaultProfile, nil, true)
	panel.SecondSpecDropdown:SetPoint("TOPLEFT",panel.SecondSpecLabel, "BOTTOMLEFT", -20, -2)

	-- Spec 4
	panel.FourthSpecLabel = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	panel.FourthSpecLabel:SetPoint("TOPLEFT", panel.SecondSpecDropdown,"BOTTOMLEFT", 20, -8)
	panel.FourthSpecLabel:SetWidth(170)
	panel.FourthSpecLabel:SetJustifyH("LEFT")
	panel.FourthSpecLabel:SetText("Fourth Spec")
	panel.FourthSpecLabel:Hide()

	panel.FourthSpecDropdown = PanelHelpers:CreateDropdownFrame("TidyPlatesFourthSpecDropdown", panel, HubProfileList, DefaultProfile, nil, true)
	panel.FourthSpecDropdown:SetPoint("TOPLEFT",panel.FourthSpecLabel, "BOTTOMLEFT", -20, -2)
	panel.FourthSpecDropdown:Hide()


	----------------------------------------------
	-- Automation
	----------------------------------------------
	panel.AutomationLabel = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	panel.AutomationLabel:SetFont(font, 22)
	panel.AutomationLabel:SetText("Automation")
	panel.AutomationLabel:SetPoint("TOPLEFT", panel.ThirdSpecDropdown, "BOTTOMLEFT", 20, -20)
	panel.AutomationLabel:SetTextColor(255/255, 105/255, 6/255)


	---------------
	-- Column 1
	---------------
	-- Enemy Visibility
	panel.AutoShowEnemyLabel = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	panel.AutoShowEnemyLabel:SetPoint("TOPLEFT", panel.AutomationLabel,"BOTTOMLEFT", 0, -4)
	panel.AutoShowEnemyLabel:SetWidth(170)
	panel.AutoShowEnemyLabel:SetJustifyH("LEFT")
	panel.AutoShowEnemyLabel:SetText("敌对姓名面板:")

	panel.AutoShowEnemy = PanelHelpers:CreateDropdownFrame("TidyPlatesAutoShowEnemy", panel, AutomationDropdownItems, NO_AUTOMATION, nil, true)
	panel.AutoShowEnemy:SetPoint("TOPLEFT",panel.AutoShowEnemyLabel, "BOTTOMLEFT", -20, -2)


	---------------
	-- Column 2
	---------------
	-- Friendly Visibility
	panel.AutoShowFriendlyLabel = panel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	panel.AutoShowFriendlyLabel:SetPoint("TOPLEFT", panel.AutoShowEnemyLabel,"TOPLEFT", 180, 0)
	panel.AutoShowFriendlyLabel:SetWidth(170)
	panel.AutoShowFriendlyLabel:SetJustifyH("LEFT")
	panel.AutoShowFriendlyLabel:SetText("友方姓名面板:")

	panel.AutoShowFriendly = PanelHelpers:CreateDropdownFrame("TidyPlatesAutoShowFriendly", panel, AutomationDropdownItems, NO_AUTOMATION, nil, true)
	panel.AutoShowFriendly:SetPoint("TOPLEFT", panel.AutoShowFriendlyLabel,"BOTTOMLEFT", -20, -2)



	----------------------------------------------
	-- Other Options
	----------------------------------------------
	-- Blizz Button
	local BlizzOptionsButton = CreateFrame("Button", "TidyPlatesOptions_BlizzOptionsButton", panel, "TidyPlatesPanelButtonTemplate")
	--BlizzOptionsButton:SetPoint("TOPRIGHT", ResetButton, "TOPLEFT", -8, 0)
	BlizzOptionsButton:SetPoint("TOPLEFT", panel.AutoShowEnemy, "TOPLEFT", 16, -55)
	BlizzOptionsButton:SetWidth(260)
	BlizzOptionsButton:SetText("姓名板动作及可见性")

	-- Cast Bars
	panel.DisableCastBars = PanelHelpers:CreateCheckButton("TidyPlatesOptions_DisableCastBars", panel, "禁用施法条")
	panel.DisableCastBars:SetPoint("TOPLEFT", BlizzOptionsButton, "TOPLEFT", 0, -35)
	panel.DisableCastBars:SetScript("OnClick", function(self) SetCastBars(not self:GetChecked()) end)

	-- ForceBlizzardFont
	panel.ForceBlizzardFont = PanelHelpers:CreateCheckButton("TidyPlatesOptions_ForceBlizzardFont", panel, "强制使用多语言字体（需要重载）")
	panel.ForceBlizzardFont:SetPoint("TOPLEFT", panel.DisableCastBars, "TOPLEFT", 0, -35)
	panel.ForceBlizzardFont:SetScript("OnClick", function(self) TidyPlates.OverrideFonts( self:GetChecked()); end)

	-- Reset
	ResetButton = CreateFrame("Button", "TidyPlatesOptions_ResetButton", panel, "TidyPlatesPanelButtonTemplate")
	ResetButton:SetPoint("BOTTOMRIGHT", -16, 8)
	ResetButton:SetWidth(155)
	ResetButton:SetText("重置选项")

	-- Update Functions
	panel.okay = OnOkay
	panel.refresh = OnRefresh
	panel.ActiveThemeDropdown.OnValueChanged = OnValueChange

	panel.FirstSpecDropdown.OnValueChanged = OnValueChange
	panel.SecondSpecDropdown.OnValueChanged = OnValueChange
	panel.ThirdSpecDropdown.OnValueChanged = OnValueChange
	panel.FourthSpecDropdown.OnValueChanged = OnValueChange



	-- Blizzard Nameplate Options Button
	BlizzOptionsButton:SetScript("OnClick", function()
		InterfaceOptionsFrame_OpenToCategory(_G["InterfaceOptionsNamesPanel"])
	end)

	-- Reset Button
	ResetButton:SetScript("OnClick", function()
		SetCVar("nameplateShowEnemies", 1)
		SetCVar("threatWarning", 3)		-- Required for threat/aggro detection


		if IsShiftKeyDown() then
			TidyPlatesOptions = wipe(TidyPlatesOptions)
			for i, v in pairs(TidyPlatesOptionsDefaults) do TidyPlatesOptions[i] = v end
			SetCVar("nameplateShowFriends", 0)
			ReloadUI()
		else
			TidyPlatesOptions = wipe(TidyPlatesOptions)
			for i, v in pairs(TidyPlatesOptionsDefaults) do TidyPlatesOptions[i] = v end
			OnRefresh(panel)
			ApplyPanelSettings()
			print(yellow.."重置 "..orange.."Tidy Plates"..yellow.." 默认主题选择")
			print(yellow.."按住 "..blue.."Shift"..yellow.." 同时点击 "..red.."重新配置"..yellow.." 将清除您的已保存的设置,并重新加载用户界面.")
		end

	end)
end

-------------------------------------------------------------------------------------
-- Auto-Loader
-------------------------------------------------------------------------------------
local panelevents = {}

function panelevents:ACTIVE_TALENT_GROUP_CHANGED(self)
	--print("Panel:Talent Group Changed")
	ApplyPanelSettings()
	--OnRefresh(TidyPlatesInterfacePanel)
end

function panelevents:PLAYER_ENTERING_WORLD()
	--print("Panel:Player Entering World")
	-- Tihs may happen every time a loading screen is shown
	local fallBackTheme

	-- Locate a fallback theme
	if TidyPlatesThemeList[FirstTryTheme] then
		fallBackTheme = FirstTryTheme
	else
		for i,v in pairs(TidyPlatesThemeList) do fallBackTheme = i break; end
	end

	-- Check to make sure the selected themes exist; if not, replace with fallback
	if not TidyPlatesThemeList[TidyPlatesOptions.ActiveTheme] then
		TidyPlatesOptions.ActiveTheme = fallBackTheme end

	ApplyPanelSettings()
	ApplyAutomationSettings()
end

function panelevents:PLAYER_REGEN_ENABLED()
	SetNameplateVisibility("nameplateShowEnemies", TidyPlatesOptions.EnemyAutomation, false)
	SetNameplateVisibility("nameplateShowFriends", TidyPlatesOptions.FriendlyAutomation, false)
end

function panelevents:PLAYER_REGEN_DISABLED()
	SetNameplateVisibility("nameplateShowEnemies", TidyPlatesOptions.EnemyAutomation, true)
	SetNameplateVisibility("nameplateShowFriends", TidyPlatesOptions.FriendlyAutomation, true)
end

function panelevents:PLAYER_LOGIN()
	-- This happens only once a session

	-- Setup the interface panels
	CreateMenuTables()				-- Look at the theme table and get names
	BuildInterfacePanel(TidyPlatesInterfacePanel)

	-- First time setup
	if not TidyPlatesOptions.WelcomeShown then
		SetCVar("nameplateShowSelf", 0)		--
		SetCVar("nameplateShowAll", 1)		--


		SetCVar("nameplateShowEnemies", 1)
		SetCVar("nameplateShowFriends", 0)
		SetCVar("threatWarning", 3)		-- Required for threat/aggro detection
		TidyPlatesOptions.WelcomeShown = true
	end

end

TidyPlatesInterfacePanel:SetScript("OnEvent", function(self, event, ...) panelevents[event](self, ...) end)
for eventname in pairs(panelevents) do TidyPlatesInterfacePanel:RegisterEvent(eventname) end

-------------------------------------------------------------------------------------
-- Slash Commands
-------------------------------------------------------------------------------------

TidyPlatesSlashCommands = {}

function slash_TidyPlates(arg)
	if type(TidyPlatesSlashCommands[arg]) == 'function' then
		TidyPlatesSlashCommands[arg]()
		TidyPlates:ForceUpdate()
	else
		TidyPlatesUtility.OpenInterfacePanel(TidyPlatesInterfacePanel)
	end
end

SLASH_TIDYPLATES1 = '/tidyplates'
SLASH_TIDYPLATES2 = '/tp'
SlashCmdList['TIDYPLATES'] = slash_TidyPlates;



