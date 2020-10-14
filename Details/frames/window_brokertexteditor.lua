

local Details = _G.Details
local DF = _G.DetailsFramework
local Loc = LibStub("AceLocale-3.0"):GetLocale("Details")
local tabIndex = 11

function Details:OpenBrokerTextEditor()
    
    if (not DetailsWindowOptionsBrokerTextEditor) then

        local panel = Details:CreateWelcomePanel("DetailsWindowOptionsBrokerTextEditor", nil, 870, 300, true)
        panel:SetPoint("center", UIParent, "center")
        panel:Hide()
        panel:SetFrameStrata("FULLSCREEN")
        DF:ApplyStandardBackdrop(panel)

        local titleBar = DF:CreateTitleBar (panel, "Broker Text Editor")
    
        local textentry = DF:NewSpecialLuaEditorEntry (panel, 650, 270, "editbox", "$parentEntry", true)
        textentry:SetPoint ("topleft", panel, "topleft", 2, -25)

        DF:ApplyStandardBackdrop(textentry)
        DF:ReskinSlider(textentry.scroll)
        
        textentry.editbox:SetScript ("OnTextChanged", function()
            local text = panel.editbox:GetText()
            Details.data_broker_text = text
            Details:BrokerTick()
            if (_G.DetailsOptionsWindow)  then
                local dataBrokerString = _G["DetailsOptionsWindowTab" .. tabIndex].widget_list_by_type.textentry[1]
                dataBrokerString:SetText (Details.data_broker_text)
            end
        end)
        
        local option_selected = 1
        local onclick= function (_, _, value)
            option_selected = value
        end
        local AddOptions = {
            {label = Loc ["STRING_OPTIONS_DATABROKER_TEXT_ADD1"], value = 1, onclick = onclick},
            {label = Loc ["STRING_OPTIONS_DATABROKER_TEXT_ADD2"], value = 2, onclick = onclick},
            {label = Loc ["STRING_OPTIONS_DATABROKER_TEXT_ADD3"], value = 3, onclick = onclick},
            {label = Loc ["STRING_OPTIONS_DATABROKER_TEXT_ADD4"], value = 4, onclick = onclick},
            
            {label = Loc ["STRING_OPTIONS_DATABROKER_TEXT_ADD5"], value = 5, onclick = onclick},
            {label = Loc ["STRING_OPTIONS_DATABROKER_TEXT_ADD6"], value = 6, onclick = onclick},
            {label = Loc ["STRING_OPTIONS_DATABROKER_TEXT_ADD7"], value = 7, onclick = onclick},
            {label = Loc ["STRING_OPTIONS_DATABROKER_TEXT_ADD8"], value = 8, onclick = onclick},
            
            {label = Loc ["STRING_OPTIONS_DATABROKER_TEXT_ADD9"], value = 9, onclick = onclick},
        }
        local buildAddMenu = function()
            return AddOptions
        end
        
        local d = DF:NewDropDown (panel, _, "$parentTextOptionsDropdown", "TextOptionsDropdown", 150, 20, buildAddMenu, 1)
        d:SetPoint ("topright", panel, "topright", -12, -25)
        d:SetTemplate(DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        local optiontable = {"{dmg}", "{dps}", "{dpos}", "{ddiff}", "{heal}", "{hps}", "{hpos}", "{hdiff}", "{time}"}
    
        local add_button = DF:NewButton (panel, nil, "$parentAddButton", nil, 20, 20, function() 
            textentry.editbox:Insert (optiontable [option_selected])
        end,
        nil, nil, nil, "<-")
        add_button:SetPoint ("right", d, "left", -2, 0)
        add_button:SetTemplate(DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
        
        
        -- code author Saiket from  http://www.wowinterface.com/forums/showpost.php?p=245759&postcount=6
        --- @return StartPos, EndPos of highlight in this editbox.
        local function GetTextHighlight ( self )
            local Text, Cursor = self:GetText(), self:GetCursorPosition();
            self:Insert( "" ); -- Delete selected text
            local TextNew, CursorNew = self:GetText(), self:GetCursorPosition();
            -- Restore previous text
            self:SetText( Text );
            self:SetCursorPosition( Cursor );
            local Start, End = CursorNew, #Text - ( #TextNew - CursorNew );
            self:HighlightText( Start, End );
            return Start, End;
        end
            
        local StripColors;
        do
            local CursorPosition, CursorDelta;
            --- Callback for gsub to remove unescaped codes.
            local function StripCodeGsub ( Escapes, Code, End )
                if ( #Escapes % 2 == 0 ) then -- Doesn't escape Code
                    if ( CursorPosition and CursorPosition >= End - 1 ) then
                        CursorDelta = CursorDelta - #Code;
                    end
                    return Escapes;
                end
            end
            --- Removes a single escape sequence.
            local function StripCode ( Pattern, Text, OldCursor )
                CursorPosition, CursorDelta = OldCursor, 0;
                return Text:gsub( Pattern, StripCodeGsub ), OldCursor and CursorPosition + CursorDelta;
            end
            --- Strips Text of all color escape sequences.
            -- @param Cursor  Optional cursor position to keep track of.
            -- @return Stripped text, and the updated cursor position if Cursor was given.
            function StripColors ( Text, Cursor )
                Text, Cursor = StripCode( "(|*)(|c%x%x%x%x%x%x%x%x)()", Text, Cursor );
                return StripCode( "(|*)(|r)()", Text, Cursor );
            end
        end
        
        local COLOR_END = "|r";
        --- Wraps this editbox's selected text with the given color.
        local function ColorSelection ( self, ColorCode )
            local Start, End = GetTextHighlight( self );
            local Text, Cursor = self:GetText(), self:GetCursorPosition();
            if ( Start == End ) then -- Nothing selected
                --Start, End = Cursor, Cursor; -- Wrap around cursor
                return; -- Wrapping the cursor in a color code and hitting backspace crashes the client!
            end
            -- Find active color code at the end of the selection
            local ActiveColor;
            if ( End < #Text ) then -- There is text to color after the selection
                local ActiveEnd;
                local CodeEnd, _, Escapes, Color = 0;
                while ( true ) do
                    _, CodeEnd, Escapes, Color = Text:find( "(|*)(|c%x%x%x%x%x%x%x%x)", CodeEnd + 1 );
                    if ( not CodeEnd or CodeEnd > End ) then
                        break;
                    end
                    if ( #Escapes % 2 == 0 ) then -- Doesn't escape Code
                        ActiveColor, ActiveEnd = Color, CodeEnd;
                    end
                end
            
                if ( ActiveColor ) then
                    -- Check if color gets terminated before selection ends
                    CodeEnd = 0;
                    while ( true ) do
                        _, CodeEnd, Escapes = Text:find( "(|*)|r", CodeEnd + 1 );
                        if ( not CodeEnd or CodeEnd > End ) then
                            break;
                        end
                        if ( CodeEnd > ActiveEnd and #Escapes % 2 == 0 ) then -- Terminates ActiveColor
                            ActiveColor = nil;
                            break;
                        end
                    end
                end
            end
            
            local Selection = Text:sub( Start + 1, End );
            -- Remove color codes from the selection
            local Replacement, CursorReplacement = StripColors( Selection, Cursor - Start );
            
            self:SetText( ( "" ):join(
                Text:sub( 1, Start ),
                ColorCode, Replacement, COLOR_END,
                ActiveColor or "", Text:sub( End + 1 )
            ) );
            
            -- Restore cursor and highlight, adjusting for wrapper text
            Cursor = Start + CursorReplacement;
            if ( CursorReplacement > 0 ) then -- Cursor beyond start of color code
                Cursor = Cursor + #ColorCode;
            end
            if ( CursorReplacement >= #Replacement ) then -- Cursor beyond end of color
                Cursor = Cursor + #COLOR_END;
            end
            
            self:SetCursorPosition( Cursor );
            -- Highlight selection and wrapper
            self:HighlightText( Start, #ColorCode + ( #Replacement - #Selection ) + #COLOR_END + End );
        end
        
        local color_func = function (_, r, g, b, a)
            local hex = Details:hex (a*255)..Details:hex (r*255)..Details:hex (g*255)..Details:hex (b*255)
            ColorSelection ( textentry.editbox, "|c" .. hex)
        end
        
        local color_button = DF:NewColorPickButton (panel, "$parentButton5", nil, color_func)
        color_button:SetSize (80, 20)
        color_button:SetPoint ("topright", panel, "topright", -12, -102)
        color_button.tooltip = Loc ["STRING_OPTIONS_TEXTEDITOR_COLOR_TOOLTIP"]
        color_button:SetTemplate(DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
    
        local done = function()
            local text = panel.editbox:GetText()
            Details.data_broker_text = text
            if (_G.DetailsOptionsWindow)  then
                local dataBrokerString = _G["DetailsOptionsWindowTab" .. tabIndex].widget_list_by_type.textentry[1]
                dataBrokerString:SetText (Details.data_broker_text)
            end
            Details:BrokerTick()
            panel:Hide()
        end
        
        local ok_button = DF:NewButton (panel, nil, "$parentButtonOk", nil, 80, 20, done, nil, nil, nil, Loc ["STRING_OPTIONS_TEXTEDITOR_DONE"], 1)
        ok_button.tooltip = Loc ["STRING_OPTIONS_TEXTEDITOR_DONE_TOOLTIP"]
        ok_button:SetPoint ("topright", panel, "topright", -12, -174)
        ok_button:SetTemplate(DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))

        local reset_button = DF:NewButton (panel, nil, "$parentDefaultOk", nil, 80, 20, function() textentry.editbox:SetText ("") end, nil, nil, nil, "Reset", 1)
        reset_button.tooltip = Loc ["STRING_OPTIONS_TEXTEDITOR_RESET_TOOLTIP"]
        reset_button:SetPoint ("topright", panel, "topright", -100, -152)
        reset_button:SetTemplate(DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))

        local cancel_button = DF:NewButton (panel, nil, "$parentDefaultCancel", nil, 80, 20, function() textentry.editbox:SetText (panel.default_text); done(); end, nil, nil, nil, Loc ["STRING_OPTIONS_TEXTEDITOR_CANCEL"], 1)
        cancel_button.tooltip = Loc ["STRING_OPTIONS_TEXTEDITOR_CANCEL_TOOLTIP"]
        cancel_button:SetPoint ("topright", panel, "topright", -100, -174)
        cancel_button:SetTemplate(DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
    
    end
    
    local panel = DetailsWindowOptionsBrokerTextEditor
    
    local text = Details.data_broker_text:gsub ("||", "|")
    panel.default_text = text
    panel.editbox:SetText (text)
    
    panel:Show()
end