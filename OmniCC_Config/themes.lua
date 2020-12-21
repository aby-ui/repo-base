local _, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale('OmniCC', true)
local LSM = LibStub('LibSharedMedia-3.0')
local OmniCC = _G.OmniCC

local function getEffectValues()
    local items = {}

    for id, effect in OmniCC.FX:All() do
        items[id] = effect.name or id
    end

    return items
end

local function createStateOptionsForTheme(theme, id, order)
    local group = {
        type = 'group',
        name = L.ColorAndScale,
        desc = L.ColorAndScaleDesc,
        order = order,
        args = {}
    }

    for i, state in ipairs {'soon', 'seconds', 'minutes', 'hours', 'charging', 'controlled'} do
        group.args[state] = {
            type = 'group',
            name = L['State_' .. state],
            inline = true,
            order = 100 + i,
            args = {
                color = {
                    type = 'color',
                    name = L.TextColor,
                    order = 1,
                    hasAlpha = true,
                    get = function()
                        local style = theme.textStyles[state]
                        return style.r, style.g, style.b, style.a
                    end,
                    set = function(_, r, g, b, a)
                        local style = theme.textStyles[state]

                        style.r = r
                        style.g = g
                        style.b = b
                        style.a = a

                        OmniCC.Display:ForAll('UpdateCooldownTextPositionSizeAndColor')
                    end
                },
                scale = {
                    order = 2,
                    type = 'range',
                    name = L.TextSize,
                    isPercent = true,
                    softMin = 0,
                    softMax = 2,
                    get = function()
                        return theme.textStyles[state].scale
                    end,
                    set = function(_, val)
                        theme.textStyles[state].scale = val
                        OmniCC.Display:ForAll('UpdateCooldownTextPositionSizeAndColor')
                    end
                }
            }
        }
    end

    return group
end

local function createTextOptionsForTheme(theme, id, order)
    return {
        type = 'group',
        name = L.Typography,
        desc = L.TypographyDesc,
        order = order,
        args = {
            font = {
                type = 'group',
                name = L.TextFont,
                order = 0,
                inline = true,
                args = {
                    face = {
                        type = 'select',
                        name = L.FontFace,
                        order = 1,
                        width = 1.5,
                        dialogControl = 'LSM30_Font', --Select your widget here
                        values = LSM:HashTable('font'), -- pull in your font list from LSM
                        get = function()
                            for key, font in pairs(LSM:HashTable('font')) do
                                if theme.fontFace == font then
                                    return key
                                end
                            end
                        end,
                        set = function(_, key)
                            theme.fontFace = LSM:Fetch('font', key)
                            OmniCC.Display:ForAll('UpdateCooldownTextFont')
                        end
                    },
                    size = {
                        type = 'range',
                        name = L.FontSize,
                        order = 3,
                        width = 'full',
                        min = 8,
                        softMax = 36,
                        step = 1,
                        get = function()
                            return theme.fontSize
                        end,
                        set = function(_, val)
                            theme.fontSize = val
                            OmniCC.Display:ForAll('UpdateCooldownTextFont')
                        end
                    },
                    outline = {
                        type = 'select',
                        name = L.FontOutline,
                        order = 2,
                        get = function()
                            return theme.fontOutline
                        end,
                        set = function(_, val)
                            theme.fontOutline = val
                            OmniCC.Display:ForAll('UpdateCooldownTextFont')
                        end,
                        values = {
                            NONE = L.Outline_NONE,
                            OUTLINE = L.Outline_OUTLINE,
                            THICKOUTLINE = L.Outline_THICKOUTLINE,
                            OUTLINEMONOCHROME = L.Outline_OUTLINEMONOCHROME
                        }
                    }
                }
            },
            shadow = {
                type = 'group',
                name = L.TextShadow,
                inline = true,
                order = 10,
                args = {
                    color = {
                        type = 'color',
                        name = L.TextShadowColor,
                        order = 1,
                        width = 1.5,
                        hasAlpha = true,
                        get = function()
                            local shadow = theme.fontShadow
                            return shadow.r, shadow.g, shadow.b, shadow.a
                        end,
                        set = function(_, r, g, b, a)
                            local shadow = theme.fontShadow

                            shadow.r = r
                            shadow.g = g
                            shadow.b = b
                            shadow.a = a

                            OmniCC.Display:ForAll('UpdateCooldownTextFont')
                        end
                    },
                    x = {
                        order = 2,
                        type = 'range',
                        name = L.HorizontalOffset,
                        softMin = -18,
                        softMax = 18,
                        step = 1,
                        get = function()
                            return theme.fontShadow.x
                        end,
                        set = function(_, val)
                            theme.fontShadow.x = val
                            OmniCC.Display:ForAll('UpdateCooldownTextFont')
                        end
                    },
                    y = {
                        order = 2,
                        type = 'range',
                        name = L.VerticalOffset,
                        softMin = -18,
                        softMax = 18,
                        step = 1,
                        get = function()
                            return -theme.fontShadow.y
                        end,
                        set = function(_, val)
                            theme.fontShadow.y = -val
                            OmniCC.Display:ForAll('UpdateCooldownTextFont')
                        end
                    }
                }
            },
            position = {
                type = 'group',
                name = L.TextPosition,
                inline = true,
                order = 20,
                args = {
                    anchor = {
                        type = 'select',
                        width = 1.5,
                        name = L.Anchor,
                        order = 0,
                        get = function()
                            return theme.anchor
                        end,
                        set = function(_, val)
                            theme.anchor = val
                            OmniCC.Display:ForAll('UpdateCooldownTextPositionSizeAndColor')
                        end,
                        values = {
                            TOPLEFT = L.Anchor_TOPLEFT,
                            TOP = L.Anchor_TOP,
                            TOPRIGHT = L.Anchor_TOPRIGHT,
                            LEFT = L.Anchor_LEFT,
                            CENTER = L.Anchor_CENTER,
                            RIGHT = L.Anchor_RIGHT,
                            BOTTOMLEFT = L.Anchor_BOTTOMLEFT,
                            BOTTOM = L.Anchor_BOTTOM,
                            BOTTOMRIGHT = L.Anchor_BOTTOMRIGHT
                        }
                    },
                    x = {
                        order = 2,
                        type = 'range',
                        name = L.HorizontalOffset,
                        softMin = -18,
                        softMax = 18,
                        step = 1,
                        get = function()
                            return theme.xOff
                        end,
                        set = function(_, val)
                            theme.xOff = val
                            OmniCC.Display:ForAll('UpdateCooldownTextPositionSizeAndColor')
                        end
                    },
                    y = {
                        order = 3,
                        type = 'range',
                        name = L.VerticalOffset,
                        softMin = -18,
                        softMax = 18,
                        step = 1,
                        get = function()
                            return -theme.yOff
                        end,
                        set = function(_, val)
                            theme.yOff = -val
                            OmniCC.Display:ForAll('UpdateCooldownTextPositionSizeAndColor')
                        end
                    }
                }
            }
        }
    }
end

local function addThemeOptions(owner, theme, id)
    local key = 'theme_' .. id

    owner.args[key] = {
        type = 'group',
        name = theme.name or id,
        order = id == DEFAULT and 0 or 200,
        childGroups = 'tab',
        args = {
            display = {
                type = 'group',
                name = L.Display,
                desc = L.DisplayGroupDesc,
                order = 100,
                args = {
                    cooldownText = {
                        type = 'group',
                        name = L.CooldownText,
                        inline = true,
                        order = 100,
                        args = {
                            enable = {
                                type = 'toggle',
                                name = L.EnableText,
                                desc = L.EnableTextDesc,
                                order = 10,
                                width = 'full',
                                get = function()
                                    return theme.enableText
                                end,
                                set = function(_, enable)
                                    theme.enableText = enable
                                    OmniCC.Cooldown:ForAll('Refresh', true)
                                end
                            },
                            scale = {
                                type = 'toggle',
                                name = L.ScaleText,
                                -- desc = L.ScaleTextDesc,
                                order = 11,
                                width = 'full',
                                get = function()
                                    return theme.scaleText
                                end,
                                set = function(_, scale)
                                    theme.scaleText = scale
                                    OmniCC.Display:ForActive('UpdateSize')
                                end
                            },
                            minSize = {
                                type = 'range',
                                name = L.MinSize,
                                desc = L.MinSizeDesc,
                                width = 'full',
                                order = 30,
                                min = 0,
                                softMax = 200,
                                bigStep = 5,
                                get = function()
                                    return Round(theme.minSize * 100)
                                end,
                                set = function(_, val)
                                    theme.minSize = val / 100
                                    OmniCC.Display:ForAll('UpdateCooldownTextPositionSizeAndColor')
                                end
                            },
                            minDuration = {
                                type = 'range',
                                name = L.MinDuration,
                                desc = L.MinDurationDesc,
                                width = 'full',
                                order = 30,
                                min = 0,
                                softMax = 60,
                                step = 1,
                                get = function()
                                    return theme.minDuration
                                end,
                                set = function(_, val)
                                    theme.minDuration = val
                                    OmniCC.Cooldown:ForAll('Refresh', true)
                                end
                            },
                            mmssThreshold = {
                                type = 'range',
                                name = L.MMSSDuration,
                                desc = L.MMSSDurationDesc,
                                width = 'full',
                                order = 32,
                                min = 0,
                                softMax = 600,
                                step = 1,
                                get = function()
                                    return theme.mmSSDuration
                                end,
                                set = function(_, val)
                                    theme.mmSSDuration = val
                                    OmniCC.Timer:ForActive('Update')
                                end
                            },
                            tenthsThreshold = {
                                type = 'range',
                                name = L.TenthsDuration,
                                desc = L.TenthsDurationDesc,
                                width = 'full',
                                order = 33,
                                min = 0,
                                softMax = 60,
                                step = 1,
                                get = function()
                                    return theme.tenthsDuration
                                end,
                                set = function(_, val)
                                    theme.tenthsDuration = val
                                    OmniCC.Timer:ForActive('Update')
                                end
                            },
                            timerOffset = {
                                type = 'range',
                                name = L.TimerOffset,
                                desc = L.TimerOffsetDesc,
                                width = 'full',
                                order = 40,
                                min = 0,
                                softMax = 3000,
                                step = 100,
                                get = function()
                                    return theme.timerOffset
                                end,
                                set = function(_, val)
                                    theme.timerOffset = val
                                    OmniCC.Cooldown:ForAll('Refresh', true)
                                end
                            }
                        }
                    },
                    finishEffect = {
                        type = 'group',
                        name = L.FinishEffects,
                        order = 200,
                        inline = true,
                        args = {
                            effect = {
                                type = 'select',
                                name = L.FinishEffect,
                                desc = L.FinishEffectDesc,
                                order = 13,
                                get = function()
                                    return theme.effect
                                end,
                                set = function(_, val)
                                    theme.effect = val
                                end,
                                values = getEffectValues
                            },
                            minDuration = {
                                type = 'range',
                                name = L.MinEffectDuration,
                                desc = L.MinEffectDurationDesc,
                                width = 'full',
                                min = 0,
                                softMax = 600,
                                step = 5,
                                get = function()
                                    return theme.minEffectDuration
                                end,
                                set = function(_, val)
                                    theme.minEffectDuration = val
                                end
                            }
                        }
                    },
                    drawSwipes = {
                        type = 'toggle',
                        name = L.EnableCooldownSwipes,
                        desc = L.EnableCooldownSwipesDesc,
                        order = 300,
                        width = 'full',
                        get = function()
                            return theme.drawSwipes
                        end,
                        set = function(_, enable)
                            theme.drawSwipes = enable
                            OmniCC.Cooldown:ForAll('UpdateStyle')
                        end
                    }
                }
            },
            text = createTextOptionsForTheme(theme, id, 200),
            state = createStateOptionsForTheme(theme, id, 300),
            preview = {
                type = 'execute',
                order = 9000,
                name = L.Preview,
                func = function()
                    Addon.PreviewDialog:SetTheme(theme)
                end
            },
            remove = {
                type = 'execute',
                order = 9001,
                name = L.ThemeRemove,
                desc = L.ThemeRemoveDesc,
                func = function()
                    if OmniCC:RemoveTheme(id) then
                        owner.args[key] = nil
                    end
                end,
                disabled = function()
                    return theme == OmniCC:GetDefaultTheme()
                end
            }
        }
    }
end

local ThemeOptions = {
    type = 'group',
    name = L.Themes,
    args = {
        description = {
            type = 'description',
            name = L.ThemesDesc,
            order = 0
        }
    }
}

-- generate options
ThemeOptions.args.add = {
    type = 'input',
    order = 100,
    name = L.ThemeAdd,
    desc = L.ThemeAddDesc,
    width = 'double',
    set = function(_, val)
        val = strtrim(val)

        local theme = OmniCC:AddTheme(val)
        if theme then
            addThemeOptions(ThemeOptions, theme, val)
        end
    end,
    validate = function(_, val)
        val = strtrim(val)

        if val == '' then
            return false
        end

        return not OmniCC:HasTheme(val)
    end
}

function Addon:RefreshThemeOptions()
    for key in pairs(ThemeOptions.args) do
        if key:match('^theme_') then
            ThemeOptions.args[key] = nil
        end
    end

    for id, theme in OmniCC:GetThemes() do
        addThemeOptions(ThemeOptions, theme, id)
    end
end

Addon:RefreshThemeOptions()
Addon.ThemeOptions = ThemeOptions
