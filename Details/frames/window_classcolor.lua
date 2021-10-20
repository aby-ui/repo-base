

local Details = _G.Details
local DF = _G.DetailsFramework
local Loc = _G.LibStub("AceLocale-3.0"):GetLocale("Details")

--> config class colors
function Details:OpenClassColorsConfig()
    if (not _G.DetailsClassColorManager) then
        DF:CreateSimplePanel (UIParent, 300, 425, Loc ["STRING_OPTIONS_CLASSCOLOR_MODIFY"], "DetailsClassColorManager")
        local panel = _G.DetailsClassColorManager
        
        DF:ApplyStandardBackdrop (panel)
        
        local upper_panel = CreateFrame ("frame", nil, panel,"BackdropTemplate")
        upper_panel:SetAllPoints (panel)
        upper_panel:SetFrameLevel (panel:GetFrameLevel()+3)
        
        local y = -50
        
        local callback = function (button, r, g, b, a, self)
            self.MyObject.my_texture:SetVertexColor (r, g, b)
            Details.class_colors [self.MyObject.my_class][1] = r
            Details.class_colors [self.MyObject.my_class][2] = g
            Details.class_colors [self.MyObject.my_class][3] = b
            Details:RefreshMainWindow (-1, true)
        end

        local set_color = function (self, button, class, index)
            local current_class_color = Details.class_colors [class]
            local r, g, b = unpack (current_class_color)
            DF:ColorPick (self, r, g, b, 1, callback)
        end

        local reset_color = function (self, button, class, index)
            local color_table = RAID_CLASS_COLORS [class]
            local r, g, b = color_table.r, color_table.g, color_table.b
            self.MyObject.my_texture:SetVertexColor (r, g, b)
            Details.class_colors [self.MyObject.my_class][1] = r
            Details.class_colors [self.MyObject.my_class][2] = g
            Details.class_colors [self.MyObject.my_class][3] = b
            Details:RefreshMainWindow (-1, true)
        end

        local on_enter = function (self, capsule)
            --Details:CooltipPreset (1)
            --GameCooltip:AddLine ("right click to reset")
            --GameCooltip:Show (self)
        end
        local on_leave = function (self, capsule)
            --GameCooltip:Hide()
        end
        
        local reset = DF:NewLabel (panel, panel, nil, nil, "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:" .. 20 .. ":" .. 20 .. ":0:1:512:512:8:70:328:409|t " .. Loc ["STRING_OPTIONS_CLASSCOLOR_RESET"])
        reset:SetPoint ("bottomright", panel, "bottomright", -23, 08)
        local reset_texture = DF:CreateImage (panel, [[Interface\MONEYFRAME\UI-MONEYFRAME-BORDER]], 138, 45, "border")
        reset_texture:SetPoint ("center", reset, "center", 0, -7)
        reset_texture:SetDesaturated (true)
        
        panel.buttons = {}
        
        for index, class_name in ipairs (CLASS_SORT_ORDER) do
            
            local icon = DF:CreateImage (upper_panel, [[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]], 32, 32, nil, CLASS_ICON_TCOORDS [class_name], "icon_" .. class_name)
            
            if (index%2 ~= 0) then
                icon:SetPoint (10, y)
            else
                icon:SetPoint (150, y)
                y = y - 33
            end
            
            local bg_texture = DF:CreateImage (panel, [[Interface\AddOns\Details\images\bar_skyline]], 135, 30, "artwork")
            bg_texture:SetPoint ("left", icon, "right", -32, 0)
            
            local button = DF:CreateButton (panel, set_color, 135, 30, "set color", class_name, index)
            button:SetPoint ("left", icon, "right", -32, 0)
            button:InstallCustomTexture (nil, nil, nil, nil, true)
            button:SetFrameLevel (panel:GetFrameLevel()+1)
            button.my_icon = icon
            button.my_texture = bg_texture
            button.my_class = class_name
            button:SetHook ("OnEnter", on_enter)
            button:SetHook ("OnLeave", on_leave)
            button:SetClickFunction (reset_color, nil, nil, "RightClick")
            panel.buttons [class_name] = button
        end

        --make color options for death log bars
        local function hex (num)
            local hexstr = '0123456789abcdef'
            local s = ''
            while num > 0 do
                local mod = math.fmod(num, 16)
                s = string.sub(hexstr, mod+1, mod+1) .. s
                num = math.floor(num / 16)
            end
            if s == '' then s = '00' end
            if (string.len (s) == 1) then
                s = "0"..s
            end
            return s
        end

        local function sort_color (t1, t2)
            return t1[1][3] > t2[1][3]
        end

        local colorSelected = function(self, fixParam, value)
            local colorName, barType = value:match("^(%w+)@(%w+)")
            Details.death_log_colors[barType] = colorName
        end

        local buildColorList = function(barType)
            --all colors
            local allColors = {}
            for colorName, colorTable in pairs(DF:GetDefaultColorList()) do
                tinsert(allColors, {colorTable, colorName, hex(colorTable[1]*255) .. hex(colorTable[2]*255) .. hex(colorTable[3]*255)})
            end
            table.sort(allColors, sort_color)
            
            local result = {}
            for index, colorTable in ipairs(allColors) do
                local colortable = colorTable[1]
                local colorname = colorTable[2]
                local value = colorname .. "@" .. barType
                tinsert (result, {label = colorname, value = value, color = colortable, onclick = colorSelected})
            end

            return result
        end

        local deathLogOptions = {
            {--damage
                type = "select",
                get = function() return Details.death_log_colors.damage end,
                values = function()
                    return buildColorList("damage")
                end,
                name = "Damage",
                desc = "Damage",
            },
            {--heal
                type = "select",
                get = function() return Details.death_log_colors.heal end,
                values = function()
                    return buildColorList("heal")
                end,
                name = "Heal",
                desc = "Heal",
            },
            {--friendlyfire
                type = "select",
                get = function() return Details.death_log_colors.friendlyfire end,
                values = function()
                    return buildColorList("friendlyfire")
                end,
                name = "Friendly Fire",
                desc = "Friendly Fire",
            },
            {--cooldown
                type = "select",
                get = function() return Details.death_log_colors.cooldown end,
                values = function()
                    return buildColorList("cooldown")
                end,
                name = "Cooldown",
                desc = "Cooldown",
            },
            {--debuff
                type = "select",
                get = function() return Details.death_log_colors.debuff end,
                values = function()
                    return buildColorList("debuff")
                end,
                name = "Debuff",
                desc = "Debuff",
            },
        }
        DetailsFramework:BuildMenu(panel, deathLogOptions, 5, -285, 700, true)

        local deathLogColorsLabel = DF:CreateLabel(panel, "Colors on Death Log:", 12, "yellow")
        deathLogColorsLabel:SetPoint("topleft", panel, "topleft", 5, -265)
    end
    
    for class, button in pairs (_G.DetailsClassColorManager.buttons) do
        button.my_texture:SetVertexColor (unpack (Details.class_colors [class]))
    end
    
    _G.DetailsClassColorManager:Show()
end
