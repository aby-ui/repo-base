

local Details = _G.Details
local DF = _G.DetailsFramework

local _

function Details:InitializeMacrosWindow()
    local DetailsMacrosPanel = DF:CreateSimplePanel(UIParent, 700, 480, "Details! Useful Macros", "DetailsMacrosPanel")
    DetailsMacrosPanel.Frame = DetailsMacrosPanel
    DetailsMacrosPanel.__name = "Macros"
    DetailsMacrosPanel.real_name = "DETAILS_MACROSWINDOW"
    DetailsMacrosPanel.__icon = [[Interface\MacroFrame\MacroFrame-Icon]]
    DetailsMacrosPanel.__iconcoords = {0, 1, 0, 1}
    DetailsMacrosPanel.__iconcolor = "white"
    DetailsPluginContainerWindow.EmbedPlugin (DetailsMacrosPanel, DetailsMacrosPanel, true)
    
    function DetailsMacrosPanel.RefreshWindow()
        Details.OpenMacrosWindow()
    end
    
    DetailsMacrosPanel:Hide()
end

function Details.OpenMacrosWindow()

    if (not DetailsMacrosPanel or not DetailsMacrosPanel.Initialized) then

        DetailsMacrosPanel.Initialized = true
        local f = DetailsMacrosPanel or DF:CreateSimplePanel(UIParent, 700, 480, "Details! Useful Macros", "DetailsMacrosPanel")
        
        local scrollbox_line_backdrop_color = {0, 0, 0, 0.2}
        local scrollbox_line_backdrop_color_onenter = {.3, .3, .3, 0.5}
        local scrollbox_lines = 7
        local scrollbox_line_height = 79.5
        local scrollbox_size = {890, 563}
        
        f.bg1 = f:CreateTexture(nil, "background")
        f.bg1:SetTexture([[Interface\AddOns\Details\images\background]], true)
        f.bg1:SetAlpha(0.8)
        f.bg1:SetVertexColor(0.27, 0.27, 0.27)
        f.bg1:SetVertTile(true)
        f.bg1:SetHorizTile(true)
        f.bg1:SetSize(790, 454)
        f.bg1:SetAllPoints()
        f:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
        f:SetBackdropColor(.5, .5, .5, .7)
        f:SetBackdropBorderColor(0, 0, 0, 1)
        
        local macrosAvailable = Details.MacroList
    
        local OnEnterMacroButton = function(self)
            self:SetBackdropColor(unpack(scrollbox_line_backdrop_color_onenter))
        end
        
        local onLeaveMacroButton = function(self)
            self:SetBackdropColor(unpack(scrollbox_line_backdrop_color))
        end
        
        local updateMacroLine = function(self, index, title, desc, macroText)
            self.Title:SetText(title)
            self.Desc:SetText(desc)
            self.MacroTextEntry:SetText(macroText)
        end
        
        local textEntryOnFocusGained = function(self)
            self:HighlightText()
        end
        
        local textEntryOnFocusLost = function(self)
            self:HighlightText (0, 0)
        end

        local refreshMacroScrollbox = function(self, data, offset, totalLines)
            for i = 1, totalLines do
                local index = i + offset
                local macro = macrosAvailable [index]
                if (macro) then
                    local line = self:GetLine (i)
                    line:UpdateLine (index, macro.Name, macro.Desc, macro.MacroText)
                end
            end
        end
        
        local macroListCreateLine = function(self, index)
            --create a new line
            local line = CreateFrame("button", "$parentLine" .. index, self,"BackdropTemplate")
            
            --set its parameters
            line:SetPoint("topleft", self, "topleft", 0, -((index-1) * (scrollbox_line_height+1)))
            line:SetSize(scrollbox_size[1], scrollbox_line_height)
            line:SetScript("OnEnter", OnEnterMacroButton)
            line:SetScript("OnLeave", onLeaveMacroButton)
            line:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
            line:SetBackdropColor(unpack(scrollbox_line_backdrop_color))
            line:SetBackdropBorderColor(0, 0, 0, 0.3)
            
            local titleLabel = DF:CreateLabel(line, "", DF:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
            titleLabel.textsize = 14
            titleLabel.textcolor = "yellow"
            local descLabel = DF:CreateLabel(line, "", DF:GetTemplate("font", "ORANGE_FONT_TEMPLATE"))
            descLabel.textsize = 12
            
            local options_dropdown_template = DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
            options_dropdown_template = DF.table.copy({}, options_dropdown_template)
            options_dropdown_template.backdropcolor = {.51, .51, .51, .3}
            options_dropdown_template.onenterbordercolor = {.51, .51, .51, .2}
            
            local textEntry = DF:CreateTextEntry(line, function()end, scrollbox_size[1] - 10, 40, "MacroTextEntry", _, _, options_dropdown_template)
            textEntry:SetHook("OnEditFocusGained", textEntryOnFocusGained)
            textEntry:SetHook("OnEditFocusLost", textEntryOnFocusLost)
            textEntry:SetJustifyH("left")
            textEntry:SetTextInsets(8, 8, 0, 0)
            
            titleLabel:SetPoint("topleft", line, "topleft", 5, -5)
            descLabel:SetPoint("topleft", titleLabel, "bottomleft", 0, -2)
            textEntry:SetPoint("topleft", descLabel, "bottomleft", 0, -4)
            
            line.Title = titleLabel
            line.Desc = descLabel
            line.MacroTextEntry = textEntry
        
            line.UpdateLine = updateMacroLine
            line:Hide()
            
            return line
        end
        
        local macroScrollbox = DF:CreateScrollBox (f, "$parentMacroScrollbox", refreshMacroScrollbox, macrosAvailable, scrollbox_size[1], scrollbox_size[2], scrollbox_lines, scrollbox_line_height)
        macroScrollbox:SetPoint("topleft", f, "topleft", 5, -30)
        macroScrollbox:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
        macroScrollbox:SetBackdropColor(0, 0, 0, 0)
        macroScrollbox:SetBackdropBorderColor(0, 0, 0, 1)
        f.MacroScrollbox = macroScrollbox
        DF:ReskinSlider(macroScrollbox)
        
        macroScrollbox.__background:Hide()
        
        --create the scrollbox lines
        for i = 1, scrollbox_lines do 
            macroScrollbox:CreateLine (macroListCreateLine)
        end
    end
    
    DetailsPluginContainerWindow.OpenPlugin (DetailsMacrosPanel)
    DetailsMacrosPanel.MacroScrollbox:Refresh()
    DetailsMacrosPanel:Show()
end
