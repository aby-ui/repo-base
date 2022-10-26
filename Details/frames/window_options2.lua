if (true) then
    --return
end


local Details = _G.Details
local DF = _G.DetailsFramework
local Loc = _G.LibStub("AceLocale-3.0"):GetLocale("Details")
--local SharedMedia = _G.LibStub:GetLibrary("LibSharedMedia-3.0")
--local LDB = _G.LibStub("LibDataBroker-1.1", true)
--local LDBIcon = LDB and _G.LibStub("LibDBIcon-1.0", true)

--options panel namespace
Details.options = {}

--local tinsert = _G.tinsert
local unpack = _G.unpack
local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
local _
local preset_version = 3
Details.preset_version = preset_version

--templates
local options_text_template = DF:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
local options_dropdown_template = DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
local options_switch_template = DF:GetTemplate("switch", "OPTIONS_CHECKBOX_TEMPLATE")
local options_slider_template = DF:GetTemplate("slider", "OPTIONS_SLIDER_TEMPLATE")

local options_button_template = DF:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")
local options_button_template_selected = DF.table.copy({}, DF:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE"))
options_button_template_selected.backdropbordercolor = {1, .8, .2}

--options
local section_menu_button_width = 120
local section_menu_button_height = 20

--build the options window
function Details:InitializeOptionsWindow(instance)
    return Details.options.InitializeOptionsWindow(instance)
end

function Details.options.InitializeOptionsWindow(instance)
	local DetailsOptionsWindow = DF:NewPanel(UIParent, _, "DetailsOptionsWindow", _, 897, 592)
    local f = DetailsOptionsWindow.frame

	f.Frame = f
	f.__name = "Options"
	f.real_name = "DETAILS_OPTIONS"
	f.__icon = [[Interface\Scenarios\ScenarioIcon-Interact]]
    _G.DetailsPluginContainerWindow.EmbedPlugin(f, f, true)
    f.sectionFramesContainer = {}

    DF:ApplyStandardBackdrop(f)
    local titleBar = DF:CreateTitleBar(f, "Options Panel")
    titleBar.Text:Hide()

    local titleText = DF:NewLabel(titleBar, nil, "$parentTitleLabel", "title", "Details! " .. Loc ["STRING_OPTIONS_WINDOW"], "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
    titleText:SetPoint("center", titleBar, "center")

    f:Hide()

    local formatFooterText = function(object)
        object.fontface = "GameFontNormal"
        object.fontsize = 10
        object.fontcolor = {1, 0.82, 0}
    end

    --create a floating frame to hold footer frames
    local footerFrame = CreateFrame("frame", "$parentFooterFrame", f, "BackdropTemplate")
    footerFrame:SetPoint("bottomleft", f, "bottomleft", 0, 0)
    footerFrame:SetPoint("bottomright", f, "bottomright", 0, 0)
    footerFrame:SetHeight(50)
    footerFrame:SetFrameLevel(f:GetFrameLevel() + 10)
    DF:ApplyStandardBackdrop(footerFrame)

    local gradientBelowTheLine = DetailsFramework:CreateTexture(footerFrame, {gradient = "vertical", fromColor = {0, 0, 0, 0.25}, toColor = "transparent"}, 1, 90, "artwork", {0, 1, 0, 1}, "dogGradient")
    gradientBelowTheLine:SetPoint("bottoms")

    --select the instance to edit
    local onSelectInstance = function(_, _, instanceId)
        local instance = _detalhes.tabela_instancias[instanceId]
        if (not instance:IsEnabled() or not instance:IsStarted()) then
            _detalhes.CriarInstancia (_, _, instance.meu_id)
        end
        Details.options.SetCurrentInstance(instance)
        f.updateMicroFrames()
    end

    local buildInstanceMenu = function()
        local instanceList = {}
        for index = 1, math.min (#_detalhes.tabela_instancias, _detalhes.instances_amount) do
            local instance = _detalhes.tabela_instancias[index]

            --what the window is showing
            local atributo = instance.atributo
            local sub_atributo = instance.sub_atributo
            
            if (atributo == 5) then --custom
                local CustomObject = _detalhes.custom [sub_atributo]
                if (not CustomObject) then
                    instance:ResetAttribute()
                    atributo = instance.atributo
                    sub_atributo = instance.sub_atributo
                    instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], onclick = onSelectInstance, icon = _detalhes.sub_atributos [atributo].icones[sub_atributo] [1], texcoord = _detalhes.sub_atributos [atributo].icones[sub_atributo] [2]}
                else
                    instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. CustomObject.name, onclick = onSelectInstance, icon = CustomObject.icon}
                end
            else
                local modo = instance.modo
                
                if (modo == 1) then --solo plugin
                    atributo = _detalhes.SoloTables.Mode or 1
                    local SoloInfo = _detalhes.SoloTables.Menu [atributo]
                    if (SoloInfo) then
                        instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. SoloInfo [1], onclick = onSelectInstance, icon = SoloInfo [2]}
                    else
                        instanceList [#instanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectInstance, icon = ""}
                    end
                    
                elseif (modo == 4) then --raid plugin
                    local plugin_name = instance.current_raid_plugin or instance.last_raid_plugin
                    if (plugin_name) then
                        local plugin_object = _detalhes:GetPlugin (plugin_name)
                        if (plugin_object) then
                            instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. plugin_object.__name, onclick = onSelectInstance, icon = plugin_object.__icon}
                        else
                            instanceList [#instanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectInstance, icon = ""}
                        end
                    else
                        instanceList [#instanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectInstance, icon = ""}
                    end
                else
                    instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], onclick = onSelectInstance, icon = _detalhes.sub_atributos [atributo].icones[sub_atributo] [1], texcoord = _detalhes.sub_atributos [atributo].icones[sub_atributo] [2]}
                end
            end
        end
        return instanceList
    end

    local instanceSelection = DF:NewDropDown (footerFrame, _, "$parentInstanceSelectDropdown", "instanceDropdown", 200, 18, buildInstanceMenu) --, nil, options_dropdown_template
    f.instanceDropdown = instanceSelection
    instanceSelection:SetPoint("bottomright", f, "bottomright", -7, 09)
    instanceSelection:SetTemplate(options_dropdown_template)
    instanceSelection:SetHook("OnEnter", function()
        GameCooltip:Reset()
        GameCooltip:Preset(2)
        GameCooltip:AddLine(Loc ["STRING_MINITUTORIAL_OPTIONS_PANEL1"])
        GameCooltip:ShowCooltip(instanceSelection.widget, "tooltip")
    end)
    instanceSelection:SetHook("OnLeave", function()
        GameCooltip:Hide()
    end)

    local instances_string = DF:NewLabel(footerFrame, nil, "$parentInstanceDropdownLabel", "instancetext", Loc ["STRING_OPTIONS_EDITINSTANCE"], "GameFontNormal", 12)
    instances_string:SetPoint("right", instanceSelection, "left", -2, 1)
    formatFooterText(instances_string)

    local bigdogImage = DF:NewImage(footerFrame, [[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]], 180*0.9, 200*0.9, nil, {1, 0, 0, 1}, "backgroundBigDog", "$parentBackgroundBigDog")
    bigdogImage:SetPoint("bottomright", footerFrame, "topright", 0, 0)
    bigdogImage:SetAlpha(.25)

    --editing group checkbox
    local onToggleEditingGroup = function(self, fixparam, value)
        _detalhes.options_group_edit = value
    end
    local editingGroupCheckBox = DF:CreateSwitch(footerFrame, onToggleEditingGroup, _detalhes.options_group_edit, _, _, _, _, _, "$parentEditGroupCheckbox", _, _, _, _, DF:GetTemplate("switch", "OPTIONS_CHECKBOX_BRIGHT_TEMPLATE"))
    editingGroupCheckBox:SetAsCheckBox()
    editingGroupCheckBox.tooltip = Loc ["STRING_MINITUTORIAL_OPTIONS_PANEL2"]

    local editingGroupLabel = DF:NewLabel(footerFrame, nil, "$parentEditingGroupLabel", "editingGroupLabel", "Editing Group:", "GameFontNormal", 12) --localize-me
    editingGroupLabel:SetPoint("bottomleft", instances_string, "topleft", 0, 5)
    editingGroupCheckBox:SetPoint("left", editingGroupLabel, "right", 2, 0)
    formatFooterText(editingGroupLabel)

	--create test bars
        DF:NewColor("C_OptionsButtonOrange", 0.9999, 0.8196, 0, 1)
        local create_test_bars_func = function()
            _detalhes.CreateTestBars()
            if (not _detalhes.test_bar_update) then
                _detalhes:StartTestBarUpdate()
            else
                _detalhes:StopTestBarUpdate()
            end
        end
        local fillbars = DF:NewButton(footerFrame, _, "$parentCreateExampleBarsButton", nil, 140, 20, create_test_bars_func, nil, nil, nil, Loc ["STRING_OPTIONS_TESTBARS"], 1)
        fillbars:SetPoint("bottomleft", f.widget, "bottomleft", 10, 10)
        fillbars:SetTemplate(options_button_template)
        fillbars:SetIcon ("Interface\\AddOns\\Details\\images\\icons", nil, nil, nil, {323/512, 365/512, 42/512, 78/512}, {1, 1, 1, 0.6}, 4, 2)

    --change log
        local changelog = DF:NewButton(footerFrame, _, "$parentOpenChangeLogButton", nil, 140, 20, _detalhes.OpenNewsWindow, "change_log", nil, nil, Loc ["STRING_OPTIONS_CHANGELOG"], 1)
        changelog:SetPoint("left", fillbars, "right", 10, 0)
        changelog:SetTemplate(options_button_template)
        changelog:SetIcon ("Interface\\AddOns\\Details\\images\\icons", nil, nil, nil, {367/512, 399/512, 43/512, 76/512}, {1, 1, 1, 0.8}, 4, 2)

    --search field
        local searchBox = DF:CreateTextEntry(footerFrame, function()end, 140, 20, _, _, _, options_dropdown_template)
        searchBox:SetPoint("left", changelog, "right", 10, 0)

        local searchLabel = DF:CreateLabel(footerFrame, "Search:") --localize-me
        searchLabel:SetPoint("bottomleft", searchBox, "topleft", 0, 2)
        formatFooterText(searchLabel)

        searchBox:SetHook("OnChar", function()
            if (searchBox.text ~= "") then
                local searchSection = f.sectionFramesContainer[19]
                searchSection.sectionButton:Enable()
                searchSection.sectionButton:Click()

                local searchingFor = searchBox.text
                local allSectionFrames = f.sectionFramesContainer

                local allSectionNames = {}
                local allSectionOptions = {}

                for i = 1, #allSectionFrames do
                    local sectionFrame = allSectionFrames[i]
                    local sectionOptionsTable = sectionFrame.sectionOptions

                    allSectionNames[#allSectionNames+1] = sectionFrame.name
                    allSectionOptions[#allSectionOptions+1] = sectionOptionsTable
                end

                --this table will hold all options
                local allOptions = {}
                --start the fill process filling 'allOptions' with each individual option from each tab
                for i = 1, #allSectionOptions do
                    local sectionOptions = allSectionOptions[i]
                    local lastLabel = nil
                    for k, setting in pairs(sectionOptions) do
                        if (type(setting) == "table") then
                            if (setting.type == "label") then
                                lastLabel = setting
                            end
                            if (setting.name) then
                                allOptions[#allOptions+1] = {setting = setting, label = lastLabel, header = allSectionNames[i]}
                            end
                        end
                    end
                end

                local searchingText = string.lower(searchingFor)
                searchBox:SetFocus()

                local options = {}

                local lastTab = nil
                local lastLabel = nil
                for i = 1, #allOptions do
                    local optionData = allOptions[i]
                    local optionName = string.lower(optionData.setting.name)
                    if (optionName:find(searchingText)) then
                        if optionData.header ~= lastTab then
                            if lastTab ~= nil then
                                options[#options+1] = {type = "label", get = function() return "" end, text_template = DF:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")} -- blank
                            end
                            options[#options+1] = {type = "label", get = function() return optionData.header end, text_template = {color = "silver", size = 14, font = DF:GetBestFontForLanguage()}}
                            lastTab = optionData.header
                            lastLabel = nil
                        end
                        if optionData.label ~= lastLabel then
                            options[#options+1] = optionData.label
                            lastLabel = optionData.label
                        end
                        options[#options+1] = optionData.setting
                    end
                end

                local startX = 200
                local startY = -60

                DF:BuildMenuVolatile(searchSection, options, startX, startY, 560, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template, globalCallback)

            else
                f.sectionFramesContainer[19].sectionButton:Disable()
            end
        end)

    local sectionsName = { --section names
        [1] = Loc ["STRING_OPTIONSMENU_DISPLAY"],
        [3] = Loc ["STRING_OPTIONSMENU_ROWSETTINGS"],
        [4] = Loc ["STRING_OPTIONSMENU_ROWTEXTS"],

        [5] = Loc ["STRING_OPTIONSMENU_TITLEBAR"], --titlebar
        [6] = Loc ["STRING_OPTIONSMENU_WINDOWBODY"], --window body
        [7] = Loc ["STRING_OPTIONS_INSTANCE_STATUSBAR_ANCHOR"], --statusbar
        [12] = Loc ["STRING_OPTIONSMENU_WALLPAPER"],
        [13] = Loc ["STRING_OPTIONSMENU_AUTOMATIC"],

        [9] = Loc ["STRING_OPTIONSMENU_PROFILES"],
        [2] = Loc ["STRING_OPTIONSMENU_SKIN"],
        [8] = Loc ["STRING_OPTIONSMENU_PLUGINS"],
        [10] = Loc ["STRING_OPTIONSMENU_TOOLTIP"],
        [11] = Loc ["STRING_OPTIONSMENU_DATAFEED"],

        [14] = Loc ["STRING_OPTIONSMENU_RAIDTOOLS"],
        [15] = "Broadcaster Tools",
        [16] = Loc ["STRING_OPTIONSMENU_SPELLS"],
        [17] = Loc ["STRING_OPTIONSMENU_DATACHART"],

        [18] = "Mythic Dungeon",

        [19] = "Search Results",

    }

    local optionsSectionsOrder = {
        1, "", 3, 4, "", 5, 6, 7, 12, 13, "", 9, 2, 8, 10, 11, 18, "", 14, 15, 16, 17, "", 19
    }

    local maxSectionIds = 19
    Details.options.maxSectionIds = maxSectionIds

    local buttonYPosition = -40

    function Details.options.SelectOptionsSection(sectionId)
        for i = 1, maxSectionIds do
            f.sectionFramesContainer[i]:Hide()
            if (f.sectionFramesContainer[i].sectionButton) then
                f.sectionFramesContainer[i].sectionButton:SetTemplate(options_button_template)
                f.sectionFramesContainer[i].sectionButton:SetIcon({.4, .4, .4}, 4, section_menu_button_height -4, "overlay")
            end
        end

        f.sectionFramesContainer[sectionId]:Show()
        --hightlight the option button
        f.sectionFramesContainer[sectionId].sectionButton:SetTemplate(options_button_template_selected)
        f.sectionFramesContainer[sectionId].sectionButton:SetIcon({1, 1, 0}, 4, section_menu_button_height -4, "overlay")
    end

    Details.options.SetCurrentInstance(instance)

    --create frames for sections
    for index, sectionId in ipairs(optionsSectionsOrder) do
        if (type(sectionId) == "number") then
            local sectionFrame = CreateFrame("frame", "$parentTab" .. sectionId, f, "BackdropTemplate")
            sectionFrame:SetPoint("topleft", f, "topleft", -40, 22)
            sectionFrame:SetSize(f:GetSize())
            sectionFrame:EnableMouse(false)

            local realBackdropAreaFrame = CreateFrame("frame", "$parentTab" .. sectionId .. "BackdropArea", f, "BackdropTemplate")
            realBackdropAreaFrame:SetFrameLevel(f:GetFrameLevel()-1)
            realBackdropAreaFrame:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
            realBackdropAreaFrame:SetBackdropColor(0.1215, 0.1176, 0.1294, .1)
            realBackdropAreaFrame:SetBackdropBorderColor(0.2, 0.2, 0.2, .05)
            realBackdropAreaFrame:SetPoint("topleft", f, "topleft", 150, -27)
            realBackdropAreaFrame:SetSize(775, 570)

			local leftGradient = DetailsFramework:CreateTexture(sectionFrame, {gradient = "horizontal", fromColor = {0, 0, 0, 0}, toColor = {0, 0, 0, 0.3}}, 10, 1, "artwork", {0, 1, 0, 1}, "leftGradient")
			leftGradient:SetPoint("right-left", realBackdropAreaFrame, 1)

			local rightGradient = DetailsFramework:CreateTexture(sectionFrame, {gradient = "horizontal", fromColor = {0, 0, 0, 0}, toColor = {0, 0, 0, 0.25}}, 110, 1, "overlay", nil, "rightGradient")
			rightGradient:SetPoint("rights", realBackdropAreaFrame, 0)
            rightGradient:Hide()

			local bottomGradient = DetailsFramework:CreateTexture(realBackdropAreaFrame, {gradient = "vertical", fromColor = {0, 0, 0, 1}, toColor = {0, 0, 0, 0}}, 1, 20, "artwork", {0, 1, 0, 1}, "bottomGradient")
            bottomGradient.sublevel = 7
			bottomGradient:SetPoint("bottoms")

            sectionFrame.name = sectionsName[sectionId]
            f.sectionFramesContainer[sectionId] = sectionFrame

            local buildOptionSectionFunc = Details.optionsSection[sectionId]
            if (buildOptionSectionFunc) then
                --call the function to create the frame
                buildOptionSectionFunc(sectionFrame)

                --create a button for the section
                local sectionButton = DF:CreateButton(f, function() Details.options.SelectOptionsSection(sectionId) end, section_menu_button_width, section_menu_button_height, sectionsName[sectionId], sectionId, nil, nil, nil, "$parentButtonSection" .. sectionId, nil, options_button_template, options_text_template)
                sectionButton:SetIcon({.4, .4, .4}, 4, section_menu_button_height -4, "overlay")
                sectionButton:SetPoint("topleft", f, "topleft", 10, buttonYPosition)
                buttonYPosition = buttonYPosition - (section_menu_button_height + 1)
                sectionFrame.sectionButton = sectionButton

                if (sectionId == 19) then --search results
                    sectionButton:Disable()

                elseif (sectionId == 1) then
                    sectionButton:SetIcon({1, 1, 0}, 4, section_menu_button_height -4, "overlay")
                end
            end
        else
            buttonYPosition = buttonYPosition - 15
        end
    end

    function Details.options.GetOptionsSection(sectionId)
        return f.sectionFramesContainer[sectionId]
    end

    function f.RefreshWindow()
		if (not _G.DetailsOptionsWindow.instance) then
			local lowerInstance = Details:GetLowerInstanceNumber()
			if (not lowerInstance) then
				local instance = Details:GetInstance(1)
				Details.CriarInstancia(_, _, 1)
				Details:OpenOptionsWindow(instance)
			else
				Details:OpenOptionsWindow(Details:GetInstance(lowerInstance))
			end
		else
			Details:OpenOptionsWindow(_G.DetailsOptionsWindow.instance)
        end
    end
    
    Details.options.SelectOptionsSection(1)
end

-- ~options
function Details:OpenOptionsWindow(instance, no_reopen, section)
	if (not instance.GetId or not instance:GetId()) then
		instance, no_reopen, section = unpack(instance)
    end

    if (not no_reopen and not instance:IsEnabled() or not instance:IsStarted()) then
        Details:CreateInstance(instance:GetId())
	end

    GameCooltip:Close()

    local window = _G.DetailsOptionsWindow
    if (not window) then
        Details.options.InitializeOptionsWindow(instance)
        window = _G.DetailsOptionsWindow
    end

    Details.options.SetCurrentInstanceAndRefresh(instance)
    _G.DetailsPluginContainerWindow.OpenPlugin(_G.DetailsOptionsWindow)

    if (section) then
        Details.options.SelectOptionsSection(section)
    end

    window.instanceDropdown:Refresh()
    window.instanceDropdown:Select(instance:GetId())

    window.updateMicroFrames()
end
