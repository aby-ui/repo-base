
if (true) then
    return
end

local Details = _G.Details
local DF = _G.DetailsFramework
local libwindow = LibStub("LibWindow-1.1")

--> this function isn't in use
    function Details.OpenDpsBenchmark()
	
        --main frame
            
            local DF = _detalhes.gump
            local _ = nil
            
            --declaration
            local f = CreateFrame ("frame", "DetailsBenchmark", UIParent,"BackdropTemplate")
            f:SetSize (800, 600)
            f:SetPoint ("left", UIParent, "left")
            f:SetFrameStrata ("LOW")
            f:EnableMouse (true)
            f:SetMovable (true)
            f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
            f:SetBackdropColor (0, 0, 0, 0.9)
            f:SetBackdropBorderColor (0, 0, 0, 1)
            
            --register to libwindow
            local LibWindow = LibStub ("LibWindow-1.1")
            LibWindow.RegisterConfig (f, _detalhes.benchmark_db.frame)
            LibWindow.RestorePosition (f)
            LibWindow.MakeDraggable (f)
            LibWindow.SavePosition (f)
            
            --titlebar
            f.TitleBar = CreateFrame ("frame", "$parentTitleBar", f,"BackdropTemplate")
            f.TitleBar:SetPoint ("topleft", f, "topleft", 2, -3)
            f.TitleBar:SetPoint ("topright", f, "topright", -2, -3)
            f.TitleBar:SetHeight (20)
            f.TitleBar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
            f.TitleBar:SetBackdropColor (.2, .2, .2, 1)
            f.TitleBar:SetBackdropBorderColor (0, 0, 0, 1)
            
            --close button
            f.Close = CreateFrame ("button", "$parentCloseButton", f,"BackdropTemplate")
            f.Close:SetPoint ("right", f.TitleBar, "right", -2, 0)
            f.Close:SetSize (16, 16)
            f.Close:SetNormalTexture (_detalhes.gump.folder .. "icons")
            f.Close:SetHighlightTexture (_detalhes.gump.folder .. "icons")
            f.Close:SetPushedTexture (_detalhes.gump.folder .. "icons")
            f.Close:GetNormalTexture():SetTexCoord (0, 16/128, 0, 1)
            f.Close:GetHighlightTexture():SetTexCoord (0, 16/128, 0, 1)
            f.Close:GetPushedTexture():SetTexCoord (0, 16/128, 0, 1)
            f.Close:SetAlpha (0.7)
            f.Close:SetScript ("OnClick", function() f:Hide() end)
            
            --title
            f.Title = f.TitleBar:CreateFontString ("$parentTitle", "overlay", "GameFontNormal")
            f.Title:SetPoint ("center", f.TitleBar, "center")
            f.Title:SetTextColor (.8, .8, .8, 1)
            f.Title:SetText ("Details! Benchmark")
            
            DF:InstallTemplate ("font", "DETAILS_BENCHMARK_NORMAL", {color = "white", size = 10, font = "Friz Quadrata TT"})
            
            function f.CreateCombatObject()
                local t = {}
                
                return t
            end
            
            function f.StartNewBenchmark()
                
            end
            
            function f.StopCurrentBenchmark()
                
            end
            
            
            f.OnTickInterval = 0
            function f.UpdateOnTick (self, deltaTime)
                f.OnTickInterval = f.OnTickInterval + deltaTime
                if (f.OnTickInterval >= 0.024) then
                    --do the update
                    
                    --reset the interval
                    f.OnTickInterval = 0
                end
            end
            function f.StartUpdateOnTick()
                f:SetScript ("OnUpdate", f.UpdateOnTick)
            end
            
            --events
            f:RegisterEvent ("PLAYER_REGEN_DISABLED")
            f:RegisterEvent ("PLAYER_REGEN_ENABLED")
            
            f:SetScript ("OnEvent", function (self, event, ...)
                if (event == "PLAYER_REGEN_DISABLED") then
                    f.StartNewBenchmark()
                    
                elseif (event == "PLAYER_REGEN_ENABLED") then
                    f.StopCurrentBenchmark()
                    
                end
            end)
            
            local normal_text_template = DF:GetTemplate ("font", "DETAILS_BENCHMARK_NORMAL")
            local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
            local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
            local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
            local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
            
        --locations
            f.FrameLocations = {
                summary = {10, -30},
                auras = {10, -120},
                spells = {10, -180},
                history = {10, -280},
            }
            f.FrameSizes = {
                default = {300, 200},
            }
            
        --summary block
        
            --declaration
                local summaryFrame = CreateFrame ("frame", "$parentSummaryFrame", f,"BackdropTemplate")
                summaryFrame:SetPoint ("topleft", f, "topleft", unpack (f.FrameLocations.summary))
                summaryFrame:SetSize (unpack (f.FrameSizes.default))
                summaryFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
                summaryFrame:SetBackdropColor (0, 0, 0, 0.9)
                summaryFrame:SetBackdropBorderColor (0, 0, 0, 1)
                
            --time to test string and dropdown
                local build_time_list = function()
                    local t = {
                        {value = 40, label = "40 seconds"},
                        {value = 60, label = "60 seconds"},
                        {value = 90, label = "90 seconds"},
                        {value = 120, label = "2 minutes"},
                        {value = 180, label = "3 minutes"},
                        {value = 300, label = "5 minutes"},
                    }
                    return t
                end
                
                summaryFrame.TimeToTestLabel = DF:CreateLabel (summaryFrame, "Amount of Time", normal_text_template)
                summaryFrame.TimeToTestDropdown = DF:CreateDropDown (summaryFrame, build_time_list, default, 150, 20, _, _, options_dropdown_template)
                
            --description string and text entry
                summaryFrame.DescriptionLabel = DF:CreateLabel (summaryFrame, "Description", normal_text_template)
                summaryFrame.DescriptionEntry = DF:CreateTextEntry (summaryFrame, function()end, 120, 20, nil, _, nil, options_dropdown_template)
                
            --DPS Amount string
                summaryFrame.DPSLabel = DF:CreateLabel (summaryFrame, "100K", normal_text_template)
                
            --TIME ELAPSED string
                summaryFrame.TimeElapsedLabel = DF:CreateLabel (summaryFrame, "01:00", normal_text_template)
            
            --boss simulation string and dropdown
                local build_bosssimulation_list, default = function()
                    local t = {
                        {value = "patchwerk", label = "Patchwerk"},
                    }
                    return t
                end
                summaryFrame.BossSimulationLabel = DF:CreateLabel (summaryFrame, "Boss Simulation", normal_text_template)
                summaryFrame.BossSimulationDropdown = DF:CreateDropDown (summaryFrame, build_bosssimulation_list, default, 150, 20, _, _, options_dropdown_template)
                
            --boss records line with a tooltip importing data from the storage
                summaryFrame.BossRecordsFrame = CreateFrame ("frame", nil, summaryFrame,"BackdropTemplate")
                summaryFrame.BossRecordsFrame:SetSize (f.FrameSizes.default[1]-20, 20)
                summaryFrame.BossRecordsFrame:SetBackdropColor (0, 0, 0, 0.3)
                summaryFrame.BossRecordsFrame:SetScript ("OnEnter", function()
                    
                end)
                summaryFrame.BossRecordsFrame:SetScript ("OnLeave", function()
                
                end)
                
            --set the points
                do
                    local x, y = 10, -10
                    summaryFrame.TimeToTestLabel:SetPoint ("topleft", summaryFrame, "topleft", x, y)
                    summaryFrame.TimeToTestDropdown:SetPoint ("topleft", summaryFrame.TimeToTestLabel, "bottomleft", 0, -2)
                    
                    --y = y - 40
                    summaryFrame.DescriptionLabel:SetPoint ("topleft", summaryFrame, "topleft", x+160, y)
                    summaryFrame.DescriptionEntry:SetPoint ("topleft", summaryFrame.DescriptionLabel, "bottomleft", 0, -2)
                    
                    y = y - 40
                    summaryFrame.DPSLabel:SetPoint ("topleft", summaryFrame, "topleft", x, y)
                    summaryFrame.TimeElapsedLabel:SetPoint ("topleft", summaryFrame, "topleft", x + 100, y)
                    
                    y = y - 40
                    summaryFrame.BossSimulationLabel:SetPoint ("topleft", summaryFrame, "topleft", x, y)
                    summaryFrame.BossSimulationDropdown:SetPoint ("topleft", summaryFrame.BossSimulationLabel, "bottomleft", 0, -2)
                    
                    y = y - 40
                    summaryFrame.BossRecordsFrame:SetPoint ("topleft", summaryFrame, "topleft", 0, 0)
                end
                
                
                
                
        --spells block
            
            --declaration
                local spellsFrame = CreateFrame ("frame", "$parentSpellsFrame", f,"BackdropTemplate")
                spellsFrame:SetPoint ("topleft", f, "topleft", unpack (f.FrameLocations.spells))
                spellsFrame:SetSize (unpack (f.FrameSizes.default))
                spellsFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
                spellsFrame:SetBackdropColor (0, 0, 0, 0.9)
                spellsFrame:SetBackdropBorderColor (0, 0, 0, 1)
                
            --header with the string titles:
                --Spell Icon | DPS | Damage | Casts | Criticals | Highest Damage
                
            --scrollpanel 
                --each line with:
                    --Texture for the icon
                    --5 strings for the data
                    --hover over scripts
            
        --auras block
            
            --declaration
                local aurasFrame = CreateFrame ("frame", "$parentAurasFrame", f,"BackdropTemplate")
                aurasFrame:SetPoint ("topleft", f, "topleft", unpack (f.FrameLocations.auras))
                aurasFrame:SetSize (unpack (f.FrameSizes.default))
                aurasFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
                aurasFrame:SetBackdropColor (0, 0, 0, 0.9)
                aurasFrame:SetBackdropBorderColor (0, 0, 0, 1)
            
            --will be 9 blocks? 
            
            --each block with:
                --Texture for the icon
                --3 strings for Total Update, Applications and Refreshes
                
                
        --history block
                
            --declaration
                local historyFrame = CreateFrame ("frame", "$parentHistoryFrame", f,"BackdropTemplate")
                historyFrame:SetPoint ("topleft", f, "topleft", unpack (f.FrameLocations.history))
                historyFrame:SetSize (unpack (f.FrameSizes.default))
                historyFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
                historyFrame:SetBackdropColor (0, 0, 0, 0.9)
                historyFrame:SetBackdropBorderColor (0, 0, 0, 1)
                
            --header with the string titles:
                --Spec | ILevel | DPS | Time | Talents | Crit | Haste | Versatility | Mastery | Int | Description
                
            --scrollpanel 
                --each line with:
                    --7 Textures for talent icons
                    --10 strings for the data
                    --hover over scripts
        
        
        
        --mechanics
        
        --to open the window
            --on target a training dummy
            --need to be on a specific map / sanctuary
        
        --on start a new combat:
            --start the timer
            --start the boss script if not patchwerk
            --create the graphic tables for *player total damage and *spell damage
            --create aura tables / grab auras already applied to the player / auras with no duration wont be added
    
        --on tick: 
            --*check if the time is gone *update the time string *update the graphic *update the spells *upate the auras
            
            
        --on finishes:
            --stop the timer and check if the elapsed time is done
            --create a new benchmark object to store the test
            --export the data to this new object
            --add this new object to the benchmark storage table
            --update the history scrollbar
            
        
    end