    --parei (20/11) declarando o header, precisa agora modificar a config do header quando atualizar
    --fazer uma função para alterar a config header.columns para adicionar ou remover attributos
    
    --próximo: ao criar uma janela AllInOne, precisa criar uma nova instancia no Details!
        --na tabela de configuração precisa dizer que é uma all in one e o details vai chamar esse arquivo pra atualizar

    --(ainda aqui) parei atualizando o height da titlebar
    --proximo passo: atualizar o resto das propriedade da title bar
    --fazer as funcções para setar os valores na titleBar
    --verificar se precisa adicionar funcções no mixin dos bottões como SetTexture, SetVertexColor

    --tem que fazer a função de ShowWindow() e ToggleWindows()
    --fazer a criação do header e fazer o header ser redirecionado (aumentar ou diminuir o tamanho by dragging)

    local LibWindow = LibStub("LibWindow-1.1")
    local df = DetailsFramework
    local detailsFramework = DetailsFramework
    local Details = Details
    local addonName, DetailsPrivite = ...

    local defaultWindowSettings =  {
        isOpened = true,

        libwindow = {},
        width = 350,
        height = 150,

        titlebar = {
            --done here: all options can be retrived from details! settings
        },

        header = {
            show_name = true, --false | on for debug
            show_icon = true,
            auto_size = true, --false | on for debug
            columns = { --damage, dps, percent
                {1, 1},
                {1, 2},
                {1, 1, "%"}
            },
        },
    }

    --namespace
    DetailsPrivite.AllInOneWindow = {}
    local attributeCodes = {

    }

    DetailsPrivite.WindowTooltip = {}


    local textureCoords = {
        show_mainmenu = {0/256, 32/256, 0, 1},
        show_segments = {32/256, 64/256, 0, 1},
        show_report = {96/256, 128/256, 0, 1},
        show_reset = {128/256, 160/256, 0, 1},
        show_displays = {66/256, 93/256, 0, 1},
        show_close = {160/256, 192/256, 0, 1},
    }

    --namespace
    Details.AllInOneWindow = {
        --store the frame of all AllInOne windows, this table does not same with the addon
        FramesCreated = {},
        WindowsOpened = 0,

        --return a table: {{settings}, {settings}, {settings}, {settings}, ...}
        GetAllSettings = function()
            --setting within profile
            return Details.all_in_one_windows
        end,

        --return the amount of settings by calling the above function and returning the amount of indexes
        GetNumSettings = function()
            return #Details.AllInOneWindow.GetAllSettings()
        end,

        --return which will be the next settingID if a new setting is added
        GetNextSettingID = function()
            return #Details.all_in_one_windows + 1
        end,

        --return the settingTable of a settingID
        GetSettingsByID = function(ID)
            return Details.AllInOneWindow.GetAllSettings()[ID]
        end,

        --add a setting and return the settingID
        AddSetting = function(newSettingTable)
            local allSettings = Details.AllInOneWindow.GetAllSettings()
            allSettings[#allSettings+1] = newSettingTable
            return #allSettings
        end,

        --frames already created on this session
        GetAllFrames = function()
            return Details.AllInOneWindow.FramesCreated
        end,

        GetNumFrames = function()
            return #Details.AllInOneWindow.GetAllFrames()
        end,

        GetFrameBySettingID = function(settingId)
            local numFramesCreated = Details.AllInOneWindow.GetNumFrames()
            for id = 1, numFramesCreated do
                local window = Details.AllInOneWindow.GetFrameByID(id)
                if (window:GetSettingsID() == settingId) then
                    return window:GetSettings()
                end
            end
        end,

        AddFrame = function(frame)
            Details.AllInOneWindow.FramesCreated[#Details.AllInOneWindow.FramesCreated+1] = frame
            return #Details.AllInOneWindow.FramesCreated+1
        end,

        GetFrameByID = function(ID)
            return Details.AllInOneWindow.FramesCreated[ID]
        end,

        RestoreAllWindows = function()

        end,

        ShowWindow = function(settingId)

        end,

        HideWindow = function(settingId)
            assert(type(settingId) ~= "number", "Details.AllInOneWindow.HideWindow require a number on 'settingId'")
            local settings = Details.AllInOneWindow.GetAllSettings()
            local windowSetting = settings[settingId]
            assert(type(windowSetting) ~= "table", "Details.AllInOneWindow.HideWindow settings not found for settingId: " .. settingId)

            if (windowSetting) then
                if (windowSetting.isOpened) then
                    windowSetting.isOpened = false
                    --get the window being used by this setting
                    local window = Details.AllInOneWindow.GetFrameBySettingID(settingId)
                    if (window) then
                        window:Hide()
                    end
                end
            end
        end,

        HideAllWindows = function()
            local numSettings = Details.AllInOneWindow.GetNumSettings()
            --table with all the settings for all AllInOne windows in the current profile
            local settings = Details.AllInOneWindow.GetAllSettings()
            for settingId = 1, numSettings do
                local windowSetting = Details.AllInOneWindow.GetSettingsByID(settingId)
                if (windowSetting.isOpened) then
                    Details.AllInOneWindow.HideWindow(settingId)
                end
            end
        end,

        ToggleWindows = function()

        end,
    }

    local menuButtonMixin = {
        GetSettingName = function(button)
            return button.settingName
        end,
    }

    local menuSupportFrameMixin = {
        Constructor = function(menuSupportFrame)
            menuSupportFrame:SetSize(1, 1)
            menuSupportFrame.allButtons = {}

            menuSupportFrame:CreateMenuButton("CloseMenu", "show_close")
            menuSupportFrame:CreateMenuButton("MainMenu", "show_mainmenu")
            menuSupportFrame:CreateMenuButton("SegmentsMenu", "show_segments")
            menuSupportFrame:CreateMenuButton("DisplaysMenu", "show_report")
            menuSupportFrame:CreateMenuButton("ReportMenu", "show_reset")
            menuSupportFrame:CreateMenuButton("ResetMenu", "show_displays")
        end,

        GetNumButtons = function(supportFrame)
            return #supportFrame.allButtons
        end,

        GetButtonByIndex = function(supportFrame, buttonIndex)
            return supportFrame.allButtons[buttonIndex]
        end,

        CreateMenuButton = function(supportFrame, name, settingName)
            local newButton = CreateFrame("button", "$parent" .. name, supportFrame)
            newButton:SetSize(20, 20)
            newButton:SetScale(1)
            supportFrame.allButtons[#supportFrame.allButtons+1] = newButton
            df:Mixin(newButton, menuButtonMixin)
            newButton.settingName = settingName
            return newButton
        end,

        Refresh = function(supportFrame)
            local window = supportFrame:GetParent():GetParent()
            --problem: it is getting the settings from the AllInOneWindow settings, it should get from Details! default window settings
            --this settings should return the regular window setting from Details! on _detalhes.tabela_instancias[windowId]
            local settings = window:GetSettings().titlebar.menu_buttons

            supportFrame:ClearAllPoints()
            supportFrame:SetSize(1, 1)
            supportFrame:SetScale(settings.scale)
            supportFrame:SetAlpha(settings.alpha)

            --buttons currently allowed to show by the user settings
            local allShownButtons = {}
            for i = 1, supportFrame:GetNumButtons() do
                local button = supportFrame:GetButtonByIndex(i)
                if (settings[button:GetSettingName()]) then
                    allShownButtons[#allShownButtons+1] = button
                    button:Show()
                    df:SetRegularButtonTexture(button, settings.texture_file, textureCoords[button:GetSettingName()])
                    df:SetRegularButtonVertexColor(button, settings.color)
                else
                    button:Hide()
                end
            end

            --hardcoded to place the menu buttons in the left side of the window
            --if needed this can be "right" with the header leave space for it
            local attachPoint = "left"

            if (settings.alignment == "horizontal") then
                --make it attach to the left side of the title bar or the right side of the title bar
                supportFrame:SetPoint(attachPoint, window.TitleBar, attachPoint, settings.x_offset, settings.y_offset)

                local paddingAmount = attachPoint == "left" and settings.padding or (settings.padding * -1)
                for i = 1, #allShownButtons do
                    local button = allShownButtons[i]
                    if (i ==1) then
                        button:SetPoint(attachPoint, supportFrame, attachPoint, 0, 0)
                    else
                        local previousButton = allShownButtons[i - 1]
                        local sideToAttach = attachPoint == "left" and "right" or "left"
                        button:SetPoint(attachPoint, previousButton, sideToAttach, paddingAmount, 0)
                    end
                end

            elseif (settings.alignment == "vertical") then
                if (attachPoint == "left") then
                    supportFrame:SetPoint("topright", window.TitleBar, "topleft", settings.x_offset, settings.y_offset)
                else
                    supportFrame:SetPoint("topleft", window.TitleBar, "topright", settings.x_offset, settings.y_offset)
                end

                --here left == top to bottom | right = bottom to top
                local paddingAmount = attachPoint == "left" and settings.padding or (settings.padding * -1)
                local attachTo = attachPoint == "left" and "top" or "bottom"
                for i = 1, #allShownButtons do
                    local button = allShownButtons[i]
                    if (i ==1) then
                        button:SetPoint(attachTo, supportFrame, attachTo, 0, 0)
                    else
                        local previousButton = allShownButtons[i - 1]
                        local sideToAttach = attachTo == "left" and "bottom" or "top"
                        button:SetPoint(attachTo, previousButton, sideToAttach, paddingAmount, 0)
                    end
                end
            end
        end,
    }

    local headerMixin = {
        Constructor = function(header)

        end,
    }

    local titleBarMixin = { --~titlebar
        --run when the title bar is created
        Constructor = function(titleBar)
            titleBar:EnableMouse(false)

            --create support frame for control buttons, it also will create the control buttons as children
            titleBar:CreateMenuSupportFrame()

            --create the elapsed time string
            titleBar:CreateCombatTimeString()
            titleBar:SetCombatTimeText("02:36") --debug

            --create titlebar texture
            titleBar:CreateTexture()

            --create header
            titleBar:CreateHeader()
        end,

        GetSettings = function(titleBar)
            --get the settings from the main window
            return titleBar:GetParent():GetSettings()
        end,

        SetSetting = function()
            --this function exists and get overriden by the SetSetting of the window mixin
        end,

        SetTitleBarHeight = function(titleBar, height)
            assert(type(height) == "number", "Invalid height, usage: TitleBar:SetTitleBarHeight(height)")
            titleBar:SetHeight(height)
            titleBar:SetSetting(height, "titlebar", "height")
            titleBar:Refresh()
        end,

        SetTitleBarTextSize = function(window, size)
            if (not size or type(size) ~= "number") then
                return
            end
            df:SetFontSize(window.TitleBar.CombatTime, size)

        end,

        SetTitleBarTextColor = function(window, color)
            local r, g, b, a = df:ParseColor(color)
            df:SetFontColor(window.TitleBar.CombatTime, r, g, b, a)
        end,

        SetTitleBarTextFont = function(window, font)

        end,

        SetTitleBarTextOutline = function(window, outline)

        end,

        SetTitleBarTextShadow = function(window, shadow, xOffset, yOffset)

        end,

        SetTexture = function(titleBar, texturePath, textureCoord, vertexColor, maskTexture)
            if (texturePath) then
                titleBar.BackgroundTexture:SetTexture(texturePath)

                if (maskTexture) then
                    titleBar.BackgroundTexture:SetMask(maskTexture)
                else
                    titleBar.BackgroundTexture:SetMask("")
                end

                if (vertexColor) then
                    local r, g, b, a = detailsFramework:ParseColors(vertexColor)
                    titleBar.BackgroundTexture:SetVertexColor(r, g, b, a)
                else
                    titleBar.BackgroundTexture:SetVertexColor(1, 1, 1, 1)
                end

                if (textureCoord) then
                    titleBar.BackgroundTexture:SetTexCoord(unpack(textureCoord))
                else
                    titleBar.BackgroundTexture:SetTexCoord(0, 1, 0, 1)
                end
            else
                titleBar.BackgroundTexture:SetTexture("")
            end
        end,

        CreateTexture = function(titleBar)
            local texture = titleBar:CreateTexture("$parentBackgroundTexture", "border")
            titleBar.BackgroundTexture = texture
            return texture
        end,

        GetTexture = function(titleBar)
            return titleBar.BackgroundTexture
        end,

        CreateCombatTimeString = function(titleBar)
            local combatTimeString = titleBar:CreateFontString("$parentCombatTime", "overlay", "GameFontNormal")
            titleBar.CombatTime = combatTimeString
            return titleBar.CombatTime
        end,

        GetCombatTimeString = function(titleBar)
            return titleBar.CombatTime
        end,

        SetCombatTimeText = function(titleBar, combatTime)
            local combatTimeString = titleBar:GetCombatTimeString()
            if (type(combatTime) == "string") then
                combatTimeString:SetText(combatTime)

            elseif (type(combatTime) == "number") then
                local timeAsString = DetailsFramework:IntegerToTimer(combatTime)
                combatTimeString:SetText(timeAsString)
            else
                --if no valid time passed, clear the timer
                combatTimeString:SetText("")
            end
        end,

        Refresh = function(titleBar)
            local settings = titleBar:GetSettings()

            --title bar is always shown
            settings.titlebar_shown = true

            --titlebar_shown = false,
            --titlebar_height = 16,
            --titlebar_texture = "Details Serenity",
            --titlebar_texture_color = {.2, .2, .2, 0.8},

            if (settings.titlebar_shown) then
                titleBar:Show()
                --height
                local height = settings.titlebar_height
                titleBar:SetHeight(height)

                titleBar:SetTexture(settings.titlebar_texture, nil, settings.titlebar_texture_color)

                local header = titleBar:GetHeader()

            else
                titleBar:Hide()
            end



            local timerShown = settings.timer_show


            local menuSupportFrame = titleBar:GetMenuSupportFrame()
            menuSupportFrame:Update()
        end,

        GetMenuSupportFrame = function(titleBar)
            return titleBar.MenuSupportFrame
        end,

        --menu support frame is the frame which will parent the menu buttons (cogwheel, segments, report button, etc)
        CreateMenuSupportFrame = function(titleBar)
            local menuSupportFrame = CreateFrame("frame", "$parentMenuSupportFrame", titleBar, "BackdropTemplate")
            titleBar.MenuSupportFrame = menuSupportFrame
            detailsFramework:Mixin(menuSupportFrame, menuSupportFrameMixin)
            menuSupportFrame:Constructor()
            return menuSupportFrame
        end,

        CreateHeader = function(titleBar)
            local defaultHeaderTable = {
                {text = "", width = 20}, --spec icon
                {text = "Actor Name", width = 60, attribute = {name = true}},

                {text = "Damage Done", width = 60, attribute = {1, 1}},
                {text = "DPS", width = 50, attribute = {1, 2}},
                {text = "Damage %", width = 50, attribute = {percent = true}},

                {text = "Healing Done", width = 60, attribute = {1, 1}},
                {text = "HPS", width = 50, attribute = {1, 2}},
                {text = "Healing %", width = 50, attribute = {percent = true}},
            }

            local defaultHeaderOptions = {
                padding = 2,
            }

            local headerFrame = DetailsFramework:CreateHeader(titleBar, defaultHeaderTable, defaultHeaderOptions)
            titleBar.Header = headerFrame
            detailsFramework:Mixin(headerFrame, headerMixin)
            headerFrame:Constructor()
            return headerFrame
        end,

        GetHeader = function(titleBar)
            return titleBar.Header
        end,
    }

    local AllInOneWindowMixin = {
        SetSetting = function(window, value, ...)
            local config = window:GetSettings()
            local currentTable = config
            local lastKey = ""
            for index, key in ipairs({...}) do
                if (type(currentTable[key]) == "table") then
                    currentTable = currentTable[value]
                else
                    lastKey = key
                end
            end
            currentTable[lastKey] = value
        end,

        IsOpened = function(window)
            return Details.AllInOneWindow.GetSettingsByID(window:GetSettingsID()).isOpened
        end,

        SetWindowSize = function(self, width, height)

        end,

        GetSettings = function(window)
            return window.settings
        end,

        SetSettingID = function(window, newSettingId)
            assert(type(newSettingId) ~= "number", "window.SetSettingID require a number on 'newSettingId'")
            local settings = Details.AllInOneWindow.GetSettingsByID(newSettingId)
            if (settings) then
                window.id = newSettingId
                window.settings = settings
            else
                error("window.SetSettingID could not find a settings for ID " .. newSettingId)
            end
        end,

        GetSettingsID = function(window)
            return window.id
        end,

        CreateTitleBar = function(window)
            local titleBar = CreateFrame("frame", "$parentTitleBar", window, "BackdropTemplate")
            window.TitleBar = titleBar
            df:Mixin(titleBar, titleBarMixin)
            titleBar:Constructor()
            return titleBar
        end,

        GetTitleBar = function(window)
            return window.TitleBar
        end,

        Refresh = function(window)
            local settingsId = window:GetSettingsID()
            local settings = window:GetSettings()

            if (not settings.isOpened) then
                window:Hide()
                return
            end

            local titleBar = window:GetTitleBar()
            titleBar:Refresh()
        end,
    }

    --override
    titleBarMixin.SetSetting = AllInOneWindowMixin.SetSetting

    --[=[
        lib window need to be on the AllInOneWindow:Update() so it can register the new libwindow table on profile change
        --register on libwindow
        LibWindow.RegisterConfig(newWindow, windowSettings.libwindow)
        LibWindow.RestorePosition(newWindow)
        LibWindow.MakeDraggable(newWindow)

        --set the size using the settings
        newWindow:SetSize(windowSettings.width, windowSettings.height)

        --rnable mouse for click through
        newWindow:EnableMouse(true)
        --setmovable for locked
        newWindow:SetMovable(true)

        --title bar position (default on top)
        titleBar:SetPoint("topleft", newWindow, "topleft", 0, 0)
        titleBar:SetPoint("topright", newWindow, "topright", 0, 0)
        --title bar height
        titleBar:SetHeight(20)

        --combat time position
        combatTimeString:SetPoint("left", titleBar, "left", 2, 0)
    --]=]

    --create only the frame for a new window ~newwindow ñewwindow
    function Details.AllInOneWindow.CreateFrame(settingId)
        --create the new window
        local newFrame = CreateFrame("frame", "DetailsNewWindow" .. settingId, UIParent, "BackdropTemplate")
        newFrame.id = settingId
        df:Mixin(newFrame, AllInOneWindowMixin)

        newFrame:SetPoint("center", UIParent, "center", -400, 0)

        --create the title bar
        newFrame:CreateTitleBar()



        --create scroll bar



        --create resizers



        --add the frame to the frame pool
        local frameId = Details.AllInOneWindow.AddFrame(newFrame)
        return newFrame
    end

    --Entry Point to create a new window, must pass here at least once
    --create the settings for a new window plus the frames
    function Details.AllInOneWindow.CreateNew()
        local newSettings = {}
        --copy the settings prototype
        df.table.deploy(newSettings, defaultWindowSettings)
        --copy the settings from a skin
        local skinTable = Details:GetSkin("Minimalistic")
        df.table.deploy(newSettings, skinTable.instance_cprops)

        --add the new settings table into the profile where the new window settings are stored
        local settingId = Details.AllInOneWindow.AddSetting(newSettings)

        --reload all windows
        Details.AllInOneWindow.ReloadAll()

        return settingId
    end

    --assuming this will run when the profile is loaded
    --assuming there will be only one All In One Window

    --used when a profile finished loading
    --entry point for loading a window on profile change, on Initialization or when a new window is created
    --at the moment of details! creation, there's zero settings available
    function Details.AllInOneWindow.ReloadAll()
        --get the amount of settings
        local numSettings = Details.AllInOneWindow.GetNumSettings()

        --table with all window frames already created on this session
        local framesCreated = Details.AllInOneWindow.GetAllFrames()
        --next frame to be used
        local frameIndex = 1

        for settingId = 1, numSettings do
            local windowSetting = Details.AllInOneWindow.GetSettingsByID(settingId)
            if (windowSetting.isOpened) then
                local windowFrame = framesCreated[frameIndex]
                if (not windowFrame) then
                    windowFrame = Details.AllInOneWindow.CreateFrame(settingId)
                end
                frameIndex = frameIndex + 1
                windowFrame:SetSettingID(settingId)

                --libwindow
                LibWindow.RegisterConfig(windowFrame, windowSetting.libwindow)
                LibWindow.RestorePosition(windowFrame)
                LibWindow.MakeDraggable(windowFrame)

                --setup the frame using the settings
                windowFrame:Refresh()
            end
        end
    end


------------------------------------------------------------------------------------------------------------------------

function DetailsPrivite.WindowTooltip.CreateTooltipFrame()
    local damageDoneTooltipFrame = CreateFrame("frame", "DetailsWindowTooltipFrame", UIParent, "BackdropTemplate")
    DetailsFramework:ApplyStandardBackdrop(damageDoneTooltipFrame)

    --create header

    --create 4 scroll frames

    --create 4 separators

    --import data from the regular tooltip functions on each attribute file


end



