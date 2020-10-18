
local Details = _G.Details
local DF = _G.DetailsFramework

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ~run ~runcode

function Details:InitializeRunCodeWindow()
    local DetailsRunCodePanel = DF:CreateSimplePanel (UIParent, 700, 480, "Details! Run Code", "DetailsRunCodePanel")
    DetailsRunCodePanel.Frame = DetailsRunCodePanel
    DetailsRunCodePanel.__name = "Auto Run Code"
    DetailsRunCodePanel.real_name = "DETAILS_RUNCODEWINDOW"
    --DetailsRunCodePanel.__icon = [[Interface\AddOns\Details\images\lua_logo]]
    DetailsRunCodePanel.__icon = [[Interface\AddOns\Details\images\run_code]]
    --DetailsRunCodePanel.__iconcoords = {0, 1, 0, 1}
    DetailsRunCodePanel.__iconcoords = {0, 30/32, 0, 25/32}
    DetailsRunCodePanel.__iconcoords = {0, 1, 0, 1}
    DetailsRunCodePanel.__iconcolor = "white"
    DetailsPluginContainerWindow.EmbedPlugin (DetailsRunCodePanel, DetailsRunCodePanel, true)
    
    function DetailsRunCodePanel.RefreshWindow()
        Details.OpenRunCodeWindow()
    end
    
    DetailsRunCodePanel:Hide()
end

function Details.OpenRunCodeWindow()
    if (not DetailsRunCodePanel or not DetailsRunCodePanel.Initialized) then
    
        DetailsRunCodePanel.Initialized = true
        
        local f = DetailsRunCodePanel or DF:CreateSimplePanel (UIParent, 700, 480, "Details! Run Code", "DetailsRunCodePanel")

        --> lua editor
        local code_editor = DF:NewSpecialLuaEditorEntry (f, 885, 510, "text", "$parentCodeEditorWindow")
        f.CodeEditor = code_editor
        code_editor:SetPoint ("topleft", f, "topleft", 20, -56)
        
            --> code editor appearance
            code_editor.scroll:SetBackdrop (nil)
            code_editor.editbox:SetBackdrop (nil)
            code_editor:SetBackdrop (nil)
            
            DF:ReskinSlider (code_editor.scroll)
            
            if (not code_editor.__background) then
                code_editor.__background = code_editor:CreateTexture (nil, "background")
            end
            
            code_editor:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
            code_editor:SetBackdropBorderColor (0, 0, 0, 1)
            
            code_editor.__background:SetColorTexture (0.2317647, 0.2317647, 0.2317647)
            code_editor.__background:SetVertexColor (0.27, 0.27, 0.27)
            code_editor.__background:SetAlpha (0.8)
            code_editor.__background:SetVertTile (true)
            code_editor.__background:SetHorizTile (true)
            code_editor.__background:SetAllPoints()
            
            --> code compile error warning
            local errortext_frame = CreateFrame ("frame", nil, code_editor,"BackdropTemplate")
            errortext_frame:SetPoint ("bottomleft", code_editor, "bottomleft", 1, 1)
            errortext_frame:SetPoint ("bottomright", code_editor, "bottomright", -1, 1)
            errortext_frame:SetHeight (20)
            errortext_frame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
            errortext_frame:SetBackdropBorderColor (0, 0, 0, 1)
            errortext_frame:SetBackdropColor (0, 0, 0)
            
            DF:CreateFlashAnimation (errortext_frame)
            
            local errortext_label = DF:CreateLabel (errortext_frame, "", DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
            errortext_label.textcolor = "red"
            errortext_label:SetPoint ("left", errortext_frame, "left", 3, 0)
            code_editor.NextCodeCheck = 0.33
            
            code_editor:HookScript ("OnUpdate", function (self, deltaTime)
                code_editor.NextCodeCheck = code_editor.NextCodeCheck - deltaTime

                if (code_editor.NextCodeCheck < 0) then
                    local script = code_editor:GetText()
                    local func, errortext = loadstring (script, "Q")
                    if (not func) then
                        local firstLine = strsplit ("\n", script, 2)
                        errortext = errortext:gsub (firstLine, "")
                        errortext = errortext:gsub ("%[string \"", "")
                        errortext = errortext:gsub ("...\"]:", "")
                        errortext = errortext:gsub ("Q\"]:", "")
                        errortext = "Line " .. errortext
                        errortext_label.text = errortext
                    else
                        errortext_label.text = ""
                    end
                    
                    code_editor.NextCodeCheck = 0.33
                end
            end)
            
        --> script selector
        local on_select_CodeType_option = function (self, fixedParameter, value)
            --> set the current editing code type
            f.EditingCode = Details.RunCodeTypes [value].Value
            f.EditingCodeKey = Details.RunCodeTypes [value].ProfileKey
            
            --> load the code for the event
            local code = Details.run_code [f.EditingCodeKey]
            code_editor:SetText (code)
        end
        
        local build_CodeType_dropdown_options = function()
            local t = {}
            
            for i = 1, #Details.RunCodeTypes do
                local option = Details.RunCodeTypes [i]
                t [#t + 1] = {label = option.Name, value = option.Value, onclick = on_select_CodeType_option, desc = option.Desc}
            end
            
            return t
        end
        
        local code_type_label = DF:CreateLabel (f, "Event:", DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
        local code_type_dropdown = DF:CreateDropDown (f, build_CodeType_dropdown_options, 1, 160, 20, "CodeTypeDropdown", _, DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
        code_type_dropdown:SetPoint ("left", code_type_label, "right", 2, 0)
        code_type_dropdown:SetFrameLevel (code_editor:GetFrameLevel() + 10)
        code_type_label:SetPoint ("bottomleft", code_editor, "topleft", 0, 8)
        
        --> create save button
        local save_script = function()
            local code = code_editor:GetText()
            local func, errortext = loadstring (code, "Q")
            
            if (func) then
                Details.run_code [f.EditingCodeKey] = code
                Details:RecompileAutoRunCode()
                Details:Msg ("Code saved!")
                code_editor:ClearFocus()
            else
                errortext_frame:Flash (0.2, 0.2, 0.4, true, nil, nil, "NONE")
                Details:Msg ("Can't save the code: it has errors.")
            end
        end
        
        local button_y = -6
        
        local save_script_button = DF:CreateButton (f, save_script, 120, 20, "Save", -1, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"), DF:GetTemplate ("font", "PLATER_BUTTON"))
        save_script_button:SetIcon ([[Interface\BUTTONS\UI-Panel-ExpandButton-Up]], 20, 20, "overlay", {0.1, .9, 0.1, .9})
        save_script_button:SetPoint ("topright", code_editor, "bottomright", 0, button_y)
        
        --> create cancel button
        local cancel_script = function()
            code_editor:SetText (Details.run_code [f.EditingCodeKey])
            Details:Msg ("Code cancelled!")
            code_editor:ClearFocus()
        end
        
        local cancel_script_button = DF:CreateButton (f, cancel_script, 120, 20, "Cancel", -1, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"), DF:GetTemplate ("font", "PLATER_BUTTON"))
        cancel_script_button:SetIcon ([[Interface\BUTTONS\UI-Panel-MinimizeButton-Up]], 20, 20, "overlay", {0.1, .9, 0.1, .9})
        cancel_script_button:SetPoint ("topleft", code_editor, "bottomleft", 0, button_y)
        
        --> create run now button
       
        local execute_script = function()
            local script = code_editor:GetText()
            local func, errortext = loadstring (script, "Q")
            
            if (func) then
                DF:SetEnvironment(func)
                DF:QuickDispatch (func)
            else
                errortext_frame:Flash (0.2, 0.2, 0.4, true, nil, nil, "NONE")
            end
        end
        
        local run_script_button = DF:CreateButton (f, execute_script, 120, 20, "Test Code", -1, nil, nil, nil, nil, nil, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"), DF:GetTemplate ("font", "PLATER_BUTTON"))
        run_script_button:SetIcon ([[Interface\BUTTONS\UI-SpellbookIcon-NextPage-Up]], 20, 20, "overlay", {0.05, 0.95, 0.05, 0.95})
        run_script_button:SetPoint ("bottomright", code_editor, "topright", 0, 3)
        
    end
    
    DetailsPluginContainerWindow.OpenPlugin (DetailsRunCodePanel)
    DetailsRunCodePanel.CodeTypeDropdown:Select (1, true)
    
    --> show the initialization code when showing up this window
    DetailsRunCodePanel.EditingCode = Details.RunCodeTypes [1].Value
    DetailsRunCodePanel.EditingCodeKey = Details.RunCodeTypes [1].ProfileKey

    local code = Details.run_code [DetailsRunCodePanel.EditingCodeKey]
    DetailsRunCodePanel.CodeEditor:SetText (code)
end
