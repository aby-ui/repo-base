local addonName, Data = ...

Data.defaultSettings = {
    profile = {
    
        Font = "PT Sans Narrow Bold",
        
        Locked = false,
        Debug = false,
        
        DisableArenaFrames = false,
        
        MyTarget_Color = {1, 1, 1, 1},
        MyFocus_Color = {0, 0.988235294117647, 0.729411764705882, 1},
        Highlight_Color = {1, 1, 0.5, 1},
    
        Enemies = {
            Enabled = true,
            
            ShowRealmnames = true,
            ConvertCyrillic = true,
            LevelText_Enabled = false,
            LevelText_OnlyShowIfNotMaxLevel = true,
            LevelText_Fontsize = 18,
            LevelText_Outline = "",
            LevelText_Textcolor = {1, 1, 1, 1},
            LevelText_EnableTextshadow = false,
            LevelText_TextShadowcolor = {0, 0, 0, 1},
            
            RangeIndicator_Enabled = true,
            RangeIndicator_Range = 28767,
            RangeIndicator_Alpha = 0.55,
            RangeIndicator_Everything = false,
            RangeIndicator_Frames = {},
                
            LeftButtonType = "Target",
            LeftButtonValue = "",
            RightButtonType = "Focus",
            RightButtonValue = "",
            MiddleButtonType = "Custom",
            MiddleButtonValue = "",
            
            ["15"] = {
                Enabled = true,
            
                Name_Fontsize = 13,
                Name_Outline = "",
                Name_Textcolor = {1, 1, 1, 1}, 
                Name_EnableTextshadow = true,
                Name_TextShadowcolor = {0, 0, 0, 1},
                
                Position_X = false,
                Position_Y = false,
                BarWidth = 220,
                BarHeight = 28,
                BarVerticalGrowdirection = "downwards",
                BarVerticalSpacing = 1,
                BarColumns = 1,
                BarHorizontalGrowdirection = "rightwards",
                BarHorizontalSpacing = 100,
                
                HealthBar_Texture = 'UI-StatusBar',
                HealthBar_Background = {0, 0, 0, 0.66},
                
                PowerBar_Enabled = false,
                PowerBar_Height = 4,
                PowerBar_Texture = 'UI-StatusBar',
                PowerBar_Background = {0, 0, 0, 0.66},
                

                RoleIcon_Enabled = true,
                RoleIcon_Size = 13,
                RoleIcon_VerticalPosition = 2,
                
                PlayerCount_Enabled = true,
                PlayerCount_Fontsize = 14,
                PlayerCount_Outline = "OUTLINE",
                PlayerCount_Textcolor = {1, 1, 1, 1},
                PlayerCount_EnableTextshadow = false,
                PlayerCount_TextShadowcolor = {0, 0, 0, 1},
                
                Framescale = 1,
                
                Spec_Enabled = true,
                Spec_Width = 36,
                
                Spec_AuraDisplay_Enabled = true,
                Spec_AuraDisplay_ShowNumbers = true,
                
                Spec_AuraDisplay_Cooldown_Fontsize = 12,
                Spec_AuraDisplay_Cooldown_Outline = "OUTLINE",
                Spec_AuraDisplay_Cooldown_EnableTextshadow = false,
                Spec_AuraDisplay_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                
                SymbolicTargetindicator_Enabled = true,
                
                NumericTargetindicator_Enabled = true,
                NumericTargetindicator_Fontsize = 18,
                NumericTargetindicator_Outline = "",
                NumericTargetindicator_Textcolor = {1, 1, 1, 1},
                NumericTargetindicator_EnableTextshadow = false,
                NumericTargetindicator_TextShadowcolor = {0, 0, 0, 1},
                
                DrTracking_Enabled = true,
                DrTracking_HorizontalSpacing = 1,
                DrTracking_GrowDirection = "leftwards",
                DrTracking_Container_Color = {0, 0, 1, 1},
                DrTracking_Container_BorderThickness = 1,
                DrTracking_Container_BasicPoint = "RIGHT",
                DrTracking_Container_RelativeTo = "Button",
                DrTracking_Container_RelativePoint = "LEFT",
                DrTracking_Container_OffsetX = 1,
                DrTracking_DisplayType = "Countdowntext",
                
                DrTracking_ShowNumbers = true,
                
                DrTracking_Cooldown_Fontsize = 12,
                DrTracking_Cooldown_Outline = "OUTLINE",
                DrTracking_Cooldown_EnableTextshadow = false,
                DrTracking_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                DrTrackingFiltering_Enabled = false,
                DrTrackingFiltering_Filterlist = {},
                
                
                Auras_Enabled = true,
                Auras_ShowTooltips = false,
                
                Auras_Buffs_Enabled = false,
                Auras_Buffs_Size = 15,
                Auras_Buffs_HorizontalGrowDirection = "leftwards",
                Auras_Buffs_HorizontalSpacing = 1,
                Auras_Buffs_VerticalGrowdirection = "upwards",
                Auras_Buffs_VerticalSpacing = 1,
                Auras_Buffs_IconsPerRow = 8,
                Auras_Buffs_Container_Point = "BOTTOMRIGHT",
                Auras_Buffs_Container_RelativeTo = "Button",
                Auras_Buffs_Container_RelativePoint = "BOTTOMLEFT",
                Auras_Buffs_Container_OffsetX = 2,
                Auras_Buffs_Container_OffsetY = 0,
                
                Auras_Buffs_Fontsize = 12,
                Auras_Buffs_Outline = "OUTLINE",
                Auras_Buffs_Textcolor = {1, 1, 1, 1},
                Auras_Buffs_EnableTextshadow = true,
                Auras_Buffs_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Buffs_ShowNumbers = true,
                
                Auras_Buffs_Cooldown_Fontsize = 12,
                Auras_Buffs_Cooldown_Outline = "OUTLINE",
                Auras_Buffs_Cooldown_EnableTextshadow = false,
                Auras_Buffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Buffs_Filtering_Enabled = true,
                Auras_Buffs_OnlyShowMine = true,
                Auras_Buffs_SpellIDFiltering_Enabled = false,
                Auras_Buffs_SpellIDFiltering_Filterlist = {},
                
                Auras_Debuffs_Enabled = true,
                Auras_Debuffs_Size = 27,
                Auras_Debuffs_HorizontalGrowDirection = "leftwards",
                Auras_Debuffs_HorizontalSpacing = 1,
                Auras_Debuffs_VerticalGrowdirection = "upwards",
                Auras_Debuffs_VerticalSpacing = 1,
                Auras_Debuffs_IconsPerRow = 8,
                Auras_Debuffs_Container_Point = "RIGHT",
                Auras_Debuffs_Container_RelativeTo = "DRContainer",
                Auras_Debuffs_Container_RelativePoint = "LEFT",
                Auras_Debuffs_Container_OffsetX = 2,
                Auras_Debuffs_Container_OffsetY = 0,
                
                Auras_Debuffs_Coloring_Enabled = true,
                Auras_Debuffs_DisplayType = "Frame",
                Auras_Debuffs_Fontsize = 12,
                Auras_Debuffs_Outline = "OUTLINE",
                Auras_Debuffs_Textcolor = {1, 1, 1, 1},
                Auras_Debuffs_EnableTextshadow = true,
                Auras_Debuffs_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Debuffs_ShowNumbers = true,
                
                Auras_Debuffs_Cooldown_Fontsize = 12,
                Auras_Debuffs_Cooldown_Outline = "OUTLINE",
                Auras_Debuffs_Cooldown_EnableTextshadow = false,
                Auras_Debuffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Debuffs_Filtering_Enabled = true,
                Auras_Debuffs_OnlyShowMine = true,
                Auras_Debuffs_DebuffTypeFiltering_Enabled = false,
                Auras_Debuffs_DebuffTypeFiltering_Filterlist = {},
                Auras_Debuffs_SpellIDFiltering_Enabled = false,
                Auras_Debuffs_SpellIDFiltering_Filterlist = {},

                ObjectiveAndRespawn_ObjectiveEnabled = true,
                ObjectiveAndRespawn_Width = 36,
                ObjectiveAndRespawn_BasicPoint = "RIGHT",
                ObjectiveAndRespawn_RelativeTo = "NumericTargetindicator",
                ObjectiveAndRespawn_RelativePoint = "LEFT",
                ObjectiveAndRespawn_OffsetX = -2,
                
                ObjectiveAndRespawn_RespawnEnabled = true,
                
                ObjectiveAndRespawn_Fontsize = 17,
                ObjectiveAndRespawn_Outline = "THICKOUTLINE",
                ObjectiveAndRespawn_Textcolor = {1, 1, 1, 1},
                ObjectiveAndRespawn_EnableTextshadow = false,
                ObjectiveAndRespawn_TextShadowcolor = {0, 0, 0, 1},
                
                ObjectiveAndRespawn_ShowNumbers = true,
                
                ObjectiveAndRespawn_Cooldown_Fontsize = 12,
                ObjectiveAndRespawn_Cooldown_Outline = "OUTLINE",
                ObjectiveAndRespawn_Cooldown_EnableTextshadow = false,
                ObjectiveAndRespawn_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Trinket_Enabled = true,
                Trinket_BasicPoint = "LEFT",
                Trinket_RelativeTo = "Button",
                Trinket_RelativePoint = "RIGHT",
                Trinket_OffsetX = 1,
                Trinket_Width = 28,
                Trinket_ShowNumbers = true,
                
                Trinket_Cooldown_Fontsize = 12,
                Trinket_Cooldown_Outline = "OUTLINE",
                Trinket_Cooldown_EnableTextshadow = false,
                Trinket_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Racial_Enabled = true,
                Racial_BasicPoint = "LEFT",
                Racial_RelativeTo = "Trinket",
                Racial_RelativePoint = "RIGHT",
                Racial_OffsetX = 2,
                Racial_Width = 28,
                Racial_ShowNumbers = true,
                
                Racial_Cooldown_Fontsize = 12,
                Racial_Cooldown_Outline = "OUTLINE",
                Racial_Cooldown_EnableTextshadow = false,
                Racial_Cooldown_TextShadowcolor = {0, 0, 0, 1},

                RacialFiltering_Enabled = false,
                RacialFiltering_Filterlist = {}, --key = spellID, value = spellName or false
                
                Notifications_Enabled = true,
                -- PositiveSound = [[Interface\AddOns\WeakAuras\Media\Sounds\BatmanPunch.ogg]],
                -- NegativeSound = [[Sound\Interface\UI_BattlegroundCountdown_Timer.ogg]],
            },
            ["40"] = {
                Enabled = true,
                
                Name_Fontsize = 13,
                Name_Outline = "",
                Name_Textcolor = {1, 1, 1, 1}, 
                Name_EnableTextshadow = true,
                Name_TextShadowcolor = {0, 0, 0, 1},
                
                Position_X = false,
                Position_Y = false,
                BarWidth = 220,
                BarHeight = 28,
                BarVerticalGrowdirection = "downwards",
                BarVerticalSpacing = 1,
                BarColumns = 1,
                BarHorizontalGrowdirection = "rightwards",
                BarHorizontalSpacing = 100,
                
                HealthBar_Texture = 'UI-StatusBar',
                HealthBar_Background = {0, 0, 0, 0.66},
                
                PowerBar_Enabled = false,
                PowerBar_Height = 4,
                PowerBar_Texture = 'UI-StatusBar',
                PowerBar_Background = {0, 0, 0, 0.66},
                
                
                RoleIcon_Enabled = true,
                RoleIcon_Size = 13,
                RoleIcon_VerticalPosition = 2,
                
                PlayerCount_Enabled = true,
                PlayerCount_Fontsize = 14,
                PlayerCount_Outline = "OUTLINE",
                PlayerCount_Textcolor = {1, 1, 1, 1},
                PlayerCount_EnableTextshadow = false,
                PlayerCount_TextShadowcolor = {0, 0, 0, 1},
                
                Framescale = 1,
                
                Spec_Enabled = true,
                Spec_Width = 36,
                
                Spec_AuraDisplay_Enabled = true,
                Spec_AuraDisplay_ShowNumbers = true,
                
                Spec_AuraDisplay_Cooldown_Fontsize = 12,
                Spec_AuraDisplay_Cooldown_Outline = "OUTLINE",
                Spec_AuraDisplay_Cooldown_EnableTextshadow = false,
                Spec_AuraDisplay_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                
                SymbolicTargetindicator_Enabled = true,
                
                NumericTargetindicator_Enabled = true,
                NumericTargetindicator_Fontsize = 18,
                NumericTargetindicator_Outline = "",
                NumericTargetindicator_Textcolor = {1, 1, 1, 1},
                NumericTargetindicator_EnableTextshadow = false,
                NumericTargetindicator_TextShadowcolor = {0, 0, 0, 1},
                
                DrTracking_Enabled = true,
                DrTracking_HorizontalSpacing = 1,
                DrTracking_GrowDirection = "leftwards",
                DrTracking_Container_Color = {0, 0, 1, 1},
                DrTracking_Container_BorderThickness = 1,
                DrTracking_Container_BasicPoint = "RIGHT",
                DrTracking_Container_RelativeTo = "Button",
                DrTracking_Container_RelativePoint = "Left",
                DrTracking_Container_OffsetX = 1,
                DrTracking_DisplayType = "Countdowntext",
                
                DrTracking_ShowNumbers = true,
                
                DrTracking_Cooldown_Fontsize = 12,
                DrTracking_Cooldown_Outline = "OUTLINE",
                DrTracking_Cooldown_EnableTextshadow = false,
                DrTracking_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                DrTrackingFiltering_Enabled = false,
                DrTrackingFiltering_Filterlist = {},
                
                
                Auras_Enabled = true,
                Auras_ShowTooltips = false,
                
                Auras_Buffs_Enabled = true,
                Auras_Buffs_Size = 15,
                Auras_Buffs_HorizontalGrowDirection = "leftwards",
                Auras_Buffs_HorizontalSpacing = 1,
                Auras_Buffs_VerticalGrowdirection = "upwards",
                Auras_Buffs_VerticalSpacing = 1,
                Auras_Buffs_IconsPerRow = 8,
                Auras_Buffs_Container_Point = "BOTTOMRIGHT",
                Auras_Buffs_Container_RelativeTo = "Button",
                Auras_Buffs_Container_RelativePoint = "BOTTOMLEFT",
                Auras_Buffs_Container_OffsetX = 2,
                Auras_Buffs_Container_OffsetY = 0,
                
                Auras_Buffs_Fontsize = 12,
                Auras_Buffs_Outline = "OUTLINE",
                Auras_Buffs_Textcolor = {1, 1, 1, 1},
                Auras_Buffs_EnableTextshadow = true,
                Auras_Buffs_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Buffs_ShowNumbers = true,
                
                Auras_Buffs_Cooldown_Fontsize = 12,
                Auras_Buffs_Cooldown_Outline = "OUTLINE",
                Auras_Buffs_Cooldown_EnableTextshadow = false,
                Auras_Buffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Buffs_Filtering_Enabled = true,
                Auras_Buffs_OnlyShowMine = true,
                Auras_Buffs_SpellIDFiltering_Enabled = false,
                Auras_Buffs_SpellIDFiltering_Filterlist = {},
                
                Auras_Debuffs_Enabled = true,
                Auras_Debuffs_Size = 15,
                Auras_Debuffs_HorizontalGrowDirection = "leftwards",
                Auras_Debuffs_HorizontalSpacing = 1,
                Auras_Debuffs_VerticalGrowdirection = "upwards",
                Auras_Debuffs_VerticalSpacing = 1,
                Auras_Debuffs_IconsPerRow = 8,
                Auras_Debuffs_Container_Point = "BOTTOMRIGHT",
                Auras_Debuffs_Container_RelativeTo = "BuffContainer",
                Auras_Debuffs_Container_RelativePoint = "BOTTOMLEFT",
                Auras_Debuffs_Container_OffsetX = 2,
                Auras_Debuffs_Container_OffsetY = 0,
                
                Auras_Debuffs_Coloring_Enabled = true,
                Auras_Debuffs_DisplayType = "Frame",
                Auras_Debuffs_Fontsize = 12,
                Auras_Debuffs_Outline = "OUTLINE",
                Auras_Debuffs_Textcolor = {1, 1, 1, 1},
                Auras_Debuffs_EnableTextshadow = true,
                Auras_Debuffs_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Debuffs_ShowNumbers = true,
                
                Auras_Debuffs_Cooldown_Fontsize = 12,
                Auras_Debuffs_Cooldown_Outline = "OUTLINE",
                Auras_Debuffs_Cooldown_EnableTextshadow = false,
                Auras_Debuffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Debuffs_Filtering_Enabled = true,
                Auras_Debuffs_OnlyShowMine = true,
                Auras_Debuffs_DebuffTypeFiltering_Enabled = true,
                Auras_Debuffs_DebuffTypeFiltering_Filterlist = {},
                Auras_Debuffs_SpellIDFiltering_Enabled = false,
                Auras_Debuffs_SpellIDFiltering_Filterlist = {},
                
                Trinket_Enabled = true,
                Trinket_BasicPoint = "LEFT",
                Trinket_RelativeTo = "Button",
                Trinket_RelativePoint = "RIGHT",
                Trinket_OffsetX = 1,
                Trinket_Width = 28,
                Trinket_ShowNumbers = true,
                
                Trinket_Cooldown_Fontsize = 12,
                Trinket_Cooldown_Outline = "OUTLINE",
                Trinket_Cooldown_EnableTextshadow = false,
                Trinket_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Racial_Enabled = true,
                Racial_BasicPoint = "LEFT",
                Racial_RelativeTo = "Trinket",
                Racial_RelativePoint = "RIGHT",
                Racial_OffsetX = 1,
                Racial_Width = 28,
                Racial_ShowNumbers = true,
                
                Racial_Cooldown_Fontsize = 12,
                Racial_Cooldown_Outline = "OUTLINE",
                Racial_Cooldown_EnableTextshadow = false,
                Racial_Cooldown_TextShadowcolor = {0, 0, 0, 1},

                RacialFiltering_Enabled = false,
                RacialFiltering_Filterlist = {}, --key = spellID, value = spellName or false
            }
            
        },
        Allies = {
            Enabled = true,
            
            ShowRealmnames = true,
            ConvertCyrillic = true,
            LevelText_Enabled = false,
            LevelText_OnlyShowIfNotMaxLevel = true,
            LevelText_Fontsize = 18,
            LevelText_Outline = "",
            LevelText_Textcolor = {1, 1, 1, 1},
            LevelText_EnableTextshadow = false,
            LevelText_TextShadowcolor = {0, 0, 0, 1},
            
            RangeIndicator_Enabled = true,
            RangeIndicator_Range = 34471,
            RangeIndicator_Alpha = 0.55,
            RangeIndicator_Everything = false,
            RangeIndicator_Frames = {},
        
            LeftButtonType = "Target",
            LeftButtonValue = "",
            RightButtonType = "Focus",
            RightButtonValue = "",
            MiddleButtonType = "Custom",
            MiddleButtonValue = "",
            
            ["15"] = {
                Enabled = true,
            
                Name_Fontsize = 13,
                Name_Outline = "",
                Name_Textcolor = {1, 1, 1, 1}, 
                Name_EnableTextshadow = true,
                Name_TextShadowcolor = {0, 0, 0, 1},
                
                Position_X = false,
                Position_Y = false,
                BarWidth = 220,
                BarHeight = 28,
                BarVerticalGrowdirection = "downwards",
                BarVerticalSpacing = 1,
                BarColumns = 1,
                BarHorizontalGrowdirection = "rightwards",
                BarHorizontalSpacing = 100,
                
                HealthBar_Texture = 'UI-StatusBar',
                HealthBar_Background = {0, 0, 0, 0.66},
                
                PowerBar_Enabled = false,
                PowerBar_Height = 4,
                PowerBar_Texture = 'UI-StatusBar',
                PowerBar_Background = {0, 0, 0, 0.66},
                
                
                RoleIcon_Enabled = true,
                RoleIcon_Size = 13,
                RoleIcon_VerticalPosition = 2,
                
                PlayerCount_Enabled = true,
                PlayerCount_Fontsize = 14,
                PlayerCount_Outline = "OUTLINE",
                PlayerCount_Textcolor = {1, 1, 1, 1},
                PlayerCount_EnableTextshadow = false,
                PlayerCount_TextShadowcolor = {0, 0, 0, 1},
                
                Framescale = 1,
                
                Spec_Enabled = true,
                Spec_Width = 36,
                
                Spec_AuraDisplay_Enabled = true,
                Spec_AuraDisplay_ShowNumbers = true,
                
                Spec_AuraDisplay_Cooldown_Fontsize = 12,
                Spec_AuraDisplay_Cooldown_Outline = "OUTLINE",
                Spec_AuraDisplay_Cooldown_EnableTextshadow = false,
                Spec_AuraDisplay_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                
                SymbolicTargetindicator_Enabled = true,
                
                NumericTargetindicator_Enabled = true,
                NumericTargetindicator_Fontsize = 18,
                NumericTargetindicator_Outline = "",
                NumericTargetindicator_Textcolor = {1, 1, 1, 1},
                NumericTargetindicator_EnableTextshadow = false,
                NumericTargetindicator_TextShadowcolor = {0, 0, 0, 1},
                
                DrTracking_Enabled = true,
                DrTracking_HorizontalSpacing = 1,
                DrTracking_GrowDirection = "rightwards",
                DrTracking_Container_Color = {0, 0, 1, 1},
                DrTracking_Container_BorderThickness = 1,
                DrTracking_Container_BasicPoint = "LEFT",
                DrTracking_Container_RelativeTo = "Button",
                DrTracking_Container_RelativePoint = "RIGHT",
                DrTracking_Container_OffsetX = 1,
                DrTracking_DisplayType = "Countdowntext",
                
                DrTracking_ShowNumbers = true,
                
                DrTracking_Cooldown_Fontsize = 12,
                DrTracking_Cooldown_Outline = "OUTLINE",
                DrTracking_Cooldown_EnableTextshadow = false,
                DrTracking_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                DrTrackingFiltering_Enabled = false,
                DrTrackingFiltering_Filterlist = {},
                
                
                Auras_Enabled = false,
                Auras_ShowTooltips = false,
                
                Auras_Buffs_Enabled = false,
                Auras_Buffs_Size = 15,
                Auras_Buffs_HorizontalGrowDirection = "leftwards",
                Auras_Buffs_HorizontalSpacing = 1,
                Auras_Buffs_VerticalGrowdirection = "upwards",
                Auras_Buffs_VerticalSpacing = 1,
                Auras_Buffs_IconsPerRow = 8,
                Auras_Buffs_Container_Point = "BOTTOMRIGHT",
                Auras_Buffs_Container_RelativeTo = "Button",
                Auras_Buffs_Container_RelativePoint = "BOTTOMLEFT",
                Auras_Buffs_Container_OffsetX = 2,
                Auras_Buffs_Container_OffsetY = 0,
                
                Auras_Buffs_Fontsize = 12,
                Auras_Buffs_Outline = "OUTLINE",
                Auras_Buffs_Textcolor = {1, 1, 1, 1},
                Auras_Buffs_EnableTextshadow = true,
                Auras_Buffs_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Buffs_ShowNumbers = true,
                
                Auras_Buffs_Cooldown_Fontsize = 12,
                Auras_Buffs_Cooldown_Outline = "OUTLINE",
                Auras_Buffs_Cooldown_EnableTextshadow = false,
                Auras_Buffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Buffs_Filtering_Enabled = true,
                Auras_Buffs_OnlyShowMine = true,
                Auras_Buffs_SpellIDFiltering_Enabled = false,
                Auras_Buffs_SpellIDFiltering_Filterlist = {},
                
                Auras_Debuffs_Enabled = true,
                Auras_Debuffs_Size = 15,
                Auras_Debuffs_HorizontalGrowDirection = "leftwards",
                Auras_Debuffs_HorizontalSpacing = 1,
                Auras_Debuffs_VerticalGrowdirection = "upwards",
                Auras_Debuffs_VerticalSpacing = 1,
                Auras_Debuffs_IconsPerRow = 8,
                Auras_Debuffs_Container_Point = "BOTTOMRIGHT",
                Auras_Debuffs_Container_RelativeTo = "BuffContainer",
                Auras_Debuffs_Container_RelativePoint = "BOTTOMLEFT",
                Auras_Debuffs_Container_OffsetX = 2,
                Auras_Debuffs_Container_OffsetY = 0,
                
                Auras_Debuffs_Coloring_Enabled = true,
                Auras_Debuffs_DisplayType = "Frame",
                Auras_Debuffs_Fontsize = 12,
                Auras_Debuffs_Outline = "OUTLINE",
                Auras_Debuffs_Textcolor = {1, 1, 1, 1},
                Auras_Debuffs_EnableTextshadow = true,
                Auras_Debuffs_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Debuffs_ShowNumbers = true,
                
                Auras_Debuffs_Cooldown_Fontsize = 12,
                Auras_Debuffs_Cooldown_Outline = "OUTLINE",
                Auras_Debuffs_Cooldown_EnableTextshadow = false,
                Auras_Debuffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Debuffs_Filtering_Enabled = true,
                Auras_Debuffs_OnlyShowMine = true,
                Auras_Debuffs_DebuffTypeFiltering_Enabled = true,
                Auras_Debuffs_DebuffTypeFiltering_Filterlist = {},
                Auras_Debuffs_SpellIDFiltering_Enabled = false,
                Auras_Debuffs_SpellIDFiltering_Filterlist = {},

                ObjectiveAndRespawn_ObjectiveEnabled = true,
                ObjectiveAndRespawn_Width = 36,
                ObjectiveAndRespawn_BasicPoint = "RIGHT",
                ObjectiveAndRespawn_RelativeTo = "NumericTargetindicator",
                ObjectiveAndRespawn_RelativePoint = "LEFT",
                ObjectiveAndRespawn_OffsetX = -2,
                
                ObjectiveAndRespawn_Width = 36,
                ObjectiveAndRespawn_Position = "LEFT",
                
                ObjectiveAndRespawn_RespawnEnabled = true,
                
                ObjectiveAndRespawn_Fontsize = 17,
                ObjectiveAndRespawn_Outline = "THICKOUTLINE",
                ObjectiveAndRespawn_Textcolor = {1, 1, 1, 1},
                ObjectiveAndRespawn_EnableTextshadow = false,
                ObjectiveAndRespawn_TextShadowcolor = {0, 0, 0, 1},
                
                ObjectiveAndRespawn_ShowNumbers = true,
                
                ObjectiveAndRespawn_Cooldown_Fontsize = 12,
                ObjectiveAndRespawn_Cooldown_Outline = "OUTLINE",
                ObjectiveAndRespawn_Cooldown_EnableTextshadow = false,
                ObjectiveAndRespawn_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Trinket_Enabled = true,
                Trinket_BasicPoint = "RIGHT",
                Trinket_RelativeTo = "Button",
                Trinket_RelativePoint = "LEFT",
                Trinket_OffsetX = -1,
                Trinket_Width = 28,
                Trinket_ShowNumbers = true,
                
                Trinket_Cooldown_Fontsize = 12,
                Trinket_Cooldown_Outline = "OUTLINE",
                Trinket_Cooldown_EnableTextshadow = false,
                Trinket_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Racial_Enabled = true,
                Racial_BasicPoint = "RIGHT",
                Racial_RelativeTo = "Trinket",
                Racial_RelativePoint = "LEFT",
                Racial_OffsetX = 1,
                Racial_Width = 28,
                Racial_ShowNumbers = true,
                
                Racial_Cooldown_Fontsize = 12,
                Racial_Cooldown_Outline = "OUTLINE",
                Racial_Cooldown_EnableTextshadow = false,
                Racial_Cooldown_TextShadowcolor = {0, 0, 0, 1},

                RacialFiltering_Enabled = false,
                RacialFiltering_Filterlist = {}, --key = spellID, value = spellName or false
                
                Notifications_Enabled = true,
                -- PositiveSound = [[Interface\AddOns\WeakAuras\Media\Sounds\BatmanPunch.ogg]],
                -- NegativeSound = [[Sound\Interface\UI_BattlegroundCountdown_Timer.ogg]],
            },
            ["40"] = {
                Enabled = true,
            
                Name_Fontsize = 13,
                Name_Outline = "",
                Name_Textcolor = {1, 1, 1, 1}, 
                Name_EnableTextshadow = true,
                Name_TextShadowcolor = {0, 0, 0, 1},
                
                Position_X = false,
                Position_Y = false,
                BarWidth = 220,
                BarHeight = 28,
                BarVerticalGrowdirection = "downwards",
                BarVerticalSpacing = 1,
                BarColumns = 1,
                BarHorizontalGrowdirection = "rightwards",
                BarHorizontalSpacing = 100,
                
                HealthBar_Texture = 'UI-StatusBar',
                HealthBar_Background = {0, 0, 0, 0.66},
                
                PowerBar_Enabled = false,
                PowerBar_Height = 4,
                PowerBar_Texture = 'UI-StatusBar',
                PowerBar_Background = {0, 0, 0, 0.66},
                
                
                RoleIcon_Enabled = true,
                RoleIcon_Size = 13,
                RoleIcon_VerticalPosition = 2,
                
                PlayerCount_Enabled = true,
                PlayerCount_Fontsize = 14,
                PlayerCount_Outline = "OUTLINE",
                PlayerCount_Textcolor = {1, 1, 1, 1},
                PlayerCount_EnableTextshadow = false,
                PlayerCount_TextShadowcolor = {0, 0, 0, 1},
                
                Framescale = 1,
                
                Spec_Enabled = true,
                Spec_Width = 36,
                
                Spec_AuraDisplay_Enabled = true,
                Spec_AuraDisplay_ShowNumbers = true,
                
                Spec_AuraDisplay_Cooldown_Fontsize = 12,
                Spec_AuraDisplay_Cooldown_Outline = "OUTLINE",
                Spec_AuraDisplay_Cooldown_EnableTextshadow = false,
                Spec_AuraDisplay_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                
                SymbolicTargetindicator_Enabled = true,
                
                NumericTargetindicator_Enabled = true,
                NumericTargetindicator_Fontsize = 18,
                NumericTargetindicator_Outline = "",
                NumericTargetindicator_Textcolor = {1, 1, 1, 1},
                NumericTargetindicator_EnableTextshadow = false,
                NumericTargetindicator_TextShadowcolor = {0, 0, 0, 1},
                
                DrTracking_Enabled = true,
                DrTracking_HorizontalSpacing = 1,
                DrTracking_GrowDirection = "rightwards",
                DrTracking_Container_Color = {0, 0, 1, 1},
                DrTracking_Container_BorderThickness = 1,
                DrTracking_Container_BasicPoint = "LEFT",
                DrTracking_Container_RelativeTo = "Button",
                DrTracking_Container_RelativePoint = "RIGHT",
                DrTracking_Container_OffsetX = 1,
                DrTracking_DisplayType = "Countdowntext",
                
                DrTracking_ShowNumbers = true,
                
                DrTracking_Cooldown_Fontsize = 12,
                DrTracking_Cooldown_Outline = "OUTLINE",
                DrTracking_Cooldown_EnableTextshadow = false,
                DrTracking_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                DrTrackingFiltering_Enabled = false,
                DrTrackingFiltering_Filterlist = {},
                
                
                Auras_Enabled = false,
                Auras_ShowTooltips = false,
                
                Auras_Buffs_Enabled = true,
                Auras_Buffs_Size = 15,
                Auras_Buffs_HorizontalGrowDirection = "leftwards",
                Auras_Buffs_HorizontalSpacing = 1,
                Auras_Buffs_VerticalGrowdirection = "upwards",
                Auras_Buffs_VerticalSpacing = 1,
                Auras_Buffs_IconsPerRow = 8,
                Auras_Buffs_Container_Point = "BOTTOMRIGHT",
                Auras_Buffs_Container_RelativeTo = "Button",
                Auras_Buffs_Container_RelativePoint = "BOTTOMLEFT",
                Auras_Buffs_Container_OffsetX = 2,
                Auras_Buffs_Container_OffsetY = 0,
                
                Auras_Buffs_Fontsize = 12,
                Auras_Buffs_Outline = "OUTLINE",
                Auras_Buffs_Textcolor = {1, 1, 1, 1},
                Auras_Buffs_EnableTextshadow = true,
                Auras_Buffs_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Buffs_ShowNumbers = true,
                
                Auras_Buffs_Cooldown_Fontsize = 12,
                Auras_Buffs_Cooldown_Outline = "OUTLINE",
                Auras_Buffs_Cooldown_EnableTextshadow = false,
                Auras_Buffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Buffs_Filtering_Enabled = true,
                Auras_Buffs_OnlyShowMine = true,
                Auras_Buffs_SpellIDFiltering_Enabled = false,
                Auras_Buffs_SpellIDFiltering_Filterlist = {},
                
                Auras_Debuffs_Enabled = true,
                Auras_Debuffs_Size = 15,
                Auras_Debuffs_HorizontalGrowDirection = "leftwards",
                Auras_Debuffs_HorizontalSpacing = 1,
                Auras_Debuffs_VerticalGrowdirection = "upwards",
                Auras_Debuffs_VerticalSpacing = 1,
                Auras_Debuffs_IconsPerRow = 8,
                Auras_Debuffs_Container_Point = "BOTTOMRIGHT",
                Auras_Debuffs_Container_RelativeTo = "BuffContainer",
                Auras_Debuffs_Container_RelativePoint = "BOTTOMLEFT",
                Auras_Debuffs_Container_OffsetX = 2,
                Auras_Debuffs_Container_OffsetY = 0,
                
                Auras_Debuffs_Coloring_Enabled = true,
                Auras_Debuffs_DisplayType = "Frame",
                Auras_Debuffs_Fontsize = 12,
                Auras_Debuffs_Outline = "OUTLINE",
                Auras_Debuffs_Textcolor = {1, 1, 1, 1},
                Auras_Debuffs_EnableTextshadow = true,
                Auras_Debuffs_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Debuffs_ShowNumbers = true,
                
                Auras_Debuffs_Cooldown_Fontsize = 12,
                Auras_Debuffs_Cooldown_Outline = "OUTLINE",
                Auras_Debuffs_Cooldown_EnableTextshadow = false,
                Auras_Debuffs_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Auras_Debuffs_Filtering_Enabled = true,
                Auras_Debuffs_OnlyShowMine = true,
                Auras_Debuffs_DebuffTypeFiltering_Enabled = true,
                Auras_Debuffs_DebuffTypeFiltering_Filterlist = {},
                Auras_Debuffs_SpellIDFiltering_Enabled = false,
                Auras_Debuffs_SpellIDFiltering_Filterlist = {},
                
                Trinket_Enabled = true,
                Trinket_BasicPoint = "RIGHT",
                Trinket_RelativeTo = "Button",
                Trinket_RelativePoint = "LEFT",
                Trinket_OffsetX = 1,
                Trinket_Width = 28,
                Trinket_ShowNumbers = true,
                
                Trinket_Cooldown_Fontsize = 12,
                Trinket_Cooldown_Outline = "OUTLINE",
                Trinket_Cooldown_EnableTextshadow = false,
                Trinket_Cooldown_TextShadowcolor = {0, 0, 0, 1},
                
                Racial_Enabled = true,
                Racial_BasicPoint = "RIGHT",
                Racial_RelativeTo = "Trinket",
                Racial_RelativePoint = "LEFT",
                Racial_OffsetX = 1,
                Racial_Width = 28,
                Racial_ShowNumbers = true,
                
                Racial_Cooldown_Fontsize = 12,
                Racial_Cooldown_Outline = "OUTLINE",
                Racial_Cooldown_EnableTextshadow = false,
                Racial_Cooldown_TextShadowcolor = {0, 0, 0, 1},

                RacialFiltering_Enabled = false,
                RacialFiltering_Filterlist = {}, --key = spellID, value = spellName or false
            }
            
        }
        
    }
}