
local addonName = "TidyPlatesIcon"
TidyPlatesIconFrame = {}

----------------------------------------------------------------------------------------
-- Dropdown Menu Functions
----------------------------------------------------------------------------------------

local DropdownFrame = CreateFrame("Frame", "TidyPlatesDropdownFrame", UIParent, "UIDropDownMenuTemplate" )
local ButtonTexture = "Interface\\Addons\\TidyPlates\\media\\TidyPlatesIcon"

local function GetCurrentSpec()
	if TidyPlatesUtility.GetSpec(false, false) == 2 then return "secondary"
	else return "primary" end
end

local function SetCurrentTheme(name)
	TidyPlatesOptions[GetCurrentSpec()] = tostring(name)
	TidyPlatesWidgets:ResetWidgets()
	TidyPlates.SetTheme(name)
	TidyPlates:ForceUpdate()
end

local function CurrentThemeHasConfigPanel()
	local theme = TidyPlatesThemeList[TidyPlatesOptions[GetCurrentSpec()]]
	if theme and theme.ShowConfigPanel and type(theme.ShowConfigPanel) == 'function' then return true end
end

local function ConfigureCurrentTheme()
    --[[
	local theme = TidyPlatesThemeList[TidyPlatesOptions[GetCurrentSpec()
	if theme and theme.ShowConfigPanel and type(theme.ShowConfigPanel) == 'function' then theme.ShowConfigPanel() end
	--]]
    ShowTidyPlatesHubPanel()
end

local function InitializeDropdownMenu()
	local DropdownButton, DropdownTitle, DropdownConfigure, DropdownSpacer = {}, {}, {}, {}
	local currentThemeName = TidyPlatesOptions[GetCurrentSpec()]

	-- Spacer Definition
	DropdownSpacer.text = ""
	DropdownSpacer.notCheckable = 1
	DropdownSpacer.isTitle = 1

	-- Title
	DropdownTitle.text = "Tidy Plates"
	DropdownTitle.notCheckable = 1
	DropdownTitle.isTitle = 1
	DropdownTitle.padding = 16
	UIDropDownMenu_AddButton(DropdownTitle)
	UIDropDownMenu_AddButton(DropdownSpacer)

	-- Theme Choices
	for name, theme in pairs(TidyPlatesThemeList) do
		DropdownButton.text = name
		DropdownButton.padding = 16
		--DropdownButton.notCheckable = 1
		if currentThemeName == name then
			DropdownButton.checked = true
		else
			DropdownButton.checked = false
		end
		DropdownButton.func = function() SetCurrentTheme(name) end
		UIDropDownMenu_AddButton(DropdownButton)
	end

	if CurrentThemeHasConfigPanel() then
		UIDropDownMenu_AddButton(DropdownSpacer)

		-- Configure Current
		DropdownConfigure.text = "Configure Theme"
		DropdownConfigure.padding = 16
		DropdownConfigure.notCheckable = 1
		DropdownConfigure.keepShownOnClick = 1
		DropdownConfigure.func = ConfigureCurrentTheme
		UIDropDownMenu_AddButton(DropdownConfigure)
	end

	--[[ Future Features
		Toggle Enemy Nameplates
		Toggle Friendly Nameplates
		Allow overlap
	--]]


end

----------------------------------------------------------------------------------------
-- Standalone Button Creation
----------------------------------------------------------------------------------------



local function CreateStandaloneIcon()
	if TidyPlatesIconFrame and TidyPlatesIconFrame.Show then return end
	local ButtonFrame = CreateFrame("Button", "TidyPlatesIconFrame", UIParent)

	--ButtonFrame:SetUserPlaced()
	ButtonFrame:SetWidth(31)
	ButtonFrame:SetHeight(31)
	ButtonFrame:SetFrameStrata("LOW")
	ButtonFrame:SetToplevel(1)
	ButtonFrame:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	ButtonFrame:SetPoint("TOPLEFT",Minimap,"TOPLEFT")

	local ButtonIcon = ButtonFrame:CreateTexture("TidyPlatesButtonIcon","BACKGROUND")
	ButtonIcon:SetTexture(ButtonTexture)
	ButtonIcon:SetWidth(25)
	ButtonIcon:SetHeight(25)
	ButtonIcon:SetPoint("TOPLEFT",ButtonFrame,"TOPLEFT",4,-3)

	local ButtonBorder = ButtonFrame:CreateTexture("TidyPlatesButtonBorder","OVERLAY")
	ButtonBorder:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	ButtonBorder:SetWidth(53)
	ButtonBorder:SetHeight(53)
	ButtonBorder:SetPoint("TOPLEFT",ButtonFrame,"TOPLEFT")

	local function OnMouseDown() ButtonIcon:SetTexCoord(-0.1,.9,-0.1,.9) end
	local function OnMouseUp() ButtonIcon:SetTexCoord(0,1,0,1) end

	local function OnEnter()
		GameTooltip_SetDefaultAnchor(GameTooltip,UIParent)
		GameTooltip:AddLine("姓名板美化(Tidy Plates)")
		GameTooltip:AddLine("左键点击：选择主题|n右键点击：主题设置|n中键点击：Tidy Plates设置",.8,.8,.8,1)
		GameTooltip:Show()
	end

	local function OnLeave() GameTooltip:Hide() end

	local function OnDragStart()
		OnMouseDown()
		ButtonFrame:StartMoving()
	end

	local function OnDragStop()
		OnMouseUp()
		ButtonFrame:StopMovingOrSizing()
	end

	local function OnClick(frame, button)
		if button =="LeftButton" then
			UIDropDownMenu_Initialize(DropdownFrame, InitializeDropdownMenu, "MENU")
			ToggleDropDownMenu(1, nil, DropdownFrame, frame);
		elseif button =="MiddleButton"  then
			--InterfaceOptionsFrame_OpenToCategory("TidyPlatesInterfaceOptions")
            ConfigureCurrentTheme()
			InterfaceOptionsFrame_OpenToCategory("Tidy Plates")
		elseif button == "RightButton"  then
			ConfigureCurrentTheme()
		end
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
	end

	ButtonFrame:EnableMouse(true)
	ButtonFrame:SetMovable(true)
	ButtonFrame:SetClampedToScreen(true)

	ButtonFrame:RegisterForClicks("LeftButtonUp","RightButtonUp","MiddleButtonUp")
	ButtonFrame:SetScript("OnClick",OnClick)

	ButtonFrame:SetScript("OnMouseDown",OnMouseDown)
	ButtonFrame:SetScript("OnMouseUp",OnMouseUp)
	ButtonFrame:SetScript("OnEnter",OnEnter)
	ButtonFrame:SetScript("OnLeave",OnLeave)

	ButtonFrame:RegisterForDrag("LeftButton")
	ButtonFrame:SetScript("OnDragStart",OnDragStart)
	ButtonFrame:SetScript("OnDragStop",OnDragStop)

	ButtonFrame:SetPoint("CENTER", UIParent)

	TidyPlatesIconFrame = ButtonFrame
end



----------------------------------------------------------------------------------------
-- LDB Button Creation
----------------------------------------------------------------------------------------
local LibIcon, LibDataBroker

local function CreateDataBrokerIcon()


	local ButtonFrameObject = LibDataBroker:NewDataObject(addonName, {
		type = "launcher",
		label = addonName,
		--icon = [[Interface\AddOns\TidyPlatesIcon\TidyPlatesIcon]],
		icon = ButtonTexture,
		OnClick = function(frame, button)
			GameTooltip:Hide()
			if button =="LeftButton" then
				UIDropDownMenu_Initialize(DropdownFrame, InitializeDropdownMenu, "MENU")
				ToggleDropDownMenu(1, nil, DropdownFrame, frame)
			elseif button =="MiddleButton" then
                ConfigureCurrentTheme()
				InterfaceOptionsFrame_OpenToCategory("Tidy Plates")
			elseif button == "RightButton"  then
				ConfigureCurrentTheme()
			end
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end,
		OnTooltipShow = function(tooltip)
			if tooltip and tooltip.AddLine then
				tooltip:SetText("姓名板美化(Tidy Plates)")
				tooltip:AddLine("左键点击：选择主题|n右键点击：主题设置|n中键点击：Tidy Plates设置",.8,.8,.8,1)
				tooltip:Show()
			end
		end,
	})

	LibIcon = LibStub("LibDBIcon-1.0", true)
	if not LibIcon then return end

	TidyPlatesOptions.LDB = TidyPlatesOptions.LDB or {}
	LibIcon:Register(addonName, ButtonFrameObject, TidyPlatesOptions.LDB)

	--[[
	local ToggleTidyPlatesButton = CreateFrame("CheckButton", "TidyPlatesOptions_HideTidyPlatesButtonFrame", TidyPlatesInterfaceOptions, "InterfaceOptionsCheckButtonTemplate")
	_G[ToggleTidyPlatesButton:GetName().."Text"]:SetText("Hide Minimap Icon")
	ToggleTidyPlatesButton:SetPoint("TOPLEFT", TidyPlatesOptions_EnableCastWatcher, "TOPLEFT", 0, -35)
	ToggleTidyPlatesButton:SetScript("OnClick", function(self)
		TidyPlatesOptions.LDB.hide = self:GetChecked() and true or false
		if TidyPlatesOptions.LDB.hide then
			LibIcon:Hide(addonName)
		else
			LibIcon:Show(addonName)
		end
	end)
	--]]
end

----------------------------------------------------------------------------------------
-- Create Button
----------------------------------------------------------------------------------------

local function CreateMinimapButton()
	if LibStub then LibDataBroker = LibStub("LibDataBroker-1.1", true) end
	if LibDataBroker then CreateDataBrokerIcon()
	else CreateStandaloneIcon() end

end

local function HideMinimapButton()
	if TidyPlatesIconFrame and TidyPlatesIconFrame.Hide then
		if LibIcon then LibIcon:Hide(addonName)
		else TidyPlatesIconFrame:Hide() end
	end
end

local function ShowMinimapButton()
	if TidyPlatesIconFrame and TidyPlatesIconFrame.Show then
		if LibIcon then LibIcon:Show(addonName)
		else TidyPlatesIconFrame:Show() end
	end
end

TidyPlatesUtility.CreateMinimapButton = CreateMinimapButton
TidyPlatesUtility.HideMinimapButton = HideMinimapButton
TidyPlatesUtility.ShowMinimapButton = ShowMinimapButton

--local WatcherFrame = CreateFrame("Frame")
--WatcherFrame:RegisterEvent("PLAYER_LOGIN")
--WatcherFrame:SetScript("OnEvent", CreateButton)


-------------------------------------------------------------------------------------
-- Slash Commands
-------------------------------------------------------------------------------------

function EnableTidyPlatesMiniButton(arg)
		TidyPlatesOptions._EnableMiniButton = true
		CreateMinimapButton()
		ShowMinimapButton()
end

--SLASH_TIDYPLATESICON1 = '/tidyplatesicon'
--SlashCmdList['TIDYPLATESICON'] = EnableTidyPlatesMiniButton;





